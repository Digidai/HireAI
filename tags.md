---
layout: default
title: All Tags
permalink: /tags/
---
<div class="page-header">
    <div class="page-icon">#</div>
    <h1 class="page-title">Tags</h1>
    <p class="page-description">Browse HR AI products by technology category and feature tags.</p>
</div>

<section class="section">
    <div class="section-header">
        <span class="section-icon">&</span>
        <h2 class="section-title">All Tags</h2>
    </div>
    <div style="margin: 16px 0;">
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
            <a href="{{ site.baseurl }}/tags/{{ tag | slugify }}/" class="tag">{{ tag }}</a>
        {% endfor %}
    </div>
</section>

<script>
document.getElementById('tag-search').addEventListener('input', function(e) {
    const searchTerm = e.target.value.toLowerCase();
    document.querySelectorAll('.tag-cloud a.tag').forEach(tag => {
        tag.style.display = tag.textContent.toLowerCase().includes(searchTerm) ? '' : 'none';
    });
});
</script>
