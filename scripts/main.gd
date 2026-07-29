extends Control

const BoardViewScript = preload("res://scripts/board_view.gd")
const UnitCatalogScript = preload("res://scripts/unit_catalog.gd")
const BattleAIScript = preload("res://scripts/battle_ai.gd")
const SquadStoreScript = preload("res://scripts/squad_store.gd")
const CampaignStoreScript = preload("res://scripts/campaign_store.gd")
const BattleRulesScript = preload("res://scripts/battle_rules.gd")
const CaptainSkillsScript = preload("res://scripts/captain_skills.gd")
const MissionRunStoreScript = preload("res://scripts/mission_run_store.gd")

const PLAYER := 0
const ENEMY := 1
const ROWS := 3
const COLS := 7
const STARTING_HP := 24

var board: BoardView
var player_hp_label: Label
var enemy_hp_label: Label
var energy_label: Label
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
var tutorial_overlay: ColorRect
var tutorial_page_label: Label
var tutorial_page := 0
var squad_overlay: ColorRect
var squad_grid: GridContainer
var squad_count_label: Label
var squad_save_button: Button
var squad_start_button: Button
var captain_skill_option: OptionButton
var hover_card: PanelContainer
var hover_name_label: Label
var hover_stats_label: Label
var hover_ability_label: Label
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
var draw_index := 0
var enemy_draw_index := 0
var selected_hand_index := -1
var selected_board_unit_id := -1
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

