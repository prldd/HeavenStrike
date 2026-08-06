class_name MissionRules
extends RefCounted

const PLAYER := 0
const ENEMY := 1
const ROWS := 3
const COLS := 7

const OBJECTIVE_DEFEAT_CONDUCTOR := "defeat_conductor"
const OBJECTIVE_SURVIVE := "survive"
const OBJECTIVE_ELIMINATE_TARGET := "eliminate_target"
const OBJECTIVE_PROTECT := "protect"
const OBJECTIVE_TYPES := [
	OBJECTIVE_DEFEAT_CONDUCTOR,
	OBJECTIVE_SURVIVE,
	OBJECTIVE_ELIMINATE_TARGET,
	OBJECTIVE_PROTECT
]

## Converts optional authored encounter data into the complete runtime shape.
## Keeping normalization here lets old encounters and version-one replays omit
## mission rules without changing their behavior.
static func normalize(authored: Dictionary = {}) -> Dictionary:
	var objective_source: Dictionary = authored.get("objective", {})
	var objective_type: String = objective_source.get(
		"type", OBJECTIVE_DEFEAT_CONDUCTOR
	)
	if objective_type not in OBJECTIVE_TYPES:
		objective_type = OBJECTIVE_DEFEAT_CONDUCTOR
	var rules := {
		"objective": {
			"type": objective_type,
			"rounds": maxi(1, int(objective_source.get("rounds", 1))),
			"target_name": str(objective_source.get("target_name", "")),
			"title": str(objective_source.get("title", "")),
			"description": str(objective_source.get("description", ""))
		},
		"turn_limit": maxi(0, int(authored.get("turn_limit", 0))),
		"blocked_cells": _valid_cells(authored.get("blocked_cells", [])),
		"predeployed": _valid_deployments(authored.get("predeployed", [])),
		"reinforcements": _valid_reinforcements(authored.get("reinforcements", [])),
		"mana": _normalize_mana(authored.get("mana", {}))
	}
	return rules

static func default_rules() -> Dictionary:
	return normalize()

static func has_authored_rules(rules: Dictionary) -> bool:
	var normalized := normalize(rules)
	return (
		normalized.objective.type != OBJECTIVE_DEFEAT_CONDUCTOR
		or normalized.turn_limit > 0
		or not normalized.blocked_cells.is_empty()
		or not normalized.predeployed.is_empty()
		or not normalized.reinforcements.is_empty()
		or normalized.mana != _normalize_mana({})
	)

static func objective_title(rules: Dictionary) -> String:
	var objective: Dictionary = normalize(rules).objective
	if not objective.title.is_empty():
		return objective.title.to_upper()
	match objective.type:
		OBJECTIVE_SURVIVE:
			return "HOLD THE FIELD"
		OBJECTIVE_ELIMINATE_TARGET:
			return "ELIMINATE THE PRIORITY TARGET"
		OBJECTIVE_PROTECT:
			return "PROTECT THE ASSET"
	return "DEFEAT THE ENEMY CONDUCTOR"

static func objective_description(rules: Dictionary) -> String:
	var normalized := normalize(rules)
	var objective: Dictionary = normalized.objective
	if not objective.description.is_empty():
		return objective.description
	match objective.type:
		OBJECTIVE_SURVIVE:
			return "Keep your Conductor operational through round %d." % objective.rounds
		OBJECTIVE_ELIMINATE_TARGET:
			return "Defeat %s. Destroying the enemy Conductor also wins." % (
				objective.target_name if not objective.target_name.is_empty() else "the marked unit"
			)
		OBJECTIVE_PROTECT:
			return "Keep %s operational and defeat the enemy Conductor." % (
				objective.target_name if not objective.target_name.is_empty() else "the marked asset"
			)
	return "Reduce the enemy Conductor to 0 HP."

static func dossier_text(rules: Dictionary) -> String:
	var normalized := normalize(rules)
	var lines: Array[String] = [
		"OBJECTIVE  ·  %s" % objective_title(normalized),
		objective_description(normalized)
	]
	if normalized.turn_limit > 0:
		lines.append("LIMIT  ·  %d ROUNDS" % normalized.turn_limit)
	if not normalized.blocked_cells.is_empty():
		lines.append("TERRAIN  ·  %d BLOCKED CELL%s" % [
			normalized.blocked_cells.size(),
			"" if normalized.blocked_cells.size() == 1 else "S"
		])
	if not normalized.predeployed.is_empty():
		lines.append("FIELD  ·  %d PREDEPLOYED UNIT%s" % [
			normalized.predeployed.size(),
			"" if normalized.predeployed.size() == 1 else "S"
		])
	if not normalized.reinforcements.is_empty():
		lines.append("INTEL  ·  REINFORCEMENTS EXPECTED")
	var mana: Dictionary = normalized.mana
	if mana.player_start != 2 or mana.enemy_start != 2 or mana.cap != 10:
		lines.append("MANA  ·  START %d/%d · CAP %d" % [
			mana.player_start, mana.enemy_start, mana.cap
		])
	return "\n".join(lines)

