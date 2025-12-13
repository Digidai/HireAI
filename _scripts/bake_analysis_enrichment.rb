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

def parse_front_matter(path)
  text = File.read(path)
  return [nil, nil, text] unless text.start_with?("---\n")

  parts = text.split("---\n", 3)
  return [nil, nil, text] if parts.size < 3

  front_matter = YAML.safe_load(parts[1], permitted_classes: [Date], aliases: true) || {}
  body = parts[2]
  [front_matter, body, text]
rescue Psych::SyntaxError => e
  warn "Front matter YAML parse error in #{path}: #{e.message}"
  [nil, nil, text]
end

def era_context_line(era)
  era_str = era.to_s
  return "Expect core-system priorities: reliability, compliance, data model flexibility, and integrations." if era_str.include?("1990s")
  return "Expect funnel priorities: attraction, assessment quality, and candidate experience improvements." if era_str.include?("2000s")
  return "Expect workflow priorities: collaboration, integrations, and operational automation across recruiting teams." if era_str.include?("2010s")
  return "Expect intelligence priorities: skills, analytics, fairness monitoring, and decision support." if era_str.include?("2020s")
  return "Expect agentic priorities: safe autonomy, human-in-the-loop controls, and strong auditability." if era_str.include?("2024+")

  nil
end

products_data = YAML.load_file("_data/products.yml")
tag_checklists = YAML.load_file("_data/tag_checklists.yml")

products = []
products_data.each do |category|
  era = category["era"]
  (category["products"] || []).each do |p|
    analysis_file = p["analysis"]
    next unless analysis_file

    slug = analysis_file.to_s.sub(/\.md\z/, "")
    products << {
      "name" => p["name"],
      "website" => p["url"],
      "description" => p["description"],
      "tags" => p["tags"] || [],
      "era" => era,
      "analysis_file" => analysis_file,
      "analysis_permalink" => "/#{slug}/",
    }
  end
end

product_by_analysis_file = {}
products.each { |p| product_by_analysis_file[p["analysis_file"]] = p }

analysis_pages = Dir.glob("*.md").select do |path|
  fm, = parse_front_matter(path)
  fm && fm["layout"] == "analysis"
end

changed = 0

analysis_pages.each do |path|
  front_matter, _body, original_text = parse_front_matter(path)
  next unless front_matter

  product = product_by_analysis_file[path]

  tags = front_matter["tags"]
  tags = product["tags"] if (!tags.is_a?(Array) || tags.empty?) && product
  tags = [] unless tags.is_a?(Array)

  era = front_matter["era"]
  era = product["era"] if era.to_s.strip.empty? && product
  era_line = era_context_line(era)

  tag_sections = []
  tags.each do |tag|
    checklist = tag_checklists[slugify(tag)]
    next unless checklist.is_a?(Array) && !checklist.empty?

    section_lines = ["#### #{tag}", ""]
    checklist.each { |item| section_lines << "- #{item}" }
    tag_sections << section_lines.join("\n")
  end

  tag_checklists_md = if tag_sections.empty?
    "_No tag-specific checklist available yet._"
  else
    tag_sections.join("\n\n")
  end

  related = []
  products.each do |p|
    next if p["analysis_file"] == path

    shared = (p["tags"] || []) & tags
    score = shared.size
    next if score <= 0

    related << { product: p, score: score, shared: shared }
  end

  related.sort_by! { |r| [-r[:score], r[:product]["name"].to_s.downcase] }

  if related.empty? && !era.to_s.strip.empty?
    products.each do |p|
      next if p["analysis_file"] == path
      next unless p["era"] == era

      related << { product: p, score: 0, shared: ["Same era"] }
    end
    related.sort_by! { |r| r[:product]["name"].to_s.downcase }
  end

  related_md = if related.empty?
    "_No related products found yet._"
  else
      related.first(6).map do |r|
        p = r[:product]
        analysis_link = "{{ site.baseurl }}#{p["analysis_permalink"]}"
        website_link = p["website"]
        shared_txt = r[:shared].join(", ")
        desc = p["description"].to_s.strip
      "- [#{p["name"]}](#{analysis_link}) — #{desc} (Shared: #{shared_txt}) · [Visit Website](#{website_link})"
    end.join("\n")
  end

  era_section = if era.to_s.strip.empty?
    ""
  else
    lines = ["### Era Context", ""]
    lines << "- #{era_line}" if era_line
    lines << "- Use the tag checklists below to validate product-specific requirements for your stack."
    lines.join("\n") + "\n\n"
  end

  baked_block = <<~MD.rstrip
    #{START_MARK}

    ---

    ## Evaluation Guide

    This section is a structured checklist based on the directory tags and era. It does not assume features—use it to verify capabilities with demos, docs, and a pilot.

    ### Baseline Checklist

    - Define primary use cases and who will use the product day-to-day.
    - Validate end-to-end workflow fit (data in → decisions/actions → reporting).
    - Confirm integrations (ATS/HRIS, calendar, email, SSO) and data sync details.
    - Review permissions, audit logs, and governance for hiring-sensitive actions.
    - Measure impact with a pilot and agreed success metrics (speed, quality, experience).

    #{era_section}### Tag Checklists

    #{tag_checklists_md}

    ## Alternatives & Related Products

    #{related_md}

    ## How To Improve This Article

    - Add verified feature details with links to official docs, pricing, or release notes.
    - Document integrations you tested (screenshots or steps) and any limitations.
    - Include security/compliance evidence (SOC report availability, DPA, retention) when publicly documented.
    - Summarize pilot outcomes (time saved, conversion changes) with clear assumptions.

    #{END_MARK}
  MD

  pattern = /#{Regexp.escape(START_MARK)}.*?#{Regexp.escape(END_MARK)}/m
  updated_text = if original_text.match?(pattern)
    original_text.sub(pattern, baked_block)
  else
    original_text.rstrip + "\n\n" + baked_block + "\n"
  end

  next if updated_text == original_text

  File.write(path, updated_text)
  changed += 1
end

puts "analysis_pages=#{analysis_pages.size} changed=#{changed}"
