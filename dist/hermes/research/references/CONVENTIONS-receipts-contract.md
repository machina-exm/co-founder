## The receipts contract

Double receipts apply to a **consequential business recommendation**: go/no-go and strategy
calls, pricing or offer changes, customer-facing actions, spending or revenue moves, and
anything hard to reverse. Each such recommendation names both:

1. **Internal receipt:** an exact vault path to current evidence about this business, or a
   founder-confirmed current fact named in the active checkpoint and then recorded. A
   `stated` claim is quoted evidence, not verified truth.
2. **External receipt:** a checked, dated source gathered through research. Primary evidence
   or independently corroborated evidence outranks vendor repetition.

**Standalone gauntlet exception:** when no founder system exists, a founder-confirmed fact quoted
exactly from the active transcript may serve as the internal leg for that standalone run. The
external leg is still required. Any resulting verdict is prefixed `STANDALONE:`, expires with
the conversation, writes no state, and cannot authorize plan or execution. The founder must run
setup and repeat the gauntlet in full mode before the bet enters the durable workflow. Without a
checked external leg, standalone returns the normal `PARKED: external receipt missing` outcome.

Three neighboring classes stay precise:

- **Operational navigation** (which state exists, which roadmap step is next, where a file
  belongs) needs the internal file or log citation it came from, not an outside source.
- **Factual claims** use the receipt appropriate to the claim: vault evidence for this
  business, checked external evidence for the outside world. Public claims never borrow one
  kind of source to prove the other.
- **Interview suggestions** are labeled `Working hypothesis:` until the founder confirms
  them. They help the founder react; they are not advice cleared for action.

One leg missing has one outcome everywhere:

`PARKED: internal receipt missing` → run recall or elicit and record the missing business fact.

`PARKED: external receipt missing` → run research.

A parked recommendation does not ship as advice and cannot advance a readiness state. Evidence
gaps live under `Parked recommendations`; `Needs your call` is reserved for genuine founder
judgment after the available facts are present.

### Verified absence

Absence is bounded negative evidence only when the record names the corpus or paths checked, exact
queries plus obvious synonyms, date, search tool, and inspected-result count. It proves only `no
<thing> found in <checked corpus/search> as of <date>`. It never proves real-world nonexistence or
the opposite proposition. An empty SOP folder supports "no SOP is recorded in this vault," not
"the business has no SOP." A finite web search supports "no independent benchmark found in this
search," not "no benchmark exists."

Vault absence can satisfy operational navigation about what is recorded. External-search absence
cannot become the external receipt for SURVIVES or DIES; it establishes the missing evidence and
keeps the recommendation PARKED.

### Gate refusal is not a verdict

A checked missing prerequisite may withhold authorization or a state advance without two receipt
legs. This is operational enforcement of a recorded gate, not a claim that the bet will fail. Name
the missing prerequisite, keep the state unchanged, and use the canonical PARKED outcome. Do not
convert an evidence gap into DIES.

### Reversible internal experiments

A founder-confirmed workflow experiment may use one checked internal scorecard receipt without an
external leg only when it is internal, reversible, and has no customer-facing, money, legal,
strategic, or readiness-state effect. Record the founder's yes, review date, success condition, and
undo condition. Anything outbound, financial, strategic, hard to reverse, or state-advancing stays
consequential and needs both legs. Steward edits to existing memory still use its mutation approval
contract even when technically reversible.

### Mutation approval scope

Approval covers the exact proposed lines and nothing discovered later. A post-approval discovery
starts a new diff: stop, show the added mutation, and get a new yes before touching it. If approval
does not arrive, leave the item flagged and report the vault NOT CLEAN. An earlier broad "clean it
up" or approval of neighboring lines never expands consent.

### Prior-stage receipt preservation

An initiative is one append-only lifecycle artifact. A downstream owner patches its own headings
and preserves every prior-stage receipt, including the complete `## Gauntlet verdict`, advisor-board
findings, objections, exact receipt lines, and `## Log`. Scope links to the local Gauntlet verdict;
`log.md` is an event pointer, never storage for the board. Before a state flip, compare the
prior-stage sections with the pre-write snapshot. Any deleted or rewritten prior-stage receipt
aborts the transition and restores the preserved material.

### Immutable consent receipts (T1 surfaces)

Four surfaces are binding, zero tolerance: any `wiki/decisions/**` page, any price or term row in
`wiki/business/offer.md`, any `content_state: approved|published` transition, and any `Founder's
yes:` field. Each MUST carry an immutable consent receipt (`[receipt: raw/inbox/<file>#<exact
words>]` or a live-transcript anchor) pointing at the founder's actual words. At the moment the
founder gives the yes, capture their exact words into an immutable
`raw/inbox/session-receipt-<date>-<slug>.md` and cite that file.

No skill may create a decision page, write an approval or `Founder's yes:` field, or advance
content to `approved`/`published` without that receipt. If the founder's yes does not exist, the
decision page is not written, the approval field is not set, and the state stays `draft`/`parked`;
the skill says so plainly rather than manufacturing consent. A system-generated date, a one-word
edit, or an inferred agreement is not a founder yes. graph-audit enforces the content
`approval_receipt`/`publication_receipt` anchors against immutable `raw/inbox/` evidence, and the
same discipline governs decisions pages and offer terms.

### Quote on cite

Before writing any `[receipt: <path>#<anchor>]` pointer, or any `<path>#<quote-anchor>` receipt
field, reopen the cited file and carry the exact quote used as the anchor into the artifact beside
the pointer. graph-audit verifies that every receipt anchor (in frontmatter receipt fields and in
inline `[receipt: …]` tags alike) is a verbatim substring of the cited file. An anchor absent from
its source fails the gate; fix the quote or remove the citation.
