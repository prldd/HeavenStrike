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
- A unit can reposition once per turn unless it has been hit by an active enemy Warden's Taunting Strike.
- Hover or select a deployed unit to preview its cyan traversal path and coral attack reach.
- Attack reach is projected from the unit's destination after earlier allied movement is simulated.
- Deploy units while enough unlocked Mana remains.
- Use **Rally** once per battle to give all current allied units +1 ATK.
- Select **Resolve Turn** to let units move and fight.
- Select **Squad** to choose up to 15 units, with at most two copies of each.
- Defeat the enemy Commander before it reduces your 24 HP to zero.

## Implemented

- Three-lane, seven-column battlefield
- 18 units across six distinct classes
- Persistent 1–15 unit squad construction with a two-copy limit
- Five sequential campaign missions with escalating difficulty
- Persistent mission completion and unit rewards
- Main menu, mission selection, practice mode, and campaign briefings
- Mission squad selection before campaign battles
- Card hand and persistent locked-Mana economy
- Automatic movement, targeting, attacks, healing, splash, and piercing
- Enemy deployment AI
- Finite 15-card enemy squads with hand, draw, and deck exhaustion rules
- Visible hand and remaining-deck counters for both sides
- Commander health, Rally powers, victory, defeat, and replay
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
