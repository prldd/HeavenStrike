class_name MissionRunStore
extends RefCounted

const SAVE_PATH := "user://mission_run.cfg"
const SAVE_VERSION := 1

static func save_run(mission_id: int, encounter_index: int, captain_hp: int) -> bool:
	var config := ConfigFile.new()
	config.set_value("meta", "version", SAVE_VERSION)
	config.set_value("run", "mission_id", mission_id)
	config.set_value("run", "encounter_index", encounter_index)
	config.set_value("run", "captain_hp", captain_hp)
	return config.save(SAVE_PATH) == OK

static func load_run(mission_count: int) -> Dictionary:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return {}
	var mission_id: int = config.get_value("run", "mission_id", -1)
	var encounter_index: int = config.get_value("run", "encounter_index", -1)
	var captain_hp: int = config.get_value("run", "captain_hp", 0)
	if mission_id < 0 or mission_id >= mission_count or encounter_index < 0 or captain_hp <= 0:
		return {}
	return {
		"mission_id": mission_id,
		"encounter_index": encounter_index,
		"captain_hp": captain_hp
	}

static func clear_run() -> void:
	var config := ConfigFile.new()
	config.set_value("meta", "version", SAVE_VERSION)
	config.set_value("run", "mission_id", -1)
	config.set_value("run", "encounter_index", -1)
	config.set_value("run", "captain_hp", 0)
	config.save(SAVE_PATH)