func _ready() -> void:
	_build_interface()
	completed_missions = CampaignStoreScript.load_completed()
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
	margin.add_theme_constant_override("margin_left", 28)
	margin.add_theme_constant_override("margin_right", 28)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_bottom", 22)
	add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 12)
	margin.add_child(root)

	var header := HBoxContainer.new()
	header.custom_minimum_size.y = 58
	root.add_child(header)

	var brand := Label.new()
	brand.text = "SKYCHAIN\nTACTICS"
	brand.add_theme_font_size_override("font_size", 19)
	brand.add_theme_color_override("font_color", Color("#71e6f5"))
	brand.custom_minimum_size.x = 210
	header.add_child(brand)

	player_hp_label = _stat_label(Color("#62e7ff"))
	header.add_child(player_hp_label)

	turn_label = Label.new()
	turn_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	turn_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	turn_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	turn_label.add_theme_font_size_override("font_size", 20)
	header.add_child(turn_label)

	enemy_hp_label = _stat_label(Color("#ff668f"))
	header.add_child(enemy_hp_label)

	board = BoardViewScript.new()
	board.custom_minimum_size = Vector2(0, 385)
	board.size_flags_vertical = Control.SIZE_EXPAND_FILL
	board.deployment_clicked.connect(_on_deployment_clicked)
	board.board_cell_clicked.connect(_on_board_cell_clicked)
	board.unit_hovered.connect(_show_unit_details)
	board.unit_hover_ended.connect(_hide_unit_details)
	root.add_child(board)

	var control_bar := HBoxContainer.new()
	control_bar.custom_minimum_size.y = 36
	control_bar.add_theme_constant_override("separation", 12)
	root.add_child(control_bar)

	energy_label = Label.new()
	energy_label.custom_minimum_size.x = 180
	energy_label.add_theme_font_size_override("font_size", 18)
	energy_label.add_theme_color_override("font_color", Color("#ffd166"))
	control_bar.add_child(energy_label)

	hint_label = Label.new()
	hint_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hint_label.add_theme_color_override("font_color", Color("#9fb2d6"))
	control_bar.add_child(hint_label)

	power_button = Button.new()
	power_button.text = "RALLY"
	power_button.tooltip_text = "Once per battle: all allies gain +1 ATK."
	power_button.custom_minimum_size.x = 160
	power_button.pressed.connect(_use_player_power)
	control_bar.add_child(power_button)

	var help_button := Button.new()
	help_button.text = "?"
	help_button.tooltip_text = "How to play"
	help_button.custom_minimum_size.x = 42
	help_button.pressed.connect(_open_tutorial)
	control_bar.add_child(help_button)

	var squad_button := Button.new()
	squad_button.text = "SQUAD"
	squad_button.tooltip_text = "Choose the 15 units in your battle squad."
	squad_button.custom_minimum_size.x = 90
	squad_button.pressed.connect(_open_squad_builder)
	control_bar.add_child(squad_button)

	menu_button = Button.new()
	menu_button.text = "MENU"
	menu_button.custom_minimum_size.x = 72
	menu_button.pressed.connect(_show_main_menu)
	control_bar.add_child(menu_button)

	end_button = Button.new()
	end_button.text = "RESOLVE TURN"
	end_button.custom_minimum_size.x = 170
	end_button.pressed.connect(_end_player_turn)
	control_bar.add_child(end_button)

	hand_row = HBoxContainer.new()
	hand_row.custom_minimum_size.y = 128
	hand_row.alignment = BoxContainer.ALIGNMENT_CENTER
	hand_row.add_theme_constant_override("separation", 10)
	root.add_child(hand_row)

	_build_overlay()
	_build_tutorial()
	_build_squad_builder()
	_build_main_menu()
	_build_mission_select()
	_build_hover_card()

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
	panel.custom_minimum_size = Vector2(480, 260)
	panel.alignment = BoxContainer.ALIGNMENT_CENTER
	panel.add_theme_constant_override("separation", 18)
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

	result_primary_button = Button.new()
	result_primary_button.text = "PLAY AGAIN"
	result_primary_button.custom_minimum_size = Vector2(180, 48)
	result_primary_button.pressed.connect(_on_result_primary)
	panel.add_child(result_primary_button)

	var return_menu := Button.new()
	return_menu.text = "RETURN TO MENU"
	return_menu.custom_minimum_size = Vector2(180, 44)
	return_menu.pressed.connect(_show_main_menu)
	panel.add_child(return_menu)

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
		"2 / 5\nCHOOSE A LANE\nDeploy on an open glowing tile at the left edge. New units rest until your next turn.",
		"3 / 5\nREPOSITION\nSelect one of your deployed units, then an open highlighted tile in an adjacent row. Each unit may shift once per turn.",
		"4 / 5\nTAUNTING STRIKE\nA unit hit by a Defender cannot change rows for its next two turns.",
		"5 / 5\nBREAK THE COMMANDER\nResolve the board, cross an open lane, and deal enough damage to defeat the enemy Commander."
	]
	tutorial_page_label.text = pages[tutorial_page]

func _build_squad_builder() -> void:
	squad_overlay = ColorRect.new()
	squad_overlay.color = Color(0.02, 0.035, 0.07, 0.97)
	squad_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	squad_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	squad_overlay.visible = false
	add_child(squad_overlay)

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
	instruction.text = "Choose 1–15 units, with no more than 2 copies each. The first selected unit is your Vanguard."
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

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	layout.add_child(scroll)

	squad_grid = GridContainer.new()
	squad_grid.columns = 3
	squad_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	squad_grid.add_theme_constant_override("h_separation", 10)
	squad_grid.add_theme_constant_override("v_separation", 10)
	scroll.add_child(squad_grid)

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
	editing_squad_names = SquadStoreScript.default_squad(roster)
	_rebuild_squad_grid()

func _select_captain_skill(index: int) -> void:
	if index >= 0 and index < CaptainSkillsScript.SKILLS.size():
		editing_captain_skill = CaptainSkillsScript.SKILLS[index]

func _toggle_squad_unit(unit_name: String) -> void:
	var copies: int = editing_squad_names.count(unit_name)
	if copies < 2 and editing_squad_names.size() < SquadStoreScript.SQUAD_SIZE:
		editing_squad_names.append(unit_name)
	elif copies >= 2:
		while unit_name in editing_squad_names:
			editing_squad_names.erase(unit_name)
	_rebuild_squad_grid()

