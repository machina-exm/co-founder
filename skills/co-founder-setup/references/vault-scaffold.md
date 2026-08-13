# The vault scaffold

The vault is the founder's durable memory that grows week over week: raw material in, distilled truth out, nothing
lost between sessions. The AI does all the bookkeeping; the founder reads, asks, and decides.
It ships EMPTY: the shape is the product, their journey fills it.

Three-layer law, encoded into everything below:

```
 raw/        immutable: sources land here, nothing edits them
   |
 scratch/    working area: nothing here is trusted
   |
 wiki/       AI-owned truth: rewritten in place, never bottom-appended
```

## The tree (create exactly this)

```
<business-folder>/
├── .co-founder-version  # exactly 1.0.0; written last after setup/migration passes
├── AGENTS.md            # the charter (step 4 wrote it)
├── CLAUDE.md            # link to AGENTS.md
├── README.md            # how this vault works, in plain English
├── index.md             # the catalog: every page, one line each (AI-maintained)
├── log.md               # append-only history of everything that happened
├── baton.md          # the last session's closing note (sprint rewrites it)
├── queue.md          # durable cross-skill work queue
├── inbox-ledger.md      # processed raw sources by content fingerprint
├── scripts/             # deterministic filing gate copied from the plugin
│   └── graph-audit
│
├── raw/
│   ├── inbox/           # the drop zone: articles, transcripts, exports
│   └── assets/          # images and attachments
│
├── wiki/
│   ├── business/        # vision-stub.md until vision writes vision.md; voice.md, offer.md, metrics.md
│   │   ├── content/     # draft/approved/published written content
│   │   └── reviews/     # completed period scorecards
│   ├── initiatives/     # one file per initiative, carrying its readiness state
│   ├── learnings/       # lessons with what they cost and returned
│   ├── sops/            # how-we-do-it procedures
│   ├── research/        # filed outputs of research runs
│   ├── decisions/       # dated records of hard-to-reverse calls
│   └── people/          # customers, competitors, partners
│
├── hub/                 # fixed hubs: business.md, initiatives.md, learnings.md,
│                        # sops.md, research.md, decisions.md, people.md
│
└── scratch/             # AI working area; promoted to wiki/ only after distillation
```

Add interview-driven subfolders under `wiki/` only when the founder named a surface that clearly
needs one. The seven-section spine itself never changes.

Write `.co-founder-version` containing exactly `1.0.0` only after every scaffold file above
exists and resolves. Fresh setup also requires exactly two event rows in `log.md`: the setup
genesis row followed by the vision-stub row. A partial setup has no right to advertise a
completed version.

Copy `graph-audit` byte-for-byte from the co-founder-setup skill's own `references/` directory into the
vault's `scripts/` directory and preserve executable mode. It is shipped code, not a generated
template. A vault is not Ready until it runs from the business-folder root.

## Note frontmatter (every wiki/ page)

```yaml
---
type: learning        # initiative | learning | sop | research | decision | business | person | review | content
title: <one plain sentence that names the insight>
status: high          # confidence: stated | high | low
created: <date>
updated: <date>
sources: [raw/inbox/<file>]
tags: []
# learnings only, when real numbers exist (time counts as cost):
cost: ""
result: ""
supersedes: null
review_after: <date +3 months>
---
```

The base five (`type/title/status/created/updated`) are universal: lint and index depend on
them. `stated` means "someone claimed this"; it is treated as a quote, not a truth.

## index.md skeleton

```markdown
# Index: everything in this vault

<!-- One line per page: link + what it holds. Updated on every filing. Read this FIRST when
     answering any question about the vault. -->

## Business
## Content
## Reviews
## Initiatives
## Learnings
## SOPs
## Research
## Decisions
## People
```

Initiative rows use exactly
`- [Title](wiki/initiatives/file.md) [state: <state>] [roadmap: <done>/<total>]`.
Content rows use exactly
`- [Title](wiki/business/content/file.md) [content_state: <state>]`. Graph-audit parses these
tokens; prose-only summaries are not lifecycle projections.

## log.md genesis

```markdown
# Log: what happened, in order

<!-- Append-only. One row per event, newest last. Format: ## [date] verb | title -->

## [<date>] setup | vault created
```

## baton.md skeleton

```markdown
---
type: baton
updated: <date>
active_initiative: null
initiative_state: null
roadmap_done: 0
roadmap_total: 0
next_step: null
content: {}
---
# Baton

No active initiative.
```

Sprint rewrites the frontmatter on every close. `content` is a mapping from each content path
mentioned in the body to its canonical `content_state` and `published_at`; graph-audit compares it
to the content file.

## inbox-ledger.md skeleton

```markdown
# Inbox ledger: processed raw sources

<!-- Steward checks the SHA-256 fingerprint before every ingest. Same fingerprint means the
     source is already processed: point to its outputs and write nothing. -->

## Entries

<!-- Entry shape:
### <sha256>
- source: raw/inbox/<file>
- processed: YYYY-MM-DD
- outputs: [wiki/<path>.md]
- log_row: "## [YYYY-MM-DD] ingest | <source>"
-->
```

