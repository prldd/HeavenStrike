# Resonance War — Campaign Narrative Plan

> Companion to `Resonance_War_Narrative_Foundation.md`. This document maps the
> complete 77-mission campaign onto the foundation's story beats and groups
> missions into individually compelling seasons and chapters. It is the
> narrative plan mirrored by the authored catalog copy.

# Season Structure

The foundation defines three acts. We ship them as three seasons, each a
complete dramatic arc with its own question, escalation, and cliffhanger:

| Season | Title | Missions | Source | Season question |
|--------|-------|----------|--------|-----------------|
| One | Reclamation | 1–22 | authored | What happened to me — and was it an accident? |
| Two | The Crisis | 23–62 | authored | Who gets to own the future the player is rebuilding? |
| Three | Caelis | 63–77 | implemented | Should the Empire's heirs resume control — or share it? |

Each season is a playable stopping point: a player who stops at the end of
Season One has a finished origin story; Season Two ends the political war;
Season Three resolves the historical one. Future expansions hang off the
threads each season deliberately leaves loose.

The seasons map onto the code as follows: Season One = `act: 1`, Season Two =
`act: 2`, and Season Three = `act: 3`. Mission numbers are stable persistence
keys and must not move.

# Recurring Cast

The foundation names only the player and Cassian. The campaign needs a small
supporting cast whose appearances are implemented in the dialogue catalog.

- **The Player** — reclamation technician turned Conductor. Never named
  on-screen; referred to by role ("the technician", later "the Conductor").
- **Cassian** — logistics adjutant → fixer → coalition architect. His arc is
  the spine of the whole campaign.
- **Lysa Vey** (anchored to M5 "Independent Witness", M30 "Paper Trail") — a
  freelance salvage-rights assessor sent to write the incident report, who
  becomes the player's first outside ally and field scout. Gives the player
  someone to talk to who is neither Cassian nor a machine.
- **The Stranger** (anchored to M7 "Dead-Channel Warning", M42 "Patron's Reach") —
  a quiet figure who knows far too much about Caelian installations. Revealed
  at the end of Season Two as a warden of Caelis.
- **The Archivist** (anchored to M41 "Contested Records") — an Order scholar met at
  Sanctuary who decodes Caelian records across Seasons Two and Three.
- **Director Rusk** (anchored to M4 "Sealed Ignition", M42 "Patron's Reach") —
  the expedition patrons' liaison: affable, corporate, signs everything. The
  face of "the patrons" from Season One; later shown to have paid for the
  relay experiment without asking what it was.
- **Evaluator Marren** (anchored to M17–18) — a career Conductor Registry
  evaluation officer, scrupulously fair; the system's honest face, and the one
  who first puts the medical cost of conducting on the record.
- **General Strosse** (anchored to M46–47) — the hardliner wing's field
  commander and its doctrinaire voice; captured in the coup, unrepentant, and
  not a fool.
- **The machines** — the player's first reclaimed automatons recur as named
  individuals in briefing text (their unit names), accumulating the resonance
  scars and personality the foundation calls for.

Faction flavor: the five civilizations (Coal, Steam, Solar, Wind, Fusion)
never appear as monoliths. Every faction fight is against *someone specific*
— a guild, a militia, a hardliner wing, a deniable contractor. Existing unit
families already suggest these sub-groups (guild engineers, local defense
forces, scholarly orders, scavenger clans, undertakers' guilds, royalist
remnants); briefings should use that texture rather than naming factions as
villains.

# Season One — Reclamation (Missions 1–22)

A salvage dig, an impossible survival, and the slow realization that the
"accident" was arranged. Tone: small, practical, personal. The player fixes
things; Cassian learns what the player is worth.

## Chapter 1 — The Salvage (M1–4)

- **M1 First Synchrony** — A joint reclamation expedition works a dormant
  Caelian relay site. The player runs field diagnostics with the first two
  recovered automatons. Teaches deployment and attacks.
- **M2 Formation Trial** — More reclaimed machines come online; Cassian is
  introduced counting crates and favors. Teaches Conductor skills.
- **M3 The Second Pulse** — The relay synchronizes unexpectedly during a
  power-up test. Security routines wake mid-accident; the player fights out
  of the collapsing gallery. Unbeknownst to everyone, they are now
  conducting.
- **M4 Sealed Ignition** — Escape through the burning site. The player drags
  Cassian out; the machines shield them without being ordered to. The
  official story will be "an industrial accident."

## Chapter 2 — The Aftermath (M5–9)

