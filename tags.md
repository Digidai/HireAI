---
layout: default
title: All Tags
permalink: /tags/
---
<main class="main-content">
    <section class="section">
        <h2>All Tags</h2>
        <div class="tag-cloud">
            {% assign tags = site.data.products | map: 'products' | map: 'tags' | join: ',' | split: ',' | uniq | sort %}
            {% for tag in tags %}
                {% if tag != "" %}
                    <a href="{{ site.baseurl }}/tags/{{ tag | downcase | replace: ' ', '-' }}/" class="tag-link">{{ tag }}</a>
                {% endif %}
            {% endfor %}
        </div>
    </section>
</main>