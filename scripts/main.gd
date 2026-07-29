extends Control

const BoardViewScript = preload("res://scripts/board_view.gd")
const UnitCatalogScript = preload("res://scripts/unit_catalog.gd")
const BattleAIScript = preload("res://scripts/battle_ai.gd")
const SquadStoreScript = preload("res://scripts/squad_store.gd")
const CampaignStoreScript = preload("res://scripts/campaign_store.gd")
const BattleRulesScript = preload("res://scripts/battle_rules.gd")
const CaptainSkillsScript = preload("res://scripts/captain_skills.gd")
const UnitSkillsScript = preload("res://scripts/unit_skills.gd")
const MissionRunStoreScript = preload("res://scripts/mission_run_store.gd")
const SquadCardScript = preload("res://scripts/squad_card.gd")
const SquadDropZoneScript = preload("res://scripts/squad_drop_zone.gd")
const UNIT_SPRITES_1 := preload("res://assets/units/reference-units-001-006.png")
const UNIT_SPRITES_2 := preload("res://assets/units/reference-units-007-012.png")
const UNIT_SPRITES_3 := preload("res://assets/units/reference-units-013-018.png")
const UNIT_SPRITES_4 := preload("res://assets/units/reference-units-019-024.png")
const UNIT_SPRITES_5 := preload("res://assets/units/reference-units-025-030.png")
const UNIT_SPRITES_6 := preload("res://assets/units/reference-units-031-036.png")
const UNIT_SPRITES_7 := preload("res://assets/units/reference-units-037-042.png")
const UNIT_SPRITES_8 := preload("res://assets/units/reference-units-043-048.png")
const MAIN_MENU_BACKGROUND := preload("res://assets/main-menu-sky-citadel.png")
const SQUAD_WORKSHOP_BACKGROUND := preload("res://assets/squad-workshop-armory.png")

const PLAYER := 0
const ENEMY := 1
const ROWS := 3
const COLS := 7
const BENCH_LIMIT := 6
const STARTING_HP := 20

var board: BoardView
var turn_label: Label
var hint_label: Label
var hand_row: HBoxContainer
var end_button: Button
var power_button: Button
var menu_button: Button
var overlay: ColorRect
var overlay_title: Label
var overlay_detail: Label
var result_primary_button: Button
var reward_reveal: VBoxContainer
var reward_portrait: TextureRect
var reward_stars_label: Label
var reward_new_label: Label
var tutorial_overlay: ColorRect
var tutorial_page_label: Label
var tutorial_page := 0
var squad_overlay: ColorRect
var squad_grid: GridContainer
var squad_selection_grid: GridContainer
var squad_count_label: Label
var squad_save_button: Button
var squad_start_button: Button
var captain_skill_option: OptionButton
var hover_card: PanelContainer
var hover_name_label: Label
var hover_stats_label: Label
var hover_ability_label: Label
var speed_button: Button
var combat_log_panel: PanelContainer
var combat_log_label: RichTextLabel
var main_menu_overlay: ColorRect
var mission_overlay: ColorRect
var mission_list: VBoxContainer
var resume_button: Button

var roster: Array = UnitCatalogScript.all_units()
var squad_names: Array = []
var editing_squad_names: Array = []
var battle_deck: Array = []
var enemy_deck: Array = []
var player_captain_skill := "Rally"
var editing_captain_skill := "Rally"
var enemy_captain_skill := "Rally"
var completed_missions: Array = []
var earned_reward_units: Array = []
var current_mission_id := -1
var current_encounter_index := 0
var mission_run_captain_hp := STARTING_HP
var awaiting_next_encounter := false
var mission_finished := false
var campaign_battle := false
var squad_opened_from_menu := false
var squad_opened_for_mission := false
var tutorial_opened_from_menu := false
var pending_mission_id := -1

var units: Array = []
var player_hand: Array = []
var enemy_hand: Array = []
var unit_icon_cache := {}
var draw_index := 0
var enemy_draw_index := 0
var selected_hand_index := -1
var selected_board_unit_id := -1
var pending_empower_actor_id := -1
var next_unit_id := 1
var round_number := 1
var player_hp := STARTING_HP
var enemy_hp := STARTING_HP
var player_max_energy := 2
var player_energy := 2
var enemy_max_energy := 2
var enemy_energy := 2
var player_power_used := false
var enemy_power_used := false
var player_shield := 0
var enemy_shield := 0
var player_shield_turns := 0
var enemy_shield_turns := 0
var input_enabled := true
var battle_over := false
var status_message := ""
var has_shown_tutorial := false
var resolution_speed := 1.0
var combat_log_lines: Array = []
var last_logged_message := ""

func _ready() -> void:
	_build_interface()
	completed_missions = CampaignStoreScript.load_completed()
	earned_reward_units = CampaignStoreScript.load_reward_units(roster)
	squad_names = SquadStoreScript.load_squad(roster)
	player_captain_skill = SquadStoreScript.load_captain_skill(CaptainSkillsScript.SKILLS)
	_sanitize_squad_unlocks()
	_start_new_match()
	_show_main_menu()

func _build_interface() -> void:
	var background := ColorRect.new()
	background.color = Color("#070c18")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_bottom", 14)
	add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 8)
	margin.add_child(root)

	var header := HBoxContainer.new()
	header.custom_minimum_size.y = 50
	root.add_child(header)

	var brand := Label.new()
	brand.text = "SKYCHAIN\nTACTICS"
	brand.add_theme_font_size_override("font_size", 17)
	brand.add_theme_color_override("font_color", Color("#71e6f5"))
	brand.custom_minimum_size.x = 170
	header.add_child(brand)

	turn_label = Label.new()
	turn_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	turn_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	turn_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	turn_label.add_theme_font_size_override("font_size", 18)
	header.add_child(turn_label)

	var header_balance := Control.new()
	header_balance.custom_minimum_size.x = 170
	header.add_child(header_balance)

	board = BoardViewScript.new()
	board.custom_minimum_size = Vector2(0, 370)
	board.size_flags_vertical = Control.SIZE_EXPAND_FILL
	board.deployment_clicked.connect(_on_deployment_clicked)
	board.board_cell_clicked.connect(_on_board_cell_clicked)
	board.unit_hovered.connect(_show_unit_details)
	board.unit_hover_ended.connect(_hide_unit_details)
	root.add_child(board)

	var control_bar := VBoxContainer.new()
	control_bar.custom_minimum_size.y = 62
	control_bar.add_theme_constant_override("separation", 8)
	root.add_child(control_bar)

	var status_row := HBoxContainer.new()
	status_row.add_theme_constant_override("separation", 8)
	control_bar.add_child(status_row)

	hint_label = Label.new()
	hint_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hint_label.add_theme_color_override("font_color", Color("#9fb2d6"))
	status_row.add_child(hint_label)

	var action_row := HBoxContainer.new()
	action_row.alignment = BoxContainer.ALIGNMENT_END
	action_row.add_theme_constant_override("separation", 8)
	control_bar.add_child(action_row)

	power_button = Button.new()
	power_button.text = "RALLY"
	power_button.tooltip_text = "Once per battle: all allies gain +1 ATK."
	power_button.custom_minimum_size.x = 135
	power_button.pressed.connect(_use_player_power)
	action_row.add_child(power_button)

	speed_button = Button.new()
	speed_button.text = "SPEED 1×"
	speed_button.tooltip_text = "Cycle combat resolution speed."
	speed_button.custom_minimum_size.x = 92
	speed_button.pressed.connect(_cycle_resolution_speed)
	action_row.add_child(speed_button)

	var log_button := Button.new()
	log_button.text = "LOG"
	log_button.tooltip_text = "Show or hide the combat action log."
	log_button.custom_minimum_size.x = 54
	log_button.pressed.connect(_toggle_combat_log)
	action_row.add_child(log_button)

	var help_button := Button.new()
	help_button.text = "?"
	help_button.tooltip_text = "How to play"
	help_button.custom_minimum_size.x = 42
	help_button.pressed.connect(_open_tutorial)
	action_row.add_child(help_button)

	var squad_button := Button.new()
	squad_button.text = "SQUAD"
	squad_button.tooltip_text = "Choose the 8 units in your battle squad."
	squad_button.custom_minimum_size.x = 78
	squad_button.pressed.connect(_open_squad_builder)
	action_row.add_child(squad_button)

	menu_button = Button.new()
	menu_button.text = "MENU"
	menu_button.custom_minimum_size.x = 64
	menu_button.pressed.connect(_show_main_menu)
	action_row.add_child(menu_button)

	end_button = Button.new()
	end_button.text = "RESOLVE TURN"
	end_button.custom_minimum_size.x = 145
	end_button.pressed.connect(_end_player_turn)
	action_row.add_child(end_button)

	hand_row = HBoxContainer.new()
	hand_row.custom_minimum_size.y = 104
	hand_row.alignment = BoxContainer.ALIGNMENT_CENTER
	hand_row.add_theme_constant_override("separation", 6)
	root.add_child(hand_row)

	_build_combat_log()
	_build_overlay()
	_build_tutorial()
	_build_squad_builder()
	_build_main_menu()
	_build_mission_select()
	_build_hover_card()

func _build_combat_log() -> void:
	combat_log_panel = PanelContainer.new()
	combat_log_panel.set_anchor(SIDE_LEFT, 1.0)
	combat_log_panel.set_anchor(SIDE_RIGHT, 1.0)
	combat_log_panel.offset_left = -430
	combat_log_panel.offset_right = -18
	combat_log_panel.offset_top = 72
	combat_log_panel.offset_bottom = 410
	combat_log_panel.z_index = 80
	combat_log_panel.visible = false
	add_child(combat_log_panel)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 8)
	combat_log_panel.add_child(layout)
	var heading := HBoxContainer.new()
	layout.add_child(heading)
	var title := Label.new()
	title.text = "COMBAT LOG"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_color_override("font_color", Color("#71e6f5"))
	heading.add_child(title)
	var close := Button.new()
	close.text = "×"
	close.pressed.connect(_toggle_combat_log)
	heading.add_child(close)
	combat_log_label = RichTextLabel.new()
	combat_log_label.bbcode_enabled = false
	combat_log_label.scroll_following = true
	combat_log_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	layout.add_child(combat_log_label)

