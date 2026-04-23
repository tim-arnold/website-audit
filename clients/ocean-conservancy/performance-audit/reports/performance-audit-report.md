# Performance Audit — Ocean Conservancy

**Date:** February 2026
**URL:** https://oceanconservancy.org
**Prepared by:** Outright

---

## Executive Summary

The Ocean Conservancy website has strong server-side infrastructure — Pantheon Global CDN, Cloudflare, and Redis object caching — resulting in fast real-world load times for most visitors. However, the site scores 32/100 on PageSpeed Insights (mobile), below the WordPress median of 41, primarily due to excessive JavaScript, render-blocking resources, and no frontend optimization layer.

The good news: the server side is already well-configured. The improvements needed are almost entirely on the frontend delivery side — how CSS, JavaScript, and images are served — and most are directly addressable.

Our goal is to reach a Performance score of 55–65, placing the site well above the WordPress median and among the top performers in the conservation sector.

---

## Understanding the Numbers

### Field Data vs. Lab Data

**Field data** (shown in the top section of each PageSpeed report) reflects real Chrome users visiting the actual site over the past 28 days. It is stable, averaged across thousands of visits, and the most meaningful signal for understanding real-world user experience. This is what Google uses to assess Core Web Vitals.

**Lab data** (shown in the lower section, and what drives the overall Performance score) simulates a first-time visitor on a mid-range phone over a slow 4G connection with no cached assets. It is a worst-case stress test, not an average experience. Lab scores can vary by 5–10 points between runs due to server response variance, CDN cache state at the moment of the test, and third-party script timing. Treat scores as directional ranges rather than precise measurements.

### Core Web Vitals Definitions

| Metric | What It Measures | Good | Poor |
|---|---|---|---|
| LCP (Largest Contentful Paint) | How long until the largest visible element finishes loading — what users perceive as "the page has loaded" | < 2.5s | > 4s |
| INP (Interaction to Next Paint) | How quickly the page responds to a click, tap, or keypress. High INP means the page feels sluggish. Replaced FID as a Core Web Vital in 2024. | < 200ms | > 500ms |
| CLS (Cumulative Layout Shift) | Unexpected movement of page elements during load. All pages tested score 0 — not a concern for this site. | < 0.1 | > 0.25 |
| FCP (First Contentful Paint) | How long until the browser renders the first piece of content. Lab metric contributing to the Performance score, not a Core Web Vital. | < 1.8s | > 3s |
| TBT (Total Blocking Time) | Total duration the main thread is blocked by JavaScript. Lab-only metric; the primary driver of low scores on this site. Closely correlated with INP in the field. | < 200ms | > 600ms |
| TTFB (Time to First Byte) | Server and CDN response time. All pages on this site show good TTFB. | < 0.8s | > 1.8s |
| Performance Score | Weighted combination of lab metrics (0–100). Useful summary but not to be interpreted too literally — a 5–10 point swing between runs on the same page is normal. WordPress mobile median is 41. | 90+ | < 50 |

---

## A Note on Score Expectations

A score of 32 is below the WordPress median but not an outlier in the conservation sector. Our target of 55–65 would place Ocean Conservancy at the top of this peer group.

| Organization | CMS | Mobile Score |
|---|---|---|
| World Wildlife Fund | ZMS | 61 |
| Surfrider | HubSpot CMS | 51 |
| Conservation International | Miro / Sanity (headless) | 46 |
| The Nature Conservancy | Adobe Experience Manager | 40 |
| **Ocean Conservancy (current)** | **WordPress** | **32** |
| Oceana | WordPress | 29 |

*Scores via PageSpeed Insights, February 2026. WordPress mobile median is 41 (HTTP Archive 2025 Web Almanac). Only Oceana is also on WordPress — the other high-performing sites are on non-WordPress platforms, which contributes to their higher scores.*

