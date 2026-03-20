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

# ── client basics ───────────────────────────────────────────────────────────────

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

# ── audit purpose ────────────────────────────────────────────────────────────────

echo ""
echo "Audit purpose:"
echo "  1) Pre-redesign  — establish baseline before a rebuild or migration"
echo "  2) Remediation   — identify and fix issues on the existing site (no rebuild)"
echo ""
read -rp "  Choose [1-2]: " purpose_choice
case "${purpose_choice:-1}" in
  1) AUDIT_PURPOSE="preredesign"; AUDIT_PURPOSE_LABEL="Pre-Redesign"
     AUDIT_GOAL="Pre-redesign audit for **{{PUBLIC_URL}}**. The goal is to document everything that must be preserved, redirected, or fixed during the rebuild." ;;
  2) AUDIT_PURPOSE="remediation"; AUDIT_PURPOSE_LABEL="Remediation"
     AUDIT_GOAL="Remediation audit for **{{PUBLIC_URL}}**. The goal is to identify and prioritize issues to fix on the existing site — no rebuild is planned." ;;
  *) AUDIT_PURPOSE="preredesign"; AUDIT_PURPOSE_LABEL="Pre-Redesign"
     AUDIT_GOAL="Pre-redesign audit for **{{PUBLIC_URL}}**. The goal is to document everything that must be preserved, redirected, or fixed during the rebuild." ;;
esac

# ── audit selection ─────────────────────────────────────────────────────────────

echo ""
echo "Audits to include:"
prompt_yn "  SEO audit" "y"           && INCLUDE_SEO=true  || INCLUDE_SEO=false
prompt_yn "  Technology audit" "y"    && INCLUDE_TECH=true || INCLUDE_TECH=false
prompt_yn "  Accessibility audit" "y" && INCLUDE_A11Y=true || INCLUDE_A11Y=false

# ── technology audit details (only if selected) ─────────────────────────────────

CMS="Unknown"
HOSTING="Unknown"
LOCAL_SITE_PATH="N/A"
IS_WORDPRESS=false
IS_HEADLESS=false
FRONTEND_FRAMEWORK=""
TECH_AUDIT_MODE=""

if [[ "$INCLUDE_TECH" == true ]]; then

  # CMS / platform
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
    1) CMS="WordPress";          IS_WORDPRESS=true;  IS_HEADLESS=false ;;
    2) CMS="Headless WordPress"; IS_WORDPRESS=true;  IS_HEADLESS=true  ;;
    3) CMS="Next.js";            IS_WORDPRESS=false; IS_HEADLESS=false ;;
    4) CMS="Nuxt";               IS_WORDPRESS=false; IS_HEADLESS=false ;;
    5) CMS="Astro";              IS_WORDPRESS=false; IS_HEADLESS=false ;;
    6) CMS="HTML/Static";        IS_WORDPRESS=false; IS_HEADLESS=false ;;
    7) CMS="Webflow";            IS_WORDPRESS=false; IS_HEADLESS=false ;;
    8) CMS="Squarespace";        IS_WORDPRESS=false; IS_HEADLESS=false ;;
    9) CMS=$(prompt "Platform name"); IS_WORDPRESS=false; IS_HEADLESS=false ;;
    *) CMS="WordPress";          IS_WORDPRESS=true;  IS_HEADLESS=false ;;
  esac

  # Headless: frontend framework
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
      1) FRONTEND_FRAMEWORK="Next.js"   ;;
      2) FRONTEND_FRAMEWORK="Nuxt"      ;;
      3) FRONTEND_FRAMEWORK="Astro"     ;;
      4) FRONTEND_FRAMEWORK="SvelteKit" ;;
      5) FRONTEND_FRAMEWORK=$(prompt "Framework name") ;;
      *) FRONTEND_FRAMEWORK="Next.js"   ;;
    esac
    CMS="Headless WordPress ($FRONTEND_FRAMEWORK frontend)"
  fi

  # Hosting
  HOSTING=$(prompt "Hosting" "$(
    case "${cms_choice:-1}" in
      7) echo "Webflow" ;;
      8) echo "Squarespace" ;;
      *) echo "Vercel" ;;
    esac
  )")

  # Local path
  echo ""
  if [[ "$IS_WORDPRESS" == true ]]; then
    read -rp "  Local WordPress path (press Enter to skip): " LOCAL_SITE_PATH_INPUT
  else
    read -rp "  Local repo path (press Enter to skip): " LOCAL_SITE_PATH_INPUT
  fi
  [[ -n "${LOCAL_SITE_PATH_INPUT:-}" ]] && LOCAL_SITE_PATH="$LOCAL_SITE_PATH_INPUT"

  # Tech audit mode
  if [[ "$LOCAL_SITE_PATH" != "N/A" ]]; then
    TECH_AUDIT_MODE="filesystem"
  else
    echo ""
    echo "  No local path provided. Options:"
    echo "    1) Front-end only — infer from public URL (limited: no source files or DB)"
    echo "    2) Skip technology audit"
    echo ""
    read -rp "  Choose [1/2]: " tech_choice
    case "${tech_choice:-1}" in
      1) TECH_AUDIT_MODE="frontend" ;;
      2) INCLUDE_TECH=false ;;
      *) TECH_AUDIT_MODE="frontend" ;;
    esac
  fi

