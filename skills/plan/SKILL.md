---
name: plan
description: >-
  Scope any idea, initiative, or "let's build X" through the readiness gates into an
  executable plan on one durable file. Run when the user says "what's the plan for...", "scope
  this out", "I want to launch...", or "how should we build X" after the founder has decided
  to proceed. A "whether" question belongs to the gauntlet. Also run when the founder hands over ANY
  build/execute request whose initiative is not yet planned. This skill is the gate that
  intercepts raw "go, build it" asks.
---

# plan: scope it properly, or don't build it at all

Every initiative gets ONE file that travels its whole life:

```
 idea ──> survived ──> planned ──> executing ──> reviewed ──> banked
              ^            ^
          the gauntlet  THIS SKILL
```

Plan owns the `planned` arrow. Work that reaches sprint without passing through here does not
run. That refusal is the whole point of the collection, and this skill is where it lives.

Before any step, read `${CLAUDE_SKILL_DIR}/../../CONVENTIONS.md`. This resolves from the
installed skill directory to the plugin's shared contract; the founder's working folder is
never used to locate it. Its state, receipts, filing, and dedupe rules govern this workflow.

## Step 0: Load the ground

Run the shared contract's Universal preflight. A Fresh, Partial, or Wrong-folder result routes
to `/co-founder:co-founder-setup` (re-sync for Partial) and stops without creating an initiative or vision
stub. On Ready, read the charter (AGENTS.md / CLAUDE.md), then check the charter-mapped vision
path immediately. If the canonical vision is missing, say the
founder is planning against nothing, route to vision, and stop without creating or sizing an
initiative, changing a queue entry, or writing a log row. Only after vision exists, consult the
vault: what does
`wiki/` already know about this idea, this customer, past attempts? Cite what you find by file.
Read pending `queue.md` entries addressed to `plan`; an offer queue item points to the canonical
`wiki/business/offer.md` rather than carrying copied terms. Then locate the initiative: an
existing file in `wiki/initiatives/`, or a new one.

Done when: you hold the charter's laws, the vault's relevant history, and the initiative file.

## Step 1: Size the stakes

One judgment, made out loud: SMALL (hours, reversible, no real money) or BIG (weeks, money,
customer-facing, hard to undo). Uncertain resolves to BIG. The size sets everything downstream:
question count, research depth, whether the gauntlet is required.

Done when: the size is stated in one line with its reason, in the initiative file.

## Step 2: The gate check

Check the stages in order, and stop at the first one missing:

