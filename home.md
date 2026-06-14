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

## Spaces

- [[data_processing/index|Data Processing]] -- pipelines that turn source
  spreadsheets and donor-mod data into the graph.
- [[graph_data/index|Graph Data]] -- the graph data model: characters,
  visual assets, donor mods, soldier classes, and abilities, and how they
  relate.
- [[interface/index|Interface]] -- the visual (Godot) and markdown
  round-trip editor for the graph.
- [[mod/index|Mod]] -- the generated XCOM 2 / LWOTC mod output and
  packaging/release.

## Background

[[archive/HANDOFF|HANDOFF.md]] is the end-of-session brief from the previous
iteration: what the old repo was, what was learned from analyzing the
character pool, and the rough phase plan this rewrite follows.
