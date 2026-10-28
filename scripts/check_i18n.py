#!/usr/bin/env python3
"""Lint the translations in `.i18n/<lang>/Game.json`.

Keys are the English strings with each code span replaced by a positional placeholder
`§0`, `§1`, ...; the game substitutes the N-th code span of the English text for `§N`.
A translation that drops, adds or renumbers placeholders therefore shows the wrong code
snippets to players. This script fails on:

  * placeholder mismatches between a key and its translation,
  * duplicate keys (later ones silently win when the JSON is loaded),
  * over-escaped quotes, which players see as a literal `\"`,
  * keys that no longer exist in `.i18n/en/Game.pot` (the English text was edited, so the
    translation is never shown).

Strings in the template that a language doesn't translate yet are only reported.

Usage: python scripts/check_i18n.py [lang ...]   (default: every language in .i18n/)
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent / ".i18n"
PLACEHOLDER = re.compile(r"§\d+")


def pot_msgids(path):
    ids, cur, in_id = set(), "", False
    for line in path.read_text(encoding="utf-8").splitlines():
        if line.startswith("msgid "):
            cur, in_id = json.loads(line[6:]), True
        elif line.startswith('"') and in_id:
            cur += json.loads(line)
        elif line.startswith("msgstr"):
            if cur:
                ids.add(cur)
            in_id = False
    return ids


def check(lang, template):
    pairs = json.loads((ROOT / lang / "Game.json").read_text(encoding="utf-8"),
                       object_pairs_hook=lambda p: p)
    errors, seen = [], set()
    for key, value in pairs:
        short = key[:70].replace("\n", " ")
        if key in seen:
            errors.append(f"duplicate key: {short!r}")
        seen.add(key)
        if key not in template:
            errors.append(f"key not in Game.pot (English text changed?): {short!r}")
        if '\\"' in value and '\\"' not in key:
            errors.append(f"literal backslash-quote (over-escaped in the .po file): {short!r}")
        want, got = set(PLACEHOLDER.findall(key)), set(PLACEHOLDER.findall(value))
        if value.strip() and want != got:
            missing = ", ".join(sorted(want - got, key=lambda s: int(s[1:])))
            extra = ", ".join(sorted(got - want, key=lambda s: int(s[1:])))
            errors.append(f"placeholders missing [{missing}] extra [{extra}]: {short!r}")
    untranslated = len(template - seen)
    for e in errors:
        print(f"::error file=.i18n/{lang}/Game.json::{e}")
    print(f"{lang}: {len(pairs)} entries, {len(errors)} errors, {untranslated} untranslated")
    return not errors


def main(langs):
    template = pot_msgids(ROOT / "en" / "Game.pot")
    langs = langs or sorted(p.name for p in ROOT.iterdir() if (p / "Game.json").exists())
    ok = all([check(lang, template) for lang in langs])
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main(sys.argv[1:])
