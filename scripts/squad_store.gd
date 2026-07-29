class_name SquadStore
extends RefCounted

const SQUAD_SIZE := 15
const SAVE_PATH := "user://player.cfg"

static func default_squad(roster: Array) -> Array:
	var names: Array = []
	for unit in roster:
		if names.size() >= SQUAD_SIZE:
			break
		names.append(unit.name)
	return names

static func sanitize(candidate_names: Array, roster: Array) -> Array:
	var valid_names: Array = roster.map(func(unit): return unit.name)
	var result: Array = []
	for unit_name in candidate_names:
		if unit_name in valid_names and unit_name not in result:
			result.append(unit_name)
		if result.size() >= SQUAD_SIZE:
			return result
	for unit_name in valid_names:
		if unit_name not in result:
			result.append(unit_name)
		if result.size() >= SQUAD_SIZE:
			break
	return result

static func load_squad(roster: Array) -> Array:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return default_squad(roster)
	var saved = config.get_value("squad", "units", [])
	if saved is not Array:
		return default_squad(roster)
	return sanitize(saved, roster)

static func save_squad(names: Array, roster: Array) -> bool:
	var clean := sanitize(names, roster)
	if clean.size() != SQUAD_SIZE:
		return false
	var config := ConfigFile.new()
	config.set_value("squad", "units", clean)
	return config.save(SAVE_PATH) == OK

static func build_deck(names: Array, roster: Array) -> Array:
	var deck: Array = []
	for unit_name in sanitize(names, roster):
		for unit in roster:
			if unit.name == unit_name:
				deck.append(unit.duplicate(true))
				break
	return deck
