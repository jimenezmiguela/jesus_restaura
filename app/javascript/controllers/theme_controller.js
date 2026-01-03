import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["toggle", "icon"];

  connect() {
    // sync checkbox with persisted theme
    this.toggleTarget.checked =
      document.documentElement.dataset.theme === "dark";
    this.updateIcon();
  }

  toggle() {
    if (this.toggleTarget.checked) {
      document.documentElement.dataset.theme = "dark";
      localStorage.setItem("theme", "dark");
    } else {
      document.documentElement.dataset.theme = "light";
      localStorage.setItem("theme", "light");
    }
    this.updateIcon();
  }

  updateIcon() {
    if (!this.iconTarget) return;
    this.iconTarget.textContent =
      document.documentElement.dataset.theme === "dark" ? "🌙" : "☀️";
  }
}
