# Noble Reach — Pre-Redesign SEO Benchmark

Tooling setup for generating a comprehensive SEO baseline before a full website redesign and rebuild.

## Purpose

Capture the current state of the website so we can:
- **Preserve strengths** — rankings, backlinks, SERP features, content that drives traffic
- **Identify weaknesses** — technical issues, content gaps, missed structured data opportunities
- **Build a risk register** — URL redirect map, backlinked pages, and anything that could break during the rebuild

## Tools

### 1. DataForSEO MCP Server

Provides real SERP data, keyword volumes, backlink profiles, and competitive intelligence via pay-as-you-go API.

**Setup:**
```bash
claude mcp add dfs-mcp \
  --env DATAFORSEO_USERNAME=<username> \
  --env DATAFORSEO_PASSWORD=<password> \
  -- npx -y dataforseo-mcp-server
```

**What we use it for:**
- Keyword ranking inventory (every keyword the site ranks for)
- Backlink profile snapshot (referring domains, anchor text, target pages)
- Competitor keyword gap analysis
- SERP feature ownership (featured snippets, knowledge panels, etc.)
- AI search mention tracking (ChatGPT, Claude, Perplexity visibility)

**Pricing:** $50 minimum deposit, pay-as-you-go. A full domain audit typically runs $1-5. Credits never expire.

### 2. claude-seo Skill

The [AgriciDaniel/claude-seo](https://github.com/AgriciDaniel/claude-seo) skill handles technical SEO auditing with script-backed evidence collection.

**Setup:**
```bash
claude skill add --url https://github.com/AgriciDaniel/claude-seo
```

**What we use it for:**
- Core Web Vitals (LCP, INP, CLS via PageSpeed Insights API)
- Schema/structured data inventory and validation
- Security headers audit
- Broken link detection
- Internal link structure analysis
- robots.txt and sitemap validation
- AI crawler access auditing (GPTBot, ClaudeBot, etc.)
- E-E-A-T assessment

### 3. Google Search Console (optional but recommended)

Ground truth for impressions, clicks, and indexed pages. The claude-seo skill includes a GSC integration script if credentials are available.

## Benchmark Reports

### Report 1: Technical Baseline
Core Web Vitals scores, schema inventory, security headers, crawl health, internal link structure, broken links, mobile readiness.

### Report 2: Strategic Baseline
Current keyword rankings, traffic-driving pages (top 50), backlink profile, referring domain count, competitor keyword gaps, SERP feature ownership.

### Report 3: Redesign Risk Register
The most critical deliverable — a checklist for the dev team:
- **URL redirect map** — every ranked/backlinked URL that must redirect in the new site
- **Backlinked pages** — pages with external links that must persist or redirect
- **SERP features at risk** — featured snippets, rich results that depend on current markup
- **Content to preserve** — pages driving organic traffic that must carry over
- **Schema to maintain** — structured data currently earning rich results
- **Internal link equity** — high-authority pages and their link relationships
