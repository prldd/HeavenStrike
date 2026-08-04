# War of Resonance

A playable Godot 4 prototype of the original lane-based strategy RPG described in [PROJECT.md](PROJECT.md).

## Run

1. Install Godot 4.2 or newer.
2. Import this folder using `project.godot`.
3. Press **F6** or **Run Project**.

The repository includes the current battlefield, menu, workshop, and unit-image
assets required by the prototype.

## Controls

- Start from the main menu in **Campaign** or **Practice Battle**.
- Select a unit card whose Mana cost is currently available.
- Select a highlighted tile in the leftmost column to deploy it.
- Select a deployed unit, then a reachable tile in any other row to reposition it; friendly units may be crossed, but enemies block the path.
- A unit can reposition any number of times during its Command phase unless a Defender's Taunting Strike has locked it for two turns. Friendly units may be crossed, but enemies block the path.
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
- Defeat the enemy Commander before it reduces your 20 HP to zero.

## Implemented

- Three-lane, seven-column battlefield
- 210 units across six distinct classes
- Persistent 1–8 unit squad construction with a two-copy limit
- 77 sequential story missions across three acts with escalating difficulty
- One-to-three battle encounter sequences with Captain-HP attrition
- Persistent in-progress mission runs and main-menu resume
- Encounter transition screens with upcoming Captain information
- Reference-accurate story-quest card pools with Star-Rarity weighting and persistent unlocks
- 107 promotion roots or standalone units plus 103 promotion forms with implemented secondary abilities
- End-of-mission card reveal with portrait, Star Rarity, and first-unlock NEW tag
- Main menu, mission selection, practice mode, and campaign briefings
- Mission squad selection before campaign battles
- Six-unit bench and persistent locked-Mana economy
- Automatic movement, targeting, attacks, healing, splash, and piercing
- Mend Warcries that restore 3 HP to the most-wounded ally
- Plague Warcries that damage every other unit and Poison them for two turns
- Envenom Warcries with explicit enemy targeting and two-turn Poison
- Pin Down Warcries that damage and Immobilise the strongest eligible melee enemy
- Lane-targeted Demoralize Warcries and automatic Punish attack debuffs
- Poison Strike attacks and Sunder Armour vulnerability setup
- Persistent per-copy Kinetic Crucible progression with five unit levels, donor merging,
  collection consumption, level-scaled stats and skills, and promotion into the next form
- Full-body sprites on the battlefield and unit-list portraits throughout menus and progression screens
- A reference-only library of all 1,048 source portraits used during the original-art replacement pass
- Enemy deployment AI
- Finite 8-card enemy squads with hand, draw, and deck exhaustion rules
- Visible hand and remaining-deck counters for both sides
- Seventy-seven authored, mission-specific eight-card PvE squads and
  context-aware deployment, movement, and Captain-skill AI
- Mission-specific briefings and debriefings, Act completion tracking, active
  run status, and pre-battle enemy squad/Captain intelligence
- 46 first-completion character interludes with a reusable speaker-driven
  dialogue presentation and operations-map replay, spanning the campaign's
  major cast introductions and reveals
- Continued campaign victories carry the awarded card into Barracks with a
  visible new-reward marker
- Optional 1×/2×/4× combat resolution speed and a toggleable action log
- Persistent battlefield badges for Taunt, Immobilise, attack modifiers, and temporary health
- Player-selected targets for Empower Warcries
- Commander health, Rally powers, victory, defeat, and replay
- Persistent selection of eight Captain skills
- Timed attack effects, healing, direct damage, area damage, and Captain shields
- Active-effect names and remaining duration in unit hover cards
- Persistent battlefield badges show Taunt, Immobilise, Fury stacks, and timed stat changes.
- Floating combat feedback calls out damage, healing, status application, and Commander hits.
- Class-specific combat animation includes melee lunges, Gunner trails, Mage projectiles, Priest healing pulses, hit recoil, distinct Double Strike impacts, and defeat dissolves.
- Synthesized battle audio distinguishes deployment, movement, class attacks, healing, statuses, shields, Commander hits, and defeats; Commander damage also triggers subtle screen shake.
- Victory triggers a dedicated ascending multi-note fanfare before the battle result is presented.
- Each resolution begins with a compact ordered movement/attack preview; the combat log names unit classes and secondary-skill timing.
- Deterministic rules with a presentation layer separated into `BoardView`
- Animated damage, healing, movement, and buff feedback
- Lane-aware AI that counters threats and uses support units contextually
- Unit definitions separated into a reusable catalog

## Unit Art Production

Replacement full-body art is organized under
`assets/units/full_by_class/<Pool>/<Class>/`. The six production pools and
their primary affinities are Universal/Fighter, Steam/Defender, Wind/Scout,
Coal/Gunner, Fusion/Mage, and Solar/Priest. Universal is neutral rather than a
sixth political faction. Every pool contains all six classes, and promotion
lineages remain together.

Use [the faction and sprite staging reference](documentation/Unit_Faction_and_Sprite_Staging.md)
for exact unit assignments and [the image prompt guide](assets/IMAGEPROMPTS.md)
for matching pool/class generation instructions. Keep numeric art-ID filenames
unchanged. The game continues to load `assets/units/full/` until the new sprite
set is complete and approved.

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
timeline and verifies its final Captain HP state.

Player, campaign, and in-progress mission-run saves include version metadata.
Legacy unversioned saves remain loadable as version-zero data.

## Current Checkpoint

The current interface cleanup is complete:

- Live battles expose only frequently used battle actions in the action bar.
- Replay mode hides unusable live controls such as the Captain ability and
  Resolve Turn.
- Replay playback and history navigation are visually separated.
- Speed has one persistent control in Settings; it is not duplicated in the
  battle or replay bars.
- Practice victories offer both **Play Again** and **Menu**.

For the next session, begin by running the validation commands above. A useful
next pass is hands-on playtesting at the target window size, concentrating on
the replay bar, Settings popover, combat-log overlap, and the transition
between replay, squad comparison, and the main menu. After UI verification,
return to gameplay balance or progression work rather than adding more replay
controls.
