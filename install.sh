#!/usr/bin/env bash
# ============================================================
# install.sh — Remote installer for personal-skills
#
# One-liner:
#   curl -fsSL https://raw.githubusercontent.com/<user>/<repo>/main/install.sh | bash
#
# Custom repo:
#   curl -fsSL ...install.sh | bash -s -- https://github.com/<user>/<repo>
# ============================================================
set -euo pipefail

REPO_URL="${1:-https://github.com/tahar-mb/personal-skills}"
SKILLS_DIR="$HOME/.claude/skills"
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

mkdir -p "$SKILLS_DIR"

# Look in skills/ first, then root
installed=0
for base in "$EXTRACTED_DIR/skills" "$EXTRACTED_DIR"; do
  [ -d "$base" ] || continue
  for dir in "$base"/*/; do
    [ -d "$dir" ] || continue
    name="$(basename "$dir")"
    case "$name" in
      bin|.git|.claude-plugin) continue ;;
    esac
    if [ -f "$dir/SKILL.md" ]; then
      dst="$SKILLS_DIR/$name"
      rm -rf "$dst"
      cp -R "$dir" "$dst"
      echo "$REPO_URL" > "$dst/.installed-from"
      echo "  Installed $name"
      ((installed++))
    fi
  done
done

if [ $installed -eq 0 ]; then
  echo "No skills found."
else
  echo ""
  echo "Done. $installed skill(s) installed to $SKILLS_DIR"
  echo "Restart Claude Code or start a new session to use them."
fi
