class_name AnimeMechaCreatorView
extends Control

const ConceptCatalog = preload("res://scripts/mecha_concept_catalog.gd")

var recipe: Dictionary = ConceptCatalog.default_recipe()
var animation_enabled := true
var show_hardpoints := false
var _elapsed := 0.0
var _body_textures: Dictionary = {}
var _weapon_textures: Dictionary = {}

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	for faction in ConceptCatalog.FACTIONS:
		_body_textures[faction] = load(ConceptCatalog.BODY_PATHS[faction]) as Texture2D
		_weapon_textures[faction] = load(ConceptCatalog.WEAPON_SHEET_PATHS[faction]) as Texture2D
	set_process(true)
	queue_redraw()

func _process(delta: float) -> void:
	if animation_enabled and is_visible_in_tree():
		_elapsed += delta
		queue_redraw()

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		queue_redraw()

func set_recipe(value: Dictionary) -> void:
	recipe = ConceptCatalog.normalize(value)
	_elapsed = 0.0
	queue_redraw()

func set_animation_enabled(value: bool) -> void:
	animation_enabled = value
	queue_redraw()

func set_show_hardpoints(value: bool) -> void:
	show_hardpoints = value
	queue_redraw()

func textures_ready() -> bool:
	return _body_textures.values().all(func(texture): return texture != null) \
		and _weapon_textures.values().all(func(texture): return texture != null)

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color("#061117"))
	_draw_grid()
	var strip_height := clampf(size.y * 0.235, 104.0, 126.0)
	var hero_rect := Rect2(Vector2(0, 0), Vector2(size.x, size.y - strip_height))
	var strip_rect := Rect2(Vector2(0, hero_rect.end.y), Vector2(size.x, strip_height))
	_draw_hero(hero_rect)
	_draw_board_scale_strip(strip_rect)

func _draw_grid() -> void:
	var color := Color("#38c7d6", 0.07)
	for x in range(18, int(size.x), 32):
		draw_line(Vector2(x, 0), Vector2(x, size.y), color, 1.0)
	for y in range(18, int(size.y), 32):
		draw_line(Vector2(0, y), Vector2(size.x, y), color, 1.0)

func _draw_hero(rect: Rect2) -> void:
	var body: Texture2D = _body_textures.get(recipe.faction)
	var weapons: Texture2D = _weapon_textures.get(recipe.faction)
	if body == null or weapons == null:
		_draw_missing(rect)
		return
	var phase := fmod(_elapsed * 0.82, 1.0) if animation_enabled else 0.0
	var firing: bool = recipe.pose == "Fire Cycle"
	var fire_amount := _fire_amount(phase) if firing else 0.0
	var bob := sin(_elapsed * 1.8) * 2.2 if animation_enabled else 0.0
	var body_size := minf(rect.size.y * 0.98, rect.size.x * 0.57)
	var body_center := Vector2(rect.size.x * 0.37, rect.position.y + rect.size.y * 0.51 + bob)
	var body_rect := Rect2(body_center - Vector2.ONE * body_size * 0.5, Vector2.ONE * body_size)
	draw_texture_rect(body, body_rect, false)

	var weapon_size := Vector2(body_size * 1.07, body_size * 0.357)
	var mount := body_center + Vector2(body_size * 0.14, -body_size * 0.015)
	var weapon_rect := Rect2(
		mount - Vector2(weapon_size.x * 0.15 + fire_amount * 9.0, weapon_size.y * 0.50),
		weapon_size
	)
	_draw_weapon_region(weapons, weapon_rect, int(_weapon().row))
	if firing:
		_draw_muzzle_flash(weapon_rect, fire_amount)
	if show_hardpoints:
		_draw_hardpoint(weapon_rect.position + Vector2(weapon_rect.size.x * 0.085, weapon_rect.size.y * 0.50))
		_draw_hardpoint(body_center + Vector2(body_size * 0.23, body_size * 0.11))

	var font := get_theme_default_font()
	draw_string(
		font, rect.position + Vector2(14, 21),
		"AUTHORED BODY MASTER  ·  SEPARATE WEAPON LAYER",
		HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color("#9db4ba")
	)

