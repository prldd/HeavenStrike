class_name SquadCard
extends Button

const UnitCatalogScript = preload("res://scripts/unit_catalog.gd")
const UIThemeScript = preload("res://scripts/ui_theme.gd")

signal unit_dropped(
	dropped_unit_name: String, source: String, source_index: int, target_index: int
)
signal long_pressed
signal long_press_released

const LONG_PRESS_DELAY := 0.45
const LONG_PRESS_CANCEL_DISTANCE := 10.0

var unit_name := ""
var drag_source := ""
var drag_texture: Texture2D
var slot_index := -1

var _touch_held := false
var _touch_press_pos := Vector2.ZERO
var _details_shown := false

func _ready() -> void:
	# Touch has no hover: details are shown via long-press instead of
	# mouse_entered (which on touch fires on every tap and scroll attempt).
	if OS.has_feature("mobile"):
		gui_input.connect(_on_touch_details_input)

func _on_touch_details_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		_touch_held = event.pressed
		if event.pressed:
			_touch_press_pos = event.position
			_arm_long_press()
	elif event is InputEventScreenDrag and _touch_held:
		# Any deliberate movement is a scroll/drag gesture, not a long-press.
		if event.position.distance_to(_touch_press_pos) > LONG_PRESS_CANCEL_DISTANCE:
			_touch_held = false

func _arm_long_press() -> void:
	await get_tree().create_timer(LONG_PRESS_DELAY).timeout
	if not _touch_held or _details_shown:
		return
	_details_shown = true
	_touch_held = false
	long_pressed.emit()

func _input(event: InputEvent) -> void:
	if _details_shown and event is InputEventScreenTouch and not event.pressed:
		_details_shown = false
		long_press_released.emit()

func configure(
	name_value: String,
	source_value: String,
	texture: Texture2D,
	index_value: int = -1,
	unit_kind: String = ""
) -> void:
	unit_name = name_value
	drag_source = source_value
	drag_texture = texture
	slot_index = index_value
	if OS.has_feature("mobile") and source_value != "squad":
		# Let touch press/drag events bubble up to the parent ScrollContainer so
		# card-dense lists scroll even when the gesture starts on a card. Taps
		# still reach the card (buttons only activate when the release lands on
		# them, which a scroll gesture never does). Squad cards keep STOP: they
		# keep drag-and-drop for reordering on mobile and must not also scroll.
		mouse_filter = Control.MOUSE_FILTER_PASS
	_apply_class_style(UnitCatalogScript.class_color(unit_kind))

func _apply_class_style(color: Color) -> void:
	add_theme_stylebox_override("normal", _card_style(color, 0.13, 0.48, 1))
	add_theme_stylebox_override("hover", _card_style(color, 0.23, 0.88, 3))
	add_theme_stylebox_override("pressed", _card_style(color, 0.28, 1.0, 4))
	add_theme_stylebox_override("disabled", _card_style(color, 0.07, 0.24, 0))

func _card_style(color: Color, tint: float, border_alpha: float, glow: int) -> StyleBoxFlat:
	return UIThemeScript.card_style(color, tint, border_alpha, glow)

func _get_drag_data(_position: Vector2):
	if unit_name.is_empty() or disabled:
		return null
	# On touch devices, dragging a card inside a scrollable list is the scroll
	# gesture; starting drag-and-drop there makes the list impossible to scroll.
	# Taps already cover add/remove/select on those lists, so only squad cards
	# (reorder, which has no tap equivalent) keep drag-and-drop on mobile.
	if OS.has_feature("mobile") and drag_source != "squad":
		return null
	var preview := TextureRect.new()
	preview.custom_minimum_size = Vector2(56, 56)
	preview.texture = drag_texture
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	set_drag_preview(preview)
	return {
		"unit_name": unit_name,
		"source": drag_source,
		"source_index": slot_index
	}

func _can_drop_data(_position: Vector2, data) -> bool:
	return (
		data is Dictionary
		and data.has("unit_name")
		and data.has("source")
		and (
			data.source != drag_source
			or (drag_source == "squad" and data.get("source_index", -1) != slot_index)
		)
	)

func _drop_data(_position: Vector2, data) -> void:
	unit_dropped.emit(
		str(data.unit_name),
		str(data.source),
		int(data.get("source_index", -1)),
		slot_index
	)
