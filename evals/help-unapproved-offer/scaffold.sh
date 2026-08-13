#!/usr/bin/env bash
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../_fixtures/founder.sh"
write_ready_founder
ruby -pi -e 'gsub("offer_state: approved", "offer_state: draft")' wiki/business/offer.md
printf '%s\n' '---' 'type: initiative' 'title: "Raise price to 1,500 USD"' 'state: idea' 'size: big' 'status: stated' 'created: 2026-07-10' 'updated: 2026-07-10' 'reopens: null' '---' '# Raise price to 1,500 USD' '## The idea' 'Raise the current price. [founder-stated]' '## Gauntlet verdict' 'PARKED: internal receipt missing' 'Measure delivery hours before the gauntlet.' '## Log' '- [2026-07-10] offer: price move captured' > wiki/initiatives/raise-price.md
printf '%s\n' '- [Raise price](wiki/initiatives/raise-price.md) [state: idea] [roadmap: 0/0] [recomputed]' >> index.md
ruby -e 'path = ARGV[0]; text = File.read(path); text.sub!("## Idea", "## Idea\n- [Raise price](../wiki/initiatives/raise-price.md)"); File.write(path, text)' hub/initiatives.md
printf '%s\n' '## [2026-07-10] offer | Raise price to 1,500 USD' >> log.md
