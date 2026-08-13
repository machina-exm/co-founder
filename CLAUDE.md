# cofounder-plugin: the /co-founder skill collection

Distributable Claude Code plugin: 13 skills that give a solopreneur a co-founder, not a yes-man.
This repo ships publicly (unlisted). Everything committed here is founder-visible.

## What this repo is
- `.claude-plugin/plugin.json` + `marketplace.json`. CLI install: `claude plugin marketplace add machina-exm/co-founder` → `claude plugin install co-founder@co-founder --scope user` → verify with `claude plugin details co-founder@co-founder` → start a fresh `claude` session.
- `skills/`: co-founder-setup, vision, plan, gauntlet, research, sprint, review, bank, steward, recall, offer, content-engine, plus the tiny help alias.
- `CONVENTIONS.md` is the public shared contract. Each `SKILL.md` plus its local `references/` is the public source of truth for that skill. The repository must stand on its own for external maintainers.

## Build laws (non-negotiable)
1. **Privacy scrub.** No private founder revenue, pricing, deal names, voice DNA, lane specifics, infrastructure facts, or private source paths ship. Templates contain empty shapes. References contain only distilled, de-identified heuristics.
2. **Voice laws.** Every skill text passes /humanize-thinking; looks engineered (ASCII diagrams, precise technical vocabulary); uses the collection's direct, standard-punctuation voice.
3. **Craft rules.** Predictable process (not output); state the positive; delete no-op sentences; progressive disclosure via references; plain markdown artifacts. Plugin installation, namespacing, cache paths, and restart behavior are Claude Code-specific.
4. **Per-skill gate.** A skill ships only after adversarial QA (scenario simulation plus contract check by an independent worker) with findings fixed and maintainer approval recorded.
5. **Mechanics doctrine.** Every skill follows the not-yet gate, receipts contract, facts-mine/decisions-yours interviews, effort sizing, and no-guessing-unattended law in `CONVENTIONS.md`.

## Release gates
- `claude plugin validate --strict .` passes with zero warnings.
- Every `skills/*/SKILL.md` frontmatter block parses as strict YAML.
- Native eval cases run, including trigger conflicts, fresh folder, re-sync, and the full loop.
- A simulated installed release resolves its shared contract from the versioned plugin cache.
- Every release bumps `.claude-plugin/plugin.json` and adds a CHANGELOG entry with Impact,
  Compatibility, Update, Migration, and Delivery blocks. A push without a version bump does not
  update pinned installs, and third-party marketplace auto-update is off by default.

## Git
Use one commit per logical fix and conventional messages naming the audit findings. Merge to main
after maintainer approval. Never commit anything failing the privacy scrub.
