class_name UnitData
extends Resource

@export var name: String = ""
@export var icon: int = 0
@export var stars: int = 1
@export var kind: String = ""
@export var cost: int = 0
@export var atk: int = 0
@export var hp: int = 0
@export var move: int = 0
@export var range: int = 0
@export var chassis_family: String = "standard"
@export var description: String = ""
@export var promotion_of: String = ""
@export var skill: SkillData = null

## Returns the catalog entry as a plain Dictionary with the same key set the
## roster historically used. Deck and hand cards are built from this dict.
func to_dict() -> Dictionary:
	var result := {
		"name": name,
		"icon": icon,
		"stars": stars,
		"kind": kind,
		"cost": cost,
		"atk": atk,
		"hp": hp,
		"move": move,
		"range": range,
		"chassis_family": chassis_family,
		"text": description,
	}
	if promotion_of != "":
		result["promotion_of"] = promotion_of
	if skill != null:
		result["skill"] = skill.to_dict()
	return result
