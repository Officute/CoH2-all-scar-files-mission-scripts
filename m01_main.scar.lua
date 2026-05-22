function Mission_BeginIntel()
	
	UI_SetCPMeterVisibility(false);
	
	Util_StartIntel(EVENTS.INTRO);
	Rule_Add(Mission_Begin);
	
	Mission_SpawnTaskForce();
	
	FOW_PlayerExploreAll(player4);
	FOW_PlayerExploreAll(player5);
	
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
		t_difficulty.unitclass["Volks"] = 8;
		t_difficulty.unitclass["Ober"] = 6;
		t_difficulty.unitclass["Fall"] = 4;
		t_difficulty.unitclass["Puma"] = 3;
		t_difficulty.unitclass["Luchs"] = 2;
		t_difficulty.unitclass["IR"] = 2;
		
		t_difficulty.taskforce_infantry = BP_GetSquadBlueprint("fallschirmjager_squad_mp");
		t_difficulty.taskforce_upgrade = nil;
		t_difficulty.castle_upgrade = nil;
		t_difficulty.reinforcementnotice = 100;
		t_difficulty.reinforcementsubtract = 5;
		
	elseif (g_diff == GD_NORMAL) then
		
		t_difficulty.unitclass = {};
		t_difficulty.unitclass["Volks"] = 6;
		t_difficulty.unitclass["Ober"] = 4;
		t_difficulty.unitclass["Fall"] = 2;
		t_difficulty.unitclass["Puma"] = 1;
		t_difficulty.unitclass["Luchs"] = 1;
		t_difficulty.unitclass["IR"] = 1;
		
		t_difficulty.taskforce_infantry = BP_GetSquadBlueprint("obersoldaten_squad_mp");
		t_difficulty.taskforce_upgrade = BP_GetUpgradeBlueprint("waffen_infrared_stg44");
		t_difficulty.castle_upgrade = BP_GetUpgradeBlueprint("paratrooper_thompson_sub_machine_gun_upgrade_mp");
		t_difficulty.reinforcementnotice = 90;
		t_difficulty.reinforcementsubtract = 7;
		
	elseif (g_diff == GD_HARD) then
		
		t_difficulty.unitclass = {};
		t_difficulty.unitclass["Volks"] = 2;
		t_difficulty.unitclass["Ober"] = 2;
		t_difficulty.unitclass["Fall"] = 2;
		t_difficulty.unitclass["Puma"] = 1;
		t_difficulty.unitclass["Luchs"] = 1;
		t_difficulty.unitclass["IR"] = 1;
		
		t_difficulty.taskforce_infantry = BP_GetSquadBlueprint("volksgrenadier_squad_mp");
		t_difficulty.taskforce_upgrade = BP_GetUpgradeBlueprint("light_infantry_package");
		t_difficulty.castle_upgrade = BP_GetUpgradeBlueprint("paratrooper_thompson_sub_machine_gun_upgrade_mp");
		t_difficulty.reinforcementnotice = 80;
		t_difficulty.reinforcementsubtract = 10;
		
	end

end

