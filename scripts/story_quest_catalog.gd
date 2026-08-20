class_name StoryQuestCatalog
extends RefCounted

const MissionRulesScript = preload("res://scripts/mission_rules.gd")

# Authored reward cadence. Mission keys are stable because campaign saves use
# the mission index, and rewards should remain deterministic across updates.
# Add units only when the authored reward plan assigns them to that mission.
const ADDITIONAL_DROPS := {
	"Relay Bastion-030": [16, 35],
	"Cinder Blade-036": [24, 42],
	"Zephyr Lancer-042": [32, 44],
	"Flux Weaver-047": [40, 57],
	"Helio Mender-048": [48, 62],
	"Helio Mender-049": [3, 13, 14, 19, 27, 37, 38, 45],
	"Helio Mender-050": [10, 13, 17, 23, 27, 37, 38, 45],
	"Flux Bastion-053": [18],
	"Flux Bastion-054": [18],
	"Cinder Battery-063": [9, 50],
	"Cinder Battery-064": [50],
	"Cinder Battery-066": [53, 59, 61],
	"Cinder Battery-067": [53, 59, 61],
	"Cinder Lancer-069": [14],
	"Zephyr Blade-075": [19, 34, 35, 50, 52, 55, 58],
	"Zephyr Blade-076": [15, 34, 35, 50, 52, 55, 58],
	"Relay Bastion-013": [11, 12, 14, 17, 23, 32, 37, 46, 48],
	"Cinder Blade-015": [3, 8, 9, 15, 20, 23, 28, 30, 42, 62],
	"Cinder Lancer-017": [8, 9, 42, 43, 46, 47, 52],
	"Flux Battery-019": [20, 35, 62],
	"Relay Weaver-021": [21, 22, 24, 41, 53],
	"Zephyr Mender-023": [21, 22, 24, 53],
	"Flux Lancer-025": [28, 29, 41, 54, 57],
	"Helio Weaver-026": [2, 18, 25, 49, 51],
	"Flux Mender-027": [25, 39, 40, 60, 62],
	"Relay Bastion-014": [11, 12, 32, 37, 46],
	"Cinder Lancer-018": [8, 16, 19, 42, 43, 46, 47, 48, 52],
	"Flux Battery-020": [15, 17, 20, 35, 62],
	"Relay Weaver-022": [21, 22, 24, 41, 53],
	"Zephyr Mender-024": [21, 22, 24, 53],
	"Flux Lancer-031": [28, 29, 41, 54, 57],
	"Helio Weaver-032": [18, 25, 49, 51],
	"Flux Mender-033": [25, 39, 40, 60, 62],
	"Zephyr Lancer-037": [4, 7, 43, 51],
	"Zephyr Lancer-038": [43, 51],
	"Brass Lancer-043": [23, 27, 38, 44, 60],
	"Brass Lancer-044": [13, 14, 27, 38, 44, 60],
	"Flux Weaver-045": [7, 28, 33, 57, 59, 61],
	"Flux Weaver-046": [28, 33, 57, 59, 61],
	"Helio Blade-081": [14, 15, 30, 31, 36, 40, 47, 48],
	"Helio Blade-082": [9, 30, 31, 36, 40, 47],
	"Brass Battery-083": [15, 20, 33, 42, 56, 58, 59, 61],
	"Brass Battery-084": [20, 33, 42, 56, 58, 59, 61],
	"Relay Blade-085": [35],
	"Relay Blade-086": [35],
	"Zephyr Battery-088": [10, 26, 32, 39, 40, 44, 49, 60],
	"Zephyr Battery-089": [10, 23, 26, 32, 39, 40, 44, 49, 60],
	"Cinder Weaver-090": [27, 29, 37, 41, 45],
	"Cinder Weaver-091": [27, 29, 37, 41, 45],
	"Flux Weaver-092": [21, 22, 24, 56],
	"Flux Weaver-093": [21, 22, 24, 56],
	"Brass Bastion-104": [38],
	"Brass Bastion-105": [38],
	"Brass Bastion-111": [10, 34, 50, 56, 62],
	"Brass Bastion-112": [19, 34, 50, 56, 62],
	"Zephyr Bastion-113": [20, 44, 49],
	"Zephyr Bastion-114": [44, 49],
	"Cinder Weaver-115": [36],
	"Cinder Weaver-116": [36],
	"Brass Blade-117": [16, 33, 55, 58],
	"Brass Blade-118": [33, 55, 58],
	"Helio Mender-126": [42, 54],
	"Helio Mender-127": [42, 54],
	"Zephyr Mender-208": [8, 9, 12, 13, 26, 30, 31, 36, 43, 45],
	"Zephyr Mender-209": [8, 12, 26, 30, 31, 36, 43, 45, 48],
	"Cinder Mender-213": [11, 47],
	"Cinder Mender-214": [47],
	"Relay Battery-217": [18, 33],
	"Relay Battery-218": [45],
	"Cinder Bastion-219": [26, 40],
	"Cinder Bastion-220": [55],
	"Zephyr Lancer-221": [22, 37],
	"Zephyr Lancer-222": [51],
	"Helio Mender-223": [30, 44],
	"Helio Mender-224": [60],
	"Cinder Blade-225": [33, 56],
	"Flux Weaver-226": [35, 58],
	"Brass Battery-227": [37, 60],
	"Helio Bastion-228": [39, 62],
	"Cinder Bastion-229": [41, 64],
	"Zephyr Lancer-230": [24, 46],
	"Flux Weaver-231": [67, 74],
	"Helio Battery-232": [43, 66],
	"Brass Mender-233": [45, 68],
	"Zephyr Blade-234": [21, 43],
	"Cinder Lancer-235": [70, 76],
	"Helio Mender-236": [28, 49],
	"Cinder Bastion-237": [38, 59],
	"Cinder Mender-238": [40, 61],
	"Cinder Weaver-239": [42, 63],
	"Brass Battery-240": [20, 42],
	"Brass Blade-241": [23, 45],
	"Brass Lancer-242": [25, 49],
	"Zephyr Lancer-243": [44, 65],
	"Zephyr Mender-244": [27, 48],
	"Zephyr Blade-245": [29, 50],
	"Flux Weaver-246": [68, 75],
	"Flux Battery-247": [31, 52],
	"Flux Lancer-248": [46, 66],
	"Helio Bastion-249": [32, 53],
	"Helio Weaver-250": [34, 54],
	"Helio Mender-251": [36, 55],
	"Cinder Blade-252": [37, 60],
	"Brass Blade-253": [39, 62],
	"Cinder Lancer-254": [41, 64],
	"Brass Battery-255": [22, 44],
	"Flux Lancer-256": [46, 66],
	"Flux Weaver-257": [48, 68],
	"Cinder Weaver-258": [50, 70],
	"Zephyr Lancer-259": [26, 48],
	"Brass Bastion-260": [52, 71],
	"Cinder Bastion-261": [54, 72],
	"Helio Bastion-262": [30, 52],
	"Flux Weaver-263": [56, 73],
	"Cinder Weaver-264": [58, 74],
	"Cinder Weaver-265": [69, 76],
	"Flux Weaver-266": [70, 77],
	"Brass Lancer-267": [33, 55],
	"Helio Mender-268": [75, 77],
	"Zephyr Mender-269": [28, 50],
	"Brass Blade-270": [35, 57],
	"Flux Lancer-271": [72, 77],
	"Flux Weaver-272": [60, 75],
	"Helio Weaver-273": [36, 56],
	"Brass Mender-274": [24, 46],
	"Zephyr Weaver-275": [73, 76],
	"Cinder Battery-276": [23, 45],
	"Brass Battery-277": [25, 43],
	"Cinder Blade-278": [42, 63],
	"Helio Mender-279": [27, 49],
	"Helio Mender-280": [70, 76],
	"Cinder Weaver-281": [71, 77],
	"Cinder Battery-282": [44, 65],
	"Zephyr Lancer-283": [50, 67],
	"Zephyr Lancer-284": [49, 69],
	"Zephyr Weaver-285": [29, 51],
	"Cinder Bastion-286": [31, 53],
	"Flux Battery-287": [51, 70],
	"Helio Weaver-288": [53, 71],
	"Helio Bastion-289": [73, 77],
	"Brass Bastion-290": [72, 76],
	"Zephyr Blade-291": [74, 77],
	"Flux Weaver-292": [55, 72],
	"Cinder Mender-293": [75, 77]
}

