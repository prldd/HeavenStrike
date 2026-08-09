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
	print("Board background art build complete: %d boards." % BOARDS.size())
	quit()
