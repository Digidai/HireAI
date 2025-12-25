#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "date"
require "uri"

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

def valid_url?(url)
  uri = URI.parse(url.to_s)
  uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
rescue URI::InvalidURIError
  false
end

warnings = []
errors = []

# Load and validate products.yml
products_data = YAML.load_file("_data/products.yml")
unless products_data.is_a?(Array)
  raise "_data/products.yml must be an array of categories"
end

products = products_data.flat_map { |c| c["products"] || [] }
puts "products=#{products.size}"

# Check for missing analysis
null_analysis = products.count { |p| p["analysis"].nil? || p["analysis"].to_s.strip.empty? }
errors << "products with missing analysis=#{null_analysis}" if null_analysis > 0

# Validate product URLs
products.each do |p|
  url = p["url"].to_s
  unless valid_url?(url)
    warnings << "Invalid URL for #{p['name']}: #{url}"
  end
  unless url.start_with?("https://")
    warnings << "Non-HTTPS URL for #{p['name']}: #{url}"
  end
end

# Validate description length
products.each do |p|
  desc = p["description"].to_s
  if desc.length < 20
    warnings << "Short description for #{p['name']}: #{desc.length} chars"
  elsif desc.length > 200
    warnings << "Long description for #{p['name']}: #{desc.length} chars"
  end
end

# Validate tags count
products.each do |p|
  tags = p["tags"] || []
  if tags.empty?
    warnings << "No tags for #{p['name']}"
  elsif tags.size > 8
    warnings << "Too many tags for #{p['name']}: #{tags.size}"
  end
end

# Analysis files are now in _analyses/ directory
analysis_files = products.map { |p| p["analysis"] }.compact.uniq
missing_analysis_files = analysis_files.reject { |f| File.exist?(f) }
if missing_analysis_files.any?
  errors << "Missing analysis files:\n" + missing_analysis_files.first(50).join("\n")
end

# Validate analysis permalinks
bad_permalink = []
analysis_files.each do |file|
  fm = front_matter(file)
  next unless fm

  basename = File.basename(file, ".md")
  expected = "/#{basename}/"
  got = fm["permalink"].to_s
  bad_permalink << "#{file}: #{got} (expected #{expected})" unless got == expected
end
errors << "Bad analysis permalinks:\n" + bad_permalink.first(50).join("\n") if bad_permalink.any?

# Collect all used tags
tag_set = []
products.each { |p| (p["tags"] || []).each { |t| tag_set << t } }
tag_set = tag_set.uniq
puts "unique_tags_used=#{tag_set.size}"

# Check for missing tag pages
missing_tag_pages = tag_set.reject { |t| File.exist?("tags/#{slugify(t)}.md") }
if missing_tag_pages.any?
  errors << "Missing tag pages:\n" + missing_tag_pages.first(50).join("\n")
end

# Validate tag page permalinks
bad_tag_pages = []
Dir.glob("tags/*.md").each do |path|
  fm = front_matter(path)
  next unless fm

  expected = "/tags/#{File.basename(path, ".md")}/"
  got = fm["permalink"].to_s
  bad_tag_pages << "#{path}: #{got} (expected #{expected})" unless got == expected
end
errors << "Bad tag page permalinks:\n" + bad_tag_pages.first(50).join("\n") if bad_tag_pages.any?

# Find unused tag pages
all_tag_pages = Dir.glob("tags/*.md").map { |p| File.basename(p, ".md") }
used_tag_slugs = tag_set.map { |t| slugify(t) }
unused_tag_pages = all_tag_pages - used_tag_slugs
if unused_tag_pages.any?
  warnings << "Unused tag pages (#{unused_tag_pages.size}): #{unused_tag_pages.first(10).join(', ')}#{unused_tag_pages.size > 10 ? '...' : ''}"
end

# Analysis pages validation
analysis_pages = Dir.glob("_analyses/*.md").select do |path|
  fm = front_matter(path)
  fm && fm["layout"] == "analysis"
end

# Check for missing baked enrichment block
missing_baked_block = analysis_pages.reject do |path|
  text = File.read(path)
  text.include?(START_MARK) && text.include?(END_MARK)
end
if missing_baked_block.any?
  errors << "Analysis pages missing baked enrichment block:\n" + missing_baked_block.first(50).join("\n")
end

# Validate tag_checklists.yml
begin
  tag_checklists = YAML.load_file("_data/tag_checklists.yml")

  # Check for tags without checklists
  tags_without_checklists = tag_set.select { |t| !tag_checklists.key?(slugify(t)) || tag_checklists[slugify(t)].nil? || tag_checklists[slugify(t)].empty? }
  if tags_without_checklists.any?
    warnings << "Tags without checklists (#{tags_without_checklists.size}): #{tags_without_checklists.first(10).join(', ')}#{tags_without_checklists.size > 10 ? '...' : ''}"
  end
rescue Psych::SyntaxError => e
  errors << "_data/tag_checklists.yml parse error: #{e.message}"
end

# Output results
puts "analysis_pages=#{analysis_pages.size}"
puts "tag_pages=#{Dir.glob('tags/*.md').size}"

if warnings.any?
  puts "\n--- WARNINGS (#{warnings.size}) ---"
  warnings.each { |w| puts "  [WARN] #{w}" }
end

if errors.any?
  puts "\n--- ERRORS (#{errors.size}) ---"
  errors.each { |e| puts "  [ERROR] #{e}" }
  raise "Validation failed with #{errors.size} error(s)"
end

puts "OK"
