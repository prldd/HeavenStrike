class_name UnitCreatorView
extends Control

const AssemblyCatalog = preload("res://scripts/unit_assembly_catalog.gd")

var recipe: Dictionary = AssemblyCatalog.default_recipe()
var animation_enabled := true
var show_pivots := false
var _elapsed := 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
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
	recipe = AssemblyCatalog.normalize(value)
	_elapsed = 0.0
	queue_redraw()

func set_animation_enabled(value: bool) -> void:
	animation_enabled = value
	queue_redraw()

func set_show_pivots(value: bool) -> void:
	show_pivots = value
	queue_redraw()

func _draw() -> void:
	var frame := Rect2(Vector2.ZERO, size)
	draw_rect(frame, Color("#07131a"))
	_draw_bay(frame)
	var scale_factor := minf(size.x / 410.0, size.y / 550.0)
	var origin := Vector2(size.x * 0.50, size.y * 0.84)
	draw_set_transform(origin, 0.0, Vector2(scale_factor, scale_factor))
	_draw_robot()
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _draw_bay(frame: Rect2) -> void:
	var grid_color := Color("#38c7d6", 0.075)
	for x in range(20, int(frame.size.x), 32):
		draw_line(Vector2(x, 0), Vector2(x, frame.size.y), grid_color, 1.0)
	for y in range(18, int(frame.size.y), 32):
		draw_line(Vector2(0, y), Vector2(frame.size.x, y), grid_color, 1.0)
	var center := Vector2(frame.size.x * 0.5, frame.size.y * 0.85)
	_draw_ellipse_shape(center, Vector2(frame.size.x * 0.31, 25), Color("#02090d", 0.78))
	draw_arc(center, frame.size.x * 0.31, PI, TAU, 40, Color("#38c7d6", 0.22), 2.0)
	for ring in 3:
		draw_arc(center, 70.0 + ring * 42.0, PI * 1.08, PI * 1.92, 32, Color("#38c7d6", 0.12), 1.0)

func _draw_robot() -> void:
	var colors := AssemblyCatalog.palette(recipe.faction, recipe.finish)
	var kind: String = recipe["class"]
	var frame: String = recipe.frame
	var phase := _pose_phase()
	var bob := sin(_elapsed * 2.2) * 3.0 if animation_enabled else 0.0
	if recipe.pose == "Traverse":
		bob = absf(sin(phase * TAU)) * -7.0
	var hip := Vector2(0, -158 + bob)
	var torso := Vector2(0, -265 + bob)
	var shoulder_width := 72.0
	var torso_width := 68.0
	match frame:
		"Bulwark":
			shoulder_width = 98.0
			torso_width = 86.0
		"Swift":
			shoulder_width = 60.0
			torso_width = 54.0
		"Resonant":
			shoulder_width = 76.0
			torso_width = 62.0

	var gait := sin(phase * TAU) if recipe.pose == "Traverse" else 0.0
	var left_foot := Vector2(-42.0 - gait * 24.0, 0)
	var right_foot := Vector2(42.0 + gait * 24.0, 0)
	_draw_leg(hip + Vector2(-24, 0), left_foot, colors, frame, true)
	_draw_leg(hip + Vector2(24, 0), right_foot, colors, frame, false)
	_draw_waist(hip, torso, torso_width, colors, frame)

	_draw_back_attachment(torso, colors, kind, frame, phase)
	_draw_torso(torso, torso_width, colors, frame)
	_draw_core(torso + Vector2(0, 10), colors, frame, phase)

	var left_shoulder := torso + Vector2(-shoulder_width, -18)
	var right_shoulder := torso + Vector2(shoulder_width, -18)
	_draw_joint(left_shoulder, 18.0, colors)
	_draw_joint(right_shoulder, 18.0, colors)
	var attack := _attack_amount(phase)
	var left_hand := left_shoulder + Vector2(-34, 92)
	var right_hand := right_shoulder + Vector2(34, 92)
	if recipe.pose == "Traverse":
		left_hand.x += gait * 28.0
		right_hand.x -= gait * 28.0
	match kind:
		"Warden":
			left_hand = left_shoulder + Vector2(-42, 72 - attack * 20)
			right_hand = right_shoulder + Vector2(50 + attack * 28, 42 - attack * 30)
		"Duelist":
			right_hand = right_shoulder + Vector2(25 + attack * 62, 70 - attack * 65)
		"Strider":
			left_hand = left_shoulder + Vector2(-38 - attack * 32, 76 - attack * 36)
			right_hand = right_shoulder + Vector2(38 + attack * 32, 76 - attack * 36)
		"Artillerist":
			right_hand = right_shoulder + Vector2(66, 12)
			left_hand = torso + Vector2(25, 30)
		"Channeler", "Lifebinder":
			left_hand = left_shoulder + Vector2(-48 - attack * 12, 54 - attack * 40)
			right_hand = right_shoulder + Vector2(48 + attack * 12, 54 - attack * 40)

	_draw_arm(left_shoulder, left_hand, colors, frame)
	_draw_arm(right_shoulder, right_hand, colors, frame)
	_draw_class_kit(kind, torso, left_hand, right_hand, colors, phase, attack)
	var head_center := torso + Vector2(0, -88)
	_draw_neck(torso, head_center, colors)
	_draw_head(head_center, colors, String(recipe.head), frame)
	_draw_faction_marks(torso, torso_width, colors, String(recipe.faction))

	if show_pivots:
		for point in [hip, torso, left_shoulder, right_shoulder, left_hand, right_hand]:
			draw_circle(point, 5.0, Color("#ff5470"))
			draw_arc(point, 9.0, 0, TAU, 16, Color.WHITE, 1.5)

