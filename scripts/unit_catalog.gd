class_name UnitCatalog
extends RefCounted

const UNITS := [
	{"name": "Cloudstep", "kind": "Strider", "cost": 2, "atk": 1, "hp": 3, "move": 3, "range": 1, "text": "Strikes twice."},
	{"name": "Emberblade", "kind": "Duelist", "cost": 3, "atk": 2, "hp": 5, "move": 2, "range": 1, "text": "Gains +1 ATK after attacking."},
	{"name": "Ironroot", "kind": "Warden", "cost": 2, "atk": 1, "hp": 7, "move": 2, "range": 1, "text": "A durable lane blocker."},
	{"name": "Sunlance", "kind": "Artillerist", "cost": 4, "atk": 3, "hp": 3, "move": 1, "range": 3, "text": "Pierces the unit behind its target."},
	{"name": "Stormsinger", "kind": "Channeler", "cost": 4, "atk": 2, "hp": 4, "move": 1, "range": 3, "text": "Deals 1 splash damage in adjacent lanes."},
	{"name": "Dawnmender", "kind": "Lifebinder", "cost": 3, "atk": 1, "hp": 5, "move": 1, "range": 2, "text": "Heals a nearby ally for 2."}
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

