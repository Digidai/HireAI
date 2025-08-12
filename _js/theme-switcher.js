const themeSwitcher = document.getElementById('theme-switcher');
const body = document.body;

const savedTheme = localStorage.getItem('theme');
if (savedTheme) {
    body.classList.add(savedTheme);
    if (savedTheme === 'dark-mode') {
        themeSwitcher.textContent = '☀️';
    }
} else {
    body.classList.add('dark-mode');
    localStorage.setItem('theme', 'dark-mode');
    themeSwitcher.textContent = '☀️';
}

themeSwitcher.addEventListener('click', () => {
    if (body.classList.contains('dark-mode')) {
        body.classList.remove('dark-mode');
        localStorage.setItem('theme', 'light-mode');
        themeSwitcher.textContent = '🌙';
    } else {
        body.classList.add('dark-mode');
        localStorage.setItem('theme', 'dark-mode');
        themeSwitcher.textContent = '☀️';
    }
});