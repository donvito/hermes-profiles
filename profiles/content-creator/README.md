# content-creator

A Hermes profile distribution: a content assistant that drafts
platform-native posts, keeps a content calendar, and publishes to LinkedIn
and X — with explicit human approval before anything goes live.

## Install

```bash
# From a checkout of this monorepo (local-directory install):
git clone https://github.com/donvito/hermes-profiles
hermes profile install ./hermes-profiles/profiles/content-creator --alias -y

# Or, once published to its delivery repo via scripts/release.sh:
hermes profile install github.com/donvito/hermes-profile-content-creator --alias
```

## Configure the model

The profile installs with no API key (`No inference provider configured`
until you add one). Add a key to the **profile's own** `.env` and pin a
model:

```bash
# 1. Add your key to the profile .env (path differs per OS — ask hermes):
hermes -p content-creator config env-path
echo "OPENAI_API_KEY=sk-your-key-here" >> "$(hermes -p content-creator config env-path)"

# 2. Pick provider + model interactively (e.g. OpenAI API / gpt-5.5):
hermes -p content-creator model

# 3. Smoke-test:
hermes -p content-creator -z "Confirm you are the content-creator profile in one sentence."

content-creator chat
```

## What's inside

| Path | Purpose |
|---|---|
| `distribution.yaml` | Manifest: name, version, `hermes_requires`, env vars |
| `SOUL.md` | Identity: platform-native writing, approval-gated publishing |
| `config.yaml` | Model/provider defaults; memory for voice + audience |
| `skills/linkedin-posting/` | Draft + publish via LinkedIn REST API (`/rest/posts`) |
| `skills/x-posting/` | Draft + publish posts/threads via X API v2 (`/2/tweets`) |
| `cron/content-pipeline.yaml` | Template for a weekday-morning pipeline check (drafts only) |

## Default skills

`linkedin-posting` and `x-posting` are this profile's default skills:
`SOUL.md` instructs the agent to load the relevant one (via the `skill_view`
tool) before drafting or publishing for a platform, so posts follow the
skills' format and publishing rules without any flags.

To preload them deterministically at launch instead, pass `-s`:

```bash
hermes -p content-creator -s linkedin-posting,x-posting chat
```

Tip: wrap that in your own shell alias (the `--alias` wrapper runs plain
`hermes -p content-creator`):

```bash
alias creator='hermes -p content-creator -s linkedin-posting,x-posting'
```

## Credentials for posting

Both posting skills are optional — drafting works without them.

| Env var | What it is |
|---|---|
| `LINKEDIN_ACCESS_TOKEN` | OAuth 2.0 member token with `openid` + `w_member_social` scopes (LinkedIn app with the "Share on LinkedIn" product) |
| `X_BEARER_TOKEN` | OAuth 2.0 **user-context** access token with `tweet.write` scope (Authorization Code + PKCE flow — the app-only bearer token cannot post) |

Put them in the profile `.env`. The skills never echo tokens and never post
without your approval of the exact final text.

## Cron

Register the pipeline check after reviewing the template (it prepares
drafts only — publishing stays human-approved):

```bash
hermes -p content-creator cron create "0 9 * * 1-5" \
  "Do the morning content pipeline check: read workspace/content-calendar.md, list what is scheduled for today and this week, draft anything in the 'ideas' column that is due within 2 days (2-3 variants each, per the linkedin-posting and x-posting skill format rules), and list drafts awaiting approval. Do NOT publish anything — publishing requires explicit human approval." \
  --name "content-pipeline" --skill linkedin-posting --skill x-posting --deliver local
```

## Update

```bash
hermes profile update content-creator
```

Config tweaks, memories, sessions, and `.env` are preserved; SOUL, skills,
and the cron directory are replaced. Re-register cron jobs after updating
(`hermes -p content-creator cron list` to check).
