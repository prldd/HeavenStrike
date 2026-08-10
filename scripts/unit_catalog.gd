class_name UnitCatalog
extends RefCounted

const LegacyContentMigrationScript = preload("res://scripts/legacy_content_migration.gd")

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
	"Coal": [119, 120, 166, 167, 15, 16, 17, 18, 36, 69, 70, 63, 64, 65, 66, 67, 68, 170, 171, 176, 177, 182, 183, 190, 191, 90, 91, 115, 116, 198, 199, 148, 149, 213, 214, 215],
	"Steam": [96, 97, 104, 105, 106, 111, 112, 136, 137, 138, 139, 186, 187, 200, 201, 117, 118, 43, 44, 77, 78, 83, 84, 98, 99, 28, 34, 158, 159, 51, 52, 180, 181, 196, 197],
	"Wind": [113, 114, 152, 153, 75, 76, 37, 38, 41, 42, 109, 110, 144, 145, 178, 179, 202, 203, 204, 205, 39, 40, 88, 89, 59, 60, 150, 151, 168, 169, 23, 24, 71, 72, 208, 209],
	"Fusion": [53, 54, 154, 155, 73, 74, 25, 31, 79, 80, 19, 20, 140, 141, 45, 46, 47, 92, 93, 107, 108, 188, 189, 192, 193, 206, 207, 210, 211, 212, 27, 33, 184, 185, 194, 195],
	"Solar": [128, 129, 134, 135, 172, 173, 81, 82, 130, 131, 57, 58, 61, 62, 26, 32, 55, 56, 48, 49, 50, 102, 103, 123, 124, 125, 126, 127, 132, 133, 142, 143, 160, 161, 162, 163]
}

const ICON_ART_IDS := {
	30: 1301, # Relay Bastion-030
	36: 1302, # Cinder Blade-036
	42: 1303, # Zephyr Lancer-042
	47: 1304, # Flux Weaver-047
	48: 1305, # Helio Mender-048
	25: 29, # Flux Lancer-025
	26: 33, # Helio Weaver-026
	27: 83, # Flux Mender-027
	28: 177, # Brass Weaver-028
	29: 423, # Relay Blade-029
	31: 30, # Flux Lancer-031
	32: 34, # Helio Weaver-032
	33: 84, # Flux Mender-033
	34: 178, # Brass Weaver-034
	35: 424, # Relay Blade-035
	37: 77, # Zephyr Lancer-037
	38: 78, # Zephyr Lancer-038
	39: 535, # Zephyr Battery-039
	40: 536, # Zephyr Battery-040
	41: 611, # Zephyr Lancer-041
	43: 41, # Brass Lancer-043
	44: 42, # Brass Lancer-044
	81: 39, # Helio Blade-081
	82: 40, # Helio Blade-082
	83: 43, # Brass Battery-083
	84: 44, # Brass Battery-084
	85: 75, # Relay Blade-085
	86: 76, # Relay Blade-086
	87: 609, # Relay Blade-087
	49: 47, # Helio Mender-049
	50: 48, # Helio Mender-050
	51: 59, # Brass Mender-051
	52: 60, # Brass Mender-052
	53: 85, # Flux Bastion-053
	54: 86, # Flux Bastion-054
	55: 57, # Helio Weaver-055
	56: 58, # Helio Weaver-056
	57: 55, # Helio Battery-057
	58: 56, # Helio Battery-058
	59: 165, # Zephyr Weaver-059
	60: 166, # Zephyr Weaver-060
	61: 187, # Helio Battery-061
	62: 188, # Helio Battery-062
	63: 79, # Cinder Battery-063
	64: 80, # Cinder Battery-064
	65: 613, # Cinder Battery-065
	66: 103, # Cinder Battery-066
	67: 104, # Cinder Battery-067
	68: 629, # Cinder Battery-068
	69: 101, # Cinder Lancer-069
	70: 102, # Cinder Lancer-070
	71: 167, # Zephyr Mender-071
	72: 168, # Zephyr Mender-072
	73: 183, # Flux Blade-073
	74: 184, # Flux Blade-074
	75: 27, # Zephyr Blade-075
	76: 28, # Zephyr Blade-076
	77: 89, # Brass Lancer-077
	78: 90, # Brass Lancer-078
	79: 487, # Flux Lancer-079
	80: 488, # Flux Lancer-080
	88: 31, # Zephyr Battery-088
	89: 32, # Zephyr Battery-089
	90: 93, # Cinder Weaver-090
	91: 94, # Cinder Weaver-091
	92: 81, # Flux Weaver-092
	93: 82, # Flux Weaver-093
	94: 195, # Relay Blade-094
	95: 196, # Relay Blade-095
	96: 289, # Brass Bastion-096
	97: 290, # Brass Bastion-097
	98: 787, # Brass Battery-098
	99: 788, # Brass Battery-099
	100: 887, # Relay Blade-100
	101: 888, # Relay Blade-101
	102: 1191, # Helio Mender-102
	103: 1192, # Helio Mender-103
	104: 73, # Brass Bastion-104
	105: 74, # Brass Bastion-105
	106: 607, # Brass Bastion-106
	107: 141, # Flux Weaver-107
	108: 142, # Flux Weaver-108
	109: 149, # Zephyr Lancer-109
	110: 150, # Zephyr Lancer-110
	111: 37, # Brass Bastion-111
	112: 38, # Brass Bastion-112
	113: 97, # Zephyr Bastion-113
	114: 98, # Zephyr Bastion-114
	115: 105, # Cinder Weaver-115
	116: 106, # Cinder Weaver-116
	117: 87, # Brass Blade-117
	118: 88, # Brass Blade-118
	119: 61, # Cinder Bastion-119
	120: 62, # Cinder Bastion-120
	121: 521, # Relay Blade-121
	122: 522, # Relay Blade-122
	123: 71, # Helio Mender-123
	124: 72, # Helio Mender-124
	125: 605, # Helio Mender-125
	126: 95, # Helio Mender-126
	127: 96, # Helio Mender-127
	128: 715, # Helio Bastion-128
	129: 716, # Helio Bastion-129
	130: 137, # Helio Lancer-130
	131: 138, # Helio Lancer-131
	132: 203, # Helio Mender-132
	133: 204, # Helio Mender-133
	134: 231, # Helio Bastion-134
	135: 232, # Helio Bastion-135
	136: 241, # Brass Bastion-136
	137: 242, # Brass Bastion-137
	138: 253, # Brass Bastion-138
	139: 254, # Brass Bastion-139
	140: 259, # Flux Battery-140
	141: 260, # Flux Battery-141
	142: 275, # Helio Mender-142
	143: 276, # Helio Mender-143
	144: 363, # Zephyr Lancer-144
	145: 364, # Zephyr Lancer-145
	146: 429, # Relay Blade-146
	147: 430, # Relay Blade-147
	148: 435, # Cinder Mender-148
	149: 436, # Cinder Mender-149
	150: 462, # Zephyr Weaver-150
	151: 463, # Zephyr Weaver-151
	152: 643, # Zephyr Bastion-152
	153: 644, # Zephyr Bastion-153
	154: 651, # Flux Bastion-154
	155: 652, # Flux Bastion-155
	156: 707, # Relay Blade-156
	157: 708, # Relay Blade-157
	158: 791, # Brass Weaver-158
	159: 792, # Brass Weaver-159
	160: 825, # Helio Mender-160
	161: 826, # Helio Mender-161
	162: 865, # Helio Mender-162
	163: 866, # Helio Mender-163
	164: 1199, # Relay Blade-164
	165: 1200, # Relay Blade-165
	166: 947, # Cinder Bastion-166
	167: 948, # Cinder Bastion-167
	168: 1025, # Zephyr Weaver-168
	169: 1026, # Zephyr Weaver-169
	170: 1027, # Cinder Battery-170
	171: 1028, # Cinder Battery-171
	172: 325, # Helio Bastion-172
	173: 326, # Helio Bastion-173
	174: 979, # Relay Blade-174
	175: 980, # Relay Blade-175
	176: 127, # Cinder Battery-176
	177: 128, # Cinder Battery-177
	178: 597, # Zephyr Lancer-178
	179: 598, # Zephyr Lancer-179
	180: 965, # Brass Mender-180
	181: 966, # Brass Mender-181
	182: 295, # Cinder Battery-182
	183: 296, # Cinder Battery-183
	184: 215, # Flux Mender-184
	185: 216, # Flux Mender-185
	186: 1011, # Brass Bastion-186
	187: 1012, # Brass Bastion-187
	188: 697, # Flux Weaver-188
	189: 698, # Flux Weaver-189
	190: 1123, # Cinder Battery-190
	191: 1124, # Cinder Battery-191
	192: 747, # Flux Weaver-192
	193: 748, # Flux Weaver-193
	194: 1019, # Flux Mender-194
	195: 1020, # Flux Mender-195
	196: 263, # Brass Mender-196
	197: 264, # Brass Mender-197
	198: 321, # Cinder Weaver-198
	199: 322, # Cinder Weaver-199
	200: 567, # Brass Bastion-200
	201: 568, # Brass Bastion-201
	202: 693, # Zephyr Lancer-202
	203: 694, # Zephyr Lancer-203
	204: 1053, # Zephyr Lancer-204
	205: 1054, # Zephyr Lancer-205
	206: 1153, # Flux Weaver-206
	207: 1154, # Flux Weaver-207
	208: 35, # Zephyr Mender-208
	209: 36, # Zephyr Mender-209
	210: 69, # Flux Weaver-210
	211: 70, # Flux Weaver-211
	212: 603, # Flux Weaver-212
	213: 107, # Cinder Mender-213
	214: 108, # Cinder Mender-214
	215: 633 # Cinder Mender-215
}

