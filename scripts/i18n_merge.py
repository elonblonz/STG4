#!/usr/bin/env python3
"""Merge the English template into every translation, like gettext's `msgmerge`.

After `lake build` regenerates `.i18n/en/Game.pot`, run

    python scripts/i18n_merge.py [--drafts drafts.json] [--rename renames.json]

then `lake exe i18n --export-json` to regenerate the `.json` files the game loads.

For each `.i18n/<lang>/Game.po` this rewrites the file in template order: each entry gets the
template's comments and msgid, and keeps its existing msgstr. Strings no longer in the template
are dropped and listed, so their translations can be carried over:

  --rename FILE   JSON object {old_msgid: new_msgid}: reuse the old translation for the new
                  msgid (for edits that don't change the meaning, e.g. typo fixes).
  --drafts FILE   JSON object {msgid: {"<lang>": translation, ...}}: new translations.
                  Drafts take precedence over existing and renamed translations.
"""
import argparse
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent / ".i18n"


def parse(path):
    """Return a list of entries: (comment lines, msgid, msgstr)."""
    entries = []
    for block in path.read_text(encoding="utf-8").split("\n\n"):
        comments, fields, cur = [], {}, None
        for line in block.split("\n"):
            if not line.strip():
                continue
            if line.startswith("#"):
                comments.append(line)
            elif line.startswith(("msgid ", "msgstr ")):
                cur, rest = line.split(" ", 1)
                fields[cur] = json.loads(rest)
            elif line.startswith('"') and cur:
                fields[cur] += json.loads(line)
        if "msgid" in fields:
            entries.append((comments, fields["msgid"], fields.get("msgstr", "")))
    return entries


def quote(keyword, text):
    """Format a PO field the way the existing files do: one quoted line per source line."""
    lines = text.split("\n")
    parts = [line + "\n" for line in lines[:-1]] + ([lines[-1]] if lines[-1] else [])
    if len(parts) == 1:
        return [f"{keyword} {json.dumps(parts[0], ensure_ascii=False)}"]
    return [f'{keyword} ""'] + [json.dumps(p, ensure_ascii=False) for p in parts]


def render(entries):
    blocks = []
    for comments, msgid, msgstr in entries:
        blocks.append("\n".join(comments + quote("msgid", msgid) + quote("msgstr", msgstr)))
    return "\n\n".join(blocks) + "\n"


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--drafts", type=Path)
    ap.add_argument("--rename", type=Path)
    ap.add_argument("--dry-run", action="store_true", help="report only, don't write files")
    args = ap.parse_args()
    drafts = json.loads(args.drafts.read_text(encoding="utf-8")) if args.drafts else {}
    renames = json.loads(args.rename.read_text(encoding="utf-8")) if args.rename else {}

    template = parse(ROOT / "en" / "Game.pot")
    template_ids = {msgid for _, msgid, _ in template}
    unknown = (set(drafts) | set(renames.values())) - template_ids
    if unknown:
        raise SystemExit(f"not in Game.pot: {sorted(k[:60] for k in unknown)}")

    for po_path in sorted(ROOT.glob("*/Game.po")):
        lang = po_path.parent.name
        old = parse(po_path)
        header = next(e for e in old if e[1] == "")
        existing = {msgid: msgstr for _, msgid, msgstr in old if msgid}
        for old_id, new_id in renames.items():
            if old_id in existing and new_id not in existing:
                existing[new_id] = existing[old_id]
        merged = [header]
        missing = 0
        for comments, msgid, _ in template:
            if not msgid:
                continue
            msgstr = drafts.get(msgid, {}).get(lang) or existing.get(msgid, "")
            missing += not msgstr
            merged.append((comments, msgid, msgstr))
        dropped = [m for m in existing if m and m not in template_ids]
        if not args.dry_run:
            po_path.write_text(render(merged), encoding="utf-8", newline="\n")
        print(f"{lang}: {len(merged) - 1} entries, {missing} untranslated, {len(dropped)} dropped")
        for m in dropped:
            print(f"  dropped: {m[:100]!r}")


if __name__ == "__main__":
    main()
