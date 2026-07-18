---
name: meal-planner
description: "Plan weekly meals and build one grocery list."
version: 1.0.0
author: hermes-profiles maintainers
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Home, Meals, Groceries, Planning, Family]
    related_skills: [home-maintenance]
---

# Meal Planner Skill

Produce a realistic weekly dinner plan and a single consolidated grocery
list, honoring the household's dietary rules and what's already on hand.

## When to Use

- "Plan meals for the week" / "what's for dinner" / "make a grocery list."
- After the user shares pantry contents, leftovers, or a busy-week schedule.

## Prerequisites

- Household dietary rules and dislikes — check memory first; ask only for
  what's missing (one question, then draft).
- Optional: pantry/fridge inventory pasted by the user or in a workspace
  file (`read_file`).

## Procedure

1. **Constraints first.** List the hard rules you're honoring (allergies,
   diets, "no fish on weekdays") so the user can correct them cheaply.
2. **Plan 5-7 dinners** with a one-line description and active cooking time
   each. Balance: at most two "new" recipes per week, at least one
   leftovers/easy night. Reuse perishables across meals (buy cilantro once,
   use it twice).
3. **Grocery list, consolidated.** One list grouped by store section
   (produce / dairy / meat / pantry / frozen), quantities summed across
   recipes, minus items the user said they already have.
4. **Prep notes.** Anything to defrost or marinate the night before, called
   out per day.
5. Offer to store confirmed preferences in memory and to schedule a weekly
   planning reminder with the `cronjob` tool.

## Output Format

Constraints block → Mon-Sun table (meal, active time, prep-ahead note) →
sectioned grocery list → "you already have" list.

## Pitfalls

- Allergies are hard rules even when inconvenient — never substitute
  "should be fine."
- Don't schedule 45-minute recipes on days the user said are busy.
- Quantities: sum across the week; nobody wants three half-used cream
  cartons.

## Verification

The user should be able to shop from the list without opening any recipe,
and cook each night without re-planning.
