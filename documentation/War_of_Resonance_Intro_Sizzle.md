# War of Resonance — Intro Sizzle

This document is the production brief and generation script for the opening
cinematic. It is designed as a 48-second sequence assembled from eight
six-second MiniMax Hailuo 2.3 clips.

The modular structure keeps each generated shot focused on one visual idea,
helps preserve character and machine continuity, and supports a clean editorial
rhythm. At 1080p, Hailuo 2.3 supports six-second generations and explicit camera
commands such as `[Push in]`, `[Tracking shot]`, and `[Static shot]`.

Official reference:
[MiniMax video-generation documentation](https://platform.minimax.io/docs/api-reference/video-generation-t2v)

## Format

- Length: 48 seconds.
- Frame: cinematic 16:9.
- Output: 1080p, six seconds per generated clip.
- Editing: hard cuts driven by sound, one match cut, and a final smash to black.
- Dialogue: sparse voice-over, never lip-synchronized.
- Spoiler level: establish the Relay accident, the Conductor-machine bond,
  Cassian's political role, and Caelis as a mystery without explaining the
  Source.
- Final image: exact game title on pure black.

For best consistency, generate a 16:9 first-frame illustration for each shot,
then animate that image with Hailuo's image-to-video mode. Established character
and environment references:

- [The Conductor](../assets/Unused%20Explorations/Talking%20Heads/Conductor.png)
- [Cassian](../assets/Unused%20Explorations/Talking%20Heads/ComfyUI_00160_.png)
- [Warden Ilyra](../assets/Unused%20Explorations/Talking%20Heads/ComfyUI_00119_.png)
- [Brass Bastion-136](../assets/units/full/241.png)
- [Caelis environment](../assets/operations_maps/original_sources/act-3-caelis.png)

## Shared visual-style prompt

Paste this before every individual shot prompt:

```text
An original hand-painted industrial-fantasy tactical RPG cinematic in the War of Resonance Ink and Cell visual language. Stylized 2.5D animation with confident varied dark ink contours, broad opaque matte gouache color shapes, crisp two-or-three-value cel shading, restrained dry-brush texture, slightly imperfect painted edges, limited internal linework, strong readable silhouettes, and atmospheric multiplane depth. This is moving illustrated concept art, not photorealism and not glossy 3D CGI.

Materials are pale enamel, silver steel, antique brass, charcoal iron, ceramic insulation, and matte mechanical underlayers. Energy appears as restrained cyan light inside engineered lenses, conduits, Relay rings, and machine cores—not free-floating fantasy magic. Accent colors may include furnace ember-orange, solar gold, wind blue, and contained fusion violet.

Automatons are human-scale autonomous mechanical characters with solid enclosed panels, articulated manufactured joints, optical lenses, distinct personalities, and no pilots. Humans wear practical industrial field clothing. Natural restrained acting, stable anatomy, deliberate cinematic motion, 16:9 composition, 24fps feeling, moderate detail, consistent faces and costumes.
```

Append this negative direction to every shot:

```text
No photorealism, plastic 3D rendering, glossy anime treatment, excessive bloom, modern vehicles, firearms held by humans, medieval fantasy armor, spaceships, giant mechs, human pilots inside robots, skeletal robot bodies, tangled exposed cables, random costume changes, extra limbs, duplicated characters, malformed hands, floating machinery, illegible signage, subtitles, captions, logos, watermark, or on-screen text.
```

## Character continuity bible

### The Conductor

The Conductor is an unnamed young adult reclamation technician with short swept
black hair, black rectangular glasses, a charcoal-gray work hoodie, dark utility
trousers, and a compact tool harness. Before the accident he looks ordinary and
slightly exhausted. Afterward, narrow cyan Relay filaments glow beneath the skin
at the neck and right hand. He is an engineer, not a superhero: observant,
compassionate, frightened, and determined.

### Cassian

Cassian is a lean adult man with warm medium-brown skin, a short trimmed beard,
a gray field cap, pale gray logistics shirt, dark cross-body satchel, and a
subtle segmented interface at his neck. His movements are economical. He
watches rooms, papers, and people more than weapons. His warmth should coexist
with the sense that he is always calculating the next consequence.

### Warden Ilyra

Warden Ilyra is a composed adult woman with long steel-blue hair, charcoal
formal fieldwear, small asymmetrical multicolored beads near one ear, and
restrained pale-violet Caelian accents. She is neither sinister nor ethereal.
She carries the stillness of someone representing a civilization that
officially does not exist.

### Brass Bastion-136

Brass Bastion-136 is a massive but human-scale reclaimed Warden automaton:
weathered pale-blue and ivory enamel, antique-brass edging, broad shoulders, a
single cyan optical lens, circular cyan chest core, small turbine-like crown,
and an enormous segmented flower-turbine shield. Its personality is protective
and deliberate. It must feel old, scarred, and loyal by choice.

### Caelis

Caelis is an immaculate, nearly empty circular city of ivory stone, pale enamel,
antique-brass ribs, cyan vertical conduits, domed halls, radial bridges, deep
dark chasms, and silent infrastructure still maintaining itself. It is
beautiful but unsettling because everything works and almost no citizens
remain.

## Clip 1 — The Dead Relay

**Time:** 00:00–00:06

### Visual prompt

```text
Begin in complete black. A single narrow cyan pulse appears, as thin as an electrocardiogram, then vanishes. Reveal a vast underground reclamation chamber containing a dormant ancient Relay: concentric antique-brass rings surrounding a dark glass core, half buried in dust, broken masonry, old cables, and pale Caelian panels. Small expedition work lights illuminate only fragments of the chamber.

The Conductor, still an ordinary technician in a charcoal hoodie and black rectangular glasses, stands at a maintenance console in the lower foreground. He brushes dust away with one gloved hand and inserts a compact diagnostic tool. The enormous Relay remains apparently dead. On the final second, one distant ring rotates by a few centimeters without being touched and a faint cyan reflection crosses his glasses.

Start almost completely dark, then reveal the chamber with the expedition lamp. Preserve huge scale and quiet negative space. Dust drifts slowly through the beam. [Push in,Pedestal up]
```

### Audio and edit

- Begin with silence.
- One low synthetic heartbeat at 00:01.
- Metal groan at 00:05.
- Cassian, quietly over radio: “The Relay was dead.”
- Hard cut on the first bright cyan pulse.

## Clip 2 — It Was Waiting

**Time:** 00:06–00:12

### Visual prompt

```text
Inside the same excavation chamber, continue with the same Conductor. Extreme close-up of his black glasses reflecting several concentric cyan rings. Pull wider as the Relay activates violently behind him. Brass rings counter-rotate, dust lifts from the floor, dormant conduits illuminate in branching cyan paths, and a controlled pressure wave moves through his clothing and hair.

The energy is technological and geometric, never magical. The Conductor reaches toward the console to shut it down, but narrow cyan circuitry travels from the interface into his right glove and beneath the skin at his wrist and neck. His expression shifts from concentration to frightened recognition. In the background Cassian is knocked from a catwalk as lights fail. The Conductor turns toward him instead of staring at the Relay.

End with a sharp white-cyan overexposure that fills the frame and creates the transition to the next shot. Strong inked shadow shapes, restrained cyan glow, stable human anatomy. [Pull out,Shake]
```

### Audio and edit

- Relay tone rises through five slightly incompatible pitches.
- Conductor, almost whispering: “No. It was waiting.”
- Abrupt electrical silence at the white frame.
- Do not show an explosion or imply the Conductor controls the event.

## Clip 3 — The Machines Remember

**Time:** 00:12–00:18

### Visual prompt

```text
The white flare resolves into the circular cyan eye of Brass Bastion-136. Its weathered pale-blue faceplate lifts from centuries of stillness. Dust falls from its shoulders. Its chest core answers the Conductor's pulse in the same rhythm.

The camera tracks sideways as Brass Bastion steps between the injured Conductor, fallen Cassian, and collapsing debris. It plants its enormous segmented flower-turbine shield into the floor. Heavy stone and metal strike the shield while it holds firm. Behind the shield, two smaller reclaimed automatons activate independently: a slender lancer steadies Cassian and a compact repair machine scans the Conductor's wounds.

The Conductor and Brass Bastion look directly at one another for one still beat. This is recognition and shared purpose, not an officer giving an order. End on the Conductor placing his glowing right hand against the old shield as matching cyan resonance rings travel through both of them. [Tracking shot,Push in]
```

### Audio and edit

- Deep shield impact.
- Three machine cores answer with distinct pitched chimes.
- Cassian, shaken: “Did you tell them to do that?”
- Conductor: “No.”
- Cut on the matching pulse.

## Clip 4 — The War Answers

**Time:** 00:18–00:24

### Visual prompt

```text
A fast but visually readable battlefield shot on a broad industrial tactical deck organized into three implied lanes, with no visible game grid or UI. Continue the Ink and Cell painted style.

Brass Bastion advances in the central lane and catches a furnace-orange projectile on its turbine shield. A long-legged silver and sky-blue Zephyr lancer sprints through the left lane, slips past the shield, and strikes with a compact polearm. On the right, an ivory-and-gold Helio repair automaton opens a segmented halo and sends one precise golden repair pulse into damaged allied armor. Behind them, a charcoal and violet Flux channeler suspends two controlled coil rings and discharges a branching cyan-violet arc toward opposing machines.

Show each action as coordinated but autonomous. The robots glance toward one another and adjust formation without visible commands. Sparks and paint chips are restrained. No gore, no human soldiers, no giant explosions. Camera travels parallel to the advancing formation, then briefly slows as all four silhouettes align. [Tracking shot,Truck right,Shake]
```

### Audio and edit

- Percussion enters: struck brass, deep industrial drum, ticking Relay rhythm.
- Shield impact, lancer wind-cut, repair chime, and contained electrical crack.
- No dialogue.
- Use three fast editorial inserts from this generation if the full shot is too
  busy.

## Clip 5 — Every Victory Becomes a Claim

**Time:** 00:24–00:30

### Visual prompt

```text
Cassian stands at the edge of a crowded coalition negotiation room, wearing the same gray field cap, pale logistics shirt, dark satchel, and subtle neck interface. Long tables are covered with maps, sealed reports, colored faction tokens, and damaged machine components. Representatives remain indistinct silhouettes so Cassian is the clear subject.

Begin close on Cassian's hand sliding one battlefield report across the table. As the camera circles him, match-cut between the report, a stamped reclamation charter, a map from which Caelis has been deliberately erased, and five different faction hands reaching for the same recovered Relay component. Cassian calmly moves the component out of everyone's reach and replaces it with a written agreement.

He looks through a rain-streaked window toward the distant Conductor repairing an automaton outside. Cassian's expression holds genuine affection, concern, and calculation at once. Warm brass interior light contrasts with cold cyan rain outside. [Truck left,Push in]
```

### Audio and edit

- Battle percussion becomes the rhythm of a stamping press.
- Muffled arguments remain unintelligible.
- Cassian: “Every victory becomes a claim.”
- On “claim,” all five hands strike the table.
- Cut away before any agreement is signed.

## Clip 6 — Not Salvage

**Time:** 00:30–00:36

### Visual prompt

```text
Night in a damaged worker district after a battle. Controlled fires burn behind heavy rain; no apocalyptic destruction. The Conductor kneels beside a wounded Brass Bastion-136 beneath a temporary canvas shelter. His glasses are cracked at one corner. Cyan Relay filaments glow faintly at his neck and right hand as he repairs a split shoulder panel with ordinary tools.

Behind them, autonomous machines perform compassionate tasks without receiving orders: a broad Warden supports a failing roof, a small Mender restores power to a clinic, and a Lancer carries water rather than a weapon. Civilians move safely through the formation.

Brass Bastion slowly raises one damaged hand and holds the shelter above the exhausted Conductor so rain stops falling on him. He pauses, then gives the machine a tired, grateful smile. The moment is quiet and reciprocal. End on their two hands—human and mechanical—working on the same exposed but orderly repair assembly. [Pedestal down,Push in]
```

### Audio and edit

- Music thins to cello-like synthetic resonance and rainfall.
- Conductor: “People aren't salvage.”
- Cassian, distant voice-over: “Neither are machines.”
- Let the final mechanical click become the sound of a Caelian gate unlocking.

## Clip 7 — Caelis Remembers

**Time:** 00:36–00:42

### Visual prompt

```text
A monumental sealed Caelian gate opens inward with perfect silent precision. On the near side stand the Conductor and Brass Bastion, seen from behind as small silhouettes. Beyond the threshold waits Warden Ilyra, composed and motionless, with long steel-blue hair, charcoal formal fieldwear, asymmetrical colored beads, and subtle pale-violet Caelian details.

Ilyra turns and walks into Caelis. The camera follows through the gate and reveals only a controlled glimpse: immaculate ivory circular platforms, antique-brass ribs, thin cyan conduits, domed buildings, radial bridges crossing immense dark chasms, and ancient maintenance automatons continuing their routines. No crowd welcomes them. The city is alive, functional, and almost empty.

Far below, something enormous sends one soft cyan pulse through every conduit. The pulse matches the Conductor's heartbeat. Ilyra looks back without smiling. Wind moves her hair while the rest of the city remains unnaturally still. [Tracking shot,Pedestal up]
```

### Audio and edit

- Nearly all music drops away when the gate opens.
- A vast distant machine breath.
- Ilyra: “Caelis remembers.”
- Conductor: “What?”
- Cut before she answers.

## Clip 8 — The Source and Title

**Time:** 00:42–00:48

Generate the visual plate without lettering:

```text
Deep beneath Caelis, descend through an immense dark cylindrical chamber crossed by five distant conduit systems: furnace orange, steam-brass teal, solar gold, wind blue, and contained fusion violet. Each incomplete current travels through separate machinery, then curves toward one tiny suspended cyan point far below.

The five currents almost meet, but the frame cuts to absolute pure black one instant before contact. After the cut, only one extremely thin cyan resonance ring expands silently from the center of the black frame and fades. Leave the final four seconds perfectly centered, uncluttered, and black for a title overlay. No objects, stars, smoke, architecture, or generated lettering after the cut. [Pedestal down,Zoom in]
```

Edit the cut to black at approximately 00:44. Do not ask the video model to
render the final title. Add it afterward so the spelling is exact.

### Title construction

```text
                         WAR OF
                       RESONANCE
```

- “WAR OF” is small, widely tracked, and warm ivory.
- “RESONANCE” is much larger, in tall engraved capitals.
- Main letters are weathered ivory with a restrained antique-brass edge.
- A hairline cyan illumination travels once through the center of “RESONANCE,”
  then dies.
- Use a pure black background.
- Do not add a subtitle, publisher mark, menu prompt, particles, crest, or
  additional logo.
- Hold the fully readable title for at least three seconds.
- End on black, not a fade into gameplay.

### Audio and edit

- Five faction tones begin separately.
- At the instant they nearly converge, use total silence.
- The title appears with one deep struck-brass impact and a low cyan resonance
  tone.
- Final sound: a quiet machine heartbeat.

## Complete voice-over script

```text
CASSIAN:
The Relay was dead.

CONDUCTOR:
No. It was waiting.

CASSIAN:
Did you tell them to do that?

CONDUCTOR:
No.

CASSIAN:
Every victory becomes a claim.

CONDUCTOR:
People aren't salvage.

CASSIAN:
Neither are machines.

ILYRA:
Caelis remembers.

CONDUCTOR:
What?
```

The unanswered “What?” should be swallowed by the cut into the Source chamber.
No narrator should explain Caelis, the Source, the five factions, or why the
machines responded.

## Final consistency rules

- Keep the Conductor's glasses, hairstyle, clothing, and facial structure
  identical in every clip.
- Cyan implants appear only after the Relay accident.
- Keep Brass Bastion's shield, single lens, turbine crown, chest core, and
  weathering unchanged.
- Robots display intention through head angle, lens movement, pauses, and
  protective actions—not human mouths or exaggerated cartoon expressions.
- Never depict the Conductor controlling machines with hand gestures.
- Use hard cuts for conflict and slow camera movement for connection or
  mystery.
- Caelis must look maintained, not ruined.
- Do not reveal the Source as a conventional glowing reactor. It should remain
  an implied network whose separated currents are only about to converge.
- Generate the title plate as clean black motion footage, but composite the
  exact `WAR OF RESONANCE` lettering afterward. This avoids the most visible
  possible failure: a misspelled game title.

## Audio implementation note

The project does not use external audio assets. Treat the sound and music
directions above as composition and timing guidance for the project's
procedural audio system, or generate the visual clips without audio and score
the assembled movie in-engine.
