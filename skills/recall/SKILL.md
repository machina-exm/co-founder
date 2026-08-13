---
name: recall
description: >-
  Check what the business already knows before deciding anything. Run when the user says "what
  do we know about...", "have we tried this before", "check the vault", "what did we learn
  about X", and AUTOMATICALLY before any gauntlet, plan, offer, or big decision, per the charter's
  recall-first ritual. Answering a business question from model memory when the vault holds the
  founder's real history is the failure this skill exists to prevent.
---

# recall: the vault answers first

The most expensive sentence an AI can say to a founder is "we have no notes on that" when the
notes exist. Recall reads before it speaks, cites what it finds by exact file, and admits
plainly when the vault is genuinely empty.

```
  the question
       |
  [ index ]     read index.md first, drill into pages
       |
  [ verify ]    list + grep BEFORE any "nothing on record"
       |
  [ answer ]    cited by file, confidence surfaced
       |
  [ bank ]      a real synthesis goes back into the vault
```

## Step 0: Preflight

Read `${CLAUDE_SKILL_DIR}/../../CONVENTIONS.md` and run its Universal preflight. A Fresh,
Partial, or Wrong-folder result routes to `/co-founder:co-founder-setup` (re-sync for Partial) and stops;
an absent vault cannot be searched honestly. On Ready, read the charter's path map.

Done when: the founder system is Ready and the catalog path is known.

## Step 1: Retrieve

Read `index.md` first: it is the catalog, and it says where to drill. Then read the pages
that plausibly bear on the question, plus the matching fixed `hub/<section>.md`. Search wide before answering
narrow: the useful lesson is often filed under the channel, the person, or the initiative
rather than the topic word.

Done when: every plausibly relevant page has been looked at, not guessed at.

## Step 2: The absence guard

Before saying anything shaped like "we have no note on that": list the relevant `wiki/`
folders and search the question's key words (and their obvious synonyms) across the vault
with whatever the environment has (rg or grep where present, the harness's search or
explicit listing plus reading otherwise, per CONVENTIONS). Absence gets VERIFIED, never
remembered: answering from memory instead of searching is the single most common way systems
like this fail. Genuinely empty: say exactly that, in one line, and offer the research skill
to fill it.

Any durable absence statement or queue item records the shared verified-absence fields: paths or
corpus, terms and synonyms, date, tool, and result count. Phrase only the scoped result. It can
prove what is not recorded in the vault, never what the business or world has never done.

Done when: presence and absence are both grounded in an actual look.

## Step 3: Answer with receipts

- Cite the exact file for every claim: `wiki/learnings/warm-intro-beats-cold.md`, not "our
  notes." Run the shared durable claim admission gate: reopen the file, verify its current
  lifecycle and confidence, and quote the exact supporting passage. Trace derived claims to their
  original inputs. A page that calls a draft approved, or mentions a topic without the claimed
  evidence, does not pass merely because recall found it.
- Surface confidence: a `stated` claim is repeated as a quote with its source, never as a
  truth. A `low` note gets its doubt said out loud.
- Read canonical lifecycle fields before using status words. An offer is approved only at
  `offer_state: approved` or `active`; publication exists only at `content_state: published` with
  `published_at`. Contradictory index or hub prose is reported as drift, not repeated as truth.
- Cross-file analogies and patterns pass the shared parameter gate. When no admitted receipt states
  the synthesis, label it `Unverified synthesis:` and offer the one founder question that could
  confirm it; rhetoric never upgrades itself into remembered fact.
- **Ask before you assert:** never present a quantity, duration, sample size, date, or causal motive
  in prose before asking the founder for it or citing a receipt for it.
- Notes past their `review_after` date get flagged as possibly stale.
- Feeding another skill (gauntlet, plan, offer): deliver a task-scoped mini-brief, the 5-10
  lines that bear on THIS decision, never a vault dump.
- Exclude every `type: content` page from business-fact receipts. Drafts are proposals, and
  approved/published pieces are publication history, not the source of truth. Use
  `wiki/business/offer.md` for the current offer and `wiki/business/metrics.md` for current
  numbers.
- This is the internal leg of the receipts law; when the question also needs external truth,
  say so and name research as the other leg.

Done when: the founder can click through to every fact in the answer.

## Step 4: Bank real syntheses

A recall that produced genuine new synthesis (a comparison, a pattern across notes, a
connection nobody had written down) is itself a finding. Append one pending entry to
`queue.md` addressed from recall to steward. The request carries the exact synthesis and the
`source_paths` list names every note it came from; recall reads, it never creates the wiki page.
Narrate the queue ID in one line. A synthesis that evaporates into chat history has to be paid
for again next month. Routine lookups do not get banked; the test is whether the answer contains
something no single existing page says.

### Mandatory filing gate

1. When recall writes a queue item, run `scripts/graph-audit queue.md`.
2. Fix every violation and rerun it. The queue item is not durable and no queue ID is narrated until
   it exits zero. A read-only lookup writes nothing and has no filing gate.

Done when: anything newly true has a durable pending queue ID, and everything else is cited.
