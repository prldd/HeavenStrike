class_name RequisitionStore
extends RefCounted

const SAVE_PATH := "user://requisition.cfg"
const SAVE_VERSION := 1
const CURRENCY_NAME := "REQUISITION CREDITS"
const SINGLE_PULL_COST := 100
const TEN_PULL_COST := 1000
const STARTER_GRANT := 1000
const CAMPAIGN_MILESTONE_GRANT := 100
const STARTER_CLAIM_ID := "starter:v1"

## Returns the persistent wallet balance. Invalid or legacy values are safely
## treated as zero; the starter grant is claimed separately and idempotently.
static func load_balance() -> int:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return 0
	return maxi(0, int(config.get_value("wallet", "balance", 0)))

static func load_claimed_ids() -> Array:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return []
	var saved = config.get_value("wallet", "claimed_ids", [])
	if saved is not Array:
		return []
	var result: Array = []
	for value in saved:
		var claim_id := str(value).strip_edges()
		if not claim_id.is_empty() and claim_id not in result:
			result.append(claim_id)
	return result

static func has_claimed(claim_id: String) -> bool:
	return claim_id.strip_edges() in load_claimed_ids()

## Grants currency exactly once for a stable source-owned claim ID. Rotating
## challenges can later use IDs such as "challenge:2026-W32:iron_trial" without
## requiring another wallet schema or risking duplicate claims.
static func claim(claim_id: String, amount: int) -> Dictionary:
	var clean_id := claim_id.strip_edges()
	var current_balance := load_balance()
	if clean_id.is_empty() or amount <= 0:
		return {"claimed": false, "amount": 0, "balance": current_balance}
	var claimed_ids := load_claimed_ids()
	if clean_id in claimed_ids:
		return {"claimed": false, "amount": 0, "balance": current_balance}
	var next_balance := current_balance + amount
	claimed_ids.append(clean_id)
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value("meta", "version", SAVE_VERSION)
	config.set_value("wallet", "balance", next_balance)
	config.set_value("wallet", "claimed_ids", claimed_ids)
	if config.save(SAVE_PATH) != OK:
		return {"claimed": false, "amount": 0, "balance": current_balance}
	return {"claimed": true, "amount": amount, "balance": next_balance}

static func ensure_starter_grant() -> Dictionary:
	return claim(STARTER_CLAIM_ID, STARTER_GRANT)

## Deducts currency only when the full amount is available. The operation is
## all-or-nothing so a ten-pull can never partially spend the wallet.
static func spend(amount: int) -> Dictionary:
	var current_balance := load_balance()
	if amount <= 0 or current_balance < amount:
		return {"spent": false, "amount": 0, "balance": current_balance}
	var next_balance := current_balance - amount
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value("meta", "version", SAVE_VERSION)
	config.set_value("wallet", "balance", next_balance)
	config.set_value("wallet", "claimed_ids", load_claimed_ids())
	if config.save(SAVE_PATH) != OK:
		return {"spent": false, "amount": 0, "balance": current_balance}
	return {"spent": true, "amount": amount, "balance": next_balance}

static func pull_cost(count: int) -> int:
	if count == 1:
		return SINGLE_PULL_COST
	if count == 10:
		return TEN_PULL_COST
	return -1

static func campaign_milestone_claim_id(mission_id: int) -> String:
	return "campaign:first_manual_clear:%03d" % mission_id
