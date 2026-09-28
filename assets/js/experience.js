(function () {
    const dialog = document.getElementById('search-dialog');
    const input = document.getElementById('global-search');
    const results = document.getElementById('global-search-results');
    const empty = document.getElementById('global-search-empty');
    const indexNode = document.getElementById('product-index');
    let products = [];
    let activeIndex = -1;
    let lastFocus = null;

    try {
        products = JSON.parse(indexNode ? indexNode.textContent : '[]');
    } catch (error) {
        products = [];
    }

    function resultHref(product) {
        return product.a || product.u;
    }

    function renderResults(query) {
        if (!results) return;
        const q = (query || '').trim().toLowerCase();
        results.innerHTML = '';
        activeIndex = -1;

        if (!q) {
            if (empty) empty.hidden = true;
            return;
        }

        const matches = products.filter((product) => {
            const haystack = `${product.n} ${product.d} ${product.e}`.toLowerCase();
            return haystack.includes(q);
        }).slice(0, 8);

        if (empty) empty.hidden = matches.length !== 0;

        matches.forEach((product, index) => {
            const item = document.createElement('li');
            item.setAttribute('role', 'presentation');
            const link = document.createElement('a');
            link.className = 'search-hit';
            link.href = resultHref(product);
            link.setAttribute('role', 'option');
            link.id = `search-hit-${index}`;
            if (!product.a) {
                link.target = '_blank';
                link.rel = 'noopener noreferrer';
            }
            const name = document.createElement('strong');
            name.textContent = product.n;
            const meta = document.createElement('small');
            meta.textContent = product.e;
            link.append(name, meta);
            item.appendChild(link);
            results.appendChild(item);
        });
    }

    function setActive(index) {
        const options = results ? results.querySelectorAll('[role="option"]') : [];
        options.forEach((option) => option.classList.remove('is-active'));
        if (!options.length) {
            activeIndex = -1;
            input.removeAttribute('aria-activedescendant');
            return;
        }
        activeIndex = (index + options.length) % options.length;
        options[activeIndex].classList.add('is-active');
        input.setAttribute('aria-activedescendant', options[activeIndex].id);
        options[activeIndex].scrollIntoView({ block: 'nearest' });
    }

    function openSearch() {
        if (!dialog || !input) return;
        lastFocus = document.activeElement;
        dialog.hidden = false;
        document.body.classList.add('search-open');
        input.value = '';
        renderResults('');
        input.focus();
    }

    function closeSearch() {
        if (!dialog) return;
        dialog.hidden = true;
        document.body.classList.remove('search-open');
        if (lastFocus && typeof lastFocus.focus === 'function') lastFocus.focus();
    }

    document.querySelectorAll('.js-open-search').forEach((button) => {
        button.addEventListener('click', openSearch);
    });

    if (dialog) {
        dialog.querySelectorAll('[data-close-search]').forEach((node) => {
            node.addEventListener('click', closeSearch);
        });
    }

    if (input) {
        input.addEventListener('input', (event) => renderResults(event.target.value));
        input.addEventListener('keydown', (event) => {
            const options = results.querySelectorAll('[role="option"]');
            if (event.key === 'ArrowDown') {
                event.preventDefault();
                setActive(activeIndex + 1);
            } else if (event.key === 'ArrowUp') {
                event.preventDefault();
                setActive(activeIndex < 0 ? options.length - 1 : activeIndex - 1);
            } else if (event.key === 'Enter' && activeIndex >= 0 && options[activeIndex]) {
                event.preventDefault();
                options[activeIndex].click();
            } else if (event.key === 'Escape') {
                event.preventDefault();
                closeSearch();
            }
        });
    }

    document.addEventListener('keydown', (event) => {
        const typing = event.target && (event.target.tagName === 'INPUT' || event.target.tagName === 'TEXTAREA');
        if ((event.metaKey || event.ctrlKey) && event.key.toLowerCase() === 'k') {
            event.preventDefault();
            openSearch();
            return;
        }
        if (!typing && event.key === '/' && !event.metaKey && !event.ctrlKey && !event.altKey) {
            event.preventDefault();
            openSearch();
        }
        if (event.key === 'Escape' && dialog && !dialog.hidden) closeSearch();
    });

    document.querySelectorAll('[data-era-filter]').forEach((button) => {
        button.addEventListener('click', () => {
            const era = button.getAttribute('data-era-filter') || 'all';
            window.activeEraFilter = era;
            document.querySelectorAll('[data-era-filter]').forEach((peer) => {
                const selected = peer === button;
                peer.classList.toggle('active', selected);
                peer.setAttribute('aria-pressed', selected ? 'true' : 'false');
            });
            if (typeof filterProductDirectoryCards === 'function') {
                const directorySearch = document.getElementById('product-directory-search');
                filterProductDirectoryCards(directorySearch ? directorySearch.value : '');
            }
            if (era !== 'all') {
                const target = document.getElementById(era);
                if (target) target.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        });
    });

    function uniqueHeadingId(base) {
        let id = base || 'section';
        let n = 2;
        while (document.getElementById(id)) {
            id = `${base}-${n}`;
            n += 1;
        }
        return id;
    }

    document.querySelectorAll('.markdown-content > h1').forEach((heading) => {
        if (!document.querySelector('.page-title, .product-header h1')) return;
        const next = document.createElement('h2');
        next.innerHTML = heading.innerHTML;
        next.className = 'markdown-lead-title';
        heading.replaceWith(next);
    });

    const toc = document.getElementById('toc');
    const markdown = document.querySelector('.markdown-content');
    const tocScope = markdown || document.getElementById('main-content');
    if (toc && tocScope) {
        const selector = markdown ? 'h2, h3' : 'h2';
        const headings = Array.from(tocScope.querySelectorAll(selector)).filter((heading) => !heading.closest('.site-footer'));
        if (headings.length >= 2) {
            const label = document.createElement('p');
            label.className = 'toc-label';
            label.textContent = 'On this page';
            const list = document.createElement('ol');
            headings.forEach((heading) => {
                if (!heading.id) {
                    const base = (heading.textContent || 'section')
                        .toLowerCase()
                        .trim()
                        .replace(/[^a-z0-9]+/g, '-')
                        .replace(/^-|-$/g, '');
                    heading.id = uniqueHeadingId(base);
                }
                const item = document.createElement('li');
                if (heading.tagName === 'H3') item.className = 'toc-sub';
                const link = document.createElement('a');
                link.href = `#${heading.id}`;
                link.textContent = heading.textContent.trim();
                item.appendChild(link);
                list.appendChild(item);
            });
            toc.append(label, list);
            toc.hidden = false;
        }
    }

    const progress = document.getElementById('reading-progress');
    if (progress && markdown) {
        progress.hidden = false;
        const updateProgress = () => {
            const rect = markdown.getBoundingClientRect();
            const viewed = Math.min(Math.max(-rect.top, 0), markdown.offsetHeight);
            const ratio = markdown.offsetHeight ? viewed / markdown.offsetHeight : 0;
            progress.style.transform = `scaleX(${Math.min(1, Math.max(0, ratio))})`;
        };
        window.addEventListener('scroll', updateProgress, { passive: true });
        updateProgress();
    }
})();
