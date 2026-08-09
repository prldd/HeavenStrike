extends SceneTree

const MAP_SIZE := Vector2i(1672, 941)
const SOURCE_ROOT := "res://assets/operations_maps/original_sources"
const OUTPUT_ROOT := "res://assets"
const MAPS := {
	"act-1-reclamation.png": "operations-map-act-1-reclamation.png",
	"act-2-crisis.png": "operations-map-act-2-crisis.png",
	"act-3-caelis.png": "operations-map-act-3-caelis.png"
}

func _init() -> void:
	for source_name in MAPS:
		var source_path: String = SOURCE_ROOT + "/" + source_name
		var output_path: String = OUTPUT_ROOT + "/" + MAPS[source_name]
		var image := Image.load_from_file(source_path)
		assert(not image.is_empty(), "Could not load operations-map source: " + source_path)
		if image.get_size() != MAP_SIZE:
			image.resize(MAP_SIZE.x, MAP_SIZE.y, Image.INTERPOLATE_LANCZOS)
		var error := image.save_png(output_path)
		assert(error == OK, "Could not save operations-map runtime art: " + output_path)
	print("Operations-map art build complete: %d maps." % MAPS.size())
	quit()
