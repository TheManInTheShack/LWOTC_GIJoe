---
title: GI Joe Mod
type: moc
tags:
  - moc
  - gi-joe-mod
created: 2026-06-13
---

# GI Joe Mod

This vault is the home of the rebuilt GI Joe mod for XCOM 2: War of the
Chosen / LWOTC. The previous iteration was a script-driven "data factory"
(spreadsheet -> `.ini`/`.int` mod files); that output and tooling are
preserved as-is under `archive/` for reference while this iteration
recasts the same data as a graph.

## Folders

The repo root is organized into domains, each its own folder:

- **`archive/`** -- the entire previous iteration, frozen as-is for
  reference. Not edited going forward.
- [[data_processing/index|`data_processing/`]] -- the Python backend.
  Drives the creation of everything: the scripts and services that build,
  query, and transform [[graph_data/index|`graph_data/`]], and that
  ultimately produce the [[mod/index|`mod/`]] output. Also exposes the API
  that [[interface/index|`interface/`]] talks to.
- [[graph_data/index|`graph_data/`]] -- the database layer. The graph
  itself: characters, visual assets, donor mods, soldier classes, and
  abilities, and the edges between them (usage, provenance, grants, etc.).
- [[interface/index|`interface/`]] -- a Godot app, run from within a
  browser, that talks to `data_processing/`'s API to browse and edit the
  graph.
- [[mod/index|`mod/`]] -- the packaged output: the part that goes on Steam
  (XCOM 2 Workshop release).
- **`documentation/`** (this folder) -- one more domain alongside the
  others, not a container for them. Both an input and an output: notes
  here can seed/describe parts of the graph, and can be generated from it,
  with Obsidian's links and graph view doubling as a view into
  `graph_data/`.

## Background

[[handoff|HANDOFF.md]] is the end-of-session brief from the previous
iteration: what the old repo was, what was learned from analyzing the
character pool, and the rough phase plan this rewrite follows.
