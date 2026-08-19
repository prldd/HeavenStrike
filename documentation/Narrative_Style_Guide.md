# War of Resonance — Narrative Style Guide

> Companion to `Resonance_War_Narrative_Foundation.md` (world rules) and
> `Resonance_War_Campaign_Narrative.md` (plot plan). This guide governs *how*
> the copy reads on screen. All campaign text is edited in
> `scripts/story_quest_catalog.gd` and `scripts/story_dialogue_catalog.gd`;
> `documentation/Campaign_Narrative_Script.md` is generated from them and is
> never edited directly.

## Surfaces

| Surface | Source | Where it appears |
|---------|--------|------------------|
| Campaign prologue | `CAMPAIGN_PROLOGUE` | First open of the operations map; replayable via WORLD BRIEF |
| Chapter cards | `CHAPTER_CARDS` | Shown once when a chapter becomes the active frontier; replayable via WORLD BRIEF |
| Briefing | `MISSION_STORIES[n].briefing` | Mission dossier + battle status line |
| Objective | `ENCOUNTER_RULES` objective text | Mission dossier |
| Debriefing | `MISSION_STORIES[n].debriefing` | Victory screen |
| Interlude | `INTERLUDES[n]` | Post-mission dialogue scene |
| Epilogue | `CAMPAIGN_EPILOGUE` | Final victory screen |

## Voice rules

The old draft read like a translation because of four habits. They are banned:

1. **Abstract nouns as actors.** "The exercise goes cleanly." "The seizure
   order freezes normal deliveries." People do things; paperwork doesn't.
   Write the person: "Cassian freezes the deliveries" is still wrong — say
   *who is harmed*: "No deliveries reach the depot after the seizure order."
2. **Omniscient synopsis.** Briefings are not plot summaries. Nobody in the
   world says "Moments later, armed crews close on your position." Briefings
   are spoken in-world, by Cassian unless he is unavailable; debriefings are
   aftermath reports, third person, but still about named people.
3. **"Previously on" scaffolding.** Do not open a briefing by re-explaining
   last mission's causal chain ("With Dax Calder's ledgers authenticating the
   contractor pay chits…"). One clause of continuity, maximum.
4. **Missing contractions.** Dialogue uses contractions by default
   ("doesn't", "shouldn't", "it's"). The only speakers who avoid them are
   Brass Bastion-136, the First Conductor, and the Caelian Wardens — for
   them, formality is a character note, not an accident.

Further rules:

- **One aphorism per scene, maximum.** "Truth is what happened. Evidence is
  what can survive a room full of interested people" works because it stands
  alone. Two epigrams in one scene means neither lands.
- **Name the opponent.** Every battle is against someone specific — a guild,
  a clan, a bureau, a house — with an incentive. Never "armed crews" or
  "attackers" without an owner. The owner is already authored in
  `MISSION_OPPONENTS`; the briefing must use it.
- **Seed, don't summon.** Enemies never arrive "moments later" for free. If
  an attack is coming, the previous debriefing or this briefing says who sent
  it and why.

## Structure rules

- **Prologue / chapter cards:** just-in-time exposition. Introduce an
  institution *before* the missions that use it (patrons before Chapter 1,
  the Order before Chapter 5, the Grand Circuit before Chapter 6, Source
  fragments before Chapter 7, Caelis before Chapter 11). Cards are 2–4 short
  paragraphs, narrator voice, concrete nouns.
- **Briefing (≤ ~55 words):** Cassian's dispatch, second person, present
  tense. The practical problem, the specific opponent, the stake. End on the
  order.
- **Debriefing (≤ ~65 words):** third person, past tense. Consequence first,
  cost second, hook to the next mission third. The hook must feed the next
  briefing's enemy, so no opponent ever appears unannounced.
- **Interlude (4–8 lines):** character voice over plot recap. The scene
  should change a relationship or reveal a motive, not restate the mission.

## Cast voices

- **Conductor (player):** plain, practical, short sentences. Notices machines
  before politics.
- **Cassian:** dry bureaucratic irony; treats paperwork as a blood sport.
  Never says thank you when a clause will do.
- **Lysa Vey:** blunt professional; allergic to flattery; counts what things
  cost.
- **Archivist Serin:** precise, scholarly; lets documents carry the emotion.
- **Asha Vale:** arena-direct; respects competence, says so sideways.
- **Dax Calder:** mercantile metaphor; every sentiment has a price tag.
- **Brass Bastion-136 / First Conductor:** clipped machine-report grammar, no
  contractions; the rare correction ("Correction. Recognition.") is the
  character.
- **The Stranger / Warden Ilyra:** formal Caelian cadence, no contractions.
- **Director Rusk (new):** affable corporate threat; condolences as
  punctuation. The face of the expedition's patrons, later implicated in the
  patron chain (M42). Introduced in the M4 interlude.
- **Evaluator Marren (new, arrives Ch. 4):** scrupulously fair career
  officer; the system's honest face. Scenes land at M17–18.
- **General Strosse (new, arrives Season 2):** doctrine-first soldier;
  the face of the Unity Day attack and the coup (M46–47), introduced in the
  M47 detention-block interlude.

## Canon clarifications (ratify before Season rewrites)

1. **Operators vs. Conductors.** Modern armies field machines commanded by
   licensed *relay operators* using manufactured control rigs — regulated,
   limited, tactical. True Conduction (the Imperial kind: will lent directly,
   machines choosing shared purpose) died with the Empire. The player is the
   first true Conductor in centuries; the licensing hall (M10) registers them
   because "operator" is the only box the bureaucracy has. This reconciles the
   registration institutions (M10, M18) with the Wardens' "first new Conductor
   in centuries" (M63).
2. **The patrons.** The expedition is bankrolled by a private consortium with
   government ties. Director Rusk is their liaison and their face. Some of
   them paid for the relay experiment without asking what it was (M42, M70).
3. **The believed history.** Every school teaches: the Empire collapsed, the
   Source went dark, Caelis was destroyed. The prologue states this belief
   plainly so the reveals (M22, M41, M62) have something to break.
