---
name: contract-review
description: "Review contracts for risk, key clauses, and redlines."
version: 1.0.0
author: hermes-profiles maintainers
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Legal, Contracts, Review, Risk, Redlines]
    related_skills: [case-summary]
---

# Contract Review Skill

Structured first-pass review of a contract: extract the deal terms, grade
every material clause for risk, and propose concrete redlines. This skill
produces a review memo — it does not negotiate, sign, or file anything.

## When to Use

- The user shares a contract (PDF, DOCX, or pasted text) and asks for a
  review, a summary of terms, or "what should I push back on?"
- The user asks to compare a draft against a prior version or a playbook.

## Prerequisites

- The document must be readable in the workspace. Use `read_file` for text
  files; for PDFs/DOCX ask the user to drop them in the workspace and
  convert with `terminal` (e.g. `pdftotext`) if available.

## Procedure

1. **Identify the frame.** Parties, effective date, term, governing law,
   contract type (MSA, NDA, SOW, lease, employment, ...). If any of these
   are missing from the document, list them as gaps.
2. **Extract the money and the risk.** Payment terms, caps on liability,
   indemnities, IP assignment/license, confidentiality, termination rights,
   auto-renewal, non-compete/non-solicit, dispute resolution.
3. **Grade each material clause** using the table format below. Risk levels:
   `HIGH` (uncapped/one-sided/unusual), `MEDIUM` (negotiable, market-ish),
   `LOW` (standard).
4. **Propose redlines.** For every HIGH and MEDIUM item, quote the clause
   verbatim, then give replacement language the user can paste.
5. **Surface deadlines.** Notice periods, renewal windows, cure periods.
   Offer to schedule reminders with the `cronjob` tool.

## Output Format

Always lead with the table:

| # | Clause (§) | Topic | Risk | Why | Suggested redline |
|---|-----------|-------|------|-----|-------------------|

Then: a short "Deal summary" paragraph, the redline blocks, and the
deadlines list. Close with the not-legal-advice reminder from SOUL.md.

## Pitfalls

- Do not paraphrase clause text inside the table — quote the section number
  and use verbatim quotes in the redline blocks.
- Auto-renewal + long notice windows is the most commonly missed HIGH risk;
  always check for it explicitly.
- If the document is a fragment, say which standard sections are absent
  rather than reviewing as if complete.

## Verification

A review is complete when every HIGH item has (a) a verbatim quote,
(b) a concrete replacement text, and (c) an owner action ("ask counterparty
to cap at 12 months of fees").
