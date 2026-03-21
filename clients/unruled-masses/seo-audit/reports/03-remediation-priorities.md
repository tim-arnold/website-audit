# SEO Remediation Priorities — Unruled Masses

**Site:** https://unruledmasses.org
**Audit date:** 2026-03-21

---

## Executive Summary

- The site launched 54 days ago and has no measurable organic footprint yet — this is the expected baseline, not a problem to fix.
- Three issues need immediate attention before Google's crawl establishes what this site is: broken playbook pages, missing image alt text, and missing structured data.
- The most impactful SEO lever available is content: the site has ~3,200 words of indexable content. The playbooks and intelligence platform, once built, will be the organic growth engine.
- Title tag and meta description fixes on the news article and news index are quick wins that should happen in the next sprint.
- A full content and backlink strategy should be revisited at the 90-day mark (late April 2026) when first keyword data becomes available.

---

## Priority 1 — Quick Wins

*High impact, low effort. Fix before the next Google crawl cycle.*

### 1.1 Fix broken /playbooks and /playbooks/poster-campaigns (404s)

| | |
|---|---|
| **What's wrong** | Both `/playbooks` and `/playbooks/poster-campaigns` return HTTP 404. The homepage links to playbooks content, and GA4 shows real users visiting these URLs. Google cannot index them. |
| **Why it matters** | Broken internal links bleed crawl equity. Users who click through from the homepage hit a dead end. If the playbooks are a core product, every day they're 404 is a day Google isn't building topic authority for that content. |
| **Fix** | Either (a) deploy the playbooks pages, or (b) temporarily redirect `/playbooks` → `/` and `/playbooks/poster-campaigns` → `/` until content is ready. Remove homepage links to these pages if they will not be live soon. |
| **Effort** | 1–2 hours (redirect) or sprint work (full page build) |

### 1.2 Add alt text to all images

| | |
|---|---|
| **What's wrong** | Homepage has 25 images; DataForSEO flagged missing alt attributes. `/our-team` has 10 team member photos. Alt text is absent or incomplete across the site. |
| **Why it matters** | Missing alt text means Google cannot understand image content. For a site with strong visual storytelling, this is lost indexation surface. It also creates accessibility failures (WCAG 2.1 AA). |
| **Fix** | In Sanity CMS: ensure every image field has an `alt` text field and that it is required. In Next.js: pass alt text from Sanity to `<Image alt={...} />`. For team photos: use the person's name + role. For content images: describe what's shown. |
| **Effort** | 2–4 hours (schema + code fix); content population is ongoing |

### 1.3 Shorten the news article title tag

| | |
|---|---|
| **What's wrong** | `/news/um-launches-civic-intelligence-system` has a 122-character title tag. Google truncates titles at ~55–60 characters in desktop SERPs. The displayed title will be cut off and meaningless. |
| **Why it matters** | Title truncation reduces click-through rates. The full headline works as an H1 but not as a title tag. |
| **Fix** | Set a separate SEO title field in Sanity (distinct from the article headline H1). For this article, try: `"Unruled Masses Launches Civic Intelligence System"` (51 chars). |
| **Effort** | 1–2 hours (Sanity schema field + template fix); 15 min per article after |

### 1.4 Fix the empty H2 on /our-team

| | |
|---|---|
| **What's wrong** | The `/our-team` page has an empty `<h2></h2>` tag — likely from a CMS field left blank. |
| **Why it matters** | Empty heading tags confuse screen readers and look like malformed markup to crawlers. |
| **Fix** | Identify which team member or section has a blank name field in Sanity and populate it, or add a conditional in the template: `{name && <h2>{name}</h2>}`. |
| **Effort** | 30 minutes |

### 1.5 Lengthen /news title tag and meta description

| | |
|---|---|
| **What's wrong** | Title is "News \| Unruled Masses" (21 chars) — flagged as too short. Meta is generic ("Press releases, announcements, and news from Unruled Masses."). |
| **Why it matters** | Short titles provide Google no signal about page topic. When someone searches for news about civic tech or democracy orgs, this page won't compete. |
| **Fix** | Title: `"News & Press Releases | Unruled Masses"` or `"Civic Democracy News | Unruled Masses"` (~40 chars). Meta: add a sentence about the topics covered, e.g. "Follow Unruled Masses for the latest on civic intelligence, corruption accountability, and nonviolent action." |
| **Effort** | 30 minutes |

