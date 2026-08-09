extends SceneTree

const UnitCatalogScript = preload("res://scripts/unit_catalog.gd")

const CANVAS_SIZE := 1024
const PORTRAIT_SIZE := 160
const SOURCE_ROOT := "res://assets/units/original_sources"
const FACTION_SOURCE_ROOT := SOURCE_ROOT + "/faction_chassis"
const LIVE_FULL_ROOT := "res://assets/units/full"
const LIVE_PORTRAIT_ROOT := "res://assets/units/portraits"
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
	_make_dir(LIVE_FULL_ROOT)
	_make_dir(LIVE_PORTRAIT_ROOT)
	_make_dir(DIALOGUE_PORTRAIT_ROOT)
	var sprite_count := _build_roster_originals()
	var portrait_count := _build_portraits()
	var dialogue_count := _build_dialogue_portraits()
	assert(sprite_count == 210, "Expected one original sprite per roster unit.")
	assert(portrait_count == 210, "Expected one portrait per roster unit.")
	assert(dialogue_count == 3, "Expected all supporting-cast portraits.")
	print("Original-art build complete: %d sprites, %d portraits, %d dialogue portraits." % [
		sprite_count, portrait_count, dialogue_count
	])
	quit()

func _build_roster_originals() -> int:
	var variant_counts := {}
	var built := 0
	for unit in UnitCatalogScript.all_units():
		var faction: String = UnitCatalogScript.faction_for_icon(unit.icon)
		var key := "%s:%s" % [faction, unit.kind]
		var variant: int = variant_counts.get(key, 0)
		variant_counts[key] = variant + 1
		var cell := _class_template(unit.kind, variant)
		_remove_magenta(cell)
		var canvas := _fit_to_canvas(cell)
		_recolor_for_faction(canvas, faction, variant)
		var source_dir := "%s/%s/%s" % [FACTION_SOURCE_ROOT, faction, unit.kind]
		_make_dir(source_dir)
		var art_id: int = UnitCatalogScript.art_id(unit.icon)
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
	for unit in UnitCatalogScript.all_units():
		var art_id: int = UnitCatalogScript.art_id(unit.icon)
		if art_id not in art_ids:
			art_ids.append(art_id)
	assert(art_ids.size() == 210, "Every roster unit must have a unique art ID.")
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
