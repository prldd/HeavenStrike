class_name BattleAI
extends RefCounted

const BattleRulesScript = preload("res://scripts/battle_rules.gd")
const PLAYER := 0
const ENEMY := 1
const COLS := 7

static func choose_deployment(roster: Array, energy: int, units: Array) -> Dictionary:
	var best := {}
	var best_score := -INF
	for card in roster:
		if card.cost > energy:
			continue
		for row in 3:
			if _occupied(units, row, COLS - 1):
				continue
			var score := _score(card, row, energy, units)
			if score > best_score:
				best_score = score
				best = {"card": card, "row": row}
	return best

static func lane_priority(units: Array) -> Array:
	var scored := []
	for row in 3:
		var score := 0.0
		for unit in units:
			if unit.row != row:
				continue
			var proximity: float = 1.0 + float(unit.col) / float(COLS - 1)
			score += unit.atk * proximity * (1.0 if unit.side == PLAYER else -0.45)
		scored.append({"row": row, "score": score})
	scored.sort_custom(func(a, b): return a.score > b.score)
	return scored.map(func(item): return item.row)

static func _score(card: Dictionary, row: int, energy: int, units: Array) -> float:
	var player_threat := 0.0
	var enemy_support := 0.0
	var wounded_allies := 0
	var adjacent_targets := 0
	for unit in units:
		if unit.side == PLAYER:
			if unit.row == row:
				player_threat += unit.atk * 2.0 + unit.hp * 0.25 + unit.col * 0.8
			if absi(unit.row - row) == 1:
				adjacent_targets += 1
		elif unit.row == row:
			enemy_support += unit.atk + unit.hp * 0.2
			if unit.hp < unit.max_hp:
				wounded_allies += 1

	var score: float = player_threat + enemy_support * 0.35
	var board_value: float = card.atk * 1.25 + card.hp * 0.35
	score += board_value / maxf(1.0, card.cost)
	score -= card.cost * 0.25
	score += 1.25 if card.cost == energy else 0.0
	var deployed_allies: int = units.filter(func(unit): return unit.side == ENEMY).size()
	if player_threat <= 0.0 and deployed_allies >= 3:
		score -= card.cost * 0.9
	match card.kind:
		"Warden":
			score += player_threat * 0.55
		"Artillerist":
			score += player_threat * 0.35
		"Channeler":
			score += adjacent_targets * 1.6
		"Lifebinder":
			score += wounded_allies * 2.5
			if wounded_allies == 0:
				score -= 1.5
		"Strider":
			if player_threat == 0:
				score += 2.0
	return score

static func choose_reposition(unit: Dictionary, units: Array) -> int:
	var best_row: int = unit.row
	var best_score := _reposition_score(unit, unit.row, units)
	for row in 3:
		if row == unit.row or not _can_reposition(unit, row, units):
			continue
		var score := _reposition_score(unit, row, units)
		if score > best_score:
			best_score = score
			best_row = row
	return best_row

static func should_use_conductor_skill(
	skill_name: String, round_number: int, conductor_hp: int, units: Array
) -> bool:
	var allies: Array = units.filter(func(unit): return unit.side == ENEMY)
	var enemies: Array = units.filter(func(unit): return unit.side == PLAYER)
	match skill_name:
		"Aid", "Healing Wave":
			return allies.any(func(unit): return unit.hp < unit.max_hp)
		"Shield", "Last Stand":
			return conductor_hp <= 10 or round_number >= 4
		"Firestorm", "Lightning Burst":
			return enemies.size() >= 2 or conductor_hp <= 8
		"Rally", "Bloodlust":
			return allies.size() >= 2
	return round_number >= 3

static func _reposition_score(unit: Dictionary, row: int, units: Array) -> float:
	var player_threat := 0.0
	var targets_in_range := 0
	for other in units:
		if other.side != PLAYER or other.row != row:
			continue
		player_threat += other.get("atk", 0) + other.get("hp", 0) * 0.2
		var distance: int = unit.col - other.col
		if distance > 0 and distance <= unit.get("range", 1):
			targets_in_range += 1
	var score := targets_in_range * 5.0 - player_threat * 0.3
	if unit.get("kind", "") == "Warden":
		score += player_threat * 0.7
	elif unit.get("kind", "") in ["Artillerist", "Channeler"]:
		score += targets_in_range * 2.0
	return score

static func _can_reposition(unit: Dictionary, target_row: int, units: Array) -> bool:
	return BattleRulesScript.can_reposition(unit, target_row, units)

static func _occupied(units: Array, row: int, col: int) -> bool:
	for unit in units:
		if unit.row == row and unit.col == col:
			return true
	return false
