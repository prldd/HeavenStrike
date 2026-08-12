extends SceneTree

const BoardViewScript = preload("res://scripts/board_view.gd")

const OUTPUT_PATH := "res://tests/attack-animation-visual.png"
const CAPTURE_SIZE := Vector2i(640, 360)
const CAPTURE_COUNT := 6
const ATTACK_DURATION := 0.48
const TEST_TIME_SCALE := 4.0

func _init() -> void:
	call_deferred("_render")

func _render() -> void:
	root.size = Vector2i(1280, 720)
	_assert_attack_frame_imports()
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
	Engine.time_scale = TEST_TIME_SCALE
	var attack_finished: Signal = board.animate_attack(1, 2, "Warden", ATTACK_DURATION)
	var playback_duration := board._attack_frame_duration(ATTACK_DURATION)
	assert(playback_duration / Engine.time_scale >= 0.30)
	for frame in 4:
		await process_frame
	assert(board.unit_attack_frame_progress.has(1))
	var high_speed_progress: float = board.unit_attack_frame_progress[1]
	assert(high_speed_progress > 0.0 and high_speed_progress < float(CAPTURE_COUNT))
	await attack_finished
	assert(board.unit_attack_frame_progress.is_empty())
	var commander_attack_finished: Signal = board.animate_commander_attack(
		1, 1, "Warden", 0.12
	)
	for frame in 4:
		await process_frame
	assert(board.unit_attack_frame_progress.has(1))
	await commander_attack_finished
	assert(board.unit_attack_frame_progress.is_empty())
	Engine.time_scale = 1.0

	var sheet := Image.create_empty(
		CAPTURE_SIZE.x * 3, CAPTURE_SIZE.y * 2, false, Image.FORMAT_RGBA8
	)
	for capture_index in CAPTURE_COUNT:
		board.unit_attack_frame_progress[1] = float(capture_index)
		board.queue_redraw()
		await process_frame
		await RenderingServer.frame_post_draw
		var capture := root.get_viewport().get_texture().get_image()
		assert(not capture.is_empty())
		capture.resize(CAPTURE_SIZE.x, CAPTURE_SIZE.y, Image.INTERPOLATE_LANCZOS)
		var destination := Vector2i(
			(capture_index % 3) * CAPTURE_SIZE.x,
			(capture_index / 3) * CAPTURE_SIZE.y
		)
		sheet.blit_rect(capture, Rect2i(Vector2i.ZERO, CAPTURE_SIZE), destination)
	board.unit_attack_frame_progress.clear()
	board.attack_frame_animation_enabled = false
	board.animate_attack(1, 2, "Warden", 0.01)
	await process_frame
	assert(board.unit_attack_frame_progress.is_empty())
	assert(sheet.save_png(OUTPUT_PATH) == OK)
	print("Attack-animation visual written to %s." % OUTPUT_PATH)
	quit()

func _assert_attack_frame_imports() -> void:
	var art_directories := DirAccess.get_directories_at(
		"res://assets/units/attack"
	)
	assert(not art_directories.is_empty())
	for art_directory in art_directories:
		assert(art_directory.is_valid_int())
		assert(FileAccess.file_exists(
			"res://assets/units/full/%03d.png" % int(art_directory)
		))
		for frame_index in range(1, 7):
			var frame_path := "res://assets/units/attack/%s/attack_%d.png" % [
				art_directory, frame_index
			]
			assert(ResourceLoader.exists(frame_path, "Texture2D"))

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