function Mission_Restrictions()

	Modify_PlayerSightRadius(player1, 0.65);
	Modify_PlayerSightRadius(player2, 0.65);
	
	Modify_PlayerResourceRate(player1, RT_Munition, 0.75, MUT_Multiplication);
	Modify_PlayerResourceRate(player1, RT_Fuel, 0, MUT_Multiplication);
	Modify_PlayerResourceRate(player1, RT_Manpower, 0.5, MUT_Multiplication);
	
	Modify_PlayerResourceRate(player2, RT_Munition, 0.75, MUT_Multiplication);
	Modify_PlayerResourceRate(player2, RT_Fuel, 0, MUT_Multiplication);
	Modify_PlayerResourceRate(player2, RT_Manpower, 0.5, MUT_Multiplication);
	
	Player_SetResource(player1, RT_Manpower, 0);
	Player_SetResource(player1, RT_Fuel, 0);
	Player_SetResource(player1, RT_Munition, 260);
	
	Player_SetResource(player2, RT_Manpower, 0);
	Player_SetResource(player2, RT_Fuel, 0);
	Player_SetResource(player2, RT_Munition, 260);
	
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("jagdpanzer_tank_destroyer_squad_mp"), ITEM_REMOVED);
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("volksgrenadier_squad_mp"), ITEM_REMOVED);
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("le_ig_18_inf_support_gun_squad_mp"), ITEM_REMOVED);
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("sdkfz_251_20_ir_searchlight_halftrack_squad_mp"), ITEM_REMOVED);
	
	Player_SetSquadProductionAvailability(player2, BP_GetSquadBlueprint("jagdpanzer_tank_destroyer_squad_mp"), ITEM_REMOVED);
	Player_SetSquadProductionAvailability(player2, BP_GetSquadBlueprint("volksgrenadier_squad_mp"), ITEM_REMOVED);
	Player_SetSquadProductionAvailability(player2, BP_GetSquadBlueprint("le_ig_18_inf_support_gun_squad_mp"), ITEM_REMOVED);
	Player_SetSquadProductionAvailability(player2, BP_GetSquadBlueprint("sdkfz_251_20_ir_searchlight_halftrack_squad_mp"), ITEM_REMOVED);
	
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

	OBJ_BRIDGEHEAD = {
		Parent = OBJ_MAIN,
		SetupUI = function()
			OBJ_BRIDGEHEAD.flank = Objective_AddUIElements(OBJ_BRIDGEHEAD, eg_flank_open, true, "$08a0ac9c7e6144909909a02d533ce8aa:187", true, 1.7, nil, nil, nil);
			OBJ_BRIDGEHEAD.bridge = Objective_AddUIElements(OBJ_BRIDGEHEAD, eg_main_point, true, "$08a0ac9c7e6144909909a02d533ce8aa:187", true, 1.7, nil, nil, nil);
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:181",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_CITY = {
		Parent = OBJ_MAIN,
		SetupUI = function()
			OBJ_CITY.inner = Objective_AddUIElements(OBJ_CITY, eg_city_inner, true, "$08a0ac9c7e6144909909a02d533ce8aa:187", true, 1.7, nil, nil, nil);
			OBJ_CITY.outer = Objective_AddUIElements(OBJ_CITY, eg_city_outer, true, "$08a0ac9c7e6144909909a02d533ce8aa:187", true, 1.7, nil, nil, nil);
			OBJ_CITY.outpost = Objective_AddUIElements(OBJ_CITY, eg_city_outpost, true, "$08a0ac9c7e6144909909a02d533ce8aa:187", true, 1.7, nil, nil, nil);
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:186",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_BRIDGE = {
		Parent = OBJ_MAIN,
		SetupUI = function()
			--OBJ_BRIDGE.ping_southern = Objective_AddUIElements(OBJ_BRIDGE, eg_southern_bridge, true, "$08a0ac9c7e6144909909a02d533ce8aa:193", true, 1.7, nil, nil, nil);
			--OBJ_BRIDGE.ping_middle = Objective_AddUIElements(OBJ_BRIDGE, eg_middle_bridge, true, "$08a0ac9c7e6144909909a02d533ce8aa:194", true, 1.7, nil, nil, nil);
			--OBJ_BRIDGE.ping_northern = Objective_AddUIElements(OBJ_BRIDGE, eg_northern_bridge, true, "$08a0ac9c7e6144909909a02d533ce8aa:194", true, 1.7, nil, nil, nil);
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:188",
		Description = 0,
		Type = OT_Secondary,
	}
	
	Objective_Register(OBJ_MAIN);
	Objective_Register(OBJ_BRIDGEHEAD);
	Objective_Register(OBJ_CITY);
	Objective_Register(OBJ_BRIDGE);
	
	OBJ_SECOND = {
	
		SetupUI = function() 
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
			Rule_AdDOneShot(m_lose, 5);
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:197",
		Description = 0,
		Type = OT_Primary,
	}
	
	OBJ_REINFORCEMENTS = {
		Parent = OBJ_SECOND,
		SetupUI = function()
		end,
		OnStart = function()
			OBJ_REINFORCEMENTS.ping = Objective_AddUIElements(OBJ_REINFORCEMENTS, eg_reinforcement_cutoff, true, "$08a0ac9c7e6144909909a02d533ce8aa:194", true, 1.7, nil, nil, nil);
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:198",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_MAJOR = {
		Parent = OBJ_SECOND,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:199",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_CAPTAIN = {
		Parent = OBJ_SECOND,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:200",
		Description = 0,
		Type = OT_Secondary,
	}
	
	Objective_Register(OBJ_SECOND);
	Objective_Register(OBJ_REINFORCEMENTS);
	Objective_Register(OBJ_MAJOR);
	Objective_Register(OBJ_CAPTAIN);
	
end

function Mission_EndMission(victory, intel) -- Note: Intel must call this FUNC again FOR it to work properly

	if (victory == true) then
		if (intel ~= nil) then
			Util_StartIntel(intel);
		else
			if (Util_IsCoop() == true) then
				Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:37", 5.0, 5.0, 5.0); 
				World_SetTeamWin(Player_GetTeam(player1));
			else
				Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:37", 5.0, 5.0, 5.0); 
				Game_EndSP(true);
			end
		end
	else
		if (intel ~= nil) then
			Util_StartIntel(intel);
		else
			if (Util_IsCoop() == true) then
				Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:38", 5.0, 5.0, 5.0); 
				World_SetTeamWin(Player_GetTeam(player4));
			else
				Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:38", 5.0, 5.0, 5.0); 
				Game_EndSP(false);
			end
		end
	end

end

