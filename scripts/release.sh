#!/usr/bin/env bash
#
# Build all five Dolffy DOS ROM variants and publish them as a GitHub release.
#
# Usage:
#   scripts/release.sh [tag] [--draft] [--notes "text"]
#
# If <tag> is omitted, it is auto-derived by bumping the patch component on the
# v1.0 maintenance line. The legacy v1.0 tag is treated as the base release, so
# the next automatic tag after v1.0 is v1.0.2.
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

# Bump the patch component on the v1.0 maintenance line.
next_tag() {
  local tags tag patch max_patch=1
  tags="$(gh release list --limit 50 --json tagName --jq '.[].tagName' 2>/dev/null || true)"
  if [ -z "$tags" ]; then
    tags="$(git tag --list 'v*' --sort=-v:refname)"
  fi

  while IFS= read -r tag; do
    case "$tag" in
      v1.0)
        ;;
      v1.0.*)
        patch="${tag#v1.0.}"
        if ! [[ "$patch" =~ ^[0-9]+$ ]]; then
          echo "error: cannot auto-bump tag '$tag'; pass an explicit tag" >&2
          return 1
        fi
        if [ "$patch" -gt "$max_patch" ]; then
          max_patch="$patch"
        fi
        ;;
    esac
  done <<< "$tags"

  echo "v1.0.$(( max_patch + 1 ))"
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
QUICKRUN="kernal/rom/dolffy-quickrun.rom"
HYPER="kernal/rom/dolffy-hyper.rom"
HYPER_QUICKRUN="kernal/rom/dolffy-hyper-quickrun.rom"
ROMS=("$PLAIN" "$QUICKRUN" "$HYPER" "$HYPER_QUICKRUN" "$ULTIMATE")

echo "==> Building ROMs (clean)"
make -C kernal clean
make -C kernal all

for f in "${ROMS[@]}"; do
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
- \`dolffy-quickrun.rom\` — Quickrun build (Plain plus C=+RUN/STOP: \`LOa\`, then \`SYS\`)
- \`dolffy-hyper.rom\` — Hyper build (Plain plus Ultimate SoftwareIEC DMA and the three-phase SHIFT/SHIFT LOCK cursor)
- \`dolffy-hyper-quickrun.rom\` — Hyper Quickrun build (Hyper plus C=+RUN/STOP Quickrun)
- \`dolffy-ultimate.rom\` — Ultimate build (adds a real-time clock and a SHIFT LOCK indicator)

All five are raw, headerless 8192-byte images. See the README for ROM selection,
Hyper/SoftwareIEC setup, installation, and the drive-side ROM requirements
(DolphinDOS 1541 ROM for the parallel path, a licensed JiffyDOS drive ROM for the
serial fast path)."
fi

if gh release view "$TAG" >/dev/null 2>&1; then
  echo "==> Release $TAG exists — updating assets (clobber)"
  gh release upload "$TAG" "${ROMS[@]}" --clobber
else
  echo "==> Creating release $TAG"
  gh release create "$TAG" "${ROMS[@]}" \
    --title "Dolffy DOS $TAG" \
    --notes "$NOTES" \
    $DRAFT
fi

echo "==> Done."
gh release view "$TAG" --web >/dev/null 2>&1 || true