func _draw_waist(hip: Vector2, torso: Vector2, torso_width: float, colors: Dictionary, frame: String) -> void:
	var waist_top := torso + Vector2(0, 50)
	draw_line(hip, waist_top, colors.edge, 32.0 if frame == "Bulwark" else 25.0, true)
	draw_line(hip, waist_top, colors.joint, 23.0 if frame == "Bulwark" else 17.0, true)
	var pelvis_width := minf(torso_width * 0.66, 54.0)
	_poly(PackedVector2Array([
		hip + Vector2(-pelvis_width, -22), hip + Vector2(pelvis_width, -22),
		hip + Vector2(pelvis_width - 9, 18), hip + Vector2(-pelvis_width + 9, 18)
	]), colors.armor.darkened(0.08), colors.edge, 5.0)
	draw_line(hip + Vector2(-pelvis_width + 12, -12), hip + Vector2(pelvis_width - 12, -12), colors.trim, 4.0)

func _draw_neck(torso: Vector2, head_center: Vector2, colors: Dictionary) -> void:
	var neck_bottom := torso + Vector2(0, -42)
	var neck_top := head_center + Vector2(0, 20)
	draw_line(neck_bottom, neck_top, colors.edge, 28.0, true)
	draw_line(neck_bottom, neck_top, colors.joint, 18.0, true)
	draw_line(neck_bottom, neck_top, colors.trim, 4.0, true)

func _pose_phase() -> float:
	if not animation_enabled:
		return 0.22 if recipe.pose == "Attack" else 0.0
	var speed := 0.72 if recipe.pose == "Idle" else 1.18
	return fmod(_elapsed * speed, 1.0)

func _attack_amount(phase: float) -> float:
	if recipe.pose != "Attack":
		return 0.0
	return sin(clampf(phase / 0.72, 0.0, 1.0) * PI)

