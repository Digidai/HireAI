---
layout: default
title: Product Directory
description: "Browse all HR AI products by technology era, with tags, direct links, and analysis pages."
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
    <div class="page-icon">*</div>
    <h1 class="page-title">Product Directory</h1>
    <p class="page-description">Complete list of HR AI products organized by technology era.</p>
</div>

<div style="margin: 16px 0 28px;">
    <input type="text" class="search-input" id="product-directory-search" placeholder="Search products...">
    <span id="product-directory-results" style="margin-left: 10px; font-size: 13px; color: var(--text-tertiary);"></span>
</div>

{% for category in site.data.products %}
<section class="category-section" id="{{ category.era | slugify }}">
    <div class="category-header">
        <span class="category-icon">{{ category.icon }}</span>
        <h2 class="category-title">{{ category.era | split: ' - ' | last }}</h2>
        <span class="category-era">{{ category.era | split: ' - ' | first }}</span>
    </div>

    <div class="cards-grid">
        {% for product in category.products %}
        {% include product-card.html product=product %}
        {% endfor %}
    </div>
</section>
{% endfor %}

<div class="page-footer">
    <a href="{{ site.baseurl }}/" class="btn btn-secondary">Back to Home</a>
</div>
