# Report 3: Redesign Risk Register — noblereach.org

**Audit date:** 2026-03-19
**Audience:** Dev team performing site rebuild
**Purpose:** Actionable checklist of everything that must be preserved, redirected, or fixed during the rebuild to avoid traffic and ranking loss.

---

## Executive Summary

- **88 keywords rank in positions 1–10** — any URL change without a 301 redirect loses these rankings immediately.
- **The `/talent-opportunities/scholars-program/` old URL has 33 backlinks from 27 domains** — this redirect must persist through the rebuild or it will lose the most linked non-homepage URL on the site.
- **`noblereachfoundation.org` → `noblereach.org` carries 55+ backlinks** — this domain redirect must never be removed.
- **7 pages are currently 404ing with active backlinks** — these need fixes independent of the rebuild.
- **No structured data exists anywhere** — adding Person and Article schema in the rebuild is a significant opportunity at low cost.
- **BugHerd and AppNexus scripts are loading on production** — remove before launch.

---

## 1. URL Redirect Map

Every URL below either ranks in top 10, has external backlinks, or both. A 301 redirect must be in place from the old URL to the new URL on launch day.

**Legend:** 🔴 Critical (ranks top-10 AND/OR has 5+ backlinks) | 🟡 Important (ranks 11–50 OR has backlinks) | ⬜ Monitor

### Person Pages

| Current URL | Ranks For (top keywords) | Backlinks | Action Required |
|---|---|---|---|
| `/person/kevin-stitt/` 🔴 | governor of oklahoma (6,600), who is governor of oklahoma (1,600) | 0 direct | Preserve URL exactly |
| `/person/dr-robert-m-gates/` 🔴 | robert gates (6,600), bob gates (6,600) | 0 direct | Preserve URL exactly |
| `/person/general-paul-nakasone-ret/` 🔴 | paul nakasone (1,600), nakasone (480) | 0 direct | Preserve URL exactly |
| `/person/anne-neuberger/` 🔴 | anne neuberger (1,600) | 1 | Preserve URL exactly |
| `/person/pulkit-sharma/` 🔴 | pulkit sharma (4,400) | 0 direct | Preserve URL exactly |
| `/person/arun-gupta/` 🔴 | arun gupta (720) | 19 | Preserve URL exactly |
| `/person/general-ann-dunwoody/` 🔴 | ann dunwoody (880) | 1 | Preserve URL exactly |
| `/person/vivek-kundra/` 🔴 | vivek kundra (390) | 0 direct | Preserve URL exactly |
| `/person/glenn-gaffney/` 🔴 | glenn gaffney (480), ufo/uap queries | 2 | Preserve URL exactly |
| `/person/benjamin-claflin/` 🔴 | benjamin claflin (880, rank 1) | 0 direct | Preserve URL exactly |
| `/person/calvin-yang/` 🟡 | calvin yang (390, rank 3) | 0 direct | Preserve URL exactly |
| `/person/victoria-virasingh/` 🟡 | victoria virasingh (90, rank 2) | 2 | Preserve URL exactly |
| `/person/sreenivas-sree-ramaswamy/` 🟡 | sree ramaswamy (50, rank 2) | 6 | Preserve URL exactly |
| `/person/krishnan-rajagopalan/` 🟡 | krishnan rajagopalan (70) | 7 | Preserve URL exactly |
| `/person/sharon-l-hays/` 🟡 | sharon hays (90, rank 7) | 0 direct | Preserve URL exactly |
| `/person/honorable-dave-mccurdy/` 🟡 | david mccurdy (170, rank 4) | 0 direct | Preserve URL exactly |
| `/person/dr-jill-tiefenthaler/` 🟡 | ceo national geographic (170) | 0 direct | Preserve URL exactly |
| `/person/honorable-lisa-disbrow/` 🟡 | lisa disbrow (110, rank 6) | 1 | Preserve URL exactly |
| `/person/lieutenant-general-leslie-smith/` 🟡 | ltg leslie smith (70), leslie c smith | 0 direct | Preserve URL exactly |
| `/person/constantine-saab/` ⬜ | — | 3 | Preserve URL exactly |
| `/person/michael-brennan/` ⬜ | — | 2 | Preserve URL exactly |
| `/person/lieutenant-general-robert-dail/` ⬜ | — | 2 | Preserve URL exactly |
| `/person/rabi-chitrakar/` ⬜ | — | 2 | Preserve URL exactly |
| `/person/general-ann-dunwoody/` ⬜ | — | 1 | Preserve URL exactly |
| `/person/micaela-simeone/` ⬜ | — | 1 | Preserve URL exactly |
| `/person/pat-tamburrino/` 🟡 | tamburrino (260, rank 19) | 0 direct | Preserve URL exactly (note: `/person/pasquale-tamburrino/` is broken with 6 backlinks — see Section 7) |
| `/person/kumar-garg/` 🟡 | kumar garg renaissance (50, rank 6) | 0 direct | Preserve URL exactly |
| `/person/simon-davidson/` 🟡 | simon davidson (70, rank 5) | 0 direct | Preserve URL exactly |
| `/person/jonathon-morgan/` 🟡 | jonathon morgan (70, rank 3) | 0 direct | Preserve URL exactly |
| `/person/vice-admiral-raquel-bono/` 🟡 | raquel bono (110, rank 11) | 0 direct | Preserve URL exactly |
| `/person/nina-dudnik/` 🟡 | nina dudnik (20, rank 3) | 0 direct | Preserve URL exactly |

