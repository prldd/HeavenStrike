class_name TutorialStore
extends RefCounted

const SAVE_PATH := "user://player.cfg"
const SECTION := "tutorial"
const COMPLETED_KEY := "completed"

static func is_completed() -> bool:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return false
	return bool(config.get_value(SECTION, COMPLETED_KEY, false))

static func mark_completed() -> bool:
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value(SECTION, COMPLETED_KEY, true)
	return config.save(SAVE_PATH) == OK
