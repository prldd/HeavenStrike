# War of Resonance

A playable Godot 4 prototype of the original lane-based strategy RPG described in [PROJECT.md](PROJECT.md).

## Run

1. Install Godot 4.2 or newer.
2. Import this folder using `project.godot`.
3. Press **F6** or **Run Project**.

The repository includes the current battlefield, menu, workshop, and unit-image
assets required by the prototype.

## Controls

- New profiles begin at the main menu. Start the five-step guided battle any
  time from **Guided Tutorial**.
- The starting collection contains the fifteen base 1-star units; advanced
  units are earned from campaign rewards or Kinetic Crucible promotions.
- Start a full battle from the main menu in **Campaign** or **Practice Battle**.
- Select a unit card whose Mana cost is currently available.
- Select a highlighted tile in the leftmost column to deploy it.
- Select a deployed unit, then a reachable tile in any other row to reposition it; friendly units may be crossed, but enemies block the path.
- A unit can reposition any number of times during its Command phase unless a Defender's Anchor Blow has locked it for two turns. Friendly units may be crossed, but enemies block the path.
- Hover or select a deployed unit to preview its cyan traversal path and coral attack reach.
- Attack reach is projected from the unit's destination after earlier allied movement is simulated.
- Units stop before the opposing deployment column and attack into it; they never enter the opposing edge.
- Units deployed this turn move and attack when that turn resolves.
- Deploy units while enough unlocked Mana remains.
- Use **Rally** once per battle to give all current allied units +1 ATK.
- Select the **→** button at the lower-right of the playfield—or press
  **Enter**—to resolve the turn and let units move and fight.
- Open the upper-right **Settings** gear to change 1×/2×/4× resolution
  speed, sound volume, animation skipping, reduced motion, or to open the
  combat log. These settings apply to battles and replays.
- Select **Replays** from the main menu to play, pause, or
  single-step a completed battle.
- Use **Older** and **Newer** beneath the replay seed to page through the ten
  most recently completed battles.
- Select **Squad** during a replay to compare the recorded player and enemy squads side by side.
- Select **Squad** to choose up to 8 units including the Vanguard, with at most two copies of each.
- In campaign interludes, select **Next** or press **Enter/Space** to advance;
  **Skip Scene** returns directly to the menu or operations map. Completed
  missions with an interlude offer **View Scene** on the operations map.
- Drag cards within the selected squad to reorder them; right-click a card to assign it as Vanguard.
- Squad Workshop supports click-to-add/remove and drag-and-drop between the Barracks and Squad.
- Defeat the enemy Conductor before it reduces your 20 HP to zero.

## Implemented

- Three-lane, seven-column battlefield
- 215 units across six distinct classes
- Persistent 1–8 unit squad construction with a two-copy limit
- 77 sequential story missions across three acts with escalating difficulty
- One-to-three battle encounter sequences with Conductor-HP attrition
- Data-driven campaign encounter rules with survival, protection, and priority-target
  objectives; round limits; blocked terrain; predeployed units; reinforcements; and
  per-encounter Mana parameters
- Persistent in-progress mission runs and main-menu resume
- Encounter transition screens with upcoming Conductor information
- Authored mission reward pools with Star-Rarity weighting and persistent unlocks
- 112 promotion roots or standalone units plus 103 promotion forms with implemented secondary abilities
- End-of-mission card reveal with portrait, Star Rarity, and first-unlock NEW tag
- Post-battle 1–10 performance ratings with Conductor integrity, formation
  survival, and completion-tempo scoring
- Main menu, three region-accurate illustrated Act maps, practice mode, and campaign briefings
- Playable opening tutorial for deployment, locked Mana, eliminating blocking
  units, lane repositioning, Conductor powers, and direct Conductor attacks
- Mission squad selection before campaign battles
- Six-unit bench and persistent locked-Mana economy
- Automatic movement, targeting, attacks, healing, splash, and piercing
- Deployment skills for repair, corrosion, targeted status effects, and lane control
- Strike skills for damage-over-time pressure, vulnerability, knockback, and suppression
- Persistent per-copy Kinetic Crucible progression with five unit levels, donor merging,
  collection consumption, level-scaled stats and skills, and promotion into the next form
- Full-body sprites on the battlefield and unit-list portraits throughout menus and progression screens
- Original full-body and portrait art for every playable unit
- Enemy deployment AI
- Finite 8-card enemy squads with hand, draw, and deck exhaustion rules
- Visible hand and remaining-deck counters for both sides
- Seventy-seven authored, mission-specific eight-card PvE squads and
  context-aware deployment, movement, and Conductor-skill AI
