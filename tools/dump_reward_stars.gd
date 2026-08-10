extends SceneTree

const CampaignStoreScript = preload("res://scripts/campaign_store.gd")
const UnitCatalogScript = preload("res://scripts/unit_catalog.gd")

func _init() -> void:
	var roster: Array = UnitCatalogScript.all_units()
	var stars_by_name := {}
	for unit in roster:
		stars_by_name[unit.name] = unit.stars
	var one_star: Array = []
	for unit in roster:
		if unit.stars == 1:
			one_star.append(unit.name)
	print("ONE_STAR_UNITS (%d): %s" % [one_star.size(), ", ".join(one_star)])
	var deficient: Array = []
	for mission in CampaignStoreScript.MISSIONS:
		var histogram := {}
		var rare: Array = []
		var ones := 0
		for unit_name in mission.reward_pool:
			var s: int = stars_by_name.get(unit_name, -1)
			histogram[s] = int(histogram.get(s, 0)) + 1
			if s == 1:
				ones += 1
			elif s >= 4:
				rare.append("%s(%d*)" % [unit_name, s])
		var keys := histogram.keys()
		keys.sort()
		var parts: Array = []
		for k in keys:
			parts.append("%d*:%d" % [k, histogram[k]])
		if ones < 3:
			deficient.append(mission.id + 1)
		print("M%02d pool=%d {%s} rare=[%s]" % [
			mission.id + 1, mission.reward_pool.size(),
			" ".join(parts), ", ".join(rare)
		])
	print("MISSIONS_WITH_FEWER_THAN_3_ONE_STAR: %s" % [str(deficient)])
	print("summary(2): %s" % CampaignStoreScript.reward_summary(2))
	print("summary(3): %s" % CampaignStoreScript.reward_summary(3))
	print("summary(6): %s" % CampaignStoreScript.reward_summary(6))
	print("summary(7): %s" % CampaignStoreScript.reward_summary(7))
	for mission_id in [0, 3]:
		var options: Array = CampaignStoreScript.reward_options(mission_id, roster)
		var parts: Array = []
		for option in options:
			parts.append("%s=%s" % [option.unit.name, option.chance])
		print("options(%d): size=%d [%s]" % [mission_id, options.size(), ", ".join(parts)])
	for roll_case in [[0, 0.0], [0, 0.999], [7, 0.85], [7, 0.92], [7, 0.99], [46, 0.95], [46, 0.99]]:
		print("roll(%d, %s): %s" % [roll_case[0], roll_case[1], CampaignStoreScript.roll_reward(roll_case[0], roster, roll_case[1])])
	quit()
