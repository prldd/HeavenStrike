extends SceneTree

const CampaignStoreScript = preload("res://scripts/campaign_store.gd")

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var scene: PackedScene = load("res://main.tscn")
	var game = scene.instantiate()
	root.add_child(game)
	await process_frame
	assert(game.main_menu_overlay.get_child(0) is TextureRect)
	assert(game.main_menu_overlay.get_child(0).texture != null)
	assert(game.squad_overlay.get_child(0) is TextureRect)
	assert(game.squad_overlay.get_child(0).texture != null)
	assert(game.speed_button.text == "SPEED 1×")
	assert(game.end_button.get_parent() != game.hint_label.get_parent())
	assert(game.hand_row.get_child(0).get_theme_stylebox("normal") is StyleBoxFlat)
	game._cycle_resolution_speed()
	assert(game.resolution_speed == 2.0)
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
	var first_entry: VBoxContainer = game.mission_list.get_child(0)
	assert(first_entry.size_flags_horizontal == Control.SIZE_EXPAND_FILL)
	assert(first_entry.get_child(1) is HBoxContainer)
	var result_buttons: Array[Node] = game.overlay.find_children("*", "Button", true, false)
	assert(result_buttons.size() == 1)
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
	print("Skychain UI smoke tests passed.")
	quit()