func _draw_board_scale_strip(rect: Rect2) -> void:
	draw_rect(rect, Color("#0a1a22", 0.97))
	draw_line(rect.position, Vector2(rect.end.x, rect.position.y), Color("#38c7d6", 0.44), 2.0)
	var font := get_theme_default_font()
	draw_string(
		font, rect.position + Vector2(14, 20),
		"BATTLEFIELD READ  ·  THREE LANES  ·  ~110 PX FIGURES",
		HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color("#b8f3f5")
	)
	var body: Texture2D = _body_textures.get(recipe.faction)
	var weapons: Texture2D = _weapon_textures.get(recipe.faction)
	if body == null or weapons == null:
		return
	var weapons_for_faction := ConceptCatalog.weapons_for(recipe.faction)
	var figure_size := minf(112.0, rect.size.y - 24.0)
	var spacing := rect.size.x / 3.0
	for index in 3:
		var center := Vector2(spacing * (index + 0.5), rect.end.y - figure_size * 0.44)
		var body_rect := Rect2(center - Vector2.ONE * figure_size * 0.5, Vector2.ONE * figure_size)
		draw_texture_rect(body, body_rect, false)
		var weapon_rect := Rect2(
			center + Vector2(figure_size * 0.05, -figure_size * 0.17),
			Vector2(figure_size * 0.93, figure_size * 0.31)
		)
		_draw_weapon_region(weapons, weapon_rect, int(weapons_for_faction[index].row))
		_draw_lane_footprint(center + Vector2(figure_size * 0.12, figure_size * 0.43), figure_size, index)

func _draw_weapon_region(sheet: Texture2D, destination: Rect2, row: int) -> void:
	var row_height := sheet.get_height() / 3.0
	var source := Rect2(0, row_height * row, sheet.get_width(), row_height)
	draw_texture_rect_region(sheet, destination, source)

func _draw_lane_footprint(center: Vector2, figure_size: float, lane: int) -> void:
	var lane_color := Color("#38c7d6", 0.18 + lane * 0.04)
	var points := PackedVector2Array([
		center + Vector2(-figure_size * 0.42, -5),
		center + Vector2(figure_size * 0.28, -5),
		center + Vector2(figure_size * 0.42, 6),
		center + Vector2(-figure_size * 0.28, 6)
	])
	draw_colored_polygon(points, lane_color)
	var outline := points.duplicate()
	outline.append(points[0])
	draw_polyline(outline, Color("#38c7d6", 0.42), 1.0, true)

func _draw_hardpoint(center: Vector2) -> void:
	draw_circle(center, 7.0, Color("#ff5470", 0.38))
	draw_arc(center, 10.0, 0, TAU, 20, Color("#ff96a8"), 2.0)
	draw_line(center - Vector2(14, 0), center + Vector2(14, 0), Color("#ff96a8"), 1.0)
	draw_line(center - Vector2(0, 14), center + Vector2(0, 14), Color("#ff96a8"), 1.0)

func _draw_muzzle_flash(weapon_rect: Rect2, amount: float) -> void:
	if amount <= 0.02:
		return
	var muzzle := Vector2(weapon_rect.end.x - weapon_rect.size.x * 0.02, weapon_rect.get_center().y)
	var radius := 5.0 + amount * 16.0
	draw_circle(muzzle, radius * 1.5, Color("#53f2ff", amount * 0.13))
	draw_circle(muzzle, radius * 0.52, Color("#f5ffff", amount * 0.94))
	for ray in 6:
		var direction := Vector2.from_angle(ray * TAU / 6.0)
		draw_line(muzzle + direction * 4.0, muzzle + direction * radius, Color("#7ff3ff", amount), 2.0, true)

func _fire_amount(phase: float) -> float:
	if phase < 0.28:
		return phase / 0.28
	if phase < 0.46:
		return 1.0 - (phase - 0.28) / 0.18
	return 0.0

func _weapon() -> Dictionary:
	return ConceptCatalog.weapon_by_id(recipe.faction, recipe.weapon)

func _draw_missing(rect: Rect2) -> void:
	var font := get_theme_default_font()
	draw_string(font, rect.get_center(), "CONCEPT ASSET NOT IMPORTED", HORIZONTAL_ALIGNMENT_CENTER, 300, 14, Color("#ef6078"))
