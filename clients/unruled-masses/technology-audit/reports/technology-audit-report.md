# Technology Audit Report — Unruled Masses

**Site:** https://unruledmasses.org
**Audit date:** 2026-03-22
**Codebase:** `/Users/timarnold/sites-personal/um-launch-page`
**Stack:** Next.js 16 + React 19 + TypeScript · Sanity v4 CMS · Cloudflare Pages via OpenNext

---

## Executive Summary

- The stack is modern and well-chosen: Next.js 16 on Cloudflare Pages via OpenNext, Sanity v4 CMS, React 19, Tailwind 4 — all current, none EOL. Overall technical quality is high.
- **One High-severity runtime vulnerability** requires an immediate update: `@opennextjs/cloudflare` <1.17.1 has a confirmed SSRF vulnerability (GHSA-c7mq-gh6q-6q7c). A single `npm update` fixes it.
- All other `npm audit` findings (4 critical, 7 high) are in transitive build/dev dependencies not exposed to user input — no live-site attack surface.
- A **12MB `production.tar.gz` archive is committed to the git repo**. This should be removed immediately and git history scrubbed — binary archives in version control are a source of credential leakage and repo bloat.
- The security architecture is genuinely strong: CSRF protection, Turnstile bot protection, input validation, HTML escaping, HTTP-only cookies, security headers, and Cloudflare Project Galileo DDoS coverage are all correctly implemented.
- The Sanity revalidate webhook still accepts a `?secret=` query parameter as a fallback — this logs the secret token in server access logs. The header-based auth is already in place; the query param fallback should be removed.
- `HSTS` (Strict-Transport-Security) is the only missing security header. All others are configured.
- **No hardcoded credentials found** anywhere in the source tree. All secrets are in environment variables.
- The `dist/` directory (old Vite build) and `DonationTier.tsx` component are dead code that should be cleaned up. `styled-components` is listed as a dependency but never imported.
- No CI/CD pipeline exists — deploys are manual. Adding at minimum a `npm run build && npm audit --audit-level=high` gate before deploy would catch the current vuln class automatically.

---

## 1. Architecture Overview

| Dimension | Detail |
|---|---|
| Framework | Next.js 16, App Router |
| Runtime | React 19, TypeScript 5.9 (strict mode) |
| Rendering | Hybrid: SSR + ISR via Next.js cache + Cloudflare KV tag cache |
| CMS | Sanity v4, headless, Studio embedded at `/studio` |
| Hosting | Cloudflare Pages (via OpenNext adapter) |
| Caching | Next.js ISR + Cloudflare KV incremental cache + D1 tag cache |
| Styling | Tailwind CSS 4 |
| Structure | Monorepo: Next.js app + embedded Sanity Studio |

The architecture is sound: server components handle data fetching, client components handle interactivity, and Sanity manages content with live preview via Presentation Tool. The OpenNext adapter wraps Next.js for Cloudflare Workers compatibility.

One architectural note: the CLAUDE.md states 8 of 11 page sections are not yet wired to Sanity — they use hardcoded fallback defaults. This means content changes to those sections currently require code deploys rather than CMS edits. This is a maintainability issue, not a security risk, but it's the most significant outstanding build task.

---

## 2. Dependency Security

### Vulnerability Summary

`npm audit` output (2026-03-22): **4 critical, 8 high, 6 moderate, 9 low** total vulnerabilities.

Despite the alarming count, only one is a live-site concern:

### Critical: `@opennextjs/cloudflare` SSRF (GHSA-c7mq-gh6q-6q7c)

**Severity:** High
**Package:** `@opennextjs/cloudflare` (direct dependency)
**Affected range:** ≤1.17.0
**Current version:** ^1.16.1 (will have resolved to 1.16.x)
**Description:** SSRF vulnerability via `/cdn-cgi/` path normalization bypass. The adapter can be tricked into making server-side requests to internal resources.
**Fix:** `npm update @opennextjs/cloudflare` — the semver range `^1.16.1` allows upgrading to 1.17.x. After update, verify `node_modules/@opennextjs/cloudflare/package.json` shows ≥1.17.1.

### Build/dev-only vulnerabilities (not live-site attack surface)

All remaining critical and high findings are in transitive dependencies of dev/deploy tooling:

