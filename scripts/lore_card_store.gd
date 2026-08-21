class_name LoreCardStore
extends RefCounted

## Presentation-only campaign lore progress: whether the player has seen the
## prologue orientation and each chapter's intro card. Stored in the "lore"
## section of user://player.cfg so it follows the same profile as battle
## settings and the tutorial flag.

const SAVE_PATH := "user://player.cfg"
const SECTION := "lore"
const PROLOGUE_KEY := "prologue_seen"
const CHAPTERS_KEY := "chapters_seen"
const PRELUDES_KEY := "preludes_seen"

static func prologue_seen() -> bool:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return false
	return bool(config.get_value(SECTION, PROLOGUE_KEY, false))

static func mark_prologue_seen() -> bool:
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value(SECTION, PROLOGUE_KEY, true)
	return config.save(SAVE_PATH) == OK

static func chapter_seen(chapter: String) -> bool:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return false
	return chapter in Array(config.get_value(SECTION, CHAPTERS_KEY, PackedStringArray()))

static func mark_chapter_seen(chapter: String) -> bool:
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	var seen: Array = Array(config.get_value(SECTION, CHAPTERS_KEY, PackedStringArray()))
	if chapter not in seen:
		seen.append(chapter)
		config.set_value(SECTION, CHAPTERS_KEY, PackedStringArray(seen))
	return config.save(SAVE_PATH) == OK

static func prelude_seen(mission_number: int) -> bool:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return false
	var seen: Array = Array(config.get_value(SECTION, PRELUDES_KEY, PackedStringArray()))
	return str(mission_number) in seen

static func mark_prelude_seen(mission_number: int) -> bool:
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	var seen: Array = Array(config.get_value(SECTION, PRELUDES_KEY, PackedStringArray()))
	if str(mission_number) not in seen:
		seen.append(str(mission_number))
		config.set_value(SECTION, PRELUDES_KEY, PackedStringArray(seen))
	return config.save(SAVE_PATH) == OK
