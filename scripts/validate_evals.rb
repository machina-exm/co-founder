#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"

ROOT = File.expand_path("..", __dir__)
TOP_KEYS = %w[schema_version name description tags plugins context runs expected_outcome execution graders].freeze
CONTEXT_KEYS = %w[scaffold_script history_file add_dirs].freeze
EXECUTION_KEYS = %w[prompt max_turns timeout_seconds model allowed_tools append_system_prompt env].freeze
COMMON_GRADER_KEYS = %w[type name weight arm].freeze
GRADER_KEYS = {
  "regex" => %w[target pattern flags match],
  "tool_used" => %w[tool input_match min max],
  "tool_order" => %w[before after],
  "file_exists" => %w[path exists],
  "llm" => %w[criteria focus],
  "baseline" => %w[baseline_file criteria]
}.freeze

def mapping!(value, label)
  abort "#{label} must be a mapping" unless value.is_a?(Hash)
end

files = Dir[File.join(ROOT, "evals", "**", "case.yaml")].sort
abort "no native eval cases found" if files.empty?
names = []

files.each do |file|
  data = YAML.safe_load(File.read(file), permitted_classes: [], permitted_symbols: [], aliases: false)
  mapping!(data, file)
  unknown = data.keys - TOP_KEYS
  abort "unknown top keys in #{file}: #{unknown.join(', ')}" unless unknown.empty?
  abort "bad schema_version in #{file}" unless data["schema_version"] == "1.1"
  abort "missing name in #{file}" unless data["name"].is_a?(String) && !data["name"].empty?
  abort "duplicate case name: #{data['name']}" if names.include?(data["name"])
  names << data["name"]
  abort "runs out of range in #{file}" if data.key?("runs") && !(1..50).cover?(data["runs"])

  execution = data["execution"]
  mapping!(execution, "execution in #{file}")
  unknown = execution.keys - EXECUTION_KEYS
  abort "unknown execution keys in #{file}: #{unknown.join(', ')}" unless unknown.empty?
  context = data.fetch("context", {})
  mapping!(context, "context in #{file}")
  unknown = context.keys - CONTEXT_KEYS
  abort "unknown context keys in #{file}: #{unknown.join(', ')}" unless unknown.empty?
  abort "prompt or history_file required in #{file}" unless execution["prompt"] || context["history_file"]
  abort "max_turns out of range in #{file}" if execution.key?("max_turns") && !(1..200).cover?(execution["max_turns"])
  abort "timeout out of range in #{file}" if execution.key?("timeout_seconds") && !(1..3600).cover?(execution["timeout_seconds"])

  %w[scaffold_script history_file].each do |key|
    next unless context[key]
    path = File.expand_path(context[key], File.dirname(file))
    abort "missing #{key} in #{file}: #{path}" unless File.file?(path)
    abort "#{key} escapes case dir in #{file}" unless path.start_with?(File.dirname(file) + File::SEPARATOR)
  end

  graders = data["graders"]
  abort "graders must be a nonempty array in #{file}" unless graders.is_a?(Array) && !graders.empty?
  grader_names = []
  graders.each_with_index do |grader, index|
    mapping!(grader, "grader #{index} in #{file}")
    type = grader["type"]
    abort "unknown grader type #{type.inspect} in #{file}" unless GRADER_KEYS.key?(type)
    allowed = COMMON_GRADER_KEYS + GRADER_KEYS.fetch(type)
    unknown = grader.keys - allowed
    abort "unknown #{type} grader keys in #{file}: #{unknown.join(', ')}" unless unknown.empty?
    name = grader["name"]
    abort "missing grader name in #{file}" unless name.is_a?(String) && !name.empty?
    abort "duplicate grader name #{name} in #{file}" if grader_names.include?(name)
    grader_names << name
    abort "invalid grader weight in #{file}" unless grader.fetch("weight", 1).is_a?(Numeric) && grader.fetch("weight", 1).positive?
    abort "invalid grader arm in #{file}" if grader.key?("arm") && !%w[with-only both].include?(grader["arm"])
  end
end

abort "expected 20 native cases, found #{files.length}" unless files.length == 20
puts "evals: #{files.length} native cases structurally valid"
