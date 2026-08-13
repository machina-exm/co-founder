---
name: research
description: >-
  Live, verified, cited answers for business decisions. Run when the user says "look this up",
  "get me the real numbers on...", "what's the market doing", "is this actually true",
  "research X", or when any recommendation needs its external receipt. Run it BEFORE advising
  on anything the training data would otherwise answer from memory, because memory is not
  research.
---

# research: receipts or it doesn't ship

Advice built on training data is pattern-matching dressed as knowledge. This skill goes and
finds what is true right now, checks it, cites it, and files it where the business can use it
again. It is how every other skill earns the right to recommend anything.

```
  the question
       |
  [ tier ]      quick: minutes, 2-3 sources   standard: multi-angle
       |        deep (opt-in): fan-out + independent fact-check
       |
  [ sweep ]     best engines available, multiple phrasings
       |
  [ verify ]    corroborate across INDEPENDENT sources
       |
  [ file ]      full dossier -> wiki/research/    chat gets the gist + link
```

Before any step, read `${CLAUDE_SKILL_DIR}/../../CONVENTIONS.md`. This resolves from the
installed skill directory to the plugin's shared contract, independent of the founder's
working folder. Its receipts, filing, and dedupe rules govern this workflow.

## Step 0: Preflight

Run the shared contract's Universal preflight. A Fresh, Partial, or Wrong-folder result routes
to `/co-founder:co-founder-setup` (re-sync for Partial) and stops without researching or filing. On Ready,
read the charter's path map and the relevant vault context.

Done when: the founder system is Ready and the dossier destination is known.

## Step 1: Sharpen the question

Restate what is actually being decided, in one line, and confirm it. "Research newsletters" is
not a question; "what open rate should a 2k-subscriber list expect, so we can judge ours" is.
A question doing double duty gets split.

Done when: one decision-shaped question is agreed.

Apply the shared parameter gate to any business-specific premise needed to shape or interpret the
research. Search the vault, then ask the founder or label the premise as an unverified working
hypothesis. Search-tier mechanics are operational; the business inputs are not yours to fill.

**Ask before you assert:** never present a quantity, duration, sample size, date, or causal motive
in prose before asking the founder for it or citing a receipt for it.

## Step 2: Pick the tier

- **Quick:** a fact to check, minutes of work, 2-3 sources. Default for small stakes.
- **Standard:** a decision input, multiple angles, 5-8 sources.
- **Deep:** bet-the-business calls only, and the founder opts in (it costs real time and
  tokens): full fan-out plus the independent fact-check pass in step 4.

Uncertain resolves upward. State the tier and, for deep, get the yes first.

Done when: the tier is stated.

## Step 3: Sweep

Use the best engines this environment has, in this order of preference: dedicated search and
scrape tools if available (for example, Firecrawl or similar), social-pulse tools (recent
posts and community threads), then the harness's native web search and page fetching. The
engines vary by machine; the process never does.

Sweep rules:

- Multiple phrasings per question: the practitioner's wording, the vendor's wording, the
  skeptic's wording. One phrasing finds one bubble.
- Prefer primary sources over roundups: the study over the listicle, the pricing page over
  the review, the practitioner's own numbers over the guru's summary.
- Capture every candidate claim WITH its source as you go. An uncited claim does not exist.
- Record the exact query, engine, search date, and result count inspected for every negative
  finding. A finite search supports "none found in this search," never "none exists."

Done when: each angle of the question has candidate claims with named sources.

## Step 4: Verify

STOP. Read `references/verify-checklist.md` before grading any claim: it holds the three traps
that make false claims look corroborated, and skipping it is how slop gets certified.

Grade each claim: **verified** (independent sources agree), **stated** (one source claims it;
carried as a quote, never as truth), **contested** (sources disagree; both sides carried).
Deep tier adds the adversarial pass: each load-bearing claim gets a fresh check whose only job
is to break it, using the checklist.

Research findings may be external facts without pretending to know what this business should
do. A benchmark applied to this business, a "should" answer, or any other consequential
recommendation uses the shared receipts contract: one internal receipt and one verified external
source. One floor missing: deliver the factual findings, then write the recommendation in the
canonical `PARKED: internal receipt missing` or `PARKED: external receipt missing` shape and
name recall or research as the next action. Evidence gaps never move to "Needs your call".

Done when: every claim in the synthesis carries a grade and a source.

Run the shared durable claim admission gate before filing. Reopen every cited page and confirm the
passage supports the written claim. Preserve the short supporting quote beside the citation. A
source that disappeared or does not contain the evidence is removed; the claim is downgraded to
`stated` with its honest source or omitted. Negative findings carry the saved search scope rather
than upgrading verified search absence into a universal fact.

Use the shared verified-absence record for every zero-result finding. It may establish the bounded
gap and support a PARKED recommendation; it never supplies the external leg for a SURVIVES/DIES
call or proves that the missing fact does not exist.

## Step 5: File and deliver

Write the full dossier to `wiki/research/<slug>.md` with the universal wiki frontmatter, the
base five plus sources (`type: research`, `title`, `status` from the overall confidence,
`created`, `updated`, `sources:` list), then the question, the synthesis, every claim with
its grade and citation, `Parked recommendations` for missing receipt legs, and a "Needs your
call" section only for judgment forks the evidence cannot settle. Include a Search record with
the exact queries, engines, dates, and inspected-result counts. Update `index.md`, link
`hub/research.md`, and append
`## [date] research | <question>` to `log.md`.

In chat: the answer in 3-6 lines, the strongest receipt, the link to the dossier. Never paste
the dossier into chat; next month's question starts from the file, not from a re-run.

### Mandatory filing gate

1. Run `scripts/graph-audit` on every touched durable file, including the complete dossier.
2. Fix every violation and rerun it. The dossier and research event remain incomplete until it
   exits zero.

Done when: the dossier is filed, indexed, logged, and the founder has the gist with its link.
