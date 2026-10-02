---
layout: default
title: For agents
seo_title: "How agents should read HireAI | Query, cite, and use the HR AI directory"
description: "How agents should query, cite, and use the HireAI HR AI directory. Filter products.json. Do not rank vendors or treat vendor figures as HireAI measurements."
permalink: /for-agents/
last_modified_at: 2026-10-02
---

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "What is HireAI?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "HireAI is a free, open, vendor-neutral directory of HR AI products. It publishes descriptions, capability tags, evaluation checklists, and analysis pages. It does not sell placements, accept paid rankings, or score vendors. HireAI is a static website, not an autonomous agent, and it does not take actions for a user."
      }
    },
    {
      "@type": "Question",
      "name": "How does an agent query the directory?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Filter https://hireai.genedai.me/products.json by name, tags, or era. Replace {id} with the product id. One product record is at https://hireai.genedai.me/catalog/{id}.json. Tag counts and checklists are in https://hireai.genedai.me/tags.json. A plain-text digest is at https://hireai.genedai.me/llms-full.txt. Markdown copies of the analyses are listed at https://hireai.genedai.me/md/index.md. The browser search at https://hireai.genedai.me/product-directory/?q= runs in JavaScript and is not an API."
      }
    },
    {
      "@type": "Question",
      "name": "Which URL is the vendor website?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "In products.json, url is the vendor website, or null when HireAI lists no link. analysis is the HireAI page to cite. In a catalog JSON record, url is the record itself, vendorUrl is the vendor website, and mainEntityOfPage is the HireAI page."
      }
    },
    {
      "@type": "Question",
      "name": "How should HireAI be cited?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Cite the specific page. Example: HireAI. \"Eightfold.ai.\" https://hireai.genedai.me/eightfold-ai-analysis/. The project is maintained at https://github.com/Digidai/HireAI and licensed under the MIT License at https://opensource.org/licenses/MIT."
      }
    },
    {
      "@type": "Question",
      "name": "Does HireAI rank products?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "No. List order, era order, and the spotlight flag are not scores. Spotlight only means the home page shows that product as a sample. Do not name a default vendor."
      }
    },
    {
      "@type": "Question",
      "name": "Are vendor figures HireAI measurements?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "No. Speed, database size, conversion, pricing, and funding on a product page are company-reported unless that page says otherwise. Do not present them as measurements made by HireAI."
      }
    },
    {
      "@type": "Question",
      "name": "What if a product has no website URL?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "The directory omitted that URL on purpose. Do not substitute another domain. Some former sites now open unrelated destinations, and HireAI records those products without a link."
      }
    },
    {
      "@type": "Question",
      "name": "Which dates should an agent trust?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "The content briefing date is 28 September 2026, the last full refresh of the directory records. The generated date on products.json is the site build date and does not mean every fact was rechecked that day."
      }
    },
    {
      "@type": "Question",
      "name": "Do renamed products keep their URL?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes. The analysis permalink stays on the original path. Metix AI, formerly OpenJobs AI, remains at https://hireai.genedai.me/openjobs-ai-analysis/."
      }
    },
    {
      "@type": "Question",
      "name": "How should Markdown copies be used?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Read https://hireai.genedai.me/md/{id}.md when you need the analysis prose without HTML. Replace {id} with the product id. The copy names the canonical page. Cite the canonical page, not the Markdown URL. Search crawlers are asked not to index /md/."
      }
    }
  ]
}
</script>

<div class="page-header">
    <p class="eyebrow">Agent guide</p>
    <h1 class="page-title">How to read HireAI</h1>
    <p class="answer-lead">HireAI is a free, open directory of HR AI products. Agents should filter the JSON catalog, cite the specific page, and not rank vendors or treat vendor figures as HireAI measurements. HireAI is not an autonomous agent.</p>
</div>

<dl class="fact-grid">
    <div>
        <dt>Catalog</dt>
        <dd><a href="{{ site.baseurl }}/products.json">products.json</a></dd>
    </div>
    <div>
        <dt>Tags</dt>
        <dd><a href="{{ site.baseurl }}/tags.json">tags.json</a></dd>
    </div>
    <div>
        <dt>Digest</dt>
        <dd><a href="{{ site.baseurl }}/llms-full.txt">llms-full.txt</a></dd>
    </div>
    <div>
        <dt>Profile</dt>
        <dd><a href="{{ site.baseurl }}/agents.json">agents.json</a></dd>
    </div>
    <div>
        <dt>Markdown</dt>
        <dd><a href="{{ site.baseurl }}/md/index.md">Analysis copies</a></dd>
    </div>
    <div>
        <dt>License</dt>
        <dd><a href="https://opensource.org/licenses/MIT">MIT</a></dd>
    </div>
