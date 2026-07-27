# Post-Purchase Onboarding Guide

Welcome — and thank you for your purchase!

This guide walks you through setting up the creator e-commerce platform from source code
to a running local environment, and then to production. Work through the steps in order;
each section links to deeper documentation already included in the repository.

---

## Step 0 — What You Have

After downloading and extracting the archive you should see a directory with:

```
README.md                 ← Full developer setup guide
PRODUCT_BRIEF.md          ← Product overview and honest caveats
TRADEMARK_GUIDELINES.md   ← How to use (and not use) the Gumroad trademark
LICENSE.md                ← MIT license text
.env.example              ← Environment variable template for development
.env.production.example   ← Environment variable template for production
gumroad-product/          ← This folder: listing, onboarding, support policy, checklist
scripts/                  ← Packaging and validation utilities
app/                      ← Rails application code
…
```

---

## Step 1 — Install Prerequisites

Install the exact Ruby and Node.js versions pinned in `.ruby-version` and `.node-version`.

```bash
# Read the pinned versions
cat .ruby-version
cat .node-version
```

Use a version manager (`rbenv`, `rvm`, `asdf`, or `nvm`) to match these exactly.

Then install system dependencies. On macOS:

```bash
brew install mysql@8.0 imagemagick libvips ffmpeg docker
```

On Debian/Ubuntu:

```bash
sudo apt-get install libmysqlclient-dev imagemagick libvips-dev ffmpeg
```

See `README.md` for platform-specific notes on PDFtk and wkhtmltopdf.

---

## Step 2 — Install Application Dependencies

```bash
gem install bundler
bundle install

corepack enable
npm install
```

---

## Step 3 — Configure Environment Variables

```bash
cp .env.example .env
```

Open `.env` in your editor. For local development most values can stay blank — Docker
handles the databases and MinIO replaces S3. The only values you need for a working local
checkout flow are:

```
STRIPE_PUBLIC_KEY_TEST=pk_test_...   ← your Stripe test public key
STRIPE_API_KEY=sk_test_...           ← your Stripe test secret key
```

Create a free Stripe account at https://stripe.com and get test keys from the dashboard.
**Never put live `sk_live_` keys in `.env` for local development.**

---

## Step 4 — Start Docker Services

```bash
make local
```

This starts MySQL, Redis, Elasticsearch, MongoDB, and MinIO. Keep this terminal open.

---

## Step 5 — Set Up the Database

In a new terminal:

```bash
bin/rails db:prepare
```

This creates and migrates both the development and test databases.

---

## Step 6 — Start the Application

```bash
bin/dev
```

Open http://localhost:3000 in your browser.

Log in with the seed account:

| Field | Value |
|---|---|
| Email | `seller@gumroad.com` |
| Password | `password` |
| 2FA code | `000000` |

---

## Step 7 — Run the Test Suite (Optional but Recommended)

```bash
RAILS_ENV=test bin/rails db:setup
RAILS_ENV=test bin/rails js:export
bin/rspec
```

A passing test suite confirms the installation is healthy.

---

## Step 8 — Production Deployment

When you are ready to deploy beyond localhost, read:

- `docs/deploying.md` — deployment workflow and Nomad configuration
- `docs/production_environment.md` — required infrastructure components
- `.env.production.example` — all environment variables needed for production

Key infrastructure you will need:

| Service | Purpose |
|---|---|
| MySQL 8.0 | Primary database |
| Redis 7 | Cache, session storage, Sidekiq queue |
| Elasticsearch 8 | Product search |
| MongoDB 6 | Event/log storage |
| S3-compatible storage | File uploads and delivery |
| Stripe account | Payment processing |
| Transactional email | Purchase receipts (Resend or similar) |

---

## Step 9 — White-Labeling (Optional)

To remove Gumroad branding and launch under your own name:

1. Replace logo files in `public/` and `vendor/assets/`.
2. Update `config/application.rb` → `config.application_name`.
3. Update footer and email templates in `app/views/`.
4. Follow `TRADEMARK_GUIDELINES.md` — you may not use the "Gumroad" name or logo in
   your product or hosted service name.

---

## Getting Help

- Open an issue on the GitHub repository for code bugs.
- For setup questions covered by the Pro or Team tier, see `SUPPORT_POLICY.md`.
- Community discussion: [GitHub Discussions](https://github.com/antiwork/gumroad/discussions)

---

## Responsible Use Reminder

Do not use this platform to sell illegal content, spam buyers, or misrepresent what you
are selling. You are the operator and are legally responsible for the store you run.
