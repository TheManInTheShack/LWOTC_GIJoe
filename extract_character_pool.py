# ------------------------------------------------------------------------------
# Extract character + appearance data from a XCOM2 CharacterPool .bin
#
# The .bin is UE3's flat property-list serialization: a sequence of
# length-prefixed strings (positive length = ASCII incl. null terminator,
# negative length = UTF-16LE incl. null terminator) interleaved with raw
# property values. This script walks that stream, regroups it per character
# (split on "strFirstName"), and pulls out the NameProperty/StrProperty
# fields - i.e. character identity plus every appearance slot (nmHead,
# nmTorso, nmHelmet, etc).
#
# IntProperty fields (tints, colors, gender, attitude, ...) are NOT extracted:
# their raw int values aren't length-prefixed strings, and reliably locating
# them requires a full UE3 property-list parser rather than this heuristic
# string walk.
# ------------------------------------------------------------------------------
import struct
import collections
import json
import sys

SRC = "mod/CharacterPool/LWOTC_GIJoe_complete.bin"
DST = "data/character_pool_export.json"


def tokenize(data):
    pos = 0
    tokens = []
    while pos < len(data) - 4:
        n = struct.unpack_from("<i", data, pos)[0]
        if 0 < n < 256:
            s = data[pos + 4:pos + 4 + n - 1]
            if all(32 <= b < 127 for b in s):
                tokens.append(s.decode('ascii'))
                pos += 4 + n
                continue
        elif -256 < n < 0:
            ln = -n
            s = data[pos + 4:pos + 4 + (ln - 1) * 2]
            try:
                dec = s.decode('utf-16-le')
                if all(32 <= ord(c) < 127 for c in dec):
                    tokens.append(dec)
                    pos += 4 + ln * 2
                    continue
            except Exception:
                pass
        pos += 1
    return tokens


def split_characters(tokens):
    chunks, cur = [], []
    for t in tokens:
        if t == 'strFirstName' and cur:
            chunks.append(cur)
            cur = []
        cur.append(t)
    chunks.append(cur)
    return chunks[1:]  # drop header preamble


def extract_record(chunk):
    rec = {"FirstName": None, "LastName": None, "NickName": None,
           "SoldierClass": None, "CharacterTemplate": None, "appearance": {}}
    for i, t in enumerate(chunk):
        if i + 2 >= len(chunk):
            continue
        nxt, val = chunk[i + 1], chunk[i + 2]
        if t == 'strFirstName' and nxt == 'StrProperty':
            rec["FirstName"] = val
        elif t == 'strLastName' and nxt == 'StrProperty':
            rec["LastName"] = val
        elif t == 'strNickName' and nxt == 'StrProperty':
            rec["NickName"] = val
        elif t == 'm_SoldierClassTemplateName' and nxt == 'NameProperty':
            rec["SoldierClass"] = val
        elif t == 'CharacterTemplateName' and nxt == 'NameProperty':
            rec["CharacterTemplate"] = val
        elif t.startswith('nm') and nxt == 'NameProperty':
            rec["appearance"][t] = val
    return rec


def main():
    src = sys.argv[1] if len(sys.argv) > 1 else SRC
    dst = sys.argv[2] if len(sys.argv) > 2 else DST

    with open(src, "rb") as f:
        data = f.read()

    tokens = tokenize(data)
    chunks = split_characters(tokens)
    characters = [extract_record(c) for c in chunks]

    asset_index = collections.defaultdict(set)
    for c in characters:
        for k, v in c["appearance"].items():
            asset_index[k].add(v)
    asset_index = {k: sorted(v) for k, v in sorted(asset_index.items())}

    total_assets = set()
    for vals in asset_index.values():
        total_assets.update(vals)

    class_counts = collections.Counter(c["SoldierClass"] for c in characters)

    out = {
        "meta": {
            "source": src,
            "extracted_with": "extract_character_pool.py",
            "total_characters": len(characters),
            "total_distinct_visual_assets": len(total_assets),
            "soldier_class_assignment_counts": dict(class_counts),
            "notes": [
                "Extraction covers NameProperty/StrProperty fields only "
                "(character identity + all appearance slots, including "
                "voice/flag/language alongside the strictly visual ones).",
                "IntProperty fields (tints, colors, gender, attitude, etc.) "
                "are NOT included - see module docstring.",
                "Most records have SoldierClass='None'. The custom GIJoe__* "
                "class assignment (defined in mod/Config/XComClassData.ini) "
                "is not embedded per-character in this file; the link "
                "between character pool entries and custom classes needs to "
                "be reverse-engineered separately.",
            ],
        },
        "asset_index": asset_index,
        "characters": characters,
    }

    with open(dst, "w", encoding="utf-8") as f:
        json.dump(out, f, indent=1)

    print(f"Wrote {dst}")
    print(f"Characters: {len(characters)} | Distinct values across appearance slots: {len(total_assets)}")


if __name__ == "__main__":
    main()
