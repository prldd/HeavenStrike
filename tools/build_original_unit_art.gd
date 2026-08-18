extends SceneTree

const UnitCatalogScript = preload("res://scripts/unit_catalog.gd")
const MissionUnitCatalogScript = preload("res://scripts/mission_unit_catalog.gd")

const CANVAS_SIZE := 1024
const PORTRAIT_SIZE := 160
const SOURCE_ROOT := "res://assets/units/original_sources"
const FACTION_SOURCE_ROOT := SOURCE_ROOT + "/faction_chassis"
const GENERATED_ROOT := "res://assets/units/gen"
const GENERATED_CHROMA_ROOT := SOURCE_ROOT + "/generated_chassis/chroma"
const GENERATED_CUTOUT_ROOT := SOURCE_ROOT + "/generated_chassis/cutouts"
const LIVE_FULL_ROOT := "res://assets/units/full"
const LIVE_PORTRAIT_ROOT := "res://assets/units/portraits"
const NEW_STANDALONE_ART_IDS := [1301, 1302, 1303, 1304, 1305, 1306]
const DIALOGUE_ATLAS := "res://assets/dialogue/original_sources/campaign-supporting-cast.png"
const DIALOGUE_PORTRAIT_ROOT := "res://assets/dialogue/portraits"
const DIALOGUE_PORTRAITS := ["lysa-vey", "asha-vale", "dax-calder"]

const CLASS_ATLASES := {
	"Warden": SOURCE_ROOT + "/class_atlases/warden.png",
	"Duelist": SOURCE_ROOT + "/class_atlases/duelist.png",
	"Artillerist": SOURCE_ROOT + "/class_atlases/artillerist.png",
	"Channeler": SOURCE_ROOT + "/class_atlases/channeler.png",
	"Lifebinder": SOURCE_ROOT + "/class_atlases/lifebinder.png"
}

# Runtime unit art has one canonical orientation: every source faces right.
# BoardView mirrors that art only for units deployed on the enemy side.
const LEFT_FACING_TEMPLATE_CELLS := {
	"Artillerist": [1, 4],
	"Strider": [8]
}

const FACTION_HUES := {
	"Coal": 0.035,
	"Steam": 0.47,
	"Wind": 0.55,
	"Fusion": 0.79,
	"Solar": 0.12,
	"Universal": 0.60
}

var atlas_cache: Dictionary = {}

func _init() -> void:
	_make_dir(FACTION_SOURCE_ROOT)
	_make_dir(GENERATED_CUTOUT_ROOT)
	_make_dir(GENERATED_ROOT)
	_make_dir(LIVE_FULL_ROOT)
	_make_dir(LIVE_PORTRAIT_ROOT)
	_make_dir(DIALOGUE_PORTRAIT_ROOT)
	var generated_count := _build_generated_cutouts()
	var sprite_count := _build_roster_originals()
	var portrait_count := _build_portraits()
	var dialogue_count := _build_dialogue_portraits()
	assert(sprite_count == 293, "Expected art for every playable and mission unit.")
	assert(portrait_count == 293, "Expected portraits for every playable and mission unit.")
	assert(dialogue_count == 3, "Expected all supporting-cast portraits.")
	print("Original-art build complete: %d generated cutouts, %d sprites, %d portraits, %d dialogue portraits." % [
		generated_count, sprite_count, portrait_count, dialogue_count
	])
	quit()

func _build_generated_cutouts() -> int:
	if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(GENERATED_CHROMA_ROOT)):
		return 0
	var active_art_ids: Array[int] = []
	for unit in _all_art_units():
		active_art_ids.append(UnitCatalogScript.art_id(unit.icon))
	var source_files := Array(DirAccess.get_files_at(GENERATED_CHROMA_ROOT)).filter(
		func(file_name): return file_name.ends_with(".png")
	)
	source_files.sort()
	for file_name in source_files:
		var art_id: int = file_name.get_basename().to_int()
		assert(file_name == "%03d.png" % art_id, "Generated chroma source needs a zero-padded numeric art ID: " + file_name)
		assert(art_id in active_art_ids, "Generated chroma source is not used by the roster: " + file_name)
		var source := _load_image(GENERATED_CHROMA_ROOT + "/" + file_name)
		_remove_generated_chroma(source)
		_remove_edge_components(source)
		var cutout := _fit_to_canvas(source)
		_contract_alpha(cutout)
		var bounds := _alpha_bounds(cutout)
		assert(bounds.size.x > 64 and bounds.size.y > 64, "Empty generated cutout: " + file_name)
		for corner in [
			Vector2i.ZERO, Vector2i(CANVAS_SIZE - 1, 0),
			Vector2i(0, CANVAS_SIZE - 1), Vector2i(CANVAS_SIZE - 1, CANVAS_SIZE - 1)
		]:
			assert(cutout.get_pixelv(corner).a <= 0.05, "Generated cutout needs transparent corners: %s (%s = %.3f)" % [
				file_name, str(corner), cutout.get_pixelv(corner).a
			])
		_save_png(cutout, GENERATED_CUTOUT_ROOT + "/" + file_name)
		_save_png(cutout, GENERATED_ROOT + "/" + file_name)
	return source_files.size()

