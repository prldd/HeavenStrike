class_name MechaConceptCatalog
extends RefCounted

const FACTIONS := ["Coal", "Wind"]
const POSES := ["Ready", "Fire Cycle"]
const BODY_NAME := "Shared Line Chassis"
const CLASS_NAME := "Artillerist"

const BODY_PATHS := {
	"Coal": "res://assets/units/modular/concepts/coal-body.png",
	"Wind": "res://assets/units/modular/concepts/wind-body.png"
}

const WEAPON_SHEET_PATHS := {
	"Coal": "res://assets/units/modular/concepts/coal-artillerist-weapons.png",
	"Wind": "res://assets/units/modular/concepts/wind-artillerist-weapons.png"
}

const WEAPONS := {
	"Coal": [
		{"id": "rail_furnace", "name": "Rail Furnace", "row": 0,
			"description": "Long-line magnetic cannon; strongest lane-read and recoil profile."},
		{"id": "foundry_rotary", "name": "Foundry Rotary", "row": 1,
			"description": "Drum-fed repeater; broad muzzle mass and sustained-fire spin."},
		{"id": "twin_sieger", "name": "Twin Sieger", "row": 2,
			"description": "Paired siege tubes; compact range with a heavy two-beat discharge."}
	],
	"Wind": [
		{"id": "focus_lance", "name": "Focus Lance", "row": 0,
			"description": "Needle beam rifle; long, clean line with a sharp charge flash."},
		{"id": "turbine_repeater", "name": "Turbine Repeater", "row": 1,
			"description": "Air-driven repeater; spinning chamber and quick recoil rhythm."},
		{"id": "dart_cell", "name": "Dart Cell", "row": 2,
			"description": "Three guided darts; compact silhouette with sequential launches."}
	]
}

const CONSTRUCTION_NOTES := {
	"Coal": (
		"Furnace-built construction: riveted overlapping slabs, exposed pistons, "
		+ "caged heat core, asymmetrical exhaust, and broad load-bearing feet."
	),
	"Wind": (
		"Turbine-built construction: swept ceramic shells, tension struts, narrow "
		+ "waist, integrated airfoils, and visible rotary power modules."
	)
}

static func default_recipe() -> Dictionary:
	return {
		"faction": "Coal",
		"class": CLASS_NAME,
		"body": BODY_NAME,
		"weapon": "rail_furnace",
		"pose": "Ready"
	}

static func normalize(recipe: Dictionary) -> Dictionary:
	var result := default_recipe()
	for key in result:
		if recipe.has(key):
			result[key] = recipe[key]
	if result.faction not in FACTIONS:
		result.faction = "Coal"
	if result.pose not in POSES:
		result.pose = "Ready"
	result["class"] = CLASS_NAME
	result.body = BODY_NAME
	if weapon_by_id(String(result.faction), String(result.weapon)).is_empty():
		result.weapon = weapons_for(String(result.faction))[0].id
	return result

static func weapons_for(faction: String) -> Array:
	return WEAPONS.get(faction, WEAPONS.Coal)

static func weapon_by_id(faction: String, weapon_id: String) -> Dictionary:
	for weapon in weapons_for(faction):
		if weapon.id == weapon_id:
			return weapon
	return {}

static func weapon_index(faction: String, weapon_id: String) -> int:
	var weapons := weapons_for(faction)
	for index in weapons.size():
		if weapons[index].id == weapon_id:
			return index
	return 0

static func recipe_code(recipe: Dictionary) -> String:
	var clean := normalize(recipe)
	var weapon := weapon_by_id(clean.faction, clean.weapon)
	return "%s-AR-%s" % [String(clean.faction).left(2).to_upper(), String(weapon.id).left(3).to_upper()]
