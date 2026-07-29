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

Before battle, each side prepares a squad of 15 units:

- One Vanguard is always available at the start of the match.
- The other 14 units form the draw pile.
- The player begins with the Vanguard and three drawn units.
- A hand can hold up to five units.
- A squad may contain no more than three copies of the same unit.

Every unit has a deployment cost, attack, health, movement distance, attack range, class, and one or more abilities.

### Energy

Deploying units costs Energy.

- Both sides begin with 2 maximum Energy.
- Maximum Energy increases by 1 at the start of each turn, up to 10.
- Available Energy refills to the current maximum at the start of the turn.
- Unspent Energy does not carry over.

This creates a natural progression from inexpensive opening units to powerful late-match combinations.

### Turn Sequence

Each turn has four phases.

1. **Start**
   - Increase and refill Energy.
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
   - A unit attacks if a valid target is in range.
   - Otherwise, it moves toward the enemy by up to its movement distance.
   - Abilities, healing, status effects, and defeated units are resolved immediately.

4. **End**
   - Check whether either Commander has been defeated.
   - Resolve end-of-turn effects.
   - The opposing side begins its turn.

The match continues until a Commander reaches zero health. If both Commanders are defeated during the same action, the acting player wins.

## Combat Rules

- A unit cannot move through another unit.
- Opposing units in the same lane block one another.
- A unit attacks the nearest valid target unless an ability says otherwise.
- Damage reduces health immediately.
- A unit is removed when its health reaches zero.
- If no unit blocks an attack at the end of a lane, the enemy Commander takes the damage.
- Newly deployed units cannot act until their owner's next turn unless they have the **Quick** keyword.
- Each deployed unit may reposition once per Command phase without losing its normal activation.
- A Warden taunts opposing units up to two spaces ahead, preventing them from changing lanes.
- Effects with the same timing resolve in board order, from the enemy side toward the acting side, then from the top lane downward.

These rules are deterministic: the same board state and commands always produce the same result.

## Unit Classes

| Class | Movement | Range | Battlefield role |
| --- | ---: | ---: | --- |
| Strider | 3 | 1 | Fast attacker that strikes twice for lower damage |
| Duelist | 2 | 1 | Melee fighter that gains attack after surviving combat |
| Warden | 2 | 1 | Durable protector that forces nearby enemies to target it |
| Artillerist | 1 | 3 | Ranged attacker whose shots can pierce targets in a lane |
| Channeler | 1 | 3 | Spellcaster that damages the target and adjacent tiles |
| Lifebinder | 1 | 2 | Support unit that heals or strengthens allies |

Classes define basic behavior, while individual abilities give each unit a distinct purpose.

## Example Turn

The player begins a turn with 4 Energy. An enemy Warden blocks the center lane, while the top lane is open.

1. The player deploys a 2-Energy Strider in the top lane.
2. The player deploys a 2-Energy Lifebinder behind a damaged Duelist in the center lane.
3. During resolution, the Duelist attacks the Warden.
4. The Lifebinder heals the Duelist.
5. The new units do not act because they were deployed this turn.
6. On the next player turn, the Strider can advance quickly through the open lane while the center group keeps the Warden occupied.

The player has traded immediate power for pressure in one lane and durability in another.

## Commander Powers

Each Commander has one power that may be used once per battle during the Command phase. Initial powers include:

- **Rally:** Give all allied units +1 attack this turn.
- **Bulwark:** Give the Commander a temporary shield.
- **Reposition:** Move one allied unit to the same column in an adjacent lane.

Commander selection changes a squad's strategy without adding another unit to the board.

## Game Modes

### First Playable Version

- Tutorial
- Short five-mission campaign
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

## Progression

Campaign victories unlock new units and Commanders. Unlocks expand strategic options rather than directly increasing unit statistics. A unit always uses the same combat values, so success depends on squad construction and play rather than grinding.

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
- Deployment, Energy, movement, attacks, and victory conditions
- One unit from each of the six classes
- A simple AI that can deploy units and complete a match
- Placeholder visuals

The milestone is successful when a player can finish a full five-to-eight-minute match and each class has a clearly recognizable tactical role.

## Intellectual Property Boundary

The project may draw inspiration from compact lane-based tactical combat, but it must not use the *Heavenstrike Rivals* name, characters, factions, story, dialogue, unit designs, artwork, audio, extracted assets, branding, or copied interface. All production content will be created specifically for Skychain Tactics.
