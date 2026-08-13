# Conventions: the contracts every skill shares

One vocabulary, defined once. A skill that invents its own state names, log verbs, or paths
breaks every other skill silently. When writing or editing any skill, these contracts win over
improvisation.

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

## Linked-state integrity

A canonical change is a graph transaction. Start at the changed field or fact, follow every
explicit link and every catalog projection it can make stale, and reconcile the reachable graph
before declaring the write complete. At minimum, check these projections:

- initiative `state` ↔ its bucket in `hub/initiatives.md` ↔ `index.md` summary and roadmap count
  ↔ checked steps and completion evidence ↔ `baton.md` and related queue entries;
- content `content_state` and `published_at` ↔ content body ↔ index/hub summary ↔ serving
  initiative steps and publication metrics or voice-sample references;
- offer `offer_state` and current constraints ↔ its customer-facing close ↔ linked initiative,
  plan, index, and current metrics;
- customer evidence ↔ the roadmap condition it satisfies ↔ current assumptions in linked
  offer, initiative, metrics, and learning pages.

The skill that changes a canonical node owns its adjacent projections in the same write. Steward is
the closure safety net, not permission for other skills to leave drift behind. After changes,
traverse again from every changed node until the frontier adds no new conflict. A direct
contradiction blocks a clean result: report `NOT CLEAN: <n> unresolved contradictions` with the
paths. "Checked, nothing to fix" is legal only when the conflict frontier is empty.

Machine-readable projections are fixed. Initiative index rows carry `[state: <state>] [roadmap:
<done>/<total>]`; `hub/initiatives.md` uses the six exact state buckets. Content index
and business-hub rows carry `[content_state: <state>]`. `baton.md` has frontmatter fields
`active_initiative`, `initiative_state`, `roadmap_done`, `roadmap_total`, `next_step`, and a
`content` mapping for every content path mentioned in its body. Graph-audit parses these fields;
free prose cannot substitute for them.

## Log verbs

`log.md` rows follow `## [YYYY-MM-DD] verb | title`, grep-parseable. The verbs:
`setup` `resync` `vision` `gauntlet` `plan` `sprint` `review` `learning` `debrief` `decision`
`ingest` `lint` `research` `content` `offer`. One row per event, append-only, newest last.

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

## Paths (fixed by setup, read from the charter's path map)

Charter `AGENTS.md` (CLAUDE.md links to it) · catalog `index.md` · history `log.md` · session state
`baton.md` · durable queue `queue.md` · processed-source register `inbox-ledger.md` ·
`wiki/business/` (`vision.md`, `voice.md`, `offer.md`, `metrics.md`, `content/`, `reviews/`,
glossary via charter) · `wiki/initiatives/` ·
`wiki/learnings/` · `wiki/sops/` · `wiki/research/` · `wiki/decisions/` · `wiki/people/` ·
fixed hubs `hub/{business,initiatives,learnings,sops,research,decisions,people}.md` ·
`raw/inbox/` (immutable drops) · `scratch/` (untrusted).

## Inbox ledger

`inbox-ledger.md` is the idempotency boundary for raw capture. Before processing a source,
steward computes a SHA-256 content fingerprint with the environment's available checksum tool
and searches the ledger for the same fingerprint. Each processed entry records source path,
fingerprint, processed date, output paths, and the one `log.md` row. Same fingerprint means
already processed: report its outputs and write nothing. Same path with new contents gets a new
fingerprint entry and updates the existing canonical pages through dedupe. Raw files never move
or mutate.

## Durable queue item queue

Cross-skill work lives in `queue.md`, not chat. One entry has a stable ID, `status` (`pending`
or `done`), `from`, `to`, `created`, `source_paths`, `request`, and, when done, `completed` plus
`output_paths`. The source skill writes a pending pointer after its own artifact is durable. The
target skill reads entries addressed to it during preflight, performs the work once, then marks
the same entry done with outputs. A done entry is append-only history; it never gets deleted or
reopened. A new need gets a new ID.

## Universal preflight

Every skill reads this file from `${CLAUDE_SKILL_DIR}/../../CONVENTIONS.md` before it reads
the founder's folder. Then classify the folder from files, never from chat memory:

- **Ready:** `.co-founder-version` reads `1.0.0`; a charter (`AGENTS.md`, or its `CLAUDE.md`
  link/import), `index.md`, `log.md`, `baton.md`, `queue.md`, `inbox-ledger.md`, and the required
  `wiki/`, `hub/`, `raw/inbox/`, and
  `scratch/` roots all exist, including the seven fixed hub files, canonical offer/metrics files,
  and executable `scripts/graph-audit`. Read the charter's path map and
  work only inside it.
