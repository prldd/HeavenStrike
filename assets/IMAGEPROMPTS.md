# Original Art Briefs and Provenance

All production images in this project must be original or properly licensed.
Generation prompts must describe War of Resonance's own visual language and
must not name, upload, transform, or imitate a third-party character, sprite,
game, artist, or franchise.

The active target for all new and revised assets is
[`documentation/Modern_Field_Command_Visual_Direction.md`](../documentation/Modern_Field_Command_Visual_Direction.md).
It supersedes the industrial-fantasy, antique-brass, parchment, and ornate
storybook language preserved in older briefs below. Those passages document how
committed source art was produced; they are provenance, not current generation
instructions. New prompts may retain the Ink and Cell rendering technique but
must use modern enclosed shells, dark joints, modular equipment, restrained
signal light, contemporary infrastructure, and the canonical color semantics.

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
faction hue variants, flips later variants for formation variety, and created
the original 210-card full-body and portrait output set. Standalone sources
extend that set without changing the established atlas variant order.

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

## Stable-ID completion and final fallback replacements

Fifteen standalone chassis sources were generated with the built-in OpenAI
image-generation tool on 2026-08-09, without input images or external visual
references. Five create the completed catalog IDs 30, 36, 42, 47, and 48;
one creates the mission-only ground transport, and nine replace the last
atlas-derived runtime fallbacks. Untouched chroma sources
are retained in `assets/units/original_sources/generated_chassis/chroma/`.
`tools/build_original_unit_art.gd` samples and removes the matte, contracts the
edge by one pixel, normalizes each cutout to a transparent 1024×1024 canvas,
and writes `cutouts/`, `gen/`, faction provenance, runtime full-body art, and
portraits. The roster now has generated `gen/` art for every active art ID.

### Priority roster modernization

Forty-three standalone replacement sources were generated with the built-in
OpenAI image-generation tool on 2026-08-17. No external images, characters,
artists, games, or franchises were referenced. The work targets the units that
previously repeated the general class-atlas frames most visibly: the four
chassis-synergy families, the Resonant Chorus carriers, Helio Mender-162, four
late dramatic promotions, the Steam faction anchor, and the skill-defining
late-game roster from icons 188 through 207. Untouched opaque chroma sources
are retained in `assets/units/original_sources/generated_chassis/chroma/`.

The shared prompt direction requested one complete original autonomous machine,
centered in three-quarter view against perfectly uniform opaque `#ff00ff`, with
modern enclosed armor, dark mechanical joints, sparse functional signal light,
clean Ink and Cell contours, controlled cel shading, and a silhouette readable
at card scale. It excluded people, pilots, text, logos, scenery, cast shadows,
medieval armor, heraldry, steampunk, exposed gears, giant-mech proportions,
photorealism, and equal-density greebling. Promotion edits used only their
project-original base source as a reference and preserved its chassis identity.

Faction and mechanic motifs were deliberately separated:

- Universal Foundation Grid uses blue-grey relay rails and modular braces:
  `217`, `218`.
- Coal Aegis Lattice uses graphite armor, ember-red heat channels, and broad
  interlocking shields: `219`, `220`.
- Wind Vector Manifold uses pale-blue aerodynamic outriggers and vector fins:
  `221`, `222`.
- Solar Resonance Pulse uses white ceramic medical armor and a segmented amber
  pulse halo: `223`, `224`.
- Resonant Chorus carriers use paired/tuned emitter geometry while retaining
  faction palettes: art IDs `35`, `36`, `69`, `70`, `603`, `107`, `108`, `633`.
- Helio Mender-162 is the restrained precursor to the existing elite
  Helio Mender-163: art ID `865`.
- Zephyr Weaver-168/169 and Cinder Battery-170/171 turn their one-star tools
  into unmistakable twin-channel six-star forms: `1025`–`1028`.
- Brass Bastion-186/187 establishes a modern Steam-faction Dragnet anchor with
  civic teal pressure armor and deployable restraint vanes: `1011`, `1012`.
