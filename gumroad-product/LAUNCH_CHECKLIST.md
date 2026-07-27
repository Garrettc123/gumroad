# Pre-Launch Checklist

Work through every item before clicking "Publish" on Gumroad.
Check off each item as you complete it.

---

## 1. Product Content

- [ ] `LISTING.md` — title, short description, long description, and FAQ reviewed and
      finalized (no placeholder text remaining)
- [ ] Replace every `[YOUR_EMAIL]` in `SUPPORT_POLICY.md` with your real support address
- [ ] `ONBOARDING.md` — tested end-to-end: downloaded the package, followed every step,
      confirmed a local environment runs
- [ ] `PRODUCT_BRIEF.md` — reviewed for accuracy; no claims about live revenue,
      compliance, or customer results
- [ ] `THUMBNAIL_BRIEF.md` — cover image created and meets Gumroad's requirements
      (1280 × 720 px minimum, < 72 MB)

---

## 2. Packaging

- [ ] Run `scripts/package-release.sh` and verify the output ZIP is clean:
      no `.env`, no `config/credentials/`, no `config/master.key`, no `node_modules`,
      no `log/`, no `tmp/`, no `dist/`
- [ ] Run `scripts/validate-package.sh` — all checks pass
- [ ] Open the ZIP on a fresh machine (or a clean temp directory) and confirm
      `ONBOARDING.md` instructions work from scratch
- [ ] Confirm the ZIP does not contain any real API keys, database passwords,
      or personal data

---

## 3. Gumroad Seller Dashboard

- [ ] Account verified (ID or bank account connected as required by Gumroad)
- [ ] Payout method configured and tested
- [ ] Support/contact email set in profile settings
- [ ] Product uploaded: ZIP file and cover image attached
- [ ] Pricing tiers set (Starter $29 / Pro $79 / Team $149 — or your chosen amounts)
- [ ] Product visibility set to "Unlisted" for initial testing, then "Published" when ready
- [ ] Gumroad's content policy reviewed — confirm the product complies

---

## 4. Legal and Tax

- [ ] Consult a tax professional about your obligations as a digital-goods seller
      (VAT, GST, sales tax vary by country and customer location)
- [ ] Gumroad's terms of service reviewed and accepted
- [ ] License (`LICENSE.md` — MIT) and trademark guidelines (`TRADEMARK_GUIDELINES.md`)
      included in the deliverable and linked from the product listing
- [ ] Privacy policy or data handling statement in place if you collect buyer emails for
      support purposes
- [ ] Refund policy text finalized in `SUPPORT_POLICY.md` and summarized in the
      Gumroad product description

---

## 5. Test Purchase

- [ ] Make a test purchase using Gumroad's built-in test-purchase feature
- [ ] Confirm the ZIP download works and is the correct file
- [ ] Confirm Gumroad delivers the product file to the buyer email address correctly
- [ ] Confirm the post-purchase email (Gumroad's default or a custom one) is readable
      and contains the correct information

---

## 6. Post-Sale Delivery Notes

- [ ] If any tier includes personal support (Pro or Team), set up a dedicated support
      email address or alias and check it regularly
- [ ] Decide on a cadence for releasing updates (e.g., quarterly) when the upstream
      open-source project ships notable improvements
- [ ] Document how buyers who have already purchased can get updates (e.g., re-download
      from Gumroad, or a GitHub release notification)

---

## 7. Launch

- [ ] Share the product link with at least one trusted person for final feedback
- [ ] Set the product to "Published" in Gumroad
- [ ] Announce — choose channels appropriate to your audience (Twitter/X, LinkedIn,
      relevant communities, your own newsletter)
- [ ] Monitor the first few purchases for any delivery or support issues
