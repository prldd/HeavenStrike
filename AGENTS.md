# War of Resonance — Agent Guide

This guide is written for AI coding agents. It describes the project layout, build and test workflows, code conventions, and architectural boundaries so an agent can make safe, useful changes without guessing.

## Project overview

War of Resonance is a Godot 4 prototype of a lane-based, turn-based tactical RPG. The player builds a squad of up to eight units, deploys them onto a 3×7 board, and resolves battles automatically. The project contains a playable campaign, practice mode, squad builder, Kinetic Crucible progression, enemy AI, deterministic replay history, and synthesized battle audio.

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
├── documentation/         # Narrative plans, consolidated narrative script, and unit faction/sprite reference
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
| `board_view.gd` | Presentation layer for the battlefield: drawing, animations, projectiles, hit flash, screen shake, hover previews. Emits `deployment_clicked`, `board_cell_clicked`, `unit_hovered`, `unit_hover_ended`, `opponent_hovered`, `opponent_hover_ended` (opponent signals fire when the mouse enters/leaves the opponent name plaque; `main.gd` answers with the win-condition hover card). |
| `battle_simulator.gd` | Deterministic simulation core: activation order, seeded RNG, replay serialization, damage/healing/shield math, target selection, and squad-power estimation. |
| `battle_rules.gd` | Static rules for the board: movement, repositioning, attack reach, Mana locking, and projected deployment/attack previews. |
| `battle_ai.gd` | Static enemy AI: deployment scoring, repositioning, and Conductor-skill timing. |
| `mission_rules.gd` | Normalizes authored encounter objectives and modifiers, formats mission intel, validates blocked/setup/reinforcement data, and evaluates deterministic win/loss conditions. |
| `challenge_catalog.gd` | Three authored challenge battles and deterministic UTC ISO-week rotation metadata. |
| `challenge_store.gd` | Persistent rotating-challenge completions and idempotent Requisition Credit reward orchestration. |
| `unit_catalog.gd` | Authoritative original roster: 223 units as `UnitData` Resources with stats, class, chassis family, skills, star rarity, and portrait/full-body art IDs. |
| `mission_unit_catalog.gd` | Mission-only `UnitData` assets that can be predeployed and replayed but never enter rewards, Reserves, or the Kinetic Crucible. |
| `resources/unit_data.gd` | `UnitData` Resource: one catalog unit's stats, class, promotion, and skill. `to_dict()` bridges to the card Dictionary shape. |
| `resources/skill_data.gd` | `SkillData` Resource: a secondary skill's name, timing type, optional trigger chance, and description. |
| `unit_skills.gd` | Static resolution of secondary unit skills: Warcry, Chant, Strike, and Reaction timing hooks, plus status effect helpers. |
| `conductor_skills.gd` | Static resolution of the eight Conductor powers and effect expiration. |
| `squad_store.gd` | Squad persistence (names or instance IDs), validation, default squads, shuffling, and Conductor-skill storage. |
| `campaign_store.gd` | Campaign completion, reward pools, reward roll logic, and enemy squad lookup per mission/encounter. |
| `requisition_store.gd` | Persistent Requisition Credit wallet, pull costs, spending, and idempotent source-owned reward claims. |
| `story_quest_catalog.gd` | Builds the 77-mission original campaign from authored reward pools, enemy decks, and Conductor configurations. `MISSION_STORIES` holds per-mission story text (chapter label, briefing, debriefing) keyed by 1-based mission number. |
| `story_dialogue_catalog.gd` | Editable post-mission interludes. `INTERLUDES` is keyed by 1-based mission number and holds a scene title, location, and ordered speaker/text lines; `CHARACTERS` owns speaker roles, initials, and accent colors. `main.gd` owns only the dialogue presentation and return flow. |
| `mission_run_store.gd` | In-progress multi-encounter mission run state (current mission, encounter index, carried Conductor HP, and persisted Autobattle eligibility). |
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

