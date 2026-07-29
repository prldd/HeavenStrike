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
	{"name": "Trinity Rusher", "icon": 3, "stars": 1, "kind": "Strider", "cost": 2, "atk": 2, "hp": 4, "move": 3, "range": 1, "text": "Double Strike — Attacks twice each action."},
	{"name": "Claw Slicer", "icon": 9, "stars": 1, "kind": "Strider", "cost": 3, "atk": 3, "hp": 5, "move": 3, "range": 1, "text": "Double Strike — Attacks twice each action."},
	{"name": "Pub Bouncer", "icon": 2, "stars": 1, "kind": "Duelist", "cost": 2, "atk": 3, "hp": 7, "move": 2, "range": 1, "text": "Fury — Permanently gains +1 ATK after attacking."},
	{"name": "Trinity Basher", "icon": 8, "stars": 1, "kind": "Duelist", "cost": 2, "atk": 3, "hp": 5, "move": 2, "range": 1, "text": "Fury — Permanently gains +1 ATK after attacking."},
	{"name": "Socialite Fencer", "icon": 1, "stars": 1, "kind": "Warden", "cost": 3, "atk": 3, "hp": 10, "move": 2, "range": 1, "text": "Taunting Strike — Target cannot change lanes for 2 turns."},
	{"name": "LDF Peacekeeper", "icon": 7, "stars": 1, "kind": "Warden", "cost": 2, "atk": 2, "hp": 8, "move": 2, "range": 1, "text": "Taunting Strike — Target cannot change lanes for 2 turns."},
	{"name": "Trinity Potshot", "icon": 4, "stars": 1, "kind": "Artillerist", "cost": 2, "atk": 3, "hp": 4, "move": 1, "range": 3, "text": "Piercing Shot — Damages every enemy in range in its lane."},
	{"name": "Factory Markswoman", "icon": 10, "stars": 1, "kind": "Artillerist", "cost": 3, "atk": 4, "hp": 5, "move": 1, "range": 3, "text": "Piercing Shot — Damages every enemy in range in its lane."},
	{"name": "Claw Caster", "icon": 5, "stars": 1, "kind": "Channeler", "cost": 3, "atk": 5, "hp": 4, "move": 1, "range": 3, "text": "Blast — Adjacent enemies take half ATK damage."},
	{"name": "Rage Spellslinger", "icon": 11, "stars": 1, "kind": "Channeler", "cost": 2, "atk": 4, "hp": 3, "move": 1, "range": 3, "text": "Blast — Adjacent enemies take half ATK damage."},
	{"name": "Chain Initiate", "icon": 6, "stars": 1, "kind": "Lifebinder", "cost": 2, "atk": 2, "hp": 5, "move": 1, "range": 2, "text": "Heal — Before moving, gives 2 HP to the lowest-health ally."},
	{"name": "LDF Medic", "icon": 12, "stars": 1, "kind": "Lifebinder", "cost": 3, "atk": 3, "hp": 5, "move": 1, "range": 2, "text": "Heal — Before moving, gives 2 HP to the lowest-health ally."},
	{"name": "Apprentice Builder", "icon": 13, "stars": 2, "kind": "Warden", "cost": 3, "atk": 2, "hp": 4, "move": 2, "range": 1, "text": "Taunting Strike — Target cannot change lanes for 2 turns.", "skill": {"name": "Fortify", "type": "Warcry", "text": "Other allied unit with the lowest HP gains +3 HP for 2 turns."}},
	{"name": "Rage Brute", "icon": 15, "stars": 2, "kind": "Duelist", "cost": 2, "atk": 2, "hp": 4, "move": 2, "range": 1, "text": "Fury — Permanently gains +1 ATK after attacking.", "skill": {"name": "Empower", "type": "Warcry", "text": "Another allied unit gains +1 ATK for 2 turns."}},
	{"name": "Claw Skirmisher", "icon": 17, "stars": 2, "kind": "Strider", "cost": 3, "atk": 2, "hp": 3, "move": 3, "range": 1, "text": "Double Strike — Attacks twice each action.", "skill": {"name": "Pinning Strike", "type": "Strike", "text": "30% chance to Immobilise the attacked enemy for 1 turn."}},
	{"name": "LDF Gunner", "icon": 19, "stars": 2, "kind": "Artillerist", "cost": 2, "atk": 3, "hp": 2, "move": 1, "range": 3, "text": "Piercing Shot — Damages every enemy in range in its lane.", "skill": {"name": "Bolt", "type": "Warcry", "text": "Deal 1 damage to the enemy unit with the highest HP."}},
	{"name": "Order Pupil", "icon": 21, "stars": 2, "kind": "Channeler", "cost": 2, "atk": 3, "hp": 2, "move": 1, "range": 3, "text": "Blast — Adjacent enemies take half ATK damage.", "skill": {"name": "Heaven's Wrath", "type": "Warcry", "text": "Deal 1 damage split between random enemy units."}},
	{"name": "Order Cleric", "icon": 23, "stars": 2, "kind": "Lifebinder", "cost": 3, "atk": 2, "hp": 4, "move": 1, "range": 2, "text": "Heal — Before moving, gives 2 HP to the lowest-health ally.", "skill": {"name": "Empower", "type": "Warcry", "text": "Another allied unit gains +1 ATK for 2 turns."}},
	{"name": "Order Apostle", "icon": 25, "stars": 2, "kind": "Strider", "cost": 2, "atk": 2, "hp": 4, "move": 3, "range": 1, "text": "Double Strike — Attacks twice each action.", "skill": {"name": "Heaven's Wrath", "type": "Warcry", "text": "Deal 1 damage split between random enemy units."}},
	{"name": "Trinity Messenger", "icon": 26, "stars": 2, "kind": "Channeler", "cost": 3, "atk": 4, "hp": 2, "move": 1, "range": 3, "text": "Blast — Adjacent enemies take half ATK damage.", "skill": {"name": "Bolt", "type": "Warcry", "text": "Deal 1 damage to the enemy unit with the highest HP."}},
	{"name": "Minerva the Brave", "icon": 27, "stars": 3, "kind": "Lifebinder", "cost": 2, "atk": 3, "hp": 4, "move": 1, "range": 2, "text": "Heal — Before moving, gives 2 HP to the lowest-health ally.", "skill": {"name": "Fortify", "type": "Warcry", "text": "Other allied unit with the lowest HP gains +3 HP for 2 turns."}},
	{"name": "Naruku the Lookout", "icon": 28, "stars": 4, "kind": "Channeler", "cost": 3, "atk": 3, "hp": 6, "move": 1, "range": 3, "text": "Blast — Adjacent enemies take half ATK damage.", "skill": {"name": "Empower", "type": "Warcry", "text": "Another allied unit gains +1 ATK for 2 turns."}},
	{"name": "Whirling Ragnr", "icon": 29, "stars": 4, "kind": "Duelist", "cost": 2, "atk": 3, "hp": 5, "move": 2, "range": 1, "text": "Fury — Permanently gains +1 ATK after attacking.", "skill": {"name": "Bolt", "type": "Warcry", "text": "Deal 1 damage to the enemy unit with the highest HP."}}
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