func _rebuild_squad_grid() -> void:
	for child in squad_grid.get_children():
		squad_grid.remove_child(child)
		child.queue_free()

	for unit in roster:
		var copies: int = editing_squad_names.count(unit.name)
		var selected: bool = copies > 0
		var unlocked: bool = unit.name in CampaignStoreScript.unlocked_unit_names(roster, completed_missions)
		var button := Button.new()
		button.custom_minimum_size = Vector2(0, 76)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.toggle_mode = true
		button.button_pressed = selected
		button.disabled = not unlocked
		button.text = "%s  ·  %d◆\n%s  |  %d ATK  %d HP" % [
			unit.name.to_upper(), unit.cost, UnitCatalogScript.display_class(unit.kind),
			unit.atk, unit.hp
		]
		if copies > 0:
			button.text += "\n%d / 2 COPIES" % copies
		if not unlocked:
			button.text += "\nLOCKED · CAMPAIGN REWARD"
		button.pressed.connect(_toggle_squad_unit.bind(unit.name))
		button.mouse_entered.connect(_show_unit_details.bind(unit))
		button.mouse_exited.connect(_hide_unit_details)
		squad_grid.add_child(button)

	squad_count_label.text = "%d / %d SELECTED" % [editing_squad_names.size(), SquadStoreScript.SQUAD_SIZE]
	squad_count_label.add_theme_color_override("font_color", Color("#70e0a1") if not editing_squad_names.is_empty() else Color("#ff8f8f"))
	squad_save_button.disabled = editing_squad_names.is_empty()
	squad_start_button.visible = squad_opened_for_mission
	squad_start_button.disabled = editing_squad_names.is_empty()

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
	var unlocked: Array = CampaignStoreScript.unlocked_unit_names(roster, completed_missions)
	var allowed: Array = []
	for unit_name in squad_names:
		if unit_name in unlocked and allowed.count(unit_name) < 2:
			allowed.append(unit_name)
	if allowed.is_empty():
		allowed = SquadStoreScript.default_squad(roster)
	squad_names = allowed

func _build_main_menu() -> void:
	main_menu_overlay = ColorRect.new()
	main_menu_overlay.color = Color("#070d1b")
	main_menu_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main_menu_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	main_menu_overlay.visible = false
	add_child(main_menu_overlay)

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

	mission_list = VBoxContainer.new()
	mission_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	mission_list.add_theme_constant_override("separation", 10)
	layout.add_child(mission_list)

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
		var button := Button.new()
		button.custom_minimum_size.y = 82
		button.disabled = not available
		button.text = "%s  %02d · %s  ·  %d BATTLE%s  ·  UP TO %d HP\n%s\nReward: %s" % [
			"✓" if complete else ("◆" if available else "🔒"),
			mission.id + 1,
			mission.title.to_upper(),
			mission.encounters.size(),
			"" if mission.encounters.size() == 1 else "S",
			mission.enemy_hp,
			mission.briefing,
			mission.reward
		]
		button.pressed.connect(_prepare_mission.bind(mission.id))
		mission_list.add_child(button)

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
	hover_card.custom_minimum_size = Vector2(340, 190)
	hover_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hover_card.z_index = 100
	hover_card.visible = false

	var style := StyleBoxFlat.new()
	style.bg_color = Color("#111d36")
	style.border_color = Color("#66d9ff")
	style.set_border_width_all(2)
	style.set_corner_radius_all(12)
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 14
	style.content_margin_bottom = 14
	hover_card.add_theme_stylebox_override("panel", style)
	add_child(hover_card)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)
	hover_card.add_child(content)

	hover_name_label = Label.new()
	hover_name_label.add_theme_font_size_override("font_size", 20)
	hover_name_label.add_theme_color_override("font_color", Color("#71e6f5"))
	content.add_child(hover_name_label)

	hover_stats_label = Label.new()
	hover_stats_label.add_theme_font_size_override("font_size", 14)
	hover_stats_label.add_theme_color_override("font_color", Color("#e7edf8"))
	content.add_child(hover_stats_label)

	hover_ability_label = Label.new()
	hover_ability_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hover_ability_label.add_theme_font_size_override("font_size", 14)
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
	hover_stats_label.text = "%d MANA\n%d ATK    %s    %d MOV    %d RANGE" % [
		definition.cost,
		unit.get("atk", definition.atk),
		hp_text,
		definition.move,
		definition.range
	]
	var active_effects: String = CaptainSkillsScript.effect_summary(unit)
	hover_ability_label.text = definition.text
	if not active_effects.is_empty():
		hover_ability_label.text += "\nActive: " + active_effects
	hover_card.visible = true
	_position_hover_card()