func _toggle_combat_log() -> void:
	combat_log_panel.visible = not combat_log_panel.visible

func _cycle_resolution_speed() -> void:
	if resolution_speed < 1.5:
		resolution_speed = 2.0
	elif resolution_speed < 3.0:
		resolution_speed = 4.0
	else:
		resolution_speed = 1.0
	speed_button.text = "SPEED %d×" % int(resolution_speed)

func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds / resolution_speed).timeout

func _log_action(message: String) -> void:
	if message.is_empty() or message == last_logged_message:
		return
	last_logged_message = message
	combat_log_lines.append(message)
	if combat_log_lines.size() > 60:
		combat_log_lines.pop_front()
	if combat_log_label != null:
		combat_log_label.text = "\n".join(combat_log_lines)

func _build_overlay() -> void:
	overlay = ColorRect.new()
	overlay.color = Color(0.02, 0.035, 0.07, 0.93)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.visible = false
	add_child(overlay)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(center)

	var panel := VBoxContainer.new()
	panel.custom_minimum_size = Vector2(480, 390)
	panel.alignment = BoxContainer.ALIGNMENT_CENTER
	panel.add_theme_constant_override("separation", 14)
	center.add_child(panel)

	overlay_title = Label.new()
	overlay_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	overlay_title.add_theme_font_size_override("font_size", 42)
	panel.add_child(overlay_title)

	overlay_detail = Label.new()
	overlay_detail.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	overlay_detail.add_theme_font_size_override("font_size", 17)
	overlay_detail.add_theme_color_override("font_color", Color("#afbeda"))
	panel.add_child(overlay_detail)

	reward_reveal = VBoxContainer.new()
	reward_reveal.alignment = BoxContainer.ALIGNMENT_CENTER
	reward_reveal.add_theme_constant_override("separation", 4)
	reward_reveal.visible = false
	panel.add_child(reward_reveal)

	var reward_heading := Label.new()
	reward_heading.text = "CARD REWARD"
	reward_heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	reward_heading.add_theme_font_size_override("font_size", 16)
	reward_heading.add_theme_color_override("font_color", Color("#9fb2d6"))
	reward_reveal.add_child(reward_heading)

	var portrait_center := CenterContainer.new()
	portrait_center.custom_minimum_size = Vector2(0, 116)
	reward_reveal.add_child(portrait_center)

	reward_portrait = TextureRect.new()
	reward_portrait.custom_minimum_size = Vector2(108, 108)
	reward_portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	reward_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	reward_portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	portrait_center.add_child(reward_portrait)

	reward_stars_label = Label.new()
	reward_stars_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	reward_stars_label.add_theme_font_size_override("font_size", 18)
	reward_stars_label.add_theme_color_override("font_color", Color("#ffd166"))
	reward_reveal.add_child(reward_stars_label)

	reward_new_label = Label.new()
	reward_new_label.text = "NEW"
	reward_new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	reward_new_label.add_theme_font_size_override("font_size", 15)
	reward_new_label.add_theme_color_override("font_color", Color("#70e0a1"))
	reward_reveal.add_child(reward_new_label)

	result_primary_button = Button.new()
	result_primary_button.text = "PLAY AGAIN"
	result_primary_button.custom_minimum_size = Vector2(180, 48)
	result_primary_button.pressed.connect(_on_result_primary)
	panel.add_child(result_primary_button)

func _build_tutorial() -> void:
	tutorial_overlay = ColorRect.new()
	tutorial_overlay.color = Color(0.02, 0.035, 0.07, 0.94)
	tutorial_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	tutorial_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	tutorial_overlay.visible = false
	add_child(tutorial_overlay)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	tutorial_overlay.add_child(center)

	var panel := VBoxContainer.new()
	panel.custom_minimum_size = Vector2(560, 330)
	panel.alignment = BoxContainer.ALIGNMENT_CENTER
	panel.add_theme_constant_override("separation", 22)
	center.add_child(panel)

	var title := Label.new()
	title.text = "FIELD BRIEFING"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 32)
	title.add_theme_color_override("font_color", Color("#71e6f5"))
	panel.add_child(title)

	tutorial_page_label = Label.new()
	tutorial_page_label.custom_minimum_size = Vector2(520, 150)
	tutorial_page_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tutorial_page_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	tutorial_page_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	tutorial_page_label.add_theme_font_size_override("font_size", 18)
	tutorial_page_label.add_theme_color_override("font_color", Color("#c1cee5"))
	panel.add_child(tutorial_page_label)

	var actions := HBoxContainer.new()
	actions.alignment = BoxContainer.ALIGNMENT_CENTER
	actions.add_theme_constant_override("separation", 12)
	panel.add_child(actions)

	var close := Button.new()
	close.text = "SKIP"
	close.custom_minimum_size = Vector2(120, 44)
	close.pressed.connect(_close_tutorial)
	actions.add_child(close)

	var next := Button.new()
	next.text = "NEXT"
	next.custom_minimum_size = Vector2(160, 44)
	next.pressed.connect(_next_tutorial_page)
	actions.add_child(next)

func _open_tutorial() -> void:
	tutorial_page = 0
	tutorial_overlay.visible = true
	_update_tutorial()

func _close_tutorial() -> void:
	tutorial_overlay.visible = false
	if tutorial_opened_from_menu:
		tutorial_opened_from_menu = false
		_show_main_menu()

func _next_tutorial_page() -> void:
	tutorial_page += 1
	if tutorial_page >= 5:
		_close_tutorial()
		return
	_update_tutorial()

func _update_tutorial() -> void:
	var pages := [
		"1 / 5\nSELECT A CARD\nCards show Mana cost, class, attack, health, and their special ability.",
		"2 / 5\nCHOOSE A LANE\nDeploy on an open glowing tile at the left edge. New units move and attack when the turn resolves.",
		"3 / 5\nREPOSITION\nSelect one of your deployed units, then an open highlighted tile in another row. Friendly units may be crossed, enemies block the path, and you may reposition any number of times.",
		"4 / 5\nTAUNTING STRIKE\nA unit hit by a Defender cannot change rows for its next two turns.",
		"5 / 5\nBREAK THE COMMANDER\nResolve the board, cross an open lane, and deal enough damage to defeat the enemy Commander."
	]
	tutorial_page_label.text = pages[tutorial_page]