fi

# ── confirm ────────────────────────────────────────────────────────────────────

echo ""
echo "Creating client:"
echo "  Name:            $CLIENT_NAME"
echo "  Slug:            $SLUG"
echo "  Directory:       clients/$SLUG/"
echo "  Audit purpose:   $AUDIT_PURPOSE_LABEL"
echo "  Public URL:      $PUBLIC_URL"
echo "  Previous domain: $PREVIOUS_DOMAIN"
[[ "$INCLUDE_TECH" == true ]] && echo "  CMS:             $CMS"
[[ "$INCLUDE_TECH" == true ]] && echo "  Hosting:         $HOSTING"
[[ "$INCLUDE_TECH" == true ]] && echo "  Local path:      $LOCAL_SITE_PATH"
echo ""
echo "  Audits:"
[[ "$INCLUDE_SEO"  == true ]] && echo "    ✓ SEO"
[[ "$INCLUDE_TECH" == true ]] && echo "    ✓ Technology ($TECH_AUDIT_MODE$([ "$IS_HEADLESS" == true ] && echo ", headless"))"
[[ "$INCLUDE_A11Y" == true ]] && echo "    ✓ Accessibility"
echo ""
read -rp "Proceed? [Y/n]: " confirm
if [[ "${confirm,,}" == "n" ]]; then
  echo "Aborted."
  exit 0
fi

# ── create directories ─────────────────────────────────────────────────────────

mkdir -p "$CLIENT_DIR"
cp "$TEMPLATE_DIR/CLAUDE.md" "$CLIENT_DIR/CLAUDE.md"

if [[ "$INCLUDE_SEO" == true ]]; then
  cp -r "$TEMPLATE_DIR/seo-audit" "$CLIENT_DIR/seo-audit"
  rm -f "$CLIENT_DIR/seo-audit/HANDOFF-"*.md
  cp "$TEMPLATE_DIR/seo-audit/HANDOFF-${AUDIT_PURPOSE}.md" "$CLIENT_DIR/seo-audit/HANDOFF.md"
fi
if [[ "$INCLUDE_TECH" == true ]]; then
  cp -r "$TEMPLATE_DIR/technology-audit" "$CLIENT_DIR/technology-audit"
  rm -f "$CLIENT_DIR/technology-audit/HANDOFF-"*.md
  cp "$TEMPLATE_DIR/technology-audit/HANDOFF-${AUDIT_PURPOSE}.md" "$CLIENT_DIR/technology-audit/HANDOFF.md"
fi
if [[ "$INCLUDE_A11Y" == true ]]; then
  cp -r "$TEMPLATE_DIR/accessibility-audit" "$CLIENT_DIR/accessibility-audit"
  rm -f "$CLIENT_DIR/accessibility-audit/HANDOFF-"*.md
  cp "$TEMPLATE_DIR/accessibility-audit/HANDOFF-${AUDIT_PURPOSE}.md" "$CLIENT_DIR/accessibility-audit/HANDOFF.md"
fi

# ── fill placeholders in CLAUDE.md ─────────────────────────────────────────────

CLAUDE_FILE="$CLIENT_DIR/CLAUDE.md"

