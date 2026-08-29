# Hermes Agent
Surface: `dist/hermes/` in this repository, served directly. There is no satellite repo — the
`machina-exm/co-founder-hermes` mirror was retired on 2026-08-29 once this repository went public,
because it duplicated `dist/hermes/` byte for byte and added a second tree to keep in sync.

## Two supported install routes

**Default — local copy (fast).** One paste, about two seconds. Skills land unmanaged, so they
update only when the founder re-runs the command.

```bash
git clone --depth 1 https://github.com/machina-exm/co-founder /tmp/cf-hermes && mkdir -p ~/.hermes/skills/business && cp -R /tmp/cf-hermes/dist/hermes/* ~/.hermes/skills/business/ && rm -rf /tmp/cf-hermes && hermes skills list | grep business
```

**Alternative — native remote install (managed).** One paste, about nine minutes: each skill gets
a fresh remote scan that costs roughly 40 seconds. In exchange the skills register as managed, so
`hermes skills check` and `hermes skills update` work on them afterwards.

```bash
for s in bank co-founder-setup content-engine gauntlet help offer plan-initiative recall research review sprint steward vision; do hermes skills install https://raw.githubusercontent.com/machina-exm/co-founder/main/dist/hermes/$s/SKILL.md --yes; done
```

## Scanner status — corrected 2026-08-29

Earlier releases of this document claimed the Nous hub scanner blocks any skill referencing
AGENTS.md/CLAUDE.md under rule `agent_config_mod`, "with no override", making local install the only
possible route. **That is no longer true.** Verified on Hermes **v0.20.6**: all 13 skills install
from raw URLs with verdict `Decision: ALLOWED — Allowed (community source, safe verdict)`, scanner
`skills-guard-v2`, rule `agent_config_ref` (referencing agent config, not modifying it), findings
LOW only. Bundled `references/` came along and every file was byte-identical to `dist/hermes/`.
`hermes skills install` also carries a `--force` flag now, which was absent on v0.19.1.

Do not reword skills to please the scanner. They pass on their own merits; if a future Hermes
release tightens the rule again, the local route above still works.

## Tap route — not supported

`hermes skills tap add machina-exm/co-founder` succeeds, but taps serve from the repository's
`skills/` directory, which holds the **Claude tier**: full-length descriptions and `plan` under its
colliding name. A tap install would deliver the wrong tier. Use one of the two routes above.

## Generator specifics
Descriptions ≤57 chars (routing index truncates at 60; hand leads in
`tools/gen/overrides/hermes-descriptions.yml`), full description moved to a `## When to use` body section,
`plan` renamed `plan-initiative` (builtin collision; guard list `tools/gen/hermes-builtins.txt`), every
bundled file cited in plain `references/...` form (the fetcher only bundles paths its regex can see), no
parent-path escapes anywhere.

## Verification status
Payload identity and the 13-skill remote install verified 2026-08-29 on v0.20.6. The last full
5-case behavior smoke was on **v0.19.1** and is due on the next Hermes-affecting change.