- Mission-specific briefings and debriefings, Act completion tracking, active
  run status, and pre-battle objective, modifier, enemy squad, and Conductor intelligence
- Story-specific opponent names and affiliations carried from prebattle intel
  onto the enemy side of every campaign battlefield
- 46 first-completion character interludes with named human/android portrait
  busts, location-driven scene backgrounds, and operations-map replay,
  spanning the campaign's major cast introductions and reveals
- Continued campaign victories carry the awarded card into Barracks with a
  visible new-reward marker
- Optional 1×/2×/4× combat resolution speed and a toggleable action log
- Persistent battlefield badges for Taunt, Immobilise, attack modifiers, and temporary health
- Player-selected ally, enemy, and lane targets for authored Warcries
- Conductor health, Rally powers, victory, defeat, and replay
- Persistent selection of eight Conductor skills
- Timed attack effects, healing, direct damage, area damage, and Conductor shields
- Active-effect names and remaining duration in unit hover cards
- Persistent battlefield badges show Taunt, Immobilise, Momentum stacks, and timed stat changes.
- Floating combat feedback calls out damage, healing, status application, and Conductor hits.
- Class-specific combat animation includes melee lunges, Gunner trails, Mage projectiles, Priest repair pulses, hit recoil, distinct Twin Actuator impacts, and defeat dissolves.
- Synthesized battle audio distinguishes deployment, movement, class attacks, healing, statuses, shields, Conductor hits, and defeats; Conductor damage also triggers subtle screen shake.
- Victory triggers a dedicated ascending multi-note fanfare before the battle result is presented.
- Each resolution begins with a compact ordered movement/attack preview; the combat log names unit classes and secondary-skill timing.
- Deterministic rules with a presentation layer separated into `BoardView`
- Animated damage, healing, movement, and buff feedback
- Lane-aware AI that counters threats and uses support units contextually
- Unit definitions separated into a reusable catalog

## Unit Art Production

All 215 live unit sprites and portraits are project-original generated chassis.
Standalone generated sources complete the five new units and replace the last
nine atlas fallbacks. The reproducible builder removes their chroma mattes,
applies the established source pipeline, writes per-unit provenance copies, and
emits the runtime files:

```bash
./tools/godot-headless.sh --script res://tools/build_original_unit_art.gd
```

See [the original-art matrix](documentation/Unit_Faction_and_Sprite_Staging.md)
and [the prompt/provenance guide](assets/IMAGEPROMPTS.md). Numeric art IDs and
promotion lineages remain stable for saves and catalog lookups.

## Validation

Run the automated gameplay-data and AI smoke tests:

```bash
./tools/godot-headless.sh --script res://tests/smoke_test.gd
./tools/godot-headless.sh --script res://tests/ui_smoke_test.gd
./tools/godot-headless.sh --script res://tests/balance_simulation.gd
```

The launcher uses the repository-local native Linux Godot 4.7.1 installation
and avoids WSL Windows-binary interoperability issues.

Battle speed, audio, animation-skip, and reduced-motion preferences persist in
the player configuration. Completed battles are added newest-first to
`user://replay_history.json`, which retains the latest ten and discards the
oldest as new battles finish. `user://last_replay.json` remains as a
backward-compatible latest-replay save. The viewer reconstructs each battle
timeline and verifies its final Conductor HP state.

Player, campaign, and in-progress mission-run saves include version metadata.
Legacy unversioned saves remain loadable as version-zero data.

## Current Checkpoint

The current interface cleanup is complete:

- Live battles expose only frequently used battle actions in the action bar.
- Replay mode hides unusable live controls such as the Conductor ability and
  Resolve Turn.
- Replay playback and history navigation are visually separated.
- Speed has one persistent control in Settings; it is not duplicated in the
  battle or replay bars.
- Practice victories offer both **Play Again** and **Menu**.
- Missions 3–9 now exercise the authored encounter-rule system with survival,
  priority-target, and protection objectives plus terrain, timing, reinforcement,
  and Mana modifiers.

For the next session, begin by running the validation commands above. Then play
Missions 3–9 at the target window size, concentrating on objective clarity,
blocked-cell readability, protection-target durability, reinforcement timing,
and the round-limit difficulty. After that balance pass, progression polish is
the next productive focus.
