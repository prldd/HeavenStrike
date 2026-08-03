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
const BattleAudioScript = preload("res://scripts/battle_audio.gd")
const BattleSimulatorScript = preload("res://scripts/battle_simulator.gd")
const BattleSettingsScript = preload("res://scripts/battle_settings.gd")
const KineticCrucibleScript = preload("res://scripts/kinetic_crucible.gd")
const UIThemeScript = preload("res://scripts/ui_theme.gd")
const MAIN_MENU_BACKGROUND := preload("res://assets/main-menu-steampunk-deck.png")

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
var result_menu_button: Button
var reward_reveal: VBoxContainer
var reward_portrait: TextureRect
var reward_stars_label: Label
var reward_new_label: Label
var result_continue_button: Button
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
var reserve_class_option: OptionButton
var reserve_search_edit: LineEdit
var reserve_filter_class := ""
var reserve_filter_text := ""
var mission_intel_panel: PanelContainer
var mission_intel_label: Label
var mission_intel_stats_label: Label
var mission_enemy_preview_row: HBoxContainer
var reward_carry_label: Label
var hover_card: PanelContainer
var hover_name_label: Label
var hover_stats_label: Label
var hover_ability_label: RichTextLabel
var hover_drop_label: Label
var speed_button: Button
var audio_button: Button
var animation_button: Button
var motion_button: Button
var settings_button: Button
var settings_panel: PanelContainer
var battle_audio: BattleAudio
var battle_simulator: BattleSimulator
var combat_log_panel: PanelContainer
var combat_log_label: RichTextLabel
var main_menu_overlay: ColorRect
var mission_overlay: ColorRect
var crucible_overlay: ColorRect
var crucible_reserve_grid: GridContainer
var crucible_target_grid: GridContainer
var crucible_donor_grid: GridContainer
var crucible_detail_label: Label
var crucible_merge_button: Button
var crucible_promote_button: Button
var crucible_extras_toggle: CheckButton
var crucible_class_option: OptionButton
var crucible_search_edit: LineEdit
var crucible_filter_class := ""
var crucible_filter_text := ""
var crucible_target_id := ""
var crucible_donor_ids: Array = []
var collection_instances: Array = []
var crucible_notice := ""
var mission_list: VBoxContainer
var mission_list_build_token := 0
var _touch_details_active := false
var campaign_progress_label: Label
var resume_button: Button
var replay_button: Button
var replay_panel: PanelContainer
var replay_play_button: Button
var replay_event_label: Label
var replay_timeline_label: Label
var replay_previous_button: Button
var replay_next_button: Button
var replay_squad_overlay: ColorRect
var replay_player_squad_grid: GridContainer
var replay_enemy_squad_grid: GridContainer

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
var recent_reward_name := ""

var units: Array = []
var player_hand: Array = []
var enemy_hand: Array = []
var unit_icon_cache := {}
var draw_index := 0
var enemy_draw_index := 0
var selected_hand_index := -1
var selected_board_unit_id := -1
var pending_empower_actor_id := -1
var pending_envenom_actor_id := -1
var pending_lane_actor_id := -1
var next_unit_id := 1
## Most recently deployed unit id per side; Roguish Snare targets it when the
## deploying side's next turn starts. Reset by _start_new_match.
var last_deployed_unit_id := {PLAYER: -1, ENEMY: -1}
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
var battle_seed := 1
var reduced_motion := false
var skip_animations := false
var replay_mode := false
var replay_playing := false
var replay_data: Dictionary = {}
var replay_event_index := 0
var replay_history: Array = []
var replay_history_index := 0

const REPLAY_PATH := "user://last_replay.json"
const REPLAY_HISTORY_PATH := "user://replay_history.json"
const NORMAL_SPEED_DURATION_SCALE := 2.0
const HOVER_CARD_SIZE := Vector2(340, 300)

func _ready() -> void:
	theme = UIThemeScript.create()
	_build_interface()
	battle_audio = BattleAudioScript.new()
	add_child(battle_audio)
	battle_simulator = BattleSimulatorScript.new()
	_load_battle_settings()
	completed_missions = CampaignStoreScript.load_completed()
	earned_reward_units = CampaignStoreScript.load_reward_units(roster)
	_sync_collection()
	squad_names = SquadStoreScript.load_instance_squad(roster, collection_instances)
	player_captain_skill = SquadStoreScript.load_captain_skill(CaptainSkillsScript.SKILLS)
	_sanitize_squad_unlocks()
	_start_new_match()
	_show_main_menu()
	_prewarm_icons()

func _prewarm_icons() -> void:
	# Decode every portrait into the icon cache a few per frame while the main
	# menu sits idle. Without this, the first opening of the mission list,
	# squad builder, or crucible in a session decodes them all synchronously,
	# which is a noticeable freeze on mobile storage.
	var count := 0
	for unit in roster:
		_unit_icon(unit.icon)
		count += 1
		if count % 8 == 0:
			await get_tree().process_frame

func _build_interface() -> void:
	var background := ColorRect.new()
	background.color = UIThemeScript.NAVY_DEEP
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
	brand.text = "WAR OF\nRESONANCE"
	brand.add_theme_font_size_override("font_size", 17)
	brand.add_theme_color_override("font_color", UIThemeScript.title_color())
	brand.custom_minimum_size.x = 170
	header.add_child(brand)

	turn_label = Label.new()
	turn_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	turn_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	turn_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	turn_label.add_theme_font_size_override("font_size", 18)
	header.add_child(turn_label)

	var header_balance := HBoxContainer.new()
	header_balance.custom_minimum_size.x = 170
	header_balance.alignment = BoxContainer.ALIGNMENT_END
	header.add_child(header_balance)
	settings_button = Button.new()
	settings_button.text = "⚙"
	settings_button.tooltip_text = "Settings"
	settings_button.custom_minimum_size = Vector2(46, 42)
	settings_button.add_theme_font_size_override("font_size", 22)
	settings_button.pressed.connect(_toggle_settings)
	header_balance.add_child(settings_button)

	board = BoardViewScript.new()
	board.custom_minimum_size = Vector2(0, 370)
	board.size_flags_vertical = Control.SIZE_EXPAND_FILL
	board.deployment_clicked.connect(_on_deployment_clicked)
	board.board_cell_clicked.connect(_on_board_cell_clicked)
	board.unit_hovered.connect(_show_unit_details)
	board.unit_hover_ended.connect(_hide_unit_details)
	root.add_child(board)

	var control_bar := VBoxContainer.new()
	control_bar.custom_minimum_size.y = 44
	control_bar.add_theme_constant_override("separation", 8)
	root.add_child(control_bar)

	var status_row := HBoxContainer.new()
	status_row.add_theme_constant_override("separation", 8)
	status_row.visible = false
	control_bar.add_child(status_row)

	hint_label = Label.new()
	hint_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hint_label.add_theme_color_override("font_color", UIThemeScript.muted_color())
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
	end_button.text = "→"
	end_button.tooltip_text = "Resolve turn (Enter)"
	end_button.add_theme_font_size_override("font_size", 28)
	end_button.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	end_button.offset_left = -74
	end_button.offset_top = -68
	end_button.offset_right = -18
	end_button.offset_bottom = -18
	end_button.z_index = 20
	end_button.pressed.connect(_end_player_turn)
	board.add_child(end_button)

	hand_row = HBoxContainer.new()
	hand_row.custom_minimum_size.y = 104
	hand_row.alignment = BoxContainer.ALIGNMENT_CENTER
	hand_row.add_theme_constant_override("separation", 6)
	root.add_child(hand_row)

	_build_combat_log()
	_build_settings_menu()
	_build_overlay()
	_build_tutorial()
	_build_squad_builder()
	_build_main_menu()
	_build_mission_select()
	_build_kinetic_crucible()
	_build_hover_card()
	_build_replay_controls()
	_build_replay_squad_overlay()

func _unhandled_key_input(event: InputEvent) -> void:
	if (
		event is InputEventKey
		and event.pressed
		and not event.echo
		and event.keycode in [KEY_ENTER, KEY_KP_ENTER]
		and end_button.visible
		and not end_button.disabled
		and not replay_mode
		and not main_menu_overlay.visible
		and not mission_overlay.visible
		and not crucible_overlay.visible
		and not squad_overlay.visible
		and not tutorial_overlay.visible
		and not overlay.visible
	):
		get_viewport().set_input_as_handled()
		_end_player_turn()

func _build_settings_menu() -> void:
	settings_panel = PanelContainer.new()
	settings_panel.set_anchor(SIDE_LEFT, 1.0)
	settings_panel.set_anchor(SIDE_RIGHT, 1.0)
	settings_panel.offset_left = -238
	settings_panel.offset_right = -18
	settings_panel.offset_top = 64
	settings_panel.offset_bottom = 326
	settings_panel.z_index = 90
	settings_panel.visible = false
	add_child(settings_panel)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 8)
	settings_panel.add_child(layout)
	var title := Label.new()
	title.text = "SETTINGS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_color", UIThemeScript.title_color())
	layout.add_child(title)

	speed_button = _settings_action("SPEED 1×", "Cycle combat resolution speed.")
	speed_button.pressed.connect(_cycle_resolution_speed)
	layout.add_child(speed_button)
	audio_button = _settings_action("SOUND 100%", "Cycle battle audio volume or mute it.")
	audio_button.pressed.connect(_cycle_audio)
	layout.add_child(audio_button)
	animation_button = _settings_action("ANIM ON", "Skip or restore battle animations.")
	animation_button.pressed.connect(_toggle_animation_skip)
	layout.add_child(animation_button)
	motion_button = _settings_action(
		"MOTION FULL", "Reduce lunges and disable shake without changing combat speed."
	)
	motion_button.pressed.connect(_toggle_reduced_motion)
	layout.add_child(motion_button)
	var log_button := _settings_action("COMBAT LOG", "Show or hide the combat action log.")
	log_button.pressed.connect(_open_combat_log_from_settings)
	layout.add_child(log_button)
	var help_button := _settings_action("HOW TO PLAY", "Open the field briefing.")
	help_button.pressed.connect(_open_tutorial_from_settings)
	layout.add_child(help_button)

func _settings_action(label: String, tooltip: String) -> Button:
	var button := Button.new()
	button.text = label
	button.tooltip_text = tooltip
	button.custom_minimum_size.y = 38
	return button

func _toggle_settings() -> void:
	settings_panel.visible = not settings_panel.visible

func _open_combat_log_from_settings() -> void:
	settings_panel.visible = false
	_toggle_combat_log()

func _open_tutorial_from_settings() -> void:
	settings_panel.visible = false
	_open_tutorial()

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
	title.add_theme_color_override("font_color", UIThemeScript.title_color())
	heading.add_child(title)
	var close := Button.new()
	close.text = "×"
	close.pressed.connect(_toggle_combat_log)
	heading.add_child(close)
	combat_log_label = RichTextLabel.new()
	combat_log_label.bbcode_enabled = false
	combat_log_label.scroll_following = true
	combat_log_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	combat_log_label.add_theme_font_size_override("normal_font_size", 12)
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
	Engine.time_scale = resolution_speed
	speed_button.text = "SPEED %d×" % int(resolution_speed)
	_save_battle_settings()

func _cycle_audio() -> void:
	battle_audio.cycle_volume()
	audio_button.text = battle_audio.label()
	_save_battle_settings()

func _toggle_animation_skip() -> void:
	skip_animations = not skip_animations
	board.idle_bob_enabled = not skip_animations
	animation_button.text = "ANIM OFF" if skip_animations else "ANIM ON"
	_save_battle_settings()

func _toggle_reduced_motion() -> void:
	reduced_motion = not reduced_motion
	board.reduced_motion = reduced_motion
	motion_button.text = "MOTION LOW" if reduced_motion else "MOTION FULL"
	_save_battle_settings()

func _load_battle_settings() -> void:
	var settings: Dictionary = BattleSettingsScript.load_settings()
	resolution_speed = settings.speed
	Engine.time_scale = resolution_speed
	reduced_motion = settings.reduced_motion
	skip_animations = settings.skip_animations
	battle_audio.set_volume_step(settings.volume)
	speed_button.text = "SPEED %d×" % int(resolution_speed)
	audio_button.text = battle_audio.label()
	board.reduced_motion = reduced_motion
	board.idle_bob_enabled = not skip_animations
	animation_button.text = "ANIM OFF" if skip_animations else "ANIM ON"
	motion_button.text = "MOTION LOW" if reduced_motion else "MOTION FULL"

func _save_battle_settings() -> void:
	BattleSettingsScript.save_settings({
		"speed": resolution_speed,
		"volume": battle_audio.volume_step,
		"reduced_motion": reduced_motion,
		"skip_animations": skip_animations
	})

func _animation_duration(seconds: float) -> float:
	if skip_animations:
		return 0.001
	# Engine.time_scale controls the wall-clock playback rate so changing speed
	# also affects a tween or timer that is already in progress.
	return seconds * NORMAL_SPEED_DURATION_SCALE

func _play_attack_sound(kind: String) -> void:
	match kind:
		"Strider", "Duelist", "Warden":
			battle_audio.play("melee")
		"Artillerist":
			battle_audio.play("gunner")
		"Channeler":
			battle_audio.play("mage")
		"Lifebinder":
			battle_audio.play("priest")

func _wait(seconds: float) -> Signal:
	return get_tree().create_timer(_animation_duration(seconds), false).timeout

func _log_action(message: String) -> void:
	if message.is_empty() or message == last_logged_message:
		return
	last_logged_message = message
	if battle_simulator != null and not replay_mode:
		battle_simulator.record("combat_log", {"message": message})
	combat_log_lines.append(message)
	if combat_log_lines.size() > 60:
		combat_log_lines.pop_front()
	if combat_log_label != null:
		combat_log_label.text = "\n".join(combat_log_lines)

