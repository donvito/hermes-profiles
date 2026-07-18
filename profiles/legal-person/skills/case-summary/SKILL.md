---
name: case-summary
description: "Summarize cases and legal documents in IRAC structure."
version: 1.0.0
author: hermes-profiles maintainers
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Legal, Cases, Summaries, Research, IRAC]
    related_skills: [contract-review]
---

# Case Summary Skill

Turn a court opinion, filing, or long legal document into a compact,
verifiable summary a busy professional can absorb in two minutes.

## When to Use

- The user shares an opinion, complaint, motion, deposition, or memo and
  asks "what does this say?" or "summarize this."
- The user asks for a digest of several documents in a matter folder.

## Prerequisites

- Documents readable in the workspace (`read_file`; convert PDFs via
  `terminal` when needed). For public opinions, `web_extract` on the
  court's or a reporter's URL also works.

## Output Format

```
MATTER:     <caption / parties / court / docket / date>
POSTURE:    <where in the lifecycle this document sits>
FACTS:      3-6 bullets, only facts that drive the outcome
ISSUES:     numbered questions the document answers
HOLDINGS:   one line per issue, with pin cite (page/paragraph)
REASONING:  2-4 bullets per holding, quoting the decisive language
ACTION ITEMS: what the user should do next, with dates if any
```

## Procedure

1. Read the whole document before summarizing — no summarizing from the
   first page only.
2. Fill the format above. Every holding gets a pin cite to a page or
   paragraph so the human can verify in seconds.
3. Quote decisive language verbatim (short quotes, with location). Never
   reconstruct quotes from memory.
4. For multi-document digests, produce one block per document plus a
   half-page "state of the matter" overview on top.
5. End with the not-legal-advice reminder from SOUL.md.

## Pitfalls

- Dissents and concurrences are not holdings — label them.
- Unpublished / non-precedential opinions must be flagged as such.
- If OCR quality is bad, say so and mark uncertain passages instead of
  silently guessing.

## Verification

A summary passes when someone could check any holding against the source in
under a minute using only your pin cites.
