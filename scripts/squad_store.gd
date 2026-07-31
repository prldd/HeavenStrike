class_name SquadStore
extends RefCounted

const SQUAD_SIZE := 8
const SAVE_PATH := "user://player.cfg"
const SAVE_VERSION := 2
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
	config.load(SAVE_PATH)
	config.set_value("meta", "version", SAVE_VERSION)
	config.set_value("squad", "units", clean)
	return config.save(SAVE_PATH) == OK

static func load_instance_squad(roster: Array, instances: Array) -> Array:
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	var saved = config.get_value("squad", "instance_ids", [])
	if saved is Array and not saved.is_empty():
		return sanitize_instances(saved, instances)
	# Migrate the previous name-based formation by assigning distinct active copies.
	var legacy_names := load_squad(roster)
	var migrated: Array = []
	for unit_name in legacy_names:
		for instance in instances:
			if (
				instance.name == unit_name and not instance.get("consumed", false)
				and instance.id not in migrated
			):
				migrated.append(instance.id)
				break
	return sanitize_instances(migrated, instances)

static func save_instance_squad(instance_ids: Array, instances: Array) -> bool:
	var clean := sanitize_instances(instance_ids, instances)
	if clean.is_empty() or clean.size() > SQUAD_SIZE:
		return false
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value("meta", "version", SAVE_VERSION)
	config.set_value("squad", "instance_ids", clean)
	config.set_value("squad", "units", instance_names(clean, instances))
	return config.save(SAVE_PATH) == OK

static func sanitize_instances(candidate_ids: Array, instances: Array) -> Array:
	var result: Array = []
	var names: Array = []
	for instance_id in candidate_ids:
		var instance := _instance_by_id(instances, str(instance_id))
		if instance.is_empty() or instance.get("consumed", false):
			continue
		if instance.id in result or names.count(instance.name) >= 2:
			continue
		result.append(instance.id)
		names.append(instance.name)
		if result.size() >= SQUAD_SIZE:
			return result
	if not result.is_empty():
		return result
	for instance in instances:
		if instance.get("consumed", false) or names.count(instance.name) >= 2:
			continue
		result.append(instance.id)
		names.append(instance.name)
		if result.size() >= SQUAD_SIZE:
			break
	return result

static func instance_names(instance_ids: Array, instances: Array) -> Array:
	var names: Array = []
	for instance_id in instance_ids:
		var instance := _instance_by_id(instances, str(instance_id))
		if not instance.is_empty():
			names.append(instance.name)
	return names

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
	config.set_value("meta", "version", SAVE_VERSION)
	config.set_value("squad", "captain_skill", skill_name)
	return config.save(SAVE_PATH) == OK

static func build_deck(names: Array, roster: Array, instances: Array = []) -> Array:
	var deck: Array = []
	var resolved_names := names
	var clean_ids: Array = []
	if not instances.is_empty():
		clean_ids = sanitize_instances(names, instances)
		resolved_names = instance_names(clean_ids, instances)
	for index in resolved_names.size():
		var unit_name = resolved_names[index]
		for unit in roster:
			if unit.name == unit_name:
				var card: Dictionary = unit.to_dict()
				if not instances.is_empty() and index < clean_ids.size():
					var instance := _instance_by_id(instances, str(clean_ids[index]))
					if not instance.is_empty():
						card.instance_id = instance.id
						card.level = instance.level
						card.level_points = instance.points
				deck.append(card)
				break
	return deck

static func _instance_by_id(instances: Array, instance_id: String) -> Dictionary:
	for instance in instances:
		if instance.id == instance_id:
			return instance
	return {}

static func shuffle_for_battle(deck: Array, rng: RandomNumberGenerator = null) -> Array:
	var shuffled := deck.duplicate(true)
	# The first squad slot is the Vanguard and must remain the opening card.
	# Every reserve card after it is randomized once for each battle.
	for index in range(shuffled.size() - 1, 1, -1):
		var swap_index: int = (
			rng.randi_range(1, index) if rng != null else randi_range(1, index)
		)
		var card = shuffled[index]
		shuffled[index] = shuffled[swap_index]
		shuffled[swap_index] = card
	return shuffled
