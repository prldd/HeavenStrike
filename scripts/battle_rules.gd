class_name BattleRules
extends RefCounted

const PLAYER := 0
const ROWS := 3
const COLS := 7

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

static func attack_cells(unit: Dictionary) -> Array:
	var cells: Array = []
	var direction := 1 if unit.side == PLAYER else -1
	for distance in range(1, unit.range + 1):
		var col: int = unit.col + direction * distance
		if col < 0 or col >= COLS:
			break
		cells.append(Vector2i(col, unit.row))
	return cells

static func traversal_cells(unit: Dictionary, units: Array) -> Array:
	if has_target_in_range(unit, units) or commander_in_range(unit):
		return []
	var cells: Array = []
	var direction := 1 if unit.side == PLAYER else -1
	for step in range(1, unit.move + 1):
		var col: int = unit.col + direction * step
		if col < 0 or col >= COLS or _occupied(units, unit.row, col):
			break
		cells.append(Vector2i(col, unit.row))
	return cells

static func has_target_in_range(unit: Dictionary, units: Array) -> bool:
	var direction := 1 if unit.side == PLAYER else -1
	for other in units:
		if other.side == unit.side or other.row != unit.row:
			continue
		var distance: int = (other.col - unit.col) * direction
		if distance > 0 and distance <= unit.range:
			return true
	return false

static func commander_in_range(unit: Dictionary) -> bool:
	if unit.side == PLAYER:
		return COLS - unit.col <= unit.range
	return unit.col + 1 <= unit.range

static func _occupied(units: Array, row: int, col: int) -> bool:
	for unit in units:
		if unit.row == row and unit.col == col:
			return true
	return false
