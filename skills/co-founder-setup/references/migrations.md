# Setup migrations

Re-sync is an in-place schema verification, not a second setup. Read the existing charter, index,
log, hub notes, baton, queue, and business files before proposing a patch. Founder-authored prose,
custom laws, history, raw sources, and unknown files survive byte-for-byte unless the founder
explicitly approves a content edit.

Every re-sync copies the plugin's `graph-audit` (shipped at the co-founder-setup skill's
`references/graph-audit`) into the vault's `scripts/graph-audit` byte-for-byte, preserves
executable mode, and runs graph-audit before confirming the version marker. Validator failures
stay visible and keep the re-sync incomplete.

## Detect the version

Read `.co-founder-version` at the business-folder root.

- `1.0.0`: verify the current scaffold and replace only missing or byte-different validator code.
  A clean vault produces no proposed changes.
- No marker but a co-founder-shaped charter/vault (an `AGENTS.md` charter plus the scaffold from
  `vault-scaffold.md`): propose one reconcile patch — create any missing scaffold file, copy the
  validator, run graph-audit to a clean exit, then write the `1.0.0` marker. Founder content is
  never rewritten to fit; contradictions are reported, not guessed into agreement.
- Any other value: report the unknown version and stop without writing. It comes from a build
  this release does not know how to migrate.

Done when: one vault remains, founder prose and history are preserved, graph-audit exits zero,
the marker reads `1.0.0`, and a second re-sync proposes no changes.
