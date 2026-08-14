# War of Resonance — 30-Second Intro Sizzle

This document is the production brief and generation script for the opening
cinematic. The finished sequence is exactly 30 seconds and contains no spoken
dialogue or generated speech. Short narrative lines appear as exact typography
on pure black between visual scenes.

This implementation follows
[`Modern_Field_Command_Visual_Direction.md`](Modern_Field_Command_Visual_Direction.md).
Its pacing was refined after reviewing the public Code RAPID announcement
teaser, gameplay trailer, story trailer, and Steam screenshots for broad
lessons in silhouette, scale, velocity, restrained signal color, and the
contrast between quiet narrative frames and action bursts. Do not copy any
reference character, machine, logo, interface, line, environment, music, or
shot composition.

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
| 00:12–00:17 | Clip 3: formation boost and shield breach | Full synthetic percussion enters |
| 00:17–00:22 | Clip 4: coordinated counterattack and autonomous choice | Fastest musical passage |
| 00:22–00:23.5 | Black intertitle: `EVERY VICTORY CREATES A CLAIM.` | Percussion becomes a stamping press |
| 00:23.5–00:27 | Clip 5: Ilyra opens the gate to Caelis | Music collapses into a distant pulse |
| 00:27–00:30 | Black title: `WAR OF RESONANCE` | Deep synthesized impact and final heartbeat |

All intertitle and title typography must be composited during editing. Do not
ask the video model to generate lettering.

## Shared visual-style prompt

Paste this before every individual clip prompt:

```text
An original high-energy modern tactical science-fiction cinematic in the War of Resonance Modern Field Command direction, rendered with Ink and Cell clarity. Stylized 2.5D animation with confident dark contours, broad opaque matte color shapes, crisp two-or-three-value cel shading, restrained painted texture, limited internal linework, strong readable silhouettes, and deep multiplane parallax. Contemporary anime-inspired hard-surface design, animated illustrated key art rather than photorealism or glossy 3D CGI.

Materials are graphite composite, blue-black mechanical understructure, ceramic-white and desaturated enamel armor, cool steel, dark optical glass, and limited weathered contact surfaces. Energy is sparse functional signal light inside engineered lenses, conduits, apertures, and machine cores: cyan for synchronization, coral red for hostile threats, amber-orange for warnings and impact heat, green for repair, and rare restrained violet for anomalous systems. Most shots use one dominant signal color.

Automatons are human-scale autonomous mechanical characters with two or three large silhouette masses, solid enclosed armor shells, clean manufactured joints, compact optics, modular role equipment, distinct personalities, and no pilots. Humans wear compact contemporary field layers and practical technical harnesses. Monumental modular infrastructure, severe vertical scale, atmospheric rain or dust, cinematic 16:9 framing, 24fps feeling, low chase angles, strong lateral motion, dramatic foreground parallax, forceful acceleration, readable contact frames, brief impact holds, and decisive recovery.
```

Append this negative direction to every clip:

```text
No photorealism, plastic 3D rendering, excessive bloom, neon overload, medieval fantasy armor, cloaks, heraldry, gothic arches, castles, parchment, ornamental brass, exposed Victorian boilers, decorative gears, spaceships, giant mechs, human pilots inside robots, skeletal robot bodies, tangled exposed cables, generic military greeble, random costume changes, extra limbs, duplicated characters, malformed hands, floating machinery, weightless movement, slow posing, idle combatants, turn-taking combat, stationary battle tableaux, illegible signage, subtitles, captions, logos, watermark, or on-screen text.
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
ceramic-white and pale-blue armor shells over a graphite understructure, broad
shoulders, one cyan optical lens, a compact circular chest aperture, a low
sensor crown, and an enormous segmented turbine shield with dark mechanical
joints. It moves with enormous weight but can accelerate explosively over a few
steps. Its first instinct is protection. Its historical name is not a material
instruction.

Reference:
[Brass Bastion-136](../assets/units/full/241.png)

### Caelis

Caelis is an immaculate, nearly empty quantum arcology of graphite monoliths,
ceramic-white structural rings, deep black apertures, precise cyan-violet
conduits, suspended service routes, immense vertical wells, and silent
infrastructure still maintaining itself. It is beautiful and unsettling
because everything works and almost no citizens remain. It is more integrated
than modern construction, never more classical.

Reference:
[Caelis environment](../assets/operations_maps/original_sources/act-3-caelis.png)

## Intertitle 1 — The Relay Was Dead

**Final time:** 00:00–00:01.5

Use a pure black frame. Center the following line in cool-white capitals:

```text
THE RELAY WAS DEAD.
```

Use widely tracked geometric lettering. A hairline cyan diagnostic pulse
briefly passes through the period. There are no particles, border, ornament, or
background image. Cut sharply into Clip 1.

## Clip 1 — The Dead Relay

**Generated length:** 6 seconds

**Final edit usage:** approximately 4.5 seconds

### Visual prompt

```text
Begin inside a vast underground reclamation well cut through a collapsed megastructure. A dormant ancient Relay dominates the darkness: concentric ceramic-white structural segments around a deep black aperture, embedded in graphite slabs, broken service bridges, and severed cyan conduits. Small expedition beacons swing through the foreground and create rapid parallax as the camera races low along a wet maintenance track toward the structure. Make the people tiny against the Relay.

