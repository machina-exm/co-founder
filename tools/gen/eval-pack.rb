#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"
require "yaml"

ROOT = File.expand_path("../..", __dir__)
EVALS_DIR = File.join(ROOT, "evals")
OUTPUT_DIR = File.join(ROOT, "dist", "eval-pack")
PORTABLE_GRADER_TYPES = %w[regex file_exists].freeze

def mapping!(value, label)
  abort "#{label} must be a mapping" unless value.is_a?(Hash)
end

def portable_case(source_path)
  data = YAML.safe_load(
    File.read(source_path),
    permitted_classes: [],
    permitted_symbols: [],
    aliases: false
  )
  mapping!(data, source_path)

  execution = data.fetch("execution")
  mapping!(execution, "execution in #{source_path}")
  graders = data.fetch("graders")
  abort "graders in #{source_path} must be an array" unless graders.is_a?(Array)

  portable = {
    "schema_version" => data.fetch("schema_version"),
    "name" => data.fetch("name"),
    "description" => data.fetch("description"),
    "tags" => data.fetch("tags")
  }

  scaffold = data.dig("context", "scaffold_script")
  portable["context"] = { "scaffold_script" => scaffold } if scaffold
  portable["execution"] = { "prompt" => execution.fetch("prompt") }
  portable["graders"] = graders.select do |grader|
    mapping!(grader, "grader in #{source_path}")
    PORTABLE_GRADER_TYPES.include?(grader.fetch("type"))
  end
  portable["expected_outcome"] = data.fetch("expected_outcome")
  portable
end

def copy_with_mode(source, destination)
  FileUtils.mkdir_p(File.dirname(destination))
  FileUtils.copy_file(source, destination)
  File.chmod(File.stat(source).mode & 0o7777, destination)
end

case_paths = Dir[File.join(EVALS_DIR, "*", "case.yaml")].sort
abort "no native eval cases found" if case_paths.empty?

FileUtils.rm_rf(OUTPUT_DIR)
FileUtils.mkdir_p(OUTPUT_DIR)

fixture_source = File.join(EVALS_DIR, "_fixtures", "founder.sh")
abort "missing shared fixture: #{fixture_source}" unless File.file?(fixture_source)
copy_with_mode(fixture_source, File.join(OUTPUT_DIR, "_fixtures", "founder.sh"))

case_paths.each do |source_path|
  case_name = File.basename(File.dirname(source_path))
  data = portable_case(source_path)

  output_case_dir = File.join(OUTPUT_DIR, case_name)
  FileUtils.mkdir_p(output_case_dir)
  header = "# portable smoke case derived from evals/#{case_name} — run graders with scripts/grade_portable.rb\n"
  File.write(File.join(output_case_dir, "case.yaml"), header + YAML.dump(data))

  scaffold = data.dig("context", "scaffold_script")
  next unless scaffold

  source_scaffold = File.expand_path(scaffold, File.dirname(source_path))
  unless source_scaffold.start_with?(File.dirname(source_path) + File::SEPARATOR) && File.file?(source_scaffold)
    abort "invalid scaffold for #{case_name}: #{scaffold}"
  end
  copy_with_mode(source_scaffold, File.join(output_case_dir, scaffold))
end

puts "eval-pack: generated #{case_paths.length} portable smoke cases and shared fixture"
