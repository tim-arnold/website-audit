# SEO Audit — noblereach.org

**Status:** Complete
**Audit date:** 2026-03-19
**Tools:** DataForSEO MCP (`dfs-mcp`)

---

## What This Audit Covers

A pre-redesign SEO baseline capturing the site's current search performance so nothing valuable is lost during the rebuild. It covers:

- **Keyword rankings** — every keyword the domain ranks for, with position, search volume, and URL
- **Backlink profile** — referring domains, TLD breakdown, anchor text, and which pages have inbound links
- **On-page SEO** — title tags, meta descriptions, H1s, canonical tags, content rate, and flagged issues for key pages
- **Core Web Vitals** — Lighthouse performance, accessibility, Best Practices, and SEO scores
- **AI/LLM mentions** — presence in Google AI Overviews and ChatGPT
- **Broken pages** — 404s with active backlinks, existing redirect chains, UTM pollution

## Methodology

Data was collected via the DataForSEO API across several endpoints:

| Endpoint | What It Provided |
|---|---|
| `dataforseo_labs_google_domain_rank_overview` | Total ranked keywords, position distribution, ETV |
| `dataforseo_labs_google_ranked_keywords` | Full keyword inventory (270 keywords) |
| `backlinks_summary` | Total backlinks, referring domains, spam score |
| `backlinks_referring_domains` | Domain-level backlink breakdown |
| `backlinks_anchors` | Anchor text distribution |
| `backlinks_domain_pages` | Per-page backlink counts, 404 detection |
| `on_page_instant_pages` | On-page SEO audit for 9 key URLs |
| `on_page_lighthouse` | Lighthouse scores for homepage and one person page |
| `ai_opt_llm_ment_search` / related | Google AI Overview and ChatGPT mention data |

Pages audited for on-page SEO:
- Homepage
- `/person/kevin-stitt/`, `/person/dr-robert-m-gates/`, `/person/general-paul-nakasone-ret/`, `/person/anne-neuberger/`
- `/stories/noblereach-emerge-lightdeck/`, `/stories/founders-fund/`
- `/us-tech-force/`, `/news/16-innovations-fueled-by-the-federal-government/`

## Contents

```
seo-audit/
├── data/        Raw and structured data collected during the audit
└── reports/     Final reports for the dev team
```

See `data/README.md` and `reports/README.md` for file-level details.

## Key Findings (Summary)

- 270 ranked keywords, ~1,685 estimated monthly organic visits
- 88 keywords in positions 1–10 — all at immediate risk if URLs change without redirects
- 113 .edu referring domains — the site's most valuable SEO asset
- All person pages missing H1 tags and meta descriptions
- No structured data anywhere on the site
- `/us-tech-force/` redirects to a press release rather than a landing page
- BugHerd dev tool and AppNexus ad scripts loading on production (likely cause of 56/100 Best Practices score)

Full findings are in `reports/`.
