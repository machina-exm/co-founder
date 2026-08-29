# Changelog

All notable changes to `/co-founder` are recorded here. Releases follow Semantic Versioning:

- **MAJOR:** a founder vault or workflow contract changes incompatibly and needs a deliberate
  migration.
- **MINOR:** new capability or a backward-compatible contract upgrade; setup re-sync may add or
  migrate files without overwriting founder content.
- **PATCH:** compatible corrections to skill behavior, docs, or release packaging.

Every release entry carries five founder-facing blocks: Impact, Compatibility, Update,
Migration, and Delivery. The Delivery record is structured for member-release posts.

## 1.0.3 — 2026-08-29

Hermes gets a second install route, and a correction. No skill behavior changed.

### Impact

- Hermes can now install /co-founder the way it installs anything else, straight from a URL. The
  skills register as managed, so `hermes skills check` and `hermes skills update` keep them current.
- The fast local install is still there and still the default. It takes about two seconds; the
  managed route takes about nine minutes, because Hermes security-scans each skill separately.
- Correction: earlier notes said Hermes could not install these skills remotely, because its
  scanner blocks anything touching `AGENTS.md` with no override. That was true of Hermes v0.19.1
  and is not true of v0.20.6. All 13 skills now scan as ALLOWED. If you avoided Hermes for that
  reason, the reason is gone.

### Compatibility

- Unchanged. Vault marker stays at `1.0.0`.
- On Hermes, `plan` is named `plan-initiative`, because Hermes has a builtin named `plan`.

### Update

Re-run whichever install you used. Both are in the README under Installing on Hermes.

### Migration

- None. If you already installed by copying files, you can keep that install or switch to the
  managed route; the skills are identical either way.

### Delivery

- Verified on Hermes v0.20.6: 13 of 13 remote installs returned
  `Decision: ALLOWED — Allowed (community source, safe verdict)` under scanner `skills-guard-v2`,
  rule `agent_config_ref`, LOW findings only, with bundled references byte-identical to the repo.
- The `hermes skills tap` route stays unsupported: taps serve from the repository's `skills/`
  directory, which holds the Claude tier rather than the Hermes tier.

## 1.0.2 — 2026-08-29

Hermes now installs from this repository. No skill behavior changed.

### Impact

- The Hermes install no longer goes through a separate mirror repository. One command clones this
  repo and copies `dist/hermes/` into your Hermes skills folder. The old link pointed at a private
  repository, so that install path did not work for anyone but the maintainer.
- One repository to trust and read instead of two.

### Compatibility

- Unchanged. Vault marker stays at `1.0.0`.
- Hermes skills are unchanged: still 13, still with `plan` named `plan-initiative` because Hermes
  has a builtin by that name.

### Update

Re-run the install command from the README. It replaces the skills with the current version:

```bash
git clone --depth 1 https://github.com/machina-exm/co-founder /tmp/cf-hermes && mkdir -p ~/.hermes/skills/business && cp -R /tmp/cf-hermes/dist/hermes/* ~/.hermes/skills/business/ && rm -rf /tmp/cf-hermes && hermes skills list | grep business
```

### Migration

- None for your vault. If you installed Hermes skills from the old mirror, the command above
  overwrites them in place with identical content.

### Delivery

- `machina-exm/co-founder-hermes` archived. Its payload was byte-identical to `dist/hermes/`, so
  it duplicated content and added a second tree to keep in sync.
- `scripts/release_hermes.sh` deleted; `scripts/release_all.sh` drops the satellite sync, its
  clean-tree guard, and the manual satellite push step.
- Still true: `hermes skills install` stays unsupported. The Nous hub scanner blocks any skill that
  touches AGENTS.md, and writing your charter is what these skills do. Local install is the
  supported path, not a workaround.

## 1.0.1 — 2026-08-29

Docs and packaging only. No skill behavior changed.

### Impact

- Grok Bot is supported. It has no marketplace route, so you ask your Bot to install the
  collection and it clones the public repo itself. `docs/porting/grok-bot.md` carries the prompt.
- The install and update instructions each lead with one short command instead of a chain of
  four, so a failure is visible and recoverable at the step that caused it.
- The skills table lists all 13 skills. `help` was missing from it, and the intro undercounted.

### Compatibility

- Unchanged. Claude Code 2.1.206 or newer, a paid Claude plan, and Git.
- Vault marker stays at `1.0.0`. The vault contract did not change, so no vault is out of date.

### Update

```sh
claude plugin marketplace update co-founder
```

Then, from your business folder:

```sh
claude plugin update co-founder@co-founder --scope user
claude
```

### Migration

- None. Nothing in your vault is affected.

### Delivery

- Grok Bot verified live 2026-08-29: 13 skills copied byte for byte, and a "build me the landing
  page" request was refused and routed to setup, exactly as on Claude Code.
- Grok Build re-verified on CLI 1.0.3; `docs/porting/grok.md` had been pinned to 0.2.118 and now
  records the `/help` and `/plan` builtin collisions plus a marketplace-install bug in that CLI.

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
