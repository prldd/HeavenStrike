class_name StoryQuestCatalog
extends RefCounted

# Exact mission appearances from https://chainguardians.com/story-quests.
# A unit must not be added here unless that reference lists it for the mission.
const ADDITIONAL_DROPS := {
	"Street Nurse": [3, 13, 14, 19, 27, 37, 38, 45],
	"Street Matron": [10, 13, 17, 23, 27, 37, 38, 45],
	"Captain Kerryson": [18],
	"Kerryson the Stoic": [18],
	"Garrett Talon": [9, 50],
	"Garrett the Claw": [50],
	"Precision Shooter": [53, 59, 61],
	"Precision Sniper": [53, 59, 61],
	"Greyson the Shifty": [14],
	"LDF Flight Officer": [19, 34, 35, 50, 52, 55, 58],
	"LDF Flight Commander": [15, 34, 35, 50, 52, 55, 58],
	"Apprentice Builder": [11, 12, 14, 17, 23, 32, 37, 46, 48],
	"Rage Brute": [3, 8, 9, 15, 20, 23, 28, 30, 42, 62],
	"Claw Skirmisher": [8, 9, 42, 43, 46, 47, 52],
	"LDF Gunner": [20, 35, 62],
	"Order Pupil": [21, 22, 24, 41, 53],
	"Order Cleric": [21, 22, 24, 53],
	"Order Apostle": [28, 29, 41, 54, 57],
	"Trinity Messenger": [2, 18, 25, 49, 51],
	"Minerva the Brave": [25, 39, 40, 60, 62],
	"Master Builder": [11, 12, 32, 37, 46],
	"Claw Ambusher": [8, 16, 19, 42, 43, 46, 47, 48, 52],
	"LDF Sureshot": [15, 17, 20, 35, 62],
	"Order Scholar": [21, 22, 24, 41, 53],
	"Order Chaplain": [21, 22, 24, 53],
	"Order Missionary": [28, 29, 41, 54, 57],
	"Trinity Herald": [18, 25, 49, 51],
	"Minerva the Lionheart": [25, 39, 40, 60, 62],
	"Talon Scratcher": [4, 7, 43, 51],
	"Talon Slasher": [43, 51],
	"Street Urchin": [23, 27, 38, 44, 60],
	"Street Hoodlum": [13, 14, 27, 38, 44, 60],
	"LDF Crowd Mage": [7, 28, 33, 57, 59, 61],
	"LDF Riot Mage": [28, 33, 57, 59, 61],
	"Claw Chopper": [14, 15, 30, 31, 36, 40, 47, 48],
	"Claw Cleaver": [9, 30, 31, 36, 40, 47],
	"LDF Bowgunner": [15, 20, 33, 42, 56, 58, 59, 61],
	"LDF Bolt Slinger": [20, 33, 42, 56, 58, 59, 61],
	"LDF Swordwielder": [35],
	"LDF Greatsword": [35],
	"Haven Trapper": [10, 26, 32, 39, 40, 44, 49, 60],
	"Haven Huntsman": [10, 23, 26, 32, 39, 40, 44, 49, 60],
	"Macabre Embalmer": [27, 29, 37, 41, 45],
	"Macabre Undertaker": [27, 29, 37, 41, 45],
	"Devout Mage": [21, 22, 24, 56],
	"Devout Warlock": [21, 22, 24, 56],
	"Commune Defender": [38],
	"Commune Captain": [38],
	"LDF Constable": [10, 34, 50, 56, 62],
	"LDF Sergeant": [19, 34, 50, 56, 62],
	"Joe Wonder": [20, 44, 49],
	"Pompous Joe Wonder": [44, 49],
	"Raging Dragon": [36],
	"Blazing Dragon": [36],
	"Royal Yeoman": [16, 33, 55, 58],
	"Royal Beefeater": [33, 55, 58],
	"Rescue Corps": [42, 54],
	"Rescue Paramedic": [42, 54],
	"Claw Minstrel": [8, 9, 12, 13, 26, 30, 31, 36, 43, 45],
	"Claw Rocker": [8, 12, 26, 30, 31, 36, 43, 45, 48],
	"Flame Warden": [11, 47],
	"Flame Dissident": [47]
}

