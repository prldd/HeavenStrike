extends SceneTree

const SOURCE_ROOT := "res://assets/ui/original_sources/chroma"
const OUTPUT_ROOT := "res://assets/ui"
const OUTPUT_SIZES := {
	"conductor-life.png": Vector2i(512, 512),
	"conductor-mana.png": Vector2i(512, 256),
	"conductor-deck.png": Vector2i(384, 256),
}
const OUTPUT_PADDING := 8

func _init() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT_ROOT))
	for file_name in OUTPUT_SIZES:
		var source := _load_image(SOURCE_ROOT + "/" + file_name)
		_remove_chroma(source)
		var bounds := _alpha_bounds(source)
		assert(bounds.size.x > 64 and bounds.size.y > 64, "Empty HUD source: " + file_name)
		var padded_bounds := bounds.grow(8).intersection(
			Rect2i(Vector2i.ZERO, source.get_size())
		)
		var cutout := source.get_region(padded_bounds)
		var target_size: Vector2i = OUTPUT_SIZES[file_name]
		var available := target_size - Vector2i.ONE * OUTPUT_PADDING * 2
		var scale := minf(
			float(available.x) / cutout.get_width(),
			float(available.y) / cutout.get_height()
		)
		var scaled_size := Vector2i(
			maxi(1, roundi(cutout.get_width() * scale)),
			maxi(1, roundi(cutout.get_height() * scale))
		)
		cutout.resize(scaled_size.x, scaled_size.y, Image.INTERPOLATE_LANCZOS)
		var canvas := Image.create_empty(
			target_size.x, target_size.y, false, Image.FORMAT_RGBA8
		)
		canvas.fill(Color.TRANSPARENT)
		var destination := (target_size - scaled_size) / 2
		canvas.blend_rect(cutout, Rect2i(Vector2i.ZERO, scaled_size), destination)
		for corner in [
			Vector2i.ZERO, Vector2i(target_size.x - 1, 0),
			Vector2i(0, target_size.y - 1), target_size - Vector2i.ONE
		]:
			assert(canvas.get_pixelv(corner).a <= 0.01, "HUD asset needs transparent corners: " + file_name)
		assert(
			canvas.save_png(OUTPUT_ROOT + "/" + file_name) == OK,
			"Could not save conductor HUD asset: " + file_name
		)
	print("Conductor HUD art built: %d assets." % OUTPUT_SIZES.size())
	quit()

func _load_image(path: String) -> Image:
	var image := Image.new()
	var bytes := FileAccess.get_file_as_bytes(path)
	assert(not bytes.is_empty(), "Could not read conductor HUD source: " + path)
	assert(image.load_png_from_buffer(bytes) == OK, "Could not load HUD PNG: " + path)
	return image

func _remove_chroma(image: Image) -> void:
	image.convert(Image.FORMAT_RGBA8)
	var key := image.get_pixel(0, 0)
	for y in image.get_height():
		for x in image.get_width():
			var color := image.get_pixel(x, y)
			var distance := Vector3(
				color.r - key.r, color.g - key.g, color.b - key.b
			).length()
			var key_probability := 1.0 - smoothstep(0.08, 0.30, distance)
			var green_dominance := color.g - maxf(color.r, color.b)
			var dominance_probability := smoothstep(0.035, 0.20, green_dominance)
			var hue_distance := absf(
				fposmod(color.h - key.h + 0.5, 1.0) - 0.5
			)
			var hue_probability := (
				(1.0 - smoothstep(0.055, 0.14, hue_distance))
				* smoothstep(0.18, 0.58, color.s)
				* smoothstep(0.16, 0.72, color.v)
			)
			# Electrical bloom makes the generated Mana matte uneven. Treat any
			# confidently green-dominant pixel as matte while cyan-blue energy,
			# whose blue channel meets or exceeds green, remains opaque.
			var matte_probability := maxf(
				key_probability, maxf(dominance_probability, hue_probability)
			)
			var alpha := 1.0 - matte_probability
			if alpha <= 0.01:
				image.set_pixel(x, y, Color.TRANSPARENT)
				continue
			if alpha < 0.995:
				color.r = clampf((color.r - key.r * (1.0 - alpha)) / alpha, 0.0, 1.0)
				color.g = clampf((color.g - key.g * (1.0 - alpha)) / alpha, 0.0, 1.0)
				color.b = clampf((color.b - key.b * (1.0 - alpha)) / alpha, 0.0, 1.0)
			color.a = alpha
			image.set_pixel(x, y, color)

func _alpha_bounds(image: Image) -> Rect2i:
	var minimum := Vector2i(image.get_width(), image.get_height())
	var maximum := Vector2i(-1, -1)
	for y in image.get_height():
		for x in image.get_width():
			if image.get_pixel(x, y).a <= 0.025:
				continue
			minimum.x = mini(minimum.x, x)
			minimum.y = mini(minimum.y, y)
			maximum.x = maxi(maximum.x, x)
			maximum.y = maxi(maximum.y, y)
	if maximum.x < minimum.x or maximum.y < minimum.y:
		return Rect2i()
	return Rect2i(minimum, maximum - minimum + Vector2i.ONE)
