# Security Findings — Unruled Masses

**Site:** https://unruledmasses.org
**Audit date:** 2026-03-22
**Audit type:** Passive live-site inspection (Playwright) + source review
**Scope:** Items NOT already covered by the technology audit. See `technology-audit/reports/technology-audit-report.md` for: dependency CVEs, HSTS, security header inventory, CSRF/Turnstile/XSS/validation mechanisms, auth cookie config, `?secret=` webhook leak, `production.tar.gz` in git, and hardcoded credential review.

---

## Pass 1: Live Response Headers (Homepage)

Actual headers served on `GET https://unruledmasses.org/`:

| Header | Value |
|---|---|
| `content-security-policy` | `frame-ancestors 'self' https://sanity.io https://*.sanity.io` |
| `x-frame-options` | `SAMEORIGIN` |
| `x-content-type-options` | `nosniff` |
| `referrer-policy` | `same-origin` |
| `permissions-policy` | `camera=(), microphone=(), geolocation=()` |
| `strict-transport-security` | **NOT PRESENT** (confirmed live) |
| `x-xss-protection` | `1; mode=block` |
| `server` | `cloudflare` (no version) |
| `x-opennext` | `1` ← framework fingerprint |
| `x-nextjs-cache` | `HIT` ← framework fingerprint |
| `x-nextjs-prerender` | `1,1` ← framework fingerprint |
| `x-nextjs-stale-time` | `300` ← framework fingerprint |
| `vary` | `rsc, next-router-state-tree, next-router-prefetch, ...` ← RSC fingerprint |
| `expect-ct` | `max-age=86400, enforce` ← deprecated header |
| `cache-control` | `s-maxage=1669, stale-while-revalidate=2592000` |

**Note on `referrer-policy`:** Live site serves `same-origin`, which sends no referrer on cross-origin requests. This is more restrictive (more private) than `strict-origin-when-cross-origin`. Both are acceptable security postures; the practical effect is that GA4 and third-party sites receive no referrer attribution from outbound clicks. Not a security defect, but a behavioral difference worth documenting.

---

## Pass 2: /studio Headers and Access

`GET https://unruledmasses.org/studio` → **200 OK**

| Header | Value |
|---|---|
| `cache-control` | `private, no-cache, no-store, max-age=0, must-revalidate` ✓ |
| `content-security-policy` | **NOT PRESENT** |
| `permissions-policy` | **NOT PRESENT** |
| `x-xss-protection` | `nosniff` |
| `x-frame-options` | `SAMEORIGIN` |

Security headers (CSP, Permissions-Policy) are explicitly excluded from the `/studio` route in `next.config.ts`. The Studio is accessible at its default, well-known path. Sanity's own authentication loads in the browser before any CMS content is accessible — this is correct and intentional. Cache headers are properly set to prevent caching.

---

## Pass 3: Sensitive Path Enumeration

| Path | Status | Notes |
|---|---|---|
| `/.env` | 404 | Not web-accessible ✓ |
| `/.git/HEAD` | 404 | Not web-accessible ✓ |
| `/.git/config` | 404 | Not web-accessible ✓ |
| `/production.tar.gz` | 404 | Not web-accessible via HTTP ✓ (still in git — see tech audit C-2) |
| `/wp-config.php` | 404 | Not web-accessible ✓ |
| `/api/revalidate` (GET) | 405 | Correctly rejects GET ✓ |

---

## Pass 4: Information Disclosure

**HTML source:**
- No `meta[name="generator"]` — no CMS/framework version in HTML ✓
- HTML comments: only React rendering markers (`<!--$-->`, `<!--/$-->`) — no sensitive content ✓
- No `X-Powered-By` header ✓

**Framework fingerprinting via headers:**
The following headers reveal the technology stack to any passive observer:
- `x-opennext: 1` → OpenNext adapter for Cloudflare
- `x-nextjs-cache`, `x-nextjs-prerender`, `x-nextjs-stale-time` → Next.js with ISR
- `vary: rsc, next-router-state-tree, ...` → React Server Components

