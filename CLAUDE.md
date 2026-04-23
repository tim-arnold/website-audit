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

## Analytics MCP Setup

The `analytics-mcp` server uses **Application Default Credentials** with the `analytics.readonly` scope. Standard `gcloud auth application-default login` does NOT include this scope — you must pass it explicitly. If you see `ACCESS_TOKEN_SCOPE_INSUFFICIENT` errors, re-authenticate:

```bash
gcloud config set account tim@weareoutright.com
gcloud auth application-default login --scopes=https://www.googleapis.com/auth/analytics.readonly,https://www.googleapis.com/auth/cloud-platform
gcloud auth application-default set-quota-project analytics-mcp-<client-slug>
```

Keep `--scopes` on one line — backslash continuations can silently break in zsh. After re-authenticating, reconnect the MCP server via `/mcp` in Claude Code.

**Field name casing:** Despite the MCP tool description saying to use snake_case, the GA4 Data API requires **camelCase** for all dimension and metric names. Use `sessionDefaultChannelGroup`, `landingPage`, `deviceCategory`, `yearMonth`, `eventName`, `eventCount`, `newUsers`, `bounceRate`, `engagedSessions`, `averageSessionDuration`, etc. Snake_case will return a 400 error with a camelCase suggestion.

The GA4 property ID for each client is stored in `clients/<slug>/.env.local` (gitignored).

## Conventions

- **Report H1 titles must start with the report name, not the client name.** The web app sidebar strips everything after the em dash, so `# Technology Audit Report — Client Name` is correct; `# Client Name — Technology Audit Report` is not.
