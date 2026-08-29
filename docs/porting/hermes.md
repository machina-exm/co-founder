# Hermes Agent
Surface: `dist/hermes/` in this repository, served directly. There is no satellite repo — the
`machina-exm/co-founder-hermes` mirror was retired on 2026-08-29 once this repository went public,
because it duplicated `dist/hermes/` byte for byte and added a second thing to keep in sync.

Install: local one-paste, copying `dist/hermes/` into the founder's Hermes skills folder.

```bash
git clone --depth 1 https://github.com/machina-exm/co-founder /tmp/cf-hermes && mkdir -p ~/.hermes/skills/business && cp -R /tmp/cf-hermes/dist/hermes/* ~/.hermes/skills/business/ && rm -rf /tmp/cf-hermes && hermes skills list | grep business
```

`hermes skills install` is NOT available: the Nous hub scanner marks any skill referencing
AGENTS.md/CLAUDE.md as dangerous (rule `agent_config_mod`) and blocks non-builtin installs with no
override. Writing the charter is this product's job, so the supported path is Hermes' local-skill
mechanism. Do not reword skills to dodge the scanner.

Specifics handled by the generator: descriptions ≤57 chars (routing index truncates at 60; hand leads in
`tools/gen/overrides/hermes-descriptions.yml`), full description moved to a `## When to use` body section,
`plan` renamed `plan-initiative` (builtin collision; guard list `tools/gen/hermes-builtins.txt`), every
bundled file cited in plain `references/...` form (the fetcher only bundles paths its regex can see), no
parent-path escapes anywhere.

Verification status: payload identity re-checked 2026-08-29 — a fresh public clone's `dist/hermes/`
matches the tree here byte for byte. The last live behavior smoke was on **v0.19.1**; the CLI on the
maintainer machine is now **v0.20.6**, so the 5-case smoke is due on the next Hermes-affecting change.
