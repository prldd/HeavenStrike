# Unit Faction and Sprite Staging Reference

This document is the authoritative balancing reference for the full-body sprite redesign. It records the assigned faction or neutral pool of every active promotion lineage and the source art staged under `assets/units/full_by_class/<Pool>/<Class>/`. Use `assets/IMAGEPROMPTS.md` for the matching general, pool, and class generation blocks. The live game continues to load `assets/units/full/` until the replacement sprites are complete.

## Pool and class alignment

| Pool | Primary class | Internal class folder |
|---|---|---|
| Universal | Fighter | Duelist |
| Steam | Defender | Warden |
| Wind | Scout | Strider |
| Coal | Gunner | Artillerist |
| Fusion | Mage | Channeler |
| Solar | Priest | Lifebinder |

Universal is the neutral sixth pool, not a political faction. Its Fighter affinity resolves the six-class/five-faction mismatch.

## Allocation rules

- Every pool contains at least two units in every class.
- Each pool's affinity class is its largest class group and contains many of that class's strongest promotion lineages.
- A promotion lineage is indivisible. Every promotion remains in the same pool and class folder as its base unit.
- The twelve standalone 1-star, skill-less base units remain Universal and available to every faction.
- Sakuya, Yuuya, and Nageki begin skill-less but promote into skilled units, so each remains in its assigned pool with its full lineage.
- Filenames are authoritative art IDs, not project icon IDs. Generated replacements must retain the exact PNG filename.
- Unknown source images that are not referenced by the active 210-unit catalog remain flat in Unclassified.

## Balance snapshot

| Pool | Defender | Fighter | Scout | Gunner | Mage | Priest | Total | 5–6 star | Star total | Avg. stars |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Coal | 4 | 2 | 4 | 14 | 6 | 5 | 35 | 14 | 143 | 4.09 |
| Steam | 15 | 2 | 4 | 4 | 4 | 6 | 35 | 15 | 146 | 4.17 |
| Wind | 4 | 2 | 13 | 4 | 6 | 6 | 35 | 16 | 144 | 4.11 |
| Fusion | 4 | 2 | 4 | 4 | 15 | 6 | 35 | 15 | 144 | 4.11 |
| Solar | 6 | 2 | 2 | 4 | 4 | 17 | 35 | 15 | 146 | 4.17 |
| Universal | 4 | 21 | 2 | 2 | 4 | 2 | 35 | 12 | 112 | 3.20 |

All six pools contain exactly 35 active units. The five political factions are tightly balanced at 143–146 total stars. Universal's lower average is intentional because it includes all twelve 1-star base units.

### Affinity strength anchors

- Universal Fighters: LDF Mastersword, Awoken Clair, Sir Gawain, José Decomposé, and Derailed Bartok.
- Coal Gunners: The Hydronaut, Frontier Protector, Booth Kavar, Yuuya Sakazaki, Garrett the Raider, and Precision Trigger.
- Steam Defenders: Sterling Knight, Ra, Creator, Commune Commander, Geartron-5000, and Bulkhead Barney.
- Wind Scouts: Cutpurse, Ninja Edge, Raider Gatling, Talon Slicer, and Clawing Cara.
- Fusion Mages: Summoner Rydia, Gorgon Medusa, The Twilight Queen, Conjuring Jester, and Ice-Prince Kokori.
- Solar Priests: The Earth Whisperer, Oro the Enlightened, Shining Inti, The Sorcerer's Stone, and The Biologist.

## Folder contract

~~~text
assets/units/full_by_class/
├── Coal/
│   ├── Warden/
│   ├── Duelist/
│   ├── Strider/
│   ├── Artillerist/
│   ├── Channeler/
│   └── Lifebinder/
├── Steam/              # Same six class subfolders
├── Wind/               # Same six class subfolders
├── Fusion/             # Same six class subfolders
├── Solar/              # Same six class subfolders
├── Universal/          # Same six class subfolders
└── Unclassified/       # No active catalog identity; remains flat
~~~

