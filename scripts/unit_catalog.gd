class_name UnitCatalog
extends RefCounted

const UNITS := [
	{"name": "Trinity Rusher", "kind": "Strider", "cost": 2, "atk": 2, "hp": 4, "move": 3, "range": 1, "text": "Double Strike: attacks twice."},
	{"name": "Claw Slicer", "kind": "Strider", "cost": 3, "atk": 3, "hp": 5, "move": 3, "range": 1, "text": "Double Strike: attacks twice."},
	{"name": "Pub Bouncer", "kind": "Duelist", "cost": 2, "atk": 3, "hp": 7, "move": 2, "range": 1, "text": "Fury: gains +1 ATK after attacking."},
	{"name": "Trinity Basher", "kind": "Duelist", "cost": 2, "atk": 3, "hp": 5, "move": 2, "range": 1, "text": "Fury: gains +1 ATK after attacking."},
	{"name": "Socialite Fencer", "kind": "Warden", "cost": 3, "atk": 3, "hp": 10, "move": 2, "range": 1, "text": "Taunting Strike: locks its target into the current row."},
	{"name": "LDF Peacekeeper", "kind": "Warden", "cost": 2, "atk": 2, "hp": 8, "move": 2, "range": 1, "text": "Taunting Strike: locks its target into the current row."},
	{"name": "Trinity Potshot", "kind": "Artillerist", "cost": 2, "atk": 3, "hp": 4, "move": 1, "range": 3, "text": "Piercing Shot: hits the unit behind its target."},
	{"name": "Factory Markswoman", "kind": "Artillerist", "cost": 3, "atk": 4, "hp": 5, "move": 1, "range": 3, "text": "Piercing Shot: hits the unit behind its target."},
	{"name": "Claw Caster", "kind": "Channeler", "cost": 3, "atk": 5, "hp": 4, "move": 1, "range": 3, "text": "Blast: deals 1 splash damage in adjacent lanes."},
	{"name": "Rage Spellslinger", "kind": "Channeler", "cost": 2, "atk": 4, "hp": 3, "move": 1, "range": 3, "text": "Blast: deals 1 splash damage in adjacent lanes."},
	{"name": "Chain Initiate", "kind": "Lifebinder", "cost": 2, "atk": 2, "hp": 5, "move": 1, "range": 2, "text": "Heal: restores 2 HP to a nearby ally."},
	{"name": "LDF Medic", "kind": "Lifebinder", "cost": 3, "atk": 3, "hp": 5, "move": 1, "range": 2, "text": "Heal: restores 2 HP to a nearby ally."}
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
