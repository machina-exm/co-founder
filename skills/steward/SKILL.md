---
name: steward
description: >-
  Keep the vault true. Two jobs in one skill: capture (fold anything from the inbox or a
  finished run into the right wiki pages) and health-check (hunt contradictions, stale claims,
  orphan pages, and propose pruning). Run when the user says "file this", "add this to the
  vault", "process the inbox", "clean up the vault", "health-check my notes", or when bank,
  research, or recall hand something over for filing. A vault nobody maintains becomes a
  graveyard nobody trusts.
---

# steward: the vault stays true or it stops mattering

Humans abandon wikis because maintenance grows faster than value. Here the AI does the
maintenance, under two disciplines that decide everything: pages get REWRITTEN to current
truth, never appended into sediment, and something must regularly DELETE, or the vault
becomes a junk drawer recall can't trust.

```
  raw/inbox/  ──>  [ CAPTURE ]  discuss -> fold -> reconcile -> tag -> index
                        |
   wiki/      <──  rewritten pages, one truth per topic
                        |
  weekly      ──>  [ HEALTH-CHECK ]  contradictions, stale, orphans, graveyard
                        |
                   a short proposed diff, founder approves, then it happens
```

Retrieval stays the environment's file search plus `index.md` (per the shared contract: rg or grep
where present, listing and reading otherwise). No databases, no embeddings: at vault scale,
search is not the problem, truth is.

Before choosing a mode, read `${CLAUDE_SKILL_DIR}/../../CONVENTIONS.md`. This resolves from
the installed skill directory to the plugin's shared contract, independent of the founder's
working folder. Its receipts, filing, and dedupe rules govern this workflow.

## Step 0: Preflight

Run the shared contract's Universal preflight. A Fresh, Partial, or Wrong-folder result routes
to `/co-founder:co-founder-setup` (re-sync for Partial) and stops without moving inbox files or editing the
vault. On Ready, read the charter's path map before choosing Capture or Health-check.

Done when: the founder system is Ready and every proposed mutation has one mapped destination.

## Mode A: Capture

Runs on anything in `raw/inbox/`, anything pasted for filing, and queue items explicitly
marked not-yet-filed. At mode open, read pending `queue.md` entries addressed to `steward`;
their stable IDs are the idempotency key for queued work. Bank and research file their OWN
outputs; a queue item that already carries file paths and a log row gets no re-filing and no
`ingest` row, per the shared filing-ownership rule.

1. **Check the ledger before reading deeply.** A pasted source first lands as an immutable file
   in `raw/inbox/`. Compute the raw file's SHA-256 fingerprint and search `inbox-ledger.md`.
   Same fingerprint: report "already processed" with the recorded output paths and stop with no
   file or log changes. Same path with changed contents is a new fingerprint and may proceed.
2. **Read the source.** It stays in `raw/` untouched; `raw/` is the evidence locker.
3. **Discuss the takeaways** with the founder, one question at a time with a recommended
   answer: what matters here, and where does it file? A queue item from another skill that
   already settled this skips straight to folding.
4. **Fold, never append.** A real source touches several pages: update each affected page in
   place so it reads as ONE current truth. New information gets integrated into the sentence
   where it belongs; a page with "Update (July):" stapled to its bottom has already started
   rotting.
5. **Reconcile contradictions on contact**, per the shared dedupe rule:
   the page gets rewritten to the current truth, the old claim preserved as superseded and
   why. A contradiction that clears the 3-test bar (hard to reverse, surprising, real
   tradeoff) becomes a decision row too. Hoarding both versions and shrugging is the
   failure mode.
6. **Tag every claim** with confidence (`stated` / `high` / `low`) and money-link where real
   numbers exist. New pages carry the base-five frontmatter and a `review_after` date.
   Before a claim is folded or carried forward, run the shared durable claim admission gate:
   reopen and quote its source passage, recompute it from named inputs, or label it
   `Founder-stated: unverified`. A confidence tag never repairs a missing receipt.
   Apply the shared parameter gate to inferred corridors, ceilings, costs, and patterns. Ask for
   confirmation or preserve an unverified hypothesis; steward never canonicalizes an inference to
   make the vault look resolved.
   **Ask before you assert:** never present a quantity, duration, sample size, date, or causal
   motive in prose before asking the founder for it or citing a receipt for it.
