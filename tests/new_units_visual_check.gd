extends SceneTree

const BoardViewScript = preload("res://scripts/board_view.gd")

const OUTPUT_PATH := "res://.tools/new-units-visual.png"

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
	# One carrier per new-skill batch: batch two (225-236) on the player side,
	# batch three (237-251) on the enemy side. Icons 231/232/241/242 map to
	# remapped art IDs 1307-1310 through UnitCatalog.art_id.
	board.units = [
		_unit(1, 0, 225, "Duelist", 0, 1, 7, 4),
		_unit(2, 0, 226, "Channeler", 1, 1, 5, 4),
		_unit(3, 0, 228, "Warden", 2, 1, 10, 2),
		_unit(4, 0, 230, "Strider", 0, 2, 4, 3),
		_unit(5, 0, 231, "Channeler", 1, 2, 6, 4),
		_unit(6, 0, 232, "Artillerist", 2, 2, 6, 4),
		_unit(7, 0, 236, "Lifebinder", 1, 3, 4, 3),
		_unit(8, 1, 237, "Warden", 0, 5, 10, 2),
		_unit(9, 1, 239, "Channeler", 1, 5, 5, 4),
		_unit(10, 1, 240, "Artillerist", 2, 5, 5, 3),
		_unit(11, 1, 241, "Duelist", 0, 4, 5, 4),
		_unit(12, 1, 242, "Strider", 1, 4, 5, 2),
		_unit(13, 1, 246, "Channeler", 2, 4, 6, 4),
		_unit(14, 1, 249, "Warden", 1, 6, 9, 2),
	]
	board.queue_redraw()
	await process_frame
	await process_frame
	await process_frame
	var image := root.get_viewport().get_texture().get_image()
	assert(not image.is_empty())
	assert(image.save_png(OUTPUT_PATH) == OK)
	print("New-units visual written to %s." % OUTPUT_PATH)
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
