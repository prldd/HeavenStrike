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

# Political faction assignments mirror
# documentation/Unit_Faction_and_Sprite_Staging.md. Icons not listed here are
# Universal: neutral units that can appear in any faction's squad.
const FACTION_ICON_IDS := {
	"Coal": [119, 120, 166, 167, 15, 16, 17, 18, 69, 70, 63, 64, 65, 66, 67, 68, 170, 171, 176, 177, 182, 183, 190, 191, 90, 91, 115, 116, 198, 199, 148, 149, 213, 214, 215],
	"Steam": [96, 97, 104, 105, 106, 111, 112, 136, 137, 138, 139, 186, 187, 200, 201, 117, 118, 43, 44, 77, 78, 83, 84, 98, 99, 28, 34, 158, 159, 51, 52, 180, 181, 196, 197],
	"Wind": [113, 114, 152, 153, 75, 76, 37, 38, 41, 109, 110, 144, 145, 178, 179, 202, 203, 204, 205, 39, 40, 88, 89, 59, 60, 150, 151, 168, 169, 23, 24, 71, 72, 208, 209],
	"Fusion": [53, 54, 154, 155, 73, 74, 25, 31, 79, 80, 19, 20, 140, 141, 45, 46, 92, 93, 107, 108, 188, 189, 192, 193, 206, 207, 210, 211, 212, 27, 33, 184, 185, 194, 195],
	"Solar": [128, 129, 134, 135, 172, 173, 81, 82, 130, 131, 57, 58, 61, 62, 26, 32, 55, 56, 49, 50, 102, 103, 123, 124, 125, 126, 127, 132, 133, 142, 143, 160, 161, 162, 163]
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
	53: 85, # Conductor Kerryson
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
	80: 488, # The Bard
	88: 31, # Haven Trapper
	89: 32, # Haven Huntsman
	90: 93, # Macabre Embalmer
	91: 94, # Macabre Undertaker
	92: 81, # Devout Mage
	93: 82, # Devout Warlock
	94: 195, # Bartok Loco
	95: 196, # Derailed Bartok
	96: 289, # Geartron Prototype
	97: 290, # Geartron-5000
	98: 787, # Bethany
	99: 788, # Bunnybot Bethany
	100: 887, # Final Empress
	101: 888, # Awoken Final Empress
	102: 1191, # Opelle
	103: 1192, # Glowing Opelle
	104: 73, # Commune Defender
	105: 74, # Commune Conductor
	106: 607, # Commune Commander
	107: 141, # Frost-Kid Kokori
	108: 142, # Ice-Prince Kokori
	109: 149, # Mata Swiftblade
	110: 150, # Swiftblade Heroine
	111: 37, # LDF Constable
	112: 38, # LDF Sergeant
	113: 97, # Joe Wonder
	114: 98, # Pompous Joe Wonder
	115: 105, # Raging Dragon
	116: 106, # Blazing Dragon
	117: 87, # Royal Yeoman
	118: 88, # Royal Beefeater
	119: 61, # Pub Barman
	120: 62, # Pub Landlord
	121: 521, # The Archaeologist
	122: 522, # The Castaway
	123: 71, # The Botanist
	124: 72, # The Ecologist
	125: 605, # The Biologist
	126: 95, # Rescue Corps
	127: 96, # Rescue Paramedic
	128: 715, # Fabulous Bors
	129: 716, # Sir Bors
	130: 137, # Selina the Stylist
	131: 138, # Selina Twinblade
	132: 203, # The Witch Doctor
	133: 204, # The Earth Whisperer
	134: 231, # Hamish Highlander
	135: 232, # Hamish Lochmaster
	136: 241, # The Rook
	137: 242, # Sterling Knight
	138: 253, # Deep Sea Barney
	139: 254, # Bulkhead Barney
	140: 259, # Crewman Basilic
	141: 260, # Conductor Basilic
	142: 275, # Oro the Pilgrim
	143: 276, # Oro the Enlightened
	144: 363, # Cara Pace
	145: 364, # Clawing Cara
	146: 429, # Clair
	147: 430, # Awoken Clair
	148: 435, # White Mage
	149: 436, # White Wizard
	150: 462, # Steph Lopod
	151: 463, # Steph the Tentacled
	152: 643, # Ant Lantis
	153: 644, # Swelling Ant
	154: 651, # Ki
	155: 652, # Hammering Ki
	156: 707, # Gawain the Just
	157: 708, # Sir Gawain
	158: 791, # Sakura
	159: 792, # Blossom Sakura
	160: 825, # Inti Chihuan
	161: 826, # Shining Inti
	162: 865, # Van Hohenheim
	163: 866, # The Sorcerer's Stone
	164: 1199, # José
	165: 1200, # José Decomposé
	166: 947, # Furia Rojo
	167: 948, # Campeon Rojo
	168: 1025, # Sakuya (Fantail Pigeon)
	169: 1026, # Sakuya Le Bel Shirogane
	170: 1027, # Yuuya (Fantail Pigeon)
	171: 1028, # Yuuya Sakazaki
	172: 325, # Three of Hearts
	173: 326, # Ace of Hearts
	174: 979, # Philippa Trot
	175: 980, # Galloping Philippa
	176: 127, # The Aquanaut
	177: 128, # The Hydronaut
	178: 597, # Thief
	179: 598, # Cutpurse
	180: 965, # Present Verdandi
	181: 966, # Verdandi Norn
	182: 295, # Frontier Rider
	183: 296, # Frontier Protector
	184: 215, # Lunnain Oracle
	185: 216, # Lunnain Divine
	186: 1011, # Ra
	187: 1012, # Ra, Creator
	188: 697, # Rydia of Mist
	189: 698, # Summoner Rydia
	190: 1123, # Booth
	191: 1124, # Booth Kavar
	192: 747, # Medusa
	193: 748, # Gorgon Medusa
	194: 1019, # Nageki (Mourning Dove)
	195: 1020, # Nageki Fujishiro
	196: 263, # Jimimi the Shepherd
	197: 264, # Jimimi the Herder
	198: 321, # Hookie
	199: 322, # Beautifly Hookie
	200: 567, # Winter Harding
	201: 568, # Happy Elf Harding
	202: 693, # Edge
	203: 694, # Ninja Edge
	204: 1053, # Explorer Gatling
	205: 1054, # Raider Gatling
	206: 1153, # Belladonna
	207: 1154, # The Twilight Queen
	208: 35, # Claw Minstrel
	209: 36, # Claw Rocker
	210: 69, # Conjuring Clown
	211: 70, # Conjuring Harlequin
	212: 603, # Conjuring Jester
	213: 107, # Flame Warden
	214: 108, # Flame Dissident
	215: 633 # Flame Schematic
}