function Mission_SpawnTaskForce()

	sg_player1 = SGroup_CreateIfNotFound("sg_player1");
	sg_player2 = SGroup_CreateIfNotFound("sg_player2");
	
	Util_CreateSquads(player1, sg_player1, t_difficulty.taskforce_infantry, mkr_first_spawner, mkr_player1_volks01, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player1, sg_player1, t_difficulty.taskforce_infantry, mkr_first_spawner, mkr_player1_volks02, 1, nil, true, nil, nil, nil);
	
	Util_CreateSquads(player1, sg_player2, t_difficulty.taskforce_infantry, mkr_first_spawner, mkr_player2_volks01, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player1, sg_player2, t_difficulty.taskforce_infantry, mkr_first_spawner, mkr_player2_volks02, 1, nil, true, nil, nil, nil);
	
	if (t_difficulty.taskforce_upgrade ~= nil) then
		Cmd_InstantUpgrade(sg_player1, t_difficulty.taskforce_upgrade, 1);
		Cmd_InstantUpgrade(sg_player2, t_difficulty.taskforce_upgrade, 1);
	end
	
	Util_CreateSquads(player1, sg_player2, BP_GetSquadBlueprint("kubelwagen_squad_mp"), mkr_first_spawner, mkr_player1_kubelwagen01, 1, nil, true, nil, nil, nil);
	
	Modify_Vulnerability(sg_player1, 0.65);
	Modify_Vulnerability(sg_player2, 0.65);
	
	Util_CreateSquads(player1, sg_player1, BP_GetSquadBlueprint("ostwind_squad_westgerman_mp"), mkr_first_spawner, mkr_player1_ostwind01, 1, nil, true, nil, nil, nil);
	
	if (Util_IsCoop() == true) then
		SGroup_SetPlayerOwner(sg_player2, player2);
	end
	
end

function Mission_SpawnGarrisonForce()

	local upgrade_table = nil;
	
	if (g_diff == GD_NORMAL or g_diff == GD_HARD) then
		upgrade_table = {BP_GetUpgradeBlueprint("paratrooper_thompson_sub_machine_gun_upgrade_mp"), BP_GetUpgradeBlueprint("paratrooper_m1919a6_lmg_mp"), BP_GetUpgradeBlueprint("riflemen_flamethrower")};
	end

	local sg_outer_garrison = SGroup_CreateIfNotFound("sg_counter_garrison");
	local sg_outer_garrison2 = SGroup_CreateIfNotFound("sg_counter_garrison2");
	local sg_infantry_patrol = SGroup_CreateIfNotFound("sg_infantry_patrol");
	local sg_sherman_patrol = SGroup_CreateIfNotFound("sg_sherman_patrol");
	
	Util_CreateSquads(player4, sg_outer_garrison, BP_GetSquadBlueprint("riflemen_squad_mp"), eg_house01, nil, 1, nil, true, nil, Util_GetRandomObject({upgrade_table, nil}), nil);
	Util_CreateSquads(player4, sg_outer_garrison, BP_GetSquadBlueprint("riflemen_squad_mp"), eg_house02, nil, 1, nil, true, nil, Util_GetRandomObject({upgrade_table, nil}), nil);
	Util_CreateSquads(player4, sg_outer_garrison, BP_GetSquadBlueprint("riflemen_squad_mp"), eg_house03, nil, 1, nil, true, nil, Util_GetRandomObject({upgrade_table, nil}), nil);
	Util_CreateSquads(player4, sg_outer_garrison2, BP_GetSquadBlueprint("riflemen_squad_mp"), eg_house04, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player4, sg_outer_garrison2, BP_GetSquadBlueprint("riflemen_squad_mp"), eg_house05, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player4, sg_outer_garrison2, BP_GetSquadBlueprint("riflemen_squad_mp"), eg_house06, nil, 1, nil, true, nil, nil, nil);
	
	SGroup_AddSlotItem(sg_outer_garrison, Object_CreateCCSlotItem("aef_bazooka_item_mp", "bazooka_mp"));
	
	Util_CreateSquads(player4, sg_infantry_patrol, BP_GetSquadBlueprint("riflemen_squad_mp"), mkr_stealth_patrol_spawner, nil, 1, nil, true, nil, BP_GetUpgradeBlueprint("paratrooper_thompson_sub_machine_gun_upgrade_mp"), nil);
	Util_CreateSquads(player4, sg_sherman_patrol, BP_GetSquadBlueprint("m4a3_sherman_squad_mp"), mkr_stealth_patrol_spawner, nil, 1, nil, true, nil, nil, nil);
	
	SGroup_AddGroup(sg_i1, sg_outer_garrison);
	SGroup_AddGroup(sg_i1, sg_outer_garrison2);
	SGroup_AddGroup(sg_i1, sg_sherman_patrol);
	SGroup_AddGroup(sg_i1, sg_infantry_patrol);
	
	Modify_UnitSpeed(sg_sherman_patrol, 0.45);
	Modify_Vulnerability(sg_outer_garrison, 1.25);
	Modify_Vulnerability(sg_sherman_patrol, 3);
	
	Cmd_SquadPath(sg_infantry_patrol, "rifle_patrol", true, LOOP_NORMAL, true, 5, nil, false, true);
	Cmd_SquadPath(sg_sherman_patrol, "sherman_patrol", true, LOOP_NORMAL, true, 0, nil, false, true);
	
end