Each active PNG and its matching .png.import file live together. The 001-bak.png reference is stored in Universal/Warden/ beside 001.png.

## Lineage assignments

### Coal

| Class | Secondary skill | Promotion lineage and source art |
|---|---|---|
| Defender (Warden) | Grit | Pub Barman (3★; 061.png) → Pub Landlord (4★; 062.png) |
| Defender (Warden) | Tag-Team | Furia Rojo (4★; 947.png) → Campeon Rojo (5★; 948.png) |
| Fighter (Duelist) | Empower | Rage Brute (2★; 015.png) → Rage Bruiser (3★; 016.png) |
| Scout (Strider) | Pinning Strike | Claw Skirmisher (2★; 017.png) → Claw Ambusher (3★; 018.png) |
| Scout (Strider) | Demoralize | Greyson the Shifty (3★; 101.png) → Greyson the Shrewd (4★; 102.png) |
| Gunner (Artillerist) | Pin Down | Garrett Talon (3★; 079.png) → Garrett the Claw (4★; 080.png) → Garrett the Raider (5★; 613.png) |
| Gunner (Artillerist) | Pin Down | Precision Shooter (3★; 103.png) → Precision Sniper (4★; 104.png) → Precision Trigger (5★; 629.png) |
| Gunner (Artillerist) | None | Yuuya (Fantail Pigeon) (1★; 1027.png) → Yuuya Sakazaki (6★; 1028.png) |
| Gunner (Artillerist) | Hydroblast | The Aquanaut (5★; 127.png) → The Hydronaut (6★; 128.png) |
| Gunner (Artillerist) | Wrangle | Frontier Rider (5★; 295.png) → Frontier Protector (6★; 296.png) |
| Gunner (Artillerist) | Summon Forth | Booth (5★; 1123.png) → Booth Kavar (6★; 1124.png) |
| Mage (Channeler) | Contagion | Macabre Embalmer (3★; 093.png) → Macabre Undertaker (4★; 094.png) |
| Mage (Channeler) | Fireball | Raging Dragon (3★; 105.png) → Blazing Dragon (4★; 106.png) |
| Mage (Channeler) | Woolen Blanket | Hookie (4★; 321.png) → Beautifly Hookie (5★; 322.png) |
| Priest (Lifebinder) | Mighty Guard | White Mage (5★; 435.png) → White Wizard (6★; 436.png) |
| Priest (Lifebinder) | Inspire Lambkin | Flame Warden (3★; 107.png) → Flame Dissident (4★; 108.png) → Flame Schematic (5★; 633.png) |

### Steam

| Class | Secondary skill | Promotion lineage and source art |
|---|---|---|
| Defender (Warden) | Sundering Smash | Geartron Prototype (4★; 289.png) → Geartron-5000 (5★; 290.png) |
| Defender (Warden) | Shield Wall | Commune Defender (3★; 073.png) → Commune Conductor (4★; 074.png) → Commune Commander (5★; 607.png) |
| Defender (Warden) | Protect | LDF Constable (2★; 037.png) → LDF Sergeant (3★; 038.png) |
| Defender (Warden) | Impairing Joust | The Rook (5★; 241.png) → Sterling Knight (6★; 242.png) |
| Defender (Warden) | Ambient Pressure | Deep Sea Barney (4★; 253.png) → Bulkhead Barney (5★; 254.png) |
| Defender (Warden) | Cattle of Ra | Ra (5★; 1011.png) → Ra, Creator (6★; 1012.png) |
| Defender (Warden) | Woolen Blanket | Winter Harding (4★; 567.png) → Happy Elf Harding (5★; 568.png) |
| Fighter (Duelist) | Warrior's Vigour | Royal Yeoman (3★; 087.png) → Royal Beefeater (4★; 088.png) |
| Scout (Strider) | Misfortune | Street Urchin (2★; 041.png) → Street Hoodlum (3★; 042.png) |
| Scout (Strider) | Punish | Prison Warden (3★; 089.png) → Prison Guv'nor (4★; 090.png) |
| Gunner (Artillerist) | Sunder Armour | LDF Bowgunner (2★; 043.png) → LDF Bolt Slinger (3★; 044.png) |
| Gunner (Artillerist) | Hopping Mad | Bethany (4★; 787.png) → Bunnybot Bethany (5★; 788.png) |
| Mage (Channeler) | Empower | Naruku the Lookout (4★; 177.png) → Farsight Naruku (5★; 178.png) |
| Mage (Channeler) | Blossom's Bloom | Sakura (5★; 791.png) → Blossom Sakura (6★; 792.png) |
| Priest (Lifebinder) | Plague | Blight Doctor (3★; 059.png) → Blight Physician (4★; 060.png) |
| Priest (Lifebinder) | Roguish Snare | Present Verdandi (5★; 965.png) → Verdandi Norn (6★; 966.png) |
| Priest (Lifebinder) | Woolen Blanket | Jimimi the Shepherd (4★; 263.png) → Jimimi the Herder (5★; 264.png) |