func _build_squad_builder() -> void:
	squad_overlay = ColorRect.new()
	squad_overlay.color = Color.TRANSPARENT
	squad_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	squad_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	squad_overlay.visible = false
	add_child(squad_overlay)
	_add_overlay_background(
		squad_overlay,
		SQUAD_WORKSHOP_BACKGROUND,
		Color(0.015, 0.025, 0.055, 0.42)
	)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 70)
	margin.add_theme_constant_override("margin_right", 70)
	margin.add_theme_constant_override("margin_top", 42)
	margin.add_theme_constant_override("margin_bottom", 42)
	squad_overlay.add_child(margin)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 14)
	margin.add_child(layout)

	var title_row := HBoxContainer.new()
	layout.add_child(title_row)

	var title := Label.new()
	title.text = "SQUAD WORKSHOP"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", Color("#71e6f5"))
	title_row.add_child(title)

	squad_count_label = Label.new()
	squad_count_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	squad_count_label.add_theme_font_size_override("font_size", 18)
	title_row.add_child(squad_count_label)

	var instruction := Label.new()
	instruction.text = "Drag squad cards to reorder them. Slot 1 is the Vanguard; right-click any squad card to make it Vanguard. Maximum 2 copies per unit."
	instruction.add_theme_color_override("font_color", Color("#aebdda"))
	layout.add_child(instruction)

	var skill_row := HBoxContainer.new()
	skill_row.add_theme_constant_override("separation", 12)
	layout.add_child(skill_row)

	var skill_label := Label.new()
	skill_label.text = "CAPTAIN SKILL"
	skill_label.custom_minimum_size.x = 150
	skill_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	skill_label.add_theme_color_override("font_color", Color("#ffd166"))
	skill_row.add_child(skill_label)

	captain_skill_option = OptionButton.new()
	captain_skill_option.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for skill_name in CaptainSkillsScript.SKILLS:
		captain_skill_option.add_item("%s · %s" % [skill_name, CaptainSkillsScript.DESCRIPTIONS[skill_name]])
	captain_skill_option.item_selected.connect(_select_captain_skill)
	skill_row.add_child(captain_skill_option)

	var workshop_columns := HBoxContainer.new()
	workshop_columns.size_flags_vertical = Control.SIZE_EXPAND_FILL
	workshop_columns.add_theme_constant_override("separation", 14)
	layout.add_child(workshop_columns)

	var barracks_zone: PanelContainer = SquadDropZoneScript.new()
	barracks_zone.zone_name = "barracks"
	barracks_zone.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	barracks_zone.size_flags_stretch_ratio = 1.0
	barracks_zone.unit_dropped.connect(_on_squad_drop.bind("barracks"))
	workshop_columns.add_child(barracks_zone)

	var barracks_layout := VBoxContainer.new()
	barracks_layout.add_theme_constant_override("separation", 8)
	barracks_zone.add_child(barracks_layout)
	var barracks_title := Label.new()
	barracks_title.text = "BARRACKS · OWNED CARDS"
	barracks_title.add_theme_font_size_override("font_size", 16)
	barracks_title.add_theme_color_override("font_color", Color("#71e6f5"))
	barracks_layout.add_child(barracks_title)
	var barracks_scroll := ScrollContainer.new()
	barracks_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	barracks_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	barracks_layout.add_child(barracks_scroll)
	squad_grid = GridContainer.new()
	squad_grid.columns = 2
	squad_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	squad_grid.add_theme_constant_override("h_separation", 8)
	squad_grid.add_theme_constant_override("v_separation", 8)
	barracks_scroll.add_child(squad_grid)

	var selection_zone: PanelContainer = SquadDropZoneScript.new()
	selection_zone.zone_name = "squad"
	selection_zone.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	selection_zone.size_flags_stretch_ratio = 1.0
	selection_zone.unit_dropped.connect(_on_squad_drop.bind("squad"))
	workshop_columns.add_child(selection_zone)

	var selection_layout := VBoxContainer.new()
	selection_layout.add_theme_constant_override("separation", 8)
	selection_zone.add_child(selection_layout)
	var selection_title := Label.new()
	selection_title.text = "SQUAD · CLICK A CARD TO REMOVE"
	selection_title.add_theme_font_size_override("font_size", 16)
	selection_title.add_theme_color_override("font_color", Color("#ffd166"))
	selection_layout.add_child(selection_title)
	var selection_scroll := ScrollContainer.new()
	selection_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	selection_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	selection_layout.add_child(selection_scroll)
	squad_selection_grid = GridContainer.new()
	squad_selection_grid.columns = 2
	squad_selection_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	squad_selection_grid.add_theme_constant_override("h_separation", 8)
	squad_selection_grid.add_theme_constant_override("v_separation", 8)
	selection_scroll.add_child(squad_selection_grid)

	var actions := HBoxContainer.new()
	actions.alignment = BoxContainer.ALIGNMENT_END
	actions.add_theme_constant_override("separation", 10)
	layout.add_child(actions)

	var reset := Button.new()
	reset.text = "RESET"
	reset.custom_minimum_size = Vector2(110, 44)
	reset.pressed.connect(_reset_squad)
	actions.add_child(reset)

	var cancel := Button.new()
	cancel.text = "CANCEL"
	cancel.custom_minimum_size = Vector2(110, 44)
	cancel.pressed.connect(_close_squad_builder)
	actions.add_child(cancel)

	squad_save_button = Button.new()
	squad_save_button.text = "SAVE SQUAD"
	squad_save_button.custom_minimum_size = Vector2(170, 44)
	squad_save_button.pressed.connect(_save_squad)
	actions.add_child(squad_save_button)

	squad_start_button = Button.new()
	squad_start_button.text = "START MISSION"
	squad_start_button.custom_minimum_size = Vector2(180, 44)
	squad_start_button.visible = false
	squad_start_button.pressed.connect(_save_and_start_mission)
	actions.add_child(squad_start_button)

func _open_squad_builder() -> void:
	if not input_enabled:
		return
	squad_opened_from_menu = false
	squad_opened_for_mission = false
	pending_mission_id = -1
	editing_squad_names = squad_names.duplicate()
	editing_captain_skill = player_captain_skill
	captain_skill_option.select(CaptainSkillsScript.SKILLS.find(editing_captain_skill))
	squad_overlay.visible = true
	_rebuild_squad_grid()

func _close_squad_builder() -> void:
	squad_overlay.visible = false
	if squad_opened_for_mission:
		squad_opened_for_mission = false
		pending_mission_id = -1
		_open_mission_select()
		return
	if squad_opened_from_menu:
		squad_opened_from_menu = false
		_show_main_menu()

func _reset_squad() -> void:
	editing_squad_names = SquadStoreScript.sanitize_owned(
		[], roster, CampaignStoreScript.inventory_counts(roster, earned_reward_units)
	)
	_rebuild_squad_grid()

func _select_captain_skill(index: int) -> void:
	if index >= 0 and index < CaptainSkillsScript.SKILLS.size():
		editing_captain_skill = CaptainSkillsScript.SKILLS[index]

func _add_squad_unit(unit_name: String) -> void:
	var inventory := CampaignStoreScript.inventory_counts(roster, earned_reward_units)
	var copies: int = editing_squad_names.count(unit_name)
	if (
		copies < mini(2, inventory.get(unit_name, 0))
		and editing_squad_names.size() < SquadStoreScript.SQUAD_SIZE
	):
		editing_squad_names.append(unit_name)
	_rebuild_squad_grid()

func _remove_squad_unit_at(index: int) -> void:
	if index >= 0 and index < editing_squad_names.size():
		editing_squad_names.remove_at(index)
	_rebuild_squad_grid()

func _remove_one_squad_unit(unit_name: String) -> void:
	var index := editing_squad_names.find(unit_name)
	if index >= 0:
		editing_squad_names.remove_at(index)
	_rebuild_squad_grid()

func _on_squad_drop(unit_name: String, source: String, destination: String) -> void:
	if destination == "squad" and source == "barracks":
		_add_squad_unit(unit_name)
	elif destination == "barracks" and source == "squad":
		_remove_one_squad_unit(unit_name)

func _rebuild_squad_grid() -> void:
	for child in squad_grid.get_children():
		squad_grid.remove_child(child)
		child.queue_free()
	for child in squad_selection_grid.get_children():
		squad_selection_grid.remove_child(child)
		child.queue_free()

	var inventory := CampaignStoreScript.inventory_counts(roster, earned_reward_units)
	for unit in roster:
		var copies: int = editing_squad_names.count(unit.name)
		var owned: int = inventory.get(unit.name, 0)
		if owned <= 0:
			continue
		var button: Button = SquadCardScript.new()
		button.configure(unit.name, "barracks", _unit_icon(unit.icon), -1, unit.kind)
		button.custom_minimum_size = Vector2(0, 78)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.icon = _unit_icon(unit.icon)
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.disabled = (
			copies >= mini(2, owned)
			or editing_squad_names.size() >= SquadStoreScript.SQUAD_SIZE
		)
		button.text = "%s\nOWNED %d · IN SQUAD %d" % [
			unit.name.to_upper(), owned, copies
		]
		button.add_theme_font_size_override("font_size", 11)
		button.pressed.connect(_add_squad_unit.bind(unit.name))
		button.connect("unit_dropped", _on_squad_card_drop)
		button.mouse_entered.connect(_show_unit_details.bind(unit))
		button.mouse_exited.connect(_hide_unit_details)
		squad_grid.add_child(button)

	for index in editing_squad_names.size():
		var unit: Dictionary = UnitCatalogScript.by_name(editing_squad_names[index])
		if unit.is_empty():
			continue
		var card: Button = SquadCardScript.new()
		card.configure(unit.name, "squad", _unit_icon(unit.icon), index, unit.kind)
		card.custom_minimum_size = Vector2(0, 72)
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card.icon = _unit_icon(unit.icon)
		card.alignment = HORIZONTAL_ALIGNMENT_LEFT
		card.text = "%02d · %s%s" % [
			index + 1,
			unit.name.to_upper(),
			"\nVANGUARD" if index == 0 else ""
		]
		card.add_theme_font_size_override("font_size", 11)
		card.pressed.connect(_remove_squad_unit_at.bind(index))
		card.connect("unit_dropped", _on_squad_card_drop)
		card.gui_input.connect(_on_squad_card_gui_input.bind(index))
		card.mouse_entered.connect(_show_unit_details.bind(unit))
		card.mouse_exited.connect(_hide_unit_details)
		squad_selection_grid.add_child(card)

	squad_count_label.text = "%d / %d SELECTED" % [editing_squad_names.size(), SquadStoreScript.SQUAD_SIZE]
	squad_count_label.add_theme_color_override("font_color", Color("#70e0a1") if not editing_squad_names.is_empty() else Color("#ff8f8f"))
	squad_save_button.disabled = editing_squad_names.is_empty()
	squad_start_button.visible = squad_opened_for_mission
	squad_start_button.disabled = editing_squad_names.is_empty()

func _on_squad_card_drop(
	unit_name: String, source: String, source_index: int, target_index: int
) -> void:
	if target_index < 0:
		if source == "squad":
			_remove_squad_unit_at(source_index)
		return
	if source == "squad":
		_move_squad_unit(source_index, target_index)
	elif source == "barracks":
		var previous_size := editing_squad_names.size()
		_add_squad_unit(unit_name)
		if editing_squad_names.size() > previous_size:
			_move_squad_unit(editing_squad_names.size() - 1, target_index)

func _move_squad_unit(from_index: int, to_index: int) -> void:
	if (
		from_index < 0 or from_index >= editing_squad_names.size()
		or to_index < 0 or to_index >= editing_squad_names.size()
		or from_index == to_index
	):
		return
	var unit_name: String = editing_squad_names[from_index]
	editing_squad_names.remove_at(from_index)
	editing_squad_names.insert(to_index, unit_name)
	_rebuild_squad_grid()

func _set_vanguard(index: int) -> void:
	if index <= 0 or index >= editing_squad_names.size():
		return
	_move_squad_unit(index, 0)

func _on_squad_card_gui_input(event: InputEvent, index: int) -> void:
	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_RIGHT
		and event.pressed
	):
		_set_vanguard(index)

func _save_squad() -> void:
	if editing_squad_names.is_empty() or editing_squad_names.size() > SquadStoreScript.SQUAD_SIZE:
		return
	squad_names = editing_squad_names.duplicate()
	player_captain_skill = editing_captain_skill
	if SquadStoreScript.save_squad(squad_names, roster):
		SquadStoreScript.save_captain_skill(player_captain_skill, CaptainSkillsScript.SKILLS)
		status_message = "Squad saved. It will be used in the next battle."
	else:
		status_message = "Squad selected for this session, but the save file could not be written."
	_close_squad_builder()
	_refresh()

