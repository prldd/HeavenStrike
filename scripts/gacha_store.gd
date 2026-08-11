class_name GachaStore
extends RefCounted

const SAVE_PATH := "user://gacha.cfg"
const SAVE_VERSION := 1
const MIN_PULLS := 1
const MAX_PULLS := 10
const PITY_RESET_MIN_STARS := 5
const HARD_PITY_PULL := 50
const PITY_WEIGHT_BONUS_PER_MISS := 0.10

## The counter stores consecutive pulls without a 5- or 6-star unit.
static func load_pity() -> int:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return 0
	return clampi(
		int(config.get_value("gacha", "pity", 0)),
		0,
		HARD_PITY_PULL - 1
	)

static func save_pity(pity: int) -> bool:
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value("meta", "version", SAVE_VERSION)
	config.set_value(
		"gacha", "pity", clampi(pity, 0, HARD_PITY_PULL - 1)
	)
	return config.save(SAVE_PATH) == OK

## Uses the exact per-unit rarity weight used by campaign battle rewards.
static func battle_reward_weight(stars: int) -> float:
	return float(1 << (6 - clampi(stars, 1, 6)))

static func adjusted_weight(stars: int, pity: int) -> float:
	var clean_stars := clampi(stars, 1, 6)
	var clean_pity := clampi(pity, 0, HARD_PITY_PULL - 1)
	if clean_pity >= HARD_PITY_PULL - 1:
		return battle_reward_weight(clean_stars) if clean_stars >= PITY_RESET_MIN_STARS else 0.0
	var weight := battle_reward_weight(clean_stars)
	if clean_stars >= PITY_RESET_MIN_STARS:
		weight *= 1.0 + clean_pity * PITY_WEIGHT_BONUS_PER_MISS
	return weight

static func rarity_odds(candidates: Array, pity: int) -> Dictionary:
	var weights := {}
	var total_weight := 0.0
	for unit in candidates:
		var stars := _unit_stars(unit)
		var weight := adjusted_weight(stars, pity)
		weights[stars] = float(weights.get(stars, 0.0)) + weight
		total_weight += weight
	var odds := {}
	for stars in range(1, 7):
		odds[stars] = (
			float(weights.get(stars, 0.0)) / total_weight
			if total_weight > 0.0 else 0.0
		)
	return odds

## Pure deterministic pull helper. Passing `roll` makes it suitable for tests.
static func roll_once(candidates: Array, pity: int, roll: float = -1.0) -> Dictionary:
	if candidates.is_empty():
		return {}
	var clean_pity := clampi(pity, 0, HARD_PITY_PULL - 1)
	var weights: Array[float] = []
	var total_weight := 0.0
	for unit in candidates:
		var weight := adjusted_weight(_unit_stars(unit), clean_pity)
		weights.append(weight)
		total_weight += weight
	if total_weight <= 0.0:
		return {}
	var random_roll := randf() if roll < 0.0 else clampf(roll, 0.0, 0.999999)
	var threshold := random_roll * total_weight
	var cumulative := 0.0
	var chosen = candidates[-1]
	for index in candidates.size():
		cumulative += weights[index]
		if threshold < cumulative:
			chosen = candidates[index]
			break
	var chosen_stars := _unit_stars(chosen)
	var reset := chosen_stars >= PITY_RESET_MIN_STARS
	return {
		"name": str(chosen.get("name")),
		"stars": chosen_stars,
		"pity_before": clean_pity,
		"pity_after": 0 if reset else mini(clean_pity + 1, HARD_PITY_PULL - 1),
		"pity_reset": reset
	}

## Resolves sequentially so a top-tier result resets pity inside a ten-pull.
static func roll_batch(
	candidates: Array, count: int, starting_pity: int, rolls: Array = []
) -> Dictionary:
	var pull_count := clampi(count, MIN_PULLS, MAX_PULLS)
	var pity := clampi(starting_pity, 0, HARD_PITY_PULL - 1)
	var results: Array = []
	for index in pull_count:
		var fixed_roll := float(rolls[index]) if index < rolls.size() else -1.0
		var result := roll_once(candidates, pity, fixed_roll)
		if result.is_empty():
			break
		results.append(result)
		pity = result.pity_after
	return {"results": results, "pity": pity}

static func _unit_stars(unit) -> int:
	var stars_value = unit.get("stars")
	return clampi(int(stars_value if stars_value != null else 1), 1, 6)
