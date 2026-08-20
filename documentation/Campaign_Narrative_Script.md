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
| Evaluator Marren | Conductor Registry evaluation officer |
| General Strosse | Hardliner field commander |

---

## Campaign Prologue

*Shown the first time the operations map opens (replayable via WORLD BRIEF).*

Three hundred years ago, the Caelian Empire ran its whole civilization on the Source. One network powering the cities, transports, and the automatons that kept them alive. Imperial Conductors guided those machines through relay stations, lending them purpose with a thought.

Then the Empire fell. The Source went dark, the capital Caelis was lost, and the Conductors lost with it. That is the story every school in every nation teaches.

Five successor nations rose from the provinces. Coal, Steam, Solar, Wind, and Fusion. Each kept a fragment of the old network running, and each is certain it alone can be trusted with what remains. Their armies field machines of their own, driven by licensed operators with control rigs. Crude tools beside what the Empire's Conductors did with their minds.

You are a reclamation technician with a joint salvage expedition, paid to pull working machinery out of a abandoned site. The patrons funding the dig expect scrap value.

The site has other plans.

---

# Act 1

## Chapter 1 — The Salvage

*Chapter briefing (shown once when the chapter unlocks):*

Your expedition works a dormant Caelian relay site under a patrons' salvage contract: recover what still functions, catalogue what doesn't, and make the dig look worth its funding.

The machines coming out of the lower galleries have been nonfunctional for three centuries.

### Mission 1 — First Synchrony

- **Briefing:** Two of the automatons we pulled from the lower galleries are walking again, and the patrons want proof the dig is worth their money before they fund the next phase. Run them along the relay site perimeter and put them through a live drill. If they do anything the manuals don't cover, I hear it from you first.
- **Debriefing:** The drill goes clean. Too clean. One of the machines moved half a second before your signal reached it. Cassian logs a success for the patrons, then seals the site to outside crews until the expedition knows what it has actually found. Off the record, he has started asking why the dig's funding arrived so quickly.

**Interlude — "A Useful Kind of Impossible"** *(Relay Site · Equipment Gallery)*

- **Cassian:** Two intact machines, one working relay, zero injuries. That's either excellent work or an accounting error.
- **Conductor:** The left one moved before I gave the signal.
- **Cassian:** Then do me a favor and leave that detail off the inventory sheet.
- **Brass Bastion-136:** Formation retained. Awaiting shared purpose.
- **Conductor:** It's been saying that since it woke up. I don't think it's quoting a manual.
- **Cassian:** No. I think it's asking a question.

### Mission 2 — Formation Trial

- **Briefing:** Two more machines woke overnight. That makes four. Tomorrow the patrons fire the relay itself: full activation, sealed test, their observers on the roster. Today belongs to us. Form the squad up and lean on the control link until it complains. If anything down here wants to surprise us, it can do it now.
- **Debriefing:** The link holds through everything we throw at it, and it shouldn't. Nobody has guided this many machines since the Empire, and nobody living is certified to try. None of that goes in the report. In his private ledger, Cassian writes one word beside your name and doesn't say it out loud: Conductor.

### Mission 3 — The Second Pulse

- **Briefing:** The relay fired early, hours ahead of schedule, nobody at the controls. The surge collapsed the lower gallery and tripped the site's Caelian security machines, and they are cutting our crew off from the exits. Hold the security line and get our people out.
- **Objective — Evacuate the Gallery:** Hold the security machines back through round 4 while the expedition crew escapes.
- **Debriefing:** Most of the crew reaches the upper gallery. Cassian's locator is still pulsing below the fire line. Three tons of stone came down on you and you walked out, and when you turned back for him, every machine turned with you, unasked. The relay is still humming, and no test schedule explains what it did to you.

**Interlude — "The Second Pulse"** *(Relay Site · Collapsed Gallery)*

- **Conductor:** The relay's still active. I can feel every machine in the dark, feeling for a way out.
- **Cassian:** You were under three tons of stone an hour ago. You shouldn't be feeling anything.
- **Conductor:** Cassian, they're afraid.
- **Cassian:** Then we get all of you out before someone decides fear counts as proof of ownership.

### Mission 4 — Sealed Ignition

- **Briefing:** The lower galleries are burning, and Cassian is trapped behind the security cordon. The site's warden core is still enforcing it, three hundred years dead or not. Break the line and bring him out. Nobody stays in a tomb we opened.
- **Objective — Break the Security Line:** Eliminate the marked security warden blocking Cassian's extraction route.
- **Debriefing:** You bring Cassian out breathing. He doesn't say thank you; he starts writing. When the patrons' director arrives to seal the site and call the matter settled, Cassian is waiting at the gate with the salvage contract in hand and a clause that forces an independent assessment before anyone removes so much as a bolt.

**Interlude — "The Official Version"** *(Expedition Infirmary · Before Dawn)*

- **Director Rusk:** A tragic accident. The consortium grieves, of course. We'll be sealing the site pending a full inquiry: our inquiry.
- **Cassian:** The activation was scheduled, sealed, and your observers signed the roster, Director. Accidents don't keep appointment books.
- **Director Rusk:** Grief makes people imaginative, adjutant. Don't let it make you expensive.
- **Cassian:** Clause nineteen of the salvage contract. Independent assessment before anything leaves that site. You signed it yourself.
- **Director Rusk:** …I'll have my office send flowers.
- **Conductor:** He's afraid of what the assessment finds.
- **Cassian:** He's afraid of who finds it first. So am I.

## Chapter 2 — The Aftermath

*Chapter briefing (shown once when the chapter unlocks):*

Salvage law is older than the nations that enforce it: whoever pulls working machinery out of a dead site owns it, if the claim survives challenge. Every scavenger consortium and half the guilds keep lawyers who specialize in making claims not survive.

Your expedition's patrons are a private consortium with government ties, and they didn't fund a dig out of curiosity. They want the Relay machines declared safe, valuable, and theirs.

Five nations watch the dig without admitting it. None of them can seize a licensed salvage operation outright, but every one of them can pay someone who can.

### Mission 5 — Independent Witness

- **Briefing:** Cassian's contract clause worked: salvage assessor Lysa Vey is walking the sealed site, independent and unimpressed. Word of waking machines has spread, and a looters' crew is breaching the perimeter mid-inspection. Keep her team alive and the recovered machines out of their hands. Her report is all that's between this dig and the patrons' seals.
- **Objective — Protect the Survey:** Keep Lysa's marked survey rig operational and defeat the looters' Conductor.
- **Debriefing:** Lysa's crew survives, and so does every machine she came to count. Her assessment stays open, and the patrons can't seal a site an independent assessor is still walking. Their answer arrives by courier: Director Rusk's office announces a public demonstration to prove the reclaimed machines are perfectly safe.

**Interlude — "What the Assessor Saw"** *(Salvage Depot · Records Office)*

- **Lysa Vey:** Your machine crossed three lanes to cover my surveyor. Nobody ordered it. I checked the logs twice.
- **Conductor:** It decided on its own.
- **Lysa Vey:** Don't rehearse that answer. It works better unrehearsed.
- **Cassian:** And what exactly will your report say?
- **Lysa Vey:** What I saw. You two can decide whether that makes me your witness or your problem.

### Mission 6 — Public Demonstration

- **Briefing:** Director Rusk has sold the capital a morning of perfectly safe reclaimed machinery, and you're the demonstration. The grandstands are full, and someone in them doesn't want the show to go well. Lysa's people caught a saboteur crew at the staging. When it goes wrong, protect the crowd first and the patrons' story second.
- **Objective — Secure the Exhibition:** Hold the demonstration floor through round 5 while spectators reach the exits.
- **Debriefing:** The sabotage turns Rusk's publicity into yours: the footage everyone shares is you holding the field while the crowd runs. Invitations flood Cassian's desk. One bears no seal, only a request to meet on the depot roof, from someone who claims to know why the Relay woke. Cassian advises against going. He notes you'll go.

### Mission 7 — Dead-Channel Warning

- **Briefing:** The stranger on the roof says the relay fired on purpose, and that whoever lit it is coming to collect their property. She's right on schedule: a retrieval crew is cutting the depot's perimeter already, equipped to take you alive and briefed on our security routines. Don't let them.
- **Objective — Cut Off the Extraction:** Eliminate the marked leader before the retrieval crew can withdraw with its prize.
- **Debriefing:** The retrieval crew withdraws empty-handed, but it knew the patrol rotations, the gate codes, and which machine to take first. Cassian locks the incident report in his private ledger. By morning the sponsors try law instead of force: a scavenger consortium files a competing claim on the expedition's salvage.

**Interlude — "A Warning Without a Name"** *(Depot Roof · Rain Shift)*

- **The Stranger:** Your survival in that gallery was not luck. The Relay was given a question, and it answered with you.
- **Conductor:** Who asked it?
- **The Stranger:** People who have waited a long time to learn whether Conductors can return. I was sent to watch for the answer.
- **Cassian:** People with no names, apparently.
- **The Stranger:** Names are why they will come for you. I left coordinates in the Relay's dead channel; use them when you have somewhere safe to run.

### Mission 8 — Salvage Claim

