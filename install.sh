#!/usr/bin/env bash
# ============================================================
# install.sh — Remote installer for personal-skills
#
# One-liner:
#   curl -fsSL https://raw.githubusercontent.com/tahar-mb/personal-skills/main/install.sh | bash
#
# With target flags:
#   curl -fsSL https://raw.githubusercontent.com/tahar-mb/personal-skills/main/install.sh | bash -s -- --cursor
#
# Custom repo:
#   curl -fsSL https://raw.githubusercontent.com/tahar-mb/personal-skills/main/install.sh | bash -s -- https://github.com/user/repo
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

# Default: all targets
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

if [[ "$REPO_URL" =~ github\.com/([^/]+)/([^/]+) ]]; then
  OWNER="${BASH_REMATCH[1]}"
  REPO="${BASH_REMATCH[2]%.git}"
  ARCHIVE_URL="https://github.com/$OWNER/$REPO/archive/main.tar.gz"
else
  echo "Error: only GitHub URLs are supported" >&2
  exit 1
fi

curl -fsSL "$ARCHIVE_URL" | tar xz -C "$TMP_DIR"

EXTRACTED_DIR="$TMP_DIR/$REPO-main"
[ -d "$EXTRACTED_DIR" ] || { echo "Error: failed to extract archive" >&2; exit 1; }

install_skill_to() {
  local name="$1"
  local src="$2"
  local dst="$3"
  local label="$4"

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
      case "$name" in
        .git|.claude-plugin) continue ;;
      esac
      if [ -f "$dir/SKILL.md" ]; then
        install_skill_to "$name" "$dir" "$dest/$name" "$target"
        ((installed++))
      fi
    done
  done

  if [ $installed -eq 0 ]; then
    echo "  No skills found."
  else
    echo "  $installed skill(s) installed."
  fi
done

echo ""
echo "Done. Restart your editor to use the skills."
