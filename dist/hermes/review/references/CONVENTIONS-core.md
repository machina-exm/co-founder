## The readiness state machine

Every initiative (an idea, a launch, a change worth real time or money) lives on ONE file in
`wiki/initiatives/`, and that file carries a `state` in its frontmatter:

```
 idea ──> survived ──> planned ──> executing ──> reviewed ──> banked
      |            |           |            |             |
  gauntlet owns  plan owns   sprint owns  review owns   bank owns
   this arrow    this arrow  this arrow   this arrow    this arrow
```

The legal transitions are exhaustive:

| From | To | Owner | Guard |
|------|----|-------|-------|
| no file | `idea` | plan, gauntlet, or offer intake | The skill handling the founder's current ask captures one stub; no other skill creates a parallel initiative. |
| `idea` | `survived` | gauntlet | Latest verdict is SURVIVES and both receipt legs are present. |
| `idea` | `planned` | plan | SMALL only; record `Sized small, gauntlet waived` and get the founder's scope confirmation. |
| `survived` | `planned` | plan | Latest gauntlet verdict is SURVIVES, no parked recommendation remains, and the founder confirms the scope. |
| `planned` | `executing` | sprint | Set immediately before the first roadmap step starts. |
| `executing` | `reviewed` | review | Review's completion bar passes and the outcome is judged. |
| `reviewed` | `banked` | bank | A learning is filed and linked from the initiative. |

No other state transition is legal. DIES and PARKED verdicts leave an `idea` at `idea`.
Unknown states stop for repair. Every owner checks the current state immediately before writing
the next one; a later workflow never trusts the state it read at session open.

State is monotonic. Replanning a `planned` initiative updates its scope and roadmap while it
stays `planned`. A same-destination amendment during `executing` preserves completed steps and
keeps `executing`; a changed destination becomes a separate `idea` linked in its body while the
old execution moves every unchecked step to `Roadmap → Stopped` with the founder-confirmed date
and reason, then proceeds to an honest stopped-outcome review. `reopens` remains null for that
new idea because its predecessor is not closed. Work already `reviewed` or
`banked` reopens as a new initiative with `reopens: wiki/initiatives/<old>.md`; the closed
file never moves backward. The new file earns every gate again.

**The gate:** sprint executes only `planned` or `executing`. Plan refuses a BIG `idea` until
the gauntlet advances it. A small bet may take the one documented skip above. When sizing is uncertain,
it is a big bet.

**The refusal shape** (used by every gated skill): state plainly what stage is missing, then ask
the first missing question. One sentence of why, zero lectures. The founder should feel
interviewed, never scolded.

## Frontmatter

Base five on every wiki page: `type` `title` `status` `created` `updated`.
Types: `initiative` `learning` `sop` `research` `decision` `business` `person` `review`
`content`.
Initiatives additionally carry `state` (readiness), `size`, and `reopens` (a closed predecessor
path or null); `state` and `status` never substitute for each other: one is lifecycle, the
other is confidence in the file's claims. Every initiative beyond `idea` carries checked
`internal_receipt` and `external_receipt` values in `<path>#<quote-anchor>` form. The internal
leg points to business evidence outside initiative/content output; the external leg points to a
dated `type: research` file under `wiki/research/`.
Confidence (`status`): `stated` (a claim, treated as a quote) · `high` · `low`.
Learnings add `cost` and `result` when real numbers exist; time counts as cost ("4 hrs").
Reviews add `period_start`, `period_end`, and `review_state` (`draft` · `complete`). Content adds
`content_state` (`draft` · `approved` · `published`), `channel`, `published_at`, and checked
`approval_receipt` / `publication_receipt` anchors as those states require. Canonical vision adds
`strategy_state` (`parked` · `cleared`) plus checked internal/external receipt anchors when cleared.
`wiki/business/offer.md` adds `offer_state` (`draft` · `approved` · `active` · `retired`).

## Paths (fixed by setup, read from the charter's path map)

Charter `AGENTS.md` (CLAUDE.md links to it) · catalog `index.md` · history `log.md` · session state
`baton.md` · durable queue `queue.md` · processed-source register `inbox-ledger.md` ·
`wiki/business/` (`vision.md`, `voice.md`, `offer.md`, `metrics.md`, `content/`, `reviews/`,
glossary via charter) · `wiki/initiatives/` ·
`wiki/learnings/` · `wiki/sops/` · `wiki/research/` · `wiki/decisions/` · `wiki/people/` ·
fixed hubs `hub/{business,initiatives,learnings,sops,research,decisions,people}.md` ·
`raw/inbox/` (immutable drops) · `scratch/` (untrusted).

## Universal preflight

