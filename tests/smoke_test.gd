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
	assert(roster.size() == 45, "The playable roster must contain 45 units.")
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
		func(icon_id): return icon_id >= 1 and icon_id <= 48
	))
	assert(roster.filter(func(unit): return unit.stars == 1).size() == 12)
	assert(roster.filter(func(unit): return unit.stars == 2).size() == 10)
	assert(roster.filter(func(unit): return unit.stars == 3).size() == 13)
	assert(roster.filter(func(unit): return unit.stars == 4).size() == 6)
	assert(roster.filter(func(unit): return unit.stars == 5).size() == 4)
	var icon_ids: Array = roster.map(func(unit): return unit.icon)
	icon_ids.sort()
	assert(icon_ids == range(1, 30) + range(31, 36) + range(37, 42) + range(43, 49))
	assert(roster.filter(func(unit): return unit.kind == "Strider").size() == 11)
	assert(roster.filter(func(unit): return unit.kind == "Duelist").size() == 6)
	assert(roster.filter(func(unit): return unit.kind == "Warden").size() == 4)
	assert(roster.filter(func(unit): return unit.kind == "Artillerist").size() == 6)
	assert(roster.filter(func(unit): return unit.kind == "Channeler").size() == 12)
	assert(roster.filter(func(unit): return unit.kind == "Lifebinder").size() == 6)
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
	assert(roster.filter(func(unit): return unit.has("promotion_of")).size() == 17)
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
	assert(starting_unlocks.size() == 10)
	assert("Chain Initiate" not in starting_unlocks)
	var earned_unlocks: Array = CampaignStoreScript.unlocked_unit_names(
		roster, ["Chain Initiate", "LDF Medic"]
	)
	assert(earned_unlocks.size() == 12)
	assert(CampaignStoreScript.roll_reward(0, roster, 0.0) == "Trinity Rusher")
	assert(CampaignStoreScript.roll_reward(0, roster, 0.999) == "Trinity Potshot")
	assert(CampaignStoreScript.reward_summary(2) == "Random: Rage Brute")
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
	for mission in CampaignStoreScript.MISSIONS:
		assert("Farsight Naruku" not in mission.reward_pool)
		assert("Macewielder Ragnr" not in mission.reward_pool)
		assert("Innocent Gretel" not in mission.reward_pool)
		assert("Witchkiller Gretel" not in mission.reward_pool)
		assert("Talon Slicer" not in mission.reward_pool)
		assert("Fortune Teller" not in mission.reward_pool)
		assert("Fortune Diviner" not in mission.reward_pool)
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

	print("Skychain smoke tests passed.")
	quit()
