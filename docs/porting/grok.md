# Grok Build
Surface: none of our own. Grok discovers the installed Claude Code plugin (skills, namespaced
commands, instruction files) with zero setup.

Install: install the Claude Code plugin, nothing else.
Verify: `grok inspect` prints `Skills (13)` with every entry marked `plugin: co-founder [claude]`.

Verified live on **1.0.3** (2026-08-29): a scratch `HOME` with only the Claude plugin installed
showed all 13 skills, `Plugins (1) co-founder (user, enabled) 13 skills`, and zero marketplaces.

Gotchas:
- `help` and `plan` collide with Grok's builtin `/help` and `/plan`. Grok resolves this itself and
  reports `[collides with /plan → /co-founder:plan]`. Nothing to fix; expect the namespaced form.
- **Marketplace install by name is broken in 1.0.3.** `grok plugin marketplace add
  machina-exm/co-founder` succeeds, but `grok plugin install co-founder@co-founder` fails with
  `No marketplace plugin named "co-founder" in "co-founder"`. Reproduced with a minimal
  two-file marketplace, under both `.claude-plugin/` and `.grok-plugin/`, with `source` written as
  `"./"`, `"."`, and an object — so it is a Grok bug, not a defect in our index.
  Workaround if a standalone install is ever needed: `git clone` the repo, then
  `grok plugin install <path> --trust`. Verified working, reports version 1.0.0.
- Grok releases often. Re-run the smoke per release. Headless mode was unusable on macOS
  (TTY errors) as of the 0.2.x line; use the TUI.
