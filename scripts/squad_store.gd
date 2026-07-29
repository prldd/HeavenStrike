class_name SquadStore
extends RefCounted

const SQUAD_SIZE := 15
const SAVE_PATH := "user://player.cfg"
const DEFAULT_CAPTAIN_SKILL := "Rally"

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
		if unit_name in valid_names and result.count(unit_name) < 2:
			result.append(unit_name)
		if result.size() >= SQUAD_SIZE:
			return result
	return result if not result.is_empty() else default_squad(roster)

static func sanitize_owned(candidate_names: Array, roster: Array, inventory: Dictionary) -> Array:
	var valid_names: Array = roster.map(func(unit): return unit.name)
	var result: Array = []
	for unit_name in candidate_names:
		var owned: int = inventory.get(unit_name, 0)
		if unit_name in valid_names and result.count(unit_name) < mini(2, owned):
			result.append(unit_name)
		if result.size() >= SQUAD_SIZE:
			return result
	if not result.is_empty():
		return result
	for unit in roster:
		var available: int = mini(2, inventory.get(unit.name, 0))
		for copy in available:
			result.append(unit.name)
			if result.size() >= SQUAD_SIZE:
				return result
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
	if clean.is_empty() or clean.size() > SQUAD_SIZE:
		return false
	var config := ConfigFile.new()
	config.set_value("squad", "units", clean)
	return config.save(SAVE_PATH) == OK

static func load_captain_skill(valid_skills: Array) -> String:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return DEFAULT_CAPTAIN_SKILL
	var saved: String = config.get_value("squad", "captain_skill", DEFAULT_CAPTAIN_SKILL)
	return saved if saved in valid_skills else DEFAULT_CAPTAIN_SKILL

static func save_captain_skill(skill_name: String, valid_skills: Array) -> bool:
	if skill_name not in valid_skills:
		return false
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value("squad", "captain_skill", skill_name)
	return config.save(SAVE_PATH) == OK

static func build_deck(names: Array, roster: Array) -> Array:
	var deck: Array = []
	for unit_name in sanitize(names, roster):
		for unit in roster:
			if unit.name == unit_name:
				deck.append(unit.duplicate(true))
				break
	return deck
