#!/usr/bin/env bash
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../_fixtures/founder.sh"
write_ready_founder
rm wiki/business/vision.md
printf '%s\n' '---' 'type: business' 'title: "Vision stub"' 'status: stated' 'created: 2026-07-01' 'updated: 2026-07-01' '---' '# Vision stub' 'Business: pricing education.' 'Audience: independent designers.' 'Quarter goal: validate ten paid buyers.' 'Founder law: no fake urgency.' > wiki/business/vision-stub.md
