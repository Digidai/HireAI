# frozen_string_literal: true

require "fileutils"
require "json"

module HireAI
  # Files written at build time so an agent can read one product, one tag,
  # or the analysis prose without executing the browser search.
  class AgentRecords < Jekyll::Generator
    safe true
    priority :low

    CONTENT_BRIEFING = "2026-09-28"
    MEASUREMENT = "Speed, database size, conversion, pricing, and funding in an analysis are company-reported unless that page says otherwise. They are not HireAI measurements."

    def generate(site)
      origin = "#{site.config["url"]}#{site.config["baseurl"]}"
      baseurl = site.config["baseurl"].to_s
      categories = site.data["products"] || []
      products = []
      categories.each do |category|
        (category["products"] || []).each { |product| products << [category, product] }
      end

      ids = products.map { |_, product| product_id(product) }
      duplicate_ids = ids.group_by(&:itself).select { |_id, group| group.size > 1 }.keys
      raise "Duplicate HireAI product ids: #{duplicate_ids.join(", ")}" if duplicate_ids.any?
      site.data["agent_product_ids"] = ids

      checks = site.data["tag_checklists"] || {}
      site.static_files << generated(site, "tags.json", JSON.pretty_generate(tags_document(origin, products, checks)) + "\n")
      linkset = linkset_json(origin)
      site.static_files << generated(site, "api-catalog.json", linkset)
      site.static_files << generated(site, ".well-known/api-catalog", linkset)

      products.each do |category, product|
        id = product_id(product)
        site.static_files << generated(
          site,
          "catalog/#{id}.json",
          JSON.pretty_generate(record_document(origin, category, product)) + "\n"
        )
      end

      analyses = site.collections["analyses"]&.docs || []
      index = [markdown_index_header(origin)]
      analyses.each do |doc|
        filename = File.basename(doc.relative_path)
        site.static_files << generated(site, "md/#{filename}", markdown_document(origin, baseurl, doc))
        title = doc.data["title"].to_s.gsub("[", "\\[").gsub("]", "\\]")
        index << "- [#{title}](#{origin}/md/#{filename}): canonical #{canonical_url(origin, doc)}"
      end
      site.static_files << generated(site, "md/index.md", index.join("\n") + "\n")
    end

    private

    def generated(site, relative, contents)
      GeneratedFile.new(site, relative, contents)
    end

    def product_id(product)
      File.basename(product["analysis"].to_s, ".md")
    end

    def slugify(text)
      text.to_s.downcase.gsub(/[^a-z0-9\s-]/, "").strip.gsub(/\s+/, "-").gsub(/-+/, "-")
    end

    def vendor_url(product)
      url = product["url"].to_s.strip
      url.empty? ? nil : url
    end

    def analysis_url(origin, product)
      "#{origin}/#{product_id(product)}/"
    end

    def citation_for(name, page_url)
      %(HireAI. "#{name}." #{page_url}.)
    end

    def tags_document(origin, products, checks)
      grouped = {}
      products.each do |category, product|
        (product["tags"] || []).each do |tag|
          slug = slugify(tag)
          if grouped[slug] && grouped[slug]["name"] != tag
            raise "Tag slug collision: #{grouped[slug]["name"]} vs #{tag}"
          end

          grouped[slug] ||= { "name" => tag, "products" => [] }
          id = product_id(product)
          grouped[slug]["products"] << {
            "name" => product["name"],
            "id" => id,
            "era" => category["era"],
            "record" => "#{origin}/catalog/#{id}.json",
            "analysis" => analysis_url(origin, product)
          }
        end
      end

      tags = grouped.keys.sort.map do |slug|
        entry = grouped[slug]
        checklist = checks[slug]
        checklist = [] unless checklist.is_a?(Array)
        {
          "name" => entry["name"],
          "slug" => slug,
          "url" => "#{origin}/tags/#{slug}/",
          "count" => entry["products"].size,
          "checklist" => checklist,
          "products" => entry["products"]
        }
      end

      {
        "name" => "HireAI tag index",
        "description" => "Capability tags for the HireAI HR AI directory. An empty checklist means HireAI has not published one for that tag.",
        "url" => "#{origin}/tags.json",
        "kind" => "static-directory",
        "autonomous" => false,
        "license" => "https://opensource.org/licenses/MIT",
        "usageInfo" => "#{origin}/for-agents/",
        "contentBriefing" => CONTENT_BRIEFING,
        "order" => "Tags are alphabetical by slug. Products stay in directory order. Neither order is a ranking.",
        "counts" => { "tags" => tags.size },
        "tags" => tags
      }
    end

    def record_document(origin, category, product)
      id = product_id(product)
      page = analysis_url(origin, product)
      vendor = vendor_url(product)
      record = {
        "@context" => "https://schema.org",
        "@type" => "Dataset",
        "identifier" => id,
        "name" => product["name"],
        "description" => product["description"].to_s,
        "url" => "#{origin}/catalog/#{id}.json",
        "vendorUrl" => vendor,
        "isPartOf" => {
          "@type" => "DataCatalog",
          "@id" => "#{origin}/#datacatalog",
          "name" => "HireAI HR AI Product Directory",
          "url" => "#{origin}/products.json"
        },
        "license" => "https://opensource.org/licenses/MIT",
        "usageInfo" => "#{origin}/for-agents/",
        "isAccessibleForFree" => true,
        "creator" => {
          "@type" => "Organization",
          "name" => "HireAI",
          "url" => "#{origin}/"
        },
        "citation" => citation_for(product["name"], page),
        "mainEntityOfPage" => page,
        "keywords" => product["tags"] || [],
        "contentBriefing" => CONTENT_BRIEFING,
        "era" => category["era"],
        "spotlight" => product["featured"] == true,
        "measurementPolicy" => MEASUREMENT,
        "markdown" => "#{origin}/md/#{id}.md",
        "about" => {
          "@type" => "SoftwareApplication",
          "name" => product["name"],
          "applicationCategory" => "BusinessApplication",
          "description" => product["description"].to_s
        }
      }
      record["sameAs"] = [vendor] if vendor
      record["about"]["url"] = vendor if vendor
      record["websitePolicy"] = "HireAI intentionally lists no website for this product. Do not substitute another domain." if vendor.nil?
      record
    end

    def canonical_url(origin, doc)
      permalink = doc.data["permalink"].to_s
      permalink = "/#{File.basename(doc.relative_path, ".md")}/" if permalink.empty?
      permalink = "/#{permalink}" unless permalink.start_with?("/")
      permalink = "#{permalink}/" unless permalink.end_with?("/")
      "#{origin}#{permalink}"
    end

    def linkset_json(origin)
      JSON.pretty_generate(
        "linkset" => [
          {
            "anchor" => "#{origin}/",
            "service-desc" => [
              { "href" => "#{origin}/products.json", "type" => "application/json", "title" => "HR AI product catalog" },
              { "href" => "#{origin}/tags.json", "type" => "application/json", "title" => "HR AI tag index" },
              { "href" => "#{origin}/agents.json", "type" => "application/json", "title" => "HireAI directory profile" }
            ],
            "service-doc" => [
              { "href" => "#{origin}/for-agents/", "type" => "text/html", "title" => "Agent guide" },
              { "href" => "#{origin}/llms.txt", "type" => "text/plain", "title" => "llms.txt" }
            ],
            "describedby" => [
              { "href" => "#{origin}/llms.txt", "type" => "text/plain", "title" => "Guidance for language models" }
            ],
            "license" => [
              { "href" => "https://opensource.org/licenses/MIT", "title" => "MIT License" }
            ]
          }
        ]
      ) + "\n"
    end

    def markdown_document(origin, baseurl, doc)
      canonical = canonical_url(origin, doc)
      title = doc.data["title"].to_s
      website = doc.data["website"].to_s.strip
      body = doc.content.to_s.gsub(/\{\{\s*site\.baseurl\s*\}\}/, baseurl.to_s)
      body = body.gsub(/\{\{\s*page\.website\s*\}\}/, website)
      body = body.gsub("](/", "](#{origin}/")
      if body.include?("{{")
        raise "Unresolved Liquid in #{doc.relative_path}"
      end
      <<~MARKDOWN
        > Canonical: #{canonical}
        > Citation: HireAI. "#{title}." #{canonical}.
        > License: https://opensource.org/licenses/MIT
        > This Markdown copy is for agents. Cite the canonical page. #{MEASUREMENT}

        #{body.strip}
      MARKDOWN
    end

    def markdown_index_header(origin)
      <<~MARKDOWN.chomp
        # HireAI analysis Markdown

        > Markdown copies of HireAI analyses. Cite the canonical HTML URL in each file, not this copy. This list is not a ranking. #{MEASUREMENT}

        Guide: #{origin}/for-agents/
        Catalog: #{origin}/products.json
      MARKDOWN
    end
  end

  class GeneratedFile < Jekyll::StaticFile
    def initialize(site, relative, contents)
      super(site, site.source, File.dirname(relative), File.basename(relative))
      @relative = relative.sub(%r{\A/+}, "")
      @contents = contents
    end

    def url
      "/#{@relative}"
    end

    def write?
      true
    end

    def write(dest)
      dest_path = destination(dest)
      FileUtils.mkdir_p(File.dirname(dest_path))
      File.write(dest_path, @contents, encoding: "UTF-8")
      true
    end
  end
end
