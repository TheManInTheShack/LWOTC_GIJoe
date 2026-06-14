---
title: Data Processing
type: moc
tags:
  - moc
  - space/data-processing
  - gi-joe-mod
created: 2026-06-13
---

# Data Processing

Pipelines and tooling that turn raw sources into [[graph_data/index|Graph
Data]]:

- Character/class/ability data from `data.xlsx`.
- Ability definitions scraped from donor LWOTC class mods.
- Visual appearance data extracted from the XCOM 2 character pool `.bin`
  format.

## Prior art (archived)

The previous iteration's pipeline scripts are preserved for reference:

- `archive/make_classes.py` -- spreadsheet -> mod `.ini`/`.int` generator.
- `archive/gather_ability_info.py` / `archive/update_ability_sheet.py` --
  scrape donor mods (`archive/examples/classes/`) and sync `data.xlsx`.
- `archive/extract_character_pool.py` -- parses a character pool `.bin`
  into `archive/data/character_pool_export.json`.
- `archive/marauder.py` -- depends on an unvendored `dopes` package; not
  currently runnable. See [[handoff|HANDOFF.md]] for notes.

## Open questions

- How does the character pool (171 entries, mostly appearance-only) map to
  the ~60 custom `GIJoe__*` soldier classes at runtime? Needs tracing
  through LWOTC's class-assignment config.
- Build a donor-mod -> asset mapping table (needs Steam Workshop content not
  vendored in this repo).

[[home|Home]]
