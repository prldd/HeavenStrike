class_name BattleSettings
extends RefCounted

const SAVE_PATH := "user://player.cfg"
const SAVE_VERSION := 1

static func load_settings() -> Dictionary:
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	return {
		"speed": clampf(float(config.get_value("battle", "speed", 1.0)), 1.0, 4.0),
		"volume": clampi(int(config.get_value("battle", "volume", 2)), 0, 2),
		"reduced_motion": bool(config.get_value("battle", "reduced_motion", false)),
		"skip_animations": bool(config.get_value("battle", "skip_animations", false))
	}

static func save_settings(settings: Dictionary) -> bool:
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value("meta", "version", SAVE_VERSION)
	config.set_value("battle", "speed", settings.get("speed", 1.0))
	config.set_value("battle", "volume", settings.get("volume", 2))
	config.set_value("battle", "reduced_motion", settings.get("reduced_motion", false))
	config.set_value("battle", "skip_animations", settings.get("skip_animations", false))
	return config.save(SAVE_PATH) == OK