# Every pool carries at least three 1-star units so the weighted roll in
# CampaignStore keeps 4-star and higher drops rare while farming stays viable.
const QUESTS := [
	["Act 1 Mission 1 - First Synchrony", ["Relay Lancer-003", "Relay Battery-004", "Relay Bastion-001"]],
	["Act 1 Mission 2 - Formation Trial", ["Relay Mender-006", "Relay Weaver-011", "Relay Blade-002"]],
	["Act 1 Mission 3 - The Second Pulse", ["Relay Bastion-001", "Relay Blade-002", "Relay Lancer-003"]],
	["Act 1 Mission 4 - Sealed Ignition", ["Relay Battery-004", "Relay Weaver-005", "Relay Mender-006"]],
	["Act 1 Mission 5 - Independent Witness", ["Relay Weaver-011", "Relay Bastion-007", "Relay Blade-008"]],
	["Act 1 Mission 6 - Public Demonstration", ["Relay Mender-006", "Relay Lancer-009", "Relay Battery-010"]],
	["Act 1 Mission 7 - Dead-Channel Warning", ["Relay Bastion-007", "Relay Blade-008", "Relay Lancer-009"]],
	["Act 1 Mission 8 - Salvage Claim", ["Relay Weaver-005", "Relay Lancer-009", "Relay Bastion-001"]],
	["Act 1 Mission 9 - Passage Rights", ["Relay Weaver-005", "Relay Lancer-009", "Relay Blade-002"]],
	["Act 1 Mission 10 - Licensed Resistance", ["Relay Bastion-001", "Relay Blade-002", "Relay Battery-010"]],
	["Act 1 Mission 11 - Depot Under Seal", ["Relay Lancer-003", "Relay Mender-006", "Relay Blade-008", "Relay Lancer-009"]],
	["Act 1 Mission 12 - The Unmarked Route", ["Relay Blade-002", "Relay Lancer-009", "Relay Battery-010"]],
	["Act 1 Mission 13 - Terms Refused", ["Relay Blade-002", "Relay Weaver-005", "Relay Battery-010"]],
	["Act 1 Mission 14 - Safehouse Extraction", ["Relay Blade-002", "Relay Weaver-005", "Relay Lancer-003"]],
	["Act 1 Mission 15 - Failing Span", ["Relay Battery-004", "Relay Weaver-011", "Relay Mender-006"]],
	["Act 1 Mission 16 - Public Challenge", ["Relay Blade-008", "Relay Lancer-009", "Relay Battery-010", "Relay Weaver-011"]],
	["Act 1 Mission 17 - The Cost of Victory", ["Relay Bastion-001", "Relay Blade-002", "Relay Blade-008", "Relay Weaver-011"]],
	["Act 1 Mission 18 - Field Certification", ["Relay Bastion-001", "Relay Lancer-003", "Relay Battery-004", "Relay Blade-008"]],
	["Act 1 Mission 19 - Feral Signal", ["Relay Battery-004", "Relay Weaver-005", "Relay Lancer-009"]],
	["Act 1 Mission 20 - Charter Ground", ["Relay Bastion-001", "Relay Lancer-003", "Relay Weaver-011"]],
	["Act 1 Mission 21 - Sanctuary Threshold", ["Relay Mender-006", "Relay Bastion-007", "Relay Mender-012"]],
	["Act 1 Mission 22 - Archive Breach", ["Relay Mender-006", "Relay Bastion-007", "Relay Mender-012"]],
	["Act 2 Mission 23 - Border Contract", ["Relay Blade-002", "Relay Weaver-011", "Relay Bastion-001"]],
	["Act 2 Mission 24 - Exhibition Match", ["Relay Mender-006", "Relay Bastion-007", "Relay Mender-012"]],
	["Act 2 Mission 25 - Circuit Opening", ["Relay Lancer-003", "Relay Battery-004", "Relay Weaver-005", "Relay Blade-008"]],
	["Act 2 Mission 26 - Crowd Favorite", ["Relay Bastion-001", "Relay Weaver-005", "Relay Lancer-009"]],
	["Act 2 Mission 27 - Fixed Odds", ["Relay Bastion-001", "Relay Blade-002", "Relay Battery-010"]],
	["Act 2 Mission 28 - Honest Contest", ["Relay Weaver-011", "Relay Mender-012", "Relay Battery-004"]],
	["Act 2 Mission 29 - Championship Point", ["Relay Mender-006", "Relay Battery-010", "Relay Mender-012"]],
	["Act 2 Mission 30 - Paper Trail", ["Relay Blade-002", "Relay Weaver-011", "Relay Weaver-005"]],
	["Act 2 Mission 31 - Engine Below", ["Relay Weaver-005", "Relay Lancer-009", "Relay Weaver-011"]],
	["Act 2 Mission 32 - Summit Breach", ["Relay Bastion-001", "Relay Blade-002", "Relay Lancer-009"]],
	["Act 2 Mission 33 - Fragment Wake", ["Relay Mender-006", "Relay Bastion-007", "Relay Mender-012"]],
	["Act 2 Mission 34 - Border Retaliation", ["Relay Mender-006", "Relay Bastion-007", "Relay Mender-012"]],
	["Act 2 Mission 35 - One Grid, Two Districts", ["Relay Mender-006", "Relay Bastion-007", "Relay Mender-012"]],
	["Act 2 Mission 36 - The Official Broadcast", ["Relay Weaver-005", "Relay Lancer-009", "Relay Weaver-011"]],
	["Act 2 Mission 37 - Return to the Township", ["Relay Blade-002", "Relay Weaver-005", "Relay Battery-010"]],
	["Act 2 Mission 38 - Forced Relocation", ["Relay Blade-002", "Relay Lancer-009", "Relay Battery-010"]],
	["Act 2 Mission 39 - Pass Intercept", ["Relay Bastion-001", "Relay Lancer-003", "Relay Battery-004", "Relay Blade-008"]],
	["Act 2 Mission 40 - The Last Chassis", ["Relay Bastion-001", "Relay Weaver-005", "Relay Lancer-009"]],
	["Act 2 Mission 41 - Contested Records", ["Relay Lancer-003", "Relay Battery-004", "Relay Mender-006"]],
	["Act 2 Mission 42 - Patron's Reach", ["Relay Bastion-007", "Relay Mender-012", "Relay Mender-006"]],
	["Act 2 Mission 43 - Clan Terms", ["Relay Weaver-005", "Relay Lancer-009", "Relay Weaver-011"]],
	["Act 2 Mission 44 - Guild Reckoning", ["Relay Bastion-001", "Relay Blade-002", "Relay Battery-010"]],
	["Act 2 Mission 45 - Core in Transit", ["Relay Blade-002", "Relay Weaver-005", "Relay Lancer-009"]],
	["Act 2 Mission 46 - Unity Day", ["Relay Weaver-005", "Relay Lancer-009", "Relay Bastion-001"]],
	["Act 2 Mission 47 - The Coup", ["Relay Weaver-005", "Relay Lancer-009", "Relay Blade-002"]],
	["Act 2 Mission 48 - Rearguard", ["Relay Weaver-005", "Relay Lancer-009", "Relay Lancer-003"]],
	["Act 2 Mission 49 - Three Fronts", ["Relay Bastion-001", "Relay Lancer-003", "Relay Battery-004"]],
	["Act 2 Mission 50 - Truce Line", ["Relay Mender-006", "Relay Bastion-007", "Relay Mender-012"]],
	["Act 2 Mission 51 - Coalition Trial", ["Relay Bastion-001", "Relay Weaver-005", "Relay Blade-008", "Relay Lancer-009"]],
	["Act 2 Mission 52 - Managed Retreat", ["Relay Blade-002", "Relay Weaver-005", "Relay Battery-010"]],
	["Act 2 Mission 53 - Network Answer", ["Relay Mender-006", "Relay Bastion-007", "Relay Mender-012"]],
	["Act 2 Mission 54 - Intake Blockade", ["Relay Mender-006", "Relay Bastion-007", "Relay Mender-012"]],
	["Act 2 Mission 55 - Counteroffensive", ["Relay Mender-006", "Relay Bastion-007", "Relay Mender-012"]],
	["Act 2 Mission 56 - The Assassins", ["Relay Mender-006", "Relay Bastion-007", "Relay Mender-012"]],
	["Act 2 Mission 57 - Tribunal Under Fire", ["Relay Mender-006", "Relay Bastion-007", "Relay Mender-012"]],
	["Act 2 Mission 58 - Royalist Gate", ["Relay Mender-006", "Relay Bastion-007", "Relay Mender-012"]],
	["Act 2 Mission 59 - Battery Night", ["Relay Mender-006", "Relay Bastion-007", "Relay Mender-012"]],
	["Act 2 Mission 60 - Joint Formation", ["Relay Bastion-001", "Relay Blade-002", "Relay Battery-010"]],
	["Act 2 Mission 61 - The Maintained Route", ["Relay Mender-006", "Relay Bastion-007", "Relay Mender-012"]],
	["Act 2 Mission 62 - Caelis Approach", ["Relay Bastion-007", "Relay Weaver-011", "Relay Mender-006"]],
	# Season Three (Act 3) expands the Caelis campaign arc;
	# reward pools use REWARD_UNITS that previously had no story drops.
	["Act 3 Mission 63 - Outer Inspection", ["Brass Bastion-136", "Brass Bastion-137", "Relay Bastion-001", "Relay Blade-002", "Relay Lancer-003"]],
	["Act 3 Mission 64 - City Still Running", ["Cinder Mender-148", "Cinder Mender-149", "Relay Battery-004", "Relay Weaver-005", "Relay Mender-006"]],
	["Act 3 Mission 65 - Stewardship Trial", ["Relay Blade-156", "Relay Blade-157", "Relay Bastion-007", "Relay Blade-008", "Relay Lancer-009"]],
	["Act 3 Mission 66 - The Buried Record", ["Relay Blade-121", "Relay Blade-122", "Relay Battery-010", "Relay Weaver-011", "Relay Mender-012"]],
	["Act 3 Mission 67 - Fivefold Claim", ["Helio Mender-123", "Helio Mender-124", "Helio Mender-125", "Relay Bastion-001", "Relay Blade-002", "Relay Lancer-003"]],
	["Act 3 Mission 68 - Deep Archive", ["Helio Bastion-128", "Helio Bastion-129", "Relay Battery-004", "Relay Weaver-005", "Relay Mender-006"]],
	["Act 3 Mission 69 - Living Witnesses", ["Helio Mender-142", "Helio Mender-143", "Relay Bastion-007", "Relay Blade-008", "Relay Lancer-009"]],
	["Act 3 Mission 70 - The Relay Experiment", ["Helio Mender-162", "Helio Mender-163", "Relay Battery-010", "Relay Weaver-011", "Relay Mender-012"]],
	["Act 3 Mission 71 - Crown Continuity", ["Relay Blade-146", "Relay Blade-147", "Relay Bastion-001", "Relay Blade-002", "Relay Lancer-003"]],
	["Act 3 Mission 72 - Civic Petition", ["Zephyr Lancer-144", "Zephyr Lancer-145", "Relay Battery-004", "Relay Weaver-005", "Relay Mender-006"]],
	["Act 3 Mission 73 - Extremes Aligned", ["Relay Blade-164", "Relay Blade-165", "Relay Bastion-007", "Relay Blade-008", "Relay Lancer-009"]],
	["Act 3 Mission 74 - Accord Draft", ["Helio Lancer-130", "Helio Lancer-131", "Relay Battery-010", "Relay Weaver-011", "Relay Mender-012"]],
	["Act 3 Mission 75 - Source Balance", ["Helio Bastion-134", "Helio Bastion-135", "Relay Bastion-001", "Relay Blade-002", "Relay Lancer-003"]],
	["Act 3 Mission 76 - Rejection Line", ["Cinder Bastion-166", "Cinder Bastion-167", "Relay Battery-004", "Relay Weaver-005", "Relay Mender-006"]],
	["Act 3 Mission 77 - The Caelis Accord", ["Brass Weaver-158", "Brass Weaver-159", "Helio Mender-160", "Helio Mender-161", "Relay Bastion-007", "Relay Blade-008", "Relay Lancer-009"]]
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
		"briefing": "Two of the automatons we pulled from the lower galleries are walking again, and the patrons want proof the dig is worth their money before they fund the next phase. Run them along the relay site perimeter and put them through a live drill. If they do anything the manuals don't cover, I hear it from you first.",
		"debriefing": "The drill goes clean. Too clean. One of the machines moved half a second before your signal reached it. Cassian logs a success for the patrons, then seals the site to outside crews until the expedition knows what it has actually found. Off the record, he has started asking why the dig's funding arrived so quickly."
	},
	2: {
		"chapter": "The Salvage",
		"briefing": "Two more machines woke overnight. That makes four. Tomorrow the patrons fire the relay itself: full activation, sealed test, their observers on the roster. Today belongs to us. Form the squad up and lean on the control link until it complains. If anything down here wants to surprise us, it can do it now.",
		"debriefing": "The link holds through everything we throw at it, and it shouldn't. Nobody has guided this many machines since the Empire, and nobody living is certified to try. None of that goes in the report. In his private ledger, Cassian writes one word beside your name and doesn't say it out loud: Conductor."
	},
	3: {
		"chapter": "The Salvage",
		"briefing": "The relay fired early, hours ahead of schedule, nobody at the controls. The surge collapsed the lower gallery and tripped the site's Caelian security machines, and they are cutting our crew off from the exits. Hold the security line and get our people out.",
		"debriefing": "Most of the crew reaches the upper gallery. Cassian's locator is still pulsing below the fire line. Three tons of stone came down on you and you walked out, and when you turned back for him, every machine turned with you, unasked. The relay is still humming, and no test schedule explains what it did to you."
	},
	4: {
		"chapter": "The Salvage",
		"briefing": "The lower galleries are burning, and Cassian is trapped behind the security cordon. The site's warden core is still enforcing it, three hundred years dead or not. Break the line and bring him out. Nobody stays in a tomb we opened.",
		"debriefing": "You bring Cassian out breathing. He doesn't say thank you; he starts writing. When the patrons' director arrives to seal the site and call the matter settled, Cassian is waiting at the gate with the salvage contract in hand and a clause that forces an independent assessment before anyone removes so much as a bolt."
	},
	# Chapter 2 — The Aftermath
	5: {
		"chapter": "The Aftermath",
		"briefing": "Cassian's contract clause worked: salvage assessor Lysa Vey is walking the sealed site, independent and unimpressed. Word of waking machines has spread, and a looters' crew is breaching the perimeter mid-inspection. Keep her team alive and the recovered machines out of their hands. Her report is all that's between this dig and the patrons' seals.",
		"debriefing": "Lysa's crew survives, and so does every machine she came to count. Her assessment stays open, and the patrons can't seal a site an independent assessor is still walking. Their answer arrives by courier: Director Rusk's office announces a public demonstration to prove the reclaimed machines are perfectly safe."
	},
	6: {
		"chapter": "The Aftermath",
		"briefing": "Director Rusk has sold the capital a morning of perfectly safe reclaimed machinery, and you're the demonstration. The grandstands are full, and someone in them doesn't want the show to go well. Lysa's people caught a saboteur crew at the staging. When it goes wrong, protect the crowd first and the patrons' story second.",
		"debriefing": "The sabotage turns Rusk's publicity into yours: the footage everyone shares is you holding the field while the crowd runs. Invitations flood Cassian's desk. One bears no seal, only a request to meet on the depot roof, from someone who claims to know why the Relay woke. Cassian advises against going. He notes you'll go."
	},
	7: {
		"chapter": "The Aftermath",
		"briefing": "The stranger on the roof says the relay fired on purpose, and that whoever lit it is coming to collect their property. She's right on schedule: a retrieval crew is cutting the depot's perimeter already, equipped to take you alive and briefed on our security routines. Don't let them.",
		"debriefing": "The retrieval crew withdraws empty-handed, but it knew the patrol rotations, the gate codes, and which machine to take first. Cassian locks the incident report in his private ledger. By morning the sponsors try law instead of force: a scavenger consortium files a competing claim on the expedition's salvage."
	},
	8: {
		"chapter": "The Aftermath",
		"briefing": "The scavenger consortium's claim comes with an enforcement crew already in the stockyard, paperwork in one hand, pry bars in the other. Hold the yard while I pull their filing apart against the original contract. If their claim is forged, I want it to have been forged expensively.",
		"debriefing": "Cassian proves the claim forged, skillfully forged, which is its own kind of evidence. The yard is compromised now, and the next attempt is a matter of patience, not doubt. He orders the Relay machines moved to a defensible depot beyond scavenger territory. The scavenger clans watch the convoy form up and start counting."
	},
	9: {
		"chapter": "The Aftermath",
		"briefing": "The clans are shadowing the convoy, and their raider chief will make his try in the pass ahead. Stay on the flanks, keep the transports rolling, and don't let them drag a single machine off the road. Everything we pulled out of that site is on those trucks.",
		"debriefing": "The convoy reaches the new depot intact, and Cassian buys passage rights from the clans with the footage of their chief losing. The base is defensible now, and conspicuous. Running it openly takes the one credential nobody sells: a Conductor registration, stamped by a licensing hall, in a world with no living Conductors."
	},
	# Chapter 3 — Claims
	10: {
		"chapter": "Claims",
		"briefing": "No license means the depot counts as unregistered Relay equipment, and unregistered Relay equipment gets seized. The registry will certify you as an operator, the only box its forms have. The licensing examiner has arranged live opposition for the field evaluation. Pass it, and notice who's scoring you.",
		"debriefing": "You leave certified as an operator, because the registry has no form for what you are. Before the ink dries, the Joint Investigative Office cites your own evaluation in an evidence order: the depot and its machines are to be seized as material in an open inquiry. Their evidence detail is already mustering."
	},
	11: {
		"chapter": "Claims",
		"briefing": "The Joint Investigative Office's evidence detail is at the gates with a seizure order and an armed escort. Cassian is shredding their jurisdiction line by line, but paper moves slower than troops. Hold the depot. And understand: everything you do here will be read back to us as a confession.",
		"debriefing": "The depot holds, and the official transcript turns the defense into proof: an armed compound resisting lawful inspection. No deliveries reach us under the seizure order. Cassian starts a private record of every falsification and routes essential supplies along an unmarked back road, a route known to a very short list of people."
	},
	12: {
		"chapter": "Claims",
		"briefing": "The unmarked route leaked. The supply convoy is pinned in the flats by a contract crew: professionals, military drill, no markings. Break their line, recover the cargo, and pull anything that names who paid for this. Someone on a very short list sold us.",
		"debriefing": "The contractors carried clean gear, every serial burned. Cassian locks it in the vault and shortens his list. The same week, three factions offer protection in exchange for say over your deployments; you refuse all three. Lysa takes the burned equipment to an informant who owes her, and he recognizes the batch."
	},
	13: {
		"chapter": "Claims",
		"briefing": "Three refusals, one answer: a joint safety commission from the three factions you declined, inspectors in front and troops behind. Their Inspector-General is running a search with a flag over it. Keep them outside the fence while Cassian challenges the mandate. And watch the old machines today; they've been restless.",
		"debriefing": "The commission retires with a courteous Cassian letter per envoy and nothing to show. Inside the wire, the oldest machines have started keeping routines nobody taught them. Lysa calls after dark: her informant will name the contractors, but his handlers are moving him tonight, and the safehouse district is already crawling."
	},
	14: {
		"chapter": "Claims",
		"briefing": "Lysa's informant can put names to the convoy ambush, and the contractors' handlers are closing on his safehouse to move him somewhere quieter. Cover her extraction team, keep the man breathing, and bring him out before the district swallows him.",
		"debriefing": "Lysa brings him out alive and leaves his handlers scattered across three streets. His testimony is true, detailed, and legally worthless. Truth and leverage, she notes, are different currencies. Then a priority distress call pre-empts the paperwork: a Caelian transit bridge is failing under load with a full crossing of civilians on it."
	},
	# Chapter 4 — The Proving
	15: {
		"chapter": "The Proving",
		"briefing": "The distress call is real: the span is failing under load, and its old transit-security core has half-woken with it, reading the evacuation as an attack. Hold the crossing, keep its drones off the civilians, and don't come home until the last one is across.",
		"debriefing": "Hundreds cross before the span drops. For the first time, the word Conductor travels ahead of the squad as something other than a threat: the person who came when the call went out. Across the river, a guild champion watches the same footage and issues a public challenge to the salvage Conductor."
	},
	16: {
		"chapter": "The Proving",
		"briefing": "A guild champion has challenged you in print, and the sponsor house behind him wants the bridge written off as luck and you as a fraud. Their arena, their crowd, their referee. Give them the match. Make the bridge look like what it was.",
		"debriefing": "The champion falls in front of his own crowd, and the house that backed him loses face it spent years buying. Cassian releases the footage with notes, trading the headline for leverage and counting the grudge as a future invoice. Within days, competing public hearings convene over the bridge, the duel, and what the depot is for."
	},
	17: {
		"chapter": "The Proving",
		"briefing": "The hearings have pulled rival crowds into the streets around the inquiry hall, and partisans on both sides are working them toward a riot. Delegates inside, demonstrators outside, one bad spark between. Keep the hall standing and the crowds apart until the testimony is in the record.",
		"debriefing": "The testimony enters the record edited, trimmed before reading to serve positions you don't hold. One officer on the evaluation panel objects in open session: Evaluator Marren puts her name to the dissent and offers an honest account, produced by testing the Relay under controlled conditions. Cassian accepts before anyone can retract it."
	},
	18: {
		"chapter": "The Proving",
		"briefing": "Marren runs a clean evaluation: full registry protocol, proving-grounds conditions, no friends in the room. She means to find the squad's ceiling and yours. Show her everything. And when the strain starts telling on you, say so; she's the first official willing to write down what conducting costs.",
		"debriefing": "Marren's report certifies the ability and documents the price: the strain, the collapse risk, the medical tent she makes you sit in afterward. Before release she asks one professional to another: a township nearby reports conductor-less automatons running old defense routines, and no one else will answer."
	},
	19: {
		"chapter": "The Proving",
		"briefing": "The township's ferals are pre-collapse machines running scar loops, defense routines with nobody left to defend. They're dangerous, some are priceless, and those two facts can't both win today. Protect the residents. If a machine has to die for that, it dies.",
		"debriefing": "The township stands; the salvage doesn't. The squad picks people over priceless machines, and one surviving feral chooses, unasked, to follow them home. Cassian adds the township to the supply roster without comment. Weeks later, displaced families from the district start camping against the depot fence, and thieves start working the camp."
	},
	20: {
		"chapter": "The Proving",
		"briefing": "Displaced families are camped against our fence, and infiltrators are using the crowd as cover to reach the stockpiles. Protect the refugees and the supplies both. These people are here because they trust the name on our gate. Don't make them wrong.",
		"debriefing": "The infiltrators are run off, and the camp holds, then stays, tents becoming streets, a settlement growing beside the depot because people feel safer near it. Watching water lines and winter stores come together, Cassian starts drafting a charter so the squad can work openly where it's needed. The Stranger answers with coordinates."
	},
	# Chapter 5 — Sanctuary
	21: {
		"chapter": "Sanctuary",
		"briefing": "The Stranger's coordinates lead to a pre-collapse sanctuary, and the Order's archivists got here first. Their gate scholar is polite, armed, and clear: outsiders don't enter. The charter says we don't force sites, so earn the threshold: show them enough strength to respect and enough restraint to trust.",
		"debriefing": "The Order shares the sanctuary once you've shown you could have taken it and didn't. The lead archivist, Serin, accepts the arrangement with a scholar's grace, though her eyes keep returning to the oldest machines, as if she recognizes them. Inside the walls, custodial machines still guard an inner vault none of the Order's keys open."
	},
	22: {
		"chapter": "Sanctuary",
		"briefing": "The inner vault's custodians are three centuries into their orders and don't care that the war they guarded against is over. Disable them without wrecking what they protect. The archive is the point, not the rubble. Serin will be right behind you; keep her standing.",
		"debriefing": "The archive opens intact, and its maintenance logs are dated after the Empire's supposed fall. The Empire didn't collapse; it dismantled itself, on purpose, with receipts. One unredacted manifest lists a destination every modern map has forgotten: Caelis. Reconstructing its routes takes the Order's cross-border collections, and an escort across a contested border."
	},
	# Chapter 6 — The Arena
	23: {
		"chapter": "The Arena",
		"briefing": "Serin's routes need the Order's archives across a border nobody polices and everybody shoots over. A militia interdiction chief runs the crossing and sells passage to people he likes. This escort is the reclamation charter's first contract: scholars, copied records, no patron. Get them all through.",
		"debriefing": "The scholars and their records come through whole; the charter has its first successful contract. Success travels. Within a week all five factions send invitations: each wants the Conductor displayed at its military exhibition, and every offer is a leash with a gift bow. Cassian replies to all five: the Conductor accepts every invitation."
	},
	24: {
		"chapter": "The Arena",
		"briefing": "Five exhibitions, one week, and every marshal running a show has orders to make his faction look like your natural home. Perform for all of them; sign with none. Stay sharp. Staged exercises have a way of going live when someone wants to measure you honestly.",
		"debriefing": "The circuit ends with the charter unbought and five bids on Cassian's desk. None can grant what the charter actually needs: a seat at the faction talks. One neutral road leads to that table: the Grand Circuit, where the nations settle disputes by proxy champion. The reigning champion's name is Asha Vale."
	},
	25: {
		"chapter": "The Arena",
		"briefing": "The Grand Circuit: five governments settling arguments in an arena because it costs less than war. Cassian's entered you, and the opening heat's champion is a working professional with a faction paycheck. Win the bout and start climbing. The name at the top of the bracket is Asha Vale.",
		"debriefing": "The first heat falls, and the betting boards rewrite themselves overnight. Cassian works the patrons' boxes while the crowd learns your name, trading attention for credit and access. The next heat draws the tournament's darling: the crowd favorite, unbeaten this season, with the whole arena already chanting for him."
	},
	26: {
		"chapter": "The Arena",
		"briefing": "The crowd favorite is everything the posters promise, fast, clean, beloved, and the arena wants you cast as the villain who ends him. Oblige them on the result, not the story. Win the match while Cassian works the boxes, learning which patrons cheer for us and what they expect it to cost.",
		"debriefing": "The favorite loses gracefully, and the crowd forgives you by the third replay. Two rival factions each toast the result as secretly theirs; neither understands why you're here. The bracket narrows, and this morning your quarter-final opponent refused a large payment to withdraw, which means the money will try another door."
	},
	27: {
		"chapter": "The Arena",
		"briefing": "Your quarter-final opponent turned down a bribe to withdraw: a professional who wants his match honest. Expect a fair fight in the arena and unfair work outside it; whoever paid for a forfeit will settle for a weakened champion. Reach the bout intact, then give him the match he stayed for.",
		"debriefing": "The match is clean and the win owed to no one. Cassian makes sure every box in the arena learns who offered the bribe, and suspicion slides off the charter onto better targets. The semi-final brings the interference indoors: a patron has ordered your next opponent to surrender and present the match to you as a gift."
	},
	28: {
		"chapter": "The Arena",
		"briefing": "Your semi-final opponent has orders to throw the match: a patron means to own your title by giving it to you. He doesn't want to obey, and I don't want the gift. Force the honest contest: fight like he's free, win like it's real. A title handed over is a leash.",
		"debriefing": "He fights honestly and loses honestly, and no patron alive can claim your final was bought. Cassian thanks him in print for refusing the arrangement; the fixers retreat to reconsider. One match remains. Asha Vale, three years unbeaten, the Circuit's champion and its conscience, is waiting."
	},
	29: {
		"chapter": "The Arena",
		"briefing": "Asha Vale: the reigning champion, the best relay operator the modern armies have produced, and the last name between the charter and the talks. She's studied every bout you've fought. Beat the best there is, in front of everyone, and make the title mean what we need it to mean.",
		"debriefing": "The Circuit has a new champion, and Cassian converts the title into formal recognition before the floor is swept. The charter sits at the talks. Vale files you under unfinished business, professional to the end. Lysa spends the patrons'-box access tracing old money: the contractor payments from the depot attacks run to a border camp, and its paymaster is still there."
	},
	# Chapter 7 — Fault Lines
	30: {
		"chapter": "Fault Lines",
		"briefing": "Lysa's found the border camp where the depot raiders were paid, and its paymaster's chits will name the contracting house behind two years of attacks. She's scouting it now, and the camp knows she's close. Escort her in, take the records, and be gone before the paymaster burns his own books.",
		"debriefing": "Lysa comes out with pay chits and seal records: proof the raiders were deniable contractors all along, and a contracting house's name that points toward a guild. The trail has to wait. A Wind city has invoked the charter: a Caelian war engine is waking beneath its streets, and every neighbor wants the machine more than it wants the city saved."
	},
	31: {
		"chapter": "Fault Lines",
		"briefing": "The Wind city called us because we're the only help that arrives without an invoice for its sovereignty. A Caelian war engine is coming up under the streets, three centuries asleep and still following its last orders. Stop it, and keep it out of the populated districts while the neighbors circle overhead.",
		"debriefing": "The engine dies in the empty districts and the city stands. Five factions inspect the machines under their own streets and blame one another for the wake-up. Cassian moves before the accusations can arm themselves: an emergency ceasefire summit in the capital, every aggrieved party at one table: a table every hardliner in five capitals wants overturned."
	},
	32: {
		"chapter": "Fault Lines",
		"briefing": "The ceasefire summit convenes in three hours, and my people have been pulling explosives out of the walls since midnight. A bomber means to bury the delegates in the building that was supposed to save the peace. Sweep the approaches, hold the hall, and get everyone out when it goes wrong. It will go wrong.",
		"debriefing": "The charges take the gallery, not the table; the delegates stagger out through smoke while their aides die under the doors. The summit is dead before the fires are, and hardliners across five capitals hold up the fallen as proof that peace was the trap. Then, in two delegations' territories at once, the power grids begin failing in sequence."
	},
	33: {
		"chapter": "Fault Lines",
		"briefing": "Power is failing across two territories in waves, jumping between Source fragments that aren't supposed to touch. The network's own defense automata wake with the surges and treat repair crews as intruders. Escort the crews to the failing junctions and keep them working. The hospitals go dark first.",
		"debriefing": "The crews keep the wards lit, and the pattern is undeniable to anyone reading honestly: the fragments are degrading in sympathy, one body refusing to admit it's dead. Officials blame weather. One government blames its neighbor, loudly, and launches a retaliatory raid toward a civilian border district. Cassian is already drawing your route toward it."
	},
	34: {
		"chapter": "Fault Lines",
		"briefing": "A hardliner retaliation column is aimed at a border district full of people who had nothing to do with the accusation. Both governments will condemn you for touching it. Touch it anyway. Intercept the column before the fighting reaches the streets.",
		"debriefing": "The district survives, and both governments denounce the rescue. Saving people without a flag is apparently the one unforgivable act left. Worse, the raids have severed the remaining grid links. Two districts are failing now, winter is coming, and exactly one repair crew is free to move. It cannot reach both."
	},
	35: {
		"chapter": "Fault Lines",
		"briefing": "Two dying districts, one repair crew, and a militia blockade chief holding the only road the crew can still use. You can clear one route before winter. Not two. Pick the district that can still be stabilized, break the blockade, and get the crew through, knowing what the other district becomes.",
		"debriefing": "One district has heat and light. The other has a martyrdom story its leaders will spend for years, and the people freezing in it know exactly who chose. There was no version that saved both, Cassian checked, but he made sure the order came down signed by you. The capital's answer to the crisis is a stage: leaders announcing, on camera, that the emergency is over."
	},
	36: {
		"chapter": "Fault Lines",
		"briefing": "The grid is still failing, and the leadership declares victory over it tomorrow, live, from a hall packed with dignitaries. Extremists who want the crisis louder plan to attend. Protect the gathering and the repair crews working beneath it. We don't have to believe the speech to keep the audience alive.",
		"debriefing": "The attackers are stopped, the broadcast runs as written, and everyone on that stage knows the lights outside are still dying. 'Institutions lie to survive,' Cassian says, filing the speech. 'Remember who taught you that.' Then he gets the squad out of the manufactured celebration: an inspection trip to the township you saved, where a welcome is already being planned."
	},
	# Chapter 8 — Heroes and Costs
	37: {
		"chapter": "Heroes and Costs",
		"briefing": "The township is turning our inspection into a festival, and an elderly caretaker just looked at one of our oldest machines and called it by a name three centuries dead. Raiders have picked the celebration for a grab at crowd and squad alike. Keep the square. Then I want to hear what she remembers.",
		"debriefing": "The square holds and the festival finishes. The caretaker gets her private word about the machine she knew: a resonance scar with a name attached, and Cassian writes down every syllable. Before the lanterns come down, a messenger rides in from a commune up the line: a state relocation force is coming to empty it at gunpoint, and the commune refuses to go."
	},
	38: {
		"chapter": "Heroes and Costs",
		"briefing": "The commune sits on degrading ground, and the relocation authority has orders to empty it for the residents' own good, at gunpoint, since they won't go. The residents aren't wrong about the land and aren't safe on it either. Stand between the guns and the doorsteps. Nobody gets dragged out of their home today.",
		"debriefing": "The commune keeps its homes and its defiance; the relocation commander withdraws to recount his arithmetic. On the return leg, the supply convoy traveling with the squad gets diverted through the narrow pass, and both exits close behind it. Deniable raiders, coordinated, waiting for exactly this route."
	},
	39: {
		"chapter": "Heroes and Costs",
		"briefing": "We're encircled in the pass, professionals again, and they knew our route before we took it. There's no clever exit, only a fought one. Break the encirclement and bring everyone home. When I say everyone, I am including the machines.",
		"debriefing": "The squad comes home minus one. One of the oldest machines, the first gallery's own, went still holding the rear so the others could pass. Its presence lingers in the Relay anyway, faint and stubborn, carried by every machine it marched beside. Cassian writes nothing for a day. Then he orders the chassis recovered."
	},
	40: {
		"chapter": "Heroes and Costs",
		"briefing": "The chassis is still in the pass, and a salvage crew is moving to strip it. Their recovery chief thinks dead metal is finders' property. No speeches. Go back up there, take our own back, and be off that slope before the people behind the ambush send anyone interested in prisoners.",
		"debriefing": "The chassis comes home on a quiet truck, and the depot stands down for an evening. Waiting on Cassian's desk: a priority message from Serin. She's decoded the sanctuary's Caelian transport records, and at least two groups of claimants are moving to seize her convoy before she can reach the coalition with them."
	},
	41: {
		"chapter": "Heroes and Costs",
		"briefing": "Serin's convoy is an hour out with the decoded transport history, and a record-seizure team is on the road to take it. The claimants want the documents buried or rewritten before the coalition reads them. Meet her outside the Sanctuary and walk those records through. The history matters more than the fight.",
		"debriefing": "Serin and the records reach headquarters intact; protected copies go into three separate vaults the same night. The decoded routes say what no faction archive admits: Caelis was not destroyed; it was removed from the maps, deliberately, by everyone at once. The Stranger resurfaces within the week with new coordinates and proof of who lit your Relay."
	},
	42: {
		"chapter": "Heroes and Costs",
		"briefing": "The Stranger's coordinates lead to an abandoned relay station and an offer: proof your activation was arranged, paid for through the coalition's own patron chain. The patrons' retrieval agents will come to erase the evidence, and possibly the witness. Secure the meeting, take the proof, keep our mysterious friend breathing.",
		"debriefing": "The proof escapes, and it reads badly: patrons inside the coalition paid for the relay experiment. Director Rusk knew only the payment, a signature, not the design, and his condolences arrive ahead of his lawyers. Cassian moves before the implicated patrons can arm themselves: they're negotiating to hire the scavenger clans, and Dax Calder can reach the clans first."
	},
	43: {
		"chapter": "Heroes and Costs",
		"briefing": "The clans sell neutrality to whoever earns it, and they respect exactly one currency. Their trialmaster sets the terms: prove your strength in a clan trial, and Dax Calder buys their neutrality with the winnings. Fight their way, on their ground, by their rules. Win the trial and the patrons lose their army.",
		"debriefing": "The clans take the trial's result as final and sell their neutrality to Calder's coin; the implicated patrons go shopping for muscle in a market closed to them. Calder also delivers authenticated contract ledgers, and Lysa reads them twice. They're enough. She can finally walk into her old guildhall and ask where the contractor money truly came from."
	},
	44: {
		"chapter": "Heroes and Costs",
		"briefing": "Lysa confronts her old guild with Calder's ledgers in hand, and the guildhall factor has already declined to answer, politely, behind armed clerks. Escort her in and keep her standing while she makes them produce their authorizations. She's waited years for this conversation. Don't let them end it early.",
		"debriefing": "The guild produces paperwork older than the war, and responsibility climbs out of the hall into patron country: the trail points up, not back. Buried in the manifests is worse: all five factions are quietly shipping Source cores into weapons programs. One core moves this week under security sized for secrecy, not war."
	},
	# Chapter 9 — Cores
	45: {
		"chapter": "Cores",
		"briefing": "The manifests name a Source core in transit: one convoy, one route, guarded for secrecy rather than battle. Intercept it and take the core before it reaches a weapons program. Understand what winning buys: once we hold a core, every flag in the world calls us exactly what they feared.",
		"debriefing": "The convoy surrenders the core, and Cassian's warning lands within hours: the coalition now owns the thing all five factions were arming in secret, which makes it a power whether it wanted to be one or not. Five competing custody demands arrive by morning. Cassian's answer is a shared-custody proposal, announced publicly at Unity Day."
	},
	46: {
		"chapter": "Cores",
		"briefing": "Cassian announces the shared-custody proposal at Unity Day, in the capital's most crowded square. A hardliner cell means to turn the celebration into the massacre that ends all talk of sharing. General Strosse's people want the open war the moderates keep postponing. Work the crowd, find the cell, stop the killing.",
		"debriefing": "The square empties frightened instead of dead, and the captured orders read worse than the attack: Unity Day was the opening move. While the crowd is still fleeing, General Strosse's armored columns leave their garrisons and advance on the council chambers. The coup Cassian has been predicting all season is finished hiding."
	},
	47: {
		"chapter": "Cores",
		"briefing": "Strosse's field marshal is driving armored columns at the council chambers, betting the government folds before breakfast. Break the advance in the streets before it reaches the government district. The moderates are watching from their windows, deciding which side to be brave on. Give them an easy choice.",
		"debriefing": "The coup breaks at the government district's edge, and the moderates discover they were loyal all along; Cassian absorbs them, paperwork first. Clearing the underground approach turns up what the battle was sitting on: a powered Caelian transit line beneath the capital, still drawing energy, still maintained, pointing somewhere no map admits."
	},
	48: {
		"chapter": "Cores",
		"briefing": "The transit line's entrance is real, and the coup's rearguard still holds the surface above it, beaten troops with nothing to lose and orders to deny everything. Clear them off the station so Serin's team can go down and trace the route. Watch for demolition charges; dying coups love a buried secret.",
		"debriefing": "Serin's team goes in, and the line's maintenance records are recent; someone has kept it alive for three centuries. Its terminus sits in a place missing from every modern map. The station's activation doesn't stay quiet: three faction armies detect the power draw and converge on the populated town above the next junction."
	},
	49: {
		"chapter": "Cores",
		"briefing": "Three armies are converging on the town above the junction, and none of them plans to arrive second. We cannot win that battle. Nobody can. What we can do is hold an evacuation corridor until every civilian is out, then be gone ourselves. Lives only. Nothing else is on the table.",
		"debriefing": "The corridor holds until the last family is through; then the town belongs to the armies, the first true three-faction battle, fought over empty streets. The war everyone feared has begun, and history will record the coalition's part in its opening battle as a retreat. Cassian starts calling the enemies he can still talk to."
	},
	50: {
		"chapter": "Cores",
		"briefing": "Cassian has talked several of the shooting enemies into a local truce, signed on a line you'll be standing on, beside troops we fought last month. Hardliner holdouts on every side want the signing buried with its signatories. Hold the truce line until the ink exists. Give peace the hour it needs.",
		"debriefing": "The truce holds because former enemies enforce it shoulder to shoulder, and it spreads along the front faster than orders travel. On the first joint patrol, several of your oldest machines refuse a pursuit order, and move, unasked, to shield the wounded of both sides. The truce partners demand to know what the coalition is actually fielding. Cassian arranges a controlled demonstration."
	},
	51: {
		"chapter": "Cores",
		"briefing": "The machines refused an order in front of three nervous armies, and the truce partners want data, not assurances. So: a controlled field trial, on the record: the coalition's own test conductor fields the opposing squad to give the observers honest resistance. Learn, in public, whether a truce can stand on machines that choose.",
		"debriefing": "The trial ends without casualties and without comfort: the machines take some orders, decline others, and protect bystanders regardless of flag. All three signatories leave the observation post quietly alarmed. Their follow-up negotiation hardens into a demand that the dispute be settled the old way: champion combat, one staged battle, winner takes the point."
	},
	52: {
		"chapter": "Cores",
		"briefing": "The three delegations have hired a provocateur to settle their dispute by staged battle and called it negotiation. Circuit rules, treaty language riding on the result. Cassian needs the coalition to lose this one: the ground yielded, no delegation humiliated. Control the fight, keep it clean, withdraw on his signal.",
		"debriefing": "The withdrawal lands exactly as choreographed, and the talks survive because nobody won enough to gloat. Cassian no longer asks before he spends you; note it and move on. The staged battle's Source draw doesn't stay on the field. Lights fail across the district, and dormant machines begin waking in sequence, answering something."
	},
	# Chapter 10 — Coalition Fracture
	53: {
		"chapter": "Coalition Fracture",
		"briefing": "The blackout is spreading, and grid crews report the impossible: Source fragments synchronizing on their own, waking defense automata as they link. The Order confirms it's not an attack; it's a response, though nobody knows to what. Follow the crews outward and keep them alive while they contain the cascade.",
		"debriefing": "The crews contain the first cascade, and the network keeps answering itself regardless. In the dark, a locked ward inside a faction recruitment center fails open, and the bureau's security mobilizes not to evacuate it but to reseal it. Lysa's contact inside says the ward holds people, not equipment, and the life support is on battery."
	},
	54: {
		"chapter": "Coalition Fracture",
		"briefing": "The ward holds people who passed medical screening for possible Relay use and then refused the bureau's sponsorship contracts: no Relays, no Conductors, just candidates the recruitment bureau won't release. Its security chief is restoring the locks while their life support runs down. Get them out before either deadline lands.",
		"debriefing": "The candidates reach the coalition clinic alive, and the bureau brands the rescue theft of state recruitment assets. The hardliner alliance takes up the phrase gratefully and launches the offensive it had already prepared: three fronts, timed to the hour. Cassian reads their declaration twice and starts moving pieces: only one force can intercept every breakthrough."
	},
	55: {
		"chapter": "Coalition Fracture",
		"briefing": "The hardliner alliance is driving three fronts at once, and the coalition has no second force. We're the interception. Run the breakthroughs one after another and keep running. The medics are already refusing to clear you for the field. Pace the strain: the Relay has to outlast this offensive, and so do you.",
		"debriefing": "The fronts hold at a cost the medical tents will count for weeks. The offensive's field command reports failure, and its sponsors change targets: if the coalition can't be broken in battle, its delegates can be removed one at a time. Cassian's network catches the first kill team before it reaches its hotel."
	},
	56: {
		"chapter": "Coalition Fracture",
		"briefing": "The assassins are working down the delegate list, and Cassian's network is racing them name by name. Move the surviving representatives to the secure chamber and hunt the teams hunting them. Tonight you'll see how far his information web reaches: every warning on your map is one of his people paying a debt.",
		"debriefing": "The delegates reach the secure chamber alive; the kill teams don't. Shaken and done hiding, the survivors invoke emergency procedure and call a public tribunal: one open session to decide who can legitimately govern the Source. Every armed claimant in the war now has a date, a place, and a target."
	},
	57: {
		"chapter": "Coalition Fracture",
		"briefing": "The tribunal convenes in public because secrecy is what killed the last answers. Rival claimants have sent disruptors to make sure no answer survives the asking. Keep the chamber standing and the witnesses breathing until every claimant has been heard. There is no correct side in that room; that's the point of protecting all of it.",
		"debriefing": "The tribunal hears everyone and answers nothing: no claimant can impose control safely, and now that's on the record. Serin offers the buried Caelian conduits as neutral ground for a shared settlement. Fighting has already reached the western district above their only mapped entrance, and a royalist guard holds the gate under a charter nobody remembers signing."
	},
	58: {
		"chapter": "Coalition Fracture",
		"briefing": "The royalist gatekeeper at the western entrance has kept his post since the Empire, hereditary, formal, unimpressed by three centuries of successor states. His charter demands a trial of passage before the gates open, and he'll honor the result. Meet their terms exactly. We need them as doorkeepers, not casualties.",
		"debriefing": "The gatekeepers honor the trial and open the western conduit, three hundred years of duty discharged with a bow. The coalition goes under the city. Above, ranging fire starts walking toward the buried route: a siege corps' long-range batteries, already solving the conduits' geometry. Someone means to close the door behind us permanently."
	},
	59: {
		"chapter": "Coalition Fracture",
		"briefing": "The siege corps' battery commander has his guns ranged on the conduit route, and the next barrage could drop the passage on the coalition inside it. Break through the surface defenses and silence the batteries before they fire again. No illusions: every side will rebuild these guns. Tonight the tunnels need them quiet.",
		"debriefing": "The conduits survive the night; the batteries are scrap until someone rebuilds them, and everyone knows someone will. Cassian spends the victory the same hour: he calls Asha Vale and asks her to raise a joint force from the Circuit's old rivals, people who tried to buy, beat, and bury you, to hold the exposed route while Serin finishes the maps."
	},
	60: {
		"chapter": "Coalition Fracture",
		"briefing": "Asha Vale answers with a team built from the Circuit's old rivals, and the siege corps answers her with a route commander sent to retake the passage. Fight beside people who tried to buy, beat, and bury you, and hold the conduit line until Serin's survey is done.",
		"debriefing": "Vale's team holds the route until the survey is complete, and Serin's finished maps show what the conduits were built toward: a single maintained passage beyond the known network, with a live signal waiting at its far terminus. The Stranger studies the map a long moment, then asks the coalition to walk it, and says she's done being a stranger."
	},
	61: {
		"chapter": "Coalition Fracture",
		"briefing": "The Stranger finally gives a name: Ilyra, warden of Caelis, sent to bring the accidental Conductor home. The maintained route ends at a terminus its transit custodians still guard, and Vale's team can hold the junction behind us only so long. Secure the passage, reach the terminus, meet whatever's been signaling.",
		"debriefing": "The terminus custodians stand down to Ilyra's authority, and the signal's source is what she promised: a transit gate, powered and waiting. Her report home doesn't stay secret. Intercepted military traffic shows five faction armies converging on the same route. Every flag in the war is marching on Caelis at once."
	},
	62: {
		"chapter": "Coalition Fracture",
		"briefing": "Five armies are converging on the gate of Caelis, and Ilyra can hold the threshold open only so long. Cassian is assembling the delegations into something that arrives as a coalition instead of an invasion. Hold the gate approach against their vanguards until he's ready. The last battle of this war is keeping the war outside those walls.",
		"debriefing": "Cassian reaches the gate leading a coalition, not an army, and the war stops at the threshold because you held the approach until it could. Caelis opens. The Wardens admit the delegation as far as an inspection court in the Outer City, no further. Three hundred years of sealed gates do not open on one good afternoon."
	},
	# Chapter 11 — The Outer City
	63: {
		"chapter": "The Outer City",
		"briefing": "The Wardens will admit the delegation on one condition: their emergency protocol inspects you first. Their examiner wants to watch you conduct our machines without touching a Caelian system. Give the protocol a clean reading. Three hundred years of procedure is watching, and it only says no once.",
		"debriefing": "The examiner's verdict: an unregistered Conductor with an unauthorized Relay: an anomaly to be studied, not sealed out. The gates open onto an Outer City that is lit, swept, and kept for citizens who never came home, and its caretaker machines take one look at the delegation and file it under trespassers."
	},
	64: {
		"chapter": "The Outer City",
		"briefing": "The Outer City's caretakers have kept it immaculate for three centuries of absent citizens, and their rules have no category for guests. They've classified the delegation as trespassers and started enforcing. Keep the machines off our people without wrecking the city they love. The Wardens are scoring how you win.",
		"debriefing": "The caretakers stand down once the squad proves it will protect their city instead of claiming it. The Wardens watch machines defended by a Conductor who could have taken them, and their answer is a second examination: stewardship, at a maintenance district whose own machines stay under Caelian command."
	},
	65: {
		"chapter": "The Outer City",
		"briefing": "The stewardship examination has one rule that matters: defend the maintenance district without conducting a single Caelian machine assigned to it. The examiner's own custodians will press you. Protect their district with only what we brought. Show them conducting can mean keeping, not taking.",
		"debriefing": "The district holds, and not one Caelian machine changes hands to hold it. The Wardens record the result in whatever passes for their books and unlock the inner gates. Serin already knows where she's leading the delegation first: the Imperial Archive, whose custodians deny Wardens and outsiders alike."
	},
	# Chapter 12 — The Imperial Archive
	66: {
		"chapter": "The Imperial Archive",
		"briefing": "The Imperial Archive keeps the Empire's unedited account of its final years, and its custodians were built to keep that account from everyone, Wardens included. Serin needs the record intact, so disable the defenses without pulping what they guard. Precision work. The record is the prize, not the rubble.",
		"debriefing": "The archive opens with its collection unharmed. Its record shows a Source crisis and an Empire that chose to fragment the network rather than trust any single power with it whole, and its index points to five sealed founding galleries. Alarms answer first: faction claimants are already breaching them to burn what weakens their histories."
	},
	67: {
		"chapter": "The Imperial Archive",
		"briefing": "Five founding galleries, one per faction, each holding the annotated truth of what its nation preserved, and what it was meant to preserve. Claimant record-burners are inside already, destroying evidence in rooms their own capitals sent them to. Reach the galleries before the collection is gone.",
		"debriefing": "The galleries survive with their records legible; the burners leave empty-handed and their sponsors unnamed, for now. Read together, the five sections stop being five myths and become one syllabus, and a cipher none of the Order's keys touches, pointing down to the archive's deepest sealed vault."
	},
	68: {
		"chapter": "The Imperial Archive",
		"briefing": "The deep vault holds the evidence that made the Empire break its own civilization, and guardians designed to resist Conductors, which means they were designed for someone like you. Take the record, keep the guardian network dormant, and let nothing in that vault leave with you except knowledge.",
		"debriefing": "The deep record comes out and the vault seals behind it, guardians dormant, archive intact. What it names is worse than any weapon: living witnesses, kept in a Conductor Vault nearby: the people who paid the price behind the Empire's decision. Their hospice assesses visitors before it admits them."
	},
	# Chapter 13 — The Conductor Vault
	69: {
		"chapter": "The Conductor Vault",
		"briefing": "The Conductor Vault isn't a prison; it's a hospice: the last First Conductors, still alive, still paying for what the Relay program took from them. Its guardians assess every visitor for harm before they allow a word. Pass their assessment gently. Some of these witnesses have waited three centuries to be asked.",
		"debriefing": "The guardians stand down, and the First Conductors receive the delegation in the Relay ward: your own medical future, walking and talking. They answer every question but one, and for that one they point at the Warden council. The council's own Continuity Directorate responds by sealing the witness chamber before anyone can testify."
	},
	70: {
		"chapter": "The Conductor Vault",
		"briefing": "The Continuity Directorate authorized the relay experiment that made you, arranged through expendable intermediaries, our own patrons among them, and now it's sealed the council chamber and turned its custodians on the witnesses. Break the lockdown. The council's testimony and its records both survive this, or the truth dies with its keepers.",
		"debriefing": "The lockdown breaks and the council records survive. Cornered by its own paper, the Warden council admits what your activation was: a deliberate continuity test, and you the result it hoped for. Then it summons the new Conductor to the Crown Relay: an invitation with an honor guard attached."
	},
	71: {
		"chapter": "The Conductor Vault",
		"briefing": "The council offers you the Vault's purpose: stay in Caelis, succeed the First Conductors, become the system's next warden. It's honestly meant, and it's the wrong answer, and the honor guard sealing the exits agrees with the offer more than the answer. Decline carefully, then leave anyway.",
		"debriefing": "The containment breaks without a single guardian harmed; the Crown Relay stands, and so does the refusal. Caelis learns the new Conductor won't be kept, so it tries politics instead, petitioning for a public hearing on the Source's stewardship. Armed restorationists are already moving to take the council chambers first."
	},
	# Chapter 14 — The Civic Core
	72: {
		"chapter": "The Civic Core",
		"briefing": "Caelis has asked for a public hearing on who should steward the Source, and every surviving delegation is coming to answer. Restorationist hardliners mean to seat a different answer by force. Their seizure team is already moving on the Civic Core's chambers. Clear them out and hold the hall for the talks.",
		"debriefing": "The Civic Core holds, and the delegations sit down under coalition guard to resume what the seizure was meant to end. The failure teaches the extremes something the moderates never could: neither can win alone. Caelian restorationists and faction hardliners open a channel neither admits to, and plan the talks' funeral together."
	},
	73: {
		"chapter": "The Civic Core",
		"briefing": "Restorationists and faction hardliners: the two ends of the argument, allied at last, against the middle. Their joint conductor leads the push to break the negotiations before a compromise exists. Protect the negotiators. You don't get a seat at their table; you get to make sure the table survives.",
		"debriefing": "The alliance of extremes breaks, and needing each other at all tells the room how much both ends fear the middle. The talks continue. Cassian starts drafting the Accord in the next chamber, and you begin to read the room the way he always has, while every would-be signatory sends troops to underline its demands."
	},
	74: {
		"chapter": "The Civic Core",
		"briefing": "Cassian is drafting the Accord, and every proposed signatory wants one more concession; several have sent pressure forces to the negotiating hall to make the wanting persuasive. Keep the troops away from the draft. Your part in this story gets smaller from here; that's what winning looks like.",
		"debriefing": "The pressure forces withdraw, and with outside coercion off the table Cassian seals the completed draft for review. Its first article demands proof, not promises: a joint repair team from every signatory must enter the Source complex and reconnect the fragments. The complex's own defenses will read that as a seizure."
	},
	# Chapter 15 — The Source
	75: {
		"chapter": "The Source",
		"briefing": "The Accord's first article sends a joint crew from every signatory into the Source complex to reconnect its fragments. The complex's distribution defenses were built against exactly this, one power reaching for the whole, and they can't read a treaty. Escort the crews and keep them working until the network understands.",
		"debriefing": "The fragments reconnect, and the truth finishes coming out: the Source was never a generator; it's a balancing network, a bomb when any one hand holds it, a civilization when every hand does. The reconnection also lights the complex for every rejectionist force left in the world. They're already marching."
	},
	76: {
		"chapter": "The Source",
		"briefing": "Every rejectionist army left is converging on the Source complex, and their field marshal understands the war better than its owners do. Champions from every faction stand with you on the approach. Hold the field, all of it, every flag, and keep everyone alive long enough for their leaders to sign.",
		"debriefing": "The allied line holds, faction champions shoulder to shoulder where the war's fronts used to be. In the assembly hall the signatures begin. The rejectionists fall back for one last advance, and their marshal gives the conflict its name before the histories do: the Resonance War, ending at a signing table."
	},
	77: {
		"chapter": "The Source",
		"briefing": "The Accord is ready for signatures, and the last rejectionists are coming up the approach to stop the pen. Defend the assembly and buy every signature the time it needs. End this the way Cassian built it: with everyone alive enough to sign.",
		"debriefing": "The Accord is signed. The factions take home a shared account of the past, return the most dangerous evidence to its vault, and place the Source under an authority that belongs to no one flag. The war ends at a table, which is where Cassian always said it would."
	}
}

