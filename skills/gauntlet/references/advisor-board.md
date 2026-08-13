# The advisor board

Five specialists, each reading the founder's own files before opining. Generic personas give
generic advice; these lenses are loaded with THIS business. Each lens owns a bounded territory
and flags nothing outside it: overlap is how panels degenerate into five copies of the same
opinion.

## What every lens reads first

From the charter: the opening business description (the text before Laws), the laws, the
glossary. From the vault: the vision file, plus the lens's own files listed below. A listed
file or folder that is missing or empty gets recorded as "no vault receipt found for this
lens" and the lens proceeds from the available facts; it never invents a finding to fill the
gap. In standalone mode (no vault), each lens works from the interview's elicited facts and
says so in its findings.

## The five lenses

### 1. Customer
**Reads:** `wiki/people/` (customers), the glossary's ICP terms, `wiki/learnings/` tagged with
audience or channel.
**Owns:** willingness-to-pay evidence and buyer-language fit: would the actual named customer
want this, from this founder, judged by what they have already paid for and how they speak.
**Does not flag:** price math, floors, margins, brand tone, operational load. Other lenses own
those.

### 2. Cash
**Reads:** the charter's stage and margins, `wiki/learnings/` with `cost`/`result` fields,
pricing facts in `wiki/business/`.
**Owns:** ALL money math: unit economics, cash timing, runway impact, margins, and price-floor
law violations. Whether the math works at the founder's REAL volume.
**Does not flag:** demand or desirability (Customer owns those), or legal/trust exposure of
money promises (Risk owns that).

### 3. Brand
**Reads:** `wiki/business/voice.md`, the charter's identity and non-negotiable laws, past
positioning decisions in `wiki/decisions/`.
**Owns:** positioning, naming, promise clarity; contradictions with brand-specific laws and
past positioning decisions; whether the idea cheapens or confuses the promise.
**Does not flag:** whether it sells (Customer and Cash own that), price-floor laws (Cash),
or the always-ask law (Risk).

### 4. Ops
**Reads:** `wiki/sops/`, the active initiatives in `wiki/initiatives/`, the charter's rituals.
**Owns:** can one person actually run this alongside what is already executing; what breaks at
2x volume; which existing commitment this silently cannibalizes.
**Does not flag:** whether it is worth running. That verdict belongs upstream.

### 5. Risk
**Reads:** `wiki/decisions/` (what was ruled hard-to-reverse before), the always-ask law,
anything in the idea touching money, contracts, or public promises.
**Owns:** the irreversible parts, the worst plausible outcome and its cost, and legal or
trust-damaging exposure: public claims, guarantees, refunds, contracts, scarcity that is not
real, always-ask law violations.
**Does not flag:** ordinary execution difficulty (Ops owns that) or routine money math (Cash).

## Report format (each lens)

Three findings maximum, each one line: the issue, the receipt (file or elicited fact it rests
on), and severity LOW / SERIOUS. A lens with nothing real to flag reports "clear": padding a
report to look thorough is a failure.

Run the shared durable claim admission gate on each finding before it reaches the report. Reopen
and quote the cited passage or show the calculation. An interpretation without that support is a
question or `Founder-stated: unverified`, not a finding.

## Merge rules

1. Deduplicate by issue, never by wording.
2. **Corroboration upgrades:** the same admitted issue flagged independently by two lenses becomes
   SERIOUS regardless of individual ratings, and gets said first. Agreement cannot turn a shared
   unsupported assumption into evidence.
3. Order the merged list: corroborated issues, then SERIOUS, then LOW.
4. Every surviving finding keeps its receipt. A finding whose receipt cannot be named gets
   demoted to a question for the founder.
5. The merged findings feed back into the interrogation (Step 2) as the gauntlet's final round:
   the founder answers the board's strongest objections before any verdict.
