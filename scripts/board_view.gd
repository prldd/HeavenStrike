class_name BoardView
extends Control

const BattleRulesScript = preload("res://scripts/battle_rules.gd")
const UnitCatalogScript = preload("res://scripts/unit_catalog.gd")
const UNIT_SPRITES_1 := preload("res://assets/units/reference-units-001-006.png")
const UNIT_SPRITES_2 := preload("res://assets/units/reference-units-007-012.png")
const UNIT_SPRITES_3 := preload("res://assets/units/reference-units-013-018.png")
const UNIT_SPRITES_4 := preload("res://assets/units/reference-units-019-024.png")
const UNIT_SPRITES_5 := preload("res://assets/units/reference-units-025-030.png")
const UNIT_SPRITES_6 := preload("res://assets/units/reference-units-031-036.png")
const UNIT_SPRITES_7 := preload("res://assets/units/reference-units-037-042.png")
const UNIT_SPRITES_8 := preload("res://assets/units/reference-units-043-048.png")
const BOARD_BACKGROUND := preload("res://assets/board-sky-citadel.png")

signal deployment_clicked(row: int)
signal board_cell_clicked(row: int, col: int)
signal unit_hovered(unit: Dictionary)
signal unit_hover_ended

const ROWS := 3
const COLS := 7
const BOARD_MARGIN := 16.0
var units: Array = []
var selected_card: Dictionary = {}
var selected_unit_id := -1
var targetable_unit_ids: Array = []
var player_mana_text := ""
var enemy_mana_text := ""
var player_hp_text := ""
var enemy_hp_text := ""
var player_deck_text := ""
var enemy_deck_text := ""
var enabled := true
var hover_row := -1
var hover_unit_id := -1
var event_text := "Choose a unit, then choose a lane."
var effect_unit_id := -1
var effect_label := ""
var effect_color := Color.WHITE
var effect_strength := 0.0
var commander_effect_side := -1
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

func _ready() -> void:
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	mouse_exited.connect(_clear_hover)

func _clear_hover() -> void:
	hover_row = -1
	if hover_unit_id >= 0:
		hover_unit_id = -1
		unit_hover_ended.emit()
	queue_redraw()

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
	next_enemy_deck_text: String = ""
) -> void:
	units = next_units
	selected_card = card
	selected_unit_id = selected_id
	targetable_unit_ids = next_targetable_ids.duplicate()
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
	commander_effect_side = -1
	effect_unit_id = unit_id
	effect_label = label
	effect_color = color
	effect_strength = 1.0
	var tween := create_tween()
	tween.tween_method(_set_effect_strength, 1.0, 0.0, 0.38).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_callback(_clear_effect)

