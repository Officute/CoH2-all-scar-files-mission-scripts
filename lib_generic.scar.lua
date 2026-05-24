--loadfile("scar/generic/lib_generic.scar")()




g_temp_egroup_id = 0
g_temp_sgroup_id = 0

colorUnPacker = {
	__call = function(t)
		return unpack(t)
	end
}

Color = {
	red = {255, 0, 0, 255},
	green = {0, 255, 0, 255},
	blue = {0, 0, 255, 255},
	yellow = {255, 255, 0, 255},
	orange = {255, 128, 0, 255},
}

function Library_Init()
	g_all_players = {[0] = {}, [1] = {}} 
	g_pos_center_absolute = World_Pos(0, 0, 0)
	g_pos_center_relative = World_Pos(0, Misc_GetTerrainHeight(g_pos_center_absolute), 0)
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		local team = Player_GetTeam(player)
		table.insert(g_all_players[team], player)
	end
end

Scar_AddInit(Library_Init)

for key, _t in pairs(Color) do
	setmetatable(_t, colorUnPacker)
end

function Ability_GetUniqueKey(ability)
	return "ability_" .. BP_GetName(ability)
end

function dr_text3dpos(frame, pos, text, r, g, b)
	return dr_text3d(frame, pos.x, pos.y, pos.z, text, 255, 255, 255)
end

function EGroup_CreateTemp(egroupName)
	g_temp_egroup_id = g_temp_egroup_id + 1
	return EGroup_Create(egroupName .. g_temp_egroup_id)
end


function EGroup_GetClosest(pos, egroup)
	local entities = {}
	EGroup_ForEach(egroup, function(egid, idx, entity)
		table.insert(entities, entity)
	end)
	return World_GetClosest(pos, entities)
end

function EGroup_AddGroup(egroup, grouptoadd)
	EGroup_ForEach(grouptoadd, function(egid, idx, entity)
		EGroup_Add(egroup, entity)
	end)
	return egroup
end

function EGroup_FilterByUnitType(egroup, filters, filter_mode)
	local matches = {}
	if scartype(filters) ~= ST_TABLE then
		filters = {filters}
	end
	
	local filters_count = table.getn(filters)
	EGroup_ForEach(egroup, function(egid, idx, entity)
		local match_count = 0
		for key, filter in ipairs(filters) do
			if Entity_IsOfType(entity, filter) then
				match_count = match_count + 1
			end
		end
		if (filter_mode == FILTER_KEEP and match_count ~= filters_count) 
		or (filter_mode == FILTER_REMOVE and match_count == filters_count) then
			EGroup_Remove(egroup, entity)
		end
	end)
	return egroup
end

function Entity_GetUniqueKey(entity)
	return "entity_" .. Entity_GetGameID(entity)
end

function Entity_GetGarrisonedSquads(entity)
	local sgroup = SGroup_CreateIfNotFound("sg_villagers_squads_held")
	SGroup_Clear(sgroup)
	Entity_GetSquadsHeld(entity, sgroup)
	return sgroup
end

function Entity_AutoAlign(entity)
	Entity_SetHeading(entity, Entity_GetHeading(entity), false)
end

function Entity_CheckForParentSquad(target)
	if scartype(target) == ST_ENTITY then
		if Entity_GetSquad(target) then
			return Entity_GetSquad(target)
		else
			return target
		end
	else
		return target
	end
end

function Entity_CreateAndSpawnToward(ebp, player, pos, toward, force_construct, auto_align)
	force_construct = Util_DefaultValue(force_construct, true)
	auto_align = Util_DefaultValue(auto_align, false)
	local neutral = false
	if not player then
		neutral = true
		player = World_GetPlayerAt(1)
	end
	local entity entity = Entity_Create(ebp, player, pos, toward)
	
	if neutral then
		Entity_SetWorldOwned(entity)
	end
	Entity_Spawn(entity)
	if force_construct then
		Entity_ForceConstruct(entity)
	end
	if auto_align then
		Entity_AutoAlign(entity)
	end
	return entity
end

function Entity_CreateAndSpawnTowardDelayed(ebp, player, pos, toward, delay, force_construct, auto_align)
	force_construct = Util_DefaultValue(force_construct, true)
	auto_align = Util_DefaultValue(auto_align, false)
	local neutral = false
	if not player then
		neutral = true
		player = World_GetPlayerAt(1)
	end
	local entity entity = Entity_Create(ebp, player, pos, toward)
	
	if neutral then
		Entity_SetWorldOwned(entity)
	end
	Util_Delay(delay, function()
		Entity_Spawn(entity)
	end)
	if force_construct then
		Entity_ForceConstruct(entity)
	end
	if auto_align then
		Entity_AutoAlign(entity)
	end
	return entity
end

function Entity_CreateAndSpawnTowardDelayedRandom(ebp, player, pos, toward, force_construct, auto_align)
	return Entity_CreateAndSpawnTowardDelayed(ebp, player, pos, toward, World_GetRand(1, 12), force_construct, auto_align)
end
function Entity_GetName(entity)
	local bp = Entity_GetBlueprint(entity)
	return Util_GetBPName(bp)
end

function Entity_GetTempEGroup(entity, index)
	if not index then 
		index = 1 
	end
	local egroup = EGroup_CreateTemp("eg_temp_blah")
	EGroup_Add(egroup, entity)
	return egroup
end

function Entity_GetOwnerSafe(entity)
	if World_OwnsEntity(entity) then
		return nil
	else
		return Entity_GetPlayerOwner(entity)
	end
end

function Entity_Replace(entity, ebp)
	local pos = Entity_GetPosition(entity)
	local heading = Entity_GetHeading(entity)
	local health = Entity_GetHealthPercentage(entity)
	local owner = Entity_GetOwnerSafe(entity)
	
	local newEntity = Entity_CreateAndSpawnToward(ebp, owner, pos, pos)
	Entity_SetHeading(newEntity, heading, false)
	Entity_SetHealth(newEntity, health)
	Entity_Destroy(entity)
	return newEntity
end

function Entity_IsSelected(entity)
	return Misc_IsEntitySelected(entity)
end

function Entity_HasProductionQueueItem(entity, queueItem)
	if Entity_GetProductionQueueSize(entity) > 0 then
		local count = 0
		for i = 0, Entity_GetProductionQueueSize(entity) - 1 do
			if Entity_GetProductionQueueItem(entity, i) == queueItem then
				return true
			end
		end
	end
end

function Entity_IsValidEntity(entity)
	if Util_Tester(Entity_GetGameID, {entity}) then
		return true
	end
	return false
end

function Entity_Validate(entity)
	local entityId = Entity_GetGameID(entity)
	if Entity_IsValid(entityId) and Entity_IsSpawned(entity) and Entity_IsAlive(entity) then
		return true
	end
	return false
end

