extends SceneTree

const ATLAS_ROOT := "res://assets/units/original_sources/generated_roster_atlases/chroma"
const MANIFEST_PATH := "res://assets/units/original_sources/generated_roster_atlases/manifest.json"
const OUTPUT_ROOT := "res://assets/units/original_sources/generated_chassis/chroma"

func _init() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT_ROOT))
	var manifest := _load_manifest()
	assert(int(manifest.get("version", 0)) == 1, "Unsupported generated roster atlas manifest version.")
	var written := 0
	for atlas_data in manifest.get("atlases", []):
		written += _extract_atlas(atlas_data)
	assert(written == 157, "Expected 157 roster units extracted from generated atlases.")
	print("Generated roster atlas extraction complete: %d unit sources." % written)
	quit()

func _load_manifest() -> Dictionary:
	var file := FileAccess.open(MANIFEST_PATH, FileAccess.READ)
	assert(file != null, "Missing generated roster atlas manifest: " + MANIFEST_PATH)
	var parsed = JSON.parse_string(file.get_as_text())
	assert(parsed is Dictionary, "Generated roster atlas manifest must be a JSON object.")
	return parsed

func _extract_atlas(atlas_data: Dictionary) -> int:
	var file_name: String = atlas_data.get("file", "")
	var columns: int = atlas_data.get("columns", 0)
	var rows: int = atlas_data.get("rows", 0)
	var art_ids: Array = atlas_data.get("art_ids", [])
	assert(not file_name.is_empty() and columns > 0 and rows > 0, "Invalid generated roster atlas entry.")
	assert(art_ids.size() <= columns * rows, "Too many art IDs for generated roster atlas: " + file_name)
	var source_path := ATLAS_ROOT + "/" + file_name
	var atlas := Image.load_from_file(source_path)
	assert(not atlas.is_empty(), "Missing generated roster atlas: " + source_path)
	for index in art_ids.size():
		var column := index % columns
		var row := int(index / columns)
		var x0 := roundi(float(atlas.get_width()) * column / float(columns))
		var x1 := roundi(float(atlas.get_width()) * (column + 1) / float(columns))
		var y0 := roundi(float(atlas.get_height()) * row / float(rows))
		var y1 := roundi(float(atlas.get_height()) * (row + 1) / float(rows))
		var cell := atlas.get_region(Rect2i(x0, y0, x1 - x0, y1 - y0))
		_paint_safe_gutter(cell)
		var output_path := OUTPUT_ROOT + "/%03d.png" % int(art_ids[index])
		var error := cell.save_png(output_path)
		assert(error == OK, "Could not save generated unit source: " + output_path)
	return art_ids.size()

func _paint_safe_gutter(image: Image) -> void:
	var width := image.get_width()
	var height := image.get_height()
	var gutter := maxi(2, roundi(minf(width, height) * 0.02))
	var matte := Color(0.0, 1.0, 0.0, 1.0)
	image.fill_rect(Rect2i(0, 0, width, gutter), matte)
	image.fill_rect(Rect2i(0, height - gutter, width, gutter), matte)
	image.fill_rect(Rect2i(0, 0, gutter, height), matte)
	image.fill_rect(Rect2i(width - gutter, 0, gutter, height), matte)
