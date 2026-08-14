extends SceneTree

const OUTPUT_PATHS := {
	1: "res://tests/operations-map-modern-visual.png",
	2: "res://tests/operations-map-modern-act-2-visual.png",
	3: "res://tests/operations-map-modern-act-3-visual.png"
}

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
	for act in OUTPUT_PATHS:
		game._switch_operations_act(act)
		for frame in 3:
			await process_frame
		var image := root.get_viewport().get_texture().get_image()
		assert(not image.is_empty())
		assert(image.save_png(OUTPUT_PATHS[act]) == OK)
		print("Modern Act %d operations-map visual written to %s." % [
			act, OUTPUT_PATHS[act]
		])
	quit()
