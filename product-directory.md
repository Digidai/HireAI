---
layout: default
title: Product Directory
---

<main class="main-content">
    <section class="section">
        <h2>HR AI Product Directory</h2>
        {% for category in site.data.products %}
        <div class="product-category">
            <h3>{{ category.icon }} {{ category.era }}</h3>
            <ul class="product-list">
                {% for product in category.products %}
                <li>
                    <h4><a href="{{ product.url }}">{{ product.name }}</a></h4>
                    <p>{{ product.description }}</p>
                    {% if product.analysis %}
                    <a href="{{ product.analysis | relative_url }}">Read Analysis</a>
                    {% endif %}
                </li>
                {% endfor %}
            </ul>
        </div>
        {% endfor %}
    </section>
</main>
