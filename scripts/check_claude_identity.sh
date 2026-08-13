#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$root"

manifest=tools/gen/claude-baseline.sha256

usage() {
  echo "usage: scripts/check_claude_identity.sh record|check" >&2
  exit 2
}

build_manifest() {
  output=$1
  unsorted=$(mktemp)
  paths=$(mktemp)
  trap 'rm -f "$unsorted" "$paths"' RETURN

  git ls-files -z -- skills CONVENTIONS.md .claude-plugin AGENTS.md CLAUDE.md >"$paths"
  while IFS= read -r -d '' path; do
    if [[ -L "$path" ]]; then
      # Hash a symlink's target path string so identity never depends on resolved content.
      link_target=$(readlink "$path")
      digest=$(printf '%s' "$link_target" | shasum -a 256 | awk '{print $1}')
    else
      digest=$(shasum -a 256 -- "$path" | awk '{print $1}')
    fi
    printf '%s\t%s\n' "$path" "$digest" >>"$unsorted"
  done <"$paths"

  LC_ALL=C sort "$unsorted" | awk -F '\t' '{print $2 "  " $1}' >"$output"
  rm -f "$unsorted" "$paths"
  trap - RETURN
}

[[ $# -eq 1 ]] || usage

case "$1" in
  record)
    mkdir -p "$(dirname "$manifest")"
    temp=$(mktemp)
    trap 'rm -f "$temp"' EXIT
    build_manifest "$temp"
    mv "$temp" "$manifest"
    trap - EXIT
    count=$(wc -l <"$manifest" | tr -d ' ')
    echo "IDENTITY RECORDED ($count files)"
    ;;
  check)
    if [[ ! -f "$manifest" ]]; then
      echo "IDENTITY ERROR: missing manifest $manifest" >&2
      exit 1
    fi

    current=$(mktemp)
    findings=$(mktemp)
    trap 'rm -f "$current" "$findings"' EXIT
    build_manifest "$current"

    awk '
      FNR == NR {
        baseline[substr($0, 67)] = substr($0, 1, 64)
        next
      }
      {
        path = substr($0, 67)
        digest = substr($0, 1, 64)
        current[path] = digest
        if (!(path in baseline))
          print "ADDED " path
        else if (baseline[path] != digest)
          print "CHANGED " path
      }
      END {
        for (path in baseline)
          if (!(path in current))
            print "MISSING " path
      }
    ' "$manifest" "$current" | LC_ALL=C sort -k2,2 -k1,1 >"$findings"

    if [[ -s "$findings" ]]; then
      while IFS= read -r finding; do
        echo "IDENTITY $finding"
      done <"$findings"
      exit 1
    fi

    count=$(wc -l <"$current" | tr -d ' ')
    echo "IDENTITY OK ($count files)"
    ;;
  *)
    usage
    ;;
esac