function Mission_Begin()

	if (Event_IsAnyRunning() == false) then
		
		UI_SetCPMeterVisibility(false);
		
		Mission_SpawnGarrisonForce();
		
		Objective_Start(OBJ_MAIN, false);
		Objective_Start(OBJ_BRIDGEHEAD, true);
		
		Event_PlayerOwnsTerritory(OnCapture_Flank, nil, player1, eg_flank_open, ANY, 0); 
		Event_PlayerOwnsTerritory(OnCapture_Bridge, nil, player1, eg_main_point, ANY, 0); 
		Event_PlayerOwnsTerritory(OnCapture_Outer, nil, player1, eg_city_outer, ANY, 0); 
		Event_PlayerOwnsTerritory(OnCapture_Inner, nil, player1, eg_city_inner, ANY, 0); 
		Event_PlayerOwnsTerritory(OnCapture_Tower, nil, player1, eg_city_outpost, ANY, 0); 
		
		Event_PlayerOwnsTerritory(OnCapture_Flank, nil, player2, eg_flank_open, ANY, 0); 
		Event_PlayerOwnsTerritory(OnCapture_Bridge, nil, player2, eg_main_point, ANY, 0); 
		Event_PlayerOwnsTerritory(OnCapture_Outer, nil, player2, eg_city_outer, ANY, 0); 
		Event_PlayerOwnsTerritory(OnCapture_Inner, nil, player2, eg_city_inner, ANY, 0); 
		Event_PlayerOwnsTerritory(OnCapture_Tower, nil, player2, eg_city_outpost, ANY, 0); 
		
		Rule_AddInterval(Mission_ConditionCheck, 5);
		Rule_RemoveMe();
		
	end

end

function Mission_ConditionCheck()

	if (Util_GetPlayerOwner(eg_flank_open) == player1 or Util_GetPlayerOwner(eg_flank_open) == player2) then
		if (Util_GetPlayerOwner(eg_main_point) == player1 or Util_GetPlayerOwner(eg_main_point) == player2) then
			
			Util_Surrender(sg_i1, mkr_player_spawner, true, true);
			
			Objective_Complete(OBJ_BRIDGEHEAD, true);
			Mission_MoveToMainCity();
			Rule_RemoveMe();
			
		end
	end

	Mission_LostAll();
	
end

function Mission_LostAll()

	if (SGroup_Count(Player_GetSquads(player1)) == 0) then
		
		if (Util_IsCoop() == true) then
			if (SGroup_Count(Player_GetSquads(player2)) == 0) then
				Mission_EndMission(false, nil);
			end
		else
			Mission_EndMission(false, nil);
		end
		
	end

end

function Mission_SpawnCityGarrison()

	----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Main City

	sg_inner_garrison = SGroup_CreateIfNotFound("sg_inner_garrison");
	sg_castle_defence = SGroup_CreateIfNotFound("sg_castle_defence");
	sg_city_patrol1 = SGroup_CreateIfNotFound("sg_city_patrol1");
	sg_city_patrol2 = SGroup_CreateIfNotFound("sg_city_patrol2");
	sg_city_patrol3 = SGroup_CreateIfNotFound("sg_city_patrol3");
	
	Util_CreateSquads(player4, sg_inner_garrison, BP_GetSquadBlueprint("riflemen_squad_mp"), eg_city01, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player4, sg_inner_garrison, BP_GetSquadBlueprint("riflemen_squad_mp"), eg_city02, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player4, sg_inner_garrison, BP_GetSquadBlueprint("riflemen_squad_mp"), eg_city03, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player4, sg_inner_garrison, BP_GetSquadBlueprint("riflemen_squad_mp"), eg_city04, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player4, sg_inner_garrison, BP_GetSquadBlueprint("riflemen_squad_mp"), eg_city05, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player4, sg_inner_garrison, BP_GetSquadBlueprint("riflemen_squad_mp"), eg_city06, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player4, sg_inner_garrison, BP_GetSquadBlueprint("riflemen_squad_mp"), eg_city07, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player4, sg_inner_garrison, BP_GetSquadBlueprint("riflemen_squad_mp"), eg_city08, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player4, sg_inner_garrison, BP_GetSquadBlueprint("riflemen_squad_mp"), eg_city09, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player4, sg_inner_garrison, BP_GetSquadBlueprint("riflemen_squad_mp"), eg_city10, nil, 1, nil, true, nil, nil, nil);

	Util_CreateSquads(player4, sg_castle_defence, BP_GetSquadBlueprint("riflemen_squad_mp"), mkr_caste_spawner, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player4, sg_castle_defence, BP_GetSquadBlueprint("riflemen_squad_mp"), mkr_caste_spawner1, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player4, sg_castle_defence, BP_GetSquadBlueprint("riflemen_squad_mp"), mkr_caste_spawner2, nil, 1, nil, true, nil, nil, nil);
	
	if (t_difficulty.castle_upgrade ~= nil) then
		Cmd_InstantUpgrade(sg_castle_defence, t_difficulty.castle_upgrade, 3);
	end
	
	Cmd_SquadPath(sg_castle_defence, "castle_patrol", true, LOOP_NORMAL, true, 0, nil, false, true);
	
	Util_CreateSquads(player4, sg_city_patrol1, BP_GetSquadBlueprint("riflemen_squad_mp"), mkr_american_reinforcement, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player4, sg_city_patrol1, BP_GetSquadBlueprint("m4a3_sherman_squad_mp"), mkr_american_reinforcement, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player4, sg_city_patrol2, BP_GetSquadBlueprint("riflemen_squad_mp"), mkr_american_reinforcement, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player4, sg_city_patrol3, BP_GetSquadBlueprint("riflemen_squad_mp"), mkr_american_reinforcement, nil, 1, nil, true, nil, nil, nil);
	
	if (t_difficulty.castle_upgrade ~= nil) then
		Cmd_InstantUpgrade(sg_city_patrol2, t_difficulty.castle_upgrade, 1);
		Cmd_InstantUpgrade(sg_city_patrol3, t_difficulty.castle_upgrade, 1);
	end
	
	Cmd_SquadPath(sg_city_patrol1, "patrol_city01", true, LOOP_NORMAL, true, 0, nil, false, true);
	Cmd_SquadPath(sg_city_patrol2, "patrol_city02", true, LOOP_NORMAL, true, 0, nil, false, true);
	Cmd_SquadPath(sg_city_patrol3, "patrol_city03", true, LOOP_NORMAL, true, 0, nil, false, true);
	
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Outer city
	
	sg_outer_patrol = SGroup_CreateIfNotFound("sg_outer_patrol");
	
	Util_CreateSquads(player4, sg_outer_patrol, BP_GetSquadBlueprint("ranger_squad_mp"), mkr_top_spawner01, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player4, sg_outer_patrol, BP_GetSquadBlueprint("ranger_squad_mp"), mkr_top_spawner02, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player4, sg_outer_patrol, BP_GetSquadBlueprint("ranger_squad_mp"), mkr_top_spawner03, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player4, sg_outer_patrol, BP_GetSquadBlueprint("ranger_squad_mp"), mkr_top_spawner04, nil, 1, nil, true, nil, nil, nil);
	
	Cmd_SquadPath(sg_outer_patrol, "outer_patrol", true, LOOP_NORMAL, true, 0, nil, false, true);
	
	SGroup_AddGroup(sg_top, sg_outer_patrol);
	
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Fighting Positions
	
	sg_fighting_positions_echelon = SGroup_CreateIfNotFound("sg_fighting_positions_echelon");
	
	for i=1, EGroup_Count(eg_fighting_positions) do
		local entity = EGroup_GetSpawnedEntityAt(eg_fighting_positions, i);
		local eg_temp = EGroup_FromEntity(entity);
		Util_CreateSquads(player4, sg_fighting_positions_echelon, BP_GetSquadBlueprint("rear_echelon_squad_mp"), eg_temp, nil, 1, nil, true, nil, nil, nil);
		Cmd_InstantUpgrade(eg_temp, BP_GetUpgradeBlueprint("fighting_position_mg_addition_mp"), 1);
	end
	
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- bunkers
	
	sg_bunkers_riflemen = SGroup_CreateIfNotFound("sg_bunkers_riflemen");
	
	for i=1, EGroup_Count(eg_bunkers) do
		local entity = EGroup_GetSpawnedEntityAt(eg_bunkers, i);
		Util_CreateSquads(player4, sg_fighting_positions_echelon, BP_GetSquadBlueprint("riflemen_squad_mp"), EGroup_FromEntity(entity), nil, 1, nil, true, nil, BP_GetUpgradeBlueprint("paratrooper_m1919a6_lmg_mp"), nil);
	end
	