### Stories Pages

| Current URL | Ranks For | Backlinks | Action Required |
|---|---|---|---|
| `/stories/founders-fund/` 🔴 | trae stephens (3,600, rank 8) | 1 | Preserve URL exactly |
| `/stories/noblereach-emerge-lightdeck/` 🔴 | lightdeck (8,100, rank 19) ⚠️ UTM | 0 direct | Preserve URL exactly; fix UTM ranking issue |
| `/stories/iora-health-dr-rushika-fernandopulle/` 🟡 | rushika fernandopulle (260, rank 5), iora health (590) | 0 direct | Preserve URL exactly |
| `/stories/ginkgo-bioworks-tom-knight/` 🟡 | tom knight (720), ginkgo bioworks founders | 0 direct | Preserve URL exactly |
| `/stories/coursera-daphne-koller-and-andrew-ng/` 🟡 | coursera founders (210), who owns coursera | 0 direct | Preserve URL exactly |
| `/stories/james-kanoff-terradot/` 🟡 | terradot (880), james kanoff (110) | 0 direct | Preserve URL exactly |
| `/stories/noblereach-emerge-mesodyne/` 🟡 | mesodyne (320, rank 21) | 0 direct | Preserve URL exactly |
| `/stories/eco-concrete-building-a-greener-future-with-phoenix-materials/` 🟡 | phoenix materials (320, rank 10) | 0 direct | Preserve URL exactly |
| `/stories/first-mile-innovations-conlan-gotzions-journey-through-impact-and-ingenuity/` ⬜ | — | 2 | Preserve URL exactly |
| `/stories/noblereach-at-gcec-2025-shaping-the-future-of-entrepreneurship-education/` 🟡 | gcec 2025 (70, rank 6), gcec conference 2025 (110) | 0 direct | Preserve URL exactly |
| `/stories/venture-meets-mission-awarded-2025-axiom-business-book-awards-gold-medal/` 🟡 | axiom business book award (70, rank 18) | 0 direct | Preserve URL exactly |

### News Pages

| Current URL | Ranks For | Backlinks | Action Required |
|---|---|---|---|
| `/news/16-innovations-fueled-by-the-federal-government/` 🔴 | 30+ innovation queries (rank 2–95) | 37 | **Preserve URL exactly — highest backlinked content page** |
| `/news/dive-technologies-qa/` 🔴 | dive technologies (320), dive-ld — also in AI Overviews | 0 direct | Preserve URL exactly |
| `/news/noblereach-foundation-tech-force/` 🟡 | via /us-tech-force/ redirect | 1 | Preserve URL exactly |
| `/news/noblereach-announces-second-class-of-2025-scholars/` 🟡 | — | 10 | Preserve URL exactly |
| `/news/noblereach-foundation-announces-inaugural-class-of-scholars/` 🟡 | — | 9 | Preserve URL exactly |
| `/news/noblereach-names-former-senior-commerce-department-official-sree-ramaswamy-as-chief-innovation-officer/` ⬜ | — | 6 | Preserve URL exactly |
| `/news/noblereach-welcomes-johns-hopkins-applied-physics-laboratory-director-ralph-semmel-and-national-geographic-society-ceo-jill-tiefenthaler-to-its-board-of-directors/` ⬜ | ralph semmel (140) | 3 | Preserve URL exactly |
| `/news/noblereach-foundation-signs-education-partnership-agreement-with-nsa/` 🟡 | nsa agreement (110) | 3 | Preserve URL exactly |
| `/news/expanding-horizons-taking-the-noblereach-scholars-program-to-state-and-local-government/` ⬜ | — | 3 | Preserve URL exactly |
| `/news/noblereach-foundation-announces-board-leadership-changes/` ⬜ | — | 1 | Preserve URL exactly |

