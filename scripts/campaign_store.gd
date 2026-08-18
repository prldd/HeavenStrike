class_name CampaignStore
extends RefCounted

const StoryQuestCatalogScript = preload("res://scripts/story_quest_catalog.gd")
const SquadStoreScript = preload("res://scripts/squad_store.gd")
const UnitCatalogScript = preload("res://scripts/unit_catalog.gd")
const SAVE_PATH := "user://campaign.cfg"
const SAVE_VERSION := 1
const CAMPAIGN_EPILOGUE := StoryQuestCatalogScript.CAMPAIGN_EPILOGUE
const REWARD_UNITS := [
	"Relay Mender-006", "Relay Mender-012",
	"Relay Bastion-013", "Cinder Blade-015", "Cinder Lancer-017",
	"Flux Battery-019", "Relay Weaver-021", "Zephyr Mender-023",
	"Flux Lancer-025", "Helio Weaver-026", "Flux Mender-027",
	"Brass Weaver-028", "Relay Blade-029",
	"Relay Bastion-030", "Cinder Blade-036", "Zephyr Lancer-042",
	"Flux Weaver-047", "Helio Mender-048",
	"Relay Bastion-014", "Cinder Blade-016", "Cinder Lancer-018", "Flux Battery-020",
	"Relay Weaver-022", "Zephyr Mender-024", "Flux Lancer-031", "Helio Weaver-032",
	"Flux Mender-033", "Brass Weaver-034", "Relay Blade-035",
	"Zephyr Lancer-037", "Zephyr Lancer-038", "Zephyr Battery-039",
	"Zephyr Battery-040", "Zephyr Lancer-041",
	"Brass Lancer-043", "Brass Lancer-044", "Flux Weaver-045",
	"Flux Weaver-046", "Helio Weaver-055", "Helio Weaver-056",
	"Helio Mender-049", "Helio Mender-050", "Flux Bastion-053", "Flux Bastion-054",
	"Cinder Battery-063", "Cinder Battery-064", "Cinder Battery-066", "Cinder Battery-067",
	"Cinder Lancer-069", "Zephyr Blade-075", "Zephyr Blade-076",
	"Helio Blade-081", "Helio Blade-082", "Brass Battery-083", "Brass Battery-084",
	"Relay Blade-085", "Relay Blade-086",
	"Zephyr Battery-088", "Zephyr Battery-089", "Cinder Weaver-090", "Cinder Weaver-091",
	"Flux Weaver-092", "Flux Weaver-093",
	"Brass Bastion-104", "Brass Bastion-105",
	"Brass Bastion-111", "Brass Bastion-112", "Zephyr Bastion-113", "Zephyr Bastion-114",
	"Cinder Weaver-115", "Cinder Weaver-116", "Brass Blade-117", "Brass Blade-118",
	"Cinder Bastion-119", "Cinder Bastion-120", "Relay Blade-121", "Relay Blade-122",
	"Helio Mender-123", "Helio Mender-124", "Helio Mender-125",
	"Helio Mender-126", "Helio Mender-127", "Helio Bastion-128", "Helio Bastion-129",
	"Helio Lancer-130", "Helio Lancer-131",
	"Helio Mender-132", "Helio Mender-133",
	"Helio Bastion-134", "Helio Bastion-135", "Brass Bastion-136", "Brass Bastion-137",
	"Brass Bastion-138", "Brass Bastion-139", "Flux Battery-140", "Flux Battery-141",
	"Helio Mender-142", "Helio Mender-143", "Zephyr Lancer-144", "Zephyr Lancer-145",
	"Relay Blade-146", "Relay Blade-147", "Cinder Mender-148", "Cinder Mender-149",
	"Zephyr Weaver-150", "Zephyr Weaver-151", "Zephyr Bastion-152", "Zephyr Bastion-153",
	"Flux Bastion-154", "Flux Bastion-155", "Relay Blade-156", "Relay Blade-157",
	"Brass Weaver-158", "Brass Weaver-159", "Helio Mender-160", "Helio Mender-161",
	"Helio Mender-162", "Helio Mender-163", "Relay Blade-164", "Relay Blade-165",
	"Cinder Bastion-166", "Cinder Bastion-167",
	"Zephyr Weaver-168", "Zephyr Weaver-169",
	"Cinder Battery-170", "Cinder Battery-171",
	"Zephyr Mender-208", "Zephyr Mender-209", "Cinder Mender-213", "Cinder Mender-214",
	"Relay Battery-217", "Relay Battery-218", "Cinder Bastion-219", "Cinder Bastion-220",
	"Zephyr Lancer-221", "Zephyr Lancer-222", "Helio Mender-223", "Helio Mender-224",
	"Cinder Blade-225", "Flux Weaver-226", "Brass Battery-227", "Helio Bastion-228",
	"Cinder Bastion-229", "Zephyr Lancer-230", "Flux Weaver-231", "Helio Battery-232",
	"Brass Mender-233", "Zephyr Blade-234", "Cinder Lancer-235", "Helio Mender-236",
	"Cinder Bastion-237", "Cinder Mender-238", "Cinder Weaver-239", "Brass Battery-240",
	"Brass Blade-241", "Brass Lancer-242", "Zephyr Lancer-243", "Zephyr Mender-244",
	"Zephyr Blade-245", "Flux Weaver-246", "Flux Battery-247", "Flux Lancer-248",
	"Helio Bastion-249", "Helio Weaver-250", "Helio Mender-251",
	"Cinder Blade-252", "Brass Blade-253", "Cinder Lancer-254", "Brass Battery-255",
	"Flux Lancer-256", "Flux Weaver-257", "Cinder Weaver-258", "Zephyr Lancer-259",
	"Brass Bastion-260", "Cinder Bastion-261", "Helio Bastion-262", "Flux Weaver-263",
	"Cinder Weaver-264", "Cinder Weaver-265", "Flux Weaver-266", "Brass Lancer-267",
	"Helio Mender-268", "Zephyr Mender-269", "Brass Blade-270", "Flux Lancer-271",
	"Flux Weaver-272", "Helio Weaver-273", "Brass Mender-274", "Zephyr Weaver-275",
	"Cinder Battery-276", "Brass Battery-277", "Cinder Blade-278", "Helio Mender-279",
	"Helio Mender-280", "Cinder Weaver-281", "Cinder Battery-282", "Zephyr Lancer-283",
	"Zephyr Lancer-284", "Zephyr Weaver-285", "Cinder Bastion-286", "Flux Battery-287",
	"Helio Weaver-288", "Helio Bastion-289", "Brass Bastion-290", "Zephyr Blade-291",
	"Flux Weaver-292", "Cinder Mender-293"
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
	for saved_name in saved:
		var unit_name := UnitCatalogScript.canonical_name(str(saved_name))
		if unit_name in valid_names:
			result.append(unit_name)
	if result != saved:
		config.set_value("meta", "version", SAVE_VERSION)
		config.set_value("campaign", "reward_units", result)
		config.save(SAVE_PATH)
	return result

static func award_reward(unit_name: String, roster: Array, earned: Array) -> Array:
	return award_rewards([unit_name], roster, earned)

static func award_rewards(unit_names: Array, roster: Array, earned: Array) -> Array:
	var valid_names: Array = roster.map(func(unit): return unit.name)
	var result: Array = earned.duplicate()
	for unit_name in unit_names:
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
		if unit.stars == 1:
			unlocked.append(unit.name)
	for reward in earned_rewards:
		if UnitCatalogScript.by_name(reward) != null and reward not in unlocked:
			unlocked.append(reward)
	return unlocked

static func inventory_counts(roster: Array, earned_rewards: Array) -> Dictionary:
	var counts := {}
	for unit in roster:
		counts[unit.name] = 1 if unit.stars == 1 else 0
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