# Prologue shown the first time the operations map opens (replayable via the
# WORLD BRIEF button). It establishes the believed history — Empire, Source,
# collapse, five factions, operators versus true Conductors — so the later
# reveals have something to break. Voice rules live in
# documentation/Narrative_Style_Guide.md.
const CAMPAIGN_PROLOGUE := (
	"Three hundred years ago, the Caelian Empire ran its whole civilization on "
	+ "the Source. One network powering the cities, transports, and the "
	+ "automatons that kept them alive. Imperial Conductors guided those machines "
	+ "through relay stations, lending them purpose with a thought.\n\n"
	+ "Then the Empire fell. The Source went dark, the capital Caelis was lost, "
	+ "and the Conductors lost with it. That is the story every school in every "
	+ "nation teaches.\n\n"
	+ "Five successor nations rose from the provinces. Coal, Steam, Solar, Wind, "
	+ "and Fusion. Each kept a fragment of the old network running, and each is "
	+ "certain it alone can be trusted with what remains. Their armies field "
	+ "machines of their own, driven by licensed operators with control rigs. "
	+ "Crude tools beside what the Empire's Conductors did with their minds.\n\n"
	+ "You are a reclamation technician with a joint salvage expedition, paid to "
	+ "pull working machinery out of a abandoned site. The patrons "
	+ "funding the dig expect scrap value.\n\n"
	+ "The site has other plans."
)