**Why WordPress mobile scores are inherently low:**
- Third-party scripts we can't eliminate (GTM, reCAPTCHA, New Relic, OptinMonster) carry a baseline cost of ~300–500ms of blocking time
- WordPress core ships jQuery and other scripts that add weight
- The Lighthouse mobile test simulates a mid-range phone on slow 4G — even well-optimized sites score 20–30 points lower on mobile than desktop
- Plugin updates can regress performance at any time
- Content-rich sites with animation libraries (GSAP), UI frameworks (UIkit), and carousels (Swiper) face a heavier baseline than minimal marketing sites

**Realistic targets:**
- **55–65** is the goal after all four phases (top-tier for a WordPress site of this complexity)
- **50** is a strong interim milestone achievable through Phases 1–2
- **65+** would require removing animation libraries, replacing UIkit, or eliminating third-party scripts — changes that may not be acceptable tradeoffs

It is important to set honest expectations: performance improvements are hard to predict precisely. Some changes may affect existing functionality and require testing or reversion. If we fall short of 55–65 after Phases 1–3, a design conversation about specific patterns (see "Homepage: Design Patterns to Watch") will be needed.

---

## Pages Under Review

Using Google Analytics data from November 2025 – February 2026, we identified the twenty most common entry pages — where sessions begin. These represent the majority of first impressions and are the highest-impact targets.

### Top 5 Entry Pages

| Page | Sessions | Current Score | Target | Notes |
|---|---|---|---|---|
| / (Homepage) | ~9.2% of sessions | 32 | 55–65 | Primary focus |
| /blog/2021/06/07/10-moving-quotes-ocean/ | 7,652 (3.4%) | 33 | 55–65 | Organic search driven |
| /our-people/career-opportunities/ | 6,058 (2.7%) | 28 | 50–60 | Lowest engagement time (14s); links to external job site |
| /give-support/take-action/ | 4,480 (2.0%) | 30 | 55–65 | Conversion-critical; Gravity Form present |
| /blog/2018/12/10/7-wild-facts-may-not-know-seahorses/ | 3,157 (1.4%) | 33 | 55–65 | Highest avg engagement time (1m 26s); LCP outlier |

*Scores are PageSpeed Insights mobile. Target reflects expected outcome after all four phases of work.*

---

## Homepage: Baseline Metrics

**Page:** oceanconservancy.org/

| Metric | Current | Rating | Target | Notes |
|---|---|---|---|---|
| **Performance Score** | **32 / 100** | Poor | **55–65** | WordPress median is 41 |
| **Core Web Vitals — Field Data (Real Users, 28-day, Mobile)** | | | | |
| LCP (Largest Contentful Paint) | 1.8s | Good | < 2.5s | Fast for real users |
| INP (Interaction to Next Paint) | 419ms | Needs Improvement | < 200ms | Primary UX concern |
| CLS (Cumulative Layout Shift) | 0 | Good | < 0.1 | No layout instability |
| FCP (First Contentful Paint) | 1.5s | Good | < 1.8s | |
| TTFB (Time to First Byte) | 0.5s | Good | < 0.8s | Server infra is solid |
| **Lab Metrics — Simulated Slow Mobile (Worst-Case Scenario)** | | | | |
| Performance Score | 32 / 100 | Poor | 55–65 | Drives overall score |
| LCP | 26.7s | Poor | 8–12s | After all 4 phases |
| TBT (Total Blocking Time) | 1,130ms | Poor | 350–500ms | JS blocking main thread |
| FCP | 15.5s | Poor | 4–7s | |

Field data reflects real Chrome users and looks healthy because most visitors are on fast connections with CDN-cached assets. Lab data simulates a first-time visitor on slow 4G — this is what drives the score.

**What is driving the low score:**
- No frontend optimization layer — no CSS/JS minification, no lazy loading, no critical CSS, no image format conversion
- Heavy JavaScript loading on every page — UIkit, Swiper, GSAP animations, reCAPTCHA, OptinMonster, and New Relic all load regardless of whether the page needs them
- Images served as uploaded — no WebP/AVIF conversion, no lazy loading
- Render-blocking CSS — full UIkit framework stylesheet loads on every page

The 419ms INP is the most significant real-user issue. It means the page can be unresponsive to clicks and taps for nearly half a second — noticeable to users and a Core Web Vitals failure. Reducing JavaScript blocking time is the primary lever for improving this.

