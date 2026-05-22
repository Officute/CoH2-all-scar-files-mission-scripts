function German_Initialize()

	sg_german_officer = SGroup_CreateIfNotFound("sg_german_officer");
	sg_execution_units = SGroup_CreateIfNotFound("sg_execution_units");

	Util_SpawnGarrison(player3, eg_bunkers, SGroup_CreateIfNotFound("_SGT"), BP_GetSquadBlueprint("grenadier_squad_mp"), 1);
	Util_SpawnGarrison(player3, eg_mortar_bunkers, SGroup_CreateIfNotFound("_SGT"), BP_GetSquadBlueprint("grenadier_squad_mp"), 1);
	Util_SpawnGarrison(player3, eg_radio_house, SGroup_CreateIfNotFound("_SGT"), BP_GetSquadBlueprint("ostruppen_squad_mp"), 1);
	Util_SpawnGarrison(player3, eg_camphouse, SGroup_CreateIfNotFound("_SGT"), BP_GetSquadBlueprint("grenadier_squad_mp"), 1);
	Util_SpawnGarrison(player3, eg_officer_house, sg_german_officer, BP_GetSquadBlueprint("luftwaffe_officer_squad_tow"), 1);

	sg_axis_convoy = SGroup_CreateIfNotFound("_SGT_CONVOY");
	
	t_roads = { 
		{path = "road1", spawn = mkr_convoy_exit1, exit = mkr_convoy_exit5}, {path = "road2", spawn = mkr_convoy_exit3, exit = mkr_convoy_exit2},
		{path = "road3", spawn = mkr_convoy_exit1, exit = mkr_convoy_exit2}, {path = "road4", spawn = mkr_convoy_exit3, exit = mkr_convoy_exit1}
	};
	t_road = nil;
	t_vehicles = { BP_GetSquadBlueprint("mechanized_250_halftrack_mp"), BP_GetSquadBlueprint("sdkfz_251_halftrack_squad_mp"), BP_GetSquadBlueprint("opel_blitz_supply_squad"), BP_GetSquadBlueprint("scoutcar_sdkfz222_mp") };
	
	sg_panzer1 = SGroup_CreateIfNotFound("sg_panzer1");
	sg_panzer2 = SGroup_CreateIfNotFound("sg_panzer2");
	sg_panzer3 = SGroup_CreateIfNotFound("sg_panzer3");
	sg_panzer4 = SGroup_CreateIfNotFound("sg_panzer4");
	sg_panzer5 = SGroup_CreateIfNotFound("sg_panzer5");
	
	Util_CreateSquads(player3, sg_execution_units, BP_GetSquadBlueprint("grenadier_squad_mp"), mkr_pw5, nil, 2);
	
end

function German_BeginConvoy(time)
	Rule_AddInterval(_ConvoyDo, time);
end

