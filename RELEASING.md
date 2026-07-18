# Releasing a profile

Releasing publishes one profile from this monorepo to its standalone
**delivery repo**, where the profile is the repository root. The delivery
repo is what makes the one-command install work:

```bash
hermes profile install github.com/donvito/hermes-profile-<profile-name> --alias
```

(`hermes profile install <git-url>` requires `distribution.yaml` at the repo
root, so monorepo subdirectories can't be installed from a git URL directly —
see [`compat.md`](compat.md).)

Delivery repos MUST be named `hermes-profile-<profile-name>` — for example
`hermes-profile-legal-person`. The convention is enforced: `scripts/release.sh`
rejects any other name, and the CI workflow derives the URL from it.

The examples below use `legal-person`; substitute your profile name.

## One-time setup

1. **Create the delivery repo on GitHub**: `<owner>/hermes-profile-<profile-name>`
   — empty (no README, no license; the release tooling populates it), and
   public so users can install without credentials.
2. **Create a fine-grained PAT** (only needed for CI releases): GitHub →
   Settings → Developer settings → Fine-grained tokens → Generate new token.
   Scope it to the `hermes-profile-*` repos only, with
   **Repository permissions → Contents: Read and write**.
3. **Add the PAT as a repository secret** on this monorepo: Settings →
   Secrets and variables → Actions → New repository secret, named
   `DELIVERY_TOKEN`. The workflow fails with a clear error if it's missing.

## Release via CI (recommended)

1. Set `version:` in `profiles/legal-person/distribution.yaml` to the version
   you're shipping (e.g. `0.1.0`) and update the profile's `CHANGELOG.md`.
   Commit to `main`.
2. Tag and push. The tag format is `<profile-name>-v<semver>` and the version
   must match `distribution.yaml` exactly:

   ```bash
   git tag legal-person-v0.1.0
   git push origin legal-person-v0.1.0
   ```

The `release` workflow ([`.github/workflows/release.yaml`](.github/workflows/release.yaml))
then:

- parses the tag and verifies `profiles/legal-person/` exists,
- verifies the tag version equals the `distribution.yaml` version,
- runs static checks (manifest `name` matches the directory, every skill has
  frontmatter, no user-owned files such as `.env` / `auth.json` / `state.db` /
  `memories/` / `sessions/` / `logs/` staged),
- calls `scripts/release.sh` to push the profile to
  `hermes-profile-legal-person`, tagged `v0.1.0`.

Watch progress under the monorepo's **Actions** tab.

## Release manually (fallback)

Same result, from your machine, with your own git credentials — no PAT or
secret needed:

```bash
# Preview what would be pushed:
scripts/release.sh legal-person git@github.com:donvito/hermes-profile-legal-person.git --dry-run

# Real push:
scripts/release.sh legal-person git@github.com:donvito/hermes-profile-legal-person.git
```

## What gets pushed

The contents of `profiles/legal-person/` become the delivery repo's root,
as a single fresh commit per release (stamped with the monorepo commit it
was cut from) plus tag `v<version>`. For example:

```
.gitignore
CHANGELOG.md
LICENSE.md
README.md
SOUL.md
config.yaml
cron/weekly-digest.yaml
distribution.yaml
skills/case-summary/SKILL.md
skills/contract-review/SKILL.md
```

What does NOT get pushed:

- **The rest of the monorepo** — other profiles, `scripts/`, the monorepo
  README, git history.
- **Secrets or user data** — the CI static checks fail the release if
  user-owned files are staged, and `hermes profile install` hard-strips
  user-owned paths on the install side regardless (`USER_OWNED_EXCLUDE` in
  hermes-agent's `hermes_cli/profile_distribution.py`).

The delivery repo is a **one-way mirror**: each release overwrites its
contents, so edits made directly on the delivery repo are clobbered by the
next release. Make all changes in this monorepo.

## Shipping a new version later

1. Bump `version:` in `distribution.yaml` (e.g. `0.2.0`) and update
   `CHANGELOG.md`. Commit to `main`.
2. Tag `legal-person-v0.2.0` and push the tag (or run `release.sh` manually).

Re-releasing an existing version fails on purpose — `release.sh` refuses if
tag `v0.2.0` already exists on the delivery repo. Installed users pick up the
new version with:

```bash
hermes profile update legal-person
```

Updates replace distribution-owned paths (`SOUL.md`, `skills/`, `cron/`,
`mcp.json`, `distribution.yaml`) and preserve the user's `config.yaml`,
`.env`, memories, and sessions — see [`compat.md`](compat.md) for details.

## Notes on tags vs GitHub Releases

- This flow pushes **git tags**, not GitHub "Releases" (the UI objects with
  release notes and attachments). `hermes profile install` / `update` only
  need the git repo; a GitHub Release is optional decoration you can draft
  on top of the delivery repo's tag if you want visible release notes.
- Two tag namespaces are in play: `<profile-name>-v<semver>` on this monorepo
  (the CI trigger), and `v<semver>` on the delivery repo (created by
  `release.sh`).
- Installs track the delivery repo's **default branch**, not tags — git-ref
  pinning isn't implemented upstream. That's why `release.sh` only
  fast-forwards the delivery repo at tagged, validated versions.
