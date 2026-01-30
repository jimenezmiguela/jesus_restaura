# Local Development Setup

**Quick Summary:** Clone the repo, install Ruby and JS dependencies, build assets, set up the database, and run the Rails server locally.

One-time setup instructions for running the application locally in a development environment.

---

## Scope

These instructions apply to **local development only**.  
The production application is deployed using Dokku and follows a different configuration.

---

## Requirements

- Ruby (see `.ruby-version`)
- Bundler
- Node.js
- Yarn
- PostgreSQL

---

## Clone the Repository

```bash
git clone https://github.com/your-username/repo-name.git
cd repo-name
```

---

## Install Dependencies
**Ruby gems**
```bash
bundle install
```

**JavaScript packages**
```bash
yarn install
```

---

## Build Assets

CSS is compiled using Dart Sass via `cssbundling-rails`

```bash
yarn build:css
```

---

## Database Setup

The application uses PostgreSQL.

```bash
rails db:setup
```

If the database already exists:

```bash
rails db:migrate
```

---

## Run the Application

```bash
rails s
```

The application will be available at: http://localhost:3000


---

## Environment Variables

Environment-specific configuration should be provided via `.env` or local shell.

Refer to `.env.example` if present.

---

## Tests

Run the test suite with:

```bash
bundle exec rspec
```

---

## Notes

- Service workers and PWA install prompts may behave differently in development.
- Full PWA install behavior typically requires HTTPS.
- Production configuration and secrets are managed by Dokku.
