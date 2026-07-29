class_name CampaignStore
extends RefCounted

const SAVE_PATH := "user://campaign.cfg"
const REWARD_UNITS := ["Chain Initiate", "LDF Medic"]

const MISSIONS := [
	{
		"id": 0,
		"title": "Act 1 Mission 1 - Training Day",
		"briefing": "Complete the first field exercise against Trinity forces.",
		"enemy_hp": 8,
		"encounters": [
			{"title": "Training Day", "enemy_hp": 8, "squad_offset": 0, "skill": "Aid"}
		],
		"reward_pool": ["Trinity Rusher", "Trinity Potshot"]
	},
	{
		"id": 1,
		"title": "Act 1 Mission 2 - Training Day (2)",
		"briefing": "Return to the training field against a mixed support squad.",
		"enemy_hp": 11,
		"encounters": [
			{"title": "Field Exercise", "enemy_hp": 9, "squad_offset": 2, "skill": "Shield"},
			{"title": "Training Captain", "enemy_hp": 11, "squad_offset": 4, "skill": "Bloodlust"}
		],
		"reward_pool": ["Chain Initiate", "Rage Spellslinger"]
	},
	{
		"id": 2,
		"title": "Act 1 Mission 8 - Scrap Merchants",
		"briefing": "Drive the Claw raiders away from the disputed salvage field.",
		"enemy_hp": 14,
		"encounters": [
			{"title": "Salvage Crew", "enemy_hp": 11, "squad_offset": 5, "skill": "Lightning Burst"},
			{"title": "Scrap Merchants", "enemy_hp": 14, "squad_offset": 7, "skill": "Healing Wave"}
		],
		"reward_pool": ["Claw Caster", "Claw Slicer"]
	},
	{
		"id": 3,
		"title": "Act 1 Mission 10 - Class Dismissed",
		"briefing": "Break through a varied formation of early frontline units.",
		"enemy_hp": 17,
		"encounters": [
			{"title": "School Guard", "enemy_hp": 12, "squad_offset": 8, "skill": "Rally"},
			{"title": "Dismissal Bell", "enemy_hp": 14, "squad_offset": 10, "skill": "Firestorm"},
			{"title": "Class Dismissed", "enemy_hp": 17, "squad_offset": 12, "skill": "Last Stand"}
		],
		"reward_pool": ["Socialite Fencer", "Pub Bouncer", "Factory Markswoman"]
	},
	{
		"id": 4,
		"title": "Act 1 Mission 21 - Sanctuary: Outside",
		"briefing": "Secure the approach to Sanctuary against an LDF formation.",
		"enemy_hp": 20,
		"encounters": [
			{"title": "Sanctuary Approach", "enemy_hp": 14, "squad_offset": 11, "skill": "Shield"},
			{"title": "LDF Outer Guard", "enemy_hp": 17, "squad_offset": 14, "skill": "Firestorm"},
			{"title": "Sanctuary: Outside", "enemy_hp": 20, "squad_offset": 17, "skill": "Lightning Burst"}
		],
		"reward_pool": ["Chain Initiate", "LDF Peacekeeper", "LDF Medic"]
	}
]

static func load_completed() -> Array:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return []
	var saved = config.get_value("campaign", "completed", [])
	if saved is not Array:
		return []
	return sanitize_completed(saved)

static func sanitize_completed(candidate: Array) -> Array:
	var result: Array = []
	for mission_id in candidate:
		var id := int(mission_id)
		if id >= 0 and id < MISSIONS.size() and id not in result:
			result.append(id)
	result.sort()
	return result

static func complete_mission(mission_id: int, completed: Array) -> Array:
	var result := sanitize_completed(completed)
	if mission_id >= 0 and mission_id < MISSIONS.size() and mission_id not in result:
		result.append(mission_id)
		result.sort()
	var config := ConfigFile.new()
	config.set_value("campaign", "completed", result)
	config.save(SAVE_PATH)
	return result

static func is_available(mission_id: int, completed: Array) -> bool:
	return mission_id == 0 or mission_id - 1 in completed

static func load_reward_units(roster: Array) -> Array:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return []
	var saved = config.get_value("campaign", "reward_units", [])
	if saved is not Array:
		return []
	var valid_names: Array = roster.map(func(unit): return unit.name)
	var result: Array = []
	for unit_name in saved:
		if unit_name in valid_names and unit_name not in result:
			result.append(unit_name)
	return result

static func award_reward(unit_name: String, roster: Array, earned: Array) -> Array:
	var valid_names: Array = roster.map(func(unit): return unit.name)
	var result: Array = earned.duplicate()
	if unit_name in valid_names and unit_name not in result:
		result.append(unit_name)
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value("campaign", "reward_units", result)
	config.save(SAVE_PATH)
	return result

static func unlocked_unit_names(roster: Array, earned_rewards: Array) -> Array:
	var unlocked: Array = []
	for unit in roster:
		if unit.name not in REWARD_UNITS:
			unlocked.append(unit.name)
	for reward in earned_rewards:
		if reward in REWARD_UNITS and reward not in unlocked:
			unlocked.append(reward)
	return unlocked

static func reward_summary(mission_id: int) -> String:
	if mission_id < 0 or mission_id >= MISSIONS.size():
		return "No card reward"
	return "Random: " + ", ".join(MISSIONS[mission_id].reward_pool)

static func roll_reward(mission_id: int, roster: Array, roll: float = -1.0) -> String:
	if mission_id < 0 or mission_id >= MISSIONS.size():
		return ""
	var reward_names: Array = MISSIONS[mission_id].reward_pool
	var candidates: Array = roster.filter(func(unit): return unit.name in reward_names)
	return choose_weighted_reward(candidates, roll)

static func choose_weighted_reward(candidates: Array, roll: float = -1.0) -> String:
	if candidates.is_empty():
		return ""
	var total_weight := 0
	var weights: Array = []
	for unit in candidates:
		var stars: int = clampi(unit.get("stars", 1), 1, 6)
		var weight: int = 1 << (6 - stars)
		weights.append(weight)
		total_weight += weight
	var random_roll := randf() if roll < 0.0 else clampf(roll, 0.0, 0.999999)
	var threshold := random_roll * total_weight
	var cumulative := 0
	for index in candidates.size():
		cumulative += weights[index]
		if threshold < cumulative:
			return candidates[index].name
	return candidates[-1].name

static func enemy_squad_names(mission_id: int, roster: Array) -> Array:
	var names: Array = []
	if roster.is_empty():
		return names
	var offset: int = maxi(0, mission_id) * 3
	for index in 15:
		var roster_index: int = (index + offset) % roster.size()
		var unit_name: String = roster[roster_index].name
		if names.count(unit_name) < 2:
			names.append(unit_name)
	return names

static func encounter(mission_id: int, encounter_index: int) -> Dictionary:
	if mission_id < 0 or mission_id >= MISSIONS.size():
		return {}
	var encounters: Array = MISSIONS[mission_id].encounters
	if encounter_index < 0 or encounter_index >= encounters.size():
		return {}
	return encounters[encounter_index]

static func encounter_count(mission_id: int) -> int:
	if mission_id < 0 or mission_id >= MISSIONS.size():
		return 0
	return MISSIONS[mission_id].encounters.size()
