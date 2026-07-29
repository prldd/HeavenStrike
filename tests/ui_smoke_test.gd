extends SceneTree

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var scene: PackedScene = load("res://main.tscn")
	var game = scene.instantiate()
	root.add_child(game)
	await process_frame
	game._open_mission_select()
	await process_frame
	assert(game.mission_list.get_child_count() == 62)
	var first_entry: VBoxContainer = game.mission_list.get_child(0)
	assert(first_entry.size_flags_horizontal == Control.SIZE_EXPAND_FILL)
	assert(first_entry.get_child(1) is HBoxContainer)
	print("Skychain UI smoke tests passed.")
	quit()
