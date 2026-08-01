class_name UnitSkills
extends RefCounted

const BattleSimulatorScript = preload("res://scripts/battle_simulator.gd")
const BattleRulesScript = preload("res://scripts/battle_rules.gd")

## Chants that resolve at the end of their side's turn instead of the start.
const END_TURN_CHANTS := ["Impairing Joust", "Galatine's Ground"]

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
		"Prune":
			var target = _ally_by_id_classes(
				actor, units, target_id, ["Lifebinder", "Channeler"]
			)
			if target == null:
				target = _lowest_health_ally_classes(
					actor, units, ["Lifebinder", "Channeler"]
				)
			if target != null:
				var turns := rank_value(skill, level, 0, 2)
				target.immobilized_turns = 0
				target.regen_turns = maxi(target.get("regen_turns", 0), turns)
				result.message = "Prune cleanses %s and grants Regen for %s." % [
					target.name, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Medic!":
			var target = _ally_by_id_classes(
				actor, units, target_id, ["Duelist", "Warden"]
			)
			if target == null:
				target = _lowest_health_ally_classes(actor, units, ["Duelist", "Warden"])
			if target != null:
				var turns := rank_value(skill, level, 0, 2)
				target.immobilized_turns = 0
				target.regen_turns = maxi(target.get("regen_turns", 0), turns)
				result.message = "Medic! cleanses %s and grants Regen for %s." % [
					target.name, _turn_label(turns)
				]
				result.affected.append(target.id)
		"New Look":
			var target = _ally_by_id_classes(
				actor, units, target_id, ["Strider", "Artillerist"]
			)
			if target == null:
				target = _lowest_health_ally_classes(
					actor, units, ["Strider", "Artillerist"]
				)
			if target != null:
				var turns := rank_value(skill, level, 0, 2)
				target.immobilized_turns = 0
				target.regen_turns = maxi(target.get("regen_turns", 0), turns)
				result.message = "New Look cleanses %s and grants Regen for %s." % [
					target.name, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Guard":
			var regen_chance := rank_value(skill, level, 0, 40) / 100.0
			var chance_roll := randf() if rng == null else rng.randf()
			var grant_regen: bool = chance_roll < regen_chance
			for target in units:
				if target.side != actor.side or target.get("hp", 0) <= 0:
					continue
				target.protect_turns = maxi(target.get("protect_turns", 0), 3)
				if grant_regen:
					target.regen_turns = maxi(target.get("regen_turns", 0), 2)
				result.affected.append(target.id)
			if not result.affected.is_empty():
				result.message = "Guard grants the team Protect for 3 turns."
				if grant_regen:
					result.message += " The team also gains Regen for 2 turns."
		"Sun Festival":
			var turns := rank_value(skill, level, 0, 2)
			actor.festival_turns = turns
			result.message = "Sun Festival begins: celebration at the end of %s." % [
				_turn_label(turns)
			]
			result.affected.append(actor.id)
	return result

static func resolve_chants(
	side: int,
	units: Array,
	phase: String = "start",
	rng: RandomNumberGenerator = null,
	roll: float = -1.0
) -> Array:
	var results: Array = []
	for unit in units:
		if unit.side != side or unit.get("hp", 0) <= 0:
			continue
		var skill: Dictionary = unit.get("skill", {})
		if skill.get("type", "").to_lower() != "chant":
			continue
		var skill_name: String = skill.get("name", "")
		if (phase == "end") != (skill_name in END_TURN_CHANTS):
			continue
		var level := int(unit.get("level", 1))
		match skill_name:
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
			"Lifestream":
				var turns := rank_value(skill, level, 0, 2)
				var cleanse_count := rank_value(skill, level, 1, 1)
				var affected: Array = []
				for ally in units:
					if ally.side != side or ally.get("hp", 0) <= 0:
						continue
					ally.regen_turns = maxi(ally.get("regen_turns", 0), turns)
					affected.append(ally.id)
				var immobilized: Array = units.filter(
					func(ally): return (
						ally.side == side and ally.get("hp", 0) > 0
						and ally.get("immobilized_turns", 0) > 0
					)
				)
				var cleansed := 0
				for i in mini(cleanse_count, immobilized.size()):
					var pick = _pick_random(immobilized, rng)
					immobilized.erase(pick)
					pick.immobilized_turns = 0
					cleansed += 1
				if not affected.is_empty():
					var result := {
						"message": "Lifestream grants all allies Regen for %s." % _turn_label(turns),
						"affected": affected, "sound": "status"
					}
					if cleansed > 0:
						result.message += " %d all%s had Immobilise removed." % [
							cleansed, "y" if cleansed == 1 else "ies"
						]
					results.append(result)
			"Ocean's Reclaim":
				var cleanse_count := rank_value(skill, level, 0, 1)
				var turns := rank_value(skill, level, 1, 2)
				var candidates: Array = units.filter(
					func(ally): return (
						ally.side == side and ally.id != unit.id and ally.get("hp", 0) > 0
					)
				)
				var cleansed: Array = []
				for i in mini(cleanse_count, candidates.size()):
					var pick = _pick_random(candidates, rng)
					candidates.erase(pick)
					pick.immobilized_turns = 0
					pick.stun_turns = 0
					pick.regen_turns = maxi(pick.get("regen_turns", 0), turns)
					cleansed.append(pick)
				if not cleansed.is_empty():
					results.append({
						"message": "Ocean's Reclaim cleanses %d all%s and grants Regen for %s." % [
							cleansed.size(), "y" if cleansed.size() == 1 else "ies",
							_turn_label(turns)
						],
						"affected": cleansed.map(func(ally): return ally.id),
						"sound": "status"
					})
			"Mighty Guard":
				var doom := rank_value(skill, level, 0, 1)
				var affected: Array = []
				for ally in units:
					if ally.side != side or ally.get("hp", 0) <= 0:
						continue
					ally.protect_turns = maxi(ally.get("protect_turns", 0), 2)
					ally.regen_turns = maxi(ally.get("regen_turns", 0), 2)
					affected.append(ally.id)
				unit.doom_turns = doom
				if not affected.is_empty():
					results.append({
						"message": "Mighty Guard grants the team Protect and Regen for 2 turns; doom falls in %s." % _turn_label(doom),
						"affected": affected, "sound": "status"
					})
			"Blossom's Bloom":
				var amount := rank_value(skill, level, 0, 1)
				var affected: Array = []
				for ally in units:
					if (
						ally.side != side or ally.id == unit.id or ally.get("hp", 0) <= 0
						or ally.get("regen_turns", 0) <= 0
					):
						continue
					ally.atk += amount
					_add_effect(ally, "Blossom's Bloom", 1, amount, 0)
					affected.append(ally.id)
				if not affected.is_empty():
					results.append({
						"message": "Blossom's Bloom gives %d Regen-carrying all%s +%d ATK for 1 turn." % [
							affected.size(), "y" if affected.size() == 1 else "ies", amount
						],
						"affected": affected, "sound": "status"
					})
			"Impairing Joust":
				var turns := rank_value(skill, level, 0, 1)
				var regen_chance := rank_value(skill, level, 1, 30) / 100.0
				var regen_turns := rank_value(skill, level, 2, 3)
				var affected: Array = []
				for enemy in units:
					if (
						enemy.side == side or enemy.get("hp", 0) <= 0
						or enemy.get("taunt_turns", 0) <= 0
					):
						continue
					enemy.immobilized_turns = maxi(
						enemy.get("immobilized_turns", 0), turns
					)
					affected.append(enemy.id)
				var chance_roll := randf() if roll < 0.0 else roll
				if chance_roll < regen_chance:
					unit.regen_turns = maxi(unit.get("regen_turns", 0), regen_turns)
					affected.append(unit.id)
				if not affected.is_empty():
					results.append({
						"message": "Impairing Joust Immobilises %d Taunted enem%s for %s." % [
							affected.size() - (1 if unit.id in affected else 0),
							"y" if affected.size() == 1 else "ies", _turn_label(turns)
						],
						"affected": affected, "sound": "status"
					})
			"Galatine's Ground":
				var turns := rank_value(skill, level, 0, 1)
				var regen_chance := rank_value(skill, level, 1, 30) / 100.0
				var affected: Array = []
				for enemy in units:
					if (
						enemy.side == side or enemy.get("hp", 0) <= 0
						or enemy.get("immobilized_turns", 0) <= 0
					):
						continue
					enemy.stun_turns = maxi(enemy.get("stun_turns", 0), turns)
					affected.append(enemy.id)
				var chance_roll := randf() if roll < 0.0 else roll
				if chance_roll < regen_chance:
					unit.regen_turns = maxi(unit.get("regen_turns", 0), 3)
					affected.append(unit.id)
				if not affected.is_empty():
					results.append({
						"message": "Galatine's Ground Stuns %d Immobilised enem%s for %s." % [
							affected.size() - (1 if unit.id in affected else 0),
							"y" if affected.size() == 1 else "ies", _turn_label(turns)
						],
						"affected": affected, "sound": "status"
					})
	if phase == "end":
		_append_sun_festival(side, units, results)
	return results

## Counts down Sun Festival timers at the end of the owner's turn; when one
## reaches zero, all allies heal and allies carrying Regen gain ATK and Haste.
static func _append_sun_festival(side: int, units: Array, results: Array) -> void:
	for unit in units:
		if unit.side != side or unit.get("hp", 0) <= 0:
			continue
		if unit.get("festival_turns", 0) <= 0:
			continue
		unit.festival_turns -= 1
		if unit.festival_turns > 0:
			continue
		var skill: Dictionary = unit.get("skill", {})
		var level := int(unit.get("level", 1))
		var attack := rank_value(skill, level, 1, 1)
		var healing := rank_value(skill, level, 2, 2)
		var affected: Array = []
		for ally in units:
			if ally.side != side or ally.get("hp", 0) <= 0:
				continue
			BattleSimulatorScript.apply_unit_healing(ally, healing)
			if ally.get("regen_turns", 0) > 0:
				ally.atk += attack
				_add_effect(ally, "Sun Festival", 1, attack, 0)
				ally.haste_turns = maxi(ally.get("haste_turns", 0), 1)
			affected.append(ally.id)
		if not affected.is_empty():
			results.append({
				"message": "Sun Festival restores %d HP to all allies; Regen carriers gain +%d ATK and Haste." % [
					healing, attack
				],
				"affected": affected, "sound": "status"
			})

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
			"affected": [unit.id],
			"label": "POISON"
		})
	for unit in units:
		if unit.side != side or unit.get("regen_turns", 0) <= 0:
			continue
		if unit.get("hp", 0) <= 0:
			continue
		BattleSimulatorScript.apply_unit_healing(unit, 1)
		unit.regen_turns -= 1
		results.append({
			"message": "Regen restores 1 HP to %s." % unit.name,
			"affected": [unit.id],
			"label": "REGEN"
		})
	return results

