#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"

files = Dir[File.join(__dir__, "..", "skills", "*", "SKILL.md")].sort
abort "no skills found" if files.empty?

files.each do |file|
  source = File.read(file)
  match = source.match(/\A---\n(.*?)\n---\n/m)
  abort "missing frontmatter: #{file}" unless match

  data = YAML.safe_load(match[1], permitted_classes: [], permitted_symbols: [], aliases: false)
  abort "frontmatter is not a mapping: #{file}" unless data.is_a?(Hash)
  abort "frontmatter keys must be exactly name + description: #{file}" unless data.keys.sort == %w[description name]
  abort "invalid name: #{file}" unless data["name"].is_a?(String) && !data["name"].empty?
  abort "invalid description: #{file}" unless data["description"].is_a?(String) && !data["description"].empty?
end

puts "frontmatter: #{files.length} skills valid"
