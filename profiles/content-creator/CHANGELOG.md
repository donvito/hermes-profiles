# Changelog — content-creator

## 0.1.1

- Default skills: SOUL.md now instructs the agent to load
  `linkedin-posting` / `x-posting` (via `skill_view`) before drafting or
  publishing for a platform, so new sessions follow the skills' format and
  publishing rules with no flags. README documents the deterministic launch
  alternative (`hermes -p content-creator -s linkedin-posting,x-posting`).

## 0.1.0

- Initial release.
- SOUL: platform-native content assistant; publishing is approval-gated.
- Skills: `linkedin-posting` (LinkedIn REST API), `x-posting` (X API v2,
  single posts and threads).
- Cron template: `content-pipeline` (weekdays 09:00, drafts only, disabled
  until registered).
