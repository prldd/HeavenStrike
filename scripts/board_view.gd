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
signal opponent_clicked

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
const VFX_INK := Color("#302b28")
const VFX_STEEL := Color("#a9aaa4")
const VFX_HIGHLIGHT := Color("#fff0c8")
const VFX_BRASS := Color("#b58a45")
const VFX_EMBER := Color("#d66f38")
const VFX_SMOKE := Color("#665e55")
const VFX_STEAM := Color("#d9d0bc")
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
var attack_effect: Dictionary = {}
var attack_effect_progress := 0.0
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
	actor_id: int, target_id: int, unit_kind: String, duration: float = 0.24,
	strike_index: int = 0, strike_count: int = 1
) -> Signal:
	var actor = _unit_by_id(actor_id)
	var target = _unit_by_id(target_id)
	if actor == null or target == null:
		return get_tree().process_frame
	var origin := _unit_art_rect(actor).get_center()
	var destination := _unit_art_rect(target).get_center()
	var effect_cells := attack_effect_cells(actor, target, unit_kind)
	var impact_cells := _attack_impact_cells(actor, target, unit_kind, effect_cells)
	_animate_attack_pose(actor_id, unit_kind, origin, destination, duration, strike_index)
	return _animate_attack_effect(
		origin, destination, unit_kind, effect_cells, impact_cells, duration,
		strike_index, strike_count, false
	)

func animate_commander_attack(
	actor_id: int, commander_side: int, unit_kind: String, duration: float = 0.26,
	strike_index: int = 0, strike_count: int = 1
) -> Signal:
	var actor = _unit_by_id(actor_id)
	if actor == null:
		return get_tree().process_frame
	var origin := _unit_art_rect(actor).get_center()
	var destination := Vector2(
		size.x - 82.0 if commander_side == 1 else 82.0,
		_grid_rect().get_center().y
	)
	_animate_attack_pose(actor_id, unit_kind, origin, destination, duration, strike_index)
	return _animate_attack_effect(
		origin, destination, unit_kind, [], [], duration,
		strike_index, strike_count, true
	)

## Returns the spatial path used to stage a class animation. Rail Volley crosses
## every authored range cell; Arc Burst uses the primary impact and its adjacent
## blast coordinates. These cells remain internal and are never drawn as UI.
func attack_effect_cells(actor: Dictionary, target: Dictionary, unit_kind: String) -> Array:
	var target_cell := Vector2i(target.col, target.row)
	var cells: Array = (
		BattleRulesScript.attack_cells(actor)
		if unit_kind == "Artillerist" else [target_cell]
	)
	if unit_kind == "Channeler":
		for cell in BattleRulesScript.blast_cells(target):
			if cell != Vector2i(actor.col, actor.row) and cell not in cells:
				cells.append(cell)
	return cells

func _attack_impact_cells(
	actor: Dictionary, target: Dictionary, unit_kind: String, effect_cells: Array
) -> Array:
	var impact_cells: Array = [Vector2i(target.col, target.row)]
	if unit_kind not in ["Artillerist", "Channeler"]:
		return impact_cells
	var splash_cells: Array = BattleRulesScript.blast_cells(target)
	for unit in units:
		if unit.id == target.id or unit.side == actor.side:
			continue
		var cell := Vector2i(unit.col, unit.row)
		if (
			unit_kind == "Artillerist" and cell in effect_cells
			or unit_kind == "Channeler" and cell in splash_cells
		):
			impact_cells.append(cell)
	return impact_cells

func _attack_cell_center(cell: Vector2i) -> Vector2:
	for unit in units:
		if unit.row == cell.y and unit.col == cell.x:
			return _unit_art_rect(unit).get_center()
	return _cell_rect(cell.y, cell.x).get_center()

