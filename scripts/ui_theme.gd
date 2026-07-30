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
	theme.set_color("separator", "HSeparator", Color(BRASS_DARK, 0.85))
	theme.set_color("separator", "VSeparator", Color(BRASS_DARK, 0.85))
	theme.set_constant("separation", "HSeparator", 2)
	theme.set_constant("separation", "VSeparator", 2)
	return theme

static func title_color() -> Color:
	return BRASS_LIGHT

static func muted_color() -> Color:
	return Color("#c4b99f")

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