| Package | Severity | Advisory | Description | Path |
|---|---|---|---|---|
| `fast-xml-parser` | CRITICAL | GHSA-m7jm-9gc2-mpf2 (CVSS 9.3) | Entity encoding bypass, regex injection | `@opennextjs/aws` → `@aws-sdk/*` |
| `basic-ftp` | CRITICAL | GHSA-5rq4-664w-9x2c (CVSS 9.1) | Path traversal in `downloadToDir()` | `@opennextjs/aws` → build tools |
| `rollup` | HIGH | GHSA-mw96-cpmx-2vgc | Arbitrary file write, path traversal | Dev bundler |
| `undici` | HIGH (multiple) | GHSA-f269-vfmq-vjvj, etc. | WebSocket parser overflow, memory issues | `wrangler` → `miniflare` |
| `minimatch` | HIGH (multiple) | GHSA-3ppc-4f35-3m26 | ReDoS via repeated wildcards | Build tooling |

None of these packages handle user input at runtime. The attack surfaces (FTP downloads, XML parsing from untrusted sources, glob expansion on user data) are not present in this application. They are flagged here for completeness and to unblock `npm audit --audit-level=high` in CI once the OpenNext update is applied.

Fixing these transitive vulnerabilities requires upstream releases of `@opennextjs/cloudflare` or `wrangler`. Track `@opennextjs/cloudflare` releases for dependency tree updates.

---

## 3. Content and Data Model

The Sanity content model is well-organized with a clean separation between singletons and collections:

**Singletons** (one document per type, protected from deletion in Studio): `launchPage`, `ourTeamPage`, `privacyPolicy`, `termsOfService`, `pressBoilerplate`, `siteSettings`, `headerNavigation`

**Collections** (multiple documents): `newsArticle`, `teamMember`

The model has no detected orphaned types or duplicate fields. Singleton protection is correctly configured in `sanity.config.ts` — the "new document" button and delete action are both disabled for singleton types.

**Sanity Studio authentication:** Studio at `/studio` is protected by Sanity's own authentication (project member access). It is not behind the site password gate — this is intentional and correct. Sanity requires editors to be authenticated project members.

**Incomplete CMS migration:** Per CLAUDE.md, 8 of 11 homepage sections still use hardcoded content fallbacks rather than CMS-fetched data. The sections not yet migrated include the DeepDive/Playbook, Donate, Support, and several others. Until migrated, content changes require code edits and deploys. This is the biggest outstanding development task.

---

## 4. Third-Party Integrations

| Service | Integration Method | Spam/Abuse Protection | Data Storage |
|---|---|---|---|
| Google Analytics 4 | Direct gtag.js, Consent Mode v2 | N/A | Google |
| Mailchimp | Server-side API (newsletter route) | Turnstile + Origin validation | Mailchimp |
| Resend | Server-side API (contact route) | Turnstile + Origin + input validation | Email delivery only |
| Cloudflare Turnstile | Invisible widget on all forms | — | Cloudflare |
| Donorbox | Dynamic `<script>` load on modal open | Donorbox's own fraud detection | Donorbox |
| Vimeo | Lazy `<iframe>` on modal open | N/A | Vimeo |
| Cloudflare KV/D1 | Runtime bindings via wrangler | N/A | Cloudflare edge |

All server-side integrations (Mailchimp, Resend, Cloudflare cache purge) use environment variables for credentials. No credentials are hardcoded in source.

**Newsletter single opt-in:** The Mailchimp integration uses `status: 'subscribed'` (single opt-in) in both `/api/newsletter` and `/api/contact`. Depending on subscriber geography, double opt-in may be required under GDPR/CASL. This is a compliance consideration, not a code defect.

**Donorbox `<dbox-widget>` custom element:** The Donorbox widget is loaded dynamically only when the donation modal opens, which is good for performance. However, `<dbox-widget>` is a third-party custom element with no local accessibility guarantees — this should be tested directly with a screen reader once a donation is attempted. See also the accessibility audit's finding on the donation modal.

---

## 5. Application Security

The security posture is strong. Key mechanisms:

