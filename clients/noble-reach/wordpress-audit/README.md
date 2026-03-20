# WordPress Audit — noblereach.org

**Status:** Planned

---

## What This Audit Will Cover

A technical audit of the WordPress installation focused on identifying issues that should be addressed in the rebuild (or migrated away from). Likely scope:

- **Plugin inventory** — active plugins, update status, redundancy, security risk
- **Theme** — custom vs. off-the-shelf, template structure, page builder usage
- **Performance** — caching configuration, image optimization, render-blocking assets
- **Security** — WordPress version, plugin vulnerabilities, file permissions, login hardening
- **Content architecture** — post types, custom fields, taxonomy structure
- **Third-party integrations** — HubSpot, GTM, analytics setup, any tag manager cruft
- **Media library** — image sizes, orphaned media, naming conventions

## Methodology

TBD — likely a combination of:
- Site crawl and admin access (if available)
- WPScan or equivalent for security
- Query Monitor or plugin audit via admin
- Manual inspection of theme/template structure

## Contents

```
wordpress-audit/
├── data/        Raw findings and plugin/theme inventories
└── reports/     Final report(s) for the dev team
```
