extends SceneTree

const UnitCatalogScript = preload("res://scripts/unit_catalog.gd")
const MissionUnitCatalogScript = preload("res://scripts/mission_unit_catalog.gd")

const CANVAS_SIZE := Vector2i(1024, 1024)
const GENERATED_ROOT := "res://assets/units/gen"
const RUNTIME_ROOT := "res://assets/units/full"

func _init() -> void:
	var active_art_ids := _active_art_ids()
	var installed_art_ids: Array[int] = []
	var source_files := Array(DirAccess.get_files_at(GENERATED_ROOT)).filter(
		func(file_name): return file_name.ends_with(".png")
	)
	source_files.sort()
	for file_name in source_files:
		var art_id: int = file_name.get_basename().to_int()
		assert(
			file_name == "%03d.png" % art_id,
			"Generated unit art must use its zero-padded numeric art ID: " + file_name
		)
		assert(
			art_id in active_art_ids,
			"Generated unit art does not map to an active roster entry: " + file_name
		)
		var source_path: String = GENERATED_ROOT + "/" + file_name
		_validate_source(source_path)
		var runtime_path: String = RUNTIME_ROOT + "/" + file_name
		assert(
			DirAccess.copy_absolute(
				ProjectSettings.globalize_path(source_path),
				ProjectSettings.globalize_path(runtime_path)
			) == OK,
			"Could not install generated unit art: " + runtime_path
		)
		installed_art_ids.append(art_id)

	assert(
		installed_art_ids.size() == installed_art_ids.duplicate().size(),
		"Generated unit art contains duplicate numeric art IDs."
	)
	var missing_art_ids: Array[int] = []
	for art_id in active_art_ids:
		var runtime_path := RUNTIME_ROOT + "/%03d.png" % art_id
		assert(FileAccess.file_exists(runtime_path), "Missing runtime unit art: " + runtime_path)
		_ensure_mipmaps(runtime_path + ".import")
		if art_id not in installed_art_ids:
			missing_art_ids.append(art_id)
	missing_art_ids.sort()
	print(
		"Generated unit-art install complete: %d replacements, %d retained fallbacks." % [
			installed_art_ids.size(), missing_art_ids.size()
		]
	)
	if not missing_art_ids.is_empty():
		print("Retained fallback art IDs: " + str(missing_art_ids))
	quit()

func _active_art_ids() -> Array[int]:
	var art_ids: Array[int] = []
	var units: Array = UnitCatalogScript.all_units().duplicate()
	units.append_array(MissionUnitCatalogScript.all_units())
	for unit in units:
		var art_id: int = UnitCatalogScript.art_id(unit.icon)
		assert(art_id not in art_ids, "Roster art IDs must remain unique.")
		art_ids.append(art_id)
	art_ids.sort()
	return art_ids

func _validate_source(path: String) -> void:
	var image := Image.new()
	var bytes := FileAccess.get_file_as_bytes(path)
	assert(not bytes.is_empty(), "Could not read generated unit art: " + path)
	assert(image.load_png_from_buffer(bytes) == OK, "Could not decode generated unit art: " + path)
	assert(image.get_size() == CANVAS_SIZE, "Generated unit art must be 1024x1024: " + path)
	image.convert(Image.FORMAT_RGBA8)
	for corner in [
		Vector2i.ZERO,
		Vector2i(CANVAS_SIZE.x - 1, 0),
		Vector2i(0, CANVAS_SIZE.y - 1),
		CANVAS_SIZE - Vector2i.ONE
	]:
		assert(
			image.get_pixelv(corner).a <= 0.05,
			"Generated unit art needs transparent canvas corners: " + path
		)

func _ensure_mipmaps(import_path: String) -> void:
	assert(FileAccess.file_exists(import_path), "Missing runtime import map: " + import_path)
	var config := ConfigFile.new()
	assert(config.load(import_path) == OK, "Could not read runtime import map: " + import_path)
	if not config.get_value("params", "mipmaps/generate", false):
		config.set_value("params", "mipmaps/generate", true)
		assert(config.save(import_path) == OK, "Could not update runtime import map: " + import_path)
