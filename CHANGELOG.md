A Ruby on Rails application providing a Bible reader with web, API, and PWA support.

# Changelog

All notable changes to this project are documented in this file.
This project follows Semantic Versioning.

---

## v1.5.1 - 2026-01-23
### Fixed
- Standardized SCSS compilation using Dart Sass via `cssbundling-rails`
- Fixed asset compilation failures on fresh Linux clones and CI environments
- Prevented legacy asset compilation paths from attempting to process SCSS with an incompatible parser

---

## v1.5.0 - 2026-01-16
### Added
- Full installable Progressive Web App (PWA) support for iOS and Android
- Web app manifest with icons (192x192, 512x512) and metadata
- iOS PWA support (apple-touch-icon, standalone mode)
- Service worker registration
- Persisted light/dark theme across sessions
- Verified behavior via RSpec (Android install prompt pending Chrome heuristics)

---

## v1.4.0 - 2026-01-09
### Added
- Behavioral anchor test suite for core domain logic and UI state
- Improved regression safety for user-facing flows

---

## v1.3.0 - 2025-01-03
### Added
- Dark mode foundation with persistent theming across page loads
- Cross-browser support (Chrome, Firefox, Safari)

---

## v1.2.0 - 2025-12-22
### Added
- Centralized Dart Sass system with design tokens and reusable components
- Improved consistency and maintainability of stylesheets

---

## v1.1.1 - 2025-12-13
### Fixed
- Security hardening including bot prevention, input validation, and spam forensics
- Improved resilience against automated abuse

---

## v1.1.0 - 2025-09-08
### Added
- User CRUD functionality for saved verses and custom selections
- Integration with existing Devise authentication and PostgreSQL setup

---

## v1.0.1 - 2025-08-06
### Fixed
- Security hardening including Devise upgrades, credential handling, and forced SSL in production

---

## v1.0.0 - 2025-08-04
### Added
- Initial stable release
- Bible reader core functionality
- Devise authentication
- PostgreSQL database integration
- Web and API controllers for content access
