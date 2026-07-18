#!/usr/bin/env bash
# release.sh — publish one profile from this monorepo to its standalone
# delivery repo, so users get the one-command install:
#
#   hermes profile install github.com/<owner>/<delivery-repo> --alias
#
# Why a delivery repo: `hermes profile install <git-url>` clones the URL and
# requires distribution.yaml at the REPO ROOT (hermes_cli/profile_distribution.py
# _stage_source). It cannot address a subdirectory of a monorepo, so each
# profile is mirrored to its own repo where the profile IS the root.
#
# Usage:
#   scripts/release.sh <profile-name> <delivery-repo-url> [--dry-run]
#
# Example:
#   scripts/release.sh legal-person git@github.com:donvitocodes/legal-person-agent.git
#
# The version is read from the profile's distribution.yaml and pushed as tag
# v<version> on the delivery repo. Re-releasing the same version fails unless
# you bump distribution.yaml first.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROFILE_NAME="${1:-}"
DELIVERY_URL="${2:-}"
DRY_RUN="${3:-}"

if [[ -z "$PROFILE_NAME" || -z "$DELIVERY_URL" ]]; then
    echo "Usage: scripts/release.sh <profile-name> <delivery-repo-url> [--dry-run]" >&2
    exit 2
fi

PROFILE_DIR="$REPO_ROOT/profiles/$PROFILE_NAME"
[[ -f "$PROFILE_DIR/distribution.yaml" ]] || {
    echo "FAIL: $PROFILE_DIR has no distribution.yaml" >&2
    exit 1
}

VERSION="$(python3 -c "
import yaml, sys
mf = yaml.safe_load(open('$PROFILE_DIR/distribution.yaml'))
print(mf.get('version', '0.1.0'))
")"
TAG="v$VERSION"
SRC_SHA="$(git -C "$REPO_ROOT" rev-parse --short HEAD)"

echo "Releasing $PROFILE_NAME $TAG (monorepo @ $SRC_SHA) -> $DELIVERY_URL"

WORKDIR="$(mktemp -d -t hermes-release-XXXXXX)"
trap 'rm -rf "$WORKDIR"' EXIT

# Clone the delivery repo (or start fresh if it's empty/new).
if git clone --depth 1 "$DELIVERY_URL" "$WORKDIR/repo" 2>/dev/null; then
    # symbolic-ref (not rev-parse) so a freshly-created empty repo works too.
    DEFAULT_BRANCH="$(git -C "$WORKDIR/repo" symbolic-ref --short HEAD)"
else
    mkdir -p "$WORKDIR/repo"
    git -C "$WORKDIR/repo" init -b main
    git -C "$WORKDIR/repo" remote add origin "$DELIVERY_URL"
    DEFAULT_BRANCH="main"
fi

if git -C "$WORKDIR/repo" ls-remote --tags origin "refs/tags/$TAG" 2>/dev/null | grep -q .; then
    echo "FAIL: tag $TAG already exists on the delivery repo — bump 'version' in distribution.yaml" >&2
    exit 1
fi

# Replace repo contents with the profile directory, as-is. .gitignore ships
# too so installers who develop in place stay protected.
find "$WORKDIR/repo" -mindepth 1 -maxdepth 1 ! -name .git -exec rm -rf {} +
cp -R "$PROFILE_DIR/." "$WORKDIR/repo/"

git -C "$WORKDIR/repo" add -A
if git -C "$WORKDIR/repo" diff --cached --quiet; then
    echo "Nothing changed since the last release; tagging current tree as $TAG."
else
    git -C "$WORKDIR/repo" commit -m "$PROFILE_NAME $TAG (from hermes-profiles @ $SRC_SHA)"
fi
git -C "$WORKDIR/repo" tag "$TAG"

if [[ "$DRY_RUN" == "--dry-run" ]]; then
    echo "DRY RUN — would push branch $DEFAULT_BRANCH and tag $TAG to $DELIVERY_URL"
    git -C "$WORKDIR/repo" log --oneline -3
    exit 0
fi

git -C "$WORKDIR/repo" push -u origin "$DEFAULT_BRANCH" --tags
echo
echo "Released $PROFILE_NAME $TAG. Users install with:"
echo "  hermes profile install <github.com/owner/repo form of $DELIVERY_URL> --alias"