- **BIG bet, state still `idea`**: route to the gauntlet first. One sentence of why ("this is
  weeks of your life, it gets interrogated before it gets planned"), then the queue item
  contract: leave the initiative as an `idea` stub, tell the founder to run the gauntlet on it,
  and write nothing further. The gauntlet alone flips `survived`; plan resumes after. A SMALL bet
  may proceed directly, recorded as: "Sized small, gauntlet waived."
- **BIG bet, state `survived`:** read the latest Gauntlet verdict. Only SURVIVES with no Parked
  recommendation may proceed; DIES or PARKED routes back to the named evidence gap without a
  state change.
- **The ask is raw execution** ("just build it", "go"): refuse the build, start the scope.
  Create at most an `idea` stub; the missing stage is `planned`, and the refusal shape from
  the shared contract carries the message: name the missing stage, ask the first missing question.
  Interviewed, never scolded.
- **State is already `planned`:** this is replanning, not a new transition. Preserve the state,
  run the checkpoint on the changed scope, and update the roadmap without erasing history.
- **State is `executing`:** a same-destination amendment preserves checked steps and stays
  `executing`. A changed destination creates a separate `idea` whose body links this initiative;
  `reopens` stays null because the predecessor is still active. With the founder's confirmation,
  move every unchecked old step to `Roadmap → Stopped` with today's date and the reason. Review
  records the stopped outcome on the old arc; the new idea earns its own gates.
- **State is `reviewed` or `banked`:** the arc is closed. New work gets a new linked `idea`;
  the closed file stays unchanged.
- **State is unknown or malformed:** stop for repair. Never infer the nearest legal state.

Done when: every required stage before `planned` is genuinely done, or the founder has been
routed to the one that is missing.

## Step 3: Scope the WHAT

One question per turn, recommended answer attached, founder's words captured. Facts you can
get yourself (from the vault, from research), get yourself. Probe only where a real gap shows:
what is the smallest version that still delivers, and what does the current workaround cost?
A concrete founder earns zero probes.

Then the checkpoint, before the Scope and Roadmap sections or any state change are written
(the `idea` stub and its sizing line may already exist). Present on one screen:

- **What we're doing** (2-3 lines in their words)
- **Key tradeoffs** (the calls made and why)
- **Out of scope** (what this deliberately is not)
- **Needs your call** (anything only they can rule on)

Every line must be judgeable without homework. Any correction: integrate, re-present the whole
checkpoint, wait for the yes again. A revision is never a confirmation.

Run the shared durable claim admission gate before this checkpoint and again before filing. Each
number, customer fact, and causal statement carries a recomputation, an exact checked quote from
an open source file, or `Founder-stated: unverified`. Earlier gauntlet or offer prose is not trusted
as a receipt merely because it is already durable.

Apply the shared parameter gate to durations, counts, caps, sequence assumptions, and completion
thresholds. Ask one founder question when a missing value blocks the scope; otherwise keep it as a
working hypothesis under Needs your call or Parked recommendations. Imported unverified offer or
gauntlet values never become roadmap commitments.

**Ask before you assert:** never present a quantity, duration, sample size, date, or causal motive
in prose before asking the founder for it or citing a receipt for it.

A `wiki/decisions/**` page is a T1 consent surface (shared contract, Immutable consent receipts):
plan may create one only with the founder's `[receipt: raw/inbox/<file>#<exact words>]` for the
exact call. Without that yes, record the tradeoff in Key decisions and write no decision page.

Done when: the founder has said yes to the exact scope about to be written.

## Step 4: Plan the HOW

STOP. Read `references/initiative-template.md` now: it holds the file's exact section shape and
the roadmap rules. An improvised structure breaks sprint's ability to execute it.

Snapshot every pre-existing prior-stage section before editing. Patch Scope, Roadmap, Needs your
call, and Parked recommendations in place; preserve the complete Gauntlet verdict, advisor board,
objections, exact receipt lines, and append-only Log. Scope links to `[Gauntlet verdict](#gauntlet-verdict)`.
`log.md` points to the event and never stores the board. Compare the preserved sections byte for
byte before the state flip; any loss aborts the transition.

Write decisions with their rationale, never task spam. Every consequential recommendation in
Key decisions carries both receipt legs from the shared contract: a vault fact and a checked
external source. A missing leg moves the item to `Parked recommendations` in the contract's
canonical shape; it never moves to "Needs your call" because evidence gathering is not a founder
judgment. The
roadmap section follows fog-of-war
discipline: chart in detail only what is visible now as session-sized steps, keep the rest in
"Not yet decided" where it graduates as the frontier advances, and keep "Out of scope" as the
list that never graduates.

Every initiative advancing beyond `idea` carries both checked references in frontmatter:
`internal_receipt: <path>#<quote-anchor>` to business evidence outside initiative/content output,
and `external_receipt: wiki/research/<file>.md#<quote-anchor>` to dated checked research. This is a
state invariant, independent of wording or size. Missing fields keep the initiative PARKED and
below `planned`.

Done when: the initiative file matches the template with zero empty sections (an honest
"Not yet decided" or "Parked recommendations: None." entry counts as content).

## Step 5: Flip the state and hand off

Re-read the current state immediately before writing. Set `state: planned` only for the legal
`idea → planned` SMALL waiver or `survived → planned` transition. Replanning stays `planned`; a
same-destination executing amendment stays `executing`. Any other state follows Step 2 instead
of moving backward. Bump today's date and append the log row:
`## [date] plan | <initiative title>`. Ensure `index.md` and `hub/initiatives.md` point to the
initiative under the bucket matching its current state, update the index roadmap summary and
`baton.md`, and reconcile the consumed queue entry as one linked-state transaction. Then close
with exactly two lines: what got decided
(one line), and the ONE next command: "say 'let's work' and sprint takes the first step."

When this plan consumes a queue entry, mark that same ID done with the initiative path only
after the initiative legally reaches `planned`. A route to vision, gauntlet, or receipts leaves the
entry pending.

### Mandatory filing gate

1. Run `scripts/graph-audit` on every touched durable file.
2. Fix every violation and rerun it. The plan, state transition, log, and queue completion remain
   incomplete until it exits zero.

Done when: the legal state is preserved or advanced, the log row exists, and the founder knows
the next move.
