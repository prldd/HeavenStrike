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
		"debriefing": "Adele saw you conduct the machines, and her report says so plainly. The patrons dislike its conclusions, which only makes officials across all five factions more eager to read it."
	},
	6: {
		"chapter": "The Aftermath",
		"briefing": "The expedition's patrons have arranged a public demonstration to prove the reclaimed machines are safe. When the exhibition is disrupted, protect the spectators and regain control of the field.",
		"debriefing": "The event was meant to quiet questions about the accident. Instead, images of the rescue make you famous and invitations flood Cassian's desk; one bears no seal, only a request to meet on the depot roof if you want to know why the Relay woke."
	},
	7: {
		"chapter": "The Aftermath",
		"briefing": "A stranger claims the relay activation was deliberate and warns that its architects will come for their property. Moments later, armed crews close on your position. Fight your way clear.",
		"debriefing": "The stranger disappears after leaving coordinates hidden in the Relay's dead communication channel. The attackers knew the site's security routines and came prepared to find you alive; before you can decode the coordinates, their sponsors make a legal move for the salvage."
	},
	8: {
		"chapter": "The Aftermath",
		"briefing": "Hours after the stranger's attack, a scavenger consortium files a challenge to the expedition's salvage claim and brings an armed crew to enforce it. Hold the stockyard while Cassian compares their paperwork with the original contract.",
		"debriefing": "Cassian proves the claim was forged, but not cheaply or carelessly. With the stockyard exposed and another attempt certain, he orders the Relay machines moved to a defensible depot beyond the scavenger border."
	},
	9: {
		"chapter": "The Aftermath",
		"briefing": "Raiders are following the convoy that carries the reclaimed machines to their new depot. Guard the transports and keep the route open.",
		"debriefing": "The convoy reaches the depot intact. Cassian uses your victory to secure passage rights from the same clans suspected of the attack, but operating the new base legally requires the one thing you do not yet have: a Conductor registration."
	},
	# Chapter 3 — Claims
	10: {
		"chapter": "Claims",
		"briefing": "To keep the new depot from being seized as unlicensed Relay equipment, Cassian takes you to the regional licensing hall. Registration requires a certified field evaluation, and the examiners have supplied live opposition.",
		"debriefing": "You leave with a valid registration and a new designation in five government ledgers: strategic asset. Copies of your scores reach the examiners' patrons before you leave the grounds."
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
		"debriefing": "The informant confirms that the ambush was staged, but his testimony cannot be used in court. Before the team can leave Adele's safehouse, a township distress call reports that an old transit bridge is failing beneath an evacuation column."
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
		"debriefing": "The refugees choose to remain near the depot, turning a temporary camp into a small neighborhood. Once Cassian's charter gives them enough legal standing to manage without the squad, Adele finishes decoding the coordinates the Stranger left in the Relay."
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
		"debriefing": "The maintenance logs continue for centuries after the Empire supposedly fell. An unredacted manifest names Caelis, but its route codes are incomplete; Archivist Serin must compare them with Order collections on the far side of a border no government currently patrols."
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
		"debriefing": "The recovered pay chits carry no signatures, but the contracting house used a guild seal Adele recognizes from her former employer. Before she can approach the guild, a Wind city invokes the new charter for help with a Caelian war engine waking beneath its streets."
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
		"debriefing": "The caretaker remembers the machine's first Conductor, dead for sixty years. During the celebration, a messenger arrives from a nearby commune whose residents are about to be removed from their failing territory by force."
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
		"debriefing": "The records show that all five founding factions erased Caelis from their maps. When Serin restores the missing route on a Caelian chart, its dormant transit frequency activates and broadcasts new meeting coordinates signed by the Stranger."
	},
	42: {
		"chapter": "Heroes and Costs",
		"briefing": "The Stranger's new coordinates lead to an abandoned relay station, where they offer proof that your activation was arranged through patrons inside the coalition. Protect the meeting and secure the evidence before those patrons' agents arrive.",
		"debriefing": "The evidence names people who welcomed you at their tables after the accident. Cassian cannot expose them while they can hire the scavenger clans as an army, so he asks Garrett to arrange neutrality talks before the coalition makes its accusation."
	},
	43: {
		"chapter": "Heroes and Costs",
		"briefing": "Before exposing the patrons behind your Relay experiment, Cassian must keep them from hiring the scavenger clans as an army. Garrett can secure clan neutrality, but their leaders will negotiate only after you prove your strength on their terms.",
		"debriefing": "The clans accept neutrality, depriving the implicated patrons of their usual hired muscle. Garrett also provides authenticated contract ledgers, giving Adele enough evidence to confront her former guild directly."
	},
	44: {
		"chapter": "Heroes and Costs",
		"briefing": "With Garrett's ledgers authenticating the contractor pay chits, Adele can finally confront her former guild. Escort her into the guildhall and keep her safe when its officers refuse to answer.",
		"debriefing": "The guild produces authorizations that push responsibility higher, then Adele resigns in public. Among the disclosed papers are shipping manifests proving that all five factions are quietly moving Source cores into weapons programs."
	},
	# Chapter 9 — Cores
	45: {
		"chapter": "Cores",
		"briefing": "The guild manifests reveal five secret Source-core weapons programs and identify one core being moved with inadequate security. Intercept that shipment before any faction can deploy it.",
		"debriefing": "The core is secure, but possession makes the coalition a military power in its own right. By keeping the weapon from everyone else, you have also given every faction a reason to come for you."
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
		"debriefing": "The town is empty before the three armies collide, but the wider battle marks the beginning of open war. Cassian makes sure the official record distinguishes the ground you surrendered from the lives you saved."
	},
	50: {
		"chapter": "Cores",
		"briefing": "Cassian has persuaded several enemies to attempt a local truce. Defend the signing site beside troops you recently fought, and give their leaders time to finish the agreement.",
		"debriefing": "The truce holds because former enemies enforce it together. During the first joint patrol afterward, several of your oldest machines refuse an order to pursue retreating troops and instead move to protect the wounded."
	},
	51: {
		"chapter": "Cores",
		"briefing": "After the machines refuse pursuit during the joint patrol, take them to a controlled field deployment. Learn which commands they reject and whether the truce can rely on a squad that chooses its own purpose.",
		"debriefing": "The machines still defend people and hold their ground, but will not destroy simply because they are told. Their refusal alarms the truce's three signatories, whose emergency negotiation collapses into a staged show of force."
	},
	52: {
		"chapter": "Cores",
		"briefing": "The three truce partners have answered the machines' refusal with a negotiation that is becoming a staged battle. Cassian needs you to yield the disputed ground without humiliating any delegation, so control the fight and withdraw on his signal.",
		"debriefing": "Your withdrawal preserves the talks, but the staged battle's Source draw propagates far beyond the field. Lights fail across the district as dormant machines wake in sequence—and only afterward do you realize Cassian committed your squad without asking."
	},
	# Chapter 10 — Breaking Point
	53: {
		"chapter": "Breaking Point",
		"briefing": "The power surge from the staged negotiation has spread into Source fragments across the district, causing blackouts and waking dormant machines. Follow the grid crews outward and protect them while they contain the cascade.",
		"debriefing": "Order scholars confirm that no faction initiated the synchronization; the Source network is responding to the war as though it has become aware of the strain. The blackout also disables a nearby detention center holding registered Conductors, and security forces mobilize to seal it."
	},
	54: {
		"chapter": "Breaking Point",
		"briefing": "The Source blackout has opened a detention center for registered Conductors. Reach it before security forces restore the locks, and bring the detainees out before the failing life-support system or the arriving troops kill them.",
		"debriefing": "The Conductors reach the coalition clinic alive, where Nara asks whether the law considers them assets, prisoners, or people. Before Cassian can answer with a legal status, hardliners brand the rescue an attack on state property and launch an offensive across three fronts."
	},
	55: {
		"chapter": "Breaking Point",
		"briefing": "The detention-center rescue has become the hardliners' excuse for a full offensive across three fronts. The coalition has no other force able to intercept each breakthrough, so keep moving for as long as the Relay can bear the strain.",
		"debriefing": "The fronts hold, but medical staff refuse to clear you for another deployment. Unable to break the coalition in battle, the offensive's sponsors switch targets and begin hunting its delegates one by one."
	},
	56: {
		"chapter": "Breaking Point",
		"briefing": "After the three-front offensive stalls, its sponsors send assassins after coalition delegates instead. Use Cassian's warnings to move the surviving representatives to a secure chamber and eliminate the teams tracking them.",
		"debriefing": "The delegates survive because Cassian's hidden network identifies the assassins. Rather than scatter again, the survivors invoke emergency procedure and call a public tribunal to decide who can legitimately govern the Source."
	},
	57: {
		"chapter": "Breaking Point",
		"briefing": "The delegates rescued from the assassins have convened an emergency public tribunal rather than remain hidden. Armed groups from several sides are trying to silence it, so keep the chamber standing until every claimant to the Source is heard.",
		"debriefing": "The tribunal proves no claimant can impose an answer safely. Serin offers the buried Caelian conduits as neutral infrastructure for a shared settlement, but fighting has already reached the western district above their only mapped entrance."
	},
	58: {
		"chapter": "Breaking Point",
		"briefing": "Following Serin's proposal at the tribunal, the coalition travels to the western entrance of the Caelian conduits. A royalist guard controls the gates under an ancient charter and demands a formal trial before granting passage.",
		"debriefing": "The gatekeepers accept the result and admit the coalition as the first authority in two centuries to honor their procedure. Their charter bears the seal of Caelis and has never legally expired."
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
		"debriefing": "The signal belongs to the Stranger, who identifies herself as Warden Ilyra of Caelis and provides the route to the hidden city's gate. Her transmission has been intercepted, however, and five faction armies are already racing you there."
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
		"debriefing": "Each faction preserved one real strength of the old system but mistook its fragment for the whole. When the five records are aligned, their missing sections form a cipher pointing to the archive's deepest sealed vault."
	},
	68: {
		"chapter": "The Imperial Archive",
		"briefing": "The combined founding records reveal both the location and cipher of the archive's deepest vault. Its guardians were designed to resist Conductors, so reach the evidence that caused the Empire to fragment the Source without releasing it beyond the vault.",
		"debriefing": "The sealed record explains the original crisis and why its full details could still destabilize every faction. It also cross-references living witnesses in the Conductor Vault; Cassian postpones his questions until you can hear what the old Conductors remember."
	},
	# Chapter 13 — The Conductor Vault
	69: {
		"chapter": "The Conductor Vault",
		"briefing": "The sealed record identifies living witnesses in a nearby Conductor Vault who can explain the human cost behind the Empire's decision. Travel to the hospice and pass its guardians' assessment to speak with them.",
		"debriefing": "Inside the hospice, the first Conductors explain that their role was to share purpose, not command. They also reveal that the Wardens maintained dormant Relay programs after the Empire withdrew and insist the council answer why yours was activated."
	},
	70: {
		"chapter": "The Conductor Vault",
		"briefing": "The first Conductors reveal that the Wardens maintained dormant Relay programs and direct you to demand answers from their council. There, the Wardens admit your activation was a continuity test just as hired intermediaries arrive to destroy its records.",
		"debriefing": "The accident that changed your life was an experiment you never agreed to join. The Wardens accept responsibility, then argue that your survival proves Caelis finally has a viable successor and summon you to the Crown Relay."
	},
	71: {
		"chapter": "The Conductor Vault",
		"briefing": "Because the continuity test proved a new Conductor can survive, the Warden council summons you to the Crown Relay and offers succession over the Vault and eventually the Source. When you refuse, its honor guard moves to detain you.",
		"debriefing": "You escape the Crown Relay after rejecting solitary rule. Unable to install a successor, the Wardens agree to bring their claim into the open and petition Cassian's coalition for stewardship through negotiation instead."
	},
	# Chapter 14 — The Civic Core
	72: {
		"chapter": "The Civic Core",
		"briefing": "Unable to install you as a solitary successor, Caelis changes course and formally petitions Cassian's coalition for stewardship of the Source. The delegations gather at the Civic Core, where armed hardliners are trying to seize the council chambers first.",
		"debriefing": "The petition remains unresolved, but the disagreement has moved from power grids to a negotiating table. Keeping the chamber secure gives debate a chance to replace open warfare."
	},
	73: {
		"chapter": "The Civic Core",
		"briefing": "Caelian restorationists and faction hardliners have joined forces to destroy the talks before a compromise can emerge. Protect the negotiators, even though the final agreement is not yours to write.",
		"debriefing": "The alliance between both extremes exposes how much they each fear compromise. The talks survive, and you begin to understand the shifts in the room that Cassian has always noticed first."
	},
	74: {
		"chapter": "The Civic Core",
		"briefing": "Cassian is drafting the Accord while every proposed signatory presses for a final concession. Some have sent troops to strengthen their demands, so keep them away from the negotiating hall.",
		"debriefing": "The completed draft rests on shared laws rather than any hero's authority. Its final condition is practical: every signatory must send repair crews into the Source complex and prove the network can be restored under shared control."
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
		"debriefing": "With the armies finally standing together, the Warden who once watched you from the shadows names the conflict in memory of the dead from all five factions: the Resonance War."
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
