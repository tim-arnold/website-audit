# Pre-Redesign Audit Framework

This repo contains pre-redesign audits across multiple clients. Each client lives in `clients/<slug>/`.

## Structure

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

_template/                       ← copy this to bootstrap a new client
  CLAUDE.md                      ← fill in {{PLACEHOLDERS}} or run new-client.sh
  seo-audit/HANDOFF.md
  wordpress-audit/HANDOFF.md
  accessibility-audit/HANDOFF.md
```

## Starting a New Client

```bash
./new-client.sh
```

The script will prompt for client details and create a ready-to-use directory under `clients/`.

## Clients

| Client | URL | Status |
|---|---|---|
| noble-reach | https://noblereach.org | SEO ✓ · WordPress ✓ · Accessibility ✓ |

## Conventions

- **Report H1 titles must start with the report name, not the client name.** The web app sidebar strips everything after the em dash, so `# Technology Audit Report — Client Name` is correct; `# Client Name — Technology Audit Report` is not.