- `smoke_test.gd` — validates the unit catalog, art files, simulator, replay history, damage/healing, Conductor shields, squad store, Kinetic Crucible, and skill data. Extensive `assert()` calls; fails fast on regression.
- `ui_smoke_test.gd` — instantiates `main.tscn`, probes the UI control tree, toggles settings, checks audio labels, verifies the board view API, and exercises the Kinetic Crucible UI.
- `balance_simulation.gd` — audits all 77 campaign missions: every configured enemy encounter has a valid squad, positive power, monotonic HP progression, and the difficulty curve stays within the allowed max jump.

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
- **Simulation vs. presentation:** keep deterministic combat rules in `BattleSimulator`, `BattleRules`, `BattleAI`, `UnitSkills`, and `ConductorSkills`. Keep drawing, animation, audio, and input in `BoardView` and `main.gd`. Do not add combat logic to `BoardView`.
- **Autobattle:** completed campaign missions offer an AUTOBATTLE button in the squad builder (`squad_autobattle_button` → `main.gd:_save_and_autobattle_mission`). It reuses the live battle loop rather than a separate simulation: `autobattle_active` forces `_animation_duration` to 0.001, `_resolve_warcry` skips its player-target prompts so `UnitSkills`' side-agnostic `-1` fallbacks pick targets, and `_autobattle_player_turn` (a side-flipped mirror of `_enemy_turn`) drives repositioning, deployment, and the Conductor skill through `BattleAI.choose_reposition`, `choose_deployment`, and `should_use_conductor_skill` — the latter two take an optional `side` parameter that defaults to ENEMY. Multi-encounter missions auto-advance past the "FIELD SECURED" screen inside `_check_game_over`. The flag clears on manual mission starts, redeploy, practice, and the main menu, but survives a loss so RETRY BATTLE autobattles again. The Operation Complete screen also offers AUTOBATTLE (`result_autobattle_button` → `_autobattle_mission_replay`) next to REDEPLOY and the primary CAMPAIGN action; its campaign-win home button is the shared home glyph.
- **Home icon:** every return-to-menu control (battle HUD, tutorial, result screens, replay panel, mission select, Kinetic Crucible, Requisition) is a textless Button built by `main.gd:_make_home_button` with the procedural glyph from `UITheme.home_icon()`; keep new menu-return buttons on the same helper instead of adding "MENU" text labels.
- **Authored encounter rules:** optional rules live in `StoryQuestCatalog.ENCOUNTER_RULES`, keyed as `"<1-based mission>:<0-based encounter>"`, and are normalized by `MissionRules`. Encounters without an entry must retain the standard defeat-the-Conductor behavior. Setup and reinforcement deployments must be recorded with their exact cell and mission-role metadata so version-one replays can reconstruct them without executing live rule setup.
- **Unit data as Resources:** the catalog (`UnitCatalog`) returns `UnitData`/`SkillData` Resources built once in code; `by_name()` returns `null` when a unit is missing. New units belong in the `_unit(...)` list in `UnitCatalog._build()`. Deck/hand cards and runtime battle units remain plain Dictionaries — cards are produced via `UnitData.to_dict()` plus per-instance keys in `SquadStore.build_deck`, and `main.gd:_spawn_unit` builds runtime instances from cards (applying `KineticCrucible.scaled_stat` for the card's level). Secondary skills scale with unit level: `UnitCatalog.RANK_VALUES` holds the five authored per-level rows, `SkillData` carries them as `rank_values` with `{0}`/`{1}` placeholder descriptions, and `UnitSkills.rank_value` reads the magnitudes at resolution time. Any new secondary skill needs authored copy, a rank table (or flat fallback), a matching resolution branch in `UnitSkills`, and an AI consideration in `BattleAI` if relevant.
- **Deterministic replays:** the simulator records events. Replays are saved to `user://last_replay.json` and archived newest-first to `user://replay_history.json` (limit 10). Keep replay serialization backward-compatible where possible; the tests already assert version 1 format.
- **Persistence:** all player save data is written under `user://` via `ConfigFile` or `JSON`. Files include `user://player.cfg`, `user://campaign.cfg`, `user://mission_run.cfg`, and `user://kinetic_crucible.cfg`. Migration code is kept in the relevant store scripts, not in `main.gd`.
- **Original unit art:** the seven class atlases in `assets/units/original_sources/class_atlases/` and standalone generated sources in `assets/units/original_sources/generated_chassis/` are the generative sources for playable and mission-only chassis. `assets/units/gen/` contains a transparent generated cutout for every live art ID, so runtime art no longer needs an atlas fallback. The builder asserts exactly 224 full-body sprites and 224 portraits (223 playable, one mission-only). Regenerate with:
  ```bash
  ./tools/godot-headless.sh --script res://tools/build_original_unit_art.gd
  ```
  The builder writes per-unit provenance copies to `assets/units/original_sources/faction_chassis/` and committed runtime outputs to `assets/units/full/` and `assets/units/portraits/`. Promotion families must stay in one faction pool and numeric art IDs must remain stable.

## Data and assets

- `assets/units/original_sources/class_atlases/` — seven original mechanical class atlases.
- `assets/units/original_sources/faction_chassis/` — 224 derived provenance files, grouped by faction and class.
- `assets/units/portraits/` — exactly 224 generated 160×160 portrait PNGs.
- `assets/units/full/` — exactly 224 original full-body sprites used on the battlefield.
- `assets/dialogue/original_sources/` and `assets/dialogue/portraits/` — original supporting-cast source atlas and keyed portraits.
- `assets/units/attack/<art id>/attack_<1..6>.png` — optional per-unit attack animation frames extracted from generated video clips. When all six imported frames exist for a unit's art id, `BoardView` swaps them in during unit and Conductor attacks (progress driven by `unit_attack_frame_progress`) and skips the overlapping generic class effect; units without frames keep the static-sprite lunge and class effect. Frames share the idle sprite's canvas size and foot line. Generate them with the Python pipeline:
  ```bash
  .tools/anim-pipeline-venv/Scripts/python.exe tools/attack_anim/extract_attack_frames.py --video <clip.mp4> --art-id 241
  ```
  Install `tools/attack_anim/requirements.txt` into the gitignored `.tools/anim-pipeline-venv`; `ffmpeg` must be on PATH. The script requires exactly six timestamps (override with `--times` in seconds), crops letterbox bars, keys out the white background and gray ground shadow, and rescales/re-anchors every frame onto the idle sprite's canvas — the scale comes from the last (settled) frame, feet aligned to the idle sprite's foot line. It also writes a `preview.png` contact sheet into the output directory for review; `preview.png` is not loaded by the game. Open Godot after extraction so the PNGs are imported for export-safe runtime loading. `tests/attack_animation_visual_check.gd` directly exercises art ID 241 without depending on player save data.
- `assets/IMAGEPROMPTS.md` — original generation briefs and provenance rules.
- Menu and operations-map backgrounds are at the repository root under `assets/`. Battlefield stage art lives under `assets/boards/`: practice/tutorial uses the training hall, while `BoardView.set_campaign_mission()` selects Relay excavation, proving circuit, faction crossroads, coalition front, or Caelis sanctum by mission range. Normalize all runtime boards from `assets/boards/original_sources/` with `./tools/godot-headless.sh --script res://tools/build_board_background_art.gd`.

Do not add external audio files. Audio is synthesized in `battle_audio.gd`.

## Testing strategy

1. Run the three headless scripts above.
2. After UI changes, run `ui_smoke_test.gd` and then do a manual visual pass at the target 1280×720 window size.
3. When adding units or changing campaign data, run `balance_simulation.gd` to avoid breaking the difficulty curve assertion (`largest_difficulty_jump <= 0.18`).
4. `smoke_test.gd` is the broad safety net; it asserts exact counts (223 playable units plus mission-only assets, 15/17/48/56/61/26 six-bucket star distribution, 107 promotions, 13 audio sounds, etc.), so expect to update it when intentionally expanding either catalog.

## Save files and persistence

Godot `user://` resolves to the project-local user dir when run through `tools/godot-headless.sh`. Important persistent files:

- `user://player.cfg` — battle settings, squad name list, and squad instance IDs.
- `user://campaign.cfg` — completed missions, reward units, and debug-granted inventory.
- `user://requisition.cfg` — Requisition Credit balance and idempotent reward claim IDs.
- `user://challenges.cfg` — completed rotating-challenge claim IDs.
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

## Original unit and skill workflow

All roster identities, descriptions, values, rewards, and art must be authored for War of Resonance. Do not import or adapt third-party databases, character names, text, designs, or assets. New content should extend the established chassis naming grammar, faction palette, and deterministic balance model.

### Art assets

- The seven class atlases under `assets/units/original_sources/class_atlases/` are original source assets.
- `tools/build_original_unit_art.gd` chroma-keys those atlases, derives faction variants, and writes both provenance and runtime images.
- Every active catalog art ID must have exactly one file in `assets/units/full/` and `assets/units/portraits/`; inactive art is not retained in production directories.
- New source art must be created specifically for this project, recorded in `assets/IMAGEPROMPTS.md`, and must not use an external character or artwork as an image reference.

### Catalog conventions

- Project `icon` IDs are stable gameplay identifiers. `ICON_ART_IDS` maps them to stable numeric filenames when the IDs differ.
- Internal classes are Warden, Duelist, Strider, Artillerist, Channeler, and Lifebinder. Movement and range are authored per card, while class ability copy stays consistent within a class.
- Secondary-skill copy lives in `SKILL_DESCRIPTIONS`; five level rows live in `RANK_VALUES`. Both are original project content and must change together.
- `CHASSIS_FAMILIES` assigns optional `standard`, `bulwark`, `swift`, or `resonant` tuning families. Foundation Grid, Aegis Lattice, Vector Manifold, Resonance Pulse, and Resonant Chorus grant family-gated effects.
- Promotions are declared pairwise via `promotion_of`; `KineticCrucible.record_promotion` safely walks multi-tier chains.
- Retired public names are migrated only through hashes in `legacy_content_migration.gd`; never reintroduce retired strings into production files.

### Skill implementation checklist

1. `RANK_VALUES` entry + `_skill(...)` on each unit in `UnitCatalog._build()`.
2. A resolution branch in `scripts/unit_skills.gd` (`resolve_warcry`,
   `resolve_strike`, `resolve_chants`, `resolve_reaction`, `refresh_auras` —
   all five timing hooks are live; auras are recomputed from living sources
   on every call, stripping each unit's `aura_hp`/`aura_atk`/`aura_move` and
   re-applying, so a buff disappears when its source dies). Family auras are
   Foundation Grid (Standard HP + ATK), Aegis Lattice (Bulwark HP), Vector
   Manifold (Swift Move), and Resonant Chorus (Resonant HP + ATK); all exclude
   the source. Lumen Shell remains an unrestricted HP aura, while Dawn Circuit
   grants HP + ATK to allies that currently have Regen.
   Multiple sources of the same aura stack additively, and each change event
   carries a `stat` field ("HP"/"ATK"/"MOVE") so
   `main.gd:_refresh_auras` can log it. The `target_id = -1` /
   `target_lane = -1` fallbacks are what the enemy AI uses. `BattleAI` scores
   family-matched allies when deploying chassis-synergy carriers.
   `resolve_chants(side, units, phase, ...)` runs twice per side turn:
   `phase = "start"` for start-of-turn chants (and the Regen/Poison tick lives
   in `resolve_start_statuses`), `phase = "end"` for skills in
   `END_TURN_CHANTS` (Lockdown Sweep, Grounding Wave, Dragnet) and the Solar Crescendo
   buff countdown. Status mechanics authored for this project: Regen (heal at
   side-turn start, mirrors Poison), Stun (`stun_turns` blocks activation,
   traversal, and repositioning — see `BattleRules.is_stunned` and the
   `activation_order` filter), Haste (+1 move in `traversal_cells`), and doom
   (`doom_turns` countdown that sets HP to 0 when it expires, ticking on the
   opposing side's expiry pass). Silence (`silenced_turns`, applied by the
   Null Signal Warcry) is the game's skill-locking status: while the
   counter holds, `UnitSkills.is_silenced` gates all five timing hooks, so
   the unit's own Warcry, Strike, Chants (both phases, including the Roguish
   Snare pre-pass), and Reaction do not trigger, and it stops contributing
   its Aura in `refresh_auras` (the buff drops while Silenced and returns on
   expiry). It ticks down in the same `expire_statuses` pass as
   `immobilized_turns` — at the end of the silenced unit's own side turns —
   so the rank value N lasts N of the silenced unit's turns (the "enemy
   turns" of the authored rules text, from the caster's perspective). Silence
   never blocks movement, attacks, or Conductor skills, and class abilities
   are flavor text with no mechanics, so a skill lock does not suppress the
   unit's class behavior. The Null Signal AI fallback
   (`_skilled_enemy`) picks the highest-ATK enemy carrying a secondary
   skill; skill-less enemies are never Silenced. Knockback (Kinetic Throw,
   Paired Circuit) shifts the
   target one cell away from the attacker along its column, stopping at the
   board edge or an occupied cell, and is reported via `result.moved`.
   Deployment Snare is a deployment-reactive trigger family: it fires at the
   start of the OPPOSING side's turn from that side's living carriers, so
   `resolve_chants` takes a `last_placed_id` argument — the deploying side's
   most recently placed unit, tracked in `main.gd:last_deployed_unit_id`
   (updated by `_spawn_unit`, reset by `_start_new_match`) — and the
   `_append_roguish_snare` pre-pass Stuns it for 2 turns with a rank-scaled
   chance of permanent Poison (`PERMANENT_POISON_TURNS = 999`, which
   `resolve_start_statuses` never ticks down; `BoardView` and
   `ConductorSkills.effect_summary` special-case it for display).
   Frontline Relay is column-relative and cross-lane ("Affects all lanes"): side 0
   advances toward higher columns and side 1 toward lower ones, so allies
   on columns further from the enemy edge than the chanter are "behind"
   (gain Protect) and enemies on columns closer to it are "in front"
   (lose ATK via the `effects` debuff mechanism); units in the chanter's
   own column are neither.
   Retaliation Screen and Silent Cycle share the damage-immunity core in
   `BattleSimulator.apply_unit_damage(unit, amount, source)`: attack damage
   (the direct hit in `main.gd:_activate_unit` and its Arc Burst/Rail Volley riders in
   `_apply_special_damage`) passes the attacking unit as `source`, while
   secondary-skill and Conductor damage passes no source and bypasses both
   immunities. Retaliation Screen is a Warcry that sets `summon_forth_turns`
   (ticking on the opposing side's expiry pass, like `doom_turns`, so N
   covers exactly the next N enemy turns); while it holds, attack damage
   against the carrier is 0 and `main.gd` fires
   `UnitSkills.resolve_summon_forth` once per blocked hit — {2} highest-ATK
   living enemies take {1}% of the attacker's ATK (minimum 1, rounded down),
   with ATK-tier ties at the cutoff broken by seeded RNG
   (`_highest_attack_enemies`). The result's `immunity` field names the
   immunity that zeroed the hit so the presentation layer can show IMMUNE
   and trigger the retaliation. Silent Cycle is a countdown chant: `_spawn_unit`
   initializes `quiet_triggers_left` from rank {0}, and the `_append_quiet`
   pre-pass in `resolve_chants` phase `"start"` (same opposing-side pattern
   as Deployment Snare) fires when the opposing side's turn begins, Silencing
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
   `scripts/story_quest_catalog.gd` (mission keys are authored)
   and to `REWARD_UNITS` in `scripts/campaign_store.gd`. Never edit
   `MISSION_ENEMY_SQUADS` for this — those decks are deliberately authored.
   Live example: the Resonant Chorus batch (icons 208–215) — Zephyr Mender-208,
   Zephyr Mender-209, Cinder Mender-213, and Cinder Mender-214 are reward units with
   `ADDITIONAL_DROPS` entries; the other four carriers are starting Reserves.
   The chassis-synergy promotion pairs (icons 217–224) are all reward units
   with authored `ADDITIONAL_DROPS` entries.

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

