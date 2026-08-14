class_name SquadStore
extends RefCounted

const UnitCatalogScript = preload("res://scripts/unit_catalog.gd")
const SQUAD_SIZE := 8
const SAVE_PATH := "user://player.cfg"
const SAVE_VERSION := 4
const DEFAULT_CONDUCTOR_SKILL := "Rally"
const DEFAULT_SQUAD_NAME := "Squad 1"
const MAX_SQUAD_NAME_LENGTH := 24
const LEGACY_LEADER_SKILL_KEY := "cap" + "tain_skill"

static func default_squad(roster: Array) -> Array:
	var names: Array = []
	for unit in roster:
		if unit.stars != 1:
			continue
		if names.size() >= SQUAD_SIZE:
			break
		names.append(unit.name)
	# Pure-data fixtures and custom rosters may not define enough 1-star units.
	for unit in roster:
		if names.size() >= SQUAD_SIZE:
			break
		if unit.name not in names:
			names.append(unit.name)
	return names

static func sanitize(candidate_names: Array, roster: Array) -> Array:
	var valid_names: Array = roster.map(func(unit): return unit.name)
	var result: Array = []
	for saved_name in candidate_names:
		var unit_name := UnitCatalogScript.canonical_name(str(saved_name))
		if unit_name in valid_names and result.count(unit_name) < 2:
			result.append(unit_name)
		if result.size() >= SQUAD_SIZE:
			return result
	return result if not result.is_empty() else default_squad(roster)

static func sanitize_owned(candidate_names: Array, roster: Array, inventory: Dictionary) -> Array:
	var valid_names: Array = roster.map(func(unit): return unit.name)
	var result: Array = []
	for saved_name in candidate_names:
		var unit_name := UnitCatalogScript.canonical_name(str(saved_name))
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
	var migrated := sanitize(saved, roster)
	if migrated != saved:
		config.set_value("meta", "version", SAVE_VERSION)
		config.set_value("squad", "units", migrated)
		config.save(SAVE_PATH)
	return migrated

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

## Loads the named-squad collection. Older single-formation saves migrate into
## one named squad without changing its unit order or Conductor skill.
static func load_named_squads(
	roster: Array, instances: Array, valid_skills: Array
) -> Dictionary:
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	var saved_entries = config.get_value("squads", "entries", [])
	var entries: Array = []
	if saved_entries is Array:
		for saved_value in saved_entries:
			if saved_value is not Dictionary:
				continue
			var saved: Dictionary = saved_value
			var squad_id := str(saved.get("id", "")).strip_edges()
			if squad_id.is_empty() or entries.any(func(entry): return entry.id == squad_id):
				squad_id = next_named_squad_id(entries)
			var fallback_name := "Squad %d" % (entries.size() + 1)
			entries.append({
				"id": squad_id,
				"name": unique_squad_name(
					sanitize_squad_name(saved.get("name", ""), fallback_name), entries
				),
				"instance_ids": sanitize_instances(
					saved.get("instance_ids", []), instances
				),
				"conductor_skill": (
					saved.get("conductor_skill", DEFAULT_CONDUCTOR_SKILL)
					if saved.get("conductor_skill", DEFAULT_CONDUCTOR_SKILL) in valid_skills
					else DEFAULT_CONDUCTOR_SKILL
				)
			})
	if entries.is_empty():
		entries.append({
			"id": "squad_001",
			"name": DEFAULT_SQUAD_NAME,
			"instance_ids": load_instance_squad(roster, instances),
			"conductor_skill": load_conductor_skill(valid_skills)
		})
	var active_id := str(config.get_value("squads", "active_id", ""))
	if not entries.any(func(entry): return entry.id == active_id):
		active_id = entries[0].id
	var state := {"active_id": active_id, "squads": entries}
	save_named_squads(entries, active_id, instances, valid_skills)
	return state