### Wind

| Class | Secondary skill | Promotion lineage and source art |
|---|---|---|
| Defender (Warden) | Protect | Joe Wonder (3★; 097.png) → Pompous Joe Wonder (4★; 098.png) |
| Defender (Warden) | Tide Turn | Ant Lantis (4★; 643.png) → Swelling Ant (5★; 644.png) |
| Fighter (Duelist) | Punish | LDF Flight Officer (2★; 027.png) → LDF Flight Commander (3★; 028.png) |
| Scout (Strider) | Pinning Slice | Talon Scratcher (3★; 077.png) → Talon Slasher (4★; 078.png) → Talon Slicer (5★; 611.png) |
| Scout (Strider) | Weakening Strike | Mata Swiftblade (4★; 149.png) → Swiftblade Heroine (5★; 150.png) |
| Scout (Strider) | Pincer Drain | Cara Pace (4★; 363.png) → Clawing Cara (5★; 364.png) |
| Scout (Strider) | Roguish Snare | Thief (5★; 597.png) → Cutpurse (6★; 598.png) |
| Scout (Strider) | Shadowbind | Edge (5★; 693.png) → Ninja Edge (6★; 694.png) |
| Scout (Strider) | Shadowbind | Explorer Gatling (5★; 1053.png) → Raider Gatling (6★; 1054.png) |
| Gunner (Artillerist) | Pinning Slice | Innocent Gretel (4★; 535.png) → Witchkiller Gretel (5★; 536.png) |
| Gunner (Artillerist) | Big Game Hunter | Haven Trapper (2★; 031.png) → Haven Huntsman (3★; 032.png) |
| Mage (Channeler) | Envenom | Frog-Hopper Keru (4★; 165.png) → Lizard-Licker Keru (5★; 166.png) |
| Mage (Channeler) | Ocean's Reclaim | Steph Lopod (5★; 462.png) → Steph the Tentacled (6★; 463.png) |
| Mage (Channeler) | None | Sakuya (Fantail Pigeon) (1★; 1025.png) → Sakuya Le Bel Shirogane (6★; 1026.png) |
| Priest (Lifebinder) | Empower | Order Cleric (2★; 023.png) → Order Chaplain (3★; 024.png) |
| Priest (Lifebinder) | Demoralize | Communicator Ripley (4★; 167.png) → The Telecommunicator (5★; 168.png) |
| Priest (Lifebinder) | Inspire Lambkin | Claw Minstrel (2★; 035.png) → Claw Rocker (3★; 036.png) |

### Fusion

