class_name UnitCatalog
extends RefCounted

const CLASS_NAMES := {
	"Strider": "Scout",
	"Duelist": "Fighter",
	"Warden": "Defender",
	"Artillerist": "Gunner",
	"Channeler": "Mage",
	"Lifebinder": "Priest"
}

const CLASS_COLORS := {
	"Strider": Color("#52cfff"),
	"Duelist": Color("#ff8a54"),
	"Warden": Color("#56d98d"),
	"Artillerist": Color("#f2c44f"),
	"Channeler": Color("#b987ff"),
	"Lifebinder": Color("#ff77b2")
}

const ICON_ART_IDS := {
	25: 29, # Order Apostle
	26: 33, # Trinity Messenger
	27: 83, # Minerva the Brave
	28: 177, # Naruku the Lookout
	29: 423, # Whirling Ragnr
	31: 30, # Order Missionary
	32: 34, # Trinity Herald
	33: 84, # Minerva the Lionheart
	34: 178, # Farsight Naruku
	35: 424, # Macewielder Ragnr
	37: 77, # Talon Scratcher
	38: 78, # Talon Slasher
	39: 535, # Innocent Gretel
	40: 536, # Witchkiller Gretel
	41: 611, # Talon Slicer
	43: 41, # Street Urchin
	44: 42, # Street Hoodlum
	81: 39, # Claw Chopper
	82: 40, # Claw Cleaver
	83: 43, # LDF Bowgunner
	84: 44, # LDF Bolt Slinger
	85: 75, # LDF Swordwielder
	86: 76, # LDF Greatsword
	87: 609, # LDF Mastersword
	49: 47, # Street Nurse
	50: 48, # Street Matron
	51: 59, # Blight Doctor
	52: 60, # Blight Physician
	53: 85, # Captain Kerryson
	54: 86, # Kerryson the Stoic
	55: 57, # Fortune Teller
	56: 58, # Fortune Diviner
	57: 55, # Dart Shooter
	58: 56, # Dart Sharpshooter
	59: 165, # Frog-Hopper Keru
	60: 166, # Lizard-Licker Keru
	61: 187, # Blightshot
	62: 188, # Toxic Shot
	63: 79, # Garrett Talon
	64: 80, # Garrett the Claw
	65: 613, # Garrett the Raider
	66: 103, # Precision Shooter
	67: 104, # Precision Sniper
	68: 629, # Precision Trigger
	69: 101, # Greyson the Shifty
	70: 102, # Greyson the Shrewd
	71: 167, # Communicator Ripley
	72: 168, # The Telecommunicator
	73: 183, # Vicious Pierrot
	74: 184, # Pierrot the Deciever
	75: 27, # LDF Flight Officer
	76: 28, # LDF Flight Commander
	77: 89, # Prison Warden
	78: 90, # Prison Guv'nor
	79: 487, # Shakespeare
	80: 488 # The Bard
}

static var _units: Array[UnitData] = []

## Per-level secondary skill magnitudes, ported from the unit reference
## (chainguardians.com). Row index is unit level - 1; each row holds the
## values substituted into the {0}/{1} placeholders of the skill description.
const RANK_VALUES := {
	"Fortify": [["3 HP", "2 turns"], ["3 HP", "3 turns"], ["4 HP", "3 turns"], ["4 HP", "4 turns"], ["5 HP", "5 turns"]],
	"Empower": [["1 ATK", "2 turns"], ["1 ATK", "3 turns"], ["2 ATK", "3 turns"], ["2 ATK", "4 turns"], ["2 ATK", "5 turns"]],
	"Bolt": [["1 damage"], ["2 damage"], ["3 damage"], ["4 damage"], ["5 damage"]],
	"Heaven's Wrath": [["1 damage"], ["2 damage"], ["3 damage"], ["4 damage"], ["5 damage"]],
	"Misfortune": [["1 ATK", "2 turns"], ["2 ATK", "2 turns"], ["3 ATK", "2 turns"], ["3 ATK", "3 turns"], ["4 ATK", "3 turns"]],
	"Mend": [["3 HP"], ["4 HP"], ["5 HP"], ["6 HP"], ["7 HP"]],
	"Plague": [["1 damage", "2 turns"], ["2 damage", "2 turns"], ["2 damage", "3 turns"], ["2 damage", "4 turns"], ["3 damage", "4 turns"]],
	"Envenom": [["2 turns"], ["3 turns"], ["4 turns"], ["5 turns"], ["6 turns"]],
	"Pin Down": [["1 damage", "1 turn"], ["2 damage", "1 turn"], ["3 damage", "1 turn"], ["3 damage", "2 turns"], ["4 damage", "2 turns"]],
	"Sunder Armour": [["1 damage", "2 turns"], ["2 damage", "2 turns"], ["2 damage", "3 turns"], ["3 damage", "3 turns"], ["3 damage", "4 turns"]],
	"Demoralize": [["1 ATK", "2 turns"], ["2 ATK", "2 turns"], ["3 ATK", "2 turns"], ["3 ATK", "3 turns"], ["4 ATK", "3 turns"]],
	"Punish": [["1 ATK", "2 turns"], ["2 ATK", "2 turns"], ["3 ATK", "2 turns"], ["3 ATK", "3 turns"], ["4 ATK", "3 turns"]],
	"Pinning Strike": [["30% chance", "1 turn"], ["32% chance", "1 turn"], ["35% chance", "1 turn"], ["37% chance", "2 turns"], ["40% chance", "2 turns"]],
	"Pinning Slice": [["60% chance", "1 turn"], ["70% chance", "1 turn"], ["80% chance", "1 turn"], ["90% chance", "2 turns"], ["100% chance", "2 turns"]],
	"Poison Strike": [["50% chance", "2 turns"], ["60% chance", "2 turns"], ["70% chance", "2 turns"], ["80% chance", "3 turns"], ["90% chance", "3 turns"]]
}