- Retaliation Screen uses deployed interception surfaces: `697`, `698`, `1123`,
  `1124`; Petrify Loop uses nested phase rings: `747`, `748`; Silent Cycle uses
  a progressively closed suppression halo: `1019`, `1020`.
- Thermal Wrap is expressed by mantle-like heat shielding across distinct Steam
  Lifebinder, Coal Channeler, and Steam Warden bodies: `263`, `264`, `321`,
  `322`, `567`, `568`.
- Umbral Clamp has three intentionally different capture silhouettes: Wind
  biped interceptors (`693`, `694`), low Wind quadrupeds (`1053`, `1054`), and
  Fusion tripod field clamps with nested magnetic jaws (`1153`, `1154`).

`tools/build_original_unit_art.gd` removes the matte, normalizes the transparent
canvas, and installs these sources under their existing numeric art IDs, so no
catalog identity, promotion link, replay, or save mapping changes.

### Roster-wide faction and class modernization

The remaining 166 atlas-derived playable units were reprocessed on 2026-08-17
with the built-in OpenAI image-generation tool. No external images, characters,
artists, games, or franchises were referenced. Nine starting Reserve units
(`001`–`009`) were generated as individual sources. The other 157 units were
authored across 42 faction-and-class roster sheets, with promotion families kept
in adjacent cells so each upgrade reads as the same chassis receiving a clear
equipment refit rather than becoming an unrelated machine.

Untouched generated sheets live under
`assets/units/original_sources/generated_roster_atlases/chroma/`. Their committed
manifest records the exact row-major art-ID mapping, and
`tools/extract_generated_roster_atlases.gd` reproducibly crops the individual
green-matte sources into `generated_chassis/chroma/` before the standard unit-art
builder removes the matte and produces runtime sprites and portraits.

The shared sheet brief required one complete, right-facing autonomous machine
per equal cell; generous green gutter; modern enclosed armor; dark manufactured
joints; sparse functional light; clean Ink and Cell contours; controlled cel
shading; and no pilots, text, logos, scenery, floor, cast shadows, medieval
armor, heraldry, Victorian machinery, exposed decorative gears, giant-mech
proportions, or equal-density greebling. Every cell named its unit, promotion
parent, star tier, and secondary skill so equipment differences remain authored
rather than arbitrary.

Faction identity was locked independently from class identity:

- Universal: modular blue-grey and cool-white shells with cyan relay hardware.
- Coal: graphite and heat-shield red with orange thermal systems and extraction
  logistics hardware.
- Steam: oxidized teal, cool steel, and pressure white with civic/transit
  engineering modules, explicitly excluding historical steampunk motifs.
- Wind: pale blue, silver, and cyan with swept navigation fins and lightweight
  highland-network construction.
- Fusion: graphite, silver, and restrained violet containment assemblies.
- Solar: ceramic white, blue-black, and precise amber heliostat systems.

Class silhouettes were equally explicit: Wardens carry shield mass and planted
frames; Duelists use paired close-combat tools; Striders use long legs and a
forward lean; Artillerists expose a barrel, recoil brace, and counterweight;
Channelers carry coils, arc vanes, and a luminous core; Lifebinders carry repair
manipulators, reservoirs, and protective halo geometry. This pass gives every
active art ID a direct generated source while retaining all stable numeric IDs,
catalog identities, promotion links, replay mappings, and save compatibility.

### Late-roster reused-silhouette replacement

The 69 remaining class-atlas derivations, icons `225` through `293`, were
replaced on 2026-08-22 with individual sources generated by the built-in OpenAI
image-generation tool. No input images or external visual references were used.
The 224 existing direct modern sources were treated as protected and were not
regenerated. Stable icon-to-art mappings were retained, including art IDs
`1307` through `1320` for icons whose numeric filenames would otherwise collide.

