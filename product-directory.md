---
layout: default
title: Product Directory
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
                <h3 class="card-title"><a href="{{ product.url }}" target="_blank" rel="noopener">{{ product.name }}</a></h3>
            </div>
            <p class="card-description">{{ product.description }}</p>
            <div class="card-footer">
                {% for tag in product.tags %}
                <a href="{{ site.baseurl }}/tags/{{ tag | slugify }}/" class="tag">{{ tag }}</a>
                {% endfor %}
            </div>
            {% if product.analysis %}
            <div style="margin-top: 12px;">
                <a href="{{ site.baseurl }}/{{ product.analysis | replace: '.md', '' }}/" class="btn btn-outline">Read Analysis</a>
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

<script>
function filterProductDirectoryCards(query) {
    const q = (query || '').trim().toLowerCase();
    const sections = document.querySelectorAll('section.category-section');

    let totalCards = 0;
    let visibleCards = 0;

    sections.forEach(section => {
        const cards = section.querySelectorAll('.cards-grid .card');
        let sectionVisible = 0;

        cards.forEach(card => {
            totalCards += 1;
            const text = (card.textContent || '').toLowerCase();
            const show = q === '' || text.includes(q);
            card.style.display = show ? '' : 'none';
            if (show) {
                visibleCards += 1;
                sectionVisible += 1;
            }
        });

        section.style.display = sectionVisible > 0 ? '' : 'none';
    });

    const resultsEl = document.getElementById('product-directory-results');
    if (resultsEl) {
        resultsEl.textContent = q === '' ? `${totalCards} products` : `${visibleCards} / ${totalCards} products`;
    }
}

const searchInput = document.getElementById('product-directory-search');
if (searchInput) {
    const params = new URLSearchParams(window.location.search);
    const initialQuery = params.get('q') || '';
    if (initialQuery) {
        searchInput.value = initialQuery;
    }

    filterProductDirectoryCards(searchInput.value);

    searchInput.addEventListener('input', (e) => {
        filterProductDirectoryCards(e.target.value);
    });

    searchInput.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            searchInput.value = '';
            filterProductDirectoryCards('');
        }
    });
}
</script>