These cannot be easily removed without patching OpenNext itself, but they do allow attackers to target CVEs specific to this stack.

---

## Pass 5: Cookies

`document.cookie` before consent: **empty** ✓

No first-party cookies are set before the user accepts the consent dialog. GA4 fires in Consent Mode v2 "denied" state (`gcs=G100`, `npa=1`, `pscdl=denied`) with a session-scoped client ID (`cid`) — no persistent cookie is written.

**GA4 pre-consent network pings:**
GA4 sends cookieless pings to `www.google-analytics.com` immediately on page load, before consent is given. The pings include:
- A session-scoped `cid` (client identifier)
- Browser fingerprint data (`uaa`, `uab`, `uafvl`, `uap`, `uapv`)
- Screen resolution (`sr=1512x982`)

This is the designed behavior of Consent Mode v2 — Google uses these pings for conversion modeling. However, under strict GDPR/ePrivacy interpretations, transmitting any data to Google servers before explicit consent may be non-compliant. The site's Privacy Policy should clearly disclose this behavior.

---

## Pass 6: Third-Party Scripts and SRI

External scripts loaded on homepage:

| Script | SRI | Notes |
|---|---|---|
| `www.googletagmanager.com/gtag/js?id=G-Y7JQFZ1860` | None | GA4 property ID exposed in src (expected/public) |
| `challenges.cloudflare.com/turnstile/v0/api.js` | None | Turnstile |

Neither external script has a `integrity` (SRI) attribute or `crossorigin` attribute. If either CDN were compromised, arbitrary JavaScript could be injected with no browser-level protection. The absence of a `script-src` CSP (noted in tech audit) means there is also no allowlist restricting which external scripts can execute.

SRI is intentionally not supported by Google for `gtag.js` (the file is dynamically generated per property). Cloudflare Turnstile similarly does not document SRI support. This is a fundamental limitation of both integrations — not a site configuration error — but worth documenting.

---

## Pass 7: robots.txt

```
User-agent: *
Allow: /
Disallow: /studio
Disallow: /api/
Disallow: /playbooks

Sitemap: https://unruledmasses.org/sitemap.xml
```

Observations:
- `/studio` is explicitly listed — advertises the CMS admin path to crawlers and attackers. Low impact since obscurity isn't meaningful security, but unnecessary.
- `/api/` is listed — enumerates the existence of all API routes. Attackers can probe these endpoints knowing they exist.
- `/playbooks` is listed — confirms the stub route exists (consistent with SEO and tech audit findings about broken pages).

---

## Pass 8: Browser Console — CSP Warnings

The browser console on page load shows:

```
[ERROR] Note that 'script-src' was not explicitly set,
        so 'unsafe-inline' is allowed.
```

This is emitted by the Cloudflare Turnstile iframe due to the absence of a `script-src` directive. While this confirms a finding already in the technology audit, it is visible to any attacker opening DevTools and confirms the CSP gap explicitly.

---

## Summary Table

| # | Finding | Severity | Category |
|---|---|---|---|
| S-1 | GA4 fires cookieless pings before consent (Consent Mode v2) | Medium | Compliance |
| S-2 | No SRI on third-party scripts (GA4, Turnstile) | Low | Defense in depth |
| S-3 | `/studio` at predictable path; security headers excluded from route | Low | Config |
| S-4 | Framework fingerprinting via `x-opennext`, `x-nextjs-*`, `vary` headers | Low | Info disclosure |
| S-5 | `robots.txt` discloses `/studio`, `/api/`, `/playbooks` | Low | Info disclosure |
| S-6 | `expect-ct` deprecated header present | Info | Config hygiene |
| S-7 | `referrer-policy: same-origin` (affects analytics attribution) | Info | Config |
| — | All sensitive paths return 404 | Pass | Info disclosure |
| — | No cookies before consent | Pass | Privacy |
| — | No framework version in HTML | Pass | Info disclosure |
| — | `/api/revalidate` GET correctly returns 405 | Pass | Auth |