# Replace composite placeholders first (they embed other placeholders)
replace_in_file "$CLAUDE_FILE" "{{AUDIT_PURPOSE_LABEL}}"  "$AUDIT_PURPOSE_LABEL"
replace_in_file "$CLAUDE_FILE" "{{AUDIT_GOAL}}"           "$AUDIT_GOAL"
# Then replace individual placeholders
replace_in_file "$CLAUDE_FILE" "{{CLIENT_DISPLAY_NAME}}"  "$CLIENT_NAME"
replace_in_file "$CLAUDE_FILE" "{{CLIENT_SLUG}}"          "$SLUG"
replace_in_file "$CLAUDE_FILE" "{{PUBLIC_URL}}"           "$PUBLIC_URL"
replace_in_file "$CLAUDE_FILE" "{{PREVIOUS_DOMAIN}}"      "$PREVIOUS_DOMAIN"
replace_in_file "$CLAUDE_FILE" "{{CMS}}"                  "$CMS"
replace_in_file "$CLAUDE_FILE" "{{HOSTING}}"              "$HOSTING"
replace_in_file "$CLAUDE_FILE" "{{LOCAL_SITE_PATH}}"      "$LOCAL_SITE_PATH"

# ── annotate technology HANDOFF ────────────────────────────────────────────────

if [[ "$INCLUDE_TECH" == true ]]; then
  TECH_HANDOFF="$CLIENT_DIR/technology-audit/HANDOFF.md"

  if [[ "$IS_WORDPRESS" == true ]]; then
    cat >> "$TECH_HANDOFF" <<'WPNOTE'

---

## WordPress-Specific Audit Areas

In addition to the generic technology audit above, cover these WordPress-specific areas:

### Theme Architecture
- Active theme: custom, child theme, or off-the-shelf? What templating engine (PHP, Timber/Twig, Blade)?
- PHP template files and routing logic; any component/partial system

### Content Model
- Custom post types (CPTs): slugs, public/non-public, archive routing
- Taxonomies per CPT; any configurable slugs stored in options
- ACF field groups: locations, key field types, flexible content layouts, options pages
- Are field group definitions version-controlled (JSON) or DB-only?

### Plugins
For each active plugin: purpose, hard vs. soft dependency, DB-only data (requires export), dev tools to remove.
Flag especially: form plugins, redirect plugins, SEO plugins, any with custom DB tables.

### Custom Functionality
Review `functions.php` and `inc/`. Document: CPT/taxonomy registration, custom queries, URL rewrites, API integrations, hardcoded credentials.

### Migration Checklist Additions
- [ ] Full database export (postmeta, options, term relationships)
- [ ] ACF field group JSON exports (verify completeness)
- [ ] Form plugin definitions export (Gravity Forms JSON, etc.)
- [ ] Redirect plugin rules export (JSON)
- [ ] Yoast/RankMath SEO meta (in DB export — flag if migrating off WP)
- [ ] ACF options page values (CPT slugs, GTM ID, global settings)
- [ ] Media library (`wp-content/uploads/`)
- [ ] Any plugin-specific custom DB tables (forms, maps, etc.)

WPNOTE
  fi

  if [[ "$IS_HEADLESS" == true ]]; then
    cat >> "$TECH_HANDOFF" <<HEADLESSNOTE

---

## Headless WordPress Notes

This site uses WordPress as a headless CMS with a **${FRONTEND_FRAMEWORK}** frontend. Theme rendering is not relevant — focus on the backend data model and API.

**Additional focus areas:**
- CPT REST API exposure (\`show_in_rest: true\`?)
- ACF fields exposed via REST API or WPGraphQL
- API-specific plugins (WPGraphQL, JWT Auth, ACF to REST API, etc.)
- Authentication scheme for private/preview content
- How the frontend consumes the WP API (fetch patterns, preview mode, ISR/SSG)

**Skip:**
- Template hierarchy and Twig/PHP rendering
- Enqueued styles/scripts (frontend manages its own assets)

HEADLESSNOTE
  fi

  if [[ "$TECH_AUDIT_MODE" == "frontend" ]]; then
    cat >> "$TECH_HANDOFF" <<'FRONTENDNOTE'

---

## ⚠️ Front-End Only Mode

No local path was available at setup time. This audit is limited to what can be inferred from the public URL and HTML source.

**What you can still assess:**
- HTML source: framework fingerprints, meta tags, schema markup, script inventory
- Public URL structure and redirects
- Third-party scripts (GTM, analytics, ad platforms, integrations)
- Publicly visible content model (URL patterns, page types)
- Network requests (API calls, CDN assets, third-party resources)

**What you cannot assess without source access:**
- Dependency inventory and versions
- Build configuration and environment variables
- Server-side logic, API routes, custom middleware
- Hardcoded credentials or dev tools in source files
- Non-public content types or admin-only functionality

**Recommendation:** Flag gaps clearly in the report. If source access becomes available, supplement with a filesystem pass.

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
