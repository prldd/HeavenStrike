class_name ResonanceUITheme
extends RefCounted

# These legacy constant names are part of the UI API used across main.gd.
# Their values now describe the modern field-command palette: graphite,
# cool readout white, cyan signal light, and coral threat indication.
const INK := Color("#061016")
const INK_SOFT := Color("#52666f")
const PARCHMENT := Color("#d7e4e7")
const PARCHMENT_LIGHT := Color("#f2f8f9")
const PARCHMENT_DARK := Color("#6f8790")
const NAVY := Color("#101d26")
const NAVY_DEEP := Color("#061018")
const BRASS := Color("#38c7d6")
const BRASS_LIGHT := Color("#b8f3f5")
const BRASS_DARK := Color("#236a76")
const CRIMSON := Color("#ef6078")

static func create() -> Theme:
	var theme := Theme.new()
	theme.default_font_size = 15

	theme.set_color("font_color", "Label", PARCHMENT_LIGHT)
	theme.set_color("font_shadow_color", "Label", Color(0.01, 0.025, 0.035, 0.78))
	theme.set_constant("shadow_offset_x", "Label", 1)
	theme.set_constant("shadow_offset_y", "Label", 2)

	theme.set_stylebox("panel", "PanelContainer", _panel(NAVY, BRASS_DARK, 1, 3, 12))
	theme.set_stylebox("normal", "Button", _button(NAVY, Color("#31515b"), 1))
	theme.set_stylebox("hover", "Button", _button(Color("#16313d"), BRASS, 3))
	theme.set_stylebox("pressed", "Button", _button(Color("#0a202a"), BRASS_LIGHT, 1))
	theme.set_stylebox("focus", "Button", _outline(BRASS_LIGHT, 2, 2))
	theme.set_stylebox("disabled", "Button", _button(Color("#172128"), Color("#3b4b51"), 0))
	theme.set_color("font_color", "Button", PARCHMENT_LIGHT)
	theme.set_color("font_hover_color", "Button", Color.WHITE)
	theme.set_color("font_pressed_color", "Button", BRASS_LIGHT)
	theme.set_color("font_disabled_color", "Button", Color("#718087"))

	for control_type in ["OptionButton", "LineEdit"]:
		theme.set_stylebox("normal", control_type, _button(NAVY_DEEP, BRASS_DARK, 0))
		theme.set_stylebox("focus", control_type, _outline(BRASS_LIGHT, 2, 2))
		theme.set_color("font_color", control_type, PARCHMENT_LIGHT)

	theme.set_stylebox("panel", "PopupMenu", _panel(NAVY_DEEP, BRASS_DARK, 1, 2, 8))
	theme.set_color("font_color", "PopupMenu", PARCHMENT_LIGHT)
	theme.set_color("font_hover_color", "PopupMenu", Color.WHITE)
	theme.set_stylebox("hover", "PopupMenu", _flat(Color("#15343f"), 2))

	theme.set_stylebox("normal", "RichTextLabel", _panel(Color("#0b1720"), BRASS_DARK, 1, 2, 8))
	theme.set_color("default_color", "RichTextLabel", PARCHMENT_LIGHT)
	theme.set_color("font_color", "CheckButton", PARCHMENT_LIGHT)

	theme.set_stylebox("scroll", "VScrollBar", _flat(Color("#111925"), 4))
	theme.set_stylebox("grabber", "VScrollBar", _flat(BRASS_DARK, 4))
	theme.set_stylebox("grabber_highlight", "VScrollBar", _flat(BRASS, 4))
	theme.set_stylebox("grabber_pressed", "VScrollBar", _flat(BRASS_LIGHT, 4))
	if OS.has_feature("mobile"):
		# Default ~12px scrollbars are too thin to grab on a touchscreen.
		for stylebox_name in ["scroll", "grabber", "grabber_highlight", "grabber_pressed"]:
			var bar_style: StyleBoxFlat = theme.get_stylebox(stylebox_name, "VScrollBar")
			bar_style.content_margin_left = 8
			bar_style.content_margin_right = 8
	theme.set_color("separator", "HSeparator", Color(BRASS_DARK, 0.85))
	theme.set_color("separator", "VSeparator", Color(BRASS_DARK, 0.85))
	theme.set_constant("separation", "HSeparator", 2)
	theme.set_constant("separation", "VSeparator", 2)
	return theme

static func title_color() -> Color:
	return BRASS_LIGHT