function Entity_HasModifierExt(entity)
	local list = {"Bailey_Bridge_25_01","bailey_bridge_25_01_wrecked","Best_Bridge_L_01","best_bridge_l_01_wrecked","Bridge_15_01","bridge_15_01_rebuilt","bridge_15_01_wrecked","Bridge_25_01","bridge_25_01_rebuilt","bridge_25_01_wrecked","bridge_25_stone_01","bridge_25_stone_01_rebuilt","bridge_25_stone_01_wrecked","Bridge_35_01","bridge_35_01_invuln","bridge_35_01_rebuilt","bridge_35_01_wrecked","bridge_35_stavelot","bridge_35_stavelot_rebuilt","bridge_35_stavelot_wrecked","bridge_35_stone_01","bridge_35_stone_01_rebuilt","bridge_35_stone_01_wrecked","Bridge_M6_Pont_Tourant","bridge_m6_pont_tourant_rebuilt","bridge_m6_pont_tourant_wrecked","bridge_molkte_base_wide","bridge_short_span_stone","bridge_short_span_stone_rebuilt","bridge_short_span_stone_wreck","bridge_short_span_wooden_w_iron_banding","bridge_short_span_wooden_w_iron_banding_fake_wreck","bridge_short_span_wooden_w_iron_banding_rebuilt","bridge_short_span_wooden_w_iron_banding_wrecked","Foot_Bridge_25_01","foot_bridge_25_01_rebuilt","foot_bridge_25_01_wrecked","oosterbeek_railway_bridge_00_wrecked","Rebuilt_bridge_section","russian_bridge_test","sep_bridge_01","soviet_foot_bridge","soviet_foot_bridge_wrecked","multisub_3x3x2_01","multisub_3x3x2_02","multisub_3x3x2_03","multisub_3x3x3_01","multisub_3x3x3_02","multisub_3x3x3_03","plaster01_2x2x2_01","plaster01_2x2x2_02","plaster01_2x2x3_01","plaster01_3x3x3_01","plaster01_3x3x3_02","plaster01_3x3x3_03","plaster01_3x3x3_04","plaster01_med_2x2x2_01","plaster02_2x2x2_01","stone01_4x3x2_01","stone01_4x3x2_02","stone02_2x2x2_01","stone02_barn_3x3x2_01","stone02_church_3x4x3_01","stone02_church_3x4x3_02","stone02_church_3x4x3_03","stone02_church_4x5x3_01","stone02_church_4x5x3_02","stone02_church_4x5x3_03","stone02_church_6x8x7_01","wood01_house_2x3x2_01","wood01_shed_1x1x1_01","wood01_shed_1x2x1_01","wood01_shed_1x2x1_02","wood01_shed_2x2x2_01","wood01_shed_2x3x2_01","ardenes_brick01_3x2x3_01","ardenes_brick01_3x2x3_02","ardenes_brick01_3x2x3_03","ardenes_brick01_3x2x3_04","ardenes_brick01_3x2x3_05","ardenes_brick01_4x1x2_01","ardenes_brick01_4x1x2_02","ardenes_brick01_5x1x2_01","ardenes_brick01_5x1x2_02","ardenes_brick_01_2x2x2_4sided_01","ardenes_industrial_01","ardenes_multisub_2level_door_01","ardenes_multisub_2level_door_02","ardenes_multisub_2level_door_03","ardenes_multisub_2level_door_04","ardenes_MultiSub_3x2_01","ardenes_multisub_3x3_03","ardenes_multisub_3x3_04","ardenes_multisub_3x3_04_end","ardenes_MultiSub_3x3_Combo_01","ardenes_MultiSub_3x3_Combo_02","ardenes_multisub_3x3_combo_03","ardenes_MultiSub_4x2_Combo_02","ardenes_MultiSub_Wdg90_x2_01","ardenes_MultiSub_Wdg90_x3_01","ardenes_MultiSub_Wdg90_x4_01","ardenes_Plaster01_2x1_M06_01","ardenes_Plaster01_2x2_01","ardenes_Plaster01_2x2_02","ardenes_plaster01_2x2_03","ardenes_Plaster01_2x2_3sided_06","ardenes_Plaster01_2x2_Corner_01","ardenes_Plaster01_2x2_Wdg_01","ardenes_Plaster01_2x3_01","ardenes_plaster01_2x3_02","ardenes_Plaster01_2X3_combo_01","ardenes_Plaster01_2x3_Corner_01","ardenes_plaster01_2x3_end","ardenes_Plaster01_2X3_Wdg_01","ardenes_plaster01_2x4x2_01","ardenes_Plaster01_3x1_M06_01","ardenes_Plaster01_3x2_01","ardenes_Plaster01_3x2_NIS_02","ardenes_Plaster01_3x2_Shops_01","ardenes_Plaster01_3x2_Wdg60_01","ardenes_Plaster01_3x2_Wdg_01","ardenes_Plaster01_3x3_01","ardenes_plaster01_3x3_01_german_hq","ardenes_Plaster01_3x3_combo_01","ardenes_plaster01_3x4x2_01","ardenes_plaster01_8x6x4_01","ardenes_plaster01_corner_01","ardenes_plaster01_t_junction_01","ardenes_Plaster02_1x3_Wdg_01","ardenes_plaster02_1x3_wdg_02","ardenes_Plaster02_2x2_01","ardenes_Plaster02_2x2_3Sided_01","ardenes_plaster02_2x2_3sided_02","ardenes_plaster02_2x4x2_01","ardenes_Plaster02_3x3_01","ardenes_Plaster02_4x2_Civic","ardenes_Plaster02_5x2_01","ardenes_Plaster02_5x2_M06_01","ardenes_Plaster03_1x1_Shed_01","ardenes_Plaster03_2x1_02","ardenes_Plaster03_2x2_01","ardenes_Plaster03_3x1_Garage_01","ardenes_Plaster03_3x1_Hangar_01","ardenes_Plaster03_3x1_Rural_01","ardenes_Plaster03_3x2_01","ardenes_Plaster03_3x2_02","ardenes_Plaster03_3x2_Barn_01","ardenes_Plaster03_3x3_01","ardenes_Plaster03_4x3_Indu_01","ardenes_Plaster04_1x2_Tower_01","ardenes_Plaster04_2x1_Garage_01","ardenes_Plaster04_2x1_TrainShed_01","ardenes_Plaster04_2x2_01","ardenes_Plaster04_2x2_02","ardenes_Plaster04_2x2_3Sided_01","ardenes_Plaster04_2x3_Fire_01","ardenes_Plaster04_3x3_Vari_01","ardenes_Plaster04_6x3_Train_01","ardenes_plaster04_8x4_train_02","ardenes_plaster05_2x4x2_01","ardenes_plaster05_3x4x2_01","ardenes_plaster05_3x4x3_01","ardenes_plaster05_3x4x3_01_end","ardenes_plaster05_3x4x3_02","ardenes_plaster05_3x4x3_03","ardenes_plaster05_mutisub_4x4x3_01","ardenes_plaster05_mutisub_4x4x3_02","ardenes_stone02_1x2x3_01","ardenes_stone02_2x3x3_01","ardenes_stone02_2x4x2_01","ardenes_stone02_end_1x2x3_01","ardenes_stone_02_3x4x2_01","multisub_2level_door_01","log_thatched_1x2x1_shed_01","log_thatched_2x2x1_cottage_01","log_thatched_2x3x1_cottage_01","log_thatched_2x3x1_cottage_02","log_wooden_1x2x1_cottage_01","log_wooden_1x2x1_cottage_01_m02","log_wooden_1x2x1_shed_01","log_wooden_2x2x1_cottage_01","log_wooden_2x2x1_cottage_01_m02","log_wooden_2x3x1_cottage_01","log_wooden_2x3x2_church_01","plank_wooden_1x2x1_shed_01","plank_wooden_2x3x1_cottage_01","plank_wooden_2x3x1_cottage_02","plank_wooden_2x3x1_cottage_03","plank_wooden_2x3x1_cottage_03_m02","plank_wooden_2x4x1_church_01","plaster_wooden_2x3x1_cottage_01","plaster_wooden_5x6x2_church_01","plaster_wooden_5x6x2_church_02","demo_log_wooden_2x2x1_cottage_01","demo_log_wooden_2x3x1_cottage_01","demo_log_wooden_2x3x1_cottage_01_handsoff","demo_plank_wooden_2x4x1_church_01","Brick01_1x1_01","Brick01_2x1_01","Brick01_2x2_NotchRoof_01","Brick01_2x2_Slant_01","Brick01_2x4_NotchRoof_01","Brick01_3x1_01","Brick01_3x1_02","Brick01_3x1_Hangar_01","brick01_3x1_hangar_01_tankwars","brick01_3x1_hangar_01_tankwars_left","brick01_3x1_hangar_01_tankwars_right","Brick01_3x2_Loadock_01","Brick01_3x2_Train_01","Brick01_3x2_TripleRoof_01","brick01_3x3x3_residential","brick01_3x3x3_residential_02","brick01_3x3x4_residential","brick01_3x3x4_residential_02","Brick01_4x4_Stepped_01","Brick01_4x5_01","brick01_5x3x3_residential","brick01_5x3x3_residential_03","brick01_5x3x3_residential_04","brick01_5x3x3_residential_02","brick01_5x3x4_residential","brick01_5x3x4_residential_02","Brick01_5x4_RoundRoof_01","Brick01_6x3_01","BrickTile01_2x1_01","BrickTile01_2x2_01","BrickTile01_2x2_Tower_01","BrickTile01_2x3_01","BrickTile01_2x3_RoundRoof_01","BrickTile01_3x1_01","BrickTile01_3x3_01","BrickTile01_3x3_02","BrickTile01_3x3_Mine_01","BrickTile01_4x1_RoundRoof_01","BrickTile01_4x3_Train_01","Brick_01_2x3_Control_Tower","Concrete_1x2_Tower_01","concrete_1x2_tower_01_sp_m07","Concrete_1x2_Tower_02","concrete_1x2_tower_02_sp_m07","Concrete_2x1_Tower_01","concrete_2x1_tower_01_push_hq_allies","concrete_2x1_tower_01_push_hq_axis","Concrete_2x2_Tower_01","Metals_2x1_Shelter_01","Metals_2x2_Silo_01","Wood_3x1_Barracks_01","wood_3x1_barracks_02","wood_3x1_barracks_03","Wood_3x2_Barracks_01","wood_3x2_barracks_02","wood_3x2_barracks_03","wood_3x2_barracks_m11_unique","wood_3x3x2_warehouse_01","wood_3x3x2_warehouse_02","wood_3x3x2_warehouse_03","brick01_3x2x3_01","brick01_3x2x3_02","brick01_3x2x3_03","brick01_3x2x3_04","brick01_3x2x3_05","brick01_4x1x2_01","brick01_4x1x2_02","brick01_5x1x2_01","brick01_5x1x2_02","lublin_castle_01","lublin_castle_02","lublin_castle_03","lublin_castle_04","lublin_castle_05","lublin_castle_06","lublin_castle_07","MultiSub_3x2_01","MultiSub_3x3_01","multisub_3x3_02","multisub_3x3_03","multisub_3x3_04","multisub_3x3_04_end","MultiSub_3x3_Combo_01","MultiSub_3x3_Combo_02","MultiSub_4x2_Combo_01","MultiSub_4x2_Combo_02","multisub_5x2x3_01","multisub_5x2x3_unique_01","MultiSub_Wdg90_x2_01","MultiSub_Wdg90_x3_01","MultiSub_Wdg90_x4_01","Plaster01_2x1_M06_01","Plaster01_2x2_01","Plaster01_2x2_02","Plaster01_2x2_3sided_06","Plaster01_2x2_Corner_01","Plaster01_2x2_Wdg_01","Plaster01_2x3_01","Plaster01_2x3_Arch_01","Plaster01_2X3_combo_01","Plaster01_2x3_Corner_01","Plaster01_2X3_Wdg_01","Plaster01_3x1_01","Plaster01_3x1_M06_01","Plaster01_3x2_01","Plaster01_3x2_NIS_02","Plaster01_3x2_Shops_01","Plaster01_3x2_Wdg60_01","Plaster01_3x2_Wdg_01","plaster01_3x2_wdg_02","Plaster01_3x3_01","plaster01_3x3_01_german_hq","Plaster01_3x3_combo_01","Plaster01_3x3_Wdg_01","Plaster01_4x2_01","Plaster01_4x2_Joint_01","Plaster01_4x2_Joint_02","Plaster01_4x2_Joint_03","Plaster01_5x2_Joint_01","Plaster01_5x2_Joint_02","Plaster01_6x3_01","plaster01_6x3_02","Plaster02_1x3_01","Plaster02_1x3_Wdg_01","Plaster02_1x5_M06Tower_01","Plaster02_2x2_01","Plaster02_2x2_3Sided_01","Plaster02_2x3_Arch_01","Plaster02_2x3_CivicLeft_01","Plaster02_2x3_CivicMid_01","Plaster02_2x3_CivicRight_01","Plaster02_3x3_01","Plaster02_4x2_Civic","Plaster02_5x2_01","Plaster02_5x2_M06_01","Plaster02_5x3_Manor_01","Plaster02_5x3_Manor_02","Plaster02_6x3_Civic_01","Plaster02_6x3_Civic_02","plaster02_6x3_civic_02_hq","Plaster02_7x3_M06_01","Plaster03_1x1_Shed_01","Plaster03_1x3_01","Plaster03_2x1_01","Plaster03_2x1_02","Plaster03_2x2_01","Plaster03_2x2_Arch_03","Plaster03_2x2_Ruin_01","Plaster03_2x3_Indu_01","Plaster03_3x1_Garage_01","Plaster03_3x1_Hangar_01","Plaster03_3x1_Rural_01","Plaster03_3x2_01","Plaster03_3x2_02","Plaster03_3x2_Barn_01","Plaster03_3x3_01","Plaster03_4x3_Indu_01","Plaster04_1x2_Tower_01","Plaster04_1x3_01","Plaster04_2x1_Garage_01","Plaster04_2x1_TrainShed_01","Plaster04_2x2_01","Plaster04_2x2_02","Plaster04_2x2_3Sided_01","Plaster04_2x3_Arch_01","Plaster04_2x3_Fire_01","Plaster04_2x4_Arch_01","plaster04_2x4_arch_01_ignitionpoint","Plaster04_3x3_01","Plaster04_3x3_Balcony_01","Plaster04_3x3_Vari_01","Plaster04_6x3_Train_01","plaster05_2x4x2_01","plaster05_2x4x2_02","plaster05_3x4x3_01","plaster05_3x4x3_01_end","plaster05_3x4x3_02","plaster05_3x4x3_03","plaster05_mutisub_4x4x3_01","plaster05_mutisub_4x4x3_02","poznan_city_hall_01","reichstag_01","reichstag_02","reichstag_03","reichstag_04","reichstag_05","stalingrad_industrial_01","stalingrad_railway_01","stalingrad_railway_02","stalingrad_railway_03","stalingrad_railway_04","stalingrad_railway_05","stalingrad_railway_05_test","stalingrad_railway_06","stalingrad_railway_07","stalingrad_railway_08","lublin_castle_gate_door","generic_trench","hmg_trench","mortar_emplacement","slit_trench","wooden_guardpost_01","wooden_guardpost_01_nis","Harbour_Crane_01","wooden_guardpost_large_los","concrete_1x2_tower_02_los","fortress_spotter_tower","console_interactive_capture2","generator_interactive","frozen_panzer_iv","frozen_stug_iii","wrecked_brummbar_02","wrecked_t_34_76_02","bridge_short_span_wooden_w_iron_banding_wall01","bridge_wood_angle","axis_hq_capturable","manpower_resource_point","territory_fuel_point","territory_fuel_point_mp","territory_munitions_point","territory_munitions_point_mp","territory_point","territory_point_command","territory_point_invisible","territory_point_invisible_command","territory_point_low","territory_point_mp","victory_point","victory_point_no_swap","victory_point_no_ticker","sp_victory_point_hold_without_troops","forward_command_garrisonable","meta_fuel_depot","m10_military_hospital","m11_military_hospital","military_hospital","radio_antenna","radio_antenna_no_abilities","radio_post_sp","radio_post_tow","radio_tower_point_mp","radio_tower_point_occupation","radio_tower_point_tow","sp_hq","sp_hq_wreck","support_bay","tow_kalach_fuel_point","tow_kalach_munitions_point","tow_kalach_radio_tower","tow_kalach_watchtower","watchtower","watchtower_battle","armored_rifle_command_mp","armored_rifle_command_sp","armor_command_mp","armor_command_sp","company_weapons_pool_mp","company_weapons_pool_sp","rifle_command_mp","rifle_command_sp","armored_rifle_command_wreck_mp","armor_command_wreck_mp","company_weapons_pool_wreck_mp","rifle_command_wreck_mp","aef_barbed_wire_fence_mp","aef_mg_nest","aef_mg_nest_aef_base","aef_mg_nest_perimeter_mp","aef_sandbags","aef_sandbag_fence","aef_tank_trap_mp","airborne_beacon_mp","invisi_heal_station_mp","invisi_repair_station_mp","major_retreat_point_mp","fighting_position_mp","fighting_position_riflemen_mp","observation_post_fuel_aef_mp","observation_post_munition_aef_mp","m4a3_sherman_demo_burnout","aef_airdropped_mine_contact_mp","aef_airdropped_mine_mp","aef_sandbagwall_cover_specialization","pm_aef_fighting_position_teamweapons","pm_aef_pinpoint_arty_marker_mp","pm_aef_pinpoint_arty_three_marker_mp","jackson","rifleman_soldier_group_mp","pm_attached_seargent","pm_attached_medic","aef_attack_plane","dodge_wc51_50cal_paradrop","pm_aef_airborne_paratroopers_plane_paras","pm_aef_airborne_paratroopers_plane_strafe","pm_aef_air_support_recon","pm_aef_air_support_rocket","pm_aef_air_support_rocket_elite","pm_aef_air_support_strafe","pm_aef_air_support_strafe_elite","pm_p47_flyby","pm_p47_mg_strafe","pm_p47_rocket_strafe","pm_aef_airborne_supply_drop_plane","assault_engineer_mp","assault_engineer_vehicle_crew_mp","captain_mp","captain_unlock_mp","lieutenant_mp","lieutenant_unlock_mp","major_mp","major_unlock_mp","paratrooper_mp","pathfinder_ir_mp","pathfinder_recon_mp","ranger_mp","rear_echelon_radioman_mp","rear_echelon_reserve_troop_mp","rear_echelon_troop_capt_mp","rear_echelon_troop_mp","rifleman_soldier_captain_mp","rifleman_soldier_lieutenant_mp","rifleman_soldier_mp","usf_medic_mp","vehicle_crew_bazooka_mp","vehicle_crew_troop_mp","vehicle_crew_troop_repair_station_mp","at_team_weapon_crew_mp","hmg_team_weapon_crew_mp","howitzer_team_weapon_crew_mp","m1919a4_team_weapon_crew_mp","mortar_team_weapon_crew_mp","m1919a4_30cal_machine_gun_mp","m1_81mm_mortar_mp","m2hb_50cal_machine_gun_mp","m2_60mm_mortar_mp","m1_57mm_antitank_gun_mp","m1_75mm_pack_howitzer_mp","dodge_wc51_50cal_mp","dodge_wc51_ambulance_mp","dodge_wc51_mp","dodge_wc51_mp_pathfinders","m10_tank_destroyer_mp","m20_utility_car_mp","m36_tank_destroyer_mp","m15a1_aa_halftrack_mp","m21_mortar_halftrack_mp","m3_halftrack_assault_mp","m3_halftrack_mp","m4a3e8_sherman_easy_8_mp","m4a3_76mm_sherman_mp","m4a3_sherman_bulldozer_mp","m4a3_sherman_mp","m5a1_stuart_mp","m7b1_priest_mp","m8a1_hmc_mp","m8_greyhound_mp","paratroopers_combat_group_plane","paratroopers_plane","paratroopers_plane_atgun","paratroopers_plane_hmg","paratroopers_plane_paras","p47_recon","p47_recon_plane_sweep","p47_recon_tracking","p47_rockets","p47_strafe","bereich_festung","bereich_festung_mp","dolch_aktionen","dolch_aktionen_mp","hintere_panzerwerk","hintere_panzerwerk_mp","schweres_kriegswerk","schweres_kriegswerk_mp","german_hq","german_hq_mp","german_hq_wreck","german_hq_wreck_mp","slit_trench_german","slit_trench_german_mp","sniper_cover","sniper_digin_cover_mp","axis_bunker_starting_position","axis_bunker_starting_position_mp","bunker","bunker_mp","bunker_of_death_mp","invisible_retreat_point","fuel_post_german","fuel_post_german_mp","munition_post_german","munition_post_german_mp","m01_stuka_dogfight","m01_stuka_ground_attack_fast","mg42_crew_single","stuka_ground_attack_long","howitzer_105mm_dummy","panzer_iv_sdkfz_161_tutorial","assault_grenadiers_leader_mp","assault_grenadiers_mp","grenadiers","grenadiers_mp","grenadiers_sp","german_medic","german_medic_mp","assault_officer","assault_officer_grenadiers_bodyguard_mp","assault_officer_mp","officer","officer_mp","officer_tow_occupation","ostruppen_soldier","ostruppen_soldier_mp","panzer_grenadiers","panzer_grenadiers_mp","urban_assault_panzer_grenadiers_mp","hack_invisi_pioneer_mp","pioneer","pioneer_mp","repair_pioneer","repair_pioneer_mp","paradrop_sniper_soldier_mp","sniper_soldier","sniper_soldier_mp","stormtroopers_mp","atgun88_crew","atgun88_crew_mp","atgun_crew","atgun_crew_mp","howitzer_crew","howitzer_crew_mp","mg42_crew","mg42_crew_mp","mortar_crew","mortar_crew_mp","granatewerfer_34_81mm_mortar","granatewerfer_34_81mm_mortar_mp","mg42_hmg","mg42_hmg_attack_ground","mg42_hmg_mp","pak40_75mm_at_gun","pak40_75mm_at_gun_mp","pak43_88mm_at_gun","pak43_88mm_at_gun_mp","howitzer_105mm_le_fh18","howitzer_105mm_le_fh18_mp","luftwaffe_officer_tow","panzer_mg","hintere_panzerwerk_voronezh","armored_car_sdkfz_222","armored_car_sdkfz_222_mp","brummbar_sturmpanzer_iv_sdkfz_166","brummbar_sturmpanzer_iv_sdkfz_166_mp","elefant_sdkfz_184","elefant_sdkfz_184_mp","halftrack_sdkfz_251","halftrack_sdkfz_251_mp","mechanized_250_halftrack_grenadier_mp","mechanized_250_halftrack_mp","mortar_light_halftrack_250_7","mortar_light_halftrack_250_7_mp","sdkfz_221_light_at_halftrack","opel_blitz_supply_truck_mp","opel_blitz_truck","ostwind_flak_panzer","ostwind_flak_panzer_mp","panther_sdkfz_171","panther_sdkfz_171_mp","panzerwerfer_sdkfz_4_1","panzerwerfer_sdkfz_4_1_mp","panzer_iii_mp","panzer_iv_commander_sdkfz_161","panzer_iv_commander_sdkfz_161_mp","panzer_iv_sdkfz_161","panzer_iv_sdkfz_161_mp","panzer_iv_sdkfz_ausf1","panzer_iv_sdkfz_ausf1_mp","puma_east_german","stug_iii_e_sdkfz_141_1","stug_iii_e_sdkfz_141_1_commander_mp","stug_iii_e_sdkfz_141_1_mp","stug_iii_g_sdkfz_141_1","stug_iii_g_sdkfz_141_1_mp","cargo_plane","cargo_plane_fuel","cargo_plane_munitions","stuka_air_recon","stuka_air_recon_mp","stuka_bombing_dive","stuka_bombing_dive_mp","stuka_bombing_run_sp","stuka_fragementation_bomb","stuka_fragementation_bomb_mp","stuka_ground_attack","stuka_ground_attack_m09","stuka_ground_attack_mp","stuka_ground_attack_west_airborne_assault","stuka_incendiary_bomb","stuka_incendiary_bomb_victory","stuka_ju87_anti_tank","stuka_ju87_anti_tank_m06","stuka_ju87_anti_tank_mp","stuka_ju87_anti_tank_superiority","stuka_smoke_bomb","stuka_smoke_bomb_mp","tactical_bomber","tactical_bomber_accurate","tiger_ace_sdkfz_181_mp","tiger_sdkfz_181","tiger_sdkfz_181_mp","tiger_sdkfz_181_singleplayer_mission","tiger_sdkfz_181_tow","proxy_medic_mp","proxy_rifleman_soldier_a","proxy_rifleman_soldier_b","proxy_rifleman_soldier_c","proxy_sniper_recon_mp","barracks","barracks_mp","motorpool","motorpool_mp","tank_depot","tank_depot_mp","weapon_support_center","weapon_support_center_mp","hq","hq_invisible_sp","hq_mp","hq_no_wreck","hq_wreck","hq_wreck_mp","barbed_wire_fence","barbed_wire_fence_mp","barbed_wire_field","barbed_wire_field_mp","machine_gun_nest","machine_gun_nest_mp","repair_station_mp","sand_bag_soviet","sand_bag_soviet_mp","sand_bag_soviet_tutorial","wire_field","wire_field_mp","observation_post_fuel","observation_post_fuel_mp","observation_post_munition","observation_post_munition_mp","steam_train","m01_il-2_sturmovik_rocket","m01_il2_dogfight","m01_medic","hq_wreck_m06","forward_hq","m08_tank_buster_conscript","isakovich_a01_commander","isakovich_m06","m01_base_conscript_soldier","m01_base_conscript_soldier_durable","m01_conscript_soldier","m01_conscript_soldier_dock","m01_conscript_soldier_harmless","m01_conscript_soldier_harmless_durable","m11_ania_sniper","m11_isakovich_recon","m11_sniper","m11_sniper_recon","tow_cold_weaether_guard_troops","m11_partisan_troop_kar98k","m11_partisan_troop_nagant","m11_partisan_troop_noweapon","m08_t_34_76_smallpath","combat_engineer","combat_engineer_mp","repair_engineer","repair_engineer_mp","guard_troops","guard_troops_assault_mp","guard_troops_mp","penal_battalion_troops","penal_battalion_troops_mp","shock_troops","shock_troops_mp","commissar","commissar_227","commissar_mp","commissar_of_death_227_mp","base_conscript_soldier","base_conscript_soldier_mp","conscript_soldier","conscript_soldier_conscript_bodyguard_mp","conscript_soldier_mp","medic","medic_mp","partisan_troops_antitank","partisan_troops_lmg","partisan_troops_rifle","partisan_troops_smg","partisan_sniper","partisan_troop_kar98k","partisan_troop_kar98k_2","partisan_troop_kar98k_2_mp","partisan_troop_kar98k_mp","partisan_troop_kar98k_tow_bd","partisan_troop_kar98k_tow_mp","partisan_troop_nagant","partisan_troop_nagant_mp","partisan_troop_nagant_tow_mp","refugee_female","refugee_female_mp","refugee_male","refugee_male_mp","sniper","sniper_mp","sniper_recon","sniper_recon_mp","soviet_officer","soviet_officer_mp","atgun53k_crew","atgun53k_crew_mp","atgunzis_crew","atgunzis_crew_mp","dshk_weapon_crew","dshk_weapon_crew_mp","howitzer_crew203__soviet_mp","howitzer_crew_soviet","howitzer_crew_soviet_mp","maxim_weapon_crew","maxim_weapon_crew_mp","mortar_120mm_weapon_crew_mp","mortar_weapon_crew","mortar_weapon_crew_mp","_civilian_female","_civilian_female_mp","_civilian_male","_civilian_male_mp","dhsk_38_machine_gun","dhsk_38_machine_gun_mp","hm-120_38_mortar","hm-120_38_mortar_mp","m1910_maxim_heavy_machine_gun","m1910_maxim_heavy_machine_gun_mp","pm41_82mm_mortar","pm41_82mm_mortar_mp","m1937_53-k_45mm_at_gun","m1937_53-k_45mm_at_gun_mp","m1942_76mm_divisional_gun_zis-3","m1942_76mm_divisional_gun_zis-3_mp","artillery_203mm_b4","m1931_203mm_b-4_howitzer_artillery","m1931_203mm_b-4_howitzer_artillery_commander_mp","m1931_203mm_b-4_howitzer_artillery_mp","m1937_152mm_ml_20_artillery","m1937_152mm_ml_20_artillery_mp","il-2_sturmovik","il-2_sturmovik_advanced_mp","il-2_sturmovik_anti_tank_bomb_mp","il-2_sturmovik_mark_vehicle_mp","il-2_sturmovik_mp","il-2_sturmovik_recon","il-2_sturmovik_recon_mp","il-2_sturmovik_rocket","il-2_sturmovik_rocket_mp","il-2_sturmovik_rocket_sp","il-2_sturmovik_victory_mp","is-2_heavy_tank","is-2_heavy_tank_mp","isu_152_spg","isu_152_spg_mp","katyusha_bm-13n","katyusha_bm-13n_mp","kv-1","kv-1_commander_mp","kv-1_mp","kv-2","kv-2_mp","kv-2_tow","kv-8","kv-8_mp","m3a1_scout_car","m3a1_scout_car_mp","m5_halftrack","m5_halftrack_assault_mp","m5_halftrack_mp","cargo_plane_soviet","soviet_allied_cargo_plane","sherman_soviet","su_76m","su_76m_mp","su_85","su_85_mp","t_34_76","t_34_76_mp","t_34_85","t_34_85_mp","t_70m","t_70m_mp","us6_truck","us6_truck_mp","zis_6_transport","zis_6_transport_mp","heavy_armor_support_mp","infantry_support_mp","light_armor_support_mp","west_german_hq_mp","west_german_hq_wreck_mp","base_flak_gun_mp","flak_emplacement","flak_emplacement_base","reinforced_barbed_wire_fence_mp","reinforced_barbed_wire_tank_trap_mp","west_german_invisi_repair_station_mp","wg_barbed_wire_fence_mp","wg_sandbag_fence_mp","bunker_westgerman_mp","heavy_armor_support_preplaced","infantry_support_preplaced","light_armor_support_preplaced","howitzer_105mm_le_fh18_minichallenge","howitzer_105mm_long_range","armored_car_sdkfz_223","assault_pioneer_mp","fallschirmjager_mp","field_officer_mp","terror_officer_guard_mp","terror_officer_mp","jaeger_light_infantry_recon","obersoldaten_mp","panzerfusilier_mp","urban_assault_light_infantry","volksgrenadier_mp","anti_tank_gun_crew_mp","arty_crew_mp","flak_emplacement_crew","flak_emplacement_crew_base","hmg_crew_mp","mg34_hmg_crew","mortar_team_crew_mp","granatwerfer_34_81mm_mortar_wg_mp","mg34_hmg_mp","mg42_hmg_wg_mp","pak40_75mm_at_gun_wg_mp","pak43_88mm_at_gun_westgerman_mp","raketenwerfer43_88mm_puppchen_antitank_gun_mp","le_ig_18_inf_support_gun_mp","halftrack_sdkfz_251_17_flak_mp","halftrack_sdkfz_251_20_ir_searchlight_mp","halftrack_sdkfz_251_20_ir_searchlight_sp","halftrack_sdkfz_251_mp_2","halftrack_sdkfz_251_wurfrahmen_40_mp","jagdpanzer_iv_sdkfz_162_mp","jagdtiger_sdkfz_186_mp","king_tiger_sdkfz_182_mp","kubelwagen_type_82_mp","ostwind_flak_panzer_west_german_mp","panther_sdkfz_171_commander_mp","panther_sdkfz_171_ausf_g_mp","panzer_ii_luchs_sdkfz_123_mp","panzer_iv_sdkfz_ausf_j_mp","ju52_paratrooper_plane","puma_sdkfz_234_mp","sturmtiger_606_38cm_rw_61_mp","sws_halftrack_mp","sws_halftrack_sp",}
	local bpName = BP_GetName(Entity_GetBlueprint(entity))
	
	return Table_Contains(list, bpName)