func _build_overlay() -> void:
	overlay = ColorRect.new()
	overlay.color = Color(0.035, 0.026, 0.02, 0.94)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.visible = false
	add_child(overlay)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(center)

	var plaque := PanelContainer.new()
	plaque.custom_minimum_size = Vector2(520, 430)
	plaque.add_theme_stylebox_override("panel", UIThemeScript.dark_plaque())
	center.add_child(plaque)
	var panel := VBoxContainer.new()
	panel.custom_minimum_size = Vector2(460, 370)
	panel.alignment = BoxContainer.ALIGNMENT_CENTER
	panel.add_theme_constant_override("separation", 14)
	plaque.add_child(panel)

	overlay_title = Label.new()
	overlay_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	overlay_title.add_theme_font_size_override("font_size", 42)
	panel.add_child(overlay_title)

	overlay_detail = Label.new()
	overlay_detail.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	overlay_detail.add_theme_font_size_override("font_size", 17)
	overlay_detail.add_theme_color_override("font_color", UIThemeScript.muted_color())
	panel.add_child(overlay_detail)

	reward_reveal = VBoxContainer.new()
	reward_reveal.alignment = BoxContainer.ALIGNMENT_CENTER
	reward_reveal.add_theme_constant_override("separation", 4)
	reward_reveal.visible = false
	panel.add_child(reward_reveal)

	var reward_heading := Label.new()
	reward_heading.text = "UNIT ACQUIRED"
	reward_heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	reward_heading.add_theme_font_size_override("font_size", 16)
	reward_heading.add_theme_color_override("font_color", UIThemeScript.muted_color())
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
	reward_stars_label.add_theme_color_override("font_color", UIThemeScript.title_color())
	reward_reveal.add_child(reward_stars_label)

	reward_new_label = Label.new()
	reward_new_label.text = "NEW"
	reward_new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	reward_new_label.add_theme_font_size_override("font_size", 15)
	reward_new_label.add_theme_color_override("font_color", Color("#70e0a1"))
	reward_reveal.add_child(reward_new_label)

	var result_actions := HBoxContainer.new()
	result_actions.alignment = BoxContainer.ALIGNMENT_CENTER
	result_actions.add_theme_constant_override("separation", 12)
	panel.add_child(result_actions)

	result_continue_button = Button.new()
	result_continue_button.text = "CONTINUE CAMPAIGN"
	result_continue_button.custom_minimum_size = Vector2(210, 48)
	result_continue_button.visible = false
	result_continue_button.pressed.connect(_continue_campaign)
	result_actions.add_child(result_continue_button)

	result_primary_button = Button.new()
	result_primary_button.text = "PLAY AGAIN"
	result_primary_button.custom_minimum_size = Vector2(180, 48)
	result_primary_button.pressed.connect(_on_result_primary)
	result_actions.add_child(result_primary_button)

	result_menu_button = Button.new()
	result_menu_button.text = "MENU"
	result_menu_button.custom_minimum_size = Vector2(140, 48)
	result_menu_button.visible = false
	result_menu_button.pressed.connect(_show_main_menu)
	result_actions.add_child(result_menu_button)

func _build_tutorial() -> void:
	tutorial_overlay = ColorRect.new()
	tutorial_overlay.color = Color.TRANSPARENT
	tutorial_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	tutorial_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	tutorial_overlay.visible = false
	add_child(tutorial_overlay)
	_add_overlay_background(
		tutorial_overlay,
		MAIN_MENU_BACKGROUND,
		Color(0.035, 0.025, 0.02, 0.72)
	)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	tutorial_overlay.add_child(center)

	var plaque := PanelContainer.new()
	plaque.custom_minimum_size = Vector2(610, 380)
	plaque.add_theme_stylebox_override("panel", UIThemeScript.dark_plaque())
	center.add_child(plaque)
	var panel := VBoxContainer.new()
	panel.custom_minimum_size = Vector2(550, 320)
	panel.alignment = BoxContainer.ALIGNMENT_CENTER
	panel.add_theme_constant_override("separation", 22)
	plaque.add_child(panel)

	var title := Label.new()
	title.text = "TACTICAL DOCTRINE"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 32)
	title.add_theme_color_override("font_color", UIThemeScript.title_color())
	panel.add_child(title)

	tutorial_page_label = Label.new()
	tutorial_page_label.custom_minimum_size = Vector2(520, 150)
	tutorial_page_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tutorial_page_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	tutorial_page_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	tutorial_page_label.add_theme_font_size_override("font_size", 18)
	tutorial_page_label.add_theme_color_override("font_color", UIThemeScript.muted_color())
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
	end_button.visible = false
	tutorial_overlay.visible = true
	_update_tutorial()

func _close_tutorial() -> void:
	tutorial_overlay.visible = false
	if tutorial_opened_from_menu:
		tutorial_opened_from_menu = false
		_show_main_menu()
	else:
		end_button.visible = not replay_mode and not battle_over

func _next_tutorial_page() -> void:
	tutorial_page += 1
	if tutorial_page >= 5:
		_close_tutorial()
		return
	_update_tutorial()

func _update_tutorial() -> void:
	var pages := [
		"1 / 5\nASSEMBLE YOUR OPTIONS\nUnit cards show Mana cost, role, attack, health, and tactical ability.",
		"2 / 5\nCOMMIT TO A LANE\nDeploy on an open tile at your edge. Preview the route, then account for movement before the attack.",
		"3 / 5\nREFORM THE LINE\nReposition deployed units between open rows. Allies may be crossed, enemies obstruct the route, and you may reposition any number of times.",
		"4 / 5\nCONTROL THEIR MOVEMENT\nTaunt and Immobilise deny enemy lane changes, letting you isolate threats and protect weak positions.",
		"5 / 5\nBREAK THEIR COMMAND\nControl the lanes, create an opening, and project enough force through it to defeat the enemy Captain."
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
		MAIN_MENU_BACKGROUND,
		Color(0.035, 0.025, 0.02, 0.68)
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
	title.text = "FORMATION COMMAND"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", UIThemeScript.title_color())
	title_row.add_child(title)

	squad_count_label = Label.new()
	squad_count_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	squad_count_label.add_theme_font_size_override("font_size", 18)
	title_row.add_child(squad_count_label)

	var instruction := Label.new()
	instruction.text = "Shape an eight-unit plan. Drag to reorder; slot 1 leads the opening hand. Right-click a unit to assign the Vanguard. Maximum 2 copies per unit."
	instruction.add_theme_color_override("font_color", UIThemeScript.muted_color())
	layout.add_child(instruction)

	mission_intel_panel = PanelContainer.new()
	mission_intel_panel.visible = false
	layout.add_child(mission_intel_panel)
	var intel_layout := HBoxContainer.new()
	intel_layout.add_theme_constant_override("separation", 12)
	mission_intel_panel.add_child(intel_layout)
	mission_intel_label = Label.new()
	mission_intel_label.custom_minimum_size.x = 330
	mission_intel_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	mission_intel_label.add_theme_color_override("font_color", Color("#e8b4a2"))
	intel_layout.add_child(mission_intel_label)
	mission_intel_stats_label = Label.new()
	mission_intel_stats_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mission_intel_stats_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	mission_intel_stats_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	mission_intel_stats_label.clip_text = true
	mission_intel_stats_label.add_theme_font_size_override("font_size", 11)
	mission_intel_stats_label.add_theme_color_override("font_color", UIThemeScript.muted_color())
	intel_layout.add_child(mission_intel_stats_label)
	mission_enemy_preview_row = HBoxContainer.new()
	mission_enemy_preview_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mission_enemy_preview_row.alignment = BoxContainer.ALIGNMENT_END
	mission_enemy_preview_row.add_theme_constant_override("separation", 5)
	intel_layout.add_child(mission_enemy_preview_row)

	var skill_row := HBoxContainer.new()
	skill_row.add_theme_constant_override("separation", 12)
	layout.add_child(skill_row)

	var skill_label := Label.new()
	skill_label.text = "COMMAND TACTIC"
	skill_label.custom_minimum_size.x = 150
	skill_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	skill_label.add_theme_color_override("font_color", UIThemeScript.title_color())
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
	barracks_title.text = "RESERVES · OWNED UNITS"
	barracks_title.add_theme_font_size_override("font_size", 16)
	barracks_title.add_theme_color_override("font_color", UIThemeScript.title_color())
	barracks_layout.add_child(barracks_title)
	reward_carry_label = Label.new()
	reward_carry_label.visible = false
	reward_carry_label.add_theme_color_override("font_color", UIThemeScript.title_color())
	barracks_layout.add_child(reward_carry_label)
	var reserve_filter_row := HBoxContainer.new()
	reserve_filter_row.add_theme_constant_override("separation", 8)
	barracks_layout.add_child(reserve_filter_row)
	reserve_class_option = _make_reserve_class_option()
	reserve_class_option.item_selected.connect(
		func(index):
			reserve_filter_class = reserve_class_option.get_item_metadata(index)
			_rebuild_squad_grid()
	)
	reserve_filter_row.add_child(reserve_class_option)
	reserve_search_edit = _make_reserve_search_edit(
		func(text):
			reserve_filter_text = text
			_rebuild_squad_grid()
	)
	reserve_filter_row.add_child(reserve_search_edit)
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
	selection_title.text = "ACTIVE FORMATION · CLICK TO REMOVE"
	selection_title.add_theme_font_size_override("font_size", 16)
	selection_title.add_theme_color_override("font_color", UIThemeScript.title_color())
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
	squad_save_button.text = "SAVE FORMATION"
	squad_save_button.custom_minimum_size = Vector2(170, 44)
	squad_save_button.pressed.connect(_save_squad)
	actions.add_child(squad_save_button)

	squad_start_button = Button.new()
	squad_start_button.text = "DEPLOY FORMATION"
	squad_start_button.custom_minimum_size = Vector2(180, 44)
	squad_start_button.visible = false
	squad_start_button.pressed.connect(_save_and_start_mission)
	actions.add_child(squad_start_button)

func _open_squad_builder() -> void:
	if replay_mode:
		_open_replay_squads()
		return
	if not input_enabled:
		return
	squad_opened_from_menu = false
	squad_opened_for_mission = false
	pending_mission_id = -1
	editing_squad_names = squad_names.duplicate()
	editing_captain_skill = player_captain_skill
	captain_skill_option.select(CaptainSkillsScript.SKILLS.find(editing_captain_skill))
	end_button.visible = false
	squad_overlay.visible = true
	# Let the overlay render before the (potentially heavy) grid rebuild so the
	# tap shows the new page immediately instead of freezing on the old one.
	await get_tree().process_frame
	_rebuild_squad_grid()

func _open_replay_squads() -> void:
	var player_names: Array = []
	var enemy_names: Array = []
	for event in replay_data.get("events", []):
		if event.get("type", "") == "battle_started":
			player_names = event.get("player_squad", []).duplicate()
			enemy_names = event.get("enemy_squad", []).duplicate()
			break
	_populate_replay_squad_grid(replay_player_squad_grid, player_names)
	_populate_replay_squad_grid(replay_enemy_squad_grid, enemy_names)
	replay_playing = false
	replay_play_button.text = "PLAY"
	replay_squad_overlay.visible = true

func _populate_replay_squad_grid(grid: GridContainer, names: Array) -> void:
	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()
	if names.is_empty():
		var unavailable := Label.new()
		unavailable.text = "Squad data unavailable\nfor this older replay."
		unavailable.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		grid.add_child(unavailable)
		return
	for index in names.size():
		var unit := UnitCatalogScript.by_name(names[index])
		if unit == null:
			continue
		var card := Button.new()
		card.custom_minimum_size = Vector2(0, 82)
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card.icon = _unit_icon(unit.icon)
		card.alignment = HORIZONTAL_ALIGNMENT_LEFT
		card.text = "%02d · %s\n%s%s" % [
			index + 1,
			unit.name.to_upper(),
			UnitCatalogScript.display_class(unit.kind),
			" · VANGUARD" if index == 0 else ""
		]
		card.add_theme_font_size_override("font_size", 11)
		_apply_class_card_style(card, unit.kind)
		card.mouse_entered.connect(_show_unit_details.bind(unit.to_dict()))
		card.mouse_exited.connect(_hide_unit_details)
		grid.add_child(card)

func _close_replay_squads() -> void:
	replay_squad_overlay.visible = false
	hover_card.visible = false

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
		return
	end_button.visible = not replay_mode and not battle_over

func _reset_squad() -> void:
	_sync_collection()
	editing_squad_names = SquadStoreScript.sanitize_instances([], collection_instances)
	_rebuild_squad_grid()

func _select_captain_skill(index: int) -> void:
	if index >= 0 and index < CaptainSkillsScript.SKILLS.size():
		editing_captain_skill = CaptainSkillsScript.SKILLS[index]

func _add_squad_unit(instance_id: String) -> void:
	if _touch_details_active:
		return
	var instance: Dictionary = KineticCrucibleScript.instance_by_id(
		collection_instances, instance_id
	)
	if instance.is_empty() or instance.get("consumed", false):
		return
	var selected_names := SquadStoreScript.instance_names(
		editing_squad_names, collection_instances
	)
	if (
		instance_id not in editing_squad_names
		and selected_names.count(instance.name) < 2
		and editing_squad_names.size() < SquadStoreScript.SQUAD_SIZE
	):
		editing_squad_names.append(instance_id)
	_rebuild_squad_grid()

func _remove_squad_unit_at(index: int) -> void:
	if _touch_details_active:
		return
	if index >= 0 and index < editing_squad_names.size():
		editing_squad_names.remove_at(index)
	_rebuild_squad_grid()

func _remove_one_squad_unit(instance_id: String) -> void:
	var index := editing_squad_names.find(instance_id)
	if index >= 0:
		editing_squad_names.remove_at(index)
	_rebuild_squad_grid()

func _on_squad_drop(instance_id: String, source: String, destination: String) -> void:
	if destination == "squad" and source == "barracks":
		_add_squad_unit(instance_id)
	elif destination == "barracks" and source == "squad":
		_remove_one_squad_unit(instance_id)

func _make_reserve_class_option() -> OptionButton:
	var option := OptionButton.new()
	option.add_item("ALL CLASSES")
	option.set_item_metadata(0, "")
	for kind in UnitCatalogScript.CLASS_NAMES.keys():
		option.add_item(UnitCatalogScript.CLASS_NAMES[kind])
		option.set_item_metadata(option.item_count - 1, kind)
	return option

func _make_reserve_search_edit(on_text_changed: Callable) -> LineEdit:
	var edit := LineEdit.new()
	edit.placeholder_text = "SEARCH UNITS OR SKILLS"
	edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	edit.text_changed.connect(on_text_changed)
	return edit

func _reserve_visible(unit: UnitData, filter_class: String, filter_text: String) -> bool:
	if not filter_class.is_empty() and unit.kind != filter_class:
		return false
	if not filter_text.is_empty():
		var query := filter_text.to_lower()
		var matches_name := unit.name.to_lower().find(query) != -1
		var matches_skill := unit.skill != null and unit.skill.name.to_lower().find(query) != -1
		if not matches_name and not matches_skill:
			return false
	return true

func _rebuild_squad_grid() -> void:
	for child in squad_grid.get_children():
		squad_grid.remove_child(child)
		child.queue_free()
	for child in squad_selection_grid.get_children():
		squad_selection_grid.remove_child(child)
		child.queue_free()
	_refresh_mission_intel()
	reward_carry_label.visible = not recent_reward_name.is_empty()
	reward_carry_label.text = "★ NEW REWARD ADDED · %s" % recent_reward_name.to_upper()

	_sync_collection()
	var selected_names := SquadStoreScript.instance_names(
		editing_squad_names, collection_instances
	)
	var reserves := KineticCrucibleScript.sort_reserves(
		KineticCrucibleScript.active_instances(collection_instances), roster
	)
	for instance in reserves:
		var unit := UnitCatalogScript.by_name(instance.name)
		if unit == null or not _reserve_visible(unit, reserve_filter_class, reserve_filter_text):
			continue
		var copies: int = selected_names.count(instance.name)
		var button: Button = SquadCardScript.new()
		button.configure(instance.id, "barracks", _unit_icon(unit.icon), -1, unit.kind)
		button.custom_minimum_size = Vector2(0, 78)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.icon = _unit_icon(unit.icon)
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.disabled = (
			instance.id in editing_squad_names
			or copies >= 2
			or editing_squad_names.size() >= SquadStoreScript.SQUAD_SIZE
		)
		button.text = "%s%s · LV %d\n%s" % [
			"★ NEW REWARD · " if unit.name == recent_reward_name else "",
			unit.name.to_upper(), instance.level,
			"IN FORMATION" if instance.id in editing_squad_names else "AVAILABLE"
		]
		if unit.name == recent_reward_name:
			button.add_theme_color_override("font_color", UIThemeScript.title_color())
		button.add_theme_font_size_override("font_size", 11)
		button.pressed.connect(_add_squad_unit.bind(instance.id))
		button.connect("unit_dropped", _on_squad_card_drop)
		_connect_card_details(button, _unit_with_instance(unit, instance))
		squad_grid.add_child(button)

	for index in editing_squad_names.size():
		var instance: Dictionary = KineticCrucibleScript.instance_by_id(
			collection_instances, editing_squad_names[index]
		)
		if instance.is_empty():
			continue
		var unit := UnitCatalogScript.by_name(instance.name)
		var card: Button = SquadCardScript.new()
		card.configure(instance.id, "squad", _unit_icon(unit.icon), index, unit.kind)
		card.custom_minimum_size = Vector2(0, 72)
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card.icon = _unit_icon(unit.icon)
		card.alignment = HORIZONTAL_ALIGNMENT_LEFT
		card.text = "%02d · %s · LV %d%s" % [
			index + 1,
			unit.name.to_upper(),
			instance.level,
			"\nVANGUARD" if index == 0 else ""
		]
		card.add_theme_font_size_override("font_size", 11)
		card.pressed.connect(_remove_squad_unit_at.bind(index))
		card.connect("unit_dropped", _on_squad_card_drop)
		card.gui_input.connect(_on_squad_card_gui_input.bind(index))
		_connect_card_details(card, _unit_with_instance(unit, instance))
		squad_selection_grid.add_child(card)

	squad_count_label.text = "%d / %d SELECTED" % [editing_squad_names.size(), SquadStoreScript.SQUAD_SIZE]
	squad_count_label.add_theme_color_override("font_color", Color("#70e0a1") if not editing_squad_names.is_empty() else Color("#ff8f8f"))
	squad_save_button.disabled = editing_squad_names.is_empty()
	squad_start_button.visible = squad_opened_for_mission
	squad_start_button.disabled = editing_squad_names.is_empty()

func _refresh_mission_intel() -> void:
	for child in mission_enemy_preview_row.get_children():
		mission_enemy_preview_row.remove_child(child)
		child.queue_free()
	mission_intel_panel.visible = (
		squad_opened_for_mission
		and pending_mission_id >= 0
		and pending_mission_id < CampaignStoreScript.MISSIONS.size()
	)
	if not mission_intel_panel.visible:
		return
	var mission: Dictionary = CampaignStoreScript.MISSIONS[pending_mission_id]
	var encounter: Dictionary = mission.encounters[0]
	mission_intel_label.text = (
		"UPCOMING · ACT %d / MISSION %d\n%s · %d HP · CAPTAIN: %s"
		% [
			mission.act, mission.act_mission, mission.short_title.to_upper(),
			encounter.enemy_hp, encounter.skill.to_upper()
		]
	)
	mission_intel_stats_label.text = _enemy_squad_summary(encounter.enemy_squad)
	for unit_name in encounter.enemy_squad:
		var unit := UnitCatalogScript.by_name(unit_name)
		if unit == null:
			continue
		var portrait := TextureRect.new()
		portrait.custom_minimum_size = Vector2(42, 48)
		portrait.texture = _unit_icon(unit.icon)
		portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		portrait.tooltip_text = "%s · %s" % [
			unit.name, UnitCatalogScript.display_class(unit.kind)
		]
		portrait.mouse_entered.connect(_show_unit_details.bind(unit.to_dict()))
		portrait.mouse_exited.connect(_hide_unit_details)
		mission_enemy_preview_row.add_child(portrait)

func _enemy_squad_summary(enemy_squad: Array) -> String:
	var enemy_cards := SquadStoreScript.build_deck(enemy_squad, roster)
	if enemy_cards.is_empty():
		return ""
	var mana_total := 0
	var class_counts := {}
	var class_order: Array = []
	for card in enemy_cards:
		mana_total += int(card.get("cost", 0))
		var unit_class := UnitCatalogScript.display_class(str(card.get("kind", "")))
		if not class_counts.has(unit_class):
			class_counts[unit_class] = 0
			class_order.append(unit_class)
		class_counts[unit_class] += 1
	var class_parts: Array = []
	for unit_class in class_order:
		class_parts.append("%s ×%d" % [unit_class.to_upper(), class_counts[unit_class]])
	return "AVG MANA %.1f · RECOMMENDED %s\n%s" % [
		mana_total / float(enemy_cards.size()),
		_recommended_squad_level(enemy_cards),
		" · ".join(class_parts)
	]

func _recommended_squad_level(enemy_cards: Array) -> String:
	if editing_squad_names.is_empty():
		return "—"
	var enemy_power := BattleSimulatorScript.estimate_squad_power(enemy_cards)
	var player_cards := SquadStoreScript.build_deck(
		editing_squad_names, roster, collection_instances
	)
	for level in range(1, KineticCrucibleScript.MAX_LEVEL + 1):
		var scaled_cards: Array = []
		for card in player_cards:
			var scaled: Dictionary = card.duplicate()
			scaled.level = level
			scaled_cards.append(scaled)
		if BattleSimulatorScript.estimate_squad_power(scaled_cards) >= enemy_power:
			return "CRUCIBLE LV %d" % level
	return "CRUCIBLE LV %d+" % KineticCrucibleScript.MAX_LEVEL

func _on_squad_card_drop(
	instance_id: String, source: String, source_index: int, target_index: int
) -> void:
	if target_index < 0:
		if source == "squad":
			_remove_squad_unit_at(source_index)
		return
	if source == "squad":
		_move_squad_unit(source_index, target_index)
	elif source == "barracks":
		var previous_size := editing_squad_names.size()
		_add_squad_unit(instance_id)
		if editing_squad_names.size() > previous_size:
			_move_squad_unit(editing_squad_names.size() - 1, target_index)

func _move_squad_unit(from_index: int, to_index: int) -> void:
	if (
		from_index < 0 or from_index >= editing_squad_names.size()
		or to_index < 0 or to_index >= editing_squad_names.size()
		or from_index == to_index
	):
		return
	var instance_id: String = editing_squad_names[from_index]
	editing_squad_names.remove_at(from_index)
	editing_squad_names.insert(to_index, instance_id)
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
	if SquadStoreScript.save_instance_squad(squad_names, collection_instances):
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
	SquadStoreScript.save_instance_squad(squad_names, collection_instances)
	SquadStoreScript.save_captain_skill(player_captain_skill, CaptainSkillsScript.SKILLS)
	var mission_id := pending_mission_id
	squad_opened_for_mission = false
	pending_mission_id = -1
	squad_overlay.visible = false
	recent_reward_name = ""
	_begin_mission(mission_id)

func _sanitize_squad_unlocks() -> void:
	_sync_collection()
	var clean_squad: Array = SquadStoreScript.sanitize_instances(
		squad_names, collection_instances
	)
	if clean_squad != squad_names:
		squad_names = clean_squad
		SquadStoreScript.save_instance_squad(squad_names, collection_instances)

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
		Color(0.035, 0.025, 0.02, 0.66)
	)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main_menu_overlay.add_child(center)

	var plaque := PanelContainer.new()
	plaque.custom_minimum_size = Vector2(480, 650)
	plaque.add_theme_stylebox_override("panel", UIThemeScript.dark_plaque())
	center.add_child(plaque)

	var layout := VBoxContainer.new()
	layout.custom_minimum_size = Vector2(420, 600)
	layout.alignment = BoxContainer.ALIGNMENT_CENTER
	layout.add_theme_constant_override("separation", 16)
	plaque.add_child(layout)

	var title := Label.new()
	title.text = "WAR OF\nRESONANCE"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 48)
	title.add_theme_color_override("font_color", UIThemeScript.title_color())
	layout.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "CONTROL THE LANE  ·  BREAK THE LINE"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 12)
	subtitle.add_theme_color_override("font_color", UIThemeScript.muted_color())
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

	replay_button = _menu_action("REPLAYS")
	replay_button.pressed.connect(_open_last_replay)
	layout.add_child(replay_button)

	var squad := _menu_action("FORMATION COMMAND")
	squad.pressed.connect(_open_squad_from_menu)
	layout.add_child(squad)

	var crucible := _menu_action("KINETIC CRUCIBLE")
	crucible.pressed.connect(_open_kinetic_crucible)
	layout.add_child(crucible)

	var tutorial := _menu_action("HOW TO PLAY")
	tutorial.pressed.connect(_open_tutorial_from_menu)
	layout.add_child(tutorial)

