# Modular Unit Art Buildout

## Goal

Replace the expensive one-render-per-unit pipeline with a compact library of
robot parts. A unit becomes a deterministic assembly recipe, while factions,
classes, progression, and individual identity come from separate visual layers.
The first prototype lives only in **Unit View / Creator** so the art direction
can be approved before battlefield, cards, portraits, or saved replays change.

## Visual grammar

Every assembled unit has five independent decisions:

1. **Faction kit** — palette, material language, panel marks, vents, fins, or
   energy seams. Coal, Steam, Wind, Fusion, Solar, and Universal form the first
   six kits.
2. **Class kit** — weapon, readable combat silhouette, attack pivot, and VFX
   socket. Warden, Duelist, Strider, Artillerist, Channeler, and Lifebinder each
   get one strong primary read before variants are added.
3. **Frame** — Standard, Bulwark, Swift, or Resonant body proportions. This maps
   directly to the existing chassis-family mechanic.
4. **Identity parts** — interchangeable head and later shoulder, torso-shell,
   leg, and back-module variants. These make promotion families recognizable
   without requiring a wholly new illustration.
5. **Finish** — Field, Officer, or Prototype surface treatment. Finish is a
   low-cost rarity/promotion signal and never changes the silhouette.

The prototype currently exposes 6 × 6 × 4 × 4 × 3 = **1,728 combinations**
from a small procedural vocabulary. Pose is preview state, not unit identity.

## Technical shape

- `UnitAssemblyCatalog` owns stable component names, palettes, class kits, and
  normalized recipes. Runtime code should depend on recipe data, not UI nodes.
- `UnitCreatorView` draws a pivoted robot from primitives and provides Idle,
  Traverse, and Attack previews. Red pivot markers can be enabled to review
  animation rig quality.
- A production recipe should use stable component IDs and a schema version.
  Its deterministic defaults can derive from unit icon ID, class, faction, and
  chassis family, avoiding new save data for the existing roster.
- The eventual battlefield renderer should consume the same recipe and pose
  data, at a lower level of detail, without moving combat rules into the view.
- Replays should store the unit's recipe ID only when a recipe can differ from
  the catalog default. Old version-one replays continue deriving defaults.

## Phased rollout

### Phase 0 — Art-direction prototype (this change)

- Add Unit View / Creator to the main menu.
- Prove silhouette, faction palette, frame proportions, head swaps, animation
  pivots, and one attack language per class.
- Keep all deployed-unit, portrait, reward, and catalog art unchanged.

Exit gate: each class is identifiable without UI copy at 160 px tall; each
faction is distinguishable in grayscale silhouette plus one color cue; Idle,
Traverse, and Attack have no visible joint separation.

### Phase 1 — Asset vocabulary

- Convert the approved prototype language into SVG or small transparent PNG
  parts at a shared 512 × 512 rig canvas.
- Author 4 heads, 4 torsos, 4 leg sets, 3 arm sets, 6 class weapons, 6 faction
  detail kits, and common shadow/damage overlays.
- Define named sockets: root, hip, chest, neck, shoulders, elbows, hands,
  weapon muzzle/edge, backpack, core, and ground contact.
- Add automated checks for canvas size, alpha bounds, socket names, duplicate
  IDs, and parts extending outside safe bounds.

Exit gate: at least 24 deliberately selected recipes look intentional at full,
card, and board sizes; components never require per-unit positional patches.

### Phase 2 — Rig and animation library

- Store animation clips as curves over named sockets: Idle, Traverse, Deploy,
  Hit, Defeat, and one class Attack clip.
- Layer faction-specific VFX and class weapon events over shared body motion.
- Add reduced-motion transforms and animation-off settled poses.
- Use the existing deterministic battle events to trigger clips; animation
  time never affects simulation results.

Exit gate: all clips work for all four frames and all head variants; attacks
remain legible at 1×, 2×, 4×, and autobattle speeds.

### Phase 3 — Catalog recipe assignment

- Derive a baseline recipe for all 223 playable units and the mission-only
  transport, then hand-author exceptions only for story or promotion needs.
- Keep promotion families on a shared base silhouette and add one obvious
  upgrade part or finish step.
- Generate deterministic portrait thumbnails from the rig for menus and saves;
  cache them instead of committing hundreds of unique source renders.

Exit gate: recipe audit covers every live icon ID; promotion and faction rules
pass; portrait generation is deterministic and build-time bounded.

### Phase 4 — Staged integration

1. Formation/requisition cards and hover details.
2. Kinetic Crucible and reward reveal.
3. Battlefield idle/deployment rendering.
4. Traverse, attack, hit, and defeat animations.
5. Remove legacy per-unit runtime PNG dependencies only after visual parity and
   replay compatibility are verified.

Each step keeps a feature flag or fallback to the current `assets/units/full/`
and `assets/units/portraits/` art until its visual tests pass.

## Review checklist in Unit View / Creator

- Can the class be named from silhouette alone?
- Does the faction read without changing the body proportions?
- Do Standard, Bulwark, Swift, and Resonant feel like one construction system?
- Are hands, muzzle, weapon edge, feet, and core obvious enough to become
  reliable animation/VFX sockets?
- Does the design survive at roughly 160 px tall?
- Which combinations look accidental, overly human, or too visually noisy?