## Original chassis families keyed by project icon. Units missing from this
## table use the standard frame. Families are mechanical tuning groups used
## by a small number of authored synergies; they do not imply species.
const CHASSIS_FAMILIES := {
	30: "bulwark", # Relay Bastion-030
	42: "swift", # Zephyr Lancer-042
	47: "resonant", # Flux Weaver-047
	48: "resonant", # Helio Mender-048
	9: "swift", # Relay Lancer-009
	2: "bulwark", # Relay Blade-002
	11: "resonant", # Relay Weaver-011
	6: "resonant", # Relay Mender-006
	13: "bulwark", # Relay Bastion-013
	15: "bulwark", # Cinder Blade-015
	21: "resonant", # Relay Weaver-021
	25: "swift", # Flux Lancer-025
	26: "resonant", # Helio Weaver-026
	28: "resonant", # Brass Weaver-028
	29: "bulwark", # Relay Blade-029
	14: "bulwark", # Relay Bastion-014
	16: "bulwark", # Cinder Blade-016
	22: "resonant", # Relay Weaver-022
	31: "swift", # Flux Lancer-031
	32: "resonant", # Helio Weaver-032
	34: "resonant", # Brass Weaver-034
	35: "bulwark", # Relay Blade-035
	37: "swift", # Zephyr Lancer-037
	38: "swift", # Zephyr Lancer-038
	41: "swift", # Zephyr Lancer-041
	57: "swift", # Helio Battery-057
	58: "swift", # Helio Battery-058
	59: "resonant", # Zephyr Weaver-059
	60: "resonant", # Zephyr Weaver-060
	66: "swift", # Cinder Battery-066
	67: "swift", # Cinder Battery-067
	68: "swift", # Cinder Battery-068
	77: "swift", # Brass Lancer-077
	78: "swift", # Brass Lancer-078
	83: "swift", # Brass Battery-083
	84: "swift", # Brass Battery-084
	94: "bulwark", # Relay Blade-094
	95: "bulwark", # Relay Blade-095
	96: "resonant", # Brass Bastion-096
	97: "resonant", # Brass Bastion-097
	102: "resonant", # Helio Mender-102
	103: "resonant", # Helio Mender-103
	104: "bulwark", # Brass Bastion-104
	105: "bulwark", # Brass Bastion-105
	106: "bulwark", # Brass Bastion-106
	107: "resonant", # Flux Weaver-107
	108: "resonant", # Flux Weaver-108
	119: "bulwark", # Cinder Bastion-119
	120: "bulwark", # Cinder Bastion-120
	121: "bulwark", # Relay Blade-121
	122: "bulwark", # Relay Blade-122
	123: "resonant", # Helio Mender-123
	124: "resonant", # Helio Mender-124
	125: "resonant", # Helio Mender-125
	128: "bulwark", # Helio Bastion-128
	129: "bulwark", # Helio Bastion-129
	132: "resonant", # Helio Mender-132
	133: "resonant", # Helio Mender-133
	134: "bulwark", # Helio Bastion-134
	135: "bulwark", # Helio Bastion-135
	142: "resonant", # Helio Mender-142
	143: "resonant", # Helio Mender-143
	144: "swift", # Zephyr Lancer-144
	145: "swift", # Zephyr Lancer-145
	148: "swift", # Cinder Mender-148
	149: "swift", # Cinder Mender-149
	150: "swift", # Zephyr Weaver-150
	151: "swift", # Zephyr Weaver-151
	152: "bulwark", # Zephyr Bastion-152
	153: "bulwark", # Zephyr Bastion-153
	154: "bulwark", # Flux Bastion-154
	155: "bulwark", # Flux Bastion-155
	156: "bulwark", # Relay Blade-156
	157: "bulwark", # Relay Blade-157
	158: "resonant", # Brass Weaver-158
	160: "resonant", # Helio Mender-160
	161: "resonant", # Helio Mender-161
	166: "bulwark", # Cinder Bastion-166
	167: "bulwark", # Cinder Bastion-167
	172: "bulwark", # Helio Bastion-172
	173: "bulwark", # Helio Bastion-173
	178: "swift", # Zephyr Lancer-178
	179: "swift", # Zephyr Lancer-179
	182: "resonant", # Cinder Battery-182
	183: "resonant", # Cinder Battery-183
	196: "resonant", # Brass Mender-196
	197: "resonant", # Brass Mender-197
	198: "resonant", # Cinder Weaver-198
	199: "resonant", # Cinder Weaver-199
	204: "swift", # Zephyr Lancer-204
	205: "swift", # Zephyr Lancer-205
	206: "swift", # Flux Weaver-206
	207: "swift", # Flux Weaver-207
	208: "resonant", # Zephyr Mender-208
	209: "resonant", # Zephyr Mender-209
	210: "resonant", # Flux Weaver-210
	211: "resonant", # Flux Weaver-211
	212: "resonant", # Flux Weaver-212
	213: "resonant", # Cinder Mender-213
	214: "resonant", # Cinder Mender-214
	215: "resonant" # Cinder Mender-215
}

static var _units: Array[UnitData] = []

# Preserve existing collections and squads created before the leader-title
# terminology was standardized. Split legacy spellings keep obsolete copy out
# of searchable project text while still allowing old save values to migrate.
const LEGACY_NAME_ALIASES := {
	"Cap" + "tain Kerryson": "Flux Bastion-053",
	"Commune Cap" + "tain": "Brass Bastion-105",
	"Cap" + "tain Basilic": "Flux Battery-141"
}