const QUESTS := [
	["Act 1 Mission 1 - Training Day", ["Trinity Rusher", "Trinity Potshot"]],
	["Act 1 Mission 2 - Training Day (2)", ["Chain Initiate", "Rage Spellslinger"]],
	["Act 1 Mission 3 - Cause for Alarm", []],
	["Act 1 Mission 4 - Into the Fire", []],
	["Act 1 Mission 5 - Adele", ["Rage Spellslinger"]],
	["Act 1 Mission 6 - Calendar Girl", ["Chain Initiate"]],
	["Act 1 Mission 7 - The Stranger", []],
	["Act 1 Mission 8 - Scrap Merchants", ["Claw Caster", "Claw Slicer"]],
	["Act 1 Mission 9 - Raider Way", ["Claw Caster", "Claw Slicer"]],
	["Act 1 Mission 10 - Class Dismissed", ["Socialite Fencer", "Pub Bouncer", "Factory Markswoman"]],
	["Act 1 Mission 11 - Base Defence", ["Trinity Rusher", "Chain Initiate", "Trinity Basher", "Claw Slicer"]],
	["Act 1 Mission 12 - Ambush", ["Pub Bouncer", "Claw Slicer", "Factory Markswoman"]],
	["Act 1 Mission 13 - Determination", ["Pub Bouncer", "Claw Caster", "Factory Markswoman"]],
	["Act 1 Mission 14 - Stunt Woman", ["Pub Bouncer", "Claw Caster"]],
	["Act 1 Mission 15 - The Bridge", ["Trinity Potshot", "Rage Spellslinger"]],
	["Act 1 Mission 16 - The Overconfident", ["Trinity Basher", "Claw Slicer", "Factory Markswoman", "Rage Spellslinger"]],
	["Act 1 Mission 17 - Aftermath", ["Socialite Fencer", "Pub Bouncer", "Trinity Basher", "Rage Spellslinger"]],
	["Act 1 Mission 18 - Proving Grounds", ["Socialite Fencer", "Trinity Rusher", "Trinity Potshot", "Trinity Basher"]],
	["Act 1 Mission 19 - Wild Things", ["Trinity Potshot", "Claw Caster", "Claw Slicer"]],
	["Act 1 Mission 20 - Encampment", ["Socialite Fencer", "Trinity Rusher", "Rage Spellslinger"]],
	["Act 1 Mission 21 - Sanctuary: Outside", ["Chain Initiate", "LDF Peacekeeper", "LDF Medic"]],
	["Act 1 Mission 22 - Sanctuary: Inside", ["Chain Initiate", "LDF Peacekeeper", "LDF Medic"]],
	["Act 2 Mission 23 - On A Mission", ["Pub Bouncer", "Rage Spellslinger"]],
	["Act 2 Mission 24 - Showing Off", ["Chain Initiate", "LDF Peacekeeper", "LDF Medic"]],
	["Act 2 Mission 25 - Arena: Heat 1", ["Trinity Rusher", "Trinity Potshot", "Claw Caster", "Trinity Basher"]],
	["Act 2 Mission 26 - Arena: Heat 2", ["Socialite Fencer", "Claw Caster", "Claw Slicer"]],
	["Act 2 Mission 27 - Arena: Quarter Finals", ["Socialite Fencer", "Pub Bouncer", "Factory Markswoman"]],
	["Act 2 Mission 28 - Arena: Semi-Finals", ["Rage Spellslinger", "LDF Medic"]],
	["Act 2 Mission 29 - Hit It, Slash It, Stab It!", ["Chain Initiate", "Factory Markswoman", "LDF Medic"]],
	["Act 2 Mission 30 - Recon, Adele-style", ["Pub Bouncer", "Rage Spellslinger"]],
	["Act 2 Mission 31 - Hidden Dragon", ["Claw Caster", "Claw Slicer", "Rage Spellslinger"]],
	["Act 2 Mission 32 - Peace and Quiet", ["Socialite Fencer", "Pub Bouncer", "Claw Slicer"]],
	["Act 2 Mission 33 - Breakdown", ["Chain Initiate", "LDF Peacekeeper", "LDF Medic"]],
	["Act 2 Mission 34 - Hit and Run", ["Chain Initiate", "LDF Peacekeeper", "LDF Medic"]],
	["Act 2 Mission 35 - Tough Decisions", ["Chain Initiate", "LDF Peacekeeper", "LDF Medic"]],
	["Act 2 Mission 36 - Mission Accomplished", ["Claw Caster", "Claw Slicer", "Rage Spellslinger"]],
	["Act 2 Mission 37 - A Heroes' Welcome", ["Pub Bouncer", "Claw Caster", "Factory Markswoman"]],
	["Act 2 Mission 38 - Left Behind", ["Pub Bouncer", "Claw Slicer", "Factory Markswoman"]],
	["Act 2 Mission 39 - Fallen for You", ["Socialite Fencer", "Trinity Rusher", "Trinity Potshot", "Trinity Basher"]],
	["Act 2 Mission 40 - Quiet, Please", ["Socialite Fencer", "Claw Caster", "Claw Slicer"]],
	["Act 2 Mission 41 - The Bookworm", ["Trinity Rusher", "Trinity Potshot", "Chain Initiate"]],
	["Act 2 Mission 42 - Stranger's Tide", ["LDF Peacekeeper", "LDF Medic"]],
	["Act 2 Mission 43 - Claw Hammered", ["Claw Caster", "Claw Slicer", "Rage Spellslinger"]],
	["Act 2 Mission 44 - Unfinished Business", ["Socialite Fencer", "Pub Bouncer", "Factory Markswoman"]],
	["Act 2 Mission 45 - Cores for Concern", ["Pub Bouncer", "Claw Caster", "Claw Slicer"]],
	["Act 2 Mission 46 - Party Crashers", ["Claw Caster", "Claw Slicer"]],
	["Act 2 Mission 47 - Brute Force", ["Claw Caster", "Claw Slicer"]],
	["Act 2 Mission 48 - What Lies Beneath", ["Claw Caster", "Claw Slicer"]],
	["Act 2 Mission 49 - Worlds Collide", ["Socialite Fencer", "Trinity Rusher", "Trinity Potshot"]],
	["Act 2 Mission 50 - Leap of Faith", ["Chain Initiate", "LDF Peacekeeper", "LDF Medic"]],
	["Act 2 Mission 51 - Separation Anxiety", ["Socialite Fencer", "Claw Caster", "Trinity Basher", "Claw Slicer"]],
	["Act 2 Mission 52 - Three's A Crowd", ["Pub Bouncer", "Claw Caster", "Factory Markswoman"]],
	["Act 2 Mission 53 - Breaking Point", ["Chain Initiate", "LDF Peacekeeper", "LDF Medic"]],
	["Act 2 Mission 54 - Breakout", ["Chain Initiate", "LDF Peacekeeper", "LDF Medic"]],
	["Act 2 Mission 55 - No Holding Back", ["Chain Initiate", "LDF Peacekeeper", "LDF Medic"]],
	["Act 2 Mission 56 - One By One", ["Chain Initiate", "LDF Peacekeeper", "LDF Medic"]],
	["Act 2 Mission 57 - Rhetorical Question", ["Chain Initiate", "LDF Peacekeeper", "LDF Medic"]],
	["Act 2 Mission 58 - West Enders", ["Chain Initiate", "LDF Peacekeeper", "LDF Medic"]],
	["Act 2 Mission 59 - From Afar", ["Chain Initiate", "LDF Peacekeeper", "LDF Medic"]],
	["Act 2 Mission 60 - Away Game", ["Socialite Fencer", "Pub Bouncer", "Factory Markswoman"]],
	["Act 2 Mission 61 - The Path", ["Chain Initiate", "LDF Peacekeeper", "LDF Medic"]],
	["Act 2 Mission 62 - The Showdown", ["LDF Peacekeeper", "Rage Spellslinger"]]
]

