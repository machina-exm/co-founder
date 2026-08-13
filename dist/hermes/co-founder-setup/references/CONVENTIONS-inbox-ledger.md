## Inbox ledger

`inbox-ledger.md` is the idempotency boundary for raw capture. Before processing a source,
steward computes a SHA-256 content fingerprint with the environment's available checksum tool
and searches the ledger for the same fingerprint. Each processed entry records source path,
fingerprint, processed date, output paths, and the one `log.md` row. Same fingerprint means
already processed: report its outputs and write nothing. Same path with new contents gets a new
fingerprint entry and updates the existing canonical pages through dedupe. Raw files never move
or mutate.
