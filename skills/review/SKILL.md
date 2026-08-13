---
name: review
description: >-
  The weekly scorecard. What moved, what stalled, what the money did, measured against the
  vision file, then at most ONE change to how the business works, defended. Run when the user
  says "how's the week", "score me", "weekly review", "what did we get done", or at the
  charter's weekly ritual. Solo founders fail by thrash more than by laziness; this skill is
  the anti-thrash law.
---

# review: honest scorecard, one change, back to work

Diagnose freely, change the machine once. The founder who rebuilds their system every week
ships systems instead of shipping the business. Review makes the week legible, then enforces
the discipline that makes next week better instead of merely different.

```
  the week
     |
  [ evidence ]   log rows, learnings, decisions, roadmap movement
     |
  [ scorecard ]  vs wiki/business/vision.md, failures verbatim
     |
  [ ONE change ] at most one, defended, on the record
```

## Step 0: Preflight

Read `${CLAUDE_SKILL_DIR}/../../CONVENTIONS.md` and run its Universal preflight. A Fresh,
Partial, or Wrong-folder result routes to `/co-founder:co-founder-setup` (re-sync for Partial) and stops
without writing a review. On Ready, read the charter and path map.

Done when: the founder system is Ready and the review evidence paths are known.

## Step 1: Gather the evidence

Set the review period before scoring anything. Find the latest `type: review` page in
`wiki/business/reviews/`. For the first review, `period_start` is the date of the genesis
`setup` row in `log.md`; later reviews start the day after the latest `period_end`.
`period_end` is today. If the latest review already ends today, update that same review only
after explicit confirmation; never create an overlapping period.

Read that inclusive period slice, citing everything: `log.md` rows inside the boundaries, `baton.md`
and each active initiative's Log (the canonical record of what was COMMITTED: the named next
moves and dates that define "supposed to move"), learning notes written (with their
cost/result), decision rows, initiative movement (steps checked, states flipped, fog
graduated), anything still sitting in "Needs your call", and the previous review note's
"Next week's candidate" section, carried back as a candidate only, never as pre-approved
work. Read `wiki/business/metrics.md` as the financial source of record; each number must have a
dated source. Learning `cost`/`result` fields may explain a metric but never silently replace a
missing total. The vision file is the bar; no vision file means the review runs shallow and says so,
recommending the vision skill first.

Every claim in the scorecard traces to a row or a file. A week with thin logs gets reported
as thin on record, never reconstructed from vibes.

Apply the shared durable claim admission gate while gathering, not after scoring. Reopen every
cited file and quote the row that supports the claim. A one-row tracker proves one logged block,
not a 14-day measurement. Monthly recurring revenue is a run-rate, not weekly cash received or
weekly net. A founder-reported result with no instrument row is `Founder-stated: unverified`.
When a downstream note repeats a claim, check the original receipt instead of trusting the note.

Reconcile lifecycle evidence before scoring it. If the founder says a piece shipped, confirm the
date, update its canonical `content_state` and `published_at`, then reconcile its index/hub,
serving roadmap checkbox, publication metric, and eligible voice-sample reference. Until that
transaction is complete, report the statement as founder-stated/unverified and do not score the
piece as shipped. Apply the same rule to customer evidence and roadmap completion conditions.

Review never authors or reconstructs missing customer-facing copy. A reported publication can
advance an existing content file only when the vault already contains the exact published text.
If the founder reports another post but supplies no text, record only the bounded publication
claim as founder-stated/unverified, ask for the exact copy, and leave content lifecycle plus roadmap
unchecked. Content-engine owns any new draft.

Before moving content to `approved` or `published`, capture the founder's exact approval or
publication words in an immutable `raw/inbox/session-receipt-<date>-<slug>.md`. Set
`approval_receipt: <path>#<exact words>` and, for publication,
`publication_receipt: <path>#<exact words>`. An edit to one phrase is not whole-artifact approval.
Graph-audit rejects lifecycle state without these checked anchors. These are T1 consent surfaces
(shared contract, Immutable consent receipts): with no founder yes on record, review does not
advance the content state and does not write the approval field.

Done when: the week's facts are collected with their sources.

## Step 2: The scorecard

One screen, against the vision's quarter goal and direction:

- **Moved:** what actually advanced, with the receipt.
- **Stalled:** what was supposed to move and did not. Verbatim, unlaundered: "the pricing
  page did not happen" is a fact; "made progress on positioning" covering the same week is a
  lie with better manners.
