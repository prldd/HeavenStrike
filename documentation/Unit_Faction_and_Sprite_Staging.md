# Original Unit Art Matrix

This document defines the production boundary for playable unit art. Every live
unit is an original autonomous chassis with a direct project-generated source.
The older project-owned class atlases remain committed as historical provenance
and a development fallback, but no active runtime unit depends on them.
No third-party sprite, portrait, character design, or extracted sheet is part of
the runtime or source-art tree.

New and revised unit art follows
[`Modern_Field_Command_Visual_Direction.md`](Modern_Field_Command_Visual_Direction.md).
The Ink and Cell rendering method remains valid, but the active design language
uses enclosed contemporary armor shells, dark manufactured joints, compact
optics, modular role equipment, and sparse functional light. Historical
industrial-fantasy atlas prompts are retained as provenance, not as the target
for future chassis.

## Source and outputs

- `assets/units/original_sources/class_atlases/` contains seven original source
  atlases: one each for Warden, Duelist, Artillerist, Channeler, and Lifebinder,
  plus two Strider atlases for additional silhouette variety. They are retained
  for provenance and fallback tooling only.
- `assets/units/original_sources/generated_roster_atlases/chroma/` retains 42
  untouched faction-and-class generation sheets. Its manifest maps their 157
  cells to stable art IDs.
- `assets/units/original_sources/generated_chassis/chroma/` contains individual
  generated mattes: untouched standalone sources plus deterministic crops from
  the roster sheets. `cutouts/` contains their reproducible alpha derivatives.
- `assets/units/original_sources/faction_chassis/<Faction>/<Class>/` contains
  293 derived provenance images: 292 playable chassis and one mission-only
  ground transport.
- `assets/units/gen/` contains transparent generated art for every active roster
  ID.
- `assets/units/full/` contains exactly the same 293 art IDs as runtime
  full-body sprites.
- `assets/units/portraits/` contains exactly the same 293 art IDs as cropped
  menu portraits.

Regenerate all derived assets with:

```bash
./tools/godot-headless.sh --script res://tools/extract_generated_roster_atlases.gd
./tools/godot-headless.sh --script res://tools/normalize_late_roster_chroma.gd
./tools/godot-headless.sh --script res://tools/build_original_unit_art.gd
```

The builder reads playable units from `UnitCatalog`, mission assets from
`MissionUnitCatalog`, faction assignment from `UnitCatalog.FACTION_ICON_IDS`,
and art filename mapping from `UnitCatalog.ICON_ART_IDS`. It asserts a unique
art ID for every playable and mission unit.

## Faction color language

| Pool | Palette treatment | Narrative use |
|---|---|---|
| Coal | graphite, heat-shield red, thermal orange | extraction and heavy logistics |
| Steam | oxidized teal, cool steel, pressure white | civic engineering and transit authorities |
| Wind | pale blue, silver, cyan navigation light | distributed highland and aerial networks |
| Fusion | graphite, restrained violet or green containment light | experimental energy enclaves |
| Solar | ceramic white, blue-black, precise amber charge | heliostat city-states |
| Universal | blue-grey, cool white, cyan interfaces | shared or unaffiliated chassis |

Faction palettes change broad armor zones and one restrained signal-light hue
while preserving graphite understructure and strong ink separation. Interaction
colors remain stable regardless of faction: cyan player, coral threat, green
repair or valid deployment, and amber warning. Promotion families must stay
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
| Transport | Mission asset | wheels or tracks, enclosed cargo mass, no humanoid anatomy |

New art must extend this language without imitating an existing entertainment
property. Record any new generation brief and source file in
`assets/IMAGEPROMPTS.md`, then regenerate and run the IP-boundary smoke checks.
Reject medieval armor, heraldry, ornamental filigree, exposed Victorian boilers,
decorative gear motifs, giant piloted-mech proportions, and equal-density
greebling. At gameplay size, class silhouette and facing must read before
surface detail.
