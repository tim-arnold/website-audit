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

## Running a Retest

After a redesign launches or a remediation is applied, scaffold a new retest:

```bash
./add-retest.sh
```

The script prompts for the client slug and which audit types to retest. It auto-increments the retest number and creates `<audit-type>/retest-N/` with `data/`, `reports/`, and a pre-filled `HANDOFF.md`. Multiple retests are supported per audit type.

Retest reports live at `<audit-type>/retest-N/reports/`. The comparison report is always `00-comparison.md`. The web app groups them under Initial / Retest N sub-headers in the sidebar.

## Clients

| Client | URL | Status |
|---|---|---|
| noble-reach | https://noblereach.org | SEO ✓ · WordPress ✓ · Accessibility ✓ |
