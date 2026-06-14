# LWOTC_GIJoe

A from-scratch rewrite of a GI Joe mod for XCOM 2: War of the Chosen /
LWOTC, recast as a graph-based data model with an Obsidian-flavored
documentation layer. Start at [[documentation/home|documentation/home.md]].

## Layout

- `archive/` -- the entire previous iteration (data-factory scripts, the
  generated mod, spreadsheets, donor-mod examples), frozen as-is for
  reference. Don't edit; read for prior art only.
- `documentation/` -- the living vault: `home.md` (entry MOC),
  `handoff.md` (maintained status/plan brief), `templates/`, and one
  folder per "space" (`data_processing/`, `graph_data/`, `interface/`,
  `mod/`), each with an `index.md` MOC.
- Root stays clean: `.git`, `.gitignore`, `.obsidian` (when present),
  `CLAUDE.md`, plus `archive/` and `documentation/`.

## Conventions

- **Folders**: `lower_snake_case`.
- **Markdown files**: `kebab-case.md`.
- **Data files**: `snake_case`.
- Lowercase everything unless there's a specific reason not to (e.g.
  preserving original names of archived material).
- New markdown notes get basic YAML frontmatter -- see
  `documentation/templates/note-template.md` for the shape
  (`title`, `type`, `tags`, `created`).
- Tag heavily; tags and `[[wikilinks]]` are how this vault doubles as a
  view into the graph data model. Use nested tags like `space/graph-data`
  for space membership, plus `moc` for index/map-of-content notes.
