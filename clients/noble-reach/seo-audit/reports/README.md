# SEO Audit — Reports

Three reports written for the dev team performing the site rebuild. Start with Report 3 if you need to act quickly — it's the most directly actionable.

## Reports

### [01 — Technical Baseline](01-technical-baseline.md)

What the site looks like under the hood. Covers:
- Lighthouse scores (performance, accessibility, Best Practices, SEO) for homepage and a person page
- Core Web Vitals: LCP, FCP, TTI
- On-page SEO issues for 9 key pages: title tags, meta descriptions, H1s, canonical tags
- Structured data inventory (spoiler: there is none)
- Internal link structure summary
- Broken pages list with backlink counts
- Third-party scripts loaded on every page
- Infrastructure and security notes

**Audience:** Developers and SEO practitioners planning the rebuild.

---

### [02 — Strategic Baseline](02-strategic-baseline.md)

How the site performs in search. Covers:
- Keyword ranking distribution (270 keywords, positions 1–100+)
- Top keywords by search volume with ranking URLs
- Top 20 traffic-driving pages with estimated monthly visit contribution
- Full backlink profile: referring domains, TLD breakdown (113 .edu), anchor text
- AI/LLM presence: Google AI Overviews (9 appearances, ~25,470 impressions), ChatGPT
- SERP feature ownership

**Audience:** Anyone making content or architecture decisions for the new site.

---

### [03 — Redesign Risk Register](03-redesign-risk-register.md)

The most critical deliverable. A checklist of everything that must be handled correctly on launch day. Covers:
- **URL redirect map** — every ranked or backlinked URL with action required
- **Existing redirect chains** — 301s already in place that carry backlinks and must persist
- **Old domain redirect** — `noblereachfoundation.org` → `noblereach.org` must never be removed
- **SERP features at risk** — AI Overview pages and position 1–2 rankings
- **Content to preserve verbatim** — pages where content changes could lose rankings
- **Schema to implement** — Person, Article, Organization, BreadcrumbList (none currently exist)
- **Broken pages** — 7 active 404s with backlinks, fix recommendations for each
- **Technical debt** — HubSpot UTM pollution, BugHerd on production, AppNexus scripts, missing H1s/meta descriptions

**Audience:** Dev team lead and project manager. Review before finalizing the new site's URL structure.
