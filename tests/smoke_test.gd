extends SceneTree

const UnitCatalogScript = preload("res://scripts/unit_catalog.gd")
const BattleSimulatorScript = preload("res://scripts/battle_simulator.gd")
const BattleAIScript = preload("res://scripts/battle_ai.gd")
const SquadStoreScript = preload("res://scripts/squad_store.gd")
const CampaignStoreScript = preload("res://scripts/campaign_store.gd")
const BattleRulesScript = preload("res://scripts/battle_rules.gd")
const CaptainSkillsScript = preload("res://scripts/captain_skills.gd")
const UnitSkillsScript = preload("res://scripts/unit_skills.gd")

func _init() -> void:
	var roster: Array = UnitCatalogScript.all_units()
	assert(roster.size() == 82, "The playable roster must contain 82 units.")
	assert(UnitCatalogScript.by_name("Trinity Rusher").kind == "Strider")
	assert(UnitCatalogScript.display_class("Strider") == "Scout")
	assert(UnitCatalogScript.display_class("Lifebinder") == "Priest")
	assert(UnitCatalogScript.class_color("Strider") != UnitCatalogScript.class_color("Duelist"))
	assert(UnitCatalogScript.class_color("Warden") != UnitCatalogScript.class_color("Lifebinder"))
	assert(UnitCatalogScript.by_name("Missing").is_empty())
	var simulator := BattleSimulatorScript.new()
	simulator.reset(4242)
	assert(simulator.seed_value == 4242)
	assert(simulator.record("test", {"value": 7}).sequence == 1)
	assert(simulator.replay_data().events.size() == 1)
	assert(simulator.replay_data().seed == 4242)
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
	var captain_state := {
		"player_hp": 20, "enemy_hp": 20,
		"player_shield": 2, "enemy_shield": 0
	}
	var captain_hit := BattleSimulatorScript.apply_captain_damage(
		0, 5, captain_state
	)
	assert(captain_hit.shield_absorbed == 2)
	assert(captain_state.player_hp == 17)
	assert(roster.map(func(unit): return unit.icon).all(
		func(icon_id): return icon_id >= 1 and icon_id <= 87
	))
	assert(roster.filter(func(unit): return unit.stars == 1).size() == 12)
	assert(roster.filter(func(unit): return unit.stars == 2).size() == 14)
	assert(roster.filter(func(unit): return unit.stars == 3).size() == 25)
	assert(roster.filter(func(unit): return unit.stars == 4).size() == 19)
	assert(roster.filter(func(unit): return unit.stars == 5).size() == 12)
	var icon_ids: Array = roster.map(func(unit): return unit.icon)
	var unique_icon_ids: Array = []
	for icon_id in icon_ids:
		if icon_id not in unique_icon_ids:
			unique_icon_ids.append(icon_id)
	assert(icon_ids.size() == unique_icon_ids.size())
	assert(roster.filter(func(unit): return unit.kind == "Strider").size() == 17)
	assert(roster.filter(func(unit): return unit.kind == "Duelist").size() == 15)
	assert(roster.filter(func(unit): return unit.kind == "Warden").size() == 6)
	assert(roster.filter(func(unit): return unit.kind == "Artillerist").size() == 18)
	assert(roster.filter(func(unit): return unit.kind == "Channeler").size() == 14)
	assert(roster.filter(func(unit): return unit.kind == "Lifebinder").size() == 12)
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
	assert(roster.filter(
		func(unit): return unit.get("skill", {}).get("name", "") == "Mend"
	).size() == 4)
	assert(roster.filter(
		func(unit): return unit.get("skill", {}).get("name", "") == "Plague"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.get("skill", {}).get("name", "") == "Envenom"
	).size() == 6)
	assert(roster.filter(
		func(unit): return unit.get("skill", {}).get("name", "") == "Pin Down"
	).size() == 6)
	assert(roster.filter(
		func(unit): return unit.get("skill", {}).get("name", "") == "Demoralize"
	).size() == 6)
	assert(roster.filter(
		func(unit): return unit.get("skill", {}).get("name", "") == "Punish"
	).size() == 6)
	assert(roster.filter(
		func(unit): return unit.get("skill", {}).get("name", "") == "Poison Strike"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.get("skill", {}).get("name", "") == "Sunder Armour"
	).size() == 5)
	assert(UnitCatalogScript.art_id(49) == 47)
	assert(UnitCatalogScript.art_id(56) == 58)
	assert(UnitCatalogScript.art_id(27) == 83)
	assert(UnitCatalogScript.art_id(28) == 177)
	assert(UnitCatalogScript.art_id(29) == 423)
	assert(UnitCatalogScript.art_id(39) == 535)
	assert(UnitCatalogScript.art_id(68) == 629)
	assert(UnitCatalogScript.art_id(80) == 488)
	assert(UnitCatalogScript.art_id(87) == 609)
	for unit in roster:
		var art_id: int = UnitCatalogScript.art_id(unit.icon)
		assert(FileAccess.file_exists(
			"res://assets/units/portraits/%03d.png" % art_id
		))
		assert(FileAccess.file_exists(
			"res://assets/units/full/%03d.png" % art_id
		))
	assert(roster.filter(func(unit): return unit.has("promotion_of")).size() == 37)
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
	assert(CaptainSkillsScript.SKILLS.size() == 8)
	assert(CampaignStoreScript.SAVE_VERSION == 1)
	assert(SquadStoreScript.SAVE_VERSION == 1)

	assert(CampaignStoreScript.MISSIONS.size() == 62)
	assert(CampaignStoreScript.MISSIONS[0].title == "Act 1 Mission 1 - Training Day")
	assert(CampaignStoreScript.MISSIONS[61].title == "Act 2 Mission 62 - The Showdown")
	assert(CampaignStoreScript.MISSIONS[0].enemy_hp == 8)
	assert(CampaignStoreScript.MISSIONS[61].enemy_hp == 20)
	assert(CampaignStoreScript.encounter_count(3) == 1)
	assert(CampaignStoreScript.encounter_count(31) == 3)
	assert(CampaignStoreScript.encounter(31, 2).title == "Peace and Quiet")
	assert(CampaignStoreScript.encounter(999, 0).is_empty())
	assert(CampaignStoreScript.is_available(0, []))
	assert(not CampaignStoreScript.is_available(1, []))
	assert(CampaignStoreScript.is_available(1, [0]))
	assert(CampaignStoreScript.sanitize_completed([2, 2, 999, -1, 0]) == [0, 2])
	var starting_unlocks: Array = CampaignStoreScript.unlocked_unit_names(roster, [])
	assert(starting_unlocks.size() == 30)
	assert("Chain Initiate" not in starting_unlocks)
	var earned_unlocks: Array = CampaignStoreScript.unlocked_unit_names(
		roster, ["Chain Initiate", "LDF Medic"]
	)
	assert(earned_unlocks.size() == 32)
	assert(CampaignStoreScript.roll_reward(0, roster, 0.0) == "Trinity Rusher")
	assert(CampaignStoreScript.roll_reward(0, roster, 0.999) == "Trinity Potshot")
	assert(CampaignStoreScript.reward_summary(2) == "Random: Street Nurse, Rage Brute")
	assert(CampaignStoreScript.reward_summary(3) == "Random: Talon Scratcher")
	assert(CampaignStoreScript.reward_summary(7) == "Random: Claw Caster, Claw Slicer, Rage Brute, Claw Skirmisher, Claw Ambusher")
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
	assert("Captain Kerryson" in CampaignStoreScript.MISSIONS[17].reward_pool)
	assert("Kerryson the Stoic" in CampaignStoreScript.MISSIONS[17].reward_pool)
	assert("Garrett Talon" in CampaignStoreScript.MISSIONS[8].reward_pool)
	assert("Garrett the Claw" in CampaignStoreScript.MISSIONS[49].reward_pool)
	assert("Precision Shooter" in CampaignStoreScript.MISSIONS[52].reward_pool)
	assert("Precision Sniper" in CampaignStoreScript.MISSIONS[60].reward_pool)
	assert("Greyson the Shifty" in CampaignStoreScript.MISSIONS[13].reward_pool)
	assert("LDF Flight Officer" in CampaignStoreScript.MISSIONS[18].reward_pool)
	assert("LDF Flight Commander" in CampaignStoreScript.MISSIONS[14].reward_pool)
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
	assert(enemy_squad_signatures.size() == 62)

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
	assert(BattleAIScript.should_use_captain_skill(
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
	var rally: Dictionary = CaptainSkillsScript.apply("Rally", 0, skill_units, 20)
	assert(rally.success)
	assert(skill_ally.atk == 3)
	assert("Rally (1 turn)" in CaptainSkillsScript.effect_summary(skill_ally))
	CaptainSkillsScript.expire_effects(skill_units, 0)
	assert(skill_ally.atk == 2)
	assert(skill_ally.effects.is_empty())
	var aid: Dictionary = CaptainSkillsScript.apply("Aid", 0, skill_units, 20)
	assert(aid.success and skill_ally.hp == 5)
	var shield: Dictionary = CaptainSkillsScript.apply("Shield", 0, skill_units, 20)
	assert(shield.success and shield.shield == 5 and shield.shield_turns == 2)
	assert(not CaptainSkillsScript.apply("Last Stand", 0, skill_units, 9).success)
	assert(CaptainSkillsScript.apply("Last Stand", 0, skill_units, 8).success)
	CaptainSkillsScript.expire_effects(skill_units, 0)
	var firestorm: Dictionary = CaptainSkillsScript.apply("Firestorm", 0, skill_units, 20)
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
	CaptainSkillsScript.expire_effects(warcry_units, 0)
	assert(fortify_ally.max_hp == 8)
	CaptainSkillsScript.expire_effects(warcry_units, 0)
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
	CaptainSkillsScript.expire_effects(misfortune_units, 1)
	assert(enemy_scout.atk == 4)
	CaptainSkillsScript.expire_effects(misfortune_units, 1)
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
	CaptainSkillsScript.expire_effects(debuff_units, 1)
	CaptainSkillsScript.expire_effects(debuff_units, 1)
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
	assert(BattleSimulatorScript.apply_unit_damage(sunder_defender, 2).damage == 3)
	assert(sunder_defender.hp == 4)
	UnitSkillsScript.expire_statuses([sunder_defender], 1)
	assert(sunder_defender.vulnerable_turns == 1)
	skirmisher.skill = {"name": "Pinning Slice", "type": "Strike"}
	assert(not UnitSkillsScript.resolve_strike(skirmisher, warcry_enemy, [], 0.59).message.is_empty())
	warcry_enemy.immobilized_turns = 0
	assert(UnitSkillsScript.resolve_strike(skirmisher, warcry_enemy, [], 0.60).message.is_empty())

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
	var choice: Dictionary = BattleAIScript.choose_deployment(roster, 2, units)
	assert(not choice.is_empty(), "AI should find an affordable deployment.")
	assert(choice.card.cost <= 2)
	assert(choice.row == 1, "AI should answer the most dangerous lane.")
	var finite_hand: Array = roster.slice(0, 4)
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
	assert(BattleAIScript.choose_deployment(roster, 10, blocked_units).is_empty())

	print("Aether Engine smoke tests passed.")
	quit()