# Chapter intro cards, keyed by chapter name (the same strings used in
# MISSION_STORIES and the operations-map regions). Shown once when a chapter
# becomes the campaign frontier; they carry just-in-time exposition for the
# institutions the chapter's missions are about to use.
const CHAPTER_CARDS := {
	"The Salvage": {
		"text": (
			"Your expedition works a dormant Caelian relay site under a patrons' "
			+ "salvage contract: recover what still functions, catalogue what "
			+ "doesn't, and make the dig look worth its funding.\n\n"
			+ "The machines coming out of the lower galleries have been nonfunctional for "
			+ "three centuries."
		)
	},
	"The Aftermath": {
		"text": (
			"Salvage law is older than the nations that enforce it: whoever pulls "
			+ "working machinery out of a dead site owns it, if the claim survives "
			+ "challenge. Every scavenger consortium and half the guilds keep "
			+ "lawyers who specialize in making claims not survive.\n\n"
			+ "Your expedition's patrons are a private consortium with government "
			+ "ties, and they didn't fund a dig out of curiosity. They want the "
			+ "Relay machines declared safe, valuable, and theirs.\n\n"
			+ "Five nations watch the dig without admitting it. None of them can "
			+ "seize a licensed salvage operation outright, but every one of them "
			+ "can pay someone who can."
		)
	},
	"Claims": {
		"text": (
			"Every modern army fields machines driven by licensed relay operators: "
			+ "technicians with manufactured control rigs, regulated, registered, "
			+ "and deliberately limited. It is the only legal way to command a "
			+ "machine, and the licensing halls keep it that way.\n\n"
			+ "True Conduction, the Imperial kind, will lent directly, machines "
			+ "choosing to share it, died with the Empire. The registry has no "
			+ "form for it, because the registry was built to never need one.\n\n"
			+ "When governments quarrel over a machine, a claim, or a person, the "
			+ "Joint Investigative Office decides whose evidence counts. Its "
			+ "seizure orders do not ask permission."
		)
	},
	"The Proving": {
		"text": (
			"A rescue on camera is worth more than a victory in the field. The "
			+ "guilds learned that first: their champions fight public duels for "
			+ "public money, and a house that owns a beloved champion owns a piece "
			+ "of what people believe.\n\n"
			+ "The state has its own machinery for belief. Hearings shape "
			+ "testimony, evaluation panels certify what is officially true, and "
			+ "the Conductor Registry decides whose abilities exist on paper.\n\n"
			+ "The squad that saved a bridge is about to meet both."
		)
	},
	"Sanctuary": {
		"text": (
			"The Order of the Archive predates the nations it serves. Its "
			+ "archivists cross every border unchallenged, because every "
			+ "government needs someone trusted to keep the records nobody trusts "
			+ "anyone else to keep.\n\n"
			+ "The Order's rule is simple: knowledge is preserved, not owned. Its "
			+ "scholars are polite, patient, and absolutely immovable.\n\n"
			+ "The Stranger's coordinates point to a sanctuary the Order reached "
			+ "first. The gates do not open for force. They open for people the "
			+ "Order decides deserve what's inside."
		)
	},
	"The Arena": {
		"text": (
			"War is expensive and embarrassing, so the five nations built a "
			+ "cheaper way to lose an argument: the Grand Circuit. Disputes that "
			+ "once cost armies now cost a champion, a bracket, and a week of "
			+ "spectating.\n\n"
			+ "The champions are professionals with faction paychecks, and the "
			+ "patrons' boxes above the arena are where the real matches happen. "
			+ "A title buys more than glory; it buys a seat at tables soldiers "
			+ "never see.\n\n"
			+ "The reigning champion has held the title for three years. Her name "
			+ "is Asha Vale."
		)
	},
	"Fault Lines": {
		"text": (
			"Every nation's grid runs on a fragment of the old Source: one "
			+ "broken piece of the network that once powered a civilization, "
			+ "coaxed into lighting a single country at a time. Each fragment is "
			+ "an heirloom, a weapon, and a secret.\n\n"
			+ "The fragments were separated on purpose, three centuries ago. "
			+ "Nobody alive remembers the reason.\n\n"
			+ "Now the lights are failing in two territories at once, and the "
			+ "engineers have started using a word the politicians refuse to "
			+ "hear: sympathy. The fragments are degrading together, like one "
			+ "body refusing to admit it died."
		)
	},
	"Heroes and Costs": {
		"text": (
			"Cassian's charter is outgrowing its paper. Townships, scholars, "
			+ "clans, and defectors keep joining the one force in the war that "
			+ "answers distress calls without an invoice, and the charter is "
			+ "becoming a coalition whether anyone voted for it or not.\n\n"
			+ "Coalitions are built out of people, and people cost. Every ally "
			+ "added to the roster is another name that can be ambushed, bought, "
			+ "or buried.\n\n"
			+ "Meanwhile the decoded Caelian records keep saying the impossible: "
			+ "the lost capital was not destroyed. It was removed from the maps, "
			+ "carefully, deliberately, by everyone at once."
		)
	},
	"Cores": {
		"text": (
			"A Source core is a fragment's heart: enough concentrated power to "
			+ "run a city or end one. Every nation officially renounces "
			+ "weaponizing them. Every nation is quietly doing it.\n\n"
			+ "Inside each government, the hardliner wings have stopped waiting "
			+ "for permission. They want the open war the moderates keep "
			+ "postponing, and they are increasingly willing to start it "
			+ "themselves.\n\n"
			+ "The coalition is about to hold the one thing all five factions "
			+ "were arming in secret. Owning it makes the coalition a power "
			+ "whether it wanted to be one or not."
		)
	},
	"Coalition Fracture": {
		"text": (
			"The Source fragments have begun synchronizing on their own: "
			+ "blackouts rippling between grids, dormant machines waking in "
			+ "sequence, the network answering something nobody sent. The Order "
			+ "is certain of one thing only: it is not an attack. It is a "
			+ "response.\n\n"
			+ "The factions' recruitment bureaus screen the public for anyone who "
			+ "might interface with a Relay. What they do with the people they "
			+ "find is not in any pamphlet.\n\n"
			+ "Under the old districts run buried Caelian conduits, sealed since "
			+ "the collapse. Lately, their maintenance lights have been coming on."
		)
	},
	"The Outer City": {
		"text": (
			"Caelis was never destroyed. Behind three centuries of sealed gates, "
			+ "the Imperial capital stands lit, swept, and maintained, a city "
			+ "kept ready for citizens who never came home.\n\n"
			+ "The Wardens of Caelis keep it: hereditary custodians and their "
			+ "machines, still executing a disaster protocol older than every "
			+ "nation outside the walls. They are not a government. They are a "
			+ "duty that outlived one.\n\n"
			+ "They did not open the gate out of welcome. For the first time in "
			+ "centuries the world has produced a true Conductor, and the Wardens "
			+ "inspect anomalies before they admit them."
		)
	},
	"The Imperial Archive": {
		"text": (
			"Every nation teaches the fall of the Empire from its own textbook, "
			+ "and no two textbooks agree. Caelis keeps the original.\n\n"
			+ "The Imperial Archive holds the Empire's final years unedited: the "
			+ "Source crisis, the votes, the signatures, the decision that no "
			+ "single power could ever safely hold the whole network. Its "
			+ "custodians protect that record from everyone, including the "
			+ "Empire's heirs.\n\n"
			+ "Five modern nations were born from that record. All five have "
			+ "reasons to want it burned."
		)
	},
	"The Conductor Vault": {
		"text": (
			"The Empire's Conductors did not all die with it. The survivors live "
			+ "in the Conductor Vault, not a prison, a hospice, still paying, "
			+ "century after century, for what the Relay program took from "
			+ "them.\n\n"
			+ "They remember what true Conduction costs, and they remember why "
			+ "Caelis sealed itself: a continuity test, a wager that the world "
			+ "outside might someday produce a Conductor worth trusting with the "
			+ "keys.\n\n"
			+ "The test was arranged through expendable intermediaries. It "
			+ "succeeded. Its result is standing in their ward."
		)
	},
	"The Civic Core": {
		"text": (
			"Caelis has petitioned to resume stewardship of the Source. The "
			+ "factions' answer is the Accord: a negotiated settlement placing "
			+ "the network under shared authority, the first document in three "
			+ "hundred years that every flag is asked to sign.\n\n"
			+ "Cassian drafts; the delegations bargain; the extremes on both "
			+ "sides reach for force. Restorationists who want the Empire back "
			+ "and hardliners who want the Source seized agree on exactly one "
			+ "thing: the talks must not succeed.\n\n"
			+ "The war's last battles will be fought over a negotiating table."
		)
	},
	"The Source": {
		"text": (
			"The Source was never a generator. It is a balancing network: the "
			+ "system that kept a civilization's power moving where it was "
			+ "needed, stable because it was whole.\n\n"
			+ "Fragmented, each piece is a bomb waiting for a hand. Reconnected "
			+ "and governed, it is a civilization again. The Empire understood "
			+ "that at the end, and dismantled itself to protect it.\n\n"
			+ "The Accord's signatures will decide which version the world gets. "
			+ "Every force that would rather burn the future than share it is "
			+ "already marching."
		)
	}
}

