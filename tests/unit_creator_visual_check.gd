extends SceneTree

const OUTPUT_PATH := "res://tests/unit-creator-visual.png"

func _init() -> void:
	call_deferred("_render")

func _render() -> void:
	root.size = Vector2i(1280, 720)
	var scene: PackedScene = load("res://main.tscn")
	var game = scene.instantiate()
	root.add_child(game)
	await process_frame
	game._open_unit_creator()
	game.unit_creator_recipe = {
		"faction": "Coal",
		"class": "Artillerist",
		"frame": "Bulwark",
		"head": "Cyclops",
		"finish": "Field",
		"pose": "Attack"
	}
	game._sync_unit_creator_controls()
	game._refresh_unit_creator()
	game.unit_creator_animation_toggle.button_pressed = false
	game.unit_creator_view.set_animation_enabled(false)
	for frame in 3:
		await process_frame
	await RenderingServer.frame_post_draw
	var image := root.get_viewport().get_texture().get_image()
	assert(not image.is_empty())
	assert(image.save_png(OUTPUT_PATH) == OK)
	print("Unit creator visual written to %s." % OUTPUT_PATH)
	quit()
