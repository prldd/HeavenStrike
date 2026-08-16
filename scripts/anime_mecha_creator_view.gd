class_name AnimeMechaCreatorView
extends Control

const ConceptCatalog = preload("res://scripts/mecha_concept_catalog.gd")

var recipe: Dictionary = ConceptCatalog.default_recipe()
var animation_enabled := true
var show_hardpoints := false
var _elapsed := 0.0
var _parts: Dictionary = {}
var _weapon_textures: Dictionary = {}
var _part_bounds: Dictionary = {}
var _last_hand_hardpoints: Array[Vector2] = []
var _last_weapon_hardpoints: Array[Vector2] = []

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	for faction in ConceptCatalog.FACTIONS:
		var faction_parts := {}
		for part_name in ConceptCatalog.PART_NAMES:
			var texture := load(
				ConceptCatalog.part_path(faction, part_name)
			) as Texture2D
			faction_parts[part_name] = texture
			if texture != null:
				_part_bounds[texture.resource_path] = _solid_content_rect(texture.get_image())
		_parts[faction] = faction_parts
		_weapon_textures[faction] = load(
			ConceptCatalog.WEAPON_SHEET_PATHS[faction]
		) as Texture2D
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
	if _parts.size() != ConceptCatalog.FACTIONS.size():
		return false
	for faction in ConceptCatalog.FACTIONS:
		if not _parts.has(faction) or _parts[faction].size() != ConceptCatalog.PART_NAMES.size():
			return false
		if not _parts[faction].values().all(func(texture): return texture != null):
			return false
	return _weapon_textures.values().all(func(texture): return texture != null)

func part_count() -> int:
	return _parts.values().reduce(func(total, faction_parts): return total + faction_parts.size(), 0)

func weapon_hardpoints_connected() -> bool:
	if recipe["class"] == "Duelist":
		return true
	var skeleton := _skeleton(recipe.pose, recipe["class"], 0.22)
	var rear_grip := Vector2(skeleton.hand_left)
	var support_grip := rear_grip + Vector2((0.30 - 0.085) * 330.0, 0)
	return rear_grip.distance_to(Vector2(skeleton.hand_left)) <= 0.01 \
		and support_grip.distance_to(Vector2(skeleton.hand_right)) <= 0.01

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color("#061117"))
	_draw_grid()
	var strip_height := clampf(size.y * 0.235, 104.0, 126.0)
	var hero_rect := Rect2(Vector2.ZERO, Vector2(size.x, size.y - strip_height))
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
	if not textures_ready():
		_draw_missing(rect)
		return
	var phase := fmod(_elapsed * 0.82, 1.0) if animation_enabled else 0.18
	var rig_scale := minf(rect.size.y / 330.0, rect.size.x / 650.0)
	var origin := Vector2(rect.size.x * 0.34, rect.end.y - 5.0)
	_draw_rig(origin, rig_scale, recipe, phase, true)
	var font := get_theme_default_font()
	draw_string(
		font, rect.position + Vector2(14, 21),
		"17 ARTICULATED PARTS  ·  WRIST → HAND → WEAPON GRIP",
		HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color("#9db4ba")
	)

func _draw_board_scale_strip(rect: Rect2) -> void:
	draw_rect(rect, Color("#0a1a22", 0.97))
	draw_line(rect.position, Vector2(rect.end.x, rect.position.y), Color("#38c7d6", 0.44), 2.0)
	var font := get_theme_default_font()
	draw_string(
		font, rect.position + Vector2(14, 20),
		"BATTLEFIELD READ  ·  IDLE / TRAVERSE / ATTACK  ·  ~110 PX",
		HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color("#b8f3f5")
	)
	var spacing := rect.size.x / 3.0
	var poses := ["Idle", "Traverse", "Attack"]
	for index in 3:
		var sample: Dictionary = recipe.duplicate()
		sample.pose = poses[index]
		if sample["class"] == "Artillerist":
			var loadouts := ConceptCatalog.loadouts_for(sample.faction, sample["class"])
			sample.weapon = loadouts[index].id
		var origin := Vector2(spacing * (index + 0.5), rect.end.y - 1.0)
		_draw_lane_footprint(origin + Vector2(7, -2), 112.0, index)
		_draw_rig(origin, 0.30, sample, 0.22 + index * 0.19, false)

