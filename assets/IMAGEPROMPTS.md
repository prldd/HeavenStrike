# Original Art Briefs and Provenance

All production images in this project must be original or properly licensed.
Generation prompts must describe War of Resonance's own visual language and
must not name, upload, transform, or imitate a third-party character, sprite,
game, artist, or franchise.

## Playable chassis atlases

The seven committed atlases in `assets/units/original_sources/class_atlases/`
were generated as new work without image references. Their shared brief was:

> Six distinct autonomous industrial-fantasy combat machines on a 3×2 atlas;
> compact readable tactical-game silhouettes; pale blue enamel, silver steel,
> antique brass, cyan power light, dark ink outlines; exactly one machine per
> cell; flat pure-magenta background; no humans, text, logos, borders, shadows,
> known characters, or franchise-specific motifs.

Each class added its own silhouette requirements:

- Warden: shields, broad armor, planted defensive stance.
- Duelist: paired melee implements and agile close-combat posture.
- Strider: long legs, light armor, scouting tools, forward motion.
- Artillerist: integrated cannon, recoil brace, ammunition mechanism.
- Channeler: arc coils, suspended vanes, luminous control core.
- Lifebinder: repair manipulators, reservoirs, protective halo shapes.

Two Strider atlases provide twelve base silhouettes; every other class has six.
`tools/build_original_unit_art.gd` removes the magenta matte, derives controlled
faction hue variants, flips later variants for formation variety, and creates
the 210 committed full-body and portrait outputs.

## Ink and Cell full-body replacements

Updated full-body sources live in `assets/units/gen/`, keyed by the stable
numeric art IDs returned by `UnitCatalog.art_id()`. They use the project's
`assets/ARTSTYLES.md` Ink and Cell guidance: strong ink contours, broad opaque
paint shapes, crisp cel-shaded values, restrained brush texture, simplified
mechanical construction, and transparent 1024x1024 canvases.

Install every available replacement into the runtime `assets/units/full/`
directory with:

```bash
./tools/godot-headless.sh --script res://tools/install_generated_unit_art.gd
```

The installer validates source filenames against the active roster art map,
preserves the complete canvas used by `BoardView` for consistent scaling,
enables mipmaps on every runtime import, and retains the atlas-derived runtime
fallback for any active art ID that does not yet have a generated replacement.

## Supporting-cast atlas

`assets/dialogue/original_sources/campaign-supporting-cast.png` was generated
without image references as a three-column atlas for Lysa Vey, Asha Vale, and
Dax Calder. The brief specified original industrial-fantasy field clothing,
distinct ages and silhouettes, a cohesive brass/teal/coral palette, flat
magenta backgrounds, and no text, logos, known characters, or franchise motifs.
The same builder extracts transparent portraits into `assets/dialogue/portraits/`.

## Campaign operations maps

The three Act maps in `assets/operations_maps/original_sources/` were generated
as original 1672x941 environment illustrations, without external image
references. The existing map layouts were used only as project-owned edit
targets so their geography, landmark positions, negative space, and campaign
route logic would remain stable.

Their shared brief was:

> A deliberately simplified, cel-shaded ink-and-gouache operations map with
> confident varied dark contours, broad opaque matte color shapes, two or three
> crisp value groups, restrained dry-brush texture, sparse internal linework,
> and five large readable industrial-fantasy landmark silhouettes; pale enamel,
> silver steel, antique brass, muted earth, and restrained cyan power light;
> broad quiet terrain behind mission buttons and labels; roughly one fifth the
> visual detail of a painted environment; no mission nodes, route overlays,
> text, people, logos, or watermark.

Each Act preserved its authored progression:

- Act I: relay excavation, salvage arena, tented settlement, monumental bridge,
  and upper-right Sanctuary along a lower-left to upper-right frontier route.
- Act II: coast and arena, circular excavation, civic highlands, amber industrial
  core, and the fortified cyan Gate of Caelis across five crisis regions.
- Act III: outer gate, Imperial Archive, Conductor Vault, Civic Core, and radiant
  Source linked by the broad circular platforms and bridges of Caelis.

Regenerate the runtime copies with:

```bash
./tools/godot-headless.sh --script res://tools/build_operations_map_art.gd
```

## Battlefield backgrounds

The outdoor courtyard and indoor training hall sources in
`assets/boards/original_sources/` were generated as project-original edits of
the existing board composition. The edit targets fixed the panoramic camera,
arena footprint, commander dais positions, and gameplay-safe negative space.
Updated unit images `001`, `003`, and `005` were supplied only as visual-style
references; their characters were explicitly excluded from the environments.

Their shared final prompt direction was:

> Restyle the board as a hand-painted Ink and Cell industrial-fantasy tactical
> environment with confident varied contours, broad opaque matte gouache
> shapes, crisp two-or-three-group cel shading, restrained brush texture,
> simplified manufactured construction, and moderate readable detail. Build
> the central battlefield into the environment as one quiet deck of a few
> large pale-enamel and warm-slate panels with antique-brass rails and dark
> recessed seams. Remove small paving and plank subdivisions. Preserve the
> exact panoramic composition and do not add an explicit grid, cells, units,
> text, UI, logos, or watermark; the exact 3x7 inlays are drawn in code.

The courtyard variant keeps a sparse outdoor workshop skyline, distant hills,
and cyan/coral side-dais accents. The training variant replaces the skyline
with broad steel arches, clerestory light, pale wall panels, and a minimal
equipment wall while retaining the same gameplay footprint and palette.

Regenerate the normalized 2167x726 runtime copies with:

```bash
./tools/godot-headless.sh --script res://tools/build_board_background_art.gd
```

## Adding art

1. Write a project-specific visual brief and record it here.
2. Generate without external images or named stylistic imitation.
3. Keep the untouched generated source under an `original_sources/` directory.
4. Derive runtime assets through a committed reproducible tool.
5. Verify transparent edges, target-size readability, exact file counts, and
   absence of inactive or unlicensed source material.