### Program / Section Pages

| Current URL | Ranks For | Backlinks | Action Required |
|---|---|---|---|
| `/talent-opportunities/noblereach-scholars-program/` 🔴 | noblereach scholars (90, rank 1), noble scholar (70) | 7 | Preserve URL exactly |
| `/talent-opportunities/noblereach-scholars-program/scholars-faq/` 🔴 | — | 9 | Preserve URL exactly |
| `/talent-opportunities/noblereach-interns/` 🟡 | rockefeller foundation internship (260) | 3 | Preserve URL exactly |
| `/us-tech-force/` 🔴 | tech force (1,900, rank 20), us tech force program (170) | 1 | **Create real landing page — currently redirects to press release** |
| `/us-coast-guard-internship/` 🟡 | coast guard internship (70, rank 8), coast guard internships (70, rank 6) | 0 direct | Preserve URL exactly |
| `/venture-meets-mission/` 🟡 | venture meets mission (70, rank 3) | 7 | Preserve URL exactly |
| `/innovation/our-work-with-darpa/` 🟡 | darpa opportunities (90), darpa work (90) | 0 direct | Preserve URL exactly |
| `/education/curriculum-and-credentialing/` 🟡 | innovation for impact (70, rank 6) | 0 direct | Preserve URL exactly |
| `/about-noblereach/noblereach-jobs-internships/` 🟡 | noble foundation jobs (30, rank 4), noble foundation careers | 0 direct | Preserve URL exactly |
| `/about-noblereach/team-and-board/` ⬜ | — | 1 | Preserve URL exactly |
| `/privacy/` ⬜ | — | 5 | Preserve URL exactly |
| `/scholars-cohort/` ⬜ | — | 1 | Preserve URL exactly |

---

## 2. Existing Redirect Chains — Must Persist

These 301 redirects are already in place and have accumulated backlinks. The rebuild must carry these forward — do not remove or change the destination.

| Old URL (301 source) | Backlinks | Ref Domains | Must Redirect To |
|---|---|---|---|
| `/talent-opportunities/scholars-program/` | **33** | **27** | `/talent-opportunities/noblereach-scholars-program/` |
| `/talent-opportunities/scholars-program/scholars-partners/` | 7 | 7 | Closest current partners/about page |
| `/scholars-program/` | 7 | 2 | `/talent-opportunities/noblereach-scholars-program/` |
| `/scholars-program/scholars-faq/` | 5 | 4 | `/talent-opportunities/noblereach-scholars-program/scholars-faq/` |
| `/academic-partnerships/curriculum/` | 5 | 5 | `/education/curriculum-and-credentialing/` |
| `/bringing-emergingtechnologies-to-life/` | 4 | 3 | Closest current program page |
| `/team-and-board/` | 4 | 3 | `/about-noblereach/team-and-board/` |
| `/providing-opportunities-for-top-tier-talent/noblereach-interns/` | 2 | 2 | `/talent-opportunities/noblereach-interns/` |
| `/talent-opportunities/scholars-program/host-a-scholar/` | 1 | 1 | Closest current host/partner page |
| `/science-to-venture/` | 3 | 3 | Closest current program page |

---

## 3. Old Domain Redirect — Critical Infrastructure

> ⚠️ **DO NOT REMOVE THIS REDIRECT UNDER ANY CIRCUMSTANCES.**

`noblereachfoundation.org` → `noblereach.org`

- **55 backlinks** still arrive via this redirect chain
- **46 external sites** still use "noblereachfoundation.org" as anchor text
- **18 sites** link directly to `https://noblereachfoundation.org/`
- Many .edu domains link to the old domain — these are the most valuable links on the site

The domain redirect must be maintained at the DNS/hosting level through and after the rebuild. Verify it is still active post-launch.

