extends SceneTree

const CampaignStoreScript = preload("res://scripts/campaign_store.gd")
const BattleSettingsScript = preload("res://scripts/battle_settings.gd")
const BattleSimulatorScript = preload("res://scripts/battle_simulator.gd")
const BattleRulesScript = preload("res://scripts/battle_rules.gd")
const KineticCrucibleScript = preload("res://scripts/kinetic_crucible.gd")
const GachaStoreScript = preload("res://scripts/gacha_store.gd")
const RequisitionStoreScript = preload("res://scripts/requisition_store.gd")
const MissionRunStoreScript = preload("res://scripts/mission_run_store.gd")
const TutorialStoreScript = preload("res://scripts/tutorial_store.gd")
const UnitCatalogScript = preload("res://scripts/unit_catalog.gd")

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	DirAccess.remove_absolute(ProjectSettings.globalize_path(KineticCrucibleScript.SAVE_PATH))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(TutorialStoreScript.SAVE_PATH))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(CampaignStoreScript.SAVE_PATH))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(GachaStoreScript.SAVE_PATH))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(RequisitionStoreScript.SAVE_PATH))
	BattleSettingsScript.save_settings({
		"speed": 1.0,
		"volume": 2,
		"reduced_motion": false,
		"skip_animations": false
	})
	assert(not TutorialStoreScript.is_completed())
	var scene: PackedScene = load("res://main.tscn")
	var game = scene.instantiate()
	root.add_child(game)
	await process_frame
	assert(game.main_menu_overlay.visible)
	assert(not game.tutorial_mode)
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
	assert(game.LOSS_TITLE == "TACTICAL DEFEAT")
	assert(game.LOSS_DETAIL == "Your Conductor was defeated.\nRetry the battle with a new tactical approach.")
	var retired_leader_term := "Cap" + "tain"
	assert(game._canonical_replay_text(
		"Enemy " + retired_leader_term + " loses 3 HP."
	) == "Enemy Conductor loses 3 HP.")
	assert(game.audio_button.get_parent().get_parent() == game.settings_panel)
	assert(game.speed_button.get_parent().get_parent() == game.settings_panel)
	assert(game.has_method("_begin_tutorial"))
	var tutorial_menu_found := false
	for action in game.main_menu_overlay.find_children("*", "Button", true, false):
		if action.text == "GUIDED TUTORIAL":
			tutorial_menu_found = true
	assert(tutorial_menu_found)
	var main_menu_plaques: Array[Node] = game.main_menu_overlay.find_children(
		"*", "PanelContainer", true, false
	)
	assert(main_menu_plaques.size() == 1)
	assert(main_menu_plaques[0].get_global_rect().end.y <= game.get_viewport_rect().end.y)
	assert(not game.tutorial_panel.visible)
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
	assert(game.command_dock.is_ancestor_of(game.end_button))
	assert(game.command_dock.is_ancestor_of(game.hand_row))
	assert(game.command_dock.is_ancestor_of(game.power_button))
	assert(game.command_bridge.is_ancestor_of(game.turn_label))
	assert(game.command_bridge.is_ancestor_of(game.hint_label))
	assert(game.end_button.text == "END TURN")
	assert(game.end_button.tooltip_text.contains("Enter"))
	assert(not game.end_button.visible)
	for action in game.find_children("*", "Button", true, false):
		assert(action.text != "SQUAD")
	assert(game.win_button.text == "WIN")
	assert(game.win_button.tooltip_text.contains("campaign battle"))
	assert(game.win_button.pressed.is_connected(game._win_campaign_battle))
	assert(not game.win_button.visible)
	assert(game.hand_row.get_child(0).get_theme_stylebox("normal") is StyleBoxFlat)
	game.skip_animations = true
	game.board.idle_animation_enabled = false
	game._begin_tutorial()
	assert(game.tutorial_mode)
	assert(game.tutorial_step == game.TUTORIAL_INTRO)
	assert(game.tutorial_panel.visible)
	assert(game.tutorial_continue_button.has_meta("tutorial_pulse"))
	assert(not game.tutorial_menu_button.visible)
	assert(game.player_conductor_skill == "Rally")
	assert(game.player_hand[0].name == game.TUTORIAL_UNIT_NAME)
	assert(game.enemy_hp == game.TUTORIAL_ENEMY_HP)
	var tutorial_target = game.units.filter(
		func(unit): return unit.side == game.ENEMY and unit.name == game.TUTORIAL_TARGET_NAME
	).front()
	assert(tutorial_target.row == game.TUTORIAL_DEPLOYMENT_ROW)
	assert(tutorial_target.col == game.TUTORIAL_TARGET_COL)
	assert(tutorial_target.hp == 4)
	game._on_tutorial_continue()
	assert(game.tutorial_step == game.TUTORIAL_SELECT_CARD)
	assert(not game.tutorial_menu_button.visible)
	var tutorial_card_index := -1
	for index in game.player_hand.size():
		if game.player_hand[index].name == game.TUTORIAL_UNIT_NAME:
			tutorial_card_index = index
			break
	assert(tutorial_card_index >= 0)
	var tutorial_card_button: Button = game.hand_row.get_child(tutorial_card_index)
	assert(tutorial_card_button.has_meta("tutorial_pulse"))
	game.skip_animations = false
	game._apply_tutorial_button_pulse(tutorial_card_button, 1.0)
	assert(tutorial_card_button.scale == Vector2.ONE)
	assert(tutorial_card_button.modulate != Color.WHITE)
	game.skip_animations = true
	assert(not game.tutorial_continue_button.has_meta("tutorial_pulse"))
	game._select_card(tutorial_card_index)
	assert(game.tutorial_step == game.TUTORIAL_DEPLOY)
	assert(game.board.guided_deployment_row == game.TUTORIAL_DEPLOYMENT_ROW)
	assert(game.board._has_guidance_pulse())
	await game._on_deployment_clicked(game.TUTORIAL_DEPLOYMENT_ROW)
	assert(game.tutorial_step == game.TUTORIAL_MANA)
	assert(game.tutorial_continue_button.has_meta("tutorial_pulse"))
	assert(game.player_energy == 0)
	assert(game.BattleRulesScript.locked_mana(game.units, game.PLAYER) == 2)
	game._on_tutorial_continue()
	assert(game.tutorial_step == game.TUTORIAL_RESOLVE)
	assert(not game.end_button.disabled)
	assert(game.end_button.has_meta("tutorial_pulse"))
	await game._end_player_turn()
	assert(game.round_number == 2)
	assert(game.tutorial_step == game.TUTORIAL_SELECT_UNIT)
	assert(not game.units.any(func(unit): return unit.id == tutorial_target.id))
	assert(game.enemy_hp == game.TUTORIAL_ENEMY_HP)
	assert(game.battle_simulator.events.filter(
		func(event): return event.type == "attack" and event.target_id == tutorial_target.id
	).size() == 2)
	assert(game.board.guided_target_pulse)
	var tutorial_unit = game._tutorial_unit()
	assert(tutorial_unit != null)
	assert(tutorial_unit.col == 3)
	assert(tutorial_unit.hp == 1)
	assert(tutorial_unit.get("taunt_turns", 0) == 0)
	var tutorial_reinforcement = game.units.filter(
		func(unit): return (
			unit.side == game.ENEMY and unit.name == game.TUTORIAL_REINFORCEMENT_NAME
		)
	).front()
	assert(tutorial_reinforcement.row == game.TUTORIAL_DEPLOYMENT_ROW)
	assert(tutorial_reinforcement.col == 4)
	assert(tutorial_reinforcement.kind == "Duelist")
	assert(game.battle_simulator.events.filter(
		func(event): return (
			event.type == "attack" and event.actor_id == tutorial_reinforcement.id
			and event.target_id == tutorial_unit.id
		)
	).size() == 1)
	await game._on_board_cell_clicked(tutorial_unit.row, tutorial_unit.col)
	assert(game.tutorial_step == game.TUTORIAL_REPOSITION)
	assert(game.board.guided_reposition_row == game.TUTORIAL_REPOSITION_ROW)
	assert(game.board._has_guidance_pulse())
	await game._on_board_cell_clicked(game.TUTORIAL_REPOSITION_ROW, tutorial_unit.col)
	assert(tutorial_unit.row == game.TUTORIAL_REPOSITION_ROW)
	assert(game.tutorial_step == game.TUTORIAL_POWER)
	assert(not game.power_button.disabled)
	assert(game.power_button.has_meta("tutorial_pulse"))
	await game._use_player_power()
	assert(game.player_power_used)
	assert(tutorial_unit.atk == 3)
	assert(game.tutorial_step == game.TUTORIAL_FINAL_RESOLVE)
	assert(not game.end_button.disabled)
	assert(game.end_button.has_meta("tutorial_pulse"))
	await game._end_player_turn()
	assert(game.enemy_hp == 0)
	assert(game.battle_over)
	assert(not game.overlay.visible)
	assert(tutorial_unit.col == 5)
	assert(game.battle_simulator.events.filter(
		func(event): return event.type == "commander_attack" and event.side == game.ENEMY
	).size() == 2)
	assert(game.tutorial_step == game.TUTORIAL_COMPLETE)
	assert(not game.tutorial_continue_button.visible)
	assert(game.tutorial_menu_button.visible)
	assert(game.tutorial_menu_button.text.is_empty())
	assert(game.tutorial_menu_button.icon != null)
	assert(game.tutorial_menu_button.has_meta("tutorial_pulse"))
	game._finish_tutorial_to_menu()
	assert(not game.tutorial_mode)
	assert(game.tutorial_pulse_buttons.is_empty())
	assert(not game.board._has_guidance_pulse())
	assert(game.main_menu_overlay.visible)
	game.skip_animations = false
	game.board.idle_animation_enabled = true
	game.units.clear()
	game._refresh()
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
	var board_cell_shape: PackedVector2Array = game.board._cell_polygon(0, 0)
	assert(board_cell.size.x > 0.0 and board_cell.size.y > 0.0)
	assert(board_cell_shape.size() == 4)
	assert((board_cell_shape[1] - board_cell_shape[0]).length()
		< (board_cell_shape[2] - board_cell_shape[3]).length())
	assert(game.board._cell_at(board_cell.get_center()) == Vector2i(0, 0))
	assert(game.board.UNIT_ART_CELL_SCALE > 1.0)
	var overlap_hit_unit := {"id": 99, "row": 1, "col": 3}
	game.board.units = [overlap_hit_unit]
	var overlap_art: Rect2 = game.board._unit_art_rect(overlap_hit_unit)
	assert(game.board._unit_at_point(
		Vector2(overlap_art.get_center().x, overlap_art.position.y + 4)
	).id == 99)
	game.board.selected_unit_id = 99
	var reposition_clicks: Array[Vector2i] = []
	var capture_reposition_click := func(row: int, col: int):
		reposition_clicks.append(Vector2i(col, row))
	game.board.board_cell_clicked.connect(capture_reposition_click)
	var lane_change_event := InputEventMouseButton.new()
	lane_change_event.button_index = MOUSE_BUTTON_LEFT
	lane_change_event.pressed = true
	lane_change_event.position = game.board._cell_rect(0, 3).get_center()
	game.board._gui_input(lane_change_event)
	assert(reposition_clicks == [Vector2i(3, 0)])
	game.board.board_cell_clicked.disconnect(capture_reposition_click)
	game.board.selected_unit_id = -1
	game.board.units = []
	assert(game.board.has_method("animate_unit_move"))
	assert(game.board.has_method("animate_attack"))
	assert(game.board.has_method("animate_commander_attack"))
	assert(game.board.has_method("attack_effect_cells"))
	assert(game.board.has_method("animate_heal"))
	assert(game.board.has_method("animate_hit"))
	assert(game.board.has_method("animate_hits"))
	assert(game.board.has_method("animate_defeat"))
	assert(game.board.has_method("shake"))
	assert(game.board.has_method("set_practice_mode"))
	assert(game.board.has_method("set_campaign_mission"))
	assert(game.board.has_method("set_opponent_identity"))
	# Rail Volley crosses every authored range cell. Arc Burst stages its primary
	# explosion and adjacent blasts without exposing those cells as board UI.
	var ranged_visual_actor := {
		"id": 501, "side": 0, "row": 1, "col": 1, "range": 3
	}
	var ranged_visual_target := {"id": 502, "side": 1, "row": 1, "col": 3}
	assert(game.board.attack_effect_cells(
		ranged_visual_actor, ranged_visual_target, "Artillerist"
	) == [Vector2i(2, 1), Vector2i(3, 1), Vector2i(4, 1)])
	assert(game.board.attack_effect_cells(
		ranged_visual_actor, ranged_visual_target, "Channeler"
	) == [
		Vector2i(3, 1), Vector2i(2, 1), Vector2i(4, 1),
		Vector2i(3, 0), Vector2i(3, 2)
	])
	game._set_board_opponent({
		"opponent_name": "Asha Vale",
		"opponent_affiliation": "Grand Circuit Champion",
	})
	assert(game.board.opponent_name == "Asha Vale")
	assert(game.board.opponent_affiliation == "Grand Circuit Champion")
	assert(game.opponent_button.text.contains("ASHA VALE"))
	# Hovering the command-bridge opponent readout shows the win conditions.
	var opponent_hover_log: Array = []
	game.opponent_button.mouse_entered.connect(func(): opponent_hover_log.append("enter"))
	game.opponent_button.mouse_exited.connect(func(): opponent_hover_log.append("exit"))
	game.opponent_button.mouse_entered.emit()
	assert(game.hover_card.visible)
	assert(game.hover_name_label.text == "WIN CONDITIONS")
	assert(game.hover_ability_label.text.contains("Conductor"))
	game.opponent_button.mouse_exited.emit()
	assert(opponent_hover_log == ["enter", "exit"])
	assert(not game.hover_card.visible)
	game.board.set_opponent_identity("", "")
	game.board.set_practice_mode(true)
	assert(game.board.practice_mode)
	assert(game.board.background_stage == game.board.STAGE_TRAINING)
	game.board.set_practice_mode(false)
	assert(not game.board.practice_mode)
	assert(game.board.background_stage == game.board.STAGE_RELAY)
	game.board.set_campaign_mission(14)
	assert(game.board.background_stage == game.board.STAGE_PROVING)
	game.board.set_campaign_mission(29)
	assert(game.board.background_stage == game.board.STAGE_FACTION)
	game.board.set_campaign_mission(45)
	assert(game.board.background_stage == game.board.STAGE_COALITION)
	game.board.set_campaign_mission(62)
	assert(game.board.background_stage == game.board.STAGE_CAELIS)
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
	# Deployment initializes the Silent Cycle trigger countdown from the rank table.
	var quiet_card: Dictionary = UnitCatalogScript.by_name("Flux Mender-195").to_dict()
	var quiet_unit: Dictionary = game._spawn_unit(quiet_card, 0, 1, 0)
	assert(quiet_unit.quiet_triggers_left == 1)
	assert(quiet_unit.summon_forth_turns == 0)
	var summon_card: Dictionary = UnitCatalogScript.by_name("Cinder Battery-190").to_dict()
	var summon_unit: Dictionary = game._spawn_unit(summon_card, 0, 2, 0)
	assert(summon_unit.quiet_triggers_left == 0)
	game.units.clear()
	# A Scout that defeats the final blocking unit with its first Twin Actuator strike
	# spends the remaining strike on the newly exposed enemy Conductor.
	game.skip_animations = true
	var scout_card: Dictionary = UnitCatalogScript.by_name("Relay Lancer-003").to_dict()
	var scout: Dictionary = game._spawn_unit(scout_card, 0, 0, 5)
	scout.atk = 2
	scout.move = 0
	scout.range = 1
	scout.skill = {}
	var blocker_card: Dictionary = UnitCatalogScript.by_name("Relay Blade-002").to_dict()
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
	var split_twin_events: Array = game.battle_simulator.events.filter(
		func(event): return event.type in ["attack", "commander_attack"]
	)
	assert(split_twin_events.size() == 2)
	assert(split_twin_events[0].strike_index == 0)
	assert(split_twin_events[1].strike_index == 1)
	assert(split_twin_events.all(func(event): return event.strike_count == 2))
	game.units.clear()
	game.skip_animations = false
	game._open_mission_select()
	var wait_frames := 0
	while game.mission_node_buttons.size() < 22 and wait_frames < 120:
		await process_frame
		wait_frames += 1
	assert(game.mission_node_buttons.size() == 22)
	assert(game.mission_map_texture.texture.resource_path.ends_with(
		"operations-map-act-1-reclamation.png"
	))
	assert(game.mission_map_texture.texture.get_image().has_mipmaps())
	assert(game.mission_act_buttons.size() == 3)
	assert(game.mission_map_act == 1)
	assert(game.mission_selected_id == 0)
	assert(game.mission_detail_kicker.text == "ACT 1 · THE SALVAGE · OPERATION 01")
	assert(game.mission_detail_title.text == CampaignStoreScript.MISSIONS[0].short_title.to_upper())
	assert(game.mission_detail_briefing.text == CampaignStoreScript.MISSIONS[0].briefing)
	game._select_mission_on_map(2)
	assert(game.mission_detail_stats.text.contains("EVACUATE THE GALLERY"))
	assert(game.mission_detail_stats.text.contains("2 BLOCKED CELLS"))
	game._select_mission_on_map(0)
	assert(game.mission_node_buttons[0].text == "01")
	assert(game.mission_node_buttons[21].text == "22")
	assert(game.mission_node_buttons[0].get_meta("operation_region") == "The Salvage")
	assert(game.mission_node_buttons[21].get_meta("operation_region") == "Sanctuary")
	assert(game.mission_list.find_children(
		"RegionLabel*", "Label", false, false
	).size() == 5)
	assert(game.mission_node_buttons[21].position.x > game.mission_node_buttons[0].position.x)
	assert(game.mission_node_buttons[21].position.y < game.mission_node_buttons[0].position.y)
	var result_buttons: Array[Node] = game.overlay.find_children("*", "Button", true, false)
	assert(result_buttons.size() == 6)
	assert(game.reward_portrait in result_buttons)
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
	assert(not game.result_redeploy_button.visible)
	assert(not game.result_menu_button.visible)
	game._show_card_reward("Relay Bastion-013", true, 1)
	assert(game.reward_reveal.visible)
	assert(game.reward_portrait.icon != null)
	assert(game.reward_portrait.drag_source == "reward")
	assert(game.reward_portrait._get_drag_data(Vector2.ZERO) == null)
	assert(game.reward_hint_label.text.contains("ABILITIES"))
	assert(game.reward_stars_label.text == "★★")
	assert(game.reward_new_label.visible)
	assert(game.reward_new_label.text == "NEW UNIT · COPY 1")
	game.reward_portrait.mouse_entered.emit()
	assert(game.hover_card.visible)
	assert(game.hover_name_label.text.contains("RELAY BASTION-013"))
	assert(game.hover_stats_label.text.contains("BULWARK CHASSIS"))
	assert(game.hover_ability_label.text.contains("BRACE PROTOCOL"))
	game.reward_portrait.mouse_exited.emit()
	assert(not game.hover_card.visible)
	game._show_card_reward("Relay Bastion-013", false, 3)
	assert(game.reward_new_label.visible)
	assert(game.reward_new_label.text.contains("DUPLICATE"))
	assert(game.reward_new_label.text.contains("COPY 3"))
	assert(game.reward_new_label.text.contains("+5 MATCH POINTS"))
	game._open_kinetic_crucible()
	await process_frame
	var crucible_units: Array = KineticCrucibleScript.active_instances(
		game.collection_instances
	)
	# EXTRAS ONLY visibly filters out unit groups that do not have a third copy
	# available beyond the protected two formation copies.
	var names_seen := {}
	var protected_count := 0
	var extras_group_count := 0
	for instance in crucible_units:
		names_seen[instance.name] = names_seen.get(instance.name, 0) + 1
	for copy_count in names_seen.values():
		protected_count += mini(2, copy_count)
		if copy_count > 2:
			extras_group_count += copy_count
	assert(game.crucible_reserve_grid.get_child_count() == extras_group_count)
	assert(protected_count > 0)
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
	# Before target selection, a three-copy group remains fully visible so the
	# strongest copy can be selected as the target. Afterwards, protected
	# non-target copies disappear and only the safe extra donor remains.
	var extras_config := ConfigFile.new()
	extras_config.set_value("meta", "instances_migrated", true)
	extras_config.set_value("collection", "next_id", 4)
	extras_config.set_value("collection", "instances", [
		{
			"id": "unit_000001", "name": "Relay Bastion-013",
			"level": 2, "points": 1, "consumed": false
		},
		{
			"id": "unit_000002", "name": "Relay Bastion-013",
			"level": 5, "points": 0, "consumed": false
		},
		{
			"id": "unit_000003", "name": "Relay Bastion-013",
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
	assert("unit_000002" in visible_ids)
	assert("unit_000003" in visible_ids)
	game._select_crucible_unit("unit_000003")
	var cards_by_id := {}
	for card in game.crucible_reserve_grid.get_children():
		cards_by_id[card.unit_name] = card
	assert(not cards_by_id["unit_000001"].disabled)
	assert(cards_by_id["unit_000001"].text.contains("RECOVERED"))
	assert(not cards_by_id.has("unit_000002"))
	assert(cards_by_id["unit_000003"].disabled)
	assert(cards_by_id["unit_000003"].text.contains("TARGET"))
	game._select_crucible_unit("unit_000001")
	assert(game.crucible_donor_ids == ["unit_000001"])
	assert(game.crucible_detail_label.text.contains("PROJECTED STATS"))
	assert(game.crucible_merge_button.text.contains("+9"))
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
			"id": "unit_000001", "name": "Relay Bastion-013",
			"level": 5, "points": 0, "consumed": false
		}
	])
	promo_config.save(KineticCrucibleScript.SAVE_PATH)
	game._open_kinetic_crucible()
	await process_frame
	game._select_crucible_unit("unit_000001")
	assert(game.crucible_target_id == "unit_000001")
	assert(not game.crucible_promote_button.disabled)
	assert(game.crucible_detail_label.text.contains("RELAY BASTION-014"))
	game._promote_crucible_unit()
	var promoted_copy := KineticCrucibleScript.instance_by_id(
		game.collection_instances, "unit_000001"
	)
	assert(promoted_copy.name == "Relay Bastion-014")
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
	assert(inventory.values().reduce(func(total, count): return total + count, 0) == 15)
	assert(game.squad_names.all(func(instance_id): return (
		KineticCrucibleScript.instance_by_id(game.collection_instances, instance_id).name
		in game.roster.filter(func(unit): return unit.stars == 1).map(func(unit): return unit.name)
	)))
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
	await process_frame
	assert(game.result_rating_panel.visible)
	assert(int(game.result_rating_grade_label.text) in range(1, 11))
	assert(game.result_rating_word_label.text.contains("/ 1000"))
	assert(game.result_rating_breakdown_label.text.contains("CONDUCTOR"))
	assert(game.result_rating_breakdown_label.text.contains("FORMATION"))
	assert(game.result_rating_breakdown_label.text.contains("TEMPO"))
	var result_plaque: PanelContainer = game.result_rating_panel.get_parent().get_parent()
	assert(result_plaque.get_global_rect().end.y <= game.get_viewport_rect().end.y)
	assert(
		game.result_rating_panel.get_global_rect().end.y
		<= game.result_primary_button.get_parent().get_global_rect().position.y
	)
	var finished_events: Array = game.battle_simulator.events.filter(
		func(event): return event.type == "battle_finished"
	)
	assert(not finished_events.is_empty())
	assert(finished_events[-1].rating.score > 0)
	assert(game.result_primary_button.text == "PLAY AGAIN")
	assert(game.result_primary_button.has_theme_stylebox_override("normal"))
	assert(not game.result_continue_button.has_theme_stylebox_override("normal"))
	assert(game.result_menu_button.visible)
	assert(not game.result_continue_button.visible)
	assert(not game.result_redeploy_button.visible)
	assert(not game.win_button.visible)
	# The defeat screen keeps RETRY BATTLE as the emphasized primary action and
	# offers the home icon as the way out.
	game.player_hp = 0
	game.enemy_hp = 20
	assert(game._check_game_over())
	await process_frame
	assert(game.overlay_title.text == game.LOSS_TITLE)
	assert(game.result_primary_button.text == "RETRY BATTLE")
	assert(game.result_primary_button.has_theme_stylebox_override("normal"))
	assert(game.result_menu_button.visible)
	assert(game.result_menu_button.icon != null)
	assert(not game.result_continue_button.visible)
	assert(not game.result_redeploy_button.visible)
	game.overlay.visible = false
	game.campaign_battle = true
	game.current_mission_id = 0
	game.current_encounter_index = 0
	game.completed_missions = [0]
	game.mission_run_conductor_hp = game.STARTING_HP
	game._start_new_match()
	var redeploy_squad: Array = game.squad_names.duplicate()
	var rewards_before_replay: int = game.earned_reward_units.size()
	var currency_before_manual_clear: int = game.requisition_currency
	game.enemy_hp = 0
	assert(game._check_game_over())
	await process_frame
	assert(game.mission_finished)
	assert(game.earned_reward_units.size() == rewards_before_replay + 1)
	assert(game.recent_reward_is_duplicate)
	assert(not game.recent_reward_instance_id.is_empty())
	assert(game.recent_reward_copy_count >= 2)
	assert(game.reward_new_label.text.contains("DUPLICATE"))
	assert(game.reward_new_label.text.contains("+5 MATCH POINTS"))
	assert(game.requisition_currency == (
		currency_before_manual_clear + RequisitionStoreScript.CAMPAIGN_MILESTONE_GRANT
	))
	assert(game.overlay_detail.text.contains("FIRST MANUAL CLEAR"))
	assert(game.result_primary_button.text.is_empty())
	assert(game.result_primary_button.icon != null)
	assert(game.result_redeploy_button.visible)
	assert(game.result_redeploy_button.text == "REDEPLOY")
	assert(game.result_redeploy_button.tooltip_text.contains("another unit reward"))
	assert(game.result_autobattle_button.visible)
	assert(game.result_autobattle_button.text == "AUTOBATTLE")
	assert(game.result_autobattle_button.tooltip_text.contains("AI command"))
	assert(game.result_continue_button.visible)
	assert(game.result_continue_button.text == "CAMPAIGN")
	assert(game.result_continue_button.has_theme_stylebox_override("normal"))
	assert(not game.result_redeploy_button.has_theme_stylebox_override("normal"))
	assert(game.get_viewport().gui_get_focus_owner() == game.result_continue_button)
	game._redeploy_mission()
	assert(not game.overlay.visible)
	assert(not game.mission_finished)
	assert(game.campaign_battle)
	assert(game.current_mission_id == 0)
	assert(game.current_encounter_index == 0)
	assert(game.round_number == 1)
	assert(game.player_hp == game.STARTING_HP)
	assert(game.squad_names == redeploy_squad)
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
	game.recent_reward_name = "Relay Mender-006"
	game.recent_reward_instance_id = ""
	game.recent_reward_is_duplicate = true
	game.recent_reward_copy_count = 2
	game.overlay.visible = true
	game.squad_overlay.visible = false
	game._continue_campaign()
	assert(not game.overlay.visible)
	assert(game.dialogue_overlay.visible)
	assert(not game.mission_overlay.visible)
	assert(game.dialogue_scene_title.text == "A Useful Kind of Impossible")
	assert(game.dialogue_speaker_label.text == "Cassian")
	assert(game.dialogue_progress_label.text == "1  /  4")
	assert(game.dialogue_portrait.texture != null)
	assert(game.dialogue_portrait.texture.resource_path.ends_with("ComfyUI_00160_.png"))
	assert(game.dialogue_portrait.texture_filter
		== CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS)
	assert(game.dialogue_portrait.texture.get_image().has_mipmaps())
	assert(not game.dialogue_initials_label.visible)
	assert(game.dialogue_backdrop.texture.resource_path.ends_with("fusion-menu.png"))
	await process_frame
	assert(game.dialogue_portrait_container is CenterContainer)
	assert(game.dialogue_portrait_container.custom_minimum_size == Vector2(300, 300))
	assert(game.dialogue_portrait_container.get_global_rect().end.y
		<= game.get_viewport_rect().end.y)
	game._advance_interlude()
	assert(game.dialogue_speaker_label.text == "Conductor")
	assert(game.dialogue_portrait.texture.resource_path.ends_with("Conductor.png"))
	game._finish_interlude()
	assert(not game.dialogue_overlay.visible)
	assert(game.mission_overlay.visible)
	assert(not game.squad_overlay.visible)
	await process_frame
	game._select_mission_on_map(0)
	assert(game.mission_scene_button.visible)
	game.mission_scene_button.pressed.emit()
	assert(game.dialogue_overlay.visible)
	assert(not game.mission_overlay.visible)
	game._finish_interlude()
	assert(game.mission_overlay.visible)
	await process_frame
	await process_frame
	game._select_mission_on_map(1)
	assert(game.mission_detail_briefing.text == CampaignStoreScript.MISSIONS[1].briefing)
	assert(not game.mission_launch_button.disabled)
	game.mission_launch_button.pressed.emit()
	assert(not game.mission_overlay.visible)
	assert(game.squad_overlay.visible)
	assert(game.squad_opened_for_mission)
	assert(game.pending_mission_id == 1)
	for action in game.squad_overlay.find_children("*", "Button", true, false):
		assert(action.text != "RESET")
	assert(game.mission_intel_panel.visible)
	assert(game.mission_enemy_preview_row.get_child_count() == 8)
	assert(game.mission_intel_label.text.contains("CONDUCTOR:"))
	assert(game.mission_intel_label.text.contains("OPPONENT: RELAY DRILL TEAM"))
	assert(game.mission_intel_label.text.contains("RECLAMATION EXPEDITION"))
	assert(game.mission_intel_stats_label.text.contains("AVG MANA"))
	assert(game.mission_intel_stats_label.text.contains("RECOMMENDED"))
	assert(game.mission_intel_stats_label.text.contains("×"))
	assert(game.mission_intel_label.get_parent() is VBoxContainer)
	assert(game.mission_intel_label.autowrap_mode == TextServer.AUTOWRAP_WORD_SMART)
	game.pending_mission_id = 60 # Act 2 · Mission 39
	game._refresh_mission_intel()
	await process_frame
	assert(game.mission_intel_label.text.contains("ACT 2 / MISSION 39"))
	assert(game.mission_intel_label.text.contains("OPPONENT: TERMINUS CUSTODIAN"))
	assert(game.mission_intel_label.text.contains("CAELIAN TRANSIT SECURITY"))
	assert(game.mission_intel_label.get_global_rect().end.x
		<= game.mission_intel_panel.get_global_rect().end.x + 0.5)
	assert(game.reward_carry_label.visible)
	assert(game.reward_carry_label.text.contains("RELAY MENDER-006"))
	assert(game.reward_carry_label.text.contains("DUPLICATE"))
	assert(game.reward_carry_label.text.contains("COPY 2"))
	game.squad_overlay.visible = false
	game.squad_opened_for_mission = false
	game.pending_mission_id = -1
	game.completed_missions = []
	for mission_id in 61:
		game.completed_missions.append(mission_id)
	assert(game._latest_campaign_mission_id() == 61)
	game._open_mission_select()
	for frame in 4:
		await process_frame
	assert(game.mission_map_act == 2)
	assert(game.mission_node_buttons.size() == 40)
	assert(game.mission_map_texture.texture.resource_path.ends_with(
		"operations-map-act-2-crisis.png"
	))
	assert(game.mission_map_texture.texture.get_image().has_mipmaps())
	assert(game.mission_selected_id == 61)
	assert(game.mission_node_buttons[61].text == "40")
	assert(game.mission_node_buttons[22].get_meta("operation_region") == "The Arena")
	assert(game.mission_node_buttons[61].get_meta("operation_region") == "Coalition Fracture")
	assert(game.mission_detail_kicker.text.contains("ACT 2"))
	assert(game.mission_detail_kicker.text.contains("OPERATION 40"))
	game._switch_operations_act(3)
	for frame in 3:
		await process_frame
	assert(game.mission_map_act == 3)
	assert(game.mission_node_buttons.size() == 15)
	assert(game.mission_map_texture.texture.resource_path.ends_with(
		"operations-map-act-3-caelis.png"
	))
	assert(game.mission_map_texture.texture.get_image().has_mipmaps())
	assert(game.mission_selected_id == 62)
	assert(game.mission_node_buttons[62].get_meta("operation_region") == "The Outer City")
	assert(game.mission_node_buttons[76].get_meta("operation_region") == "The Source")
	assert(game.mission_launch_button.disabled)
	game.mission_overlay.visible = false
	# Authored mission rules load into the deterministic runtime and board.
	game.campaign_battle = true
	game.current_mission_id = 2
	game.current_encounter_index = 0
	game.mission_run_conductor_hp = 20
	game._start_new_match()
	assert(game.active_mission_rules.objective.type == "survive")
	assert(game.player_max_energy == 4)
	assert(game.board.blocked_cells.size() == 2)
	assert(game.board.mission_objective_text.contains("EVACUATE THE GALLERY"))
	var authored_start_events: Array = game.battle_simulator.events.filter(
		func(event): return event.type == "battle_started"
	)
	assert(authored_start_events.size() == 1)
	assert(authored_start_events[0].mission_rules.objective.type == "survive")
	game.current_mission_id = 4
	game._start_new_match()
	var protected_units: Array = game.units.filter(
		func(unit): return unit.get("mission_role", "") == "protected"
	)
	assert(protected_units.size() == 1)
	assert(protected_units[0].get("mission_stationary", false))
	assert(not protected_units[0].get("locks_mana", true))
	assert(protected_units[0].id not in game.battle_simulator.activation_order(
		0, game.units
	))
	game.current_mission_id = 8
	game._start_new_match()
	var transports: Array = game.units.filter(
		func(unit): return unit.name == "Relay Ground Transport-216"
	)
	assert(transports.size() == 1)
	var transport: Dictionary = transports[0]
	assert(transport.get("mission_role", "") == "protected")
	assert(not transport.get("mission_stationary", true))
	assert(not transport.get("locks_mana", true))
	assert(transport.kind == "Transport")
	assert(transport.hp == 18 and transport.max_hp == 18)
	assert(transport.atk == 1 and transport.move == 0 and transport.range == 1)
	assert(transport.id in game.battle_simulator.activation_order(0, game.units))
	assert(BattleRulesScript.traversal_cells(
		transport, game.units, game.active_mission_rules.blocked_cells
	).is_empty())
	assert(not BattleRulesScript.can_reposition(
		transport, 0, game.units, game.active_mission_rules.blocked_cells
	))
	game.current_mission_id = 5
	game._start_new_match()
	game.round_number = 2
	await game._deploy_mission_reinforcements(1)
	assert(game.units.any(func(unit): return unit.name == "Helio Battery-057"))
	assert(game.battle_simulator.events.any(func(event): return (
		event.type == "mission_rule_triggered"
		and event.get("kind", "") == "reinforcement"
	)))
	MissionRunStoreScript.clear_run()
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
		"player_squad": ["Relay Lancer-003", "Relay Blade-002"],
		"enemy_squad": ["Relay Mender-006", "Relay Bastion-001"],
		"mission_rules": {
			"objective": {"type": "survive", "rounds": 3, "title": "Replay Hold"}
		}
	})
	replay.record("deploy", {
		"side": 0, "unit_id": 1, "card": "Relay Lancer-003", "row": 1,
		"col": 2, "mission_role": "priority", "locks_mana": false
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
	var replay_menu_button: Button = game.replay_panel.get_child(0).get_child(0).get_child(0)
	assert(replay_menu_button.text.is_empty())
	assert(replay_menu_button.icon != null)
	game._open_squad_builder()
	assert(game.replay_squad_overlay.visible)
	assert(game.replay_player_squad_grid.get_child_count() == 2)
	assert(game.replay_enemy_squad_grid.get_child_count() == 2)
	game._close_replay_squads()
	assert(not game.replay_squad_overlay.visible)
	await game._apply_next_replay_event()
	await game._apply_next_replay_event()
	assert(game.units.size() == 1)
	assert(game.units[0].col == 2)
	assert(game.units[0].mission_role == "priority")
	assert(not game.units[0].locks_mana)
	assert(game.board.mission_objective_text.contains("REPLAY HOLD"))
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
	var rewards_before_gacha: int = game.earned_reward_units.size()
	game._open_gacha()
	assert(game.gacha_overlay.visible)
	assert(not game.main_menu_overlay.visible)
	var currency_before_gacha: int = game.requisition_currency
	assert(currency_before_gacha >= RequisitionStoreScript.STARTER_GRANT)
	assert(RequisitionStoreScript.has_claimed(
		RequisitionStoreScript.campaign_milestone_claim_id(0)
	))
	assert(game.gacha_pity_label.text.contains("REQUISITION CREDITS"))
	assert(game.gacha_pity_label.text.contains("PITY"))
	assert(game.gacha_odds_label.text.contains("Battle rarity curve"))
	game._perform_gacha_roll(10, [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0])
	assert(game.gacha_results.size() == 10)
	assert(game.gacha_result_grid.get_child_count() == 10)
	assert(game.earned_reward_units.size() == rewards_before_gacha + 10)
	assert(game.gacha_pity == 10)
	assert(game.requisition_currency == (
		currency_before_gacha - RequisitionStoreScript.TEN_PULL_COST
	))
	assert(game.gacha_roll_one_button.disabled == (
		game.requisition_currency < RequisitionStoreScript.SINGLE_PULL_COST
	))
	assert(game.gacha_roll_ten_button.disabled)
	if game.requisition_currency < RequisitionStoreScript.SINGLE_PULL_COST:
		var hard_pity_credit := RequisitionStoreScript.claim("test:hard_pity", 100)
		game.requisition_currency = hard_pity_credit.balance
		game._refresh_gacha_status()
	var currency_before_hard_pity: int = game.requisition_currency
	game.gacha_pity = GachaStoreScript.HARD_PITY_PULL - 1
	game._perform_gacha_roll(1, [0.0])
	assert(game.gacha_results.size() == 1)
	assert(game.gacha_results[0].stars >= 5)
	assert(game.gacha_results[0].pity_reset)
	assert(game.gacha_pity == 0)
	assert(game.requisition_currency == (
		currency_before_hard_pity - RequisitionStoreScript.SINGLE_PULL_COST
	))
	assert(GachaStoreScript.load_pity() == 0)
	game._show_main_menu()
	assert(not game.gacha_overlay.visible)
	# Autobattle: completed missions offer an AI-commanded battle from the squad
	# builder; the driver resolves the whole mission at skip-animation speed and
	# lands on the normal victory (with reward) or loss screen.
	game._open_mission_select(0)
	for frame in 3:
		await process_frame
	game._select_mission_on_map(0)
	game._prepare_mission(0)
	assert(game.squad_opened_for_mission)
	assert(game.pending_mission_id == 0)
	assert(game.squad_autobattle_button.visible)
	assert(not game.squad_autobattle_button.disabled)
	game._save_and_autobattle_mission()
	var currency_before_autobattle: int = game.requisition_currency
	assert(game.autobattle_active)
	assert(game.campaign_battle)
	assert(game.current_mission_id == 0)
	assert(not game.squad_overlay.visible)
	var autobattle_frames := 0
	while not game.battle_over and autobattle_frames < 20000:
		await process_frame
		autobattle_frames += 1
	assert(game.battle_over, "Autobattle should resolve the mission on its own.")
	assert(game.overlay.visible)
	assert(game.battle_simulator.events.any(
		func(event): return event.type == "battle_finished"
	))
	if game.mission_finished:
		assert(game.result_primary_button.text.is_empty())
		assert(game.result_primary_button.icon != null)
		assert(not game.recent_reward_name.is_empty())
		assert(game.overlay_detail.text.contains("UNIT REWARD ONLY"))
		# The Operation Complete screen offers its own AUTOBATTLE rerun.
		assert(game.result_autobattle_button.visible)
		assert(game.result_redeploy_button.text == "REDEPLOY")
		assert(game.result_continue_button.text == "CAMPAIGN")
		game._autobattle_mission_replay()
		assert(game.autobattle_active)
		assert(not game.overlay.visible)
		autobattle_frames = 0
		while not game.battle_over and autobattle_frames < 20000:
			await process_frame
			autobattle_frames += 1
		assert(game.battle_over, "Result-screen autobattle should also resolve.")
		assert(game.overlay.visible)
	else:
		assert(game.overlay_title.text == game.LOSS_TITLE)
	assert(game.requisition_currency == currency_before_autobattle)
	game._show_main_menu()
	assert(not game.autobattle_active)
	DirAccess.remove_absolute(ProjectSettings.globalize_path(GachaStoreScript.SAVE_PATH))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(RequisitionStoreScript.SAVE_PATH))
	await create_timer(0.05).timeout
	game.queue_free()
	await process_frame
	await process_frame
	print("War of Resonance UI smoke tests passed.")
	quit()
