---
layout: default
title: Product Directory
description: "Browse all HR AI products by technology era, with tags, direct links, and analysis pages."
permalink: /product-directory/
---
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
        <div class="card">
            <div class="card-header">
                <h3 class="card-title"><a href="{{ product.url | escape }}" target="_blank" rel="noopener noreferrer">{{ product.name | escape }}</a></h3>
            </div>
            <p class="card-description">{{ product.description | escape }}</p>
            <div class="card-footer">
                {% for tag in product.tags %}
                <a href="{{ site.baseurl }}/tags/{{ tag | slugify }}/" class="tag">{{ tag | escape }}</a>
                {% endfor %}
            </div>
            {% if product.analysis %}
            <div style="margin-top: 12px;">
                <a href="{{ site.baseurl }}/{{ product.analysis | replace: '_analyses/', '' | replace: '.md', '' }}/" class="btn btn-outline">Read Analysis</a>
            </div>
            {% endif %}
        </div>
        {% endfor %}
    </div>
</section>
{% endfor %}

<div class="page-footer">
    <a href="{{ site.baseurl }}/" class="btn btn-secondary">Back to Home</a>
</div>
