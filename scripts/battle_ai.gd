class_name BattleAI
extends RefCounted

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
	score += card.cost * 0.4
	score += 1.25 if card.cost == energy else 0.0
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

static func _occupied(units: Array, row: int, col: int) -> bool:
	for unit in units:
		if unit.row == row and unit.col == col:
			return true
	return false

