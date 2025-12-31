document.addEventListener("turbo:load", () => {
  console.log("theme.js: turbo:load fired"); // debug

  const toggle = document.getElementById("theme-toggle");
  const icon = toggle ? toggle.nextElementSibling : null;
  console.log("toggle:", toggle, "icon:", icon); // debug

  if (!toggle || !icon) return;

  const applyTheme = (theme) => {
    document.documentElement.dataset.theme = theme;
    document.documentElement.classList.toggle("persist-dark", theme === "dark");
    toggle.checked = theme === "dark";
    icon.textContent = theme === "dark" ? "☀️" : "🌙";
  };

  const savedTheme = localStorage.getItem("theme") || "light";
  applyTheme(savedTheme);

  toggle.onchange = () => {
    const next = toggle.checked ? "dark" : "light";
    localStorage.setItem("theme", next);
    applyTheme(next);
  };
});
