# Changelog — legal-person

## 0.1.1

- Declare default preloaded skills (`skills.preload` in `config.yaml`):
  `contract-review`, `case-summary` load into every new session
  automatically on hermes-agent versions with `skills.preload` support
  (older versions ignore the key).

## 0.1.0

- Initial release.
- SOUL: citation-driven legal assistant with explicit boundaries.
- Skills: `contract-review`, `case-summary`.
- Cron template: `weekly-digest` (Mondays 09:00, disabled until registered).
- Example MCP servers (disabled): `clio`, `matter-files`.
