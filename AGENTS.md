# War of Resonance — Agent Guide

This guide is written for AI coding agents. It describes the project layout, build and test workflows, code conventions, and architectural boundaries so an agent can make safe, useful changes without guessing.

## Project overview

War of Resonance (formerly "Aether Engine Tactics") is a Godot 4 prototype of a lane-based, turn-based tactical RPG. The player builds a squad of up to eight units, deploys them onto a 3×7 board, and resolves battles automatically. The project contains a playable campaign, practice mode, squad builder, Kinetic Crucible progression, enemy AI, deterministic replay history, and synthesized battle audio.

The prototype is intentionally a single-player, desktop-first Godot project. All game logic is written in GDScript. There is no server, no network code, and no external package manager.

## Technology stack

- **Engine:** Godot 4.7.1 (the project file targets feature set `4.7`).
- **Language:** GDScript only.
- **Renderer:** `gl_compatibility` for desktop and mobile compatibility.
- **Target resolution:** 1280×720, windowed, canvas-items stretch mode.
- **Project configuration:** `project.godot` (the Godot project manifest).
- **No external build manifest:** there is no `package.json`, `pyproject.toml`, `Cargo.toml`, `Makefile`, or `CMakeLists.txt`.
- **Audio:** procedurally generated WAV streams at runtime; no external audio assets.
- **Art:** static PNG spritesheets and generated portrait/ full-body PNGs under `assets/`.

## Project structure

```text
.
├── project.godot          # Godot project manifest (application, display, rendering)
├── main.tscn              # Root scene: a single Control node that loads scripts/main.gd
├── README.md              # Player-facing controls and feature list
├── PROJECT.md             # Design document: rules, classes, progression, roadmap
├── AGENTS.md              # This file
├── scripts/               # All GDScript source (Resource classes live in scripts/resources/)
├── tests/                 # Headless Godot test scripts
├── tools/                 # Development utilities
├── assets/                # Spritesheets, generated portraits, generated full-body sprites, backgrounds
├── export_templates/      # Empty in source; Godot export templates live here when installed
├── feature_profiles/      # Empty in source
├── script_templates/      # Empty in source
├── text_editor_themes/    # Empty in source
├── .editorconfig          # Formatting rules
├── .gitattributes         # Line-ending normalization
├── .gitignore             # Godot cache, editor, build, and OS artifacts
└── .tools/                # Local native Linux Godot 4.7.1 binary and isolated user dir (not in git)
```

## Code organization and key modules

All source is in `scripts/`. The architecture separates deterministic simulation from presentation and persistence.

| File | Responsibility |
|------|----------------|
| `main.gd` | Main scene controller. Builds the entire UI in code, owns game state, handles input, drives the battle loop, replays, squad builder, mission select, and settings. |
| `board_view.gd` | Presentation layer for the battlefield: drawing, animations, projectiles, hit flash, screen shake, hover previews. Emits `deployment_clicked`, `board_cell_clicked`, `unit_hovered`, `unit_hover_ended`. |
| `battle_simulator.gd` | Deterministic simulation core: activation order, seeded RNG, replay serialization, damage/healing/shield math, target selection, and squad-power estimation. |
| `battle_rules.gd` | Static rules for the board: movement, repositioning, attack reach, Mana locking, and projected deployment/attack previews. |
| `battle_ai.gd` | Static enemy AI: deployment scoring, repositioning, and Captain-skill timing. |
| `unit_catalog.gd` | Authoritative unit roster: 210 units as `UnitData` Resources with stats, class, race, skills, star rarity, and portrait/full-body art IDs. |
| `resources/unit_data.gd` | `UnitData` Resource: one catalog unit's stats, class, promotion, and skill. `to_dict()` bridges to the card Dictionary shape. |
| `resources/skill_data.gd` | `SkillData` Resource: a secondary skill's name, timing type, optional trigger chance, and description. |
| `unit_skills.gd` | Static resolution of secondary unit skills: Warcry, Chant, Strike, and Reaction timing hooks, plus status effect helpers. |
| `captain_skills.gd` | Static resolution of the eight Commander powers and effect expiration. |
| `squad_store.gd` | Squad persistence (names or instance IDs), validation, default squads, shuffling, and Captain-skill storage. |
| `campaign_store.gd` | Campaign completion, reward pools, reward roll logic, and enemy squad lookup per mission/encounter. |
| `story_quest_catalog.gd` | Builds the 62-mission campaign from reference quest data, reward pools, authored enemy decks, and Captain configurations. |
| `mission_run_store.gd` | In-progress multi-encounter mission run state (current mission, encounter index, carried Captain HP). |
| `kinetic_crucible.gd` | Per-copy unit progression: levels 1–5, merge point values, donor rules, level-based stat growth (`scaled_stat`), promotion conversion (`record_promotion`), inventory sync, and migration from older name-based saves. |
| `battle_settings.gd` | Player settings persistence (resolution speed, audio volume, reduced motion, animation skip). |
| `battle_audio.gd` | Procedural audio generation and polyphonic playback; `AudioStreamPlayer` pool. |
| `ui_theme.gd` | Programmatic theme generation for buttons, panels, scrollbars, and labels. |
| `squad_card.gd` | Drag-and-drop card Button used in the squad builder. |
| `squad_drop_zone.gd` | Drop target PanelContainer used in the squad builder. |