## Non-human races from the unit reference (chainguardians.com), keyed by
## project icon. Units missing from this table are human; `_unit` applies the
## default. The four races are human, ogur, lambkin, and felyne.
const UNIT_RACES := {
	9: "felyne", # Claw Slicer
	2: "ogur", # Pub Bouncer
	11: "lambkin", # Rage Spellslinger
	6: "lambkin", # Chain Initiate
	13: "ogur", # Apprentice Builder
	15: "ogur", # Rage Brute
	21: "lambkin", # Order Pupil
	25: "felyne", # Order Apostle
	26: "lambkin", # Trinity Messenger
	28: "lambkin", # Naruku the Lookout
	29: "ogur", # Whirling Ragnr
	14: "ogur", # Master Builder
	16: "ogur", # Rage Bruiser
	22: "lambkin", # Order Scholar
	31: "felyne", # Order Missionary
	32: "lambkin", # Trinity Herald
	34: "lambkin", # Farsight Naruku
	35: "ogur", # Macewielder Ragnr
	37: "felyne", # Talon Scratcher
	38: "felyne", # Talon Slasher
	41: "felyne", # Talon Slicer
	57: "felyne", # Dart Shooter
	58: "felyne", # Dart Sharpshooter
	59: "lambkin", # Frog-Hopper Keru
	60: "lambkin", # Lizard-Licker Keru
	66: "felyne", # Precision Shooter
	67: "felyne", # Precision Sniper
	68: "felyne", # Precision Trigger
	77: "felyne", # Prison Warden
	78: "felyne", # Prison Guv'nor
	83: "felyne", # LDF Bowgunner
	84: "felyne", # LDF Bolt Slinger
	94: "ogur", # Bartok Loco
	95: "ogur", # Derailed Bartok
	96: "lambkin", # Geartron Prototype
	97: "lambkin", # Geartron-5000
	102: "lambkin", # Opelle
	103: "lambkin", # Glowing Opelle
	104: "ogur", # Commune Defender
	105: "ogur", # Commune Conductor
	106: "ogur", # Commune Commander
	107: "lambkin", # Frost-Kid Kokori
	108: "lambkin", # Ice-Prince Kokori
	119: "ogur", # Pub Barman
	120: "ogur", # Pub Landlord
	121: "ogur", # The Archaeologist
	122: "ogur", # The Castaway
	123: "lambkin", # The Botanist
	124: "lambkin", # The Ecologist
	125: "lambkin", # The Biologist
	128: "ogur", # Fabulous Bors
	129: "ogur", # Sir Bors
	132: "lambkin", # The Witch Doctor
	133: "lambkin", # The Earth Whisperer
	134: "ogur", # Hamish Highlander
	135: "ogur", # Hamish Lochmaster
	142: "lambkin", # Oro the Pilgrim
	143: "lambkin", # Oro the Enlightened
	144: "felyne", # Cara Pace
	145: "felyne", # Clawing Cara
	148: "felyne", # White Mage
	149: "felyne", # White Wizard
	150: "felyne", # Steph Lopod
	151: "felyne", # Steph the Tentacled
	152: "ogur", # Ant Lantis
	153: "ogur", # Swelling Ant
	154: "ogur", # Ki
	155: "ogur", # Hammering Ki
	156: "ogur", # Gawain the Just
	157: "ogur", # Sir Gawain
	158: "lambkin", # Sakura
	160: "lambkin", # Inti Chihuan
	161: "lambkin", # Shining Inti
	166: "ogur", # Furia Rojo
	167: "ogur", # Campeon Rojo
	172: "ogur", # Three of Hearts
	173: "ogur", # Ace of Hearts
	178: "felyne", # Thief
	179: "felyne", # Cutpurse
	182: "lambkin", # Frontier Rider
	183: "lambkin", # Frontier Protector
	196: "lambkin", # Jimimi the Shepherd
	197: "lambkin", # Jimimi the Herder
	198: "lambkin", # Hookie
	199: "lambkin", # Beautifly Hookie
	204: "felyne", # Explorer Gatling
	205: "felyne", # Raider Gatling
	206: "felyne", # Belladonna
	207: "felyne", # The Twilight Queen
	208: "lambkin", # Claw Minstrel
	209: "lambkin", # Claw Rocker
	210: "lambkin", # Conjuring Clown
	211: "lambkin", # Conjuring Harlequin
	212: "lambkin", # Conjuring Jester
	213: "lambkin", # Flame Warden
	214: "lambkin", # Flame Dissident
	215: "lambkin" # Flame Schematic
}

static var _units: Array[UnitData] = []

