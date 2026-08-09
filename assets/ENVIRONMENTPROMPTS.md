# Environment Prompts

Composition reference: `assets/boards/reference-playboard.png`. Preserve its
clear floor footprint; vary only the setting and palette around it.

Current stage examples: training hall, Relay excavation, proving circuit,
faction crossroads, coalition front, and Caelis sanctum under `assets/boards/`.

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
