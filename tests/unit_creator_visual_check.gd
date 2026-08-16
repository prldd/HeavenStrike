extends SceneTree

const OUTPUT_PATH := "res://tests/unit-creator-visual.png"
const COAL_OUTPUT_PATH := "res://tests/unit-creator-coal-visual.png"
const UNARMED_OUTPUT_PATH := "res://tests/unit-creator-unarmed-visual.png"

func _init() -> void:
	call_deferred("_render")

func _render() -> void:
	root.size = Vector2i(1280, 720)
	var scene: PackedScene = load("res://main.tscn")
	var game = scene.instantiate()
	root.add_child(game)
	await process_frame
	game._open_unit_creator()
	game.unit_creator_animation_toggle.button_pressed = false
	game.unit_creator_view.set_animation_enabled(false)
	var captures := [
		{"faction": "Coal", "class": "Artillerist", "weapon": "foundry_rotary", "path": COAL_OUTPUT_PATH},
		{"faction": "Wind", "class": "Artillerist", "weapon": "turbine_repeater", "path": OUTPUT_PATH},
		{"faction": "Wind", "class": "Duelist", "weapon": "unarmed", "path": UNARMED_OUTPUT_PATH}
	]
	for capture in captures:
		game.unit_creator_recipe = {
			"faction": capture.faction,
			"class": capture["class"],
			"body": "Shared Line Chassis",
			"weapon": capture.weapon,
			"pose": "Attack"
		}
		game._sync_unit_creator_controls()
		game._refresh_unit_creator()
		game.unit_creator_pivot_toggle.button_pressed = capture["class"] == "Artillerist"
		for frame in 3:
			await process_frame
		await RenderingServer.frame_post_draw
		var image := root.get_viewport().get_texture().get_image()
		assert(not image.is_empty())
		assert(image.save_png(capture.path) == OK)
		print("Unit creator visual written to %s." % capture.path)
	quit()