end

function Mission_MoveToMainCity()

	Util_StartIntel(EVENTS.CITYOPEN);
	
	Objective_Start(OBJ_CITY, true);
	Objective_Start(OBJ_BRIDGE, true);
	
	Mission_SpawnCityGarrison();
	
	Production_Unlock();
	World_IncreaseInteractionStage();
	
	American_PopulateCity();
	
	t_US_alert = 
	{
		Level = 0.0,
		triggered1 = false,
		triggered2 = false,
		triggered3 = false,
	};
	
	OBJ_SECOND.cap01 = Event_PlayerCanSeeElement(Mission_BeginSecondary, nil, player1, sg_captain01, ANY, 0);
	OBJ_SECOND.cap02 = Event_PlayerCanSeeElement(Mission_BeginSecondary, nil, player1, sg_captain02, ANY, 0);
	OBJ_SECOND.cap03 = Event_PlayerCanSeeElement(Mission_BeginSecondary, nil, player1, sg_captain03, ANY, 0);
	OBJ_SECOND.cap04 = Event_PlayerCanSeeElement(Mission_BeginSecondary, nil, player1, sg_major, ANY, 0); -- This is actually the Major
	
	OBJ_BRIDGE.attack = {
		
		bridges = {
		
			{egroup = eg_middle_bridge, demolished = false, captured = false, group = SGroup_CreateIfNotFound("sg_bridge_group01"), wasplacing = false, intel = EVENTS.BRDIGE2, index = 1},
			{egroup = eg_northern_bridge, demolished = false, captured = false, group = SGroup_CreateIfNotFound("sg_bridge_group02"), wasplacing = false, intel = EVENTS.BRDIGE1, index = 2},
			{egroup = eg_southern_bridge, demolished = false, captured = true, group = SGroup_CreateIfNotFound("sg_bridge_group03"), wasplacing = false, intel = EVENTS.BRDIGE3, index = 3},
		
		},
		
	};
	
	--Event_Proximity(Mission_UnlockNorthernBridge, nil, player1, EGroup_GetPosition(eg_northern_bridge), 15, ANY, 0);
	--Event_Proximity(Mission_UnlockMiddleBridge, nil, player1, EGroup_GetPosition(eg_middle_bridge), 15, ANY, 0);
	
	--Event_Proximity(Mission_UnlockNorthernBridge, nil, player2, EGroup_GetPosition(eg_northern_bridge), 15, ANY, 0);
	--Event_Proximity(Mission_UnlockMiddleBridge, nil, player2, EGroup_GetPosition(eg_middle_bridge), 15, ANY, 0);
	
	Modify_Vulnerability(eg_middle_bridge, 1.5);
	Modify_Vulnerability(eg_northern_bridge, 1.5);
	Modify_Vulnerability(eg_southern_bridge, 1.5);
	
	Mission_UpdateAmericanReinforcements()
	Rule_AddInterval(Mission_UpdateAmericanReinforcements, t_difficulty.reinforcementnotice);
	
	--Rule_AddInterval(American_BridgeDemolition, 15);
	
	Rule_AddInterval(Mission_CheckCity, 3);
	Rule_AddInterval(Mission_CheckBridges, 4);
	
	--American_CheckBridges();
	
	g_target_bridge = OBJ_BRIDGE.attack.bridges[3];
	
	Rule_AddOneShot(Mission_AttackBridge, 2 * 60);
	
