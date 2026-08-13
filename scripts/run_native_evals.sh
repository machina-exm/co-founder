#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$root"

claude plugin eval . \
  --scaffold \
  --ablation none \
  --runs 1 \
  --threshold 1 \
  --allow-tools Write Edit Bash WebFetch