---

## Priority 2 — High Impact

*Meaningful SEO improvement; requires more build or content work.*

### 2.1 Add Organization and WebSite structured data

| | |
|---|---|
| **What's wrong** | No schema.org JSON-LD on any page. Google has no structured signal that this is a nonprofit organization. |
| **Why it matters** | `Organization` schema is the fastest path to a Knowledge Panel in branded searches for "Unruled Masses". `WebSite` schema with `SearchAction` can enable a Sitelinks Search Box. Both are high-value branded SERP features. |
| **Fix** | Add to `<head>` on every page via Next.js layout: `Organization` (name, url, logo, description, sameAs links to social profiles, nonprofit status), `WebSite` (name, url). Add `Article`/`NewsArticle` to news article pages (headline, datePublished, author, publisher). |
| **Effort** | 3–5 hours |

### 2.2 Add Article-specific OG images to news pages

| | |
|---|---|
| **What's wrong** | All pages use the same generic OG image (`/images/og-image.png`), including individual news articles. |
| **Why it matters** | When the press release is shared on social media or linked by journalists, a generic image reduces click-through. Article-specific images signal professionalism and increase engagement. |
| **Fix** | Add an `ogImage` field to the Sanity news article schema. Use it in the `<meta og:image>` tag on article pages with the site default as fallback. |
| **Effort** | 2–3 hours |

### 2.3 Investigate and fix Best Practices score (81/100)

| | |
|---|---|
| **What's wrong** | Both audited pages score 81/100 on Lighthouse Best Practices — consistent across homepage and /our-team, suggesting a shared third-party script issue. Likely candidates: console errors from GTM/GA4, use of deprecated browser APIs, or mixed content warnings. |
| **Why it matters** | Best Practices issues indicate code quality problems that can affect user experience and indirectly signal trust to Google. |
| **Fix** | Open Chrome DevTools Console on the live site and document any errors. Cross-reference with GTM tags. The legacy GA3 events (`checkout_progress`, `set_checkout_option`) identified in the analytics audit are a likely source. |
| **Effort** | 2–4 hours to diagnose; fix time depends on root cause |

### 2.4 Submit sitemap and verify Search Console

| | |
|---|---|
| **What's wrong** | Analytics audit found Search Console is not linked to the GA4 property. It's unclear whether Search Console is even set up. |
| **Why it matters** | Without Search Console: Google cannot receive sitemap submissions, crawl errors go unnoticed, and keyword impression data is unavailable. This is the most direct line of communication with Google's crawlers. |
| **Fix** | (1) Set up Google Search Console for `unruledmasses.org` (verify via DNS TXT record via Cloudflare). (2) Generate and submit a sitemap — Next.js can auto-generate via `next-sitemap`. (3) Link Search Console to GA4 (Admin → Product Links → Search Console). (4) Request indexation for core pages. |
| **Effort** | 2–4 hours |

### 2.5 Reduce page weight from ~4.5–4.9 MB

| | |
|---|---|
| **What's wrong** | Both audited pages transfer ~4.5–4.9 MB. For a text-and-image site, this is high. |
| **Why it matters** | Page weight doesn't hurt desktop Lighthouse scores significantly right now, but it will hurt mobile users on slower connections — and Google's ranking signals weight mobile experience heavily. |
| **Fix** | Audit Sanity CDN image URLs to confirm they are using Sanity's image transformation pipeline (`?w=800&auto=format`). Ensure Next.js `<Image>` is used everywhere (auto WebP, lazy loading, correct sizing). Check whether all 21 scripts on the homepage are necessary. |
| **Effort** | 4–8 hours |

### 2.6 Improve server response time on /our-team (966ms TTFB)

| | |
|---|---|
| **What's wrong** | /our-team has a server response time of 966ms vs. 137ms on the homepage. Nearly 1 second before the browser receives any HTML. |
| **Why it matters** | TTFB is a direct input into LCP and overall performance scores. A 1-second TTFB will push the page toward failing CWVs as content grows. |
| **Fix** | Investigate whether /our-team is server-side rendered on request (fetching Sanity data on each request) vs. statically generated at build time. If it's SSR, switch to ISR (Incremental Static Regeneration) with a short revalidation period. Cloudflare also provides edge caching — ensure it's active for this route. |
| **Effort** | 3–6 hours |

