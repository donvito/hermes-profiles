# Changelog — home-manager

## 0.1.1

- Declare default preloaded skills (`skills.preload` in `config.yaml`):
  `home-maintenance`, `meal-planner` load into every new session
  automatically on hermes-agent versions with `skills.preload` support
  (older versions ignore the key).

## 0.1.0

- Initial release.
- SOUL: low-mental-load household assistant with safety boundaries.
- Skills: `meal-planner`, `home-maintenance`.
- Cron template: `weekly-checkin` (Sundays 17:00, disabled until registered).
