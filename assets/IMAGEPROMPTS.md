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

### Chassis-synergy atlas extensions

Icons `217`–`224` were added on 2026-08-10 as four two-stage promotion
families for the Standard, Bulwark, Swift, and Resonant synergy mechanics. No
new external or AI-generated source was used. Their full-body provenance is
derived reproducibly from the project-owned class atlases by
`tools/build_original_unit_art.gd`, using the established faction recoloring,
transparent 1024×1024 canvas, right-facing orientation, and portrait crop:

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

## Modular anime-mecha vertical slice

The four untouched transparent concept sources under
`assets/units/modular/concepts/` were generated with the built-in OpenAI
image-generation tool on 2026-08-15, without input images or external visual
references. They are an art-direction vertical slice used only by Unit View /
Creator; deployed units and portraits still use the existing runtime art.

The two socket-compatible body masters share a neutral ready stance, full-body
square canvas, empty universal hand hardpoints, strong outer contours, broad
cel-shaded masses, and detail intended to survive near 120 pixels tall. Their
construction briefs deliberately diverged:

- Coal: heavyweight furnace machine with riveted overlapping slab armor,
  exposed hydraulic pistons, a protected ember core, asymmetrical exhaust, and
  broad load-bearing feet in soot iron, burnt umber, steel, and orange heat.
- Wind: lightweight turbine machine with swept ceramic shells, interlocking
  plates, tension struts, calf turbines, compact sensors, and integrated
  airfoils in pearl white, navy, teal, and cyan energy.

Each matching Artillerist weapon sheet requested exactly three isolated,
right-facing cutouts in equal horizontal rows with the faction's common
circular hardpoint. Coal contains a magnetic rail cannon, rotary autocannon,
and twin siege launcher. Wind contains a beam rifle, turbine repeater, and
guided dart cell. All prompts required genuine transparency, complete
silhouettes, original designs, no robots or hands in weapon sheets, no text,
logos, watermark, ground shadow, familiar franchise motifs, or excessive
micro-detail.

The articulated follow-up used each approved body master as its sole edit
target. The prompt preserved faction identity while requesting an exploded
transparent inventory with separate head, torso/pelvis, back accessory,
shoulders, paired upper arms, paired forearms, paired hands, paired thighs,
paired shins, and paired feet. Every piece was required to keep the source
view direction and end at a clean circular mechanical socket, with no assembled
robot, weapons, labels, overlaps, missing hands/feet, redesign, or added parts.
A second background-extraction edit changed only the generated checkerboard to
genuine alpha. `tools/build_modular_mecha_parts.gd` then crops 17 runtime PNGs
per faction into `assets/units/modular/parts/`.

## Adding art

1. Write a project-specific visual brief and record it here.
2. Generate without external images or named stylistic imitation.
3. Keep the untouched generated source under an `original_sources/` directory.
4. Derive runtime assets through a committed reproducible tool.
5. Verify transparent edges, target-size readability, exact file counts, and
   absence of inactive or unlicensed source material.
