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
- Select a deployed unit, then an open tile in an adjacent row to reposition it.
- A unit can reposition once per turn unless a Defender's Taunting Strike has locked it for two turns.
- Hover or select a deployed unit to preview its cyan traversal path and coral attack reach.
- Attack reach is projected from the unit's destination after earlier allied movement is simulated.
- Units stop before the opposing deployment column and attack into it; they never enter the opposing edge.
- Units deployed this turn move and attack when that turn resolves.
- Deploy units while enough unlocked Mana remains.
- Use **Rally** once per battle to give all current allied units +1 ATK.
- Select **Resolve Turn** to let units move and fight.
- Select **Squad** to choose up to 15 units, with at most two copies of each.
- Squad Workshop supports click-to-add/remove and drag-and-drop between the Barracks and Squad.
- Defeat the enemy Commander before it reduces your 24 HP to zero.

## Implemented

- Three-lane, seven-column battlefield
- 23 units across six distinct classes
- Persistent 1–15 unit squad construction with a two-copy limit
- 62 sequential story missions across two acts with escalating difficulty
- One-to-three battle encounter sequences with Captain-HP attrition
- Persistent in-progress mission runs and main-menu resume
- Encounter transition screens with upcoming Captain information
- Quest-specific, Star-Rarity-weighted card rewards with persistent unlocks
- 23 unpromoted units: twelve 1★ starters and eleven reward-only units from 2★ to 4★
- End-of-mission card reveal with portrait, Star Rarity, and first-unlock NEW tag
- Main menu, mission selection, practice mode, and campaign briefings
- Mission squad selection before campaign battles
- Six-unit bench and persistent locked-Mana economy
- Automatic movement, targeting, attacks, healing, splash, and piercing
- Enemy deployment AI
- Finite 15-card enemy squads with hand, draw, and deck exhaustion rules
- Visible hand and remaining-deck counters for both sides
- Commander health, Rally powers, victory, defeat, and replay
- Persistent selection of eight Captain skills
- Timed attack effects, healing, direct damage, area damage, and Captain shields
- Active-effect names and remaining duration in unit hover cards
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
