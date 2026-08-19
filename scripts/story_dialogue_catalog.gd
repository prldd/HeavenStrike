class_name StoryDialogueCatalog
extends RefCounted

## Post-mission character scenes. Mission keys are 1-based so they match the
## narrative documents and the mission numbers shown to players. Keeping the
## script separate from main.gd lets dialogue be revised without touching UI
## or campaign-flow code.

const PORTRAIT_ROOT := "res://assets/dialogue/talking_heads/"
const ORIGINAL_PORTRAIT_ROOT := "res://assets/dialogue/portraits/"
const PORTRAITS := {
	"conductor": PORTRAIT_ROOT + "conductor.png",
	"nara": PORTRAIT_ROOT + "nara.png",
	"serin": PORTRAIT_ROOT + "serin.png",
	"ilyra": PORTRAIT_ROOT + "ilyra.png",
	"cassian": PORTRAIT_ROOT + "cassian.png",
	"rook": PORTRAIT_ROOT + "rook.png",
	"first_conductor": PORTRAIT_ROOT + "first_conductor.png",
	"lysa": ORIGINAL_PORTRAIT_ROOT + "lysa-vey.png",
	"asha": ORIGINAL_PORTRAIT_ROOT + "asha-vale.png",
	"dax": ORIGINAL_PORTRAIT_ROOT + "dax-calder.png"
}

const BACKGROUNDS := {
	"general": "res://assets/main-menu-steampunk-deck.png",
	"field": "res://assets/coal-set.png",
	"arena": "res://assets/neutral-set.png",
	"technical": "res://assets/fusion-menu.png",
	"workshop": "res://assets/dialogue/backgrounds/caelise-workshop.png",
	"caelis": "res://assets/dialogue/backgrounds/caelis-city.png"
}

const CHARACTERS := {
	"Conductor": {
		"role": "Reclamation technician · Conductor",
		"initials": "CO",
		"accent": "#67e6f4",
		"portrait": PORTRAITS.conductor,
		"portrait_kind": "human"
	},
	"Cassian": {
		"role": "Expedition logistics adjutant",
		"initials": "CA",
		"accent": "#efd38a",
		"portrait": PORTRAITS.cassian,
		"portrait_kind": "human"
	},
	"Director Rusk": {
		"role": "Expedition patron liaison",
		"initials": "DR",
		"accent": "#d4b06a",
		"portrait": "",
		"portrait_kind": "human"
	},
	"Lysa Vey": {
		"role": "Salvage-rights assessor",
		"initials": "LV",
		"accent": "#e8a87c",
		"portrait": PORTRAITS.lysa,
		"portrait_kind": "human"
	},
	"The Stranger": {
		"role": "Unknown observer",
		"initials": "?",
		"accent": "#b6a1e8",
		"portrait": PORTRAITS.ilyra,
		"portrait_kind": "human"
	},
	"Archivist Serin": {
		"role": "Order archivist",
		"initials": "AS",
		"accent": "#a8d8a0",
		"portrait": PORTRAITS.serin,
		"portrait_kind": "human"
	},
	"Asha Vale": {
		"role": "Grand Circuit champion",
		"initials": "AV",
		"accent": "#ef8d8d",
		"portrait": PORTRAITS.asha,
		"portrait_kind": "human"
	},
	"Dax Calder": {
		"role": "Ember-district negotiator",
		"initials": "DC",
		"accent": "#e3b778",
		"portrait": PORTRAITS.dax,
		"portrait_kind": "human"
	},
	"Brass Bastion-136": {
		"role": "Reclaimed Caelian automaton",
		"initials": "RK",
		"accent": "#9db7cf",
		"portrait": PORTRAITS.rook,
		"portrait_kind": "android"
	},
	"Nara": {
		"role": "Freed Relay candidate",
		"initials": "NA",
		"accent": "#d7a7c9",
		"portrait": PORTRAITS.nara,
		"portrait_kind": "human"
	},
	"Warden Ilyra": {
		"role": "Warden of Caelis",
		"initials": "WI",
		"accent": "#b6a1e8",
		"portrait": PORTRAITS.ilyra,
		"portrait_kind": "human"
	},
	"First Conductor": {
		"role": "Caelian android · Conductor Vault witness",
		"initials": "FC",
		"accent": "#d8c8a8",
		"portrait": PORTRAITS.first_conductor,
		"portrait_kind": "android"
	},
	"Caretaker Mara": {
		"role": "Township caretaker",
		"initials": "CM",
		"accent": "#c7b68b",
		"portrait": PORTRAITS.nara,
		"portrait_kind": "human"
	},
	"Evaluator Marren": {
		"role": "Conductor Registry evaluation officer",
		"initials": "EM",
		"accent": "#8b9bb4",
		"portrait": "",
		"portrait_kind": "human"
	},
	"General Strosse": {
		"role": "Hardliner field commander",
		"initials": "GS",
		"accent": "#a8725c",
		"portrait": "",
		"portrait_kind": "human"
	}
}