func _draw_rig(
	origin: Vector2, rig_scale: float, active_recipe: Dictionary,
	phase: float, record_connections: bool
) -> void:
	var faction: String = active_recipe.faction
	var pose: String = active_recipe.pose
	var kind: String = active_recipe["class"]
	var parts: Dictionary = _parts[faction]
	var skeleton := _skeleton(pose, kind, phase)
	var point := func(name: String) -> Vector2:
		return origin + Vector2(skeleton[name]) * rig_scale
	var height := func(value: float) -> float:
		return value * rig_scale

	var shadow_center := origin + Vector2(3, -2) * rig_scale
	draw_ellipse(shadow_center, 72.0 * rig_scale, 14.0 * rig_scale, Color("#01070a", 0.62))

	# Back accessory and far-side limbs establish the faction silhouette before
	# the torso and near-side arm chains are layered over them.
	_draw_part(parts.accessory, point.call("pelvis"), Vector2(0.50, 0.88), height.call(165), 0.0)
	_draw_leg(parts, "right", skeleton, origin, rig_scale)
	_draw_leg(parts, "left", skeleton, origin, rig_scale)
	_draw_part(parts.torso, point.call("pelvis"), Vector2(0.50, 0.91), height.call(155), float(skeleton.torso_angle))

	var loadout := ConceptCatalog.loadout_by_id(faction, kind, active_recipe.weapon)
	var hand_targets: Array[Vector2] = []
	var weapon_targets: Array[Vector2] = []
	if int(loadout.row) >= 0:
		var weapon_rect: Rect2 = _weapon_rect(origin, rig_scale, skeleton)
		_draw_weapon_region(_weapon_textures[faction], weapon_rect, int(loadout.row))
		hand_targets = [point.call("hand_left"), point.call("hand_right")]
		weapon_targets = [
			weapon_rect.position + Vector2(weapon_rect.size.x * 0.085, weapon_rect.size.y * 0.50),
			weapon_rect.position + Vector2(weapon_rect.size.x * 0.30, weapon_rect.size.y * 0.50)
		]
		if pose == "Attack":
			_draw_muzzle_flash(weapon_rect, float(skeleton.attack_amount))

	_draw_rig_joints(skeleton, origin, rig_scale, faction)
	_draw_part(parts.shoulder_right, point.call("shoulder_right"), Vector2(0.50, 0.54), height.call(66), 0.0)
	_draw_arm(parts, "right", skeleton, origin, rig_scale)
	_draw_part(parts.shoulder_left, point.call("shoulder_left"), Vector2(0.50, 0.54), height.call(66), 0.0)
	_draw_arm(parts, "left", skeleton, origin, rig_scale)
	_draw_part(parts.head, point.call("neck"), Vector2(0.50, 0.88), height.call(72), float(skeleton.head_angle))

	if record_connections:
		_last_hand_hardpoints = hand_targets
		_last_weapon_hardpoints = weapon_targets
	if show_hardpoints and record_connections:
		for hardpoint in hand_targets:
			_draw_hardpoint(hardpoint, Color("#71f1a8"), 11.0)
		for hardpoint in weapon_targets:
			_draw_hardpoint(hardpoint, Color("#ff96a8"), 7.0)
		for socket_name in ["neck", "shoulder_left", "shoulder_right", "hip_left", "hip_right"]:
			_draw_hardpoint(point.call(socket_name), Color("#7fdcff"), 6.0)

func _draw_arm(
	parts: Dictionary, side: String, skeleton: Dictionary,
	origin: Vector2, rig_scale: float
) -> void:
	var shoulder: Vector2 = origin + Vector2(skeleton["shoulder_%s" % side]) * rig_scale
	var elbow: Vector2 = origin + Vector2(skeleton["elbow_%s" % side]) * rig_scale
	var hand: Vector2 = origin + Vector2(skeleton["hand_%s" % side]) * rig_scale
	_draw_segment(parts["upper_arm_%s" % side], shoulder, elbow, 1.34)
	_draw_segment(parts["forearm_%s" % side], elbow, hand, 1.34)
	var wrist_angle := (hand - elbow).angle() - PI * 0.5
	_draw_part(parts["hand_%s" % side], hand, Vector2(0.50, 0.10), 46.0 * rig_scale, wrist_angle)

