class_name BattleRules
extends RefCounted

const PLAYER := 0
const ROWS := 3
const COLS := 7

static func is_taunted(unit: Dictionary, units: Array) -> bool:
	return unit.get("taunt_turns", 0) > 0

static func is_immobilized(unit: Dictionary) -> bool:
	return unit.get("immobilized_turns", 0) > 0

static func is_stunned(unit: Dictionary) -> bool:
	return unit.get("stun_turns", 0) > 0

static func apply_taunt(unit: Dictionary, turns: int = 2) -> void:
	unit.taunt_turns = maxi(unit.get("taunt_turns", 0), turns)

static func expire_taunts(units: Array, side: int) -> void:
	for unit in units:
		if unit.side == side and unit.get("taunt_turns", 0) > 0:
			unit.taunt_turns -= 1

static func can_reposition(
	unit: Dictionary, target_row: int, units: Array, blocked_cells: Array = []
) -> bool:
	if target_row < 0 or target_row >= ROWS:
		return false
	if target_row == unit.row:
		return false
	if (
		is_taunted(unit, units) or is_immobilized(unit) or is_stunned(unit)
		or unit.get("mission_stationary", false)
	):
		return false
	var direction := 1 if target_row > unit.row else -1
	for row in range(unit.row + direction, target_row + direction, direction):
		if is_cell_blocked(blocked_cells, row, unit.col):
			return false
		for other in units:
			if other.get("id", -1) != unit.id and other.row == row and other.col == unit.col:
				# Friendly units may be crossed, but no unit may share the destination.
				if row == target_row or other.side != unit.side:
					return false
	return true

static func attack_cells(unit: Dictionary) -> Array:
	return attack_cells_from(unit, unit.col)

static func attack_cells_from(unit: Dictionary, origin_col: int) -> Array:
	var cells: Array = []
	var direction := 1 if unit.side == PLAYER else -1
	for distance in range(1, unit.range + 1):
		var col: int = origin_col + direction * distance
		if col < 0 or col >= COLS:
			break
		cells.append(Vector2i(col, unit.row))
	return cells

static func traversal_cells(
	unit: Dictionary, units: Array, blocked_cells: Array = []
) -> Array:
	var cells: Array = []
	if (
		unit.get("immobilized_turns", 0) > 0 or unit.get("stun_turns", 0) > 0
		or unit.get("mission_stationary", false)
	):
		return cells
	var direction := 1 if unit.side == PLAYER else -1
	var final_col := COLS - 2 if unit.side == PLAYER else 1
	var move: int = unit.move + (1 if unit.get("haste_turns", 0) > 0 else 0)
	for step in range(1, move + 1):
		var col: int = unit.col + direction * step
		if (direction > 0 and col > final_col) or (direction < 0 and col < final_col):
			break
		if _occupied(units, unit.row, col) or is_cell_blocked(blocked_cells, unit.row, col):
			break
		cells.append(Vector2i(col, unit.row))
	return cells

static func projected_action(
	unit_id: int, units: Array, blocked_cells: Array = []
) -> Dictionary:
	var projected_units: Array = units.duplicate(true)
	var selected = _unit_by_id(projected_units, unit_id)
	if selected == null or not selected.get("ready", false):
		return {"traversal": [], "attack": [], "origin_col": -1, "projected_col": -1}

	var actors: Array = projected_units.filter(
		func(unit): return unit.side == selected.side and unit.get("ready", false)
	)
	actors.sort_custom(func(a, b):
		if a.col == b.col:
			return a.row < b.row
		return a.col > b.col if selected.side == PLAYER else a.col < b.col
	)

	for actor in actors:
		var path := traversal_cells(actor, projected_units, blocked_cells)
		if actor.id == unit_id:
			var destination: int = actor.col if path.is_empty() else path[-1].x
			return {
				"traversal": path,
				"attack": attack_cells_from(actor, destination),
				"origin_col": actor.col,
				"projected_col": destination
			}
		if not path.is_empty():
			actor.col = path[-1].x

	return {"traversal": [], "attack": [], "origin_col": -1, "projected_col": -1}

static func projected_deployment(
	card: Dictionary, row: int, units: Array, blocked_cells: Array = []
) -> Dictionary:
	if (
		row < 0 or row >= ROWS or _occupied(units, row, 0)
		or is_cell_blocked(blocked_cells, row, 0)
	):
		return {"traversal": [], "attack": [], "origin_col": -1, "projected_col": -1}
	var projected_units: Array = units.duplicate(true)
	var projected_unit := card.duplicate(true)
	var projected_id := -1
	while _unit_by_id(projected_units, projected_id) != null:
		projected_id -= 1
	projected_unit.id = projected_id
	projected_unit.side = PLAYER
	projected_unit.row = row
	projected_unit.col = 0
	projected_unit.ready = true
	projected_unit.immobilized_turns = 0
	projected_units.append(projected_unit)
	return projected_action(projected_id, projected_units, blocked_cells)

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
		return (COLS - 1) - unit.col <= unit.range
	return unit.col <= unit.range

static func blast_cells(target: Dictionary) -> Array:
	return [
		Vector2i(target.col - 1, target.row),
		Vector2i(target.col + 1, target.row),
		Vector2i(target.col, target.row - 1),
		Vector2i(target.col, target.row + 1)
	].filter(func(cell): return cell.x >= 0 and cell.x < COLS and cell.y >= 0 and cell.y < ROWS)

static func locked_mana(units: Array, side: int) -> int:
	var locked := 0
	for unit in units:
		if unit.side == side and unit.get("locks_mana", true):
			locked += unit.get("cost", 0)
	return locked

static func available_mana(capacity: int, units: Array, side: int) -> int:
	return maxi(0, capacity - locked_mana(units, side))

static func is_cell_blocked(blocked_cells: Array, row: int, col: int) -> bool:
	for cell in blocked_cells:
		if int(cell.get("row", -1)) == row and int(cell.get("col", -1)) == col:
			return true
	return false

static func _occupied(units: Array, row: int, col: int) -> bool:
	for unit in units:
		if unit.row == row and unit.col == col:
			return true
	return false

static func _unit_by_id(units: Array, unit_id: int):
	for unit in units:
		if unit.id == unit_id:
			return unit
	return null
