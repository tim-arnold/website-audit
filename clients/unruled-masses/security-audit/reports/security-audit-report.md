# Security Audit Report — Unruled Masses

**Site:** https://unruledmasses.org
**Audit date:** 2026-03-22
**Stack:** Next.js 16 · Sanity v4 CMS · Cloudflare Pages via OpenNext
**Method:** Passive live-site inspection (Playwright) — no active probing or exploitation

> **Scope note:** This report covers only findings not already documented in the technology audit (`technology-audit/reports/technology-audit-report.md`). Cross-reference that report for: dependency CVEs (including the OpenNext SSRF), missing HSTS, full security header inventory, CSRF/Turnstile/XSS protection, auth cookie configuration, the revalidate `?secret=` webhook leak, and `production.tar.gz` in the git repository.

---

## Executive Summary

- The live-site security posture is strong. All sensitive file paths (`.env`, `.git`, `production.tar.gz`) correctly return 404 and are not web-accessible. No cookies are set before user consent. No framework version or credentials are disclosed in HTML.
- **One medium-severity compliance issue:** GA4 fires cookieless pings to Google servers before the user accepts the consent dialog (Consent Mode v2 behavior). Under strict GDPR/ePrivacy interpretations, transmitting a session client ID and browser fingerprint to Google before consent may be non-compliant. The Privacy Policy should explicitly disclose this.
- **Three low-severity findings:** no Subresource Integrity on third-party scripts; `/studio` has security headers excluded from its route; and several response headers expose framework internals (`x-opennext`, `x-nextjs-*`).
- **`robots.txt`** unnecessarily advertises the CMS admin path (`/studio`) and all API routes (`/api/`) to crawlers and attackers — a minor enumeration aid.
- The `expect-ct` header is deprecated since 2022 and should be removed when the header config is next updated.

---

## 1. Transport and HTTPS

HTTPS is correctly enforced. All pages load over TLS. The `server: cloudflare` header reveals no server version. HTTP → HTTPS redirect behavior was not directly tested but is expected given Cloudflare Pages defaults.

**HSTS is missing** — confirmed on the live site. This is documented in the technology audit (item H-2) with a specific fix. Not repeated here.

---

## 2. Sensitive Path Exposure

All tested paths return 404 with no content leakage:

| Path | Status |
|---|---|
| `/.env` | 404 ✓ |
| `/.git/HEAD` | 404 ✓ |
| `/.git/config` | 404 ✓ |
| `/production.tar.gz` | 404 ✓ |
| `/wp-config.php` | 404 ✓ |
| `/api/revalidate` (GET) | 405 ✓ |

`production.tar.gz` is committed to the git repository (tech audit C-2) but is not served via HTTP. The git exposure risk remains — see the technology audit for remediation.

---

## 3. Information Disclosure

### Framework Fingerprinting via Response Headers

The following headers are present on every response and expose the full technology stack:

| Header | Value | Reveals |
|---|---|---|
| `x-opennext` | `1` | OpenNext adapter (Cloudflare) |
| `x-nextjs-cache` | `HIT` | Next.js ISR cache |
| `x-nextjs-prerender` | `1,1` | Next.js prerendering |
| `x-nextjs-stale-time` | `300` | Next.js cache config |
| `vary` | `rsc, next-router-state-tree, ...` | React Server Components |

These headers allow any passive observer to identify the exact stack and target known CVEs. Removing `x-opennext` and `x-nextjs-*` headers requires changes to the OpenNext adapter or a Cloudflare Worker transform — they cannot be removed via `next.config.ts` alone.

**Practical risk:** Low. The stack is already inferred from `_next/` asset paths. However, these headers make fingerprinting trivial and precise.

**HTML source is clean:** No `meta[name="generator"]`, no HTML comments with version numbers, no `X-Powered-By`. ✓

### `/studio` Path and Headers

The Sanity Studio admin interface is accessible at the well-known path `/studio` (returns 200). Sanity's own authentication loads before any CMS content is accessible — this is correct. However:

1. **Predictable path:** The `/studio` path is standard for Sanity and is also listed in `robots.txt`. Any attacker targeting Sanity vulnerabilities knows exactly where the admin UI is.
2. **Security headers excluded:** The `next.config.ts` security header middleware explicitly excludes `/studio` from applying headers. As a result, `/studio` serves without `Content-Security-Policy` or `Permissions-Policy` — the only route on the site without these headers.

The practical risk is low given Sanity handles its own auth, but if a Sanity Studio XSS vulnerability were discovered, the missing CSP provides no frame of containment.

### `robots.txt` Path Disclosure

```
Disallow: /studio
Disallow: /api/
Disallow: /playbooks
```

