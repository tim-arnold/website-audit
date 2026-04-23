# Outright — Technology Inventory

**Audited:** 2026-03-23
**Source:** Local repo at `/Users/timarnold/sites/outright-react-2024`
**Live site:** https://weareoutright.com

---

## 1. Architecture

| Attribute | Value |
|---|---|
| Framework | Next.js 14.2.13 (App Router) |
| Language | JavaScript (no TypeScript) |
| Rendering | Hybrid — SSG for most pages, client components throughout |
| Styling | SCSS modules + Bootstrap 5.3.3 |
| Hosting | Cloudflare Pages (`@cloudflare/next-on-pages` adapter) |
| Build output | `.vercel/output/static` (via `pages:build`) |
| CI/CD | Not documented; no CI config files found in repo |
| Package manager | npm (package-lock.json present) |
| Node compat | Cloudflare `nodejs_compat` flag enabled (`wrangler.toml`) |

**Site structure:**
- App Router with `app/` directory
- All pages are static or client-rendered; no API routes observed
- Content is hardcoded in JS config files per project (`app/our-work/client-work-pages/*.js`)
- No CMS — all content changes require a code deploy
- Custom index generators run pre-build to create import maps for images, team photos, logos

**Hidden/non-public routes** (excluded from sitemap and robots.txt):
- `/dev-glossary` — internal glossary
- `/vote` — voter education page (PSA videos; appears to be a one-time campaign)
- `/holiday` — holiday content
- `/brand-guide` — internal brand reference
- `/zoom` — Zoom background images
- `/outbox` — newsletter signup (Mailchimp)
- `/terms` — privacy policy / terms

---

## 2. Dependencies

### Framework & Runtime

| Package | Installed | Latest | Gap |
|---|---|---|---|
| next | 14.2.13 | 16.2.1 | 2 major versions behind |
| react | 18.3.1 | 19.2.4 | 1 major version behind |
| react-dom | 18.3.1 | 19.2.4 | 1 major version behind |

### UI & Animation

| Package | Installed | Latest | Notes |
|---|---|---|---|
| bootstrap | 5.3.3 | 5.3.8 | Minor update available |
| framer-motion | 11.11.10 | 12.38.0 | Major version behind |
| gsap | 3.13.0 | 3.14.2 | Minor update available |
| fullpage.js | 4.0.30 | 4.0.41 | Minor update available |
| react-scroll-parallax | 3.4.5 | 3.5.0 | Minor update available |
| react-iframe | 1.8.5 | 1.8.5 | Current |

### Build Tools & Processing

| Package | Installed | Latest | Notes |
|---|---|---|---|
| sass | 1.79.5 | 1.98.0 | Minor updates available |
| sharp | 0.34.2 | 0.34.5 | Minor update available |
| postcss-preset-env | 10.0.7 | 11.2.0 | Major version behind |
| @svgr/webpack | 8.1.0 | (not checked) | |
| uglify-es | 3.3.10 | abandoned | Package is abandoned; last release 2018 |
| uglifyjs | 2.4.11 | deprecated | Deprecated wrapper; superseded by uglify-js |

### Cloudflare / Deployment

| Package | Installed | Latest | Notes |
|---|---|---|---|
| @cloudflare/next-on-pages | 1.13.16 | (check CF docs) | |

### Dev / Test

| Package | Installed | Latest | Notes |
|---|---|---|---|
| eslint | 8.57.1 | 9.39.4 | Major version behind (ESLint 9 has breaking config changes) |
| eslint-config-next | 14.2.13 | 16.2.1 | Pinned to Next 14 |
| vite | 5.4.11 | 8.0.2 | 3 major versions behind |
| vitest | 2.1.5 | 4.1.0 | 2 major versions behind |
| @vitejs/plugin-react | 4.3.3 | 6.0.1 | Major version behind |
| @vitest/ui | 2.1.5 | 4.1.0 | Major version behind |
| @babel/preset-env | 7.26.0 | 7.29.2 | Minor update |
| @testing-library/jest-dom | 6.6.3 | 6.9.1 | Minor update |
| @testing-library/react | 16.0.1 | 16.3.2 | Minor update |
| jsdom | 25.0.1 | 28.1.0 | Major versions behind |

### Noteworthy dependency issues

- **`uglify-es`**: Abandoned since 2018. No CVEs filed but unmaintained. Used only as a dependency — not directly invoked in scripts.
- **`scss` package** (v0.2.4): Thin wrapper around libsass, which is deprecated. `sass` (Dart Sass) is already installed and should be the sole Sass compiler.
- **`viewport-units-buggyfill`**: Last release 2016, targets very old iOS/Android browsers. Almost certainly dead code.
- **`react-iframe`**: Simple iframe wrapper; last release 2021. Low risk but unmaintained.