Each prompt named the unit, faction, class, star tier, and secondary skill. The
shared direction requested one complete autonomous right-facing machine with a
distinct body plan and equipment layout; modern enclosed armor; dark manufactured
joints; sparse functional light; confident Ink and Cell contours; broad opaque
shapes; controlled two-to-three-value cel shading; and card-scale readability.
It excluded people, pilots, text, logos, scenery, floors, shadows, medieval or
heraldic styling, Victorian machinery, steampunk, decorative exposed gears,
giant-mech proportions, photorealism, equal-density greebling, and recognizable
franchise motifs.

Faction and class constraints used the established production matrix: Coal is
graphite, heat-shield red, and thermal orange; Steam is oxidized teal, cool steel,
and pressure white; Wind is pale blue, silver, and cyan; Fusion is graphite,
silver, and restrained violet; Solar is ceramic white, blue-black, and amber.
Wardens emphasize shield mass, Duelists paired close-combat tools, Striders long
legs and forward lean, Artillerists barrel/recoil/counterweight construction,
Channelers coils/vanes/luminous cores, and Lifebinders repair arms/reservoirs/
protective halos. Every unit also received unique functional hardware derived
from its named skill—for example Siphon Edge drain blades, Interference Net
tether spars, Temporal Rewind counter-rotating rings, Apex Confluence converging
rails, and Sacrificial Pyre's reserve cell and heat crown.

The generated source files are committed under their stable IDs in
`assets/units/original_sources/generated_chassis/chroma/`.
`tools/normalize_late_roster_chroma.gd` flattens only transparent files in this
69-source batch onto a solid green matte before the standard builder removes the
key and writes cutouts, provenance copies, battlefield sprites, and portraits.

### Chassis-synergy atlas extensions

Icons `217`–`224` were added on 2026-08-10 as four two-stage promotion
families for the Standard, Bulwark, Swift, and Resonant synergy mechanics.
Their original full-body provenance was derived reproducibly from the
project-owned class atlases. Those initial sources were replaced in the
2026-08-17 modernization batch above while retaining the same stable art IDs,
transparent 1024×1024 canvas, orientation, and portrait crop:

- `217` / `218` — Relay Battery, Universal Artillerist, Foundation Grid.
- `219` / `220` — Cinder Bastion, Coal Warden, Aegis Lattice.
- `221` / `222` — Zephyr Lancer, Wind Strider, Vector Manifold.
- `223` / `224` — Helio Mender, Solar Lifebinder, Resonance Pulse.

Shared final prompt:

> Create one entirely original War of Resonance industrial-fantasy autonomous
> machine as a 1024×1024 full-body tactical RPG unit sprite. Use the Ink and
> Cell language: confident dark ink contours, broad opaque matte gouache
> shapes, crisp two-to-three-value cel shading, restrained dry-brush texture,
> and simplified readable mechanical construction. Show one complete machine,
> centered with generous padding, facing right in a three-quarter side view on
> a perfectly flat solid #ff00ff chroma-key background. No human pilot, text,
> logo, watermark, border, shadow, reflection, crop, sprite sheet, atlas,
> multiple view, or #ff00ff in the subject.

Subject and palette additions to that shared prompt:

- `1301` — Relay Bastion-030: layered pale-blue failover shield, square silver
  chassis, antique-brass hinges, cyan capacitors, short anchor hammer; Universal
  Warden silhouette.
- `1302` — Cinder Blade-036: paired furnace-edged cleavers, ember-red cowls,
  blackened steel, brass heat vents, orange-white core; Coal Duelist silhouette.
- `1303` — Zephyr Lancer-042: long silver legs, sky-blue fins, twin lance arms,
  slipstream vanes, cyan turbine; Wind Strider silhouette.
- `1304` — Flux Weaver-047: suspended violet core, stepped indigo coil hoops,
  phase lenses, silver tripod frame; Fusion Channeler silhouette.
- `1305` — Helio Mender-048: ivory body, warm-gold repair halo, amber
  reservoirs, precise manipulators, cyan sun-disc aperture; Solar Lifebinder.