end

function Game_GetLocalPlayerID()
	return Player_GetID(Game_GetLocalPlayer())
end

function Heading_Rotate(heading, amount)
	local _heading = World_Pos(heading.x, heading.y, heading.z)
	local angle = math.atan2(_heading.z, _heading.x) + math.rad(amount)
	_heading.z = math.sin(angle)
	_heading.x = math.cos(angle)
	return _heading
end

function Misc_UnSelectAll()
	Misc_GetSelectedSquads(sg_selected, false)
	Misc_GetSelectedEntities(eg_selected, false)
	
	SGroup_ForEach(sg_selected, function(sigid, idx, squad)
		Misc_SelectSquad(squad, false)
	end)
	
	EGroup_ForEach(eg_selected, function(eigid, idx, entity)
		Misc_SelectEntity(entity, false)
	end)
end

function Modify_SetSquadtAutoTargetting(squad, hardpoint, enable)
	local modifier = 1
	if enable then
		modifier = Modifier_Create(MAT_Weapon, "modifiers\\auto_target_enable_weapon_modifier.lua", MUT_Enable, true, 1, hardpoint)
	else
		modifier = Modifier_Create(MAT_Weapon, "modifiers\\auto_target_enable_weapon_modifier.lua", MUT_Enable, true, -1, hardpoint)
	end
	local result = Modifier_ApplyToSquad(modifier, squad)
	return result
