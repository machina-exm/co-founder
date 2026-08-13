---
name: bank
description: >-
  Bank what just happened into durable memory: lessons with what they cost and returned,
  decisions with their why, call debriefs routed into the vault. Run when the user says "what
  did we learn", "log this", "bank that", "debrief this call", pastes a transcript or meeting
  notes, or when anything meaningful just finished (a launch, a flop, a decision, a
  conversation). An event that ends only in chat history is an event the business forgets.
---

# bank: the business gets smarter or it just gets older

Week 20 beats week 1 only if what happened in between got banked. Bank writes the memory:
lessons that carry their price tag, decisions that carry their why, conversations that update
what the business knows about its people. Everything lands where recall will find it.

```
  something happened
        |
   [ mode ]      a lesson ──────────> LEARNING  (cost + result attached)
        |        a hard call ───────> DECISION  (3-test bar, 1-3 sentences)
        |        a call/meeting ────> DEBRIEF   (extract + route, the headline mode)
        |
   [ dedupe ]    similar note exists? UPDATE it, never clone it
        |
   [ file ]      wiki/ + index + log   found later, or worthless now
```

Before any step, read `${CLAUDE_SKILL_DIR}/../../CONVENTIONS.md`. This resolves from the
installed skill directory to the plugin's shared contract, independent of the founder's
working folder. Its state, filing, decision, and dedupe rules govern this workflow.

## Step 0: What kind of memory is this

Run the shared contract's Universal preflight. A Fresh, Partial, or Wrong-folder result routes
to `/co-founder:co-founder-setup` (re-sync for Partial) and stops without creating a note or log row. On
Ready, read the charter's path map. Then classify the event into three shapes; one event can
produce several. Also read pending `queue.md` entries addressed to `bank`; review entries
point to the reviewed initiative and requested lesson rather than duplicating either.

- **Learning:** something was tried and taught something. Goes to `wiki/learnings/`.
- **Decision:** a call passing the shared contract's 3-test bar (hard to reverse,
  surprising without context, a real tradeoff). Goes to `wiki/decisions/` as its own page:
  base-five frontmatter (`type: decision`), 1-3 sentences of what and why, dated. Fails a
  test: it is not decision-log material, and logging it anyway is how decision logs die of
  noise. A `wiki/decisions/**` page is a T1 consent surface (shared contract, Immutable consent
  receipts): create it only with the founder's `[receipt: raw/inbox/<file>#<exact words>]` for the
  exact call, cited in the page. Absent a founder yes, write no decision page; a decision the
  founder never made is not banked as one.
- **Debrief:** a conversation happened (customer, partner, investor, prospect). STOP and read
  `references/debrief-extraction.md` before touching it: the eight extraction sections and
  their routing are the contract, and a debrief filed as one blob is a debrief lost.

Done when: the shapes present in this event are named.

## Step 1: Write the learning (when there is one)

The note follows the vault frontmatter with the money fields:

- `cost:` what it took. Dollars when real, time always counts ("2 hrs", "3 wks").
- `result:` what happened, in numbers where numbers exist ("reply rate 4% -> 9% on 50 sends").
- `status:` honest confidence: `high` only when the result would likely repeat.

Run the shared durable claim admission gate on `cost`, `result`, and every sentence in the lesson.
Reopen and quote the actual tracker or log row; a file path with blank totals is not a receipt.
Recompute calculated values from named inputs. When effort or outcome exists only in the founder's
recollection, write `Founder-stated: unverified`; when nobody supplied it, use `not recorded`
rather than manufacturing a plausible duration. Recheck original sources before carrying a claim
from review, content, or an older learning.

The shared parameter gate applies before filling any tidy-looking blank. Unknown effort, cost,
sample size, or result stays `not recorded` or founder-stated/unverified; the note shape never
justifies guessing a value.

**Ask before you assert:** never present a quantity, duration, sample size, date, or causal motive
in prose before asking the founder for it or citing a receipt for it.

The writing contract: what failed gets written as a failure, in plain words. A flop reported
as "mixed results" poisons every future recall that touches it. History stays honest per the
shared dedupe rule: when today's evidence reverses yesterday's note, the note becomes the
current truth with the old claim preserved as superseded (`supersedes:` link) and why. One
canonical truth, with its history visible.

Done when: the note exists with cost, result, confidence, and its sources.

## Step 2: Dedupe before filing

The shared dedupe rule, applied at EVERY destination this event
touches (learnings, decisions, people, the initiative), not just learnings: search
`index.md`, the fixed `hub/<section>.md`, and the target folder with the environment's file search. Found
substantially the same ground: UPDATE it. Fold the new evidence in, adjust the confidence,
bump `updated:`, note the supersession inside. Near-duplicates are how a vault rots into a
junk drawer where recall finds three half-truths instead of one truth.

Genuinely new ground: new note, base-five frontmatter whatever its type (person pages:
`type: person`, `status: stated`).

Done when: exactly one note carries this lesson, and it is the truest current version.

## Step 3: The findability check

Answer concretely: which recall query, next month, should surface this note, and would it?
Fix what fails the check: the title says the insight plainly (a title like "notes from
Tuesday" fails), the tags carry the topic words a founder would actually use, the fixed hub
links it, `index.md` lists it with a one-line summary.

Done when: the note is reachable through index, its fixed hub, and a plausible search.

## Step 4: Close the loops

- The event belongs to an initiative: add the dated line to that file's Log. The state flip
  has a hard guard: `state: banked` ONLY when the initiative currently reads
  `state: reviewed` AND this run has filed or updated at least one learning page and linked its
  exact path from the initiative. A decision-only or debrief-only run cannot close the arc.
  Lessons from any other stage (a gauntlet DIES, a mid-execution surprise) link from the
  initiative's Log with the state untouched; banking a lesson never advances a lifecycle the
  work has not earned.
  A legal `reviewed → banked` write also moves the initiative to the matching hub bucket and
  updates its index and baton projections before close.
- Append the vault log row: `## [date] learning | <title>` (or `decision` / `debrief`).
- When a queue entry triggered the work, mark that same ID done with the learning/decision paths
  only after those files and their index links are durable.
- Close in chat with the gist in two lines plus the file path. The note is the deliverable;
  the chat is just the receipt.

### Mandatory filing gate

1. Run `scripts/graph-audit` on every touched durable file.
2. Fix every violation and rerun it. Learning, decision, lifecycle, log, and queue writes remain
   incomplete until it exits zero.

Done when: initiative, log, index, and chat all point at the same banked memory.