func _build_replay_controls() -> void:
	replay_panel = PanelContainer.new()
	replay_panel.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	replay_panel.position = Vector2(-390, -112)
	replay_panel.custom_minimum_size = Vector2(780, 96)
	replay_panel.z_index = 95
	replay_panel.visible = false
	add_child(replay_panel)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	replay_panel.add_child(row)

	var menu_center := CenterContainer.new()
	menu_center.custom_minimum_size.x = 76
	row.add_child(menu_center)
	var back := Button.new()
	back.text = "MENU"
	back.custom_minimum_size = Vector2(68, 46)
	back.pressed.connect(_close_replay)
	menu_center.add_child(back)

	row.add_child(VSeparator.new())
	var transport := VBoxContainer.new()
	transport.add_theme_constant_override("separation", 5)
	row.add_child(transport)
	var transport_actions := HBoxContainer.new()
	transport_actions.add_theme_constant_override("separation", 6)
	transport.add_child(transport_actions)
	replay_play_button = Button.new()
	replay_play_button.text = "PLAY"
	replay_play_button.custom_minimum_size.x = 68
	replay_play_button.pressed.connect(_toggle_replay_playback)
	transport_actions.add_child(replay_play_button)
	var step := Button.new()
	step.text = "STEP"
	step.custom_minimum_size.x = 68
	step.pressed.connect(_step_replay)
	transport_actions.add_child(step)
	replay_event_label = Label.new()
	replay_event_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	replay_event_label.add_theme_color_override("font_color", UIThemeScript.muted_color())
	transport.add_child(replay_event_label)

	row.add_child(VSeparator.new())
	var history := VBoxContainer.new()
	history.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	history.add_theme_constant_override("separation", 5)
	row.add_child(history)
	replay_timeline_label = Label.new()
	replay_timeline_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	replay_timeline_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	replay_timeline_label.add_theme_color_override("font_color", UIThemeScript.title_color())
	history.add_child(replay_timeline_label)
	var history_actions := HBoxContainer.new()
	history_actions.alignment = BoxContainer.ALIGNMENT_CENTER
	history_actions.add_theme_constant_override("separation", 8)
	history.add_child(history_actions)
	replay_previous_button = Button.new()
	replay_previous_button.text = "◀ OLDER"
	replay_previous_button.custom_minimum_size.x = 104
	replay_previous_button.pressed.connect(_open_older_replay)
	history_actions.add_child(replay_previous_button)
	replay_next_button = Button.new()
	replay_next_button.text = "NEWER ▶"
	replay_next_button.custom_minimum_size.x = 104
	replay_next_button.pressed.connect(_open_newer_replay)
	history_actions.add_child(replay_next_button)

func _build_replay_squad_overlay() -> void:
	replay_squad_overlay = ColorRect.new()
	replay_squad_overlay.color = Color(0.035, 0.026, 0.02, 0.97)
	replay_squad_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	replay_squad_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	replay_squad_overlay.z_index = 110
	replay_squad_overlay.visible = false
	add_child(replay_squad_overlay)
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 54)
	margin.add_theme_constant_override("margin_right", 54)
	margin.add_theme_constant_override("margin_top", 42)
	margin.add_theme_constant_override("margin_bottom", 42)
	replay_squad_overlay.add_child(margin)
	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 18)
	margin.add_child(layout)
	var title := Label.new()
	title.text = "RECORDED FORMATIONS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 28)
	title.add_theme_color_override("font_color", UIThemeScript.title_color())
	layout.add_child(title)
	var columns := HBoxContainer.new()
	columns.size_flags_vertical = Control.SIZE_EXPAND_FILL
	columns.add_theme_constant_override("separation", 24)
	layout.add_child(columns)
	replay_player_squad_grid = _replay_squad_column(columns, "PLAYER SQUAD", Color("#8bc2c6"))
	replay_enemy_squad_grid = _replay_squad_column(columns, "ENEMY SQUAD", Color("#ff8ba8"))
	var close := Button.new()
	close.text = "RETURN TO REPLAY"
	close.custom_minimum_size = Vector2(220, 44)
	close.pressed.connect(_close_replay_squads)
	layout.add_child(close)

func _replay_squad_column(
	parent: HBoxContainer, heading: String, color: Color
) -> GridContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(panel)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 10)
	panel.add_child(content)
	var title := Label.new()
	title.text = heading
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", color)
	content.add_child(title)
	var grid := GridContainer.new()
	grid.columns = 2
	grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation", 10)
	grid.add_theme_constant_override("v_separation", 10)
	content.add_child(grid)
	return grid

func _build_mission_select() -> void:
	mission_overlay = ColorRect.new()
	mission_overlay.color = Color.TRANSPARENT
	mission_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mission_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	mission_overlay.visible = false
	add_child(mission_overlay)
	_add_overlay_background(
		mission_overlay,
		MAIN_MENU_BACKGROUND,
		Color(0.035, 0.025, 0.02, 0.78)
	)

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
	title.text = "OPERATIONS MAP · THE TEMPEST FRONT"
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", UIThemeScript.title_color())
	layout.add_child(title)

	campaign_progress_label = Label.new()
	campaign_progress_label.add_theme_color_override("font_color", UIThemeScript.muted_color())
	layout.add_child(campaign_progress_label)

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

