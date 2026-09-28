#!/usr/bin/env ruby
# frozen_string_literal: true

# Rewrites directory copy from the product catalog.
# Briefings state only what the catalog records. They do not invent pricing,
# customers, or performance figures.

require "yaml"
require "date"

ROOT = File.expand_path("..", __dir__)
MARKER = "<!-- HireAI: briefing:2026-09-28 -->"
DATE = "2026-09-28"
DATE_HUMAN = "28 September 2026"

def slugify(text)
  text.to_s
      .downcase
      .gsub(/[^a-z0-9\s-]/, "")
      .strip
      .gsub(/\s+/, "-")
      .gsub(/-+/, "-")
end

def yaml_double(value)
  '"' + value.to_s.gsub("\\", "\\\\").gsub('"', '\\"').gsub("\n", " ") + '"'
end

def split_doc(text)
  return nil unless text.start_with?("---\n")

  normalized = text.end_with?("\n") ? text : "#{text}\n"
  parts = normalized.split("---\n", 3)
  return nil if parts.length < 3

  [parts[1], parts[2]]
end

def upsert_line(front_matter, key, line)
  if front_matter.match?(/^#{Regexp.escape(key)}:/)
    front_matter.sub(/^#{Regexp.escape(key)}:.*$/, line)
  else
    front_matter.rstrip + "\n" + line + "\n"
  end
end

def join_doc(front_matter, body)
  "---\n#{front_matter.rstrip}\n---\n#{body.sub(/\A\n*/, "\n")}"
end

def analysis_href(analysis_path)
  slug = File.basename(analysis_path.to_s, ".md")
  "{{ site.baseurl }}/#{slug}/"
end

products_data = YAML.load_file(File.join(ROOT, "_data/products.yml"))
checklists = YAML.load_file(File.join(ROOT, "_data/tag_checklists.yml")) || {}

catalog = []
by_analysis = {}
tag_counts = Hash.new(0)

products_data.each do |category|
  (category["products"] || []).each do |product|
    record = {
      "name" => product["name"],
      "description" => product["description"].to_s,
      "url" => product["url"].to_s,
      "analysis" => product["analysis"].to_s,
      "tags" => product["tags"] || [],
      "era" => category["era"].to_s,
      "era_summary" => category["summary"].to_s
    }
    catalog << record
    by_analysis[record["analysis"]] = record
    record["tags"].each { |tag| tag_counts[tag] += 1 }
  end
end

def checklist_for(checklists, tag)
  checklists[slugify(tag)]
end

def render_checks(record, checklists)
  tags = record["tags"]
  return "- Confirm the workflow this product claims to support.\n- Ask for integrations, permissions, audit logs, and a rollback path.\n- Pilot one role before a wider rollout.\n" if tags.empty?

  tags.first(3).map do |tag|
    items = checklist_for(checklists, tag)
    lines = if items.is_a?(Array) && !items.empty?
              items.first(4).map { |item| "- #{item}" }
            else
              ["- Confirm how this product supports #{tag} in a demo, not from marketing copy."]
            end
    "### #{tag}\n\n#{lines.join("\n")}\n"
  end.join("\n")
end

def render_related(record, catalog)
  tags = record["tags"]
  related = catalog
            .reject { |other| other["name"] == record["name"] }
            .map { |other| [((other["tags"] || []) & tags).length, other] }
            .select { |score, _| score.positive? }
            .sort_by { |score, other| [-score, other["name"]] }
            .first(4)
            .map(&:last)

  return "No other product in the directory shares these tags.\n" if related.empty?

  related.map do |other|
    href = analysis_href(other["analysis"])
    "- [#{other['name']}](#{href}) — #{other['description']}"
  end.join("\n") + "\n"
end

def sentence_fragment(text)
  text.to_s.strip.sub(/[.]\z/, "")
end

def human_list(items)
  items = items.map(&:to_s)
  return "" if items.empty?
  return items[0] if items.length == 1
  return "#{items[0]} and #{items[1]}" if items.length == 2

  "#{items[0..-2].join(', ')}, and #{items[-1]}"
end

def era_paragraph(record, name)
  era = record["era"].to_s.strip
  return "" if era.empty?

  "HireAI files #{name} in the **#{era}** era. #{record['era_summary']}".strip + "\n\n"
end

def tag_phrase(tags)
  return "tools in the same workflow" if tags.empty?

  human_list(tags)
end

def source_lines(record)
  if record["url"].start_with?("http")
    "- Official website: #{record['url']}\n- HireAI directory record updated #{DATE_HUMAN}.\n"
  else
    "- No public website is recorded in the HireAI directory.\n- HireAI directory record updated #{DATE_HUMAN}.\n"
  end
end

def placeholder_body(record, checklists, catalog)
  name = record["name"]
  <<~MD
    #{MARKER}

    # #{name}

    ## Overview

    **#{name}** — #{sentence_fragment(record['description'])}.

    #{era_paragraph(record, name)}This briefing is vendor-neutral. It does not rank #{name}, quote a price, or treat unchecked capabilities as facts.

    ## When to shortlist it

    Shortlist #{name} when you are comparing #{tag_phrase(record['tags'])} tools. Read the checks below in a demo, then confirm packaging, security, and integrations on the vendor site.

    ## What to verify

    #{render_checks(record, checklists)}
    ## Related products in HireAI

    #{render_related(record, catalog)}
    ## Takeaway

    Use #{name} as a candidate in the #{record['era'].split(' - ').last} group, not as a default winner. Keep it on the shortlist only if the checks above match the job you need done.

    ## Source

    #{source_lines(record)}
  MD
end

def starter_top(record)
  name = record["name"]
  <<~MD
    #{MARKER}

    ## Overview

    **#{name}** — #{sentence_fragment(record['description'])}.

    #{era_paragraph(record, name)}## When to shortlist it

    Shortlist #{name} when you are comparing #{tag_phrase(record['tags'])} tools. This page does not rank the product and does not confirm pricing.

    ## How to use the evaluation guide

    The guide below is a demo checklist drawn from the product's tags and era. Every item is something to verify. It is not a list of features HireAI has already seen in the product.

    ## Source

    #{source_lines(record)}
  MD
end

def deep_insert(record)
  name = record["name"]
  tags = record["tags"]
  tag_line = tags.empty? ? "" : "Directory tags: #{tags.join(', ')}.\n\n"
  <<~MD

    #{MARKER}

    ## Updated briefing (#{DATE_HUMAN})

    **#{name}** — #{sentence_fragment(record['description'])}.

    #{era_paragraph(record, name)}#{tag_line}The research note below may include earlier or vendor-reported figures. Use it for context, then confirm current packaging, security, and integrations on the vendor site. Directory record updated #{DATE_HUMAN}.

  MD
end

def product_detail_note
  <<~MD
    #{MARKER}

    > **How to read this page.** Speed, database size, and conversion figures below are vendor-reported claims, not measurements by HireAI. Confirm them before you buy. Directory record updated #{DATE_HUMAN}.

  MD
end

def record_for(path, front_matter, by_analysis)
  relative = "_analyses/#{File.basename(path)}"
  catalog_record = by_analysis[relative]
  return catalog_record if catalog_record

  description = front_matter[/^description:\s*(.*)$/, 1].to_s
  description = description.gsub(/\A["']|["']\z/, "")
  title = front_matter[/^page_title:\s*(.*)$/, 1] || front_matter[/^title:\s*(.*)$/, 1] || File.basename(path, ".md")
  title = title.gsub(/\A["']|["']\z/, "").sub(/ Analysis\z/, "").sub(/ - .*\z/, "")
  website = front_matter[/^website:\s*(.*)$/, 1].to_s.gsub(/\A["']|["']\z/, "")
  era = front_matter[/^era:\s*(.*)$/, 1].to_s.gsub(/\A["']|["']\z/, "")
  tags_line = front_matter[/^tags:\s*(.*)$/, 1].to_s
  tags = tags_line.scan(/"([^"]+)"/) .flatten
  {
    "name" => title,
    "description" => description,
    "url" => website,
    "analysis" => relative,
    "tags" => tags,
    "era" => era,
    "era_summary" => ""
  }
end

counts = Hash.new(0)

Dir.glob(File.join(ROOT, "_analyses/*.md")).sort.each do |path|
  raw = File.read(path)
  front_matter, body = split_doc(raw)
  next unless front_matter

  record = record_for(path, front_matter, by_analysis)
  layout = front_matter[/^layout:\s*(\S+)/, 1]
  base = File.basename(path)

  front_matter = upsert_line(front_matter, "last_modified_at", "last_modified_at: #{DATE}")
  unless record["description"].empty?
    front_matter = upsert_line(front_matter, "description", "description: #{yaml_double(record['description'])}")
  end
  unless record["era"].empty?
    front_matter = upsert_line(front_matter, "era", "era: #{yaml_double(record['era'])}")
  end
  if !record["url"].empty? && front_matter.match?(/^website:\s*""\s*$/)
    front_matter = upsert_line(front_matter, "website", "website: #{yaml_double(record['url'])}")
  end
  if front_matter.match?(/^tags:\s*\[\s*\]\s*$/) && !record["tags"].empty?
    rendered_tags = record["tags"].map { |tag| yaml_double(tag) }.join(", ")
    front_matter = upsert_line(front_matter, "tags", "tags: [#{rendered_tags}]")
  end
  page_description = front_matter[/^page_description:\s*(.*)$/, 1].to_s
  if page_description.match?(/In-depth analysis of/i) && !record["description"].empty?
    front_matter = upsert_line(front_matter, "page_description", "page_description: #{yaml_double(record['description'])}")
  end

  if base == "hr-ai-evolution-comprehensive-analysis.md"
    front_matter = upsert_line(
      front_matter,
      "description",
      "description: #{yaml_double("How HR technology moved from 1990s applicant tracking systems to agentic AI, and how the current HireAI directory uses that framework.")}"
    )
    front_matter = upsert_line(
      front_matter,
      "page_description",
      "page_description: #{yaml_double("A framework for reading HR AI, from applicant tracking systems to agentic platforms, plus the current HireAI directory counts.")}"
    )
    unless body.include?(MARKER)
      snapshot = products_data.map { |category| "- **#{category['era']}** (#{category['products'].length}): #{category['summary']}" }.join("\n")
      insert = <<~MD

        #{MARKER}

        ## Directory snapshot (#{DATE_HUMAN})

        This essay first examined a sample of 46 products. HireAI now lists **#{catalog.length}** products. The framework below still explains the sequence. Use the [product directory]({{ site.baseurl }}/product-directory/) for the current catalog.

        #{snapshot}

      MD
      body = body.sub(
        "This comprehensive analysis examines 46 leading HR AI products and vendors through the lens of Josh Bersin's five-stage technological evolution framework, spanning from the 1990s emergence of Applicant Tracking Systems (ATS) to the current era of Agentic AI Platforms.",
        "The framework below follows that five-stage sequence, from 1990s applicant tracking systems to agentic AI platforms. The original essay looked closely at 46 products. The directory snapshot that follows is the current catalog."
      )
      body = body.sub(
        "Our analysis examines 46 products and vendors across these stages, evaluating their core capabilities, market positioning, and strategic evolution.",
        "The original essay examined 46 products and vendors across these stages. Treat that sample as historical context. The directory snapshot is the current catalog."
      )
      body = body.sub("## Executive Summary\n", "## Executive Summary\n#{insert}")
      counts[:flagship] += 1
    end
  elsif body.include?(MARKER)
    counts[:already] += 1
  elsif layout == "product-detail"
    body = "\n#{product_detail_note}\n#{body.lstrip}"
    counts[:product_detail] += 1
  elsif body.include?("Summarize the core tech approach") || body.include?("- Feature 1")
    body = "\n#{placeholder_body(record, checklists, catalog)}"
    counts[:placeholder] += 1
  elsif body.include?("starter article generated") && body.include?("<!-- HireAI: baked-enrichment:start -->")
    body = body.sub(/\A.*?(?=<!-- HireAI: baked-enrichment:start -->)/m, "\n#{starter_top(record)}\n")
    counts[:starter] += 1
  else
    insert = deep_insert(record)
    if body.match?(/^# /)
      body = body.sub(/^# .*\n/, "\\0\n#{insert}")
    else
      body = "\n#{insert}\n#{body.lstrip}"
    end
    counts[:deep] += 1
  end

  File.write(path, join_doc(front_matter, body))
end

Dir.glob(File.join(ROOT, "tags/*.md")).sort.each do |path|
  raw = File.read(path)
  front_matter, body = split_doc(raw)
  next unless front_matter

  tag = front_matter[/^tag:\s*(.*)$/, 1].to_s.gsub(/\A["']|["']\z/, "")
  count = tag_counts[tag]
  next if count.zero?

  if front_matter.match?(/^description:/)
    front_matter = front_matter.sub(/^description:.*$/) do |line|
      line.gsub(/\d+\+/, count.to_s)
    end
  else
    front_matter = upsert_line(
      front_matter,
      "description",
      "description: #{yaml_double("HireAI lists #{count} products tagged #{tag}.")}"
    )
  end

  unless body.include?(MARKER)
    note = "#{MARKER}\n\nAs of #{DATE_HUMAN}, HireAI lists **#{count}** products tagged #{tag}.\n"
    body = if body.strip.empty?
             "\n#{note}\n"
           else
             "\n#{note}\n#{body.lstrip}"
           end
    counts[:tags] += 1
  end

  File.write(path, join_doc(front_matter, body))
end

replacements = {
  "149+ Products · 150+ Analysis · 58 Categories" => "#{catalog.length} Products · #{Dir.glob(File.join(ROOT, '_analyses/*.md')).length} Analyses · #{tag_counts.length} Tags",
  "149+ HR AI products across all categories" => "#{catalog.length} HR AI products across five technology eras",
  "150+ in-depth product analysis articles" => "#{Dir.glob(File.join(ROOT, '_analyses/*.md')).length} product briefings and analyses",
  "58 tags for precise categorization" => "#{tag_counts.length} tags for precise categorization",
  "| **149+** | **150+** | **58** | **5** |" => "| **#{catalog.length}** | **#{Dir.glob(File.join(ROOT, '_analyses/*.md')).length}** | **#{tag_counts.length}** | **5** |",
  "View All 149+ Products" => "View All #{catalog.length} Products",
  "A comprehensive analysis of 46 HR AI products through Josh Bersin's five-stage framework, examining the progression from 1990s ATS systems to 2024+ Agentic AI Platforms." => "How HR AI moved from 1990s applicant tracking to agentic platforms, with the current directory of #{catalog.length} products organized on that framework.",
  "Product database (149+ products)" => "Product database (#{catalog.length} products)",
  "Tag pages (58 tags)" => "Tag pages (#{tag_counts.length} tags)",
  "Product analysis pages (150+)" => "Product analysis pages (#{Dir.glob(File.join(ROOT, '_analyses/*.md')).length})",
  "149+ 款 HR AI 产品，覆盖所有品类" => "#{catalog.length} 款 HR AI 产品，覆盖五个技术时代",
  "150+ 篇产品深度分析文章" => "#{Dir.glob(File.join(ROOT, '_analyses/*.md')).length} 篇产品简报与分析",
  "| **149+** | **150+** | **8** | **95** | **5** |" => "| **#{catalog.length}** | **#{Dir.glob(File.join(ROOT, '_analyses/*.md')).length}** | **5** | **#{tag_counts.length}** | **5** |",
  "查看全部 149+ 产品" => "查看全部 #{catalog.length} 产品",
  "产品数据库（149+ 产品）" => "产品数据库（#{catalog.length} 产品）",
  "产品分析页（150+）" => "产品分析页（#{Dir.glob(File.join(ROOT, '_analyses/*.md')).length}）",
  "149+ HR AI products catalogued" => "#{catalog.length} HR AI products catalogued",
  "150+ in-depth analysis articles" => "#{Dir.glob(File.join(ROOT, '_analyses/*.md')).length} product briefings and analyses",
  "95 category tags" => "#{tag_counts.length} capability tags",
  "**[Browse All 58 Tags →](https://hireai.genedai.me/product-directory/)**" => "**[Browse All #{tag_counts.length} Tags →](https://hireai.genedai.me/product-directory/)**",
  "| **结构化分类** | 95 个标签精准分类 |" => "| **结构化分类** | #{tag_counts.length} 个标签精准分类 |",
  "**[浏览全部 95 个标签 →](https://hireai.genedai.me/product-directory/)**" => "**[浏览全部 #{tag_counts.length} 个标签 →](https://hireai.genedai.me/product-directory/)**",
  "评估标准（95 个标签）" => "评估标准（#{tag_counts.length} 个标签）",
  "通过 Josh Bersin 的五阶段框架，对 46 个 HR AI 产品进行全面分析，研究从 1990 年代 ATS 系统到 2024+ 智能体 AI 平台的发展历程。" => "用 Josh Bersin 的五阶段框架说明 HR AI 如何从 1990 年代申请追踪走到智能体平台，并给出当前目录中的 #{catalog.length} 款产品。",
  "Tag pages (95+ files)" => "Tag pages (#{tag_counts.length} files)",
  "Product analysis articles (150+ files)" => "Product analysis articles (#{Dir.glob(File.join(ROOT, '_analyses/*.md')).length} files)",
  ">149+</text>" => ">#{catalog.length}</text>",
  ">150+</text>" => ">#{Dir.glob(File.join(ROOT, '_analyses/*.md')).length}</text>",
  ">58</text>" => ">#{tag_counts.length}</text>"
}

%w[README.md README-zh.md ROADMAP.md CONTRIBUTING.md assets/images/og-image.svg].each do |relative|
  file = File.join(ROOT, relative)
  text = File.read(file)
  replacements.each { |from, to| text = text.gsub(from, to) }
  File.write(file, text)
end

faq = File.read(File.join(ROOT, "FAQ.md"))
old_faq = "We aim to update the collection regularly as new HR AI products emerge and existing ones evolve. Major updates typically occur monthly, but we also make smaller updates as needed."
new_faq = "HireAI updates the directory when products are added or corrected. On #{DATE_HUMAN} every product page was refreshed with a dated briefing, an era placement, and demo checks. HireAI does not measure vendor pricing or performance claims."
faq = faq.gsub(old_faq, new_faq)
old_reco = "We aim to provide objective information about HR AI products rather than specific recommendations. However, our analysis may highlight strengths and weaknesses of different products to help you make informed decisions."
new_reco = "No. HireAI does not rank products or name a default vendor. Each page states the directory description, the technology era, and checks to run in a demo."
faq = faq.gsub(old_reco, new_reco)
File.write(File.join(ROOT, "FAQ.md"), faq)

readme_zh = File.read(File.join(ROOT, "README-zh.md"))
readme_zh = readme_zh.sub(
  "每个产品都包含详细分析：\n\n- 公司背景与历史\n- 核心功能与能力\n- 技术架构\n- 目标市场与使用场景\n- 优势与劣势\n- 竞争定位\n- 定价与部署方式",
  "每个产品页包含：\n\n- 通俗描述和技术时代\n- 能力标签，以及需要在演示中核对的检查项\n- 供应商网站链接，以及目录中的相关产品\n- 日期说明，避免把供应商自称的数字当成 HireAI 的测量结果"
)
File.write(File.join(ROOT, "README-zh.md"), readme_zh)

tag_rows = {
  "AI" => "ai",
  "Automation" => "automation",
  "Sourcing" => "sourcing",
  "ATS" => "ats",
  "Assessment" => "assessment",
  "Analytics" => "analytics",
  "Conversational AI" => "conversational-ai",
  "Agentic AI" => "agentic-ai"
}
%w[README.md README-zh.md].each do |relative|
  file = File.join(ROOT, relative)
  text = File.read(file)
  tag_rows.each do |label, slug|
    count = tag_counts[label]
    text = text.gsub(%r{(\| \[#{Regexp.escape(label)}\]\(https://hireai\.genedai\.me/tags/#{slug}/\) \| )\d+( \|)}) { "#{Regexp.last_match(1)}#{count}#{Regexp.last_match(2)}" }
  end
  File.write(file, text)
end

readme = File.read(File.join(ROOT, "README.md"))
readme = readme.sub(
  "Every product includes a detailed analysis covering:\n\n- Company background & history\n- Core features & capabilities\n- Technology architecture\n- Target market & use cases\n- Strengths & weaknesses\n- Competitive positioning\n- Pricing & deployment options",
  "Every product page includes:\n\n- A plain-language description and technology era\n- Capability tags and checks to run in a demo\n- A link to the vendor site and to related products in the directory\n- A dated note so vendor-reported figures are not treated as HireAI measurements"
)
File.write(File.join(ROOT, "README.md"), readme)

changelog = File.read(File.join(ROOT, "CHANGELOG.md"))
unless changelog.include?("dated September 2026 briefing")
  changelog = changelog.sub(
    "### Changed\n- Refined meta tag generation for tag pages\n",
    "### Changed\n- Refreshed every product page with a 28 September 2026 briefing, era placement, and demo checks tied to directory tags.\n- Updated public directory counts in the README, roadmap, tag pages, and flagship essay.\n- Refined meta tag generation for tag pages\n"
  )
  File.write(File.join(ROOT, "CHANGELOG.md"), changelog)
end

puts "products=#{catalog.length} tags=#{tag_counts.length} analyses=#{Dir.glob(File.join(ROOT, '_analyses/*.md')).length}"
products_data.each do |category|
  puts "  #{category['era']}: #{category['products'].length}"
end
counts.each { |key, value| puts "#{key}=#{value}" }
