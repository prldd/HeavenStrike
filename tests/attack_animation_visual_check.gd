extends SceneTree

const BoardViewScript = preload("res://scripts/board_view.gd")

const OUTPUT_PATH := "res://tests/attack-animation-visual.png"
const CAPTURE_SIZE := Vector2i(640, 360)
const CAPTURE_COUNT := 6
const ATTACK_DURATION := 1.20

func _init() -> void:
	call_deferred("_render")

func _render() -> void:
	root.size = Vector2i(1280, 720)
	var board := BoardViewScript.new()
	root.add_child(board)
	board.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	board.player_mana_text = "6 / 10"
	board.enemy_mana_text = "4 / 10"
	board.player_hp_text = "20 / 20"
	board.enemy_hp_text = "20 / 20"
	board.player_deck_text = "4"
	board.enemy_deck_text = "4"
	board.opponent_name = "ANIMATION TEST"
	board.opponent_affiliation = "ART ID 241"
	board.mission_objective_text = "Verify generated attack-frame playback."
	board.units = [
		_unit(1, 0, 136, "Warden", 1, 2, 8, 2),
		_unit(2, 1, 1, "Warden", 1, 4, 8, 2),
	]
	await process_frame
	await process_frame

	var loaded_frames: Array = board._attack_frames_for(board.units[0])
	assert(loaded_frames.size() == 6)
	board.animate_attack(1, 2, "Warden", ATTACK_DURATION)
	var sheet := Image.create_empty(
		CAPTURE_SIZE.x * 3, CAPTURE_SIZE.y * 2, false, Image.FORMAT_RGBA8
	)
	var frame_interval := ATTACK_DURATION / float(CAPTURE_COUNT)
	await create_timer(frame_interval * 0.5).timeout
	for capture_index in CAPTURE_COUNT:
		var capture := root.get_viewport().get_texture().get_image()
		assert(not capture.is_empty())
		capture.resize(CAPTURE_SIZE.x, CAPTURE_SIZE.y, Image.INTERPOLATE_LANCZOS)
		var destination := Vector2i(
			(capture_index % 3) * CAPTURE_SIZE.x,
			(capture_index / 3) * CAPTURE_SIZE.y
		)
		sheet.blit_rect(capture, Rect2i(Vector2i.ZERO, CAPTURE_SIZE), destination)
		if capture_index < CAPTURE_COUNT - 1:
			await create_timer(frame_interval).timeout
	await create_timer(frame_interval * 0.5).timeout
	await process_frame
	assert(board.unit_attack_frame_progress.is_empty())
	board.animate_commander_attack(1, 1, "Warden", 0.12)
	await create_timer(0.04).timeout
	assert(board.unit_attack_frame_progress.has(1))
	await create_timer(0.10).timeout
	assert(board.unit_attack_frame_progress.is_empty())
	assert(sheet.save_png(OUTPUT_PATH) == OK)
	print("Attack-animation visual written to %s." % OUTPUT_PATH)
	quit()

func _unit(
	id: int, side: int, icon: int, kind: String,
	row: int, col: int, hp: int, atk: int
) -> Dictionary:
	return {
		"id": id,
		"side": side,
		"icon": icon,
		"name": "Attack Test %d" % id,
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
