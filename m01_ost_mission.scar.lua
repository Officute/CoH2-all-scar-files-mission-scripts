function Mission_SpawnPakGuns()

	local sg_temp = SGroup_CreateIfNotFound("sg_temp");

	Util_CreateSquads(player1, sg_temp, BP_GetSquadBlueprint("pak43_88mm_at_gun_squad_mp"), mkr_pak43_spawn01, nil, 1, nil, false, mkr_pak43_spawn01_01, nil, nil);
	Util_CreateSquads(player2, sg_temp, BP_GetSquadBlueprint("pak43_88mm_at_gun_squad_mp"), mkr_pak43_spawn02, nil, 1, nil, false, mkr_pak43_spawn02_02, nil, nil);
	Util_CreateSquads(player1, sg_temp, BP_GetSquadBlueprint("pak43_88mm_at_gun_squad_mp"), mkr_pak43_spawn03, nil, 1, nil, false, mkr_pak43_spawn03_03, nil, nil);

	SGroup_Clear(sg_temp);
	
end

function Mission_BeginIntel()
	
	UI_SetCPMeterVisibility(false);
	
	Util_StartIntel(EVENTS.INTRO);
	Rule_Add(Mission_Begin);
	
	German_MoveIntoDefence();
	German_CallInReinforcements();
	
end

function Mission_Difficulty()

	g_diff = nil;
	
	if (Util_IsCoop() == false) then
		g_diff = Game_GetSPDifficulty();		
	else
		g_diff = GD_NORMAL;
	end
	
	t_difficulty = {};
	
	if (g_diff == GD_EASY) then
		
		t_difficulty.unitclass = {};
		t_difficulty.unitclass["Partisans"] = 8;
		t_difficulty.unitclass["Volks"] = 10;
		t_difficulty.unitclass["Grenadiers"] = 8;
		t_difficulty.unitclass["PGrens"] = 6;
		t_difficulty.unitclass["PZ4"] = 6;
		t_difficulty.unitclass["PZ5"] = 5;
		t_difficulty.unitclass["Tiger"] = 3;
		t_difficulty.unitclass["KT"] = 2;
		
		t_difficulty.resourceaward = 100;
		
		t_difficulty.maxbreak = 20;
		t_difficulty.commissar_increment = 1;
		t_difficulty.commissar_fear = 5;
		t_difficulty.commissar_fear_level = 75;
		t_difficulty.special_increment = 1;
		t_difficulty.airstrafelevel = DEMAND_HIGH;
		
	elseif (g_diff == GD_NORMAL) then
		
		t_difficulty.unitclass = {};
		t_difficulty.unitclass["Partisans"] = 7;
		t_difficulty.unitclass["Volks"] = 9;
		t_difficulty.unitclass["Grenadiers"] = 7;
		t_difficulty.unitclass["PGrens"] = 5;
		t_difficulty.unitclass["PZ4"] = 5;
		t_difficulty.unitclass["PZ5"] = 4;
		t_difficulty.unitclass["Tiger"] = 2;
		t_difficulty.unitclass["KT"] = 2;
		
		t_difficulty.resourceaward = 50;
		
		t_difficulty.maxbreak = 10;
		t_difficulty.commissar_increment = 2;
		t_difficulty.commissar_fear = 10;
		t_difficulty.commissar_fear_level = 65;
		t_difficulty.special_increment = 2;
		t_difficulty.airstrafelevel = DEMAND_HIGH - 15;
		
	elseif (g_diff == GD_HARD) then
		
		t_difficulty.unitclass = {};
		t_difficulty.unitclass["Partisans"] = 6;
		t_difficulty.unitclass["Volks"] = 8;
		t_difficulty.unitclass["Grenadiers"] = 6;
		t_difficulty.unitclass["PGrens"] = 4;
		t_difficulty.unitclass["PZ4"] = 4;
		t_difficulty.unitclass["PZ5"] = 3;
		t_difficulty.unitclass["Tiger"] = 2;
		t_difficulty.unitclass["KT"] = 1;
		
		t_difficulty.resourceaward = 25;
		
		t_difficulty.maxbreak = 6;
		t_difficulty.commissar_increment = 5;
		t_difficulty.commissar_fear = 15;
		t_difficulty.commissar_fear_level = 45;
		t_difficulty.special_increment = 3;
		t_difficulty.airstrafelevel = DEMAND_MEDIUM - 5;
		
	end

end

