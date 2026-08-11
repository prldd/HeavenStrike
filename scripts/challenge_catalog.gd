class_name ChallengeCatalog
extends RefCounted

const MissionRulesScript = preload("res://scripts/mission_rules.gd")

const REWARD_CREDITS := 250
const SECONDS_PER_DAY := 86400
const ROTATION_ANCHOR := {
	"year": 2026, "month": 1, "day": 5,
	"hour": 0, "minute": 0, "second": 0
}

## Challenges rotate weekly in this authored order. The catalog owns battle
## data only; ChallengeStore owns completion persistence and currency claims.
const CHALLENGES := [
	{
		"id": "iron_trial",
		"title": "Iron Trial",
		"subtitle": "Hold the Salvage Line",
		"briefing": "A Coal assault column is testing the convoy perimeter. Keep the transport operational until its cargo can be secured.",
		"opponent_name": "Trial Marshal Veyr",
		"opponent_affiliation": "Coal Emergency Corps",
		"squad_faction": "Coal",
		"enemy_hp": 20,
		"skill": "Shield",
		"enemy_squad": [
			"Cinder Bastion-220", "Cinder Mender-214", "Cinder Weaver-199",
			"Cinder Battery-191", "Cinder Lancer-070", "Cinder Blade-016",
			"Cinder Battery-177", "Cinder Bastion-167"
		],
		"rules": {
			"objective": {
				"type": "protect",
				"target_name": "the salvage transport",
				"title": "Hold the Salvage Line",
				"description": "Keep the marked transport operational and defeat the Trial Marshal."
			},
			"turn_limit": 7,
			"blocked_cells": [
				{"row": 0, "col": 3}, {"row": 2, "col": 3}
			],
			"predeployed": [{
				"unit": "Relay Ground Transport-216", "side": 0,
				"row": 1, "col": 2, "role": "protected",
				"stationary": false, "locks_mana": false
			}],
			"reinforcements": [{
				"unit": "Cinder Battery-176", "side": 1,
				"round": 3, "row": 0, "col": 6
			}]
		}
	},
	{
		"id": "overclock_gauntlet",
		"title": "Overclock Gauntlet",
		"subtitle": "Survive the Acceleration",
		"briefing": "A Zephyr proving cadre has uncapped its drive governors. Endure five rounds while their formation accelerates beyond safe limits.",
		"opponent_name": "Circuit Ace Tal",
		"opponent_affiliation": "Zephyr Proving Cadre",
		"squad_faction": "Wind",
		"enemy_hp": 20,
		"skill": "Rally",
		"enemy_squad": [
			"Zephyr Lancer-222", "Zephyr Mender-209", "Zephyr Weaver-169",
			"Zephyr Battery-040", "Zephyr Lancer-204", "Zephyr Blade-076",
			"Zephyr Bastion-153", "Zephyr Battery-089"
		],
		"rules": {
			"objective": {
				"type": "survive",
				"rounds": 5,
				"title": "Survive the Acceleration",
				"description": "Keep your Conductor operational through round 5."
			},
			"blocked_cells": [{"row": 1, "col": 3}],
			"mana": {
				"player_start": 2, "enemy_start": 4, "growth": 2, "cap": 8
			},
			"reinforcements": [
				{
					"unit": "Zephyr Lancer-221", "side": 1,
					"round": 2, "row": 0, "col": 6
				},
				{
					"unit": "Zephyr Battery-088", "side": 1,
					"round": 4, "row": 2, "col": 6
				}
			]
		}
	},
	{
		"id": "null_hunt",
		"title": "Null Hunt",
		"subtitle": "Break the Signal Core",
		"briefing": "A Fusion interdiction cell is masking its command signal behind a priority chassis. Destroy that core before the operation window closes.",
		"opponent_name": "Null Auditor Senn",
		"opponent_affiliation": "Fusion Interdiction Office",
		"squad_faction": "Fusion",
		"enemy_hp": 20,
		"skill": "Firestorm",
		"enemy_squad": [
			"Flux Weaver-212", "Flux Mender-195", "Flux Bastion-154",
			"Flux Battery-141", "Flux Lancer-080", "Flux Blade-074",
			"Flux Weaver-193", "Flux Mender-185"
		],
		"rules": {
			"objective": {
				"type": "eliminate_target",
				"target_name": "the signal core",
				"title": "Break the Signal Core",
				"description": "Eliminate the marked signal core before the six-round window closes."
			},
			"turn_limit": 6,
			"blocked_cells": [
				{"row": 0, "col": 2}, {"row": 2, "col": 4}
			],
			"predeployed": [{
				"unit": "Flux Weaver-207", "side": 1,
				"row": 1, "col": 4, "role": "priority",
				"stationary": true, "locks_mana": false
			}],
			"reinforcements": [{
				"unit": "Flux Lancer-079", "side": 1,
				"round": 3, "row": 2, "col": 6
			}]
		}
	}
]