- **The money:** what came in, what went out, what it says (from the period's dated rows in
  `wiki/business/metrics.md`, with learning cost/result as explanation; "not tracked for this
  period" is a legitimate, flagged entry).
- **The vault:** lessons banked this week, and notes now past their `review_after` date
  (flag the stale list for steward's next health-check).
- **Score vs the quarter goal:** on track / behind / off, in one line with the number that
  says so.

Done when: the founder sees the week as it was, not as it felt.

## Step 3: The one change

At most ONE change to how the business works this week: a system, a habit, a cadence, an
offer's mechanics. The founder proposes or picks from your recommendation; either way it gets
defended out loud: what problem this change solves, the evidence from the scorecard, what
would prove it worked by next review. Diagnosis is unlimited; surgery is rationed.

An internal, reversible workflow adjustment cites the scorecard evidence that motivates it; it
uses the shared reversible-internal-experiment contract: founder yes, review date, success
condition, and undo condition. It does not manufacture an outside source. A customer-facing,
money, strategy, readiness-state, or hard-to-reverse
change is consequential and clears both receipt legs before it can become the week's one change.
A missing leg parks the candidate in the shared canonical shape; it is not the chosen change.

The founder's explicit yes is a precondition, not prose review may supply. The `Founder's yes:`
field is a T1 consent surface (shared contract, Immutable consent receipts): capture the exact yes
in the immutable `raw/inbox/session-receipt-<date>-<slug>.md` and link it as
`[receipt: raw/inbox/<file>#<exact words>]` before writing the one change or any decision row.
Without that anchor, leave the candidate unchosen and write no `Founder's yes:` field; a supplied
date is never a substitute for the words.

**Ask before you assert:** never present a quantity, duration, sample size, date, or causal motive
in prose before asking the founder for it or citing a receipt for it.

Apply the shared parameter gate before making the change concrete. A duration, cadence, or target
comes from an admitted receipt or one founder question. Without it, recommend the behavior without
an invented number or preserve `Working hypothesis: unverified` as next week's candidate.

The urge for a second change goes on the record under "next week's candidate" and waits.
A change that is hard to reverse, surprising, and a real tradeoff earns a decision row.

Zero changes is a legitimate outcome; a machine that worked this week does not need
improving to feel productive.

Done when: at most one change is on the record with its defense, or none, said plainly.

## Step 4: Close the loop

Write the review note to `wiki/business/reviews/review-<period_end>.md` with base-five
frontmatter plus `type: review`, `period_start`, `period_end`, and `review_state: complete`.
List it in `index.md` under Reviews and link `hub/business.md`. The note's required sections:
the scorecard, the one change and its defense,
"Next week's candidate", **"Steward queue"** (notes past `review_after`, or "None."), and
**"Bank queue"** (reviewed initiatives and the lesson each should bank, or "None.").
For every non-None item, append a pending entry to `queue.md`: review → steward for stale
notes, review → bank for reviewed initiatives. Put the queue IDs in these note sections.
Queue items that live only in chat or inside a review paragraph are not queue items. Append
`## [period_end] review | <period_start> to <period_end>` to `log.md`.

`state: reviewed` has a checkable bar: the current state is exactly `executing`, every box under
the initiative's Next steps is checked OR the remaining unchecked work has been moved to
`Roadmap → Stopped` with a founder-confirmed date and reason, the scorecard names its outcome this week, "Needs your
call" is "None." or explicitly non-blocking, and Parked recommendations is "None." Re-read the
state immediately before writing it. `planned` work routes to sprint or state repair; `idea` and
`survived` route to their missing gate; `reviewed` and `banked` remain closed. Initiatives
passing the legal `executing → reviewed` transition get the state flip plus a Log line:
`- [date] review: outcome judged; hand to bank for <lesson topic>`.
Move each changed initiative to the matching hub bucket and update the index summary, baton,
roadmap conditions, and queue projection in the same linked-state transaction.

Quarterly cadence, deterministic: 12 `review` rows in `log.md` since the last `vision` row,
or 84+ days since `vision.md` was updated, adds a "Vision nudge" line to the note and the
close; the quarter goal just got scored 12 times, and the founder knows things they did not
know when they set it.

Close in chat: the score line, the one change (or none), the ONE next move.

### Mandatory filing gate

1. Run `scripts/graph-audit` on every touched durable file, including every created or reconstructed
   content artifact.
2. Fix every violation and rerun it. The review, founder approval, lifecycle changes, and queue
   writes remain incomplete until it exits zero.

Done when: the note is filed, the log row exists, and next week's review can measure this
week's change.
