# hermes-profiles

Installable [Hermes](https://github.com/NousResearch/hermes-agent) profile
distributions, developed in one monorepo. Each directory under `profiles/`
is a complete profile home — SOUL, config, skills, cron templates — packaged
in the [distribution format](https://hermes-agent.nousresearch.com/docs/user-guide/profile-distributions)
that `hermes profile install` understands (`distribution.yaml` at the
profile root).

## Profiles

| Profile | What it is |
|---|---|
| [`legal-person`](profiles/legal-person/) | Legal assistant: contract review, case summaries, deadline tracking |
| [`realestate-agent`](profiles/realestate-agent/) | Real-estate assistant: listings, comps, market watch |
| [`home-manager`](profiles/home-manager/) | Household assistant: meal planning, maintenance, reminders |
| [`content-creator`](profiles/content-creator/) | Content assistant: drafts, content calendar, LinkedIn + X posting |

## Install a profile

Prerequisite: the Hermes CLI
(`curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash`).

### From this monorepo (works today)

`hermes profile install <git-url>` requires `distribution.yaml` at the repo
root, so a monorepo subdirectory can't be a git-URL source — clone first,
then install from the local directory:

```bash
git clone https://github.com/donvito/hermes-profiles
hermes profile install ./hermes-profiles/profiles/legal-person --alias -y
# or any other profile:
hermes profile install ./hermes-profiles/profiles/content-creator --alias -y
```

### One command, from a delivery repo (after publishing)

Once a profile has been released to its standalone delivery repo with
`scripts/release.sh` (or the tag-triggered CI workflow — see Releasing
below), users install straight from the git URL, no clone needed:

```bash
# works only after donvito/legal-person-agent has been published
hermes profile install github.com/donvito/legal-person-agent --alias
```

### Configure the model (required before first chat)

Profiles ship with `model.provider: auto` and no API key — a fresh install
fails with `No inference provider configured` until you add a key. Each
profile has its **own** `.env`, separate from your default Hermes setup.

**1. Add your API key to the profile's `.env`.** Ask hermes for the exact
path — it differs per OS (`~/.hermes/profiles/<name>/.env` on Linux/macOS,
`%LOCALAPPDATA%\hermes\profiles\<name>\.env` on Windows):

```bash
hermes -p legal-person config env-path
# open that file (or create it) and add one line, no quotes:
#   OPENAI_API_KEY=sk-your-key-here

# one-liner alternative (bash / Git Bash):
echo "OPENAI_API_KEY=sk-your-key-here" >> "$(hermes -p legal-person config env-path)"
```

**2. Pin the provider and model** (recommended — skips auto-detection):

```bash
hermes -p legal-person config set model.provider openai-api
hermes -p legal-person config set model.default gpt-5.5
```

Or pick interactively with `hermes -p legal-person model`, or run the full
wizard with `hermes -p legal-person setup`. Any provider hermes supports
works the same way (e.g. `OPENROUTER_API_KEY` + provider `openrouter`,
`ANTHROPIC_API_KEY` + provider `anthropic`).

**3. Smoke-test it:**

```bash
hermes -p legal-person -z "Reply with one sentence confirming you are the legal-person profile."
```

### After install

```bash
legal-person chat            # thanks to --alias
hermes profile info legal-person
hermes profile update legal-person   # pull a new release later
```

Your `.env`, memories, sessions, and `config.yaml` edits are never touched
by installs or updates.

## Anatomy of a profile

```
profiles/legal-person/
├── distribution.yaml      # manifest — name, version, hermes_requires, env vars
├── SOUL.md                # personality / operating rules
├── config.yaml            # non-secret settings, incl. mcp_servers
├── skills/
│   ├── contract-review/SKILL.md
│   └── case-summary/SKILL.md
├── cron/
│   └── weekly-digest.yaml # template; registered manually (never auto-scheduled)
├── .gitignore             # keeps secrets/user data out if developed in place
├── README.md · CHANGELOG.md · LICENSE.md
```

See [`compat.md`](compat.md) for how each piece maps onto the hermes-agent
code and which Hermes versions are supported.

## Validating

```bash
scripts/validate.sh legal-person
```

Static-checks the manifest, skills, and cron templates; installs into a
throwaway `<name>-validate` profile; runs `hermes doctor`; cleans up.

## Releasing

Bump `version` in the profile's `distribution.yaml`, update its
`CHANGELOG.md`, then either:

```bash
# Manually:
scripts/release.sh legal-person git@github.com:donvito/legal-person-agent.git

# Or via CI (.github/workflows/release.yaml):
git tag legal-person-v0.2.0
git push origin legal-person-v0.2.0
```

Both copy `profiles/legal-person/` to the root of the delivery repo and tag
it `v0.2.0`. Installed users pick it up with
`hermes profile update legal-person`.

## License

MIT — see [LICENSE](LICENSE).