end

function Mission_AttackBridge()

	local bridge = nil;
	if (g_target_bridge == nil) then
		bridge = OBJ_BRIDGE.attack.bridges[World_GetRand(1, 3)];
		g_target_bridge = bridge;
	else
		bridge = g_target_bridge;
	end
	Util_StartIntel(bridge.intel);
	Rule_AddOneShot(Mission_SendUnits, 15);
	
	OBJ_BRIDGE.ping = Objective_AddUIElements(OBJ_BRIDGE, bridge.egroup, true, "$08a0ac9c7e6144909909a02d533ce8aa:193", true, 1.7, nil, nil, nil);
	
end

function Mission_SendUnits()
	
	if (t_US_alert.Level >= 0.75) then
		American_BridgeDemolition(g_target_bridge.egroup, g_target_bridge.group, true);
	else
		American_BridgeDemolition(g_target_bridge.egroup, g_target_bridge.group, false);
	end
	
	Rule_AddOneShot(Mission_CallOffAttack, 5 * 60);
	
end

function Mission_CallOffAttack()

	Objective_RemoveUIElements(OBJ_BRIDGE, OBJ_BRIDGE.ping);
	if (SGroup_IsUnderAttack(g_target_bridge.group, ANY, 1) == true) then
		Util_Surrender(g_target_bridge.group, mkr_player_spawner, true, true);
	else
		Cmd_AttackMove(g_target_bridge.group, SGroup_GetPosition(Player_GetSquads(player1)), false, nil, 15, nil); 
	end
	
	--Cmd_DetonateDemolitions(player4, g_target_bridge.egroup, false); 
	
	American_DestonateObject(g_target_bridge.egroup);
	
	if (EGroup_Count(g_target_bridge.egroup) == 0) then
		table.remove(OBJ_BRIDGE.attack.bridges, g_target_bridge.index);
		for i=1, #OBJ_BRIDGE.attack.bridges do
			OBJ_BRIDGE.attack.bridges[i].index = i;
		end
	end
	
	g_target_bridge = nil;

	Rule_AddOneShot(Mission_AttackBridge, 7 * 60);
	
end

function Mission_UnlockNorthernBridge()
	OBJ_BRIDGE.attack.bridges.bridge02.captured = true;
	Objective_RemoveUIElements(OBJ_BRIDGE, OBJ_BRIDGE.attack.bridges.bridge02.uiID);
	Objective_AddUIElements(OBJ_BRIDGE, eg_northern_bridge, true, "$08a0ac9c7e6144909909a02d533ce8aa:193", true, 1.7, nil, nil, nil);
end

function Mission_UnlockMiddleBridge()
	OBJ_BRIDGE.attack.bridges.bridge01.captured = true;
	Objective_RemoveUIElements(OBJ_BRIDGE, OBJ_BRIDGE.attack.bridges.bridge02.uiID);
	Objective_AddUIElements(OBJ_BRIDGE, eg_southern_bridge, true, "$08a0ac9c7e6144909909a02d533ce8aa:193", true, 1.7, nil, nil, nil);
end