The Conductor, still an ordinary technician in a charcoal field layer and black rectangular glasses, slides on one knee beneath a fallen service arm, catches himself at a flush diagnostic console, wipes rain grit from its surface, and drives a compact diagnostic key into the socket. Cassian arrives behind him carrying a field case and turns to wave other workers away from unstable scaffolding.

The camera whips around the Conductor as the first structural segment rotates by itself. Water and dust jump from the deck in a perfect circle. A thin cyan reflection races across his glasses. End in an extreme close-up of that reflection as the black core opens like a mechanical aperture. Fast entry, abrupt stop, strong scale, one dominant cyan signal, urgent but controlled movement. [Low tracking shot,Truck right,Push in]
```

### Sound design

- Low sub-bass machinery.
- Quick diagnostic ticks follow the camera movement.
- The final aperture movement produces a dry composite latch.
- No voice, breathy narration, or audible words.

## Clip 2 — The Accident

**Generated length:** 6 seconds

**Final edit usage:** approximately 4.5 seconds

### Visual prompt

```text
Continue in the same reclamation well with the same Conductor and Cassian. Start on the Relay aperture opening. Interlocked graphite and ceramic segments counter-rotate at escalating speed as thin cyan conduits ignite outward through the floor. The camera performs one rapid controlled orbit around the Conductor while a geometric pressure wave tears rain, dust, and loose diagnostic film through the room.

A catwalk support snaps. Cassian is thrown toward the edge while the Conductor lunges and catches his wrist with both hands. Cyan circuitry travels from the live console through the Conductor's glove and beneath the skin at his right wrist and neck. His body locks in pain, but he refuses to release Cassian.

Behind them, Brass Bastion-136 wakes in the dark. Its cyan eye contracts to a hard point, it takes three thunderous accelerating steps, drives its enormous segmented shield beneath the falling catwalk, and throws the wreckage sideways away from both humans. Two smaller machines wake and choose different rescue routes without being ordered. End on one quiet half-second frame as Brass Bastion's cyan chest aperture and the Conductor's new Relay filaments pulse in perfect synchronization. Violent directional debris, heavy contact, stable faces, no magical levitation. [Truck left,Brief shake,Push in]
```

### Sound design

- Five incompatible Relay pitches rise into a single chord.
- Metal failure travels left to right across the stereo field.
- Brass Bastion lands with a deep impact followed by a clean cyan core chime.
- Cut into total silence for the second intertitle.

## Intertitle 2 — The Machines Remembered

**Final time:** 00:10.5–00:12

Use pure black. Center the following line in cool-white capitals:

```text
THEN THE MACHINES REMEMBERED.
```

On the final word, place a faint cyan reflection behind the letters, as though a
machine eye opened beyond the black. Keep the background otherwise empty. Cut
on the first battle-drum strike.

## Clip 3 — Formation Boost

**Generated length:** 6 seconds

**Final edit usage:** approximately 5 seconds

This clip must feel like an attack already in progress. No opposing rows waiting
for their turns and no heroic lineup pose.

### Visual prompt

```text
A kinetic battle on a rain-dark command-carrier deck organized into three implied lanes, with no visible grid or UI. Monumental radar walls, suspended routes, and distant carriers establish scale beyond the clear combat surface. Begin at ankle height moving backward at high speed as four allied automatons boost directly toward the camera while thin coral enemy targeting arcs sweep across the deck behind and beside them. Every machine is already moving, and the cyan allied signals remain visually separate from the coral threats.

