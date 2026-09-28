---
layout: default
title: HR AI Product Tags
seo_title: "HR AI Product Tags | HireAI"
description: "Browse HR AI products by capability tag, with evaluation checklists for ATS, sourcing, assessment, agentic AI, and more."
permalink: /tags/
---
<div class="page-header">
    <p class="eyebrow">Capabilities</p>
    <h1 class="page-title">Tags</h1>
    <p class="answer-lead">Tags group HR AI products by capability, such as ATS, sourcing, assessment, or agentic AI. Open a tag to see matching products and an evaluation checklist.</p>
</div>

<section class="section">
    <div class="section-header">
        <span class="section-icon">{% include icon.html name="link" %}</span>
        <h2 class="section-title">All Tags</h2>
    </div>
    <div class="search-bar">
        <input type="text" class="search-input" id="tag-search" placeholder="Search tags...">
    </div>
    <div class="tag-cloud">
        {% assign all_tags = "" | split: "" %}
        {% for category in site.data.products %}
            {% for product in category.products %}
                {% for tag in product.tags %}
                    {% assign all_tags = all_tags | push: tag %}
                {% endfor %}
            {% endfor %}
        {% endfor %}
        {% assign unique_tags = all_tags | uniq | sort %}
        {% for tag in unique_tags %}
            <a href="{{ site.baseurl }}/tags/{{ tag | slugify }}/" class="tag">{{ tag | escape }}</a>
        {% endfor %}
    </div>
</section>