end

function Modify_SetEntityAutoTargetting(entity, hardpoint, enable)
	if Entity_Validate(entity) and Entity_HasModifierExt(entity) then
		local modifier = 1
		if enable then
			modifier = Modifier_Create(MAT_Weapon, "modifiers\\auto_target_enable_weapon_modifier.lua", MUT_Enable, true, 1, hardpoint)
		else
			modifier = Modifier_Create(MAT_Weapon, "modifiers\\auto_target_enable_weapon_modifier.lua", MUT_Enable, true, -1, hardpoint)
		end
		local result = Modifier_ApplyToEntity(modifier, entity)
		return result
	end
end

function Modify_SetEntityAutoTargettingAllHardpoints(entity, enable)
	if Entity_Validate(entity) and Entity_HasModifierExt(entity) then
		local result = {}
		local count = Entity_GetWeaponHardpointCount(entity)
		local zero = "0"
		if count > 0 then
			for i = 1, count do
				if i == 10 then
					zero = ""
				end
				local hardpoint = "hardpoint_" .. zero .. i
				local modId = Modify_SetEntityAutoTargetting(entity, hardpoint, enable)
				table.insert(result, modId)
			end
		end
		return result
	end
end			

function Modify_SetSquadAutoTargettingAllHardpoints(squad, enable)
	local result = {}
	Squad_ForEachEntity(squad, function(squadid, idx, entity)
		local subResult = Modify_SetEntityAutoTargettingAllHardpoints(entity, enable)
		Table_AddTable(result, subResult)
	end)
	return result
