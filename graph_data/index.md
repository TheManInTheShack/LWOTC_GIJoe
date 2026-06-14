---
title: Graph Data
type: moc
tags:
  - moc
  - space/graph-data
  - gi-joe-mod
created: 2026-06-13
---

# Graph Data

The graph data model at the core of this rewrite: characters, visual
assets, donor mods, soldier classes, and abilities, with edges capturing
relationships like "character uses asset", "asset provided by mod", and
"class grants ability".

Produced and consumed by [[data_processing/index|Data Processing]];
authored and browsed via [[interface/index|Interface]]; compiled into
[[mod/index|Mod]] output.

## Seed data (archived)

- `archive/data/character_pool_export.json` -- export of the previous
  character pool: 171 character records across 33 appearance slots, 568
  distinct asset values. See [[archive/HANDOFF|HANDOFF.md]] for the full
  analysis and caveats (e.g. `IntProperty` fields like tints/gender/skin
  color were not extracted).
- `archive/data/data.xlsx` -- `characters` and `abilities` sheets: ~60
  custom soldier classes and their ability loadouts.

## Design tasks

- Define the graph schema (nodes: characters, visual assets, donor mods,
  soldier classes, abilities; edges: usage/provenance/grants relationships).
- Decide on storage (JSON/SQLite/other) and the markdown round-trip format
  used by [[interface/index|Interface]].

[[home|Home]]