- **M5 Independent Witness** — Lysa Vey arrives to assess salvage rights and write the
  incident report. Looters hit the site; the player conducts openly for the
  first time, and Lysa writes down what she saw.
- **M6 Public Demonstration** — The expedition's patrons stage a publicity event to
  bury the incident. The player provides a "demonstration of perfectly safe
  reclaimed machinery" that goes wrong. First taste of being displayed.
- **M7 Dead-Channel Warning** — A stranger tells the player the relay activation was
  no accident, then disappears before the questions start. The season's
  engine starts here.
- **M8 Salvage Claim** — Scavenger crews contest the expedition's salvage
  claim. Lawfully murky: everyone has paperwork, nobody has permission.
- **M9 Passage Rights** — Raiders hit the convoy moving the reclaimed tech.
  Cassian negotiates passage rights afterward — his first visible win.

## Chapter 3 — Claims (M10–14)

- **M10 Licensed Resistance** — Governments require Conductor registration. The
  "certification exam" is a faction evaluation in disguise; everyone scores
  the player except the player.
- **M11 Depot Under Seal** — The expedition depot is attacked during the
  investigation. Winning the defense is used as evidence that the player is
  a strategic threat. Victory, politically spent by others.
- **M12 The Unmarked Route** — A second ambush, too professional to be raiders. The
  player finds contractor gear; Cassian begins controlling who knows that.
- **M13 Terms Refused** — Three faction envoys, three offers, one refusal.
  The answer comes back as a "safety inspection" with teeth. The older
  automatons begin showing distinct habits.
- **M14 Safehouse Extraction** — Lysa returns with a dangerous plan to prove the
  ambush was staged, using a bought informant. It works and proves nothing
  admissible — her first lesson in the difference between truth and leverage.

## Chapter 4 — The Proving (M15–20)

- **M15 Failing Span** — A Caelian transit bridge fails under load. The player
  holds the crossing while civilians evacuate. The first pure repair/rescue
  mission, and the player's first genuine hero moment.
- **M16 Public Challenge** — A faction champion challenges the "salvage
  Conductor" publicly. Winning humiliates a proud house and makes an enemy;
  Cassian turns the headline into a bargaining chip anyway.
- **M17 The Cost of Victory** — Hearings over the bridge and the duel. Competing
  narratives fight in the streets; the player's testimony is edited before
  it is heard.
- **M18 Field Certification** — A formal evaluation of Conductor limits, run by
  a scrupulously fair officer. The cost of conducting (strain, collapse,
  medical tents) is shown for the first time.
- **M19 Feral Signal** — Conductor-less automatons running on resonance scars
  threaten a township. The player chooses protecting people over recovering
  priceless machines — and one of the ferals chooses to follow them home.
- **M20 Charter Ground** — The displaced township camps by the depot. Defending
  the refugee camp cements the player's folk-hero standing. Cassian starts
  writing his coalition charter on the back of it.

## Chapter 5 — Sanctuary (M21–22)

- **M21 Sanctuary Threshold** — Following the Stranger's coordinates, the
  expedition reaches a pre-collapse sanctuary installation. Order archivists
  are already cataloguing it; access is won, not granted.
- **M22 Archive Breach** — Inside the archive: maintenance logs dated
  *after* the Empire's supposed fall. The Empire did not collapse; it
  dismantled itself. And one unredacted manifest lists a destination:
  **Caelis**. Season cliffhanger.

# Season Two — The Crisis (Missions 23–62)

One long interconnected political crisis. Every faction holds a fragment of
the old system and a fragment of the truth. The player wins battles; Cassian
wins the peace; both discover that Caelis never died.

## Chapter 6 — The Arena (M23–29)

- **M23 Border Contract** — Operating under Cassian's new reclamation charter,
  the player escorts Order scholars through contested territory. The
  charter's first test.
- **M24 Exhibition Match** — Every faction tries to recruit or showcase the
  player in the same week. Cassian plays the offers against each other and
  teaches the player what an auction looks like from inside the lot.
- **M25 Circuit Opening** — The Grand Circuit: where factions settle disputes
  by proxy champion. The charter needs a seat at the table; the price of
  admission is winning. The reigning champion's name is Asha Vale.
- **M26 Crowd Favorite** — Crowd favorite vs. crowd's villain; the player
  learns the arena is a legislature with better catering.
- **M27 Fixed Odds** — Cassian works the boxes while the player
  works the bracket. Two victories per round now.
- **M28 Honest Contest** — An opponent throws the match on orders; the
  player realizes the fix was meant as a gift, and refuses it by winning
  anyway.
