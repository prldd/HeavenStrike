class_name CampaignStore
extends RefCounted

const SAVE_PATH := "user://campaign.cfg"
const REWARD_UNITS := ["Chain Initiate", "LDF Medic"]

const MISSIONS := [
	{
		"id": 0,
		"title": "Broken Skyway",
		"briefing": "Repel a scouting crew from the abandoned eastern causeway.",
		"enemy_hp": 8,
		"encounters": [
			{"title": "Causeway Scouts", "enemy_hp": 8, "squad_offset": 0, "skill": "Aid"}
		],
		"reward": "Chain Initiate"
	},
	{
		"id": 1,
		"title": "The Iron Crossing",
		"briefing": "Break through a defensive formation guarding the weather route.",
		"enemy_hp": 11,
		"encounters": [
			{"title": "Outer Guard", "enemy_hp": 9, "squad_offset": 2, "skill": "Shield"},
			{"title": "Iron Captain", "enemy_hp": 11, "squad_offset": 4, "skill": "Bloodlust"}
		],
		"reward": "LDF Medic"
	},
	{
		"id": 2,
		"title": "Stormglass Reach",
		"briefing": "Survive long-range fire while a storm closes over the battlefield.",
		"enemy_hp": 14,
		"encounters": [
			{"title": "Stormglass Battery", "enemy_hp": 11, "squad_offset": 5, "skill": "Lightning Burst"},
			{"title": "Reach Commander", "enemy_hp": 14, "squad_offset": 7, "skill": "Healing Wave"}
		],
		"reward": "Stormglass Supply Cache"
	},
	{
		"id": 3,
		"title": "Siege of Aster",
		"briefing": "Defeat the expedition fleet before it anchors above Aster.",
		"enemy_hp": 17,
		"encounters": [
			{"title": "Vanguard Wing", "enemy_hp": 12, "squad_offset": 8, "skill": "Rally"},
			{"title": "Siege Deck", "enemy_hp": 14, "squad_offset": 10, "skill": "Firestorm"},
			{"title": "Aster Admiral", "enemy_hp": 17, "squad_offset": 12, "skill": "Last Stand"}
		],
		"reward": "Veteran Commander Crest"
	},
	{
		"id": 4,
		"title": "Heart of the Tempest",
		"briefing": "Take control of the ancient engine at the center of the storm.",
		"enemy_hp": 20,
		"encounters": [
			{"title": "Tempest Gate", "enemy_hp": 14, "squad_offset": 11, "skill": "Shield"},
			{"title": "Engine Wardens", "enemy_hp": 17, "squad_offset": 14, "skill": "Firestorm"},
			{"title": "Tempest Sovereign", "enemy_hp": 20, "squad_offset": 17, "skill": "Lightning Burst"}
		],
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
