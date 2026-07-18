# realestate-agent

A Hermes profile distribution: a numbers-first assistant for listings,
comparable-sales analysis, and market monitoring.

## Install

```bash
# From a checkout of this monorepo (local-directory install):
hermes profile install ./profiles/realestate-agent --alias -y

# Or from the standalone delivery repo published by scripts/release.sh:
hermes profile install github.com/donvito/realestate-agent-agent --alias
```

Then:

```bash
cp ~/.hermes/profiles/realestate-agent/.env.EXAMPLE ~/.hermes/profiles/realestate-agent/.env
# fill in keys, or run: hermes -p realestate-agent setup
realestate-agent chat
```

## What's inside

| Path | Purpose |
|---|---|
| `distribution.yaml` | Manifest: name, version, `hermes_requires`, env vars |
| `SOUL.md` | Identity: fact-driven, fair-housing-safe, no invented numbers |
| `config.yaml` | Model/provider defaults + a disabled filesystem MCP server |
| `skills/listing-writer/` | Portal-ready listings with a compliance pass |
| `skills/comp-analysis/` | CMA-style pricing with explicit adjustments |
| `cron/market-watch.yaml` | Template for a weekday-morning market brief |

## Cron

Register the market watch after reviewing the template:

```bash
hermes -p realestate-agent cron create "0 8 * * 1-5" \
  "Do a morning market watch: check mortgage-rate headlines and any new or price-changed listings in my saved search areas noted in memory. Summarize in five bullets max; skip the report entirely if nothing changed." \
  --name "market-watch" --deliver local
```

## Update

```bash
hermes profile update realestate-agent
```

Config tweaks, memories, sessions, and `.env` are preserved; SOUL, skills,
and the cron directory are replaced. Re-register cron jobs after updating
(`hermes -p realestate-agent cron list` to check).