| Class | Secondary skill | Promotion lineage and source art |
|---|---|---|
| Defender (Warden) | Mend | Conductor Kerryson (3★; 085.png) → Kerryson the Stoic (4★; 086.png) |
| Defender (Warden) | Yield! | Ki (4★; 651.png) → Hammering Ki (5★; 652.png) |
| Fighter (Duelist) | Demoralize | Vicious Pierrot (4★; 183.png) → Pierrot the Deciever (5★; 184.png) |
| Scout (Strider) | Heaven's Wrath | Order Apostle (2★; 029.png) → Order Missionary (3★; 030.png) |
| Scout (Strider) | Punish | Shakespeare (4★; 487.png) → The Bard (5★; 488.png) |
| Gunner (Artillerist) | Bolt | LDF Gunner (2★; 019.png) → LDF Sureshot (3★; 020.png) |
| Gunner (Artillerist) | Cannon Barrage | Crewman Basilic (4★; 259.png) → Conductor Basilic (5★; 260.png) |
| Mage (Channeler) | Misfortune | LDF Crowd Mage (2★; 045.png) → LDF Riot Mage (3★; 046.png) |
| Mage (Channeler) | Meteor Barrage | Devout Mage (3★; 081.png) → Devout Warlock (4★; 082.png) |
| Mage (Channeler) | Freeze! | Frost-Kid Kokori (4★; 141.png) → Ice-Prince Kokori (5★; 142.png) |
| Mage (Channeler) | Summon Forth | Rydia of Mist (5★; 697.png) → Summoner Rydia (6★; 698.png) |
| Mage (Channeler) | Stone Gaze | Medusa (5★; 747.png) → Gorgon Medusa (6★; 748.png) |
| Mage (Channeler) | Shadowbind | Belladonna (5★; 1153.png) → The Twilight Queen (6★; 1154.png) |
| Mage (Channeler) | Inspire Lambkin | Conjuring Clown (3★; 069.png) → Conjuring Harlequin (4★; 070.png) → Conjuring Jester (5★; 603.png) |
| Priest (Lifebinder) | Fortify | Minerva the Brave (3★; 083.png) → Minerva the Lionheart (4★; 084.png) |
| Priest (Lifebinder) | Divine Silence | Lunnain Oracle (5★; 215.png) → Lunnain Divine (6★; 216.png) |
| Priest (Lifebinder) | None | Nageki (Mourning Dove) (1★; 1019.png) → Nageki Fujishiro (6★; 1020.png) |

### Solar

| Class | Secondary skill | Promotion lineage and source art |
|---|---|---|
| Defender (Warden) | Medic! | Fabulous Bors (4★; 715.png) → Sir Bors (5★; 716.png) |
| Defender (Warden) | Caber Toss | Hamish Highlander (4★; 231.png) → Hamish Lochmaster (5★; 232.png) |
| Defender (Warden) | Royal Flush | Three of Hearts (4★; 325.png) → Ace of Hearts (5★; 326.png) |
| Fighter (Duelist) | Poison Strike | Claw Chopper (2★; 039.png) → Claw Cleaver (3★; 040.png) |
| Scout (Strider) | New Look | Selina the Stylist (4★; 137.png) → Selina Twinblade (5★; 138.png) |
| Gunner (Artillerist) | Envenom | Dart Shooter (3★; 055.png) → Dart Sharpshooter (4★; 056.png) |
| Gunner (Artillerist) | Envenom | Blightshot (4★; 187.png) → Toxic Shot (5★; 188.png) |
| Mage (Channeler) | Bolt | Trinity Messenger (2★; 033.png) → Trinity Herald (3★; 034.png) |
| Mage (Channeler) | Misfortune | Fortune Teller (3★; 057.png) → Fortune Diviner (4★; 058.png) |
| Priest (Lifebinder) | Mend | Street Nurse (2★; 047.png) → Street Matron (3★; 048.png) |
| Priest (Lifebinder) | Moonlight | Opelle (4★; 1191.png) → Glowing Opelle (5★; 1192.png) |
| Priest (Lifebinder) | Prune | The Botanist (3★; 071.png) → The Ecologist (4★; 072.png) → The Biologist (5★; 605.png) |
| Priest (Lifebinder) | Medic! | Rescue Corps (3★; 095.png) → Rescue Paramedic (4★; 096.png) |
| Priest (Lifebinder) | Lifestream | The Witch Doctor (5★; 203.png) → The Earth Whisperer (6★; 204.png) |
| Priest (Lifebinder) | Guard | Oro the Pilgrim (5★; 275.png) → Oro the Enlightened (6★; 276.png) |
| Priest (Lifebinder) | Sun Festival | Inti Chihuan (5★; 825.png) → Shining Inti (6★; 826.png) |
| Priest (Lifebinder) | Trisha's Prospect | Van Hohenheim (5★; 865.png) → The Sorcerer's Stone (6★; 866.png) |