func _build_kinetic_crucible() -> void:
	crucible_overlay = ColorRect.new()
	crucible_overlay.color = Color.TRANSPARENT
	crucible_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	crucible_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	crucible_overlay.visible = false
	add_child(crucible_overlay)
	_add_overlay_background(
		crucible_overlay,
		MAIN_MENU_BACKGROUND,
		Color(0.035, 0.025, 0.02, 0.76)
	)
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 70)
	margin.add_theme_constant_override("margin_right", 70)
	margin.add_theme_constant_override("margin_top", 42)
	margin.add_theme_constant_override("margin_bottom", 42)
	crucible_overlay.add_child(margin)
	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 14)
	margin.add_child(layout)
	var title_row := HBoxContainer.new()
	layout.add_child(title_row)
	var title := Label.new()
	title.text = "KINETIC CRUCIBLE"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", UIThemeScript.title_color())
	title_row.add_child(title)
	var subtitle := Label.new()
	subtitle.text = "SELECT A UNIT TO ENHANCE · QUEUE ANY NUMBER OF DONORS · MERGE"
	subtitle.add_theme_font_size_override("font_size", 12)
	subtitle.add_theme_color_override("font_color", UIThemeScript.muted_color())
	layout.add_child(subtitle)
	var columns := HBoxContainer.new()
	columns.size_flags_vertical = Control.SIZE_EXPAND_FILL
	columns.add_theme_constant_override("separation", 14)
	layout.add_child(columns)
	var reserves_panel := PanelContainer.new()
	reserves_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	reserves_panel.size_flags_stretch_ratio = 1.0
	columns.add_child(reserves_panel)
	var reserves_layout := VBoxContainer.new()
	reserves_layout.add_theme_constant_override("separation", 8)
	reserves_panel.add_child(reserves_layout)
	var reserves_header := HBoxContainer.new()
	reserves_layout.add_child(reserves_header)
	var reserves_title := Label.new()
	reserves_title.text = "RESERVES · OWNED UNITS"
	reserves_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	reserves_title.add_theme_font_size_override("font_size", 16)
	reserves_title.add_theme_color_override("font_color", UIThemeScript.title_color())
	reserves_header.add_child(reserves_title)
	crucible_extras_toggle = CheckButton.new()
	crucible_extras_toggle.text = "EXTRAS ONLY"
	crucible_extras_toggle.tooltip_text = (
		"Only show spare copies: the two highest-level copies of each unit stay protected and hidden."
	)
	crucible_extras_toggle.button_pressed = true
	crucible_extras_toggle.toggled.connect(_toggle_crucible_extras)
	reserves_header.add_child(crucible_extras_toggle)
	var crucible_filter_row := HBoxContainer.new()
	crucible_filter_row.add_theme_constant_override("separation", 8)
	reserves_layout.add_child(crucible_filter_row)
	crucible_class_option = _make_reserve_class_option()
	crucible_class_option.item_selected.connect(
		func(index):
			crucible_filter_class = crucible_class_option.get_item_metadata(index)
			_rebuild_crucible()
	)
	crucible_filter_row.add_child(crucible_class_option)
	crucible_search_edit = _make_reserve_search_edit(
		func(text):
			crucible_filter_text = text
			_rebuild_crucible()
	)
	crucible_filter_row.add_child(crucible_search_edit)
	var reserves_scroll := ScrollContainer.new()
	reserves_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	reserves_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	reserves_layout.add_child(reserves_scroll)
	crucible_reserve_grid = GridContainer.new()
	crucible_reserve_grid.columns = 2
	crucible_reserve_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	crucible_reserve_grid.add_theme_constant_override("h_separation", 8)
	crucible_reserve_grid.add_theme_constant_override("v_separation", 8)
	reserves_scroll.add_child(crucible_reserve_grid)

	var crucible_panel := PanelContainer.new()
	crucible_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	crucible_panel.size_flags_stretch_ratio = 1.0
	columns.add_child(crucible_panel)
	var crucible_layout := VBoxContainer.new()
	crucible_layout.add_theme_constant_override("separation", 8)
	crucible_panel.add_child(crucible_layout)
	var target_title := Label.new()
	target_title.text = "ENHANCEMENT TARGET · CLICK TO CLEAR"
	target_title.add_theme_font_size_override("font_size", 16)
	target_title.add_theme_color_override("font_color", UIThemeScript.title_color())
	crucible_layout.add_child(target_title)
	crucible_target_grid = GridContainer.new()
	crucible_target_grid.columns = 1
	crucible_target_grid.custom_minimum_size.y = 78
	crucible_layout.add_child(crucible_target_grid)
	var donor_title := Label.new()
	donor_title.text = "CRUCIBLE QUEUE · CLICK TO REMOVE · UNITS WILL BE CONSUMED"
	donor_title.add_theme_font_size_override("font_size", 14)
	donor_title.add_theme_color_override("font_color", Color("#e8b4a2"))
	crucible_layout.add_child(donor_title)
	var donor_scroll := ScrollContainer.new()
	donor_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	donor_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	crucible_layout.add_child(donor_scroll)
	crucible_donor_grid = GridContainer.new()
	crucible_donor_grid.columns = 2
	crucible_donor_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	crucible_donor_grid.add_theme_constant_override("h_separation", 8)
	crucible_donor_grid.add_theme_constant_override("v_separation", 8)
	donor_scroll.add_child(crucible_donor_grid)
	crucible_detail_label = Label.new()
	crucible_detail_label.custom_minimum_size = Vector2(0, 72)
	crucible_detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	crucible_detail_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	crucible_detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	crucible_detail_label.add_theme_font_size_override("font_size", 14)
	crucible_layout.add_child(crucible_detail_label)
	var actions := HBoxContainer.new()
	actions.alignment = BoxContainer.ALIGNMENT_END
	actions.add_theme_constant_override("separation", 12)
	layout.add_child(actions)
	var back := Button.new()
	back.text = "BACK TO MENU"
	back.custom_minimum_size = Vector2(180, 46)
	back.pressed.connect(_show_main_menu)
	actions.add_child(back)
	var debug_copies := Button.new()
	debug_copies.text = "DEBUG · 4 OF EACH"
	debug_copies.tooltip_text = (
		"Grant enough copies to hold at least four active copies of every unit."
	)
	debug_copies.custom_minimum_size = Vector2(180, 46)
	debug_copies.pressed.connect(_debug_grant_four_of_each)
	actions.add_child(debug_copies)
	crucible_promote_button = Button.new()
	crucible_promote_button.text = "PROMOTE"
	crucible_promote_button.tooltip_text = (
		"Convert a level 5 unit into its promoted form. The promoted form starts at level 1."
	)
	crucible_promote_button.custom_minimum_size = Vector2(200, 46)
	crucible_promote_button.pressed.connect(_promote_crucible_unit)
	actions.add_child(crucible_promote_button)
	crucible_merge_button = Button.new()
	crucible_merge_button.text = "MERGE QUEUE"
	crucible_merge_button.custom_minimum_size = Vector2(200, 46)
	crucible_merge_button.pressed.connect(_merge_crucible_units)
	actions.add_child(crucible_merge_button)

func _open_kinetic_crucible() -> void:
	main_menu_overlay.visible = false
	crucible_overlay.visible = true
	crucible_target_id = ""
	crucible_donor_ids.clear()
	crucible_notice = ""
	await get_tree().process_frame
	_rebuild_crucible()

func _toggle_crucible_extras(_enabled: bool) -> void:
	crucible_notice = ""
	_rebuild_crucible()

func _select_crucible_unit(instance_id: String) -> void:
	if _touch_details_active:
		return
	if crucible_target_id.is_empty():
		crucible_target_id = instance_id
		crucible_notice = ""
	elif instance_id != crucible_target_id and instance_id not in crucible_donor_ids:
		var donor := KineticCrucibleScript.instance_by_id(
			collection_instances, instance_id
		)
		if _crucible_donor_allowed(donor):
			crucible_donor_ids.append(instance_id)
			crucible_notice = ""
	_rebuild_crucible()

func _clear_crucible_target() -> void:
	if _touch_details_active:
		return
	crucible_target_id = ""
	crucible_donor_ids.clear()
	crucible_notice = ""
	_rebuild_crucible()

func _remove_crucible_donor(instance_id: String) -> void:
	if _touch_details_active:
		return
	crucible_donor_ids.erase(instance_id)
	crucible_notice = ""
	_rebuild_crucible()

func _debug_grant_four_of_each() -> void:
	_sync_collection()
	var before := KineticCrucibleScript.inventory_counts(collection_instances)
	var granted := 0
	for unit in roster:
		granted += maxi(0, 4 - int(before.get(unit.name, 0)))
	earned_reward_units = CampaignStoreScript.debug_grant_minimum_copies(
		roster, earned_reward_units, before, 4
	)
	_sync_collection()
	crucible_notice = (
		"Debug inventory ready · granted %d copies · every unit now has at least 4 active copies."
		% granted
	)
	_rebuild_crucible()

func _rebuild_crucible() -> void:
	_sync_collection()
	var active := KineticCrucibleScript.active_instances(collection_instances)
	if not active.any(func(instance): return instance.id == crucible_target_id):
		crucible_target_id = ""
		crucible_donor_ids.clear()
	crucible_donor_ids = crucible_donor_ids.filter(
		func(instance_id): return active.any(
			func(instance): return instance.id == instance_id
		)
	)
	for grid in [crucible_reserve_grid, crucible_target_grid, crucible_donor_grid]:
		for child in grid.get_children():
			grid.remove_child(child)
			child.queue_free()
	var protected_ids := _crucible_protected_ids(active)
	for instance in KineticCrucibleScript.sort_reserves(active, roster):
		if instance.id in protected_ids:
			continue
		var unit := UnitCatalogScript.by_name(instance.name)
		if unit == null or not _reserve_visible(unit, crucible_filter_class, crucible_filter_text):
			continue
		var card: Button = SquadCardScript.new()
		card.configure(
			instance.id, "crucible_reserve", _unit_icon(unit.icon), -1, unit.kind
		)
		card.custom_minimum_size = Vector2(0, 78)
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card.icon = _unit_icon(unit.icon)
		card.alignment = HORIZONTAL_ALIGNMENT_LEFT
		var state := "SELECT TO ENHANCE"
		if not crucible_target_id.is_empty():
			if instance.id == crucible_target_id:
				state = "ENHANCEMENT TARGET"
				card.disabled = true
			elif instance.id in crucible_donor_ids:
				state = "QUEUED FOR MERGE"
				card.disabled = true
			elif _crucible_donor_allowed(instance):
				state = "+%d POINTS · CLICK TO QUEUE" % KineticCrucibleScript.merge_value(
					_crucible_target(), instance, roster
				)
			else:
				state = "NOT A VALID DONOR"
				card.disabled = true
		card.text = "%s · LV %d\n%s" % [
			unit.name.to_upper(), instance.level, state
		]
		card.add_theme_font_size_override("font_size", 10)
		card.pressed.connect(_select_crucible_unit.bind(instance.id))
		_connect_card_details(card, _unit_with_instance(unit, instance))
		crucible_reserve_grid.add_child(card)
	_build_crucible_selection_cards()
	_refresh_crucible_detail()

func _build_crucible_selection_cards() -> void:
	var target := _crucible_target()
	if target.is_empty():
		var empty_target := Label.new()
		empty_target.text = "Select any owned unit from Reserves."
		empty_target.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		empty_target.add_theme_color_override("font_color", UIThemeScript.muted_color())
		crucible_target_grid.add_child(empty_target)
		return
	var target_unit := UnitCatalogScript.by_name(target.name)
	var target_card := SquadCardScript.new()
	target_card.configure(
		target.id, "crucible_target", _unit_icon(target_unit.icon), -1, target_unit.kind
	)
	target_card.custom_minimum_size = Vector2(0, 72)
	target_card.icon = _unit_icon(target_unit.icon)
	target_card.alignment = HORIZONTAL_ALIGNMENT_LEFT
	target_card.text = "%s · LV %d\nENHANCEMENT TARGET" % [
		target.name.to_upper(), target.level
	]
	target_card.pressed.connect(_clear_crucible_target)
	_connect_card_details(target_card, _unit_with_instance(target_unit, target))
	crucible_target_grid.add_child(target_card)
	for donor_id in crucible_donor_ids:
		var donor := KineticCrucibleScript.instance_by_id(
			collection_instances, donor_id
		)
		if donor.is_empty():
			continue
		var unit := UnitCatalogScript.by_name(donor.name)
		var card := SquadCardScript.new()
		card.configure(donor.id, "crucible_queue", _unit_icon(unit.icon), -1, unit.kind)
		card.custom_minimum_size = Vector2(0, 72)
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card.icon = _unit_icon(unit.icon)
		card.alignment = HORIZONTAL_ALIGNMENT_LEFT
		card.text = "%s · LV %d\nCONSUME · +%d POINTS" % [
			donor.name.to_upper(),
			donor.level,
			KineticCrucibleScript.merge_value(target, donor, roster)
		]
		card.pressed.connect(_remove_crucible_donor.bind(donor.id))
		_connect_card_details(card, _unit_with_instance(unit, donor))
		crucible_donor_grid.add_child(card)

func _crucible_target() -> Dictionary:
	return KineticCrucibleScript.instance_by_id(
		collection_instances, crucible_target_id
	)

func _crucible_donor_allowed(donor: Dictionary) -> bool:
	var target := _crucible_target()
	return KineticCrucibleScript.can_merge(target, donor, roster)

## When EXTRAS ONLY is on, the two most-invested copies of each unit name
## (highest level, then points) are protected from sacrifice and hidden from
## the reserves list, so only spare copies are offered for consumption.
func _crucible_protected_ids(active: Array) -> Array:
	if not crucible_extras_toggle.button_pressed:
		return []
	var by_name := {}
	for instance in active:
		if not by_name.has(instance.name):
			by_name[instance.name] = []
		by_name[instance.name].append(instance)
	var protected: Array = []
	for copies in by_name.values():
		copies.sort_custom(
			func(a, b):
				if a.level != b.level:
					return a.level > b.level
				if a.get("points", 0) != b.get("points", 0):
					return a.get("points", 0) > b.get("points", 0)
				return a.id < b.id
		)
		for index in mini(2, copies.size()):
			protected.append(copies[index].id)
	return protected

