class_name CaptainSkills
extends RefCounted

const SKILLS := [
	"Rally",
	"Bloodlust",
	"Aid",
	"Healing Wave",
	"Shield",
	"Last Stand",
	"Lightning Burst",
	"Firestorm"
]

const DESCRIPTIONS := {
	"Rally": "All allied units gain +1 ATK for 1 turn.",
	"Bloodlust": "The strongest allied unit gains +2 ATK for 1 turn.",
	"Aid": "Restore 3 HP to the most damaged allied unit.",
	"Healing Wave": "Restore 2 HP to every damaged allied unit.",
	"Shield": "Give your Captain 5 Shield for 2 turns.",
	"Last Stand": "At 8 Captain HP or less, allies gain +2 ATK for 1 turn.",
	"Lightning Burst": "Deal 3 damage to the strongest enemy unit or Captain.",
	"Firestorm": "Deal 2 damage to every enemy unit, or the enemy Captain."
}

static func apply(skill_name: String, side: int, units: Array, captain_hp: int) -> Dictionary:
	var allies: Array = units.filter(func(unit): return unit.side == side)
	var enemies: Array = units.filter(func(unit): return unit.side != side)
	var result := {
		"success": false,
		"message": "",
		"captain_damage": 0,
		"shield": 0,
		"shield_turns": 0,
		"affected": []
	}

	match skill_name:
		"Rally":
			if allies.is_empty():
				result.message = "Rally needs at least one allied unit."
				return result
			for unit in allies:
				_add_attack_effect(unit, "Rally", 1, 1)
				result.affected.append(unit.id)
			result.message = "Rally grants all allied units +1 ATK this turn."
		"Bloodlust":
			if allies.is_empty():
				result.message = "Bloodlust needs an allied unit."
				return result
			allies.sort_custom(func(a, b): return a.atk > b.atk)
			_add_attack_effect(allies[0], "Bloodlust", 2, 1)
			result.affected.append(allies[0].id)
			result.message = "Bloodlust grants %s +2 ATK this turn." % allies[0].name
		"Aid":
			var target = _most_damaged(allies)
			if target == null:
				result.message = "Aid needs a damaged allied unit."
				return result
			var restored: int = mini(3, target.max_hp - target.hp)
			target.hp += restored
			result.affected.append(target.id)
			result.message = "Aid restores %d HP to %s." % [restored, target.name]
		"Healing Wave":
			var healed := 0
			for unit in allies:
				if unit.hp < unit.max_hp:
					unit.hp = mini(unit.max_hp, unit.hp + 2)
					result.affected.append(unit.id)
					healed += 1
			if healed == 0:
				result.message = "Healing Wave needs a damaged allied unit."
				return result
			result.message = "Healing Wave restores allied units."
		"Shield":
			result.shield = 5
			result.shield_turns = 2
			result.message = "Shield protects the Captain for 2 turns."
		"Last Stand":
			if captain_hp > 8:
				result.message = "Last Stand requires 8 Captain HP or less."
				return result
			if allies.is_empty():
				result.message = "Last Stand needs at least one allied unit."
				return result
			for unit in allies:
				_add_attack_effect(unit, "Last Stand", 2, 1)
				result.affected.append(unit.id)
			result.message = "Last Stand grants all allied units +2 ATK this turn."
		"Lightning Burst":
			if enemies.is_empty():
				result.captain_damage = 3
				result.message = "Lightning Burst strikes the enemy Captain for 3."
			else:
				enemies.sort_custom(func(a, b): return a.atk > b.atk)
				enemies[0].hp -= 3
				result.affected.append(enemies[0].id)
				result.message = "Lightning Burst deals 3 damage to %s." % enemies[0].name
		"Firestorm":
			if enemies.is_empty():
				result.captain_damage = 2
				result.message = "Firestorm scorches the enemy Captain for 2."
			else:
				for unit in enemies:
					unit.hp -= 2
					result.affected.append(unit.id)
				result.message = "Firestorm deals 2 damage to every enemy unit."
		_:
			result.message = "Unknown Captain skill."
			return result

	result.success = true
	return result

static func expire_effects(units: Array, side: int) -> void:
	for unit in units:
		if unit.side != side:
			continue
		var retained: Array = []
		for effect in unit.get("effects", []):
			effect.turns -= 1
			if effect.turns <= 0:
				unit.atk = maxi(0, unit.atk - effect.get("attack", 0))
			else:
				retained.append(effect)
		unit.effects = retained

static func effect_summary(unit: Dictionary) -> String:
	var labels: Array = []
	for effect in unit.get("effects", []):
		labels.append("%s (%d turn%s)" % [
			effect.name,
			effect.turns,
			"" if effect.turns == 1 else "s"
		])
	if unit.get("taunt_turns", 0) > 0:
		labels.append("Taunted (%d turns)" % unit.taunt_turns)
	return ", ".join(labels)

static func _add_attack_effect(unit: Dictionary, effect_name: String, amount: int, turns: int) -> void:
	unit.atk += amount
	var effects: Array = unit.get("effects", [])
	effects.append({"name": effect_name, "attack": amount, "turns": turns})
	unit.effects = effects

static func _most_damaged(units: Array):
	var damaged: Array = units.filter(func(unit): return unit.hp < unit.max_hp)
	if damaged.is_empty():
		return null
	damaged.sort_custom(func(a, b):
		return (a.hp / float(a.max_hp)) < (b.hp / float(b.max_hp))
	)
	return damaged[0]