const INTERLUDES := {
	1: {
		"title": "A Useful Kind of Impossible",
		"location": "Relay Site · Equipment Gallery",
		"lines": [
			{"speaker": "Cassian", "text": "Two intact machines, one working relay, zero injuries. That's either excellent work or an accounting error."},
			{"speaker": "Conductor", "text": "The left one moved before I gave the signal."},
			{"speaker": "Cassian", "text": "Then do me a favor and leave that detail off the inventory sheet."},
			{"speaker": "Brass Bastion-136", "text": "Formation retained. Awaiting shared purpose."},
			{"speaker": "Conductor", "text": "It's been saying that since it woke up. I don't think it's quoting a manual."},
			{"speaker": "Cassian", "text": "No. I think it's asking a question."}
		]
	},
	3: {
		"title": "The Second Pulse",
		"location": "Relay Site · Collapsed Gallery",
		"lines": [
			{"speaker": "Conductor", "text": "The relay's still active. I can feel every machine in the dark, feeling for a way out."},
			{"speaker": "Cassian", "text": "You were under three tons of stone an hour ago. You shouldn't be feeling anything."},
			{"speaker": "Conductor", "text": "Cassian — they're afraid."},
			{"speaker": "Cassian", "text": "Then we get all of you out before someone decides fear counts as proof of ownership."}
		]
	},
	4: {
		"title": "The Official Version",
		"location": "Expedition Infirmary · Before Dawn",
		"lines": [
			{"speaker": "Director Rusk", "text": "A tragic accident. The consortium grieves, of course. We'll be sealing the site pending a full inquiry — our inquiry."},
			{"speaker": "Cassian", "text": "The activation was scheduled, sealed, and your observers signed the roster, Director. Accidents don't keep appointment books."},
			{"speaker": "Director Rusk", "text": "Grief makes people imaginative, adjutant. Don't let it make you expensive."},
			{"speaker": "Cassian", "text": "Clause nineteen of the salvage contract. Independent assessment before anything leaves that site. You signed it yourself."},
			{"speaker": "Director Rusk", "text": "…I'll have my office send flowers."},
			{"speaker": "Conductor", "text": "He's afraid of what the assessment finds."},
			{"speaker": "Cassian", "text": "He's afraid of who finds it first. So am I."}
		]
	},
	5: {
		"title": "What the Assessor Saw",
		"location": "Salvage Depot · Records Office",
		"lines": [
			{"speaker": "Lysa Vey", "text": "Your machine crossed three lanes to cover my surveyor. Nobody ordered it. I checked the logs twice."},
			{"speaker": "Conductor", "text": "It decided on its own."},
			{"speaker": "Lysa Vey", "text": "Don't rehearse that answer. It works better unrehearsed."},
			{"speaker": "Cassian", "text": "And what exactly will your report say?"},
			{"speaker": "Lysa Vey", "text": "What I saw. You two can decide whether that makes me your witness or your problem."}
		]
	},
	7: {
		"title": "A Warning Without a Name",
		"location": "Depot Roof · Rain Shift",
		"lines": [
			{"speaker": "The Stranger", "text": "Your survival in that gallery was not luck. The Relay was given a question, and it answered with you."},
			{"speaker": "Conductor", "text": "Who asked it?"},
			{"speaker": "The Stranger", "text": "People who have waited a long time to learn whether Conductors can return. I was sent to watch for the answer."},
			{"speaker": "Cassian", "text": "People with no names, apparently."},
			{"speaker": "The Stranger", "text": "Names are why they will come for you. I left coordinates in the Relay's dead channel; use them when you have somewhere safe to run."}
		]
	},
	9: {
		"title": "Passage Rights",
		"location": "Convoy Camp · Scavenger Border",
		"lines": [
			{"speaker": "Conductor", "text": "They hit us yesterday. Today you paid them for safe passage."},
			{"speaker": "Cassian", "text": "Their cousins. People who invoice by the family branch take the distinction very seriously."},
			{"speaker": "Conductor", "text": "What did it cost?"},
			{"speaker": "Cassian", "text": "Two repair crews, one favor, and letting them claim they escorted us the whole way. Pride is cheap when someone else pays for it in blood."}
		]
	},
	10: {
		"title": "Registered",
		"location": "Conductor Licensing Hall · South Annex",
		"lines": [
			{"speaker": "Cassian", "text": "Congratulations. Five governments now agree that you exist."},
			{"speaker": "Conductor", "text": "They certified me as an operator. The Relay's listed as restricted equipment."},
			{"speaker": "Cassian", "text": "Operator is the only box the form has. Be grateful — one of the amendments wanted you listed as part of the equipment."},
			{"speaker": "Conductor", "text": "How many amendments were there?"},
			{"speaker": "Cassian", "text": "Three. I framed the worst one."}
		]
	},
	14: {
		"title": "Truth and Leverage",
		"location": "Lysa's Safehouse · Back Room",
		"lines": [
			{"speaker": "Lysa Vey", "text": "The informant named the contractors. He also took their money, crossed the border on a forged pass, and perjured himself twice."},
			{"speaker": "Conductor", "text": "But what he told us was true."},
			{"speaker": "Cassian", "text": "Truth is what happened. Evidence is what can survive a room full of interested people."},
			{"speaker": "Lysa Vey", "text": "I hate it when you're reasonable."},
			{"speaker": "Cassian", "text": "Most people do."},
			{"speaker": "Lysa Vey", "text": "Save it. A township bridge just called for every machine in range, and we're the closest crew."}
		]
	},
	18: {
		"title": "After the Test",
		"location": "Evaluation Grounds · Medical Tent",
		"lines": [
			{"speaker": "Evaluator Marren", "text": "For the record: you passed. Off the record, I want you to hear the medical section out loud."},
			{"speaker": "Conductor", "text": "The squad was still moving. I could've finished the last exercise."},
			{"speaker": "Evaluator Marren", "text": "You were unconscious for six minutes, and your heart did what we politely call an irregular event. That's what conducting does to you — every time, a little more. My instruments say it accumulates."},
			{"speaker": "Conductor", "text": "Were the machines hurt?"},
			{"speaker": "Brass Bastion-136", "text": "Formation intact. Conductor condition unacceptable."},
			{"speaker": "Cassian", "text": "For once, the evaluator, the machine, and I all agree. Don't let the consensus go to your head."}
		]
	},
	20: {
		"title": "A Charter in Pencil",
		"location": "Depot Settlement · Supply Office",
		"lines": [
			{"speaker": "Conductor", "text": "The camp needs water lines, clinic power, and a winter roof. In that order."},
			{"speaker": "Cassian", "text": "It also needs to exist on paper before someone decides the land's empty."},
			{"speaker": "Conductor", "text": "Can a charter stop rain?"},
			{"speaker": "Cassian", "text": "No. It makes stealing the roof expensive. You keep them dry; I'll keep them legal."},
			{"speaker": "Lysa Vey", "text": "Then write fast. I decoded the Stranger's coordinates — an Order sanctuary past the eastern border."},
			{"speaker": "Conductor", "text": "We leave at dawn."}
		]
	},
	22: {
		"title": "The Name on the Manifest",
		"location": "Sanctuary · Sealed Archive",
		"lines": [
			{"speaker": "Archivist Serin", "text": "This transport manifest was filed forty-three years after the Empire supposedly collapsed."},
			{"speaker": "Lysa Vey", "text": "Cargo?"},
			{"speaker": "Archivist Serin", "text": "People. Records. Conductor equipment. All of it routed to Caelis."},
			{"speaker": "Conductor", "text": "Caelis was destroyed. Every schoolbook says so."},
			{"speaker": "Cassian", "text": "No. Caelis was removed from the story, and everyone agreed not to notice."}
		]
	},
	24: {
		"title": "Inside the Auction",
		"location": "Coal Embassy · Exhibition Week",
		"lines": [
			{"speaker": "Conductor", "text": "Every delegation offered support. Every offer ends with their officers running my deployments."},
			{"speaker": "Lysa Vey", "text": "An auction's flattering until the lot figures out what the paddles mean."},
			{"speaker": "Cassian", "text": "Let them bid. Competing claims are the closest thing we've got to independence."},
			{"speaker": "Conductor", "text": "You enjoy this."},
			{"speaker": "Cassian", "text": "I enjoy watching powerful people notice they aren't alone in the room."}
		]
	},
	29: {
		"title": "The Champion's Table",
		"location": "Grand Circuit · Empty Arena",
		"lines": [
			{"speaker": "Asha Vale", "text": "You fight like a mechanic. Every move repairs the position the last one left."},
			{"speaker": "Conductor", "text": "That sounded like an insult."},
			{"speaker": "Asha Vale", "text": "I lost. It'd be a poor one. It's the closest thing to respect I hand out."},
			{"speaker": "Cassian", "text": "Listen to them applaud. Every patron in those boxes still thinks your victory belongs to them."},
			{"speaker": "Asha Vale", "text": "Then sit carefully. The arena's more honest than the table."}
		]
	},
	30: {
		"title": "Old Employment",
		"location": "Border Camp · Captured Pay Office",
		"lines": [
			{"speaker": "Lysa Vey", "text": "I know this guild seal because I used to carry it."},
			{"speaker": "Cassian", "text": "That detail was missing from your professional history."},
			{"speaker": "Lysa Vey", "text": "You didn't ask questions you couldn't use the answers to."},
			{"speaker": "Conductor", "text": "Can you get us inside?"},
			{"speaker": "Lysa Vey", "text": "Yes. That's the part I was hoping you wouldn't ask."}
		]
	},
	32: {
		"title": "The Hall Is Coming Down",
		"location": "Ceasefire Hall · Moments After Detonation",
		"lines": [
			{"speaker": "Lysa Vey", "text": "DOWN! Away from the windows — there could be a second charge!"},
			{"speaker": "Conductor", "text": "The west arch is folding. Rook, brace it! There are people under that gallery."},
			{"speaker": "Cassian", "text": "The aides were at those doors. I put them there."},
			{"speaker": "Lysa Vey", "text": "Cassian. Eyes on me. The exits might be trapped and the bombers might still be inside — I need you here, not in that doorway."},
			{"speaker": "Cassian", "text": "They spared the principals and killed the people who made this summit possible. They wanted witnesses to carry the fear home."},
			{"speaker": "Conductor", "text": "Then they don't get to pick what survives. We pull out everyone we can, and then we find who lit the fuse."}
		]
	},
	36: {
		"title": "Terms in Hand",
		"location": "Capital Broadcast Hall · Service Tunnel",
		"lines": [
			{"speaker": "Conductor", "text": "They announced the grid was stable while we were still carrying batteries into the hospital."},
			{"speaker": "Cassian", "text": "Institutions lie to survive. Remember who taught you that."},
			{"speaker": "Conductor", "text": "You almost sound proud of them."},
			{"speaker": "Cassian", "text": "No. I'm saying the grid fails again unless we change the people who keep hiding the damage, not just the wiring."}
		]
	},
	37: {
		"title": "The Old Name",
		"location": "Riverside Township · Festival Square",
		"lines": [
			{"speaker": "Caretaker Mara", "text": "We called that one Rook. It stood outside the school through every storm."},
			{"speaker": "Brass Bastion-136", "text": "Caretaker Mara. Evacuation count: thirty-seven. All accounted for."},
			{"speaker": "Caretaker Mara", "text": "That was sixty years ago."},
			{"speaker": "Conductor", "text": "It didn't forget you. It just didn't have anyone left to tell."}
		]
	},
	39: {
		"title": "The Missing Note",
		"location": "Narrow Pass · Coalition Camp",
		"lines": [
			{"speaker": "Conductor", "text": "I close my eyes and the Relay's still reaching for it. There's a gap where its signal used to be."},
			{"speaker": "Brass Bastion-136", "text": "Formation reports one position absent."},
			{"speaker": "Cassian", "text": "The salvagers hit the pass at dawn."},
			{"speaker": "Conductor", "text": "Then we're gone before dawn."},
			{"speaker": "Cassian", "text": "Transports are already ordered."}
		]
	},
	40: {
		"title": "No One Left as Salvage",
		"location": "Depot Workshop · Recovery Bay",
		"lines": [
			{"speaker": "Lysa Vey", "text": "The chassis can't be restored. Not the way it was."},
			{"speaker": "Conductor", "text": "I know."},
			{"speaker": "Brass Bastion-136", "text": "Recovery acknowledged. Formation remembers."},
			{"speaker": "Cassian", "text": "Was going back worth the risk?"},
			{"speaker": "Conductor", "text": "Ask the ones who watched us come back for it."}
		]
	},
	41: {
		"title": "A Map Made Honest",
		"location": "Coalition Headquarters · Cartography Room",
		"lines": [
			{"speaker": "Archivist Serin", "text": "Every founding faction signed the deletion order. Different seals, same ink formula, same day."},
			{"speaker": "Lysa Vey", "text": "Five enemies agreeing to erase one city."},
			{"speaker": "Cassian", "text": "Which means the lie was worth more than their rivalry ever was."},
			{"speaker": "Conductor", "text": "Put Caelis back on the map."},
			{"speaker": "Archivist Serin", "text": "The map just answered. A dormant transit frequency is broadcasting coordinates — signed by your Stranger."}
		]
	},
	42: {
		"title": "The Patron Chain",
		"location": "Abandoned Relay Station · Lower Platform",
		"lines": [
			{"speaker": "The Stranger", "text": "The experiment was purchased through six intermediaries. Your patrons saw only an invoice."},
			{"speaker": "Cassian", "text": "I know these names. Rusk's consortium, half the charter board. I've eaten at their tables."},
			{"speaker": "Conductor", "text": "Did they know I might die?"},
			{"speaker": "The Stranger", "text": "Rusk and the others paid. They were careful never to ask what they had bought. That is not the same as planning it."},
			{"speaker": "Cassian", "text": "Then we ask for them, publicly — but not while they can still hire every clan between here and the capital. I need Dax Calder first."}
		]
	},
	44: {
		"title": "Open Ledger",
		"location": "Guildhall Steps · Public Record Bell",
		"lines": [
			{"speaker": "Lysa Vey", "text": "Resignation's filed. Credentials suspended. My former guild would like me arrested."},
			{"speaker": "Cassian", "text": "The coalition needs an independent assessor."},
			{"speaker": "Lysa Vey", "text": "You mean an assessor no respectable office will touch."},
			{"speaker": "Conductor", "text": "We were never especially respectable."},
			{"speaker": "Lysa Vey", "text": "First convincing offer I've heard all day."}
		]
	},
	45: {
		"title": "Possession",
		"location": "Coalition Depot · Source-Core Vault",
		"lines": [
			{"speaker": "Conductor", "text": "We took the core so no faction could turn it into a weapon."},
			{"speaker": "Cassian", "text": "And now every faction sees a weapon with our troops standing around it."},
			{"speaker": "Lysa Vey", "text": "Intent doesn't show up on an inventory."},
			{"speaker": "Conductor", "text": "Then the vault gets five locks and five different keys. Nobody opens it alone — including us."},
			{"speaker": "Cassian", "text": "That may be the first political solution you've ever proposed. I'll present it at Unity Day, where every faction answers in front of the public."}
		]
	},
	47: {
		"title": "The Hardliner's Position",
		"location": "Coalition Headquarters · Detention Block",
		"lines": [
			{"speaker": "General Strosse", "text": "If you came for a confession, adjutant, file a requisition. I'll give you a position instead: the Source is too dangerous to share, and your coalition is a story moderates tell to postpone deciding who controls it."},
			{"speaker": "Cassian", "text": "That story kept five armies from the gate."},
			{"speaker": "General Strosse", "text": "For a season. Paper holds until the day it doesn't, and then the side with discipline takes the field. That's not treason. That's arithmetic."},
			{"speaker": "Conductor", "text": "Your arithmetic put guns on a Unity Day crowd."},
			{"speaker": "General Strosse", "text": "And your improvisation broke a prepared coup in four hours. I don't admire improvisation, Conductor — but I know soldiering when it beats mine."},
			{"speaker": "Cassian", "text": "Noted. For the tribunal."},
			{"speaker": "General Strosse", "text": "Quote it exactly. I'd hate to be misrepresented."}
		]
	},
	49: {
		"title": "The Ground We Surrendered",
		"location": "Evacuated Township · Western Ridge",
		"lines": [
			{"speaker": "Asha Vale", "text": "By sunset, each army claims we handed this town to the other two."},
			{"speaker": "Conductor", "text": "They can keep the streets. The people are breathing."},
			{"speaker": "Cassian", "text": "I'll make sure the record separates ground surrendered from lives saved."},
			{"speaker": "Asha Vale", "text": "Records won't stop the next army."},
			{"speaker": "Conductor", "text": "No. People might."}
		]
	},
	50: {
		"title": "Terms of Respect",
		"location": "Truce Line · Shared Command Tent",
		"lines": [
			{"speaker": "Dax Calder", "text": "My people held the eastern sector. Yours made a dramatic amount of noise in the west."},
			{"speaker": "Conductor", "text": "Is that a compliment?"},
			{"speaker": "Dax Calder", "text": "It's an invoice with the total removed."},
			{"speaker": "Cassian", "text": "The truce needs a joint patrol commander."},
			{"speaker": "Dax Calder", "text": "Then I accept, provided the mechanic promises not to repair my personality."}
		]
	},
	51: {
		"title": "A Refusal in Formation",
		"location": "Forward Depot · Resonance Bay",
		"lines": [
			{"speaker": "Conductor", "text": "They ignored the attack order. Then they shielded the medics instead."},
			{"speaker": "Brass Bastion-136", "text": "Purpose conflict. Destruction unnecessary. Protection retained."},
			{"speaker": "Cassian", "text": "An army that can refuse its commander will terrify every government on the map."},
			{"speaker": "Conductor", "text": "Good. That scares me less than one that can't."}
		]
	},
	52: {
		"title": "The Signal to Withdraw",
		"location": "Negotiation House · Private Stair",
		"lines": [
			{"speaker": "Conductor", "text": "You committed the squad before you told me the plan."},
			{"speaker": "Cassian", "text": "If either delegation had known the withdrawal was arranged, they'd have refused it."},
			{"speaker": "Conductor", "text": "I'm not either delegation."},
			{"speaker": "Cassian", "text": "No. You're the person I trusted to survive my decision."},
			{"speaker": "Conductor", "text": "Next time, trust me before the decision."}
		]
	},
	53: {
		"title": "The Network Listens",
		"location": "Failed Grid District · Relay Substation",
		"lines": [
			{"speaker": "Archivist Serin", "text": "The fragments synchronized under battlefield loads. No operator issued anything."},
			{"speaker": "Conductor", "text": "It felt like the Relay does when the machines reach for one another."},
			{"speaker": "Lysa Vey", "text": "You're telling me the power grid is frightened."},
			{"speaker": "Conductor", "text": "I'm telling you we've been assuming only people can notice a war."}
		]
	},
	54: {
		"title": "Asset, Prisoner, Person",
		"location": "Coalition Clinic · Intake Hall",
		"lines": [
			{"speaker": "Nara", "text": "I went in for a medical screening. I never touched a Relay, and they still decided my future belonged to them."},
			{"speaker": "Conductor", "text": "A screening isn't consent."},
			{"speaker": "Nara", "text": "After I refused the contract, my file stopped using my name."},
			{"speaker": "Cassian", "text": "I have that file. By morning, it's evidence."}
		]
	},
	55: {
		"title": "The Body Keeps the Account",
		"location": "Field Hospital · Conductive Ward",
		"lines": [
			{"speaker": "Cassian", "text": "The doctors won't clear you for another deployment."},
			{"speaker": "Conductor", "text": "The western front would've broken."},
			{"speaker": "Brass Bastion-136", "text": "Conductor survival priority elevated. Formation will interpose."},
			{"speaker": "Conductor", "text": "I never gave that order."},
			{"speaker": "Brass Bastion-136", "text": "Shared purpose does not require order."}
		]
	},
	56: {
		"title": "Cassian's Other Ledger",
		"location": "Coalition Headquarters · Records Cellar",
		"lines": [
			{"speaker": "Cassian", "text": "Informants, couriers, sympathetic clerks, and people owed favors by people owed favors."},
			{"speaker": "Conductor", "text": "How long have you had this network?"},
			{"speaker": "Cassian", "text": "Long enough that telling you earlier would've made you responsible for it."},
			{"speaker": "Lysa Vey", "text": "That isn't how responsibility works."},
			{"speaker": "Cassian", "text": "No. It's how plausible deniability works."}
		]
	},
	58: {
		"title": "A Charter Still in Force",
		"location": "Western Conduit Gate · Royalist Court",
		"lines": [
			{"speaker": "Archivist Serin", "text": "The gate charter carries the seal of Caelis. Legally, it never expired."},
			{"speaker": "Cassian", "text": "Then neither did the authority that issued it."},
			{"speaker": "Conductor", "text": "You sound pleased."},
			{"speaker": "Cassian", "text": "I'm pleased the door opened. I'm concerned about who kept the keys."}
		]
	},
	60: {
		"title": "Former Opponents",
		"location": "Conduit Route · Joint Strike Camp",
		"lines": [
			{"speaker": "Asha Vale", "text": "I brought the people you beat in the Circuit. They already know you can win."},
			{"speaker": "Conductor", "text": "Do they know how to take an order from me?"},
			{"speaker": "Asha Vale", "text": "No. They know how to understand an objective. That's usually better."},
			{"speaker": "Cassian", "text": "The coalition appears to have acquired an army."},
			{"speaker": "Asha Vale", "text": "Call it a team until you earn the other word."}
		]
	},
	61: {
		"title": "The Invitation",
		"location": "Caelian Transit Terminus · The Far Door",
		"lines": [
			{"speaker": "The Stranger", "text": "My name is Ilyra. I am a Warden of Caelis."},
			{"speaker": "Warden Ilyra", "text": "I was sent to observe the continuity test and bring home any Conductor who survived it."},
			{"speaker": "Conductor", "text": "Home? I've never seen Caelis."},
			{"speaker": "Warden Ilyra", "text": "The Relay has. To the Wardens, that distinction is sufficient."},
			{"speaker": "Cassian", "text": "Then the Wardens are about to learn what distinctions cost."}
		]
	},
	62: {
		"title": "At the Threshold",
		"location": "Caelis · Outer Inspection Court",
		"lines": [
			{"speaker": "Warden Ilyra", "text": "No foreign delegation has crossed this threshold in three hundred years."},
			{"speaker": "Cassian", "text": "Then it's fortunate we came as a coalition rather than a foreign power."},
			{"speaker": "Lysa Vey", "text": "That sentence shouldn't have worked."},
			{"speaker": "Cassian", "text": "It worked because everyone here wants a reason not to start shooting."},
			{"speaker": "Conductor", "text": "The machines know this place. They've gone quiet."}
		]
	},
	65: {
		"title": "Stewardship",
		"location": "Caelis · Maintenance District",
		"lines": [
			{"speaker": "Warden Ilyra", "text": "You could have seized the district machines through the Relay."},
			{"speaker": "Conductor", "text": "They already had work and a purpose. They didn't need mine."},
			{"speaker": "Warden Ilyra", "text": "The old Conductors would have called that restraint."},
			{"speaker": "Brass Bastion-136", "text": "Correction. Recognition."}
		]
	},
	67: {
		"title": "Five True Stories",
		"location": "Imperial Archive · Founding Galleries",
		"lines": [
			{"speaker": "Archivist Serin", "text": "Each faction preserved one honest fragment: discipline, industry, faith, freedom, ambition."},
			{"speaker": "Lysa Vey", "text": "And each built a whole history around its favorite piece."},
			{"speaker": "Cassian", "text": "A lie can be made entirely from truths arranged for the wrong purpose."},
			{"speaker": "Conductor", "text": "Then we show them the pieces fit together."}
		]
	},
	68: {
		"title": "What Remains Sealed",
		"location": "Imperial Archive · Deep Vault",
		"lines": [
			{"speaker": "Cassian", "text": "You haven't told us what was in the final record."},
			{"speaker": "Conductor", "text": "Not yet."},
			{"speaker": "Cassian", "text": "I've spent years arguing that hidden history is a weapon."},
			{"speaker": "Conductor", "text": "Then trust me when I say this one's still loaded."},
			{"speaker": "Cassian", "text": "I do. I don't like how much it costs both of us."},
			{"speaker": "Archivist Serin", "text": "The record names living witnesses in the Conductor Vault. We should hear them before deciding what the world can bear."}
		]
	},
	69: {
		"title": "Company in the Relay",
		"location": "Caelis · Conductor Vault",
		"lines": [
			{"speaker": "First Conductor", "text": "They taught your age that we commanded machines, because command is easier to regulate than companionship."},
			{"speaker": "Conductor", "text": "The Relay is hurting me."},
			{"speaker": "First Conductor", "text": "Yes. Shared purpose means shared weight. The old Empire praised the gift and hid the bill."},
			{"speaker": "Brass Bastion-136", "text": "Weight shared. Conductor not alone."},
			{"speaker": "First Conductor", "text": "And you were not chosen by chance. Ask the Warden council why it needed a new Conductor badly enough to spend your life on the answer."}
		]
	},
	70: {
		"title": "Continuity Test",
		"location": "Warden Council · Witness Chamber",
		"lines": [
			{"speaker": "Warden Ilyra", "text": "We authorized the continuity test. The intermediaries were never told what it was."},
			{"speaker": "Conductor", "text": "I was never told anything."},
			{"speaker": "Warden Ilyra", "text": "Caelis needed to know whether Conduction could take hold again. We were afraid it could not."},
			{"speaker": "Cassian", "text": "You turned a person into a question because you were afraid of the answer."},
			{"speaker": "Warden Ilyra", "text": "Yes. There is no honorable wording for it. The council will summon you to the Crown Relay — your survival was the answer it wanted."}
		]
	},
	71: {
		"title": "Succession",
		"location": "Conductor Vault · Crown Relay",
		"lines": [
			{"speaker": "Warden Ilyra", "text": "The honor guard has withdrawn. The offer stands: accept the Vault, and Caelis will recognize you as successor."},
			{"speaker": "Conductor", "text": "My answer's still no."},
			{"speaker": "Cassian", "text": "One good ruler is still a system waiting for one bad heir."},
			{"speaker": "Conductor", "text": "Open the doors. Let the world help carry what it uses."},
			{"speaker": "Warden Ilyra", "text": "Then Caelis will petition the coalition in the morning. If we cannot name a successor, we will argue for stewardship in the open."}
		]
	},
	72: {
		"title": "The Petition",
		"location": "Caelis Council Hall · Coalition Table",
		"lines": [
			{"speaker": "Warden Ilyra", "text": "Caelis petitions to resume stewardship of the Source."},
			{"speaker": "Dax Calder", "text": "A polite word for ownership."},
			{"speaker": "Asha Vale", "text": "Then counter it with terms, not weapons."},
			{"speaker": "Cassian", "text": "For the first time, everyone who claims the Source is in one room. Keeping them here is the victory."},
			{"speaker": "Conductor", "text": "Then I'll keep the doors standing."}
		]
	},
	74: {
		"title": "The Architect",
		"location": "Accord Chamber · Third Night",
		"lines": [
			{"speaker": "Cassian", "text": "The draft gives no faction a permanent majority. Source access requires shared inspection."},
			{"speaker": "Conductor", "text": "My name isn't in it."},
			{"speaker": "Cassian", "text": "No."},
			{"speaker": "Conductor", "text": "Good. If the peace needs me forever, we didn't repair anything."},
			{"speaker": "Cassian", "text": "Now you sound like an institution builder. Tomorrow the signatories send one joint repair team into the Source; the Accord lives only if that team works."}
		]
	},
	75: {
		"title": "The Balancing Network",
		"location": "Source Complex · Distribution Heart",
		"lines": [
			{"speaker": "Archivist Serin", "text": "The Source doesn't create power. It balances unlike systems so none can consume the rest."},
			{"speaker": "Conductor", "text": "It was never one machine."},
			{"speaker": "Warden Ilyra", "text": "Nor was the Empire, until it forgot."},
			{"speaker": "Cassian", "text": "Then the engineering diagram and the Accord require the same design."}
		]
	},
	76: {
		"title": "The War Gets a Name",
		"location": "Source Approach · Allied Field Line",
		"lines": [
			{"speaker": "Asha Vale", "text": "Coal holds the center. Wind scouts the conduits. Solar medics are treating Fusion troops."},
			{"speaker": "Dax Calder", "text": "A week ago, any of those sentences would've started a riot."},
			{"speaker": "Warden Ilyra", "text": "The marshal named it better than any of us could. Caelis will keep his word for it, in memory of all five factions' dead."},
			{"speaker": "Conductor", "text": "Record who stood together, too."}
		]
	},
	77: {
		"title": "What Outlives Us",
		"location": "Caelis · Accord Hall at Dawn",
		"lines": [
			{"speaker": "Cassian", "text": "Quiet, for the end of a war."},
			{"speaker": "Lysa Vey", "text": "You've been smiling at the filing clauses for ten minutes."},
			{"speaker": "Warden Ilyra", "text": "The Source is reconnecting. It recognizes no single master."},
			{"speaker": "Brass Bastion-136", "text": "Formation expanded. Purpose shared."},
			{"speaker": "Conductor", "text": "Good. Now we fix what the war left broken."},
			{"speaker": "Cassian", "text": "And this time, we leave instructions someone else can use."}
		]
	}
}

