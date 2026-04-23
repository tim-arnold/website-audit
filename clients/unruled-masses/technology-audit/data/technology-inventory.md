# Technology Inventory — Unruled Masses

**Site:** https://unruledmasses.org
**Audit date:** 2026-03-22
**Source:** Local repo at `/Users/timarnold/sites-personal/um-launch-page`

---

## 1. Framework and Runtime

| Component | Version | Status | Notes |
|---|---|---|---|
| Next.js | ^16.1.6 | Current | App Router, ISR, server actions |
| React | ^19.2.4 | Current | Latest stable |
| TypeScript | ^5.9.3 | Current | Strict mode enabled |
| Tailwind CSS | 4.1.12 | Current | Using `@tailwindcss/postcss` plugin |
| Node.js (target) | ES2020 | — | `tsconfig.json` target |

---

## 2. Deployment Stack

| Component | Version / Value | Notes |
|---|---|---|
| Hosting | Cloudflare Pages | |
| Adapter | `@opennextjs/cloudflare` ^1.16.1 | **SSRF vulnerability in <1.17.1** |
| Build adapter | `@opennextjs/aws` (transitive) | Pulls in AWS SDK — high CVE surface |
| Incremental cache | Cloudflare KV (`NEXT_INC_CACHE_KV`) | Namespace ID: 16966c3dd98c480cae6ed9d32f9aef6b |
| Tag cache | Cloudflare D1 (`um-launch-page-tags`) | Database ID: 5a6e96f5-b58e-4b90-9826-e941d018c0b8 |
| Wrangler | ^4.61.0 | Deploy CLI — HIGH vulnerability (via miniflare/undici) |
| Compatibility date | 2025-12-30 | Cloudflare Workers compat |

---

## 3. CMS

| Component | Version | Notes |
|---|---|---|
| Sanity | ^4.22.0 | Studio embedded at `/studio` |
| next-sanity | ^11.6.12 | Live preview, draft mode |
| @sanity/image-url | ^1.2.0 | Image URL builder |
| @sanity/vision | ^4.22.0 | GROQ query tool in Studio |
| @portabletext/react | ^6.0.2 | Rich text rendering |
| Sanity API version | 2026-01-30 | Recent |
| Dataset | production | |
| Studio auth | Sanity-managed (project members) | Studio not behind site password |

### Schema types

| Type | Kind | CMS-editable | Notes |
|---|---|---|---|
| `launchPage` | Singleton | Partial — 3/11 sections | Hero, Problem, HowWeWork migrated; 8 sections use fallback defaults |
| `ourTeamPage` | Singleton | Yes | |
| `newsArticle` | Collection | Yes | Slug-based routing |
| `teamMember` | Collection | Yes | |
| `siteSettings` | Singleton | Yes | Tagline, social links, legal line |
| `headerNavigation` | Singleton | Yes | Nav items, CTA buttons |
| `privacyPolicy` | Singleton | Yes | |
| `termsOfService` | Singleton | Yes | |
| `pressBoilerplate` | Singleton | Yes | |

---

## 4. Third-Party Integrations

| Service | Purpose | Credential(s) | Location |
|---|---|---|---|
| Google Analytics 4 | Analytics | `NEXT_PUBLIC_GA_MEASUREMENT_ID` | Env var |
| Mailchimp | Newsletter subscription | `MAILCHIMP_API_KEY`, `MAILCHIMP_LIST_ID`, `MAILCHIMP_DC` | Env var |
| Resend | Transactional email (contact form) | `RESEND_API_KEY` | Env var |
| Cloudflare Turnstile | Bot protection | `NEXT_PUBLIC_TURNSTILE_SITE_KEY`, `TURNSTILE_SECRET_KEY` | Env var |
| Donorbox | Donation widget | Campaign ID in Sanity | Loaded dynamically on modal open |
| Vimeo | Hero video | None — public embed | Loaded only when user opens modal |
| Cloudflare KV/D1 | ISR cache | Bound at runtime via Wrangler | wrangler.jsonc |
| Cloudflare Zone API | Cache purge on revalidate | `CLOUDFLARE_ZONE_ID`, `CLOUDFLARE_API_TOKEN` | Env var |
| UptimeRobot | Uptime monitoring | Not in codebase | External service |

