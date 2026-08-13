# OpenCode (and the npx rail)
Install: `npx skills add machina-exm/co-founder/.agents/skills` — the subpath is REQUIRED; the bare repo
form installs the Claude-only tree (`${CLAUDE_SKILL_DIR}` paths break outside Claude Code).
OpenCode v1.18.11 discovers project `.agents/skills`, `.claude/skills`, `.opencode/skills`; description-based
auto-selection is native. Real directories only — symlinked skill dirs have open discovery bugs.
Gotcha: a GLOBAL skill with the same name shadows a project skill (observed: global `review` shadowed ours).
Debug: `opencode debug skill --print-logs | grep duplicate`.
