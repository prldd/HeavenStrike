class_name BattleRules
extends RefCounted

const PLAYER := 0
const ROWS := 3
const COLS := 7

static func is_taunted(unit: Dictionary, units: Array) -> bool:
	var source_id: int = unit.get("taunted_by", -1)
	if source_id < 0:
		return false
	var source = _unit_by_id(units, source_id)
	return source != null and source.side != unit.side and source.kind == "Warden"

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

static func traversal_cells(unit: Dictionary, units: Array) -> Array:
	var cells: Array = []
	var direction := 1 if unit.side == PLAYER else -1
	var final_col := COLS - 2 if unit.side == PLAYER else 1
	for step in range(1, unit.move + 1):
		var col: int = unit.col + direction * step
		if (direction > 0 and col > final_col) or (direction < 0 and col < final_col):
			break
		if _occupied(units, unit.row, col):
			break
		cells.append(Vector2i(col, unit.row))
	return cells

static func projected_action(unit_id: int, units: Array) -> Dictionary:
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
		var path := traversal_cells(actor, projected_units)
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

static func locked_mana(units: Array, side: int) -> int:
	var locked := 0
	for unit in units:
		if unit.side == side:
			locked += unit.get("cost", 0)
	return locked

static func available_mana(capacity: int, units: Array, side: int) -> int:
	return maxi(0, capacity - locked_mana(units, side))

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