static func resolve_strike(
	actor: Dictionary, target: Dictionary, _units: Array, roll: float = -1.0
) -> Dictionary:
	var result := {"message": "", "affected": [], "moved": []}
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
	elif skill_name == "Caber Toss":
		if target.hp > 0:
			var spaces := rank_value(skill, level, 0, 2)
			var regen_chance := rank_value(skill, level, 1, 30) / 100.0
			_knockback(actor, target, spaces, _units, result)
			var chance_roll := randf() if roll < 0.0 else roll
			if chance_roll < regen_chance:
				actor.regen_turns = maxi(actor.get("regen_turns", 0), 1)
			result.message = "Caber Toss knocks %s back %d spaces." % [target.name, spaces]
			result.affected.append(target.id)
	elif skill_name == "Cannon Barrage":
		var damage := rank_value(skill, level, 0, 2)
		var regen_chance := rank_value(skill, level, 1, 40) / 100.0
		var victims: Array = _units.filter(
			func(unit): return (
				unit.side != actor.side and unit.row != actor.row and unit.hp > 0
			)
		)
		for victim in victims:
			BattleSimulatorScript.apply_unit_damage(victim, damage)
			result.affected.append(victim.id)
		var chance_roll := randf() if roll < 0.0 else roll
		if chance_roll < regen_chance:
			actor.regen_turns = maxi(actor.get("regen_turns", 0), 2)
		if not victims.is_empty():
			result.message = "Cannon Barrage deals %d damage to %d enem%s outside this lane." % [
				damage, victims.size(), "y" if victims.size() == 1 else "ies"
			]
	elif skill_name == "Pincer Drain":
		if target.get("immobilized_turns", 0) > 0:
			var amount := rank_value(skill, level, 0, 1)
			var regen_chance := rank_value(skill, level, 1, 30) / 100.0
			actor.atk += amount
			var chance_roll := randf() if roll < 0.0 else roll
			if chance_roll < regen_chance:
				actor.regen_turns = maxi(actor.get("regen_turns", 0), 1)
			result.message = "Pincer Drain grants %s +%d ATK." % [actor.name, amount]
			result.affected.append(actor.id)
	elif skill_name == "Slash Speed":
		if target.hp > 0:
			var spaces := rank_value(skill, level, 0, 2)
			var others := rank_value(skill, level, 1, 1)
			var regen_chance := rank_value(skill, level, 2, 40) / 100.0
			_knockback(actor, target, spaces, _units, result)
			result.affected.append(target.id)
			var candidates: Array = _units.filter(
				func(unit): return (
					unit.side != actor.side and unit.id != target.id and unit.hp > 0
				)
			)
			candidates.sort_custom(func(a, b):
				if a.atk == b.atk:
					return a.id < b.id
				return a.atk > b.atk
			)
			for i in mini(others, candidates.size()):
				_knockback(actor, candidates[i], spaces, _units, result)
				result.affected.append(candidates[i].id)
			var chance_roll := randf() if roll < 0.0 else roll
			if chance_roll < regen_chance:
				actor.regen_turns = maxi(actor.get("regen_turns", 0), 1)
			result.message = "Slash Speed knocks back %d enem%s." % [
				result.affected.size(), "y" if result.affected.size() == 1 else "ies"
			]
	elif skill_name == "Trisha's Prospect":
		if target.get("protect_turns", 0) > 0:
			var turns := rank_value(skill, level, 0, 2)
			for enemy in _units:
				if enemy.side != actor.side:
					enemy.protect_turns = 0
			for ally in _units:
				if ally.side != actor.side or ally.get("hp", 0) <= 0:
					continue
				ally.protect_turns = maxi(ally.get("protect_turns", 0), turns)
				ally.regen_turns = maxi(ally.get("regen_turns", 0), 2)
				result.affected.append(ally.id)
			result.message = "Trisha's Prospect steals the enemy's Protect for %s." % _turn_label(turns)
	elif skill_name == "Hurtful Brother":
		var health := rank_value(skill, level, 0, 1)
		var turns := rank_value(skill, level, 1, 2)
		var regen := rank_value(skill, level, 2, 2)
		var sakuya_present: bool = _units.any(
			func(unit): return "Sakuya" in unit.name and unit.hp > 0
		)
		for ally in _units:
			if ally.side != actor.side or ally.get("hp", 0) <= 0:
				continue
			ally.hp += health
			ally.max_hp += health
			_add_effect(ally, "Hurtful Brother", turns, 0, health)
			if sakuya_present:
				ally.regen_turns = maxi(ally.get("regen_turns", 0), regen)
			result.affected.append(ally.id)
		result.message = "Hurtful Brother grants all allies +%d HP for %s." % [
			health, _turn_label(turns)
		]
		if sakuya_present:
			result.message += " Sakuya grants Regen for %s." % _turn_label(regen)
	elif skill_name == "Heartful Brother":
		var amount := rank_value(skill, level, 0, 1)
		var turns := rank_value(skill, level, 1, 2)
		var vulnerable_turns := rank_value(skill, level, 2, 2)
		var yuuya_present: bool = _units.any(
			func(unit): return "Yuuya" in unit.name and unit.hp > 0
		)
		for enemy in _units:
			if enemy.side == actor.side or enemy.get("hp", 0) <= 0:
				continue
			enemy.atk = maxi(0, enemy.atk - amount)
			_add_effect(enemy, "Heartful Brother", turns, -amount, 0)
			if yuuya_present:
				if enemy.get("vulnerable_turns", 0) > 0:
					enemy.vulnerable_stacks = enemy.get("vulnerable_stacks", 1) + 1
				else:
					enemy.vulnerable_stacks = 1
				enemy.vulnerable_turns = maxi(
					enemy.get("vulnerable_turns", 0), vulnerable_turns
				)
			result.affected.append(enemy.id)
		if not result.affected.is_empty():
			result.message = "Heartful Brother gives all enemies -%d ATK for %s." % [
				amount, _turn_label(turns)
			]
			if yuuya_present:
				result.message += " Yuuya makes them Vulnerable for %s." % _turn_label(vulnerable_turns)
	return result

