# Open-Source Creator E-Commerce Platform — Developer Kit

> A complete, production-grade self-hosted creator commerce platform derived from the
> open-source [Gumroad](https://github.com/antiwork/gumroad) codebase.  
> *"Gumroad" is a trademark of Gumroad, Inc. This project is derived from the Gumroad open-source software.*

---

## What Is This?

This kit gives developers and technical entrepreneurs a fully functional, self-hosted
creator marketplace they can run on their own infrastructure.

The underlying codebase powers a platform where creators sell digital products —
ebooks, courses, software, templates, music, and more — directly to their audiences.
It includes a Stripe/PayPal checkout, file delivery, product management, analytics,
affiliate tracking, subscription billing, and a customizable storefront, all running on Ruby on Rails.

---

## Who Is This For?

| Audience | Use Case |
|---|---|
| **Indie SaaS developers** | Fork the codebase, white-label it, and launch your own creator marketplace niche. |
| **Agencies** | Deploy a private store for a client who wants full ownership of their digital-product business. |
| **Entrepreneurs** | Learn how a production-grade e-commerce Rails app is built before building your own. |
| **Students / learners** | Study a real-world full-stack application with Stripe, Sidekiq, Elasticsearch, and React. |

---

## What Is Included

- Full Ruby on Rails source code (MIT licensed)
- React + TypeScript frontend (Vite bundled)
- Docker Compose setup for local development (MySQL, Redis, Elasticsearch, MongoDB, MinIO)
- Stripe and PayPal integration scaffolding (test-mode configuration templates)
- Pre-configured test suite (`bin/rspec`, Minitest, Vitest)
- Production deployment documentation (`docs/deploying.md`)
- Step-by-step self-hosting guide (see `gumroad-product/ONBOARDING.md`)
- Environment variable templates (`.env.example`, `.env.production.example`)
- Post-purchase setup checklist

---

## Key Features of the Platform

- **Product types**: digital downloads, memberships, courses, bundles, physical goods, call bookings, coffee tips
- **Payments**: Stripe (cards, Apple Pay, Google Pay, BNPL, UPI, iDEAL, Bancontact) and PayPal
- **Subscriptions and installment plans**
- **Affiliate and referral tracking**
- **Per-product analytics and revenue dashboard**
- **Customizable creator storefronts and embeddable widgets**
- **Automated purchase receipts and stamped PDF delivery**
- **Multi-currency and VAT/tax support**
- **Elasticsearch-powered product discovery**
- **Sidekiq-based background jobs**

---

## Tech Stack Requirements

| Component | Version |
|---|---|
| Ruby | See `.ruby-version` |
| Node.js | See `.node-version` |
| MySQL | 8.0.x |
| Redis | 7.x |
| Elasticsearch | 8.x |
| MongoDB | 6.x |
| Docker | 24+ (for local dev) |

---

## Quick Start (5 Steps)

```bash
# 1. Install Ruby and Node.js (see README.md for version pinning)

# 2. Install system dependencies (macOS example)
brew install mysql@8.0 imagemagick libvips ffmpeg

# 3. Install application dependencies
gem install bundler && bundle install
npm install

# 4. Start Docker services (database, Redis, Elasticsearch, etc.)
make local

# 5. Set up the database and start the server
bin/rails db:prepare
bin/dev
```

Open http://localhost:3000. Log in with `seller@gumroad.com` / `password`.

Full setup instructions are in `README.md` and `gumroad-product/ONBOARDING.md`.

---

## Configuration

Copy the example environment file and fill in your credentials:

```bash
cp .env.example .env
```

The app boots without external credentials for local development — MinIO replaces S3,
and you can use Stripe's test-mode keys. See `.env.example` for all variables.

**Never commit a populated `.env` file.** The `.gitignore` excludes `.env` and
`.env.*.local` by default.

---

## Use Cases

### White-label creator marketplace
Fork the repo, remove the Gumroad branding per the [Trademark Guidelines](TRADEMARK_GUIDELINES.md),
add your own name and colors, and launch your own niche creator store.

### Private internal storefront
Run a company-internal software or asset distribution portal with authentication and access controls.

### Learning project
The codebase is an excellent real-world reference for Rails best practices:
service objects, Sidekiq workers, Stripe webhooks, Elasticsearch integration, and React on Rails.

---

## Limitations and Honest Caveats

- This is **source code**, not a managed SaaS. You are responsible for hosting, maintenance, and security patches.
- Running in production requires infrastructure: a MySQL server, Redis, Elasticsearch cluster, S3-compatible object storage, and a mail service — see `docs/production_environment.md`.
- Gumroad trademark guidelines prohibit offering a hosted/managed service under the "Gumroad" name without a license.
- No revenue guarantees. The platform's capabilities depend entirely on how you configure and operate it.
- Payment processing requires valid Stripe and/or PayPal accounts in supported countries.
- Tax, legal, and compliance obligations (GDPR, VAT, seller-of-record rules) are **your responsibility** as the operator.

---

## Responsible Use

This software may not be used to:

- Sell illegal, counterfeit, or harmful content
- Engage in spam, unsolicited outreach, or lead harvesting without consent
- Mislead buyers about the product they are purchasing
- Bypass Gumroad, Inc.'s own platform controls or terms of service
- Operate any service that misrepresents itself as the official Gumroad platform

Use this software ethically, legally, and in compliance with the applicable laws in your jurisdiction.

---

## License

MIT License — see [LICENSE.md](LICENSE.md) for the full text.  
"Gumroad" is a trademark of Gumroad, Inc. Use of the trademark is governed by [TRADEMARK_GUIDELINES.md](TRADEMARK_GUIDELINES.md).

---

## Support

See `gumroad-product/SUPPORT_POLICY.md` for support and refund terms.

For questions about the underlying open-source project, see the [upstream repository](https://github.com/antiwork/gumroad).

---

## Security

Please report security vulnerabilities via the process described in [SECURITY.md](SECURITY.md).
Do **not** open public GitHub issues for security bugs.
