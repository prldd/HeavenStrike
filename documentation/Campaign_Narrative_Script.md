# War of Resonance — Campaign Narrative Script

This is a consolidated, human-readable dump of every piece of authored narrative
text in the campaign, for review and revision outside the game code.

**This file is generated. Do not edit it directly.** Run:

```bash
./tools/godot-headless.sh --script res://tools/generate_campaign_narrative.gd
```

**Sources (edit these):**

- `scripts/story_quest_catalog.gd` — `QUESTS` (mission titles), `MISSION_STORIES`
  (chapter, briefing, debriefing), `ENCOUNTER_RULES` (special objective text),
  `CAMPAIGN_PROLOGUE` (first-open orientation), `CHAPTER_CARDS` (per-chapter
  intro briefings), `CAMPAIGN_EPILOGUE`.
- `scripts/story_dialogue_catalog.gd` — `CHARACTERS` (cast) and `INTERLUDES`
  (post-mission dialogue scenes, keyed by 1-based mission number).

Voice and structure rules live in `documentation/Narrative_Style_Guide.md`.

Per mission: **Briefing** is the pre-battle description (the player's frame, the
practical problem), **Objective** is the authored special win condition when one
exists, **Debriefing** is the post-victory messaging (Cassian's frame, the
political consequence), and **Interlude** is the post-mission dialogue scene.

---

## Cast

| Speaker | Role |
|---------|------|
| Conductor | Reclamation technician · Conductor |
| Cassian | Expedition logistics adjutant |
| Director Rusk | Expedition patron liaison |
| Lysa Vey | Salvage-rights assessor |
| The Stranger | Unknown observer |
| Archivist Serin | Order archivist |
| Asha Vale | Grand Circuit champion |
| Dax Calder | Ember-district negotiator |
| Brass Bastion-136 | Reclaimed Caelian automaton |
| Nara | Freed Relay candidate |
| Warden Ilyra | Warden of Caelis |
| First Conductor | Caelian android · Conductor Vault witness |
| Caretaker Mara | Township caretaker |

---

## Campaign Prologue

*Shown the first time the operations map opens (replayable via WORLD BRIEF).*

Three hundred years ago, the Caelian Empire ran its whole civilization on the Source — one network that powered the cities, the transports, and the automatons that kept them alive. Imperial Conductors guided those machines through relay stations, lending them purpose with a thought.

Then the Empire fell. The Source went dark, the capital Caelis was lost, and the Conductors died with it. That is the story every school in every nation teaches.

Five successor nations rose from the provinces — Coal, Steam, Solar, Wind, and Fusion. Each kept a fragment of the old network running, and each is certain it alone can be trusted with what remains. Their armies field machines of their own, driven by licensed operators with control rigs — crude tools beside what the Empire's Conductors did with their minds.

You are a reclamation technician with a joint salvage expedition, paid to pull working Caelian machinery out of a dead relay site. The patrons funding the dig expect scrap value.

The site has other plans.

---

# Act 1

## Chapter 1 — The Salvage

*Chapter briefing (shown once when the chapter unlocks):*

Your expedition works a dormant Caelian relay site under a patrons' salvage contract: recover what still functions, catalogue what doesn't, and make the dig look worth its funding.

The machines coming out of the lower galleries have been dead for three centuries. They should not be waking up — and they definitely should not be watching you work.

### Mission 1 — First Synchrony

- **Briefing:** Field test day. Two of the automatons we pulled from the lower galleries are walking again, and the patrons want proof the dig is worth their money before they fund the next phase. Run them along the relay site perimeter and put them through a live drill. If they do anything the manuals don't cover, I hear it from you first.
- **Debriefing:** The drill goes clean — too clean. One of the machines moved half a second before your signal reached it. Cassian logs a success for the patrons, then seals the site to outside crews until the expedition knows what it has actually found. Off the record, he has started asking why the dig's funding arrived so quickly.

**Interlude — "A Useful Kind of Impossible"** *(Relay Site · Equipment Gallery)*

- **Cassian:** Two intact machines, one working relay, zero injuries. That's either excellent work or an accounting error.
- **Conductor:** The left one moved before I gave the signal.
- **Cassian:** Then do me a favor and leave that detail off the inventory sheet.
- **Brass Bastion-136:** Formation retained. Awaiting shared purpose.
- **Conductor:** It's been saying that since it woke up. I don't think it's quoting a manual.
- **Cassian:** No. I think it's asking a question.

### Mission 2 — Formation Trial

- **Briefing:** Two more machines woke overnight — that makes four. Tomorrow the patrons fire the relay itself: full activation, sealed test, their observers on the roster. Today belongs to us. Form the squad up and lean on the control link until it complains. If anything down here wants to surprise us, it can do it now.
- **Debriefing:** The link holds through everything we throw at it, and it shouldn't. Nobody has guided this many machines since the Empire, and nobody living is certified to try. None of that goes in the report. In his private ledger, Cassian writes one word beside your name and doesn't say it out loud: Conductor.

### Mission 3 — The Second Pulse

- **Briefing:** The relay fired early — hours ahead of schedule, nobody at the controls. The surge collapsed the lower gallery and tripped the site's Caelian security machines, and they are cutting our crew off from the exits. Hold the security line and get our people out.
- **Objective — Evacuate the Gallery:** Hold the security machines back through round 4 while the expedition crew escapes.
- **Debriefing:** Most of the crew reaches the upper gallery. Cassian's locator is still pulsing below the fire line. Three tons of stone came down on you and you walked out — and when you turned back for him, every machine turned with you, unasked. The relay is still humming, and no test schedule explains what it did to you.

**Interlude — "The Second Pulse"** *(Relay Site · Collapsed Gallery)*

- **Conductor:** The relay's still active. I can feel every machine in the dark, feeling for a way out.
- **Cassian:** You were under three tons of stone an hour ago. You shouldn't be feeling anything.
- **Conductor:** Cassian — they're afraid.
- **Cassian:** Then we get all of you out before someone decides fear counts as proof of ownership.

### Mission 4 — Sealed Ignition

- **Briefing:** The lower galleries are burning, and Cassian is trapped behind the security cordon — the site's warden core is still enforcing it, three hundred years dead or not. Break the line and bring him out. Nobody stays in a tomb we opened.
- **Objective — Break the Security Line:** Eliminate the marked security warden blocking Cassian's extraction route.
- **Debriefing:** You bring Cassian out breathing. He doesn't say thank you — he starts writing. When the patrons' director arrives to seal the site and call the matter settled, Cassian is waiting at the gate with the salvage contract in hand and a clause that forces an independent assessment before anyone removes so much as a bolt.

**Interlude — "The Official Version"** *(Expedition Infirmary · Before Dawn)*

- **Director Rusk:** A tragic accident. The consortium grieves, of course. We'll be sealing the site pending a full inquiry — our inquiry.
- **Cassian:** The activation was scheduled, sealed, and your observers signed the roster, Director. Accidents don't keep appointment books.
- **Director Rusk:** Grief makes people imaginative, adjutant. Don't let it make you expensive.
- **Cassian:** Clause nineteen of the salvage contract. Independent assessment before anything leaves that site. You signed it yourself.
- **Director Rusk:** …I'll have my office send flowers.
- **Conductor:** He's afraid of what the assessment finds.
- **Cassian:** He's afraid of who finds it first. So am I.

