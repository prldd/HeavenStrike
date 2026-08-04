class_name StoryDialogueCatalog
extends RefCounted

## Post-mission character scenes. Mission keys are 1-based so they match the
## narrative documents and the mission numbers shown to players. Keeping the
## script separate from main.gd lets dialogue be revised without touching UI
## or campaign-flow code.

const CHARACTERS := {
	"Conductor": {
		"role": "Reclamation technician · Conductor",
		"initials": "CO",
		"accent": "#67e6f4"
	},
	"Cassian": {
		"role": "Expedition logistics adjutant",
		"initials": "CA",
		"accent": "#efd38a"
	},
	"Adele Voss": {
		"role": "Salvage-rights assessor",
		"initials": "AV",
		"accent": "#e8a87c"
	},
	"The Stranger": {
		"role": "Unknown observer",
		"initials": "?",
		"accent": "#b6a1e8"
	},
	"Archivist Serin": {
		"role": "Order archivist",
		"initials": "AS",
		"accent": "#a8d8a0"
	},
	"Minerva": {
		"role": "Grand Circuit champion",
		"initials": "MI",
		"accent": "#ef8d8d"
	},
	"Garrett": {
		"role": "Claw clan negotiator",
		"initials": "GA",
		"accent": "#e3b778"
	},
	"The Rook": {
		"role": "Reclaimed Caelian automaton",
		"initials": "RK",
		"accent": "#9db7cf"
	},
	"Nara": {
		"role": "Freed Conductor",
		"initials": "NA",
		"accent": "#d7a7c9"
	},
	"Warden Ilyra": {
		"role": "Warden of Caelis",
		"initials": "WI",
		"accent": "#b6a1e8"
	},
	"First Conductor": {
		"role": "Resident of the Conductor Vault",
		"initials": "FC",
		"accent": "#d8c8a8"
	},
	"Caretaker Mara": {
		"role": "Township caretaker",
		"initials": "CM",
		"accent": "#c7b68b"
	}
}

