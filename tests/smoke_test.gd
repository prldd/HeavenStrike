extends SceneTree

const UnitCatalogScript = preload("res://scripts/unit_catalog.gd")
const BattleSimulatorScript = preload("res://scripts/battle_simulator.gd")
const BattleResultsScript = preload("res://scripts/battle_results.gd")
const BattleAIScript = preload("res://scripts/battle_ai.gd")
const SquadStoreScript = preload("res://scripts/squad_store.gd")
const CampaignStoreScript = preload("res://scripts/campaign_store.gd")
const BattleRulesScript = preload("res://scripts/battle_rules.gd")
const ConductorSkillsScript = preload("res://scripts/conductor_skills.gd")
const UnitSkillsScript = preload("res://scripts/unit_skills.gd")
const KineticCrucibleScript = preload("res://scripts/kinetic_crucible.gd")
const StoryDialogueCatalogScript = preload("res://scripts/story_dialogue_catalog.gd")
const MissionRunStoreScript = preload("res://scripts/mission_run_store.gd")

func _init() -> void:
	var roster: Array = UnitCatalogScript.all_units()
	assert(roster.size() == 210, "The playable roster must contain 210 units.")
	assert(UnitCatalogScript.by_name("Trinity Rusher").kind == "Strider")
	assert(UnitCatalogScript.display_class("Strider") == "Scout")
	assert(UnitCatalogScript.display_class("Lifebinder") == "Priest")
	assert(UnitCatalogScript.class_color("Strider") != UnitCatalogScript.class_color("Duelist"))
	assert(UnitCatalogScript.class_color("Warden") != UnitCatalogScript.class_color("Lifebinder"))
	assert(UnitCatalogScript.by_name("Missing") == null)
	var retired_rank_word := "Cap" + "tain"
	assert(roster.all(func(unit): return retired_rank_word.to_lower() not in unit.name.to_lower()))
	assert(UnitCatalogScript.canonical_name(retired_rank_word + " Kerryson") == "Conductor Kerryson")
	assert(UnitCatalogScript.canonical_name("Commune " + retired_rank_word) == "Commune Conductor")
	assert(UnitCatalogScript.by_name(retired_rank_word + " Basilic").name == "Conductor Basilic")
	assert(SquadStoreScript.sanitize(
		[retired_rank_word + " Kerryson"], roster
	) == ["Conductor Kerryson"])
	var retired_skill_key := retired_rank_word.to_lower() + "_skill"
	var retired_hp_key := retired_rank_word.to_lower() + "_hp"
	var old_player_config := ConfigFile.new()
	old_player_config.set_value("squad", retired_skill_key, "Shield")
	assert(old_player_config.save(SquadStoreScript.SAVE_PATH) == OK)
	assert(SquadStoreScript.load_conductor_skill(ConductorSkillsScript.SKILLS) == "Shield")
	var migrated_player_config := ConfigFile.new()
	assert(migrated_player_config.load(SquadStoreScript.SAVE_PATH) == OK)
	assert(migrated_player_config.get_value("squad", "conductor_skill", "") == "Shield")
	assert(not migrated_player_config.has_section_key("squad", retired_skill_key))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(SquadStoreScript.SAVE_PATH))
	var old_run_config := ConfigFile.new()
	old_run_config.set_value("run", "mission_id", 2)
	old_run_config.set_value("run", "encounter_index", 1)
	old_run_config.set_value("run", retired_hp_key, 13)
	assert(old_run_config.save(MissionRunStoreScript.SAVE_PATH) == OK)
	var migrated_run := MissionRunStoreScript.load_run(77)
	assert(migrated_run.conductor_hp == 13)
	var migrated_run_config := ConfigFile.new()
	assert(migrated_run_config.load(MissionRunStoreScript.SAVE_PATH) == OK)
	assert(migrated_run_config.get_value("run", "conductor_hp", 0) == 13)
	assert(not migrated_run_config.has_section_key("run", retired_hp_key))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(MissionRunStoreScript.SAVE_PATH))
	var old_campaign_config := ConfigFile.new()
	old_campaign_config.set_value("campaign", "reward_units", [
		retired_rank_word + " Kerryson", "Commune " + retired_rank_word
	])
	assert(old_campaign_config.save(CampaignStoreScript.SAVE_PATH) == OK)
	assert(CampaignStoreScript.load_reward_units(roster) == [
		"Conductor Kerryson", "Commune Conductor"
	])
	DirAccess.remove_absolute(ProjectSettings.globalize_path(CampaignStoreScript.SAVE_PATH))
	var old_crucible_config := ConfigFile.new()
	old_crucible_config.set_value("meta", "instances_migrated", true)
	old_crucible_config.set_value("collection", "next_id", 2)
	old_crucible_config.set_value("collection", "instances", [{
		"id": "unit_000001", "name": retired_rank_word + " Basilic",
		"level": 2, "points": 1, "consumed": false
	}])
	assert(old_crucible_config.save(KineticCrucibleScript.SAVE_PATH) == OK)
	var migrated_instances := KineticCrucibleScript.sync_instances(
		roster, {"Conductor Basilic": 1}
	)
	assert(migrated_instances.size() == 1)
	assert(migrated_instances[0].name == "Conductor Basilic")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(KineticCrucibleScript.SAVE_PATH))
	assert(KineticCrucibleScript.LEVEL_COSTS == [3, 6, 12, 24])
	assert(KineticCrucibleScript.apply_points(
		{"level": 1, "points": 0}, 2
	) == {"level": 1, "points": 2})
	assert(KineticCrucibleScript.apply_points(
		{"level": 1, "points": 2}, 1
	) == {"level": 2, "points": 0})
	assert(KineticCrucibleScript.apply_points(
		{"level": 1, "points": 0}, 45
	) == {"level": 5, "points": 0})
	assert(KineticCrucibleScript.merge_value(
		{"name": "A", "kind": "Warden"}, {"name": "B", "kind": "Strider"}
	) == 1)
	assert(KineticCrucibleScript.merge_value(
		{"name": "A", "kind": "Warden"}, {"name": "B", "kind": "Warden"}
	) == 2)
	assert(KineticCrucibleScript.merge_value(
		{"name": "A", "kind": "Warden"}, {"name": "A", "kind": "Warden"}
	) == 5)
	var instance_copies: Array = [
		{"id": "copy_a", "name": "Trinity Rusher", "level": 3, "points": 1, "consumed": false},
		{"id": "copy_b", "name": "Trinity Rusher", "level": 1, "points": 0, "consumed": false},
		{"id": "copy_c", "name": "Pub Bouncer", "level": 2, "points": 0, "consumed": false}
	]
	assert(KineticCrucibleScript.active_instances(instance_copies).size() == 3)
	assert(KineticCrucibleScript.inventory_counts(instance_copies)["Trinity Rusher"] == 2)
	var reserve_instances: Array = [
		{"id": "unit_000004", "name": "Order Pupil", "level": 2, "points": 0, "consumed": false},
		{"id": "unit_000002", "name": "LDF Bowgunner", "level": 1, "points": 0, "consumed": false},
		{"id": "unit_000007", "name": "Order Pupil", "level": 5, "points": 0, "consumed": false},
		{"id": "unit_000001", "name": "Trinity Rusher", "level": 1, "points": 0, "consumed": false},
		{"id": "unit_000005", "name": "Order Scholar", "level": 1, "points": 0, "consumed": false},
		{"id": "unit_000006", "name": "Order Pupil", "level": 5, "points": 0, "consumed": false},
		{"id": "unit_000003", "name": "LDF Bolt Slinger", "level": 1, "points": 0, "consumed": false}
	]
	var sorted_reserves := KineticCrucibleScript.sort_reserves(reserve_instances, roster)
	assert(sorted_reserves.map(func(instance): return instance.id) == [
		"unit_000001", # Strider class group first
		"unit_000003", # Artillerist tree: promoted 3-star before 2-star base
		"unit_000002",
		"unit_000005", # Channeler tree: promoted 3-star before base copies
		"unit_000007", # same unit: level 5 before level 2, id descending on ties
		"unit_000006",
		"unit_000004"
	])
	assert(KineticCrucibleScript.can_merge(
		instance_copies[0], instance_copies[1], roster, true, instance_copies
	))
	assert(not KineticCrucibleScript.can_merge(
		instance_copies[0], instance_copies[2], roster, true, instance_copies
	))
	assert(SquadStoreScript.sanitize_instances(
		["copy_a", "copy_b", "copy_c"], instance_copies
	) == ["copy_a", "copy_b", "copy_c"])
	var instance_deck: Array = SquadStoreScript.build_deck(
		["copy_a", "copy_b", "copy_c"], roster, instance_copies
	)
	assert(instance_deck.size() == 3)
	assert(instance_deck[0].instance_id == "copy_a")
	assert(instance_deck[0].level == 3)
	var simulator := BattleSimulatorScript.new()
	simulator.reset(4242)
	assert(simulator.seed_value == 4242)
	assert(simulator.record("test", {"value": 7}).sequence == 1)
	assert(simulator.replay_data().events.size() == 1)
	assert(simulator.replay_data().seed == 4242)
	var battle_rating := BattleResultsScript.calculate(
		15, 20, 4,
		[
			{"id": 1, "side": 0, "hp": 3},
			{"id": 3, "side": 0, "hp": 2},
			{"id": 9, "side": 1, "hp": 1}
		],
		[
			{"type": "deploy", "side": 0, "unit_id": 1},
			{"type": "deploy", "side": 0, "unit_id": 2},
			{"type": "deploy", "side": 0, "unit_id": 3},
			{"type": "deploy", "side": 1, "unit_id": 9}
		]
	)
	assert(battle_rating.score == 817)
	assert(battle_rating.rating == 9)
	assert(battle_rating.word == "AMAZING")
	assert(battle_rating.survivors == 2 and battle_rating.deployed == 3)
	var flawless_rating := BattleResultsScript.calculate(20, 20, 1, [], [])
	assert(flawless_rating.score == 1000)
	assert(flawless_rating.rating == 10)
	assert(flawless_rating.word == "FLAWLESS")
	var replay_history_path := "user://smoke_replay_history.json"
	for replay_seed in range(12):
		simulator.reset(replay_seed)
		simulator.record("test", {"seed": replay_seed})
		assert(simulator.archive_replay(replay_history_path))
	var replay_history := BattleSimulatorScript.load_replay_history(replay_history_path)
	assert(replay_history.size() == 10)
	assert(replay_history[0].seed == 11)
	assert(replay_history[9].seed == 2)
	var damage_target := {"id": 99, "hp": 5, "max_hp": 5}
	assert(BattleSimulatorScript.apply_unit_damage(damage_target, 3).after == 2)
	assert(BattleSimulatorScript.apply_unit_healing(damage_target, 2).after == 4)
	var conductor_state := {
		"player_hp": 20, "enemy_hp": 20,
		"player_shield": 2, "enemy_shield": 0
	}
	var conductor_hit := BattleSimulatorScript.apply_conductor_damage(
		0, 5, conductor_state
	)
	assert(conductor_hit.shield_absorbed == 2)
	assert(conductor_state.player_hp == 17)
	assert(roster.map(func(unit): return unit.icon).all(
		func(icon_id): return icon_id >= 1 and icon_id <= 215
	))
	assert(roster.filter(func(unit): return unit.stars == 1).size() == 15)
	assert(roster.filter(func(unit): return unit.stars == 2).size() == 17)
	assert(roster.filter(func(unit): return unit.stars == 3).size() == 39)
	assert(roster.filter(func(unit): return unit.stars == 4).size() == 52)
	assert(roster.filter(func(unit): return unit.stars == 5).size() == 61)
	assert(roster.filter(func(unit): return unit.stars == 6).size() == 26)
	var icon_ids: Array = roster.map(func(unit): return unit.icon)
	var unique_icon_ids: Array = []
	for icon_id in icon_ids:
		if icon_id not in unique_icon_ids:
			unique_icon_ids.append(icon_id)
	assert(icon_ids.size() == unique_icon_ids.size())
	assert(roster.filter(func(unit): return unit.kind == "Strider").size() == 29)
	assert(roster.filter(func(unit): return unit.kind == "Duelist").size() == 31)
	assert(roster.filter(func(unit): return unit.kind == "Warden").size() == 37)
	assert(roster.filter(func(unit): return unit.kind == "Artillerist").size() == 32)
	assert(roster.filter(func(unit): return unit.kind == "Channeler").size() == 39)
	assert(roster.filter(func(unit): return unit.kind == "Lifebinder").size() == 42)
	assert(UnitCatalogScript.by_name("Apprentice Builder").stars == 2)
	assert(UnitCatalogScript.by_name("Rage Brute").cost == 2)
	assert(UnitCatalogScript.by_name("LDF Gunner").range == 3)
	assert(UnitCatalogScript.by_name("Apprentice Builder").skill.name == "Fortify")
	assert(UnitCatalogScript.by_name("Claw Skirmisher").skill.type == "Strike")
	assert(UnitCatalogScript.by_name("Order Apostle").skill.name == "Heaven's Wrath")
	assert(UnitCatalogScript.by_name("Trinity Messenger").skill.name == "Bolt")
	assert(UnitCatalogScript.by_name("Minerva the Brave").skill.name == "Fortify")
	assert(UnitCatalogScript.by_name("Naruku the Lookout").skill.name == "Empower")
	assert(UnitCatalogScript.by_name("Whirling Ragnr").skill.name == "Bolt")
	assert(UnitCatalogScript.by_name("Master Builder").promotion_of == "Apprentice Builder")
	assert(UnitCatalogScript.by_name("Claw Ambusher").skill.name == "Pinning Strike")
	assert(UnitCatalogScript.by_name("Order Missionary").skill.name == "Heaven's Wrath")
	assert(UnitCatalogScript.by_name("Farsight Naruku").skill.name == "Empower")
	assert(UnitCatalogScript.by_name("Macewielder Ragnr").stars == 5)
	assert(UnitCatalogScript.by_name("Talon Scratcher").skill.name == "Pinning Slice")
	assert(UnitCatalogScript.by_name("Talon Slasher").promotion_of == "Talon Scratcher")
	assert(UnitCatalogScript.by_name("Innocent Gretel").kind == "Artillerist")
	assert(UnitCatalogScript.by_name("Witchkiller Gretel").hp == 7)
	assert(UnitCatalogScript.by_name("Talon Slicer").promotion_of == "Talon Slasher")
	assert(UnitCatalogScript.by_name("Street Urchin").skill.name == "Misfortune")
	assert(UnitCatalogScript.by_name("Street Hoodlum").promotion_of == "Street Urchin")
	assert(UnitCatalogScript.by_name("LDF Crowd Mage").stars == 2)
	assert(UnitCatalogScript.by_name("LDF Riot Mage").promotion_of == "LDF Crowd Mage")
	assert(UnitCatalogScript.by_name("Fortune Teller").kind == "Channeler")
	assert(UnitCatalogScript.by_name("Fortune Diviner").hp == 7)
	assert(UnitCatalogScript.by_name("Street Nurse").skill.name == "Mend")
	assert(UnitCatalogScript.by_name("Kerryson the Stoic").atk == 4)
	assert(UnitCatalogScript.by_name("Blight Doctor").skill.name == "Plague")
	assert(UnitCatalogScript.by_name("Dart Shooter").skill.name == "Envenom")
	assert(UnitCatalogScript.by_name("Lizard-Licker Keru").promotion_of == "Frog-Hopper Keru")
	assert(UnitCatalogScript.by_name("Toxic Shot").stars == 5)
	assert(UnitCatalogScript.by_name("Garrett Talon").skill.name == "Pin Down")
	assert(UnitCatalogScript.by_name("Garrett the Raider").promotion_of == "Garrett the Claw")
	assert(UnitCatalogScript.by_name("Precision Trigger").promotion_of == "Precision Sniper")
	assert(UnitCatalogScript.by_name("Greyson the Shifty").skill.name == "Demoralize")
	assert(UnitCatalogScript.by_name("The Telecommunicator").stars == 5)
	assert(UnitCatalogScript.by_name("Pierrot the Deciever").promotion_of == "Vicious Pierrot")
	assert(UnitCatalogScript.by_name("LDF Flight Officer").skill.name == "Punish")
	assert(UnitCatalogScript.by_name("Prison Guv'nor").promotion_of == "Prison Warden")
	assert(UnitCatalogScript.by_name("The Bard").promotion_of == "Shakespeare")
	assert(UnitCatalogScript.by_name("Claw Chopper").skill.name == "Poison Strike")
	assert(UnitCatalogScript.by_name("LDF Mastersword").skill.name == "Sunder Armour")
	assert(UnitCatalogScript.by_name("Haven Trapper").skill.name == "Big Game Hunter")
	assert(UnitCatalogScript.by_name("Haven Huntsman").promotion_of == "Haven Trapper")
	assert(UnitCatalogScript.by_name("Macabre Embalmer").skill.name == "Contagion")
	assert(UnitCatalogScript.by_name("Macabre Undertaker").promotion_of == "Macabre Embalmer")
	assert(UnitCatalogScript.by_name("Devout Mage").skill.name == "Meteor Barrage")
	assert(UnitCatalogScript.by_name("Devout Warlock").promotion_of == "Devout Mage")
	assert(UnitCatalogScript.by_name("Bartok Loco").skill.name == "Sundering Smash")
	assert(UnitCatalogScript.by_name("Bartok Loco").skill.type == "Chant")
	assert(UnitCatalogScript.by_name("Derailed Bartok").promotion_of == "Bartok Loco")
	assert(UnitCatalogScript.by_name("Geartron Prototype").kind == "Warden")
	assert(UnitCatalogScript.by_name("Geartron-5000").promotion_of == "Geartron Prototype")
	assert(UnitCatalogScript.by_name("Bethany").skill.name == "Hopping Mad")
	assert(UnitCatalogScript.by_name("Bethany").skill.type == "Reaction")
	assert(UnitCatalogScript.by_name("Bunnybot Bethany").promotion_of == "Bethany")
	assert(UnitCatalogScript.by_name("Final Empress").skill.name == "Moonlight")
	assert(UnitCatalogScript.by_name("Final Empress").skill.type == "Aura")
	assert(UnitCatalogScript.by_name("Awoken Final Empress").promotion_of == "Final Empress")
	assert(UnitCatalogScript.by_name("Opelle").kind == "Lifebinder")
	assert(UnitCatalogScript.by_name("Glowing Opelle").promotion_of == "Opelle")
	assert(UnitCatalogScript.by_name("Commune Defender").skill.name == "Shield Wall")
	assert(UnitCatalogScript.by_name("Commune Defender").skill.type == "Reaction")
	assert(UnitCatalogScript.by_name("Commune Conductor").promotion_of == "Commune Defender")
	assert(UnitCatalogScript.by_name("Commune Commander").promotion_of == "Commune Conductor")
	assert(UnitCatalogScript.by_name("Commune Commander").stars == 5)
	assert(UnitCatalogScript.by_name("Frost-Kid Kokori").skill.name == "Freeze!")
	assert(UnitCatalogScript.by_name("Frost-Kid Kokori").skill.type == "Warcry")
	assert(UnitCatalogScript.by_name("Ice-Prince Kokori").promotion_of == "Frost-Kid Kokori")
	assert(UnitCatalogScript.by_name("Mata Swiftblade").skill.name == "Weakening Strike")
	assert(UnitCatalogScript.by_name("Mata Swiftblade").skill.type == "Strike")
	assert(UnitCatalogScript.by_name("Swiftblade Heroine").promotion_of == "Mata Swiftblade")
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Mend"
	).size() == 4)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Plague"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Envenom"
	).size() == 6)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Pin Down"
	).size() == 6)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Demoralize"
	).size() == 6)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Punish"
	).size() == 6)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Poison Strike"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Sunder Armour"
	).size() == 5)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Big Game Hunter"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Contagion"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Meteor Barrage"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Sundering Smash"
	).size() == 4)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Hopping Mad"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Moonlight"
	).size() == 4)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Shield Wall"
	).size() == 3)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Freeze!"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Weakening Strike"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Protect"
	).size() == 4)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Fireball"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Warrior's Vigour"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Grit"
	).size() == 4)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Prune"
	).size() == 3)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Medic!"
	).size() == 4)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "New Look"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Lifestream"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Caber Toss"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Impairing Joust"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Ambient Pressure"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Cannon Barrage"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Guard"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Pincer Drain"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Slash Speed"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Mighty Guard"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Ocean's Reclaim"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Tide Turn"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Yield!"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Galatine's Ground"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Blossom's Bloom"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Sun Festival"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Trisha's Prospect"
	).size() == 4)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Tag-Team"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Hurtful Brother"
	).size() == 1)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Heartful Brother"
	).size() == 1)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Royal Flush"
	).size() == 4)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Hydroblast"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Roguish Snare"
	).size() == 4)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Wrangle"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Cattle of Ra"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Divine Silence"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Stone Gaze"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Summon Forth"
	).size() == 4)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Quiet!"
	).size() == 1)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Woolen Blanket"
	).size() == 6)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Shadowbind"
	).size() == 6)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Inspire Lambkin"
	).size() == 8)
	assert(UnitCatalogScript.by_name("LDF Sergeant").promotion_of == "LDF Constable")
	assert(UnitCatalogScript.by_name("Pompous Joe Wonder").promotion_of == "Joe Wonder")
	assert(UnitCatalogScript.by_name("Blazing Dragon").promotion_of == "Raging Dragon")
	assert(UnitCatalogScript.by_name("Royal Beefeater").promotion_of == "Royal Yeoman")
	assert(UnitCatalogScript.by_name("Pub Landlord").promotion_of == "Pub Barman")
	assert(UnitCatalogScript.by_name("The Biologist").promotion_of == "The Ecologist")
	assert(UnitCatalogScript.by_name("Rescue Paramedic").promotion_of == "Rescue Corps")
	assert(UnitCatalogScript.by_name("The Earth Whisperer").stars == 6)
	assert(UnitCatalogScript.by_name("Sakuya Le Bel Shirogane").promotion_of == "Sakuya (Fantail Pigeon)")
	assert(UnitCatalogScript.by_name("Yuuya Sakazaki").promotion_of == "Yuuya (Fantail Pigeon)")
	assert(UnitCatalogScript.by_name("José Decomposé").promotion_of == "José")
	assert(UnitCatalogScript.by_name("Three of Hearts").skill.name == "Royal Flush")
	assert(UnitCatalogScript.by_name("Three of Hearts").skill.type == "Warcry")
	assert(UnitCatalogScript.by_name("Ace of Hearts").promotion_of == "Three of Hearts")
	assert(UnitCatalogScript.by_name("Ace of Hearts").stars == 5)
	assert(UnitCatalogScript.by_name("Philippa Trot").kind == "Duelist")
	assert(UnitCatalogScript.by_name("Galloping Philippa").promotion_of == "Philippa Trot")
	assert(UnitCatalogScript.by_name("The Aquanaut").skill.name == "Hydroblast")
	assert(UnitCatalogScript.by_name("The Aquanaut").skill.type == "Chant")
	assert(UnitCatalogScript.by_name("The Hydronaut").promotion_of == "The Aquanaut")
	assert(UnitCatalogScript.by_name("The Hydronaut").stars == 6)
	assert(UnitCatalogScript.by_name("Thief").skill.name == "Roguish Snare")
	assert(UnitCatalogScript.by_name("Thief").skill.type == "Chant")
	assert(UnitCatalogScript.by_name("Cutpurse").promotion_of == "Thief")
	assert(UnitCatalogScript.by_name("Present Verdandi").kind == "Lifebinder")
	assert(UnitCatalogScript.by_name("Verdandi Norn").promotion_of == "Present Verdandi")
	assert(UnitCatalogScript.by_name("Frontier Rider").skill.name == "Wrangle")
	assert(UnitCatalogScript.by_name("Frontier Rider").skill.type == "Chant")
	assert(UnitCatalogScript.by_name("Frontier Rider").kind == "Artillerist")
	assert(UnitCatalogScript.by_name("Frontier Protector").promotion_of == "Frontier Rider")
	assert(UnitCatalogScript.by_name("Frontier Protector").stars == 6)
	assert(UnitCatalogScript.by_name("Lunnain Oracle").skill.name == "Divine Silence")
	assert(UnitCatalogScript.by_name("Lunnain Oracle").skill.type == "Warcry")
	assert(UnitCatalogScript.by_name("Lunnain Oracle").kind == "Lifebinder")
	assert(UnitCatalogScript.by_name("Lunnain Divine").promotion_of == "Lunnain Oracle")
	assert(UnitCatalogScript.by_name("Lunnain Divine").stars == 6)
	assert(UnitCatalogScript.by_name("Ra").skill.name == "Cattle of Ra")
	assert(UnitCatalogScript.by_name("Ra").skill.type == "Chant")
	assert(UnitCatalogScript.by_name("Ra").kind == "Warden")
	assert(UnitCatalogScript.by_name("Ra, Creator").promotion_of == "Ra")
	assert(UnitCatalogScript.by_name("Ra, Creator").stars == 6)
	assert(UnitCatalogScript.by_name("Rydia of Mist").skill.name == "Summon Forth")
	assert(UnitCatalogScript.by_name("Rydia of Mist").skill.type == "Warcry")
	assert(UnitCatalogScript.by_name("Rydia of Mist").kind == "Channeler")
	assert(UnitCatalogScript.by_name("Summoner Rydia").promotion_of == "Rydia of Mist")
	assert(UnitCatalogScript.by_name("Summoner Rydia").stars == 6)
	assert(UnitCatalogScript.by_name("Booth").skill.name == "Summon Forth")
	assert(UnitCatalogScript.by_name("Booth").kind == "Artillerist")
	assert(UnitCatalogScript.by_name("Booth Kavar").promotion_of == "Booth")
	assert(UnitCatalogScript.by_name("Booth Kavar").stars == 6)
	assert(UnitCatalogScript.by_name("Medusa").skill.name == "Stone Gaze")
	assert(UnitCatalogScript.by_name("Medusa").skill.type == "Chant")
	assert(UnitCatalogScript.by_name("Medusa").kind == "Channeler")
	assert(UnitCatalogScript.by_name("Gorgon Medusa").promotion_of == "Medusa")
	assert(UnitCatalogScript.by_name("Gorgon Medusa").stars == 6)
	assert(UnitCatalogScript.by_name("Nageki (Mourning Dove)").skill == null)
	assert(UnitCatalogScript.by_name("Nageki (Mourning Dove)").kind == "Lifebinder")
	assert(UnitCatalogScript.by_name("Nageki Fujishiro").skill.name == "Quiet!")
	assert(UnitCatalogScript.by_name("Nageki Fujishiro").skill.type == "Chant")
	assert(UnitCatalogScript.by_name("Nageki Fujishiro").promotion_of == "Nageki (Mourning Dove)")
	assert(UnitCatalogScript.by_name("Nageki Fujishiro").stars == 6)
	assert(UnitCatalogScript.by_name("Jimimi the Shepherd").skill.name == "Woolen Blanket")
	assert(UnitCatalogScript.by_name("Jimimi the Shepherd").skill.type == "Warcry")
	assert(UnitCatalogScript.by_name("Jimimi the Shepherd").kind == "Lifebinder")
	assert(UnitCatalogScript.by_name("Jimimi the Shepherd").stars == 4)
	assert(UnitCatalogScript.by_name("Jimimi the Herder").promotion_of == "Jimimi the Shepherd")
	assert(UnitCatalogScript.by_name("Jimimi the Herder").stars == 5)
	assert(UnitCatalogScript.by_name("Hookie").skill.name == "Woolen Blanket")
	assert(UnitCatalogScript.by_name("Hookie").kind == "Channeler")
	assert(UnitCatalogScript.by_name("Beautifly Hookie").promotion_of == "Hookie")
	assert(UnitCatalogScript.by_name("Beautifly Hookie").stars == 5)
	assert(UnitCatalogScript.by_name("Winter Harding").skill.name == "Woolen Blanket")
	assert(UnitCatalogScript.by_name("Winter Harding").kind == "Warden")
	assert(UnitCatalogScript.by_name("Winter Harding").hp == 9)
	assert(UnitCatalogScript.by_name("Happy Elf Harding").promotion_of == "Winter Harding")
	assert(UnitCatalogScript.by_name("Happy Elf Harding").stars == 5)
	assert(UnitCatalogScript.by_name("Edge").skill.name == "Shadowbind")
	assert(UnitCatalogScript.by_name("Edge").skill.type == "Warcry")
	assert(UnitCatalogScript.by_name("Edge").kind == "Strider")
	assert(UnitCatalogScript.by_name("Edge").stars == 5)
	assert(UnitCatalogScript.by_name("Ninja Edge").promotion_of == "Edge")
	assert(UnitCatalogScript.by_name("Ninja Edge").stars == 6)
	assert(UnitCatalogScript.by_name("Explorer Gatling").skill.name == "Shadowbind")
	assert(UnitCatalogScript.by_name("Explorer Gatling").kind == "Strider")
	assert(UnitCatalogScript.by_name("Raider Gatling").promotion_of == "Explorer Gatling")
	assert(UnitCatalogScript.by_name("Raider Gatling").stars == 6)
	assert(UnitCatalogScript.by_name("Belladonna").skill.name == "Shadowbind")
	assert(UnitCatalogScript.by_name("Belladonna").kind == "Channeler")
	assert(UnitCatalogScript.by_name("The Twilight Queen").promotion_of == "Belladonna")
	assert(UnitCatalogScript.by_name("The Twilight Queen").stars == 6)
	assert(UnitCatalogScript.by_name("The Twilight Queen").atk == 6)
	assert(UnitCatalogScript.by_name("Claw Minstrel").skill.name == "Inspire Lambkin")
	assert(UnitCatalogScript.by_name("Claw Minstrel").skill.type == "Aura")
	assert(UnitCatalogScript.by_name("Claw Minstrel").kind == "Lifebinder")
	assert(UnitCatalogScript.by_name("Claw Minstrel").stars == 2)
	assert(UnitCatalogScript.by_name("Claw Minstrel").cost == 3)
	assert(UnitCatalogScript.by_name("Claw Minstrel").atk == 2)
	assert(UnitCatalogScript.by_name("Claw Minstrel").hp == 3)
	assert(UnitCatalogScript.by_name("Claw Rocker").promotion_of == "Claw Minstrel")
	assert(UnitCatalogScript.by_name("Claw Rocker").stars == 3)
	assert(UnitCatalogScript.by_name("Claw Rocker").hp == 5)
	assert(UnitCatalogScript.by_name("Conjuring Clown").kind == "Channeler")
	assert(UnitCatalogScript.by_name("Conjuring Clown").skill.name == "Inspire Lambkin")
	assert(UnitCatalogScript.by_name("Conjuring Clown").atk == 4)
	assert(UnitCatalogScript.by_name("Conjuring Harlequin").promotion_of == "Conjuring Clown")
	assert(UnitCatalogScript.by_name("Conjuring Harlequin").stars == 4)
	assert(UnitCatalogScript.by_name("Conjuring Jester").promotion_of == "Conjuring Harlequin")
	assert(UnitCatalogScript.by_name("Conjuring Jester").stars == 5)
	assert(UnitCatalogScript.by_name("Conjuring Jester").atk == 6)
	assert(UnitCatalogScript.by_name("Flame Warden").kind == "Lifebinder")
	assert(UnitCatalogScript.by_name("Flame Warden").skill.name == "Inspire Lambkin")
	assert(UnitCatalogScript.by_name("Flame Warden").cost == 2)
	assert(UnitCatalogScript.by_name("Flame Dissident").promotion_of == "Flame Warden")
	assert(UnitCatalogScript.by_name("Flame Dissident").stars == 4)
	assert(UnitCatalogScript.by_name("Flame Schematic").promotion_of == "Flame Dissident")
	assert(UnitCatalogScript.by_name("Flame Schematic").stars == 5)
	assert(UnitCatalogScript.by_name("Flame Schematic").hp == 5)
	# Races are ported from the reference database; units default to human.
	assert(UnitCatalogScript.by_name("Trinity Rusher").race == "human")
	assert(UnitCatalogScript.by_name("Socialite Fencer").race == "human")
	assert(UnitCatalogScript.by_name("Three of Hearts").race == "ogur")
	assert(UnitCatalogScript.by_name("Pub Bouncer").race == "ogur")
	assert(UnitCatalogScript.by_name("Thief").race == "felyne")
	assert(UnitCatalogScript.by_name("Claw Slicer").race == "felyne")
	assert(UnitCatalogScript.by_name("Chain Initiate").race == "lambkin")
	assert(UnitCatalogScript.by_name("Opelle").race == "lambkin")
	assert(UnitCatalogScript.by_name("Thief").to_dict().race == "felyne")
	assert(UnitCatalogScript.by_name("Trinity Rusher").to_dict().race == "human")
	for lambkin_name in [
		"Claw Minstrel", "Claw Rocker", "Conjuring Clown", "Conjuring Harlequin",
		"Conjuring Jester", "Flame Warden", "Flame Dissident", "Flame Schematic"
	]:
		assert(UnitCatalogScript.by_name(lambkin_name).race == "lambkin")
	assert(UnitCatalogScript.art_id(49) == 47)
	assert(UnitCatalogScript.art_id(56) == 58)
	assert(UnitCatalogScript.art_id(27) == 83)
	assert(UnitCatalogScript.art_id(28) == 177)
	assert(UnitCatalogScript.art_id(29) == 423)
	assert(UnitCatalogScript.art_id(39) == 535)
	assert(UnitCatalogScript.art_id(68) == 629)
	assert(UnitCatalogScript.art_id(80) == 488)
	assert(UnitCatalogScript.art_id(87) == 609)
	assert(UnitCatalogScript.art_id(88) == 31)
	assert(UnitCatalogScript.art_id(89) == 32)
	assert(UnitCatalogScript.art_id(90) == 93)
	assert(UnitCatalogScript.art_id(91) == 94)
	assert(UnitCatalogScript.art_id(92) == 81)
	assert(UnitCatalogScript.art_id(93) == 82)
	assert(UnitCatalogScript.art_id(94) == 195)
	assert(UnitCatalogScript.art_id(97) == 290)
	assert(UnitCatalogScript.art_id(98) == 787)
	assert(UnitCatalogScript.art_id(100) == 887)
	assert(UnitCatalogScript.art_id(102) == 1191)
	assert(UnitCatalogScript.art_id(103) == 1192)
	assert(UnitCatalogScript.art_id(104) == 73)
	assert(UnitCatalogScript.art_id(106) == 607)
	assert(UnitCatalogScript.art_id(108) == 142)
	assert(UnitCatalogScript.art_id(110) == 150)
	assert(UnitCatalogScript.art_id(111) == 37)
	assert(UnitCatalogScript.art_id(113) == 97)
	assert(UnitCatalogScript.art_id(115) == 105)
	assert(UnitCatalogScript.art_id(117) == 87)
	assert(UnitCatalogScript.art_id(119) == 61)
	assert(UnitCatalogScript.art_id(133) == 204)
	assert(UnitCatalogScript.art_id(147) == 430)
	assert(UnitCatalogScript.art_id(165) == 1200)
	assert(UnitCatalogScript.art_id(169) == 1026)
	assert(UnitCatalogScript.art_id(171) == 1028)
	assert(UnitCatalogScript.art_id(172) == 325)
	assert(UnitCatalogScript.art_id(173) == 326)
	assert(UnitCatalogScript.art_id(174) == 979)
	assert(UnitCatalogScript.art_id(175) == 980)
	assert(UnitCatalogScript.art_id(176) == 127)
	assert(UnitCatalogScript.art_id(177) == 128)
	assert(UnitCatalogScript.art_id(178) == 597)
	assert(UnitCatalogScript.art_id(179) == 598)
	assert(UnitCatalogScript.art_id(180) == 965)
	assert(UnitCatalogScript.art_id(181) == 966)
	assert(UnitCatalogScript.art_id(182) == 295)
	assert(UnitCatalogScript.art_id(183) == 296)
	assert(UnitCatalogScript.art_id(184) == 215)
	assert(UnitCatalogScript.art_id(185) == 216)
	assert(UnitCatalogScript.art_id(186) == 1011)
	assert(UnitCatalogScript.art_id(187) == 1012)
	assert(UnitCatalogScript.art_id(188) == 697)
	assert(UnitCatalogScript.art_id(189) == 698)
	assert(UnitCatalogScript.art_id(190) == 1123)
	assert(UnitCatalogScript.art_id(191) == 1124)
	assert(UnitCatalogScript.art_id(192) == 747)
	assert(UnitCatalogScript.art_id(193) == 748)
	assert(UnitCatalogScript.art_id(194) == 1019)
	assert(UnitCatalogScript.art_id(195) == 1020)
	assert(UnitCatalogScript.art_id(196) == 263)
	assert(UnitCatalogScript.art_id(197) == 264)
	assert(UnitCatalogScript.art_id(198) == 321)
	assert(UnitCatalogScript.art_id(199) == 322)
	assert(UnitCatalogScript.art_id(200) == 567)
	assert(UnitCatalogScript.art_id(201) == 568)
	assert(UnitCatalogScript.art_id(202) == 693)
	assert(UnitCatalogScript.art_id(203) == 694)
	assert(UnitCatalogScript.art_id(204) == 1053)
	assert(UnitCatalogScript.art_id(205) == 1054)
	assert(UnitCatalogScript.art_id(206) == 1153)
	assert(UnitCatalogScript.art_id(207) == 1154)
	assert(UnitCatalogScript.art_id(208) == 35)
	assert(UnitCatalogScript.art_id(209) == 36)
	assert(UnitCatalogScript.art_id(210) == 69)
	assert(UnitCatalogScript.art_id(211) == 70)
	assert(UnitCatalogScript.art_id(212) == 603)
	assert(UnitCatalogScript.art_id(213) == 107)
	assert(UnitCatalogScript.art_id(214) == 108)
	assert(UnitCatalogScript.art_id(215) == 633)
	for unit in roster:
		var art_id: int = UnitCatalogScript.art_id(unit.icon)
		assert(FileAccess.file_exists(
			"res://assets/units/portraits/%03d.png" % art_id
		))
		var full_art_path := "res://assets/units/full/%03d.png" % art_id
		assert(FileAccess.file_exists(full_art_path))
		var full_art_import_path := full_art_path + ".import"
		assert(FileAccess.file_exists(full_art_import_path))
		assert(FileAccess.get_file_as_string(full_art_import_path).contains(
			"mipmaps/generate=true"
		))
	assert(roster.filter(func(unit): return unit.promotion_of != "").size() == 103)
	assert(UnitSkillsScript.timing_tooltip("Warcry") == "Activates when this unit enters the battlefield.")

	var default_squad: Array = SquadStoreScript.default_squad(roster)
	assert(default_squad.size() == 8)
	var repaired_squad: Array = SquadStoreScript.sanitize(["Trinity Rusher", "Trinity Rusher", "Trinity Rusher", "Missing"], roster)
	assert(repaired_squad.size() == 2)
	assert(repaired_squad.count("Trinity Rusher") == 2)
	assert(SquadStoreScript.build_deck(repaired_squad, roster).size() == 2)
	var ordered_deck: Array = SquadStoreScript.build_deck(
		["Trinity Rusher", "Pub Bouncer", "Socialite Fencer", "Trinity Potshot"],
		roster
	)
	var deck_rng := RandomNumberGenerator.new()
	deck_rng.seed = 42
	var shuffled_deck: Array = SquadStoreScript.shuffle_for_battle(ordered_deck, deck_rng)
	assert(shuffled_deck[0].name == "Trinity Rusher")
	assert(shuffled_deck.map(func(card): return card.name).duplicate().size() == ordered_deck.size())
	var ordered_names: Array = ordered_deck.map(func(card): return card.name)
	var shuffled_names: Array = shuffled_deck.map(func(card): return card.name)
	ordered_names.sort()
	shuffled_names.sort()
	assert(shuffled_names == ordered_names)
	assert(SquadStoreScript.sanitize([], roster).size() == 8)
	var inventory := CampaignStoreScript.inventory_counts(
		roster, ["Trinity Rusher", "Trinity Rusher", "Chain Initiate"]
	)
	assert(inventory["Trinity Rusher"] == 3)
	assert(inventory["Chain Initiate"] == 1)
	assert(inventory["LDF Medic"] == 0)
	var owned_squad: Array = SquadStoreScript.sanitize_owned(
		["Trinity Rusher", "Trinity Rusher", "Trinity Rusher", "Chain Initiate", "LDF Medic"],
		roster,
		inventory
	)
	assert(owned_squad == ["Trinity Rusher", "Trinity Rusher", "Chain Initiate"])
	assert(ConductorSkillsScript.SKILLS.size() == 8)
	assert(CampaignStoreScript.SAVE_VERSION == 1)
	assert(SquadStoreScript.SAVE_VERSION == 3)

	assert(CampaignStoreScript.MISSIONS.size() == 77)
	assert(CampaignStoreScript.MISSIONS[0].title == "Act 1 Mission 1 - Training Day")
	assert(CampaignStoreScript.MISSIONS[61].title == "Act 2 Mission 62 - The Showdown")
	assert(CampaignStoreScript.MISSIONS[76].title == "Act 3 Mission 77 - Accord")
	assert(CampaignStoreScript.MISSIONS[0].enemy_hp == 8)
	assert(CampaignStoreScript.MISSIONS[61].enemy_hp == 20)
	assert(CampaignStoreScript.MISSIONS[76].enemy_hp == 20)
	assert(CampaignStoreScript.MISSIONS[62].act == 3)
	assert(CampaignStoreScript.MISSIONS[62].act_mission == 1)
	assert(CampaignStoreScript.MISSIONS[76].act_mission == 15)
	assert(CampaignStoreScript.MISSIONS[62].chapter == "The Outer City")
	assert(CampaignStoreScript.MISSIONS[77 - 1].chapter == "The Source")
	for mission in CampaignStoreScript.MISSIONS:
		assert(not mission.get("opponent_name", "").is_empty())
		assert(not mission.get("opponent_affiliation", "").is_empty())
		for encounter in mission.encounters:
			assert(encounter.opponent_name == mission.opponent_name)
			assert(encounter.opponent_affiliation == mission.opponent_affiliation)
	assert(CampaignStoreScript.MISSIONS[8].opponent_affiliation == "Scavenger Clans")
	assert(CampaignStoreScript.MISSIONS[28].opponent_name == "Minerva")
	assert(CampaignStoreScript.MISSIONS[76].opponent_affiliation == "Accord Rejectionists")
	assert(StoryDialogueCatalogScript.INTERLUDES.size() == 46)
	assert(StoryDialogueCatalogScript.PORTRAITS.size() == 9)
	for portrait_path in StoryDialogueCatalogScript.PORTRAITS.values():
		var portrait_texture: Texture2D = load(portrait_path)
		assert(portrait_texture != null)
		assert(portrait_texture.get_image().has_mipmaps())
	assert(StoryDialogueCatalogScript.CHARACTERS.Conductor.portrait.ends_with("Conductor.png"))
	assert(StoryDialogueCatalogScript.CHARACTERS["The Rook"].portrait_kind == "android")
	assert(StoryDialogueCatalogScript.CHARACTERS["First Conductor"].portrait_kind == "android")
	for character in StoryDialogueCatalogScript.CHARACTERS.values():
		assert(character.get("portrait_kind", "") in ["human", "android"])
		assert(ResourceLoader.exists(character.get("portrait", "")))
	var opening_interlude := StoryDialogueCatalogScript.scene_for_mission(0)
	assert(opening_interlude.title == "A Useful Kind of Impossible")
	assert(opening_interlude.lines.size() >= 4)
	assert(opening_interlude.background == StoryDialogueCatalogScript.BACKGROUNDS.technical)
	assert(StoryDialogueCatalogScript.scene_for_mission(1).is_empty())
	assert(StoryDialogueCatalogScript.scene_for_mission(60).title == "The Invitation")
	assert(StoryDialogueCatalogScript.scene_for_mission(61).title == "At the Threshold")
	assert(StoryDialogueCatalogScript.scene_for_mission(62).is_empty())
	assert(StoryDialogueCatalogScript.scene_for_mission(66).title == "Five True Stories")
	assert(StoryDialogueCatalogScript.scene_for_mission(76).lines.size() == 6)
	for mission_number in StoryDialogueCatalogScript.INTERLUDES:
		var interlude: Dictionary = StoryDialogueCatalogScript.INTERLUDES[mission_number]
		var presented_scene := StoryDialogueCatalogScript.scene_for_mission(mission_number - 1)
		assert(mission_number >= 1 and mission_number <= CampaignStoreScript.MISSIONS.size())
		assert(not interlude.get("title", "").is_empty())
		assert(not interlude.get("location", "").is_empty())
		assert(ResourceLoader.exists(presented_scene.get("background", "")))
		assert(interlude.get("lines", []).size() >= 4)
		for dialogue_line in interlude.lines:
			assert(not dialogue_line.get("speaker", "").is_empty())
			assert(not dialogue_line.get("text", "").is_empty())
			assert(StoryDialogueCatalogScript.CHARACTERS.has(dialogue_line.speaker))
	assert("The Rook" in CampaignStoreScript.MISSIONS[62].reward_pool)
	assert("Sterling Knight" in CampaignStoreScript.MISSIONS[62].reward_pool)
	assert("Shining Inti" in CampaignStoreScript.MISSIONS[76].reward_pool)
	assert(CampaignStoreScript.CAMPAIGN_EPILOGUE.contains("THE RESONANCE WAR"))
	assert(CampaignStoreScript.encounter_count(3) == 1)
	assert(CampaignStoreScript.encounter_count(31) == 3)
	assert(CampaignStoreScript.encounter(31, 2).title == "Peace and Quiet")
	assert(CampaignStoreScript.encounter(999, 0).is_empty())
	assert(CampaignStoreScript.is_available(0, []))
	assert(not CampaignStoreScript.is_available(1, []))
	assert(CampaignStoreScript.is_available(1, [0]))
	assert(CampaignStoreScript.sanitize_completed([2, 2, 999, -1, 0]) == [0, 2])
	var starting_unlocks: Array = CampaignStoreScript.unlocked_unit_names(roster, [])
	assert(starting_unlocks.size() == 85)
	assert("Chain Initiate" not in starting_unlocks)
	assert("Claw Minstrel" not in starting_unlocks)
	assert("Conjuring Clown" in starting_unlocks)
	assert("Conjuring Jester" in starting_unlocks)
	assert("Flame Schematic" in starting_unlocks)
	var earned_unlocks: Array = CampaignStoreScript.unlocked_unit_names(
		roster, ["Chain Initiate", "LDF Medic"]
	)
	assert(earned_unlocks.size() == 87)
	assert("Claw Minstrel" in CampaignStoreScript.REWARD_UNITS)
	assert("Claw Rocker" in CampaignStoreScript.REWARD_UNITS)
	assert("Flame Warden" in CampaignStoreScript.REWARD_UNITS)
	assert("Flame Dissident" in CampaignStoreScript.REWARD_UNITS)
	assert("Conjuring Clown" not in CampaignStoreScript.REWARD_UNITS)
	assert(CampaignStoreScript.roll_reward(0, roster, 0.0) == "Trinity Rusher")
	assert(CampaignStoreScript.roll_reward(0, roster, 0.999) == "Trinity Potshot")
	assert(CampaignStoreScript.reward_summary(2) == "Random: Street Nurse, Rage Brute")
	assert(CampaignStoreScript.reward_summary(3) == "Random: Talon Scratcher")
	assert(CampaignStoreScript.reward_summary(7) == "Random: Claw Caster, Claw Slicer, Rage Brute, Claw Skirmisher, Claw Ambusher, Claw Minstrel, Claw Rocker")
	var training_rewards: Array = CampaignStoreScript.reward_options(0, roster)
	assert(training_rewards.size() == 2)
	assert(is_equal_approx(training_rewards[0].chance, 0.5))
	assert(is_equal_approx(training_rewards[1].chance, 0.5))
	assert(CampaignStoreScript.reward_options(3, roster).size() == 1)
	assert(is_equal_approx(CampaignStoreScript.reward_options(3, roster)[0].chance, 1.0))
	assert(CampaignStoreScript.reward_summary(6) == "Random: Talon Scratcher, LDF Crowd Mage")
	assert("Master Builder" in CampaignStoreScript.MISSIONS[10].reward_pool)
	assert("Claw Ambusher" in CampaignStoreScript.MISSIONS[7].reward_pool)
	assert("Order Missionary" in CampaignStoreScript.MISSIONS[27].reward_pool)
	assert("Street Nurse" in CampaignStoreScript.MISSIONS[2].reward_pool)
	assert("Street Matron" in CampaignStoreScript.MISSIONS[9].reward_pool)
	assert("Conductor Kerryson" in CampaignStoreScript.MISSIONS[17].reward_pool)
	assert("Kerryson the Stoic" in CampaignStoreScript.MISSIONS[17].reward_pool)
	assert("Garrett Talon" in CampaignStoreScript.MISSIONS[8].reward_pool)
	assert("Garrett the Claw" in CampaignStoreScript.MISSIONS[49].reward_pool)
	assert("Precision Shooter" in CampaignStoreScript.MISSIONS[52].reward_pool)
	assert("Precision Sniper" in CampaignStoreScript.MISSIONS[60].reward_pool)
	assert("Greyson the Shifty" in CampaignStoreScript.MISSIONS[13].reward_pool)
	assert("LDF Flight Officer" in CampaignStoreScript.MISSIONS[18].reward_pool)
	assert("LDF Flight Commander" in CampaignStoreScript.MISSIONS[14].reward_pool)
	assert("Haven Trapper" in CampaignStoreScript.MISSIONS[9].reward_pool)
	assert("Haven Huntsman" in CampaignStoreScript.MISSIONS[22].reward_pool)
	assert("Macabre Embalmer" in CampaignStoreScript.MISSIONS[26].reward_pool)
	assert("Macabre Undertaker" in CampaignStoreScript.MISSIONS[28].reward_pool)
	assert("Devout Mage" in CampaignStoreScript.MISSIONS[20].reward_pool)
	assert("Devout Warlock" in CampaignStoreScript.MISSIONS[55].reward_pool)
	assert("Commune Defender" in CampaignStoreScript.MISSIONS[37].reward_pool)
	assert("Commune Conductor" in CampaignStoreScript.MISSIONS[37].reward_pool)
	assert("LDF Constable" in CampaignStoreScript.MISSIONS[9].reward_pool)
	assert("LDF Constable" in CampaignStoreScript.MISSIONS[61].reward_pool)
	assert("LDF Sergeant" in CampaignStoreScript.MISSIONS[18].reward_pool)
	assert("Joe Wonder" in CampaignStoreScript.MISSIONS[19].reward_pool)
	assert("Pompous Joe Wonder" in CampaignStoreScript.MISSIONS[43].reward_pool)
	assert("Raging Dragon" in CampaignStoreScript.MISSIONS[35].reward_pool)
	assert("Blazing Dragon" in CampaignStoreScript.MISSIONS[35].reward_pool)
	assert("Royal Yeoman" in CampaignStoreScript.MISSIONS[15].reward_pool)
	assert("Royal Beefeater" in CampaignStoreScript.MISSIONS[32].reward_pool)
	assert("Rescue Corps" in CampaignStoreScript.MISSIONS[41].reward_pool)
	assert("Rescue Paramedic" in CampaignStoreScript.MISSIONS[41].reward_pool)
	assert("Claw Minstrel" in CampaignStoreScript.MISSIONS[7].reward_pool)
	assert("Claw Minstrel" in CampaignStoreScript.MISSIONS[44].reward_pool)
	assert("Claw Rocker" in CampaignStoreScript.MISSIONS[47].reward_pool)
	assert("Flame Warden" in CampaignStoreScript.MISSIONS[10].reward_pool)
	assert("Flame Warden" in CampaignStoreScript.MISSIONS[46].reward_pool)
	assert("Flame Dissident" in CampaignStoreScript.MISSIONS[46].reward_pool)
	# Campaign reward rolls can grant the four new reward units.
	assert(CampaignStoreScript.roll_reward(7, roster, 0.85) == "Claw Minstrel")
	assert(CampaignStoreScript.roll_reward(7, roster, 0.99) == "Claw Rocker")
	assert(CampaignStoreScript.roll_reward(46, roster, 0.95) == "Flame Warden")
	assert(CampaignStoreScript.roll_reward(46, roster, 0.99) == "Flame Dissident")
	assert("Rescue Corps" in CampaignStoreScript.MISSIONS[53].reward_pool)
	assert("Rescue Paramedic" in CampaignStoreScript.MISSIONS[53].reward_pool)
	for mission in CampaignStoreScript.MISSIONS:
		assert("Farsight Naruku" not in mission.reward_pool)
		assert("Macewielder Ragnr" not in mission.reward_pool)
		assert("Innocent Gretel" not in mission.reward_pool)
		assert("Witchkiller Gretel" not in mission.reward_pool)
		assert("Talon Slicer" not in mission.reward_pool)
		assert("Fortune Teller" not in mission.reward_pool)
		assert("Fortune Diviner" not in mission.reward_pool)
		assert("Blight Doctor" not in mission.reward_pool)
		assert("Blight Physician" not in mission.reward_pool)
		assert("Dart Shooter" not in mission.reward_pool)
		assert("Dart Sharpshooter" not in mission.reward_pool)
		assert("Frog-Hopper Keru" not in mission.reward_pool)
		assert("Lizard-Licker Keru" not in mission.reward_pool)
		assert("Blightshot" not in mission.reward_pool)
		assert("Toxic Shot" not in mission.reward_pool)
		assert("Garrett the Raider" not in mission.reward_pool)
		assert("Precision Trigger" not in mission.reward_pool)
		assert("Greyson the Shrewd" not in mission.reward_pool)
		assert("Communicator Ripley" not in mission.reward_pool)
		assert("The Telecommunicator" not in mission.reward_pool)
		assert("Vicious Pierrot" not in mission.reward_pool)
		assert("Pierrot the Deciever" not in mission.reward_pool)
		assert("Prison Warden" not in mission.reward_pool)
		assert("Prison Guv'nor" not in mission.reward_pool)
		assert("Shakespeare" not in mission.reward_pool)
		assert("The Bard" not in mission.reward_pool)
		assert("Bartok Loco" not in mission.reward_pool)
		assert("Derailed Bartok" not in mission.reward_pool)
		assert("Geartron Prototype" not in mission.reward_pool)
		assert("Geartron-5000" not in mission.reward_pool)
		assert("Bethany" not in mission.reward_pool)
		assert("Bunnybot Bethany" not in mission.reward_pool)
		assert("Final Empress" not in mission.reward_pool)
		assert("Awoken Final Empress" not in mission.reward_pool)
		assert("Opelle" not in mission.reward_pool)
		assert("Glowing Opelle" not in mission.reward_pool)
		assert("Commune Commander" not in mission.reward_pool)
		assert("Frost-Kid Kokori" not in mission.reward_pool)
		assert("Ice-Prince Kokori" not in mission.reward_pool)
		assert("Mata Swiftblade" not in mission.reward_pool)
		assert("Swiftblade Heroine" not in mission.reward_pool)
		assert("Rydia of Mist" not in mission.reward_pool)
		assert("Summoner Rydia" not in mission.reward_pool)
		assert("Booth" not in mission.reward_pool)
		assert("Booth Kavar" not in mission.reward_pool)
		assert("Medusa" not in mission.reward_pool)
		assert("Gorgon Medusa" not in mission.reward_pool)
		assert("Nageki (Mourning Dove)" not in mission.reward_pool)
		assert("Nageki Fujishiro" not in mission.reward_pool)
	var rarity_candidates := [
		{"name": "One Star", "stars": 1},
		{"name": "Five Star", "stars": 5}
	]
	assert(CampaignStoreScript.choose_weighted_reward(rarity_candidates, 0.93) == "One Star")
	assert(CampaignStoreScript.choose_weighted_reward(rarity_candidates, 0.99) == "Five Star")
	var enemy_squad: Array = CampaignStoreScript.enemy_squad_names(2, 0, roster)
	assert(enemy_squad.size() == 8)
	var unique_enemy_cards: Array = []
	for card_name in enemy_squad:
		if card_name not in unique_enemy_cards:
			unique_enemy_cards.append(card_name)
	assert(unique_enemy_cards.size() == 8)
	assert(enemy_squad != CampaignStoreScript.enemy_squad_names(3, 0, roster))
	assert(CampaignStoreScript.encounter(0, 0).enemy_squad.size() == 8)
	var enemy_squad_signatures: Array[String] = []
	var roster_names: Array = roster.map(func(unit): return unit.name)
	for mission in CampaignStoreScript.MISSIONS:
		var configured_squad: Array = mission.encounters[0].enemy_squad
		assert(configured_squad.size() == 8)
		assert(configured_squad.all(func(unit_name): return unit_name in roster_names))
		assert(configured_squad.all(
			func(unit_name): return configured_squad.count(unit_name) <= 2
		))
		var signature := "|".join(configured_squad)
		assert(signature not in enemy_squad_signatures)
		enemy_squad_signatures.append(signature)
	assert(enemy_squad_signatures.size() == 77)

	var mover := {"id": 1, "side": 0, "kind": "Duelist", "row": 1, "col": 2, "repositioned": false, "taunt_turns": 0}
	var distant_warden := {"id": 2, "side": 1, "kind": "Warden", "row": 1, "col": 5, "repositioned": false}
	assert(not BattleRulesScript.is_taunted(mover, [mover, distant_warden]))
	assert(BattleRulesScript.can_reposition(mover, 0, [mover, distant_warden]))
	var nearby_warden := {"id": 3, "side": 1, "kind": "Warden", "row": 1, "col": 4, "repositioned": false}
	BattleRulesScript.apply_taunt(mover)
	assert(BattleRulesScript.is_taunted(mover, [mover, nearby_warden]))
	assert(not BattleRulesScript.can_reposition(mover, 0, [mover, nearby_warden]))
	BattleRulesScript.expire_taunts([mover], 0)
	assert(mover.taunt_turns == 1)
	assert(BattleRulesScript.is_taunted(mover, [mover]))
	BattleRulesScript.expire_taunts([mover], 0)
	assert(not BattleRulesScript.is_taunted(mover, [mover]))
	mover.immobilized_turns = 1
	assert(BattleRulesScript.is_immobilized(mover))
	assert(not BattleRulesScript.can_reposition(mover, 0, [mover]))
	assert(BattleAIScript.choose_reposition(mover, [mover]) == mover.row)
	mover.immobilized_turns = 0
	assert(not BattleRulesScript.is_immobilized(mover))
	assert(BattleRulesScript.can_reposition(mover, 0, [mover]))
	var blocker := {"id": 4, "side": 0, "kind": "Strider", "row": 0, "col": 2, "repositioned": false}
	assert(not BattleRulesScript.can_reposition(mover, 0, [mover, blocker]))
	assert(not BattleRulesScript.can_reposition(mover, 2, [mover, {"id": 5, "side": 1, "kind": "Strider", "row": 2, "col": 2}]))
	var top_lane_mover := {
		"id": 50, "side": 0, "kind": "Duelist", "row": 0, "col": 2,
		"repositioned": false, "taunt_turns": 0
	}
	assert(BattleRulesScript.can_reposition(top_lane_mover, 2, [top_lane_mover]))
	var friendly_between := {
		"id": 7, "side": 0, "kind": "Strider", "row": 1, "col": 2
	}
	assert(BattleRulesScript.can_reposition(top_lane_mover, 2, [top_lane_mover, friendly_between]))
	var enemy_between := {
		"id": 8, "side": 1, "kind": "Strider", "row": 1, "col": 2
	}
	assert(not BattleRulesScript.can_reposition(top_lane_mover, 2, [top_lane_mover, enemy_between]))
	top_lane_mover.repositioned = true
	assert(BattleRulesScript.can_reposition(top_lane_mover, 2, [top_lane_mover]))
	var middle_lane_blocker := {
		"id": 51, "side": 1, "kind": "Warden", "row": 1, "col": 2
	}
	assert(not BattleRulesScript.can_reposition(
		top_lane_mover, 2, [top_lane_mover, middle_lane_blocker]
	))
	assert(BattleAIScript.choose_reposition(top_lane_mover, [top_lane_mover]) == 0)
	assert(BattleAIScript.should_use_conductor_skill(
		"Shield", 4, 18, []
	))

	var mana_units := [
		{"side": 0, "cost": 2},
		{"side": 0, "cost": 3},
		{"side": 1, "cost": 4}
	]
	assert(BattleRulesScript.locked_mana(mana_units, 0) == 5)
	assert(BattleRulesScript.available_mana(8, mana_units, 0) == 3)
	assert(BattleRulesScript.available_mana(10, [mana_units[1]], 0) == 7)

	var skill_ally := {
		"id": 20, "side": 0, "name": "Test Ally", "atk": 2,
		"hp": 3, "max_hp": 5, "effects": [], "taunted_by": -1
	}
	var skill_enemy := {
		"id": 21, "side": 1, "name": "Test Enemy", "atk": 4,
		"hp": 6, "max_hp": 6, "effects": [], "taunted_by": -1
	}
	var skill_units := [skill_ally, skill_enemy]
	var rally: Dictionary = ConductorSkillsScript.apply("Rally", 0, skill_units, 20)
	assert(rally.success)
	assert(skill_ally.atk == 3)
	assert("Rally (1 turn)" in ConductorSkillsScript.effect_summary(skill_ally))
	ConductorSkillsScript.expire_effects(skill_units, 0)
	assert(skill_ally.atk == 2)
	assert(skill_ally.effects.is_empty())
	var aid: Dictionary = ConductorSkillsScript.apply("Aid", 0, skill_units, 20)
	assert(aid.success and skill_ally.hp == 5)
	var shield: Dictionary = ConductorSkillsScript.apply("Shield", 0, skill_units, 20)
	assert(shield.success and shield.shield == 5 and shield.shield_turns == 2)
	assert(not ConductorSkillsScript.apply("Last Stand", 0, skill_units, 9).success)
	assert(ConductorSkillsScript.apply("Last Stand", 0, skill_units, 8).success)
	ConductorSkillsScript.expire_effects(skill_units, 0)
	var firestorm: Dictionary = ConductorSkillsScript.apply("Firestorm", 0, skill_units, 20)
	assert(firestorm.success and skill_enemy.hp == 4)

	var builder := {
		"id": 30, "side": 0, "name": "Apprentice Builder", "atk": 2,
		"hp": 4, "max_hp": 4, "effects": [],
		"skill": {"name": "Fortify", "type": "Warcry"}
	}
	var fortify_ally := {
		"id": 31, "side": 0, "name": "Ally", "atk": 2,
		"hp": 2, "max_hp": 5, "effects": []
	}
	var warcry_enemy := {
		"id": 32, "side": 1, "name": "Enemy", "atk": 2,
		"hp": 6, "max_hp": 6, "effects": []
	}
	var warcry_units := [builder, fortify_ally, warcry_enemy]
	assert(not UnitSkillsScript.resolve_warcry(builder, warcry_units).message.is_empty())
	assert(fortify_ally.hp == 5 and fortify_ally.max_hp == 8)
	ConductorSkillsScript.expire_effects(warcry_units, 0)
	assert(fortify_ally.max_hp == 8)
	ConductorSkillsScript.expire_effects(warcry_units, 0)
	assert(fortify_ally.hp == 5 and fortify_ally.max_hp == 5)

	var brute := {
		"id": 33, "side": 0, "name": "Rage Brute", "atk": 2,
		"hp": 4, "max_hp": 4, "effects": [],
		"skill": {"name": "Empower", "type": "Warcry"}
	}
	assert(not UnitSkillsScript.resolve_warcry(brute, [brute, fortify_ally]).message.is_empty())
	assert(fortify_ally.atk == 3)
	var empower_target := {
		"id": 41, "side": 0, "name": "Chosen Ally", "atk": 1,
		"hp": 4, "max_hp": 4, "effects": []
	}
	assert(not UnitSkillsScript.resolve_warcry(
		brute, [brute, fortify_ally, empower_target], 41
	).message.is_empty())
	assert(empower_target.atk == 2)
	var gunner := {
		"id": 34, "side": 0, "name": "LDF Gunner", "atk": 3,
		"hp": 2, "max_hp": 2, "effects": [],
		"skill": {"name": "Bolt", "type": "Warcry"}
	}
	assert(not UnitSkillsScript.resolve_warcry(gunner, [gunner, warcry_enemy]).message.is_empty())
	assert(warcry_enemy.hp == 5)
	var misfortune_actor := {
		"id": 37, "side": 0, "name": "Street Urchin", "atk": 2,
		"hp": 2, "max_hp": 2, "effects": [],
		"skill": {"name": "Misfortune", "type": "Warcry"}
	}
	var enemy_scout := {
		"id": 38, "side": 1, "name": "Enemy Scout", "kind": "Strider",
		"atk": 5, "hp": 4, "max_hp": 4, "effects": []
	}
	var enemy_gunner := {
		"id": 39, "side": 1, "name": "Enemy Gunner", "kind": "Artillerist",
		"atk": 4, "hp": 4, "max_hp": 4, "effects": []
	}
	var enemy_fighter := {
		"id": 40, "side": 1, "name": "Enemy Fighter", "kind": "Duelist",
		"atk": 8, "hp": 4, "max_hp": 4, "effects": []
	}
	var misfortune_units := [
		misfortune_actor, enemy_scout, enemy_gunner, enemy_fighter
	]
	assert(not UnitSkillsScript.resolve_warcry(
		misfortune_actor, misfortune_units
	).message.is_empty())
	assert(enemy_scout.atk == 4)
	assert(enemy_gunner.atk == 4 and enemy_fighter.atk == 8)
	ConductorSkillsScript.expire_effects(misfortune_units, 1)
	assert(enemy_scout.atk == 4)
	ConductorSkillsScript.expire_effects(misfortune_units, 1)
	assert(enemy_scout.atk == 5)
	var mend_actor := {
		"id": 41, "side": 0, "name": "Street Nurse", "kind": "Lifebinder",
		"atk": 2, "hp": 3, "max_hp": 3, "effects": [],
		"skill": {"name": "Mend", "type": "Warcry"}
	}
	var mend_target := {
		"id": 42, "side": 0, "name": "Wounded Ally", "kind": "Duelist",
		"atk": 2, "hp": 2, "max_hp": 5, "effects": []
	}
	var mend_result := UnitSkillsScript.resolve_warcry(
		mend_actor, [mend_actor, mend_target]
	)
	assert(not mend_result.message.is_empty())
	assert(mend_target.hp == 5)
	var plague_actor := {
		"id": 43, "side": 0, "name": "Blight Doctor", "kind": "Lifebinder",
		"atk": 2, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Plague", "type": "Warcry"}
	}
	var plague_ally := {
		"id": 44, "side": 0, "name": "Plagued Ally", "kind": "Duelist",
		"atk": 2, "hp": 5, "max_hp": 5, "effects": []
	}
	var plague_enemy := {
		"id": 45, "side": 1, "name": "Plagued Enemy", "kind": "Warden",
		"atk": 2, "hp": 5, "max_hp": 5, "effects": []
	}
	var plague_units := [plague_actor, plague_ally, plague_enemy]
	var plague_result := UnitSkillsScript.resolve_warcry(plague_actor, plague_units)
	assert(plague_result.affected.size() == 2)
	assert(plague_actor.hp == 6)
	assert(plague_ally.hp == 4 and plague_enemy.hp == 4)
	assert(plague_ally.poison_turns == 2 and plague_enemy.poison_turns == 2)
	assert(UnitSkillsScript.resolve_start_statuses(1, plague_units).size() == 1)
	assert(plague_enemy.hp == 3 and plague_enemy.poison_turns == 1)
	assert(UnitSkillsScript.resolve_start_statuses(1, plague_units).size() == 1)
	assert(plague_enemy.hp == 2 and plague_enemy.poison_turns == 0)
	var envenom_actor := {
		"id": 46, "side": 0, "name": "Dart Shooter", "kind": "Artillerist",
		"atk": 4, "hp": 3, "max_hp": 3, "effects": [],
		"skill": {"name": "Envenom", "type": "Warcry"}
	}
	var envenom_target := {
		"id": 47, "side": 1, "name": "Chosen Enemy", "kind": "Channeler",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	var envenom_other := {
		"id": 48, "side": 1, "name": "Other Enemy", "kind": "Warden",
		"atk": 5, "hp": 8, "max_hp": 8, "effects": []
	}
	var envenom_result := UnitSkillsScript.resolve_warcry(
		envenom_actor, [envenom_actor, envenom_target, envenom_other], 47
	)
	assert(envenom_result.affected == [47])
	assert(envenom_target.poison_turns == 2)
	assert(not envenom_other.has("poison_turns"))
	var pin_actor := {
		"id": 49, "side": 0, "name": "Garrett Talon", "kind": "Artillerist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Pin Down", "type": "Warcry"}
	}
	var pin_result := UnitSkillsScript.resolve_warcry(
		pin_actor, [pin_actor, envenom_target, envenom_other]
	)
	assert(pin_result.affected == [48])
	assert(envenom_other.hp == 7 and envenom_other.immobilized_turns == 1)
	var demoralize_actor := {
		"id": 50, "side": 0, "name": "Greyson the Shifty", "kind": "Strider",
		"atk": 2, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Demoralize", "type": "Warcry"}
	}
	var lane_fighter := {
		"id": 51, "side": 1, "name": "Lane Fighter", "kind": "Duelist",
		"row": 2, "atk": 5, "hp": 5, "max_hp": 5, "effects": []
	}
	var lane_mage := {
		"id": 52, "side": 1, "name": "Lane Mage", "kind": "Channeler",
		"row": 2, "atk": 6, "hp": 5, "max_hp": 5, "effects": []
	}
	var lane_defender := {
		"id": 55, "side": 1, "name": "Lane Defender", "kind": "Warden",
		"row": 2, "atk": 3, "hp": 8, "max_hp": 8, "effects": []
	}
	var other_lane_scout := {
		"id": 53, "side": 1, "name": "Other Scout", "kind": "Strider",
		"row": 1, "atk": 4, "hp": 5, "max_hp": 5, "effects": []
	}
	var debuff_units := [
		demoralize_actor, lane_fighter, lane_mage, lane_defender, other_lane_scout
	]
	var demoralize_result := UnitSkillsScript.resolve_warcry(
		demoralize_actor, debuff_units, -1, null, 2
	)
	assert(demoralize_result.affected == [51, 55])
	assert(
		lane_fighter.atk == 4 and lane_defender.atk == 2
		and lane_mage.atk == 6 and other_lane_scout.atk == 4
	)
	var deploy_preview := BattleRulesScript.projected_deployment(
		{"move": 3, "range": 1}, 0, []
	)
	assert(deploy_preview.traversal == [
		Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0)
	])
	assert(deploy_preview.attack == [Vector2i(4, 0)])
	var blocked_deploy_preview := BattleRulesScript.projected_deployment(
		{"move": 3, "range": 1}, 0,
		[{"id": 90, "side": 1, "row": 0, "col": 2, "ready": true, "move": 1, "range": 1}]
	)
	assert(blocked_deploy_preview.traversal == [Vector2i(1, 0)])
	assert(blocked_deploy_preview.attack == [Vector2i(2, 0)])
	var punish_actor := {
		"id": 54, "side": 0, "name": "LDF Flight Officer", "kind": "Duelist",
		"atk": 4, "hp": 4, "max_hp": 4, "effects": [],
		"skill": {"name": "Punish", "type": "Warcry"}
	}
	var punish_result := UnitSkillsScript.resolve_warcry(
		punish_actor, debuff_units + [punish_actor]
	)
	assert(punish_result.affected == [52])
	assert(lane_mage.atk == 5)
	ConductorSkillsScript.expire_effects(debuff_units, 1)
	ConductorSkillsScript.expire_effects(debuff_units, 1)
	assert(lane_fighter.atk == 5 and lane_mage.atk == 6)
	var pupil := {
		"id": 36, "side": 0, "name": "Order Pupil", "atk": 3,
		"hp": 2, "max_hp": 2, "effects": [],
		"skill": {"name": "Heaven's Wrath", "type": "Warcry"}
	}
	assert(not UnitSkillsScript.resolve_warcry(pupil, [pupil, warcry_enemy]).message.is_empty())
	assert(warcry_enemy.hp == 4)
	var skirmisher := {
		"id": 35, "side": 0, "name": "Claw Skirmisher", "atk": 2,
		"hp": 3, "max_hp": 3, "effects": [],
		"skill": {"name": "Pinning Strike", "type": "Strike"}
	}
	assert(not UnitSkillsScript.resolve_strike(skirmisher, warcry_enemy, [], 0.29).message.is_empty())
	assert(warcry_enemy.immobilized_turns == 1)
	UnitSkillsScript.expire_statuses([warcry_enemy], 1)
	assert(warcry_enemy.immobilized_turns == 0)
	var poison_striker := {
		"id": 91, "side": 0, "name": "Claw Chopper",
		"skill": {"name": "Poison Strike", "type": "Strike"}
	}
	assert(not UnitSkillsScript.resolve_strike(
		poison_striker, warcry_enemy, [], 0.49
	).message.is_empty())
	assert(warcry_enemy.poison_turns == 2)
	var sunder_actor := {
		"id": 92, "side": 0, "name": "LDF Bowgunner",
		"skill": {"name": "Sunder Armour", "type": "Warcry"}
	}
	var sunder_defender := {
		"id": 93, "side": 1, "name": "Armoured Target", "kind": "Warden",
		"hp": 8, "max_hp": 8, "effects": []
	}
	var sunder_scout := {
		"id": 94, "side": 1, "name": "Ineligible Target", "kind": "Strider",
		"hp": 10, "max_hp": 10, "effects": []
	}
	var sunder_result := UnitSkillsScript.resolve_warcry(
		sunder_actor, [sunder_actor, sunder_defender, sunder_scout]
	)
	assert(sunder_result.affected == [93])
	assert(sunder_defender.hp == 7 and sunder_defender.vulnerable_turns == 2)
	assert(sunder_defender.vulnerable_stacks == 1)
	assert(BattleSimulatorScript.apply_unit_damage(sunder_defender, 2).damage == 3)
	assert(sunder_defender.hp == 4)
	UnitSkillsScript.expire_statuses([sunder_defender], 1)
	assert(sunder_defender.vulnerable_turns == 1)
	var sunder_result_two := UnitSkillsScript.resolve_warcry(
		sunder_actor, [sunder_actor, sunder_defender, sunder_scout]
	)
	assert(sunder_result_two.affected == [93])
	assert(sunder_defender.vulnerable_stacks == 2)
	assert(sunder_defender.vulnerable_turns == 2)
	assert("stack 2" in sunder_result_two.message)
	sunder_defender.hp = 8
	assert(BattleSimulatorScript.apply_unit_damage(sunder_defender, 2).damage == 4)
	assert(sunder_defender.hp == 4)
	UnitSkillsScript.expire_statuses([sunder_defender], 1)
	assert(sunder_defender.vulnerable_turns == 1)
	assert(sunder_defender.vulnerable_stacks == 2)
	UnitSkillsScript.expire_statuses([sunder_defender], 1)
	assert(sunder_defender.vulnerable_turns == 0)
	assert(sunder_defender.vulnerable_stacks == 0)
	var hunter_actor := {
		"id": 95, "side": 0, "name": "Haven Trapper", "kind": "Artillerist",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {"name": "Big Game Hunter", "type": "Warcry"}
	}
	var hunter_big := {
		"id": 96, "side": 1, "name": "Big Target", "kind": "Strider",
		"atk": 4, "hp": 9, "max_hp": 9, "effects": []
	}
	var hunter_small := {
		"id": 97, "side": 1, "name": "Small Target", "kind": "Warden",
		"atk": 2, "hp": 4, "max_hp": 4, "effects": []
	}
	var hunter_result := UnitSkillsScript.resolve_warcry(
		hunter_actor, [hunter_actor, hunter_big, hunter_small]
	)
	assert(hunter_result.affected == [96])
	assert(hunter_big.hp == 8 and hunter_big.vulnerable_turns == 2)
	assert(hunter_big.vulnerable_stacks == 1)
	assert(not hunter_small.has("vulnerable_turns"))
	var contagion_actor := {
		"id": 98, "side": 0, "name": "Macabre Embalmer", "kind": "Channeler",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {"name": "Contagion", "type": "Warcry"}
	}
	var contagion_mage := {
		"id": 99, "side": 1, "name": "Enemy Mage", "kind": "Channeler",
		"atk": 4, "hp": 5, "max_hp": 5, "effects": []
	}
	var contagion_priest := {
		"id": 100, "side": 1, "name": "Enemy Priest", "kind": "Lifebinder",
		"atk": 2, "hp": 6, "max_hp": 6, "effects": []
	}
	var contagion_fighter := {
		"id": 101, "side": 1, "name": "Enemy Fighter", "kind": "Duelist",
		"atk": 5, "hp": 7, "max_hp": 7, "effects": []
	}
	var contagion_result := UnitSkillsScript.resolve_warcry(
		contagion_actor,
		[contagion_actor, contagion_mage, contagion_priest, contagion_fighter]
	)
	assert(contagion_result.affected == [99, 100])
	assert(contagion_mage.hp == 4 and contagion_mage.poison_turns == 2)
	assert(contagion_priest.hp == 5 and contagion_priest.poison_damage == 1)
	assert(contagion_fighter.hp == 7 and not contagion_fighter.has("poison_turns"))
	var meteor_actor := {
		"id": 102, "side": 0, "name": "Devout Mage", "kind": "Channeler",
		"row": 0, "atk": 5, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Meteor Barrage", "type": "Warcry"}
	}
	var meteor_lane_one := {
		"id": 103, "side": 1, "name": "Lane One Target", "kind": "Duelist",
		"row": 1, "atk": 5, "hp": 6, "max_hp": 6, "effects": []
	}
	var meteor_lane_two := {
		"id": 104, "side": 1, "name": "Lane Two Target", "kind": "Strider",
		"row": 2, "atk": 3, "hp": 8, "max_hp": 8, "effects": []
	}
	var meteor_units := [meteor_actor, meteor_lane_one, meteor_lane_two]
	var meteor_result := UnitSkillsScript.resolve_warcry(
		meteor_actor, meteor_units, -1, null, 2
	)
	assert(meteor_result.affected == [104])
	assert(meteor_lane_two.hp == 6 and meteor_lane_one.hp == 6)
	var meteor_fallback := UnitSkillsScript.resolve_warcry(meteor_actor, meteor_units)
	assert(meteor_fallback.affected == [103])
	assert(meteor_lane_one.hp == 4)
	skirmisher.skill = {"name": "Pinning Slice", "type": "Strike"}
	assert(not UnitSkillsScript.resolve_strike(skirmisher, warcry_enemy, [], 0.59).message.is_empty())
	warcry_enemy.immobilized_turns = 0
	assert(UnitSkillsScript.resolve_strike(skirmisher, warcry_enemy, [], 0.60).message.is_empty())

	# Chant: Sundering Smash hits every enemy in the chanter's lane at the
	# start of the chanter's turn and makes survivors Vulnerable.
	var bartok := {
		"id": 105, "side": 0, "name": "Bartok Loco", "kind": "Duelist",
		"row": 1, "atk": 5, "hp": 8, "max_hp": 8, "effects": [],
		"skill": {"name": "Sundering Smash", "type": "Chant"}
	}
	var chant_lane_foe := {
		"id": 106, "side": 1, "name": "Lane Foe", "kind": "Warden",
		"row": 1, "atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var chant_other_lane := {
		"id": 107, "side": 1, "name": "Other Lane Foe", "kind": "Strider",
		"row": 2, "atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var chant_units := [bartok, chant_lane_foe, chant_other_lane]
	var chant_results := UnitSkillsScript.resolve_chants(0, chant_units)
	assert(chant_results.size() == 1)
	assert(chant_results[0].affected == [106])
	assert(chant_lane_foe.hp == 5 and chant_lane_foe.vulnerable_turns == 2)
	assert(chant_lane_foe.vulnerable_stacks == 1)
	assert(chant_other_lane.hp == 6 and not chant_other_lane.has("vulnerable_turns"))
	assert(UnitSkillsScript.resolve_chants(1, chant_units).is_empty())
	# Re-applying Vulnerable stacks, mirroring Sunder Armour, and last turn's
	# Vulnerable amplifies this turn's chant damage (1 + 1 stack).
	UnitSkillsScript.resolve_chants(0, chant_units)
	assert(chant_lane_foe.hp == 3 and chant_lane_foe.vulnerable_stacks == 2)
	# Level scaling: a level-5 chanter hits for 3 damage over 4 turns.
	var veteran_geartron := {
		"id": 114, "side": 0, "name": "Geartron-5000", "kind": "Warden",
		"row": 0, "atk": 3, "hp": 13, "max_hp": 13, "effects": [], "level": 5,
		"skill": UnitCatalogScript.by_name("Geartron-5000").skill.to_dict()
	}
	var veteran_lane_foe := {
		"id": 115, "side": 1, "name": "Veteran Lane Foe", "kind": "Duelist",
		"row": 0, "atk": 4, "hp": 9, "max_hp": 9, "effects": []
	}
	var veteran_chants := UnitSkillsScript.resolve_chants(
		0, [veteran_geartron, veteran_lane_foe]
	)
	assert(veteran_chants.size() == 1)
	assert(veteran_lane_foe.hp == 6 and veteran_lane_foe.vulnerable_turns == 4)

	# Chant: Hydroblast debuffs the ATK of every enemy in the chanter's lane
	# until the end of the enemy's next turn and Knocks them Back away from
	# the chanter, stopping at the board edge or an occupied cell.
	var aquanaut := {
		"id": 404, "side": 0, "name": "The Aquanaut", "kind": "Artillerist",
		"row": 1, "col": 2, "atk": 3, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {
			"name": "Hydroblast", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Hydroblast"]
		}
	}
	var hydro_foe := {
		"id": 405, "side": 1, "name": "Hydro Foe", "kind": "Warden",
		"row": 1, "col": 4, "atk": 4, "hp": 8, "max_hp": 8, "effects": []
	}
	var hydro_blocker := {
		"id": 406, "side": 1, "name": "Hydro Blocker", "kind": "Duelist",
		"row": 1, "col": 5, "atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var hydro_other_lane := {
		"id": 407, "side": 1, "name": "Other Lane Hydro Foe", "kind": "Strider",
		"row": 2, "col": 4, "atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	var hydro_units := [aquanaut, hydro_foe, hydro_blocker, hydro_other_lane]
	var hydro_results := UnitSkillsScript.resolve_chants(0, hydro_units)
	assert(hydro_results.size() == 1)
	assert(hydro_results[0].affected == [405, 406])
	assert(hydro_foe.atk == 3 and hydro_blocker.atk == 2)
	# The foe is blocked by the blocker and stays; the blocker slides to col 6.
	assert(hydro_foe.col == 4 and hydro_blocker.col == 6)
	assert(hydro_results[0].moved.size() == 2)
	assert(hydro_other_lane.atk == 3 and hydro_other_lane.col == 4)
	assert(not hydro_other_lane.has("effects") or hydro_other_lane.effects.is_empty())
	assert(UnitSkillsScript.resolve_chants(1, hydro_units).is_empty())
	# The debuff lifts at the end of the enemy's next turn.
	ConductorSkillsScript.expire_effects(hydro_units, 1)
	assert(hydro_foe.atk == 4 and hydro_blocker.atk == 3)
	# Level scaling: a level-5 chanter debuffs 3 ATK and Knocks Back 3 spaces.
	var hydronaut := {
		"id": 408, "side": 0, "name": "The Hydronaut", "kind": "Artillerist",
		"row": 0, "col": 0, "atk": 4, "hp": 7, "max_hp": 7, "effects": [], "level": 5,
		"skill": UnitCatalogScript.by_name("The Hydronaut").skill.to_dict()
	}
	var hydro_veteran_foe := {
		"id": 409, "side": 1, "name": "Veteran Hydro Foe", "kind": "Warden",
		"row": 0, "col": 3, "atk": 5, "hp": 9, "max_hp": 9, "effects": []
	}
	var hydro_veteran_results := UnitSkillsScript.resolve_chants(
		0, [hydronaut, hydro_veteran_foe]
	)
	assert(hydro_veteran_results.size() == 1)
	assert(hydro_veteran_foe.atk == 2 and hydro_veteran_foe.col == 6)

	# Chant: Roguish Snare is a deployment trap that fires at the start of
	# the OPPOSING side's turn, Stunning that side's most recently deployed
	# unit (the `last_placed_id` argument) for 2 turns with a rank-scaled
	# chance of permanent Poison. Only the first living carrier triggers.
	var thief := {
		"id": 410, "side": 0, "name": "Thief", "kind": "Strider",
		"row": 0, "col": 1, "atk": 2, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {
			"name": "Roguish Snare", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Roguish Snare"]
		}
	}
	var cutpurse := {
		"id": 411, "side": 0, "name": "Cutpurse", "kind": "Strider",
		"row": 1, "col": 1, "atk": 2, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {
			"name": "Roguish Snare", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Roguish Snare"]
		}
	}
	var snare_fresh := {
		"id": 412, "side": 1, "name": "Fresh Recruit", "kind": "Warden",
		"row": 0, "col": 5, "atk": 3, "hp": 8, "max_hp": 8, "effects": []
	}
	var snare_veteran := {
		"id": 413, "side": 1, "name": "Old Guard", "kind": "Duelist",
		"row": 1, "col": 4, "atk": 4, "hp": 7, "max_hp": 7, "effects": []
	}
	var snare_units := [thief, cutpurse, snare_fresh, snare_veteran]
	# Nothing fires on the snare owner's own turn, when the opponent has
	# placed nothing yet, or when the id names a unit of the wrong side.
	assert(UnitSkillsScript.resolve_chants(0, snare_units, "start", null, -1.0, 412).is_empty())
	assert(UnitSkillsScript.resolve_chants(1, snare_units, "start", null, -1.0, -1).is_empty())
	assert(UnitSkillsScript.resolve_chants(1, snare_units, "start", null, -1.0, 410).is_empty())
	# At the start of side 1's turn the trap springs on its most recent
	# deployment (412), not the earlier one (413). Roll 0.0 beats the 20%
	# level-1 chance, so the Poison lands and never expires.
	var snare_results := UnitSkillsScript.resolve_chants(
		1, snare_units, "start", null, 0.0, 412
	)
	assert(snare_results.size() == 1, "Two carriers must not stack two snares.")
	assert(snare_results[0].affected == [412])
	assert("Stuns" in snare_results[0].message)
	assert(snare_fresh.stun_turns == 2 and BattleRulesScript.is_stunned(snare_fresh))
	assert(snare_fresh.poison_turns == UnitSkillsScript.PERMANENT_POISON_TURNS)
	assert(snare_fresh.poison_damage == 1)
	assert(snare_veteran.get("stun_turns", 0) == 0)
	# The permanent Poison ticks damage but never counts down.
	var snare_status := UnitSkillsScript.resolve_start_statuses(1, snare_units)
	assert(snare_status.size() == 1 and snare_fresh.hp == 7)
	assert(snare_fresh.poison_turns == UnitSkillsScript.PERMANENT_POISON_TURNS)
	# The Stun lasts two of the victim's side turns.
	UnitSkillsScript.expire_statuses(snare_units, 1)
	assert(snare_fresh.stun_turns == 1 and BattleRulesScript.is_stunned(snare_fresh))
	UnitSkillsScript.expire_statuses(snare_units, 1)
	assert(snare_fresh.stun_turns == 0 and not BattleRulesScript.is_stunned(snare_fresh))
	# A roll above the chance still Stuns but does not Poison.
	var snare_miss := UnitSkillsScript.resolve_chants(
		1, snare_units, "start", null, 0.99, 413
	)
	assert(snare_miss.size() == 1 and snare_miss[0].affected == [413])
	assert(snare_veteran.stun_turns == 2 and snare_veteran.get("poison_turns", 0) == 0)
	# With the first carrier dead, the next living one springs the trap; the
	# level-5 rank row is a 100% chance, so even a 0.99 roll Poisons.
	thief.hp = 0
	cutpurse.level = 5
	var snare_max := UnitSkillsScript.resolve_chants(
		1, snare_units, "start", null, 0.99, 413
	)
	assert(snare_max.size() == 1)
	assert(snare_veteran.poison_turns == UnitSkillsScript.PERMANENT_POISON_TURNS)
	# With every carrier dead the trap cannot fire.
	cutpurse.hp = 0
	assert(UnitSkillsScript.resolve_chants(
		1, snare_units, "start", null, 0.0, 412
	).is_empty())

	# Chant: Wrangle grants Protect to every ally behind the chanter and
	# debuffs the ATK of every enemy in front of it, across all lanes.
	# "Behind"/"in front" are column-relative: side 0 advances toward
	# higher columns, so behind = lower column, in front = higher column;
	# units in the chanter's own column are neither.
	var frontier_rider := {
		"id": 420, "side": 0, "name": "Frontier Rider", "kind": "Artillerist",
		"row": 1, "col": 3, "atk": 2, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {
			"name": "Wrangle", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Wrangle"]
		}
	}
	var wrangle_ally_behind := {
		"id": 421, "side": 0, "name": "Rear Ally", "kind": "Warden",
		"row": 2, "col": 1, "atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var wrangle_ally_ahead := {
		"id": 422, "side": 0, "name": "Front Ally", "kind": "Duelist",
		"row": 1, "col": 5, "atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var wrangle_ally_beside := {
		"id": 423, "side": 0, "name": "Flank Ally", "kind": "Strider",
		"row": 0, "col": 3, "atk": 2, "hp": 4, "max_hp": 4, "effects": []
	}
	var wrangle_foe_front := {
		"id": 424, "side": 1, "name": "Front Foe", "kind": "Warden",
		"row": 0, "col": 4, "atk": 4, "hp": 8, "max_hp": 8, "effects": []
	}
	var wrangle_foe_behind := {
		"id": 425, "side": 1, "name": "Rear Foe", "kind": "Strider",
		"row": 1, "col": 2, "atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	var wrangle_units := [
		frontier_rider, wrangle_ally_behind, wrangle_ally_ahead,
		wrangle_ally_beside, wrangle_foe_front, wrangle_foe_behind
	]
	var wrangle_results := UnitSkillsScript.resolve_chants(0, wrangle_units)
	assert(wrangle_results.size() == 1)
	# Cross-lane: the rear ally is in lane 3, the front foe in lane 1.
	assert(wrangle_results[0].affected == [421, 424])
	assert(wrangle_ally_behind.protect_turns == 1)
	assert(wrangle_ally_ahead.get("protect_turns", 0) == 0)
	assert(wrangle_ally_beside.get("protect_turns", 0) == 0)
	assert(frontier_rider.get("protect_turns", 0) == 0)
	assert(wrangle_foe_front.atk == 3 and wrangle_foe_front.effects.size() == 1)
	assert(wrangle_foe_behind.atk == 3 and wrangle_foe_behind.effects.is_empty())
	assert(UnitSkillsScript.resolve_chants(1, wrangle_units).is_empty())
	assert(UnitSkillsScript.resolve_chants(0, wrangle_units, "end").is_empty())
	# The level-1 debuff lasts one enemy turn, mirroring Hydroblast.
	ConductorSkillsScript.expire_effects(wrangle_units, 1)
	assert(wrangle_foe_front.atk == 4 and wrangle_foe_front.effects.is_empty())
	# Level scaling: the level-5 rank row is 2-turn Protect, -3 ATK, 2 turns.
	var frontier_protector := {
		"id": 426, "side": 0, "name": "Frontier Protector", "kind": "Artillerist",
		"row": 0, "col": 2, "atk": 3, "hp": 5, "max_hp": 5, "effects": [], "level": 5,
		"skill": UnitCatalogScript.by_name("Frontier Protector").skill.to_dict()
	}
	var wrangle_veteran_ally := {
		"id": 427, "side": 0, "name": "Veteran Rear Ally", "kind": "Warden",
		"row": 0, "col": 1, "atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var wrangle_veteran_foe := {
		"id": 428, "side": 1, "name": "Veteran Front Foe", "kind": "Duelist",
		"row": 2, "col": 5, "atk": 5, "hp": 7, "max_hp": 7, "effects": []
	}
	var wrangle_veteran_units := [
		frontier_protector, wrangle_veteran_ally, wrangle_veteran_foe
	]
	var wrangle_veteran_results := UnitSkillsScript.resolve_chants(
		0, wrangle_veteran_units
	)
	assert(wrangle_veteran_results.size() == 1)
	assert(wrangle_veteran_results[0].affected == [427, 428])
	assert(wrangle_veteran_ally.protect_turns == 2)
	assert(wrangle_veteran_foe.atk == 2)
	# The 2-turn debuff survives the first enemy expiry and lifts at the second.
	ConductorSkillsScript.expire_effects(wrangle_veteran_units, 1)
	assert(wrangle_veteran_foe.atk == 2 and wrangle_veteran_foe.effects.size() == 1)
	ConductorSkillsScript.expire_effects(wrangle_veteran_units, 1)
	assert(wrangle_veteran_foe.atk == 5 and wrangle_veteran_foe.effects.is_empty())
	# A dead chanter resolves nothing.
	frontier_protector.hp = 0
	assert(UnitSkillsScript.resolve_chants(0, wrangle_veteran_units).is_empty())

	# Warcry: Divine Silence locks a target enemy's secondary skill for a
	# rank-scaled number of that unit's side turns (the "enemy turns" of the
	# reference text, counted from the caster's perspective). While Silenced,
	# none of the unit's skill timing hooks fire; movement, attacks, and
	# Conductor skills are unaffected.
	var lunnain_oracle := {
		"id": 440, "side": 0, "name": "Lunnain Oracle", "kind": "Lifebinder",
		"row": 1, "col": 0, "atk": 2, "hp": 5, "max_hp": 5, "effects": [], "level": 3,
		"skill": {
			"name": "Divine Silence", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Divine Silence"]
		}
	}
	var silenced_chanter := {
		"id": 441, "side": 1, "name": "Silenced Chanter", "kind": "Channeler",
		"row": 0, "col": 5, "atk": 2, "hp": 4, "max_hp": 4, "effects": [],
		"skill": {
			"name": "Sundering Smash", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Sundering Smash"]
		}
	}
	var silence_smash_target := {
		"id": 442, "side": 0, "name": "Smash Target", "kind": "Duelist",
		"row": 0, "col": 2, "atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var silence_plain_foe := {
		"id": 443, "side": 1, "name": "Skill-less Foe", "kind": "Warden",
		"row": 2, "col": 5, "atk": 5, "hp": 9, "max_hp": 9, "effects": []
	}
	var silence_units := [
		lunnain_oracle, silenced_chanter, silence_smash_target, silence_plain_foe
	]
	assert(UnitSkillsScript.rank_value(
		UnitCatalogScript.by_name("Lunnain Oracle").skill.to_dict(), 1, 0, 1
	) == 1)
	assert(UnitSkillsScript.rank_value(
		UnitCatalogScript.by_name("Lunnain Oracle").skill.to_dict(), 5, 0, 1
	) == 5)
	# Level 3 reads the third rank row: 3 turns.
	var silence_result := UnitSkillsScript.resolve_warcry(
		lunnain_oracle, silence_units, 441
	)
	assert(silence_result.affected == [441])
	assert(silenced_chanter.silenced_turns == 3)
	assert(UnitSkillsScript.is_silenced(silenced_chanter))
	assert("Silenced (3 turns)" in ConductorSkillsScript.effect_summary(silenced_chanter))
	# A unit without a secondary skill is never Silenced.
	assert(not silence_plain_foe.has("silenced_turns"))
	# The AI fallback picks the skill-bearing enemy over the higher-ATK
	# skill-less one, and picks nobody when no enemy carries a skill.
	var silence_fallback := UnitSkillsScript.resolve_warcry(lunnain_oracle, silence_units)
	assert(silence_fallback.affected == [441])
	assert(silenced_chanter.silenced_turns == 3)
	assert(UnitSkillsScript.resolve_warcry(
		lunnain_oracle, [lunnain_oracle, silence_plain_foe]
	).affected.is_empty())
	assert(silence_plain_foe.get("silenced_turns", 0) == 0)
	# Chants do not fire while the chanter is Silenced.
	assert(UnitSkillsScript.resolve_chants(1, silence_units).is_empty())
	# Silence ticks down in the same expiry pass as Immobilise, at the end of
	# the silenced unit's own side turns, so it lasts exactly N of them.
	UnitSkillsScript.expire_statuses(silence_units, 0)
	assert(silenced_chanter.silenced_turns == 3)
	UnitSkillsScript.expire_statuses(silence_units, 1)
	assert(silenced_chanter.silenced_turns == 2)
	UnitSkillsScript.expire_statuses(silence_units, 1)
	UnitSkillsScript.expire_statuses(silence_units, 1)
	assert(silenced_chanter.silenced_turns == 0)
	assert(not UnitSkillsScript.is_silenced(silenced_chanter))
	# The chant fires again once the Silence expires.
	var silence_chant_results := UnitSkillsScript.resolve_chants(1, silence_units)
	assert(silence_chant_results.size() == 1)
	assert(silence_smash_target.hp == 5)
	# Strike and Reaction are gated the same way and recover on expiry.
	var silenced_striker := {
		"id": 444, "side": 1, "name": "Silenced Striker", "kind": "Strider",
		"atk": 3, "hp": 4, "max_hp": 4, "effects": [], "silenced_turns": 1,
		"skill": {"name": "Poison Strike", "type": "Strike"}
	}
	assert(UnitSkillsScript.resolve_strike(
		silenced_striker, silence_smash_target, silence_units, 0.0
	).message.is_empty())
	assert(silence_smash_target.get("poison_turns", 0) == 0)
	silenced_striker.silenced_turns = 0
	assert(not UnitSkillsScript.resolve_strike(
		silenced_striker, silence_smash_target, silence_units, 0.0
	).message.is_empty())
	assert(silence_smash_target.poison_turns == 2)
	var silenced_reactor := {
		"id": 445, "side": 1, "name": "Silenced Reactor", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": [], "silenced_turns": 1,
		"skill": {"name": "Shield Wall", "type": "Reaction"}
	}
	var silence_attacker := {
		"id": 446, "side": 0, "name": "Attacker", "kind": "Duelist",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	assert(UnitSkillsScript.resolve_reaction(
		silenced_reactor, silence_attacker, silence_units, 0.0
	).message.is_empty())
	assert(silenced_reactor.get("protect_turns", 0) == 0)
	silenced_reactor.silenced_turns = 0
	assert(not UnitSkillsScript.resolve_reaction(
		silenced_reactor, silence_attacker, silence_units, 0.0
	).message.is_empty())
	assert(silenced_reactor.protect_turns == 2)
	# A Silenced Warcry carrier does not trigger its skill.
	var silenced_medic := {
		"id": 447, "side": 1, "name": "Silenced Medic", "kind": "Lifebinder",
		"atk": 1, "hp": 3, "max_hp": 3, "effects": [], "silenced_turns": 1,
		"skill": {"name": "Mend", "type": "Warcry"}
	}
	assert(UnitSkillsScript.resolve_warcry(
		silenced_medic, silence_units + [silenced_medic]
	).message.is_empty())
	# A Silenced aura source stops contributing: the buff drops while the
	# Silence holds and returns when it expires.
	var silenced_empress := {
		"id": 448, "side": 0, "name": "Silenced Empress", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Moonlight", "type": "Aura"}
	}
	var silence_aura_ally := {
		"id": 449, "side": 0, "name": "Aura Ally", "kind": "Warden",
		"atk": 2, "hp": 4, "max_hp": 4, "effects": []
	}
	var silence_aura_units := [silenced_empress, silence_aura_ally]
	var silence_aura_events: Array = []
	UnitSkillsScript.refresh_auras(silence_aura_units, silence_aura_events)
	assert(silence_aura_ally.max_hp == 8)
	silenced_empress.silenced_turns = 1
	UnitSkillsScript.refresh_auras(silence_aura_units, silence_aura_events)
	assert(silence_aura_ally.max_hp == 4)
	assert(silence_aura_events[-1].unit_id == 449 and silence_aura_events[-1].delta == -4)
	silenced_empress.silenced_turns = 0
	UnitSkillsScript.refresh_auras(silence_aura_units, silence_aura_events)
	assert(silence_aura_ally.max_hp == 8)
	# A Silenced Roguish Snare carrier does not spring the trap.
	var silenced_thief := {
		"id": 450, "side": 1, "name": "Silenced Thief", "kind": "Strider",
		"row": 0, "col": 4, "atk": 2, "hp": 5, "max_hp": 5, "effects": [],
		"silenced_turns": 1,
		"skill": {
			"name": "Roguish Snare", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Roguish Snare"]
		}
	}
	var snare_silence_victim := {
		"id": 451, "side": 0, "name": "Snare Victim", "kind": "Warden",
		"row": 0, "col": 1, "atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var snare_silence_units := [silenced_thief, snare_silence_victim]
	assert(UnitSkillsScript.resolve_chants(
		0, snare_silence_units, "start", null, 0.0, 451
	).is_empty())
	assert(snare_silence_victim.get("stun_turns", 0) == 0)
	silenced_thief.silenced_turns = 0
	assert(UnitSkillsScript.resolve_chants(
		0, snare_silence_units, "start", null, 0.0, 451
	).size() == 1)
	assert(snare_silence_victim.stun_turns == 2)

	# Chant (end): Cattle of Ra Knocks Back every Taunted enemy, Immobilises
	# it and debuffs its ATK for 1 enemy turn; non-Taunted and allied units
	# are ignored.
	var ra := {
		"id": 430, "side": 0, "name": "Ra", "kind": "Warden",
		"row": 0, "col": 3, "atk": 2, "hp": 10, "max_hp": 10, "effects": [],
		"skill": {
			"name": "Cattle of Ra", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Cattle of Ra"]
		}
	}
	var cattle_taunted_foe := {
		"id": 431, "side": 1, "name": "Taunted Foe", "kind": "Duelist",
		"row": 0, "col": 5, "atk": 4, "hp": 6, "max_hp": 6, "effects": [],
		"taunt_turns": 2
	}
	var cattle_plain_foe := {
		"id": 432, "side": 1, "name": "Plain Foe", "kind": "Strider",
		"row": 1, "col": 5, "atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	var cattle_taunted_ally := {
		"id": 433, "side": 0, "name": "Taunted Ally", "kind": "Warden",
		"row": 2, "col": 4, "atk": 2, "hp": 8, "max_hp": 8, "effects": [],
		"taunt_turns": 2
	}
	var cattle_units := [
		ra, cattle_taunted_foe, cattle_plain_foe, cattle_taunted_ally
	]
	# It is an end-of-turn chant: the start phase and the opposing side's own
	# end phase resolve nothing.
	assert(UnitSkillsScript.resolve_chants(0, cattle_units, "start").is_empty())
	assert(UnitSkillsScript.resolve_chants(1, cattle_units, "end").is_empty())
	var cattle_results := UnitSkillsScript.resolve_chants(0, cattle_units, "end")
	assert(cattle_results.size() == 1)
	assert(cattle_results[0].affected == [431])
	assert(cattle_results[0].moved.size() == 1)
	# The Taunted enemy slides one space away from the chanter and is
	# Immobilised and debuffed for 1 enemy turn; everyone else is untouched.
	assert(cattle_taunted_foe.col == 6)
	assert(cattle_taunted_foe.immobilized_turns == 1)
	assert(cattle_taunted_foe.atk == 3 and cattle_taunted_foe.effects.size() == 1)
	assert(cattle_plain_foe.col == 5 and cattle_plain_foe.atk == 3)
	assert(cattle_plain_foe.get("immobilized_turns", 0) == 0)
	assert(cattle_taunted_ally.col == 4 and cattle_taunted_ally.atk == 2)
	assert(cattle_taunted_ally.get("immobilized_turns", 0) == 0)
	# Both the debuff and the Immobilise lift at the end of the enemy's turn.
	ConductorSkillsScript.expire_effects(cattle_units, 1)
	UnitSkillsScript.expire_statuses(cattle_units, 1)
	assert(cattle_taunted_foe.atk == 4 and cattle_taunted_foe.effects.is_empty())
	assert(cattle_taunted_foe.immobilized_turns == 0)
	# A dead chanter resolves nothing.
	ra.hp = 0
	assert(UnitSkillsScript.resolve_chants(0, cattle_units, "end").is_empty())
	# Level scaling: the level-5 rank row Knocks Back 3 spaces and debuffs
	# 3 ATK.
	var ra_creator := {
		"id": 434, "side": 0, "name": "Ra, Creator", "kind": "Warden",
		"row": 0, "col": 2, "atk": 3, "hp": 11, "max_hp": 11, "effects": [],
		"level": 5,
		"skill": UnitCatalogScript.by_name("Ra, Creator").skill.to_dict()
	}
	var cattle_veteran_foe := {
		"id": 435, "side": 1, "name": "Veteran Taunted Foe", "kind": "Warden",
		"row": 0, "col": 3, "atk": 5, "hp": 9, "max_hp": 9, "effects": [],
		"taunt_turns": 1
	}
	var cattle_veteran_results := UnitSkillsScript.resolve_chants(
		0, [ra_creator, cattle_veteran_foe], "end"
	)
	assert(cattle_veteran_results.size() == 1)
	assert(cattle_veteran_foe.col == 6)
	assert(cattle_veteran_foe.atk == 2)
	assert(cattle_veteran_foe.immobilized_turns == 1)

	# Chant (start): Stone Gaze Poisons one random living non-Poisoned enemy
	# for a rank-scaled number of enemy turns, then Stuns up to {1} Poisoned
	# enemies in front of the chanter (the Wrangle column rule, cross-lane) for
	# 1 enemy turn. An enemy Poisoned by the first part can be Stunned by the
	# second.
	assert(UnitSkillsScript.rank_value(
		UnitCatalogScript.by_name("Medusa").skill.to_dict(), 1, 0, 1
	) == 1)
	assert(UnitSkillsScript.rank_value(
		UnitCatalogScript.by_name("Medusa").skill.to_dict(), 5, 0, 1
	) == 3)
	assert(UnitSkillsScript.rank_value(
		UnitCatalogScript.by_name("Medusa").skill.to_dict(), 5, 1, 1
	) == 3)
	var medusa := {
		"id": 460, "side": 0, "name": "Medusa", "kind": "Channeler",
		"row": 0, "col": 3, "atk": 3, "hp": 9, "max_hp": 9, "effects": [],
		"skill": {
			"name": "Stone Gaze", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Stone Gaze"]
		}
	}
	var gaze_fresh_foe := {
		"id": 461, "side": 1, "name": "Fresh Foe", "kind": "Duelist",
		"row": 1, "col": 5, "atk": 4, "hp": 6, "max_hp": 6, "effects": []
	}
	var gaze_poisoned_foe := {
		"id": 462, "side": 1, "name": "Poisoned Foe", "kind": "Warden",
		"row": 2, "col": 4, "atk": 2, "hp": 8, "max_hp": 8, "effects": [],
		"poison_turns": 2, "poison_damage": 1
	}
	var gaze_rear_foe := {
		"id": 463, "side": 1, "name": "Rear Foe", "kind": "Strider",
		"row": 0, "col": 1, "atk": 3, "hp": 5, "max_hp": 5, "effects": [],
		"poison_turns": 2, "poison_damage": 1
	}
	var gaze_beside_foe := {
		"id": 464, "side": 1, "name": "Flank Foe", "kind": "Warden",
		"row": 2, "col": 3, "atk": 2, "hp": 8, "max_hp": 8, "effects": [],
		"poison_turns": 2, "poison_damage": 1
	}
	var gaze_units := [
		medusa, gaze_fresh_foe, gaze_poisoned_foe, gaze_rear_foe, gaze_beside_foe
	]
	# It is a start-of-turn chant: the end phase and the opposing side's own
	# start phase resolve nothing.
	assert(UnitSkillsScript.resolve_chants(0, gaze_units, "end").is_empty())
	assert(UnitSkillsScript.resolve_chants(1, gaze_units).is_empty())
	# The level-1 rank row Poisons for 1 enemy turn and Stuns up to 1 enemy.
	var gaze_results := UnitSkillsScript.resolve_chants(0, gaze_units)
	assert(gaze_results.size() == 1)
	# The only non-Poisoned enemy is the forced random pick: it is Poisoned for
	# 1 enemy turn and, standing in front, is also the single Stun target.
	assert(gaze_results[0].affected == [461])
	assert(gaze_fresh_foe.poison_turns == 1)
	assert(gaze_fresh_foe.poison_damage == 1)
	assert(gaze_fresh_foe.stun_turns == 1)
	# The level-1 cap of 1 Stun leaves the other Poisoned in-front enemy alone,
	# and Poisoned enemies behind or in the chanter's own column are untouched.
	assert(gaze_poisoned_foe.get("stun_turns", 0) == 0)
	assert(gaze_poisoned_foe.poison_turns == 2)
	assert(gaze_rear_foe.get("stun_turns", 0) == 0)
	assert(gaze_beside_foe.get("stun_turns", 0) == 0)
	# The Stun lasts 1 enemy turn; the Poison ticks at the enemy's turn start.
	UnitSkillsScript.expire_statuses(gaze_units, 1)
	assert(gaze_fresh_foe.stun_turns == 0)
	var gaze_status := UnitSkillsScript.resolve_start_statuses(1, gaze_units)
	assert(gaze_status.size() == 4)
	assert(gaze_fresh_foe.hp == 5 and gaze_fresh_foe.poison_turns == 0)
	# A dead or Silenced chanter resolves nothing.
	medusa.hp = 0
	assert(UnitSkillsScript.resolve_chants(0, gaze_units).is_empty())
	medusa.hp = 9
	medusa.silenced_turns = 1
	assert(UnitSkillsScript.resolve_chants(0, gaze_units).is_empty())
	medusa.silenced_turns = 0
	# With no non-Poisoned enemy the first part no-ops: nobody is re-Poisoned,
	# but an in-front Poisoned enemy is still Stunned.
	var gaze_no_fresh_foe := {
		"id": 465, "side": 1, "name": "Still Poisoned Foe", "kind": "Duelist",
		"row": 0, "col": 5, "atk": 3, "hp": 6, "max_hp": 6, "effects": [],
		"poison_turns": 2, "poison_damage": 1
	}
	var gaze_noop_results := UnitSkillsScript.resolve_chants(
		0, [medusa, gaze_no_fresh_foe]
	)
	assert(gaze_noop_results.size() == 1)
	assert("Poisons" not in gaze_noop_results[0].message)
	assert("Stuns" in gaze_noop_results[0].message)
	assert(gaze_noop_results[0].affected == [465])
	assert(gaze_no_fresh_foe.stun_turns == 1)
	assert(gaze_no_fresh_foe.poison_turns == 2)
	# Level scaling: the level-5 rank row Poisons for 3 enemy turns and Stuns
	# up to 3 in-front Poisoned enemies.
	var gorgon_medusa := {
		"id": 466, "side": 0, "name": "Gorgon Medusa", "kind": "Channeler",
		"row": 1, "col": 3, "atk": 4, "hp": 10, "max_hp": 10, "effects": [],
		"level": 5,
		"skill": UnitCatalogScript.by_name("Gorgon Medusa").skill.to_dict()
	}
	var gaze_vet_fresh := {
		"id": 467, "side": 1, "name": "Veteran Fresh Foe", "kind": "Duelist",
		"row": 0, "col": 5, "atk": 4, "hp": 6, "max_hp": 6, "effects": []
	}
	var gaze_vet_poisoned_a := {
		"id": 468, "side": 1, "name": "Veteran Poisoned Foe", "kind": "Warden",
		"row": 1, "col": 4, "atk": 2, "hp": 8, "max_hp": 8, "effects": [],
		"poison_turns": 1, "poison_damage": 1
	}
	var gaze_vet_poisoned_b := {
		"id": 469, "side": 1, "name": "Veteran Far Foe", "kind": "Strider",
		"row": 2, "col": 6, "atk": 3, "hp": 5, "max_hp": 5, "effects": [],
		"poison_turns": 1, "poison_damage": 1
	}
	var gaze_vet_results := UnitSkillsScript.resolve_chants(
		0, [gorgon_medusa, gaze_vet_fresh, gaze_vet_poisoned_a, gaze_vet_poisoned_b]
	)
	assert(gaze_vet_results.size() == 1)
	assert(gaze_vet_results[0].affected == [467, 468, 469])
	assert(gaze_vet_fresh.poison_turns == 3)
	assert(gaze_vet_fresh.stun_turns == 1)
	assert(gaze_vet_poisoned_a.stun_turns == 1)
	assert(gaze_vet_poisoned_b.stun_turns == 1)

	# Reaction: Hopping Mad counters the attacker for fixed damage, but only
	# while the defender survives the attack.
	var bethany := {
		"id": 108, "side": 1, "name": "Bethany", "kind": "Artillerist",
		"atk": 4, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Hopping Mad", "type": "Reaction"}
	}
	var reaction_attacker := {
		"id": 109, "side": 0, "name": "Attacker", "kind": "Duelist",
		"atk": 3, "hp": 7, "max_hp": 7, "effects": []
	}
	var reaction_result := UnitSkillsScript.resolve_reaction(
		bethany, reaction_attacker, [bethany, reaction_attacker]
	)
	assert(reaction_result.affected == [109])
	assert(reaction_attacker.hp == 4)
	assert("attacks back" in reaction_result.message)
	assert(UnitSkillsScript.resolve_reaction(
		reaction_attacker, bethany, [bethany, reaction_attacker]
	).message.is_empty())
	bethany.hp = 0
	assert(UnitSkillsScript.resolve_reaction(
		bethany, reaction_attacker, [bethany, reaction_attacker]
	).message.is_empty())
	assert(reaction_attacker.hp == 4)

	# Reaction: Shield Wall has a level-based chance to grant the defender
	# Protect, which blocks all damage until it expires.
	var shield_waller := {
		"id": 116, "side": 1, "name": "Commune Defender", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": [],
		"skill": {
			"name": "Shield Wall", "type": "Reaction",
			"rank_values": UnitCatalogScript.RANK_VALUES["Shield Wall"]
		}
	}
	var wall_attacker := {
		"id": 117, "side": 0, "name": "Wall Attacker", "kind": "Duelist",
		"atk": 3, "hp": 7, "max_hp": 7, "effects": []
	}
	var wall_result := UnitSkillsScript.resolve_reaction(
		shield_waller, wall_attacker, [shield_waller, wall_attacker], 0.39
	)
	assert(wall_result.affected == [116])
	assert(shield_waller.protect_turns == 2)
	assert("Protect" in wall_result.message)
	assert(UnitSkillsScript.resolve_reaction(
		shield_waller, wall_attacker, [shield_waller, wall_attacker], 0.40
	).message.is_empty())
	var blocked_hit := BattleSimulatorScript.apply_unit_damage(shield_waller, 3)
	assert(blocked_hit.damage == 0 and blocked_hit.protected)
	assert(shield_waller.hp == 8)
	UnitSkillsScript.expire_statuses([shield_waller], 1)
	assert(shield_waller.protect_turns == 1)
	UnitSkillsScript.expire_statuses([shield_waller], 1)
	assert(shield_waller.protect_turns == 0)
	assert(BattleSimulatorScript.apply_unit_damage(shield_waller, 3).damage == 3)
	assert(shield_waller.hp == 5)

	# Warcry: Freeze! damages and Immobilises enemy Scouts and Fighters in the
	# target lane; other classes and lanes are untouched.
	var frost_mage := {
		"id": 118, "side": 0, "name": "Frost-Kid Kokori", "kind": "Channeler",
		"row": 0, "atk": 3, "hp": 7, "max_hp": 7, "effects": [],
		"skill": {
			"name": "Freeze!", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Freeze!"]
		}
	}
	var frost_scout := {
		"id": 119, "side": 1, "name": "Frost Scout", "kind": "Strider",
		"row": 2, "atk": 3, "hp": 4, "max_hp": 4, "effects": []
	}
	var frost_fighter := {
		"id": 120, "side": 1, "name": "Frost Fighter", "kind": "Duelist",
		"row": 2, "atk": 4, "hp": 6, "max_hp": 6, "effects": []
	}
	var frost_warden := {
		"id": 121, "side": 1, "name": "Frost Warden", "kind": "Warden",
		"row": 2, "atk": 2, "hp": 9, "max_hp": 9, "effects": []
	}
	var frost_other_lane := {
		"id": 122, "side": 1, "name": "Other Lane Scout", "kind": "Strider",
		"row": 1, "atk": 3, "hp": 4, "max_hp": 4, "effects": []
	}
	var frost_units := [
		frost_mage, frost_scout, frost_fighter, frost_warden, frost_other_lane
	]
	var frost_result := UnitSkillsScript.resolve_warcry(
		frost_mage, frost_units, -1, null, 2
	)
	assert(frost_result.affected == [119, 120])
	assert(frost_scout.hp == 3 and frost_scout.immobilized_turns == 1)
	assert(frost_fighter.hp == 5 and frost_fighter.immobilized_turns == 1)
	assert(frost_warden.hp == 9 and not frost_warden.has("immobilized_turns"))
	assert(frost_other_lane.hp == 4)
	# Without a chosen lane the AI fallback picks the lane with eligible enemies.
	frost_scout.immobilized_turns = 0
	frost_fighter.immobilized_turns = 0
	var frost_fallback := UnitSkillsScript.resolve_warcry(frost_mage, frost_units)
	assert(frost_fallback.affected == [119, 120])
	assert(frost_scout.hp == 2 and frost_fighter.hp == 4)
	# An enemy that dies to the damage is not Immobilised.
	frost_scout.hp = 1
	frost_scout.immobilized_turns = 0
	UnitSkillsScript.resolve_warcry(frost_mage, frost_units, -1, null, 2)
	assert(frost_scout.hp == 0 and frost_scout.immobilized_turns == 0)

	# Strike: Weakening Strike has a level-based chance to cut the attacked
	# enemy's ATK for a few turns.
	var swiftblade := {
		"id": 123, "side": 0, "name": "Mata Swiftblade", "kind": "Strider",
		"atk": 3, "hp": 4, "max_hp": 4, "effects": [],
		"skill": {
			"name": "Weakening Strike", "type": "Strike",
			"rank_values": UnitCatalogScript.RANK_VALUES["Weakening Strike"]
		}
	}
	var weaken_target := {
		"id": 124, "side": 1, "name": "Weaken Target", "kind": "Duelist",
		"atk": 5, "hp": 6, "max_hp": 6, "effects": []
	}
	assert(not UnitSkillsScript.resolve_strike(
		swiftblade, weaken_target, [], 0.59
	).message.is_empty())
	assert(weaken_target.atk == 4)
	assert(UnitSkillsScript.resolve_strike(
		swiftblade, weaken_target, [], 0.60
	).message.is_empty())
	assert(weaken_target.atk == 4)
	ConductorSkillsScript.expire_effects([weaken_target], 1)
	ConductorSkillsScript.expire_effects([weaken_target], 1)
	assert(weaken_target.atk == 5)

	# Warcry: Protect grants a chosen allied unit Protect for a level-scaled
	# duration; without a chosen target the AI fallback shields the lowest-HP
	# ally, and Protect blocks all damage while it lasts.
	var protector := {
		"id": 130, "side": 0, "name": "LDF Constable", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": [],
		"skill": {
			"name": "Protect", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Protect"]
		}
	}
	var protect_ally := {
		"id": 131, "side": 0, "name": "Frail Ally", "kind": "Channeler",
		"atk": 3, "hp": 3, "max_hp": 6, "effects": []
	}
	var protect_other := {
		"id": 132, "side": 0, "name": "Sturdy Ally", "kind": "Duelist",
		"atk": 3, "hp": 7, "max_hp": 7, "effects": []
	}
	var protect_units := [protector, protect_ally, protect_other]
	var protect_result := UnitSkillsScript.resolve_warcry(protector, protect_units, 132)
	assert(protect_result.affected == [132])
	assert(protect_other.protect_turns == 2)
	assert("Protect" in protect_result.message)
	var protect_fallback := UnitSkillsScript.resolve_warcry(protector, protect_units)
	assert(protect_fallback.affected == [131])
	assert(protect_ally.protect_turns == 2)
	assert(BattleSimulatorScript.apply_unit_damage(protect_ally, 4).protected)
	assert(protect_ally.hp == 3)
	UnitSkillsScript.expire_statuses(protect_units, 0)
	assert(protect_ally.protect_turns == 1)

	# Warcry: Royal Flush grants every allied unit in the chosen lane Protect
	# for a level-scaled duration; the AI fallback picks the lane holding the
	# most living allies, and enemies in the lane are ignored.
	var hearts := {
		"id": 400, "side": 0, "name": "Three of Hearts", "kind": "Warden",
		"row": 0, "atk": 1, "hp": 8, "max_hp": 8, "effects": [], "level": 5,
		"skill": {
			"name": "Royal Flush", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Royal Flush"]
		}
	}
	var flush_mate := {
		"id": 401, "side": 0, "name": "Lane Ally", "kind": "Duelist",
		"row": 1, "atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var flush_second := {
		"id": 402, "side": 0, "name": "Second Lane Ally", "kind": "Strider",
		"row": 1, "atk": 2, "hp": 5, "max_hp": 5, "effects": []
	}
	var flush_enemy := {
		"id": 403, "side": 1, "name": "Lane Enemy", "kind": "Warden",
		"row": 1, "atk": 3, "hp": 8, "max_hp": 8, "effects": []
	}
	var flush_units := [hearts, flush_mate, flush_second, flush_enemy]
	var flush_result := UnitSkillsScript.resolve_warcry(
		hearts, flush_units, -1, null, 0
	)
	assert(flush_result.affected == [400])
	assert(hearts.protect_turns == 6)
	assert(not flush_mate.has("protect_turns"))
	var flush_fallback := UnitSkillsScript.resolve_warcry(hearts, flush_units)
	assert(flush_fallback.affected == [401, 402])
	assert(flush_mate.protect_turns == 6 and flush_second.protect_turns == 6)
	assert(not flush_enemy.has("protect_turns"))
	assert(BattleSimulatorScript.apply_unit_damage(flush_mate, 3).protected)
	assert(flush_mate.hp == 6)

	# Warcry: Woolen Blanket heals the chosen ally for a level-scaled amount
	# (overhealing like Mend) and grants it Protect for a level-scaled
	# duration; the AI fallback picks the lowest-HP ally, and a Silenced
	# caster does not trigger.
	var shepherd := {
		"id": 500, "side": 0, "name": "Jimimi the Shepherd", "kind": "Lifebinder",
		"row": 0, "atk": 3, "hp": 4, "max_hp": 4, "effects": [], "level": 5,
		"skill": {
			"name": "Woolen Blanket", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Woolen Blanket"]
		}
	}
	var blanket_hurt := {
		"id": 501, "side": 0, "name": "Hurt Ally", "kind": "Duelist",
		"row": 1, "atk": 3, "hp": 2, "max_hp": 6, "effects": []
	}
	var blanket_full := {
		"id": 502, "side": 0, "name": "Full Ally", "kind": "Strider",
		"row": 2, "atk": 2, "hp": 5, "max_hp": 5, "effects": []
	}
	var blanket_units := [shepherd, blanket_hurt, blanket_full]
	# Level 5 row: +4 HP and Protect for 3 turns.
	var blanket_result := UnitSkillsScript.resolve_warcry(
		shepherd, blanket_units, 501
	)
	assert(blanket_result.affected == [501])
	assert(blanket_hurt.hp == 6 and blanket_hurt.protect_turns == 3)
	assert(not blanket_full.has("protect_turns"))
	# The heal overheals past max HP, mirroring Mend.
	var blanket_overheal := UnitSkillsScript.resolve_warcry(
		shepherd, blanket_units, 502
	)
	assert(blanket_overheal.affected == [502])
	assert(blanket_full.hp == 9 and blanket_full.protect_turns == 3)
	# Without a chosen target the AI fallback picks the lowest-HP ally.
	var blanket_fallback := UnitSkillsScript.resolve_warcry(shepherd, blanket_units)
	assert(blanket_fallback.affected == [501])
	assert(blanket_hurt.hp == 10)
	# A Silenced caster's Woolen Blanket does not trigger.
	shepherd.silenced_turns = 1
	var blanket_silenced := UnitSkillsScript.resolve_warcry(
		shepherd, blanket_units, 501
	)
	assert(blanket_silenced.affected.is_empty() and blanket_silenced.message.is_empty())
	assert(blanket_hurt.hp == 10)
	shepherd.silenced_turns = 0

	# Warcry: Shadowbind cuts the ATK of every living enemy in the target lane
	# and Immobilises them for a level-scaled duration; other lanes are
	# untouched, the AI fallback picks the highest-value enemy lane, and a
	# Silenced caster does not trigger.
	var edge := {
		"id": 510, "side": 0, "name": "Edge", "kind": "Strider",
		"row": 0, "atk": 2, "hp": 5, "max_hp": 5, "effects": [], "level": 5,
		"skill": {
			"name": "Shadowbind", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Shadowbind"]
		}
	}
	var bind_foe_a := {
		"id": 511, "side": 1, "name": "Bound Foe A", "kind": "Duelist",
		"row": 1, "atk": 4, "hp": 6, "max_hp": 6, "effects": []
	}
	var bind_foe_b := {
		"id": 512, "side": 1, "name": "Bound Foe B", "kind": "Artillerist",
		"row": 1, "atk": 5, "hp": 4, "max_hp": 4, "effects": []
	}
	var bind_other_lane := {
		"id": 513, "side": 1, "name": "Other Lane Foe", "kind": "Warden",
		"row": 2, "atk": 5, "hp": 8, "max_hp": 8, "effects": []
	}
	var bind_units := [edge, bind_foe_a, bind_foe_b, bind_other_lane]
	# Level 5 row: -4 ATK and Immobilise for 3 turns.
	var bind_result := UnitSkillsScript.resolve_warcry(
		edge, bind_units, -1, null, 1
	)
	assert(bind_result.affected == [511, 512])
	assert(bind_foe_a.atk == 0 and bind_foe_a.immobilized_turns == 3)
	assert(bind_foe_b.atk == 1 and bind_foe_b.immobilized_turns == 3)
	assert(bind_other_lane.atk == 5 and not bind_other_lane.has("immobilized_turns"))
	assert("Shadowbind" in bind_result.message)
	# The Immobilise ticks down on the enemy side's expiry pass and the ATK
	# debuff expires with its effect timer.
	UnitSkillsScript.expire_statuses(bind_units, 1)
	assert(bind_foe_a.immobilized_turns == 2)
	ConductorSkillsScript.expire_effects(bind_units, 1)
	ConductorSkillsScript.expire_effects(bind_units, 1)
	ConductorSkillsScript.expire_effects(bind_units, 1)
	assert(bind_foe_a.atk == 4 and bind_foe_b.atk == 5)
	assert(bind_foe_a.effects.is_empty())
	# A Silenced caster's Shadowbind does not trigger.
	edge.silenced_turns = 1
	var bind_silenced := UnitSkillsScript.resolve_warcry(edge, bind_units, -1, null, 1)
	assert(bind_silenced.affected.is_empty() and bind_silenced.message.is_empty())
	assert(bind_foe_a.atk == 4)
	edge.silenced_turns = 0
	# Without a chosen lane the AI fallback picks the lane worth the most
	# enemy ATK (lane 1: 9 ATK over two units beats lane 2's single 5 ATK).
	bind_foe_a.immobilized_turns = 0
	var bind_fallback := UnitSkillsScript.resolve_warcry(edge, bind_units)
	assert(bind_fallback.affected == [511, 512])
	assert(bind_foe_a.atk == 0 and bind_foe_a.immobilized_turns == 3)
	assert(bind_other_lane.atk == 5 and not bind_other_lane.has("immobilized_turns"))

	# Warcry: Fireball damages a chosen enemy and splashes orthogonally
	# adjacent enemies; the AI fallback hits the highest-HP enemy.
	var dragon := {
		"id": 133, "side": 0, "name": "Raging Dragon", "kind": "Channeler",
		"row": 0, "col": 0, "atk": 5, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {
			"name": "Fireball", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Fireball"]
		}
	}
	var fire_target := {
		"id": 134, "side": 1, "name": "Burned Enemy", "kind": "Warden",
		"row": 1, "col": 3, "atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var fire_adjacent := {
		"id": 135, "side": 1, "name": "Splashed Enemy", "kind": "Duelist",
		"row": 1, "col": 4, "atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	var fire_diagonal := {
		"id": 136, "side": 1, "name": "Diagonal Enemy", "kind": "Strider",
		"row": 2, "col": 4, "atk": 3, "hp": 4, "max_hp": 4, "effects": []
	}
	var fire_units := [dragon, fire_target, fire_adjacent, fire_diagonal]
	var fire_result := UnitSkillsScript.resolve_warcry(dragon, fire_units, 134)
	assert(fire_result.affected == [134, 135])
	assert(fire_target.hp == 7)
	assert(fire_adjacent.hp == 4)
	assert(fire_diagonal.hp == 4)
	var fire_fallback := UnitSkillsScript.resolve_warcry(dragon, fire_units)
	assert(fire_fallback.affected[0] == 134)
	assert(fire_target.hp == 6)

	# Warcry: Warrior's Vigour buffs the lowest-HP allied Defender or Fighter;
	# other classes are ignored and the buff expires with its timer.
	var yeoman := {
		"id": 137, "side": 0, "name": "Royal Yeoman", "kind": "Duelist",
		"atk": 2, "hp": 4, "max_hp": 4, "effects": [],
		"skill": {
			"name": "Warrior's Vigour", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Warrior's Vigour"]
		}
	}
	var vigour_warden := {
		"id": 138, "side": 0, "name": "Hurt Warden", "kind": "Warden",
		"atk": 2, "hp": 3, "max_hp": 6, "effects": []
	}
	var vigour_mage := {
		"id": 139, "side": 0, "name": "Hurt Mage", "kind": "Channeler",
		"atk": 3, "hp": 1, "max_hp": 5, "effects": []
	}
	var vigour_result := UnitSkillsScript.resolve_warcry(
		yeoman, [yeoman, vigour_warden, vigour_mage]
	)
	assert(vigour_result.affected == [138])
	assert(vigour_warden.hp == 5 and vigour_warden.max_hp == 8)
	assert(vigour_warden.atk == 3)
	assert(vigour_mage.hp == 1 and vigour_mage.atk == 3)
	ConductorSkillsScript.expire_effects([vigour_warden], 0)
	ConductorSkillsScript.expire_effects([vigour_warden], 0)
	assert(vigour_warden.atk == 2)
	assert(vigour_warden.max_hp == 6 and vigour_warden.hp == 5)
	# With no eligible Defender or Fighter ally the Warcry does nothing.
	assert(UnitSkillsScript.resolve_warcry(
		yeoman, [yeoman, vigour_mage]
	).message.is_empty())

	# Status: Regen heals 1 HP at the start of the unit's side turn and ticks down.
	var regen_carrier := {
		"id": 140, "side": 0, "name": "Regen Carrier", "kind": "Warden",
		"atk": 2, "hp": 3, "max_hp": 6, "effects": [], "regen_turns": 2
	}
	var regen_results := UnitSkillsScript.resolve_start_statuses(0, [regen_carrier])
	assert(regen_results.size() == 1 and regen_results[0].label == "REGEN")
	assert(regen_carrier.hp == 4 and regen_carrier.regen_turns == 1)

	# Reaction: Grit has a level-based chance to grant Regen after being attacked.
	var gritter := {
		"id": 141, "side": 1, "name": "Pub Barman", "kind": "Warden",
		"atk": 2, "hp": 7, "max_hp": 7, "effects": [],
		"skill": {
			"name": "Grit", "type": "Reaction",
			"rank_values": UnitCatalogScript.RANK_VALUES["Grit"]
		}
	}
	var grit_attacker := {
		"id": 142, "side": 0, "name": "Grit Attacker", "kind": "Duelist",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	var grit_result := UnitSkillsScript.resolve_reaction(
		gritter, grit_attacker, [gritter, grit_attacker], 0.39
	)
	assert(grit_result.affected == [141])
	assert(gritter.regen_turns == 2)
	assert(UnitSkillsScript.resolve_reaction(
		gritter, grit_attacker, [gritter, grit_attacker], 0.40
	).message.is_empty())

	# Warcry: Prune/New Look/Medic! cleanse Immobilise from a class-matched ally
	# and grant Regen; the AI fallback picks the lowest-HP ally of the class.
	var prune_actor := {
		"id": 143, "side": 0, "name": "The Botanist", "kind": "Lifebinder",
		"atk": 2, "hp": 4, "max_hp": 4, "effects": [],
		"skill": {
			"name": "Prune", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Prune"]
		}
	}
	var prune_mage := {
		"id": 144, "side": 0, "name": "Pinned Mage", "kind": "Channeler",
		"atk": 3, "hp": 4, "max_hp": 4, "effects": [], "immobilized_turns": 2
	}
	var prune_warden := {
		"id": 145, "side": 0, "name": "Pinned Warden", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": [], "immobilized_turns": 2
	}
	var prune_units := [prune_actor, prune_mage, prune_warden]
	var prune_result := UnitSkillsScript.resolve_warcry(prune_actor, prune_units)
	assert(prune_result.affected == [144])
	assert(prune_mage.immobilized_turns == 0 and prune_mage.regen_turns == 2)
	assert(prune_warden.immobilized_turns == 2)
	# A chosen target of the wrong class is rejected and the fallback applies.
	var prune_wrong := UnitSkillsScript.resolve_warcry(prune_actor, prune_units, 145)
	assert(prune_wrong.affected == [144])
	var medic_actor := {
		"id": 146, "side": 0, "name": "Rescue Corps", "kind": "Lifebinder",
		"atk": 3, "hp": 4, "max_hp": 4, "effects": [],
		"skill": {
			"name": "Medic!", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Medic!"]
		}
	}
	var medic_result := UnitSkillsScript.resolve_warcry(
		medic_actor, [medic_actor, prune_mage, prune_warden]
	)
	assert(medic_result.affected == [145])
	assert(prune_warden.immobilized_turns == 0 and prune_warden.regen_turns == 2)
	var stylist_actor := {
		"id": 147, "side": 0, "name": "Selina the Stylist", "kind": "Strider",
		"atk": 2, "hp": 4, "max_hp": 4, "effects": [],
		"skill": {
			"name": "New Look", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["New Look"]
		}
	}
	var pinned_gunner := {
		"id": 148, "side": 0, "name": "Pinned Gunner", "kind": "Artillerist",
		"atk": 3, "hp": 3, "max_hp": 3, "effects": [], "immobilized_turns": 1
	}
	var look_result := UnitSkillsScript.resolve_warcry(
		stylist_actor, [stylist_actor, pinned_gunner, prune_warden]
	)
	assert(look_result.affected == [148])
	assert(pinned_gunner.immobilized_turns == 0 and pinned_gunner.regen_turns == 2)

	# Chant (start): Lifestream grants all allies Regen and cleanses Immobilise.
	var witch_doctor := {
		"id": 149, "side": 0, "name": "The Witch Doctor", "kind": "Lifebinder",
		"atk": 2, "hp": 7, "max_hp": 7, "effects": [],
		"skill": {
			"name": "Lifestream", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Lifestream"]
		}
	}
	var lifestream_ally := {
		"id": 150, "side": 0, "name": "Sick Ally", "kind": "Duelist",
		"atk": 2, "hp": 5, "max_hp": 5, "effects": [], "immobilized_turns": 3
	}
	var lifestream_results := UnitSkillsScript.resolve_chants(
		0, [witch_doctor, lifestream_ally]
	)
	assert(lifestream_results.size() == 1)
	assert(witch_doctor.regen_turns == 2 and lifestream_ally.regen_turns == 2)
	assert(lifestream_ally.immobilized_turns == 0)

	# Strike: Caber Toss knocks the target back, stopping at the board edge and
	# at occupied cells.
	var hamish := {
		"id": 151, "side": 0, "name": "Hamish Highlander", "kind": "Warden",
		"row": 0, "col": 2, "atk": 1, "hp": 7, "max_hp": 7, "effects": [],
		"skill": {
			"name": "Caber Toss", "type": "Strike",
			"rank_values": UnitCatalogScript.RANK_VALUES["Caber Toss"]
		}
	}
	var caber_target := {
		"id": 152, "side": 1, "name": "Tossed Enemy", "kind": "Duelist",
		"row": 0, "col": 4, "atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	var caber_blocker := {
		"id": 153, "side": 1, "name": "Blocking Enemy", "kind": "Warden",
		"row": 0, "col": 6, "atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var caber_result := UnitSkillsScript.resolve_strike(
		hamish, caber_target, [hamish, caber_target, caber_blocker], 0.29
	)
	assert(caber_result.affected == [152])
	assert(caber_target.col == 5) # col 6 is occupied, so the toss stops early
	assert(caber_result.moved[0].from_col == 4)
	assert(hamish.regen_turns == 1)
	assert(UnitSkillsScript.resolve_strike(
		hamish, caber_target, [hamish, caber_target, caber_blocker], 0.30
	).message.is_empty() or hamish.regen_turns == 1)

	# Reaction: Ambient Pressure can grant permanent ATK and Regen.
	var barney := {
		"id": 154, "side": 1, "name": "Deep Sea Barney", "kind": "Warden",
		"atk": 0, "hp": 8, "max_hp": 8, "effects": [],
		"skill": {
			"name": "Ambient Pressure", "type": "Reaction",
			"rank_values": UnitCatalogScript.RANK_VALUES["Ambient Pressure"]
		}
	}
	var pressure_result := UnitSkillsScript.resolve_reaction(
		barney, grit_attacker, [barney, grit_attacker], 0.59
	)
	assert(pressure_result.affected == [154])
	assert(barney.atk == 1 and barney.regen_turns == 1)
	assert(UnitSkillsScript.resolve_reaction(
		barney, grit_attacker, [barney, grit_attacker], 0.60
	).message.is_empty())

	# Strike: Cannon Barrage hits enemies outside the attacker's lane.
	var basilic := {
		"id": 155, "side": 0, "name": "Crewman Basilic", "kind": "Artillerist",
		"row": 0, "col": 1, "atk": 4, "hp": 9, "max_hp": 9, "effects": [],
		"skill": {
			"name": "Cannon Barrage", "type": "Strike",
			"rank_values": UnitCatalogScript.RANK_VALUES["Cannon Barrage"]
		}
	}
	var barrage_lane_foe := {
		"id": 156, "side": 1, "name": "Lane Foe", "kind": "Warden",
		"row": 0, "col": 4, "atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var barrage_far_foe := {
		"id": 157, "side": 1, "name": "Far Foe", "kind": "Duelist",
		"row": 1, "col": 4, "atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	var barrage_result := UnitSkillsScript.resolve_strike(
		basilic, barrage_lane_foe, [basilic, barrage_lane_foe, barrage_far_foe], 0.39
	)
	assert(barrage_result.affected == [157])
	assert(barrage_far_foe.hp == 3 and barrage_lane_foe.hp == 8)
	assert(basilic.regen_turns == 2)

	# Warcry: Guard Protects the whole team; at max rank it always adds Regen.
	var oro := {
		"id": 158, "side": 0, "name": "Oro the Enlightened", "kind": "Lifebinder",
		"atk": 2, "hp": 4, "max_hp": 4, "effects": [], "level": 5,
		"skill": {
			"name": "Guard", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Guard"]
		}
	}
	var guard_ally := {
		"id": 159, "side": 0, "name": "Guard Ally", "kind": "Duelist",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	var guard_result := UnitSkillsScript.resolve_warcry(oro, [oro, guard_ally])
	assert(guard_result.affected == [158, 159])
	assert(oro.protect_turns == 3 and guard_ally.protect_turns == 3)
	assert(oro.regen_turns == 2 and guard_ally.regen_turns == 2)

	# Strike: Pincer Drain only fires against an Immobilised target.
	var cara := {
		"id": 160, "side": 0, "name": "Cara Pace", "kind": "Strider",
		"atk": 0, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {
			"name": "Pincer Drain", "type": "Strike",
			"rank_values": UnitCatalogScript.RANK_VALUES["Pincer Drain"]
		}
	}
	var pincer_target := {
		"id": 161, "side": 1, "name": "Pinned Target", "kind": "Warden",
		"atk": 2, "hp": 6, "max_hp": 6, "effects": [], "immobilized_turns": 1
	}
	var pincer_result := UnitSkillsScript.resolve_strike(
		cara, pincer_target, [cara, pincer_target], 0.29
	)
	assert(pincer_result.affected == [160])
	assert(cara.atk == 1 and cara.regen_turns == 1)
	var free_target := {
		"id": 162, "side": 1, "name": "Free Target", "kind": "Warden",
		"atk": 2, "hp": 6, "max_hp": 6, "effects": []
	}
	assert(UnitSkillsScript.resolve_strike(
		cara, free_target, [cara, free_target], 0.29
	).message.is_empty())

	# Strike: Slash Speed knocks back the target plus the highest-ATK other enemy.
	var clair := {
		"id": 163, "side": 0, "name": "Clair", "kind": "Duelist",
		"row": 1, "col": 2, "atk": 4, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {
			"name": "Slash Speed", "type": "Strike",
			"rank_values": UnitCatalogScript.RANK_VALUES["Slash Speed"]
		}
	}
	var slash_target := {
		"id": 164, "side": 1, "name": "Slashed Enemy", "kind": "Warden",
		"row": 1, "col": 3, "atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var slash_other := {
		"id": 165, "side": 1, "name": "Strong Enemy", "kind": "Duelist",
		"row": 0, "col": 3, "atk": 6, "hp": 5, "max_hp": 5, "effects": []
	}
	var slash_weak := {
		"id": 166, "side": 1, "name": "Weak Enemy", "kind": "Strider",
		"row": 2, "col": 3, "atk": 1, "hp": 4, "max_hp": 4, "effects": []
	}
	var slash_result := UnitSkillsScript.resolve_strike(
		clair, slash_target, [clair, slash_target, slash_other, slash_weak], 0.39
	)
	assert(slash_result.affected == [164, 165])
	assert(slash_target.col == 5 and slash_other.col == 5)
	assert(slash_weak.col == 3)
	assert(clair.regen_turns == 1)

	# Chant (start): Mighty Guard Protects and Regens the team, then the doom
	# timer defeats the caster after the listed number of enemy turns.
	var white_mage := {
		"id": 167, "side": 0, "name": "White Mage", "kind": "Lifebinder",
		"atk": 2, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {
			"name": "Mighty Guard", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Mighty Guard"]
		}
	}
	var mighty_units := [white_mage, guard_ally]
	var mighty_results := UnitSkillsScript.resolve_chants(0, mighty_units)
	assert(mighty_results.size() == 1)
	assert(white_mage.protect_turns == 2 and white_mage.regen_turns == 2)
	assert(white_mage.doom_turns == 1)
	UnitSkillsScript.expire_statuses(mighty_units, 0)
	assert(white_mage.hp > 0) # the caster's own turn does not tick doom
	UnitSkillsScript.expire_statuses(mighty_units, 1)
	assert(white_mage.hp == 0)

	# Chant (start): Ocean's Reclaim cleanses Immobilise and Stun from random
	# other allies and grants Regen.
	var steph := {
		"id": 168, "side": 0, "name": "Steph Lopod", "kind": "Channeler",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {
			"name": "Ocean's Reclaim", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Ocean's Reclaim"]
		}
	}
	var reclaim_ally := {
		"id": 169, "side": 0, "name": "Snared Ally", "kind": "Duelist",
		"atk": 2, "hp": 5, "max_hp": 5, "effects": [],
		"immobilized_turns": 2, "stun_turns": 1
	}
	var reclaim_results := UnitSkillsScript.resolve_chants(0, [steph, reclaim_ally])
	assert(reclaim_results.size() == 1 and reclaim_results[0].affected == [169])
	assert(reclaim_ally.immobilized_turns == 0 and reclaim_ally.stun_turns == 0)
	assert(reclaim_ally.regen_turns == 2)

	# Reaction: Tide Turn Taunts the attacker and can grant Regen.
	var ant := {
		"id": 170, "side": 1, "name": "Ant Lantis", "kind": "Warden",
		"atk": 1, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {
			"name": "Tide Turn", "type": "Reaction",
			"rank_values": UnitCatalogScript.RANK_VALUES["Tide Turn"]
		}
	}
	var tide_result := UnitSkillsScript.resolve_reaction(
		ant, grit_attacker, [ant, grit_attacker], 0.19
	)
	assert(grit_attacker.taunt_turns == 1 and ant.regen_turns == 1)
	assert(BattleRulesScript.is_taunted(grit_attacker, [ant, grit_attacker]))
	grit_attacker.taunt_turns = 0
	ant.regen_turns = 0
	UnitSkillsScript.resolve_reaction(ant, grit_attacker, [ant, grit_attacker], 0.20)
	assert(ant.regen_turns == 0)

	# Reaction: Yield! knocks the attacker back and Immobilises it.
	var ki := {
		"id": 171, "side": 1, "name": "Ki", "kind": "Warden",
		"row": 0, "col": 3, "atk": 2, "hp": 7, "max_hp": 7, "effects": [],
		"skill": {
			"name": "Yield!", "type": "Reaction",
			"rank_values": UnitCatalogScript.RANK_VALUES["Yield!"]
		}
	}
	var yield_attacker := {
		"id": 172, "side": 0, "name": "Charging Attacker", "kind": "Duelist",
		"row": 0, "col": 2, "atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	var yield_result := UnitSkillsScript.resolve_reaction(
		ki, yield_attacker, [ki, yield_attacker], 0.29
	)
	assert(yield_result.affected.has(172))
	assert(yield_attacker.col == 0)
	assert(yield_attacker.immobilized_turns == 2)
	assert(ki.regen_turns == 1)

	# Chant (end): Impairing Joust and Galatine's Ground only resolve in the end
	# phase; Galatine's Ground Stuns, and Stun blocks activation and movement.
	var rook := {
		"id": 173, "side": 0, "name": "The Rook", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": [],
		"skill": {
			"name": "Impairing Joust", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Impairing Joust"]
		}
	}
	var gawain := {
		"id": 174, "side": 0, "name": "Gawain the Just", "kind": "Duelist",
		"atk": 2, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {
			"name": "Galatine's Ground", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Galatine's Ground"]
		}
	}
	var taunted_foe := {
		"id": 175, "side": 1, "name": "Taunted Foe", "kind": "Duelist",
		"row": 0, "col": 4, "move": 2, "range": 1, "atk": 3, "hp": 5, "max_hp": 5,
		"effects": [], "taunt_turns": 1, "ready": true
	}
	var joust_units := [rook, gawain, taunted_foe]
	assert(UnitSkillsScript.resolve_chants(0, joust_units, "start").is_empty())
	var joust_results := UnitSkillsScript.resolve_chants(0, joust_units, "end", null, 0.29)
	assert(joust_results.size() == 2)
	assert(taunted_foe.immobilized_turns == 1)
	assert(taunted_foe.stun_turns == 1)
	assert(rook.regen_turns == 3 and gawain.regen_turns == 3)
	var stun_sim := BattleSimulator.new()
	assert(stun_sim.activation_order(1, joust_units).is_empty())
	assert(BattleRulesScript.traversal_cells(taunted_foe, joust_units).is_empty())
	assert(not BattleRulesScript.can_reposition(taunted_foe, 1, joust_units))
	UnitSkillsScript.expire_statuses(joust_units, 1)
	assert(taunted_foe.stun_turns == 0)

	# Chant (start): Blossom's Bloom buffs only allies carrying Regen, for 1 turn.
	var sakura := {
		"id": 176, "side": 0, "name": "Sakura", "kind": "Channeler",
		"atk": 2, "hp": 7, "max_hp": 7, "effects": [],
		"skill": {
			"name": "Blossom's Bloom", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Blossom's Bloom"]
		}
	}
	var bloom_ally := {
		"id": 177, "side": 0, "name": "Regen Ally", "kind": "Duelist",
		"atk": 2, "hp": 5, "max_hp": 5, "effects": [], "regen_turns": 1
	}
	var bloom_plain := {
		"id": 178, "side": 0, "name": "Plain Ally", "kind": "Duelist",
		"atk": 2, "hp": 5, "max_hp": 5, "effects": []
	}
	var bloom_units := [sakura, bloom_ally, bloom_plain]
	var bloom_results := UnitSkillsScript.resolve_chants(0, bloom_units)
	assert(bloom_results.size() == 1 and bloom_results[0].affected == [177])
	assert(bloom_ally.atk == 3 and bloom_plain.atk == 2)
	ConductorSkillsScript.expire_effects(bloom_units, 0)
	assert(bloom_ally.atk == 2)

	# Warcry + end phase: Sun Festival counts down, then heals all allies and
	# grants Regen carriers ATK and Haste (Haste adds +1 movement).
	var inti := {
		"id": 179, "side": 0, "name": "Inti Chihuan", "kind": "Lifebinder",
		"row": 0, "col": 0, "move": 1, "range": 2, "atk": 1, "hp": 3, "max_hp": 4,
		"effects": [],
		"skill": {
			"name": "Sun Festival", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Sun Festival"]
		}
	}
	var festival_ally := {
		"id": 180, "side": 0, "name": "Festive Ally", "kind": "Duelist",
		"row": 1, "col": 0, "move": 2, "range": 1, "atk": 2, "hp": 4, "max_hp": 6,
		"effects": [], "regen_turns": 1
	}
	var festival_units := [inti, festival_ally]
	var festival_warcry := UnitSkillsScript.resolve_warcry(inti, festival_units)
	assert(not festival_warcry.message.is_empty())
	assert(inti.festival_turns == 2)
	assert(UnitSkillsScript.resolve_chants(0, festival_units, "end").is_empty())
	assert(inti.festival_turns == 1)
	var festival_results := UnitSkillsScript.resolve_chants(0, festival_units, "end")
	assert(festival_results.size() == 1)
	assert(inti.hp == 4 and festival_ally.hp == 6)
	assert(festival_ally.atk == 3 and festival_ally.haste_turns == 1)
	assert(inti.get("haste_turns", 0) == 0) # Inti carries no Regen
	assert(BattleRulesScript.traversal_cells(festival_ally, festival_units).size() == 3)
	UnitSkillsScript.expire_statuses(festival_units, 0)
	assert(festival_ally.haste_turns == 0)

	# Strike: Trisha's Prospect steals Protect from the enemy team for its allies.
	var hohenheim := {
		"id": 181, "side": 0, "name": "Van Hohenheim", "kind": "Lifebinder",
		"atk": 1, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {
			"name": "Trisha's Prospect", "type": "Strike",
			"rank_values": UnitCatalogScript.RANK_VALUES["Trisha's Prospect"]
		}
	}
	var prospect_target := {
		"id": 182, "side": 1, "name": "Shielded Enemy", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": [], "protect_turns": 2
	}
	var prospect_other_foe := {
		"id": 183, "side": 1, "name": "Also Shielded", "kind": "Duelist",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": [], "protect_turns": 1
	}
	var prospect_units := [hohenheim, prospect_target, prospect_other_foe]
	var prospect_result := UnitSkillsScript.resolve_strike(
		hohenheim, prospect_target, prospect_units
	)
	assert(prospect_result.affected == [181])
	assert(prospect_target.protect_turns == 0 and prospect_other_foe.protect_turns == 0)
	assert(hohenheim.protect_turns == 2 and hohenheim.regen_turns == 2)
	# Without Protect on the target nothing happens.
	assert(UnitSkillsScript.resolve_strike(
		hohenheim, prospect_target, prospect_units
	).message.is_empty())

	# Reaction: Tag-Team buffs the highest-ATK other ally and can self-Regen.
	var furia := {
		"id": 184, "side": 0, "name": "Furia Rojo", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": [],
		"skill": {
			"name": "Tag-Team", "type": "Reaction",
			"rank_values": UnitCatalogScript.RANK_VALUES["Tag-Team"]
		}
	}
	var tag_partner := {
		"id": 185, "side": 0, "name": "Partner", "kind": "Duelist",
		"atk": 5, "hp": 4, "max_hp": 4, "effects": []
	}
	var tag_result := UnitSkillsScript.resolve_reaction(
		furia, grit_attacker, [furia, tag_partner, grit_attacker], 0.19
	)
	assert(tag_result.affected.has(185))
	assert(tag_partner.atk == 6 and furia.regen_turns == 1)

	# Strike: the Brother skills check the board for their sibling by name.
	var yuuya := {
		"id": 186, "side": 0, "name": "Yuuya Sakazaki", "kind": "Artillerist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {
			"name": "Hurtful Brother", "type": "Strike",
			"rank_values": UnitCatalogScript.RANK_VALUES["Hurtful Brother"]
		}
	}
	var sakuya := {
		"id": 187, "side": 0, "name": "Sakuya Le Bel Shirogane", "kind": "Channeler",
		"atk": 4, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {
			"name": "Heartful Brother", "type": "Strike",
			"rank_values": UnitCatalogScript.RANK_VALUES["Heartful Brother"]
		}
	}
	var brother_foe := {
		"id": 188, "side": 1, "name": "Brother Foe", "kind": "Warden",
		"atk": 3, "hp": 8, "max_hp": 8, "effects": []
	}
	# Hurtful Brother: allies gain HP; the Regen rider needs Sakuya on the board.
	var hurtful_result := UnitSkillsScript.resolve_strike(
		yuuya, brother_foe, [yuuya, brother_foe]
	)
	assert(hurtful_result.affected == [186])
	assert(yuuya.hp == 7 and yuuya.max_hp == 7)
	assert(yuuya.get("regen_turns", 0) == 0)
	var hurtful_sakuya := UnitSkillsScript.resolve_strike(
		yuuya, brother_foe, [yuuya, sakuya, brother_foe]
	)
	assert(hurtful_sakuya.affected == [186, 187])
	assert(yuuya.regen_turns == 2 and sakuya.regen_turns == 2)
	ConductorSkillsScript.expire_effects([yuuya, sakuya], 0)
	assert(yuuya.max_hp == 8) # both +1 HP stacks still active
	ConductorSkillsScript.expire_effects([yuuya, sakuya], 0)
	assert(yuuya.max_hp == 6 and yuuya.hp == 6) # both stacks expired together
	# Heartful Brother: enemies lose ATK; the Vulnerable rider needs Yuuya.
	yuuya.hp = 6
	var heartful_result := UnitSkillsScript.resolve_strike(
		sakuya, brother_foe, [sakuya, brother_foe]
	)
	assert(heartful_result.affected == [188])
	assert(brother_foe.atk == 2)
	assert(brother_foe.get("vulnerable_turns", 0) == 0)
	var heartful_yuuya := UnitSkillsScript.resolve_strike(
		sakuya, brother_foe, [sakuya, yuuya, brother_foe]
	)
	assert(brother_foe.atk == 1 and brother_foe.vulnerable_turns == 2)
	assert("Yuuya" in heartful_yuuya.message)

	# Aura: Moonlight raises allied current and max HP while the source lives.
	var empress := {
		"id": 110, "side": 0, "name": "Final Empress", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Moonlight", "type": "Aura"}
	}
	var moonlit_ally := {
		"id": 111, "side": 0, "name": "Moonlit Ally", "kind": "Warden",
		"atk": 2, "hp": 4, "max_hp": 8, "effects": []
	}
	var moonlit_foe := {
		"id": 112, "side": 1, "name": "Foe", "kind": "Strider",
		"atk": 2, "hp": 5, "max_hp": 5, "effects": []
	}
	var aura_units := [empress, moonlit_ally, moonlit_foe]
	var aura_events: Array = []
	UnitSkillsScript.refresh_auras(aura_units, aura_events)
	assert(aura_events.size() == 1)
	assert(aura_events[0].unit_id == 111 and aura_events[0].delta == 4)
	assert(aura_events[0].label == "Moonlight")
	assert(moonlit_ally.hp == 8 and moonlit_ally.max_hp == 12)
	assert(empress.hp == 6 and empress.max_hp == 6)
	assert(moonlit_foe.hp == 5 and moonlit_foe.max_hp == 5)
	# Refreshing while the source lives is idempotent and reports no changes.
	aura_events.clear()
	UnitSkillsScript.refresh_auras(aura_units, aura_events)
	assert(aura_events.is_empty())
	assert(moonlit_ally.hp == 8 and moonlit_ally.max_hp == 12)
	# The buff disappears when the source leaves the board.
	UnitSkillsScript.refresh_auras([moonlit_ally, moonlit_foe], aura_events)
	assert(aura_events.size() == 1)
	assert(aura_events[0].unit_id == 111 and aura_events[0].delta == -4)
	assert(aura_events[0].label == "Moonlight")
	assert(moonlit_ally.hp == 4 and moonlit_ally.max_hp == 8)
	# Losing the aura never kills: HP bottoms out at 1.
	UnitSkillsScript.refresh_auras(aura_units)
	moonlit_ally.hp = 2
	UnitSkillsScript.refresh_auras([moonlit_ally, moonlit_foe])
	assert(moonlit_ally.hp == 1 and moonlit_ally.max_hp == 8)
	# Two sources stack, aura units buff each other, and level scales the aura.
	var opelle := {
		"id": 113, "side": 0, "name": "Opelle", "kind": "Lifebinder",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": [], "level": 2,
		"skill": UnitCatalogScript.by_name("Opelle").skill.to_dict()
	}
	UnitSkillsScript.refresh_auras(aura_units + [opelle])
	assert(moonlit_ally.hp == 10 and moonlit_ally.max_hp == 17)
	assert(empress.max_hp == 11 and opelle.max_hp == 9)

	# Aura: Inspire Lambkin grants OTHER allied Lambkin +{0} max HP and +{1}
	# ATK; non-Lambkin allies and the source itself are unaffected.
	var inspire_skill: Dictionary = UnitCatalogScript.by_name("Claw Minstrel").skill.to_dict()
	assert(UnitSkillsScript.rank_value(inspire_skill, 1, 0, 1) == 1)
	assert(UnitSkillsScript.rank_value(inspire_skill, 1, 1, 1) == 1)
	assert(UnitSkillsScript.rank_value(inspire_skill, 5, 0, 1) == 4)
	assert(UnitSkillsScript.rank_value(inspire_skill, 5, 1, 1) == 2)
	var minstrel := {
		"id": 120, "side": 0, "name": "Claw Minstrel", "kind": "Lifebinder",
		"atk": 2, "hp": 3, "max_hp": 3, "effects": [], "race": "lambkin",
		"skill": inspire_skill
	}
	var lambkin_ally := {
		"id": 121, "side": 0, "name": "Flame Warden", "kind": "Lifebinder",
		"atk": 2, "hp": 3, "max_hp": 5, "effects": [], "race": "lambkin"
	}
	var human_ally := {
		"id": 122, "side": 0, "name": "Human Ally", "kind": "Warden",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [], "race": "human"
	}
	var inspire_units := [minstrel, lambkin_ally, human_ally]
	var inspire_events: Array = []
	UnitSkillsScript.refresh_auras(inspire_units, inspire_events)
	assert(inspire_events.size() == 2)
	assert(inspire_events[0].unit_id == 121 and inspire_events[0].delta == 1)
	assert(inspire_events[0].label == "Inspire Lambkin")
	assert(inspire_events[0].stat == "HP")
	assert(inspire_events[1].unit_id == 121 and inspire_events[1].delta == 1)
	assert(inspire_events[1].stat == "ATK")
	assert(lambkin_ally.max_hp == 6 and lambkin_ally.hp == 4)
	assert(lambkin_ally.atk == 3)
	assert(minstrel.max_hp == 3 and minstrel.atk == 2)
	assert(human_ally.max_hp == 6 and human_ally.atk == 3)
	# Refreshing while the source lives is idempotent.
	inspire_events.clear()
	UnitSkillsScript.refresh_auras(inspire_units, inspire_events)
	assert(inspire_events.is_empty())
	assert(lambkin_ally.max_hp == 6 and lambkin_ally.atk == 3)
	# Both buffs drop when the source dies.
	minstrel.hp = 0
	UnitSkillsScript.refresh_auras(inspire_units, inspire_events)
	assert(lambkin_ally.max_hp == 5 and lambkin_ally.atk == 2)
	# Both buffs drop while the source is Silenced and return when it expires.
	minstrel.hp = 3
	minstrel.silenced_turns = 1
	UnitSkillsScript.refresh_auras(inspire_units, inspire_events)
	assert(lambkin_ally.max_hp == 5 and lambkin_ally.atk == 2)
	minstrel.silenced_turns = 0
	UnitSkillsScript.refresh_auras(inspire_units, inspire_events)
	assert(lambkin_ally.max_hp == 6 and lambkin_ally.atk == 3)
	# Two sources stack (like Moonlight), and carriers buff each other.
	var harlequin := {
		"id": 123, "side": 0, "name": "Conjuring Harlequin", "kind": "Channeler",
		"atk": 5, "hp": 4, "max_hp": 4, "effects": [], "race": "lambkin", "level": 5,
		"skill": UnitCatalogScript.by_name("Conjuring Harlequin").skill.to_dict()
	}
	UnitSkillsScript.refresh_auras(inspire_units + [harlequin])
	assert(lambkin_ally.max_hp == 10 and lambkin_ally.atk == 5)
	assert(minstrel.max_hp == 7 and minstrel.atk == 4)
	assert(harlequin.max_hp == 5 and harlequin.atk == 6)
	assert(human_ally.max_hp == 6 and human_ally.atk == 3)

	# Warcry: Summon Forth makes the carrier take 0 damage from attacks for
	# {0} enemy turns; each blocked hit retaliates against the {2} highest-ATK
	# living enemies for {1}% of the attacker's ATK (min 1, rounded down).
	var summon_skill: Dictionary = UnitCatalogScript.by_name("Rydia of Mist").skill.to_dict()
	assert(UnitSkillsScript.rank_value(summon_skill, 1, 0, 1) == 1)
	assert(UnitSkillsScript.rank_value(summon_skill, 1, 1, 50) == 50)
	assert(UnitSkillsScript.rank_value(summon_skill, 1, 2, 1) == 1)
	assert(UnitSkillsScript.rank_value(summon_skill, 5, 0, 1) == 3)
	assert(UnitSkillsScript.rank_value(summon_skill, 5, 1, 50) == 100)
	assert(UnitSkillsScript.rank_value(summon_skill, 5, 2, 1) == 3)
	var rydia := {
		"id": 500, "side": 0, "name": "Rydia of Mist", "kind": "Channeler",
		"row": 0, "col": 1, "atk": 3, "hp": 7, "max_hp": 7, "effects": [], "level": 1,
		"skill": summon_skill
	}
	var summon_attacker := {
		"id": 501, "side": 1, "name": "Blade Foe", "kind": "Duelist",
		"row": 0, "col": 2, "atk": 4, "hp": 6, "max_hp": 6, "effects": []
	}
	var summon_big_foe := {
		"id": 502, "side": 1, "name": "Brute Foe", "kind": "Warden",
		"row": 1, "col": 4, "atk": 6, "hp": 9, "max_hp": 9, "effects": []
	}
	var summon_small_foe := {
		"id": 503, "side": 1, "name": "Scout Foe", "kind": "Strider",
		"row": 2, "col": 3, "atk": 2, "hp": 5, "max_hp": 5, "effects": []
	}
	var summon_units := [rydia, summon_attacker, summon_big_foe, summon_small_foe]
	var summon_warcry := UnitSkillsScript.resolve_warcry(rydia, summon_units)
	assert(summon_warcry.affected == [500])
	assert(rydia.summon_forth_turns == 1)
	assert("Summon Forth (1 turns)" in ConductorSkillsScript.effect_summary(rydia))
	# The level-1 row blocks the attack and deals 50% of 4 ATK = 2 damage to
	# the single highest-ATK enemy (the 6-ATK Brute, not the attacker).
	var summon_hit: Dictionary = BattleSimulatorScript.apply_unit_damage(
		rydia, summon_attacker.atk, summon_attacker
	)
	assert(summon_hit.damage == 0 and summon_hit.immunity == "summon_forth")
	assert(rydia.hp == 7)
	var summon_counter := UnitSkillsScript.resolve_summon_forth(
		rydia, summon_attacker, summon_units
	)
	assert(summon_counter.affected == [502])
	assert(summon_big_foe.hp == 7 and summon_attacker.hp == 6)
	# Skill damage is not attack damage: a source-less hit bypasses the
	# immunity entirely, even while the counter holds.
	var summon_skill_hit: Dictionary = BattleSimulatorScript.apply_unit_damage(rydia, 3)
	assert(summon_skill_hit.damage == 3 and summon_skill_hit.immunity == "")
	assert(rydia.hp == 4)
	rydia.hp = 7
	# The counter ticks on the opposing side's expiry pass, so the level-1
	# shield covers exactly one enemy turn before attacks land normally.
	UnitSkillsScript.expire_statuses(summon_units, 0)
	assert(rydia.summon_forth_turns == 1)
	UnitSkillsScript.expire_statuses(summon_units, 1)
	assert(rydia.summon_forth_turns == 0)
	var summon_expired_hit: Dictionary = BattleSimulatorScript.apply_unit_damage(
		rydia, summon_attacker.atk, summon_attacker
	)
	assert(summon_expired_hit.damage == 4 and summon_expired_hit.immunity == "")
	assert(rydia.hp == 3)
	rydia.hp = 7
	# The level-3 row: 2 enemy turns, 100% of ATK, the 2 highest-ATK enemies.
	rydia.level = 3
	UnitSkillsScript.resolve_warcry(rydia, summon_units)
	assert(rydia.summon_forth_turns == 2)
	assert(BattleSimulatorScript.apply_unit_damage(
		rydia, summon_attacker.atk, summon_attacker
	).damage == 0)
	var summon_counter_3 := UnitSkillsScript.resolve_summon_forth(
		rydia, summon_attacker, summon_units
	)
	assert(summon_counter_3.affected == [502, 501])
	assert(summon_big_foe.hp == 3 and summon_attacker.hp == 2)
	assert(summon_small_foe.hp == 5)
	# ATK ties at the cutoff tier are broken by seeded RNG picks; the same
	# seed always picks the same unit.
	var tie_a := {
		"id": 510, "side": 1, "name": "Tie Blade", "kind": "Duelist",
		"atk": 5, "hp": 5, "max_hp": 5, "effects": []
	}
	var tie_b := {
		"id": 511, "side": 1, "name": "Tie Edge", "kind": "Duelist",
		"atk": 5, "hp": 5, "max_hp": 5, "effects": []
	}
	rydia.level = 1
	var tie_rng := RandomNumberGenerator.new()
	tie_rng.seed = 11
	var tie_counter := UnitSkillsScript.resolve_summon_forth(
		rydia, tie_a, [rydia, tie_a, tie_b], tie_rng
	)
	assert(tie_counter.affected.size() == 1)
	var tie_first_id: int = tie_counter.affected[0]
	# 50% of 5 ATK rounds down to 2 damage on the picked unit.
	assert((tie_a.hp == 3) != (tie_b.hp == 3))
	var tie_rng_repeat := RandomNumberGenerator.new()
	tie_rng_repeat.seed = 11
	assert(UnitSkillsScript.resolve_summon_forth(
		rydia, tie_a, [rydia, tie_a, tie_b], tie_rng_repeat
	).affected == [tie_first_id])
	# A dead carrier never retaliates.
	rydia.hp = 0
	assert(UnitSkillsScript.resolve_summon_forth(
		rydia, tie_a, [rydia, tie_a, tie_b], tie_rng
	).affected.is_empty())

	# Chant: Quiet! fires at the start of the OPPOSING side's turn exactly
	# {0} times after deployment, Silencing the {1} highest-ATK living
	# enemies for {2} enemy turns; the carrier takes 0 attack damage from
	# Silenced attackers for as long as it lives.
	var quiet_skill: Dictionary = UnitCatalogScript.by_name("Nageki Fujishiro").skill.to_dict()
	assert(UnitSkillsScript.rank_value(quiet_skill, 1, 0, 1) == 1)
	assert(UnitSkillsScript.rank_value(quiet_skill, 1, 1, 1) == 1)
	assert(UnitSkillsScript.rank_value(quiet_skill, 1, 2, 1) == 1)
	assert(UnitSkillsScript.rank_value(quiet_skill, 5, 0, 1) == 3)
	assert(UnitSkillsScript.rank_value(quiet_skill, 5, 1, 1) == 3)
	assert(UnitSkillsScript.rank_value(quiet_skill, 5, 2, 1) == 3)
	var nageki := {
		"id": 520, "side": 0, "name": "Nageki Fujishiro", "kind": "Lifebinder",
		"row": 0, "col": 1, "atk": 2, "hp": 5, "max_hp": 5, "effects": [], "level": 3,
		"quiet_triggers_left": 2,
		"skill": quiet_skill
	}
	var quiet_foe_big := {
		"id": 521, "side": 1, "name": "Loud Brute", "kind": "Warden",
		"atk": 6, "hp": 9, "max_hp": 9, "effects": []
	}
	var quiet_foe_mid := {
		"id": 522, "side": 1, "name": "Loud Blade", "kind": "Duelist",
		"atk": 4, "hp": 6, "max_hp": 6, "effects": []
	}
	var quiet_foe_small := {
		"id": 523, "side": 1, "name": "Loud Scout", "kind": "Strider",
		"atk": 3, "hp": 4, "max_hp": 4, "effects": []
	}
	var quiet_units := [nageki, quiet_foe_big, quiet_foe_mid, quiet_foe_small]
	# Nothing fires at the start of the carrier's own side turn.
	assert(UnitSkillsScript.resolve_chants(0, quiet_units).is_empty())
	assert(nageki.quiet_triggers_left == 2)
	# Level-3 row: 2 triggers; each Silences the 2 highest-ATK enemies for
	# 2 turns (the 3-ATK Scout is left alone).
	var quiet_results := UnitSkillsScript.resolve_chants(1, quiet_units)
	assert(quiet_results.size() == 1)
	assert(quiet_results[0].affected == [521, 522])
	assert(quiet_foe_big.silenced_turns == 2 and quiet_foe_mid.silenced_turns == 2)
	assert(UnitSkillsScript.is_silenced(quiet_foe_big))
	assert(quiet_foe_small.get("silenced_turns", 0) == 0)
	assert(nageki.quiet_triggers_left == 1)
	# The second trigger refreshes (max, never stacks) and spends the last
	# charge; later opposing turns fire nothing.
	var quiet_results_2 := UnitSkillsScript.resolve_chants(1, quiet_units)
	assert(quiet_results_2.size() == 1 and nageki.quiet_triggers_left == 0)
	assert(quiet_foe_big.silenced_turns == 2)
	assert(UnitSkillsScript.resolve_chants(1, quiet_units).is_empty())
	# Passive: 0 attack damage from a Silenced attacker, normal damage from
	# a non-Silenced one, even with the trigger countdown spent.
	var quiet_blocked: Dictionary = BattleSimulatorScript.apply_unit_damage(
		nageki, quiet_foe_big.atk, quiet_foe_big
	)
	assert(quiet_blocked.damage == 0 and quiet_blocked.immunity == "quiet")
	assert(nageki.hp == 5)
	var quiet_open: Dictionary = BattleSimulatorScript.apply_unit_damage(
		nageki, quiet_foe_small.atk, quiet_foe_small
	)
	assert(quiet_open.damage == 3 and quiet_open.immunity == "")
	nageki.hp = 5
	# Skill damage from a Silenced enemy still lands: the passive gates
	# attack damage only.
	assert(BattleSimulatorScript.apply_unit_damage(nageki, 2).damage == 2)
	nageki.hp = 5
	# A Silenced carrier's trigger is a chant: it does not fire and the
	# charge is not spent, but the passive keeps working because it is not
	# a trigger.
	nageki.quiet_triggers_left = 1
	nageki.silenced_turns = 1
	quiet_foe_big.silenced_turns = 0
	quiet_foe_mid.silenced_turns = 0
	assert(UnitSkillsScript.resolve_chants(1, quiet_units).is_empty())
	assert(nageki.quiet_triggers_left == 1)
	quiet_foe_big.silenced_turns = 1
	assert(BattleSimulatorScript.apply_unit_damage(
		nageki, quiet_foe_big.atk, quiet_foe_big
	).damage == 0)
	nageki.silenced_turns = 0
	quiet_foe_big.silenced_turns = 0
	# Level-5 row: 3 triggers, the 3 highest-ATK enemies, 3 turns.
	nageki.level = 5
	nageki.quiet_triggers_left = 3
	var quiet_max := UnitSkillsScript.resolve_chants(1, quiet_units)
	assert(quiet_max.size() == 1 and quiet_max[0].affected == [521, 522, 523])
	assert(quiet_foe_small.silenced_turns == 3)
	assert(nageki.quiet_triggers_left == 2)
	# A dead carrier never triggers.
	nageki.hp = 0
	assert(UnitSkillsScript.resolve_chants(1, quiet_units).is_empty())

	var preview_unit := {"id": 6, "side": 0, "kind": "Strider", "row": 1, "col": 1, "move": 3, "range": 1}
	assert(BattleRulesScript.attack_cells(preview_unit) == [Vector2i(2, 1)])
	assert(BattleRulesScript.traversal_cells(preview_unit, [preview_unit]) == [
		Vector2i(2, 1), Vector2i(3, 1), Vector2i(4, 1)
	])
	preview_unit.immobilized_turns = 1
	assert(BattleRulesScript.traversal_cells(preview_unit, [preview_unit]).is_empty())
	preview_unit.immobilized_turns = 0
	var path_blocker := {"id": 7, "side": 0, "kind": "Warden", "row": 1, "col": 3}
	assert(BattleRulesScript.traversal_cells(preview_unit, [preview_unit, path_blocker]) == [Vector2i(2, 1)])
	var attack_target := {"id": 8, "side": 1, "kind": "Duelist", "row": 1, "col": 2}
	assert(BattleRulesScript.traversal_cells(preview_unit, [preview_unit, attack_target]).is_empty())
	var player_at_enemy_gate := {
		"id": 81, "side": 0, "kind": "Strider", "row": 2, "col": 4,
		"move": 3, "range": 1, "ready": true
	}
	assert(BattleRulesScript.traversal_cells(player_at_enemy_gate, [player_at_enemy_gate]) == [Vector2i(5, 2)])
	assert(BattleRulesScript.attack_cells_from(player_at_enemy_gate, 5) == [Vector2i(6, 2)])
	assert(BattleRulesScript.commander_in_range({
		"side": 0, "col": 5, "range": 1
	}))
	var enemy_at_player_gate := {
		"id": 82, "side": 1, "kind": "Strider", "row": 2, "col": 2,
		"move": 3, "range": 1, "ready": true
	}
	assert(BattleRulesScript.traversal_cells(enemy_at_player_gate, [enemy_at_player_gate]) == [Vector2i(1, 2)])
	assert(BattleRulesScript.attack_cells_from(enemy_at_player_gate, 1) == [Vector2i(0, 2)])
	assert(BattleRulesScript.commander_in_range({
		"side": 1, "col": 1, "range": 1
	}))
	var center_target := {"row": 1, "col": 3}
	assert(BattleRulesScript.blast_cells(center_target) == [
		Vector2i(2, 1), Vector2i(4, 1), Vector2i(3, 0), Vector2i(3, 2)
	])
	assert(BattleRulesScript.blast_cells({"row": 0, "col": 0}) == [
		Vector2i(1, 0), Vector2i(0, 1)
	])

	var front_ally := {
		"id": 9, "side": 0, "kind": "Duelist", "row": 1, "col": 3,
		"move": 2, "range": 1, "ready": true
	}
	var following_ally := {
		"id": 10, "side": 0, "kind": "Strider", "row": 1, "col": 1,
		"move": 3, "range": 1, "ready": true
	}
	var following_preview: Dictionary = BattleRulesScript.projected_action(10, [front_ally, following_ally])
	assert(following_preview.traversal == [Vector2i(2, 1), Vector2i(3, 1), Vector2i(4, 1)])
	assert(following_preview.projected_col == 4)
	assert(following_preview.attack == [Vector2i(5, 1)])

	var ranged_mover := {
		"id": 11, "side": 0, "kind": "Artillerist", "row": 0, "col": 1,
		"move": 1, "range": 3, "ready": true
	}
	var ranged_target := {"id": 12, "side": 1, "kind": "Warden", "row": 0, "col": 4}
	var ranged_preview: Dictionary = BattleRulesScript.projected_action(11, [ranged_mover, ranged_target])
	assert(ranged_preview.traversal == [Vector2i(2, 0)])
	assert(ranged_preview.attack == [Vector2i(3, 0), Vector2i(4, 0), Vector2i(5, 0)])

	var units := [
		{"side": 0, "row": 1, "col": 5, "atk": 3, "hp": 4, "max_hp": 4}
	]
	var ai_hand: Array = roster.map(func(unit): return unit.to_dict())
	var choice: Dictionary = BattleAIScript.choose_deployment(ai_hand, 2, units)
	assert(not choice.is_empty(), "AI should find an affordable deployment.")
	assert(choice.card.cost <= 2)
	assert(choice.row == 1, "AI should answer the most dangerous lane.")
	var finite_hand: Array = roster.slice(0, 4).map(func(unit): return unit.to_dict())
	var hand_choice: Dictionary = BattleAIScript.choose_deployment(finite_hand, 2, units)
	assert(not hand_choice.is_empty())
	var chosen_index: int = finite_hand.find(hand_choice.card)
	assert(chosen_index >= 0)
	finite_hand.remove_at(chosen_index)
	assert(finite_hand.size() == 3)

	var blocked_units := [
		{"side": 1, "row": 0, "col": 6, "atk": 1, "hp": 1, "max_hp": 1},
		{"side": 1, "row": 1, "col": 6, "atk": 1, "hp": 1, "max_hp": 1},
		{"side": 1, "row": 2, "col": 6, "atk": 1, "hp": 1, "max_hp": 1}
	]
	assert(BattleAIScript.choose_deployment(ai_hand, 10, blocked_units).is_empty())

	# Level growth: +10% ATK / max HP per level above 1, never below base.
	assert(KineticCrucibleScript.scaled_stat(10, 1) == 10)
	assert(KineticCrucibleScript.scaled_stat(10, 5) == 14)
	assert(KineticCrucibleScript.scaled_stat(2, 5) == 3)
	assert(KineticCrucibleScript.scaled_stat(1, 5) == 1)
	assert(KineticCrucibleScript.scaled_stat(0, 5) == 0)
	assert(KineticCrucibleScript.scaled_stat(3, 3) == 4)

	# Secondary skills scale with unit level via the reference rank tables.
	var mend_skill: Dictionary = UnitCatalogScript.by_name("Street Nurse").skill.to_dict()
	assert(mend_skill.has("rank_values"))
	assert(UnitSkillsScript.rank_value(mend_skill, 1, 0, 3) == 3)
	assert(UnitSkillsScript.rank_value(mend_skill, 5, 0, 3) == 7)
	assert(UnitSkillsScript.rank_value(mend_skill, 99, 0, 3) == 7)
	assert(UnitSkillsScript.rank_value({"name": "Mend"}, 5, 0, 3) == 3)
	var nurse_skill: SkillData = UnitCatalogScript.by_name("Street Nurse").skill
	assert(nurse_skill.format_text(1) == "Restore 3 HP to the allied unit with the lowest HP.")
	assert(nurse_skill.format_text(5) == "Restore 7 HP to the allied unit with the lowest HP.")
	var veteran_nurse := {
		"id": 95, "side": 0, "name": "Street Nurse", "kind": "Lifebinder",
		"atk": 2, "hp": 3, "max_hp": 3, "effects": [], "level": 5,
		"skill": mend_skill
	}
	var veteran_patient := {
		"id": 96, "side": 0, "name": "Hurt Ally", "kind": "Duelist",
		"atk": 2, "hp": 1, "max_hp": 10, "effects": []
	}
	assert(not UnitSkillsScript.resolve_warcry(
		veteran_nurse, [veteran_nurse, veteran_patient]
	).message.is_empty())
	assert(veteran_patient.hp == 8)
	var apostle_skill: Dictionary = UnitCatalogScript.by_name("Order Apostle").skill.to_dict()
	var veteran_apostle := {
		"id": 97, "side": 0, "name": "Order Apostle", "atk": 2,
		"hp": 4, "max_hp": 4, "effects": [], "level": 5, "skill": apostle_skill
	}
	var wrath_enemy := {
		"id": 98, "side": 1, "name": "Wrath Target", "kind": "Strider",
		"atk": 2, "hp": 9, "max_hp": 9, "effects": []
	}
	var wrath_rng := RandomNumberGenerator.new()
	wrath_rng.seed = 7
	var wrath_result := UnitSkillsScript.resolve_warcry(
		veteran_apostle, [veteran_apostle, wrath_enemy], -1, wrath_rng
	)
	assert(wrath_enemy.hp == 4)
	assert("split between random enemy units" in wrath_result.message)
	var veteran_skirmisher := {
		"id": 99, "side": 0, "name": "Claw Skirmisher", "level": 5,
		"skill": UnitCatalogScript.by_name("Claw Skirmisher").skill.to_dict()
	}
	var strike_target := {
		"id": 100, "side": 1, "name": "Strike Target",
		"hp": 5, "max_hp": 5, "effects": []
	}
	assert(UnitSkillsScript.resolve_strike(
		veteran_skirmisher, strike_target, [], 0.41
	).message.is_empty())
	assert(not UnitSkillsScript.resolve_strike(
		veteran_skirmisher, strike_target, [], 0.39
	).message.is_empty())
	assert(strike_target.immobilized_turns == 2)

	# Promotion conversion: a level-5 copy becomes its promoted form at level 1.
	assert(KineticCrucibleScript.promotion_target("Apprentice Builder", roster).name == "Master Builder")
	assert(KineticCrucibleScript.promotion_target("Master Builder", roster) == null)
	# Three-tier promotion chains resolve one step at a time, and the reserve
	# sort's root resolver walks the full chain back to the base form.
	assert(KineticCrucibleScript.promotion_target("Conjuring Clown", roster).name == "Conjuring Harlequin")
	assert(KineticCrucibleScript.promotion_target("Conjuring Harlequin", roster).name == "Conjuring Jester")
	assert(KineticCrucibleScript.promotion_target("Conjuring Jester", roster) == null)
	assert(KineticCrucibleScript.promotion_target("Flame Warden", roster).name == "Flame Dissident")
	assert(KineticCrucibleScript.promotion_target("Flame Dissident", roster).name == "Flame Schematic")
	assert(KineticCrucibleScript.promotion_target("Flame Schematic", roster) == null)
	var chain_by_name := {}
	for unit in roster:
		chain_by_name[unit.name] = unit
	assert(KineticCrucibleScript._promotion_root(
		"Conjuring Jester", chain_by_name, {}
	) == "Conjuring Clown")
	assert(KineticCrucibleScript._promotion_root(
		"Flame Schematic", chain_by_name, {}
	) == "Flame Warden")
	var promo_config := ConfigFile.new()
	promo_config.set_value("meta", "instances_migrated", true)
	promo_config.set_value("collection", "next_id", 11)
	promo_config.set_value("collection", "instances", [
		{"id": "unit_000001", "name": "Apprentice Builder", "level": 5, "points": 0, "consumed": false},
		{"id": "unit_000010", "name": "Trinity Rusher", "level": 5, "points": 0, "consumed": false}
	])
	promo_config.save(KineticCrucibleScript.SAVE_PATH)
	var promo_counts := {"Apprentice Builder": 1, "Trinity Rusher": 1}
	var promoted: Dictionary = KineticCrucibleScript.record_promotion(
		"unit_000001", roster, promo_counts
	)
	assert(promoted.ok and promoted.to == "Master Builder")
	var after_promotion: Array = KineticCrucibleScript.sync_instances(roster, promo_counts)
	var promoted_copy := KineticCrucibleScript.instance_by_id(
		after_promotion, "unit_000001"
	)
	assert(promoted_copy.name == "Master Builder")
	assert(promoted_copy.level == 1 and promoted_copy.points == 0)
	assert(after_promotion.filter(
		func(instance): return instance.name == "Apprentice Builder"
	).size() == 1)
	assert(not KineticCrucibleScript.record_promotion("unit_000010", roster, promo_counts).ok)
	assert(not KineticCrucibleScript.record_promotion("unit_000001", roster, promo_counts).ok)
	DirAccess.remove_absolute(ProjectSettings.globalize_path(KineticCrucibleScript.SAVE_PATH))

	print("Aether Engine smoke tests passed.")
	quit()