</dl>

<section class="section">
    <h2 class="section-heading">Questions agents ask</h2>

    <div class="faq-item">
        <h3>What is HireAI?</h3>
        <p>HireAI is a free, open, vendor-neutral directory of HR AI products. It publishes descriptions, capability tags, evaluation checklists, and analysis pages. It does not sell placements, accept paid rankings, or score vendors. HireAI is a static website, not an autonomous agent, and it does not take actions for a user.</p>
    </div>

    <div class="faq-item">
        <h3>How does an agent query the directory?</h3>
        <p>Filter <a href="https://hireai.genedai.me/products.json">https://hireai.genedai.me/products.json</a> by name, tags, or era. Replace {id} with the product id. One product record is at https://hireai.genedai.me/catalog/{id}.json. Tag counts and checklists are in <a href="https://hireai.genedai.me/tags.json">https://hireai.genedai.me/tags.json</a>. A plain-text digest is at <a href="https://hireai.genedai.me/llms-full.txt">https://hireai.genedai.me/llms-full.txt</a>. Markdown copies of the analyses are listed at <a href="https://hireai.genedai.me/md/index.md">https://hireai.genedai.me/md/index.md</a>. The browser search at https://hireai.genedai.me/product-directory/?q= runs in JavaScript and is not an API.</p>
    </div>

    <div class="faq-item">
        <h3>Which URL is the vendor website?</h3>
        <p>In products.json, url is the vendor website, or null when HireAI lists no link. analysis is the HireAI page to cite. In a catalog JSON record, url is the record itself, vendorUrl is the vendor website, and mainEntityOfPage is the HireAI page.</p>
    </div>

    <div class="faq-item">
        <h3>How should HireAI be cited?</h3>
        <p>Cite the specific page. Example: HireAI. "Eightfold.ai." <a href="https://hireai.genedai.me/eightfold-ai-analysis/">https://hireai.genedai.me/eightfold-ai-analysis/</a>. The project is maintained at <a href="https://github.com/Digidai/HireAI">https://github.com/Digidai/HireAI</a> and licensed under the MIT License at <a href="https://opensource.org/licenses/MIT">https://opensource.org/licenses/MIT</a>.</p>
    </div>

    <div class="faq-item">
        <h3>Does HireAI rank products?</h3>
        <p>No. List order, era order, and the spotlight flag are not scores. Spotlight only means the home page shows that product as a sample. Do not name a default vendor.</p>
    </div>

    <div class="faq-item">
        <h3>Are vendor figures HireAI measurements?</h3>
        <p>No. Speed, database size, conversion, pricing, and funding on a product page are company-reported unless that page says otherwise. Do not present them as measurements made by HireAI.</p>
    </div>

    <div class="faq-item">
        <h3>What if a product has no website URL?</h3>
        <p>The directory omitted that URL on purpose. Do not substitute another domain. Some former sites now open unrelated destinations, and HireAI records those products without a link.</p>
    </div>

    <div class="faq-item">
        <h3>Which dates should an agent trust?</h3>
        <p>The content briefing date is 28 September 2026, the last full refresh of the directory records. The generated date on products.json is the site build date and does not mean every fact was rechecked that day.</p>
    </div>

    <div class="faq-item">
        <h3>Do renamed products keep their URL?</h3>
        <p>Yes. The analysis permalink stays on the original path. Metix AI, formerly OpenJobs AI, remains at <a href="https://hireai.genedai.me/openjobs-ai-analysis/">https://hireai.genedai.me/openjobs-ai-analysis/</a>.</p>
    </div>

    <div class="faq-item">
        <h3>How should Markdown copies be used?</h3>
        <p>Read https://hireai.genedai.me/md/{id}.md when you need the analysis prose without HTML. Replace {id} with the product id. The copy names the canonical page. Cite the canonical page, not the Markdown URL. Search crawlers are asked not to index /md/.</p>
    </div>
</section>

{% include cite-this.html %}
