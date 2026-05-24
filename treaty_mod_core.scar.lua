import("ScarUtil.scar")
import("Fatalities/Fatalities.scar")
import("WinConditions/lib_generic.scar")

function TreatyMod_PreInit()
	--loadfile("scar/treaty_mod/treaty_mod_core.scar")()
	TreatyMod_Init()
end

Scar_AddInit(TreatyMod_PreInit)



function TreatyMod_Init()
	--AI_EnableAll(false)
	--FOW_Enable(false)
	Players_ForEach(function(pid, idx, player)
		Player_SetPopCapOverride(player, g_treaty_mod_popcap)
	end)
	g_enable_messages = false
	g_text_line_count = 0
	g_text = ""
	g_guid = "9449299d18824bc5ae1083e562fb5678"
	g_ebp_victory_point = BP_GetEntityBlueprint("victory_point")
	g_ebp_territory_point = BP_GetEntityBlueprint("territory_point_mp")
	g_ebp_fuel_point = BP_GetEntityBlueprint("territory_fuel_point_mp")
	g_ebp_munitions_point = BP_GetEntityBlueprint("territory_munitions_point_mp")
	g_ebp_repair_point = BP_GetEntityBlueprint("support_bay")
	g_ebp_heal_point = BP_GetEntityBlueprint("military_hospital")
	g_ebp_watch_tower_point = BP_GetEntityBlueprint("watchtower")
	g_pos_center_absolute = World_Pos(0, 0, 0)
	g_pos_center_relative = World_Pos(0, Misc_GetTerrainHeight(g_pos_center_absolute), 0)
	g_3d_text_frame = Util_CreateUIFrame("g_3d_text_frame")
	g_icon_company_ceasefire_active = TreatyMod_GetIcon("icon_company_cease_fire_active")
	g_weapon_modifiers = {}
	g_territory_points = {
		victoryPoints = {points = {}, blueprint = g_ebp_victory_point, count = 0},
		strategicPoints = {points = {}, blueprint = g_ebp_territory_point, count = 0},
		fuelPoints = {points = {}, blueprint = g_ebp_fuel_point, count = 0},
		munitionPoints = {points = {}, blueprint = g_ebp_munitions_point, count = 0},
		specialPoints = {points = {}, blueprint = {g_ebp_repair_point, g_ebp_heal_point, g_ebp_watch_tower_point}, count = 0},
	}
	g_locked_commands = {SCMD_Attack, SCMD_StationaryAttack, SCMD_AttackMove, SCMD_Capture, CMD_AttackMove, CMD_Attack, CMD_AttackForced, CMD_AttackFromHold, CMD_Capture}
	g_squad_last_known_pos = {}
	g_moved_squad = {}
	g_cmd_monitors = {}
	g_trespassing_squads = {}
	g_treaty_mod_monitor_enabled = true
	g_teams = {
		[0] = {players = {}, count = 0},
		[1] = {players = {}, count = 0},
	}
	
	g_team_territories = {
		[0] = {},
		[1] = {},
	}
	
	g_commander_abilities = {"paradrops_anti_tank_gun","paradrop_machine_gun","aef_hq_engineer_call_in","paratroopers_paradrop","priest_dispatch","sherman_easy8_dispatch","sherman_bulldozer_dispatch","assault_engineer_dispatch","m10_deploy",--[["siege_240mm_barrage",--]]"elite_vehicle_crews","riflemen_30_caliber_lmg","m21_mortar_halftrack_dispatch",--[["time_on_target_artillery",--]]--[["p47_rocket_attack",--]]"riflemen_defensive_buildings","pathfinders_dispatch","air_drop_combat_group","forward_observers_unlock_2","greyhound_recon_dispatch",--[["artillery_155mm",--]]"recon_sweep","m3_halftrack_group","dodge_wc51_dispatch","withdraw_and_refit","riflemen_flamethrowers","artillery_smoke_barrage","elite_riflemen","riflemen_flares","pathfinders_recon_dispatch","for_mother_russia_ability",--[["il-2_support",--]]--[["fear_propaganda_artillery",--]]--[["il-2_precision_bomb_strike",--]]--[["il-2_recon",--]]"scorched_earth_policy","rapid_conscription","partisan_dispatch","tank_detection_ability","mark_vehicle",--[["il-2_sturmovik_attack",--]]"soviet_hq_engineer_call_in","cmd_is2_heavy_tank","cmd_120mm_mortar_crew","cmd_guard_troops","cmd_isu-152","cmd_katyusha","cmd_penal_battalion","cmd_shock_troops","cmd_radio_intercept","cmd_conscript_evasive_tactics","cmd_t34_85_medium_tank","cmd_vehicle_crew_repair_training","cmd_kv-8_unlock_mp","cmd_at_gun_ambush_tactics_mp","cmd_conscript_repair_kit","cmd_conscript_assault_package","cmd_ml_20",--[["fire_artillery",--]]"army_item_global_cover_training","partisan_dispatch_tow","no_retreat_no_surrender","scorched_earth_policy_mp","commissar_squad_mp","b4_203mm_howitzer","forward_hq","booby_trap","m-42_at_gun","cmd_kv-1_unlock","kv-2","soviet_industry","repair_station","tank_traps","anti-personnel_mines","spy_network","partisans_commander_anti_infantry","partisans_commander_anti_vehicle","anti_tank_grenade_assault","light_anti_vehicle_mines","salvage_kits","manpower_blitz","hold_the_line","conscript_ptrs_upgrade",--[["il-2_anti_tank_bomb_strike",--]]"dshk_mp","cmd_advanced_t34_85_medium_tank",--[["il-2_sturmovik_attack_advanced",--]]"allied_air_supplies","sherman_soviet_dispatch","m5_halftrack_assault",--[["stuka_bombing_strike",--]]--[["stuka_strafing_run",--]]--[["stuka_smoke_bomb",--]]--[["railway_gun_artillery",--]]--[["light_support_artillery",--]]--[["sector_artillery",--]]--[["stuka_fragmentation_bomb",--]]"mortar_halftrack","tiger_tank","panzer_tactician_unlock","pak_43_emplacement_unlock","hull_down_unlock","tank_awareness_unlock","blinding_grenades_unlock","jaeger_infantry_unlock","relief_infantry","fast_march","ambush_camouflage_unlock","armor_commander",--[["stuka_close_air_support",--]]"supply_truck","stuka_air_recon","assault_field_officer","stationary_los_unlock","heavy_at_mine_unlock","german_hq_pioneer_call_in","army_item_global_cover_training","howitzer_105mm_emplacement_unlock","elefant_unlock","ostruppen","redistribute_resources","trench_unlock","assault_grenadiers","air_dropped_medical_supplies","stug_iii_e","mechanized_assault_group","air_dropped_munitions","troop_training","tiger_tank_ace","defensive_fortifications",--[["crush_the_pocket",--]]"breakthrough","stormtroopers",--[["strategic_bombing",--]]"forward_repair_station","urban_assault_grenadiers",--[["stuka_incendiary_bombs",--]]"light_anti_vehicle_mines","munitions_blitz","mortar_incendiary_barrage","supply_break","sprint","command_panther","mechanized_grenadier_group",--[["stuka_aerial_superiority_close_air_support",--]]"stuka_aerial_superiority_recon",--[["stuka_aerial_superiority_strafing_run",--]]"counterattack_tactics","ostruppen_reserves","puma_dispatch","jagdtiger","wg_hq_pioneer_call_in","fallschirmjaeger","panzerfusiliers_dispatch","mg34_dispatch","command_panther","terror_officer","valiant_assault","heavy_fortifications",--[["airborne_assault",--]]--[["assault_artillery",--]]"radio_silence","infiltration_tactics_unlock","flare_artillery","infrared_stg44","breakthrough_tactics","panzer_iv_group_dispatch","signal_flags","vehicle_critical_repair_unlock","through_salvage",--[["howitzer_105mm_offmap_barrage",--]]"ostwind_dispatch","jaeger_light_infantry_recon_dispatch","field_defenses","pak_43_emplacement_unlock",--[["zeroing_artillery",--]]"mortar_halftrack_west_german","advanced_siphon","heat_shells_unlock","tank_commander_unlock","urban_assault_light_infantry"}
	
	Players_ForEach(function(pid, idx, player)
		local team = Player_GetTeam(player)
		table.insert(g_teams[team].players, player)
		g_teams[team].count = g_teams[team].count + 1
		
		Player_SetCommandAvailability(player, g_locked_commands, ITEM_LOCKED)
		for key, race in pairs(ABILITY) do
			for key, ability in pairs(race) do
				local bpName = BP_GetName(ability)
				if not Table_Contains(g_commander_abilities, bpName) then
					Player_SetAbilityAvailability(player, ability, ITEM_LOCKED)
				end
			end
		end
		
		for key, race in pairs(SBP) do
			for key, sbp in pairs(race) do
				local modId = Modify_SquadTypeEnableCapturing(player, sbp, false)
				TreatyMod_RegisterModifier(modId)
			end
		end
	end)
	
	World_ForEachEntities(function(eid, idx, entity)
		if Entity_IsOfType(entity, "strategic_node") then
			local bp = Entity_GetBlueprint(entity)
			
			for key, pointType in pairs(g_territory_points) do
				if (scartype(pointType.blueprint) == ST_TABLE and Table_Contains(pointType.blueprint, bp)) or pointType.blueprint == bp  then
					table.insert(pointType.points, {entity = entity, entityId = Entity_GetGameID(entity), pos = Entity_GetPosition(entity)})
					pointType.count = pointType.count + 1
					Msg("Inserted " .. BP_GetName(bp))
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
						Msg("distance from line: " .. _distance)
					end
					if (_distance > 30) then
						center_offset = 0
					else
						center_offset = World_DistancePointToPoint(point.pos, g_pos_center_relative)
					end
				end
				Msg("center_offset: " .. center_offset)
				local _distances = {distance_0 = Util_DistancePointToTeamShortest(0, point.pos) - center_offset, distance_1 = Util_DistancePointToTeamShortest(1, point.pos) - center_offset, point = point}
				
				table.insert(points, _distances)
			end
			local count_points = table.getn(points)
			if count_points % 2 > 0 then
				count_points = count_points - 1
			end
			for i = 1, count_points do
				local case = Table_GetSmallest(points, "distance_" .. team)
				table.insert(g_team_territories[team], case.point.entity)
				Entity_InstantCaptureStrategicPoint(case.point.entity, g_teams[team].players[1])
				if team == 0 then team = 1 else team = 0 end
				Table_RemoveValue(points, case)
			end
		end
	end
	
	local starting_territory_team_points = World_GetEntitiesByBlueprint(BP_GetEntityBlueprint("starting_territory_team"))
	local starting_positions  = World_GetEntitiesByBlueprint(BP_GetEntityBlueprint("starting_position"))
	
	local function _handleExtraSectorEntities(t)
		for key, entity in ipairs(t) do
			if not World_OwnsEntity(entity) then
				local owner = Entity_GetPlayerOwner(entity)
				local team = Player_GetTeam(owner)
				table.insert(g_team_territories[team], entity)
			end
		end
	end
	
	_handleExtraSectorEntities(starting_territory_team_points)
	_handleExtraSectorEntities(starting_positions)
	
	Rule_Add(TreatyMod_Monitor)
	Util_Delay(1, function()
		TreatyMod_ObjectiveInit()
	end)
	UI_SetCompany(Util_CreateLocString("Ceasefire Active!"), g_icon_company_ceasefire_active, false, 0, 0, 0)

end

function TreatyMod_RegisterModifier(modIds)
	if scartype(modIds) ~= ST_TABLE then
		modIds = {modIds}
	end
	for key, modId in ipairs(modIds) do
		table.insert(g_weapon_modifiers, modId)
	end
end


function Player_GetSquadsOnTeamTerritory(player, team, set_last_pos)
	local sectorEntities = g_team_territories[team]
	
	local squads = {}
	local sg_sector_squads = SGroup_CreateIfNotFound("sg_sector_squads")
	SGroup_Clear(sg_sector_squads)
	for key, sector in ipairs(sectorEntities) do
		local sectorId = World_GetTerritorySectorID(Entity_GetPosition(sector))
		--World_GetSquadsWithinTerritorySector( Player* player, SGroup* sgroup, size_t sectorID, <a href="enum_list.htm#OwnerType">OwnerType</a> ownerType 
		World_GetSquadsWithinTerritorySector(player, sg_sector_squads, sectorId, OT_Player)
		SGroup_ForEach(sg_sector_squads, function(sgid, idx, squad)
			local squadKey = Squad_GetUniqueKey(squad)
			table.insert(squads, squad)
			if Squad_IsEntirelyInPlayerTerritory(Squad_GetPlayerOwner(squad), squad) and set_last_pos then
				g_squad_last_known_pos[squadKey] = {sectorEntity = sector}
			end
		end)
		SGroup_Clear(sg_sector_squads)
	end
	
	return squads
end

function Player_GetSquadsOnFriendyTerritory(player)
	local team = Player_GetTeam(player)
	return Player_GetSquadsOnTeamTerritory(player, team, true)
end

function Player_GetSquadsOnEnemyTerritory(player)
	local team = Team_GetEnemyTeam(Player_GetTeam(player))
	return Player_GetSquadsOnTeamTerritory(player, team)
end

function Player_GetSquadsTable(player)
	local squadList = {}
	local sg_squads = Player_GetSquads(player)
	SGroup_ForEach(sg_squads, function(sgid, idx, squad)
		table.insert(squadList, squad)
	end)
	return squadList
end

function TreatyMod_Monitor()
	if g_treaty_mod_monitor_enabled then
		Players_ForEach(function(pid, idx, player)
			local sg_squads = Player_GetSquads(player)
			local eg_entities = Player_GetEntities(player)
			
			SGroup_ForEach(sg_squads, function(sgid, idx, squad)
				local squadKey = Squad_GetUniqueKey(squad) .. Squad_CountSpawned(squad)
				local bpName = BP_GetName(Squad_GetBlueprint(squad))
				if not g_weapon_modifiers[squadKey] then
					local modIds = Modify_SetSquadAutoTargettingAllHardpoints(squad, false)
					g_weapon_modifiers[squadKey] = true
					TreatyMod_RegisterModifier(modIds)
				end
			end)
			EGroup_ForEach(eg_entities, function(egid, idx, entity)
				local entityKey = Entity_GetUniqueKey(entity)
				if not g_weapon_modifiers[entityKey] then
					local tempEGroup = Entity_GetTempEGroup(entity)
					if Entity_IsOfType(entity, "defence_building") then
						local modIds = Modify_SetEntityAutoTargettingAllHardpoints(entity, false)
						TreatyMod_RegisterModifier(modIds)
						g_weapon_modifiers[entityKey] = true
					else
						g_weapon_modifiers[entityKey] = true
					end
				end
			end)

			local playerSquads = Player_GetSquadsTable(player)
			local sectorSquads = Player_GetSquadsOnFriendyTerritory(player)
			local enemySectorSquads = Player_GetSquadsOnEnemyTerritory(player)
			for key, squad in ipairs(playerSquads) do
				local squadKey = Squad_GetUniqueKey(squad)
				if not Table_Contains(sectorSquads, squad) and Table_Contains(enemySectorSquads, squad) and not Squad_IsPlane(squad) then
					if not g_moved_squad[squadKey] then
						Squad_SetSelectable(squad, false)
						local squadPos = Squad_GetPosition(squad)
						local tempSGroup = Squad_GetTempSGroup(squad)

						if not Player_IsHuman(player) then
							AI_LockSquads(player, Squad_GetTempSGroup(squad))
						end
						
						UI_EnableSquadDecorator(squad, false)
						UI_CreateColouredSquadKickerMessage(player, squad, Util_CreateLocString("Nope!"), Color.yellow())
						g_trespassing_squads[squadKey] = {squad = squad, squadId = Squad_GetGameID(squad), owner = player, squadKey = squadKey, lastMovedTicks = 8, tempSGroup = tempSGroup}
						g_moved_squad[squadKey] = true
					end
				else 
					if g_moved_squad[squadKey] and Squad_IsEntirelyInPlayerTerritory(player, squad) and Table_Contains(sectorSquads, squad) then
						Util_Delay(2 * 8, function()
							Squad_SetSelectable(squad, true)
							UI_EnableSquadDecorator(squad, true)
							Cmd_Stop(Squad_GetTempSGroup(squad))
							if not Player_IsHuman(player) then
								AI_UnlockSquads(player, Squad_GetTempSGroup(squad))
							end
							UI_CreateColouredSquadKickerMessage(player, squad, Util_CreateLocString("Released!"), Color.green())
						end)
						g_moved_squad[squadKey] = nil
						g_trespassing_squads[squadKey] = nil
					end	
				end
			end
		end)
	end
	
	for key, item in pairs(g_trespassing_squads) do
		local delete = false
		if Squad_IsValid(item.squadId) then
			local squad = item.squad
			if item.lastMovedTicks >= 4 then
				item.lastMovedTicks = 0
				local moveToPos = g_squad_last_known_pos[item.squadKey]
				if not moveToPos then
					moveToPos = Player_GetStartingPosition(item.owner)
				else
					moveToPos = Entity_GetPosition(moveToPos.sectorEntity)
				end
				Cmd_Move(item.tempSGroup, moveToPos)
			end
			item.lastMovedTicks = item.lastMovedTicks + 1
		else
			delete = true
		end
		
		if delete then
			g_trespassing_squads[key] = nil
		end
	end
	
	if not g_treaty_mod_monitor_enabled and table.getn(g_trespassing_squads) == 0 then
		Rule_RemoveMe()
	end
end

function Squad_IsEntirelyInPlayerTerritory(player, squad)
	local pass_count = 0
	local count = 0
	Squad_ForEachEntity(squad, function(eid, idx, entity)
		count = count + 1
		local entityPos = Entity_GetPosition(entity)
		if World_IsPointInPlayerTerritory(player, Entity_GetPosition(entity)) then
			pass_count = pass_count + 1
		end
	end)
	if pass_count == count then
		return true
	else
		return false
	end
end

function TreatyMod_SquadCommandIssued(caster, command, target)
	Msg(scartype_tostring(command) .. " = " .. tostring(command))
	for key, value in pairs(_G) do
		if value == command then
			Msg(key)
		end
	end
end

function Msg(text)
	if g_enable_messages then
		g_text_line_count = g_text_line_count + 1
		if g_text_line_count == 100 then
			g_text = ""
			g_text_line_count = 0
		end
		g_text = text.."\n"..g_text
		dr_clear("TREATYMOD")
		dr_setautoclear("TREATYMOD", 0)
		dr_text2d("TREATYMOD", 0.615, 0.025, g_text, 0, 255, 0)
	end
end

function TreatyMod_ObjectiveInit()
	OBJ_Main = {
		Title = Util_CreateLocString("Ceasefire ends in " .. g_treaty_mod_time .. " minutes."), Type = OT_Primary, Intel_Start = nil, Intel_Start_SkipFunc = nil,
		SetupUI = function() 
		end,	
		OnStart = function()
			Objective_StartTimer(OBJ_Main, COUNT_DOWN, g_treaty_mod_time * 60)
			Util_Delay(4, function()
				local newTitle = Util_CreateLocString("Ceasefire ends in ")
				Objective_UpdateText(OBJ_Main, newTitle, newTitle, false)
			end)
			
			Util_Delay(Time_SecondsToTicks(g_treaty_mod_time * 60), function()
				
				local newTitle = Util_CreateLocString("Ceasefire ended!")
				Objective_UpdateText(OBJ_Main, newTitle, newTitle, false)
				Objective_Complete(OBJ_Main, true)
				Util_Delay(2 * 8, function()
					Objective_Show(OBJ_Main, false)
				end)
			end)
		end,	
		Intel_Complete = nil, Intel_Complete_SkipFunc = nil,	
		OnComplete = function()		
			TreatyMod_EndTreaty()
		end,
		Intel_Fail = nil, Intel_Fail_SkipFunc = nil,
		OnFail = function()	
		end,
	}
	Objective_Register(OBJ_Main)
	Util_Delay(1, function()
		Objective_Start(OBJ_Main)
	end)
end

function TreatyMod_EndTreaty()
	UI_ClearCompany()
	g_treaty_mod_monitor_enabled = false
	-- remove modifiers (weapon auto-targetting, capture enable)
	for key, value in ipairs(g_weapon_modifiers) do
		Modifier_Remove(value)
	end
	
	-- unlock all locked commands and abilities
	Players_ForEach(function(pid, idx, player)
		local team = Player_GetTeam(player)

		Player_SetCommandAvailability(player, g_locked_commands, ITEM_DEFAULT)
		for key, race in pairs(ABILITY) do
			for key, ability in pairs(race) do
				local bpName = BP_GetName(ability)
				if not Table_Contains(g_commander_abilities, bpName) then
					Player_SetAbilityAvailability(player, ability, ITEM_DEFAULT)
				end
			end
		end
	end)
end

function TreatyMod_GetIcon(icon)
	return "ModIcons_"..g_guid.."_"..icon	
end
