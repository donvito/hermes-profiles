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

### One command, from a delivery repo

Each released profile is mirrored to its own repo (see Releasing below), so
users install straight from a git URL:

```bash
hermes profile install github.com/donvito/legal-person-agent --alias
```

### From this monorepo

`hermes profile install <git-url>` requires `distribution.yaml` at the repo
root, so a monorepo subdirectory can't be a git-URL source — but any local
directory can:

```bash
git clone github.com/donvito/hermes-profiles
hermes profile install ./hermes-profiles/profiles/legal-person --alias -y
```

### After install

```bash
cp ~/.hermes/profiles/legal-person/.env.EXAMPLE ~/.hermes/profiles/legal-person/.env
# fill in your keys — or run the wizard:
hermes -p legal-person setup

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
