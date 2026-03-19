# SEO Audit — Data

Raw and structured data collected during the audit. These files are the source of truth that the reports are derived from. If a report number looks off, check here first.

## Files

| File | Source | Description |
|---|---|---|
| `baseline-data.md` | DataForSEO (multiple endpoints) | First-pass data collection: domain rank overview, top keywords by volume, backlink summary, anchor text, AI/LLM mentions, and key observations. Collected as a starting point before deeper pulls. |
| `technical-audit.md` | DataForSEO `on_page_instant_pages` + `on_page_lighthouse` | On-page SEO audit for 9 key URLs and Lighthouse scores for the homepage and Kevin Stitt person page. Includes per-page issues table and third-party script inventory. |
| `full-keyword-inventory.md` | DataForSEO `dataforseo_labs_google_ranked_keywords` | All 270 keywords noblereach.org ranks for, sorted by search volume descending. Includes rank and ranking URL for each. |
| `top10-keywords.md` | DataForSEO `dataforseo_labs_google_ranked_keywords` (filtered) | The 88 keywords ranking in positions 1–10. These are the highest-risk keywords in a redesign — any URL change without a redirect loses them immediately. |
| `pages-and-broken-links.md` | DataForSEO `backlinks_domain_pages` | Per-page backlink data for all 405 indexed pages. Identifies 404 pages with active backlinks, existing 301 redirect chains, and UTM-polluted URLs receiving external links. |

## Notes

- Keyword counts differ slightly between `baseline-data.md` (195 keywords, collected first) and `full-keyword-inventory.md` (270 keywords, collected later) — the site gained rankings between the two pulls.
- The `full-keyword-inventory.md` table strips UTM parameters from ranking URLs for readability. The raw UTM URL for the "lightdeck" keyword (rank 19) is preserved in `baseline-data.md` and `technical-audit.md`.
- `backlinks_backlinks` (individual backlink endpoint) returned access denied and was not collected. Referring domain and summary data is complete.
