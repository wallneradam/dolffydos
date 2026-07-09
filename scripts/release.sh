#!/usr/bin/env bash
#
# Build Dolffy DOS ROMs and publish them as a GitHub release.
#
# Usage:
#   scripts/release.sh [tag] [--draft] [--notes "text"]
#
# If <tag> is omitted, it is auto-derived by bumping the patch component of the
# highest existing vMAJOR.MINOR[.PATCH] release (a bare vMAJOR.MINOR counts as
# patch 0). It tracks the current minor/major, so a later v1.1 or v2.0 release
# bumps from there instead of regressing to the v1.0 line.
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

# Portable file size (bytes) and MD5: GNU/coreutils on Linux, BSD tools on macOS.
fsize() { wc -c < "$1" | tr -d '[:space:]'; }
fmd5()  { if command -v md5sum >/dev/null 2>&1; then md5sum "$1" | cut -d' ' -f1; else md5 -q "$1"; fi; }

# Refuse to release from a dirty or unpushed tree: a release must be reproducible
# from a commit that exists on the remote.
require_clean_pushed_tree() {
  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "error: working tree has uncommitted changes; commit or stash before releasing" >&2
    exit 1
  fi
  if [ -z "$(git branch -r --contains HEAD 2>/dev/null)" ]; then
    echo "error: HEAD is not on any remote branch; push before releasing" >&2
    exit 1
  fi
}

# Auto-derive the next tag by bumping the patch of the highest existing
# vMAJOR.MINOR[.PATCH] release (a bare vMAJOR.MINOR counts as patch 0).
next_tag() {
  local tags tag rest maj min pat best_maj=-1 best_min=-1 best_pat=-1
  tags="$(gh release list --limit 100 --json tagName --jq '.[].tagName' 2>/dev/null || true)"
  if [ -z "$tags" ]; then
    tags="$(git tag --list 'v*' --sort=-v:refname)"
  fi

  while IFS= read -r tag; do
    [ -n "$tag" ] || continue
    case "$tag" in v[0-9]*) ;; *) continue ;; esac
    rest="${tag#v}"
    maj="${rest%%.*}"; rest="${rest#*.}"
    min="${rest%%.*}"
    if [ "$rest" = "$min" ]; then pat=0; else pat="${rest#*.}"; fi
    # Ignore anything non-numeric or with extra dotted components (rc tags etc.).
    case "$maj.$min.$pat" in *[!0-9.]*) continue ;; esac
    if [ "$maj" -gt "$best_maj" ] ||
       { [ "$maj" -eq "$best_maj" ] && [ "$min" -gt "$best_min" ]; } ||
       { [ "$maj" -eq "$best_maj" ] && [ "$min" -eq "$best_min" ] && [ "$pat" -gt "$best_pat" ]; }; then
      best_maj="$maj"; best_min="$min"; best_pat="$pat"
    fi
  done <<< "$tags"

  if [ "$best_maj" -lt 0 ]; then
    echo "error: no vMAJOR.MINOR[.PATCH] tags found; pass an explicit tag" >&2
    return 1
  fi
  echo "v${best_maj}.${best_min}.$(( best_pat + 1 ))"
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

require_clean_pushed_tree

echo "==> Building ROMs (clean)"
make -C kernal clean
make -C kernal all

# Prove the toolchain still reproduces the faithful reference ROM before shipping.
make -C kernal verify

md5s=""
for f in "$PLAIN" "$ULTIMATE" "$QUICKRUN"; do
  if [ ! -f "$f" ]; then
    echo "error: expected build output missing: $f" >&2
    exit 1
  fi
  size=$(fsize "$f")
  if [ "$size" -ne 8192 ]; then
    echo "error: $f is $size bytes, expected 8192" >&2
    exit 1
  fi
  sum=$(fmd5 "$f")
  md5s="$md5s$sum "
  echo "    ok: $f ($size bytes, md5 $sum)"
done

# Guard against a build that silently produced identical images (stale artifacts,
# a broken variant define): the three builds must differ.
if [ "$(printf '%s\n' $md5s | sort -u | wc -l | tr -d '[:space:]')" -ne 3 ]; then
  echo "error: the three ROM builds are not all distinct; refusing to release" >&2
  exit 1
fi

if [ -z "$NOTES" ]; then
  NOTES="Dolffy DOS ${TAG}: prebuilt KERNAL ROM images.

- \`dolffy.rom\`: Plain build (conservative, runs anywhere a C64 KERNAL runs)
- \`dolffy-quickrun.rom\`: Quickrun build (Plain plus C=+RUN/STOP: \`LOa\`, then \`SYS\`)
- \`dolffy-ultimate.rom\`: Ultimate build (adds a real-time clock and a SHIFT LOCK indicator)

All three are raw, headerless 8192-byte images. See the README for installation and the
drive-side ROM requirements (DolphinDOS 1541 ROM for the parallel path, a licensed
JiffyDOS drive ROM for the serial fast path)."
fi

if gh release view "$TAG" >/dev/null 2>&1; then
  echo "==> Release $TAG exists, updating assets (clobber)"
  gh release upload "$TAG" "$PLAIN" "$QUICKRUN" "$ULTIMATE" --clobber
else
  echo "==> Creating release $TAG"
  gh release create "$TAG" "$PLAIN" "$QUICKRUN" "$ULTIMATE" \
    --title "Dolffy DOS $TAG" \
    --notes "$NOTES" \
    $DRAFT
fi

echo "==> Done."
gh release view "$TAG" --web >/dev/null 2>&1 || true
