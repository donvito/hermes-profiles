#!/usr/bin/env bash
# validate.sh — install a profile from this monorepo into a throwaway Hermes
# profile, run `hermes doctor`, and smoke-check the installed tree.
#
# Usage:
#   scripts/validate.sh <profile-name> [--keep]
#
#   <profile-name>  directory name under profiles/ (e.g. legal-person)
#   --keep          leave the <name>-validate profile installed for inspection
#
# Requires the `hermes` CLI on PATH (install: https://hermes-agent.nousresearch.com).
# Uses the local-directory install path of `hermes profile install`, which is
# the officially supported way to test a distribution before pushing
# (website/docs/user-guide/profile-distributions.md in hermes-agent).

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROFILE_NAME="${1:-}"
KEEP="${2:-}"

if [[ -z "$PROFILE_NAME" ]]; then
    echo "Usage: scripts/validate.sh <profile-name> [--keep]" >&2
    echo "Available profiles:" >&2
    ls "$REPO_ROOT/profiles" >&2
    exit 2
fi

PROFILE_DIR="$REPO_ROOT/profiles/$PROFILE_NAME"
TEST_NAME="${PROFILE_NAME}-validate"

fail() { echo "FAIL: $*" >&2; exit 1; }
ok()   { echo "  ok: $*"; }

[[ -d "$PROFILE_DIR" ]] || fail "no such profile directory: $PROFILE_DIR"
command -v hermes >/dev/null 2>&1 || fail "hermes CLI not found on PATH"

echo "== Static checks: $PROFILE_NAME =="

[[ -f "$PROFILE_DIR/distribution.yaml" ]] || fail "distribution.yaml missing (required by hermes profile install)"
python3 - "$PROFILE_DIR" <<'PY'
import sys, pathlib
try:
    import yaml
except ImportError:
    sys.exit("PyYAML is required: pip install pyyaml")
root = pathlib.Path(sys.argv[1])

# distribution.yaml: 'name' is the only hard requirement in the manifest schema
mf = yaml.safe_load((root / "distribution.yaml").read_text())
assert isinstance(mf, dict) and mf.get("name"), "distribution.yaml must define 'name'"
assert mf["name"] == root.name, f"manifest name {mf['name']!r} != directory {root.name!r}"
print(f"  ok: distribution.yaml ({mf['name']} {mf.get('version', '0.1.0')})")

# config.yaml must parse if present
cfg_path = root / "config.yaml"
if cfg_path.exists():
    cfg = yaml.safe_load(cfg_path.read_text())
    assert isinstance(cfg, dict), "config.yaml must be a mapping"
    print("  ok: config.yaml parses")

# Every skill needs SKILL.md with name + description frontmatter
skills = sorted((root / "skills").glob("*/")) if (root / "skills").is_dir() else []
for skill_dir in skills:
    md = skill_dir / "SKILL.md"
    assert md.is_file(), f"{skill_dir.name}: SKILL.md missing"
    text = md.read_text()
    assert text.startswith("---"), f"{skill_dir.name}: missing YAML frontmatter"
    fm = yaml.safe_load(text.split("---", 2)[1])
    assert fm.get("name"), f"{skill_dir.name}: frontmatter missing 'name'"
    desc = fm.get("description") or ""
    assert desc, f"{skill_dir.name}: frontmatter missing 'description'"
    assert len(fm["name"]) <= 64, f"{skill_dir.name}: name > 64 chars"
    assert len(desc) <= 1024, f"{skill_dir.name}: description > 1024 chars"
    print(f"  ok: skill {fm['name']}")

# Cron templates must parse
cron_dir = root / "cron"
if cron_dir.is_dir():
    for f in sorted(cron_dir.glob("*.yaml")):
        job = yaml.safe_load(f.read_text())
        assert isinstance(job, dict) and job.get("schedule") and job.get("prompt"), \
            f"cron/{f.name}: needs at least 'schedule' and 'prompt'"
        print(f"  ok: cron template {f.name}")

# No secrets / user data staged in the profile directory
forbidden = [".env", "auth.json", "state.db", "memories", "sessions", "logs"]
present = [p for p in forbidden if (root / p).exists()]
assert not present, f"user-owned paths must not ship in a distribution: {present}"
print("  ok: no user-owned paths present")
PY

echo
echo "== Install into throwaway profile: $TEST_NAME =="
hermes profile delete "$TEST_NAME" -y >/dev/null 2>&1 || true
hermes profile install "$PROFILE_DIR" --name "$TEST_NAME" -y

INSTALLED="$HOME/.hermes/profiles/$TEST_NAME"
[[ -f "$INSTALLED/SOUL.md" ]]            && ok "SOUL.md installed"
[[ -f "$INSTALLED/config.yaml" ]]        && ok "config.yaml installed"
[[ -f "$INSTALLED/distribution.yaml" ]]  && ok "distribution.yaml installed (with source + installed_at)"
find "$INSTALLED/skills" -name SKILL.md | grep -q . && ok "skills installed"
[[ -f "$INSTALLED/.env" ]] && fail ".env must never be installed from a distribution"

echo
echo "== hermes profile info =="
hermes profile info "$TEST_NAME"

echo
echo "== hermes doctor (informational — may warn about missing API keys) =="
hermes -p "$TEST_NAME" doctor || echo "(doctor exited non-zero — review output above)"

if [[ "$KEEP" == "--keep" ]]; then
    echo
    echo "Keeping profile '$TEST_NAME' ($INSTALLED). Delete with:"
    echo "  hermes profile delete $TEST_NAME -y"
else
    echo
    echo "== Cleanup =="
    hermes profile delete "$TEST_NAME" -y
fi

echo
echo "PASS: $PROFILE_NAME validates and installs cleanly."
