# Aether Engine Tactics — Agent Guide

This guide is written for AI coding agents. It describes the project layout, build and test workflows, code conventions, and architectural boundaries so an agent can make safe, useful changes without guessing.

## Project overview

Aether Engine Tactics is a Godot 4 prototype of a lane-based, turn-based tactical RPG. The player builds a squad of up to eight units, deploys them onto a 3×7 board, and resolves battles automatically. The project contains a playable campaign, practice mode, squad builder, Kinetic Crucible progression, enemy AI, deterministic replay history, and synthesized battle audio.

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
| `unit_catalog.gd` | Authoritative unit roster: 82 units as `UnitData` Resources with stats, class, skills, star rarity, and portrait/full-body art IDs. |
| `resources/unit_data.gd` | `UnitData` Resource: one catalog unit's stats, class, promotion, and skill. `to_dict()` bridges to the card Dictionary shape. |
| `resources/skill_data.gd` | `SkillData` Resource: a secondary skill's name, timing type, optional trigger chance, and description. |
| `unit_skills.gd` | Static resolution of secondary unit skills: Warcry, Chant, Strike, and Reaction timing hooks, plus status effect helpers. |
| `captain_skills.gd` | Static resolution of the eight Commander powers and effect expiration. |
| `squad_store.gd` | Squad persistence (names or instance IDs), validation, default squads, shuffling, and Captain-skill storage. |
| `campaign_store.gd` | Campaign completion, reward pools, reward roll logic, and enemy squad lookup per mission/encounter. |
| `story_quest_catalog.gd` | Builds the 62-mission campaign from reference quest data, reward pools, authored enemy decks, and Captain configurations. |
| `mission_run_store.gd` | In-progress multi-encounter mission run state (current mission, encounter index, carried Captain HP). |
| `kinetic_crucible.gd` | Per-copy unit progression: levels 1–5, merge point values, donor rules, inventory sync, and migration from older name-based saves. |
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
- **Simulation vs. presentation:** keep deterministic combat rules in `BattleSimulator`, `BattleRules`, `BattleAI`, `UnitSkills`, and `CaptainSkills`. Keep drawing, animation, audio, and input in `BoardView` and `main.gd`. Do not add combat logic to `BoardView`.
- **Unit data as Resources:** the catalog (`UnitCatalog`) returns `UnitData`/`SkillData` Resources built once in code; `by_name()` returns `null` when a unit is missing. New units belong in the `_unit(...)` list in `UnitCatalog._build()`. Deck/hand cards and runtime battle units remain plain Dictionaries — cards are produced via `UnitData.to_dict()` plus per-instance keys in `SquadStore.build_deck`, and `main.gd:_spawn_unit` builds runtime instances from cards. Any new secondary skill needs a matching resolution branch in `UnitSkills` and an AI consideration in `BattleAI` if relevant.
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
- Background images are at the repository root under `assets/` (e.g. `board-steampunk-courtyard.png`, `main-menu-steampunk-deck.png`).

Do not add external audio files. Audio is synthesized in `battle_audio.gd`.

## Testing strategy

1. Run the three headless scripts above.
2. After UI changes, run `ui_smoke_test.gd` and then do a manual visual pass at the target 1280×720 window size.
3. When adding units or changing campaign data, run `balance_simulation.gd` to avoid breaking the difficulty curve assertion (`largest_difficulty_jump <= 0.18`).
4. `smoke_test.gd` is the broad safety net; it asserts exact counts (82 units, 12/14/25/19/12 star distribution, 37 promotions, 13 audio sounds, etc.), so expect to update it when intentionally expanding the roster.

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

## Common tasks

- **Add a unit:** add a `_unit(...)` entry to `UnitCatalog._build()` in `scripts/unit_catalog.gd`, add portrait/full-body art to `assets/units/`, map the art ID in `ICON_ART_IDS`, update `smoke_test.gd` counts if intentional, and run the three tests.
- **Add a skill timing:** add a branch in `scripts/unit_skills.gd` and wire it into the battle resolution in `main.gd`. Add an AI consideration in `scripts/battle_ai.gd` if the enemy should use it.
- **Add a Captain skill:** edit `scripts/captain_skills.gd`, add the name to `CaptainSkills.SKILLS`, and update the description.
- **Add a mission:** edit `scripts/story_quest_catalog.gd` (`QUESTS`, `ADDITIONAL_DROPS`, `MISSION_ENEMY_SQUADS`), then run `balance_simulation.gd`.
- **Change UI theme:** edit `scripts/ui_theme.gd`; the theme is generated programmatically and applied to the root control in `main.gd`.
- **Change audio:** edit `scripts/battle_audio.gd`; the sounds are generated from wave functions.

When in doubt, keep logic in the static helper scripts and keep `main.gd` focused on orchestration and UI state.