const SKILLS := [
	"Aid", "Shield", "Bloodlust", "Rally",
	"Lightning Burst", "Healing Wave", "Firestorm", "Last Stand"
]

# Authored story text per mission number (1-based), following
# documentation/Resonance_War_Campaign_Narrative.md. Missions without an entry
# fall back to the generated placeholder text below. Briefings state the
# practical problem (the player's frame); debriefings state the political
# consequence (Cassian's frame). Season One covers missions 1-22.
const MISSION_STORIES := {
	# Chapter 1 — The Salvage
	1: {
		"chapter": "The Salvage",
		"briefing": "The expedition's first recovered automatons are powered and responsive. Run a field exercise at the relay site perimeter and confirm they can hold a formation.",
		"debriefing": "The machines performed better than their salvage tags suggested. Cassian logs the result and quietly orders the site sealed to non-expedition personnel."
	},
	2: {
		"chapter": "The Salvage",
		"briefing": "Two more reclaimed units have come online. Run a second exercise and test your command link under pressure before tomorrow's power-up test.",
		"debriefing": "The link held. Cassian notes your name in the margin of his ledger, next to a word neither of you has said aloud yet: Conductor."
	},
	3: {
		"chapter": "The Salvage",
		"briefing": "The relay synchronized on its own during the power-up test and the gallery is coming down. Fight through the waking security routines and get the crew out.",
		"debriefing": "Officially: an industrial accident, no survivors' statements required. Unofficially, you should be dead — and the machines now move when you think."
	},
	4: {
		"chapter": "The Salvage",
		"briefing": "Fire is spreading through the lower galleries and Cassian is trapped behind the security line. Cut through and bring him back.",
		"debriefing": "Cassian owes you his life and knows exactly what such debts are worth. The expedition's patrons declare the site closed and the incident concluded. It is neither."
	},
	# Chapter 2 — The Aftermath
	5: {
		"chapter": "The Aftermath",
		"briefing": "A salvage-rights assessor named Adele Voss is on site when looters breach the perimeter. Protect the assessment crew and the recovered stock.",
		"debriefing": "Adele watched you conduct and wrote it down. Her report is accurate, unflattering to the patrons, and suddenly very popular in five capitals."
	},
	6: {
		"chapter": "The Aftermath",
		"briefing": "The patrons want a demonstration of 'perfectly safe reclaimed machinery' for the press. Keep the crowd safe when the demonstration inevitably goes wrong.",
		"debriefing": "The photographs were supposed to bury the accident. Instead they made you famous. Cassian starts receiving invitations addressed to 'the Conductor's people'."
	},
	7: {
		"chapter": "The Aftermath",
		"briefing": "A stranger corners you after the demonstration: the relay activation was arranged, and the arrangers will want their property back. Then armed crews arrive to discuss it.",
		"debriefing": "The stranger vanished before the questions started. Whoever sent those crews knew the site's security routines — and knew you survived."
	},
	8: {
		"chapter": "The Aftermath",
		"briefing": "A scavenger consortium has produced paperwork contesting the expedition's salvage claim, and muscle to enforce it. Hold the stockyard.",
		"debriefing": "Their paperwork was forged well enough to be expensive. Someone is paying professionals to separate you from what you dug up."
	},
	9: {
		"chapter": "The Aftermath",
		"briefing": "Raiders are shadowing the convoy moving the reclaimed tech to the new depot. See it through.",
		"debriefing": "The convoy arrived intact. Cassian negotiates passage rights with the very clans suspected of the raid — the first time you watch him spend a victory."
	},
	# Chapter 3 — Claims
	10: {
		"chapter": "Claims",
		"briefing": "Registration law requires a certified evaluation of new Conductors. The examiners have brought 'calibration opposition'. Pass their test without breaking anything expensive.",
		"debriefing": "You are now a registered strategic asset in five government ledgers. The examiners' scores reached their patrons before you left the room."
	},
	11: {
		"chapter": "Claims",
		"briefing": "Armed investigators have decided the depot itself is evidence and brought an escort to collect it. Defend the base.",
		"debriefing": "You won, and the inquiry transcript now describes a 'dangerous armed compound resisting lawful inspection'. Cassian starts keeping two sets of records."
	},
	12: {
		"chapter": "Claims",
		"briefing": "A supply run is hit by raiders who fight like regulars. Break the ambush and bring back something that identifies them.",
		"debriefing": "Contractor gear, serials burned. Cassian locks the evidence in his personal strongbox — your first lesson in the difference between truth and leverage."
	},
	13: {
		"chapter": "Claims",
		"briefing": "Three envoys, three offers, three refusals. The fourth answer arrives as a 'safety inspection' with an armed escort.",
		"debriefing": "You declined them all. Cassian sends each envoy a courteous note, keeping open every door you just closed. Meanwhile the oldest machines have begun keeping their own routines."
	},
	14: {
		"chapter": "Claims",
		"briefing": "Adele's informant will talk if her crew can extract him from under his handlers' noses. Cover the extraction.",
		"debriefing": "His testimony proves the ambush was staged — and is legally worthless. Adele is furious. Cassian files it under 'useful, later'."
	},
	# Chapter 4 — The Proving
	15: {
		"chapter": "The Proving",
		"briefing": "The old transit bridge is failing under evacuation load. Hold the crossing against the debris field and panicked security drones until the last civilian is across.",
		"debriefing": "Hundreds walked away because your squad stood where the bridge was weakest. For the first time, the crowds know your name for the right reason."
	},
	16: {
		"chapter": "The Proving",
		"briefing": "A guild champion has challenged the 'salvage Conductor' to a public bout, intending to end your reputation. Accept, and win.",
		"debriefing": "You humiliated a proud house in front of its peers. Cassian sells the footage to three networks and books the grudge as an asset, not a liability."
	},
	17: {
		"chapter": "The Proving",
		"briefing": "Hearings into the bridge and the bout have drawn agitators into the streets around the inquiry hall. Keep the proceedings from turning into a riot.",
		"debriefing": "Your testimony was entered, edited, and read aloud by people who were not there. The record now says what the record needed to say."
	},
	18: {
		"chapter": "The Proving",
		"briefing": "A formal evaluation of Conductor limits, run by an officer famous for fairness. Demonstrate your squad's full capability — then survive the demonstration.",
		"debriefing": "The evaluator's report is the first honest document about you in any government file. It also lists, clinically, what conducting is doing to your body."
	},
	19: {
		"chapter": "The Proving",
		"briefing": "Conductor-less automatons running on old habits are menacing a township. Protect the people — even if it means destroying machines you would rather save.",
		"debriefing": "You chose the township over the salvage. One of the ferals refused to leave afterward; Cassian pretends not to notice the extra mouth at the depot."
	},
	20: {
		"chapter": "The Proving",
		"briefing": "The displaced township is camped by the depot, and someone is using the refugees as cover for a probe at your stock. Defend the camp.",
		"debriefing": "The refugees have a folk hero and the depot has a neighborhood. Cassian begins drafting something he calls a charter."
	},
	# Chapter 5 — Sanctuary
	21: {
		"chapter": "Sanctuary",
		"briefing": "The stranger's coordinates lead to a pre-collapse sanctuary installation. Order archivists hold the perimeter and grant access to no one. Persuade them.",
		"debriefing": "The Order's scholars agreed to share the site — after you demonstrated you could have taken it. The archivist in charge has not stopped watching your machines."
	},
	22: {
		"chapter": "Sanctuary",
		"briefing": "The sanctuary's inner vault is guarded by custodial routines older than any living nation. Reach the records.",
		"debriefing": "The maintenance logs run centuries past the Empire's 'fall'. The Empire did not collapse — it dismantled itself. And one unredacted manifest lists a destination: Caelis."
	}
}

