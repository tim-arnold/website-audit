# Analytics Retest Audit — Round {{RETEST_NUMBER}}

## Context

You are conducting an analytics retest #{{RETEST_NUMBER}} for the client described in `../../CLAUDE.md`. Started: {{RETEST_DATE}}.

Read `../../CLAUDE.md` and `../../.env.local` (for the GA4 Property ID) before starting. Then read the original audit report in `../reports/` to understand what data quality issues were flagged and which remediations were recommended.

The goal is to re-run the same assessments, confirm that recommended fixes were applied, and document any remaining or new issues.

**Do NOT modify any GA4 property settings or data.** Read and observe only.

## Deliverables

- `data/retest-data.md` — raw data collected from GA4
- `reports/00-comparison.md` — delta summary: what improved, regressed, or stayed flat
- `reports/analytics-retest-report.md` — full updated analytics snapshot

---

## Step 1: Re-collect the Same Data

Re-run the same GA4 queries from the original audit. Save raw output to `data/retest-data.md`. Use the same date ranges where possible to ensure fair comparison.

- `get_property_details` — property configuration, linked services
- `get_custom_dimensions_and_metrics` — custom dimensions/metrics
- Traffic by channel (last 12 months)
- Top landing pages (last 12 months, limit 50)
- Device breakdown
- Monthly traffic trend (last 24 months)
- Top exit pages
- Conversion events
- Geographic distribution

---

## Step 2: Re-run the Data Quality Assessment

For each check from the original audit, determine whether it now passes, still fails, or has changed.

| Check | Original Status | Retest Status | Notes |
|---|---|---|---|
| Duplicate tracking | | | |
| Internal traffic excluded | | | |
| Bot/spam filtering | | | |
| Cross-domain / subdomain tracking | | | |
| Missing conversion events | | | |
| UTM parameter coverage | | | |
| Search Console linked | | | |
| Google Ads linked | | | |
| Data retention period | | | |

---

## Step 3: Write the Reports

### Report 1: Comparison (`reports/00-comparison.md`)

Lead with an executive summary (3-5 bullets) on the most significant changes.

Then cover:

#### Data Quality
- Issues that were fixed (list each)
- Issues still outstanding (with updated priority notes)
- New issues introduced

#### Traffic Trends
- Sessions: before → after (same 12-month window)
- Channel mix changes
- Notable landing page gains/losses
- Conversion rate changes

#### Conversion Tracking
- New conversion events configured
- Events still missing
- Overall conversion volume change

#### Comparison table
| Metric | Baseline | Retest {{RETEST_NUMBER}} | Delta |
|---|---|---|---|

Use ▲ / ▼ / → for increase / decrease / no change.

---

### Report 2: Full Analytics Report (`reports/analytics-retest-report.md`)

Same structure as the original analytics audit report. Write as a standalone document — do not assume the reader has seen the original. Call out explicitly where things have changed.

---

## Formatting Notes

- Reference specific event names, page URLs, and metric values
- Where data is ambiguous, say so
- Audience is a dev team or marketing ops person