---

## 4. SERP Features at Risk

### Google AI Overviews

| Page | Queries | AI Search Vol | Risk |
|---|---|---|---|
| `/person/kevin-stitt/` | Governor of Oklahoma | 1,300 | URL must be preserved; content about Stitt must remain substantive |
| `/person/general-paul-nakasone-ret/` | Paul Nakasone / NSA | 390 | Same as above |
| `/news/dive-technologies-qa/` | Dive Technologies / Anduril UUV | 370 | Article must be preserved verbatim; URL must not change |
| `/news/16-innovations-fueled-by-the-federal-government/` | Government innovations | 110 | Article must be preserved verbatim |

If any of these pages returns a 404 or significantly changes content at launch, AI Overview citations will be lost. Google re-evaluates AI Overview sources continuously.

### High-Visibility Position 1–2 Rankings

| Page | Keyword | Volume | Risk |
|---|---|---|---|
| `/person/benjamin-claflin/` | benjamin claflin | 880 | URL change = immediate ranking loss |
| `/person/arun-gupta/` | arun gupta | 720 | URL change = immediate ranking loss |
| `/person/glenn-gaffney/` | glenn gaffney, gaffney uap | 480 | URL change = immediate ranking loss |
| `/person/victoria-virasingh/` | victoria virasingh | 90 | URL change = immediate ranking loss |
| `/person/sreenivas-sree-ramaswamy/` | sree ramaswamy | 50 | URL change = immediate ranking loss |
| `/news/16-innovations-fueled-by-the-federal-government/` | government innovations | 90 | Content + URL must be preserved |
| `/talent-opportunities/noblereach-scholars-program/` | noblereach scholars | 90 | URL + content must be preserved |

---

## 5. Content to Preserve Verbatim

The following pages drive organic traffic and/or AI Overview citations. Content must carry over to the new site without significant alteration. URL changes require 301 redirects.

| Page | Reason to Preserve |
|---|---|
| `/person/kevin-stitt/` | Ranks for 6,600 vol "governor of oklahoma" cluster; AI Overview citation |
| `/person/dr-robert-m-gates/` | Ranks for 6,600 vol "robert gates" cluster |
| `/person/general-paul-nakasone-ret/` | Ranks for 1,600 vol "paul nakasone"; AI Overview citation |
| `/person/anne-neuberger/` | Ranks for 1,600 vol "anne neuberger" |
| `/person/pulkit-sharma/` | Ranks for 4,400 vol "pulkit sharma" |
| `/stories/founders-fund/` | Ranks for 3,600 vol "trae stephens" |
| `/stories/noblereach-emerge-lightdeck/` | Ranks for 8,100 vol "lightdeck" |
| `/news/16-innovations-fueled-by-the-federal-government/` | 37 backlinks; AI Overview citation; 30+ ranking keywords |
| `/news/dive-technologies-qa/` | AI Overview citation for defense tech queries |
| `/talent-opportunities/noblereach-scholars-program/` | Ranks #1 for branded scholars terms; .edu links point here via old URL redirects |

---

## 6. Schema to Implement in Rebuild

No structured data currently exists. The rebuild is an opportunity to add schema at the template level — one implementation covers all pages of that type.

| Schema Type | Template | Priority | Benefit |
|---|---|---|---|
| `Person` | All `/person/` pages | **High** | Strengthens AI Overview citations; Knowledge Panel eligibility |
| `Article` | All `/news/` and `/stories/` pages | **High** | Rich result eligibility; AI Overview citation strengthening |
| `Organization` | Homepage | **Medium** | Brand Knowledge Panel; logo in SERPs |
| `BreadcrumbList` | All pages | **Medium** | Breadcrumb display in SERPs |
| `Book` | `/venture-meets-mission/` | **Low** | Rich result for book pages |

Person schema fields to include: `name`, `jobTitle`, `description`, `url`, `image`, `sameAs` (link to Wikipedia/LinkedIn if available).

---

## 7. Known Broken Pages — Fix Before or During Rebuild

### 404 Pages with Active Backlinks (fix immediately — link equity is being lost now)

