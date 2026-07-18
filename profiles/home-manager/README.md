# home-manager

A Hermes profile distribution: a calm household assistant for meal planning,
home maintenance, and reminders.

## Install

```bash
# From a checkout of this monorepo (local-directory install):
git clone https://github.com/donvito/hermes-profiles
hermes profile install ./hermes-profiles/profiles/home-manager --alias -y

# Or, once published to its delivery repo via scripts/release.sh:
hermes profile install github.com/donvito/home-manager-agent --alias
```

## Configure the model

The profile installs with no API key (`No inference provider configured`
until you add one). Add a key to the **profile's own** `.env` and pin a
model:

```bash
# 1. Add your key to the profile .env (path differs per OS — ask hermes):
hermes -p home-manager config env-path
echo "OPENAI_API_KEY=sk-your-key-here" >> "$(hermes -p home-manager config env-path)"

# 2. Pick provider + model interactively (e.g. OpenAI API / gpt-5.5):
hermes -p home-manager model

# 3. Smoke-test:
hermes -p home-manager -z "Confirm you are the home-manager profile in one sentence."

home-manager chat
```

## What's inside

| Path | Purpose |
|---|---|
| `distribution.yaml` | Manifest: name, version, `hermes_requires`, env vars |
| `SOUL.md` | Identity: low-mental-load, budget-aware, safety-first |
| `config.yaml` | Model/provider defaults; memory enabled for household facts |
| `skills/meal-planner/` | Weekly dinners + one consolidated grocery list |
| `skills/home-maintenance/` | Seasonal checklists and DIY-vs-pro triage |
| `cron/weekly-checkin.yaml` | Template for a Sunday planning check-in |

## Cron

Register the check-in after reviewing the template:

```bash
hermes -p home-manager cron create "0 17 * * 0" \
  "Run the Sunday household check-in: draft this week's meal plan per the meal-planner skill, and list any maintenance items due in the next two weeks per the home-maintenance skill." \
  --name "weekly-checkin" --skill meal-planner --skill home-maintenance --deliver local
```

## Update

```bash
hermes profile update home-manager
```

Config tweaks, memories, sessions, and `.env` are preserved; SOUL, skills,
and the cron directory are replaced. Re-register cron jobs after updating
(`hermes -p home-manager cron list` to check).
