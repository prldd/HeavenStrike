extends SceneTree

const CampaignStoreScript = preload("res://scripts/campaign_store.gd")
const BattleSettingsScript = preload("res://scripts/battle_settings.gd")
const BattleSimulatorScript = preload("res://scripts/battle_simulator.gd")
const KineticCrucibleScript = preload("res://scripts/kinetic_crucible.gd")
const UnitCatalogScript = preload("res://scripts/unit_catalog.gd")

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	BattleSettingsScript.save_settings({
		"speed": 1.0,
		"volume": 2,
		"reduced_motion": false,
		"skip_animations": false
	})
	var scene: PackedScene = load("res://main.tscn")
	var game = scene.instantiate()
	root.add_child(game)
	await process_frame
	assert(game.main_menu_overlay.get_child(0) is TextureRect)
	assert(game.main_menu_overlay.get_child(0).texture != null)
	assert(game.squad_overlay.get_child(0) is TextureRect)
	assert(game.squad_overlay.get_child(0).texture != null)
	assert(game.dialogue_overlay.get_child(0) is TextureRect)
	assert(game.dialogue_overlay.get_child(0).texture != null)
	assert(not game.dialogue_overlay.visible)
	assert(game.speed_button.text == "SPEED 1×")
	assert(game.audio_button.text == "SOUND 100%")
	assert(game.animation_button.text == "ANIM ON")
	assert(game.motion_button.text == "MOTION FULL")
	assert(game.audio_button.get_parent().get_parent() == game.settings_panel)
	assert(game.speed_button.get_parent().get_parent() == game.settings_panel)
	assert(not game.has_method("_open_tutorial"))
	for action in game.main_menu_overlay.find_children("*", "Button", true, false):
		assert(action.text != "HOW TO PLAY")
	for action in game.settings_panel.find_children("*", "Button", true, false):
		assert(action.text != "HOW TO PLAY")
	assert(not game.settings_panel.visible)
	game._toggle_settings()
	assert(game.settings_panel.visible)
	game._toggle_settings()
	assert(not game.settings_panel.visible)
	game._toggle_animation_skip()
	assert(game.skip_animations)
	game._toggle_animation_skip()
	assert(not game.skip_animations)
	game._toggle_reduced_motion()
	assert(game.reduced_motion and game.board.reduced_motion)
	assert(is_equal_approx(game._animation_duration(1.0), 2.0))
	game._toggle_reduced_motion()
	assert(not game.reduced_motion and not game.board.reduced_motion)
	assert(game.battle_audio.sounds.size() == 13)
	assert(game.battle_audio.sounds.has("victory"))
	game._cycle_audio()
	assert(game.audio_button.text == "SOUND 50%")
	game._cycle_audio()
	assert(game.audio_button.text == "SOUND OFF")
	game._cycle_audio()
	assert(game.audio_button.text == "SOUND 100%")
	assert(game.end_button.get_parent() == game.board)
	assert(game.end_button.text == "→")
	assert(game.end_button.tooltip_text.contains("Enter"))
	assert(not game.end_button.visible)
	assert(game.win_button.text == "WIN")
	assert(game.win_button.tooltip_text.contains("campaign battle"))
	assert(game.win_button.pressed.is_connected(game._win_campaign_battle))
	assert(not game.win_button.visible)
	assert(game.hand_row.get_child(0).get_theme_stylebox("normal") is StyleBoxFlat)
	game._cycle_resolution_speed()
	assert(game.resolution_speed == 2.0)
	assert(Engine.time_scale == 2.0)
	assert(is_equal_approx(game._animation_duration(1.0), 2.0))
	game._cycle_resolution_speed()
	assert(game.resolution_speed == 4.0)
	assert(Engine.time_scale == 4.0)
	assert(is_equal_approx(game._animation_duration(1.0), 2.0))
	game._cycle_resolution_speed()
	assert(game.resolution_speed == 1.0)
	assert(Engine.time_scale == 1.0)
	assert(is_equal_approx(game._animation_duration(1.0), 2.0))
	assert(game._wait(0.05) is Signal)
	game._cycle_resolution_speed()
	game._cycle_resolution_speed()
	assert(game.resolution_speed == 4.0)
	game._cycle_resolution_speed()
	assert(game.resolution_speed == 1.0)
	assert(game.combat_log_panel != null)
	game.board.set_state(
		[], {}, -1, true, "Choose a target.", [42],
		"2 / 4\n2 LOCKED", "4 / 4\n0 LOCKED",
		"18 HP\n2 SHIELD", "12 HP", "DECK 3", "DECK 2"
	)
	assert(game.board.targetable_unit_ids == [42])
	assert(game.board.player_mana_text == "2 / 4\n2 LOCKED")
	assert(game.board.enemy_mana_text == "4 / 4\n0 LOCKED")
	assert(game.board.player_hp_text == "18 HP\n2 SHIELD")
	assert(game.board.player_deck_text == "DECK 3")
	var board_cell: Rect2 = game.board._cell_rect(0, 0)
	assert(board_cell.size.y > board_cell.size.x)
	assert(is_equal_approx(
		board_cell.size.x / board_cell.size.y,
		game.board.CELL_ASPECT_RATIO
	))
	assert(game.board.has_method("animate_unit_move"))
	assert(game.board.has_method("animate_attack"))
	assert(game.board.has_method("animate_commander_attack"))
	assert(game.board.has_method("animate_heal"))
	assert(game.board.has_method("animate_hit"))
	assert(game.board.has_method("animate_defeat"))
	assert(game.board.has_method("shake"))
	assert(game.board.has_method("set_practice_mode"))
	assert(game.board.has_method("set_opponent_identity"))
	game.board.set_opponent_identity("Minerva", "Grand Circuit Champion")
	assert(game.board.opponent_name == "Minerva")
	assert(game.board.opponent_affiliation == "Grand Circuit Champion")
	game.board.set_opponent_identity("", "")
	game.board.set_practice_mode(true)
	assert(game.board.practice_mode)
	game.board.set_practice_mode(false)
	assert(not game.board.practice_mode)
	assert(game._resolution_preview(0) == "UPCOMING · No ready units.")
	var preview_unit: Dictionary = game._spawn_unit(game.roster[0].to_dict(), 0, 0, 0)
	assert(game.last_deployed_unit_id[0] == preview_unit.id)
	var preview_text: String = game._resolution_preview(0)
	assert(preview_text.begins_with("UPCOMING · 1 %s" % preview_unit.name))
	preview_unit.taunt_turns = 2
	preview_unit.immobilized_turns = 1
	preview_unit.fury_stacks = 3
	assert(preview_unit.taunt_turns == 2)
	assert(preview_unit.immobilized_turns == 1)
	assert(preview_unit.fury_stacks == 3)
	assert(preview_unit.silenced_turns == 0)
	preview_unit.silenced_turns = 2
	assert(preview_unit.silenced_turns == 2)
	assert(preview_unit.summon_forth_turns == 0)
	assert(preview_unit.quiet_triggers_left == 0)
	# Deployment initializes the Quiet! trigger countdown from the rank table.
	var quiet_card: Dictionary = UnitCatalogScript.by_name("Nageki Fujishiro").to_dict()
	var quiet_unit: Dictionary = game._spawn_unit(quiet_card, 0, 1, 0)
	assert(quiet_unit.quiet_triggers_left == 1)
	assert(quiet_unit.summon_forth_turns == 0)
	var summon_card: Dictionary = UnitCatalogScript.by_name("Booth").to_dict()
	var summon_unit: Dictionary = game._spawn_unit(summon_card, 0, 2, 0)
	assert(summon_unit.quiet_triggers_left == 0)
	game.units.clear()
	# A Scout that defeats the final blocking unit with its first Double Strike
	# spends the remaining strike on the newly exposed enemy Conductor.
	game.skip_animations = true
	var scout_card: Dictionary = UnitCatalogScript.by_name("Trinity Rusher").to_dict()
	var scout: Dictionary = game._spawn_unit(scout_card, 0, 0, 5)
	scout.atk = 2
	scout.move = 0
	scout.range = 1
	scout.skill = {}
	var blocker_card: Dictionary = UnitCatalogScript.by_name("Pub Bouncer").to_dict()
	var blocker: Dictionary = game._spawn_unit(blocker_card, 1, 0, 6)
	blocker.hp = 1
	blocker.max_hp = 1
	blocker.skill = {}
	game.enemy_hp = 20
	game.battle_simulator.events.clear()
	game._refresh()
	await game._activate_unit(scout)
	assert(game._unit_by_id(blocker.id) == null)
	assert(game.enemy_hp == 18)
	assert(game.battle_simulator.events.filter(
		func(event): return event.type == "commander_attack"
	).size() == 1)
	game.units.clear()
	game.skip_animations = false
	game._open_mission_select()
	# The mission list builds progressively over several frames on open.
	# 77 mission rows plus 15 chapter header labels.
	var wait_frames := 0
	while game.mission_list.get_child_count() < 92 and wait_frames < 120:
		await process_frame
		wait_frames += 1
	assert(game.mission_list.get_child_count() == 92)
	assert(game.campaign_progress_label.text.contains("ACT 1"))
	assert(game.campaign_progress_label.text.contains("ACT 2"))
	assert(game.campaign_progress_label.text.contains("ACT 3"))
	var first_header: Label = game.mission_list.get_child(0)
	assert(first_header.text == "ACT 1 · THE SALVAGE")
	var chapter_headers := 0
	for child in game.mission_list.get_children():
		if child is Label:
			chapter_headers += 1
	assert(chapter_headers == 15)
	var first_entry: VBoxContainer = game.mission_list.get_child(1)
	assert(first_entry.size_flags_horizontal == Control.SIZE_EXPAND_FILL)
	assert(first_entry.get_child(1) is HBoxContainer)
	var result_buttons: Array[Node] = game.overlay.find_children("*", "Button", true, false)
	assert(result_buttons.size() == 3)
	assert(game.result_primary_button.get_index() < game.result_continue_button.get_index())
	game._emphasize_result_action(game.result_continue_button)
	assert(game.result_continue_button.has_theme_stylebox_override("normal"))
	assert(not game.result_primary_button.has_theme_stylebox_override("normal"))
	assert(game.get_viewport().gui_get_focus_owner() == game.result_continue_button)
	assert(game.overlay_detail.get_parent() is ScrollContainer)
	assert(game.overlay_detail.autowrap_mode == TextServer.AUTOWRAP_WORD_SMART)
	assert(game.overlay_detail.text_overrun_behavior == TextServer.OVERRUN_NO_TRIMMING)
	assert(game.overlay_detail.mouse_filter == Control.MOUSE_FILTER_IGNORE)
	assert(not game.result_continue_button.visible)
	assert(not game.result_menu_button.visible)
	game._show_card_reward("Chain Initiate", true)
	assert(game.reward_reveal.visible)
	assert(game.reward_portrait.texture != null)
	assert(game.reward_stars_label.text == "★")
	assert(game.reward_new_label.visible)
	game._show_card_reward("Chain Initiate", false)
	assert(not game.reward_new_label.visible)
	game._open_kinetic_crucible()
	await process_frame
	var crucible_units: Array = KineticCrucibleScript.active_instances(
		game.collection_instances
	)
	# EXTRAS ONLY hides the two highest-level copies of each unit name.
	var names_seen := {}
	var protected_count := 0
	for instance in crucible_units:
		names_seen[instance.name] = names_seen.get(instance.name, 0) + 1
	for copy_count in names_seen.values():
		protected_count += mini(2, copy_count)
	assert(
		game.crucible_reserve_grid.get_child_count()
		== crucible_units.size() - protected_count
	)
	game.crucible_extras_toggle.button_pressed = false
	assert(game.crucible_reserve_grid.get_child_count() == crucible_units.size())
	# Class filter and name search narrow the crucible reserves list.
	game.crucible_class_option.select(1)
	game.crucible_class_option.item_selected.emit(1)
	var filter_kind: String = game.crucible_class_option.get_item_metadata(1)
	var expected_in_class := 0
	for instance in crucible_units:
		if UnitCatalogScript.by_name(instance.name).kind == filter_kind:
			expected_in_class += 1
	assert(game.crucible_reserve_grid.get_child_count() == expected_in_class)
	game.crucible_class_option.select(0)
	game.crucible_class_option.item_selected.emit(0)
	assert(game.crucible_reserve_grid.get_child_count() == crucible_units.size())
	var search_term: String = crucible_units[0].name
	game.crucible_search_edit.text_changed.emit(search_term)
	var expected_in_search := 0
	for instance in crucible_units:
		if instance.name.to_lower().contains(search_term.to_lower()):
			expected_in_search += 1
	assert(game.crucible_reserve_grid.get_child_count() == expected_in_search)
	game.crucible_search_edit.text_changed.emit("")
	assert(game.crucible_reserve_grid.get_child_count() == crucible_units.size())
	assert(game.crucible_target_grid.get_child_count() == 1)
	game._select_crucible_unit(crucible_units[0].id)
	assert(game.crucible_target_id == crucible_units[0].id)
	assert(game.crucible_target_grid.get_child_count() == 1)
	game._select_crucible_unit(crucible_units[1].id)
	game._select_crucible_unit(crucible_units[2].id)
	assert(game.crucible_donor_ids.size() == 2)
	assert(game.crucible_donor_grid.get_child_count() == 2)
	game._remove_crucible_donor(crucible_units[1].id)
	assert(game.crucible_donor_ids.size() == 1)
	game._clear_crucible_target()
	assert(game.crucible_target_id.is_empty())
	assert(game.crucible_donor_ids.is_empty())
	assert(game.crucible_promote_button.disabled)
	# EXTRAS ONLY protects the two highest-level copies, exposing the lowest.
	var extras_config := ConfigFile.new()
	extras_config.set_value("meta", "instances_migrated", true)
	extras_config.set_value("collection", "next_id", 4)
	extras_config.set_value("collection", "instances", [
		{
			"id": "unit_000001", "name": "Apprentice Builder",
			"level": 1, "points": 0, "consumed": false
		},
		{
			"id": "unit_000002", "name": "Apprentice Builder",
			"level": 5, "points": 0, "consumed": false
		},
		{
			"id": "unit_000003", "name": "Apprentice Builder",
			"level": 3, "points": 0, "consumed": false
		}
	])
	extras_config.save(KineticCrucibleScript.SAVE_PATH)
	game.crucible_extras_toggle.button_pressed = true
	game._open_kinetic_crucible()
	await process_frame
	var visible_ids: Array = []
	for card in game.crucible_reserve_grid.get_children():
		visible_ids.append(card.unit_name)
	assert("unit_000001" in visible_ids)
	assert("unit_000002" not in visible_ids)
	assert("unit_000003" not in visible_ids)
	game.crucible_extras_toggle.button_pressed = false
	visible_ids = []
	for card in game.crucible_reserve_grid.get_children():
		visible_ids.append(card.unit_name)
	assert("unit_000002" in visible_ids and "unit_000003" in visible_ids)
	# Promotion: a level-5 copy with an implemented next form can be promoted.
	var promo_config := ConfigFile.new()
	promo_config.set_value("meta", "instances_migrated", true)
	promo_config.set_value("collection", "next_id", 2)
	promo_config.set_value("collection", "instances", [
		{
			"id": "unit_000001", "name": "Apprentice Builder",
			"level": 5, "points": 0, "consumed": false
		}
	])
	promo_config.save(KineticCrucibleScript.SAVE_PATH)
	game._open_kinetic_crucible()
	await process_frame
	game._select_crucible_unit("unit_000001")
	assert(game.crucible_target_id == "unit_000001")
	assert(not game.crucible_promote_button.disabled)
	assert(game.crucible_detail_label.text.contains("MASTER BUILDER"))
	game._promote_crucible_unit()
	var promoted_copy := KineticCrucibleScript.instance_by_id(
		game.collection_instances, "unit_000001"
	)
	assert(promoted_copy.name == "Master Builder")
	assert(promoted_copy.level == 1 and promoted_copy.points == 0)
	assert(game.crucible_notice.contains("promoted"))
	assert(game.crucible_promote_button.disabled)
	# Restore a fresh collection so later runs are unaffected.
	DirAccess.remove_absolute(ProjectSettings.globalize_path(KineticCrucibleScript.SAVE_PATH))
	game._show_main_menu()
	game.input_enabled = true
	game._open_squad_builder()
	await process_frame
	for action in game.squad_overlay.find_children("*", "Button", true, false):
		assert(action.text != "RESET")
	var inventory: Dictionary = CampaignStoreScript.inventory_counts(
		game.roster, game.earned_reward_units
	)
	var owned_types := 0
	for count in inventory.values():
		if count > 0:
			owned_types += 1
	assert(game.squad_grid.get_child_count() == owned_types)
	assert(game.squad_grid.get_child(0).get_theme_stylebox("normal") is StyleBoxFlat)
	assert(game.squad_selection_grid.get_child_count() == game.editing_squad_names.size())
	# Class filter and name search narrow the squad builder reserves list.
	var squad_active := KineticCrucibleScript.active_instances(game.collection_instances)
	game.reserve_class_option.select(1)
	game.reserve_class_option.item_selected.emit(1)
	var squad_filter_kind: String = game.reserve_class_option.get_item_metadata(1)
	var expected_squad_in_class := 0
	for instance in squad_active:
		if UnitCatalogScript.by_name(instance.name).kind == squad_filter_kind:
			expected_squad_in_class += 1
	assert(game.squad_grid.get_child_count() == expected_squad_in_class)
	game.reserve_class_option.select(0)
	game.reserve_class_option.item_selected.emit(0)
	assert(game.squad_grid.get_child_count() == owned_types)
	var search_instance := KineticCrucibleScript.instance_by_id(
		game.collection_instances, game.squad_grid.get_child(0).unit_name
	)
	game.reserve_search_edit.text_changed.emit(search_instance.name)
	var expected_squad_in_search := 0
	for instance in squad_active:
		if instance.name.to_lower().contains(search_instance.name.to_lower()):
			expected_squad_in_search += 1
	assert(game.squad_grid.get_child_count() == expected_squad_in_search)
	game.reserve_search_edit.text_changed.emit("")
	assert(game.squad_grid.get_child_count() == owned_types)
	var previous_size: int = game.editing_squad_names.size()
	game._remove_squad_unit_at(0)
	assert(game.editing_squad_names.size() == previous_size - 1)
	var add_name: String = game.squad_grid.get_child(0).unit_name
	game._on_squad_drop(add_name, "barracks", "squad")
	assert(game.editing_squad_names.count(add_name) <= 2)
	if game.editing_squad_names.size() > 1:
		var previous_vanguard: String = game.editing_squad_names[0]
		game._set_vanguard(1)
		assert(game.editing_squad_names[1] == previous_vanguard)
	game.campaign_battle = false
	game.player_hp = 20
	game.enemy_hp = 0
	assert(game._check_game_over())
	assert(game.result_primary_button.text == "PLAY AGAIN")
	assert(game.result_primary_button.has_theme_stylebox_override("normal"))
	assert(not game.result_continue_button.has_theme_stylebox_override("normal"))
	assert(game.result_menu_button.visible)
	assert(not game.result_continue_button.visible)
	assert(not game.win_button.visible)
	game.battle_over = false
	game.input_enabled = true
	game.campaign_battle = true
	game.main_menu_overlay.visible = false
	game.mission_overlay.visible = false
	game._refresh()
	assert(game.win_button.visible)
	game.campaign_battle = false
	game._refresh()
	assert(not game.win_button.visible)
	game.overlay.visible = false
	game.current_mission_id = 0
	game.completed_missions = [0]
	game.mission_finished = true
	game.mission_interlude_pending = true
	game.recent_reward_name = "Chain Initiate"
	game.overlay.visible = true
	game.squad_overlay.visible = false
	game._continue_campaign()
	assert(not game.overlay.visible)
	assert(game.dialogue_overlay.visible)
	assert(not game.mission_overlay.visible)
	assert(game.dialogue_scene_title.text == "A Useful Kind of Impossible")
	assert(game.dialogue_speaker_label.text == "Cassian")
	assert(game.dialogue_progress_label.text == "1  /  4")
	game._advance_interlude()
	assert(game.dialogue_speaker_label.text == "Conductor")
	game._finish_interlude()
	assert(not game.dialogue_overlay.visible)
	assert(game.mission_overlay.visible)
	assert(not game.squad_overlay.visible)
	await process_frame
	var view_scene_button: Button = null
	for candidate in game.mission_list.find_children("*", "Button", true, false):
		if candidate.text == "VIEW SCENE":
			view_scene_button = candidate
			break
	assert(view_scene_button != null)
	view_scene_button.pressed.emit()
	assert(game.dialogue_overlay.visible)
	assert(not game.mission_overlay.visible)
	game._finish_interlude()
	assert(game.mission_overlay.visible)
	await process_frame
	var next_mission_button: Button = null
	for candidate in game.mission_list.find_children("*", "Button", true, false):
		if candidate.text.contains("MISSION 02"):
			next_mission_button = candidate
			break
	assert(next_mission_button != null)
	assert(next_mission_button.text.contains(CampaignStoreScript.MISSIONS[1].briefing))
	next_mission_button.pressed.emit()
	assert(not game.mission_overlay.visible)
	assert(game.squad_overlay.visible)
	assert(game.squad_opened_for_mission)
	assert(game.pending_mission_id == 1)
	for action in game.squad_overlay.find_children("*", "Button", true, false):
		assert(action.text != "RESET")
	assert(game.mission_intel_panel.visible)
	assert(game.mission_enemy_preview_row.get_child_count() == 8)
	assert(game.mission_intel_label.text.contains("CAPTAIN:"))
	assert(game.mission_intel_label.text.contains("OPPONENT: RELAY DRILL TEAM"))
	assert(game.mission_intel_label.text.contains("RECLAMATION EXPEDITION"))
	assert(game.mission_intel_stats_label.text.contains("AVG MANA"))
	assert(game.mission_intel_stats_label.text.contains("RECOMMENDED"))
	assert(game.mission_intel_stats_label.text.contains("×"))
	assert(game.reward_carry_label.visible)
	assert(game.reward_carry_label.text.contains("CHAIN INITIATE"))
	game.squad_overlay.visible = false
	game.squad_opened_for_mission = false
	game.pending_mission_id = -1
	game.completed_missions = []
	for mission_id in 61:
		game.completed_missions.append(mission_id)
	assert(game._latest_campaign_mission_id() == 61)
	game._open_mission_select()
	for frame in 16:
		await process_frame
	assert(game.mission_scroll.scroll_vertical > 0)
	var frontier_button: Button = null
	for candidate in game.mission_list.find_children("*", "Button", true, false):
		if candidate.text.contains("ACT 2 · MISSION 40"):
			frontier_button = candidate
			break
	assert(frontier_button != null)
	assert(frontier_button.get_global_rect().intersects(game.mission_scroll.get_global_rect()))
	game.mission_overlay.visible = false
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://replay_history.json"))
	var older_replay := BattleSimulatorScript.new()
	older_replay.reset(555)
	older_replay.record("battle_started", {"player_hp": 20, "enemy_hp": 20})
	older_replay.record("battle_finished", {
		"winner": 0, "player_hp": 20, "enemy_hp": 20
	})
	assert(older_replay.archive_replay("user://replay_history.json"))
	var replay := BattleSimulatorScript.new()
	replay.reset(777)
	replay.record("battle_started", {
		"player_hp": 20,
		"enemy_hp": 20,
		"player_squad": ["Trinity Rusher", "Pub Bouncer"],
		"enemy_squad": ["Chain Initiate", "Socialite Fencer"]
	})
	replay.record("deploy", {
		"side": 0, "unit_id": 1, "card": "Trinity Rusher", "row": 1
	})
	replay.record("battle_finished", {
		"winner": 0, "player_hp": 20, "enemy_hp": 20
	})
	assert(replay.save_replay("user://last_replay.json"))
	assert(replay.archive_replay("user://replay_history.json"))
	game._show_main_menu()
	assert(not game.replay_button.disabled)
	game._open_last_replay()
	assert(game.replay_panel.visible)
	assert(not game.menu_button.visible)
	assert(not game.end_button.visible)
	assert(not game.power_button.visible)
	assert(game.speed_button.visible)
	assert(game.replay_panel.get_child(0).get_child(0).get_child(0).text == "MENU")
	game._open_squad_builder()
	assert(game.replay_squad_overlay.visible)
	assert(game.replay_player_squad_grid.get_child_count() == 2)
	assert(game.replay_enemy_squad_grid.get_child_count() == 2)
	game._close_replay_squads()
	assert(not game.replay_squad_overlay.visible)
	await game._apply_next_replay_event()
	await game._apply_next_replay_event()
	assert(game.units.size() == 1)
	assert(game.replay_timeline_label.text.contains("SEED 777"))
	assert(game.replay_timeline_label.text.contains("REPLAY 1 / 2"))
	assert(game.replay_event_label.text == "EVENT 2 / 3")
	assert(not game.replay_previous_button.disabled)
	assert(game.replay_next_button.disabled)
	await game._apply_next_replay_event()
	assert(game.status_message.contains("verified"))
	game._open_older_replay()
	assert(game.replay_timeline_label.text.contains("SEED 555"))
	assert(game.replay_previous_button.disabled)
	assert(not game.replay_next_button.disabled)
	game._open_newer_replay()
	assert(game.replay_timeline_label.text.contains("SEED 777"))
	game._close_replay()
	assert(game.menu_button.visible)
	assert(not game.end_button.visible)
	assert(game.power_button.visible)
	await create_timer(0.05).timeout
	game.queue_free()
	await process_frame
	await process_frame
	print("Aether Engine UI smoke tests passed.")
	quit()
