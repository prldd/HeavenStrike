class_name BoardView
extends Control

const BattleRulesScript = preload("res://scripts/battle_rules.gd")
const UNIT_SPRITES_1 := preload("res://assets/units/reference-units-001-006.png")
const UNIT_SPRITES_2 := preload("res://assets/units/reference-units-007-012.png")
const UNIT_SPRITES_3 := preload("res://assets/units/reference-units-013-018.png")
const UNIT_SPRITES_4 := preload("res://assets/units/reference-units-019-024.png")

signal deployment_clicked(row: int)
signal board_cell_clicked(row: int, col: int)
signal unit_hovered(unit: Dictionary)
signal unit_hover_ended

const ROWS := 3
const COLS := 7
const BOARD_MARGIN := 16.0
const COLORS := {
	"Strider": Color("#66d9ff"),
	"Duelist": Color("#ff9d66"),
	"Warden": Color("#70e0a1"),
	"Artillerist": Color("#ffd166"),
	"Channeler": Color("#c99cff"),
	"Lifebinder": Color("#ff8fbd")
}

var units: Array = []
var selected_card: Dictionary = {}
var selected_unit_id := -1
var enabled := true
var hover_row := -1
var hover_unit_id := -1
var event_text := "Choose a unit, then choose a lane."
var effect_unit_id := -1
var effect_label := ""
var effect_color := Color.WHITE
var effect_strength := 0.0

func _ready() -> void:
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	mouse_exited.connect(_clear_hover)

func _clear_hover() -> void:
	hover_row = -1
	if hover_unit_id >= 0:
		hover_unit_id = -1
		unit_hover_ended.emit()
	queue_redraw()

func set_state(next_units: Array, card: Dictionary, selected_id: int, can_deploy: bool, message: String) -> void:
	units = next_units
	selected_card = card
	selected_unit_id = selected_id
	enabled = can_deploy
	event_text = message
	queue_redraw()

func play_unit_effect(unit_id: int, label: String, color: Color) -> void:
	effect_unit_id = unit_id
	effect_label = label
	effect_color = color
	effect_strength = 1.0
	var tween := create_tween()
	tween.tween_method(_set_effect_strength, 1.0, 0.0, 0.38).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_callback(_clear_effect)

func _set_effect_strength(value: float) -> void:
	effect_strength = value
	queue_redraw()

func _clear_effect() -> void:
	effect_unit_id = -1
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
	draw_style_box(_box(Color("#101b33"), Color("#26385f"), 18, 2), panel)

	var grid := _grid_rect()
	for row in ROWS:
		for col in COLS:
			var cell_rect := _cell_rect(row, col).grow(-3.0)
			var base := Color("#172746") if (row + col) % 2 == 0 else Color("#1b2d50")
			if col == 0:
				base = Color("#193c59")
			elif col == COLS - 1:
				base = Color("#4a263e")
			if row == hover_row and col == 0 and enabled and not selected_card.is_empty():
				base = Color("#245f78")
			draw_style_box(_box(base, Color("#30466f"), 10, 1), cell_rect)

	draw_string(
		get_theme_default_font(),
		Vector2(150, 24),
		event_text,
		HORIZONTAL_ALIGNMENT_LEFT,
		grid.size.x,
		15,
		Color("#b9caea")
	)

	var preview_id: int = selected_unit_id if selected_unit_id >= 0 else hover_unit_id
	var preview_unit: Variant = _unit_by_id(preview_id)
	if preview_unit != null:
		_draw_action_preview(preview_unit)

	_draw_commander(Vector2(68, grid.get_center().y), false)
	_draw_commander(Vector2(size.x - 68, grid.get_center().y), true)

	for unit in units:
		_draw_unit(unit)
		if unit.id == selected_unit_id:
			_draw_selection(unit)
		if unit.id == effect_unit_id:
			_draw_effect(unit)

	if not selected_card.is_empty() and enabled:
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
	if selected_unit != null and enabled and not BattleRulesScript.is_taunted(selected_unit, units) and not selected_unit.get("repositioned", false):
		for target_row in [selected_unit.row - 1, selected_unit.row + 1]:
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

func _draw_commander(center: Vector2, enemy: bool) -> void:
	var color := Color("#ed5b86") if enemy else Color("#50d4e8")
	draw_circle(center, 48, Color(color, 0.12))
	draw_circle(center, 34, Color("#0c1529"))
	draw_arc(center, 35, 0, TAU, 40, color, 3)
	var icon := "◆"
	var font := get_theme_default_font()
	var text_size := font.get_string_size(icon, HORIZONTAL_ALIGNMENT_LEFT, -1, 30)
	draw_string(font, center - text_size / 2 + Vector2(0, text_size.y * 0.75), icon, HORIZONTAL_ALIGNMENT_LEFT, -1, 30, color)
	draw_string(
		font,
		center + Vector2(-55, 62),
		"ENEMY" if enemy else "YOU",
		HORIZONTAL_ALIGNMENT_CENTER,
		110,
		12,
		Color("#91a7ce")
	)

func _draw_unit(unit: Dictionary) -> void:
	var rect := _cell_rect(unit.row, unit.col).grow(-10.0)
	var center := rect.get_center()
	var color: Color = COLORS.get(unit.kind, Color.WHITE)
	var side_color := Color("#ff668f") if unit.side == 1 else Color("#62e7ff")

	draw_circle(center + Vector2(0, 3), minf(rect.size.x, rect.size.y) * 0.34, Color(0, 0, 0, 0.3))
	draw_circle(center, minf(rect.size.x, rect.size.y) * 0.32, Color(color, 0.2))
	_draw_unit_icon(unit, center, minf(rect.size.x, rect.size.y) * 0.68)
	draw_arc(center, minf(rect.size.x, rect.size.y) * 0.32, 0, TAU, 32, side_color, 3)

	var font := get_theme_default_font()
	var hp_text := "%d" % unit.hp
	var atk_text := "%d" % unit.atk
	draw_circle(rect.position + Vector2(15, 15), 13, Color("#e95778"))
	draw_circle(Vector2(rect.end.x - 15, rect.position.y + 15), 13, Color("#e8b94f"))
	draw_string(font, rect.position + Vector2(7, 20), hp_text, HORIZONTAL_ALIGNMENT_CENTER, 16, 12, Color.WHITE)
	draw_string(font, Vector2(rect.end.x - 23, rect.position.y + 20), atk_text, HORIZONTAL_ALIGNMENT_CENTER, 16, 12, Color("#16203a"))

	if not unit.ready:
		draw_circle(center, minf(rect.size.x, rect.size.y) * 0.32, Color(0.05, 0.08, 0.15, 0.48))
		draw_string(font, Vector2(rect.position.x, rect.end.y - 7), "RESTING", HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 10, Color("#b8c2d9"))

func _draw_unit_icon(unit: Dictionary, center: Vector2, size: float) -> void:
	var icon_id: int = unit.get("icon", 0)
	if icon_id < 1 or icon_id > 24:
		return
	var sheets: Array[Texture2D] = [
		UNIT_SPRITES_1, UNIT_SPRITES_2, UNIT_SPRITES_3, UNIT_SPRITES_4
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

func _draw_selection(unit: Dictionary) -> void:
	var rect := _cell_rect(unit.row, unit.col).grow(-5)
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
