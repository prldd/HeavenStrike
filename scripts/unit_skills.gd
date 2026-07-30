class_name UnitSkills
extends RefCounted

const BattleSimulatorScript = preload("res://scripts/battle_simulator.gd")

static func resolve_warcry(
	actor: Dictionary,
	units: Array,
	target_id: int = -1,
	rng: RandomNumberGenerator = null,
	target_lane: int = -1
) -> Dictionary:
	var result := {"message": "", "affected": []}
	var skill: Dictionary = actor.get("skill", {})
	if skill.get("type", "").to_lower() != "warcry":
		return result
	match skill.get("name", ""):
		"Fortify":
			var target = _lowest_health_ally(actor, units)
			if target != null:
				target.hp += 3
				target.max_hp += 3
				_add_effect(target, "Fortify", 2, 0, 3)
				result.message = "Fortify gives %s +3 HP for 2 turns." % target.name
				result.affected.append(target.id)
		"Empower":
			var target = _ally_by_id(actor, units, target_id)
			if target == null:
				target = _highest_attack_ally(actor, units)
			if target != null:
				target.atk += 1
				_add_effect(target, "Empower", 2, 1, 0)
				result.message = "Empower gives %s +1 ATK for 2 turns." % target.name
				result.affected.append(target.id)
		"Bolt":
			var target = _highest_health_enemy(actor, units)
			if target != null:
				BattleSimulatorScript.apply_unit_damage(target, 1)
				result.message = "Bolt deals 1 damage to %s." % target.name
				result.affected.append(target.id)
		"Heaven's Wrath":
			var candidates := _enemies(actor, units)
			var target = null
			if not candidates.is_empty():
				target = (
					candidates[rng.randi_range(0, candidates.size() - 1)]
					if rng != null else candidates.pick_random()
				)
			if target != null:
				BattleSimulatorScript.apply_unit_damage(target, 1)
				result.message = "Heaven's Wrath deals 1 damage to %s." % target.name
				result.affected.append(target.id)
		"Misfortune":
			var target = _highest_attack_enemy_classes(
				actor, units, ["Strider", "Artillerist"]
			)
			if target != null:
				target.atk = maxi(0, target.atk - 1)
				_add_effect(target, "Misfortune", 2, -1, 0)
				result.message = "Misfortune gives %s -1 ATK for 2 turns." % target.name
				result.affected.append(target.id)
		"Mend":
			var target = _lowest_health_ally(actor, units)
			if target != null:
				BattleSimulatorScript.apply_unit_healing(target, 3, true)
				result.message = "Mend restores 3 HP to %s." % target.name
				result.affected.append(target.id)
		"Plague":
			var victims: Array = units.filter(func(unit): return unit.id != actor.id)
			for target in victims:
				BattleSimulatorScript.apply_unit_damage(target, 1)
				target.poison_turns = maxi(target.get("poison_turns", 0), 2)
				target.poison_damage = maxi(target.get("poison_damage", 0), 1)
				result.affected.append(target.id)
			if not victims.is_empty():
				result.message = "Plague deals 1 damage and Poisons %d other unit%s for 2 turns." % [
					victims.size(), "" if victims.size() == 1 else "s"
				]
		"Envenom":
			var target = _enemy_by_id(actor, units, target_id)
			if target == null:
				target = _highest_health_enemy(actor, units)
			if target != null:
				target.poison_turns = maxi(target.get("poison_turns", 0), 2)
				target.poison_damage = maxi(target.get("poison_damage", 0), 1)
				result.message = "Envenom Poisons %s for 2 turns." % target.name
				result.affected.append(target.id)
		"Pin Down":
			var target = _highest_attack_enemy_classes(
				actor, units, ["Warden", "Duelist", "Strider"]
			)
			if target != null:
				BattleSimulatorScript.apply_unit_damage(target, 1)
				if target.hp > 0:
					target.immobilized_turns = maxi(
						target.get("immobilized_turns", 0), 1
					)
				result.message = "Pin Down deals 1 damage to %s and Immobilises it for 1 turn." % target.name
				result.affected.append(target.id)
		"Demoralize":
			var lane := target_lane
			if lane < 0:
				lane = _best_enemy_lane(actor, units, ["Duelist", "Strider", "Warden"])
			var target_count := 0
			for target in units:
				if (
					target.side == actor.side or target.row != lane
					or target.kind not in ["Duelist", "Strider", "Warden"]
				):
					continue
				target.atk = maxi(0, target.atk - 1)
				_add_effect(target, "Demoralize", 2, -1, 0)
				result.affected.append(target.id)
				target_count += 1
			if target_count > 0:
				result.message = "Demoralize gives %d enem%s in lane %d -1 ATK for 2 turns." % [
					target_count, "y" if target_count == 1 else "ies", lane + 1
				]
		"Punish":
			var target = _highest_attack_enemy_classes(
				actor, units, ["Duelist", "Channeler"]
			)
			if target != null:
				target.atk = maxi(0, target.atk - 1)
				_add_effect(target, "Punish", 2, -1, 0)
				result.message = "Punish gives %s -1 ATK for 2 turns." % target.name
				result.affected.append(target.id)
	return result

