# SEO Remediation Priorities — Outright

**Site:** https://weareoutright.com
**Audit date:** 2026-03-20

---

## Executive Summary

- The site has critical on-page issues (multiple H1s, missing meta descriptions, no structured data) that depress rankings across every page — these are the highest-leverage fixes
- 15 MB page weight on the homepage is a severe performance liability and likely harming mobile Core Web Vitals
- The spam backlink campaign (135 links, 121 domains) needs to be monitored and potentially disavowed
- The site has essentially no content strategy — zero blog posts, guides, or thought leadership content — leaving commercial keywords entirely uncontested by Outright
- AI visibility is zero; building this requires content depth that the site currently lacks
- Google Business Profile optimization is a quick win for DC local agency queries

---

## Priority 1 — Quick Wins
*High impact, low effort — fix first*

---

### 1.1 Fix sitewide H1 bug

**What's wrong:** Every page on the site has multiple H1 tags. The logo or nav element renders as `<h1>outright</h1>`, then each page adds its own H1. The homepage has 9 H1s total, including client brand names (Google/YouTube, Marriott International, etc.) marked as H1s — likely from a homepage marquee or carousel component.

**Why it matters:** Multiple H1s confuse crawlers about the topic of the page. Google uses H1 content as a primary page-topic signal. With 9 competing H1s on the homepage, no single topic registers clearly.

**Recommended fix:** The site logo/nav should use a `<p>`, `<span>`, or `<a>` — not an `<h1>`. Each page should have exactly one H1 that describes the page topic. Client names in carousels/marquees should be `<p>` or `<span>` elements. This is a template-level fix; once corrected, it applies to every page.

**Effort:** 2–4 hours (template change in Next.js layout component)

---

### 1.2 Write a meta description for the homepage

**What's wrong:** The homepage has no meta description. Google generates one automatically from the page text, which on a JS-heavy page often results in truncated or irrelevant snippets.

**Why it matters:** Meta descriptions directly influence click-through rate in search results. A well-written description is the first pitch to a prospect.

**Recommended fix:** Add a 150–160 character meta description to the homepage. Example: "Outright is a DC-based full-service creative agency working at the intersection of mission and brand — helping consumer brands and nonprofits drive lasting change."

**Effort:** 30 minutes

---

### 1.3 Rewrite the homepage title tag

**What's wrong:** "Outright | Home" is 15 characters and contains no keywords. It doesn't describe what the agency does or where it's located.

**Why it matters:** The title tag is the single highest-weight on-page ranking factor. It also appears as the clickable headline in search results.

**Recommended fix:** Aim for 50–60 characters. Example: "Outright — Creative Agency for Mission-Driven Brands | DC"

**Effort:** 30 minutes

---

### 1.4 Add alt text to all images

**What's wrong:** Images across the homepage and case study pages are missing `alt` attributes. This was flagged on both audited pages.

**Why it matters:** Missing alt text fails WCAG 2.1 1.1.1 (Non-text Content), disables image search indexing, and signals low-quality content to crawlers.

**Recommended fix:** Audit all image components in the Next.js codebase and add descriptive alt text. Decorative images should use `alt=""`. Images of client work should describe the work: e.g., `alt="Washington Project for the Arts website homepage redesign by Outright"`.

**Effort:** 4–8 hours (depending on how images are handled in components)

---

### 1.5 Set up Google Business Profile

**What's wrong:** Outright does not appear in the local map pack for "creative agency dc" — which has an active local pack. A Google Business Profile (GBP) is required to appear there.

**Why it matters:** The local pack appears above organic results for DC agency queries. Map pack presence would increase visibility immediately, even with a modest organic ranking.

**Recommended fix:** Create or claim a Google Business Profile for Outright's DC office. Add accurate NAP (name, address, phone), business hours, agency category, and photos of work. Encourage existing clients to leave reviews.

**Effort:** 2–3 hours setup; ongoing review acquisition

---

## Priority 2 — High Impact
*Meaningful improvement, higher effort*

---

### 2.1 Reduce homepage page weight (15 MB → under 3 MB)

**What's wrong:** The homepage weighs 15 MB — 5–10× the recommended budget. This is almost certainly caused by unoptimized video or image assets, likely the Vimeo embed or background video/hero media.

**Why it matters:** Mobile Core Web Vitals (especially LCP) are highly sensitive to page weight. Google uses mobile-first indexing. A 15 MB homepage likely fails LCP on mobile even if it passes on desktop. Performance is also a direct ranking factor.