function Mission_Restrictions()

	Player_AddUnspentCommandPoints(player1, 16);
	
	Player_AddUnspentCommandPoints(player2, 16);

	Cmd_InstantUpgrade(eg_command_bunker, BP_GetUpgradeBlueprint("bunker_command_mp"), 1);

	Cmd_InstantUpgrade(player1, BP_GetUpgradeBlueprint("battle_phase_2_mp"), 1);
	Cmd_InstantUpgrade(player1, BP_GetUpgradeBlueprint("battle_phase_3_mp"), 1);
	Cmd_InstantUpgrade(player1, BP_GetUpgradeBlueprint("battle_phase_4_mp"), 1);
	Cmd_InstantUpgrade(player1, BP_GetUpgradeBlueprint("heavy_fortifications"), 1);
	Cmd_InstantUpgrade(player1, BP_GetUpgradeBlueprint("defensive_fortifications"), 1);
	
	Cmd_InstantUpgrade(player2, BP_GetUpgradeBlueprint("battle_phase_2_mp"), 1);
	Cmd_InstantUpgrade(player2, BP_GetUpgradeBlueprint("battle_phase_3_mp"), 1);
	Cmd_InstantUpgrade(player2, BP_GetUpgradeBlueprint("battle_phase_4_mp"), 1);
	Cmd_InstantUpgrade(player2, BP_GetUpgradeBlueprint("heavy_fortifications"), 1);
	Cmd_InstantUpgrade(player2, BP_GetUpgradeBlueprint("defensive_fortifications"), 1);
	
	Modify_PlayerResourceRate(player1, RT_Manpower, 0, MUT_Multiplication);
	Modify_PlayerResourceRate(player1, RT_Fuel, 0, MUT_Multiplication);
	Modify_PlayerResourceRate(player1, RT_Munition, 0.6, MUT_Multiplication);
	
	Modify_PlayerResourceRate(player2, RT_Manpower, 0, MUT_Multiplication);
	Modify_PlayerResourceRate(player2, RT_Fuel, 0, MUT_Multiplication);
	Modify_PlayerResourceRate(player2, RT_Munition, 0.6, MUT_Multiplication);
	
	Player_SetResource(player1, RT_Manpower, 1000);
	Player_SetResource(player1, RT_Fuel, 0);
	Player_SetResource(player1, RT_Munition, 250);
	
	Player_SetResource(player2, RT_Manpower, 1000);
	Player_SetResource(player2, RT_Fuel, 0);
	Player_SetResource(player2, RT_Munition, 250);
	
	Player_SetPopCapOverride(player1, 260);
	
	Player_SetPopCapOverride(player2, 260);
	
	Player_SetUpgradeAvailability(player1, BP_GetUpgradeBlueprint("grenadier_mg42_lmg_mp"), ITEM_REMOVED);
	Player_SetUpgradeAvailability(player1, BP_GetUpgradeBlueprint("panzer_grenadier_panzershreck_atw_item_mp"), ITEM_REMOVED);
	Player_SetUpgradeAvailability(player1, BP_GetUpgradeBlueprint("panzerbusche_39_mp"), ITEM_REMOVED);
	Player_SetUpgradeAvailability(player1, BP_GetUpgradeBlueprint("stormtrooper_assault_package_mp"), ITEM_REMOVED);
	Player_SetUpgradeAvailability(player1, BP_GetUpgradeBlueprint("light_infantry_package"), ITEM_REMOVED);
	Player_SetUpgradeAvailability(player1, BP_GetUpgradeBlueprint("waffen_mg34_lmg_mp"), ITEM_REMOVED);
	Player_SetUpgradeAvailability(player1, BP_GetUpgradeBlueprint("panzer_top_gunner_mp"), ITEM_REMOVED);
	Player_SetUpgradeAvailability(player1, BP_GetUpgradeBlueprint("panther_top_gunner_mp"), ITEM_REMOVED);
	Player_SetUpgradeAvailability(player1, BP_GetUpgradeBlueprint("tiger_top_gunner_mp"), ITEM_REMOVED);
	Player_SetUpgradeAvailability(player1, BP_GetUpgradeBlueprint("king_tiger_top_gunner_mp"), ITEM_REMOVED);
	Player_SetUpgradeAvailability(player1, BP_GetUpgradeBlueprint("assault_pioneer_panzerschreck_upgrade"), ITEM_REMOVED);
	
	Player_SetUpgradeAvailability(player2, BP_GetUpgradeBlueprint("grenadier_mg42_lmg_mp"), ITEM_REMOVED);
	Player_SetUpgradeAvailability(player2, BP_GetUpgradeBlueprint("panzer_grenadier_panzershreck_atw_item_mp"), ITEM_REMOVED);
	Player_SetUpgradeAvailability(player2, BP_GetUpgradeBlueprint("panzerbusche_39_mp"), ITEM_REMOVED);
	Player_SetUpgradeAvailability(player2, BP_GetUpgradeBlueprint("stormtrooper_assault_package_mp"), ITEM_REMOVED);
	Player_SetUpgradeAvailability(player2, BP_GetUpgradeBlueprint("light_infantry_package"), ITEM_REMOVED);
	Player_SetUpgradeAvailability(player2, BP_GetUpgradeBlueprint("waffen_mg34_lmg_mp"), ITEM_REMOVED);
	Player_SetUpgradeAvailability(player2, BP_GetUpgradeBlueprint("panzer_top_gunner_mp"), ITEM_REMOVED);
	Player_SetUpgradeAvailability(player2, BP_GetUpgradeBlueprint("panther_top_gunner_mp"), ITEM_REMOVED);
	Player_SetUpgradeAvailability(player2, BP_GetUpgradeBlueprint("tiger_top_gunner_mp"), ITEM_REMOVED);
	Player_SetUpgradeAvailability(player2, BP_GetUpgradeBlueprint("king_tiger_top_gunner_mp"), ITEM_REMOVED);
	Player_SetUpgradeAvailability(player2, BP_GetUpgradeBlueprint("assault_pioneer_panzerschreck_upgrade"), ITEM_REMOVED);
	
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("grenadier_panzerfaust_mp"), ITEM_REMOVED);
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("volksgrenadier_grenade_mp"), ITEM_REMOVED);
	
	Player_SetAbilityAvailability(player2, BP_GetAbilityBlueprint("grenadier_panzerfaust_mp"), ITEM_REMOVED); 
	Player_SetAbilityAvailability(player2, BP_GetAbilityBlueprint("volksgrenadier_grenade_mp"), ITEM_REMOVED);
	
	Player_SetConstructionMenuAvailability(player1, "tp_construction_german_pioneer_advanced", ITEM_REMOVED);
	
	Player_SetConstructionMenuAvailability(player2, "tp_construction_german_pioneer_advanced", ITEM_REMOVED); 
	
