# Skychain Tactics

A playable Godot 4 prototype of the original lane-based strategy RPG described in [PROJECT.md](PROJECT.md).

## Run

1. Install Godot 4.2 or newer.
2. Import this folder using `project.godot`.
3. Press **F6** or **Run Project**.

The project uses only code-drawn visuals and has no external asset dependencies.

## Controls

- Start from the main menu in **Campaign** or **Practice Battle**.
- Select a unit card whose Mana cost is currently available.
- Select a highlighted tile in the leftmost column to deploy it.
- Select a deployed unit, then a reachable tile in any other row to reposition it; units cannot pass through occupied tiles.
- A unit can reposition any number of times during its Command phase unless a Defender's Taunting Strike has locked it for two turns. Friendly units may be crossed, but enemies block the path.
- Hover or select a deployed unit to preview its cyan traversal path and coral attack reach.
- Attack reach is projected from the unit's destination after earlier allied movement is simulated.
- Units stop before the opposing deployment column and attack into it; they never enter the opposing edge.
- Units deployed this turn move and attack when that turn resolves.
- Deploy units while enough unlocked Mana remains.
- Use **Rally** once per battle to give all current allied units +1 ATK.
- Select **Resolve Turn** to let units move and fight.
- Select **Squad** to choose up to 8 units including the Vanguard, with at most two copies of each.
- Drag cards within the selected squad to reorder them; right-click a card to assign it as Vanguard.
- Squad Workshop supports click-to-add/remove and drag-and-drop between the Barracks and Squad.
- Defeat the enemy Commander before it reduces your 24 HP to zero.

## Implemented

- Three-lane, seven-column battlefield
- 45 units across six distinct classes
- Persistent 1–8 unit squad construction with a two-copy limit
- 62 sequential story missions across two acts with escalating difficulty
- One-to-three battle encounter sequences with Captain-HP attrition
- Persistent in-progress mission runs and main-menu resume
- Encounter transition screens with upcoming Captain information
- Reference-accurate story-quest card pools with Star-Rarity weighting and persistent unlocks
- 28 unpromoted units plus 17 standalone promotion cards with implemented secondary abilities
- End-of-mission card reveal with portrait, Star Rarity, and first-unlock NEW tag
- Main menu, mission selection, practice mode, and campaign briefings
- Mission squad selection before campaign battles
- Six-unit bench and persistent locked-Mana economy
- Automatic movement, targeting, attacks, healing, splash, and piercing
- Enemy deployment AI
- Finite 8-card enemy squads with hand, draw, and deck exhaustion rules
- Visible hand and remaining-deck counters for both sides
- Mission-specific eight-card PvE squads and context-aware deployment, movement, and Captain-skill AI
- Optional 1×/2×/4× combat resolution speed and a toggleable action log
- Persistent battlefield badges for Taunt, Immobilise, attack modifiers, and temporary health
- Player-selected targets for Empower Warcries
- Commander health, Rally powers, victory, defeat, and replay
- Persistent selection of eight Captain skills
- Timed attack effects, healing, direct damage, area damage, and Captain shields
- Active-effect names and remaining duration in unit hover cards
- Persistent battlefield badges show Taunt, Immobilise, Fury stacks, and timed stat changes.
- Floating combat feedback calls out damage, healing, status application, and Commander hits.
- Each resolution begins with a compact ordered movement/attack preview; the combat log names unit classes and secondary-skill timing.
- Deterministic rules with a presentation layer separated into `BoardView`
- Five-step in-game field briefing
- Animated damage, healing, movement, and buff feedback
- Lane-aware AI that counters threats and uses support units contextually
- Unit definitions separated into a reusable catalog

## Validation

Run the automated gameplay-data and AI smoke tests:

```bash
godot --headless --path . --script res://tests/smoke_test.gd
```
