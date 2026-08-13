---
name: co-founder-setup
description: >-
  One-time setup for the /co-founder collection. Interviews the founder, writes their
  personalized business charter (AGENTS.md + CLAUDE.md), scaffolds their empty vault, and
  creates their voice file. Run when the user says "set up co-founder", "set up my co-founder",
  "get me started", or has just installed the plugin into an empty folder.
---

# setup: turn an empty folder into your business brain

One interview. Three artifacts. Everything else in this collection reads what you build here.

```
                    /co-founder:co-founder-setup
                           |
          one interview, ~8 questions, 15-20 minutes
                           |
         +-----------------+-----------------+
         |                 |                 |
     AGENTS.md          vault/          voice file
    (the charter)    (empty, ready)   (how you sound)
         |                 |                 |
    every skill       every lesson      every piece of
    reads this        lands here        content matches it
```

The founder is non-technical. Explain each move in plain English as you make it, and let them watch the files appear. The wow is "it made ME something", not "it ran a script".

## Step 0: Preflight

Read `${CLAUDE_SKILL_DIR}/../../CONVENTIONS.md`, then look at the current folder before
touching anything. Setup is the only skill that may create or repair the founder-system
signature defined there.

- Empty or near-empty folder: proceed fresh.
- A charter or vault from a previous run already exists: this is a re-sync, not a setup. Say so, then update only what changed (new skills into the trigger map, stale paths, renamed files). Everything the founder wrote stays.
- The folder holds unrelated work (someone's codebase, a downloads dump): stop and ask where their business folder should live. Recommend a fresh folder named after the business.

For every re-sync, STOP and read `references/migrations.md`. Detect `.co-founder-version`, show
one proposed migration patch, and get the explicit yes before changing founder files. A fresh
setup writes the current marker only after the complete scaffold passes its done check.

Done when: you know which of the three modes you are in, the version is known, and the founder
knows what is about to happen.

## Step 1: Detect the harness

Check which instruction files this environment reads.

- `AGENTS.md` or `CLAUDE.md` already present: you will extend, not overwrite.
- Neither: you will create `AGENTS.md` as the source of truth and link `CLAUDE.md` to it. On Windows, where links need admin rights, create a two-line `CLAUDE.md` containing `@AGENTS.md` instead.

Done when: you know exactly which file(s) step 4 will write.

## Step 2: The interview

One question per turn. Every question ships with a `Working hypothesis:` so the founder reacts
instead of composing from scratch; it is an interview candidate, not cleared advice. Facts you
can find yourself, find yourself; only decisions reach the founder.

The eight questions, in order:

1. **What is the business called, what does it sell, and to whom?** The name plus one sentence each. Push past vague ("coaching") to concrete ("a 6-week pricing course for freelance designers").
2. **What stage?** Pre-revenue, or making money, and roughly what monthly range. Ranges are fine, exact numbers are not required.
3. **The one goal for this quarter.** A single sentence. If they give three, ask which one wins.
4. **Pricing and margins, if known.** Skippable: pre-revenue founders skip it without shame. Whatever lands here powers the cash lens later.
5. **Non-negotiables.** Two or three lines they will not cross: a price floor, a channel they refuse, a brand line. These become their laws.
6. **Primary writing format.** X/posts or newsletter/email. These are the installed v1 pack;
   choose the one the founder will publish consistently. Additional channel packs appear here
   only after they are installed, so setup never promises craft the collection cannot run.
7. **How they sound.** Ask for 2-3 samples of their real writing (posts, emails). No samples: three adjectives plus one writer they admire. Either route feeds the voice file.
8. **Where the vault lives.** Recommend: right here, this folder. The business folder IS the vault.

A skipped question is recorded as skipped, never guessed at.

Before any answer becomes durable, apply the shared durable claim admission gate. Direct answers
are recorded as `Founder-stated: unverified` unless another checked source verifies them. Writing
samples can support observed voice traits; adjectives without samples remain founder-stated and
cannot produce `status: high`.

Apply the shared parameter gate to every missing range, target, cadence, confidence grade, and
capacity input. Ask when it blocks setup; otherwise record the skip or working hypothesis as
unverified. A plausible default does not become founder context.

**Ask before you assert:** never present a quantity, duration, sample size, date, or causal motive
in prose before asking the founder for it or citing a receipt for it.

### Arithmetic consistency gate

Before confirmation, separate direct inputs from derived numbers. Normalize currency, unit, and
time period, then recompute every derived value from the stated inputs with explicit arithmetic.
For example, `2 clients × €800/client/month = €1,600/month`; a stated total of €1,800 conflicts.
Show any mismatch as one equation and ask which input should change. Do not round, average,
silently repair, or present the derived total as confirmed while the mismatch remains.

Done when: every charter placeholder has either an answer in the founder's words or an explicit
skip, and every derived number recomputes exactly from its confirmed inputs.

## Step 3: Confirm back

Present the whole elicited profile on one screen: identity, stage, goal, laws, writing format,
voice notes, direct metrics, and each derived metric with its formula. Ask for one explicit yes.

Any correction: integrate it, re-present the full profile, and wait for the yes again. A revision is never a confirmation.

Done when: the founder has said yes to the exact profile you are about to write.

## Step 4: Write the charter

STOP. Read `references/charter-template.md` now: it holds the exact section order, the placeholder map, and the line budget. Writing the charter from memory produces a generic file, and a generic charter is the one failure this skill exists to prevent.

Fill the template with the founder's own words from step 2. Target under 150 lines. Then create the link per step 1's finding.

Done when: `AGENTS.md` exists, `CLAUDE.md` resolves to it, and every section carries their content, with zero unfilled placeholders.

## Step 5: Scaffold the vault and the voice file

STOP. Read `references/vault-scaffold.md` now: it holds the folder tree, the note frontmatter schema, the hub seeds, the README text, and the worked example page. The scaffold's value is its exact shape; improvising it breaks steward and recall later.

Create the tree, write `index.md` and `log.md` with their genesis entries, place the plain-English
README, seed the seven hub notes, and write the voice file to `wiki/business/voice.md` from the step-2
samples. Ship the worked example at the exact path
`wiki/learnings/example-learning-shape.md`, list it in `index.md`, link it from
`hub/learnings.md`, and tell the founder they can delete it.

The seven hub notes use the fixed filenames from the reference. Also seed `queue.md`,
`inbox-ledger.md`, `wiki/business/metrics.md`, `wiki/business/offer.md`, and the
`wiki/business/content/` and `wiki/business/reviews/` folders. These are runtime contracts, not
optional examples. Put only founder-confirmed answers from interview questions 2 and 4 into
dated metrics rows with `setup confirmation` as the source. A derived row is eligible only when
its stored formula recomputes exactly from named confirmed input rows; write that formula in the
Calculation column. An unresolved mismatch writes neither the total nor a receipt. Setup creates offer.md as an empty
shape with `offer_state: draft`; offer alone writes its audience, promise, price, and terms.

Create the vault's `scripts/` directory. Copy `${CLAUDE_SKILL_DIR}/references/graph-audit` into
it byte-for-byte as `scripts/graph-audit` and preserve executable mode (or set it where the
filesystem supports executable bits). This shipped program is part of the Ready signature; setup
never recreates its logic from prose.

During this step, `log.md` contains exactly the allowed genesis row
`## [date] setup | vault created`. Do not invent a `scaffold` verb. Do not write
`.co-founder-version` yet; the marker certifies the complete Step 6 system, not a partial tree.

Done when: the tree matches the reference exactly, both root ledgers and canonical business
files exist, the worked example is indexed and linked, and `log.md` carries only its genesis row.

## Step 6: Land the first artifact and hand off

Write a short vision stub to `wiki/business/vision-stub.md` with base-five frontmatter
(`type: business`, `status: stated`) and five body lines from the interview answers: what the
business is, who it serves, the quarter's goal, and the founder's laws in brief. List it in
`index.md`, link it from `hub/business.md`, and append exactly
`## [date] vision | stub for <quarter goal>` to `log.md`.

Run the final scaffold check: charter/link; README, index, log, baton, both ledgers; all seven
fixed hub notes; every fixed wiki folder; the executable `graph-audit` validator script; voice, metrics,
offer, vision stub, and the worked example.
For a fresh setup, `log.md` must contain exactly two event rows in order:
`## [date] setup | vault created`, then `## [date] vision | stub for <quarter goal>`. A missing
row or any other verb fails the check. Keep `.co-founder-version` absent until the mandatory
filing gate below passes.

### Mandatory filing gate

1. Run `scripts/graph-audit` across the complete fresh or migrated vault.
2. Fix every violation and rerun it. Write `.co-founder-version` containing `1.0.0` and declare
   setup done only after it exits zero.

Then close with exactly this shape:

1. Show what was built: the three artifacts, one line each.
2. Name the ONE next command: run `/co-founder:vision` to turn the stub into the real thing.
3. Name the sequence once: vision sets direction, plan creates the first initiative, then sprint
   becomes the daily entry point. Do not present sprint as executable before plan exists.

Never end on plumbing. End on what they own now that they did not own twenty minutes ago.

Done when: the two exact log rows and version marker exist, and the founder knows their three
artifacts, the vision → plan → sprint sequence, and the one next command.