- **Briefing:** The scavenger consortium's claim comes with an enforcement crew already in the stockyard, paperwork in one hand, pry bars in the other. Hold the yard while I pull their filing apart against the original contract. If their claim is forged, I want it to have been forged expensively.
- **Objective — Hold the Stockyard:** Keep control of the stockyard through round 4 while Cassian verifies the salvage claim.
- **Debriefing:** Cassian proves the claim forged, skillfully forged, which is its own kind of evidence. The yard is compromised now, and the next attempt is a matter of patience, not doubt. He orders the Relay machines moved to a defensible depot beyond scavenger territory. The scavenger clans watch the convoy form up and start counting.

### Mission 9 — Passage Rights

- **Briefing:** The clans are shadowing the convoy, and their raider chief will make his try in the pass ahead. Stay on the flanks, keep the transports rolling, and don't let them drag a single machine off the road. Everything we pulled out of that site is on those trucks.
- **Objective — Guard the Convoy:** Keep the marked transport operational and defeat the pursuing Conductor.
- **Debriefing:** The convoy reaches the new depot intact, and Cassian buys passage rights from the clans with the footage of their chief losing. The base is defensible now, and conspicuous. Running it openly takes the one credential nobody sells: a Conductor registration, stamped by a licensing hall, in a world with no living Conductors.

**Interlude — "Passage Rights"** *(Convoy Camp · Scavenger Border)*

- **Conductor:** They hit us yesterday. Today you paid them for safe passage.
- **Cassian:** Their cousins. People who invoice by the family branch take the distinction very seriously.
- **Conductor:** What did it cost?
- **Cassian:** Two repair crews, one favor, and letting them claim they escorted us the whole way. Pride is cheap when someone else pays for it in blood.

## Chapter 3 — Claims

*Chapter briefing (shown once when the chapter unlocks):*

Every modern army fields machines driven by licensed relay operators: technicians with manufactured control rigs, regulated, registered, and deliberately limited. It is the only legal way to command a machine, and the licensing halls keep it that way.

True Conduction, the Imperial kind, will lent directly, machines choosing to share it, died with the Empire. The registry has no form for it, because the registry was built to never need one.

When governments quarrel over a machine, a claim, or a person, the Joint Investigative Office decides whose evidence counts. Its seizure orders do not ask permission.

### Mission 10 — Licensed Resistance

- **Briefing:** No license means the depot counts as unregistered Relay equipment, and unregistered Relay equipment gets seized. The registry will certify you as an operator, the only box its forms have. The licensing examiner has arranged live opposition for the field evaluation. Pass it, and notice who's scoring you.
- **Debriefing:** You leave certified as an operator, because the registry has no form for what you are. Before the ink dries, the Joint Investigative Office cites your own evaluation in an evidence order: the depot and its machines are to be seized as material in an open inquiry. Their evidence detail is already mustering.

**Interlude — "Registered"** *(Conductor Licensing Hall · South Annex)*

- **Cassian:** Congratulations. Five governments now agree that you exist.
- **Conductor:** They certified me as an operator. The Relay's listed as restricted equipment.
- **Cassian:** Operator is the only box the form has. Be grateful. One of the amendments wanted you listed as part of the equipment.
- **Conductor:** How many amendments were there?
- **Cassian:** Three. I framed the worst one.

### Mission 11 — Depot Under Seal

- **Briefing:** The Joint Investigative Office's evidence detail is at the gates with a seizure order and an armed escort. Cassian is shredding their jurisdiction line by line, but paper moves slower than troops. Hold the depot. And understand: everything you do here will be read back to us as a confession.
- **Debriefing:** The depot holds, and the official transcript turns the defense into proof: an armed compound resisting lawful inspection. No deliveries reach us under the seizure order. Cassian starts a private record of every falsification and routes essential supplies along an unmarked back road, a route known to a very short list of people.

### Mission 12 — The Unmarked Route

- **Briefing:** The unmarked route leaked. The supply convoy is pinned in the flats by a contract crew: professionals, military drill, no markings. Break their line, recover the cargo, and pull anything that names who paid for this. Someone on a very short list sold us.
- **Debriefing:** The contractors carried clean gear, every serial burned. Cassian locks it in the vault and shortens his list. The same week, three factions offer protection in exchange for say over your deployments; you refuse all three. Lysa takes the burned equipment to an informant who owes her, and he recognizes the batch.

### Mission 13 — Terms Refused

- **Briefing:** Three refusals, one answer: a joint safety commission from the three factions you declined, inspectors in front and troops behind. Their Inspector-General is running a search with a flag over it. Keep them outside the fence while Cassian challenges the mandate. And watch the old machines today; they've been restless.
- **Debriefing:** The commission retires with a courteous Cassian letter per envoy and nothing to show. Inside the wire, the oldest machines have started keeping routines nobody taught them. Lysa calls after dark: her informant will name the contractors, but his handlers are moving him tonight, and the safehouse district is already crawling.

### Mission 14 — Safehouse Extraction

- **Briefing:** Lysa's informant can put names to the convoy ambush, and the contractors' handlers are closing on his safehouse to move him somewhere quieter. Cover her extraction team, keep the man breathing, and bring him out before the district swallows him.
- **Debriefing:** Lysa brings him out alive and leaves his handlers scattered across three streets. His testimony is true, detailed, and legally worthless. Truth and leverage, she notes, are different currencies. Then a priority distress call pre-empts the paperwork: a Caelian transit bridge is failing under load with a full crossing of civilians on it.

