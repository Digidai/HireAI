document.addEventListener('DOMContentLoaded', () => {
    const searchInput = document.getElementById('table-search');
    const table = document.getElementById('comparison-table');
    const tableBody = table ? table.querySelector('tbody') : null;

    if (!tableBody) return;

    const rows = Array.from(tableBody.querySelectorAll('tr'));

    if (searchInput) {
        searchInput.addEventListener('keyup', (e) => {
            const query = e.target.value.toLowerCase();
            rows.forEach(row => {
                const productName = row.querySelector('td:first-child').textContent.toLowerCase();
                if (productName.includes(query)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    }

    const sortTable = (colIndex, ascending = true) => {
        const sortedRows = rows.sort((a, b) => {
            const aVal = a.querySelector(`td:nth-child(${colIndex})`).textContent.trim();
            const bVal = b.querySelector(`td:nth-child(${colIndex})`).textContent.trim();
            return aVal.localeCompare(bVal, undefined, {numeric: false}) * (ascending ? 1 : -1);
        });

        sortedRows.forEach(row => tableBody.appendChild(row));
    };

    const sortNameAsc = document.getElementById('sort-name-asc');
    if(sortNameAsc) {
        sortNameAsc.addEventListener('click', () => sortTable(1, true));
    }

    const sortNameDesc = document.getElementById('sort-name-desc');
    if(sortNameDesc) {
        sortNameDesc.addEventListener('click', () => sortTable(1, false));
    }
});