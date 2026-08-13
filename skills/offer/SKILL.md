---
name: offer
description: >-
  Design the offer, price it, close it: tiers, caps, guarantees, anchors, launch timing, with
  operator-grade heuristics applied to the founder's real numbers. Run when the user says "price
  this", "design my offer", "how should I structure the price we've chosen", "build the tier
  structure", "add a guarantee?", "how do I launch the paid thing", or asks HOW to execute an
  approved pricing/packaging/monetization decision. "Should we change price?" belongs to the gauntlet.
  Generic pricing frameworks recalled from memory are not advice; this skill applies tested
  mechanics to THEIR business.
---

# offer: design it, price it, close it

Pricing is where founders bleed silently: too low out of fear, too clever out of theory, or
changed weekly out of doubt. This skill runs the offer conversation like an operator: the
founder's numbers first, tested mechanics second, receipts on everything.

```
  the offer question
        |
  [ ground ]     recall: their numbers, past pricing lessons, the vision
        |
  [ probe ]      wishful pricing dies here, before the market kills it
        |
  [ design ]     ladder -> price -> close -> launch, heuristics applied
        |
  [ receipts ]   their fact + external comparable, or PARKED
```

Before any step, read `${CLAUDE_SKILL_DIR}/../../CONVENTIONS.md`. This resolves from the
installed skill directory to the plugin's shared contract, independent of the founder's
working folder. Its receipts, filing, decision, and state rules govern this workflow.

## Step 0: Ground in their reality

Run the shared contract's Universal preflight. A Fresh, Partial, or Wrong-folder result routes
to `/co-founder:co-founder-setup` (re-sync for Partial) and stops without designing or filing an offer.
On Ready, recall first: stage and margins from the charter, every pricing-related learning and
decision in the vault, what customers have actually paid before, the vision's direction.
Cite by file. An offer designed against an imagined business fails in the real one.

Before sizing or creating anything, search `index.md` and every file in `wiki/initiatives/` for
the same destination and price move; titles alone are not a dedupe key. Record the matching path
and current state. An exact move gets one initiative for its whole lifecycle.

This is a money surface: the always-ask law applies to everything here.

Done when: their real numbers and history are on the table, or their absence is stated.

## Step 0.5: Size the move, and stop if it is BIG

Public price changes, repricing existing customers, and anything that materially moves
revenue are BIG. A truly small reversible test may size SMALL only when its bounded audience,
cost, rollback, and non-impact on existing customers are recorded. A BIG move
found here follows the dedupe result before any stub is created:

- **Exact `idea` or `survived` match:** reuse that file. An `idea` returns to the gauntlet; a `survived`
  file proceeds only when its latest verdict is SURVIVES with no parked recommendation.
- **Exact `planned` or `executing` match:** amend that initiative and preserve its state. If the
  approved Key decisions already contain this exact price move, offer may design the remaining
  terms against it. If the ask changes the approved move, route the change through plan's
  same-destination amendment checkpoint first. Never create or re-run the gauntlet on a parallel initiative.
- **Exact `reviewed` or `banked` match:** the arc is closed; a renewed move creates one new
  `idea` with `reopens:` pointing to the closed file.
- **No exact match:** create one new `idea` stub, append
  `## [date] offer | <initiative title>` to root `log.md`, add the same event to the initiative's
  local Log, and hand it to the gauntlet. Durable state creation always has a root event even when offer
  design stops at the gate.

No designing or recommending happens while a required gauntlet or plan amendment is pending. The
stub-creation event above is the invocation's one offer row. A genuinely small, reversible experiment proceeds only when sizing records it as
small; a BIG label has no experiment-shaped bypass. Discovering mid-design that the move needed
interrogation is discovering it too late.

Done when: the move is sized, and BIG moves are with the gauntlet instead of here.

## Step 1: Probe the wishful thinking

Inventory every parameter the design would need: delivery input, capacity, cap, spot count,
guarantee window, buyer behavior, and launch audience. Run each through the shared parameter gate
before applying a heuristic. A missing value gets one question or a parked/unverified label and is
excluded from current terms and customer-facing close.

**Ask before you assert:** never present a quantity, duration, sample size, date, or causal motive
in prose before asking the founder for it or citing a receipt for it.

Before designing anything, the pricing-specific gap probes, each only where a real gap
shows:

- **What has anyone actually paid?** The strongest pricing fact is a payment that already
  happened. Interest, compliments, and survey answers are not payments.
