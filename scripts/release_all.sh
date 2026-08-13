#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$root"

if [[ $# -gt 1 ]]; then
  echo "usage: scripts/release_all.sh [commit-message]" >&2
  exit 2
fi

message=${1:-release sync}
satellite="${HOME}/work/co-founder-hermes"

section() {
  echo
  echo "=== $1 ==="
}

section "GENERATE PORTABLE SURFACES"
ruby tools/gen/generate.rb tierB
ruby tools/gen/generate.rb tierC
ruby tools/gen/eval-pack.rb

section "VERIFY GENERATED TREES ARE CURRENT"
git diff --exit-code -- .agents .codex-plugin .kimi-plugin kimi.plugin.json dist

section "VERIFY CLAUDE IDENTITY"
bash scripts/check_claude_identity.sh check

section "RUN REPOSITORY VALIDATORS"
if [[ -x scripts/verify_release.sh ]]; then
  scripts/verify_release.sh
else
  validators=(
    scripts/validate_frontmatter.rb
    scripts/validate_evals.rb
    scripts/validate_round2_contracts.rb
  )
  for validator in "${validators[@]}"; do
    if [[ -f "$validator" ]]; then
      ruby "$validator"
    fi
  done
fi

if [[ -x scripts/run_native_evals.sh ]]; then
  if native_eval_output=$(scripts/run_native_evals.sh 2>&1); then
    printf '%s\n' "$native_eval_output"
  else
    native_eval_status=$?
    printf '%s\n' "$native_eval_output"
    if [[ "$native_eval_output" == '`plugin eval` is currently in early access' ]]; then
      echo "native eval: early-access gate tolerated"
    else
      exit "$native_eval_status"
    fi
  fi
fi

section "VALIDATE CLAUDE PLUGIN"
validation_output=$(mktemp)
trap 'rm -f "$validation_output"' EXIT
if ! claude plugin validate --strict . >"$validation_output" 2>&1; then
  cat "$validation_output"
  exit 1
fi
cat "$validation_output"

section "COMMIT HERMES SATELLITE"
if release_output=$(bash scripts/release_hermes.sh "$message" 2>&1); then
  printf '%s\n' "$release_output"
else
  release_status=$?
  printf '%s\n' "$release_output"
  if [[ "$release_output" == *"nothing to commit, working tree clean"* ]] &&
    [[ -d "$satellite/.git" ]] &&
    git -C "$satellite" diff --quiet &&
    git -C "$satellite" diff --cached --quiet; then
    echo "Hermes satellite already current; existing commit retained."
  else
    exit "$release_status"
  fi
fi

section "RELEASE SUMMARY"
ruby -rjson -e '
  manifests = {
    "Claude" => ".claude-plugin/plugin.json",
    "Codex" => ".codex-plugin/plugin.json",
    "Kimi" => "kimi.plugin.json"
  }
  manifests.each do |surface, path|
    version = JSON.parse(File.read(path)).fetch("version")
    puts "#{surface} version: #{version}"
  end
'
claude_files=$(find skills .claude-plugin -type f | wc -l | tr -d ' ')
for shared_file in CONVENTIONS.md AGENTS.md CLAUDE.md; do
  [[ -e "$shared_file" || -L "$shared_file" ]] && ((claude_files += 1))
done
codex_files=$(find .agents .codex-plugin -type f | wc -l | tr -d ' ')
kimi_files=$(find .agents/skills .kimi-plugin -type f | wc -l | tr -d ' ')
((kimi_files += 1)) # kimi.plugin.json
printf 'Claude files: %s\n' "$claude_files"
printf 'Codex files: %s\n' "$codex_files"
printf 'Kimi files: %s\n' "$kimi_files"
printf 'Hermes files: %s\n' "$(find dist/hermes -type f | wc -l | tr -d ' ')"
printf 'Eval-pack files: %s\n' "$(find dist/eval-pack -type f | wc -l | tr -d ' ')"
printf 'Satellite commit: %s\n' "$(git -C "$satellite" rev-parse HEAD)"
echo "Manual step: push satellite ($satellite)"
echo "Manual step: git tag the main release"