---

## 3. Third-Party Integrations

| Integration | How Implemented | Credentials Exposed? | Notes |
|---|---|---|---|
| Google Analytics 4 | Inline `<Script>` in `layout.jsx` | Measurement ID `G-FKFEMV82VX` in source | Public ID; not a secret — expected |
| Facebook Pixel | `<noscript>` img tag only in `layout.jsx` | Pixel ID `600144734158587` in source | **Pixel script never loaded** — only the noscript fallback exists; FB Pixel is effectively non-functional |
| Copper CRM widget | `<Script src="...">` in `layout.jsx` | Widget key in URL | Public widget URL; not a secret |
| Mailchimp (newsletter) | JSONP in `OutboxForm.jsx` | List ID `e1228b5936`, user ID `6b2d137daa7341f2eed8111a7` in source | Mailchimp public list IDs; expected to be public |
| Google Tag Manager | Not found | — | GTM is not installed; GA4 loaded directly |

### Google Analytics implementation notes

- GA4 loaded with `strategy="afterInteractive"` — correct
- Custom SPA page view tracking implemented by monkey-patching `history.pushState` and `history.replaceState` — this is a manual workaround; Next.js App Router's built-in navigation events are not used
- `gtag('config', ...)` called both on initial load and on every route change — possible double-counting on initial page load if the initial `config` call fires before `pushState` patch is applied
- No GTM; all tracking is hardcoded in `layout.jsx`

### Facebook Pixel notes

- Only a `<noscript>` fallback img is present — the actual FB Pixel `<Script>` that loads `fbevents.js` is missing
- The pixel will only fire for users with JavaScript disabled (essentially nobody)
- This means Facebook ad attribution, retargeting audiences, and conversion tracking via FB are non-functional

---

## 4. Content Model

- All content is hardcoded as JavaScript config files in `app/our-work/client-work-pages/`
- 14 active work page configs; 1 inactive client directory observed (`clients-inactive/`)
- No database, no CMS, no headless API
- Team members managed via `team/team_members.js`
- Adding or updating any content requires a developer, a commit, and a deploy

---

## 5. Custom Functionality

### Index generation scripts
Pre-build scripts generate JS import maps for:
- Client work pages (`PROJECT_SLUGS`)
- Team headshots
- Zoom background images
- Outright logo variations

These must run before `next build`; the `build` script handles this automatically. If a developer runs `next build` directly, indexes may be stale.

### SPA routing / history patching
`layout.jsx` patches `history.pushState` and `history.replaceState` to fire GA4 pageviews on route changes. This is fragile:
- If Next.js internals change how it calls these APIs, tracking breaks silently
- No test coverage for this behavior

### Sitemap slug sync
Work page slugs are maintained in two places:
1. Filename of `app/our-work/client-work-pages/*.js`
2. Hardcoded array in `next-sitemap.config.mjs`

These can drift. If a slug is added to the config files but not to `next-sitemap.config.mjs`, it won't appear in the sitemap or robots.txt.

### Hidden pages accessible via direct URL
The following pages are excluded from sitemap/robots but are publicly accessible:
- `/dev-glossary` — internal glossary; contains no apparent sensitive data
- `/vote` — voter education PSA page; appears to be a past campaign artifact
- `/brand-guide` — internal brand reference; appears to be intended as internal-only
- `/zoom` — Zoom background images
- `/outbox` — newsletter signup

These pages are not password-protected. `/brand-guide` in particular may warrant review.

---

## 6. Performance & Configuration

- Image optimization: WebP/AVIF via `next/image` + Sharp — correctly configured
- `www.weareoutright.com → weareoutright.com` redirect defined in `next.config.mjs` — correct
- No `.env` files committed to repo — correct
- No internal environment variable references found that suggest secrets are missing
- `wrangler.toml` compatibility date: `2025-01-06` — current for Cloudflare Workers
- No staging environment config detected
- No CSP (Content Security Policy) headers observed in config

---

## 7. Security Observations (surface-level; not a full security audit)

- No hardcoded secrets found in source
- GA4 measurement ID and Mailchimp list IDs in source are public identifiers — expected
- FB Pixel ID in noscript tag — public identifier; not a secret
- No `.env` files present in repo root
- No API routes — attack surface is minimal for a static/CDN-deployed site
- JSONP used for Mailchimp form submission — JSONP is an older pattern with XSS risk if the target server is compromised; not directly exploitable here but worth noting
