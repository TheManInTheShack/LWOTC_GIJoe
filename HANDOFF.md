# LWOTC_GIJoe — Handoff / Next Iteration Brief

This is a summary of where things stand as of this session, written for
whoever (human or AI) picks this up next. The owner's plan is to use this
repo's "bones" to start a new iteration rather than continuing to patch the
current one.

## What this repo currently is

It's not a hand-written UnrealScript mod — it's a **data factory** that
generates an XCOM 2 (WotC) mod from spreadsheets:

- `data/data.xlsx` — source spreadsheet with `characters` and `abilities`
  sheets: ~60 G.I. Joe characters mapped to custom soldier classes, with
  abilities sourced from other LWOTC class mods.
- `make_classes.py` — reads `data/data.xlsx` and generates the actual mod
  output: `mod/Config/XComClassData.ini` (class defs + soldier list),
  `mod/Config/XComGameData.ini` (loadouts), `mod/Config/XComGame.ini`,
  `mod/Config/XComStartingSoldiers.ini`, and `mod/Localization/XComGame.int`.
- `gather_ability_info.py` / `update_ability_sheet.py` / `marauder.py` —
  upstream pipeline that scrapes ability definitions out of "donor" LWOTC
  class mods (vendored under `examples/classes/<workshopID>/`, includes full
  `.uc` UnrealScript sources for ~15 community classes) and keeps
  `data/data.xlsx` in sync.
- `mod/` — the actual mod folder: `.XComMod` manifest, generated `Config`/
  `Localization`, `ModPreview.jpg`, and `CharacterPool/LWOTC_GIJoe_complete.bin`.
- `mod/Mod List.txt` — documents ~170 Steam Workshop mods this is designed
  to run alongside (cosmetics, weapons, LWOTC framework mods, etc.), grouped
  by category (Cosmetic: 93, Gear: 27, UI: 27, LWOTC: 12, Perks: 9, ...).
- `textmod/` — separate side tool (`game_text_dominator`, PyInstaller-built)
  for bulk-editing in-game localization text.

### Known issues / cruft worth addressing in a rewrite

- `marauder.py` imports a private package `dopes` (`dopes.excel_tools`,
  `dopes.mapping_tools`) that isn't vendored and isn't on PyPI — that part
  of the pipeline is currently **unrunnable as-is**.
- `textmod/build/` + `textmod/dist/` are ~199MB of PyInstaller build
  artifacts checked into git. There is **no `.gitignore`** anywhere in the
  repo.
- `.marauder.py.swp` (stale Vim swapfile) and empty `foo.txt` are junk.
- `data/old/` has ~7 legacy spreadsheet copies.
- `.git` is ~243MB, mostly from the above.

## Character pool analysis (new this session)

`mod/CharacterPool/LWOTC_GIJoe_complete.bin` looked like an opaque binary but
is actually UE3's flat property-list serialization (length-prefixed ASCII /
UTF-16 strings) — fully parseable as plain data.

- **`extract_character_pool.py`** — standalone script that walks the `.bin`
  and exports it to JSON. Re-run with `python3 extract_character_pool.py`
  (defaults: reads `mod/CharacterPool/LWOTC_GIJoe_complete.bin`, writes
  `data/character_pool_export.json`).
- **`data/character_pool_export.json`** — the export. Contains:
  - `meta` — counts and caveats (see below).
  - `asset_index` — for each of the 33 appearance slots (`nmHead`, `nmTorso`,
    `nmArms`, `nmLegs`, `nmHelmet`, underlays, deco pieces, forearms,
    thighs/shins, tattoos, scars, face paint, haircut, beard, voice, flag,
    weapon pattern, etc.), the sorted list of distinct asset names used.
  - `characters` — all **171** character records (name, nickname, assigned
    soldier class / character template, and full appearance dict).

### Key findings

- **171 character records**, not ~60 — most exist purely for **appearance**
  (template `Soldier`, class `None`/`Rookie`). The ~60 custom `GIJoe__*`
  classes from `XComClassData.ini` are a separate layer; only one character
  in the pool (`Breaker` → `GIJoe__Breaker`) has a class wired up directly in
  the `.bin`. **How the other ~59 classes get matched to pool entries in-game
  is still an open question** — worth tracing through LWOTC's class
  assignment config before designing the new data model.
- **568 distinct values** are referenced across the 33 appearance slots
  (this is broader than "visual models" alone — it includes voice packs,
  country flags, weapon camo patterns, language).
- **Caveat**: this export only captures `NameProperty`/`StrProperty` fields.
  `IntProperty` fields (armor/weapon/tattoo tint indices, gender, skin color,
  attitude, hair color, etc.) are present in the `.bin` but were **not**
  reliably extractable with this quick heuristic parser — a real UE3
  property-list parser is needed to round-trip those too.
- Many asset names carry naming-convention fingerprints that map to specific
  entries in `mod/Mod List.txt`'s Cosmetic section, e.g.:
  - `Kev_Grim*` → GrimStyle Armor WOTC
  - `DLC_30_*` / `DLC_60_*` → vanilla Alien Hunters / Shen's Last Gift (no
    donor mod needed)
  - `HPW_WotC_SLD_MGO3_*` / `MGSV_*` → MGSV/MGO3 ports
  - `IRI_*` → Iridar packs
  - `Capnbubs_*` → Capnbubs Accessories
  - `COD_RussianOps_*` → CoD:MW Russian Operators pack
  - A full verified mapping needs the actual cosmetic mods' content/config,
    which **isn't vendored in this repo** (only the LWOTC class-donor mods
    under `examples/classes/` are). This is a good task to do where the
    Workshop downloads are locally available (e.g. on the laptop).

## Vision for the next iteration (from the owner)

Rough phase plan as described:

1. **Graph data model + clean I/O** — recast the visual-model data (from the
   character pool) and the class/ability data (from `data/data.xlsx`) as a
   graph, with a clean import/export layer. This export is the seed for that.
2. **Application** for processing the graph:
   - Visual interface built in **Godot**.
   - Text-based editing via **markdown** that syncs up/down with the graph
     (i.e. markdown as a human-editable serialization of graph state).
3. **Limited Steam Workshop release** of the resulting mod.
4. **Public-facing utility** wrapping the build pipeline (graph → XCOM2
   `.ini`/`.int` output), so others can use it.
5. Ongoing cycle: add characters repeatedly using the new pipeline.

## Suggested starting points

- Design the graph schema: nodes likely include characters, visual assets,
  donor mods, soldier classes, and abilities; edges capture "character uses
  asset", "asset provided by mod", "class grants ability", etc.
- Decide on graph storage (JSON/SQLite/other) and the markdown round-trip
  format before building the Godot front-end.
- Build the donor-mod → asset mapping table (needs Workshop content not
  present in this repo).
- Investigate the character-pool ↔ custom-class assignment mechanism in
  LWOTC before finalizing the schema.
- Decide what to do with `marauder.py`'s `dopes` dependency (replace, vendor,
  or drop) and clean up the repo (`.gitignore`, remove `textmod/build`/`dist`,
  remove junk files) — either as prep work or as part of the rewrite.
