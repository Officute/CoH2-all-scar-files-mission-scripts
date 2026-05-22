function American_PopulateCity()

	sg_parachute_infantry = SGroup_CreateIfNotFound("sg_parachute_infantry");
	sg_stuart_vehicle = SGroup_CreateIfNotFound("sg_stuart_vehicle");
	sg_reinforce_sherman_tank = SGroup_CreateIfNotFound("sg_reinforce_sherman_tank");
	
	American_InitializeSurrender();
	
end

function American_Support(level)

	local t_upgrades = {BP_GetUpgradeBlueprint("paratrooper_thompson_sub_machine_gun_upgrade_mp"), BP_GetUpgradeBlueprint("paratrooper_m1919a6_lmg_mp")};

	if (level == 1) then -- paratroopers
		
		American_SpawnSquadWithTask(sg_parachute_infantry, BP_GetSquadBlueprint("paratrooper_squad_mp"), nil, true, TC_REINFORCE, t_upgrades);
		American_SpawnSquadWithTask(sg_parachute_infantry, BP_GetSquadBlueprint("paratrooper_squad_mp"), nil, true, TC_REINFORCE, t_upgrades);
		American_SpawnSquadWithTask(sg_parachute_infantry, BP_GetSquadBlueprint("paratrooper_squad_mp"), nil, true, TC_REINFORCE, t_upgrades);
		American_SpawnSquadWithTask(sg_parachute_infantry, BP_GetSquadBlueprint("paratrooper_squad_mp"), nil, true, TC_REINFORCE, t_upgrades);
		
	elseif (level == 2) then -- paratroopers % Stuart tank
		
		American_SpawnSquadWithTask(sg_parachute_infantry, BP_GetSquadBlueprint("paratrooper_squad_mp"), nil, true, TC_REINFORCE, t_upgrades);
		American_SpawnSquadWithTask(sg_parachute_infantry, BP_GetSquadBlueprint("paratrooper_squad_mp"), nil, true, TC_REINFORCE, t_upgrades);
		
		American_SpawnSquadWithTask(sg_stuart_vehicle, BP_GetSquadBlueprint("m5a1_stuart_squad_mp"), nil, true, TC_REINFORCE, nil);
		American_SpawnSquadWithTask(sg_stuart_vehicle, BP_GetSquadBlueprint("m5a1_stuart_squad_mp"), nil, true, TC_REINFORCE, nil);
		
	elseif (level == 3) then -- paratroopers & M4A3 Sherman
		
		American_SpawnSquadWithTask(sg_parachute_infantry, BP_GetSquadBlueprint("paratrooper_squad_mp"), nil, true, TC_REINFORCE, t_upgrades);
		American_SpawnSquadWithTask(sg_parachute_infantry, BP_GetSquadBlueprint("paratrooper_squad_mp"), nil, true, TC_REINFORCE, t_upgrades);
		American_SpawnSquadWithTask(sg_parachute_infantry, BP_GetSquadBlueprint("paratrooper_squad_mp"), nil, true, TC_REINFORCE, t_upgrades);
		American_SpawnSquadWithTask(sg_parachute_infantry, BP_GetSquadBlueprint("paratrooper_squad_mp"), nil, true, TC_REINFORCE, t_upgrades);
		
		American_SpawnSquadWithTask(sg_reinforce_sherman_tank, BP_GetSquadBlueprint("m4a3_sherman_squad_mp"), nil, true, TC_REINFORCE, nil);
		American_SpawnSquadWithTask(sg_reinforce_sherman_tank, BP_GetSquadBlueprint("m4a3_sherman_squad_mp"), nil, true, TC_REINFORCE, nil);
		
	else
		fatal("invalid input");
	end

end

