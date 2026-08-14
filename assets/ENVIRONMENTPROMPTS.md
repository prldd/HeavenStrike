# Environment Prompts

The active environment direction is **Modern Field Command**: contemporary
hard-surface science fiction, graphite composite structures, cyan signal
lighting, sparse warning amber, angular modular architecture, and clean
tactical negative space. Avoid medieval, cathedral, heraldic, parchment,
brass, and Victorian-steampunk cues.

Composition reference: `assets/boards/reference-playboard.png`. Preserve its
clear floor footprint; vary only the setting and palette around it.

The active stage set lives under `assets/boards/modern/`; untouched generated
sources live under `assets/boards/original_sources/modern/`. The earlier Ink
and Cell stage set remains under `assets/boards/` as provenance and fallback.

Use the Ink and Cell guidance in `ARTSTYLES.md`: strong ink contours, broad
matte gouache shapes, crisp cel shading, restrained texture, simplified
construction, and the same detail level as the unit sprites.

## Playboard prompt

Create an empty panoramic tactical arena as one opaque full-bleed 2167×726 RGB
PNG. Use an elevated three-quarter camera, level horizon, and centered floor.

The protected play area is this trapezoid:

- top-left `(341,247)`
- top-right `(1826,247)`
- bottom-right `(1947,708)`
- bottom-left `(220,708)`

Keep it flat, matte, evenly lit, and visually quiet. Add no raised objects,
architecture, rails, steps, cables, strong seams, shadows, glow, fog, symbols,
or baked-in grid. At most six tiny low-contrast scuffs or flat debris pieces
under 24×14 pixels may appear, away from cell centers and grid seams.

Place sparse architecture and props beyond the play area using a few large
silhouettes. Keep the central background low contrast and the bottom edge
unobstructed. No characters, units, text, logos, UI, cropping, padding,
letterboxing, stretching, or border. Nothing may compete with the runtime 3×7
grid or unit sprites.

## Faction palette

- **Solar:** white-gold, blue-black roofs, amber light.
- **Steam:** brass, copper, verdigris, clean steam.
- **Coal:** black iron, soot, ash, ember orange.
- **Wind:** pale blue, silver, turbines, open sky.
- **Fusion:** graphite, compact green core, restrained circuits.
- **Caelis:** ivory, silver-gold, dormant relay machinery.
- **Neutral:** stone, timber, plain metal, soft daylight.

## Other environments

Use 1672×941 with the same style and palette. Reserve broad low-detail space for
UI; the playboard safe zone is not required.

Reject any playboard with the wrong size or anything raised, bright,
high-contrast, grid-like, or interactive-looking inside the protected area.

## Modern Field Command set

The main-menu source was generated with the built-in OpenAI image-generation
tool on 2026-08-13 and is preserved at
`assets/backgrounds/original_sources/main-menu-command-deck.png`. Its final
prompt direction was:

> Create an original cinematic science-fiction command-deck overlook above a
> dense frontier megacity after rain. Place a tall agile humanoid combat mech
> on a maintenance gantry in the right third, with quiet dark negative space
> across the left third for a vertical menu. Use sleek modular concrete,
> service rails, antenna arrays, holographic navigation beacons, elevated
> highways, and angular towers. Render it as premium stylized anime-inspired
> hard-surface key art with graphite, slate, cyan, electric blue, and sparse
> amber. Blue-hour storm-clearing light. No text, logos, flags, heraldry,
> swords, castles, domes, gothic arches, steampunk gears, fantasy ornament, or
> copied characters, interface, and environments.

The six modern stage sources were generated with the same tool on 2026-08-13.
Their shared final prompt direction was:

> Create an original very-wide battlefield background for a lane-based
> tactical mech game. Use a straight-on arena view with the horizon near the
> upper third. Reserve the lower 62 percent as one broad, empty, evenly lit
> graphite combat deck with extremely subtle modular seams and no props,
> because runtime units and a translucent 3x7 grid are drawn over it. Use
> premium stylized anime-inspired science-fiction hard-surface rendering,
> crisp graphic shapes, subtle cel-shaded edges, contemporary industrial or
> aerospace design, cyan signal lighting, and sparse warning accents. No text,
> logos, UI, banners, flags, heraldry, arches, castles, gothic architecture,
> steampunk gears, parchment, brass, gold, beige, sepia, or fantasy ornament.

The per-stage subjects were:

- **Training:** a military robotics hangar with armored observation galleries,
  maintenance rails, robotic gantries, vents, strip lights, and a sealed blast
  door.
- **Relay excavation:** a research platform beside a collapsed megastructure,
  with modular survey containers, sensor masts, cable bridges, and a partially
  uncovered cyan energy relay.
- **Proving circuit:** an orbital-elevator rooftop test deck with armored-glass
  control pods, telemetry booms, drone docks, and a distant coastal megacity.
- **Faction crossroads:** a suspended logistics platform where black/orange
  industry, white/cyan renewables, and dark/green bio-reactive districts meet.
- **Coalition front:** an armored command-carrier deck above a stormy mountain
  theater, with angular blast shields, defense batteries, radar blades, and
  distant carriers.
- **Caelis sanctum:** a quantum command core with graphite-and-white structural
  rings, a circular energy aperture, minimal plasma pylons, recessed service
  doors, and no classical ornament.

The build tool center-crops these 2:1 sources to the runtime playboard aspect,
then resizes them to 2167x726 so all active stages share one draw geometry.

The three active operations-map sources were generated with the built-in
OpenAI image-generation tool on 2026-08-13 and are preserved under
`assets/operations_maps/original_sources/modern/`. Their shared final prompt
direction was:

> Create an original 16:9 high-altitude oblique strategic view for a tactical
> mech campaign. Arrange five readable destination zones around broad dark
> logistics corridors, leaving open low-contrast spaces for runtime routes and
> mission nodes. Use premium stylized anime-inspired hard-surface illustration,
> crisp graphic forms, subtle cel-shaded edges, graphite infrastructure, cyan
> energy, and sparse safety accents. Do not bake in pins, paths, labels,
> borders, or UI. No text, logos, fantasy temples, domes, castles, heraldry,
> decorative borders, parchment, brass, gold, beige, sepia, or steampunk gears.

The act variants progress from a reclaimed plateau megacity with an excavation,
training complex, proving deck, mag-rail bridge, and command arcology; through a
storm crisis split among orange industry, white/cyan renewables, green research,
and a coalition carrier port; to a dark mountain quantum arcology whose cyan,
violet, carrier, and defense districts climb toward a white final command core.
