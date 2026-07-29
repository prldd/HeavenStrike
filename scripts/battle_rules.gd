class_name BattleRules
extends RefCounted

const PLAYER := 0
const ROWS := 3

static func is_taunted(unit: Dictionary, units: Array) -> bool:
	var direction := 1 if unit.side == PLAYER else -1
	for other in units:
		if other.side == unit.side or other.kind != "Warden" or other.row != unit.row:
			continue
		var distance: int = (other.col - unit.col) * direction
		if distance > 0 and distance <= 2:
			return true
	return false

static func can_reposition(unit: Dictionary, target_row: int, units: Array) -> bool:
	if target_row < 0 or target_row >= ROWS:
		return false
	if absi(target_row - unit.row) != 1:
		return false
	if unit.get("repositioned", false) or is_taunted(unit, units):
		return false
	for other in units:
		if other.row == target_row and other.col == unit.col:
			return false
	return true