- **M29 Championship Point** — The final. The player takes the
  title; Cassian converts it into formal recognition of the charter. The
  factions now have a shared problem: the technician won't stay bought.

## Chapter 7 — Fault Lines (M30–36)

- **M30 Paper Trail** — Lysa, now openly with the player, scouts a
  border incident and finds the "raiders" from Season One were deniable
  contractors. Whose signature is on the pay chits?
- **M31 Engine Below** — A dormant Caelian war-engine wakes beneath a city.
  Five factions blame each other; the player disables the machine while they
  argue. Technology is never neutral.
- **M32 Summit Breach** — Cassian's ceasefire summit, secured by the
  player. Someone bombs it. Everyone's hardliners profit; nobody claims it.
- **M33 Fragment Wake** — Cascading infrastructure failures across two
  territories. The Source fragments are degrading in sympathy. The player
  triages; the politicians posture.
- **M34 Border Retaliation** — Retaliatory strikes between factions. The player
  intercepts one aimed at a civilian district and is denounced by both
  sides for it.
- **M35 One Grid, Two Districts** — One repair crew, two dying grids. Whichever
  district the player saves, the other becomes a faction's martyrdom story.
  A lasting consequence the debriefing should not soften.
- **M36 The Official Broadcast** — Leaders declare the crisis resolved for the
  cameras. The grid is still failing and everyone at the podium knows it.
  Cassian: "Institutions lie to survive. Remember who taught you that."

## Chapter 8 — Heroes and Costs (M37–44)

- **M37 Return to the Township** — Return to the township from M19. An old
  caretaker recognizes one of the player's automatons from before the
  collapse — a resonance scar with a name attached.
- **M38 Forced Relocation** — A commune refuses evacuation from degrading
  territory. The player defends people from a rescue they do not want.
  Not every fix is welcome; not every stubborn faction is wrong.
- **M39 Pass Intercept** — A raid goes wrong and one of the player's oldest
  machines falls covering the retreat. The squad carries its echo. This one
  should hurt in the debriefing, not just the battle.
- **M40 The Last Chassis** — The recovery mission. No speeches, no politics:
  the squad goes back for their own.
- **M41 Contested Records** — The Sanctuary archivist decodes Caelian logistics
  records: Caelis was not destroyed. It was *removed from the maps*.
  Deliberately. By everyone, at once.
- **M42 Patron's Reach** — The Stranger resurfaces with proof that someone
  arranged the Season One relay activation — and that the someone is inside
  the coalition's own patron chain.
- **M43 Clan Terms** — The scavenger clans are squeezed into picking a
  side. They respect one currency; the player pays it in battle, then buys
  their neutrality with the winnings.
- **M44 Guild Reckoning** — Lysa confronts her old guild over the
  contractor pay chits. The guild factor smiles and produces paperwork older
  than the war. The trail points up, not back.

## Chapter 9 — Cores (M45–52)

- **M45 Core in Transit** — Source-cores are being quietly weaponized by
  all five factions. The player seizes one to keep it out of play — and
  becomes a power by owning it, exactly as Cassian warned.
- **M46 Unity Day** — A Unity Day celebration is attacked by extremists
  who want the open war the moderates keep postponing. The coalition holds,
  barely.
- **M47 The Coup** — A hardliner wing attempts to settle the argument by
  force. The player breaks the coup; Cassian absorbs the moderates who
  quietly approved of it.
- **M48 Rearguard** — Beneath the battlefield: a buried Caelian
  transit line, still powered, still maintained, pointing somewhere no map
  admits exists.
- **M49 Three Fronts** — The first true three-faction battle. The player
  cannot win it; they can only keep the civilians out of it. The war
  everyone feared has begun.
- **M50 Truce Line** — Cassian stakes the coalition on an unpopular
  truce. The player holds the line while it is signed, beside an enemy from
  Season One now enforcing the same truce.
- **M51 Coalition Trial** — The oldest automatons begin declining certain
  orders — old resonance scars against new purpose. The player must decide
  what they owe the machines who made them a Conductor.
- **M52 Managed Retreat** — A three-way negotiation collapses into a brawl
  the player loses on purpose to let Cassian save the talks. First
  explicit sign: Cassian no longer needs the player's permission.

## Chapter 10 — Breaking Point (M53–62)

- **M53 Network Answer** — The Source fragments begin synchronizing on their
  own: blackouts, machines waking, networks re-forming. The Order confirms
  it is not an attack. It is a *response*.
- **M54 Intake Blockade** — A faction recruitment center has imprisoned people who
  passed medical screening for possible Relay use, then refused sponsorship
  contracts. They have no Relays and are not Conductors; the blackout gives
  the coalition one chance to get them out before the locked ward closes.
