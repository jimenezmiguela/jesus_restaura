# Pin npm packages
pin "application", preload: true
pin "@rails/ujs", to: "rails-ujs.js", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# Bootstrap is loaded via CDN, no need to pin for JS