---

## Additional Entry Pages: Baselines

The four pages below were tested individually. Many of the same JS and CSS issues apply site-wide, but each page has its own profile depending on which blocks, sliders, or forms are present.

### 2. Ocean Quotes Blog Post — `/blog/2021/06/07/10-moving-quotes-ocean/`

7,652 sessions (3.4%), likely driven almost entirely by organic search. Blog post templates are lighter than the homepage — fewer sliders, less animation — reflected in a better INP (164ms vs. 419ms). However, GSAP and Swiper load unconditionally on every page, contributing to TBT of 1,030ms. Phase 3 conditional loading will benefit this page directly.

| Metric | Value |
|---|---|
| Performance Score | 33 |
| LCP | 20.2s |
| INP | 164ms |
| TBT | 1,030ms |
| FCP | 15.3s |

### 3. Career Opportunities — `/our-people/career-opportunities/`

6,058 sessions (2.7%), lowest-scoring of the five at 28. Highest TBT of the group at 1,700ms — over 50% above the homepage. GA4 shows the lowest average engagement time at 14 seconds; this is likely partly explained by the page linking off to an external site for actual job listings, not just performance friction.

| Metric | Value |
|---|---|
| Performance Score | 28 |
| LCP | 19.2s |
| INP | 152ms |
| TBT | 1,700ms |
| FCP | 14.3s |

### 4. Take Action — `/give-support/take-action/`

4,480 sessions (2.0%), the most conversion-critical page. Includes a Gravity Form, so reCAPTCHA is justified here — but the 392ms INP is nearly as high as the homepage, meaning users may experience a delay when interacting with the form. Performance friction on a take-action page directly affects advocacy and donation conversion rates.

| Metric | Value |
|---|---|
| Performance Score | 30 |
| LCP | 19.5s |
| INP | 392ms |
| TBT | 1,380ms |
| FCP | 14.7s |

### 5. Seahorse Facts Blog Post — `/blog/2018/12/10/7-wild-facts-may-not-know-seahorses/`

3,157 sessions (1.4%). Despite its age, GA4 shows the highest average engagement time of the five pages — 1 minute 26 seconds. Zero key events recorded, suggesting an opportunity to add a relevant call-to-action.

| Metric | Value |
|---|---|
| Performance Score | 33 |
| LCP | **39.7s** |
| INP | 135ms |
| TBT | 1,060ms |
| FCP | 15.3s |

> **⚠ LCP outlier:** 39.7s is significantly higher than any other page tested — nearly 50% worse than the homepage (26.7s). This strongly suggests a large, unoptimized hero or featured image specific to this page. Manually inspect before starting Phase 2 image work to confirm.

---

## Extended Baseline: Pages 6–20

The 15 pages below represent the next tier by session volume (November 2025 – February 2026). Two pages from the GA4 top 20 were excluded: the site search page (/search), which is dynamically generated, and the donation page (/page/177540/donate/1), which is hosted on Engaging Networks.

**Note on score variability:** PageSpeed Insights lab scores can vary 5–10 points between runs on the same page — normal due to server response time, CDN cache state, and third-party script activity. Scores are directional snapshots. Field data changes will be the most reliable signal for measuring optimization impact.

