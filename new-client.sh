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

prompt_yn() {
  local label="$1"
  local default="${2:-y}"
  local value
  read -rp "  $label [Y/n]: " value
  value="${value:-$default}"
  [[ "${value,,}" != "n" ]]
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

# ── audit selection ────────────────────────────────────────────────────────────

echo ""
echo "Audits to include:"
prompt_yn "  SEO audit" "y" && INCLUDE_SEO=true || INCLUDE_SEO=false
prompt_yn "  WordPress audit" "y" && INCLUDE_WP=true || INCLUDE_WP=false
prompt_yn "  Accessibility audit" "y" && INCLUDE_A11Y=true || INCLUDE_A11Y=false

# ── WordPress local path ───────────────────────────────────────────────────────

LOCAL_SITE_PATH="N/A"
WP_AUDIT_MODE=""

if [[ "$INCLUDE_WP" == true ]]; then
  echo ""
  read -rp "  Local site path (press Enter to skip): " LOCAL_SITE_PATH_INPUT
  if [[ -n "$LOCAL_SITE_PATH_INPUT" ]]; then
    LOCAL_SITE_PATH="$LOCAL_SITE_PATH_INPUT"
    WP_AUDIT_MODE="filesystem"
  else
    echo ""
    echo "  No local path provided. Options:"
    echo "    1) Front-end only — infer from public URL (limited: no theme files, plugins, or DB)"
    echo "    2) Skip WordPress audit"
    echo ""
    read -rp "  Choose [1/2]: " wp_choice
    case "${wp_choice:-1}" in
      1) WP_AUDIT_MODE="frontend" ;;
      2) INCLUDE_WP=false ;;
      *) WP_AUDIT_MODE="frontend" ;;
    esac
  fi
fi

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
echo "  Local path:      ${LOCAL_SITE_PATH}"
echo ""
echo "  Audits:"
[[ "$INCLUDE_SEO"  == true ]] && echo "    ✓ SEO"
[[ "$INCLUDE_WP"   == true ]] && echo "    ✓ WordPress ($WP_AUDIT_MODE)"
[[ "$INCLUDE_A11Y" == true ]] && echo "    ✓ Accessibility"
echo ""
read -rp "Proceed? [Y/n]: " confirm
if [[ "${confirm,,}" == "n" ]]; then
  echo "Aborted."
  exit 0
fi

# ── create directory ───────────────────────────────────────────────────────────

mkdir -p "$CLIENT_DIR"
cp "$TEMPLATE_DIR/CLAUDE.md" "$CLIENT_DIR/CLAUDE.md"

[[ "$INCLUDE_SEO"  == true ]] && cp -r "$TEMPLATE_DIR/seo-audit"           "$CLIENT_DIR/seo-audit"
[[ "$INCLUDE_WP"   == true ]] && cp -r "$TEMPLATE_DIR/wordpress-audit"     "$CLIENT_DIR/wordpress-audit"
[[ "$INCLUDE_A11Y" == true ]] && cp -r "$TEMPLATE_DIR/accessibility-audit" "$CLIENT_DIR/accessibility-audit"

# ── fill placeholders in CLAUDE.md ─────────────────────────────────────────────

CLAUDE_FILE="$CLIENT_DIR/CLAUDE.md"

replace_in_file "$CLAUDE_FILE" "{{CLIENT_DISPLAY_NAME}}" "$CLIENT_NAME"
replace_in_file "$CLAUDE_FILE" "{{CLIENT_SLUG}}"         "$SLUG"
replace_in_file "$CLAUDE_FILE" "{{PUBLIC_URL}}"          "$PUBLIC_URL"
replace_in_file "$CLAUDE_FILE" "{{PREVIOUS_DOMAIN}}"     "$PREVIOUS_DOMAIN"
replace_in_file "$CLAUDE_FILE" "{{CMS}}"                 "$CMS"
replace_in_file "$CLAUDE_FILE" "{{HOSTING}}"             "$HOSTING"
replace_in_file "$CLAUDE_FILE" "{{LOCAL_SITE_PATH}}"     "$LOCAL_SITE_PATH"

# ── annotate WordPress HANDOFF for front-end mode ──────────────────────────────

if [[ "$INCLUDE_WP" == true && "$WP_AUDIT_MODE" == "frontend" ]]; then
  WP_HANDOFF="$CLIENT_DIR/wordpress-audit/HANDOFF.md"
  cat >> "$WP_HANDOFF" <<'FRONTENDNOTE'

---

## ⚠️ Front-End Only Mode

No local filesystem copy was available at setup time. This audit is limited to what can be inferred from the public URL.

**What you can still assess:**
- HTML source: template structure, heading hierarchy, meta tags, schema markup
- Public URLs and redirects
- Third-party scripts loaded on the page (GTM, analytics, ad platforms)
- Publicly visible content model (URL patterns, page types, taxonomy URLs)

**What you cannot assess without filesystem access:**
- Plugin inventory and versions
- Theme architecture (PHP templates, Timber/Twig, etc.)
- ACF field groups and the full content model
- Custom functions, hooks, and URL rewrites
- Hardcoded credentials or dev tools in source files
- Non-public CPTs (`action`, `resource`, etc.)

**Recommendation:** Flag any gaps clearly in the report. If a local copy becomes available later, re-run the filesystem pass and supplement the report.

FRONTENDNOTE
fi

# ── done ───────────────────────────────────────────────────────────────────────

echo ""
echo "Done. Client created at clients/$SLUG/"
echo ""
echo "Next steps:"
echo "  1. Open clients/$SLUG/ in Claude Code"
if [[ "$INCLUDE_SEO" == true ]]; then
echo "  2. Start with the SEO audit: review clients/$SLUG/seo-audit/HANDOFF.md"
fi
echo "  3. Add a Cloudflare Access application for the client's reports:"
echo "     - Hostname: audits.weareoutright.com/$SLUG"
echo "     - Policy:   Emails ending in @weareoutright.com OR @<client-domain>"
echo ""
