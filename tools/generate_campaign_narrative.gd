extends SceneTree

# Regenerates documentation/Campaign_Narrative_Script.md from the authored
# campaign narrative data so the consolidated reading copy never drifts from
# the game. Run headless:
#   ./tools/godot-headless.sh --script res://tools/generate_campaign_narrative.gd

const StoryQuestCatalogScript = preload("res://scripts/story_quest_catalog.gd")
const StoryDialogueCatalogScript = preload("res://scripts/story_dialogue_catalog.gd")

const OUTPUT_PATH := "res://documentation/Campaign_Narrative_Script.md"


func _init() -> void:
	var lines: Array[String] = []
	_append_header(lines)
	_append_cast(lines)
	_append_prologue(lines)
	_append_missions(lines)
	_append_epilogue(lines)

	var file := FileAccess.open(OUTPUT_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Could not open %s for writing (error %d)." % [OUTPUT_PATH, FileAccess.get_open_error()])
		quit(1)
		return
	file.store_string("\n".join(lines) + "\n")
	file.close()
	print("Wrote %d lines to %s" % [lines.size(), OUTPUT_PATH])
	quit()


func _append_header(lines: Array[String]) -> void:
	lines.append_array([
		"# War of Resonance — Campaign Narrative Script",
		"",
		"This is a consolidated, human-readable dump of every piece of authored narrative",
		"text in the campaign, for review and revision outside the game code.",
		"",
		"**This file is generated. Do not edit it directly.** Run:",
		"",
		"```bash",
		"./tools/godot-headless.sh --script res://tools/generate_campaign_narrative.gd",
		"```",
		"",
		"**Sources (edit these):**",
		"",
		"- `scripts/story_quest_catalog.gd` — `QUESTS` (mission titles), `MISSION_STORIES`",
		"  (chapter, briefing, debriefing), `ENCOUNTER_RULES` (special objective text),",
		"  `CAMPAIGN_PROLOGUE` (first-open orientation), `CHAPTER_CARDS` (per-chapter",
		"  intro briefings), `CAMPAIGN_EPILOGUE`.",
		"- `scripts/story_dialogue_catalog.gd` — `CHARACTERS` (cast), `PRELUDES` (scenes",
		"  shown once before a mission unlocks), and `INTERLUDES` (post-mission dialogue",
		"  scenes, keyed by 1-based mission number).",
		"",
		"Voice and structure rules live in `documentation/Narrative_Style_Guide.md`.",
		"",
		"Per mission: **Briefing** is the pre-battle description (the player's frame, the",
		"practical problem), **Objective** is the authored special win condition when one",
		"exists, **Debriefing** is the post-victory messaging (Cassian's frame, the",
		"political consequence), and **Interlude** is the post-mission dialogue scene.",
		"",
		"---",
		""
	])


func _append_cast(lines: Array[String]) -> void:
	lines.append_array([
		"## Cast",
		"",
		"| Speaker | Role |",
		"|---------|------|"
	])
	for speaker in StoryDialogueCatalogScript.CHARACTERS:
		var details: Dictionary = StoryDialogueCatalogScript.CHARACTERS[speaker]
		lines.append("| %s | %s |" % [speaker, details.get("role", "")])
	lines.append_array(["", "---", ""])


func _append_prologue(lines: Array[String]) -> void:
	lines.append_array([
		"## Campaign Prologue",
		"",
		"*Shown the first time the operations map opens (replayable via WORLD BRIEF).*",
		""
	])
	for prologue_line in StoryQuestCatalogScript.CAMPAIGN_PROLOGUE.split("\n"):
		lines.append(prologue_line)
	lines.append_array(["", "---", ""])


func _append_missions(lines: Array[String]) -> void:
	var quests: Array = StoryQuestCatalogScript.QUESTS
	var stories: Dictionary = StoryQuestCatalogScript.MISSION_STORIES
	var rules: Dictionary = StoryQuestCatalogScript.ENCOUNTER_RULES
	var interludes: Dictionary = StoryDialogueCatalogScript.INTERLUDES
	var preludes: Dictionary = StoryDialogueCatalogScript.PRELUDES

	var last_act := ""
	var last_chapter := ""
	var chapter_number := 0

	for index in quests.size():
		var mission_number := index + 1
		var raw_title := String(quests[index][0])
		# Titles are authored as "Act N Mission M - Name".
		var act := "Act " + raw_title.get_slice(" ", 1)
		var name := raw_title.get_slice(" - ", 1) if " - " in raw_title else raw_title

		if act != last_act:
			lines.append_array(["# %s" % act, ""])
			last_act = act
			last_chapter = ""

		var story: Dictionary = stories.get(mission_number, {})
		var chapter := String(story.get("chapter", ""))
		if chapter != last_chapter:
			chapter_number += 1
			lines.append_array(["## Chapter %d — %s" % [chapter_number, chapter], ""])
			var card_text := String(
				StoryQuestCatalogScript.CHAPTER_CARDS.get(chapter, {}).get("text", "")
			)
			if not card_text.is_empty():
				lines.append("*Chapter briefing (shown once when the chapter unlocks):*")
				lines.append("")
				for card_line in card_text.split("\n"):
					lines.append(card_line)
				lines.append("")
			last_chapter = chapter

		lines.append_array(["### Mission %d — %s" % [mission_number, name], ""])

		if preludes.has(mission_number):
			var prelude: Dictionary = preludes[mission_number]
			lines.append_array([
				"",
				"**Prelude — \"%s\"** *(%s, shown once before the mission unlocks)*" % [
					prelude.get("title", ""), prelude.get("location", "")
				],
				""
			])
			for line in prelude.get("lines", []):
				lines.append("- **%s:** %s" % [line.get("speaker", ""), line.get("text", "")])
			lines.append("")

		var briefing := String(story.get("briefing", ""))
		if briefing.is_empty():
			briefing = StoryQuestCatalogScript._mission_briefing(index, name)
		lines.append("- **Briefing:** %s" % briefing)

		var encounter := 0
		while rules.has("%d:%d" % [mission_number, encounter]):
			var rule: Dictionary = rules["%d:%d" % [mission_number, encounter]]
			var objective: Dictionary = rule.get("objective", {})
			if not objective.is_empty():
				var label := "**Objective"
				if encounter > 0:
					label += " (encounter %d)" % (encounter + 1)
				label += " — %s:** %s" % [
					objective.get("title", ""), objective.get("description", "")
				]
				lines.append("- %s" % label)
			encounter += 1

		var debriefing := String(story.get("debriefing", ""))
		if debriefing.is_empty():
			debriefing = StoryQuestCatalogScript._mission_debriefing(index, name)
		lines.append("- **Debriefing:** %s" % debriefing)

		if interludes.has(mission_number):
			var scene: Dictionary = interludes[mission_number]
			lines.append_array([
				"",
				"**Interlude — \"%s\"** *(%s)*" % [scene.get("title", ""), scene.get("location", "")],
				""
			])
			for line in scene.get("lines", []):
				lines.append("- **%s:** %s" % [line.get("speaker", ""), line.get("text", "")])

		lines.append("")


func _append_epilogue(lines: Array[String]) -> void:
	lines.append_array([
		"---",
		"",
		"## Campaign Epilogue",
		"",
		"*Shown on completing the final mission.*",
		""
	])
	for epilogue_line in StoryQuestCatalogScript.CAMPAIGN_EPILOGUE.split("\n"):
		lines.append(epilogue_line)
