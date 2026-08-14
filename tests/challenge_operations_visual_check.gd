extends SceneTree

const ChallengeCatalogScript = preload("res://scripts/challenge_catalog.gd")
const MAP_OUTPUT := "res://.tools/challenge-map-entry-visual.png"
const OUTPUT := "res://.tools/challenge-operations-visual.png"

func _init() -> void:
	call_deferred("_render")

func _render() -> void:
	root.size = Vector2i(1280, 720)
	var scene: PackedScene = load("res://main.tscn")
	var game = scene.instantiate()
	root.add_child(game)
	await process_frame
	game._open_mission_select()
	await process_frame
	await process_frame
	await _save_frame(MAP_OUTPUT)
	game._open_challenge_operations()
	var challenge := ChallengeCatalogScript.by_id("overclock_gauntlet")
	var now := int(Time.get_unix_time_from_system())
	challenge["cycle_id"] = "2026-W33"
	challenge["starts_unix"] = now - ChallengeCatalogScript.SECONDS_PER_DAY
	challenge["ends_unix"] = now + 4 * ChallengeCatalogScript.SECONDS_PER_DAY
	challenge["claim_id"] = "challenge:2026-W33:overclock_gauntlet"
	challenge["completed"] = false
	challenge["reward_available"] = true
	game.active_challenge = challenge
	game._refresh_challenge_operations()
	await _save_frame(OUTPUT)
	print("Challenge Operations visuals written to res://.tools/.")
	quit()

func _save_frame(path: String) -> void:
	await process_frame
	await process_frame
	await process_frame
	var image := root.get_viewport().get_texture().get_image()
	assert(not image.is_empty())
	assert(image.save_png(path) == OK)
