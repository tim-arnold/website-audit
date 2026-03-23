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
- **Google Analytics MCP** (`analytics-mcp`) — GA4 data: traffic, behavior, conversions, data quality checks
- **GA4 Property ID** — store in the client's `.env.local` (gitignored) as `GA4_PROPERTY_ID`
- Setup: `pipx install analytics-mcp` + `gcloud auth application-default login` + `claude mcp add analytics-mcp -s user -- pipx run analytics-mcp`

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
    seo-audit/
      data/                      ← raw collected data
      reports/                   ← final deliverable reports
    wordpress-audit/
      data/
      reports/
    accessibility-audit/
      data/
      reports/
      screenshots/

_template/                       ← copied by new-client.sh
web/                             ← Astro report viewer
  src/
    lib/reports.ts               ← reads clients/*/reports/*.md at build time
    pages/                       ← [client]/[report] dynamic routes
    layouts/
    styles/
  package.json
  astro.config.mjs
  wrangler.toml                  ← Cloudflare Workers static asset config
```
