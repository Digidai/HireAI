document.addEventListener('DOMContentLoaded', () => {
    const tocContainer = document.querySelector('.toc');
    const content = document.querySelector('.analysis-content');

    if (tocContainer && content) {
        const headings = content.querySelectorAll('h2, h3');
        if (headings.length > 0) {
            const tocList = document.createElement('ul');
            let currentH2List;
            const usedIds = new Set(); // To track used IDs

            headings.forEach(heading => {
                let baseId = heading.textContent.toLowerCase().replace(/\s+/g, '-').replace(/[^\w-]+/g, '');
                let id = baseId;
                let counter = 1;
                while (usedIds.has(id)) { // Ensure uniqueness
                    id = `${baseId}-${counter}`;
                    counter++;
                }
                usedIds.add(id); // Add the new unique ID to the set

                heading.id = id;

                const listItem = document.createElement('li');
                const link = document.createElement('a');
                link.href = `#${id}`;
                link.textContent = heading.textContent;
                listItem.appendChild(link);

                if (heading.tagName === 'H2') {
                    tocList.appendChild(listItem);
                    currentH2List = document.createElement('ul');
                    listItem.appendChild(currentH2List);
                } else if (heading.tagName === 'H3' && currentH2List) {
                    currentH2List.appendChild(listItem);
                }
            });
            tocContainer.appendChild(tocList);
        }
    }
});