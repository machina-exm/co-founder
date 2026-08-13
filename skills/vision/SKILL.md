---
name: vision
description: >-
  Turn the fuzzy picture in the founder's head into a short, durable vision file every other
  skill measures against. Run when the user says "where is this going", "set the direction",
  "define the vision", "what's the strategy", at quarterly resets, or when plan's gate finds
  no vision file. A business planned against nothing drifts toward whatever was loudest this
  week.
---

# vision: the bar everything else measures against

The gauntlet attacks plans with it, review scores weeks against it, plan refuses to scope without
it. One short file, interrogated into existence once, revised deliberately, never
re-litigated by accident.

```
  the fuzzy picture
        |
  [ interrogate ]   diagnosis -> direction -> what gets sacrificed
        |
  [ checkpoint ]    one screen, founder says yes
        |
  wiki/business/vision.md   read by every skill, scored every week
```

## Step 0: Preflight

Read `${CLAUDE_SKILL_DIR}/../../CONVENTIONS.md` and run its Universal preflight. A Fresh,
Partial, or Wrong-folder result routes to `/co-founder:co-founder-setup` (re-sync for Partial) and stops
without writing. On Ready, read the charter and its path map before the vault.

Done when: the founder system is Ready and every path below comes from its charter.

## Step 1: Stub intake

A stub may exist at `wiki/business/vision-stub.md` (setup writes it).
Treat it as INPUT only, never as the canonical vision. Its recognized fields are business,
audience, quarter goal, and founder laws: map business + audience into a candidate
Direction, the laws into candidate sacrifices, the goal into This quarter. Diagnosis and
sacrifice are NOT in any stub; the interview below elicits them explicitly. The canonical
output is always `wiki/business/vision.md`, and once it exists the stub gets deleted.

## Step 2: The interview

One question per turn, a `Working hypothesis:` attached. It helps the founder react and does
not become consequential strategy advice unless it clears the shared receipts contract. The
vault first: past learnings, the decision log, and the current numbers inform every working
hypothesis you offer. Day zero with an
empty vault works too; the interview IS the input.

Walk three layers in order, and push back where the answers go soft:

1. **Diagnosis.** What is actually going on: the real constraint holding the business back,
   in one honest sentence. Push past symptoms ("not enough sales") to the constraint that
   causes them ("nobody knows the offer exists" is a different business than "people look
   and don't buy"). A diagnosis the founder has evidence for beats an aspiration every time;
   probe for the receipt behind it.
2. **Direction.** The guiding policy: the KIND of moves this business makes, and for whom.
   Fuzzy answers get the gap probes: who has actually paid, what is the smallest true
   version of this ambition, what would the founder bet a month on?
3. **Sacrifice.** What this direction deliberately gives up. A vision with no sacrifice is a
   wish. Get at least one real thing on the record the business will NOT chase this year,
   in the founder's words.

Then the quarter: ONE goal, measurable, theirs.

The quarter's target is founder-owned. Apply the shared parameter gate: when evidence invalidates
the old number and no replacement is supplied, ask for the replacement in one question or leave a
`Working hypothesis: unverified` under Needs your call. Never silently choose the new target or
overwrite the current one with a suggested number.

**Ask before you assert:** never present a quantity, duration, sample size, date, or causal motive
in prose before asking the founder for it or citing a receipt for it.

Done when: diagnosis, direction, sacrifice, and quarter goal each exist in the founder's
words with pushback survived.

Before the checkpoint, run the shared durable claim admission gate on every diagnosis, target,
and causal statement. Reopen each cited file and quote the supporting line. A founder's chosen
target is labeled `Founder-stated: unverified` until evidence verifies it; a working hypothesis
never becomes a silent target or a factual diagnosis.

## Step 3: The checkpoint

One screen: the diagnosis (2 lines), the direction (2-3 lines), the sacrifices (the not-list),
the quarter goal (1 line), and anything that Needs their call. Every line judgeable without
homework. Corrections integrate and the WHOLE screen re-presents; a revision is never a
confirmation.

Done when: the founder says yes to the exact text about to be written.

## Step 4: Write it

`wiki/business/vision.md`, base-five frontmatter (`type: business`) plus `strategy_state`
(`parked` or `cleared`), `internal_receipt`, and `external_receipt`, under 40 lines. A direction
is `cleared` only when the internal receipt points outside initiative/content output, the external
receipt points to a dated `type: research` file under `wiki/research/`, both use
`<path>#<quote-anchor>`, and graph-audit verifies them. Otherwise set `strategy_state: parked`, keep
the gap in `Parked recommendations`, and do not present the direction as ratified strategy.

The sections: Diagnosis · Direction · What we're not doing · This quarter · Review rhythm (one
line: scored weekly by review, revisited quarterly) · Claim receipts (the calculation, exact
quoted receipt, or founder-stated/unverified label for each factual or causal line). Reopen every
cited source at write time, then update `index.md`, link
`hub/business.md`, and append
`## [date] vision | <one-line direction>` to `log.md`.

On first canonical write, replace the vision-stub link with the vision link in both `index.md`
and `hub/business.md`, then delete `wiki/business/vision-stub.md`. Treat those four changes as
one close: the stub never leaves a dangling catalog or hub entry. Reconcile `baton.md` and any
pending pointer that names the retired stub in the same linked-state transaction.

A REVISION of an existing vision runs the same interview on what changed, and the change
itself gets tested: a direction change that is hard to reverse, surprising, and a real
tradeoff earns a decision row with its why. The old vision text survives inside the file
under "Superseded <date>": the business remembers what it used to believe.

### Mandatory filing gate

1. Run `scripts/graph-audit` on every touched durable file.
2. Fix every violation and rerun it. The vision write and any state projection remain incomplete
   until it exits zero.

Done when: the file exists at the charter's path, the log carries the row, and (revisions)
the supersession is on the record.

## Step 5: Hand off

Two lines: the direction in one sentence, and the ONE next move: an active initiative gets
re-checked against the new vision by review, a fresh start goes to plan ("what's the plan
for <the quarter goal>").

Done when: the founder knows what the file says and what reads it next.
