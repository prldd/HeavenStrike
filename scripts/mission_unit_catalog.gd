class_name MissionUnitCatalog
extends RefCounted

const UnitDataScript = preload("res://scripts/resources/unit_data.gd")

const GROUND_TRANSPORT_NAME := "Relay Ground Transport-216"

static var _units: Array[UnitData] = []

static func all_units() -> Array[UnitData]:
	_build()
	return _units

static func by_name(unit_name: String) -> UnitData:
	_build()
	for unit in _units:
		if unit.name == unit_name:
			return unit
	return null

static func _build() -> void:
	if not _units.is_empty():
		return
	var transport := UnitDataScript.new()
	transport.name = GROUND_TRANSPORT_NAME
	transport.icon = 216
	transport.stars = 1
	transport.kind = "Transport"
	transport.cost = 0
	transport.atk = 1
	transport.hp = 18
	transport.move = 0
	transport.range = 1
	transport.description = (
		"Armored Carrier — A reinforced autonomous cargo crawler with one defensive cannon."
	)
	_units = [transport]
