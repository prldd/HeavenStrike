# Unit Faction and Sprite Staging Reference

This document is the balancing reference for the full-body sprite redesign. It records the proposed faction of every active unit lineage and the source art filename staged under assets/units/full_by_class/. The live game continues to load assets/units/full/ until the replacement sprites are complete.

## Allocation rules

- Coal favors Fighters (Duelists).
- Steam favors Defenders (Wardens).
- Wind favors Scouts (Striders).
- Fusion favors Mages (Channelers).
- Solar favors Priests (Lifebinders).
- Gunners (Artillerists) have no exclusive faction affinity and are distributed across all five.
- Every faction has at least one lineage in every class. Affinity determines prevalence and where many of the strongest lineages live; it is not a class restriction.
- A promotion lineage is indivisible. Every promotion remains in the same faction folder as its base unit.
- The twelve standalone 1-star, skill-less base units are Universal and available to every faction.
- Sakuya, Yuuya, and Nageki begin skill-less but promote into skilled units, so each remains in its assigned faction with its full promotion lineage.
- Filenames are authoritative art IDs, not project icon IDs. Generated replacements should retain the exact PNG filename.
- Unknown source images that are not referenced by the active 210-unit catalog remain in Unclassified.

## Balance snapshot

| Faction | Defender | Fighter | Scout | Gunner | Mage | Priest | Total | 5–6 star | Star total | Avg. stars |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Coal | 4 | 13 | 4 | 7 | 6 | 6 | 40 | 16 | 165 | 4.12 |
| Steam | 15 | 2 | 4 | 6 | 6 | 7 | 40 | 18 | 167 | 4.17 |
| Wind | 4 | 6 | 11 | 6 | 6 | 6 | 39 | 19 | 164 | 4.21 |
| Fusion | 6 | 4 | 4 | 7 | 13 | 6 | 40 | 18 | 165 | 4.12 |
| Solar | 6 | 4 | 4 | 4 | 6 | 15 | 39 | 16 | 162 | 4.15 |
| Universal | 2 | 2 | 2 | 2 | 2 | 2 | 12 | 0 | 12 | 1.00 |

The five faction pools contain 39–40 units each. Their total rarity is intentionally close (162–167 stars), while each affinity class is the largest class group in its faction. Universal units are excluded from faction rarity comparisons.

### Affinity strength anchors

The strongest affinity-class lineages deliberately remain with their natural faction. These are the first visual-synergy anchors to preserve during later balance passes:

- Coal: Awoken Clair, Sir Gawain, José Decomposé, and LDF Mastersword (Fighters).
- Steam: Sterling Knight, Ra, Creator, Commune Commander, and Geartron-5000 (Defenders).
- Wind: Cutpurse, Ninja Edge, Talon Slicer, and Clawing Cara (Scouts).
- Fusion: Summoner Rydia, Gorgon Medusa, The Twilight Queen, and Conjuring Jester (Mages).
- Solar: Oro the Enlightened, Shining Inti, The Biologist, and Glowing Opelle (Priests).

Cross-class lineages keep the overall rarity pools close and ensure faction Conductors have real deployment choices without diluting these anchors.

## Folder contract

~~~text
assets/units/full_by_class/
├── Coal/
├── Steam/
├── Wind/
├── Fusion/
├── Solar/
├── Universal/
└── Unclassified/
~~~

Coal, Steam, Wind, Fusion, Solar, and Universal contain the active source art. Unclassified contains reference images with no active UnitCatalog entry. The obsolete class folders were removed after their active files were reassigned.

## Lineage assignments

### Coal