# Preserve existing collections and squads created before the leader-title
# terminology was standardized. Split legacy spellings keep obsolete copy out
# of searchable project text while still allowing old save values to migrate.
const LEGACY_NAME_ALIASES := {
	"Cap" + "tain Kerryson": "Conductor Kerryson",
	"Commune Cap" + "tain": "Commune Conductor",
	"Cap" + "tain Basilic": "Conductor Basilic"
}

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
	"Poison Strike": [["50% chance", "2 turns"], ["60% chance", "2 turns"], ["70% chance", "2 turns"], ["80% chance", "3 turns"], ["90% chance", "3 turns"]],
	"Big Game Hunter": [["1 damage", "2 turns"], ["2 damage", "2 turns"], ["2 damage", "3 turns"], ["3 damage", "3 turns"], ["3 damage", "4 turns"]],
	"Contagion": [["1 damage", "2 turns"], ["2 damage", "2 turns"], ["2 damage", "3 turns"], ["2 damage", "4 turns"], ["3 damage", "4 turns"]],
	"Meteor Barrage": [["2 damage"], ["2 damage"], ["3 damage"], ["3 damage"], ["4 damage"]],
	"Sundering Smash": [["1 damage", "2 turns"], ["2 damage", "2 turns"], ["2 damage", "3 turns"], ["3 damage", "3 turns"], ["3 damage", "4 turns"]],
	"Hopping Mad": [["3 damage"], ["5 damage"], ["6 damage"], ["7 damage"], ["9 damage"]],
	"Moonlight": [["4 HP"], ["5 HP"], ["6 HP"], ["7 HP"], ["8 HP"]],
	"Shield Wall": [["40% chance", "2 turns"], ["42% chance", "2 turns"], ["45% chance", "2 turns"], ["47% chance", "3 turns"], ["50% chance", "3 turns"]],
	"Freeze!": [["1 damage", "1 turn"], ["2 damage", "1 turn"], ["3 damage", "1 turn"], ["3 damage", "2 turns"], ["4 damage", "2 turns"]],
	"Weakening Strike": [["60% chance", "1 ATK", "2 turns"], ["70% chance", "2 ATK", "2 turns"], ["80% chance", "3 ATK", "2 turns"], ["90% chance", "3 ATK", "3 turns"], ["100% chance", "4 ATK", "3 turns"]],
	"Protect": [["2 turns"], ["3 turns"], ["4 turns"], ["5 turns"], ["6 turns"]],
	"Fireball": [["1 damage", "1 damage"], ["2 damage", "1 damage"], ["2 damage", "2 damage"], ["3 damage", "2 damage"], ["3 damage", "3 damage"]],
	"Warrior's Vigour": [["2 HP", "1 ATK", "2 turns"], ["2 HP", "1 ATK", "3 turns"], ["2 HP", "2 ATK", "3 turns"], ["2 HP", "2 ATK", "4 turns"], ["3 HP", "2 ATK", "4 turns"]],
	"Grit": [["40% chance", "2 turns"], ["42% chance", "2 turns"], ["45% chance", "2 turns"], ["47% chance", "3 turns"], ["50% chance", "3 turns"]],
	"Prune": [["2 turns"], ["3 turns"], ["4 turns"], ["5 turns"], ["6 turns"]],
	"Medic!": [["2 turns"], ["3 turns"], ["4 turns"], ["5 turns"], ["6 turns"]],
	"New Look": [["2 turns"], ["3 turns"], ["4 turns"], ["5 turns"], ["6 turns"]],
	"Lifestream": [["2 turns", "1 random"], ["3 turns", "2 random"], ["4 turns", "3 random"], ["5 turns", "3 random"], ["6 turns", "4 random"]],
	"Caber Toss": [["2", "30% chance"], ["2", "35% chance"], ["2", "40% chance"], ["3", "45% chance"], ["3", "50% chance"]],
	"Impairing Joust": [["1 turn", "30% chance", "3 turns"], ["1 turn", "35% chance", "3 turns"], ["2 turns", "40% chance", "3 turns"], ["2 turns", "45% chance", "3 turns"], ["2 turns", "50% chance", "3 turns"]],
	"Ambient Pressure": [["60% chance", "1 ATK"], ["70% chance", "1 ATK"], ["80% chance", "1 ATK"], ["90% chance", "2 ATK"], ["100% chance", "2 ATK"]],
	"Cannon Barrage": [["2 damage", "40% chance"], ["3 damage", "55% chance"], ["3 damage", "70% chance"], ["4 damage", "85% chance"], ["4 damage", "100% chance"]],
	"Guard": [["40% chance"], ["55% chance"], ["70% chance"], ["85% chance"], ["100% chance"]],
	"Pincer Drain": [["1 ATK", "30% chance"], ["2 ATK", "32% chance"], ["2 ATK", "35% chance"], ["3 ATK", "37% chance"], ["3 ATK", "40% chance"]],
	"Slash Speed": [["2", "1 random", "40% chance"], ["2", "2 random", "60% chance"], ["3", "2 random", "60% chance"], ["3", "2 random", "80% chance"], ["4", "2 random", "100% chance"]],
	"Mighty Guard": [["1"], ["2"], ["3"], ["4"], ["5"]],
	"Ocean's Reclaim": [["1 random", "2 turns"], ["1 random", "3 turns"], ["2 random", "4 turns"], ["2 random", "5 turns"], ["2 random", "6 turns"]],
	"Tide Turn": [["1 turns", "20% chance"], ["1 turns", "40% chance"], ["2 turns", "60% chance"], ["2 turns", "80% chance"], ["2 turns", "100% chance"]],
	"Yield!": [["2", "30% chance"], ["2", "35% chance"], ["3", "40% chance"], ["3", "45% chance"], ["4", "50% chance"]],
	"Galatine's Ground": [["1 turns", "30% chance"], ["1 turns", "35% chance"], ["2 turns", "40% chance"], ["2 turns", "45% chance"], ["2 turns", "50% chance"]],
	"Blossom's Bloom": [["1 ATK"], ["2 ATK"], ["3 ATK"], ["4 ATK"], ["5 ATK"]],
	"Sun Festival": [["2", "1 ATK", "2 HP"], ["3", "2 ATK", "3 HP"], ["4", "2 ATK", "4 HP"], ["4", "3 ATK", "4 HP"], ["4", "3 ATK", "5 HP"]],
	"Trisha's Prospect": [["2"], ["3"], ["4"], ["5"], ["6"]],
	"Tag-Team": [["20% chance"], ["40% chance"], ["60% chance"], ["80% chance"], ["100% chance"]],
	"Heartful Brother": [["1 ATK", "2", "2"], ["2 ATK", "2", "2"], ["2 ATK", "3", "3"], ["3 ATK", "3", "3"], ["3 ATK", "4", "4"]],
	"Hurtful Brother": [["1 HP", "2", "2"], ["1 HP", "3", "3"], ["2 HP", "3", "3"], ["2 HP", "4", "4"], ["3 HP", "4", "4"]],
	"Royal Flush": [["2 turns"], ["3 turns"], ["4 turns"], ["5 turns"], ["6 turns"]],
	"Hydroblast": [["1 ATK", "1"], ["2 ATK", "1"], ["2 ATK", "2"], ["3 ATK", "2"], ["3 ATK", "3"]],
	"Roguish Snare": [["20% chance"], ["40% chance"], ["60% chance"], ["80% chance"], ["100% chance"]],
	"Wrangle": [["1 turn", "1 ATK", "1 turn"], ["1 turn", "2 ATK", "1 turn"], ["2 turns", "2 ATK", "1 turn"], ["2 turns", "2 ATK", "2 turns"], ["2 turns", "3 ATK", "2 turns"]],
	"Cattle of Ra": [["1", "1 ATK"], ["2", "1 ATK"], ["2", "2 ATK"], ["3", "2 ATK"], ["3", "3 ATK"]],
	"Divine Silence": [["1"], ["2"], ["3"], ["4"], ["5"]],
	"Stone Gaze": [["1", "1"], ["1", "2"], ["2", "2"], ["3", "2"], ["3", "3"]],
	"Summon Forth": [["1", "50%", "1"], ["2", "50%", "2"], ["2", "100%", "2"], ["2", "100%", "3"], ["3", "100%", "3"]],
	"Quiet!": [["1", "1 random", "1"], ["1", "2 random", "2"], ["2", "2 random", "2"], ["3", "2 random", "2"], ["3", "3 random", "3"]],
	"Woolen Blanket": [["1 HP", "2 turns"], ["2 HP", "2 turns"], ["3 HP", "2 turns"], ["3 HP", "3 turns"], ["4 HP", "3 turns"]],
	"Shadowbind": [["1 ATK", "2 turns"], ["2 ATK", "2 turns"], ["3 ATK", "2 turns"], ["3 ATK", "3 turns"], ["4 ATK", "3 turns"]],
	"Inspire Lambkin": [["1 HP", "1 ATK"], ["2 HP", "1 ATK"], ["2 HP", "2 ATK"], ["3 HP", "2 ATK"], ["4 HP", "2 ATK"]]
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
	u.race = UNIT_RACES.get(icon, "human")
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
		_unit('Conductor Kerryson', 53, 3, 'Warden', 2, 3, 6, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', '', _skill('Mend', 'Warcry', -1.0, 'Restore {0} to the allied unit with the lowest HP.')),
		_unit('Kerryson the Stoic', 54, 4, 'Warden', 2, 4, 8, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', 'Conductor Kerryson', _skill('Mend', 'Warcry', -1.0, 'Restore {0} to the allied unit with the lowest HP.')),
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
		_unit('Haven Trapper', 88, 2, 'Artillerist', 3, 3, 5, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', '', _skill('Big Game Hunter', 'Warcry', -1.0, 'Enemy unit with the highest HP takes {0} and becomes Vulnerable for {1}.')),
		_unit('Haven Huntsman', 89, 3, 'Artillerist', 3, 4, 7, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', 'Haven Trapper', _skill('Big Game Hunter', 'Warcry', -1.0, 'Enemy unit with the highest HP takes {0} and becomes Vulnerable for {1}.')),
		_unit('Macabre Embalmer', 90, 3, 'Channeler', 3, 3, 5, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', '', _skill('Contagion', 'Warcry', -1.0, 'Deal {0} to all enemy Mages and Priests and Poison them for {1}.')),
		_unit('Macabre Undertaker', 91, 4, 'Channeler', 3, 4, 7, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', 'Macabre Embalmer', _skill('Contagion', 'Warcry', -1.0, 'Deal {0} to all enemy Mages and Priests and Poison them for {1}.')),
		_unit('Devout Mage', 92, 3, 'Channeler', 4, 5, 6, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', '', _skill('Meteor Barrage', 'Warcry', -1.0, 'Deal {0} to enemy units in target lane.')),
		_unit('Devout Warlock', 93, 4, 'Channeler', 4, 6, 8, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', 'Devout Mage', _skill('Meteor Barrage', 'Warcry', -1.0, 'Deal {0} to enemy units in target lane.')),
		_unit('Bartok Loco', 94, 4, 'Duelist', 4, 5, 8, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', '', _skill('Sundering Smash', 'Chant', -1.0, "At the start of your turn, deal {0} to all enemies in this unit's lane and make them Vulnerable for {1}.")),
		_unit('Derailed Bartok', 95, 5, 'Duelist', 4, 6, 9, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', 'Bartok Loco', _skill('Sundering Smash', 'Chant', -1.0, "At the start of your turn, deal {0} to all enemies in this unit's lane and make them Vulnerable for {1}.")),
		_unit('Geartron Prototype', 96, 4, 'Warden', 3, 2, 11, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', '', _skill('Sundering Smash', 'Chant', -1.0, "At the start of your turn, deal {0} to all enemies in this unit's lane and make them Vulnerable for {1}.")),
		_unit('Geartron-5000', 97, 5, 'Warden', 3, 3, 13, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', 'Geartron Prototype', _skill('Sundering Smash', 'Chant', -1.0, "At the start of your turn, deal {0} to all enemies in this unit's lane and make them Vulnerable for {1}.")),
		_unit('Bethany', 98, 4, 'Artillerist', 3, 4, 6, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', '', _skill('Hopping Mad', 'Reaction', -1.0, 'After attacked, this unit will attack back for {0}.')),
		_unit('Bunnybot Bethany', 99, 5, 'Artillerist', 3, 5, 7, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', 'Bethany', _skill('Hopping Mad', 'Reaction', -1.0, 'After attacked, this unit will attack back for {0}.')),
		_unit('Final Empress', 100, 4, 'Duelist', 2, 3, 6, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', '', _skill('Moonlight', 'Aura', -1.0, 'Other allied units gain {0}.')),
		_unit('Awoken Final Empress', 101, 5, 'Duelist', 2, 4, 7, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', 'Final Empress', _skill('Moonlight', 'Aura', -1.0, 'Other allied units gain {0}.')),
		_unit('Opelle', 102, 4, 'Lifebinder', 2, 3, 5, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', '', _skill('Moonlight', 'Aura', -1.0, 'Other allied units gain {0}.')),
		_unit('Glowing Opelle', 103, 5, 'Lifebinder', 2, 3, 6, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', 'Opelle', _skill('Moonlight', 'Aura', -1.0, 'Other allied units gain {0}.')),
		_unit('Commune Defender', 104, 3, 'Warden', 4, 3, 10, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', '', _skill('Shield Wall', 'Reaction', -1.0, '{0} after being attacked to gain Protect for {1}.')),
		_unit('Commune Conductor', 105, 4, 'Warden', 4, 4, 12, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', 'Commune Defender', _skill('Shield Wall', 'Reaction', -1.0, '{0} after being attacked to gain Protect for {1}.')),
		_unit('Commune Commander', 106, 5, 'Warden', 3, 4, 13, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', 'Commune Conductor', _skill('Shield Wall', 'Reaction', -1.0, '{0} after being attacked to gain Protect for {1}.')),
		_unit('Frost-Kid Kokori', 107, 4, 'Channeler', 3, 3, 5, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', '', _skill('Freeze!', 'Warcry', -1.0, 'Deal {0} to all enemy Scout and Fighter units in target lane and Immobilise them for {1}.')),
		_unit('Ice-Prince Kokori', 108, 5, 'Channeler', 3, 4, 7, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', 'Frost-Kid Kokori', _skill('Freeze!', 'Warcry', -1.0, 'Deal {0} to all enemy Scout and Fighter units in target lane and Immobilise them for {1}.')),
		_unit('Mata Swiftblade', 109, 4, 'Strider', 4, 3, 5, 3, 1, 'Double Strike — Attacks twice each action.', '', _skill('Weakening Strike', 'Strike', -1.0, "{0} to reduce attacked enemy unit's ATK by {1} for {2}.")),
		_unit('Swiftblade Heroine', 110, 5, 'Strider', 4, 4, 6, 3, 1, 'Double Strike — Attacks twice each action.', 'Mata Swiftblade', _skill('Weakening Strike', 'Strike', -1.0, "{0} to reduce attacked enemy unit's ATK by {1} for {2}.")),
		_unit('LDF Constable', 111, 2, 'Warden', 2, 2, 8, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', '', _skill('Protect', 'Warcry', -1.0, 'Grant target allied unit Protect for {0}.')),
		_unit('LDF Sergeant', 112, 3, 'Warden', 2, 3, 9, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', 'LDF Constable', _skill('Protect', 'Warcry', -1.0, 'Grant target allied unit Protect for {0}.')),
		_unit('Joe Wonder', 113, 3, 'Warden', 2, 2, 4, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', '', _skill('Protect', 'Warcry', -1.0, 'Grant target allied unit Protect for {0}.')),
		_unit('Pompous Joe Wonder', 114, 4, 'Warden', 2, 3, 5, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', 'Joe Wonder', _skill('Protect', 'Warcry', -1.0, 'Grant target allied unit Protect for {0}.')),
		_unit('Raging Dragon', 115, 3, 'Channeler', 4, 5, 6, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', '', _skill('Fireball', 'Warcry', -1.0, 'Deal {0} to target enemy unit. Adjacent enemy units take {1}.')),
		_unit('Blazing Dragon', 116, 4, 'Channeler', 4, 6, 7, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', 'Raging Dragon', _skill('Fireball', 'Warcry', -1.0, 'Deal {0} to target enemy unit. Adjacent enemy units take {1}.')),
		_unit('Royal Yeoman', 117, 3, 'Duelist', 2, 2, 4, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', '', _skill("Warrior's Vigour", 'Warcry', -1.0, 'Other allied Defender or Fighter with the lowest HP gains {0} and {1} for {2}.')),
		_unit('Royal Beefeater', 118, 4, 'Duelist', 2, 3, 5, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', 'Royal Yeoman', _skill("Warrior's Vigour", 'Warcry', -1.0, 'Other allied Defender or Fighter with the lowest HP gains {0} and {1} for {2}.')),
		_unit('Pub Barman', 119, 3, 'Warden', 2, 2, 7, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', '', _skill('Grit', 'Reaction', -1.0, '{0} to gain Regen for {1} after being attacked.')),
		_unit('Pub Landlord', 120, 4, 'Warden', 2, 3, 9, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', 'Pub Barman', _skill('Grit', 'Reaction', -1.0, '{0} to gain Regen for {1} after being attacked.')),
		_unit('The Archaeologist', 121, 4, 'Duelist', 2, 4, 6, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', '', _skill('Grit', 'Reaction', -1.0, '{0} to gain Regen for {1} after being attacked.')),
		_unit('The Castaway', 122, 5, 'Duelist', 2, 5, 6, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', 'The Archaeologist', _skill('Grit', 'Reaction', -1.0, '{0} to gain Regen for {1} after being attacked.')),
		_unit('The Botanist', 123, 3, 'Lifebinder', 2, 2, 4, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', '', _skill('Prune', 'Warcry', -1.0, 'Immobilise is removed from target Priest or Mage. Target unit also gains Regen for {0}.')),
		_unit('The Ecologist', 124, 4, 'Lifebinder', 2, 3, 5, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', 'The Botanist', _skill('Prune', 'Warcry', -1.0, 'Immobilise is removed from target Priest or Mage. Target unit also gains Regen for {0}.')),
		_unit('The Biologist', 125, 5, 'Lifebinder', 2, 4, 6, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', 'The Ecologist', _skill('Prune', 'Warcry', -1.0, 'Immobilise is removed from target Priest or Mage. Target unit also gains Regen for {0}.')),
		_unit('Rescue Corps', 126, 3, 'Lifebinder', 2, 3, 4, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', '', _skill('Medic!', 'Warcry', -1.0, 'Immobilise is removed from target Fighter or Defender. Target unit also gains Regen for {0}.')),
		_unit('Rescue Paramedic', 127, 4, 'Lifebinder', 2, 4, 5, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', 'Rescue Corps', _skill('Medic!', 'Warcry', -1.0, 'Immobilise is removed from target Fighter or Defender. Target unit also gains Regen for {0}.')),
		_unit('Fabulous Bors', 128, 4, 'Warden', 2, 2, 6, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', '', _skill('Medic!', 'Warcry', -1.0, 'Immobilise is removed from target Fighter or Defender. Target unit also gains Regen for {0}.')),
		_unit('Sir Bors', 129, 5, 'Warden', 2, 3, 7, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', 'Fabulous Bors', _skill('Medic!', 'Warcry', -1.0, 'Immobilise is removed from target Fighter or Defender. Target unit also gains Regen for {0}.')),
		_unit('Selina the Stylist', 130, 4, 'Strider', 2, 2, 4, 3, 1, 'Double Strike — Attacks twice each action.', '', _skill('New Look', 'Warcry', -1.0, 'Immobilise is removed from target Scout or Gunner. Target unit gains Regen for {0}.')),
		_unit('Selina Twinblade', 131, 5, 'Strider', 2, 2, 5, 3, 1, 'Double Strike — Attacks twice each action.', 'Selina the Stylist', _skill('New Look', 'Warcry', -1.0, 'Immobilise is removed from target Scout or Gunner. Target unit gains Regen for {0}.')),
		_unit('The Witch Doctor', 132, 5, 'Lifebinder', 2, 2, 7, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', '', _skill('Lifestream', 'Chant', -1.0, 'At the start of your turn, grant all allied units Regen for {0} and {1} allied units with Immobilise have it removed.')),
		_unit('The Earth Whisperer', 133, 6, 'Lifebinder', 2, 2, 8, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', 'The Witch Doctor', _skill('Lifestream', 'Chant', -1.0, 'At the start of your turn, grant all allied units Regen for {0} and {1} allied units with Immobilise have it removed.')),
		_unit('Hamish Highlander', 134, 4, 'Warden', 2, 1, 7, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', '', _skill('Caber Toss', 'Strike', -1.0, 'On attack, Knocks Back enemy unit by {0} spaces. Additional {1} to gain Regen for 1 turn.')),
		_unit('Hamish Lochmaster', 135, 5, 'Warden', 2, 1, 8, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', 'Hamish Highlander', _skill('Caber Toss', 'Strike', -1.0, 'On attack, Knocks Back enemy unit by {0} spaces. Additional {1} to gain Regen for 1 turn.')),
		_unit('The Rook', 136, 5, 'Warden', 2, 2, 8, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', '', _skill('Impairing Joust', 'Chant', -1.0, 'At the end of your turn, all enemy Taunted units become Immobilised for {0}. {1} for this unit to gain Regen for {2}.')),
		_unit('Sterling Knight', 137, 6, 'Warden', 2, 3, 9, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', 'The Rook', _skill('Impairing Joust', 'Chant', -1.0, 'At the end of your turn, all enemy Taunted units become Immobilised for {0}. {1} for this unit to gain Regen for {2}.')),
		_unit('Deep Sea Barney', 138, 4, 'Warden', 2, 0, 8, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', '', _skill('Ambient Pressure', 'Reaction', -1.0, 'After attacked, {0} to gain {1}. This unit then has {0} to gain Regen for 1 player turn.')),
		_unit('Bulkhead Barney', 139, 5, 'Warden', 2, 0, 10, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', 'Deep Sea Barney', _skill('Ambient Pressure', 'Reaction', -1.0, 'After attacked, {0} to gain {1}. This unit then has {0} to gain Regen for 1 player turn.')),
		_unit('Crewman Basilic', 140, 4, 'Artillerist', 4, 4, 9, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', '', _skill('Cannon Barrage', 'Strike', -1.0, "After attack, deals {0} to all enemy units not in this unit's lane. {1} to also grant this unit Regen for 2 player turns.")),
		_unit('Conductor Basilic', 141, 5, 'Artillerist', 4, 5, 11, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', 'Crewman Basilic', _skill('Cannon Barrage', 'Strike', -1.0, "After attack, deals {0} to all enemy units not in this unit's lane. {1} to also grant this unit Regen for 2 player turns.")),
		_unit('Oro the Pilgrim', 142, 5, 'Lifebinder', 2, 1, 4, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', '', _skill('Guard', 'Warcry', -1.0, 'All allied units gain Protect for 3 enemy turns. {0} to also grant them Regen for 2 player turns.')),
		_unit('Oro the Enlightened', 143, 6, 'Lifebinder', 2, 2, 4, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', 'Oro the Pilgrim', _skill('Guard', 'Warcry', -1.0, 'All allied units gain Protect for 3 enemy turns. {0} to also grant them Regen for 2 player turns.')),
		_unit('Cara Pace', 144, 4, 'Strider', 2, 0, 5, 3, 1, 'Double Strike — Attacks twice each action.', '', _skill('Pincer Drain', 'Strike', -1.0, 'On every Attack to an Immobilised Enemy Unit, gains {0}. {1} to gain Regen for 1 turn.')),
		_unit('Clawing Cara', 145, 5, 'Strider', 2, 0, 6, 3, 1, 'Double Strike — Attacks twice each action.', 'Cara Pace', _skill('Pincer Drain', 'Strike', -1.0, 'On every Attack to an Immobilised Enemy Unit, gains {0}. {1} to gain Regen for 1 turn.')),
		_unit('Clair', 146, 5, 'Duelist', 2, 4, 5, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', '', _skill('Slash Speed', 'Strike', -1.0, 'After attack, Knocks Back enemy {0} spaces and {1} other enemies with highest ATK by same number of spaces. {2} gains Regen for 1 player turn.')),
		_unit('Awoken Clair', 147, 6, 'Duelist', 2, 6, 6, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', 'Clair', _skill('Slash Speed', 'Strike', -1.0, 'After attack, Knocks Back enemy {0} spaces and {1} other enemies with highest ATK by same number of spaces. {2} gains Regen for 1 player turn.')),
		_unit('White Mage', 148, 5, 'Lifebinder', 3, 2, 6, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', '', _skill('Mighty Guard', 'Chant', -1.0, 'For {0} player turns all allied units gain Protect and Regen for 2 player turns. After {0} enemy turns, this unit is Defeated.')),
		_unit('White Wizard', 149, 6, 'Lifebinder', 3, 3, 7, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', 'White Mage', _skill('Mighty Guard', 'Chant', -1.0, 'For {0} player turns all allied units gain Protect and Regen for 2 player turns. After {0} enemy turns, this unit is Defeated.')),
		_unit('Steph Lopod', 150, 5, 'Channeler', 2, 3, 6, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', '', _skill("Ocean's Reclaim", 'Chant', -1.0, 'At the start of every turn, removes Immobilise and Stun from {0} other allied units and awards Regen for {1}.')),
		_unit('Steph the Tentacled', 151, 6, 'Channeler', 2, 5, 7, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', 'Steph Lopod', _skill("Ocean's Reclaim", 'Chant', -1.0, 'At the start of every turn, removes Immobilise and Stun from {0} other allied units and awards Regen for {1}.')),
		_unit('Ant Lantis', 152, 4, 'Warden', 2, 1, 6, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', '', _skill('Tide Turn', 'Reaction', -1.0, 'Before attacked this unit will Taunt the attacker for {0}. {1} to gain Regen for 1 turn.')),
		_unit('Swelling Ant', 153, 5, 'Warden', 2, 2, 7, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', 'Ant Lantis', _skill('Tide Turn', 'Reaction', -1.0, 'Before attacked this unit will Taunt the attacker for {0}. {1} to gain Regen for 1 turn.')),
		_unit('Ki', 154, 4, 'Warden', 2, 2, 7, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', '', _skill('Yield!', 'Reaction', -1.0, 'After attacked, attacker is Knocked Back {0} spaces and Immobilised for 2 enemy turns. {1} to gain Regen for 1 player turn.')),
		_unit('Hammering Ki', 155, 5, 'Warden', 2, 3, 9, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', 'Ki', _skill('Yield!', 'Reaction', -1.0, 'After attacked, attacker is Knocked Back {0} spaces and Immobilised for 2 enemy turns. {1} to gain Regen for 1 player turn.')),
		_unit('Gawain the Just', 156, 5, 'Duelist', 2, 2, 6, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', '', _skill("Galatine's Ground", 'Chant', -1.0, 'At the end of your turn, all enemy Immobilised units become Stunned for {0}. {1} for this unit to gain Regen for 3 turns.')),
		_unit('Sir Gawain', 157, 6, 'Duelist', 2, 3, 7, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', 'Gawain the Just', _skill("Galatine's Ground", 'Chant', -1.0, 'At the end of your turn, all enemy Immobilised units become Stunned for {0}. {1} for this unit to gain Regen for 3 turns.')),
		_unit('Sakura', 158, 5, 'Channeler', 3, 2, 7, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', '', _skill("Blossom's Bloom", 'Chant', -1.0, 'At the start of the player turn, other allied units with Regen gain {0} for 1 player turn.')),
		_unit('Blossom Sakura', 159, 6, 'Channeler', 3, 3, 8, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', 'Sakura', _skill("Blossom's Bloom", 'Chant', -1.0, 'At the start of the player turn, other allied units with Regen gain {0} for 1 player turn.')),
		_unit('Inti Chihuan', 160, 5, 'Lifebinder', 2, 1, 4, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', '', _skill('Sun Festival', 'Warcry', -1.0, 'At the end of {0} player turns, all allies with Regen gain {1} and Haste. All allies restore {2}.')),
		_unit('Shining Inti', 161, 6, 'Lifebinder', 2, 2, 5, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', 'Inti Chihuan', _skill('Sun Festival', 'Warcry', -1.0, 'At the end of {0} player turns, all allies with Regen gain {1} and Haste. All allies restore {2}.')),
		_unit('Van Hohenheim', 162, 5, 'Lifebinder', 2, 1, 6, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', '', _skill("Trisha's Prospect", 'Strike', -1.0, 'After attacking an enemy with Protect, removes Protect from all enemies and gives it to all allies for {0} enemy turns. All allies gain Regen for 2 player turns.')),
		_unit("The Sorcerer's Stone", 163, 6, 'Lifebinder', 2, 2, 7, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', 'Van Hohenheim', _skill("Trisha's Prospect", 'Strike', -1.0, 'After attacking an enemy with Protect, removes Protect from all enemies and gives it to all allies for {0} enemy turns. All allies gain Regen for 2 player turns.')),
		_unit('José', 164, 5, 'Duelist', 2, 2, 6, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', '', _skill("Trisha's Prospect", 'Strike', -1.0, 'After attacking an enemy with Protect, removes Protect from all enemies and gives it to all allies for {0} enemy turns. All allies gain Regen for 2 player turns.')),
		_unit('José Decomposé', 165, 6, 'Duelist', 2, 3, 6, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', 'José', _skill("Trisha's Prospect", 'Strike', -1.0, 'After attacking an enemy with Protect, removes Protect from all enemies and gives it to all allies for {0} enemy turns. All allies gain Regen for 2 player turns.')),
		_unit('Furia Rojo', 166, 4, 'Warden', 2, 2, 8, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', '', _skill('Tag-Team', 'Reaction', -1.0, 'After an allied Tag-Team unit is attacked, target other allied unit gains 1 ATK and this unit has {0} to gain Regen for 1 player turn.')),
		_unit('Campeon Rojo', 167, 5, 'Warden', 2, 2, 10, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', 'Furia Rojo', _skill('Tag-Team', 'Reaction', -1.0, 'After an allied Tag-Team unit is attacked, target other allied unit gains 1 ATK and this unit has {0} to gain Regen for 1 player turn.')),
		_unit('Sakuya (Fantail Pigeon)', 168, 1, 'Channeler', 2, 1, 1, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', '', null),
		_unit('Sakuya Le Bel Shirogane', 169, 6, 'Channeler', 2, 4, 6, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', 'Sakuya (Fantail Pigeon)', _skill('Heartful Brother', 'Strike', -1.0, 'After attack all enemies lose {0} for {1} enemy turns, and if Yuuya is on the board, also become Vulnerable for {2} player turns.')),
		_unit('Yuuya (Fantail Pigeon)', 170, 1, 'Artillerist', 2, 1, 1, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', '', null),
		_unit('Yuuya Sakazaki', 171, 6, 'Artillerist', 2, 3, 6, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', 'Yuuya (Fantail Pigeon)', _skill('Hurtful Brother', 'Strike', -1.0, 'After attack all allies gain {0} for {1} player turns, and if Sakuya is on the board, also gain Regen for {2} player turns.')),
		_unit('Three of Hearts', 172, 4, 'Warden', 3, 1, 8, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', '', _skill('Royal Flush', 'Warcry', -1.0, 'All allied units in target lane gain Protect for {0}.')),
		_unit('Ace of Hearts', 173, 5, 'Warden', 3, 2, 11, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', 'Three of Hearts', _skill('Royal Flush', 'Warcry', -1.0, 'All allied units in target lane gain Protect for {0}.')),
		_unit('Philippa Trot', 174, 4, 'Duelist', 3, 3, 6, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', '', _skill('Royal Flush', 'Warcry', -1.0, 'All allied units in target lane gain Protect for {0}.')),
		_unit('Galloping Philippa', 175, 5, 'Duelist', 3, 4, 6, 2, 1, 'Fury — Permanently gains +1 ATK after attacking.', 'Philippa Trot', _skill('Royal Flush', 'Warcry', -1.0, 'All allied units in target lane gain Protect for {0}.')),
		_unit('The Aquanaut', 176, 5, 'Artillerist', 3, 3, 5, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', '', _skill('Hydroblast', 'Chant', -1.0, 'At the start of your turn, all enemy units in same lane as this unit lose {0} and are Knocked Back by {1} spaces.')),
		_unit('The Hydronaut', 177, 6, 'Artillerist', 3, 4, 7, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', 'The Aquanaut', _skill('Hydroblast', 'Chant', -1.0, 'At the start of your turn, all enemy units in same lane as this unit lose {0} and are Knocked Back by {1} spaces.')),
		_unit('Thief', 178, 5, 'Strider', 3, 2, 5, 3, 1, 'Double Strike — Attacks twice each action.', '', _skill('Roguish Snare', 'Chant', -1.0, 'At the start of your opponents turn, the last unit they place on the board will be Stunned for 2 turns with {0} to become permanently Poisoned.')),
		_unit('Cutpurse', 179, 6, 'Strider', 3, 2, 6, 3, 1, 'Double Strike — Attacks twice each action.', 'Thief', _skill('Roguish Snare', 'Chant', -1.0, 'At the start of your opponents turn, the last unit they place on the board will be Stunned for 2 turns with {0} to become permanently Poisoned.')),
		_unit('Present Verdandi', 180, 5, 'Lifebinder', 4, 2, 6, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', '', _skill('Roguish Snare', 'Chant', -1.0, 'At the start of your opponents turn, the last unit they place on the board will be Stunned for 2 turns with {0} to become permanently Poisoned.')),
		_unit('Verdandi Norn', 181, 6, 'Lifebinder', 4, 2, 7, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', 'Present Verdandi', _skill('Roguish Snare', 'Chant', -1.0, 'At the start of your opponents turn, the last unit they place on the board will be Stunned for 2 turns with {0} to become permanently Poisoned.')),
		_unit('Frontier Rider', 182, 5, 'Artillerist', 2, 2, 5, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', '', _skill('Wrangle', 'Chant', -1.0, 'At the start of your turn, all allied units behind this unit gain Protect for {0}. All enemy units in front of this unit lose {1} for {2}. (Affects all lanes).')),
		_unit('Frontier Protector', 183, 6, 'Artillerist', 2, 3, 5, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', 'Frontier Rider', _skill('Wrangle', 'Chant', -1.0, 'At the start of your turn, all allied units behind this unit gain Protect for {0}. All enemy units in front of this unit lose {1} for {2}. (Affects all lanes).')),
		_unit('Lunnain Oracle', 184, 5, 'Lifebinder', 2, 2, 5, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', '', _skill('Divine Silence', 'Warcry', -1.0, 'Target enemy unit is Silenced for {0} enemy turns.')),
		_unit('Lunnain Divine', 185, 6, 'Lifebinder', 2, 3, 7, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', 'Lunnain Oracle', _skill('Divine Silence', 'Warcry', -1.0, 'Target enemy unit is Silenced for {0} enemy turns.')),
		_unit('Ra', 186, 5, 'Warden', 4, 2, 10, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', '', _skill('Cattle of Ra', 'Chant', -1.0, 'At the end of the player turn, all Taunted enemy units are knocked back {0} spaces, are Immobilised and lose {1} for 1 enemy turn.')),
		_unit('Ra, Creator', 187, 6, 'Warden', 4, 3, 11, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', 'Ra', _skill('Cattle of Ra', 'Chant', -1.0, 'At the end of the player turn, all Taunted enemy units are knocked back {0} spaces, are Immobilised and lose {1} for 1 enemy turn.')),
		_unit('Rydia of Mist', 188, 5, 'Channeler', 3, 3, 7, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', '', _skill('Summon Forth', 'Warcry', -1.0, 'For {0} enemy turns, this Unit takes 0 damage when attacked and deals {1} damage back to {2} random enemy units with the highest ATK.')),
		_unit('Summoner Rydia', 189, 6, 'Channeler', 3, 4, 8, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', 'Rydia of Mist', _skill('Summon Forth', 'Warcry', -1.0, 'For {0} enemy turns, this Unit takes 0 damage when attacked and deals {1} damage back to {2} random enemy units with the highest ATK.')),
		_unit('Booth', 190, 5, 'Artillerist', 3, 4, 6, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', '', _skill('Summon Forth', 'Warcry', -1.0, 'For {0} enemy turns, this Unit takes 0 damage when attacked and deals {1} damage back to {2} random enemy units with the highest ATK.')),
		_unit('Booth Kavar', 191, 6, 'Artillerist', 3, 5, 7, 1, 3, 'Piercing Shot — Damages every enemy in range in its lane.', 'Booth', _skill('Summon Forth', 'Warcry', -1.0, 'For {0} enemy turns, this Unit takes 0 damage when attacked and deals {1} damage back to {2} random enemy units with the highest ATK.')),
		_unit('Medusa', 192, 5, 'Channeler', 4, 3, 9, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', '', _skill('Stone Gaze', 'Chant', -1.0, 'At start of player turn, 1 random non-Poisoned enemy is Poisoned for {0} enemy turns. {1} Poisoned enemies in front of this unit are Stunned for 1 enemy turn.')),
		_unit('Gorgon Medusa', 193, 6, 'Channeler', 4, 4, 10, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', 'Medusa', _skill('Stone Gaze', 'Chant', -1.0, 'At start of player turn, 1 random non-Poisoned enemy is Poisoned for {0} enemy turns. {1} Poisoned enemies in front of this unit are Stunned for 1 enemy turn.')),
		_unit('Nageki (Mourning Dove)', 194, 1, 'Lifebinder', 2, 1, 1, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', '', null),
		_unit('Nageki Fujishiro', 195, 6, 'Lifebinder', 3, 2, 5, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', 'Nageki (Mourning Dove)', _skill('Quiet!', 'Chant', -1.0, 'At the start of {0} enemy turns, {1} enemies with the highest ATK are Silenced for {2} enemy turns. This unit takes 0 damage from all Silenced enemies.')),
		_unit('Jimimi the Shepherd', 196, 4, 'Lifebinder', 3, 3, 4, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', '', _skill('Woolen Blanket', 'Warcry', -1.0, 'Target ally unit gains {0} and Protect for {1}.')),
		_unit('Jimimi the Herder', 197, 5, 'Lifebinder', 3, 4, 5, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', 'Jimimi the Shepherd', _skill('Woolen Blanket', 'Warcry', -1.0, 'Target ally unit gains {0} and Protect for {1}.')),
		_unit('Hookie', 198, 4, 'Channeler', 3, 3, 3, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', '', _skill('Woolen Blanket', 'Warcry', -1.0, 'Target ally unit gains {0} and Protect for {1}.')),
		_unit('Beautifly Hookie', 199, 5, 'Channeler', 3, 4, 4, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', 'Hookie', _skill('Woolen Blanket', 'Warcry', -1.0, 'Target ally unit gains {0} and Protect for {1}.')),
		_unit('Winter Harding', 200, 4, 'Warden', 3, 2, 9, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', '', _skill('Woolen Blanket', 'Warcry', -1.0, 'Target ally unit gains {0} and Protect for {1}.')),
		_unit('Happy Elf Harding', 201, 5, 'Warden', 3, 3, 10, 2, 1, 'Taunting Strike — Target cannot change lanes for 2 turns.', 'Winter Harding', _skill('Woolen Blanket', 'Warcry', -1.0, 'Target ally unit gains {0} and Protect for {1}.')),
		_unit('Edge', 202, 5, 'Strider', 3, 2, 5, 3, 1, 'Double Strike — Attacks twice each action.', '', _skill('Shadowbind', 'Warcry', -1.0, 'Reduce {0} of all enemy units in target lane and Immobilise them for {1}.')),
		_unit('Ninja Edge', 203, 6, 'Strider', 3, 3, 6, 3, 1, 'Double Strike — Attacks twice each action.', 'Edge', _skill('Shadowbind', 'Warcry', -1.0, 'Reduce {0} of all enemy units in target lane and Immobilise them for {1}.')),
		_unit('Explorer Gatling', 204, 5, 'Strider', 3, 2, 5, 3, 1, 'Double Strike — Attacks twice each action.', '', _skill('Shadowbind', 'Warcry', -1.0, 'Reduce {0} of all enemy units in target lane and Immobilise them for {1}.')),
		_unit('Raider Gatling', 205, 6, 'Strider', 3, 3, 6, 3, 1, 'Double Strike — Attacks twice each action.', 'Explorer Gatling', _skill('Shadowbind', 'Warcry', -1.0, 'Reduce {0} of all enemy units in target lane and Immobilise them for {1}.')),
		_unit('Belladonna', 206, 5, 'Channeler', 3, 4, 5, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', '', _skill('Shadowbind', 'Warcry', -1.0, 'Reduce {0} of all enemy units in target lane and Immobilise them for {1}.')),
		_unit('The Twilight Queen', 207, 6, 'Channeler', 3, 6, 5, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', 'Belladonna', _skill('Shadowbind', 'Warcry', -1.0, 'Reduce {0} of all enemy units in target lane and Immobilise them for {1}.')),
		_unit('Claw Minstrel', 208, 2, 'Lifebinder', 3, 2, 3, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', '', _skill('Inspire Lambkin', 'Aura', -1.0, 'Other allied Lambkin gain {0} and {1}.')),
		_unit('Claw Rocker', 209, 3, 'Lifebinder', 3, 3, 5, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', 'Claw Minstrel', _skill('Inspire Lambkin', 'Aura', -1.0, 'Other allied Lambkin gain {0} and {1}.')),
		_unit('Conjuring Clown', 210, 3, 'Channeler', 3, 4, 2, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', '', _skill('Inspire Lambkin', 'Aura', -1.0, 'Other allied Lambkin gain {0} and {1}.')),
		_unit('Conjuring Harlequin', 211, 4, 'Channeler', 3, 5, 4, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', 'Conjuring Clown', _skill('Inspire Lambkin', 'Aura', -1.0, 'Other allied Lambkin gain {0} and {1}.')),
		_unit('Conjuring Jester', 212, 5, 'Channeler', 3, 6, 5, 1, 3, 'Blast — Adjacent enemies take half ATK damage.', 'Conjuring Harlequin', _skill('Inspire Lambkin', 'Aura', -1.0, 'Other allied Lambkin gain {0} and {1}.')),
		_unit('Flame Warden', 213, 3, 'Lifebinder', 2, 2, 3, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', '', _skill('Inspire Lambkin', 'Aura', -1.0, 'Other allied Lambkin gain {0} and {1}.')),
		_unit('Flame Dissident', 214, 4, 'Lifebinder', 2, 3, 4, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', 'Flame Warden', _skill('Inspire Lambkin', 'Aura', -1.0, 'Other allied Lambkin gain {0} and {1}.')),
		_unit('Flame Schematic', 215, 5, 'Lifebinder', 2, 4, 5, 1, 2, 'Heal — Before moving, gives 2 HP to the lowest-health ally.', 'Flame Dissident', _skill('Inspire Lambkin', 'Aura', -1.0, 'Other allied Lambkin gain {0} and {1}.'))
	]

static func all_units() -> Array[UnitData]:
	_build()
	return _units

static func by_name(unit_name: String) -> UnitData:
	_build()
	unit_name = canonical_name(unit_name)
	for unit in _units:
		if unit.name == unit_name:
			return unit
	return null

static func canonical_name(unit_name: String) -> String:
	return LEGACY_NAME_ALIASES.get(unit_name, unit_name)

static func legacy_name(unit_name: String) -> String:
	for old_name in LEGACY_NAME_ALIASES:
		if LEGACY_NAME_ALIASES[old_name] == unit_name:
			return old_name
	return unit_name

static func display_class(kind: String) -> String:
	return CLASS_NAMES.get(kind, kind)

static func class_color(kind: String) -> Color:
	return CLASS_COLORS.get(kind, Color("#91a7ce"))

static func faction_for_icon(icon_id: int) -> String:
	for faction in FACTION_ICON_IDS:
		if icon_id in FACTION_ICON_IDS[faction]:
			return faction
	return "Universal"

static func faction_for_name(unit_name: String) -> String:
	var unit := by_name(unit_name)
	return faction_for_icon(unit.icon) if unit != null else ""

static func art_id(icon_id: int) -> int:
	return ICON_ART_IDS.get(icon_id, icon_id)