## Build and run

Open the project in Godot 4.2 or newer and run `main.tscn` (press **F6** or **Run Project**). The repository expects a local Linux Godot 4.7.1 binary for headless development work.

The headless launcher is used for automated tests and tooling:

```bash
./tools/godot-headless.sh --script res://tests/smoke_test.gd
./tools/godot-headless.sh --script res://tools/generate_unit_portraits.gd
```

The launcher expects the native Linux binary at:

```text
.tools/godot-4.7.1-linux/Godot_v4.7.1-stable_linux.x86_64
```

It isolates Godot's user data, config, and cache under `.tools/godot-user/` so CI or local test runs do not interfere with the developer's main Godot profile.

## Test commands

Run all three headless tests before committing gameplay or UI changes:

```bash
./tools/godot-headless.sh --script res://tests/smoke_test.gd
./tools/godot-headless.sh --script res://tests/ui_smoke_test.gd
./tools/godot-headless.sh --script res://tests/balance_simulation.gd
```

On Windows (where the Linux launcher cannot run), use the local Windows binary directly. Override `APPDATA` so tests get an isolated user profile — `ui_smoke_test.gd` is sensitive to existing save data in the real profile:

```bash
mkdir -p .tools/godot-user-win
APPDATA="$(pwd -W)/.tools/godot-user-win" "/e/Tools/Godot/Godot.exe" --headless --path . --script res://tests/smoke_test.gd
```

- `smoke_test.gd` — validates the unit catalog, art files, simulator, replay history, damage/healing, Captain shields, squad store, Kinetic Crucible, and skill data. Extensive `assert()` calls; fails fast on regression.
- `ui_smoke_test.gd` — instantiates `main.tscn`, probes the UI control tree, toggles settings, checks audio labels, verifies the board view API, and exercises the Kinetic Crucible UI.
- `balance_simulation.gd` — audits all 62 campaign missions: every configured enemy encounter has a valid squad, positive power, monotonic HP progression, and the difficulty curve stays within the allowed max jump.

There is no separate test runner. Each script is a `SceneTree` that runs in `_init()` and exits with `quit()`.

## Code style guidelines

The project follows `.editorconfig` and `.gitattributes`:

- **Indentation:**
  - Tab characters for `*.gd`, `*.tscn`, `*.tres`, `*.godot`, `*.cfg`.
  - Two spaces for `*.md`, `*.json`, `*.yml`, `*.yaml`.
- **Line endings:** LF for all text files; `.gitattributes` enforces this.
- **Final newlines:** required.
- **Trailing whitespace:** trimmed (except in `*.md`).
- **GDScript style observed in the code:**
  - `snake_case` for functions, variables, and file names.
  - `PascalCase` for `class_name` and built-in node types.
  - `UPPER_SNAKE_CASE` for constants.
  - Prefer `static func` for stateless helpers (rules, catalog, AI, skills, stores).
  - Use `class_name` on reusable helpers (`BattleSimulator`, `BattleRules`, `UnitCatalog`, etc.).
  - Use `preload("res://scripts/...")` for cross-script dependencies.
  - Use `RandomNumberGenerator` with a stored seed for any deterministic/random behavior; the simulator owns the seed.

