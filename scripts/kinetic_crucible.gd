class_name KineticCrucible
extends RefCounted

const SAVE_PATH := "user://kinetic_crucible.cfg"
const SAVE_VERSION := 2
const MAX_LEVEL := 5
const LEVEL_COSTS := [3, 6, 12, 24]
## Fraction of base ATK / max HP gained per level above 1 (level 5 = 1.4x).
const STAT_GROWTH_PER_LEVEL := 0.1

## Returns a base stat grown for the given unit level. Growth is deliberately
## slow and never reduces the base value.
static func scaled_stat(base: int, level: int) -> int:
	var clamped := clampi(level, 1, MAX_LEVEL)
	return maxi(base, int(round(base * (1.0 + STAT_GROWTH_PER_LEVEL * (clamped - 1)))))

static func sync_instances(roster: Array, base_counts: Dictionary) -> Array:
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	var valid_names: Array = roster.map(func(unit): return unit.name)
	var saved = config.get_value("collection", "instances", [])
	var instances: Array = []
	if saved is Array:
		for value in saved:
			if value is not Dictionary or value.get("name", "") not in valid_names:
				continue
			instances.append(_sanitize_instance(value))

	var next_id := maxi(1, int(config.get_value("collection", "next_id", 1)))
	for unit in roster:
		var acquired: int = maxi(0, int(base_counts.get(unit.name, 0)))
		var represented: int = instances.filter(
			func(instance): return instance.name == unit.name
		).size()
		while represented < acquired:
			instances.append({
				"id": "unit_%06d" % next_id,
				"name": unit.name,
				"level": 1,
				"points": 0,
				"consumed": false
			})
			next_id += 1
			represented += 1

	# One-time migration from the earlier shared-by-name prototype.
	if not bool(config.get_value("meta", "instances_migrated", false)):
		for unit in roster:
			var matching: Array = instances.filter(
				func(instance): return instance.name == unit.name
			)
			var consumed_count := mini(
				matching.size(),
				maxi(0, int(config.get_value("consumed", unit.name, 0)))
			)
			for index in consumed_count:
				matching[index].consumed = true
			var legacy_progress = config.get_value("progress", unit.name, {})
			var active: Array = matching.filter(
				func(instance): return not instance.consumed
			)
			if legacy_progress is Dictionary and not active.is_empty():
				var progress := _sanitize_progress(legacy_progress)
				active[0].level = progress.level
				active[0].points = progress.points
		config.set_value("meta", "instances_migrated", true)

	config.set_value("meta", "version", SAVE_VERSION)
	config.set_value("collection", "next_id", next_id)
	config.set_value("collection", "instances", instances)
	config.save(SAVE_PATH)
	return instances

static func active_instances(instances: Array) -> Array:
	return instances.filter(
		func(instance): return not instance.consumed
	)

static func inventory_counts(instances: Array) -> Dictionary:
	var counts := {}
	for instance in instances:
		if instance.get("consumed", false):
			continue
		counts[instance.name] = int(counts.get(instance.name, 0)) + 1
	return counts

static func merge_value(target: Dictionary, donor: Dictionary, roster: Array = []) -> int:
	if target.get("name", "") == donor.get("name", ""):
		return 5
	var target_unit := _definition(target, roster)
	var donor_unit := _definition(donor, roster)
	if target_unit != null and donor_unit != null and target_unit.kind == donor_unit.kind:
		return 2
	# Retain pure-data compatibility for rules tests.
	if target.get("kind", "") != "" and target.get("kind", "") == donor.get("kind", ""):
		return 2
	return 1

static func can_merge(
	target: Dictionary,
	donor: Dictionary,
	roster: Array,
	only_extras: bool = false,
	active: Array = []
) -> bool:
	if target.is_empty() or donor.is_empty():
		return false
	if target.id == donor.id or donor.get("consumed", false):
		return false
	if int(target.get("level", 1)) >= MAX_LEVEL:
		return false
	if only_extras:
		var collection := active
		if collection.is_empty():
			return false
		if collection.filter(
			func(instance): return instance.name == donor.name
		).size() < 2:
			return false
	return _definition(target, roster) != null and _definition(donor, roster) != null

static func record_merge(
	target_id: String,
	donor_id: String,
	roster: Array,
	base_counts: Dictionary
) -> Dictionary:
	return record_merge_batch(target_id, [donor_id], roster, base_counts)