func _hide_unit_details() -> void:
	hover_card.visible = false

func _process(_delta: float) -> void:
	if hover_card != null and hover_card.visible:
		_position_hover_card()

func _position_hover_card() -> void:
	var pointer := get_viewport().get_mouse_position()
	var card_size := Vector2(340, 190)
	var viewport_size := get_viewport_rect().size
	var target := pointer + Vector2(18, 18)
	if target.x + card_size.x > viewport_size.x - 10:
		target.x = pointer.x - card_size.x - 18
	if target.y + card_size.y > viewport_size.y - 10:
		target.y = viewport_size.y - card_size.y - 10
	hover_card.position = Vector2(maxf(10, target.x), maxf(10, target.y))

func _start_new_match() -> void:
	units.clear()
	player_hand.clear()
	enemy_hand.clear()
	battle_deck = SquadStoreScript.build_deck(squad_names, roster)
	var encounter: Dictionary = CampaignStoreScript.encounter(current_mission_id, current_encounter_index) if campaign_battle else {}
	var enemy_squad_id: int = encounter.get("squad_offset", 0)
	var enemy_squad_names: Array = CampaignStoreScript.enemy_squad_names(enemy_squad_id, roster)
	enemy_deck = SquadStoreScript.build_deck(enemy_squad_names, roster)
	draw_index = 0
	enemy_draw_index = 0
	selected_hand_index = -1
	selected_board_unit_id = -1
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
	if player_hand.size() >= 5 or draw_index >= battle_deck.size():
		return
	player_hand.append(battle_deck[draw_index].duplicate())
	draw_index += 1

func _draw_enemy_card() -> void:
	if enemy_hand.size() >= 5 or enemy_draw_index >= enemy_deck.size():
		return
	enemy_hand.append(enemy_deck[enemy_draw_index].duplicate())
	enemy_draw_index += 1

func _refresh() -> void:
	player_hp_label.text = "◆  %02d HP%s\n%d HAND · %d DECK" % [
		player_hp, " · %d SHIELD" % player_shield if player_shield > 0 else "",
		player_hand.size(), battle_deck.size() - draw_index
	]
	enemy_hp_label.text = "%02d HP%s  ◆\n%d HAND · %d DECK" % [
		enemy_hp, " · %d SHIELD" % enemy_shield if enemy_shield > 0 else "",
		enemy_hand.size(), enemy_deck.size() - enemy_draw_index
	]
	var locked_mana := BattleRulesScript.locked_mana(units, PLAYER)
	energy_label.text = "MANA  %d / %d  ·  %d LOCKED" % [player_energy, player_max_energy, locked_mana]
	turn_label.text = "ROUND %02d  ·  YOUR COMMAND" % round_number if input_enabled else "ROUND %02d  ·  RESOLVING" % round_number
	hint_label.text = status_message
	end_button.disabled = not input_enabled or battle_over
	menu_button.disabled = not input_enabled or battle_over
	power_button.disabled = not input_enabled or player_power_used or battle_over
	power_button.text = "%s USED" % player_captain_skill.to_upper() if player_power_used else player_captain_skill.to_upper()
	power_button.tooltip_text = CaptainSkillsScript.DESCRIPTIONS[player_captain_skill]

	var selected := {}
	if selected_hand_index >= 0 and selected_hand_index < player_hand.size():
		selected = player_hand[selected_hand_index]
	board.set_state(units, selected, selected_board_unit_id, input_enabled and not battle_over, status_message)
	_rebuild_hand()

