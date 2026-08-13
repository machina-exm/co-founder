#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
satellite="${HOME}/work/co-founder-hermes"
message=${1:-sync from co-founder}

if [[ $# -gt 1 ]]; then
  echo "usage: scripts/release_hermes.sh [commit-message]" >&2
  exit 2
fi

if [[ ! -d "$satellite/.git" ]]; then
  echo "gh repo clone machina-exm/co-founder-hermes \"$satellite\"" >&2
  exit 1
fi

if [[ -n $(git -C "$satellite" status --porcelain) ]]; then
  echo "satellite working tree is not clean: $satellite" >&2
  exit 1
fi

ruby "$root/tools/gen/generate.rb" tierC
# Hermes taps serve skills from the repo's skills/ subdirectory.
mkdir -p "$satellite/skills"
rsync -a --delete --exclude=.git --exclude=README.md "$root/dist/hermes/" "$satellite/skills/"

cat >"$satellite/README.md" <<'EOF'
# co-founder for Hermes Agent

The co-founder skill collection, packaged for Hermes. Generated from the main repo — do not edit here.

## Install

Copy and paste this one command into your terminal:

```bash
git clone --depth 1 https://github.com/machina-exm/co-founder-hermes /tmp/ak-hermes && mkdir -p ~/.hermes/skills/business && cp -R /tmp/ak-hermes/skills/* ~/.hermes/skills/business/ && rm -rf /tmp/ak-hermes && hermes skills list | grep business
```

You should see 13 skills listed under `business`. Then open your terminal IN your business folder and run `hermes`, and say "set up co-founder".

Why not `hermes skills install`? These skills write and maintain your business charter file
(`AGENTS.md`) — that is their whole job, and you approve every write. Hermes' remote-install
scanner flags ANY skill that touches agent instruction files, with no override, so the supported
path is this local install, which is Hermes' mechanism for skills you have chosen yourself.

## Update

Re-run the same install command. It replaces the skills with the latest version.
EOF

git -C "$satellite" add -A
git -C "$satellite" commit -m "$message"
