class_name BoardView
extends Control

const BattleRulesScript = preload("res://scripts/battle_rules.gd")
const UnitCatalogScript = preload("res://scripts/unit_catalog.gd")
const UnitSkillsScript = preload("res://scripts/unit_skills.gd")
const TRAINING_BACKGROUND := preload("res://assets/boards/stage-training.png")
const RELAY_BACKGROUND := preload("res://assets/boards/stage-relay-excavation.png")
const PROVING_BACKGROUND := preload("res://assets/boards/stage-proving-circuit.png")
const FACTION_BACKGROUND := preload("res://assets/boards/stage-faction-crossroads.png")
const COALITION_BACKGROUND := preload("res://assets/boards/stage-coalition-front.png")
const CAELIS_BACKGROUND := preload("res://assets/boards/stage-caelis-sanctum.png")

signal deployment_clicked(row: int)
signal board_cell_clicked(row: int, col: int)
signal unit_hovered(unit: Dictionary)
signal unit_hover_ended
signal opponent_hovered
signal opponent_hover_ended

const ROWS := 3
const COLS := 7
const GRID_BOTTOM_MARGIN := 18.0
const GRID_MAX_TOP := 250.0
const GRID_MIN_TOP := 118.0
const GRID_SIDE_GUTTER := 260.0
const CELL_WIDTH_TO_DEPTH := 1.04
const PERSPECTIVE_TOP_SCALE := 0.86
const ROW_DEPTHS := [0.0, 0.28, 0.62, 1.0]
const UNIT_ART_CELL_SCALE := 1.82
const UNIT_FOOT_INSET := 8.0
const READY_PULSE_FREQUENCY := 0.32
const GRID_BRASS := Color("#b99a64")
const GRID_PLAYER_ENAMEL := Color("#78b9c2")
const GRID_ENEMY_ENAMEL := Color("#bd7675")
const DEPLOY_GREEN := Color("#70e0a1")
const DEPLOY_GREEN_BRIGHT := Color("#c4ffda")
const STAGE_TRAINING := "training"
const STAGE_RELAY := "relay_excavation"
const STAGE_PROVING := "proving_circuit"
const STAGE_FACTION := "faction_crossroads"
const STAGE_COALITION := "coalition_front"
const STAGE_CAELIS := "caelis_sanctum"
var units: Array = []
var selected_card: Dictionary = {}
var selected_unit_id := -1
var targetable_unit_ids: Array = []
var targetable_rows: Array = []
var guided_deployment_row := -1
var guided_reposition_row := -1
var guided_target_pulse := false
var guidance_pulse_time := 0.0
var player_mana_text := ""
var enemy_mana_text := ""
var player_hp_text := ""
var enemy_hp_text := ""
var player_deck_text := ""
var enemy_deck_text := ""
var opponent_name := ""
var opponent_affiliation := ""
var _opponent_hovered := false
var blocked_cells: Array = []
var mission_objective_text := ""
var enabled := true
var practice_mode := false
var background_stage := STAGE_RELAY
var hover_row := -1
var hover_col := -1
var hover_unit_id := -1
var event_text := "Choose a unit, then choose a lane."
var unit_effects: Dictionary = {}
var unit_effect_tweens: Dictionary = {}
var commander_effect_side := -1
var commander_effect_label := ""
var commander_effect_color := Color.WHITE
var commander_effect_strength := 0.0
var commander_effect_tween: Tween
var unit_visual_offsets: Dictionary = {}
var unit_flash_strength: Dictionary = {}
var unit_defeat_strength: Dictionary = {}
var full_unit_texture_cache: Dictionary = {}
var projectile_from := Vector2.ZERO
var projectile_to := Vector2.ZERO
var projectile_progress := 0.0
var projectile_kind := ""
var shake_tween: Tween
var reduced_motion := false
var idle_animation_enabled := true
var idle_time := 0.0

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	mouse_exited.connect(_clear_hover)

func _process(delta: float) -> void:
	if reduced_motion or not idle_animation_enabled or not is_visible_in_tree():
		return
	var redraw := false
	if not units.is_empty():
		idle_time += delta / maxf(Engine.time_scale, 0.001)
		redraw = true
	if _has_guidance_pulse():
		guidance_pulse_time = fmod(
			guidance_pulse_time + delta / maxf(Engine.time_scale, 0.001), 1.1
		)
		redraw = true
	if redraw:
		queue_redraw()

func _clear_hover() -> void:
	hover_row = -1
	hover_col = -1
	if hover_unit_id >= 0:
		hover_unit_id = -1
		unit_hover_ended.emit()
	queue_redraw()

func set_practice_mode(enabled_flag: bool) -> void:
	var next_stage := STAGE_TRAINING if enabled_flag else (
		STAGE_RELAY if background_stage == STAGE_TRAINING else background_stage
	)
	if practice_mode == enabled_flag and background_stage == next_stage:
		return
	practice_mode = enabled_flag
	background_stage = next_stage
	queue_redraw()

func set_campaign_mission(mission_id: int) -> void:
	practice_mode = false
	background_stage = campaign_stage_for_mission(mission_id)
	queue_redraw()

static func campaign_stage_for_mission(mission_id: int) -> String:
	if mission_id < 14:
		return STAGE_RELAY
	if mission_id < 29:
		return STAGE_PROVING
	if mission_id < 45:
		return STAGE_FACTION
	if mission_id < 62:
		return STAGE_COALITION
	return STAGE_CAELIS

func _background_texture() -> Texture2D:
	match background_stage:
		STAGE_TRAINING:
			return TRAINING_BACKGROUND
		STAGE_PROVING:
			return PROVING_BACKGROUND
		STAGE_FACTION:
			return FACTION_BACKGROUND
		STAGE_COALITION:
			return COALITION_BACKGROUND
		STAGE_CAELIS:
			return CAELIS_BACKGROUND
		_:
			return RELAY_BACKGROUND

func set_opponent_identity(display_name: String, affiliation: String) -> void:
	opponent_name = display_name
	opponent_affiliation = affiliation
	if display_name.is_empty() and _opponent_hovered:
		_opponent_hovered = false
		opponent_hover_ended.emit()
	queue_redraw()

func _opponent_plaque_rect() -> Rect2:
	var plaque_width := minf(270.0, size.x * 0.25)
	return Rect2(
		Vector2(size.x - plaque_width - 14.0, 5.0),
		Vector2(plaque_width, 31.0)
	)

func _update_opponent_hover(point: Vector2) -> void:
	var inside := (
		not opponent_name.is_empty()
		and _opponent_plaque_rect().has_point(point)
	)
	if inside == _opponent_hovered:
		return
	_opponent_hovered = inside
	if inside:
		opponent_hovered.emit()
	else:
		opponent_hover_ended.emit()

