#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$root"

claude plugin validate --strict .
ruby scripts/validate_frontmatter.rb
ruby scripts/validate_evals.rb
ruby scripts/validate_round2_contracts.rb
ruby tests/graph_audit_test.rb
scripts/validator-demo

expected_version=1.0.0
version=$(ruby -rjson -e 'print JSON.parse(File.read(".claude-plugin/plugin.json"))["version"]')
test "$version" = "$expected_version"
grep -Fqx "## $expected_version — 2026-08-13" CHANGELOG.md
test -f LICENSE
test -f CLAUDE.md
test -L AGENTS.md
test "$(readlink AGENTS.md)" = CLAUDE.md
if find . -name .DS_Store -print -quit | grep -q .; then
  echo "tracked or untracked .DS_Store found" >&2
  exit 1
fi

temp=$(mktemp -d)
trap 'rm -rf "$temp"' EXIT
install_home="$temp/home"
HOME="$install_home" claude plugin marketplace add "$root" >/dev/null
HOME="$install_home" claude plugin install co-founder@co-founder --scope user >/dev/null
installed=$(HOME="$install_home" claude plugin list --json)
install_path=$(INSTALLED="$installed" VERSION="$version" ruby -rjson -e '
  plugins = JSON.parse(ENV.fetch("INSTALLED"))
  plugin = plugins.find { |entry| entry["id"] == "co-founder@co-founder" }
  abort "fresh install missing co-founder@co-founder" unless plugin
  abort "fresh install disabled" unless plugin["enabled"]
  abort "fresh install version mismatch" unless plugin["version"] == ENV.fetch("VERSION")
  print plugin.fetch("installPath")
')
details=$(HOME="$install_home" claude plugin details co-founder@co-founder)
grep -q "Skills (13)" <<<"$details"
for skill in bank content-engine steward gauntlet help offer plan recall research review co-founder-setup sprint vision; do
  grep -qE "Skills \(13\).*${skill}|  ${skill}[, ]" <<<"$details"
done
for skill_dir in "$install_path"/skills/*; do
  test -r "$skill_dir/../../CONVENTIONS.md"
done
test -r "$install_path/skills/co-founder-setup/references/vault-scaffold.md"
test -r "$install_path/skills/co-founder-setup/references/migrations.md"
test -x "$install_path/skills/co-founder-setup/references/graph-audit"

echo "install: co-founder@co-founder $version enabled; 13 skills registered from a fresh CLI install"
echo "release: manifests, metadata, frontmatter, eval schema, and installed cache paths valid for $version"
