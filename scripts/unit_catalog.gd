class_name UnitCatalog
extends RefCounted

const CLASS_NAMES := {
	"Strider": "Scout",
	"Duelist": "Fighter",
	"Warden": "Defender",
	"Artillerist": "Gunner",
	"Channeler": "Mage",
	"Lifebinder": "Priest"
}

const UNITS := [
	{"name": "Trinity Rusher", "icon": 3, "kind": "Strider", "cost": 2, "atk": 2, "hp": 4, "move": 3, "range": 1, "text": "Double Strike — Attacks twice each action."},
	{"name": "Claw Slicer", "icon": 9, "kind": "Strider", "cost": 3, "atk": 3, "hp": 5, "move": 3, "range": 1, "text": "Double Strike — Attacks twice each action."},
	{"name": "Pub Bouncer", "icon": 2, "kind": "Duelist", "cost": 2, "atk": 3, "hp": 7, "move": 2, "range": 1, "text": "Fury — Permanently gains +1 ATK after attacking."},
	{"name": "Trinity Basher", "icon": 8, "kind": "Duelist", "cost": 2, "atk": 3, "hp": 5, "move": 2, "range": 1, "text": "Fury — Permanently gains +1 ATK after attacking."},
	{"name": "Socialite Fencer", "icon": 1, "kind": "Warden", "cost": 3, "atk": 3, "hp": 10, "move": 2, "range": 1, "text": "Taunting Strike — Target cannot change lanes for 2 turns."},
	{"name": "LDF Peacekeeper", "icon": 7, "kind": "Warden", "cost": 2, "atk": 2, "hp": 8, "move": 2, "range": 1, "text": "Taunting Strike — Target cannot change lanes for 2 turns."},
	{"name": "Trinity Potshot", "icon": 4, "kind": "Artillerist", "cost": 2, "atk": 3, "hp": 4, "move": 1, "range": 3, "text": "Piercing Shot — Damages every enemy in range in its lane."},
	{"name": "Factory Markswoman", "icon": 10, "kind": "Artillerist", "cost": 3, "atk": 4, "hp": 5, "move": 1, "range": 3, "text": "Piercing Shot — Damages every enemy in range in its lane."},
	{"name": "Claw Caster", "icon": 5, "kind": "Channeler", "cost": 3, "atk": 5, "hp": 4, "move": 1, "range": 3, "text": "Blast — Adjacent enemies take half ATK damage."},
	{"name": "Rage Spellslinger", "icon": 11, "kind": "Channeler", "cost": 2, "atk": 4, "hp": 3, "move": 1, "range": 3, "text": "Blast — Adjacent enemies take half ATK damage."},
	{"name": "Chain Initiate", "icon": 6, "kind": "Lifebinder", "cost": 2, "atk": 2, "hp": 5, "move": 1, "range": 2, "text": "Heal — Before moving, gives 2 HP to the lowest-health ally."},
	{"name": "LDF Medic", "icon": 12, "kind": "Lifebinder", "cost": 3, "atk": 3, "hp": 5, "move": 1, "range": 2, "text": "Heal — Before moving, gives 2 HP to the lowest-health ally."}
]

static func all_units() -> Array:
	var result: Array = []
	for unit in UNITS:
		result.append(unit.duplicate(true))
	return result

static func by_name(unit_name: String) -> Dictionary:
	for unit in UNITS:
		if unit.name == unit_name:
			return unit.duplicate(true)
	return {}

static func display_class(kind: String) -> String:
	return CLASS_NAMES.get(kind, kind)
