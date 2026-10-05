@echo off
rem Start the RealPlus MCP bridge with the Node that Codex ships (CODEX_MCP_NODE_PATH), else a system node.
if defined CODEX_MCP_NODE_PATH (
  "%CODEX_MCP_NODE_PATH%" "%~dp0..\server.mjs" %*
) else (
  node "%~dp0..\server.mjs" %*
)
