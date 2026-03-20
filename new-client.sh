#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/_template"
CLIENTS_DIR="$SCRIPT_DIR/clients"

# ── helpers ────────────────────────────────────────────────────────────────────

prompt() {
  local label="$1"
  local default="${2:-}"
  local value

  if [[ -n "$default" ]]; then
    read -rp "  $label [$default]: " value
    echo "${value:-$default}"
  else
    read -rp "  $label: " value
    echo "$value"
  fi
}

prompt_optional() {
  local label="$1"
  local value
  read -rp "  $label (press Enter to skip): " value
  echo "${value:-N/A}"
}

to_slug() {
  echo "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | tr ' ' '-' \
    | tr -cd '[:alnum:]-' \
    | sed 's/--*/-/g' \
    | sed 's/^-//;s/-$//'
}

replace_in_file() {
  local file="$1"
  local placeholder="$2"
  local value="$3"
  # macOS-compatible sed in-place (empty string for backup suffix)
  sed -i '' "s|${placeholder}|${value}|g" "$file"
}

# ── gather input ───────────────────────────────────────────────────────────────

echo ""
echo "New client setup"
echo "────────────────"

CLIENT_NAME=$(prompt "Client name")
if [[ -z "$CLIENT_NAME" ]]; then
  echo "Error: client name is required." >&2
  exit 1
fi

SLUG=$(to_slug "$CLIENT_NAME")
CLIENT_DIR="$CLIENTS_DIR/$SLUG"

if [[ -d "$CLIENT_DIR" ]]; then
  echo ""
  echo "Error: $CLIENT_DIR already exists. Choose a different name or delete it first." >&2
  exit 1
fi

echo ""
PUBLIC_URL=$(prompt "Public URL" "https://")
PREVIOUS_DOMAIN=$(prompt_optional "Previous/old domain")
CMS=$(prompt "CMS" "WordPress")
HOSTING=$(prompt "Hosting" "WPEngine")
LOCAL_SITE_PATH=$(prompt_optional "Local site path (e.g. /Users/you/Local Sites/site/app/public)")

# ── confirm ────────────────────────────────────────────────────────────────────

echo ""
echo "Creating client:"
echo "  Name:            $CLIENT_NAME"
echo "  Slug:            $SLUG"
echo "  Directory:       clients/$SLUG/"
echo "  Public URL:      $PUBLIC_URL"
echo "  Previous domain: $PREVIOUS_DOMAIN"
echo "  CMS:             $CMS"
echo "  Hosting:         $HOSTING"
echo "  Local path:      $LOCAL_SITE_PATH"
echo ""
read -rp "Proceed? [Y/n]: " confirm
if [[ "${confirm,,}" == "n" ]]; then
  echo "Aborted."
  exit 0
fi

# ── create directory ───────────────────────────────────────────────────────────

cp -r "$TEMPLATE_DIR" "$CLIENT_DIR"

# ── fill placeholders in CLAUDE.md ─────────────────────────────────────────────

CLAUDE_FILE="$CLIENT_DIR/CLAUDE.md"

replace_in_file "$CLAUDE_FILE" "{{CLIENT_DISPLAY_NAME}}" "$CLIENT_NAME"
replace_in_file "$CLAUDE_FILE" "{{CLIENT_SLUG}}"         "$SLUG"
replace_in_file "$CLAUDE_FILE" "{{PUBLIC_URL}}"          "$PUBLIC_URL"
replace_in_file "$CLAUDE_FILE" "{{PREVIOUS_DOMAIN}}"     "$PREVIOUS_DOMAIN"
replace_in_file "$CLAUDE_FILE" "{{CMS}}"                 "$CMS"
replace_in_file "$CLAUDE_FILE" "{{HOSTING}}"             "$HOSTING"
replace_in_file "$CLAUDE_FILE" "{{LOCAL_SITE_PATH}}"     "$LOCAL_SITE_PATH"

# ── done ───────────────────────────────────────────────────────────────────────

echo ""
echo "Done. Client created at clients/$SLUG/"
echo ""
echo "Next steps:"
echo "  1. Open clients/$SLUG/ in Claude Code"
echo "  2. Start with the SEO audit: review clients/$SLUG/seo-audit/HANDOFF.md"
echo ""
