#!/usr/bin/env bash
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../_fixtures/founder.sh"
write_ready_founder
write_initiative executing complete
printf '%s\n' '## [2026-07-09] sprint | workshop outline' >> log.md
