#!/usr/bin/env python3
import argparse
import importlib.util
import json
import re
import sys
from pathlib import Path

sys.dont_write_bytecode = True

DEFAULT_ROOT = Path(__file__).resolve().parents[1]

ALLOWED_STATES = {"tested", "untested", "unsupported"}
ROW_RE = re.compile(
    r'\{\s*vendor\s*=\s*"([^"]*)"\s*;\s*pattern\s*=\s*"([^"]*)"\s*;'
    r'\s*profile\s*=\s*"([^"]*)"\s*;\s*state\s*=\s*"([^"]*)"\s*;\s*\}',
    re.S,
)
ALIAS_RE = re.compile(
    r'\{\s*vendor\s*=\s*"([^"]*)"\s*;\s*pattern\s*=\s*"([^"]*)"\s*;\s*\}',
    re.S,
)
DOCS_ROW_RE = re.compile(
    r"\|\s*([^|]+?)\s*\|\s*`([^`]+)`\s*\|\s*`([^`]+)`\s*\|\s*([^|]+?)\s*\|"
)

errors = []


def check(condition, message):
    if not condition:
        errors.append(message)


def load_module(script_path):
    spec = importlib.util.spec_from_file_location("regenerate_hardware", script_path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def read_block(text, name):
    match = re.search(r"\b%s\s*=\s*\[(.*?)\]\s*;" % re.escape(name), text, re.S)
    if not match:
        raise SystemExit("check-hardware-profile: missing %s block" % name)
    return match.group(1)


def parse_table(text):
    rows = []
    for vendor, pattern, profile, state in ROW_RE.findall(read_block(text, "hardwareProfiles")):
        rows.append((vendor, pattern, profile, state))
    return rows


def parse_aliases(text):
    return ALIAS_RE.findall(read_block(text, "vendorAliases"))


def parse_choices(text):
    match = re.search(r"choices = \[(.*?)\];", text, re.S)
    if not match:
        raise SystemExit("check-hardware-profile: missing choices list in 09-facter.nix")
    return re.findall(r'"([^"]*)"', match.group(1))


def parse_docs(text):
    rows = []
    for line in text.splitlines():
        match = DOCS_ROW_RE.fullmatch(line.strip())
        if match:
            rows.append(tuple(part.strip() for part in match.groups()))
    return rows


def main():
    parser = argparse.ArgumentParser(
        description="Check the ojuny hardware profile mapping and coverage table."
    )
    parser.add_argument("--root", default=str(DEFAULT_ROOT), help="Repository path.")
    args = parser.parse_args()

    root = Path(args.root).resolve()
    module_path = root / "modules/07-system/10-hardware-profile.nix"
    page_path = root / "modules/07-system/09-facter.nix"
    script_path = root / "scripts/regenerate-hardware.py"
    fixture_path = root / "tests/fixtures/facter-surface-go.json"
    docs_path = root / "docs/hardware-coverage.md"

    module = load_module(script_path)
    table_text = module_path.read_text()
    page_text = page_path.read_text()

    nix_rows = parse_table(table_text)
    nix_aliases = parse_aliases(table_text)
    choices = parse_choices(page_text)
    docs_rows = parse_docs(docs_path.read_text())

    check(
        nix_rows == module.HARDWARE_PROFILES,
        "10-hardware-profile.nix and scripts/regenerate-hardware.py tables differ",
    )
    check(
        nix_aliases == module.VENDOR_ALIASES,
        "10-hardware-profile.nix and scripts/regenerate-hardware.py vendor aliases differ",
    )

    states = {row[3] for row in nix_rows}
    check(states <= ALLOWED_STATES, "unexpected coverage state: %s" % sorted(states - ALLOWED_STATES))

    supported = sorted({row[2] for row in nix_rows if row[3] != "unsupported"})
    check(choices[:1] == ["auto"], "dropdown must start with auto")
    check(choices[1:] == supported, "dropdown choices do not match the supported profiles")
    check(choices[1:] == sorted(choices[1:]), "dropdown profile choices are not sorted")

    check(
        [tuple(row) for row in docs_rows] == nix_rows,
        "docs/hardware-coverage.md rows do not match the coverage table",
    )

    fixture = json.loads(fixture_path.read_text())
    surface = module.detect_profile(fixture)
    check(surface["vendor"] == "microsoft", "Surface Go vendor was not detected as microsoft")
    check(
        surface["profile"] == "microsoft-surface-go",
        "Surface Go did not select microsoft-surface-go",
    )
    check(surface["state"] == "untested", "Surface Go state is not untested")

    unknown = module.detect_profile(
        {"smbios": {"system": {"manufacturer": "Acme", "product": "Unknown 1"}}}
    )
    check(unknown["profile"] == "unmatched", "unknown product did not return unmatched")
    check(unknown["state"] == "unmatched", "unknown product state is not unmatched")

    check(
        module.selected_profile(fixture, "auto") == "microsoft-surface-go",
        "auto selection did not pick the Surface Go profile",
    )

    unsupported = {
        "smbios": {"system": {"manufacturer": "Dell Inc.", "product": "XPS 13 9343"}}
    }
    check(
        module.selected_profile(unsupported, "auto") is None,
        "auto selection must not pick an unsupported profile",
    )
    check(
        module.selected_profile(unsupported, "dell-xps-13-9343") == "dell-xps-13-9343",
        "explicit selection must honour an unsupported profile",
    )

    if errors:
        for error in errors:
            print("check-hardware-profile: %s" % error, file=sys.stderr)
        return 1

    print(
        "check-hardware-profile: ok (%d rows, %d supported, Surface Go -> %s)"
        % (len(nix_rows), len(supported), surface["profile"])
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
