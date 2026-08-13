---
name: gauntlet
description: >-
  The anti-yes-man. Interrogate any idea, plan, price change, or pitch like an investor until
  it survives or dies, one pointed question at a time, each with a recommended answer. Run
  when the user says "is this a good idea", "poke holes in this", "run this through the
  gauntlet", "stress-test this", "would you invest in this", "play devil's advocate", or
  pitches something and asks what you think. Flattery is never the answer; this skill is.
---

# gauntlet: the idea earns its life here

A cheerleader with a knowledge cutoff is worthless to a founder. The gauntlet asks the questions
an investor would, in the order a co-founder should, and it does not stop at the first
comfortable answer. Weak ideas die in five minutes here instead of five weeks in the wild.

```
        the pitch
            |
     [ mode check ]  full collection present? read charter + vault first
            |
     [ size check ]  quick poke ── small ideas, 2-4 questions
            |
     FULL GAUNTLET   one question at a time, recommended answers,
            |        walk the idea's tree until nothing is left standing
            |        on assumption
     [ deep tier ]   BIG bets: convene the advisor board
            |
        VERDICT      survives -> state: survived | dies -> buried with honors
```

## Step 0: Mode check

Read `${CLAUDE_SKILL_DIR}/../../CONVENTIONS.md`, then look for the charter (AGENTS.md /
CLAUDE.md) and the vault. Apply the shared Universal preflight without losing the gauntlet's
explicit standalone exception.

- **Full mode** (the Ready signature is present): read the charter's opening business description, laws, and
  glossary. Consult the vault for everything it knows about this idea's territory: past
  attempts, related learnings, the vision file. Cite by file. The gauntlet attacks with THEIR
  facts. Then locate or create the initiative file in `wiki/initiatives/` BEFORE any
  interrogation: if new, it starts as a stub with frontmatter (`type: initiative`, `title`,
  `state: idea`, `size`, `status: stated`, dates), `## The idea` holding the pitch, an empty
  `## Gauntlet verdict`, and `## Log`. Plan expands it to the full template later; the gauntlet
  owns only these headings. List a new stub in `index.md` and `hub/initiatives.md`.
- **Partial mode** (some structure exists): name what is missing, route to
  `/co-founder:co-founder-setup` in re-sync mode, and run the gauntlet verbally if the founder wants to
  continue. Write no files until setup repairs the signature.
- **Standalone mode** (nothing present): the gauntlet still runs, on interview-elicited facts
  alone, verbally, writing no files. Ask the two grounding questions first (what is the
  business, who pays). Quote the founder-confirmed answers in the transcript as the standalone
  internal receipt, then gather the checked external leg before any go/no-go verdict. Label a
  verdict `STANDALONE: SURVIVES` or `STANDALONE: DIES`: it expires with this conversation,
  writes no state, and cannot hand off to plan. Close by routing the founder to setup and a full
  re-run of the gauntlet before the bet enters the durable workflow. Missing external evidence uses the normal
  `PARKED: external receipt missing` outcome.

Done when: you know the mode, hold whatever ground truth exists, and (full mode) the
initiative file exists at `state: idea` or better.

## Step 1: Size the stakes

QUICK POKE for small, reversible, cheap ideas: 2-4 questions on the weakest points, verdict,
done in minutes. FULL GAUNTLET for anything with real money, weeks of work, or customer contact.
Uncertain resolves to the full gauntlet.

Done when: the tier is stated to the founder in one line.

## Step 2: The interrogation

The rules, non-negotiable:

- **One question per turn.** A wall of questions produces diluted answers.
- **Every question carries your recommended answer.** The founder reacts to a position, never
  stares at a blank. You are proposing while interrogating; that is the co-founder posture.
- **Facts are yours, decisions are theirs.** Anything findable (in the vault, by research) you
  find; only judgment calls reach the founder.
- **Attack with receipts.** A counterclaim cites their vault or a checked external source.
  A doubt with no receipt gets asked as a question, never asserted as a fact.
- **Walk the tree.** Resolve dependent questions in dependency order: who pays, before what
  it costs; what it replaces, before how it grows.

The five holes to probe, in this order, skipping any the founder has already filled:

1. **Demand proof.** What has a customer already PAID for or concretely done that says this is
   wanted? Interest is not evidence; behavior is.
2. **Workaround cost.** What do those people do today instead, and what does it cost them in
   money or hours? No painful workaround, no urgency.
3. **Unit economics.** What does one sale earn, what does it cost to get, and does the math
   survive at their real volume, not a fantasy volume?
4. **Smallest version.** What is the least that still delivers the value? Everything beyond it
   is attachment, and attachment is where budgets die.
