class_name MechaConceptCatalog
extends RefCounted

const FACTIONS := ["Coal", "Wind"]
const CLASSES := ["Artillerist", "Duelist"]
const POSES := ["Idle", "Traverse", "Attack"]
const BODY_NAME := "Shared Line Chassis"
const PART_NAMES := [
	"head", "torso", "accessory", "shoulder_left", "shoulder_right",
	"upper_arm_left", "upper_arm_right", "forearm_left", "forearm_right",
	"hand_left", "hand_right", "thigh_left", "thigh_right", "shin_left",
	"shin_right", "foot_left", "foot_right"
]

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

const UNARMED_LOADOUT := {
	"id": "unarmed", "name": "Unarmed", "row": -1,
	"description": "No held weapon. Independent hands drive guarded idle, traversal, and impact poses."
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
		"class": "Artillerist",
		"body": BODY_NAME,
		"weapon": "rail_furnace",
		"pose": "Idle"
	}

static func normalize(recipe: Dictionary) -> Dictionary:
	var result := default_recipe()
	for key in result:
		if recipe.has(key):
			result[key] = recipe[key]
	if result.faction not in FACTIONS:
		result.faction = "Coal"
	if result["class"] not in CLASSES:
		result["class"] = "Artillerist"
	if result.pose not in POSES:
		result.pose = "Idle"
	result.body = BODY_NAME
	if loadout_by_id(String(result.faction), String(result["class"]), String(result.weapon)).is_empty():
		result.weapon = loadouts_for(String(result.faction), String(result["class"]))[0].id
	return result

static func weapons_for(faction: String) -> Array:
	return WEAPONS.get(faction, WEAPONS.Coal)

static func loadouts_for(faction: String, kind: String) -> Array:
	return weapons_for(faction) if kind == "Artillerist" else [UNARMED_LOADOUT]

static func weapon_by_id(faction: String, weapon_id: String) -> Dictionary:
	for weapon in weapons_for(faction):
		if weapon.id == weapon_id:
			return weapon
	return {}

static func loadout_by_id(faction: String, kind: String, loadout_id: String) -> Dictionary:
	for loadout in loadouts_for(faction, kind):
		if loadout.id == loadout_id:
			return loadout
	return {}

static func weapon_index(faction: String, weapon_id: String) -> int:
	var weapons := weapons_for(faction)
	for index in weapons.size():
		if weapons[index].id == weapon_id:
			return index
	return 0

static func loadout_index(faction: String, kind: String, loadout_id: String) -> int:
	var loadouts := loadouts_for(faction, kind)
	for index in loadouts.size():
		if loadouts[index].id == loadout_id:
			return index
	return 0

static func part_path(faction: String, part_name: String) -> String:
	return "res://assets/units/modular/parts/%s/%s.png" % [
		faction.to_lower(), part_name
	]

static func recipe_code(recipe: Dictionary) -> String:
	var clean := normalize(recipe)
	var loadout := loadout_by_id(clean.faction, clean["class"], clean.weapon)
	return "%s-%s-%s" % [
		String(clean.faction).left(2).to_upper(),
		String(clean["class"]).left(2).to_upper(),
		String(loadout.id).left(3).to_upper()
	]
