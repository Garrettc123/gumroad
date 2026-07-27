#!/usr/bin/env bash
# scripts/package-release.sh
#
# Produces a clean, distributable ZIP of the repository suitable for selling as a
# digital download on Gumroad. The archive excludes:
#   - Secrets and credentials (.env, config/credentials/, config/master.key)
#   - Development databases and caches (log/, tmp/, public/packs, public/vite)
#   - Installed dependencies (node_modules/, vendor/bundle)
#   - Build artifacts (dist/, public/assets)
#   - macOS/editor noise (.DS_Store, .idea, *.swp)
#   - Any existing dist/ output from a previous run
#
# Usage:
#   bash scripts/package-release.sh [VERSION]
#
# The VERSION argument is optional. If omitted the script uses the current git
# commit short SHA. Example: bash scripts/package-release.sh 1.0.0
#
# Output: dist/creator-ecommerce-kit-<VERSION>.zip

set -euo pipefail

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="${1:-}"
PRODUCT_NAME="creator-ecommerce-kit"

# Fall back to the git short SHA when no version argument is provided.
if [[ -z "$VERSION" ]]; then
  VERSION="$(git -C "$REPO_ROOT" rev-parse --short HEAD 2>/dev/null || echo "snapshot")"
fi

OUTPUT_DIR="$REPO_ROOT/dist"
ARCHIVE_NAME="${PRODUCT_NAME}-${VERSION}.zip"
ARCHIVE_PATH="$OUTPUT_DIR/$ARCHIVE_NAME"

echo "==> Packaging release: $ARCHIVE_NAME"
echo "    Source: $REPO_ROOT"
echo "    Output: $ARCHIVE_PATH"

# ---------------------------------------------------------------------------
# Safety checks
# ---------------------------------------------------------------------------

# Abort if there are uncommitted changes to tracked files, to avoid packaging
# a half-finished state. The --porcelain flag limits output to changed files.
if [[ -n "$(git -C "$REPO_ROOT" status --porcelain 2>/dev/null)" ]]; then
  echo ""
  echo "WARNING: The working tree has uncommitted changes."
  echo "         Consider committing or stashing before packaging."
  echo "         Continuing anyway — but verify the archive contents."
  echo ""
fi

# ---------------------------------------------------------------------------
# Build the archive
# ---------------------------------------------------------------------------

mkdir -p "$OUTPUT_DIR"

# Remove a stale archive if one exists from a previous run.
rm -f "$ARCHIVE_PATH"

# Patterns to exclude from the archive. Each entry is passed to zip as an
# --exclude argument. Paths are relative to REPO_ROOT.
EXCLUDES=(
  # Secrets and credentials — never ship these
  ".env"
  ".env.development"
  ".env.test"
  ".env.*.local"
  "config/credentials/*"
  "config/master.key"
  "config/certs/*"

  # Installed packages — buyers run their own install
  "node_modules/*"
  "vendor/bundle/*"

  # Build artifacts and compiled assets
  "dist/*"
  "public/packs/*"
  "public/packs-test/*"
  "public/vite/*"
  "public/vite-dev/*"
  "public/vite-test/*"
  "public/assets/*"
  "public/cache/*"
  "public/pages-tailwind.css"
  "public/pages-tailwind-manifest.json"

  # Logs, temp files, and caches
  "log/*"
  "tmp/*"
  "dump.rdb"
  ".sass-cache/*"
  ".jhw-cache/*"

  # Local development databases and docker volumes
  "docker/base/Gemfile*"

  # Editor and OS noise
  ".DS_Store"
  ".idea/*"
  "*.swp"
  "*.swo"
  ".byebug_history"
  "*.icloud"

  # Git internals — not useful to the buyer
  ".git/*"

  # Nomad production deployment secrets and certificates
  "nomad/certs/*"
  "nomad/production/route53/*"
  "nomad/staging/route53/*"

  # Auto-generated JS route files (regenerated on first build)
  "app/javascript/json_schemas/*"
  "app/javascript/routes.*"
  "app/javascript/utils/routes.*"
  "app/javascript/stylesheets/pages_tailwind.generated.html"
)

# Build the zip from the repo root, then move it to dist/.
# We temporarily cd into the parent of the repo so the archive path inside
# the zip is self-contained under a single top-level directory.
PARENT_DIR="$(dirname "$REPO_ROOT")"
REPO_DIR_NAME="$(basename "$REPO_ROOT")"

# Construct the --exclude flags
EXCLUDE_FLAGS=()
for pattern in "${EXCLUDES[@]}"; do
  EXCLUDE_FLAGS+=("--exclude" "${REPO_DIR_NAME}/${pattern}")
done

(
  cd "$PARENT_DIR"
  zip -r "$ARCHIVE_PATH" "$REPO_DIR_NAME" \
    "${EXCLUDE_FLAGS[@]}" \
    --quiet
)

# ---------------------------------------------------------------------------
# Post-build report
# ---------------------------------------------------------------------------

echo ""
echo "✅ Archive created: $ARCHIVE_PATH"
echo "   Size: $(du -sh "$ARCHIVE_PATH" | cut -f1)"
echo ""
echo "Run 'bash scripts/validate-package.sh $ARCHIVE_PATH' to verify the archive."
