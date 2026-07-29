class_name BoardView
extends Control

signal deployment_clicked(row: int)

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
var enabled := true
var hover_row := -1
var event_text := "Choose a unit, then choose a lane."

func _ready() -> void:
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	mouse_exited.connect(_clear_hover)

func _clear_hover() -> void:
	hover_row = -1
	queue_redraw()

func set_state(next_units: Array, card: Dictionary, can_deploy: bool, message: String) -> void:
	units = next_units
	selected_card = card
	enabled = can_deploy
	event_text = message
	queue_redraw()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		hover_row = _row_at(event.position)
		queue_redraw()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var row := _row_at(event.position)
		if row >= 0 and enabled and not selected_card.is_empty():
			deployment_clicked.emit(row)

func _row_at(point: Vector2) -> int:
	var rect := _grid_rect()
	if not rect.has_point(point):
		return -1
	return clampi(int((point.y - rect.position.y) / (rect.size.y / ROWS)), 0, ROWS - 1)

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

	_draw_commander(Vector2(68, grid.get_center().y), false)
	_draw_commander(Vector2(size.x - 68, grid.get_center().y), true)

	for unit in units:
		_draw_unit(unit)

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
	draw_arc(center, minf(rect.size.x, rect.size.y) * 0.32, 0, TAU, 32, side_color, 3)

	var initial: String = unit.kind.left(1)
	var font := get_theme_default_font()
	var initial_size := font.get_string_size(initial, HORIZONTAL_ALIGNMENT_LEFT, -1, 24)
	draw_string(font, center - initial_size / 2 + Vector2(0, initial_size.y * 0.72), initial, HORIZONTAL_ALIGNMENT_LEFT, -1, 24, color)

	var hp_text := "%d" % unit.hp
	var atk_text := "%d" % unit.atk
	draw_circle(rect.position + Vector2(15, 15), 13, Color("#e95778"))
	draw_circle(Vector2(rect.end.x - 15, rect.position.y + 15), 13, Color("#e8b94f"))
	draw_string(font, rect.position + Vector2(7, 20), hp_text, HORIZONTAL_ALIGNMENT_CENTER, 16, 12, Color.WHITE)
	draw_string(font, Vector2(rect.end.x - 23, rect.position.y + 20), atk_text, HORIZONTAL_ALIGNMENT_CENTER, 16, 12, Color("#16203a"))

	if not unit.ready:
		draw_circle(center, minf(rect.size.x, rect.size.y) * 0.32, Color(0.05, 0.08, 0.15, 0.48))
		draw_string(font, Vector2(rect.position.x, rect.end.y - 7), "RESTING", HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 10, Color("#b8c2d9"))

func _occupied(row: int, col: int) -> bool:
	for unit in units:
		if unit.row == row and unit.col == col:
			return true
	return false

func _box(fill: Color, border: Color, radius: int, width: int) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = fill
	box.border_color = border
	box.set_border_width_all(width)
	box.set_corner_radius_all(radius)
	return box