| Page | Score | LCP | INP | TBT | FCP |
|---|---|---|---|---|---|
| /work/plastics/cleanups-icc/ | 32 | 19.2s | 164ms | 1,130ms | 16.2s |
| /blog/2023/11/08/oarfish-known-doomsday-fish/ | 28 | 18.5s | 88ms | 1,710ms | 14.6s |
| /work/plastics/ | 27 | 17.2s | 164ms | **2,180ms** | 13.9s |
| /blog/2023/08/03/do-jellyfish-have-brains/ | 37 | 15.9s | 340ms | 770ms | 14.0s |
| /blog/2022/09/09/ocean-puns-you-need-in-your-life/ | 30 | 15.3s | N/A | 1,440ms | 13.1s |
| /blog/2024/01/12/caution-killer-cone-snails/ | 30 | 15.5s | 164ms | 1,340ms | 12.8s |
| /blog/2021/12/29/7-longest-living-ocean-animals/ | 28 | 18.4s | N/A | 1,750ms | 13.4s |
| /work/plastics/cleanups-icc/annual-data-release/ | 38 | **6.9s** | 164ms | 1,190ms | **6.2s** |
| /wildlife-library/sea-scallop/ | 28 | 15.9s | 164ms | 1,810ms | 11.3s |
| /blog/2020/05/19/11-facts-horseshoe-crabs-will-blow-mind/ | 27 | **38.8s** | N/A | **2,030ms** | 13.3s |
| /blog/2019/03/08/exactly-narwhal-tusk/ | 40 | 12.5s | 164ms | 800ms | 5.6s |
| /blog/2019/03/13/orca-not-whale/ | 35 | 21.7s | N/A | 910ms | 13.0s |
| /newsroom/press-release/2025/11/17/ocean-animals-ingested-plastics-study/ | 28 | 18.6s | 164ms | 1,740ms | 14.0s |
| /blog/2020/01/22/stonefish/ | 31 | 21.8s | 164ms | 1,230ms | 16.3s |
| /blog/2024/02/08/all-about-goblin-sharks/ | 32 | 15.3s | N/A | 1,130ms | 13.3s |

*INP shown as N/A where insufficient real-user data exists in the 28-day CrUX window — not a performance concern. All scores are PageSpeed Insights mobile, captured February 20, 2026.*

**Key observations:**
- **Scores cluster tightly between 27–38** for 13 of 15 pages, confirming the same systemic issues — not page-specific content — drive poor scores across the site
- **Annual data release page is a useful benchmark:** LCP of 6.9s and FCP of 6.2s — far better than any other page. This content-light page shows what the infrastructure is capable of when content is lean, and is a reference point for what Phase 3 conditional loading is targeting
- **/work/plastics/ has TBT of 2,180ms** — the highest in the dataset. Likely loads additional embedded media or heavier blocks
- **Three additional LCP outliers:** horseshoe crabs (38.8s), stonefish (21.8s), orca (21.7s). Same pattern as the seahorse page — large unoptimized hero or featured images

> **⚠ LCP outliers requiring manual image inspection before Phase 2:** Seahorse (39.7s), horseshoe crabs (38.8s), stonefish (21.8s), orca (21.7s). Manually inspect these four pages to confirm the cause and prioritize which images to address first.

---

## What's Working Well

1. **Pantheon Global CDN + Cloudflare** — Two-layer edge caching delivers fast TTFB (0.5s)
2. **Redis object caching** — Object Cache Pro with zstd compression and igbinary serialization handles database queries efficiently
3. **Smart cache purging** — Pantheon Advanced Page Cache uses surrogate keys for targeted invalidation
4. **Zero layout shift** — CLS of 0 across all pages tested indicates stable visual layout
5. **Cache-busting via `filemtime()`** — Ensures fresh assets after deploys without breaking cache

---

## What Could Be Improved: The Missing Optimization Layer

The site currently has no frontend optimization, meaning:
- No CSS minification or combination
- No JS minification, deferral, or delayed loading
- No critical CSS extraction
- No image lazy loading
- No WebP/AVIF image conversion
- No unused CSS removal
- No resource hint injection

The raw, unoptimized HTML/CSS/JS output of the theme is being served directly through the CDN. This is a potentially significant factor in the low Performance score. That said, it is also one that can be quite tricky to address in a WordPress website.

---

## Key Issues & Opportunities

### 1. No Frontend Optimization Plugin (Highest Priority)

**Problem:** No optimization layer handling CSS/JS minification, deferral, lazy loading, or critical CSS. Note: this could pay off well, but can just as easily result in only a slight change in performance while introducing risks and additional workflow steps for content editors.

**Recommendation:** Install and configure a Pantheon-compatible optimization plugin. Plugin selection is constrained by **Pantheon's read-only filesystem** — only `wp-content/uploads/` is writable at runtime. Many optimization plugins assume they can write cache files outside `/uploads/` and will fail silently on Pantheon.

