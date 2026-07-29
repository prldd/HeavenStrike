# Skychain Tactics

Skychain Tactics is a compact, turn-based strategy RPG inspired by the lane-based battles of *Heavenstrike Rivals*. Players assemble a squad of original fantasy units, deploy them onto a small battlefield, and use their class behaviors and abilities to defeat the enemy Commander.

This is a spiritual successor, not a remake. Its setting, characters, artwork, audio, story, terminology, interface, and progression will be original.

## The Player Experience

A match should be easy to understand, tactically interesting, and last about five to eight minutes. The player makes a small number of important decisions:

- Which unit to deploy
- Which lane to place it in
- Whether to attack, defend, or prepare for a later turn
- How to combine unit classes and abilities
- When to use the Commander's once-per-battle power

After deployment, units act automatically. The strategy comes from anticipating how the board will resolve.

## How a Match Is Played

### Objective

Each side has a Commander at opposite ends of the battlefield. Reduce the enemy Commander's health to zero before the enemy defeats yours.

### Battlefield

The battlefield contains three lanes and seven columns. The player controls the left side and the opponent controls the right side.

```text
Player                                                     Enemy
Commander  [ ][ ][ ][ ][ ][ ][ ]  Commander
Commander  [ ][ ][ ][ ][ ][ ][ ]  Commander
Commander  [ ][ ][ ][ ][ ][ ][ ]  Commander
```

Units enter from their owner's edge and advance toward the opposing Commander. Units normally remain in their chosen lane unless an ability moves them.

### Squad

Before battle, each side prepares a squad of up to 15 units:

- One Vanguard is always available at the start of the match.
- Up to 14 other units form the draw pile.
- The player begins with the Vanguard and three drawn units.
- A bench can hold up to six units.
- A squad may contain no more than two copies of the same unit.
- The Barracks begins with one copy of every base-set card and permanently keeps every card reward, including duplicates.
- Players can drag cards between Barracks and Squad; clicking a selected squad card removes one copy.
- PvE opponents follow the same squad, opening hand, hand limit, draw, and deck-exhaustion rules.

Every unit has a deployment cost, attack, health, movement distance, attack range, class, and one or more abilities.

### Mana

Deploying a unit locks its Mana cost while it remains on the battlefield.

- Both sides begin with a Mana capacity of 2.
- Capacity increases by 2 at the start of each later turn, up to 10.
- Available Mana equals capacity minus Mana locked by active units.
- When a unit is defeated, its locked Mana becomes available again.

This makes committing an expensive unit a continuing resource decision rather than a one-turn payment.

### Turn Sequence

Each turn has four phases.

1. **Start**
   - Increase Mana capacity by 2, up to 10.
   - Recalculate available Mana after active-unit locks.
   - Draw one unit.
   - Resolve start-of-turn effects.

2. **Command**
   - Deploy one or more units the player can afford.
   - Units are placed in an open tile on the player's deployment edge.
   - Reposition deployed units to an open tile in an adjacent lane at the same column.
   - Use the Commander power if it is available.
   - End the phase when ready.

3. **Resolution**
   - Units act one at a time, beginning with the unit closest to the enemy Commander.
   - A unit first moves toward the enemy by up to its movement distance.
   - Movement stops early when another unit still occupies the next cell.
   - After movement finishes, the unit attacks if a valid target is in range.
   - Abilities, healing, status effects, and defeated units are resolved immediately.

4. **End**
   - Check whether either Commander has been defeated.
   - Resolve end-of-turn effects.
   - The opposing side begins its turn.

The match continues until a Commander reaches zero health. If both Commanders are defeated during the same action, the acting player wins.

## Combat Rules

- A unit cannot move through another unit.
- Frontmost units resolve first, so vacated cells are available to units moving later in the same phase.
- Opposing units in the same lane block one another.
- A unit attacks the nearest valid target unless an ability says otherwise.
- Damage reduces health immediately.
- A unit is removed when its health reaches zero.
- If no unit blocks an attack at the end of a lane, the enemy Commander takes the damage.
- The first and seventh columns are deployment and Commander zones. Units may deploy there, but opposing units stop in the adjacent column and attack into the zone instead of entering it.
- Newly deployed units move and attack during the resolution phase of the turn in which they are placed.
- Each deployed unit may reposition once per Command phase without losing its normal activation.
- A unit hit by a Defender's Taunting Strike cannot change lanes for its next two turns.
- Effects with the same timing resolve in board order, from the enemy side toward the acting side, then from the top lane downward.

