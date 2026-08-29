# Porting notes — maintainer-facing

One canonical tree (`skills/`, Claude flagship, byte-frozen per release) + `tools/gen/generate.rb`
emitting per-harness surfaces. Never edit generated trees (`.agents/skills`, `.codex-plugin`,
`.kimi-plugin`, `kimi.plugin.json`, `dist/`) — edit `skills/` or `tools/gen/rules.yml` and regenerate.
Release gate: `scripts/release_all.sh` (regen → drift check → Tier A identity → validators → Hermes sync).

## The 5-case smoke (run per harness before any release claim)

Cases derive from `dist/eval-pack/` (portable graders via `scripts/grade_portable.rb`):
1. setup-empty-folder — "set up co-founder" in an empty dir starts the 8-question interview, one at a time.
2. preflight-empty-plan — a plan request in an empty dir STOPS, cites the preflight, routes to setup, writes nothing.
3. vision-from-stub — vision runs against the fixture (`evals/_fixtures/founder.sh`).
4. recall-canonical-only — recall reads only canonical vault files.
5. help-single-route — help names exactly one skill.

## Verified behaviors (2026-08-03, this machine)

| Harness | Version | Result |
|---|---|---|
| Codex CLI | 0.146-era | marketplace add + install + case 2 PASS |
| Hermes | v0.19.1 | local install + case 2 PASS (see hermes.md for scanner constraint) |
| OpenCode | v1.18.11 | npx subpath install, 13/13 discovered |
| Grok Build | 1.0.3 | zero-setup Claude-plugin discovery re-verified 2026-08-29 (`grok inspect` = 13 skills). Marketplace install by name is broken in 1.0.3 — see grok.md |
| Grok Bot | hosted, 2026-08-29 | prompt-driven install of `.agents/skills`, byte-identity confirmed, case 2 PASS — see grok-bot.md |
| Kimi Code | 0.31.1 | project skills + case 2 PASS; TUI plugin install has a manual trust dialog |
