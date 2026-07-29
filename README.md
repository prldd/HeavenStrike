# Skychain Tactics

A playable Godot 4 prototype of the original lane-based strategy RPG described in [PROJECT.md](PROJECT.md).

## Run

1. Install Godot 4.2 or newer.
2. Import this folder using `project.godot`.
3. Press **F6** or **Run Project**.

The project uses only code-drawn visuals and has no external asset dependencies.

## Controls

- Select an affordable unit card at the bottom of the screen.
- Select a highlighted tile in the leftmost column to deploy it.
- Deploy as many units as available Energy allows.
- Use **Rally** once per battle to give all current allied units +1 ATK.
- Select **Resolve Turn** to let units move and fight.
- Defeat the enemy Commander before it reduces your 24 HP to zero.

## Implemented

- Three-lane, seven-column battlefield
- Six distinct unit classes
- Card hand and escalating Energy economy
- Automatic movement, targeting, attacks, healing, splash, and piercing
- Enemy deployment AI
- Commander health, Rally powers, victory, defeat, and replay
- Deterministic rules with a presentation layer separated into `BoardView`