---

## 5. Dependency Audit

### Direct runtime dependencies

| Package | Version | Vulnerability | Notes |
|---|---|---|---|
| `next` | ^16.1.6 | None known | |
| `react` / `react-dom` | ^19.2.4 | None known | |
| `@opennextjs/cloudflare` | ^1.16.1 | **HIGH SSRF** GHSA-c7mq-gh6q-6q7c | Fix: update to ≥1.17.1 |
| `sanity` | ^4.22.0 | None direct | |
| `next-sanity` | ^11.6.12 | None direct | |
| `@radix-ui/react-dialog` | ^1.1.15 | None known | |
| `lucide-react` | 0.487.0 | None known | |
| `styled-components` | ^6.3.8 | None known | **Not imported anywhere — dead dependency** |
| `clsx` | 2.1.1 | None known | |
| `tailwind-merge` | 3.2.0 | None known | |
| `tw-animate-css` | 1.3.8 | None known | |

### Direct dev dependencies

| Package | Version | Vulnerability | Notes |
|---|---|---|---|
| `wrangler` | ^4.61.0 | **HIGH** via miniflare/undici | Dev/deploy tool only, not runtime |
| `@playwright/test` | ^1.57.0 | None direct | Dev only |
| `lighthouse` | ^12.8.2 | None direct | Dev only |
| `puppeteer` | ^24.35.0 | None direct | Dev only |
| `typescript` | ^5.9.3 | None known | Dev only |

### Critical/High transitive vulnerabilities

| Package | Severity | CVE / Advisory | Description | Exposed at runtime? |
|---|---|---|---|---|
| `fast-xml-parser` | CRITICAL | GHSA-m7jm-9gc2-mpf2 (CVSS 9.3) | Entity encoding bypass via regex injection in DOCTYPE entity names | Unlikely — via `@opennextjs/aws` build tooling |
| `fast-xml-parser` | HIGH | GHSA-37qj-frw5-hhjh | RangeError DoS via numeric entities | Unlikely |
| `basic-ftp` | CRITICAL | GHSA-5rq4-664w-9x2c (CVSS 9.1) | Path traversal in `downloadToDir()` | No — FTP not used in app |
| `rollup` | HIGH | GHSA-mw96-cpmx-2vgc | Arbitrary file write via path traversal | No — build tool only |
| `undici` | HIGH | GHSA-f269-vfmq-vjvj | WebSocket 64-bit length parser overflow | No — dev tooling only |
| `undici` | HIGH | GHSA-vrm6-8vpv-qv8q | Unbounded WebSocket memory consumption | No — dev tooling only |
| `minimatch` | HIGH | GHSA-3ppc-4f35-3m26 | ReDoS via repeated wildcards | No — build/dev only |
| `@isaacs/brace-expansion` | HIGH | GHSA-7h2j-956f-4vf2 | Uncontrolled resource consumption | No — build/dev only |

**Summary:** `npm audit` reports 4 critical, 8 high. All critical and most high vulnerabilities are in transitive dependencies of dev/build tools (`wrangler`, `@opennextjs/aws`, `rollup`). The only direct runtime-relevant vulnerability is `@opennextjs/cloudflare` <1.17.1 (HIGH, SSRF). Fix with `npm update @opennextjs/cloudflare`.

---

## 6. Custom API Routes

| Route | Method | Auth | Purpose |
|---|---|---|---|
| `POST /api/contact` | POST | Turnstile + Origin | Contact form submission → Resend email |
| `POST /api/newsletter` | POST | Turnstile + Origin | Newsletter signup → Mailchimp |
| `POST /api/auth/verify` | POST | None (public) | Site password verification → sets HTTP-only cookie |
| `GET /api/auth/verify` | GET | None (public) | Check auth status |
| `POST /api/revalidate` | POST | Bearer token (+ legacy query param) | Sanity webhook → ISR cache purge |
| `GET /api/draft-mode/enable` | GET | Sanity token | Enable draft mode for Sanity visual editing |

