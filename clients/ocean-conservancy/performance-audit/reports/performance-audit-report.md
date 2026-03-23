# Performance Audit — Ocean Conservancy

**Date:** February 13, 2026
**URL:** https://oceanconservancy.org
**Prepared by:** Tim Arnold, Outright

---

## Executive Summary

The Ocean Conservancy website has a **strong server-side caching infrastructure** (Pantheon Global CDN, Redis via Object Cache Pro, Cloudflare) and **reasonable Core Web Vitals** from real-user data. However, the Lighthouse **Performance score is 32/100** — well below the target range of 70–90 — driven primarily by excessive JavaScript, render-blocking resources, unoptimized images, and heavy third-party scripts.

Notably, while LiteSpeed Cache is installed, it is **not active** and its server-level features are incompatible with Pantheon's Nginx-based infrastructure. This means there is currently **no frontend optimization layer** between the theme output and the CDN — no CSS/JS minification, no lazy loading, no critical CSS extraction, and no image format conversion. This represents both the core problem and the biggest opportunity.

The good news: most of these issues are addressable through a combination of theme-level code changes and a properly chosen optimization plugin. However, because much of the site's functionality comes from WordPress plugins (OptinMonster, reCAPTCHA, New Relic, Gravity Forms, GTM), our ability to control how those third-party scripts load is limited in some cases. The roadmap below is honest about what we can directly change versus what requires plugin configuration, workarounds, or acceptance.

---

## Current Scores (PageSpeed Insights — Mobile)

| Category | Score | Rating |
|----------|-------|--------|
| **Performance** | **32** | Poor |
| Accessibility | 88 | Good |
| Best Practices | 54 | Needs Work |
| SEO | 85 | Good |

### Core Web Vitals (Field Data — 28-day, Mobile, Chrome UX Report)

| Metric | Value | Rating | Target |
|--------|-------|--------|--------|
| Largest Contentful Paint (LCP) | 1.8s | Good | < 2.5s |
| Interaction to Next Paint (INP) | 419ms | Needs Improvement | < 200ms |
| Cumulative Layout Shift (CLS) | 0 | Good | < 0.1 |
| First Contentful Paint (FCP) | 1.5s | Good | < 1.8s |
| Time to First Byte (TTFB) | 0.5s | Good | < 0.8s |

### Lab Metrics (Lighthouse 13.0.1 — Emulated Moto G Power, Slow 4G)

| Metric | Value | Rating | Target |
|--------|-------|--------|--------|
| First Contentful Paint (FCP) | **15.5s** | Poor | < 1.8s |
| Largest Contentful Paint (LCP) | **26.7s** | Poor | < 2.5s |
| Total Blocking Time (TBT) | **1,130ms** | Poor | < 200ms |
| Speed Index | **15.8s** | Poor | < 3.4s |
| Cumulative Layout Shift (CLS) | 0 | Good | < 0.1 |

### Why Field Data and Lab Data Differ So Dramatically

The field data (from real Chrome users) looks reasonable because most visitors benefit from **Cloudflare CDN caching**, **browser cache on repeat visits**, and **fast connections**. The Lighthouse lab test simulates a **worst-case scenario**: a first-time visitor on a mid-range phone over a slow 4G connection with no cache. This reveals the true weight of the page — every unoptimized image, every render-blocking script, and every third-party request compounds on a constrained connection.

The 26.7-second LCP means a first-time mobile visitor on a slower connection could wait nearly **half a minute** to see the main content. The 1,130ms Total Blocking Time means the page is **completely unresponsive** for over a full second while JavaScript executes. These lab numbers are what drive the Performance score of 32.

**Assessment:** The server-side infrastructure (TTFB, caching, CDN) is excellent. The problem is entirely on the **frontend delivery side**: too much unoptimized CSS and JS shipped to every page, no image optimization pipeline, and heavy third-party scripts loading in the critical path.

---

## What's Working Well

