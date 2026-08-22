extends SceneTree

const SOURCE_ROOT := "res://assets/units/original_sources/generated_chassis/chroma"
const FIRST_ICON := 225
const LAST_ICON := 293
const ICON_ART_IDS := {
	231: 1307, 232: 1308, 241: 1309, 242: 1310,
	253: 1311, 254: 1312, 259: 1313, 260: 1314,
	263: 1315, 264: 1316, 275: 1317, 276: 1318,
	289: 1319, 290: 1320,
}


func _init() -> void:
	var normalized := 0
	for icon in range(FIRST_ICON, LAST_ICON + 1):
		var art_id: int = ICON_ART_IDS.get(icon, icon)
		var path := "%s/%03d.png" % [SOURCE_ROOT, art_id]
		assert(FileAccess.file_exists(path), "Missing late-roster source: " + path)
		var image := Image.load_from_file(path)
		assert(not image.is_empty(), "Could not load late-roster source: " + path)
		image.convert(Image.FORMAT_RGBA8)
		if image.get_pixel(0, 0).a > 0.95:
			continue
		var matte := Image.create(image.get_width(), image.get_height(), false, Image.FORMAT_RGBA8)
		matte.fill(Color(0.0, 1.0, 0.0, 1.0))
		matte.blend_rect(image, Rect2i(Vector2i.ZERO, image.get_size()), Vector2i.ZERO)
		matte.convert(Image.FORMAT_RGB8)
		var error := matte.save_png(path)
		assert(error == OK, "Could not normalize late-roster source: " + path)
		normalized += 1
	print("Late-roster chroma normalization complete: %d transparent sources flattened, 69 checked." % normalized)
	quit()