func _rebuild_hand() -> void:
	for child in hand_row.get_children():
		hand_row.remove_child(child)
		child.queue_free()

	for i in player_hand.size():
		var card: Dictionary = player_hand[i]
		var button := Button.new()
		button.custom_minimum_size = Vector2(178, 122)
		button.toggle_mode = true
		button.button_pressed = i == selected_hand_index
		button.disabled = not input_enabled or card.cost > player_energy or battle_over
		button.text = "%s  ·  %d◆\n%s\n%d ATK   %d HP\n%s" % [
			card.name.to_upper(), card.cost, UnitCatalogScript.display_class(card.kind),
			card.atk, card.hp, card.text
		]
		button.add_theme_font_size_override("font_size", 12)
		button.pressed.connect(_select_card.bind(i))
		button.mouse_entered.connect(_show_unit_details.bind(card))
		button.mouse_exited.connect(_hide_unit_details)
		hand_row.add_child(button)

func _select_card(index: int) -> void:
	if not input_enabled:
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
	if selected_board_unit_id >= 0:
		var selected = _unit_by_id(selected_board_unit_id)
		if selected == null:
			selected_board_unit_id = -1
		elif clicked != null and clicked.side == PLAYER:
			selected_board_unit_id = clicked.id
			status_message = _reposition_status(clicked)
		elif BattleRulesScript.can_reposition(selected, row, units) and col == selected.col:
			var old_row: int = selected.row
			selected.row = row
			selected.repositioned = true
			selected_board_unit_id = -1
			status_message = "%s shifts from lane %d to lane %d." % [selected.name, old_row + 1, row + 1]
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
	if unit.get("repositioned", false):
		return "%s has already changed lanes this turn." % unit.name
	if BattleRulesScript.is_taunted(unit, units):
		return "%s is taunted by a Defender and cannot leave this lane." % unit.name
	return "Choose an open highlighted tile in an adjacent lane to reposition %s." % unit.name

func _reposition_block_reason(unit: Dictionary, row: int, col: int) -> String:
	if unit.get("repositioned", false):
		return "%s has already repositioned this turn." % unit.name
	if BattleRulesScript.is_taunted(unit, units):
		return "%s is taunted and must remain in its lane." % unit.name
	if col != unit.col or absi(row - unit.row) != 1:
		return "Units can only shift to an adjacent lane in the same column."
	return "That destination is occupied."

func _on_deployment_clicked(row: int) -> void:
	if not input_enabled or selected_hand_index < 0 or selected_hand_index >= player_hand.size():
		return
	if _unit_at(row, 0) != null:
		status_message = "That deployment tile is occupied."
		_refresh()
		return

	var card: Dictionary = player_hand[selected_hand_index]
	if card.cost > player_energy:
		return
	player_energy -= card.cost
	_spawn_unit(card, PLAYER, row, 0)
	status_message = "%s deployed to lane %d." % [card.name, row + 1]
	player_hand.remove_at(selected_hand_index)
	selected_hand_index = -1
	_refresh()

func _spawn_unit(card: Dictionary, side: int, row: int, col: int) -> void:
	units.append({
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
		# Deployment is part of the turn: newly placed units move and attack
		# when that side resolves immediately afterward.
		"ready": true,
		"repositioned": false,
		"taunt_turns": 0,
		"effects": []
	})
	next_unit_id += 1

func _use_player_power() -> void:
	if player_power_used or not input_enabled:
		return
	if not _apply_captain_skill(PLAYER, player_captain_skill):
		_refresh()
		return
	player_power_used = true
	_refresh()

