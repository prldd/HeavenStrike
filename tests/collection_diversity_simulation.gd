extends SceneTree

const CampaignStoreScript = preload("res://scripts/campaign_store.gd")
const GachaStoreScript = preload("res://scripts/gacha_store.gd")
const RequisitionStoreScript = preload("res://scripts/requisition_store.gd")
const UnitCatalogScript = preload("res://scripts/unit_catalog.gd")

# Baseline first-clear model: keep every copy, spend every available Credit on
# single pulls, and take one weighted reward from each completed mission. The
# audit excludes repeat clears, challenges, and player-directed Crucible use.
const SIMULATION_RUNS := 1000
const BASE_SEED := 0x574F52
const ACT_END_MISSIONS := {
	1: 21,
	2: 61,
	3: 76
}
const MIN_P10_UNIQUE_BY_ACT := {
	1: 30,
	2: 48,
	3: 53
}
const FACTIONS := ["Coal", "Steam", "Wind", "Fusion", "Solar", "Universal"]


func _init() -> void:
	var roster := UnitCatalogScript.all_units()
	var gacha_tables := _build_gacha_tables(roster)
	var snapshots := {1: [], 2: [], 3: []}
	assert(CampaignStoreScript.MISSIONS.size() == ACT_END_MISSIONS[3] + 1)
	assert(RequisitionStoreScript.STARTER_GRANT >= 0)
	assert(RequisitionStoreScript.CAMPAIGN_MILESTONE_GRANT >= 0)
	assert(RequisitionStoreScript.SINGLE_PULL_COST > 0)
	_assert_gacha_tables_match_production(roster, gacha_tables)

	for run_index in SIMULATION_RUNS:
		var rng := RandomNumberGenerator.new()
		rng.seed = BASE_SEED + run_index
		var counts := CampaignStoreScript.inventory_counts(roster, [])
		var pity := 0
		var credits := RequisitionStoreScript.STARTER_GRANT
		var pull_state := _spend_available_credits(
			counts, pity, credits, rng, gacha_tables
		)
		pity = pull_state.pity
		credits = pull_state.credits

		for mission_id in CampaignStoreScript.MISSIONS.size():
			_add_copy(
				counts,
				CampaignStoreScript.roll_reward(mission_id, roster, rng.randf())
			)
			credits += RequisitionStoreScript.CAMPAIGN_MILESTONE_GRANT
			pull_state = _spend_available_credits(
				counts, pity, credits, rng, gacha_tables
			)
			pity = pull_state.pity
			credits = pull_state.credits

			var act := int(CampaignStoreScript.MISSIONS[mission_id].act)
			if mission_id == ACT_END_MISSIONS.get(act, -1):
				snapshots[act].append(_collection_snapshot(counts, roster))

	var previous_median_unique := 0
	for act in range(1, 4):
		assert(snapshots[act].size() == SIMULATION_RUNS)
		var summary := _summarize(snapshots[act])
		assert(summary.median_unique > previous_median_unique)
		assert(summary.p10_unique >= MIN_P10_UNIQUE_BY_ACT[act])
		assert(summary.p10_class_coverage == UnitCatalogScript.CLASS_NAMES.size())
		assert(summary.p10_faction_coverage == FACTIONS.size())
		previous_median_unique = summary.median_unique
		print(_format_summary(act, summary))

	print(
		"Collection diversity simulation passed: %d seeded first-clear campaigns."
		% SIMULATION_RUNS
	)
	quit()


func _spend_available_credits(
	counts: Dictionary,
	pity: int,
	credits: int,
	rng: RandomNumberGenerator,
	gacha_tables: Array
) -> Dictionary:
	var next_pity := pity
	var remaining_credits := credits
	while remaining_credits >= RequisitionStoreScript.SINGLE_PULL_COST:
		var result := _roll_gacha_table(gacha_tables[next_pity], rng.randf())
		_add_copy(counts, result.name)
		next_pity = 0 if result.stars >= GachaStoreScript.PITY_RESET_MIN_STARS else (
			mini(next_pity + 1, GachaStoreScript.HARD_PITY_PULL - 1)
		)
		remaining_credits -= RequisitionStoreScript.SINGLE_PULL_COST
	return {"pity": next_pity, "credits": remaining_credits}


func _build_gacha_tables(roster: Array) -> Array:
	# Tens of thousands of roll_once() calls allocate enough temporary arrays to
	# destabilize Godot 4.7. Precompute its exact cumulative weights for each pity
	# value, then verify representative table results against the production API.
	var rarity_counts := {}
	for unit in roster:
		rarity_counts[unit.stars] = int(rarity_counts.get(unit.stars, 0)) + 1
	var tables: Array = []
	for pity in GachaStoreScript.HARD_PITY_PULL:
		var names: Array[String] = []
		var stars: Array[int] = []
		var cumulative: Array[float] = []
		var total_weight := 0.0
		for unit in roster:
			total_weight += GachaStoreScript.adjusted_weight(
				unit.stars, pity
			) / float(rarity_counts[unit.stars])
			names.append(unit.name)
			stars.append(unit.stars)
			cumulative.append(total_weight)
		tables.append({
			"names": names,
			"stars": stars,
			"cumulative": cumulative,
			"total_weight": total_weight
		})
	return tables


func _roll_gacha_table(table: Dictionary, roll: float) -> Dictionary:
	var threshold := clampf(roll, 0.0, 0.999999) * float(table.total_weight)
	for index in table.cumulative.size():
		if threshold < float(table.cumulative[index]):
			return {"name": table.names[index], "stars": table.stars[index]}
	var last_index: int = table.names.size() - 1
	return {"name": table.names[last_index], "stars": table.stars[last_index]}


