# Changelog — realestate-agent

## 0.1.1

- Default skills: SOUL.md now instructs the agent to load
  `listing-writer` / `comp-analysis` (via `skill_view`) before its first
  substantive answer, so new sessions follow the skills' procedures with
  no flags. README documents the deterministic launch alternative
  (`hermes -p realestate-agent -s listing-writer,comp-analysis`).

## 0.1.0

- Initial release.
- SOUL: fact-driven real-estate assistant with fair-housing guardrails.
- Skills: `listing-writer`, `comp-analysis`.
- Cron template: `market-watch` (weekdays 08:00, disabled until registered).
- Example MCP server (disabled): `deal-files`.
