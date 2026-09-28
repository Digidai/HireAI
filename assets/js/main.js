// Theme toggle
const themeToggle = document.getElementById('theme-toggle');
const html = document.documentElement;

function currentTheme() {
    return html.getAttribute('data-theme') === 'dark' ? 'dark' : 'light';
}

if (!html.getAttribute('data-theme')) {
    const savedTheme = localStorage.getItem('theme');
    const theme = savedTheme || (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
    html.setAttribute('data-theme', theme);
}

if (themeToggle) {
    themeToggle.setAttribute('aria-pressed', currentTheme() === 'dark' ? 'true' : 'false');
    themeToggle.addEventListener('click', () => {
        const newTheme = currentTheme() === 'light' ? 'dark' : 'light';
        html.setAttribute('data-theme', newTheme);
        localStorage.setItem('theme', newTheme);
        themeToggle.setAttribute('aria-pressed', newTheme === 'dark' ? 'true' : 'false');
    });
}

// Mobile menu
const mobileMenuBtn = document.getElementById('mobile-menu-btn');
const sidebar = document.getElementById('site-sidebar');
const sidebarBackdrop = document.getElementById('sidebar-backdrop');

function setSidebarOpen(open) {
    if (!sidebar || !mobileMenuBtn) return;
    sidebar.classList.toggle('open', open);
    mobileMenuBtn.setAttribute('aria-expanded', open ? 'true' : 'false');
    mobileMenuBtn.setAttribute('aria-label', open ? 'Close navigation menu' : 'Open navigation menu');
    if (sidebarBackdrop) sidebarBackdrop.hidden = !open;
    document.body.classList.toggle('sidebar-open', open);
}

if (mobileMenuBtn && sidebar) {
    mobileMenuBtn.addEventListener('click', () => {
        setSidebarOpen(!sidebar.classList.contains('open'));
    });

    if (sidebarBackdrop) {
        sidebarBackdrop.addEventListener('click', () => setSidebarOpen(false));
    }

    sidebar.querySelectorAll('a').forEach((link) => {
        link.addEventListener('click', () => {
            if (window.matchMedia('(max-width: 768px)').matches) setSidebarOpen(false);
        });
    });

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') setSidebarOpen(false);
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

// Debounce utility function
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

function initProductTableSearch() {
    const input = document.getElementById('product-search');
    const table = document.getElementById('product-table');
    if (!input || !table) return;

    const rows = table.querySelectorAll('tbody tr');

    const performSearch = debounce(function (searchTerm) {
        const term = (searchTerm || '').toLowerCase();
        rows.forEach(row => {
            const text = (row.textContent || '').toLowerCase();
            row.style.display = text.includes(term) ? '' : 'none';
        });
    }, 200);

    input.addEventListener('input', function (e) {
        performSearch(e.target.value);
    });
}

function initTagSearch() {
    const input = document.getElementById('tag-search');
    if (!input) return;

    const tags = document.querySelectorAll('.tag-cloud a.tag');
    if (!tags.length) return;

    const performSearch = debounce(function (searchTerm) {
        const term = (searchTerm || '').toLowerCase();
        tags.forEach(tag => {
            tag.style.display = tag.textContent.toLowerCase().includes(term) ? '' : 'none';
        });
    }, 200);

    input.addEventListener('input', function (e) {
        performSearch(e.target.value);
    });
}

// Product Directory Search with Fuse.js fuzzy matching
let productFuse = null;
let productCards = [];
let allSections = [];

function buildProductIndex() {
    const sections = document.querySelectorAll('section.category-section');
    if (!sections.length) return false;

    allSections = Array.from(sections);
    productCards = [];

    sections.forEach((section, sectionIndex) => {
        const cards = section.querySelectorAll('.cards-grid .card');
        cards.forEach((card, cardIndex) => {
            const title = card.querySelector('.card-title')?.textContent || '';
            const description = card.querySelector('.card-description')?.textContent || '';
            const tags = Array.from(card.querySelectorAll('.tag')).map(t => t.textContent).join(' ');

            productCards.push({
                element: card,
                section: section,
                sectionIndex: sectionIndex,
                title: title.trim(),
                description: description.trim(),
                tags: tags.trim(),
                text: `${title} ${description} ${tags}`.toLowerCase()
            });
        });
    });

    // Initialize Fuse.js if available
    if (typeof Fuse !== 'undefined' && productCards.length > 0) {
        productFuse = new Fuse(productCards, {
            keys: [
                { name: 'title', weight: 0.4 },
                { name: 'description', weight: 0.3 },
                { name: 'tags', weight: 0.3 }
            ],
            threshold: 0.4,
            ignoreLocation: true,
            includeScore: true
        });
    }

    return true;
}

function eraAllows(item) {
    const era = window.activeEraFilter || 'all';
    return era === 'all' || item.section.id === era;
}

function filterProductDirectoryCards(query) {
    const q = (query || '').trim();

    if (!productCards.length && !buildProductIndex()) {
        return;
    }

    const totalCards = productCards.length;
    let visibleCards = 0;
    const sectionVisibility = new Map();

    // Initialize section visibility
    allSections.forEach(section => sectionVisibility.set(section, 0));

    if (q === '') {
        productCards.forEach(item => {
            const isMatch = eraAllows(item);
            item.element.style.display = isMatch ? '' : 'none';
            if (isMatch) {
                visibleCards++;
                sectionVisibility.set(item.section, sectionVisibility.get(item.section) + 1);
            }
        });
    } else if (productFuse) {
        // Use Fuse.js fuzzy search
        const results = productFuse.search(q);
        const matchedElements = new Set(results.map(r => r.item.element));

        productCards.forEach(item => {
            const isMatch = matchedElements.has(item.element) && eraAllows(item);
            item.element.style.display = isMatch ? '' : 'none';
            if (isMatch) {
                visibleCards++;
                sectionVisibility.set(item.section, sectionVisibility.get(item.section) + 1);
            }
        });
    } else {
        // Fallback to simple includes search
        const lowerQ = q.toLowerCase();
        productCards.forEach(item => {
            const isMatch = item.text.includes(lowerQ) && eraAllows(item);
            item.element.style.display = isMatch ? '' : 'none';
            if (isMatch) {
                visibleCards++;
                sectionVisibility.set(item.section, sectionVisibility.get(item.section) + 1);
            }
        });
    }

    // Update section visibility
    allSections.forEach(section => {
        section.style.display = sectionVisibility.get(section) > 0 ? '' : 'none';
    });

    // Update results count
    const resultsEl = document.getElementById('product-directory-results');
    if (resultsEl) {
        resultsEl.textContent = q === '' ? `${visibleCards} products` : `${visibleCards} / ${totalCards} products`;
    }

    const emptyEl = document.getElementById('directory-empty');
    if (emptyEl) emptyEl.hidden = visibleCards !== 0;
}

function initProductDirectorySearch() {
    const input = document.getElementById('product-directory-search');
    if (!input) return;

    // Build index after DOM is ready
    buildProductIndex();

    const params = new URLSearchParams(window.location.search);
    const initialQuery = params.get('q') || '';
    if (initialQuery) {
        input.value = initialQuery;
    }

    filterProductDirectoryCards(input.value);

    const debouncedFilter = debounce(function (value) {
        filterProductDirectoryCards(value);
    }, 150);

    input.addEventListener('input', (e) => {
        debouncedFilter(e.target.value);
    });

    input.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            input.value = '';
            filterProductDirectoryCards('');
        }
    });
}