## queue.md skeleton

```markdown
# Queue: durable work between skills

<!-- Source skills append pending entries. Target skills mark the same entry done and add
     outputs. Never delete an entry; a new need gets a new ID. -->

## Queue

<!-- Entry shape:
### <queue-id>
- status: pending
- from: recall
- to: steward
- created: YYYY-MM-DD
- source_paths: [wiki/<path>.md]
- request: <one concrete job>
- completed: null
- output_paths: []
-->
```

## README.md (verbatim, founder-facing)

```markdown
# Your vault: how it works

This folder is your business's memory. It has three zones: `raw/`, `wiki/`, and `scratch/`.

- **raw/**: drop anything in `raw/inbox/`: an article, a call transcript, an export.
  Nothing in here ever gets edited. It is the evidence locker.
- **wiki/**: the distilled truth. Your lessons, your procedures, your decisions, your
  research. The AI writes and maintains every page. You read it; the AI handles filing.
- **scratch/**: the AI's workbench. Ignore it.

Four root files keep it reliable: `index.md`, `log.md`, `queue.md`, and `inbox-ledger.md`.
`queue.md` keeps work alive between skills, and `inbox-ledger.md` prevents duplicate ingests.
One shipped check, `graph-audit`, blocks broken lifecycle state and bad receipts before a skill
calls its filing complete.

The AI handles the bookkeeping. Drop things in the inbox, run your skills, make your calls.
The vault stays organized because the AI does the maintenance no one wants to do.
```

## hub seeds (fixed filenames)

Create exactly these seven files:

`hub/business.md` · `hub/initiatives.md` · `hub/learnings.md` · `hub/sops.md` ·
`hub/research.md` · `hub/decisions.md` · `hub/people.md`.

Each uses this shape:

```markdown
---
type: business
title: "Learnings: hub note"
status: high
created: <date>
updated: <date>
---
# Learnings

Every lesson this business has paid for, with what it cost and what it returned.

## What worked
## What failed
## Still testing

> How this fills up: after anything meaningful, say "what did we learn", and the note gets
> written, tagged, and linked here. The AI handles filing.
```

Adapt the header, the one-line purpose, and the sub-buckets per section (Initiatives: by state ·
Decisions: by area · People: customers/competitors/partners · SOPs: by frequency · Research: by
question · Business: vision/voice/offer/metrics plus content/reviews). The filename never varies.

`hub/initiatives.md` always carries these exact level-two buckets in order: `Idea`, `Survived`,
`Planned`, `Executing`, `Reviewed`, `Banked`. Each initiative link appears under exactly one.
Content links in `hub/business.md` carry `[content_state: <state>]`.

## The metrics source (wiki/business/metrics.md)

```markdown
---
type: business
title: "Metrics: dated business numbers"
status: stated
created: <date>
updated: <date>
---
# Metrics

<!-- One dated row per metric. Every number names its source path or founder confirmation.
     Derived values also name their exact recomputable formula, with currency, units, and period.
     Review reads this file for "The money"; absent data stays "not tracked". -->

| As of | Metric | Value | Source | Calculation |
|-------|--------|-------|--------|-------------|
```

## The canonical offer (wiki/business/offer.md)

```markdown
---
type: business
title: "Offer: current canonical design"
status: stated
offer_state: draft
created: <date>
updated: <date>
---
# Offer

## Audience
None yet.
## Promise
None yet.
## Ladder and price
None yet.
## Terms and receipts
None yet.
## Parked recommendations
None.
```

## The worked example (exact path)

Write this to `wiki/learnings/example-learning-shape.md`, list it under Learnings in
`index.md`, and link it from `hub/learnings.md`. Tell the founder it is deletable.

```markdown
---
type: learning
title: "Example only: the shape of a banked lesson"
status: stated
created: <date>
updated: <date>
sources: []
tags: [example]
cost: ""
result: ""
supersedes: null
review_after: null
---
# Example only: the shape of a banked lesson

This page contains no business claim. It shows the fields a real lesson will fill: what was
tried, what it cost, what happened, the evidence, and when to re-check it. Delete it whenever.
```

## The voice file (wiki/business/voice.md)

Built from interview Q7. Sections, all filled from THEIR material:

```markdown
---
type: business
title: "Voice: how everything public sounds"
status: <high with approved founder samples; stated without them>
created: <date>
updated: <date>
---
# Voice

## Register
<3-5 lines derived from their samples: sentence length, formality, energy, quirks.>

## Words and moves they use
<bullets pulled from the samples>

## Never
<bullets: what would read as off-brand for them>

## Approved samples
<the 2-3 samples they gave, verbatim: the calibration set every content run checks against>
```

No samples given: derive Register from their three adjectives + admired writer, leave Approved
samples with a note that the first pieces they approve will be filed here.
