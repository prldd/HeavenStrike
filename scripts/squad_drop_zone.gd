class_name SquadDropZone
extends PanelContainer

signal unit_dropped(unit_name: String, source: String)

var zone_name := ""

func _can_drop_data(_position: Vector2, data) -> bool:
	return (
		data is Dictionary
		and data.has("unit_name")
		and data.has("source")
		and data.source != zone_name
	)

func _drop_data(_position: Vector2, data) -> void:
	unit_dropped.emit(str(data.unit_name), str(data.source))
