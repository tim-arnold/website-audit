# Outright — Technology Audit Report

**Date:** 2026-03-23
**Site:** https://weareoutright.com
**Stack:** Next.js 14 · React 18 · SCSS · Cloudflare Pages
**Source:** Local repo at `/Users/timarnold/sites/outright-react-2024`

---

## Executive Summary

- **Facebook Pixel is broken.** Only the `<noscript>` fallback is in `layout.jsx`; the pixel script that loads `fbevents.js` is missing. FB ad attribution, retargeting, and conversion tracking are non-functional.
- **Next.js is two major versions behind** (14.2.13 vs. 16.2.1). React is one major version behind (18 vs. 19). Upgrading Next is a meaningful engineering effort due to App Router changes between v14 and v16.
- **Two abandoned packages** (`uglify-es`, `viewport-units-buggyfill`) and one deprecated package (`scss`) are in `package.json` and should be removed.
- **The GA4 SPA tracking implementation is fragile** — it monkey-patches `history.pushState`/`replaceState` directly in `layout.jsx`, which may cause double-counting on initial load and will silently break if Next.js internals change.
- **No GTM.** All tracking is hardcoded in `layout.jsx`. Adding or changing any analytics tag requires a code change and deploy.
- **Content is entirely code-managed** — no CMS. Every copy change, image swap, or team member update requires a developer and a deploy. This is a significant operational constraint.
- **Several hidden pages** (`/brand-guide`, `/vote`, `/dev-glossary`) are publicly accessible via direct URL despite being excluded from the sitemap. `/brand-guide` in particular may be intended as internal-only.

---

## 1. Property Configuration

| Attribute | Value |
|---|---|
| Framework | Next.js 14.2.13 |
| React | 18.3.1 |
| Rendering | Hybrid SSG + client components |
| Hosting | Cloudflare Pages |
| Deployment adapter | `@cloudflare/next-on-pages` 1.13.16 |
| CI/CD | Not documented; no CI config in repo |
| TypeScript | No |
| CMS | None — content hardcoded in JS config files |
| Analytics | GA4 (hardcoded in `layout.jsx`) |
| Tag Management | None (no GTM) |
| Forms | Mailchimp (JSONP), Copper CRM widget |

---

## 2. Dependency Status

### Core framework

| Package | Installed | Latest | Status |
|---|---|---|---|
| next | 14.2.13 | 16.2.1 | 2 major versions behind |
| react / react-dom | 18.3.1 | 19.2.4 | 1 major version behind |
| eslint | 8.57.1 | 9.39.4 | Major version behind |
| vite | 5.4.11 | 8.0.2 | 3 major versions behind (dev only) |
| vitest / @vitest/ui | 2.1.5 | 4.1.0 | 2 major versions behind (dev only) |
| framer-motion | 11.11.10 | 12.38.0 | Major version behind |
| postcss-preset-env | 10.0.7 | 11.2.0 | Major version behind |

### Abandoned / deprecated packages

| Package | Issue |
|---|---|
| `uglify-es` | Abandoned since 2018; unmaintained. Not directly called in scripts — likely a transitive artifact. Remove. |
| `uglifyjs` | Deprecated wrapper; superseded by `uglify-js`. Remove. |
| `scss` v0.2.4 | Deprecated wrapper around libsass (libsass itself is deprecated). `sass` (Dart Sass) is already installed and in use. Remove `scss`. |
| `viewport-units-buggyfill` | Last release 2016; targets browsers from ~2014. Remove. |

---

## 3. Third-Party Integrations

| Integration | Status | Notes |
|---|---|---|
| Google Analytics 4 | Functional, with caveats | See GA4 section below |
| Facebook Pixel | **Broken** | Only noscript fallback present; pixel script missing |
| Copper CRM widget | Functional | Contact widget loaded via external script |
| Mailchimp newsletter | Functional | JSONP implementation; `/outbox` page |
| Google Tag Manager | Not installed | All tracking hardcoded |

### GA4 Implementation Issues

The GA4 implementation in `app/layout.jsx` uses a manual `history.pushState`/`replaceState` patch to track SPA route changes. Two issues:

1. **Potential double-counting on initial load.** `gtag('config', 'G-FKFEMV82VX')` fires on load, and the `pushState` patch can fire a second `config` call immediately for the same URL depending on timing.
2. **Fragility.** If Next.js changes its internal routing implementation, the patch may fire on every micro-navigation or stop firing entirely, with no visible error.

The correct approach for Next.js App Router is to use `usePathname()` and `useEffect()` inside a client component to fire pageview events only when the route actually changes.

### Facebook Pixel — Not Functional

`layout.jsx` contains only:
```jsx
<noscript>
  <img src="https://www.facebook.com/tr?id=600144734158587&ev=PageView&noscript=1" />
</noscript>
```