7. **Show the patch, then close the books.** Existing pages about to change: present the
   short proposed patch first (pages created and updated, contradictions reconciled, index
   and fixed-hub changes) and get the yes; the founder's memory never mutates silently in capture
   any more than in health-check. A plain "file this" that creates new pages and changes no
   existing claim proceeds directly. Approval covers those exact lines. A later discovery starts
   a new diff and waits for a new yes; without it, leave the item flagged and report NOT CLEAN.
   Then: update `index.md` (every touched page, one line
   each), link the right fixed hub, append `## [date] ingest | <source>` to `log.md`, and run
   the findability test on anything new: which future search should surface this, and would it?
   For raw work, add the source fingerprint, outputs, and log row to `inbox-ledger.md`. For
   queued work, mark the same queue item ID `done` with its output paths after the files are durable.

Done when: the source's knowledge lives in rewritten pages, the catalog knows them, the ledger
proves raw-source processing is idempotent, and any queue entry is done.

## Mode B: Health-check

Runs weekly (review hands over its stale flags), or on demand.

Treat the lint as a linked-graph sweep, not a folder checklist. Seed it with every canonical file
changed since the latest `lint` row, every active initiative, the current offer, published or
approved content, due claims, and pending queue items. For each seed, follow explicit links and the
shared linked-state projections until no new node appears. Record each hit as: seed; linked
surfaces checked; contradiction; proposed resolution.

Sweep the vault for exactly these, citing files for every hit:

- **Contradictions:** two pages asserting incompatible things. Propose the reconciliation.
- **Stale claims:** `review_after` dates past due, and claims newer pages have quietly
  superseded. Propose the rewrite or the re-verification.
- **Orphans:** pages absent from their fixed hub and unlinked by every other page. Propose the link, or the merge into
  a page that earns one.
- **Graveyard notes:** low-confidence, never-cited, no-longer-true pages. Propose deletion.
  Something must delete; a pruning pass that removes nothing should be rare and said with
  evidence, not comfort.
- **Gaps:** questions the vault keeps almost-answering. Propose the research run that would
  close them.
- **Lifecycle projections:** initiative state versus its hub bucket, index summary and roadmap
  count, baton, completion evidence, and queue status; content publication state versus index,
  serving roadmap, publication metrics, and voice samples; offer state and known constraints
  versus its customer-facing close, linked initiative, and metrics. A checked box whose evidence
  is absent is a contradiction; evidence that satisfies an unchecked completion condition is a
  stale projection.

Deliver the whole sweep as ONE short proposed diff: what changes, what gets deleted, what
gets flagged, each line with its reason. The founder approves before anything mutates;
silent maintenance of someone's memory is not maintenance, it is editing history. Then
execute the approved lines, append `## [date] lint | <summary>` to `log.md`.

Approval is scoped to those exact lines. Anything discovered after the yes becomes a new proposed
diff and waits for a new yes; it is never folded into the approved batch. Without the second
approval, leave the new item untouched and flagged, then report NOT CLEAN.

Then rerun the graph from every changed node to a fixed point. Any surviving direct contradiction
ends with `NOT CLEAN: <n> unresolved contradictions` and their paths. It cannot be summarized as
clean or "nothing to fix."

An honestly clean vault gets a two-line "checked, nothing to fix" and no theater.

### Mandatory filing gate

1. Capture mode runs `scripts/graph-audit` with every touched durable file. Health mode runs it
   without a file list so it scans the complete durable vault.
2. Fix every violation covered by the approved diff, then rerun the validator.
3. A remaining violation blocks queue completion and a clean declaration. Report its exact output
   and use a new approval diff for any repair not already authorized.

Done when: the approved diff is applied, the log row exists, and every change traces to an
approved line.