func play_commander_effect(side: int, label: String, color: Color) -> void:
	commander_effect_side = side
	effect_unit_id = -1
	effect_label = label
	effect_color = color
	effect_strength = 1.0
	var tween := create_tween()
	tween.tween_method(_set_effect_strength, 1.0, 0.0, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_callback(_clear_effect)

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
		var lunge := (destination - origin).normalized() * minf(28.0, origin.distance_to(destination) * 0.22) * lunge_scale
		var tween := create_tween()
		tween.tween_method(_set_unit_visual_offset.bind(actor_id), Vector2.ZERO, lunge, duration * 0.42)
		tween.tween_method(_set_unit_visual_offset.bind(actor_id), lunge, Vector2.ZERO, duration * 0.58)
		tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
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
	var destination := Vector2(size.x - 82 if commander_side == 1 else 82, _grid_rect().get_center().y)
	if unit_kind in ["Strider", "Duelist", "Warden"]:
		var lunge := (destination - origin).normalized() * (10.0 if reduced_motion else 30.0)
		var tween := create_tween()
		tween.tween_method(_set_unit_visual_offset.bind(actor_id), Vector2.ZERO, lunge, duration * 0.42)
		tween.tween_method(_set_unit_visual_offset.bind(actor_id), lunge, Vector2.ZERO, duration * 0.58)
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

func _set_effect_strength(value: float) -> void:
	effect_strength = value
	queue_redraw()

func _clear_effect() -> void:
	effect_unit_id = -1
	commander_effect_side = -1
	effect_label = ""
	queue_redraw()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		hover_row = _row_at(event.position)
		_update_unit_hover(event.position)
		queue_redraw()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var row := _row_at(event.position)
		var col := _col_at(event.position)
		if row >= 0 and col >= 0 and enabled:
			if not selected_card.is_empty() and col == 0:
				deployment_clicked.emit(row)
			elif selected_card.is_empty():
				board_cell_clicked.emit(row, col)

func _row_at(point: Vector2) -> int:
	var rect := _grid_rect()
	if not rect.has_point(point):
		return -1
	return clampi(int((point.y - rect.position.y) / (rect.size.y / ROWS)), 0, ROWS - 1)

func _col_at(point: Vector2) -> int:
	var rect := _grid_rect()
	if not rect.has_point(point):
		return -1
	return clampi(int((point.x - rect.position.x) / (rect.size.x / COLS)), 0, COLS - 1)

func _update_unit_hover(point: Vector2) -> void:
	var grid := _grid_rect()
	var next_unit: Dictionary = {}
	if grid.has_point(point):
		var row := clampi(int((point.y - grid.position.y) / (grid.size.y / ROWS)), 0, ROWS - 1)
		var col := clampi(int((point.x - grid.position.x) / (grid.size.x / COLS)), 0, COLS - 1)
		for unit in units:
			if unit.row == row and unit.col == col:
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
	return Rect2(
		Vector2(142.0, BOARD_MARGIN + 26.0),
		Vector2(size.x - 284.0, size.y - BOARD_MARGIN * 2.0 - 52.0)
	)

func _cell_rect(row: int, col: int) -> Rect2:
	var grid := _grid_rect()
	var cell := Vector2(grid.size.x / COLS, grid.size.y / ROWS)
	return Rect2(grid.position + Vector2(col * cell.x, row * cell.y), cell)

func _draw() -> void:
	var panel := Rect2(Vector2.ZERO, size)
	draw_texture_rect(BOARD_BACKGROUND, panel, false)
	draw_rect(panel, Color(0.025, 0.045, 0.09, 0.16))
	draw_style_box(_box(Color.TRANSPARENT, Color("#536b91"), 18, 2), panel.grow(-1))

	var grid := _grid_rect()
	for row in ROWS:
		for col in COLS:
			var cell_rect := _cell_rect(row, col).grow(-3.0)
			var base := (
				Color(0.04, 0.09, 0.16, 0.25)
				if (row + col) % 2 == 0
				else Color(0.08, 0.12, 0.19, 0.18)
			)
			if col == 0:
				base = Color(0.04, 0.33, 0.52, 0.30)
			elif col == COLS - 1:
				base = Color(0.55, 0.08, 0.28, 0.28)
			if row == hover_row and col == 0 and enabled and not selected_card.is_empty():
				base = Color(0.08, 0.62, 0.78, 0.42)
			draw_style_box(_box(base, Color(0.55, 0.67, 0.82, 0.46), 7, 1), cell_rect)

	draw_style_box(
		_box(Color(0.025, 0.05, 0.11, 0.78), Color(0.43, 0.60, 0.78, 0.55), 8, 1),
		Rect2(Vector2(142, 6), Vector2(minf(grid.size.x * 0.62, 590), 28))
	)
	draw_string(
		get_theme_default_font(),
		Vector2(153, 25),
		event_text,
		HORIZONTAL_ALIGNMENT_LEFT,
		minf(grid.size.x * 0.60, 570),
		14,
		Color("#e3edff")
	)

	var preview_id: int = (
		-1 if not targetable_unit_ids.is_empty()
		else selected_unit_id if selected_unit_id >= 0
		else hover_unit_id
	)
	var preview_unit: Variant = _unit_by_id(preview_id)
	if preview_unit != null:
		_draw_action_preview(preview_unit)

	_draw_commander(
		Vector2(82, grid.get_center().y), false, player_hp_text, player_deck_text
	)
	_draw_commander(
		Vector2(size.x - 82, grid.get_center().y), true, enemy_hp_text, enemy_deck_text
	)
	if commander_effect_side >= 0:
		_draw_commander_effect(
			Vector2(size.x - 82 if commander_effect_side == 1 else 82, grid.get_center().y)
		)
	_draw_mana_indicator(Vector2(82, grid.get_center().y - 92), player_mana_text, false)
	_draw_mana_indicator(Vector2(size.x - 82, grid.get_center().y - 92), enemy_mana_text, true)

	for unit in units:
		_draw_unit(unit)
		if unit.id == selected_unit_id:
			_draw_selection(unit)
		if unit.id in targetable_unit_ids:
			_draw_targetable(unit)
		if unit.id == effect_unit_id:
			_draw_effect(unit)
	_draw_projectile()

	if not selected_card.is_empty() and enabled and targetable_unit_ids.is_empty():
		for row in ROWS:
			var deploy := _cell_rect(row, 0).grow(-8)
			if not _occupied(row, 0):
				draw_dashed_line(
					deploy.position + Vector2(5, deploy.size.y - 5),
					deploy.end - Vector2(5, deploy.size.y - 5),
					Color("#61e8ff"),
					2,
					6
				)

	var selected_unit: Variant = _unit_by_id(selected_unit_id)
	if (
		selected_unit != null and enabled and targetable_unit_ids.is_empty()
		and not BattleRulesScript.is_taunted(selected_unit, units)
	):
		for target_row in ROWS:
			if BattleRulesScript.can_reposition(selected_unit, target_row, units):
				var target := _cell_rect(target_row, selected_unit.col).grow(-7)
				draw_style_box(_box(Color(0.2, 0.75, 0.85, 0.12), Color("#61e8ff"), 10, 3), target)

	if preview_unit != null:
		var legend := "CYAN  TRAVERSE    CORAL  ATTACK REACH"
		draw_string(
			get_theme_default_font(),
			Vector2(grid.end.x - 330, 24),
			legend,
			HORIZONTAL_ALIGNMENT_RIGHT,
			330,
			11,
			Color("#91a7ce")
		)

func _draw_targetable(unit: Dictionary) -> void:
	var rect := _cell_rect(unit.row, unit.col).grow(-4)
	draw_style_box(
		_box(Color(1.0, 0.72, 0.18, 0.16), Color("#ffd166"), 12, 4),
		rect
	)
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
	var rect := _cell_rect(unit.row, unit.col).grow(-10.0)
	rect.position += unit_visual_offsets.get(unit.id, Vector2.ZERO)
	var center := rect.get_center()
	var color: Color = UnitCatalogScript.class_color(unit.kind)

	draw_style_box(
		_box(Color(color, 0.10), Color(color, 0.32), 13, 1),
		rect.grow(5)
	)
	_draw_unit_art(unit, rect.grow(-2.0))
	var flash: float = unit_flash_strength.get(unit.id, 0.0)
	if flash > 0.0:
		draw_style_box(
			_box(Color(1, 1, 1, flash * 0.34), Color(1, 1, 1, flash * 0.72), 10, 2),
			rect.grow(-2)
		)
	var font := get_theme_default_font()
	var hp_text := "%d" % unit.hp
	var atk_text := "%d" % unit.atk
	draw_circle(rect.position + Vector2(15, 15), 13, Color("#e95778"))
	draw_circle(Vector2(rect.end.x - 15, rect.position.y + 15), 13, Color("#e8b94f"))
	draw_string(font, rect.position + Vector2(7, 20), hp_text, HORIZONTAL_ALIGNMENT_CENTER, 16, 12, Color.WHITE)
	draw_string(font, Vector2(rect.end.x - 23, rect.position.y + 20), atk_text, HORIZONTAL_ALIGNMENT_CENTER, 16, 12, Color("#16203a"))
	_draw_status_badges(unit, rect)

	if not unit.ready:
		draw_style_box(
			_box(Color(0.05, 0.08, 0.15, 0.48), Color.TRANSPARENT, 10, 0),
			rect.grow(-3)
		)
		draw_string(font, Vector2(rect.position.x, rect.end.y - 7), "RESTING", HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 10, Color("#b8c2d9"))
	var defeat: float = unit_defeat_strength.get(unit.id, 0.0)
	if defeat > 0.0:
		draw_style_box(
			_box(Color(0.025, 0.04, 0.08, defeat * 0.94), Color(color, 1.0 - defeat), 10, 1),
			rect.grow(-2)
		)
		for slice in 4:
			var slice_y := rect.position.y + rect.size.y * (float(slice + 1) / 5.0)
			draw_line(
				Vector2(rect.position.x + defeat * 12.0, slice_y),
				Vector2(rect.end.x - defeat * 12.0, slice_y),
				Color(color, defeat * 0.55),
				1
			)

func _draw_projectile() -> void:
	if projectile_kind.is_empty():
		return
	var position := projectile_from.lerp(projectile_to, projectile_progress)
	var color := Color("#70e0a1")
	var radius := 7.0
	if projectile_kind == "Artillerist":
		color = Color("#ffd166")
		radius = 5.0
		draw_line(projectile_from, position, Color(color, 0.42), 3)
	elif projectile_kind == "Channeler":
		color = Color("#c99cff")
		radius = 10.0
	elif projectile_kind == "Heal":
		color = Color("#70e0a1")
		radius = 9.0
	else:
		color = Color("#ff8fbd")
	draw_circle(position, radius + 5, Color(color, 0.14))
	draw_circle(position, radius, Color(color, 0.88))
	draw_arc(position, radius + 3, 0, TAU, 18, color, 2)

func _draw_status_badges(unit: Dictionary, rect: Rect2) -> void:
	var badges: Array = []
	if unit.get("taunt_turns", 0) > 0:
		badges.append({"label": "T%d" % unit.taunt_turns, "color": Color("#ff9d66")})
	if unit.get("immobilized_turns", 0) > 0:
		badges.append({"label": "I%d" % unit.immobilized_turns, "color": Color("#c99cff")})
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
		var center := Vector2(rect.position.x + 11 + index * 20, rect.end.y - 11)
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

func _draw_unit_icon(unit: Dictionary, center: Vector2, size: float) -> void:
	var icon_id: int = unit.get("icon", 0)
	if icon_id < 1 or icon_id > 48:
		return
	var sheets: Array[Texture2D] = [
		UNIT_SPRITES_1, UNIT_SPRITES_2, UNIT_SPRITES_3, UNIT_SPRITES_4,
		UNIT_SPRITES_5, UNIT_SPRITES_6, UNIT_SPRITES_7, UNIT_SPRITES_8
	]
	var texture: Texture2D = sheets[int((icon_id - 1) / 6)]
	var slot := (icon_id - 1) % 6
	var source := Rect2(slot * 100, 0, 100, 100)
	var scale_x := -1.0 if unit.side == 0 else 1.0
	draw_set_transform(center, 0.0, Vector2(scale_x, 1.0))
	draw_texture_rect_region(
		texture,
		Rect2(Vector2(-size * 0.5, -size * 0.5), Vector2(size, size)),
		source
	)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _draw_unit_art(unit: Dictionary, rect: Rect2) -> void:
	var icon_id: int = unit.get("icon", 0)
	if icon_id < 1 or icon_id > 48:
		return
	var texture: Texture2D = _full_unit_texture(icon_id)
	if texture == null:
		_draw_unit_icon(unit, rect.get_center(), minf(rect.size.x, rect.size.y) * 0.68)
		return
	var texture_size := texture.get_size()
	var art_scale := minf(rect.size.x / texture_size.x, rect.size.y / texture_size.y)
	var draw_size := texture_size * art_scale
	var center := Vector2(rect.get_center().x, rect.end.y - draw_size.y * 0.5)
	var scale_x := -1.0 if unit.side == 0 else 1.0
	draw_set_transform(center, 0.0, Vector2(scale_x, 1.0))
	draw_texture_rect(
		texture,
		Rect2(-draw_size * 0.5, draw_size),
		false
	)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _full_unit_texture(icon_id: int) -> Texture2D:
	if full_unit_texture_cache.has(icon_id):
		return full_unit_texture_cache[icon_id]
	var path := "res://assets/units/full/%03d.png" % icon_id
	var texture := load(path) as Texture2D
	full_unit_texture_cache[icon_id] = texture
	return texture

func _draw_effect(unit: Dictionary) -> void:
	var rect := _cell_rect(unit.row, unit.col).grow(-5.0)
	var center := rect.get_center()
	var radius := minf(rect.size.x, rect.size.y) * (0.35 + (1.0 - effect_strength) * 0.18)
	draw_circle(center, radius, Color(effect_color, effect_strength * 0.22), false, 4)
	draw_arc(center, radius, 0, TAU, 32, Color(effect_color, effect_strength), 4)
	draw_string(
		get_theme_default_font(),
		Vector2(rect.position.x, rect.position.y - 4 - (1.0 - effect_strength) * 18),
		effect_label,
		HORIZONTAL_ALIGNMENT_CENTER,
		rect.size.x,
		14,
		Color(effect_color, effect_strength)
	)

func _draw_commander_effect(center: Vector2) -> void:
	var radius := 42.0 + (1.0 - effect_strength) * 14.0
	draw_arc(center, radius, 0, TAU, 32, Color(effect_color, effect_strength), 4)
	draw_string(
		get_theme_default_font(),
		center + Vector2(-58, -50 - (1.0 - effect_strength) * 18),
		effect_label,
		HORIZONTAL_ALIGNMENT_CENTER,
		116,
		15,
		Color(effect_color, effect_strength)
	)

func _draw_selection(unit: Dictionary) -> void:
	var rect := _cell_rect(unit.row, unit.col).grow(-5)
	rect.position += unit_visual_offsets.get(unit.id, Vector2.ZERO)
	draw_style_box(_box(Color(0.25, 0.8, 0.9, 0.08), Color("#71e6f5"), 12, 3), rect)

func _draw_action_preview(unit: Dictionary) -> void:
	var direction := 1 if unit.side == 0 else -1
	var preview: Dictionary = BattleRulesScript.projected_action(unit.id, units)
	for cell in preview.attack:
		var attack_rect := _cell_rect(cell.y, cell.x).grow(-8)
		var occupied_target := _enemy_at(unit, cell.y, cell.x)
		var fill := Color(0.94, 0.31, 0.43, 0.24 if occupied_target else 0.09)
		var width := 3 if occupied_target else 2
		draw_style_box(_box(fill, Color("#ff667e"), 9, width), attack_rect)

	for cell in preview.traversal:
		var move_rect := _cell_rect(cell.y, cell.x).grow(-12)
		draw_style_box(_box(Color(0.2, 0.75, 0.9, 0.14), Color("#4ec9e8"), 8, 2), move_rect)
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
	for unit in units:
		if unit.row == row and unit.col == col:
			return true
	return false

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