## Authored per-level secondary-skill magnitudes. Row index is unit level - 1;
## each row holds values substituted into the {0}/{1} placeholders.
const RANK_VALUES := {
	"Failover Mantle": [["1 HP", "1 turn"], ["2 HP", "1 turn"], ["2 HP", "2 turns"], ["3 HP", "2 turns"], ["4 HP", "3 turns"]],
	"Furnace Wake": [["1 ATK", "1 turn"], ["1 ATK", "2 turns"], ["2 ATK", "2 turns"], ["2 ATK", "3 turns"], ["3 ATK", "3 turns"]],
	"Slipstream Reversal": [["1", "1 turn"], ["2", "1 turn"], ["2", "2 turns"], ["3", "2 turns"], ["4", "3 turns"]],
	"Phase Cascade": [["1 damage", "1 turn"], ["2 damage", "1 turn"], ["2 damage", "2 turns"], ["3 damage", "2 turns"], ["4 damage", "3 turns"]],
	"Dawn Circuit": [["1 HP", "1 ATK"], ["2 HP", "1 ATK"], ["2 HP", "2 ATK"], ["3 HP", "2 ATK"], ["4 HP", "3 ATK"]],
	"Brace Protocol": [["3 HP", "2 turns"], ["3 HP", "3 turns"], ["4 HP", "3 turns"], ["4 HP", "4 turns"], ["5 HP", "5 turns"]],
	"Overclock Link": [["1 ATK", "2 turns"], ["1 ATK", "3 turns"], ["2 ATK", "3 turns"], ["2 ATK", "4 turns"], ["2 ATK", "5 turns"]],
	"Arc Lance": [["1 damage"], ["2 damage"], ["3 damage"], ["4 damage"], ["5 damage"]],
	"Relay Storm": [["1 damage"], ["2 damage"], ["3 damage"], ["4 damage"], ["5 damage"]],
	"Signal Jam": [["1 ATK", "2 turns"], ["2 ATK", "2 turns"], ["3 ATK", "2 turns"], ["3 ATK", "3 turns"], ["4 ATK", "3 turns"]],
	"Repair Pulse": [["3 HP"], ["4 HP"], ["5 HP"], ["6 HP"], ["7 HP"]],
	"Corrosion Bloom": [["1 damage", "2 turns"], ["2 damage", "2 turns"], ["2 damage", "3 turns"], ["2 damage", "4 turns"], ["3 damage", "4 turns"]],
	"Toxin Injector": [["2 turns"], ["3 turns"], ["4 turns"], ["5 turns"], ["6 turns"]],
	"Anchor Shot": [["1 damage", "1 turn"], ["2 damage", "1 turn"], ["3 damage", "1 turn"], ["3 damage", "2 turns"], ["4 damage", "2 turns"]],
	"Breach Charge": [["1 damage", "2 turns"], ["2 damage", "2 turns"], ["2 damage", "3 turns"], ["3 damage", "3 turns"], ["3 damage", "4 turns"]],
	"Suppression Field": [["1 ATK", "2 turns"], ["2 ATK", "2 turns"], ["3 ATK", "2 turns"], ["3 ATK", "3 turns"], ["4 ATK", "3 turns"]],
	"Countermeasure": [["1 ATK", "2 turns"], ["2 ATK", "2 turns"], ["3 ATK", "2 turns"], ["3 ATK", "3 turns"], ["4 ATK", "3 turns"]],
	"Locking Strike": [["30% chance", "1 turn"], ["32% chance", "1 turn"], ["35% chance", "1 turn"], ["37% chance", "2 turns"], ["40% chance", "2 turns"]],
	"Sever Drive": [["60% chance", "1 turn"], ["70% chance", "1 turn"], ["80% chance", "1 turn"], ["90% chance", "2 turns"], ["100% chance", "2 turns"]],
	"Corrosive Edge": [["50% chance", "2 turns"], ["60% chance", "2 turns"], ["70% chance", "2 turns"], ["80% chance", "3 turns"], ["90% chance", "3 turns"]],
	"Heavy Target": [["1 damage", "2 turns"], ["2 damage", "2 turns"], ["2 damage", "3 turns"], ["3 damage", "3 turns"], ["3 damage", "4 turns"]],
	"Chain Corrosion": [["1 damage", "2 turns"], ["2 damage", "2 turns"], ["2 damage", "3 turns"], ["2 damage", "4 turns"], ["3 damage", "4 turns"]],
	"Meteor Pattern": [["2 damage"], ["2 damage"], ["3 damage"], ["3 damage"], ["4 damage"]],
	"Breaker Impact": [["1 damage", "2 turns"], ["2 damage", "2 turns"], ["2 damage", "3 turns"], ["3 damage", "3 turns"], ["3 damage", "4 turns"]],
	"Reactor Leap": [["3 damage"], ["5 damage"], ["6 damage"], ["7 damage"], ["9 damage"]],
	"Lumen Shell": [["4 HP"], ["5 HP"], ["6 HP"], ["7 HP"], ["8 HP"]],
	"Aegis Array": [["40% chance", "2 turns"], ["42% chance", "2 turns"], ["45% chance", "2 turns"], ["47% chance", "3 turns"], ["50% chance", "3 turns"]],
	"Cryo Lock": [["1 damage", "1 turn"], ["2 damage", "1 turn"], ["3 damage", "1 turn"], ["3 damage", "2 turns"], ["4 damage", "2 turns"]],
	"Drain Strike": [["60% chance", "1 ATK", "2 turns"], ["70% chance", "2 ATK", "2 turns"], ["80% chance", "3 ATK", "2 turns"], ["90% chance", "3 ATK", "3 turns"], ["100% chance", "4 ATK", "3 turns"]],
	"Guard Link": [["2 turns"], ["3 turns"], ["4 turns"], ["5 turns"], ["6 turns"]],
	"Thermal Burst": [["1 damage", "1 damage"], ["2 damage", "1 damage"], ["2 damage", "2 damage"], ["3 damage", "2 damage"], ["3 damage", "3 damage"]],
	"Combat Surge": [["2 HP", "1 ATK", "2 turns"], ["2 HP", "1 ATK", "3 turns"], ["2 HP", "2 ATK", "3 turns"], ["2 HP", "2 ATK", "4 turns"], ["3 HP", "2 ATK", "4 turns"]],
	"Holdfast": [["40% chance", "2 turns"], ["42% chance", "2 turns"], ["45% chance", "2 turns"], ["47% chance", "3 turns"], ["50% chance", "3 turns"]],
	"Purge Routine": [["2 turns"], ["3 turns"], ["4 turns"], ["5 turns"], ["6 turns"]],
	"Field Recovery": [["2 turns"], ["3 turns"], ["4 turns"], ["5 turns"], ["6 turns"]],
	"Refit Cycle": [["2 turns"], ["3 turns"], ["4 turns"], ["5 turns"], ["6 turns"]],
	"Renewal Current": [["2 turns", "1 random"], ["3 turns", "2 random"], ["4 turns", "3 random"], ["5 turns", "3 random"], ["6 turns", "4 random"]],
	"Kinetic Throw": [["2", "30% chance"], ["2", "35% chance"], ["2", "40% chance"], ["3", "45% chance"], ["3", "50% chance"]],
	"Lockdown Sweep": [["1 turn", "30% chance", "3 turns"], ["1 turn", "35% chance", "3 turns"], ["2 turns", "40% chance", "3 turns"], ["2 turns", "45% chance", "3 turns"], ["2 turns", "50% chance", "3 turns"]],
	"Pressure Sink": [["60% chance", "1 ATK"], ["70% chance", "1 ATK"], ["80% chance", "1 ATK"], ["90% chance", "2 ATK"], ["100% chance", "2 ATK"]],
	"Saturation Fire": [["2 damage", "40% chance"], ["3 damage", "55% chance"], ["3 damage", "70% chance"], ["4 damage", "85% chance"], ["4 damage", "100% chance"]],
	"Cover Matrix": [["40% chance"], ["55% chance"], ["70% chance"], ["85% chance"], ["100% chance"]],
	"Clamp Drain": [["1 ATK", "30% chance"], ["2 ATK", "32% chance"], ["2 ATK", "35% chance"], ["3 ATK", "37% chance"], ["3 ATK", "40% chance"]],
	"Vector Flurry": [["2", "1 random", "40% chance"], ["2", "2 random", "60% chance"], ["3", "2 random", "60% chance"], ["3", "2 random", "80% chance"], ["4", "2 random", "100% chance"]],
	"Lasting Aegis": [["1"], ["2"], ["3"], ["4"], ["5"]],
	"Tidal Reset": [["1 random", "2 turns"], ["1 random", "3 turns"], ["2 random", "4 turns"], ["2 random", "5 turns"], ["2 random", "6 turns"]],
	"Reversal Current": [["1 turns", "20% chance"], ["1 turns", "40% chance"], ["2 turns", "60% chance"], ["2 turns", "80% chance"], ["2 turns", "100% chance"]],
	"Repulse Command": [["2", "30% chance"], ["2", "35% chance"], ["3", "40% chance"], ["3", "45% chance"], ["4", "50% chance"]],
	"Grounding Wave": [["1 turns", "30% chance"], ["1 turns", "35% chance"], ["2 turns", "40% chance"], ["2 turns", "45% chance"], ["2 turns", "50% chance"]],
	"Growth Pulse": [["1 ATK"], ["2 ATK"], ["3 ATK"], ["4 ATK"], ["5 ATK"]],
	"Solar Crescendo": [["2", "1 ATK", "2 HP"], ["3", "2 ATK", "3 HP"], ["4", "2 ATK", "4 HP"], ["4", "3 ATK", "4 HP"], ["4", "3 ATK", "5 HP"]],
	"Shield Exchange": [["2"], ["3"], ["4"], ["5"], ["6"]],
	"Paired Circuit": [["20% chance"], ["40% chance"], ["60% chance"], ["80% chance"], ["100% chance"]],
	"Twin Dissonance": [["1 ATK", "2", "2"], ["2 ATK", "2", "2"], ["2 ATK", "3", "3"], ["3 ATK", "3", "3"], ["3 ATK", "4", "4"]],
	"Twin Resonance": [["1 HP", "2", "2"], ["1 HP", "3", "3"], ["2 HP", "3", "3"], ["2 HP", "4", "4"], ["3 HP", "4", "4"]],
	"Lane Bulwark": [["2 turns"], ["3 turns"], ["4 turns"], ["5 turns"], ["6 turns"]],
	"Pressure Jet": [["1 ATK", "1"], ["2 ATK", "1"], ["2 ATK", "2"], ["3 ATK", "2"], ["3 ATK", "3"]],
	"Deployment Snare": [["20% chance"], ["40% chance"], ["60% chance"], ["80% chance"], ["100% chance"]],
	"Frontline Relay": [["1 turn", "1 ATK", "1 turn"], ["1 turn", "2 ATK", "1 turn"], ["2 turns", "2 ATK", "1 turn"], ["2 turns", "2 ATK", "2 turns"], ["2 turns", "3 ATK", "2 turns"]],
	"Dragnet": [["1", "1 ATK"], ["2", "1 ATK"], ["2", "2 ATK"], ["3", "2 ATK"], ["3", "3 ATK"]],
	"Null Signal": [["1"], ["2"], ["3"], ["4"], ["5"]],
	"Petrify Loop": [["1", "1"], ["1", "2"], ["2", "2"], ["3", "2"], ["3", "3"]],
	"Retaliation Screen": [["1", "50%", "1"], ["2", "50%", "2"], ["2", "100%", "2"], ["2", "100%", "3"], ["3", "100%", "3"]],
	"Silent Cycle": [["1", "1 random", "1"], ["1", "2 random", "2"], ["2", "2 random", "2"], ["3", "2 random", "2"], ["3", "3 random", "3"]],
	"Thermal Wrap": [["1 HP", "2 turns"], ["2 HP", "2 turns"], ["3 HP", "2 turns"], ["3 HP", "3 turns"], ["4 HP", "3 turns"]],
	"Umbral Clamp": [["1 ATK", "2 turns"], ["2 ATK", "2 turns"], ["3 ATK", "2 turns"], ["3 ATK", "3 turns"], ["4 ATK", "3 turns"]],
	"Resonant Chorus": [["1 HP", "1 ATK"], ["2 HP", "1 ATK"], ["2 HP", "2 ATK"], ["3 HP", "2 ATK"], ["4 HP", "2 ATK"]]
}

