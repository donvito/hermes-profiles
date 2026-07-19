# Changelog — content-creator

## 0.1.1

- Declare default preloaded skills (`skills.preload` in `config.yaml`):
  `linkedin-posting`, `x-posting` load into every new session
  automatically on hermes-agent versions with `skills.preload` support
  (older versions ignore the key).

## 0.1.0

- Initial release.
- SOUL: platform-native content assistant; publishing is approval-gated.
- Skills: `linkedin-posting` (LinkedIn REST API), `x-posting` (X API v2,
  single posts and threads).
- Cron template: `content-pipeline` (weekdays 09:00, drafts only, disabled
  until registered).