- `1306` — Relay Ground Transport-216: mission-only Universal convoy crawler;
  low broad six-wheel silhouette, enclosed pale-blue cargo vault, reinforced
  silver-and-brass armor, cyan navigation lens, and exactly one small forward
  defensive cannon. Generated on 2026-08-10 with no image references using the
  shared Ink and Cell/chroma constraints, plus explicit exclusions for people,
  limbs, shields, humanoid anatomy, tank proportions, and additional weapons.
- `866` — Helio Mender-163: elite ivory-gold Shield Exchange repair frame with
  segmented halo, emitter dishes, amber reservoirs, and cyan-white aperture.
- `887` / `888` — Relay Blade-100/101: base and promoted slate-blue paired-blade
  Lumen Shell frames; the promotion adds larger blades, twin shell rings, and
  reinforced relay modules.
- `947` / `948` — Cinder Bastion-166/167: base and promoted black-steel,
  furnace-red Paired Circuit Wardens with tower shields, anchor mauls, and
  paired brass conduits.
- `965` / `966` — Brass Mender-180/181: base and promoted oxidized-teal repair
  frames with brass tanks, manipulators, clamps, and folding snare projectors.
- `979` — Relay Blade-174: disciplined blue-grey paired-saber frame with one
  compact back-mounted lane-shield generator.
- `980` — Relay Blade-175: elite blue-grey paired-saber frame with twin
  lane-shield projectors; the final revision explicitly zoomed out to retain at
  least twelve percent padding around both complete swords and every extremity.

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

The reference-derived mission-stage set keeps one uninterrupted matte floor
while changing only the perimeter inspiration: orderly training hall, ancient
Relay excavation, civic proving circuit, five-faction industrial crossroads,
fortified coalition front, and intact Caelian sanctum. All six used
`assets/boards/reference-playboard.png` as the composition and safe-floor edit
reference; prompts excluded floor props, authored grids, text, characters, and
UI. Untouched generated sources are retained beside the reference in
`assets/boards/original_sources/`.

Regenerate the normalized 2167x726 runtime copies with:

```bash
./tools/godot-headless.sh --script res://tools/build_board_background_art.gd
```

## Conductor battle HUD instruments

The Life, Mana, and deck-count instrument sources were generated with the
built-in OpenAI image-generation tool on 2026-08-11, without input images or
external visual references. Untouched green-matte sources live under
`assets/ui/original_sources/chroma/`; transparent, normalized runtime assets
live directly under `assets/ui/`.

Their shared prompt direction was:

> Create one original War of Resonance conductor HUD instrument in the Ink and
> Cell language: confident dark contours, broad matte gouache shapes, crisp
> two-to-three-value cel shading, restrained brush texture, pale enamel,
> silver steel, antique brass, and one broad dark empty reading aperture for a
> live value drawn in code. Use a straight-on orthographic view, a strong
> tiny-scale silhouette, and a perfectly flat solid-green chroma background.
> No text, numbers, letters, logos, watermark, cast shadow, characters, hands,
> or unrelated objects.

Each readout has a distinct physical metaphor:

- Life: near-square mechanical life-core vessel with a coral-crimson heartlike
  pulse core, paired pulse fins, clamps, and a large central aperture.
- Mana: wide arc-energy capacitor with cyan-white induction coils, electrical
  arcs, blue reservoir fins, and a central power readout chamber.
- Deck: exactly three offset slate-blue tactical cards in an antique-brass
  counting cradle, with a small cyan corner pip and front counting aperture.

Remove the matte and rebuild the runtime copies with:

```bash
./tools/godot-headless.sh --script res://tools/build_conductor_hud_art.gd
```

## Adding art

1. Write a project-specific visual brief and record it here.
2. Generate without external images or named stylistic imitation.
3. Keep the untouched generated source under an `original_sources/` directory.
4. Derive runtime assets through a committed reproducible tool.
5. Verify transparent edges, target-size readability, exact file counts, and
   absence of inactive or unlicensed source material.