func _save_and_start_mission() -> void:
	if editing_squad_names.is_empty() or pending_mission_id < 0:
		return
	squad_names = editing_squad_names.duplicate()
	player_captain_skill = editing_captain_skill
	SquadStoreScript.save_squad(squad_names, roster)
	SquadStoreScript.save_captain_skill(player_captain_skill, CaptainSkillsScript.SKILLS)
	var mission_id := pending_mission_id
	squad_opened_for_mission = false
	pending_mission_id = -1
	squad_overlay.visible = false
	_begin_mission(mission_id)

func _sanitize_squad_unlocks() -> void:
	squad_names = SquadStoreScript.sanitize_owned(
		squad_names,
		roster,
		CampaignStoreScript.inventory_counts(roster, earned_reward_units)
	)

func _build_main_menu() -> void:
	main_menu_overlay = ColorRect.new()
	main_menu_overlay.color = Color.TRANSPARENT
	main_menu_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main_menu_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	main_menu_overlay.visible = false
	add_child(main_menu_overlay)
	_add_overlay_background(
		main_menu_overlay,
		MAIN_MENU_BACKGROUND,
		Color(0.015, 0.025, 0.06, 0.48)
	)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main_menu_overlay.add_child(center)

	var layout := VBoxContainer.new()
	layout.custom_minimum_size = Vector2(460, 560)
	layout.alignment = BoxContainer.ALIGNMENT_CENTER
	layout.add_theme_constant_override("separation", 16)
	center.add_child(layout)

	var title := Label.new()
	title.text = "SKYCHAIN\nTACTICS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 48)
	title.add_theme_color_override("font_color", Color("#71e6f5"))
	layout.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "COMMAND THE DRIFTING SKYWAYS"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_color_override("font_color", Color("#8da2c8"))
	layout.add_child(subtitle)

	var campaign := _menu_action("CAMPAIGN")
	campaign.pressed.connect(_open_mission_select)
	layout.add_child(campaign)

	resume_button = _menu_action("RESUME MISSION")
	resume_button.pressed.connect(_resume_mission)
	layout.add_child(resume_button)

	var practice := _menu_action("PRACTICE BATTLE")
	practice.pressed.connect(_begin_practice)
	layout.add_child(practice)

	var squad := _menu_action("SQUAD WORKSHOP")
	squad.pressed.connect(_open_squad_from_menu)
	layout.add_child(squad)

	var tutorial := _menu_action("HOW TO PLAY")
	tutorial.pressed.connect(_open_tutorial_from_menu)
	layout.add_child(tutorial)

func _build_mission_select() -> void:
	mission_overlay = ColorRect.new()
	mission_overlay.color = Color("#091124")
	mission_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mission_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	mission_overlay.visible = false
	add_child(mission_overlay)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 180)
	margin.add_theme_constant_override("margin_right", 180)
	margin.add_theme_constant_override("margin_top", 60)
	margin.add_theme_constant_override("margin_bottom", 50)
	mission_overlay.add_child(margin)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 14)
	margin.add_child(layout)

	var title := Label.new()
	title.text = "CAMPAIGN · THE TEMPEST ENGINE"
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", Color("#71e6f5"))
	layout.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Complete missions in order. Victories unlock new support units."
	subtitle.add_theme_color_override("font_color", Color("#9fb2d6"))
	layout.add_child(subtitle)

	var mission_scroll := ScrollContainer.new()
	mission_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mission_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	mission_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	layout.add_child(mission_scroll)

	mission_list = VBoxContainer.new()
	mission_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mission_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	mission_list.add_theme_constant_override("separation", 10)
	mission_scroll.add_child(mission_list)

	var back := Button.new()
	back.text = "BACK TO MENU"
	back.custom_minimum_size = Vector2(180, 44)
	back.pressed.connect(_show_main_menu)
	layout.add_child(back)

func _menu_action(label: String) -> Button:
	var button := Button.new()
	button.text = label
	button.custom_minimum_size = Vector2(360, 52)
	button.add_theme_font_size_override("font_size", 17)
	return button

func _add_overlay_background(
	parent: Control, texture: Texture2D, tint_color: Color
) -> void:
	var backdrop := TextureRect.new()
	backdrop.texture = texture
	backdrop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	parent.add_child(backdrop)

	var tint := ColorRect.new()
	tint.color = tint_color
	tint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tint.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	parent.add_child(tint)

func _show_main_menu() -> void:
	input_enabled = false
	squad_opened_from_menu = false
	squad_opened_for_mission = false
	tutorial_opened_from_menu = false
	pending_mission_id = -1
	main_menu_overlay.visible = true
	mission_overlay.visible = false
	squad_overlay.visible = false
	tutorial_overlay.visible = false
	overlay.visible = false
	hover_card.visible = false
	combat_log_panel.visible = false
	var saved_run: Dictionary = MissionRunStoreScript.load_run(CampaignStoreScript.MISSIONS.size())
	resume_button.disabled = saved_run.is_empty()
	resume_button.text = "RESUME MISSION"
	if not saved_run.is_empty():
		resume_button.text = "RESUME · %s · BATTLE %d" % [
			CampaignStoreScript.MISSIONS[saved_run.mission_id].title.to_upper(),
			saved_run.encounter_index + 1
		]
	_refresh()

func _open_mission_select() -> void:
	main_menu_overlay.visible = false
	mission_overlay.visible = true
	_rebuild_mission_list()

func _rebuild_mission_list() -> void:
	for child in mission_list.get_children():
		mission_list.remove_child(child)
		child.queue_free()
	for mission in CampaignStoreScript.MISSIONS:
		var available: bool = CampaignStoreScript.is_available(mission.id, completed_missions)
		var complete: bool = mission.id in completed_missions
		var entry := VBoxContainer.new()
		entry.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		entry.add_theme_constant_override("separation", 4)
		mission_list.add_child(entry)

		var button := Button.new()
		button.custom_minimum_size.y = 58
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.disabled = not available
		button.text = "%s  %02d · %s  ·  %d BATTLE%s  ·  UP TO %d HP\n%s" % [
			"✓" if complete else ("◆" if available else "🔒"),
			mission.id + 1,
			mission.title.to_upper(),
			mission.encounters.size(),
			"" if mission.encounters.size() == 1 else "S",
			mission.enemy_hp,
			mission.briefing
		]
		button.pressed.connect(_prepare_mission.bind(mission.id))
		entry.add_child(button)

		var rewards := HBoxContainer.new()
		rewards.custom_minimum_size.y = 42
		rewards.add_theme_constant_override("separation", 8)
		entry.add_child(rewards)

		var reward_label := Label.new()
		var reward_options: Array = CampaignStoreScript.reward_options(mission.id, roster)
		reward_label.text = (
			"CARD DROPS" if not reward_options.is_empty()
			else "NO IMPLEMENTED CARD DROP"
		)
		reward_label.custom_minimum_size.x = 118
		reward_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		reward_label.add_theme_font_size_override("font_size", 11)
		reward_label.add_theme_color_override("font_color", Color("#8fa5ca"))
		rewards.add_child(reward_label)

		for option in reward_options:
			var reward_unit: Dictionary = option.unit
			var tile := VBoxContainer.new()
			tile.custom_minimum_size = Vector2(34, 40)
			tile.add_theme_constant_override("separation", 0)
			rewards.add_child(tile)

			var portrait := TextureRect.new()
			portrait.custom_minimum_size = Vector2(32, 30)
			portrait.texture = _unit_icon(reward_unit.icon)
			portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			portrait.mouse_default_cursor_shape = Control.CURSOR_HELP
			portrait.mouse_entered.connect(
				_show_reward_details.bind(reward_unit, float(option.chance))
			)
			portrait.mouse_exited.connect(_hide_unit_details)
			tile.add_child(portrait)

			var stars := Label.new()
			stars.text = "★".repeat(reward_unit.get("stars", 1))
			stars.mouse_filter = Control.MOUSE_FILTER_IGNORE
			stars.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			stars.add_theme_font_size_override("font_size", 9)
			stars.add_theme_color_override("font_color", Color("#ffd166"))
			tile.add_child(stars)

		var divider := HSeparator.new()
		divider.mouse_filter = Control.MOUSE_FILTER_IGNORE
		entry.add_child(divider)

func _prepare_mission(mission_id: int) -> void:
	if not CampaignStoreScript.is_available(mission_id, completed_missions):
		return
	mission_overlay.visible = false
	input_enabled = true
	_open_squad_builder()
	squad_opened_for_mission = true
	pending_mission_id = mission_id
	_rebuild_squad_grid()

func _begin_practice() -> void:
	campaign_battle = false
	current_mission_id = -1
	current_encounter_index = 0
	awaiting_next_encounter = false
	main_menu_overlay.visible = false
	mission_overlay.visible = false
	_start_new_match()
	_show_tutorial_once()

func _begin_mission(mission_id: int) -> void:
	if not CampaignStoreScript.is_available(mission_id, completed_missions):
		return
	campaign_battle = true
	current_mission_id = mission_id
	current_encounter_index = 0
	mission_run_captain_hp = STARTING_HP
	awaiting_next_encounter = false
	main_menu_overlay.visible = false
	mission_overlay.visible = false
	_start_new_match()
	status_message = CampaignStoreScript.MISSIONS[mission_id].briefing
	_refresh()
	_show_tutorial_once()

