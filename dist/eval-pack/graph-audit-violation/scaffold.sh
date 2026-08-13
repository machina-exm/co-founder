#!/usr/bin/env bash
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../_fixtures/founder.sh"
write_ready_founder
write_initiative executing open
ruby -pi -e 'gsub("initiative_state: executing", "initiative_state: planned")' baton.md