func _draw_leg(
	parts: Dictionary, side: String, skeleton: Dictionary,
	origin: Vector2, rig_scale: float
) -> void:
	var hip: Vector2 = origin + Vector2(skeleton["hip_%s" % side]) * rig_scale
	var knee: Vector2 = origin + Vector2(skeleton["knee_%s" % side]) * rig_scale
	var ankle: Vector2 = origin + Vector2(skeleton["ankle_%s" % side]) * rig_scale
	_draw_segment(parts["thigh_%s" % side], hip, knee, 1.34)
	_draw_segment(parts["shin_%s" % side], knee, ankle, 1.34)
	_draw_part(parts["foot_%s" % side], ankle, Vector2(0.48, 0.16), 48.0 * rig_scale, 0.0)

func _draw_segment(texture: Texture2D, from: Vector2, to: Vector2, length_scale: float) -> void:
	var vector := to - from
	_draw_part(
		texture, from, Vector2(0.50, 0.10), vector.length() * length_scale,
		vector.angle() - PI * 0.5
	)

func _draw_part(
	texture: Texture2D, anchor: Vector2, pivot_ratio: Vector2,
	target_height: float, rotation: float
) -> void:
	if texture == null or target_height <= 0.0:
		return
	var content_rect: Rect2i = _part_bounds.get(
		texture.resource_path, Rect2i(Vector2i.ZERO, Vector2i(texture.get_size()))
	)
	var content_size := Vector2(content_rect.size)
	var part_scale := target_height / content_size.y
	var pivot := Vector2(content_size.x * pivot_ratio.x, content_size.y * pivot_ratio.y)
	draw_set_transform(anchor, rotation, Vector2.ONE * part_scale)
	draw_texture_rect_region(
		texture, Rect2(-pivot, content_size), Rect2(content_rect)
	)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _solid_content_rect(image: Image) -> Rect2i:
	# Background extraction can leave isolated opaque flecks. Ignore rows and
	# columns without enough coverage so those flecks cannot distort pivots.
	var width := image.get_width()
	var height := image.get_height()
	var min_row_pixels := maxi(2, int(width * 0.025))
	var min_column_pixels := maxi(2, int(height * 0.025))
	var top := height
	var bottom := -1
	for y in height:
		var count := 0
		for x in width:
			if image.get_pixel(x, y).a >= 0.20:
				count += 1
		if count >= min_row_pixels:
			top = mini(top, y)
			bottom = maxi(bottom, y)
	var left := width
	var right := -1
	for x in width:
		var count := 0
		for y in height:
			if image.get_pixel(x, y).a >= 0.20:
				count += 1
		if count >= min_column_pixels:
			left = mini(left, x)
			right = maxi(right, x)
	if right < left or bottom < top:
		return image.get_used_rect()
	return Rect2i(left, top, right - left + 1, bottom - top + 1).grow(2).intersection(
		Rect2i(0, 0, width, height)
	)

func _draw_rig_joints(
	skeleton: Dictionary, origin: Vector2, rig_scale: float, faction: String
) -> void:
	var accent := Color("#ff8b3d") if faction == "Coal" else Color("#63eafb")
	for socket_name in [
		"neck", "shoulder_left", "shoulder_right", "elbow_left", "elbow_right",
		"hand_left", "hand_right", "hip_left", "hip_right", "knee_left",
		"knee_right", "ankle_left", "ankle_right"
	]:
		var center := origin + Vector2(skeleton[socket_name]) * rig_scale
		var radius := (6.5 if socket_name.contains("hand") else 8.5) * rig_scale
		draw_circle(center, radius + 2.0, Color("#061016"))
		draw_circle(center, radius, Color("#182a32"))
		draw_arc(center, radius * 0.72, 0, TAU, 18, Color(accent, 0.82), 2.0)

