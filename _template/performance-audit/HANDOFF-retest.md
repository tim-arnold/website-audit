# Performance Retest Audit — Round {{RETEST_NUMBER}}

## Context

You are conducting a performance retest #{{RETEST_NUMBER}} for the client described in `../../CLAUDE.md`. Started: {{RETEST_DATE}}.

Read `../../CLAUDE.md` first. Then read the original performance audit in `../reports/` to understand what was measured and what improvements were recommended.

The goal is to re-run the same tests on the same pages, compare scores directly, and assess whether remediation efforts improved performance.

## Deliverables

- `data/retest-data.md` — raw Lighthouse and DataForSEO output
- `reports/00-comparison.md` — delta summary
- `reports/performance-retest-report.md` — full updated performance snapshot

---

## Step 1: Re-run the Same Tests

Test the same pages as the original audit:

### Lighthouse via DataForSEO
Use `on_page_lighthouse` on each page from the original audit. Record:
- Performance score
- LCP (Largest Contentful Paint)
- CLS (Cumulative Layout Shift)
- INP / TBT (Interaction to Next Paint / Total Blocking Time)
- Accessibility score
- SEO score
- Best Practices score

### On-page audit
Use `on_page_instant_pages` on the same pages. Note any new issues or resolved issues.

---

## Step 2: Map Against Original Findings

For every issue in the original performance audit:

| Issue | Original Value | Retest Value | Delta | Status |
|---|---|---|---|---|

Status: **Fixed** / **Improved** / **Unchanged** / **Regressed**

---

## Step 3: Write the Reports

### Report 1: Comparison (`reports/00-comparison.md`)

Lead with an executive summary (3-5 bullets).

Core Web Vitals comparison table:
| Metric | Page | Baseline | Retest {{RETEST_NUMBER}} | Delta | Status |
|---|---|---|---|---|---|

Lighthouse scores comparison:
| Score | Page | Baseline | Retest {{RETEST_NUMBER}} | Delta |
|---|---|---|---|---|

Then: issues resolved, issues still outstanding, new issues.

Use ▲ / ▼ / → for changes. Flag any regressions prominently.

---

### Report 2: Full Performance Report (`reports/performance-retest-report.md`)

Same structure as the original performance audit report. Write as a standalone document.

---

## Formatting Notes

- Always include specific metric values (e.g., LCP: 4.2s → 2.1s), not just scores
- Flag any Core Web Vitals that cross the pass/fail threshold in either direction
- Audience is a dev team — note what changed in the codebase that likely caused each shift
