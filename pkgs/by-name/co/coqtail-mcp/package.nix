{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "coqtail-mcp";
  version = "98fb9672522eb1221e41018f452963ebcb7bef32";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "park-sunho";
    repo = "Coqtail-mcp";
    rev = finalAttrs.version;
    hash = "sha256-3VDlK7qLBRwikS+E34f6QhLrPYIGYXCaq3yAzkd9MQk=";
  };

  # coqtail_lib is already included by the package root; force-including it
  # adds duplicate wheel entries that python-installer rejects.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '[tool.hatch.build.targets.wheel.force-include]' "" \
      --replace-fail '"src/coqtail_mcp/coqtail_lib" = "coqtail_mcp/coqtail_lib"' ""
  '';

  build-system = [
    python3Packages.hatchling
  ];

  dependencies = [
    python3Packages.mcp
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
  ];

  pythonImportsCheck = [
    "coqtail_mcp"
    "coqtail_mcp.server"
  ];

  meta = {
    description = "MCP server for Rocq/Coq proof-assistant sessions using Coqtail";
    homepage = "https://github.com/park-sunho/Coqtail-mcp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ damhiya ];
    mainProgram = "coqtail-mcp";
    platforms = lib.platforms.unix;
  };
})
