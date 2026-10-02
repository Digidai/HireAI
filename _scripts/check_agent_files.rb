#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "pathname"

site = Pathname.new(ARGV[0] || "_site")
errors = []

def read_json(path, errors)
  JSON.parse(File.read(path))
rescue StandardError => e
  errors << "#{path}: #{e.message}"
  nil
end

required = %w[
  products.json
  tags.json
  agents.json
  api-catalog.json
  llms.txt
  llms-full.txt
  robots.txt
  for-agents/index.html
  sitemap-catalog.xml
  .well-known/api-catalog
  md/index.md
]
required.each do |name|
  errors << "missing #{name}" unless site.join(name).file?
end

catalog = read_json(site.join("products.json"), errors)
tags = read_json(site.join("tags.json"), errors)
profile = read_json(site.join("agents.json"), errors)
linkset = read_json(site.join("api-catalog.json"), errors)
well_known = File.read(site.join(".well-known/api-catalog")) if site.join(".well-known/api-catalog").file?
errors << "api-catalog copies differ" if well_known && File.read(site.join("api-catalog.json")) != well_known

if catalog
  errors << "catalog autonomous" unless catalog["autonomous"] == false
  errors << "catalog kind" unless catalog["kind"] == "static-directory"
  errors << "missing rank rule" unless catalog["rules"].to_s.include?("Do not rank vendors")
  errors << "missing measurement rule" unless catalog["rules"].to_s.include?("as HireAI measurements")
  products = catalog["products"] || []
  errors << "no products" if products.empty?
  ids = products.map { |product| product["id"] }
  errors << "duplicate ids in products.json" if ids.uniq.size != ids.size
  errors << "product count mismatch" if catalog.dig("counts", "products") != products.size

  record_ids = []
  products.each do |product|
    id = product["id"].to_s
    record_path = site.join("catalog/#{id}.json")
    markdown_path = site.join("md/#{id}.md")
    errors << "missing record #{id}" unless record_path.file?
    errors << "missing markdown #{id}" unless markdown_path.file?
    record = read_json(record_path, errors)
    next unless record

    record_ids << record["identifier"]
    errors << "#{id} citation mismatch" unless record["citation"] == product["citation"]
    errors << "#{id} vendorUrl mismatch" unless record["vendorUrl"] == product["url"]
    errors << "#{id} record url is vendor" if record["url"] == product["url"] && !product["url"].nil?
    errors << "#{id} spotlight mismatch" unless record["spotlight"] == product["spotlight"]
    if product["url"].nil?
      errors << "#{id} missing websitePolicy" unless record["websitePolicy"].to_s.include?("no website")
      errors << "#{id} about.url present" if record.dig("about", "url")
    end
  end
  errors << "record id set differs" if record_ids.sort != ids.sort

  null_urls = products.count { |product| product["url"].nil? }
  errors << "expected products without a website" if null_urls.zero?
end

if tags && catalog
  errors << "tag autonomous" unless tags["autonomous"] == false
  errors << "tag count mismatch" if tags["tags"].size != catalog.dig("counts", "tags")
  tags["tags"].each do |tag|
    errors << "tag #{tag["slug"]} missing checklist array" unless tag["checklist"].is_a?(Array)
    errors << "tag #{tag["slug"]} count" unless tag["count"] == tag["products"].size
  end
end

if profile
  errors << "profile autonomous" unless profile["autonomous"] == false
  errors << "profile query" unless profile["query"].to_s.include?("not an API")
end

if linkset
  hrefs = linkset.dig("linkset", 0, "service-desc").to_a.map { |item| item["href"] }
  errors << "linkset missing products.json" unless hrefs.any? { |href| href.to_s.end_with?("/products.json") }
end

llms = File.read(site.join("llms.txt"))
%w[/for-agents/ /products.json /tags.json /llms-full.txt /md/index.md].each do |needle|
  errors << "llms.txt missing #{needle}" unless llms.include?(needle)
end

digest = File.read(site.join("llms-full.txt"))
errors << "digest ranks" if digest.include?("not a ranking") == false
errors << "digest still has liquid" if digest.include?("{{")

robots = File.read(site.join("robots.txt"))
errors << "robots missing markdown allow" unless robots.include?("Allow: /md/")
errors << "robots missing markdown disallow" unless robots.include?("Disallow: /md/")
errors << "robots missing query disallow" unless robots.include?("Disallow: /*?*")

guide = File.read(site.join("for-agents/index.html"))
[
  "not an autonomous agent",
  "Do not name a default vendor.",
  "are not scores",
  "company-reported unless that page says otherwise",
  "vendorUrl is the vendor website",
  "FAQPage"
].each do |needle|
  errors << "for-agents missing #{needle}" unless guide.include?(needle)
end

home = File.read(site.join("index.html"))
errors << "home missing agent section" unless home.include?("For agents and answer engines")
errors << "home missing api-catalog link" unless home.include?('rel="api-catalog"')
errors << "home missing service-desc" unless home.include?('rel="service-desc"')

directory = File.read(site.join("product-directory/index.html"))
errors << "directory still uses descending order" if directory.include?("ItemListOrderDescending")
errors << "directory missing unordered list" unless directory.include?("ItemListUnordered")
errors << "directory missing browser-search note" unless directory.include?("runs in the browser")

sample = catalog && catalog["products"]&.find { |product| product["id"] == "eightfold-ai-analysis" }
if sample
  page = File.read(site.join("eightfold-ai-analysis/index.html"))
  errors << "analysis missing markdown alternate" unless page.include?("/md/eightfold-ai-analysis.md")
  errors << "analysis missing record link" unless page.include?("/catalog/eightfold-ai-analysis.json")
  markdown = File.read(site.join("md/eightfold-ai-analysis.md"))
  errors << "markdown still has liquid" if markdown.include?("{{")
  errors << "markdown missing canonical" unless markdown.include?("https://hireai.genedai.me/eightfold-ai-analysis/")
end

flagship_html = site.join("hr-ai-evolution-comprehensive-analysis/index.html")
if flagship_html.file?
  flagship_page = File.read(flagship_html)
  errors << "non-product analysis links a catalog record" if flagship_page.include?("/catalog/hr-ai-evolution-comprehensive-analysis.json")
  errors << "flagship missing markdown alternate" unless flagship_page.include?("/md/hr-ai-evolution-comprehensive-analysis.md")
end

kenexa_html = site.join("ibm-kenexa-analysis/index.html")
if kenexa_html.file?
  kenexa_page = File.read(kenexa_html)
  errors << "ibm kenexa links a catalog record" if kenexa_page.include?("/catalog/ibm-kenexa-analysis.json")
end

flagship = site.join("md/hr-ai-evolution-comprehensive-analysis.md")
if flagship.file?
  text = File.read(flagship)
  errors << "flagship markdown still has liquid" if text.include?("{{")
  errors << "flagship markdown link was not absolutized" unless text.include?("https://hireai.genedai.me/product-directory/")
end

if errors.empty?
  puts "agent files ok products=#{catalog['products'].size} tags=#{tags['tags'].size}"
else
  puts errors.join("\n")
  warn "agent file check failed with #{errors.size} error(s)"
  exit 1
end