5. **Timing and durability.** Why now, and does it still make sense if the obvious market
   shift happens? Push past answers every competitor could give.

A concrete founder gets few probes; a fuzzy one gets them all. The exit bar: every hole is
either filled with substance or conceded as fatal. Do not soften a concession into a maybe.

Before convening the board or writing a verdict, run the shared durable claim admission gate on
every number, conversion, absence, and causal statement. Reopen the named source and quote the
supporting passage. Revenue cannot become runway without a founder-stated cash balance and burn
calculation; an empty SOP folder proves only that no SOP is recorded there. Founder memories stay
`Founder-stated: unverified`, including remembered attendee counts and buyer behavior.

Apply the shared parameter gate to every board assumption the vault does not supply: hourly cost,
delivery cap, customer alternative, buyer behavior, capacity, or scarcity. Ask it as the next
gauntlet question or label it `Working hypothesis: unverified`; never use it as a finding, required
modification, fatal hole, or verdict input.

**Ask before you assert:** never present a quantity, duration, sample size, date, or causal motive
in prose before asking the founder for it or citing a receipt for it. Do not self-prime a fact
(a runway, an attendee count) and then ask a leading question to have it confirmed.

Done when: nothing important is still standing on an assumption.

## Step 3: The deep tier (BIG bets only)

STOP. Read `references/advisor-board.md` now: it defines the five lenses, their bounded
territories, and the merge rules. Improvised lenses overlap and dilute; the file is the panel.

Convene the board on the interrogation's survivors. Where the harness runs parallel agents,
run the lenses in parallel; where it does not, run them as sequential passes with a fresh eye
per lens. Merge per the reference.

Done when: each lens has reported inside its own territory and the merged findings are ranked.

## Step 4: The verdict

Every SURVIVES or DIES verdict is a consequential go/no-go recommendation, whatever the bet's
size. Both receipt legs must exist: an internal receipt and a checked external source. A missing
leg replaces the go/no-go verdict with the shared canonical `PARKED: internal receipt missing`
or `PARKED: external receipt missing`, plus the recall or research action. Enthusiasm cannot
turn a parked recommendation into a go decision.

Verified absence can enforce a missing-prerequisite gate, but it cannot supply the external leg or
upgrade PARKED to DIES. State the operational refusal, preserve the `idea` state, and name the
evidence that would clear the gate.

In standalone mode, apply the shared exception explicitly: quote the transcript fact used as
the internal leg, name the external source, prefix the outcome `STANDALONE:`, and state that it
cannot advance or authorize work. Never present a standalone verdict as a durable gate result.

Three outcomes, delivered plainly. In full mode, EVERY outcome writes the complete durable gauntlet
record into the Gauntlet verdict section: outcome, full advisor board, strongest objections, founder
answers, exact receipt lines, and reopen condition. Then append
`## [date] gauntlet | <title>` to `log.md`; a died idea's reasoning is the
most valuable thing this skill produces, and it never lives only in chat.

Re-read the initiative state before the verdict write. An `idea` may advance to `survived` only
on SURVIVES. Re-running the gauntlet on `survived` work updates the latest verdict but keeps the
state; DIES or PARKED then blocks plan until a later SURVIVES. `planned` or `executing` work never
moves backward: record the pressure test and route a same-destination change to plan as an amendment;
a changed destination becomes a new `idea`. A `reviewed` or `banked` arc stays closed and
any renewed bet becomes a new `idea` with `reopens:` pointing to it.

- **SURVIVES.** Say what made it survive and what changed under fire. For an `idea`, set
  `state: survived`; every later state stays unchanged. Then
  write the verdict (verdict, strongest objection, what changed). Then the ONE next move:
  "say 'scope this out' and plan takes it from here."
- **DIES.** Name the fatal hole in one sentence, honor what was good, and record what
  evidence would reopen it. State stays unchanged. Offer to bank a learning so the next
  idea starts smarter.
- **PARKED.** One missing fact decides it. Name the missing leg in the canonical shape, offer
  recall or research, state stays unchanged.

After the verdict write, run the linked-state transaction: place the initiative link in the hub
bucket matching its actual state, update the index summary and current baton, and reconcile any
queue entry that points at the verdict. A link that exists under the wrong bucket is stale.

### Mandatory filing gate

1. Run `scripts/graph-audit` on every touched durable file in full mode.
2. Fix every violation and rerun it. A durable verdict, state change, or log row is incomplete
   until it exits zero. Standalone mode writes nothing and has no filing gate.

The founder should leave knowing exactly why, never just what.

Done when: the verdict is delivered with its reasons, and in full mode the initiative file,
legal state, and log carry it whatever the outcome.