static func scene_for_mission(mission_id: int) -> Dictionary:
	var scene: Dictionary = INTERLUDES.get(mission_id + 1, {})
	if scene.is_empty():
		return {}
	var result := scene.duplicate(true)
	result["background"] = background_for_scene(result)
	return result

static func has_interlude(mission_id: int) -> bool:
	return INTERLUDES.has(mission_id + 1)

static func character(speaker: String) -> Dictionary:
	var details: Dictionary = CHARACTERS.get(speaker, {
		"role": "Campaign character",
		"initials": speaker.left(2).to_upper(),
		"accent": "#efd38a"
	})
	return details.duplicate(true)

static func background_for_scene(scene: Dictionary) -> String:
	var explicit_background: String = scene.get("background", "")
	if not explicit_background.is_empty():
		return explicit_background
	var location := String(scene.get("location", "")).to_lower()
	if _contains_any(location, [
		"caelis", "source", "imperial archive", "conductor vault",
		"warden council", "accord"
	]):
		return BACKGROUNDS.caelis
	if _contains_any(location, ["arena", "circuit", "evaluation grounds"]):
		return BACKGROUNDS.arena
	if _contains_any(location, [
		"relay", "grid", "substation", "clinic", "hospital", "infirmary",
		"conductive ward", "inspection"
	]):
		return BACKGROUNDS.technical
	if _contains_any(location, [
		"depot", "workshop", "supply", "records", "archive", "cartography",
		"pay office", "maintenance"
	]):
		return BACKGROUNDS.workshop
	if _contains_any(location, [
		"field", "pass", "border", "camp", "ridge", "route", "gate", "roof",
		"approach", "truce line"
	]):
		return BACKGROUNDS.field
	return BACKGROUNDS.general

static func _contains_any(text: String, terms: Array) -> bool:
	for term in terms:
		if text.contains(String(term)):
			return true
	return false
