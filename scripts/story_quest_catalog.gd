class_name StoryQuestCatalog
extends RefCounted

const MissionRulesScript = preload("res://scripts/mission_rules.gd")

# Exact mission appearances from https://chainguardians.com/story-quests.
# A unit must not be added here unless that reference lists it for the mission.
const ADDITIONAL_DROPS := {
	"Street Nurse": [3, 13, 14, 19, 27, 37, 38, 45],
	"Street Matron": [10, 13, 17, 23, 27, 37, 38, 45],
	"Conductor Kerryson": [18],
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
	"Commune Conductor": [38],
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
# consequence (Cassian's frame). The table covers all three seasons and all
# 77 missions.
const MISSION_STORIES := {
	# Chapter 1 — The Salvage
	1: {
		"chapter": "The Salvage",
		"briefing": "Two reclaimed automatons are ready for their first field test. Deploy them along the relay site's perimeter and make sure they can hold formation.",
		"debriefing": "The exercise goes cleanly. Impressed by the machines' response, Cassian restricts access to the site until the expedition understands what it has found."
	},
	2: {
		"chapter": "The Salvage",
		"briefing": "Two more machines have come online. Bring them into formation and test the control link under pressure before tomorrow's relay activation.",
		"debriefing": "The link remains stable throughout the exercise. In his ledger, Cassian writes a word beside your name that neither of you is ready to say aloud: Conductor."
	},
	3: {
		"chapter": "The Salvage",
		"briefing": "The relay has activated on its own, waking the site's security machines and bringing down the gallery. Clear a path and get the expedition crew outside.",
		"debriefing": "Most of the expedition reaches the upper gallery, but Cassian's locator still pulses below the fire line. You should not have survived the collapse, and the machines now answer your thoughts; when you turn back for him, they turn with you without being asked."
	},
	4: {
		"chapter": "The Salvage",
		"briefing": "Fire is spreading through the lower galleries, and Cassian is trapped beyond the security line. Break through the remaining defenses and bring him out.",
		"debriefing": "Cassian leaves the site alive because of you, a debt he does not take lightly. When the patrons close the site and declare the incident settled, he invokes the expedition's salvage contract and forces them to accept an independent assessment before anything can be removed."
	},
	# Chapter 2 — The Aftermath
	5: {
		"chapter": "The Aftermath",
		"briefing": "Cassian's contract challenge brings salvage assessor Adele Voss to the sealed relay site. When looters breach the perimeter during her inspection, protect her crew and keep the recovered machines out of the raiders' hands.",
		"debriefing": "Adele's crew and the recovered machines survive the raid. Her independent assessment remains open, and the patrons' attempts to contain its findings only draw attention from officials across all five factions."
	},
	6: {
		"chapter": "The Aftermath",
		"briefing": "The expedition's patrons have arranged a public demonstration to prove the reclaimed machines are safe. When the exhibition is disrupted, protect the spectators and regain control of the field.",
		"debriefing": "The event was meant to quiet questions about the accident. Instead, images of the rescue make you famous and invitations flood Cassian's desk; one bears no seal, only a request to meet on the depot roof if you want to know why the Relay woke."
	},
	7: {
		"chapter": "The Aftermath",
		"briefing": "A stranger claims the relay activation was deliberate and warns that its architects will come for their property. Moments later, armed crews close on your position. Fight your way clear.",
		"debriefing": "The attackers knew the site's security routines and came prepared to take you alive. Their capture fails, but within hours their sponsors make a legal move for the salvage instead."
	},
	8: {
		"chapter": "The Aftermath",
		"briefing": "Hours after the stranger's attack, a scavenger consortium files a challenge to the expedition's salvage claim and brings an armed crew to enforce it. Hold the stockyard while Cassian compares their paperwork with the original contract.",
		"debriefing": "Cassian proves the claim was forged, but not cheaply or carelessly. With the stockyard exposed and another attempt certain, he orders the Relay machines moved to a defensible depot beyond the scavenger border."
	},
	9: {
		"chapter": "The Aftermath",
		"briefing": "Raiders are following the convoy that carries the reclaimed machines to their new depot. Guard the transports and keep the route open.",
		"debriefing": "The convoy reaches the depot intact. The new base is defensible, but operating it openly requires the one thing you do not yet have: a Conductor registration."
	},
	# Chapter 3 — Claims
	10: {
		"chapter": "Claims",
		"briefing": "To keep the new depot from being seized as unlicensed Relay equipment, Cassian takes you to the regional licensing hall. Registration requires a certified field evaluation, and the examiners have supplied live opposition.",
		"debriefing": "You leave with a valid registration. Before you are clear of the grounds, the Joint Investigative Office cites the evaluation in an evidence order authorizing seizure of the depot and its machines."
	},
	11: {
		"chapter": "Claims",
		"briefing": "Investigators have declared the depot and its machines evidence. Their armed escort is moving in to seize both, so defend the base while Cassian challenges the order.",
		"debriefing": "You keep the depot, but the official transcript calls it a dangerous armed compound that resisted a lawful inspection. The seizure order freezes normal deliveries, so Cassian begins a private record and sends essential supplies by an unmarked back route."
	},
	12: {
		"chapter": "Claims",
		"briefing": "The unmarked supply convoy Cassian routed around the depot seizure has been ambushed by raiders moving with military discipline. Break their line and recover anything that can identify who learned the route and hired them.",
		"debriefing": "The attackers carried contractor equipment with every serial number removed. As Cassian locks it away, three factions offer protection in exchange for control of your deployments; you refuse all three, and Adele begins tracing the equipment through an informant."
	},
	13: {
		"chapter": "Claims",
		"briefing": "The three factions whose protection offers you refused answer together: a surprise safety inspection backed by armed troops. Keep them out of the depot while Cassian challenges the inspectors' authority.",
		"debriefing": "Cassian sends a courteous reply to every rejected envoy while the oldest machines begin following routines no one taught them. Adele then reports that her informant can identify the contractors from the ambush, but his handlers are already moving him."
	},
	14: {
		"chapter": "Claims",
		"briefing": "Adele's informant can identify the contractors behind the supply ambush, but his handlers are watching the safehouse district. Cover her extraction team and bring him out before they relocate him.",
		"debriefing": "Adele gets the informant out alive and scatters the handlers watching the safehouse. The contractor trail is finally within reach, though turning it into a case will be harder than winning the extraction."
	},
	# Chapter 4 — The Proving
	15: {
		"chapter": "The Proving",
		"briefing": "The team diverts from Adele's safehouse to the failing transit bridge named in the distress call. Hold back its damaged security drones and keep the crossing open until every civilian is clear.",
		"debriefing": "Hundreds of civilians make it across before the bridge gives way. For the first time, people know the Conductor not as a threat or a curiosity, but as the person who came when they needed help."
	},
	16: {
		"chapter": "The Proving",
		"briefing": "A guild champion has challenged the 'salvage Conductor' to a public match, hoping to end your new reputation. Meet the challenge and prove the bridge was no accident.",
		"debriefing": "The victory wins over the crowd and humiliates the house that sponsored your opponent. Cassian distributes the footage, accepting that the influence it buys also comes with a powerful grudge."
	},
	17: {
		"chapter": "The Proving",
		"briefing": "Public hearings over the bridge rescue and the guild match have drawn rival crowds to the inquiry hall. Keep the delegates and demonstrators safe before the tension becomes a riot.",
		"debriefing": "The hearing enters your testimony into the record only after officials edit it to support their own positions. One officer on the evaluation panel objects publicly and offers to produce an honest account by testing the Relay under controlled conditions."
	},
	18: {
		"chapter": "The Proving",
		"briefing": "The officer who challenged the edited hearing record has arranged an independent evaluation at the proving grounds. Demonstrate the squad's full strength, but do not ignore the strain on your own body.",
		"debriefing": "The evaluation confirms your ability and describes the damage continued conducting may cause. Before releasing you, the officer asks for help with reports of conductor-less automatons repeating dangerous defense routines in a nearby township."
	},
	19: {
		"chapter": "The Proving",
		"briefing": "At the evaluation officer's request, travel to the nearby township where conductor-less automatons are repeating old defense routines. Protect the residents, even if some of the machines cannot be recovered.",
		"debriefing": "You save the township at the cost of valuable salvage. One surviving automaton follows the squad back to the depot, and Cassian quietly adds another place to the supply roster."
	},
	20: {
		"chapter": "The Proving",
		"briefing": "Families displaced from the township have made camp beside the depot. Someone is using the crowded camp as cover to reach your stockpiles, so protect both the refugees and the supplies.",
		"debriefing": "The refugees choose to remain near the depot, turning a temporary camp into a small neighborhood. With water restored and winter supplies secured, the settlement can stand without the squad."
	},
	# Chapter 5 — Sanctuary
	21: {
		"chapter": "Sanctuary",
		"briefing": "With the depot settlement protected by Cassian's new charter, the team can finally follow the Stranger's coordinates. They lead to a pre-collapse sanctuary whose Order archivists refuse to admit you, so secure access without damaging the site.",
		"debriefing": "The Order agrees to share the sanctuary after you prove you could have taken it by force. The lead archivist accepts the arrangement, though her attention remains fixed on your oldest machines."
	},
	22: {
		"chapter": "Sanctuary",
		"briefing": "Ancient custodial machines still guard the sanctuary's inner vault. Disable them without destroying the archive, then reach the records they protect.",
		"debriefing": "The archive is secured intact. Its maintenance logs and transport ledgers can now be copied, but reconstructing their incomplete routes will require the Order's cross-border collection."
	},
	# Chapter 6 — The Arena
	23: {
		"chapter": "The Arena",
		"briefing": "To decode the Caelis manifest, Serin needs records held by Order scholars across an unpoliced border. Cassian makes their escort the reclamation charter's first contract; get the expedition and its copied records across safely.",
		"debriefing": "The scholars and records arrive safely, giving the charter its first successful contract. That public success draws invitations from all five factions, each offering support if the Conductor appears at its military exhibition."
	},
	24: {
		"chapter": "The Arena",
		"briefing": "The charter's successful Order escort has made you valuable enough that all five factions demand an appearance. Complete their competing exhibition circuit without accepting a patron, and be ready when staged exercises become real tests.",
		"debriefing": "By attending every exhibition, you avoid accepting any single faction's offer. Their bids prove the charter needs status none of them can grant alone, so Cassian enters you in the neutral Grand Circuit to win a recognized seat at the faction talks."
	},
	25: {
		"chapter": "The Arena",
		"briefing": "The Grand Circuit settles political disputes through sponsored champions. The charter needs a title to earn a seat at the talks, so win the opening heat and begin the climb toward Minerva, the reigning champion.",
		"debriefing": "The first win earns the crowd's attention and changes the betting around the tournament. Cassian uses that interest to secure credit and access among the patrons' boxes."
	},
	26: {
		"chapter": "The Arena",
		"briefing": "The second heat puts you against the tournament's crowd favorite. Win the match while Cassian studies which patrons support you and what they expect to gain.",
		"debriefing": "Two rival factions celebrate your victory, each convinced it serves their interests. Neither has understood why you entered the Circuit."
	},
	27: {
		"chapter": "The Arena",
		"briefing": "Your quarter-final opponent rejected a large payment to withdraw this morning. Expect a fair fight in the arena and interference from the people who wanted to prevent it.",
		"debriefing": "You win without benefiting from the attempted bribe. Cassian makes sure the other patrons learn who offered it, shifting suspicion away from the charter."
	},
	28: {
		"chapter": "The Arena",
		"briefing": "A patron has ordered your semi-final opponent to surrender and present the result as a gift to you. Deny them that claim by forcing an honest match and winning it.",
		"debriefing": "Because the victory was earned, no patron can claim that you owe them for it. Cassian publicly thanks your opponent for refusing the arrangement, and the match-fixers reconsider their approach."
	},
	29: {
		"chapter": "The Arena",
		"briefing": "Only the final remains. Defeat the reigning champion, claim the title, and earn the reclamation charter a place in the faction talks.",
		"debriefing": "You leave the Circuit as its new champion, and Cassian converts the title into formal recognition of the charter. The access gained in the patrons' boxes also lets Adele trace the earlier contractor payments to a border camp."
	},
	# Chapter 7 — Fault Lines
	30: {
		"chapter": "Fault Lines",
		"briefing": "Using contacts opened by the Circuit victory, Adele locates the border camp that paid the raiders who attacked the depot. Escort her there and recover proof of who funded the contract.",
		"debriefing": "The contracting house's pay chits and seal records are secured. Before the trail can be followed into the guild, a Wind city invokes the new charter for help with a Caelian war engine waking beneath its streets."
	},
	31: {
		"chapter": "Fault Lines",
		"briefing": "The Wind city requests the independent charter because neighboring factions will only help in exchange for control of the buried machine. Reach the city, stop the awakened Caelian war engine, and keep it out of the populated districts.",
		"debriefing": "The city survives, but each faction blames another while inspecting the ancient machines beneath its own territory. To prevent the accusation from becoming a border war, Cassian calls an emergency ceasefire summit in the capital."
	},
	32: {
		"chapter": "Fault Lines",
		"briefing": "Cassian brings the factions blaming one another for the Wind-city war engine into an emergency ceasefire summit. Attackers breach the hall before terms can be signed; protect the delegates and keep the building standing.",
		"debriefing": "The delegates stagger out through smoke while their aides lie beneath shattered gallery doors. Before the fires are contained, the summit is dead; across five capitals, hardliners are already using the fallen as proof that peace itself was a trap."
	},
	33: {
		"chapter": "Fault Lines",
		"briefing": "While survivors are still being pulled from the bombed summit, synchronized power failures spread across two delegations' territories. Follow the repair crews to the nearest failing junction and keep emergency power running before the hospitals go dark.",
		"debriefing": "The failures are propagating between separate Source fragments, though officials blame severe weather. One government instead accuses its neighbor of sabotage and launches a retaliatory raid toward a civilian border district."
	},
	34: {
		"chapter": "Fault Lines",
		"briefing": "The sabotage accusation following the grid cascade has triggered retaliatory raids on both sides of the border. Intercept the strike force moving toward a civilian district before the fighting reaches its streets.",
		"debriefing": "The district is safe, but both governments condemn your intervention. Their raids have severed the remaining grid links, leaving two districts without stable power and only one repair crew able to move before winter."
	},
	35: {
		"chapter": "Fault Lines",
		"briefing": "Damage from the border raids has left two district grids failing, and the only available repair crew cannot reach both in time. Secure the route to the district that can still be stabilized before winter.",
		"debriefing": "One district has power; the other now has a disaster around which its leaders can rally anger. There was no way to save both, but Cassian ensured that the final decision would be remembered as yours."
	},
	36: {
		"chapter": "Fault Lines",
		"briefing": "Faction leaders plan to announce that the infrastructure crisis is over, even as the grid continues to fail. Protect the gathering and the repair crews working beneath it.",
		"debriefing": "Everyone on the stage knows the grid is still failing, but the announcement proceeds as written. To get the squad away from the capital's manufactured celebration, Cassian sends you to inspect repairs in the township you saved earlier."
	},
	# Chapter 8 — Heroes and Costs
	37: {
		"chapter": "Heroes and Costs",
		"briefing": "Cassian's repair inspection brings the squad back to the township saved from feral automatons. The residents turn the visit into a public welcome, where an elderly caretaker recognizes one of your oldest machines just before trouble reaches the square.",
		"debriefing": "The festival square is secured, and the elderly caretaker asks for a private word about the machine she recognized. Before the celebration resumes, a nearby commune sends an urgent messenger."
	},
	38: {
		"chapter": "Heroes and Costs",
		"briefing": "Answering the messenger from the township celebration, the squad travels to a nearby commune that refuses evacuation. Hold the line between its residents and the relocation force preparing to remove them at gunpoint.",
		"debriefing": "You protect the commune from an evacuation its residents never accepted. On the return journey, the supply convoy accompanying your squad is diverted through a narrow pass, where raiders close both exits."
	},
	39: {
		"chapter": "Heroes and Costs",
		"briefing": "The convoy returning from the commune is trapped in a narrow pass by a coordinated raid. Break the encirclement and bring every member of the squad home.",
		"debriefing": "One of your oldest machines falls while covering the retreat. Its presence remains faintly in the Relay, carried by the squad and by you even after its body goes still."
	},
	40: {
		"chapter": "Heroes and Costs",
		"briefing": "The fallen automaton's chassis remains behind enemy lines. Take the squad back to the pass and recover it before the salvagers arrive.",
		"debriefing": "The chassis is back at the depot. Waiting there is an urgent message from Archivist Serin: she has decoded the sanctuary's Caelian transport records, and several groups are already trying to seize them before she can reach the coalition."
	},
	41: {
		"chapter": "Heroes and Costs",
		"briefing": "Following Serin's urgent message, meet her convoy outside the Sanctuary and escort her decoded transport records past the groups trying to seize them.",
		"debriefing": "Serin and the decoded records reach coalition headquarters intact. Protected copies are secured before the groups pursuing her can erase or alter the transport history."
	},
	42: {
		"chapter": "Heroes and Costs",
		"briefing": "The Stranger's new coordinates lead to an abandoned relay station, where they offer proof that your activation was arranged through patrons inside the coalition. Protect the meeting and secure the evidence before those patrons' agents arrive.",
		"debriefing": "The Stranger and the evidence escape the relay station. The attackers fail to bury the patron chain, leaving the coalition with proof of an internal conspiracy—and an immediate security crisis."
	},
	43: {
		"chapter": "Heroes and Costs",
		"briefing": "Before exposing the patrons behind your Relay experiment, Cassian must keep them from hiring the scavenger clans as an army. Garrett can secure clan neutrality, but their leaders will negotiate only after you prove your strength on their terms.",
		"debriefing": "The clans accept neutrality, depriving the implicated patrons of their usual hired muscle. Garrett also provides authenticated contract ledgers, giving Adele enough evidence to confront her former guild directly."
	},
	44: {
		"chapter": "Heroes and Costs",
		"briefing": "With Garrett's ledgers authenticating the contractor pay chits, Adele can finally confront her former guild. Escort her into the guildhall and keep her safe when its officers refuse to answer.",
		"debriefing": "The guild is forced to produce authorizations that push responsibility higher. Among the disclosed papers are shipping manifests proving that all five factions are quietly moving Source cores into weapons programs."
	},
	# Chapter 9 — Cores
	45: {
		"chapter": "Cores",
		"briefing": "The guild manifests reveal five secret Source-core weapons programs and identify one core being moved with inadequate security. Intercept that shipment before any faction can deploy it.",
		"debriefing": "The shipment is intercepted and the Source core secured before it can enter a weapons program. Within hours, all five factions issue competing demands for its custody."
	},
	46: {
		"chapter": "Cores",
		"briefing": "To answer fears that the coalition seized the Source core for itself, Cassian plans to announce a shared-custody proposal during Unity Day. Armed extremists intend to turn the crowded capital celebration into a massacre before he can speak.",
		"debriefing": "The coalition prevents a massacre, but captured orders reveal the attack was the opening move of a hardliner coup. While the public is still fleeing the square, armored columns begin advancing on the council chambers."
	},
	47: {
		"chapter": "Cores",
		"briefing": "The Unity Day attack was a diversion for a hardliner coup now moving on the council chambers. Break the armored advance before it reaches the government district.",
		"debriefing": "The coup fails. Battlefield scans taken while clearing its underground approach reveal a powered Caelian transit line beneath the capital, still drawing energy and receiving recent maintenance."
	},
	48: {
		"chapter": "Cores",
		"briefing": "The scans recovered after the failed coup locate an entrance to the powered Caelian line. Clear the remaining surface forces so Serin's team can enter the station and trace its route.",
		"debriefing": "The line points toward a place absent from every modern map, and its maintenance records are recent. The station's activation is detected by three faction armies, which converge on the populated town above its next junction."
	},
	49: {
		"chapter": "Cores",
		"briefing": "Three factions detected the transit line's activation and are converging on the town above its next junction. Hold an evacuation corridor, get the civilians clear, and withdraw before the armies collide.",
		"debriefing": "The evacuation is complete before the three armies collide. The town is lost, but its people are clear as the wider battle marks the beginning of open war."
	},
	50: {
		"chapter": "Cores",
		"briefing": "Cassian has persuaded several enemies to attempt a local truce. Defend the signing site beside troops you recently fought, and give their leaders time to finish the agreement.",
		"debriefing": "The truce holds because former enemies enforce it together. During the first joint patrol afterward, several of your oldest machines refuse an order to pursue retreating troops and instead move to protect the wounded."
	},
	51: {
		"chapter": "Cores",
		"briefing": "After the machines refuse pursuit during the joint patrol, take them to a controlled field deployment. Learn which commands they reject and whether the truce can rely on a squad that chooses its own purpose.",
		"debriefing": "The controlled deployment ends without casualties, but its results alarm all three truce signatories. Their emergency negotiation collapses into a staged show of force."
	},
	52: {
		"chapter": "Cores",
		"briefing": "The three truce partners have answered the machines' refusal with a negotiation that is becoming a staged battle. Cassian needs you to yield the disputed ground without humiliating any delegation, so control the fight and withdraw on his signal.",
		"debriefing": "Your withdrawal preserves the talks, but the staged battle's Source draw propagates far beyond the field. Lights fail across the district as dormant machines wake in sequence."
	},
	# Chapter 10 — Breaking Point
	53: {
		"chapter": "Breaking Point",
		"briefing": "The power surge from the staged negotiation has spread into Source fragments across the district, causing blackouts and waking dormant machines. Follow the grid crews outward and protect them while they contain the cascade.",
		"debriefing": "Repair crews contain the first cascade, but the blackout opens a locked ward inside a faction recruitment center. Security forces mobilize to restore its doors before the failing life-support system forces an evacuation."
	},
	54: {
		"chapter": "Breaking Point",
		"briefing": "The locked ward holds people who passed medical screening for possible Relay use, then refused faction sponsorship contracts. They have no Relays and are not Conductors, but the recruitment bureau will not release them. Reach the ward before security restores the doors or life support fails.",
		"debriefing": "The detainees reach the coalition clinic alive. Hardliners brand their extraction the theft of state recruitment assets and use it to launch an offensive across three fronts."
	},
	55: {
		"chapter": "Breaking Point",
		"briefing": "The recruitment-center extraction has become the hardliners' excuse for a full offensive across three fronts. The coalition has no other force able to intercept each breakthrough, so keep moving for as long as the Relay can bear the strain.",
		"debriefing": "The fronts hold at severe cost. Unable to break the coalition in battle, the offensive's sponsors switch targets and begin hunting its delegates one by one."
	},
	56: {
		"chapter": "Breaking Point",
		"briefing": "After the three-front offensive stalls, its sponsors send assassins after coalition delegates instead. Use Cassian's warnings to move the surviving representatives to a secure chamber and eliminate the teams tracking them.",
		"debriefing": "The delegates reach the secure chamber and the assassins are eliminated. Rather than scatter again, the survivors invoke emergency procedure and call a public tribunal to decide who can legitimately govern the Source."
	},
	57: {
		"chapter": "Breaking Point",
		"briefing": "The delegates rescued from the assassins have convened an emergency public tribunal rather than remain hidden. Armed groups from several sides are trying to silence it, so keep the chamber standing until every claimant to the Source is heard.",
		"debriefing": "The tribunal proves no claimant can impose an answer safely. Serin offers the buried Caelian conduits as neutral infrastructure for a shared settlement, but fighting has already reached the western district above their only mapped entrance."
	},
	58: {
		"chapter": "Breaking Point",
		"briefing": "Following Serin's proposal at the tribunal, the coalition travels to the western entrance of the Caelian conduits. A royalist guard controls the gates under an ancient charter and demands a formal trial before granting passage.",
		"debriefing": "The gatekeepers accept the result and open the western conduit entrance. As the coalition enters, ranging fire from long-range batteries begins walking toward the buried route."
	},
	59: {
		"chapter": "Breaking Point",
		"briefing": "The royalist gatekeepers admit the coalition, revealing that long-range batteries are already ranging the buried conduit route. Break through their surface defenses and disable the guns before the next barrage collapses the passage.",
		"debriefing": "The conduits survive the night, but the batteries can be replaced. Cassian asks Minerva to assemble former Circuit rivals into a joint force that can hold the exposed route while Serin finishes mapping it."
	},
	60: {
		"chapter": "Breaking Point",
		"briefing": "Answering Cassian's request after the battery strike, Minerva assembles former Grand Circuit rivals into the coalition's first joint team. Fight beside them to hold the conduit route while Serin completes her survey.",
		"debriefing": "Minerva's team secures the route long enough for Serin to complete the maps. They reveal a single maintained passage beyond the known network and a live signal waiting at its far terminus."
	},
	61: {
		"chapter": "Breaking Point",
		"briefing": "With Minerva's team holding the junction, follow Serin's completed map down the only maintained route beyond the known network. Secure the passage and reach the source of the live signal at its far terminus.",
		"debriefing": "The maintained passage is secured and its unknown signal source is waiting at the far terminus. Intercepted military traffic shows five faction armies converging on the same route."
	},
	62: {
		"chapter": "Breaking Point",
		"briefing": "Follow Ilyra from the transit terminus to Caelis before the armies that intercepted her signal can claim it. Hold the gate approach long enough for Cassian to assemble a neutral delegation and keep the war outside the city.",
		"debriefing": "Cassian reaches Caelis at the head of a coalition delegation rather than another invading army. The Wardens open the outer approach far enough to admit the delegation into an inspection court, but the city's inner threshold remains sealed."
	},
	# Chapter 11 — The Outer City
	63: {
		"chapter": "The Outer City",
		"briefing": "The outer gate is open, but Ilyra's fellow Wardens halt the delegation at the threshold. They will admit outsiders only after their emergency protocol verifies that you can conduct the reclaimed machines without seizing Caelian systems.",
		"debriefing": "The Wardens classify you as an unregistered Conductor with an unauthorized Relay. They grant entry despite the violation, deciding that the first new Conductor in centuries deserves further study."
	},
	64: {
		"chapter": "The Outer City",
		"briefing": "After passing the Warden inspection, the delegation enters Caelis's clean, powered, almost empty Outer City. Its caretaker machines still enforce rules for citizens who never returned and identify your group as trespassers.",
		"debriefing": "The caretakers have maintained an empty city for generations. Their response convinces the Wardens that your bond with the reclaimed machines must be tested as stewardship, not merely measured for control."
	},
	65: {
		"chapter": "The Outer City",
		"briefing": "Because the Outer City caretakers responded to your machines, the Wardens demand a second test before opening the inner gates. Defend a maintenance district without taking control of the Caelian machines already assigned to it.",
		"debriefing": "By protecting the district without claiming its machines, you demonstrate that conducting can be an act of stewardship. The Wardens record the result and unlock the inner gates."
	},
	# Chapter 12 — The Imperial Archive
	66: {
		"chapter": "The Imperial Archive",
		"briefing": "The maintenance test unlocks Caelis's inner gates, and Serin chooses the Imperial Archive as the delegation's first destination. Disable defenses that deny access to Wardens and outsiders alike without damaging its unedited account of the Empire's final years.",
		"debriefing": "The archive records a Source crisis and the Empire's decision that no single power could safely control the whole network. Its index points to five sealed founding galleries just as alarms report rival claimants forcing their way inside."
	},
	67: {
		"chapter": "The Imperial Archive",
		"briefing": "The central archive index leads to five founding galleries, one for each modern faction. Rival claimants have breached them to destroy evidence that weakens their own histories; reach the rooms before the collection is lost.",
		"debriefing": "The five founding galleries are secured before the claimants can destroy their records. Aligning the recovered sections reveals a cipher pointing to the archive's deepest sealed vault."
	},
	68: {
		"chapter": "The Imperial Archive",
		"briefing": "The combined founding records reveal both the location and cipher of the archive's deepest vault. Its guardians were designed to resist Conductors, so reach the evidence that caused the Empire to fragment the Source without releasing it beyond the vault.",
		"debriefing": "The deep record is recovered and resealed without escaping the vault. Its guardian network is left dormant and the archive remains intact."
	},
	# Chapter 13 — The Conductor Vault
	69: {
		"chapter": "The Conductor Vault",
		"briefing": "The sealed record identifies living witnesses in a nearby Conductor Vault who can explain the human cost behind the Empire's decision. Travel to the hospice and pass its guardians' assessment to speak with them.",
		"debriefing": "The hospice guardians stand down and admit the delegation. Beyond them, the surviving First Conductors receive you in the Relay ward."
	},
	70: {
		"chapter": "The Conductor Vault",
		"briefing": "The First Conductors direct the delegation to the Warden council for answers about your activation. The Continuity Directorate—the Warden faction that authorized the experiment—seals the witness chamber and activates its custodial forces to prevent the council from testifying. Break the lockdown without destroying the surviving records.",
		"debriefing": "The Continuity Directorate's lockdown is broken and the council records survive. Unable to conceal its role any longer, the Warden council admits that your activation was a deliberate continuity test."
	},
	71: {
		"chapter": "The Conductor Vault",
		"briefing": "The Warden council summons you to the Crown Relay and insists the new Conductor remain in Caelis as successor to the Vault. When you refuse, its honor guard seals the exits.",
		"debriefing": "You break the containment and keep the coalition delegation intact. Despite the confrontation, the Crown Relay and its guardians remain unharmed."
	},
	# Chapter 14 — The Civic Core
	72: {
		"chapter": "The Civic Core",
		"briefing": "After its succession offer fails, Caelis requests a public hearing on the future stewardship of the Source. The delegations gather at the Civic Core, where armed hardliners are trying to seize the council chambers first.",
		"debriefing": "The Civic Core is secured. Under coalition guard, the surviving delegations resume the negotiations the hardliners tried to end."
	},
	73: {
		"chapter": "The Civic Core",
		"briefing": "Caelian restorationists and faction hardliners have joined forces to destroy the talks before a compromise can emerge. Protect the negotiators, even though the final agreement is not yours to write.",
		"debriefing": "The alliance between both extremes exposes how much they each fear compromise. The talks survive, and you begin to understand the shifts in the room that Cassian has always noticed first."
	},
	74: {
		"chapter": "The Civic Core",
		"briefing": "Cassian is drafting the Accord while every proposed signatory presses for a final concession. Some have sent troops to strengthen their demands, so keep them away from the negotiating hall.",
		"debriefing": "The pressure forces are repelled. With outside coercion broken, Cassian seals the completed Accord draft for signatory review."
	},
	# Chapter 15 — The Source
	75: {
		"chapter": "The Source",
		"briefing": "The final Accord draft requires every signatory to prove shared stewardship in practice, so a joint repair team enters the Source complex to reconnect its fragments. Its defenses mistake the team for another faction trying to seize control.",
		"debriefing": "The joint crews prove that a connected, shared Source can support an entire civilization. The reconnection also reveals the complex to every remaining rejectionist force, which begins converging before the Accord can be signed."
	},
	76: {
		"chapter": "The Source",
		"briefing": "The Accord is nearly complete, but fighting has reached the Source complex. Hold the field with champions from every faction and keep all sides alive long enough for their leaders to sign.",
		"debriefing": "The allied line holds, with faction champions fighting together at the Source approach. The surviving rejectionists fall back toward the assembly as their leaders finish the Accord."
	},
	77: {
		"chapter": "The Source",
		"briefing": "The Accord is ready for signatures, and the last rejectionists are advancing on the assembly. Defend the delegates and give them the time they need to end the war.",
		"debriefing": "The Accord is signed. The factions accept a shared account of the past, return the most dangerous evidence to the vault, and place the Source under coalition authority."
	}
}

# Epilogue shown on completing the final mission (the Accord ending from
# documentation/Resonance_War_Narrative_Foundation.md).
const CAMPAIGN_EPILOGUE := (
	"Cassian's Accord holds. The factions publish the history they can safely "
	+ "share and return the most dangerous evidence to its vault. They place "
	+ "the Source under a coalition authority that belongs to no single faction.\n\n"
	+ "The war ends. The grids stabilize, and the cities remain lit.\n\n"
	+ "History remembers Cassian as the architect of the peace. It records you "
	+ "as a reclamation technician who was present at several decisive events.\n\n"
	+ "You return to repair work, accompanied by machines that have grown older "
	+ "and more individual than any official history will acknowledge.\n\n"
	+ "Years later, historians give the conflict a name:\n\n"
	+ "THE RESONANCE WAR"
)

# Authored eight-card decks, indexed by mission. Multi-battle missions keep
# their mission's identity while Conductor HP and skill change per encounter.
# These are deliberately explicit: reward pools do not silently alter enemies.
const MISSION_OPPONENTS := [
	# Act 1 · Reclamation
	["Perimeter Test Team", "Reclamation Expedition"], # 1
	["Relay Drill Team", "Reclamation Expedition"], # 2
	["Awakened Custodian", "Caelian Site Security"], # 3
	["Gallery Firebreak", "Caelian Site Security"], # 4
	["Looters' Foreman", "Unaffiliated Raiders"], # 5
	["Exhibition Saboteur", "Unknown Sponsor"], # 6
	["Retrieval Commander", "Unknown Sponsor"], # 7
	["Consortium Enforcer", "Scavenger Consortium"], # 8
	["Raider Convoy Chief", "Scavenger Clans"], # 9
	["Licensing Examiner", "Conductor Registry"], # 10
	["Evidence Detail Conductor", "Joint Investigative Office"], # 11
	["Contract Ambush Leader", "Deniable Contractors"], # 12
	["Safety Inspector-General", "Three-Faction Commission"], # 13
	["Informant's Handler", "Deniable Contractors"], # 14
	["Bridge Defense Core", "Caelian Transit Security"], # 15
	["Guild Champion", "Sponsor House"], # 16
	["Inquiry Hall Agitator", "Unaffiliated Partisans"], # 17
	["Relay Evaluator", "Conductor Registry"], # 18
	["Feral Patrol Core", "Unaffiliated Automata"], # 19
	["Camp Infiltrator", "Unaffiliated Raiders"], # 20
	["Sanctuary Gate Scholar", "Order Archivists"], # 21
	["Archive Custodian", "Caelian Sanctuary Defense"], # 22
	# Act 2 · The Crisis
	["Border Interdiction Chief", "Unaffiliated Border Militia"], # 23
	["Exhibition Marshal", "Five-Faction Circuit"], # 24
	["Opening-Heat Champion", "Grand Circuit"], # 25
	["The Crowd Favorite", "Grand Circuit"], # 26
	["Quarter-Final Champion", "Grand Circuit"], # 27
	["Semi-Final Champion", "Grand Circuit"], # 28
	["Minerva", "Grand Circuit Champion"], # 29
	["Contractor Paymaster", "Deniable Contractors"], # 30
	["Awakened War Engine", "Caelian War Machine"], # 31
	["Summit Bomber", "Unknown Hardliners"], # 32
	["Fragment Defense Swarm", "Source Network Automata"], # 33
	["Retaliation Commander", "Border Hardliners"], # 34
	["Route Blockade Chief", "Border Militia"], # 35
	["Broadcast Hall Attacker", "Unaffiliated Extremists"], # 36
	["Festival Saboteur", "Unaffiliated Raiders"], # 37
	["Relocation Commander", "State Relocation Authority"], # 38
	["Pass Ambush Leader", "Deniable Raiders"], # 39
	["Salvage Recovery Chief", "Unaffiliated Salvagers"], # 40
	["Record-Seizure Conductor", "Competing Claimants"], # 41
	["Patron Retrieval Agent", "Coalition Insiders"], # 42
	["Clan Trialmaster", "Scavenger Clans"], # 43
	["Guildhall Factor", "Contractors' Guild"], # 44
	["Core Convoy Commander", "Five-Faction Arms Program"], # 45
	["Unity Day Cell Leader", "Unaffiliated Extremists"], # 46
	["Coup Field Marshal", "Faction Hardliners"], # 47
	["Coup Rearguard", "Hardliner Coup"], # 48
	["Junction Battle Commander", "Three-Faction Armies"], # 49
	["Truce-Line Holdout", "Faction Hardliners"], # 50
	["Coalition Test Conductor", "Reclamation Coalition"], # 51
	["Negotiation Provocateur", "Three-Party Delegation"], # 52
	["Synchronized Defense Core", "Source Fragment Network"], # 53
	["Intake Security Chief", "Faction Relay Bureau"], # 54
	["Offensive Field Command", "Hardliner Alliance"], # 55
	["Assassin Cell Leader", "Hardliner Alliance"], # 56
	["Tribunal Disruptor", "Rival Claimants"], # 57
	["Royalist Gatekeeper", "Caelian Royalist Guard"], # 58
	["Battery Commander", "Faction Siege Corps"], # 59
	["Conduit Route Commander", "Faction Siege Corps"], # 60
	["Terminus Custodian", "Caelian Transit Security"], # 61
	["Gate Vanguard", "Five-Faction Armies"], # 62
	# Act 3 · Caelis
	["Warden Examiner", "Wardens of Caelis"], # 63
	["Outer City Caretaker", "Caelian Civic Automata"], # 64
	["Stewardship Examiner", "Wardens of Caelis"], # 65
	["Archive Custodian", "Imperial Archive"], # 66
	["Record-Burner Conductor", "Faction Claimants"], # 67
	["Deep Vault Guardian", "Imperial Archive"], # 68
	["Hospice Assessor", "Conductor Vault Guardians"], # 69
	["Continuity Marshal", "Warden Continuity Directorate"], # 70
	["Crown Relay Honor Guard", "Wardens of Caelis"], # 71
	["Civic Core Seizure Leader", "Caelian Restorationists"], # 72
	["Extremist Coalition Conductor", "Restorationists & Hardliners"], # 73
	["Negotiation Hall Coercer", "Faction Pressure Forces"], # 74
	["Distribution Defense Core", "The Source"], # 75
	["Rejectionist Field Marshal", "Accord Rejectionists"], # 76
	["Last Rejectionist", "Accord Rejectionists"] # 77
]

# The modern faction represented by each enemy squad. Local unaffiliated groups
# can borrow a regional faction identity; "Blended" is used when no single
# identity is intended. Caelian teams blend the five successor factions because
# each inherited part of Caelis.
const MISSION_SQUAD_FACTIONS := [
	# Act 1
	"Blended", "Blended", "Caelian", "Caelian", "Coal", "Solar", "Solar",
	"Coal", "Coal", "Steam", "Blended", "Solar", "Blended", "Solar",
	"Caelian", "Solar", "Blended", "Steam", "Blended", "Coal", "Wind",
	"Caelian",
	# Act 2
	"Wind", "Blended", "Blended", "Blended", "Blended", "Blended", "Fusion",
	"Solar", "Caelian", "Blended", "Caelian", "Wind", "Wind", "Blended",
	"Coal", "Steam", "Coal", "Coal", "Blended", "Solar", "Coal", "Solar",
	"Blended", "Blended", "Steam", "Steam", "Blended", "Steam", "Blended",
	"Blended", "Caelian", "Fusion", "Blended", "Blended", "Blended", "Caelian",
	"Coal", "Coal", "Caelian", "Blended",
	# Act 3
	"Caelian", "Caelian", "Caelian", "Caelian", "Blended", "Caelian", "Caelian",
	"Blended", "Caelian", "Caelian", "Blended", "Blended", "Caelian", "Blended",
	"Blended"
]

## Optional per-encounter rules, keyed as "<1-based mission>:<0-based battle>".
## Encounters without an entry retain the standard defeat-the-Conductor rules.
## The first authored set teaches one variation at a time across the opening
## campaign chapters before later missions return to the unmodified baseline.
const ENCOUNTER_RULES := {
	"3:0": {
		"objective": {
			"type": "survive",
			"rounds": 4,
			"title": "Evacuate the Gallery",
			"description": "Hold the security machines back through round 4 while the expedition crew escapes."
		},
		"blocked_cells": [
			{"row": 0, "col": 3}, {"row": 2, "col": 3}
		],
		"mana": {"player_start": 4, "enemy_start": 2, "growth": 2, "cap": 10}
	},
	"4:0": {
		"objective": {
			"type": "eliminate_target",
			"target_name": "the security warden",
			"title": "Break the Security Line",
			"description": "Eliminate the marked security warden blocking Cassian's extraction route."
		},
		"turn_limit": 6,
		"predeployed": [{
			"unit": "Claw Chopper", "side": 1, "row": 1, "col": 4,
			"role": "priority", "locks_mana": false
		}]
	},
	"5:0": {
		"objective": {
			"type": "protect",
			"target_name": "Adele's survey rig",
			"title": "Protect the Survey",
			"description": "Keep Adele's marked survey rig operational and defeat the raider Conductor."
		},
		"turn_limit": 7,
		"predeployed": [{
			"unit": "Apprentice Builder", "side": 0, "row": 1, "col": 1,
			"role": "protected", "stationary": true, "locks_mana": false
		}]
	},
	"6:0": {
		"objective": {
			"type": "survive",
			"rounds": 5,
			"title": "Secure the Exhibition",
			"description": "Hold the demonstration floor through round 5 while spectators reach the exits."
		},
		"reinforcements": [
			{"unit": "Dart Shooter", "side": 1, "round": 2, "row": 0, "col": 6},
			{"unit": "Claw Slicer", "side": 1, "round": 4, "row": 2, "col": 6}
		]
	},
	"7:0": {
		"objective": {
			"type": "eliminate_target",
			"target_name": "the extraction leader",
			"title": "Cut Off the Extraction",
			"description": "Eliminate the marked leader before the armed crew can withdraw with its prize."
		},
		"turn_limit": 6,
		"predeployed": [{
			"unit": "Trinity Rusher", "side": 1, "row": 1, "col": 4,
			"role": "priority", "locks_mana": false
		}],
		"reinforcements": [{
			"unit": "Rescue Corps", "side": 1, "round": 3, "row": 0, "col": 6
		}]
	},
	"8:0": {
		"objective": {
			"type": "survive",
			"rounds": 4,
			"title": "Hold the Stockyard",
			"description": "Keep control of the stockyard through round 4 while Cassian verifies the salvage claim."
		},
		"blocked_cells": [{"row": 1, "col": 3}],
		"mana": {"player_start": 2, "enemy_start": 4, "growth": 2, "cap": 8}
	},
	"9:0": {
		"objective": {
			"type": "protect",
			"target_name": "the salvage transport",
			"title": "Guard the Convoy",
			"description": "Keep the marked transport operational and defeat the pursuing Conductor."
		},
		"turn_limit": 7,
		"predeployed": [{
			"unit": "Apprentice Builder", "side": 0, "row": 1, "col": 2,
			"role": "protected", "stationary": true, "locks_mana": false
		}],
		"reinforcements": [
			{"unit": "Claw Ambusher", "side": 1, "round": 2, "row": 0, "col": 6},
			{"unit": "Garrett Talon", "side": 1, "round": 4, "row": 2, "col": 6}
		]
	}
}

const MISSION_ENEMY_SQUADS := [
	# Act 1
	["Trinity Rusher", "Trinity Potshot", "Trinity Basher", "Chain Initiate", "Pub Bouncer", "LDF Peacekeeper", "Rage Spellslinger", "Socialite Fencer"],
	["Chain Initiate", "Rage Spellslinger", "Pub Bouncer", "Trinity Rusher", "Trinity Potshot", "LDF Peacekeeper", "Claw Slicer", "Factory Markswoman"],
	["LDF Peacekeeper", "Haven Huntsman", "Conjuring Clown", "Order Apostle", "Pub Bouncer", "Greyson the Shifty", "The Botanist", "Claw Skirmisher"],
	["LDF Peacekeeper", "Chain Initiate", "Claw Chopper", "LDF Flight Officer", "Order Missionary", "Claw Rocker", "LDF Sureshot", "LDF Crowd Mage"],
	["Factory Markswoman", "Raging Dragon", "Claw Slicer", "Precision Shooter", "Macabre Embalmer", "Apprentice Builder", "Flame Warden", "Rage Bruiser"],
	["Master Builder", "Trinity Messenger", "Trinity Basher", "Dart Shooter", "Fortune Teller", "Claw Slicer", "Rescue Corps", "Claw Cleaver"],
	["Trinity Rusher", "Fortune Teller", "Rescue Corps", "Dart Shooter", "Rage Spellslinger", "Claw Chopper", "Socialite Fencer", "The Botanist"],
	["Rage Bruiser", "Socialite Fencer", "Garrett Talon", "Claw Skirmisher", "Raging Dragon", "LDF Medic", "Macabre Embalmer", "Flame Warden"],
	["Apprentice Builder", "Greyson the Shifty", "Rage Bruiser", "Chain Initiate", "Raging Dragon", "Claw Ambusher", "Garrett Talon", "LDF Medic"],
	["Socialite Fencer", "Pub Bouncer", "Royal Yeoman", "LDF Bolt Slinger", "Blight Doctor", "Order Pupil", "Prison Warden", "LDF Constable"],
	["LDF Medic", "Street Nurse", "Claw Slicer", "Dart Shooter", "Conjuring Clown", "LDF Flight Officer", "LDF Sergeant", "Conductor Kerryson"],
	["Claw Slicer", "Socialite Fencer", "Trinity Messenger", "Street Matron", "Claw Cleaver", "Rage Spellslinger", "The Botanist", "Dart Shooter"],
	["Pub Bouncer", "Claw Caster", "Factory Markswoman", "Street Hoodlum", "Rage Brute", "Chain Initiate", "LDF Peacekeeper", "Trinity Potshot"],
	["Rescue Corps", "Street Matron", "Socialite Fencer", "Trinity Rusher", "Claw Cleaver", "Dart Shooter", "Pub Bouncer", "Trinity Herald"],
	["Trinity Potshot", "Rage Spellslinger", "LDF Flight Commander", "Factory Markswoman", "Pub Bouncer", "LDF Peacekeeper", "Chain Initiate", "Claw Slicer"],
	["Socialite Fencer", "Opelle", "Selina the Stylist", "Hamish Highlander", "Blightshot", "Street Matron", "Trinity Herald", "Pub Bouncer"],
	["Socialite Fencer", "Pub Bouncer", "Trinity Basher", "Rage Spellslinger", "Rage Bruiser", "Factory Markswoman", "LDF Medic", "Trinity Rusher"],
	["Jimimi the Shepherd", "Whirling Ragnr", "Street Hoodlum", "LDF Sergeant", "LDF Bowgunner", "Factory Markswoman", "Naruku the Lookout", "Trinity Rusher"],
	["Macabre Undertaker", "LDF Sureshot", "LDF Swordwielder", "Order Missionary", "Three of Hearts", "Rescue Paramedic", "Bethany", "Yuuya (Fantail Pigeon)"],
	["Flame Dissident", "Final Empress", "Rage Bruiser", "Claw Skirmisher", "Precision Shooter", "Hookie", "Pub Landlord", "Garrett the Claw"],
	["Order Chaplain", "Order Scholar", "Claw Rocker", "Innocent Gretel", "Philippa Trot", "Mata Swiftblade", "Haven Huntsman", "Joe Wonder"],
	["Order Scholar", "LDF Swordwielder", "Order Missionary", "Hamish Highlander", "Dart Sharpshooter", "Shakespeare", "Flame Dissident", "Rage Spellslinger"],
	# Act 2
	["Communicator Ripley", "Order Chaplain", "Final Empress", "Haven Huntsman", "Talon Scratcher", "Frog-Hopper Keru", "Innocent Gretel", "Master Builder"],
	["Minerva the Brave", "Final Empress", "Commune Defender", "Claw Skirmisher", "Prison Warden", "Dart Sharpshooter", "Ant Lantis", "Order Scholar"],
	["Trinity Rusher", "Trinity Potshot", "Claw Caster", "Trinity Basher", "Claw Skirmisher", "Pub Bouncer", "Socialite Fencer", "Chain Initiate"],
	["Socialite Fencer", "Claw Caster", "Claw Slicer", "Claw Skirmisher", "Factory Markswoman", "Pub Bouncer", "Chain Initiate", "Rage Brute"],
	["Socialite Fencer", "Pub Bouncer", "Factory Markswoman", "Street Hoodlum", "LDF Gunner", "Chain Initiate", "Rage Spellslinger", "Trinity Rusher"],
	["Rage Spellslinger", "LDF Medic", "Order Pupil", "Order Cleric", "Rage Brute", "LDF Peacekeeper", "Factory Markswoman", "Claw Slicer"],
	["Minerva the Brave", "Crewman Basilic", "Whirling Ragnr", "Shakespeare", "Conjuring Harlequin", "LDF Sureshot", "LDF Crowd Mage", "Master Builder"],
	["Fortune Teller", "Dart Shooter", "Rescue Paramedic", "Bartok Loco", "Street Matron", "Selina the Stylist", "Master Builder", "The Archaeologist"],
	["Rescue Paramedic", "Prison Warden", "Claw Chopper", "Winter Harding", "Final Empress", "LDF Constable", "Garrett Talon", "Hookie"],
	["Order Cleric", "LDF Constable", "Prison Warden", "Order Apostle", "Hookie", "Conjuring Clown", "LDF Bolt Slinger", "LDF Greatsword"],
	["Street Matron", "Fortune Diviner", "Ki", "Order Missionary", "Crewman Basilic", "Blight Doctor", "Rage Bruiser", "LDF Flight Commander"],
	["Order Cleric", "Order Scholar", "Talon Slasher", "LDF Greatsword", "LDF Flight Officer", "Mata Swiftblade", "Haven Trapper", "Master Builder"],
	["Claw Minstrel", "Master Builder", "Innocent Gretel", "Haven Huntsman", "Talon Slasher", "The Archaeologist", "Frog-Hopper Keru", "Philippa Trot"],
	["Dart Shooter", "Rage Brute", "LDF Sergeant", "Conjuring Harlequin", "LDF Flight Commander", "Claw Ambusher", "Innocent Gretel", "Flame Dissident"],
	["Claw Ambusher", "Precision Sniper", "The Archaeologist", "Flame Dissident", "Garrett Talon", "Macabre Embalmer", "Rage Brute", "Pub Landlord"],
	["Street Hoodlum", "Prison Warden", "Naruku the Lookout", "Whirling Ragnr", "Jimimi the Shepherd", "LDF Sergeant", "Final Empress", "Bethany"],
	["Garrett Talon", "Pub Landlord", "Final Empress", "Greyson the Shifty", "Philippa Trot", "Precision Shooter", "Flame Dissident", "Raging Dragon"],
	["Raging Dragon", "Flame Warden", "Hookie", "Greyson the Shifty", "The Archaeologist", "Bartok Loco", "Pub Barman", "Garrett the Claw"],
	["Order Scholar", "Pub Landlord", "Prison Warden", "Order Cleric", "Garrett Talon", "Bartok Loco", "Rescue Paramedic", "Claw Skirmisher"],
	["LDF Greatsword", "The Ecologist", "Trinity Messenger", "Blightshot", "Master Builder", "Selina the Stylist", "Fortune Diviner", "Dart Sharpshooter"],
	["Garrett the Claw", "Claw Ambusher", "Flame Warden", "The Archaeologist", "Precision Shooter", "LDF Greatsword", "Pub Landlord", "Hookie"],
	["LDF Greatsword", "Claw Cleaver", "Order Scholar", "Fortune Diviner", "Selina the Stylist", "Apprentice Builder", "Dart Shooter", "Rescue Paramedic"],
	["Garrett the Claw", "Geartron-5000", "Blight Doctor", "Haven Huntsman", "Royal Beefeater", "Ant Lantis", "Belladonna", "Selina the Stylist"],
	["Opelle", "Raging Dragon", "Geartron-5000", "Whirling Ragnr", "Shakespeare", "The Rook", "Blight Physician", "Blightshot"],
	["Farsight Naruku", "Street Hoodlum", "Whirling Ragnr", "Royal Beefeater", "Jimimi the Herder", "LDF Bolt Slinger", "Bulkhead Barney", "Prison Warden"],
	["Sakura", "Bulkhead Barney", "Whirling Ragnr", "LDF Greatsword", "Jimimi the Herder", "Naruku the Lookout", "Bunnybot Bethany", "Prison Warden"],
	["Minerva the Brave", "Three of Hearts", "Awoken Final Empress", "Pub Landlord", "Devout Mage", "Lunnain Oracle", "Precision Shooter", "Swiftblade Heroine"],
	["Geartron-5000", "Street Hoodlum", "Present Verdandi", "Awoken Final Empress", "Blight Doctor", "Bethany", "Macewielder Ragnr", "Order Scholar"],
	["Minerva the Brave", "Commune Defender", "The Rook", "José", "Talon Slasher", "Garrett the Claw", "Geartron Prototype", "Fortune Diviner"],
	["Beautifly Hookie", "Furia Rojo", "Galloping Philippa", "Crewman Basilic", "Mata Swiftblade", "The Botanist", "Steph Lopod", "LDF Flight Commander"],
	["Frog-Hopper Keru", "Commune Conductor", "Vicious Pierrot", "Glowing Opelle", "Innocent Gretel", "Greyson the Shifty", "Jimimi the Shepherd", "Three of Hearts"],
	["Minerva the Brave", "LDF Sureshot", "Order Scholar", "Frost-Kid Kokori", "Bartok Loco", "Kerryson the Stoic", "The Bard", "Master Builder"],
	["Bunnybot Bethany", "Thief", "Talon Slasher", "Final Empress", "Hookie", "Present Verdandi", "Garrett the Raider", "Campeon Rojo"],
	["Rage Bruiser", "Dart Sharpshooter", "Flame Schematic", "Crewman Basilic", "Selina the Stylist", "Street Hoodlum", "Medusa", "Bulkhead Barney"],
	["LDF Swordwielder", "Talon Slasher", "Beautifly Hookie", "LDF Bolt Slinger", "Haven Huntsman", "Rescue Paramedic", "Furia Rojo", "Flame Warden"],
	["Sir Bors", "Talon Scratcher", "Inti Chihuan", "Commune Defender", "Trinity Herald", "Clair", "Vicious Pierrot", "Bunnybot Bethany"],
	["Garrett Talon", "Claw Ambusher", "Pub Barman", "Flame Schematic", "The Castaway", "Clair", "Campeon Rojo", "Order Scholar"],
	["Furia Rojo", "Hookie", "Blazing Dragon", "The Aquanaut", "Greyson the Shrewd", "White Mage", "Pub Barman", "LDF Greatsword"],
	["Fortune Teller", "Crewman Basilic", "Swiftblade Heroine", "Beautifly Hookie", "LDF Sergeant", "Galloping Philippa", "The Telecommunicator", "Van Hohenheim"],
	["Minerva the Lionheart", "Macewielder Ragnr", "Devout Warlock", "Opelle", "Bethany", "Cara Pace", "Pub Landlord", "LDF Sergeant"],
	# Act 3 — the wardens and defenses of Caelis, escalating into the coalition
	# of every faction's best for the finale.
	["The Rook", "White Wizard", "Blossom Sakura", "Frontier Protector", "Happy Elf Harding", "Whirling Ragnr", "Talon Slasher", "Vicious Pierrot"],
	["White Mage", "Thief", "Commune Conductor", "Frog-Hopper Keru", "The Bard", "Hamish Lochmaster", "Awoken Final Empress", "Booth Kavar"],
	["Sir Gawain", "Devout Warlock", "Witchkiller Gretel", "Shakespeare", "Lunnain Oracle", "Ki", "Sir Bors", "Booth Kavar"],
	["The Castaway", "Blossom Sakura", "Winter Harding", "White Mage", "Crewman Basilic", "Bulkhead Barney", "Edge", "Gorgon Medusa"],
	["The Biologist", "Sakuya Le Bel Shirogane", "Commune Conductor", "Clawing Cara", "Summoner Rydia", "Bunnybot Bethany", "Van Hohenheim", "Royal Beefeater"],
	["Sir Bors", "The Hydronaut", "Van Hohenheim", "Galloping Philippa", "Ninja Edge", "Sakura", "Conjuring Jester", "Geartron Prototype"],
	["Oro the Enlightened", "Talon Slasher", "LDF Mastersword", "Lizard-Licker Keru", "Dart Sharpshooter", "The Bard", "Ki", "Ra"],
	["The Sorcerer's Stone", "Explorer Gatling", "Campeon Rojo", "The Ecologist", "Crewman Basilic", "Fortune Diviner", "Bartok Loco", "Frog-Hopper Keru"],
	["Awoken Clair", "Gawain the Just", "Blight Physician", "Talon Slasher", "Innocent Gretel", "Summoner Rydia", "The Biologist", "Sterling Knight"],
	["Clawing Cara", "Devout Warlock", "Bethany", "Communicator Ripley", "The Castaway", "The Biologist", "Campeon Rojo", "Galloping Philippa"],
	["José Decomposé", "Macabre Undertaker", "Pompous Joe Wonder", "Opelle", "Medusa", "Commune Conductor", "Shakespeare", "Precision Sniper"],
	["Selina Twinblade", "Flame Dissident", "Gawain the Just", "Witchkiller Gretel", "Sakuya Le Bel Shirogane", "Macabre Undertaker", "Sir Bors", "Conductor Basilic"],
	["Hamish Lochmaster", "Innocent Gretel", "Summoner Rydia", "Verdandi Norn", "Commune Commander", "Explorer Gatling", "Swiftblade Heroine", "Clair"],
	["Campeon Rojo", "Lizard-Licker Keru", "Swiftblade Heroine", "Conductor Basilic", "Winter Harding", "Van Hohenheim", "Awoken Final Empress", "Lunnain Oracle"],
	["Blossom Sakura", "Shining Inti", "The Earth Whisperer", "Gorgon Medusa", "Derailed Bartok", "Frontier Rider", "Ace of Hearts", "Talon Slasher"]
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
		var opponent: Array = (
			MISSION_OPPONENTS[index]
			if index < MISSION_OPPONENTS.size()
			else ["Unknown Opposition", "Unaffiliated"]
		)
		var squad_faction: String = (
			MISSION_SQUAD_FACTIONS[index]
			if index < MISSION_SQUAD_FACTIONS.size()
			else "Blended"
		)
		for battle_index in battle_count:
			var hp := maxi(8, enemy_hp - (battle_count - battle_index - 1) * 2)
			var rule_key := "%d:%d" % [index + 1, battle_index]
			var rules: Dictionary = MissionRulesScript.normalize(
				ENCOUNTER_RULES.get(rule_key, {})
			)
			encounters.append({
				"title": short_title if battle_index == battle_count - 1 else "%s · Approach %d" % [short_title, battle_index + 1],
				"enemy_hp": hp,
				"skill": SKILLS[(index + battle_index) % SKILLS.size()],
				"opponent_name": opponent[0],
				"opponent_affiliation": opponent[1],
				"squad_faction": squad_faction,
				"enemy_squad": _enemy_squad_for(index),
				"rules": rules
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
			"opponent_name": opponent[0],
			"opponent_affiliation": opponent[1],
			"squad_faction": squad_faction,
			"encounters": encounters,
			"reward_pool": reward_pool
		})
	return missions

# Placeholder generator for missions not yet covered by MISSION_STORIES.
static func _mission_briefing(index: int, title: String) -> String:
	var objectives := [
		"Secure the approach before the opposing conductor can reinforce it.",
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