func _notification(what: int) -> void:
	if what == NOTIFICATION_MOUSE_EXIT and _opponent_hovered:
		_opponent_hovered = false
		opponent_hover_ended.emit()

func set_mission_rules(next_blocked_cells: Array, objective_text: String) -> void:
	blocked_cells = next_blocked_cells.duplicate(true)
	mission_objective_text = objective_text
	queue_redraw()

func set_guidance(
	deployment_row: int = -1,
	reposition_row: int = -1,
	target_pulse: bool = false
) -> void:
	guided_deployment_row = deployment_row
	guided_reposition_row = reposition_row
	guided_target_pulse = target_pulse
	if not _has_guidance_pulse():
		guidance_pulse_time = 0.0
	queue_redraw()

func _has_guidance_pulse() -> bool:
	return (
		guided_deployment_row >= 0 or guided_reposition_row >= 0
		or guided_target_pulse
	)

func _guidance_pulse_amount() -> float:
	if reduced_motion or not idle_animation_enabled:
		return 0.7
	return (sin(guidance_pulse_time / 1.1 * TAU - PI * 0.5) + 1.0) * 0.5

func set_state(
	next_units: Array,
	card: Dictionary,
	selected_id: int,
	can_deploy: bool,
	message: String,
	next_targetable_ids: Array = [],
	next_player_mana_text: String = "",
	next_enemy_mana_text: String = "",
	next_player_hp_text: String = "",
	next_enemy_hp_text: String = "",
	next_player_deck_text: String = "",
	next_enemy_deck_text: String = "",
	next_targetable_rows: Array = []
) -> void:
	units = next_units
	selected_card = card
	selected_unit_id = selected_id
	targetable_unit_ids = next_targetable_ids.duplicate()
	targetable_rows = next_targetable_rows.duplicate()
	player_mana_text = next_player_mana_text
	enemy_mana_text = next_enemy_mana_text
	player_hp_text = next_player_hp_text
	enemy_hp_text = next_enemy_hp_text
	player_deck_text = next_player_deck_text
	enemy_deck_text = next_enemy_deck_text
	enabled = can_deploy
	event_text = message
	queue_redraw()

func play_unit_effect(unit_id: int, label: String, color: Color) -> void:
	if unit_effect_tweens.has(unit_id):
		var old_tween: Tween = unit_effect_tweens[unit_id]
		if is_instance_valid(old_tween):
			old_tween.kill()
	unit_effects[unit_id] = {"label": label, "color": color, "strength": 1.0}
	var tween := create_tween()
	unit_effect_tweens[unit_id] = tween
	tween.tween_method(_set_unit_effect_strength.bind(unit_id), 1.0, 0.0, 0.38).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_callback(_clear_unit_effect.bind(unit_id))
	queue_redraw()