func _draw_leg(hip: Vector2, foot: Vector2, colors: Dictionary, frame: String, left: bool) -> void:
	var knee := hip.lerp(foot, 0.52)
	knee.x += (-24.0 if left else 24.0) if frame != "Swift" else (18.0 if left else -18.0)
	_draw_limb_segment(hip, knee, 25.0 if frame == "Bulwark" else 18.0, colors)
	_draw_joint(knee, 14.0, colors)
	_draw_limb_segment(knee, foot + Vector2(0, -13), 21.0 if frame == "Bulwark" else 15.0, colors)
	var foot_points := PackedVector2Array([
		foot + Vector2(-24, -13), foot + Vector2(22, -13), foot + Vector2(34, 0),
		foot + Vector2(-30, 0)
	])
	_poly(foot_points, colors.armor, colors.edge, 4.0)
	_draw_joint(hip, 17.0, colors)

func _draw_arm(shoulder: Vector2, hand: Vector2, colors: Dictionary, frame: String) -> void:
	var elbow := shoulder.lerp(hand, 0.52) + Vector2(signf(hand.x) * 13.0, 5)
	var width := 24.0 if frame == "Bulwark" else 16.0
	_draw_limb_segment(shoulder, elbow, width, colors)
	_draw_joint(elbow, width * 0.58, colors)
	_draw_limb_segment(elbow, hand, width * 0.82, colors)
	_draw_joint(hand, 10.0, colors)

func _draw_limb_segment(from: Vector2, to: Vector2, width: float, colors: Dictionary) -> void:
	draw_line(from, to, colors.edge, width + 7.0, true)
	draw_line(from, to, colors.armor, width, true)
	draw_line(from, to, Color(colors.trim, 0.72), maxf(3.0, width * 0.18), true)

func _draw_joint(at: Vector2, radius: float, colors: Dictionary) -> void:
	draw_circle(at, radius + 3.0, colors.edge)
	draw_circle(at, radius, colors.joint)
	draw_arc(at, radius * 0.70, 0, TAU, 16, colors.trim, 3.0)

func _draw_torso(center: Vector2, width: float, colors: Dictionary, frame: String) -> void:
	var height := 106.0 if frame == "Bulwark" else 96.0
	var taper := 18.0 if frame == "Swift" else 8.0
	var points := PackedVector2Array([
		center + Vector2(-width, -48), center + Vector2(width, -48),
		center + Vector2(width - taper, 42), center + Vector2(28, height * 0.55),
		center + Vector2(-28, height * 0.55), center + Vector2(-width + taper, 42)
	])
	_poly(points, colors.armor, colors.edge, 6.0)
	draw_line(center + Vector2(-width + 12, -26), center + Vector2(width - 12, -26), Color(colors.trim, 0.68), 5.0)
	if frame == "Resonant":
		for side in [-1, 1]:
			draw_arc(center + Vector2(side * (width + 13), 0), 25, -PI * 0.6, PI * 0.6, 18, colors.energy, 4.0)

func _draw_core(center: Vector2, colors: Dictionary, frame: String, phase: float) -> void:
	var pulse := 1.0 + (sin(phase * TAU) * 0.08 if animation_enabled else 0.0)
	var radius := (24.0 if frame == "Resonant" else 17.0) * pulse
	draw_circle(center, radius + 8.0, colors.edge)
	draw_circle(center, radius + 3.0, Color(colors.energy, 0.24))
	draw_circle(center, radius * 0.56, colors.energy)
	draw_arc(center, radius + 3.0, phase * TAU, phase * TAU + PI * 1.45, 22, colors.trim, 3.0)

