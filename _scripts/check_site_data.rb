#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "date"

START_MARK = "<!-- HireAI: baked-enrichment:start -->"
END_MARK = "<!-- HireAI: baked-enrichment:end -->"

def slugify(text)
  text.to_s
      .downcase
      .gsub(/[^a-z0-9\s-]/, "")
      .strip
      .gsub(/\s+/, "-")
      .gsub(/-+/, "-")
end

def front_matter(path)
  text = File.read(path)
  return nil unless text.start_with?("---\n")

  parts = text.split("---\n", 3)
  return nil if parts.size < 3

  YAML.safe_load(parts[1], permitted_classes: [Date], aliases: true) || {}
rescue Psych::SyntaxError => e
  raise "Front matter YAML parse error in #{path}: #{e.message}"
end

products_data = YAML.load_file("_data/products.yml")
unless products_data.is_a?(Array)
  raise "_data/products.yml must be an array of categories"
end

products = products_data.flat_map { |c| c["products"] || [] }
puts "products=#{products.size}"

null_analysis = products.count { |p| p["analysis"].nil? || p["analysis"].to_s.strip.empty? }
raise "products with missing analysis=#{null_analysis}" if null_analysis > 0

analysis_files = products.map { |p| p["analysis"] }.compact.uniq
missing_analysis_files = analysis_files.reject { |f| File.exist?(f) }
if missing_analysis_files.any?
  raise "Missing analysis files:\n" + missing_analysis_files.first(50).join("\n")
end

bad_permalink = []
analysis_files.each do |file|
  fm = front_matter(file)
  next unless fm

  expected = "/#{File.basename(file, ".md")}/"
  got = fm["permalink"].to_s
  bad_permalink << "#{file}: #{got} (expected #{expected})" unless got == expected
end
raise "Bad analysis permalinks:\n" + bad_permalink.first(50).join("\n") if bad_permalink.any?

tag_set = []
products.each { |p| (p["tags"] || []).each { |t| tag_set << t } }
tag_set = tag_set.uniq
missing_tag_pages = tag_set.reject { |t| File.exist?("tags/#{slugify(t)}.md") }
if missing_tag_pages.any?
  raise "Missing tag pages:\n" + missing_tag_pages.first(50).join("\n")
end

bad_tag_pages = []
Dir.glob("tags/*.md").each do |path|
  fm = front_matter(path)
  next unless fm

  expected = "/tags/#{File.basename(path, ".md")}/"
  got = fm["permalink"].to_s
  bad_tag_pages << "#{path}: #{got} (expected #{expected})" unless got == expected
end
raise "Bad tag page permalinks:\n" + bad_tag_pages.first(50).join("\n") if bad_tag_pages.any?

analysis_pages = Dir.glob("*.md").select do |path|
  fm = front_matter(path)
  fm && fm["layout"] == "analysis"
end

missing_baked_block = analysis_pages.reject do |path|
  text = File.read(path)
  text.include?(START_MARK) && text.include?(END_MARK)
end
if missing_baked_block.any?
  raise "Analysis pages missing baked enrichment block:\n" + missing_baked_block.first(50).join("\n")
end

begin
  YAML.load_file("_data/tag_checklists.yml")
rescue Psych::SyntaxError => e
  raise "_data/tag_checklists.yml parse error: #{e.message}"
end

puts "analysis_pages=#{analysis_pages.size}"
puts "tag_pages=#{Dir.glob('tags/*.md').size}"
puts "OK"