end

function Mission_Objectives()

	OBJ_MAIN = {
	
		SetupUI = function() 
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
			Rule_AdDOneShot(m_lose, 5);
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:93",
		Description = 0,
		Type = OT_Primary,
	}

	OBJ_LINE = {
		Parent = OBJ_MAIN,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:138",
		Description = 0,
		Type = OT_Secondary,
	}

	OBJ_LAST = {
		Parent = OBJ_MAIN,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:137",
		Description = 0,
		Type = OT_Secondary,
	}

	OBJ_TRAIN = {
		Parent = nil,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:159",
		Description = 0,
		Type = OT_Secondary,
	}
	
	Objective_Register(OBJ_MAIN);
	Objective_Register(OBJ_LINE);
	Objective_Register(OBJ_LAST);
	
	Objective_Register(OBJ_TRAIN);
	
end

function Mission_IsPlayerDead()

	local total = SGroup_Count(Player_GetSquads(player1)) + SGroup_Count(Player_GetSquads(player2));

	if (total == 0) then
		Mission_Win(g_last_man);
	end

end

function Mission_BrokenLines()
	
	if (EGroup_IsCapturedByPlayer(eg_munition_point, soviet1, ANY) == true or EGroup_Count(eg_command_bunker) == 0) then
		Mission_Win(g_line_fail);
	end
	
end

function Mission_Begin()

	if (Event_IsAnyRunning() == false) then
		
		Objective_Start(OBJ_MAIN, false);
		Objective_Start(OBJ_LINE, true);
		Objective_Start(OBJ_LAST, true);
		
		Berlin_TimeBegin();
		
		Rule_AddInterval(German_Update, 15);
		
		Rule_AddOneShot(Mission_KickOff, 3 * 60);
		Rule_AddInterval(Mission_IsPlayerDead, 4);
		Rule_AddInterval(Mission_CheckLines, 5);
		Rule_AddInterval(Mission_BrokenLines, 6);
		Rule_RemoveMe();
		
	end

end

