class_name BattleSimulator
extends RefCounted

const BattleRulesScript = preload("res://scripts/battle_rules.gd")
const KineticCrucibleScript = preload("res://scripts/kinetic_crucible.gd")

const PLAYER := 0
const ENEMY := 1

var seed_value := 1
var rng := RandomNumberGenerator.new()
var events: Array = []
var sequence := 0

func reset(next_seed: int) -> void:
	seed_value = next_seed
	rng.seed = next_seed
	events.clear()
	sequence = 0

func activation_order(side: int, units: Array) -> Array:
	var ordered := units.filter(func(unit):
		return unit.side == side and unit.get("ready", false) \
			and unit.get("stun_turns", 0) <= 0
	)
	ordered.sort_custom(func(a, b):
		if a.col == b.col:
			return a.row < b.row
		return a.col > b.col if side == PLAYER else a.col < b.col
	)
	return ordered.map(func(unit): return unit.id)

func plan_activation(actor_id: int, units: Array) -> Dictionary:
	var actor = unit_by_id(units, actor_id)
	if actor == null:
		return {}
	var path: Array = BattleRulesScript.traversal_cells(actor, units)
	var projected_col: int = actor.col if path.is_empty() else path[-1].x
	var projected_actor: Dictionary = actor.duplicate(true)
	projected_actor.col = projected_col
	var target = find_target(projected_actor, units)
	var strikes := 2 if actor.kind == "Strider" else 1
	var plan := {
		"actor_id": actor.id,
		"side": actor.side,
		"movement": path,
		"projected_col": projected_col,
		"target_id": -1 if target == null else target.id,
		"commander_side": -1,
		"strikes": strikes,
		"class_skill": class_skill(actor.kind),
		"secondary_skill": actor.get("skill", {}).duplicate(true)
	}
	if target == null and BattleRulesScript.commander_in_range(projected_actor):
		plan.commander_side = ENEMY if actor.side == PLAYER else PLAYER
	return plan

func preview_side(side: int, units: Array, limit: int = 3) -> Dictionary:
	var projected_units: Array = units.duplicate(true)
	var order := activation_order(side, projected_units)
	var plans: Array = []
	for actor_id in order:
		var plan := plan_activation(actor_id, projected_units)
		plans.append(plan)
		var actor = unit_by_id(projected_units, actor_id)
		if actor != null:
			actor.col = plan.get("projected_col", actor.col)
	var visible: Array = plans.slice(0, mini(limit, plans.size()))
	return {
		"side": side,
		"order": order,
		"plans": plans,
		"visible": visible,
		"remaining": maxi(0, plans.size() - visible.size())
	}

func record(event_type: String, payload: Dictionary = {}) -> Dictionary:
	sequence += 1
	var event := payload.duplicate(true)
	event["sequence"] = sequence
	event["type"] = event_type
	events.append(event)
	return event

func replay_data(metadata: Dictionary = {}) -> Dictionary:
	return {
		"version": 1,
		"seed": seed_value,
		"metadata": metadata.duplicate(true),
		"events": events.duplicate(true)
	}

func replay_json(metadata: Dictionary = {}) -> String:
	return JSON.stringify(replay_data(metadata), "\t")

static func load_replay(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is not Dictionary:
		return {}
	if int(parsed.get("version", 0)) != 1 or parsed.get("events", []) is not Array:
		return {}
	return parsed

static func load_replay_history(path: String) -> Array:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return []
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is not Dictionary or parsed.get("replays", []) is not Array:
		return []
	var valid_replays: Array = []
	for replay in parsed.replays:
		if replay is Dictionary \
				and int(replay.get("version", 0)) == 1 \
				and replay.get("events", []) is Array:
			valid_replays.append(replay)
	return valid_replays

func save_replay(path: String, metadata: Dictionary = {}) -> bool:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(replay_json(metadata))
	return true

func archive_replay(path: String, metadata: Dictionary = {}, limit := 10) -> bool:
	var history := load_replay_history(path)
	history.push_front(replay_data(metadata))
	if history.size() > limit:
		history.resize(limit)
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify({
		"version": 1,
		"replays": history
	}, "\t"))
	return true

