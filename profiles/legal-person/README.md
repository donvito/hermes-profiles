# legal-person

A Hermes profile distribution: a legal assistant for contract review, case
summaries, legal research, and deadline tracking.

## Install

```bash
# From a checkout of this monorepo (local-directory install):
hermes profile install ./profiles/legal-person --alias -y

# Or from the standalone delivery repo published by scripts/release.sh:
hermes profile install github.com/donvito/legal-person-agent --alias
```

Then:

```bash
cp ~/.hermes/profiles/legal-person/.env.EXAMPLE ~/.hermes/profiles/legal-person/.env
# fill in your keys, or just run:
hermes -p legal-person setup

legal-person chat        # with --alias, or: hermes -p legal-person chat
```

## What's inside

| Path | Purpose |
|---|---|
| `distribution.yaml` | Manifest: name, version, `hermes_requires`, env vars |
| `SOUL.md` | Identity: precise, citation-driven, never gives legal advice |
| `config.yaml` | Model/provider defaults + disabled example MCP servers |
| `skills/contract-review/` | Risk-graded clause table + redlines |
| `skills/case-summary/` | IRAC-style summaries with pin cites |
| `cron/weekly-digest.yaml` | Template for a Monday-morning matter digest |

## Cron

Shipped cron files are templates — Hermes never auto-schedules jobs from a
distribution. Register the digest after reviewing it:

```bash
hermes -p legal-person cron create "0 9 * * 1" \
  "Produce the weekly matter digest as described by the case-summary skill: scan the workspace for documents added or changed in the last 7 days, summarize each, and list upcoming deadlines for the next 30 days." \
  --name "weekly-digest" --skill case-summary --deliver local
```

## MCP

`config.yaml` ships two disabled `mcp_servers` entries (a Clio-style bridge
and a filesystem server). Enable them by setting `enabled: true` and putting
`MCP_CLIO_API_KEY` in the profile `.env`, or add your own with
`hermes -p legal-person mcp add`.

## Update

```bash
hermes profile update legal-person
```

Your `config.yaml` tweaks, memories, sessions, and `.env` are preserved;
SOUL, skills, and the cron directory are replaced from the new version.
Note: replacing `cron/` also clears jobs you registered with `cron create`,
so re-register them after an update (`hermes -p legal-person cron list` to
check).