**Interlude — "Truth and Leverage"** *(Lysa's Safehouse · Back Room)*

- **Lysa Vey:** The informant named the contractors. He also took their money, crossed the border on a forged pass, and perjured himself twice.
- **Conductor:** But what he told us was true.
- **Cassian:** Truth is what happened. Evidence is what can survive a room full of interested people.
- **Lysa Vey:** I hate it when you're reasonable.
- **Cassian:** Most people do.
- **Lysa Vey:** Save it. A township bridge just called for every machine in range, and we're the closest crew.

## Chapter 4 — The Proving

*Chapter briefing (shown once when the chapter unlocks):*

A rescue on camera is worth more than a victory in the field. The guilds learned that first: their champions fight public duels for public money, and a house that owns a beloved champion owns a piece of what people believe.

The state has its own machinery for belief. Hearings shape testimony, evaluation panels certify what is officially true, and the Conductor Registry decides whose abilities exist on paper.

The squad that saved a bridge is about to meet both.

### Mission 15 — Failing Span

- **Briefing:** The distress call is real: the span is failing under load, and its old transit-security core has half-woken with it, reading the evacuation as an attack. Hold the crossing, keep its drones off the civilians, and don't come home until the last one is across.
- **Debriefing:** Hundreds cross before the span drops. For the first time, the word Conductor travels ahead of the squad as something other than a threat: the person who came when the call went out. Across the river, a guild champion watches the same footage and issues a public challenge to the salvage Conductor.

### Mission 16 — Public Challenge

- **Briefing:** A guild champion has challenged you in print, and the sponsor house behind him wants the bridge written off as luck and you as a fraud. Their arena, their crowd, their referee. Give them the match. Make the bridge look like what it was.
- **Debriefing:** The champion falls in front of his own crowd, and the house that backed him loses face it spent years buying. Cassian releases the footage with notes, trading the headline for leverage and counting the grudge as a future invoice. Within days, competing public hearings convene over the bridge, the duel, and what the depot is for.

### Mission 17 — The Cost of Victory

- **Briefing:** The hearings have pulled rival crowds into the streets around the inquiry hall, and partisans on both sides are working them toward a riot. Delegates inside, demonstrators outside, one bad spark between. Keep the hall standing and the crowds apart until the testimony is in the record.
- **Debriefing:** The testimony enters the record edited, trimmed before reading to serve positions you don't hold. One officer on the evaluation panel objects in open session: Evaluator Marren puts her name to the dissent and offers an honest account, produced by testing the Relay under controlled conditions. Cassian accepts before anyone can retract it.

### Mission 18 — Field Certification

- **Briefing:** Marren runs a clean evaluation: full registry protocol, proving-grounds conditions, no friends in the room. She means to find the squad's ceiling and yours. Show her everything. And when the strain starts telling on you, say so; she's the first official willing to write down what conducting costs.
- **Debriefing:** Marren's report certifies the ability and documents the price: the strain, the collapse risk, the medical tent she makes you sit in afterward. Before release she asks one professional to another: a township nearby reports conductor-less automatons running old defense routines, and no one else will answer.

**Interlude — "After the Test"** *(Evaluation Grounds · Medical Tent)*

- **Evaluator Marren:** For the record: you passed. Off the record, I want you to hear the medical section out loud.
- **Conductor:** The squad was still moving. I could've finished the last exercise.
- **Evaluator Marren:** You were unconscious for six minutes, and your heart did what we politely call an irregular event. That's what conducting does to you: every time, a little more. My instruments say it accumulates.
- **Conductor:** Were the machines hurt?
- **Brass Bastion-136:** Formation intact. Conductor condition unacceptable.
- **Cassian:** For once, the evaluator, the machine, and I all agree. Don't let the consensus go to your head.

### Mission 19 — Feral Signal

- **Briefing:** The township's ferals are pre-collapse machines running scar loops, defense routines with nobody left to defend. They're dangerous, some are priceless, and those two facts can't both win today. Protect the residents. If a machine has to die for that, it dies.
- **Debriefing:** The township stands; the salvage doesn't. The squad picks people over priceless machines, and one surviving feral chooses, unasked, to follow them home. Cassian adds the township to the supply roster without comment. Weeks later, displaced families from the district start camping against the depot fence, and thieves start working the camp.

### Mission 20 — Charter Ground

- **Briefing:** Displaced families are camped against our fence, and infiltrators are using the crowd as cover to reach the stockpiles. Protect the refugees and the supplies both. These people are here because they trust the name on our gate. Don't make them wrong.
- **Debriefing:** The infiltrators are run off, and the camp holds, then stays, tents becoming streets, a settlement growing beside the depot because people feel safer near it. Watching water lines and winter stores come together, Cassian starts drafting a charter so the squad can work openly where it's needed. The Stranger answers with coordinates.

**Interlude — "A Charter in Pencil"** *(Depot Settlement · Supply Office)*

- **Conductor:** The camp needs water lines, clinic power, and a winter roof. In that order.
- **Cassian:** It also needs to exist on paper before someone decides the land's empty.
- **Conductor:** Can a charter stop rain?
- **Cassian:** No. It makes stealing the roof expensive. You keep them dry; I'll keep them legal.
- **Lysa Vey:** Then write fast. I decoded the Stranger's coordinates: an Order sanctuary past the eastern border.
- **Conductor:** We leave at dawn.

## Chapter 5 — Sanctuary

*Chapter briefing (shown once when the chapter unlocks):*

The Order of the Archive predates the nations it serves. Its archivists cross every border unchallenged, because every government needs someone trusted to keep the records nobody trusts anyone else to keep.

The Order's rule is simple: knowledge is preserved, not owned. Its scholars are polite, patient, and absolutely immovable.

The Stranger's coordinates point to a sanctuary the Order reached first. The gates do not open for force. They open for people the Order decides deserve what's inside.

### Mission 21 — Sanctuary Threshold

- **Briefing:** The Stranger's coordinates lead to a pre-collapse sanctuary, and the Order's archivists got here first. Their gate scholar is polite, armed, and clear: outsiders don't enter. The charter says we don't force sites, so earn the threshold: show them enough strength to respect and enough restraint to trust.
- **Debriefing:** The Order shares the sanctuary once you've shown you could have taken it and didn't. The lead archivist, Serin, accepts the arrangement with a scholar's grace, though her eyes keep returning to the oldest machines, as if she recognizes them. Inside the walls, custodial machines still guard an inner vault none of the Order's keys open.

### Mission 22 — Archive Breach

- **Briefing:** The inner vault's custodians are three centuries into their orders and don't care that the war they guarded against is over. Disable them without wrecking what they protect. The archive is the point, not the rubble. Serin will be right behind you; keep her standing.
- **Debriefing:** The archive opens intact, and its maintenance logs are dated after the Empire's supposed fall. The Empire didn't collapse; it dismantled itself, on purpose, with receipts. One unredacted manifest lists a destination every modern map has forgotten: Caelis. Reconstructing its routes takes the Order's cross-border collections, and an escort across a contested border.

**Interlude — "The Name on the Manifest"** *(Sanctuary · Sealed Archive)*

- **Archivist Serin:** This transport manifest was filed forty-three years after the Empire supposedly collapsed.
- **Lysa Vey:** Cargo?
- **Archivist Serin:** People. Records. Conductor equipment. All of it routed to Caelis.
- **Conductor:** Caelis was destroyed. Every schoolbook says so.
- **Cassian:** No. Caelis was removed from the story, and everyone agreed not to notice.

# Act 2

## Chapter 6 — The Arena

*Chapter briefing (shown once when the chapter unlocks):*

War is expensive and embarrassing, so the five nations built a cheaper way to lose an argument: the Grand Circuit. Disputes that once cost armies now cost a champion, a bracket, and a week of spectating.

The champions are professionals with faction paychecks, and the patrons' boxes above the arena are where the real matches happen. A title buys more than glory; it buys a seat at tables soldiers never see.

The reigning champion has held the title for three years. Her name is Asha Vale.

### Mission 23 — Border Contract

- **Briefing:** Serin's routes need the Order's archives across a border nobody polices and everybody shoots over. A militia interdiction chief runs the crossing and sells passage to people he likes. This escort is the reclamation charter's first contract: scholars, copied records, no patron. Get them all through.
- **Debriefing:** The scholars and their records come through whole; the charter has its first successful contract. Success travels. Within a week all five factions send invitations: each wants the Conductor displayed at its military exhibition, and every offer is a leash with a gift bow. Cassian replies to all five: the Conductor accepts every invitation.

### Mission 24 — Exhibition Match

- **Briefing:** Five exhibitions, one week, and every marshal running a show has orders to make his faction look like your natural home. Perform for all of them; sign with none. Stay sharp. Staged exercises have a way of going live when someone wants to measure you honestly.
- **Debriefing:** The circuit ends with the charter unbought and five bids on Cassian's desk. None can grant what the charter actually needs: a seat at the faction talks. One neutral road leads to that table: the Grand Circuit, where the nations settle disputes by proxy champion. The reigning champion's name is Asha Vale.

**Interlude — "Inside the Auction"** *(Coal Embassy · Exhibition Week)*

- **Conductor:** Every delegation offered support. Every offer ends with their officers running my deployments.
- **Lysa Vey:** An auction's flattering until the lot figures out what the paddles mean.
- **Cassian:** Let them bid. Competing claims are the closest thing we've got to independence.
- **Conductor:** You enjoy this.
- **Cassian:** I enjoy watching powerful people notice they aren't alone in the room.

### Mission 25 — Circuit Opening

- **Briefing:** The Grand Circuit: five governments settling arguments in an arena because it costs less than war. Cassian's entered you, and the opening heat's champion is a working professional with a faction paycheck. Win the bout and start climbing. The name at the top of the bracket is Asha Vale.
- **Debriefing:** The first heat falls, and the betting boards rewrite themselves overnight. Cassian works the patrons' boxes while the crowd learns your name, trading attention for credit and access. The next heat draws the tournament's darling: the crowd favorite, unbeaten this season, with the whole arena already chanting for him.

### Mission 26 — Crowd Favorite

- **Briefing:** The crowd favorite is everything the posters promise, fast, clean, beloved, and the arena wants you cast as the villain who ends him. Oblige them on the result, not the story. Win the match while Cassian works the boxes, learning which patrons cheer for us and what they expect it to cost.
- **Debriefing:** The favorite loses gracefully, and the crowd forgives you by the third replay. Two rival factions each toast the result as secretly theirs; neither understands why you're here. The bracket narrows, and this morning your quarter-final opponent refused a large payment to withdraw, which means the money will try another door.

### Mission 27 — Fixed Odds

- **Briefing:** Your quarter-final opponent turned down a bribe to withdraw: a professional who wants his match honest. Expect a fair fight in the arena and unfair work outside it; whoever paid for a forfeit will settle for a weakened champion. Reach the bout intact, then give him the match he stayed for.
- **Debriefing:** The match is clean and the win owed to no one. Cassian makes sure every box in the arena learns who offered the bribe, and suspicion slides off the charter onto better targets. The semi-final brings the interference indoors: a patron has ordered your next opponent to surrender and present the match to you as a gift.

### Mission 28 — Honest Contest

- **Briefing:** Your semi-final opponent has orders to throw the match: a patron means to own your title by giving it to you. He doesn't want to obey, and I don't want the gift. Force the honest contest: fight like he's free, win like it's real. A title handed over is a leash.
- **Debriefing:** He fights honestly and loses honestly, and no patron alive can claim your final was bought. Cassian thanks him in print for refusing the arrangement; the fixers retreat to reconsider. One match remains. Asha Vale, three years unbeaten, the Circuit's champion and its conscience, is waiting.

### Mission 29 — Championship Point

- **Briefing:** Asha Vale: the reigning champion, the best relay operator the modern armies have produced, and the last name between the charter and the talks. She's studied every bout you've fought. Beat the best there is, in front of everyone, and make the title mean what we need it to mean.
- **Debriefing:** The Circuit has a new champion, and Cassian converts the title into formal recognition before the floor is swept. The charter sits at the talks. Vale files you under unfinished business, professional to the end. Lysa spends the patrons'-box access tracing old money: the contractor payments from the depot attacks run to a border camp, and its paymaster is still there.

**Interlude — "The Champion's Table"** *(Grand Circuit · Empty Arena)*

- **Asha Vale:** You fight like a mechanic. Every move repairs the position the last one left.
- **Conductor:** That sounded like an insult.
- **Asha Vale:** I lost. It'd be a poor one. It's the closest thing to respect I hand out.
- **Cassian:** Listen to them applaud. Every patron in those boxes still thinks your victory belongs to them.
- **Asha Vale:** Then sit carefully. The arena's more honest than the table.

## Chapter 7 — Fault Lines

*Chapter briefing (shown once when the chapter unlocks):*

Every nation's grid runs on a fragment of the old Source: one broken piece of the network that once powered a civilization, coaxed into lighting a single country at a time. Each fragment is an heirloom, a weapon, and a secret.

The fragments were separated on purpose, three centuries ago. Nobody alive remembers the reason.

Now the lights are failing in two territories at once, and the engineers have started using a word the politicians refuse to hear: sympathy. The fragments are degrading together, like one body refusing to admit it died.

### Mission 30 — Paper Trail

- **Briefing:** Lysa's found the border camp where the depot raiders were paid, and its paymaster's chits will name the contracting house behind two years of attacks. She's scouting it now, and the camp knows she's close. Escort her in, take the records, and be gone before the paymaster burns his own books.
- **Debriefing:** Lysa comes out with pay chits and seal records: proof the raiders were deniable contractors all along, and a contracting house's name that points toward a guild. The trail has to wait. A Wind city has invoked the charter: a Caelian war engine is waking beneath its streets, and every neighbor wants the machine more than it wants the city saved.

**Interlude — "Old Employment"** *(Border Camp · Captured Pay Office)*

- **Lysa Vey:** I know this guild seal because I used to carry it.
- **Cassian:** That detail was missing from your professional history.
- **Lysa Vey:** You didn't ask questions you couldn't use the answers to.
- **Conductor:** Can you get us inside?
- **Lysa Vey:** Yes. That's the part I was hoping you wouldn't ask.

### Mission 31 — Engine Below

- **Briefing:** The Wind city called us because we're the only help that arrives without an invoice for its sovereignty. A Caelian war engine is coming up under the streets, three centuries asleep and still following its last orders. Stop it, and keep it out of the populated districts while the neighbors circle overhead.
- **Debriefing:** The engine dies in the empty districts and the city stands. Five factions inspect the machines under their own streets and blame one another for the wake-up. Cassian moves before the accusations can arm themselves: an emergency ceasefire summit in the capital, every aggrieved party at one table: a table every hardliner in five capitals wants overturned.

### Mission 32 — Summit Breach

- **Briefing:** The ceasefire summit convenes in three hours, and my people have been pulling explosives out of the walls since midnight. A bomber means to bury the delegates in the building that was supposed to save the peace. Sweep the approaches, hold the hall, and get everyone out when it goes wrong. It will go wrong.
- **Debriefing:** The charges take the gallery, not the table; the delegates stagger out through smoke while their aides die under the doors. The summit is dead before the fires are, and hardliners across five capitals hold up the fallen as proof that peace was the trap. Then, in two delegations' territories at once, the power grids begin failing in sequence.

**Interlude — "The Hall Is Coming Down"** *(Ceasefire Hall · Moments After Detonation)*

- **Lysa Vey:** DOWN! Away from the windows. There could be a second charge!
- **Conductor:** The west arch is folding. Rook, brace it! There are people under that gallery.
- **Cassian:** The aides were at those doors. I put them there.
- **Lysa Vey:** Cassian. Eyes on me. The exits might be trapped and the bombers might still be inside. I need you here, not in that doorway.
- **Cassian:** They spared the principals and killed the people who made this summit possible. They wanted witnesses to carry the fear home.
- **Conductor:** Then they don't get to pick what survives. We pull out everyone we can, and then we find who lit the fuse.

### Mission 33 — Fragment Wake

- **Briefing:** Power is failing across two territories in waves, jumping between Source fragments that aren't supposed to touch. The network's own defense automata wake with the surges and treat repair crews as intruders. Escort the crews to the failing junctions and keep them working. The hospitals go dark first.
- **Objective — Hold the Junctions:** Keep the repair crews working through round 5 while the defense automata surge.
- **Debriefing:** The crews keep the wards lit, and the pattern is undeniable to anyone reading honestly: the fragments are degrading in sympathy, one body refusing to admit it's dead. Officials blame weather. One government blames its neighbor, loudly, and launches a retaliatory raid toward a civilian border district. Cassian is already drawing your route toward it.

### Mission 34 — Border Retaliation

- **Briefing:** A hardliner retaliation column is aimed at a border district full of people who had nothing to do with the accusation. Both governments will condemn you for touching it. Touch it anyway. Intercept the column before the fighting reaches the streets.
- **Debriefing:** The district survives, and both governments denounce the rescue. Saving people without a flag is apparently the one unforgivable act left. Worse, the raids have severed the remaining grid links. Two districts are failing now, winter is coming, and exactly one repair crew is free to move. It cannot reach both.

### Mission 35 — One Grid, Two Districts

- **Briefing:** Two dying districts, one repair crew, and a militia blockade chief holding the only road the crew can still use. You can clear one route before winter. Not two. Pick the district that can still be stabilized, break the blockade, and get the crew through, knowing what the other district becomes.
- **Debriefing:** One district has heat and light. The other has a martyrdom story its leaders will spend for years, and the people freezing in it know exactly who chose. There was no version that saved both, Cassian checked, but he made sure the order came down signed by you. The capital's answer to the crisis is a stage: leaders announcing, on camera, that the emergency is over.

### Mission 36 — The Official Broadcast

- **Briefing:** The grid is still failing, and the leadership declares victory over it tomorrow, live, from a hall packed with dignitaries. Extremists who want the crisis louder plan to attend. Protect the gathering and the repair crews working beneath it. We don't have to believe the speech to keep the audience alive.
- **Debriefing:** The attackers are stopped, the broadcast runs as written, and everyone on that stage knows the lights outside are still dying. 'Institutions lie to survive,' Cassian says, filing the speech. 'Remember who taught you that.' Then he gets the squad out of the manufactured celebration: an inspection trip to the township you saved, where a welcome is already being planned.

**Interlude — "Terms in Hand"** *(Capital Broadcast Hall · Service Tunnel)*

- **Conductor:** They announced the grid was stable while we were still carrying batteries into the hospital.
- **Cassian:** Institutions lie to survive. Remember who taught you that.
- **Conductor:** You almost sound proud of them.
- **Cassian:** No. I'm saying the grid fails again unless we change the people who keep hiding the damage, not just the wiring.

## Chapter 8 — Heroes and Costs

*Chapter briefing (shown once when the chapter unlocks):*

Cassian's charter is outgrowing its paper. Townships, scholars, clans, and defectors keep joining the one force in the war that answers distress calls without an invoice, and the charter is becoming a coalition whether anyone voted for it or not.

Coalitions are built out of people, and people cost. Every ally added to the roster is another name that can be ambushed, bought, or buried.

Meanwhile the decoded Caelian records keep saying the impossible: the lost capital was not destroyed. It was removed from the maps, carefully, deliberately, by everyone at once.

### Mission 37 — Return to the Township

- **Briefing:** The township is turning our inspection into a festival, and an elderly caretaker just looked at one of our oldest machines and called it by a name three centuries dead. Raiders have picked the celebration for a grab at crowd and squad alike. Keep the square. Then I want to hear what she remembers.
- **Debriefing:** The square holds and the festival finishes. The caretaker gets her private word about the machine she knew: a resonance scar with a name attached, and Cassian writes down every syllable. Before the lanterns come down, a messenger rides in from a commune up the line: a state relocation force is coming to empty it at gunpoint, and the commune refuses to go.

**Interlude — "The Old Name"** *(Riverside Township · Festival Square)*

- **Caretaker Mara:** We called that one Rook. It stood outside the school through every storm.
- **Brass Bastion-136:** Caretaker Mara. Evacuation count: thirty-seven. All accounted for.
- **Caretaker Mara:** That was sixty years ago.
- **Conductor:** It didn't forget you. It just didn't have anyone left to tell.

### Mission 38 — Forced Relocation

- **Briefing:** The commune sits on degrading ground, and the relocation authority has orders to empty it for the residents' own good, at gunpoint, since they won't go. The residents aren't wrong about the land and aren't safe on it either. Stand between the guns and the doorsteps. Nobody gets dragged out of their home today.
- **Debriefing:** The commune keeps its homes and its defiance; the relocation commander withdraws to recount his arithmetic. On the return leg, the supply convoy traveling with the squad gets diverted through the narrow pass, and both exits close behind it. Deniable raiders, coordinated, waiting for exactly this route.

### Mission 39 — Pass Intercept

- **Briefing:** We're encircled in the pass, professionals again, and they knew our route before we took it. There's no clever exit, only a fought one. Break the encirclement and bring everyone home. When I say everyone, I am including the machines.
- **Debriefing:** The squad comes home minus one. One of the oldest machines, the first gallery's own, went still holding the rear so the others could pass. Its presence lingers in the Relay anyway, faint and stubborn, carried by every machine it marched beside. Cassian writes nothing for a day. Then he orders the chassis recovered.

**Interlude — "The Missing Note"** *(Narrow Pass · Coalition Camp)*

- **Conductor:** I close my eyes and the Relay's still reaching for it. There's a gap where its signal used to be.
- **Brass Bastion-136:** Formation reports one position absent.
- **Cassian:** The salvagers hit the pass at dawn.
- **Conductor:** Then we're gone before dawn.
- **Cassian:** Transports are already ordered.

### Mission 40 — The Last Chassis

- **Briefing:** The chassis is still in the pass, and a salvage crew is moving to strip it. Their recovery chief thinks dead metal is finders' property. No speeches. Go back up there, take our own back, and be off that slope before the people behind the ambush send anyone interested in prisoners.
- **Debriefing:** The chassis comes home on a quiet truck, and the depot stands down for an evening. Waiting on Cassian's desk: a priority message from Serin. She's decoded the sanctuary's Caelian transport records, and at least two groups of claimants are moving to seize her convoy before she can reach the coalition with them.

**Interlude — "No One Left as Salvage"** *(Depot Workshop · Recovery Bay)*

- **Lysa Vey:** The chassis can't be restored. Not the way it was.
- **Conductor:** I know.
- **Brass Bastion-136:** Recovery acknowledged. Formation remembers.
- **Cassian:** Was going back worth the risk?
- **Conductor:** Ask the ones who watched us come back for it.

### Mission 41 — Contested Records

- **Briefing:** Serin's convoy is an hour out with the decoded transport history, and a record-seizure team is on the road to take it. The claimants want the documents buried or rewritten before the coalition reads them. Meet her outside the Sanctuary and walk those records through. The history matters more than the fight.
- **Debriefing:** Serin and the records reach headquarters intact; protected copies go into three separate vaults the same night. The decoded routes say what no faction archive admits: Caelis was not destroyed; it was removed from the maps, deliberately, by everyone at once. The Stranger resurfaces within the week with new coordinates and proof of who lit your Relay.

**Interlude — "A Map Made Honest"** *(Coalition Headquarters · Cartography Room)*

- **Archivist Serin:** Every founding faction signed the deletion order. Different seals, same ink formula, same day.
- **Lysa Vey:** Five enemies agreeing to erase one city.
- **Cassian:** Which means the lie was worth more than their rivalry ever was.
- **Conductor:** Put Caelis back on the map.
- **Archivist Serin:** The map just answered. A dormant transit frequency is broadcasting coordinates, signed by your Stranger.

### Mission 42 — Patron's Reach

- **Briefing:** The Stranger's coordinates lead to an abandoned relay station and an offer: proof your activation was arranged, paid for through the coalition's own patron chain. The patrons' retrieval agents will come to erase the evidence, and possibly the witness. Secure the meeting, take the proof, keep our mysterious friend breathing.
- **Debriefing:** The proof escapes, and it reads badly: patrons inside the coalition paid for the relay experiment. Director Rusk knew only the payment, a signature, not the design, and his condolences arrive ahead of his lawyers. Cassian moves before the implicated patrons can arm themselves: they're negotiating to hire the scavenger clans, and Dax Calder can reach the clans first.

**Interlude — "The Patron Chain"** *(Abandoned Relay Station · Lower Platform)*

- **The Stranger:** The experiment was purchased through six intermediaries. Your patrons saw only an invoice.
- **Cassian:** I know these names. Rusk's consortium, half the charter board. I've eaten at their tables.
- **Conductor:** Did they know I might die?
- **The Stranger:** Rusk and the others paid. They were careful never to ask what they had bought. That is not the same as planning it.
- **Cassian:** Then we ask for them, publicly, but not while they can still hire every clan between here and the capital. I need Dax Calder first.

### Mission 43 — Clan Terms

- **Briefing:** The clans sell neutrality to whoever earns it, and they respect exactly one currency. Their trialmaster sets the terms: prove your strength in a clan trial, and Dax Calder buys their neutrality with the winnings. Fight their way, on their ground, by their rules. Win the trial and the patrons lose their army.
- **Debriefing:** The clans take the trial's result as final and sell their neutrality to Calder's coin; the implicated patrons go shopping for muscle in a market closed to them. Calder also delivers authenticated contract ledgers, and Lysa reads them twice. They're enough. She can finally walk into her old guildhall and ask where the contractor money truly came from.

### Mission 44 — Guild Reckoning

- **Briefing:** Lysa confronts her old guild with Calder's ledgers in hand, and the guildhall factor has already declined to answer, politely, behind armed clerks. Escort her in and keep her standing while she makes them produce their authorizations. She's waited years for this conversation. Don't let them end it early.
- **Debriefing:** The guild produces paperwork older than the war, and responsibility climbs out of the hall into patron country: the trail points up, not back. Buried in the manifests is worse: all five factions are quietly shipping Source cores into weapons programs. One core moves this week under security sized for secrecy, not war.

**Interlude — "Open Ledger"** *(Guildhall Steps · Public Record Bell)*

- **Lysa Vey:** Resignation's filed. Credentials suspended. My former guild would like me arrested.
- **Cassian:** The coalition needs an independent assessor.
- **Lysa Vey:** You mean an assessor no respectable office will touch.
- **Conductor:** We were never especially respectable.
- **Lysa Vey:** First convincing offer I've heard all day.

## Chapter 9 — Cores

*Chapter briefing (shown once when the chapter unlocks):*

A Source core is a fragment's heart: enough concentrated power to run a city or end one. Every nation officially renounces weaponizing them. Every nation is quietly doing it.

Inside each government, the hardliner wings have stopped waiting for permission. They want the open war the moderates keep postponing, and they are increasingly willing to start it themselves.

The coalition is about to hold the one thing all five factions were arming in secret. Owning it makes the coalition a power whether it wanted to be one or not.

### Mission 45 — Core in Transit

- **Briefing:** The manifests name a Source core in transit: one convoy, one route, guarded for secrecy rather than battle. Intercept it and take the core before it reaches a weapons program. Understand what winning buys: once we hold a core, every flag in the world calls us exactly what they feared.
- **Debriefing:** The convoy surrenders the core, and Cassian's warning lands within hours: the coalition now owns the thing all five factions were arming in secret, which makes it a power whether it wanted to be one or not. Five competing custody demands arrive by morning. Cassian's answer is a shared-custody proposal, announced publicly at Unity Day.

**Interlude — "Possession"** *(Coalition Depot · Source-Core Vault)*

- **Conductor:** We took the core so no faction could turn it into a weapon.
- **Cassian:** And now every faction sees a weapon with our troops standing around it.
- **Lysa Vey:** Intent doesn't show up on an inventory.
- **Conductor:** Then the vault gets five locks and five different keys. Nobody opens it alone, including us.
- **Cassian:** That may be the first political solution you've ever proposed. I'll present it at Unity Day, where every faction answers in front of the public.

### Mission 46 — Unity Day

- **Briefing:** Cassian announces the shared-custody proposal at Unity Day, in the capital's most crowded square. A hardliner cell means to turn the celebration into the massacre that ends all talk of sharing. General Strosse's people want the open war the moderates keep postponing. Work the crowd, find the cell, stop the killing.
- **Debriefing:** The square empties frightened instead of dead, and the captured orders read worse than the attack: Unity Day was the opening move. While the crowd is still fleeing, General Strosse's armored columns leave their garrisons and advance on the council chambers. The coup Cassian has been predicting all season is finished hiding.

### Mission 47 — The Coup

- **Briefing:** Strosse's field marshal is driving armored columns at the council chambers, betting the government folds before breakfast. Break the advance in the streets before it reaches the government district. The moderates are watching from their windows, deciding which side to be brave on. Give them an easy choice.
- **Debriefing:** The coup breaks at the government district's edge, and the moderates discover they were loyal all along; Cassian absorbs them, paperwork first. Clearing the underground approach turns up what the battle was sitting on: a powered Caelian transit line beneath the capital, still drawing energy, still maintained, pointing somewhere no map admits.

**Interlude — "The Hardliner's Position"** *(Coalition Headquarters · Detention Block)*

- **General Strosse:** If you came for a confession, adjutant, file a requisition. I'll give you a position instead: the Source is too dangerous to share, and your coalition is a story moderates tell to postpone deciding who controls it.
- **Cassian:** That story kept five armies from the gate.
- **General Strosse:** For a season. Paper holds until the day it doesn't, and then the side with discipline takes the field. That's not treason. That's arithmetic.
- **Conductor:** Your arithmetic put guns on a Unity Day crowd.
- **General Strosse:** And your improvisation broke a prepared coup in four hours. I don't admire improvisation, Conductor, but I know soldiering when it beats mine.
- **Cassian:** Noted. For the tribunal.
- **General Strosse:** Quote it exactly. I'd hate to be misrepresented.

### Mission 48 — Rearguard

- **Briefing:** The transit line's entrance is real, and the coup's rearguard still holds the surface above it, beaten troops with nothing to lose and orders to deny everything. Clear them off the station so Serin's team can go down and trace the route. Watch for demolition charges; dying coups love a buried secret.
- **Debriefing:** Serin's team goes in, and the line's maintenance records are recent; someone has kept it alive for three centuries. Its terminus sits in a place missing from every modern map. The station's activation doesn't stay quiet: three faction armies detect the power draw and converge on the populated town above the next junction.

### Mission 49 — Three Fronts

- **Briefing:** Three armies are converging on the town above the junction, and none of them plans to arrive second. We cannot win that battle. Nobody can. What we can do is hold an evacuation corridor until every civilian is out, then be gone ourselves. Lives only. Nothing else is on the table.
- **Debriefing:** The corridor holds until the last family is through; then the town belongs to the armies, the first true three-faction battle, fought over empty streets. The war everyone feared has begun, and history will record the coalition's part in its opening battle as a retreat. Cassian starts calling the enemies he can still talk to.

**Interlude — "The Ground We Surrendered"** *(Evacuated Township · Western Ridge)*

- **Asha Vale:** By sunset, each army claims we handed this town to the other two.
- **Conductor:** They can keep the streets. The people are breathing.
- **Cassian:** I'll make sure the record separates ground surrendered from lives saved.
- **Asha Vale:** Records won't stop the next army.
- **Conductor:** No. People might.

### Mission 50 — Truce Line

- **Briefing:** Cassian has talked several of the shooting enemies into a local truce, signed on a line you'll be standing on, beside troops we fought last month. Hardliner holdouts on every side want the signing buried with its signatories. Hold the truce line until the ink exists. Give peace the hour it needs.
- **Debriefing:** The truce holds because former enemies enforce it shoulder to shoulder, and it spreads along the front faster than orders travel. On the first joint patrol, several of your oldest machines refuse a pursuit order, and move, unasked, to shield the wounded of both sides. The truce partners demand to know what the coalition is actually fielding. Cassian arranges a controlled demonstration.

**Interlude — "Terms of Respect"** *(Truce Line · Shared Command Tent)*

- **Dax Calder:** My people held the eastern sector. Yours made a dramatic amount of noise in the west.
- **Conductor:** Is that a compliment?
- **Dax Calder:** It's an invoice with the total removed.
- **Cassian:** The truce needs a joint patrol commander.
- **Dax Calder:** Then I accept, provided the mechanic promises not to repair my personality.

### Mission 51 — Coalition Trial

- **Briefing:** The machines refused an order in front of three nervous armies, and the truce partners want data, not assurances. So: a controlled field trial, on the record: the coalition's own test conductor fields the opposing squad to give the observers honest resistance. Learn, in public, whether a truce can stand on machines that choose.
- **Debriefing:** The trial ends without casualties and without comfort: the machines take some orders, decline others, and protect bystanders regardless of flag. All three signatories leave the observation post quietly alarmed. Their follow-up negotiation hardens into a demand that the dispute be settled the old way: champion combat, one staged battle, winner takes the point.

**Interlude — "A Refusal in Formation"** *(Forward Depot · Resonance Bay)*

- **Conductor:** They ignored the attack order. Then they shielded the medics instead.
- **Brass Bastion-136:** Purpose conflict. Destruction unnecessary. Protection retained.
- **Cassian:** An army that can refuse its commander will terrify every government on the map.
- **Conductor:** Good. That scares me less than one that can't.

### Mission 52 — Managed Retreat

- **Briefing:** The three delegations have hired a provocateur to settle their dispute by staged battle and called it negotiation. Circuit rules, treaty language riding on the result. Cassian needs the coalition to lose this one: the ground yielded, no delegation humiliated. Control the fight, keep it clean, withdraw on his signal.
- **Debriefing:** The withdrawal lands exactly as choreographed, and the talks survive because nobody won enough to gloat. Cassian no longer asks before he spends you; note it and move on. The staged battle's Source draw doesn't stay on the field. Lights fail across the district, and dormant machines begin waking in sequence, answering something.

**Interlude — "The Signal to Withdraw"** *(Negotiation House · Private Stair)*

- **Conductor:** You committed the squad before you told me the plan.
- **Cassian:** If either delegation had known the withdrawal was arranged, they'd have refused it.
- **Conductor:** I'm not either delegation.
- **Cassian:** No. You're the person I trusted to survive my decision.
- **Conductor:** Next time, trust me before the decision.

## Chapter 10 — Coalition Fracture

*Chapter briefing (shown once when the chapter unlocks):*

The Source fragments have begun synchronizing on their own: blackouts rippling between grids, dormant machines waking in sequence, the network answering something nobody sent. The Order is certain of one thing only: it is not an attack. It is a response.

The factions' recruitment bureaus screen the public for anyone who might interface with a Relay. What they do with the people they find is not in any pamphlet.

Under the old districts run buried Caelian conduits, sealed since the collapse. Lately, their maintenance lights have been coming on.

### Mission 53 — Network Answer

- **Briefing:** The blackout is spreading, and grid crews report the impossible: Source fragments synchronizing on their own, waking defense automata as they link. The Order confirms it's not an attack; it's a response, though nobody knows to what. Follow the crews outward and keep them alive while they contain the cascade.
- **Debriefing:** The crews contain the first cascade, and the network keeps answering itself regardless. In the dark, a locked ward inside a faction recruitment center fails open, and the bureau's security mobilizes not to evacuate it but to reseal it. Lysa's contact inside says the ward holds people, not equipment, and the life support is on battery.

**Interlude — "The Network Listens"** *(Failed Grid District · Relay Substation)*

- **Archivist Serin:** The fragments synchronized under battlefield loads. No operator issued anything.
- **Conductor:** It felt like the Relay does when the machines reach for one another.
- **Lysa Vey:** You're telling me the power grid is frightened.
- **Conductor:** I'm telling you we've been assuming only people can notice a war.

### Mission 54 — Intake Blockade

- **Briefing:** The ward holds people who passed medical screening for possible Relay use and then refused the bureau's sponsorship contracts: no Relays, no Conductors, just candidates the recruitment bureau won't release. Its security chief is restoring the locks while their life support runs down. Get them out before either deadline lands.
- **Debriefing:** The candidates reach the coalition clinic alive, and the bureau brands the rescue theft of state recruitment assets. The hardliner alliance takes up the phrase gratefully and launches the offensive it had already prepared: three fronts, timed to the hour. Cassian reads their declaration twice and starts moving pieces: only one force can intercept every breakthrough.

**Interlude — "Asset, Prisoner, Person"** *(Coalition Clinic · Intake Hall)*

- **Nara:** I went in for a medical screening. I never touched a Relay, and they still decided my future belonged to them.
- **Conductor:** A screening isn't consent.
- **Nara:** After I refused the contract, my file stopped using my name.
- **Cassian:** I have that file. By morning, it's evidence.

### Mission 55 — Counteroffensive

- **Briefing:** The hardliner alliance is driving three fronts at once, and the coalition has no second force. We're the interception. Run the breakthroughs one after another and keep running. The medics are already refusing to clear you for the field. Pace the strain: the Relay has to outlast this offensive, and so do you.
- **Objective — Break the Offensive:** Destroy 10 hardliner units. Their Conductor stays behind the line and cannot be attacked.
- **Debriefing:** The fronts hold at a cost the medical tents will count for weeks. The offensive's field command reports failure, and its sponsors change targets: if the coalition can't be broken in battle, its delegates can be removed one at a time. Cassian's network catches the first kill team before it reaches its hotel.

**Interlude — "The Body Keeps the Account"** *(Field Hospital · Conductive Ward)*

- **Cassian:** The doctors won't clear you for another deployment.
- **Conductor:** The western front would've broken.
- **Brass Bastion-136:** Conductor survival priority elevated. Formation will interpose.
- **Conductor:** I never gave that order.
- **Brass Bastion-136:** Shared purpose does not require order.

### Mission 56 — The Assassins

- **Briefing:** The assassins are working down the delegate list, and Cassian's network is racing them name by name. Move the surviving representatives to the secure chamber and hunt the teams hunting them. Tonight you'll see how far his information web reaches: every warning on your map is one of his people paying a debt.
- **Debriefing:** The delegates reach the secure chamber alive; the kill teams don't. Shaken and done hiding, the survivors invoke emergency procedure and call a public tribunal: one open session to decide who can legitimately govern the Source. Every armed claimant in the war now has a date, a place, and a target.

**Interlude — "Cassian's Other Ledger"** *(Coalition Headquarters · Records Cellar)*

- **Cassian:** Informants, couriers, sympathetic clerks, and people owed favors by people owed favors.
- **Conductor:** How long have you had this network?
- **Cassian:** Long enough that telling you earlier would've made you responsible for it.
- **Lysa Vey:** That isn't how responsibility works.
- **Cassian:** No. It's how plausible deniability works.

### Mission 57 — Tribunal Under Fire

- **Briefing:** The tribunal convenes in public because secrecy is what killed the last answers. Rival claimants have sent disruptors to make sure no answer survives the asking. Keep the chamber standing and the witnesses breathing until every claimant has been heard. There is no correct side in that room; that's the point of protecting all of it.
- **Debriefing:** The tribunal hears everyone and answers nothing: no claimant can impose control safely, and now that's on the record. Serin offers the buried Caelian conduits as neutral ground for a shared settlement. Fighting has already reached the western district above their only mapped entrance, and a royalist guard holds the gate under a charter nobody remembers signing.

### Mission 58 — Royalist Gate

- **Briefing:** The royalist gatekeeper at the western entrance has kept his post since the Empire, hereditary, formal, unimpressed by three centuries of successor states. His charter demands a trial of passage before the gates open, and he'll honor the result. Meet their terms exactly. We need them as doorkeepers, not casualties.
- **Objective — Trial of Passage:** Defeat the gatekeeper's Conductor without destroying the marked doorkeepers. We need them as doorkeepers, not casualties.
- **Debriefing:** The gatekeepers honor the trial and open the western conduit, three hundred years of duty discharged with a bow. The coalition goes under the city. Above, ranging fire starts walking toward the buried route: a siege corps' long-range batteries, already solving the conduits' geometry. Someone means to close the door behind us permanently.

**Interlude — "A Charter Still in Force"** *(Western Conduit Gate · Royalist Court)*

- **Archivist Serin:** The gate charter carries the seal of Caelis. Legally, it never expired.
- **Cassian:** Then neither did the authority that issued it.
- **Conductor:** You sound pleased.
- **Cassian:** I'm pleased the door opened. I'm concerned about who kept the keys.

### Mission 59 — Battery Night

- **Briefing:** The siege corps' battery commander has his guns ranged on the conduit route, and the next barrage could drop the passage on the coalition inside it. Break through the surface defenses and silence the batteries before they fire again. No illusions: every side will rebuild these guns. Tonight the tunnels need them quiet.
- **Debriefing:** The conduits survive the night; the batteries are scrap until someone rebuilds them, and everyone knows someone will. Cassian spends the victory the same hour: he calls Asha Vale and asks her to raise a joint force from the Circuit's old rivals, people who tried to buy, beat, and bury you, to hold the exposed route while Serin finishes the maps.

### Mission 60 — Joint Formation

- **Briefing:** Asha Vale answers with a team built from the Circuit's old rivals, and the siege corps answers her with a route commander sent to retake the passage. Fight beside people who tried to buy, beat, and bury you, and hold the conduit line until Serin's survey is done.
- **Debriefing:** Vale's team holds the route until the survey is complete, and Serin's finished maps show what the conduits were built toward: a single maintained passage beyond the known network, with a live signal waiting at its far terminus. The Stranger studies the map a long moment, then asks the coalition to walk it, and says she's done being a stranger.

**Interlude — "Former Opponents"** *(Conduit Route · Joint Strike Camp)*

- **Asha Vale:** I brought the people you beat in the Circuit. They already know you can win.
- **Conductor:** Do they know how to take an order from me?
- **Asha Vale:** No. They know how to understand an objective. That's usually better.
- **Cassian:** The coalition appears to have acquired an army.
- **Asha Vale:** Call it a team until you earn the other word.

### Mission 61 — The Maintained Route

- **Briefing:** The Stranger finally gives a name: Ilyra, warden of Caelis, sent to bring the accidental Conductor home. The maintained route ends at a terminus its transit custodians still guard, and Vale's team can hold the junction behind us only so long. Secure the passage, reach the terminus, meet whatever's been signaling.
- **Debriefing:** The terminus custodians stand down to Ilyra's authority, and the signal's source is what she promised: a transit gate, powered and waiting. Her report home doesn't stay secret. Intercepted military traffic shows five faction armies converging on the same route. Every flag in the war is marching on Caelis at once.

**Interlude — "The Invitation"** *(Caelian Transit Terminus · The Far Door)*

- **The Stranger:** My name is Ilyra. I am a Warden of Caelis.
- **Warden Ilyra:** I was sent to observe the continuity test and bring home any Conductor who survived it.
- **Conductor:** Home? I've never seen Caelis.
- **Warden Ilyra:** The Relay has. To the Wardens, that distinction is sufficient.
- **Cassian:** Then the Wardens are about to learn what distinctions cost.

### Mission 62 — Caelis Approach

- **Briefing:** Five armies are converging on the gate of Caelis, and Ilyra can hold the threshold open only so long. Cassian is assembling the delegations into something that arrives as a coalition instead of an invasion. Hold the gate approach against their vanguards until he's ready. The last battle of this war is keeping the war outside those walls.
- **Debriefing:** Cassian reaches the gate leading a coalition, not an army, and the war stops at the threshold because you held the approach until it could. Caelis opens. The Wardens admit the delegation as far as an inspection court in the Outer City, no further. Three hundred years of sealed gates do not open on one good afternoon.

**Interlude — "At the Threshold"** *(Caelis · Outer Inspection Court)*

- **Warden Ilyra:** No foreign delegation has crossed this threshold in three hundred years.
- **Cassian:** Then it's fortunate we came as a coalition rather than a foreign power.
- **Lysa Vey:** That sentence shouldn't have worked.
- **Cassian:** It worked because everyone here wants a reason not to start shooting.
- **Conductor:** The machines know this place. They've gone quiet.

# Act 3

## Chapter 11 — The Outer City

*Chapter briefing (shown once when the chapter unlocks):*

Caelis was never destroyed. Behind three centuries of sealed gates, the Imperial capital stands lit, swept, and maintained, a city kept ready for citizens who never came home.

The Wardens of Caelis keep it: hereditary custodians and their machines, still executing a disaster protocol older than every nation outside the walls. They are not a government. They are a duty that outlived one.

They did not open the gate out of welcome. For the first time in centuries the world has produced a true Conductor, and the Wardens inspect anomalies before they admit them.

### Mission 63 — Outer Inspection

- **Briefing:** The Wardens will admit the delegation on one condition: their emergency protocol inspects you first. Their examiner wants to watch you conduct our machines without touching a Caelian system. Give the protocol a clean reading. Three hundred years of procedure is watching, and it only says no once.
- **Debriefing:** The examiner's verdict: an unregistered Conductor with an unauthorized Relay: an anomaly to be studied, not sealed out. The gates open onto an Outer City that is lit, swept, and kept for citizens who never came home, and its caretaker machines take one look at the delegation and file it under trespassers.

### Mission 64 — City Still Running

- **Briefing:** The Outer City's caretakers have kept it immaculate for three centuries of absent citizens, and their rules have no category for guests. They've classified the delegation as trespassers and started enforcing. Keep the machines off our people without wrecking the city they love. The Wardens are scoring how you win.
- **Debriefing:** The caretakers stand down once the squad proves it will protect their city instead of claiming it. The Wardens watch machines defended by a Conductor who could have taken them, and their answer is a second examination: stewardship, at a maintenance district whose own machines stay under Caelian command.

### Mission 65 — Stewardship Trial

- **Briefing:** The stewardship examination has one rule that matters: defend the maintenance district without conducting a single Caelian machine assigned to it. The examiner's own custodians will press you. Protect their district with only what we brought. Show them conducting can mean keeping, not taking.
- **Debriefing:** The district holds, and not one Caelian machine changes hands to hold it. The Wardens record the result in whatever passes for their books and unlock the inner gates. Serin already knows where she's leading the delegation first: the Imperial Archive, whose custodians deny Wardens and outsiders alike.

**Interlude — "Stewardship"** *(Caelis · Maintenance District)*

- **Warden Ilyra:** You could have seized the district machines through the Relay.
- **Conductor:** They already had work and a purpose. They didn't need mine.
- **Warden Ilyra:** The old Conductors would have called that restraint.
- **Brass Bastion-136:** Correction. Recognition.

## Chapter 12 — The Imperial Archive

*Chapter briefing (shown once when the chapter unlocks):*

Every nation teaches the fall of the Empire from its own textbook, and no two textbooks agree. Caelis keeps the original.

The Imperial Archive holds the Empire's final years unedited: the Source crisis, the votes, the signatures, the decision that no single power could ever safely hold the whole network. Its custodians protect that record from everyone, including the Empire's heirs.

Five modern nations were born from that record. All five have reasons to want it burned.

### Mission 66 — The Buried Record

- **Briefing:** The Imperial Archive keeps the Empire's unedited account of its final years, and its custodians were built to keep that account from everyone, Wardens included. Serin needs the record intact, so disable the defenses without pulping what they guard. Precision work. The record is the prize, not the rubble.
- **Debriefing:** The archive opens with its collection unharmed. Its record shows a Source crisis and an Empire that chose to fragment the network rather than trust any single power with it whole, and its index points to five sealed founding galleries. Alarms answer first: faction claimants are already breaching them to burn what weakens their histories.

### Mission 67 — Fivefold Claim

- **Briefing:** Five founding galleries, one per faction, each holding the annotated truth of what its nation preserved, and what it was meant to preserve. Claimant record-burners are inside already, destroying evidence in rooms their own capitals sent them to. Reach the galleries before the collection is gone.
- **Debriefing:** The galleries survive with their records legible; the burners leave empty-handed and their sponsors unnamed, for now. Read together, the five sections stop being five myths and become one syllabus, and a cipher none of the Order's keys touches, pointing down to the archive's deepest sealed vault.

**Interlude — "Five True Stories"** *(Imperial Archive · Founding Galleries)*

- **Archivist Serin:** Each faction preserved one honest fragment: discipline, industry, faith, freedom, ambition.
- **Lysa Vey:** And each built a whole history around its favorite piece.
- **Cassian:** A lie can be made entirely from truths arranged for the wrong purpose.
- **Conductor:** Then we show them the pieces fit together.

### Mission 68 — Deep Archive

- **Briefing:** The deep vault holds the evidence that made the Empire break its own civilization, and guardians designed to resist Conductors, which means they were designed for someone like you. Take the record, keep the guardian network dormant, and let nothing in that vault leave with you except knowledge.
- **Debriefing:** The deep record comes out and the vault seals behind it, guardians dormant, archive intact. What it names is worse than any weapon: living witnesses, kept in a Conductor Vault nearby: the people who paid the price behind the Empire's decision. Their hospice assesses visitors before it admits them.

**Interlude — "What Remains Sealed"** *(Imperial Archive · Deep Vault)*

- **Cassian:** You haven't told us what was in the final record.
- **Conductor:** Not yet.
- **Cassian:** I've spent years arguing that hidden history is a weapon.
- **Conductor:** Then trust me when I say this one's still loaded.
- **Cassian:** I do. I don't like how much it costs both of us.
- **Archivist Serin:** The record names living witnesses in the Conductor Vault. We should hear them before deciding what the world can bear.

## Chapter 13 — The Conductor Vault

*Chapter briefing (shown once when the chapter unlocks):*

The Empire's Conductors did not all die with it. The survivors live in the Conductor Vault, not a prison, a hospice, still paying, century after century, for what the Relay program took from them.

They remember what true Conduction costs, and they remember why Caelis sealed itself: a continuity test, a wager that the world outside might someday produce a Conductor worth trusting with the keys.

The test was arranged through expendable intermediaries. It succeeded. Its result is standing in their ward.

### Mission 69 — Living Witnesses

- **Briefing:** The Conductor Vault isn't a prison; it's a hospice: the last First Conductors, still alive, still paying for what the Relay program took from them. Its guardians assess every visitor for harm before they allow a word. Pass their assessment gently. Some of these witnesses have waited three centuries to be asked.
- **Debriefing:** The guardians stand down, and the First Conductors receive the delegation in the Relay ward: your own medical future, walking and talking. They answer every question but one, and for that one they point at the Warden council. The council's own Continuity Directorate responds by sealing the witness chamber before anyone can testify.

**Interlude — "Company in the Relay"** *(Caelis · Conductor Vault)*

- **First Conductor:** They taught your age that we commanded machines, because command is easier to regulate than companionship.
- **Conductor:** The Relay is hurting me.
- **First Conductor:** Yes. Shared purpose means shared weight. The old Empire praised the gift and hid the bill.
- **Brass Bastion-136:** Weight shared. Conductor not alone.
- **First Conductor:** And you were not chosen by chance. Ask the Warden council why it needed a new Conductor badly enough to spend your life on the answer.

### Mission 70 — The Relay Experiment

- **Briefing:** The Continuity Directorate authorized the relay experiment that made you, arranged through expendable intermediaries, our own patrons among them, and now it's sealed the council chamber and turned its custodians on the witnesses. Break the lockdown. The council's testimony and its records both survive this, or the truth dies with its keepers.
- **Debriefing:** The lockdown breaks and the council records survive. Cornered by its own paper, the Warden council admits what your activation was: a deliberate continuity test, and you the result it hoped for. Then it summons the new Conductor to the Crown Relay: an invitation with an honor guard attached.

**Interlude — "Continuity Test"** *(Warden Council · Witness Chamber)*

- **Warden Ilyra:** We authorized the continuity test. The intermediaries were never told what it was.
- **Conductor:** I was never told anything.
- **Warden Ilyra:** Caelis needed to know whether Conduction could take hold again. We were afraid it could not.
- **Cassian:** You turned a person into a question because you were afraid of the answer.
- **Warden Ilyra:** Yes. There is no honorable wording for it. The council will summon you to the Crown Relay: your survival was the answer it wanted.

### Mission 71 — Crown Continuity

- **Briefing:** The council offers you the Vault's purpose: stay in Caelis, succeed the First Conductors, become the system's next warden. It's honestly meant, and it's the wrong answer, and the honor guard sealing the exits agrees with the offer more than the answer. Decline carefully, then leave anyway.
- **Debriefing:** The containment breaks without a single guardian harmed; the Crown Relay stands, and so does the refusal. Caelis learns the new Conductor won't be kept, so it tries politics instead, petitioning for a public hearing on the Source's stewardship. Armed restorationists are already moving to take the council chambers first.

**Interlude — "Succession"** *(Conductor Vault · Crown Relay)*

- **Warden Ilyra:** The honor guard has withdrawn. The offer stands: accept the Vault, and Caelis will recognize you as successor.
- **Conductor:** My answer's still no.
- **Cassian:** One good ruler is still a system waiting for one bad heir.
- **Conductor:** Open the doors. Let the world help carry what it uses.
- **Warden Ilyra:** Then Caelis will petition the coalition in the morning. If we cannot name a successor, we will argue for stewardship in the open.

## Chapter 14 — The Civic Core

*Chapter briefing (shown once when the chapter unlocks):*

Caelis has petitioned to resume stewardship of the Source. The factions' answer is the Accord: a negotiated settlement placing the network under shared authority, the first document in three hundred years that every flag is asked to sign.

Cassian drafts; the delegations bargain; the extremes on both sides reach for force. Restorationists who want the Empire back and hardliners who want the Source seized agree on exactly one thing: the talks must not succeed.

The war's last battles will be fought over a negotiating table.

### Mission 72 — Civic Petition

- **Briefing:** Caelis has asked for a public hearing on who should steward the Source, and every surviving delegation is coming to answer. Restorationist hardliners mean to seat a different answer by force. Their seizure team is already moving on the Civic Core's chambers. Clear them out and hold the hall for the talks.
- **Debriefing:** The Civic Core holds, and the delegations sit down under coalition guard to resume what the seizure was meant to end. The failure teaches the extremes something the moderates never could: neither can win alone. Caelian restorationists and faction hardliners open a channel neither admits to, and plan the talks' funeral together.

**Interlude — "The Petition"** *(Caelis Council Hall · Coalition Table)*

- **Warden Ilyra:** Caelis petitions to resume stewardship of the Source.
- **Dax Calder:** A polite word for ownership.
- **Asha Vale:** Then counter it with terms, not weapons.
- **Cassian:** For the first time, everyone who claims the Source is in one room. Keeping them here is the victory.
- **Conductor:** Then I'll keep the doors standing.

### Mission 73 — Extremes Aligned

- **Briefing:** Restorationists and faction hardliners: the two ends of the argument, allied at last, against the middle. Their joint conductor leads the push to break the negotiations before a compromise exists. Protect the negotiators. You don't get a seat at their table; you get to make sure the table survives.
- **Debriefing:** The alliance of extremes breaks, and needing each other at all tells the room how much both ends fear the middle. The talks continue. Cassian starts drafting the Accord in the next chamber, and you begin to read the room the way he always has, while every would-be signatory sends troops to underline its demands.

### Mission 74 — Accord Draft

- **Briefing:** Cassian is drafting the Accord, and every proposed signatory wants one more concession; several have sent pressure forces to the negotiating hall to make the wanting persuasive. Keep the troops away from the draft. Your part in this story gets smaller from here; that's what winning looks like.
- **Debriefing:** The pressure forces withdraw, and with outside coercion off the table Cassian seals the completed draft for review. Its first article demands proof, not promises: a joint repair team from every signatory must enter the Source complex and reconnect the fragments. The complex's own defenses will read that as a seizure.

**Interlude — "The Architect"** *(Accord Chamber · Third Night)*

- **Cassian:** The draft gives no faction a permanent majority. Source access requires shared inspection.
- **Conductor:** My name isn't in it.
- **Cassian:** No.
- **Conductor:** Good. If the peace needs me forever, we didn't repair anything.
- **Cassian:** Now you sound like an institution builder. Tomorrow the signatories send one joint repair team into the Source; the Accord lives only if that team works.

## Chapter 15 — The Source

*Chapter briefing (shown once when the chapter unlocks):*

The Source was never a generator. It is a balancing network: the system that kept a civilization's power moving where it was needed, stable because it was whole.

Fragmented, each piece is a bomb waiting for a hand. Reconnected and governed, it is a civilization again. The Empire understood that at the end, and dismantled itself to protect it.

The Accord's signatures will decide which version the world gets. Every force that would rather burn the future than share it is already marching.

### Mission 75 — Source Balance

- **Briefing:** The Accord's first article sends a joint crew from every signatory into the Source complex to reconnect its fragments. The complex's distribution defenses were built against exactly this, one power reaching for the whole, and they can't read a treaty. Escort the crews and keep them working until the network understands.
- **Objective — Reconnect the Network:** Spend 20 total mana on deployments to bring the fragments into balance. Defeating the defense Conductor also wins.
- **Debriefing:** The fragments reconnect, and the truth finishes coming out: the Source was never a generator; it's a balancing network, a bomb when any one hand holds it, a civilization when every hand does. The reconnection also lights the complex for every rejectionist force left in the world. They're already marching.

**Interlude — "The Balancing Network"** *(Source Complex · Distribution Heart)*

- **Archivist Serin:** The Source doesn't create power. It balances unlike systems so none can consume the rest.
- **Conductor:** It was never one machine.
- **Warden Ilyra:** Nor was the Empire, until it forgot.
- **Cassian:** Then the engineering diagram and the Accord require the same design.

### Mission 76 — Rejection Line

- **Briefing:** Every rejectionist army left is converging on the Source complex, and their field marshal understands the war better than its owners do. Champions from every faction stand with you on the approach. Hold the field, all of it, every flag, and keep everyone alive long enough for their leaders to sign.
- **Debriefing:** The allied line holds, faction champions shoulder to shoulder where the war's fronts used to be. In the assembly hall the signatures begin. The rejectionists fall back for one last advance, and their marshal gives the conflict its name before the histories do: the Resonance War, ending at a signing table.

**Interlude — "The War Gets a Name"** *(Source Approach · Allied Field Line)*

- **Asha Vale:** Coal holds the center. Wind scouts the conduits. Solar medics are treating Fusion troops.
- **Dax Calder:** A week ago, any of those sentences would've started a riot.
- **Warden Ilyra:** The marshal named it better than any of us could. Caelis will keep his word for it, in memory of all five factions' dead.
- **Conductor:** Record who stood together, too.

### Mission 77 — The Caelis Accord

- **Briefing:** The Accord is ready for signatures, and the last rejectionists are coming up the approach to stop the pen. Defend the assembly and buy every signature the time it needs. End this the way Cassian built it: with everyone alive enough to sign.
- **Debriefing:** The Accord is signed. The factions take home a shared account of the past, return the most dangerous evidence to its vault, and place the Source under an authority that belongs to no one flag. The war ends at a table, which is where Cassian always said it would.

**Interlude — "What Outlives Us"** *(Caelis · Accord Hall at Dawn)*

- **Cassian:** Quiet, for the end of a war.
- **Lysa Vey:** You've been smiling at the filing clauses for ten minutes.
- **Warden Ilyra:** The Source is reconnecting. It recognizes no single master.
- **Brass Bastion-136:** Formation expanded. Purpose shared.
- **Conductor:** Good. Now we fix what the war left broken.
- **Cassian:** And this time, we leave instructions someone else can use.

---

## Campaign Epilogue

*Shown on completing the final mission.*

Cassian's Accord holds. The factions publish the history they can safely share, return the most dangerous evidence to its vault, and place the Source under an authority no single flag owns.

The war ends. The grids stabilize, and the cities stay lit.

History remembers Cassian as the architect of the peace. It records you as a reclamation technician who was present at several decisive events.

You return to repair work, accompanied by machines that have grown older and more individual than any official history will acknowledge.

Years later, historians give the conflict a name:

THE RESONANCE WAR
