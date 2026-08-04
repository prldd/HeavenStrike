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
		"debriefing": "The patrons call it an industrial accident and discourage the survivors from speaking. That explanation leaves out two facts: you should not have survived, and the machines now respond to your thoughts."
	},
	4: {
		"chapter": "The Salvage",
		"briefing": "Fire is spreading through the lower galleries, and Cassian is trapped beyond the security line. Break through the remaining defenses and bring him out.",
		"debriefing": "Cassian leaves the site alive because of you, a debt he does not take lightly. The expedition's patrons close the site and declare the incident settled, but neither of you believes them."
	},
	# Chapter 2 — The Aftermath
	5: {
		"chapter": "The Aftermath",
		"briefing": "Salvage assessor Adele Voss is inspecting the site when looters breach the perimeter. Protect her crew and keep the recovered machines out of the raiders' hands.",
		"debriefing": "Adele saw you conduct the machines, and her report says so plainly. The patrons dislike its conclusions, which only makes officials across all five factions more eager to read it."
	},
	6: {
		"chapter": "The Aftermath",
		"briefing": "The expedition's patrons have arranged a public demonstration to prove the reclaimed machines are safe. When the exhibition is disrupted, protect the spectators and regain control of the field.",
		"debriefing": "The event was meant to quiet questions about the accident. Instead, images of the rescue make you famous, and invitations addressed to 'the Conductor's people' begin arriving on Cassian's desk."
	},
	7: {
		"chapter": "The Aftermath",
		"briefing": "A stranger claims the relay activation was deliberate and warns that its architects will come for their property. Moments later, armed crews close on your position. Fight your way clear.",
		"debriefing": "The stranger disappears before you can demand answers. The attackers knew the relay site's security routines and came prepared to find you alive."
	},
	8: {
		"chapter": "The Aftermath",
		"briefing": "A scavenger consortium has challenged the expedition's salvage claim and brought an armed crew to enforce its paperwork. Hold the stockyard until Cassian can answer the claim.",
		"debriefing": "Cassian proves the claim was forged, but not cheaply or carelessly. Someone with money and skilled agents is trying to take the relay salvage from you."
	},
	9: {
		"chapter": "The Aftermath",
		"briefing": "Raiders are following the convoy that carries the reclaimed machines to their new depot. Guard the transports and keep the route open.",
		"debriefing": "The convoy reaches the depot intact. Cassian uses your victory to secure passage rights from the same clans suspected of the attack, turning a safe arrival into a lasting agreement."
	},
	# Chapter 3 — Claims
	10: {
		"chapter": "Claims",
		"briefing": "Conductor registration requires a certified field evaluation. The examiners have supplied live opposition, so pass their test and try not to damage the testing grounds.",
		"debriefing": "You leave with a valid registration and a new designation in five government ledgers: strategic asset. Copies of your scores reach the examiners' patrons before you leave the grounds."
	},
	11: {
		"chapter": "Claims",
		"briefing": "Investigators have declared the depot and its machines evidence. Their armed escort is moving in to seize both, so defend the base while Cassian challenges the order.",
		"debriefing": "You keep the depot, but the official transcript calls it a dangerous armed compound that resisted a lawful inspection. Cassian begins keeping a private record alongside the official one."
	},
	12: {
		"chapter": "Claims",
		"briefing": "A supply convoy has been ambushed by raiders moving with military discipline. Break their line and recover anything that can identify who hired them.",
		"debriefing": "The attackers carried contractor equipment with every serial number removed. Cassian locks the evidence away; proof that cannot yet survive scrutiny may still become useful leverage."
	},
	13: {
		"chapter": "Claims",
		"briefing": "You have refused recruitment offers from three factions. Their answer is a surprise safety inspection backed by armed troops. Keep them out of the depot.",
		"debriefing": "Cassian sends a courteous reply to every rejected envoy, preserving relationships you had reason to close. At the depot, the oldest machines have begun following routines no one taught them."
	},
	14: {
		"chapter": "Claims",
		"briefing": "Adele has found an informant who can identify the contractors, but his handlers are watching him. Cover her team while they bring him out.",
		"debriefing": "The informant confirms that the ambush was staged, but his testimony cannot be used in court. Adele sees a dead end; Cassian sees information that may become useful later."
	},
	# Chapter 4 — The Proving
	15: {
		"chapter": "The Proving",
		"briefing": "An old transit bridge is failing beneath an evacuation column. Hold back the damaged security drones and keep the crossing open until every civilian is clear.",
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
		"debriefing": "The hearing enters your testimony into the record only after officials have edited it to support their own positions. What happened and what history records are already becoming different stories."
	},
	18: {
		"chapter": "The Proving",
		"briefing": "A respected officer has agreed to measure the limits of your Relay under controlled conditions. Demonstrate the squad's full strength, but do not ignore the strain on your own body.",
		"debriefing": "The evaluation is the first honest government report written about you. Its findings confirm your ability, then describe in clinical detail the damage that continued conducting may cause."
	},
	19: {
		"chapter": "The Proving",
		"briefing": "Automatons without a Conductor are threatening a nearby township as they repeat old defense routines. Protect the residents, even if some of the machines cannot be recovered.",
		"debriefing": "You save the township at the cost of valuable salvage. One surviving automaton follows the squad back to the depot, and Cassian quietly adds another place to the supply roster."
	},
	20: {
		"chapter": "The Proving",
		"briefing": "Families displaced from the township have made camp beside the depot. Someone is using the crowded camp as cover to reach your stockpiles, so protect both the refugees and the supplies.",
		"debriefing": "The refugees choose to remain near the depot, turning a temporary camp into a small neighborhood. Cassian begins drafting a charter that could give the settlement legal standing."
	},
	# Chapter 5 — Sanctuary
	21: {
		"chapter": "Sanctuary",
		"briefing": "The stranger's coordinates lead to a sanctuary built before the Empire's fall. Order archivists control the perimeter and refuse to admit your team, so secure access without damaging the site.",
		"debriefing": "The Order agrees to share the sanctuary after you prove you could have taken it by force. The lead archivist accepts the arrangement, though her attention remains fixed on your oldest machines."
	},
	22: {
		"chapter": "Sanctuary",
		"briefing": "Ancient custodial machines still guard the sanctuary's inner vault. Disable them without destroying the archive, then reach the records they protect.",
		"debriefing": "The maintenance logs continue for centuries after the Empire supposedly fell. They suggest that the Empire dismantled itself deliberately, and an unredacted transport manifest names one final destination: Caelis."
	},
	# Chapter 6 — The Arena
	23: {
		"chapter": "The Arena",
		"briefing": "The reclamation charter's first contract is to escort Order scholars through territory neither neighboring faction will police. Get the expedition safely across the border.",
		"debriefing": "The scholars arrive safely, giving the new charter its first successful contract. Cassian also notes which officials allowed the crossing and which favors they will expect in return."
	},
	24: {
		"chapter": "The Arena",
		"briefing": "All five factions have invited you to competing military exhibitions. Complete the demonstration circuit, and be ready when your hosts turn staged exercises into real tests.",
		"debriefing": "By attending every exhibition, you avoid accepting any single faction's offer. Cassian uses their competing bids to strengthen the charter while you see how openly they intend to bargain for your loyalty."
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
		"debriefing": "You leave the Circuit as its new champion. Before the celebration ends, Cassian turns the title into formal recognition of the charter, forcing the factions to deal with you as an independent party."
	},
	# Chapter 7 — Fault Lines
	30: {
		"chapter": "Fault Lines",
		"briefing": "Adele believes the raiders who attacked the depot were hired contractors. Escort her to their border camp and recover proof of who paid them.",
		"debriefing": "The recovered pay chits carry no signatures, but the contracting house used a guild seal Adele recognizes. She finally admits that she once worked for the same guild."
	},
	31: {
		"chapter": "Fault Lines",
		"briefing": "A dormant Caelian war engine has awakened beneath a Wind city. While faction officials argue over blame, stop the machine before it reaches the populated districts.",
		"debriefing": "The city survives, but the argument only grows louder. Each faction claims its doctrine could have prevented the disaster while quietly inspecting the ancient machines buried in its own territory."
	},
	32: {
		"chapter": "Fault Lines",
		"briefing": "Cassian's ceasefire summit is underway when attackers breach the security perimeter. Protect the delegates and keep the meeting hall from falling.",
		"debriefing": "The delegates survive, but the bombing ends the talks and claims members of their staffs. Hardliners in every faction benefit, and none accepts responsibility."
	},
	33: {
		"chapter": "Fault Lines",
		"briefing": "Power failures are spreading across two territories, and the hospitals are next in the cascade. Secure the local grid so repair crews can keep emergency power running.",
		"debriefing": "The failures appear to be spreading between separate Source fragments, though official reports blame severe weather. Cassian records which authorities supported the repairs and which tried to obstruct them."
	},
	34: {
		"chapter": "Fault Lines",
		"briefing": "Both sides of the border are launching retaliatory raids. One strike force is moving toward a civilian district, so intercept it before the fighting reaches the streets.",
		"debriefing": "The district is safe, but both governments condemn you for crossing the line and interfering. The residents whose homes are still standing offer a different account."
	},
	35: {
		"chapter": "Fault Lines",
		"briefing": "Two district grids are failing, and the only available repair crew cannot reach both in time. Secure the route to the district that can still be stabilized before winter.",
		"debriefing": "One district has power; the other now has a disaster around which its leaders can rally anger. There was no way to save both, but Cassian ensured that the final decision would be remembered as yours."
	},
	36: {
		"chapter": "Fault Lines",
		"briefing": "Faction leaders plan to announce that the infrastructure crisis is over, even as the grid continues to fail. Protect the gathering and the repair crews working beneath it.",
		"debriefing": "Everyone on the stage knew the grid was still failing, but the announcement proceeds as written. Afterward, Cassian tells you quietly, 'Institutions lie to survive. Remember who taught you that.'"
	},
	# Chapter 8 — Heroes and Costs
	37: {
		"chapter": "Heroes and Costs",
		"briefing": "The township you saved has invited the squad to a public welcome. An elderly caretaker claims to recognize one of your machines, but trouble reaches the celebration before she can explain.",
		"debriefing": "The caretaker remembers the machine's first Conductor, dead for sixty years. When she speaks the old name, the automaton stands at attention without any order from you."
	},
	38: {
		"chapter": "Heroes and Costs",
		"briefing": "A commune refuses to abandon its failing territory, and the relocation force is preparing to remove its residents at gunpoint. Hold the line between them until negotiations can resume.",
		"debriefing": "You protected the commune from an evacuation its residents never accepted. Coalition lawyers argue over whether you prevented an abuse or obstructed a rescue; the people who live there have already made up their minds."
	},
	39: {
		"chapter": "Heroes and Costs",
		"briefing": "A raid has trapped the depot convoy in a narrow pass. Break the encirclement and bring every member of the squad home.",
		"debriefing": "One of your oldest machines falls while covering the retreat. Its presence remains faintly in the Relay, carried by the squad and by you even after its body goes still."
	},
	40: {
		"chapter": "Heroes and Costs",
		"briefing": "The fallen automaton's chassis remains behind enemy lines. Take the squad back to the pass and recover it before the salvagers arrive.",
		"debriefing": "The chassis is back at the depot. You cannot restore what the squad lost, but the surviving machines understand that you returned for one of their own."
	},
	41: {
		"chapter": "Heroes and Costs",
		"briefing": "The Sanctuary archivist has decoded the Caelian transport records and insists on delivering her findings in person. Escort her past the groups trying to seize them.",
		"debriefing": "The records show that Caelis was not destroyed. All five founding factions agreed to erase it from their maps, leaving every modern account of the Empire incomplete by design."
	},
	42: {
		"chapter": "Heroes and Costs",
		"briefing": "The Stranger has returned with proof that your relay activation was arranged through patrons inside the coalition. Protect the meeting and secure the evidence.",
		"debriefing": "The evidence leads to people who welcomed you at their tables after the accident. Cassian reads the names twice, then sits in silence as he considers what they mean for the coalition."
	},
	43: {
		"chapter": "Heroes and Costs",
		"briefing": "Faction agents are pressuring the scavenger clans to join the war. Their leaders have agreed to discuss neutrality only after you prove your strength on their terms.",
		"debriefing": "The clans accept Cassian's neutrality agreement, depriving several factions of their usual hired muscle. Garrett sends his regards along with a carefully itemized bill for the negotiations."
	},
	44: {
		"chapter": "Heroes and Costs",
		"briefing": "Adele is confronting her former guild with the contractor pay chits. Escort her into the guildhall and keep her safe when its officers refuse to answer.",
		"debriefing": "The guild produces old authorizations that push responsibility higher instead of clearing anyone involved. Adele resigns in public, and Cassian offers her a place in the coalition before the day is over."
	},
	# Chapter 9 — Cores
	45: {
		"chapter": "Cores",
		"briefing": "All five factions are secretly adapting Source cores for military use. One core is being moved without proper security; seize it before any army can deploy it.",
		"debriefing": "The core is secure, but possession makes the coalition a military power in its own right. By keeping the weapon from everyone else, you have also given every faction a reason to come for you."
	},
	46: {
		"chapter": "Cores",
		"briefing": "Unity Day has drawn thousands of civilians into the capital. Armed extremists intend to turn the celebration into the start of an open war, so stop them before panic spreads through the streets.",
		"debriefing": "The coalition keeps the celebration from becoming a massacre, but the attack leaves the public frightened and suspicious. The extremists lose the field while gaining the fear they wanted."
	},
	47: {
		"chapter": "Cores",
		"briefing": "A hardliner faction has launched a coup and is moving on the council chambers tonight. Break its advance before the government falls.",
		"debriefing": "The coup fails, leaving its quieter supporters exposed and looking for protection. Cassian brings those moderates into negotiations before they can organize another attempt."
	},
	48: {
		"chapter": "Cores",
		"briefing": "Scans beneath the battlefield reveal a powered Caelian transit line. Clear the surface forces so the archivists can enter the station and trace its route.",
		"debriefing": "The line leads toward a place absent from every modern map, and its maintenance records are recent. Someone has kept the route operational."
	},
	49: {
		"chapter": "Cores",
		"briefing": "Three faction forces are converging outside a populated town, each treating the others as enemies. Hold the evacuation corridor, keep the civilians clear, and withdraw before the armies close in.",
		"debriefing": "The town is empty before the three armies collide, but the wider battle marks the beginning of open war. Cassian makes sure the official record distinguishes the ground you surrendered from the lives you saved."
	},
	50: {
		"chapter": "Cores",
		"briefing": "Cassian has persuaded several enemies to attempt a local truce. Defend the signing site beside troops you recently fought, and give their leaders time to finish the agreement.",
		"debriefing": "The truce holds because former enemies enforce it together. Garrett the Claw keeps his assigned sector secure and politely declines to compare his results with yours."
	},
	51: {
		"chapter": "Cores",
		"briefing": "Several of your oldest machines have begun refusing aggressive orders as earlier routines surface through the Relay. Deploy with them and learn which commands they will still accept.",
		"debriefing": "The machines still defend people, protect one another, and hold their ground, but they will no longer destroy simply because they are told. Their refusal forces you to consider what a Conductor owes the minds joined to the Relay."
	},
	52: {
		"chapter": "Cores",
		"briefing": "A three-party negotiation has collapsed into a staged show of force. Cassian needs you to yield the disputed ground without humiliating either delegation, so control the fight and withdraw on his signal.",
		"debriefing": "Your withdrawal gives Cassian the opening he needs to preserve the talks. Only afterward do you realize he committed your squad to the plan without first asking you."
	},
	# Chapter 10 — Breaking Point
	53: {
		"chapter": "Breaking Point",
		"briefing": "Source fragments are synchronizing without their operators, causing blackouts and waking dormant machines across the district. Protect the repair teams while they contain the cascade.",
		"debriefing": "Order scholars confirm that no faction initiated the synchronization. The network is not attacking; it is responding to the war, as though some larger system has become aware of it."
	},
	54: {
		"chapter": "Breaking Point",
		"briefing": "The blackouts have opened a detention center for registered Conductors. Reach the facility before security forces retake it and bring the detainees out alive.",
		"debriefing": "One freed Conductor asks whether the law now considers them an asset, a prisoner, or a person. You cannot answer, so Cassian begins drafting a legal status that can."
	},
	55: {
		"chapter": "Breaking Point",
		"briefing": "A full-scale offensive has opened across three fronts, and the coalition has no other force able to intercept each breakthrough. Keep moving for as long as the Relay can bear the strain.",
		"debriefing": "Medical staff refuse to clear you for another deployment, but the front would have broken if you had stayed behind. The machines now place themselves between you and incoming fire without being ordered."
	},
	56: {
		"chapter": "Breaking Point",
		"briefing": "Assassins are targeting coalition delegates one at a time. Move the remaining representatives to a secure location and eliminate the teams hunting them.",
		"debriefing": "The delegates survive because Cassian's informants identify the assassins before they can strike again. He then shows you the full network, far larger than he ever admitted, without waiting to be asked."
	},
	57: {
		"chapter": "Breaking Point",
		"briefing": "A public tribunal has convened to decide who should govern the Source. Armed groups from several sides are trying to silence the debate, so keep the chamber standing until every delegation is heard.",
		"debriefing": "Every proposal draws violence from a different direction, proving that no claimant can impose an answer safely. The tribunal settles nothing, but it makes clear why a shared settlement is necessary."
	},
	58: {
		"chapter": "Breaking Point",
		"briefing": "Fighting has reached the western districts above the Caelian conduits. A royalist guard still controls the underground gates under an ancient charter, and it demands a formal trial before granting passage.",
		"debriefing": "The gatekeepers accept the result and admit the coalition as the first authority in two centuries to honor their procedure. Their charter bears the seal of Caelis and has never legally expired."
	},
	59: {
		"chapter": "Breaking Point",
		"briefing": "Long-range batteries are firing on the buried conduit network. Break through their defenses and disable the guns before the next barrage severs the route.",
		"debriefing": "The conduits survive the night, though every army involved can eventually replace the destroyed batteries. You have bought repair crews time, not ended the threat."
	},
	60: {
		"chapter": "Breaking Point",
		"briefing": "Minerva has assembled former Grand Circuit rivals into the coalition's first joint strike team. Fight beside them to secure the conduit route.",
		"debriefing": "Minerva proves as dependable an ally as she was an opponent. Whatever Cassian chooses to call it, the coalition now has a disciplined force of its own."
	},
	61: {
		"chapter": "Breaking Point",
		"briefing": "The conduit maps reveal a single route beyond the known network. Secure the passage and reach the person waiting at its far end.",
		"debriefing": "The Stranger finally identifies themself as a Warden of Caelis, sent to bring the accidental Conductor to the hidden city. The request is presented as an invitation, but refusal is clearly not expected."
	},
	62: {
		"chapter": "Breaking Point",
		"briefing": "Armies from all five factions have reached the gate of Caelis at once. Hold the approach long enough for Cassian to establish a neutral delegation and keep the war outside the city.",
		"debriefing": "Cassian arrives at the head of a coalition delegation rather than another invading army. For the first time in living memory, the gates of Caelis open to the outside world."
	},
	# Chapter 11 — The Outer City
	63: {
		"chapter": "The Outer City",
		"briefing": "The Wardens of Caelis will admit the delegation only after inspecting you and your machines under an ancient emergency protocol. Submit to their field test and show that the squad is under control.",
		"debriefing": "The Wardens classify you as an unregistered Conductor with an unauthorized Relay. They grant entry despite the violation, deciding that the first new Conductor in centuries deserves further study."
	},
	64: {
		"chapter": "The Outer City",
		"briefing": "Caelis's Outer City is clean, powered, and almost entirely empty. Its caretakers still enforce rules written for citizens who never returned, and they identify your delegation as trespassers.",
		"debriefing": "The caretakers have maintained an empty city for generations, waiting for a population that will not return. Your oldest machines seem to understand what that long duty has cost them."
	},
	65: {
		"chapter": "The Outer City",
		"briefing": "The Wardens will not permit an unsanctioned Conductor beyond the Outer City. To earn passage, defend a maintenance district without taking control of the machines assigned to it.",
		"debriefing": "By protecting the district without claiming its machines, you demonstrate that conducting can be an act of stewardship. The Wardens record the result and unlock the inner gates."
	},
	# Chapter 12 — The Imperial Archive
	66: {
		"chapter": "The Imperial Archive",
		"briefing": "The Imperial Archive contains an unedited account of the Empire's final years. Its custodial defenses deny access to Wardens and outsiders alike, so disable them without damaging the records.",
		"debriefing": "The archive records a Source crisis, a vote to divide the network, and an organized destruction of public history. The Empire's final decision was that no single power could safely control the whole system again."
	},
	67: {
		"chapter": "The Imperial Archive",
		"briefing": "Five archive rooms preserve the original records behind each faction's founding story. Rival claimants have entered the complex to destroy evidence that weakens their own version of history. Protect the collection.",
		"debriefing": "The records show that each faction preserved a real strength of the old system: Coal its discipline, Steam its industry, Solar its faith, Wind its freedom, and Fusion its ambition. Each mistook one part of the inheritance for the whole."
	},
	68: {
		"chapter": "The Imperial Archive",
		"briefing": "The archive's deepest vault holds the evidence that led the Empire to fragment the Source. Its guardians were designed specifically to resist Conductors, so reach the sealed record without releasing it beyond the vault.",
		"debriefing": "The sealed record explains the original crisis and why its full details could still destabilize every faction. Cassian understands from your expression that some truths cannot yet be made public, and postpones his questions."
	},
	# Chapter 13 — The Conductor Vault
	69: {
		"chapter": "The Conductor Vault",
		"briefing": "The Conductor Vault is a hospice for the Empire's first Conductors, kept alive long after their service ended. Its guardians will allow entry only if you can pass their assessment.",
		"debriefing": "Inside the hospice, you meet Conductors living with the same damage your doctors warned about. They explain that their role was never to command machines, but to share purpose with them and keep them company."
	},
	70: {
		"chapter": "The Conductor Vault",
		"briefing": "The Wardens admit that your relay activation was a continuity test arranged through outside patrons who never knew their true client. Some of their hired intermediaries have followed you to Caelis to destroy the evidence.",
		"debriefing": "The accident that changed your life was an experiment you never agreed to join. The Wardens accept responsibility for ordering it, while Cassian gains proof against the patrons who helped carry it out."
	},
	71: {
		"chapter": "The Conductor Vault",
		"briefing": "The Wardens offer you authority over the Vault and, eventually, the Source itself. When you refuse, their honor guard moves to detain you until a successor can be secured.",
		"debriefing": "The offer was sincere, but accepting it would only place the old system under a new solitary ruler. You leave the Vault convinced that the world needs shared institutions, not another permanent Warden."
	},
	# Chapter 14 — The Civic Core
	72: {
		"chapter": "The Civic Core",
		"briefing": "Caelis has formally petitioned to resume stewardship of the Source. Cassian's coalition has come to debate the request, but armed hardliners are attempting to seize the council chambers first.",
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
		"debriefing": "The completed draft rests on shared laws rather than any hero's authority, and your name appears nowhere in it. That absence means the peace can survive without depending on you."
	},
	# Chapter 15 — The Source
	75: {
		"chapter": "The Source",
		"briefing": "As its fragments reconnect, the Source reveals itself as a network that balances power rather than simply producing it. Its defenses cannot distinguish the coalition's repair crews from another group trying to seize control.",
		"debriefing": "Separated, each Source fragment can become a weapon or fail catastrophically. Connected and jointly governed, the network can once again support an entire civilization."
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
