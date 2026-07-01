#!/usr/bin/env bash
# ============================================================
# install.sh — Cross-platform remote installer
#
# Works on macOS (bash 3) and Linux (bash 4+).
#
# One-liner:
#   curl -fsSL https://raw.githubusercontent.com/tahar-mb/personal-skills/main/install.sh | bash
#
# With target:
#   curl -fsSL .../install.sh | bash -s -- --cursor
#
# Custom repo:
#   curl -fsSL .../install.sh | bash -s -- https://github.com/user/repo
# ============================================================
set -euo pipefail

# --- Parse args ---
POSITIONAL=()
TARGET_FLAGS=()
for arg in "$@"; do
  case "$arg" in
    --claude|--hermes|--cursor) TARGET_FLAGS+=("${arg#--}") ;;
    *) POSITIONAL+=("$arg") ;;
  esac
done

REPO_URL="${POSITIONAL[0]:-https://github.com/tahar-mb/personal-skills}"
[ ${#TARGET_FLAGS[@]} -eq 0 ] && TARGET_FLAGS=(claude hermes cursor)

target_dir() {
  case "$1" in
    claude) echo "$HOME/.claude/skills" ;;
    hermes) echo "$HOME/.hermes/skills" ;;
    cursor) echo "$HOME/.cursor/skills" ;;
  esac
}

# Derive archive URL from repo URL
if [[ "$REPO_URL" =~ github\.com/([^/]+)/([^/]+) ]]; then
  OWNER="${BASH_REMATCH[1]}"
  REPO="${BASH_REMATCH[2]%.git}"
  ARCHIVE_URL="https://github.com/$OWNER/$REPO/archive/main.tar.gz"
  EXTRACTED_NAME="$REPO-main"
else
  echo "Error: only GitHub URLs are supported" >&2
  exit 1
fi

TMP_DIR=$(mktemp -d)
cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

echo "Downloading skills from $REPO_URL ..."
curl -fsSL "$ARCHIVE_URL" | tar xz -C "$TMP_DIR"

EXTRACTED_DIR="$TMP_DIR/$EXTRACTED_NAME"
[ -d "$EXTRACTED_DIR" ] || { echo "Error: failed to extract archive" >&2; exit 1; }

install_skill_to() {
  local name="$1" src="$2" dst="$3" label="$4"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -f "$dst/.installed-from" ]; then
    echo "  [$label] Warning: $dst already exists, skipping" >&2
    return 0
  fi
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