**Recommended fix:**
- Audit which assets are responsible for the bulk of the weight (Chrome DevTools Network tab)
- Replace any autoplay background video with a poster image + optional user-triggered video
- Compress and convert images to WebP/AVIF
- Lazy-load below-fold images and Vimeo embeds
- Defer non-critical third-party scripts (Facebook pixel, Copper CRM) until after page load
- Consider eliminating render-blocking stylesheets via critical CSS inlining

**Effort:** 1–3 days depending on scope of media changes

---

### 2.2 Fix Lighthouse Best Practices score (currently 52/100)

**What's wrong:** A score of 52/100 is the site's weakest Lighthouse category. Common causes: console errors, deprecated APIs, mixed content, browser errors from third-party scripts.

**Why it matters:** Google uses Best Practices signals as part of overall quality assessment. Console errors can also indicate broken functionality that affects user experience and crawling.

**Recommended fix:**
- Open DevTools Console on the live site and document all JS errors
- There is already one confirmed DOM parse error (line 444, homepage): "The given token cannot be inserted here" — this should be fixed in the source
- Audit GTM tags for any scripts loading via HTTP rather than HTTPS
- Review Vimeo and Facebook embed implementations for deprecation warnings

**Effort:** 4–8 hours investigation + fixes

---

### 2.3 Add schema markup (structured data)

**What's wrong:** No structured data is present on any page.

**Why it matters:** Schema markup enables rich results (breadcrumbs, sitelinks, knowledge panels) and improves how Google understands page content. For an agency, it also increases chances of appearing in AI-generated responses.

**Recommended fix:**
- Add `Organization` schema to the homepage: name, description, logo, address, founding date, social profiles
- Add `LocalBusiness` schema with DC address and service area
- Add `BreadcrumbList` to all case study and interior pages
- Add `CreativeWork` or `WebPage` schema to case study pages with project descriptions

**Effort:** 4–8 hours

---

### 2.4 Resolve the spam backlink campaign

**What's wrong:** 135 backlinks from 121 domains use the anchor "BLACK SEO LINKS, BACKLINKS, MASS BACKLINKING – TELEGRAM @SEO_LINKK". These are nofollow and likely not causing immediate harm, but represent a systematic spam campaign targeting the site.

**Why it matters:** While Google typically ignores nofollow spam, a concentrated pattern of spam links pointing at the site may eventually trigger a manual review or algorithmic penalty, especially if the volume grows.

**Recommended fix:**
- Export all linking domains with spam score ≥ 50
- Create a Google Search Console disavow file for the worst offenders (spam score ≥ 60, clearly spammy domains)
- Monitor quarterly — if the campaign grows, escalate the disavow
- Do not disavow the "BLACK SEO LINKS" anchors proactively yet since they are all nofollow; revisit if the count increases significantly

**Effort:** 2–4 hours to build and submit the disavow file

---

### 2.5 Consolidate or redirect the Up Partnership subdomain

**What's wrong:** `up.weareoutright.com` is a separate subdomain with its own rankings ("up partnership" at rank 13, sv 1,000). This authority does not flow back to the main domain.

**Why it matters:** If the Up Partnership project was a client site, it should ideally live on the client's own domain. If it's meant to be an Outright showcase, it would deliver more SEO value as a subdirectory (`weareoutright.com/work/up-partnership/`) than a subdomain. Subdomains are treated as separate sites by Google.

**Recommended fix:** Evaluate whether up.weareoutright.com is still active or maintained. If it's a portfolio/case study, migrate content to a page on the main domain and 301-redirect the subdomain. This would consolidate the authority and keyword rankings into the main domain.

**Effort:** 1 day (depending on content complexity)

---

### 2.6 Strengthen on-page targeting for DC agency keywords

**What's wrong:** The homepage ranks positions 8–82 for commercial DC agency terms ("creative agency dc", "web design dc", "marketing company washington dc"). The homepage copy is thin (192 words) and doesn't clearly signal DC-based agency services.

**Why it matters:** These keywords have real commercial intent and are the queries that bring in new business. Moving from position 8 to position 2–3 for "creative agency dc" (320 sv) would meaningfully increase qualified traffic.

**Recommended fix:**
- Add a clear, crawlable text section to the homepage that explicitly mentions DC, branding, design, and the types of clients served (mission-driven, nonprofits, consumer brands)
- The visible text should include variations of target keywords naturally — not keyword stuffing, but genuine descriptive copy
- Improve internal linking: case study pages should link back to the homepage with relevant anchor text

**Effort:** 4–8 hours (copywriting + dev implementation)

---

## Priority 3 — Ongoing
*Process or content recommendations; no single fix*

---

### 3.1 Build a content strategy targeting commercial and informational keywords

**What's wrong:** The site has no blog, resource section, or long-form content. Zero of Outright's 24 ranked keywords come from thought leadership content. Competitors like designindc.com and taoti.com rank for hundreds of keywords via service pages and articles.

