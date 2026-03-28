# Site Audit Framework

Pre-redesign and remediation audits across multiple clients. Each client lives in `clients/<slug>/`.

## Clients

| Client | URL | Type | Status |
|---|---|---|---|
| noble-reach | https://noblereach.org | Pre-redesign | SEO ✓ · WordPress ✓ · Accessibility ✓ |
| outright | https://weareoutright.com | Remediation | SEO ✓ · Technology ✓ |
| unruled-masses | https://unruledmasses.org | Remediation | SEO ✓ · Technology ✓ · Accessibility ✓ · Analytics ✓ · Security ✓ |

## Audit Dependencies

Each audit type requires different tools to be configured in Claude Code.

### SEO Audit
- **DataForSEO MCP** (`dfs-mcp`) — provides SERP data, keyword rankings, backlink analysis, Lighthouse, on-page audits, and AI mention data
- Configure via the DataForSEO MCP server in Claude Code settings with your API credentials

### Technology Audit
- **Local repo/site copy** — a filesystem copy of the codebase (WordPress local, git clone, etc.). Path goes in the client's `CLAUDE.md`.
- No external API credentials required — the audit is filesystem-only (read-only)
- Front-end only mode available if no local copy exists (with caveats)

### Analytics Audit

**Tool:** Google Analytics MCP (`analytics-mcp`) — queries GA4 for traffic, behavior, events, conversions, and data quality checks.

#### Access requirements

The client must grant your Google account **Viewer** access (read-only) to their GA4 property before you can pull data. They do this in:

> GA4 Admin → Account Access Management (for all properties) **or** Property Access Management (for one property) → Add users → enter your Google email → role: Viewer

You need the GA4 **property ID** (a numeric ID, e.g. `526160702`, found in GA4 Admin → Property Settings). Store it in the client's `.env.local`:

```
GA4_PROPERTY_ID=526160702
```

#### One-time MCP install

```bash
pipx install analytics-mcp
claude mcp add analytics-mcp -s user -- pipx run analytics-mcp
```

#### Authentication (per machine / when token expires)

The MCP uses **Application Default Credentials** with `analytics.readonly` scope. Standard `gcloud auth application-default login` does not include this scope — you must pass it explicitly:

```bash
gcloud auth application-default login \
  --scopes="https://www.googleapis.com/auth/analytics.readonly,https://www.googleapis.com/auth/cloud-platform"
```

This opens a browser to your Google account (the one the client has granted Viewer access). The token is saved locally and persists across sessions until it expires or is revoked. After authenticating, reconnect the server in Claude Code via `/mcp`.

If you see `ACCESS_TOKEN_SCOPE_INSUFFICIENT` errors, re-run the command above — the token is missing the analytics scope and needs to be refreshed.

#### Field name casing

The GA4 Data API requires **camelCase** for all dimension and metric names (`sessionDefaultChannelGroup`, `landingPage`, `deviceCategory`, `yearMonth`, `eventName`, `bounceRate`, etc.), even though the MCP tool description says to use snake_case. Using snake_case returns a 400 error.

### Security Audit
- **Local repo/site copy** — for dependency scanning and credential checks
- **Playwright MCP** — for live site header and TLS inspection
- No additional API credentials required beyond what other audits use

### Accessibility Audit
- **Playwright MCP** — browser automation for live page testing, screenshots, keyboard navigation, and accessibility tree inspection
- Install: add the Playwright MCP server to Claude Code settings
- **Local site copy** (optional) — for the code-level pass; audit proceeds with live site only if unavailable

---

## Adding a New Client

```bash
./new-client.sh
```

Prompts for client details and creates a ready-to-use directory under `clients/` from the `_template/`.

## Adding an Audit to an Existing Client

```bash
./new-client.sh --add-audit
```

Lists existing clients and their current audit status, then prompts for which client and which audit type to add. Scaffolds the audit directory (with `data/` and `reports/` subdirectories and a `HANDOFF.md`) and updates the client's `CLAUDE.md` status. Automatically selects the correct HANDOFF template (pre-redesign vs. remediation) based on the client's existing `CLAUDE.md`.

## Report Viewer

Reports are rendered as a navigable web app in `web/`. Live at `audits.weareoutright.com` (Cloudflare Access — email OTP required).

### Run locally

```bash
cd web
npm install
npm run dev
```

Opens at `http://localhost:4321`. No auth required locally — all reports are accessible.

### Build

```bash
cd web
npm run build
```

Output goes to `web/dist/`. Deployed automatically by Cloudflare Pages on push to `main`.

## Repo Structure

```
clients/
  <client-slug>/
    CLAUDE.md                    ← client context (URL, CMS, local path, status)
    .env.local                   ← GA4 property ID and other secrets (gitignored)
    seo-audit/
      data/                      ← raw collected data
      reports/                   ← final deliverable reports
    technology-audit/
      data/
      reports/
    accessibility-audit/
      data/
      reports/
      screenshots/
    analytics-audit/
      data/
      reports/
    security-audit/
      data/
      reports/
    wordpress-audit/             ← WordPress-only clients
      data/
      reports/

_template/                       ← copied by new-client.sh; each audit type has
  <audit-type>/                    HANDOFF-preredesign.md and HANDOFF-remediation.md
  CLAUDE.md

web/                             ← Astro report viewer
  src/
    lib/reports.ts               ← reads clients/*/reports/*.md at build time
    pages/                       ← [client]/[report] dynamic routes
    layouts/
    styles/
  astro.config.mjs
  wrangler.toml                  ← Cloudflare Pages config

wrangler.toml                    ← root-level Cloudflare config
new-client.sh                    ← scaffold new client or add audit to existing one
CLAUDE.md                        ← project-level instructions for Claude Code
```