## Chapter 2 — The Aftermath

### Mission 5 — Independent Witness

- **Briefing:** Cassian's contract challenge brings salvage assessor Lysa Vey to the sealed relay site. When looters breach the perimeter during her inspection, protect her crew and keep the recovered machines out of the raiders' hands.
- **Objective — Protect the Survey:** Keep Lysa's marked survey rig operational and defeat the raider Conductor.
- **Debriefing:** Lysa's crew and the recovered machines survive the raid. Her independent assessment remains open, and the patrons' attempts to contain its findings only draw attention from officials across all five factions.

**Interlude — "What the Assessor Saw"** *(Salvage Depot · Records Office)*

- **Lysa Vey:** Your machine crossed three lanes to shield my surveyor. You did not order it.
- **Conductor:** No.
- **Lysa Vey:** Good. A rehearsed lie takes longer than that.
- **Cassian:** And what exactly will your report say?
- **Lysa Vey:** What happened. You two can decide how frightened that should make you.

### Mission 6 — Public Demonstration

- **Briefing:** The expedition's patrons have arranged a public demonstration to prove the reclaimed machines are safe. When the exhibition is disrupted, protect the spectators and regain control of the field.
- **Objective — Secure the Exhibition:** Hold the demonstration floor through round 5 while spectators reach the exits.
- **Debriefing:** The event was meant to quiet questions about the accident. Instead, images of the rescue make you famous and invitations flood Cassian's desk; one bears no seal, only a request to meet on the depot roof if you want to know why the Relay woke.

### Mission 7 — Dead-Channel Warning

- **Briefing:** A stranger claims the relay activation was deliberate and warns that its architects will come for their property. Moments later, armed crews close on your position. Fight your way clear.
- **Objective — Cut Off the Extraction:** Eliminate the marked leader before the armed crew can withdraw with its prize.
- **Debriefing:** The attackers knew the site's security routines and came prepared to take you alive. Their capture fails, but within hours their sponsors make a legal move for the salvage instead.

**Interlude — "A Warning Without a Name"** *(Depot Roof · Rain Shift)*

- **The Stranger:** The Relay did not choose you. It was asked a question, and your survival was the answer.
- **Conductor:** Who asked it?
- **The Stranger:** People who have waited centuries to learn whether Conductors can return.
- **Cassian:** A name would be more useful than a prophecy.
- **The Stranger:** Names are why they are coming. I left coordinates in the Relay's dead channel; follow them when you have somewhere safe to return to.

### Mission 8 — Salvage Claim

- **Briefing:** Hours after the stranger's attack, a scavenger consortium files a challenge to the expedition's salvage claim and brings an armed crew to enforce it. Hold the stockyard while Cassian compares their paperwork with the original contract.
- **Objective — Hold the Stockyard:** Keep control of the stockyard through round 4 while Cassian verifies the salvage claim.
- **Debriefing:** Cassian proves the claim was forged, but not cheaply or carelessly. With the stockyard exposed and another attempt certain, he orders the Relay machines moved to a defensible depot beyond the scavenger border.

### Mission 9 — Passage Rights

- **Briefing:** Raiders are following the convoy that carries the reclaimed machines to their new depot. Guard the transports and keep the route open.
- **Objective — Guard the Convoy:** Keep the marked transport operational and defeat the pursuing Conductor.
- **Debriefing:** The convoy reaches the depot intact. The new base is defensible, but operating it openly requires the one thing you do not yet have: a Conductor registration.

**Interlude — "Passage Rights"** *(Convoy Camp · Scavenger Border)*

- **Conductor:** They attacked us yesterday. Today you bought passage from them.
- **Cassian:** From their cousins. The distinction matters deeply to people who invoice by the cousin.
- **Conductor:** And what did it cost?
- **Cassian:** A favor, two repair crews, and the public fiction that they escorted us all along.

## Chapter 3 — Claims

### Mission 10 — Licensed Resistance

- **Briefing:** To keep the new depot from being seized as unlicensed Relay equipment, Cassian takes you to the regional licensing hall. Registration requires a certified field evaluation, and the examiners have supplied live opposition.
- **Debriefing:** You leave with a valid registration. Before you are clear of the grounds, the Joint Investigative Office cites the evaluation in an evidence order authorizing seizure of the depot and its machines.

**Interlude — "Registered"** *(Conductor Licensing Hall · South Annex)*

- **Cassian:** Congratulations. Five governments now agree that you exist.
- **Conductor:** They listed the Relay as restricted equipment and me as its operator.
- **Cassian:** Better than listing you as part of the equipment.
- **Conductor:** That was one of the amendments, wasn't it?
- **Cassian:** Three of them.

### Mission 11 — Depot Under Seal

- **Briefing:** Investigators have declared the depot and its machines evidence. Their armed escort is moving in to seize both, so defend the base while Cassian challenges the order.
- **Debriefing:** You keep the depot, but the official transcript calls it a dangerous armed compound that resisted a lawful inspection. The seizure order freezes normal deliveries, so Cassian begins a private record and sends essential supplies by an unmarked back route.

### Mission 12 — The Unmarked Route

- **Briefing:** The unmarked supply convoy Cassian routed around the depot seizure has been ambushed by raiders moving with military discipline. Break their line and recover anything that can identify who learned the route and hired them.
- **Debriefing:** The attackers carried contractor equipment with every serial number removed. As Cassian locks it away, three factions offer protection in exchange for control of your deployments; you refuse all three, and Lysa begins tracing the equipment through an informant.

### Mission 13 — Terms Refused

- **Briefing:** The three factions whose protection offers you refused answer together: a surprise safety inspection backed by armed troops. Keep them out of the depot while Cassian challenges the inspectors' authority.
- **Debriefing:** Cassian sends a courteous reply to every rejected envoy while the oldest machines begin following routines no one taught them. Lysa then reports that her informant can identify the contractors from the ambush, but his handlers are already moving him.

### Mission 14 — Safehouse Extraction

- **Briefing:** Lysa's informant can identify the contractors behind the supply ambush, but his handlers are watching the safehouse district. Cover her extraction team and bring him out before they relocate him.
- **Debriefing:** Lysa gets the informant out alive and scatters the handlers watching the safehouse. The contractor trail is finally within reach, though turning it into a case will be harder than winning the extraction.