func _animate_attack_pose(
	actor_id: int, unit_kind: String, origin: Vector2, destination: Vector2,
	duration: float, strike_index: int
) -> void:
	var direction := (destination - origin).normalized()
	var motion_scale := 0.3 if reduced_motion else 1.0
	var windup_distance := 7.0
	var strike_distance := 15.0
	match unit_kind:
		"Strider":
			windup_distance = 9.0
			strike_distance = 30.0
		"Duelist":
			windup_distance = 12.0
			strike_distance = 27.0
		"Warden":
			windup_distance = 6.0
			strike_distance = 19.0
		"Artillerist":
			windup_distance = -10.0
			strike_distance = -4.0
		"Channeler":
			windup_distance = 5.0
			strike_distance = 10.0
		"Lifebinder":
			windup_distance = 4.0
			strike_distance = 8.0
		_:
			windup_distance = 5.0
			strike_distance = 10.0
	var perpendicular := Vector2(-direction.y, direction.x)
	var twin_offset := 0.0
	if unit_kind == "Strider":
		twin_offset = (-6.0 if strike_index % 2 == 0 else 6.0) * motion_scale
	var windup := -direction * windup_distance * motion_scale + perpendicular * twin_offset
	var strike := direction * strike_distance * motion_scale - perpendicular * twin_offset * 0.45
	var tween := create_tween()
	tween.tween_method(
		_set_unit_visual_offset.bind(actor_id), Vector2.ZERO, windup, duration * 0.32
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_method(
		_set_unit_visual_offset.bind(actor_id), windup, strike, duration * 0.25
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_method(
		_set_unit_visual_offset.bind(actor_id), strike, Vector2.ZERO, duration * 0.43
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_callback(_clear_unit_visual.bind(actor_id))

func _animate_attack_effect(
	origin: Vector2, destination: Vector2, unit_kind: String, cells: Array,
	impact_cells: Array, duration: float, strike_index: int,
	strike_count: int, commander: bool
) -> Signal:
	attack_effect = {
		"origin": origin,
		"destination": destination,
		"kind": unit_kind,
		"cells": cells.duplicate(),
		"impact_cells": impact_cells.duplicate(),
		"strike_index": strike_index,
		"strike_count": maxi(1, strike_count),
		"commander": commander
	}
	attack_effect_progress = 0.0
	queue_redraw()
	var tween := create_tween()
	tween.tween_method(
		_set_attack_effect_progress, 0.0, 1.0, duration
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(_clear_attack_effect)
	return tween.finished

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

func animate_hits(unit_ids: Array, duration: float = 0.18) -> Signal:
	var animated_ids: Array = []
	for unit_id in unit_ids:
		if unit_id in animated_ids or _unit_by_id(unit_id) == null:
			continue
		animated_ids.append(unit_id)
		animate_hit(unit_id, duration)
	if animated_ids.is_empty():
		return get_tree().process_frame
	return get_tree().create_timer(duration, false).timeout

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

func _set_attack_effect_progress(value: float) -> void:
	attack_effect_progress = value
	queue_redraw()

func _clear_attack_effect() -> void:
	attack_effect = {}
	attack_effect_progress = 0.0
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
		if (
			enabled and not opponent_name.is_empty()
			and _opponent_plaque_rect().has_point(event.position)
		):
			opponent_clicked.emit()
			return
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
	_draw_attack_effect()
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

func _draw_attack_effect() -> void:
	if attack_effect.is_empty():
		return
	var progress := attack_effect_progress
	var kind: String = attack_effect.get("kind", "")
	var origin: Vector2 = attack_effect.get("origin", Vector2.ZERO)
	var destination: Vector2 = attack_effect.get("destination", Vector2.ZERO)
	var cells: Array = attack_effect.get("cells", [])
	var impact_cells: Array = attack_effect.get("impact_cells", [])
	var strike_index: int = attack_effect.get("strike_index", 0)
	match kind:
		"Strider":
			_draw_strider_attack(destination, progress, strike_index)
		"Duelist":
			_draw_duelist_attack(origin, destination, progress)
		"Warden":
			_draw_warden_attack(origin, destination, progress)
		"Artillerist", "Transport":
			_draw_artillerist_attack(
				origin, destination, cells, impact_cells, progress
			)
		"Channeler":
			_draw_channeler_attack(origin, destination, impact_cells, progress)
		"Lifebinder":
			_draw_lifebinder_attack(origin, destination, progress)
		_:
			_draw_lifebinder_attack(origin, destination, progress)

func _draw_strider_attack(
	destination: Vector2, progress: float, strike_index: int
) -> void:
	var sweep := clampf((progress - 0.16) * 2.5, 0.0, 1.0)
	var strength := sin(sweep * PI)
	if strength <= 0.0:
		return
	var second_blade := strike_index % 2 == 1
	var start_angle := -2.55 if not second_blade else -0.45
	var end_angle := start_angle + PI * 1.18 * sweep
	var radius := 30.0 + sweep * 13.0
	# Dark painted edge, steel body, and a narrow hot glint make this read as
	# a physical blade crossing the chassis rather than a colored UI streak.
	draw_arc(
		destination, radius, start_angle, end_angle, 24,
		Color(VFX_INK, strength * 0.78), 10.0, true
	)
	draw_arc(
		destination, radius, start_angle, end_angle, 24,
		Color(VFX_STEEL, strength), 6.0, true
	)
	draw_arc(
		destination, radius - 2.0, start_angle, end_angle, 24,
		Color(VFX_HIGHLIGHT, strength * 0.92), 2.0, true
	)
	var slash_direction := Vector2(0.62, 0.78)
	if second_blade:
		slash_direction.x *= -1.0
	var slash_normal := Vector2(-slash_direction.y, slash_direction.x)
	var slash_length := 42.0 + sweep * 15.0
	var painted_trail := PackedVector2Array([
		destination - slash_direction * slash_length + slash_normal * 8.0,
		destination + slash_direction * slash_length + slash_normal * 2.0,
		destination + slash_direction * slash_length - slash_normal * 2.0,
		destination - slash_direction * slash_length - slash_normal * 8.0,
	])
	draw_colored_polygon(painted_trail, Color(VFX_STEEL, strength * 0.48))
	draw_line(
		destination - slash_direction * slash_length,
		destination + slash_direction * slash_length,
		Color(VFX_INK, strength * 0.72), 9.0, true
	)
	draw_line(
		destination - slash_direction * slash_length * 0.92,
		destination + slash_direction * slash_length * 0.92,
		Color(VFX_HIGHLIGHT, strength), 3.0, true
	)
	_draw_sparks(destination, sweep, 0.85)

func _draw_duelist_attack(origin: Vector2, destination: Vector2, progress: float) -> void:
	var direction := (destination - origin).normalized()
	var center := destination - direction * 7.0
	var sweep := clampf((progress - 0.12) * 1.85, 0.0, 1.0)
	var strength := sin(sweep * PI)
	var angle := direction.angle()
	draw_arc(
		center, 34.0 + sweep * 18.0, angle - 1.65, angle - 1.65 + sweep * 3.3,
		30, Color(VFX_INK, strength * 0.72), 13.0, true
	)
	draw_arc(
		center, 34.0 + sweep * 18.0, angle - 1.65, angle - 1.65 + sweep * 3.3,
		30, Color(VFX_BRASS, strength * 0.92), 8.0, true
	)
	draw_arc(
		center, 31.0 + sweep * 18.0, angle - 1.58, angle - 1.58 + sweep * 3.15,
		28, Color(VFX_HIGHLIGHT, strength), 2.5, true
	)
	_draw_sparks(destination + direction * 5.0, sweep, 1.0)

func _draw_warden_attack(origin: Vector2, destination: Vector2, progress: float) -> void:
	var direction := (destination - origin).normalized()
	var charge := clampf(progress / 0.48, 0.0, 1.0)
	var charge_fade := clampf((0.62 - progress) * 4.0, 0.0, 1.0)
	var ram_end := origin.lerp(destination, charge)
	draw_line(
		origin, ram_end, Color(VFX_INK, charge_fade * 0.74), 13.0, true
	)
	draw_line(
		origin, ram_end, Color(VFX_STEEL, charge_fade), 7.0, true
	)
	for collar in 3:
		var collar_center := ram_end - direction * float(collar * 8)
		draw_circle(collar_center, 4.5, Color(VFX_BRASS, charge_fade * 0.9))
	var impact := clampf((progress - 0.42) / 0.58, 0.0, 1.0)
	_draw_impact_cracks(destination, impact, 1.15)
	var shock_strength := sin(impact * PI)
	draw_arc(
		destination + Vector2(0, 10), 14.0 + impact * 48.0, 0, TAU,
		30, Color(VFX_BRASS, shock_strength * 0.58), 4.0, true
	)
	_draw_smoke_burst(destination, impact, 1.0)
	_draw_sparks(destination, impact, 1.1)

func _draw_artillerist_attack(
	origin: Vector2, destination: Vector2, cells: Array,
	impact_cells: Array, progress: float
) -> void:
	var rail_end := destination
	if not cells.is_empty():
		var last_cell: Vector2i = cells[-1]
		rail_end = Vector2(_cell_rect(last_cell.y, last_cell.x).get_center().x, origin.y)
	var direction := (rail_end - origin).normalized()
	var perpendicular := Vector2(-direction.y, direction.x)
	var raw_travel := (progress - 0.08) / 0.62
	var travel := clampf(raw_travel, 0.0, 1.0)
	var bullet := origin.lerp(rail_end, travel)
	var tracer_start := origin.lerp(rail_end, maxf(0.0, travel - 0.18))
	var shot_fade := clampf((0.82 - progress) * 3.8, 0.0, 1.0)
	var muzzle_phase := clampf(progress / 0.24, 0.0, 1.0)
	_draw_muzzle_flash(origin, direction, muzzle_phase)
	draw_line(tracer_start, bullet, Color(VFX_INK, shot_fade * 0.82), 7.0, true)
	draw_line(tracer_start, bullet, Color(VFX_BRASS, shot_fade), 3.5, true)
	draw_line(tracer_start, bullet, Color(VFX_HIGHLIGHT, shot_fade), 1.2, true)
	for wake_index in 4:
		var wake_travel := maxf(0.0, travel - 0.045 * float(wake_index + 1))
		var wake_center := origin.lerp(rail_end, wake_travel)
		var wake_alpha := shot_fade * (0.22 - float(wake_index) * 0.04)
		draw_circle(
			wake_center, 4.5 + float(wake_index) * 1.6,
			Color(VFX_SMOKE, wake_alpha)
		)
	var bullet_points := PackedVector2Array([
		bullet + direction * 13.0,
		bullet + perpendicular * 4.5,
		bullet - direction * 9.0,
		bullet - perpendicular * 4.5,
	])
	draw_colored_polygon(bullet_points, Color(VFX_HIGHLIGHT, shot_fade))
	var total_distance := maxf(origin.distance_to(rail_end), 1.0)
	if impact_cells.is_empty():
		impact_cells = [destination]
	for cell_value in impact_cells:
		var impact_center: Vector2
		if cell_value is Vector2i:
			impact_center = _attack_cell_center(cell_value)
		else:
			impact_center = cell_value
		var hit_ratio := origin.distance_to(impact_center) / total_distance
		var impact_phase := clampf((raw_travel - hit_ratio) * 2.0, 0.0, 0.999)
		_draw_sparks(impact_center, impact_phase, 1.05)
		_draw_smoke_burst(impact_center, impact_phase, 0.62)

func _draw_channeler_attack(
	origin: Vector2, destination: Vector2, impact_cells: Array, progress: float
) -> void:
	var travel := clampf(progress / 0.46, 0.0, 1.0)
	var orb := origin.lerp(destination, travel)
	var travel_fade := clampf((0.55 - progress) * 4.8, 0.0, 1.0)
	var trail_start := origin.lerp(destination, maxf(0.0, travel - 0.16))
	draw_line(trail_start, orb, Color(VFX_INK, travel_fade * 0.7), 7.0, true)
	draw_line(trail_start, orb, Color(VFX_BRASS, travel_fade), 3.0, true)
	draw_circle(orb, 10.0, Color(VFX_INK, travel_fade))
	draw_arc(orb, 13.0, progress * 10.0, progress * 10.0 + PI * 1.6, 18,
		Color(VFX_HIGHLIGHT, travel_fade), 3.0)
	for satellite in 3:
		var angle := progress * 13.0 + float(satellite) * TAU / 3.0
		draw_circle(
			orb + Vector2.from_angle(angle) * 16.0, 3.0,
			Color(VFX_BRASS, travel_fade)
		)
	var burst := clampf((progress - 0.40) / 0.60, 0.0, 1.0)
	if impact_cells.is_empty():
		impact_cells = [destination]
	for index in impact_cells.size():
		var cell_value = impact_cells[index]
		var center: Vector2
		if cell_value is Vector2i:
			center = _attack_cell_center(cell_value)
		else:
			center = cell_value
		var local_burst := clampf(burst * 1.35 - float(index) * 0.08, 0.0, 1.0)
		_draw_explosion(center, local_burst, 1.18 if index == 0 else 0.82)

func _draw_lifebinder_attack(origin: Vector2, destination: Vector2, progress: float) -> void:
	var travel := clampf((progress - 0.05) / 0.66, 0.0, 1.0)
	var direction := (destination - origin).normalized()
	var perpendicular := Vector2(-direction.y, direction.x)
	var fade := clampf((0.84 - progress) * 4.0, 0.0, 1.0)
	for strand in [-1.0, 0.0, 1.0]:
		var phase_offset: float = strand * 0.055
		var needle_travel := clampf(travel + phase_offset, 0.0, 1.0)
		var weave: float = sin(needle_travel * TAU * 1.6 + strand) * 7.0 * strand
		var point: Vector2 = origin.lerp(destination, needle_travel) + perpendicular * weave
		var tail := point - direction * 22.0
		draw_line(tail, point, Color(VFX_INK, fade * 0.78), 5.0, true)
		draw_line(tail, point, Color(VFX_STEEL, fade), 2.5, true)
		draw_circle(point, 3.2, Color(VFX_HIGHLIGHT, fade))
		draw_line(
			point - direction * 7.0, point - direction * 12.0 + perpendicular * 5.0,
			Color(VFX_BRASS, fade), 2.0, true
		)
		draw_line(
			point - direction * 7.0, point - direction * 12.0 - perpendicular * 5.0,
			Color(VFX_BRASS, fade), 2.0, true
		)
	var impact := clampf((progress - 0.60) / 0.40, 0.0, 1.0)
	_draw_steam_burst(destination, impact, 0.9)
	_draw_sparks(destination, impact, 0.55)

func _draw_muzzle_flash(origin: Vector2, direction: Vector2, phase: float) -> void:
	var strength := sin(clampf(phase, 0.0, 1.0) * PI)
	if strength <= 0.0:
		return
	var perpendicular := Vector2(-direction.y, direction.x)
	var points := PackedVector2Array([
		origin + direction * (28.0 + strength * 12.0),
		origin + perpendicular * 11.0 * strength,
		origin - direction * 5.0,
		origin - perpendicular * 11.0 * strength,
	])
	draw_colored_polygon(points, Color(VFX_EMBER, strength * 0.88))
	var core := PackedVector2Array([
		origin + direction * (20.0 + strength * 8.0),
		origin + perpendicular * 5.0 * strength,
		origin,
		origin - perpendicular * 5.0 * strength,
	])
	draw_colored_polygon(core, Color(VFX_HIGHLIGHT, strength))

func _draw_sparks(center: Vector2, phase: float, scale: float) -> void:
	var clamped_phase := clampf(phase, 0.0, 1.0)
	var strength := sin(clamped_phase * PI)
	if strength <= 0.0:
		return
	for ray in 8:
		var angle := float(ray) * TAU / 8.0 + 0.21
		var direction := Vector2.from_angle(angle)
		var inner := center + direction * (5.0 + clamped_phase * 5.0) * scale
		var outer := center + direction * (
			12.0 + float(ray % 3) * 6.0 + clamped_phase * 17.0
		) * scale
		draw_line(inner, outer, Color(VFX_EMBER, strength * 0.9), 2.4, true)
		if ray % 2 == 0:
			draw_circle(outer, 2.2 * scale, Color(VFX_HIGHLIGHT, strength))

func _draw_smoke_burst(center: Vector2, phase: float, scale: float) -> void:
	var clamped_phase := clampf(phase, 0.0, 1.0)
	var fade := pow(1.0 - clamped_phase, 1.4)
	if fade <= 0.0:
		return
	for puff in 6:
		var angle := float(puff) * TAU / 6.0 + 0.35
		var drift := Vector2.from_angle(angle) * clamped_phase * 28.0 * scale
		drift.y -= clamped_phase * 12.0 * scale
		var puff_center := center + drift
		var radius := (7.0 + float(puff % 3) * 3.0 + clamped_phase * 10.0) * scale
		draw_circle(puff_center, radius, Color(VFX_SMOKE, fade * 0.24))
		draw_arc(
			puff_center, radius, -2.8, 0.35, 14,
			Color(VFX_INK, fade * 0.34), 1.5, true
		)

func _draw_steam_burst(center: Vector2, phase: float, scale: float) -> void:
	var clamped_phase := clampf(phase, 0.0, 1.0)
	var fade := pow(1.0 - clamped_phase, 1.25)
	if fade <= 0.0:
		return
	for puff in 5:
		var angle := -PI * 0.85 + float(puff) * PI * 0.42
		var drift := Vector2.from_angle(angle) * clamped_phase * 34.0 * scale
		drift.y -= clamped_phase * 13.0 * scale
		var radius := (6.0 + float(puff % 2) * 4.0 + clamped_phase * 13.0) * scale
		draw_circle(center + drift, radius, Color(VFX_STEAM, fade * 0.32))
		draw_arc(
			center + drift, radius, 0, TAU, 16,
			Color(VFX_INK, fade * 0.22), 1.2, true
		)

func _draw_explosion(center: Vector2, phase: float, scale: float) -> void:
	var clamped_phase := clampf(phase, 0.0, 1.0)
	var flash := sin(clamped_phase * PI)
	if flash <= 0.0:
		return
	var points := PackedVector2Array()
	for point_index in 16:
		var angle := float(point_index) * TAU / 16.0
		var alternating := 1.0 if point_index % 2 == 0 else 0.48
		var radius := (12.0 + clamped_phase * 34.0) * alternating * scale
		points.append(center + Vector2.from_angle(angle) * radius)
	draw_colored_polygon(points, Color(VFX_EMBER, flash * 0.58))
	draw_circle(center, (8.0 + clamped_phase * 14.0) * scale,
		Color(VFX_HIGHLIGHT, flash * 0.88))
	_draw_sparks(center, clamped_phase, scale)
	_draw_smoke_burst(center, clamped_phase, scale)

func _draw_impact_cracks(center: Vector2, phase: float, scale: float) -> void:
	var clamped_phase := clampf(phase, 0.0, 1.0)
	var fade := sin(clamped_phase * PI)
	if fade <= 0.0:
		return
	for crack in 7:
		var angle := float(crack) * TAU / 7.0 + 0.18
		var direction := Vector2.from_angle(angle)
		var side := Vector2(-direction.y, direction.x)
		var elbow := center + direction * (13.0 + clamped_phase * 13.0) * scale
		var tip := elbow + direction * (10.0 + float(crack % 3) * 4.0) * scale
		tip += side * (-4.0 if crack % 2 == 0 else 4.0) * scale
		draw_line(center, elbow, Color(VFX_INK, fade * 0.72), 3.0, true)
		draw_line(elbow, tip, Color(VFX_INK, fade * 0.52), 2.0, true)

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
