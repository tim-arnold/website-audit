# Sonnet Handoff — NobleReach SEO Benchmark

## Context

You are continuing an SEO pre-redesign benchmark for **noblereach.org**. All data collected so far is in `data/baseline-data.md`. Read that file first.

The project README describes three reports to produce. Report 2 (Strategic Baseline) is mostly done from the data already collected. Report 1 (Technical Baseline) and Report 3 (Risk Register) need a technical audit first.

## What's Done

- Domain rank overview (195 ranked keywords, ~1,685 ETV)
- Top ranked keywords by search volume
- Full backlink profile (640 backlinks, 294 referring domains, anchor text distribution)
- AI/LLM mention tracking (Google AI Overviews + ChatGPT)
- Key observations and redesign risks identified

## What's Left

### Step 1: Technical Audit

Run these DataForSEO MCP tools against the site. Do them in parallel where possible.

**a) On-page audit of key pages.** Use `on_page_instant_pages` for each of these URLs:
- `https://noblereach.org/`
- `https://noblereach.org/person/kevin-stitt/`
- `https://noblereach.org/person/dr-robert-m-gates/`
- `https://noblereach.org/stories/noblereach-emerge-lightdeck/`
- `https://noblereach.org/stories/founders-fund/`
- `https://noblereach.org/us-tech-force/`
- `https://noblereach.org/news/16-innovations-fueled-by-the-federal-government/`
- `https://noblereach.org/person/general-paul-nakasone-ret/`
- `https://noblereach.org/person/anne-neuberger/`

From each result, extract: title tag, meta description, H1, canonical URL, schema/structured data present, internal/external link counts, page load issues, and any on-page SEO problems.

**b) Lighthouse audit.** Use `on_page_lighthouse` on the homepage and one person page to get Core Web Vitals (LCP, CLS, INP/TBT), performance score, accessibility score, and SEO score.

**c) Competitor keyword gap (optional but valuable).** If you can identify 2-3 peer organizations from the site content (e.g., other gov-tech or defense-innovation nonprofits), use `dataforseo_labs_google_domain_intersection` to find keywords competitors rank for that noblereach.org does not.

### Step 2: Expand Keyword Data

Use `dataforseo_labs_google_ranked_keywords` with `limit: 1000` to get the full keyword inventory. Sort by search volume descending. Save the full list to `data/full-keyword-inventory.md` as a table.

Also pull keywords filtered to top-10 only (`filters: [["ranked_serp_element.serp_item.rank_group","<=",10]]`) and save separately — these are the most at-risk in a redesign.

### Step 3: Identify Broken/At-Risk Pages

Use `backlinks_domain_pages` (if available) or query the site to find:
- All pages with external backlinks (these need redirects if URLs change)
- The 17 already-broken pages (from backlink summary data)
- Pages ranking in top 10 that would lose traffic if URLs change

### Step 4: Write the Reports

Save all reports to the `reports/` directory.

**Report 1: `reports/01-technical-baseline.md`**
- Core Web Vitals scores (from Lighthouse)
- On-page SEO audit results (title tags, meta descriptions, H1s, canonical issues)
- Schema/structured data inventory
- Internal link structure summary (9,507 internal links — note any orphan pages or thin clusters)
- Broken pages list
- Mobile readiness assessment
- Security (Cloudflare — note from backlink data)

**Report 2: `reports/02-strategic-baseline.md`**
- Current keyword rankings (summary table + link to full inventory)
- Traffic-driving pages (top 20 by estimated traffic)
- Backlink profile summary (referring domains, TLD breakdown, anchor text)
- AI/LLM mention presence (Google AI Overviews, ChatGPT)
- Competitor keyword gaps (if Step 1c was done)
- SERP feature ownership (any featured snippets, knowledge panels from keyword data)

**Report 3: `reports/03-redesign-risk-register.md`**

This is the most important deliverable. Structure it as actionable checklists:

- **URL Redirect Map**: Every URL that ranks or has backlinks. Table format: `Current URL | Ranks For | Backlinks | Action Required`
- **Backlinked Pages**: All pages with external links, especially .edu and .gov links
- **Old Domain Redirects**: noblereachfoundation.org → noblereach.org chain must persist. Call this out prominently.
- **SERP Features at Risk**: Pages in AI Overviews, any featured snippets
- **Content to Preserve**: Pages driving organic traffic that must carry over verbatim or with equivalent content
- **Schema to Maintain**: Any structured data currently earning rich results
- **Known Broken Pages**: The 17 already-broken pages — recommend fixes or proper 410s
- **Technical Debt to Fix in Rebuild**: HubSpot UTM parameter pollution, any issues found in the technical audit

### Formatting Notes

- Use markdown tables throughout
- Lead each report with a 3-5 bullet executive summary
- Keep reports factual — data and recommendations, no filler
- Reference specific URLs and numbers, not vague generalizations
- The audience is a dev team doing a site rebuild — be specific about what they need to do

## Available Tools

You have access to the DataForSEO MCP server (`dfs-mcp`) and Playwright MCP. The Backlinks API trial is active (summary, referring_domains, and anchors work; the `backlinks_backlinks` endpoint returned access denied — don't retry it). The LLM mentions API is also active.

The `claude-seo` skill referenced in the README is NOT installed — don't try to invoke it. Use DataForSEO and Playwright directly.
