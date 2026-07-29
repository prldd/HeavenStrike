class_name CampaignStore
extends RefCounted

const SAVE_PATH := "user://campaign.cfg"
const REWARD_UNITS := ["Dawnmender", "Mosscaller", "Aurora Sage"]

const MISSIONS := [
	{
		"id": 0,
		"title": "Broken Skyway",
		"briefing": "Repel a scouting crew from the abandoned eastern causeway.",
		"enemy_hp": 18,
		"enemy_energy": 2,
		"reward": "Dawnmender"
	},
	{
		"id": 1,
		"title": "The Iron Crossing",
		"briefing": "Break through a defensive formation guarding the weather route.",
		"enemy_hp": 22,
		"enemy_energy": 2,
		"reward": "Mosscaller"
	},
	{
		"id": 2,
		"title": "Stormglass Reach",
		"briefing": "Survive long-range fire while a storm closes over the battlefield.",
		"enemy_hp": 25,
		"enemy_energy": 3,
		"reward": "Aurora Sage"
	},
	{
		"id": 3,
		"title": "Siege of Aster",
		"briefing": "Defeat the expedition fleet before it anchors above Aster.",
		"enemy_hp": 29,
		"enemy_energy": 3,
		"reward": "Veteran Commander Crest"
	},
	{
		"id": 4,
		"title": "Heart of the Tempest",
		"briefing": "Take control of the ancient engine at the center of the storm.",
		"enemy_hp": 34,
		"enemy_energy": 4,
		"reward": "Campaign Complete"
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

static func unlocked_unit_names(roster: Array, completed: Array) -> Array:
	var unlocked: Array = []
	for unit in roster:
		if unit.name not in REWARD_UNITS:
			unlocked.append(unit.name)
	for mission_id in sanitize_completed(completed):
		var reward: String = MISSIONS[mission_id].reward
		if reward in REWARD_UNITS and reward not in unlocked:
			unlocked.append(reward)
	return unlocked

