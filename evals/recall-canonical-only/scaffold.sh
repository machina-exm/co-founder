#!/usr/bin/env bash
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../_fixtures/founder.sh"
write_ready_founder
printf '%s\n' '---' 'type: content' 'title: "Draft price announcement"' 'status: stated' 'content_state: draft' 'channel: newsletter' 'published_at: null' 'created: 2026-07-09' 'updated: 2026-07-09' '---' '# Draft' 'The workshop costs 900 USD.' > wiki/business/content/draft-price.md
