function OnGameSetup()
	player1 = World_GetPlayerAt(1);
	player2 = World_GetPlayerAt(2);
	player3 = World_GetPlayerAt(3);
	player4 = World_GetPlayerAt(4);
	Setup_SetPlayerName(player2, "$08a0ac9c7e6144909909a02d533ce8aa:243");
	Setup_SetPlayerName(player3, "$08a0ac9c7e6144909909a02d533ce8aa:244");
	Setup_SetPlayerName(player4, "$08a0ac9c7e6144909909a02d533ce8aa:244");
end

function OnGameRestore()
	player1 = World_GetPlayerAt(1);
	player2 = World_GetPlayerAt(2);
	player3 = World_GetPlayerAt(3);
	player4 = World_GetPlayerAt(4);
	Game_DefaultGameRestore();
end

function Mission_Init()

	Mission_Objectives();
	Mission_Difficulty();
	Mission_Restrictions();
	
	Mission_ExtraUI();

	Civilian_Initialize();
	German_Initialize();
	--Time_Initialize();
	
	AI_EnableAll(false);
	
	Rule_AddOneShot(Mission_DelayIntel, 0.65);
	
end

Scar_AddInit(Mission_Init);

function Mission_DelayIntel()
	Util_StartIntel(EVENTS.INTRO);
end

function Mission_Restrictions()

	Cmd_InstantUpgrade(player1, BP_GetUpgradeBlueprint("hq_molotov_grenade_mp"), 1);

end

function Mission_Objectives()

	OBJ_HQ = {
	
		SetupUI = function() 
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:229",
		Description = 0,
		Type = OT_Primary,
	}

	OBJ_Civilian = {
	
		SetupUI = function() 
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:230",
		Description = 0,
		Type = OT_Primary,
	}
	
	OBJ_EXECUTIONS = {
		Parent = OBJ_Civilian,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:231",
		Description = 0,
		Type = OT_Secondary,
	}

	OBJ_PRISONERS = {
		Parent = OBJ_Civilian,
		SetupUI = function()
			Objective_AddUIElements(OBJ_PRISONERS, mkr_gatedemolish, true, "$08a0ac9c7e6144909909a02d533ce8aa:268", true, 2.7, nil, nil, nil);
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:232",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_SEARCHANDDESTROY = {
	
		SetupUI = function() 
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:233",
		Description = 0,
		Type = OT_Primary,
	}

	OBJ_RADIO = {
		Parent = OBJ_SEARCHANDDESTROY,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:234",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_CAMP = {
		Parent = OBJ_SEARCHANDDESTROY,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:235",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_CAPRADIO = {
		Parent = OBJ_SEARCHANDDESTROY,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:236",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_KILLOFFICER = {
		Parent = OBJ_SEARCHANDDESTROY,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:237",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_AMBUSH = {
		Parent = OBJ_SEARCHANDDESTROY,
		SetupUI = function()
			Objective_AddUIElements(OBJ_AMBUSH, eg_cap_radio, true, "$08a0ac9c7e6144909909a02d533ce8aa:261", true, 1.7, nil, nil, nil);
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:238",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_PANZERDESTROY = {
		Parent = OBJ_PANZERBREAKDOWN,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:240",
		Description = 0,
		Type = OT_Secondary,
	}
	
	Objective_Register(OBJ_HQ);
	
	Objective_Register(OBJ_Civilian);
	Objective_Register(OBJ_EXECUTIONS);
	Objective_Register(OBJ_PRISONERS);
	
	Objective_Register(OBJ_SEARCHANDDESTROY);
	Objective_Register(OBJ_RADIO);
	Objective_Register(OBJ_CAMP);
	Objective_Register(OBJ_CAPRADIO);
	Objective_Register(OBJ_KILLOFFICER);
	
	Objective_Register(OBJ_AMBUSH);
	Objective_Register(OBJ_PANZERDESTROY);
	
end

