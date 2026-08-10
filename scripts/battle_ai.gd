class_name BattleAI
extends RefCounted

const BattleRulesScript = preload("res://scripts/battle_rules.gd")
const PLAYER := 0
const ENEMY := 1
const COLS := 7

static func choose_deployment(
	roster: Array, energy: int, units: Array, blocked_cells: Array = []
) -> Dictionary:
	var best := {}
	var best_score := -INF
	for card in roster:
		if card.cost > energy:
			continue
		for row in 3:
			if (
				_occupied(units, row, COLS - 1)
				or BattleRulesScript.is_cell_blocked(blocked_cells, row, COLS - 1)
			):
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

## Repositioning priorities, highest first: interpose on a lane whose opposing
## units can kill our Conductor on their upcoming turn, then open a rail toward
## the opposing Conductor (a lane with no opposing units), and only then trade
## blows with individual units. `conductor_hp` of -1 means unknown, so any
## open-rail threat counts as lethal.
static func choose_reposition(
	unit: Dictionary, units: Array, blocked_cells: Array = [], conductor_hp: int = -1
) -> int:
	var lethal_rows := _lethal_threat_rows(unit.side, units, conductor_hp)
	var best_row: int = unit.row
	var best_score := _reposition_score(unit, unit.row, units, lethal_rows)
	for row in 3:
		if row == unit.row or not _can_reposition(unit, row, units, blocked_cells):
			continue
		var score := _reposition_score(unit, row, units, lethal_rows)
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

static func _reposition_score(
	unit: Dictionary, row: int, units: Array, lethal_rows: Array = []
) -> float:
	var direction := 1 if unit.side == PLAYER else -1
	var player_threat := 0.0
	var targets_in_range := 0
	var opponents_in_row := 0
	for other in units:
		if other.side == unit.side or other.row != row:
			continue
		opponents_in_row += 1
		player_threat += other.get("atk", 0) + other.get("hp", 0) * 0.2
		var distance: int = (other.col - unit.col) * direction
		if distance > 0 and distance <= unit.get("range", 1):
			targets_in_range += 1
	var score := 0.0
	if lethal_rows.has(row):
		# Lethal lanes outrank everything; only a unit stationed ahead of the
		# threat can actually body-block it, otherwise it just joins the fight.
		score += 100.0 if _can_interpose(unit, row, units) else 15.0
	if opponents_in_row == 0:
		score += 40.0
		if _commander_in_range(unit):
			score += 25.0
	else:
		score += targets_in_range * 1.5 - player_threat * 0.3
		if unit.get("kind", "") == "Warden":
			score += player_threat * 0.7
		elif unit.get("kind", "") in ["Artillerist", "Channeler"]:
			score += targets_in_range * 2.0
	return score

## Lanes where an opposing unit can strike the given side's Conductor on its
## upcoming turn: no defender stands ahead of it and one advance (if it can
## still move) brings the Conductor into range. The lanes only count when
## their combined potential damage is lethal; unknown HP (-1) treats any such
## lane as lethal.
static func _lethal_threat_rows(side: int, units: Array, conductor_hp: int) -> Array:
	var rows := {}
	var total_damage := 0
	for other in units:
		if other.side == side or _has_defender_ahead(side, other, units):
			continue
		var move: int = other.get("move", 1)
		if BattleRulesScript.is_stunned(other) or BattleRulesScript.is_immobilized(other):
			move = 0
		if side == ENEMY:
			var final_col: int = mini(other.col + move, COLS - 2)
			if (COLS - 1) - final_col > other.get("range", 1):
				continue
		else:
			var final_col: int = maxi(other.col - move, 1)
			if final_col > other.get("range", 1):
				continue
		rows[other.row] = true
		total_damage += other.get("atk", 0) * (2 if other.get("kind", "") == "Strider" else 1)
	if conductor_hp > 0 and total_damage < conductor_hp:
		return []
	return rows.keys()

static func _has_defender_ahead(side: int, threat: Dictionary, units: Array) -> bool:
	for unit in units:
		if unit.side != side or unit.row != threat.row:
			continue
		if side == ENEMY and unit.col > threat.col:
			return true
		if side == PLAYER and unit.col < threat.col:
			return true
	return false

static func _can_interpose(unit: Dictionary, row: int, units: Array) -> bool:
	for other in units:
		if other.side == unit.side or other.row != row:
			continue
		if unit.side == ENEMY and unit.col > other.col:
			return true
		if unit.side == PLAYER and unit.col < other.col:
			return true
	return false

static func _commander_in_range(unit: Dictionary) -> bool:
	if unit.side == PLAYER:
		return (COLS - 1) - unit.col <= unit.get("range", 1)
	return unit.col <= unit.get("range", 1)

static func _can_reposition(
	unit: Dictionary, target_row: int, units: Array, blocked_cells: Array = []
) -> bool:
	return BattleRulesScript.can_reposition(unit, target_row, units, blocked_cells)

static func _occupied(units: Array, row: int, col: int) -> bool:
	for unit in units:
		if unit.row == row and unit.col == col:
			return true
	return false