func play_commander_effect(side: int, label: String, color: Color) -> void:
	commander_effect_side = side
	commander_effect_label = label
	commander_effect_color = color
	commander_effect_strength = 1.0
	if is_instance_valid(commander_effect_tween):
		commander_effect_tween.kill()
	commander_effect_tween = create_tween()
	commander_effect_tween.tween_method(_set_commander_effect_strength, 1.0, 0.0, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	commander_effect_tween.tween_callback(_clear_commander_effect)
	queue_redraw()

func animate_unit_move(
	unit_id: int, from_row: int, from_col: int, duration: float = 0.28
) -> Signal:
	var unit = _unit_by_id(unit_id)
	if unit == null:
		return get_tree().process_frame
	var from_center := _cell_rect(from_row, from_col).get_center()
	var destination_center := _cell_rect(unit.row, unit.col).get_center()
	var starting_offset := from_center - destination_center
	unit_visual_offsets[unit_id] = starting_offset
	queue_redraw()
	var tween := create_tween()
	tween.tween_method(
		_set_unit_visual_offset.bind(unit_id),
		starting_offset,
		Vector2.ZERO,
		duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(_clear_unit_visual.bind(unit_id))
	return tween.finished

func animate_attack(
	actor_id: int, target_id: int, unit_kind: String, duration: float = 0.24
) -> Signal:
	var actor = _unit_by_id(actor_id)
	var target = _unit_by_id(target_id)
	if actor == null or target == null:
		return get_tree().process_frame
	var origin := _cell_rect(actor.row, actor.col).get_center()
	var destination := _cell_rect(target.row, target.col).get_center()
	if unit_kind in ["Strider", "Duelist", "Warden"]:
		var lunge_scale := 0.35 if reduced_motion else 1.0
		var direction := (destination - origin).normalized()
		var lunge := direction * minf(28.0, origin.distance_to(destination) * 0.22) * lunge_scale
		# Wind up by pulling back from the target, then spring forward into the
		# strike. The strike eases in so it accelerates through the hit.
		var windup := -direction * minf(9.0, origin.distance_to(destination) * 0.08) * lunge_scale
		duration *= 1.35
		var tween := create_tween()
		tween.tween_method(_set_unit_visual_offset.bind(actor_id), Vector2.ZERO, windup, duration * 0.30)\
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_method(_set_unit_visual_offset.bind(actor_id), windup, lunge, duration * 0.28)\
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tween.tween_method(_set_unit_visual_offset.bind(actor_id), lunge, Vector2.ZERO, duration * 0.42)\
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_callback(_clear_unit_visual.bind(actor_id))
		return tween.finished
	return _animate_projectile(origin, destination, unit_kind, duration)

func animate_commander_attack(
	actor_id: int, commander_side: int, unit_kind: String, duration: float = 0.26
) -> Signal:
	var actor = _unit_by_id(actor_id)
	if actor == null:
		return get_tree().process_frame
	var origin := _cell_rect(actor.row, actor.col).get_center()
	var destination := Vector2(
		size.x - 82.0 if commander_side == 1 else 82.0,
		_grid_rect().get_center().y
	)
	if unit_kind in ["Strider", "Duelist", "Warden"]:
		var direction := (destination - origin).normalized()
		var lunge := direction * (10.0 if reduced_motion else 30.0)
		var windup := -direction * (4.0 if reduced_motion else 11.0)
		duration *= 1.35
		var tween := create_tween()
		tween.tween_method(_set_unit_visual_offset.bind(actor_id), Vector2.ZERO, windup, duration * 0.30)\
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_method(_set_unit_visual_offset.bind(actor_id), windup, lunge, duration * 0.28)\
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tween.tween_method(_set_unit_visual_offset.bind(actor_id), lunge, Vector2.ZERO, duration * 0.42)\
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_callback(_clear_unit_visual.bind(actor_id))
		return tween.finished
	return _animate_projectile(origin, destination, unit_kind, duration)

func animate_heal(actor_id: int, target_id: int, duration: float = 0.32) -> Signal:
	var actor = _unit_by_id(actor_id)
	var target = _unit_by_id(target_id)
	if actor == null or target == null:
		return get_tree().process_frame
	return _animate_projectile(
		_cell_rect(actor.row, actor.col).get_center(),
		_cell_rect(target.row, target.col).get_center(),
		"Heal",
		duration
	)

func animate_hit(unit_id: int, duration: float = 0.18) -> Signal:
	var unit = _unit_by_id(unit_id)
	if unit == null:
		return get_tree().process_frame
	var direction := -1.0 if unit.side == 1 else 1.0
	unit_flash_strength[unit_id] = 1.0
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_method(_set_unit_flash.bind(unit_id), 1.0, 0.0, duration)
	tween.tween_method(
		_set_unit_visual_offset.bind(unit_id),
		Vector2(direction * 9.0, 0),
		Vector2.ZERO,
		duration
	).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(_clear_unit_hit.bind(unit_id))
	return tween.finished

func animate_defeat(unit_id: int, duration: float = 0.28) -> Signal:
	var unit = _unit_by_id(unit_id)
	if unit == null:
		return get_tree().process_frame
	unit_defeat_strength[unit_id] = 0.0
	var tween := create_tween()
	tween.tween_method(_set_unit_defeat.bind(unit_id), 0.0, 1.0, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_callback(_clear_unit_defeat.bind(unit_id))
	return tween.finished

func shake(strength: float = 8.0) -> void:
	if reduced_motion:
		return
	if shake_tween != null and shake_tween.is_valid():
		shake_tween.kill()
	var origin := position
	shake_tween = create_tween()
	shake_tween.tween_property(self, "position", origin + Vector2(strength, -strength * 0.35), 0.035)
	shake_tween.tween_property(self, "position", origin + Vector2(-strength * 0.7, strength * 0.3), 0.045)
	shake_tween.tween_property(self, "position", origin + Vector2(strength * 0.35, 0), 0.045)
	shake_tween.tween_property(self, "position", origin, 0.06).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _animate_projectile(
	origin: Vector2, destination: Vector2, kind: String, duration: float
) -> Signal:
	projectile_from = origin
	projectile_to = destination
	projectile_kind = kind
	projectile_progress = 0.0
	var tween := create_tween()
	tween.tween_method(_set_projectile_progress, 0.0, 1.0, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(_clear_projectile)
	return tween.finished

func _clear_projectile() -> void:
	projectile_kind = ""
	queue_redraw()

func _clear_unit_visual(unit_id: int) -> void:
	unit_visual_offsets.erase(unit_id)
	queue_redraw()

func _clear_unit_hit(unit_id: int) -> void:
	unit_flash_strength.erase(unit_id)
	_clear_unit_visual(unit_id)

func _clear_unit_defeat(unit_id: int) -> void:
	unit_defeat_strength.erase(unit_id)
	queue_redraw()

func _set_projectile_progress(value: float) -> void:
	projectile_progress = value
	queue_redraw()

func _set_unit_flash(value: float, unit_id: int) -> void:
	unit_flash_strength[unit_id] = value
	queue_redraw()

func _set_unit_defeat(value: float, unit_id: int) -> void:
	unit_defeat_strength[unit_id] = value
	queue_redraw()

func _set_unit_visual_offset(value: Vector2, unit_id: int) -> void:
	unit_visual_offsets[unit_id] = value
	queue_redraw()

func _set_unit_effect_strength(value: float, unit_id: int) -> void:
	if unit_effects.has(unit_id):
		unit_effects[unit_id].strength = value
	queue_redraw()

func _clear_unit_effect(unit_id: int) -> void:
	unit_effects.erase(unit_id)
	unit_effect_tweens.erase(unit_id)
	queue_redraw()

func _set_commander_effect_strength(value: float) -> void:
	commander_effect_strength = value
	queue_redraw()

func _clear_commander_effect() -> void:
	commander_effect_side = -1
	commander_effect_label = ""
	queue_redraw()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		hover_row = _row_at(event.position)
		hover_col = _col_at(event.position)
		_update_unit_hover(event.position)
		_update_opponent_hover(event.position)
		queue_redraw()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var cell := _cell_at(event.position)
		var row := cell.y
		var col := cell.x
		if enabled:
			var hit_unit := _unit_at_point(event.position)
			var selected_unit: Variant = _unit_by_id(selected_unit_id)
			var is_lane_destination := (
				selected_unit != null and cell.x == int(selected_unit.col)
			)
			# Enlarged silhouettes overlap adjacent lanes. During repositioning or
			# lane-targeting, the highlighted ground cell is the user's intent and
			# must win over a sprite whose transparent canvas reaches across it.
			if (
				selected_card.is_empty() and cell.x >= 0
				and (not targetable_rows.is_empty() or is_lane_destination)
			):
				board_cell_clicked.emit(row, col)
			elif selected_card.is_empty() and not hit_unit.is_empty():
				board_cell_clicked.emit(hit_unit.row, hit_unit.col)
			elif row >= 0 and col >= 0 and not selected_card.is_empty() and col == 0:
				deployment_clicked.emit(row)
			elif row >= 0 and col >= 0 and selected_card.is_empty():
				board_cell_clicked.emit(row, col)

func _row_at(point: Vector2) -> int:
	return _cell_at(point).y

func _col_at(point: Vector2) -> int:
	return _cell_at(point).x

func _cell_at(point: Vector2) -> Vector2i:
	if not _grid_rect().has_point(point):
		return Vector2i(-1, -1)
	for row in ROWS:
		for col in COLS:
			if Geometry2D.is_point_in_polygon(point, _cell_polygon(row, col)):
				return Vector2i(col, row)
	return Vector2i(-1, -1)

func _update_unit_hover(point: Vector2) -> void:
	var next_unit := _unit_at_point(point)
	if next_unit.is_empty():
		var cell := _cell_at(point)
		for unit in units:
			if cell.x >= 0 and unit.row == cell.y and unit.col == cell.x:
				next_unit = unit
				break

	var next_id: int = -1 if next_unit.is_empty() else next_unit.id
	if next_id == hover_unit_id:
		return
	hover_unit_id = next_id
	if next_unit.is_empty():
		unit_hover_ended.emit()
	else:
		unit_hovered.emit(next_unit)

func _grid_rect() -> Rect2:
	# Match the upper edge of the illustrated deck instead of projecting the
	# first lane into the skyline and rear scenery at taller resolutions.
	var grid_top := clampf(size.y * 0.34, GRID_MIN_TOP, GRID_MAX_TOP)
	var grid_height := maxf(1.0, size.y - grid_top - GRID_BOTTOM_MARGIN)
	var maximum_width := maxf(1.0, size.x - GRID_SIDE_GUTTER)
	var perspective_width := (grid_height / ROWS) * CELL_WIDTH_TO_DEPTH * COLS
	var grid_width := minf(maximum_width, perspective_width)
	return Rect2(
		Vector2((size.x - grid_width) * 0.5, grid_top),
		Vector2(grid_width, grid_height)
	)

func _cell_polygon(row: int, col: int, inset: float = 0.0) -> PackedVector2Array:
	var grid := _grid_rect()
	var top_depth: float = ROW_DEPTHS[row]
	var bottom_depth: float = ROW_DEPTHS[row + 1]
	var top_scale := lerpf(PERSPECTIVE_TOP_SCALE, 1.0, top_depth)
	var bottom_scale := lerpf(PERSPECTIVE_TOP_SCALE, 1.0, bottom_depth)
	var top_width := grid.size.x * top_scale
	var bottom_width := grid.size.x * bottom_scale
	var top_left := grid.get_center().x - top_width * 0.5
	var bottom_left := grid.get_center().x - bottom_width * 0.5
	var top_y := grid.position.y + grid.size.y * top_depth
	var bottom_y := grid.position.y + grid.size.y * bottom_depth
	var points := PackedVector2Array([
		Vector2(top_left + top_width * float(col) / COLS, top_y),
		Vector2(top_left + top_width * float(col + 1) / COLS, top_y),
		Vector2(bottom_left + bottom_width * float(col + 1) / COLS, bottom_y),
		Vector2(bottom_left + bottom_width * float(col) / COLS, bottom_y),
	])
	if inset > 0.0:
		var center := Vector2.ZERO
		for point in points:
			center += point
		center /= points.size()
		for index in points.size():
			points[index] = points[index].lerp(center, inset)
	return points

func _cell_rect(row: int, col: int) -> Rect2:
	var points := _cell_polygon(row, col)
	var rect := Rect2(points[0], Vector2.ZERO)
	for point in points:
		rect = rect.expand(point)
	return rect

func _cell_foot(row: int, col: int) -> Vector2:
	var points := _cell_polygon(row, col)
	return (points[2] + points[3]) * 0.5 - Vector2(0, UNIT_FOOT_INSET)

func _cell_visual_width(row: int, col: int) -> float:
	var points := _cell_polygon(row, col)
	return ((points[1] - points[0]).length() + (points[2] - points[3]).length()) * 0.5

func _unit_art_rect(unit: Dictionary) -> Rect2:
	var cell_width := _cell_visual_width(unit.row, unit.col)
	var art_size := cell_width * UNIT_ART_CELL_SCALE
	var foot := _cell_foot(unit.row, unit.col)
	foot += unit_visual_offsets.get(unit.id, Vector2.ZERO)
	return Rect2(foot - Vector2(art_size * 0.5, art_size), Vector2.ONE * art_size)

func _unit_at_point(point: Vector2) -> Dictionary:
	var layered_units := units.duplicate()
	layered_units.sort_custom(_unit_draws_before)
	layered_units.reverse()
	for unit in layered_units:
		var art_rect := _unit_art_rect(unit)
		var hit_rect := Rect2(
			Vector2(art_rect.get_center().x - art_rect.size.x * 0.35, art_rect.position.y),
			Vector2(art_rect.size.x * 0.70, art_rect.size.y)
		)
		if hit_rect.has_point(point):
			return unit
	return {}

func _draw_cell_shape(
	row: int, col: int, fill: Color, border: Color, width: float = 1.0, inset: float = 0.025
) -> void:
	var polygon := _cell_polygon(row, col, inset)
	draw_colored_polygon(polygon, fill)
	var outline := polygon.duplicate()
	outline.append(polygon[0])
	draw_polyline(outline, border, width, true)

func _draw_deployment_option(row: int, hovered: bool) -> void:
	var polygon := _cell_polygon(row, 0, 0.055)
	draw_colored_polygon(polygon, Color(DEPLOY_GREEN, 0.18))
	var outline := polygon.duplicate()
	outline.append(polygon[0])
	draw_polyline(
		outline, Color(DEPLOY_GREEN_BRIGHT, 0.72), 2.2 if hovered else 1.4, true
	)

func _draw_board_grid() -> void:
	# Default cells are only a faint positional guide. The generated floor stays
	# visually dominant, and the outer edge is deliberately left unlined so it
	# cannot cut across the environment at the top of the play area.
	for row in ROWS:
		for col in COLS:
			var polygon := _cell_polygon(row, col)
			var fill := (
				Color(0.80, 0.77, 0.67, 0.018)
				if (row + col) % 2 == 0
				else Color(0.075, 0.09, 0.10, 0.024)
			)
			if col == 0:
				fill = Color(0.24, 0.54, 0.57, 0.025)
			elif col == COLS - 1:
				fill = Color(0.58, 0.27, 0.27, 0.022)
			draw_colored_polygon(polygon, fill)

	# Draw each internal seam exactly once. Small endpoint insets keep the faint
	# lines from visually reconnecting into an implied perimeter border.
	for col in range(1, COLS):
		var top := _cell_polygon(0, col - 1)[1]
		var bottom := _cell_polygon(ROWS - 1, col - 1)[2]
		var seam_color := GRID_BRASS
		if col == 1:
			seam_color = GRID_PLAYER_ENAMEL
		elif col == COLS - 1:
			seam_color = GRID_ENEMY_ENAMEL
		draw_line(
			top.lerp(bottom, 0.022), bottom.lerp(top, 0.008),
			Color(seam_color, 0.24), 0.85, true
		)
	for row in range(1, ROWS):
		var left := _cell_polygon(row - 1, 0)[3]
		var right := _cell_polygon(row - 1, COLS - 1)[2]
		draw_line(
			left.lerp(right, 0.012), right.lerp(left, 0.012),
			Color(GRID_BRASS, 0.22), 0.85, true
		)

func _draw() -> void:
	var panel := Rect2(Vector2.ZERO, size)
	draw_texture_rect(_background_texture(), panel, false)
	# A light cool glaze seats the background behind the units without muting
	# the painted enamel values or turning the scene uniformly brown.
	draw_rect(panel, Color(0.035, 0.045, 0.055, 0.08))

	var grid := _grid_rect()
	_draw_board_grid()
	if not selected_card.is_empty() and enabled and targetable_unit_ids.is_empty():
		for row in ROWS:
			if (
				not _occupied(row, 0)
				and (guided_deployment_row < 0 or row == guided_deployment_row)
			):
				_draw_deployment_option(row, hover_row == row and hover_col == 0)
	for row in ROWS:
		for col in COLS:
			if BattleRulesScript.is_cell_blocked(blocked_cells, row, col):
				_draw_blocked_cell(row, col)
	if guided_deployment_row >= 0:
		var pulse := _guidance_pulse_amount()
		_draw_cell_shape(
			guided_deployment_row, 0,
			Color(DEPLOY_GREEN, 0.10 + pulse * 0.14),
			DEPLOY_GREEN_BRIGHT.lerp(Color.WHITE, pulse * 0.45),
			3.0 + pulse * 2.0,
			0.04
		)

	var event_width := minf(grid.size.x * 0.68, 620.0)
	var event_rect := Rect2(
		Vector2((size.x - event_width) * 0.5, 6),
		Vector2(event_width, 28)
	)
	draw_style_box(
		_box(Color(0.055, 0.06, 0.07, 0.72), Color(0.72, 0.54, 0.30, 0.68), 6, 1),
		event_rect
	)
	draw_string(
		get_theme_default_font(),
		event_rect.position + Vector2(0, 18),
		event_text,
		HORIZONTAL_ALIGNMENT_CENTER,
		event_rect.size.x,
		12,
		Color("#f4e6c7")
	)
	if not mission_objective_text.is_empty():
		var objective_rect := Rect2(
			Vector2((size.x - event_width) * 0.5, 37),
			Vector2(event_width, 20)
		)
		draw_string(
			get_theme_default_font(),
			objective_rect.position + Vector2(0, 14),
			mission_objective_text,
			HORIZONTAL_ALIGNMENT_CENTER,
			objective_rect.size.x,
			10,
			Color("#e8c77b")
		)
	_draw_opponent_identity()

	var preview_id: int = (
		-1 if not targetable_unit_ids.is_empty() or not targetable_rows.is_empty()
		else selected_unit_id if selected_unit_id >= 0
		else hover_unit_id
	)
	var preview_unit: Variant = _unit_by_id(preview_id)
	if preview_unit != null:
		_draw_action_preview(preview_unit)
	var deployment_preview := {}
	if (
		preview_unit == null and not selected_card.is_empty()
		and hover_row >= 0 and hover_col == 0 and not _occupied(hover_row, 0)
		and (guided_deployment_row < 0 or hover_row == guided_deployment_row)
		and targetable_unit_ids.is_empty() and targetable_rows.is_empty()
	):
		var projected_unit := selected_card.duplicate(true)
		projected_unit.side = 0
		projected_unit.row = hover_row
		projected_unit.col = 0
		deployment_preview = BattleRulesScript.projected_deployment(
			selected_card, hover_row, units, blocked_cells
		)
		_draw_action_preview_data(projected_unit, deployment_preview)

	_draw_commander(
		Vector2(82, grid.get_center().y), false, player_hp_text, player_deck_text
	)
	_draw_commander(
		Vector2(size.x - 82, grid.get_center().y), true, enemy_hp_text, enemy_deck_text
	)
	if commander_effect_side >= 0:
		_draw_commander_effect(
			Vector2(
				size.x - 82.0 if commander_effect_side == 1 else 82.0,
				grid.get_center().y
			)
		)
	_draw_mana_indicator(Vector2(82, grid.get_center().y - 92), player_mana_text, false)
	_draw_mana_indicator(Vector2(size.x - 82, grid.get_center().y - 92), enemy_mana_text, true)

	for unit in units:
		if unit.id == selected_unit_id:
			_draw_selection(unit)
		if unit.id in targetable_unit_ids:
			_draw_targetable(unit)
	var layered_units := units.duplicate()
	layered_units.sort_custom(_unit_draws_before)
	for unit in layered_units:
		_draw_unit(unit)
	for unit in layered_units:
		if unit.id in unit_effects:
			_draw_effect(unit)
	_draw_projectile()

	for target_row in targetable_rows:
		for col in COLS:
			_draw_cell_shape(
				target_row, col, Color(0.74, 0.50, 0.14, 0.14), Color("#d6aa5d"), 2.0
			)
		var lane_rect := Rect2(
			_cell_rect(target_row, 0).position,
			Vector2(grid.size.x, _cell_rect(target_row, 0).size.y)
		).grow(-10)
		draw_string(
			get_theme_default_font(),
			lane_rect.position + Vector2(0, 17),
			"SELECT LANE %d" % (target_row + 1),
			HORIZONTAL_ALIGNMENT_CENTER,
			lane_rect.size.x,
			12,
			Color("#fff0c2")
		)

	var selected_unit: Variant = _unit_by_id(selected_unit_id)
	if (
		selected_unit != null and enabled and targetable_unit_ids.is_empty()
		and not BattleRulesScript.is_taunted(selected_unit, units)
	):
		for target_row in ROWS:
			if (
				BattleRulesScript.can_reposition(
					selected_unit, target_row, units, blocked_cells
				)
				and (guided_reposition_row < 0 or target_row == guided_reposition_row)
			):
				var pulse := (
					_guidance_pulse_amount()
					if guided_reposition_row == target_row else 0.0
				)
				_draw_cell_shape(
					target_row, selected_unit.col,
					Color(0.2, 0.75, 0.85, 0.12 + pulse * 0.14),
					Color("#61e8ff").lerp(Color.WHITE, pulse * 0.45),
					3.0 + pulse * 2.0,
					0.06
				)

func _unit_draws_before(a: Dictionary, b: Dictionary) -> bool:
	var a_foot := _cell_foot(a.row, a.col).y
	var b_foot := _cell_foot(b.row, b.col).y
	if not is_equal_approx(a_foot, b_foot):
		return a_foot < b_foot
	return int(a.col) < int(b.col)

func _draw_opponent_identity() -> void:
	if opponent_name.is_empty():
		return
	var plaque := _opponent_plaque_rect()
	draw_style_box(
		_box(Color(0.055, 0.045, 0.055, 0.82), Color(0.93, 0.36, 0.52, 0.72), 6, 1),
		plaque
	)
	var font := get_theme_default_font()
	draw_string(
		font,
		plaque.position + Vector2(10, 14),
		opponent_name.to_upper(),
		HORIZONTAL_ALIGNMENT_RIGHT,
		plaque.size.x - 20,
		12,
		Color("#ffd6df")
	)
	draw_string(
		font,
		plaque.position + Vector2(10, 26),
		opponent_affiliation.to_upper(),
		HORIZONTAL_ALIGNMENT_RIGHT,
		plaque.size.x - 20,
		9,
		Color("#c8a9b5")
	)

func _draw_targetable(unit: Dictionary) -> void:
	var pulse := _guidance_pulse_amount() if guided_target_pulse else 0.0
	_draw_cell_shape(
		unit.row, unit.col,
		Color(1.0, 0.72, 0.18, 0.16 + pulse * 0.12),
		Color("#ffd166").lerp(Color.WHITE, pulse * 0.45),
		4.0 + pulse * 2.0,
		0.04
	)
	var rect := _cell_rect(unit.row, unit.col).grow(-5)
	var label_rect := Rect2(rect.position + Vector2(5, 5), Vector2(rect.size.x - 10, 18))
	draw_style_box(_box(Color(0.08, 0.07, 0.03, 0.88), Color("#ffd166"), 6, 1), label_rect)
	draw_string(
		get_theme_default_font(),
		label_rect.position + Vector2(0, 14),
		"SELECT TARGET",
		HORIZONTAL_ALIGNMENT_CENTER,
		label_rect.size.x,
		11,
		Color("#fff1b5")
	)

func _draw_commander(center: Vector2, enemy: bool, hp_text: String, deck_text: String) -> void:
	var color := Color("#ed5b86") if enemy else Color("#50d4e8")
	draw_circle(center, 48, Color(color, 0.12))
	draw_circle(center, 34, Color("#0c1529"))
	draw_arc(center, 35, 0, TAU, 40, color, 3)
	var font := get_theme_default_font()
	var hp_lines := hp_text.split("\n")
	var hp_value: String = hp_lines[0] if not hp_lines.is_empty() else "HP"
	draw_string(
		font, center + Vector2(-36, 5), hp_value,
		HORIZONTAL_ALIGNMENT_CENTER, 72, 16, Color("#f4f8ff")
	)
	if hp_lines.size() > 1:
		draw_string(
			font, center + Vector2(-36, 21), hp_lines[1],
			HORIZONTAL_ALIGNMENT_CENTER, 72, 9, Color("#ffd166")
		)
	draw_string(
		font,
		center + Vector2(-55, 58),
		"%s  ·  %s" % ["ENEMY" if enemy else "YOU", deck_text],
		HORIZONTAL_ALIGNMENT_CENTER,
		110,
		11,
		Color("#91a7ce")
	)

func _draw_mana_indicator(center: Vector2, value: String, enemy: bool) -> void:
	if value.is_empty():
		return
	var color := Color("#ff8ba8") if enemy else Color("#61e8ff")
	var rect := Rect2(center - Vector2(55, 26), Vector2(110, 52))
	draw_style_box(_box(Color(0.025, 0.05, 0.11, 0.86), color, 9, 2), rect)
	draw_string(
		get_theme_default_font(), rect.position + Vector2(0, 15), "MANA",
		HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 10, color
	)
	var lines := value.split("\n")
	draw_string(
		get_theme_default_font(), rect.position + Vector2(0, 32), lines[0],
		HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 14, Color("#fff1b5")
	)
	if lines.size() > 1:
		draw_string(
			get_theme_default_font(), rect.position + Vector2(0, 46), lines[1],
			HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 9, Color("#91a7ce")
		)

func _draw_unit(unit: Dictionary) -> void:
	var cell_rect := _cell_rect(unit.row, unit.col)
	var cell_width := _cell_visual_width(unit.row, unit.col)
	var visual_offset: Vector2 = unit_visual_offsets.get(unit.id, Vector2.ZERO)
	var foot := _cell_foot(unit.row, unit.col) + visual_offset
	var footprint_rect := Rect2(
		Vector2(foot.x - cell_width * 0.5, foot.y - cell_rect.size.y),
		Vector2(cell_width, cell_rect.size.y)
	)
	var art_rect := _unit_art_rect(unit)
	var art_size := art_rect.size.y
	var color: Color = UnitCatalogScript.class_color(unit.kind)
	var ready_pulse := _readiness_pulse_amount(unit)
	var ring_fill_alpha := 0.055
	var ring_line_alpha := 0.14
	var ring_width := 1.0
	if unit.get("ready", true) and int(unit.get("hp", 1)) > 0:
		ring_fill_alpha = 0.07 + ready_pulse * 0.035
		ring_line_alpha = 0.20 + ready_pulse * 0.08
		ring_width = 1.2 + ready_pulse * 0.25

	# The cell is only the unit's footprint. The art intentionally reaches into
	# neighboring rows and columns, like figures standing together on a field.
	draw_set_transform(foot - Vector2(0, 3), 0.0, Vector2(1.0, 0.30))
	draw_circle(Vector2.ZERO, cell_width * 0.40, Color(color, ring_fill_alpha))
	draw_arc(
		Vector2.ZERO, cell_width * 0.40, 0, TAU, 28,
		Color(color, ring_line_alpha), ring_width
	)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	_draw_unit_shadow(footprint_rect)
	_draw_unit_art(unit, art_rect)
	var flash: float = unit_flash_strength.get(unit.id, 0.0)
	if flash > 0.0:
		draw_style_box(
			_box(Color(1, 1, 1, flash * 0.34), Color(1, 1, 1, flash * 0.72), 10, 2),
			footprint_rect.grow(-2)
		)
	var font := get_theme_default_font()
	var hp_text := "%d" % unit.hp
	var atk_text := "%d" % unit.atk
	var pill_size := Vector2(minf(34.0, cell_width * 0.32), 20.0)
	var pill_y := foot.y - pill_size.y - 1.0
	var health_pill := Rect2(
		Vector2(foot.x - cell_width * 0.39, pill_y), pill_size
	)
	var attack_pill := Rect2(
		Vector2(foot.x + cell_width * 0.39 - pill_size.x, pill_y), pill_size
	)
	draw_style_box(
		_box(Color("#3f7554"), Color("#91b886"), 10, 1),
		health_pill
	)
	draw_style_box(
		_box(Color("#9b4145"), Color("#d08076"), 10, 1),
		attack_pill
	)
	draw_string(
		font,
		health_pill.position + Vector2(0, 15),
		hp_text,
		HORIZONTAL_ALIGNMENT_CENTER,
		health_pill.size.x,
		12,
		Color.WHITE
	)
	draw_string(
		font,
		attack_pill.position + Vector2(0, 15),
		atk_text,
		HORIZONTAL_ALIGNMENT_CENTER,
		attack_pill.size.x,
		12,
		Color.WHITE
	)
	_draw_protect_aura(unit, footprint_rect)
	var badge_rect := Rect2(
		Vector2(foot.x - cell_width * 0.5, maxf(38.0, art_rect.position.y + 6.0)),
		Vector2(cell_width, art_size)
	)
	_draw_status_badges(unit, badge_rect)

	if not unit.ready:
		var rest_rect := Rect2(
			Vector2(foot.x - cell_width * 0.42, foot.y - 40),
			Vector2(cell_width * 0.84, 20)
		)
		draw_style_box(
			_box(Color(0.05, 0.08, 0.15, 0.48), Color.TRANSPARENT, 10, 0),
			rest_rect
		)
		draw_string(font, rest_rect.position + Vector2(0, 14), "RESTING", HORIZONTAL_ALIGNMENT_CENTER, rest_rect.size.x, 10, Color("#b8c2d9"))
	var defeat: float = unit_defeat_strength.get(unit.id, 0.0)
	if defeat > 0.0:
		draw_style_box(
			_box(Color(0.025, 0.04, 0.08, defeat * 0.94), Color(color, 1.0 - defeat), 10, 1),
			footprint_rect.grow(-2)
		)
		for slice in 4:
			var slice_y := footprint_rect.position.y + footprint_rect.size.y * (float(slice + 1) / 5.0)
			draw_line(
				Vector2(footprint_rect.position.x + defeat * 12.0, slice_y),
				Vector2(footprint_rect.end.x - defeat * 12.0, slice_y),
				Color(color, defeat * 0.55),
				1
			)

func _draw_projectile() -> void:
	if projectile_kind.is_empty():
		return
	var projectile_position := projectile_from.lerp(projectile_to, projectile_progress)
	var color := Color("#70e0a1")
	var radius := 7.0
	if projectile_kind in ["Artillerist", "Transport"]:
		color = Color("#ffd166")
		radius = 5.0
		draw_line(projectile_from, projectile_position, Color(color, 0.42), 3)
	elif projectile_kind == "Channeler":
		color = Color("#c99cff")
		radius = 10.0
	elif projectile_kind == "Heal":
		color = Color("#70e0a1")
		radius = 9.0
	else:
		color = Color("#ff8fbd")
	draw_circle(projectile_position, radius + 5, Color(color, 0.14))
	draw_circle(projectile_position, radius, Color(color, 0.88))
	draw_arc(projectile_position, radius + 3, 0, TAU, 18, color, 2)

## Bluish ring around a Protected unit so the status reads at a glance,
## complementing the S-badge in _draw_status_badges.
func _draw_protect_aura(unit: Dictionary, rect: Rect2) -> void:
	if unit.get("protect_turns", 0) <= 0:
		return
	var center := rect.get_center()
	var radius := maxf(rect.size.x, rect.size.y) * 0.58
	var color := Color("#71e6f5")
	draw_circle(center, radius, Color(color, 0.10))
	draw_arc(center, radius, 0, TAU, 36, Color(color, 0.62), 2.5)
	draw_arc(center, radius - 5, 0, TAU, 36, Color(color, 0.28), 1.5)

func _draw_status_badges(unit: Dictionary, rect: Rect2) -> void:
	var badges: Array = []
	if unit.get("mission_role", "") == "priority":
		badges.append({"label": "!", "color": Color("#ff668f")})
	elif unit.get("mission_role", "") == "protected":
		badges.append({"label": "◆", "color": Color("#67e6f4")})
	if unit.get("taunt_turns", 0) > 0:
		badges.append({"label": "T%d" % unit.taunt_turns, "color": Color("#ff9d66")})
	if unit.get("immobilized_turns", 0) > 0:
		badges.append({"label": "I%d" % unit.immobilized_turns, "color": Color("#c99cff")})
	if unit.get("poison_turns", 0) > 0:
		# Permanent Poison (Deployment Snare) shows no countdown, like ST/H.
		var poison_label := "P%d" % unit.poison_turns
		if unit.poison_turns >= UnitSkillsScript.PERMANENT_POISON_TURNS:
			poison_label = "P"
		badges.append({"label": poison_label, "color": Color("#8ee36b")})
	if unit.get("vulnerable_turns", 0) > 0:
		var vulnerable_label := "V%d" % unit.vulnerable_turns
		if unit.get("vulnerable_stacks", 1) > 1:
			vulnerable_label = "V%dx%d" % [unit.vulnerable_turns, unit.vulnerable_stacks]
		badges.append({
			"label": vulnerable_label,
			"color": Color("#ef8b72")
		})
	if unit.get("protect_turns", 0) > 0:
		badges.append({"label": "S%d" % unit.protect_turns, "color": Color("#71e6f5")})
	if unit.get("regen_turns", 0) > 0:
		badges.append({"label": "R%d" % unit.regen_turns, "color": Color("#8ee36b")})
	if unit.get("stun_turns", 0) > 0:
		badges.append({"label": "ST", "color": Color("#ffd166")})
	if unit.get("silenced_turns", 0) > 0:
		badges.append({"label": "SI%d" % unit.silenced_turns, "color": Color("#a8b8ff")})
	if unit.get("haste_turns", 0) > 0:
		badges.append({"label": "H", "color": Color("#f2c44f")})
	if unit.get("doom_turns", 0) > 0:
		badges.append({"label": "D%d" % unit.doom_turns, "color": Color("#ff668f")})
	if unit.get("summon_forth_turns", 0) > 0:
		badges.append({"label": "SM%d" % unit.summon_forth_turns, "color": Color("#e6a8ff")})
	if unit.get("fury_stacks", 0) > 0:
		badges.append({"label": "F%d" % unit.fury_stacks, "color": Color("#ffd166")})
	for effect in unit.get("effects", []):
		var attack: int = effect.get("attack", 0)
		var health: int = effect.get("health", 0)
		var prefix := "+A" if attack > 0 else ("-A" if attack < 0 else ("+H" if health > 0 else "-H"))
		var label := "%s%d" % [prefix, effect.get("turns", 0)]
		var color := Color("#70e0a1") if attack >= 0 and health >= 0 else Color("#ff8f8f")
		badges.append({"label": label, "color": color})
	for index in mini(5, badges.size()):
		var center := Vector2(rect.position.x + 11 + index * 20, rect.position.y + 11)
		draw_circle(center, 9, Color(0.03, 0.05, 0.10, 0.92))
		draw_arc(center, 9, 0, TAU, 16, badges[index].color, 2)
		draw_string(
			get_theme_default_font(),
			center + Vector2(-8, 4),
			badges[index].label,
			HORIZONTAL_ALIGNMENT_CENTER,
			16,
			9,
			badges[index].color
		)

func _readiness_pulse_amount(unit: Dictionary) -> float:
	if (
		not unit.get("ready", true) or unit_defeat_strength.has(unit.id)
		or int(unit.get("hp", 1)) <= 0
	):
		return 0.0
	if reduced_motion or not idle_animation_enabled:
		return 0.5
	# A long, offset cycle keeps the readiness rings from pulsing in lockstep.
	var phase := fposmod(float(int(unit.get("id", 0))) * 1.618, TAU)
	return (sin(idle_time * READY_PULSE_FREQUENCY * TAU + phase) + 1.0) * 0.5

func _draw_unit_shadow(rect: Rect2) -> void:
	# Two restrained, fixed ellipses ground the feet without implying a bounce.
	var shadow_center := Vector2(rect.get_center().x, rect.end.y - 4.0)
	var outer_half_width := rect.size.x * 0.24
	draw_set_transform(shadow_center, 0.0, Vector2(1.0, 0.14))
	draw_circle(Vector2.ZERO, outer_half_width, Color(0.02, 0.03, 0.06, 0.08))
	var inner_half_width := rect.size.x * 0.18
	draw_set_transform(shadow_center, 0.0, Vector2(1.0, 0.12))
	draw_circle(Vector2.ZERO, inner_half_width, Color(0.02, 0.03, 0.06, 0.13))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _draw_unit_art(unit: Dictionary, rect: Rect2) -> void:
	var icon_id: int = unit.get("icon", 0)
	if icon_id < 1:
		return
	var texture: Texture2D = _full_unit_texture(icon_id)
	if texture == null:
		_draw_missing_unit_art(unit, rect)
		return
	# Use the full generated canvas so deliberately small characters remain
	# relatively small instead of being normalized by alpha-bound cropping.
	var content_rect := Rect2(Vector2.ZERO, texture.get_size())
	var content_size := content_rect.size
	var art_scale := minf(rect.size.x / content_size.x, rect.size.y / content_size.y)
	var draw_size := (content_size * art_scale).round()
	var center := rect.get_center().round()
	# Generated runtime sprites face right; mirror the enemy so both sides face
	# toward the opposing Conductor.
	var scale_x := 1.0 if unit.side == 0 else -1.0
	draw_set_transform(center, 0.0, Vector2(scale_x, 1.0))
	draw_texture_rect_region(
		texture,
		Rect2(-draw_size * 0.5, draw_size),
		content_rect
	)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _draw_missing_unit_art(unit: Dictionary, rect: Rect2) -> void:
	var center := rect.get_center()
	var glyph_radius := minf(rect.size.x, rect.size.y) * 0.27
	var color: Color = UnitCatalogScript.class_color(unit.get("kind", "Warden"))
	draw_circle(center, glyph_radius, Color(color, 0.22))
	draw_arc(center, glyph_radius, 0.0, TAU, 6, color, 3.0)
	draw_line(
		center - Vector2(glyph_radius * 0.45, 0),
		center + Vector2(glyph_radius * 0.45, 0),
		color,
		2.0
	)

func _full_unit_texture(icon_id: int) -> Texture2D:
	if full_unit_texture_cache.has(icon_id):
		return full_unit_texture_cache[icon_id]
	var path := "res://assets/units/full/%03d.png" % UnitCatalogScript.art_id(icon_id)
	var texture := load(path) as Texture2D
	full_unit_texture_cache[icon_id] = texture
	return texture

func _draw_effect(unit: Dictionary) -> void:
	var effect: Dictionary = unit_effects.get(unit.id, {})
	if effect.is_empty():
		return
	var strength: float = effect.strength
	var color: Color = effect.color
	var rect := _cell_rect(unit.row, unit.col).grow(-5.0)
	var center := rect.get_center()
	var radius := minf(rect.size.x, rect.size.y) * (0.35 + (1.0 - strength) * 0.18)
	draw_circle(center, radius, Color(color, strength * 0.22), false, 4)
	draw_arc(center, radius, 0, TAU, 32, Color(color, strength), 4)
	draw_string(
		get_theme_default_font(),
		Vector2(rect.position.x, rect.position.y - 4 - (1.0 - strength) * 18),
		effect.label,
		HORIZONTAL_ALIGNMENT_CENTER,
		rect.size.x,
		14,
		Color(color, strength)
	)

func _draw_commander_effect(center: Vector2) -> void:
	var strength := commander_effect_strength
	var color := commander_effect_color
	var radius := 42.0 + (1.0 - strength) * 14.0
	draw_arc(center, radius, 0, TAU, 32, Color(color, strength), 4)
	draw_string(
		get_theme_default_font(),
		center + Vector2(-58, -50 - (1.0 - strength) * 18),
		commander_effect_label,
		HORIZONTAL_ALIGNMENT_CENTER,
		116,
		15,
		Color(color, strength)
	)

func _draw_selection(unit: Dictionary) -> void:
	_draw_cell_shape(
		unit.row, unit.col,
		Color(0.25, 0.8, 0.9, 0.08), Color("#71e6f5"), 3.0, 0.04
	)

func _draw_action_preview(unit: Dictionary) -> void:
	var preview: Dictionary = BattleRulesScript.projected_action(
		unit.id, units, blocked_cells
	)
	_draw_action_preview_data(unit, preview)

func _draw_action_preview_data(unit: Dictionary, preview: Dictionary) -> void:
	var direction := 1 if unit.side == 0 else -1
	for cell in preview.attack:
		var occupied_target := _enemy_at(unit, cell.y, cell.x)
		var fill := Color(0.94, 0.31, 0.43, 0.24 if occupied_target else 0.09)
		var width := 3 if occupied_target else 2
		_draw_cell_shape(cell.y, cell.x, fill, Color("#ff667e"), width, 0.07)

	for cell in preview.traversal:
		_draw_cell_shape(
			cell.y, cell.x, Color(0.2, 0.75, 0.9, 0.14), Color("#4ec9e8"), 2.0, 0.10
		)
		var move_rect := _cell_rect(cell.y, cell.x).grow(-12)
		var center := move_rect.get_center()
		var arrow := "›" if direction > 0 else "‹"
		draw_string(
			get_theme_default_font(),
			center + Vector2(-12, 8),
			arrow,
			HORIZONTAL_ALIGNMENT_CENTER,
			24,
			20,
			Color("#71e6f5")
		)

func _enemy_at(unit: Dictionary, row: int, col: int) -> bool:
	for other in units:
		if other.side != unit.side and other.row == row and other.col == col:
			return true
	return false

func _occupied(row: int, col: int) -> bool:
	if BattleRulesScript.is_cell_blocked(blocked_cells, row, col):
		return true
	for unit in units:
		if unit.row == row and unit.col == col:
			return true
	return false

func _draw_blocked_cell(row: int, col: int) -> void:
	var polygon := _cell_polygon(row, col, 0.08)
	draw_colored_polygon(polygon, Color(0.035, 0.035, 0.04, 0.84))
	var rect := _cell_rect(row, col).grow(-10)
	draw_line(rect.position, rect.end, Color("#d2a05c"), 3.0, true)
	draw_line(
		Vector2(rect.end.x, rect.position.y),
		Vector2(rect.position.x, rect.end.y),
		Color("#d2a05c"), 3.0, true
	)
	draw_string(
		get_theme_default_font(), rect.position + Vector2(0, 14),
		"BLOCKED", HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 9,
		Color("#f0d7a5")
	)

func _unit_by_id(unit_id: int):
	for unit in units:
		if unit.id == unit_id:
			return unit
	return null

func _box(fill: Color, border: Color, radius: int, width: int) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = fill
	box.border_color = border
	box.set_border_width_all(width)
	box.set_corner_radius_all(radius)
	return box