function _ConvoyDo()
	local randvalue = World_GetRand(1, 15);
	if (randvalue <= 7) then
		t_road = t_roads[World_GetRand(1, #t_roads)];
		local sg_temp = SGroup_Temp();
		Util_CreateSquads(player3, sg_temp, t_vehicles[World_GetRand(1, #t_vehicles)], mkr_player_partisan_reinforcement, nil, 1, nil, false, nil, nil, nil);
		Cmd_SquadPath(sg_temp, t_road.path, true, LOOP_NONE, false, 0, t_road.exit, false, true);
		SGroup_AddGroup(sg_axis_convoy, sg_temp);
		SGroup_Clear(sg_temp);
		Rule_AddOneShot(_ConvoyDelay1, 3);
	end
end

function _ConvoyDelay1()
	local sg_temp = SGroup_Temp();
	Util_CreateSquads(player3, sg_temp, t_vehicles[World_GetRand(1, #t_vehicles)], mkr_player_partisan_reinforcement, nil, 1, nil, false, nil, nil, nil);
	Cmd_SquadPath(sg_temp, t_road.path, true, LOOP_NONE, false, 0, t_road.exit, false, true);
	SGroup_AddGroup(sg_axis_convoy, sg_temp);
	SGroup_Clear(sg_temp);
	Rule_AddOneShot(_ConvoyDelay2, 3);
end

function _ConvoyDelay2()
	local sg_temp = SGroup_Temp();
	Util_CreateSquads(player3, sg_temp, t_vehicles[World_GetRand(1, #t_vehicles)], mkr_player_partisan_reinforcement, nil, 1, nil, false, nil, nil, nil);
	Cmd_SquadPath(sg_temp, t_road.path, true, LOOP_NONE, false, 0, t_road.exit, false, true);
	SGroup_AddGroup(sg_axis_convoy, sg_temp);
	SGroup_Clear(sg_temp);
end

function German_BeginPanzer()

	Util_CreateSquads(player4, sg_panzer1, BP_GetSquadBlueprint(t_difficulty.vehicle01), mkr_panzerspawner, nil, 1);
	Util_CreateSquads(player4, sg_panzer2, BP_GetSquadBlueprint(t_difficulty.vehicle02), mkr_panzerspawner, nil, 1);
	Util_CreateSquads(player4, sg_panzer3, BP_GetSquadBlueprint(t_difficulty.vehicle03), mkr_panzerspawner, nil, 1);
	Util_CreateSquads(player4, sg_panzer4, BP_GetSquadBlueprint(t_difficulty.vehicle04), mkr_panzerspawner, nil, 1);
	Util_CreateSquads(player4, sg_panzer5, BP_GetSquadBlueprint(t_difficulty.vehicle05), mkr_panzerspawner, nil, 1);

	Command_PlayerSquadCriticalHit(player2, sg_panzer1, PCMD_CriticalHit, BP_GetCriticalBlueprint("vehicle_damage_engine_rear"), 1, false);
	Command_PlayerSquadCriticalHit(player2, sg_panzer2, PCMD_CriticalHit, BP_GetCriticalBlueprint("vehicle_destroy_engine"), 1, false);
	Command_PlayerSquadCriticalHit(player2, sg_panzer3, PCMD_CriticalHit, BP_GetCriticalBlueprint("vehicle_destroy_maingun"), 1, false);
	Command_PlayerSquadCriticalHit(player2, sg_panzer4, PCMD_CriticalHit, BP_GetCriticalBlueprint("vehicle_damage_engine_rear"), 1, false);
	Command_PlayerSquadCriticalHit(player2, sg_panzer5, PCMD_CriticalHit, BP_GetCriticalBlueprint("vehicle_destroy_maingun"), 1, false);
	
	Cmd_SquadPath(sg_panzer1, "panzers", true, LOOP_NONE, false, 0, nil, false, true);
	Cmd_SquadPath(sg_panzer2, "panzers", true, LOOP_NONE, false, 0, nil, false, true);
	Cmd_SquadPath(sg_panzer3, "panzers", true, LOOP_NONE, false, 0, nil, false, true);
	Cmd_SquadPath(sg_panzer4, "panzers", true, LOOP_NONE, false, 0, nil, false, true);
	Cmd_SquadPath(sg_panzer5, "panzers", true, LOOP_NONE, false, 0, nil, false, true);
	
	Event_Proximity(German_PanzerGoToPositions, nil, player4, mkr_panzercheck, 5, ANY, 0);

end

function German_PanzerGoToPositions()

	Cmd_Stop(sg_panzer1);
	Cmd_Stop(sg_panzer2);
	Cmd_Stop(sg_panzer3);
	Cmd_Stop(sg_panzer4);
	Cmd_Stop(sg_panzer5);

	Cmd_Move(sg_panzer1, mkr_pw1);
	Cmd_Move(sg_panzer2, mkr_pw2);
	Cmd_Move(sg_panzer3, mkr_pw3);
	Cmd_Move(sg_panzer4, mkr_pw4);
	Cmd_Move(sg_panzer5, mkr_pw5);
	
end