# Epilogue shown on completing the final mission (the Accord ending from
# documentation/Resonance_War_Narrative_Foundation.md).
const CAMPAIGN_EPILOGUE := (
	"Cassian's Accord holds. The factions publish the history they can safely "
	+ "share, return the most dangerous evidence to its vault, and place the "
	+ "Source under an authority no single flag owns.\n\n"
	+ "The war ends. The grids stabilize, and the cities stay lit.\n\n"
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
	["Asha Vale", "Grand Circuit Champion"], # 29
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
			"unit": "Helio Blade-081", "side": 1, "row": 1, "col": 4,
			"role": "priority", "locks_mana": false
		}]
	},
	"5:0": {
		"objective": {
			"type": "protect",
			"target_name": "Lysa's survey rig",
			"title": "Protect the Survey",
			"description": "Keep Lysa's marked survey rig operational and defeat the looters' Conductor."
		},
		"turn_limit": 7,
		"predeployed": [{
			"unit": "Relay Bastion-013", "side": 0, "row": 1, "col": 1,
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
			{"unit": "Helio Battery-057", "side": 1, "round": 2, "row": 0, "col": 6},
			{"unit": "Relay Lancer-009", "side": 1, "round": 4, "row": 2, "col": 6}
		]
	},
	"7:0": {
		"objective": {
			"type": "eliminate_target",
			"target_name": "the extraction leader",
			"title": "Cut Off the Extraction",
			"description": "Eliminate the marked leader before the retrieval crew can withdraw with its prize."
		},
		"turn_limit": 6,
		"predeployed": [{
			"unit": "Relay Lancer-003", "side": 1, "row": 1, "col": 4,
			"role": "priority", "locks_mana": false
		}],
		"reinforcements": [{
			"unit": "Helio Mender-126", "side": 1, "round": 3, "row": 0, "col": 6
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
			"unit": "Relay Ground Transport-216", "side": 0, "row": 1, "col": 2,
			"role": "protected", "stationary": false, "locks_mana": false
		}],
		"reinforcements": [
			{"unit": "Cinder Lancer-018", "side": 1, "round": 2, "row": 0, "col": 6},
			{"unit": "Cinder Battery-063", "side": 1, "round": 4, "row": 2, "col": 6}
		]
	},
	"33:0": {
		"objective": {
			"type": "survive",
			"rounds": 5,
			"title": "Hold the Junctions",
			"description": "Keep the repair crews working through round 5 while the defense automata surge."
		},
		"reinforcements": [
			{"unit": "Helio Weaver-055", "side": 1, "round": 2, "row": 0, "col": 6},
			{"unit": "Relay Bastion-014", "side": 1, "round": 3, "row": 2, "col": 6},
			{"unit": "Relay Blade-094", "side": 1, "round": 4, "row": 0, "col": 6}
		]
	},
	"55:0": {
		"objective": {
			"type": "rout",
			"kills": 10,
			"title": "Break the Offensive",
			"description": "Destroy 10 hardliner units. Their Conductor stays behind the line and cannot be attacked."
		},
		"turn_limit": 8,
		"reinforcements": [
			{"unit": "Cinder Bastion-166", "side": 1, "round": 2, "row": 1, "col": 6},
			{"unit": "Relay Blade-175", "side": 1, "round": 3, "row": 0, "col": 6},
			{"unit": "Zephyr Lancer-109", "side": 1, "round": 4, "row": 2, "col": 6},
			{"unit": "Cinder Weaver-199", "side": 1, "round": 5, "row": 1, "col": 6}
		]
	},
	"58:0": {
		"objective": {
			"type": "preserve",
			"target_name": "the doorkeepers",
			"title": "Trial of Passage",
			"description": "Defeat the gatekeeper's Conductor without destroying the marked doorkeepers. We need them as doorkeepers, not casualties."
		},
		"predeployed": [
			{
				"unit": "Brass Bastion-139", "side": 1, "row": 0, "col": 4,
				"role": "preserved", "stationary": true, "locks_mana": false
			},
			{
				"unit": "Cinder Bastion-167", "side": 1, "row": 2, "col": 4,
				"role": "preserved", "stationary": true, "locks_mana": false
			}
		]
	},
	"75:0": {
		"objective": {
			"type": "resonance",
			"amount": 20,
			"title": "Reconnect the Network",
			"description": "Spend 20 total mana on deployments to bring the fragments into balance. Defeating the defense Conductor also wins."
		},
		"mana": {"player_start": 3, "enemy_start": 2, "growth": 3, "cap": 10}
	}
}