1. **Pantheon Global CDN + Cloudflare** — Two-layer edge caching delivers fast TTFB (0.5s)
2. **Redis object caching** — Object Cache Pro with zstd compression and igbinary serialization handles database queries efficiently
3. **Smart cache purging** — Pantheon Advanced Page Cache uses surrogate keys for targeted invalidation
4. **Zero layout shift** — CLS of 0 indicates stable visual layout
5. **Cache-busting via `filemtime()`** — Ensures fresh assets after deploys without breaking cache

---

## What's Not Working: The Missing Optimization Layer

LiteSpeed Cache is installed but **not active**, and its server-level features (page caching, ESI) are **incompatible with Pantheon's Nginx/Varnish stack** regardless. Pantheon does not run the LiteSpeed Web Server.

This means the site currently has **no frontend optimization** of any kind:

- No CSS minification or combination
- No JS minification, deferral, or delayed loading
- No critical CSS extraction
- No image lazy loading
- No WebP/AVIF image conversion
- No unused CSS removal
- No resource hint injection

The raw, unoptimized HTML/CSS/JS output of the theme is being served directly through the CDN. This is the single biggest factor in the low Performance score.

---

## Key Issues & Opportunities

### 1. No Frontend Optimization Plugin (Highest Priority)

**Problem:** With LiteSpeed Cache inactive and incompatible, there is no optimization layer handling CSS/JS minification, deferral, lazy loading, or critical CSS.

**Recommendation:** Install and configure a Pantheon-compatible optimization plugin. However, plugin selection is constrained by **Pantheon's read-only filesystem** — the code directory (`wp-content/themes/`, `wp-content/plugins/`, `wp-content/cache/`) is not writable at runtime. Only `wp-content/uploads/` is writable. Many optimization plugins assume they can write cache files, config files, or minified assets to directories outside of `/uploads/`, and will fail silently or error on Pantheon.

**Options, accounting for Pantheon's constraints:**

