extends SceneTree

const CRUCIBLE_OUTPUT := "res://.tools/kinetic-crucible-visual.png"
const REWARD_OUTPUT := "res://.tools/duplicate-reward-visual.png"

func _init() -> void:
	call_deferred("_render")

func _render() -> void:
	root.size = Vector2i(1280, 720)
	var scene: PackedScene = load("res://main.tscn")
	var game = scene.instantiate()
	root.add_child(game)
	await process_frame

	game.main_menu_overlay.visible = false
	game.crucible_overlay.visible = true
	game.crucible_extras_toggle.set_pressed_no_signal(false)
	game.crucible_filter_text = "Relay Bastion-013"
	game.collection_instances = [
		_instance("unit_000001", 3, 8),
		_instance("unit_000002", 2, 1),
		_instance("unit_000003", 1, 0),
		_instance("unit_000004", 1, 0)
	]
	game.crucible_target_id = "unit_000001"
	game.crucible_donor_ids = ["unit_000002", "unit_000003"]
	game._rebuild_crucible(false)
	await _save_frame(CRUCIBLE_OUTPUT)

	game.crucible_overlay.visible = false
	game.overlay.visible = true
	game.overlay_title.text = "OPERATION COMPLETE"
	game.overlay_detail.text = (
		"The relay line is secure. Duplicate chassis remain valuable as "
		+ "Kinetic Crucible donors."
	)
	game.result_rating_panel.visible = false
	game.result_continue_button.visible = true
	game.result_redeploy_button.visible = true
	game.result_menu_button.visible = false
	game._show_card_reward("Relay Bastion-013", false, 4)
	await _save_frame(REWARD_OUTPUT)
	print("Progression visuals written to res://.tools/.")
	quit()

func _instance(instance_id: String, level: int, points: int) -> Dictionary:
	return {
		"id": instance_id,
		"name": "Relay Bastion-013",
		"level": level,
		"points": points,
		"consumed": false
	}

func _save_frame(path: String) -> void:
	await process_frame
	await process_frame
	await process_frame
	var image := root.get_viewport().get_texture().get_image()
	assert(not image.is_empty())
	assert(image.save_png(path) == OK)
