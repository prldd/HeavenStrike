extends SceneTree

const SOURCE_PATHS := {
	"Coal": "res://assets/units/modular/concepts/coal-parts-alpha.png",
	"Wind": "res://assets/units/modular/concepts/wind-parts-alpha.png"
}

# Regions are deliberately source-specific. The runtime rig consumes only the
# extracted part files and normalized sockets, never these layout coordinates.
const PART_RECTS := {
	"Coal": {
		"head": Rect2i(340, 55, 220, 260),
		"torso": Rect2i(555, 45, 315, 405),
		"accessory": Rect2i(890, 15, 325, 390),
		"shoulder_left": Rect2i(45, 60, 295, 220),
		"shoulder_right": Rect2i(1010, 370, 235, 225),
		"upper_arm_left": Rect2i(240, 390, 175, 310),
		"upper_arm_right": Rect2i(860, 385, 185, 315),
		"forearm_left": Rect2i(435, 415, 180, 220),
		"forearm_right": Rect2i(675, 410, 180, 225),
		"hand_left": Rect2i(470, 525, 145, 175),
		"hand_right": Rect2i(675, 520, 145, 180),
		"thigh_left": Rect2i(405, 695, 190, 225),
		"thigh_right": Rect2i(675, 695, 195, 225),
		"shin_left": Rect2i(325, 880, 210, 290),
		"shin_right": Rect2i(745, 880, 210, 290),
		"foot_left": Rect2i(130, 1025, 210, 185),
		"foot_right": Rect2i(930, 1025, 225, 185)
	},
	"Wind": {
		"head": Rect2i(250, 25, 230, 240),
		"torso": Rect2i(490, 35, 285, 365),
		"accessory": Rect2i(755, 10, 490, 365),
		"shoulder_left": Rect2i(10, 230, 290, 205),
		"shoulder_right": Rect2i(280, 230, 250, 205),
		"upper_arm_left": Rect2i(50, 420, 180, 255),
		"upper_arm_right": Rect2i(240, 420, 180, 255),
		"forearm_left": Rect2i(485, 420, 180, 255),
		"forearm_right": Rect2i(650, 420, 180, 255),
		"hand_left": Rect2i(885, 490, 130, 180),
		"hand_right": Rect2i(1025, 490, 130, 180),
		"thigh_left": Rect2i(60, 700, 215, 275),
		"thigh_right": Rect2i(260, 700, 210, 275),
		"shin_left": Rect2i(435, 690, 245, 400),
		"shin_right": Rect2i(655, 690, 245, 400),
		"foot_left": Rect2i(215, 1015, 230, 195),
		"foot_right": Rect2i(835, 1015, 235, 195)
	}
}

func _init() -> void:
	call_deferred("_build")

func _build() -> void:
	var built := 0
	for faction in SOURCE_PATHS:
		var source_texture := load(SOURCE_PATHS[faction]) as Texture2D
		assert(source_texture != null)
		var source := source_texture.get_image()
		assert(source.get_size() == Vector2i(1254, 1254))
		var output_dir := "res://assets/units/modular/parts/%s" % String(faction).to_lower()
		assert(DirAccess.make_dir_recursive_absolute(
			ProjectSettings.globalize_path(output_dir)
		) == OK)
		for part_name in PART_RECTS[faction]:
			var region: Rect2i = PART_RECTS[faction][part_name]
			var part := source.get_region(region)
			assert(not part.is_empty())
			assert(part.save_png("%s/%s.png" % [output_dir, part_name]) == OK)
			built += 1
	assert(built == 34)
	print("Built %d articulated anime-mecha parts." % built)
	quit()