func _end_player_turn() -> void:
	if not input_enabled or battle_over:
		return
	input_enabled = false
	selected_hand_index = -1
	selected_board_unit_id = -1
	status_message = "Your units advance."
	_refresh()
	await _resolve_side(PLAYER)
	_expire_side_effects(PLAYER)
	if _check_game_over():
		return
	await get_tree().create_timer(0.35).timeout
	await _enemy_turn()

func _enemy_turn() -> void:
	for unit in units:
		if unit.side == ENEMY:
			unit.ready = true
			unit.repositioned = false
	if round_number > 1:
		enemy_max_energy = mini(10, enemy_max_energy + 2)
	enemy_energy = BattleRulesScript.available_mana(enemy_max_energy, units, ENEMY)
	if round_number > 1:
		_draw_enemy_card()
	status_message = "Enemy is deploying..."
	_refresh()
	await get_tree().create_timer(0.55).timeout
	await _enemy_reposition_units()

	var attempts := 0
	while attempts < 3:
		var choice: Dictionary = BattleAIScript.choose_deployment(enemy_hand, enemy_energy, units)
		if choice.is_empty():
			break
		var card: Dictionary = choice.card
		var row: int = choice.row
		_spawn_unit(card, ENEMY, row, COLS - 1)
		enemy_energy -= card.cost
		var hand_index: int = enemy_hand.find(card)
		if hand_index >= 0:
			enemy_hand.remove_at(hand_index)
		status_message = "Enemy deployed %s to lane %d." % [card.name, row + 1]
		_refresh()
		await get_tree().create_timer(0.35).timeout
		attempts += 1

	if not enemy_power_used and (round_number >= 2 or enemy_hp <= 8):
		if _apply_captain_skill(ENEMY, enemy_captain_skill):
			enemy_power_used = true
			status_message = "Enemy Captain: " + status_message
			_refresh()
			await get_tree().create_timer(0.45).timeout

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
	input_enabled = true
	status_message = "Select a card or resolve the board as it stands."
	_refresh()

func _enemy_reposition_units() -> void:
	var enemy_ids: Array = units.filter(func(unit): return unit.side == ENEMY).map(func(unit): return unit.id)
	for unit_id in enemy_ids:
		var unit = _unit_by_id(unit_id)
		if unit == null or BattleRulesScript.is_taunted(unit, units):
			continue
		var current_threat := _player_lane_threat(unit.row, unit.col)
		var best_row: int = unit.row
		var best_threat := current_threat
		for candidate_row in [unit.row - 1, unit.row + 1]:
			if not BattleRulesScript.can_reposition(unit, candidate_row, units):
				continue
			var candidate_threat := _player_lane_threat(candidate_row, unit.col)
			if candidate_threat < best_threat:
				best_threat = candidate_threat
				best_row = candidate_row
		if best_row != unit.row:
			var old_row: int = unit.row
			unit.row = best_row
			unit.repositioned = true
			status_message = "%s shifts from lane %d to lane %d." % [unit.name, old_row + 1, best_row + 1]
			board.play_unit_effect(unit.id, "SHIFT", Color("#ff8b9f"))
			_refresh()
			await get_tree().create_timer(0.28).timeout

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
		await get_tree().create_timer(0.32).timeout