**Options:**

| Plugin | Cost | Pantheon Compatibility | Notes |
|---|---|---|---|
| WP Rocket | $59/yr | Requires workaround | Writes to `wp-rocket-config/` and `cache/wp-rocket/` — not writable by default; symlink to `/uploads/` needed |
| Autoptimize | Free | Requires config | Can be reconfigured to use `/uploads/` via `AUTOPTIMIZE_CACHE_CHILD_DIR` constant |
| Perfmatters | $24.95/yr | Good | Database-driven; handles script management, lazy loading, preloading, DNS prefetch — but does not do CSS/JS minification |

**Pantheon-native alternative:** Implement optimizations directly in theme code (see Phases 1 and 3). Higher development effort but full control with no plugin compatibility concerns.

**What a plugin gives us:** CSS async loading, JS deferral, lazy loading, resource hints, critical CSS
**What no plugin will fix:** Conditional loading of specific third-party scripts, image format conversion, font subsetting

**Estimated impact:** 10–25 point improvement in Performance score from plugin configuration alone

---

### 2. Excessive JavaScript / Main Thread Blocking (High Impact)

**Problem:** Heavy JS payloads block the main thread — contributing to the 419ms INP and 1,130ms TBT. Loading on every page:
- UIkit JS (v3.21.11) — full UI framework
- Swiper bundle — 8+ slider instances registered
- GSAP animation suite — 4 CDN files (core, ScrollTrigger, CustomEase, SplitText) + custom app.js
- Google reCAPTCHA Enterprise — loaded globally, not just on form pages
- OptinMonster — popup script
- New Relic RUM — real-user monitoring, in the critical path
- jQuery + jQuery Migrate — WordPress defaults

**What we can directly change (theme code):**
- Add `defer` attribute to UIkit, Swiper, GSAP, and theme script enqueues — Low effort, high impact
- Conditionally enqueue Swiper JS only on pages with slider blocks — Medium effort, high impact
- Conditionally enqueue GSAP only on pages with animated blocks — Medium effort, high impact
- Wrap reCAPTCHA to only load on pages with Gravity Forms — Medium effort, medium impact

**What we have limited control over:**
- **OptinMonster** — script loading managed by the plugin; JS delay feature may work but aggressive delays can break popup triggers
- **New Relic RUM** — often injected at the Pantheon platform level; moving to async may require Pantheon support
- **GTM** — controllable if in theme, limited if via plugin
- **jQuery Migrate** — removable via `wp_dequeue_script` but may break plugins; requires testing

**Estimated impact:** 1–3s improvement in TBT; significant INP improvement

---

### 3. Image Optimization (High Impact)

**Problem:** No image optimization pipeline. Images are served as uploaded (JPG/PNG) with no format conversion and no lazy loading. The four LCP outlier pages (seahorse 39.7s, horseshoe crabs 38.8s, stonefish 21.8s, orca 21.7s) are almost certainly caused by large unoptimized hero images.

**What we can directly change (theme code):**
- Add `loading="lazy"` to below-the-fold images in block templates — Low effort
- Add explicit `width` and `height` attributes — Low effort
- Preload the LCP hero image with `<link rel="preload">` — Low effort
- Convert hero sections from CSS `background-image` to `<picture>` elements — Medium effort, requires design review

**What requires a plugin or service:**
- **WebP/AVIF conversion** — Plugins (ShortPixel, Imagify, EWWW) write to `wp-content/uploads/` which is writable on Pantheon — these should work. Storage note: converted files can increase media storage 2–3x; ShortPixel's CDN delivery option avoids this.
- **Cloudflare Polish + WebP** — Available on CF Pro plan ($20/mo); handles conversion at the CDN edge with no WordPress plugin, no storage impact, no filesystem constraints. Cleanest option if Cloudflare is already on a paid plan.

**Estimated impact:** 20–40% reduction in image transfer size; faster LCP on slower connections; direct fix for the LCP outlier pages

---

### 4. Render-Blocking CSS (High Impact)