end

function Modify_SetSGroupAutoTargettingAllHardpoints(sgroup, enable)
	local result = {}
	SGroup_ForEach(sgroup, function(sgid, idx, squad)
		local subResult = Modify_SetSquadAutoTargettingAllHardpoints(squad, enable)
		Table_AddTable(result, subResult)
	end)
	return result
end
	
function Modify_SetEGroupAutoTargettingAllHardpoints(entity, enable)
	local result = {}
	EGroup_ForEach(egroup, function(egid, idx, entity)
		local subResult = Modify_SetEntityAutoTargettingAllHardpoints(entity, enable)
		Table_AddTable(result, subResult)
	end)
	return result
end

function Modify_SquadTypeEnableCapturing(playerid, blueprint, enabled)
	local _enable = -1
	if enabled then
		_enable = 1
	end
	local modifier = Modifier_Create(MAT_SquadType, "modifiers\\capture_enable_squad_modifier.lua", MUT_Enable, false, _enable, blueprint)
	return {Modifier_ApplyToPlayer(modifier, playerid)}
end

function Player_IsLocalPlayer(player)
	local pid = Player_GetID(player)
	if pid == Game_GetLocalPlayerID() then
		return true
	end
	return false
end

function Player_GetUniqueKey(player)
	return "player_" .. Player_GetID(player) .. "_" .. Player_GetName(player)
