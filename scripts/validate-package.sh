#!/usr/bin/env bash
# scripts/validate-package.sh
#
# Validates a release ZIP produced by scripts/package-release.sh.
# Checks that the archive:
#   1. Is a valid zip file
#   2. Contains required documentation files
#   3. Does NOT contain secrets or credentials
#   4. Does NOT contain installed dependencies or build artifacts
#
# Usage:
#   bash scripts/validate-package.sh <path-to-archive.zip>
#
# Exit codes:
#   0 — all checks passed
#   1 — one or more checks failed

set -euo pipefail

ARCHIVE="${1:-}"

if [[ -z "$ARCHIVE" ]]; then
  echo "Usage: bash scripts/validate-package.sh <path-to-archive.zip>"
  exit 1
fi

if [[ ! -f "$ARCHIVE" ]]; then
  echo "Error: file not found: $ARCHIVE"
  exit 1
fi

PASS=0
FAIL=0

# Helper: mark a check as passed
ok() {
  echo "  ✅ $1"
  PASS=$((PASS + 1))
}

# Helper: mark a check as failed
fail() {
  echo "  ❌ $1"
  FAIL=$((FAIL + 1))
}

echo "==> Validating archive: $ARCHIVE"
echo ""

# ---------------------------------------------------------------------------
# 1. Valid zip
# ---------------------------------------------------------------------------
echo "--- Archive integrity"
if unzip -t "$ARCHIVE" > /dev/null 2>&1; then
  ok "Archive is a valid ZIP"
else
  fail "Archive failed integrity check (unzip -t)"
fi

# Write the archive listing to a temp file. We do this rather than storing it
# in a shell variable because grep -q exits as soon as it finds a match,
# closing the pipe; when the variable is large (~2 MB), the echo writing to
# the pipe receives SIGPIPE and exits non-zero, which causes set -o pipefail
# to treat a successful grep as a pipeline failure.
CONTENTS_FILE="$(mktemp)"
trap 'rm -f "$CONTENTS_FILE"' EXIT
unzip -l "$ARCHIVE" > "$CONTENTS_FILE" 2>/dev/null

# Detect the top-level directory prefix inside the archive (e.g. "gumroad/").
# Checking against this prefix lets the checks work regardless of what the
# enclosing directory is named.
TOP_DIR="$(awk 'NR==4{print $NF}' "$CONTENTS_FILE" | cut -d'/' -f1)"
echo "    Archive top-level directory: ${TOP_DIR:-<none>}"

# ---------------------------------------------------------------------------
# 2. Required files present
# ---------------------------------------------------------------------------
echo ""
echo "--- Required files"

REQUIRED_FILES=(
  "README.md"
  "LICENSE.md"
  "PRODUCT_BRIEF.md"
  "TRADEMARK_GUIDELINES.md"
  ".env.example"
  ".env.production.example"
  "gumroad-product/LISTING.md"
  "gumroad-product/ONBOARDING.md"
  "gumroad-product/SUPPORT_POLICY.md"
  "gumroad-product/LAUNCH_CHECKLIST.md"
  "gumroad-product/THUMBNAIL_BRIEF.md"
  "Gemfile"
  "package.json"
)

for f in "${REQUIRED_FILES[@]}"; do
  # Search for the file with the top-level prefix, or as a path component
  if grep -q "${TOP_DIR:+${TOP_DIR}/}${f}" "$CONTENTS_FILE" || \
     grep -q "/${f}$" "$CONTENTS_FILE" || \
     grep -q " ${f}$" "$CONTENTS_FILE"; then
    ok "Found: $f"
  else
    fail "Missing: $f"
  fi
done

# ---------------------------------------------------------------------------
# 3. Secrets and credentials NOT present
# ---------------------------------------------------------------------------
echo ""
echo "--- Secrets and credentials must be absent"

FORBIDDEN_FILES=(
  ".env$"
  "\.env\.development"
  "\.env\.local"
  "config/master\.key"
  "config/credentials/"
  "config/certs/"
  "nomad/certs/"
  "nomad/production/route53/"
  "nomad/staging/route53/"
)

for pattern in "${FORBIDDEN_FILES[@]}"; do
  if grep -qE "$pattern" "$CONTENTS_FILE"; then
    fail "FORBIDDEN file matched pattern: $pattern"
  else
    ok "Not present (good): $pattern"
  fi
done

# ---------------------------------------------------------------------------
# 4. Installed dependencies and build artifacts NOT present
# ---------------------------------------------------------------------------
echo ""
echo "--- Build artifacts and installed packages must be absent"

FORBIDDEN_DIRS=(
  "node_modules/"
  "vendor/bundle/"
  "public/packs/"
  "public/assets/"
  "public/vite/"
  "\.git/"
  # Use anchored patterns to avoid false positives like "gumroad_blog/log/..."
  # Matches the log or tmp directory at the top level of the archive
  "/log/"
  "/tmp/"
)

for dir in "${FORBIDDEN_DIRS[@]}"; do
  if grep -q "$dir" "$CONTENTS_FILE"; then
    fail "FORBIDDEN directory found in archive: $dir"
  else
    ok "Not present (good): $dir"
  fi
done

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo ""
echo "==> Results: $PASS passed, $FAIL failed"

if [[ $FAIL -gt 0 ]]; then
  echo ""
  echo "🚫 Validation FAILED — do not distribute this archive."
  exit 1
else
  echo ""
  echo "✅ All checks passed — archive is safe to distribute."
  exit 0
fi