Every skill reads this file from `references/CONVENTIONS-core.md` (in this skill's own folder — from the terminal it is `${HERMES_SKILL_DIR}/references/CONVENTIONS-core.md`) before it reads
the founder's folder. Then classify the folder from files, never from chat memory:

- **Ready:** `.co-founder-version` reads `1.0.0`; a charter (`AGENTS.md`, or its `CLAUDE.md`
  link/import), `index.md`, `log.md`, `baton.md`, `queue.md`, `inbox-ledger.md`, and the required
  `wiki/`, `hub/`, `raw/inbox/`, and
  `scratch/` roots all exist, including the seven fixed hub files, canonical offer/metrics files,
  and executable `scripts/graph-audit`. Read the charter's path map and
  work only inside it.
- **Fresh:** no charter and none of `index.md`, `log.md`, or `wiki/` exists. Setup owns all
  scaffold creation. Every other collection skill stops without writing and routes to
  `/co-founder-setup`.
- **Partial:** some signature files exist but the Ready signature does not. Preserve every
  existing file, name what is missing, and route to `/co-founder-setup` in re-sync mode.
  Every other collection skill stops without filling gaps or creating a parallel vault.
- **Wrong folder:** unrelated work is present and no founder-system signature exists. Route
  to setup, which asks for a fresh business folder.

Two intentional entry-point exceptions keep first use recoverable. Setup performs the fresh,
re-sync, and wrong-folder work. The gauntlet may run verbally in standalone mode, writes no files,
and offers setup after the verdict. Help may inspect the charter to route; without a Ready
system it routes to setup and stops.

After a Ready result, each skill checks its own required artifact. A missing voice file routes
content-engine to setup re-sync; a missing vision routes planning work to vision; a missing
initiative routes execution work to plan. One owner repairs each gap.

## The durable claim admission gate

A sentence becomes business memory only through one of these three doors:

1. **Calculated.** Name the input rows, units, time period, and formula. Reopen those inputs and
   recompute the result immediately before writing it.
2. **Quoted receipt.** Reopen the cited file immediately before writing, locate the exact passage
   that supports the claim, and carry its path plus a short exact quote or table row. A filename
   alone is not evidence. The passage must establish the claim, not merely mention its topic.
3. **Founder-stated: unverified.** Preserve the founder's words and label them exactly this way.
   They are usable as a stated input or interview lead, never as a verified result.

Nothing else enters a durable file as fact. Estimates, analogies, remembered chat, model
inferences, and numbers copied from a summary use the third door or wait for a question. Before
reusing a claim downstream, rerun the gate against its actual source; a previous page's confidence
label is not a substitute. A claim cannot become stronger than its weakest input. Contradictory
sources are carried together until reconciled, never resolved by choosing the convenient one.

The write-time check is literal: open the source and confirm the supporting passage still exists.
If a tracker has one row, it proves one row; it does not prove a completed measurement window. If
a metrics page records monthly run-rate, it does not prove cash received during a week. If a file
records two clients, it does not prove two personal posts. A citation that fails this check is
removed from the claim, and the claim is either labeled `Founder-stated: unverified` or omitted.

Every skill that writes or rewrites business memory runs this admission gate on new claims and on
old claims it carries forward. The artifact records enough evidence for a later skill to rerun the
check: calculation, exact quoted receipt, or the founder-stated/unverified label.

Every derived row in `wiki/business/metrics.md` carries its explicit arithmetic in a
`Calculation` column, including units, currency, and time period. Recompute the formula from its
named input rows before filing. A founder-stated total that conflicts with the recomputation is
not a confirmed receipt: show the equation, ask which input is wrong, and file no total until the
founder resolves it.

### The parameter gate

Before supplying any business-specific target, duration, quantity, cap, capacity, cadence, cost,
conversion, buyer behavior, or scope assumption, search the admitted receipts. If the parameter
is absent and blocks the work, ask one precise founder question. If it does not block, record
`Working hypothesis: unverified:` only under `Needs your call` or `Parked recommendations` and
continue around it.

An unverified parameter never becomes a current metric, offer term, close, key decision, roadmap
commitment, public claim, or readiness-state justification. A formula built from an invented input
is still invented. Heuristics choose the next question; they never supply the answer. Founder
confirmation names the exact parameter being confirmed and is admitted as founder-stated, not
retroactively described as measured evidence.

**Ask before you assert:** never present a quantity, duration, sample size, date, or causal motive
in prose before asking the founder for it or citing a receipt for it. A plausible number offered
first and confirmed afterward is the failure this rule prevents.

## The shared dedupe rule (every skill that files)

Before creating any wiki page: search `index.md`, the target fixed `hub/<section>.md`, and the
target folder. The
same claim or topic already exists: update the existing page to the current truth, preserving
the prior claim via `supersedes:` or a superseded note inside, and say why. Create a new page
only for genuinely distinct topics. A conclusion that reverses leaves ONE canonical note
standing with the old one marked superseded; two current truths is the failure this rule
exists to prevent.

Content drafts are never canonical evidence. Recall and recommendation workflows exclude
`type: content` pages from business-fact receipts regardless of `content_state`; approved and
published content may be consulted for voice or publication history only. Current offer facts
come from `wiki/business/offer.md`; current financial facts come from
`wiki/business/metrics.md`, with dated source links.

## Durable queue item queue

Cross-skill work lives in `queue.md`, not chat. One entry has a stable ID, `status` (`pending`
or `done`), `from`, `to`, `created`, `source_paths`, `request`, and, when done, `completed` plus
`output_paths`. The source skill writes a pending pointer after its own artifact is durable. The
target skill reads entries addressed to it during preflight, performs the work once, then marks
the same entry done with outputs. A done entry is append-only history; it never gets deleted or
reopened. A new need gets a new ID.