end

function Player_GetName(player)
	return Player_GetDisplayName(player)[1]
end

function Players_ForEach(f)
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		local pid = Player_GetID(player)
		f(pid, i, player)
	end
end 

function Players_ForEachInTeam(team, f)
	Players_ForEach(function(pid, idx, player)
		if Player_GetTeam(player) == team then
			f(pid, idx, player)
		end
	end)
end

function Player_AddPopulation(player, amount)
	local population = Player_GetMaxPopulation(player, CT_Personnel)
	Player_SetPopCapOverride(player, population + amount)
end

function Player_ExecuteLocally(player, f)
	if Player_IsLocalPlayer(player) then
		f(player)
	end
end

function Player_GetEnemyPlayer(player)
	local team = Player_GetTeam(player)
	local enemyTeam = Team_GetEnemyTeam(team)
	return Team_GetFirstPlayer(enemyTeam)
end

function Player_SetResourceIncomeNumber(player, resource_type, number, dbg_resname)
	local originalRate = Player_GetResourceRate(player, resource_type)
	local numberToShow = number
	local addition = (0 - originalRate) + (numberToShow / 60)
	--if player == player_generic then
	--	Msg("[" .. dbg_resname .. "] Received number " .. number .. " (setting rate to " .. addition / 8 .. ")")
	--end
	Modify_PlayerResourceRate(player, resource_type, addition / 8, MUT_Addition)
end

function Pos_AddHeight(pos, height)
	return World_Pos(pos.x, pos.y + height, pos.z)
end

function Pos_GetString(pos)
	return "X:" .. math.floor(pos.x * 100)/100 .. ", Y: " .. math.floor(pos.y*100)/100 .. ", Z: " .. math.floor(pos.z*100)/100
end


function SGroup_CreateTemp(sgroupName)
	g_temp_sgroup_id = g_temp_sgroup_id + 1
	return SGroup_Create(sgroupName .. g_temp_sgroup_id)
end

function Squad_GetUniqueKey(squad)
	return "squad_" .. Squad_GetGameID(squad)
end

function Squad_GetName(squad)
	local bp = Squad_GetBlueprint(squad)
	return Util_GetBPName(bp)
end

function Squad_GetTempSGroup(squad, index)
	index = index or 1
	
	local sgroup = SGroup_CreateTemp("sg_temp_blah")
	SGroup_Add(sgroup, squad)
	return sgroup
end

function Squad_IsIdle(squad)
	return Squad_HasActiveCommand(squad) and Squad_GetActiveCommand(squad) == SQUADSTATEID_Idle
end

function Squad_IsConcstructing(squad)
	return Squad_HasActiveCommand(squad) and Squad_GetActiveCommand(squad) == SQUADSTATEID_Construction
end

function Squad_IsHeadingToPosition(squad, pos, distance)
	distance = distance or 0
	if Squad_HasDestination(squad) then
		local destination = Squad_GetDestination(squad)
		if World_DistancePointToPoint(pos, destination) <= distance then
			return true
		end
	end
	return false
end

function Squad_ForEachEntity(squad, f)
	for i = 1, Squad_Count(squad) do
		local entity = Squad_EntityAt(squad, i-1)
		f(squad, i-1, entity)
	end	