function American_BeginReinforcements()

	local sg_paratroop_reinforcements = SGroup_CreateIfNotFound("sg_paratroop_reinforcements");

	local t_upgrades = {BP_GetUpgradeBlueprint("paratrooper_thompson_sub_machine_gun_upgrade_mp"), BP_GetUpgradeBlueprint("paratrooper_m1919a6_lmg_mp")};
	
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Reinforce Points or Capture Points
	
	if (Util_GetPlayerOwner(eg_city_inner) ~= player4) then
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), eg_city_inner, true, TC_CAPTURE, t_upgrades);
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), eg_city_inner, true, TC_CAPTURE, t_upgrades);
	else
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), Util_GetRandomPosition(EGroup_GetPosition(eg_city_inner), 20), true, TC_MOVE, t_upgrades);
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), Util_GetRandomPosition(EGroup_GetPosition(eg_city_inner), 20), true, TC_MOVE, t_upgrades);
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), Util_GetRandomPosition(EGroup_GetPosition(eg_city_inner), 20), true, TC_MOVE, t_upgrades);
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), Util_GetRandomPosition(EGroup_GetPosition(eg_city_inner), 20), true, TC_MOVE, t_upgrades);
	end
	
	if (Util_GetPlayerOwner(eg_city_outer) ~= player4) then
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), eg_city_outer, true, TC_CAPTURE, t_upgrades);
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), eg_city_outer, true, TC_CAPTURE, t_upgrades);
	else
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), Util_GetRandomPosition(EGroup_GetPosition(eg_city_outer), 20), true, TC_MOVE, t_upgrades);
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), Util_GetRandomPosition(EGroup_GetPosition(eg_city_outer), 20), true, TC_MOVE, t_upgrades);
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), Util_GetRandomPosition(EGroup_GetPosition(eg_city_outer), 20), true, TC_MOVE, t_upgrades);
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), Util_GetRandomPosition(EGroup_GetPosition(eg_city_outer), 20), true, TC_MOVE, t_upgrades);
	end
	
	if (Util_GetPlayerOwner(eg_city_outpost) ~= player4) then
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), eg_city_outpost, true, TC_CAPTURE, t_upgrades);
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), eg_city_outpost, true, TC_CAPTURE, t_upgrades);
	else
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), Util_GetRandomPosition(EGroup_GetPosition(eg_city_outpost), 20), true, TC_MOVE, t_upgrades);
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), Util_GetRandomPosition(EGroup_GetPosition(eg_city_outpost), 20), true, TC_MOVE, t_upgrades);
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), Util_GetRandomPosition(EGroup_GetPosition(eg_city_outpost), 20), true, TC_MOVE, t_upgrades);
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), Util_GetRandomPosition(EGroup_GetPosition(eg_city_outpost), 20), true, TC_MOVE, t_upgrades);
	end
	
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Target Player Squads
	
	local player_squad = Player_GetSquads(player1);
	
	for i=1, SGroup_Count(player_squad) do
		local sgroup = SGroup_FromSquad(SGroup_GetSpawnedSquadAt(player_squad, i));
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), sgroup, true, TC_KILL, t_upgrades);
	end
	
	if (Util_IsCoop() == true) then
		
		player_squad = Player_GetSquads(player2);
		
		for i=1, SGroup_Count(player_squad) do
			local sgroup = SGroup_FromSquad(SGroup_GetSpawnedSquadAt(player_squad, i));
			American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), sgroup, true, TC_KILL, t_upgrades);
		end
		
	end
	
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Garrison city
	
	if (EGroup_IsHoldingAny(eg_city01) == false) then
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), eg_city01, true, TC_GARRISON, t_upgrades);
	end
	
	if (EGroup_IsHoldingAny(eg_city02) == false) then
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), eg_city02, true, TC_GARRISON, t_upgrades);
	end
	
	if (EGroup_IsHoldingAny(eg_city03) == false) then
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), eg_city03, true, TC_GARRISON, t_upgrades);
	end
	
	if (EGroup_IsHoldingAny(eg_city04) == false) then
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), eg_city04, true, TC_GARRISON, t_upgrades);
	end
	
	if (EGroup_IsHoldingAny(eg_city05) == false) then
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), eg_city05, true, TC_GARRISON, t_upgrades);
	end
	
	if (EGroup_IsHoldingAny(eg_city06) == false) then
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), eg_city06, true, TC_GARRISON, t_upgrades);
	end
	
	if (EGroup_IsHoldingAny(eg_city07) == false) then
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), eg_city07, true, TC_GARRISON, t_upgrades);
	end
	
	if (EGroup_IsHoldingAny(eg_city08) == false) then
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), eg_city08, true, TC_GARRISON, t_upgrades);
	end
	
	if (EGroup_IsHoldingAny(eg_city09) == false) then
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), eg_city09, true, TC_GARRISON, t_upgrades);
	end
	
	if (EGroup_IsHoldingAny(eg_city10) == false) then
		American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("paratrooper_squad_mp"), eg_city10, true, TC_GARRISON, t_upgrades);
	end
	
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Tanks - not to many -!
	
	American_SpawnSquadWithTask(sg_paratroop_reinforcements, BP_GetSquadBlueprint("m4a3_sherman_squad_mp"), "patrol_city01", true, TC_PATROL, nil);
	
	Modify_Vulnerability(player_squad, 1.25);
	
