extends SceneTree

const OUTPUT := "res://.tools/unit-requisition-visual.png"

func _init() -> void:
	call_deferred("_render")

func _render() -> void:
	root.size = Vector2i(1280, 720)
	var scene: PackedScene = load("res://main.tscn")
	var game = scene.instantiate()
	root.add_child(game)
	await process_frame
	game._open_gacha()
	game.gacha_pity = 17
	game.gacha_results = [
		_result("Relay Lancer-003", 1, false, 3),
		_result("Relay Bastion-013", 2, true, 1),
		_result("Zephyr Mender-209", 3, true, 1),
		_result("Flux Weaver-211", 4, false, 2),
		_result("Relay Blade-035", 5, true, 1),
		_result("Helio Mender-133", 6, true, 1),
		_result("Cinder Blade-015", 1, false, 4),
		_result("Zephyr Lancer-037", 2, false, 2),
		_result("Flux Weaver-045", 3, true, 1),
		_result("Cinder Mender-214", 4, true, 1)
	]
	game._rebuild_gacha_results()
	game._refresh_gacha_status()
	game.gacha_result_label.text = "10 UNITS ACQUIRED · 6 NEW · 4 DUPLICATES · 2 TOP-TIER"
	await process_frame
	await process_frame
	await process_frame
	var image := root.get_viewport().get_texture().get_image()
	assert(not image.is_empty())
	assert(image.save_png(OUTPUT) == OK)
	print("Unit requisition visual written to %s." % OUTPUT)
	quit()

func _result(name: String, stars: int, is_new: bool, copy_count: int) -> Dictionary:
	return {
		"name": name,
		"stars": stars,
		"is_new": is_new,
		"copy_count": copy_count,
		"pity_reset": stars >= 5
	}