## Player-facing copy is authored here rather than embedded in roster rows.
## This keeps mechanics, rank placeholders, and writing independently editable.
const SKILL_DESCRIPTIONS := {
	"Failover Mantle": "On deployment, restore {0} to every damaged ally; the most damaged also gains Protect for {1}.",
	"Furnace Wake": "After attacking, this unit gains {0} and Haste for {1}.",
	"Slipstream Reversal": "After being attacked, knock the attacker back {0} spaces and gain Haste for {1}.",
	"Phase Cascade": "At turn start, deal {0} to the strongest enemy; if it is Immobilised or Silenced, Stun it for {1}.",
	"Dawn Circuit": "Other allied units with Regen gain {0} and {1} while this unit is active.",
	"Brace Protocol": "On deployment, the other ally with the lowest HP gains {0} for {1}.",
	"Overclock Link": "On deployment, another ally gains {0} for {1}.",
	"Arc Lance": "On deployment, deal {0} to the enemy with the highest HP.",
	"Relay Storm": "On deployment, distribute {0} among random enemies.",
	"Signal Jam": "On deployment, the strongest enemy Scout or Gunner loses {0} for {1}.",
	"Repair Pulse": "On deployment, restore {0} to the allied unit with the lowest HP.",
	"Corrosion Bloom": "On deployment, every other unit takes {0} and is Poisoned for {1}.",
	"Toxin Injector": "On deployment, Poison a selected enemy for {0}.",
	"Anchor Shot": "On deployment, deal {0} to the strongest enemy Defender, Fighter, or Scout and Immobilise it for {1}.",
	"Breach Charge": "On deployment, deal {0} to the toughest enemy Defender or Fighter and make it Vulnerable for {1}.",
	"Suppression Field": "On deployment, Fighters, Scouts, and Defenders in one enemy lane lose {0} for {1}.",
	"Countermeasure": "On deployment, the strongest enemy Fighter or Mage loses {0} for {1}.",
	"Locking Strike": "Each attack has {0} to Immobilise its target for {1}.",
	"Sever Drive": "Each attack has {0} to Immobilise its target for {1}.",
	"Corrosive Edge": "Each attack has {0} to Poison its target for {1}.",
	"Heavy Target": "On deployment, the enemy with the highest HP takes {0} and becomes Vulnerable for {1}.",
	"Chain Corrosion": "On deployment, all enemy Mages and Priests take {0} and are Poisoned for {1}.",
	"Meteor Pattern": "On deployment, deal {0} to every enemy in a selected lane.",
	"Breaker Impact": "At turn start, enemies in this unit's lane take {0} and become Vulnerable for {1}.",
	"Reactor Leap": "After this unit is attacked, it retaliates for {0}.",
	"Lumen Shell": "Other allied units gain {0} while this unit is active.",
	"Aegis Array": "After being attacked, this unit has {0} to gain Protect for {1}.",
	"Cryo Lock": "On deployment, enemy Scouts and Fighters in one lane take {0} and are Immobilised for {1}.",
	"Drain Strike": "Each attack has {0} to reduce its target's ATK by {1} for {2}.",
	"Guard Link": "On deployment, a selected ally gains Protect for {0}.",
	"Thermal Burst": "On deployment, deal {0} to one enemy and {1} to adjacent enemies.",
	"Combat Surge": "On deployment, the lowest-HP allied Defender or Fighter gains {0} and {1} for {2}.",
	"Holdfast": "After being attacked, this unit has {0} to gain Regen for {1}.",
	"Purge Routine": "On deployment, remove Immobilise from a Priest or Mage and grant Regen for {0}.",
	"Field Recovery": "On deployment, remove Immobilise from a Fighter or Defender and grant Regen for {0}.",
	"Refit Cycle": "On deployment, remove Immobilise from a Scout or Gunner and grant Regen for {0}.",
	"Renewal Current": "At turn start, all allies gain Regen for {0}; remove Immobilise from {1} allies.",
	"Kinetic Throw": "After attacking, knock the target back {0} spaces; this unit has {1} to gain Regen for 1 turn.",
	"Lockdown Sweep": "At turn end, Taunted enemies become Immobilised for {0}; this unit has {1} to gain Regen for {2}.",
	"Pressure Sink": "After being attacked, this unit has {0} to gain {1}, then the same chance to gain Regen for 1 turn.",
	"Saturation Fire": "After attacking, enemies in other lanes take {0}; this unit has {1} to gain Regen for 2 turns.",
	"Cover Matrix": "On deployment, all allies gain Protect for 3 enemy turns; {0} to also gain Regen for 2 turns.",
	"Clamp Drain": "Attacking an Immobilised enemy grants {0}; this unit has {1} to gain Regen for 1 turn.",
	"Vector Flurry": "After attacking, knock the target and {1} strong enemies back {0} spaces; {2} to gain Regen.",
	"Lasting Aegis": "For {0} turns, allies gain Protect and Regen; this unit is defeated when the cycle ends.",
	"Tidal Reset": "At turn start, remove Immobilise and Stun from {0} allies and grant them Regen for {1}.",
	"Reversal Current": "Before being attacked, Taunt the attacker for {0}; this unit has {1} to gain Regen.",
	"Repulse Command": "After being attacked, knock the attacker back {0} spaces and Immobilise it; {1} to gain Regen.",
	"Grounding Wave": "At turn end, Immobilised enemies are Stunned for {0}; this unit has {1} to gain Regen.",
	"Growth Pulse": "At turn start, other allies with Regen gain {0} for 1 turn.",
	"Solar Crescendo": "After {0} turns, allies with Regen gain {1} and Haste; all allies restore {2}.",
	"Shield Exchange": "Attacking a Protected enemy transfers enemy Protect to all allies for {0}; allies also gain Regen.",
	"Paired Circuit": "When another linked unit is attacked, one ally gains 1 ATK; this unit has {0} to gain Regen.",
	"Twin Dissonance": "After attacking, enemies lose {0} for {1}; with its linked counterpart, they also become Vulnerable for {2}.",
	"Twin Resonance": "After attacking, allies gain {0} for {1}; with its linked counterpart, they also gain Regen for {2}.",
	"Lane Bulwark": "On deployment, all allies in a selected lane gain Protect for {0}.",
	"Pressure Jet": "At turn start, enemies in this unit's lane lose {0} and are knocked back {1} spaces.",
	"Deployment Snare": "At the opponent's turn start, their newest unit is Stunned; {0} to Poison it permanently.",
	"Frontline Relay": "At turn start, allies behind this unit gain Protect for {0}; enemies ahead lose {1} for {2}.",
	"Dragnet": "At turn end, Taunted enemies are knocked back {0}, Immobilised, and lose {1} for 1 turn.",
	"Null Signal": "On deployment, Silence a selected enemy for {0} turns.",
	"Petrify Loop": "At turn start, Poison one enemy for {0}, then Stun {1} Poisoned enemies ahead.",
	"Retaliation Screen": "For {0} enemy turns, attacks deal no damage to this unit; it returns {1} to {2} strong enemies.",
	"Silent Cycle": "For {0} enemy turns, Silence {1} strong enemies for {2}; Silenced enemies cannot damage this unit.",
	"Thermal Wrap": "On deployment, a selected ally gains {0} and Protect for {1}.",
	"Umbral Clamp": "On deployment, enemies in one lane lose {0} and are Immobilised for {1}.",
	"Resonant Chorus": "Other allied Resonant chassis gain {0} and {1} while this unit is active."
}

static func _skill(name: String, type: String, chance: float) -> SkillData:
	var s := SkillData.new()
	s.name = name
	s.type = type
	s.chance = chance
	s.description = SKILL_DESCRIPTIONS.get(name, "")
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
	attack_range: int,
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
	u.range = attack_range
	u.chassis_family = CHASSIS_FAMILIES.get(icon, "standard")
	u.description = text
	u.promotion_of = promotion_of
	u.skill = skill
	return u

