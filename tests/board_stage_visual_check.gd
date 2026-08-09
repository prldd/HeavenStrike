extends SceneTree

const BoardViewScript = preload("res://scripts/board_view.gd")

const STAGES := [
	["training", -1],
	["relay", 0],
	["proving", 14],
	["faction", 29],
	["coalition", 45],
	["caelis", 62],
]

func _init() -> void:
	call_deferred("_render")

func _render() -> void:
	root.size = Vector2i(1280, 720)
	for stage in STAGES:
		var board := BoardViewScript.new()
		root.add_child(board)
		board.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		if stage[1] < 0:
			board.set_practice_mode(true)
		else:
			board.set_campaign_mission(stage[1])
		board.player_hp_text = "18 / 20"
		board.enemy_hp_text = "14 / 20"
		board.player_mana_text = "6 / 10"
		board.enemy_mana_text = "4 / 10"
		board.units = [
			_unit(1, 0, 1, "Warden", 0, 1),
			_unit(2, 0, 3, "Strider", 2, 2),
			_unit(3, 1, 5, "Warden", 1, 5),
			_unit(4, 1, 7, "Duelist", 2, 6),
		]
		board.queue_redraw()
		await process_frame
		await process_frame
		await process_frame
		var image := root.get_viewport().get_texture().get_image()
		var output := "res://.tools/board-stage-%s.png" % stage[0]
		assert(image.save_png(output) == OK)
		board.queue_free()
		await process_frame
	print("Board stage visual check complete.")
	quit()

func _unit(id: int, side: int, icon: int, kind: String, row: int, col: int) -> Dictionary:
	return {
		"id": id,
		"side": side,
		"icon": icon,
		"name": "Stage Unit %d" % id,
		"kind": kind,
		"row": row,
		"col": col,
		"hp": 6,
		"max_hp": 6,
		"atk": 3,
		"move": 2,
		"range": 1,
		"ready": true,
		"effects": [],
	}