## Development conventions

- **Single main scene:** `main.tscn` is the only committed scene. The rest of the UI is built in code inside `main.gd`. Add new UI elements inside `main.gd` unless there is a strong reason to introduce a scene file.
- **Mobile touch scrolling:** on Android/iOS (`OS.has_feature("mobile")`), interactive children of `ScrollContainer`s must use `MOUSE_FILTER_PASS` (see `SquadCard.configure` and the mission-list buttons in `main.gd`), otherwise a touch drag that starts on them never reaches the container and the list cannot scroll. Only skip this when the child keeps drag-and-drop on mobile (squad-formation cards). Card drag-and-drop itself is disabled on mobile for list cards (`SquadCard._get_drag_data`) so drags scroll instead of starting a drag; `ui_theme.gd` also widens scrollbars on mobile.
- **Mobile touch details:** touch has no hover, so detail popups must not be driven by `mouse_entered` on mobile (it fires on every tap/scroll and the popup tracks the last touch point). Cards show details via long-press instead: `SquadCard` emits `long_pressed`/`long_press_released` (0.45 s hold, cancelled by ~10 px of movement), wired through `main.gd:_connect_card_details`, and the card tap handlers bail out when `_touch_details_active` is set so the release that ends a long-press does not also fire the card's action (the Viewport delivers the release to the pressed button regardless of `mouse_filter`, so suppression must happen at the action level).
- **Simulation vs. presentation:** keep deterministic combat rules in `BattleSimulator`, `BattleRules`, `BattleAI`, `UnitSkills`, and `CaptainSkills`. Keep drawing, animation, audio, and input in `BoardView` and `main.gd`. Do not add combat logic to `BoardView`.
- **Unit data as Resources:** the catalog (`UnitCatalog`) returns `UnitData`/`SkillData` Resources built once in code; `by_name()` returns `null` when a unit is missing. New units belong in the `_unit(...)` list in `UnitCatalog._build()`. Deck/hand cards and runtime battle units remain plain Dictionaries — cards are produced via `UnitData.to_dict()` plus per-instance keys in `SquadStore.build_deck`, and `main.gd:_spawn_unit` builds runtime instances from cards (applying `KineticCrucible.scaled_stat` for the card's level). Secondary skills scale with unit level: `UnitCatalog.RANK_VALUES` holds the five per-level rows ported from the unit reference, `SkillData` carries them as `rank_values` with `{0}`/`{1}` placeholder descriptions, and `UnitSkills.rank_value` reads the magnitudes at resolution time. Any new secondary skill needs a rank table (or flat fallback), a matching resolution branch in `UnitSkills`, and an AI consideration in `BattleAI` if relevant.
- **Deterministic replays:** the simulator records events. Replays are saved to `user://last_replay.json` and archived newest-first to `user://replay_history.json` (limit 10). Keep replay serialization backward-compatible where possible; the tests already assert version 1 format.
- **Persistence:** all player save data is written under `user://` via `ConfigFile` or `JSON`. Files include `user://player.cfg`, `user://campaign.cfg`, `user://mission_run.cfg`, and `user://kinetic_crucible.cfg`. Migration code is kept in the relevant store scripts, not in `main.gd`.
- **Portraits:** generated from `assets/units/portrait_manifest.tsv` and the source sheets in `assets/units/portrait_sheets/`. The generator asserts exactly 1,048 portraits. Regenerate with:
  ```bash
  ./tools/godot-headless.sh --script res://tools/generate_unit_portraits.gd
  ```
  Generated outputs live in `assets/units/portraits/` and `assets/units/full/` and are committed.

## Data and assets

- `assets/units/reference-units-*.png` — battlefield sprite sheets (6 units per sheet, 6 sheets committed).
- `assets/units/portrait_sheets/` — high-resolution source sheets for portraits.
- `assets/units/portraits/` — 160×160 generated portrait PNGs.
- `assets/units/full/` — generated full-body sprites used on the battlefield.
- `assets/units/portrait_manifest.tsv` — TSV mapping `art_id`, `sheet_name`, `slot`, `...` used by the generator.
- Background images are at the repository root under `assets/` (e.g. `board-steampunk-courtyard.png`, `main-menu-steampunk-deck.png`). Practice battles use `assets/board-steampunk-training-hall.png` instead of the courtyard; `BoardView.set_practice_mode()` switches between them. The training-hall art is generated procedurally — regenerate with `python tools/generate_practice_background.py`.

Do not add external audio files. Audio is synthesized in `battle_audio.gd`.

## Testing strategy

1. Run the three headless scripts above.
2. After UI changes, run `ui_smoke_test.gd` and then do a manual visual pass at the target 1280×720 window size.
3. When adding units or changing campaign data, run `balance_simulation.gd` to avoid breaking the difficulty curve assertion (`largest_difficulty_jump <= 0.18`).
4. `smoke_test.gd` is the broad safety net; it asserts exact counts (210 units, 15/17/39/52/61/26 six-bucket star distribution, 103 promotions, 13 audio sounds, etc.), so expect to update it when intentionally expanding the roster.

## Save files and persistence

Godot `user://` resolves to the project-local user dir when run through `tools/godot-headless.sh`. Important persistent files:

- `user://player.cfg` — battle settings, squad name list, and squad instance IDs.
- `user://campaign.cfg` — completed missions, reward units, and debug-granted inventory.
- `user://mission_run.cfg` — active multi-encounter run.
- `user://kinetic_crucible.cfg` — per-copy collection instances, levels, and points.
- `user://last_replay.json` — legacy single latest replay.
- `user://replay_history.json` — newest-first list of up to 10 versioned replays.

All persisted structures include a `version` field. Legacy unversioned data is loaded as version zero in `main.gd`.

## Deployment

There is no automated deployment or CI pipeline in the repository. Exporting is done through the Godot editor or the `godot --export` command after installing export templates.

### Android

The `Android` export preset in `export_presets.cfg` is configured and verified (arm64-v8a, debug signing). Prerequisites:

- Export templates for 4.7.1.stable installed under `%APPDATA%/Godot/export_templates/4.7.1.stable/` (only the `android_*.apk` files are needed for non-gradle exports).
- JDK 17 — a portable Temurin build lives at `.tools/jdk/` (referenced from `export/android/java_sdk_path` in the Godot editor settings); the Android SDK path is also configured there, and debug signing uses `C:/Users/<user>/.android/debug.keystore` (alias `androiddebugkey`, pass `android`).
- `textures/vram_compression/import_etc2_astc=true` in `project.godot` (required for Android export; already set).

Headless debug build (output goes to the gitignored `exports/`):

```bash
"/e/Tools/Godot/Godot.exe" --headless --path . --export-debug "Android" "exports/war-of-resonance-debug.apk"
```

Gitignore excludes:

- `.godot/` — engine import/cache files.
- `.tools/` — local binary/tool directory (except the launcher script is kept in `tools/`).
- `/build/`, `/dist/`, `/exports/` — export output directories.
- `export_credentials.cfg` — never commit export credentials.

If you add an export workflow, keep credentials out of the repository and write output to the ignored directories above.

## Security considerations

- The game runs entirely locally. There are no network requests, no secrets, and no third-party API keys.
- `export_credentials.cfg` is gitignored; do not create or commit it.
- Do not read or write files outside `res://` (project directory) or `user://` (Godot's user data path). The exception is the portrait generator, which writes generated PNGs back into `res://assets/units/` so they can be committed.
- Avoid using `eval`, `OS.execute`, or `FileAccess` on arbitrary paths. If you need to load a user-provided file, validate the path and extension.
- Save files are plain text ConfigFile/JSON. This is acceptable for a single-player prototype; do not treat them as authoritative for multiplayer.

## Porting units and skills from the reference

The authoritative unit source is chainguardians.com (a Heavenstrike Rivals
database). The project's roster, rank tables, and campaign drop lists are
ported from it. Follow this workflow when adding more.

### Extracting the reference database

The site is an AngularJS app; HTML fetches return only the shell. The full unit
database (1,052 units) is embedded as a JS literal in the app bundle:

1. Fetch any page (e.g. `https://chainguardians.com/units`) and find the
   `sky-app.min.<hash>.js` script name (the hash changes between deploys).
2. Download that bundle, then in Node extract the array starting at
   `function UnitData(){var e={units:[` with bracket matching and `eval()` it
   into JSON (it is an unquoted JS literal, not strict JSON).

Each unit record has: `numberId` (zero-padded string), `name`, `className`
(defender/fighter/scout/gunner/mage/priest), `starCount`, `manaCost`,
`maxAttack`, `maxHealth`, `race`, `promotionIds`, and `skill` with `name`,
`type` (warcry/strike/chant/reaction/aura), `description` (with `{0}`/`{1}`
placeholders), and `values` (five per-level rank rows). Drop sources are split
into `storyQuests`, `events`, `raids`, `arenas`, and `gatcha` — **only
`storyQuests` matter for campaign rewards** (`Act N Mission M - Title`, where M
is the global 1–62 mission number used in `ADDITIONAL_DROPS`). Units with zero
story quests are starting-Reserve cards instead of reward cards — with one
documented exception: the 53-unit Regen-skills batch (icons 119–171) was added
to `REWARD_UNITS` even though only Rescue Corps / Rescue Paramedic have story
drops, by explicit owner decision; its units are reward-pool-only, not
starting Reserves.

### Art assets

- **Portraits** (`assets/units/portraits/%03d.png`) are pre-generated for all
  1,048 manifest units — no work needed for new units.
  `assets/units/portrait_manifest.tsv` columns: art ID (= reference
  `numberId`), portrait sheet, slot, full-body sheet, slot, unit name. The
  960×160 six-slot portrait sheets live in `assets/units/portrait_sheets/`.
- **Full-body sprites** (`assets/units/full/%03d.png`) exist only for a subset
  of units, and the full-body sheets are *not* mirrored locally. Download
  missing ones from `https://chainguardians.com/img/full/<numberId>.png`
  (a `_hires` variant exists at `img/full_hires/<numberId>.png`). They are
  roughly 415px-wide chibi PNGs. `smoke_test.gd` asserts both files exist for
  every roster unit; commit the `.import` files Godot generates on the next
  run.

### Catalog conventions

- Project `icon` IDs are project-local and do **not** equal reference
  `numberId`s (e.g. Order Apostle is icon 25 but art 29). New units take the
  next free project icon and an `ICON_ART_IDS` entry mapping it to the
  reference `numberId`; `art_id()` defaults to identity when unmapped.
- Class mapping: defender→Warden, fighter→Duelist, scout→Strider,
  gunner→Artillerist, mage→Channeler, priest→Lifebinder. Movement/range by
  class: Warden 2/1, Duelist 2/1, Strider 3/1, Artillerist 1/3, Channeler 1/3,
  Lifebinder 1/2. Cost/ATK/HP are ported verbatim from `manaCost`/`maxAttack`/
  `maxHealth`. Class ability text is a fixed string per class (see existing
  entries).
- Secondary skill description text is the reference description verbatim; the
  five `values` rows go into `UnitCatalog.RANK_VALUES` keyed by skill name.
- Race is ported from the reference `race` key (human/ogur/lambkin/felyne):
  `UnitCatalog.UNIT_RACES` maps project icon → race for NON-human units only
  and `_unit(...)` defaults the rest to `"human"` (via `UnitData.race`, which
  `to_dict()` and `main.gd:_spawn_unit` carry onto card and runtime unit
  Dictionaries). Race currently has no UI; it gates the Inspire Lambkin aura.
- Promotions are declared pairwise via `promotion_of`, but chains can be three
  tiers deep (Conjuring Clown → Harlequin → Jester, Flame Warden → Dissident →
  Schematic). `KineticCrucible.record_promotion` promotes one step at a time
  and `_promotion_root` walks the full chain with a guard loop, so no special
  handling is needed beyond declaring each link.

### Skill implementation checklist

1. `RANK_VALUES` entry + `_skill(...)` on each unit in `UnitCatalog._build()`.
2. A resolution branch in `scripts/unit_skills.gd` (`resolve_warcry`,
   `resolve_strike`, `resolve_chants`, `resolve_reaction`, `refresh_auras` —
   all five timing hooks are live; auras are recomputed from living sources
   on every call, stripping each unit's `aura_hp`/`aura_atk` and re-applying,
   so a buff disappears when its source dies). Auras so far: Moonlight (HP
   only) and Inspire Lambkin (HP + ATK, gated on the target's
   `race == "lambkin"`, source excluded); multiple sources of the same aura
   stack additively, and each change event carries a `stat` field ("HP"/"ATK")
   so `main.gd:_refresh_auras` can log it. The `target_id = -1` /
   `target_lane = -1` fallbacks are what the enemy AI uses — `BattleAI` itself
   only scores by class and usually needs no per-skill changes.
   `resolve_chants(side, units, phase, ...)` runs twice per side turn:
   `phase = "start"` for start-of-turn chants (and the Regen/Poison tick lives
   in `resolve_start_statuses`), `phase = "end"` for skills in
   `END_TURN_CHANTS` (Impairing Joust, Galatine's Ground, Cattle of Ra) and the Sun Festival
   buff countdown. Status mechanics ported from the reference: Regen (heal at
   side-turn start, mirrors Poison), Stun (`stun_turns` blocks activation,
   traversal, and repositioning — see `BattleRules.is_stunned` and the
   `activation_order` filter), Haste (+1 move in `traversal_cells`), and doom
   (`doom_turns` countdown that sets HP to 0 when it expires, ticking on the
   opposing side's expiry pass). Silence (`silenced_turns`, applied by the
   Divine Silence Warcry) is the game's skill-locking status: while the
   counter holds, `UnitSkills.is_silenced` gates all five timing hooks, so
   the unit's own Warcry, Strike, Chants (both phases, including the Roguish
   Snare pre-pass), and Reaction do not trigger, and it stops contributing
   its Aura in `refresh_auras` (the buff drops while Silenced and returns on
   expiry). It ticks down in the same `expire_statuses` pass as
   `immobilized_turns` — at the end of the silenced unit's own side turns —
   so the rank value N lasts N of the silenced unit's turns (the "enemy
   turns" of the reference text, from the caster's perspective). Silence
   never blocks movement, attacks, or Captain skills, and class abilities
   are flavor text with no mechanics, so "Class Skills are silenced" from
   the reference is a no-op here. The Divine Silence AI fallback
   (`_skilled_enemy`) picks the highest-ATK enemy carrying a secondary
   skill; skill-less enemies are never Silenced. Knockback (Caber Toss,
   Tag-Team) shifts the
   target one cell away from the attacker along its column, stopping at the
   board edge or an occupied cell, and is reported via `result.moved`.
   Roguish Snare is a deployment-reactive trigger family: it fires at the
   start of the OPPOSING side's turn from that side's living carriers, so
   `resolve_chants` takes a `last_placed_id` argument — the deploying side's
   most recently placed unit, tracked in `main.gd:last_deployed_unit_id`
   (updated by `_spawn_unit`, reset by `_start_new_match`) — and the
   `_append_roguish_snare` pre-pass Stuns it for 2 turns with a rank-scaled
   chance of permanent Poison (`PERMANENT_POISON_TURNS = 999`, which
   `resolve_start_statuses` never ticks down; `BoardView` and
   `CaptainSkills.effect_summary` special-case it for display).
   Wrangle is column-relative and cross-lane ("Affects all lanes"): side 0
   advances toward higher columns and side 1 toward lower ones, so allies
   on columns further from the enemy edge than the chanter are "behind"
   (gain Protect) and enemies on columns closer to it are "in front"
   (lose ATK via the `effects` debuff mechanism); units in the chanter's
   own column are neither.
   Summon Forth and Quiet! share the damage-immunity core in
   `BattleSimulator.apply_unit_damage(unit, amount, source)`: attack damage
   (the direct hit in `main.gd:_activate_unit` and its Blast/Pierce riders in
   `_apply_special_damage`) passes the attacking unit as `source`, while
   secondary-skill and Captain damage passes no source and bypasses both
   immunities. Summon Forth is a Warcry that sets `summon_forth_turns`
   (ticking on the opposing side's expiry pass, like `doom_turns`, so N
   covers exactly the next N enemy turns); while it holds, attack damage
   against the carrier is 0 and `main.gd` fires
   `UnitSkills.resolve_summon_forth` once per blocked hit — {2} highest-ATK
   living enemies take {1}% of the attacker's ATK (minimum 1, rounded down),
   with ATK-tier ties at the cutoff broken by seeded RNG
   (`_highest_attack_enemies`). The result's `immunity` field names the
   immunity that zeroed the hit so the presentation layer can show IMMUNE
   and trigger the retaliation. Quiet! is a countdown chant: `_spawn_unit`
   initializes `quiet_triggers_left` from rank {0}, and the `_append_quiet`
   pre-pass in `resolve_chants` phase `"start"` (same opposing-side pattern
   as Roguish Snare) fires when the opposing side's turn begins, Silencing
   the {1} highest-ATK living enemies for {2} turns (`silenced_turns`, max
   not stack). A Silenced carrier's trigger does not fire and does not
   spend a charge; its passive (0 attack damage from Silenced attackers,
   checked in the same damage gate) is not a trigger and keeps working.
3. If the player chooses a target, wire `main.gd`: ally-target follows the
   `pending_empower_actor_id` pattern, enemy-target the
   `pending_envenom_actor_id` pattern, and lane-target the
   `pending_lane_actor_id` + `_lane_target_kinds()` pattern. Add the skill to
   the damage/heal/status audio and animation lists in `_resolve_warcry`.
4. Rewards: add the unit to `ADDITIONAL_DROPS` in
   `scripts/story_quest_catalog.gd` (missions from the reference `storyQuests`)
   and to `REWARD_UNITS` in `scripts/campaign_store.gd`. Never edit
   `MISSION_ENEMY_SQUADS` for this — those decks are deliberately authored.
   Live example: the Inspire Lambkin batch (icons 208–215) — Claw Minstrel,
   Claw Rocker, Flame Warden, and Flame Dissident are reward units with
   `ADDITIONAL_DROPS` entries; the other four carriers have no story drops
   and are starting Reserves.

### Updating the tests

`tests/smoke_test.gd` hardcodes roster facts that must move together: total
roster size, the icon upper bound, the five star-count buckets, the six class
counts, the promotion count, per-skill unit counts, `art_id()` assertions, and
reward-pool assertions. Add resolution tests for each new skill following the
existing fixtures. `tests/balance_simulation.gd` must keep
`largest_difficulty_jump <= 0.18` (reward pools do not affect it, enemy-squad
edits do).

Gotchas when running the Windows binary headless:

- A failed `assert()` prints the error but leaves Godot running idle instead
  of exiting — kill the process after a timeout and read the captured log.
- `smoke_test.gd` never loads `main.tscn`, so parse errors in `main.gd` only
  surface in `ui_smoke_test.gd`.
- GDScript lambdas cannot span lines inside a call unless the body is wrapped
  in parentheses: `func(u): return (u.a and u.b)` — otherwise the parser
  reports "Expected closing \")\" after call arguments".

## Common tasks

- **Add a unit:** add a `_unit(...)` entry to `UnitCatalog._build()` in `scripts/unit_catalog.gd`, add portrait/full-body art to `assets/units/`, map the art ID in `ICON_ART_IDS`, update `smoke_test.gd` counts if intentional, and run the three tests. For reference-sourced units follow the full workflow in "Porting units and skills from the reference" above.
- **Add a skill timing:** add a branch in `scripts/unit_skills.gd` and wire it into the battle resolution in `main.gd`. Add an AI consideration in `scripts/battle_ai.gd` if the enemy should use it.
- **Add a Captain skill:** edit `scripts/captain_skills.gd`, add the name to `CaptainSkills.SKILLS`, and update the description.
- **Add a mission:** edit `scripts/story_quest_catalog.gd` (`QUESTS`, `ADDITIONAL_DROPS`, `MISSION_ENEMY_SQUADS`), then run `balance_simulation.gd`.
- **Change UI theme:** edit `scripts/ui_theme.gd`; the theme is generated programmatically and applied to the root control in `main.gd`.
- **Change audio:** edit `scripts/battle_audio.gd`; the sounds are generated from wave functions.

When in doubt, keep logic in the static helper scripts and keep `main.gd` focused on orchestration and UI state.
