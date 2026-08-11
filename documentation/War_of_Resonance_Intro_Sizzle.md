# War of Resonance — 30-Second Intro Sizzle

This document is the production brief and generation script for the opening
cinematic. The finished sequence is exactly 30 seconds and contains no spoken
dialogue or generated speech. Short narrative lines appear as exact typography
on pure black between visual scenes.

Generate five six-second MiniMax Hailuo 2.3 clips, for a maximum of 30 seconds
of generated footage. Trim and assemble those clips with the black intertitles
and final title card according to the edit timeline below.

Official reference:
[MiniMax video-generation documentation](https://platform.minimax.io/docs/api-reference/video-generation-t2v)

## Final edit timeline

| Time | Image | Sound |
|------|-------|-------|
| 00:00–00:01.5 | Black intertitle: `THE RELAY WAS DEAD.` | One low machine heartbeat |
| 00:01.5–00:06 | Clip 1: discovery of the dormant Relay | Sub-bass machinery and diagnostic ticks |
| 00:06–00:10.5 | Clip 2: activation, injury, and machine awakening | Rising five-note Relay signal |
| 00:10.5–00:12 | Black intertitle: `THEN THE MACHINES REMEMBERED.` | Sudden silence, then one core chime |
| 00:12–00:17 | Clip 3: formation charge and shield breach | Full percussion enters |
| 00:17–00:22 | Clip 4: coordinated counterattack | Fastest musical passage |
| 00:22–00:23.5 | Black intertitle: `EVERY VICTORY CREATES A CLAIM.` | Percussion becomes a stamping press |
| 00:23.5–00:27 | Clip 5: Ilyra opens the gate to Caelis | Music collapses into a distant pulse |
| 00:27–00:30 | Black title: `WAR OF RESONANCE` | Struck brass impact and final heartbeat |

All intertitle and title typography must be composited during editing. Do not
ask the video model to generate lettering.

## Shared visual-style prompt

Paste this before every individual clip prompt:

```text
An original high-energy hand-painted industrial-fantasy tactical RPG cinematic in the War of Resonance Ink and Cell visual language. Stylized 2.5D animation with confident varied dark ink contours, broad opaque matte gouache color shapes, crisp two-or-three-value cel shading, restrained dry-brush texture, slightly imperfect painted edges, limited internal linework, strong readable silhouettes, and deep multiplane parallax. This is animated illustrated concept art, not photorealism and not glossy 3D CGI.

Materials are pale enamel, silver steel, antique brass, charcoal iron, ceramic insulation, and matte mechanical underlayers. Energy appears as restrained cyan light inside engineered lenses, conduits, Relay rings, and machine cores—not free-floating fantasy magic. Accent colors include furnace ember-orange, solar gold, wind blue, and contained fusion violet.

Automatons are human-scale autonomous mechanical characters with solid enclosed panels, articulated manufactured joints, optical lenses, distinct personalities, and no pilots. Humans wear practical industrial field clothing. Stable anatomy and designs, cinematic 16:9 framing, 24fps feeling, dramatic foreground parallax, forceful acceleration, readable impacts, and decisive camera movement.
```

Append this negative direction to every clip:

```text
No photorealism, plastic 3D rendering, glossy anime treatment, excessive bloom, modern vehicles, firearms held by humans, medieval fantasy armor, spaceships, giant mechs, human pilots inside robots, skeletal robot bodies, tangled exposed cables, random costume changes, extra limbs, duplicated characters, malformed hands, floating machinery, weightless movement, slow posing, idle combatants, turn-taking combat, stationary battle tableaux, illegible signage, subtitles, captions, logos, watermark, or on-screen text.
```

## Character continuity

### The Conductor

The Conductor is an unnamed young adult reclamation technician with short swept
black hair, black rectangular glasses, a charcoal-gray work hoodie, dark utility
trousers, and a compact tool harness. Before the accident he appears ordinary
and exhausted. Afterward, narrow cyan Relay filaments glow beneath the skin at
the neck and right hand. He remains an engineer rather than an action hero.

Reference:
[The Conductor](../assets/Unused%20Explorations/Talking%20Heads/Conductor.png)

### Cassian

Cassian is a lean adult man with warm medium-brown skin, a short trimmed beard,
a gray field cap, pale gray logistics shirt, dark cross-body satchel, and a
subtle segmented interface at his neck. His movements are economical, and his
first instinct during the Relay accident is to help the expedition personnel
around him.

Reference:
[Cassian](../assets/Unused%20Explorations/Talking%20Heads/ComfyUI_00160_.png)

### Warden Ilyra

Warden Ilyra is a composed adult woman with long steel-blue hair, charcoal
formal fieldwear, small asymmetrical multicolored beads near one ear, and
restrained pale-violet Caelian accents. She is neither sinister nor ethereal.
She moves with the still certainty of someone representing a civilization that
officially does not exist.

Reference:
[Warden Ilyra](../assets/Unused%20Explorations/Talking%20Heads/ComfyUI_00119_.png)

### Brass Bastion-136

Brass Bastion-136 is a massive but human-scale Warden automaton with weathered
pale-blue and ivory enamel, antique-brass edging, broad shoulders, one cyan
optical lens, a circular cyan chest core, a small turbine-like crown, and an
enormous segmented flower-turbine shield. It moves with enormous weight but can
accelerate explosively over a few steps. Its first instinct is protection.

Reference:
[Brass Bastion-136](../assets/units/full/241.png)

### Caelis

Caelis is an immaculate, nearly empty circular city of ivory stone, pale enamel,
antique-brass ribs, cyan vertical conduits, domed halls, radial bridges, deep
dark chasms, and silent infrastructure still maintaining itself. It is
beautiful and unsettling because everything works and almost no citizens
remain.

Reference:
[Caelis environment](../assets/operations_maps/original_sources/act-3-caelis.png)

## Intertitle 1 — The Relay Was Dead

**Final time:** 00:00–00:01.5

Use a pure black frame. Center the following line in warm ivory capitals:

```text
THE RELAY WAS DEAD.
```

Use widely tracked, restrained lettering. A hairline cyan pulse briefly passes
through the period. There are no particles, border, ornament, or background
image. Cut sharply into Clip 1.

## Clip 1 — The Dead Relay

**Generated length:** 6 seconds

**Final edit usage:** approximately 4.5 seconds

### Visual prompt

```text
Begin inside a vast underground reclamation chamber. A dormant ancient Relay dominates the darkness: concentric antique-brass rings around a black glass core, half buried beneath dust, broken pale Caelian masonry, and severed conduits. Small expedition lamps swing through the foreground and create rapid parallax as the camera races low along a maintenance track toward the structure.

The Conductor, still an ordinary technician in a charcoal hoodie and black rectangular glasses, slides on one knee beneath a hanging cable, catches himself at the maintenance console, wipes dust from its surface, and drives a compact diagnostic key into the socket. Cassian arrives behind him carrying a field case and turns to wave other workers away from unstable scaffolding.

The camera whips around the Conductor as the first Relay ring rotates by itself. Dust jumps from the floor in a perfect circle. A thin cyan reflection races across his glasses. End in an extreme close-up of that reflection as the black core opens like a mechanical aperture. Fast entry, abrupt stop, strong scale, heavy machinery, urgent but controlled movement. [Tracking shot,Truck right,Push in]
```

### Sound design

- Low sub-bass machinery.
- Quick diagnostic ticks follow the camera movement.
- The final aperture movement produces a dry brass snap.
- No voice, breathy narration, or audible words.

## Clip 2 — The Accident

**Generated length:** 6 seconds

**Final edit usage:** approximately 4.5 seconds

### Visual prompt

```text
Continue in the same chamber with the same Conductor and Cassian. Start on the Relay aperture opening. Concentric brass rings counter-rotate at escalating speed as cyan conduits ignite outward through the floor. The camera orbits rapidly around the Conductor while a geometric pressure wave tears dust and loose paper through the room.

A catwalk support snaps. Cassian is thrown toward the edge while the Conductor lunges and catches his wrist with both hands. Cyan circuitry travels from the live console through the Conductor's glove and beneath the skin at his right wrist and neck. His body locks in pain, but he refuses to release Cassian.

Behind them, Brass Bastion-136 erupts from the dust. Its cyan eye opens, it takes three thunderous accelerating steps, drives its enormous turbine shield beneath the falling catwalk, and throws the wreckage sideways away from both humans. Two smaller machines wake and rush into the collapsing chamber without being ordered. End as Brass Bastion's cyan chest core and the Conductor's new Relay filaments pulse in perfect synchronization. Violent environmental motion, heavy impacts, stable faces, no magical levitation. [Truck left,Shake,Push in]
```

### Sound design

- Five incompatible Relay pitches rise into a single chord.
- Metal failure travels left to right across the stereo field.
- Brass Bastion lands with a deep impact followed by a clean cyan core chime.
- Cut into total silence for the second intertitle.

## Intertitle 2 — The Machines Remembered

**Final time:** 00:10.5–00:12

Use pure black. Center the following line in warm ivory capitals:

```text
THEN THE MACHINES REMEMBERED.
```

On the final word, place a faint cyan reflection behind the letters, as though a
machine eye opened beyond the black. Keep the background otherwise empty. Cut
on the first battle-drum strike.

## Clip 3 — Formation Breach

**Generated length:** 6 seconds

**Final edit usage:** approximately 5 seconds

This clip must feel like an attack already in progress. No opposing rows waiting
for their turns and no heroic lineup pose.

### Visual prompt

```text
A kinetic battle on a broad industrial tactical deck organized into three implied lanes, with no visible grid or UI. Begin at ankle height moving backward at high speed as four allied automatons sprint directly toward the camera while enemy fire tears across the deck behind and beside them. Every machine is already moving.

Brass Bastion-136 charges in the center lane, shield lowered like a moving wall. A furnace-orange artillery shell screams past the lens. Brass Bastion pivots its whole weight, catches the shell on the angled turbine shield, and redirects the explosion sideways into an empty railing. The blast kicks debris and painted speed lines across the frame without stopping the advance.

Using the tilted shield as a ramp, a long-legged silver and sky-blue Zephyr lancer accelerates from behind, runs three steps up the shield, vaults over Brass Bastion, rotates its polearm in midair, and lands in a sliding strike that sweeps an enemy machine out of the lane. The camera whip-pans with the lancer, passes inches above the deck, then finishes facing the rest of the formation surging through the breach. Aggressive forward momentum, heavy footfalls, rapid parallax, readable cause-and-effect choreography. [Tracking shot,Truck left,Shake]
```

### Sound design

- Fast struck-brass percussion and deep industrial drums.
- Doppler whistle as the projectile passes the camera.
- Shield impact briefly ducks the music.
- Lancer landing adds a cutting wind sound and hard metallic skid.

## Clip 4 — Resonance Counterattack

**Generated length:** 6 seconds

**Final edit usage:** approximately 5 seconds

The action must build continuously from defense to repair to retaliation. Do
not present separate characters posing for isolated ability demonstrations.

### Visual prompt

```text
Continue the same battle from inside the breached formation. The camera races sideways between moving automatons while enemy machines attack from foreground and background at the same time. A damaged allied Strider is struck, tumbles across the deck, plants one polearm, and converts the fall into a spinning recovery without stopping.

An ivory-and-gold Helio Mender skates into the moving formation, unfolds a segmented repair halo while running, and fires one precise golden repair pulse into the Strider. Armor seams close as the Strider launches forward again. An enemy blade dives toward the Mender, but Brass Bastion enters from outside frame at full speed and shoulder-checks it away with the edge of the turbine shield.

That shield impact reveals a charcoal-and-violet Flux channeler directly behind it. The channeler snaps two coil rings into alignment. The camera performs a rapid half-orbit as a controlled cyan-violet arc travels through three enemy machines, throwing them backward in sequence. At the same instant the recovered Strider races along the arc's path and drives the final opponent out of frame. Finish with the allied formation continuing forward rather than stopping to pose. Fast camera, speed ramp into impacts, layered foreground action, clear silhouettes, coordinated autonomous decisions. [Pan right,Tracking shot,Shake]
```

### Sound design

- Music reaches its fastest tempo.
- Repair tone becomes part of the percussion rather than pausing the action.
- Each chained arc impact steps upward in pitch.
- Final strike cuts immediately to the third black intertitle.

## Intertitle 3 — Every Victory Creates a Claim

**Final time:** 00:22–00:23.5

Use pure black. Center the following line in warm ivory capitals:

```text
EVERY VICTORY CREATES A CLAIM.
```

As the words appear, briefly reveal five extremely faint faction-colored lines
approaching the sentence from different directions. They stop before touching
it. Accompany the card with a single legal-stamp impact, not a voice.

## Clip 5 — The Gate of Caelis

**Generated length:** 6 seconds

**Final edit usage:** approximately 3.5 seconds

### Visual prompt

```text
A monumental sealed Caelian gate fills the frame. Begin close behind the Conductor and Brass Bastion-136 as they approach through wind and drifting white dust. Their movement remains urgent from the preceding battle, but both slow when the enormous mechanism unlocks without being touched.

The gate opens inward with perfect silent precision. Warden Ilyra waits beyond it, composed and motionless, with long steel-blue hair, charcoal formal fieldwear, asymmetrical colored beads, and subtle pale-violet Caelian details. She turns immediately and walks away, expecting them to follow.

The camera rushes through the widening gate and rises behind her to reveal only one breathtaking glimpse of Caelis: immaculate ivory circular platforms, antique-brass ribs, domed halls, radial bridges over immense dark chasms, thin cyan conduits, and ancient maintenance automatons still performing their routines. The city is alive, functioning, and almost empty. Far below, one enormous cyan pulse flashes through every bridge and tower. Cut to black at the brightest instant before explaining its source. [Tracking shot,Pedestal up,Push in]
```

### Sound design

- Battle music collapses into wind and a distant mechanical breath.
- The gate unlocks with five quiet tones resolving into one.
- The city-wide pulse produces a deep sound felt more than heard.
- No dialogue from Ilyra or the Conductor.

## Final title card

**Final time:** 00:27–00:30

Cut from the Caelis pulse to absolute pure black. Add the title in editing:

```text
                         WAR OF
                       RESONANCE
```

- “WAR OF” is small, widely tracked, and warm ivory.
- “RESONANCE” is much larger, in tall engraved capitals.
- Main letters are weathered ivory with a restrained antique-brass edge.
- A hairline cyan illumination travels once through the center of “RESONANCE,”
  then dies.
- Do not add a subtitle, publisher mark, menu prompt, particles, crest, or
  additional logo.
- Hold the fully readable title through the final frame.
- End on black rather than transitioning directly into gameplay.

The title appears with one deep struck-brass impact and a low resonance tone.
The final sound is one quiet machine heartbeat.

## Energy and choreography rules

- Battle movement must begin before the camera arrives and continue after the
  camera leaves. No one waits to take a turn.
- Give every action visible preparation, acceleration, contact, recoil, and
  recovery.
- Keep the camera close enough that projectiles and moving limbs cross the
  foreground, creating speed and danger.
- Use lateral tracking for velocity, low angles for weight, whip-pans to connect
  dependent actions, and short speed ramps into major impacts.
- Each action must cause the next action. Brass Bastion's shield creates the
  Lancer's ramp; the repair pulse returns the Strider to combat; the shield
  counter exposes the Channeler's firing line.
- Maintain readable silhouettes. Energy and debris must support the motion,
  never conceal it.
- Keep explosions brief and directional. Avoid spherical fireballs that fill
  the frame.
- Robots fight as autonomous individuals sharing purpose. The Conductor never
  gestures like a puppeteer and is not shown issuing battlefield orders.

## Final consistency rules

- Keep the Conductor's glasses, hairstyle, clothing, and facial structure
  identical in every clip.
- Cyan implants appear only after the Relay accident.
- Keep Brass Bastion's shield, single lens, turbine crown, chest core, and
  weathering unchanged.
- Robots communicate intention through head angle, lens movement, timing, and
  protective actions—not human mouths or exaggerated cartoon expressions.
- Caelis must look maintained rather than ruined.
- Do not reveal the Source as a conventional glowing reactor. The city-wide
  pulse is the only hint.
- Composite every intertitle and the final `WAR OF RESONANCE` lettering during
  editing so all text is spelled and timed exactly.

## Audio implementation note

The project does not use external audio assets. Treat the sound and music
directions as timing guidance for the project's procedural audio system. The
generated visual clips should be silent; no TTS, character voices, narration,
or generated dialogue is required.