---

## 7. Environment Variables

| Variable | Exposure | Required | Notes |
|---|---|---|---|
| `SITE_PASSWORD` | Server only | No | If unset, password gate disabled |
| `NEXT_PUBLIC_TURNSTILE_SITE_KEY` | Public (client) | Yes (production) | Safe to expose |
| `TURNSTILE_SECRET_KEY` | Server only | Yes (production) | |
| `RESEND_API_KEY` | Server only | Yes (production) | |
| `CONTACT_EMAIL` | Server only | Yes | Destination for contact form emails |
| `MAILCHIMP_API_KEY` | Server only | Yes (production) | |
| `MAILCHIMP_LIST_ID` | Server only | Yes (production) | |
| `MAILCHIMP_DC` | Server only | Yes (production) | Mailchimp datacenter prefix |
| `NEXT_PUBLIC_GA_MEASUREMENT_ID` | Public (client) | No | If unset, GA4 script not loaded |
| `NEXT_PUBLIC_SANITY_PROJECT_ID` | Public (client) | Yes | Safe — Sanity CDN is public |
| `NEXT_PUBLIC_SANITY_DATASET` | Public (client) | Yes | |
| `SANITY_REVALIDATE_SECRET` | Server only | Yes (production) | Webhook auth token |
| `SANITY_VIEWER_TOKEN` | Server only | Yes (draft mode) | Draft-mode read access |
| `CLOUDFLARE_ZONE_ID` | Server only | Optional | Cache purge on revalidate |
| `CLOUDFLARE_API_TOKEN` | Server only | Optional | Cache purge on revalidate |

---

## 8. Security Headers (next.config.ts)

Applied to all routes except `/studio`:

| Header | Value | Status |
|---|---|---|
| `X-Content-Type-Options` | `nosniff` | ✓ |
| `Content-Security-Policy` | `frame-ancestors 'self' https://sanity.io https://*.sanity.io` | ✓ Partial (frame-ancestors only) |
| `X-XSS-Protection` | `1; mode=block` | ✓ (legacy — modern browsers use CSP) |
| `Referrer-Policy` | `strict-origin-when-cross-origin` | ✓ |
| `Permissions-Policy` | `camera=(), microphone=(), geolocation=()` | ✓ |
| `Strict-Transport-Security` (HSTS) | **Not configured** | ✗ Missing |

---

## 9. Dead Code / Technical Debt

| Item | Location | Issue |
|---|---|---|
| `production.tar.gz` | Repo root | 12MB binary archive committed to git |
| `dist/` directory | Repo root | Leftover from pre-migration Vite build (Jan 2026) |
| `DonationTier.tsx` | `src/app/components/DonationTier.tsx` | Component never imported anywhere |
| `styled-components` | `package.json` dependencies | Never imported in source — dead dependency |
| Legacy `/playbooks` route | `src/app/(site)/playbooks/` | Route exists but pages return empty content; links go to 404 on live site |
| Legacy query param in revalidate | `src/app/(site)/api/revalidate/route.ts` L60 | `?secret=` fallback logs token in server logs |
| 8 un-migrated Sanity sections | `src/app/components/sections/` | CMS data not wired up; fallback hardcoded defaults |

---

## 10. CI/CD

| Check | Status | Notes |
|---|---|---|
| CI pipeline | Not configured | No `.github/workflows/`, no Cloudflare CI |
| Deployment | Manual via `npm run deploy` | `opennextjs-cloudflare build && deploy` |
| E2E tests | Playwright, local only | 5 spec files; run against localhost |
| Pre-deploy test run | Not enforced | No CI gate before deploy |
| Dependency auditing in CI | Not configured | `npm audit` not in any automated step |