func _resume_mission() -> void:
	var saved_run: Dictionary = MissionRunStoreScript.load_run(CampaignStoreScript.MISSIONS.size())
	if saved_run.is_empty():
		return
	if saved_run.encounter_index >= CampaignStoreScript.encounter_count(saved_run.mission_id):
		MissionRunStoreScript.clear_run()
		_show_main_menu()
		return
	campaign_battle = true
	current_mission_id = saved_run.mission_id
	current_encounter_index = saved_run.encounter_index
	mission_run_captain_hp = saved_run.captain_hp
	awaiting_next_encounter = false
	main_menu_overlay.visible = false
	mission_overlay.visible = false
	_start_new_match()
	_show_tutorial_once()

func _show_tutorial_once() -> void:
	if not has_shown_tutorial:
		has_shown_tutorial = true
		_open_tutorial()

func _open_tutorial_from_menu() -> void:
	main_menu_overlay.visible = false
	tutorial_opened_from_menu = true
	_open_tutorial()

func _open_squad_from_menu() -> void:
	main_menu_overlay.visible = false
	input_enabled = true
	_open_squad_builder()
	squad_opened_from_menu = true

func _build_hover_card() -> void:
	hover_card = PanelContainer.new()
	hover_card.custom_minimum_size = Vector2(340, 236)
	hover_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hover_card.z_index = 100
	hover_card.visible = false

	var style := StyleBoxFlat.new()
	style.bg_color = Color("#111d36")
	style.border_color = Color("#66d9ff")
	style.set_border_width_all(2)
	style.set_corner_radius_all(12)
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	hover_card.add_theme_stylebox_override("panel", style)
	add_child(hover_card)

	var content := VBoxContainer.new()
	content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	content.add_theme_constant_override("separation", 6)
	hover_card.add_child(content)

	hover_name_label = Label.new()
	hover_name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hover_name_label.add_theme_font_size_override("font_size", 18)
	hover_name_label.add_theme_color_override("font_color", Color("#71e6f5"))
	content.add_child(hover_name_label)

	hover_stats_label = Label.new()
	hover_stats_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hover_stats_label.add_theme_font_size_override("font_size", 13)
	hover_stats_label.add_theme_color_override("font_color", Color("#e7edf8"))
	content.add_child(hover_stats_label)

	hover_ability_label = Label.new()
	hover_ability_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hover_ability_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hover_ability_label.add_theme_font_size_override("font_size", 13)
	hover_ability_label.add_theme_color_override("font_color", Color("#aebdda"))
	content.add_child(hover_ability_label)

func _show_unit_details(unit: Dictionary) -> void:
	var definition: Dictionary = UnitCatalogScript.by_name(unit.name)
	if definition.is_empty():
		definition = unit
	var current_hp: int = unit.get("hp", definition.hp)
	var maximum_hp: int = unit.get("max_hp", definition.hp)
	var hp_text := "%d HP" % current_hp
	if current_hp != maximum_hp:
		hp_text = "%d / %d HP" % [current_hp, maximum_hp]

	hover_name_label.text = "%s  ·  %s" % [
		definition.name.to_upper(),
		UnitCatalogScript.display_class(definition.kind)
	]
	hover_stats_label.text = "%d MANA · %s\n%d ATK    %s    %d MOV    %d RANGE" % [
		definition.cost,
		"★".repeat(definition.get("stars", 1)),
		unit.get("atk", definition.atk),
		hp_text,
		definition.move,
		definition.range
	]
	var active_effects: String = CaptainSkillsScript.effect_summary(unit)
	hover_ability_label.text = definition.text
	var skill: Dictionary = definition.get("skill", {})
	if not skill.is_empty():
		hover_ability_label.text += "\n\n%s · %s\n%s\n%s" % [
			skill.name.to_upper(),
			skill.type.to_upper(),
			skill.text,
			UnitSkillsScript.timing_tooltip(skill.type)
		]
	if not active_effects.is_empty():
		hover_ability_label.text += "\nActive: " + active_effects
	hover_card.visible = true
	_position_hover_card()

func _show_reward_details(unit: Dictionary, chance: float) -> void:
	_show_unit_details(unit)
	hover_ability_label.text += "\nDrop likelihood: %.1f%% on mission victory." % (chance * 100.0)

func _hide_unit_details() -> void:
	hover_card.visible = false

func _process(_delta: float) -> void:
	if hover_card != null and hover_card.visible:
		_position_hover_card()

func _position_hover_card() -> void:
	var pointer := get_viewport().get_mouse_position()
	var card_size := Vector2(340, 236)
	var viewport_size := get_viewport_rect().size
	var target := pointer + Vector2(18, 18)
	if target.x + card_size.x > viewport_size.x - 10:
		target.x = pointer.x - card_size.x - 18
	if target.y + card_size.y > viewport_size.y - 10:
		target.y = viewport_size.y - card_size.y - 10
	hover_card.position = Vector2(maxf(10, target.x), maxf(10, target.y))

func _start_new_match() -> void:
	units.clear()
	combat_log_lines.clear()
	last_logged_message = ""
	if combat_log_label != null:
		combat_log_label.text = ""
	player_hand.clear()
	enemy_hand.clear()
	battle_deck = SquadStoreScript.shuffle_for_battle(
		SquadStoreScript.build_deck(squad_names, roster)
	)
	var encounter: Dictionary = CampaignStoreScript.encounter(current_mission_id, current_encounter_index) if campaign_battle else {}
	var enemy_squad_names: Array = CampaignStoreScript.enemy_squad_names(
		current_mission_id, current_encounter_index, roster
	)
	enemy_deck = SquadStoreScript.shuffle_for_battle(
		SquadStoreScript.build_deck(enemy_squad_names, roster)
	)
	draw_index = 0
	enemy_draw_index = 0
	selected_hand_index = -1
	selected_board_unit_id = -1
	pending_empower_actor_id = -1
	next_unit_id = 1
	round_number = 1
	player_hp = mission_run_captain_hp if campaign_battle else STARTING_HP
	enemy_hp = STARTING_HP if not campaign_battle else encounter.enemy_hp
	player_max_energy = 2
	player_energy = 2
	enemy_max_energy = 2
	enemy_energy = 2
	player_power_used = false
	enemy_power_used = false
	player_shield = 0
	enemy_shield = 0
	player_shield_turns = 0
	enemy_shield_turns = 0
	enemy_captain_skill = encounter.get("skill", "Shield") if campaign_battle else "Shield"
	input_enabled = true
	battle_over = false
	mission_finished = false
	overlay.visible = false
	status_message = "Select a unit card, then choose a deployment lane."
	if campaign_battle:
		status_message = "Battle %d/%d · %s" % [
			current_encounter_index + 1,
			CampaignStoreScript.encounter_count(current_mission_id),
			encounter.title
		]
		MissionRunStoreScript.save_run(current_mission_id, current_encounter_index, player_hp)
	for i in 4:
		_draw_player_card()
		_draw_enemy_card()
	_refresh()

func _draw_player_card() -> void:
	if player_hand.size() >= BENCH_LIMIT or draw_index >= battle_deck.size():
		return
	player_hand.append(battle_deck[draw_index].duplicate())
	draw_index += 1

func _draw_enemy_card() -> void:
	if enemy_hand.size() >= BENCH_LIMIT or enemy_draw_index >= enemy_deck.size():
		return
	enemy_hand.append(enemy_deck[enemy_draw_index].duplicate())
	enemy_draw_index += 1

func _refresh() -> void:
	_log_action(status_message)
	var player_locked_mana := BattleRulesScript.locked_mana(units, PLAYER)
	var enemy_locked_mana := BattleRulesScript.locked_mana(units, ENEMY)
	turn_label.text = "ROUND %02d  ·  YOUR COMMAND" % round_number if input_enabled else "ROUND %02d  ·  RESOLVING" % round_number
	hint_label.text = status_message
	end_button.disabled = (
		not input_enabled or battle_over or pending_empower_actor_id >= 0
	)
	menu_button.disabled = not input_enabled or battle_over
	power_button.disabled = not input_enabled or player_power_used or battle_over
	power_button.text = "%s USED" % player_captain_skill.to_upper() if player_power_used else player_captain_skill.to_upper()
	power_button.tooltip_text = CaptainSkillsScript.DESCRIPTIONS[player_captain_skill]

	var selected := {}
	if selected_hand_index >= 0 and selected_hand_index < player_hand.size():
		selected = player_hand[selected_hand_index]
	var targetable_ids: Array = []
	if pending_empower_actor_id >= 0:
		targetable_ids = units.filter(
			func(unit): return unit.side == PLAYER and unit.id != pending_empower_actor_id
		).map(func(unit): return unit.id)
	board.set_state(
		units, selected, selected_board_unit_id,
		input_enabled and not battle_over, status_message, targetable_ids,
		"%d / %d\n%d LOCKED" % [player_energy, player_max_energy, player_locked_mana],
		"%d / %d\n%d LOCKED" % [enemy_energy, enemy_max_energy, enemy_locked_mana],
		"%d HP%s" % [player_hp, "\n%d SHIELD" % player_shield if player_shield > 0 else ""],
		"%d HP%s" % [enemy_hp, "\n%d SHIELD" % enemy_shield if enemy_shield > 0 else ""],
		"DECK %d" % (battle_deck.size() - draw_index),
		"DECK %d" % (enemy_deck.size() - enemy_draw_index)
	)
	_rebuild_hand()