static func resolve_chants(_side: int, _units: Array) -> Array:
	# Timing hook for later Chant units.
	return []

static func resolve_start_statuses(side: int, units: Array) -> Array:
	var results: Array = []
	for unit in units:
		if unit.side != side or unit.get("poison_turns", 0) <= 0:
			continue
		var damage: int = maxi(1, unit.get("poison_damage", 1))
		BattleSimulatorScript.apply_unit_damage(unit, damage)
		unit.poison_turns -= 1
		results.append({
			"message": "Poison deals %d damage to %s." % [damage, unit.name],
			"affected": [unit.id]
		})
	return results

static func resolve_strike(
	actor: Dictionary, target: Dictionary, _units: Array, roll: float = -1.0
) -> Dictionary:
	var result := {"message": "", "affected": []}
	var skill: Dictionary = actor.get("skill", {})
	if skill.get("type", "").to_lower() != "strike":
		return result
	var skill_name: String = skill.get("name", "")
	var pin_chance := 0.0
	if skill_name == "Pinning Strike":
		pin_chance = 0.30
	elif skill_name == "Pinning Slice":
		pin_chance = 0.60
	if pin_chance > 0.0:
		var chance_roll := randf() if roll < 0.0 else roll
		if chance_roll < pin_chance and target.hp > 0:
			target.immobilized_turns = maxi(target.get("immobilized_turns", 0), 1)
			result.message = "%s immobilises %s for 1 turn." % [skill_name, target.name]
			result.affected.append(target.id)
	return result

static func resolve_reaction(
	_target: Dictionary, _attacker: Dictionary, _units: Array
) -> Dictionary:
	# Timing hook for later Reaction units.
	return {"message": "", "affected": []}

static func refresh_auras(_units: Array) -> void:
	# Timing hook for later Aura units.
	pass

static func expire_statuses(units: Array, side: int) -> void:
	for unit in units:
		if unit.side == side and unit.get("immobilized_turns", 0) > 0:
			unit.immobilized_turns -= 1

static func timing_tooltip(skill_type: String) -> String:
	match skill_type.to_lower():
		"aura":
			return "Active continuously while this unit is in play."
		"chant":
			return "Activates at the start of each of your turns."
		"reaction":
			return "Activates in response to a specified event."
		"strike":
			return "Activates when this unit attacks."
		"warcry":
			return "Activates when this unit enters the battlefield."
	return ""

static func _add_effect(
	unit: Dictionary, effect_name: String, turns: int, attack: int, health: int
) -> void:
	var effects: Array = unit.get("effects", [])
	effects.append({
		"name": effect_name,
		"turns": turns,
		"attack": attack,
		"health": health
	})
	unit.effects = effects

static func _other_allies(actor: Dictionary, units: Array) -> Array:
	return units.filter(func(unit): return unit.side == actor.side and unit.id != actor.id)

static func _ally_by_id(
	actor: Dictionary, units: Array, target_id: int
):
	if target_id < 0:
		return null
	for unit in units:
		if unit.id == target_id and unit.side == actor.side and unit.id != actor.id:
			return unit
	return null

static func _enemies(actor: Dictionary, units: Array) -> Array:
	return units.filter(func(unit): return unit.side != actor.side)

static func _enemy_by_id(actor: Dictionary, units: Array, target_id: int):
	if target_id < 0:
		return null
	for unit in units:
		if unit.id == target_id and unit.side != actor.side:
			return unit
	return null

static func _lowest_health_ally(actor: Dictionary, units: Array):
	var candidates := _other_allies(actor, units)
	candidates.sort_custom(func(a, b):
		if a.hp == b.hp:
			return a.id < b.id
		return a.hp < b.hp
	)
	return null if candidates.is_empty() else candidates[0]

static func _highest_attack_ally(actor: Dictionary, units: Array):
	var candidates := _other_allies(actor, units)
	candidates.sort_custom(func(a, b):
		if a.atk == b.atk:
			return a.id < b.id
		return a.atk > b.atk
	)
	return null if candidates.is_empty() else candidates[0]

static func _highest_health_enemy(actor: Dictionary, units: Array):
	var candidates := _enemies(actor, units)
	candidates.sort_custom(func(a, b):
		if a.hp == b.hp:
			return a.id < b.id
		return a.hp > b.hp
	)
	return null if candidates.is_empty() else candidates[0]

static func _highest_attack_enemy_classes(
	actor: Dictionary, units: Array, kinds: Array
):
	var candidates := _enemies(actor, units).filter(
		func(unit): return unit.kind in kinds
	)
	candidates.sort_custom(func(a, b):
		if a.atk == b.atk:
			return a.id < b.id
		return a.atk > b.atk
	)
	return null if candidates.is_empty() else candidates[0]

static func _best_enemy_lane(actor: Dictionary, units: Array, kinds: Array) -> int:
	var best_lane := -1
	var best_score := -1
	for lane in 3:
		var score := 0
		for unit in _enemies(actor, units):
			if unit.row == lane and unit.kind in kinds:
				score += 10 + unit.atk
		if score > best_score:
			best_lane = lane
			best_score = score
	return best_lane
