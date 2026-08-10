class_name UnitSkills
extends RefCounted

const BattleSimulatorScript = preload("res://scripts/battle_simulator.gd")
const BattleRulesScript = preload("res://scripts/battle_rules.gd")

## Chants that resolve at the end of their side's turn instead of the start.
const END_TURN_CHANTS := ["Lockdown Sweep", "Grounding Wave", "Dragnet"]

## Sentinel poison duration applied by Deployment Snare: resolve_start_statuses
## never ticks a counter this large down, so the Poison is permanent.
const PERMANENT_POISON_TURNS := 999

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
	# A Silenced unit's secondary skill does not trigger.
	if is_silenced(actor):
		return result
	var level := int(actor.get("level", 1))
	match skill.get("name", ""):
		"Failover Mantle":
			var amount := rank_value(skill, level, 0, 1)
			var turns := rank_value(skill, level, 1, 1)
			var damaged: Array = units.filter(
				func(ally): return (
					ally.side == actor.side and ally.get("hp", 0) > 0
					and ally.get("hp", 0) < ally.get("max_hp", ally.get("hp", 0))
				)
			)
			damaged.sort_custom(func(a, b):
				var a_missing: int = a.get("max_hp", a.hp) - a.hp
				var b_missing: int = b.get("max_hp", b.hp) - b.hp
				if a_missing == b_missing:
					return a.id < b.id
				return a_missing > b_missing
			)
			if not damaged.is_empty():
				damaged[0].protect_turns = maxi(
					damaged[0].get("protect_turns", 0), turns
				)
				for ally in damaged:
					BattleSimulatorScript.apply_unit_healing(ally, amount)
					result.affected.append(ally.id)
				result.message = "Failover Mantle restores %d HP to %d damaged all%s; %s gains Protect for %s." % [
					amount, damaged.size(), "y" if damaged.size() == 1 else "ies",
					damaged[0].name, _turn_label(turns)
				]
		"Brace Protocol":
			var target = _lowest_health_ally(actor, units)
			if target != null:
				var amount := rank_value(skill, level, 0, 3)
				var turns := rank_value(skill, level, 1, 2)
				target.hp += amount
				target.max_hp += amount
				_add_effect(target, "Brace Protocol", turns, 0, amount)
				result.message = "Brace Protocol gives %s +%d HP for %s." % [
					target.name, amount, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Overclock Link":
			var target = _ally_by_id(actor, units, target_id)
			if target == null:
				target = _highest_attack_ally(actor, units)
			if target != null:
				var amount := rank_value(skill, level, 0, 1)
				var turns := rank_value(skill, level, 1, 2)
				target.atk += amount
				_add_effect(target, "Overclock Link", turns, amount, 0)
				result.message = "Overclock Link gives %s +%d ATK for %s." % [
					target.name, amount, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Arc Lance":
			var target = _highest_health_enemy(actor, units)
			if target != null:
				var damage := rank_value(skill, level, 0, 1)
				BattleSimulatorScript.apply_unit_damage(target, damage)
				result.message = "Arc Lance deals %d damage to %s." % [damage, target.name]
				result.affected.append(target.id)
		"Relay Storm":
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
				result.message = "Relay Storm deals 1 damage to %s." % last_target.name
			elif hits > 1:
				result.message = (
					"Relay Storm deals %d damage split between random enemy units." % hits
				)
		"Signal Jam":
			var target = _highest_attack_enemy_classes(
				actor, units, ["Strider", "Artillerist"]
			)
			if target != null:
				var amount := rank_value(skill, level, 0, 1)
				var turns := rank_value(skill, level, 1, 2)
				target.atk = maxi(0, target.atk - amount)
				_add_effect(target, "Signal Jam", turns, -amount, 0)
				result.message = "Signal Jam gives %s -%d ATK for %s." % [
					target.name, amount, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Repair Pulse":
			var target = _lowest_health_ally(actor, units)
			if target != null:
				var amount := rank_value(skill, level, 0, 3)
				BattleSimulatorScript.apply_unit_healing(target, amount, true)
				result.message = "Repair Pulse restores %d HP to %s." % [amount, target.name]
				result.affected.append(target.id)
		"Corrosion Bloom":
			var damage := rank_value(skill, level, 0, 1)
			var turns := rank_value(skill, level, 1, 2)
			var victims: Array = units.filter(func(unit): return unit.id != actor.id)
			for target in victims:
				BattleSimulatorScript.apply_unit_damage(target, damage)
				target.poison_turns = maxi(target.get("poison_turns", 0), turns)
				target.poison_damage = maxi(target.get("poison_damage", 0), 1)
				result.affected.append(target.id)
			if not victims.is_empty():
				result.message = "Corrosion Bloom deals %d damage and Poisons %d other unit%s for %s." % [
					damage, victims.size(), "" if victims.size() == 1 else "s",
					_turn_label(turns)
				]
		"Toxin Injector":
			var target = _enemy_by_id(actor, units, target_id)
			if target == null:
				target = _highest_health_enemy(actor, units)
			if target != null:
				var turns := rank_value(skill, level, 0, 2)
				target.poison_turns = maxi(target.get("poison_turns", 0), turns)
				target.poison_damage = maxi(target.get("poison_damage", 0), 1)
				result.message = "Toxin Injector Poisons %s for %s." % [
					target.name, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Null Signal":
			var target = _enemy_by_id(actor, units, target_id)
			if target == null:
				target = _skilled_enemy(actor, units)
			if target != null:
				var turns := rank_value(skill, level, 0, 1)
				target.silenced_turns = maxi(target.get("silenced_turns", 0), turns)
				result.message = "Null Signal Silences %s for %s." % [
					target.name, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Anchor Shot":
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
				result.message = "Anchor Shot deals %d damage to %s and Immobilises it for %s." % [
					damage, target.name, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Breach Charge":
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
				result.message = "Breach Charge deals %d damage to %s and makes it Vulnerable for %s%s." % [
					damage, target.name, _turn_label(turns), stack_note
				]
				result.affected.append(target.id)
		"Suppression Field":
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
				_add_effect(target, "Suppression Field", turns, -amount, 0)
				result.affected.append(target.id)
				target_count += 1
			if target_count > 0:
				result.message = "Suppression Field gives %d enem%s in lane %d -%d ATK for %s." % [
					target_count, "y" if target_count == 1 else "ies", lane + 1,
					amount, _turn_label(turns)
				]
		"Countermeasure":
			var target = _highest_attack_enemy_classes(
				actor, units, ["Duelist", "Channeler"]
			)
			if target != null:
				var amount := rank_value(skill, level, 0, 1)
				var turns := rank_value(skill, level, 1, 2)
				target.atk = maxi(0, target.atk - amount)
				_add_effect(target, "Countermeasure", turns, -amount, 0)
				result.message = "Countermeasure gives %s -%d ATK for %s." % [
					target.name, amount, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Heavy Target":
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
				result.message = "Heavy Target deals %d damage to %s and makes it Vulnerable for %s%s." % [
					damage, target.name, _turn_label(turns), stack_note
				]
				result.affected.append(target.id)
		"Chain Corrosion":
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
				result.message = "Chain Corrosion deals %d damage to %d enemy Mage%s and Priest%s and Poisons them for %s." % [
					damage, victims.size(), "" if victims.size() == 1 else "s",
					"" if victims.size() == 1 else "s", _turn_label(turns)
				]
		"Meteor Pattern":
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
				result.message = "Meteor Pattern deals %d damage to %d enem%s in lane %d." % [
					damage, target_count, "y" if target_count == 1 else "ies", lane + 1
				]
		"Cryo Lock":
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
				result.message = "Cryo Lock deals %d damage to %d enem%s in lane %d and Immobilises them for %s." % [
					damage, target_count, "y" if target_count == 1 else "ies",
					lane + 1, _turn_label(turns)
				]
		"Guard Link":
			var target = _ally_by_id(actor, units, target_id)
			if target == null:
				target = _lowest_health_ally(actor, units)
			if target != null:
				var turns := rank_value(skill, level, 0, 2)
				target.protect_turns = maxi(target.get("protect_turns", 0), turns)
				result.message = "Guard Link grants %s Protect for %s." % [
					target.name, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Lane Bulwark":
			var lane := target_lane
			if lane < 0:
				lane = _best_ally_lane(actor, units)
			var turns := rank_value(skill, level, 0, 2)
			var target_count := 0
			for target in units:
				if (
					target.side != actor.side or target.row != lane
					or target.get("hp", 0) <= 0
				):
					continue
				target.protect_turns = maxi(target.get("protect_turns", 0), turns)
				result.affected.append(target.id)
				target_count += 1
			if target_count > 0:
				result.message = "Lane Bulwark grants %d all%s in lane %d Protect for %s." % [
					target_count, "y" if target_count == 1 else "ies", lane + 1,
					_turn_label(turns)
				]
		"Thermal Wrap":
			var target = _ally_by_id(actor, units, target_id)
			if target == null:
				target = _lowest_health_ally(actor, units)
			if target != null:
				var amount := rank_value(skill, level, 0, 1)
				var turns := rank_value(skill, level, 1, 2)
				BattleSimulatorScript.apply_unit_healing(target, amount, true)
				target.protect_turns = maxi(target.get("protect_turns", 0), turns)
				result.message = "Thermal Wrap gives %s +%d HP and Protect for %s." % [
					target.name, amount, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Umbral Clamp":
			var lane := target_lane
			if lane < 0:
				lane = _best_enemy_lane(actor, units, [])
			var amount := rank_value(skill, level, 0, 1)
			var turns := rank_value(skill, level, 1, 2)
			var target_count := 0
			for target in units:
				if (
					target.side == actor.side or target.row != lane
					or target.get("hp", 0) <= 0
				):
					continue
				target.atk = maxi(0, target.atk - amount)
				_add_effect(target, "Umbral Clamp", turns, -amount, 0)
				target.immobilized_turns = maxi(
					target.get("immobilized_turns", 0), turns
				)
				result.affected.append(target.id)
				target_count += 1
			if target_count > 0:
				result.message = "Umbral Clamp gives %d enem%s in lane %d -%d ATK and Immobilises them for %s." % [
					target_count, "y" if target_count == 1 else "ies", lane + 1,
					amount, _turn_label(turns)
				]
		"Thermal Burst":
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
				result.message = "Thermal Burst deals %d damage to %s." % [damage, target.name]
				if not adjacent.is_empty():
					result.message += " Adjacent %s take%s %d damage." % [
						", ".join(adjacent), "s" if adjacent.size() == 1 else "", splash
					]
		"Combat Surge":
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
				_add_effect(target, "Combat Surge", turns, attack, health)
				result.message = "Combat Surge gives %s +%d HP and +%d ATK for %s." % [
					target.name, health, attack, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Purge Routine":
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
				result.message = "Purge Routine cleanses %s and grants Regen for %s." % [
					target.name, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Field Recovery":
			var target = _ally_by_id_classes(
				actor, units, target_id, ["Duelist", "Warden"]
			)
			if target == null:
				target = _lowest_health_ally_classes(actor, units, ["Duelist", "Warden"])
			if target != null:
				var turns := rank_value(skill, level, 0, 2)
				target.immobilized_turns = 0
				target.regen_turns = maxi(target.get("regen_turns", 0), turns)
				result.message = "Field Recovery cleanses %s and grants Regen for %s." % [
					target.name, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Refit Cycle":
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
				result.message = "Refit Cycle cleanses %s and grants Regen for %s." % [
					target.name, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Cover Matrix":
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
				result.message = "Cover Matrix grants the team Protect for 3 turns."
				if grant_regen:
					result.message += " The team also gains Regen for 2 turns."
		"Solar Crescendo":
			var turns := rank_value(skill, level, 0, 2)
			actor.festival_turns = turns
			result.message = "Solar Crescendo begins: celebration at the end of %s." % [
				_turn_label(turns)
			]
			result.affected.append(actor.id)
		"Retaliation Screen":
			var turns := rank_value(skill, level, 0, 1)
			actor.summon_forth_turns = maxi(actor.get("summon_forth_turns", 0), turns)
			result.message = "Retaliation Screen shields %s for %s." % [
				actor.name, _turn_label(turns)
			]
			result.affected.append(actor.id)
	return result

## Resolves the chant skills of every living unit on `side`. `phase` is
## "start" or "end" of that side's turn. `last_placed_id` is the id of the
## most recent unit `side` deployed (or -1 when it has placed nothing yet);
## Deployment Snare carriers on the OPPOSING side use it at turn start.
static func resolve_chants(
	side: int,
	units: Array,
	phase: String = "start",
	rng: RandomNumberGenerator = null,
	roll: float = -1.0,
	last_placed_id: int = -1
) -> Array:
	var results: Array = []
	if phase == "start":
		_append_roguish_snare(side, units, last_placed_id, rng, roll, results)
		_append_quiet(side, units, rng, results)
	for unit in units:
		if unit.side != side or unit.get("hp", 0) <= 0:
			continue
		if is_silenced(unit):
			continue
		var skill: Dictionary = unit.get("skill", {})
		if skill.get("type", "").to_lower() != "chant":
			continue
		var skill_name: String = skill.get("name", "")
		if (phase == "end") != (skill_name in END_TURN_CHANTS):
			continue
		var level := int(unit.get("level", 1))
		match skill_name:
			"Phase Cascade":
				var candidates: Array = units.filter(
					func(enemy): return enemy.side != side and enemy.get("hp", 0) > 0
				)
				candidates.sort_custom(func(a, b):
					if a.atk == b.atk:
						return a.id < b.id
					return a.atk > b.atk
				)
				if not candidates.is_empty():
					var target = candidates[0]
					var damage := rank_value(skill, level, 0, 1)
					var turns := rank_value(skill, level, 1, 1)
					var disrupted: bool = (
						target.get("immobilized_turns", 0) > 0
						or target.get("silenced_turns", 0) > 0
					)
					BattleSimulatorScript.apply_unit_damage(target, damage)
					if disrupted and target.get("hp", 0) > 0:
						target.stun_turns = maxi(target.get("stun_turns", 0), turns)
					results.append({
						"message": "Phase Cascade deals %d damage to %s%s." % [
							damage, target.name,
							" and Stuns it for %s" % _turn_label(turns) if disrupted and target.get("hp", 0) > 0 else ""
						],
						"affected": [target.id], "sound": "mage"
					})
			"Breaker Impact":
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
					result.message = "Breaker Impact deals %d damage to %d enem%s in lane %d and makes them Vulnerable for %s." % [
						damage, result.affected.size(),
						"y" if result.affected.size() == 1 else "ies",
						unit.row + 1, _turn_label(turns)
					]
					results.append(result)
			"Pressure Jet":
				# The ATK debuff carries one turn, so it lasts until the end of
				# the enemy's next turn; the authored copy gives no duration.
				var amount := rank_value(skill, level, 0, 1)
				var spaces := rank_value(skill, level, 1, 1)
				var result := {
					"message": "", "affected": [], "moved": [], "sound": "status"
				}
				for target in units:
					if (
						target.side == side or target.row != unit.row
						or target.get("hp", 0) <= 0
					):
						continue
					target.atk = maxi(0, target.get("atk", 0) - amount)
					_add_effect(target, "Pressure Jet", 1, -amount, 0)
					_knockback(unit, target, spaces, units, result)
					result.affected.append(target.id)
				if not result.affected.is_empty():
					result.message = "Pressure Jet gives %d enem%s in lane %d -%d ATK and Knocks them Back %d space%s." % [
						result.affected.size(),
						"y" if result.affected.size() == 1 else "ies",
						unit.row + 1, amount, spaces, "" if spaces == 1 else "s"
					]
					results.append(result)
			"Frontline Relay":
				# "Behind"/"in front of" are column-relative and cross-lane:
				# side 0 advances toward higher columns and side 1 toward
				# lower ones, so an ally is behind the chanter when its
				# column is further from the enemy edge and an enemy is in
				# front when its column is closer to it. Units in the
				# chanter's own column are neither.
				var protect_turns := rank_value(skill, level, 0, 1)
				var amount := rank_value(skill, level, 1, 1)
				var debuff_turns := rank_value(skill, level, 2, 1)
				var forward := 1 if side == 0 else -1
				var result := {"message": "", "affected": [], "sound": "status"}
				var protected_count := 0
				var debuffed_count := 0
				for target in units:
					if target.id == unit.id or target.get("hp", 0) <= 0:
						continue
					var offset: int = (target.col - unit.col) * forward
					if target.side == side and offset < 0:
						target.protect_turns = maxi(
							target.get("protect_turns", 0), protect_turns
						)
						result.affected.append(target.id)
						protected_count += 1
					elif target.side != side and offset > 0:
						target.atk = maxi(0, target.get("atk", 0) - amount)
						_add_effect(target, "Frontline Relay", debuff_turns, -amount, 0)
						result.affected.append(target.id)
						debuffed_count += 1
				if not result.affected.is_empty():
					var clauses: Array = []
					if protected_count > 0:
						clauses.append("grants %d all%s behind it Protect for %s" % [
							protected_count,
							"y" if protected_count == 1 else "ies",
							_turn_label(protect_turns)
						])
					if debuffed_count > 0:
						clauses.append("gives %d enem%s in front of it -%d ATK for %s" % [
							debuffed_count,
							"y" if debuffed_count == 1 else "ies",
							amount, _turn_label(debuff_turns)
						])
					result.message = "Frontline Relay %s." % " and ".join(clauses)
					results.append(result)
			"Petrify Loop":
				# Part 1 Poisons one random living non-Poisoned enemy for {0}
				# enemy turns; part 2 Stuns up to {1} Poisoned enemies standing
				# in front of the chanter (the Frontline Relay column rule: closer to
				# the enemy edge than the chanter, across all lanes) for 1 enemy
				# turn. An enemy Poisoned by part 1 counts toward part 2 when it
				# stands in front. Either part no-ops without a valid target.
				var poison_turns := rank_value(skill, level, 0, 1)
				var stun_count := rank_value(skill, level, 1, 1)
				var forward := 1 if side == 0 else -1
				var result := {"message": "", "affected": [], "sound": "status"}
				var poison_candidates: Array = units.filter(
					func(target): return (
						target.side != side and target.get("hp", 0) > 0
						and target.get("poison_turns", 0) <= 0
					)
				)
				var poisoned = _pick_random(poison_candidates, rng)
				if poisoned != null:
					poisoned.poison_turns = maxi(
						poisoned.get("poison_turns", 0), poison_turns
					)
					poisoned.poison_damage = maxi(poisoned.get("poison_damage", 0), 1)
					result.affected.append(poisoned.id)
				var stunned_count := 0
				for target in units:
					if stunned_count >= stun_count:
						break
					if (
						target.side == side or target.get("hp", 0) <= 0
						or target.get("poison_turns", 0) <= 0
					):
						continue
					var offset: int = (target.col - unit.col) * forward
					if offset <= 0:
						continue
					target.stun_turns = maxi(target.get("stun_turns", 0), 1)
					if target.id not in result.affected:
						result.affected.append(target.id)
					stunned_count += 1
				if not result.affected.is_empty():
					var clauses: Array = []
					if poisoned != null:
						clauses.append("Poisons %s for %s" % [
							poisoned.name, _turn_label(poison_turns)
						])
					if stunned_count > 0:
						clauses.append("Stuns %d Poisoned enem%s in front of it for 1 enemy turn" % [
							stunned_count, "y" if stunned_count == 1 else "ies"
						])
					result.message = "Petrify Loop %s." % " and ".join(clauses)
					results.append(result)
			"Renewal Current":
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
						"message": "Renewal Current grants all allies Regen for %s." % _turn_label(turns),
						"affected": affected, "sound": "status"
					}
					if cleansed > 0:
						result.message += " %d all%s had Immobilise removed." % [
							cleansed, "y" if cleansed == 1 else "ies"
						]
					results.append(result)
			"Tidal Reset":
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
						"message": "Tidal Reset cleanses %d all%s and grants Regen for %s." % [
							cleansed.size(), "y" if cleansed.size() == 1 else "ies",
							_turn_label(turns)
						],
						"affected": cleansed.map(func(ally): return ally.id),
						"sound": "status"
					})
			"Lasting Aegis":
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
						"message": "Lasting Aegis grants the team Protect and Regen for 2 turns; doom falls in %s." % _turn_label(doom),
						"affected": affected, "sound": "status"
					})
			"Growth Pulse":
				var amount := rank_value(skill, level, 0, 1)
				var affected: Array = []
				for ally in units:
					if (
						ally.side != side or ally.id == unit.id or ally.get("hp", 0) <= 0
						or ally.get("regen_turns", 0) <= 0
					):
						continue
					ally.atk += amount
					_add_effect(ally, "Growth Pulse", 1, amount, 0)
					affected.append(ally.id)
				if not affected.is_empty():
					results.append({
						"message": "Growth Pulse gives %d Regen-carrying all%s +%d ATK for 1 turn." % [
							affected.size(), "y" if affected.size() == 1 else "ies", amount
						],
						"affected": affected, "sound": "status"
					})
			"Lockdown Sweep":
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
						"message": "Lockdown Sweep Immobilises %d Taunted enem%s for %s." % [
							affected.size() - (1 if unit.id in affected else 0),
							"y" if affected.size() == 1 else "ies", _turn_label(turns)
						],
						"affected": affected, "sound": "status"
					})
			"Grounding Wave":
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
						"message": "Grounding Wave Stuns %d Immobilised enem%s for %s." % [
							affected.size() - (1 if unit.id in affected else 0),
							"y" if affected.size() == 1 else "ies", _turn_label(turns)
						],
						"affected": affected, "sound": "status"
					})
			"Dragnet":
				# Runs at the end of the CHANTER's side turn (the "player turn"
				# of the authored rule, matching Lockdown Sweep). The ATK
				# debuff and the Immobilise each carry one turn, so both last
				# until the end of the enemy's next turn, mirroring Pressure Jet.
				var spaces := rank_value(skill, level, 0, 1)
				var amount := rank_value(skill, level, 1, 1)
				var result := {
					"message": "", "affected": [], "moved": [], "sound": "status"
				}
				for enemy in units:
					if (
						enemy.side == side or enemy.get("hp", 0) <= 0
						or enemy.get("taunt_turns", 0) <= 0
					):
						continue
					_knockback(unit, enemy, spaces, units, result)
					enemy.immobilized_turns = maxi(
						enemy.get("immobilized_turns", 0), 1
					)
					enemy.atk = maxi(0, enemy.get("atk", 0) - amount)
					_add_effect(enemy, "Dragnet", 1, -amount, 0)
					result.affected.append(enemy.id)
				if not result.affected.is_empty():
					result.message = "Dragnet Knocks Back %d Taunted enem%s %d space%s; they are Immobilised and lose %d ATK for 1 enemy turn." % [
						result.affected.size(),
						"y" if result.affected.size() == 1 else "ies",
						spaces, "" if spaces == 1 else "s", amount
					]
					results.append(result)
	if phase == "end":
		_append_sun_festival(side, units, results)
	return results

## Deployment Snare is a deployment trap: when the turn of the side OPPOSITE the
## carrier starts, that side's most recently deployed unit (`last_placed_id`)
## is Stunned for 2 turns and, at a rank-scaled chance, permanently Poisoned.
## Only the first living carrier in deployment order triggers, so multiple
## carriers never stack. Nothing happens while the opponent has placed no
## unit yet or every carrier is dead.
static func _append_roguish_snare(
	side: int,
	units: Array,
	last_placed_id: int,
	rng: RandomNumberGenerator,
	roll: float,
	results: Array
) -> void:
	if last_placed_id < 0:
		return
	var victim = BattleSimulatorScript.unit_by_id(units, last_placed_id)
	if victim == null or victim.side != side or victim.get("hp", 0) <= 0:
		return
	for carrier in units:
		if carrier.side == side or carrier.get("hp", 0) <= 0:
			continue
		if is_silenced(carrier):
			continue
		var skill: Dictionary = carrier.get("skill", {})
		if skill.get("name", "") != "Deployment Snare":
			continue
		if skill.get("type", "").to_lower() != "chant":
			continue
		var level := int(carrier.get("level", 1))
		victim.stun_turns = maxi(victim.get("stun_turns", 0), 2)
		var message := "Deployment Snare Stuns %s for 2 turns." % victim.name
		var poison_chance := rank_value(skill, level, 0, 20) / 100.0
		var chance_roll: float = roll if roll >= 0.0 else (
			rng.randf() if rng != null else randf()
		)
		if chance_roll < poison_chance:
			victim.poison_turns = maxi(
				victim.get("poison_turns", 0), PERMANENT_POISON_TURNS
			)
			victim.poison_damage = maxi(victim.get("poison_damage", 0), 1)
			message += " It is permanently Poisoned."
		results.append({
			"message": message,
			"affected": [victim.id],
			"sound": "status"
		})
		return

## Silent Cycle is a countdown chant: when the turn of the side OPPOSITE the
## carrier starts, the {1} living enemies with the highest ATK are Silenced
## for {2} enemy turns. Each carrier fires exactly {0} times after
## deployment (`quiet_triggers_left`, set in main.gd:_spawn_unit). The
## trigger is a chant, so a Silenced carrier skips it WITHOUT spending a
## charge; the 0-damage passive lives in BattleSimulator.apply_unit_damage
## and is not a trigger, so it works even while the carrier is Silenced.
static func _append_quiet(
	side: int, units: Array, rng: RandomNumberGenerator, results: Array
) -> void:
	for carrier in units:
		if carrier.side == side or carrier.get("hp", 0) <= 0:
			continue
		if is_silenced(carrier):
			continue
		var skill: Dictionary = carrier.get("skill", {})
		if skill.get("name", "") != "Silent Cycle":
			continue
		if skill.get("type", "").to_lower() != "chant":
			continue
		if int(carrier.get("quiet_triggers_left", 0)) <= 0:
			continue
		carrier.quiet_triggers_left -= 1
		var level := int(carrier.get("level", 1))
		var count := rank_value(skill, level, 1, 1)
		var turns := rank_value(skill, level, 2, 1)
		var targets := _highest_attack_enemies(carrier, units, count, rng)
		for target in targets:
			target.silenced_turns = maxi(target.get("silenced_turns", 0), turns)
		if targets.is_empty():
			continue
		results.append({
			"message": "Silent Cycle Silences %s for %s." % [
				", ".join(targets.map(func(target): return target.name)),
				_turn_label(turns)
			],
			"affected": targets.map(func(target): return target.id),
			"sound": "status"
		})

## Retaliation Screen retaliation: when an attack against the carrier is reduced to
## 0 by its Retaliation Screen immunity (see BattleSimulator.apply_unit_damage),
## {2} random living enemies with the highest ATK take {1}% of the attacking
## unit's ATK (minimum 1, rounded down). main.gd fires this once per blocked
## attack hit; a dead carrier never retaliates.
static func resolve_summon_forth(
	defender: Dictionary,
	attacker: Dictionary,
	units: Array,
	rng: RandomNumberGenerator = null
) -> Dictionary:
	var result := {"message": "", "affected": []}
	if defender.get("hp", 0) <= 0 or int(defender.get("summon_forth_turns", 0)) <= 0:
		return result
	var skill: Dictionary = defender.get("skill", {})
	if skill.get("name", "") != "Retaliation Screen":
		return result
	var level := int(defender.get("level", 1))
	var percent := rank_value(skill, level, 1, 50)
	var count := rank_value(skill, level, 2, 1)
	var damage := maxi(1, floori(float(attacker.get("atk", 0) * percent) / 100.0))
	var targets := _highest_attack_enemies(defender, units, count, rng)
	for target in targets:
		BattleSimulatorScript.apply_unit_damage(target, damage)
		result.affected.append(target.id)
	if not targets.is_empty():
		result.message = "Retaliation Screen deals %d damage back to %s." % [
			damage, ", ".join(targets.map(func(target): return target.name))
		]
	return result

## Counts down Solar Crescendo timers at the end of the owner's turn; when one
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
				_add_effect(ally, "Solar Crescendo", 1, attack, 0)
				ally.haste_turns = maxi(ally.get("haste_turns", 0), 1)
			affected.append(ally.id)
		if not affected.is_empty():
			results.append({
				"message": "Solar Crescendo restores %d HP to all allies; Regen carriers gain +%d ATK and Haste." % [
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
		# Permanent Poison (Deployment Snare) deals damage but never counts down.
		if unit.poison_turns < PERMANENT_POISON_TURNS:
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
	if is_silenced(actor):
		return result
	var skill_name: String = skill.get("name", "")
	var level := int(actor.get("level", 1))
	if skill_name == "Locking Strike" or skill_name == "Sever Drive":
		var fallback := 30 if skill_name == "Locking Strike" else 60
		var pin_chance := rank_value(skill, level, 0, fallback) / 100.0
		var turns := rank_value(skill, level, 1, 1)
		var chance_roll := randf() if roll < 0.0 else roll
		if chance_roll < pin_chance and target.hp > 0:
			target.immobilized_turns = maxi(target.get("immobilized_turns", 0), turns)
			result.message = "%s immobilises %s for %s." % [
				skill_name, target.name, _turn_label(turns)
			]
			result.affected.append(target.id)
	elif skill_name == "Corrosive Edge":
		var poison_chance: float = skill.get("chance", -1.0)
		if poison_chance < 0.0:
			poison_chance = rank_value(skill, level, 0, 50) / 100.0
		var turns := rank_value(skill, level, 1, 2)
		var chance_roll := randf() if roll < 0.0 else roll
		if chance_roll < poison_chance and target.hp > 0:
			target.poison_turns = maxi(target.get("poison_turns", 0), turns)
			target.poison_damage = maxi(target.get("poison_damage", 0), 1)
			result.message = "Corrosive Edge Poisons %s for %s." % [
				target.name, _turn_label(turns)
			]
			result.affected.append(target.id)
	elif skill_name == "Furnace Wake":
		var amount := rank_value(skill, level, 0, 1)
		var turns := rank_value(skill, level, 1, 1)
		actor.atk += amount
		actor.haste_turns = maxi(actor.get("haste_turns", 0), turns)
		_add_effect(actor, "Furnace Wake", turns, amount, 0)
		result.message = "Furnace Wake grants %s +%d ATK and Haste for %s." % [
			actor.name, amount, _turn_label(turns)
		]
		result.affected.append(actor.id)
	elif skill_name == "Drain Strike":
		var weaken_chance := rank_value(skill, level, 0, 60) / 100.0
		var amount := rank_value(skill, level, 1, 1)
		var turns := rank_value(skill, level, 2, 2)
		var chance_roll := randf() if roll < 0.0 else roll
		if chance_roll < weaken_chance and target.hp > 0:
			target.atk = maxi(0, target.get("atk", 0) - amount)
			_add_effect(target, "Drain Strike", turns, -amount, 0)
			result.message = "Drain Strike gives %s -%d ATK for %s." % [
				target.name, amount, _turn_label(turns)
			]
			result.affected.append(target.id)
	elif skill_name == "Kinetic Throw":
		if target.hp > 0:
			var spaces := rank_value(skill, level, 0, 2)
			var regen_chance := rank_value(skill, level, 1, 30) / 100.0
			_knockback(actor, target, spaces, _units, result)
			var chance_roll := randf() if roll < 0.0 else roll
			if chance_roll < regen_chance:
				actor.regen_turns = maxi(actor.get("regen_turns", 0), 1)
			result.message = "Kinetic Throw knocks %s back %d spaces." % [target.name, spaces]
			result.affected.append(target.id)
	elif skill_name == "Saturation Fire":
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
			result.message = "Saturation Fire deals %d damage to %d enem%s outside this lane." % [
				damage, victims.size(), "y" if victims.size() == 1 else "ies"
			]
	elif skill_name == "Clamp Drain":
		if target.get("immobilized_turns", 0) > 0:
			var amount := rank_value(skill, level, 0, 1)
			var regen_chance := rank_value(skill, level, 1, 30) / 100.0
			actor.atk += amount
			var chance_roll := randf() if roll < 0.0 else roll
			if chance_roll < regen_chance:
				actor.regen_turns = maxi(actor.get("regen_turns", 0), 1)
			result.message = "Clamp Drain grants %s +%d ATK." % [actor.name, amount]
			result.affected.append(actor.id)
	elif skill_name == "Vector Flurry":
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
			result.message = "Vector Flurry knocks back %d enem%s." % [
				result.affected.size(), "y" if result.affected.size() == 1 else "ies"
			]
	elif skill_name == "Shield Exchange":
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
			result.message = "Shield Exchange steals the enemy's Protect for %s." % _turn_label(turns)
	elif skill_name == "Twin Resonance":
		var health := rank_value(skill, level, 0, 1)
		var turns := rank_value(skill, level, 1, 2)
		var regen := rank_value(skill, level, 2, 2)
		var dissonance_counterpart_present: bool = _units.any(
			func(unit): return (
				unit.hp > 0
				and unit.get("skill", {}).get("name", "") == "Twin Dissonance"
			)
		)
		for ally in _units:
			if ally.side != actor.side or ally.get("hp", 0) <= 0:
				continue
			ally.hp += health
			ally.max_hp += health
			_add_effect(ally, "Twin Resonance", turns, 0, health)
			if dissonance_counterpart_present:
				ally.regen_turns = maxi(ally.get("regen_turns", 0), regen)
			result.affected.append(ally.id)
		result.message = "Twin Resonance grants all allies +%d HP for %s." % [
			health, _turn_label(turns)
		]
		if dissonance_counterpart_present:
			result.message += " Its linked counterpart grants Regen for %s." % _turn_label(regen)
	elif skill_name == "Twin Dissonance":
		var amount := rank_value(skill, level, 0, 1)
		var turns := rank_value(skill, level, 1, 2)
		var vulnerable_turns := rank_value(skill, level, 2, 2)
		var resonance_counterpart_present: bool = _units.any(
			func(unit): return (
				unit.hp > 0
				and unit.get("skill", {}).get("name", "") == "Twin Resonance"
			)
		)
		for enemy in _units:
			if enemy.side == actor.side or enemy.get("hp", 0) <= 0:
				continue
			enemy.atk = maxi(0, enemy.atk - amount)
			_add_effect(enemy, "Twin Dissonance", turns, -amount, 0)
			if resonance_counterpart_present:
				if enemy.get("vulnerable_turns", 0) > 0:
					enemy.vulnerable_stacks = enemy.get("vulnerable_stacks", 1) + 1
				else:
					enemy.vulnerable_stacks = 1
				enemy.vulnerable_turns = maxi(
					enemy.get("vulnerable_turns", 0), vulnerable_turns
				)
			result.affected.append(enemy.id)
		if not result.affected.is_empty():
			result.message = "Twin Dissonance gives all enemies -%d ATK for %s." % [
				amount, _turn_label(turns)
			]
			if resonance_counterpart_present:
				result.message += " Its linked counterpart makes them Vulnerable for %s." % _turn_label(vulnerable_turns)
	return result

static func resolve_reaction(
	target: Dictionary, attacker: Dictionary, _units: Array, roll: float = -1.0
) -> Dictionary:
	var result := {"message": "", "affected": [], "moved": []}
	var skill: Dictionary = target.get("skill", {})
	if skill.get("type", "").to_lower() != "reaction":
		return result
	if is_silenced(target):
		return result
	if target.get("hp", 0) <= 0 or attacker.get("hp", 0) <= 0:
		return result
	var level := int(target.get("level", 1))
	match skill.get("name", ""):
		"Slipstream Reversal":
			var spaces := rank_value(skill, level, 0, 1)
			var turns := rank_value(skill, level, 1, 1)
			_knockback(target, attacker, spaces, _units, result)
			target.haste_turns = maxi(target.get("haste_turns", 0), turns)
			result.message = "Slipstream Reversal knocks %s back %d space%s and grants %s Haste for %s." % [
				attacker.name, spaces, "" if spaces == 1 else "s",
				target.name, _turn_label(turns)
			]
			result.affected.append(attacker.id)
			result.affected.append(target.id)
		"Reactor Leap":
			var damage := rank_value(skill, level, 0, 3)
			BattleSimulatorScript.apply_unit_damage(attacker, damage)
			result.message = "Reactor Leap: %s attacks back for %d damage." % [
				target.name, damage
			]
			result.affected.append(attacker.id)
		"Aegis Array":
			var wall_chance := rank_value(skill, level, 0, 40) / 100.0
			var turns := rank_value(skill, level, 1, 2)
			var chance_roll := randf() if roll < 0.0 else roll
			if chance_roll < wall_chance:
				target.protect_turns = maxi(target.get("protect_turns", 0), turns)
				result.message = "Aegis Array grants %s Protect for %s." % [
					target.name, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Holdfast":
			var regen_chance := rank_value(skill, level, 0, 40) / 100.0
			var turns := rank_value(skill, level, 1, 2)
			var chance_roll := randf() if roll < 0.0 else roll
			if chance_roll < regen_chance:
				target.regen_turns = maxi(target.get("regen_turns", 0), turns)
				result.message = "Holdfast grants %s Regen for %s." % [
					target.name, _turn_label(turns)
				]
				result.affected.append(target.id)
		"Pressure Sink":
			var pressure_chance := rank_value(skill, level, 0, 60) / 100.0
			var amount := rank_value(skill, level, 1, 1)
			var chance_roll := randf() if roll < 0.0 else roll
			if chance_roll < pressure_chance:
				target.atk += amount
				target.regen_turns = maxi(target.get("regen_turns", 0), 1)
				result.message = "Pressure Sink grants %s +%d ATK and Regen for 1 turn." % [
					target.name, amount
				]
				result.affected.append(target.id)
		"Reversal Current":
			var turns := rank_value(skill, level, 0, 1)
			var regen_chance := rank_value(skill, level, 1, 20) / 100.0
			attacker.taunt_turns = maxi(attacker.get("taunt_turns", 0), turns)
			result.message = "Reversal Current Taunts %s for %s." % [
				attacker.name, _turn_label(turns)
			]
			result.affected.append(attacker.id)
			var chance_roll := randf() if roll < 0.0 else roll
			if chance_roll < regen_chance:
				target.regen_turns = maxi(target.get("regen_turns", 0), 1)
				result.affected.append(target.id)
		"Repulse Command":
			var spaces := rank_value(skill, level, 0, 2)
			var regen_chance := rank_value(skill, level, 1, 30) / 100.0
			_knockback(target, attacker, spaces, _units, result)
			attacker.immobilized_turns = maxi(attacker.get("immobilized_turns", 0), 2)
			result.message = "Repulse Command knocks back %s and Immobilises it for 2 turns." % attacker.name
			result.affected.append(attacker.id)
			var chance_roll := randf() if roll < 0.0 else roll
			if chance_roll < regen_chance:
				target.regen_turns = maxi(target.get("regen_turns", 0), 1)
				result.affected.append(target.id)
		"Paired Circuit":
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
				result.message = "Paired Circuit grants %s +1 ATK." % others[0].name
				result.affected.append(others[0].id)
			var regen_chance := rank_value(skill, level, 0, 20) / 100.0
			var chance_roll := randf() if roll < 0.0 else roll
			if chance_roll < regen_chance:
				target.regen_turns = maxi(target.get("regen_turns", 0), 1)
				if target.id not in result.affected:
					result.affected.append(target.id)
	return result

## Recomputes aura buffs from living sources. Each call strips the bonuses a
## unit currently carries (`aura_hp`, `aura_atk`) and re-applies what surviving
## aura units grant, so a buff disappears as soon as its source leaves the
## board. Silenced sources contribute nothing, so the buff drops while the
## source is Silenced and returns when the Silence expires. Every change is
## appended to `events` as {"unit_id", "delta", "label", "stat"} so callers can
## log aura gains and losses.
static func refresh_auras(units: Array, events: Array = []) -> void:
	var desired := {}
	var desired_atk := {}
	var desired_labels := {}
	for source in units:
		if source.get("hp", 1) <= 0:
			continue
		if is_silenced(source):
			continue
		var skill: Dictionary = source.get("skill", {})
		if skill.get("type", "").to_lower() != "aura":
			continue
		var level := int(source.get("level", 1))
		match skill.get("name", ""):
			"Dawn Circuit":
				var hp_amount := rank_value(skill, level, 0, 1)
				var atk_amount := rank_value(skill, level, 1, 1)
				for unit in units:
					if (
						unit.side == source.side and unit.id != source.id
						and unit.get("hp", 0) > 0 and unit.get("regen_turns", 0) > 0
					):
						desired[unit.id] = int(desired.get(unit.id, 0)) + hp_amount
						desired_atk[unit.id] = int(desired_atk.get(unit.id, 0)) + atk_amount
						var labels: Array = desired_labels.get(unit.id, [])
						if "Dawn Circuit" not in labels:
							labels.append("Dawn Circuit")
						desired_labels[unit.id] = labels
			"Lumen Shell":
				var amount := rank_value(skill, level, 0, 4)
				for unit in units:
					if unit.side == source.side and unit.id != source.id:
						desired[unit.id] = int(desired.get(unit.id, 0)) + amount
						var labels: Array = desired_labels.get(unit.id, [])
						if "Lumen Shell" not in labels:
							labels.append("Lumen Shell")
						desired_labels[unit.id] = labels
			"Resonant Chorus":
				var hp_amount := rank_value(skill, level, 0, 1)
				var atk_amount := rank_value(skill, level, 1, 1)
				for unit in units:
					if (
						unit.side == source.side and unit.id != source.id
						and unit.get("chassis_family", "standard") == "resonant"
					):
						desired[unit.id] = int(desired.get(unit.id, 0)) + hp_amount
						desired_atk[unit.id] = int(desired_atk.get(unit.id, 0)) + atk_amount
						var labels: Array = desired_labels.get(unit.id, [])
						if "Resonant Chorus" not in labels:
							labels.append("Resonant Chorus")
						desired_labels[unit.id] = labels
	for unit in units:
		if unit.get("hp", 0) <= 0:
			continue
		var label := " + ".join(desired_labels.get(unit.id, []))
		if label.is_empty():
			label = unit.get("aura_label", "the aura")
		var applied := int(unit.get("aura_hp", 0))
		var want := int(desired.get(unit.id, 0))
		if applied != want:
			events.append({
				"unit_id": unit.id, "delta": want - applied, "label": label, "stat": "HP"
			})
			unit.max_hp += want - applied
			unit.hp = clampi(unit.hp + want - applied, 1, unit.max_hp)
			unit.aura_hp = want
		var applied_atk := int(unit.get("aura_atk", 0))
		var want_atk := int(desired_atk.get(unit.id, 0))
		if applied_atk != want_atk:
			events.append({
				"unit_id": unit.id, "delta": want_atk - applied_atk, "label": label, "stat": "ATK"
			})
			unit.atk = maxi(0, unit.atk + want_atk - applied_atk)
			unit.aura_atk = want_atk
		if want > 0 or want_atk > 0:
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
		if unit.side == side and unit.get("silenced_turns", 0) > 0:
			unit.silenced_turns -= 1
		if unit.side == side and unit.get("haste_turns", 0) > 0:
			unit.haste_turns -= 1
		# Doom timers (Lasting Aegis) count the opposing side's turns; when one
		# runs out the carrier is defeated.
		if unit.side != side and unit.get("doom_turns", 0) > 0:
			unit.doom_turns -= 1
			if unit.doom_turns <= 0:
				unit.hp = 0
		# Retaliation Screen immunity also counts the opposing side's turns (the
		# "enemy turns" of the authored copy), so N covers exactly the next
		# N opposing-side turns.
		if unit.side != side and unit.get("summon_forth_turns", 0) > 0:
			unit.summon_forth_turns -= 1

## A Silenced unit's secondary skill does not trigger while the counter
## holds: it skips its Warcry, Strike, Chants, and Reaction, and stops
## contributing its Aura. Movement, attacks, and Conductor skills are unaffected.
static func is_silenced(unit: Dictionary) -> bool:
	return unit.get("silenced_turns", 0) > 0

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

## Highest-ATK enemy carrying a secondary skill; the Null Signal AI
## fallback. Enemies without a skill are never picked, since Silencing them
## would do nothing.
static func _skilled_enemy(actor: Dictionary, units: Array):
	var candidates := _enemies(actor, units).filter(
		func(unit): return not unit.get("skill", {}).is_empty()
	)
	candidates.sort_custom(func(a, b):
		if a.atk == b.atk:
			return a.id < b.id
		return a.atk > b.atk
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

## Up to `count` living enemies of `actor` with the highest ATK, the "random
## enemies with the highest ATK" in the Retaliation Screen and Silent Cycle rules
## text: whole ATK tiers are taken until a tier would overfill the remaining
## slots, which are then filled by seeded random picks from that tier.
static func _highest_attack_enemies(
	actor: Dictionary, units: Array, count: int, rng: RandomNumberGenerator
) -> Array:
	var candidates: Array = _enemies(actor, units).filter(
		func(unit): return unit.get("hp", 0) > 0
	)
	candidates.sort_custom(func(a, b):
		if a.atk == b.atk:
			return a.id < b.id
		return a.atk > b.atk
	)
	var picked: Array = []
	var index := 0
	while index < candidates.size() and picked.size() < count:
		var tier_atk: int = candidates[index].atk
		var tier: Array = []
		while index < candidates.size() and candidates[index].atk == tier_atk:
			tier.append(candidates[index])
			index += 1
		if picked.size() + tier.size() <= count:
			picked.append_array(tier)
		else:
			for slot in count - picked.size():
				var choice = _pick_random(tier, rng)
				tier.erase(choice)
				picked.append(choice)
	return picked

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

## Lane with the most living allied units; the Lane Bulwark AI fallback.
static func _best_ally_lane(actor: Dictionary, units: Array) -> int:
	var best_lane := -1
	var best_count := -1
	for lane in 3:
		var count := 0
		for unit in units:
			if (
				unit.side == actor.side and unit.row == lane
				and unit.get("hp", 0) > 0
			):
				count += 1
		if count > best_count:
			best_lane = lane
			best_count = count
	return best_lane