| Protection | Implementation | Status |
|---|---|---|
| CSRF | `isValidOrigin()` validates `Origin` header on all POST routes | ✓ |
| Bot protection | Cloudflare Turnstile on contact + newsletter forms | ✓ |
| XSS prevention | `escapeHtml()` applied to all user input before HTML inclusion | ✓ |
| Input validation | `validateContactForm()` validates format + length on all fields | ✓ |
| Auth cookie | HTTP-only, `secure: true` in production, `SameSite: strict`, 24h TTL | ✓ |
| Password comparison | Plain string comparison (no bcrypt) | Acceptable for a simple gate; not suitable if this becomes real auth |
| Sanity webhook auth | Bearer token via `Authorization` header (preferred) | ✓ |
| Sanity webhook legacy param | `?secret=` query param fallback still active | ⚠ Logs token in server access logs |
| Draft mode | `SANITY_VIEWER_TOKEN` server-only, not exposed to client | ✓ |
| No hardcoded credentials | All API keys in env vars; `.env.example` shows pattern | ✓ |

**Security headers:** All configured headers are correctly applied. One header is missing:

| Header | Status | Risk |
|---|---|---|
| `X-Content-Type-Options` | ✓ nosniff | — |
| `Content-Security-Policy` | ✓ frame-ancestors only | Note: only restricts framing; no script-src policy |
| `X-XSS-Protection` | ✓ 1; mode=block | Legacy; fine to keep |
| `Referrer-Policy` | ✓ strict-origin-when-cross-origin | — |
| `Permissions-Policy` | ✓ camera/mic/geo blocked | — |
| `Strict-Transport-Security` | ✗ **Missing** | Browsers may not enforce HTTPS on first visit |

---

## 6. Performance and Configuration

| Area | Status | Notes |
|---|---|---|
| Next.js Image optimization | Not used | All images use `<img>` with hardcoded string paths to WebP files. Next.js `<Image>` would provide automatic srcset, size optimization, and better LCP. |
| Image format | WebP | Images already converted to WebP. Direct `<img>` with `loading="lazy"` is correct. |
| Video loading | Lazy (modal only) | Vimeo embed only loads when user opens modal. Good. |
| Donorbox script | Lazy (modal only) | Loaded only when donate button is clicked. Good. |
| GA4 script | `strategy="afterInteractive"` | Does not block rendering. |
| Turnstile | Invisible + lazy | No UI friction; loads with page. |
| Cache: KV incremental | Configured | ISR responses cached in Cloudflare KV. |
| Cache: D1 tag cache | Configured | Tag-based revalidation via Cloudflare D1. |
| Cache: Sanity webhook | Configured | Webhook triggers path + tag revalidation + Cloudflare CDN purge. |
| Security headers | Applied | Applied to all routes except `/studio`. |
| HSTS | Missing | See security section. |

The caching architecture is notably sophisticated: Sanity content changes trigger Next.js tag revalidation AND Cloudflare CDN purge via the revalidate webhook. This is correct and well-implemented.

---

## 7. Custom Functionality and Code Quality

**Positive patterns:**
- TypeScript strict mode across the entire codebase — no `any` escape hatches in reviewed code
- Server/client component split is clean — `'use client'` only where hooks or browser APIs are needed
- Fallback pattern on all Sanity-driven components ensures the site functions if CMS is unavailable
- Security utilities (`sanitize.ts`, `validation.ts`, `turnstile.ts`) are extracted as tested helpers, not inline

**Issues found:**

`production.tar.gz` — A 12MB binary archive is committed directly to the git repository root. This is almost certainly a leftover from the January 2026 Vite → Next.js migration. Binary files in git are a long-term problem:
- They can't be diffed or reviewed
- If the archive contains a `.env` or compiled assets with embedded env values, they persist in git history indefinitely even after deletion
- They inflate every clone of the repo by 12MB permanently

`dist/` directory — The old Vite build output is present in the repo. This should be gitignored and removed.

`DonationTier.tsx` — A component at `src/app/components/DonationTier.tsx` that is never imported anywhere in the codebase. Dead code from a previous donation tier design.

`styled-components` v6.3.8 — Listed as a production dependency in `package.json` but not imported anywhere in the source tree. Adds ~40KB to the dependency tree and could introduce security surface without providing value.

**Revalidate legacy query param (`src/app/(site)/api/revalidate/route.ts` lines 60–78):**
The endpoint accepts `?secret=TOKEN` as a fallback for backwards compatibility with an older Sanity webhook. The comment acknowledges this is deprecated. Server logs record query parameters, which means any webhook call using the legacy format writes the revalidation secret to server logs. Since the Authorization header is already in place, the query param fallback should be removed.