- **WP Rocket** — Premium ($59/yr). Handles CSS/JS minification + defer + delay, critical CSS generation, lazy loading, preloading. However, WP Rocket writes to `wp-content/wp-rocket-config/` and `wp-content/cache/wp-rocket/`, which are **not writable on Pantheon by default**. Pantheon publishes a [WP Rocket compatibility guide](https://docs.pantheon.io) and there are workarounds (symlink the cache directory to `/uploads/`, or use their CDN add-on), but this requires extra setup and may not survive platform updates.
- **Autoptimize** — Free. Writes its cache to `wp-content/cache/autoptimize/`, which has the same write restriction. Can be reconfigured to use a path under `/uploads/` via the `AUTOPTIMIZE_CACHE_CHILD_DIR` constant, making it more Pantheon-friendly with some setup.
- **Perfmatters** — Premium ($24.95/yr). Lightweight and largely **database-driven** (stores settings in `wp_options`), making it more Pantheon-compatible out of the box. Focused on script management (disable per page), lazy loading, preloading, DNS prefetch, and local Google Analytics. Does not do CSS/JS minification or critical CSS — it's a complement, not a standalone solution.

**Pantheon-native approach (alternative):** Rather than fighting filesystem constraints with a plugin, many of these optimizations can be implemented directly in theme code (see Phases 1 and 3). This gives full control, avoids plugin compatibility issues, and survives platform updates. The tradeoff is higher development effort.

**What a plugin gives us:** CSS async loading, JS deferral, lazy loading, resource hints, and critical CSS — handling most of the Phase 1 and Phase 3 items with configuration rather than custom code.

**What no plugin will fix:** Conditional loading of specific third-party scripts (reCAPTCHA, OptinMonster, New Relic), image format conversion, or font subsetting. Those require separate solutions.

**Estimated impact:** 10–25 point improvement in Performance score from plugin configuration alone

---

### 2. Excessive JavaScript / Main Thread Blocking (High Impact)

**Problem:** Heavy JS payloads block the main thread, contributing to the poor Performance score, the 419ms INP, and the 1,130ms TBT. Currently loading on every page:

- **UIkit JS** (v3.21.11) — full UI framework
- **Swiper bundle** — 8+ separate slider instances registered (hero, testimonials, partners, spotlight, news, posts, gallery, get-involved)
- **GSAP animation suite** — 4 CDN files (core, ScrollTrigger, CustomEase, SplitText) + custom app.js
- **Google reCAPTCHA Enterprise** — loaded globally, not just on form pages
- **OptinMonster** — popup script
- **New Relic RUM** — real-user monitoring in the critical path
- **jQuery + jQuery Migrate** — WordPress defaults

**What we can directly change (theme code):**
- Add `defer` attribute to UIkit, Swiper, GSAP, and theme script enqueues — **Low effort, high impact**
- Conditionally enqueue Swiper JS only on pages/posts that contain slider blocks — **Medium effort, high impact**
- Conditionally enqueue GSAP only on pages with animated blocks — **Medium effort, high impact**
- Wrap reCAPTCHA output to only load on pages with Gravity Forms — **Medium effort, medium impact** (depends on how it's integrated; if it's hardcoded in the theme we control it, if it's via a plugin we may need to use hooks)

**What we have limited control over (plugin-managed):**
- **OptinMonster** — Its script loading is managed by the OptinMonster plugin. We can try delaying it via a performance plugin's JS delay feature, but aggressive delays may break popup triggers.
- **New Relic RUM** — Typically injected by the Pantheon platform or a server-side agent. Moving it to async may require Pantheon support or configuration changes outside WordPress.
- **GTM** — We can control when it fires if we manage the embed snippet in the theme. If it's added via a plugin, we're limited to that plugin's settings.
- **jQuery Migrate** — Can be removed via `wp_dequeue_script`, but may break plugins that depend on it. Requires testing.

**Estimated impact:** 1–3s improvement in Total Blocking Time; significant INP improvement. The theme-level changes (defer + conditional loading) will deliver most of the gains.

---

### 3. Image Optimization (High Impact)

**Problem:** No automatic image optimization pipeline. Images are served as uploaded (JPG/PNG) with no modern format conversion and no lazy loading.

**Current state:**
- No WebP or AVIF conversion
- No `loading="lazy"` attributes
- Custom image sizes defined (410px, 860px, 1920px, 1586px) but no responsive art direction
- Hero images appear to use background-image CSS (not optimizable via `<picture>`)

**What we can directly change (theme code):**
- Add `loading="lazy"` to below-the-fold images in block templates — **Low effort**
- Add explicit `width` and `height` attributes — **Low effort**
- Preload the LCP hero image with `<link rel="preload">` — **Low effort**
- Convert hero sections from CSS `background-image` to `<picture>` elements where feasible — **Medium effort** (requires template changes and design review)

**What requires a plugin or service:**
- **WebP/AVIF conversion** — Most image optimization plugins (ShortPixel, Imagify, EWWW) work by writing converted files alongside the originals in `wp-content/uploads/`, which **is writable on Pantheon** — so these should function correctly. **Storage note:** These plugins generate additional converted versions alongside the originals, which can increase total media storage by 2–3x (each uploaded image may have its original plus WebP and/or AVIF variants at every registered thumbnail size). On Pantheon, storage is included with the plan but worth monitoring. ShortPixel's CDN-based delivery option can serve converted formats on-the-fly without storing extra files locally — worth considering if storage is a concern.
- Alternatively, **Cloudflare's Polish + WebP feature** (available on Pro plan, $20/mo) can handle image conversion at the CDN edge with no WordPress plugin, no storage impact, and no filesystem constraints. This is the cleanest option for Pantheon if Cloudflare is already on a paid plan.

**What we can't easily change:**
- Images uploaded at unnecessarily large dimensions. A bulk audit and re-upload may be needed for the worst offenders, but this is an editorial workflow issue, not a code change.

**Estimated impact:** 20–40% reduction in image transfer size; faster LCP on slower connections

---

### 4. Render-Blocking CSS (High Impact)

**Problem:** Multiple CSS files load synchronously in `<head>`, blocking first paint. This includes the full UIkit framework CSS, Swiper CSS, and all block-specific stylesheets — even on pages that don't use those blocks.

**Current state:**
- UIkit CSS (full framework)
- Swiper CSS (carousel library)
- Theme custom styles
- Individual block stylesheets (hero, statistic, spotlight, our-work, donate, partners)

**What we can directly change (theme code):**
- Conditionally enqueue block-specific CSS only when those blocks are present on the page — **Medium effort, high impact**
- Conditionally enqueue Swiper CSS only on pages with sliders — **Medium effort**

**What requires a plugin or significant effort:**
- **Critical CSS extraction** — Generating and inlining above-the-fold CSS is complex to do manually. WP Rocket handles this automatically; Autoptimize offers it via an add-on. Doing it manually per template is high effort and brittle.
- **CSS async loading** — Converting non-critical stylesheets to load asynchronously (`media="print"` trick) can be done in theme code, but an optimization plugin handles this more reliably across all enqueued styles including those from other plugins.
- **CSS minification** — Straightforward via plugin (WP Rocket, Autoptimize). Not worth building custom.

**Estimated impact:** 0.5–1.5s improvement in FCP/LCP in lab tests

---

### 5. Font Loading Strategy (Medium Impact)

**Problem:** 8 font files (6 Geologica weights + 2 Inter weights) loaded via `@font-face` with `font-display: fallback`. This triggers a 3-second block period before fallback text is shown.

**What we can directly change (theme code):**
- Switch to `font-display: swap` — **Low effort**
- Preload the 1–2 critical font weights used above the fold — **Low effort**
- Reduce font weights if design permits (e.g., 6 Geologica weights → 3) — **Low effort, requires design approval**
- Switch to variable fonts (single file replaces all weights) — **Medium effort, requires font licensing check**

**Estimated impact:** 200–500ms improvement in text rendering; smaller total transfer

---

### 6. Missing Resource Hints (Medium Impact)

**Problem:** No `dns-prefetch`, `preconnect`, or `prefetch` directives for third-party origins.

**What we can directly change (theme code):**
Add to `<head>` via `wp_head` hook:
```html
<link rel="preconnect" href="https://www.googletagmanager.com" crossorigin>
<link rel="preconnect" href="https://www.google.com" crossorigin>
<link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
<link rel="dns-prefetch" href="https://bam.nr-data.net">
```

This is a straightforward theme change. Some optimization plugins (WP Rocket, Perfmatters) also handle this via settings.

**Estimated impact:** 100–300ms per third-party connection on first visit

---

### 7. Third-Party Script Governance (Medium Impact)

**Problem:** Multiple third-party scripts load on every page, regardless of need:

| Script | Purpose | Load Behavior | Our Control |
|--------|---------|---------------|-------------|
| Google reCAPTCHA Enterprise | Bot protection | Sync, every page | Partial — depends on integration method |
| Google Tag Manager | Analytics | Async | Partial — if in theme, yes; if via plugin, limited |
| New Relic RUM | Monitoring | Sync, blocking | Low — often platform-managed on Pantheon |
| OptinMonster | Popups | Async, footer | Low — managed by plugin |

**What we can try:**
- **reCAPTCHA**: If loaded via theme code, wrap in conditional to only output on pages with forms. If loaded via Gravity Forms plugin settings, we may be able to configure it there.
- **OptinMonster**: Use a performance plugin's JS delay feature to defer loading until user interaction. Risk: may delay popup display.
- **GTM**: If the snippet is in the theme, we can implement a delayed/consent-gated load. If via a plugin, we're limited to its options.

**What we likely can't change:**
- **New Relic**: On Pantheon, this is often injected at the platform level. Contact Pantheon support to explore async options.

**Estimated impact:** 500ms–1s reduction in Total Blocking Time on non-form pages, but gains depend on how much control we have over each script.

---

### 8. Best Practices Score (54)

The low Best Practices score likely stems from:
- **Browser console errors** from JS conflicts
- **Missing security headers** (Content Security Policy, etc.)
- **Deprecated APIs** used by legacy scripts

**What we can directly change:**
- Audit and fix browser console errors in theme JS — **Medium effort**
- Add security headers via Pantheon's `pantheon.yml` or a plugin — **Low–Medium effort**

**What may be plugin-caused:**
- Deprecated API usage from older plugin versions — requires plugin updates or is outside our control

---

## Tradeoffs & Risks: What to Know Before Approving Changes

Every performance optimization involves a tradeoff. The changes below can improve scores, but each comes with a potential cost to design, editorial workflow, or site behavior. **We recommend reviewing these tradeoffs before greenlighting any phase of work**, so there are no surprises after implementation.

### Adding an optimization plugin = adding another caching layer

The site currently runs through three layers of caching: **Cloudflare → Pantheon CDN → WordPress**. When content is updated, each layer needs to clear before the change appears live. Adding a frontend optimization plugin (WP Rocket, Autoptimize, etc.) introduces a **fourth caching layer** — one more thing that can cause "I updated the page but it still looks the same" issues for the editorial team.

**What to expect:** Occasionally, after publishing changes, editors may need to manually purge the optimization plugin's cache in addition to the existing workflow. This adds a small but real friction to day-to-day content management.

**Mitigation:** Most optimization plugins integrate with WordPress's publish/update hooks and purge automatically. But edge cases (menu changes, widget updates, global elements) often require manual purges. The editorial team should be briefed on how to clear the additional cache.

### Deferring JavaScript may break animations and interactive elements

Adding `defer` to scripts changes the order in which JavaScript loads and executes. This is the single biggest lever for improving the Performance score, but:

- **Animations may flash or stutter on first load** — GSAP-powered animations that currently play smoothly on page load may briefly show unstyled/unanimated content before the deferred JS kicks in.
- **Interactive elements may have a brief non-functional window** — Sliders, popups, and other JS-dependent features may take a moment longer to become interactive after the page visually renders.
- **Some scripts may break entirely** — Particularly scripts with hard dependencies on load order. Each deferred script needs individual testing.

**What to expect:** The page will *visually* load faster, but there may be a brief gap where things look right but don't respond to clicks/scrolls yet. Animations may need to be redesigned to account for deferred loading (e.g., triggering on scroll rather than on page load).

**The hard truth about render-blocking resources:** Much of the "render-blocking" diagnosis is tied directly to the homepage animations. The most reliable way to significantly improve this metric is to reduce or remove entrance animations on above-the-fold elements. If the current animation design is non-negotiable, the score improvement from other changes will be more modest.

### Font-display: swap causes a visible font flash

Switching from `font-display: fallback` to `font-display: swap` means:

- **Users will briefly see system fonts** (Arial, Helvetica, etc.) before the custom fonts (Geologica, Inter) load and swap in
- **This causes a visible "flash of unstyled text" (FOUT)** — text may briefly appear in a different size, weight, or spacing, then snap to the intended design
- **On slow connections, the flash can last 1–3 seconds**

**What to expect:** Some users — especially first-time visitors on slower connections — will see the site in a system font for a moment. This is a design fidelity tradeoff. The current `fallback` setting prioritizes design consistency (hiding text until fonts load), while `swap` prioritizes showing content immediately.

**Client decision needed:** Is a brief font flash acceptable in exchange for faster perceived load time? If not, this change should be skipped — the score impact is relatively small (Low–Medium).

### Image optimization changes image quality (slightly)

WebP/AVIF conversion and compression reduce file sizes by discarding some image data:

- **Quality loss is typically imperceptible** at 80–85% quality, but pixel-perfect comparison will show differences
- **Some images may show compression artifacts** — especially images with text overlays, sharp edges, or gradients
- **Art-directed hero images** may need manual quality review after conversion

**What to expect:** The vast majority of images will look identical to the casual viewer. But if the client has exacting standards for image quality (e.g., photography-heavy campaigns), a review process should be built in after batch optimization.

### Conditional script loading may cause inconsistencies

Loading Swiper/GSAP/reCAPTCHA only on pages that need them is efficient, but:

- **New pages that use these features need to be accounted for** — If an editor adds a slider block to a page that previously didn't have one, the script needs to be enqueued for that page. With WordPress block detection this is usually automatic, but edge cases exist.
- **Preview/draft behavior may differ from published pages** — Cached pages may not reflect new block additions until caches clear.

### Third-party script delays may affect functionality

- **Delaying OptinMonster** means popups appear later or may not trigger if a user leaves quickly
- **Delaying GTM** means analytics may miss very short visits (bounces under a few seconds)
- **Delaying reCAPTCHA** could cause forms to briefly appear without bot protection, or require a loading state before submission is enabled

---

## Prioritized Implementation Roadmap

### Phase 1 — Quick Wins (1–2 weeks)
*Expected score improvement: 32 → 38–45*

These are all directly within our control via theme code changes.

| Task | Type | Effort | Impact |
|------|------|--------|--------|
| Add `defer` to theme JS enqueues (UIkit, Swiper, GSAP, app.js) | Theme code | Low | High |
| Add `loading="lazy"` to below-fold images in block templates | Theme code | Low | Medium |
| Add resource hints (preconnect, dns-prefetch) via `wp_head` | Theme code | Low | Medium |
| Switch `font-display` from `fallback` to `swap` | Theme code | Low | Low–Med |
| Add `<link rel="preload">` for LCP hero image | Theme code | Low | Medium |

### Phase 2 — Optimization Plugin + Images (2–4 weeks)
*Expected score improvement: 38–45 → 45–55*

Requires plugin selection, installation, configuration, and thorough testing. The optimization plugin may conflict with theme scripts or other plugins and will need careful QA.

| Task | Type | Effort | Impact |
|------|------|--------|--------|
| Choose and install optimization plugin (WP Rocket or Autoptimize) | Plugin config | Medium | High |
| Configure CSS minification + async loading | Plugin config | Low | High |
| Configure JS defer/delay settings | Plugin config | Low–Med | High |
| Enable critical CSS generation | Plugin config | Low–Med | High |
| Install image optimization plugin (ShortPixel/EWWW) or evaluate Cloudflare Polish | Plugin + config | Medium | High |
| Test thoroughly — defer/delay can break interactive elements | QA | Medium | — |

**Caveat:** Plugin-based optimization is powerful but not fully in our control. Pantheon's read-only filesystem means any caching/optimization plugin must be validated to either write to `/uploads/` or store its data in the database. Updates to the optimization plugin, WordPress core, or other plugins can introduce regressions. Budget for ongoing monitoring and compatibility testing after updates.

### Phase 3 — Theme-Level Conditional Loading (3–5 weeks)
*Expected score improvement: 45–55 → 50–60*

These require modifying how the theme enqueues its own assets. Higher effort but gives us direct control with no plugin dependency.

| Task | Type | Effort | Impact |
|------|------|--------|--------|
| Conditional Swiper CSS/JS (only on pages with slider blocks) | Theme code | Medium–High | High |
| Conditional GSAP loading (only on pages with animated blocks) | Theme code | Medium–High | High |
| Conditional reCAPTCHA loading (only on pages with forms) | Theme code | Medium | Medium |
| Conditional block-specific CSS (only when block is on page) | Theme code | Medium–High | Medium |
| Reduce font weights or switch to variable font | Theme code + design | Medium | Medium |

### Phase 4 — Third-Party Governance & Polish (Ongoing)
*Expected score improvement: 50–60 → 55–65*

Limited by plugin constraints. Gains here are real but harder to guarantee.

| Task | Type | Effort | Impact | Risk |
|------|------|--------|--------|------|
| Delay OptinMonster via JS delay feature | Plugin config | Low | Medium | May delay popups |
| Explore New Relic async loading with Pantheon | Platform support | Low | Medium | May not be possible |
| Delayed GTM loading (if snippet is in theme) | Theme code | Medium | Medium | May affect analytics |
| Remove jQuery Migrate | Theme code | Low | Low | May break plugins |
| Add security headers for Best Practices score | Config | Medium | Medium | CSP can break things |
| Remove inactive LiteSpeed Cache plugin | Admin | Low | Low | Reduces plugin bloat |

---

## A Note on Score Expectations

It's important to set realistic expectations grounded in industry data.

According to the [HTTP Archive's 2025 Web Almanac](https://almanac.httparchive.org/en/2025/cms), the **median WordPress mobile Lighthouse Performance score is 41**. The site's current score of **32** is below that median, but not drastically so. For context, the highest-performing CMS platform (Wix) achieves a median of only **64** on mobile, and only **45% of all WordPress sites** pass Core Web Vitals.

**Why WordPress mobile scores are inherently low:**

- **Third-party scripts we can't eliminate** (GTM, reCAPTCHA, New Relic, OptinMonster) carry a baseline cost of ~300–500ms of blocking time that we can mitigate but not remove
- **WordPress core** ships jQuery and other scripts that add weight
- **The Lighthouse mobile test** simulates a mid-range phone (Moto G Power) on a slow 4G connection — even well-optimized sites score 20–30 points lower on mobile than desktop under these conditions
- **Plugin updates** can regress performance at any time if they add scripts or change loading behavior
- **Content-rich sites** with animation libraries (GSAP), UI frameworks (UIkit), and carousels (Swiper) face a heavier baseline than minimal marketing sites

**Realistic targets for this site:**

- **50–55** is achievable through Phase 1 and 2 work (above the WordPress median)
- **55–65** is a strong outcome after all four phases (top-tier for WordPress)
- **65+** would require aggressive measures like removing animation libraries, replacing UIkit, or eliminating third-party scripts — changes that may not be acceptable tradeoffs for functionality and design
- **70+ on mobile** is exceptional for any WordPress site with this level of functionality and should not be treated as an expected outcome

---

## Target Outcomes

| Metric | Current | After Phase 1 | After Phase 2 | After Phases 3–4 |
|--------|---------|---------------|---------------|-------------------|
| Performance Score | 32 | 38–45 | 45–55 | 55–65 |
| LCP (lab) | 26.7s | 18–22s | 12–16s | 8–12s |
| TBT (lab) | 1,130ms | 800–900ms | 500–700ms | 350–500ms |
| FCP (lab) | 15.5s | 10–13s | 7–10s | 4–7s |
| LCP (field) | 1.8s | ~1.6s | ~1.4s | ~1.3s |
| INP (field) | 419ms | ~350ms | ~300ms | ~250ms |
| CLS | 0 | 0 | 0 | 0 |

*For reference: the WordPress mobile median is 41 (HTTP Archive 2025). Reaching 55+ would place the site well above the WordPress median. Reaching 65 would be a top-tier result.*

---

## Appendix: Current Technology Stack

| Layer | Technology | Status |
|-------|-----------|--------|
| CMS | WordPress 6.7+ | Active |
| Theme | Simple Block (FSE Block Theme, custom) | Active |
| Hosting | Pantheon (Nginx/Varnish) | Active |
| Page Cache | Pantheon Global CDN + Cloudflare | Active |
| Object Cache | Object Cache Pro (Redis, zstd, igbinary) | Active |
| Cache Purging | Pantheon Advanced Page Cache (surrogate keys) | Active |
| Frontend Optimization | LiteSpeed Cache v7.7 | **Installed but inactive; incompatible with Pantheon** |
| JS Framework | UIkit v3.21.11 | Active — loaded on every page |
| Animations | GSAP v3.13.0 (ScrollTrigger, CustomEase, SplitText) | Active — loaded on every page |
| Carousels | Swiper | Active — loaded on every page |
| Forms | Gravity Forms + reCAPTCHA Enterprise | Active — reCAPTCHA loads on every page |
| Analytics | Google Tag Manager + New Relic RUM | Active — both load on every page |
| Popups | OptinMonster | Active |
| Custom Fields | Advanced Custom Fields Pro | Active |