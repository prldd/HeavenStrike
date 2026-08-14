extends SceneTree

const OUTPUT := "res://.tools/named-squads-visual.png"

func _init() -> void:
	call_deferred("_render")

func _render() -> void:
	root.size = Vector2i(1280, 720)
	var scene: PackedScene = load("res://main.tscn")
	var game = scene.instantiate()
	root.add_child(game)
	await process_frame
	game.main_menu_overlay.visible = false
	game.input_enabled = true
	game._open_squad_builder()
	await process_frame
	var formation: Array = game.editing_squad_names.duplicate()
	game.saved_squads = [
		_squad("squad_001", "Relay Guard", formation, "Shield"),
		_squad("squad_002", "Siegebreakers", formation, "Firestorm"),
		_squad("squad_003", "Rapid Response", formation, "Rally")
	]
	game._load_editing_squad("squad_002")
	game._refresh_named_squad_controls()
	game._rebuild_squad_grid()
	await process_frame
	await process_frame
	await process_frame
	var image := root.get_viewport().get_texture().get_image()
	assert(not image.is_empty())
	assert(image.save_png(OUTPUT) == OK)
	print("Named squads visual written to %s." % OUTPUT)
	quit()

func _squad(
	squad_id: String, squad_name: String, formation: Array, conductor_skill: String
) -> Dictionary:
	return {
		"id": squad_id,
		"name": squad_name,
		"instance_ids": formation.duplicate(),
		"conductor_skill": conductor_skill
	}
