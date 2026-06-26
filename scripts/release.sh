#!/usr/bin/env bash
#
# Build both Dolffy DOS ROMs and publish them as a GitHub release.
#
# Usage:
#   scripts/release.sh [tag] [--draft] [--notes "text"]
#
# If <tag> is omitted, it is auto-derived by bumping the last numeric component
# of the latest GitHub release tag (e.g. v1.0 -> v1.1, v1.9 -> v1.10). With no
# prior release it starts at v1.0.
#
# Examples:
#   scripts/release.sh            # auto-bump from the latest release
#   scripts/release.sh v2.0       # explicit tag
#   scripts/release.sh --draft    # auto-bump, as a draft
#
# Requires: acme (build), gh (authenticated GitHub CLI), make.
#
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# Bump the last dot-separated numeric component of the latest release tag.
next_tag() {
  local latest
  latest="$(gh release list --limit 1 --json tagName --jq '.[0].tagName' 2>/dev/null || true)"
  if [ -z "$latest" ]; then
    latest="$(git tag --list 'v*' --sort=-v:refname | head -n1)"
  fi
  if [ -z "$latest" ]; then
    echo "v1.0"
    return
  fi
  local ver="${latest#v}"
  local IFS=.
  local parts=()
  read -ra parts <<< "$ver"
  local last=$(( ${#parts[@]} - 1 ))
  if ! [[ "${parts[$last]}" =~ ^[0-9]+$ ]]; then
    echo "error: cannot auto-bump tag '$latest'; pass an explicit tag" >&2
    return 1
  fi
  parts[$last]=$(( parts[$last] + 1 ))
  echo "v${parts[*]}"
}

TAG=""
DRAFT=""
NOTES=""
while [ $# -gt 0 ]; do
  case "$1" in
    --draft) DRAFT="--draft"; shift ;;
    --notes) NOTES="${2:-}"; shift 2 ;;
    --*) echo "unknown argument: $1" >&2; exit 2 ;;
    *)
      if [ -n "$TAG" ]; then echo "unexpected extra argument: $1" >&2; exit 2; fi
      TAG="$1"; shift ;;
  esac
done

if [ -z "$TAG" ]; then
  TAG="$(next_tag)"
  echo "==> No tag given; auto-bumped to: $TAG"
fi

PLAIN="kernal/rom/dolffy.rom"
ULTIMATE="kernal/rom/dolffy-ultimate.rom"

echo "==> Building both ROMs (clean)"
make -C kernal clean
make -C kernal all

for f in "$PLAIN" "$ULTIMATE"; do
  if [ ! -f "$f" ]; then
    echo "error: expected build output missing: $f" >&2
    exit 1
  fi
  size=$(stat -f%z "$f")
  if [ "$size" -ne 8192 ]; then
    echo "error: $f is $size bytes, expected 8192" >&2
    exit 1
  fi
  echo "    ok: $f ($size bytes)"
done

if [ -z "$NOTES" ]; then
  NOTES="Dolffy DOS ${TAG} — prebuilt KERNAL ROM images.

- \`dolffy.rom\` — Plain build (conservative, runs anywhere a C64 KERNAL runs)
- \`dolffy-ultimate.rom\` — Ultimate build (adds a real-time clock and a SHIFT LOCK indicator)

Both are raw, headerless 8192-byte images. See the README for installation and the
drive-side ROM requirements (DolphinDOS 1541 ROM for the parallel path, a licensed
JiffyDOS drive ROM for the serial fast path)."
fi

if gh release view "$TAG" >/dev/null 2>&1; then
  echo "==> Release $TAG exists — updating assets (clobber)"
  gh release upload "$TAG" "$PLAIN" "$ULTIMATE" --clobber
else
  echo "==> Creating release $TAG"
  gh release create "$TAG" "$PLAIN" "$ULTIMATE" \
    --title "Dolffy DOS $TAG" \
    --notes "$NOTES" \
    $DRAFT
fi

echo "==> Done."
gh release view "$TAG" --web >/dev/null 2>&1 || true
