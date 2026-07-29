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
	assert(game.squad_selection_grid.get_child_count() == game.editing_squad_names.size())
	var previous_size: int = game.editing_squad_names.size()
	game._remove_squad_unit_at(0)
	assert(game.editing_squad_names.size() == previous_size - 1)
	var add_name: String = game.squad_grid.get_child(0).unit_name
	game._on_squad_drop(add_name, "barracks", "squad")
	assert(game.editing_squad_names.count(add_name) <= 2)
	print("Skychain UI smoke tests passed.")
	quit()