# Authored eight-card decks, indexed by mission. Multi-battle missions keep
# their mission's identity while Captain HP and skill change per encounter.
# These are deliberately explicit: reward pools do not silently alter enemies.
const MISSION_ENEMY_SQUADS := [
	# Act 1
	["Trinity Rusher", "Trinity Potshot", "Trinity Basher", "Chain Initiate", "Pub Bouncer", "LDF Peacekeeper", "Rage Spellslinger", "Socialite Fencer"],
	["Chain Initiate", "Rage Spellslinger", "Pub Bouncer", "Trinity Rusher", "Trinity Potshot", "LDF Peacekeeper", "Claw Slicer", "Factory Markswoman"],
	["Rage Brute", "Pub Bouncer", "Rage Spellslinger", "Trinity Basher", "Street Nurse", "Trinity Potshot", "Claw Caster", "LDF Peacekeeper"],
	["Talon Scratcher", "Claw Slicer", "Claw Caster", "Rage Brute", "Pub Bouncer", "Factory Markswoman", "Chain Initiate", "Trinity Rusher"],
	["Rage Spellslinger", "Rage Brute", "Pub Bouncer", "Trinity Basher", "Claw Caster", "Chain Initiate", "Factory Markswoman", "LDF Peacekeeper"],
	["Chain Initiate", "Socialite Fencer", "Trinity Rusher", "Trinity Potshot", "Pub Bouncer", "LDF Medic", "Claw Slicer", "Rage Spellslinger"],
	["Talon Scratcher", "LDF Crowd Mage", "Street Urchin", "Chain Initiate", "Claw Slicer", "Pub Bouncer", "Trinity Potshot", "Socialite Fencer"],
	["Claw Caster", "Claw Slicer", "Claw Skirmisher", "Claw Ambusher", "Rage Brute", "Pub Bouncer", "Factory Markswoman", "Chain Initiate"],
	["Claw Slicer", "Claw Caster", "Claw Skirmisher", "Garrett Talon", "Rage Brute", "Trinity Potshot", "LDF Peacekeeper", "Chain Initiate"],
	["Socialite Fencer", "Pub Bouncer", "Factory Markswoman", "Street Matron", "Rage Spellslinger", "Chain Initiate", "Trinity Rusher", "Claw Caster"],
	["Trinity Rusher", "Chain Initiate", "Trinity Basher", "Claw Slicer", "Apprentice Builder", "Master Builder", "Trinity Potshot", "LDF Medic"],
	["Pub Bouncer", "Claw Slicer", "Factory Markswoman", "Claw Ambusher", "Street Urchin", "Rage Spellslinger", "Chain Initiate", "Socialite Fencer"],
	["Pub Bouncer", "Claw Caster", "Factory Markswoman", "Street Hoodlum", "Rage Brute", "Chain Initiate", "LDF Peacekeeper", "Trinity Potshot"],
	["Pub Bouncer", "Claw Caster", "Greyson the Shifty", "Street Hoodlum", "Socialite Fencer", "Factory Markswoman", "Chain Initiate", "Rage Spellslinger"],
	["Trinity Potshot", "Rage Spellslinger", "LDF Flight Commander", "Factory Markswoman", "Pub Bouncer", "LDF Peacekeeper", "Chain Initiate", "Claw Slicer"],
	["Trinity Basher", "Claw Slicer", "Factory Markswoman", "Rage Spellslinger", "Claw Skirmisher", "Rage Brute", "Socialite Fencer", "Chain Initiate"],
	["Socialite Fencer", "Pub Bouncer", "Trinity Basher", "Rage Spellslinger", "Rage Bruiser", "Factory Markswoman", "LDF Medic", "Trinity Rusher"],
	["Socialite Fencer", "Trinity Rusher", "Trinity Potshot", "Trinity Basher", "Trinity Messenger", "Captain Kerryson", "Kerryson the Stoic", "LDF Peacekeeper"],
	["Trinity Potshot", "Claw Caster", "Claw Slicer", "LDF Flight Officer", "Talon Scratcher", "Pub Bouncer", "Chain Initiate", "Factory Markswoman"],
	["Socialite Fencer", "Trinity Rusher", "Rage Spellslinger", "Rage Brute", "Trinity Potshot", "Chain Initiate", "LDF Peacekeeper", "Pub Bouncer"],
	["Chain Initiate", "LDF Peacekeeper", "LDF Medic", "LDF Gunner", "LDF Crowd Mage", "Trinity Rusher", "Pub Bouncer", "Factory Markswoman"],
	["Chain Initiate", "LDF Peacekeeper", "LDF Medic", "LDF Sureshot", "LDF Crowd Mage", "Apprentice Builder", "Order Pupil", "Trinity Basher"],
	# Act 2
	["Pub Bouncer", "Rage Spellslinger", "Rage Brute", "Street Urchin", "Claw Slicer", "Factory Markswoman", "Chain Initiate", "Socialite Fencer"],
	["Chain Initiate", "LDF Peacekeeper", "LDF Medic", "LDF Gunner", "Order Pupil", "Order Cleric", "Apprentice Builder", "Trinity Rusher"],
	["Trinity Rusher", "Trinity Potshot", "Claw Caster", "Trinity Basher", "Claw Skirmisher", "Pub Bouncer", "Socialite Fencer", "Chain Initiate"],
	["Socialite Fencer", "Claw Caster", "Claw Slicer", "Claw Skirmisher", "Factory Markswoman", "Pub Bouncer", "Chain Initiate", "Rage Brute"],
	["Socialite Fencer", "Pub Bouncer", "Factory Markswoman", "Street Hoodlum", "LDF Gunner", "Chain Initiate", "Rage Spellslinger", "Trinity Rusher"],
	["Rage Spellslinger", "LDF Medic", "Order Pupil", "Order Cleric", "Rage Brute", "LDF Peacekeeper", "Factory Markswoman", "Claw Slicer"],
	["Chain Initiate", "Factory Markswoman", "LDF Medic", "LDF Gunner", "Order Apostle", "Pub Bouncer", "Socialite Fencer", "Claw Skirmisher"],
	["Pub Bouncer", "Rage Spellslinger", "Rage Brute", "Rage Bruiser", "Street Urchin", "Trinity Potshot", "Chain Initiate", "Claw Caster"],
	["Claw Caster", "Claw Slicer", "Rage Spellslinger", "Claw Skirmisher", "Claw Ambusher", "Talon Scratcher", "Pub Bouncer", "Chain Initiate"],
	["Socialite Fencer", "Pub Bouncer", "Claw Slicer", "Street Hoodlum", "Factory Markswoman", "Rage Brute", "Chain Initiate", "LDF Peacekeeper"],
	["Chain Initiate", "LDF Peacekeeper", "LDF Medic", "Apprentice Builder", "LDF Gunner", "LDF Crowd Mage", "Order Cleric", "Trinity Rusher"],
	["Chain Initiate", "LDF Peacekeeper", "LDF Medic", "LDF Gunner", "LDF Sureshot", "Trinity Rusher", "Trinity Potshot", "Socialite Fencer"],
	["Chain Initiate", "LDF Peacekeeper", "LDF Medic", "Master Builder", "LDF Crowd Mage", "Order Pupil", "Order Cleric", "Rage Brute"],
	["Claw Caster", "Claw Slicer", "Rage Spellslinger", "Claw Ambusher", "Rage Bruiser", "Talon Scratcher", "Factory Markswoman", "Chain Initiate"],
	["Pub Bouncer", "Claw Caster", "Factory Markswoman", "Street Urchin", "Street Hoodlum", "Rage Brute", "Chain Initiate", "Socialite Fencer"],
	["Pub Bouncer", "Claw Slicer", "Factory Markswoman", "Claw Skirmisher", "Claw Ambusher", "LDF Gunner", "Chain Initiate", "Rage Spellslinger"],
	["Socialite Fencer", "Trinity Rusher", "Trinity Potshot", "Trinity Basher", "Trinity Messenger", "Trinity Herald", "Chain Initiate", "LDF Medic"],
	["Socialite Fencer", "Claw Caster", "Claw Slicer", "Claw Ambusher", "Talon Scratcher", "Factory Markswoman", "Chain Initiate", "Pub Bouncer"],
	["Trinity Rusher", "Trinity Potshot", "Chain Initiate", "Order Pupil", "Order Cleric", "Order Apostle", "Apprentice Builder", "Socialite Fencer"],
	["LDF Peacekeeper", "LDF Medic", "LDF Gunner", "LDF Crowd Mage", "Chain Initiate", "Apprentice Builder", "Factory Markswoman", "Trinity Basher"],
	["Claw Caster", "Claw Slicer", "Rage Spellslinger", "Claw Ambusher", "Rage Bruiser", "Talon Slasher", "Factory Markswoman", "Chain Initiate"],
	["Socialite Fencer", "Pub Bouncer", "Factory Markswoman", "Street Hoodlum", "Rage Bruiser", "LDF Sureshot", "Chain Initiate", "Claw Caster"],
	["Pub Bouncer", "Claw Caster", "Claw Slicer", "Street Urchin", "Street Hoodlum", "Blight Doctor", "Blight Physician", "Factory Markswoman"],
	["Claw Caster", "Claw Slicer", "Claw Skirmisher", "Claw Ambusher", "Talon Scratcher", "Talon Slasher", "Rage Brute", "Chain Initiate"],
	["Claw Caster", "Claw Slicer", "Rage Brute", "Rage Bruiser", "Claw Ambusher", "Talon Scratcher", "Factory Markswoman", "LDF Medic"],
	["Claw Caster", "Claw Slicer", "Garrett Talon", "Garrett the Claw", "Street Hoodlum", "Fortune Teller", "Rage Bruiser", "LDF Sureshot"],
	["Socialite Fencer", "Trinity Rusher", "Trinity Potshot", "Trinity Messenger", "Trinity Herald", "Minerva the Brave", "Chain Initiate", "Pub Bouncer"],
	["Chain Initiate", "LDF Peacekeeper", "LDF Medic", "Order Pupil", "Order Cleric", "Order Apostle", "Apprentice Builder", "LDF Gunner"],
	["Socialite Fencer", "Claw Caster", "Trinity Basher", "Claw Slicer", "Claw Ambusher", "Talon Scratcher", "Street Hoodlum", "Chain Initiate"],
	["Pub Bouncer", "Claw Caster", "Factory Markswoman", "Street Hoodlum", "LDF Crowd Mage", "Fortune Teller", "Rage Bruiser", "Chain Initiate"],
	["Chain Initiate", "LDF Peacekeeper", "LDF Medic", "Order Pupil", "Order Cleric", "Precision Shooter", "Precision Sniper", "Apprentice Builder"],
	["Chain Initiate", "LDF Peacekeeper", "LDF Medic", "LDF Gunner", "LDF Crowd Mage", "LDF Riot Mage", "Master Builder", "Order Chaplain"],
	["Chain Initiate", "LDF Peacekeeper", "LDF Medic", "Order Apostle", "Order Missionary", "Order Scholar", "Order Chaplain", "Master Builder"],
	["Chain Initiate", "LDF Peacekeeper", "LDF Medic", "LDF Sureshot", "Precision Shooter", "Precision Sniper", "Master Builder", "Order Missionary"],
	["Chain Initiate", "LDF Peacekeeper", "LDF Medic", "Order Scholar", "Order Chaplain", "Order Missionary", "Minerva the Lionheart", "Master Builder"],
	["Chain Initiate", "LDF Peacekeeper", "LDF Medic", "LDF Sureshot", "Precision Shooter", "Precision Sniper", "Minerva the Brave", "Master Builder"],
	["Chain Initiate", "LDF Peacekeeper", "LDF Medic", "LDF Sureshot", "LDF Riot Mage", "Fortune Diviner", "Order Chaplain", "Master Builder"],
	["Socialite Fencer", "Pub Bouncer", "Factory Markswoman", "Street Hoodlum", "Fortune Teller", "LDF Riot Mage", "Rage Bruiser", "Claw Ambusher"],
	["Chain Initiate", "LDF Peacekeeper", "LDF Medic", "Order Scholar", "Order Chaplain", "Order Missionary", "Minerva the Lionheart", "Farsight Naruku"],
	["LDF Peacekeeper", "Rage Spellslinger", "Master Builder", "Rage Bruiser", "LDF Sureshot", "Order Missionary", "Trinity Herald", "Minerva the Lionheart"]
]