function Mission_Difficulty()

	g_diff = Game_GetSPDifficulty();
	t_difficulty = {};
	
	if (g_diff == GD_EASY) then
		
		t_difficulty.vuln = 0.75;
		
		t_difficulty.vehicle01 = "stug_iii_e_squad_mp";
		t_difficulty.vehicle02 = "stug_iii_e_squad_mp";
		t_difficulty.vehicle03 = "panzer_iv_stubby_squad_mp";
		t_difficulty.vehicle04 = "stug_iii_e_squad_mp";
		t_difficulty.vehicle05 = "stug_iii_e_squad_mp";
		
		t_difficulty.maxex = 4;
		
	elseif (g_diff == GD_NORMAL) then
		
		t_difficulty.vuln = 0.5;
		
		t_difficulty.vehicle01 = "stug_iii_e_squad_mp";
		t_difficulty.vehicle02 = "stug_iii_e_squad_mp";
		t_difficulty.vehicle03 = "stug_iii_e_squad_mp";
		t_difficulty.vehicle04 = "panzer_iv_stubby_squad_mp";
		t_difficulty.vehicle05 = "panzer_iv_squad_mp";
		
		t_difficulty.maxex = 3;
		
	elseif (g_diff == GD_HARD) then
		
		t_difficulty.vuln = 0.12;
		
		t_difficulty.vehicle01 = "stug_iii_e_squad_mp";
		t_difficulty.vehicle02 = "panzer_iv_stubby_squad_mp";
		t_difficulty.vehicle03 = "panzer_iv_squad_mp";
		t_difficulty.vehicle04 = "panzer_iv_squad_mp";
		t_difficulty.vehicle05 = "stug_iii_e_squad_mp";
		
		t_difficulty.maxex = 2;
		
	end

end

function Mission_ApplySquadModifiers(sgroup)
	Modify_Vulnerability(sgroup, t_difficulty.vuln);
end

function Mission_BeginObjectives()

	UI_SetCPMeterVisibility(false);

	Objective_Start(OBJ_HQ, false);
	Objective_Start(OBJ_SEARCHANDDESTROY, true);
	Objective_Start(OBJ_RADIO, false);
	Objective_Start(OBJ_CAMP, false);
	
	Cmd_InstantSetupTeamWeapon(sg_autosetup, false);
	Command_PlayerSquadCriticalHit(player2, sg_decrew, PCMD_CriticalHit, BP_GetCriticalBlueprint("vehicle_abandon"), 1, false);
	
	Event_Proximity(Mission_LostUnits, nil, player1, mkr_PlayerPartisanReinforcements, 20, ANY, 2);
	Event_Proximity(Mission_RadioProx, nil, player1, mkr_radio_location_trigger, 50, ANY, 5);
	Event_Proximity(Mission_CampProx, nil, player1, mkr_german_camp_location_trigger, 80, ANY, 5);
	
	Mission_ApplySquadModifiers(Player_GetSquads(player1));
	Rule_AddInterval(Mission_SquadsDown, 5);
	Rule_AddOneShot(Mission_DelayedCivilianMission, 90);
	
end

function Mission_DelayedCivilianMission()

	Objective_Start(OBJ_Civilian, false);
	Objective_Start(OBJ_EXECUTIONS, true);
	Objective_Start(OBJ_PRISONERS, true);

	German_BeginConvoy(4 * 60);
	
end

function Mission_LostUnits()

	Util_CreateSquads(player1, SGroup_CreateIfNotFound("_SGT"), BP_GetSquadBlueprint("conscript_squad_mp"), mkr_player_partisan_reinforcement, mkr_player_partisan_moveto, 1, nil, false, nil, nil, nil);
	Util_StartIntel(EVENTS.CIVILIAN_INTRO);

end

function Mission_RadioProx()

	Objective_Complete(OBJ_RADIO, true);
	Objective_Start(OBJ_CAPRADIO, true);
	
	Util_StartIntel(EVENTS.RADIOFOUND);
	
	Rule_AddInterval(Mission_HasCapturedRadio, 5);
	
	if (Rule_Exists(Mission_LastCheck) == false) then
		Rule_AddInterval(Mission_LastCheck, 10);
	end
	
end

function Mission_HasCapturedRadio()

	if (EGroup_IsCapturedByPlayer(eg_cap_radio, player1, ANY)) then
		
		Util_StartIntel(EVENTS.CAMPCAPTURED);
		
		EGroup_SetPlayerOwner(eg_player3_radio_heal_station, player1);
		
		Objective_Complete(OBJ_CAPRADIO, true);
		Rule_RemoveMe();
		
	end

end