**`/playbooks` routes** — `src/app/(site)/playbooks/page.tsx` and `src/app/(site)/playbooks/[slug]/page.tsx` exist in the codebase and are linked from the homepage, but the pages serve empty or stub content that results in 404s on the live site (confirmed in SEO audit). These need to either be implemented or the homepage links removed and routes redirected.

---

## Remediation Checklist

### Critical (fix immediately)

| # | What | Risk | Fix | Effort |
|---|---|---|---|---|
| C-1 | `@opennextjs/cloudflare` <1.17.1 — SSRF vulnerability (GHSA-c7mq-gh6q-6q7c) | Security — server-side request forgery | `npm update @opennextjs/cloudflare` then redeploy | 30 min |
| C-2 | `production.tar.gz` committed to git | Security — potential credential leakage; repo bloat | Delete file, add to `.gitignore`, scrub from git history (`git filter-repo` or `git-bfg`) | 1–2 hr |

### High (fix soon)

| # | What | Risk | Fix | Effort |
|---|---|---|---|---|
| H-1 | Revalidate endpoint: legacy `?secret=` query param logs token in server access logs | Security — secret token exposure in logs | Remove lines 60–78 in `revalidate/route.ts` that read `legacySecret`; update Sanity webhook to use `Authorization: Bearer` header only | 30 min |
| H-2 | Missing `Strict-Transport-Security` header | Security — browsers may not enforce HTTPS on first visit | Add to `securityHeaders` array in `next.config.ts`: `{ key: 'Strict-Transport-Security', value: 'max-age=63072000; includeSubDomains; preload' }` | 15 min |
| H-3 | `/playbooks` routes return empty/404 content but are linked from homepage | Stability + UX | Either implement the playbook pages or remove the nav links and add 301 redirects to the homepage | 2–4 hr |
| H-4 | No CI/CD pipeline | Stability — no automated gate prevents broken deploys | Add a GitHub Actions workflow: `npm ci && npm run build && npm audit --audit-level=high` on push to main | 2–4 hr |

### Medium (planned work)

| # | What | Risk | Fix | Effort |
|---|---|---|---|---|
| M-1 | 8 homepage sections not wired to Sanity CMS | Maintainability — content changes require code deploys | Complete Sanity migration for remaining sections; follow the pattern of `HeroSection.tsx` (accepts optional `data` prop with fallback) | 1–2 sprints |
| M-2 | No `next/image` usage — manual `<img>` tags with WebP paths | Performance — no automatic srcset, size optimization, or LCP prioritization | Incrementally replace `<img>` with `next/image` `<Image>` on high-traffic pages (homepage hero, team photos) | 1–2 days |
| M-3 | Newsletter uses single opt-in (`status: 'subscribed'`) | Compliance — GDPR/CASL in some jurisdictions require double opt-in | Change `status` from `'subscribed'` to `'pending'` in `/api/newsletter` and `/api/contact` routes to trigger Mailchimp confirmation email | 1 hr |
| M-4 | `dist/` Vite build artifacts in repo | Maintainability — dead files, repo bloat | Add `dist/` to `.gitignore`, remove from tracking | 30 min |

### Low (backlog)

| # | What | Risk | Fix | Effort |
|---|---|---|---|---|
| L-1 | `DonationTier.tsx` — dead component | Maintainability | Delete `src/app/components/DonationTier.tsx` | 5 min |
| L-2 | `styled-components` — dead dependency | Maintainability, minor security surface | Remove from `package.json` dependencies | 15 min |
| L-3 | `npm audit` high/critical in transitive dev deps | Hygiene — blocks clean CI audit output | Track `@opennextjs/cloudflare` and `wrangler` releases; update when upstreams publish fixes | Ongoing |
| L-4 | Auth password comparison not constant-time | Security (minor) — timing oracle on password check; fine for simple gate | Use `crypto.timingSafeEqual()` in `route.ts` auth verify if password gate is kept long-term | 30 min |
| L-5 | CSP `frame-ancestors` only — no `script-src` directive | Security (defense in depth) | Add a `script-src` CSP policy; this is complex due to Next.js inline scripts and requires nonce implementation | 1–3 days |

---

## Quick Wins Summary

These three items together require under 2 hours total and address the most significant risks:

1. **`npm update @opennextjs/cloudflare && npm run deploy`** — patches the only live-site CVE
2. **Delete `production.tar.gz`, add to `.gitignore`, scrub git history** — eliminates potential credential exposure in repo
3. **Remove legacy `?secret=` param from revalidate route** — stops logging the webhook secret
