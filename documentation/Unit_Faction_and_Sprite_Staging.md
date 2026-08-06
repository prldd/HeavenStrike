# Original Unit Art Matrix

This document defines the production boundary for playable unit art. Every live
unit is an original autonomous chassis derived from project-owned class atlases.
No third-party sprite, portrait, character design, or extracted sheet is part of
the runtime or source-art tree.

## Source and outputs

- `assets/units/original_sources/class_atlases/` contains seven original source
  atlases: one each for Warden, Duelist, Artillerist, Channeler, and Lifebinder,
  plus two Strider atlases for additional silhouette variety.
- `assets/units/original_sources/faction_chassis/<Faction>/<Class>/` contains
  the 210 derived per-unit provenance images.
- `assets/units/full/` contains exactly the same 210 art IDs as runtime
  full-body sprites.
- `assets/units/portraits/` contains exactly the same 210 art IDs as cropped
  menu portraits.

Regenerate all derived assets with:

```bash
./tools/godot-headless.sh --script res://tools/build_original_unit_art.gd
```

The builder reads faction assignment from `UnitCatalog.FACTION_ICON_IDS` and
art filename mapping from `UnitCatalog.ICON_ART_IDS`. It asserts a unique art ID
for every catalog unit.

## Faction color language

| Pool | Palette treatment | Narrative use |
|---|---|---|
| Coal | ember red and furnace orange | heavy industrial districts |
| Steam | oxidized teal and brass | civic engineering authorities |
| Wind | pale blue and silver | highland transport networks |
| Fusion | violet and electric indigo | experimental energy enclaves |
| Solar | warm gold and ivory | heliostat city-states |
| Universal | blue-grey and neutral brass | shared or unaffiliated chassis |

Faction palettes change enamel and power-light hues while preserving the
original neutral metal, brass, and ink structure. Promotion families must stay
within one pool. Numeric art filenames are stable persistence identifiers and
must not be renumbered casually.

## Class silhouette language

| Internal class | Player label | Visual signature |
|---|---|---|
| Warden | Defender | shield mass, broad planted stance |
| Duelist | Fighter | paired limbs or close-combat tool arms |
| Strider | Scout | narrow frame, long legs, forward lean |
| Artillerist | Gunner | visible barrel, recoil brace, rear counterweight |
| Channeler | Mage | suspended coils, arc vanes, luminous core |
| Lifebinder | Priest | repair arms, reservoir, protective halo geometry |

New art must extend this language without imitating an existing entertainment
property. Record any new generation brief and source file in
`assets/IMAGEPROMPTS.md`, then regenerate and run the IP-boundary smoke checks.
