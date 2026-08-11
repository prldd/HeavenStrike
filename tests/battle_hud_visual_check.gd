extends SceneTree

const OUTPUT_PATH := "res://tests/battle-hud-visual.png"

func _init() -> void:
	call_deferred("_render")

func _render() -> void:
	root.size = Vector2i(1280, 720)
	var scene: PackedScene = load("res://main.tscn")
	var game = scene.instantiate()
	root.add_child(game)
	await process_frame
	game.skip_animations = true
	game.board.idle_animation_enabled = false
	game._begin_practice()
	await process_frame
	await process_frame
	await process_frame
	var image := root.get_viewport().get_texture().get_image()
	assert(not image.is_empty())
	assert(image.save_png(OUTPUT_PATH) == OK)
	print("Battle HUD visual written to %s." % OUTPUT_PATH)
	quit()