**Interlude — "Truth and Leverage"** *(Lysa's Safehouse · Back Room)*

- **Lysa Vey:** The informant identified the contractors. He also took money, crossed a border illegally, and lied under oath.
- **Conductor:** But he told the truth to us.
- **Cassian:** Truth is what happened. Evidence is what can survive a room full of interested people.
- **Lysa Vey:** I dislike him when he sounds reasonable.
- **Cassian:** Most people do.
- **Lysa Vey:** Save the admiration. A township bridge just called for every available machine, and we are the closest team.

## Chapter 4 — The Proving

### Mission 15 — Failing Span

- **Briefing:** The team diverts from Lysa's safehouse to the failing transit bridge named in the distress call. Hold back its damaged security drones and keep the crossing open until every civilian is clear.
- **Debriefing:** Hundreds of civilians make it across before the bridge gives way. For the first time, people know the Conductor not as a threat or a curiosity, but as the person who came when they needed help.

### Mission 16 — Public Challenge

- **Briefing:** A guild champion has challenged the 'salvage Conductor' to a public match, hoping to end your new reputation. Meet the challenge and prove the bridge was no accident.
- **Debriefing:** The victory wins over the crowd and humiliates the house that sponsored your opponent. Cassian distributes the footage, accepting that the influence it buys also comes with a powerful grudge.

### Mission 17 — The Cost of Victory

- **Briefing:** Public hearings over the bridge rescue and the guild match have drawn rival crowds to the inquiry hall. Keep the delegates and demonstrators safe before the tension becomes a riot.
- **Debriefing:** The hearing enters your testimony into the record only after officials edit it to support their own positions. One officer on the evaluation panel objects publicly and offers to produce an honest account by testing the Relay under controlled conditions.

### Mission 18 — Field Certification

- **Briefing:** The officer who challenged the edited hearing record has arranged an independent evaluation at the proving grounds. Demonstrate the squad's full strength, but do not ignore the strain on your own body.
- **Debriefing:** The evaluation confirms your ability and describes the damage continued conducting may cause. Before releasing you, the officer asks for help with reports of conductor-less automatons repeating dangerous defense routines in a nearby township.

**Interlude — "After the Test"** *(Evaluation Grounds · Medical Tent)*

- **Conductor:** The squad was still moving. I could have finished the last exercise.
- **Cassian:** You lost six minutes and woke asking whether the machines were hurt.
- **Conductor:** Were they?
- **Brass Bastion-136:** Formation intact. Conductor condition unacceptable.
- **Cassian:** For once, the machine and I are in complete agreement.

### Mission 19 — Feral Signal

- **Briefing:** At the evaluation officer's request, travel to the nearby township where conductor-less automatons are repeating old defense routines. Protect the residents, even if some of the machines cannot be recovered.
- **Debriefing:** You save the township at the cost of valuable salvage. One surviving automaton follows the squad back to the depot, and Cassian quietly adds another place to the supply roster.

### Mission 20 — Charter Ground

- **Briefing:** Families displaced from the township have made camp beside the depot. Someone is using the crowded camp as cover to reach your stockpiles, so protect both the refugees and the supplies.
- **Debriefing:** The refugees choose to remain near the depot, turning a temporary camp into a small neighborhood. With water restored and winter supplies secured, the settlement can stand without the squad.

**Interlude — "A Charter in Pencil"** *(Depot Settlement · Supply Office)*

- **Conductor:** The camp needs water lines, clinic power, and a winter roof. In that order.
- **Cassian:** It also needs a legal identity before someone decides the land is empty.
- **Conductor:** Can a charter stop rain?
- **Cassian:** No. It can make stealing the roof more expensive.
- **Lysa Vey:** Then finish it tonight. I decoded the Stranger's coordinates, and they point to an Order sanctuary beyond the eastern border.
- **Conductor:** Then we leave at dawn.

## Chapter 5 — Sanctuary

### Mission 21 — Sanctuary Threshold

- **Briefing:** With the depot settlement protected by Cassian's new charter, the team can finally follow the Stranger's coordinates. They lead to a pre-collapse sanctuary whose Order archivists refuse to admit you, so secure access without damaging the site.
- **Debriefing:** The Order agrees to share the sanctuary after you prove you could have taken it by force. The lead archivist accepts the arrangement, though her attention remains fixed on your oldest machines.

### Mission 22 — Archive Breach

- **Briefing:** Ancient custodial machines still guard the sanctuary's inner vault. Disable them without destroying the archive, then reach the records they protect.
- **Debriefing:** The archive is secured intact. Its maintenance logs and transport ledgers can now be copied, but reconstructing their incomplete routes will require the Order's cross-border collection.

**Interlude — "The Name on the Manifest"** *(Sanctuary · Sealed Archive)*

- **Archivist Serin:** This transport manifest was filed forty-three years after the Empire supposedly collapsed.
- **Lysa Vey:** Cargo?
- **Archivist Serin:** People. Records. Conductor equipment. All routed to Caelis.
- **Conductor:** Caelis was destroyed.
- **Cassian:** No. Caelis was removed from the story.

# Act 2

## Chapter 6 — The Arena

### Mission 23 — Border Contract

- **Briefing:** To decode the Caelis manifest, Serin needs records held by Order scholars across an unpoliced border. Cassian makes their escort the reclamation charter's first contract; get the expedition and its copied records across safely.
- **Debriefing:** The scholars and records arrive safely, giving the charter its first successful contract. That public success draws invitations from all five factions, each offering support if the Conductor appears at its military exhibition.

### Mission 24 — Exhibition Match

- **Briefing:** The charter's successful Order escort has made you valuable enough that all five factions demand an appearance. Complete their competing exhibition circuit without accepting a patron, and be ready when staged exercises become real tests.
- **Debriefing:** By attending every exhibition, you avoid accepting any single faction's offer. Their bids prove the charter needs status none of them can grant alone, so Cassian enters you in the neutral Grand Circuit to win a recognized seat at the faction talks.

**Interlude — "Inside the Auction"** *(Coal Embassy · Exhibition Week)*

- **Conductor:** Every delegation offered support. Every offer ends with their officers controlling deployment.
- **Lysa Vey:** An auction is flattering if nobody tells the lot what the paddles mean.
- **Cassian:** Let them bid. Competing claims are the nearest thing we have to independence.
- **Conductor:** You enjoy this.
- **Cassian:** I enjoy watching powerful people discover they are not alone in the room.

### Mission 25 — Circuit Opening

- **Briefing:** The Grand Circuit settles political disputes through sponsored champions. The charter needs a title to earn a seat at the talks, so win the opening heat and begin the climb toward Asha Vale, the reigning champion.
- **Debriefing:** The first win earns the crowd's attention and changes the betting around the tournament. Cassian uses that interest to secure credit and access among the patrons' boxes.

### Mission 26 — Crowd Favorite

- **Briefing:** The second heat puts you against the tournament's crowd favorite. Win the match while Cassian studies which patrons support you and what they expect to gain.
- **Debriefing:** Two rival factions celebrate your victory, each convinced it serves their interests. Neither has understood why you entered the Circuit.

### Mission 27 — Fixed Odds

- **Briefing:** Your quarter-final opponent rejected a large payment to withdraw this morning. Expect a fair fight in the arena and interference from the people who wanted to prevent it.
- **Debriefing:** You win without benefiting from the attempted bribe. Cassian makes sure the other patrons learn who offered it, shifting suspicion away from the charter.

### Mission 28 — Honest Contest

- **Briefing:** A patron has ordered your semi-final opponent to surrender and present the result as a gift to you. Deny them that claim by forcing an honest match and winning it.
- **Debriefing:** Because the victory was earned, no patron can claim that you owe them for it. Cassian publicly thanks your opponent for refusing the arrangement, and the match-fixers reconsider their approach.

### Mission 29 — Championship Point

- **Briefing:** Only the final remains. Defeat the reigning champion, claim the title, and earn the reclamation charter a place in the faction talks.
- **Debriefing:** You leave the Circuit as its new champion, and Cassian converts the title into formal recognition of the charter. The access gained in the patrons' boxes also lets Lysa trace the earlier contractor payments to a border camp.

**Interlude — "The Champion's Table"** *(Grand Circuit · Empty Arena)*

- **Asha Vale:** You fight like a mechanic. Every motion repairs the position left by the one before it.
- **Conductor:** You say that like an insult.
- **Asha Vale:** I lost. It would be a poor one.
- **Cassian:** Listen to them applaud. Every patron out there still thinks your victory belongs to them.
- **Asha Vale:** Then sit carefully. The arena is more honest than the table.

## Chapter 7 — Fault Lines

### Mission 30 — Paper Trail

- **Briefing:** Using contacts opened by the Circuit victory, Lysa locates the border camp that paid the raiders who attacked the depot. Escort her there and recover proof of who funded the contract.
- **Debriefing:** The contracting house's pay chits and seal records are secured. Before the trail can be followed into the guild, a Wind city invokes the new charter for help with a Caelian war engine waking beneath its streets.

**Interlude — "Old Employment"** *(Border Camp · Captured Pay Office)*

- **Lysa Vey:** I know this guild seal because I used to carry it.
- **Cassian:** You neglected to include that in your professional history.
- **Lysa Vey:** You neglected to ask questions whose answers you could not use.
- **Conductor:** Can you get us inside?
- **Lysa Vey:** Yes. That is the part I was hoping you wouldn't ask.

### Mission 31 — Engine Below

- **Briefing:** The Wind city requests the independent charter because neighboring factions will only help in exchange for control of the buried machine. Reach the city, stop the awakened Caelian war engine, and keep it out of the populated districts.
- **Debriefing:** The city survives, but each faction blames another while inspecting the ancient machines beneath its own territory. To prevent the accusation from becoming a border war, Cassian calls an emergency ceasefire summit in the capital.

### Mission 32 — Summit Breach

- **Briefing:** Cassian brings the factions blaming one another for the Wind-city war engine into an emergency ceasefire summit. Attackers breach the hall before terms can be signed; protect the delegates and keep the building standing.
- **Debriefing:** The delegates stagger out through smoke while their aides lie beneath shattered gallery doors. Before the fires are contained, the summit is dead; across five capitals, hardliners are already using the fallen as proof that peace itself was a trap.

**Interlude — "The Hall Is Coming Down"** *(Ceasefire Hall · Moments After Detonation)*

- **Lysa Vey:** DOWN! Away from the windows—there may be a second charge!
- **Conductor:** The west arch is folding. Rook, brace it! There are people under that gallery.
- **Cassian:** The aides were stationed there. I put them at those doors.
- **Lysa Vey:** Cassian, eyes on me. The delegates are bleeding, the exits may be trapped, and the attackers could still be inside.
- **Cassian:** They left the principals alive and murdered the people who made this summit possible. They wanted five witnesses to carry terror home.
- **Conductor:** They don't get to choose what survives. We clear the smoke, pull out everyone we can, then find who lit the fuse.

### Mission 33 — Fragment Wake

- **Briefing:** While survivors are still being pulled from the bombed summit, synchronized power failures spread across two delegations' territories. Follow the repair crews to the nearest failing junction and keep emergency power running before the hospitals go dark.
- **Debriefing:** The failures are propagating between separate Source fragments, though officials blame severe weather. One government instead accuses its neighbor of sabotage and launches a retaliatory raid toward a civilian border district.

### Mission 34 — Border Retaliation

- **Briefing:** The sabotage accusation following the grid cascade has triggered retaliatory raids on both sides of the border. Intercept the strike force moving toward a civilian district before the fighting reaches its streets.
- **Debriefing:** The district is safe, but both governments condemn your intervention. Their raids have severed the remaining grid links, leaving two districts without stable power and only one repair crew able to move before winter.

### Mission 35 — One Grid, Two Districts

- **Briefing:** Damage from the border raids has left two district grids failing, and the only available repair crew cannot reach both in time. Secure the route to the district that can still be stabilized before winter.
- **Debriefing:** One district has power; the other now has a disaster around which its leaders can rally anger. There was no way to save both, but Cassian ensured that the final decision would be remembered as yours.

### Mission 36 — The Official Broadcast

- **Briefing:** Faction leaders plan to announce that the infrastructure crisis is over, even as the grid continues to fail. Protect the gathering and the repair crews working beneath it.
- **Debriefing:** Everyone on the stage knows the grid is still failing, but the announcement proceeds as written. To get the squad away from the capital's manufactured celebration, Cassian sends you to inspect repairs in the township you saved earlier.

**Interlude — "Terms in Hand"** *(Capital Broadcast Hall · Service Tunnel)*

- **Conductor:** They announced the grid is stable while we were carrying batteries into the hospital.
- **Cassian:** Institutions lie to survive. Remember who taught you that.
- **Conductor:** You sound almost proud of them.
- **Cassian:** No. I am saying the grid will fail again unless we also change the officials who keep hiding the damage.

## Chapter 8 — Heroes and Costs

### Mission 37 — Return to the Township

- **Briefing:** Cassian's repair inspection brings the squad back to the township saved from feral automatons. The residents turn the visit into a public welcome, where an elderly caretaker recognizes one of your oldest machines just before trouble reaches the square.
- **Debriefing:** The festival square is secured, and the elderly caretaker asks for a private word about the machine she recognized. Before the celebration resumes, a nearby commune sends an urgent messenger.

**Interlude — "The Old Name"** *(Riverside Township · Festival Square)*

- **Caretaker Mara:** We called that one Rook. It stood outside the school through every storm.
- **Brass Bastion-136:** Caretaker Mara. Evacuation count: thirty-seven. All accounted for.
- **Caretaker Mara:** That was sixty years ago.
- **Conductor:** It did not forget. It just had no one left to tell.

### Mission 38 — Forced Relocation

- **Briefing:** Answering the messenger from the township celebration, the squad travels to a nearby commune that refuses evacuation. Hold the line between its residents and the relocation force preparing to remove them at gunpoint.
- **Debriefing:** You protect the commune from an evacuation its residents never accepted. On the return journey, the supply convoy accompanying your squad is diverted through a narrow pass, where raiders close both exits.

### Mission 39 — Pass Intercept

- **Briefing:** The convoy returning from the commune is trapped in a narrow pass by a coordinated raid. Break the encirclement and bring every member of the squad home.
- **Debriefing:** One of your oldest machines falls while covering the retreat. Its presence remains faintly in the Relay, carried by the squad and by you even after its body goes still.

**Interlude — "The Missing Note"** *(Narrow Pass · Coalition Camp)*

- **Conductor:** The Relay still reaches for them when I close my eyes.
- **Brass Bastion-136:** Formation reports one position absent.
- **Cassian:** The salvagers will reach the pass at dawn.
- **Conductor:** Then we leave before dawn.
- **Cassian:** I already ordered the transports.

### Mission 40 — The Last Chassis

- **Briefing:** The fallen automaton's chassis remains behind enemy lines. Take the squad back to the pass and recover it before the salvagers arrive.
- **Debriefing:** The chassis is back at the depot. Waiting there is an urgent message from Archivist Serin: she has decoded the sanctuary's Caelian transport records, and several groups are already trying to seize them before she can reach the coalition.

**Interlude — "No One Left as Salvage"** *(Depot Workshop · Recovery Bay)*

- **Lysa Vey:** The chassis cannot be restored. Not the way it was.
- **Conductor:** I know.
- **Brass Bastion-136:** Recovery acknowledged. Formation remembers.
- **Cassian:** Was the second operation worth the risk?
- **Conductor:** Ask the ones who watched us come back for them.

### Mission 41 — Contested Records

- **Briefing:** Following Serin's urgent message, meet her convoy outside the Sanctuary and escort her decoded transport records past the groups trying to seize them.
- **Debriefing:** Serin and the decoded records reach coalition headquarters intact. Protected copies are secured before the groups pursuing her can erase or alter the transport history.

**Interlude — "A Map Made Honest"** *(Coalition Headquarters · Cartography Room)*

- **Archivist Serin:** Every founding faction signed the deletion order. Different seals, same ink formula, same day.
- **Lysa Vey:** Five enemies agreeing to erase one city.
- **Cassian:** Which means the lie was once more valuable than their rivalry.
- **Conductor:** Put Caelis back on the map.
- **Archivist Serin:** The map just answered. A dormant transit frequency is broadcasting coordinates signed by your Stranger.

### Mission 42 — Patron's Reach

- **Briefing:** The Stranger's new coordinates lead to an abandoned relay station, where they offer proof that your activation was arranged through patrons inside the coalition. Protect the meeting and secure the evidence before those patrons' agents arrive.
- **Debriefing:** The Stranger and the evidence escape the relay station. The attackers fail to bury the patron chain, leaving the coalition with proof of an internal conspiracy—and an immediate security crisis.

**Interlude — "The Patron Chain"** *(Abandoned Relay Station · Lower Platform)*

- **The Stranger:** The experiment was purchased through six intermediaries. Your patrons knew only the payment.
- **Cassian:** I know these names. I have eaten at their tables.
- **Conductor:** Did they know I might die?
- **The Stranger:** They made certain they would never need to ask.
- **Cassian:** Then we will ask for them publicly—but not while they can hire every scavenger clan between here and the capital. I need Dax Calder first.

### Mission 43 — Clan Terms

- **Briefing:** Before exposing the patrons behind your Relay experiment, Cassian must keep them from hiring the scavenger clans as an army. Dax Calder can secure clan neutrality, but their leaders will negotiate only after you prove your strength on their terms.
- **Debriefing:** The clans accept neutrality, depriving the implicated patrons of their usual hired muscle. Dax Calder also provides authenticated contract ledgers, giving Lysa enough evidence to confront her former guild directly.

### Mission 44 — Guild Reckoning

- **Briefing:** With Dax Calder's ledgers authenticating the contractor pay chits, Lysa can finally confront her former guild. Escort her into the guildhall and keep her safe when its officers refuse to answer.
- **Debriefing:** The guild is forced to produce authorizations that push responsibility higher. Among the disclosed papers are shipping manifests proving that all five factions are quietly moving Source cores into weapons programs.

**Interlude — "Open Ledger"** *(Guildhall Steps · Public Record Bell)*

- **Lysa Vey:** My resignation is entered. My credentials are suspended. My former guild would like me arrested.
- **Cassian:** The coalition needs an independent assessor.
- **Lysa Vey:** You mean an assessor no respectable office will hire.
- **Conductor:** We were never especially respectable.
- **Lysa Vey:** That is the first convincing offer I've heard all day.

## Chapter 9 — Cores

### Mission 45 — Core in Transit

- **Briefing:** The guild manifests reveal five secret Source-core weapons programs and identify one core being moved with inadequate security. Intercept that shipment before any faction can deploy it.
- **Debriefing:** The shipment is intercepted and the Source core secured before it can enter a weapons program. Within hours, all five factions issue competing demands for its custody.

**Interlude — "Possession"** *(Coalition Depot · Source-Core Vault)*

- **Conductor:** We took the core so no faction could turn it into a weapon.
- **Cassian:** And now every faction sees a weapon guarded by our troops.
- **Lysa Vey:** Intent does not show up on an inventory.
- **Conductor:** Then the vault needs five locks and five different keys.
- **Cassian:** That may be the first political solution you have ever proposed. I will present it at Unity Day, where every faction must answer in front of the public.

### Mission 46 — Unity Day

- **Briefing:** To answer fears that the coalition seized the Source core for itself, Cassian plans to announce a shared-custody proposal during Unity Day. Armed extremists intend to turn the crowded capital celebration into a massacre before he can speak.
- **Debriefing:** The coalition prevents a massacre, but captured orders reveal the attack was the opening move of a hardliner coup. While the public is still fleeing the square, armored columns begin advancing on the council chambers.

### Mission 47 — The Coup

- **Briefing:** The Unity Day attack was a diversion for a hardliner coup now moving on the council chambers. Break the armored advance before it reaches the government district.
- **Debriefing:** The coup fails. Battlefield scans taken while clearing its underground approach reveal a powered Caelian transit line beneath the capital, still drawing energy and receiving recent maintenance.

### Mission 48 — Rearguard

- **Briefing:** The scans recovered after the failed coup locate an entrance to the powered Caelian line. Clear the remaining surface forces so Serin's team can enter the station and trace its route.
- **Debriefing:** The line points toward a place absent from every modern map, and its maintenance records are recent. The station's activation is detected by three faction armies, which converge on the populated town above its next junction.

### Mission 49 — Three Fronts

- **Briefing:** Three factions detected the transit line's activation and are converging on the town above its next junction. Hold an evacuation corridor, get the civilians clear, and withdraw before the armies collide.
- **Debriefing:** The evacuation is complete before the three armies collide. The town is lost, but its people are clear as the wider battle marks the beginning of open war.

**Interlude — "The Ground We Surrendered"** *(Evacuated Township · Western Ridge)*

- **Asha Vale:** By sunset, each army will claim we abandoned the town to the other two.
- **Conductor:** They can keep the streets.
- **Cassian:** I will make certain the record distinguishes ground surrendered from lives saved.
- **Asha Vale:** Records will not stop the next army.
- **Conductor:** No. People might.

### Mission 50 — Truce Line

- **Briefing:** Cassian has persuaded several enemies to attempt a local truce. Defend the signing site beside troops you recently fought, and give their leaders time to finish the agreement.
- **Debriefing:** The truce holds because former enemies enforce it together. During the first joint patrol afterward, several of your oldest machines refuse an order to pursue retreating troops and instead move to protect the wounded.

**Interlude — "Terms of Respect"** *(Truce Line · Shared Command Tent)*

- **Dax Calder:** My people held the eastern sector. Yours made a dramatic amount of noise in the west.
- **Conductor:** Is that a compliment?
- **Dax Calder:** It is an invoice with the total removed.
- **Cassian:** The truce needs a joint patrol commander.
- **Dax Calder:** Then I accept, provided the mechanic promises not to repair my personality.

### Mission 51 — Coalition Trial

- **Briefing:** After the machines refuse pursuit during the joint patrol, take them to a controlled field deployment. Learn which commands they reject and whether the truce can rely on a squad that chooses its own purpose.
- **Debriefing:** The controlled deployment ends without casualties, but its results alarm all three truce signatories. Their emergency negotiation collapses into a staged show of force.

**Interlude — "A Refusal in Formation"** *(Forward Depot · Resonance Bay)*

- **Conductor:** They ignored the attack order. Then they moved to shield the medics.
- **Brass Bastion-136:** Purpose conflict. Destruction unnecessary. Protection retained.
- **Cassian:** An army that can refuse its commander will terrify every government.
- **Conductor:** Good. It terrifies me less than one that cannot.

### Mission 52 — Managed Retreat

- **Briefing:** The three truce partners have answered the machines' refusal with a negotiation that is becoming a staged battle. Cassian needs you to yield the disputed ground without humiliating any delegation, so control the fight and withdraw on his signal.
- **Debriefing:** Your withdrawal preserves the talks, but the staged battle's Source draw propagates far beyond the field. Lights fail across the district as dormant machines wake in sequence.

**Interlude — "The Signal to Withdraw"** *(Negotiation House · Private Stair)*

- **Conductor:** You committed the squad before telling me the plan.
- **Cassian:** If either delegation knew the withdrawal was arranged, they would have rejected it.
- **Conductor:** I am not either delegation.
- **Cassian:** No. You are the person I trusted to survive my decision.
- **Conductor:** Trust me before the decision next time.

## Chapter 10 — Coalition Fracture

### Mission 53 — Network Answer

- **Briefing:** The power surge from the staged negotiation has spread into Source fragments across the district, causing blackouts and waking dormant machines. Follow the grid crews outward and protect them while they contain the cascade.
- **Debriefing:** Repair crews contain the first cascade, but the blackout opens a locked ward inside a faction recruitment center. Security forces mobilize to restore its doors before the failing life-support system forces an evacuation.

**Interlude — "The Network Listens"** *(Failed Grid District · Relay Substation)*

- **Archivist Serin:** The fragments synchronized in response to battlefield loads. No operator issued the command.
- **Conductor:** It felt like the Relay when the machines search for one another.
- **Lysa Vey:** You are suggesting the power grid is frightened.
- **Conductor:** I am suggesting we stop assuming only people can notice a war.

### Mission 54 — Intake Blockade

- **Briefing:** The locked ward holds people who passed medical screening for possible Relay use, then refused faction sponsorship contracts. They have no Relays and are not Conductors, but the recruitment bureau will not release them. Reach the ward before security restores the doors or life support fails.
- **Debriefing:** The detainees reach the coalition clinic alive. Hardliners brand their extraction the theft of state recruitment assets and use it to launch an offensive across three fronts.

**Interlude — "Asset, Prisoner, Person"** *(Coalition Clinic · Intake Hall)*

- **Nara:** I went in for a medical screening. I've never touched a Relay, but they decided my future belonged to them.
- **Conductor:** A screening is not consent.
- **Nara:** My file stopped using my name after I refused their contract.
- **Cassian:** I have that file. By morning, it will be evidence.

### Mission 55 — Counteroffensive

- **Briefing:** The recruitment-center extraction has become the hardliners' excuse for a full offensive across three fronts. The coalition has no other force able to intercept each breakthrough, so keep moving for as long as the Relay can bear the strain.
- **Debriefing:** The fronts hold at severe cost. Unable to break the coalition in battle, the offensive's sponsors switch targets and begin hunting its delegates one by one.

**Interlude — "The Body Keeps the Account"** *(Field Hospital · Conductive Ward)*

- **Cassian:** The doctors have refused clearance for another deployment.
- **Conductor:** The western front would have broken.
- **Brass Bastion-136:** Conductor survival priority elevated. Formation will interpose.
- **Conductor:** I never gave that order.
- **Brass Bastion-136:** Shared purpose does not require order.

### Mission 56 — The Assassins

- **Briefing:** After the three-front offensive stalls, its sponsors send assassins after coalition delegates instead. Use Cassian's warnings to move the surviving representatives to a secure chamber and eliminate the teams tracking them.
- **Debriefing:** The delegates reach the secure chamber and the assassins are eliminated. Rather than scatter again, the survivors invoke emergency procedure and call a public tribunal to decide who can legitimately govern the Source.

**Interlude — "Cassian's Other Ledger"** *(Coalition Headquarters · Records Cellar)*

- **Cassian:** These are informants, couriers, sympathetic clerks, and people owed favors by people owed favors.
- **Conductor:** How long have you had this network?
- **Cassian:** Long enough that telling you earlier would have made you responsible for it.
- **Lysa Vey:** That is not how responsibility works.
- **Cassian:** No. It is how plausible deniability works.

### Mission 57 — Tribunal Under Fire

- **Briefing:** The delegates rescued from the assassins have convened an emergency public tribunal rather than remain hidden. Armed groups from several sides are trying to silence it, so keep the chamber standing until every claimant to the Source is heard.
- **Debriefing:** The tribunal proves no claimant can impose an answer safely. Serin offers the buried Caelian conduits as neutral infrastructure for a shared settlement, but fighting has already reached the western district above their only mapped entrance.

### Mission 58 — Royalist Gate

- **Briefing:** Following Serin's proposal at the tribunal, the coalition travels to the western entrance of the Caelian conduits. A royalist guard controls the gates under an ancient charter and demands a formal trial before granting passage.
- **Debriefing:** The gatekeepers accept the result and open the western conduit entrance. As the coalition enters, ranging fire from long-range batteries begins walking toward the buried route.

**Interlude — "A Charter Still in Force"** *(Western Conduit Gate · Royalist Court)*

- **Archivist Serin:** The gate charter bears the seal of Caelis. Legally, it never expired.
- **Cassian:** Then neither did the authority that issued it.
- **Conductor:** You sound pleased.
- **Cassian:** I am pleased the door opened. I am concerned its original owners may still be alive.

### Mission 59 — Battery Night

- **Briefing:** The royalist gatekeepers admit the coalition, revealing that long-range batteries are already ranging the buried conduit route. Break through their surface defenses and disable the guns before the next barrage collapses the passage.
- **Debriefing:** The conduits survive the night, but the batteries can be replaced. Cassian asks Asha Vale to assemble former Circuit rivals into a joint force that can hold the exposed route while Serin finishes mapping it.

### Mission 60 — Joint Formation

- **Briefing:** Answering Cassian's request after the battery strike, Asha Vale assembles former Grand Circuit rivals into the coalition's first joint team. Fight beside them to hold the conduit route while Serin completes her survey.
- **Debriefing:** Asha Vale's team secures the route long enough for Serin to complete the maps. They reveal a single maintained passage beyond the known network and a live signal waiting at its far terminus.

**Interlude — "Former Opponents"** *(Conduit Route · Joint Strike Camp)*

- **Asha Vale:** I assembled the people you defeated in the Circuit. They already know you can win.
- **Conductor:** Do they know how to take an order from me?
- **Asha Vale:** No. They know how to understand the objective. It is usually better.
- **Cassian:** The coalition appears to have acquired an army.
- **Asha Vale:** Call it a team until you learn to deserve the other word.

### Mission 61 — The Maintained Route

- **Briefing:** With Asha Vale's team holding the junction, follow Serin's completed map down the only maintained route beyond the known network. Secure the passage and reach the source of the live signal at its far terminus.
- **Debriefing:** The maintained passage is secured and its unknown signal source is waiting at the far terminus. Intercepted military traffic shows five faction armies converging on the same route.

**Interlude — "The Invitation"** *(Caelian Transit Terminus · The Far Door)*

- **The Stranger:** My name is Ilyra. I am a Warden of Caelis.
- **Warden Ilyra:** I was sent to observe the continuity test and bring home any Conductor who survived.
- **Conductor:** Home? I have never seen Caelis.
- **Warden Ilyra:** The Relay has. To the Wardens, that distinction is sufficient.
- **Cassian:** Then the Wardens are about to learn the value of distinctions.

### Mission 62 — Caelis Approach

- **Briefing:** Follow Ilyra from the transit terminus to Caelis before the armies that intercepted her signal can claim it. Hold the gate approach long enough for Cassian to assemble a neutral delegation and keep the war outside the city.
- **Debriefing:** Cassian reaches Caelis at the head of a coalition delegation rather than another invading army. The Wardens open the outer approach far enough to admit the delegation into an inspection court, but the city's inner threshold remains sealed.

**Interlude — "At the Threshold"** *(Caelis · Outer Inspection Court)*

- **Warden Ilyra:** No foreign delegation has crossed this threshold in two hundred years.
- **Cassian:** Then it is fortunate we came as a coalition rather than a foreign power.
- **Lysa Vey:** That sentence should not have worked.
- **Cassian:** It worked because everyone here wants a reason not to start shooting.
- **Conductor:** The machines know this place.

# Act 3

## Chapter 11 — The Outer City

### Mission 63 — Outer Inspection

- **Briefing:** The outer gate is open, but Ilyra's fellow Wardens halt the delegation at the threshold. They will admit outsiders only after their emergency protocol verifies that you can conduct the reclaimed machines without seizing Caelian systems.
- **Debriefing:** The Wardens classify you as an unregistered Conductor with an unauthorized Relay. They grant entry despite the violation, deciding that the first new Conductor in centuries deserves further study.

### Mission 64 — City Still Running

- **Briefing:** After passing the Warden inspection, the delegation enters Caelis's clean, powered, almost empty Outer City. Its caretaker machines still enforce rules for citizens who never returned and identify your group as trespassers.
- **Debriefing:** The caretakers have maintained an empty city for generations. Their response convinces the Wardens that your bond with the reclaimed machines must be tested as stewardship, not merely measured for control.

### Mission 65 — Stewardship Trial

- **Briefing:** Because the Outer City caretakers responded to your machines, the Wardens demand a second test before opening the inner gates. Defend a maintenance district without taking control of the Caelian machines already assigned to it.
- **Debriefing:** By protecting the district without claiming its machines, you demonstrate that conducting can be an act of stewardship. The Wardens record the result and unlock the inner gates.

**Interlude — "Stewardship"** *(Caelis · Maintenance District)*

- **Warden Ilyra:** You could have seized the district machines through the Relay.
- **Conductor:** They already had work and a purpose. They did not need mine.
- **Warden Ilyra:** The old Conductors would call that restraint.
- **Brass Bastion-136:** Correction. Recognition.

## Chapter 12 — The Imperial Archive

### Mission 66 — The Buried Record

- **Briefing:** The maintenance test unlocks Caelis's inner gates, and Serin chooses the Imperial Archive as the delegation's first destination. Disable defenses that deny access to Wardens and outsiders alike without damaging its unedited account of the Empire's final years.
- **Debriefing:** The archive records a Source crisis and the Empire's decision that no single power could safely control the whole network. Its index points to five sealed founding galleries just as alarms report rival claimants forcing their way inside.

### Mission 67 — Fivefold Claim

- **Briefing:** The central archive index leads to five founding galleries, one for each modern faction. Rival claimants have breached them to destroy evidence that weakens their own histories; reach the rooms before the collection is lost.
- **Debriefing:** The five founding galleries are secured before the claimants can destroy their records. Aligning the recovered sections reveals a cipher pointing to the archive's deepest sealed vault.

**Interlude — "Five True Stories"** *(Imperial Archive · Founding Galleries)*

- **Archivist Serin:** Each faction preserved one honest fragment: discipline, industry, faith, freedom, ambition.
- **Lysa Vey:** And each built a complete history around its favorite piece.
- **Cassian:** A lie can be made entirely from truths arranged for the wrong purpose.
- **Conductor:** Then we show them the pieces fit together.

### Mission 68 — Deep Archive

- **Briefing:** The combined founding records reveal both the location and cipher of the archive's deepest vault. Its guardians were designed to resist Conductors, so reach the evidence that caused the Empire to fragment the Source without releasing it beyond the vault.
- **Debriefing:** The deep record is recovered and resealed without escaping the vault. Its guardian network is left dormant and the archive remains intact.

**Interlude — "What Remains Sealed"** *(Imperial Archive · Deep Vault)*

- **Cassian:** You have not told us what was in the final record.
- **Conductor:** Not yet.
- **Cassian:** I have spent years arguing that hidden history is a weapon.
- **Conductor:** Then trust me when I say this one is still loaded.
- **Cassian:** I do. I dislike how much that costs both of us.
- **Archivist Serin:** The record names living witnesses in the Conductor Vault. We should hear them before deciding what the world can bear.

## Chapter 13 — The Conductor Vault

### Mission 69 — Living Witnesses

- **Briefing:** The sealed record identifies living witnesses in a nearby Conductor Vault who can explain the human cost behind the Empire's decision. Travel to the hospice and pass its guardians' assessment to speak with them.
- **Debriefing:** The hospice guardians stand down and admit the delegation. Beyond them, the surviving First Conductors receive you in the Relay ward.

**Interlude — "Company in the Relay"** *(Caelis · Conductor Vault)*

- **First Conductor:** They taught your age that we commanded machines because command is easier to regulate than companionship.
- **Conductor:** The Relay is hurting me.
- **First Conductor:** Yes. Sharing purpose means sharing weight. The old Empire praised the gift and hid the bill.
- **Brass Bastion-136:** Weight shared. Conductor not alone.
- **First Conductor:** Nor were you chosen by chance. Ask the Warden council why it needed a new Conductor badly enough to gamble with your life.

### Mission 70 — The Relay Experiment

- **Briefing:** The First Conductors direct the delegation to the Warden council for answers about your activation. The Continuity Directorate—the Warden faction that authorized the experiment—seals the witness chamber and activates its custodial forces to prevent the council from testifying. Break the lockdown without destroying the surviving records.
- **Debriefing:** The Continuity Directorate's lockdown is broken and the council records survive. Unable to conceal its role any longer, the Warden council admits that your activation was a deliberate continuity test.

**Interlude — "Continuity Test"** *(Warden Council · Witness Chamber)*

- **Warden Ilyra:** We authorized the continuity test. The intermediaries were not told its nature.
- **Conductor:** I was not told anything.
- **Warden Ilyra:** Caelis needed to know whether Conduction could take hold again.
- **Cassian:** You converted a person into a question because you were afraid of the answer.
- **Warden Ilyra:** Yes. There is no honorable wording for it. The council will now summon you to the Crown Relay, because survival was the answer it wanted.

### Mission 71 — Crown Continuity

- **Briefing:** The Warden council summons you to the Crown Relay and insists the new Conductor remain in Caelis as successor to the Vault. When you refuse, its honor guard seals the exits.
- **Debriefing:** You break the containment and keep the coalition delegation intact. Despite the confrontation, the Crown Relay and its guardians remain unharmed.

**Interlude — "Succession"** *(Conductor Vault · Crown Relay)*

- **Warden Ilyra:** The honor guard has withdrawn. The offer remains: accept the Vault, and Caelis will recognize you as successor.
- **Conductor:** My answer remains no.
- **Cassian:** One good ruler is still a system waiting for one bad heir.
- **Conductor:** Open the doors. Let the world help carry what it uses.
- **Warden Ilyra:** Then Caelis will petition the coalition in the morning. If we cannot name a successor, we will argue for stewardship in the open.

## Chapter 14 — The Civic Core

### Mission 72 — Civic Petition

- **Briefing:** After its succession offer fails, Caelis requests a public hearing on the future stewardship of the Source. The delegations gather at the Civic Core, where armed hardliners are trying to seize the council chambers first.
- **Debriefing:** The Civic Core is secured. Under coalition guard, the surviving delegations resume the negotiations the hardliners tried to end.

**Interlude — "The Petition"** *(Caelis Council Hall · Coalition Table)*

- **Warden Ilyra:** Caelis petitions to resume stewardship of the Source.
- **Dax Calder:** A polite word for ownership.
- **Asha Vale:** Then counter it with terms, not weapons.
- **Cassian:** For the first time, everyone who claims the Source is in one room. Keeping them here is the victory.
- **Conductor:** Then I will keep the doors standing.

### Mission 73 — Extremes Aligned

- **Briefing:** Caelian restorationists and faction hardliners have joined forces to destroy the talks before a compromise can emerge. Protect the negotiators, even though the final agreement is not yours to write.
- **Debriefing:** The alliance between both extremes exposes how much they each fear compromise. The talks survive, and you begin to understand the shifts in the room that Cassian has always noticed first.

### Mission 74 — Accord Draft

- **Briefing:** Cassian is drafting the Accord while every proposed signatory presses for a final concession. Some have sent troops to strengthen their demands, so keep them away from the negotiating hall.
- **Debriefing:** The pressure forces are repelled. With outside coercion broken, Cassian seals the completed Accord draft for signatory review.

**Interlude — "The Architect"** *(Accord Chamber · Third Night)*

- **Cassian:** The draft gives no faction a permanent majority. Source access requires shared inspection.
- **Conductor:** My name is not in it.
- **Cassian:** No.
- **Conductor:** Good. If the peace needs me forever, we did not repair anything.
- **Cassian:** You finally sound like an institution builder. Tomorrow the signatories send one joint repair team into the Source; the Accord lives only if that team works.

## Chapter 15 — The Source

### Mission 75 — Source Balance

- **Briefing:** The final Accord draft requires every signatory to prove shared stewardship in practice, so a joint repair team enters the Source complex to reconnect its fragments. Its defenses mistake the team for another faction trying to seize control.
- **Debriefing:** The joint crews prove that a connected, shared Source can support an entire civilization. The reconnection also reveals the complex to every remaining rejectionist force, which begins converging before the Accord can be signed.

**Interlude — "The Balancing Network"** *(Source Complex · Distribution Heart)*

- **Archivist Serin:** The Source does not create power. It balances unlike systems so none can consume the rest.
- **Conductor:** It was never one machine.
- **Warden Ilyra:** Nor was the Empire, until it forgot.
- **Cassian:** Then the engineering diagram and the Accord require the same design.

### Mission 76 — Rejection Line

- **Briefing:** The Accord is nearly complete, but fighting has reached the Source complex. Hold the field with champions from every faction and keep all sides alive long enough for their leaders to sign.
- **Debriefing:** The allied line holds, with faction champions fighting together at the Source approach. The surviving rejectionists fall back toward the assembly as their leaders finish the Accord.

**Interlude — "The War Gets a Name"** *(Source Approach · Allied Field Line)*

- **Asha Vale:** Coal holds the center. Wind scouts the conduits. Solar medics are treating Fusion troops.
- **Dax Calder:** A week ago each of those sentences would start a riot.
- **Warden Ilyra:** Caelis will record this as the Resonance War, in memory of all five factions' dead.
- **Conductor:** Record who stood together, too.

### Mission 77 — The Caelis Accord

- **Briefing:** The Accord is ready for signatures, and the last rejectionists are advancing on the assembly. Defend the delegates and give them the time they need to end the war.
- **Debriefing:** The Accord is signed. The factions accept a shared account of the past, return the most dangerous evidence to the vault, and place the Source under coalition authority.

**Interlude — "What Outlives Us"** *(Caelis · Accord Hall at Dawn)*

- **Cassian:** Remarkably quiet, for the end of a war.
- **Lysa Vey:** You have been smiling at the filing clauses for ten minutes.
- **Warden Ilyra:** The Source is reconnecting. It recognizes no single master.
- **Brass Bastion-136:** Formation expanded. Purpose shared.
- **Conductor:** Good. Now we fix what the war left broken.
- **Cassian:** And this time, we leave instructions someone else can use.

---

## Campaign Epilogue

*Shown on completing the final mission.*

Cassian's Accord holds. The factions publish the history they can safely share and return the most dangerous evidence to its vault. They place the Source under a coalition authority that belongs to no single faction.

The war ends. The grids stabilize, and the cities remain lit.

History remembers Cassian as the architect of the peace. It records you as a reclamation technician who was present at several decisive events.

You return to repair work, accompanied by machines that have grown older and more individual than any official history will acknowledge.

Years later, historians give the conflict a name:

THE RESONANCE WAR
