---
title: Interface
type: moc
tags:
  - moc
  - space/interface
  - gi-joe-mod
created: 2026-06-13
---

# Interface

A **Godot** app, run from within a browser, for browsing and editing
[[graph_data/index|Graph Data]]. Talks to [[data_processing/index|Data
Processing]]'s API rather than touching the graph storage directly.

## Design tasks

- Define the API surface [[data_processing/index|Data Processing]] exposes
  (read/write operations the front-end needs).
- Scope the Godot front-end: what views are needed (character browser,
  appearance editor, class/ability editor)?
- Decide how the app is packaged/served for in-browser use (Godot web
  export).

[[home|Home]]
