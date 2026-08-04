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
	["Act 2 Mission 62 - The Showdown", ["LDF Peacekeeper", "Rage Spellslinger"]],
	# Season Three (Act 3) — original content, not ported from the reference;
	# reward pools use REWARD_UNITS that previously had no story drops.
	["Act 3 Mission 63 - The Gate Opens", ["The Rook", "Sterling Knight"]],
	["Act 3 Mission 64 - Still Running", ["White Mage", "White Wizard"]],
	["Act 3 Mission 65 - The Wardens' Test", ["Gawain the Just", "Sir Gawain"]],
	["Act 3 Mission 66 - The True History", ["The Archaeologist", "The Castaway"]],
	["Act 3 Mission 67 - Five Fragments", ["The Botanist", "The Ecologist", "The Biologist"]],
	["Act 3 Mission 68 - What Was Sealed", ["Fabulous Bors", "Sir Bors"]],
	["Act 3 Mission 69 - The First Conductors", ["Oro the Pilgrim", "Oro the Enlightened"]],
	["Act 3 Mission 70 - The Experiment", ["Van Hohenheim", "The Sorcerer's Stone"]],
	["Act 3 Mission 71 - Succession", ["Clair", "Awoken Clair"]],
	["Act 3 Mission 72 - The Petition", ["Cara Pace", "Clawing Cara"]],
	["Act 3 Mission 73 - Old Habits", ["José", "José Decomposé"]],
	["Act 3 Mission 74 - The Architect", ["Selina the Stylist", "Selina Twinblade"]],
	["Act 3 Mission 75 - The Balancing Network", ["Hamish Highlander", "Hamish Lochmaster"]],
	["Act 3 Mission 76 - The Resonance War", ["Furia Rojo", "Campeon Rojo"]],
	["Act 3 Mission 77 - Accord", ["Sakura", "Blossom Sakura", "Inti Chihuan", "Shining Inti"]]
]

const SKILLS := [
	"Aid", "Shield", "Bloodlust", "Rally",
	"Lightning Burst", "Healing Wave", "Firestorm", "Last Stand"
]