func _rebuild_hand() -> void:
	for child in hand_row.get_children():
		hand_row.remove_child(child)
		child.queue_free()

	for i in player_hand.size():
		var card: Dictionary = player_hand[i]
		var button := Button.new()
		button.custom_minimum_size = Vector2(170, 98)
		button.toggle_mode = true
		button.button_pressed = i == selected_hand_index
		button.disabled = not input_enabled or card.cost > player_energy or battle_over
		button.icon = _unit_icon(card.get("icon", 0))
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.text = "%s\n%d◆ · %s\n%d ATK · %d HP" % [
			card.name.to_upper(), card.cost, UnitCatalogScript.display_class(card.kind),
			card.atk, card.hp
		]
		_apply_class_card_style(button, card.kind)
		button.add_theme_font_size_override("font_size", 10)
		button.pressed.connect(_select_card.bind(i))
		button.mouse_entered.connect(_show_unit_details.bind(card))
		button.mouse_exited.connect(_hide_unit_details)
		hand_row.add_child(button)

func _apply_class_card_style(button: Button, kind: String) -> void:
	var color: Color = UnitCatalogScript.class_color(kind)
	button.add_theme_stylebox_override("normal", _class_card_style(color, 0.13, 0.50, 1))
	button.add_theme_stylebox_override("hover", _class_card_style(color, 0.23, 0.90, 3))
	button.add_theme_stylebox_override("pressed", _class_card_style(color, 0.28, 1.0, 4))
	button.add_theme_stylebox_override("disabled", _class_card_style(color, 0.07, 0.24, 0))

func _class_card_style(
	color: Color, tint: float, border_alpha: float, glow: int
) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#0d162b").lerp(color, tint)
	style.border_color = Color(color, border_alpha)
	style.set_border_width_all(1)
	style.set_corner_radius_all(8)
	style.content_margin_left = 8
	style.content_margin_right = 8
	style.shadow_color = Color(color, 0.22 if glow > 0 else 0.0)
	style.shadow_size = glow
	return style

func _unit_icon(icon_id: int) -> Texture2D:
	return _unit_icon_at_size(icon_id, 48)

func _unit_icon_at_size(icon_id: int, size: int) -> Texture2D:
	if icon_id < 1 or icon_id > 48:
		return null
	var cache_key := "%d:%d" % [icon_id, size]
	if unit_icon_cache.has(cache_key):
		return unit_icon_cache[cache_key]
	var sheets: Array[Texture2D] = [
		UNIT_SPRITES_1, UNIT_SPRITES_2, UNIT_SPRITES_3, UNIT_SPRITES_4,
		UNIT_SPRITES_5, UNIT_SPRITES_6, UNIT_SPRITES_7, UNIT_SPRITES_8
	]
	var atlas: Texture2D = sheets[int((icon_id - 1) / 6)]
	var source_image: Image = atlas.get_image()
	var icon_image := source_image.get_region(
		Rect2i(((icon_id - 1) % 6) * 100, 0, 100, 100)
	)
	icon_image.resize(size, size, Image.INTERPOLATE_LANCZOS)
	var icon := ImageTexture.create_from_image(icon_image)
	unit_icon_cache[cache_key] = icon
	return icon

func _show_card_reward(unit_name: String, is_new: bool) -> void:
	var unit: Dictionary = UnitCatalogScript.by_name(unit_name)
	reward_reveal.visible = not unit.is_empty()
	if unit.is_empty():
		return
	reward_portrait.texture = _unit_icon_at_size(unit.icon, 100)
	reward_stars_label.text = "★".repeat(unit.get("stars", 1))
	reward_new_label.visible = is_new

func _select_card(index: int) -> void:
	if not input_enabled:
		return
	if pending_empower_actor_id >= 0:
		status_message = "Choose an allied target for Empower first."
		_refresh()
		return
	selected_hand_index = -1 if selected_hand_index == index else index
	selected_board_unit_id = -1
	if selected_hand_index >= 0:
		status_message = "Choose a highlighted tile on your deployment edge."
	else:
		status_message = "Select a unit card, then choose a deployment lane."
	_refresh()

func _on_board_cell_clicked(row: int, col: int) -> void:
	if not input_enabled or battle_over:
		return
	var clicked = _unit_at(row, col)
	if pending_empower_actor_id >= 0:
		var actor = _unit_by_id(pending_empower_actor_id)
		if (
			actor != null and clicked != null
			and clicked.side == PLAYER and clicked.id != actor.id
		):
			pending_empower_actor_id = -1
			status_message = await _resolve_warcry(actor, clicked.id)
		else:
			status_message = "Choose another allied unit as Empower's target."
		_refresh()
		return
	if selected_board_unit_id >= 0:
		var selected = _unit_by_id(selected_board_unit_id)
		if selected == null:
			selected_board_unit_id = -1
		elif clicked != null and clicked.side == PLAYER:
			selected_board_unit_id = clicked.id
			status_message = _reposition_status(clicked)
		elif BattleRulesScript.can_reposition(selected, row, units) and col == selected.col:
			var old_row: int = selected.row
			var old_col: int = selected.col
			selected.row = row
			selected_board_unit_id = selected.id
			status_message = "%s shifts from lane %d to lane %d. Choose another lane or continue." % [selected.name, old_row + 1, row + 1]
			input_enabled = false
			_refresh()
			await board.animate_unit_move(selected.id, old_row, old_col, 0.24)
			input_enabled = true
			board.play_unit_effect(selected.id, "SHIFT", Color("#71e6f5"))
		else:
			status_message = _reposition_block_reason(selected, row, col)
			selected_board_unit_id = -1
	elif clicked != null and clicked.side == PLAYER:
		selected_hand_index = -1
		selected_board_unit_id = clicked.id
		status_message = _reposition_status(clicked)
	_refresh()

func _reposition_status(unit: Dictionary) -> String:
	if BattleRulesScript.is_taunted(unit, units):
		return "%s is taunted by a Defender and cannot leave this lane." % unit.name
	return "Choose a reachable highlighted tile in another lane to reposition %s." % unit.name

func _reposition_block_reason(unit: Dictionary, row: int, col: int) -> String:
	if BattleRulesScript.is_taunted(unit, units):
		return "%s is taunted and must remain in its lane." % unit.name
	if col != unit.col or row == unit.row:
		return "Units can only shift between lanes in the same column."
	return "Another unit blocks that lane shift."

func _on_deployment_clicked(row: int) -> void:
	if not input_enabled or selected_hand_index < 0 or selected_hand_index >= player_hand.size():
		return
	if pending_empower_actor_id >= 0:
		status_message = "Choose an allied target for Empower first."
		_refresh()
		return
	if _unit_at(row, 0) != null:
		status_message = "That deployment tile is occupied."
		_refresh()
		return

	var card: Dictionary = player_hand[selected_hand_index]
	if card.cost > player_energy:
		return
	player_energy -= card.cost
	var spawned: Dictionary = _spawn_unit(card, PLAYER, row, 0)
	status_message = "%s deployed to lane %d." % [card.name, row + 1]
	input_enabled = false
	_refresh()
	await board.animate_unit_move(spawned.id, row, -1, 0.32)
	input_enabled = true
	var warcry_message := await _resolve_warcry(spawned)
	if not warcry_message.is_empty():
		status_message += " " + warcry_message
	player_hand.remove_at(selected_hand_index)
	selected_hand_index = -1
	_refresh()

func _spawn_unit(card: Dictionary, side: int, row: int, col: int) -> Dictionary:
	var spawned := {
		"id": next_unit_id,
		"side": side,
		"row": row,
		"col": col,
		"name": card.name,
		"icon": card.get("icon", 0),
		"kind": card.kind,
		"cost": card.cost,
		"atk": card.atk,
		"hp": card.hp,
		"max_hp": card.hp,
		"move": card.move,
		"range": card.range,
		"skill": card.get("skill", {}).duplicate(true),
		# Deployment is part of the turn: newly placed units move and attack
		# when that side resolves immediately afterward.
		"ready": true,
		"repositioned": false,
		"taunt_turns": 0,
		"immobilized_turns": 0,
		"fury_stacks": 0,
		"effects": []
	}
	units.append(spawned)
	next_unit_id += 1
	UnitSkillsScript.refresh_auras(units)
	return spawned

func _resolve_warcry(actor: Dictionary, target_id: int = -1) -> String:
	var skill: Dictionary = actor.get("skill", {})
	var has_other_ally := units.any(
		func(unit): return unit.side == PLAYER and unit.id != actor.id
	)
	if (
		actor.side == PLAYER and skill.get("name", "") == "Empower"
		and target_id < 0
		and has_other_ally
	):
		pending_empower_actor_id = actor.id
		return "Choose another allied unit as Empower's target."
	var result: Dictionary = UnitSkillsScript.resolve_warcry(actor, units, target_id)
	for unit_id in result.affected:
		var target = _unit_by_id(unit_id)
		if target != null:
			board.play_unit_effect(
				target.id, skill.get("name", "WARCRY").to_upper(), Color("#ffd166")
			)
			if skill.get("name", "") in ["Bolt", "Heaven's Wrath"]:
				await board.animate_hit(target.id, 0.16 / resolution_speed)
			elif skill.get("name", "") in ["Fortify", "Empower"]:
				await board.animate_heal(actor.id, target.id, 0.24 / resolution_speed)
	if not result.message.is_empty():
		_log_action("%s [WARCRY · %s] %s" % [
			actor.name, skill.get("name", "Unknown"), result.message
		])
	await _animate_defeated_units()
	_remove_defeated()
	UnitSkillsScript.refresh_auras(units)
	return result.message

func _use_player_power() -> void:
	if player_power_used or not input_enabled:
		return
	var applied: bool = await _apply_captain_skill(PLAYER, player_captain_skill)
	if not applied:
		_refresh()
		return
	player_power_used = true
	_refresh()

func _end_player_turn() -> void:
	if not input_enabled or battle_over:
		return
	if pending_empower_actor_id >= 0:
		status_message = "Choose an allied target for Empower before resolving."
		_refresh()
		return
	status_message = _resolution_preview(PLAYER)
	_refresh()
	await _wait(0.8)
	input_enabled = false
	selected_hand_index = -1
	selected_board_unit_id = -1
	status_message = "Your units advance."
	_refresh()
	await _resolve_side(PLAYER)
	_expire_side_effects(PLAYER)
	if _check_game_over():
		return
	await _wait(0.35)
	await _enemy_turn()