end

function Squad_InfraRedReveal(squad, duration)

	local modifiertype = "modifiers\\enable_visible_in_fow.lua"
	
	local modifier = Modifier_Create(MAT_Squad, modifiertype, MUT_Enable, false, 1, "")

	local result = Modifier_ApplyToSquad(modifier, squad)
	if duration ~= nil then
		Util_Delay(duration, function()
			Modifier_Remove(result)
		end)
	end

	return {result}
end

function Squad_CountSpawned(squad)
	local count = 0
	Squad_ForEachEntity(squad, function(sid, idx, entity)
		if Entity_IsAlive(entity) and Entity_IsSpawned(entity) then
			count = count + 1
		end
	end)
	return count
end

function Squad_IsVehicle(squad)
	local isVehicle = false
	Squad_ForEachEntity(squad, function(squad, idx, entity)
		if Entity_IsVehicle(entity) then
			isVehicle = true
		end
	end)
	return isVehicle
end

function Squad_IsPlane(squad)
	local isPlane = false
	Squad_ForEachEntity(squad, function(squad, idx, entity)
		if Entity_IsPlane(entity) then
			isPlane = true
		end
	end)
	return isPlane
end

function Squad_SetSelectable(squad, selectabe)
	SGroup_SetSelectable(Squad_GetTempSGroup(squad), selectabe)
end

function Squad_GetLastAttackerSquad(squad)
	local sg_temp = SGroup_CreateTemp("sg_last_squad_attacker_squad")
	Squad_GetLastAttacker(squad, sg_temp)
	if SGroup_CountSpawned(sg_temp) > 0 then
		return SGroup_GetSpawnedSquadAt(sg_temp, 1)
	end
end

function String_Match(s, matches)
	if scartype(matches) ~= ST_TABLE then
		matches = {matches}
	end
	for key, v in ipairs(matches) do
		if string.match(s, v) then
			return true
		end
	end
	return false
end

function Team_GetFirstPlayer(team)
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		local pTeam = Player_GetTeam(player)
		if pTeam == team then
			return player
		end
	end
end

function Team_GetRandomPlayer(team)
	return Table_GetRandomItem(g_all_players[team])
end

function Team_GetEntitiesNearPoint(team, pos, radius)
	radius = radius or 15
	local eg_result = EGroup_CreateTemp("eg_team_entities_near_point")
	local eg_holder_temp = EGroup_CreateTemp("eg_team_entities_near_point_temp")

	Players_ForEachInTeam(team, function(pid, idx, player)
		EGroup_Clear(eg_holder_temp)
		World_GetEntitiesNearPoint(player, eg_holder_temp, pos, radius, OT_Player)
		EGroup_AddGroup(eg_result, eg_holder_temp)
	end)
	return eg_result
end

function Team_GetSquadsNearPoint(team, pos, radius)
	radius = radius or 15
	local sg_result = SGroup_CreateTemp("sg_team_entities_near_point")
	local sg_holder_temp = SGroup_CreateTemp("sg_team_entities_near_point_temp")

	Players_ForEachInTeam(team, function(pid, idx, player)
		SGroup_Clear(sg_holder_temp)
		World_GetSquadsNearPoint(player, sg_holder_temp, pos, radius, OT_Player)
		SGroup_AddGroup(sg_result, sg_holder_temp)
	end)
	return sg_result
end

function Team_GetPlayerCount(team)
	local count = 0
	Players_ForEachInTeam(team, function(pid, idx, player)
		count = count + 1
	end)
	return count
end

function Team_GetTitle(team)
	local title = "Team [ "
	local count = Team_GetPlayerCount(team)
	local _count = 0
	Players_ForEachInTeam(team, function(pid, idx, player)
		local name = Player_GetName(player)
		title = title .. name
		_count = _count + 1
		if _count < count then
			title = title .. ", "
		end
	end)
	
	return title .. " ]"
end

function Table_AddTable(t, add, f)
	if t ~= nil and add ~= nil then
		if not f then
			f = ipairs
		end
		if f == ipairs then
			for key, value in f(add) do
				table.insert(t, value)
			end
		elseif f == pairs then
			for key, value in f(add) do
				t[key] = value
			end
		end
	end
end

function Table_GetSmallest(t, itemField)
	local smallest = nil
	local smallestItem = nil
	for key, v in ipairs(t) do
		local value
		if itemField ~= nil then
			value = v[itemField]
		else
			value = v
		end
		if smallest == nil or value < smallest then
			smallest = value
			smallestItem = v
		end
	end
	
	if itemField ~= nil then
		return smallestItem
	else
		return smallest
	end
end

function Table_GetLargest(t, itemField)
	local largest = nil
	local largestItem = nil
	for key, v in ipairs(t) do
		local value
		if itemField ~= nil then
			value = v[itemField]
		else
			value = v
		end
		if largest == nil or value > largest then
			largest = value
			largestItem = v
		end
	end
	
	if itemField ~= nil then
		return largestItem
	else
		return largest
	end
end

function Table_RemoveValue(t, v)
	for key, value in pairs(t) do
		if value == v then
			table.remove(t, key)
		end
	end
end

function Team_ExecuteLocally(team, f)
	Players_ForEachInTeam(team, function(pid, idx, player)
		Player_ExecuteLocally(player, f)
	end)
end

function Time_TicksToSeconds(ticks)
	return ticks / 8
end

function Time_SecondsToTicks(seconds)
	return seconds * 8
end

function UI_FlashSquad(squad)
	Squad_ForEachEntity(squad, function(squad, idx, entity)
		UI_FlashEntity(entity)
	end)
end

function Util_GlobalMessage(title, displaytime)
	Game_TextTitleFade(title, 0, displaytime, 2)
end

function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

function Util_Repeat(times, f)
	for i = 1, times do
		f()
	end
end

function Util_Delay(delay, task)
	--table.insert(g_delayed_task, {when = delay, f = task})
	local ruleName = "DelayedTask_" .. tostring(task) .. World_GetGameTime()
	_G[ruleName] = task
	Rule_AddOneShot(_G[ruleName], delay / 8)
	return ruleName
end