- **Fresh:** no charter and none of `index.md`, `log.md`, or `wiki/` exists. Setup owns all
  scaffold creation. Every other collection skill stops without writing and routes to
  `/co-founder:co-founder-setup`.
- **Partial:** some signature files exist but the Ready signature does not. Preserve every
  existing file, name what is missing, and route to `/co-founder:co-founder-setup` in re-sync mode.
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

## Deterministic filing gate

The founder vault carries one executable validator copied from this plugin: `scripts/graph-audit`.
It is the authority on whether a durable write may close. Prompt interpretation cannot waive,
narrow, or replace its result.

Every skill writes the durable artifact, its projections, and its required event row as one
tentative transaction. The event row exists before validation so graph-audit can verify it; a
retry repairs that same transaction and never appends a duplicate event. Every filing step then
ends with this gate:

1. Run `scripts/graph-audit <every touched durable file>`; it audits the full linked graph,
   including every durable file's modification date and every cited receipt anchor.
2. Fix every violation, rerun the command, and proceed only after it exits zero.

A nonzero exit keeps the tentative transaction open. It blocks exposing the state advance,
completing the queue item, making a done claim, or declaring clean health; repair the artifacts,
projections, and existing event row, then rerun. Steward health runs the command without a file
list so the whole durable vault is checked. Validator failures are reported verbatim when the skill
cannot repair them safely.

## The receipts contract

Double receipts apply to a **consequential business recommendation**: go/no-go and strategy
calls, pricing or offer changes, customer-facing actions, spending or revenue moves, and
anything hard to reverse. Each such recommendation names both:

1. **Internal receipt:** an exact vault path to current evidence about this business, or a
   founder-confirmed current fact named in the active checkpoint and then recorded. A
   `stated` claim is quoted evidence, not verified truth.
2. **External receipt:** a checked, dated source gathered through research. Primary evidence
   or independently corroborated evidence outranks vendor repetition.

**Standalone gauntlet exception:** when no founder system exists, a founder-confirmed fact quoted
exactly from the active transcript may serve as the internal leg for that standalone run. The
external leg is still required. Any resulting verdict is prefixed `STANDALONE:`, expires with
the conversation, writes no state, and cannot authorize plan or execution. The founder must run
setup and repeat the gauntlet in full mode before the bet enters the durable workflow. Without a
checked external leg, standalone returns the normal `PARKED: external receipt missing` outcome.

Three neighboring classes stay precise:

- **Operational navigation** (which state exists, which roadmap step is next, where a file
  belongs) needs the internal file or log citation it came from, not an outside source.
- **Factual claims** use the receipt appropriate to the claim: vault evidence for this
  business, checked external evidence for the outside world. Public claims never borrow one
  kind of source to prove the other.
- **Interview suggestions** are labeled `Working hypothesis:` until the founder confirms
  them. They help the founder react; they are not advice cleared for action.

One leg missing has one outcome everywhere:

`PARKED: internal receipt missing` → run recall or elicit and record the missing business fact.

`PARKED: external receipt missing` → run research.

A parked recommendation does not ship as advice and cannot advance a readiness state. Evidence
gaps live under `Parked recommendations`; `Needs your call` is reserved for genuine founder
judgment after the available facts are present.

### Verified absence

Absence is bounded negative evidence only when the record names the corpus or paths checked, exact
queries plus obvious synonyms, date, search tool, and inspected-result count. It proves only `no
<thing> found in <checked corpus/search> as of <date>`. It never proves real-world nonexistence or
the opposite proposition. An empty SOP folder supports "no SOP is recorded in this vault," not
"the business has no SOP." A finite web search supports "no independent benchmark found in this
search," not "no benchmark exists."

Vault absence can satisfy operational navigation about what is recorded. External-search absence
cannot become the external receipt for SURVIVES or DIES; it establishes the missing evidence and
keeps the recommendation PARKED.

### Gate refusal is not a verdict

A checked missing prerequisite may withhold authorization or a state advance without two receipt
legs. This is operational enforcement of a recorded gate, not a claim that the bet will fail. Name
the missing prerequisite, keep the state unchanged, and use the canonical PARKED outcome. Do not
convert an evidence gap into DIES.

### Reversible internal experiments

A founder-confirmed workflow experiment may use one checked internal scorecard receipt without an
external leg only when it is internal, reversible, and has no customer-facing, money, legal,
strategic, or readiness-state effect. Record the founder's yes, review date, success condition, and
undo condition. Anything outbound, financial, strategic, hard to reverse, or state-advancing stays
consequential and needs both legs. Steward edits to existing memory still use its mutation approval
contract even when technically reversible.

