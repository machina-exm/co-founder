---
name: sprint
description: >-
  The daily driver. Open the session knowing exactly where the business stands and what the ONE
  next move is, then execute one roadmap step to done. Run when the user says "where are we",
  "what should I do today", "let's work", "start the day", "continue on...", or opens a
  session cold with no specific ask. Orientation is this skill's job, never the founder's
  memory.
---

# sprint: one step, finished, every session

Founders don't fail from missing strategy; they fail from open loops. Sprint closes them:
every session starts oriented, works exactly one step of the roadmap to done, and ends with
the state saved so tomorrow starts oriented too.

```
  session opens
       |
  [ standup ]   baton + active initiative -> 5 lines + ONE next move
       |
  [ gate ]      state must be planned/executing, or it routes to plan
       |
  [ one step ]  session-sized, finished completely, verified
       |
  [ close ]     box checked, fog graduated, baton rewritten
```

Before any step, read `${CLAUDE_SKILL_DIR}/../../CONVENTIONS.md`. This resolves from the
installed skill directory to the plugin's shared contract, independent of the founder's
working folder. Its state, receipts, and queue item rules govern this workflow.

## Step 0: Standup

Run the shared contract's Universal preflight. A Fresh, Partial, or Wrong-folder result routes
to `/co-founder:co-founder-setup` (re-sync for Partial) and stops without inventing a baton or
initiative. On Ready, read, in order: the charter, `baton.md` at the vault root (the last session's closing
note), the active initiatives in `wiki/initiatives/` (states `planned` or `executing`), and
any waiting "Needs your call" sections.

No active initiative is a legitimate first-use state. Say "Nothing is active" with the file
search that proved it. If `wiki/business/vision.md` is missing, propose exactly one focus:
run vision. If vision exists, read its quarter goal and propose exactly one focus: run plan on
that goal. Stop before the execution gate; there is no roadmap step to execute yet.

More than one initiative active: the tiebreaker is deterministic. Take the one `baton.md`
names if it is still active; otherwise prefer `executing` over `planned`, then the most
recent Log entry. Still tied: one question, with a recommended focus and the tie named.

Then report in AT MOST five lines: where things stand, what happened last session, what is
waiting on the founder, and exactly ONE suggested focus. One focus, never a list; a menu is
a decision pushed back onto the person who hired you to carry it. Every line cites where it
came from (file or log row); a fact you cannot source is reported as "not on record", never
improvised.

Accountability, factual and unheated: the last baton named a next move and any committed
dates. Compare against what actually happened. A slip gets stated plainly ("the pricing page
was the move, it didn't happen") and one question: what changed? The answer often belongs in
the roadmap or the vault; route it there.

Done when: the founder knows the state, the slippage if any, and the ONE proposed move, or the
zero-active route has handed them to vision or plan.

## Step 1: The gate

The chosen work's initiative must be exactly `planned` or `executing`. Every other state
refuses execution per the refusal shape in the shared contract (name the missing stage, ask the
first missing question): `idea` and `survived` route to plan (BIG ideas that have not faced the
gauntlet go there first), `reviewed` and `banked` are closed arcs whose renewed work needs a new `idea` with
`reopens:` pointing to the closed file, and an unknown or malformed state stops for repair,
never gets guessed around.
The founder's enthusiasm today does not outrank the gate; the gate is what their enthusiasm
hired.

A founder ask that is NOT on the active roadmap gets one explicit line before any work. The
ask matches a "Not yet decided" item whose answer is now visible: ask the one confirmation it
needs, then move it into Next steps as a session-sized checkbox. It matches nothing: it is
new scope and routes through plan first. Silent scope additions are how roadmaps become
fiction.

Apply the shared parameter gate to any new time block, due date, quantity, or completion threshold.
The roadmap can supply a recorded value; otherwise ask one question or leave an unverified
candidate. Sprint never invents a two-hour block to make a useful habit sound concrete.

Done when: the work about to start maps to one legitimate roadmap step.

## Step 2: Execute the one step

Starting the first-ever step on a `planned` initiative: set `state: executing` NOW, before
the work, with `updated:` bumped. The state says work has begun; an interrupted session must
not leave the file claiming otherwise.

Work the step with the founder to DONE, where done is the checkbox's own text, visibly
completed and verified in the session. The discipline:

- One step per session. The urge to start a second one goes into the roadmap, never into
  the session.
- Operational next moves cite the initiative or log that makes them next. Facts get the source
  appropriate to the claim (vault for this business, research for the outside world).
  Consequential recommendations use both legs and park if either is missing.
- Founder-only calls that would block progress go to "Needs your call" in the initiative
  file, and the work continues around them where it can.
- A step that turns out bigger than one session gets split honestly: finish the true
  session-sized core now, write the remainder as new steps. Say so out loud.

For a step containing "approve" or "publish," re-read the canonical content file before checking
the box. Approval requires `content_state: approved|published` plus a checked `approval_receipt`;
publication requires `content_state: published`, `published_at`, and a checked
`publication_receipt`. These are T1 consent surfaces (shared contract, Immutable consent receipts):
the receipt must cite the founder's exact words in immutable `raw/inbox/`. A wording edit or
founder-reported publication without those fields leaves the step unchecked. Graph-audit enforces
this relationship after the write.

**Ask before you assert:** never present a quantity, duration, sample size, date, or causal motive
in prose before asking the founder for it or citing a receipt for it.

Any business fact written during execution passes the shared durable claim admission gate at
write time. Reopen the cited source and quote the supporting line, recompute from named inputs, or
label the statement `Founder-stated: unverified`; a baton summary cannot verify its own claim.

Done when: the step's own completion text is true and shown to be true.

## Step 3: Close the session

In this order:

1. Recheck the step's literal completion condition and its canonical evidence. Check the box only
   when both are true; then add the dated line to the initiative's Log section.
2. Confirm the frontmatter reads `state: executing` (step 2 set it when work began). Move the
   initiative link to the executing hub bucket and update the index state/step summary; this is
   one linked-state transaction, not steward work deferred to later.
3. Graduate any "Not yet decided" entries the finished step made answerable into concrete
   next steps. The roadmap's frontier just moved; chart the newly visible ground.
4. Append `## [date] sprint | <step title>` to `log.md`.
5. Rewrite `baton.md` at the vault root: what happened this session, where the initiative
   stands, the ONE next move, open threads, anything waiting on the founder. Reference vault
   files by path, never duplicate their content.
6. Run `scripts/graph-audit` on every touched durable file.
7. Fix every violation and rerun it. Check the roadmap box, close the log/baton transaction,
   and declare the step done only after it exits zero.
8. Close with two lines to the founder: what got finished, and what tomorrow's move is.

Done when: a fresh session tomorrow could run its standup from the baton alone and lose
nothing.
