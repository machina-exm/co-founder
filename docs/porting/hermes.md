# Hermes Agent
Surface: `dist/hermes/` → synced to the satellite repo `machina-exm/co-founder-hermes` (skills under `skills/`).
Install: local one-paste (see satellite README). `hermes skills install` is NOT available: the Nous hub
scanner marks any skill referencing AGENTS.md/CLAUDE.md as dangerous (rule `agent_config_mod`) and blocks
non-builtin installs with no override. Writing the charter is this product's job, so the supported path is
Hermes' local-skill mechanism. Do not reword skills to dodge the scanner.
Specifics handled by the generator: descriptions ≤57 chars (routing index truncates at 60; hand leads in
`tools/gen/overrides/hermes-descriptions.yml`), full description moved to a `## When to use` body section,
`plan` renamed `plan-initiative` (builtin collision; guard list `tools/gen/hermes-builtins.txt`), every
bundled file cited in plain `references/...` form (the fetcher only bundles paths its regex can see), no
parent-path escapes anywhere.