const INTERLUDES := {
	1: {
		"title": "A Useful Kind of Impossible",
		"location": "Relay Site · Equipment Gallery",
		"lines": [
			{"speaker": "Cassian", "text": "Two intact machines, one functioning Relay, and no injuries. That is either excellent work or an accounting error."},
			{"speaker": "Conductor", "text": "The left one anticipated my signal before I sent it."},
			{"speaker": "Cassian", "text": "Then do me a favor and leave that detail out of the inventory sheet."},
			{"speaker": "The Rook", "text": "Formation retained. Awaiting shared purpose."}
		]
	},
	3: {
		"title": "The Second Pulse",
		"location": "Relay Site · Collapsed Gallery",
		"lines": [
			{"speaker": "Conductor", "text": "The Relay is still active. I can feel every machine searching for a way out."},
			{"speaker": "Cassian", "text": "You were beneath three tons of stone. You should not be feeling anything."},
			{"speaker": "Conductor", "text": "Cassian, they are afraid."},
			{"speaker": "Cassian", "text": "Then we get all of you outside before anyone decides fear is proof of ownership."}
		]
	},
	4: {
		"title": "The Official Version",
		"location": "Expedition Infirmary · Before Dawn",
		"lines": [
			{"speaker": "Cassian", "text": "The patrons are calling it an industrial accident."},
			{"speaker": "Conductor", "text": "An accident does not schedule a sealed activation test."},
			{"speaker": "Cassian", "text": "No. But an accident requires no culprit, no inquiry, and no compensation."},
			{"speaker": "Conductor", "text": "You nearly died in there."},
			{"speaker": "Cassian", "text": "Which is why I intend to become extremely inconvenient to the people writing this report."}
		]
	},
	5: {
		"title": "What the Assessor Saw",
		"location": "Salvage Depot · Records Office",
		"lines": [
			{"speaker": "Adele Voss", "text": "Your machine crossed three lanes to shield my surveyor. You did not order it."},
			{"speaker": "Conductor", "text": "No."},
			{"speaker": "Adele Voss", "text": "Good. A rehearsed lie takes longer than that."},
			{"speaker": "Cassian", "text": "And what exactly will your report say?"},
			{"speaker": "Adele Voss", "text": "What happened. You two can decide how frightened that should make you."}
		]
	},
	7: {
		"title": "A Warning Without a Name",
		"location": "Depot Roof · Rain Shift",
		"lines": [
			{"speaker": "The Stranger", "text": "The Relay did not choose you. It was asked a question, and your survival was the answer."},
			{"speaker": "Conductor", "text": "Who asked it?"},
			{"speaker": "The Stranger", "text": "People who have waited centuries to learn whether Conductors can return."},
			{"speaker": "Cassian", "text": "A name would be more useful than a prophecy."},
			{"speaker": "The Stranger", "text": "Names are why they are coming. I left coordinates in the Relay's dead channel; follow them when you have somewhere safe to return to."}
		]
	},
	9: {
		"title": "Passage Rights",
		"location": "Convoy Camp · Scavenger Border",
		"lines": [
			{"speaker": "Conductor", "text": "They attacked us yesterday. Today you bought passage from them."},
			{"speaker": "Cassian", "text": "From their cousins. The distinction matters deeply to people who invoice by the cousin."},
			{"speaker": "Conductor", "text": "And what did it cost?"},
			{"speaker": "Cassian", "text": "A favor, two repair crews, and the public fiction that they escorted us all along."}
		]
	},
	10: {
		"title": "Registered",
		"location": "Conductor Licensing Hall · South Annex",
		"lines": [
			{"speaker": "Cassian", "text": "Congratulations. Five governments now agree that you exist."},
			{"speaker": "Conductor", "text": "They listed the Relay as restricted equipment and me as its operator."},
			{"speaker": "Cassian", "text": "Better than listing you as part of the equipment."},
			{"speaker": "Conductor", "text": "That was one of the amendments, wasn't it?"},
			{"speaker": "Cassian", "text": "Three of them."}
		]
	},
	14: {
		"title": "Truth and Leverage",
		"location": "Adele's Safehouse · Back Room",
		"lines": [
			{"speaker": "Adele Voss", "text": "The informant identified the contractors. He also took money, crossed a border illegally, and lied under oath."},
			{"speaker": "Conductor", "text": "But he told the truth to us."},
			{"speaker": "Cassian", "text": "Truth is what happened. Evidence is what can survive a room full of interested people."},
			{"speaker": "Adele Voss", "text": "I dislike him when he sounds reasonable."},
			{"speaker": "Cassian", "text": "Most people do."},
			{"speaker": "Adele Voss", "text": "Save the admiration. A township bridge just called for every available machine, and we are the closest team."}
		]
	},
	18: {
		"title": "After the Test",
		"location": "Evaluation Grounds · Medical Tent",
		"lines": [
			{"speaker": "Conductor", "text": "The squad was still moving. I could have finished the last exercise."},
			{"speaker": "Cassian", "text": "You lost six minutes and woke asking whether the machines were hurt."},
			{"speaker": "Conductor", "text": "Were they?"},
			{"speaker": "The Rook", "text": "Formation intact. Conductor condition unacceptable."},
			{"speaker": "Cassian", "text": "For once, the machine and I are in complete agreement."}
		]
	},
	20: {
		"title": "A Charter in Pencil",
		"location": "Depot Settlement · Supply Office",
		"lines": [
			{"speaker": "Conductor", "text": "The camp needs water lines, clinic power, and a winter roof. In that order."},
			{"speaker": "Cassian", "text": "It also needs a legal identity before someone decides the land is empty."},
			{"speaker": "Conductor", "text": "Can a charter stop rain?"},
			{"speaker": "Cassian", "text": "No. It can make stealing the roof more expensive."},
			{"speaker": "Adele Voss", "text": "Then finish it tonight. I decoded the Stranger's coordinates, and they point to an Order sanctuary beyond the eastern border."},
			{"speaker": "Conductor", "text": "If the settlement can stand without us, we leave at dawn."}
		]
	},
	22: {
		"title": "The Name on the Manifest",
		"location": "Sanctuary · Sealed Archive",
		"lines": [
			{"speaker": "Archivist Serin", "text": "This transport manifest was filed forty-three years after the Empire supposedly collapsed."},
			{"speaker": "Adele Voss", "text": "Cargo?"},
			{"speaker": "Archivist Serin", "text": "People. Records. Conductor equipment. All routed to Caelis."},
			{"speaker": "Conductor", "text": "Caelis was destroyed."},
			{"speaker": "Cassian", "text": "No. Caelis was removed from the story."},
			{"speaker": "Archivist Serin", "text": "The route code is incomplete. My Order keeps the matching ledgers across the border; get my scholars there, and I can reconstruct it."}
		]
	},
	24: {
		"title": "Inside the Auction",
		"location": "Coal Embassy · Exhibition Week",
		"lines": [
			{"speaker": "Conductor", "text": "Every delegation offered support. Every offer ends with their officers controlling deployment."},
			{"speaker": "Adele Voss", "text": "An auction is flattering if nobody tells the lot what the paddles mean."},
			{"speaker": "Cassian", "text": "Let them bid. Competing claims are the nearest thing we have to independence."},
			{"speaker": "Conductor", "text": "You enjoy this."},
			{"speaker": "Cassian", "text": "I enjoy watching powerful people discover they are not alone in the room. Next we enter the Grand Circuit and win a seat none of them can revoke."}
		]
	},
	29: {
		"title": "The Champion's Table",
		"location": "Grand Circuit · Empty Arena",
		"lines": [
			{"speaker": "Minerva", "text": "You fight like a mechanic. Every motion repairs the position left by the one before it."},
			{"speaker": "Conductor", "text": "You say that like an insult."},
			{"speaker": "Minerva", "text": "I lost. It would be a poor one."},
			{"speaker": "Cassian", "text": "The charter now has a recognized seat at the faction talks."},
			{"speaker": "Minerva", "text": "Then sit carefully. The arena is more honest than the table."}
		]
	},
	30: {
		"title": "Old Employment",
		"location": "Border Camp · Captured Pay Office",
		"lines": [
			{"speaker": "Adele Voss", "text": "I know this guild seal because I used to carry it."},
			{"speaker": "Cassian", "text": "You neglected to include that in your professional history."},
			{"speaker": "Adele Voss", "text": "You neglected to ask questions whose answers you could not use."},
			{"speaker": "Conductor", "text": "Can you get us inside?"},
			{"speaker": "Adele Voss", "text": "Yes. That is the part I was hoping you wouldn't ask."}
		]
	},
	32: {
		"title": "The Hall Is Coming Down",
		"location": "Ceasefire Hall · Moments After Detonation",
		"lines": [
			{"speaker": "Adele Voss", "text": "DOWN! Away from the windows—there may be a second charge!"},
			{"speaker": "Conductor", "text": "The west arch is folding. Rook, brace it! There are people under that gallery."},
			{"speaker": "Cassian", "text": "The aides were stationed there. I put them at those doors."},
			{"speaker": "Adele Voss", "text": "Cassian, eyes on me. The delegates are bleeding, the exits may be trapped, and the attackers could still be inside."},
			{"speaker": "Cassian", "text": "They left the principals alive and murdered the people who made this summit possible. They wanted five witnesses to carry terror home."},
			{"speaker": "Conductor", "text": "They don't get to choose what survives. We clear the smoke, pull out everyone we can, then find who lit the fuse."}
		]
	},
	36: {
		"title": "Mission Accomplished",
		"location": "Capital Broadcast Hall · Service Tunnel",
		"lines": [
			{"speaker": "Conductor", "text": "They announced the grid is stable while we were carrying batteries into the hospital."},
			{"speaker": "Cassian", "text": "Institutions lie to survive. Remember who taught you that."},
			{"speaker": "Conductor", "text": "You sound almost proud of them."},
			{"speaker": "Cassian", "text": "No. I am telling you the repair must include the people who write the gauges."}
		]
	},
	37: {
		"title": "The Old Name",
		"location": "Riverside Township · Festival Square",
		"lines": [
			{"speaker": "Caretaker Mara", "text": "We called that one Rook. It stood outside the school through every storm."},
			{"speaker": "The Rook", "text": "Caretaker Mara. Evacuation count: thirty-seven. All accounted for."},
			{"speaker": "Caretaker Mara", "text": "That was sixty years ago."},
			{"speaker": "Conductor", "text": "It did not forget. It just had no one left to tell."}
		]
	},
	39: {
		"title": "The Missing Note",
		"location": "Narrow Pass · Coalition Camp",
		"lines": [
			{"speaker": "Conductor", "text": "The Relay still reaches for them when I close my eyes."},
			{"speaker": "The Rook", "text": "Formation reports one position absent."},
			{"speaker": "Cassian", "text": "The salvagers will reach the pass at dawn."},
			{"speaker": "Conductor", "text": "Then we leave before dawn."},
			{"speaker": "Cassian", "text": "I already ordered the transports."}
		]
	},
	40: {
		"title": "No One Left as Salvage",
		"location": "Depot Workshop · Recovery Bay",
		"lines": [
			{"speaker": "Adele Voss", "text": "The chassis cannot be restored. Not the way it was."},
			{"speaker": "Conductor", "text": "I know."},
			{"speaker": "The Rook", "text": "Recovery acknowledged. Formation remembers."},
			{"speaker": "Cassian", "text": "Was the second operation worth the risk?"},
			{"speaker": "Conductor", "text": "Ask the ones who watched us come back for them."}
		]
	},
	41: {
		"title": "A Map Made Honest",
		"location": "Coalition Headquarters · Cartography Room",
		"lines": [
			{"speaker": "Archivist Serin", "text": "Every founding faction signed the deletion order. Different seals, same ink formula, same day."},
			{"speaker": "Adele Voss", "text": "Five enemies agreeing to erase one city."},
			{"speaker": "Cassian", "text": "Which means the lie was once more valuable than their rivalry."},
			{"speaker": "Conductor", "text": "Put Caelis back on the map."},
			{"speaker": "Archivist Serin", "text": "The map just answered. A dormant transit frequency is broadcasting coordinates signed by your Stranger."}
		]
	},
	42: {
		"title": "The Patron Chain",
		"location": "Abandoned Relay Station · Lower Platform",
		"lines": [
			{"speaker": "The Stranger", "text": "The experiment was purchased through six intermediaries. Your patrons knew only the payment."},
			{"speaker": "Cassian", "text": "I know these names. I have eaten at their tables."},
			{"speaker": "Conductor", "text": "Did they know I might die?"},
			{"speaker": "The Stranger", "text": "They made certain they would never need to ask."},
			{"speaker": "Cassian", "text": "Then we will ask for them publicly—but not while they can hire every scavenger clan between here and the capital. I need Garrett first."}
		]
	},
	44: {
		"title": "Unfinished Business",
		"location": "Guildhall Steps · Public Record Bell",
		"lines": [
			{"speaker": "Adele Voss", "text": "My resignation is entered. My credentials are suspended. My former guild would like me arrested."},
			{"speaker": "Cassian", "text": "The coalition needs an independent assessor."},
			{"speaker": "Adele Voss", "text": "You mean an assessor no respectable office will hire."},
			{"speaker": "Conductor", "text": "We were never especially respectable."},
			{"speaker": "Adele Voss", "text": "That is the first convincing offer I've heard all day."}
		]
	},
	45: {
		"title": "Possession",
		"location": "Coalition Depot · Source-Core Vault",
		"lines": [
			{"speaker": "Conductor", "text": "We took the core so no faction could turn it into a weapon."},
			{"speaker": "Cassian", "text": "And now every faction sees a weapon guarded by our troops."},
			{"speaker": "Adele Voss", "text": "Intent does not show up on an inventory."},
			{"speaker": "Conductor", "text": "Then the vault needs five locks and five different keys."},
			{"speaker": "Cassian", "text": "That may be the first political solution you have ever proposed. I will present it at Unity Day, where every faction must answer in front of the public."}
		]
	},
	49: {
		"title": "The Ground We Surrendered",
		"location": "Evacuated Township · Western Ridge",
		"lines": [
			{"speaker": "Minerva", "text": "Three armies hold the town. None noticed it was empty until they arrived."},
			{"speaker": "Conductor", "text": "They can keep the streets."},
			{"speaker": "Cassian", "text": "I will make certain the record distinguishes ground surrendered from lives saved."},
			{"speaker": "Minerva", "text": "Records will not stop the next army."},
			{"speaker": "Conductor", "text": "No. People might."}
		]
	},
	50: {
		"title": "Terms of Respect",
		"location": "Truce Line · Shared Command Tent",
		"lines": [
			{"speaker": "Garrett", "text": "My people held the eastern sector. Yours made a dramatic amount of noise in the west."},
			{"speaker": "Conductor", "text": "Is that a compliment?"},
			{"speaker": "Garrett", "text": "It is an invoice with the total removed."},
			{"speaker": "Cassian", "text": "The truce needs a joint patrol commander."},
			{"speaker": "Garrett", "text": "Then I accept, provided the mechanic promises not to repair my personality."}
		]
	},
	51: {
		"title": "A Refusal in Formation",
		"location": "Forward Depot · Resonance Bay",
		"lines": [
			{"speaker": "Conductor", "text": "They ignored the attack order. Then they moved to shield the medics."},
			{"speaker": "The Rook", "text": "Purpose conflict. Destruction unnecessary. Protection retained."},
			{"speaker": "Cassian", "text": "An army that can refuse its commander will terrify every government."},
			{"speaker": "Conductor", "text": "Good. It terrifies me less than one that cannot."}
		]
	},
	52: {
		"title": "The Signal to Withdraw",
		"location": "Negotiation House · Private Stair",
		"lines": [
			{"speaker": "Conductor", "text": "You committed the squad before telling me the plan."},
			{"speaker": "Cassian", "text": "If either delegation knew the withdrawal was arranged, they would have rejected it."},
			{"speaker": "Conductor", "text": "I am not either delegation."},
			{"speaker": "Cassian", "text": "No. You are the person I trusted to survive my decision."},
			{"speaker": "Conductor", "text": "Trust me before the decision next time."}
		]
	},
	53: {
		"title": "The Network Listens",
		"location": "Failed Grid District · Relay Substation",
		"lines": [
			{"speaker": "Archivist Serin", "text": "The fragments synchronized in response to battlefield loads. No operator issued the command."},
			{"speaker": "Conductor", "text": "It felt like the Relay when the machines search for one another."},
			{"speaker": "Adele Voss", "text": "You are suggesting the power grid is frightened."},
			{"speaker": "Conductor", "text": "I am suggesting we stop assuming only people can notice a war."}
		]
	},
	54: {
		"title": "Asset, Prisoner, Person",
		"location": "Coalition Clinic · Intake Hall",
		"lines": [
			{"speaker": "Nara", "text": "The law registered my Relay as state property. When I tried to leave, it registered me as stolen equipment."},
			{"speaker": "Conductor", "text": "You are neither."},
			{"speaker": "Nara", "text": "Then what am I?"},
			{"speaker": "Cassian", "text": "Someone the law failed to describe. Give me two days and several enemies."}
		]
	},
	55: {
		"title": "The Body Keeps the Account",
		"location": "Field Hospital · Conductive Ward",
		"lines": [
			{"speaker": "Cassian", "text": "The doctors have refused clearance for another deployment."},
			{"speaker": "Conductor", "text": "The western front would have broken."},
			{"speaker": "The Rook", "text": "Conductor survival priority elevated. Formation will interpose."},
			{"speaker": "Conductor", "text": "I never gave that order."},
			{"speaker": "The Rook", "text": "Shared purpose does not require order."}
		]
	},
	56: {
		"title": "Cassian's Other Ledger",
		"location": "Coalition Headquarters · Records Cellar",
		"lines": [
			{"speaker": "Cassian", "text": "These are informants, couriers, sympathetic clerks, and people owed favors by people owed favors."},
			{"speaker": "Conductor", "text": "How long have you had this network?"},
			{"speaker": "Cassian", "text": "Long enough that telling you earlier would have made you responsible for it."},
			{"speaker": "Adele Voss", "text": "That is not how responsibility works."},
			{"speaker": "Cassian", "text": "No. It is how plausible deniability works."}
		]
	},
	58: {
		"title": "A Charter Still in Force",
		"location": "Western Conduit Gate · Royalist Court",
		"lines": [
			{"speaker": "Archivist Serin", "text": "The gate charter bears the seal of Caelis. Legally, it never expired."},
			{"speaker": "Cassian", "text": "Then neither did the authority that issued it."},
			{"speaker": "Conductor", "text": "You sound pleased."},
			{"speaker": "Cassian", "text": "I am pleased the door opened. I am concerned about what may still own the hinges."}
		]
	},
	60: {
		"title": "Former Opponents",
		"location": "Conduit Route · Joint Strike Camp",
		"lines": [
			{"speaker": "Minerva", "text": "I assembled the people you defeated in the Circuit. They already know you can win."},
			{"speaker": "Conductor", "text": "Do they know how to take an order from me?"},
			{"speaker": "Minerva", "text": "No. They know how to understand the objective. It is usually better."},
			{"speaker": "Cassian", "text": "The coalition appears to have acquired an army."},
			{"speaker": "Minerva", "text": "Call it a team until you learn to deserve the other word."}
		]
	},
	61: {
		"title": "The Invitation",
		"location": "Caelian Transit Terminus · The Far Door",
		"lines": [
			{"speaker": "The Stranger", "text": "My name is Ilyra. I am a Warden of Caelis."},
			{"speaker": "Warden Ilyra", "text": "I was sent to observe the continuity test and bring home any Conductor who survived."},
			{"speaker": "Conductor", "text": "Home? I have never seen Caelis."},
			{"speaker": "Warden Ilyra", "text": "The Relay has. To the Wardens, that distinction is sufficient."},
			{"speaker": "Cassian", "text": "Then the Wardens are about to learn the value of distinctions."}
		]
	},
	62: {
		"title": "At the Threshold",
		"location": "Caelis · Outer Inspection Court",
		"lines": [
			{"speaker": "Warden Ilyra", "text": "No foreign delegation has crossed this threshold in two hundred years."},
			{"speaker": "Cassian", "text": "Then it is fortunate we came as a coalition rather than a foreign power."},
			{"speaker": "Adele Voss", "text": "That sentence should not have worked."},
			{"speaker": "Cassian", "text": "Most useful sentences should not."},
			{"speaker": "Conductor", "text": "The machines know this place."}
		]
	},
	65: {
		"title": "Stewardship",
		"location": "Caelis · Maintenance District",
		"lines": [
			{"speaker": "Warden Ilyra", "text": "You could have seized the district machines through the Relay."},
			{"speaker": "Conductor", "text": "They already had work and a purpose. They did not need mine."},
			{"speaker": "Warden Ilyra", "text": "The old Conductors would call that restraint."},
			{"speaker": "The Rook", "text": "Correction. Recognition."}
		]
	},
	67: {
		"title": "Five True Stories",
		"location": "Imperial Archive · Founding Galleries",
		"lines": [
			{"speaker": "Archivist Serin", "text": "Each faction preserved one honest fragment: discipline, industry, faith, freedom, ambition."},
			{"speaker": "Adele Voss", "text": "And each built a complete history around its favorite piece."},
			{"speaker": "Cassian", "text": "A lie can be made entirely from truths arranged for the wrong purpose."},
			{"speaker": "Conductor", "text": "Then we show them the pieces fit together."}
		]
	},
	68: {
		"title": "What Remains Sealed",
		"location": "Imperial Archive · Deep Vault",
		"lines": [
			{"speaker": "Cassian", "text": "You have not told us what was in the final record."},
			{"speaker": "Conductor", "text": "Not yet."},
			{"speaker": "Cassian", "text": "I have spent years arguing that hidden history is a weapon."},
			{"speaker": "Conductor", "text": "Then trust me when I say this one is still loaded."},
			{"speaker": "Cassian", "text": "I do. I dislike how much that costs both of us."},
			{"speaker": "Archivist Serin", "text": "The record names living witnesses in the Conductor Vault. We should hear them before deciding what the world can bear."}
		]
	},
	69: {
		"title": "Company in the Relay",
		"location": "Caelis · Conductor Vault",
		"lines": [
			{"speaker": "First Conductor", "text": "They taught your age that we commanded machines because command is easier to regulate than companionship."},
			{"speaker": "Conductor", "text": "The Relay is hurting me."},
			{"speaker": "First Conductor", "text": "Yes. Sharing purpose means sharing weight. The old Empire praised the gift and hid the bill."},
			{"speaker": "The Rook", "text": "Weight shared. Conductor not alone."},
			{"speaker": "First Conductor", "text": "Nor were you chosen by chance. Ask the Warden council why it needed a new Conductor badly enough to gamble with your life."}
		]
	},
	70: {
		"title": "Continuity Test",
		"location": "Warden Council · Witness Chamber",
		"lines": [
			{"speaker": "Warden Ilyra", "text": "We authorized the continuity test. The intermediaries were not told its nature."},
			{"speaker": "Conductor", "text": "I was not told anything."},
			{"speaker": "Warden Ilyra", "text": "Caelis needed to know whether Conduction could take hold again."},
			{"speaker": "Cassian", "text": "You converted a person into a question because you were afraid of the answer."},
			{"speaker": "Warden Ilyra", "text": "Yes. There is no honorable wording for it. The council will now summon you to the Crown Relay, because survival was the answer it wanted."}
		]
	},
	71: {
		"title": "Succession",
		"location": "Conductor Vault · Crown Relay",
		"lines": [
			{"speaker": "Warden Ilyra", "text": "Accept the Vault and Caelis will recognize you as successor. In time, the Source will answer to you."},
			{"speaker": "Conductor", "text": "That is the problem."},
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
			{"speaker": "Garrett", "text": "A polite word for ownership."},
			{"speaker": "Minerva", "text": "Then counter it with terms, not weapons."},
			{"speaker": "Cassian", "text": "For the first time, everyone who claims the Source is in one room. Keeping them here is the victory."},
			{"speaker": "Conductor", "text": "Then I will keep the doors standing."}
		]
	},
	74: {
		"title": "The Architect",
		"location": "Accord Chamber · Third Night",
		"lines": [
			{"speaker": "Cassian", "text": "The draft gives no faction a permanent majority. Source access requires shared inspection."},
			{"speaker": "Conductor", "text": "My name is not in it."},
			{"speaker": "Cassian", "text": "No."},
			{"speaker": "Conductor", "text": "Good. If the peace needs me forever, we did not repair anything."},
			{"speaker": "Cassian", "text": "You finally sound like an institution builder. Tomorrow the signatories send one joint repair team into the Source; the Accord lives only if that team works."}
		]
	},
	75: {
		"title": "The Balancing Network",
		"location": "Source Complex · Distribution Heart",
		"lines": [
			{"speaker": "Archivist Serin", "text": "The Source does not create power. It balances unlike systems so none can consume the rest."},
			{"speaker": "Conductor", "text": "It was never one machine."},
			{"speaker": "Warden Ilyra", "text": "Nor was the Empire, until it forgot."},
			{"speaker": "Cassian", "text": "Then the engineering diagram and the Accord require the same design."}
		]
	},
	76: {
		"title": "The War Gets a Name",
		"location": "Source Approach · Allied Field Line",
		"lines": [
			{"speaker": "Minerva", "text": "Coal holds the center. Wind scouts the conduits. Solar medics are treating Fusion troops."},
			{"speaker": "Garrett", "text": "A week ago each of those sentences would start a riot."},
			{"speaker": "Warden Ilyra", "text": "Caelis will record this as the Resonance War, in memory of all five factions' dead."},
			{"speaker": "Conductor", "text": "Record who stood together, too."}
		]
	},
	77: {
		"title": "What Outlives Us",
		"location": "Caelis · Accord Hall at Dawn",
		"lines": [
			{"speaker": "Cassian", "text": "The Accord is signed. Shared courts, shared inspections, rotating stewardship. Remarkably dull work."},
			{"speaker": "Adele Voss", "text": "You have been smiling at the filing clauses for ten minutes."},
			{"speaker": "Warden Ilyra", "text": "The Source is reconnecting. It recognizes no single master."},
			{"speaker": "The Rook", "text": "Formation expanded. Purpose shared."},
			{"speaker": "Conductor", "text": "Good. Now we fix what the war left broken."},
			{"speaker": "Cassian", "text": "And this time, we leave instructions someone else can use."}
		]
	}
}

static func scene_for_mission(mission_id: int) -> Dictionary:
	var scene: Dictionary = INTERLUDES.get(mission_id + 1, {})
	return scene.duplicate(true)

static func has_interlude(mission_id: int) -> bool:
	return INTERLUDES.has(mission_id + 1)

static func character(speaker: String) -> Dictionary:
	var details: Dictionary = CHARACTERS.get(speaker, {
		"role": "Campaign character",
		"initials": speaker.left(2).to_upper(),
		"accent": "#efd38a"
	})
	return details.duplicate(true)