function Mission_SpawnReinforcements()

	local eg_player1_sws = EGroup_CreateIfNotFound("eg_player1_sws");
	local eg_player2_sws = EGroup_CreateIfNotFound("eg_player2_sws");

	local sg_player1_infantry = SGroup_CreateIfNotFound("sg_player1_infantry");
	local sg_player2_infantry = SGroup_CreateIfNotFound("sg_player2_infantry");
	
	local sg_player1_halftrack = SGroup_CreateIfNotFound("sg_player1_halftrack");
	local sg_player2_halftrack = SGroup_CreateIfNotFound("sg_player2_halftrack");
	
	Util_CreateSquads(player1, sg_player1_halftrack, BP_GetSquadBlueprint("mechanized_250_halftrack_mp"), mkr_reinforcement_to_bridge, mkr_player1_htrack01, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player1, sg_player2_halftrack, BP_GetSquadBlueprint("mechanized_250_halftrack_mp"), mkr_reinforcement_to_bridge, mkr_player2_htrack01, 1, nil, true, nil, nil, nil);
	
	Util_CreateSquads(player1, sg_player1_infantry, BP_GetSquadBlueprint("panzerfusilier_squad_mp"), sg_player1_halftrack, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player1, sg_player2_infantry, BP_GetSquadBlueprint("panzerfusilier_squad_mp"), sg_player2_halftrack, nil, 1, nil, true, nil, nil, nil);
	
	Modify_Vulnerability(sg_player1_infantry, 0.5);
	Modify_Vulnerability(sg_player2_infantry, 0.5);
	
	local pgrenremoval = Player_GetSquads(player1);
	SGroup_Filter(pgrenremoval, BP_GetSquadBlueprint("panzer_grenadier_squad_mp"), FILTER_KEEP, nil); 
	SGroup_DestroyAllSquads(pgrenremoval);
	
	Util_CreateEntities(player1, eg_player1_sws, BP_GetEntityBlueprint("heavy_armor_support_mp"), mkr_player1_sws, 1); 
	
	if (Util_IsCoop() == true) then
		SGroup_SetPlayerOwner(sg_player2_infantry, player2);
		SGroup_SetPlayerOwner(sg_player2_halftrack, player2);
		Util_CreateEntities(player2, eg_player2_sws, BP_GetEntityBlueprint("heavy_armor_support_mp"), mkr_player2_sws, 1); 
	end
	
	--Rule_AddOneShot(Mission_RemoveSWS, 2);
	
end

function Mission_RemoveSWS()
	
	local squads = Player_GetSquads(player1);
	SGroup_Filter(squads, BP_GetSquadBlueprint("sws_halftrack_squad_mp"), FILTER_KEEP, nil); 
	SGroup_DisableUI(squads);
	SGroup_Clear(squads);
	
	if (Util_IsCoop() == true) then
		
		local squads = Player_GetSquads(player2);
		SGroup_Filter(squads, BP_GetSquadBlueprint("sws_halftrack_squad_mp"), FILTER_KEEP, nil); 
		SGroup_DisableUI(squads);
		SGroup_Clear(squads);
		
	end
	
end

function Mission_UpdateAmericanReinforcements()

	if (t_difficulty.reinforcementnotice >= 10) then
		t_difficulty.reinforcementnotice = t_difficulty.reinforcementnotice - t_difficulty.reinforcementsubtract;
	end
	if (Rule_Exists(Mission_UpdateAmericanReinforcements) == true) then
		Rule_ChangeInterval(Mission_UpdateAmericanReinforcements, t_difficulty.reinforcementnotice);
	end

	Obj_ShowProgress2("$08a0ac9c7e6144909909a02d533ce8aa:189", t_US_alert.Level);

	t_US_alert.Level = t_US_alert.Level + 0.05;
	
	if (t_US_alert.Level >= 0.5 and t_US_alert.triggered1 == false) then
		American_Support(1);
		Util_StartIntel(EVENTS.LEVEL1);
		t_US_alert.triggered1 = true;
	elseif (t_US_alert.Level >= 0.75 and t_US_alert.triggered2 == false) then
		American_Support(2);
		Util_StartIntel(EVENTS.LEVEL2);
		t_US_alert.triggered2 = true;
	elseif (t_US_alert.Level >= 0.99 and t_US_alert.triggered3 == false) then
		American_Support(3);
		Util_StartIntel(EVENTS.LEVEL3);
		t_US_alert.triggered3 = true;
		Rule_AddOneShot(American_BeginReinforcements, 30);
		Obj_HideProgress();
		Rule_RemoveMe();
	end
	
end

function Mission_BeginSecondary()

	Util_StartIntel(EVENTS.INTELTIP);

	Objective_Start(OBJ_SECOND, true);
	Objective_Start(OBJ_REINFORCEMENTS, false);
	Objective_Start(OBJ_MAJOR, true);
	Objective_Start(OBJ_CAPTAIN, false);

	Objective_SetCounter(OBJ_MAJOR, 0, 1);
	Objective_SetCounter(OBJ_CAPTAIN, 0, 3);
	
	if (Event_Exists(OBJ_SECOND.cap01) == true) then
		Event_Remove(OBJ_SECOND.cap01);
	end
	
	if (Event_Exists(OBJ_SECOND.cap02) == true) then
		Event_Remove(OBJ_SECOND.cap02);
	end
	
	if (Event_Exists(OBJ_SECOND.cap03) == true) then
		Event_Remove(OBJ_SECOND.cap03);
	end
	
	if (Event_Exists(OBJ_SECOND.cap04) == true) then
		Event_Remove(OBJ_SECOND.cap04);
	end
	
	Event_PlayerCanSeeElement(Secondary_CanSeeCaptain01, nil, player1, sg_captain01, ANY, 0);
	Event_PlayerCanSeeElement(Secondary_CanSeeCaptain02, nil, player1, sg_captain02, ANY, 0);
	Event_PlayerCanSeeElement(Secondary_CanSeeCaptain03, nil, player1, sg_captain03, ANY, 0);
	Event_PlayerCanSeeElement(Secondary_CanSeeCaptain04, nil, player1, sg_major, ANY, 0);
	
	Rule_AddInterval(Secondary_CheckCaptains, 5);
	Rule_AddInterval(Secondary_CheckMajor, 5);
	Rule_AddInterval(Mission_OnReinforcementPointCapture, 5);
	