function Util_IsPositionInPolygon(polygon, x, y)
    --// ray-casting algorithm based on
    --// http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html
    
    --local x = point[0], y = point[1]
	
    local inside = false
	local length = table.getn(polygon)
	local j = length
    for i = 0, length do
		if i == 0 then
			j = length
		else
			j = i - 1 
		end
        local xi, yi = polygon[i][0], polygon[i][1]
        local xj, yj = polygon[j][0], polygon[j][1]
        
        local intersect = ((yi > y) ~= (yj > y))
            and (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
        if (intersect) then inside = not inside end
    end
    
    return inside
end

function Util_GetDirectionalOffset(pos, heading, offset, angle)
	heading = heading or World_Pos(0, 0, 0)
	angle = math.rad(angle)
	local alpha = math.atan2(heading.z, heading.x)
	local x = offset * math.cos(alpha + angle)
	local y = offset * math.sin(alpha + angle)
	--Msg("Offsets: X:" .. x .. ", Y: " .. y)
	local newPos = World_Pos(pos.x + x, pos.y, pos.z + y)
	newPos.y =  Misc_GetTerrainHeight(newPos)
	return newPos
end

function Util_GetDirectionalOffsetPosition(pos, heading, offset, direction)
	heading = heading or World_Pos(0, 0, 0)
	local angle = 0
	if direction == OFFSET_FRONT then
		angle = 0
	elseif direction == OFFSET_FRONT_RIGHT then
		angle = 45
	elseif direction == OFFSET_RIGHT then
		angle = 90
	elseif direction == OFFSET_BACK_RIGHT then
		angle = 135
	elseif direction == OFFSET_BACK then
		angle = 180
	elseif direction == OFFSET_BACK_LEFT then
		angle = 225
	elseif direction == OFFSET_LEFT then
		angle = 270
	elseif direction == OFFSET_FRONT_LEFT then
		angle = 315
	end
	--Msg("using angle " .. angle)
	return Util_GetDirectionalOffset(pos, heading, offset, angle)
end

function Util_GetRandomPos(pos, range, updateY)
	updateY = Util_DefaultValue(updateY, true)
	local _pos = Util_GetRandomPosition(pos, range)
	if updateY then
		_pos.y = Misc_GetTerrainHeight(_pos)
	end
	return _pos
end

function Util_GetRandomPosExtended(pos, minRange, maxRange)
	local angle = World_GetRand(1 * 1000, 360 * 1000) / 1000
	local distance = World_GetRand(minRange * 1000, maxRange * 1000) / 1000
	
	return Util_GetDirectionalOffset(pos, nil, distance, angle)
end

function Util_GetAngleTowardsPos(pos1, pos2)
	local distance = World_DistancePointToPoint(pos1, pos2)
	
	local pos_list = {}
	
	for i = 1, 360 do
		local pos = Util_GetDirectionalOffset(pos1, nil, distance, i)
		table.insert(pos_list, {pos = pos, angle = i})
	end
	
	local lowest_distance = distance + 1
	local lowest_index = -1
	for key, item in ipairs(pos_list) do
		local dist = World_DistancePointToPoint(pos2, item.pos)
		if dist < lowest_distance then
			lowest_distance = dist
			lowest_index = key
		end
	end
	
	if lowest_index > -1 then
		--Msg("returning angle " .. pos_list[lowest_index].angle)
		return pos_list[lowest_index].angle
	end
end

function Util_CopyPosition(pos)
	return World_Pos(pos.x, pos.y, pos.z)
end

function Util_CreateUIFrame(name)
	name = tostring(name)
	dr_clear(name)
	dr_setautoclear(name, 0)
	return name
end

function Util_Tester(f, v)
	local success, result = xpcall(function() return f(unpack(v)) end, function() end)
	return success or false	
end

function Misc_Tester(f, v)
	local success, result = xpcall(function() return f(unpack(v)) end, function() end)
	return {passed = success, result = result} or {passed = false}
end

function Util_DefaultValue(value, defaultValue)
	if value == nil then
		return defaultValue
	else
		return value
	end
end

function Util_DistanceFromLine(vPoint, vBegin, vEnd)
   return math.abs((vEnd.z - vBegin.z) * vPoint.x - (vEnd.x - vBegin.x) * vPoint.z + vEnd.x * vBegin.z - vEnd.z * vBegin.x) / math.sqrt(math.pow(vEnd.z - vBegin.z, 2) + math.pow(vEnd.x - vBegin.x, 2))
end

function Util_DistancePointToTeamShortest(team, point)
	local distances = {}
	Players_ForEachInTeam(team, function(pid, idx, player)
		local pos = Player_GetStartingPosition(player)
		local distance = World_DistancePointToPoint(point, pos)
		table.insert(distances, distance)
	end)
	
	return Table_GetSmallest(distances)
end

function World_GetEntitiesByBlueprint(ebp)
	local result = {}
	if scartype(ebp) == ST_STRING then
		ebp = BP_GetEntityBlueprint(ebp)
	end
	for i = 0, World_GetNumEntities() -1 do
		local entity = World_GetEntity(i)
		if Entity_GetBlueprint(entity) == ebp then
			table.insert(result, entity)
		end
	end
	
	return result
end

function World_ForEachEntities(f)
	for i = 0, World_GetNumEntities() -1 do
		local entity = World_GetEntity(i)
		f(Entity_GetGameID(entity), i, entity)
	end
end

function World_ForEachEntitiesByBlueprint(ebp, f)
	for i = 0, World_GetNumEntities() -1 do
		local entity = World_GetEntity(i)
		if Entity_GetBlueprint(entity) == ebp then
			f(Entity_GetGameID(entity), i, entity)
		end
	end
end

function World_GetEntitiesOfType(entityType)
	local result = {}
	World_ForEachEntities(function(eid, idx, entity)
		if Entity_IsOfType(entity, entityType) then
			table.insert(result, entity)
		end
	end)
	return result
end

function World_DivideTerritoryBetweenTeams()
	local g_teams = {
		[0] = {players = {}, count = 0},
		[1] = {players = {}, count = 0},
	}
	local g_territory_points = {
		victoryPoints = {points = {}, blueprint = g_ebp_victory_point, count = 0},
		strategicPoints = {points = {}, blueprint = g_ebp_territory_point, count = 0},
		fuelPoints = {points = {}, blueprint = g_ebp_fuel_point, count = 0},
		munitionPoints = {points = {}, blueprint = g_ebp_munitions_point, count = 0},
		specialPoints = {points = {}, blueprint = {g_ebp_repair_point, g_ebp_heal_point, g_ebp_watch_tower_point}, count = 0},
	}
	
	Players_ForEach(function(pid, idx, player)
		local team = Player_GetTeam(player)
		table.insert(g_teams[team].players, player)
		g_teams[team].count = g_teams[team].count + 1
	end)
	
	World_ForEachEntities(function(eid, idx, entity)
		if Entity_IsOfType(entity, "strategic_node") then
			local bp = Entity_GetBlueprint(entity)
			
			for key, pointType in pairs(g_territory_points) do
				if (scartype(pointType.blueprint) == ST_TABLE and Table_Contains(pointType.blueprint, bp)) or pointType.blueprint == bp  then
					table.insert(pointType.points, {entity = entity, entityId = Entity_GetGameID(entity), pos = Entity_GetPosition(entity)})
					pointType.count = pointType.count + 1
					break
				end
			end
		end
	end)
	for key, pointType in pairs(g_territory_points) do
		if pointType.count > 1 then
			local points = {}
			local team = 0
			for pointKey, point in ipairs(pointType.points) do
				local center_offset = 0
				if pointType.blueprint == g_ebp_victory_point then
					local _distance = 0
					if pointType.count == 3 then
						local pos_1 = pointType.points[1].pos
						local pos_2 = pointType.points[2].pos
						local pos_3 = pointType.points[3].pos
						local dist_1 = World_DistancePointToPoint(pos_1, pos_2)
						local dist_2 = World_DistancePointToPoint(pos_2, pos_3)
						local dist_3 = World_DistancePointToPoint(pos_3, pos_1)
						
						local pos_a = nil
						local pos_b = nil
						local pos_c = nil
						if dist_1 > dist_2 and dist_1 > dist_3 then
							pos_a = pos_1
							pos_b = pos_2
							pos_c = pos_3
						elseif dist_2 > dist_1 and dist_2 > dist_3 then
							pos_a = pos_2
							pos_b = pos_3
							pos_c = pos_1
						elseif dist_3 > dist_1 and dist_3 > dist_2 then
							pos_a = pos_3
							pos_b = pos_1
							pos_c = pos_2
						end
						
						_distance = Util_DistanceFromLine(pos_c, pos_a, pos_b)
					end
					if (_distance > 30) then
						center_offset = 0
					else
						center_offset = World_DistancePointToPoint(point.pos, g_pos_center_relative)
					end
				end
				local _distances = {distance_0 = Util_DistancePointToTeamShortest(0, point.pos) - center_offset, distance_1 = Util_DistancePointToTeamShortest(1, point.pos) - center_offset, point = point}
				
				table.insert(points, _distances)
			end
			local count_points = table.getn(points)
			if count_points % 2 > 0 then
				count_points = count_points - 1
			end
			for i = 1, count_points do
				local case = Table_GetSmallest(points, "distance_" .. team)
				Entity_InstantCaptureStrategicPoint(case.point.entity, g_teams[team].players[1])
				if team == 0 then team = 1 else team = 0 end
				Table_RemoveValue(points, case)
			end
		end
	end
end