func _contract_alpha(image: Image) -> void:
	var source := image.duplicate()
	for y in range(1, image.get_height() - 1):
		for x in range(1, image.get_width() - 1):
			if source.get_pixel(x, y).a <= 0.05:
				continue
			var touches_transparency := false
			for offset_y in range(-1, 2):
				for offset_x in range(-1, 2):
					if source.get_pixel(x + offset_x, y + offset_y).a <= 0.05:
						touches_transparency = true
						break
				if touches_transparency:
					break
			if touches_transparency:
				image.set_pixel(x, y, Color.TRANSPARENT)

func _remove_generated_chroma(image: Image) -> void:
	image.convert(Image.FORMAT_RGBA8)
	var key := image.get_pixel(0, 0)
	var green_key := key.g > key.r + 0.25 and key.g > key.b + 0.25
	for y in image.get_height():
		for x in image.get_width():
			var color := image.get_pixel(x, y)
			var distance := Vector3(
				color.r - key.r, color.g - key.g, color.b - key.b
			).length()
			var alpha := smoothstep(0.08, 0.32, distance)
			if green_key:
				var green_dominance := color.g - maxf(color.r, color.b)
				var green_alpha := 1.0 - smoothstep(0.04, 0.20, green_dominance)
				alpha = minf(alpha, green_alpha)
			if alpha <= 0.01:
				image.set_pixel(x, y, Color.TRANSPARENT)
				continue
			if alpha < 0.995:
				color.r = clampf((color.r - key.r * (1.0 - alpha)) / alpha, 0.0, 1.0)
				color.g = clampf((color.g - key.g * (1.0 - alpha)) / alpha, 0.0, 1.0)
				color.b = clampf((color.b - key.b * (1.0 - alpha)) / alpha, 0.0, 1.0)
				var spill := maxf(0.0, minf(color.r, color.b) - color.g)
				color.r = maxf(0.0, color.r - spill)
				color.b = maxf(0.0, color.b - spill)
			color.a = alpha
			image.set_pixel(x, y, color)

func _remove_edge_components(image: Image) -> void:
	var width := image.get_width()
	var height := image.get_height()
	var visited := PackedByteArray()
	visited.resize(width * height)
	var pending: Array[int] = []
	for x in width:
		_queue_edge_pixel(image, x, 0, width, visited, pending)
		_queue_edge_pixel(image, x, height - 1, width, visited, pending)
	for y in range(1, height - 1):
		_queue_edge_pixel(image, 0, y, width, visited, pending)
		_queue_edge_pixel(image, width - 1, y, width, visited, pending)
	while not pending.is_empty():
		var index: int = pending.pop_back()
		var x: int = index % width
		var y: int = int(index / width)
		image.set_pixel(x, y, Color.TRANSPARENT)
		if x > 0:
			_queue_edge_pixel(image, x - 1, y, width, visited, pending)
		if x + 1 < width:
			_queue_edge_pixel(image, x + 1, y, width, visited, pending)
		if y > 0:
			_queue_edge_pixel(image, x, y - 1, width, visited, pending)
		if y + 1 < height:
			_queue_edge_pixel(image, x, y + 1, width, visited, pending)

func _queue_edge_pixel(
	image: Image, x: int, y: int, width: int,
	visited: PackedByteArray, pending: Array[int]
) -> void:
	var index := y * width + x
	if visited[index] != 0:
		return
	visited[index] = 1
	if image.get_pixel(x, y).a > 0.05:
		pending.append(index)