end

function American_CheckBridges()
	if (Rule_Exists(American_BridgeDemolition) == false) then
		Rule_AddInterval(American_BridgeDemolition, 60);
	end
end

function American_BridgeDemolition(bridge, sgroup, isReinforcement)

	if (bridge == nil) then return; end
	if (sgroup == nil) then return; end

	if (SGroup_Count(sgroup) == 0 and EGroup_Count(bridge) > 0) then
		
		if (isReinforcement == false) then
		
			American_SpawnSquadWithTask(sgroup, BP_GetSquadBlueprint("assault_engineer_squad_5_man_mp"), EGroup_GetPosition(bridge), false, TC_MOVE, nil);
			American_SpawnSquadWithTask(sgroup, BP_GetSquadBlueprint("ranger_squad_mp"), Util_GetRandomPosition(EGroup_GetPosition(bridge), 15), false, TC_MOVE, nil);
			American_SpawnSquadWithTask(sgroup, BP_GetSquadBlueprint("ranger_squad_mp"), Util_GetRandomPosition(EGroup_GetPosition(bridge), 15), false, TC_MOVE, nil);
			American_SpawnSquadWithTask(sgroup, BP_GetSquadBlueprint("ranger_squad_mp"), Util_GetRandomPosition(EGroup_GetPosition(bridge), 15), false, TC_MOVE, nil);
			
		else
		
			American_SpawnSquadWithTask(sgroup, BP_GetSquadBlueprint("assault_engineer_squad_5_man_mp"), EGroup_GetPosition(bridge), true, TC_MOVE, nil);
			American_SpawnSquadWithTask(sgroup, BP_GetSquadBlueprint("paratrooper_squad_mp"), Util_GetRandomPosition(EGroup_GetPosition(bridge), 15), true, TC_MOVE, nil);
			American_SpawnSquadWithTask(sgroup, BP_GetSquadBlueprint("paratrooper_squad_mp"), Util_GetRandomPosition(EGroup_GetPosition(bridge), 15), true, TC_MOVE, nil);
			American_SpawnSquadWithTask(sgroup, BP_GetSquadBlueprint("paratrooper_squad_mp"), Util_GetRandomPosition(EGroup_GetPosition(bridge), 15), true, TC_MOVE, nil);
			
		end
		
	end

end

TC_DEMOLISH = 0;
TC_MOVE = 1;
TC_CAPTURE = 2;
TC_REINFORCE = 3;
TC_KILL = 4;
TC_GARRISON = 5;
TC_PATROL = 6