**Problem:** Multiple CSS files load synchronously in `<head>`, blocking first paint — including the full UIkit framework, Swiper CSS, and all block-specific stylesheets, even on pages that don't use those blocks.

**What we can directly change (theme code):**
- Conditionally enqueue block-specific CSS only when those blocks are present — Medium effort, high impact
- Conditionally enqueue Swiper CSS only on pages with sliders — Medium effort

**What requires a plugin:**
- Critical CSS extraction — WP Rocket handles automatically; Autoptimize via add-on; doing manually is high effort and brittle
- CSS async loading — An optimization plugin handles this more reliably across all enqueued styles
- CSS minification — Straightforward via plugin

**Estimated impact:** 0.5–1.5s improvement in FCP/LCP in lab tests

---

### 5. Font Loading Strategy (Medium Impact)

**Problem:** 8 font files (6 Geologica weights + 2 Inter weights) loaded via `@font-face` with `font-display: fallback`, triggering a 3-second block period before fallback text is shown.

**What we can directly change (theme code):**
- Switch to `font-display: swap` — Low effort (requires client sign-off — see Tradeoffs)
- Preload the 1–2 critical font weights used above the fold — Low effort
- Reduce font weights if design permits (e.g., 6 Geologica weights → 3) — Low effort, requires design approval
- Switch to variable fonts — Medium effort, requires font licensing check

**Estimated impact:** 200–500ms improvement in text rendering; smaller total transfer

---

### 6. Missing Resource Hints (Medium Impact)

**Problem:** No `dns-prefetch`, `preconnect`, or `prefetch` directives for third-party origins.

**Fix (theme code, via `wp_head` hook):**
```html
<link rel="preconnect" href="https://www.googletagmanager.com" crossorigin>
<link rel="preconnect" href="https://www.google.com" crossorigin>
<link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
<link rel="dns-prefetch" href="https://bam.nr-data.net">
```

**Estimated impact:** 100–300ms per third-party connection on first visit

---

### 7. Third-Party Script Governance (Medium Impact)

| Script | Purpose | Load Behavior | Our Control |
|---|---|---|---|
| Google reCAPTCHA Enterprise | Bot protection | Sync, every page | Partial |
| Google Tag Manager | Analytics | Async | Partial — depends on implementation |
| New Relic RUM | Monitoring | Sync, blocking | Low — platform-managed |
| OptinMonster | Popups | Async, footer | Low — plugin-managed |

**Estimated impact:** 500ms–1s TBT reduction on non-form pages

---

### 8. Best Practices Score (54)

Likely driven by browser console errors from JS conflicts, missing security headers, and deprecated APIs from legacy scripts.

**What we can directly change:**
- Audit and fix browser console errors in theme JS — Medium effort
- Add security headers via `pantheon.yml` — Low–Medium effort

---

## Homepage: Design Patterns to Watch

The four phases of technical work will deliver meaningful improvement across all pages. For the homepage specifically, it contains several design patterns that work against performance in ways that code changes alone may not fully resolve.

We will complete all technical optimizations first and measure the result. If scores reach the 55–65 target range, no further conversation is needed. If we fall short — particularly on the homepage — the patterns below are likely why. This section is here so that conversation, if it happens, is grounded in specifics.

### 1. Autoplay Background Video Above the Fold

The hero section loads an MP4 (`OC-WaveGradient-Compressed.mp4`) as a background video, plus a full 1920×1018px JPG fallback image that loads unconditionally — even when the video plays. Autoplay background video is one of the heaviest above-the-fold patterns possible.

**What we can do in code:** Serve the video only on desktop using a media query or JavaScript; replace with an optimized static image on mobile. Compress and properly size the fallback JPG. These are Phase 2–3 changes.

**What may require a design conversation:** If the video remains the hero on desktop, it will continue to carry a performance cost that offsets gains elsewhere. A static image hero would substantially improve LCP.

### 2. Spotlight Carousel Loading All Images Upfront

The Spotlight carousel contains 4 slides, but Swiper duplicates them in the DOM for looping — resulting in **8 images** present in the HTML. None appear to have lazy loading. On page load, all 8 download immediately.

