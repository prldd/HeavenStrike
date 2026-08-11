class_name AetherEngineUITheme
extends RefCounted

const INK := Color("#241b19")
const INK_SOFT := Color("#51423a")
const PARCHMENT := Color("#e7d4ad")
const PARCHMENT_LIGHT := Color("#f4e6c7")
const PARCHMENT_DARK := Color("#b99b6a")
const NAVY := Color("#172334")
const NAVY_DEEP := Color("#0c1420")
const BRASS := Color("#c49a52")
const BRASS_LIGHT := Color("#efd38a")
const BRASS_DARK := Color("#75542c")
const CRIMSON := Color("#8f3941")

static func create() -> Theme:
	var theme := Theme.new()
	theme.default_font_size = 15

	theme.set_color("font_color", "Label", PARCHMENT_LIGHT)
	theme.set_color("font_shadow_color", "Label", Color(0.04, 0.025, 0.02, 0.75))
	theme.set_constant("shadow_offset_x", "Label", 1)
	theme.set_constant("shadow_offset_y", "Label", 2)

	theme.set_stylebox("panel", "PanelContainer", _panel(NAVY, BRASS_DARK, 2, 8, 12))
	theme.set_stylebox("normal", "Button", _button(NAVY, BRASS_DARK, 1))
	theme.set_stylebox("hover", "Button", _button(Color("#29364a"), BRASS_LIGHT, 2))
	theme.set_stylebox("pressed", "Button", _button(Color("#101927"), BRASS, 1))
	theme.set_stylebox("focus", "Button", _outline(BRASS_LIGHT, 2, 7))
	theme.set_stylebox("disabled", "Button", _button(Color("#22262c"), Color("#5d5549"), 0))
	theme.set_color("font_color", "Button", PARCHMENT_LIGHT)
	theme.set_color("font_hover_color", "Button", Color.WHITE)
	theme.set_color("font_pressed_color", "Button", BRASS_LIGHT)
	theme.set_color("font_disabled_color", "Button", Color("#7f7a70"))

	for control_type in ["OptionButton", "LineEdit"]:
		theme.set_stylebox("normal", control_type, _button(NAVY_DEEP, BRASS_DARK, 0))
		theme.set_stylebox("focus", control_type, _outline(BRASS_LIGHT, 2, 7))
		theme.set_color("font_color", control_type, PARCHMENT_LIGHT)

	theme.set_stylebox("panel", "PopupMenu", _panel(NAVY_DEEP, BRASS_DARK, 2, 6, 8))
	theme.set_color("font_color", "PopupMenu", PARCHMENT_LIGHT)
	theme.set_color("font_hover_color", "PopupMenu", Color.WHITE)
	theme.set_stylebox("hover", "PopupMenu", _flat(Color("#3a3440"), 4))

	theme.set_stylebox("normal", "RichTextLabel", _panel(Color("#101a27"), BRASS_DARK, 1, 5, 8))
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
	return Color("#c4b99f")

## Procedural house glyph shared by every return-to-menu button. Drawn as a
## brass roof triangle over a body block with a door cutout, so the app needs
## no icon asset files.
static func home_icon(size: int = 28) -> ImageTexture:
	var image := Image.create_empty(size, size, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
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
	var style := _panel(PARCHMENT, BRASS_DARK, 3, 9, 18)
	style.border_color = BRASS
	style.shadow_color = Color(0.02, 0.015, 0.01, 0.72)
	style.shadow_size = 12
	return style

static func dark_plaque() -> StyleBoxFlat:
	var style := _panel(Color(0.055, 0.075, 0.105, 0.95), BRASS, 3, 10, 24)
	style.shadow_color = Color(0.01, 0.01, 0.015, 0.82)
	style.shadow_size = 14
	return style

static func command_bridge_style() -> StyleBoxFlat:
	var style := _panel(
		Color(0.035, 0.068, 0.096, 0.96), Color.TRANSPARENT, 0, 10, 10
	)
	style.border_color = Color("#789096", 0.30)
	style.set_border_width(SIDE_BOTTOM, 1)
	style.shadow_color = Color(0.01, 0.02, 0.03, 0.48)
	style.shadow_size = 5
	return style

static func command_dock_style() -> StyleBoxFlat:
	var style := _panel(
		Color(0.025, 0.052, 0.075, 0.97), Color("#789096", 0.28), 1, 12, 8
	)
	style.shadow_color = Color(0.01, 0.02, 0.03, 0.56)
	style.shadow_size = 6
	return style

static func instrument_style(
	accent: Color, tint: float, border_alpha: float, glow: int, margin: float = 8.0
) -> StyleBoxFlat:
	var fill := Color("#0c1a25").lerp(accent.darkened(0.62), tint)
	var style := _panel(fill, Color(accent, border_alpha * 0.74), 1, 10, margin)
	style.shadow_color = Color(accent, 0.10 if glow > 0 else 0.0)
	style.shadow_size = mini(glow, 3)
	return style

static func card_style(color: Color, tint: float, border_alpha: float, glow: int) -> StyleBoxFlat:
	var style := _panel(NAVY_DEEP.lerp(color.darkened(0.28), tint), Color(color, border_alpha), 2, 6, 7)
	style.shadow_color = Color(color, 0.22 if glow > 0 else 0.0)
	style.shadow_size = glow
	return style

static func _button(fill: Color, border: Color, shadow: int) -> StyleBoxFlat:
	var style := _panel(fill, border, 2, 6, 10)
	style.shadow_color = Color(0.02, 0.015, 0.01, 0.65 if shadow > 0 else 0.0)
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