static func muted_color() -> Color:
	return Color("#a8b9bd")

## Procedural house glyph shared by every return-to-menu button. Drawn as a
## cyan signal roof over a body block with a door cutout, so the app needs no
## icon asset files.
static func home_icon(size: int = 28) -> ImageTexture:
	var image := Image.create_empty(size, size, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	@warning_ignore("integer_division")
	var center := size / 2
	var roof_peak := int(size * 0.06)
	var roof_base := int(size * 0.48)
	var body_bottom := int(size * 0.9)
	for y in range(roof_peak, body_bottom):
		var half := 0.0
		if y <= roof_base:
			half = (float(y - roof_peak) / float(roof_base - roof_peak)) * size * 0.44
		else:
			half = size * 0.27
		for x in range(maxi(0, center - int(half)), mini(size, center + int(half) + 1)):
			image.set_pixel(x, y, BRASS_LIGHT)
	var door_half := int(size * 0.07)
	for y in range(int(size * 0.64), body_bottom):
		for x in range(center - door_half, center + door_half + 1):
			image.set_pixel(x, y, Color.TRANSPARENT)
	return ImageTexture.create_from_image(image)

static func parchment_panel() -> StyleBoxFlat:
	var style := _panel(PARCHMENT, BRASS_DARK, 1, 2, 18)
	style.border_color = BRASS
	style.shadow_color = Color(0.01, 0.04, 0.06, 0.58)
	style.shadow_size = 8
	return style

static func dark_plaque() -> StyleBoxFlat:
	var style := _panel(Color(0.025, 0.06, 0.082, 0.94), Color(BRASS, 0.68), 1, 2, 24)
	style.set_border_width(SIDE_LEFT, 4)
	style.shadow_color = Color(0.0, 0.03, 0.05, 0.86)
	style.shadow_size = 16
	return style

static func command_bridge_style() -> StyleBoxFlat:
	var style := _panel(
		Color(0.018, 0.050, 0.070, 0.97), Color.TRANSPARENT, 0, 2, 10
	)
	style.border_color = Color("#789096", 0.30)
	style.set_border_width(SIDE_BOTTOM, 1)
	style.shadow_color = Color(0.01, 0.02, 0.03, 0.48)
	style.shadow_size = 5
	return style

static func command_dock_style() -> StyleBoxFlat:
	var style := _panel(
		Color(0.014, 0.042, 0.061, 0.98), Color(BRASS, 0.32), 1, 3, 8
	)
	style.shadow_color = Color(0.01, 0.02, 0.03, 0.56)
	style.shadow_size = 6
	return style

static func instrument_style(
	accent: Color, tint: float, border_alpha: float, glow: int, margin: float = 8.0
) -> StyleBoxFlat:
	var fill := Color("#081822").lerp(accent.darkened(0.72), tint)
	var style := _panel(fill, Color(accent, border_alpha * 0.78), 1, 3, margin)
	style.set_border_width(SIDE_BOTTOM, 2 if glow > 0 else 1)
	style.shadow_color = Color(accent, 0.13 if glow > 0 else 0.0)
	style.shadow_size = mini(glow, 4)
	return style

static func card_style(color: Color, tint: float, border_alpha: float, glow: int) -> StyleBoxFlat:
	var style := _panel(NAVY_DEEP.lerp(color.darkened(0.36), tint), Color(color, border_alpha), 1, 3, 7)
	style.shadow_color = Color(color, 0.22 if glow > 0 else 0.0)
	style.shadow_size = glow
	return style

static func _button(fill: Color, border: Color, shadow: int) -> StyleBoxFlat:
	var style := _panel(fill, border, 1, 2, 10)
	style.shadow_color = Color(0.0, 0.04, 0.06, 0.68 if shadow > 0 else 0.0)
	style.shadow_size = shadow
	return style

static func _panel(
	fill: Color, border: Color, width: int, radius: int, margin: float
) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(width)
	style.set_corner_radius_all(radius)
	style.content_margin_left = margin
	style.content_margin_right = margin
	style.content_margin_top = margin
	style.content_margin_bottom = margin
	return style

static func _outline(color: Color, width: int, radius: int) -> StyleBoxFlat:
	return _panel(Color.TRANSPARENT, color, width, radius, 0)

static func _flat(color: Color, radius: int) -> StyleBoxFlat:
	return _panel(color, Color.TRANSPARENT, 0, radius, 0)
