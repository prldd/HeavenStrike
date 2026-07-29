extends SceneTree

const UnitCatalogScript = preload("res://scripts/unit_catalog.gd")
const BattleAIScript = preload("res://scripts/battle_ai.gd")
const SquadStoreScript = preload("res://scripts/squad_store.gd")
const CampaignStoreScript = preload("res://scripts/campaign_store.gd")

func _init() -> void:
	var roster: Array = UnitCatalogScript.all_units()
	assert(roster.size() == 18, "The playable roster must contain 18 units.")
	assert(UnitCatalogScript.by_name("Cloudstep").kind == "Strider")
	assert(UnitCatalogScript.by_name("Missing").is_empty())
	for kind in ["Strider", "Duelist", "Warden", "Artillerist", "Channeler", "Lifebinder"]:
		assert(roster.filter(func(unit): return unit.kind == kind).size() == 3)

	var default_squad: Array = SquadStoreScript.default_squad(roster)
	assert(default_squad.size() == SquadStoreScript.SQUAD_SIZE)
	var repaired_squad: Array = SquadStoreScript.sanitize(["Cloudstep", "Cloudstep", "Missing"], roster)
	assert(repaired_squad.size() == SquadStoreScript.SQUAD_SIZE)
	assert(repaired_squad.count("Cloudstep") == 1)
	assert(SquadStoreScript.build_deck(repaired_squad, roster).size() == SquadStoreScript.SQUAD_SIZE)

	assert(CampaignStoreScript.MISSIONS.size() == 5)
	assert(CampaignStoreScript.is_available(0, []))
	assert(not CampaignStoreScript.is_available(1, []))
	assert(CampaignStoreScript.is_available(1, [0]))
	assert(CampaignStoreScript.sanitize_completed([2, 2, 99, -1, 0]) == [0, 2])
	var starting_unlocks: Array = CampaignStoreScript.unlocked_unit_names(roster, [])
	assert(starting_unlocks.size() == 15)
	assert("Dawnmender" not in starting_unlocks)
	var earned_unlocks: Array = CampaignStoreScript.unlocked_unit_names(roster, [0, 1, 2])
	assert(earned_unlocks.size() == 18)

	var units := [
		{"side": 0, "row": 1, "col": 5, "atk": 3, "hp": 4, "max_hp": 4}
	]
	var choice: Dictionary = BattleAIScript.choose_deployment(roster, 2, units)
	assert(not choice.is_empty(), "AI should find an affordable deployment.")
	assert(choice.card.cost <= 2)
	assert(choice.row == 1, "AI should answer the most dangerous lane.")

	var blocked_units := [
		{"side": 1, "row": 0, "col": 6, "atk": 1, "hp": 1, "max_hp": 1},
		{"side": 1, "row": 1, "col": 6, "atk": 1, "hp": 1, "max_hp": 1},
		{"side": 1, "row": 2, "col": 6, "atk": 1, "hp": 1, "max_hp": 1}
	]
	assert(BattleAIScript.choose_deployment(roster, 10, blocked_units).is_empty())

	print("Skychain smoke tests passed.")
	quit()
