class_name ChallengeStore
extends RefCounted

const ChallengeCatalogScript = preload("res://scripts/challenge_catalog.gd")
const RequisitionStoreScript = preload("res://scripts/requisition_store.gd")

const SAVE_PATH := "user://challenges.cfg"
const SAVE_VERSION := 1

static func load_completed_claim_ids() -> Array:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return []
	var saved = config.get_value("challenges", "completed_claim_ids", [])
	if saved is not Array:
		return []
	var result: Array = []
	for value in saved:
		var claim_id := str(value).strip_edges()
		if (
			ChallengeCatalogScript.is_valid_claim_id(claim_id)
			and claim_id not in result
		):
			result.append(claim_id)
	return result

## The wallet claim is also accepted as completion evidence. This lets the
## challenge record recover safely if its save is removed after currency was
## already granted, without ever paying the same weekly reward twice.
static func is_completed(cycle_id: String, challenge_id: String) -> bool:
	var claim_id := ChallengeCatalogScript.claim_id(cycle_id, challenge_id)
	if claim_id.is_empty():
		return false
	return (
		claim_id in load_completed_claim_ids()
		or RequisitionStoreScript.has_claimed(claim_id)
	)

static func active_status(unix_time: int = -1) -> Dictionary:
	var challenge := ChallengeCatalogScript.active_for_unix_time(unix_time)
	var completed := is_completed(challenge.cycle_id, challenge.id)
	challenge["completed"] = completed
	challenge["reward_available"] = not completed
	return challenge

## Records a victory in the challenge active at the supplied UTC timestamp.
## Repeat victories remain completed but never grant additional currency.
static func record_victory(unix_time: int = -1) -> Dictionary:
	var challenge := ChallengeCatalogScript.active_for_unix_time(unix_time)
	var claim_id: String = challenge.claim_id
	var currency: Dictionary = RequisitionStoreScript.claim(
		claim_id, int(challenge.reward_credits)
	)
	var completed_ids := load_completed_claim_ids()
	if claim_id not in completed_ids:
		completed_ids.append(claim_id)
	var saved := _save_completed_claim_ids(completed_ids)
	return {
		"completed": saved or RequisitionStoreScript.has_claimed(claim_id),
		"first_clear": bool(currency.claimed),
		"reward_amount": int(currency.amount),
		"balance": int(currency.balance),
		"cycle_id": challenge.cycle_id,
		"challenge_id": challenge.id,
		"claim_id": claim_id
	}

static func _save_completed_claim_ids(completed_ids: Array) -> bool:
	var sanitized: Array = []
	for value in completed_ids:
		var claim_id := str(value).strip_edges()
		if (
			ChallengeCatalogScript.is_valid_claim_id(claim_id)
			and claim_id not in sanitized
		):
			sanitized.append(claim_id)
	var config := ConfigFile.new()
	config.set_value("meta", "version", SAVE_VERSION)
	config.set_value("challenges", "completed_claim_ids", sanitized)
	return config.save(SAVE_PATH) == OK