static func find_target(actor: Dictionary, units: Array):
	var direction := 1 if actor.side == PLAYER else -1
	var candidates := units.filter(func(other):
		if other.side == actor.side or other.row != actor.row:
			return false
		var distance: int = (other.col - actor.col) * direction
		return distance > 0 and distance <= actor.range
	)
	if candidates.is_empty():
		return null
	candidates.sort_custom(func(a, b):
		var a_distance: int = absi(a.col - actor.col)
		var b_distance: int = absi(b.col - actor.col)
		return a.id < b.id if a_distance == b_distance else a_distance < b_distance
	)
	return candidates[0]

static func unit_by_id(units: Array, unit_id: int):
	for unit in units:
		if unit.id == unit_id:
			return unit
	return null

static func class_skill(kind: String) -> String:
	match kind:
		"Strider":
			return "Double Strike"
		"Duelist":
			return "Fury"
		"Warden":
			return "Taunting Strike"
		"Artillerist":
			return "Piercing Shot"
		"Channeler":
			return "Blast"
		"Lifebinder":
			return "Heal"
	return ""

static func estimate_squad_power(cards: Array) -> float:
	var score := 0.0
	for card in cards:
		var reach: float = card.get("move", 1) + card.get("range", 1)
		var class_multiplier := 1.35 if card.get("kind", "") == "Strider" else 1.0
		var level: int = card.get("level", 1)
		score += (
			KineticCrucibleScript.scaled_stat(card.get("atk", 0), level) * class_multiplier
			+ KineticCrucibleScript.scaled_stat(card.get("hp", 0), level) * 0.45
			+ reach * 0.55
			- card.get("cost", 0) * 0.25
		)
	return score

## The single damage gate. Attack damage (a normal attack hit and its
## Blast/Pierce riders) passes the attacking unit as `source`; secondary-skill
## and Captain damage passes no source and therefore bypasses both damage
## immunities: Summon Forth (0 damage when attacked while its counter holds)
## and Quiet! (0 damage from Silenced attackers while the carrier lives).
## The returned `immunity` names the immunity that zeroed the hit ("" when
## none) so callers can message it and fire the Summon Forth retaliation.
static func apply_unit_damage(
	unit: Dictionary, amount: int, source: Dictionary = {}
) -> Dictionary:
	var before: int = unit.get("hp", 0)
	var adjusted_amount := maxi(0, amount)
	var protected: bool = unit.get("protect_turns", 0) > 0
	var immunity := ""
	if protected:
		adjusted_amount = 0
	elif not source.is_empty():
		if unit.get("summon_forth_turns", 0) > 0:
			immunity = "summon_forth"
		elif (
			unit.get("skill", {}).get("name", "") == "Quiet!"
			and source.get("silenced_turns", 0) > 0
		):
			immunity = "quiet"
		if not immunity.is_empty():
			adjusted_amount = 0
	if adjusted_amount > 0 and unit.get("vulnerable_turns", 0) > 0:
		adjusted_amount += maxi(1, unit.get("vulnerable_stacks", 1))
	var dealt := mini(before, adjusted_amount)
	unit.hp = before - adjusted_amount
	return {
		"unit_id": unit.get("id", -1),
		"before": before,
		"damage": dealt,
		"after": unit.hp,
		"defeated": unit.hp <= 0,
		"protected": protected,
		"immunity": immunity
	}

static func apply_unit_healing(
	unit: Dictionary, amount: int, allow_overheal: bool = false
) -> Dictionary:
	var before: int = unit.get("hp", 0)
	var limit: int = before + amount if allow_overheal else unit.get("max_hp", before)
	unit.hp = mini(limit, before + maxi(0, amount))
	return {
		"unit_id": unit.get("id", -1),
		"before": before,
		"healing": unit.hp - before,
		"after": unit.hp
	}

static func apply_captain_damage(
	side: int, amount: int, captain_state: Dictionary
) -> Dictionary:
	var hp_key := "player_hp" if side == PLAYER else "enemy_hp"
	var shield_key := "player_shield" if side == PLAYER else "enemy_shield"
	var remaining := maxi(0, amount)
	var absorbed := mini(int(captain_state.get(shield_key, 0)), remaining)
	captain_state[shield_key] = int(captain_state.get(shield_key, 0)) - absorbed
	remaining -= absorbed
	var before: int = captain_state.get(hp_key, 0)
	captain_state[hp_key] = maxi(0, before - remaining)
	return {
		"side": side,
		"before": before,
		"shield_absorbed": absorbed,
		"damage": remaining,
		"after": captain_state[hp_key]
	}
