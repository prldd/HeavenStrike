class_name SquadCard
extends Button

const UnitCatalogScript = preload("res://scripts/unit_catalog.gd")
const UIThemeScript = preload("res://scripts/ui_theme.gd")

signal unit_dropped(
	dropped_unit_name: String, source: String, source_index: int, target_index: int
)

var unit_name := ""
var drag_source := ""
var drag_texture: Texture2D
var slot_index := -1

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
