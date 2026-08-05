class_name BattleResults
extends RefCounted

const PLAYER := 0
const MAX_SCORE := 1000
const VICTORY_POINTS := 350
const INTEGRITY_POINTS := 300
const FORMATION_POINTS := 190
const TEMPO_POINTS := 160
const RATING_WORDS := [
	"", "SURVIVED", "HARD WON", "GRITTY", "CLOSE CALL", "SOLID",
	"GOOD", "GREAT", "EXCELLENT", "AMAZING", "FLAWLESS"
]

static func calculate(
	player_hp: int,
	max_hp: int,
	rounds: int,
	units: Array,
	events: Array
) -> Dictionary:
	var safe_max_hp := maxi(1, max_hp)
	var safe_player_hp := clampi(player_hp, 0, safe_max_hp)
	var integrity_points := roundi(
		INTEGRITY_POINTS * safe_player_hp / float(safe_max_hp)
	)

	var deployed_ids: Array[int] = []
	for event in events:
		if (
			event.get("type", "") == "deploy"
			and int(event.get("side", -1)) == PLAYER
		):
			var unit_id := int(event.get("unit_id", -1))
			if unit_id >= 0 and unit_id not in deployed_ids:
				deployed_ids.append(unit_id)
	var surviving_ids: Array[int] = []
	for unit in units:
		var unit_id := int(unit.get("id", -1))
		if (
			int(unit.get("side", -1)) == PLAYER and unit.get("hp", 0) > 0
			and unit_id in deployed_ids
		):
			surviving_ids.append(unit_id)
	var formation_points := FORMATION_POINTS
	if not deployed_ids.is_empty():
		formation_points = roundi(
			FORMATION_POINTS * surviving_ids.size() / float(deployed_ids.size())
		)

	var safe_rounds := maxi(1, rounds)
	var tempo_points := clampi(
		TEMPO_POINTS - maxi(0, safe_rounds - 1) * 15,
		40,
		TEMPO_POINTS
	)
	var score := clampi(
		VICTORY_POINTS + integrity_points + formation_points + tempo_points,
		0,
		MAX_SCORE
	)
	var rating := clampi(ceili(score / 100.0), 1, 10)
	return {
		"score": score,
		"max_score": MAX_SCORE,
		"rating": rating,
		"word": RATING_WORDS[rating],
		"victory_points": VICTORY_POINTS,
		"integrity_points": integrity_points,
		"integrity_max": INTEGRITY_POINTS,
		"player_hp": safe_player_hp,
		"max_hp": safe_max_hp,
		"formation_points": formation_points,
		"formation_max": FORMATION_POINTS,
		"survivors": surviving_ids.size(),
		"deployed": deployed_ids.size(),
		"tempo_points": tempo_points,
		"tempo_max": TEMPO_POINTS,
		"rounds": safe_rounds
	}