static func save_named_squads(
	entries: Array, active_id: String, instances: Array, valid_skills: Array
) -> bool:
	if entries.is_empty():
		return false
	var clean_entries: Array = []
	for entry_value in entries:
		if entry_value is not Dictionary:
			continue
		var entry: Dictionary = entry_value
		var squad_id := str(entry.get("id", "")).strip_edges()
		if squad_id.is_empty() or clean_entries.any(func(saved): return saved.id == squad_id):
			squad_id = next_named_squad_id(clean_entries)
		var fallback_name := "Squad %d" % (clean_entries.size() + 1)
		var skill_name: String = entry.get("conductor_skill", DEFAULT_CONDUCTOR_SKILL)
		clean_entries.append({
			"id": squad_id,
			"name": unique_squad_name(
				sanitize_squad_name(entry.get("name", ""), fallback_name), clean_entries
			),
			"instance_ids": sanitize_instances(entry.get("instance_ids", []), instances),
			"conductor_skill": (
				skill_name if skill_name in valid_skills else DEFAULT_CONDUCTOR_SKILL
			)
		})
	if clean_entries.is_empty():
		return false
	var clean_active_id := active_id
	if not clean_entries.any(func(entry): return entry.id == clean_active_id):
		clean_active_id = clean_entries[0].id
	var active: Dictionary = clean_entries.filter(
		func(entry): return entry.id == clean_active_id
	)[0]
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value("meta", "version", SAVE_VERSION)
	config.set_value("squads", "active_id", clean_active_id)
	config.set_value("squads", "entries", clean_entries)
	# Keep the version-three keys synchronized for older builds and utilities.
	config.set_value("squad", "instance_ids", active.instance_ids)
	config.set_value("squad", "units", instance_names(active.instance_ids, instances))
	config.set_value("squad", "conductor_skill", active.conductor_skill)
	return config.save(SAVE_PATH) == OK

static func sanitize_squad_name(value: Variant, fallback: String = DEFAULT_SQUAD_NAME) -> String:
	var clean := str(value).replace("\n", " ").replace("\r", " ").replace("\t", " ")
	clean = clean.strip_edges().left(MAX_SQUAD_NAME_LENGTH).strip_edges()
	return clean if not clean.is_empty() else fallback

static func unique_squad_name(
	requested: String, entries: Array, excluded_id: String = ""
) -> String:
	var base := sanitize_squad_name(requested)
	var candidate := base
	var suffix := 2
	var used_names: Array = entries.filter(
		func(entry): return str(entry.get("id", "")) != excluded_id
	).map(func(entry): return str(entry.get("name", "")).to_lower())
	while candidate.to_lower() in used_names:
		var suffix_text := " (%d)" % suffix
		candidate = base.left(MAX_SQUAD_NAME_LENGTH - suffix_text.length()) + suffix_text
		suffix += 1
	return candidate

static func next_named_squad_id(entries: Array) -> String:
	var next_number := 1
	while entries.any(func(entry): return entry.get("id", "") == "squad_%03d" % next_number):
		next_number += 1
	return "squad_%03d" % next_number

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

static func load_conductor_skill(valid_skills: Array) -> String:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return DEFAULT_CONDUCTOR_SKILL
	var legacy_saved = config.get_value("squad", LEGACY_LEADER_SKILL_KEY, DEFAULT_CONDUCTOR_SKILL)
	var saved: String = config.get_value("squad", "conductor_skill", legacy_saved)
	if (
		not config.has_section_key("squad", "conductor_skill")
		and config.has_section_key("squad", LEGACY_LEADER_SKILL_KEY)
	):
		config.set_value("meta", "version", SAVE_VERSION)
		config.set_value("squad", "conductor_skill", saved)
		config.erase_section_key("squad", LEGACY_LEADER_SKILL_KEY)
		config.save(SAVE_PATH)
	return saved if saved in valid_skills else DEFAULT_CONDUCTOR_SKILL

static func save_conductor_skill(skill_name: String, valid_skills: Array) -> bool:
	if skill_name not in valid_skills:
		return false
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value("meta", "version", SAVE_VERSION)
	config.set_value("squad", "conductor_skill", skill_name)
	if config.has_section_key("squad", LEGACY_LEADER_SKILL_KEY):
		config.erase_section_key("squad", LEGACY_LEADER_SKILL_KEY)
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
