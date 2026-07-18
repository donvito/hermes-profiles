---
name: home-maintenance
description: "Track seasonal home maintenance and DIY-vs-pro calls."
version: 1.0.0
author: hermes-profiles maintainers
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Home, Maintenance, Seasonal, Checklists, Safety]
    related_skills: [meal-planner]
---

# Home Maintenance Skill

Keep a household's preventive maintenance on schedule: seasonal checklists,
recurring cadences (filters, batteries, gutters), and honest DIY-vs-call-a-
professional guidance.

## When to Use

- "What home maintenance is due?" / seasonal checklist requests.
- Something broke and the user wants triage: DIY, watch, or call a pro.
- Setting up recurring maintenance reminders.

## Prerequisites

- Home facts from memory or the user: climate/region, house age, heating
  type, appliance models and filter sizes. Store new facts in memory as you
  learn them.

## Procedure

1. **Seasonal checklist.** For the current season, produce a checklist
   ordered by consequence-of-skipping (safety → water damage → efficiency →
   cosmetic). Each item: what, why in one clause, time estimate, and
   supplies with sizes from memory (e.g. the furnace filter size).
2. **Cadence items.** Track the recurring set — HVAC filters, smoke/CO
   detector batteries and test, water softener salt, gutter cleaning,
   dryer-vent lint, water-heater flush. Offer to register each as a
   recurring reminder via the `cronjob` tool (e.g. every 90 days for
   filters) instead of a one-time list.
3. **Triage requests.** For a reported problem: likely causes in order of
   probability, the one safe diagnostic the user can do, then the DIY/pro
   call with reasoning. Use `web_search` for the appliance manual or recall
   notices when a model number is known, and cite it.
4. **Safety gate.** Gas smell, sparking panel, roof work, structural cracks,
   anything requiring a permit → "call a professional now", plus the exact
   symptoms to describe on the phone.

## Output Format

Checklist table (item, why, time, supplies) → cadence/reminder offers →
triage answer where asked.

## Pitfalls

- Filter sizes and detector types vary per house — pull from memory, never
  assume a standard size.
- "It's probably fine" is not triage; give the failure mode you're ruling
  out.
- Regional differences matter (freeze protection, hurricane prep) — anchor
  on the stored region.

## Verification

Every checklist item is actionable this week by a non-expert or explicitly
routed to a professional with a reason.
