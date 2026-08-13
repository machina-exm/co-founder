# The debrief extraction

A call is the densest source of truth a founder touches all week, and it evaporates within a
day. The debrief extracts it into eight sections and routes each to the page where it
builds durable memory. Input: a transcript, recording notes, or the founder's fresh recollection
(interview them for it while it is fresh, one question at a time).

## The eight sections

Extract into these, quoting verbatim where the words themselves matter:

1. **What resonated.** The lines that made them lean in, VERBATIM. These are marketing copy
   the market just wrote for free.
2. **What confused them.** Where they asked for clarification or went quiet. Each one is a
   positioning bug.
3. **Objections.** What they pushed back on, in their words, and what answer was given.
4. **Questions we could not answer.** The exact question, unsoftened. These are homework.
5. **Positioning drift.** Anything the founder said that contradicts the charter's glossary,
   the voice file, or the vision. Quote both sides.
6. **Commitments and next steps.** Who said they would do what, by when.
7. **Proof gaps.** Claims made in the call that have no receipt yet behind them.
8. **Person updates.** Role, situation, preferences, relationship changes for everyone on
   the call.

A section with nothing in it gets "None." and no padding.

## The routing

Each extracted item moves to its home, using at every stop the shared dedupe rule already
loaded from `${CLAUDE_SKILL_DIR}/../../CONVENTIONS.md`. Every page created here carries the
base-five frontmatter (`type: person` pages
default `status: stated`; a person's own words are claims, not truths):

| Extraction | Routes to |
|------------|-----------|
| What resonated, objections + answers | `wiki/learnings/` (message/market lessons) and the relevant `wiki/people/` page |
| What confused them | `wiki/learnings/` as a positioning lesson; recurring confusion graduates to a decision to fix the positioning |
| Unanswered questions | "Needs your call" on the relevant initiative, or a research run offer |
| Positioning drift | flag to the founder NOW (challenge-on-contradiction), then the glossary or voice file gets corrected, whichever was wrong |
| Commitments | the relevant initiative's Log and Next steps; founder commitments surface at sprint's next standup |
| Proof gaps | `wiki/learnings/` tagged as proof-gap, feeding the receipts law |
| Person updates | the `wiki/people/` page (create it if the person matters enough to meet twice) |

## The close

One log row for the whole debrief: `## [date] debrief | <who, context>`. In chat: the three
most consequential findings, one line each, and where everything else landed. The founder
should feel the call got squeezed dry, in about two minutes of reading.