| Class | Secondary skill | Promotion lineage and source art |
|---|---|---|
| Fighter | Empower | Rage Brute (2★; 015.png) → Rage Bruiser (3★; 016.png) |
| Scout | Pinning Strike | Claw Skirmisher (2★; 017.png) → Claw Ambusher (3★; 018.png) |
| Mage | Misfortune | LDF Crowd Mage (2★; 045.png) → LDF Riot Mage (3★; 046.png) |
| Priest | Plague | Blight Doctor (3★; 059.png) → Blight Physician (4★; 060.png) |
| Gunner | Envenom | Blightshot (4★; 187.png) → Toxic Shot (5★; 188.png) |
| Gunner | Pin Down | Garrett Talon (3★; 079.png) → Garrett the Claw (4★; 080.png) → Garrett the Raider (5★; 613.png) |
| Scout | Demoralize | Greyson the Shifty (3★; 101.png) → Greyson the Shrewd (4★; 102.png) |
| Fighter | Sunder Armour | LDF Swordwielder (3★; 075.png) → LDF Greatsword (4★; 076.png) → LDF Mastersword (5★; 609.png) |
| Mage | Contagion | Macabre Embalmer (3★; 093.png) → Macabre Undertaker (4★; 094.png) |
| Fighter | Sundering Smash | Bartok Loco (4★; 195.png) → Derailed Bartok (5★; 196.png) |
| Mage | Fireball | Raging Dragon (3★; 105.png) → Blazing Dragon (4★; 106.png) |
| Defender | Grit | Pub Barman (3★; 061.png) → Pub Landlord (4★; 062.png) |
| Priest | Lifestream | The Witch Doctor (5★; 203.png) → The Earth Whisperer (6★; 204.png) |
| Gunner | Cannon Barrage | Crewman Basilic (4★; 259.png) → Captain Basilic (5★; 260.png) |
| Fighter | Slash Speed | Clair (5★; 429.png) → Awoken Clair (6★; 430.png) |
| Fighter | Galatine's Ground | Gawain the Just (5★; 707.png) → Sir Gawain (6★; 708.png) |
| Priest | Trisha's Prospect | Van Hohenheim (5★; 865.png) → The Sorcerer's Stone (6★; 866.png) |
| Fighter | Trisha's Prospect | José (5★; 1199.png) → José Decomposé (6★; 1200.png) |
| Defender | Tag-Team | Furia Rojo (4★; 947.png) → Campeon Rojo (5★; 948.png) |

### Steam

| Class | Secondary skill | Promotion lineage and source art |
|---|---|---|
| Gunner | Bolt | LDF Gunner (2★; 019.png) → LDF Sureshot (3★; 020.png) |
| Mage | Bolt | Trinity Messenger (2★; 033.png) → Trinity Herald (3★; 034.png) |
| Mage | Empower | Naruku the Lookout (4★; 177.png) → Farsight Naruku (5★; 178.png) |
| Scout | Punish | Prison Warden (3★; 089.png) → Prison Guv'nor (4★; 090.png) |
| Gunner | Sunder Armour | LDF Bowgunner (2★; 043.png) → LDF Bolt Slinger (3★; 044.png) |
| Defender | Sundering Smash | Geartron Prototype (4★; 289.png) → Geartron-5000 (5★; 290.png) |
| Gunner | Hopping Mad | Bethany (4★; 787.png) → Bunnybot Bethany (5★; 788.png) |
| Defender | Shield Wall | Commune Defender (3★; 073.png) → Commune Captain (4★; 074.png) → Commune Commander (5★; 607.png) |
| Defender | Protect | LDF Constable (2★; 037.png) → LDF Sergeant (3★; 038.png) |
| Fighter | Grit | The Archaeologist (4★; 521.png) → The Castaway (5★; 522.png) |
| Defender | Impairing Joust | The Rook (5★; 241.png) → Sterling Knight (6★; 242.png) |
| Defender | Ambient Pressure | Deep Sea Barney (4★; 253.png) → Bulkhead Barney (5★; 254.png) |
| Priest | Mighty Guard | White Mage (5★; 435.png) → White Wizard (6★; 436.png) |
| Defender | Cattle of Ra | Ra (5★; 1011.png) → Ra, Creator (6★; 1012.png) |
| Priest | Woolen Blanket | Jimimi the Shepherd (4★; 263.png) → Jimimi the Herder (5★; 264.png) |
| Mage | Woolen Blanket | Hookie (4★; 321.png) → Beautifly Hookie (5★; 322.png) |
| Defender | Woolen Blanket | Winter Harding (4★; 567.png) → Happy Elf Harding (5★; 568.png) |
| Scout | Shadowbind | Explorer Gatling (5★; 1053.png) → Raider Gatling (6★; 1054.png) |
| Priest | Inspire Lambkin | Flame Warden (3★; 107.png) → Flame Dissident (4★; 108.png) → Flame Schematic (5★; 633.png) |

### Wind

