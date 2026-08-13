# Grok Build
No package. Grok discovers the installed Claude Code plugin (skills, namespaced commands, instruction
files) with zero setup — verified live on 0.2.118: the case-2 fixture loaded the plan skill, resolved
`${CLAUDE_SKILL_DIR}/../../CONVENTIONS.md` from the Claude plugin cache, and kept the
`/co-founder:co-founder-setup` route intact.
Requirement: user must have the Claude Code plugin installed (our recommended flagship path anyway).
Verify: `grok inspect` lists 13 skills under `plugin: co-founder`. Grok releases weekly — re-run the
smoke per release; headless mode was unusable on macOS (TTY errors), use the TUI.