This enumerates the CMS admin path and confirms the existence of all API routes to any observer. Robots.txt is public by design and security through obscurity is not a meaningful defense — however, explicitly advertising `/api/` removes even that minimal friction. Consider removing `/studio` and `/api/` from `robots.txt` (they don't need to be listed to prevent indexing; unlisted paths are not crawled by default).

---

## 4. Cookies and Pre-Consent Data Transmission

**Cookies before consent:** None. `document.cookie` is empty on page load. GA4 does not write a persistent cookie before the user accepts the consent dialog. ✓

**GA4 Consent Mode v2 pre-consent pings:**

GA4 fires network requests to `www.google-analytics.com` immediately on page load, before any consent interaction, with:
- `gcs=G100` — no consent granted
- `npa=1` — no personalized ads
- `pscdl=denied` — consent denied
- `cid=...` — a session-scoped client identifier
- Browser fingerprint fields: `uaa` (CPU arch), `uab` (bitness), `uafvl` (full browser version), `uap` (platform), `sr` (screen resolution)

This is the designed behavior of Google's Consent Mode v2 — pings are sent for conversion modeling without persistent cookies. However, under strict readings of GDPR Article 5 and the ePrivacy Directive, *any* transmission of data to a third party (Google) that allows even partial identification — including a session client ID and browser fingerprint — may require prior consent.

**Risk:** Medium (compliance). This is not a code defect but a product/legal decision. The Privacy Policy should explicitly disclose that Google Analytics fires in a cookieless, restricted mode before consent is given. Legal review is recommended for jurisdictions with strict ePrivacy enforcement (EU, UK, Germany specifically).

---

## 5. Third-Party Scripts and SRI

| Script | SRI | Practical mitigations |
|---|---|---|
| `www.googletagmanager.com/gtag/js` | None | Google does not support SRI for gtag.js (dynamically generated) |
| `challenges.cloudflare.com/turnstile/v0/api.js` | None | Cloudflare does not document SRI support for Turnstile |

Neither external script carries a `integrity` (SRI) hash. If the respective CDN were compromised, arbitrary JavaScript could be injected into every page visitor's browser with no browser-level protection. The absence of a `script-src` CSP (technology audit item L-5) means there is no secondary control either.

**Practical risk:** Low. Both Google and Cloudflare operate major global CDNs with their own security programs. CDN compromise at this level would be a sector-wide incident. This is a defense-in-depth gap rather than an active vulnerability.

---

## 6. Deprecated Header

`expect-ct: max-age=86400, enforce` is present on all responses. This header was deprecated in 2022 — Certificate Transparency enforcement is now mandatory in all major browsers and does not require the header. It is harmless but is dead configuration weight. Remove it when the header config in `next.config.ts` is next updated.

---

## Remediation Checklist

### Medium (compliance risk — address before significant EU traffic or legal review)

| # | What | Risk | Fix | Effort |
|---|---|---|---|---|
| S-1 | GA4 fires cookieless pings before consent | GDPR/ePrivacy compliance — data sent to Google before consent | Update Privacy Policy to disclose Consent Mode v2 behavior; consult legal counsel on whether pre-consent pings meet ePrivacy requirements for target jurisdictions | 1–2 hrs legal review + copy update |

### Low (defense in depth — address in planned work)

| # | What | Risk | Fix | Effort |
|---|---|---|---|---|
| S-2 | No SRI on third-party scripts (GA4, Turnstile) | CDN compromise would allow script injection with no browser-level protection | Not fixable without switching analytics providers; document as accepted risk | 30 min to document |
| S-3 | `/studio` excluded from security header middleware | XSS in Sanity Studio would have no CSP containment | Add `/studio` to the security header middleware in `next.config.ts`, or apply a Studio-specific CSP that allows Sanity's required origins | 1–2 hrs |
| S-4 | Framework fingerprinting via `x-opennext`, `x-nextjs-*` headers | Eases stack-specific CVE targeting | Add a Cloudflare Worker transform rule to strip these response headers; or accept as low-risk given `_next/` assets already reveal the stack | 1–2 hrs |
| S-5 | `robots.txt` discloses `/studio` and `/api/` | Minor enumeration aid | Remove `/studio` and `/api/` from `robots.txt` — these paths don't need to be listed to remain unindexed | 15 min |

### Informational (config hygiene — do when touching headers)

| # | What | Fix | Effort |
|---|---|---|---|
| S-6 | `expect-ct` deprecated header | Remove from `securityHeaders` array in `next.config.ts` | 5 min |
| S-7 | `referrer-policy: same-origin` — affects analytics attribution | Intentional or oversight? If analytics attribution from outbound links matters, change to `strict-origin-when-cross-origin`. If full privacy is preferred, keep as-is. | 5 min |

---

## What Was Checked and Passed

| Check | Result |
|---|---|
| Sensitive file paths (`.env`, `.git`, `production.tar.gz`) | 404 — not web-accessible ✓ |
| Cookies before consent | None set ✓ |
| Framework version in HTML | Not disclosed ✓ |
| HTML comments — information disclosure | None ✓ |
| `/api/revalidate` GET rejection | 405 ✓ |
| `/studio` cache headers | `no-store, no-cache` — correctly non-cacheable ✓ |
| Sanity Studio auth | Required before CMS access ✓ |
| Server header | `cloudflare` only — no version ✓ |