| Broken URL | Backlinks | Ref Domains | Recommended Action |
|---|---|---|---|
| `/person/linda-bixby/` | 8 | 7 | Recreate person page OR 301 → `/about-noblereach/team-and-board/` |
| `/person/pasquale-tamburrino/` | 6 | 5 | 301 → `/person/pat-tamburrino/` (existing page) |
| `/person/luiz-camargo/` | 4 | 3 | Recreate person page OR 301 → `/about-noblereach/team-and-board/` |
| `/person/thomas-fewer/` | 2 | 2 | Recreate person page OR 301 → closest replacement |
| `/person/jeremy-joseph/` | 2 | 2 | Recreate person page OR 301 → closest replacement |
| `/jobs/` | 2 | 2 | 301 → `/about-noblereach/noblereach-jobs-internships/` |
| `/science-to-venture/` | 2 | 2 | 301 → closest current program page |

### 404 Pages with No Backlinks (clean up during rebuild)

| Broken URL | Recommended Action |
|---|---|
| `/providing-opportunities-for-top-tier-talent/jobs/` | 301 → `/about-noblereach/noblereach-jobs-internships/` |
| `/talent-opportunities/noblereach-fellows/` | 301 → closest current program OR 410 if program discontinued |
| `/us-tech-force` (no trailing slash) | 301 → `/us-tech-force/` |
| `/about-noblereach/contact-us/` | 301 → `/about-noblereach/` or new contact page |
| `/academic-partnerships/academic-partners/` | 301 → closest current page |
| `/_old-pages/bringing-emergingtechnologies-to-life/` | 410 Gone (intentionally archived) |

---

## 8. Technical Debt to Fix in Rebuild

### HubSpot UTM Parameter Pollution (High Priority)

HubSpot email campaigns are generating unique indexed URLs via UTM parameters. At least one ranking URL (`/stories/noblereach-emerge-lightdeck/`) is ranking in Google with the full UTM string in the URL — meaning Google may be splitting ranking signals between the canonical URL and the UTM variant.

**Fix:** Implement canonical tags that point UTM variants to the clean URL. Most CMS platforms and HubSpot configurations support this. Additionally, ensure HubSpot email tracking uses URL fragments (`#`) or server-side session tracking rather than query parameters for links to canonical content.

UTM-polluted URLs that have received external backlinks:
- `/talent-opportunities/scholars-program/?utm_campaign=DC Curated Email...` (2 backlinks, 404)
- `/news/noblereach-announces-second-class-of-2025-scholars/?__hstc=...` (1 backlink)
- `/stories/noblereach-emerge-lightdeck/?utm_source=hs_email...` (ranking URL)
- Several other story and news URLs with HubSpot tracking parameters

### BugHerd Dev Tool on Production (High Priority)

Macropod BugHerd (a QA/feedback annotation tool) is loading on all production pages. This contributes to the low Best Practices Lighthouse score (56/100) and adds unnecessary third-party JavaScript to every page load.

**Fix:** Remove BugHerd from production before launch. If needed for pre-launch QA, ensure it is gated behind an environment variable and does not load on the live site.

### AppNexus Ad Exchange Scripts (Medium Priority)

AppNexus (an advertising exchange) scripts are loading on all pages. This is unusual for a nonprofit and likely arrived via GTM or HubSpot configuration. It is a probable contributor to the 56/100 Best Practices score.

**Fix:** Audit GTM tags and HubSpot integrations. Remove AppNexus if not intentionally placed.

### Missing Meta Descriptions (Medium Priority — Fix in Rebuild Template)

8 of 9 audited pages have no meta description. This is a template-level issue — all person pages and story pages are affected. The rebuild should add meta description fields to every page template and populate them at content entry time.

### Missing H1 Tags on Person Pages (High Priority — Fix in Rebuild Template)

All person pages use H5 for the person's name with no H1. The rebuild should ensure every page template includes exactly one H1 tag containing the primary topic (person name for person pages).

### Homepage Title Tag (Low Priority)

"NobleReach Foundation" (21 chars) is flagged as too short. Consider expanding to include a brief descriptor, e.g. "NobleReach Foundation | Civic Leadership & National Security".

### Render-Blocking Resources (Medium Priority)

Every page loads 2 render-blocking scripts and 2 render-blocking stylesheets. Google Fonts is the primary candidate — consider self-hosting fonts to eliminate the render-blocking CDN call.

### Homepage Page Weight: 5.5MB (Medium Priority)

The homepage loads 5.5MB of resources. Identify and optimize or lazy-load large images. Target < 2MB for a content-focused homepage.
