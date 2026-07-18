# home-manager

A Hermes profile distribution: a calm household assistant for meal planning,
home maintenance, and reminders.

## Install

```bash
# From a checkout of this monorepo (local-directory install):
hermes profile install ./profiles/home-manager --alias -y

# Or from the standalone delivery repo published by scripts/release.sh:
hermes profile install github.com/donvitocodes/home-manager-agent --alias
```

Then:

```bash
cp ~/.hermes/profiles/home-manager/.env.EXAMPLE ~/.hermes/profiles/home-manager/.env
# fill in keys, or run: hermes -p home-manager setup
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
