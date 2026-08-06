extends SceneTree

const BoardViewScript = preload("res://scripts/board_view.gd")

const OUTPUT_PATH := "res://tests/original-art-visual.png"

func _init() -> void:
	call_deferred("_render")

func _render() -> void:
	root.size = Vector2i(1280, 720)
	var board := BoardViewScript.new()
	root.add_child(board)
	board.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	board.player_mana_text = "6 / 10"
	board.enemy_mana_text = "4 / 10"
	board.player_hp_text = "18 / 20"
	board.enemy_hp_text = "14 / 20"
	board.player_deck_text = "5"
	board.enemy_deck_text = "4"
	board.opponent_name = "RELAY INSPECTOR"
	board.opponent_affiliation = "CAELIAN CIVIC GRID"
	board.mission_objective_text = "Protect the survey chassis through round 5."
	board.units = [
		_unit(1, 0, 63, "Artillerist", 0, 1, 4, 3),
		_unit(2, 0, 113, "Warden", 1, 2, 8, 2),
		_unit(3, 0, 169, "Channeler", 2, 1, 6, 4),
		_unit(4, 1, 102, "Lifebinder", 0, 5, 5, 2),
		_unit(5, 1, 79, "Strider", 1, 4, 4, 3),
		_unit(6, 1, 117, "Duelist", 2, 5, 7, 3),
	]
	board.queue_redraw()
	await process_frame
	await process_frame
	await process_frame
	var image := root.get_viewport().get_texture().get_image()
	assert(not image.is_empty())
	assert(image.save_png(OUTPUT_PATH) == OK)
	print("Original-art visual written to %s." % OUTPUT_PATH)
	quit()

func _unit(
	id: int, side: int, icon: int, kind: String,
	row: int, col: int, hp: int, atk: int
) -> Dictionary:
	return {
		"id": id,
		"side": side,
		"icon": icon,
		"name": "Visual Chassis %d" % id,
		"kind": kind,
		"row": row,
		"col": col,
		"hp": hp,
		"max_hp": hp,
		"atk": atk,
		"move": 2,
		"range": 1,
		"ready": true,
		"effects": [],
	}
