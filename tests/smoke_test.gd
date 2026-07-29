extends SceneTree

const UnitCatalogScript = preload("res://scripts/unit_catalog.gd")
const BattleAIScript = preload("res://scripts/battle_ai.gd")
const SquadStoreScript = preload("res://scripts/squad_store.gd")
const CampaignStoreScript = preload("res://scripts/campaign_store.gd")
const BattleRulesScript = preload("res://scripts/battle_rules.gd")
const CaptainSkillsScript = preload("res://scripts/captain_skills.gd")

func _init() -> void:
	var roster: Array = UnitCatalogScript.all_units()
	assert(roster.size() == 12, "The playable roster must contain 12 units.")
	assert(UnitCatalogScript.by_name("Trinity Rusher").kind == "Strider")
	assert(UnitCatalogScript.display_class("Strider") == "Scout")
	assert(UnitCatalogScript.display_class("Lifebinder") == "Priest")
	assert(UnitCatalogScript.by_name("Missing").is_empty())
	assert(roster.map(func(unit): return unit.icon).all(
		func(icon_id): return icon_id >= 1 and icon_id <= 12
	))
	assert(roster.all(func(unit): return unit.stars == 1))
	var icon_ids: Array = roster.map(func(unit): return unit.icon)
	icon_ids.sort()
	assert(icon_ids == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
	for kind in ["Strider", "Duelist", "Warden", "Artillerist", "Channeler", "Lifebinder"]:
		assert(roster.filter(func(unit): return unit.kind == kind).size() == 2)

	var default_squad: Array = SquadStoreScript.default_squad(roster)
	assert(default_squad.size() == 12)
	var repaired_squad: Array = SquadStoreScript.sanitize(["Trinity Rusher", "Trinity Rusher", "Trinity Rusher", "Missing"], roster)
	assert(repaired_squad.size() == 2)
	assert(repaired_squad.count("Trinity Rusher") == 2)
	assert(SquadStoreScript.build_deck(repaired_squad, roster).size() == 2)
	assert(SquadStoreScript.sanitize([], roster).size() == 12)
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
	assert(CampaignStoreScript.reward_summary(2).begins_with("Prototype pool:"))
	assert(CampaignStoreScript.reward_summary(7) == "Random: Claw Caster, Claw Slicer")
	var training_rewards: Array = CampaignStoreScript.reward_options(0, roster)
	assert(training_rewards.size() == 2)
	assert(is_equal_approx(training_rewards[0].chance, 0.5))
	assert(is_equal_approx(training_rewards[1].chance, 0.5))
	var fallback_rewards: Array = CampaignStoreScript.reward_options(2, roster)
	assert(fallback_rewards.size() == 12)
	var fallback_total := 0.0
	for option in fallback_rewards:
		fallback_total += option.chance
	assert(is_equal_approx(fallback_total, 1.0))
	var rarity_candidates := [
		{"name": "One Star", "stars": 1},
		{"name": "Five Star", "stars": 5}
	]
	assert(CampaignStoreScript.choose_weighted_reward(rarity_candidates, 0.93) == "One Star")
	assert(CampaignStoreScript.choose_weighted_reward(rarity_candidates, 0.99) == "Five Star")
	var enemy_squad: Array = CampaignStoreScript.enemy_squad_names(2, roster)
	assert(enemy_squad.size() == 15)
	var unique_enemy_cards: Array = []
	for card_name in enemy_squad:
		if card_name not in unique_enemy_cards:
			unique_enemy_cards.append(card_name)
	assert(unique_enemy_cards.size() == 12)

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

	var preview_unit := {"id": 6, "side": 0, "kind": "Strider", "row": 1, "col": 1, "move": 3, "range": 1}
	assert(BattleRulesScript.attack_cells(preview_unit) == [Vector2i(2, 1)])
	assert(BattleRulesScript.traversal_cells(preview_unit, [preview_unit]) == [
		Vector2i(2, 1), Vector2i(3, 1), Vector2i(4, 1)
	])
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