- **Add a unit:** author a `_unit(...)` entry in `UnitCatalog._build()`, assign its faction in `FACTION_ICON_IDS`, add or extend original class-atlas art, map a stable art ID in `ICON_ART_IDS` when necessary, regenerate art with `tools/build_original_unit_art.gd`, update exact-count smoke assertions, and run all three tests. Keep every promotion lineage in one faction pool.
- **Add a skill timing:** add a branch in `scripts/unit_skills.gd` and wire it into the battle resolution in `main.gd`. Add an AI consideration in `scripts/battle_ai.gd` if the enemy should use it.
- **Add a Conductor skill:** edit `scripts/conductor_skills.gd`, add the name to `ConductorSkills.SKILLS`, and update the description.
- **Add a mission:** edit `scripts/story_quest_catalog.gd` (`QUESTS`, `ADDITIONAL_DROPS`, `MISSION_ENEMY_SQUADS`), then run `balance_simulation.gd`. New missions must be appended at the end of `QUESTS` — never inserted mid-list — because `ADDITIONAL_DROPS`, `MISSION_ENEMY_SQUADS`, and the balance test all key off mission index. Every mission reward pool must contain at least three 1-star units so 4-star and higher drops stay rare under the weighted roll (`smoke_test.gd` asserts this). Add story text to `MISSION_STORIES` and, when the mission has a character scene, add a 1-based entry to `scripts/story_dialogue_catalog.gd:INTERLUDES`. Follow `documentation/Resonance_War_Campaign_Narrative.md` (the narrative plan) and `documentation/Resonance_War_Narrative_Foundation.md` (the world rules).
- **Edit campaign narrative text:** change `MISSION_STORIES`/`ENCOUNTER_RULES` in `scripts/story_quest_catalog.gd` or `INTERLUDES`/`CHARACTERS` in `scripts/story_dialogue_catalog.gd`, then regenerate the consolidated reading copy `documentation/Campaign_Narrative_Script.md` with `./tools/godot-headless.sh --script res://tools/generate_campaign_narrative.gd`. Never edit the digest directly; it is generated.
- **Change UI theme:** edit `scripts/ui_theme.gd`; the theme is generated programmatically and applied to the root control in `main.gd`.
- **Change audio:** edit `scripts/battle_audio.gd`; the sounds are generated from wave functions.

When in doubt, keep logic in the static helper scripts and keep `main.gd` focused on orchestration and UI state.