static func record_merge_batch(
	target_id: String,
	donor_ids: Array,
	roster: Array,
	base_counts: Dictionary
) -> Dictionary:
	var instances := sync_instances(roster, base_counts)
	var target := instance_by_id(instances, target_id)
	if target.is_empty() or int(target.get("level", 1)) >= MAX_LEVEL:
		return {"ok": false, "message": "That merge is no longer available."}
	var gained := 0
	var merged := 0
	for donor_id in donor_ids:
		if int(target.get("level", 1)) >= MAX_LEVEL:
			break
		var donor := instance_by_id(instances, str(donor_id))
		if not can_merge(target, donor, roster):
			continue
		var value := merge_value(target, donor, roster)
		var progress := apply_points(target, value)
		target.level = progress.level
		target.points = progress.points
		donor.consumed = true
		gained += value
		merged += 1
	if merged == 0:
		return {"ok": false, "message": "No queued units could be merged."}
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value("meta", "version", SAVE_VERSION)
	config.set_value("collection", "instances", instances)
	var error := config.save(SAVE_PATH)
	return {
		"ok": error == OK,
		"gained": gained,
		"merged": merged,
		"progress": {"level": target.level, "points": target.points},
		"message": "%s absorbed %d unit%s and gained %d Crucible point%s." % [
			target.name,
			merged,
			"" if merged == 1 else "s",
			gained,
			"" if gained == 1 else "s"
		]
	}

static func instance_by_id(instances: Array, instance_id: String) -> Dictionary:
	for instance in instances:
		if instance.id == instance_id:
			return instance
	return {}

## Returns the catalog unit that `unit_name` promotes into, or null.
static func promotion_target(unit_name: String, roster: Array) -> UnitData:
	for unit in roster:
		if unit.promotion_of == unit_name:
			return unit
	return null

## Converts a level-5 instance into its promoted form. The instance keeps its
## id (so squads fielding it automatically field the promoted unit) and starts
## over at level 1; the next sync replenishes a fresh level-1 base copy.
static func record_promotion(
	instance_id: String,
	roster: Array,
	base_counts: Dictionary
) -> Dictionary:
	var instances := sync_instances(roster, base_counts)
	var instance := instance_by_id(instances, instance_id)
	if instance.is_empty() or instance.get("consumed", false):
		return {"ok": false, "message": "That unit is no longer available."}
	if int(instance.get("level", 1)) < MAX_LEVEL:
		return {
			"ok": false,
			"message": "Only a level %d unit can be promoted." % MAX_LEVEL
		}
	var target := promotion_target(instance.get("name", ""), roster)
	if target == null:
		return {"ok": false, "message": "This unit has no promoted form."}
	var previous: String = instance.name
	instance.name = target.name
	instance.level = 1
	instance.points = 0
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value("meta", "version", SAVE_VERSION)
	config.set_value("collection", "instances", instances)
	var error := config.save(SAVE_PATH)
	return {
		"ok": error == OK,
		"from": previous,
		"to": target.name,
		"message": "%s was promoted to %s and can be levelled again." % [
			previous, target.name
		]
	}

static func display_label(instance: Dictionary) -> String:
	return "%s · LV %d" % [
		instance.get("name", "Unknown"),
		instance.get("level", 1)
	]

static func apply_points(progress: Dictionary, amount: int) -> Dictionary:
	var result := _sanitize_progress(progress)
	var remaining := maxi(0, amount)
	while remaining > 0 and result.level < MAX_LEVEL:
		var cost: int = LEVEL_COSTS[result.level - 1]
		var needed: int = cost - result.points
		var applied: int = mini(remaining, needed)
		result.points += applied
		remaining -= applied
		if result.points >= cost:
			result.level += 1
			result.points = 0
	return result

static func points_to_next(progress: Dictionary) -> int:
	var clean := _sanitize_progress(progress)
	if clean.level >= MAX_LEVEL:
		return 0
	return LEVEL_COSTS[clean.level - 1] - clean.points

static func _definition(instance: Dictionary, roster: Array) -> UnitData:
	for unit in roster:
		if unit.name == instance.get("name", ""):
			return unit
	return null

static func _sanitize_instance(value: Dictionary) -> Dictionary:
	var progress := _sanitize_progress(value)
	return {
		"id": str(value.get("id", "")),
		"name": str(value.get("name", "")),
		"level": progress.level,
		"points": progress.points,
		"consumed": bool(value.get("consumed", false))
	}

static func _sanitize_progress(value) -> Dictionary:
	if value is not Dictionary:
		return {"level": 1, "points": 0}
	var level := clampi(int(value.get("level", 1)), 1, MAX_LEVEL)
	var points := maxi(0, int(value.get("points", 0)))
	if level >= MAX_LEVEL:
		points = 0
	else:
		points = mini(points, LEVEL_COSTS[level - 1] - 1)
	return {"level": level, "points": points}
