# Report 2: Strategic Baseline — noblereach.org

**Audit date:** 2026-03-19
**Audience:** Dev team performing site rebuild

---

## Executive Summary

- noblereach.org ranks for 270 keywords with ~1,685 estimated monthly organic visits — traffic is highly concentrated on person pages.
- 88 keywords currently rank in positions 1–10; all are at immediate risk if URLs change without redirects.
- The backlink profile is exceptionally clean (spam score: 1) with 113 .edu referring domains — this authority took years to build and is the site's most valuable SEO asset.
- The site appears in Google AI Overviews for 9 queries (~25,470 impressions), primarily through person pages and the "16 innovations" article.
- ChatGPT presence is minimal; AI Overviews via Google is the primary AI search channel.
- The `noblereachfoundation.org` → `noblereach.org` redirect chain carries 55+ backlinks and must be preserved indefinitely.

---

## 1. Keyword Rankings

### Position Distribution

| Position Range | Keywords | Notes |
|---|---|---|
| 1–3 | 22 | Branded + specific person names |
| 4–10 | 66 | High-volume name queries, program pages |
| 11–20 | 59 | Secondary person names, news articles |
| 21–50 | 74 | Long-tail, related queries |
| 51–100+ | 49 | Informational long-tail |
| **Total** | **270** | |

Estimated monthly organic traffic: **~1,685 visits**
Estimated paid traffic cost equivalent: **~$300/month**

Full keyword inventory: `data/full-keyword-inventory.md`
Top-10 keywords (at-risk): `data/top10-keywords.md`

### Top Keywords by Search Volume

| Keyword | Search Volume | Rank | URL |
|---|---|---|---|
| lightdeck | 8,100 | 19 | `/stories/noblereach-emerge-lightdeck/` ⚠️ UTM URL |
| bob gates / robert gates (cluster) | 6,600 | 12–27 | `/person/dr-robert-m-gates/` |
| governor of oklahoma (cluster) | 6,600 | 5–43 | `/person/kevin-stitt/` |
| defense secretary gates (cluster) | 6,600 | 16–27 | `/person/dr-robert-m-gates/` |
| pulkit sharma | 4,400 | 13 | `/person/pulkit-sharma/` |
| trae stephens | 3,600 | 8 | `/stories/founders-fund/` |
| who is governor of oklahoma (cluster) | 1,600 | 5–19 | `/person/kevin-stitt/` |
| anne neuberger | 1,600 | 10 | `/person/anne-neuberger/` |
| paul nakasone | 1,600 | 6 | `/person/general-paul-nakasone-ret/` |
| tech force | 1,900 | 20 | `/us-tech-force/` (redirects) |
| current governor of oklahoma | 1,300 | 6 | `/person/kevin-stitt/` |
| ann dunwoody | 880 | 8 | `/person/general-ann-dunwoody/` |
| benjamin claflin | 880 | 1 | `/person/benjamin-claflin/` |
| arun gupta | 720 | 1 | `/person/arun-gupta/` |

**Note on lightdeck:** The ranking URL for "lightdeck" (8,100 vol) includes the full HubSpot UTM parameter string in the indexed URL. This means link equity and ranking credit may be split across the canonical URL and the UTM variant.

---

## 2. Traffic-Driving Pages

The following pages are the primary sources of organic traffic, based on keyword rankings and search volume. Person pages dominate.

| Page | Top Keywords | Est. Monthly Traffic Contribution |
|---|---|---|
| `/person/kevin-stitt/` | governor of oklahoma (cluster, 6,600 vol × multiple ranks) | ~400+ |
| `/person/dr-robert-m-gates/` | robert gates / bob gates / defense secretary gates | ~300+ |
| `/news/16-innovations-fueled-by-the-federal-government/` | 30+ long-tail innovation queries | ~200+ |
| `/stories/noblereach-emerge-lightdeck/` | lightdeck (8,100 vol, rank 19) | ~100+ |
| `/stories/founders-fund/` | trae stephens (3,600 vol, rank 8) | ~100+ |
| `/person/general-paul-nakasone-ret/` | paul nakasone, nakasone, general nakasone | ~80+ |
| `/person/anne-neuberger/` | anne neuberger (1,600 vol, rank 10) | ~50+ |
| `/person/pulkit-sharma/` | pulkit sharma (4,400 vol, rank 13) | ~50+ |
| `/person/general-ann-dunwoody/` | ann dunwoody cluster | ~50+ |
| `/person/arun-gupta/` | arun gupta (720 vol, rank 1) | ~40+ |
| `/us-tech-force/` (via redirect) | tech force, us tech force program | ~40+ |
| `/talent-opportunities/noblereach-scholars-program/` | noblereach scholars (90 vol), noble scholar | ~30+ |
| `/person/vivek-kundra/` | vivek kundra (390 vol, rank 4) | ~25+ |
| `/person/glenn-gaffney/` | glenn gaffney (480 vol, rank 2), gaffney ufo/uap | ~25+ |
| `/stories/iora-health-dr-rushika-fernandopulle/` | iora health, rushika fernandopulle | ~20+ |
| `/stories/ginkgo-bioworks-tom-knight/` | tom knight, ginkgo bioworks founders | ~20+ |
| `/stories/coursera-daphne-koller-and-andrew-ng/` | coursera founders, who owns coursera | ~20+ |
| `/person/dr-jill-tiefenthaler/` | ceo national geographic, jill tiefenthaler | ~20+ |
| `/person/calvin-yang/` | calvin yang (390 vol, rank 3) | ~15+ |
| `/stories/james-kanoff-terradot/` | terradot, james kanoff | ~15+ |