**What we can do in code:** Add lazy loading to non-visible carousel slides and configure Swiper to load slides on demand. Achievable in Phase 3.

**What may require a design conversation:** Carousels are inherently expensive on page load. A static featured story with a "see more" link is a high-performance alternative.

### 3. Second Background Video Mid-Page

A second MP4 (`fishes.mp4`) plays in the corporate support section. It is below the fold and does not directly affect LCP, but contributes to total page weight.

**What we can do in code:** Defer loading using Intersection Observer until it nears the viewport. Phase 3 change.

**What may require a design conversation:** Replacing with a static image would remove the cost entirely if scores remain short of target.

### 4. High Image Volume with No Responsive Sizing

A full inspection of the homepage reveals approximately **40 images** and 2 background videos loading on every visit, with no lazy loading in the current source. This includes: Our Work section (6 images), News section (3 photos at 1024px wide), Get Involved section (4 images), and corporate partners carousel (19 logos). Most are served at desktop dimensions with no `srcset` attributes for mobile.

**What we can do in code:** Lazy loading (Phase 1), WebP/AVIF conversion (Phase 2), proper `srcset` responsive sizing (Phase 3). These will significantly reduce download burden.

**What may require a design conversation:** The total number of image-heavy sections is high for a homepage. If scores are still lower than desired after Phase 2–3, consolidating carousels or reducing image-heavy sections may be the most direct path to further improvement.

---

## Tradeoffs & Risks

Every performance optimization involves a tradeoff. Review these before greenlighting any phase of work.

### An additional caching layer
Installing an optimization plugin adds a fourth cache layer on top of Cloudflare, Pantheon CDN, and WordPress. Editors may occasionally need to clear an additional cache after publishing. Most plugins handle this automatically, but edge cases (menu changes, global elements) often require manual purges. **The editorial team should be briefed.**

### JS deferral may cause brief animation delays
Deferring JavaScript — the single biggest lever for score improvement — means GSAP-powered animations may briefly show unstyled content, and interactive elements (sliders, popups) may take a moment longer to become active. Each deferred script needs individual testing before going live.

### Font swap causes a brief text flash
Switching to `font-display: swap` means users on slow connections will briefly see system fonts (Arial, Helvetica) before custom fonts load. **Client decision needed:** is a brief font flash acceptable in exchange for faster perceived load time?

### Image compression changes quality slightly
WebP/AVIF conversion at 80–85% quality is imperceptible in most cases, but images with text overlays, sharp edges, or gradients may show subtle differences. A review process should be built in for photography-heavy campaign pages.

### Conditional script loading requires ongoing maintenance
Loading Swiper/GSAP/reCAPTCHA only on pages that need them is efficient, but new pages that use these features must be accounted for. WordPress block detection handles this automatically in most cases, but edge cases exist.

---

## Prioritized Implementation Roadmap

Phases 1 and 2 apply site-wide and will improve scores across all 20 entry pages. Phase 3 conditional loading has the greatest benefit for blog posts and interior pages, where unnecessary scripts are a larger share of total load.

### Phase 1 — Quick Wins (1–2 weeks)
*Expected: 32 → 38–45*

All directly achievable via theme code changes.

| Task | Effort | Impact |
|---|---|---|
| Defer JS loading (UIkit, Swiper, GSAP, theme scripts) | Low | High |
| Add/validate lazy loading on below-fold images | Low | Medium |
| Add resource hints (preconnect, dns-prefetch) | Low | Medium |
| Preload LCP hero image | Low | Medium |
| Switch `font-display` to `swap` (with client sign-off) | Low | Low–Med |

### Phase 2 — Optimization Plugin + Images (2–4 weeks)
*Expected: 38–45 → 45–55*

Requires plugin selection, installation, configuration, and thorough QA. The optimization plugin may conflict with theme scripts and will need careful testing.