function American_SpawnSquadWithTask(SGroup, Blueprint, Target, IsReinforcement, TargetCommand, UpgradeTable)

	local user = player4;
	local sg_temp = SGroup_CreateIfNotFound("sg_tempforamerican");
	
	if (IsReinforcement) then
		user = player5; -- FOR display name purpose and so we can apply other modifiers at another point (if necessary)
	end
	
	local dest = nil;
	
	if (Target == nil) then
		dest = nil;
	elseif (scartype(Target) == ST_EGROUP) then
		dest = mkr_usf_middle_move;
	elseif (scartype(Target) == ST_SGROUP) then
		dest = mkr_usf_middle_move;
	elseif (scartype(Target) == ST_STRING) then
		dest = mkr_usf_middle_move;
	elseif (scartype(Target) == ST_MARKER or scartype(Target) == ST_POSITION) then
		dest = Target;
	end
	
	Util_CreateSquads(user, sg_temp, Blueprint, mkr_american_reinforcement, dest, 1, nil, true, nil, UpgradeTable, nil);
	
	if (TargetCommand == TC_DEMOLISH) then
		--Cmd_SetDemolitions(sg_temp, Target, true, true);
	elseif (TargetCommand == TC_MOVE) then
		Cmd_Move(sg_temp, Target, true);
	elseif (TargetCommand == TC_CAPTURE) then
		Cmd_AttackMoveThenCapture(sg_temp, Target, true); 
	elseif (TargetCommand == TC_REINFORCE) then
		local t_buildings = {eg_city01, eg_city02, eg_city03, eg_city04, eg_city05, eg_city06, eg_city07, eg_city08, eg_city09, eg_city10};
		local t_patrols = {"patrol_city01", "patrol_city02", "patrol_city03", "patrol_wood01", "patrol_wood02"};
		if (SGroup_HasSquadBlueprint(sg_temp, BP_GetSquadBlueprint("paratrooper_squad_mp"), ANY) == true) then
			local rand = World_GetRand(0, 100);
			if (rand >= 75) then
				Cmd_SquadPath(sg_temp, t_patrols[World_GetRand(1, #t_patrols)], true, LOOP_NORMAL, true, 5, nil, true, true);
			else
				Cmd_Garrison(sg_temp, t_buildings[World_GetRand(1, #t_buildings)], true, true, false);
			end
		else
			Cmd_SquadPath(sg_temp, t_patrols[World_GetRand(1, #t_patrols)], true, LOOP_NORMAL, true, 5, nil, true, true);
		end
	elseif (TargetCommand == TC_KILL) then
		Cmd_Attack(sg_temp, Target, true, false, nil);
	elseif (TargetCommand == TC_GARRISON) then
		Cmd_Garrison(sg_temp, Target, true, true, false); 
	elseif (TargetCommand == TC_PATROL) then
		Cmd_SquadPath(sg_temp, Target, true, LOOP_NORMAL, true, 0, nil, true, true);
	end
	
	SGroup_AddGroup(SGroup, sg_temp);
	SGroup_Clear(sg_temp);
	
end

function American_DestonateObject(object)

	local sg_temp = SGroup_CreateIfNotFound("_sg_temp_");

	Player_GetAllSquadsNearMarker(player4, sg_temp, object, 7);
	Player_GetAllSquadsNearMarker(player5, sg_temp, object, 7);	

	if (SGroup_Count(sg_temp) > 0) then
		if (SGroup_ContainsBlueprints(sg_temp, BP_GetSquadBlueprint("assault_engineer_squad_5_man_mp"), ANY) == true) then
			EGroup_Kill(object);
		end
	end
	
	SGroup_Clear(sg_temp);
	
end

function American_InitializeSurrender()

	t_american_surrender = 
	{
		
		{ sgroup = sg_castle_defence, point = eg_city_outpost, surrendered = false },
		{ sgroup = sg_castle_stock_defence, point = eg_city_outpost, surrendered = false },
		{ sgroup = sg_captain01_support, point = sg_captain01, surrendered = false },
		{ sgroup = sg_captain02_support, point = sg_captain02, surrendered = false },
		{ sgroup = sg_top, point = eg_city_outer, surrendered = false },
		
	};

	if (Rule_Exists(American_SurrenderUpdate) == false) then
		Rule_AddInterval(American_SurrenderUpdate, 5);
	end

end

function American_SurrenderUpdate()

	for i=1, #t_american_surrender do

		local location = t_american_surrender[i];
	
		if (t_american_surrender[i].surrendered == false) then
		
			if (scartype(t_american_surrender[i].point) == ST_EGROUP) then
		
				if (Util_GetPlayerOwner(t_american_surrender[i].point) == player1 or Util_GetPlayerOwner(t_american_surrender[i].point) == player2) then
					Util_Surrender(t_american_surrender[i].sgroup, mkr_player_spawner, true, true);
					t_american_surrender[i].surrendered = true;
				end
			
			elseif (scartype(t_american_surrender[i].point) == ST_SGROUP) then
				
				if (SGroup_Count(t_american_surrender[i].point) == 0) then
					Util_Surrender(t_american_surrender[i].sgroup, mkr_player_spawner, true, true);
					t_american_surrender[i].surrendered = true;
				end
				
			end
			
		end
		
	end

end
