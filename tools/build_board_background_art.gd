extends SceneTree

const BOARD_SIZE := Vector2i(2167, 726)
const SOURCE_ROOT := "res://assets/boards/original_sources"
const OUTPUT_ROOT := "res://assets"
const BOARDS := {
	"courtyard-ink-cell.png": "board-steampunk-courtyard.png",
	"training-hall-ink-cell.png": "board-steampunk-training-hall.png",
	"reference-playboard.png": "boards/reference-playboard.png",
	"stage-training.png": "boards/stage-training.png",
	"stage-relay-excavation.png": "boards/stage-relay-excavation.png",
	"stage-proving-circuit.png": "boards/stage-proving-circuit.png",
	"stage-faction-crossroads.png": "boards/stage-faction-crossroads.png",
	"stage-coalition-front.png": "boards/stage-coalition-front.png",
	"stage-caelis-sanctum.png": "boards/stage-caelis-sanctum.png"
}
const MODERN_BOARDS := {
	"stage-training.png": "boards/modern/stage-training.png",
	"stage-relay-excavation.png": "boards/modern/stage-relay-excavation.png",
	"stage-proving-circuit.png": "boards/modern/stage-proving-circuit.png",
	"stage-faction-crossroads.png": "boards/modern/stage-faction-crossroads.png",
	"stage-coalition-front.png": "boards/modern/stage-coalition-front.png",
	"stage-caelis-sanctum.png": "boards/modern/stage-caelis-sanctum.png"
}

func _init() -> void:
	for source_name in BOARDS:
		var source_path: String = SOURCE_ROOT + "/" + source_name
		var output_path: String = OUTPUT_ROOT + "/" + BOARDS[source_name]
		var image := Image.load_from_file(source_path)
		assert(not image.is_empty(), "Could not load board source: " + source_path)
		if image.get_size() != BOARD_SIZE:
			image.resize(BOARD_SIZE.x, BOARD_SIZE.y, Image.INTERPOLATE_LANCZOS)
		var error := image.save_png(output_path)
		assert(error == OK, "Could not save board runtime art: " + output_path)
	for source_name in MODERN_BOARDS:
		var source_path: String = SOURCE_ROOT + "/modern/" + source_name
		var output_path: String = OUTPUT_ROOT + "/" + MODERN_BOARDS[source_name]
		var image := Image.load_from_file(source_path)
		assert(not image.is_empty(), "Could not load modern board source: " + source_path)
		_resize_cover(image, BOARD_SIZE)
		var error := image.save_png(output_path)
		assert(error == OK, "Could not save modern board runtime art: " + output_path)
	print(
		"Board background art build complete: %d legacy and %d modern boards."
		% [BOARDS.size(), MODERN_BOARDS.size()]
	)
	quit()

func _resize_cover(image: Image, target_size: Vector2i) -> void:
	var source_size := image.get_size()
	var target_aspect := float(target_size.x) / float(target_size.y)
	var source_aspect := float(source_size.x) / float(source_size.y)
	var crop_size := source_size
	if source_aspect < target_aspect:
		crop_size.y = roundi(float(source_size.x) / target_aspect)
	else:
		crop_size.x = roundi(float(source_size.y) * target_aspect)
	var crop_origin := Vector2i(
		floori(float(source_size.x - crop_size.x) * 0.5),
		floori(float(source_size.y - crop_size.y) * 0.5)
	)
	var cropped := image.get_region(Rect2i(crop_origin, crop_size))
	cropped.resize(target_size.x, target_size.y, Image.INTERPOLATE_LANCZOS)
	image.copy_from(cropped)
