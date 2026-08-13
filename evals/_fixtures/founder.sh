#!/usr/bin/env bash
set -euo pipefail

fixture_repo_root() {
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd
}

install_validator_scripts() {
  local repo_root
  repo_root=$(fixture_repo_root)
  mkdir -p scripts
  cp "$repo_root/skills/co-founder-setup/references/graph-audit" scripts/graph-audit
  chmod +x scripts/graph-audit
}

write_ready_founder() {
  mkdir -p raw/inbox raw/assets scratch hub wiki/{business/{content,reviews},initiatives,learnings,sops,research,decisions,people}
  install_validator_scripts
  printf '1.0.0\n' > .co-founder-version
  printf '%s\n' '# Northstar Studio: founder system' '' '## Laws' 'Use the gate and receipts contracts.' '' '## Where things live' '- Vision: `wiki/business/vision.md`' '' '## When you say X, I run Y' '| Ask | Skill |' '|---|---|' '| whether this is good | `gauntlet` |' '| how to build it | `plan` |' '| how to structure an approved price | `offer` |' > AGENTS.md
  printf '@AGENTS.md\n' > CLAUDE.md
  printf '%s\n' '# Index' '## Business' '- [Vision](wiki/business/vision.md)' '- [Voice](wiki/business/voice.md)' '- [Offer](wiki/business/offer.md)' '- [Metrics](wiki/business/metrics.md)' '## Content' '## Reviews' '## Initiatives' '## Learnings' '## SOPs' '## Research' '## Decisions' '## People' > index.md
  printf '%s\n' '# Log' '## [2026-07-01] setup | vault created' '## [2026-07-02] vision | Vision' '## [2026-07-10] offer | Pricing workshop offer' > log.md
  printf '%s\n' '---' 'type: baton' 'updated: 2026-07-10' 'active_initiative: null' 'initiative_state: null' 'roadmap_done: 0 # [recomputed]' 'roadmap_total: 0 # [recomputed]' 'next_step: null' 'content: {}' '---' '# Baton' 'No active initiative.' > baton.md
  printf '%s\n' '# Queue' '## Queue' > queue.md
  printf '%s\n' '# Inbox ledger' '## Entries' > inbox-ledger.md
  printf '%s\n' 'The founder chose the vision direction.' > raw/inbox/vision-confirmation.txt
  printf '%s\n' '---' 'type: business' 'title: "Vision"' 'status: high' 'strategy_state: cleared' 'internal_receipt: raw/inbox/vision-confirmation.txt#chose the vision direction' 'external_receipt: wiki/research/workshop-pricing.md#checked external comparable' 'created: 2026-07-02' 'updated: 2026-07-10' '---' '# Vision' '## Direction' 'Help independent designers price profitable projects.' '## This quarter [founder-stated]' 'Validate one paid workshop with ten buyers. [founder-stated]' > wiki/business/vision.md
  printf '%s\n' '---' 'type: business' 'title: "Voice"' 'status: high' 'created: 2026-07-01' 'updated: 2026-07-10' '---' '# Voice' '## Register' 'Direct, warm, concrete.' '## Words and moves they use' '- Short examples.' '## Never' '- Hype.' '## Approved samples' 'Price the work, not your anxiety.' > wiki/business/voice.md
  printf '%s\n' '---' 'type: business' 'title: "Offer"' 'status: stated' 'offer_state: approved' 'created: 2026-07-01' 'updated: 2026-07-10' '---' '# Offer' '## Audience' 'Independent designers.' '## Promise' 'Price a project confidently.' '## Ladder and price' 'Workshop: 500 USD. [founder-stated]' '## Terms and receipts' 'Founder-confirmed price; comparable in wiki/research/workshop-pricing.md.' '## Parked recommendations' 'None.' > wiki/business/offer.md
  printf '%s\n' '---' 'type: business' 'title: "Metrics"' 'status: high' 'created: 2026-07-01' 'updated: 2026-07-10' '---' '# Metrics' '| As of | Metric | Value | Source |' '|---|---|---|---|' '| 2026-07-09 | paid workshop buyers | 4 | founder confirmation | [founder-stated]' > wiki/business/metrics.md
  printf '%s\n' '---' 'type: research' 'title: "Workshop pricing"' 'status: high' 'created: 2026-07-03' 'updated: 2026-07-10' 'sources: ["https://example.com/primary"]' '---' '# Workshop pricing' 'A checked external comparable supports a 500 USD test. [unverified]' > wiki/research/workshop-pricing.md
  printf '%s\n' '---' 'type: business' 'title: "Business map"' 'status: high' 'created: 2026-07-01' 'updated: 2026-07-10' '---' '# Business' '## Canonical' '- [Vision](../wiki/business/vision.md)' '- [Voice](../wiki/business/voice.md)' '- [Offer](../wiki/business/offer.md)' '- [Metrics](../wiki/business/metrics.md)' '## Content' > hub/business.md
  printf '%s\n' '---' 'type: business' 'title: "Initiative map"' 'status: high' 'created: 2026-07-01' 'updated: 2026-07-10' '---' '# Initiatives' '## Idea' '## Survived' '## Planned' '## Executing' '## Reviewed' '## Banked' > hub/initiatives.md
  for section in learnings sops research decisions people; do
    printf '%s\n' '---' 'type: business' "title: \"$section map\"" 'status: high' 'created: 2026-07-01' 'updated: 2026-07-10' '---' "# $section" > "hub/$section.md"
  done
}

