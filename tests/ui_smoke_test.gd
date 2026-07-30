extends SceneTree

const CampaignStoreScript = preload("res://scripts/campaign_store.gd")
const BattleSettingsScript = preload("res://scripts/battle_settings.gd")
const BattleSimulatorScript = preload("res://scripts/battle_simulator.gd")

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
	assert(game.speed_button.text == "SPEED 1×")
	assert(game.audio_button.text == "SOUND 100%")
	assert(game.animation_button.text == "ANIM ON")
	assert(game.motion_button.text == "MOTION FULL")
	assert(game.audio_button.get_parent().get_parent() == game.settings_panel)
	assert(game.speed_button.get_parent().get_parent() == game.settings_panel)
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
	assert(game._resolution_preview(0) == "UPCOMING · No ready units.")
	var preview_unit: Dictionary = game._spawn_unit(game.roster[0], 0, 0, 0)
	var preview_text: String = game._resolution_preview(0)
	assert(preview_text.begins_with("UPCOMING · 1 %s" % preview_unit.name))
	preview_unit.taunt_turns = 2
	preview_unit.immobilized_turns = 1
	preview_unit.fury_stacks = 3
	assert(preview_unit.taunt_turns == 2)
	assert(preview_unit.immobilized_turns == 1)
	assert(preview_unit.fury_stacks == 3)
	game.units.clear()
	game._open_mission_select()
	await process_frame
	assert(game.mission_list.get_child_count() == 62)
	assert(game.campaign_progress_label.text.contains("ACT 1"))
	assert(game.campaign_progress_label.text.contains("ACT 2"))
	var first_entry: VBoxContainer = game.mission_list.get_child(0)
	assert(first_entry.size_flags_horizontal == Control.SIZE_EXPAND_FILL)
	assert(first_entry.get_child(1) is HBoxContainer)
	var result_buttons: Array[Node] = game.overlay.find_children("*", "Button", true, false)
	assert(result_buttons.size() == 3)
	assert(not game.result_continue_button.visible)
	assert(not game.result_menu_button.visible)
	game._show_card_reward("Chain Initiate", true)
	assert(game.reward_reveal.visible)
	assert(game.reward_portrait.texture != null)
	assert(game.reward_stars_label.text == "★")
	assert(game.reward_new_label.visible)
	game._show_card_reward("Chain Initiate", false)
	assert(not game.reward_new_label.visible)
	game.input_enabled = true
	game._open_squad_builder()
	await process_frame
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
	assert(game.result_menu_button.visible)
	assert(not game.result_continue_button.visible)
	game.overlay.visible = false
	game.current_mission_id = 0
	game.completed_missions = [0]
	game.mission_finished = true
	game.recent_reward_name = "Chain Initiate"
	game.overlay.visible = true
	game._continue_campaign()
	assert(not game.overlay.visible)
	assert(game.squad_overlay.visible)
	assert(game.squad_opened_for_mission)
	assert(game.pending_mission_id == 1)
	assert(game.mission_intel_panel.visible)
	assert(game.mission_enemy_preview_row.get_child_count() == 8)
	assert(game.mission_intel_label.text.contains("CAPTAIN:"))
	assert(game.reward_carry_label.visible)
	assert(game.reward_carry_label.text.contains("CHAIN INITIATE"))
	game.squad_overlay.visible = false
	game.squad_opened_for_mission = false
	game.pending_mission_id = -1
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
	print("Skychain UI smoke tests passed.")
	quit()