Brass Bastion-136 charges in the center lane, shield lowered like a moving wall. A compact amber-orange artillery shell with one clean trail screams past the lens. Brass Bastion pivots its whole weight, catches the shell on the angled turbine shield, and redirects the explosion sideways into an empty blast barrier. Hold the contact for two frames, then let the blast kick spray, debris, and one long motion streak across the frame without stopping the advance.

Using the tilted shield as a ramp, a long-legged silver and pale-blue Zephyr lancer accelerates from behind, runs three steps up the shield, vaults over Brass Bastion, aligns its compact lance arm along one clear diagonal, and lands in a sliding strike that sweeps an enemy machine out of the lane. The camera whip-pans with the lancer, passes inches above the wet deck, then finishes facing the rest of the formation surging through the breach. One dominant motion vector per action, heavy footfalls, rapid parallax, readable cause-and-effect choreography. [Low tracking shot,Truck left,Brief shake]
```

### Sound design

- Fast synthetic percussion and deep industrial drums.
- Doppler whistle as the projectile passes the camera.
- Shield impact briefly ducks the music.
- Lancer landing adds a cutting wind sound and hard metallic skid.

## Clip 4 — Resonance Counterattack

**Generated length:** 6 seconds

**Final edit usage:** approximately 5 seconds

The action must build continuously from defense to repair to retaliation, then
end on a small autonomous choice. Do not present separate characters posing for
isolated ability demonstrations.

### Visual prompt

```text
Continue the same battle from inside the breached formation. The camera races sideways between moving automatons while enemy machines attack from foreground and background. Keep one readable attack line at a time. A damaged allied Strider is struck, tumbles across the deck, plants one stabilizer, and converts the fall into a sliding recovery without stopping.

A ceramic-white and blue-black Helio Mender skates into the moving formation, unfolds a compact segmented repair halo while running, and fires one precise green repair pulse into the Strider. Armor seams close as the Strider launches forward again. An enemy blade dives toward the Mender, marked by a thin coral arc, but Brass Bastion enters from outside frame at full speed and shoulder-checks it away with the edge of the turbine shield.

That shield impact reveals a graphite-and-violet Flux channeler directly behind it. The channeler snaps two restrained field coils into alignment. The camera performs a rapid half-orbit as one controlled cyan-violet arc travels through three enemy machines, throwing them backward in sequence. At the same instant the recovered Strider races along the arc's path and drives the final opponent out of frame. Instead of following the advance, the Mender breaks formation for half a second to shield a disabled neutral machine at the deck edge. Brass Bastion notices, turns its lens, and covers that choice without receiving an order. Finish on their shared cyan pulse, then cut before they pose. Fast camera, clean impact pauses, clear silhouettes, coordinated autonomous judgment. [Pan right,Tracking shot,Brief shake]
```

### Sound design

- Music reaches its fastest tempo.
- Repair tone becomes part of the percussion rather than pausing the action.
- Each chained arc impact steps upward in pitch.
- Final strike cuts immediately to the third black intertitle.

## Intertitle 3 — Every Victory Creates a Claim

**Final time:** 00:22–00:23.5

Use pure black. Center the following line in cool-white capitals:

```text
EVERY VICTORY CREATES A CLAIM.
```

As the words appear, briefly reveal five extremely faint faction-colored
registration lines approaching the sentence from different directions. They
stop before touching it. Accompany the card with a single dry authorization
stamp, not a voice.

## Clip 5 — The Gate of Caelis

**Generated length:** 6 seconds

**Final edit usage:** approximately 3.5 seconds

### Visual prompt

```text
A monumental sealed Caelian aperture fills the frame, a seamless ceramic-white break in a graphite mountain arcology. Begin close behind the Conductor and Brass Bastion-136 as they approach through wind and drifting white dust. Their movement remains urgent from the preceding battle, but both slow when the enormous mechanism unlocks without being touched.

