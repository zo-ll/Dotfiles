#!/bin/bash
# stow.sh — GNU Stow replacement, zero deps
# Usage:
#   ./stow.sh <pkg>         # symlink package into $HOME
#   ./stow.sh -D <pkg>      # unlink package
#   ./stow.sh *              # link all packages
#
# A package is a directory under the repo root containing
# files relative to $HOME. Example:
#   tmux/.config/tmux/tmux.conf  →  ~/.config/tmux/tmux.conf

set -euo pipefail

REPO="${REPO:-$(cd "$(dirname "$0")/.." && pwd)}"
TARGET="${TARGET:-$HOME}"
MODE="link"

# ── Helpers ───────────────────────────────────────────────────────────────
info() { printf "\033[34m→\033[0m %s\n" "$1"; }
ok()   { printf "\033[32m✓\033[0m %s\n" "$1"; }

# ── Link a package ─────────────────────────────────────────────────────────
link_pkg() {
    local pkg="$1"
    local pkg_dir="$REPO/$pkg"

    if [ ! -d "$pkg_dir" ]; then
        echo "stow.sh: package '$pkg' not found in $REPO" >&2
        return 1
    fi

    # Find all files (not dirs) in the package, strip the package prefix
    find "$pkg_dir" -type f -o -type l | while read -r src; do
        # Get relative path inside the package (e.g., .config/tmux/tmux.conf)
        local rel="${src#$pkg_dir/}"
        local dst="$TARGET/$rel"
        local dst_dir="$(dirname "$dst")"

        mkdir -p "$dst_dir"

        if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
            : # already linked correctly, skip
        elif [ -e "$dst" ] || [ -L "$dst" ]; then
            info "exists (not a symlink to repo): $rel"
        else
            ln -sf "$src" "$dst"
            ok "linked $rel"
        fi
    done
}

# ── Unlink a package ───────────────────────────────────────────────────────
unlink_pkg() {
    local pkg="$1"
    local pkg_dir="$REPO/$pkg"

    if [ ! -d "$pkg_dir" ]; then
        echo "stow.sh: package '$pkg' not found in $REPO" >&2
        return 1
    fi

    find "$pkg_dir" -type f -o -type l | while read -r src; do
        local rel="${src#$pkg_dir/}"
        local dst="$TARGET/$rel"

        if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
            rm "$dst"
            ok "unlinked $rel"
        fi
    done

    # Clean up empty dirs left behind
    find "$TARGET" -type d -empty -delete 2>/dev/null || true
}

# ── Parse args ─────────────────────────────────────────────────────────────
if [ "${1:-}" = "-D" ]; then
    MODE="unlink"
    shift
fi

if [ $# -eq 0 ]; then
    echo "Usage: stow.sh [-D] <pkg> [pkg ...]" >&2
    echo "  -D    unlink packages instead of linking" >&2
    exit 1
fi

for pkg in "$@"; do
    case "$MODE" in
        link)   link_pkg "$pkg"   ;;
        unlink) unlink_pkg "$pkg" ;;
    esac
done
