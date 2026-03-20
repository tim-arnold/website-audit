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

# ── CMS selection ──────────────────────────────────────────────────────────────

echo ""
echo "  CMS / platform:"
echo "    1) WordPress"
echo "    2) Headless WordPress (WP backend + decoupled frontend)"
echo "    3) Next.js / React"
echo "    4) Nuxt / Vue"
echo "    5) Astro"
echo "    6) HTML / Static"
echo "    7) Webflow"
echo "    8) Squarespace"
echo "    9) Other"
echo ""
read -rp "  Choose [1-9]: " cms_choice

case "${cms_choice:-1}" in
  1) CMS="WordPress";                    IS_WORDPRESS=true;  IS_HEADLESS=false ;;
  2) CMS="Headless WordPress";           IS_WORDPRESS=true;  IS_HEADLESS=true  ;;
  3) CMS="Next.js";                      IS_WORDPRESS=false; IS_HEADLESS=false ;;
  4) CMS="Nuxt";                         IS_WORDPRESS=false; IS_HEADLESS=false ;;
  5) CMS="Astro";                        IS_WORDPRESS=false; IS_HEADLESS=false ;;
  6) CMS="HTML/Static";                  IS_WORDPRESS=false; IS_HEADLESS=false ;;
  7) CMS="Webflow";                      IS_WORDPRESS=false; IS_HEADLESS=false ;;
  8) CMS="Squarespace";                  IS_WORDPRESS=false; IS_HEADLESS=false ;;
  9) CMS=$(prompt "Platform name");      IS_WORDPRESS=false; IS_HEADLESS=false ;;
  *) CMS="WordPress";                    IS_WORDPRESS=true;  IS_HEADLESS=false ;;
esac

# Headless: ask for the frontend framework separately
FRONTEND_FRAMEWORK=""
if [[ "$IS_HEADLESS" == true ]]; then
  echo ""
  echo "  Frontend framework:"
  echo "    1) Next.js"
  echo "    2) Nuxt"
  echo "    3) Astro"
  echo "    4) SvelteKit"
  echo "    5) Other"
  echo ""
  read -rp "  Choose [1-5]: " fe_choice
  case "${fe_choice:-1}" in
    1) FRONTEND_FRAMEWORK="Next.js"    ;;
    2) FRONTEND_FRAMEWORK="Nuxt"       ;;
    3) FRONTEND_FRAMEWORK="Astro"      ;;
    4) FRONTEND_FRAMEWORK="SvelteKit"  ;;
    5) FRONTEND_FRAMEWORK=$(prompt "Framework name") ;;
    *) FRONTEND_FRAMEWORK="Next.js"    ;;
  esac
  CMS="Headless WordPress ($FRONTEND_FRAMEWORK frontend)"
fi

HOSTING=$(prompt "Hosting" "$(
  case "${cms_choice:-1}" in
    7) echo "Webflow" ;;
    8) echo "Squarespace" ;;
    *) echo "Vercel" ;;
  esac
)")

# ── local path ─────────────────────────────────────────────────────────────────

echo ""
LOCAL_SITE_PATH="N/A"
if [[ "$IS_WORDPRESS" == true ]]; then
  read -rp "  Local WordPress path (press Enter to skip): " LOCAL_SITE_PATH_INPUT
else
  read -rp "  Local repo path (press Enter to skip): " LOCAL_SITE_PATH_INPUT
fi
[[ -n "$LOCAL_SITE_PATH_INPUT" ]] && LOCAL_SITE_PATH="$LOCAL_SITE_PATH_INPUT"

# ── audit selection ────────────────────────────────────────────────────────────

echo ""
echo "Audits to include:"
prompt_yn "  SEO audit" "y"           && INCLUDE_SEO=true  || INCLUDE_SEO=false
prompt_yn "  Accessibility audit" "y" && INCLUDE_A11Y=true || INCLUDE_A11Y=false

# WordPress audit only offered for WP-based sites
INCLUDE_WP=false
WP_AUDIT_MODE=""
if [[ "$IS_WORDPRESS" == true ]]; then
  prompt_yn "  WordPress audit" "y" && INCLUDE_WP=true || INCLUDE_WP=false
fi

if [[ "$INCLUDE_WP" == true ]]; then
  if [[ "$LOCAL_SITE_PATH" != "N/A" ]]; then
    WP_AUDIT_MODE="filesystem"
  else
    echo ""
    echo "  No local WordPress path provided. Options:"
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
echo "  Local path:      $LOCAL_SITE_PATH"
echo ""
echo "  Audits:"
[[ "$INCLUDE_SEO"  == true ]] && echo "    ✓ SEO"
[[ "$INCLUDE_WP"   == true ]] && echo "    ✓ WordPress ($WP_AUDIT_MODE$([ "$IS_HEADLESS" == true ] && echo ", headless"))"
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

# ── annotate WordPress HANDOFF ─────────────────────────────────────────────────

if [[ "$INCLUDE_WP" == true ]]; then
  WP_HANDOFF="$CLIENT_DIR/wordpress-audit/HANDOFF.md"

  if [[ "$IS_HEADLESS" == true ]]; then
    cat >> "$WP_HANDOFF" <<HEADLESSNOTE

---

## ℹ️ Headless WordPress

This site uses WordPress as a headless CMS with a **${FRONTEND_FRAMEWORK}** frontend. The WordPress audit focuses on the backend only — theme rendering is not relevant, but the content model, plugin dependencies, and API structure are.

**What to focus on:**
- Custom post types and their REST API exposure (are they in \`show_in_rest: true\`?)
- ACF field groups and which fields are exposed via the REST API or WPGraphQL
- Plugin dependencies that affect the API (WPGraphQL, JWT Auth, ACF to REST API, etc.)
- Any hardcoded API keys or credentials in \`functions.php\` / \`inc/\`
- Authentication scheme for private content

**What to skip:**
- Template hierarchy (PHP/Twig templates handle nothing — the frontend framework does)
- Enqueued styles/scripts (frontend handles its own assets)

HEADLESSNOTE
  fi

  if [[ "$WP_AUDIT_MODE" == "frontend" ]]; then
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
fi

# ── done ───────────────────────────────────────────────────────────────────────

echo ""
echo "Done. Client created at clients/$SLUG/"
echo ""
echo "Next steps:"
echo "  1. Open clients/$SLUG/ in Claude Code"
[[ "$INCLUDE_SEO"  == true ]] && echo "  2. Start with the SEO audit: review clients/$SLUG/seo-audit/HANDOFF.md"
echo "  3. Add a Cloudflare Access application for the client's reports:"
echo "     - Hostname: audits.weareoutright.com/$SLUG"
echo "     - Policy:   Emails ending in @weareoutright.com OR @<client-domain>"
echo ""