| Class | Secondary skill | Promotion lineage and source art |
|---|---|---|
| Scout | Pinning Slice | Talon Scratcher (3★; 077.png) → Talon Slasher (4★; 078.png) → Talon Slicer (5★; 611.png) |
| Gunner | Pinning Slice | Innocent Gretel (4★; 535.png) → Witchkiller Gretel (5★; 536.png) |
| Mage | Envenom | Frog-Hopper Keru (4★; 165.png) → Lizard-Licker Keru (5★; 166.png) |
| Priest | Demoralize | Communicator Ripley (4★; 167.png) → The Telecommunicator (5★; 168.png) |
| Fighter | Punish | LDF Flight Officer (2★; 027.png) → LDF Flight Commander (3★; 028.png) |
| Fighter | Poison Strike | Claw Chopper (2★; 039.png) → Claw Cleaver (3★; 040.png) |
| Gunner | Big Game Hunter | Haven Trapper (2★; 031.png) → Haven Huntsman (3★; 032.png) |
| Scout | Weakening Strike | Mata Swiftblade (4★; 149.png) → Swiftblade Heroine (5★; 150.png) |
| Defender | Protect | Joe Wonder (3★; 097.png) → Pompous Joe Wonder (4★; 098.png) |
| Scout | Pincer Drain | Cara Pace (4★; 363.png) → Clawing Cara (5★; 364.png) |
| Mage | Ocean's Reclaim | Steph Lopod (5★; 462.png) → Steph the Tentacled (6★; 463.png) |
| Defender | Tide Turn | Ant Lantis (4★; 643.png) → Swelling Ant (5★; 644.png) |
| Mage | None | Sakuya (Fantail Pigeon) (1★; 1025.png) → Sakuya Le Bel Shirogane (6★; 1026.png) |
| Fighter | Royal Flush | Philippa Trot (4★; 979.png) → Galloping Philippa (5★; 980.png) |
| Scout | Roguish Snare | Thief (5★; 597.png) → Cutpurse (6★; 598.png) |
| Priest | Roguish Snare | Present Verdandi (5★; 965.png) → Verdandi Norn (6★; 966.png) |
| Gunner | Wrangle | Frontier Rider (5★; 295.png) → Frontier Protector (6★; 296.png) |
| Scout | Shadowbind | Edge (5★; 693.png) → Ninja Edge (6★; 694.png) |
| Priest | Inspire Lambkin | Claw Minstrel (2★; 035.png) → Claw Rocker (3★; 036.png) |

### Fusion

| Class | Secondary skill | Promotion lineage and source art |
|---|---|---|
| Defender | Fortify | Apprentice Builder (2★; 013.png) → Master Builder (3★; 014.png) |
| Scout | Heaven's Wrath | Order Apostle (2★; 029.png) → Order Missionary (3★; 030.png) |
| Priest | Fortify | Minerva the Brave (3★; 083.png) → Minerva the Lionheart (4★; 084.png) |
| Fighter | Bolt | Whirling Ragnr (4★; 423.png) → Macewielder Ragnr (5★; 424.png) |
| Scout | Misfortune | Street Urchin (2★; 041.png) → Street Hoodlum (3★; 042.png) |
| Defender | Mend | Captain Kerryson (3★; 085.png) → Kerryson the Stoic (4★; 086.png) |
| Gunner | Pin Down | Precision Shooter (3★; 103.png) → Precision Sniper (4★; 104.png) → Precision Trigger (5★; 629.png) |
| Fighter | Demoralize | Vicious Pierrot (4★; 183.png) → Pierrot the Deciever (5★; 184.png) |
| Mage | Meteor Barrage | Devout Mage (3★; 081.png) → Devout Warlock (4★; 082.png) |
| Mage | Freeze! | Frost-Kid Kokori (4★; 141.png) → Ice-Prince Kokori (5★; 142.png) |
| Defender | Yield! | Ki (4★; 651.png) → Hammering Ki (5★; 652.png) |
| Gunner | None | Yuuya (Fantail Pigeon) (1★; 1027.png) → Yuuya Sakazaki (6★; 1028.png) |
| Priest | Divine Silence | Lunnain Oracle (5★; 215.png) → Lunnain Divine (6★; 216.png) |
| Mage | Summon Forth | Rydia of Mist (5★; 697.png) → Summoner Rydia (6★; 698.png) |
| Gunner | Summon Forth | Booth (5★; 1123.png) → Booth Kavar (6★; 1124.png) |
| Mage | Stone Gaze | Medusa (5★; 747.png) → Gorgon Medusa (6★; 748.png) |
| Priest | None | Nageki (Mourning Dove) (1★; 1019.png) → Nageki Fujishiro (6★; 1020.png) |
| Mage | Shadowbind | Belladonna (5★; 1153.png) → The Twilight Queen (6★; 1154.png) |
| Mage | Inspire Lambkin | Conjuring Clown (3★; 069.png) → Conjuring Harlequin (4★; 070.png) → Conjuring Jester (5★; 603.png) |