static func _build() -> void:
	if not _units.is_empty():
		return
	_units = [
		_unit('Relay Lancer-003', 3, 1, 'Strider', 2, 2, 4, 3, 1, 'Twin Actuator — Performs two attacks each action.', '', null),
		_unit('Relay Lancer-009', 9, 1, 'Strider', 3, 3, 5, 3, 1, 'Twin Actuator — Performs two attacks each action.', '', null),
		_unit('Relay Blade-002', 2, 1, 'Duelist', 2, 3, 7, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', '', null),
		_unit('Relay Blade-008', 8, 1, 'Duelist', 2, 3, 5, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', '', null),
		_unit('Relay Bastion-001', 1, 1, 'Warden', 3, 3, 10, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', '', null),
		_unit('Relay Bastion-007', 7, 1, 'Warden', 2, 2, 8, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', '', null),
		_unit('Relay Battery-004', 4, 1, 'Artillerist', 2, 3, 4, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', '', null),
		_unit('Relay Battery-010', 10, 1, 'Artillerist', 3, 4, 5, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', '', null),
		_unit('Relay Weaver-005', 5, 1, 'Channeler', 3, 5, 4, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', '', null),
		_unit('Relay Weaver-011', 11, 1, 'Channeler', 2, 4, 3, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', '', null),
		_unit('Relay Mender-006', 6, 1, 'Lifebinder', 2, 2, 5, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', '', null),
		_unit('Relay Mender-012', 12, 1, 'Lifebinder', 3, 3, 5, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', '', null),
		_unit('Relay Bastion-013', 13, 2, 'Warden', 3, 2, 4, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', '', _skill('Brace Protocol', 'Warcry', -1.0)),
		_unit('Cinder Blade-015', 15, 2, 'Duelist', 2, 2, 4, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', '', _skill('Overclock Link', 'Warcry', -1.0)),
		_unit('Cinder Lancer-017', 17, 2, 'Strider', 3, 2, 3, 3, 1, 'Twin Actuator — Performs two attacks each action.', '', _skill('Locking Strike', 'Strike', -1.0)),
		_unit('Flux Battery-019', 19, 2, 'Artillerist', 2, 3, 2, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', '', _skill('Arc Lance', 'Warcry', -1.0)),
		_unit('Relay Weaver-021', 21, 2, 'Channeler', 2, 3, 2, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', '', _skill("Relay Storm", 'Warcry', -1.0)),
		_unit('Zephyr Mender-023', 23, 2, 'Lifebinder', 3, 2, 4, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', '', _skill('Overclock Link', 'Warcry', -1.0)),
		_unit('Flux Lancer-025', 25, 2, 'Strider', 2, 2, 4, 3, 1, 'Twin Actuator — Performs two attacks each action.', '', _skill("Relay Storm", 'Warcry', -1.0)),
		_unit('Helio Weaver-026', 26, 2, 'Channeler', 3, 4, 2, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', '', _skill('Arc Lance', 'Warcry', -1.0)),
		_unit('Flux Mender-027', 27, 3, 'Lifebinder', 2, 3, 4, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', '', _skill('Brace Protocol', 'Warcry', -1.0)),
		_unit('Brass Weaver-028', 28, 4, 'Channeler', 3, 3, 6, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', '', _skill('Overclock Link', 'Warcry', -1.0)),
		_unit('Relay Blade-029', 29, 4, 'Duelist', 2, 3, 5, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', '', _skill('Arc Lance', 'Warcry', -1.0)),
		_unit('Relay Bastion-030', 30, 3, 'Warden', 3, 2, 8, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', '', _skill('Failover Mantle', 'Warcry', -1.0)),
		_unit('Relay Bastion-014', 14, 3, 'Warden', 3, 3, 6, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', 'Relay Bastion-013', _skill('Brace Protocol', 'Warcry', -1.0)),
		_unit('Cinder Blade-016', 16, 3, 'Duelist', 2, 3, 6, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', 'Cinder Blade-015', _skill('Overclock Link', 'Warcry', -1.0)),
		_unit('Cinder Lancer-018', 18, 3, 'Strider', 3, 3, 4, 3, 1, 'Twin Actuator — Performs two attacks each action.', 'Cinder Lancer-017', _skill('Locking Strike', 'Strike', -1.0)),
		_unit('Flux Battery-020', 20, 3, 'Artillerist', 2, 4, 4, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', 'Flux Battery-019', _skill('Arc Lance', 'Warcry', -1.0)),
		_unit('Relay Weaver-022', 22, 3, 'Channeler', 2, 4, 4, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', 'Relay Weaver-021', _skill("Relay Storm", 'Warcry', -1.0)),
		_unit('Zephyr Mender-024', 24, 3, 'Lifebinder', 3, 3, 5, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', 'Zephyr Mender-023', _skill('Overclock Link', 'Warcry', -1.0)),
		_unit('Flux Lancer-031', 31, 3, 'Strider', 2, 2, 5, 3, 1, 'Twin Actuator — Performs two attacks each action.', 'Flux Lancer-025', _skill("Relay Storm", 'Warcry', -1.0)),
		_unit('Helio Weaver-032', 32, 3, 'Channeler', 3, 5, 4, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', 'Helio Weaver-026', _skill('Arc Lance', 'Warcry', -1.0)),
		_unit('Flux Mender-033', 33, 4, 'Lifebinder', 2, 4, 5, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', 'Flux Mender-027', _skill('Brace Protocol', 'Warcry', -1.0)),
		_unit('Brass Weaver-034', 34, 5, 'Channeler', 3, 4, 6, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', 'Brass Weaver-028', _skill('Overclock Link', 'Warcry', -1.0)),
		_unit('Relay Blade-035', 35, 5, 'Duelist', 2, 3, 6, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', 'Relay Blade-029', _skill('Arc Lance', 'Warcry', -1.0)),
		_unit('Cinder Blade-036', 36, 3, 'Duelist', 3, 3, 6, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', '', _skill('Furnace Wake', 'Strike', -1.0)),
		_unit('Zephyr Lancer-037', 37, 3, 'Strider', 4, 2, 4, 3, 1, 'Twin Actuator — Performs two attacks each action.', '', _skill('Sever Drive', 'Strike', -1.0)),
		_unit('Zephyr Lancer-038', 38, 4, 'Strider', 4, 3, 5, 3, 1, 'Twin Actuator — Performs two attacks each action.', 'Zephyr Lancer-037', _skill('Sever Drive', 'Strike', -1.0)),
		_unit('Zephyr Battery-039', 39, 4, 'Artillerist', 3, 3, 6, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', '', _skill('Sever Drive', 'Strike', -1.0)),
		_unit('Zephyr Battery-040', 40, 5, 'Artillerist', 3, 3, 7, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', 'Zephyr Battery-039', _skill('Sever Drive', 'Strike', -1.0)),
		_unit('Zephyr Lancer-041', 41, 5, 'Strider', 3, 3, 6, 3, 1, 'Twin Actuator — Performs two attacks each action.', 'Zephyr Lancer-038', _skill('Sever Drive', 'Strike', -1.0)),
		_unit('Zephyr Lancer-042', 42, 3, 'Strider', 3, 2, 5, 3, 1, 'Twin Actuator — Performs two attacks each action.', '', _skill('Slipstream Reversal', 'Reaction', -1.0)),
		_unit('Brass Lancer-043', 43, 2, 'Strider', 3, 2, 2, 3, 1, 'Twin Actuator — Performs two attacks each action.', '', _skill('Signal Jam', 'Warcry', -1.0)),
		_unit('Brass Lancer-044', 44, 3, 'Strider', 3, 3, 3, 3, 1, 'Twin Actuator — Performs two attacks each action.', 'Brass Lancer-043', _skill('Signal Jam', 'Warcry', -1.0)),
		_unit('Flux Weaver-045', 45, 2, 'Channeler', 2, 2, 4, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', '', _skill('Signal Jam', 'Warcry', -1.0)),
		_unit('Flux Weaver-046', 46, 3, 'Channeler', 2, 3, 6, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', 'Flux Weaver-045', _skill('Signal Jam', 'Warcry', -1.0)),
		_unit('Flux Weaver-047', 47, 3, 'Channeler', 3, 3, 5, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', '', _skill('Phase Cascade', 'Chant', -1.0)),
		_unit('Helio Mender-048', 48, 3, 'Lifebinder', 3, 2, 5, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', '', _skill('Dawn Circuit', 'Aura', -1.0)),
		_unit('Helio Weaver-055', 55, 3, 'Channeler', 2, 2, 5, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', '', _skill('Signal Jam', 'Warcry', -1.0)),
		_unit('Helio Weaver-056', 56, 4, 'Channeler', 2, 3, 7, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', 'Helio Weaver-055', _skill('Signal Jam', 'Warcry', -1.0)),
		_unit('Helio Mender-049', 49, 2, 'Lifebinder', 3, 2, 3, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', '', _skill('Repair Pulse', 'Warcry', -1.0)),
		_unit('Helio Mender-050', 50, 3, 'Lifebinder', 3, 3, 4, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', 'Helio Mender-049', _skill('Repair Pulse', 'Warcry', -1.0)),
		_unit('Brass Mender-051', 51, 3, 'Lifebinder', 3, 2, 6, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', '', _skill('Corrosion Bloom', 'Warcry', -1.0)),
		_unit('Brass Mender-052', 52, 4, 'Lifebinder', 3, 3, 7, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', 'Brass Mender-051', _skill('Corrosion Bloom', 'Warcry', -1.0)),
		_unit('Flux Bastion-053', 53, 3, 'Warden', 2, 3, 6, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', '', _skill('Repair Pulse', 'Warcry', -1.0)),
		_unit('Flux Bastion-054', 54, 4, 'Warden', 2, 4, 8, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', 'Flux Bastion-053', _skill('Repair Pulse', 'Warcry', -1.0)),
		_unit('Helio Battery-057', 57, 3, 'Artillerist', 3, 4, 3, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', '', _skill('Toxin Injector', 'Warcry', -1.0)),
		_unit('Helio Battery-058', 58, 4, 'Artillerist', 3, 5, 5, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', 'Helio Battery-057', _skill('Toxin Injector', 'Warcry', -1.0)),
		_unit('Zephyr Weaver-059', 59, 4, 'Channeler', 2, 3, 7, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', '', _skill('Toxin Injector', 'Warcry', -1.0)),
		_unit('Zephyr Weaver-060', 60, 5, 'Channeler', 2, 4, 8, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', 'Zephyr Weaver-059', _skill('Toxin Injector', 'Warcry', -1.0)),
		_unit('Helio Battery-061', 61, 4, 'Artillerist', 2, 2, 6, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', '', _skill('Toxin Injector', 'Warcry', -1.0)),
		_unit('Helio Battery-062', 62, 5, 'Artillerist', 2, 3, 8, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', 'Helio Battery-061', _skill('Toxin Injector', 'Warcry', -1.0)),
		_unit('Cinder Battery-063', 63, 3, 'Artillerist', 3, 3, 6, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', '', _skill('Anchor Shot', 'Warcry', -1.0)),
		_unit('Cinder Battery-064', 64, 4, 'Artillerist', 3, 4, 7, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', 'Cinder Battery-063', _skill('Anchor Shot', 'Warcry', -1.0)),
		_unit('Cinder Battery-065', 65, 5, 'Artillerist', 2, 5, 7, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', 'Cinder Battery-064', _skill('Anchor Shot', 'Warcry', -1.0)),
		_unit('Cinder Battery-066', 66, 3, 'Artillerist', 3, 3, 5, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', '', _skill('Anchor Shot', 'Warcry', -1.0)),
		_unit('Cinder Battery-067', 67, 4, 'Artillerist', 3, 4, 7, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', 'Cinder Battery-066', _skill('Anchor Shot', 'Warcry', -1.0)),
		_unit('Cinder Battery-068', 68, 5, 'Artillerist', 2, 4, 8, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', 'Cinder Battery-067', _skill('Anchor Shot', 'Warcry', -1.0)),
		_unit('Cinder Lancer-069', 69, 3, 'Strider', 4, 2, 6, 3, 1, 'Twin Actuator — Performs two attacks each action.', '', _skill('Suppression Field', 'Warcry', -1.0)),
		_unit('Cinder Lancer-070', 70, 4, 'Strider', 4, 4, 6, 3, 1, 'Twin Actuator — Performs two attacks each action.', 'Cinder Lancer-069', _skill('Suppression Field', 'Warcry', -1.0)),
		_unit('Zephyr Mender-071', 71, 4, 'Lifebinder', 2, 3, 4, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', '', _skill('Suppression Field', 'Warcry', -1.0)),
		_unit('Zephyr Mender-072', 72, 5, 'Lifebinder', 2, 4, 5, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', 'Zephyr Mender-071', _skill('Suppression Field', 'Warcry', -1.0)),
		_unit('Flux Blade-073', 73, 4, 'Duelist', 3, 5, 7, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', '', _skill('Suppression Field', 'Warcry', -1.0)),
		_unit('Flux Blade-074', 74, 5, 'Duelist', 3, 7, 9, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', 'Flux Blade-073', _skill('Suppression Field', 'Warcry', -1.0)),
		_unit('Zephyr Blade-075', 75, 2, 'Duelist', 2, 4, 4, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', '', _skill('Countermeasure', 'Warcry', -1.0)),
		_unit('Zephyr Blade-076', 76, 3, 'Duelist', 2, 5, 4, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', 'Zephyr Blade-075', _skill('Countermeasure', 'Warcry', -1.0)),
		_unit('Brass Lancer-077', 77, 3, 'Strider', 4, 3, 5, 3, 1, 'Twin Actuator — Performs two attacks each action.', '', _skill('Countermeasure', 'Warcry', -1.0)),
		_unit("Brass Lancer-078", 78, 4, 'Strider', 4, 4, 6, 3, 1, 'Twin Actuator — Performs two attacks each action.', 'Brass Lancer-077', _skill('Countermeasure', 'Warcry', -1.0)),
		_unit('Flux Lancer-079', 79, 4, 'Strider', 2, 2, 4, 3, 1, 'Twin Actuator — Performs two attacks each action.', '', _skill('Countermeasure', 'Warcry', -1.0)),
		_unit('Flux Lancer-080', 80, 5, 'Strider', 2, 2, 5, 3, 1, 'Twin Actuator — Performs two attacks each action.', 'Flux Lancer-079', _skill('Countermeasure', 'Warcry', -1.0)),
		_unit('Helio Blade-081', 81, 2, 'Duelist', 3, 3, 8, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', '', _skill('Corrosive Edge', 'Strike', -1.0)),
		_unit('Helio Blade-082', 82, 3, 'Duelist', 3, 4, 9, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', 'Helio Blade-081', _skill('Corrosive Edge', 'Strike', -1.0)),
		_unit('Brass Battery-083', 83, 2, 'Artillerist', 4, 5, 4, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', '', _skill('Breach Charge', 'Warcry', -1.0)),
		_unit('Brass Battery-084', 84, 3, 'Artillerist', 4, 6, 6, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', 'Brass Battery-083', _skill('Breach Charge', 'Warcry', -1.0)),
		_unit('Relay Blade-085', 85, 3, 'Duelist', 2, 4, 5, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', '', _skill('Breach Charge', 'Warcry', -1.0)),
		_unit('Relay Blade-086', 86, 4, 'Duelist', 2, 5, 6, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', 'Relay Blade-085', _skill('Breach Charge', 'Warcry', -1.0)),
		_unit('Relay Blade-087', 87, 5, 'Duelist', 2, 6, 7, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', 'Relay Blade-086', _skill('Breach Charge', 'Warcry', -1.0)),
		_unit('Zephyr Battery-088', 88, 2, 'Artillerist', 3, 3, 5, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', '', _skill('Heavy Target', 'Warcry', -1.0)),
		_unit('Zephyr Battery-089', 89, 3, 'Artillerist', 3, 4, 7, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', 'Zephyr Battery-088', _skill('Heavy Target', 'Warcry', -1.0)),
		_unit('Cinder Weaver-090', 90, 3, 'Channeler', 3, 3, 5, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', '', _skill('Chain Corrosion', 'Warcry', -1.0)),
		_unit('Cinder Weaver-091', 91, 4, 'Channeler', 3, 4, 7, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', 'Cinder Weaver-090', _skill('Chain Corrosion', 'Warcry', -1.0)),
		_unit('Flux Weaver-092', 92, 3, 'Channeler', 4, 5, 6, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', '', _skill('Meteor Pattern', 'Warcry', -1.0)),
		_unit('Flux Weaver-093', 93, 4, 'Channeler', 4, 6, 8, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', 'Flux Weaver-092', _skill('Meteor Pattern', 'Warcry', -1.0)),
		_unit('Relay Blade-094', 94, 4, 'Duelist', 4, 5, 8, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', '', _skill('Breaker Impact', 'Chant', -1.0)),
		_unit('Relay Blade-095', 95, 5, 'Duelist', 4, 6, 9, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', 'Relay Blade-094', _skill('Breaker Impact', 'Chant', -1.0)),
		_unit('Brass Bastion-096', 96, 4, 'Warden', 3, 2, 11, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', '', _skill('Breaker Impact', 'Chant', -1.0)),
		_unit('Brass Bastion-097', 97, 5, 'Warden', 3, 3, 13, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', 'Brass Bastion-096', _skill('Breaker Impact', 'Chant', -1.0)),
		_unit('Brass Battery-098', 98, 4, 'Artillerist', 3, 4, 6, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', '', _skill('Reactor Leap', 'Reaction', -1.0)),
		_unit('Brass Battery-099', 99, 5, 'Artillerist', 3, 5, 7, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', 'Brass Battery-098', _skill('Reactor Leap', 'Reaction', -1.0)),
		_unit('Relay Blade-100', 100, 4, 'Duelist', 2, 3, 6, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', '', _skill('Lumen Shell', 'Aura', -1.0)),
		_unit('Relay Blade-101', 101, 5, 'Duelist', 2, 4, 7, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', 'Relay Blade-100', _skill('Lumen Shell', 'Aura', -1.0)),
		_unit('Helio Mender-102', 102, 4, 'Lifebinder', 2, 3, 5, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', '', _skill('Lumen Shell', 'Aura', -1.0)),
		_unit('Helio Mender-103', 103, 5, 'Lifebinder', 2, 3, 6, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', 'Helio Mender-102', _skill('Lumen Shell', 'Aura', -1.0)),
		_unit('Brass Bastion-104', 104, 3, 'Warden', 4, 3, 10, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', '', _skill('Aegis Array', 'Reaction', -1.0)),
		_unit('Brass Bastion-105', 105, 4, 'Warden', 4, 4, 12, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', 'Brass Bastion-104', _skill('Aegis Array', 'Reaction', -1.0)),
		_unit('Brass Bastion-106', 106, 5, 'Warden', 3, 4, 13, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', 'Brass Bastion-105', _skill('Aegis Array', 'Reaction', -1.0)),
		_unit('Flux Weaver-107', 107, 4, 'Channeler', 3, 3, 5, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', '', _skill('Cryo Lock', 'Warcry', -1.0)),
		_unit('Flux Weaver-108', 108, 5, 'Channeler', 3, 4, 7, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', 'Flux Weaver-107', _skill('Cryo Lock', 'Warcry', -1.0)),
		_unit('Zephyr Lancer-109', 109, 4, 'Strider', 4, 3, 5, 3, 1, 'Twin Actuator — Performs two attacks each action.', '', _skill('Drain Strike', 'Strike', -1.0)),
		_unit('Zephyr Lancer-110', 110, 5, 'Strider', 4, 4, 6, 3, 1, 'Twin Actuator — Performs two attacks each action.', 'Zephyr Lancer-109', _skill('Drain Strike', 'Strike', -1.0)),
		_unit('Brass Bastion-111', 111, 2, 'Warden', 2, 2, 8, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', '', _skill('Guard Link', 'Warcry', -1.0)),
		_unit('Brass Bastion-112', 112, 3, 'Warden', 2, 3, 9, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', 'Brass Bastion-111', _skill('Guard Link', 'Warcry', -1.0)),
		_unit('Zephyr Bastion-113', 113, 3, 'Warden', 2, 2, 4, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', '', _skill('Guard Link', 'Warcry', -1.0)),
		_unit('Zephyr Bastion-114', 114, 4, 'Warden', 2, 3, 5, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', 'Zephyr Bastion-113', _skill('Guard Link', 'Warcry', -1.0)),
		_unit('Cinder Weaver-115', 115, 3, 'Channeler', 4, 5, 6, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', '', _skill('Thermal Burst', 'Warcry', -1.0)),
		_unit('Cinder Weaver-116', 116, 4, 'Channeler', 4, 6, 7, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', 'Cinder Weaver-115', _skill('Thermal Burst', 'Warcry', -1.0)),
		_unit('Brass Blade-117', 117, 3, 'Duelist', 2, 2, 4, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', '', _skill("Combat Surge", 'Warcry', -1.0)),
		_unit('Brass Blade-118', 118, 4, 'Duelist', 2, 3, 5, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', 'Brass Blade-117', _skill("Combat Surge", 'Warcry', -1.0)),
		_unit('Cinder Bastion-119', 119, 3, 'Warden', 2, 2, 7, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', '', _skill('Holdfast', 'Reaction', -1.0)),
		_unit('Cinder Bastion-120', 120, 4, 'Warden', 2, 3, 9, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', 'Cinder Bastion-119', _skill('Holdfast', 'Reaction', -1.0)),
		_unit('Relay Blade-121', 121, 4, 'Duelist', 2, 4, 6, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', '', _skill('Holdfast', 'Reaction', -1.0)),
		_unit('Relay Blade-122', 122, 5, 'Duelist', 2, 5, 6, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', 'Relay Blade-121', _skill('Holdfast', 'Reaction', -1.0)),
		_unit('Helio Mender-123', 123, 3, 'Lifebinder', 2, 2, 4, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', '', _skill('Purge Routine', 'Warcry', -1.0)),
		_unit('Helio Mender-124', 124, 4, 'Lifebinder', 2, 3, 5, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', 'Helio Mender-123', _skill('Purge Routine', 'Warcry', -1.0)),
		_unit('Helio Mender-125', 125, 5, 'Lifebinder', 2, 4, 6, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', 'Helio Mender-124', _skill('Purge Routine', 'Warcry', -1.0)),
		_unit('Helio Mender-126', 126, 3, 'Lifebinder', 2, 3, 4, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', '', _skill('Field Recovery', 'Warcry', -1.0)),
		_unit('Helio Mender-127', 127, 4, 'Lifebinder', 2, 4, 5, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', 'Helio Mender-126', _skill('Field Recovery', 'Warcry', -1.0)),
		_unit('Helio Bastion-128', 128, 4, 'Warden', 2, 2, 6, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', '', _skill('Field Recovery', 'Warcry', -1.0)),
		_unit('Helio Bastion-129', 129, 5, 'Warden', 2, 3, 7, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', 'Helio Bastion-128', _skill('Field Recovery', 'Warcry', -1.0)),
		_unit('Helio Lancer-130', 130, 4, 'Strider', 2, 2, 4, 3, 1, 'Twin Actuator — Performs two attacks each action.', '', _skill('Refit Cycle', 'Warcry', -1.0)),
		_unit('Helio Lancer-131', 131, 5, 'Strider', 2, 2, 5, 3, 1, 'Twin Actuator — Performs two attacks each action.', 'Helio Lancer-130', _skill('Refit Cycle', 'Warcry', -1.0)),
		_unit('Helio Mender-132', 132, 5, 'Lifebinder', 2, 2, 7, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', '', _skill('Renewal Current', 'Chant', -1.0)),
		_unit('Helio Mender-133', 133, 6, 'Lifebinder', 2, 2, 8, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', 'Helio Mender-132', _skill('Renewal Current', 'Chant', -1.0)),
		_unit('Helio Bastion-134', 134, 4, 'Warden', 2, 1, 7, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', '', _skill('Kinetic Throw', 'Strike', -1.0)),
		_unit('Helio Bastion-135', 135, 5, 'Warden', 2, 1, 8, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', 'Helio Bastion-134', _skill('Kinetic Throw', 'Strike', -1.0)),
		_unit('Brass Bastion-136', 136, 5, 'Warden', 2, 2, 8, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', '', _skill('Lockdown Sweep', 'Chant', -1.0)),
		_unit('Brass Bastion-137', 137, 6, 'Warden', 2, 3, 9, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', 'Brass Bastion-136', _skill('Lockdown Sweep', 'Chant', -1.0)),
		_unit('Brass Bastion-138', 138, 4, 'Warden', 2, 0, 8, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', '', _skill('Pressure Sink', 'Reaction', -1.0)),
		_unit('Brass Bastion-139', 139, 5, 'Warden', 2, 0, 10, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', 'Brass Bastion-138', _skill('Pressure Sink', 'Reaction', -1.0)),
		_unit('Flux Battery-140', 140, 4, 'Artillerist', 4, 4, 9, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', '', _skill('Saturation Fire', 'Strike', -1.0)),
		_unit('Flux Battery-141', 141, 5, 'Artillerist', 4, 5, 11, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', 'Flux Battery-140', _skill('Saturation Fire', 'Strike', -1.0)),
		_unit('Helio Mender-142', 142, 5, 'Lifebinder', 2, 1, 4, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', '', _skill('Cover Matrix', 'Warcry', -1.0)),
		_unit('Helio Mender-143', 143, 6, 'Lifebinder', 2, 2, 4, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', 'Helio Mender-142', _skill('Cover Matrix', 'Warcry', -1.0)),
		_unit('Zephyr Lancer-144', 144, 4, 'Strider', 2, 0, 5, 3, 1, 'Twin Actuator — Performs two attacks each action.', '', _skill('Clamp Drain', 'Strike', -1.0)),
		_unit('Zephyr Lancer-145', 145, 5, 'Strider', 2, 0, 6, 3, 1, 'Twin Actuator — Performs two attacks each action.', 'Zephyr Lancer-144', _skill('Clamp Drain', 'Strike', -1.0)),
		_unit('Relay Blade-146', 146, 5, 'Duelist', 2, 4, 5, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', '', _skill('Vector Flurry', 'Strike', -1.0)),
		_unit('Relay Blade-147', 147, 6, 'Duelist', 2, 6, 6, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', 'Relay Blade-146', _skill('Vector Flurry', 'Strike', -1.0)),
		_unit('Cinder Mender-148', 148, 5, 'Lifebinder', 3, 2, 6, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', '', _skill('Lasting Aegis', 'Chant', -1.0)),
		_unit('Cinder Mender-149', 149, 6, 'Lifebinder', 3, 3, 7, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', 'Cinder Mender-148', _skill('Lasting Aegis', 'Chant', -1.0)),
		_unit('Zephyr Weaver-150', 150, 5, 'Channeler', 2, 3, 6, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', '', _skill("Tidal Reset", 'Chant', -1.0)),
		_unit('Zephyr Weaver-151', 151, 6, 'Channeler', 2, 5, 7, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', 'Zephyr Weaver-150', _skill("Tidal Reset", 'Chant', -1.0)),
		_unit('Zephyr Bastion-152', 152, 4, 'Warden', 2, 1, 6, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', '', _skill('Reversal Current', 'Reaction', -1.0)),
		_unit('Zephyr Bastion-153', 153, 5, 'Warden', 2, 2, 7, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', 'Zephyr Bastion-152', _skill('Reversal Current', 'Reaction', -1.0)),
		_unit('Flux Bastion-154', 154, 4, 'Warden', 2, 2, 7, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', '', _skill('Repulse Command', 'Reaction', -1.0)),
		_unit('Flux Bastion-155', 155, 5, 'Warden', 2, 3, 9, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', 'Flux Bastion-154', _skill('Repulse Command', 'Reaction', -1.0)),
		_unit('Relay Blade-156', 156, 5, 'Duelist', 2, 2, 6, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', '', _skill("Grounding Wave", 'Chant', -1.0)),
		_unit('Relay Blade-157', 157, 6, 'Duelist', 2, 3, 7, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', 'Relay Blade-156', _skill("Grounding Wave", 'Chant', -1.0)),
		_unit('Brass Weaver-158', 158, 5, 'Channeler', 3, 2, 7, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', '', _skill("Growth Pulse", 'Chant', -1.0)),
		_unit('Brass Weaver-159', 159, 6, 'Channeler', 3, 3, 8, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', 'Brass Weaver-158', _skill("Growth Pulse", 'Chant', -1.0)),
		_unit('Helio Mender-160', 160, 5, 'Lifebinder', 2, 1, 4, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', '', _skill('Solar Crescendo', 'Warcry', -1.0)),
		_unit('Helio Mender-161', 161, 6, 'Lifebinder', 2, 2, 5, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', 'Helio Mender-160', _skill('Solar Crescendo', 'Warcry', -1.0)),
		_unit('Helio Mender-162', 162, 5, 'Lifebinder', 2, 1, 6, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', '', _skill("Shield Exchange", 'Strike', -1.0)),
		_unit("Helio Mender-163", 163, 6, 'Lifebinder', 2, 2, 7, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', 'Helio Mender-162', _skill("Shield Exchange", 'Strike', -1.0)),
		_unit('Relay Blade-164', 164, 5, 'Duelist', 2, 2, 6, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', '', _skill("Shield Exchange", 'Strike', -1.0)),
		_unit('Relay Blade-165', 165, 6, 'Duelist', 2, 3, 6, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', 'Relay Blade-164', _skill("Shield Exchange", 'Strike', -1.0)),
		_unit('Cinder Bastion-166', 166, 4, 'Warden', 2, 2, 8, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', '', _skill('Paired Circuit', 'Reaction', -1.0)),
		_unit('Cinder Bastion-167', 167, 5, 'Warden', 2, 2, 10, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', 'Cinder Bastion-166', _skill('Paired Circuit', 'Reaction', -1.0)),
		_unit('Zephyr Weaver-168', 168, 1, 'Channeler', 2, 1, 1, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', '', null),
		_unit('Zephyr Weaver-169', 169, 6, 'Channeler', 2, 4, 6, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', 'Zephyr Weaver-168', _skill('Twin Dissonance', 'Strike', -1.0)),
		_unit('Cinder Battery-170', 170, 1, 'Artillerist', 2, 1, 1, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', '', null),
		_unit('Cinder Battery-171', 171, 6, 'Artillerist', 2, 3, 6, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', 'Cinder Battery-170', _skill('Twin Resonance', 'Strike', -1.0)),
		_unit('Helio Bastion-172', 172, 4, 'Warden', 3, 1, 8, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', '', _skill('Lane Bulwark', 'Warcry', -1.0)),
		_unit('Helio Bastion-173', 173, 5, 'Warden', 3, 2, 11, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', 'Helio Bastion-172', _skill('Lane Bulwark', 'Warcry', -1.0)),
		_unit('Relay Blade-174', 174, 4, 'Duelist', 3, 3, 6, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', '', _skill('Lane Bulwark', 'Warcry', -1.0)),
		_unit('Relay Blade-175', 175, 5, 'Duelist', 3, 4, 6, 2, 1, 'Momentum Core — Permanently gains 1 ATK after attacking.', 'Relay Blade-174', _skill('Lane Bulwark', 'Warcry', -1.0)),
		_unit('Cinder Battery-176', 176, 5, 'Artillerist', 3, 3, 5, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', '', _skill('Pressure Jet', 'Chant', -1.0)),
		_unit('Cinder Battery-177', 177, 6, 'Artillerist', 3, 4, 7, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', 'Cinder Battery-176', _skill('Pressure Jet', 'Chant', -1.0)),
		_unit('Zephyr Lancer-178', 178, 5, 'Strider', 3, 2, 5, 3, 1, 'Twin Actuator — Performs two attacks each action.', '', _skill('Deployment Snare', 'Chant', -1.0)),
		_unit('Zephyr Lancer-179', 179, 6, 'Strider', 3, 2, 6, 3, 1, 'Twin Actuator — Performs two attacks each action.', 'Zephyr Lancer-178', _skill('Deployment Snare', 'Chant', -1.0)),
		_unit('Brass Mender-180', 180, 5, 'Lifebinder', 4, 2, 6, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', '', _skill('Deployment Snare', 'Chant', -1.0)),
		_unit('Brass Mender-181', 181, 6, 'Lifebinder', 4, 2, 7, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', 'Brass Mender-180', _skill('Deployment Snare', 'Chant', -1.0)),
		_unit('Cinder Battery-182', 182, 5, 'Artillerist', 2, 2, 5, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', '', _skill('Frontline Relay', 'Chant', -1.0)),
		_unit('Cinder Battery-183', 183, 6, 'Artillerist', 2, 3, 5, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', 'Cinder Battery-182', _skill('Frontline Relay', 'Chant', -1.0)),
		_unit('Flux Mender-184', 184, 5, 'Lifebinder', 2, 2, 5, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', '', _skill('Null Signal', 'Warcry', -1.0)),
		_unit('Flux Mender-185', 185, 6, 'Lifebinder', 2, 3, 7, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', 'Flux Mender-184', _skill('Null Signal', 'Warcry', -1.0)),
		_unit('Brass Bastion-186', 186, 5, 'Warden', 4, 2, 10, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', '', _skill('Dragnet', 'Chant', -1.0)),
		_unit('Brass Bastion-187', 187, 6, 'Warden', 4, 3, 11, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', 'Brass Bastion-186', _skill('Dragnet', 'Chant', -1.0)),
		_unit('Flux Weaver-188', 188, 5, 'Channeler', 3, 3, 7, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', '', _skill('Retaliation Screen', 'Warcry', -1.0)),
		_unit('Flux Weaver-189', 189, 6, 'Channeler', 3, 4, 8, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', 'Flux Weaver-188', _skill('Retaliation Screen', 'Warcry', -1.0)),
		_unit('Cinder Battery-190', 190, 5, 'Artillerist', 3, 4, 6, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', '', _skill('Retaliation Screen', 'Warcry', -1.0)),
		_unit('Cinder Battery-191', 191, 6, 'Artillerist', 3, 5, 7, 1, 3, 'Rail Volley — Hits every reachable enemy in the same lane.', 'Cinder Battery-190', _skill('Retaliation Screen', 'Warcry', -1.0)),
		_unit('Flux Weaver-192', 192, 5, 'Channeler', 4, 3, 9, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', '', _skill('Petrify Loop', 'Chant', -1.0)),
		_unit('Flux Weaver-193', 193, 6, 'Channeler', 4, 4, 10, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', 'Flux Weaver-192', _skill('Petrify Loop', 'Chant', -1.0)),
		_unit('Flux Mender-194', 194, 1, 'Lifebinder', 2, 1, 1, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', '', null),
		_unit('Flux Mender-195', 195, 6, 'Lifebinder', 3, 2, 5, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', 'Flux Mender-194', _skill('Silent Cycle', 'Chant', -1.0)),
		_unit('Brass Mender-196', 196, 4, 'Lifebinder', 3, 3, 4, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', '', _skill('Thermal Wrap', 'Warcry', -1.0)),
		_unit('Brass Mender-197', 197, 5, 'Lifebinder', 3, 4, 5, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', 'Brass Mender-196', _skill('Thermal Wrap', 'Warcry', -1.0)),
		_unit('Cinder Weaver-198', 198, 4, 'Channeler', 3, 3, 3, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', '', _skill('Thermal Wrap', 'Warcry', -1.0)),
		_unit('Cinder Weaver-199', 199, 5, 'Channeler', 3, 4, 4, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', 'Cinder Weaver-198', _skill('Thermal Wrap', 'Warcry', -1.0)),
		_unit('Brass Bastion-200', 200, 4, 'Warden', 3, 2, 9, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', '', _skill('Thermal Wrap', 'Warcry', -1.0)),
		_unit('Brass Bastion-201', 201, 5, 'Warden', 3, 3, 10, 2, 1, 'Anchor Blow — The target cannot change lanes for 2 turns.', 'Brass Bastion-200', _skill('Thermal Wrap', 'Warcry', -1.0)),
		_unit('Zephyr Lancer-202', 202, 5, 'Strider', 3, 2, 5, 3, 1, 'Twin Actuator — Performs two attacks each action.', '', _skill('Umbral Clamp', 'Warcry', -1.0)),
		_unit('Zephyr Lancer-203', 203, 6, 'Strider', 3, 3, 6, 3, 1, 'Twin Actuator — Performs two attacks each action.', 'Zephyr Lancer-202', _skill('Umbral Clamp', 'Warcry', -1.0)),
		_unit('Zephyr Lancer-204', 204, 5, 'Strider', 3, 2, 5, 3, 1, 'Twin Actuator — Performs two attacks each action.', '', _skill('Umbral Clamp', 'Warcry', -1.0)),
		_unit('Zephyr Lancer-205', 205, 6, 'Strider', 3, 3, 6, 3, 1, 'Twin Actuator — Performs two attacks each action.', 'Zephyr Lancer-204', _skill('Umbral Clamp', 'Warcry', -1.0)),
		_unit('Flux Weaver-206', 206, 5, 'Channeler', 3, 4, 5, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', '', _skill('Umbral Clamp', 'Warcry', -1.0)),
		_unit('Flux Weaver-207', 207, 6, 'Channeler', 3, 6, 5, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', 'Flux Weaver-206', _skill('Umbral Clamp', 'Warcry', -1.0)),
		_unit('Zephyr Mender-208', 208, 2, 'Lifebinder', 3, 2, 3, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', '', _skill('Resonant Chorus', 'Aura', -1.0)),
		_unit('Zephyr Mender-209', 209, 3, 'Lifebinder', 3, 3, 5, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', 'Zephyr Mender-208', _skill('Resonant Chorus', 'Aura', -1.0)),
		_unit('Flux Weaver-210', 210, 3, 'Channeler', 3, 4, 2, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', '', _skill('Resonant Chorus', 'Aura', -1.0)),
		_unit('Flux Weaver-211', 211, 4, 'Channeler', 3, 5, 4, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', 'Flux Weaver-210', _skill('Resonant Chorus', 'Aura', -1.0)),
		_unit('Flux Weaver-212', 212, 5, 'Channeler', 3, 6, 5, 1, 3, 'Arc Burst — Adjacent enemies take half of the primary hit.', 'Flux Weaver-211', _skill('Resonant Chorus', 'Aura', -1.0)),
		_unit('Cinder Mender-213', 213, 3, 'Lifebinder', 2, 2, 3, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', '', _skill('Resonant Chorus', 'Aura', -1.0)),
		_unit('Cinder Mender-214', 214, 4, 'Lifebinder', 2, 3, 4, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', 'Cinder Mender-213', _skill('Resonant Chorus', 'Aura', -1.0)),
		_unit('Cinder Mender-215', 215, 5, 'Lifebinder', 2, 4, 5, 1, 2, 'Repair Field — Before moving, restores 2 HP to the most damaged ally.', 'Cinder Mender-214', _skill('Resonant Chorus', 'Aura', -1.0))
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
	var renamed: String = LEGACY_NAME_ALIASES.get(unit_name, unit_name)
	return LegacyContentMigrationScript.canonical_unit_name(renamed)

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
