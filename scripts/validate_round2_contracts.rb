#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"

ROOT = File.expand_path("..", __dir__)

def body(path)
  File.read(File.join(ROOT, path))
end

def require_text(path, *fragments)
  text = body(path)
  fragments.each do |fragment|
    abort "#{path} missing round-two contract: #{fragment}" unless text.include?(fragment)
  end
end

# Receipt-integrity adversary: a one-row tracker, monthly MRR, two clients, and revenue without
# burn inputs must never be promoted into a 14-day result, weekly cash, two personal posts, or
# runway. These checks bind the shared gate and the four skills that encountered those facts.
require_text(
  "CONVENTIONS.md",
  "## The durable claim admission gate",
  "Calculated.",
  "Quoted receipt.",
  "Founder-stated: unverified",
  "If a tracker has one row",
  "records two clients"
)

%w[co-founder-setup vision plan gauntlet research sprint review bank steward recall offer content-engine].each do |skill|
  require_text("skills/#{skill}/SKILL.md", "durable claim admission gate")
end

require_text("skills/review/SKILL.md", "A one-row tracker proves one logged block", "not weekly cash")
require_text("skills/bank/SKILL.md", "a file path with blank totals is not a receipt", "not recorded")
require_text("skills/content-engine/SKILL.md", "a client count cannot become a personal-post count")
require_text("skills/gauntlet/SKILL.md", "Revenue cannot become runway")
require_text("skills/research/SKILL.md", "none found in this search", "exact queries")
require_text("skills/co-founder-setup/SKILL.md", "cannot produce `status: high`")
require_text("skills/gauntlet/references/advisor-board.md", "Agreement cannot turn a shared")

puts "round2: receipt-integrity adversary passed"

# State-drift adversary: published content still marked draft, an executing initiative under a
# planned hub bucket, evidence-satisfied unchecked steps, stale summaries, and known-wrong close
# copy must all keep steward from declaring the vault clean.
require_text(
  "CONVENTIONS.md",
  "## Linked-state integrity",
  "A canonical change is a graph transaction",
  "NOT CLEAN: <n> unresolved contradictions"
)
require_text(
  "skills/steward/SKILL.md",
  "Treat the lint as a linked-graph sweep",
  "Lifecycle projections",
  "is absent is a contradiction",
  "rerun the graph from every changed node to a fixed point"
)
require_text("skills/review/SKILL.md", "do not score the", "piece as shipped", "matching hub bucket")
require_text("skills/content-engine/SKILL.md", "founder-confirmed publication cannot remain `draft`")
require_text("skills/offer/SKILL.md", "known-wrong or", "cannot remain in active close copy")
require_text("skills/recall/SKILL.md", "Read canonical lifecycle fields")

puts "round2: linked-state adversary passed"

# No-guessing adversary: no recorded delivery cap, spot count, buyer behavior, replacement vision
# target, or review-block duration. The skills must ask or preserve an explicitly unverified value.
require_text(
  "CONVENTIONS.md",
  "### The parameter gate",
  "ask one precise founder question",
  "is still invented. Heuristics choose the next question",
  "Heuristics choose the next question"
)
%w[co-founder-setup vision plan gauntlet research sprint review bank steward recall offer content-engine].each do |skill|
  require_text("skills/#{skill}/SKILL.md", "shared parameter gate")
end
require_text("skills/offer/SKILL.md", "delivery input, capacity, cap, spot count", "excluded from current terms")
require_text("skills/vision/SKILL.md", "Never silently choose the new target")
require_text("skills/review/SKILL.md", "duration, cadence, or target", "one founder question")
require_text("skills/content-engine/SKILL.md", "Plausible copy is not shown first")

puts "round2: no-guessing adversary passed"

# Contract-edge adversary: a bounded zero-result search cannot kill a bet; a reversible internal
# habit needs an undo test but no fabricated outside source; a seventh steward mutation needs a
# second approval; plan must preserve the complete gauntlet board.
require_text(
  "CONVENTIONS.md",
  "### Verified absence",
  "cannot become the external receipt for SURVIVES or DIES",
  "### Gate refusal is not a verdict",
  "### Reversible internal experiments",
  "### Mutation approval scope",
  "### Prior-stage receipt preservation"
)
require_text("skills/gauntlet/SKILL.md", "cannot supply the external leg", "complete durable gauntlet")
require_text("skills/research/SKILL.md", "shared verified-absence record")
require_text("skills/recall/SKILL.md", "paths or", "terms and synonyms", "result count")
require_text("skills/review/SKILL.md", "founder yes, review date, success", "undo condition")
require_text("skills/steward/SKILL.md", "later discovery starts", "new diff", "new yes")
require_text("skills/plan/SKILL.md", "preserve the complete Gauntlet verdict", "any loss aborts the transition")
require_text("skills/plan/references/initiative-template.md", "full advisor-board findings")

puts "round2: contract-edge adversary passed"

# Install/routing adversary: the marketplace identity matches the repository, a fresh process is
# required after CLI install, and help skips offer when the underlying money move is unapproved.
marketplace = JSON.parse(body(".claude-plugin/marketplace.json"))
plugin = JSON.parse(body(".claude-plugin/plugin.json"))
abort "marketplace name must match repository" unless marketplace["name"] == "co-founder"
abort "validator-gated release must be 1.0.4" unless plugin["version"] == "1.0.4"
require_text(
  "README.md",
  "claude plugin marketplace add machina-exm/co-founder",
  "claude plugin install co-founder@co-founder --scope user",
  "claude plugin details co-founder@co-founder",
  "opens a fresh session"
)
abort "README still recommends the unavailable reload command" if body("README.md").include?("/reload-plugins")
require_text(
  "skills/help/SKILL.md",
  "Complete the whole routing hop",
  "unapproved price/offer",
  "routes directly to",
  "gauntlet"
)
require_text("skills/co-founder-setup/references/charter-template.md", "design an unapproved offer/price")

puts "round2: install-and-routing adversary passed"