func _refresh_crucible_detail() -> void:
	var target := _crucible_target()
	if target.is_empty():
		crucible_detail_label.text = "Choose the individual unit you want to enhance."
		crucible_merge_button.disabled = true
		crucible_promote_button.disabled = true
		return
	var promoted := KineticCrucibleScript.promotion_target(target.name, roster)
	var promotion_available := promoted != null
	var progression := (
		"LEVEL 5 · MAXIMUM%s" % (
			" · PROMOTION READY → %s" % promoted.name.to_upper()
			if promotion_available else ""
		)
		if target.level >= KineticCrucibleScript.MAX_LEVEL
		else "LEVEL %d · %d / %d POINTS · %d TO NEXT LEVEL" % [
			target.level,
			target.points,
			KineticCrucibleScript.LEVEL_COSTS[target.level - 1],
			KineticCrucibleScript.points_to_next(target)
		]
	)
	var total_points := 0
	for donor_id in crucible_donor_ids:
		var donor := KineticCrucibleScript.instance_by_id(
			collection_instances, donor_id
		)
		total_points += KineticCrucibleScript.merge_value(target, donor, roster)
	var merge_text := "Select one or more donor units from Reserves."
	if target.level >= KineticCrucibleScript.MAX_LEVEL:
		merge_text = (
			"Promote to convert it into %s, which starts at level 1." % promoted.name
			if promotion_available
			else "This unit has reached its final form."
		)
	elif not crucible_donor_ids.is_empty():
		var projected := KineticCrucibleScript.apply_points(target, total_points)
		merge_text = "%d queued · +%d points · result: Level %d, %d points." % [
			crucible_donor_ids.size(), total_points, projected.level, projected.points
		]
	crucible_detail_label.text = "%s\n%s%s" % [
		progression,
		merge_text,
		"\n" + crucible_notice if not crucible_notice.is_empty() else ""
	]
	crucible_merge_button.disabled = (
		crucible_donor_ids.is_empty()
		or target.level >= KineticCrucibleScript.MAX_LEVEL
	)
	crucible_promote_button.disabled = (
		target.level < KineticCrucibleScript.MAX_LEVEL
		or not promotion_available
	)

func _promote_crucible_unit() -> void:
	var result: Dictionary = KineticCrucibleScript.record_promotion(
		crucible_target_id,
		roster,
		CampaignStoreScript.inventory_counts(roster, earned_reward_units)
	)
	crucible_notice = result.get("message", "Promotion failed.")
	crucible_donor_ids.clear()
	_sanitize_squad_unlocks()
	_rebuild_crucible()

func _merge_crucible_units() -> void:
	var result: Dictionary = KineticCrucibleScript.record_merge_batch(
		crucible_target_id,
		crucible_donor_ids,
		roster,
		CampaignStoreScript.inventory_counts(roster, earned_reward_units)
	)
	crucible_notice = result.get("message", "Merge failed.")
	crucible_donor_ids.clear()
	_sanitize_squad_unlocks()
	_rebuild_crucible()

func _inventory_counts() -> Dictionary:
	_sync_collection()
	return KineticCrucibleScript.inventory_counts(collection_instances)

func _sync_collection() -> void:
	collection_instances = KineticCrucibleScript.sync_instances(
		roster,
		CampaignStoreScript.inventory_counts(roster, earned_reward_units)
	)

func _unit_with_instance(unit: UnitData, instance: Dictionary) -> Dictionary:
	var result := unit.to_dict()
	result.instance_id = instance.get("id", "")
	result.level = instance.get("level", 1)
	result.level_points = instance.get("points", 0)
	return result

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
	if get_tree().paused:
		get_tree().paused = false
	if settings_panel != null:
		settings_panel.visible = false
	replay_mode = false
	replay_playing = false
	if replay_panel != null:
		replay_panel.visible = false
	if replay_squad_overlay != null:
		replay_squad_overlay.visible = false
	menu_button.visible = true
	end_button.visible = false
	power_button.visible = true
	input_enabled = false
	squad_opened_from_menu = false
	squad_opened_for_mission = false
	tutorial_opened_from_menu = false
	pending_mission_id = -1
	main_menu_overlay.visible = true
	mission_overlay.visible = false
	crucible_overlay.visible = false
	squad_overlay.visible = false
	tutorial_overlay.visible = false
	overlay.visible = false
	hover_card.visible = false
	combat_log_panel.visible = false
	var saved_run: Dictionary = MissionRunStoreScript.load_run(CampaignStoreScript.MISSIONS.size())
	resume_button.disabled = saved_run.is_empty()
	replay_button.disabled = not FileAccess.file_exists(REPLAY_HISTORY_PATH) \
		and not FileAccess.file_exists(REPLAY_PATH)
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
	await get_tree().process_frame
	_rebuild_mission_list()

func _open_last_replay() -> void:
	settings_panel.visible = false
	replay_history = BattleSimulatorScript.load_replay_history(REPLAY_HISTORY_PATH)
	if replay_history.is_empty():
		var legacy_replay: Dictionary = BattleSimulatorScript.load_replay(REPLAY_PATH)
		if not legacy_replay.is_empty():
			replay_history.append(legacy_replay)
	if replay_history.is_empty():
		replay_button.disabled = true
		return
	replay_history_index = 0
	replay_mode = true
	replay_playing = false
	_load_replay_at_index()

func _load_replay_at_index() -> void:
	if replay_history_index < 0 or replay_history_index >= replay_history.size():
		return
	replay_playing = false
	replay_play_button.text = "PLAY"
	replay_data = replay_history[replay_history_index]
	replay_event_index = 0
	main_menu_overlay.visible = false
	mission_overlay.visible = false
	overlay.visible = false
	replay_panel.visible = true
	menu_button.visible = false
	end_button.visible = false
	power_button.visible = false
	input_enabled = false
	battle_over = false
	units.clear()
	player_hand.clear()
	enemy_hand.clear()
	battle_deck.clear()
	enemy_deck.clear()
	selected_hand_index = -1
	selected_board_unit_id = -1
	next_unit_id = 1
	player_hp = STARTING_HP
	enemy_hp = STARTING_HP
	player_shield = 0
	enemy_shield = 0
	status_message = "Replay ready."
	var events: Array = replay_data.get("events", [])
	for event in events:
		if event.get("type", "") == "battle_started":
			player_hp = event.get("player_hp", STARTING_HP)
			enemy_hp = event.get("enemy_hp", STARTING_HP)
			break
	_update_replay_timeline()
	_refresh()

func _open_older_replay() -> void:
	if replay_history_index + 1 >= replay_history.size():
		return
	replay_history_index += 1
	_load_replay_at_index()

func _open_newer_replay() -> void:
	if replay_history_index <= 0:
		return
	replay_history_index -= 1
	_load_replay_at_index()

func _close_replay() -> void:
	replay_playing = false
	replay_squad_overlay.visible = false
	battle_audio.stop_all()
	menu_button.visible = true
	end_button.visible = false
	power_button.visible = true
	_show_main_menu()

func _toggle_replay_playback() -> void:
	replay_playing = not replay_playing
	replay_play_button.text = "PAUSE" if replay_playing else "PLAY"
	if replay_playing:
		_play_replay()

func _play_replay() -> void:
	while replay_playing and replay_event_index < replay_data.get("events", []).size():
		await _apply_next_replay_event()
	if replay_event_index >= replay_data.get("events", []).size():
		replay_playing = false
		replay_play_button.text = "PLAY"

func _step_replay() -> void:
	if replay_playing:
		return
	await _apply_next_replay_event()

func _apply_next_replay_event() -> void:
	var events: Array = replay_data.get("events", [])
	if replay_event_index >= events.size():
		return
	var event: Dictionary = events[replay_event_index]
	replay_event_index += 1
	var event_type: String = event.get("type", "")
	match event_type:
		"combat_log":
			status_message = event.get("message", "")
		"deploy":
			var card := UnitCatalogScript.by_name(event.get("card", ""))
			if card != null:
				var side: int = event.get("side", PLAYER)
				var row: int = event.get("row", 0)
				var col := 0 if side == PLAYER else COLS - 1
				var spawned := _spawn_unit(card.to_dict(), side, row, col)
				spawned.id = event.get("unit_id", spawned.id)
				next_unit_id = maxi(next_unit_id, spawned.id + 1)
				battle_audio.play("deploy")
				await board.animate_unit_move(
					spawned.id, row, -1 if side == PLAYER else COLS,
					_animation_duration(0.24)
				)
		"reposition":
			var shifted = _unit_by_id(event.get("unit_id", -1))
			if shifted != null:
				var from_row: int = event.get("from_row", shifted.row)
				shifted.row = event.get("to_row", shifted.row)
				await board.animate_unit_move(
					shifted.id, from_row, shifted.col, _animation_duration(0.20)
				)
		"move":
			var mover = _unit_by_id(event.get("unit_id", -1))
			if mover != null:
				var old_col: int = event.get("from_col", mover.col)
				mover.col = event.get("to_col", mover.col)
				await board.animate_unit_move(
					mover.id, mover.row, old_col, _animation_duration(0.22)
				)
		"attack":
			var attacker = _unit_by_id(event.get("actor_id", -1))
			var target = _unit_by_id(event.get("target_id", -1))
			if attacker != null and target != null:
				_play_attack_sound(attacker.kind)
				await board.animate_attack(
					attacker.id, target.id, attacker.kind, _animation_duration(0.20)
				)
				target.hp = event.get("target_hp", target.hp)
				await board.animate_hit(target.id, _animation_duration(0.14))
		"commander_attack":
			var commander_attacker = _unit_by_id(event.get("actor_id", -1))
			var side: int = event.get("side", ENEMY)
			if commander_attacker != null:
				await board.animate_commander_attack(
					commander_attacker.id, side, commander_attacker.kind,
					_animation_duration(0.20)
				)
			if side == PLAYER:
				player_hp = event.get("captain_hp", player_hp)
			else:
				enemy_hp = event.get("captain_hp", enemy_hp)
			board.shake(6.0)
		"unit_defeated":
			var defeated = _unit_by_id(event.get("unit_id", -1))
			if defeated != null:
				await board.animate_defeat(defeated.id, _animation_duration(0.20))
				units.erase(defeated)
		"state_snapshot":
			_apply_replay_snapshot(event)
		"battle_finished":
			_verify_replay_result(event)
	_refresh()
	_update_replay_timeline()
	await _wait(0.08)

func _apply_replay_snapshot(event: Dictionary) -> void:
	for state in event.get("units", []):
		var unit = _unit_by_id(state.get("id", -1))
		if unit != null:
			for key in state:
				unit[key] = state[key]
	player_hp = event.get("player_hp", player_hp)
	enemy_hp = event.get("enemy_hp", enemy_hp)
	player_shield = event.get("player_shield", player_shield)
	enemy_shield = event.get("enemy_shield", enemy_shield)

func _verify_replay_result(event: Dictionary) -> void:
	var expected_player: int = event.get("player_hp", player_hp)
	var expected_enemy: int = event.get("enemy_hp", enemy_hp)
	if player_hp == expected_player and enemy_hp == expected_enemy:
		status_message = "REPLAY COMPLETE · Final state verified."
	else:
		status_message = "REPLAY DESYNC · Expected %d–%d HP, got %d–%d." % [
			expected_player, expected_enemy, player_hp, enemy_hp
		]

func _update_replay_timeline() -> void:
	var count: int = replay_data.get("events", []).size()
	replay_event_label.text = "EVENT %d / %d" % [replay_event_index, count]
	replay_timeline_label.text = "REPLAY %d / %d  ·  SEED %s" % [
		replay_history_index + 1, replay_history.size(),
		str(replay_data.get("seed", 0))
	]
	replay_previous_button.disabled = replay_history_index + 1 >= replay_history.size()
	replay_next_button.disabled = replay_history_index <= 0

