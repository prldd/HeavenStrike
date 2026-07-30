extends SceneTree

const BattleSimulatorScript = preload("res://scripts/battle_simulator.gd")
const CampaignStoreScript = preload("res://scripts/campaign_store.gd")
const SquadStoreScript = preload("res://scripts/squad_store.gd")
const UnitCatalogScript = preload("res://scripts/unit_catalog.gd")

func _init() -> void:
	var roster := UnitCatalogScript.all_units()
	var baseline_names := SquadStoreScript.default_squad(roster)
	var baseline_cards := SquadStoreScript.build_deck(baseline_names, roster)
	var baseline_power := BattleSimulatorScript.estimate_squad_power(baseline_cards)
	var weakest_ratio := INF
	var strongest_ratio := 0.0
	var encounter_total := 0
	var previous_mission_difficulty := -1.0
	var largest_difficulty_jump := 0.0

	for mission_id in CampaignStoreScript.MISSIONS.size():
		var mission_peak_difficulty := 0.0
		var previous_encounter_hp := 0
		for encounter_index in CampaignStoreScript.encounter_count(mission_id):
			var names := CampaignStoreScript.enemy_squad_names(
				mission_id, encounter_index, roster
			)
			assert(not names.is_empty())
			assert(names.size() <= SquadStoreScript.SQUAD_SIZE)
			var cards := SquadStoreScript.build_deck(names, roster)
			var power := BattleSimulatorScript.estimate_squad_power(cards)
			assert(power > 0.0)
			var ratio := power / baseline_power
			weakest_ratio = minf(weakest_ratio, ratio)
			strongest_ratio = maxf(strongest_ratio, ratio)
			var encounter_data: Dictionary = CampaignStoreScript.encounter(
				mission_id, encounter_index
			)
			assert(encounter_data.enemy_hp >= previous_encounter_hp)
			previous_encounter_hp = encounter_data.enemy_hp
			var difficulty: float = (
				ratio * 0.70 + (encounter_data.enemy_hp / 20.0) * 0.30
			)
			mission_peak_difficulty = maxf(mission_peak_difficulty, difficulty)
			encounter_total += 1
		if previous_mission_difficulty >= 0.0:
			largest_difficulty_jump = maxf(
				largest_difficulty_jump,
				mission_peak_difficulty - previous_mission_difficulty
			)
		previous_mission_difficulty = mission_peak_difficulty

	assert(encounter_total >= CampaignStoreScript.MISSIONS.size())
	assert(largest_difficulty_jump <= 0.18)
	print(
		"Balance simulation passed: %d encounters, power ratio %.2f–%.2f, max difficulty jump %.2f."
		% [
			encounter_total, weakest_ratio, strongest_ratio,
			largest_difficulty_jump
		]
	)
	quit()