function Mission_Win(reason) -- you can only win this mission
	if (reason == g_last_man) then -- start intel with last man before we win
		Objective_Complete(OBJ_LAST, true);
		Util_StartIntel(EVENTS.LASTMANVIC);
	elseif (reason == g_line_fail) then -- start intel with last line
		Objective_Complete(OBJ_LINE, true);
		Util_StartIntel(EVENTS.LINEBROKEN);
	else -- just give a normal victory
		Game_EndSP(false); -- player somehow managed to achieve victory - but it wasn't legal
	end
	Rule_RemoveAll();
end

function Mission_KickOff()

	HintPoint_Add(mkr_ui_warning01, true, "$08a0ac9c7e6144909909a02d533ce8aa:161", 2.5, HPAT_Objective);
	HintPoint_Add(mkr_ui_warning02, true, "$08a0ac9c7e6144909909a02d533ce8aa:161", 2.5, HPAT_Objective);
	HintPoint_Add(mkr_ui_warning03, true, "$08a0ac9c7e6144909909a02d533ce8aa:161", 2.5, HPAT_Objective);

	Soviet_DoBarrage();
	Soviet_DoFlares();
	Soviet_EnableLights();
	
	Soviet_ClearMines();
	
	AI_Enable(soviet2, true);
	
	Rule_AddOneShot(Soviet_BeginAttacks, 2 * 60);
	
end

function Mission_DoTrainStation()

	Objective_Start(OBJ_TRAIN, true);
	UI_CreateMinimapBlip(mkr_ui_warning04, 10, BT_General); 
	HintPoint_Add(mkr_ui_warning04, true, "$08a0ac9c7e6144909909a02d533ce8aa:161", 2.5, HPAT_Objective);
	
end

function Mission_CheckLines()

	local sg_playercheck = Player_GetSquads(soviet1);
	SGroup_RemoveGroup(sg_playercheck, sg_katyusha_north);
	SGroup_RemoveGroup(sg_playercheck, sg_katyusha_south);
	SGroup_RemoveGroup(sg_playercheck, sg_katyusha_center);
	SGroup_RemoveGroup(sg_playercheck, sg_brokenthrough);
	if (Prox_AreSquadsNearMarker(sg_playercheck, mkr_frontline_total_collapse, ANY, nil)) then
		local sg_leftovers = SGroup_CreateIfNotFound("sg_leftovers");
		World_GetSquadsNearMarker(soviet1, sg_leftovers, mkr_frontline_total_collapse, OT_Enemy);
		SGroup_AddGroup(sg_brokenthrough, sg_leftovers);
		SOVIET_TOTALBROKENTHROUGH = SOVIET_TOTALBROKENTHROUGH + SGroup_Count(sg_leftovers);
		SGroup_Clear(sg_leftovers);
	end
	SGroup_Clear(sg_playercheck);
	
end

function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

function Util_IsCoop()
	if (AI_IsAIPlayer(player2) == false) then
		return true;
	else
		return false;
	end
end

local _cmd_follow = {};

function Cmd_Follow(sgroup, target)
	local t = {};
	t.squad = sgroup;
	t.target = target;
	table.insert(_cmd_follow, t);
	if (Rule_Exists(_UpdateFollow) == false) then
		Rule_AddInterval(_UpdateFollow, 2);
	end
end

function _UpdateFollow()
	local RemoveAt = nil;
	for i=1, #_cmd_follow do
		if (SGroup_Count(_cmd_follow[i].squad) > 0 and SGroup_Count(_cmd_follow[i].target) > 0) then
			Cmd_Move(_cmd_follow[i].squad, SGroup_GetPosition(_cmd_follow[i].target));
		else
			RemoveAt = i;
		end
	end
	if (RemoveAt ~= nil) then
		table.remove(_cmd_follow, RemoveAt);
	end
end

function SGroup_FromSquad(squad)
	local sg_temp = SGroup_CreateIfNotFound("sg_temp_from_squad");
	SGroup_Add(sg_temp, squad);
	return sg_temp;
end

function Util_GetDespawnerFromPath(path)
	if (path == "south") then
		return mkr_soviet_despawn03;
	elseif (path == "south_center") then
		return mkr_soviet_despawn03;
	elseif (path == "center") then
		return mkr_soviet_despawn02;
	elseif (path == "north_center") then
		return mkr_soviet_despawn01;
	elseif (path == "north") then
		return mkr_soviet_despawn01;
	end
end