func _draw_head(center: Vector2, colors: Dictionary, head: String, frame: String) -> void:
	var width := 43.0 if frame == "Bulwark" else 36.0
	match head:
		"Cyclops":
			_poly(PackedVector2Array([
				center + Vector2(-width, -28), center + Vector2(width, -28),
				center + Vector2(width - 7, 24), center + Vector2(-width + 7, 24)
			]), colors.armor, colors.edge, 5.0)
			draw_circle(center + Vector2(0, -2), 12, colors.edge)
			draw_circle(center + Vector2(0, -2), 6, colors.energy)
		"Crown":
			_poly(PackedVector2Array([
				center + Vector2(-width, 22), center + Vector2(-width + 5, -24),
				center + Vector2(-13, -39), center + Vector2(0, -23),
				center + Vector2(16, -43), center + Vector2(width - 5, -24),
				center + Vector2(width, 22)
			]), colors.armor, colors.edge, 5.0)
			draw_line(center + Vector2(-24, -1), center + Vector2(24, -1), colors.energy, 6.0, true)
		"Sensor Array":
			_poly(PackedVector2Array([
				center + Vector2(-width, -24), center + Vector2(width, -24),
				center + Vector2(width - 10, 24), center + Vector2(-width + 10, 24)
			]), colors.armor, colors.edge, 5.0)
			for x in [-20, 0, 20]:
				draw_circle(center + Vector2(x, -2), 6.0, colors.energy)
			draw_line(center + Vector2(18, -25), center + Vector2(30, -48), colors.trim, 5.0, true)
		_:
			_poly(PackedVector2Array([
				center + Vector2(-width, -24), center + Vector2(width, -24),
				center + Vector2(width - 4, 22), center + Vector2(-width + 4, 22)
			]), colors.armor, colors.edge, 5.0)
			draw_line(center + Vector2(-27, -2), center + Vector2(27, -2), colors.energy, 8.0, true)

func _draw_back_attachment(center: Vector2, colors: Dictionary, kind: String, frame: String, phase: float) -> void:
	if frame == "Bulwark":
		for side in [-1, 1]:
			var plate := PackedVector2Array([
				center + Vector2(side * 50, -45), center + Vector2(side * 104, -25),
				center + Vector2(side * 92, 38), center + Vector2(side * 48, 26)
			])
			_poly(plate, colors.armor.darkened(0.12), colors.edge, 5.0)
	elif frame == "Swift":
		for side in [-1, 1]:
			var fin := PackedVector2Array([
				center + Vector2(side * 36, -35), center + Vector2(side * 92, -78),
				center + Vector2(side * 61, 14)
			])
			_poly(fin, colors.trim, colors.edge, 4.0)
	elif kind == "Channeler" or frame == "Resonant":
		var orbit := center + Vector2(0, -2)
		draw_arc(orbit, 91, phase * TAU, phase * TAU + PI * 1.55, 32, Color(colors.energy, 0.75), 4.0)
		draw_arc(orbit, 105, -phase * TAU, -phase * TAU + PI * 1.2, 32, Color(colors.trim, 0.45), 2.0)

