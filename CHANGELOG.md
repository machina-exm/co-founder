# Changelog

All notable changes to `/co-founder` are recorded here. Releases follow Semantic Versioning:

- **MAJOR:** a founder vault or workflow contract changes incompatibly and needs a deliberate
  migration.
- **MINOR:** new capability or a backward-compatible contract upgrade; setup re-sync may add or
  migrate files without overwriting founder content.
- **PATCH:** compatible corrections to skill behavior, docs, or release packaging.

Every release entry carries five founder-facing blocks: Impact, Compatibility, Update,
Migration, and Delivery. The Delivery record is structured for member-release posts.

## 1.0.0 — 2026-08-13

First public release.

### Impact

- 13 skills that run a business with you and push back like a real co-founder: setup, vision,
  plan, gauntlet, research, sprint, review, bank, steward, recall, offer, content-engine, help.
- Consequential advice is receipt-gated: a fact about your business plus a checked outside
  source, or the recommendation parks and names the next check.
- Every lesson, decision, and research run lands in your own vault as plain markdown you own.
- Multi-harness: Claude Code is the flagship (full plugin experience); Codex CLI, Grok Build,
  Kimi Code CLI, OpenCode (via `npx skills add machina-exm/co-founder/.agents/skills`), and Hermes
  Agent (local install, see the co-founder-hermes repo) run the same skills from one canonical
  tree. Generated surfaces are committed; edit `skills/` + `tools/gen/rules.yml` only.

### Compatibility

- Claude Code 2.1.206 or newer, a paid Claude plan, and Git.
- Vault marker: `.co-founder-version` reads `1.0.0`. Charters are `AGENTS.md`-first with a
  `CLAUDE.md` compatibility shim, portable across harnesses.

### Update

- First release: nothing to update from. Install with the one-line command in the README.

### Migration

- None. Setup re-sync on an existing 1.0.0 vault verifies the scaffold and proposes no changes.

### Delivery

- Marketplace `co-founder` at `machina-exm/co-founder`; install string `co-founder@co-founder`.
- Release gate: `scripts/release_all.sh` (surface regeneration, drift check, flagship
  byte-identity, repository validators, strict plugin validation, Hermes satellite sync).