func _build_roster_originals() -> int:
	var variant_counts := {}
	var built := 0
	for unit in _all_art_units():
		var faction: String = UnitCatalogScript.faction_for_icon(unit.icon)
		var key := "%s:%s" % [faction, unit.kind]
		var variant: int = variant_counts.get(key, 0)
		var art_id: int = UnitCatalogScript.art_id(unit.icon)
		# Existing standalone replacements still consume their historical atlas
		# slot so later chassis retain stable variants. Newly appended IDs do not.
		if art_id not in NEW_STANDALONE_ART_IDS:
			variant_counts[key] = variant + 1
		var generated_path := GENERATED_ROOT + "/%03d.png" % art_id
		var generated_source_path := GENERATED_CHROMA_ROOT + "/%03d.png" % art_id
		var canvas: Image
		if FileAccess.file_exists(generated_source_path) and FileAccess.file_exists(generated_path):
			canvas = _load_image(generated_path)
			assert(
				canvas.get_size() == Vector2i(CANVAS_SIZE, CANVAS_SIZE),
				"Generated unit source must be 1024x1024: " + generated_path
			)
		else:
			var cell := _class_template(unit.kind, variant)
			_remove_magenta(cell)
			canvas = _fit_to_canvas(cell)
			_recolor_for_faction(canvas, faction, variant)
			# Chroma-sourced units get their gen/ cutout from
			# _build_generated_cutouts; atlas-derived units need one written here
			# so gen/ keeps a transparent cutout for every live art ID.
			_save_png(canvas, GENERATED_ROOT + "/%03d.png" % art_id)
		var source_dir := "%s/%s/%s" % [FACTION_SOURCE_ROOT, faction, unit.kind]
		_make_dir(source_dir)
		var file_name := "%03d.png" % art_id
		_save_png(canvas, source_dir + "/" + file_name)
		_save_png(canvas, LIVE_FULL_ROOT + "/" + file_name)
		built += 1
	return built

func _class_template(unit_class: String, variant: int) -> Image:
	var template_index := variant % _template_count(unit_class)
	var cell: Image
	if unit_class == "Strider":
		var atlas_path := (
			SOURCE_ROOT + "/class_atlases/strider-a.png"
			if template_index < 6
			else SOURCE_ROOT + "/class_atlases/strider-b.png"
		)
		cell = _atlas_cell(_cached_atlas(atlas_path), template_index % 6)
	else:
		var atlas_path: String = CLASS_ATLASES[unit_class]
		cell = _atlas_cell(_cached_atlas(atlas_path), template_index)
	var left_facing_cells: Array = LEFT_FACING_TEMPLATE_CELLS.get(unit_class, [])
	if template_index in left_facing_cells:
		cell.flip_x()
	return cell

func _template_count(unit_class: String) -> int:
	return 12 if unit_class == "Strider" else 6

func _cached_atlas(path: String) -> Image:
	if not atlas_cache.has(path):
		atlas_cache[path] = _load_image(path)
	return atlas_cache[path]

func _recolor_for_faction(image: Image, faction: String, variant: int) -> void:
	var base_hue: float = FACTION_HUES.get(faction, 0.55)
	var hue_offset := (float(variant % 3) - 1.0) * 0.018
	var value_scale := 0.94 + float(variant % 4) * 0.025
	for y in image.get_height():
		for x in image.get_width():
			var color := image.get_pixel(x, y)
			if color.a <= 0.025:
				continue
			var saturation := color.s
			var hue := color.h
			# The generated source uses blue enamel and cyan power elements.
			# Shift only that authored material family; brass, ink, and neutral
			# metal remain consistent across factions.
			if saturation > 0.10 and hue > 0.42 and hue < 0.72:
				var shifted_saturation := clampf(saturation * 1.08, 0.18, 0.92)
				var shifted_value := clampf(color.v * value_scale, 0.0, 1.0)
				var shifted := Color.from_hsv(
					fposmod(base_hue + hue_offset, 1.0),
					shifted_saturation,
					shifted_value,
					color.a
				)
				image.set_pixel(x, y, shifted)

func _atlas_cell(atlas: Image, cell_index: int) -> Image:
	var column := cell_index % 3
	var row := int(cell_index / 3)
	var x0 := roundi(float(atlas.get_width()) * column / 3.0)
	var x1 := roundi(float(atlas.get_width()) * (column + 1) / 3.0)
	var y0 := roundi(float(atlas.get_height()) * row / 2.0)
	var y1 := roundi(float(atlas.get_height()) * (row + 1) / 2.0)
	return atlas.get_region(Rect2i(x0, y0, x1 - x0, y1 - y0))

func _remove_magenta(image: Image) -> void:
	image.convert(Image.FORMAT_RGBA8)
	for y in image.get_height():
		for x in image.get_width():
			var color := image.get_pixel(x, y)
			# Estimate coverage for artwork composited over pure magenta. Neutral,
			# blue, cyan, and brass foreground colors remain opaque; magenta spill
			# becomes a smooth alpha edge and is removed from the RGB channels.
			var spill := minf(color.r, color.b) - color.g
			var alpha := clampf(1.0 - spill * 1.08, 0.0, 1.0)
			if alpha < 0.025:
				image.set_pixel(x, y, Color.TRANSPARENT)
				continue
			if alpha < 0.995:
				var inv := 1.0 - alpha
				color.r = clampf((color.r - inv) / alpha, 0.0, 1.0)
				color.g = clampf(color.g / alpha, 0.0, 1.0)
				color.b = clampf((color.b - inv) / alpha, 0.0, 1.0)
				# Suppress the green fringe that can remain after subtracting a
				# magenta matte from antialiased edge pixels.
				color.g = minf(color.g, maxf(color.r, color.b))
			color.a = alpha
			image.set_pixel(x, y, color)

