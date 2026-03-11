# Bible Reader (Web, API, PWA)

This repository represents a production Ruby on Rails application, structured and deployed in the same way I build and maintain client projects.

A Ruby on Rails application providing a Bible reader with full web, API, and installable Progressive Web App (PWA) support.

Live application: https://jesusrestaura.com/

---

## Overview

This application delivers a fast, accessible Bible reading experience across desktop and mobile, with offline-capable PWA support and an API for programmatic access.

It is actively maintained and deployed in production using Dokku.

---

## Key Features

- Web-based Bible reader with responsive UI
- Installable Progressive Web App (iOS & Android)
- Offline support via service workers
- User authentication and saved verse selections (Devise)
- JSON API for content access
- Persistent light/dark theme
- PostgreSQL-backed persistence

---

## Tech Stack

- **Ruby on Rails**
- **PostgreSQL**
- **Devise** (authentication)
- **Dart Sass** via `cssbundling-rails`
- **RSpec** (behavioral and regression coverage)
- **PWA** (Web App Manifest, Service Workers)
- **Dokku** (production deployment)

---

## Architecture & Decisions

- Uses Rails’ standard MVC with shared domain logic across web and API controllers
- Asset pipeline standardized on Dart Sass to ensure consistent compilation across CI and Linux environments
- PWA support implemented incrementally with verified install behavior on mobile browsers
- Security hardened for production use (forced SSL, bot mitigation, input validation)

---

## Deployment

The application is deployed on **Dokku** with environment-based configuration.

Key considerations:

- Environment variables for credentials and secrets
- Precompiled assets in production
- Database-backed sessions and persistence

---

## Testing

- RSpec test suite covering core domain behavior and UI state
- Regression-focused tests for user-facing flows

---

## Status

Actively maintained. See `CHANGELOG.md` for detailed version history and recent improvements.

---

## Local Development

For developers who want to run the application locally, complete setup instructions are available in [`docs/SETUP.md`](docs/SETUP.md).  
This includes cloning the repository, installing dependencies, building assets, setting up the database, running the server, and executing tests.
