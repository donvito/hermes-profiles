# Changelog — realestate-agent

## Unreleased

- Preload `listing-writer` and `comp-analysis` via `skills.defaults` on every
  new session (requires hermes-agent `skills.defaults` support).

## 0.1.0

- Initial release.
- SOUL: fact-driven real-estate assistant with fair-housing guardrails.
- Skills: `listing-writer`, `comp-analysis`.
- Cron template: `market-watch` (weekdays 08:00, disabled until registered).
- Example MCP server (disabled): `deal-files`.
