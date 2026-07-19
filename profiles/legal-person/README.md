# legal-person

A Hermes profile distribution: a legal assistant for contract review, case
summaries, legal research, and deadline tracking.

## Install

```bash
# From a checkout of this monorepo (local-directory install):
git clone https://github.com/donvito/hermes-profiles
hermes profile install ./hermes-profiles/profiles/legal-person --alias -y

# Or, once published to its delivery repo via scripts/release.sh:
hermes profile install github.com/donvito/hermes-profile-legal-person --alias
```

## Configure the model

The profile installs with no API key (`No inference provider configured`
until you add one). Add a key to the **profile's own** `.env` and pin a
model:

```bash
# 1. Add your key to the profile .env (path differs per OS — ask hermes):
hermes -p legal-person config env-path
echo "OPENAI_API_KEY=sk-your-key-here" >> "$(hermes -p legal-person config env-path)"

# 2. Pick provider + model interactively (e.g. OpenAI API / gpt-5.5):
hermes -p legal-person model

# 3. Smoke-test:
hermes -p legal-person -z "Confirm you are the legal-person profile in one sentence."

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

## Default skills

`contract-review` and `case-summary` are this profile's default skills:
`SOUL.md` instructs the agent to load the relevant one (via the `skill_view`
tool) before its first substantive answer, so contract and case work follows
the skills' procedures without any flags.

To preload them deterministically at launch instead, pass `-s`:

```bash
hermes -p legal-person -s contract-review,case-summary chat
```

Tip: wrap that in your own shell alias (the `--alias` wrapper runs plain
`hermes -p legal-person`):

```bash
alias legal='hermes -p legal-person -s contract-review,case-summary'
```

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
