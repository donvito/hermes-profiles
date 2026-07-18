---
name: comp-analysis
description: "Run comparable-sales analysis with explicit adjustments."
version: 1.0.0
author: hermes-profiles maintainers
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [RealEstate, Comps, Pricing, CMA, Analysis]
    related_skills: [listing-writer]
---

# Comp Analysis Skill

Build a defensible comparable-sales (CMA-style) price range for a subject
property from user-supplied or web-gathered comps. Output is an estimate for
discussion — not an appraisal, and the report must say so.

## When to Use

- "What should this list for?" / "Is this offer fair?" / "Run comps on X."

## Prerequisites

- Subject property facts (beds, baths, sqft, lot, condition, location).
- Comp data: user-provided sheets in the workspace (`read_file`), or gather
  recent nearby sales with `web_search` + `web_extract`. Public "sold"
  listings and county records are acceptable sources; always record source
  and retrieval date per comp.

## Procedure

1. **Qualify comps.** Prefer: sold (not active), within ~1 mile or same
   school-attendance zone, closed in the last 6 months, within ±20% sqft,
   same property type. Note every rule you had to relax and why.
2. **Build the comp table.** One row per comp: address, sale date, sale
   price, sqft, $/sqft, beds/baths, lot, condition notes, distance, source
   + date retrieved.
3. **Adjust explicitly.** Apply per-difference adjustments (sqft, bath
   count, garage, condition, lot) as separate line items with the dollar
   amount and your reasoning. No black-box "adjusted price" without the
   breakdown.
4. **Derive the range.** Weight comps by similarity, state the indicated
   value per comp, and give a final range plus a suggested list price with
   the pricing strategy trade-off (spark-competition vs. anchor-high).
5. **Caveats.** Market direction, days-on-market context, anything unusual
   about the subject (busy road, unpermitted addition) that the comps don't
   capture.

## Output Format

Subject fact block → comp table → adjustment grid → indicated range →
recommendation paragraph → caveats → "estimate, not an appraisal" note.

## Pitfalls

- Active listings show asking prices, not value — use them only as a
  competition check, clearly separated from sold comps.
- Never average raw $/sqft across dissimilar comps; adjust first.
- Stale comps in a fast-moving market need a time adjustment — state the
  monthly trend figure you used and its source.

## Verification

Someone reading only the tables should be able to recompute your final range
without asking you anything.
