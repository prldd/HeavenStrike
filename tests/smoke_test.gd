extends SceneTree

const UnitCatalogScript = preload("res://scripts/unit_catalog.gd")
const MissionUnitCatalogScript = preload("res://scripts/mission_unit_catalog.gd")
const BattleSimulatorScript = preload("res://scripts/battle_simulator.gd")
const BattleResultsScript = preload("res://scripts/battle_results.gd")
const MissionRulesScript = preload("res://scripts/mission_rules.gd")
const BattleAIScript = preload("res://scripts/battle_ai.gd")
const SquadStoreScript = preload("res://scripts/squad_store.gd")
const CampaignStoreScript = preload("res://scripts/campaign_store.gd")
const BattleRulesScript = preload("res://scripts/battle_rules.gd")
const ConductorSkillsScript = preload("res://scripts/conductor_skills.gd")
const UnitSkillsScript = preload("res://scripts/unit_skills.gd")
const KineticCrucibleScript = preload("res://scripts/kinetic_crucible.gd")
const GachaStoreScript = preload("res://scripts/gacha_store.gd")
const RequisitionStoreScript = preload("res://scripts/requisition_store.gd")
const ChallengeCatalogScript = preload("res://scripts/challenge_catalog.gd")
const ChallengeStoreScript = preload("res://scripts/challenge_store.gd")
const StoryDialogueCatalogScript = preload("res://scripts/story_dialogue_catalog.gd")
const MissionRunStoreScript = preload("res://scripts/mission_run_store.gd")
const LegacyContentMigrationScript = preload("res://scripts/legacy_content_migration.gd")