The gate opens inward with perfect silent precision. Warden Ilyra waits beyond it, composed and motionless, with long steel-blue hair, charcoal formal fieldwear, asymmetrical colored beads, and subtle pale-violet Caelian details. She turns immediately and walks away, expecting them to follow.

The camera rushes through the widening aperture and rises behind her to reveal only one breathtaking glimpse of Caelis: immense graphite monoliths, ceramic-white structural rings, suspended service routes over bottomless mechanical wells, precise cyan-violet conduits, and ancient maintenance automatons still performing their routines. No domes, temples, classical ribs, decorative metal, or civic ornament. The city is alive, functioning, and almost empty. Far below, one enormous cyan pulse flashes through every route and tower. Cut to black at the brightest instant before explaining its source. [Tracking shot,Pedestal up,Push in]
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

- “WAR OF” is small, widely tracked, and cool white.
- “RESONANCE” is much larger, in tall geometric capitals with original cut
  interruptions and deliberate negative space.
- Main letters are cool white with a restrained graphite edge.
- A hairline cyan illumination travels once through the center of “RESONANCE,”
  then dies.
- Do not add a subtitle, publisher mark, menu prompt, particles, crest, or
  additional logo.
- Hold the fully readable title through the final frame.
- End on black rather than transitioning directly into gameplay.

The title appears with one deep synthesized impact and a low resonance tone.
The final sound is one quiet machine heartbeat.

## Energy and choreography rules

- Alternate low-motion diagnostic frames with compressed combat bursts. The
  quiet material gives acceleration and impact somewhere to land.
- Battle movement must begin before the camera arrives and continue after the
  camera leaves. No one waits to take a turn.
- Give every action visible preparation, acceleration, contact, recoil, and
  recovery.
- Assign one dominant motion vector and one focal event to each beat. Secondary
  action supports that event instead of competing with it.
- Keep the camera close enough that projectiles and moving limbs cross the
  foreground, creating speed and danger.
- Use lateral tracking for velocity, low angles for weight, whip-pans to connect
  dependent actions, and short speed ramps into major impacts.
- Each action must cause the next action. Brass Bastion's shield creates the
  Lancer's ramp; the repair pulse returns the Strider to combat; the shield
  counter exposes the Channeler's firing line.
- Maintain readable silhouettes. Energy and debris must support the motion,
  never conceal it.
- Cyan synchronization, coral threat arcs, green repair, amber impact heat, and
  rare violet anomaly light keep the same meaning in every clip.
- Trails start at a readable source and terminate at a readable target. Use
  displaced rain, dust, and deck spray to reinforce travel rather than filling
  the frame with arbitrary particles.
- Keep explosions brief and directional. Avoid spherical fireballs that fill
  the frame.
- Robots fight as autonomous individuals sharing purpose. The Conductor never
  gestures like a puppeteer and is not shown issuing battlefield orders.

## Final consistency rules

- Keep the Conductor's glasses, hairstyle, clothing, and facial structure
  identical in every clip.
- Cyan implants appear only after the Relay accident.
- Keep Brass Bastion's shield, single lens, sensor crown, chest aperture, and
  weathering unchanged.
- Robots communicate intention through head angle, lens movement, timing, and
  protective actions—not human mouths or exaggerated cartoon expressions.
- Caelis must look maintained rather than ruined.
- Caelis must remain modern and integrated: graphite monoliths, ceramic shells,
  precise apertures, and severe voids rather than temples, domes, arches, or
  antique civic ornament.
- Do not reveal the Source as a conventional glowing reactor. The city-wide
  pulse is the only hint.
- Composite every intertitle and the final `WAR OF RESONANCE` lettering during
  editing so all text is spelled and timed exactly.

## Audio implementation note

The project does not use external audio assets. Treat the sound and music
directions as timing guidance for the project's procedural audio system. The
generated visual clips should be silent; no TTS, character voices, narration,
or generated dialogue is required. Use propulsion or system rise before
movement, one distinct transient at contact, and a brief opening in the mix
after major impacts. Low diagnostic ambience and deliberate silence should
separate action bursts; do not maintain an uninterrupted wall of sound.