const MISSION_ENEMY_SQUADS := [
	# Act 1
	["Relay Lancer-003", "Relay Battery-004", "Relay Blade-008", "Relay Mender-006", "Relay Blade-002", "Relay Bastion-007", "Relay Weaver-011", "Relay Bastion-001"],
	["Relay Mender-006", "Relay Weaver-011", "Relay Blade-002", "Relay Lancer-003", "Relay Battery-004", "Relay Bastion-007", "Relay Lancer-009", "Relay Battery-010"],
	["Relay Bastion-007", "Zephyr Battery-089", "Flux Weaver-210", "Flux Lancer-025", "Relay Blade-002", "Cinder Lancer-069", "Helio Mender-123", "Cinder Lancer-017"],
	["Relay Bastion-007", "Relay Mender-006", "Helio Blade-081", "Zephyr Blade-075", "Flux Lancer-031", "Zephyr Mender-209", "Flux Battery-020", "Flux Weaver-045"],
	["Relay Battery-010", "Cinder Weaver-115", "Relay Lancer-009", "Cinder Battery-066", "Cinder Weaver-090", "Relay Bastion-013", "Cinder Mender-213", "Cinder Blade-016"],
	["Relay Bastion-014", "Helio Weaver-026", "Relay Blade-008", "Helio Battery-057", "Helio Weaver-055", "Relay Lancer-009", "Helio Mender-126", "Helio Blade-082"],
	["Relay Lancer-003", "Helio Weaver-055", "Helio Mender-126", "Helio Battery-057", "Relay Weaver-011", "Helio Blade-081", "Relay Bastion-001", "Helio Mender-123"],
	["Cinder Blade-016", "Relay Bastion-001", "Cinder Battery-063", "Cinder Lancer-017", "Cinder Weaver-115", "Relay Mender-012", "Cinder Weaver-090", "Cinder Mender-213"],
	["Relay Bastion-013", "Cinder Lancer-069", "Cinder Blade-016", "Relay Mender-006", "Cinder Weaver-115", "Cinder Lancer-018", "Cinder Battery-063", "Relay Mender-012"],
	["Relay Bastion-001", "Relay Blade-002", "Brass Blade-117", "Brass Battery-084", "Brass Mender-051", "Relay Weaver-021", "Brass Lancer-077", "Brass Bastion-111"],
	["Relay Mender-012", "Helio Mender-049", "Relay Lancer-009", "Helio Battery-057", "Flux Weaver-210", "Zephyr Blade-075", "Brass Bastion-112", "Flux Bastion-053"],
	["Relay Lancer-009", "Relay Bastion-001", "Helio Weaver-026", "Helio Mender-050", "Helio Blade-082", "Relay Weaver-011", "Helio Mender-123", "Helio Battery-057"],
	["Relay Blade-002", "Relay Weaver-005", "Relay Battery-010", "Brass Lancer-044", "Cinder Blade-015", "Relay Mender-006", "Relay Bastion-007", "Relay Battery-004"],
	["Helio Mender-126", "Helio Mender-050", "Relay Bastion-001", "Relay Lancer-003", "Helio Blade-082", "Helio Battery-057", "Relay Blade-002", "Helio Weaver-032"],
	["Relay Battery-004", "Relay Weaver-011", "Zephyr Blade-076", "Relay Battery-010", "Relay Blade-002", "Relay Bastion-007", "Relay Mender-006", "Relay Lancer-009"],
	["Relay Bastion-001", "Helio Mender-102", "Helio Lancer-130", "Helio Bastion-134", "Helio Battery-061", "Helio Mender-050", "Helio Weaver-032", "Relay Blade-002"],
	["Relay Bastion-001", "Relay Blade-002", "Relay Blade-008", "Relay Weaver-011", "Cinder Blade-016", "Relay Battery-010", "Relay Mender-012", "Relay Lancer-003"],
	["Brass Mender-196", "Relay Blade-029", "Brass Lancer-044", "Brass Bastion-112", "Brass Battery-083", "Relay Battery-010", "Brass Weaver-028", "Relay Lancer-003"],
	["Cinder Weaver-091", "Flux Battery-020", "Relay Blade-085", "Flux Lancer-031", "Helio Bastion-172", "Helio Mender-127", "Brass Battery-098", "Cinder Battery-170"],
	["Cinder Mender-214", "Relay Blade-100", "Cinder Blade-016", "Cinder Lancer-017", "Cinder Battery-066", "Cinder Weaver-198", "Cinder Bastion-120", "Cinder Battery-064"],
	["Zephyr Mender-024", "Relay Weaver-022", "Zephyr Mender-209", "Zephyr Battery-039", "Relay Blade-174", "Zephyr Lancer-109", "Zephyr Battery-089", "Zephyr Bastion-113"],
	["Relay Weaver-022", "Relay Blade-085", "Flux Lancer-031", "Helio Bastion-134", "Helio Battery-058", "Flux Lancer-079", "Cinder Mender-214", "Relay Weaver-011"],
	# Act 2
	["Zephyr Mender-071", "Zephyr Mender-024", "Relay Blade-100", "Zephyr Battery-089", "Zephyr Lancer-037", "Zephyr Weaver-059", "Zephyr Battery-039", "Relay Bastion-014"],
	["Flux Mender-027", "Relay Blade-100", "Brass Bastion-104", "Cinder Lancer-017", "Brass Lancer-077", "Helio Battery-058", "Zephyr Bastion-152", "Relay Weaver-022"],
	["Relay Lancer-003", "Relay Battery-004", "Relay Weaver-005", "Relay Blade-008", "Cinder Lancer-017", "Relay Blade-002", "Relay Bastion-001", "Relay Mender-006"],
	["Relay Bastion-001", "Relay Weaver-005", "Relay Lancer-009", "Cinder Lancer-017", "Relay Battery-010", "Relay Blade-002", "Relay Mender-006", "Cinder Blade-015"],
	["Relay Bastion-001", "Relay Blade-002", "Relay Battery-010", "Brass Lancer-044", "Flux Battery-019", "Relay Mender-006", "Relay Weaver-011", "Relay Lancer-003"],
	["Relay Weaver-011", "Relay Mender-012", "Relay Weaver-021", "Zephyr Mender-023", "Cinder Blade-015", "Relay Bastion-007", "Relay Battery-010", "Relay Lancer-009"],
	["Flux Mender-027", "Flux Battery-140", "Relay Blade-029", "Flux Lancer-079", "Flux Weaver-211", "Flux Battery-020", "Flux Weaver-045", "Relay Bastion-014"],
	["Helio Weaver-055", "Helio Battery-057", "Helio Mender-127", "Relay Blade-094", "Helio Mender-050", "Helio Lancer-130", "Relay Bastion-014", "Relay Blade-121"],
	["Helio Mender-127", "Brass Lancer-077", "Helio Blade-081", "Brass Bastion-200", "Relay Blade-100", "Brass Bastion-111", "Cinder Battery-063", "Cinder Weaver-198"],
	["Zephyr Mender-023", "Brass Bastion-111", "Brass Lancer-077", "Flux Lancer-025", "Cinder Weaver-198", "Flux Weaver-210", "Brass Battery-084", "Relay Blade-086"],
	["Helio Mender-050", "Helio Weaver-056", "Flux Bastion-154", "Flux Lancer-031", "Flux Battery-140", "Brass Mender-051", "Cinder Blade-016", "Zephyr Blade-076"],
	["Zephyr Mender-023", "Relay Weaver-022", "Zephyr Lancer-038", "Relay Blade-086", "Zephyr Blade-075", "Zephyr Lancer-109", "Zephyr Battery-088", "Relay Bastion-014"],
	["Zephyr Mender-208", "Relay Bastion-014", "Zephyr Battery-039", "Zephyr Battery-089", "Zephyr Lancer-038", "Relay Blade-121", "Zephyr Weaver-059", "Relay Blade-174"],
	["Helio Battery-057", "Cinder Blade-015", "Brass Bastion-112", "Flux Weaver-211", "Zephyr Blade-076", "Cinder Lancer-018", "Zephyr Battery-039", "Cinder Mender-214"],
	["Cinder Lancer-018", "Cinder Battery-067", "Relay Blade-121", "Cinder Mender-214", "Cinder Battery-063", "Cinder Weaver-090", "Cinder Blade-015", "Cinder Bastion-120"],
	["Brass Lancer-044", "Brass Lancer-077", "Brass Weaver-028", "Relay Blade-029", "Brass Mender-196", "Brass Bastion-112", "Relay Blade-100", "Brass Battery-098"],
	["Cinder Battery-063", "Cinder Bastion-120", "Relay Blade-100", "Cinder Lancer-069", "Relay Blade-174", "Cinder Battery-066", "Cinder Mender-214", "Cinder Weaver-115"],
	["Cinder Weaver-115", "Cinder Mender-213", "Cinder Weaver-198", "Cinder Lancer-069", "Relay Blade-121", "Relay Blade-094", "Cinder Bastion-119", "Cinder Battery-064"],
	["Relay Weaver-022", "Cinder Bastion-120", "Brass Lancer-077", "Zephyr Mender-023", "Cinder Battery-063", "Relay Blade-094", "Helio Mender-127", "Cinder Lancer-017"],
	["Relay Blade-086", "Helio Mender-124", "Helio Weaver-026", "Helio Battery-061", "Relay Bastion-014", "Helio Lancer-130", "Helio Weaver-056", "Helio Battery-058"],
	["Cinder Battery-064", "Cinder Lancer-018", "Cinder Mender-213", "Relay Blade-121", "Cinder Battery-066", "Relay Blade-086", "Cinder Bastion-120", "Cinder Weaver-198"],
	["Relay Blade-086", "Helio Blade-082", "Relay Weaver-022", "Helio Weaver-056", "Helio Lancer-130", "Relay Bastion-013", "Helio Battery-057", "Helio Mender-127"],
	["Cinder Battery-064", "Brass Bastion-097", "Brass Mender-051", "Zephyr Battery-089", "Brass Blade-118", "Zephyr Bastion-152", "Flux Weaver-206", "Helio Lancer-130"],
	["Helio Mender-102", "Cinder Weaver-115", "Brass Bastion-097", "Relay Blade-029", "Flux Lancer-079", "Brass Bastion-136", "Brass Mender-052", "Helio Battery-061"],
	["Brass Weaver-034", "Brass Lancer-044", "Relay Blade-029", "Brass Blade-118", "Brass Mender-197", "Brass Battery-084", "Brass Bastion-139", "Brass Lancer-077"],
	["Brass Weaver-158", "Brass Bastion-139", "Relay Blade-029", "Relay Blade-086", "Brass Mender-197", "Brass Weaver-028", "Brass Battery-099", "Brass Lancer-077"],
	["Flux Mender-027", "Helio Bastion-172", "Relay Blade-101", "Cinder Bastion-120", "Flux Weaver-092", "Flux Mender-184", "Cinder Battery-066", "Zephyr Lancer-110"],
	["Brass Bastion-097", "Brass Lancer-044", "Brass Mender-180", "Relay Blade-101", "Brass Mender-051", "Brass Battery-098", "Relay Blade-035", "Relay Weaver-022"],
	["Flux Mender-027", "Brass Bastion-104", "Brass Bastion-136", "Relay Blade-164", "Zephyr Lancer-038", "Cinder Battery-064", "Brass Bastion-096", "Helio Weaver-056"],
	["Cinder Weaver-199", "Cinder Bastion-166", "Relay Blade-175", "Flux Battery-140", "Zephyr Lancer-109", "Helio Mender-123", "Zephyr Weaver-150", "Zephyr Blade-076"],
	["Zephyr Weaver-059", "Brass Bastion-105", "Flux Blade-073", "Helio Mender-103", "Zephyr Battery-039", "Cinder Lancer-069", "Brass Mender-196", "Helio Bastion-172"],
	["Flux Mender-027", "Flux Battery-020", "Relay Weaver-022", "Flux Weaver-107", "Relay Blade-094", "Flux Bastion-054", "Flux Lancer-080", "Relay Bastion-014"],
	["Brass Battery-099", "Zephyr Lancer-178", "Zephyr Lancer-038", "Relay Blade-100", "Cinder Weaver-198", "Brass Mender-180", "Cinder Battery-065", "Cinder Bastion-167"],
	["Cinder Blade-016", "Helio Battery-058", "Cinder Mender-215", "Flux Battery-140", "Helio Lancer-130", "Brass Lancer-044", "Flux Weaver-192", "Brass Bastion-139"],
	["Relay Blade-085", "Zephyr Lancer-038", "Cinder Weaver-199", "Brass Battery-084", "Zephyr Battery-089", "Helio Mender-127", "Cinder Bastion-166", "Cinder Mender-213"],
	["Helio Bastion-129", "Zephyr Lancer-037", "Helio Mender-160", "Brass Bastion-104", "Helio Weaver-032", "Relay Blade-146", "Flux Blade-073", "Brass Battery-099"],
	["Cinder Battery-063", "Cinder Lancer-018", "Cinder Bastion-119", "Cinder Mender-215", "Relay Blade-122", "Relay Blade-146", "Cinder Bastion-167", "Relay Weaver-022"],
	["Cinder Bastion-166", "Cinder Weaver-198", "Cinder Weaver-116", "Cinder Battery-176", "Cinder Lancer-070", "Cinder Mender-148", "Cinder Bastion-119", "Relay Blade-086"],
	["Helio Weaver-055", "Flux Battery-140", "Zephyr Lancer-110", "Cinder Weaver-199", "Brass Bastion-112", "Relay Blade-175", "Zephyr Mender-072", "Helio Mender-162"],
	["Flux Mender-033", "Relay Blade-035", "Flux Weaver-093", "Helio Mender-102", "Brass Battery-098", "Zephyr Lancer-144", "Cinder Bastion-120", "Brass Bastion-112"],
	# Act 3 — the wardens and defenses of Caelis, escalating into the coalition
	# of every faction's best for the finale.
	["Brass Bastion-136", "Cinder Mender-149", "Brass Weaver-159", "Cinder Battery-183", "Brass Bastion-201", "Relay Blade-029", "Zephyr Lancer-038", "Flux Blade-073"],
	["Cinder Mender-148", "Zephyr Lancer-178", "Brass Bastion-105", "Zephyr Weaver-059", "Flux Lancer-080", "Helio Bastion-135", "Relay Blade-101", "Cinder Battery-191"],
	["Relay Blade-157", "Flux Weaver-093", "Zephyr Battery-040", "Flux Lancer-079", "Flux Mender-184", "Flux Bastion-154", "Helio Bastion-129", "Cinder Battery-191"],
	["Relay Blade-122", "Brass Weaver-159", "Brass Bastion-200", "Cinder Mender-148", "Flux Battery-140", "Brass Bastion-139", "Zephyr Lancer-202", "Flux Weaver-193"],
	["Helio Mender-125", "Zephyr Weaver-169", "Brass Bastion-105", "Zephyr Lancer-145", "Flux Weaver-189", "Brass Battery-099", "Helio Mender-162", "Brass Blade-118"],
	["Helio Bastion-129", "Cinder Battery-177", "Helio Mender-162", "Relay Blade-175", "Zephyr Lancer-203", "Brass Weaver-158", "Flux Weaver-212", "Brass Bastion-096"],
	["Helio Mender-143", "Zephyr Lancer-038", "Relay Blade-087", "Zephyr Weaver-060", "Helio Battery-058", "Flux Lancer-080", "Flux Bastion-154", "Brass Bastion-186"],
	["Helio Mender-163", "Zephyr Lancer-204", "Cinder Bastion-167", "Helio Mender-124", "Flux Battery-140", "Helio Weaver-056", "Relay Blade-094", "Zephyr Weaver-059"],
	["Relay Blade-147", "Relay Blade-156", "Brass Mender-052", "Zephyr Lancer-038", "Zephyr Battery-039", "Flux Weaver-189", "Helio Mender-125", "Brass Bastion-137"],
	["Zephyr Lancer-145", "Flux Weaver-093", "Brass Battery-098", "Zephyr Mender-071", "Relay Blade-122", "Helio Mender-125", "Cinder Bastion-167", "Relay Blade-175"],
	["Relay Blade-165", "Cinder Weaver-091", "Zephyr Bastion-114", "Helio Mender-102", "Flux Weaver-192", "Brass Bastion-105", "Flux Lancer-079", "Cinder Battery-067"],
	["Helio Lancer-131", "Cinder Mender-214", "Relay Blade-156", "Zephyr Battery-040", "Zephyr Weaver-169", "Cinder Weaver-091", "Helio Bastion-129", "Flux Battery-141"],
	["Helio Bastion-135", "Zephyr Battery-039", "Flux Weaver-189", "Brass Mender-181", "Brass Bastion-106", "Zephyr Lancer-204", "Zephyr Lancer-110", "Relay Blade-146"],
	["Cinder Bastion-167", "Zephyr Weaver-060", "Zephyr Lancer-110", "Flux Battery-141", "Brass Bastion-200", "Helio Mender-162", "Relay Blade-101", "Flux Mender-184"],
	["Brass Weaver-159", "Helio Mender-161", "Helio Mender-133", "Flux Weaver-193", "Relay Blade-095", "Cinder Battery-182", "Helio Bastion-173", "Zephyr Lancer-038"]
]

# 1-based chapter number for display ("CHAPTER 7"), derived from the order
# chapters first appear in MISSION_STORIES. Returns 0 for unknown chapters.
static func chapter_number(chapter_name: String) -> int:
	var seen: Array = []
	for index in QUESTS.size():
		var chapter: String = MISSION_STORIES.get(index + 1, {}).get("chapter", "")
		if chapter.is_empty():
			continue
		if chapter not in seen:
			seen.append(chapter)
		if chapter == chapter_name:
			return seen.size()
	return 0

static func build_missions() -> Array:
	var missions: Array = []
	for index in QUESTS.size():
		var quest: Array = QUESTS[index]
		var authored_pool: Array = quest[1].duplicate()
		for unit_name in ADDITIONAL_DROPS:
			if index + 1 in ADDITIONAL_DROPS[unit_name]:
				authored_pool.append(unit_name)
		var reward_pool: Array = authored_pool
		var enemy_hp := mini(20, 8 + floori(index / 4.0))
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