end

function Secondary_CanSeeCaptain01()
	HintPoint_Add(sg_captain01, true, "$08a0ac9c7e6144909909a02d533ce8aa:203", 2.7, HPAT_Attack, "");
end

function Secondary_CanSeeCaptain02()
	HintPoint_Add(sg_captain02, true, "$08a0ac9c7e6144909909a02d533ce8aa:203", 2.7, HPAT_Attack, "");
end

function Secondary_CanSeeCaptain03()
	HintPoint_Add(sg_captain03, true, "$08a0ac9c7e6144909909a02d533ce8aa:203", 2.7, HPAT_Attack, "");
end

function Secondary_CanSeeCaptain04()
	HintPoint_Add(sg_major, true, "$08a0ac9c7e6144909909a02d533ce8aa:204", 2.7, HPAT_Attack, "");
end

function Secondary_CheckCaptains()

	local killed = 0;
	
	if (SGroup_Count(sg_captain01) == 0) then
		killed = killed + 1;
	end
	
	if (SGroup_Count(sg_captain02) == 0) then
		killed = killed + 1;
	end
	
	if (SGroup_Count(sg_captain03) == 0) then
		killed = killed + 1;
	end
	
	local alive = 0 + killed;
	Objective_SetCounter(OBJ_CAPTAIN, alive, 3);
	
	if (killed == 3) then
		Objective_Complete(OBJ_CAPTAIN, true);
		Rule_RemoveMe();
	end
	
end

function Secondary_CheckMajor()

	if (SGroup_Count(sg_major) == 0) then
	
		Objective_Complete(OBJ_MAJOR, true);
		Rule_RemoveMe();
	
	end

end

function Mission_CheckBridges()

	local destroyed = 0;

	if (EGroup_Count(eg_middle_bridge) == 0) then
		destroyed = destroyed + 1;
		OBJ_BRIDGE.attack.bridges[1].demolished = true;
	end
	
	if (EGroup_Count(eg_northern_bridge) == 0) then
		destroyed = destroyed + 1;
		OBJ_BRIDGE.attack.bridges[2].demolished = true;
	end

	if (EGroup_Count(eg_southern_bridge) == 0) then
		destroyed = destroyed + 1;
		OBJ_BRIDGE.attack.bridges[3].demolished = true;
	end
	
	local alive = 3 - destroyed;
	
	Objective_SetCounter(OBJ_BRIDGE, alive, 3);
	
	if (destroyed == 2) then -- we need at least two bridges
	
		Objective_Fail(OBJ_BRIDGE, true);
		Mission_EndMission(false, EVENTS.BRIDGELOST);
		
		Rule_RemoveMe();
		
	end
	
end

function Mission_CheckCity()

	if (Util_GetPlayerOwner(eg_city_inner) == player1 or Util_GetPlayerOwner(eg_city_inner) == player2) then
		if (Util_GetPlayerOwner(eg_city_outer) == player1 or Util_GetPlayerOwner(eg_city_outer) == player2) then
			if (Util_GetPlayerOwner(eg_city_outpost) == player1 or Util_GetPlayerOwner(eg_city_outpost) == player2) then
				Objective_Complete(OBJ_CITY, true);
				Mission_EndMission(true, EVENTS.OUTRO);
				Rule_RemoveMe();
			end
		end
	end

end

function OnCapture_Flank()
	Objective_RemoveUIElements(OBJ_BRIDGEHEAD, OBJ_BRIDGEHEAD.flank);
end

function OnCapture_Bridge()
	Objective_RemoveUIElements(OBJ_BRIDGEHEAD, OBJ_BRIDGEHEAD.bridge);
end

function OnCapture_Outer()
	Objective_RemoveUIElements(OBJ_CITY, OBJ_CITY.outer);
end

function OnCapture_Inner()
	Objective_RemoveUIElements(OBJ_CITY, OBJ_CITY.inner);
end

function OnCapture_Tower()
	Objective_RemoveUIElements(OBJ_CITY, OBJ_CITY.outpost);
end

function Mission_OnReinforcementPointCapture()

	if (EGroup_IsCapturedByPlayer(eg_reinforcement_cutoff, player1, ANY) == true or EGroup_IsCapturedByPlayer(eg_reinforcement_cutoff, player2, ANY) == true) then
		
		Objective_Complete(OBJ_REINFORCEMENTS, true);
		
		local rand = World_GetRand(1, 50);
		
		if (rand >= 50) then
			
			rand = World_GetRand(1, 100);
			
			if (rand >= (t_US_alert.Level/2)) then
				Mission_DigInAmericanGarrison();
			else
				Mission_SurrenderAmericanGarrison();
			end
			
		else
			Mission_SurrenderAmericanGarrison();
		end
		
		Rule_RemoveMe();
		
	end

end

function Mission_SurrenderAmericanGarrison()

	Util_Surrender(Player_GetSquads(player4), mkr_player_spawner, true, true);
	
	Mission_EndMission(true, EVENTS.SURRENDERGARRISON);

end

function Mission_DigInAmericanGarrison()

	Rule_Remove(Mission_UpdateAmericanReinforcements);
	Obj_HideProgress();
	
	Util_StartIntel(EVENTS.CONTINUEGARRISON);
	
end