// Keyboard shortcuts
function initKeyboardShortcuts() {
    document.addEventListener('keydown', (e) => {
        // Skip if user is typing in an input
        if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') {
            return;
        }

        // "t" to toggle theme
        if (e.key === 't' && !e.ctrlKey && !e.metaKey) {
            const themeBtn = document.getElementById('theme-toggle');
            if (themeBtn) {
                themeBtn.click();
            }
        }

        // "g h" sequence to go home (vim-style: press g then h)
        if (e.key === 'g' && !e.ctrlKey && !e.metaKey) {
            const onKey = (ev) => {
                document.removeEventListener('keydown', onKey);
                if (ev.key === 'h' && !ev.ctrlKey && !ev.metaKey) {
                    window.location.href = '/';
                }
            };
            document.addEventListener('keydown', onKey);
            setTimeout(() => document.removeEventListener('keydown', onKey), 1000);
        }
    });
}

// Lazy load images
function initLazyLoading() {
    if ('IntersectionObserver' in window) {
        const imageObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    if (img.dataset.src) {
                        img.src = img.dataset.src;
                        img.removeAttribute('data-src');
                    }
                    observer.unobserve(img);
                }
            });
        }, { rootMargin: '50px' });

        document.querySelectorAll('img[data-src]').forEach(img => {
            imageObserver.observe(img);
        });
    }
}

// Back to top functionality (using CSS classes instead of inline styles)
function initBackToTop() {
    let backToTop = document.getElementById('back-to-top');

    if (!backToTop) {
        backToTop = document.createElement('button');
        backToTop.id = 'back-to-top';
        backToTop.className = 'back-to-top';
        backToTop.innerHTML = '&#8593;';
        backToTop.setAttribute('aria-label', 'Back to top');
        document.body.appendChild(backToTop);
    }

    const toggleVisibility = () => {
        if (window.scrollY > 300) {
            backToTop.classList.add('visible');
        } else {
            backToTop.classList.remove('visible');
        }
    };

    window.addEventListener('scroll', debounce(toggleVisibility, 100), { passive: true });

    backToTop.addEventListener('click', () => {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });
}

// Initialize all features
initProductTableSearch();
initTagSearch();
initProductDirectorySearch();
initKeyboardShortcuts();
initLazyLoading();
initBackToTop();
