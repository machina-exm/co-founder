---
name: content-engine
description: >-
  The founder's content system for their ONE chosen channel (writing/X/newsletter in v1): posts,
  threads, and emails written in THEIR voice, from THEIR facts, with tested craft mechanics. Run
  when the user says "write the post", "content for this week", "turn this into a thread",
  "draft the newsletter", "hooks for X", "repurpose this", or any request to produce
  public-facing content. A generic ghostwriter output in someone else's voice is the failure
  this skill exists to prevent.
---

# content-engine: their voice, their facts, real craft

Content fails two ways for founders: it sounds like everyone else, or it claims things the
business cannot back. This engine runs on three inputs before any writing happens: the voice
file, the vault, and distilled craft mechanics. What comes out sounds like the founder and
survives fact-checking, or it does not ship.

```
  the content ask
        |
  [ voice ]     wiki/business/voice.md: register, moves, the never-list
        |
  [ facts ]     the vault: real lessons, real numbers, the positioning
        |
  [ craft ]     distilled mechanics: hooks, arcs, list growth, repurposing
        |
  [ check ]     voice drift? invented claims? then it ships
```

Before any step, read `${CLAUDE_SKILL_DIR}/../../CONVENTIONS.md`. This resolves from the
installed skill directory to the plugin's shared contract, independent of the founder's
working folder. Its receipts, filing, and dedupe rules govern this workflow.

## Step 0: Load the three inputs

Run the shared contract's Universal preflight. A Fresh, Partial, or Wrong-folder result routes
to `/co-founder:co-founder-setup` (re-sync for Partial) and stops without drafting or filing.

1. **The voice file** (`wiki/business/voice.md`): register, words and moves, the never-list,
   the approved samples. Missing: stop and route to setup (or its re-sync) to create it,
   because writing without it produces the generic ghostwriter this skill exists to prevent.
2. **The vault**: the positioning and glossary from the charter, relevant learnings and
   research dossiers, the vision's direction. Content is generated FROM these canonical
   facts, never from generic knowledge about the founder's industry.
3. **The channel scope** from the charter (chosen at setup). This skill's v1 craft block
   covers writing/X/newsletter. A legacy charter scoped to another channel routes to setup
   re-sync to choose an installed writing format, then stops. Additional channel choices become
   valid only when their mechanics packs are installed; generic video advice from a writing skill
   is the exact slop this collection refuses to ship.

Done when: voice, facts, and scope are loaded, or setup owns the named repair.

## Step 1: Scope the piece

One question at a time, recommended answer attached: what is this piece FOR (the job: grow
the list, warm the audience, sell the offer, bank authority), who exactly reads it, and what
single idea carries it. A piece with two jobs gets split. Content serving an active
initiative links to it; recurring content runs against whatever cadence is on record in the
vault or the active initiative, and where none exists, one scoping question sets it.

Done when: job, reader, and the one idea are stated in a line each.

Before drafting the first version, apply the shared parameter gate to every number, story detail,
outcome, and behavioral assertion the piece wants. Ask the founder for the exact claim or leave it
out and record an unverified hypothesis in Claim checks. Plausible copy is not shown first and
confirmed afterward.

**Ask before you assert:** never present a quantity, duration, sample size, date, or causal motive
in prose before asking the founder for it or citing a receipt for it.

## Step 2: Write with the craft block

STOP. Read `references/content-heuristics.md` now: hooks, structure and arcs, list growth,
email mechanics, and repurposing moves, each with its trap. They are distilled from
operators who publish at scale, and they are the difference between craft and vibes.

The writing rules that outrank everything in the craft block:

- **Voice first.** Every line passes the voice file: its register, its moves, nothing from
  its never-list. The approved samples are the calibration set; when a draft would not sit
  naturally beside them, the draft is wrong.