func _assert_gacha_tables_match_production(roster: Array, tables: Array) -> void:
	for pity in [0, 10, GachaStoreScript.HARD_PITY_PULL - 1]:
		for roll in [0.0, 0.25, 0.75, 0.999999]:
			var expected := GachaStoreScript.roll_once(roster, pity, roll)
			var actual := _roll_gacha_table(tables[pity], roll)
			assert(actual.name == expected.name)
			assert(actual.stars == expected.stars)


func _add_copy(counts: Dictionary, unit_name: String) -> void:
	assert(not unit_name.is_empty())
	assert(counts.has(unit_name))
	counts[unit_name] = int(counts[unit_name]) + 1


func _collection_snapshot(counts: Dictionary, roster: Array) -> Dictionary:
	var unique_units := 0
	var three_plus_units := 0
	var total_copies := 0
	var class_counts := {}
	var faction_counts := {}
	for unit_class in UnitCatalogScript.CLASS_NAMES:
		class_counts[unit_class] = 0
	for faction in FACTIONS:
		faction_counts[faction] = 0

	for unit in roster:
		var copies := int(counts.get(unit.name, 0))
		total_copies += copies
		if copies <= 0:
			continue
		unique_units += 1
		if unit.stars >= 3:
			three_plus_units += 1
		class_counts[unit.kind] = int(class_counts.get(unit.kind, 0)) + 1
		var faction := UnitCatalogScript.faction_for_icon(unit.icon)
		faction_counts[faction] = int(faction_counts.get(faction, 0)) + 1

	return {
		"unique": unique_units,
		"three_plus": three_plus_units,
		"total_copies": total_copies,
		"duplicate_rate": (
			(total_copies - unique_units) / float(total_copies)
			if total_copies > 0 else 0.0
		),
		"class_coverage": _positive_count(class_counts),
		"faction_coverage": _positive_count(faction_counts),
		"min_class_unique": _minimum_value(class_counts),
		"min_faction_unique": _minimum_value(faction_counts),
		"class_counts": class_counts,
		"faction_counts": faction_counts
	}


func _summarize(snapshots: Array) -> Dictionary:
	var unique_values: Array = []
	var three_plus_values: Array = []
	var duplicate_rates: Array = []
	var class_coverages: Array = []
	var faction_coverages: Array = []
	var minimum_class_values: Array = []
	var minimum_faction_values: Array = []
	var class_totals := {}
	var faction_totals := {}
	for unit_class in UnitCatalogScript.CLASS_NAMES:
		class_totals[unit_class] = 0
	for faction in FACTIONS:
		faction_totals[faction] = 0

	for snapshot in snapshots:
		unique_values.append(snapshot.unique)
		three_plus_values.append(snapshot.three_plus)
		duplicate_rates.append(snapshot.duplicate_rate)
		class_coverages.append(snapshot.class_coverage)
		faction_coverages.append(snapshot.faction_coverage)
		minimum_class_values.append(snapshot.min_class_unique)
		minimum_faction_values.append(snapshot.min_faction_unique)
		for unit_class in snapshot.class_counts:
			class_totals[unit_class] += snapshot.class_counts[unit_class]
		for faction in snapshot.faction_counts:
			faction_totals[faction] += snapshot.faction_counts[faction]

	return {
		"p10_unique": _percentile(unique_values, 0.10),
		"median_unique": _percentile(unique_values, 0.50),
		"p90_unique": _percentile(unique_values, 0.90),
		"mean_three_plus": _mean(three_plus_values),
		"mean_duplicate_rate": _mean(duplicate_rates),
		"p10_class_coverage": _percentile(class_coverages, 0.10),
		"p10_faction_coverage": _percentile(faction_coverages, 0.10),
		"p10_min_class_unique": _percentile(minimum_class_values, 0.10),
		"p10_min_faction_unique": _percentile(minimum_faction_values, 0.10),
		"mean_class_counts": _averages(class_totals, snapshots.size()),
		"mean_faction_counts": _averages(faction_totals, snapshots.size())
	}


func _format_summary(act: int, summary: Dictionary) -> String:
	return (
		"Act %d boundary: unique units %d/%d/%d (p10/median/p90), "
		+ "mean 3★+ %.1f, mean duplicate rate %.1f%%, "
		+ "p10 least-populated class/faction %d/%d. Classes [%s]. Factions [%s]."
	) % [
		act,
		summary.p10_unique,
		summary.median_unique,
		summary.p90_unique,
		summary.mean_three_plus,
		summary.mean_duplicate_rate * 100.0,
		summary.p10_min_class_unique,
		summary.p10_min_faction_unique,
		_format_averages(summary.mean_class_counts),
		_format_averages(summary.mean_faction_counts)
	]


func _percentile(values: Array, proportion: float) -> int:
	assert(not values.is_empty())
	var sorted_values := values.duplicate()
	sorted_values.sort()
	var index := roundi((sorted_values.size() - 1) * clampf(proportion, 0.0, 1.0))
	return int(sorted_values[index])


func _mean(values: Array) -> float:
	assert(not values.is_empty())
	var total := 0.0
	for value in values:
		total += float(value)
	return total / values.size()


func _positive_count(counts: Dictionary) -> int:
	var result := 0
	for value in counts.values():
		if int(value) > 0:
			result += 1
	return result


func _minimum_value(counts: Dictionary) -> int:
	var result := 1 << 30
	for value in counts.values():
		result = mini(result, int(value))
	return result


func _averages(totals: Dictionary, divisor: int) -> Dictionary:
	var result := {}
	for key in totals:
		result[key] = totals[key] / float(divisor)
	return result


func _format_averages(averages: Dictionary) -> String:
	var parts: Array[String] = []
	for key in averages:
		parts.append("%s %.1f" % [key, averages[key]])
	return ", ".join(parts)