static func build_missions() -> Array:
	var missions: Array = []
	for index in QUESTS.size():
		var quest: Array = QUESTS[index]
		var reference_pool: Array = quest[1].duplicate()
		for unit_name in ADDITIONAL_DROPS:
			if index + 1 in ADDITIONAL_DROPS[unit_name]:
				reference_pool.append(unit_name)
		var reward_pool: Array = reference_pool
		var enemy_hp := mini(20, 8 + int(index / 4))
		var battle_count := 1 if index < 10 else (2 if index < 30 else 3)
		var encounters: Array = []
		var short_title: String = quest[0].split(" - ", true, 1)[-1]
		var act := 1 if index < 22 else 2
		var act_mission := index + 1 if act == 1 else index - 21
		var story: Dictionary = MISSION_STORIES.get(index + 1, {})
		for battle_index in battle_count:
			var hp := maxi(8, enemy_hp - (battle_count - battle_index - 1) * 2)
			encounters.append({
				"title": short_title if battle_index == battle_count - 1 else "%s · Approach %d" % [short_title, battle_index + 1],
				"enemy_hp": hp,
				"skill": SKILLS[(index + battle_index) % SKILLS.size()],
				"enemy_squad": _enemy_squad_for(index)
			})
		missions.append({
			"id": index,
			"act": act,
			"act_mission": act_mission,
			"title": quest[0],
			"short_title": short_title,
			"chapter": story.get("chapter", ""),
			"briefing": story.get("briefing", _mission_briefing(index, short_title)),
			"debriefing": story.get("debriefing", _mission_debriefing(index, short_title)),
			"enemy_hp": enemy_hp,
			"encounters": encounters,
			"reward_pool": reward_pool
		})
	return missions

# Placeholder generator for missions not yet covered by MISSION_STORIES.
static func _mission_briefing(index: int, title: String) -> String:
	var objectives := [
		"Secure the approach before the opposing captain can reinforce it.",
		"Break the opposing formation and keep the route open.",
		"Read the enemy lanes carefully; their squad is prepared for an ambush.",
		"Protect the expedition while pushing through the hostile line."
	]
	return "Operation %s. %s" % [title, objectives[index % objectives.size()]]

static func _mission_debriefing(index: int, title: String) -> String:
	var outcomes := [
		"The route is secure and the expedition can advance.",
		"Enemy resistance has broken; new intelligence points farther ahead.",
		"The captured position reveals another piece of the larger picture.",
		"Your squad holds the field while the coalition prepares the next operation."
	]
	return "%s complete. %s" % [title, outcomes[index % outcomes.size()]]

static func _enemy_squad_for(mission_index: int) -> Array:
	if mission_index < 0 or mission_index >= MISSION_ENEMY_SQUADS.size():
		return []
	return MISSION_ENEMY_SQUADS[mission_index].duplicate()
