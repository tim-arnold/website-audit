# SEO Pre-Redesign Audit

## Context

You are conducting an SEO pre-redesign benchmark for the client described in `../CLAUDE.md`. Read that file first — it has the public URL, previous domain, CMS, and hosting details.

The goal is to establish a complete SEO baseline before a site rebuild so the dev team knows what to preserve, what to redirect, and what risks to mitigate.

## Deliverables

Save all output to this directory:
- Raw data → `data/`
- Final reports → `reports/`

Produce three reports:

**`reports/01-technical-baseline.md`** — On-page and technical SEO health
**`reports/02-strategic-baseline.md`** — Keyword rankings, traffic, backlinks, AI presence
**`reports/03-redesign-risk-register.md`** — Actionable checklist of what must not break

---

## Step 1: Collect Baseline Data

Run these DataForSEO tools. Do them in parallel where possible. Save raw output to `data/baseline-data.md`.

### a) Domain rank overview
Use `dataforseo_labs_google_domain_rank_overview` for the domain. Extract: total ranked keywords, estimated traffic value, top-performing pages.

### b) Top ranked keywords
Use `dataforseo_labs_google_ranked_keywords` with `limit: 100`, sorted by search volume descending. Then run again with `filters: [["ranked_serp_element.serp_item.rank_group","<=",10]]` to isolate top-10 rankings — these are highest risk in a redesign.

For a fuller picture, run again with `limit: 1000` and save the complete list to `data/full-keyword-inventory.md`.

### c) Backlink profile
Use `backlinks_summary` for the domain. Also run `backlinks_referring_domains` and `backlinks_anchors`. Extract: total backlinks, unique referring domains, TLD distribution (flag .edu and .gov), top anchor text, spam score.

Note: the `backlinks_backlinks` endpoint may require a higher API tier — if it returns an error, skip it and note what was unavailable.

### d) AI/LLM mentions
Use `ai_opt_llm_ment_search` with the domain to check for appearances in AI Overviews and LLM responses. Note any queries where the site appears and what context it's cited in.

### e) On-page audit of key pages
Use `on_page_instant_pages` on the homepage and the top 5-8 traffic-driving pages (identified from keyword data above). For each, extract: title tag, meta description, H1, canonical URL, structured data present, page load issues, internal/external link counts.

### f) Lighthouse audit
Use `on_page_lighthouse` on the homepage and one representative content page (e.g., highest-traffic inner page). Extract: Core Web Vitals (LCP, CLS, INP/TBT), performance score, accessibility score, SEO score, Best Practices score.

### g) Competitor gap (optional)
If you can identify 2-3 peer organizations from the site content, use `dataforseo_labs_google_domain_intersection` to find keywords competitors rank for that this domain does not.

---

## Step 2: Write the Reports

### Report 1: Technical Baseline (`reports/01-technical-baseline.md`)

- Core Web Vitals (from Lighthouse) — flag any failing metrics
- On-page SEO audit results: title tags, meta descriptions, H1s, canonical issues
- Schema/structured data inventory — what types are present, any gaps
- Internal link structure summary
- Broken/404 pages (from backlink data or on-page audit)
- Mobile readiness
- Security and hosting setup

### Report 2: Strategic Baseline (`reports/02-strategic-baseline.md`)

- Current keyword rankings: summary table + link to full inventory
- Top traffic-driving pages (table: page URL, top keyword, estimated traffic)
- Backlink profile: referring domain count, TLD breakdown, notable high-authority links, anchor text distribution
- AI/LLM mention presence
- Competitor keyword gaps (if collected)
- SERP features: any featured snippets, knowledge panels, People Also Ask appearances

### Report 3: Redesign Risk Register (`reports/03-redesign-risk-register.md`)

This is the most important deliverable. Structure it as actionable checklists:

- **URL Redirect Map**: Every URL that ranks in top 20 or has backlinks. Table: `Current URL | Ranks For | Backlinks | Action Required`
- **Backlinked Pages**: All pages with external links — flag .edu and .gov links prominently
- **Previous Domain Redirects**: If there's a previous domain in CLAUDE.md, the redirect chain must persist through the rebuild. Call this out.
- **SERP Features at Risk**: Pages in AI Overviews, featured snippets — these require content continuity
- **Content to Preserve**: Pages driving organic traffic that must carry over verbatim or with equivalent content
- **Schema to Maintain**: Structured data currently earning rich results
- **Known Broken Pages**: Recommend fixes or proper 410s
- **Technical Debt to Fix**: Any issues surfaced in the technical audit worth fixing in the rebuild

---

## Formatting Notes

- Use markdown tables throughout
- Lead each report with a 3-5 bullet executive summary
- Keep reports factual — data and recommendations, no filler
- Reference specific URLs and numbers
- Audience is a dev team doing a site rebuild — be specific about what they need to do
