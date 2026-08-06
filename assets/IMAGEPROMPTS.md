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

## Supporting-cast atlas

`assets/dialogue/original_sources/campaign-supporting-cast.png` was generated
without image references as a three-column atlas for Lysa Vey, Asha Vale, and
Dax Calder. The brief specified original industrial-fantasy field clothing,
distinct ages and silhouettes, a cohesive brass/teal/coral palette, flat
magenta backgrounds, and no text, logos, known characters, or franchise motifs.
The same builder extracts transparent portraits into `assets/dialogue/portraits/`.

## Adding art

1. Write a project-specific visual brief and record it here.
2. Generate without external images or named stylistic imitation.
3. Keep the untouched generated source under an `original_sources/` directory.
4. Derive runtime assets through a committed reproducible tool.
5. Verify transparent edges, target-size readability, exact file counts, and
   absence of inactive or unlicensed source material.
