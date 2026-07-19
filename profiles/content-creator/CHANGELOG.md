# Changelog — content-creator

## Unreleased

- Preload `linkedin-posting` and `x-posting` via `skills.defaults` on every
  new session (requires hermes-agent `skills.defaults` support).

## 0.1.0

- Initial release.
- SOUL: platform-native content assistant; publishing is approval-gated.
- Skills: `linkedin-posting` (LinkedIn REST API), `x-posting` (X API v2,
  single posts and threads).
- Cron template: `content-pipeline` (weekdays 09:00, drafts only, disabled
  until registered).