- **Facts from the vault, receipts on claims.** A number, a result, or a story about this
  business traces to a vault file; a claim about the outside world traces to checked research.
  A public call-to-action that recommends a consequential business move clears both receipt
  legs or stays out of the public body and is recorded in the draft's `Parked recommendations`
  section as `PARKED: internal receipt missing` or `PARKED: external receipt missing`, with
  the recall/research action. It never vanishes silently. Inventing a statistic for a
  founder's public post is the worst possible version of slop: it ships under THEIR name.
  No receipt: the claim comes out or gets researched.
- **Admission before prose.** Run the shared durable claim admission gate before a claim enters
  either the draft or its receipts section. Reopen the source, quote the exact supporting line,
  and verify subject plus unit: a client count cannot become a personal-post count or proof of a
  client outcome. Recompute derived claims from named inputs. Founder recollections stay
  `Founder-stated: unverified` until checked; do not turn them into confident hooks first.
- **Biographical claims are receipt-only.** Never assert a first-person fact about the founder:
  a duration ("for years", "two years"), a count ("four hundred posts"), a history ("I have always"),
  or a habit, unless those exact words appear verbatim in a `raw/` file or the live transcript.
  A client count is not a personal-post count; a metric is not a biography. If the vault does not
  contain the founder's own statement of the fact, the line comes out or is asked; the model never
  infers a biographical detail and then finds a receipt for the inference. This is the single bug
  that shipped the worst harm in three consecutive rounds, and it is a hard rule.
- **The glossary holds.** Content uses the founder's canonical terms; drift gets flagged
  and fixed before the draft lands, in whichever direction (the draft or the glossary) was
  wrong.

Done when: a draft exists that passes voice, receipts, and glossary in your own read.

## Step 3: The drift check, out loud

Before delivering, state the check results in one line each: voice (which sample it sits
beside), claims (each receipt named), glossary (clean or what was fixed). A draft failing
any check gets rewritten before the founder sees it, not annotated.

Done when: the founder receives a draft plus the three check lines, never a bare wall of
text.

## Step 4: File and close the loop

The filing is deterministic. Run the shared dedupe rule first (search
`index.md`, `hub/business.md`, `wiki/business/content/`), then write the piece to
`wiki/business/content/<date>-<slug>.md`. Frontmatter is the base five plus `type: content`,
`content_state: draft`, `channel`, `published_at: null`, and the serving initiative path or
null. Move to `approved` only on the founder's explicit approval; move to `published` and set
`published_at` only when the founder confirms publication. A draft is never a canonical business
fact. List it in `index.md` under Content, link `hub/business.md`, and append the one row:
`## [date] content | <piece>`. A piece serving an initiative also gets a dated pointer in that
initiative's Log; the draft text stays in its canonical file.

For approval or publication, capture the founder's exact words in an immutable
`raw/inbox/session-receipt-<date>-<slug>.md`. Approved content adds
`approval_receipt: <path>#<exact words>`; published content also adds
`publication_receipt: <path>#<exact words>`. A phrase edit does not count as whole-draft approval.
These `content_state: approved|published` transitions are T1 consent surfaces (shared contract,
Immutable consent receipts): with no founder yes captured, the state stays `draft`.
Published content cannot contain `[unverified]`; graph-audit blocks the transition if it does.

Every lifecycle change runs the linked-state transaction: update the index/hub summary, the
serving initiative's publication step, any publication metric, and voice-sample eligibility. A
founder-confirmed publication cannot remain `draft`; a draft cannot be counted as shipped.

Repurposing candidates get named while the piece is fresh (per the craft block's moves):
the one thing the founder approves can become several. Publishing and scheduling stay with
the founder: this environment writes drafts, the founder ships them.

### Mandatory filing gate

1. Run `scripts/graph-audit` on the complete content artifact and every other touched durable file.
2. Fix every violation and rerun it. The draft, lifecycle projections, and content event remain
   incomplete until it exits zero.

Done when: the draft is filed with explicit lifecycle state, logged once, and its repurposing
path is named.
