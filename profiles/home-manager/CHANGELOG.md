# Changelog — home-manager

## 0.1.1

- Default skills: SOUL.md now instructs the agent to load
  `meal-planner` / `home-maintenance` (via `skill_view`) before its first
  substantive answer, so new sessions follow the skills' procedures with
  no flags. README documents the deterministic launch alternative
  (`hermes -p home-manager -s meal-planner,home-maintenance`).

## 0.1.0

- Initial release.
- SOUL: low-mental-load household assistant with safety boundaries.
- Skills: `meal-planner`, `home-maintenance`.
- Cron template: `weekly-checkin` (Sundays 17:00, disabled until registered).