func _fit_to_canvas(source: Image) -> Image:
	var scale := minf(
		float(CANVAS_SIZE) / source.get_width(),
		float(CANVAS_SIZE) / source.get_height()
	)
	var scaled_width := maxi(1, roundi(source.get_width() * scale))
	var scaled_height := maxi(1, roundi(source.get_height() * scale))
	source.resize(scaled_width, scaled_height, Image.INTERPOLATE_LANCZOS)
	var canvas := Image.create(CANVAS_SIZE, CANVAS_SIZE, false, Image.FORMAT_RGBA8)
	canvas.fill(Color.TRANSPARENT)
	var offset := Vector2i(
		int((CANVAS_SIZE - scaled_width) / 2), int((CANVAS_SIZE - scaled_height) / 2)
	)
	canvas.blend_rect(source, Rect2i(Vector2i.ZERO, source.get_size()), offset)
	return canvas

func _build_portraits() -> int:
	var art_ids: Array[int] = []
	for unit in _all_art_units():
		var art_id: int = UnitCatalogScript.art_id(unit.icon)
		if art_id not in art_ids:
			art_ids.append(art_id)
	assert(art_ids.size() == 293, "Every playable and mission unit needs a unique art ID.")
	for art_id in art_ids:
		var full_path := LIVE_FULL_ROOT + "/%03d.png" % art_id
		var full := _load_image(full_path)
		var bounds := _alpha_bounds(full)
		assert(bounds.size.x > 0 and bounds.size.y > 0, "Empty unit art: %s" % full_path)
		var side := clampi(roundi(bounds.size.y * 0.62), 96, mini(full.get_width(), full.get_height()))
		var center_x := bounds.position.x + int(bounds.size.x / 2)
		var center_y := bounds.position.y + int(side * 0.52)
		var x := clampi(center_x - int(side / 2), 0, full.get_width() - side)
		var y := clampi(center_y - int(side / 2), 0, full.get_height() - side)
		var portrait := full.get_region(Rect2i(x, y, side, side))
		portrait.resize(PORTRAIT_SIZE, PORTRAIT_SIZE, Image.INTERPOLATE_LANCZOS)
		_save_png(portrait, LIVE_PORTRAIT_ROOT + "/%03d.png" % art_id)
	return art_ids.size()

func _all_art_units() -> Array:
	var units: Array = UnitCatalogScript.all_units().duplicate()
	units.append_array(MissionUnitCatalogScript.all_units())
	return units

func _build_dialogue_portraits() -> int:
	var atlas := _load_image(DIALOGUE_ATLAS)
	for index in DIALOGUE_PORTRAITS.size():
		var x0 := roundi(float(atlas.get_width()) * index / 3.0)
		var x1 := roundi(float(atlas.get_width()) * (index + 1) / 3.0)
		var portrait := atlas.get_region(
			Rect2i(x0, 0, x1 - x0, atlas.get_height())
		)
		_remove_magenta(portrait)
		_save_png(
			portrait,
			DIALOGUE_PORTRAIT_ROOT + "/" + DIALOGUE_PORTRAITS[index] + ".png"
		)
	return DIALOGUE_PORTRAITS.size()

func _alpha_bounds(image: Image) -> Rect2i:
	var min_x := image.get_width()
	var min_y := image.get_height()
	var max_x := -1
	var max_y := -1
	for y in image.get_height():
		for x in image.get_width():
			if image.get_pixel(x, y).a <= 0.025:
				continue
			min_x = mini(min_x, x)
			min_y = mini(min_y, y)
			max_x = maxi(max_x, x)
			max_y = maxi(max_y, y)
	if max_x < min_x or max_y < min_y:
		return Rect2i()
	return Rect2i(min_x, min_y, max_x - min_x + 1, max_y - min_y + 1)

func _load_image(path: String) -> Image:
	var image := Image.new()
	var bytes := FileAccess.get_file_as_bytes(path)
	assert(not bytes.is_empty(), "Could not read image: %s" % path)
	assert(image.load_png_from_buffer(bytes) == OK, "Could not load PNG: %s" % path)
	return image

func _save_png(image: Image, path: String) -> void:
	assert(image.save_png(path) == OK, "Could not save image: %s" % path)

func _make_dir(path: String) -> void:
	assert(
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(path)) == OK,
		"Could not create directory: %s" % path
	)