| Task | Effort | Impact |
|---|---|---|
| Install & configure optimization plugin (WP Rocket or Autoptimize) | Medium | High |
| Enable CSS minification + async loading | Low | High |
| Enable critical CSS generation | Low–Med | High |
| Install image optimization (ShortPixel/EWWW) or enable Cloudflare Polish | Medium | High |
| Manually inspect LCP outlier pages before image work (seahorse, horseshoe crabs, stonefish, orca) | Low | — |
| QA: test defer/delay for animation and interactive element regressions | Medium | — |

*Caveat: Plugin-based optimization is powerful but not fully in our control. Pantheon's read-only filesystem means any optimization plugin must write to `/uploads/` or store data in the database. Updates to WordPress core or other plugins can introduce regressions — budget for ongoing monitoring.*

### Phase 3 — Conditional Loading (Theme) (3–5 weeks)
*Expected: 45–55 → 50–60*

Modifying how the theme enqueues assets. Higher effort but direct control with no plugin dependency.

| Task | Effort | Impact |
|---|---|---|
| Load Swiper CSS/JS only on pages with slider blocks | Med–High | High |
| Load GSAP only on pages with animated blocks | Med–High | High |
| Load reCAPTCHA only on form pages | Medium | Medium |
| Load block-specific CSS only when block is present | Med–High | Medium |
| Serve hero video only on desktop; optimize mobile fallback image | Med–High | High |
| Defer second background video (fishes.mp4) with Intersection Observer | Medium | Medium |
| Add `srcset` responsive sizing for images | Med–High | Medium |
| Reduce font weights or switch to variable font | Medium | Medium |

### Phase 4 — Third-Party Governance (Ongoing)
*Expected: 50–60 → 55–65*

Limited by plugin constraints. Gains are real but harder to guarantee.

| Task | Effort | Impact | Risk |
|---|---|---|---|
| Delay OptinMonster load (via JS delay) | Low | Medium | May delay popups |
| Explore async New Relic with Pantheon support | Low | Medium | May not be possible |
| Add security headers via `pantheon.yml` | Medium | Medium | CSP can break things |
| Remove inactive LiteSpeed Cache plugin | Low | Low | Reduces plugin bloat |

---

## Target Outcomes

| Metric | Current | After Phase 1 | After Phase 2 | After Phases 3–4 |
|---|---|---|---|---|
| Performance Score | 32 | 38–45 | 45–55 | 55–65 |
| LCP (lab) | 26.7s | 18–22s | 12–16s | 8–12s |
| TBT (lab) | 1,130ms | 800–900ms | 500–700ms | 350–500ms |
| FCP (lab) | 15.5s | 10–13s | 7–10s | 4–7s |
| INP (field) | 419ms | ~350ms | ~300ms | ~250ms |
| CLS | 0 | 0 | 0 | 0 |

*Lab metrics simulate a worst-case slow 4G mobile visitor. Field metrics reflect real Chrome users. WordPress mobile median is 41; a score of 55–65 would be top-tier for a site of this complexity.*

---

## Appendix: Current Technology Stack

| Layer | Technology | Status |
|---|---|---|
| CMS | WordPress 6.9.1 | Active |
| Theme | Simple Block (FSE Block Theme, custom — Canic Interactive) | Active |
| Hosting | Pantheon (Nginx/Varnish) | Active |
| Page Cache | Pantheon Global CDN + Cloudflare | Active |
| Object Cache | Object Cache Pro (Redis, zstd, igbinary) | Active |
| Cache Purging | Pantheon Advanced Page Cache (surrogate keys) | Active |
| Frontend Optimization | LiteSpeed Cache v7.7 | Installed but **inactive**; incompatible with Pantheon Nginx |
| JS Framework | UIkit v3.21.11 | Active — loaded on every page |
| Animations | GSAP v3.13.0 (ScrollTrigger, CustomEase, SplitText) | Active — loaded on every page |
| Carousels | Swiper | Active — loaded on every page |
| Forms | Gravity Forms + reCAPTCHA Enterprise | Active — reCAPTCHA loads on every page |
| Analytics | Google Tag Manager + New Relic RUM | Active — both load on every page |
| Popups | OptinMonster | Active |
| Custom Fields | Advanced Custom Fields Pro | Active |
