# Site Audit Framework

Pre-redesign audits for Outright clients. Each client lives in `clients/<slug>/`.

## Clients

| Client | URL | Status |
|---|---|---|
| noble-reach | https://noblereach.org | SEO ✓ · WordPress ✓ · Accessibility ✓ |

## Audit Dependencies

Each audit type requires different tools to be configured in Claude Code.

### SEO Audit
- **DataForSEO MCP** (`dfs-mcp`) — provides SERP data, keyword rankings, backlink analysis, Lighthouse, on-page audits, and AI mention data
- Configure via the DataForSEO MCP server in Claude Code settings with your API credentials

### Technology Audit
- **Local repo/site copy** — a filesystem copy of the codebase (WordPress local, git clone, etc.). Path goes in the client's `CLAUDE.md`.
- No external API credentials required — the audit is filesystem-only (read-only)
- Front-end only mode available if no local copy exists (with caveats)

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
