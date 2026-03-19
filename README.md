# Noble Reach — Pre-Redesign Audit

Baseline audits for **noblereach.org** before a full website redesign and rebuild.

## Purpose

Capture the current state of the website so the dev team can:
- **Preserve strengths** — rankings, backlinks, SERP features, content that drives traffic
- **Identify weaknesses** — technical issues, content gaps, missed structured data opportunities
- **Build a risk register** — URL redirect map, backlinked pages, and anything that could break during the rebuild

## Audits

| Directory | Status | Description |
|---|---|---|
| `seo-audit/` | ✅ Complete | Keyword rankings, backlinks, AI mentions, on-page audit, Lighthouse, risk register |
| `wordpress-audit/` | Planned | WordPress-specific technical audit |
| `accessibility-audit/` | Planned | Accessibility audit |

## Key Facts

- **Domain:** noblereach.org (previously noblereachfoundation.org — redirects are load-bearing)
- **Platform:** WordPress on Cloudflare
- **Audit date:** 2026-03-19

---

## SEO Audit (`seo-audit/`)

### Data

| File | Contents |
|---|---|
| `seo-audit/data/baseline-data.md` | Domain rank overview, top keywords, backlink summary, AI mention data |
| `seo-audit/data/technical-audit.md` | On-page audit results (9 pages) and Lighthouse scores |
| `seo-audit/data/full-keyword-inventory.md` | All 270 ranked keywords sorted by search volume |
| `seo-audit/data/top10-keywords.md` | 88 keywords ranking in positions 1–10 (highest redesign risk) |
| `seo-audit/data/pages-and-broken-links.md` | All pages with backlinks, 404 pages, and existing redirect chains |

### Reports

| Report | File | Description |
|---|---|---|
| 1 — Technical Baseline | `seo-audit/reports/01-technical-baseline.md` | Lighthouse scores, on-page SEO issues, structured data gaps, broken pages, infrastructure |
| 2 — Strategic Baseline | `seo-audit/reports/02-strategic-baseline.md` | Keyword rankings, traffic-driving pages, backlink profile, AI Overview presence |
| 3 — Redesign Risk Register | `seo-audit/reports/03-redesign-risk-register.md` | URL redirect map, content to preserve, schema plan, broken page fixes, technical debt |