**Why it matters:** Content is the primary vehicle for capturing organic search demand outside of branded queries. Without it, the site is invisible for any query that doesn't already know the Outright name. It also blocks AI visibility — LLMs cite substantive content, not portfolio pages.

**Recommended fix:**
- Identify 10–15 high-value informational and commercial keywords relevant to Outright's positioning (e.g., "nonprofit branding agency", "mission-driven marketing", "social impact brand strategy", "rebranding nonprofit case study")
- Create a content hub — either a blog or a "Perspectives" / "Resources" section
- Publish 1–2 long-form pieces per month minimum; prioritize case study depth (existing work pages are too thin to rank for competitive queries)
- Consider POV pieces that can be cited by AI models: "How we rebranded the Me Too movement", "What mission-driven design looks like in practice"

**Effort:** Ongoing; initial content strategy: 1 week; each piece: 4–8 hours

---

### 3.2 Earn editorial backlinks from the nonprofit sector

**What's wrong:** The backlink profile has very few high-authority referring domains. The best current links come from NIRH and Washington Project for the Arts (both clients). There are no .edu or .gov links despite the nonprofit client base.

**Why it matters:** Authority is a prerequisite for ranking competitively for agency terms. Outright's domain rank of 263 is below the threshold needed to consistently compete for high-value commercial keywords.

**Recommended fix:**
- Reach out to clients to ensure they link to Outright's site (portfolio/case study attribution)
- Submit case studies to nonprofit communications and design publications (e.g., SSIR, Fast Company, Webby awards)
- Participate in DC-area business and nonprofit networks with web presence (AIGA DC, Cause Communications, etc.)
- Guest post or contribute to nonprofit marketing blogs — these often have .org authority and relevant audiences

**Effort:** Ongoing; 2–4 hours/month

---

### 3.3 Improve AI visibility

**What's wrong:** Outright has zero citations in ChatGPT responses for any relevant queries.

**Why it matters:** A growing share of B2B service discovery is happening via AI assistants. Agencies that are cited in AI responses for "best nonprofit branding agency" or "creative agency for social impact" will gain leads from this channel.

**Recommended fix:**
- AI citation follows content authority: publish case studies with sufficient depth that an LLM would cite them
- Use clear, quotable language in case study introductions: "Outright is a DC-based creative agency specializing in brand strategy for nonprofits and mission-driven organizations"
- Pursue mentions in established publications that AI models index heavily (Fast Company, Ad Age, campaign coverage in nonprofit press)
- Structured data (Priority 2.3) increases the structured signals AI engines can extract

**Effort:** Ongoing; tied to content strategy (3.1)

---

### 3.4 Fix broken pages with inbound links

**What's wrong:** 2 pages with inbound links return errors (identified in the backlinks summary). Specific URLs not confirmed in this audit.

**Why it matters:** Broken pages with backlinks waste link equity. If the pages previously ranked, they represent lost traffic.

**Recommended fix:**
- Run a full crawl (Screaming Frog or Sitebulb) to identify all 404s
- Cross-reference with backlink data in Google Search Console
- Either restore the content or 301-redirect to the most relevant live page

**Effort:** 2–4 hours

---

## Summary Checklist

| # | Item | Priority | Effort | Owner |
|---|---|---|---|---|
| 1.1 | Fix sitewide H1 bug | P1 | 2–4 hrs | Dev |
| 1.2 | Add homepage meta description | P1 | 30 min | Content |
| 1.3 | Rewrite homepage title tag | P1 | 30 min | Content |
| 1.4 | Add alt text to all images | P1 | 4–8 hrs | Dev |
| 1.5 | Set up Google Business Profile | P1 | 2–3 hrs | Marketing |
| 2.1 | Reduce page weight (15 MB) | P2 | 1–3 days | Dev |
| 2.2 | Fix Lighthouse Best Practices (52/100) | P2 | 4–8 hrs | Dev |
| 2.3 | Add schema markup | P2 | 4–8 hrs | Dev |
| 2.4 | Disavow spam backlinks | P2 | 2–4 hrs | SEO |
| 2.5 | Consolidate Up Partnership subdomain | P2 | 1 day | Dev |
| 2.6 | Strengthen DC keyword targeting on homepage | P2 | 4–8 hrs | Content + Dev |
| 3.1 | Build content strategy | P3 | Ongoing | Content |
| 3.2 | Earn nonprofit editorial backlinks | P3 | Ongoing | Marketing |
| 3.3 | Improve AI visibility | P3 | Ongoing | Content |
| 3.4 | Fix broken pages with inbound links | P3 | 2–4 hrs | Dev |
