# Changelog — legal-person

## 0.1.1

- Default skills: SOUL.md now instructs the agent to load
  `contract-review` / `case-summary` (via `skill_view`) before its first
  substantive answer, so new sessions follow the skills' procedures with
  no flags. README documents the deterministic launch alternative
  (`hermes -p legal-person -s contract-review,case-summary`).

## 0.1.0

- Initial release.
- SOUL: citation-driven legal assistant with explicit boundaries.
- Skills: `contract-review`, `case-summary`.
- Cron template: `weekly-digest` (Mondays 09:00, disabled until registered).
- Example MCP servers (disabled): `clio`, `matter-files`.