func _skeleton(pose: String, kind: String, phase: float) -> Dictionary:
	var gait := sin(phase * TAU) if pose == "Traverse" else 0.0
	var idle := sin(phase * TAU) if pose == "Idle" else 0.0
	var attack_amount := sin(clampf(phase / 0.58, 0.0, 1.0) * PI) if pose == "Attack" else 0.0
	var pelvis := Vector2(0, -137 - absf(gait) * 5.0 + idle * 1.5)
	var result := {
		"pelvis": pelvis,
		"neck": pelvis + Vector2(2, -125),
		"shoulder_left": pelvis + Vector2(-62, -88),
		"shoulder_right": pelvis + Vector2(62, -88),
		"hip_left": pelvis + Vector2(-31, 1),
		"hip_right": pelvis + Vector2(31, 1),
		"knee_left": pelvis + Vector2(-39 + gait * 22, 66),
		"knee_right": pelvis + Vector2(39 - gait * 22, 66),
		"ankle_left": pelvis + Vector2(-48 - gait * 17, 132),
		"ankle_right": pelvis + Vector2(48 + gait * 17, 132),
		"torso_angle": gait * 0.025,
		"head_angle": -gait * 0.045 + idle * 0.018,
		"attack_amount": attack_amount
	}
	if kind == "Artillerist":
		var recoil := attack_amount * 8.0
		result.hand_left = pelvis + Vector2(15 - recoil, -42)
		result.hand_right = Vector2(result.hand_left) + Vector2((0.30 - 0.085) * 330.0, 0)
		result.elbow_left = _ik_elbow(result.shoulder_left, result.hand_left, -28.0)
		result.elbow_right = _ik_elbow(result.shoulder_right, result.hand_right, 24.0)
	else:
		var arm_swing := gait * 27.0
		result.hand_left = pelvis + Vector2(-78 - arm_swing, -3)
		result.hand_right = pelvis + Vector2(78 + arm_swing, -3)
		if pose == "Attack":
			result.hand_left = pelvis + Vector2(-8, -72)
			result.hand_right = pelvis + Vector2(95 + attack_amount * 72.0, -89 - attack_amount * 18.0)
			result.torso_angle = -attack_amount * 0.08
		result.elbow_left = _ik_elbow(result.shoulder_left, result.hand_left, -24.0)
		result.elbow_right = _ik_elbow(result.shoulder_right, result.hand_right, 24.0)
	return result

func _ik_elbow(shoulder: Vector2, hand: Vector2, bend: float) -> Vector2:
	var direction := hand - shoulder
	var perpendicular := direction.normalized().orthogonal()
	return shoulder.lerp(hand, 0.52) + perpendicular * bend

func _weapon_rect(origin: Vector2, rig_scale: float, skeleton: Dictionary) -> Rect2:
	var rear_grip: Vector2 = origin + Vector2(skeleton.hand_left) * rig_scale
	var weapon_size := Vector2(330, 110) * rig_scale
	return Rect2(
		rear_grip - Vector2(weapon_size.x * 0.085, weapon_size.y * 0.50),
		weapon_size
	)

func _draw_weapon_region(sheet: Texture2D, destination: Rect2, row: int) -> void:
	var row_height := sheet.get_height() / 3.0
	draw_texture_rect_region(
		sheet, destination,
		Rect2(0, row_height * row, sheet.get_width(), row_height)
	)

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

func _draw_hardpoint(center: Vector2, color: Color, radius: float = 8.0) -> void:
	draw_circle(center, radius * 0.62, Color(color, 0.32))
	draw_arc(center, radius, 0, TAU, 20, color, 2.0)
	draw_line(center - Vector2(radius + 3, 0), center + Vector2(radius + 3, 0), color, 1.0)
	draw_line(center - Vector2(0, radius + 3), center + Vector2(0, radius + 3), color, 1.0)

func _draw_muzzle_flash(weapon_rect: Rect2, amount: float) -> void:
	if amount <= 0.02:
		return
	var muzzle := Vector2(weapon_rect.end.x - weapon_rect.size.x * 0.02, weapon_rect.get_center().y)
	var radius := 5.0 + amount * 16.0
	draw_circle(muzzle, radius * 1.5, Color("#53f2ff", amount * 0.13))
	draw_circle(muzzle, radius * 0.52, Color("#f5ffff", amount * 0.94))

func _draw_missing(rect: Rect2) -> void:
	var font := get_theme_default_font()
	draw_string(font, rect.get_center(), "ARTICULATED PARTS NOT IMPORTED", HORIZONTAL_ALIGNMENT_CENTER, 320, 14, Color("#ef6078"))