static func _skill(name: String, type: String, chance: float, text: String) -> SkillData:
	var s := SkillData.new()
	s.name = name
	s.type = type
	s.chance = chance
	s.description = text
	s.rank_values = RANK_VALUES.get(name, [])
	return s

static func _unit(
	name: String,
	icon: int,
	stars: int,
	kind: String,
	cost: int,
	atk: int,
	hp: int,
	move: int,
	range: int,
	text: String,
	promotion_of: String = "",
	skill: SkillData = null
) -> UnitData:
	var u := UnitData.new()
	u.name = name
	u.icon = icon
	u.stars = stars
	u.kind = kind
	u.cost = cost
	u.atk = atk
	u.hp = hp
	u.move = move
	u.range = range
	u.description = text
	u.promotion_of = promotion_of
	u.skill = skill
	return u

static func _build() -> void:
	if not _units.is_empty():
		return
	_units = [
		_unit('Trinity Rusher', 3, 1, 'Strider', 2, 2, 4, 3, 1, 'Double Strike — Attacks twice each action.', '', null),
		_unit('Claw Slicer', 9, 1, 'Strider', 3, 3, 5, 3, 1, 'Double Strike — Attacks twice each action.', '', null),
		_unit('Pub Bouncer', 2, 1, 'Duelist', 2, 3, 7, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', '', null),
		_unit('Trinity Basher', 8, 1, 'Duelist', 2, 3, 5, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', '', null),
		_unit('Socialite Fencer', 1, 1, 'Warden', 3, 3, 10, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', '', null),
		_unit('LDF Peacekeeper', 7, 1, 'Warden', 2, 2, 8, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', '', null),
		_unit('Trinity Potshot', 4, 1, 'Artillerist', 2, 3, 4, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', '', null),
		_unit('Factory Markswoman', 10, 1, 'Artillerist', 3, 4, 5, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', '', null),
		_unit('Claw Caster', 5, 1, 'Channeler', 3, 5, 4, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', '', null),
		_unit('Rage Spellslinger', 11, 1, 'Channeler', 2, 4, 3, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', '', null),
		_unit('Chain Initiate', 6, 1, 'Lifebinder', 2, 2, 5, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', '', null),
		_unit('LDF Medic', 12, 1, 'Lifebinder', 3, 3, 5, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', '', null),
		_unit('Apprentice Builder', 13, 2, 'Warden', 3, 2, 4, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', '', _skill('Fortify', 'Warcry', -1.0, 'Other allied unit with the lowest HP gains +{0} for {1}.')),
		_unit('Rage Brute', 15, 2, 'Duelist', 2, 2, 4, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', '', _skill('Empower', 'Warcry', -1.0, 'Another allied unit gains +{0} for {1}.')),
		_unit('Claw Skirmisher', 17, 2, 'Strider', 3, 2, 3, 3, 1, 'Double Strike — Attacks twice each action.', '', _skill('Pinning Strike', 'Strike', -1.0, '{0} to Immobilise the attacked enemy for {1}.')),
		_unit('LDF Gunner', 19, 2, 'Artillerist', 2, 3, 2, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', '', _skill('Bolt', 'Warcry', -1.0, 'Deal {0} to the enemy unit with the highest HP.')),
		_unit('Order Pupil', 21, 2, 'Channeler', 2, 3, 2, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', '', _skill("Heaven's Wrath", 'Warcry', -1.0, 'Deal {0} split between random enemy units.')),
		_unit('Order Cleric', 23, 2, 'Lifebinder', 3, 2, 4, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', '', _skill('Empower', 'Warcry', -1.0, 'Another allied unit gains +{0} for {1}.')),
		_unit('Order Apostle', 25, 2, 'Strider', 2, 2, 4, 3, 1, 'Double Strike — Attacks twice each action.', '', _skill("Heaven's Wrath", 'Warcry', -1.0, 'Deal {0} split between random enemy units.')),
		_unit('Trinity Messenger', 26, 2, 'Channeler', 3, 4, 2, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', '', _skill('Bolt', 'Warcry', -1.0, 'Deal {0} to the enemy unit with the highest HP.')),
		_unit('Minerva the Brave', 27, 3, 'Lifebinder', 2, 3, 4, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', '', _skill('Fortify', 'Warcry', -1.0, 'Other allied unit with the lowest HP gains +{0} for {1}.')),
		_unit('Naruku the Lookout', 28, 4, 'Channeler', 3, 3, 6, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', '', _skill('Empower', 'Warcry', -1.0, 'Another allied unit gains +{0} for {1}.')),
		_unit('Whirling Ragnr', 29, 4, 'Duelist', 2, 3, 5, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', '', _skill('Bolt', 'Warcry', -1.0, 'Deal {0} to the enemy unit with the highest HP.')),
		_unit('Master Builder', 14, 3, 'Warden', 3, 3, 6, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', 'Apprentice Builder', _skill('Fortify', 'Warcry', -1.0, 'Other allied unit with the lowest HP gains +{0} for {1}.')),
		_unit('Rage Bruiser', 16, 3, 'Duelist', 2, 3, 6, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', 'Rage Brute', _skill('Empower', 'Warcry', -1.0, 'Another allied unit gains +{0} for {1}.')),
		_unit('Claw Ambusher', 18, 3, 'Strider', 3, 3, 4, 3, 1, 'Double Strike — Attacks twice each action.', 'Claw Skirmisher', _skill('Pinning Strike', 'Strike', -1.0, '{0} to Immobilise the attacked enemy for {1}.')),
		_unit('LDF Sureshot', 20, 3, 'Artillerist', 2, 4, 4, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', 'LDF Gunner', _skill('Bolt', 'Warcry', -1.0, 'Deal {0} to the enemy unit with the highest HP.')),
		_unit('Order Scholar', 22, 3, 'Channeler', 2, 4, 4, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', 'Order Pupil', _skill("Heaven's Wrath", 'Warcry', -1.0, 'Deal {0} split between random enemy units.')),
		_unit('Order Chaplain', 24, 3, 'Lifebinder', 3, 3, 5, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', 'Order Cleric', _skill('Empower', 'Warcry', -1.0, 'Another allied unit gains +{0} for {1}.')),
		_unit('Order Missionary', 31, 3, 'Strider', 2, 2, 5, 3, 1, 'Double Strike — Attacks twice each action.', 'Order Apostle', _skill("Heaven's Wrath", 'Warcry', -1.0, 'Deal {0} split between random enemy units.')),
		_unit('Trinity Herald', 32, 3, 'Channeler', 3, 5, 4, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', 'Trinity Messenger', _skill('Bolt', 'Warcry', -1.0, 'Deal {0} to the enemy unit with the highest HP.')),
		_unit('Minerva the Lionheart', 33, 4, 'Lifebinder', 2, 4, 5, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', 'Minerva the Brave', _skill('Fortify', 'Warcry', -1.0, 'Other allied unit with the lowest HP gains +{0} for {1}.')),
		_unit('Farsight Naruku', 34, 5, 'Channeler', 3, 4, 6, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', 'Naruku the Lookout', _skill('Empower', 'Warcry', -1.0, 'Another allied unit gains +{0} for {1}.')),
		_unit('Macewielder Ragnr', 35, 5, 'Duelist', 2, 3, 6, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', 'Whirling Ragnr', _skill('Bolt', 'Warcry', -1.0, 'Deal {0} to the enemy unit with the highest HP.')),
		_unit('Talon Scratcher', 37, 3, 'Strider', 4, 2, 4, 3, 1, 'Double Strike — Attacks twice each action.', '', _skill('Pinning Slice', 'Strike', -1.0, '{0} to Immobilise the attacked enemy for {1}.')),
		_unit('Talon Slasher', 38, 4, 'Strider', 4, 3, 5, 3, 1, 'Double Strike — Attacks twice each action.', 'Talon Scratcher', _skill('Pinning Slice', 'Strike', -1.0, '{0} to Immobilise the attacked enemy for {1}.')),
		_unit('Innocent Gretel', 39, 4, 'Artillerist', 3, 3, 6, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', '', _skill('Pinning Slice', 'Strike', -1.0, '{0} to Immobilise the attacked enemy for {1}.')),
		_unit('Witchkiller Gretel', 40, 5, 'Artillerist', 3, 3, 7, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', 'Innocent Gretel', _skill('Pinning Slice', 'Strike', -1.0, '{0} to Immobilise the attacked enemy for {1}.')),
		_unit('Talon Slicer', 41, 5, 'Strider', 3, 3, 6, 3, 1, 'Double Strike — Attacks twice each action.', 'Talon Slasher', _skill('Pinning Slice', 'Strike', -1.0, '{0} to Immobilise the attacked enemy for {1}.')),
		_unit('Street Urchin', 43, 2, 'Strider', 3, 2, 2, 3, 1, 'Double Strike — Attacks twice each action.', '', _skill('Misfortune', 'Warcry', -1.0, 'Enemy Scout or Gunner with the highest ATK loses {0} for {1}.')),
		_unit('Street Hoodlum', 44, 3, 'Strider', 3, 3, 3, 3, 1, 'Double Strike — Attacks twice each action.', 'Street Urchin', _skill('Misfortune', 'Warcry', -1.0, 'Enemy Scout or Gunner with the highest ATK loses {0} for {1}.')),
		_unit('LDF Crowd Mage', 45, 2, 'Channeler', 2, 2, 4, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', '', _skill('Misfortune', 'Warcry', -1.0, 'Enemy Scout or Gunner with the highest ATK loses {0} for {1}.')),
		_unit('LDF Riot Mage', 46, 3, 'Channeler', 2, 3, 6, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', 'LDF Crowd Mage', _skill('Misfortune', 'Warcry', -1.0, 'Enemy Scout or Gunner with the highest ATK loses {0} for {1}.')),
		_unit('Fortune Teller', 55, 3, 'Channeler', 2, 2, 5, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', '', _skill('Misfortune', 'Warcry', -1.0, 'Enemy Scout or Gunner with the highest ATK loses {0} for {1}.')),
		_unit('Fortune Diviner', 56, 4, 'Channeler', 2, 3, 7, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', 'Fortune Teller', _skill('Misfortune', 'Warcry', -1.0, 'Enemy Scout or Gunner with the highest ATK loses {0} for {1}.')),
		_unit('Street Nurse', 49, 2, 'Lifebinder', 3, 2, 3, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', '', _skill('Mend', 'Warcry', -1.0, 'Restore {0} to the allied unit with the lowest HP.')),
		_unit('Street Matron', 50, 3, 'Lifebinder', 3, 3, 4, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', 'Street Nurse', _skill('Mend', 'Warcry', -1.0, 'Restore {0} to the allied unit with the lowest HP.')),
		_unit('Blight Doctor', 51, 3, 'Lifebinder', 3, 2, 6, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', '', _skill('Plague', 'Warcry', -1.0, 'Deal {0} to every other unit and Poison them for {1}.')),
		_unit('Blight Physician', 52, 4, 'Lifebinder', 3, 3, 7, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', 'Blight Doctor', _skill('Plague', 'Warcry', -1.0, 'Deal {0} to every other unit and Poison them for {1}.')),
		_unit('Captain Kerryson', 53, 3, 'Warden', 2, 3, 6, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', '', _skill('Mend', 'Warcry', -1.0, 'Restore {0} to the allied unit with the lowest HP.')),
		_unit('Kerryson the Stoic', 54, 4, 'Warden', 2, 4, 8, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', 'Captain Kerryson', _skill('Mend', 'Warcry', -1.0, 'Restore {0} to the allied unit with the lowest HP.')),
		_unit('Dart Shooter', 57, 3, 'Artillerist', 3, 4, 3, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', '', _skill('Envenom', 'Warcry', -1.0, 'Poison a selected enemy unit for {0}.')),
		_unit('Dart Sharpshooter', 58, 4, 'Artillerist', 3, 5, 5, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', 'Dart Shooter', _skill('Envenom', 'Warcry', -1.0, 'Poison a selected enemy unit for {0}.')),
		_unit('Frog-Hopper Keru', 59, 4, 'Channeler', 2, 3, 7, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', '', _skill('Envenom', 'Warcry', -1.0, 'Poison a selected enemy unit for {0}.')),
		_unit('Lizard-Licker Keru', 60, 5, 'Channeler', 2, 4, 8, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', 'Frog-Hopper Keru', _skill('Envenom', 'Warcry', -1.0, 'Poison a selected enemy unit for {0}.')),
		_unit('Blightshot', 61, 4, 'Artillerist', 2, 2, 6, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', '', _skill('Envenom', 'Warcry', -1.0, 'Poison a selected enemy unit for {0}.')),
		_unit('Toxic Shot', 62, 5, 'Artillerist', 2, 3, 8, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', 'Blightshot', _skill('Envenom', 'Warcry', -1.0, 'Poison a selected enemy unit for {0}.')),
		_unit('Garrett Talon', 63, 3, 'Artillerist', 3, 3, 6, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', '', _skill('Pin Down', 'Warcry', -1.0, 'Deal {0} to the highest-ATK enemy Defender, Fighter, or Scout and Immobilise it for {1}.')),
		_unit('Garrett the Claw', 64, 4, 'Artillerist', 3, 4, 7, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', 'Garrett Talon', _skill('Pin Down', 'Warcry', -1.0, 'Deal {0} to the highest-ATK enemy Defender, Fighter, or Scout and Immobilise it for {1}.')),
		_unit('Garrett the Raider', 65, 5, 'Artillerist', 2, 5, 7, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', 'Garrett the Claw', _skill('Pin Down', 'Warcry', -1.0, 'Deal {0} to the highest-ATK enemy Defender, Fighter, or Scout and Immobilise it for {1}.')),
		_unit('Precision Shooter', 66, 3, 'Artillerist', 3, 3, 5, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', '', _skill('Pin Down', 'Warcry', -1.0, 'Deal {0} to the highest-ATK enemy Defender, Fighter, or Scout and Immobilise it for {1}.')),
		_unit('Precision Sniper', 67, 4, 'Artillerist', 3, 4, 7, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', 'Precision Shooter', _skill('Pin Down', 'Warcry', -1.0, 'Deal {0} to the highest-ATK enemy Defender, Fighter, or Scout and Immobilise it for {1}.')),
		_unit('Precision Trigger', 68, 5, 'Artillerist', 2, 4, 8, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', 'Precision Sniper', _skill('Pin Down', 'Warcry', -1.0, 'Deal {0} to the highest-ATK enemy Defender, Fighter, or Scout and Immobilise it for {1}.')),
		_unit('Greyson the Shifty', 69, 3, 'Strider', 4, 2, 6, 3, 1, 'Double Strike — Attacks twice each action.', '', _skill('Demoralize', 'Warcry', -1.0, 'Enemy Fighters, Scouts, and Defenders in a selected lane lose {0} for {1}.')),
		_unit('Greyson the Shrewd', 70, 4, 'Strider', 4, 4, 6, 3, 1, 'Double Strike — Attacks twice each action.', 'Greyson the Shifty', _skill('Demoralize', 'Warcry', -1.0, 'Enemy Fighters, Scouts, and Defenders in a selected lane lose {0} for {1}.')),
		_unit('Communicator Ripley', 71, 4, 'Lifebinder', 2, 3, 4, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', '', _skill('Demoralize', 'Warcry', -1.0, 'Enemy Fighters, Scouts, and Defenders in a selected lane lose {0} for {1}.')),
		_unit('The Telecommunicator', 72, 5, 'Lifebinder', 2, 4, 5, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', 'Communicator Ripley', _skill('Demoralize', 'Warcry', -1.0, 'Enemy Fighters, Scouts, and Defenders in a selected lane lose {0} for {1}.')),
		_unit('Vicious Pierrot', 73, 4, 'Duelist', 3, 5, 7, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', '', _skill('Demoralize', 'Warcry', -1.0, 'Enemy Fighters, Scouts, and Defenders in a selected lane lose {0} for {1}.')),
		_unit('Pierrot the Deciever', 74, 5, 'Duelist', 3, 7, 9, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', 'Vicious Pierrot', _skill('Demoralize', 'Warcry', -1.0, 'Enemy Fighters, Scouts, and Defenders in a selected lane lose {0} for {1}.')),
		_unit('LDF Flight Officer', 75, 2, 'Duelist', 2, 4, 4, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', '', _skill('Punish', 'Warcry', -1.0, 'The highest-ATK enemy Fighter or Mage loses {0} for {1}.')),
		_unit('LDF Flight Commander', 76, 3, 'Duelist', 2, 5, 4, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', 'LDF Flight Officer', _skill('Punish', 'Warcry', -1.0, 'The highest-ATK enemy Fighter or Mage loses {0} for {1}.')),
		_unit('Prison Warden', 77, 3, 'Strider', 4, 3, 5, 3, 1, 'Double Strike — Attacks twice each action.', '', _skill('Punish', 'Warcry', -1.0, 'The highest-ATK enemy Fighter or Mage loses {0} for {1}.')),
		_unit("Prison Guv'nor", 78, 4, 'Strider', 4, 4, 6, 3, 1, 'Double Strike — Attacks twice each action.', 'Prison Warden', _skill('Punish', 'Warcry', -1.0, 'The highest-ATK enemy Fighter or Mage loses {0} for {1}.')),
		_unit('Shakespeare', 79, 4, 'Strider', 2, 2, 4, 3, 1, 'Double Strike — Attacks twice each action.', '', _skill('Punish', 'Warcry', -1.0, 'The highest-ATK enemy Fighter or Mage loses {0} for {1}.')),
		_unit('The Bard', 80, 5, 'Strider', 2, 2, 5, 3, 1, 'Double Strike — Attacks twice each action.', 'Shakespeare', _skill('Punish', 'Warcry', -1.0, 'The highest-ATK enemy Fighter or Mage loses {0} for {1}.')),
		_unit('Claw Chopper', 81, 2, 'Duelist', 3, 3, 8, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', '', _skill('Poison Strike', 'Strike', -1.0, '{0} to Poison the attacked enemy for {1}.')),
		_unit('Claw Cleaver', 82, 3, 'Duelist', 3, 4, 9, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', 'Claw Chopper', _skill('Poison Strike', 'Strike', -1.0, '{0} to Poison the attacked enemy for {1}.')),
		_unit('LDF Bowgunner', 83, 2, 'Artillerist', 4, 5, 4, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', '', _skill('Sunder Armour', 'Warcry', -1.0, 'Deal {0} to the highest-HP enemy Defender or Fighter and make it Vulnerable for {1}.')),
		_unit('LDF Bolt Slinger', 84, 3, 'Artillerist', 4, 6, 6, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', 'LDF Bowgunner', _skill('Sunder Armour', 'Warcry', -1.0, 'Deal {0} to the highest-HP enemy Defender or Fighter and make it Vulnerable for {1}.')),
		_unit('LDF Swordwielder', 85, 3, 'Duelist', 2, 4, 5, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', '', _skill('Sunder Armour', 'Warcry', -1.0, 'Deal {0} to the highest-HP enemy Defender or Fighter and make it Vulnerable for {1}.')),
		_unit('LDF Greatsword', 86, 4, 'Duelist', 2, 5, 6, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', 'LDF Swordwielder', _skill('Sunder Armour', 'Warcry', -1.0, 'Deal {0} to the highest-HP enemy Defender or Fighter and make it Vulnerable for {1}.')),
		_unit('LDF Mastersword', 87, 5, 'Duelist', 2, 6, 7, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', 'LDF Greatsword', _skill('Sunder Armour', 'Warcry', -1.0, 'Deal {0} to the highest-HP enemy Defender or Fighter and make it Vulnerable for {1}.')),
	]

static func all_units() -> Array[UnitData]:
	_build()
	return _units

static func by_name(unit_name: String) -> UnitData:
	_build()
	for unit in _units:
		if unit.name == unit_name:
			return unit
	return null

static func display_class(kind: String) -> String:
	return CLASS_NAMES.get(kind, kind)

static func class_color(kind: String) -> Color:
	return CLASS_COLORS.get(kind, Color("#91a7ce"))

static func art_id(icon_id: int) -> int:
	return ICON_ART_IDS.get(icon_id, icon_id)