### Solar

| Class | Secondary skill | Promotion lineage and source art |
|---|---|---|
| Mage | Heaven's Wrath | Order Pupil (2★; 021.png) → Order Scholar (3★; 022.png) |
| Priest | Empower | Order Cleric (2★; 023.png) → Order Chaplain (3★; 024.png) |
| Mage | Misfortune | Fortune Teller (3★; 057.png) → Fortune Diviner (4★; 058.png) |
| Priest | Mend | Street Nurse (2★; 047.png) → Street Matron (3★; 048.png) |
| Gunner | Envenom | Dart Shooter (3★; 055.png) → Dart Sharpshooter (4★; 056.png) |
| Scout | Punish | Shakespeare (4★; 487.png) → The Bard (5★; 488.png) |
| Fighter | Moonlight | Final Empress (4★; 887.png) → Awoken Final Empress (5★; 888.png) |
| Priest | Moonlight | Opelle (4★; 1191.png) → Glowing Opelle (5★; 1192.png) |
| Fighter | Warrior's Vigour | Royal Yeoman (3★; 087.png) → Royal Beefeater (4★; 088.png) |
| Priest | Prune | The Botanist (3★; 071.png) → The Ecologist (4★; 072.png) → The Biologist (5★; 605.png) |
| Priest | Medic! | Rescue Corps (3★; 095.png) → Rescue Paramedic (4★; 096.png) |
| Defender | Medic! | Fabulous Bors (4★; 715.png) → Sir Bors (5★; 716.png) |
| Scout | New Look | Selina the Stylist (4★; 137.png) → Selina Twinblade (5★; 138.png) |
| Defender | Caber Toss | Hamish Highlander (4★; 231.png) → Hamish Lochmaster (5★; 232.png) |
| Priest | Guard | Oro the Pilgrim (5★; 275.png) → Oro the Enlightened (6★; 276.png) |
| Mage | Blossom's Bloom | Sakura (5★; 791.png) → Blossom Sakura (6★; 792.png) |
| Priest | Sun Festival | Inti Chihuan (5★; 825.png) → Shining Inti (6★; 826.png) |
| Defender | Royal Flush | Three of Hearts (4★; 325.png) → Ace of Hearts (5★; 326.png) |
| Gunner | Hydroblast | The Aquanaut (5★; 127.png) → The Hydronaut (6★; 128.png) |

### Universal

| Class | Secondary skill | Promotion lineage and source art |
|---|---|---|
| Scout | None | Trinity Rusher (1★; 003.png) |
| Scout | None | Claw Slicer (1★; 009.png) |
| Fighter | None | Pub Bouncer (1★; 002.png) |
| Fighter | None | Trinity Basher (1★; 008.png) |
| Defender | None | Socialite Fencer (1★; 001.png) |
| Defender | None | LDF Peacekeeper (1★; 007.png) |
| Gunner | None | Trinity Potshot (1★; 004.png) |
| Gunner | None | Factory Markswoman (1★; 010.png) |
| Mage | None | Claw Caster (1★; 005.png) |
| Mage | None | Rage Spellslinger (1★; 011.png) |
| Priest | None | Chain Initiate (1★; 006.png) |
| Priest | None | LDF Medic (1★; 012.png) |

## Unclassified source art

The following 35 numeric source images have no entry in the active catalog and remain unassigned:

025.png, 026.png, 455.png, 466.png, 799.png, 800.png, 801.png, 802.png, 803.png, 804.png, 805.png, 806.png, 807.png, 808.png, 809.png, 820.png, 821.png, 899.png, 900.png, 901.png, 909.png, 911.png, 912.png, 913.png, 914.png, 919.png, 920.png, 1000.png, 1067.png, 1068.png, 1069.png, 1070.png, 1071.png, 1072.png, 1083.png

The 001-bak.png file is a backup of the Universal 001.png source and is stored with Universal rather than treated as another unit.

## Rebalancing checklist

When changing an assignment:

1. Move the entire promotion lineage, never one promotion tier.
2. Keep all six classes represented in the destination and source factions.
3. Recheck total units, 5–6-star counts, star totals, and the affinity-class plurality.
4. Move both the PNG and its matching .png.import file.
5. Keep the art filename unchanged so UnitCatalog.art_id() remains valid.

