extends SceneTree

const BattleSimulatorScript = preload("res://scripts/battle_simulator.gd")
const CampaignStoreScript = preload("res://scripts/campaign_store.gd")
const SquadStoreScript = preload("res://scripts/squad_store.gd")
const UnitCatalogScript = preload("res://scripts/unit_catalog.gd")

func _init() -> void:
	var roster := UnitCatalogScript.all_units()
	var roster_icons: Array = roster.map(func(unit): return unit.icon)
	var assigned_icons: Array = []
	var expected_faction_sizes := {
		"Coal": 56, "Steam": 48, "Wind": 50, "Fusion": 49, "Solar": 51
	}
	for faction in UnitCatalogScript.FACTION_ICON_IDS:
		var faction_icons: Array = UnitCatalogScript.FACTION_ICON_IDS[faction]
		assert(faction_icons.size() == expected_faction_sizes[faction])
		for icon_id in faction_icons:
			assert(icon_id in roster_icons)
			assert(icon_id not in assigned_icons)
			assigned_icons.append(icon_id)
	assert(roster.size() - assigned_icons.size() == 38)
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
			var squad_classes: Array = []
			for card in cards:
				if card.kind not in squad_classes:
					squad_classes.append(card.kind)
			assert(squad_classes.size() >= 5)
			var power := BattleSimulatorScript.estimate_squad_power(cards)
			assert(power > 0.0)
			var ratio := power / baseline_power
			weakest_ratio = minf(weakest_ratio, ratio)
			strongest_ratio = maxf(strongest_ratio, ratio)
			var encounter_data: Dictionary = CampaignStoreScript.encounter(
				mission_id, encounter_index
			)
			var squad_faction: String = encounter_data.get("squad_faction", "Blended")
			if squad_faction in UnitCatalogScript.FACTION_ICON_IDS:
				var faction_unit_count := 0
				for unit_name in names:
					var unit_faction := UnitCatalogScript.faction_for_name(unit_name)
					assert(unit_faction == squad_faction or unit_faction == "Universal")
					if unit_faction == squad_faction:
						faction_unit_count += 1
				assert(faction_unit_count >= 5)
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
