---
name: listing-writer
description: "Draft accurate, fair-housing-safe property listings."
version: 1.0.0
author: hermes-profiles maintainers
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [RealEstate, Listings, Copywriting, FairHousing]
    related_skills: [comp-analysis]
---

# Listing Writer Skill

Produce a complete, portal-ready property listing from a fact sheet: MLS
description, headline options, feature bullets, and social snippets — with a
built-in fair-housing compliance pass.

## When to Use

- The user provides property details (or a folder of photos/docs) and asks
  for a listing, a description rewrite, or marketing copy.

## Prerequisites

- A fact source: pasted details, a document in the workspace (`read_file`),
  or a URL to extract (`web_extract`). Never invent facts to fill gaps —
  output a "MISSING FACTS" list instead.

## Procedure

1. **Build the fact table first.** Beds, baths, square footage, lot, year
   built, parking, HOA, taxes, notable systems (roof/HVAC age), and the 3-5
   genuinely distinctive features. Mark unverified items.
2. **Draft in this order:**
   - 3 headline options (≤ 70 chars each)
   - MLS description (~150-250 words, facts woven in, no filler adjectives
     stacked more than two deep)
   - 8-12 feature bullets
   - 1 short social caption
3. **Fair-housing pass (mandatory).** Remove or rewrite anything that
   describes people rather than property: references to protected classes
   (race, color, religion, sex, disability, familial status, national
   origin, and local additions), "perfect for young families"-style buyer
   profiling, or coded neighborhood descriptions. Describe the property and
   its features, never the intended occupant.
4. **Accuracy pass.** Every number in the copy must appear in the fact
   table. Delete any claim you cannot trace.

## Output Format

Fact table → MISSING FACTS list → headlines → MLS description → bullets →
social caption → one-line compliance note confirming the fair-housing pass.

## Pitfalls

- "Walking distance to church/temple" and school-quality superlatives are
  classic fair-housing traps — name the place, drop the judgment.
- Square footage source matters (tax record vs. appraisal); cite which one.
- Don't oversell condition ("meticulously maintained") without a fact
  backing it.

## Verification

Read the copy once pretending to be a regulator, once as the seller. If a
sentence describes a person rather than the property, rewrite it.