func _init() -> void:
	var roster: Array = UnitCatalogScript.all_units()
	assert(roster.size() == 292, "The playable roster must contain 292 units.")
	var mission_units: Array = MissionUnitCatalogScript.all_units()
	assert(mission_units.size() == 1)
	var ground_transport: UnitData = mission_units[0]
	assert(ground_transport.name == "Relay Ground Transport-216")
	assert(ground_transport.icon == 216)
	assert(ground_transport.kind == "Transport")
	assert(ground_transport.cost == 0)
	assert(ground_transport.atk == 1)
	assert(ground_transport.hp == 18)
	assert(ground_transport.move == 0)
	assert(ground_transport.range == 1)
	assert(MissionUnitCatalogScript.by_name("Missing") == null)
	var original_name_pattern := RegEx.new()
	assert(original_name_pattern.compile(
		"^(Relay|Cinder|Brass|Zephyr|Flux|Helio) (Lancer|Blade|Bastion|Battery|Weaver|Mender)-[0-9]{3}$"
	) == OK)
	assert(roster.all(func(unit): return original_name_pattern.search(unit.name) != null))
	assert(UnitCatalogScript.by_name("Relay Lancer-003").kind == "Strider")
	assert(UnitCatalogScript.display_class("Strider") == "Scout")
	assert(UnitCatalogScript.display_class("Lifebinder") == "Priest")
	assert(UnitCatalogScript.class_color("Strider") != UnitCatalogScript.class_color("Duelist"))
	assert(UnitCatalogScript.class_color("Warden") != UnitCatalogScript.class_color("Lifebinder"))
	assert(UnitCatalogScript.by_name("Missing") == null)
	var retired_rank_word := "Cap" + "tain"
	assert(roster.all(func(unit): return retired_rank_word.to_lower() not in unit.name.to_lower()))
	assert(UnitCatalogScript.canonical_name(retired_rank_word + " Kerryson") == "Flux Bastion-053")
	assert(UnitCatalogScript.canonical_name("Commune " + retired_rank_word) == "Brass Bastion-105")
	assert(UnitCatalogScript.by_name(retired_rank_word + " Basilic").name == "Flux Battery-141")
	assert(SquadStoreScript.sanitize(
		[retired_rank_word + " Kerryson"], roster
	) == ["Flux Bastion-053"])
	assert(LegacyContentMigrationScript.UNIT_NAME_HASH_ALIASES.size() == 210)
	var retired_roster_name := "Tri" + "nity Rusher"
	assert(UnitCatalogScript.canonical_name(retired_roster_name) == "Relay Lancer-003")
	var retired_skill_key := retired_rank_word.to_lower() + "_skill"
	var retired_hp_key := retired_rank_word.to_lower() + "_hp"
	var old_player_config := ConfigFile.new()
	old_player_config.set_value("squad", retired_skill_key, "Shield")
	assert(old_player_config.save(SquadStoreScript.SAVE_PATH) == OK)
	assert(SquadStoreScript.load_conductor_skill(ConductorSkillsScript.SKILLS) == "Shield")
	var migrated_player_config := ConfigFile.new()
	assert(migrated_player_config.load(SquadStoreScript.SAVE_PATH) == OK)
	assert(migrated_player_config.get_value("squad", "conductor_skill", "") == "Shield")
	assert(not migrated_player_config.has_section_key("squad", retired_skill_key))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(SquadStoreScript.SAVE_PATH))
	assert(SquadStoreScript.save_conductor_skill("Rally", ConductorSkillsScript.SKILLS))
	var clean_player_config := ConfigFile.new()
	assert(clean_player_config.load(SquadStoreScript.SAVE_PATH) == OK)
	assert(clean_player_config.get_value("squad", "conductor_skill", "") == "Rally")
	assert(not clean_player_config.has_section_key("squad", retired_skill_key))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(SquadStoreScript.SAVE_PATH))
	var old_run_config := ConfigFile.new()
	old_run_config.set_value("run", "mission_id", 2)
	old_run_config.set_value("run", "encounter_index", 1)
	old_run_config.set_value("run", retired_hp_key, 13)
	assert(old_run_config.save(MissionRunStoreScript.SAVE_PATH) == OK)
	var migrated_run := MissionRunStoreScript.load_run(77)
	assert(migrated_run.conductor_hp == 13)
	assert(not migrated_run.autobattle)
	var migrated_run_config := ConfigFile.new()
	assert(migrated_run_config.load(MissionRunStoreScript.SAVE_PATH) == OK)
	assert(migrated_run_config.get_value("run", "conductor_hp", 0) == 13)
	assert(not migrated_run_config.has_section_key("run", retired_hp_key))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(MissionRunStoreScript.SAVE_PATH))
	assert(MissionRunStoreScript.save_run(4, 1, 12, true))
	var automated_run := MissionRunStoreScript.load_run(77)
	assert(automated_run.autobattle)
	assert(automated_run.mission_id == 4 and automated_run.encounter_index == 1)
	DirAccess.remove_absolute(ProjectSettings.globalize_path(MissionRunStoreScript.SAVE_PATH))
	var old_campaign_config := ConfigFile.new()
	old_campaign_config.set_value("campaign", "reward_units", [
		retired_rank_word + " Kerryson", "Commune " + retired_rank_word
	])
	assert(old_campaign_config.save(CampaignStoreScript.SAVE_PATH) == OK)
	assert(CampaignStoreScript.load_reward_units(roster) == [
		"Flux Bastion-053", "Brass Bastion-105"
	])
	DirAccess.remove_absolute(ProjectSettings.globalize_path(CampaignStoreScript.SAVE_PATH))
	var old_crucible_config := ConfigFile.new()
	old_crucible_config.set_value("meta", "instances_migrated", true)
	old_crucible_config.set_value("collection", "next_id", 2)
	old_crucible_config.set_value("collection", "instances", [{
		"id": "unit_000001", "name": retired_rank_word + " Basilic",
		"level": 2, "points": 1, "consumed": false
	}])
	assert(old_crucible_config.save(KineticCrucibleScript.SAVE_PATH) == OK)
	var migrated_instances := KineticCrucibleScript.sync_instances(
		roster, {"Flux Battery-141": 1}
	)
	assert(migrated_instances.size() == 1)
	assert(migrated_instances[0].name == "Flux Battery-141")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(KineticCrucibleScript.SAVE_PATH))
	var old_shared_progress := ConfigFile.new()
	old_shared_progress.set_value("meta", "instances_migrated", false)
	old_shared_progress.set_value("collection", "next_id", 1)
	old_shared_progress.set_value("collection", "instances", [])
	old_shared_progress.set_value(
		"progress", retired_roster_name, {"level": 3, "points": 2}
	)
	assert(old_shared_progress.save(KineticCrucibleScript.SAVE_PATH) == OK)
	var shared_progress_instances := KineticCrucibleScript.sync_instances(
		roster, {"Relay Lancer-003": 1}
	)
	assert(shared_progress_instances.size() == 1)
	assert(shared_progress_instances[0].name == "Relay Lancer-003")
	assert(shared_progress_instances[0].level == 3)
	assert(shared_progress_instances[0].points == 2)
	DirAccess.remove_absolute(ProjectSettings.globalize_path(KineticCrucibleScript.SAVE_PATH))
	assert(KineticCrucibleScript.LEVEL_COSTS == [3, 6, 12, 24])
	assert(KineticCrucibleScript.apply_points(
		{"level": 1, "points": 0}, 2
	) == {"level": 1, "points": 2})
	assert(KineticCrucibleScript.apply_points(
		{"level": 1, "points": 2}, 1
	) == {"level": 2, "points": 0})
	assert(KineticCrucibleScript.apply_points(
		{"level": 1, "points": 0}, 45
	) == {"level": 5, "points": 0})
	assert(KineticCrucibleScript.merge_value(
		{"name": "A", "kind": "Warden"}, {"name": "B", "kind": "Strider"}
	) == 1)
	assert(KineticCrucibleScript.merge_value(
		{"name": "A", "kind": "Warden"}, {"name": "B", "kind": "Warden"}
	) == 2)
	assert(KineticCrucibleScript.merge_value(
		{"name": "A", "kind": "Warden"}, {"name": "A", "kind": "Warden"}
	) == 5)
	assert(KineticCrucibleScript.progress_points({"level": 1, "points": 2}) == 2)
	assert(KineticCrucibleScript.progress_points({"level": 3, "points": 4}) == 13)
	assert(KineticCrucibleScript.points_to_max({"level": 1, "points": 0}) == 45)
	assert(KineticCrucibleScript.points_to_max({"level": 4, "points": 23}) == 1)
	assert(KineticCrucibleScript.merge_value(
		{"name": "Relay Lancer-003"},
		{"name": "Relay Lancer-003", "level": 2, "points": 1},
		roster
	) == 9)
	var merge_preview := KineticCrucibleScript.merge_preview(
		{
			"id": "target", "name": "Relay Lancer-003",
			"level": 1, "points": 2, "consumed": false
		},
		[{
			"id": "invested_donor", "name": "Relay Lancer-003",
			"level": 2, "points": 1, "consumed": false
		}],
		roster
	)
	assert(merge_preview.progress == {"level": 3, "points": 2})
	assert(merge_preview.offered == 9 and merge_preview.applied == 9)
	assert(merge_preview.overflow == 0 and merge_preview.consumed == 1)
	var capped_preview := KineticCrucibleScript.merge_preview(
		{
			"id": "target", "name": "Relay Lancer-003",
			"level": 4, "points": 23, "consumed": false
		},
		[
			{
				"id": "donor_a", "name": "Relay Lancer-003",
				"level": 1, "points": 0, "consumed": false
			},
			{
				"id": "donor_b", "name": "Relay Lancer-003",
				"level": 1, "points": 0, "consumed": false
			}
		],
		roster
	)
	assert(capped_preview.progress == {"level": 5, "points": 0})
	assert(capped_preview.offered == 5 and capped_preview.applied == 1)
	assert(capped_preview.overflow == 4 and capped_preview.consumed == 1)
	assert(capped_preview.untouched == 1)
	var merge_config := ConfigFile.new()
	merge_config.set_value("meta", "instances_migrated", true)
	merge_config.set_value("collection", "next_id", 4)
	merge_config.set_value("collection", "instances", [
		{
			"id": "target", "name": "Relay Lancer-003",
			"level": 4, "points": 23, "consumed": false
		},
		{
			"id": "donor_a", "name": "Relay Lancer-003",
			"level": 1, "points": 0, "consumed": false
		},
		{
			"id": "donor_b", "name": "Relay Lancer-003",
			"level": 1, "points": 0, "consumed": false
		}
	])
	assert(merge_config.save(KineticCrucibleScript.SAVE_PATH) == OK)
	var merge_result := KineticCrucibleScript.record_merge_batch(
		"target", ["donor_a", "donor_b"], roster, {"Relay Lancer-003": 3}
	)
	assert(merge_result.ok)
	assert(merge_result.gained == 1 and merge_result.overflow == 4)
	assert(merge_result.merged == 1 and merge_result.untouched == 1)
	assert(merge_result.progress == {"level": 5, "points": 0})
	assert(merge_result.message.contains("excess"))
	assert(merge_result.message.contains("left untouched"))
	var merged_instances := KineticCrucibleScript.sync_instances(
		roster, {"Relay Lancer-003": 3}
	)
	assert(KineticCrucibleScript.instance_by_id(
		merged_instances, "donor_a"
	).consumed)
	assert(not KineticCrucibleScript.instance_by_id(
		merged_instances, "donor_b"
	).consumed)
	DirAccess.remove_absolute(ProjectSettings.globalize_path(KineticCrucibleScript.SAVE_PATH))
	var instance_copies: Array = [
		{"id": "copy_a", "name": "Relay Lancer-003", "level": 3, "points": 1, "consumed": false},
		{"id": "copy_b", "name": "Relay Lancer-003", "level": 1, "points": 0, "consumed": false},
		{"id": "copy_c", "name": "Relay Blade-002", "level": 2, "points": 0, "consumed": false}
	]
	assert(KineticCrucibleScript.active_instances(instance_copies).size() == 3)
	assert(KineticCrucibleScript.inventory_counts(instance_copies)["Relay Lancer-003"] == 2)
	var reserve_instances: Array = [
		{"id": "unit_000004", "name": "Relay Weaver-021", "level": 2, "points": 0, "consumed": false},
		{"id": "unit_000002", "name": "Brass Battery-083", "level": 1, "points": 0, "consumed": false},
		{"id": "unit_000007", "name": "Relay Weaver-021", "level": 5, "points": 0, "consumed": false},
		{"id": "unit_000001", "name": "Relay Lancer-003", "level": 1, "points": 0, "consumed": false},
		{"id": "unit_000005", "name": "Relay Weaver-022", "level": 1, "points": 0, "consumed": false},
		{"id": "unit_000006", "name": "Relay Weaver-021", "level": 5, "points": 0, "consumed": false},
		{"id": "unit_000003", "name": "Brass Battery-084", "level": 1, "points": 0, "consumed": false}
	]
	var sorted_reserves := KineticCrucibleScript.sort_reserves(reserve_instances, roster)
	assert(sorted_reserves.map(func(instance): return instance.id) == [
		"unit_000001", # Strider class group first
		"unit_000003", # Artillerist tree: promoted 3-star before 2-star base
		"unit_000002",
		"unit_000005", # Channeler tree: promoted 3-star before base copies
		"unit_000007", # same unit: level 5 before level 2, id descending on ties
		"unit_000006",
		"unit_000004"
	])
	assert(KineticCrucibleScript.can_merge(
		instance_copies[0], instance_copies[1], roster
	))
	assert(KineticCrucibleScript.can_merge(
		instance_copies[0], instance_copies[2], roster
	))
	assert(not KineticCrucibleScript.can_merge(
		instance_copies[0], instance_copies[0], roster
	))
	assert(SquadStoreScript.sanitize_instances(
		["copy_a", "copy_b", "copy_c"], instance_copies
	) == ["copy_a", "copy_b", "copy_c"])
	var instance_deck: Array = SquadStoreScript.build_deck(
		["copy_a", "copy_b", "copy_c"], roster, instance_copies
	)
	assert(instance_deck.size() == 3)
	assert(instance_deck[0].instance_id == "copy_a")
	assert(instance_deck[0].level == 3)
	var simulator := BattleSimulatorScript.new()
	simulator.reset(4242)
	assert(simulator.seed_value == 4242)
	assert(simulator.record("test", {"value": 7}).sequence == 1)
	assert(simulator.replay_data().events.size() == 1)
	assert(simulator.replay_data().seed == 4242)
	var battle_rating := BattleResultsScript.calculate(
		15, 20, 4,
		[
			{"id": 1, "side": 0, "hp": 3},
			{"id": 3, "side": 0, "hp": 2},
			{"id": 9, "side": 1, "hp": 1}
		],
		[
			{"type": "deploy", "side": 0, "unit_id": 1},
			{"type": "deploy", "side": 0, "unit_id": 2},
			{"type": "deploy", "side": 0, "unit_id": 3},
			{"type": "deploy", "side": 1, "unit_id": 9}
		]
	)
	assert(battle_rating.score == 817)
	assert(battle_rating.rating == 9)
	assert(battle_rating.word == "AMAZING")
	assert(battle_rating.survivors == 2 and battle_rating.deployed == 3)
	var flawless_rating := BattleResultsScript.calculate(20, 20, 1, [], [])
	assert(flawless_rating.score == 1000)
	assert(flawless_rating.rating == 10)
	assert(flawless_rating.word == "FLAWLESS")
	var setup_ignored_rating := BattleResultsScript.calculate(
		20, 20, 1,
		[{"id": 90, "side": 0, "hp": 1}],
		[{"type": "deploy", "side": 0, "unit_id": 90, "mission_setup": true}]
	)
	assert(setup_ignored_rating.deployed == 0)
	var replay_history_path := "user://smoke_replay_history.json"
	for replay_seed in range(12):
		simulator.reset(replay_seed)
		simulator.record("test", {"seed": replay_seed})
		assert(simulator.archive_replay(replay_history_path))
	var replay_history := BattleSimulatorScript.load_replay_history(replay_history_path)
	assert(replay_history.size() == 10)
	assert(replay_history[0].seed == 11)
	assert(replay_history[9].seed == 2)
	var damage_target := {"id": 99, "hp": 5, "max_hp": 5}
	assert(BattleSimulatorScript.apply_unit_damage(damage_target, 3).after == 2)
	assert(BattleSimulatorScript.apply_unit_healing(damage_target, 2).after == 4)
	var conductor_state := {
		"player_hp": 20, "enemy_hp": 20,
		"player_shield": 2, "enemy_shield": 0
	}
	var conductor_hit := BattleSimulatorScript.apply_conductor_damage(
		0, 5, conductor_state
	)
	assert(conductor_hit.shield_absorbed == 2)
	assert(conductor_state.player_hp == 17)
	assert(roster.map(func(unit): return unit.icon).all(
		func(icon_id): return icon_id >= 1 and icon_id <= 293 and icon_id != 216
	))
	assert(roster.filter(func(unit): return unit.stars == 1).size() == 15)
	assert(roster.filter(func(unit): return unit.stars == 2).size() == 17)
	assert(roster.filter(func(unit): return unit.stars == 3).size() == 73)
	assert(roster.filter(func(unit): return unit.stars == 4).size() == 86)
	assert(roster.filter(func(unit): return unit.stars == 5).size() == 73)
	assert(roster.filter(func(unit): return unit.stars == 6).size() == 28)
	var icon_ids: Array = roster.map(func(unit): return unit.icon)
	var unique_icon_ids: Array = []
	for icon_id in icon_ids:
		if icon_id not in unique_icon_ids:
			unique_icon_ids.append(icon_id)
	assert(icon_ids.size() == unique_icon_ids.size())
	assert(roster.filter(func(unit): return unit.kind == "Strider").size() == 44)
	assert(roster.filter(func(unit): return unit.kind == "Duelist").size() == 41)
	assert(roster.filter(func(unit): return unit.kind == "Warden").size() == 50)
	assert(roster.filter(func(unit): return unit.kind == "Artillerist").size() == 43)
	assert(roster.filter(func(unit): return unit.kind == "Channeler").size() == 58)
	assert(roster.filter(func(unit): return unit.kind == "Lifebinder").size() == 56)
	assert(UnitCatalogScript.by_name("Relay Bastion-013").stars == 2)
	assert(UnitCatalogScript.by_name("Cinder Blade-015").cost == 2)
	assert(UnitCatalogScript.by_name("Flux Battery-019").range == 3)
	assert(UnitCatalogScript.by_name("Relay Bastion-013").skill.name == "Brace Protocol")
	assert(UnitCatalogScript.by_name("Cinder Lancer-017").skill.type == "Strike")
	assert(UnitCatalogScript.by_name("Flux Lancer-025").skill.name == "Relay Storm")
	assert(UnitCatalogScript.by_name("Helio Weaver-026").skill.name == "Arc Lance")
	assert(UnitCatalogScript.by_name("Flux Mender-027").skill.name == "Brace Protocol")
	assert(UnitCatalogScript.by_name("Brass Weaver-028").skill.name == "Overclock Link")
	assert(UnitCatalogScript.by_name("Relay Blade-029").skill.name == "Arc Lance")
	assert(UnitCatalogScript.by_name("Relay Bastion-030").skill.name == "Failover Mantle")
	assert(UnitCatalogScript.by_name("Cinder Blade-036").skill.name == "Furnace Wake")
	assert(UnitCatalogScript.by_name("Zephyr Lancer-042").skill.name == "Slipstream Reversal")
	assert(UnitCatalogScript.by_name("Flux Weaver-047").skill.name == "Phase Cascade")
	assert(UnitCatalogScript.by_name("Helio Mender-048").skill.name == "Dawn Circuit")
	assert(UnitCatalogScript.by_name("Relay Bastion-014").promotion_of == "Relay Bastion-013")
	assert(UnitCatalogScript.by_name("Cinder Lancer-018").skill.name == "Locking Strike")
	assert(UnitCatalogScript.by_name("Flux Lancer-031").skill.name == "Relay Storm")
	assert(UnitCatalogScript.by_name("Brass Weaver-034").skill.name == "Overclock Link")
	assert(UnitCatalogScript.by_name("Relay Blade-035").stars == 5)
	assert(UnitCatalogScript.by_name("Zephyr Lancer-037").skill.name == "Sever Drive")
	assert(UnitCatalogScript.by_name("Zephyr Lancer-038").promotion_of == "Zephyr Lancer-037")
	assert(UnitCatalogScript.by_name("Zephyr Battery-039").kind == "Artillerist")
	assert(UnitCatalogScript.by_name("Zephyr Battery-040").hp == 7)
	assert(UnitCatalogScript.by_name("Zephyr Lancer-041").promotion_of == "Zephyr Lancer-038")
	assert(UnitCatalogScript.by_name("Brass Lancer-043").skill.name == "Signal Jam")
	assert(UnitCatalogScript.by_name("Brass Lancer-044").promotion_of == "Brass Lancer-043")
	assert(UnitCatalogScript.by_name("Flux Weaver-045").stars == 2)
	assert(UnitCatalogScript.by_name("Flux Weaver-046").promotion_of == "Flux Weaver-045")
	assert(UnitCatalogScript.by_name("Helio Weaver-055").kind == "Channeler")
	assert(UnitCatalogScript.by_name("Helio Weaver-056").hp == 7)
	assert(UnitCatalogScript.by_name("Helio Mender-049").skill.name == "Repair Pulse")
	assert(UnitCatalogScript.by_name("Flux Bastion-054").atk == 4)
	assert(UnitCatalogScript.by_name("Brass Mender-051").skill.name == "Corrosion Bloom")
	assert(UnitCatalogScript.by_name("Helio Battery-057").skill.name == "Toxin Injector")
	assert(UnitCatalogScript.by_name("Zephyr Weaver-060").promotion_of == "Zephyr Weaver-059")
	assert(UnitCatalogScript.by_name("Helio Battery-062").stars == 5)
	assert(UnitCatalogScript.by_name("Cinder Battery-063").skill.name == "Anchor Shot")
	assert(UnitCatalogScript.by_name("Cinder Battery-065").promotion_of == "Cinder Battery-064")
	assert(UnitCatalogScript.by_name("Cinder Battery-068").promotion_of == "Cinder Battery-067")
	assert(UnitCatalogScript.by_name("Cinder Lancer-069").skill.name == "Suppression Field")
	assert(UnitCatalogScript.by_name("Zephyr Mender-072").stars == 5)
	assert(UnitCatalogScript.by_name("Flux Blade-074").promotion_of == "Flux Blade-073")
	assert(UnitCatalogScript.by_name("Zephyr Blade-075").skill.name == "Countermeasure")
	assert(UnitCatalogScript.by_name("Brass Lancer-078").promotion_of == "Brass Lancer-077")
	assert(UnitCatalogScript.by_name("Flux Lancer-080").promotion_of == "Flux Lancer-079")
	assert(UnitCatalogScript.by_name("Helio Blade-081").skill.name == "Corrosive Edge")
	assert(UnitCatalogScript.by_name("Relay Blade-087").skill.name == "Breach Charge")
	assert(UnitCatalogScript.by_name("Zephyr Battery-088").skill.name == "Heavy Target")
	assert(UnitCatalogScript.by_name("Zephyr Battery-089").promotion_of == "Zephyr Battery-088")
	assert(UnitCatalogScript.by_name("Cinder Weaver-090").skill.name == "Chain Corrosion")
	assert(UnitCatalogScript.by_name("Cinder Weaver-091").promotion_of == "Cinder Weaver-090")
	assert(UnitCatalogScript.by_name("Flux Weaver-092").skill.name == "Meteor Pattern")
	assert(UnitCatalogScript.by_name("Flux Weaver-093").promotion_of == "Flux Weaver-092")
	assert(UnitCatalogScript.by_name("Relay Blade-094").skill.name == "Breaker Impact")
	assert(UnitCatalogScript.by_name("Relay Blade-094").skill.type == "Chant")
	assert(UnitCatalogScript.by_name("Relay Blade-095").promotion_of == "Relay Blade-094")
	assert(UnitCatalogScript.by_name("Brass Bastion-096").kind == "Warden")
	assert(UnitCatalogScript.by_name("Brass Bastion-097").promotion_of == "Brass Bastion-096")
	assert(UnitCatalogScript.by_name("Brass Battery-098").skill.name == "Reactor Leap")
	assert(UnitCatalogScript.by_name("Brass Battery-098").skill.type == "Reaction")
	assert(UnitCatalogScript.by_name("Brass Battery-099").promotion_of == "Brass Battery-098")
	assert(UnitCatalogScript.by_name("Relay Blade-100").skill.name == "Lumen Shell")
	assert(UnitCatalogScript.by_name("Relay Blade-100").skill.type == "Aura")
	assert(UnitCatalogScript.by_name("Relay Blade-101").promotion_of == "Relay Blade-100")
	assert(UnitCatalogScript.by_name("Helio Mender-102").kind == "Lifebinder")
	assert(UnitCatalogScript.by_name("Helio Mender-103").promotion_of == "Helio Mender-102")
	assert(UnitCatalogScript.by_name("Brass Bastion-104").skill.name == "Aegis Array")
	assert(UnitCatalogScript.by_name("Brass Bastion-104").skill.type == "Reaction")
	assert(UnitCatalogScript.by_name("Brass Bastion-105").promotion_of == "Brass Bastion-104")
	assert(UnitCatalogScript.by_name("Brass Bastion-106").promotion_of == "Brass Bastion-105")
	assert(UnitCatalogScript.by_name("Brass Bastion-106").stars == 5)
	assert(UnitCatalogScript.by_name("Flux Weaver-107").skill.name == "Cryo Lock")
	assert(UnitCatalogScript.by_name("Flux Weaver-107").skill.type == "Warcry")
	assert(UnitCatalogScript.by_name("Flux Weaver-108").promotion_of == "Flux Weaver-107")
	assert(UnitCatalogScript.by_name("Zephyr Lancer-109").skill.name == "Drain Strike")
	assert(UnitCatalogScript.by_name("Zephyr Lancer-109").skill.type == "Strike")
	assert(UnitCatalogScript.by_name("Zephyr Lancer-110").promotion_of == "Zephyr Lancer-109")
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Repair Pulse"
	).size() == 4)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Corrosion Bloom"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Toxin Injector"
	).size() == 6)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Anchor Shot"
	).size() == 6)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Suppression Field"
	).size() == 6)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Countermeasure"
	).size() == 6)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Corrosive Edge"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Breach Charge"
	).size() == 5)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Heavy Target"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Chain Corrosion"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Meteor Pattern"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Breaker Impact"
	).size() == 4)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Reactor Leap"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Lumen Shell"
	).size() == 4)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Aegis Array"
	).size() == 3)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Cryo Lock"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Drain Strike"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Guard Link"
	).size() == 4)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Thermal Burst"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Combat Surge"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Holdfast"
	).size() == 4)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Purge Routine"
	).size() == 3)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Field Recovery"
	).size() == 4)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Refit Cycle"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Renewal Current"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Kinetic Throw"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Lockdown Sweep"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Pressure Sink"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Saturation Fire"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Cover Matrix"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Clamp Drain"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Vector Flurry"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Lasting Aegis"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Tidal Reset"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Reversal Current"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Repulse Command"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Grounding Wave"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Growth Pulse"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Solar Crescendo"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Shield Exchange"
	).size() == 4)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Paired Circuit"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Twin Resonance"
	).size() == 1)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Twin Dissonance"
	).size() == 1)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Lane Bulwark"
	).size() == 4)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Pressure Jet"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Deployment Snare"
	).size() == 4)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Frontline Relay"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Dragnet"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Null Signal"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Petrify Loop"
	).size() == 2)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Retaliation Screen"
	).size() == 4)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Silent Cycle"
	).size() == 1)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Thermal Wrap"
	).size() == 6)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Umbral Clamp"
	).size() == 6)
	assert(roster.filter(
		func(unit): return unit.skill != null and unit.skill.name == "Resonant Chorus"
	).size() == 8)
	for chassis_skill in [
		"Foundation Grid", "Aegis Lattice", "Vector Manifold", "Resonance Pulse"
	]:
		assert(roster.filter(
			func(unit): return unit.skill != null and unit.skill.name == chassis_skill
		).size() == 2)
	for skill_name in [
		"Failover Mantle", "Furnace Wake", "Slipstream Reversal",
		"Phase Cascade", "Dawn Circuit"
	]:
		assert(roster.filter(
			func(unit): return unit.skill != null and unit.skill.name == skill_name
		).size() == 1)
	for new_skill_name in [
		"Siphon Edge", "Static Lash", "Shrapnel Arc", "Grudge Capacitor",
		"Mirror Plating", "Command Uplink", "Blackout Burst", "Seismic Salvo",
		"Rally Drumbeat", "Second Wind", "Interference Net", "Siege Rhythm",
		"Intimidating Presence", "Venom Harvest", "Corrosive Detonation",
		"Volatile Core", "Execute Protocol", "Vanguard Doctrine", "Feint Step",
		"Purge Wave", "Blade Doctrine", "Death Knell", "Gunner Doctrine",
		"Frostbrand Strike", "Rampart Doctrine", "Conduit Doctrine", "Field Doctrine",
		"Concussion Blow", "Executioner Spike", "Shieldbreaker", "Scatter Volley",
		"Arc Cascade", "Hushing Resonance", "Leech Protocol", "Concussive Repulse",
		"Retribution Jolt", "Venom Barb", "Emergency Protocol", "Stasis Bolt",
		"Exposing Frequency", "Toxic Miasma", "Discordant Blast", "Resonant Warhorn",
		"Absolution Pulse", "Sanitize Corridor", "Overdrive Charge", "Decommission",
		"Gridlock Field", "Equalize", "Ballast Infusion", "Temporal Rewind",
		"Ember Recoil", "Ramping Dynamo", "Bloodforge Cycle", "Patron's Dividend",
		"Restoration Surge", "Entropy Field", "Ignition Sequence", "Backline Collapse",
		"Slipstream Chorus", "Anchoring Snare", "Provoking Snare", "Apex Confluence",
		"Clear Signal", "Command Presence", "Guardian Protocol", "Twin Drive",
		"Lag Field", "Sacrificial Pyre"
	]:
		assert(roster.filter(
			func(unit): return unit.skill != null and unit.skill.name == new_skill_name
		).size() == 1)
	assert(UnitCatalogScript.by_name("Brass Bastion-112").promotion_of == "Brass Bastion-111")
	assert(UnitCatalogScript.by_name("Zephyr Bastion-114").promotion_of == "Zephyr Bastion-113")
	assert(UnitCatalogScript.by_name("Cinder Weaver-116").promotion_of == "Cinder Weaver-115")
	assert(UnitCatalogScript.by_name("Brass Blade-118").promotion_of == "Brass Blade-117")
	assert(UnitCatalogScript.by_name("Cinder Bastion-120").promotion_of == "Cinder Bastion-119")
	assert(UnitCatalogScript.by_name("Helio Mender-125").promotion_of == "Helio Mender-124")
	assert(UnitCatalogScript.by_name("Helio Mender-127").promotion_of == "Helio Mender-126")
	assert(UnitCatalogScript.by_name("Helio Mender-133").stars == 6)
	assert(UnitCatalogScript.by_name("Zephyr Weaver-169").promotion_of == "Zephyr Weaver-168")
	assert(UnitCatalogScript.by_name("Cinder Battery-171").promotion_of == "Cinder Battery-170")
	assert(UnitCatalogScript.by_name("Relay Blade-165").promotion_of == "Relay Blade-164")
	assert(UnitCatalogScript.by_name("Helio Bastion-172").skill.name == "Lane Bulwark")
	assert(UnitCatalogScript.by_name("Helio Bastion-172").skill.type == "Warcry")
	assert(UnitCatalogScript.by_name("Helio Bastion-173").promotion_of == "Helio Bastion-172")
	assert(UnitCatalogScript.by_name("Helio Bastion-173").stars == 5)
	assert(UnitCatalogScript.by_name("Relay Blade-174").kind == "Duelist")
	assert(UnitCatalogScript.by_name("Relay Blade-175").promotion_of == "Relay Blade-174")
	assert(UnitCatalogScript.by_name("Cinder Battery-176").skill.name == "Pressure Jet")
	assert(UnitCatalogScript.by_name("Cinder Battery-176").skill.type == "Chant")
	assert(UnitCatalogScript.by_name("Cinder Battery-177").promotion_of == "Cinder Battery-176")
	assert(UnitCatalogScript.by_name("Cinder Battery-177").stars == 6)
	assert(UnitCatalogScript.by_name("Zephyr Lancer-178").skill.name == "Deployment Snare")
	assert(UnitCatalogScript.by_name("Zephyr Lancer-178").skill.type == "Chant")
	assert(UnitCatalogScript.by_name("Zephyr Lancer-179").promotion_of == "Zephyr Lancer-178")
	assert(UnitCatalogScript.by_name("Brass Mender-180").kind == "Lifebinder")
	assert(UnitCatalogScript.by_name("Brass Mender-181").promotion_of == "Brass Mender-180")
	assert(UnitCatalogScript.by_name("Cinder Battery-182").skill.name == "Frontline Relay")
	assert(UnitCatalogScript.by_name("Cinder Battery-182").skill.type == "Chant")
	assert(UnitCatalogScript.by_name("Cinder Battery-182").kind == "Artillerist")
	assert(UnitCatalogScript.by_name("Cinder Battery-183").promotion_of == "Cinder Battery-182")
	assert(UnitCatalogScript.by_name("Cinder Battery-183").stars == 6)
	assert(UnitCatalogScript.by_name("Flux Mender-184").skill.name == "Null Signal")
	assert(UnitCatalogScript.by_name("Flux Mender-184").skill.type == "Warcry")
	assert(UnitCatalogScript.by_name("Flux Mender-184").kind == "Lifebinder")
	assert(UnitCatalogScript.by_name("Flux Mender-185").promotion_of == "Flux Mender-184")
	assert(UnitCatalogScript.by_name("Flux Mender-185").stars == 6)
	assert(UnitCatalogScript.by_name("Brass Bastion-186").skill.name == "Dragnet")
	assert(UnitCatalogScript.by_name("Brass Bastion-186").skill.type == "Chant")
	assert(UnitCatalogScript.by_name("Brass Bastion-186").kind == "Warden")
	assert(UnitCatalogScript.by_name("Brass Bastion-187").promotion_of == "Brass Bastion-186")
	assert(UnitCatalogScript.by_name("Brass Bastion-187").stars == 6)
	assert(UnitCatalogScript.by_name("Flux Weaver-188").skill.name == "Retaliation Screen")
	assert(UnitCatalogScript.by_name("Flux Weaver-188").skill.type == "Warcry")
	assert(UnitCatalogScript.by_name("Flux Weaver-188").kind == "Channeler")
	assert(UnitCatalogScript.by_name("Flux Weaver-189").promotion_of == "Flux Weaver-188")
	assert(UnitCatalogScript.by_name("Flux Weaver-189").stars == 6)
	assert(UnitCatalogScript.by_name("Cinder Battery-190").skill.name == "Retaliation Screen")
	assert(UnitCatalogScript.by_name("Cinder Battery-190").kind == "Artillerist")
	assert(UnitCatalogScript.by_name("Cinder Battery-191").promotion_of == "Cinder Battery-190")
	assert(UnitCatalogScript.by_name("Cinder Battery-191").stars == 6)
	assert(UnitCatalogScript.by_name("Flux Weaver-192").skill.name == "Petrify Loop")
	assert(UnitCatalogScript.by_name("Flux Weaver-192").skill.type == "Chant")
	assert(UnitCatalogScript.by_name("Flux Weaver-192").kind == "Channeler")
	assert(UnitCatalogScript.by_name("Flux Weaver-193").promotion_of == "Flux Weaver-192")
	assert(UnitCatalogScript.by_name("Flux Weaver-193").stars == 6)
	assert(UnitCatalogScript.by_name("Flux Mender-194").skill == null)
	assert(UnitCatalogScript.by_name("Flux Mender-194").kind == "Lifebinder")
	assert(UnitCatalogScript.by_name("Flux Mender-195").skill.name == "Silent Cycle")
	assert(UnitCatalogScript.by_name("Flux Mender-195").skill.type == "Chant")
	assert(UnitCatalogScript.by_name("Flux Mender-195").promotion_of == "Flux Mender-194")
	assert(UnitCatalogScript.by_name("Flux Mender-195").stars == 6)
	assert(UnitCatalogScript.by_name("Brass Mender-196").skill.name == "Thermal Wrap")
	assert(UnitCatalogScript.by_name("Brass Mender-196").skill.type == "Warcry")
	assert(UnitCatalogScript.by_name("Brass Mender-196").kind == "Lifebinder")
	assert(UnitCatalogScript.by_name("Brass Mender-196").stars == 4)
	assert(UnitCatalogScript.by_name("Brass Mender-197").promotion_of == "Brass Mender-196")
	assert(UnitCatalogScript.by_name("Brass Mender-197").stars == 5)
	assert(UnitCatalogScript.by_name("Cinder Weaver-198").skill.name == "Thermal Wrap")
	assert(UnitCatalogScript.by_name("Cinder Weaver-198").kind == "Channeler")
	assert(UnitCatalogScript.by_name("Cinder Weaver-199").promotion_of == "Cinder Weaver-198")
	assert(UnitCatalogScript.by_name("Cinder Weaver-199").stars == 5)
	assert(UnitCatalogScript.by_name("Brass Bastion-200").skill.name == "Thermal Wrap")
	assert(UnitCatalogScript.by_name("Brass Bastion-200").kind == "Warden")
	assert(UnitCatalogScript.by_name("Brass Bastion-200").hp == 9)
	assert(UnitCatalogScript.by_name("Brass Bastion-201").promotion_of == "Brass Bastion-200")
	assert(UnitCatalogScript.by_name("Brass Bastion-201").stars == 5)
	assert(UnitCatalogScript.by_name("Zephyr Lancer-202").skill.name == "Umbral Clamp")
	assert(UnitCatalogScript.by_name("Zephyr Lancer-202").skill.type == "Warcry")
	assert(UnitCatalogScript.by_name("Zephyr Lancer-202").kind == "Strider")
	assert(UnitCatalogScript.by_name("Zephyr Lancer-202").stars == 5)
	assert(UnitCatalogScript.by_name("Zephyr Lancer-203").promotion_of == "Zephyr Lancer-202")
	assert(UnitCatalogScript.by_name("Zephyr Lancer-203").stars == 6)
	assert(UnitCatalogScript.by_name("Zephyr Lancer-204").skill.name == "Umbral Clamp")
	assert(UnitCatalogScript.by_name("Zephyr Lancer-204").kind == "Strider")
	assert(UnitCatalogScript.by_name("Zephyr Lancer-205").promotion_of == "Zephyr Lancer-204")
	assert(UnitCatalogScript.by_name("Zephyr Lancer-205").stars == 6)
	assert(UnitCatalogScript.by_name("Flux Weaver-206").skill.name == "Umbral Clamp")
	assert(UnitCatalogScript.by_name("Flux Weaver-206").kind == "Channeler")
	assert(UnitCatalogScript.by_name("Flux Weaver-207").promotion_of == "Flux Weaver-206")
	assert(UnitCatalogScript.by_name("Flux Weaver-207").stars == 6)
	assert(UnitCatalogScript.by_name("Flux Weaver-207").atk == 6)
	assert(UnitCatalogScript.by_name("Zephyr Mender-208").skill.name == "Resonant Chorus")
	assert(UnitCatalogScript.by_name("Zephyr Mender-208").skill.type == "Aura")
	assert(UnitCatalogScript.by_name("Zephyr Mender-208").kind == "Lifebinder")
	assert(UnitCatalogScript.by_name("Zephyr Mender-208").stars == 2)
	assert(UnitCatalogScript.by_name("Zephyr Mender-208").cost == 3)
	assert(UnitCatalogScript.by_name("Zephyr Mender-208").atk == 2)
	assert(UnitCatalogScript.by_name("Zephyr Mender-208").hp == 3)
	assert(UnitCatalogScript.by_name("Zephyr Mender-209").promotion_of == "Zephyr Mender-208")
	assert(UnitCatalogScript.by_name("Zephyr Mender-209").stars == 3)
	assert(UnitCatalogScript.by_name("Zephyr Mender-209").hp == 5)
	assert(UnitCatalogScript.by_name("Flux Weaver-210").kind == "Channeler")
	assert(UnitCatalogScript.by_name("Flux Weaver-210").skill.name == "Resonant Chorus")
	assert(UnitCatalogScript.by_name("Flux Weaver-210").atk == 4)
	assert(UnitCatalogScript.by_name("Flux Weaver-211").promotion_of == "Flux Weaver-210")
	assert(UnitCatalogScript.by_name("Flux Weaver-211").stars == 4)
	assert(UnitCatalogScript.by_name("Flux Weaver-212").promotion_of == "Flux Weaver-211")
	assert(UnitCatalogScript.by_name("Flux Weaver-212").stars == 5)
	assert(UnitCatalogScript.by_name("Flux Weaver-212").atk == 6)
	assert(UnitCatalogScript.by_name("Cinder Mender-213").kind == "Lifebinder")
	assert(UnitCatalogScript.by_name("Cinder Mender-213").skill.name == "Resonant Chorus")
	assert(UnitCatalogScript.by_name("Cinder Mender-213").cost == 2)
	assert(UnitCatalogScript.by_name("Cinder Mender-214").promotion_of == "Cinder Mender-213")
	assert(UnitCatalogScript.by_name("Cinder Mender-214").stars == 4)
	assert(UnitCatalogScript.by_name("Cinder Mender-215").promotion_of == "Cinder Mender-214")
	assert(UnitCatalogScript.by_name("Cinder Mender-215").stars == 5)
	assert(UnitCatalogScript.by_name("Cinder Mender-215").hp == 5)
	assert(UnitCatalogScript.by_name("Relay Battery-217").skill.name == "Foundation Grid")
	assert(UnitCatalogScript.by_name("Relay Battery-218").promotion_of == "Relay Battery-217")
	assert(UnitCatalogScript.by_name("Cinder Bastion-219").skill.name == "Aegis Lattice")
	assert(UnitCatalogScript.by_name("Cinder Bastion-220").promotion_of == "Cinder Bastion-219")
	assert(UnitCatalogScript.by_name("Zephyr Lancer-221").skill.name == "Vector Manifold")
	assert(UnitCatalogScript.by_name("Zephyr Lancer-222").promotion_of == "Zephyr Lancer-221")
	assert(UnitCatalogScript.by_name("Helio Mender-223").skill.name == "Resonance Pulse")
	assert(UnitCatalogScript.by_name("Helio Mender-224").promotion_of == "Helio Mender-223")
	# Chassis families are authored mechanical traits; units default to standard.
	assert(UnitCatalogScript.by_name("Relay Lancer-003").chassis_family == "standard")
	assert(UnitCatalogScript.by_name("Relay Bastion-001").chassis_family == "standard")
	assert(UnitCatalogScript.by_name("Helio Bastion-172").chassis_family == "bulwark")
	assert(UnitCatalogScript.by_name("Relay Blade-002").chassis_family == "bulwark")
	assert(UnitCatalogScript.by_name("Zephyr Lancer-178").chassis_family == "swift")
	assert(UnitCatalogScript.by_name("Relay Lancer-009").chassis_family == "swift")
	assert(UnitCatalogScript.by_name("Relay Mender-006").chassis_family == "resonant")
	assert(UnitCatalogScript.by_name("Helio Mender-102").chassis_family == "resonant")
	assert(UnitCatalogScript.by_name("Zephyr Lancer-178").to_dict().chassis_family == "swift")
	assert(UnitCatalogScript.by_name("Relay Lancer-003").to_dict().chassis_family == "standard")
	for resonant_name in [
		"Zephyr Mender-208", "Zephyr Mender-209", "Flux Weaver-210", "Flux Weaver-211",
		"Flux Weaver-212", "Cinder Mender-213", "Cinder Mender-214", "Cinder Mender-215"
	]:
		assert(UnitCatalogScript.by_name(resonant_name).chassis_family == "resonant")
	assert(UnitCatalogScript.by_name("Relay Battery-217").chassis_family == "standard")
	assert(UnitCatalogScript.by_name("Cinder Bastion-219").chassis_family == "bulwark")
	assert(UnitCatalogScript.by_name("Zephyr Lancer-221").chassis_family == "swift")
	assert(UnitCatalogScript.by_name("Helio Mender-223").chassis_family == "resonant")
	assert(UnitCatalogScript.art_id(49) == 47)
	assert(UnitCatalogScript.art_id(56) == 58)
	assert(UnitCatalogScript.art_id(27) == 83)
	assert(UnitCatalogScript.art_id(28) == 177)
	assert(UnitCatalogScript.art_id(29) == 423)
	assert(UnitCatalogScript.art_id(30) == 1301)
	assert(UnitCatalogScript.art_id(36) == 1302)
	assert(UnitCatalogScript.art_id(42) == 1303)
	assert(UnitCatalogScript.art_id(47) == 1304)
	assert(UnitCatalogScript.art_id(48) == 1305)
	assert(UnitCatalogScript.art_id(231) == 1307)
	assert(UnitCatalogScript.art_id(232) == 1308)
	assert(UnitCatalogScript.art_id(241) == 1309)
	assert(UnitCatalogScript.art_id(242) == 1310)
	assert(UnitCatalogScript.art_id(39) == 535)
	assert(UnitCatalogScript.art_id(68) == 629)
	assert(UnitCatalogScript.art_id(80) == 488)
	assert(UnitCatalogScript.art_id(87) == 609)
	assert(UnitCatalogScript.art_id(88) == 31)
	assert(UnitCatalogScript.art_id(89) == 32)
	assert(UnitCatalogScript.art_id(90) == 93)
	assert(UnitCatalogScript.art_id(91) == 94)
	assert(UnitCatalogScript.art_id(92) == 81)
	assert(UnitCatalogScript.art_id(93) == 82)
	assert(UnitCatalogScript.art_id(94) == 195)
	assert(UnitCatalogScript.art_id(97) == 290)
	assert(UnitCatalogScript.art_id(98) == 787)
	assert(UnitCatalogScript.art_id(100) == 887)
	assert(UnitCatalogScript.art_id(102) == 1191)
	assert(UnitCatalogScript.art_id(103) == 1192)
	assert(UnitCatalogScript.art_id(104) == 73)
	assert(UnitCatalogScript.art_id(106) == 607)
	assert(UnitCatalogScript.art_id(108) == 142)
	assert(UnitCatalogScript.art_id(110) == 150)
	assert(UnitCatalogScript.art_id(111) == 37)
	assert(UnitCatalogScript.art_id(113) == 97)
	assert(UnitCatalogScript.art_id(115) == 105)
	assert(UnitCatalogScript.art_id(117) == 87)
	assert(UnitCatalogScript.art_id(119) == 61)
	assert(UnitCatalogScript.art_id(133) == 204)
	assert(UnitCatalogScript.art_id(147) == 430)
	assert(UnitCatalogScript.art_id(165) == 1200)
	assert(UnitCatalogScript.art_id(169) == 1026)
	assert(UnitCatalogScript.art_id(171) == 1028)
	assert(UnitCatalogScript.art_id(172) == 325)
	assert(UnitCatalogScript.art_id(173) == 326)
	assert(UnitCatalogScript.art_id(174) == 979)
	assert(UnitCatalogScript.art_id(175) == 980)
	assert(UnitCatalogScript.art_id(176) == 127)
	assert(UnitCatalogScript.art_id(177) == 128)
	assert(UnitCatalogScript.art_id(178) == 597)
	assert(UnitCatalogScript.art_id(179) == 598)
	assert(UnitCatalogScript.art_id(180) == 965)
	assert(UnitCatalogScript.art_id(181) == 966)
	assert(UnitCatalogScript.art_id(182) == 295)
	assert(UnitCatalogScript.art_id(183) == 296)
	assert(UnitCatalogScript.art_id(184) == 215)
	assert(UnitCatalogScript.art_id(185) == 216)
	assert(UnitCatalogScript.art_id(186) == 1011)
	assert(UnitCatalogScript.art_id(187) == 1012)
	assert(UnitCatalogScript.art_id(188) == 697)
	assert(UnitCatalogScript.art_id(189) == 698)
	assert(UnitCatalogScript.art_id(190) == 1123)
	assert(UnitCatalogScript.art_id(191) == 1124)
	assert(UnitCatalogScript.art_id(192) == 747)
	assert(UnitCatalogScript.art_id(193) == 748)
	assert(UnitCatalogScript.art_id(194) == 1019)
	assert(UnitCatalogScript.art_id(195) == 1020)
	assert(UnitCatalogScript.art_id(196) == 263)
	assert(UnitCatalogScript.art_id(197) == 264)
	assert(UnitCatalogScript.art_id(198) == 321)
	assert(UnitCatalogScript.art_id(199) == 322)
	assert(UnitCatalogScript.art_id(200) == 567)
	assert(UnitCatalogScript.art_id(201) == 568)
	assert(UnitCatalogScript.art_id(202) == 693)
	assert(UnitCatalogScript.art_id(203) == 694)
	assert(UnitCatalogScript.art_id(204) == 1053)
	assert(UnitCatalogScript.art_id(205) == 1054)
	assert(UnitCatalogScript.art_id(206) == 1153)
	assert(UnitCatalogScript.art_id(207) == 1154)
	assert(UnitCatalogScript.art_id(208) == 35)
	assert(UnitCatalogScript.art_id(209) == 36)
	assert(UnitCatalogScript.art_id(210) == 69)
	assert(UnitCatalogScript.art_id(211) == 70)
	assert(UnitCatalogScript.art_id(212) == 603)
	assert(UnitCatalogScript.art_id(213) == 107)
	assert(UnitCatalogScript.art_id(214) == 108)
	assert(UnitCatalogScript.art_id(215) == 633)
	assert(UnitCatalogScript.art_id(216) == 1306)
	assert(UnitCatalogScript.art_id(253) == 1311)
	assert(UnitCatalogScript.art_id(254) == 1312)
	assert(UnitCatalogScript.art_id(259) == 1313)
	assert(UnitCatalogScript.art_id(260) == 1314)
	assert(UnitCatalogScript.art_id(263) == 1315)
	assert(UnitCatalogScript.art_id(264) == 1316)
	assert(UnitCatalogScript.art_id(275) == 1317)
	assert(UnitCatalogScript.art_id(276) == 1318)
	assert(UnitCatalogScript.art_id(289) == 1319)
	assert(UnitCatalogScript.art_id(290) == 1320)
	for new_icon in range(217, 225):
		assert(UnitCatalogScript.art_id(new_icon) == new_icon)
	var art_units: Array = roster.duplicate()
	art_units.append_array(mission_units)
	for unit in art_units:
		var art_id: int = UnitCatalogScript.art_id(unit.icon)
		assert(FileAccess.file_exists(
			"res://assets/units/portraits/%03d.png" % art_id
		))
		var full_art_path := "res://assets/units/full/%03d.png" % art_id
		assert(FileAccess.file_exists(full_art_path))
		var full_art_import_path := full_art_path + ".import"
		assert(FileAccess.file_exists(full_art_import_path))
		assert(FileAccess.get_file_as_string(full_art_import_path).contains(
			"mipmaps/generate=true"
		))
	var full_files := Array(DirAccess.get_files_at("res://assets/units/full")).filter(
		func(file_name): return file_name.ends_with(".png")
	)
	var portrait_files := Array(DirAccess.get_files_at("res://assets/units/portraits")).filter(
		func(file_name): return file_name.ends_with(".png")
	)
	var generated_files := Array(DirAccess.get_files_at("res://assets/units/gen")).filter(
		func(file_name): return file_name.ends_with(".png")
	)
	var provenance_files: Array = []
	for faction in ["Coal", "Steam", "Wind", "Fusion", "Solar", "Universal"]:
		for unit_class in ["Warden", "Duelist", "Strider", "Artillerist", "Channeler", "Lifebinder", "Transport"]:
			var provenance_dir := (
				"res://assets/units/original_sources/faction_chassis/%s/%s"
				% [faction, unit_class]
			)
			if DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(provenance_dir)):
				provenance_files.append_array(Array(
					DirAccess.get_files_at(provenance_dir)
				).filter(func(file_name): return file_name.ends_with(".png")))
	assert(full_files.size() == 293)
	assert(portrait_files.size() == 293)
	assert(generated_files.size() == 293)
	assert(provenance_files.size() == 293)
	full_files.sort()
	portrait_files.sort()
	generated_files.sort()
	provenance_files.sort()
	assert(full_files == portrait_files)
	assert(full_files == generated_files)
	assert(full_files == provenance_files)
	assert(not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(
		"res://assets/units/portrait_sheets"
	)))
	assert(not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(
		"res://assets/units/full_by_class"
	)))
	assert(not FileAccess.file_exists("res://assets/units/portrait_manifest.tsv"))
	assert(not FileAccess.file_exists("res://tools/generate_unit_portraits.gd"))
	assert(roster.filter(func(unit): return unit.promotion_of != "").size() == 107)
	assert(UnitSkillsScript.timing_tooltip("Warcry") == "Activates when this unit enters the battlefield.")

	var default_squad: Array = SquadStoreScript.default_squad(roster)
	assert(default_squad.size() == 8)
	assert(default_squad.all(func(unit_name): return (
		UnitCatalogScript.by_name(unit_name).stars == 1
	)))
	var repaired_squad: Array = SquadStoreScript.sanitize(["Relay Lancer-003", "Relay Lancer-003", "Relay Lancer-003", "Missing"], roster)
	assert(repaired_squad.size() == 2)
	assert(repaired_squad.count("Relay Lancer-003") == 2)
	assert(SquadStoreScript.build_deck(repaired_squad, roster).size() == 2)
	var ordered_deck: Array = SquadStoreScript.build_deck(
		["Relay Lancer-003", "Relay Blade-002", "Relay Bastion-001", "Relay Battery-004"],
		roster
	)
	var deck_rng := RandomNumberGenerator.new()
	deck_rng.seed = 42
	var shuffled_deck: Array = SquadStoreScript.shuffle_for_battle(ordered_deck, deck_rng)
	assert(shuffled_deck[0].name == "Relay Lancer-003")
	assert(shuffled_deck.map(func(card): return card.name).duplicate().size() == ordered_deck.size())
	var ordered_names: Array = ordered_deck.map(func(card): return card.name)
	var shuffled_names: Array = shuffled_deck.map(func(card): return card.name)
	ordered_names.sort()
	shuffled_names.sort()
	assert(shuffled_names == ordered_names)
	assert(SquadStoreScript.sanitize([], roster).size() == 8)
	var inventory := CampaignStoreScript.inventory_counts(
		roster, ["Relay Lancer-003", "Relay Lancer-003", "Relay Mender-006"]
	)
	assert(inventory["Relay Lancer-003"] == 3)
	assert(inventory["Relay Mender-006"] == 2)
	assert(inventory["Relay Mender-012"] == 1)
	assert(inventory["Relay Bastion-013"] == 0)
	var owned_squad: Array = SquadStoreScript.sanitize_owned(
		["Relay Lancer-003", "Relay Lancer-003", "Relay Lancer-003", "Relay Mender-006", "Relay Mender-012"],
		roster,
		inventory
	)
	assert(owned_squad == [
		"Relay Lancer-003", "Relay Lancer-003", "Relay Mender-006", "Relay Mender-012"
	])
	assert(ConductorSkillsScript.SKILLS.size() == 8)
	assert(CampaignStoreScript.SAVE_VERSION == 1)
	assert(SquadStoreScript.SAVE_VERSION == 4)
	DirAccess.remove_absolute(ProjectSettings.globalize_path(SquadStoreScript.SAVE_PATH))
	var legacy_squad_config := ConfigFile.new()
	legacy_squad_config.set_value("squad", "instance_ids", ["copy_a", "copy_c"])
	legacy_squad_config.set_value("squad", "conductor_skill", "Shield")
	assert(legacy_squad_config.save(SquadStoreScript.SAVE_PATH) == OK)
	var named_state := SquadStoreScript.load_named_squads(
		roster, instance_copies, ConductorSkillsScript.SKILLS
	)
	assert(named_state.squads.size() == 1)
	assert(named_state.squads[0].name == SquadStoreScript.DEFAULT_SQUAD_NAME)
	assert(named_state.squads[0].instance_ids == ["copy_a", "copy_c"])
	assert(named_state.squads[0].conductor_skill == "Shield")
	var second_squad_id := SquadStoreScript.next_named_squad_id(named_state.squads)
	assert(second_squad_id != named_state.active_id)
	named_state.squads.append({
		"id": second_squad_id,
		"name": SquadStoreScript.unique_squad_name("Squad 1", named_state.squads),
		"instance_ids": ["copy_b"],
		"conductor_skill": "Firestorm"
	})
	assert(named_state.squads[1].name == "Squad 1 (2)")
	assert(SquadStoreScript.save_named_squads(
		named_state.squads, second_squad_id, instance_copies,
		ConductorSkillsScript.SKILLS
	))
	var reloaded_named_state := SquadStoreScript.load_named_squads(
		roster, instance_copies, ConductorSkillsScript.SKILLS
	)
	assert(reloaded_named_state.squads.size() == 2)
	assert(reloaded_named_state.active_id == second_squad_id)
	assert(reloaded_named_state.squads[1].instance_ids == ["copy_b"])
	assert(reloaded_named_state.squads[1].conductor_skill == "Firestorm")
	var named_config := ConfigFile.new()
	assert(named_config.load(SquadStoreScript.SAVE_PATH) == OK)
	assert(named_config.get_value("meta", "version", 0) == 4)
	assert(named_config.get_value("squad", "instance_ids", []) == ["copy_b"])
	assert(named_config.get_value("squad", "conductor_skill", "") == "Firestorm")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(SquadStoreScript.SAVE_PATH))

	assert(CampaignStoreScript.MISSIONS.size() == 77)
	assert(CampaignStoreScript.MISSIONS[0].title == "Act 1 Mission 1 - First Synchrony")
	assert(CampaignStoreScript.MISSIONS[61].title == "Act 2 Mission 62 - Caelis Approach")
	assert(CampaignStoreScript.MISSIONS[76].title == "Act 3 Mission 77 - The Caelis Accord")
	assert(CampaignStoreScript.MISSIONS[0].enemy_hp == 8)
	assert(CampaignStoreScript.MISSIONS[61].enemy_hp == 20)
	assert(CampaignStoreScript.MISSIONS[76].enemy_hp == 20)
	assert(CampaignStoreScript.MISSIONS[62].act == 3)
	assert(CampaignStoreScript.MISSIONS[62].act_mission == 1)
	assert(CampaignStoreScript.MISSIONS[76].act_mission == 15)
	assert(CampaignStoreScript.MISSIONS[62].chapter == "The Outer City")
	assert(CampaignStoreScript.MISSIONS[77 - 1].chapter == "The Source")
	for mission in CampaignStoreScript.MISSIONS:
		assert(not mission.get("opponent_name", "").is_empty())
		assert(not mission.get("opponent_affiliation", "").is_empty())
		for encounter in mission.encounters:
			assert(encounter.opponent_name == mission.opponent_name)
			assert(encounter.opponent_affiliation == mission.opponent_affiliation)
	assert(CampaignStoreScript.MISSIONS[8].opponent_affiliation == "Scavenger Clans")
	assert(CampaignStoreScript.MISSIONS[28].opponent_name == "Asha Vale")
	assert(CampaignStoreScript.MISSIONS[76].opponent_affiliation == "Accord Rejectionists")
	assert(StoryDialogueCatalogScript.INTERLUDES.size() == 46)
	assert(StoryDialogueCatalogScript.PORTRAITS.size() == 10)
	for portrait_path in StoryDialogueCatalogScript.PORTRAITS.values():
		var portrait_texture: Texture2D = load(portrait_path)
		assert(portrait_texture != null)
		assert(portrait_texture.get_image().has_mipmaps())
	assert(StoryDialogueCatalogScript.CHARACTERS.Conductor.portrait.ends_with("conductor.png"))
	assert(StoryDialogueCatalogScript.CHARACTERS["Brass Bastion-136"].portrait_kind == "android")
	assert(StoryDialogueCatalogScript.CHARACTERS["First Conductor"].portrait_kind == "android")
	for character in StoryDialogueCatalogScript.CHARACTERS.values():
		assert(character.get("portrait_kind", "") in ["human", "android"])
		assert(ResourceLoader.exists(character.get("portrait", "")))
	var opening_interlude := StoryDialogueCatalogScript.scene_for_mission(0)
	assert(opening_interlude.title == "A Useful Kind of Impossible")
	assert(opening_interlude.lines.size() >= 4)
	assert(opening_interlude.background == StoryDialogueCatalogScript.BACKGROUNDS.technical)
	assert(StoryDialogueCatalogScript.scene_for_mission(1).is_empty())
	assert(StoryDialogueCatalogScript.scene_for_mission(60).title == "The Invitation")
	assert(StoryDialogueCatalogScript.scene_for_mission(61).title == "At the Threshold")
	assert(StoryDialogueCatalogScript.scene_for_mission(62).is_empty())
	assert(StoryDialogueCatalogScript.scene_for_mission(66).title == "Five True Stories")
	assert(StoryDialogueCatalogScript.scene_for_mission(76).lines.size() == 6)
	for mission_number in StoryDialogueCatalogScript.INTERLUDES:
		var interlude: Dictionary = StoryDialogueCatalogScript.INTERLUDES[mission_number]
		var presented_scene := StoryDialogueCatalogScript.scene_for_mission(mission_number - 1)
		assert(mission_number >= 1 and mission_number <= CampaignStoreScript.MISSIONS.size())
		assert(not interlude.get("title", "").is_empty())
		assert(not interlude.get("location", "").is_empty())
		assert(ResourceLoader.exists(presented_scene.get("background", "")))
		assert(interlude.get("lines", []).size() >= 4)
		for dialogue_line in interlude.lines:
			assert(not dialogue_line.get("speaker", "").is_empty())
			assert(not dialogue_line.get("text", "").is_empty())
			assert(StoryDialogueCatalogScript.CHARACTERS.has(dialogue_line.speaker))
	assert("Brass Bastion-136" in CampaignStoreScript.MISSIONS[62].reward_pool)
	assert("Brass Bastion-137" in CampaignStoreScript.MISSIONS[62].reward_pool)
	assert("Helio Mender-161" in CampaignStoreScript.MISSIONS[76].reward_pool)
	assert(CampaignStoreScript.CAMPAIGN_EPILOGUE.contains("THE RESONANCE WAR"))
	assert(CampaignStoreScript.encounter_count(3) == 1)
	assert(CampaignStoreScript.encounter_count(31) == 3)
	assert(CampaignStoreScript.encounter(31, 2).title == "Summit Breach")
	assert(CampaignStoreScript.encounter(999, 0).is_empty())
	var default_mission_rules: Dictionary = MissionRulesScript.default_rules()
	assert(default_mission_rules.objective.type == "defeat_conductor")
	assert(not MissionRulesScript.has_authored_rules(default_mission_rules))
	var authored_encounters := 0
	for mission in CampaignStoreScript.MISSIONS:
		for encounter in mission.encounters:
			if MissionRulesScript.has_authored_rules(encounter.rules):
				authored_encounters += 1
			var occupied_rule_cells: Array = []
			for deployment in encounter.rules.predeployed:
				assert(
					UnitCatalogScript.by_name(deployment.unit) != null
					or MissionUnitCatalogScript.by_name(deployment.unit) != null
				)
				var cell := {"row": deployment.row, "col": deployment.col}
				assert(cell not in encounter.rules.blocked_cells)
				assert(cell not in occupied_rule_cells)
				occupied_rule_cells.append(cell)
			for reinforcement in encounter.rules.reinforcements:
				assert(
					UnitCatalogScript.by_name(reinforcement.unit) != null
					or MissionUnitCatalogScript.by_name(reinforcement.unit) != null
				)
				assert(reinforcement.round >= 1)
	assert(authored_encounters == 7)
	var evacuation_rules: Dictionary = CampaignStoreScript.encounter(2, 0).rules
	assert(evacuation_rules.objective.type == "survive")
	assert(evacuation_rules.objective.rounds == 4)
	assert(evacuation_rules.blocked_cells.size() == 2)
	assert(evacuation_rules.mana.player_start == 4)
	assert(MissionRulesScript.dossier_text(evacuation_rules).contains("EVACUATE THE GALLERY"))
	assert(not MissionRulesScript.evaluate(
		evacuation_rules, [], 3, 10, 10, "enemy_end"
	).finished)
	var survival_result: Dictionary = MissionRulesScript.evaluate(
		evacuation_rules, [], 4, 10, 10, "enemy_end"
	)
	assert(survival_result.finished and survival_result.winner == 0)
	var priority_rules: Dictionary = CampaignStoreScript.encounter(3, 0).rules
	assert(priority_rules.objective.type == "eliminate_target")
	assert(priority_rules.predeployed[0].role == "priority")
	assert(not MissionRulesScript.evaluate(
		priority_rules,
		[{"mission_role": "priority", "hp": 1}], 1, 20, 10
	).finished)
	assert(MissionRulesScript.evaluate(
		priority_rules, [], 1, 20, 10
	).winner == 0)
	var protect_rules: Dictionary = CampaignStoreScript.encounter(4, 0).rules
	assert(protect_rules.objective.type == "protect")
	assert(MissionRulesScript.evaluate(
		protect_rules, [], 1, 20, 10
	).winner == 1)
	assert(not MissionRulesScript.evaluate(
		protect_rules,
		[{"mission_role": "protected", "hp": 1}], 1, 20, 10
	).finished)
	assert(MissionRulesScript.evaluate(
		priority_rules,
		[{"mission_role": "priority", "hp": 1}], 6, 20, 10, "enemy_end"
	).winner == 1)
	assert(CampaignStoreScript.is_available(0, []))
	assert(not CampaignStoreScript.is_available(1, []))
	assert(CampaignStoreScript.is_available(1, [0]))
	assert(CampaignStoreScript.sanitize_completed([2, 2, 999, -1, 0]) == [0, 2])
	var starting_unlocks: Array = CampaignStoreScript.unlocked_unit_names(roster, [])
	assert(starting_unlocks.size() == 15)
	assert(starting_unlocks.all(func(unit_name): return (
		UnitCatalogScript.by_name(unit_name).stars == 1
	)))
	assert("Relay Mender-006" in starting_unlocks)
	assert("Relay Mender-012" in starting_unlocks)
	assert("Zephyr Mender-208" not in starting_unlocks)
	assert("Flux Weaver-210" not in starting_unlocks)
	assert("Flux Weaver-212" not in starting_unlocks)
	assert("Cinder Mender-215" not in starting_unlocks)
	assert("Relay Battery-217" not in starting_unlocks)
	assert("Helio Mender-224" not in starting_unlocks)
	var earned_unlocks: Array = CampaignStoreScript.unlocked_unit_names(
		roster, ["Relay Bastion-013", "Cinder Blade-015"]
	)
	assert(earned_unlocks.size() == 17)
	assert("Relay Bastion-013" in earned_unlocks)
	assert("Cinder Blade-015" in earned_unlocks)
	assert("Zephyr Mender-208" in CampaignStoreScript.REWARD_UNITS)
	assert("Zephyr Mender-209" in CampaignStoreScript.REWARD_UNITS)
	assert("Cinder Mender-213" in CampaignStoreScript.REWARD_UNITS)
	assert("Cinder Mender-214" in CampaignStoreScript.REWARD_UNITS)
	for chassis_reward in [
		"Relay Battery-217", "Relay Battery-218", "Cinder Bastion-219",
		"Cinder Bastion-220", "Zephyr Lancer-221", "Zephyr Lancer-222",
		"Helio Mender-223", "Helio Mender-224"
	]:
		assert(chassis_reward in CampaignStoreScript.REWARD_UNITS)
	assert("Flux Weaver-210" not in CampaignStoreScript.REWARD_UNITS)
	assert(CampaignStoreScript.roll_reward(0, roster, 0.0) == "Relay Lancer-003")
	assert(CampaignStoreScript.roll_reward(0, roster, 0.999) == "Relay Battery-004")
	var gacha_fixture := [
		{"name": "Low", "stars": 1},
		{"name": "High", "stars": 5},
		{"name": "Highest", "stars": 6}
	]
	assert(GachaStoreScript.battle_reward_weight(1) == 32.0)
	assert(GachaStoreScript.battle_reward_weight(5) == 2.0)
	assert(GachaStoreScript.battle_reward_weight(6) == 1.0)
	var base_gacha_odds := GachaStoreScript.rarity_odds(gacha_fixture, 0)
	var raised_gacha_odds := GachaStoreScript.rarity_odds(gacha_fixture, 10)
	assert(is_equal_approx(base_gacha_odds[5], 2.0 / 35.0))
	assert(is_equal_approx(base_gacha_odds[6], 1.0 / 35.0))
	var full_roster_gacha_odds := GachaStoreScript.rarity_odds(roster, 0)
	assert(is_equal_approx(full_roster_gacha_odds[1], 32.0 / 63.0))
	assert(is_equal_approx(full_roster_gacha_odds[2], 16.0 / 63.0))
	assert(is_equal_approx(
		full_roster_gacha_odds[1] + full_roster_gacha_odds[2], 48.0 / 63.0
	))
	assert(is_equal_approx(
		full_roster_gacha_odds[5] + full_roster_gacha_odds[6], 3.0 / 63.0
	))
	assert(raised_gacha_odds[5] + raised_gacha_odds[6] > (
		base_gacha_odds[5] + base_gacha_odds[6]
	))
	var missed_pull := GachaStoreScript.roll_once(gacha_fixture, 0, 0.0)
	assert(missed_pull.name == "Low" and missed_pull.pity_after == 1)
	var hard_pity_pull := GachaStoreScript.roll_once(
		gacha_fixture, GachaStoreScript.HARD_PITY_PULL - 1, 0.0
	)
	assert(hard_pity_pull.stars >= 5)
	assert(hard_pity_pull.pity_reset and hard_pity_pull.pity_after == 0)
	var sequential_pulls := GachaStoreScript.roll_batch(
		gacha_fixture, 3, GachaStoreScript.HARD_PITY_PULL - 2, [0.0, 0.0, 0.0]
	)
	assert(sequential_pulls.results[0].pity_after == GachaStoreScript.HARD_PITY_PULL - 1)
	assert(sequential_pulls.results[1].pity_reset)
	assert(sequential_pulls.results[2].pity_after == 1)
	assert(sequential_pulls.pity == 1)
	assert(GachaStoreScript.save_pity(12))
	assert(GachaStoreScript.load_pity() == 12)
	DirAccess.remove_absolute(ProjectSettings.globalize_path(GachaStoreScript.SAVE_PATH))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(RequisitionStoreScript.SAVE_PATH))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(ChallengeStoreScript.SAVE_PATH))
	assert(RequisitionStoreScript.load_balance() == 0)
	var starter_currency := RequisitionStoreScript.ensure_starter_grant()
	assert(starter_currency.claimed)
	assert(starter_currency.amount == 1000 and starter_currency.balance == 1000)
	var duplicate_starter := RequisitionStoreScript.ensure_starter_grant()
	assert(not duplicate_starter.claimed and duplicate_starter.balance == 1000)
	var mission_claim_id := RequisitionStoreScript.campaign_milestone_claim_id(7)
	assert(mission_claim_id == "campaign:first_manual_clear:007")
	var mission_currency := RequisitionStoreScript.claim(
		mission_claim_id, RequisitionStoreScript.CAMPAIGN_MILESTONE_GRANT
	)
	assert(mission_currency.claimed and mission_currency.balance == 1100)
	assert(RequisitionStoreScript.has_claimed(mission_claim_id))
	# Three offline challenge templates rotate on UTC ISO-week boundaries. Their
	# authored objectives use the same normalized rules as campaign encounters.
	var challenges := ChallengeCatalogScript.all_challenges()
	assert(challenges.size() == 3)
	assert(challenges.map(func(challenge): return challenge.id) == [
		"iron_trial", "overclock_gauntlet", "null_hunt"
	])
	for challenge in challenges:
		assert(challenge.reward_credits == 250)
		assert(challenge.enemy_squad.size() == SquadStoreScript.SQUAD_SIZE)
		assert(challenge.skill in ConductorSkillsScript.SKILLS)
		assert(MissionRulesScript.has_authored_rules(challenge.rules))
		var challenge_cards := SquadStoreScript.build_deck(challenge.enemy_squad, roster)
		assert(challenge_cards.size() == SquadStoreScript.SQUAD_SIZE)
		assert(BattleSimulatorScript.estimate_squad_power(challenge_cards) > 0.0)
		var challenge_classes: Array = []
		for unit_name in challenge.enemy_squad:
			var challenge_unit := UnitCatalogScript.by_name(unit_name)
			assert(challenge_unit != null)
			assert(
				UnitCatalogScript.faction_for_name(unit_name) == challenge.squad_faction
				or UnitCatalogScript.faction_for_name(unit_name) == "Universal"
			)
			if challenge_unit.kind not in challenge_classes:
				challenge_classes.append(challenge_unit.kind)
		assert(challenge_classes.size() >= 5)
		var occupied_challenge_cells: Array = []
		for deployment in challenge.rules.predeployed + challenge.rules.reinforcements:
			assert(
				UnitCatalogScript.by_name(deployment.unit) != null
				or MissionUnitCatalogScript.by_name(deployment.unit) != null
			)
			var challenge_cell := {"row": deployment.row, "col": deployment.col}
			assert(challenge_cell not in challenge.rules.blocked_cells)
			if deployment in challenge.rules.predeployed:
				assert(challenge_cell not in occupied_challenge_cells)
				occupied_challenge_cells.append(challenge_cell)
	assert(challenges[0].rules.objective.type == "protect")
	assert(challenges[1].rules.objective.type == "survive")
	assert(challenges[1].rules.objective.rounds == 5)
	assert(challenges[2].rules.objective.type == "eliminate_target")
	assert(challenges[2].rules.turn_limit == 6)
	var week_32_start := int(Time.get_unix_time_from_datetime_dict({
		"year": 2026, "month": 8, "day": 3,
		"hour": 0, "minute": 0, "second": 0
	}))
	var week_33_start := week_32_start + 7 * 86400
	var week_34_start := week_33_start + 7 * 86400
	assert(ChallengeCatalogScript.cycle_for_unix_time(week_32_start).id == "2026-W32")
	assert(ChallengeCatalogScript.cycle_for_unix_time(
		week_32_start + 7 * 86400 - 1
	).id == "2026-W32")
	assert(ChallengeCatalogScript.cycle_for_unix_time(week_33_start).id == "2026-W33")
	assert(ChallengeCatalogScript.active_for_unix_time(week_32_start).id == "iron_trial")
	assert(ChallengeCatalogScript.active_for_unix_time(
		week_33_start
	).id == "overclock_gauntlet")
	assert(ChallengeCatalogScript.active_for_unix_time(week_34_start).id == "null_hunt")
	var year_boundary := int(Time.get_unix_time_from_datetime_dict({
		"year": 2025, "month": 12, "day": 31,
		"hour": 12, "minute": 0, "second": 0
	}))
	assert(ChallengeCatalogScript.cycle_for_unix_time(year_boundary).id == "2026-W01")
	assert(ChallengeCatalogScript.claim_id(
		"2026-W32", "iron_trial"
	) == "challenge:2026-W32:iron_trial")
	assert(ChallengeCatalogScript.claim_id("bad-cycle", "iron_trial").is_empty())
	assert(not ChallengeCatalogScript.is_valid_claim_id("challenge:2026-W54:iron_trial"))
	# Completion records sanitize malformed and duplicate values.
	var challenge_config := ConfigFile.new()
	var week_34_claim := "challenge:2026-W34:null_hunt"
	challenge_config.set_value("challenges", "completed_claim_ids", [
		"", "invalid", week_34_claim, week_34_claim
	])
	assert(challenge_config.save(ChallengeStoreScript.SAVE_PATH) == OK)
	assert(ChallengeStoreScript.load_completed_claim_ids() == [week_34_claim])
	assert(ChallengeStoreScript.is_completed("2026-W34", "null_hunt"))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(ChallengeStoreScript.SAVE_PATH))
	# A first clear grants 250 Credits once. Repeats preserve completion without
	# paying again, and the wallet claim can recover a missing challenge save.
	var challenge_currency := ChallengeStoreScript.record_victory(week_32_start)
	assert(challenge_currency.completed and challenge_currency.first_clear)
	assert(challenge_currency.claim_id == "challenge:2026-W32:iron_trial")
	assert(challenge_currency.reward_amount == 250 and challenge_currency.balance == 1350)
	assert(ChallengeStoreScript.load_completed_claim_ids() == [
		"challenge:2026-W32:iron_trial"
	])
	var completed_challenge := ChallengeStoreScript.active_status(week_32_start)
	assert(completed_challenge.completed and not completed_challenge.reward_available)
	var repeat_challenge := ChallengeStoreScript.record_victory(week_32_start)
	assert(repeat_challenge.completed and not repeat_challenge.first_clear)
	assert(repeat_challenge.reward_amount == 0 and repeat_challenge.balance == 1350)
	DirAccess.remove_absolute(ProjectSettings.globalize_path(ChallengeStoreScript.SAVE_PATH))
	assert(ChallengeStoreScript.is_completed("2026-W32", "iron_trial"))
	assert(not ChallengeStoreScript.is_completed(
		"2026-W33", "overclock_gauntlet"
	))
	assert(RequisitionStoreScript.has_claimed(
		"challenge:2026-W32:iron_trial"
	))
	assert(RequisitionStoreScript.load_balance() == 1350)
	assert(RequisitionStoreScript.pull_cost(1) == 100)
	assert(RequisitionStoreScript.pull_cost(10) == 1000)
	assert(RequisitionStoreScript.pull_cost(2) == -1)
	var full_campaign_currency := (
		RequisitionStoreScript.STARTER_GRANT
		+ CampaignStoreScript.MISSIONS.size()
		* RequisitionStoreScript.CAMPAIGN_MILESTONE_GRANT
	)
	assert(full_campaign_currency == 8700)
	assert(full_campaign_currency / RequisitionStoreScript.SINGLE_PULL_COST == 87)
	var ten_pull_spend := RequisitionStoreScript.spend(1000)
	assert(ten_pull_spend.spent and ten_pull_spend.balance == 350)
	var rejected_spend := RequisitionStoreScript.spend(1000)
	assert(not rejected_spend.spent and rejected_spend.balance == 350)
	assert(RequisitionStoreScript.load_balance() == 350)
	DirAccess.remove_absolute(ProjectSettings.globalize_path(ChallengeStoreScript.SAVE_PATH))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(RequisitionStoreScript.SAVE_PATH))
	assert(CampaignStoreScript.reward_summary(2) == "Random: Relay Bastion-001, Relay Blade-002, Relay Lancer-003, Helio Mender-049, Cinder Blade-015")
	assert(CampaignStoreScript.reward_summary(3) == "Random: Relay Battery-004, Relay Weaver-005, Relay Mender-006, Zephyr Lancer-037")
	assert(CampaignStoreScript.reward_summary(7) == "Random: Relay Weaver-005, Relay Lancer-009, Relay Bastion-001, Cinder Blade-015, Cinder Lancer-017, Cinder Lancer-018, Zephyr Mender-208, Zephyr Mender-209")
	var training_rewards: Array = CampaignStoreScript.reward_options(0, roster)
	assert(training_rewards.size() == 3)
	assert(is_equal_approx(training_rewards[0].chance, 1.0 / 3.0))
	assert(is_equal_approx(training_rewards[1].chance, 1.0 / 3.0))
	assert(is_equal_approx(training_rewards[2].chance, 1.0 / 3.0))
	var ignition_rewards: Array = CampaignStoreScript.reward_options(3, roster)
	assert(ignition_rewards.size() == 4)
	assert(is_equal_approx(ignition_rewards[0].chance, 4.0 / 13.0))
	assert(is_equal_approx(ignition_rewards[1].chance, 4.0 / 13.0))
	assert(is_equal_approx(ignition_rewards[2].chance, 4.0 / 13.0))
	assert(is_equal_approx(ignition_rewards[3].chance, 1.0 / 13.0))
	# Every mission pool keeps at least three 1-star units so 4-star and higher
	# drops stay rare under the weighted roll.
	for mission in CampaignStoreScript.MISSIONS:
		var one_star_count := 0
		for unit_name in mission.reward_pool:
			var reward_unit := UnitCatalogScript.by_name(unit_name)
			if reward_unit != null and reward_unit.stars == 1:
				one_star_count += 1
		assert(one_star_count >= 3)
	assert(CampaignStoreScript.reward_summary(6) == "Random: Relay Bastion-007, Relay Blade-008, Relay Lancer-009, Zephyr Lancer-037, Flux Weaver-045")
	assert("Relay Bastion-014" in CampaignStoreScript.MISSIONS[10].reward_pool)
	assert("Cinder Lancer-018" in CampaignStoreScript.MISSIONS[7].reward_pool)
	assert("Flux Lancer-031" in CampaignStoreScript.MISSIONS[27].reward_pool)
	assert("Helio Mender-049" in CampaignStoreScript.MISSIONS[2].reward_pool)
	assert("Helio Mender-050" in CampaignStoreScript.MISSIONS[9].reward_pool)
	assert("Flux Bastion-053" in CampaignStoreScript.MISSIONS[17].reward_pool)
	assert("Flux Bastion-054" in CampaignStoreScript.MISSIONS[17].reward_pool)
	assert("Cinder Battery-063" in CampaignStoreScript.MISSIONS[8].reward_pool)
	assert("Cinder Battery-064" in CampaignStoreScript.MISSIONS[49].reward_pool)
	assert("Cinder Battery-066" in CampaignStoreScript.MISSIONS[52].reward_pool)
	assert("Cinder Battery-067" in CampaignStoreScript.MISSIONS[60].reward_pool)
	assert("Cinder Lancer-069" in CampaignStoreScript.MISSIONS[13].reward_pool)
	assert("Zephyr Blade-075" in CampaignStoreScript.MISSIONS[18].reward_pool)
	assert("Zephyr Blade-076" in CampaignStoreScript.MISSIONS[14].reward_pool)
	assert("Zephyr Battery-088" in CampaignStoreScript.MISSIONS[9].reward_pool)
	assert("Zephyr Battery-089" in CampaignStoreScript.MISSIONS[22].reward_pool)
	assert("Cinder Weaver-090" in CampaignStoreScript.MISSIONS[26].reward_pool)
	assert("Cinder Weaver-091" in CampaignStoreScript.MISSIONS[28].reward_pool)
	assert("Flux Weaver-092" in CampaignStoreScript.MISSIONS[20].reward_pool)
	assert("Flux Weaver-093" in CampaignStoreScript.MISSIONS[55].reward_pool)
	assert("Brass Bastion-104" in CampaignStoreScript.MISSIONS[37].reward_pool)
	assert("Brass Bastion-105" in CampaignStoreScript.MISSIONS[37].reward_pool)
	assert("Brass Bastion-111" in CampaignStoreScript.MISSIONS[9].reward_pool)
	assert("Brass Bastion-111" in CampaignStoreScript.MISSIONS[61].reward_pool)
	assert("Brass Bastion-112" in CampaignStoreScript.MISSIONS[18].reward_pool)
	assert("Zephyr Bastion-113" in CampaignStoreScript.MISSIONS[19].reward_pool)
	assert("Zephyr Bastion-114" in CampaignStoreScript.MISSIONS[43].reward_pool)
	assert("Cinder Weaver-115" in CampaignStoreScript.MISSIONS[35].reward_pool)
	assert("Cinder Weaver-116" in CampaignStoreScript.MISSIONS[35].reward_pool)
	assert("Brass Blade-117" in CampaignStoreScript.MISSIONS[15].reward_pool)
	assert("Brass Blade-118" in CampaignStoreScript.MISSIONS[32].reward_pool)
	assert("Helio Mender-126" in CampaignStoreScript.MISSIONS[41].reward_pool)
	assert("Helio Mender-127" in CampaignStoreScript.MISSIONS[41].reward_pool)
	assert("Zephyr Mender-208" in CampaignStoreScript.MISSIONS[7].reward_pool)
	assert("Zephyr Mender-208" in CampaignStoreScript.MISSIONS[44].reward_pool)
	assert("Zephyr Mender-209" in CampaignStoreScript.MISSIONS[47].reward_pool)
	assert("Cinder Mender-213" in CampaignStoreScript.MISSIONS[10].reward_pool)
	assert("Cinder Mender-213" in CampaignStoreScript.MISSIONS[46].reward_pool)
	assert("Cinder Mender-214" in CampaignStoreScript.MISSIONS[46].reward_pool)
	assert("Relay Battery-217" in CampaignStoreScript.MISSIONS[17].reward_pool)
	assert("Relay Battery-218" in CampaignStoreScript.MISSIONS[44].reward_pool)
	assert("Cinder Bastion-219" in CampaignStoreScript.MISSIONS[25].reward_pool)
	assert("Cinder Bastion-220" in CampaignStoreScript.MISSIONS[54].reward_pool)
	assert("Zephyr Lancer-221" in CampaignStoreScript.MISSIONS[21].reward_pool)
	assert("Zephyr Lancer-222" in CampaignStoreScript.MISSIONS[50].reward_pool)
	assert("Helio Mender-223" in CampaignStoreScript.MISSIONS[29].reward_pool)
	assert("Helio Mender-224" in CampaignStoreScript.MISSIONS[59].reward_pool)
	assert("Relay Bastion-030" in CampaignStoreScript.MISSIONS[15].reward_pool)
	assert("Cinder Blade-036" in CampaignStoreScript.MISSIONS[23].reward_pool)
	assert("Zephyr Lancer-042" in CampaignStoreScript.MISSIONS[31].reward_pool)
	assert("Flux Weaver-047" in CampaignStoreScript.MISSIONS[39].reward_pool)
	assert("Helio Mender-048" in CampaignStoreScript.MISSIONS[47].reward_pool)
	# Campaign reward rolls can grant the four new reward units.
	assert(CampaignStoreScript.roll_reward(7, roster, 0.85) == "Zephyr Mender-208")
	assert(CampaignStoreScript.roll_reward(7, roster, 0.99) == "Zephyr Mender-209")
	assert(CampaignStoreScript.roll_reward(46, roster, 0.95) == "Cinder Mender-213")
	assert(CampaignStoreScript.roll_reward(46, roster, 0.99) == "Cinder Mender-214")
	assert("Helio Mender-126" in CampaignStoreScript.MISSIONS[53].reward_pool)
	assert("Helio Mender-127" in CampaignStoreScript.MISSIONS[53].reward_pool)
	for mission in CampaignStoreScript.MISSIONS:
		assert("Brass Weaver-034" not in mission.reward_pool)
		assert("Relay Blade-035" not in mission.reward_pool)
		assert("Zephyr Battery-039" not in mission.reward_pool)
		assert("Zephyr Battery-040" not in mission.reward_pool)
		assert("Zephyr Lancer-041" not in mission.reward_pool)
		assert("Helio Weaver-055" not in mission.reward_pool)
		assert("Helio Weaver-056" not in mission.reward_pool)
		assert("Brass Mender-051" not in mission.reward_pool)
		assert("Brass Mender-052" not in mission.reward_pool)
		assert("Helio Battery-057" not in mission.reward_pool)
		assert("Helio Battery-058" not in mission.reward_pool)
		assert("Zephyr Weaver-059" not in mission.reward_pool)
		assert("Zephyr Weaver-060" not in mission.reward_pool)
		assert("Helio Battery-061" not in mission.reward_pool)
		assert("Helio Battery-062" not in mission.reward_pool)
		assert("Cinder Battery-065" not in mission.reward_pool)
		assert("Cinder Battery-068" not in mission.reward_pool)
		assert("Cinder Lancer-070" not in mission.reward_pool)
		assert("Zephyr Mender-071" not in mission.reward_pool)
		assert("Zephyr Mender-072" not in mission.reward_pool)
		assert("Flux Blade-073" not in mission.reward_pool)
		assert("Flux Blade-074" not in mission.reward_pool)
		assert("Brass Lancer-077" not in mission.reward_pool)
		assert("Brass Lancer-078" not in mission.reward_pool)
		assert("Flux Lancer-079" not in mission.reward_pool)
		assert("Flux Lancer-080" not in mission.reward_pool)
		assert("Relay Blade-094" not in mission.reward_pool)
		assert("Relay Blade-095" not in mission.reward_pool)
		assert("Brass Bastion-096" not in mission.reward_pool)
		assert("Brass Bastion-097" not in mission.reward_pool)
		assert("Brass Battery-098" not in mission.reward_pool)
		assert("Brass Battery-099" not in mission.reward_pool)
		assert("Relay Blade-100" not in mission.reward_pool)
		assert("Relay Blade-101" not in mission.reward_pool)
		assert("Helio Mender-102" not in mission.reward_pool)
		assert("Helio Mender-103" not in mission.reward_pool)
		assert("Brass Bastion-106" not in mission.reward_pool)
		assert("Flux Weaver-107" not in mission.reward_pool)
		assert("Flux Weaver-108" not in mission.reward_pool)
		assert("Zephyr Lancer-109" not in mission.reward_pool)
		assert("Zephyr Lancer-110" not in mission.reward_pool)
		assert("Flux Weaver-188" not in mission.reward_pool)
		assert("Flux Weaver-189" not in mission.reward_pool)
		assert("Cinder Battery-190" not in mission.reward_pool)
		assert("Cinder Battery-191" not in mission.reward_pool)
		assert("Flux Weaver-192" not in mission.reward_pool)
		assert("Flux Weaver-193" not in mission.reward_pool)
		assert("Flux Mender-194" not in mission.reward_pool)
		assert("Flux Mender-195" not in mission.reward_pool)
	var rarity_candidates := [
		{"name": "One Star", "stars": 1},
		{"name": "Five Star", "stars": 5}
	]
	assert(CampaignStoreScript.choose_weighted_reward(rarity_candidates, 0.93) == "One Star")
	assert(CampaignStoreScript.choose_weighted_reward(rarity_candidates, 0.99) == "Five Star")
	var enemy_squad: Array = CampaignStoreScript.enemy_squad_names(2, 0, roster)
	assert(enemy_squad.size() == 8)
	var unique_enemy_cards: Array = []
	for card_name in enemy_squad:
		if card_name not in unique_enemy_cards:
			unique_enemy_cards.append(card_name)
	assert(unique_enemy_cards.size() == 8)
	assert(enemy_squad != CampaignStoreScript.enemy_squad_names(3, 0, roster))
	assert(CampaignStoreScript.encounter(0, 0).enemy_squad.size() == 8)
	var enemy_squad_signatures: Array[String] = []
	var roster_names: Array = roster.map(func(unit): return unit.name)
	for mission in CampaignStoreScript.MISSIONS:
		var configured_squad: Array = mission.encounters[0].enemy_squad
		assert(configured_squad.size() == 8)
		assert(configured_squad.all(func(unit_name): return unit_name in roster_names))
		assert(configured_squad.all(
			func(unit_name): return configured_squad.count(unit_name) <= 2
		))
		var signature := "|".join(configured_squad)
		assert(signature not in enemy_squad_signatures)
		enemy_squad_signatures.append(signature)
	assert(enemy_squad_signatures.size() == 77)

	var mover := {"id": 1, "side": 0, "kind": "Duelist", "row": 1, "col": 2, "repositioned": false, "taunt_turns": 0}
	var distant_warden := {"id": 2, "side": 1, "kind": "Warden", "row": 1, "col": 5, "repositioned": false}
	assert(not BattleRulesScript.is_taunted(mover, [mover, distant_warden]))
	assert(BattleRulesScript.can_reposition(mover, 0, [mover, distant_warden]))
	var nearby_warden := {"id": 3, "side": 1, "kind": "Warden", "row": 1, "col": 4, "repositioned": false}
	BattleRulesScript.apply_taunt(mover)
	assert(BattleRulesScript.is_taunted(mover, [mover, nearby_warden]))
	assert(not BattleRulesScript.can_reposition(mover, 0, [mover, nearby_warden]))
	BattleRulesScript.expire_taunts([mover], 0)
	assert(mover.taunt_turns == 1)
	assert(BattleRulesScript.is_taunted(mover, [mover]))
	BattleRulesScript.expire_taunts([mover], 0)
	assert(not BattleRulesScript.is_taunted(mover, [mover]))
	mover.immobilized_turns = 1
	assert(BattleRulesScript.is_immobilized(mover))
	assert(not BattleRulesScript.can_reposition(mover, 0, [mover]))
	assert(BattleAIScript.choose_reposition(mover, [mover]) == mover.row)
	mover.immobilized_turns = 0
	assert(not BattleRulesScript.is_immobilized(mover))
	assert(BattleRulesScript.can_reposition(mover, 0, [mover]))
	var mission_blocks := [{"row": 0, "col": 2}, {"row": 1, "col": 3}]
	assert(not BattleRulesScript.can_reposition(mover, 0, [mover], mission_blocks))
	var terrain_mover := {
		"id": 99, "side": 0, "row": 1, "col": 2, "move": 2,
		"immobilized_turns": 0, "stun_turns": 0
	}
	assert(BattleRulesScript.traversal_cells(
		terrain_mover, [terrain_mover], mission_blocks
	).is_empty())
	var blocker := {"id": 4, "side": 0, "kind": "Strider", "row": 0, "col": 2, "repositioned": false}
	assert(not BattleRulesScript.can_reposition(mover, 0, [mover, blocker]))
	assert(not BattleRulesScript.can_reposition(mover, 2, [mover, {"id": 5, "side": 1, "kind": "Strider", "row": 2, "col": 2}]))
	var top_lane_mover := {
		"id": 50, "side": 0, "kind": "Duelist", "row": 0, "col": 2,
		"repositioned": false, "taunt_turns": 0
	}
	assert(BattleRulesScript.can_reposition(top_lane_mover, 2, [top_lane_mover]))
	var friendly_between := {
		"id": 7, "side": 0, "kind": "Strider", "row": 1, "col": 2
	}
	assert(BattleRulesScript.can_reposition(top_lane_mover, 2, [top_lane_mover, friendly_between]))
	var enemy_between := {
		"id": 8, "side": 1, "kind": "Strider", "row": 1, "col": 2
	}
	assert(not BattleRulesScript.can_reposition(top_lane_mover, 2, [top_lane_mover, enemy_between]))
	top_lane_mover.repositioned = true
	assert(BattleRulesScript.can_reposition(top_lane_mover, 2, [top_lane_mover]))
	var middle_lane_blocker := {
		"id": 51, "side": 1, "kind": "Warden", "row": 1, "col": 2
	}
	assert(not BattleRulesScript.can_reposition(
		top_lane_mover, 2, [top_lane_mover, middle_lane_blocker]
	))
	assert(BattleAIScript.choose_reposition(top_lane_mover, [top_lane_mover]) == 0)
	assert(BattleAIScript.should_use_conductor_skill(
		"Shield", 4, 18, []
	))

	# Repositioning priorities: opening a rail toward the opposing Conductor
	# outranks trading blows with a lane blocker that is not lethal.
	var rail_attacker := {
		"id": 60, "side": 1, "kind": "Duelist", "row": 1, "col": 3,
		"atk": 3, "hp": 5, "max_hp": 5, "move": 2, "range": 1,
		"repositioned": false, "taunt_turns": 0
	}
	var lane_bully := {
		"id": 61, "side": 0, "kind": "Warden", "row": 1, "col": 2,
		"atk": 2, "hp": 8, "max_hp": 8, "move": 1, "range": 1
	}
	assert(BattleAIScript.choose_reposition(
		rail_attacker, [rail_attacker, lane_bully], [], 20
	) == 0)
	# A lethal rail toward our own Conductor outranks opening one: the guard
	# interposes on lane 3 only while the striker's damage can kill.
	var rail_guard := {
		"id": 62, "side": 1, "kind": "Warden", "row": 0, "col": 5,
		"atk": 2, "hp": 9, "max_hp": 9, "move": 1, "range": 1,
		"repositioned": false, "taunt_turns": 0
	}
	var rail_striker := {
		"id": 63, "side": 0, "kind": "Strider", "row": 2, "col": 4,
		"atk": 6, "hp": 4, "max_hp": 4, "move": 3, "range": 1
	}
	assert(BattleAIScript.choose_reposition(
		rail_guard, [rail_guard, rail_striker], [], 12
	) == 2)
	assert(BattleAIScript.choose_reposition(
		rail_guard, [rail_guard, rail_striker], [], 20
	) == 0)
	# A defender already standing ahead of the striker breaks the lethal rail,
	# so the guard keeps attacking instead of shuffling lanes.
	var rail_anchor := {
		"id": 64, "side": 1, "kind": "Duelist", "row": 2, "col": 6,
		"atk": 3, "hp": 5, "max_hp": 5, "move": 2, "range": 1
	}
	assert(BattleAIScript.choose_reposition(
		rail_guard, [rail_guard, rail_striker, rail_anchor], [], 12
	) == 0)

	var mana_units := [
		{"side": 0, "cost": 2},
		{"side": 0, "cost": 3},
		{"side": 1, "cost": 4}
	]
	assert(BattleRulesScript.locked_mana(mana_units, 0) == 5)
	assert(BattleRulesScript.available_mana(8, mana_units, 0) == 3)
	assert(BattleRulesScript.available_mana(10, [mana_units[1]], 0) == 7)
	assert(BattleRulesScript.locked_mana([
		{"side": 0, "cost": 4, "locks_mana": false}
	], 0) == 0)

	var skill_ally := {
		"id": 20, "side": 0, "name": "Test Ally", "atk": 2,
		"hp": 3, "max_hp": 5, "effects": [], "taunted_by": -1
	}
	var skill_enemy := {
		"id": 21, "side": 1, "name": "Test Enemy", "atk": 4,
		"hp": 6, "max_hp": 6, "effects": [], "taunted_by": -1
	}
	var skill_units := [skill_ally, skill_enemy]
	var rally: Dictionary = ConductorSkillsScript.apply("Rally", 0, skill_units, 20)
	assert(rally.success)
	assert(skill_ally.atk == 3)
	assert("Rally (1 turn)" in ConductorSkillsScript.effect_summary(skill_ally))
	ConductorSkillsScript.expire_effects(skill_units, 0)
	assert(skill_ally.atk == 2)
	assert(skill_ally.effects.is_empty())
	var aid: Dictionary = ConductorSkillsScript.apply("Aid", 0, skill_units, 20)
	assert(aid.success and skill_ally.hp == 5)
	var shield: Dictionary = ConductorSkillsScript.apply("Shield", 0, skill_units, 20)
	assert(shield.success and shield.shield == 5 and shield.shield_turns == 2)
	assert(not ConductorSkillsScript.apply("Last Stand", 0, skill_units, 9).success)
	assert(ConductorSkillsScript.apply("Last Stand", 0, skill_units, 8).success)
	ConductorSkillsScript.expire_effects(skill_units, 0)
	var firestorm: Dictionary = ConductorSkillsScript.apply("Firestorm", 0, skill_units, 20)
	assert(firestorm.success and skill_enemy.hp == 4)

	var builder := {
		"id": 30, "side": 0, "name": "Relay Bastion-013", "atk": 2,
		"hp": 4, "max_hp": 4, "effects": [],
		"skill": {"name": "Brace Protocol", "type": "Warcry"}
	}
	var fortify_ally := {
		"id": 31, "side": 0, "name": "Ally", "atk": 2,
		"hp": 2, "max_hp": 5, "effects": []
	}
	var warcry_enemy := {
		"id": 32, "side": 1, "name": "Enemy", "atk": 2,
		"hp": 6, "max_hp": 6, "effects": []
	}
	var warcry_units := [builder, fortify_ally, warcry_enemy]
	assert(not UnitSkillsScript.resolve_warcry(builder, warcry_units).message.is_empty())
	assert(fortify_ally.hp == 5 and fortify_ally.max_hp == 8)
	ConductorSkillsScript.expire_effects(warcry_units, 0)
	assert(fortify_ally.max_hp == 8)
	ConductorSkillsScript.expire_effects(warcry_units, 0)
	assert(fortify_ally.hp == 5 and fortify_ally.max_hp == 5)

	var brute := {
		"id": 33, "side": 0, "name": "Cinder Blade-015", "atk": 2,
		"hp": 4, "max_hp": 4, "effects": [],
		"skill": {"name": "Overclock Link", "type": "Warcry"}
	}
	assert(not UnitSkillsScript.resolve_warcry(brute, [brute, fortify_ally]).message.is_empty())
	assert(fortify_ally.atk == 3)
	var empower_target := {
		"id": 41, "side": 0, "name": "Chosen Ally", "atk": 1,
		"hp": 4, "max_hp": 4, "effects": []
	}
	assert(not UnitSkillsScript.resolve_warcry(
		brute, [brute, fortify_ally, empower_target], 41
	).message.is_empty())
	assert(empower_target.atk == 2)
	var gunner := {
		"id": 34, "side": 0, "name": "Flux Battery-019", "atk": 3,
		"hp": 2, "max_hp": 2, "effects": [],
		"skill": {"name": "Arc Lance", "type": "Warcry"}
	}
	assert(not UnitSkillsScript.resolve_warcry(gunner, [gunner, warcry_enemy]).message.is_empty())
	assert(warcry_enemy.hp == 5)
	var misfortune_actor := {
		"id": 37, "side": 0, "name": "Brass Lancer-043", "atk": 2,
		"hp": 2, "max_hp": 2, "effects": [],
		"skill": {"name": "Signal Jam", "type": "Warcry"}
	}
	var enemy_scout := {
		"id": 38, "side": 1, "name": "Enemy Scout", "kind": "Strider",
		"atk": 5, "hp": 4, "max_hp": 4, "effects": []
	}
	var enemy_gunner := {
		"id": 39, "side": 1, "name": "Enemy Gunner", "kind": "Artillerist",
		"atk": 4, "hp": 4, "max_hp": 4, "effects": []
	}
	var enemy_fighter := {
		"id": 40, "side": 1, "name": "Enemy Fighter", "kind": "Duelist",
		"atk": 8, "hp": 4, "max_hp": 4, "effects": []
	}
	var misfortune_units := [
		misfortune_actor, enemy_scout, enemy_gunner, enemy_fighter
	]
	assert(not UnitSkillsScript.resolve_warcry(
		misfortune_actor, misfortune_units
	).message.is_empty())
	assert(enemy_scout.atk == 4)
	assert(enemy_gunner.atk == 4 and enemy_fighter.atk == 8)
	ConductorSkillsScript.expire_effects(misfortune_units, 1)
	assert(enemy_scout.atk == 4)
	ConductorSkillsScript.expire_effects(misfortune_units, 1)
	assert(enemy_scout.atk == 5)
	var mend_actor := {
		"id": 41, "side": 0, "name": "Helio Mender-049", "kind": "Lifebinder",
		"atk": 2, "hp": 3, "max_hp": 3, "effects": [],
		"skill": {"name": "Repair Pulse", "type": "Warcry"}
	}
	var mend_target := {
		"id": 42, "side": 0, "name": "Wounded Ally", "kind": "Duelist",
		"atk": 2, "hp": 2, "max_hp": 5, "effects": []
	}
	var mend_result := UnitSkillsScript.resolve_warcry(
		mend_actor, [mend_actor, mend_target]
	)
	assert(not mend_result.message.is_empty())
	assert(mend_target.hp == 5)
	var plague_actor := {
		"id": 43, "side": 0, "name": "Brass Mender-051", "kind": "Lifebinder",
		"atk": 2, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Corrosion Bloom", "type": "Warcry"}
	}
	var plague_ally := {
		"id": 44, "side": 0, "name": "Plagued Ally", "kind": "Duelist",
		"atk": 2, "hp": 5, "max_hp": 5, "effects": []
	}
	var plague_enemy := {
		"id": 45, "side": 1, "name": "Plagued Enemy", "kind": "Warden",
		"atk": 2, "hp": 5, "max_hp": 5, "effects": []
	}
	var plague_units := [plague_actor, plague_ally, plague_enemy]
	var plague_result := UnitSkillsScript.resolve_warcry(plague_actor, plague_units)
	assert(plague_result.affected.size() == 2)
	assert(plague_actor.hp == 6)
	assert(plague_ally.hp == 4 and plague_enemy.hp == 4)
	assert(plague_ally.poison_turns == 2 and plague_enemy.poison_turns == 2)
	assert(UnitSkillsScript.resolve_start_statuses(1, plague_units).size() == 1)
	assert(plague_enemy.hp == 3 and plague_enemy.poison_turns == 1)
	assert(UnitSkillsScript.resolve_start_statuses(1, plague_units).size() == 1)
	assert(plague_enemy.hp == 2 and plague_enemy.poison_turns == 0)
	var envenom_actor := {
		"id": 46, "side": 0, "name": "Helio Battery-057", "kind": "Artillerist",
		"atk": 4, "hp": 3, "max_hp": 3, "effects": [],
		"skill": {"name": "Toxin Injector", "type": "Warcry"}
	}
	var envenom_target := {
		"id": 47, "side": 1, "name": "Chosen Enemy", "kind": "Channeler",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	var envenom_other := {
		"id": 48, "side": 1, "name": "Other Enemy", "kind": "Warden",
		"atk": 5, "hp": 8, "max_hp": 8, "effects": []
	}
	var envenom_result := UnitSkillsScript.resolve_warcry(
		envenom_actor, [envenom_actor, envenom_target, envenom_other], 47
	)
	assert(envenom_result.affected == [47])
	assert(envenom_target.poison_turns == 2)
	assert(not envenom_other.has("poison_turns"))
	var pin_actor := {
		"id": 49, "side": 0, "name": "Cinder Battery-063", "kind": "Artillerist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Anchor Shot", "type": "Warcry"}
	}
	var pin_result := UnitSkillsScript.resolve_warcry(
		pin_actor, [pin_actor, envenom_target, envenom_other]
	)
	assert(pin_result.affected == [48])
	assert(envenom_other.hp == 7 and envenom_other.immobilized_turns == 1)
	var demoralize_actor := {
		"id": 50, "side": 0, "name": "Cinder Lancer-069", "kind": "Strider",
		"atk": 2, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Suppression Field", "type": "Warcry"}
	}
	var lane_fighter := {
		"id": 51, "side": 1, "name": "Lane Fighter", "kind": "Duelist",
		"row": 2, "atk": 5, "hp": 5, "max_hp": 5, "effects": []
	}
	var lane_mage := {
		"id": 52, "side": 1, "name": "Lane Mage", "kind": "Channeler",
		"row": 2, "atk": 6, "hp": 5, "max_hp": 5, "effects": []
	}
	var lane_defender := {
		"id": 55, "side": 1, "name": "Lane Defender", "kind": "Warden",
		"row": 2, "atk": 3, "hp": 8, "max_hp": 8, "effects": []
	}
	var other_lane_scout := {
		"id": 53, "side": 1, "name": "Other Scout", "kind": "Strider",
		"row": 1, "atk": 4, "hp": 5, "max_hp": 5, "effects": []
	}
	var debuff_units := [
		demoralize_actor, lane_fighter, lane_mage, lane_defender, other_lane_scout
	]
	var demoralize_result := UnitSkillsScript.resolve_warcry(
		demoralize_actor, debuff_units, -1, null, 2
	)
	assert(demoralize_result.affected == [51, 55])
	assert(
		lane_fighter.atk == 4 and lane_defender.atk == 2
		and lane_mage.atk == 6 and other_lane_scout.atk == 4
	)
	var deploy_preview := BattleRulesScript.projected_deployment(
		{"move": 3, "range": 1}, 0, []
	)
	assert(deploy_preview.traversal == [
		Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0)
	])
	assert(deploy_preview.attack == [Vector2i(4, 0)])
	var blocked_deploy_preview := BattleRulesScript.projected_deployment(
		{"move": 3, "range": 1}, 0,
		[{"id": 90, "side": 1, "row": 0, "col": 2, "ready": true, "move": 1, "range": 1}]
	)
	assert(blocked_deploy_preview.traversal == [Vector2i(1, 0)])
	assert(blocked_deploy_preview.attack == [Vector2i(2, 0)])
	var punish_actor := {
		"id": 54, "side": 0, "name": "Zephyr Blade-075", "kind": "Duelist",
		"atk": 4, "hp": 4, "max_hp": 4, "effects": [],
		"skill": {"name": "Countermeasure", "type": "Warcry"}
	}
	var punish_result := UnitSkillsScript.resolve_warcry(
		punish_actor, debuff_units + [punish_actor]
	)
	assert(punish_result.affected == [52])
	assert(lane_mage.atk == 5)
	ConductorSkillsScript.expire_effects(debuff_units, 1)
	ConductorSkillsScript.expire_effects(debuff_units, 1)
	assert(lane_fighter.atk == 5 and lane_mage.atk == 6)
	var pupil := {
		"id": 36, "side": 0, "name": "Relay Weaver-021", "atk": 3,
		"hp": 2, "max_hp": 2, "effects": [],
		"skill": {"name": "Relay Storm", "type": "Warcry"}
	}
	assert(not UnitSkillsScript.resolve_warcry(pupil, [pupil, warcry_enemy]).message.is_empty())
	assert(warcry_enemy.hp == 4)
	var skirmisher := {
		"id": 35, "side": 0, "name": "Cinder Lancer-017", "atk": 2,
		"hp": 3, "max_hp": 3, "effects": [],
		"skill": {"name": "Locking Strike", "type": "Strike"}
	}
	assert(not UnitSkillsScript.resolve_strike(skirmisher, warcry_enemy, [], 0.29).message.is_empty())
	assert(warcry_enemy.immobilized_turns == 1)
	UnitSkillsScript.expire_statuses([warcry_enemy], 1)
	assert(warcry_enemy.immobilized_turns == 0)
	var poison_striker := {
		"id": 91, "side": 0, "name": "Helio Blade-081",
		"skill": {"name": "Corrosive Edge", "type": "Strike"}
	}
	assert(not UnitSkillsScript.resolve_strike(
		poison_striker, warcry_enemy, [], 0.49
	).message.is_empty())
	assert(warcry_enemy.poison_turns == 2)
	# Secondary-skill batch two (catalog icons 225-236): one carrier per skill,
	# exercised through every timing hook the batch uses. Fixtures carry no
	# rank tables, so rank_value fallbacks drive the magnitudes.
	var siphon_actor := {
		"id": 240, "side": 0, "name": "Cinder Blade-225", "kind": "Duelist",
		"atk": 4, "hp": 7, "max_hp": 7, "effects": [],
		"skill": {"name": "Siphon Edge", "type": "Strike"}
	}
	var siphon_target := {
		"id": 241, "side": 1, "name": "Siphon Target", "kind": "Warden",
		"atk": 3, "hp": 8, "max_hp": 8, "effects": []
	}
	var siphon_result := UnitSkillsScript.resolve_strike(
		siphon_actor, siphon_target, [siphon_actor, siphon_target], 0.5
	)
	assert(not siphon_result.message.is_empty())
	assert(siphon_target.atk == 2 and siphon_actor.atk == 5)
	assert(UnitSkillsScript.resolve_strike(
		siphon_actor, siphon_target, [siphon_actor, siphon_target], 0.99
	).message.is_empty())
	ConductorSkillsScript.expire_effects([siphon_target], 1)
	ConductorSkillsScript.expire_effects([siphon_target], 1)
	assert(siphon_target.atk == 3)
	ConductorSkillsScript.expire_effects([siphon_actor], 0)
	ConductorSkillsScript.expire_effects([siphon_actor], 0)
	ConductorSkillsScript.expire_effects([siphon_actor], 0)
	assert(siphon_actor.atk == 4)
	var lash_actor := {
		"id": 242, "side": 0, "name": "Flux Weaver-226", "kind": "Channeler",
		"atk": 4, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {"name": "Static Lash", "type": "Strike"}
	}
	assert(not UnitSkillsScript.resolve_strike(
		lash_actor, siphon_target, [lash_actor, siphon_target], 0.2
	).message.is_empty())
	assert(siphon_target.silenced_turns == 1)
	siphon_target.silenced_turns = 0
	assert(UnitSkillsScript.resolve_strike(
		lash_actor, siphon_target, [lash_actor, siphon_target], 0.9
	).message.is_empty())
	var shrapnel_actor := {
		"id": 243, "side": 0, "name": "Brass Battery-227", "kind": "Artillerist",
		"atk": 4, "hp": 6, "max_hp": 6, "effects": [], "row": 0, "col": 0,
		"skill": {"name": "Shrapnel Arc", "type": "Strike"}
	}
	var shrapnel_target := {
		"id": 244, "side": 1, "name": "Shrapnel Target", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": [], "row": 0, "col": 3
	}
	var shrapnel_victim := {
		"id": 245, "side": 1, "name": "Shrapnel Victim", "kind": "Strider",
		"atk": 2, "hp": 5, "max_hp": 5, "effects": [], "row": 0, "col": 4
	}
	var shrapnel_bystander := {
		"id": 246, "side": 1, "name": "Other Lane", "kind": "Strider",
		"atk": 2, "hp": 5, "max_hp": 5, "effects": [], "row": 1, "col": 3
	}
	var shrapnel_result := UnitSkillsScript.resolve_strike(
		shrapnel_actor, shrapnel_target,
		[shrapnel_actor, shrapnel_target, shrapnel_victim, shrapnel_bystander]
	)
	assert(shrapnel_result.affected == [245])
	assert(shrapnel_victim.hp == 4 and shrapnel_target.hp == 8)
	assert(shrapnel_bystander.hp == 5)
	var grudge_carrier := {
		"id": 247, "side": 0, "name": "Helio Bastion-228", "kind": "Warden",
		"atk": 2, "hp": 10, "max_hp": 10, "effects": [],
		"skill": {"name": "Grudge Capacitor", "type": "Reaction"}
	}
	var grudge_attacker := {
		"id": 248, "side": 1, "name": "Grudge Attacker", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	assert(not UnitSkillsScript.resolve_reaction(
		grudge_carrier, grudge_attacker, [grudge_carrier, grudge_attacker], 0.5
	).message.is_empty())
	assert(grudge_carrier.atk == 3)
	assert(UnitSkillsScript.resolve_reaction(
		grudge_carrier, grudge_attacker, [grudge_carrier, grudge_attacker], 0.99
	).message.is_empty())
	assert(grudge_carrier.atk == 3)
	var plating_carrier := {
		"id": 249, "side": 0, "name": "Cinder Bastion-229", "kind": "Warden",
		"atk": 3, "hp": 9, "max_hp": 9, "effects": [],
		"skill": {"name": "Mirror Plating", "type": "Reaction"}
	}
	var plating_result := UnitSkillsScript.resolve_reaction(
		plating_carrier, grudge_attacker, [plating_carrier, grudge_attacker]
	)
	assert(plating_result.affected == [248])
	assert(grudge_attacker.vulnerable_turns == 1)
	assert(grudge_attacker.vulnerable_stacks == 1)
	var uplink_actor := {
		"id": 250, "side": 0, "name": "Zephyr Lancer-230", "kind": "Strider",
		"atk": 3, "hp": 4, "max_hp": 4, "effects": [],
		"skill": {"name": "Command Uplink", "type": "Warcry"}
	}
	var uplink_warden := {
		"id": 251, "side": 0, "name": "Allied Warden", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var uplink_weaver := {
		"id": 252, "side": 0, "name": "Allied Weaver", "kind": "Channeler",
		"atk": 3, "hp": 4, "max_hp": 4, "effects": []
	}
	var uplink_result := UnitSkillsScript.resolve_warcry(
		uplink_actor, [uplink_actor, uplink_warden, uplink_weaver, grudge_attacker]
	)
	assert(uplink_result.affected == [251])
	assert(uplink_warden.haste_turns == 1)
	assert(uplink_weaver.get("haste_turns", 0) == 0)
	var blackout_actor := {
		"id": 253, "side": 0, "name": "Flux Weaver-231", "kind": "Channeler",
		"atk": 4, "hp": 6, "max_hp": 6, "effects": [], "row": 0, "col": 0,
		"skill": {"name": "Blackout Burst", "type": "Warcry"}
	}
	var blackout_target := {
		"id": 254, "side": 1, "name": "Lane One Enemy", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [], "row": 1, "col": 5
	}
	var blackout_bystander := {
		"id": 255, "side": 1, "name": "Lane Zero Enemy", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [], "row": 0, "col": 5
	}
	var blackout_result := UnitSkillsScript.resolve_warcry(
		blackout_actor,
		[blackout_actor, blackout_target, blackout_bystander], -1, null, 1
	)
	assert(blackout_result.affected == [254])
	assert(blackout_target.silenced_turns == 1)
	assert(blackout_bystander.get("silenced_turns", 0) == 0)
	var salvo_actor := {
		"id": 256, "side": 0, "name": "Helio Battery-232", "kind": "Artillerist",
		"atk": 4, "hp": 6, "max_hp": 6, "effects": [], "row": 0, "col": 0,
		"skill": {"name": "Seismic Salvo", "type": "Warcry"}
	}
	var salvo_target := {
		"id": 257, "side": 1, "name": "Salvo Target", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": [], "row": 0, "col": 3
	}
	var salvo_result := UnitSkillsScript.resolve_warcry(
		salvo_actor, [salvo_actor, salvo_target], -1, null, 0
	)
	assert(salvo_result.affected == [257])
	assert(salvo_target.hp == 7 and salvo_target.col == 4)
	assert(salvo_result.moved == [{"id": 257, "row": 0, "from_col": 3}])
	var drumbeat_carrier := {
		"id": 258, "side": 0, "name": "Brass Mender-233", "kind": "Lifebinder",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Rally Drumbeat", "type": "Chant"}
	}
	var drumbeat_protected := {
		"id": 259, "side": 0, "name": "Protected Ally", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": [], "protect_turns": 1
	}
	var drumbeat_exposed := {
		"id": 260, "side": 0, "name": "Exposed Ally", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var drumbeat_results := UnitSkillsScript.resolve_chants(
		0, [drumbeat_carrier, drumbeat_protected, drumbeat_exposed], "start"
	)
	assert(drumbeat_results.size() == 1)
	assert(drumbeat_results[0].affected == [259])
	assert(drumbeat_protected.atk == 3 and drumbeat_exposed.atk == 3)
	ConductorSkillsScript.expire_effects([drumbeat_protected], 0)
	assert(drumbeat_protected.atk == 2)
	var wind_carrier := {
		"id": 261, "side": 0, "name": "Zephyr Blade-234", "kind": "Duelist",
		"atk": 3, "hp": 2, "max_hp": 6, "effects": [],
		"skill": {"name": "Second Wind", "type": "Chant"}
	}
	var wind_results := UnitSkillsScript.resolve_chants(0, [wind_carrier], "start")
	assert(wind_results.size() == 1)
	assert(wind_carrier.regen_turns == 2 and wind_carrier.protect_turns == 2)
	wind_carrier.hp = 6
	assert(UnitSkillsScript.resolve_chants(0, [wind_carrier], "start").is_empty())
	var net_carrier := {
		"id": 262, "side": 0, "name": "Cinder Lancer-235", "kind": "Strider",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Interference Net", "type": "Chant"}
	}
	var net_victim := {
		"id": 263, "side": 1, "name": "Net Victim", "kind": "Duelist",
		"atk": 4, "hp": 6, "max_hp": 6, "effects": []
	}
	var net_results := UnitSkillsScript.resolve_chants(
		1, [net_carrier, net_victim], "start", null, -1.0, 263
	)
	assert(net_results.size() == 1)
	assert(net_results[0].affected == [263])
	assert(net_victim.atk == 2)
	ConductorSkillsScript.expire_effects([net_victim], 1)
	ConductorSkillsScript.expire_effects([net_victim], 1)
	assert(net_victim.atk == 4)
	assert(UnitSkillsScript.resolve_chants(
		0, [net_carrier, net_victim], "start", null, -1.0, 263
	).is_empty())
	var rhythm_carrier := {
		"id": 264, "side": 0, "name": "Helio Mender-236", "kind": "Lifebinder",
		"atk": 3, "hp": 4, "max_hp": 4, "effects": [],
		"skill": {"name": "Siege Rhythm", "type": "Aura"}
	}
	var rhythm_hasted := {
		"id": 265, "side": 0, "name": "Hasted Ally", "kind": "Strider",
		"atk": 2, "hp": 5, "max_hp": 5, "effects": [], "haste_turns": 1
	}
	var rhythm_plain := {
		"id": 266, "side": 0, "name": "Plain Ally", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var rhythm_units := [rhythm_carrier, rhythm_hasted, rhythm_plain]
	UnitSkillsScript.refresh_auras(rhythm_units)
	assert(rhythm_hasted.atk == 3 and rhythm_hasted.aura_atk == 1)
	assert(rhythm_plain.atk == 2)
	rhythm_carrier.hp = 0
	UnitSkillsScript.refresh_auras(rhythm_units)
	assert(rhythm_hasted.atk == 2 and rhythm_hasted.aura_atk == 0)
	# Secondary-skill batch three (catalog icons 237-251): faction-specialised
	# carriers, one per skill, including the class doctrines and Slow.
	var presence_actor := {
		"id": 270, "side": 0, "name": "Cinder Bastion-237", "kind": "Warden",
		"atk": 2, "hp": 10, "max_hp": 10, "effects": [], "row": 1, "col": 0,
		"skill": {"name": "Intimidating Presence", "type": "Warcry"}
	}
	var presence_lane_enemy := {
		"id": 271, "side": 1, "name": "Same Lane", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [], "row": 1, "col": 5
	}
	var presence_other_enemy := {
		"id": 272, "side": 1, "name": "Other Lane", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [], "row": 2, "col": 5
	}
	var presence_result := UnitSkillsScript.resolve_warcry(
		presence_actor, [presence_actor, presence_lane_enemy, presence_other_enemy]
	)
	assert(presence_result.affected == [271])
	assert(presence_lane_enemy.taunt_turns == 1)
	assert(presence_other_enemy.get("taunt_turns", 0) == 0)
	var harvest_carrier := {
		"id": 273, "side": 0, "name": "Cinder Mender-238", "kind": "Lifebinder",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {"name": "Venom Harvest", "type": "Chant"}
	}
	var harvest_poisoned := {
		"id": 274, "side": 1, "name": "Poisoned Enemy", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [], "poison_turns": 2, "poison_damage": 1
	}
	var harvest_clean := {
		"id": 275, "side": 1, "name": "Clean Enemy", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var harvest_results := UnitSkillsScript.resolve_chants(
		0, [harvest_carrier, harvest_poisoned, harvest_clean], "end"
	)
	assert(harvest_results.size() == 1)
	assert(harvest_results[0].affected == [274])
	assert(harvest_poisoned.hp == 5 and harvest_clean.hp == 6)
	assert(UnitSkillsScript.resolve_chants(
		0, [harvest_carrier, harvest_poisoned, harvest_clean], "start"
	).is_empty())
	var detonation_actor := {
		"id": 276, "side": 0, "name": "Cinder Weaver-239", "kind": "Channeler",
		"atk": 4, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {"name": "Corrosive Detonation", "type": "Warcry"}
	}
	var detonation_target := {
		"id": 277, "side": 1, "name": "Detonation Target", "kind": "Warden",
		"atk": 2, "hp": 9, "max_hp": 9, "effects": [], "poison_turns": 3, "poison_damage": 1
	}
	var detonation_result := UnitSkillsScript.resolve_warcry(
		detonation_actor, [detonation_actor, detonation_target], 277
	)
	assert(detonation_result.affected == [277])
	assert(detonation_target.hp == 6 and detonation_target.poison_turns == 0)
	var volatile_carrier := {
		"id": 278, "side": 0, "name": "Brass Battery-240", "kind": "Artillerist",
		"atk": 3, "hp": 0, "max_hp": 5, "effects": [],
		"skill": {"name": "Volatile Core", "type": "Reaction"}
	}
	var volatile_attacker := {
		"id": 279, "side": 1, "name": "Volatile Attacker", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var volatile_result := UnitSkillsScript.resolve_reaction(
		volatile_carrier, volatile_attacker, [volatile_carrier, volatile_attacker]
	)
	assert(volatile_result.affected == [279])
	assert(volatile_attacker.hp == 4)
	var execute_actor := {
		"id": 280, "side": 0, "name": "Brass Blade-241", "kind": "Duelist",
		"atk": 4, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {"name": "Execute Protocol", "type": "Strike"}
	}
	var execute_wounded := {
		"id": 281, "side": 1, "name": "Wounded Target", "kind": "Warden",
		"atk": 2, "hp": 2, "max_hp": 8, "effects": []
	}
	var execute_result := UnitSkillsScript.resolve_strike(
		execute_actor, execute_wounded, [execute_actor, execute_wounded]
	)
	assert(execute_result.affected == [281])
	assert(execute_wounded.hp == 1)
	execute_wounded.hp = 8
	assert(UnitSkillsScript.resolve_strike(
		execute_actor, execute_wounded, [execute_actor, execute_wounded]
	).message.is_empty())
	var feint_carrier := {
		"id": 282, "side": 0, "name": "Zephyr Lancer-243", "kind": "Strider",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {"name": "Feint Step", "type": "Reaction"}
	}
	var feint_attacker := {
		"id": 283, "side": 1, "name": "Feint Attacker", "kind": "Duelist",
		"atk": 4, "hp": 6, "max_hp": 6, "effects": []
	}
	var feint_result := UnitSkillsScript.resolve_reaction(
		feint_carrier, feint_attacker, [feint_carrier, feint_attacker]
	)
	assert(feint_carrier.haste_turns == 1 and feint_attacker.atk == 3)
	assert(feint_result.affected == [282, 283])
	ConductorSkillsScript.expire_effects([feint_attacker], 1)
	assert(feint_attacker.atk == 4)
	var purge_actor := {
		"id": 284, "side": 0, "name": "Zephyr Mender-244", "kind": "Lifebinder",
		"atk": 2, "hp": 4, "max_hp": 4, "effects": [],
		"skill": {"name": "Purge Wave", "type": "Warcry"}
	}
	var purge_ally := {
		"id": 285, "side": 0, "name": "Afflicted Ally", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": [],
		"stun_turns": 2, "poison_turns": 3, "poison_damage": 1, "immobilized_turns": 1
	}
	var purge_result := UnitSkillsScript.resolve_warcry(
		purge_actor, [purge_actor, purge_ally], 285
	)
	assert(purge_result.affected == [285])
	assert(purge_ally.stun_turns == 0 and purge_ally.poison_turns == 0)
	assert(purge_ally.immobilized_turns == 0 and purge_ally.regen_turns == 2)
	var knell_actor := {
		"id": 286, "side": 0, "name": "Flux Weaver-246", "kind": "Channeler",
		"atk": 4, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Death Knell", "type": "Warcry"}
	}
	var knell_target := {
		"id": 287, "side": 1, "name": "Doomed Enemy", "kind": "Warden",
		"atk": 2, "hp": 12, "max_hp": 12, "effects": []
	}
	var knell_result := UnitSkillsScript.resolve_warcry(
		knell_actor, [knell_actor, knell_target], 287
	)
	assert(knell_result.affected == [287])
	assert(knell_target.doom_turns == 4)
	for doom_tick in 4:
		UnitSkillsScript.expire_statuses([knell_target], 0)
	assert(knell_target.hp == 0)
	var frost_actor := {
		"id": 288, "side": 0, "name": "Flux Lancer-248", "kind": "Strider",
		"atk": 3, "hp": 4, "max_hp": 4, "effects": [],
		"skill": {"name": "Frostbrand Strike", "type": "Strike"}
	}
	var frost_target := {
		"id": 289, "side": 1, "name": "Frost Target", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [], "row": 0, "col": 4, "move": 2
	}
	assert(not UnitSkillsScript.resolve_strike(
		frost_actor, frost_target, [frost_actor, frost_target], 0.4
	).message.is_empty())
	assert(frost_target.slow_turns == 1)
	assert(BattleRulesScript.traversal_cells(frost_target, [frost_target]).size() == 1)
	UnitSkillsScript.expire_statuses([frost_target], 1)
	assert(frost_target.slow_turns == 0)
	assert(BattleRulesScript.traversal_cells(frost_target, [frost_target]).size() == 2)
	var doctrine_carrier := {
		"id": 290, "side": 0, "name": "Helio Bastion-249", "kind": "Warden",
		"atk": 2, "hp": 9, "max_hp": 9, "effects": [],
		"skill": {"name": "Rampart Doctrine", "type": "Aura"}
	}
	var doctrine_warden := {
		"id": 291, "side": 0, "name": "Allied Warden", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var doctrine_duelist := {
		"id": 292, "side": 0, "name": "Allied Duelist", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var doctrine_enemy_warden := {
		"id": 293, "side": 1, "name": "Enemy Warden", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var doctrine_units := [
		doctrine_carrier, doctrine_warden, doctrine_duelist, doctrine_enemy_warden
	]
	UnitSkillsScript.refresh_auras(doctrine_units)
	assert(doctrine_warden.atk == 3 and doctrine_warden.aura_atk == 1)
	assert(doctrine_duelist.atk == 3 and doctrine_duelist.get("aura_atk", 0) == 0)
	assert(doctrine_enemy_warden.atk == 2)
	var concussion_actor := {
		"id": 300, "side": 0, "name": "Cinder Blade-252", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Concussion Blow", "type": "Strike"}
	}
	var concussion_target := {
		"id": 301, "side": 1, "name": "Concussion Target", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var concussion_result := UnitSkillsScript.resolve_strike(
		concussion_actor, concussion_target, [concussion_actor, concussion_target], 0.2
	)
	assert(concussion_result.affected == [301])
	assert(concussion_target.stun_turns == 1)
	assert(UnitSkillsScript.resolve_strike(
		concussion_actor, concussion_target, [concussion_actor, concussion_target], 0.9
	).message.is_empty())
	var spike_actor := {
		"id": 302, "side": 0, "name": "Brass Blade-253", "kind": "Duelist",
		"atk": 4, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {"name": "Executioner Spike", "type": "Strike"}
	}
	var spike_target := {
		"id": 303, "side": 1, "name": "Spike Target", "kind": "Warden",
		"atk": 2, "hp": 6, "max_hp": 6, "effects": []
	}
	var spike_result := UnitSkillsScript.resolve_strike(
		spike_actor, spike_target, [spike_actor, spike_target], 0.2
	)
	assert(spike_result.affected == [303])
	assert(spike_target.hp == 4)
	assert(UnitSkillsScript.resolve_strike(
		spike_actor, spike_target, [spike_actor, spike_target], 0.9
	).message.is_empty())
	var breaker_actor := {
		"id": 304, "side": 0, "name": "Cinder Lancer-254", "kind": "Strider",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {"name": "Shieldbreaker", "type": "Strike"}
	}
	var breaker_target := {
		"id": 305, "side": 1, "name": "Shielded Target", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": [], "protect_turns": 2
	}
	var breaker_result := UnitSkillsScript.resolve_strike(
		breaker_actor, breaker_target, [breaker_actor, breaker_target]
	)
	assert(breaker_result.affected == [305])
	assert(breaker_target.protect_turns == 0 and breaker_target.hp == 7)
	var volley_actor := {
		"id": 306, "side": 0, "name": "Brass Battery-255", "kind": "Artillerist",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {"name": "Scatter Volley", "type": "Strike"}
	}
	var volley_target := {
		"id": 307, "side": 1, "name": "Volley Target", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var volley_bystander := {
		"id": 308, "side": 1, "name": "Volley Bystander", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var volley_result := UnitSkillsScript.resolve_strike(
		volley_actor, volley_target,
		[volley_actor, volley_target, volley_bystander], 0.2
	)
	assert(volley_result.affected == [308])
	assert(volley_bystander.hp == 5 and volley_target.hp == 8)
	assert(UnitSkillsScript.resolve_strike(
		volley_actor, volley_target,
		[volley_actor, volley_target, volley_bystander], 0.9
	).message.is_empty())
	var cascade_actor := {
		"id": 309, "side": 0, "name": "Flux Lancer-256", "kind": "Strider",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": [], "row": 0, "col": 2,
		"skill": {"name": "Arc Cascade", "type": "Strike"}
	}
	var cascade_target := {
		"id": 310, "side": 1, "name": "Cascade Target", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": [], "row": 0, "col": 4
	}
	var cascade_bystander := {
		"id": 311, "side": 1, "name": "Cascade Bystander", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [], "row": 0, "col": 5
	}
	var cascade_far := {
		"id": 312, "side": 1, "name": "Cascade Far", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [], "row": 1, "col": 5
	}
	var cascade_result := UnitSkillsScript.resolve_strike(
		cascade_actor, cascade_target,
		[cascade_actor, cascade_target, cascade_bystander, cascade_far], 0.1
	)
	assert(cascade_result.affected == [311])
	assert(cascade_bystander.hp == 5 and cascade_bystander.stun_turns == 1)
	assert(cascade_far.hp == 6)
	var hush_actor := {
		"id": 313, "side": 0, "name": "Flux Weaver-257", "kind": "Channeler",
		"atk": 4, "hp": 5, "max_hp": 5, "effects": [], "row": 0, "col": 2,
		"skill": {"name": "Hushing Resonance", "type": "Strike"}
	}
	var hush_target := {
		"id": 314, "side": 1, "name": "Hush Target", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": [], "row": 0, "col": 3
	}
	var hush_adjacent := {
		"id": 315, "side": 1, "name": "Hush Adjacent", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [], "row": 1, "col": 3
	}
	var hush_far := {
		"id": 316, "side": 1, "name": "Hush Far", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [], "row": 2, "col": 6
	}
	var hush_result := UnitSkillsScript.resolve_strike(
		hush_actor, hush_target,
		[hush_actor, hush_target, hush_adjacent, hush_far], 0.3
	)
	assert(hush_result.affected == [314, 315])
	assert(hush_target.silenced_turns == 1 and hush_adjacent.silenced_turns == 1)
	assert(hush_far.get("silenced_turns", 0) == 0)
	var leech_actor := {
		"id": 317, "side": 0, "name": "Cinder Weaver-258", "kind": "Channeler",
		"atk": 4, "hp": 3, "max_hp": 6, "effects": [],
		"skill": {"name": "Leech Protocol", "type": "Strike"}
	}
	var leech_target := {
		"id": 318, "side": 1, "name": "Leech Target", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var leech_result := UnitSkillsScript.resolve_strike(
		leech_actor, leech_target, [leech_actor, leech_target], 0.4
	)
	assert(leech_result.affected == [317])
	assert(leech_actor.hp == 5)
	assert(UnitSkillsScript.resolve_strike(
		leech_actor, leech_target, [leech_actor, leech_target], 0.9
	).message.is_empty())
	var repulse_actor := {
		"id": 319, "side": 0, "name": "Zephyr Lancer-259", "kind": "Strider",
		"atk": 2, "hp": 5, "max_hp": 5, "effects": [], "row": 0, "col": 2,
		"skill": {"name": "Concussive Repulse", "type": "Strike"}
	}
	var repulse_target := {
		"id": 320, "side": 1, "name": "Repulse Target", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": [], "row": 0, "col": 4
	}
	var repulse_result := UnitSkillsScript.resolve_strike(
		repulse_actor, repulse_target, [repulse_actor, repulse_target], 0.3
	)
	assert(repulse_result.affected == [320])
	assert(repulse_target.col == 5 and repulse_target.silenced_turns == 1)
	assert(repulse_result.moved.size() == 1)
	var jolt_carrier := {
		"id": 321, "side": 0, "name": "Brass Bastion-260", "kind": "Warden",
		"atk": 2, "hp": 10, "max_hp": 10, "effects": [],
		"skill": {"name": "Retribution Jolt", "type": "Reaction"}
	}
	var jolt_attacker := {
		"id": 322, "side": 1, "name": "Jolt Attacker", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var jolt_result := UnitSkillsScript.resolve_reaction(
		jolt_carrier, jolt_attacker, [jolt_carrier, jolt_attacker], 0.3
	)
	assert(jolt_result.affected == [322])
	assert(jolt_attacker.hp == 5 and jolt_attacker.stun_turns == 1)
	assert(UnitSkillsScript.resolve_reaction(
		jolt_carrier, jolt_attacker, [jolt_carrier, jolt_attacker], 0.9
	).message.is_empty())
	var barb_carrier := {
		"id": 323, "side": 0, "name": "Cinder Bastion-261", "kind": "Warden",
		"atk": 3, "hp": 9, "max_hp": 9, "effects": [],
		"skill": {"name": "Venom Barb", "type": "Reaction"}
	}
	var barb_attacker := {
		"id": 324, "side": 1, "name": "Barb Attacker", "kind": "Duelist",
		"atk": 4, "hp": 6, "max_hp": 6, "effects": []
	}
	var barb_result := UnitSkillsScript.resolve_reaction(
		barb_carrier, barb_attacker, [barb_carrier, barb_attacker]
	)
	assert(barb_result.affected == [324])
	assert(barb_attacker.atk == 3 and barb_attacker.poison_turns == 2)
	assert(barb_attacker.poison_damage == 1)
	var emergency_carrier := {
		"id": 325, "side": 0, "name": "Helio Bastion-262", "kind": "Warden",
		"atk": 2, "hp": 3, "max_hp": 8, "effects": [],
		"skill": {"name": "Emergency Protocol", "type": "Reaction"}
	}
	var emergency_attacker := {
		"id": 326, "side": 1, "name": "Emergency Attacker", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var emergency_result := UnitSkillsScript.resolve_reaction(
		emergency_carrier, emergency_attacker,
		[emergency_carrier, emergency_attacker], 0.2
	)
	assert(emergency_result.affected == [325])
	assert(emergency_carrier.hp == 5 and emergency_carrier.protect_turns == 1)
	var stasis_actor := {
		"id": 327, "side": 0, "name": "Flux Weaver-263", "kind": "Channeler",
		"atk": 4, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {"name": "Stasis Bolt", "type": "Warcry"}
	}
	var stasis_target := {
		"id": 328, "side": 1, "name": "Stasis Target", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var stasis_result := UnitSkillsScript.resolve_warcry(
		stasis_actor, [stasis_actor, stasis_target], 328
	)
	assert(stasis_target.stun_turns == 1)
	assert(328 in stasis_result.affected)
	var expose_actor := {
		"id": 329, "side": 0, "name": "Cinder Weaver-264", "kind": "Channeler",
		"atk": 4, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {"name": "Exposing Frequency", "type": "Warcry"}
	}
	var expose_one := {
		"id": 330, "side": 1, "name": "Expose One", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var expose_two := {
		"id": 331, "side": 1, "name": "Expose Two", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var expose_result := UnitSkillsScript.resolve_warcry(
		expose_actor, [expose_actor, expose_one, expose_two]
	)
	assert(expose_result.affected == [330, 331])
	assert(expose_one.vulnerable_turns == 1 and expose_two.vulnerable_turns == 1)
	var miasma_actor := {
		"id": 332, "side": 0, "name": "Cinder Weaver-265", "kind": "Channeler",
		"atk": 4, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Toxic Miasma", "type": "Warcry"}
	}
	var miasma_one := {
		"id": 333, "side": 1, "name": "Miasma One", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var miasma_two := {
		"id": 334, "side": 1, "name": "Miasma Two", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var miasma_result := UnitSkillsScript.resolve_warcry(
		miasma_actor, [miasma_actor, miasma_one, miasma_two]
	)
	assert(miasma_result.affected == [333, 334])
	assert(miasma_one.hp == 7 and miasma_one.poison_turns == 2)
	assert(miasma_two.hp == 5 and miasma_two.poison_turns == 2)
	var discord_actor := {
		"id": 335, "side": 0, "name": "Flux Weaver-266", "kind": "Channeler",
		"atk": 5, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Discordant Blast", "type": "Warcry"}
	}
	var discord_enemy := {
		"id": 336, "side": 1, "name": "Discord Enemy", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var discord_result := UnitSkillsScript.resolve_warcry(
		discord_actor, [discord_actor, discord_enemy]
	)
	assert(discord_result.affected == [336])
	assert(discord_enemy.hp == 5 and discord_enemy.atk == 2)
	ConductorSkillsScript.expire_effects([discord_enemy], 1)
	ConductorSkillsScript.expire_effects([discord_enemy], 1)
	assert(discord_enemy.atk == 3)
	var warhorn_actor := {
		"id": 337, "side": 0, "name": "Brass Lancer-267", "kind": "Strider",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {"name": "Resonant Warhorn", "type": "Warcry"}
	}
	var warhorn_ally := {
		"id": 338, "side": 0, "name": "Warhorn Ally", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var warhorn_result := UnitSkillsScript.resolve_warcry(
		warhorn_actor, [warhorn_actor, warhorn_ally]
	)
	assert(warhorn_result.affected == [337, 338])
	assert(warhorn_actor.atk == 4 and warhorn_ally.atk == 4)
	ConductorSkillsScript.expire_effects([warhorn_actor, warhorn_ally], 0)
	ConductorSkillsScript.expire_effects([warhorn_actor, warhorn_ally], 0)
	assert(warhorn_actor.atk == 3 and warhorn_ally.atk == 3)
	var absolution_actor := {
		"id": 339, "side": 0, "name": "Helio Mender-268", "kind": "Lifebinder",
		"atk": 2, "hp": 7, "max_hp": 7, "effects": [],
		"skill": {"name": "Absolution Pulse", "type": "Warcry"}
	}
	var absolution_ally := {
		"id": 340, "side": 0, "name": "Afflicted Ally", "kind": "Warden",
		"atk": 2, "hp": 4, "max_hp": 8, "effects": [],
		"stun_turns": 2, "immobilized_turns": 1, "poison_turns": 3, "poison_damage": 1,
		"silenced_turns": 1, "vulnerable_turns": 2, "vulnerable_stacks": 1
	}
	var absolution_result := UnitSkillsScript.resolve_warcry(
		absolution_actor, [absolution_actor, absolution_ally]
	)
	assert(absolution_result.affected == [339, 340])
	assert(absolution_ally.stun_turns == 0 and absolution_ally.immobilized_turns == 0)
	assert(absolution_ally.poison_turns == 0 and absolution_ally.silenced_turns == 0)
	assert(absolution_ally.vulnerable_turns == 0 and absolution_ally.hp == 6)
	var sanitize_actor := {
		"id": 341, "side": 0, "name": "Zephyr Mender-269", "kind": "Lifebinder",
		"atk": 2, "hp": 4, "max_hp": 4, "effects": [], "row": 0, "col": 1,
		"skill": {"name": "Sanitize Corridor", "type": "Warcry"}
	}
	var sanitize_ally := {
		"id": 342, "side": 0, "name": "Lane Ally", "kind": "Warden",
		"atk": 2, "hp": 4, "max_hp": 4, "effects": [], "row": 1, "col": 2,
		"immobilized_turns": 2, "stun_turns": 1
	}
	var sanitize_other := {
		"id": 343, "side": 0, "name": "Other Lane Ally", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [], "row": 0, "col": 3,
		"immobilized_turns": 2
	}
	var sanitize_result := UnitSkillsScript.resolve_warcry(
		sanitize_actor, [sanitize_actor, sanitize_ally, sanitize_other], -1, null, 1
	)
	assert(sanitize_result.affected == [342])
	assert(sanitize_ally.immobilized_turns == 0 and sanitize_ally.stun_turns == 0)
	assert(sanitize_ally.hp == 5 and sanitize_ally.max_hp == 5)
	assert(sanitize_other.immobilized_turns == 2)
	var overdrive_actor := {
		"id": 344, "side": 0, "name": "Brass Blade-270", "kind": "Duelist",
		"atk": 4, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Overdrive Charge", "type": "Warcry"}
	}
	var overdrive_result := UnitSkillsScript.resolve_warcry(
		overdrive_actor, [overdrive_actor]
	)
	assert(overdrive_result.affected == [344])
	assert(overdrive_actor.overdrive_turns == 3)
	UnitSkillsScript.resolve_chants(0, [overdrive_actor], "end")
	UnitSkillsScript.resolve_chants(0, [overdrive_actor], "end")
	assert(overdrive_actor.atk == 4 and overdrive_actor.overdrive_turns == 1)
	var overdrive_results := UnitSkillsScript.resolve_chants(0, [overdrive_actor], "end")
	assert(overdrive_results.size() == 1)
	assert(overdrive_actor.atk == 6 and overdrive_actor.overdrive_turns == 0)
	var decommission_actor := {
		"id": 345, "side": 0, "name": "Flux Lancer-271", "kind": "Strider",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Decommission", "type": "Warcry"}
	}
	var decommission_weak := {
		"id": 346, "side": 1, "name": "Weak Enemy", "kind": "Lifebinder",
		"atk": 2, "hp": 5, "max_hp": 5, "effects": []
	}
	var decommission_strong := {
		"id": 347, "side": 1, "name": "Strong Enemy", "kind": "Duelist",
		"atk": 5, "hp": 6, "max_hp": 6, "effects": []
	}
	var decommission_result := UnitSkillsScript.resolve_warcry(
		decommission_actor,
		[decommission_actor, decommission_weak, decommission_strong], 346
	)
	assert(decommission_result.affected == [346])
	assert(decommission_weak.hp == 0 and decommission_strong.hp == 6)
	var decommission_miss := UnitSkillsScript.resolve_warcry(
		decommission_actor, [decommission_actor, decommission_strong], 347
	)
	assert(decommission_miss.affected.is_empty())
	assert(decommission_strong.hp == 6)
	var gridlock_actor := {
		"id": 348, "side": 0, "name": "Flux Weaver-272", "kind": "Channeler",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Gridlock Field", "type": "Warcry"}
	}
	var gridlock_heavy := {
		"id": 349, "side": 1, "name": "Heavy Enemy", "kind": "Duelist",
		"atk": 4, "hp": 6, "max_hp": 6, "effects": []
	}
	var gridlock_light := {
		"id": 350, "side": 1, "name": "Light Enemy", "kind": "Strider",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	var gridlock_result := UnitSkillsScript.resolve_warcry(
		gridlock_actor, [gridlock_actor, gridlock_heavy, gridlock_light]
	)
	assert(gridlock_result.affected == [349])
	assert(gridlock_heavy.immobilized_turns == 1)
	assert(gridlock_light.get("immobilized_turns", 0) == 0)
	var equalize_actor := {
		"id": 351, "side": 0, "name": "Helio Weaver-273", "kind": "Channeler",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Equalize", "type": "Warcry"}
	}
	var equalize_enemy := {
		"id": 352, "side": 1, "name": "Strong Enemy", "kind": "Duelist",
		"atk": 5, "hp": 6, "max_hp": 6, "effects": []
	}
	var equalize_ally := {
		"id": 353, "side": 0, "name": "Weak Ally", "kind": "Lifebinder",
		"atk": 2, "hp": 3, "max_hp": 6, "effects": []
	}
	var equalize_result := UnitSkillsScript.resolve_warcry(
		equalize_actor, [equalize_actor, equalize_enemy, equalize_ally]
	)
	assert(equalize_result.affected == [352, 353])
	assert(equalize_enemy.atk == 3)
	assert(equalize_ally.hp == 5 and equalize_ally.max_hp == 8)
	var ballast_actor := {
		"id": 354, "side": 0, "name": "Brass Mender-274", "kind": "Lifebinder",
		"atk": 2, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Ballast Infusion", "type": "Warcry"}
	}
	var ballast_ally := {
		"id": 355, "side": 0, "name": "Ballast Ally", "kind": "Duelist",
		"atk": 2, "hp": 6, "max_hp": 6, "effects": []
	}
	var ballast_result := UnitSkillsScript.resolve_warcry(
		ballast_actor, [ballast_actor, ballast_ally], 355
	)
	assert(ballast_result.affected == [355])
	assert(ballast_ally.atk == 4 and ballast_ally.immobilized_turns == 2)
	var rewind_actor := {
		"id": 356, "side": 0, "name": "Zephyr Weaver-275", "kind": "Channeler",
		"atk": 4, "hp": 7, "max_hp": 7, "effects": [], "row": 0, "col": 3,
		"skill": {"name": "Temporal Rewind", "type": "Warcry"}
	}
	var rewind_ally := {
		"id": 357, "side": 0, "name": "Rewind Ally", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [], "row": 0, "col": 4
	}
	var rewind_enemy := {
		"id": 358, "side": 1, "name": "Rewind Enemy", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": [], "row": 1, "col": 2
	}
	var rewind_result := UnitSkillsScript.resolve_warcry(
		rewind_actor, [rewind_actor, rewind_ally, rewind_enemy]
	)
	assert(rewind_result.affected == [357, 358])
	assert(rewind_ally.col == 5 and rewind_ally.protect_turns == 1)
	assert(rewind_enemy.col == 1 and rewind_enemy.vulnerable_turns == 1)
	assert(rewind_result.moved.size() == 2)
	var ember_carrier := {
		"id": 359, "side": 0, "name": "Cinder Battery-276", "kind": "Artillerist",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {"name": "Ember Recoil", "type": "Chant"}
	}
	var ember_enemy := {
		"id": 360, "side": 1, "name": "Ember Enemy", "kind": "Duelist",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	# End-phase chant: nothing at the start phase, a hit on a successful roll.
	assert(UnitSkillsScript.resolve_chants(0, [ember_carrier, ember_enemy], "start", null, 0.2).is_empty())
	var ember_results := UnitSkillsScript.resolve_chants(
		0, [ember_carrier, ember_enemy], "end", null, 0.2
	)
	assert(ember_results.size() == 1 and ember_results[0].affected == [360])
	assert(ember_enemy.hp == 4)
	assert(UnitSkillsScript.resolve_chants(
		0, [ember_carrier, ember_enemy], "end", null, 0.9
	).is_empty())
	assert(ember_enemy.hp == 4)
	var ramping_carrier := {
		"id": 361, "side": 0, "name": "Brass Battery-277", "kind": "Artillerist",
		"atk": 2, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {"name": "Ramping Dynamo", "type": "Chant"}
	}
	var ramping_results := UnitSkillsScript.resolve_chants(0, [ramping_carrier], "start", null, 0.2)
	assert(ramping_results.size() == 1 and ramping_carrier.atk == 3)
	assert(UnitSkillsScript.resolve_chants(0, [ramping_carrier], "start", null, 0.9).is_empty())
	assert(ramping_carrier.atk == 3)
	var forge_carrier := {
		"id": 362, "side": 0, "name": "Cinder Blade-278", "kind": "Duelist",
		"atk": 4, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Bloodforge Cycle", "type": "Chant"}
	}
	var forge_results := UnitSkillsScript.resolve_chants(0, [forge_carrier], "start")
	assert(forge_results.size() == 1)
	assert(forge_carrier.atk == 5 and forge_carrier.hp == 5)
	forge_carrier.hp = 1
	UnitSkillsScript.resolve_chants(0, [forge_carrier], "start")
	assert(forge_carrier.atk == 6 and forge_carrier.hp == 1)
	var dividend_carrier := {
		"id": 363, "side": 0, "name": "Helio Mender-279", "kind": "Lifebinder",
		"atk": 2, "hp": 4, "max_hp": 4, "effects": [],
		"skill": {"name": "Patron's Dividend", "type": "Chant"}
	}
	var dividend_ally := {
		"id": 364, "side": 0, "name": "Dividend Ally", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var dividend_results := UnitSkillsScript.resolve_chants(
		0, [dividend_carrier, dividend_ally], "start"
	)
	assert(dividend_results.size() == 1 and dividend_results[0].affected == [364])
	assert(dividend_ally.hp == 7 and dividend_ally.max_hp == 7 and dividend_ally.atk == 4)
	assert(dividend_carrier.atk == 2 and dividend_carrier.max_hp == 4)
	var surge_carrier := {
		"id": 365, "side": 0, "name": "Helio Mender-280", "kind": "Lifebinder",
		"atk": 3, "hp": 5, "max_hp": 7, "effects": [],
		"skill": {"name": "Restoration Surge", "type": "Chant"}
	}
	var surge_ally := {
		"id": 366, "side": 0, "name": "Surge Ally", "kind": "Warden",
		"atk": 2, "hp": 6, "max_hp": 8, "effects": []
	}
	var surge_results := UnitSkillsScript.resolve_chants(
		0, [surge_carrier, surge_ally], "start", null, 0.2
	)
	assert(surge_results.size() == 1)
	assert(surge_carrier.hp == 7 and surge_ally.hp == 8)
	assert(surge_carrier.protect_turns == 1)
	var entropy_carrier := {
		"id": 367, "side": 0, "name": "Cinder Weaver-281", "kind": "Channeler",
		"atk": 4, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Entropy Field", "type": "Chant"}
	}
	var entropy_enemy := {
		"id": 368, "side": 1, "name": "Entropy Enemy", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var entropy_results := UnitSkillsScript.resolve_chants(
		0, [entropy_carrier, entropy_enemy], "start"
	)
	assert(entropy_results.size() == 1)
	assert(368 in entropy_results[0].affected and 367 in entropy_results[0].affected)
	assert(entropy_enemy.hp == 7 and entropy_carrier.atk == 5)
	var ignition_carrier := {
		"id": 369, "side": 0, "name": "Cinder Battery-282", "kind": "Artillerist",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {"name": "Ignition Sequence", "type": "Chant"}
	}
	var ignition_burned := {
		"id": 370, "side": 1, "name": "Vulnerable Enemy", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [],
		"vulnerable_turns": 2, "vulnerable_stacks": 1
	}
	var ignition_clean := {
		"id": 371, "side": 1, "name": "Clean Enemy", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var ignition_results := UnitSkillsScript.resolve_chants(
		0, [ignition_carrier, ignition_burned, ignition_clean], "start"
	)
	assert(ignition_results.size() == 1 and ignition_results[0].affected == [370])
	assert(ignition_burned.hp == 4 and ignition_clean.hp == 6)
	var collapse_chanter := {
		"id": 372, "side": 0, "name": "Zephyr Lancer-283", "kind": "Strider",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": [], "row": 0, "col": 3,
		"skill": {"name": "Backline Collapse", "type": "Chant"}
	}
	var collapse_behind := {
		"id": 373, "side": 1, "name": "Behind Enemy", "kind": "Duelist",
		"atk": 4, "hp": 6, "max_hp": 6, "effects": [], "row": 1, "col": 2
	}
	var collapse_front := {
		"id": 374, "side": 1, "name": "Front Enemy", "kind": "Duelist",
		"atk": 4, "hp": 6, "max_hp": 6, "effects": [], "row": 2, "col": 4
	}
	assert(UnitSkillsScript.resolve_chants(
		0, [collapse_chanter, collapse_behind, collapse_front], "start"
	).is_empty())
	var collapse_results := UnitSkillsScript.resolve_chants(
		0, [collapse_chanter, collapse_behind, collapse_front], "end"
	)
	assert(collapse_results.size() == 1 and collapse_results[0].affected == [373])
	assert(collapse_behind.atk == 3 and collapse_behind.immobilized_turns == 1)
	assert(collapse_front.atk == 4 and collapse_front.get("immobilized_turns", 0) == 0)
	var slip_chanter := {
		"id": 375, "side": 0, "name": "Zephyr Lancer-284", "kind": "Strider",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {"name": "Slipstream Chorus", "type": "Chant"}
	}
	var slip_ally := {
		"id": 376, "side": 0, "name": "Slip Ally", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var slip_results := UnitSkillsScript.resolve_chants(
		0, [slip_chanter, slip_ally], "start", null, 0.2
	)
	assert(slip_results.size() == 1)
	assert(slip_ally.haste_turns == 1 and slip_chanter.protect_turns == 1)
	var anchor_carrier := {
		"id": 377, "side": 0, "name": "Zephyr Weaver-285", "kind": "Channeler",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {"name": "Anchoring Snare", "type": "Chant"}
	}
	var anchor_victim := {
		"id": 378, "side": 1, "name": "Anchored Enemy", "kind": "Duelist",
		"atk": 4, "hp": 6, "max_hp": 6, "effects": []
	}
	var anchor_results := UnitSkillsScript.resolve_chants(
		1, [anchor_carrier, anchor_victim], "start", null, -1.0, 378
	)
	assert(anchor_results.size() == 1 and anchor_results[0].affected == [378])
	assert(anchor_victim.immobilized_turns == 1 and anchor_victim.atk == 3)
	assert(anchor_victim.effects.size() == 1 and anchor_victim.effects[0].turns == 2)
	var provoke_carrier := {
		"id": 379, "side": 0, "name": "Cinder Bastion-286", "kind": "Warden",
		"atk": 2, "hp": 9, "max_hp": 9, "effects": [],
		"skill": {"name": "Provoking Snare", "type": "Chant"}
	}
	var provoke_victim := {
		"id": 380, "side": 1, "name": "Provoked Enemy", "kind": "Duelist",
		"atk": 4, "hp": 6, "max_hp": 6, "effects": []
	}
	var provoke_results := UnitSkillsScript.resolve_chants(
		1, [provoke_carrier, provoke_victim], "start", null, 0.2, 380
	)
	assert(provoke_results.size() == 1)
	assert(provoke_victim.taunt_turns == 1 and provoke_carrier.protect_turns == 1)
	assert(379 in provoke_results[0].affected and 380 in provoke_results[0].affected)
	var apex_chanter := {
		"id": 381, "side": 0, "name": "Flux Battery-287", "kind": "Artillerist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Apex Confluence", "type": "Chant"}
	}
	var apex_healthy := {
		"id": 382, "side": 1, "name": "Healthy Enemy", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var apex_hurt := {
		"id": 383, "side": 1, "name": "Hurt Enemy", "kind": "Warden",
		"atk": 2, "hp": 2, "max_hp": 8, "effects": []
	}
	var apex_results := UnitSkillsScript.resolve_chants(
		0, [apex_chanter, apex_healthy, apex_hurt], "start"
	)
	assert(apex_results.size() == 1 and apex_chanter.atk == 4)
	assert(apex_chanter.effects.size() == 1 and apex_chanter.effects[0].attack == 1)
	var clear_carrier := {
		"id": 384, "side": 0, "name": "Helio Weaver-288", "kind": "Channeler",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Clear Signal", "type": "Chant"}
	}
	var clear_ally := {
		"id": 385, "side": 0, "name": "Silenced Ally", "kind": "Duelist",
		"atk": 3, "hp": 4, "max_hp": 6, "effects": [], "silenced_turns": 2
	}
	var clear_results := UnitSkillsScript.resolve_chants(
		0, [clear_carrier, clear_ally], "start"
	)
	assert(clear_results.size() == 1 and clear_results[0].affected == [385])
	assert(clear_ally.silenced_turns == 0 and clear_ally.hp == 6)
	var presence_source := {
		"id": 386, "side": 0, "name": "Helio Bastion-289", "kind": "Warden",
		"atk": 3, "hp": 10, "max_hp": 10, "effects": [],
		"skill": {"name": "Command Presence", "type": "Aura"}
	}
	var presence_ally := {
		"id": 387, "side": 0, "name": "Presence Ally", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	UnitSkillsScript.refresh_auras([presence_source, presence_ally])
	assert(presence_ally.aura_hp == 1 and presence_ally.aura_atk == 1)
	assert(presence_ally.max_hp == 7 and presence_ally.hp == 7 and presence_ally.atk == 4)
	presence_source.hp = 0
	UnitSkillsScript.refresh_auras([presence_source, presence_ally])
	assert(presence_ally.max_hp == 6 and presence_ally.atk == 3)
	var guardian_carrier := {
		"id": 388, "side": 0, "name": "Brass Bastion-290", "kind": "Warden",
		"atk": 3, "hp": 10, "max_hp": 10, "effects": [],
		"skill": {"name": "Guardian Protocol", "type": "Warcry"}
	}
	var guardian_ally := {
		"id": 389, "side": 0, "name": "Guarded Ally", "kind": "Duelist",
		"atk": 4, "hp": 6, "max_hp": 6, "effects": []
	}
	var guardian_attacker := {
		"id": 390, "side": 1, "name": "Attacker", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var guardian_squad: Array = [guardian_carrier, guardian_ally, guardian_attacker]
	var guardian_result := UnitSkillsScript.resolve_warcry(
		guardian_carrier, guardian_squad, 389
	)
	assert(guardian_result.affected == [389])
	assert(guardian_ally.cover_turns == 1 and guardian_ally.cover_source_id == 388)
	var cover_hit := BattleSimulatorScript.apply_unit_damage(
		guardian_ally, 3, guardian_attacker, guardian_squad
	)
	assert(cover_hit.get("redirected_to", -1) == 388)
	assert(guardian_carrier.hp == 7 and guardian_ally.hp == 6)
	UnitSkillsScript.expire_statuses(guardian_squad, 1)
	assert(guardian_ally.cover_turns == 0)
	assert("cover_source_id" not in guardian_ally)
	var open_hit := BattleSimulatorScript.apply_unit_damage(
		guardian_ally, 3, guardian_attacker, guardian_squad
	)
	assert(open_hit.get("redirected_to", -1) == -1 and guardian_ally.hp == 3)
	var drive_actor := {
		"id": 391, "side": 0, "name": "Zephyr Blade-291", "kind": "Duelist",
		"atk": 4, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Twin Drive", "type": "Warcry"}
	}
	var drive_ally := {
		"id": 392, "side": 0, "name": "Driven Ally", "kind": "Artillerist",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	var drive_result := UnitSkillsScript.resolve_warcry(drive_actor, [drive_actor, drive_ally], 392)
	assert(drive_result.affected == [392])
	assert(drive_ally.doublestrike_turns == 1)
	UnitSkillsScript.expire_statuses([drive_actor, drive_ally], 0)
	assert(drive_ally.doublestrike_turns == 0)
	var lag_actor := {
		"id": 393, "side": 0, "name": "Flux Weaver-292", "kind": "Channeler",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [], "row": 1, "col": 2,
		"skill": {"name": "Lag Field", "type": "Warcry"}
	}
	var lag_enemy := {
		"id": 394, "side": 1, "name": "Delayed Enemy", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [], "row": 0, "col": 4
	}
	var lag_bystander := {
		"id": 395, "side": 1, "name": "Bystander Enemy", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [], "row": 2, "col": 4
	}
	var lag_result := UnitSkillsScript.resolve_warcry(
		lag_actor, [lag_actor, lag_enemy, lag_bystander], -1, null, 0
	)
	assert(lag_result.affected == [394])
	assert(lag_enemy.delayed_turns == 1 and lag_bystander.get("delayed_turns", 0) == 0)
	UnitSkillsScript.expire_statuses([lag_enemy], 1)
	assert(lag_enemy.delayed_turns == 0)
	var pyre_actor := {
		"id": 396, "side": 0, "name": "Cinder Mender-293", "kind": "Lifebinder",
		"atk": 3, "hp": 7, "max_hp": 7, "effects": [],
		"skill": {"name": "Sacrificial Pyre", "type": "Warcry"}
	}
	var pyre_sacrifice := {
		"id": 397, "side": 0, "name": "Sacrificed Ally", "kind": "Strider",
		"atk": 2, "hp": 4, "max_hp": 4, "effects": []
	}
	var pyre_ally := {
		"id": 398, "side": 0, "name": "Pyre Ally", "kind": "Duelist",
		"atk": 2, "hp": 6, "max_hp": 6, "effects": []
	}
	var pyre_result := UnitSkillsScript.resolve_warcry(
		pyre_actor, [pyre_actor, pyre_sacrifice, pyre_ally], 397
	)
	assert(pyre_sacrifice.hp == 0)
	assert(397 in pyre_result.affected)
	assert(pyre_actor.atk == 5 and pyre_ally.atk == 4)
	assert(pyre_actor.effects.size() == 1 and pyre_actor.effects[0].turns == 2)
	var sunder_actor := {
		"id": 92, "side": 0, "name": "Brass Battery-083",
		"skill": {"name": "Breach Charge", "type": "Warcry"}
	}
	var sunder_defender := {
		"id": 93, "side": 1, "name": "Armoured Target", "kind": "Warden",
		"hp": 8, "max_hp": 8, "effects": []
	}
	var sunder_scout := {
		"id": 94, "side": 1, "name": "Ineligible Target", "kind": "Strider",
		"hp": 10, "max_hp": 10, "effects": []
	}
	var sunder_result := UnitSkillsScript.resolve_warcry(
		sunder_actor, [sunder_actor, sunder_defender, sunder_scout]
	)
	assert(sunder_result.affected == [93])
	assert(sunder_defender.hp == 7 and sunder_defender.vulnerable_turns == 2)
	assert(sunder_defender.vulnerable_stacks == 1)
	assert(BattleSimulatorScript.apply_unit_damage(sunder_defender, 2).damage == 3)
	assert(sunder_defender.hp == 4)
	UnitSkillsScript.expire_statuses([sunder_defender], 1)
	assert(sunder_defender.vulnerable_turns == 1)
	var sunder_result_two := UnitSkillsScript.resolve_warcry(
		sunder_actor, [sunder_actor, sunder_defender, sunder_scout]
	)
	assert(sunder_result_two.affected == [93])
	assert(sunder_defender.vulnerable_stacks == 2)
	assert(sunder_defender.vulnerable_turns == 2)
	assert("stack 2" in sunder_result_two.message)
	sunder_defender.hp = 8
	assert(BattleSimulatorScript.apply_unit_damage(sunder_defender, 2).damage == 4)
	assert(sunder_defender.hp == 4)
	UnitSkillsScript.expire_statuses([sunder_defender], 1)
	assert(sunder_defender.vulnerable_turns == 1)
	assert(sunder_defender.vulnerable_stacks == 2)
	UnitSkillsScript.expire_statuses([sunder_defender], 1)
	assert(sunder_defender.vulnerable_turns == 0)
	assert(sunder_defender.vulnerable_stacks == 0)
	var hunter_actor := {
		"id": 95, "side": 0, "name": "Zephyr Battery-088", "kind": "Artillerist",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {"name": "Heavy Target", "type": "Warcry"}
	}
	var hunter_big := {
		"id": 96, "side": 1, "name": "Big Target", "kind": "Strider",
		"atk": 4, "hp": 9, "max_hp": 9, "effects": []
	}
	var hunter_small := {
		"id": 97, "side": 1, "name": "Small Target", "kind": "Warden",
		"atk": 2, "hp": 4, "max_hp": 4, "effects": []
	}
	var hunter_result := UnitSkillsScript.resolve_warcry(
		hunter_actor, [hunter_actor, hunter_big, hunter_small]
	)
	assert(hunter_result.affected == [96])
	assert(hunter_big.hp == 8 and hunter_big.vulnerable_turns == 2)
	assert(hunter_big.vulnerable_stacks == 1)
	assert(not hunter_small.has("vulnerable_turns"))
	var contagion_actor := {
		"id": 98, "side": 0, "name": "Cinder Weaver-090", "kind": "Channeler",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {"name": "Chain Corrosion", "type": "Warcry"}
	}
	var contagion_mage := {
		"id": 99, "side": 1, "name": "Enemy Mage", "kind": "Channeler",
		"atk": 4, "hp": 5, "max_hp": 5, "effects": []
	}
	var contagion_priest := {
		"id": 100, "side": 1, "name": "Enemy Priest", "kind": "Lifebinder",
		"atk": 2, "hp": 6, "max_hp": 6, "effects": []
	}
	var contagion_fighter := {
		"id": 101, "side": 1, "name": "Enemy Fighter", "kind": "Duelist",
		"atk": 5, "hp": 7, "max_hp": 7, "effects": []
	}
	var contagion_result := UnitSkillsScript.resolve_warcry(
		contagion_actor,
		[contagion_actor, contagion_mage, contagion_priest, contagion_fighter]
	)
	assert(contagion_result.affected == [99, 100])
	assert(contagion_mage.hp == 4 and contagion_mage.poison_turns == 2)
	assert(contagion_priest.hp == 5 and contagion_priest.poison_damage == 1)
	assert(contagion_fighter.hp == 7 and not contagion_fighter.has("poison_turns"))
	var meteor_actor := {
		"id": 102, "side": 0, "name": "Flux Weaver-092", "kind": "Channeler",
		"row": 0, "atk": 5, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Meteor Pattern", "type": "Warcry"}
	}
	var meteor_lane_one := {
		"id": 103, "side": 1, "name": "Lane One Target", "kind": "Duelist",
		"row": 1, "atk": 5, "hp": 6, "max_hp": 6, "effects": []
	}
	var meteor_lane_two := {
		"id": 104, "side": 1, "name": "Lane Two Target", "kind": "Strider",
		"row": 2, "atk": 3, "hp": 8, "max_hp": 8, "effects": []
	}
	var meteor_units := [meteor_actor, meteor_lane_one, meteor_lane_two]
	var meteor_result := UnitSkillsScript.resolve_warcry(
		meteor_actor, meteor_units, -1, null, 2
	)
	assert(meteor_result.affected == [104])
	assert(meteor_lane_two.hp == 6 and meteor_lane_one.hp == 6)
	var meteor_fallback := UnitSkillsScript.resolve_warcry(meteor_actor, meteor_units)
	assert(meteor_fallback.affected == [103])
	assert(meteor_lane_one.hp == 4)
	skirmisher.skill = {"name": "Sever Drive", "type": "Strike"}
	assert(not UnitSkillsScript.resolve_strike(skirmisher, warcry_enemy, [], 0.59).message.is_empty())
	warcry_enemy.immobilized_turns = 0
	assert(UnitSkillsScript.resolve_strike(skirmisher, warcry_enemy, [], 0.60).message.is_empty())

	# Chant: Breaker Impact hits every enemy in the chanter's lane at the
	# start of the chanter's turn and makes survivors Vulnerable.
	var bartok := {
		"id": 105, "side": 0, "name": "Relay Blade-094", "kind": "Duelist",
		"row": 1, "atk": 5, "hp": 8, "max_hp": 8, "effects": [],
		"skill": {"name": "Breaker Impact", "type": "Chant"}
	}
	var chant_lane_foe := {
		"id": 106, "side": 1, "name": "Lane Foe", "kind": "Warden",
		"row": 1, "atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var chant_other_lane := {
		"id": 107, "side": 1, "name": "Other Lane Foe", "kind": "Strider",
		"row": 2, "atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var chant_units := [bartok, chant_lane_foe, chant_other_lane]
	var chant_results := UnitSkillsScript.resolve_chants(0, chant_units)
	assert(chant_results.size() == 1)
	assert(chant_results[0].affected == [106])
	assert(chant_lane_foe.hp == 5 and chant_lane_foe.vulnerable_turns == 2)
	assert(chant_lane_foe.vulnerable_stacks == 1)
	assert(chant_other_lane.hp == 6 and not chant_other_lane.has("vulnerable_turns"))
	assert(UnitSkillsScript.resolve_chants(1, chant_units).is_empty())
	# Re-applying Vulnerable stacks, mirroring Breach Charge, and last turn's
	# Vulnerable amplifies this turn's chant damage (1 + 1 stack).
	UnitSkillsScript.resolve_chants(0, chant_units)
	assert(chant_lane_foe.hp == 3 and chant_lane_foe.vulnerable_stacks == 2)
	# Level scaling: a level-5 chanter hits for 3 damage over 4 turns.
	var veteran_geartron := {
		"id": 114, "side": 0, "name": "Brass Bastion-097", "kind": "Warden",
		"row": 0, "atk": 3, "hp": 13, "max_hp": 13, "effects": [], "level": 5,
		"skill": UnitCatalogScript.by_name("Brass Bastion-097").skill.to_dict()
	}
	var veteran_lane_foe := {
		"id": 115, "side": 1, "name": "Veteran Lane Foe", "kind": "Duelist",
		"row": 0, "atk": 4, "hp": 9, "max_hp": 9, "effects": []
	}
	var veteran_chants := UnitSkillsScript.resolve_chants(
		0, [veteran_geartron, veteran_lane_foe]
	)
	assert(veteran_chants.size() == 1)
	assert(veteran_lane_foe.hp == 6 and veteran_lane_foe.vulnerable_turns == 4)

	# Chant: Pressure Jet debuffs the ATK of every enemy in the chanter's lane
	# until the end of the enemy's next turn and Knocks them Back away from
	# the chanter, stopping at the board edge or an occupied cell.
	var aquanaut := {
		"id": 404, "side": 0, "name": "Cinder Battery-176", "kind": "Artillerist",
		"row": 1, "col": 2, "atk": 3, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {
			"name": "Pressure Jet", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Pressure Jet"]
		}
	}
	var hydro_foe := {
		"id": 405, "side": 1, "name": "Hydro Foe", "kind": "Warden",
		"row": 1, "col": 4, "atk": 4, "hp": 8, "max_hp": 8, "effects": []
	}
	var hydro_blocker := {
		"id": 406, "side": 1, "name": "Hydro Blocker", "kind": "Duelist",
		"row": 1, "col": 5, "atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var hydro_other_lane := {
		"id": 407, "side": 1, "name": "Other Lane Hydro Foe", "kind": "Strider",
		"row": 2, "col": 4, "atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	var hydro_units := [aquanaut, hydro_foe, hydro_blocker, hydro_other_lane]
	var hydro_results := UnitSkillsScript.resolve_chants(0, hydro_units)
	assert(hydro_results.size() == 1)
	assert(hydro_results[0].affected == [405, 406])
	assert(hydro_foe.atk == 3 and hydro_blocker.atk == 2)
	# The foe is blocked by the blocker and stays; the blocker slides to col 6.
	assert(hydro_foe.col == 4 and hydro_blocker.col == 6)
	assert(hydro_results[0].moved.size() == 2)
	assert(hydro_other_lane.atk == 3 and hydro_other_lane.col == 4)
	assert(not hydro_other_lane.has("effects") or hydro_other_lane.effects.is_empty())
	assert(UnitSkillsScript.resolve_chants(1, hydro_units).is_empty())
	# The debuff lifts at the end of the enemy's next turn.
	ConductorSkillsScript.expire_effects(hydro_units, 1)
	assert(hydro_foe.atk == 4 and hydro_blocker.atk == 3)
	# Level scaling: a level-5 chanter debuffs 3 ATK and Knocks Back 3 spaces.
	var hydronaut := {
		"id": 408, "side": 0, "name": "Cinder Battery-177", "kind": "Artillerist",
		"row": 0, "col": 0, "atk": 4, "hp": 7, "max_hp": 7, "effects": [], "level": 5,
		"skill": UnitCatalogScript.by_name("Cinder Battery-177").skill.to_dict()
	}
	var hydro_veteran_foe := {
		"id": 409, "side": 1, "name": "Veteran Hydro Foe", "kind": "Warden",
		"row": 0, "col": 3, "atk": 5, "hp": 9, "max_hp": 9, "effects": []
	}
	var hydro_veteran_results := UnitSkillsScript.resolve_chants(
		0, [hydronaut, hydro_veteran_foe]
	)
	assert(hydro_veteran_results.size() == 1)
	assert(hydro_veteran_foe.atk == 2 and hydro_veteran_foe.col == 6)

	# Chant: Deployment Snare is a deployment trap that fires at the start of
	# the OPPOSING side's turn, Stunning that side's most recently deployed
	# unit (the `last_placed_id` argument) for 2 turns with a rank-scaled
	# chance of permanent Poison. Only the first living carrier triggers.
	var thief := {
		"id": 410, "side": 0, "name": "Zephyr Lancer-178", "kind": "Strider",
		"row": 0, "col": 1, "atk": 2, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {
			"name": "Deployment Snare", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Deployment Snare"]
		}
	}
	var cutpurse := {
		"id": 411, "side": 0, "name": "Zephyr Lancer-179", "kind": "Strider",
		"row": 1, "col": 1, "atk": 2, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {
			"name": "Deployment Snare", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Deployment Snare"]
		}
	}
	var snare_fresh := {
		"id": 412, "side": 1, "name": "Fresh Recruit", "kind": "Warden",
		"row": 0, "col": 5, "atk": 3, "hp": 8, "max_hp": 8, "effects": []
	}
	var snare_veteran := {
		"id": 413, "side": 1, "name": "Old Cover Matrix", "kind": "Duelist",
		"row": 1, "col": 4, "atk": 4, "hp": 7, "max_hp": 7, "effects": []
	}
	var snare_units := [thief, cutpurse, snare_fresh, snare_veteran]
	# Nothing fires on the snare owner's own turn, when the opponent has
	# placed nothing yet, or when the id names a unit of the wrong side.
	assert(UnitSkillsScript.resolve_chants(0, snare_units, "start", null, -1.0, 412).is_empty())
	assert(UnitSkillsScript.resolve_chants(1, snare_units, "start", null, -1.0, -1).is_empty())
	assert(UnitSkillsScript.resolve_chants(1, snare_units, "start", null, -1.0, 410).is_empty())
	# At the start of side 1's turn the trap springs on its most recent
	# deployment (412), not the earlier one (413). Roll 0.0 beats the 20%
	# level-1 chance, so the Poison lands and never expires.
	var snare_results := UnitSkillsScript.resolve_chants(
		1, snare_units, "start", null, 0.0, 412
	)
	assert(snare_results.size() == 1, "Two carriers must not stack two snares.")
	assert(snare_results[0].affected == [412])
	assert("Stuns" in snare_results[0].message)
	assert(snare_fresh.stun_turns == 2 and BattleRulesScript.is_stunned(snare_fresh))
	assert(snare_fresh.poison_turns == UnitSkillsScript.PERMANENT_POISON_TURNS)
	assert(snare_fresh.poison_damage == 1)
	assert(snare_veteran.get("stun_turns", 0) == 0)
	# The permanent Poison ticks damage but never counts down.
	var snare_status := UnitSkillsScript.resolve_start_statuses(1, snare_units)
	assert(snare_status.size() == 1 and snare_fresh.hp == 7)
	assert(snare_fresh.poison_turns == UnitSkillsScript.PERMANENT_POISON_TURNS)
	# The Stun lasts two of the victim's side turns.
	UnitSkillsScript.expire_statuses(snare_units, 1)
	assert(snare_fresh.stun_turns == 1 and BattleRulesScript.is_stunned(snare_fresh))
	UnitSkillsScript.expire_statuses(snare_units, 1)
	assert(snare_fresh.stun_turns == 0 and not BattleRulesScript.is_stunned(snare_fresh))
	# A roll above the chance still Stuns but does not Poison.
	var snare_miss := UnitSkillsScript.resolve_chants(
		1, snare_units, "start", null, 0.99, 413
	)
	assert(snare_miss.size() == 1 and snare_miss[0].affected == [413])
	assert(snare_veteran.stun_turns == 2 and snare_veteran.get("poison_turns", 0) == 0)
	# With the first carrier dead, the next living one springs the trap; the
	# level-5 rank row is a 100% chance, so even a 0.99 roll Poisons.
	thief.hp = 0
	cutpurse.level = 5
	var snare_max := UnitSkillsScript.resolve_chants(
		1, snare_units, "start", null, 0.99, 413
	)
	assert(snare_max.size() == 1)
	assert(snare_veteran.poison_turns == UnitSkillsScript.PERMANENT_POISON_TURNS)
	# With every carrier dead the trap cannot fire.
	cutpurse.hp = 0
	assert(UnitSkillsScript.resolve_chants(
		1, snare_units, "start", null, 0.0, 412
	).is_empty())

	# Chant: Frontline Relay grants Protect to every ally behind the chanter and
	# debuffs the ATK of every enemy in front of it, across all lanes.
	# "Behind"/"in front" are column-relative: side 0 advances toward
	# higher columns, so behind = lower column, in front = higher column;
	# units in the chanter's own column are neither.
	var frontier_rider := {
		"id": 420, "side": 0, "name": "Cinder Battery-182", "kind": "Artillerist",
		"row": 1, "col": 3, "atk": 2, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {
			"name": "Frontline Relay", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Frontline Relay"]
		}
	}
	var wrangle_ally_behind := {
		"id": 421, "side": 0, "name": "Rear Ally", "kind": "Warden",
		"row": 2, "col": 1, "atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var wrangle_ally_ahead := {
		"id": 422, "side": 0, "name": "Front Ally", "kind": "Duelist",
		"row": 1, "col": 5, "atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var wrangle_ally_beside := {
		"id": 423, "side": 0, "name": "Flank Ally", "kind": "Strider",
		"row": 0, "col": 3, "atk": 2, "hp": 4, "max_hp": 4, "effects": []
	}
	var wrangle_foe_front := {
		"id": 424, "side": 1, "name": "Front Foe", "kind": "Warden",
		"row": 0, "col": 4, "atk": 4, "hp": 8, "max_hp": 8, "effects": []
	}
	var wrangle_foe_behind := {
		"id": 425, "side": 1, "name": "Rear Foe", "kind": "Strider",
		"row": 1, "col": 2, "atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	var wrangle_units := [
		frontier_rider, wrangle_ally_behind, wrangle_ally_ahead,
		wrangle_ally_beside, wrangle_foe_front, wrangle_foe_behind
	]
	var wrangle_results := UnitSkillsScript.resolve_chants(0, wrangle_units)
	assert(wrangle_results.size() == 1)
	# Cross-lane: the rear ally is in lane 3, the front foe in lane 1.
	assert(wrangle_results[0].affected == [421, 424])
	assert(wrangle_ally_behind.protect_turns == 1)
	assert(wrangle_ally_ahead.get("protect_turns", 0) == 0)
	assert(wrangle_ally_beside.get("protect_turns", 0) == 0)
	assert(frontier_rider.get("protect_turns", 0) == 0)
	assert(wrangle_foe_front.atk == 3 and wrangle_foe_front.effects.size() == 1)
	assert(wrangle_foe_behind.atk == 3 and wrangle_foe_behind.effects.is_empty())
	assert(UnitSkillsScript.resolve_chants(1, wrangle_units).is_empty())
	assert(UnitSkillsScript.resolve_chants(0, wrangle_units, "end").is_empty())
	# The level-1 debuff lasts one enemy turn, mirroring Pressure Jet.
	ConductorSkillsScript.expire_effects(wrangle_units, 1)
	assert(wrangle_foe_front.atk == 4 and wrangle_foe_front.effects.is_empty())
	# Level scaling: the level-5 rank row is 2-turn Protect, -3 ATK, 2 turns.
	var frontier_protector := {
		"id": 426, "side": 0, "name": "Cinder Battery-183", "kind": "Artillerist",
		"row": 0, "col": 2, "atk": 3, "hp": 5, "max_hp": 5, "effects": [], "level": 5,
		"skill": UnitCatalogScript.by_name("Cinder Battery-183").skill.to_dict()
	}
	var wrangle_veteran_ally := {
		"id": 427, "side": 0, "name": "Veteran Rear Ally", "kind": "Warden",
		"row": 0, "col": 1, "atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var wrangle_veteran_foe := {
		"id": 428, "side": 1, "name": "Veteran Front Foe", "kind": "Duelist",
		"row": 2, "col": 5, "atk": 5, "hp": 7, "max_hp": 7, "effects": []
	}
	var wrangle_veteran_units := [
		frontier_protector, wrangle_veteran_ally, wrangle_veteran_foe
	]
	var wrangle_veteran_results := UnitSkillsScript.resolve_chants(
		0, wrangle_veteran_units
	)
	assert(wrangle_veteran_results.size() == 1)
	assert(wrangle_veteran_results[0].affected == [427, 428])
	assert(wrangle_veteran_ally.protect_turns == 2)
	assert(wrangle_veteran_foe.atk == 2)
	# The 2-turn debuff survives the first enemy expiry and lifts at the second.
	ConductorSkillsScript.expire_effects(wrangle_veteran_units, 1)
	assert(wrangle_veteran_foe.atk == 2 and wrangle_veteran_foe.effects.size() == 1)
	ConductorSkillsScript.expire_effects(wrangle_veteran_units, 1)
	assert(wrangle_veteran_foe.atk == 5 and wrangle_veteran_foe.effects.is_empty())
	# A dead chanter resolves nothing.
	frontier_protector.hp = 0
	assert(UnitSkillsScript.resolve_chants(0, wrangle_veteran_units).is_empty())

	# Warcry: Null Signal locks a target enemy's secondary skill for a
	# rank-scaled number of that unit's side turns (the "enemy turns" of the
	# authored text, counted from the caster's perspective). While Silenced,
	# none of the unit's skill timing hooks fire; movement, attacks, and
	# Conductor skills are unaffected.
	var lunnain_oracle := {
		"id": 440, "side": 0, "name": "Flux Mender-184", "kind": "Lifebinder",
		"row": 1, "col": 0, "atk": 2, "hp": 5, "max_hp": 5, "effects": [], "level": 3,
		"skill": {
			"name": "Null Signal", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Null Signal"]
		}
	}
	var silenced_chanter := {
		"id": 441, "side": 1, "name": "Silenced Chanter", "kind": "Channeler",
		"row": 0, "col": 5, "atk": 2, "hp": 4, "max_hp": 4, "effects": [],
		"skill": {
			"name": "Breaker Impact", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Breaker Impact"]
		}
	}
	var silence_smash_target := {
		"id": 442, "side": 0, "name": "Smash Target", "kind": "Duelist",
		"row": 0, "col": 2, "atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var silence_plain_foe := {
		"id": 443, "side": 1, "name": "Skill-less Foe", "kind": "Warden",
		"row": 2, "col": 5, "atk": 5, "hp": 9, "max_hp": 9, "effects": []
	}
	var silence_units := [
		lunnain_oracle, silenced_chanter, silence_smash_target, silence_plain_foe
	]
	assert(UnitSkillsScript.rank_value(
		UnitCatalogScript.by_name("Flux Mender-184").skill.to_dict(), 1, 0, 1
	) == 1)
	assert(UnitSkillsScript.rank_value(
		UnitCatalogScript.by_name("Flux Mender-184").skill.to_dict(), 5, 0, 1
	) == 5)
	# Level 3 reads the third rank row: 3 turns.
	var silence_result := UnitSkillsScript.resolve_warcry(
		lunnain_oracle, silence_units, 441
	)
	assert(silence_result.affected == [441])
	assert(silenced_chanter.silenced_turns == 3)
	assert(UnitSkillsScript.is_silenced(silenced_chanter))
	assert("Silenced (3 turns)" in ConductorSkillsScript.effect_summary(silenced_chanter))
	# A unit without a secondary skill is never Silenced.
	assert(not silence_plain_foe.has("silenced_turns"))
	# The AI fallback picks the skill-bearing enemy over the higher-ATK
	# skill-less one, and picks nobody when no enemy carries a skill.
	var silence_fallback := UnitSkillsScript.resolve_warcry(lunnain_oracle, silence_units)
	assert(silence_fallback.affected == [441])
	assert(silenced_chanter.silenced_turns == 3)
	assert(UnitSkillsScript.resolve_warcry(
		lunnain_oracle, [lunnain_oracle, silence_plain_foe]
	).affected.is_empty())
	assert(silence_plain_foe.get("silenced_turns", 0) == 0)
	# Chants do not fire while the chanter is Silenced.
	assert(UnitSkillsScript.resolve_chants(1, silence_units).is_empty())
	# Silence ticks down in the same expiry pass as Immobilise, at the end of
	# the silenced unit's own side turns, so it lasts exactly N of them.
	UnitSkillsScript.expire_statuses(silence_units, 0)
	assert(silenced_chanter.silenced_turns == 3)
	UnitSkillsScript.expire_statuses(silence_units, 1)
	assert(silenced_chanter.silenced_turns == 2)
	UnitSkillsScript.expire_statuses(silence_units, 1)
	UnitSkillsScript.expire_statuses(silence_units, 1)
	assert(silenced_chanter.silenced_turns == 0)
	assert(not UnitSkillsScript.is_silenced(silenced_chanter))
	# The chant fires again once the Silence expires.
	var silence_chant_results := UnitSkillsScript.resolve_chants(1, silence_units)
	assert(silence_chant_results.size() == 1)
	assert(silence_smash_target.hp == 5)
	# Strike and Reaction are gated the same way and recover on expiry.
	var silenced_striker := {
		"id": 444, "side": 1, "name": "Silenced Striker", "kind": "Strider",
		"atk": 3, "hp": 4, "max_hp": 4, "effects": [], "silenced_turns": 1,
		"skill": {"name": "Corrosive Edge", "type": "Strike"}
	}
	assert(UnitSkillsScript.resolve_strike(
		silenced_striker, silence_smash_target, silence_units, 0.0
	).message.is_empty())
	assert(silence_smash_target.get("poison_turns", 0) == 0)
	silenced_striker.silenced_turns = 0
	assert(not UnitSkillsScript.resolve_strike(
		silenced_striker, silence_smash_target, silence_units, 0.0
	).message.is_empty())
	assert(silence_smash_target.poison_turns == 2)
	var silenced_reactor := {
		"id": 445, "side": 1, "name": "Silenced Reactor", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": [], "silenced_turns": 1,
		"skill": {"name": "Aegis Array", "type": "Reaction"}
	}
	var silence_attacker := {
		"id": 446, "side": 0, "name": "Attacker", "kind": "Duelist",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	assert(UnitSkillsScript.resolve_reaction(
		silenced_reactor, silence_attacker, silence_units, 0.0
	).message.is_empty())
	assert(silenced_reactor.get("protect_turns", 0) == 0)
	silenced_reactor.silenced_turns = 0
	assert(not UnitSkillsScript.resolve_reaction(
		silenced_reactor, silence_attacker, silence_units, 0.0
	).message.is_empty())
	assert(silenced_reactor.protect_turns == 2)
	# A Silenced Warcry carrier does not trigger its skill.
	var silenced_medic := {
		"id": 447, "side": 1, "name": "Silenced Medic", "kind": "Lifebinder",
		"atk": 1, "hp": 3, "max_hp": 3, "effects": [], "silenced_turns": 1,
		"skill": {"name": "Repair Pulse", "type": "Warcry"}
	}
	assert(UnitSkillsScript.resolve_warcry(
		silenced_medic, silence_units + [silenced_medic]
	).message.is_empty())
	# A Silenced aura source stops contributing: the buff drops while the
	# Silence holds and returns when it expires.
	var silenced_empress := {
		"id": 448, "side": 0, "name": "Silenced Empress", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Lumen Shell", "type": "Aura"}
	}
	var silence_aura_ally := {
		"id": 449, "side": 0, "name": "Aura Ally", "kind": "Warden",
		"atk": 2, "hp": 4, "max_hp": 4, "effects": []
	}
	var silence_aura_units := [silenced_empress, silence_aura_ally]
	var silence_aura_events: Array = []
	UnitSkillsScript.refresh_auras(silence_aura_units, silence_aura_events)
	assert(silence_aura_ally.max_hp == 8)
	silenced_empress.silenced_turns = 1
	UnitSkillsScript.refresh_auras(silence_aura_units, silence_aura_events)
	assert(silence_aura_ally.max_hp == 4)
	assert(silence_aura_events[-1].unit_id == 449 and silence_aura_events[-1].delta == -4)
	silenced_empress.silenced_turns = 0
	UnitSkillsScript.refresh_auras(silence_aura_units, silence_aura_events)
	assert(silence_aura_ally.max_hp == 8)
	# A Silenced Deployment Snare carrier does not spring the trap.
	var silenced_thief := {
		"id": 450, "side": 1, "name": "Silenced Zephyr Lancer-178", "kind": "Strider",
		"row": 0, "col": 4, "atk": 2, "hp": 5, "max_hp": 5, "effects": [],
		"silenced_turns": 1,
		"skill": {
			"name": "Deployment Snare", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Deployment Snare"]
		}
	}
	var snare_silence_victim := {
		"id": 451, "side": 0, "name": "Snare Victim", "kind": "Warden",
		"row": 0, "col": 1, "atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var snare_silence_units := [silenced_thief, snare_silence_victim]
	assert(UnitSkillsScript.resolve_chants(
		0, snare_silence_units, "start", null, 0.0, 451
	).is_empty())
	assert(snare_silence_victim.get("stun_turns", 0) == 0)
	silenced_thief.silenced_turns = 0
	assert(UnitSkillsScript.resolve_chants(
		0, snare_silence_units, "start", null, 0.0, 451
	).size() == 1)
	assert(snare_silence_victim.stun_turns == 2)

	# Chant (end): Dragnet Knocks Back every Taunted enemy, Immobilises
	# it and debuffs its ATK for 1 enemy turn; non-Taunted and allied units
	# are ignored.
	var ra := {
		"id": 430, "side": 0, "name": "Brass Bastion-186", "kind": "Warden",
		"row": 0, "col": 3, "atk": 2, "hp": 10, "max_hp": 10, "effects": [],
		"skill": {
			"name": "Dragnet", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Dragnet"]
		}
	}
	var cattle_taunted_foe := {
		"id": 431, "side": 1, "name": "Taunted Foe", "kind": "Duelist",
		"row": 0, "col": 5, "atk": 4, "hp": 6, "max_hp": 6, "effects": [],
		"taunt_turns": 2
	}
	var cattle_plain_foe := {
		"id": 432, "side": 1, "name": "Plain Foe", "kind": "Strider",
		"row": 1, "col": 5, "atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	var cattle_taunted_ally := {
		"id": 433, "side": 0, "name": "Taunted Ally", "kind": "Warden",
		"row": 2, "col": 4, "atk": 2, "hp": 8, "max_hp": 8, "effects": [],
		"taunt_turns": 2
	}
	var cattle_units := [
		ra, cattle_taunted_foe, cattle_plain_foe, cattle_taunted_ally
	]
	# It is an end-of-turn chant: the start phase and the opposing side's own
	# end phase resolve nothing.
	assert(UnitSkillsScript.resolve_chants(0, cattle_units, "start").is_empty())
	assert(UnitSkillsScript.resolve_chants(1, cattle_units, "end").is_empty())
	var cattle_results := UnitSkillsScript.resolve_chants(0, cattle_units, "end")
	assert(cattle_results.size() == 1)
	assert(cattle_results[0].affected == [431])
	assert(cattle_results[0].moved.size() == 1)
	# The Taunted enemy slides one space away from the chanter and is
	# Immobilised and debuffed for 1 enemy turn; everyone else is untouched.
	assert(cattle_taunted_foe.col == 6)
	assert(cattle_taunted_foe.immobilized_turns == 1)
	assert(cattle_taunted_foe.atk == 3 and cattle_taunted_foe.effects.size() == 1)
	assert(cattle_plain_foe.col == 5 and cattle_plain_foe.atk == 3)
	assert(cattle_plain_foe.get("immobilized_turns", 0) == 0)
	assert(cattle_taunted_ally.col == 4 and cattle_taunted_ally.atk == 2)
	assert(cattle_taunted_ally.get("immobilized_turns", 0) == 0)
	# Both the debuff and the Immobilise lift at the end of the enemy's turn.
	ConductorSkillsScript.expire_effects(cattle_units, 1)
	UnitSkillsScript.expire_statuses(cattle_units, 1)
	assert(cattle_taunted_foe.atk == 4 and cattle_taunted_foe.effects.is_empty())
	assert(cattle_taunted_foe.immobilized_turns == 0)
	# A dead chanter resolves nothing.
	ra.hp = 0
	assert(UnitSkillsScript.resolve_chants(0, cattle_units, "end").is_empty())
	# Level scaling: the level-5 rank row Knocks Back 3 spaces and debuffs
	# 3 ATK.
	var ra_creator := {
		"id": 434, "side": 0, "name": "Brass Bastion-187", "kind": "Warden",
		"row": 0, "col": 2, "atk": 3, "hp": 11, "max_hp": 11, "effects": [],
		"level": 5,
		"skill": UnitCatalogScript.by_name("Brass Bastion-187").skill.to_dict()
	}
	var cattle_veteran_foe := {
		"id": 435, "side": 1, "name": "Veteran Taunted Foe", "kind": "Warden",
		"row": 0, "col": 3, "atk": 5, "hp": 9, "max_hp": 9, "effects": [],
		"taunt_turns": 1
	}
	var cattle_veteran_results := UnitSkillsScript.resolve_chants(
		0, [ra_creator, cattle_veteran_foe], "end"
	)
	assert(cattle_veteran_results.size() == 1)
	assert(cattle_veteran_foe.col == 6)
	assert(cattle_veteran_foe.atk == 2)
	assert(cattle_veteran_foe.immobilized_turns == 1)

	# Chant (start): Petrify Loop Poisons one random living non-Poisoned enemy
	# for a rank-scaled number of enemy turns, then Stuns up to {1} Poisoned
	# enemies in front of the chanter (the Frontline Relay column rule, cross-lane) for
	# 1 enemy turn. An enemy Poisoned by the first part can be Stunned by the
	# second.
	assert(UnitSkillsScript.rank_value(
		UnitCatalogScript.by_name("Flux Weaver-192").skill.to_dict(), 1, 0, 1
	) == 1)
	assert(UnitSkillsScript.rank_value(
		UnitCatalogScript.by_name("Flux Weaver-192").skill.to_dict(), 5, 0, 1
	) == 3)
	assert(UnitSkillsScript.rank_value(
		UnitCatalogScript.by_name("Flux Weaver-192").skill.to_dict(), 5, 1, 1
	) == 3)
	var medusa := {
		"id": 460, "side": 0, "name": "Flux Weaver-192", "kind": "Channeler",
		"row": 0, "col": 3, "atk": 3, "hp": 9, "max_hp": 9, "effects": [],
		"skill": {
			"name": "Petrify Loop", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Petrify Loop"]
		}
	}
	var gaze_fresh_foe := {
		"id": 461, "side": 1, "name": "Fresh Foe", "kind": "Duelist",
		"row": 1, "col": 5, "atk": 4, "hp": 6, "max_hp": 6, "effects": []
	}
	var gaze_poisoned_foe := {
		"id": 462, "side": 1, "name": "Poisoned Foe", "kind": "Warden",
		"row": 2, "col": 4, "atk": 2, "hp": 8, "max_hp": 8, "effects": [],
		"poison_turns": 2, "poison_damage": 1
	}
	var gaze_rear_foe := {
		"id": 463, "side": 1, "name": "Rear Foe", "kind": "Strider",
		"row": 0, "col": 1, "atk": 3, "hp": 5, "max_hp": 5, "effects": [],
		"poison_turns": 2, "poison_damage": 1
	}
	var gaze_beside_foe := {
		"id": 464, "side": 1, "name": "Flank Foe", "kind": "Warden",
		"row": 2, "col": 3, "atk": 2, "hp": 8, "max_hp": 8, "effects": [],
		"poison_turns": 2, "poison_damage": 1
	}
	var gaze_units := [
		medusa, gaze_fresh_foe, gaze_poisoned_foe, gaze_rear_foe, gaze_beside_foe
	]
	# It is a start-of-turn chant: the end phase and the opposing side's own
	# start phase resolve nothing.
	assert(UnitSkillsScript.resolve_chants(0, gaze_units, "end").is_empty())
	assert(UnitSkillsScript.resolve_chants(1, gaze_units).is_empty())
	# The level-1 rank row Poisons for 1 enemy turn and Stuns up to 1 enemy.
	var gaze_results := UnitSkillsScript.resolve_chants(0, gaze_units)
	assert(gaze_results.size() == 1)
	# The only non-Poisoned enemy is the forced random pick: it is Poisoned for
	# 1 enemy turn and, standing in front, is also the single Stun target.
	assert(gaze_results[0].affected == [461])
	assert(gaze_fresh_foe.poison_turns == 1)
	assert(gaze_fresh_foe.poison_damage == 1)
	assert(gaze_fresh_foe.stun_turns == 1)
	# The level-1 cap of 1 Stun leaves the other Poisoned in-front enemy alone,
	# and Poisoned enemies behind or in the chanter's own column are untouched.
	assert(gaze_poisoned_foe.get("stun_turns", 0) == 0)
	assert(gaze_poisoned_foe.poison_turns == 2)
	assert(gaze_rear_foe.get("stun_turns", 0) == 0)
	assert(gaze_beside_foe.get("stun_turns", 0) == 0)
	# The Stun lasts 1 enemy turn; the Poison ticks at the enemy's turn start.
	UnitSkillsScript.expire_statuses(gaze_units, 1)
	assert(gaze_fresh_foe.stun_turns == 0)
	var gaze_status := UnitSkillsScript.resolve_start_statuses(1, gaze_units)
	assert(gaze_status.size() == 4)
	assert(gaze_fresh_foe.hp == 5 and gaze_fresh_foe.poison_turns == 0)
	# A dead or Silenced chanter resolves nothing.
	medusa.hp = 0
	assert(UnitSkillsScript.resolve_chants(0, gaze_units).is_empty())
	medusa.hp = 9
	medusa.silenced_turns = 1
	assert(UnitSkillsScript.resolve_chants(0, gaze_units).is_empty())
	medusa.silenced_turns = 0
	# With no non-Poisoned enemy the first part no-ops: nobody is re-Poisoned,
	# but an in-front Poisoned enemy is still Stunned.
	var gaze_no_fresh_foe := {
		"id": 465, "side": 1, "name": "Still Poisoned Foe", "kind": "Duelist",
		"row": 0, "col": 5, "atk": 3, "hp": 6, "max_hp": 6, "effects": [],
		"poison_turns": 2, "poison_damage": 1
	}
	var gaze_noop_results := UnitSkillsScript.resolve_chants(
		0, [medusa, gaze_no_fresh_foe]
	)
	assert(gaze_noop_results.size() == 1)
	assert("Poisons" not in gaze_noop_results[0].message)
	assert("Stuns" in gaze_noop_results[0].message)
	assert(gaze_noop_results[0].affected == [465])
	assert(gaze_no_fresh_foe.stun_turns == 1)
	assert(gaze_no_fresh_foe.poison_turns == 2)
	# Level scaling: the level-5 rank row Poisons for 3 enemy turns and Stuns
	# up to 3 in-front Poisoned enemies.
	var gorgon_medusa := {
		"id": 466, "side": 0, "name": "Flux Weaver-193", "kind": "Channeler",
		"row": 1, "col": 3, "atk": 4, "hp": 10, "max_hp": 10, "effects": [],
		"level": 5,
		"skill": UnitCatalogScript.by_name("Flux Weaver-193").skill.to_dict()
	}
	var gaze_vet_fresh := {
		"id": 467, "side": 1, "name": "Veteran Fresh Foe", "kind": "Duelist",
		"row": 0, "col": 5, "atk": 4, "hp": 6, "max_hp": 6, "effects": []
	}
	var gaze_vet_poisoned_a := {
		"id": 468, "side": 1, "name": "Veteran Poisoned Foe", "kind": "Warden",
		"row": 1, "col": 4, "atk": 2, "hp": 8, "max_hp": 8, "effects": [],
		"poison_turns": 1, "poison_damage": 1
	}
	var gaze_vet_poisoned_b := {
		"id": 469, "side": 1, "name": "Veteran Far Foe", "kind": "Strider",
		"row": 2, "col": 6, "atk": 3, "hp": 5, "max_hp": 5, "effects": [],
		"poison_turns": 1, "poison_damage": 1
	}
	var gaze_vet_results := UnitSkillsScript.resolve_chants(
		0, [gorgon_medusa, gaze_vet_fresh, gaze_vet_poisoned_a, gaze_vet_poisoned_b]
	)
	assert(gaze_vet_results.size() == 1)
	assert(gaze_vet_results[0].affected == [467, 468, 469])
	assert(gaze_vet_fresh.poison_turns == 3)
	assert(gaze_vet_fresh.stun_turns == 1)
	assert(gaze_vet_poisoned_a.stun_turns == 1)
	assert(gaze_vet_poisoned_b.stun_turns == 1)

	# Reaction: Reactor Leap counters the attacker for fixed damage, but only
	# while the defender survives the attack.
	var bethany := {
		"id": 108, "side": 1, "name": "Brass Battery-098", "kind": "Artillerist",
		"atk": 4, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Reactor Leap", "type": "Reaction"}
	}
	var reaction_attacker := {
		"id": 109, "side": 0, "name": "Attacker", "kind": "Duelist",
		"atk": 3, "hp": 7, "max_hp": 7, "effects": []
	}
	var reaction_result := UnitSkillsScript.resolve_reaction(
		bethany, reaction_attacker, [bethany, reaction_attacker]
	)
	assert(reaction_result.affected == [109])
	assert(reaction_attacker.hp == 4)
	assert("attacks back" in reaction_result.message)
	assert(UnitSkillsScript.resolve_reaction(
		reaction_attacker, bethany, [bethany, reaction_attacker]
	).message.is_empty())
	bethany.hp = 0
	assert(UnitSkillsScript.resolve_reaction(
		bethany, reaction_attacker, [bethany, reaction_attacker]
	).message.is_empty())
	assert(reaction_attacker.hp == 4)

	# Reaction: Aegis Array has a level-based chance to grant the defender
	# Protect, which blocks all damage until it expires.
	var shield_waller := {
		"id": 116, "side": 1, "name": "Brass Bastion-104", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": [],
		"skill": {
			"name": "Aegis Array", "type": "Reaction",
			"rank_values": UnitCatalogScript.RANK_VALUES["Aegis Array"]
		}
	}
	var wall_attacker := {
		"id": 117, "side": 0, "name": "Wall Attacker", "kind": "Duelist",
		"atk": 3, "hp": 7, "max_hp": 7, "effects": []
	}
	var wall_result := UnitSkillsScript.resolve_reaction(
		shield_waller, wall_attacker, [shield_waller, wall_attacker], 0.39
	)
	assert(wall_result.affected == [116])
	assert(shield_waller.protect_turns == 2)
	assert("Aegis Array" in wall_result.message)
	assert(UnitSkillsScript.resolve_reaction(
		shield_waller, wall_attacker, [shield_waller, wall_attacker], 0.40
	).message.is_empty())
	var blocked_hit := BattleSimulatorScript.apply_unit_damage(shield_waller, 3)
	assert(blocked_hit.damage == 0 and blocked_hit.protected)
	assert(shield_waller.hp == 8)
	UnitSkillsScript.expire_statuses([shield_waller], 1)
	assert(shield_waller.protect_turns == 1)
	UnitSkillsScript.expire_statuses([shield_waller], 1)
	assert(shield_waller.protect_turns == 0)
	assert(BattleSimulatorScript.apply_unit_damage(shield_waller, 3).damage == 3)
	assert(shield_waller.hp == 5)

	# Warcry: Cryo Lock damages and Immobilises enemy Scouts and Fighters in the
	# target lane; other classes and lanes are untouched.
	var frost_mage := {
		"id": 118, "side": 0, "name": "Flux Weaver-107", "kind": "Channeler",
		"row": 0, "atk": 3, "hp": 7, "max_hp": 7, "effects": [],
		"skill": {
			"name": "Cryo Lock", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Cryo Lock"]
		}
	}
	var frost_scout := {
		"id": 119, "side": 1, "name": "Frost Scout", "kind": "Strider",
		"row": 2, "atk": 3, "hp": 4, "max_hp": 4, "effects": []
	}
	var frost_fighter := {
		"id": 120, "side": 1, "name": "Frost Fighter", "kind": "Duelist",
		"row": 2, "atk": 4, "hp": 6, "max_hp": 6, "effects": []
	}
	var frost_warden := {
		"id": 121, "side": 1, "name": "Frost Warden", "kind": "Warden",
		"row": 2, "atk": 2, "hp": 9, "max_hp": 9, "effects": []
	}
	var frost_other_lane := {
		"id": 122, "side": 1, "name": "Other Lane Scout", "kind": "Strider",
		"row": 1, "atk": 3, "hp": 4, "max_hp": 4, "effects": []
	}
	var frost_units := [
		frost_mage, frost_scout, frost_fighter, frost_warden, frost_other_lane
	]
	var frost_result := UnitSkillsScript.resolve_warcry(
		frost_mage, frost_units, -1, null, 2
	)
	assert(frost_result.affected == [119, 120])
	assert(frost_scout.hp == 3 and frost_scout.immobilized_turns == 1)
	assert(frost_fighter.hp == 5 and frost_fighter.immobilized_turns == 1)
	assert(frost_warden.hp == 9 and not frost_warden.has("immobilized_turns"))
	assert(frost_other_lane.hp == 4)
	# Without a chosen lane the AI fallback picks the lane with eligible enemies.
	frost_scout.immobilized_turns = 0
	frost_fighter.immobilized_turns = 0
	var frost_fallback := UnitSkillsScript.resolve_warcry(frost_mage, frost_units)
	assert(frost_fallback.affected == [119, 120])
	assert(frost_scout.hp == 2 and frost_fighter.hp == 4)
	# An enemy that dies to the damage is not Immobilised.
	frost_scout.hp = 1
	frost_scout.immobilized_turns = 0
	UnitSkillsScript.resolve_warcry(frost_mage, frost_units, -1, null, 2)
	assert(frost_scout.hp == 0 and frost_scout.immobilized_turns == 0)

	# Strike: Drain Strike has a level-based chance to cut the attacked
	# enemy's ATK for a few turns.
	var swiftblade := {
		"id": 123, "side": 0, "name": "Zephyr Lancer-109", "kind": "Strider",
		"atk": 3, "hp": 4, "max_hp": 4, "effects": [],
		"skill": {
			"name": "Drain Strike", "type": "Strike",
			"rank_values": UnitCatalogScript.RANK_VALUES["Drain Strike"]
		}
	}
	var weaken_target := {
		"id": 124, "side": 1, "name": "Weaken Target", "kind": "Duelist",
		"atk": 5, "hp": 6, "max_hp": 6, "effects": []
	}
	assert(not UnitSkillsScript.resolve_strike(
		swiftblade, weaken_target, [], 0.59
	).message.is_empty())
	assert(weaken_target.atk == 4)
	assert(UnitSkillsScript.resolve_strike(
		swiftblade, weaken_target, [], 0.60
	).message.is_empty())
	assert(weaken_target.atk == 4)
	ConductorSkillsScript.expire_effects([weaken_target], 1)
	ConductorSkillsScript.expire_effects([weaken_target], 1)
	assert(weaken_target.atk == 5)

	# Warcry: Guard Link grants a chosen allied unit Protect for a level-scaled
	# duration; without a chosen target the AI fallback shields the lowest-HP
	# ally, and Protect blocks all damage while it lasts.
	var protector := {
		"id": 130, "side": 0, "name": "Brass Bastion-111", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": [],
		"skill": {
			"name": "Guard Link", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Guard Link"]
		}
	}
	var protect_ally := {
		"id": 131, "side": 0, "name": "Frail Ally", "kind": "Channeler",
		"atk": 3, "hp": 3, "max_hp": 6, "effects": []
	}
	var protect_other := {
		"id": 132, "side": 0, "name": "Sturdy Ally", "kind": "Duelist",
		"atk": 3, "hp": 7, "max_hp": 7, "effects": []
	}
	var protect_units := [protector, protect_ally, protect_other]
	var protect_result := UnitSkillsScript.resolve_warcry(protector, protect_units, 132)
	assert(protect_result.affected == [132])
	assert(protect_other.protect_turns == 2)
	assert("Guard Link" in protect_result.message)
	var protect_fallback := UnitSkillsScript.resolve_warcry(protector, protect_units)
	assert(protect_fallback.affected == [131])
	assert(protect_ally.protect_turns == 2)
	assert(BattleSimulatorScript.apply_unit_damage(protect_ally, 4).protected)
	assert(protect_ally.hp == 3)
	UnitSkillsScript.expire_statuses(protect_units, 0)
	assert(protect_ally.protect_turns == 1)

	# Warcry: Lane Bulwark grants every allied unit in the chosen lane Protect
	# for a level-scaled duration; the AI fallback picks the lane holding the
	# most living allies, and enemies in the lane are ignored.
	var hearts := {
		"id": 400, "side": 0, "name": "Helio Bastion-172", "kind": "Warden",
		"row": 0, "atk": 1, "hp": 8, "max_hp": 8, "effects": [], "level": 5,
		"skill": {
			"name": "Lane Bulwark", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Lane Bulwark"]
		}
	}
	var flush_mate := {
		"id": 401, "side": 0, "name": "Lane Ally", "kind": "Duelist",
		"row": 1, "atk": 3, "hp": 6, "max_hp": 6, "effects": []
	}
	var flush_second := {
		"id": 402, "side": 0, "name": "Second Lane Ally", "kind": "Strider",
		"row": 1, "atk": 2, "hp": 5, "max_hp": 5, "effects": []
	}
	var flush_enemy := {
		"id": 403, "side": 1, "name": "Lane Enemy", "kind": "Warden",
		"row": 1, "atk": 3, "hp": 8, "max_hp": 8, "effects": []
	}
	var flush_units := [hearts, flush_mate, flush_second, flush_enemy]
	var flush_result := UnitSkillsScript.resolve_warcry(
		hearts, flush_units, -1, null, 0
	)
	assert(flush_result.affected == [400])
	assert(hearts.protect_turns == 6)
	assert(not flush_mate.has("protect_turns"))
	var flush_fallback := UnitSkillsScript.resolve_warcry(hearts, flush_units)
	assert(flush_fallback.affected == [401, 402])
	assert(flush_mate.protect_turns == 6 and flush_second.protect_turns == 6)
	assert(not flush_enemy.has("protect_turns"))
	assert(BattleSimulatorScript.apply_unit_damage(flush_mate, 3).protected)
	assert(flush_mate.hp == 6)

	# Warcry: Thermal Wrap heals the chosen ally for a level-scaled amount
	# (overhealing like Repair Pulse) and grants it Protect for a level-scaled
	# duration; the AI fallback picks the lowest-HP ally, and a Silenced
	# caster does not trigger.
	var shepherd := {
		"id": 500, "side": 0, "name": "Brass Mender-196", "kind": "Lifebinder",
		"row": 0, "atk": 3, "hp": 4, "max_hp": 4, "effects": [], "level": 5,
		"skill": {
			"name": "Thermal Wrap", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Thermal Wrap"]
		}
	}
	var blanket_hurt := {
		"id": 501, "side": 0, "name": "Hurt Ally", "kind": "Duelist",
		"row": 1, "atk": 3, "hp": 2, "max_hp": 6, "effects": []
	}
	var blanket_full := {
		"id": 502, "side": 0, "name": "Full Ally", "kind": "Strider",
		"row": 2, "atk": 2, "hp": 5, "max_hp": 5, "effects": []
	}
	var blanket_units := [shepherd, blanket_hurt, blanket_full]
	# Level 5 row: +4 HP and Protect for 3 turns.
	var blanket_result := UnitSkillsScript.resolve_warcry(
		shepherd, blanket_units, 501
	)
	assert(blanket_result.affected == [501])
	assert(blanket_hurt.hp == 6 and blanket_hurt.protect_turns == 3)
	assert(not blanket_full.has("protect_turns"))
	# The heal overheals past max HP, mirroring Repair Pulse.
	var blanket_overheal := UnitSkillsScript.resolve_warcry(
		shepherd, blanket_units, 502
	)
	assert(blanket_overheal.affected == [502])
	assert(blanket_full.hp == 9 and blanket_full.protect_turns == 3)
	# Without a chosen target the AI fallback picks the lowest-HP ally.
	var blanket_fallback := UnitSkillsScript.resolve_warcry(shepherd, blanket_units)
	assert(blanket_fallback.affected == [501])
	assert(blanket_hurt.hp == 10)
	# A Silenced caster's Thermal Wrap does not trigger.
	shepherd.silenced_turns = 1
	var blanket_silenced := UnitSkillsScript.resolve_warcry(
		shepherd, blanket_units, 501
	)
	assert(blanket_silenced.affected.is_empty() and blanket_silenced.message.is_empty())
	assert(blanket_hurt.hp == 10)
	shepherd.silenced_turns = 0

	# Warcry: Umbral Clamp cuts the ATK of every living enemy in the target lane
	# and Immobilises them for a level-scaled duration; other lanes are
	# untouched, the AI fallback picks the highest-value enemy lane, and a
	# Silenced caster does not trigger.
	var edge := {
		"id": 510, "side": 0, "name": "Zephyr Lancer-202", "kind": "Strider",
		"row": 0, "atk": 2, "hp": 5, "max_hp": 5, "effects": [], "level": 5,
		"skill": {
			"name": "Umbral Clamp", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Umbral Clamp"]
		}
	}
	var bind_foe_a := {
		"id": 511, "side": 1, "name": "Bound Foe A", "kind": "Duelist",
		"row": 1, "atk": 4, "hp": 6, "max_hp": 6, "effects": []
	}
	var bind_foe_b := {
		"id": 512, "side": 1, "name": "Bound Foe B", "kind": "Artillerist",
		"row": 1, "atk": 5, "hp": 4, "max_hp": 4, "effects": []
	}
	var bind_other_lane := {
		"id": 513, "side": 1, "name": "Other Lane Foe", "kind": "Warden",
		"row": 2, "atk": 5, "hp": 8, "max_hp": 8, "effects": []
	}
	var bind_units := [edge, bind_foe_a, bind_foe_b, bind_other_lane]
	# Level 5 row: -4 ATK and Immobilise for 3 turns.
	var bind_result := UnitSkillsScript.resolve_warcry(
		edge, bind_units, -1, null, 1
	)
	assert(bind_result.affected == [511, 512])
	assert(bind_foe_a.atk == 0 and bind_foe_a.immobilized_turns == 3)
	assert(bind_foe_b.atk == 1 and bind_foe_b.immobilized_turns == 3)
	assert(bind_other_lane.atk == 5 and not bind_other_lane.has("immobilized_turns"))
	assert("Umbral Clamp" in bind_result.message)
	# The Immobilise ticks down on the enemy side's expiry pass and the ATK
	# debuff expires with its effect timer.
	UnitSkillsScript.expire_statuses(bind_units, 1)
	assert(bind_foe_a.immobilized_turns == 2)
	ConductorSkillsScript.expire_effects(bind_units, 1)
	ConductorSkillsScript.expire_effects(bind_units, 1)
	ConductorSkillsScript.expire_effects(bind_units, 1)
	assert(bind_foe_a.atk == 4 and bind_foe_b.atk == 5)
	assert(bind_foe_a.effects.is_empty())
	# A Silenced caster's Umbral Clamp does not trigger.
	edge.silenced_turns = 1
	var bind_silenced := UnitSkillsScript.resolve_warcry(edge, bind_units, -1, null, 1)
	assert(bind_silenced.affected.is_empty() and bind_silenced.message.is_empty())
	assert(bind_foe_a.atk == 4)
	edge.silenced_turns = 0
	# Without a chosen lane the AI fallback picks the lane worth the most
	# enemy ATK (lane 1: 9 ATK over two units beats lane 2's single 5 ATK).
	bind_foe_a.immobilized_turns = 0
	var bind_fallback := UnitSkillsScript.resolve_warcry(edge, bind_units)
	assert(bind_fallback.affected == [511, 512])
	assert(bind_foe_a.atk == 0 and bind_foe_a.immobilized_turns == 3)
	assert(bind_other_lane.atk == 5 and not bind_other_lane.has("immobilized_turns"))

	# Warcry: Thermal Burst damages a chosen enemy and splashes orthogonally
	# adjacent enemies; the AI fallback hits the highest-HP enemy.
	var dragon := {
		"id": 133, "side": 0, "name": "Cinder Weaver-115", "kind": "Channeler",
		"row": 0, "col": 0, "atk": 5, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {
			"name": "Thermal Burst", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Thermal Burst"]
		}
	}
	var fire_target := {
		"id": 134, "side": 1, "name": "Burned Enemy", "kind": "Warden",
		"row": 1, "col": 3, "atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var fire_adjacent := {
		"id": 135, "side": 1, "name": "Splashed Enemy", "kind": "Duelist",
		"row": 1, "col": 4, "atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	var fire_diagonal := {
		"id": 136, "side": 1, "name": "Diagonal Enemy", "kind": "Strider",
		"row": 2, "col": 4, "atk": 3, "hp": 4, "max_hp": 4, "effects": []
	}
	var fire_units := [dragon, fire_target, fire_adjacent, fire_diagonal]
	var fire_result := UnitSkillsScript.resolve_warcry(dragon, fire_units, 134)
	assert(fire_result.affected == [134, 135])
	assert(fire_target.hp == 7)
	assert(fire_adjacent.hp == 4)
	assert(fire_diagonal.hp == 4)
	var fire_fallback := UnitSkillsScript.resolve_warcry(dragon, fire_units)
	assert(fire_fallback.affected[0] == 134)
	assert(fire_target.hp == 6)

	# Warcry: Combat Surge buffs the lowest-HP allied Defender or Fighter;
	# other classes are ignored and the buff expires with its timer.
	var yeoman := {
		"id": 137, "side": 0, "name": "Brass Blade-117", "kind": "Duelist",
		"atk": 2, "hp": 4, "max_hp": 4, "effects": [],
		"skill": {
			"name": "Combat Surge", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Combat Surge"]
		}
	}
	var vigour_warden := {
		"id": 138, "side": 0, "name": "Hurt Warden", "kind": "Warden",
		"atk": 2, "hp": 3, "max_hp": 6, "effects": []
	}
	var vigour_mage := {
		"id": 139, "side": 0, "name": "Hurt Mage", "kind": "Channeler",
		"atk": 3, "hp": 1, "max_hp": 5, "effects": []
	}
	var vigour_result := UnitSkillsScript.resolve_warcry(
		yeoman, [yeoman, vigour_warden, vigour_mage]
	)
	assert(vigour_result.affected == [138])
	assert(vigour_warden.hp == 5 and vigour_warden.max_hp == 8)
	assert(vigour_warden.atk == 3)
	assert(vigour_mage.hp == 1 and vigour_mage.atk == 3)
	ConductorSkillsScript.expire_effects([vigour_warden], 0)
	ConductorSkillsScript.expire_effects([vigour_warden], 0)
	assert(vigour_warden.atk == 2)
	assert(vigour_warden.max_hp == 6 and vigour_warden.hp == 5)
	# With no eligible Defender or Fighter ally the Warcry does nothing.
	assert(UnitSkillsScript.resolve_warcry(
		yeoman, [yeoman, vigour_mage]
	).message.is_empty())

	# Status: Regen heals 1 HP at the start of the unit's side turn and ticks down.
	var regen_carrier := {
		"id": 140, "side": 0, "name": "Regen Carrier", "kind": "Warden",
		"atk": 2, "hp": 3, "max_hp": 6, "effects": [], "regen_turns": 2
	}
	var regen_results := UnitSkillsScript.resolve_start_statuses(0, [regen_carrier])
	assert(regen_results.size() == 1 and regen_results[0].label == "REGEN")
	assert(regen_carrier.hp == 4 and regen_carrier.regen_turns == 1)

	# Reaction: Holdfast has a level-based chance to grant Regen after being attacked.
	var gritter := {
		"id": 141, "side": 1, "name": "Cinder Bastion-119", "kind": "Warden",
		"atk": 2, "hp": 7, "max_hp": 7, "effects": [],
		"skill": {
			"name": "Holdfast", "type": "Reaction",
			"rank_values": UnitCatalogScript.RANK_VALUES["Holdfast"]
		}
	}
	var grit_attacker := {
		"id": 142, "side": 0, "name": "Holdfast Attacker", "kind": "Duelist",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	var grit_result := UnitSkillsScript.resolve_reaction(
		gritter, grit_attacker, [gritter, grit_attacker], 0.39
	)
	assert(grit_result.affected == [141])
	assert(gritter.regen_turns == 2)
	assert(UnitSkillsScript.resolve_reaction(
		gritter, grit_attacker, [gritter, grit_attacker], 0.40
	).message.is_empty())

	# Warcry: Purge Routine/Refit Cycle/Field Recovery cleanse Immobilise from a class-matched ally
	# and grant Regen; the AI fallback picks the lowest-HP ally of the class.
	var prune_actor := {
		"id": 143, "side": 0, "name": "Helio Mender-123", "kind": "Lifebinder",
		"atk": 2, "hp": 4, "max_hp": 4, "effects": [],
		"skill": {
			"name": "Purge Routine", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Purge Routine"]
		}
	}
	var prune_mage := {
		"id": 144, "side": 0, "name": "Pinned Mage", "kind": "Channeler",
		"atk": 3, "hp": 4, "max_hp": 4, "effects": [], "immobilized_turns": 2
	}
	var prune_warden := {
		"id": 145, "side": 0, "name": "Pinned Warden", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": [], "immobilized_turns": 2
	}
	var prune_units := [prune_actor, prune_mage, prune_warden]
	var prune_result := UnitSkillsScript.resolve_warcry(prune_actor, prune_units)
	assert(prune_result.affected == [144])
	assert(prune_mage.immobilized_turns == 0 and prune_mage.regen_turns == 2)
	assert(prune_warden.immobilized_turns == 2)
	# A chosen target of the wrong class is rejected and the fallback applies.
	var prune_wrong := UnitSkillsScript.resolve_warcry(prune_actor, prune_units, 145)
	assert(prune_wrong.affected == [144])
	var medic_actor := {
		"id": 146, "side": 0, "name": "Helio Mender-126", "kind": "Lifebinder",
		"atk": 3, "hp": 4, "max_hp": 4, "effects": [],
		"skill": {
			"name": "Field Recovery", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Field Recovery"]
		}
	}
	var medic_result := UnitSkillsScript.resolve_warcry(
		medic_actor, [medic_actor, prune_mage, prune_warden]
	)
	assert(medic_result.affected == [145])
	assert(prune_warden.immobilized_turns == 0 and prune_warden.regen_turns == 2)
	var stylist_actor := {
		"id": 147, "side": 0, "name": "Helio Lancer-130", "kind": "Strider",
		"atk": 2, "hp": 4, "max_hp": 4, "effects": [],
		"skill": {
			"name": "Refit Cycle", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Refit Cycle"]
		}
	}
	var pinned_gunner := {
		"id": 148, "side": 0, "name": "Pinned Gunner", "kind": "Artillerist",
		"atk": 3, "hp": 3, "max_hp": 3, "effects": [], "immobilized_turns": 1
	}
	var look_result := UnitSkillsScript.resolve_warcry(
		stylist_actor, [stylist_actor, pinned_gunner, prune_warden]
	)
	assert(look_result.affected == [148])
	assert(pinned_gunner.immobilized_turns == 0 and pinned_gunner.regen_turns == 2)

	# Chant (start): Renewal Current grants all allies Regen and cleanses Immobilise.
	var witch_doctor := {
		"id": 149, "side": 0, "name": "Helio Mender-132", "kind": "Lifebinder",
		"atk": 2, "hp": 7, "max_hp": 7, "effects": [],
		"skill": {
			"name": "Renewal Current", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Renewal Current"]
		}
	}
	var lifestream_ally := {
		"id": 150, "side": 0, "name": "Sick Ally", "kind": "Duelist",
		"atk": 2, "hp": 5, "max_hp": 5, "effects": [], "immobilized_turns": 3
	}
	var lifestream_results := UnitSkillsScript.resolve_chants(
		0, [witch_doctor, lifestream_ally]
	)
	assert(lifestream_results.size() == 1)
	assert(witch_doctor.regen_turns == 2 and lifestream_ally.regen_turns == 2)
	assert(lifestream_ally.immobilized_turns == 0)

	# Strike: Kinetic Throw knocks the target back, stopping at the board edge and
	# at occupied cells.
	var hamish := {
		"id": 151, "side": 0, "name": "Helio Bastion-134", "kind": "Warden",
		"row": 0, "col": 2, "atk": 1, "hp": 7, "max_hp": 7, "effects": [],
		"skill": {
			"name": "Kinetic Throw", "type": "Strike",
			"rank_values": UnitCatalogScript.RANK_VALUES["Kinetic Throw"]
		}
	}
	var caber_target := {
		"id": 152, "side": 1, "name": "Tossed Enemy", "kind": "Duelist",
		"row": 0, "col": 4, "atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	var caber_blocker := {
		"id": 153, "side": 1, "name": "Blocking Enemy", "kind": "Warden",
		"row": 0, "col": 6, "atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var caber_result := UnitSkillsScript.resolve_strike(
		hamish, caber_target, [hamish, caber_target, caber_blocker], 0.29
	)
	assert(caber_result.affected == [152])
	assert(caber_target.col == 5) # col 6 is occupied, so the toss stops early
	assert(caber_result.moved[0].from_col == 4)
	assert(hamish.regen_turns == 1)
	assert(UnitSkillsScript.resolve_strike(
		hamish, caber_target, [hamish, caber_target, caber_blocker], 0.30
	).message.is_empty() or hamish.regen_turns == 1)

	# Reaction: Pressure Sink can grant permanent ATK and Regen.
	var barney := {
		"id": 154, "side": 1, "name": "Brass Bastion-138", "kind": "Warden",
		"atk": 0, "hp": 8, "max_hp": 8, "effects": [],
		"skill": {
			"name": "Pressure Sink", "type": "Reaction",
			"rank_values": UnitCatalogScript.RANK_VALUES["Pressure Sink"]
		}
	}
	var pressure_result := UnitSkillsScript.resolve_reaction(
		barney, grit_attacker, [barney, grit_attacker], 0.59
	)
	assert(pressure_result.affected == [154])
	assert(barney.atk == 1 and barney.regen_turns == 1)
	assert(UnitSkillsScript.resolve_reaction(
		barney, grit_attacker, [barney, grit_attacker], 0.60
	).message.is_empty())

	# Strike: Saturation Fire hits enemies outside the attacker's lane.
	var basilic := {
		"id": 155, "side": 0, "name": "Flux Battery-140", "kind": "Artillerist",
		"row": 0, "col": 1, "atk": 4, "hp": 9, "max_hp": 9, "effects": [],
		"skill": {
			"name": "Saturation Fire", "type": "Strike",
			"rank_values": UnitCatalogScript.RANK_VALUES["Saturation Fire"]
		}
	}
	var barrage_lane_foe := {
		"id": 156, "side": 1, "name": "Lane Foe", "kind": "Warden",
		"row": 0, "col": 4, "atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var barrage_far_foe := {
		"id": 157, "side": 1, "name": "Far Foe", "kind": "Duelist",
		"row": 1, "col": 4, "atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	var barrage_result := UnitSkillsScript.resolve_strike(
		basilic, barrage_lane_foe, [basilic, barrage_lane_foe, barrage_far_foe], 0.39
	)
	assert(barrage_result.affected == [157])
	assert(barrage_far_foe.hp == 3 and barrage_lane_foe.hp == 8)
	assert(basilic.regen_turns == 2)

	# Warcry: Cover Matrix Protects the whole team; at max rank it always adds Regen.
	var oro := {
		"id": 158, "side": 0, "name": "Helio Mender-143", "kind": "Lifebinder",
		"atk": 2, "hp": 4, "max_hp": 4, "effects": [], "level": 5,
		"skill": {
			"name": "Cover Matrix", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Cover Matrix"]
		}
	}
	var guard_ally := {
		"id": 159, "side": 0, "name": "Cover Matrix Ally", "kind": "Duelist",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	var guard_result := UnitSkillsScript.resolve_warcry(oro, [oro, guard_ally])
	assert(guard_result.affected == [158, 159])
	assert(oro.protect_turns == 3 and guard_ally.protect_turns == 3)
	assert(oro.regen_turns == 2 and guard_ally.regen_turns == 2)

	# Strike: Clamp Drain only fires against an Immobilised target.
	var cara := {
		"id": 160, "side": 0, "name": "Zephyr Lancer-144", "kind": "Strider",
		"atk": 0, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {
			"name": "Clamp Drain", "type": "Strike",
			"rank_values": UnitCatalogScript.RANK_VALUES["Clamp Drain"]
		}
	}
	var pincer_target := {
		"id": 161, "side": 1, "name": "Pinned Target", "kind": "Warden",
		"atk": 2, "hp": 6, "max_hp": 6, "effects": [], "immobilized_turns": 1
	}
	var pincer_result := UnitSkillsScript.resolve_strike(
		cara, pincer_target, [cara, pincer_target], 0.29
	)
	assert(pincer_result.affected == [160])
	assert(cara.atk == 1 and cara.regen_turns == 1)
	var free_target := {
		"id": 162, "side": 1, "name": "Free Target", "kind": "Warden",
		"atk": 2, "hp": 6, "max_hp": 6, "effects": []
	}
	assert(UnitSkillsScript.resolve_strike(
		cara, free_target, [cara, free_target], 0.29
	).message.is_empty())

	# Strike: Vector Flurry knocks back the target plus the highest-ATK other enemy.
	var clair := {
		"id": 163, "side": 0, "name": "Relay Blade-146", "kind": "Duelist",
		"row": 1, "col": 2, "atk": 4, "hp": 5, "max_hp": 5, "effects": [],
		"skill": {
			"name": "Vector Flurry", "type": "Strike",
			"rank_values": UnitCatalogScript.RANK_VALUES["Vector Flurry"]
		}
	}
	var slash_target := {
		"id": 164, "side": 1, "name": "Slashed Enemy", "kind": "Warden",
		"row": 1, "col": 3, "atk": 2, "hp": 8, "max_hp": 8, "effects": []
	}
	var slash_other := {
		"id": 165, "side": 1, "name": "Strong Enemy", "kind": "Duelist",
		"row": 0, "col": 3, "atk": 6, "hp": 5, "max_hp": 5, "effects": []
	}
	var slash_weak := {
		"id": 166, "side": 1, "name": "Weak Enemy", "kind": "Strider",
		"row": 2, "col": 3, "atk": 1, "hp": 4, "max_hp": 4, "effects": []
	}
	var slash_result := UnitSkillsScript.resolve_strike(
		clair, slash_target, [clair, slash_target, slash_other, slash_weak], 0.39
	)
	assert(slash_result.affected == [164, 165])
	assert(slash_target.col == 5 and slash_other.col == 5)
	assert(slash_weak.col == 3)
	assert(clair.regen_turns == 1)

	# Chant (start): Lasting Aegis Protects and Regens the team, then the doom
	# timer defeats the caster after the listed number of enemy turns.
	var white_mage := {
		"id": 167, "side": 0, "name": "Cinder Mender-148", "kind": "Lifebinder",
		"atk": 2, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {
			"name": "Lasting Aegis", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Lasting Aegis"]
		}
	}
	var mighty_units := [white_mage, guard_ally]
	var mighty_results := UnitSkillsScript.resolve_chants(0, mighty_units)
	assert(mighty_results.size() == 1)
	assert(white_mage.protect_turns == 2 and white_mage.regen_turns == 2)
	assert(white_mage.doom_turns == 1)
	UnitSkillsScript.expire_statuses(mighty_units, 0)
	assert(white_mage.hp > 0) # the caster's own turn does not tick doom
	UnitSkillsScript.expire_statuses(mighty_units, 1)
	assert(white_mage.hp == 0)

	# Chant (start): Tidal Reset cleanses Immobilise and Stun from random
	# other allies and grants Regen.
	var steph := {
		"id": 168, "side": 0, "name": "Zephyr Weaver-150", "kind": "Channeler",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {
			"name": "Tidal Reset", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Tidal Reset"]
		}
	}
	var reclaim_ally := {
		"id": 169, "side": 0, "name": "Snared Ally", "kind": "Duelist",
		"atk": 2, "hp": 5, "max_hp": 5, "effects": [],
		"immobilized_turns": 2, "stun_turns": 1
	}
	var reclaim_results := UnitSkillsScript.resolve_chants(0, [steph, reclaim_ally])
	assert(reclaim_results.size() == 1 and reclaim_results[0].affected == [169])
	assert(reclaim_ally.immobilized_turns == 0 and reclaim_ally.stun_turns == 0)
	assert(reclaim_ally.regen_turns == 2)

	# Reaction: Reversal Current Taunts the attacker and can grant Regen.
	var ant := {
		"id": 170, "side": 1, "name": "Zephyr Bastion-152", "kind": "Warden",
		"atk": 1, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {
			"name": "Reversal Current", "type": "Reaction",
			"rank_values": UnitCatalogScript.RANK_VALUES["Reversal Current"]
		}
	}
	var tide_result := UnitSkillsScript.resolve_reaction(
		ant, grit_attacker, [ant, grit_attacker], 0.19
	)
	assert(grit_attacker.taunt_turns == 1 and ant.regen_turns == 1)
	assert(BattleRulesScript.is_taunted(grit_attacker, [ant, grit_attacker]))
	grit_attacker.taunt_turns = 0
	ant.regen_turns = 0
	UnitSkillsScript.resolve_reaction(ant, grit_attacker, [ant, grit_attacker], 0.20)
	assert(ant.regen_turns == 0)

	# Reaction: Repulse Command knocks the attacker back and Immobilises it.
	var ki := {
		"id": 171, "side": 1, "name": "Flux Bastion-154", "kind": "Warden",
		"row": 0, "col": 3, "atk": 2, "hp": 7, "max_hp": 7, "effects": [],
		"skill": {
			"name": "Repulse Command", "type": "Reaction",
			"rank_values": UnitCatalogScript.RANK_VALUES["Repulse Command"]
		}
	}
	var yield_attacker := {
		"id": 172, "side": 0, "name": "Charging Attacker", "kind": "Duelist",
		"row": 0, "col": 2, "atk": 3, "hp": 5, "max_hp": 5, "effects": []
	}
	var yield_result := UnitSkillsScript.resolve_reaction(
		ki, yield_attacker, [ki, yield_attacker], 0.29
	)
	assert(yield_result.affected.has(172))
	assert(yield_attacker.col == 0)
	assert(yield_attacker.immobilized_turns == 2)
	assert(ki.regen_turns == 1)

	# Chant (end): Lockdown Sweep and Grounding Wave only resolve in the end
	# phase; Grounding Wave Stuns, and Stun blocks activation and movement.
	var rook := {
		"id": 173, "side": 0, "name": "Brass Bastion-136", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": [],
		"skill": {
			"name": "Lockdown Sweep", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Lockdown Sweep"]
		}
	}
	var gawain := {
		"id": 174, "side": 0, "name": "Relay Blade-156", "kind": "Duelist",
		"atk": 2, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {
			"name": "Grounding Wave", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Grounding Wave"]
		}
	}
	var taunted_foe := {
		"id": 175, "side": 1, "name": "Taunted Foe", "kind": "Duelist",
		"row": 0, "col": 4, "move": 2, "range": 1, "atk": 3, "hp": 5, "max_hp": 5,
		"effects": [], "taunt_turns": 1, "ready": true
	}
	var joust_units := [rook, gawain, taunted_foe]
	assert(UnitSkillsScript.resolve_chants(0, joust_units, "start").is_empty())
	var joust_results := UnitSkillsScript.resolve_chants(0, joust_units, "end", null, 0.29)
	assert(joust_results.size() == 2)
	assert(taunted_foe.immobilized_turns == 1)
	assert(taunted_foe.stun_turns == 1)
	assert(rook.regen_turns == 3 and gawain.regen_turns == 3)
	var stun_sim := BattleSimulator.new()
	assert(stun_sim.activation_order(1, joust_units).is_empty())
	assert(BattleRulesScript.traversal_cells(taunted_foe, joust_units).is_empty())
	assert(not BattleRulesScript.can_reposition(taunted_foe, 1, joust_units))
	UnitSkillsScript.expire_statuses(joust_units, 1)
	assert(taunted_foe.stun_turns == 0)

	# Chant (start): Growth Pulse buffs only allies carrying Regen, for 1 turn.
	var sakura := {
		"id": 176, "side": 0, "name": "Brass Weaver-158", "kind": "Channeler",
		"atk": 2, "hp": 7, "max_hp": 7, "effects": [],
		"skill": {
			"name": "Growth Pulse", "type": "Chant",
			"rank_values": UnitCatalogScript.RANK_VALUES["Growth Pulse"]
		}
	}
	var bloom_ally := {
		"id": 177, "side": 0, "name": "Regen Ally", "kind": "Duelist",
		"atk": 2, "hp": 5, "max_hp": 5, "effects": [], "regen_turns": 1
	}
	var bloom_plain := {
		"id": 178, "side": 0, "name": "Plain Ally", "kind": "Duelist",
		"atk": 2, "hp": 5, "max_hp": 5, "effects": []
	}
	var bloom_units := [sakura, bloom_ally, bloom_plain]
	var bloom_results := UnitSkillsScript.resolve_chants(0, bloom_units)
	assert(bloom_results.size() == 1 and bloom_results[0].affected == [177])
	assert(bloom_ally.atk == 3 and bloom_plain.atk == 2)
	ConductorSkillsScript.expire_effects(bloom_units, 0)
	assert(bloom_ally.atk == 2)

	# Warcry + end phase: Solar Crescendo counts down, then heals all allies and
	# grants Regen carriers ATK and Haste (Haste adds +1 movement).
	var inti := {
		"id": 179, "side": 0, "name": "Helio Mender-160", "kind": "Lifebinder",
		"row": 0, "col": 0, "move": 1, "range": 2, "atk": 1, "hp": 3, "max_hp": 4,
		"effects": [],
		"skill": {
			"name": "Solar Crescendo", "type": "Warcry",
			"rank_values": UnitCatalogScript.RANK_VALUES["Solar Crescendo"]
		}
	}
	var festival_ally := {
		"id": 180, "side": 0, "name": "Festive Ally", "kind": "Duelist",
		"row": 1, "col": 0, "move": 2, "range": 1, "atk": 2, "hp": 4, "max_hp": 6,
		"effects": [], "regen_turns": 1
	}
	var festival_units := [inti, festival_ally]
	var festival_warcry := UnitSkillsScript.resolve_warcry(inti, festival_units)
	assert(not festival_warcry.message.is_empty())
	assert(inti.festival_turns == 2)
	assert(UnitSkillsScript.resolve_chants(0, festival_units, "end").is_empty())
	assert(inti.festival_turns == 1)
	var festival_results := UnitSkillsScript.resolve_chants(0, festival_units, "end")
	assert(festival_results.size() == 1)
	assert(inti.hp == 4 and festival_ally.hp == 6)
	assert(festival_ally.atk == 3 and festival_ally.haste_turns == 1)
	assert(inti.get("haste_turns", 0) == 0) # Inti carries no Regen
	assert(BattleRulesScript.traversal_cells(festival_ally, festival_units).size() == 3)
	UnitSkillsScript.expire_statuses(festival_units, 0)
	assert(festival_ally.haste_turns == 0)

	# Strike: Shield Exchange steals Protect from the enemy team for its allies.
	var hohenheim := {
		"id": 181, "side": 0, "name": "Helio Mender-162", "kind": "Lifebinder",
		"atk": 1, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {
			"name": "Shield Exchange", "type": "Strike",
			"rank_values": UnitCatalogScript.RANK_VALUES["Shield Exchange"]
		}
	}
	var prospect_target := {
		"id": 182, "side": 1, "name": "Shielded Enemy", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": [], "protect_turns": 2
	}
	var prospect_other_foe := {
		"id": 183, "side": 1, "name": "Also Shielded", "kind": "Duelist",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": [], "protect_turns": 1
	}
	var prospect_units := [hohenheim, prospect_target, prospect_other_foe]
	var prospect_result := UnitSkillsScript.resolve_strike(
		hohenheim, prospect_target, prospect_units
	)
	assert(prospect_result.affected == [181])
	assert(prospect_target.protect_turns == 0 and prospect_other_foe.protect_turns == 0)
	assert(hohenheim.protect_turns == 2 and hohenheim.regen_turns == 2)
	# Without Protect on the target nothing happens.
	assert(UnitSkillsScript.resolve_strike(
		hohenheim, prospect_target, prospect_units
	).message.is_empty())

	# Reaction: Paired Circuit buffs the highest-ATK other ally and can self-Regen.
	var furia := {
		"id": 184, "side": 0, "name": "Cinder Bastion-166", "kind": "Warden",
		"atk": 2, "hp": 8, "max_hp": 8, "effects": [],
		"skill": {
			"name": "Paired Circuit", "type": "Reaction",
			"rank_values": UnitCatalogScript.RANK_VALUES["Paired Circuit"]
		}
	}
	var tag_partner := {
		"id": 185, "side": 0, "name": "Partner", "kind": "Duelist",
		"atk": 5, "hp": 4, "max_hp": 4, "effects": []
	}
	var tag_result := UnitSkillsScript.resolve_reaction(
		furia, grit_attacker, [furia, tag_partner, grit_attacker], 0.19
	)
	assert(tag_result.affected.has(185))
	assert(tag_partner.atk == 6 and furia.regen_turns == 1)

	# The paired Strike skills detect one another by skill identity.
	var resonance_unit := {
		"id": 186, "side": 0, "name": "Cinder Battery-171", "kind": "Artillerist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {
			"name": "Twin Resonance", "type": "Strike",
			"rank_values": UnitCatalogScript.RANK_VALUES["Twin Resonance"]
		}
	}
	var dissonance_unit := {
		"id": 187, "side": 0, "name": "Zephyr Weaver-169", "kind": "Channeler",
		"atk": 4, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {
			"name": "Twin Dissonance", "type": "Strike",
			"rank_values": UnitCatalogScript.RANK_VALUES["Twin Dissonance"]
		}
	}
	var brother_foe := {
		"id": 188, "side": 1, "name": "Brother Foe", "kind": "Warden",
		"atk": 3, "hp": 8, "max_hp": 8, "effects": []
	}
	# Twin Resonance: allies gain HP; its paired skill enables the Regen rider.
	var resonance_result := UnitSkillsScript.resolve_strike(
		resonance_unit, brother_foe, [resonance_unit, brother_foe]
	)
	assert(resonance_result.affected == [186])
	assert(resonance_unit.hp == 7 and resonance_unit.max_hp == 7)
	assert(resonance_unit.get("regen_turns", 0) == 0)
	var paired_resonance_result := UnitSkillsScript.resolve_strike(
		resonance_unit, brother_foe, [resonance_unit, dissonance_unit, brother_foe]
	)
	assert(paired_resonance_result.affected == [186, 187])
	assert(resonance_unit.regen_turns == 2 and dissonance_unit.regen_turns == 2)
	ConductorSkillsScript.expire_effects([resonance_unit, dissonance_unit], 0)
	assert(resonance_unit.max_hp == 8) # both +1 HP stacks still active
	ConductorSkillsScript.expire_effects([resonance_unit, dissonance_unit], 0)
	assert(resonance_unit.max_hp == 6 and resonance_unit.hp == 6) # both stacks expired together
	# Twin Dissonance: enemies lose ATK; its paired skill enables Vulnerable.
	resonance_unit.hp = 6
	var dissonance_result := UnitSkillsScript.resolve_strike(
		dissonance_unit, brother_foe, [dissonance_unit, brother_foe]
	)
	assert(dissonance_result.affected == [188])
	assert(brother_foe.atk == 2)
	assert(brother_foe.get("vulnerable_turns", 0) == 0)
	var paired_dissonance_result := UnitSkillsScript.resolve_strike(
		dissonance_unit, brother_foe, [dissonance_unit, resonance_unit, brother_foe]
	)
	assert(brother_foe.atk == 1 and brother_foe.vulnerable_turns == 2)
	assert("linked counterpart" in paired_dissonance_result.message)

	# Aura: Lumen Shell raises allied current and max HP while the source lives.
	var empress := {
		"id": 110, "side": 0, "name": "Relay Blade-100", "kind": "Duelist",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [],
		"skill": {"name": "Lumen Shell", "type": "Aura"}
	}
	var moonlit_ally := {
		"id": 111, "side": 0, "name": "Moonlit Ally", "kind": "Warden",
		"atk": 2, "hp": 4, "max_hp": 8, "effects": []
	}
	var moonlit_foe := {
		"id": 112, "side": 1, "name": "Foe", "kind": "Strider",
		"atk": 2, "hp": 5, "max_hp": 5, "effects": []
	}
	var aura_units := [empress, moonlit_ally, moonlit_foe]
	var aura_events: Array = []
	UnitSkillsScript.refresh_auras(aura_units, aura_events)
	assert(aura_events.size() == 1)
	assert(aura_events[0].unit_id == 111 and aura_events[0].delta == 4)
	assert(aura_events[0].label == "Lumen Shell")
	assert(moonlit_ally.hp == 8 and moonlit_ally.max_hp == 12)
	assert(empress.hp == 6 and empress.max_hp == 6)
	assert(moonlit_foe.hp == 5 and moonlit_foe.max_hp == 5)
	# Refreshing while the source lives is idempotent and reports no changes.
	aura_events.clear()
	UnitSkillsScript.refresh_auras(aura_units, aura_events)
	assert(aura_events.is_empty())
	assert(moonlit_ally.hp == 8 and moonlit_ally.max_hp == 12)
	# The buff disappears when the source leaves the board.
	UnitSkillsScript.refresh_auras([moonlit_ally, moonlit_foe], aura_events)
	assert(aura_events.size() == 1)
	assert(aura_events[0].unit_id == 111 and aura_events[0].delta == -4)
	assert(aura_events[0].label == "Lumen Shell")
	assert(moonlit_ally.hp == 4 and moonlit_ally.max_hp == 8)
	# Losing the aura never kills: HP bottoms out at 1.
	UnitSkillsScript.refresh_auras(aura_units)
	moonlit_ally.hp = 2
	UnitSkillsScript.refresh_auras([moonlit_ally, moonlit_foe])
	assert(moonlit_ally.hp == 1 and moonlit_ally.max_hp == 8)
	# Two sources stack, aura units buff each other, and level scales the aura.
	var opelle := {
		"id": 113, "side": 0, "name": "Helio Mender-102", "kind": "Lifebinder",
		"atk": 3, "hp": 5, "max_hp": 5, "effects": [], "level": 2,
		"skill": UnitCatalogScript.by_name("Helio Mender-102").skill.to_dict()
	}
	UnitSkillsScript.refresh_auras(aura_units + [opelle])
	assert(moonlit_ally.hp == 10 and moonlit_ally.max_hp == 17)
	assert(empress.max_hp == 11 and opelle.max_hp == 9)

	# Aura: Resonant Chorus grants OTHER allied resonant-frame +{0} max HP and +{1}
	# ATK; non-resonant-frame allies and the source itself are unaffected.
	var inspire_skill: Dictionary = UnitCatalogScript.by_name("Zephyr Mender-208").skill.to_dict()
	assert(UnitSkillsScript.rank_value(inspire_skill, 1, 0, 1) == 1)
	assert(UnitSkillsScript.rank_value(inspire_skill, 1, 1, 1) == 1)
	assert(UnitSkillsScript.rank_value(inspire_skill, 5, 0, 1) == 4)
	assert(UnitSkillsScript.rank_value(inspire_skill, 5, 1, 1) == 2)
	var minstrel := {
		"id": 120, "side": 0, "name": "Zephyr Mender-208", "kind": "Lifebinder",
		"atk": 2, "hp": 3, "max_hp": 3, "effects": [], "chassis_family": "resonant",
		"skill": inspire_skill
	}
	var resonant_ally := {
		"id": 121, "side": 0, "name": "Cinder Mender-213", "kind": "Lifebinder",
		"atk": 2, "hp": 3, "max_hp": 5, "effects": [], "chassis_family": "resonant"
	}
	var standard_ally := {
		"id": 122, "side": 0, "name": "Human Ally", "kind": "Warden",
		"atk": 3, "hp": 6, "max_hp": 6, "effects": [], "chassis_family": "standard"
	}
	var inspire_units := [minstrel, resonant_ally, standard_ally]
	var inspire_events: Array = []
	UnitSkillsScript.refresh_auras(inspire_units, inspire_events)
	assert(inspire_events.size() == 2)
	assert(inspire_events[0].unit_id == 121 and inspire_events[0].delta == 1)
	assert(inspire_events[0].label == "Resonant Chorus")
	assert(inspire_events[0].stat == "HP")
	assert(inspire_events[1].unit_id == 121 and inspire_events[1].delta == 1)
	assert(inspire_events[1].stat == "ATK")
	assert(resonant_ally.max_hp == 6 and resonant_ally.hp == 4)
	assert(resonant_ally.atk == 3)
	assert(minstrel.max_hp == 3 and minstrel.atk == 2)
	assert(standard_ally.max_hp == 6 and standard_ally.atk == 3)
	# Refreshing while the source lives is idempotent.
	inspire_events.clear()
	UnitSkillsScript.refresh_auras(inspire_units, inspire_events)
	assert(inspire_events.is_empty())
	assert(resonant_ally.max_hp == 6 and resonant_ally.atk == 3)
	# Both buffs drop when the source dies.
	minstrel.hp = 0
	UnitSkillsScript.refresh_auras(inspire_units, inspire_events)
	assert(resonant_ally.max_hp == 5 and resonant_ally.atk == 2)
	# Both buffs drop while the source is Silenced and return when it expires.
	minstrel.hp = 3
	minstrel.silenced_turns = 1
	UnitSkillsScript.refresh_auras(inspire_units, inspire_events)
	assert(resonant_ally.max_hp == 5 and resonant_ally.atk == 2)
	minstrel.silenced_turns = 0
	UnitSkillsScript.refresh_auras(inspire_units, inspire_events)
	assert(resonant_ally.max_hp == 6 and resonant_ally.atk == 3)
	# Two sources stack (like Lumen Shell), and carriers buff each other.
	var harlequin := {
		"id": 123, "side": 0, "name": "Flux Weaver-211", "kind": "Channeler",
		"atk": 5, "hp": 4, "max_hp": 4, "effects": [], "chassis_family": "resonant", "level": 5,
		"skill": UnitCatalogScript.by_name("Flux Weaver-211").skill.to_dict()
	}
	UnitSkillsScript.refresh_auras(inspire_units + [harlequin])
	assert(resonant_ally.max_hp == 10 and resonant_ally.atk == 5)
	assert(minstrel.max_hp == 7 and minstrel.atk == 4)
	assert(harlequin.max_hp == 5 and harlequin.atk == 6)
	assert(standard_ally.max_hp == 6 and standard_ally.atk == 3)

	# Chassis-family batch: each Aura buffs only its authored family. Foundation
	# Grid grants HP/ATK to Standard frames, Aegis Lattice grants HP to Bulwark
	# frames, and Vector Manifold grants movement to Swift frames.
	var foundation_source := {
		"id": 130, "side": 0, "name": "Relay Battery-217", "atk": 3,
		"hp": 4, "max_hp": 4, "move": 1, "effects": [], "level": 1,
		"chassis_family": "standard",
		"skill": UnitCatalogScript.by_name("Relay Battery-217").skill.to_dict()
	}
	var aegis_source := {
		"id": 131, "side": 0, "name": "Cinder Bastion-219", "atk": 2,
		"hp": 9, "max_hp": 9, "move": 2, "effects": [], "level": 1,
		"chassis_family": "bulwark",
		"skill": UnitCatalogScript.by_name("Cinder Bastion-219").skill.to_dict()
	}
	var vector_source := {
		"id": 132, "side": 0, "name": "Zephyr Lancer-221", "atk": 2,
		"hp": 4, "max_hp": 4, "move": 3, "effects": [], "level": 1,
		"chassis_family": "swift", "silenced_turns": 0,
		"skill": UnitCatalogScript.by_name("Zephyr Lancer-221").skill.to_dict()
	}
	var foundation_ally := {
		"id": 133, "side": 0, "name": "Standard Ally", "atk": 3,
		"hp": 5, "max_hp": 5, "move": 2, "effects": [], "chassis_family": "standard"
	}
	var aegis_ally := {
		"id": 134, "side": 0, "name": "Bulwark Ally", "atk": 2,
		"hp": 8, "max_hp": 8, "move": 2, "effects": [], "chassis_family": "bulwark"
	}
	var vector_ally := {
		"id": 135, "side": 0, "name": "Swift Ally", "atk": 2,
		"hp": 4, "max_hp": 4, "move": 3, "effects": [], "chassis_family": "swift"
	}
	var resonance_ally := {
		"id": 136, "side": 0, "name": "Resonant Ally", "atk": 2,
		"hp": 4, "max_hp": 4, "move": 1, "effects": [], "chassis_family": "resonant"
	}
	var chassis_aura_units := [
		foundation_source, aegis_source, vector_source,
		foundation_ally, aegis_ally, vector_ally, resonance_ally
	]
	var chassis_aura_events: Array = []
	UnitSkillsScript.refresh_auras(chassis_aura_units, chassis_aura_events)
	assert(foundation_ally.max_hp == 6 and foundation_ally.atk == 4)
	assert(aegis_ally.max_hp == 10 and aegis_ally.atk == 2)
	assert(vector_ally.move == 4)
	assert(resonance_ally.max_hp == 4 and resonance_ally.atk == 2)
	assert(chassis_aura_events.size() == 4)
	assert(chassis_aura_events.any(func(event): return (
		event.unit_id == 135 and event.stat == "MOVE" and event.delta == 1
	)))
	chassis_aura_events.clear()
	UnitSkillsScript.refresh_auras(chassis_aura_units, chassis_aura_events)
	assert(chassis_aura_events.is_empty())
	vector_source.silenced_turns = 1
	UnitSkillsScript.refresh_auras(chassis_aura_units, chassis_aura_events)
	assert(vector_ally.move == 3)
	assert(chassis_aura_events.size() == 1 and chassis_aura_events[0].stat == "MOVE")

	# Resonance Pulse is a start-turn Chant that repairs only other Resonant
	# frames and grants them Regen; its Standard neighbor remains unchanged.
	var pulse_source := {
		"id": 140, "side": 0, "name": "Helio Mender-223", "atk": 2,
		"hp": 5, "max_hp": 5, "move": 1, "effects": [], "level": 1,
		"chassis_family": "resonant", "silenced_turns": 0,
		"skill": UnitCatalogScript.by_name("Helio Mender-223").skill.to_dict()
	}
	var pulse_ally := {
		"id": 141, "side": 0, "name": "Pulse Ally", "atk": 2,
		"hp": 2, "max_hp": 5, "move": 1, "effects": [],
		"regen_turns": 0, "chassis_family": "resonant"
	}
	var pulse_standard := {
		"id": 142, "side": 0, "name": "Pulse Standard", "atk": 2,
		"hp": 2, "max_hp": 5, "move": 1, "effects": [],
		"regen_turns": 0, "chassis_family": "standard"
	}
	var pulse_results := UnitSkillsScript.resolve_chants(
		0, [pulse_source, pulse_ally, pulse_standard], "start"
	)
	assert(pulse_results.size() == 1)
	assert(pulse_results[0].affected == [141])
	assert(pulse_ally.hp == 3 and pulse_ally.regen_turns == 1)
	assert(pulse_standard.hp == 2 and pulse_standard.regen_turns == 0)
	pulse_source.silenced_turns = 1
	assert(UnitSkillsScript.resolve_chants(
		0, [pulse_source, pulse_ally, pulse_standard], "start"
	).is_empty())

	# Warcry: Retaliation Screen makes the carrier take 0 damage from attacks for
	# {0} enemy turns; each blocked hit retaliates against the {2} highest-ATK
	# living enemies for {1}% of the attacker's ATK (min 1, rounded down).
	var summon_skill: Dictionary = UnitCatalogScript.by_name("Flux Weaver-188").skill.to_dict()
	assert(UnitSkillsScript.rank_value(summon_skill, 1, 0, 1) == 1)
	assert(UnitSkillsScript.rank_value(summon_skill, 1, 1, 50) == 50)
	assert(UnitSkillsScript.rank_value(summon_skill, 1, 2, 1) == 1)
	assert(UnitSkillsScript.rank_value(summon_skill, 5, 0, 1) == 3)
	assert(UnitSkillsScript.rank_value(summon_skill, 5, 1, 50) == 100)
	assert(UnitSkillsScript.rank_value(summon_skill, 5, 2, 1) == 3)
	var rydia := {
		"id": 500, "side": 0, "name": "Flux Weaver-188", "kind": "Channeler",
		"row": 0, "col": 1, "atk": 3, "hp": 7, "max_hp": 7, "effects": [], "level": 1,
		"skill": summon_skill
	}
	var summon_attacker := {
		"id": 501, "side": 1, "name": "Blade Foe", "kind": "Duelist",
		"row": 0, "col": 2, "atk": 4, "hp": 6, "max_hp": 6, "effects": []
	}
	var summon_big_foe := {
		"id": 502, "side": 1, "name": "Brute Foe", "kind": "Warden",
		"row": 1, "col": 4, "atk": 6, "hp": 9, "max_hp": 9, "effects": []
	}
	var summon_small_foe := {
		"id": 503, "side": 1, "name": "Scout Foe", "kind": "Strider",
		"row": 2, "col": 3, "atk": 2, "hp": 5, "max_hp": 5, "effects": []
	}
	var summon_units := [rydia, summon_attacker, summon_big_foe, summon_small_foe]
	var summon_warcry := UnitSkillsScript.resolve_warcry(rydia, summon_units)
	assert(summon_warcry.affected == [500])
	assert(rydia.summon_forth_turns == 1)
	assert("Retaliation Screen (1 turns)" in ConductorSkillsScript.effect_summary(rydia))
	# The level-1 row blocks the attack and deals 50% of 4 ATK = 2 damage to
	# the single highest-ATK enemy (the 6-ATK Brute, not the attacker).
	var summon_hit: Dictionary = BattleSimulatorScript.apply_unit_damage(
		rydia, summon_attacker.atk, summon_attacker
	)
	assert(summon_hit.damage == 0 and summon_hit.immunity == "summon_forth")
	assert(rydia.hp == 7)
	var summon_counter := UnitSkillsScript.resolve_summon_forth(
		rydia, summon_attacker, summon_units
	)
	assert(summon_counter.affected == [502])
	assert(summon_big_foe.hp == 7 and summon_attacker.hp == 6)
	# Skill damage is not attack damage: a source-less hit bypasses the
	# immunity entirely, even while the counter holds.
	var summon_skill_hit: Dictionary = BattleSimulatorScript.apply_unit_damage(rydia, 3)
	assert(summon_skill_hit.damage == 3 and summon_skill_hit.immunity == "")
	assert(rydia.hp == 4)
	rydia.hp = 7
	# The counter ticks on the opposing side's expiry pass, so the level-1
	# shield covers exactly one enemy turn before attacks land normally.
	UnitSkillsScript.expire_statuses(summon_units, 0)
	assert(rydia.summon_forth_turns == 1)
	UnitSkillsScript.expire_statuses(summon_units, 1)
	assert(rydia.summon_forth_turns == 0)
	var summon_expired_hit: Dictionary = BattleSimulatorScript.apply_unit_damage(
		rydia, summon_attacker.atk, summon_attacker
	)
	assert(summon_expired_hit.damage == 4 and summon_expired_hit.immunity == "")
	assert(rydia.hp == 3)
	rydia.hp = 7
	# The level-3 row: 2 enemy turns, 100% of ATK, the 2 highest-ATK enemies.
	rydia.level = 3
	UnitSkillsScript.resolve_warcry(rydia, summon_units)
	assert(rydia.summon_forth_turns == 2)
	assert(BattleSimulatorScript.apply_unit_damage(
		rydia, summon_attacker.atk, summon_attacker
	).damage == 0)
	var summon_counter_3 := UnitSkillsScript.resolve_summon_forth(
		rydia, summon_attacker, summon_units
	)
	assert(summon_counter_3.affected == [502, 501])
	assert(summon_big_foe.hp == 3 and summon_attacker.hp == 2)
	assert(summon_small_foe.hp == 5)
	# ATK ties at the cutoff tier are broken by seeded RNG picks; the same
	# seed always picks the same unit.
	var tie_a := {
		"id": 510, "side": 1, "name": "Tie Blade", "kind": "Duelist",
		"atk": 5, "hp": 5, "max_hp": 5, "effects": []
	}
	var tie_b := {
		"id": 511, "side": 1, "name": "Tie Zephyr Lancer-202", "kind": "Duelist",
		"atk": 5, "hp": 5, "max_hp": 5, "effects": []
	}
	rydia.level = 1
	var tie_rng := RandomNumberGenerator.new()
	tie_rng.seed = 11
	var tie_counter := UnitSkillsScript.resolve_summon_forth(
		rydia, tie_a, [rydia, tie_a, tie_b], tie_rng
	)
	assert(tie_counter.affected.size() == 1)
	var tie_first_id: int = tie_counter.affected[0]
	# 50% of 5 ATK rounds down to 2 damage on the picked unit.
	assert((tie_a.hp == 3) != (tie_b.hp == 3))
	var tie_rng_repeat := RandomNumberGenerator.new()
	tie_rng_repeat.seed = 11
	assert(UnitSkillsScript.resolve_summon_forth(
		rydia, tie_a, [rydia, tie_a, tie_b], tie_rng_repeat
	).affected == [tie_first_id])
	# A dead carrier never retaliates.
	rydia.hp = 0
	assert(UnitSkillsScript.resolve_summon_forth(
		rydia, tie_a, [rydia, tie_a, tie_b], tie_rng
	).affected.is_empty())

	# Chant: Silent Cycle fires at the start of the OPPOSING side's turn exactly
	# {0} times after deployment, Silencing the {1} highest-ATK living
	# enemies for {2} enemy turns; the carrier takes 0 attack damage from
	# Silenced attackers for as long as it lives.
	var quiet_skill: Dictionary = UnitCatalogScript.by_name("Flux Mender-195").skill.to_dict()
	assert(UnitSkillsScript.rank_value(quiet_skill, 1, 0, 1) == 1)
	assert(UnitSkillsScript.rank_value(quiet_skill, 1, 1, 1) == 1)
	assert(UnitSkillsScript.rank_value(quiet_skill, 1, 2, 1) == 1)
	assert(UnitSkillsScript.rank_value(quiet_skill, 5, 0, 1) == 3)
	assert(UnitSkillsScript.rank_value(quiet_skill, 5, 1, 1) == 3)
	assert(UnitSkillsScript.rank_value(quiet_skill, 5, 2, 1) == 3)
	var nageki := {
		"id": 520, "side": 0, "name": "Flux Mender-195", "kind": "Lifebinder",
		"row": 0, "col": 1, "atk": 2, "hp": 5, "max_hp": 5, "effects": [], "level": 3,
		"quiet_triggers_left": 2,
		"skill": quiet_skill
	}
	var quiet_foe_big := {
		"id": 521, "side": 1, "name": "Loud Brute", "kind": "Warden",
		"atk": 6, "hp": 9, "max_hp": 9, "effects": []
	}
	var quiet_foe_mid := {
		"id": 522, "side": 1, "name": "Loud Blade", "kind": "Duelist",
		"atk": 4, "hp": 6, "max_hp": 6, "effects": []
	}
	var quiet_foe_small := {
		"id": 523, "side": 1, "name": "Loud Scout", "kind": "Strider",
		"atk": 3, "hp": 4, "max_hp": 4, "effects": []
	}
	var quiet_units := [nageki, quiet_foe_big, quiet_foe_mid, quiet_foe_small]
	# Nothing fires at the start of the carrier's own side turn.
	assert(UnitSkillsScript.resolve_chants(0, quiet_units).is_empty())
	assert(nageki.quiet_triggers_left == 2)
	# Level-3 row: 2 triggers; each Silences the 2 highest-ATK enemies for
	# 2 turns (the 3-ATK Scout is left alone).
	var quiet_results := UnitSkillsScript.resolve_chants(1, quiet_units)
	assert(quiet_results.size() == 1)
	assert(quiet_results[0].affected == [521, 522])
	assert(quiet_foe_big.silenced_turns == 2 and quiet_foe_mid.silenced_turns == 2)
	assert(UnitSkillsScript.is_silenced(quiet_foe_big))
	assert(quiet_foe_small.get("silenced_turns", 0) == 0)
	assert(nageki.quiet_triggers_left == 1)
	# The second trigger refreshes (max, never stacks) and spends the last
	# charge; later opposing turns fire nothing.
	var quiet_results_2 := UnitSkillsScript.resolve_chants(1, quiet_units)
	assert(quiet_results_2.size() == 1 and nageki.quiet_triggers_left == 0)
	assert(quiet_foe_big.silenced_turns == 2)
	assert(UnitSkillsScript.resolve_chants(1, quiet_units).is_empty())
	# Passive: 0 attack damage from a Silenced attacker, normal damage from
	# a non-Silenced one, even with the trigger countdown spent.
	var quiet_blocked: Dictionary = BattleSimulatorScript.apply_unit_damage(
		nageki, quiet_foe_big.atk, quiet_foe_big
	)
	assert(quiet_blocked.damage == 0 and quiet_blocked.immunity == "quiet")
	assert(nageki.hp == 5)
	var quiet_open: Dictionary = BattleSimulatorScript.apply_unit_damage(
		nageki, quiet_foe_small.atk, quiet_foe_small
	)
	assert(quiet_open.damage == 3 and quiet_open.immunity == "")
	nageki.hp = 5
	# Skill damage from a Silenced enemy still lands: the passive gates
	# attack damage only.
	assert(BattleSimulatorScript.apply_unit_damage(nageki, 2).damage == 2)
	nageki.hp = 5
	# A Silenced carrier's trigger is a chant: it does not fire and the
	# charge is not spent, but the passive keeps working because it is not
	# a trigger.
	nageki.quiet_triggers_left = 1
	nageki.silenced_turns = 1
	quiet_foe_big.silenced_turns = 0
	quiet_foe_mid.silenced_turns = 0
	assert(UnitSkillsScript.resolve_chants(1, quiet_units).is_empty())
	assert(nageki.quiet_triggers_left == 1)
	quiet_foe_big.silenced_turns = 1
	assert(BattleSimulatorScript.apply_unit_damage(
		nageki, quiet_foe_big.atk, quiet_foe_big
	).damage == 0)
	nageki.silenced_turns = 0
	quiet_foe_big.silenced_turns = 0
	# Level-5 row: 3 triggers, the 3 highest-ATK enemies, 3 turns.
	nageki.level = 5
	nageki.quiet_triggers_left = 3
	var quiet_max := UnitSkillsScript.resolve_chants(1, quiet_units)
	assert(quiet_max.size() == 1 and quiet_max[0].affected == [521, 522, 523])
	assert(quiet_foe_small.silenced_turns == 3)
	assert(nageki.quiet_triggers_left == 2)
	# A dead carrier never triggers.
	nageki.hp = 0
	assert(UnitSkillsScript.resolve_chants(1, quiet_units).is_empty())

	var preview_unit := {"id": 6, "side": 0, "kind": "Strider", "row": 1, "col": 1, "move": 3, "range": 1}
	assert(BattleRulesScript.attack_cells(preview_unit) == [Vector2i(2, 1)])
	assert(BattleRulesScript.traversal_cells(preview_unit, [preview_unit]) == [
		Vector2i(2, 1), Vector2i(3, 1), Vector2i(4, 1)
	])
	preview_unit.immobilized_turns = 1
	assert(BattleRulesScript.traversal_cells(preview_unit, [preview_unit]).is_empty())
	preview_unit.immobilized_turns = 0
	var path_blocker := {"id": 7, "side": 0, "kind": "Warden", "row": 1, "col": 3}
	assert(BattleRulesScript.traversal_cells(preview_unit, [preview_unit, path_blocker]) == [Vector2i(2, 1)])
	var attack_target := {"id": 8, "side": 1, "kind": "Duelist", "row": 1, "col": 2}
	assert(BattleRulesScript.traversal_cells(preview_unit, [preview_unit, attack_target]).is_empty())
	var player_at_enemy_gate := {
		"id": 81, "side": 0, "kind": "Strider", "row": 2, "col": 4,
		"move": 3, "range": 1, "ready": true
	}
	assert(BattleRulesScript.traversal_cells(player_at_enemy_gate, [player_at_enemy_gate]) == [Vector2i(5, 2)])
	assert(BattleRulesScript.attack_cells_from(player_at_enemy_gate, 5) == [Vector2i(6, 2)])
	assert(BattleRulesScript.commander_in_range({
		"side": 0, "col": 5, "range": 1
	}))
	var enemy_at_player_gate := {
		"id": 82, "side": 1, "kind": "Strider", "row": 2, "col": 2,
		"move": 3, "range": 1, "ready": true
	}
	assert(BattleRulesScript.traversal_cells(enemy_at_player_gate, [enemy_at_player_gate]) == [Vector2i(1, 2)])
	assert(BattleRulesScript.attack_cells_from(enemy_at_player_gate, 1) == [Vector2i(0, 2)])
	assert(BattleRulesScript.commander_in_range({
		"side": 1, "col": 1, "range": 1
	}))
	var center_target := {"row": 1, "col": 3}
	assert(BattleRulesScript.blast_cells(center_target) == [
		Vector2i(2, 1), Vector2i(4, 1), Vector2i(3, 0), Vector2i(3, 2)
	])
	assert(BattleRulesScript.blast_cells({"row": 0, "col": 0}) == [
		Vector2i(1, 0), Vector2i(0, 1)
	])

	var front_ally := {
		"id": 9, "side": 0, "kind": "Duelist", "row": 1, "col": 3,
		"move": 2, "range": 1, "ready": true
	}
	var following_ally := {
		"id": 10, "side": 0, "kind": "Strider", "row": 1, "col": 1,
		"move": 3, "range": 1, "ready": true
	}
	var following_preview: Dictionary = BattleRulesScript.projected_action(10, [front_ally, following_ally])
	assert(following_preview.traversal == [Vector2i(2, 1), Vector2i(3, 1), Vector2i(4, 1)])
	assert(following_preview.projected_col == 4)
	assert(following_preview.attack == [Vector2i(5, 1)])

	var ranged_mover := {
		"id": 11, "side": 0, "kind": "Artillerist", "row": 0, "col": 1,
		"move": 1, "range": 3, "ready": true
	}
	var ranged_target := {"id": 12, "side": 1, "kind": "Warden", "row": 0, "col": 4}
	var ranged_preview: Dictionary = BattleRulesScript.projected_action(11, [ranged_mover, ranged_target])
	assert(ranged_preview.traversal == [Vector2i(2, 0)])
	assert(ranged_preview.attack == [Vector2i(3, 0), Vector2i(4, 0), Vector2i(5, 0)])

	var units := [
		{"side": 0, "row": 1, "col": 5, "atk": 3, "hp": 4, "max_hp": 4}
	]
	var ai_hand: Array = roster.map(func(unit): return unit.to_dict())
	var choice: Dictionary = BattleAIScript.choose_deployment(ai_hand, 2, units)
	assert(not choice.is_empty(), "AI should find an affordable deployment.")
	assert(choice.card.cost <= 2)
	assert(choice.row == 1, "AI should answer the most dangerous lane.")
	var finite_hand: Array = roster.slice(0, 4).map(func(unit): return unit.to_dict())
	var hand_choice: Dictionary = BattleAIScript.choose_deployment(finite_hand, 2, units)
	assert(not hand_choice.is_empty())
	var chosen_index: int = finite_hand.find(hand_choice.card)
	assert(chosen_index >= 0)
	finite_hand.remove_at(chosen_index)
	assert(finite_hand.size() == 3)
	var plain_support_card := {
		"name": "Plain Support", "cost": 3, "atk": 2, "hp": 5,
		"kind": "Lifebinder", "chassis_family": "resonant", "skill": {}
	}
	var pulse_support_card: Dictionary = plain_support_card.duplicate(true)
	pulse_support_card.name = "Pulse Support"
	pulse_support_card.skill = {"name": "Resonance Pulse", "type": "Chant"}
	var synergy_board := [
		{"id": 30, "side": 1, "row": 0, "col": 5, "atk": 3, "hp": 2,
			"max_hp": 5, "chassis_family": "resonant"},
		{"id": 31, "side": 0, "row": 0, "col": 2, "atk": 3, "hp": 5,
			"max_hp": 5, "chassis_family": "standard"}
	]
	assert(BattleAIScript._score(
		pulse_support_card, 0, 3, synergy_board, 1
	) > BattleAIScript._score(plain_support_card, 0, 3, synergy_board, 1))

	var blocked_units := [
		{"side": 1, "row": 0, "col": 6, "atk": 1, "hp": 1, "max_hp": 1},
		{"side": 1, "row": 1, "col": 6, "atk": 1, "hp": 1, "max_hp": 1},
		{"side": 1, "row": 2, "col": 6, "atk": 1, "hp": 1, "max_hp": 1}
	]
	assert(BattleAIScript.choose_deployment(ai_hand, 10, blocked_units).is_empty())

	# Autobattle reuses the same chooser for the player's side: the deploy
	# column flips to column 0 and the opposing side drives the threat score.
	var autobattle_units := [
		{"side": 1, "row": 2, "col": 1, "atk": 3, "hp": 4, "max_hp": 4}
	]
	var autobattle_choice: Dictionary = BattleAIScript.choose_deployment(
		ai_hand, 2, autobattle_units, [], 0
	)
	assert(not autobattle_choice.is_empty())
	assert(autobattle_choice.row == 2, "Autobattle AI should answer the enemy's lane.")
	var player_blocked_units := [
		{"side": 0, "row": 0, "col": 0, "atk": 1, "hp": 1, "max_hp": 1},
		{"side": 0, "row": 1, "col": 0, "atk": 1, "hp": 1, "max_hp": 1},
		{"side": 0, "row": 2, "col": 0, "atk": 1, "hp": 1, "max_hp": 1}
	]
	assert(BattleAIScript.choose_deployment(ai_hand, 10, player_blocked_units, [], 0).is_empty())
	# should_use_conductor_skill flips allies/enemies for the player side.
	var player_skill_units := [
		{"side": 0, "row": 0, "col": 0, "atk": 2, "hp": 3, "max_hp": 3},
		{"side": 0, "row": 1, "col": 0, "atk": 2, "hp": 3, "max_hp": 3}
	]
	assert(BattleAIScript.should_use_conductor_skill("Rally", 1, 20, player_skill_units, 0))
	assert(not BattleAIScript.should_use_conductor_skill("Firestorm", 1, 20, player_skill_units, 0))

	# Level growth: +10% ATK / max HP per level above 1, never below base.
	assert(KineticCrucibleScript.scaled_stat(10, 1) == 10)
	assert(KineticCrucibleScript.scaled_stat(10, 5) == 14)
	assert(KineticCrucibleScript.scaled_stat(2, 5) == 3)
	assert(KineticCrucibleScript.scaled_stat(1, 5) == 1)
	assert(KineticCrucibleScript.scaled_stat(0, 5) == 0)
	assert(KineticCrucibleScript.scaled_stat(3, 3) == 4)

	# Secondary skills scale with unit level via authored rank tables.
	var mend_skill: Dictionary = UnitCatalogScript.by_name("Helio Mender-049").skill.to_dict()
	assert(mend_skill.has("rank_values"))
	assert(UnitSkillsScript.rank_value(mend_skill, 1, 0, 3) == 3)
	assert(UnitSkillsScript.rank_value(mend_skill, 5, 0, 3) == 7)
	assert(UnitSkillsScript.rank_value(mend_skill, 99, 0, 3) == 7)
	assert(UnitSkillsScript.rank_value({"name": "Repair Pulse"}, 5, 0, 3) == 3)
	var nurse_skill: SkillData = UnitCatalogScript.by_name("Helio Mender-049").skill
	assert(nurse_skill.format_text(1) == "On deployment, restore 3 HP to the allied unit with the lowest HP.")
	assert(nurse_skill.format_text(5) == "On deployment, restore 7 HP to the allied unit with the lowest HP.")
	var veteran_nurse := {
		"id": 95, "side": 0, "name": "Helio Mender-049", "kind": "Lifebinder",
		"atk": 2, "hp": 3, "max_hp": 3, "effects": [], "level": 5,
		"skill": mend_skill
	}
	var veteran_patient := {
		"id": 96, "side": 0, "name": "Hurt Ally", "kind": "Duelist",
		"atk": 2, "hp": 1, "max_hp": 10, "effects": []
	}
	assert(not UnitSkillsScript.resolve_warcry(
		veteran_nurse, [veteran_nurse, veteran_patient]
	).message.is_empty())
	assert(veteran_patient.hp == 8)
	var apostle_skill: Dictionary = UnitCatalogScript.by_name("Flux Lancer-025").skill.to_dict()
	var veteran_apostle := {
		"id": 97, "side": 0, "name": "Flux Lancer-025", "atk": 2,
		"hp": 4, "max_hp": 4, "effects": [], "level": 5, "skill": apostle_skill
	}
	var wrath_enemy := {
		"id": 98, "side": 1, "name": "Wrath Target", "kind": "Strider",
		"atk": 2, "hp": 9, "max_hp": 9, "effects": []
	}
	var wrath_rng := RandomNumberGenerator.new()
	wrath_rng.seed = 7
	var wrath_result := UnitSkillsScript.resolve_warcry(
		veteran_apostle, [veteran_apostle, wrath_enemy], -1, wrath_rng
	)
	assert(wrath_enemy.hp == 4)
	assert("split between random enemy units" in wrath_result.message)
	var veteran_skirmisher := {
		"id": 99, "side": 0, "name": "Cinder Lancer-017", "level": 5,
		"skill": UnitCatalogScript.by_name("Cinder Lancer-017").skill.to_dict()
	}
	var strike_target := {
		"id": 100, "side": 1, "name": "Strike Target",
		"hp": 5, "max_hp": 5, "effects": []
	}
	assert(UnitSkillsScript.resolve_strike(
		veteran_skirmisher, strike_target, [], 0.41
	).message.is_empty())
	assert(not UnitSkillsScript.resolve_strike(
		veteran_skirmisher, strike_target, [], 0.39
	).message.is_empty())
	assert(strike_target.immobilized_turns == 2)

	# The five completed stable-ID slots exercise every secondary-skill timing.
	var failover_actor := {
		"id": 200, "side": 0, "name": "Relay Bastion-030", "level": 5,
		"hp": 8, "max_hp": 8, "skill": UnitCatalogScript.by_name("Relay Bastion-030").skill.to_dict()
	}
	var failover_low := {
		"id": 201, "side": 0, "name": "Low Ally", "hp": 2, "max_hp": 6,
		"protect_turns": 0
	}
	var failover_high := {
		"id": 202, "side": 0, "name": "High Ally", "hp": 4, "max_hp": 6,
		"protect_turns": 0
	}
	var failover_result := UnitSkillsScript.resolve_warcry(
		failover_actor, [failover_actor, failover_low, failover_high]
	)
	assert(failover_low.hp == 6 and failover_high.hp == 6)
	assert(failover_low.protect_turns == 3)
	assert(failover_result.affected == [201, 202])

	var furnace_actor := {
		"id": 203, "side": 0, "name": "Cinder Blade-036", "level": 5,
		"atk": 3, "hp": 6, "effects": [], "haste_turns": 0,
		"skill": UnitCatalogScript.by_name("Cinder Blade-036").skill.to_dict()
	}
	var furnace_target := {"id": 204, "side": 1, "name": "Target", "hp": 5}
	assert(not UnitSkillsScript.resolve_strike(
		furnace_actor, furnace_target, [furnace_actor, furnace_target]
	).message.is_empty())
	assert(furnace_actor.atk == 6 and furnace_actor.haste_turns == 3)
	assert(furnace_actor.effects[0].name == "Furnace Wake")

	# Furnace Wake resolves after attacking, so its first turn must survive the
	# same-side expiry pass and empower the actor's following activation.
	var furnace_recruit := {
		"id": 209, "side": 0, "name": "Cinder Blade-036", "level": 1,
		"atk": 3, "hp": 6, "effects": [], "haste_turns": 0,
		"skill": UnitCatalogScript.by_name("Cinder Blade-036").skill.to_dict()
	}
	UnitSkillsScript.resolve_strike(furnace_recruit, furnace_target, [
		furnace_recruit, furnace_target
	])
	ConductorSkillsScript.expire_effects([furnace_recruit], 0)
	UnitSkillsScript.expire_statuses([furnace_recruit], 0)
	assert(furnace_recruit.atk == 4 and furnace_recruit.haste_turns == 1)
	ConductorSkillsScript.expire_effects([furnace_recruit], 0)
	UnitSkillsScript.expire_statuses([furnace_recruit], 0)
	assert(furnace_recruit.atk == 3 and furnace_recruit.haste_turns == 0)

	var slipstream_actor := {
		"id": 205, "side": 0, "name": "Zephyr Lancer-042", "level": 5,
		"row": 0, "col": 3, "hp": 5, "haste_turns": 0,
		"skill": UnitCatalogScript.by_name("Zephyr Lancer-042").skill.to_dict()
	}
	var slipstream_attacker := {
		"id": 206, "side": 1, "name": "Attacker", "row": 0, "col": 4,
		"hp": 5
	}
	var slipstream_result := UnitSkillsScript.resolve_reaction(
		slipstream_actor, slipstream_attacker,
		[slipstream_actor, slipstream_attacker]
	)
	assert(slipstream_attacker.col == 6 and slipstream_actor.haste_turns == 3)
	assert(slipstream_result.moved[0].id == slipstream_attacker.id)

	var phase_actor := {
		"id": 207, "side": 0, "name": "Flux Weaver-047", "level": 5,
		"hp": 5, "skill": UnitCatalogScript.by_name("Flux Weaver-047").skill.to_dict()
	}
	var phase_target := {
		"id": 208, "side": 1, "name": "Disrupted Target", "atk": 6,
		"hp": 6, "max_hp": 6, "immobilized_turns": 1, "silenced_turns": 0
	}
	var phase_results := UnitSkillsScript.resolve_chants(
		0, [phase_actor, phase_target], "start"
	)
	assert(phase_results.size() == 1)
	assert(phase_target.hp == 2 and phase_target.stun_turns == 3)

	var dawn_actor := {
		"id": 209, "side": 0, "name": "Helio Mender-048", "level": 5,
		"atk": 2, "hp": 5, "max_hp": 5,
		"skill": UnitCatalogScript.by_name("Helio Mender-048").skill.to_dict()
	}
	var dawn_ally := {
		"id": 210, "side": 0, "name": "Regenerating Ally", "atk": 2,
		"hp": 5, "max_hp": 5, "regen_turns": 1, "aura_hp": 0, "aura_atk": 0
	}
	UnitSkillsScript.refresh_auras([dawn_actor, dawn_ally])
	assert(dawn_ally.hp == 9 and dawn_ally.max_hp == 9 and dawn_ally.atk == 5)
	dawn_ally.regen_turns = 0
	UnitSkillsScript.refresh_auras([dawn_actor, dawn_ally])
	assert(dawn_ally.hp == 5 and dawn_ally.max_hp == 5 and dawn_ally.atk == 2)

	# Promotion conversion: a level-5 copy becomes its promoted form at level 1.
	assert(KineticCrucibleScript.promotion_target("Relay Bastion-013", roster).name == "Relay Bastion-014")
	assert(KineticCrucibleScript.promotion_target("Relay Bastion-014", roster) == null)
	# Three-tier promotion chains resolve one step at a time, and the reserve
	# sort's root resolver walks the full chain back to the base form.
	assert(KineticCrucibleScript.promotion_target("Flux Weaver-210", roster).name == "Flux Weaver-211")
	assert(KineticCrucibleScript.promotion_target("Flux Weaver-211", roster).name == "Flux Weaver-212")
	assert(KineticCrucibleScript.promotion_target("Flux Weaver-212", roster) == null)
	assert(KineticCrucibleScript.promotion_target("Cinder Mender-213", roster).name == "Cinder Mender-214")
	assert(KineticCrucibleScript.promotion_target("Cinder Mender-214", roster).name == "Cinder Mender-215")
	assert(KineticCrucibleScript.promotion_target("Cinder Mender-215", roster) == null)
	assert(KineticCrucibleScript.promotion_target(
		"Relay Battery-217", roster
	).name == "Relay Battery-218")
	assert(KineticCrucibleScript.promotion_target(
		"Cinder Bastion-219", roster
	).name == "Cinder Bastion-220")
	assert(KineticCrucibleScript.promotion_target(
		"Zephyr Lancer-221", roster
	).name == "Zephyr Lancer-222")
	assert(KineticCrucibleScript.promotion_target(
		"Helio Mender-223", roster
	).name == "Helio Mender-224")
	var chain_by_name := {}
	for unit in roster:
		chain_by_name[unit.name] = unit
	assert(KineticCrucibleScript._promotion_root(
		"Flux Weaver-212", chain_by_name, {}
	) == "Flux Weaver-210")
	assert(KineticCrucibleScript._promotion_root(
		"Cinder Mender-215", chain_by_name, {}
	) == "Cinder Mender-213")
	var promo_config := ConfigFile.new()
	promo_config.set_value("meta", "instances_migrated", true)
	promo_config.set_value("collection", "next_id", 11)
	promo_config.set_value("collection", "instances", [
		{"id": "unit_000001", "name": "Relay Bastion-013", "level": 5, "points": 0, "consumed": false},
		{"id": "unit_000010", "name": "Relay Lancer-003", "level": 5, "points": 0, "consumed": false}
	])
	promo_config.save(KineticCrucibleScript.SAVE_PATH)
	var promo_counts := {"Relay Bastion-013": 1, "Relay Lancer-003": 1}
	var promoted: Dictionary = KineticCrucibleScript.record_promotion(
		"unit_000001", roster, promo_counts
	)
	assert(promoted.ok and promoted.to == "Relay Bastion-014")
	var after_promotion: Array = KineticCrucibleScript.sync_instances(roster, promo_counts)
	var promoted_copy := KineticCrucibleScript.instance_by_id(
		after_promotion, "unit_000001"
	)
	assert(promoted_copy.name == "Relay Bastion-014")
	assert(promoted_copy.level == 1 and promoted_copy.points == 0)
	assert(after_promotion.filter(
		func(instance): return instance.name == "Relay Bastion-013"
	).size() == 1)
	assert(not KineticCrucibleScript.record_promotion("unit_000010", roster, promo_counts).ok)
	assert(not KineticCrucibleScript.record_promotion("unit_000001", roster, promo_counts).ok)
	DirAccess.remove_absolute(ProjectSettings.globalize_path(KineticCrucibleScript.SAVE_PATH))

	print("War of Resonance smoke tests passed.")
	quit()
