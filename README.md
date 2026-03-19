# Noble Reach — Pre-Redesign SEO Benchmark

SEO baseline audit for **noblereach.org** before a full website redesign and rebuild.

## Purpose

Capture the current state of the website so the dev team can:
- **Preserve strengths** — rankings, backlinks, SERP features, content that drives traffic
- **Identify weaknesses** — technical issues, content gaps, missed structured data opportunities
- **Build a risk register** — URL redirect map, backlinked pages, and anything that could break during the rebuild

## Data

Raw and structured data collected during the audit:

| File | Contents |
|---|---|
| `data/baseline-data.md` | Domain rank overview, top keywords, backlink summary, AI mention data |
| `data/technical-audit.md` | On-page audit results (9 pages) and Lighthouse scores |
| `data/full-keyword-inventory.md` | All 270 ranked keywords sorted by search volume |
| `data/top10-keywords.md` | 88 keywords ranking in positions 1–10 (highest redesign risk) |
| `data/pages-and-broken-links.md` | All pages with backlinks, 404 pages, and existing redirect chains |

## Reports

| Report | File | Description |
|---|---|---|
| 1 — Technical Baseline | `reports/01-technical-baseline.md` | Lighthouse scores, on-page SEO issues, structured data gaps, broken pages, infrastructure |
| 2 — Strategic Baseline | `reports/02-strategic-baseline.md` | Keyword rankings, traffic-driving pages, backlink profile, AI Overview presence |
| 3 — Redesign Risk Register | `reports/03-redesign-risk-register.md` | URL redirect map, content to preserve, schema plan, broken page fixes, technical debt |

## Key Facts

- **Domain:** noblereach.org (previously noblereachfoundation.org — redirects are load-bearing)
- **Platform:** WordPress on Cloudflare
- **Ranked keywords:** 270 | **Estimated monthly organic visits:** ~1,685
- **Referring domains:** 294 (113 from .edu — highest-value links)
- **Audit date:** 2026-03-19
