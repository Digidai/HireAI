// Theme toggle
const themeToggle = document.getElementById('theme-toggle');
const html = document.documentElement;

const savedTheme = localStorage.getItem('theme') || 'light';
html.setAttribute('data-theme', savedTheme);

if (themeToggle) {
    themeToggle.addEventListener('click', () => {
        const currentTheme = html.getAttribute('data-theme');
        const newTheme = currentTheme === 'light' ? 'dark' : 'light';
        html.setAttribute('data-theme', newTheme);
        localStorage.setItem('theme', newTheme);
    });
}

// Mobile menu
const mobileMenuBtn = document.getElementById('mobile-menu-btn');
const sidebar = document.querySelector('.sidebar');

if (mobileMenuBtn && sidebar) {
    mobileMenuBtn.addEventListener('click', () => {
        sidebar.classList.toggle('open');
    });

    document.addEventListener('click', (e) => {
        if (!sidebar.contains(e.target) && !mobileMenuBtn.contains(e.target)) {
            sidebar.classList.remove('open');
        }
    });
}

// Smooth scroll for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    });
});

function initProductTableSearch() {
    const input = document.getElementById('product-search');
    const table = document.getElementById('product-table');
    if (!input || !table) return;

    const rows = table.querySelectorAll('tbody tr');

    input.addEventListener('input', function (e) {
        const searchTerm = (e.target.value || '').toLowerCase();
        rows.forEach(row => {
            const text = (row.textContent || '').toLowerCase();
            row.style.display = text.includes(searchTerm) ? '' : 'none';
        });
    });
}

function initTagSearch() {
    const input = document.getElementById('tag-search');
    if (!input) return;

    const tags = document.querySelectorAll('.tag-cloud a.tag');
    if (!tags.length) return;

    input.addEventListener('input', function (e) {
        const searchTerm = (e.target.value || '').toLowerCase();
        tags.forEach(tag => {
            tag.style.display = tag.textContent.toLowerCase().includes(searchTerm) ? '' : 'none';
        });
    });
}

function filterProductDirectoryCards(query) {
    const q = (query || '').trim().toLowerCase();
    const sections = document.querySelectorAll('section.category-section');
    if (!sections.length) return;

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

function initProductDirectorySearch() {
    const input = document.getElementById('product-directory-search');
    if (!input) return;

    const params = new URLSearchParams(window.location.search);
    const initialQuery = params.get('q') || '';
    if (initialQuery) {
        input.value = initialQuery;
    }

    filterProductDirectoryCards(input.value);

    input.addEventListener('input', (e) => {
        filterProductDirectoryCards(e.target.value);
    });

    input.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            input.value = '';
            filterProductDirectoryCards('');
        }
    });
}

initProductTableSearch();
initTagSearch();
initProductDirectorySearch();