These rules are deterministic: the same board state and commands always produce the same result.

## Unit Classes

| Class | Movement | Range | Battlefield role |
| --- | ---: | ---: | --- |
| Scout | 3 | 1 | **Double Strike:** attacks twice each attack action |
| Fighter | 2 | 1 | **Fury:** permanently gains +1 ATK after attacking a unit or Captain |
| Defender | 2 | 1 | **Taunting Strike:** prevents its target from changing lanes for two turns |
| Gunner | 1 | 3 | **Piercing Shot:** damages every enemy in range along its lane |
| Mage | 1 | 3 | **Blast:** adjacent enemies take half the Mage's ATK as splash damage |
| Priest | 1 | 2 | **Heal:** gives 2 HP to the lowest-health other ally before moving |

Classes define basic behavior, while individual abilities give each unit a distinct purpose.

The implemented roster currently contains 18 unpromoted units: the original twelve 1★ cards and the first six-unit 2★ cohort. Two-star units are earned through their reference story-mission drop pools and are not included in the starting Barracks.

## Example Turn

The player begins a turn with 4 available Mana. An enemy Defender blocks the center lane, while the top lane is open.

1. The player deploys a 2-Mana Scout in the top lane.
2. The player deploys a 2-Mana Priest behind a damaged Fighter in the center lane.
3. During resolution, the Fighter attacks the Defender.
4. The Priest heals the Fighter.
5. The new units do not act because they were deployed this turn.
6. On the next player turn, the Scout can advance quickly through the open lane while the center group keeps the Defender occupied.

The player has traded immediate power for pressure in one lane and durability in another.

## Commander Powers

Each Commander equips one power for battle: Rally, Bloodlust, Aid, Healing Wave, Shield, Last Stand, Lightning Burst, or Firestorm. Friendly-unit effects normally last one turn unless a skill explicitly states otherwise.

Commander selection changes a squad's strategy without adding another unit to the board.

## Game Modes

### First Playable Version

- Tutorial
- Full 62-mission, two-act story campaign
- Practice battle against AI
- Squad-building screen
- 18 original units, with three units per class
- Three Commanders

### Later Possibilities

- Additional campaign chapters
- Challenge battles with special board rules
- Draft mode
- Local pass-and-play
- Online competitive matches
- Replays and ranked seasons

Online play and live-service systems are outside the first release. The battle simulation must be complete and reliable before multiplayer is considered.

Campaign mission selection flows from the scrollable world map into squad selection and then one to three consecutive battles. All 62 reference story missions are present across two acts. The battlefield, decks, Mana, and Captain-skill use reset between encounters, while the player's Captain carries remaining HP forward. In-progress runs can be resumed.

## Progression

Campaign victories award one random card from that quest's eligible drop list. Drop weight halves with each additional Star Rarity, making lower-star cards progressively more likely. Earned card unlocks persist and expand strategic options rather than directly increasing unit statistics.

The first release will not include loot boxes, paid energy, duplicate-unit upgrades, or randomized stat growth.

## Presentation

The game takes place among drifting island-cities connected by ancient skyways. Rival expedition crews compete for control of weather engines that keep the islands aloft.

The visual direction combines:

- Illustrated character cards
- Readable, small battlefield figures
- Bright elemental effects
- A clean interface designed for mouse and touch
- Strong lane, range, target, and movement indicators

Combat information must remain readable even when several abilities resolve in sequence.

## Technical Direction

The project will use Godot 4 and target desktop first at a touch-friendly 16:9 resolution. Unit and ability data will be stored as Godot Resources so content can be balanced without changing combat code.

The battle simulation will be separated from animation and interface code. It will produce an ordered list of events—movement, attacks, healing, status changes, and defeats—which the presentation layer then animates. This supports reliable AI testing, replays, faster debugging, and possible future network play.

## First Milestone

The initial milestone is a complete battle sandbox:

- A functional 3-by-7 board
- One player Commander and one AI Commander
- Deployment, Mana locking, movement, attacks, and victory conditions
- One unit from each of the six classes
- A simple AI that can deploy units and complete a match
- Placeholder visuals

The milestone is successful when a player can finish a full five-to-eight-minute match and each class has a clearly recognizable tactical role.

## Intellectual Property Boundary

The project may draw inspiration from compact lane-based tactical combat, but it must not use the *Heavenstrike Rivals* name, characters, factions, story, dialogue, unit designs, artwork, audio, extracted assets, branding, or copied interface. All production content will be created specifically for Skychain Tactics.