# Authored story text per mission number (1-based), following
# documentation/Resonance_War_Campaign_Narrative.md. Missions without an entry
# fall back to the generated placeholder text below. Briefings state the
# practical problem (the player's frame); debriefings state the political
# consequence (Cassian's frame). Season One covers missions 1-22, Season Two
# covers missions 23-62.
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
	},
	# Chapter 6 — The Arena
	23: {
		"chapter": "The Arena",
		"briefing": "The reclamation charter's first contract: escort Order scholars through contested territory that neither side will police. See them through.",
		"debriefing": "The scholars arrived intact and the charter survived its first test. Cassian notes which faction looked the other way — and what that courtesy will cost."
	},
	24: {
		"chapter": "The Arena",
		"briefing": "Every faction wants the Conductor at its exhibition this week. Attend the demonstration circuit, and expect the 'demonstrations' to turn earnest.",
		"debriefing": "Five offers, all declined by itinerary. Cassian plays the bids against each other while you learn what an auction looks like from inside the lot."
	},
	25: {
		"chapter": "The Arena",
		"briefing": "The Grand Circuit settles faction disputes by proxy champion, and a seat at the charter talks costs a title. Win your heat. The reigning champion's name is Minerva.",
		"debriefing": "The crowd has a new favorite and the bookmakers have a new problem. Cassian opens a line of credit in the champions' boxes."
	},
	26: {
		"chapter": "The Arena",
		"briefing": "The second heat pairs you against a crowd darling. The arena is a legislature with better catering — win the bout and read the boxes while you do.",
		"debriefing": "Two factions applauded your victory for opposite reasons. Both are wrong about what you want."
	},
	27: {
		"chapter": "The Arena",
		"briefing": "Quarter finals. Your opponent's patron was offered a fortune for a forfeit this morning; expect the bout to be honest and everything around it not to be.",
		"debriefing": "You won without touching the bribe. Cassian made sure the right people learned it was offered."
	},
	28: {
		"chapter": "The Arena",
		"briefing": "Your semi-final opponent has been ordered to throw the match as a 'gift'. Refuse the fix the only way available: win anyway.",
		"debriefing": "A thrown match would have owned you. An honest win owes no one. Cassian approves; the fixers adjust their estimates."
	},
	29: {
		"chapter": "The Arena",
		"briefing": "The final. Win the title and the charter takes its seat.",
		"debriefing": "Champion. Cassian converts the title into formal recognition of the reclamation charter before the confetti settles. The factions now share a problem: the technician will not stay bought."
	},
	# Chapter 7 — Fault Lines
	30: {
		"chapter": "Fault Lines",
		"briefing": "Adele has a lead on the border incident: the 'raiders' from the depot days were deniable contractors. Escort her in and bring back proof.",
		"debriefing": "Pay chits, no signatures — by design. But the contracting house carries a guild seal, and Adele recognizes it. She used to work for them."
	},
	31: {
		"chapter": "Fault Lines",
		"briefing": "A dormant Caelian war-engine has woken beneath a Wind city. Five factions are blaming each other; the machine is not waiting for a verdict. Disable it.",
		"debriefing": "The city stands. Each faction claims its doctrine would have prevented the awakening, and each is quietly recalibrating its own buried machines."
	},
	32: {
		"chapter": "Fault Lines",
		"briefing": "Cassian's ceasefire summit convenes under your security. Someone does not want it to conclude.",
		"debriefing": "The bomb killed the talks and nearly the delegates. Every faction's hardliners profited; none claimed it. The coalition survives its first funeral."
	},
	33: {
		"chapter": "Fault Lines",
		"briefing": "Infrastructure is failing in cascade across two territories. Triage the grid and keep the hospitals lit.",
		"debriefing": "The Source fragments are degrading in sympathy, and the official reports call it weather. You fix what you can reach; Cassian catalogs who prevented the rest."
	},
	34: {
		"chapter": "Fault Lines",
		"briefing": "Retaliatory strikes are trading across the border, and one is aimed at a civilian district. Intercept it.",
		"debriefing": "You saved the district and were denounced by both sides for interfering. The civilians, notably, denounced no one."
	},
	35: {
		"chapter": "Fault Lines",
		"briefing": "One repair crew, two dying grids, no time for both. Choose which district lives through the winter.",
		"debriefing": "Whichever you saved, the other district's grief now has a flag. There was no right answer; there was only an answer. Cassian made sure it was yours and not his."
	},
	36: {
		"chapter": "Fault Lines",
		"briefing": "Faction leaders will declare the crisis resolved tonight. Provide security for the announcement — and try not to listen to it.",
		"debriefing": "The grid is still failing and everyone at the podium knew it. Cassian, quietly: 'Institutions lie to survive. Remember who taught you that.'"
	},
	# Chapter 8 — Heroes and Costs
	37: {
		"chapter": "Heroes and Costs",
		"briefing": "The township you saved is throwing a welcome, and an old caretaker claims to know one of your machines. Expect the celebration to attract trouble.",
		"debriefing": "She knew the machine's first Conductor by name, sixty years dead. It stood at attention for her. You did not order that."
	},
	38: {
		"chapter": "Heroes and Costs",
		"briefing": "A commune refuses evacuation from degrading territory and will fight the relocation teams. Stand between them and the eviction.",
		"debriefing": "You protected people from a rescue they never asked for. The coalition's lawyers are still deciding whether that was heroic or criminal. The commune has decided."
	},
	39: {
		"chapter": "Heroes and Costs",
		"briefing": "A raid on the depot convoy. Get the squad out — all of the squad.",
		"debriefing": "One of the oldest machines fell covering the retreat. Its echo is still in the link. The squad carries it, and so do you."
	},
	40: {
		"chapter": "Heroes and Costs",
		"briefing": "No speeches, no politics. The squad goes back for their own. Bring the chassis home.",
		"debriefing": "Recovered. What was lost cannot be restored — but what remains is yours, and the machines know you came back."
	},
	41: {
		"chapter": "Heroes and Costs",
		"briefing": "The Sanctuary archivist has decoded the Caelian logistics records and will deliver them only in person. Get her through the interested parties.",
		"debriefing": "Caelis was not destroyed. It was removed from the maps — deliberately, by everyone, at once. Every faction's founding myth just became a lie of omission."
	},
	42: {
		"chapter": "Heroes and Costs",
		"briefing": "The Stranger resurfaces with proof that the relay activation was arranged — and the trail runs through the coalition's own patron chain. Protect the handoff.",
		"debriefing": "Someone you have dined with arranged your accident. Cassian reads the evidence twice and says nothing for a long time."
	},
	43: {
		"chapter": "Heroes and Costs",
		"briefing": "The scavenger clans are being squeezed into picking a side. They respect one currency. Pay it on the field, then buy their neutrality with the winnings.",
		"debriefing": "The clans stay neutral, which makes the factions' deniable muscle suddenly expensive. Garrett sends his regards and an itemized invoice."
	},
	44: {
		"chapter": "Heroes and Costs",
		"briefing": "Adele confronts her old guild over the contractor pay chits. Stand with her in a room where everyone is armed and nothing is admitted.",
		"debriefing": "The guild factor smiled and produced paperwork older than the war. The trail points up, not back. Adele resigns loudly; Cassian hires her quietly."
	},
	# Chapter 9 — Cores
	45: {
		"chapter": "Cores",
		"briefing": "All five factions are quietly weaponizing Source-cores. Seize the unsecured one before it enters play.",
		"debriefing": "You now hold what every faction wants, which makes you a power — exactly as Cassian warned. The core hums in its vault like a held breath."
	},
	46: {
		"chapter": "Cores",
		"briefing": "Unity Day. Extremists who want the open war the moderates keep postponing have picked the celebration as their stage. Keep the peace.",
		"debriefing": "The coalition held — barely, publicly, at cost. The extremists lost the battle and won the argument: everyone is now afraid."
	},
	47: {
		"chapter": "Cores",
		"briefing": "A hardliner wing has decided to settle the argument by force tonight. Break the coup before it reaches the council chambers.",
		"debriefing": "The coup is broken. The moderates who quietly approved of it are already at Cassian's table, and he is already seating them."
	},
	48: {
		"chapter": "Cores",
		"briefing": "The battlefield sits over a buried Caelian transit line — still powered, still maintained. Clear the surface and see where it points.",
		"debriefing": "It points somewhere no map admits exists. The maintenance is recent. Something down there is still on duty."
	},
	49: {
		"chapter": "Cores",
		"briefing": "Three factions, one field, no valid target but each other. You cannot win this battle; you can only keep the civilians out of it.",
		"debriefing": "The war everyone feared has begun. History will record that you lost the field and saved the town. Cassian will make sure of it."
	},
	50: {
		"chapter": "Cores",
		"briefing": "Cassian stakes the coalition on an unpopular truce. Hold the line beside former enemies while it is signed.",
		"debriefing": "The truce holds because enemies enforced it together. Garrett the Claw kept his sector quieter than you kept yours, and neither of you mentions it."
	},
	51: {
		"chapter": "Cores",
		"briefing": "Your oldest machines are declining certain orders — old resonance scars against new purpose. Take the field and learn what they will still fight for.",
		"debriefing": "They will defend, protect, and stand. They will no longer destroy on command. You must decide what you owe the machines that made you a Conductor."
	},
	52: {
		"chapter": "Cores",
		"briefing": "A three-way negotiation is collapsing. Lose the brawl gracefully — Cassian needs to save the talks, not your pride.",
		"debriefing": "You lost on purpose; Cassian won the room. Walking out, you realize he never asked your permission. He no longer needs it."
	},
	# Chapter 10 — Breaking Point
	53: {
		"chapter": "Breaking Point",
		"briefing": "Source fragments are synchronizing on their own: blackouts, waking machines, networks re-forming. Hold the district through the cascade.",
		"debriefing": "The Order confirms it is not an attack. It is a response. Something has noticed the war."
	},
	54: {
		"chapter": "Breaking Point",
		"briefing": "A detention facility for registered Conductors broke open in the blackouts. Support the rescue crews and keep the freed Conductors alive.",
		"debriefing": "One of them asked you what they are now — asset, prisoner, or person. You had no answer. Cassian starts drafting one."
	},
	55: {
		"chapter": "Breaking Point",
		"briefing": "Full-scale offensive on three fronts. Run interceptions at maximum strain.",
		"debriefing": "The medics have stopped clearing you for the field. You went anyway. The machines have started positioning themselves between you and the fighting."
	},
	56: {
		"chapter": "Breaking Point",
		"briefing": "Coalition delegates are being assassinated one by one. Protect the survivors.",
		"debriefing": "The survivors live because Cassian's information network found the killers first. It is larger than he ever told you. He shows you all of it, unasked."
	},
	57: {
		"chapter": "Breaking Point",
		"briefing": "A public tribunal convenes to answer the only question that matters: who should govern the Source? Keep the chamber alive through every answer.",
		"debriefing": "Violence interrupted every proposal, from every direction. There is no correct side. That was the point of asking."
	},
	58: {
		"chapter": "Breaking Point",
		"briefing": "The fighting reaches the old western districts, built directly over Caelian conduits. A royalist remnant guards the gates below by a charter no one remembers. Negotiate passage their way.",
		"debriefing": "The gatekeepers stood aside for the first authority to ask correctly in two hundred years. Their charter is Caelian. It is still valid."
	},
	59: {
		"chapter": "Breaking Point",
		"briefing": "Long-range batteries are targeting the conduit network itself. Silence the guns.",
		"debriefing": "Every side will rebuild them, and everyone knows it. Tonight the network survives. Repair versus control, at artillery scale."
	},
	60: {
		"chapter": "Breaking Point",
		"briefing": "Minerva leads a joint strike team of former arena rivals — the coalition, armed at last. Fight beside people who tried to buy, beat, and bury you.",
		"debriefing": "She fights the way she lost: honestly. Cassian's coalition has an army now, whatever he calls it."
	},
	61: {
		"chapter": "Breaking Point",
		"briefing": "The conduits converge on a single navigable route. Secure it — and meet whoever has been waiting at its end.",
		"debriefing": "The Stranger steps out of the shadows with a title: Warden of Caelis, sent to bring the accidental Conductor home. It is an invitation. It is also a summons."
	},
	62: {
		"chapter": "Breaking Point",
		"briefing": "Every faction army reaches the gate of Caelis in the same hour. Keep the war from following you inside.",
		"debriefing": "Cassian arrives with a coalition, not an army. The gates open for the first time in living memory. What waits inside has been waiting a very long time."
	},
	# Chapter 11 — The Outer City
	63: {
		"chapter": "The Outer City",
		"briefing": "Caelis sets its entry terms through its wardens: maintenance automatons and hereditary Conductors still executing a thousand-year-old disaster protocol. Submit to inspection.",
		"debriefing": "The wardens inspect you like a malfunction — an unregistered Conductor commanding unsanctioned machines. They let you in anyway. Curiosity, it seems, is also a protocol."
	},
	64: {
		"chapter": "The Outer City",
		"briefing": "The Outer City is immaculate and empty, maintained for citizens who never came back. Its caretakers object to your presence the only way they know.",
		"debriefing": "A civilization kept running by machines out of habit and hope. Your oldest units walk slower here. They recognize the grief."
	},
	65: {
		"chapter": "The Outer City",
		"briefing": "The wardens will not permit an unsanctioned Conductor deeper into the city. Earn passage the Caelian way: prove that conducting is stewardship, not command.",
		"debriefing": "You fought to protect, not to take, and the wardens logged it. The inner gates unlock. Somewhere below, something ancient notes your approach."
	},
	# Chapter 12 — The Imperial Archive
	66: {
		"chapter": "The Imperial Archive",
		"briefing": "The Imperial Archive holds the unedited record. Its custodial security protects the truth from everyone alike — including you.",
		"debriefing": "The Source crisis, the vote to fragment, the burning of the histories. The Empire's last act was a verdict: no single power could be trusted with the whole again."
	},
	67: {
		"chapter": "The Imperial Archive",
		"briefing": "Five reading rooms, five founding myths, each annotated by Caelian archivists. Rival claimants have followed you in, and they want the rooms burned.",
		"debriefing": "Coal's discipline, Steam's industry, Solar's faith, Wind's freedom, Fusion's ambition — each preserved exactly one virtue of the old system and lost the rest. The archive's judgment is kinder than yours."
	},
	68: {
		"chapter": "The Imperial Archive",
		"briefing": "The deepest vault holds what the fragmentation was meant to contain. Its guardians were built to fight Conductors.",
		"debriefing": "You know now what the crisis was, and why the most destabilizing evidence must stay sealed. Cassian reads your face and asks no questions. He will ask later."
	},
	# Chapter 13 — The Conductor Vault
	69: {
		"chapter": "The Conductor Vault",
		"briefing": "The Conductor Vault is not a prison but a hospice: the Empire's first Conductors, and the truth of what the Relay costs. Its keepers will decide whether you may enter.",
		"debriefing": "Your medical future walks and talks here, and is gracious about it. The first Conductors did not command machines. They kept them company."
	},
	70: {
		"chapter": "The Conductor Vault",
		"briefing": "The wardens confess: your relay activation was a Caelian continuity test, arranged through expendable intermediaries. Some of those intermediaries are here, and they are armed.",
		"debriefing": "Your accident was an exam you never applied for, paid for by patrons who never knew their client. The Stranger's debt and Cassian's leverage come due in the same hour."
	},
	71: {
		"chapter": "The Conductor Vault",
		"briefing": "The wardens offer you the Vault's purpose: succeed them as warden of the system. Their honor guard will test whether refusal is even possible.",
		"debriefing": "A genuine offer, honestly meant — and the wrong answer. The world does not need another warden. It needs the system to stop needing one."
	},
	# Chapter 14 — The Civic Core
	72: {
		"chapter": "The Civic Core",
		"briefing": "Caelis petitions to resume stewardship of the Source. Cassian's coalition arrives to answer, and the hardliners answer first. Hold the chambers.",
		"debriefing": "The ideological war is finally the right shape: argued in chambers, not fought over grids. Your job is to keep it that shape a little longer."
	},
	73: {
		"chapter": "The Civic Core",
		"briefing": "Caelian restorationists and faction maximalists make common cause to collapse the talks. Protect a negotiation you are not invited to lead.",
		"debriefing": "The talks survive because the extremes overplayed their hand. You are learning to watch a room the way Cassian watches a ledger."
	},
	74: {
		"chapter": "The Civic Core",
		"briefing": "Cassian drafts the Accord. Every signatory wants one more concession, and some send soldiers to negotiate. Buy him the quiet he needs.",
		"debriefing": "Your name is nowhere in the document, and that is the document's greatest strength. Cassian's work no longer needs your battles. It needed this one."
	},
	# Chapter 15 — The Source
	75: {
		"chapter": "The Source",
		"briefing": "The Source itself: not a generator but a balancing network, waking as its fragments converge. Its defenses cannot tell steward from claimant.",
		"debriefing": "Alone, any fragment is a weapon or a bomb. Together, governed, it is a civilization. The machine has been waiting centuries for someone to understand that."
	},
	76: {
		"chapter": "The Source",
		"briefing": "The last battle: not for control of the Source, but to keep everyone alive long enough to sign. Every faction's best stands on this field — on every side.",
		"debriefing": "The warden who once watched you from shadows gives the conflict its name, honoring the dead of all five armies: the Resonance War."
	},
	77: {
		"chapter": "The Source",
		"briefing": "The Accord is ready to sign, and the last rejectionists have come to stop it. End the war the way it began: defending a room full of people.",
		"debriefing": "Partial truth made public, the sealed evidence re-sealed, the Source placed under coalition authority. History will remember the architect of the peace. Your machines will remember the technician."
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
	["LDF Peacekeeper", "Rage Spellslinger", "Master Builder", "Rage Bruiser", "LDF Sureshot", "Order Missionary", "Trinity Herald", "Minerva the Lionheart"],
	# Act 3 — the wardens and defenses of Caelis, escalating into the coalition
	# of every faction's best for the finale.
	["The Rook", "Geartron Prototype", "Master Builder", "Order Chaplain", "White Mage", "Bunnybot Bethany", "LDF Greatsword", "Kerryson the Stoic"],
	["Geartron Prototype", "Geartron-5000", "The Rook", "White Mage", "Oro the Pilgrim", "Master Builder", "Order Chaplain", "LDF Greatsword"],
	["The Rook", "Geartron-5000", "Gawain the Just", "White Wizard", "Order Chaplain", "Kerryson the Stoic", "Bunnybot Bethany", "Master Builder"],
	["The Archaeologist", "The Castaway", "Geartron-5000", "White Wizard", "Order Missionary", "The Rook", "Oro the Pilgrim", "Bunnybot Bethany"],
	["The Botanist", "The Ecologist", "The Biologist", "Geartron-5000", "White Wizard", "The Rook", "Sir Gawain", "Master Builder"],
	["Fabulous Bors", "Sir Bors", "The Rook", "Geartron-5000", "White Wizard", "Sterling Knight", "Kerryson the Stoic", "Oro the Enlightened"],
	["Oro the Pilgrim", "Oro the Enlightened", "Clair", "Awoken Clair", "White Mage", "White Wizard", "Geartron-5000", "The Rook"],
	["Van Hohenheim", "The Sorcerer's Stone", "Geartron-5000", "The Rook", "Awoken Clair", "White Wizard", "Sir Bors", "Sterling Knight"],
	["The Rook", "Sterling Knight", "Sir Gawain", "Awoken Clair", "The Sorcerer's Stone", "White Wizard", "Sir Bors", "Geartron-5000"],
	["Commune Captain", "Royal Beefeater", "LDF Flight Commander", "Order Chaplain", "Minerva the Brave", "Master Builder", "Precision Sniper", "Sterling Knight"],
	["Flame Dissident", "José", "José Decomposé", "Blazing Dragon", "Pompous Joe Wonder", "LDF Riot Mage", "Precision Sniper", "Garrett the Claw"],
	["Selina the Stylist", "Selina Twinblade", "Macewielder Ragnr", "Farsight Naruku", "Kerryson the Stoic", "Commune Captain", "White Wizard", "Sir Bors"],
	["Hamish Highlander", "Hamish Lochmaster", "Deep Sea Barney", "Bulkhead Barney", "Crewman Basilic", "Captain Basilic", "The Sorcerer's Stone", "Awoken Clair"],
	["Minerva the Lionheart", "Furia Rojo", "Campeon Rojo", "Blazing Dragon", "Sir Gawain", "Sir Bors", "Awoken Clair", "The Sorcerer's Stone"],
	["Minerva the Lionheart", "Campeon Rojo", "Blossom Sakura", "Shining Inti", "The Sorcerer's Stone", "Sir Gawain", "Hamish Lochmaster", "Sterling Knight"]
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
		var act := 1 if index < 22 else (2 if index < 62 else 3)
		var act_mission := index + 1 if act == 1 else (index - 21 if act == 2 else index - 61)
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
