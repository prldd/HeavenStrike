class_name UnitAssemblyCatalog
extends RefCounted

## Small, data-only vocabulary for assembling readable robot silhouettes.
## The creator uses these names directly; battlefield recipes can later store
## their integer indices in replay-safe unit metadata.
const FACTIONS := ["Coal", "Steam", "Wind", "Fusion", "Solar", "Universal"]
const CLASSES := [
	"Warden", "Duelist", "Strider", "Artillerist", "Channeler", "Lifebinder"
]
const FRAMES := ["Standard", "Bulwark", "Swift", "Resonant"]
const HEADS := ["Visor", "Cyclops", "Crown", "Sensor Array"]
const FINISHES := ["Field", "Officer", "Prototype"]
const POSES := ["Idle", "Traverse", "Attack"]

const FACTION_NOTES := {
	"Coal": "Riveted furnace armor, hot seams, soot-dark mass.",
	"Steam": "Brass pressure fittings, rounded plates, utility-first construction.",
	"Wind": "Pale aerodynamic shells, fins, and cool blue signal light.",
	"Fusion": "Dark containment armor split by volatile magenta energy.",
	"Solar": "Ivory ceremonial plates, gold structure, sun-hot emitters.",
	"Universal": "Neutral field steel with cyan command-deck identification."
}

const CLASS_KITS := {
	"Warden": {
		"role": "Defender",
		"weapon": "Pile-driver + barrier plate",
		"motion": "Heavy brace, recoil through the planted leg"
	},
	"Duelist": {
		"role": "Fighter",
		"weapon": "Powered cleaver",
		"motion": "Shoulder-led advancing cut"
	},
	"Strider": {
		"role": "Scout",
		"weapon": "Paired impulse blades",
		"motion": "Digitigrade sprint and alternating strikes"
	},
	"Artillerist": {
		"role": "Gunner",
		"weapon": "Shoulder rail assembly",
		"motion": "Barrel charge, discharge, damped recoil"
	},
	"Channeler": {
		"role": "Mage",
		"weapon": "Resonance coil and focusing staff",
		"motion": "Orbiting charge gathered into a cast"
	},
	"Lifebinder": {
		"role": "Priest",
		"weapon": "Repair projector",
		"motion": "Emitter bloom and restorative pulse"
	}
}

static func default_recipe() -> Dictionary:
	return {
		"faction": "Coal",
		"class": "Warden",
		"frame": "Bulwark",
		"head": "Cyclops",
		"finish": "Field",
		"pose": "Idle"
	}

static func normalize(recipe: Dictionary) -> Dictionary:
	var result := default_recipe()
	for key in result:
		if recipe.has(key):
			result[key] = recipe[key]
	result.faction = _valid_or_default(String(result.faction), FACTIONS, "Universal")
	result["class"] = _valid_or_default(String(result["class"]), CLASSES, "Warden")
	result.frame = _valid_or_default(String(result.frame), FRAMES, "Standard")
	result.head = _valid_or_default(String(result.head), HEADS, "Visor")
	result.finish = _valid_or_default(String(result.finish), FINISHES, "Field")
	result.pose = _valid_or_default(String(result.pose), POSES, "Idle")
	return result

static func random_recipe(seed_value: int) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	return {
		"faction": FACTIONS[rng.randi_range(0, FACTIONS.size() - 1)],
		"class": CLASSES[rng.randi_range(0, CLASSES.size() - 1)],
		"frame": FRAMES[rng.randi_range(0, FRAMES.size() - 1)],
		"head": HEADS[rng.randi_range(0, HEADS.size() - 1)],
		"finish": FINISHES[rng.randi_range(0, FINISHES.size() - 1)],
		"pose": "Idle"
	}

static func palette(faction: String, finish: String = "Field") -> Dictionary:
	var colors: Dictionary
	match faction:
		"Coal":
			colors = {"armor": Color("#592f2b"), "trim": Color("#d36a3d"), "energy": Color("#ffb34f")}
		"Steam":
			colors = {"armor": Color("#786446"), "trim": Color("#d6b66e"), "energy": Color("#70d9df")}
		"Wind":
			colors = {"armor": Color("#c8d8d5"), "trim": Color("#4b91a6"), "energy": Color("#7ff3ff")}
		"Fusion":
			colors = {"armor": Color("#403653"), "trim": Color("#c357ad"), "energy": Color("#ff79e6")}
		"Solar":
			colors = {"armor": Color("#e4ddbf"), "trim": Color("#d79a32"), "energy": Color("#fff09a")}
		_:
			colors = {"armor": Color("#60737a"), "trim": Color("#38c7d6"), "energy": Color("#b8f3f5")}
	colors["joint"] = Color("#17252b")
	colors["edge"] = Color("#071117")
	match finish:
		"Officer":
			colors.armor = (colors.armor as Color).lightened(0.12)
			colors.trim = (colors.trim as Color).lightened(0.16)
		"Prototype":
			colors.armor = (colors.armor as Color).darkened(0.18)
			colors.energy = Color("#f4fbff")
	return colors

static func class_kit(kind: String) -> Dictionary:
	return CLASS_KITS.get(kind, CLASS_KITS.Warden)

static func recipe_code(recipe: Dictionary) -> String:
	var clean := normalize(recipe)
	return "%s-%s-%s-%s" % [
		String(clean.faction).left(2).to_upper(),
		String(clean["class"]).left(2).to_upper(),
		String(clean.frame).left(2).to_upper(),
		String(clean.head).left(2).to_upper()
	]

static func combination_count() -> int:
	return FACTIONS.size() * CLASSES.size() * FRAMES.size() * HEADS.size() * FINISHES.size()

static func _valid_or_default(value: String, options: Array, fallback: String) -> String:
	return value if value in options else fallback