- **M55 Counteroffensive** — Full-scale faction offensive. The player runs
  interceptions at maximum strain; the medics start refusing to clear them
  for the field.
- **M56 The Assassins** — Coalition delegates are assassinated one by one. The
  player protects the survivors — and finally sees the full extent of
  Cassian's information network when it saves them.
- **M57 Tribunal Under Fire** — A public tribunal asks the only question
  that matters: who should govern the Source? Violence interrupts every
  answer. There is no correct side; that is the point of the mission.
- **M58 Royalist Gate** — Fighting reaches the old western districts built
  over Caelian conduits. A royalist remnant still guards the gates below,
  by a charter nobody remembers signing.
- **M59 Battery Night** — Long-range batteries target the conduit network
  itself. The player disables guns that every side will rebuild, and knows
  it. Repair versus control, at artillery scale.
- **M60 Joint Formation** — Asha Vale returns leading a joint strike team of former
  arena rivals — Cassian's coalition, armed at last. The player fights
  beside people who tried to buy, beat, and bury them.
- **M61 The Maintained Route** — The conduits converge on a single navigable route. The
  Stranger steps out of the shadows and introduces themselves properly: a
  warden of Caelis, sent to bring the accidental Conductor home.
- **M62 Caelis Approach** — Season finale. Every faction army reaches the gate
  of Caelis at the same hour. The player's last battle of the season is
  keeping the war from following them inside. Cassian arrives with a
  coalition, not an army. The city opens. **End of Season Two.**

# Season Three — Caelis (New Missions 63–77)

The foundation's Act III, unwritten in code. Fifteen missions in five
chapters; the count is a planning target, not a constraint. The Empire never
fell — it resigned, and kept the keys.

## Chapter 11 — The Outer City (M63–65)

- **M63 Outer Inspection** — Entry terms are set by the city's wardens:
  maintenance automatons and their hereditary Conductors, still executing a
  thousand-year-old disaster protocol. The player is inspected like a
  malfunction.
- **M64 City Still Running** — The Outer City is immaculate and empty: a
  civilization maintained by machines for citizens who never came back.
  What resonance scars look like given centuries.
- **M65 Stewardship Trial** — The wardens will not let an unregistered,
  unsanctioned Conductor deeper in. Earn passage the Caelian way: by
  demonstrating that conducting is stewardship, not command.

## Chapter 12 — The Imperial Archive (M66–68)

- **M66 The Buried Record** — The full record: the Source crisis, the vote to
  fragment, the deliberate destruction of the histories. Combat against the
  archive's own custodial security — it protects truth from everyone alike.
- **M67 Fivefold Claim** — Each faction's founding myth is here, annotated:
  what Coal, Steam, Solar, Wind, and Fusion each preserved, and what each
  was *meant* to preserve. The player reads their own war's syllabus.
- **M68 Deep Archive** — The most destabilizing evidence the foundation
  mentions: what the crisis actually was, and why the Empire decided no
  single power could ever be trusted with the whole system again.

## Chapter 13 — The Conductor Vault (M69–71)

- **M69 Living Witnesses** — What the Empire's Conductors were, what
  the Relay program cost them, and why the Vault exists: not a prison, a
  hospice. The player's medical future, walking and talking.
- **M70 The Relay Experiment** — The player's origin recontextualized: the relay
  activation was a Caelian continuity test, arranged by the wardens through
  expendable intermediaries — including, unknowingly, the expedition's own
  patrons. The Stranger's debt and Cassian's leverage both come due.
- **M71 Crown Continuity** — The wardens offer the player the Vault's purpose:
  become the next warden of the system. A genuine offer, honestly meant,
  and the wrong answer.

## Chapter 14 — The Civic Core (M72–74)

- **M72 Civic Petition** — Caelis petitions to resume stewardship of the
  Source. The factions — via Cassian's coalition — arrive to answer. The
  ideological war the foundation promises: fought in chambers, lost in
  skirmishes outside them.
- **M73 Extremes Aligned** — Hardliners on *both* sides (Caelian restorationists
  and faction maximalists) try to collapse the talks. The player protects
  a negotiation they are not invited to lead.
- **M74 Accord Draft** — Cassian drafts the Accord. The player's role in
  the story visibly shrinks as his completes. That is the success the
  foundation describes, staged as a mission.

## Chapter 15 — The Source (M75–77)

- **M75 Source Balance** — The final reveal: the Source is not a
  generator but a distribution and balancing network. Alone, any one
  faction's fragment is a weapon or a bomb. Together, governed, it is a
  civilization.