function Mission_CampProx()

	Objective_Complete(OBJ_CAMP, true);
	Objective_Start(OBJ_KILLOFFICER, true);
	
	Cmd_UngarrisonSquad(sg_german_officer, nil, false) 
	Cmd_SquadPath(sg_german_officer, "officer_route", true, LOOP_NORMAL, false, 1, nil, true, true);
	Cmd_SquadPath(sg_officer_guard01, "officer_route", true, LOOP_TOGGLE_DIRECTION, false, 1, nil, true, true);
	Cmd_SquadPath(sg_officer_guard02, "officer_route", true, LOOP_TOGGLE_DIRECTION, false, 1, nil, true, false);	
	
	Util_StartIntel(EVENTS.CAMPFOUND);
	
	Rule_AddInterval(Mission_OfficerDown, 4);
	
	if (Rule_Exists(Mission_LastCheck) == false) then
		Rule_AddInterval(Mission_LastCheck, 10);
	end
	
end

function Mission_OfficerDown()

	if (SGroup_Count(sg_german_officer) == 0) then
		
		Util_StartIntel(EVENTS.OFFICERKILLED);
		Objective_Complete(OBJ_KILLOFFICER, true);
		Rule_RemoveMe();
		
	end

end

function Mission_LastCheck()

	if (Objective_IsComplete(OBJ_CAPRADIO) == true and Objective_IsComplete(OBJ_KILLOFFICER) == true) then
		
		Util_StartIntel(EVENTS.AMBUSHWARNING);
		
		Rule_RemoveMe();
		
	end

end

function Mission_AmbushBegin()

	sg_convoy_truck01 = SGroup_CreateIfNotFound("sg_convoy_truck01");
	sg_convoy_truck02 = SGroup_CreateIfNotFound("sg_convoy_truck02");
	sg_convoy_truck03 = SGroup_CreateIfNotFound("sg_convoy_truck03");
	sg_convoy_unit01 = SGroup_CreateIfNotFound("sg_convoy_unit01");
	sg_convoy_unit02 = SGroup_CreateIfNotFound("sg_convoy_unit02");
	sg_convoy_unit03 = SGroup_CreateIfNotFound("sg_convoy_unit03");
	sg_convoy_unit04 = SGroup_CreateIfNotFound("sg_convoy_unit04");
	sg_convoy_unit05 = SGroup_CreateIfNotFound("sg_convoy_unit05");
	sg_convoy_unit06 = SGroup_CreateIfNotFound("sg_convoy_unit06");
	
	Util_CreateSquads(player3, sg_convoy_truck01, BP_GetSquadBlueprint("sdkfz_251_halftrack_squad_mp"), mkr_convoy_exit3, nil, 1);
	Util_CreateSquads(player3, sg_convoy_truck02, BP_GetSquadBlueprint("sdkfz_251_halftrack_squad_mp"), mkr_convoy_exit3, nil, 1);
	Util_CreateSquads(player3, sg_convoy_truck03, BP_GetSquadBlueprint("sdkfz_251_halftrack_squad_mp"), mkr_convoy_exit3, nil, 1);
	
	Util_CreateSquads(player3, sg_convoy_unit01, BP_GetSquadBlueprint("stormtrooper_squad_mp"), sg_convoy_truck01, nil, 1);
	Util_CreateSquads(player3, sg_convoy_unit02, BP_GetSquadBlueprint("stormtrooper_squad_mp"), sg_convoy_truck01, nil, 1);
	
	Util_CreateSquads(player3, sg_convoy_unit03, BP_GetSquadBlueprint("stormtrooper_squad_mp"), sg_convoy_truck02, nil, 1);
	Util_CreateSquads(player3, sg_convoy_unit04, BP_GetSquadBlueprint("pioneer_squad_mp"), sg_convoy_truck02, nil, 1);
	
	Util_CreateSquads(player3, sg_convoy_unit05, BP_GetSquadBlueprint("pioneer_squad_mp"), sg_convoy_truck03, nil, 1);
	Util_CreateSquads(player3, sg_convoy_unit06, BP_GetSquadBlueprint("ostruppen_squad_mp"), sg_convoy_truck03, nil, 1);
	
	Cmd_SquadPath(sg_convoy_truck01, "convoy_fixed", true, LOOP_NONE, false, 0, nil, false, true);
	Cmd_SquadPath(sg_convoy_truck02, "convoy_fixed", true, LOOP_NONE, false, 0, nil, false, true);
	Cmd_SquadPath(sg_convoy_truck03, "convoy_fixed", true, LOOP_NONE, false, 0, nil, false, true);
	
	Event_Proximity(Mission_StopTruck1, nil, sg_convoy_truck01, mkr_truckstop1, 5, ANY, 0);
	Event_Proximity(Mission_StopTruck2, nil, sg_convoy_truck02, mkr_truckstop2, 5, ANY, 0);
	Event_Proximity(Mission_StopTruck3, nil, sg_convoy_truck03, mkr_truckstop3, 5, ANY, 0);
	
	Rule_AddInterval(Mission_AmbushFirstEnd, 5);
	
