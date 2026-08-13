#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"
require "json"
require "yaml"

ROOT = File.expand_path("../..", __dir__)
RULES_PATH = File.join(__dir__, "rules.yml")
SOURCE_SKILLS = File.join(ROOT, "skills")
OUTPUT_SKILLS = File.join(ROOT, ".agents", "skills")
HERMES_SKILLS = File.join(ROOT, "dist", "hermes")
KIMI_MANIFEST_PATH = File.join(ROOT, "kimi.plugin.json")
KIMI_PLUGIN_DIR = File.join(ROOT, ".kimi-plugin")
KIMI_NESTED_MANIFEST_PATH = File.join(KIMI_PLUGIN_DIR, "plugin.json")
KIMI_COMMANDS_DIR = File.join(KIMI_PLUGIN_DIR, "commands")
CONVENTIONS_PATH = File.join(ROOT, "CONVENTIONS.md")
HERMES_DESCRIPTIONS_PATH = File.join(__dir__, "overrides", "hermes-descriptions.yml")
HERMES_BUILTINS_PATH = File.join(__dir__, "hermes-builtins.txt")
HERMES_DESCRIPTION_LIMIT = 57
HERMES_BUNDLE_REF_PATTERN = /(?:\]\(|[`\s"'])(?<path>(?:references|templates|scripts|assets|examples)\/[^\s)`"'<>]+)/

def mapping!(value, label)
  abort "#{label} must be a mapping" unless value.is_a?(Hash)
end

def load_rules
  rules = YAML.safe_load(File.read(RULES_PATH), permitted_classes: [], permitted_symbols: [], aliases: false)
  mapping!(rules, RULES_PATH)
  abort "unsupported rules schema" unless rules["schema_version"] == 1
  rules
end

def markdown_sources
  Dir[File.join(SOURCE_SKILLS, "**", "*.md")].sort
end

def assert_source_counts!(rules)
  expected = rules.fetch("expected_counts")
  skill_token = rules.dig("substitutions", "skill_dir_conventions", "source").sub("/../../CONVENTIONS.md", "")
  skill_files = markdown_sources + [CONVENTIONS_PATH]
  matching_skill_files = skill_files.select { |path| File.read(path).include?(skill_token) }
  skill_total = matching_skill_files.sum { |path| File.read(path).scan(skill_token).length }
  abort "skill_dir count mismatch: expected #{expected.dig('skill_dir', 'total')}, found #{skill_total}" unless skill_total == expected.dig("skill_dir", "total")
  abort "skill_dir file count mismatch: expected #{expected.dig('skill_dir', 'files')}, found #{matching_skill_files.length}" unless matching_skill_files.length == expected.dig("skill_dir", "files")

  route_token = "/co-founder:"
  skill_bodies = Dir[File.join(SOURCE_SKILLS, "*", "SKILL.md")].sum { |path| File.read(path).scan(route_token).length }
  charter = File.read(File.join(SOURCE_SKILLS, "co-founder-setup", "references", "charter-template.md")).scan(route_token).length
  route_total = markdown_sources.sum { |path| File.read(path).scan(route_token).length }
  abort "skill-body route count mismatch: expected #{expected.dig('routes', 'skill_bodies')}, found #{skill_bodies}" unless skill_bodies == expected.dig("routes", "skill_bodies")
  abort "charter route count mismatch: expected #{expected.dig('routes', 'charter_template')}, found #{charter}" unless charter == expected.dig("routes", "charter_template")
  abort "route count mismatch: expected #{expected.dig('routes', 'total')}, found #{route_total}" unless route_total == expected.dig("routes", "total")
end

def extract_section(source, heading)
  lines = source.lines
  index = lines.index do |line|
    match = line.match(/^(#+) (.+)$/)
    title = match && match[2].strip
    match && [2, 3].include?(match[1].length) && (title == heading || title.start_with?("#{heading} (") )
  end
  abort "missing CONVENTIONS section: #{heading}" unless index

  level = lines[index][/^#+/].length
  finish = ((index + 1)...lines.length).find do |candidate|
    match = lines[candidate].match(/^(#+) /)
    match && match[1].length <= level
  end || lines.length
  lines[index...finish].join.rstrip + "\n"
end

def conventions_sections(rules)
  source = File.read(CONVENTIONS_PATH)
  split = rules.fetch("conventions_split")
  core = split.fetch("core_sections").map { |heading| extract_section(source, heading) }.join("\n")
  references = split.fetch("reference_sections").to_h do |heading, skills|
    [heading, { "skills" => skills, "content" => extract_section(source, heading) }]
  end
  [core, references]
end

def replace_once!(content, source, replacement, label)
  count = content.scan(source).length
  abort "#{label}: expected one match, found #{count}" unless count == 1
  content.sub(source, replacement)
end

def normalize_route_grammar(content, rules)
  setup = Regexp.escape(rules.dig("substitutions", "route_setup", "tierB"))
  vision = Regexp.escape(rules.dig("substitutions", "route_vision", "tierB"))

  content = content.gsub(/routes\s+to\s+#{setup}/, "stops and runs the co-founder-setup skill before anything else")
  content = content.gsub(/points\s+to\s+#{setup}/, "stops and runs the co-founder-setup skill before anything else")
  content = content.gsub(/route\s+to\s+#{setup}/, "stop and run the co-founder-setup skill before anything else")
  content = content.gsub(/point them\s+to\s+#{setup}/, "tell them to stop and run the co-founder-setup skill before anything else")
  content = content.gsub(/run\s+#{vision}/, rules.dig("substitutions", "route_vision", "tierB"))
  content = content.gsub(/(\(re-sync for Partial\))\s+and stops\s+without/, "\\1, without")
  content = content.gsub(/(\(re-sync for Partial\))\s+and stops there/, "\\1")
  content = content.gsub(/(\(re-sync for Partial\))\s+and stops;/, "\\1;")
  content.gsub(
    "stops without writing and stops and runs the co-founder-setup skill before anything else",
    "stops and runs the co-founder-setup skill before anything else without writing"
  )
end

def apply_rules(content, rules, tier = "tierB")
  rules.fetch("substitutions").each do |name, rule|
    replacement = rule[tier]
    next unless replacement

    source = rule.fetch("source")
    if tier == "tierB" && name.start_with?("route_")
      content = content.gsub("`#{source}`", replacement)
      content = content.gsub(source, replacement)
    elsif tier == "tierC" && name.start_with?("skill_dir_")
      content = content.gsub("`#{source}`", replacement)
    else
      content = content.gsub(source, replacement)
    end
  end
  tier == "tierB" ? normalize_route_grammar(content, rules) : content
end

def apply_path_rewrites(content, relative_path, rules, tier = "tierB")
  portable_tier = tier == "tierC" ? "tierB" : tier
  rules.dig("charter_shim", portable_tier).select { |rewrite| rewrite.fetch("path") == relative_path }.each do |rewrite|
    content = replace_once!(content, rewrite.fetch("source"), rewrite.fetch("replacement"), "charter shim #{relative_path}")
  end

  skill_name = relative_path.split(File::SEPARATOR).first
  citation = rules.dig("reference_citations", portable_tier, skill_name)
  if citation && File.basename(relative_path) == "SKILL.md"
    content = replace_once!(content, citation.fetch("source"), citation.fetch("replacement"), "reference citation #{skill_name}")
  end
  content
end

def frontmatter(path, content = File.read(path))
  match = content.match(/\A---\n(.*?)\n---\n/m)
  abort "missing frontmatter: #{path}" unless match
  data = YAML.safe_load(match[1], permitted_classes: [], permitted_symbols: [], aliases: false)
  mapping!(data, "frontmatter in #{path}")
  [data, match]
end

def hermes_description_overrides
  overrides = YAML.safe_load(
    File.read(HERMES_DESCRIPTIONS_PATH),
    permitted_classes: [], permitted_symbols: [], aliases: false
  )
  mapping!(overrides, HERMES_DESCRIPTIONS_PATH)
  overrides.each do |skill_name, description|
    abort "invalid Hermes description override for #{skill_name}" unless description.is_a?(String) && !description.empty?
    abort "Hermes description override exceeds #{HERMES_DESCRIPTION_LIMIT} chars: #{skill_name}" if description.length > HERMES_DESCRIPTION_LIMIT
  end
  overrides
end

def hermes_name_overrides(rules, known_skills)
  overrides = rules.fetch("hermes_name_overrides", {})
  mapping!(overrides, "hermes_name_overrides")
  unknown_overrides = overrides.keys - known_skills
  abort "unknown Hermes name overrides: #{unknown_overrides.join(', ')}" unless unknown_overrides.empty?

  overrides.each do |source_name, emitted_name|
    unless source_name.is_a?(String) && !source_name.empty? && emitted_name.is_a?(String) && !emitted_name.empty?
      abort "invalid Hermes name override: #{source_name.inspect} => #{emitted_name.inspect}"
    end
  end
  overrides
end

def assert_unique_hermes_names!(emitted_names)
  duplicates = emitted_names.group_by(&:itself).select { |_name, matches| matches.length > 1 }.keys.sort
  abort "duplicate emitted Hermes skill names: #{duplicates.join(', ')}" unless duplicates.empty?
end

def assert_no_hermes_builtin_collisions!(emitted_names)
  builtins = File.readlines(HERMES_BUILTINS_PATH, chomp: true).map(&:strip).reject(&:empty?)
  collisions = emitted_names & builtins
  return if collisions.empty?

  abort "Hermes built-in skill name collision: #{collisions.sort.join(', ')}; add an override under hermes_name_overrides in #{RULES_PATH}"
end

def first_sentence(description)
  description[/\A.*?(?:[.!?](?=\s|\z)|\z)/m].to_s.strip
end

def automatic_hermes_description(description, skill_name)
  sentence = first_sentence(description)
  abort "empty automatic Hermes description: #{skill_name}" if sentence.empty?
  return sentence if sentence.length <= HERMES_DESCRIPTION_LIMIT

  lead = sentence.scan(/\S+/).each_with_object(String.new) do |word, candidate|
    addition = candidate.empty? ? word : " #{word}"
    break candidate if candidate.length + addition.length > HERMES_DESCRIPTION_LIMIT
    candidate << addition
  end
  abort "empty automatic Hermes description: #{skill_name}" if lead.empty?
  abort "automatic Hermes description cut mid-word: #{skill_name}" unless sentence.start_with?(lead) && sentence[lead.length] == " "
  lead
end

def hermes_skill_markdown(content, source_path, skill_name, emitted_name, overrides)
  data, match = frontmatter(source_path, content)
  original_description = data["description"]
  abort "missing source description: #{source_path}" unless original_description.is_a?(String) && !original_description.empty?

  description = overrides.fetch(skill_name) do
    automatic_hermes_description(original_description, skill_name)
  end
  header = "---\nname: #{emitted_name}\ndescription: #{description.inspect}\n---\n"
  body = content[match.end(0)..].sub(/\A\n/, "")
  "#{header}\n## When to use\n\n#{original_description}\n\n#{body}"
end

def rewrite_hermes_body_routes(content, source_skill_name, name_overrides)
  _data, match = frontmatter("generated Hermes #{source_skill_name}", content)
  body = content[match.end(0)..]
  name_overrides.each do |route_name, emitted_name|
    next if route_name == source_skill_name

    body = body.gsub(%r{(?<![A-Za-z0-9-])/#{Regexp.escape(route_name)}(?![A-Za-z0-9-])}, "/#{emitted_name}")
  end
  content[0...match.end(0)] + body
end

def apply_hermes_skill_body_rules(content, skill_name, rules)
  rules.fetch("hermes_skill_body_rewrites", {}).fetch(skill_name, []).each do |rewrite|
    content = replace_once!(
      content,
      rewrite.fetch("source"),
      rewrite.fetch("replacement"),
      "Hermes skill body rewrite #{skill_name}"
    )
  end
  rules.fetch("hermes_skill_body_substitutions").each_value do |rule|
    content = content.gsub(rule.fetch("source"), rule.fetch("replacement"))
  end
  content
end

def write_file(path, content, mode: nil)
  FileUtils.mkdir_p(File.dirname(path))
  File.binwrite(path, content)
  File.chmod(mode, path) if mode
end

def display_name(skill_name)
  skill_name.split("-").map(&:capitalize).join(" ")
end

def emit_skills(rules, core, reference_sections)
  FileUtils.rm_rf(OUTPUT_SKILLS)
  skill_dirs = Dir[File.join(SOURCE_SKILLS, "*")].select { |path| File.directory?(path) }.sort

  skill_dirs.each do |source_dir|
    skill_name = File.basename(source_dir)
    output_dir = File.join(OUTPUT_SKILLS, skill_name)
    Dir[File.join(source_dir, "**", "*")].sort.each do |source_path|
      next if File.directory?(source_path)

      relative_path = source_path.delete_prefix(SOURCE_SKILLS + File::SEPARATOR)
      output_path = File.join(OUTPUT_SKILLS, relative_path)
      mode = File.stat(source_path).mode & 0o7777
      if File.extname(source_path) == ".md"
        content = File.read(source_path)
        content = apply_rules(content, rules)
        content = apply_path_rewrites(content, relative_path, rules)
      else
        content = File.binread(source_path)
      end
      write_file(output_path, content, mode: mode)
    end

    write_file(File.join(output_dir, "references", "CONVENTIONS-core.md"), apply_rules(core, rules), mode: 0o644)
    reference_sections.each do |heading, section|
      next unless section.fetch("skills").include?(skill_name)

      slug = heading.sub(/^The /, "").downcase.gsub(/[^a-z0-9]+/, "-").sub(/^-/, "").sub(/-$/, "")
      path = File.join(output_dir, "references", "CONVENTIONS-#{slug}.md")
      write_file(path, apply_rules(section.fetch("content"), rules), mode: 0o644)
    end

    metadata = "interface:\n  display_name: \"#{display_name(skill_name)}\"\npolicy:\n  allow_implicit_invocation: true\n"
    write_file(File.join(output_dir, "agents", "openai.yaml"), metadata, mode: 0o644)
  end
end

def emit_packaging(rules)
  claude_manifest = JSON.parse(File.read(File.join(ROOT, ".claude-plugin", "plugin.json")))
  release_version = rules.fetch("release_version")
  manifest = {
    "name" => claude_manifest.fetch("name"),
    "version" => release_version,
    "description" => claude_manifest.fetch("description"),
    "author" => claude_manifest.fetch("author"),
    "homepage" => claude_manifest.fetch("homepage"),
    "repository" => claude_manifest.fetch("repository"),
    "license" => claude_manifest.fetch("license"),
    "keywords" => claude_manifest.fetch("keywords"),
    "skills" => "./.agents/skills/",
    "interface" => {
      "displayName" => claude_manifest.fetch("displayName"),
      "shortDescription" => claude_manifest.fetch("description"),
      "longDescription" => claude_manifest.fetch("description"),
      "developerName" => claude_manifest.dig("author", "name"),
      "category" => "Productivity",
      "capabilities" => [],
      "defaultPrompt" => "Help me run my business with co-founder."
    }
  }
  write_file(File.join(ROOT, ".codex-plugin", "plugin.json"), JSON.pretty_generate(manifest) + "\n", mode: 0o644)

  claude_marketplace = JSON.parse(File.read(File.join(ROOT, ".claude-plugin", "marketplace.json")))
  marketplace = {
    "name" => claude_marketplace.fetch("name"),
    "interface" => { "displayName" => claude_marketplace.fetch("description") },
    "plugins" => [
      {
        "name" => claude_manifest.fetch("name"),
        "source" => { "source" => "local", "path" => "./" },
        "policy" => { "installation" => "AVAILABLE", "authentication" => "ON_INSTALL" },
        "category" => "Productivity"
      }
    ]
  }
  write_file(File.join(ROOT, ".agents", "plugins", "marketplace.json"), JSON.pretty_generate(marketplace) + "\n", mode: 0o644)

  skill_names = Dir[File.join(OUTPUT_SKILLS, "*")]
    .select { |path| File.directory?(path) }
    .map { |path| File.basename(path) }
    .sort
  kimi_manifest = {
    "name" => "co-founder",
    "version" => release_version,
    "description" => claude_manifest.fetch("description"),
    "skills" => skill_names.map { |skill_name| "./.agents/skills/#{skill_name}/" },
    "commands" => skill_names.map { |skill_name| "./.kimi-plugin/commands/#{skill_name}.md" },
    "interface" => {
      "displayName" => claude_manifest.fetch("displayName")
    }
  }
  kimi_manifest_content = JSON.pretty_generate(kimi_manifest) + "\n"
  write_file(KIMI_MANIFEST_PATH, kimi_manifest_content, mode: 0o644)
  write_file(KIMI_NESTED_MANIFEST_PATH, kimi_manifest_content, mode: 0o644)

  FileUtils.rm_rf(KIMI_COMMANDS_DIR)
  skill_names.each do |skill_name|
    command = <<~MARKDOWN
      Start the #{skill_name} skill.

      Load and follow the `#{skill_name}` skill from `.agents/skills/#{skill_name}`, passing "$ARGUMENTS" through as the user's request.
    MARKDOWN
    write_file(File.join(KIMI_COMMANDS_DIR, "#{skill_name}.md"), command, mode: 0o644)
  end
end

def emit_hermes_skills(rules, core, reference_sections)
  skill_dirs = Dir[File.join(SOURCE_SKILLS, "*")].select { |path| File.directory?(path) }.sort
  known_skills = skill_dirs.map { |path| File.basename(path) }
  description_overrides = hermes_description_overrides
  unknown_description_overrides = description_overrides.keys - known_skills
  abort "unknown Hermes description overrides: #{unknown_description_overrides.join(', ')}" unless unknown_description_overrides.empty?
  name_overrides = hermes_name_overrides(rules, known_skills)
  emitted_names = known_skills.map { |skill_name| name_overrides.fetch(skill_name, skill_name) }
  assert_unique_hermes_names!(emitted_names)
  assert_no_hermes_builtin_collisions!(emitted_names)
  FileUtils.rm_rf(HERMES_SKILLS)

  skill_dirs.each do |source_dir|
    skill_name = File.basename(source_dir)
    emitted_name = name_overrides.fetch(skill_name, skill_name)
    output_dir = File.join(HERMES_SKILLS, emitted_name)
    Dir[File.join(source_dir, "**", "*")].sort.each do |source_path|
      next if File.directory?(source_path)

      relative_path = source_path.delete_prefix(SOURCE_SKILLS + File::SEPARATOR)
      output_relative_path = source_path.delete_prefix(source_dir + File::SEPARATOR)
      output_path = File.join(output_dir, output_relative_path)
      mode = File.stat(source_path).mode & 0o7777
      if File.extname(source_path) == ".md"
        content = File.read(source_path)
        if File.basename(source_path) == "SKILL.md"
          content = hermes_skill_markdown(content, source_path, skill_name, emitted_name, description_overrides)
        end
        content = apply_rules(content, rules, "tierC")
        content = apply_path_rewrites(content, relative_path, rules, "tierC")
        if File.basename(source_path) == "SKILL.md"
          content = rewrite_hermes_body_routes(content, skill_name, name_overrides)
          content = apply_hermes_skill_body_rules(content, skill_name, rules)
        end
      else
        content = File.binread(source_path)
      end
      write_file(output_path, content, mode: mode)
    end

    write_file(
      File.join(output_dir, "references", "CONVENTIONS-core.md"),
      apply_rules(core, rules, "tierC"),
      mode: 0o644
    )
    reference_sections.each do |heading, section|
      next unless section.fetch("skills").include?(skill_name)

      slug = heading.sub(/^The /, "").downcase.gsub(/[^a-z0-9]+/, "-").sub(/^-/, "").sub(/-$/, "")
      path = File.join(output_dir, "references", "CONVENTIONS-#{slug}.md")
      write_file(path, apply_rules(section.fetch("content"), rules, "tierC"), mode: 0o644)
    end
  end
end

def frontmatter_name(path)
  data, = frontmatter(path)
  data["name"]
end

def self_check!(rules)
  generated_files = Dir[File.join(ROOT, ".agents", "skills", "**", "*")].select { |path| File.file?(path) }.sort
  generated_files += [File.join(ROOT, ".codex-plugin", "plugin.json")]
  rules.fetch("forbidden_strings").each do |forbidden|
    hits = generated_files.select { |path| File.binread(path).include?(forbidden) }
    abort "forbidden string #{forbidden.inspect} survived in: #{hits.join(', ')}" unless hits.empty?
  end

  Dir[File.join(OUTPUT_SKILLS, "*")].select { |path| File.directory?(path) }.sort.each do |skill_dir|
    directory_name = File.basename(skill_dir)
    name = frontmatter_name(File.join(skill_dir, "SKILL.md"))
    abort "skill directory/name mismatch: #{directory_name} != #{name.inspect}" unless directory_name == name
  end

  source_graph = File.join(SOURCE_SKILLS, "co-founder-setup", "references", "graph-audit")
  output_graph = File.join(OUTPUT_SKILLS, "co-founder-setup", "references", "graph-audit")
  abort "graph-audit bytes changed" unless File.binread(source_graph) == File.binread(output_graph)
  abort "graph-audit executable bit changed" unless (File.stat(source_graph).mode & 0o111) == (File.stat(output_graph).mode & 0o111)

  kimi_manifest_content = File.binread(KIMI_MANIFEST_PATH)
  abort "Kimi manifests differ" unless kimi_manifest_content == File.binread(KIMI_NESTED_MANIFEST_PATH)
  kimi_manifest = JSON.parse(kimi_manifest_content)
  expected_fields = %w[name version description skills commands interface]
  abort "Kimi manifest fields mismatch" unless kimi_manifest.keys.sort == expected_fields.sort
  abort "Kimi plugin name mismatch" unless kimi_manifest.fetch("name") == "co-founder"
  abort "Kimi plugin version mismatch" unless kimi_manifest.fetch("version") == rules.fetch("release_version")
  claude_manifest = JSON.parse(File.read(File.join(ROOT, ".claude-plugin", "plugin.json")))
  abort "Kimi plugin description mismatch" unless kimi_manifest.fetch("description") == claude_manifest.fetch("description")
  expected_interface = { "displayName" => claude_manifest.fetch("displayName") }
  abort "Kimi plugin interface mismatch" unless kimi_manifest.fetch("interface") == expected_interface
  skill_names = Dir[File.join(OUTPUT_SKILLS, "*")]
    .select { |path| File.directory?(path) }
    .map { |path| File.basename(path) }
    .sort
  abort "Kimi skill count mismatch: expected 13, found #{skill_names.length}" unless skill_names.length == 13
  expected_skills = skill_names.map { |skill_name| "./.agents/skills/#{skill_name}/" }
  expected_commands = skill_names.map { |skill_name| "./.kimi-plugin/commands/#{skill_name}.md" }
  abort "Kimi skill paths mismatch" unless kimi_manifest.fetch("skills") == expected_skills
  abort "Kimi command paths mismatch" unless kimi_manifest.fetch("commands") == expected_commands

  command_files = Dir[File.join(KIMI_COMMANDS_DIR, "*.md")].sort
  abort "Kimi command count mismatch: expected 13, found #{command_files.length}" unless command_files.length == 13
  command_files.each do |path|
    skill_name = File.basename(path, ".md")
    expected = <<~MARKDOWN
      Start the #{skill_name} skill.

      Load and follow the `#{skill_name}` skill from `.agents/skills/#{skill_name}`, passing "$ARGUMENTS" through as the user's request.
    MARKDOWN
    abort "Kimi command content mismatch: #{path}" unless File.binread(path) == expected
  end

  kimi_files = [KIMI_MANIFEST_PATH, KIMI_NESTED_MANIFEST_PATH] + command_files
  rules.fetch("forbidden_strings").each do |forbidden|
    hits = kimi_files.select { |path| File.binread(path).include?(forbidden) }
    abort "forbidden string #{forbidden.inspect} survived in Kimi: #{hits.join(', ')}" unless hits.empty?
  end
end

def self_check_hermes!(rules)
  source_names = Dir[File.join(SOURCE_SKILLS, "*")].select { |path| File.directory?(path) }.map { |path| File.basename(path) }.sort
  name_overrides = hermes_name_overrides(rules, source_names)
  expected_names = source_names.map { |skill_name| name_overrides.fetch(skill_name, skill_name) }.sort
  generated_dirs = Dir[File.join(HERMES_SKILLS, "*")].select { |path| File.directory?(path) }.sort
  generated_names = generated_dirs.map { |path| File.basename(path) }
  abort "Hermes skill count mismatch: expected 13, found #{generated_dirs.length}" unless generated_dirs.length == 13
  abort "Hermes skill directory mismatch" unless generated_names == expected_names

  generated_files = Dir[File.join(HERMES_SKILLS, "**", "*")].select { |path| File.file?(path) }.sort
  rules.fetch("forbidden_strings").each do |forbidden|
    hits = generated_files.select { |path| File.binread(path).include?(forbidden) }
    abort "forbidden string #{forbidden.inspect} survived in Hermes: #{hits.join(', ')}" unless hits.empty?
  end

  generated_dirs.each do |skill_dir|
    directory_name = File.basename(skill_dir)
    skill_path = File.join(skill_dir, "SKILL.md")
    data, = frontmatter(skill_path)
    abort "skill directory/name mismatch: #{directory_name} != #{data['name'].inspect}" unless directory_name == data["name"]
    description = data["description"]
    abort "empty Hermes description: #{directory_name}" unless description.is_a?(String) && !description.empty?
    abort "Hermes description exceeds #{HERMES_DESCRIPTION_LIMIT} chars: #{directory_name}" if description.length > HERMES_DESCRIPTION_LIMIT
  end

  source_graph = File.join(SOURCE_SKILLS, "co-founder-setup", "references", "graph-audit")
  output_graph = File.join(HERMES_SKILLS, "co-founder-setup", "references", "graph-audit")
  abort "Hermes graph-audit bytes changed" unless File.binread(source_graph) == File.binread(output_graph)
  abort "Hermes graph-audit executable bit changed" unless (File.stat(source_graph).mode & 0o111) == (File.stat(output_graph).mode & 0o111)
end

def hermes_bundle_refs
  coverage = []
  diffs = []
  Dir[File.join(HERMES_SKILLS, "*")].select { |path| File.directory?(path) }.sort.each do |skill_dir|
    skill_path = File.join(skill_dir, "SKILL.md")
    content = File.read(skill_path)
    collected = content.scan(HERMES_BUNDLE_REF_PATTERN).flatten.compact.uniq.sort
    present = Dir[File.join(skill_dir, "**", "*")]
      .select { |path| File.file?(path) && path != skill_path }
      .map { |path| path.delete_prefix(skill_dir + File::SEPARATOR) }
      .sort
    coverage << [File.basename(skill_dir), collected.length, present.length]

    unbundled = present - collected
    nonexistent = collected - present
    next if unbundled.empty? && nonexistent.empty?

    lines = [File.basename(skill_dir)]
    lines.concat(unbundled.map { |path| "  - not collected: #{path}" })
    lines.concat(nonexistent.map { |path| "  + not present:   #{path}" })
    diffs << lines.join("\n")
  end

  name_width = [coverage.map { |row| row[0].length }.max || 5, "skill".length].max
  puts "hermes_bundle_refs coverage:"
  puts format("%-#{name_width}s  %9s  %13s", "skill", "collected", "files present")
  coverage.each do |skill_name, collected_count, present_count|
    puts format("%-#{name_width}s  %9d  %13d", skill_name, collected_count, present_count)
  end
  abort "hermes_bundle_refs: bundle coverage mismatch:\n#{diffs.join("\n")}" unless diffs.empty?

  puts "hermes_bundle_refs: OK"
end

tier = ARGV.shift
abort "usage: ruby tools/gen/generate.rb tierB|tierC" unless %w[tierB tierC].include?(tier) && ARGV.empty?

rules = load_rules
assert_source_counts!(rules)
core, reference_sections = conventions_sections(rules)
if tier == "tierB"
  emit_skills(rules, core, reference_sections)
  emit_packaging(rules)
  self_check!(rules)
  puts "tierB: generated 13 skills, Codex packaging, and Kimi packaging"
else
  emit_hermes_skills(rules, core, reference_sections)
  self_check_hermes!(rules)
  hermes_bundle_refs
  puts "tierC: generated 13 standalone Hermes skills"
end