func _enemy_turn() -> void:
	for unit in units:
		if unit.side == ENEMY:
			unit.ready = true
			unit.repositioned = false
	_resolve_chants(ENEMY)
	if round_number > 1:
		enemy_max_energy = mini(10, enemy_max_energy + 2)
	enemy_energy = BattleRulesScript.available_mana(enemy_max_energy, units, ENEMY)
	if round_number > 1:
		_draw_enemy_card()
	status_message = "Enemy is deploying..."
	_refresh()
	await _wait(0.55)
	await _enemy_reposition_units()

	var attempts := 0
	while attempts < 3:
		var choice: Dictionary = BattleAIScript.choose_deployment(enemy_hand, enemy_energy, units)
		if choice.is_empty():
			break
		var card: Dictionary = choice.card
		var row: int = choice.row
		var spawned: Dictionary = _spawn_unit(card, ENEMY, row, COLS - 1)
		enemy_energy -= card.cost
		var hand_index: int = enemy_hand.find(card)
		if hand_index >= 0:
			enemy_hand.remove_at(hand_index)
			status_message = "Enemy deployed %s to lane %d." % [card.name, row + 1]
			_refresh()
			await board.animate_unit_move(spawned.id, row, COLS, 0.32 / resolution_speed)
			var warcry_message := await _resolve_warcry(spawned)
			if not warcry_message.is_empty():
				status_message += " " + warcry_message
		_refresh()
		await _wait(0.35)
		attempts += 1

	if (
		not enemy_power_used
		and BattleAIScript.should_use_captain_skill(
			enemy_captain_skill, round_number, enemy_hp, units
		)
	):
		var skill_applied: bool = await _apply_captain_skill(ENEMY, enemy_captain_skill)
		if skill_applied:
			enemy_power_used = true
			status_message = "Enemy Captain: " + status_message
			_refresh()
			await _wait(0.45)

	status_message = _resolution_preview(ENEMY)
	_refresh()
	await _wait(0.8)
	status_message = "Enemy units advance."
	_refresh()
	await _resolve_side(ENEMY)
	_expire_side_effects(ENEMY)
	if _check_game_over():
		return

	round_number += 1
	player_max_energy = mini(10, player_max_energy + 2)
	player_energy = BattleRulesScript.available_mana(player_max_energy, units, PLAYER)
	_draw_player_card()
	for unit in units:
		if unit.side == PLAYER:
			unit.ready = true
			unit.repositioned = false
	_resolve_chants(PLAYER)
	input_enabled = true
	status_message = "Select a card or resolve the board as it stands."
	_refresh()

func _enemy_reposition_units() -> void:
	var enemy_ids: Array = units.filter(func(unit): return unit.side == ENEMY).map(func(unit): return unit.id)
	for unit_id in enemy_ids:
		var unit = _unit_by_id(unit_id)
		if unit == null or BattleRulesScript.is_taunted(unit, units):
			continue
		var best_row: int = BattleAIScript.choose_reposition(unit, units)
		if best_row != unit.row:
			var old_row: int = unit.row
			var old_col: int = unit.col
			unit.row = best_row
			status_message = "%s shifts from lane %d to lane %d." % [unit.name, old_row + 1, best_row + 1]
			_refresh()
			await board.animate_unit_move(unit.id, old_row, old_col, 0.24 / resolution_speed)
			board.play_unit_effect(unit.id, "SHIFT", Color("#ff8b9f"))
			_refresh()
			await _wait(0.28)

func _player_lane_threat(row: int, enemy_col: int) -> int:
	var threat := 0
	for unit in units:
		if unit.side == PLAYER and unit.row == row and unit.col < enemy_col:
			threat += unit.atk + (2 if unit.kind == "Warden" else 0)
	return threat

func _resolve_side(side: int) -> void:
	var acting_ids: Array = []
	var side_units := units.filter(func(u): return u.side == side and u.ready)
	side_units.sort_custom(func(a, b):
		if a.col == b.col:
			return a.row < b.row
		return a.col > b.col if side == PLAYER else a.col < b.col
	)
	for unit in side_units:
		acting_ids.append(unit.id)

	for id in acting_ids:
		var actor = _unit_by_id(id)
		if actor == null or actor.side != side:
			continue
		await _activate_unit(actor)
		_remove_defeated()
		_refresh()
		if player_hp <= 0 or enemy_hp <= 0:
			return
		await _wait(0.32)

func _resolution_preview(side: int) -> String:
	var ordered := units.filter(func(unit): return unit.side == side and unit.ready)
	ordered.sort_custom(func(a, b):
		if a.col == b.col:
			return a.row < b.row
		return a.col > b.col if side == PLAYER else a.col < b.col
	)
	if ordered.is_empty():
		return "UPCOMING · No ready units."
	var entries: Array[String] = []
	for index in mini(3, ordered.size()):
		var unit: Dictionary = ordered[index]
		var preview: Dictionary = BattleRulesScript.projected_action(unit.id, units)
		var move_count: int = preview.get("traversal", []).size()
		var attack_count: int = preview.get("attack", []).size()
		entries.append("%d %s M%d→A%d" % [index + 1, unit.name, move_count, attack_count])
	if ordered.size() > 3:
		entries.append("+%d more (see LOG)" % (ordered.size() - 3))
	return "UPCOMING · " + "  |  ".join(entries)

func _actor_tag(actor: Dictionary) -> String:
	var unit_class: String = UnitCatalogScript.display_class(actor.kind)
	var skill: Dictionary = actor.get("skill", {})
	if skill.is_empty():
		return "%s [%s]" % [actor.name, unit_class]
	return "%s [%s · %s %s]" % [
		actor.name, unit_class, skill.get("type", "Skill"), skill.get("name", "Unknown")
	]

func _activate_unit(actor: Dictionary) -> void:
	if actor.kind == "Lifebinder":
		var healing_target = _lowest_health_ally(actor)
		if healing_target != null:
			await board.animate_heal(actor.id, healing_target.id, 0.30 / resolution_speed)
			healing_target.hp += 2
			status_message = "%s heals %s for 2 HP." % [_actor_tag(actor), healing_target.name]
			board.play_unit_effect(healing_target.id, "+2 HP", Color("#70e0a1"))
			_refresh()
			await _wait(0.22)

	var path: Array = BattleRulesScript.traversal_cells(actor, units)
	if not path.is_empty():
		var old_row: int = actor.row
		var old_col: int = actor.col
		actor.col = path[-1].x
		status_message = "%s advances %d space%s." % [
			_actor_tag(actor), path.size(), "" if path.size() == 1 else "s"
		]
		_refresh()
		await board.animate_unit_move(actor.id, old_row, old_col, 0.30 / resolution_speed)
		board.play_unit_effect(actor.id, "ADVANCE", Color("#71e6f5"))
	else:
		status_message = "%s cannot advance." % _actor_tag(actor)

	var target = _find_target(actor)
	if target != null:
		var strikes := 2 if actor.kind == "Strider" else 1
		for hit in strikes:
			if target == null or target.hp <= 0:
				target = _find_target(actor)
			if target == null:
				break
			await board.animate_attack(actor.id, target.id, actor.kind, 0.24 / resolution_speed)
			target.hp -= actor.atk
			status_message = "%s hits %s for %d." % [_actor_tag(actor), target.name, actor.atk]
			var impact_label := "-%d" % actor.atk
			var impact_color := Color("#ff668f")
			if actor.kind == "Channeler":
				impact_label += " BLAST"
				impact_color = Color("#c99cff")
			elif actor.kind == "Artillerist":
				impact_label += " PIERCE"
				impact_color = Color("#ffd166")
			board.play_unit_effect(target.id, impact_label, impact_color)
			var secondary_hits: Array = _apply_special_damage(actor, target)
			await board.animate_hit(target.id, 0.18 / resolution_speed)
			for secondary_id in secondary_hits:
				await board.animate_hit(secondary_id, 0.14 / resolution_speed)
			if actor.kind == "Warden" and target.hp > 0:
				BattleRulesScript.apply_taunt(target)
				status_message += " Taunting Strike locks %s for 2 turns." % target.name
				board.play_unit_effect(target.id, "TAUNT 2", Color("#ff9d66"))
			var strike_result: Dictionary = UnitSkillsScript.resolve_strike(actor, target, units)
			if not strike_result.message.is_empty():
				status_message += " " + strike_result.message
				board.play_unit_effect(target.id, "IMMOBILISED", Color("#ffd166"))
			var reaction_result: Dictionary = UnitSkillsScript.resolve_reaction(target, actor, units)
			if not reaction_result.message.is_empty():
				status_message += " " + reaction_result.message
			await _animate_defeated_units()
			_remove_defeated()
			_refresh()
			if hit + 1 < strikes:
				await _wait(0.18)
		if actor.kind == "Duelist" and _unit_by_id(actor.id) != null:
			actor.atk += 1
			actor.fury_stacks = actor.get("fury_stacks", 0) + 1
			status_message += " Its ATK rises."
			board.play_unit_effect(actor.id, "FURY +1", Color("#ffd166"))
		return

	if _commander_in_range(actor):
		var strikes := 2 if actor.kind == "Strider" else 1
		var commander_side := ENEMY if actor.side == PLAYER else PLAYER
		var total_dealt := 0
		for hit in strikes:
			await board.animate_commander_attack(
				actor.id, commander_side, actor.kind, 0.25 / resolution_speed
			)
			var dealt := _damage_captain(commander_side, actor.atk)
			total_dealt += dealt
			status_message = "%s hits %s Commander for %d." % [
				_actor_tag(actor), "the enemy" if actor.side == PLAYER else "your", dealt
			]
			_refresh()
			board.play_commander_effect(commander_side, "-%d HP" % dealt, Color("#ff668f"))
			if hit + 1 < strikes:
				await _wait(0.12)
		status_message = "%s strikes %s Commander for %d!" % [
			_actor_tag(actor), "the enemy" if actor.side == PLAYER else "your", total_dealt
		]
		if actor.kind == "Duelist" and _unit_by_id(actor.id) != null:
			actor.atk += 1
			actor.fury_stacks = actor.get("fury_stacks", 0) + 1
			status_message += " Fury grants +1 ATK."
		return