---

## Priority 3 — Ongoing

*No single fix; requires process or content investment over time.*

### 3.1 Build and publish playbooks content

| | |
|---|---|
| **What's wrong** | The "Action Playbook" is core to Unruled Masses' value proposition and is mentioned prominently on the homepage — but the pages are 404. |
| **Why it matters** | Playbooks are the most SEO-viable content type on this site. Searches like "how to organize a protest", "poster campaign guide", "contacting elected officials template" have real search volume. Each playbook is a potential landing page for a specific high-intent query. |
| **Fix** | Prioritize deploying the playbooks section. Each playbook should: have a descriptive URL (`/playbooks/[topic]`), 800+ words of original content, a clear H1 and meta description targeting a specific query, and internal links to related playbooks. |
| **Effort** | Ongoing — 1 playbook per sprint |

### 3.2 Consistent news/content publishing

| | |
|---|---|
| **What's wrong** | The site has one news article published January 26, 2026. No content has been added in the 54 days since launch. |
| **Why it matters** | Google rewards sites that publish consistently. Fresh content also provides the raw material for backlinks, social sharing, and AI training data inclusion. A dead news section signals a dormant organization to both crawlers and journalists. |
| **Fix** | Establish a publishing cadence — even 2–4 pieces per month. Prioritize content that: (a) targets specific queries (use Search Console data once live), (b) can earn backlinks from civic/media outlets, and (c) demonstrates the intelligence platform's unique data. |
| **Effort** | Ongoing |

### 3.3 Backlink acquisition strategy

| | |
|---|---|
| **What's wrong** | Zero backlinks. Domain authority is 0. Without backlinks, even well-optimized pages will struggle to rank against established civic organizations. |
| **Why it matters** | Backlinks remain the strongest ranking signal in competitive informational spaces. One link from ProPublica, a university civics program, or a major newspaper is worth more than 100 on-page optimizations. |
| **Fix** | (1) Reach out to journalists who covered the launch and ask for backlinks in their coverage. (2) Submit the site to nonprofit directories (GuideStar, Idealist, GrantWatch). (3) Pitch guest posts or op-eds to civic tech publications. (4) When the intelligence platform launches, issue a press release and pitch it as a story. |
| **Effort** | Ongoing |

### 3.4 Build AI visibility through authoritative content

| | |
|---|---|
| **What's wrong** | No LLM mentions detected. The site does not appear in AI responses to relevant civic queries. |
| **Why it matters** | AI Overviews and chatbot responses are increasingly the first touchpoint for civic research queries. Organizations that appear there will get traffic that never clicks a SERP result. |
| **Fix** | AI visibility follows from content authority and backlinks — there is no shortcut. Prioritize: (1) original data and research from the intelligence platform, (2) landing backlinks from authoritative civic and journalism sources, (3) Wikipedia presence for the organization. |
| **Effort** | Ongoing — 6–12 month horizon |

---

## Summary Table

| # | Issue | Priority | Effort | Impact |
|---|---|---|---|---|
| 1.1 | Fix /playbooks 404s | P1 | Low–Medium | High |
| 1.2 | Add image alt text | P1 | Low | Medium |
| 1.3 | Shorten news article title tag | P1 | Low | Medium |
| 1.4 | Fix empty H2 on /our-team | P1 | Low | Low |
| 1.5 | Fix /news title and meta | P1 | Low | Low |
| 2.1 | Add Organization/Article schema | P2 | Medium | High |
| 2.2 | Article-specific OG images | P2 | Low–Medium | Low |
| 2.3 | Debug Best Practices score (81) | P2 | Medium | Medium |
| 2.4 | Set up Search Console + sitemap | P2 | Low | High |
| 2.5 | Reduce page weight (~4.9 MB) | P2 | Medium | Medium |
| 2.6 | Fix TTFB on /our-team (966ms) | P2 | Medium | Medium |
| 3.1 | Build playbooks content | P3 | High | High |
| 3.2 | Consistent news publishing | P3 | High | High |
| 3.3 | Backlink acquisition | P3 | High | High |
| 3.4 | Build AI visibility | P3 | High | Medium |