func _activate_unit(actor: Dictionary) -> void:
	if actor.kind == "Lifebinder":
		var healing_target = _lowest_health_ally(actor)
		if healing_target != null:
			healing_target.hp += 2
			status_message = "%s heals %s for 2 HP." % [actor.name, healing_target.name]
			board.play_unit_effect(healing_target.id, "+2 HP", Color("#70e0a1"))
			_refresh()
			await get_tree().create_timer(0.22).timeout

	var path: Array = BattleRulesScript.traversal_cells(actor, units)
	if not path.is_empty():
		actor.col = path[-1].x
		status_message = "%s advances %d space%s." % [
			actor.name, path.size(), "" if path.size() == 1 else "s"
		]
		board.play_unit_effect(actor.id, "ADVANCE", Color("#71e6f5"))
		_refresh()
		await get_tree().create_timer(0.22).timeout
	else:
		status_message = "%s cannot advance." % actor.name

	var target = _find_target(actor)
	if target != null:
		var strikes := 2 if actor.kind == "Strider" else 1
		for hit in strikes:
			if target == null or target.hp <= 0:
				target = _find_target(actor)
			if target == null:
				break
			target.hp -= actor.atk
			status_message = "%s hits %s for %d." % [actor.name, target.name, actor.atk]
			board.play_unit_effect(target.id, "-%d" % actor.atk, Color("#ff668f"))
			_apply_special_damage(actor, target)
			if actor.kind == "Warden" and target.hp > 0:
				BattleRulesScript.apply_taunt(target)
				status_message += " Taunting Strike locks %s for 2 turns." % target.name
			_remove_defeated()
			_refresh()
			if hit + 1 < strikes:
				await get_tree().create_timer(0.18).timeout
		if actor.kind == "Duelist" and _unit_by_id(actor.id) != null:
			actor.atk += 1
			status_message += " Its ATK rises."
		return

	if _commander_in_range(actor):
		var strikes := 2 if actor.kind == "Strider" else 1
		var damage: int = actor.atk * strikes
		var dealt: int
		if actor.side == PLAYER:
			dealt = _damage_captain(ENEMY, damage)
			status_message = "%s strikes the enemy Commander for %d!" % [actor.name, dealt]
		else:
			dealt = _damage_captain(PLAYER, damage)
			status_message = "%s strikes your Commander for %d!" % [actor.name, dealt]
		if actor.kind == "Duelist" and _unit_by_id(actor.id) != null:
			actor.atk += 1
			status_message += " Fury grants +1 ATK."
		return

func _apply_special_damage(actor: Dictionary, target: Dictionary) -> void:
	if actor.kind == "Channeler":
		var splash_damage := maxi(1, int(actor.atk / 2))
		var blast_cells: Array = BattleRulesScript.blast_cells(target)
		for other in units:
			if other.id != target.id and other.side == target.side and Vector2i(other.col, other.row) in blast_cells:
				other.hp -= splash_damage
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
		if not pierced.is_empty():
			status_message += " Piercing Shot also hits %s." % ", ".join(pierced)

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

	if result.shield > 0:
		if side == PLAYER:
			player_shield = result.shield
			player_shield_turns = result.shield_turns
		else:
			enemy_shield = result.shield
			enemy_shield_turns = result.shield_turns

	if result.captain_damage > 0:
		_damage_captain(ENEMY if side == PLAYER else PLAYER, result.captain_damage)

	for unit_id in result.affected:
		var target = _unit_by_id(unit_id)
		if target != null:
			board.play_unit_effect(target.id, "SKILL", Color("#ffd166") if side == PLAYER else Color("#ff8b9f"))
	_remove_defeated()
	return true

func _expire_side_effects(side: int) -> void:
	CaptainSkillsScript.expire_effects(units, side)
	BattleRulesScript.expire_taunts(units, side)
	if side == PLAYER and player_shield_turns > 0:
		player_shield_turns -= 1
		if player_shield_turns == 0:
			player_shield = 0
	elif side == ENEMY and enemy_shield_turns > 0:
		enemy_shield_turns -= 1
		if enemy_shield_turns == 0:
			enemy_shield = 0

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
	if enemy_hp <= 0:
		var reward_text := ""
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
			var reward: String = CampaignStoreScript.MISSIONS[current_mission_id].reward
			reward_text = "\nReward unlocked: %s" % reward
		overlay_title.text = "MISSION COMPLETE" if campaign_battle else "VICTORY"
		overlay_title.add_theme_color_override("font_color", Color("#67e6f4"))
		overlay_detail.text = "The enemy weather engine is yours.\nVictory achieved in %d rounds.%s" % [round_number, reward_text]
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