The actual pixel initialization script (`fbevents.js` + `fbq('init', ...)` + `fbq('track', 'PageView')`) is missing. The pixel fires only for JavaScript-disabled users — effectively zero people. Any Facebook ad campaigns relying on this pixel for attribution or retargeting are operating blind.

---

## 4. Content Management

All content lives in code. Implications:

| Action | Who can do it | What it requires |
|---|---|---|
| Update copy on any page | Developer | Code edit + deploy |
| Add/change a team member | Developer | Edit `team_members.js` + run index generator + deploy |
| Add a new case study | Developer | New JS config file + assets + update sitemap config + deploy |
| Change a meta description | Developer | Code edit + deploy |

This is workable for a small dev shop but creates a bottleneck: non-technical staff cannot make any content changes independently. This is a strategic risk if the development team is ever unavailable.

---

## 5. Custom Code Issues

### Slug / sitemap drift
Work page slugs exist in two places:
1. `app/our-work/client-work-pages/*.js` filenames
2. Hardcoded array in `next-sitemap.config.mjs`

A new work page added in (1) but not (2) will be missing from `sitemap.xml` and explicitly allowed in `robots.txt` — reducing SEO value.

### Hidden pages without authentication
The following are excluded from sitemap/robots but publicly accessible:

| Route | Content | Risk |
|---|---|---|
| `/brand-guide` | Internal brand reference | Medium — may contain IP or guidelines not intended for public |
| `/vote` | Voter ed PSA campaign (past) | Low — appears to be a completed campaign artifact |
| `/dev-glossary` | Internal glossary | Low — no sensitive data apparent |
| `/zoom` | Zoom backgrounds | Low |

`/brand-guide` should either be behind authentication or removed if the content is intended to be internal-only.

### JSONP for Mailchimp form
`OutboxForm.jsx` uses JSONP to submit to Mailchimp's API. JSONP executes arbitrary script from a third-party domain. While Mailchimp is a trusted vendor, JSONP is a legacy pattern that bypasses CORS protections and creates a dependency on that vendor never serving malicious script. Mailchimp's modern API supports standard `fetch` with CORS; migrating is low-risk and removes this pattern.

---

## 6. Remediation Priorities

### Critical (fix immediately)

| What | Risk | Fix | Effort |
|---|---|---|---|
| Facebook Pixel not loading | Marketing — FB ad attribution and retargeting broken | Add FB Pixel `<Script>` with `fbevents.js` init to `layout.jsx` before the noscript fallback | 1 hour |

### High (fix soon)

| What | Risk | Fix | Effort |
|---|---|---|---|
| GA4 SPA tracking — history patch | Data integrity — potential double-counting, silent breakage on Next.js upgrade | Replace with `usePathname()` + `useEffect()` pageview pattern in a client component | 2–4 hours |
| No GTM | Operational — every analytics change requires a deploy | Migrate GA4 and FB Pixel to GTM; add GTM container script to `layout.jsx` | 1–2 days |
| `/brand-guide` publicly accessible | Security / IP — internal brand assets visible to anyone | Add authentication (e.g. password protection or IP restriction at Cloudflare) or remove route | 2–4 hours |
| Next.js 2 major versions behind | Stability — missing security patches and bug fixes in v15/v16 | Upgrade to Next 15 first, then 16; test each major bump separately | 2–5 days |

### Medium (planned work)

| What | Risk | Fix | Effort |
|---|---|---|---|
| Remove abandoned packages (`uglify-es`, `uglifyjs`, `scss`, `viewport-units-buggyfill`) | Maintainability — dead weight in `package.json` | Remove from `package.json`, run `npm install`, verify build | 1–2 hours |
| Sitemap slug sync | SEO — new work pages may be missing from sitemap | Automate sitemap slug generation from the same index used at build time, eliminating the duplicate array | 2–4 hours |
| Mailchimp JSONP → fetch | Security — JSONP executes third-party script | Migrate `OutboxForm.jsx` to use Mailchimp's REST API or a server-side route | 4–8 hours |
| React 18 → 19 upgrade | Stability — React 18 EOL approaching | Upgrade after Next.js upgrade; audit client components for deprecated patterns | 1–3 days |
| Upgrade dev tooling (vite, vitest, eslint) | Maintainability — 2–3 major versions behind | Update in a dedicated PR; ESLint 9 has a new flat config format | 1 day |

### Low (backlog)

| What | Risk | Fix | Effort |
|---|---|---|---|
| Remove `/vote` campaign page | Hygiene — stale content | Archive assets, delete route | 1 hour |
| Content management bottleneck | Operational — all changes require a developer | Evaluate headless CMS (Sanity, Contentful) for at least team/work content | Multi-sprint |
| Add CSP headers | Security — no Content Security Policy defined | Define CSP via Cloudflare headers or `next.config.mjs` `headers()` | 4–8 hours |
| Framer Motion major upgrade (v11 → v12) | Compatibility — v12 has API changes | Audit usage, upgrade, test animations | 4–8 hours |