static func resolve_reaction(
	target: Dictionary, attacker: Dictionary, _units: Array, roll: float = -1.0
) -> Dictionary:
	var result := {"message": "", "affected": [], "moved": []}
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
		"Grit":
			var regen_chance := rank_value(skill, level, 0, 40) / 100.0
			var turns := rank_value(skill, level, 1, 2)
			var chance_roll := randf() if roll < 0.0 else roll
			if chance_roll < regen_chance:
				target.regen_turns = maxi(target.get("regen_turns", 0), turns)
				result.message = "Grit grants %s Regen for %s." % [
					target.name, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Ambient Pressure":
			var pressure_chance := rank_value(skill, level, 0, 60) / 100.0
			var amount := rank_value(skill, level, 1, 1)
			var chance_roll := randf() if roll < 0.0 else roll
			if chance_roll < pressure_chance:
				target.atk += amount
				target.regen_turns = maxi(target.get("regen_turns", 0), 1)
				result.message = "Ambient Pressure grants %s +%d ATK and Regen for 1 turn." % [
					target.name, amount
				]
				result.affected.append(target.id)
		"Tide Turn":
			var turns := rank_value(skill, level, 0, 1)
			var regen_chance := rank_value(skill, level, 1, 20) / 100.0
			attacker.taunt_turns = maxi(attacker.get("taunt_turns", 0), turns)
			result.message = "Tide Turn Taunts %s for %s." % [
				attacker.name, _turn_label(turns)
			]
			result.affected.append(attacker.id)
			var chance_roll := randf() if roll < 0.0 else roll
			if chance_roll < regen_chance:
				target.regen_turns = maxi(target.get("regen_turns", 0), 1)
				result.affected.append(target.id)
		"Yield!":
			var spaces := rank_value(skill, level, 0, 2)
			var regen_chance := rank_value(skill, level, 1, 30) / 100.0
			_knockback(target, attacker, spaces, _units, result)
			attacker.immobilized_turns = maxi(attacker.get("immobilized_turns", 0), 2)
			result.message = "Yield! knocks back %s and Immobilises it for 2 turns." % attacker.name
			result.affected.append(attacker.id)
			var chance_roll := randf() if roll < 0.0 else roll
			if chance_roll < regen_chance:
				target.regen_turns = maxi(target.get("regen_turns", 0), 1)
				result.affected.append(target.id)
		"Tag-Team":
			var others: Array = _units.filter(
				func(unit): return (
					unit.side == target.side and unit.id != target.id and unit.hp > 0
				)
			)
			if not others.is_empty():
				others.sort_custom(func(a, b):
					if a.atk == b.atk:
						return a.id < b.id
					return a.atk > b.atk
				)
				others[0].atk += 1
				result.message = "Tag-Team grants %s +1 ATK." % others[0].name
				result.affected.append(others[0].id)
			var regen_chance := rank_value(skill, level, 0, 20) / 100.0
			var chance_roll := randf() if roll < 0.0 else roll
			if chance_roll < regen_chance:
				target.regen_turns = maxi(target.get("regen_turns", 0), 1)
				if target.id not in result.affected:
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
		if unit.side == side and unit.get("stun_turns", 0) > 0:
			unit.stun_turns -= 1
		if unit.side == side and unit.get("haste_turns", 0) > 0:
			unit.haste_turns -= 1
		# Doom timers (Mighty Guard) count the opposing side's turns; when one
		# runs out the carrier is defeated.
		if unit.side != side and unit.get("doom_turns", 0) > 0:
			unit.doom_turns -= 1
			if unit.doom_turns <= 0:
				unit.hp = 0

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

static func _ally_by_id_classes(
	actor: Dictionary, units: Array, target_id: int, kinds: Array
):
	if target_id < 0:
		return null
	for unit in units:
		if (
			unit.id == target_id and unit.side == actor.side and unit.id != actor.id
			and unit.kind in kinds
		):
			return unit
	return null

static func _lowest_health_ally_classes(actor: Dictionary, units: Array, kinds: Array):
	var candidates := _other_allies(actor, units).filter(
		func(unit): return unit.kind in kinds and unit.get("hp", 0) > 0
	)
	candidates.sort_custom(func(a, b):
		if a.hp == b.hp:
			return a.id < b.id
		return a.hp < b.hp
	)
	return null if candidates.is_empty() else candidates[0]

static func _pick_random(candidates: Array, rng: RandomNumberGenerator):
	if candidates.is_empty():
		return null
	if rng == null:
		return candidates.pick_random()
	return candidates[rng.randi_range(0, candidates.size() - 1)]

## Slides `target` up to `spaces` cells along its lane away from `source`,
## stopping at the board edge or the first occupied cell. The final position
## is recorded in `result.moved` so the presentation layer can animate it.
static func _knockback(
	source: Dictionary, target: Dictionary, spaces: int, units: Array, result: Dictionary
) -> void:
	var direction: int = signi(target.col - source.col)
	if direction == 0:
		direction = 1 if source.side == 0 else -1
	var from_col: int = target.col
	for step in spaces:
		var next_col: int = target.col + direction
		if next_col < 0 or next_col >= BattleRulesScript.COLS:
			break
		var blocked: bool = units.any(
			func(unit): return (
				unit.id != target.id and unit.get("hp", 0) > 0
				and unit.row == target.row and unit.col == next_col
			)
		)
		if blocked:
			break
		target.col = next_col
	result.moved.append({"id": target.id, "row": target.row, "from_col": from_col})

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
