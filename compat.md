# Compatibility

How this repo's profile layout maps onto the actual hermes-agent code, and
which versions are supported. File references are paths in
[NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent).

## Version matrix

| Profile | Profile version | Requires Hermes | Verified against |
|---|---|---|---|
| legal-person | 0.1.0 | >=0.18.0 | hermes-agent 0.18.2 |
| realestate-agent | 0.1.0 | >=0.18.0 | hermes-agent 0.18.2 |
| home-manager | 0.1.0 | >=0.18.0 | hermes-agent 0.18.2 |

The pin lives in each profile's `distribution.yaml` as `hermes_requires`
(single comparator, checked at install time by
`hermes_cli/profile_distribution.py::check_hermes_requires`).

## How each file is consumed

| File in a profile | Consumed by (hermes-agent) | Notes |
|---|---|---|
| `distribution.yaml` | `hermes_cli/profile_distribution.py` | Required at the source root; `name` is the only mandatory field. Installer stamps `source:` and `installed_at:` into the installed copy. |
| `SOUL.md` | agent system-prompt assembly | Replaces the default personality (`hermes_cli/default_soul.py`). Distribution-owned: replaced on `profile update`. |
| `config.yaml` | `hermes_cli/config.py` (deep-merged over `DEFAULT_CONFIG`) | Non-secret settings only. Preserved on update unless `--force-config`. |
| `config.yaml → mcp_servers` | `tools/mcp_tool.py`, `hermes_cli/mcp_config.py` | This is the ONLY place the runtime reads MCP servers from — there is no standalone `mcp/` or `mcp.json` loader, which is why these profiles keep MCP config in `config.yaml` rather than the `mcp/` directory some layouts suggest. `${VAR}` values interpolate from the profile `.env`. |
| `skills/<name>/SKILL.md` | skill loader (`agent/skill_utils.py` et al.) | YAML frontmatter requires `name` (≤64 chars) and `description` (≤1024; house style ≤60). Optional `scripts/`, `references/`, `templates/` subdirs. |
| `cron/*.yaml` | copied by the installer; **not** auto-scheduled | The scheduler only reads `cron/jobs.json`, created when jobs are registered. Our `cron/*.yaml` files are reviewed templates whose fields mirror `hermes cron create` (`cron/jobs.py::create_job`); each file's header shows the exact registration command. |
| `env_requires` (manifest) | installer | Checked against the shell + profile `.env`; a `.env.EXAMPLE` is generated in the installed profile. Secrets are never shipped. |
| `.gitignore` | git only | Mirrors the installer's `USER_OWNED_EXCLUDE` so a profile developed in place can't commit secrets or user data. |
| `README.md`, `CHANGELOG.md`, `LICENSE.md` | humans | Copied into the installed profile (harmless), replaced on update. |

## Differences from the "suggested" layout

- **`VERSION.yaml`** — not used; the version lives in `distribution.yaml`
  (`version:`), which is what `hermes profile info` and `hermes profile list`
  display.
- **`mcp/<server>.yaml`** — not used; hermes-agent reads MCP servers from
  `config.yaml → mcp_servers` only (see table above).
- **`config.yaml` pinning the hermes version** — the enforced pin is
  `hermes_requires` in `distribution.yaml`; `config.yaml` has no version
  field the installer checks.

## Install semantics worth knowing

- `hermes profile install <git-url>` clones the URL and requires
  `distribution.yaml` at the **repo root** (`_stage_source`). Monorepo
  subdirectories therefore install via the local-directory path
  (`hermes profile install ./profiles/<name>`) or via the per-profile
  delivery repos produced by `scripts/release.sh` /
  `.github/workflows/release.yaml`.
- Git-ref pinning (`#v1.2.0` suffixes) is documented as planned upstream but
  not implemented — installs track the delivery repo's default branch, which
  is why `release.sh` only fast-forwards the delivery repo at tagged,
  validated versions.
- On update, distribution-owned paths (`SOUL.md`, `skills/`, `cron/`,
  `mcp.json`, `distribution.yaml`) are replaced; `config.yaml` is preserved;
  user-owned paths (`.env`, `auth.json`, `memories/`, `sessions/`,
  `state.db*`, `logs/`, `workspace/`, `home/`, `local/`, caches) are never
  touched and are hard-stripped by the installer even if accidentally
  committed.
- **Cron caveat (verified against 0.18.2):** because `cron/` is
  distribution-owned, `hermes profile update` replaces the whole directory —
  including `cron/jobs.json`, where jobs you registered with
  `hermes cron create` live. After an update, re-register jobs from the
  shipped templates (`hermes -p <name> cron list` to confirm what's gone).
- Profile names must match `[a-z0-9][a-z0-9_-]{0,63}` and must not collide
  with reserved names (`hermes`, `default`, `test`, `tmp`, `root`, `sudo`)
  or hermes subcommands — all three directory names here comply.