**Key insight:** The top 3 pages by traffic (Kevin Stitt, Robert Gates, 16 innovations article) likely account for 50%+ of total organic visits.

---

## 3. Backlink Profile

### Summary

| Metric | Value |
|---|---|
| Total backlinks | 640 |
| Referring domains | 294 (242 unique main domains) |
| Domain spam score | 1/100 (very clean) |
| Broken backlinks | 28 (17 broken target pages) |
| Internal links (sitewide) | 9,507 |
| External outbound links | 1,294 |
| Server | Cloudflare |
| Domain first seen | 2022-07-20 |

### Referring Domain TLD Breakdown

| TLD | Count | Notes |
|---|---|---|
| .com | 213 | General commercial |
| **.edu** | **113** | **Highest-value — universities and research institutions** |
| .org | 102 | Nonprofits, associations |
| .ac.uk | 27 | UK academic |
| .co | 19 | International commercial |
| .ai | 18 | Tech/AI companies |
| .net | 9 | |
| .us | 8 | |

**113 .edu referring domains** is the site's crown jewel. These links point primarily to the Scholars and Emerge program pages. They were built over years through academic partnerships and cannot be easily replaced.

### Top Referring Domains

| Domain | Approx Rank | Backlinks | Notes |
|---|---|---|---|
| noblereachfoundation.org | 185 | 55 | Old domain — redirects to noblereach.org |
| smapply.us | 123 | 10 | Scholars application platform |
| uchicago.edu | 51 | 10 | University of Chicago |
| lever.co | 47 | 11 | Job posting platform |
| northeastern.edu | — | 1 | Northeastern University |
| ucsd.edu | — | 1 | UC San Diego |

### Anchor Text Distribution

| Anchor | Backlinks | Referring Domains |
|---|---|---|
| (empty/image/redirect) | 111 | 30 |
| NobleReach Foundation | 109 | 61 |
| noblereachfoundation.org | 46 | 41 |
| NobleReach Emerge | 38 | 10 |
| NobleReach | 30 | 19 |
| NobleReach Scholars | 19 | 11 |
| noblereach.org | 19 | 18 |
| https://noblereachfoundation.org/ | 18 | 13 |
| NobleReach Scholars program | 12 | 8 |
| Biography | 5 | 5 (.edu) |

**Note:** 46 backlinks still use the anchor "noblereachfoundation.org" and 18 link directly to the old domain URL. These are served by the existing redirect — but they represent historical brand confusion that will only resolve over time.

---

## 4. AI/LLM Mention Presence

### Google AI Overviews

| Metric | Value |
|---|---|
| AI Overview appearances | 9 |
| AI search volume (queries triggering AIO) | ~2,830 |
| Estimated AIO impressions | ~25,470 |

**Pages cited in AI Overviews:**

| Page | AI Search Volume | Context |
|---|---|---|
| `/person/kevin-stitt/` | 1,300 | Governor of Oklahoma queries — co-cited with Wikipedia |
| `/person/general-paul-nakasone-ret/` | 390 | NSA / Paul Nakasone queries — co-cited with Ballistic Ventures |
| `/news/dive-technologies-qa/` | 370 | Defense tech / Dive Technologies / Anduril UUV queries |
| `/news/16-innovations-fueled-by-the-federal-government/` | 110 | Government innovation queries |

The AI Overview presence is meaningful but narrow — 4 pages account for all citations. The innovations article is particularly valuable: it earns AI Overview citations despite ranking only in positions 56–95 for many of its keywords.

### ChatGPT

- noblereach.org appears in ChatGPT search results for "Michael Thomas CEO" but is not cited in the answer body.
- Minimal ChatGPT presence overall.
- Google AI Overviews is the primary AI search channel for this site.

---

## 5. SERP Feature Ownership

Based on keyword and AI mention data:

| Feature | Pages | Status |
|---|---|---|
| Google AI Overviews | `/person/kevin-stitt/`, `/person/general-paul-nakasone-ret/`, `/news/dive-technologies-qa/`, `/news/16-innovations-fueled-by-the-federal-government/` | Active |
| Position 1–2 rankings | `/person/benjamin-claflin/`, `/person/arun-gupta/`, `/news/16-innovations-fueled-by-the-federal-government/` (rank 2 for "government innovations"), `/person/glenn-gaffney/`, `/person/victoria-virasingh/`, `/person/sreenivas-sree-ramaswamy/` | Active |
| Featured snippets | Not confirmed — no featured snippet data available in this audit | Unknown |
| Knowledge panels | Not confirmed | Unknown |

No rich results (review stars, FAQ schema, etc.) are present because the site has no structured data.
