extends SceneTree

const OUTPUT_PATH := "res://tests/operations-map-modern-visual.png"

func _init() -> void:
	call_deferred("_render")

func _render() -> void:
	root.size = Vector2i(1280, 720)
	var scene: PackedScene = load("res://main.tscn")
	var game = scene.instantiate()
	root.add_child(game)
	await process_frame
	game.completed_missions = []
	game._open_mission_select()
	for frame in 6:
		await process_frame
	var image := root.get_viewport().get_texture().get_image()
	assert(not image.is_empty())
	assert(image.save_png(OUTPUT_PATH) == OK)
	print("Modern operations-map visual written to %s." % OUTPUT_PATH)
	quit()