static func all_challenges() -> Array:
	var result: Array = []
	for authored in CHALLENGES:
		result.append(_normalized_challenge(authored))
	return result

static func by_id(challenge_id: String) -> Dictionary:
	for challenge in all_challenges():
		if challenge.id == challenge_id:
			return challenge
	return {}

## Returns UTC ISO-week metadata. Supplying a timestamp keeps rotation tests and
## future saved challenge runs deterministic; -1 selects the current system time.
static func cycle_for_unix_time(unix_time: int = -1) -> Dictionary:
	var timestamp := unix_time
	if timestamp < 0:
		timestamp = int(Time.get_unix_time_from_system())
	var day_index := floori(float(timestamp) / float(SECONDS_PER_DAY))
	var monday_day := day_index - _positive_mod(day_index + 3, 7)
	var thursday_date: Dictionary = Time.get_datetime_dict_from_unix_time(
		(monday_day + 3) * SECONDS_PER_DAY
	)
	var week_year := int(thursday_date.year)
	var january_fourth := int(Time.get_unix_time_from_datetime_dict({
		"year": week_year, "month": 1, "day": 4,
		"hour": 0, "minute": 0, "second": 0
	}))
	var january_fourth_day := floori(float(january_fourth) / float(SECONDS_PER_DAY))
	var week_one_monday := january_fourth_day - _positive_mod(
		january_fourth_day + 3, 7
	)
	var week_number := floori(float(monday_day - week_one_monday) / 7.0) + 1
	return {
		"id": "%04d-W%02d" % [week_year, week_number],
		"year": week_year,
		"week": week_number,
		"starts_unix": monday_day * SECONDS_PER_DAY,
		"ends_unix": (monday_day + 7) * SECONDS_PER_DAY
	}

static func active_for_unix_time(unix_time: int = -1) -> Dictionary:
	var cycle := cycle_for_unix_time(unix_time)
	var anchor_unix := int(Time.get_unix_time_from_datetime_dict(ROTATION_ANCHOR))
	var anchor_day := floori(float(anchor_unix) / float(SECONDS_PER_DAY))
	var cycle_day := floori(float(cycle.starts_unix) / float(SECONDS_PER_DAY))
	var rotation_number := floori(float(cycle_day - anchor_day) / 7.0)
	var challenge_index := _positive_mod(rotation_number, CHALLENGES.size())
	var challenge := _normalized_challenge(CHALLENGES[challenge_index])
	challenge["cycle_id"] = cycle.id
	challenge["starts_unix"] = cycle.starts_unix
	challenge["ends_unix"] = cycle.ends_unix
	challenge["claim_id"] = claim_id(cycle.id, challenge.id)
	return challenge

static func claim_id(cycle_id: String, challenge_id: String) -> String:
	if not is_valid_cycle_id(cycle_id) or by_id(challenge_id).is_empty():
		return ""
	return "challenge:%s:%s" % [cycle_id, challenge_id]

static func is_valid_cycle_id(cycle_id: String) -> bool:
	if cycle_id.length() != 8 or cycle_id.substr(4, 2) != "-W":
		return false
	if not cycle_id.substr(0, 4).is_valid_int() or not cycle_id.substr(6, 2).is_valid_int():
		return false
	var week := int(cycle_id.substr(6, 2))
	return int(cycle_id.substr(0, 4)) >= 1970 and week >= 1 and week <= 53

static func is_valid_claim_id(value: String) -> bool:
	var parts := value.split(":")
	return (
		parts.size() == 3 and parts[0] == "challenge"
		and is_valid_cycle_id(parts[1]) and not by_id(parts[2]).is_empty()
	)

static func _normalized_challenge(authored: Dictionary) -> Dictionary:
	var result: Dictionary = authored.duplicate(true)
	result["reward_credits"] = REWARD_CREDITS
	result["rules"] = MissionRulesScript.normalize(result.get("rules", {}))
	return result

static func _positive_mod(value: int, divisor: int) -> int:
	return ((value % divisor) + divisor) % divisor