- **What is the price of the current alternative?** What the customer spends today (money
  or hours) bounds what the offer can charge.
- **Does the math survive their real volume?** Revenue fantasies use fantasy volume. Run
  the unit economics at the volume the vault supports.
- **Can they operationally honor what the price implies?** A cap, a guarantee, a
  service-heavy tier: each is a promise with an operating cost.

Done when: the design brief rests on facts, with the wishes named as wishes.

## Step 2: Design with the heuristics

STOP. Read `references/offer-heuristics.md` now: it holds the distilled operator mechanics
for ladders, caps, grandfathering, anchors, close sequence, guarantees, annual-versus-
monthly, urgency legality, and launch timing, each with its trap. Advising on an offer
without them is recalling generic frameworks, which is the thing this skill exists to
replace.

Apply them to THIS business, one decision at a time, recommended answer attached: the
ladder (what is free, what is gated, why), the price and its cap logic, the close (anchor,
sequence, guarantee window), the launch (timing signal, warm slice). Where a heuristic and
the founder's vault evidence disagree, the vault wins and the disagreement gets said.

Done when: each element of the offer has a recommendation with its mechanism and its trap
named.

## Step 3: Receipts before the recommendation ships

Every element of the final recommendation carries both legs: at least one fact about THEIR
business (a vault file: past payment, margin, churn, audience number) and at least one
checked external comparable (run research; category pricing, a real benchmark). A leg
missing moves that element to `Parked recommendations` in the shared canonical shape and
names recall or research as the next action. "Needs your call" is only for a judgment fork
after the evidence is present. No confident-sounding heuristic bypasses this: the heuristics
choose the QUESTIONS, the receipts justify the answers.

Done when: the founder can click through to why, on every number.

Run the shared durable claim admission gate on every proposed cap, duration, capacity, price,
buyer behavior, and urgency statement. Reopen each cited source and quote the exact supporting
passage; recompute capacities from recorded inputs. Anything supplied only by the founder is
`Founder-stated: unverified`. A heuristic supplies a question, never an invented input.

## Step 4: Bank it

The canonical home is always `wiki/business/offer.md`. Update it through the shared dedupe rule
with Audience · Promise · Ladder and price · Terms · Receipts · Parked recommendations · History.
Its base-five frontmatter carries `offer_state`: `draft` while any recommendation is parked,
`approved` after explicit founder confirmation with every receipt present, `active` only after
the founder confirms it is live, and `retired` when a successor takes over. Preserve superseded
terms in History with dates; one file carries current truth.

Every price or term row is a T1 consent surface (shared contract, Immutable consent receipts):
each carries `[receipt: raw/inbox/<file>#<exact words>]` pointing at the founder's actual words,
captured into an immutable `raw/inbox/session-receipt-<date>-<slug>.md` when the yes is given.
Offer may not move `offer_state` to `approved` or write a priced/term row as current truth without
that receipt. Absent the founder's yes, the price stays a parked recommendation and `offer_state`
stays `draft`; a system-generated date is never a founder-stated one.
Keep `index.md` and `hub/business.md` pointed at the canonical offer.
Before close, run the linked-state transaction across the offer's current constraints, its
customer-facing close, index summary, linked initiative decisions, and metrics. A known-wrong or
parked cap cannot remain in active close copy.

Then route without duplicating the design:

- **Execution work is needed** (a launch, a tier build): append a pending `queue.md` entry
  from offer to plan whose `source_paths` contains `wiki/business/offer.md`. Plan owns the
  initiative and marks the entry done after the initiative reaches `planned`.
- **An initiative already exists:** add the offer path plus the relevant rationale to Key
  decisions. The initiative points to the canonical terms instead of copying them.
- **The call passes the 3-test bar:** write the short dated decision page for history and link
  it from offer.md. It is part of this offer event, not a second event. A `wiki/decisions/**` page
  is a T1 consent surface: it may be created only with the founder's `[receipt: raw/inbox/<file>#<exact
  words>]` for the exact call. Without that yes, write no decision page and leave the term parked.

Append exactly one row: `## [date] offer | <what was designed>`.

Close in chat: the offer in three lines, the strongest receipt, the ONE next move.

### Mandatory filing gate

1. Run `scripts/graph-audit` on every touched durable file, including any initiative stub created
   while gating the offer.
2. Fix every violation and rerun it. Offer state, initiative creation, root event row, and queue
   writes remain incomplete until it exits zero.

Done when: offer.md holds the current design, exactly one log row records the event, and any
execution queue item has a durable queue ID.
