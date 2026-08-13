#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"

def usage!
  abort "usage: scripts/grade_portable.rb <case-dir> <vault-dir>"
end

def vault_files(vault_dir, target)
  pattern = if target == "files"
              File.join(vault_dir, "**", "*")
            elsif target.is_a?(Hash) && target["source"] == "file" && target["path"].is_a?(String)
              File.expand_path(target["path"], vault_dir)
            else
              raise ArgumentError, "unsupported regex target #{target.inspect}"
            end

  unless pattern == vault_dir || pattern.start_with?(vault_dir + File::SEPARATOR)
    raise ArgumentError, "regex target escapes vault: #{target.inspect}"
  end

  Dir.glob(pattern, File::FNM_DOTMATCH).select { |path| File.file?(path) }.sort
end

def regexp_for(grader)
  options = 0
  grader.fetch("flags", "").each_char do |flag|
    options |= case flag
               when "i" then Regexp::IGNORECASE
               when "m" then Regexp::MULTILINE
               when "x" then Regexp::EXTENDED
               else raise ArgumentError, "unsupported regex flag #{flag.inspect}"
               end
  end
  Regexp.new(grader.fetch("pattern"), options)
end

def regex_passes?(grader, vault_dir)
  regexp = regexp_for(grader)
  contents = vault_files(vault_dir, grader.fetch("target")).map { |path| File.read(path) }
  match = grader.fetch("match", "contains")

  return contents.any? { |content| regexp.match?(content) } if match == "contains"

  count_match = /\Acount:(\d+)\z/.match(match)
  raise ArgumentError, "unsupported regex match #{match.inspect}" unless count_match

  expected = Integer(count_match[1], 10)
  contents.sum { |content| content.scan(regexp).length } == expected
end

def file_exists_passes?(grader, vault_dir)
  path = File.expand_path(grader.fetch("path"), vault_dir)
  unless path == vault_dir || path.start_with?(vault_dir + File::SEPARATOR)
    raise ArgumentError, "file_exists path escapes vault: #{grader['path'].inspect}"
  end

  File.exist?(path) == grader.fetch("exists", true)
end

usage! unless ARGV.length == 2

case_dir = File.expand_path(ARGV[0])
vault_dir = File.expand_path(ARGV[1])
case_file = File.join(case_dir, "case.yaml")
abort "missing case file: #{case_file}" unless File.file?(case_file)
abort "missing vault directory: #{vault_dir}" unless Dir.exist?(vault_dir)

data = YAML.safe_load(File.read(case_file), permitted_classes: [], permitted_symbols: [], aliases: false)
graders = data.fetch("graders")
portable_total = 0
portable_passed = 0
failed = false

graders.each do |grader|
  name = grader.fetch("name")
  type = grader.fetch("type")

  unless %w[regex file_exists].include?(type)
    puts "SKIP (harness/llm): #{name}"
    next
  end

  portable_total += 1
  passed = type == "regex" ? regex_passes?(grader, vault_dir) : file_exists_passes?(grader, vault_dir)
  if passed
    portable_passed += 1
    puts "PASS: #{name}"
  else
    failed = true
    puts "FAIL: #{name}"
  end
rescue KeyError, ArgumentError, RegexpError => error
  failed = true
  puts "FAIL: #{name} (#{error.message})"
end

puts "#{portable_passed}/#{portable_total} portable graders passed"
exit 1 if failed
