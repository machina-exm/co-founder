# The initiative file

One file per initiative, living in `wiki/initiatives/`, named `<slug>.md`. Every skill in the
loop reads and writes THIS file: the gauntlet flips it to `survived`, plan to `planned`, sprint works
its roadmap and flips `executing`, review judges it, bank stores its lesson. The section
shape below is a contract, not a suggestion: sprint navigates by these exact headings.

```markdown
---
type: initiative
title: <one plain sentence naming the initiative>
state: idea           # idea | survived | planned | executing | reviewed | banked
size: big             # small | big (one-line reason lives in The idea)
status: high          # confidence in the file's claims: stated | high | low
created: <date>
updated: <date>
reopens: null        # path to a closed predecessor when this is a reopened arc
internal_receipt: null  # business evidence outside initiative/content output; required beyond idea
external_receipt: null  # dated wiki/research/<file>.md#<anchor>; required beyond idea
---
# <Title>

## The idea
<2-4 lines in the founder's words: what this is, who it is for, why now.
 Plus the sizing line: "Sized big: <reason>." or "Sized small, gauntlet waived: <reason>.">

## Gauntlet verdict
<Written only by the gauntlet: the outcome, full advisor-board findings, strongest objections,
 founder answers, exact receipt lines, what changed, and reopen condition. For a small waived
 bet: "Waived at sizing.">

## Scope
### What we're doing
<the confirmed checkpoint content, founder-approved>
### Key decisions
<each decision WITH its rationale and its receipt: "Priced at $X because <vault fact,
 file link> and <external source>.">
### Out of scope
<what this deliberately is not; this list never graduates into the roadmap>

## Roadmap
### Next steps
<ONLY what is visible now. Each step sized to one working session and finishable in it.
 Checkbox list; sprint completes exactly one per session:>
- [ ] <step, session-sized, concrete completion visible>
- [ ] <step>
### Not yet decided
<the fog: questions that can be STATED precisely now but not answered. Each graduates into
 Next steps when the frontier reaches it. State the question, never a guessed answer.>
### Stopped
<unchecked work deliberately closed after a founder-confirmed direction change. Each line names
the date and reason. "None." during ordinary execution.>

## Needs your call
<open questions only the founder can rule on. Unattended runs park here instead of guessing.>

## Parked recommendations
<evidence gaps only. Use exactly "PARKED: internal receipt missing" or "PARKED: external
receipt missing", then name the recall/research action. "None." when every recommendation is
cleared. Parked items cannot advance the initiative.>

## Log
<one line per event on this initiative, newest last, using the same verb names as log.md:
 - [date] plan: scope confirmed
 - [date] sprint: step "<step>" done>
```

## Fill rules

- **Stub before planning:** a file created before scoping completes starts at `state: idea`
  with whatever sections exist honestly filled. Plan sets `planned` only through the shared
  legal transition table and after the founder's explicit yes. A reopened reviewed/banked
  arc is a new `idea` whose `reopens:` points to the closed file. `state` is readiness; `status`
  is confidence in the file's claims: the two never substitute for each other.
- Replanning preserves state: `planned` stays `planned`; same-destination changes during
  `executing` stay `executing` and preserve checked steps. No skill rewinds a state.
- Prior-stage sections are durable receipts. Plan patches its own sections and preserves the
  complete `## Gauntlet verdict`, advisor board, objections, receipt lines, and append-only `## Log`
  byte for byte. Scope links to `[Gauntlet verdict](#gauntlet-verdict)`; `log.md` is only an event pointer.
  Snapshot and compare those sections before a state flip; any loss aborts the transition.
- A section that is intentionally empty carries "None.", never a blank.
- Session-sized means finishable, not started: a step the founder and the AI can complete and
  verify inside one sitting. "Launch the funnel" is a project; "draft the landing page copy
  and approve it" is a step.
- The fog test for Not-yet-decided entries: can the question be stated precisely now? State it
  there. Can it not even be stated yet? It belongs in Out of scope until it can.
- Consequential recommendations in Key decisions name both receipts: a `wiki/` file path and a
  checked external source. A missing leg uses Parked recommendations; Needs your call holds only
  founder judgment after the facts are present.
- Graph-audit requires checked `internal_receipt` and `external_receipt` fields for every state
  beyond `idea`. The internal leg points outside initiative/content output; the external leg
  points to dated checked research. Wording and small-bet waivers cannot change that invariant.
- The Log section is append-only and mirrors log.md verbs; never rewrite a past line.
