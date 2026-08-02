class_name CampaignStore
extends RefCounted

const StoryQuestCatalogScript = preload("res://scripts/story_quest_catalog.gd")
const SquadStoreScript = preload("res://scripts/squad_store.gd")
const SAVE_PATH := "user://campaign.cfg"
const SAVE_VERSION := 1
const REWARD_UNITS := [
	"Chain Initiate", "LDF Medic",
	"Apprentice Builder", "Rage Brute", "Claw Skirmisher",
	"LDF Gunner", "Order Pupil", "Order Cleric",
	"Order Apostle", "Trinity Messenger", "Minerva the Brave",
	"Naruku the Lookout", "Whirling Ragnr",
	"Master Builder", "Rage Bruiser", "Claw Ambusher", "LDF Sureshot",
	"Order Scholar", "Order Chaplain", "Order Missionary", "Trinity Herald",
	"Minerva the Lionheart", "Farsight Naruku", "Macewielder Ragnr",
	"Talon Scratcher", "Talon Slasher", "Innocent Gretel",
	"Witchkiller Gretel", "Talon Slicer",
	"Street Urchin", "Street Hoodlum", "LDF Crowd Mage",
	"LDF Riot Mage", "Fortune Teller", "Fortune Diviner",
	"Street Nurse", "Street Matron", "Captain Kerryson", "Kerryson the Stoic",
	"Garrett Talon", "Garrett the Claw", "Precision Shooter", "Precision Sniper",
	"Greyson the Shifty", "LDF Flight Officer", "LDF Flight Commander",
	"Claw Chopper", "Claw Cleaver", "LDF Bowgunner", "LDF Bolt Slinger",
	"LDF Swordwielder", "LDF Greatsword",
	"Haven Trapper", "Haven Huntsman", "Macabre Embalmer", "Macabre Undertaker",
	"Devout Mage", "Devout Warlock",
	"Commune Defender", "Commune Captain",
	"LDF Constable", "LDF Sergeant", "Joe Wonder", "Pompous Joe Wonder",
	"Raging Dragon", "Blazing Dragon", "Royal Yeoman", "Royal Beefeater",
	"Pub Barman", "Pub Landlord", "The Archaeologist", "The Castaway",
	"The Botanist", "The Ecologist", "The Biologist",
	"Rescue Corps", "Rescue Paramedic", "Fabulous Bors", "Sir Bors",
	"Selina the Stylist", "Selina Twinblade",
	"The Witch Doctor", "The Earth Whisperer",
	"Hamish Highlander", "Hamish Lochmaster", "The Rook", "Sterling Knight",
	"Deep Sea Barney", "Bulkhead Barney", "Crewman Basilic", "Captain Basilic",
	"Oro the Pilgrim", "Oro the Enlightened", "Cara Pace", "Clawing Cara",
	"Clair", "Awoken Clair", "White Mage", "White Wizard",
	"Steph Lopod", "Steph the Tentacled", "Ant Lantis", "Swelling Ant",
	"Ki", "Hammering Ki", "Gawain the Just", "Sir Gawain",
	"Sakura", "Blossom Sakura", "Inti Chihuan", "Shining Inti",
	"Van Hohenheim", "The Sorcerer's Stone", "José", "José Decomposé",
	"Furia Rojo", "Campeon Rojo",
	"Sakuya (Fantail Pigeon)", "Sakuya Le Bel Shirogane",
	"Yuuya (Fantail Pigeon)", "Yuuya Sakazaki",
	"Claw Minstrel", "Claw Rocker", "Flame Warden", "Flame Dissident"
]

static var MISSIONS: Array = StoryQuestCatalogScript.build_missions()

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
	config.load(SAVE_PATH)
	config.set_value("meta", "version", SAVE_VERSION)
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
		if unit_name in valid_names:
			result.append(unit_name)
	return result

static func award_reward(unit_name: String, roster: Array, earned: Array) -> Array:
	var valid_names: Array = roster.map(func(unit): return unit.name)
	var result: Array = earned.duplicate()
	if unit_name in valid_names:
		result.append(unit_name)
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value("meta", "version", SAVE_VERSION)
	config.set_value("campaign", "reward_units", result)
	config.save(SAVE_PATH)
	return result

static func debug_grant_minimum_copies(
	roster: Array, earned: Array, active_counts: Dictionary, minimum_copies: int
) -> Array:
	var result: Array = earned.duplicate()
	var target := maxi(0, minimum_copies)
	for unit in roster:
		var missing := maxi(0, target - int(active_counts.get(unit.name, 0)))
		for copy in missing:
			result.append(unit.name)
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value("meta", "version", SAVE_VERSION)
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

static func inventory_counts(roster: Array, earned_rewards: Array) -> Dictionary:
	var counts := {}
	for unit in roster:
		counts[unit.name] = 0 if unit.name in REWARD_UNITS else 1
	for reward in earned_rewards:
		if counts.has(reward):
			counts[reward] += 1
	return counts

static func reward_summary(mission_id: int) -> String:
	if mission_id < 0 or mission_id >= MISSIONS.size():
		return "No card reward"
	var mission: Dictionary = MISSIONS[mission_id]
	if mission.reward_pool.is_empty():
		return "No implemented story card reward"
	return "Random: " + ", ".join(mission.reward_pool)

static func roll_reward(mission_id: int, roster: Array, roll: float = -1.0) -> String:
	if mission_id < 0 or mission_id >= MISSIONS.size():
		return ""
	var reward_names: Array = MISSIONS[mission_id].reward_pool
	var candidates: Array = roster.filter(func(unit): return unit.name in reward_names)
	return choose_weighted_reward(candidates, roll)

static func reward_options(mission_id: int, roster: Array) -> Array:
	if mission_id < 0 or mission_id >= MISSIONS.size():
		return []
	var reward_names: Array = MISSIONS[mission_id].reward_pool
	var candidates: Array = roster.filter(func(unit): return unit.name in reward_names)
	var total_weight := 0
	var weighted: Array = []
	for unit in candidates:
		var stars: int = clampi(unit.stars, 1, 6)
		var weight: int = 1 << (6 - stars)
		weighted.append({"unit": unit, "weight": weight})
		total_weight += weight
	var result: Array = []
	for option in weighted:
		result.append({
			"unit": option.unit,
			"chance": option.weight / float(total_weight)
		})
	return result

static func choose_weighted_reward(candidates: Array, roll: float = -1.0) -> String:
	if candidates.is_empty():
		return ""
	var total_weight := 0
	var weights: Array = []
	for unit in candidates:
		# One-arg get() reads both catalog Resources and plain Dictionary fixtures.
		var stars_value = unit.get("stars")
		var stars: int = clampi(stars_value if stars_value != null else 1, 1, 6)
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

static func enemy_squad_names(
	mission_id: int, encounter_index: int, roster: Array
) -> Array:
	var names: Array = []
	if roster.is_empty():
		return names
	var mission_encounter := encounter(mission_id, encounter_index)
	var configured: Array = mission_encounter.get("enemy_squad", [])
	var valid_names: Array = roster.map(func(unit): return unit.name)
	for unit_name in configured:
		if unit_name in valid_names and names.count(unit_name) < 2:
			names.append(unit_name)
		if names.size() >= SquadStoreScript.SQUAD_SIZE:
			break
	if not names.is_empty():
		return names
	return SquadStoreScript.default_squad(roster)

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
