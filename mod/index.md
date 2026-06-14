---
title: Mod
type: moc
tags:
  - moc
  - space/mod
  - gi-joe-mod
created: 2026-06-13
---

# Mod

The packaged output: the part that goes on Steam. [[data_processing/index|Data
Processing]] compiles [[graph_data/index|Graph Data]] into an XCOM 2 (WotC) /
LWOTC mod here, ready for a Workshop release.

## Prior build (archived)

`archive/mod/` is the last generated mod folder (frozen at the pre-rewrite
checkpoint): `.XComMod` manifest, `Config/`, `Localization/`, character
pool `.bin`, and `ModList.txt` documenting ~170 Workshop mods it's designed
to run alongside.

## Plan

- Public-facing build pipeline: graph -> XCOM 2 `.ini`/`.int` output, so
  others can use it.
- Limited Steam Workshop release of the resulting mod.
- Ongoing cycle: add characters repeatedly using the new pipeline.

[[home|Home]]
