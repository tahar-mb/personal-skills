#!/usr/bin/env bash
# ============================================================
# install-linux.sh — Linux-optimized installer
#
# One-liner:
#   curl -fsSL https://raw.githubusercontent.com/tahar-mb/personal-skills/main/install-linux.sh | bash
#
# With target:
#   curl -fsSL https://raw.githubusercontent.com/tahar-mb/personal-skills/main/install-linux.sh | bash -s -- --cursor
# ============================================================
set -euo pipefail

# Linux ships bash 4+ — associative arrays and other modern features are safe.

REPO_URL="https://github.com/tahar-mb/personal-skills"
declare -A TARGET_DIRS=(
  [claude]="$HOME/.claude/skills"
  [hermes]="$HOME/.hermes/skills"
  [cursor]="$HOME/.cursor/skills"
)
TARGET_ORDER=(claude hermes cursor)
ACTIVE_TARGETS=()

for arg in "$@"; do
  case "$arg" in
    --claude|--hermes|--cursor) ACTIVE_TARGETS+=("${arg#--}") ;;
  esac
done

[ ${#ACTIVE_TARGETS[@]} -eq 0 ] && ACTIVE_TARGETS=("${TARGET_ORDER[@]}")

TMP_DIR="$(mktemp -d)"
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

for target in "${ACTIVE_TARGETS[@]}"; do
  dest="${TARGET_DIRS[$target]}"
  echo "Installing to $dest ..."
  installed=0
  for base in "$EXTRACTED_DIR/skills" "$EXTRACTED_DIR"; do
    [ -d "$base" ] || continue
    for dir in "$base"/*/; do
      [ -d "$dir" ] || continue
      name="$(basename "$dir")"
      [[ "$name" == .git || "$name" == .claude-plugin ]] && continue
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