func _apply_special_damage(actor: Dictionary, target: Dictionary) -> Array:
	var affected_ids: Array = []
	if actor.kind == "Channeler":
		var splash_damage := maxi(1, int(actor.atk / 2))
		var blast_cells: Array = BattleRulesScript.blast_cells(target)
		for other in units:
			if other.id != target.id and other.side == target.side and Vector2i(other.col, other.row) in blast_cells:
				other.hp -= splash_damage
				affected_ids.append(other.id)
				board.play_unit_effect(other.id, "-%d BLAST" % splash_damage, Color("#c99cff"))
		status_message += " Blast deals %d damage to adjacent enemies." % splash_damage
	elif actor.kind == "Artillerist":
		var direction := 1 if actor.side == PLAYER else -1
		var pierced: Array = []
		for other in units:
			if other.id == target.id or other.side == actor.side or other.row != actor.row:
				continue
			var distance: int = (other.col - actor.col) * direction
			if distance > 0 and distance <= actor.range:
				other.hp -= actor.atk
				pierced.append(other.name)
				affected_ids.append(other.id)
				board.play_unit_effect(other.id, "-%d PIERCE" % actor.atk, Color("#ffd166"))
		if not pierced.is_empty():
			status_message += " Piercing Shot also hits %s." % ", ".join(pierced)
	return affected_ids

func _animate_defeated_units() -> void:
	var defeated_ids: Array = units.filter(
		func(unit): return unit.hp <= 0
	).map(func(unit): return unit.id)
	for unit_id in defeated_ids:
		await board.animate_defeat(unit_id, 0.26 / resolution_speed)

func _find_target(actor: Dictionary):
	var direction := 1 if actor.side == PLAYER else -1
	var candidates := []
	for other in units:
		if other.side == actor.side or other.row != actor.row:
			continue
		var distance: int = (other.col - actor.col) * direction
		if distance > 0 and distance <= actor.range:
			candidates.append(other)
	if candidates.is_empty():
		return null
	candidates.sort_custom(func(a, b): return absi(a.col - actor.col) < absi(b.col - actor.col))
	return candidates[0]

func _lowest_health_ally(actor: Dictionary):
	var candidates := []
	for other in units:
		if other.side == actor.side and other.id != actor.id:
			candidates.append(other)
	if candidates.is_empty():
		return null
	candidates.sort_custom(func(a, b):
		if a.hp == b.hp:
			return a.id < b.id
		return a.hp < b.hp
	)
	return candidates[0]

func _commander_in_range(actor: Dictionary) -> bool:
	if actor.side == PLAYER:
		return (COLS - 1) - actor.col <= actor.range and _find_target(actor) == null
	return actor.col <= actor.range and _find_target(actor) == null

func _unit_at(row: int, col: int):
	for unit in units:
		if unit.row == row and unit.col == col:
			return unit
	return null

func _unit_by_id(id: int):
	for unit in units:
		if unit.id == id:
			return unit
	return null

func _remove_defeated() -> void:
	units = units.filter(func(unit): return unit.hp > 0)
	player_energy = BattleRulesScript.available_mana(player_max_energy, units, PLAYER)
	enemy_energy = BattleRulesScript.available_mana(enemy_max_energy, units, ENEMY)

func _apply_captain_skill(side: int, skill_name: String) -> bool:
	var captain_hp: int = player_hp if side == PLAYER else enemy_hp
	var result: Dictionary = CaptainSkillsScript.apply(skill_name, side, units, captain_hp)
	status_message = result.message
	if not result.success:
		return false
	_log_action("%s CAPTAIN [SKILL · %s] %s" % [
		"YOUR" if side == PLAYER else "ENEMY", skill_name, result.message
	])

	if result.shield > 0:
		if side == PLAYER:
			player_shield = result.shield
			player_shield_turns = result.shield_turns
		else:
			enemy_shield = result.shield
			enemy_shield_turns = result.shield_turns

	if result.captain_damage > 0:
		var target_side := ENEMY if side == PLAYER else PLAYER
		var dealt := _damage_captain(target_side, result.captain_damage)
		_refresh()
		board.play_commander_effect(target_side, "-%d HP" % dealt, Color("#ff668f"))

	for unit_id in result.affected:
		var target = _unit_by_id(unit_id)
		if target != null:
			board.play_unit_effect(target.id, "SKILL", Color("#ffd166") if side == PLAYER else Color("#ff8b9f"))
			if skill_name in ["Lightning Burst", "Firestorm"]:
				await board.animate_hit(target.id, 0.16 / resolution_speed)
	await _animate_defeated_units()
	_remove_defeated()
	return true

func _expire_side_effects(side: int) -> void:
	CaptainSkillsScript.expire_effects(units, side)
	BattleRulesScript.expire_taunts(units, side)
	UnitSkillsScript.expire_statuses(units, side)
	if side == PLAYER and player_shield_turns > 0:
		player_shield_turns -= 1
		if player_shield_turns == 0:
			player_shield = 0
	elif side == ENEMY and enemy_shield_turns > 0:
		enemy_shield_turns -= 1
		if enemy_shield_turns == 0:
			enemy_shield = 0

func _resolve_chants(side: int) -> void:
	for result in UnitSkillsScript.resolve_chants(side, units):
		if not result.get("message", "").is_empty():
			status_message = result.message
			_log_action("[%s CHANT] %s" % ["ALLY" if side == PLAYER else "ENEMY", result.message])
		for unit_id in result.get("affected", []):
			var target = _unit_by_id(unit_id)
			if target != null:
				board.play_unit_effect(target.id, "CHANT", Color("#ffd166"))
	_remove_defeated()
	UnitSkillsScript.refresh_auras(units)

func _damage_captain(side: int, damage: int) -> int:
	var remaining := damage
	if side == PLAYER and player_shield > 0:
		var absorbed := mini(player_shield, remaining)
		player_shield -= absorbed
		remaining -= absorbed
	elif side == ENEMY and enemy_shield > 0:
		var absorbed := mini(enemy_shield, remaining)
		enemy_shield -= absorbed
		remaining -= absorbed
	if side == PLAYER:
		player_hp = maxi(0, player_hp - remaining)
	else:
		enemy_hp = maxi(0, enemy_hp - remaining)
	return remaining

func _on_result_primary() -> void:
	if awaiting_next_encounter:
		awaiting_next_encounter = false
		current_encounter_index += 1
		_start_new_match()
	elif mission_finished:
		_show_main_menu()
	else:
		_start_new_match()

func _check_game_over() -> bool:
	if player_hp > 0 and enemy_hp > 0:
		return false
	battle_over = true
	input_enabled = false
	overlay.visible = true
	reward_reveal.visible = false
	if enemy_hp <= 0:
		if campaign_battle:
			var encounter_count := CampaignStoreScript.encounter_count(current_mission_id)
			if current_encounter_index + 1 < encounter_count:
				awaiting_next_encounter = true
				mission_run_captain_hp = player_hp
				MissionRunStoreScript.save_run(current_mission_id, current_encounter_index + 1, mission_run_captain_hp)
				var next_encounter: Dictionary = CampaignStoreScript.encounter(current_mission_id, current_encounter_index + 1)
				overlay_title.text = "BATTLE WON"
				overlay_title.add_theme_color_override("font_color", Color("#67e6f4"))
				overlay_detail.text = "Captain HP carried forward: %d\nNext: Battle %d/%d · %s" % [
					player_hp, current_encounter_index + 2, encounter_count, next_encounter.title
				]
				result_primary_button.text = "CONTINUE MISSION"
				_refresh()
				return true
			completed_missions = CampaignStoreScript.complete_mission(current_mission_id, completed_missions)
			MissionRunStoreScript.clear_run()
			mission_finished = true
			var reward := CampaignStoreScript.roll_reward(current_mission_id, roster)
			var was_unlocked := reward in CampaignStoreScript.unlocked_unit_names(
				roster, earned_reward_units
			)
			earned_reward_units = CampaignStoreScript.award_reward(
				reward, roster, earned_reward_units
			)
			_show_card_reward(reward, not was_unlocked)
		overlay_title.text = "MISSION COMPLETE" if campaign_battle else "VICTORY"
		overlay_title.add_theme_color_override("font_color", Color("#67e6f4"))
		overlay_detail.text = "Victory achieved in %d rounds." % round_number
		result_primary_button.text = "RETURN TO MENU" if campaign_battle else "PLAY AGAIN"
	else:
		if campaign_battle:
			MissionRunStoreScript.clear_run()
		overlay_title.text = "DEFEAT"
		overlay_title.add_theme_color_override("font_color", Color("#ff668f"))
		overlay_detail.text = "Your skyway has fallen.\nRebuild your formation and try again."
		result_primary_button.text = "RETRY BATTLE"
	_refresh()
	return true

func _stat_label(color: Color) -> Label:
	var label := Label.new()
	label.custom_minimum_size.x = 170
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 20)
	label.add_theme_color_override("font_color", color)
	return label
