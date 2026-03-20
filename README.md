# Site Audit Framework

Pre-redesign audits for Outright clients. Each client lives in `clients/<slug>/`.

## Clients

| Client | URL | Status |
|---|---|---|
| noble-reach | https://noblereach.org | SEO ✓ · WordPress ✓ · Accessibility ✓ |

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
