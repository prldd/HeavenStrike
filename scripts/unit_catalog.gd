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

const UNITS := [
	{"name": "Trinity Rusher", "icon": 3, "stars": 1, "kind": "Strider", "cost": 2, "atk": 2, "hp": 4, "move": 3, "range": 1, "text": "Double Strike — Attacks twice each action."},
	{"name": "Claw Slicer", "icon": 9, "stars": 1, "kind": "Strider", "cost": 3, "atk": 3, "hp": 5, "move": 3, "range": 1, "text": "Double Strike — Attacks twice each action."},
	{"name": "Pub Bouncer", "icon": 2, "stars": 1, "kind": "Duelist", "cost": 2, "atk": 3, "hp": 7, "move": 2, "range": 1, "text": "Fury — Permanently gains +1 ATK after attacking."},
	{"name": "Trinity Basher", "icon": 8, "stars": 1, "kind": "Duelist", "cost": 2, "atk": 3, "hp": 5, "move": 2, "range": 1, "text": "Fury — Permanently gains +1 ATK after attacking."},
	{"name": "Socialite Fencer", "icon": 1, "stars": 1, "kind": "Warden", "cost": 3, "atk": 3, "hp": 10, "move": 2, "range": 1, "text": "Taunting Strike — Target cannot change lanes for 2 turns."},
	{"name": "LDF Peacekeeper", "icon": 7, "stars": 1, "kind": "Warden", "cost": 2, "atk": 2, "hp": 8, "move": 2, "range": 1, "text": "Taunting Strike — Target cannot change lanes for 2 turns."},
	{"name": "Trinity Potshot", "icon": 4, "stars": 1, "kind": "Artillerist", "cost": 2, "atk": 3, "hp": 4, "move": 1, "range": 3, "text": "Piercing Shot — Damages every enemy in range in its lane."},
	{"name": "Factory Markswoman", "icon": 10, "stars": 1, "kind": "Artillerist", "cost": 3, "atk": 4, "hp": 5, "move": 1, "range": 3, "text": "Piercing Shot — Damages every enemy in range in its lane."},
	{"name": "Claw Caster", "icon": 5, "stars": 1, "kind": "Channeler", "cost": 3, "atk": 5, "hp": 4, "move": 1, "range": 3, "text": "Blast — Adjacent enemies take half ATK damage."},
	{"name": "Rage Spellslinger", "icon": 11, "stars": 1, "kind": "Channeler", "cost": 2, "atk": 4, "hp": 3, "move": 1, "range": 3, "text": "Blast — Adjacent enemies take half ATK damage."},
	{"name": "Chain Initiate", "icon": 6, "stars": 1, "kind": "Lifebinder", "cost": 2, "atk": 2, "hp": 5, "move": 1, "range": 2, "text": "Heal — Before moving, gives 2 HP to the lowest-health ally."},
	{"name": "LDF Medic", "icon": 12, "stars": 1, "kind": "Lifebinder", "cost": 3, "atk": 3, "hp": 5, "move": 1, "range": 2, "text": "Heal — Before moving, gives 2 HP to the lowest-health ally."},
	{"name": "Apprentice Builder", "icon": 13, "stars": 2, "kind": "Warden", "cost": 3, "atk": 2, "hp": 4, "move": 2, "range": 1, "text": "Taunting Strike — Target cannot change lanes for 2 turns.", "skill": {"name": "Fortify", "type": "Warcry", "text": "Other allied unit with the lowest HP gains +3 HP for 2 turns."}},
	{"name": "Rage Brute", "icon": 15, "stars": 2, "kind": "Duelist", "cost": 2, "atk": 2, "hp": 4, "move": 2, "range": 1, "text": "Fury — Permanently gains +1 ATK after attacking.", "skill": {"name": "Empower", "type": "Warcry", "text": "Another allied unit gains +1 ATK for 2 turns."}},
	{"name": "Claw Skirmisher", "icon": 17, "stars": 2, "kind": "Strider", "cost": 3, "atk": 2, "hp": 3, "move": 3, "range": 1, "text": "Double Strike — Attacks twice each action.", "skill": {"name": "Pinning Strike", "type": "Strike", "text": "30% chance to Immobilise the attacked enemy for 1 turn."}},
	{"name": "LDF Gunner", "icon": 19, "stars": 2, "kind": "Artillerist", "cost": 2, "atk": 3, "hp": 2, "move": 1, "range": 3, "text": "Piercing Shot — Damages every enemy in range in its lane.", "skill": {"name": "Bolt", "type": "Warcry", "text": "Deal 1 damage to the enemy unit with the highest HP."}},
	{"name": "Order Pupil", "icon": 21, "stars": 2, "kind": "Channeler", "cost": 2, "atk": 3, "hp": 2, "move": 1, "range": 3, "text": "Blast — Adjacent enemies take half ATK damage.", "skill": {"name": "Heaven's Wrath", "type": "Warcry", "text": "Deal 1 damage split between random enemy units."}},
	{"name": "Order Cleric", "icon": 23, "stars": 2, "kind": "Lifebinder", "cost": 3, "atk": 2, "hp": 4, "move": 1, "range": 2, "text": "Heal — Before moving, gives 2 HP to the lowest-health ally.", "skill": {"name": "Empower", "type": "Warcry", "text": "Another allied unit gains +1 ATK for 2 turns."}},
	{"name": "Order Apostle", "icon": 25, "stars": 2, "kind": "Strider", "cost": 2, "atk": 2, "hp": 4, "move": 3, "range": 1, "text": "Double Strike — Attacks twice each action.", "skill": {"name": "Heaven's Wrath", "type": "Warcry", "text": "Deal 1 damage split between random enemy units."}},
	{"name": "Trinity Messenger", "icon": 26, "stars": 2, "kind": "Channeler", "cost": 3, "atk": 4, "hp": 2, "move": 1, "range": 3, "text": "Blast — Adjacent enemies take half ATK damage.", "skill": {"name": "Bolt", "type": "Warcry", "text": "Deal 1 damage to the enemy unit with the highest HP."}},
	{"name": "Minerva the Brave", "icon": 27, "stars": 3, "kind": "Lifebinder", "cost": 2, "atk": 3, "hp": 4, "move": 1, "range": 2, "text": "Heal — Before moving, gives 2 HP to the lowest-health ally.", "skill": {"name": "Fortify", "type": "Warcry", "text": "Other allied unit with the lowest HP gains +3 HP for 2 turns."}},
	{"name": "Naruku the Lookout", "icon": 28, "stars": 4, "kind": "Channeler", "cost": 3, "atk": 3, "hp": 6, "move": 1, "range": 3, "text": "Blast — Adjacent enemies take half ATK damage.", "skill": {"name": "Empower", "type": "Warcry", "text": "Another allied unit gains +1 ATK for 2 turns."}},
	{"name": "Whirling Ragnr", "icon": 29, "stars": 4, "kind": "Duelist", "cost": 2, "atk": 3, "hp": 5, "move": 2, "range": 1, "text": "Fury — Permanently gains +1 ATK after attacking.", "skill": {"name": "Bolt", "type": "Warcry", "text": "Deal 1 damage to the enemy unit with the highest HP."}},
	{"name": "Master Builder", "icon": 14, "stars": 3, "kind": "Warden", "cost": 3, "atk": 3, "hp": 6, "move": 2, "range": 1, "text": "Taunting Strike — Target cannot change lanes for 2 turns.", "promotion_of": "Apprentice Builder", "skill": {"name": "Fortify", "type": "Warcry", "text": "Other allied unit with the lowest HP gains +3 HP for 2 turns."}},
	{"name": "Rage Bruiser", "icon": 16, "stars": 3, "kind": "Duelist", "cost": 2, "atk": 3, "hp": 6, "move": 2, "range": 1, "text": "Fury — Permanently gains +1 ATK after attacking.", "promotion_of": "Rage Brute", "skill": {"name": "Empower", "type": "Warcry", "text": "Another allied unit gains +1 ATK for 2 turns."}},
	{"name": "Claw Ambusher", "icon": 18, "stars": 3, "kind": "Strider", "cost": 3, "atk": 3, "hp": 4, "move": 3, "range": 1, "text": "Double Strike — Attacks twice each action.", "promotion_of": "Claw Skirmisher", "skill": {"name": "Pinning Strike", "type": "Strike", "text": "30% chance to Immobilise the attacked enemy for 1 turn."}},
	{"name": "LDF Sureshot", "icon": 20, "stars": 3, "kind": "Artillerist", "cost": 2, "atk": 4, "hp": 4, "move": 1, "range": 3, "text": "Piercing Shot — Damages every enemy in range in its lane.", "promotion_of": "LDF Gunner", "skill": {"name": "Bolt", "type": "Warcry", "text": "Deal 1 damage to the enemy unit with the highest HP."}},
	{"name": "Order Scholar", "icon": 22, "stars": 3, "kind": "Channeler", "cost": 2, "atk": 4, "hp": 4, "move": 1, "range": 3, "text": "Blast — Adjacent enemies take half ATK damage.", "promotion_of": "Order Pupil", "skill": {"name": "Heaven's Wrath", "type": "Warcry", "text": "Deal 1 damage split between random enemy units."}},
	{"name": "Order Chaplain", "icon": 24, "stars": 3, "kind": "Lifebinder", "cost": 3, "atk": 3, "hp": 5, "move": 1, "range": 2, "text": "Heal — Before moving, gives 2 HP to the lowest-health ally.", "promotion_of": "Order Cleric", "skill": {"name": "Empower", "type": "Warcry", "text": "Another allied unit gains +1 ATK for 2 turns."}},
	{"name": "Order Missionary", "icon": 31, "stars": 3, "kind": "Strider", "cost": 2, "atk": 2, "hp": 5, "move": 3, "range": 1, "text": "Double Strike — Attacks twice each action.", "promotion_of": "Order Apostle", "skill": {"name": "Heaven's Wrath", "type": "Warcry", "text": "Deal 1 damage split between random enemy units."}},
	{"name": "Trinity Herald", "icon": 32, "stars": 3, "kind": "Channeler", "cost": 3, "atk": 5, "hp": 4, "move": 1, "range": 3, "text": "Blast — Adjacent enemies take half ATK damage.", "promotion_of": "Trinity Messenger", "skill": {"name": "Bolt", "type": "Warcry", "text": "Deal 1 damage to the enemy unit with the highest HP."}},
	{"name": "Minerva the Lionheart", "icon": 33, "stars": 4, "kind": "Lifebinder", "cost": 2, "atk": 4, "hp": 5, "move": 1, "range": 2, "text": "Heal — Before moving, gives 2 HP to the lowest-health ally.", "promotion_of": "Minerva the Brave", "skill": {"name": "Fortify", "type": "Warcry", "text": "Other allied unit with the lowest HP gains +3 HP for 2 turns."}},
	{"name": "Farsight Naruku", "icon": 34, "stars": 5, "kind": "Channeler", "cost": 3, "atk": 4, "hp": 6, "move": 1, "range": 3, "text": "Blast — Adjacent enemies take half ATK damage.", "promotion_of": "Naruku the Lookout", "skill": {"name": "Empower", "type": "Warcry", "text": "Another allied unit gains +1 ATK for 2 turns."}},
	{"name": "Macewielder Ragnr", "icon": 35, "stars": 5, "kind": "Duelist", "cost": 2, "atk": 3, "hp": 6, "move": 2, "range": 1, "text": "Fury — Permanently gains +1 ATK after attacking.", "promotion_of": "Whirling Ragnr", "skill": {"name": "Bolt", "type": "Warcry", "text": "Deal 1 damage to the enemy unit with the highest HP."}},
	{"name": "Talon Scratcher", "icon": 37, "stars": 3, "kind": "Strider", "cost": 4, "atk": 2, "hp": 4, "move": 3, "range": 1, "text": "Double Strike — Attacks twice each action.", "skill": {"name": "Pinning Slice", "type": "Strike", "text": "60% chance to Immobilise the attacked enemy for 1 turn."}},
	{"name": "Talon Slasher", "icon": 38, "stars": 4, "kind": "Strider", "cost": 4, "atk": 3, "hp": 5, "move": 3, "range": 1, "text": "Double Strike — Attacks twice each action.", "promotion_of": "Talon Scratcher", "skill": {"name": "Pinning Slice", "type": "Strike", "text": "60% chance to Immobilise the attacked enemy for 1 turn."}},
	{"name": "Innocent Gretel", "icon": 39, "stars": 4, "kind": "Artillerist", "cost": 3, "atk": 3, "hp": 6, "move": 1, "range": 3, "text": "Piercing Shot — Damages every enemy in range in its lane.", "skill": {"name": "Pinning Slice", "type": "Strike", "text": "60% chance to Immobilise the attacked enemy for 1 turn."}},
	{"name": "Witchkiller Gretel", "icon": 40, "stars": 5, "kind": "Artillerist", "cost": 3, "atk": 3, "hp": 7, "move": 1, "range": 3, "text": "Piercing Shot — Damages every enemy in range in its lane.", "promotion_of": "Innocent Gretel", "skill": {"name": "Pinning Slice", "type": "Strike", "text": "60% chance to Immobilise the attacked enemy for 1 turn."}},
	{"name": "Talon Slicer", "icon": 41, "stars": 5, "kind": "Strider", "cost": 3, "atk": 3, "hp": 6, "move": 3, "range": 1, "text": "Double Strike — Attacks twice each action.", "promotion_of": "Talon Slasher", "skill": {"name": "Pinning Slice", "type": "Strike", "text": "60% chance to Immobilise the attacked enemy for 1 turn."}},
	{"name": "Street Urchin", "icon": 43, "stars": 2, "kind": "Strider", "cost": 3, "atk": 2, "hp": 2, "move": 3, "range": 1, "text": "Double Strike — Attacks twice each action.", "skill": {"name": "Misfortune", "type": "Warcry", "text": "Enemy Scout or Gunner with the highest ATK loses 1 ATK for 2 turns."}},
	{"name": "Street Hoodlum", "icon": 44, "stars": 3, "kind": "Strider", "cost": 3, "atk": 3, "hp": 3, "move": 3, "range": 1, "text": "Double Strike — Attacks twice each action.", "promotion_of": "Street Urchin", "skill": {"name": "Misfortune", "type": "Warcry", "text": "Enemy Scout or Gunner with the highest ATK loses 1 ATK for 2 turns."}},
	{"name": "LDF Crowd Mage", "icon": 45, "stars": 2, "kind": "Channeler", "cost": 2, "atk": 2, "hp": 4, "move": 1, "range": 3, "text": "Blast — Adjacent enemies take half ATK damage.", "skill": {"name": "Misfortune", "type": "Warcry", "text": "Enemy Scout or Gunner with the highest ATK loses 1 ATK for 2 turns."}},
	{"name": "LDF Riot Mage", "icon": 46, "stars": 3, "kind": "Channeler", "cost": 2, "atk": 3, "hp": 6, "move": 1, "range": 3, "text": "Blast — Adjacent enemies take half ATK damage.", "promotion_of": "LDF Crowd Mage", "skill": {"name": "Misfortune", "type": "Warcry", "text": "Enemy Scout or Gunner with the highest ATK loses 1 ATK for 2 turns."}},
	{"name": "Fortune Teller", "icon": 55, "stars": 3, "kind": "Channeler", "cost": 2, "atk": 2, "hp": 5, "move": 1, "range": 3, "text": "Blast — Adjacent enemies take half ATK damage.", "skill": {"name": "Misfortune", "type": "Warcry", "text": "Enemy Scout or Gunner with the highest ATK loses 1 ATK for 2 turns."}},
	{"name": "Fortune Diviner", "icon": 56, "stars": 4, "kind": "Channeler", "cost": 2, "atk": 3, "hp": 7, "move": 1, "range": 3, "text": "Blast — Adjacent enemies take half ATK damage.", "promotion_of": "Fortune Teller", "skill": {"name": "Misfortune", "type": "Warcry", "text": "Enemy Scout or Gunner with the highest ATK loses 1 ATK for 2 turns."}},
	{"name": "Street Nurse", "icon": 49, "stars": 2, "kind": "Lifebinder", "cost": 3, "atk": 2, "hp": 3, "move": 1, "range": 2, "text": "Heal — Before moving, gives 2 HP to the lowest-health ally.", "skill": {"name": "Mend", "type": "Warcry", "text": "Restore 3 HP to the allied unit with the lowest HP."}},
	{"name": "Street Matron", "icon": 50, "stars": 3, "kind": "Lifebinder", "cost": 3, "atk": 3, "hp": 4, "move": 1, "range": 2, "text": "Heal — Before moving, gives 2 HP to the lowest-health ally.", "promotion_of": "Street Nurse", "skill": {"name": "Mend", "type": "Warcry", "text": "Restore 3 HP to the allied unit with the lowest HP."}},
	{"name": "Blight Doctor", "icon": 51, "stars": 3, "kind": "Lifebinder", "cost": 3, "atk": 2, "hp": 6, "move": 1, "range": 2, "text": "Heal — Before moving, gives 2 HP to the lowest-health ally.", "skill": {"name": "Plague", "type": "Warcry", "text": "Deal 1 damage to every other unit and Poison them for 2 turns."}},
	{"name": "Blight Physician", "icon": 52, "stars": 4, "kind": "Lifebinder", "cost": 3, "atk": 3, "hp": 7, "move": 1, "range": 2, "text": "Heal — Before moving, gives 2 HP to the lowest-health ally.", "promotion_of": "Blight Doctor", "skill": {"name": "Plague", "type": "Warcry", "text": "Deal 1 damage to every other unit and Poison them for 2 turns."}},
	{"name": "Captain Kerryson", "icon": 53, "stars": 3, "kind": "Warden", "cost": 2, "atk": 3, "hp": 6, "move": 2, "range": 1, "text": "Taunting Strike — Target cannot change lanes for 2 turns.", "skill": {"name": "Mend", "type": "Warcry", "text": "Restore 3 HP to the allied unit with the lowest HP."}},
	{"name": "Kerryson the Stoic", "icon": 54, "stars": 4, "kind": "Warden", "cost": 2, "atk": 4, "hp": 8, "move": 2, "range": 1, "text": "Taunting Strike — Target cannot change lanes for 2 turns.", "promotion_of": "Captain Kerryson", "skill": {"name": "Mend", "type": "Warcry", "text": "Restore 3 HP to the allied unit with the lowest HP."}},
	{"name": "Dart Shooter", "icon": 57, "stars": 3, "kind": "Artillerist", "cost": 3, "atk": 4, "hp": 3, "move": 1, "range": 3, "text": "Piercing Shot — Damages every enemy in range in its lane.", "skill": {"name": "Envenom", "type": "Warcry", "text": "Poison a selected enemy unit for 2 turns."}},
	{"name": "Dart Sharpshooter", "icon": 58, "stars": 4, "kind": "Artillerist", "cost": 3, "atk": 5, "hp": 5, "move": 1, "range": 3, "text": "Piercing Shot — Damages every enemy in range in its lane.", "promotion_of": "Dart Shooter", "skill": {"name": "Envenom", "type": "Warcry", "text": "Poison a selected enemy unit for 2 turns."}},
	{"name": "Frog-Hopper Keru", "icon": 59, "stars": 4, "kind": "Channeler", "cost": 2, "atk": 3, "hp": 7, "move": 1, "range": 3, "text": "Blast — Adjacent enemies take half ATK damage.", "skill": {"name": "Envenom", "type": "Warcry", "text": "Poison a selected enemy unit for 2 turns."}},
	{"name": "Lizard-Licker Keru", "icon": 60, "stars": 5, "kind": "Channeler", "cost": 2, "atk": 4, "hp": 8, "move": 1, "range": 3, "text": "Blast — Adjacent enemies take half ATK damage.", "promotion_of": "Frog-Hopper Keru", "skill": {"name": "Envenom", "type": "Warcry", "text": "Poison a selected enemy unit for 2 turns."}},
	{"name": "Blightshot", "icon": 61, "stars": 4, "kind": "Artillerist", "cost": 2, "atk": 2, "hp": 6, "move": 1, "range": 3, "text": "Piercing Shot — Damages every enemy in range in its lane.", "skill": {"name": "Envenom", "type": "Warcry", "text": "Poison a selected enemy unit for 2 turns."}},
	{"name": "Toxic Shot", "icon": 62, "stars": 5, "kind": "Artillerist", "cost": 2, "atk": 3, "hp": 8, "move": 1, "range": 3, "text": "Piercing Shot — Damages every enemy in range in its lane.", "promotion_of": "Blightshot", "skill": {"name": "Envenom", "type": "Warcry", "text": "Poison a selected enemy unit for 2 turns."}},
	{"name": "Garrett Talon", "icon": 63, "stars": 3, "kind": "Artillerist", "cost": 3, "atk": 3, "hp": 6, "move": 1, "range": 3, "text": "Piercing Shot — Damages every enemy in range in its lane.", "skill": {"name": "Pin Down", "type": "Warcry", "text": "Deal 1 damage to the highest-ATK enemy Defender, Fighter, or Scout and Immobilise it for 1 turn."}},
	{"name": "Garrett the Claw", "icon": 64, "stars": 4, "kind": "Artillerist", "cost": 3, "atk": 4, "hp": 7, "move": 1, "range": 3, "text": "Piercing Shot — Damages every enemy in range in its lane.", "promotion_of": "Garrett Talon", "skill": {"name": "Pin Down", "type": "Warcry", "text": "Deal 1 damage to the highest-ATK enemy Defender, Fighter, or Scout and Immobilise it for 1 turn."}},
	{"name": "Garrett the Raider", "icon": 65, "stars": 5, "kind": "Artillerist", "cost": 2, "atk": 5, "hp": 7, "move": 1, "range": 3, "text": "Piercing Shot — Damages every enemy in range in its lane.", "promotion_of": "Garrett the Claw", "skill": {"name": "Pin Down", "type": "Warcry", "text": "Deal 1 damage to the highest-ATK enemy Defender, Fighter, or Scout and Immobilise it for 1 turn."}},
	{"name": "Precision Shooter", "icon": 66, "stars": 3, "kind": "Artillerist", "cost": 3, "atk": 3, "hp": 5, "move": 1, "range": 3, "text": "Piercing Shot — Damages every enemy in range in its lane.", "skill": {"name": "Pin Down", "type": "Warcry", "text": "Deal 1 damage to the highest-ATK enemy Defender, Fighter, or Scout and Immobilise it for 1 turn."}},
	{"name": "Precision Sniper", "icon": 67, "stars": 4, "kind": "Artillerist", "cost": 3, "atk": 4, "hp": 7, "move": 1, "range": 3, "text": "Piercing Shot — Damages every enemy in range in its lane.", "promotion_of": "Precision Shooter", "skill": {"name": "Pin Down", "type": "Warcry", "text": "Deal 1 damage to the highest-ATK enemy Defender, Fighter, or Scout and Immobilise it for 1 turn."}},
	{"name": "Precision Trigger", "icon": 68, "stars": 5, "kind": "Artillerist", "cost": 2, "atk": 4, "hp": 8, "move": 1, "range": 3, "text": "Piercing Shot — Damages every enemy in range in its lane.", "promotion_of": "Precision Sniper", "skill": {"name": "Pin Down", "type": "Warcry", "text": "Deal 1 damage to the highest-ATK enemy Defender, Fighter, or Scout and Immobilise it for 1 turn."}},
	{"name": "Greyson the Shifty", "icon": 69, "stars": 3, "kind": "Strider", "cost": 4, "atk": 2, "hp": 6, "move": 3, "range": 1, "text": "Double Strike — Attacks twice each action.", "skill": {"name": "Demoralize", "type": "Warcry", "text": "Enemy Fighters, Scouts, and Defenders in a selected lane lose 1 ATK for 2 turns."}},
	{"name": "Greyson the Shrewd", "icon": 70, "stars": 4, "kind": "Strider", "cost": 4, "atk": 4, "hp": 6, "move": 3, "range": 1, "text": "Double Strike — Attacks twice each action.", "promotion_of": "Greyson the Shifty", "skill": {"name": "Demoralize", "type": "Warcry", "text": "Enemy Fighters, Scouts, and Defenders in a selected lane lose 1 ATK for 2 turns."}},
	{"name": "Communicator Ripley", "icon": 71, "stars": 4, "kind": "Lifebinder", "cost": 2, "atk": 3, "hp": 4, "move": 1, "range": 2, "text": "Heal — Before moving, gives 2 HP to the lowest-health ally.", "skill": {"name": "Demoralize", "type": "Warcry", "text": "Enemy Fighters, Scouts, and Defenders in a selected lane lose 1 ATK for 2 turns."}},
	{"name": "The Telecommunicator", "icon": 72, "stars": 5, "kind": "Lifebinder", "cost": 2, "atk": 4, "hp": 5, "move": 1, "range": 2, "text": "Heal — Before moving, gives 2 HP to the lowest-health ally.", "promotion_of": "Communicator Ripley", "skill": {"name": "Demoralize", "type": "Warcry", "text": "Enemy Fighters, Scouts, and Defenders in a selected lane lose 1 ATK for 2 turns."}},
	{"name": "Vicious Pierrot", "icon": 73, "stars": 4, "kind": "Duelist", "cost": 3, "atk": 5, "hp": 7, "move": 2, "range": 1, "text": "Fury — Permanently gains +1 ATK after attacking.", "skill": {"name": "Demoralize", "type": "Warcry", "text": "Enemy Fighters, Scouts, and Defenders in a selected lane lose 1 ATK for 2 turns."}},
	{"name": "Pierrot the Deciever", "icon": 74, "stars": 5, "kind": "Duelist", "cost": 3, "atk": 7, "hp": 9, "move": 2, "range": 1, "text": "Fury — Permanently gains +1 ATK after attacking.", "promotion_of": "Vicious Pierrot", "skill": {"name": "Demoralize", "type": "Warcry", "text": "Enemy Fighters, Scouts, and Defenders in a selected lane lose 1 ATK for 2 turns."}},
	{"name": "LDF Flight Officer", "icon": 75, "stars": 2, "kind": "Duelist", "cost": 2, "atk": 4, "hp": 4, "move": 2, "range": 1, "text": "Fury — Permanently gains +1 ATK after attacking.", "skill": {"name": "Punish", "type": "Warcry", "text": "The highest-ATK enemy Fighter or Mage loses 1 ATK for 2 turns."}},
	{"name": "LDF Flight Commander", "icon": 76, "stars": 3, "kind": "Duelist", "cost": 2, "atk": 5, "hp": 4, "move": 2, "range": 1, "text": "Fury — Permanently gains +1 ATK after attacking.", "promotion_of": "LDF Flight Officer", "skill": {"name": "Punish", "type": "Warcry", "text": "The highest-ATK enemy Fighter or Mage loses 1 ATK for 2 turns."}},
	{"name": "Prison Warden", "icon": 77, "stars": 3, "kind": "Strider", "cost": 4, "atk": 3, "hp": 5, "move": 3, "range": 1, "text": "Double Strike — Attacks twice each action.", "skill": {"name": "Punish", "type": "Warcry", "text": "The highest-ATK enemy Fighter or Mage loses 1 ATK for 2 turns."}},
	{"name": "Prison Guv'nor", "icon": 78, "stars": 4, "kind": "Strider", "cost": 4, "atk": 4, "hp": 6, "move": 3, "range": 1, "text": "Double Strike — Attacks twice each action.", "promotion_of": "Prison Warden", "skill": {"name": "Punish", "type": "Warcry", "text": "The highest-ATK enemy Fighter or Mage loses 1 ATK for 2 turns."}},
	{"name": "Shakespeare", "icon": 79, "stars": 4, "kind": "Strider", "cost": 2, "atk": 2, "hp": 4, "move": 3, "range": 1, "text": "Double Strike — Attacks twice each action.", "skill": {"name": "Punish", "type": "Warcry", "text": "The highest-ATK enemy Fighter or Mage loses 1 ATK for 2 turns."}},
	{"name": "The Bard", "icon": 80, "stars": 5, "kind": "Strider", "cost": 2, "atk": 2, "hp": 5, "move": 3, "range": 1, "text": "Double Strike — Attacks twice each action.", "promotion_of": "Shakespeare", "skill": {"name": "Punish", "type": "Warcry", "text": "The highest-ATK enemy Fighter or Mage loses 1 ATK for 2 turns."}}
]

static func all_units() -> Array:
	var result: Array = []
	for unit in UNITS:
		result.append(unit.duplicate(true))
	return result

static func by_name(unit_name: String) -> Dictionary:
	for unit in UNITS:
		if unit.name == unit_name:
			return unit.duplicate(true)
	return {}

static func display_class(kind: String) -> String:
	return CLASS_NAMES.get(kind, kind)

static func class_color(kind: String) -> Color:
	return CLASS_COLORS.get(kind, Color("#91a7ce"))

static func art_id(icon_id: int) -> int:
	return ICON_ART_IDS.get(icon_id, icon_id)
