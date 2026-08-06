class_name SkillData
extends Resource

@export var name: String = ""
@export var type: String = ""
## Negative means the skill has no explicit chance (the resolver default applies).
@export var chance: float = -1.0
@export var description: String = ""
## Per-level authored magnitudes. Row index is unit
## level - 1; each row holds the values substituted into the {0}/{1}
## placeholders of the description.
@export var rank_values: Array = []

func to_dict() -> Dictionary:
	var result := {
		"name": name,
		"type": type,
		"text": description,
	}
	if chance >= 0.0:
		result["chance"] = chance
	if not rank_values.is_empty():
		result["rank_values"] = rank_values.duplicate(true)
	return result

func values_for(level: int) -> Array:
	if rank_values.is_empty():
		return []
	var row = rank_values[clampi(level, 1, rank_values.size()) - 1]
	return row if row is Array else []

func format_text(level: int) -> String:
	var row := values_for(level)
	if row.is_empty():
		return description
	var result := description
	for index in row.size():
		result = result.replace("{%d}" % index, str(row[index]))
	return result