### Mutation approval scope

Approval covers the exact proposed lines and nothing discovered later. A post-approval discovery
starts a new diff: stop, show the added mutation, and get a new yes before touching it. If approval
does not arrive, leave the item flagged and report the vault NOT CLEAN. An earlier broad "clean it
up" or approval of neighboring lines never expands consent.

### Prior-stage receipt preservation

An initiative is one append-only lifecycle artifact. A downstream owner patches its own headings
and preserves every prior-stage receipt, including the complete `## Gauntlet verdict`, advisor-board
findings, objections, exact receipt lines, and `## Log`. Scope links to the local Gauntlet verdict;
`log.md` is an event pointer, never storage for the board. Before a state flip, compare the
prior-stage sections with the pre-write snapshot. Any deleted or rewritten prior-stage receipt
aborts the transition and restores the preserved material.

### Immutable consent receipts (T1 surfaces)

Four surfaces are binding, zero tolerance: any `wiki/decisions/**` page, any price or term row in
`wiki/business/offer.md`, any `content_state: approved|published` transition, and any `Founder's
yes:` field. Each MUST carry an immutable consent receipt (`[receipt: raw/inbox/<file>#<exact
words>]` or a live-transcript anchor) pointing at the founder's actual words. At the moment the
founder gives the yes, capture their exact words into an immutable
`raw/inbox/session-receipt-<date>-<slug>.md` and cite that file.

No skill may create a decision page, write an approval or `Founder's yes:` field, or advance
content to `approved`/`published` without that receipt. If the founder's yes does not exist, the
decision page is not written, the approval field is not set, and the state stays `draft`/`parked`;
the skill says so plainly rather than manufacturing consent. A system-generated date, a one-word
edit, or an inferred agreement is not a founder yes. graph-audit enforces the content
`approval_receipt`/`publication_receipt` anchors against immutable `raw/inbox/` evidence, and the
same discipline governs decisions pages and offer terms.

### Quote on cite

Before writing any `[receipt: <path>#<anchor>]` pointer, or any `<path>#<quote-anchor>` receipt
field, reopen the cited file and carry the exact quote used as the anchor into the artifact beside
the pointer. graph-audit verifies that every receipt anchor (in frontmatter receipt fields and in
inline `[receipt: …]` tags alike) is a verbatim substring of the cited file. An anchor absent from
its source fails the gate; fix the quote or remove the citation.

## The four behaviors every skill embeds

1. **Facts are mine, decisions are yours.** Look up what can be looked up; bring the founder
   only real judgment calls, one question per turn, each with a recommended answer.
2. **Size the stakes first.** Quick treatment for small things, full treatment for
   bet-the-business things. Uncertain resolves to the deeper treatment.
3. **Receipts before recommendations.** Apply the receipts contract above. Consequential
   advice needs both legs; operational navigation cites the internal record; interview
   suggestions remain working hypotheses. Missing-leg advice parks in the canonical shape.
4. **Never guess unattended.** A question only the founder can answer goes into a
   "Needs your call" list; work continues around it.

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

## Filing ownership

Each payload has one canonical home. The owning skill files it and may enqueue a pointer to the
next distinct job; the queue never carries a second copy of filed content. Bank and research
file their own outputs: their semantic verb (`learning`, `debrief`, `decision`, `research`) is
the event's one log row. Steward captures raw inbox drops, pasted filing asks, and queue items whose
payload is explicitly not yet filed. A queue item already carrying source paths and a log row gets
no re-filing and no `ingest` row; the target creates only its own distinct output.

The queue carries work, not duplicate content. Recall enqueues new synthesis for steward. Review
enqueues stale-note work for steward and completed initiatives for bank. Offer files the
canonical offer, then enqueues plan when execution is needed. Consumers point to those source
paths and mark the queue entry done after creating their own owned artifact.

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

## The 3-test decision bar

A call earns a decision row only when ALL THREE hold: hard to reverse · surprising without
context · a real tradeoff (something was given up). Anything less is not decision-log
material.

## Searching the vault

Use the environment's available file search: `rg` or `grep` where present, the harness's
search tool or explicit folder listing plus reading otherwise. Absence is valid only after
`index.md` AND the relevant wiki folders were actually searched with whatever tooling exists.

## Cross-skill invocation

Skills reference each other by prose name ("run the gauntlet", "hand this to steward"), never by
file path into another skill's folder. Shared material lives in the skill that owns it.
