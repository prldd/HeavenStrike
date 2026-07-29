class_name SquadCard
extends Button

signal unit_dropped(dropped_unit_name: String, source: String)

var unit_name := ""
var drag_source := ""
var drag_texture: Texture2D

func configure(name_value: String, source_value: String, texture: Texture2D) -> void:
	unit_name = name_value
	drag_source = source_value
	drag_texture = texture

func _get_drag_data(_position: Vector2):
	if unit_name.is_empty() or disabled:
		return null
	var preview := TextureRect.new()
	preview.custom_minimum_size = Vector2(56, 56)
	preview.texture = drag_texture
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	set_drag_preview(preview)
	return {"unit_name": unit_name, "source": drag_source}

func _can_drop_data(_position: Vector2, data) -> bool:
	return (
		data is Dictionary
		and data.has("unit_name")
		and data.has("source")
		and data.source != drag_source
	)

func _drop_data(_position: Vector2, data) -> void:
	unit_dropped.emit(str(data.unit_name), str(data.source))