func _rebuild_mission_list() -> void:
	for child in mission_list.get_children():
		mission_list.remove_child(child)
		child.queue_free()
	var act_one_complete := completed_missions.filter(func(id): return id < 22).size()
	var act_two_complete := completed_missions.filter(func(id): return id >= 22).size()
	var saved_run: Dictionary = MissionRunStoreScript.load_run(
		CampaignStoreScript.MISSIONS.size()
	)
	var run_text := ""
	if not saved_run.is_empty():
		var run_mission: Dictionary = CampaignStoreScript.MISSIONS[saved_run.mission_id]
		run_text = "  ·  ACTIVE RUN: ACT %d MISSION %d · BATTLE %d/%d · %d HP" % [
			run_mission.act, run_mission.act_mission,
			saved_run.encounter_index + 1, run_mission.encounters.size(),
			saved_run.captain_hp
		]
	campaign_progress_label.text = (
		"ACT 1  %d/22 COMPLETE  ·  ACT 2  %d/40 COMPLETE%s"
		% [act_one_complete, act_two_complete, run_text]
	)
	var inventory: Dictionary = _inventory_counts()
	# Build rows progressively: creating ~62 wrapped-text rows takes seconds on
	# mobile, so yield every few rows to keep the page responsive. The token
	# aborts this coroutine if a newer rebuild starts or the user navigates
	# away mid-build.
	mission_list_build_token += 1
	var build_token := mission_list_build_token
	var built := 0
	for mission in CampaignStoreScript.MISSIONS:
		if build_token != mission_list_build_token or not mission_overlay.visible:
			return
		var available: bool = CampaignStoreScript.is_available(mission.id, completed_missions)
		var complete: bool = mission.id in completed_missions
		var entry := VBoxContainer.new()
		entry.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		entry.add_theme_constant_override("separation", 4)
		mission_list.add_child(entry)

		var button := Button.new()
		button.custom_minimum_size.y = 92
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.text_overrun_behavior = TextServer.OVERRUN_NO_TRIMMING
		button.disabled = not available
		if OS.has_feature("mobile"):
			# Let touch drags bubble up to the ScrollContainer so the list
			# scrolls even when the gesture starts on a mission row (same
			# treatment as SquadCard).
			button.mouse_filter = Control.MOUSE_FILTER_PASS
		button.text = "%s  ACT %d · MISSION %02d  ·  %s  ·  %d BATTLE%s  ·  UP TO %d HP\n%s" % [
			"✓" if complete else ("◆" if available else "🔒"),
			mission.act,
			mission.act_mission,
			mission.short_title.to_upper(),
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
		reward_label.add_theme_color_override("font_color", UIThemeScript.muted_color())
		rewards.add_child(reward_label)

		for option in reward_options:
			var reward_unit: UnitData = option.unit
			var is_unobtained: bool = int(inventory.get(reward_unit.name, 0)) <= 0
			var tile := VBoxContainer.new()
			tile.custom_minimum_size = Vector2(34, 40)
			tile.add_theme_constant_override("separation", 0)
			rewards.add_child(tile)

			var art_slot := Control.new()
			art_slot.custom_minimum_size = Vector2(32, 30)
			art_slot.mouse_filter = Control.MOUSE_FILTER_PASS
			tile.add_child(art_slot)

			var portrait := TextureRect.new()
			portrait.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
			portrait.texture = _unit_icon(reward_unit.icon)
			portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			portrait.mouse_default_cursor_shape = Control.CURSOR_HELP
			if not OS.has_feature("mobile"):
				# Hover details are desktop-only; on touch they would fire on
				# every tap/scroll and linger as a stuck popup.
				portrait.mouse_entered.connect(
					_show_reward_details.bind(reward_unit.to_dict(), float(option.chance))
				)
				portrait.mouse_exited.connect(_hide_unit_details)
			art_slot.add_child(portrait)

			if is_unobtained:
				var new_tag := Label.new()
				new_tag.text = "NEW"
				new_tag.position = Vector2(-2, -4)
				new_tag.size = Vector2(28, 12)
				new_tag.mouse_filter = Control.MOUSE_FILTER_IGNORE
				new_tag.z_index = 2
				new_tag.add_theme_font_size_override("font_size", 8)
				new_tag.add_theme_color_override("font_color", Color("#8ee0a6"))
				new_tag.add_theme_color_override("font_outline_color", Color("#102018"))
				new_tag.add_theme_constant_override("outline_size", 2)
				art_slot.add_child(new_tag)

			var stars := Label.new()
			stars.text = "★".repeat(reward_unit.stars)
			stars.mouse_filter = Control.MOUSE_FILTER_IGNORE
			stars.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			stars.add_theme_font_size_override("font_size", 9)
			stars.add_theme_color_override("font_color", UIThemeScript.title_color())
			tile.add_child(stars)

		var divider := HSeparator.new()
		divider.mouse_filter = Control.MOUSE_FILTER_IGNORE
		entry.add_child(divider)
		built += 1
		if built % 6 == 0:
			await get_tree().process_frame
			if build_token != mission_list_build_token or not mission_overlay.visible:
				return

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
	board.set_practice_mode(true)
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
	board.set_practice_mode(false)
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
	board.set_practice_mode(false)
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
	hover_card.custom_minimum_size = HOVER_CARD_SIZE
	hover_card.size = HOVER_CARD_SIZE
	hover_card.clip_contents = true
	hover_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hover_card.z_index = 100
	hover_card.visible = false

	var style := StyleBoxFlat.new()
	style.bg_color = Color("#172334")
	style.border_color = UIThemeScript.BRASS
	style.set_border_width_all(3)
	style.set_corner_radius_all(8)
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 12
	style.content_margin_bottom = 18
	hover_card.add_theme_stylebox_override("panel", style)
	add_child(hover_card)

	var content := VBoxContainer.new()
	content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	content.add_theme_constant_override("separation", 8)
	hover_card.add_child(content)

	hover_name_label = Label.new()
	hover_name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hover_name_label.add_theme_font_size_override("font_size", 18)
	hover_name_label.add_theme_color_override("font_color", UIThemeScript.title_color())
	content.add_child(hover_name_label)

	hover_stats_label = Label.new()
	hover_stats_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hover_stats_label.add_theme_font_size_override("font_size", 13)
	hover_stats_label.add_theme_color_override("font_color", UIThemeScript.PARCHMENT_LIGHT)
	content.add_child(hover_stats_label)

	hover_ability_label = RichTextLabel.new()
	hover_ability_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hover_ability_label.bbcode_enabled = true
	hover_ability_label.custom_minimum_size.y = 166
	hover_ability_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	hover_ability_label.fit_content = false
	hover_ability_label.scroll_active = true
	hover_ability_label.scroll_following = false
	hover_ability_label.add_theme_font_size_override("font_size", 13)
	hover_ability_label.add_theme_color_override("default_color", UIThemeScript.muted_color())
	content.add_child(hover_ability_label)

	hover_drop_label = Label.new()
	hover_drop_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hover_drop_label.visible = false
	hover_drop_label.custom_minimum_size.y = 22
	hover_drop_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hover_drop_label.add_theme_font_size_override("font_size", 13)
	hover_drop_label.add_theme_color_override("font_color", UIThemeScript.title_color())
	content.add_child(hover_drop_label)

func _show_unit_details(unit: Dictionary) -> void:
	var definition := UnitCatalogScript.by_name(unit.name)
	if definition == null:
		_hide_unit_details()
		return
	var current_hp: int = unit.get("hp", definition.hp)
	var maximum_hp: int = unit.get("max_hp", definition.hp)
	var hp_text := "%d HP" % current_hp
	if current_hp != maximum_hp:
		hp_text = "%d / %d HP" % [current_hp, maximum_hp]

	hover_name_label.text = "%s  ·  %s" % [
		definition.name.to_upper(),
		UnitCatalogScript.display_class(definition.kind)
	]
	var unit_level: int = unit.get("level", 1)
	hover_stats_label.text = "LEVEL %d · %d MANA · %s\n%d ATK    %s    %d MOV    %d RANGE" % [
		unit_level,
		definition.cost,
		"★".repeat(definition.stars),
		unit.get("atk", definition.atk),
		hp_text,
		definition.move,
		definition.range
	]
	var active_effects: String = CaptainSkillsScript.effect_summary(unit)
	hover_ability_label.text = _format_primary_ability(definition.description)
	var skill: SkillData = definition.skill
	if skill != null:
		hover_ability_label.text += "\n\n%s · %s\n[font_size=12][color=#c4b99f]%s[/color][/font_size]\n[font_size=11][color=#938b7b]%s[/color][/font_size]" % [
			skill.name.to_upper(),
			skill.type.to_upper(),
			skill.format_text(unit_level),
			UnitSkillsScript.timing_tooltip(skill.type)
		]
	if not active_effects.is_empty():
		hover_ability_label.text += "\nACTIVE  [font_size=12][color=#c4b99f]%s[/color][/font_size]" % active_effects
	hover_drop_label.visible = false
	hover_card.size = HOVER_CARD_SIZE
	hover_card.visible = true
	_position_hover_card()

func _show_reward_details(unit: Dictionary, chance: float) -> void:
	_show_unit_details(unit)
	hover_drop_label.text = "DROP CHANCE  ·  %.1f%%" % (chance * 100.0)
	hover_drop_label.visible = true

func _format_primary_ability(description: String) -> String:
	var divider := description.find(" — ")
	if divider < 0:
		return "[font_size=12][color=#c4b99f]%s[/color][/font_size]" % description
	return "%s — [font_size=12][color=#c4b99f]%s[/color][/font_size]" % [
		description.left(divider),
		description.substr(divider + 3)
	]

func _hide_unit_details() -> void:
	hover_card.visible = false

func _connect_card_details(card: SquadCard, unit_dict: Dictionary) -> void:
	# Desktop shows details on hover. Touch has no hover — mouse_entered would
	# fire on every tap and scroll start — so mobile uses long-press instead.
	if OS.has_feature("mobile"):
		card.long_pressed.connect(_on_card_long_pressed.bind(unit_dict))
		card.long_press_released.connect(_on_card_long_press_released)
	else:
		card.mouse_entered.connect(_show_unit_details.bind(unit_dict))
		card.mouse_exited.connect(_hide_unit_details)

func _on_card_long_pressed(unit_dict: Dictionary) -> void:
	# Suppress the tap action of the release that ends this long-press; card
	# handlers check _touch_details_active. The Viewport delivers the release
	# to the pressed button regardless of mouse_filter, so the suppression has
	# to happen at the action level.
	_touch_details_active = true
	_show_unit_details(unit_dict)

func _on_card_long_press_released() -> void:
	_hide_unit_details()
	# Clear after this frame so the button activation from the same release
	# still sees the suppression flag.
	await get_tree().process_frame
	_touch_details_active = false

func _process(_delta: float) -> void:
	if hover_card != null and hover_card.visible:
		_position_hover_card()

func _position_hover_card() -> void:
	var pointer := get_viewport().get_mouse_position()
	var card_size := HOVER_CARD_SIZE
	var viewport_size := get_viewport_rect().size
	var target := pointer + Vector2(18, 18)
	if OS.has_feature("mobile"):
		# Long-press popup: keep it above the finger instead of under it.
		target = pointer + Vector2(-card_size.x * 0.5, -card_size.y - 48)
	if target.x + card_size.x > viewport_size.x - 10:
		target.x = pointer.x - card_size.x - 18
	if target.y + card_size.y > viewport_size.y - 10:
		target.y = viewport_size.y - card_size.y - 10
	hover_card.position = Vector2(maxf(10, target.x), maxf(10, target.y))

func _start_new_match() -> void:
	replay_mode = false
	replay_playing = false
	power_button.visible = true
	end_button.visible = true
	if replay_panel != null:
		replay_panel.visible = false
	units.clear()
	combat_log_lines.clear()
	last_logged_message = ""
	if combat_log_label != null:
		combat_log_label.text = ""
	player_hand.clear()
	enemy_hand.clear()
	battle_seed = int(Time.get_unix_time_from_system() * 1000.0) ^ int(Time.get_ticks_usec())
	battle_simulator.reset(battle_seed)
	battle_deck = SquadStoreScript.shuffle_for_battle(
		SquadStoreScript.build_deck(
			squad_names, roster, collection_instances
		), battle_simulator.rng
	)
	var encounter: Dictionary = CampaignStoreScript.encounter(current_mission_id, current_encounter_index) if campaign_battle else {}
	var enemy_squad_names: Array = CampaignStoreScript.enemy_squad_names(
		current_mission_id, current_encounter_index, roster
	)
	enemy_deck = SquadStoreScript.shuffle_for_battle(
		SquadStoreScript.build_deck(enemy_squad_names, roster), battle_simulator.rng
	)
	draw_index = 0
	enemy_draw_index = 0
	selected_hand_index = -1
	selected_board_unit_id = -1
	pending_empower_actor_id = -1
	pending_envenom_actor_id = -1
	pending_lane_actor_id = -1
	next_unit_id = 1
	last_deployed_unit_id = {PLAYER: -1, ENEMY: -1}
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
	battle_simulator.record("battle_started", {
		"mission_id": current_mission_id,
		"encounter_index": current_encounter_index,
		"player_hp": player_hp,
		"enemy_hp": enemy_hp,
		"player_squad": SquadStoreScript.instance_names(
			squad_names, collection_instances
		),
		"enemy_squad": enemy_squad_names.duplicate(),
		"player_skill": player_captain_skill,
		"enemy_skill": enemy_captain_skill
	})
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
		not input_enabled or battle_over
		or pending_empower_actor_id >= 0 or pending_envenom_actor_id >= 0
		or pending_lane_actor_id >= 0
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
		var pending_actor = _unit_by_id(pending_empower_actor_id)
		var ally_kinds: Array = _ally_target_kinds(
			pending_actor.get("skill", {}).get("name", "") if pending_actor != null else ""
		)
		targetable_ids = units.filter(
			func(unit): return (
				unit.side == PLAYER and unit.id != pending_empower_actor_id
				and (ally_kinds.is_empty() or unit.kind in ally_kinds)
			)
		).map(func(unit): return unit.id)
	elif pending_envenom_actor_id >= 0:
		targetable_ids = units.filter(
			func(unit): return unit.side == ENEMY
		).map(func(unit): return unit.id)
	elif pending_lane_actor_id >= 0:
		targetable_ids = []
	var targetable_rows: Array = []
	if pending_lane_actor_id >= 0:
		var lane_actor = _unit_by_id(pending_lane_actor_id)
		var lane_skill_name: String = (
			lane_actor.get("skill", {}).get("name", "") if lane_actor != null else ""
		)
		var lane_kinds: Array = _lane_target_kinds(lane_skill_name)
		var lane_side := _lane_target_side(lane_skill_name)
		for row in ROWS:
			if units.any(
				func(unit): return (
					unit.side == lane_side and unit.row == row
					and (lane_kinds.is_empty() or unit.kind in lane_kinds)
				)
			):
				targetable_rows.append(row)
	board.set_state(
		units, selected, selected_board_unit_id,
		input_enabled and not battle_over, status_message, targetable_ids,
		"%d / %d\n%d LOCKED" % [player_energy, player_max_energy, player_locked_mana],
		"%d / %d\n%d LOCKED" % [enemy_energy, enemy_max_energy, enemy_locked_mana],
		"%d HP%s" % [player_hp, "\n%d SHIELD" % player_shield if player_shield > 0 else ""],
		"%d HP%s" % [enemy_hp, "\n%d SHIELD" % enemy_shield if enemy_shield > 0 else ""],
		"DECK %d" % (battle_deck.size() - draw_index),
		"DECK %d" % (enemy_deck.size() - enemy_draw_index),
		targetable_rows
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
	return UIThemeScript.card_style(color, tint, border_alpha, glow)

func _unit_icon(icon_id: int) -> Texture2D:
	return _unit_icon_at_size(icon_id, 48)

func _unit_icon_at_size(icon_id: int, size: int) -> Texture2D:
	if icon_id < 1:
		return null
	var cache_key := "%d:%d" % [icon_id, size]
	if unit_icon_cache.has(cache_key):
		return unit_icon_cache[cache_key]
	var portrait_path := (
		"res://assets/units/portraits/%03d.png"
		% UnitCatalogScript.art_id(icon_id)
	)
	var portrait_texture := load(portrait_path) as Texture2D
	if portrait_texture == null:
		return null
	var portrait_image := portrait_texture.get_image()
	portrait_image.resize(size, size, Image.INTERPOLATE_LANCZOS)
	var portrait_icon := ImageTexture.create_from_image(portrait_image)
	unit_icon_cache[cache_key] = portrait_icon
	return portrait_icon

func _show_card_reward(unit_name: String, is_new: bool) -> void:
	var unit := UnitCatalogScript.by_name(unit_name)
	reward_reveal.visible = unit != null
	if unit == null:
		return
	reward_portrait.texture = _unit_icon_at_size(unit.icon, 100)
	reward_stars_label.text = "★".repeat(unit.stars)
	reward_new_label.visible = is_new

func _select_card(index: int) -> void:
	if not input_enabled:
		return
	if (
		pending_empower_actor_id >= 0 or pending_envenom_actor_id >= 0
		or pending_lane_actor_id >= 0
	):
		status_message = "Choose the highlighted Warcry target first."
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
		var ally_kinds: Array = _ally_target_kinds(
			actor.get("skill", {}).get("name", "") if actor != null else ""
		)
		if (
			actor != null and clicked != null
			and clicked.side == PLAYER and clicked.id != actor.id
			and (ally_kinds.is_empty() or clicked.kind in ally_kinds)
		):
			pending_empower_actor_id = -1
			status_message = await _resolve_warcry(actor, clicked.id)
		else:
			status_message = "Choose another allied unit as %s's target." % (
				actor.get("skill", {}).get("name", "the Warcry") if actor != null else "the Warcry"
			)
		_refresh()
		return
	if pending_envenom_actor_id >= 0:
		var actor = _unit_by_id(pending_envenom_actor_id)
		if actor != null and clicked != null and clicked.side == ENEMY:
			pending_envenom_actor_id = -1
			status_message = await _resolve_warcry(actor, clicked.id)
		else:
			status_message = "Choose a highlighted enemy unit as %s's target." % (
				actor.get("skill", {}).get("name", "the Warcry") if actor != null else "the Warcry"
			)
		_refresh()
		return
	if pending_lane_actor_id >= 0:
		var actor = _unit_by_id(pending_lane_actor_id)
		var lane_skill_name: String = (
			actor.get("skill", {}).get("name", "") if actor != null else ""
		)
		var lane_kinds: Array = _lane_target_kinds(lane_skill_name)
		var lane_side := _lane_target_side(lane_skill_name)
		if actor != null and units.any(
			func(unit): return (
				unit.side == lane_side and unit.row == row
				and (lane_kinds.is_empty() or unit.kind in lane_kinds)
			)
		):
			pending_lane_actor_id = -1
			status_message = await _resolve_warcry(actor, -1, row)
		else:
			status_message = "Choose one of the highlighted lanes."
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
			battle_simulator.record("reposition", {
				"unit_id": selected.id, "from_row": old_row, "to_row": row
			})
			selected_board_unit_id = selected.id
			status_message = "%s shifts from lane %d to lane %d. Choose another lane or continue." % [selected.name, old_row + 1, row + 1]
			input_enabled = false
			_refresh()
			battle_audio.play("move")
			await board.animate_unit_move(selected.id, old_row, old_col, _animation_duration(0.24))
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
	if BattleRulesScript.is_immobilized(unit):
		return "%s is immobilised and cannot leave this lane." % unit.name
	if BattleRulesScript.is_taunted(unit, units):
		return "%s is taunted by a Defender and cannot leave this lane." % unit.name
	return "Choose a reachable highlighted tile in another lane to reposition %s." % unit.name

func _reposition_block_reason(unit: Dictionary, row: int, col: int) -> String:
	if BattleRulesScript.is_immobilized(unit):
		return "%s is immobilised and must remain in its lane." % unit.name
	if BattleRulesScript.is_taunted(unit, units):
		return "%s is taunted and must remain in its lane." % unit.name
	if col != unit.col or row == unit.row:
		return "Units can only shift between lanes in the same column."
	return "Another unit blocks that lane shift."

func _on_deployment_clicked(row: int) -> void:
	if not input_enabled or selected_hand_index < 0 or selected_hand_index >= player_hand.size():
		return
	if (
		pending_empower_actor_id >= 0 or pending_envenom_actor_id >= 0
		or pending_lane_actor_id >= 0
	):
		status_message = "Choose the highlighted Warcry target first."
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
	battle_simulator.record("deploy", {
		"side": PLAYER, "unit_id": spawned.id, "card": card.name, "row": row
	})
	status_message = "%s deployed to lane %d." % [card.name, row + 1]
	input_enabled = false
	_refresh()
	battle_audio.play("deploy")
	await board.animate_unit_move(spawned.id, row, -1, _animation_duration(0.32))
	input_enabled = true
	var warcry_message := await _resolve_warcry(spawned)
	if not warcry_message.is_empty():
		status_message += " " + warcry_message
	player_hand.remove_at(selected_hand_index)
	selected_hand_index = -1
	_refresh()

func _spawn_unit(card: Dictionary, side: int, row: int, col: int) -> Dictionary:
	var unit_level: int = card.get("level", 1)
	var spawned := {
		"id": next_unit_id,
		"side": side,
		"row": row,
		"col": col,
		"name": card.name,
		"icon": card.get("icon", 0),
		"kind": card.kind,
		"cost": card.cost,
		"atk": KineticCrucibleScript.scaled_stat(card.atk, unit_level),
		"hp": KineticCrucibleScript.scaled_stat(card.hp, unit_level),
		"max_hp": KineticCrucibleScript.scaled_stat(card.hp, unit_level),
		"move": card.move,
		"range": card.range,
		"race": card.get("race", "human"),
		"skill": card.get("skill", {}).duplicate(true),
		"instance_id": card.get("instance_id", ""),
		"level": card.get("level", 1),
		"level_points": card.get("level_points", 0),
		# Deployment is part of the turn: newly placed units move and attack
		# when that side resolves immediately afterward.
		"ready": true,
		"repositioned": false,
		"taunt_turns": 0,
		"immobilized_turns": 0,
		"poison_turns": 0,
		"poison_damage": 0,
		"vulnerable_turns": 0,
		"vulnerable_stacks": 0,
		"protect_turns": 0,
		"regen_turns": 0,
		"stun_turns": 0,
		"silenced_turns": 0,
		"haste_turns": 0,
		"doom_turns": 0,
		"festival_turns": 0,
		"summon_forth_turns": 0,
		"quiet_triggers_left": 0,
		"fury_stacks": 0,
		"effects": []
	}
	# Quiet! fires its Silence trigger at the start of the next {0} enemy
	# turns after deployment.
	if spawned.skill.get("name", "") == "Quiet!":
		spawned.quiet_triggers_left = UnitSkillsScript.rank_value(
			spawned.skill, unit_level, 0, 1
		)
	units.append(spawned)
	next_unit_id += 1
	last_deployed_unit_id[side] = spawned.id
	_refresh_auras()
	return spawned

func _resolve_warcry(
	actor: Dictionary, target_id: int = -1, target_lane: int = -1
) -> String:
	var skill: Dictionary = actor.get("skill", {})
	var ally_kinds: Array = _ally_target_kinds(skill.get("name", ""))
	var has_other_ally := units.any(
		func(unit): return (
			unit.side == PLAYER and unit.id != actor.id
			and (ally_kinds.is_empty() or unit.kind in ally_kinds)
		)
	)
	if (
		actor.side == PLAYER
		and skill.get("name", "") in ["Empower", "Protect", "Prune", "New Look", "Medic!", "Woolen Blanket"]
		and target_id < 0
		and has_other_ally
	):
		pending_empower_actor_id = actor.id
		return "Choose another allied unit as %s's target." % skill.get("name", "")
	if (
		actor.side == PLAYER and skill.get("name", "") in ["Envenom", "Fireball", "Divine Silence"]
		and target_id < 0 and units.any(func(unit): return unit.side == ENEMY)
	):
		pending_envenom_actor_id = actor.id
		return "Choose a highlighted enemy unit as %s's target." % skill.get("name", "")
	var lane_kinds: Array = _lane_target_kinds(skill.get("name", ""))
	var lane_side := _lane_target_side(skill.get("name", ""))
	if (
		actor.side == PLAYER
		and skill.get("name", "") in ["Demoralize", "Meteor Barrage", "Freeze!", "Royal Flush", "Shadowbind"]
		and target_lane < 0 and units.any(
			func(unit): return (
				unit.side == lane_side
				and (lane_kinds.is_empty() or unit.kind in lane_kinds)
			)
		)
	):
		pending_lane_actor_id = actor.id
		return "Choose one of the highlighted lanes."
	var result: Dictionary = UnitSkillsScript.resolve_warcry(
		actor, units, target_id, battle_simulator.rng, target_lane
	)
	for unit_id in result.affected:
		var target = _unit_by_id(unit_id)
		if target != null:
			board.play_unit_effect(
				target.id, skill.get("name", "WARCRY").to_upper(), Color("#ffd166")
			)
			if skill.get("name", "") in [
				"Bolt", "Heaven's Wrath", "Plague", "Pin Down", "Sunder Armour",
				"Big Game Hunter", "Contagion", "Meteor Barrage", "Freeze!", "Fireball"
			]:
				battle_audio.play("mage")
				await board.animate_hit(target.id, _animation_duration(0.16))
			elif skill.get("name", "") in [
				"Fortify", "Empower", "Mend", "Protect", "Warrior's Vigour",
				"Prune", "New Look", "Medic!", "Guard", "Sun Festival", "Royal Flush",
				"Summon Forth", "Woolen Blanket"
			]:
				battle_audio.play("status")
				await board.animate_heal(actor.id, target.id, _animation_duration(0.24))
			elif skill.get("name", "") in [
				"Envenom", "Demoralize", "Punish", "Misfortune", "Divine Silence",
				"Shadowbind"
			]:
				battle_audio.play("status")
	if not result.message.is_empty():
		_log_action("%s [WARCRY · %s] %s" % [
			actor.name, skill.get("name", "Unknown"), result.message
		])
	await _animate_defeated_units()
	_remove_defeated()
	_refresh_auras()
	return result.message

## Eligible allied classes for unit-targeted Warcries. An empty list means any
## other allied unit is a valid target.
func _ally_target_kinds(skill_name: String) -> Array:
	match skill_name:
		"Prune":
			return ["Lifebinder", "Channeler"]
		"New Look":
			return ["Strider", "Artillerist"]
		"Medic!":
			return ["Duelist", "Warden"]
	return []

## Eligible enemy classes for lane-targeted Warcries. An empty list means any
## enemy unit makes its lane a valid target.
func _lane_target_kinds(skill_name: String) -> Array:
	if skill_name == "Demoralize":
		return ["Duelist", "Strider", "Warden"]
	if skill_name == "Freeze!":
		return ["Strider", "Duelist"]
	return []

## Side whose units make a lane a valid target for a lane-targeted Warcry.
## Royal Flush buffs allies; the other lane Warcries target enemies.
func _lane_target_side(skill_name: String) -> int:
	return PLAYER if skill_name == "Royal Flush" else ENEMY

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
	if (
		pending_empower_actor_id >= 0 or pending_envenom_actor_id >= 0
		or pending_lane_actor_id >= 0
	):
		status_message = "Choose the highlighted Warcry target before resolving."
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
	await _resolve_chants(PLAYER, "end")
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
	await _resolve_chants(ENEMY)
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
		battle_simulator.record("deploy", {
			"side": ENEMY, "unit_id": spawned.id, "card": card.name, "row": row
		})
		enemy_energy -= card.cost
		var hand_index: int = enemy_hand.find(card)
		if hand_index >= 0:
			enemy_hand.remove_at(hand_index)
			status_message = "Enemy deployed %s to lane %d." % [card.name, row + 1]
			_refresh()
			battle_audio.play("deploy")
			await board.animate_unit_move(spawned.id, row, COLS, _animation_duration(0.32))
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
	await _resolve_chants(ENEMY, "end")
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
	await _resolve_chants(PLAYER)
	input_enabled = true
	status_message = "Select a card or resolve the board as it stands."
	_refresh()

func _enemy_reposition_units() -> void:
	var enemy_ids: Array = units.filter(func(unit): return unit.side == ENEMY).map(func(unit): return unit.id)
	for unit_id in enemy_ids:
		var unit = _unit_by_id(unit_id)
		if (
			unit == null
			or BattleRulesScript.is_taunted(unit, units)
			or BattleRulesScript.is_immobilized(unit)
		):
			continue
		var best_row: int = BattleAIScript.choose_reposition(unit, units)
		if best_row != unit.row:
			var old_row: int = unit.row
			var old_col: int = unit.col
			unit.row = best_row
			battle_simulator.record("reposition", {
				"unit_id": unit.id, "from_row": old_row, "to_row": best_row
			})
			status_message = "%s shifts from lane %d to lane %d." % [unit.name, old_row + 1, best_row + 1]
			_refresh()
			battle_audio.play("move")
			await board.animate_unit_move(unit.id, old_row, old_col, _animation_duration(0.24))
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
	var acting_ids: Array = battle_simulator.activation_order(side, units)

	for id in acting_ids:
		var actor = _unit_by_id(id)
		if actor == null or actor.side != side:
			continue
		battle_simulator.record("activation_started", {
			"side": side,
			"unit_id": actor.id,
			"plan": battle_simulator.plan_activation(actor.id, units)
		})
		await _activate_unit(actor)
		battle_simulator.record("state_snapshot", {
			"units": units.duplicate(true),
			"player_hp": player_hp,
			"enemy_hp": enemy_hp,
			"player_shield": player_shield,
			"enemy_shield": enemy_shield
		})
		_remove_defeated()
		_refresh()
		if player_hp <= 0 or enemy_hp <= 0:
			return
		await _wait(0.32)

func _resolution_preview(side: int) -> String:
	var preview: Dictionary = battle_simulator.preview_side(side, units)
	if preview.order.is_empty():
		return "UPCOMING · No ready units."
	var entries: Array[String] = []
	for index in preview.visible.size():
		var plan: Dictionary = preview.visible[index]
		var unit = _unit_by_id(plan.actor_id)
		var move_count: int = plan.movement.size()
		var attack_count: int = plan.strikes if plan.target_id >= 0 or plan.commander_side >= 0 else 0
		entries.append("%d %s M%d→A%d" % [index + 1, unit.name, move_count, attack_count])
	if preview.remaining > 0:
		entries.append("+%d more (see LOG)" % preview.remaining)
	return "UPCOMING · " + "  |  ".join(entries)

## Battle status and log lines identify units by name only; class and skill
## brackets made the messages too long to read at a glance.
func _actor_tag(actor: Dictionary) -> String:
	return actor.name

func _activate_unit(actor: Dictionary) -> void:
	if actor.kind == "Lifebinder":
		var healing_target = _lowest_health_ally(actor)
		if healing_target != null:
			battle_audio.play("heal")
			await board.animate_heal(actor.id, healing_target.id, _animation_duration(0.30))
			BattleSimulatorScript.apply_unit_healing(healing_target, 2, true)
			status_message = "%s heals %s for 2 HP." % [_actor_tag(actor), healing_target.name]
			board.play_unit_effect(healing_target.id, "+2 HP", Color("#70e0a1"))
			_refresh()
			await _wait(0.22)

	var path: Array = BattleRulesScript.traversal_cells(actor, units)
	if not path.is_empty():
		var old_row: int = actor.row
		var old_col: int = actor.col
		actor.col = path[-1].x
		battle_simulator.record("move", {
			"unit_id": actor.id,
			"from_col": old_col,
			"to_col": actor.col,
			"row": actor.row
		})
		status_message = "%s advances %d space%s." % [
			_actor_tag(actor), path.size(), "" if path.size() == 1 else "s"
		]
		_refresh()
		battle_audio.play("move")
		await board.animate_unit_move(actor.id, old_row, old_col, _animation_duration(0.30))
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
			_play_attack_sound(actor.kind)
			await board.animate_attack(actor.id, target.id, actor.kind, _animation_duration(0.24))
			var damage_result: Dictionary = BattleSimulatorScript.apply_unit_damage(
				target, actor.atk, actor
			)
			var damage_dealt: int = damage_result.damage
			var was_protected: bool = damage_result.get("protected", false)
			var immunity: String = damage_result.get("immunity", "")
			battle_simulator.record("attack", {
				"actor_id": actor.id,
				"target_id": target.id,
				"damage": damage_dealt,
				"target_hp": target.hp
			})
			if was_protected:
				status_message = "%s's attack on %s is blocked by Protect." % [
					_actor_tag(actor), target.name
				]
			elif not immunity.is_empty():
				status_message = "%s's attack on %s is blocked by %s." % [
					_actor_tag(actor), target.name,
					"Summon Forth" if immunity == "summon_forth" else "Quiet!"
				]
			else:
				status_message = "%s hits %s for %d." % [
					_actor_tag(actor), target.name, damage_dealt
				]
			var impact_label := "-%d" % damage_dealt
			var impact_color := Color("#ff668f")
			if was_protected:
				impact_label = "PROTECTED"
				impact_color = Color("#71e6f5")
			elif not immunity.is_empty():
				impact_label = "IMMUNE"
				impact_color = Color("#a8b8ff")
			elif actor.kind == "Channeler":
				impact_label += " BLAST"
				impact_color = Color("#c99cff")
			elif actor.kind == "Artillerist":
				impact_label += " PIERCE"
				impact_color = Color("#ffd166")
			board.play_unit_effect(target.id, impact_label, impact_color)
			var secondary_hits: Array = _apply_special_damage(actor, target)
			battle_audio.play("hit")
			await board.animate_hit(target.id, _animation_duration(0.18))
			for secondary_id in secondary_hits:
				battle_audio.play("hit")
				await board.animate_hit(secondary_id, _animation_duration(0.14))
			if actor.kind == "Warden" and target.hp > 0:
				BattleRulesScript.apply_taunt(target)
				status_message += " Taunting Strike locks %s for 2 turns." % target.name
				battle_audio.play("status")
				if not was_protected:
					board.play_unit_effect(target.id, "TAUNT 2", Color("#ff9d66"))
			var strike_result: Dictionary = UnitSkillsScript.resolve_strike(
				actor, target, units, battle_simulator.rng.randf()
			)
			if not strike_result.message.is_empty():
				status_message += " " + strike_result.message
				battle_audio.play("status")
				var strike_name: String = actor.get("skill", {}).get("name", "")
				var strike_label := "IMMOBILISED"
				var strike_color := Color("#ffd166")
				match strike_name:
					"Poison Strike":
						strike_label = "POISONED"
						strike_color = Color("#8ee36b")
					"Weakening Strike", "Heartful Brother":
						strike_label = "-ATK"
						strike_color = Color("#ff9d66")
					"Caber Toss", "Slash Speed":
						strike_label = "KNOCKBACK"
					"Cannon Barrage":
						strike_label = "BARRAGE"
					"Pincer Drain":
						strike_label = "DRAIN"
					"Trisha's Prospect":
						strike_label = "PROTECT"
						strike_color = Color("#71e6f5")
					"Hurtful Brother":
						strike_label = "+HP"
						strike_color = Color("#8ee36b")
				if not was_protected:
					board.play_unit_effect(target.id, strike_label, strike_color)
			for moved in strike_result.get("moved", []):
				await board.animate_unit_move(
					moved.id, moved.row, moved.from_col, _animation_duration(0.2)
				)
			var reaction_result: Dictionary = UnitSkillsScript.resolve_reaction(
				target, actor, units, battle_simulator.rng.randf()
			)
			if not reaction_result.message.is_empty():
				status_message += " " + reaction_result.message
				var reaction_name: String = target.get("skill", {}).get("name", "")
				var buff_reactions := [
					"Shield Wall", "Grit", "Ambient Pressure", "Tide Turn", "Yield!", "Tag-Team"
				]
				battle_audio.play("status" if reaction_name in buff_reactions else "hit")
				var reaction_label := "COUNTER"
				var reaction_color := Color("#ff8b9f")
				match reaction_name:
					"Shield Wall":
						reaction_label = "PROTECT"
						reaction_color = Color("#71e6f5")
					"Grit":
						reaction_label = "REGEN"
						reaction_color = Color("#8ee36b")
					"Ambient Pressure", "Tag-Team":
						reaction_label = "+ATK"
						reaction_color = Color("#ffd166")
					"Tide Turn":
						reaction_label = "TAUNT"
						reaction_color = Color("#ff9d66")
					"Yield!":
						reaction_label = "KNOCKBACK"
						reaction_color = Color("#ffd166")
				for reaction_id in reaction_result.affected:
					var reaction_target = _unit_by_id(reaction_id)
					if reaction_target == null:
						continue
					if reaction_name == "Shield Wall" and was_protected:
						continue
					board.play_unit_effect(
						reaction_target.id, reaction_label, reaction_color
					)
					if reaction_name not in buff_reactions:
						await board.animate_hit(
							reaction_target.id, _animation_duration(0.14)
						)
			for moved in reaction_result.get("moved", []):
				await board.animate_unit_move(
					moved.id, moved.row, moved.from_col, _animation_duration(0.2)
				)
			# A Summon Forth-immune defender retaliates once per blocked hit,
			# animated like Hopping Mad's counter.
			if immunity == "summon_forth":
				var summon_result: Dictionary = UnitSkillsScript.resolve_summon_forth(
					target, actor, units, battle_simulator.rng
				)
				if not summon_result.message.is_empty():
					status_message += " " + summon_result.message
					for summon_id in summon_result.affected:
						var summon_target = _unit_by_id(summon_id)
						if summon_target == null:
							continue
						battle_audio.play("hit")
						board.play_unit_effect(
							summon_target.id, "COUNTER", Color("#ff8b9f")
						)
						await board.animate_hit(
							summon_target.id, _animation_duration(0.14)
						)
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
			_play_attack_sound(actor.kind)
			await board.animate_commander_attack(
				actor.id, commander_side, actor.kind, _animation_duration(0.25)
			)
			var dealt := _damage_captain(commander_side, actor.atk)
			battle_simulator.record("commander_attack", {
				"actor_id": actor.id,
				"side": commander_side,
				"damage": dealt,
				"captain_hp": enemy_hp if commander_side == ENEMY else player_hp
			})
			total_dealt += dealt
			status_message = "%s hits %s Commander for %d." % [
				_actor_tag(actor), "the enemy" if actor.side == PLAYER else "your", dealt
			]
			_refresh()
			battle_audio.play("commander")
			board.shake(8.0)
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
				var blast_result: Dictionary = BattleSimulatorScript.apply_unit_damage(
					other, splash_damage, actor
				)
				affected_ids.append(other.id)
				if blast_result.get("protected", false):
					board.play_unit_effect(other.id, "PROTECTED", Color("#71e6f5"))
				elif not String(blast_result.get("immunity", "")).is_empty():
					board.play_unit_effect(other.id, "IMMUNE", Color("#a8b8ff"))
				else:
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
				var pierce_result: Dictionary = BattleSimulatorScript.apply_unit_damage(
					other, actor.atk, actor
				)
				if pierce_result.get("protected", false):
					board.play_unit_effect(other.id, "PROTECTED", Color("#71e6f5"))
				elif not String(pierce_result.get("immunity", "")).is_empty():
					board.play_unit_effect(other.id, "IMMUNE", Color("#a8b8ff"))
				else:
					pierced.append(other.name)
					board.play_unit_effect(other.id, "-%d PIERCE" % actor.atk, Color("#ffd166"))
				affected_ids.append(other.id)
		if not pierced.is_empty():
			status_message += " Piercing Shot also hits %s." % ", ".join(pierced)
	return affected_ids

func _animate_defeated_units() -> void:
	var defeated_ids: Array = units.filter(
		func(unit): return unit.hp <= 0
	).map(func(unit): return unit.id)
	for unit_id in defeated_ids:
		battle_simulator.record("unit_defeated", {"unit_id": unit_id})
		battle_audio.play("defeat")
		await board.animate_defeat(unit_id, _animation_duration(0.26))

func _find_target(actor: Dictionary):
	return BattleSimulatorScript.find_target(actor, units)

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
	return BattleRulesScript.commander_in_range(actor) and _find_target(actor) == null

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
	_refresh_auras()

## Recomputes aura buffs and logs every gain and loss so aura swings show up
## in the combat log and are recorded into replays.
func _refresh_auras() -> void:
	var events: Array = []
	UnitSkillsScript.refresh_auras(units, events)
	for event in events:
		var unit = _unit_by_id(event.unit_id)
		if unit == null:
			continue
		var delta: int = event.delta
		var stat: String = event.get("stat", "HP")
		if delta > 0:
			_log_action("%s gains +%d %s from %s." % [unit.name, delta, stat, event.label])
		else:
			_log_action("%s loses %d %s as %s fades." % [unit.name, -delta, stat, event.label])

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
		battle_audio.play("shield")
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
		battle_audio.play("commander")
		board.shake(8.0)
		board.play_commander_effect(target_side, "-%d HP" % dealt, Color("#ff668f"))

	for unit_id in result.affected:
		var target = _unit_by_id(unit_id)
		if target != null:
			board.play_unit_effect(target.id, "SKILL", Color("#ffd166") if side == PLAYER else Color("#ff8b9f"))
			if skill_name in ["Lightning Burst", "Firestorm"]:
				battle_audio.play("hit")
				await board.animate_hit(target.id, _animation_duration(0.16))
			else:
				battle_audio.play("status")
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

func _resolve_chants(side: int, phase: String = "start") -> void:
	if phase == "start":
		for result in UnitSkillsScript.resolve_start_statuses(side, units):
			if not result.get("message", "").is_empty():
				status_message = result.message
				_log_action("[%s STATUS] %s" % [
					"ALLY" if side == PLAYER else "ENEMY", result.message
				])
			for unit_id in result.get("affected", []):
				var target = _unit_by_id(unit_id)
				if target != null:
					board.play_unit_effect(
						target.id, result.get("label", "POISON"), Color("#8ee36b")
					)
	for result in UnitSkillsScript.resolve_chants(
		side, units, phase, battle_simulator.rng, -1.0,
		int(last_deployed_unit_id.get(side, -1))
	):
		if not result.get("message", "").is_empty():
			status_message = result.message
			_log_action("[%s CHANT] %s" % ["ALLY" if side == PLAYER else "ENEMY", result.message])
		var sound: String = result.get("sound", "")
		if not sound.is_empty():
			battle_audio.play(sound)
		for unit_id in result.get("affected", []):
			var target = _unit_by_id(unit_id)
			if target != null:
				board.play_unit_effect(target.id, "CHANT", Color("#ffd166"))
		for moved in result.get("moved", []):
			await board.animate_unit_move(
				moved.id, moved.row, moved.from_col, _animation_duration(0.2)
			)
	await _animate_defeated_units()
	_remove_defeated()
	_refresh_auras()

func _damage_captain(side: int, damage: int) -> int:
	var state := {
		"player_hp": player_hp,
		"enemy_hp": enemy_hp,
		"player_shield": player_shield,
		"enemy_shield": enemy_shield
	}
	var result: Dictionary = BattleSimulatorScript.apply_captain_damage(side, damage, state)
	player_hp = state.player_hp
	enemy_hp = state.enemy_hp
	player_shield = state.player_shield
	enemy_shield = state.enemy_shield
	if result.shield_absorbed > 0:
		battle_audio.play("shield")
	return result.damage

func _on_result_primary() -> void:
	if awaiting_next_encounter:
		awaiting_next_encounter = false
		current_encounter_index += 1
		_start_new_match()
	elif mission_finished:
		_show_main_menu()
	else:
		_start_new_match()

func _continue_campaign() -> void:
	var next_mission_id := current_mission_id + 1
	if (
		not mission_finished
		or next_mission_id < 0
		or next_mission_id >= CampaignStoreScript.MISSIONS.size()
		or not CampaignStoreScript.is_available(next_mission_id, completed_missions)
	):
		return
	overlay.visible = false
	result_continue_button.visible = false
	mission_finished = false
	_prepare_mission(next_mission_id)

func _check_game_over() -> bool:
	if player_hp > 0 and enemy_hp > 0:
		return false
	battle_over = true
	input_enabled = false
	end_button.visible = false
	battle_simulator.record("battle_finished", {
		"winner": PLAYER if enemy_hp <= 0 else ENEMY,
		"player_hp": player_hp,
		"enemy_hp": enemy_hp
	})
	var replay_metadata := {
		"mission_id": current_mission_id,
		"encounter_index": current_encounter_index
	}
	battle_simulator.save_replay(REPLAY_PATH, replay_metadata)
	battle_simulator.archive_replay(REPLAY_HISTORY_PATH, replay_metadata)
	overlay.visible = true
	reward_reveal.visible = false
	result_continue_button.visible = false
	result_menu_button.visible = false
	if enemy_hp <= 0:
		battle_audio.play("victory")
		if campaign_battle:
			var encounter_count := CampaignStoreScript.encounter_count(current_mission_id)
			if current_encounter_index + 1 < encounter_count:
				awaiting_next_encounter = true
				mission_run_captain_hp = player_hp
				MissionRunStoreScript.save_run(current_mission_id, current_encounter_index + 1, mission_run_captain_hp)
				var next_encounter: Dictionary = CampaignStoreScript.encounter(current_mission_id, current_encounter_index + 1)
				overlay_title.text = "FIELD SECURED"
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
			recent_reward_name = reward
			_show_card_reward(reward, not was_unlocked)
		overlay_title.text = (
			"OPERATION COMPLETE" if campaign_battle
			else "TACTICAL VICTORY"
		)
		overlay_title.add_theme_color_override("font_color", Color("#67e6f4"))
		overlay_detail.text = (
			"%s\nVictory achieved in %d rounds."
			% [
				CampaignStoreScript.MISSIONS[current_mission_id].debriefing,
				round_number
			]
			if campaign_battle
			else "Victory achieved in %d rounds." % round_number
		)
		result_primary_button.text = "RETURN TO MENU" if campaign_battle else "PLAY AGAIN"
		result_continue_button.visible = (
			campaign_battle
			and current_mission_id + 1 < CampaignStoreScript.MISSIONS.size()
		)
		result_menu_button.visible = not campaign_battle
	else:
		if campaign_battle:
			MissionRunStoreScript.clear_run()
		overlay_title.text = "LINE BROKEN"
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
