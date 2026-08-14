# Modern Field Command — Visual and Presentation Direction

This is the canonical art-direction guide for War of Resonance. It governs new
environment art, interface work, unit revisions, combat animation, narrative
staging, promotional images, and trailers. When older project notes call for an
ornate industrial-fantasy, parchment, antique-brass, or storybook treatment,
this document takes precedence.

The direction was refined after reviewing the public media for
[Code RAPID](https://store.steampowered.com/app/3499590/Code_RAPID/), including
its announcement teaser, current gameplay trailer, story trailer, and Steam
screenshots. Those materials are a reference for broad qualities—clarity,
velocity, scale, color discipline, and the contrast between machines and
authority—not a source of assets or designs. Do not copy its characters,
machines, logo, interface layouts, environments, story lines, terminology, or
shot compositions. War of Resonance remains an original turn-based game with
human-scale autonomous chassis and its own setting.

Reference review completed on 2026-08-13:

- The current Steam page, screenshots, gameplay trailer, story trailer, and
  store description linked above.
- The public
  [Code RAPID announcement teaser](https://www.youtube.com/watch?v=RsjfhSkGoaU).

These links document the source of the high-level direction only. Do not place
downloaded reference frames, video, audio, logos, or other third-party media in
the repository.

## Direction in one sentence

An austere field-command interface frames readable autonomous machines moving
through monumental, weathered infrastructure, with neutral hard surfaces and
small signal colors making every decision, threat, and impact immediately
legible.

## Core pillars

### Silhouette before surface

- A unit's class, facing, posture, and current action must read before panel
  seams, texture, or glow.
- Build machines from two or three large masses and one identifying feature.
- Keep joints and functional transitions dark so pale or colored armor shells
  separate clearly.
- Concentrate detail at the head or sensor cluster, chest, and role-defining
  equipment. Let the remaining surfaces rest.
- Use asymmetry to express purpose, repairs, or history, not as random noise.

### Monumental infrastructure, human-scale stakes

- Automatons remain human-scale. They are not piloted giant robots.
- Establish scale through elevated carriers, relay towers, suspended roads,
  maintenance wells, sealed hangars, radar walls, and distant arcologies.
- Favor broad platforms and a few enormous structural masses over decorative
  skylines filled with equally weighted detail.
- Let fog, rain, dust, cloud, and distance divide foreground, battlefield, and
  horizon into clear depth layers.
- The battlefield must remain an empty operational surface. Architecture lives
  beyond the playable footprint and never disguises the 3x7 board.

### Color is information

The world begins neutral. Emission is sparse and meaningful.

| Function | Color family | Reference value | Use |
|---|---|---|---|
| Field / structure | Graphite and blue-black | `#061018`, `#101D26` | Backgrounds, panels, joints |
| Primary information | Cool white | `#F2F8F9` | Titles, important values, silhouettes |
| Player / synchronized / selected | Cyan | `#38C7D6` | Focus, routes, player energy, active controls |
| Soft player support | Pale cyan | `#B8F3F5` | Secondary highlights and readable bloom cores |
| Hostile / invalid / damage | Coral red | `#EF6078` | Enemy identity, danger arcs, damage and blocked states |
| Warning / impact | Amber orange | `#FF884D` | Heat, timing warnings, explosions, rare priority calls |
| Recovery / valid placement | Signal green | `#70E0A1` | Healing, repair, legal deployment, confirmed recovery |
| Anomalous / Source activity | Restrained violet | `#C99CFF` | Fusion and exceptional Caelian events only |

- Most frames should contain graphite, cool white, and only one dominant
  signal color.
- Faction identity may tint armor or local light, but interaction colors stay
  consistent across factions.
- Do not make every seam emissive. Glow should reveal state or energy flow.
- Avoid sepia, parchment, decorative gold, and broad fields of warm beige.

### Velocity with readable causality

- Every action has anticipation, travel, contact, and recovery.
- Use one dominant motion vector and one focal event per beat.
- Show direction with a short trail, displaced dust or water, foreground
  parallax, a projectile path, or a compressed smear—not with indiscriminate
  particles.
- Give important hits a very brief impact hold before recoil and follow-through.
- Keep effects close to the contact point. A flash must reveal the hit, not hide
  the units.
- Movement begins before the strongest frame and continues after it. Avoid
  lineup poses and units waiting visibly for permission to act.

War of Resonance is turn-based. Velocity is staged, not simulated. An activation
may feel explosive, but its selected unit, path, target, result, and return to
board state must stay unambiguous. Never add fake real-time chaos that makes the
deterministic sequence harder to follow.

### Quiet frames give fast frames weight

- Alternate operational stillness with short action bursts.
- Use maintenance, weather, observation, and machine behavior for quiet scenes.
- A silent lens turn, protective step, delayed response, or chosen route can
  communicate automaton agency more effectively than exposition.
- After a major impact, allow a short clean frame in which the new state can be
  understood.

## Unit and character design

The existing Ink and Cell technique remains valid: confident contours, opaque
matte color shapes, crisp two- or three-value shading, and restrained painted
texture. Modern Field Command changes the design vocabulary applied through
that technique.

Use:

- Enclosed contemporary armor shells, manufactured joints, compact optics,
  service markings without legible text, modular equipment, and plausible
  maintenance access.
- White, graphite, or desaturated faction armor over dark mechanical
  understructure, with limited signal light.
- Clear class silhouettes: planted shield mass, close-combat wedge, long-legged
  scout, recoil-braced gun platform, controlled coil geometry, or repair halo.
- Wear at contact points and repaired panels that suggest service history.
- Head angle, lens aperture, stance, spacing, and timing to express personality.

Avoid:

- Medieval armor, crests, tabards, cloaks, heraldry, ornamental filigree,
  gothic shapes, and fantasy weapons disguised as machinery.
- Exposed Victorian boilers, decorative pipes, gear motifs, copper scrollwork,
  and antique brass as a default material.
- Generic military humanoids covered in equal-density greebles.
- Giant piloted-mech proportions, cockpit cues, or franchise-recognizable forms.
- Human mouths, skin, exaggerated anime faces, or skeletal robot anatomy.

Humans wear compact contemporary field clothing, technical layers, practical
harnesses, weather protection, and restrained augmentation. Formal authority is
shown through fit, posture, access, and interface privileges rather than capes,
crowns, medals, or ceremonial armor.

## Environment language

### Architecture

- Use angular modular construction, slab-like megastructures, industrial ribs,
  maintenance gantries, hard-surface carriers, antenna fields, and protected
  service routes.
- Mix functioning systems with controlled decay: patched decks, abandoned
  sectors, exposed aggregate, collapsed spans, and infrastructure still
  completing routines.
- Repeat functional modules at different scales to make a location feel built
  by a system rather than decorated by an illustrator.
- Caelian spaces are more precise and integrated than modern ones, not more
  classical. Their mystery comes from seamless function, impossible scale, and
  unfamiliar coordination—not temples, domes, or antique ornament.

### Atmosphere and light

- Use cool overcast light, blue hour, fog, rain, snow, dust, or warm low-angle
  sun to separate planes and establish operational conditions.
- Warm scenes still retain graphite structure and disciplined emissions.
- Keep the play surface evenly legible. Place dramatic contrast at the horizon,
  around a focal structure, or behind the units.
- Avoid omnipresent bloom. Reserve it for activation, impact, or the Source.

### Faction translation

- **Coal:** graphite armor, heat shields, red-orange thermal cores, loaders,
  excavators, reinforced logistics, and particulate weather. Functional heavy
  industry, not soot-covered steampunk.
- **Steam:** oxidized teal, cool steel, pressure containment, transit systems,
  pumps, turbines, and disciplined civic modules. Engineered infrastructure,
  not Victorian ornament.
- **Solar:** ceramic white, blue-black structure, precise amber charge, hard
  sun control, mirrors, and clean thermal geometry. Advanced but not angelic.
- **Wind:** pale blue, silver, light frames, stabilizers, aero surfaces, open
  routes, suspended infrastructure, and visible weather response.
- **Fusion:** graphite, violet or green containment light, compact field coils,
  shielding, warning geometry, and experimental modules. Dangerous through
  restraint and instability, not visual clutter.
- **Universal / coalition:** blue-grey shells, cool white data light, modular
  adapters, field repairs, and standardized connections.
- **Caelis:** graphite and ceramic-white monoliths, seamless apertures, precise
  cyan-violet system light, deep voids, and infrastructure operating without
  visible supervision.

## Battlefield presentation

- Preserve the unobstructed 3x7 footprint and strong lane direction.
- Use cyan for player-facing projections and coral for hostile projections.
- Threats may use thin radial arcs, segmented rings, line telegraphs, and sparse
  reticles. Valid placement uses a calmer green confirmation.
- Shields use thin geometric shells or hex-like facets only when active. Do not
  leave a permanent honeycomb texture over the scene.
- Missiles and ranged attacks need readable origins, paths, and endpoints.
- Melee attacks should close distance along a clear vector, contact, recoil,
  and restore the stable board composition.
- Combat logs and status markers confirm the simulation; they do not compete
  with the action for visual dominance.

## Camera and animation grammar

Use low three-quarter chase views, lateral tracking, controlled push-ins, and
short orbits for promotional work. In gameplay, preserve the tactical camera
and borrow the same energy through local motion, trails, recoil, screen-space
parallax, and tightly limited shake.

For every hero action, identify:

1. The acting silhouette.
2. The travel direction or firing line.
3. The contact frame.
4. The mechanical result.
5. The clean state to which the viewer returns.

Avoid continuous handheld motion, long uncontrolled spins, repeated full-screen
flashes, and camera movement that reverses the perceived lane direction.
Reduced-motion mode shortens travel, removes shake and aggressive parallax, and
retains the contact cue plus result. Animation-off mode must present the same
information without relying on motion.

## Interface and graphic design

The interface is a field instrument, not a fantasy book.

- Use graphite or translucent blue-black surfaces, thin one-pixel borders,
  square or lightly clipped corners, and generous negative space.
- Use uppercase geometric or condensed type for headings and short commands.
  Body copy and narrative text remain comfortably readable and need not be
  condensed.
- Build hierarchy with scale, spacing, alignment, and luminance before adding
  borders or glow.
- A single slash, double slash, coordinate tick, segmented meter, or diagnostic
  line can imply machinery. Do not wallpaper panels with these motifs.
- Normal navigation stays sparse. Dense telemetry belongs in Formation Command,
  mission dossiers, replay analysis, and unit-detail views where comparison is
  the point.
- Cyan means active or synchronized. Coral means enemy, invalid, or destructive.
  Amber means warning or pending consequence. White is the default emphasis.
- Buttons should change border, fill, or a small indicator on focus. Avoid large
  magical auras and ornate frames.
- The title treatment may use cut geometry, interruption, and negative space,
  but must remain an original mark and must not reproduce another game's logo.

## Narrative presentation

Modern Field Command reinforces the existing story rather than replacing it.
Its central presentation tension is **assigned purpose versus chosen purpose**.

- Governments describe Conductors and automatons as registered assets,
  infrastructure, contracts, claims, and acceptable losses.
- Characters reveal the human cost through protection, hesitation, repair,
  refusal, and the private names they give machines.
- Mission briefings use precise utilitarian language. Debriefings and interludes
  expose who benefited, who was categorized as expendable, and what precedent
  the victory created.
- Conductors are interfaces between machine will and institutional authority,
  not heroic puppeteers issuing magical commands.
- Automatons demonstrate judgment through behavior. Do not explain every act of
  agency immediately.
- Preserve political ambiguity. Choosing one's purpose does not erase material
  dependence, faction loyalty, or the consequences of breaking an order.

Do not reproduce dialogue, names, premises, or plot events from reference
media. The project-specific expression remains the Relay disaster, resonance
scars, faction claims, Cassian's institutional coalition, and the hidden
fragmentation of the Source.

## Trailer and teaser grammar

Promotional sequences should alternate quiet diagnostic images with compact
bursts of acceleration. A useful 30-second arc is:

1. **Absence:** a dead system, empty platform, or silent machine.
2. **Connection:** one signal, aperture, lens, or involuntary synchronization.
3. **Velocity:** two linked combat actions with clear cause and effect.
4. **Consequence:** an order, claim, cost, or act of machine judgment.
5. **Scale:** reveal the larger infrastructure or political system.
6. **Identity:** cut to a clean original title on black.

Intertitles are short institutional statements or thematic reversals. Composite
all exact lettering in editing rather than asking an image or video model to
render it. Do not use borrowed slogans, logo construction, shot-for-shot
recreations, or soundtrack imitation.

Sound follows the action hierarchy even though all project audio is synthesized:

- Give propulsion or system activation a rising tonal or rhythmic build.
- Place a distinct transient on contact, then briefly open space for recoil or
  consequence to register.
- Use low diagnostic ambience between action bursts instead of an uninterrupted
  wall of sound.
- Let repeated Relay pitches, machine heartbeats, and faction timbres provide
  continuity across cuts.
- Use silence deliberately before an intertitle, reveal, or title impact.
- Do not add external audio files, generated dialogue, imitation voice work, or
  recognizable music.

The production-ready 30-second implementation is documented in
`documentation/War_of_Resonance_Intro_Sizzle.md`.

## Review checklist

Before accepting a new asset, screen, animation, or promotional shot, verify:

- Does it read as modern tactical science fiction without medieval, heraldic,
  parchment, or steampunk ornament?
- Is the largest silhouette or decision legible at gameplay size?
- Is there one dominant signal color with a clear meaning?
- Does the environment communicate scale without invading gameplay space?
- Does motion have a clear actor, vector, contact, result, and recovery?
- Can the same game state be understood with reduced motion or animation off?
- Does the interface reserve dense telemetry for places where it adds value?
- Does narrative staging reveal agency or institutional pressure through action?
- Is the work original and free of copied names, assets, layouts, shots, logos,
  dialogue, and franchise-specific motifs?

## Anti-goals

- Medieval fantasy dressed with mechanical parts.
- Ornate steampunk, Victorian machinery, or antique technical illustration.
- Glossy photoreal military simulation.
- Neon cyberpunk overload or permanent holographic noise.
- Generic giant-mech spectacle that erases the autonomous human-scale cast.
- Fast animation without readable tactical cause and effect.
- Minimal UI that withholds necessary combat information.
- Reference imitation instead of a coherent War of Resonance identity.