- **M76 Rejection Line** — The last battle: not for control of the
  Source, but to keep everyone alive long enough to sign. The war's name,
  spoken for the first time, by the enemy who understands it best.
- **M77 The Caelis Accord** — Finale and epilogue. Partial truth made public, the
  sealed evidence re-sealed, the Source placed under coalition authority.
  Cassian is remembered as the architect of peace; the player returns to
  repair work, diminished in the histories and content in the epilogue.
  Historians name the conflict. Roll credits.

# The Revelation Ladder

Each season's big reveal must recontextualize what came before:

1. **S1** — The accident was staged. (Recontextualizes M3–4, M6.)
2. **S1 finale** — The Empire dismantled itself; Caelis exists in the
   records. (Recontextualizes all "ancient ruin" assumptions.)
3. **S2 mid** — Caelis was deliberately erased from the maps by every
   founding faction at once. (Recontextualizes every faction myth.)
4. **S2 late** — The Source fragments are re-synchronizing by themselves.
   (Recontextualizes the Season Two crises as symptoms, not causes.)
5. **S2 finale** — Caelis is alive, and it summoned the player.
   (Recontextualizes the relay activation.)
6. **S3** — The Source is a balancing network; fragmentation was a
   safeguard, and the player's own creation was a Caelian test.
   (Recontextualizes the entire campaign.)

# Cassian's Influence Track

The foundation's "the player creates leverage, Cassian spends it" needs
visible escalation so the finale lands:

- **S1:** protects the player from investigations; wins passage rights;
  drafts the charter (M20).
- **S2 early:** converts the arena title into recognition (M29); brokers
  the first summit (M32).
- **S2 mid:** absorbs moderate factions (M47); risks everything on a truce
  (M50); acts without the player's permission (M52).
- **S2 late:** his information network saves the delegates (M56); arrives
  at Caelis leading a coalition, not an army (M62).
- **S3:** drafts and wins the Accord (M74, M77) and no longer needs the
  player politically — staged as triumph, not betrayal.

# Writing Rules for Briefings and Debriefings

- Every mission's text must do at least one job from the foundation's
  mission-design list (teach, advance a character, reveal political or
  historical information, change a relationship, move Cassian's track, or
  create a consequence). If a mission does none, merge or rewrite it.
- Briefings state the practical problem (the player's frame). Debriefings
  state the political consequence (Cassian's frame). The gap between the
  two is the game's voice.
- Victories must sometimes cost. At minimum M11, M16, M35, M45, and M49
  end with the player worse off politically for having won.
- The player is addressed by role, never by name; factions are described by
  actors and incentives, never by adjectives.
- Keep existing mission titles — they are load-bearing in code and several
  recur through interludes and later campaign consequences.

# Implementation Notes (when this plan is executed)

- **Append-only:** new missions go at the end of `QUESTS` in
  `scripts/story_quest_catalog.gd` (indices 63+). Never insert mid-list —
  `ADDITIONAL_DROPS`, `MISSION_ENEMY_SQUADS`, and the balance test all key
  off mission index.
- **Acts:** Season Three needs `act: 3` support in
  `StoryQuestCatalog.build()` and anywhere `main.gd` groups missions by act.
- **Briefings/debriefings:** `_mission_briefing` / `_mission_debriefing`
  currently generate rotating placeholder text. The execution step replaces
  them with a per-mission text table (briefing, debriefing, chapter label)
  so the narrative above can be written verbatim without touching battle
  logic.
- **Balance:** any added mission needs an authored enemy squad in
  `MISSION_ENEMY_SQUADS` and must keep
  `tests/balance_simulation.gd`'s `largest_difficulty_jump <= 0.18`.
- **Tests:** `smoke_test.gd` asserts campaign facts that will need updating
  when Season Three missions land.
- **Scope of this document:** narrative organization only. No code changes
  are part of this step.

# Expansion Hooks (post-Season-Three)

Threads deliberately left loose, per the foundation's rule that each
expansion answers one question and poses another:

- Who inside the patron chain *profited* from staging the relay activation?
  (The wardens arranged it; someone else sold them the access.)
- What happens to the freed Relay candidates from M54 in a world where the
  coalition now governs the Source?
- The sealed evidence from M68 — someone always unseals things eventually.
- The feral automaton from M19 and the oldest machines' declining orders
  (M51): what do machines want, once no one is conducting them?
- The royalist remnant's forgotten charter (M58): what else is still under
  the old districts, still guarded, still waiting?
