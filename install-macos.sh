#!/usr/bin/env bash
# ============================================================
# install-macos.sh — macOS-optimized installer
#
# One-liner:
#   curl -fsSL https://raw.githubusercontent.com/tahar-mb/personal-skills/main/install-macos.sh | bash
#
# With target:
#   curl -fsSL .../install-macos.sh | bash -s -- --cursor
# ============================================================
set -euo pipefail

# macOS defaults to bash 3 — no associative arrays, no ** globs
# This script is written for bash 3 compatibility.

REPO_URL="https://github.com/tahar-mb/personal-skills"
TARGET_FLAGS=()

for arg in "$@"; do
  case "$arg" in
    --claude|--hermes|--cursor) TARGET_FLAGS+=("${arg#--}") ;;
  esac
done

if [ ${#TARGET_FLAGS[@]} -eq 0 ]; then
  TARGET_FLAGS=("claude" "hermes" "cursor")
fi

target_dir() {
  case "$1" in
    claude) echo "$HOME/.claude/skills" ;;
    hermes) echo "$HOME/.hermes/skills" ;;
    cursor) echo "$HOME/.cursor/skills" ;;
  esac
}

TMP_DIR=$(mktemp -d)
cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

echo "Downloading skills from $REPO_URL ..."
curl -fsSL "https://github.com/tahar-mb/personal-skills/archive/main.tar.gz" | tar xz -C "$TMP_DIR"

EXTRACTED_DIR="$TMP_DIR/personal-skills-main"
[ -d "$EXTRACTED_DIR" ] || { echo "Error: failed to extract archive" >&2; exit 1; }

install_skill_to() {
  local name="$1" src="$2" dst="$3" label="$4"
  mkdir -p "$(dirname "$dst")"
  rm -rf "$dst"
  cp -R "$src" "$dst"
  echo "$REPO_URL" > "$dst/.installed-from"
  echo "  [$label] Installed $name"
}

for target in "${TARGET_FLAGS[@]}"; do
  dest="$(target_dir "$target")"
  echo "Installing to $dest ..."
  installed=0
  for base in "$EXTRACTED_DIR/skills" "$EXTRACTED_DIR"; do
    [ -d "$base" ] || continue
    for dir in "$base"/*/; do
      [ -d "$dir" ] || continue
      name="$(basename "$dir")"
      case "$name" in .git|.claude-plugin) continue ;; esac
      if [ -f "$dir/SKILL.md" ]; then
        install_skill_to "$name" "$dir" "$dest/$name" "$target"
        ((installed++))
      fi
    done
  done
  [ $installed -eq 0 ] && echo "  No skills found." || echo "  $installed skill(s) installed."
done

echo ""
echo "Done. Restart your editor to use the skills."