static func objective_banner(rules: Dictionary, round_number: int) -> String:
	var normalized := normalize(rules)
	var objective: Dictionary = normalized.objective
	var banner := objective_title(normalized)
	if objective.type == OBJECTIVE_SURVIVE:
		banner += "  ·  %d/%d" % [mini(round_number, objective.rounds), objective.rounds]
	if normalized.turn_limit > 0:
		banner += "  ·  LIMIT %d" % normalized.turn_limit
	return banner

## Evaluates only terminal state. Survival and turn-limit conditions are
## checked at enemy_end so “round N” includes both sides' actions.
static func evaluate(
	rules: Dictionary,
	units: Array,
	round_number: int,
	player_hp: int,
	enemy_hp: int,
	checkpoint: String = "action"
) -> Dictionary:
	var normalized := normalize(rules)
	var objective: Dictionary = normalized.objective
	if player_hp <= 0:
		return _result(true, ENEMY, "Your Conductor was defeated.")
	if objective.type == OBJECTIVE_PROTECT and not _living_role(units, "protected"):
		return _result(true, ENEMY, "%s was lost." % (
			objective.target_name if not objective.target_name.is_empty() else "The protected asset"
		))
	if enemy_hp <= 0:
		return _result(true, PLAYER, "The enemy Conductor was defeated.")
	if objective.type == OBJECTIVE_ELIMINATE_TARGET and not _living_role(units, "priority"):
		return _result(true, PLAYER, "%s was eliminated." % (
			objective.target_name if not objective.target_name.is_empty() else "The priority target"
		))
	if (
		checkpoint == "enemy_end" and objective.type == OBJECTIVE_SURVIVE
		and round_number >= objective.rounds
	):
		return _result(true, PLAYER, "The formation held through round %d." % objective.rounds)
	if (
		checkpoint == "enemy_end" and normalized.turn_limit > 0
		and round_number >= normalized.turn_limit
	):
		return _result(true, ENEMY, "The %d-round operation window closed." % normalized.turn_limit)
	return _result(false, -1, "")

static func is_blocked(rules: Dictionary, row: int, col: int) -> bool:
	for cell in normalize(rules).blocked_cells:
		if cell.row == row and cell.col == col:
			return true
	return false

static func _result(finished: bool, winner: int, reason: String) -> Dictionary:
	return {"finished": finished, "winner": winner, "reason": reason}

static func _living_role(units: Array, role: String) -> bool:
	return units.any(func(unit): return (
		unit.get("mission_role", "") == role and unit.get("hp", 0) > 0
	))

static func _normalize_mana(source: Dictionary) -> Dictionary:
	var cap := clampi(int(source.get("cap", 10)), 2, 10)
	return {
		"player_start": clampi(int(source.get("player_start", 2)), 0, cap),
		"enemy_start": clampi(int(source.get("enemy_start", 2)), 0, cap),
		"growth": clampi(int(source.get("growth", 2)), 0, 10),
		"cap": cap
	}

static func _valid_cells(source: Variant) -> Array:
	var result: Array = []
	if source is not Array:
		return result
	for raw_cell in source:
		if raw_cell is not Dictionary:
			continue
		var row := int(raw_cell.get("row", -1))
		var col := int(raw_cell.get("col", -1))
		var cell := {"row": row, "col": col}
		if row >= 0 and row < ROWS and col >= 0 and col < COLS and cell not in result:
			result.append(cell)
	return result

static func _valid_deployments(source: Variant) -> Array:
	var result: Array = []
	if source is not Array:
		return result
	for raw_deployment in source:
		if raw_deployment is not Dictionary:
			continue
		var deployment: Dictionary = raw_deployment.duplicate(true)
		deployment["side"] = clampi(int(deployment.get("side", ENEMY)), PLAYER, ENEMY)
		deployment["row"] = clampi(int(deployment.get("row", 1)), 0, ROWS - 1)
		deployment["col"] = clampi(int(deployment.get(
			"col", 1 if deployment.side == PLAYER else COLS - 2
		)), 0, COLS - 1)
		deployment["role"] = str(deployment.get("role", ""))
		deployment["stationary"] = bool(deployment.get("stationary", false))
		deployment["locks_mana"] = bool(deployment.get("locks_mana", false))
		if not str(deployment.get("unit", "")).is_empty():
			result.append(deployment)
	return result

static func _valid_reinforcements(source: Variant) -> Array:
	var result := _valid_deployments(source)
	for index in result.size():
		result[index]["round"] = maxi(1, int(result[index].get("round", 1)))
	return result
