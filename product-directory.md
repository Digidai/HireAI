---
layout: default
title: HR AI Product Directory
seo_title: "HR AI Product Directory | HireAI"
description: "Directory of HR AI products grouped by technology era, from 1990s applicant tracking systems to 2024+ agentic AI platforms."
permalink: /product-directory/
---
{% assign total_products = 0 %}
{% for category in site.data.products %}
    {% assign total_products = total_products | plus: category.products.size %}
{% endfor %}

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "CollectionPage",
  "name": "HR AI Product Directory",
  "description": "Complete directory of {{ total_products }}+ HR AI products organized by technology era, from 1990s ATS to 2024+ Agentic AI platforms.",
  "url": "{{ site.url }}{{ site.baseurl }}/product-directory/",
  "isPartOf": {
    "@type": "WebSite",
    "name": "{{ site.title }}",
    "url": "{{ site.url }}{{ site.baseurl }}"
  },
  "about": {
    "@type": "Thing",
    "name": "HR AI Software",
    "description": "Human Resources Artificial Intelligence Products and Solutions"
  },
  "numberOfItems": {{ total_products }},
  "mainEntity": {
    "@type": "ItemList",
    "itemListOrder": "https://schema.org/ItemListOrderDescending",
    "numberOfItems": {{ total_products }},
    "itemListElement": [
      {% assign position = 0 %}
      {% assign items_json = "" | split: "" %}
      {% for category in site.data.products %}
        {% for product in category.products limit: 5 %}
          {% assign position = position | plus: 1 %}
          {% if position <= 20 %}
            {% capture item_json %}{"@type": "ListItem", "position": {{ position }}, "item": {"@type": "SoftwareApplication", "name": {{ product.name | jsonify }}, "description": {{ product.description | jsonify }}, "url": {{ product.url | jsonify }}, "applicationCategory": "BusinessApplication", "operatingSystem": "Web"}}{% endcapture %}
            {% assign items_json = items_json | push: item_json %}
          {% endif %}
        {% endfor %}
      {% endfor %}
      {{ items_json | join: ", " }}
    ]
  }
}
</script>

<div class="page-header">
    <p class="eyebrow">Product directory</p>
    <h1 class="page-title">HR AI products by era</h1>
    <p class="answer-lead">This directory lists {{ total_products }} HR AI products in {{ site.data.products.size }} technology eras, from 1990s applicant tracking systems to 2024+ agentic AI platforms. Search by product, vendor, or capability. Each card links to the vendor site and, when available, a HireAI analysis.</p>
</div>

<nav class="era-nav" aria-label="Filter by technology era">
    <button type="button" class="pill-chip active" data-era-filter="all" aria-pressed="true">All eras</button>
    {% for category in site.data.products %}
    <button type="button" class="pill-chip" data-era-filter="{{ category.era | slugify }}" aria-pressed="false">{{ category.era | split: ' - ' | first | escape }}</button>
    {% endfor %}
</nav>

<div class="search-bar">
    <label class="sr-only" for="product-directory-search">Search the product directory</label>
    <input type="search" class="search-input" id="product-directory-search" placeholder="Search products, vendors, or tags" enterkeyhint="search">
    <span id="product-directory-results" class="search-results"></span>
</div>
<p id="directory-empty" class="empty-state" hidden>No products match that search.</p>

{% for category in site.data.products %}
<section class="category-section" id="{{ category.era | slugify }}">
    <div class="category-header">
        <span class="category-icon">{% include icon.html name=category.icon %}</span>
        <h2 class="category-title">{{ category.era | split: ' - ' | last }}</h2>
        <span class="category-era">{{ category.era | split: ' - ' | first }} · {{ category.products.size }}</span>
    </div>
    {% if category.summary %}
    <p class="category-summary">{{ category.summary | escape }}</p>
    {% endif %}

    <div class="cards-grid">
        {% for product in category.products %}
        {% include product-card.html product=product category=category %}
        {% endfor %}
    </div>
</section>
{% endfor %}

<div class="page-footer">
    <a href="{{ site.baseurl }}/" class="btn btn-secondary">Back to Home</a>
</div>