func _draw_class_kit(kind: String, torso: Vector2, left_hand: Vector2, right_hand: Vector2, colors: Dictionary, phase: float, attack: float) -> void:
	match kind:
		"Warden":
			var shield_center := left_hand + Vector2(-28, 10)
			_poly(PackedVector2Array([
				shield_center + Vector2(-35, -58), shield_center + Vector2(31, -48),
				shield_center + Vector2(36, 28), shield_center + Vector2(0, 66),
				shield_center + Vector2(-36, 28)
			]), colors.armor.lightened(0.05), colors.edge, 6.0)
			draw_line(shield_center + Vector2(0, -38), shield_center + Vector2(0, 37), colors.trim, 6.0)
			var hammer_tip := right_hand + Vector2(42 + attack * 35, -28)
			draw_line(right_hand, hammer_tip, colors.edge, 13.0, true)
			draw_line(right_hand, hammer_tip, colors.trim, 7.0, true)
			draw_rect(Rect2(hammer_tip - Vector2(13, 25), Vector2(40, 50)), colors.edge)
			draw_rect(Rect2(hammer_tip - Vector2(8, 20), Vector2(30, 40)), colors.armor)
		"Duelist":
			var blade_tip := right_hand + Vector2(78 + attack * 42, -84 - attack * 18)
			draw_line(right_hand, blade_tip, colors.edge, 18.0, true)
			draw_line(right_hand, blade_tip, colors.trim, 10.0, true)
			draw_line(right_hand + Vector2(5, -5), blade_tip, colors.energy, 3.0, true)
		"Strider":
			for data in [[left_hand, -1.0], [right_hand, 1.0]]:
				var hand: Vector2 = data[0]
				var side: float = data[1]
				var tip := hand + Vector2(side * (58 + attack * 22), -62)
				draw_line(hand, tip, colors.edge, 13.0, true)
				draw_line(hand, tip, colors.energy, 6.0, true)
		"Artillerist":
			var muzzle := right_hand + Vector2(105, -8)
			draw_line(torso + Vector2(20, -52), muzzle, colors.edge, 37.0, true)
			draw_line(torso + Vector2(20, -52), muzzle, colors.armor, 28.0, true)
			draw_line(torso + Vector2(35, -52), muzzle, colors.trim, 7.0, true)
			draw_circle(muzzle, 19.0, colors.edge)
			draw_circle(muzzle, 10.0 + attack * 5.0, colors.energy)
		"Channeler":
			var focus := torso + Vector2(0, -150)
			draw_line(right_hand, focus + Vector2(15, 28), colors.edge, 14.0, true)
			draw_line(right_hand, focus + Vector2(15, 28), colors.trim, 7.0, true)
			draw_circle(focus, 18.0 + attack * 14.0, Color(colors.energy, 0.28))
			draw_arc(focus, 27.0 + attack * 16.0, phase * TAU, phase * TAU + PI * 1.6, 24, colors.energy, 5.0)
		"Lifebinder":
			var emitter := right_hand + Vector2(45, -24)
			draw_line(right_hand, emitter, colors.edge, 24.0, true)
			draw_line(right_hand, emitter, colors.armor, 16.0, true)
			for spoke in 6:
				var angle := phase * TAU + spoke * TAU / 6.0
				var inner := emitter + Vector2.from_angle(angle) * 15.0
				var outer := emitter + Vector2.from_angle(angle) * (28.0 + attack * 15.0)
				draw_line(inner, outer, colors.energy, 5.0, true)

func _draw_faction_marks(center: Vector2, width: float, colors: Dictionary, faction: String) -> void:
	match faction:
		"Coal":
			for side in [-1, 1]:
				draw_line(center + Vector2(side * (width - 10), -40), center + Vector2(side * (width - 2), 34), colors.trim, 6.0)
		"Steam":
			for x in [-30, 30]:
				draw_circle(center + Vector2(x, 29), 6.0, colors.trim)
		"Wind":
			_poly(PackedVector2Array([
				center + Vector2(-31, 28), center + Vector2(0, 2), center + Vector2(31, 28)
			]), Color(colors.energy, 0.22), colors.energy, 3.0)
		"Fusion":
			draw_line(center + Vector2(-width + 10, 27), center + Vector2(width - 10, -22), colors.energy, 4.0, true)
		"Solar":
			draw_circle(center + Vector2(0, 10), 29.0, Color.TRANSPARENT, false)
			draw_arc(center + Vector2(0, 10), 29.0, 0, TAU, 20, colors.trim, 5.0)
		_:
			draw_line(center + Vector2(-26, 31), center + Vector2(26, 31), colors.trim, 5.0, true)

func _poly(points: PackedVector2Array, fill: Color, stroke: Color, width: float) -> void:
	draw_colored_polygon(points, fill)
	var outline := PackedVector2Array(points)
	outline.append(points[0])
	draw_polyline(outline, stroke, width, true)

func _draw_ellipse_shape(center: Vector2, radius: Vector2, color: Color) -> void:
	var points := PackedVector2Array()
	for index in 40:
		var angle := TAU * float(index) / 40.0
		points.append(center + Vector2(cos(angle) * radius.x, sin(angle) * radius.y))
	draw_colored_polygon(points, color)