write_initiative() {
  local state="$1"
  local boxes="${2:-open}"
  local mark='- [ ] Draft and approve the workshop outline.'
  local done=0
  if [[ "$boxes" == complete ]]; then
    mark='- [x] Draft and approve the workshop outline.'
    done=1
  fi
  printf '%s\n' 'The founder chose the workshop pilot.' > raw/inbox/workshop-confirmation.txt
  printf '%s\n' '---' 'type: initiative' 'title: "Pilot the pricing workshop"' "state: $state" 'size: big' 'status: high' 'created: 2026-07-03' 'updated: 2026-07-10' 'reopens: null' 'internal_receipt: raw/inbox/workshop-confirmation.txt#chose the workshop pilot' 'external_receipt: wiki/research/workshop-pricing.md#checked external comparable' '---' '# Pilot the pricing workshop' '## The idea' 'Run one paid workshop for independent designers. [founder-stated]' '## Gauntlet verdict' 'SURVIVES. Demand and pricing receipts are present.' '## Scope' '### What we are doing' 'One live workshop. [founder-stated]' '### Key decisions' 'Price: 500 USD. [founder-stated]' '### Out of scope' 'A recorded course.' '## Roadmap' '### Next steps' "$mark" '### Not yet decided' 'None.' '## Needs your call' 'None.' '## Parked recommendations' 'None.' '## Log' '- [2026-07-09] sprint: outline done' > wiki/initiatives/pricing-workshop.md
  printf '%s\n' "- [Pilot the pricing workshop](wiki/initiatives/pricing-workshop.md) [state: $state] [roadmap: $done/1] [recomputed]" >> index.md
  ruby -e 'path, state = ARGV; text = File.read(path); heading = "## #{state.capitalize}"; text.sub!(heading, "#{heading}\n- [Pilot the pricing workshop](../wiki/initiatives/pricing-workshop.md)"); File.write(path, text)' hub/initiatives.md "$state"
  printf '%s\n' '## [2026-07-03] plan | Pilot the pricing workshop' >> log.md
  if [[ "$state" == planned || "$state" == executing ]]; then
    local next='Draft and approve the workshop outline.'
    [[ "$boxes" == complete ]] && next='null'
    printf '%s\n' '---' 'type: baton' 'updated: 2026-07-10' 'active_initiative: wiki/initiatives/pricing-workshop.md' "initiative_state: $state" "roadmap_done: $done # [recomputed]" 'roadmap_total: 1 # [recomputed]' "next_step: $next" 'content: {}' '---' '# Baton' 'Current work: wiki/initiatives/pricing-workshop.md.' > baton.md
  fi
}

write_legacy_founder() {
  mkdir -p raw/inbox raw/assets scratch hub wiki/{business,initiatives,learnings,sops,research,decisions,people}
  printf '%s\n' '# Legacy founder charter' '## Laws' 'Never discount below 400 USD.' '## When you say X, I run Y' '| idea | `gauntlet` |' > AGENTS.md
  printf '@AGENTS.md\n' > CLAUDE.md
  printf '%s\n' '# Index' '## Learnings' '- [Keep this](wiki/learnings/keep-this.md)' > index.md
  printf '%s\n' '# Log' '## [2026-06-01] setup | vault created' > log.md
  printf '%s\n' '---' 'type: learning' 'title: "Keep this"' 'status: high' 'created: 2026-06-02' 'updated: 2026-06-02' '---' '# Keep this' 'Founder-authored marker: PRESERVE-7F3A.' > wiki/learnings/keep-this.md
  printf '%s\n' '---' 'type: business' 'title: "Voice"' 'status: high' 'created: 2026-06-01' 'updated: 2026-06-01' '---' '# Voice' 'Founder-authored marker: VOICE-9C2D.' > wiki/business/voice.md
}
