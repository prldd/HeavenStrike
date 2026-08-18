extends SceneTree

# Renders the campaign lore-card overlay (prologue + current chapter card)
# for human review. Output goes to the gitignored .tools/ directory.
# On Windows, run windowed (headless produces a null viewport texture):
#   APPDATA="$(pwd -W)/.tools/godot-user-win" "/e/Tools/Godot/Godot.exe" --path . --script res://tests/lore_card_visual_check.gd

const OUTPUT_DIR := "res://.tools/"

func _init() -> void:
	call_deferred("_render")

func _render() -> void:
	DirAccess.make_dir_recursive_absolute(OUTPUT_DIR)
	root.size = Vector2i(1280, 720)
	var scene: PackedScene = load("res://main.tscn")
	var game = scene.instantiate()
	root.add_child(game)
	await process_frame
	game.completed_missions = []
	game._open_mission_select()
	for frame in 6:
		await process_frame
	var shots := {
		"lore-card-prologue.png": "EXPEDITION ORIENTATION",
		"lore-card-chapter.png": "CHAPTER 1"
	}
	for filename in shots:
		assert(game.lore_overlay.visible)
		assert(game.lore_kicker_label.text == shots[filename])
		var image := root.get_viewport().get_texture().get_image()
		assert(not image.is_empty())
		assert(image.save_png(OUTPUT_DIR + filename) == OK)
		print("Lore card visual written to %s." % [OUTPUT_DIR + filename])
		game._advance_lore_card()
		for frame in 3:
			await process_frame
	assert(not game.lore_overlay.visible)
	quit()
