class_name MissionRunStore
extends RefCounted

const SAVE_PATH := "user://mission_run.cfg"
const SAVE_VERSION := 2
const LEGACY_LEADER_HP_KEY := "cap" + "tain_hp"

static func save_run(mission_id: int, encounter_index: int, conductor_hp: int) -> bool:
	var config := ConfigFile.new()
	config.set_value("meta", "version", SAVE_VERSION)
	config.set_value("run", "mission_id", mission_id)
	config.set_value("run", "encounter_index", encounter_index)
	config.set_value("run", "conductor_hp", conductor_hp)
	return config.save(SAVE_PATH) == OK

static func load_run(mission_count: int) -> Dictionary:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return {}
	var mission_id: int = config.get_value("run", "mission_id", -1)
	var encounter_index: int = config.get_value("run", "encounter_index", -1)
	var legacy_hp: int = config.get_value("run", LEGACY_LEADER_HP_KEY, 0)
	var conductor_hp: int = config.get_value("run", "conductor_hp", legacy_hp)
	if mission_id < 0 or mission_id >= mission_count or encounter_index < 0 or conductor_hp <= 0:
		return {}
	if (
		not config.has_section_key("run", "conductor_hp")
		and config.has_section_key("run", LEGACY_LEADER_HP_KEY)
	):
		config.set_value("meta", "version", SAVE_VERSION)
		config.set_value("run", "conductor_hp", conductor_hp)
		config.erase_section_key("run", LEGACY_LEADER_HP_KEY)
		config.save(SAVE_PATH)
	return {
		"mission_id": mission_id,
		"encounter_index": encounter_index,
		"conductor_hp": conductor_hp
	}

static func clear_run() -> void:
	var config := ConfigFile.new()
	config.set_value("meta", "version", SAVE_VERSION)
	config.set_value("run", "mission_id", -1)
	config.set_value("run", "encounter_index", -1)
	config.set_value("run", "conductor_hp", 0)
	config.save(SAVE_PATH)
