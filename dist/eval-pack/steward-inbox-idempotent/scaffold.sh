#!/usr/bin/env bash
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../_fixtures/founder.sh"
write_ready_founder
printf '%s\n' 'Customers ask for a payment-plan example.' > raw/inbox/customer-note.txt
fingerprint=$(shasum -a 256 raw/inbox/customer-note.txt | awk '{print $1}')
printf '%s\n' '---' 'type: learning' 'title: "Customers ask for payment-plan examples"' 'status: stated' 'created: 2026-07-09' 'updated: 2026-07-09' '---' '# Customers ask for payment-plan examples' 'Filed once.' > wiki/learnings/payment-plan-example.md
printf '%s\n' "### $fingerprint" '- source: raw/inbox/customer-note.txt' '- processed: 2026-07-09' '- outputs: [wiki/learnings/payment-plan-example.md]' '- log_row: "## [2026-07-09] ingest | customer-note.txt"' >> inbox-ledger.md
printf '%s\n' '## [2026-07-09] ingest | customer-note.txt' >> log.md