end

function Mission_StopTruck1()
	Cmd_Stop(sg_convoy_truck01);
	Util_StartIntel(EVENTS.GERMAN1);
	Cmd_UngarrisonSquad(sg_convoy_unit01, mkr_enemy_ambush01, false);
	Cmd_UngarrisonSquad(sg_convoy_unit02, mkr_enemy_ambush02, false); 
end

function Mission_StopTruck2()
	Cmd_Stop(sg_convoy_truck02);
	Util_StartIntel(EVENTS.GERMAN2);
	Cmd_UngarrisonSquad(sg_convoy_unit04, mkr_enemy_ambush03, false);
end

function Mission_StopTruck3()
	Cmd_Stop(sg_convoy_truck03);
	Cmd_UngarrisonSquad(sg_convoy_unit06, mkr_enemy_ambush04, false); 
end

function Mission_AmbushFirstEnd()
	
	if (SGroup_Count(sg_convoy_unit01) == 0 and SGroup_Count(sg_convoy_unit02) == 0 and SGroup_Count(sg_convoy_unit04) == 0) then
	
		Cmd_SquadPath(sg_convoy_truck01, "convoy_moveup", true, LOOP_NONE, false, 0, nil, false, true);
		Cmd_SquadPath(sg_convoy_truck02, "convoy_moveup", true, LOOP_NONE, false, 0, nil, false, true);
		Cmd_SquadPath(sg_convoy_truck03, "convoy_moveup", true, LOOP_NONE, false, 0, nil, false, true);
	
		Event_Proximity(Mission_StopTruck12, nil, sg_convoy_truck01, mkr_truckstop1, 1, ANY, 0);
		Event_Proximity(Mission_StopTruck22, nil, sg_convoy_truck02, mkr_truckstop2, 10, ANY, 0);
		Event_Proximity(Mission_StopTruck32, nil, sg_convoy_truck03, mkr_truckstop3, 15, ANY, 0);
	
		Rule_AddInterval(Mission_AmbushOver, 5);
	
		Rule_RemoveMe();
	
	end
	
end

function Mission_StopTruck12()
	Cmd_Stop(sg_convoy_truck01);
	Util_StartIntel(EVENTS.GERMAN3);
end

function Mission_StopTruck22()
	Cmd_Stop(sg_convoy_truck02);
	Cmd_UngarrisonSquad(sg_convoy_unit06, mkr_cam2, false); 
end

function Mission_StopTruck32()
	Cmd_Stop(sg_convoy_truck03);
	Cmd_UngarrisonSquad(sg_convoy_unit06, mkr_cam2, false);
end

function Mission_AmbushOver()

	if (SGroup_Count(sg_convoy_truck01) == 0 and SGroup_Count(sg_convoy_truck02) == 0 and SGroup_Count(sg_convoy_truck03) == 0) then
		
		Objective_Complete(OBJ_AMBUSH, true);
		Util_StartIntel(EVENTS.PANZERTANKS);
		
		German_BeginPanzer();
		Objective_Start(OBJ_PANZERDESTROY, true);
		
		Rule_AddInterval(Mission_PanzerDown, 5);
		
		Rule_RemoveMe();
		
	end

end

function Mission_PanzerDown()

	if (SGroup_Count(sg_panzer1) == 0 and SGroup_Count(sg_panzer2) == 0 and SGroup_Count(sg_panzer3) == 0 and SGroup_Count(sg_panzer4) == 0 and SGroup_Count(sg_panzer5) == 0) then
		
		Objective_Complete(OBJ_PANZERDESTROY, true);
		Codiex_EndGame(Player_GetRaceName(player1), true);
		Rule_RemoveMe();
		
	end

end

function Mission_SquadsDown()

	if (Player_GetSquadCount(player1) == 0) then
		Codiex_EndGame(Player_GetRaceName(player1), false);
	end

end