### Universal

| Class | Secondary skill | Promotion lineage and source art |
|---|---|---|
| Defender (Warden) | None | Socialite Fencer (1★; 001.png) |
| Defender (Warden) | None | LDF Peacekeeper (1★; 007.png) |
| Defender (Warden) | Fortify | Apprentice Builder (2★; 013.png) → Master Builder (3★; 014.png) |
| Fighter (Duelist) | None | Pub Bouncer (1★; 002.png) |
| Fighter (Duelist) | None | Trinity Basher (1★; 008.png) |
| Fighter (Duelist) | Bolt | Whirling Ragnr (4★; 423.png) → Macewielder Ragnr (5★; 424.png) |
| Fighter (Duelist) | Sunder Armour | LDF Swordwielder (3★; 075.png) → LDF Greatsword (4★; 076.png) → LDF Mastersword (5★; 609.png) |
| Fighter (Duelist) | Sundering Smash | Bartok Loco (4★; 195.png) → Derailed Bartok (5★; 196.png) |
| Fighter (Duelist) | Moonlight | Final Empress (4★; 887.png) → Awoken Final Empress (5★; 888.png) |
| Fighter (Duelist) | Grit | The Archaeologist (4★; 521.png) → The Castaway (5★; 522.png) |
| Fighter (Duelist) | Slash Speed | Clair (5★; 429.png) → Awoken Clair (6★; 430.png) |
| Fighter (Duelist) | Galatine's Ground | Gawain the Just (5★; 707.png) → Sir Gawain (6★; 708.png) |
| Fighter (Duelist) | Trisha's Prospect | José (5★; 1199.png) → José Decomposé (6★; 1200.png) |
| Fighter (Duelist) | Royal Flush | Philippa Trot (4★; 979.png) → Galloping Philippa (5★; 980.png) |
| Scout (Strider) | None | Trinity Rusher (1★; 003.png) |
| Scout (Strider) | None | Claw Slicer (1★; 009.png) |
| Gunner (Artillerist) | None | Trinity Potshot (1★; 004.png) |
| Gunner (Artillerist) | None | Factory Markswoman (1★; 010.png) |
| Mage (Channeler) | None | Claw Caster (1★; 005.png) |
| Mage (Channeler) | None | Rage Spellslinger (1★; 011.png) |
| Mage (Channeler) | Heaven's Wrath | Order Pupil (2★; 021.png) → Order Scholar (3★; 022.png) |
| Priest (Lifebinder) | None | Chain Initiate (1★; 006.png) |
| Priest (Lifebinder) | None | LDF Medic (1★; 012.png) |

## Unclassified source art

The following 35 numeric source images have no entry in the active catalog and remain unassigned:

025.png, 026.png, 455.png, 466.png, 799.png, 800.png, 801.png, 802.png, 803.png, 804.png, 805.png, 806.png, 807.png, 808.png, 809.png, 820.png, 821.png, 899.png, 900.png, 901.png, 909.png, 911.png, 912.png, 913.png, 914.png, 919.png, 920.png, 1000.png, 1067.png, 1068.png, 1069.png, 1070.png, 1071.png, 1072.png, 1083.png

The 001-bak.png file is a backup of the Universal Defender source 001.png and is not another unit.

## Rebalancing checklist

When changing an assignment:

1. Move the entire promotion lineage, never one promotion tier.
2. Keep at least two units of every class in every pool.
3. Preserve the affinity-class plurality and its strongest anchor lineages.
4. Recheck total units, 5–6-star counts, star totals, and average rarity.
5. Move both the PNG and its matching `.png.import` file into `<Pool>/<Class>/`.
6. Keep the art filename unchanged so `UnitCatalog.art_id()` remains valid.
