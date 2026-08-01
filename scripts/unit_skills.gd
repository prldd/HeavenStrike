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
	var level := int(actor.get("level", 1))
	match skill.get("name", ""):
		"Fortify":
			var target = _lowest_health_ally(actor, units)
			if target != null:
				var amount := rank_value(skill, level, 0, 3)
				var turns := rank_value(skill, level, 1, 2)
				target.hp += amount
				target.max_hp += amount
				_add_effect(target, "Fortify", turns, 0, amount)
				result.message = "Fortify gives %s +%d HP for %s." % [
					target.name, amount, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Empower":
			var target = _ally_by_id(actor, units, target_id)
			if target == null:
				target = _highest_attack_ally(actor, units)
			if target != null:
				var amount := rank_value(skill, level, 0, 1)
				var turns := rank_value(skill, level, 1, 2)
				target.atk += amount
				_add_effect(target, "Empower", turns, amount, 0)
				result.message = "Empower gives %s +%d ATK for %s." % [
					target.name, amount, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Bolt":
			var target = _highest_health_enemy(actor, units)
			if target != null:
				var damage := rank_value(skill, level, 0, 1)
				BattleSimulatorScript.apply_unit_damage(target, damage)
				result.message = "Bolt deals %d damage to %s." % [damage, target.name]
				result.affected.append(target.id)
		"Heaven's Wrath":
			var damage := rank_value(skill, level, 0, 1)
			var hits := 0
			var last_target = null
			for strike in damage:
				var candidates := _enemies(actor, units).filter(
					func(unit): return unit.hp > 0
				)
				if candidates.is_empty():
					break
				last_target = (
					candidates[rng.randi_range(0, candidates.size() - 1)]
					if rng != null else candidates.pick_random()
				)
				BattleSimulatorScript.apply_unit_damage(last_target, 1)
				if last_target.id not in result.affected:
					result.affected.append(last_target.id)
				hits += 1
			if hits == 1:
				result.message = "Heaven's Wrath deals 1 damage to %s." % last_target.name
			elif hits > 1:
				result.message = (
					"Heaven's Wrath deals %d damage split between random enemy units." % hits
				)
		"Misfortune":
			var target = _highest_attack_enemy_classes(
				actor, units, ["Strider", "Artillerist"]
			)
			if target != null:
				var amount := rank_value(skill, level, 0, 1)
				var turns := rank_value(skill, level, 1, 2)
				target.atk = maxi(0, target.atk - amount)
				_add_effect(target, "Misfortune", turns, -amount, 0)
				result.message = "Misfortune gives %s -%d ATK for %s." % [
					target.name, amount, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Mend":
			var target = _lowest_health_ally(actor, units)
			if target != null:
				var amount := rank_value(skill, level, 0, 3)
				BattleSimulatorScript.apply_unit_healing(target, amount, true)
				result.message = "Mend restores %d HP to %s." % [amount, target.name]
				result.affected.append(target.id)
		"Plague":
			var damage := rank_value(skill, level, 0, 1)
			var turns := rank_value(skill, level, 1, 2)
			var victims: Array = units.filter(func(unit): return unit.id != actor.id)
			for target in victims:
				BattleSimulatorScript.apply_unit_damage(target, damage)
				target.poison_turns = maxi(target.get("poison_turns", 0), turns)
				target.poison_damage = maxi(target.get("poison_damage", 0), 1)
				result.affected.append(target.id)
			if not victims.is_empty():
				result.message = "Plague deals %d damage and Poisons %d other unit%s for %s." % [
					damage, victims.size(), "" if victims.size() == 1 else "s",
					_turn_label(turns)
				]
		"Envenom":
			var target = _enemy_by_id(actor, units, target_id)
			if target == null:
				target = _highest_health_enemy(actor, units)
			if target != null:
				var turns := rank_value(skill, level, 0, 2)
				target.poison_turns = maxi(target.get("poison_turns", 0), turns)
				target.poison_damage = maxi(target.get("poison_damage", 0), 1)
				result.message = "Envenom Poisons %s for %s." % [
					target.name, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Pin Down":
			var target = _highest_attack_enemy_classes(
				actor, units, ["Warden", "Duelist", "Strider"]
			)
			if target != null:
				var damage := rank_value(skill, level, 0, 1)
				var turns := rank_value(skill, level, 1, 1)
				BattleSimulatorScript.apply_unit_damage(target, damage)
				if target.hp > 0:
					target.immobilized_turns = maxi(
						target.get("immobilized_turns", 0), turns
					)
				result.message = "Pin Down deals %d damage to %s and Immobilises it for %s." % [
					damage, target.name, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Sunder Armour":
			var target = _highest_health_enemy_classes(
				actor, units, ["Warden", "Duelist"]
			)
			if target != null:
				var damage := rank_value(skill, level, 0, 1)
				var turns := rank_value(skill, level, 1, 2)
				BattleSimulatorScript.apply_unit_damage(target, damage)
				if target.hp > 0:
					if target.get("vulnerable_turns", 0) > 0:
						target.vulnerable_stacks = target.get("vulnerable_stacks", 1) + 1
					else:
						target.vulnerable_stacks = 1
					target.vulnerable_turns = maxi(
						target.get("vulnerable_turns", 0), turns
					)
				var stack_note := ""
				if target.hp > 0 and target.get("vulnerable_stacks", 1) > 1:
					stack_note = " (stack %d)" % target.vulnerable_stacks
				result.message = "Sunder Armour deals %d damage to %s and makes it Vulnerable for %s%s." % [
					damage, target.name, _turn_label(turns), stack_note
				]
				result.affected.append(target.id)
		"Demoralize":
			var lane := target_lane
			if lane < 0:
				lane = _best_enemy_lane(actor, units, ["Duelist", "Strider", "Warden"])
			var amount := rank_value(skill, level, 0, 1)
			var turns := rank_value(skill, level, 1, 2)
			var target_count := 0
			for target in units:
				if (
					target.side == actor.side or target.row != lane
					or target.kind not in ["Duelist", "Strider", "Warden"]
				):
					continue
				target.atk = maxi(0, target.atk - amount)
				_add_effect(target, "Demoralize", turns, -amount, 0)
				result.affected.append(target.id)
				target_count += 1
			if target_count > 0:
				result.message = "Demoralize gives %d enem%s in lane %d -%d ATK for %s." % [
					target_count, "y" if target_count == 1 else "ies", lane + 1,
					amount, _turn_label(turns)
				]
		"Punish":
			var target = _highest_attack_enemy_classes(
				actor, units, ["Duelist", "Channeler"]
			)
			if target != null:
				var amount := rank_value(skill, level, 0, 1)
				var turns := rank_value(skill, level, 1, 2)
				target.atk = maxi(0, target.atk - amount)
				_add_effect(target, "Punish", turns, -amount, 0)
				result.message = "Punish gives %s -%d ATK for %s." % [
					target.name, amount, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Big Game Hunter":
			var target = _highest_health_enemy(actor, units)
			if target != null:
				var damage := rank_value(skill, level, 0, 1)
				var turns := rank_value(skill, level, 1, 2)
				BattleSimulatorScript.apply_unit_damage(target, damage)
				if target.hp > 0:
					if target.get("vulnerable_turns", 0) > 0:
						target.vulnerable_stacks = target.get("vulnerable_stacks", 1) + 1
					else:
						target.vulnerable_stacks = 1
					target.vulnerable_turns = maxi(
						target.get("vulnerable_turns", 0), turns
					)
				var stack_note := ""
				if target.hp > 0 and target.get("vulnerable_stacks", 1) > 1:
					stack_note = " (stack %d)" % target.vulnerable_stacks
				result.message = "Big Game Hunter deals %d damage to %s and makes it Vulnerable for %s%s." % [
					damage, target.name, _turn_label(turns), stack_note
				]
				result.affected.append(target.id)
		"Contagion":
			var damage := rank_value(skill, level, 0, 1)
			var turns := rank_value(skill, level, 1, 2)
			var victims := _enemies(actor, units).filter(
				func(unit): return unit.kind in ["Channeler", "Lifebinder"]
			)
			for target in victims:
				BattleSimulatorScript.apply_unit_damage(target, damage)
				target.poison_turns = maxi(target.get("poison_turns", 0), turns)
				target.poison_damage = maxi(target.get("poison_damage", 0), 1)
				result.affected.append(target.id)
			if not victims.is_empty():
				result.message = "Contagion deals %d damage to %d enemy Mage%s and Priest%s and Poisons them for %s." % [
					damage, victims.size(), "" if victims.size() == 1 else "s",
					"" if victims.size() == 1 else "s", _turn_label(turns)
				]
		"Meteor Barrage":
			var lane := target_lane
			if lane < 0:
				lane = _best_enemy_lane(actor, units, [])
			var damage := rank_value(skill, level, 0, 2)
			var target_count := 0
			for target in units:
				if target.side == actor.side or target.row != lane:
					continue
				BattleSimulatorScript.apply_unit_damage(target, damage)
				result.affected.append(target.id)
				target_count += 1
			if target_count > 0:
				result.message = "Meteor Barrage deals %d damage to %d enem%s in lane %d." % [
					damage, target_count, "y" if target_count == 1 else "ies", lane + 1
				]
		"Freeze!":
			var lane := target_lane
			if lane < 0:
				lane = _best_enemy_lane(actor, units, ["Strider", "Duelist"])
			var damage := rank_value(skill, level, 0, 1)
			var turns := rank_value(skill, level, 1, 1)
			var target_count := 0
			for target in units:
				if (
					target.side == actor.side or target.row != lane
					or target.kind not in ["Strider", "Duelist"]
				):
					continue
				BattleSimulatorScript.apply_unit_damage(target, damage)
				if target.hp > 0:
					target.immobilized_turns = maxi(
						target.get("immobilized_turns", 0), turns
					)
				result.affected.append(target.id)
				target_count += 1
			if target_count > 0:
				result.message = "Freeze! deals %d damage to %d enem%s in lane %d and Immobilises them for %s." % [
					damage, target_count, "y" if target_count == 1 else "ies",
					lane + 1, _turn_label(turns)
				]
		"Protect":
			var target = _ally_by_id(actor, units, target_id)
			if target == null:
				target = _lowest_health_ally(actor, units)
			if target != null:
				var turns := rank_value(skill, level, 0, 2)
				target.protect_turns = maxi(target.get("protect_turns", 0), turns)
				result.message = "Protect grants %s Protect for %s." % [
					target.name, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Fireball":
			var target = _enemy_by_id(actor, units, target_id)
			if target == null:
				target = _highest_health_enemy(actor, units)
			if target != null:
				var damage := rank_value(skill, level, 0, 1)
				var splash := rank_value(skill, level, 1, 1)
				BattleSimulatorScript.apply_unit_damage(target, damage)
				result.affected.append(target.id)
				var adjacent: Array = []
				for other in _enemies(actor, units):
					if other.id == target.id:
						continue
					var gap: int = absi(other.row - target.row) + absi(other.col - target.col)
					if gap != 1:
						continue
					BattleSimulatorScript.apply_unit_damage(other, splash)
					result.affected.append(other.id)
					adjacent.append(other.name)
				result.message = "Fireball deals %d damage to %s." % [damage, target.name]
				if not adjacent.is_empty():
					result.message += " Adjacent %s take%s %d damage." % [
						", ".join(adjacent), "s" if adjacent.size() == 1 else "", splash
					]
		"Warrior's Vigour":
			var candidates := _other_allies(actor, units).filter(
				func(unit): return unit.kind in ["Warden", "Duelist"]
			)
			candidates.sort_custom(func(a, b):
				if a.hp == b.hp:
					return a.id < b.id
				return a.hp < b.hp
			)
			if not candidates.is_empty():
				var target = candidates[0]
				var health := rank_value(skill, level, 0, 2)
				var attack := rank_value(skill, level, 1, 1)
				var turns := rank_value(skill, level, 2, 2)
				target.hp += health
				target.max_hp += health
				target.atk += attack
				_add_effect(target, "Warrior's Vigour", turns, attack, health)
				result.message = "Warrior's Vigour gives %s +%d HP and +%d ATK for %s." % [
					target.name, health, attack, _turn_label(turns)
				]
				result.affected.append(target.id)
	return result

static func resolve_chants(side: int, units: Array) -> Array:
	var results: Array = []
	for unit in units:
		if unit.side != side or unit.get("hp", 0) <= 0:
			continue
		var skill: Dictionary = unit.get("skill", {})
		if skill.get("type", "").to_lower() != "chant":
			continue
		var level := int(unit.get("level", 1))
		match skill.get("name", ""):
			"Sundering Smash":
				var damage := rank_value(skill, level, 0, 1)
				var turns := rank_value(skill, level, 1, 2)
				var result := {"message": "", "affected": [], "sound": "mage"}
				for target in units:
					if target.side == side or target.row != unit.row or target.hp <= 0:
						continue
					BattleSimulatorScript.apply_unit_damage(target, damage)
					if target.hp > 0:
						if target.get("vulnerable_turns", 0) > 0:
							target.vulnerable_stacks = target.get("vulnerable_stacks", 1) + 1
						else:
							target.vulnerable_stacks = 1
						target.vulnerable_turns = maxi(
							target.get("vulnerable_turns", 0), turns
						)
					result.affected.append(target.id)
				if not result.affected.is_empty():
					result.message = "Sundering Smash deals %d damage to %d enem%s in lane %d and makes them Vulnerable for %s." % [
						damage, result.affected.size(),
						"y" if result.affected.size() == 1 else "ies",
						unit.row + 1, _turn_label(turns)
					]
					results.append(result)
	return results

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
	var level := int(actor.get("level", 1))
	if skill_name == "Pinning Strike" or skill_name == "Pinning Slice":
		var fallback := 30 if skill_name == "Pinning Strike" else 60
		var pin_chance := rank_value(skill, level, 0, fallback) / 100.0
		var turns := rank_value(skill, level, 1, 1)
		var chance_roll := randf() if roll < 0.0 else roll
		if chance_roll < pin_chance and target.hp > 0:
			target.immobilized_turns = maxi(target.get("immobilized_turns", 0), turns)
			result.message = "%s immobilises %s for %s." % [
				skill_name, target.name, _turn_label(turns)
			]
			result.affected.append(target.id)
	elif skill_name == "Poison Strike":
		var poison_chance: float = skill.get("chance", -1.0)
		if poison_chance < 0.0:
			poison_chance = rank_value(skill, level, 0, 50) / 100.0
		var turns := rank_value(skill, level, 1, 2)
		var chance_roll := randf() if roll < 0.0 else roll
		if chance_roll < poison_chance and target.hp > 0:
			target.poison_turns = maxi(target.get("poison_turns", 0), turns)
			target.poison_damage = maxi(target.get("poison_damage", 0), 1)
			result.message = "Poison Strike Poisons %s for %s." % [
				target.name, _turn_label(turns)
			]
			result.affected.append(target.id)
	elif skill_name == "Weakening Strike":
		var weaken_chance := rank_value(skill, level, 0, 60) / 100.0
		var amount := rank_value(skill, level, 1, 1)
		var turns := rank_value(skill, level, 2, 2)
		var chance_roll := randf() if roll < 0.0 else roll
		if chance_roll < weaken_chance and target.hp > 0:
			target.atk = maxi(0, target.get("atk", 0) - amount)
			_add_effect(target, "Weakening Strike", turns, -amount, 0)
			result.message = "Weakening Strike gives %s -%d ATK for %s." % [
				target.name, amount, _turn_label(turns)
			]
			result.affected.append(target.id)
	return result

static func resolve_reaction(
	target: Dictionary, attacker: Dictionary, _units: Array, roll: float = -1.0
) -> Dictionary:
	var result := {"message": "", "affected": []}
	var skill: Dictionary = target.get("skill", {})
	if skill.get("type", "").to_lower() != "reaction":
		return result
	if target.get("hp", 0) <= 0 or attacker.get("hp", 0) <= 0:
		return result
	var level := int(target.get("level", 1))
	match skill.get("name", ""):
		"Hopping Mad":
			var damage := rank_value(skill, level, 0, 3)
			BattleSimulatorScript.apply_unit_damage(attacker, damage)
			result.message = "Hopping Mad: %s attacks back for %d damage." % [
				target.name, damage
			]
			result.affected.append(attacker.id)
		"Shield Wall":
			var wall_chance := rank_value(skill, level, 0, 40) / 100.0
			var turns := rank_value(skill, level, 1, 2)
			var chance_roll := randf() if roll < 0.0 else roll
			if chance_roll < wall_chance:
				target.protect_turns = maxi(target.get("protect_turns", 0), turns)
				result.message = "Shield Wall grants %s Protect for %s." % [
					target.name, _turn_label(turns)
				]
				result.affected.append(target.id)
	return result

## Recomputes aura buffs from living sources. Each call strips the bonus a
## unit currently carries (`aura_hp`) and re-applies what surviving aura
## units grant, so a buff disappears as soon as its source leaves the board.
## Every change is appended to `events` as {"unit_id", "delta", "label"} so
## callers can log aura gains and losses.
static func refresh_auras(units: Array, events: Array = []) -> void:
	var desired := {}
	var desired_labels := {}
	for source in units:
		if source.get("hp", 1) <= 0:
			continue
		var skill: Dictionary = source.get("skill", {})
		if skill.get("type", "").to_lower() != "aura":
			continue
		var level := int(source.get("level", 1))
		match skill.get("name", ""):
			"Moonlight":
				var amount := rank_value(skill, level, 0, 4)
				for unit in units:
					if unit.side == source.side and unit.id != source.id:
						desired[unit.id] = int(desired.get(unit.id, 0)) + amount
						var labels: Array = desired_labels.get(unit.id, [])
						if "Moonlight" not in labels:
							labels.append("Moonlight")
						desired_labels[unit.id] = labels
	for unit in units:
		if unit.get("hp", 0) <= 0:
			continue
		var applied := int(unit.get("aura_hp", 0))
		var want := int(desired.get(unit.id, 0))
		if applied == want:
			continue
		var label := " + ".join(desired_labels.get(unit.id, []))
		if label.is_empty():
			label = unit.get("aura_label", "the aura")
		events.append({"unit_id": unit.id, "delta": want - applied, "label": label})
		unit.max_hp += want - applied
		unit.hp = clampi(unit.hp + want - applied, 1, unit.max_hp)
		unit.aura_hp = want
		if want > 0:
			unit.aura_label = label
		else:
			unit.erase("aura_label")

static func expire_statuses(units: Array, side: int) -> void:
	for unit in units:
		if unit.side == side and unit.get("immobilized_turns", 0) > 0:
			unit.immobilized_turns -= 1
		if unit.side == side and unit.get("vulnerable_turns", 0) > 0:
			unit.vulnerable_turns -= 1
			if unit.vulnerable_turns <= 0:
				unit.vulnerable_stacks = 0
		if unit.side == side and unit.get("protect_turns", 0) > 0:
			unit.protect_turns -= 1

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

## Reads the magnitude in column `index` of the skill's rank table at the
## given unit level, falling back when the table is missing. Rank table
## entries look like "3 HP" or "30% chance"; the leading number is returned.
static func rank_value(skill: Dictionary, level: int, index: int, fallback: int) -> int:
	var rows: Array = skill.get("rank_values", [])
	if rows.is_empty():
		return fallback
	var row = rows[clampi(level, 1, rows.size()) - 1]
	if row is not Array or index >= row.size():
		return fallback
	var token := str(row[index]).split(" ")[0].trim_suffix("%")
	return int(token) if token.is_valid_int() else fallback

static func _turn_label(turns: int) -> String:
	return "%d turn%s" % [turns, "" if turns == 1 else "s"]

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

static func _highest_health_enemy_classes(
	actor: Dictionary, units: Array, kinds: Array
):
	var candidates := _enemies(actor, units).filter(
		func(unit): return unit.kind in kinds
	)
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
			if unit.row == lane and (kinds.is_empty() or unit.kind in kinds):
				score += 10 + unit.atk
		if score > best_score:
			best_lane = lane
			best_score = score
	return best_lane
