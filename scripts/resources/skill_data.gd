class_name SkillData
extends Resource

@export var name: String = ""
@export var type: String = ""
## Negative means the skill has no explicit chance (the resolver default applies).
@export var chance: float = -1.0
@export var description: String = ""

func to_dict() -> Dictionary:
	var result := {
		"name": name,
		"type": type,
		"text": description,
	}
	if chance >= 0.0:
		result["chance"] = chance
	return result
