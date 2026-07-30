extends SceneTree

const MANIFEST_PATH := "res://assets/units/portrait_manifest.tsv"

func _init() -> void:
	DirAccess.make_dir_recursive_absolute(
		ProjectSettings.globalize_path("res://assets/units/portraits")
	)
	var manifest := FileAccess.open(MANIFEST_PATH, FileAccess.READ)
	assert(manifest != null, "Missing portrait manifest.")
	var sheet_cache := {}
	var generated := 0
	while not manifest.eof_reached():
		var columns := manifest.get_csv_line("\t")
		if columns.size() < 5 or columns[0].is_empty():
			continue
		var art_id := int(columns[0])
		var sheet_name := columns[1]
		var slot := int(columns[2])
		var source_path := (
			"res://assets/units/portrait_sheets/%s" % sheet_name
		)
		if not sheet_cache.has(sheet_name):
			var sheet := Image.load_from_file(source_path)
			assert(not sheet.is_empty(), "Missing portrait sheet: %s" % source_path)
			assert(sheet.get_width() == 960 and sheet.get_height() == 160)
			sheet_cache[sheet_name] = sheet
		var image: Image = sheet_cache[sheet_name].get_region(
			Rect2i(slot * 160, 0, 160, 160)
		)
		var output_path := "res://assets/units/portraits/%03d.png" % art_id
		assert(image.save_png(output_path) == OK, "Could not save %s" % output_path)
		generated += 1
	assert(generated == 1048, "Expected all 1,048 live reference portraits.")
	print("Generated %d unit portraits from %d official sheets." % [
		generated, sheet_cache.size()
	])
	quit()
