import("ScarUtil.scar");
import("m02_ukf_utilities.scar");
import("m02_ukf_reinforcements.scar");

-- TODO: Add suicide panzershreck squads when the Churchill is advancing

-- TODO: Add Cleanup functions For the assault segments

function OnGameSetup()

	player1 = World_GetPlayerAt(1);
	player2 = World_GetPlayerAt(2);
	player3 = World_GetPlayerAt(3);
	player4 = World_GetPlayerAt(4);

	Setup_SetPlayerName(player1, "$08a0ac9c7e6144909909a02d533ce8aa:421");
	Setup_SetPlayerName(player2, "$08a0ac9c7e6144909909a02d533ce8aa:421");
	Setup_SetPlayerName(player3, "$08a0ac9c7e6144909909a02d533ce8aa:422");
	Setup_SetPlayerName(player4, "$08a0ac9c7e6144909909a02d533ce8aa:422");
	
end

function OnGameRestore()

	player1 = World_GetPlayerAt(1);
	player2 = World_GetPlayerAt(2);
	player3 = World_GetPlayerAt(3);
	player4 = World_GetPlayerAt(4);
	
	Game_DefaultGameRestore();

end

function OnInit()

	Mission_Difficulty();
	Mission_Restrictions();
	Mission_Objectives();

	AI_EnableAll(false);
	
	EGroup_DeSpawn(eg_on_blow);
	
	Game_EnableInput(false);
	Game_SetMode(UI_Cinematic);
	
	g_obstaclesBlown = false;
	sg_infantry_ai_support = SGroup_CreateIfNotFound("sg_infantry_ai_support");
	
	Modify_Vulnerability(sg_obstacle_defence_buff, t_difficulty.obstacle_defence_buff);
	Modify_Vulnerability(sg_player_commandos, t_difficulty.commando_variable);
	Modify_Vulnerability(sg_valentine_squad, 1.55);
	
	World_SetIceHealingRate(0);
	World_SetSnowHealingRate(1.75);
	
	Cmd_Stop(sg_player_commandos); -- For some reason the AI moves around with the commandos
	
	Rule_AddOneShot(Mission_BeginDelayed, 1);
	
end

function Mission_BeginDelayed()
	Util_StartIntel(EVENTS.INTRO);
	Rule_Add(Mission_BeginMain);
end

Scar_AddInit(OnInit);

function Mission_Difficulty()

	g_diff = Game_GetSPDifficulty();
	t_difficulty = {};
	
	if (g_diff == GD_EASY) then
	
		t_difficulty.commando_variable = 0.45;
		t_difficulty.obstacle_defence_buff = 1.12;
		t_difficulty.churchill_buff = 0.5;
		t_difficulty.city_defence_debuff = 1.95;
		t_difficulty.support_max = 4;
		t_difficulty.resourcebonus_a = 180;
		t_difficulty.resourcebonus_b = 260;
		t_difficulty.spawn_halftrack = false;
		t_difficulty.skiptwolast = true;
		
		t_difficulty.p_infantry = 10;
		t_difficulty.p_sappers = 5;
		t_difficulty.p_cromwell = 8;
		t_difficulty.p_firefly = 4;
		
	elseif (g_diff == GD_NORMAL) then
		
		t_difficulty.commando_variable = 0.55;
		t_difficulty.obstacle_defence_buff = 1.17;
		t_difficulty.churchill_buff = 0.75;
		t_difficulty.city_defence_debuff = 1.69;
		t_difficulty.support_max = 3;
		t_difficulty.resourcebonus_a = 145;
		t_difficulty.resourcebonus_b = 170;
		t_difficulty.spawn_halftrack = true;
		t_difficulty.skiptwolast = true;
		
		t_difficulty.p_infantry = 8;
		t_difficulty.p_sappers = 5;
		t_difficulty.p_cromwell = 6;
		t_difficulty.p_firefly = 3;
		
	elseif (g_diff == GD_HARD) then
		
		t_difficulty.commando_variable = 0.65;
		t_difficulty.obstacle_defence_buff = 1.26;
		t_difficulty.churchill_buff = 0.95;
		t_difficulty.city_defence_debuff = 1.57;
		t_difficulty.support_max = 2;
		t_difficulty.resourcebonus_a = 90;
		t_difficulty.resourcebonus_b = 120;
		t_difficulty.spawn_halftrack = true;
		t_difficulty.skiptwolast = false;
		
		t_difficulty.p_infantry = 6;
		t_difficulty.p_sappers = 4;
		t_difficulty.p_cromwell = 4;
		t_difficulty.p_firefly = 2;
		
	end

	t_production = {};
	t_production["unit01"] = {};
	t_production["unit01"].unit = "unit01";
	t_production["unit01"].name = "dialog.partisan_infantry";
	t_production["unit01"].blueprint = "tommy_squad_mp";
	t_production["unit01"].available = t_difficulty.p_infantry;
	t_production["unit01"].icon = "Icons_units_unit_british_tommy_with_tommy";
	t_production["unit01"].tag = "unit01";
	t_production["unit01"].intel = nil;
	t_production["unit01"].upg = nil;
	t_production["unit02"] = {};
	t_production["unit02"].unit = "unit02";
	t_production["unit02"].name = "dialog.basic_infantry";
	t_production["unit02"].blueprint = "sapper_squad_mp";
	t_production["unit02"].available = t_difficulty.p_sappers;
	t_production["unit02"].icon = "Icons_units_unit_british_engineer";
	t_production["unit02"].tag = "unit02";
	t_production["unit02"].intel = nil;
	t_production["unit02"].upg = nil;
	t_production["unit03"] = {};
	t_production["unit03"].unit = "unit03";
	t_production["unit03"].name = "dialog.medium_infantry";
	t_production["unit03"].blueprint = "cromwell_mk4_75mm_squad_mp";
	t_production["unit03"].available = t_difficulty.p_cromwell;
	t_production["unit03"].icon = "Icons_vehicles_vehicle_british_cromwell";
	t_production["unit03"].tag = "unit03";
	t_production["unit03"].intel = nil;
	t_production["unit03"].upg = nil;
	t_production["unit04"] = {};
	t_production["unit04"].unit = "unit04";
	t_production["unit04"].name = "dialog.heavy_infantry";
	t_production["unit04"].blueprint = "sherman_firefly_squad_mp";
	t_production["unit04"].available = t_difficulty.p_firefly;
	t_production["unit04"].icon = "Icons_vehicles_vehicle_british_sherman_firefly";
	t_production["unit04"].tag = "unit04";
	t_production["unit04"].intel = nil;
	t_production["unit04"].upg = nil;
	
end

function Mission_Restrictions()

	Player_SetPopCapOverride(player1, 15); 
	g_mRate = Modify_PlayerResourceRate(player1, RT_Manpower, 0, MUT_Multiplication);
	g_aRate = Modify_PlayerResourceRate(player1, RT_Munition, 0, MUT_Multiplication);
	Modify_PlayerResourceRate(player1, RT_Fuel, 0, MUT_Multiplication);
	
	Player_SetPopCapOverride(player2, 500); 
	
	Player_SetResource(player1, RT_Munition, 0);
	Player_SetResource(player1, RT_Manpower, 0);
	Player_SetResource(player1, RT_Fuel, 0);
	Player_StopEarningActionPoints(player1); 
	
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("platoon_bofors_research_mp"));
	--Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("platoon_aec_research_mp"));
	Player_SetCommandAvailability(player1, SCMD_Retreat, ITEM_LOCKED)
	
end

function Mission_Objectives()

	OBJ_CITY_START = {
	
		SetupUI = function() 
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:413",
		Description = 0,
		Type = OT_Primary,
	}

	OBJ_OBSTACLES = {
	
		Parent = OBJ_CITY_START,
	
		SetupUI = function() 
		end,
		
		OnStart = function()
			
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:414",
		Description = 0,
		Type = OT_Secondary,
		
	}
	
	OBJ_CHRUCHILLS = {
	
		Parent = OBJ_CITY_START,
	
		SetupUI = function() 
		end,
		
		OnStart = function()
			
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:415",
		Description = 0,
		Type = OT_Secondary,
		
	}
	
	OBJ_CLEARSOUTH = {
	
		Parent = OBJ_CITY_START,
	
		SetupUI = function() 
		end,
		
		OnStart = function()
			
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:433",
		Description = 0,
		Type = OT_Secondary,
		
	}
	
	OBJ_CROSS = {
	
		Parent = OBJ_CITY_START,
	
		SetupUI = function() 
		end,
		
		OnStart = function()
			
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:416",
		Description = 0,
		Type = OT_Secondary,
		
	}

	Objective_Register(OBJ_CITY_START);
	Objective_Register(OBJ_OBSTACLES);
	Objective_Register(OBJ_CHRUCHILLS);
	Objective_Register(OBJ_CLEARSOUTH);
	Objective_Register(OBJ_CROSS);
	
	OBJ_ARTY_BATTLE = {
	
		SetupUI = function() 
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:417",
		Description = 0,
		Type = OT_Primary,
	}
	
	OBJ_REPAIR_BRIDGE = {
	
		Parent = OBJ_ARTY_BATTLE,
	
		SetupUI = function() 
		end,
		
		OnStart = function()
			
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:418",
		Description = 0,
		Type = OT_Secondary,
		
	}
	
	OBJ_CROSS_BRIDGE = {
	
		Parent = OBJ_ARTY_BATTLE,
	
		SetupUI = function() 
		end,
		
		OnStart = function()
			
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:419",
		Description = 0,
		Type = OT_Secondary,
		
	}
	
	OBJ_DEFEND_POSITION = {
	
		Parent = OBJ_ARTY_BATTLE,
	
		SetupUI = function() 
		end,
		
		OnStart = function()
			
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:459",
		Description = 0,
		Type = OT_Secondary,
		
	}
	
	Objective_Register(OBJ_ARTY_BATTLE);
	Objective_Register(OBJ_REPAIR_BRIDGE);
	Objective_Register(OBJ_CROSS_BRIDGE);
	Objective_Register(OBJ_DEFEND_POSITION);
	
end

function Mission_BeginMain()

	if (Event_IsAnyRunning() == false) then

		Objective_Start(OBJ_CITY_START, false);
		Objective_Start(OBJ_OBSTACLES, true);
		
		Event_Proximity(Mission_TriggerFlak, nil, sg_player_commandos, mkr_flak_move_trigger, 15, ANY, 0); 
		Event_Proximity(Mission_MoveInAxisReinforcements, nil, sg_player_commandos, mkr_barricade_reinforcement_trigger, 30, ANY, 10); 
		
		Cmd_InstantSetupTeamWeapon(sg_obstacle_setup, false);
		UI_SetCPMeterVisibility(false);
		
		Game_SubTextFade("$08a0ac9c7e6144909909a02d533ce8aa:411", "$08a0ac9c7e6144909909a02d533ce8aa:412", 0.5, 4, 0.5);
		
		Objective_AddUIElements(OBJ_OBSTACLES, eg_barricade, true, "$08a0ac9c7e6144909909a02d533ce8aa:414", true, 2.7, nil, nil, nil);
		
		Rule_AddInterval(Mission_IsBlown, 5);
		Rule_AddInterval(Mission_AISupportUpdate, 2.5);
		Rule_AddInterval(Mission_UpdateKillzone, 1);
		Rule_RemoveMe();
		
	end
	
end

function Mission_MoveInAxisReinforcements()

	local sg_flak_new = SGroup_CreateIfNotFound("sg_flak_new");
	Util_CreateSquads(player3, sg_flak_new, BP_GetSquadBlueprint("sdkfz_251_17_flak_halftrack_squad_mp"), mkr_volks_spawn_b, mkr_volks_spawn_middle_b, 1);
	Cmd_Move(sg_flak_new, mkr_new_flak, true);
	
	Modify_Vulnerability(sg_flak_new, (t_difficulty.obstacle_defence_buff * 3));
	
	local sg_ai_axis_reinforcements = SGroup_CreateIfNotFound("sg_ai_axis_reinforcements");
	Util_CreateSquads(player3, sg_ai_axis_reinforcements, BP_GetSquadBlueprint("volksgrenadier_squad_mp"), mkr_volks_spawn_b, mkr_volks_moveto_b01, 1);
	Util_CreateSquads(player3, sg_ai_axis_reinforcements, BP_GetSquadBlueprint("volksgrenadier_squad_mp"), mkr_volks_spawn_b, mkr_volks_moveto_b02, 1);
	Util_CreateSquads(player3, sg_ai_axis_reinforcements, BP_GetSquadBlueprint("volksgrenadier_squad_mp"), mkr_volks_spawn_b, mkr_volks_moveto_b03, 1);
	Util_CreateSquads(player3, sg_ai_axis_reinforcements, BP_GetSquadBlueprint("volksgrenadier_squad_mp"), mkr_volks_spawn_b, mkr_volks_moveto_b04, 1);
	
	Modify_Vulnerability(sg_ai_axis_reinforcements, (t_difficulty.obstacle_defence_buff + 0.5));
	
	if (t_difficulty.spawn_halftrack == true) then
		
		local sg_halftrack_first = SGroup_CreateIfNotFound("sg_halftrack_first");
		Util_CreateSquads(player3, sg_halftrack_first, BP_GetSquadBlueprint("sdkfz_251_halftrack_squad_mp"), mkr_volks_spawn_b, mkr_volks_spawn_middle_b, 1);
		
	end
	
end

function Mission_UpdateKillzone()

	if (Player_AreSquadsNearMarker(player1, mkr_frontal_kill_zone) == true) then
		
		local sg_kill = SGroup_CreateIfNotFound("sg_kill");
		Player_GetAllSquadsNearMarker(player1, sg_kill, mkr_frontal_kill_zone, 10); 
		
		if (SGroup_GetAvgHealth(sg_kill) >= 0.1) then
			
			local health = SGroup_GetAvgHealth(sg_kill) - 0.01;
			SGroup_SetAvgHealth(sg_kill, health); 
			
		end
		
		SGroup_Clear(sg_kill);
		
	end

end

function Mission_AISupportUpdate()

	if (g_obstaclesBlown == true) then
	
		if (SGroup_Count(sg_infantry_ai_support) == 0) then
			
			for i=1, t_difficulty.support_max do
				Util_CreateSquads(player2, sg_infantry_ai_support, BP_GetSquadBlueprint("tommy_squad_mp"), mkr_tommy_spawn, SGroup_GetPosition(sg_churchill_last), 1);
			end
			
			Modify_Vulnerability(sg_infantry_ai_support, 2.35);
			
		else -- update position
			Cmd_Move(sg_infantry_ai_support, Util_GetRandomPosition(SGroup_GetPosition(sg_churchill_last), 5));
		end
	
	else
		
		if (SGroup_Count(sg_infantry_ai_support) == 0) then
			
			Util_CreateSquads(player2, sg_infantry_ai_support, BP_GetSquadBlueprint("tommy_squad_mp"), mkr_tommy_spawn, mkr_tommy_easy_kill01, 1);
			Util_CreateSquads(player2, sg_infantry_ai_support, BP_GetSquadBlueprint("tommy_squad_mp"), mkr_tommy_spawn, mkr_tommy_easy_kill02, 1);
			
		end
		
		Modify_Vulnerability(sg_infantry_ai_support, 2.75);
		
	end

end

function Mission_IsBlown()
	
	if (EGroup_Count(eg_barricade) == 0) then
		
		EGroup_ReSpawn(eg_on_blow);
		
		Objective_Complete(OBJ_OBSTACLES, true);
		Util_StartIntel(EVENTS.MOVEUP);
		
		World_IncreaseInteractionStage();
		
		g_obstaclesBlown = true;
		
		Rule_AddOneShot(Mission_MoveChurchillAndPlayer, 10);
		Rule_Remove(Mission_UpdateKillzone);
		Rule_RemoveMe();
		
	end
	
end

function Mission_TriggerFlak()

	Modify_Vulnerability(sg_flak_move_support, t_difficulty.obstacle_defence_buff);
	Cmd_Move(sg_flak_move_support, mkr_flak_moveto);

end

function Mission_MoveChurchillAndPlayer()

	Objective_Start(OBJ_CHRUCHILLS, true);

	Cmd_Move(sg_player_commandos, mkr_commando_assemble);
	Cmd_MoveToAndDespawn(sg_valentine_squad, mkr_valentine_despawn, false);

	SGroup_SetPlayerOwner(sg_valentine_squad, player2);
	
	Cmd_SquadPath(sg_churchill_front, "churchill_move_town", true, LOOP_NONE, false, 0);
	Cmd_SquadPath(sg_churchill_last, "churchill_move_town", true, LOOP_NONE, false, 0);
	
	Cmd_Move(sg_churchill_front, mkr_crocodile_goto_kill, true);
	
	local sg_commando_temp = SGroup_CreateIfNotFound("sg_commando_temp");
	Util_CreateSquads(player1, sg_commando_temp, BP_GetSquadBlueprint("commando_squad_mp"), mkr_commando_extra, mkr_commando_assemble, 1);
	Modify_Vulnerability(sg_commando_temp, t_difficulty.commando_variable);
	SGroup_AddGroup(sg_player_commandos, sg_commando_temp);
	
	Camera_MoveTo(mkr_commando_assemble, true, SLOW_CAMERA_PANNING, false, true);
	
	OBJ_CHRUCHILLS.uielement01 = Objective_AddUIElements(OBJ_CHRUCHILLS, sg_churchill_front, true, "$08a0ac9c7e6144909909a02d533ce8aa:425", true, 2.7, nil, nil, nil);
	OBJ_CHRUCHILLS.uielement02 = Objective_AddUIElements(OBJ_CHRUCHILLS, sg_churchill_last, true, "$08a0ac9c7e6144909909a02d533ce8aa:425", true, 2.7, nil, nil, nil); 
	
	Modify_Vulnerability(sg_churchill_front, 1.95);
	Modify_Vulnerability(sg_churchill_last, t_difficulty.churchill_buff);
	Modify_UnitSpeed(sg_churchill_front, 0.85);
	Modify_UnitSpeed(sg_churchill_last, 0.65);
	
	Modifier_Remove(g_mRate);
	Modifier_Remove(g_aRate);
	g_mRate = Modify_PlayerResourceRate(player1, RT_Manpower, 0.75, MUT_Multiplication);
	g_aRate = Modify_PlayerResourceRate(player1, RT_Munition, 1.45, MUT_Multiplication);
	
	Player_AddResource(player1, RT_Munition, t_difficulty.resourcebonus_a);
	Player_AddResource(player1, RT_Manpower, t_difficulty.resourcebonus_b);
	Player_SetPopCapOverride(player1, 50); 
	Player_SetCommandAvailability(player1, SCMD_Retreat, ITEM_UNLOCKED)
	
	g_manpowercap = 500;
	g_munitioncap = 300;
	
	Event_Proximity(Mission_ChurchillMoveBuffer, nil, sg_churchill_front, mkr_crocodile_goto_kill, 5, ANY, 0); 
	
	Mission_GarrisonCity();
	Mission_MoveVolksWithShrecks();
	
	Rule_Add(Mission_PlayerResourceCap);
	
end

function Mission_PlayerResourceCap()

	if (Player_GetResource(player1, RT_Manpower) > g_manpowercap) then
		Player_SetResource(player1, RT_Manpower, g_manpowercap);
	end

	if (Player_GetResource(player1, RT_Munition) > g_munitioncap) then
		Player_SetResource(player1, RT_Munition, g_munitioncap);
	end
	
end

function Mission_GarrisonCity()

	sg_city_defence = SGroup_CreateIfNotFound("sg_city_defence");

	Util_SpawnGarrison(player3, eg_church, sg_city_defence, BP_GetSquadBlueprint("mg34_heavy_machine_gun_squad_mp"), 1);
	Util_SpawnGarrison(player3, eg_church, sg_city_defence, BP_GetSquadBlueprint("obersoldaten_squad_mp"), 2);
	
	Util_SpawnGarrison(player3, eg_city_houses, sg_city_defence, BP_GetSquadBlueprint("obersoldaten_squad_mp"), 1);
	Util_SpawnGarrison(player3, eg_city_houses, sg_city_defence, BP_GetSquadBlueprint("assault_pioneer_squad_mp"), 1);
	
	Util_SpawnGarrison(player3, eg_mg_house_left, sg_city_defence, BP_GetSquadBlueprint("mg34_heavy_machine_gun_squad_mp"), 1);
	Util_SpawnGarrison(player3, eg_support_church, sg_city_defence, BP_GetSquadBlueprint("mg34_heavy_machine_gun_squad_mp"), 1);
	
	Modify_Vulnerability(sg_city_defence, t_difficulty.city_defence_debuff);
	
end

function Mission_MoveVolksWithShrecks()

	sg_volks_c = SGroup_CreateIfNotFound("sg_volks_c");

	Util_CreateSquads(player3, sg_volks_c, BP_GetSquadBlueprint("volksgrenadier_squad_mp"), mkr_volks_spawn_c01, mkr_volks_moveto_c01, 1);
	Util_CreateSquads(player3, sg_volks_c, BP_GetSquadBlueprint("volksgrenadier_squad_mp"), mkr_volks_spawn_c01, mkr_volks_moveto_c02, 1);
	Util_CreateSquads(player3, sg_volks_c, BP_GetSquadBlueprint("volksgrenadier_squad_mp"), mkr_volks_spawn_c02, mkr_volks_moveto_c03, 1);
	Util_CreateSquads(player3, sg_volks_c, BP_GetSquadBlueprint("volksgrenadier_squad_mp"), mkr_volks_spawn_c02, mkr_volks_moveto_c04, 1);
	
	Cmd_InstantUpgrade(sg_volks_c, BP_GetUpgradeBlueprint("assault_pioneer_panzerschreck_upgrade"), 2);
	
end

function Mission_ChurchillMoveBuffer()
	Event_OnHealth(Mission_OnChurchillFrontDamaged, nil, sg_churchill_front, 0.80, false, 2);
end

function Mission_OnChurchillFrontDamaged()

	SGroup_Kill(sg_churchill_front);

	Util_StartIntel(EVENTS.CHURCHIL_DOWN);
	Cmd_Move(sg_churchill_last, mkr_crocodile_move_after_death);
	
	World_IncreaseInteractionStage();
	
	Event_Proximity(Mission_TriggerPanzerIV, nil, sg_churchill_last, mkr_crocodile_move_after_death, 5, ANY, 0); 
	
	Rule_AddInterval(Mission_OnChurchillDeath, 5);
	
end

function Mission_OnChurchillDeath()

	if (SGroup_Count(sg_churchill_last) == 0) then
		
		Objective_Fail(OBJ_CHRUCHILLS, true);
		Codiex_EndGame(Player_GetRaceName(player1), false);
		Rule_RemoveMe();
		
	end

end

function Mission_TriggerPanzerIV()
	
	Cmd_Move(sg_panzer_iv_move_after_kill, mkr_pziv_move_new);
	Modify_Vulnerability(sg_panzer_iv_move_after_kill, 1.35);
	
	HintPoint_Add(eg_shreck01, true, "$08a0ac9c7e6144909909a02d533ce8aa:427", 1.7, HPAT_Hint);
	HintPoint_Add(eg_shreck02, true, "$08a0ac9c7e6144909909a02d533ce8aa:427", 1.7, HPAT_Hint);
	HintPoint_Add(eg_shreck03, true, "$08a0ac9c7e6144909909a02d533ce8aa:427", 1.7, HPAT_Hint);
	
	Objective_AddUIElements(OBJ_CHRUCHILLS, sg_panzer_iv_move_after_kill, true, "$08a0ac9c7e6144909909a02d533ce8aa:428", true, 2.7, nil, nil, nil);
	
	Rule_AddOneShot(Mission_DelayedPanzerIVIntel, 5);
	
end

function Mission_DelayedPanzerIVIntel()

	Util_StartIntel(EVENTS.CHURCHILL_FRONT);

	Rule_Add(Mission_ProgressLast);
	
end

function Mission_ProgressLast()

	if (SGroup_Count(sg_panzer_iv_move_after_kill) == 0) then
		
		Util_StartIntel(EVENTS.PANZERDOWN);
		
		World_IncreaseInteractionStage();
		
		Cmd_Move(sg_churchill_last, mkr_churchill_after_pziv, true);
		Cmd_SquadPath(sg_churchill_last, "circle_church", true, LOOP_NONE, false, 0, nil, true, true);
		Event_Proximity(Mission_FinishChurchillSupport, nil, sg_churchill_last, mkr_churchill_finish, 15, ANY, 0); 
		
		Rule_RemoveMe();
		
	end

end

function Mission_FinishChurchillSupport()

	Objective_Complete(OBJ_CHRUCHILLS, true);
	Objective_Start(OBJ_CLEARSOUTH, true);
	
	Util_StartIntel(EVENTS.CHURCHILL_FINISHED);
	
	g_hascapturedall = false;
	
	OBJ_CLEARSOUTH.m01 = Objective_AddUIElements(OBJ_CLEARSOUTH, eg_mun01, true, "$08a0ac9c7e6144909909a02d533ce8aa:439", true, 2.7, nil, nil, nil);
	OBJ_CLEARSOUTH.m02 = Objective_AddUIElements(OBJ_CLEARSOUTH, eg_mun02, true, "$08a0ac9c7e6144909909a02d533ce8aa:439", true, 2.7, nil, nil, nil);
	OBJ_CLEARSOUTH.m03 = Objective_AddUIElements(OBJ_CLEARSOUTH, eg_mun03, true, "$08a0ac9c7e6144909909a02d533ce8aa:439", true, 2.7, nil, nil, nil);
	
	Mission_InitializeAxisAISouth();
	
	Rule_AddInterval(Mission_HasClearedSouth, 5);
	Rule_AddOneShot(Mission_AIReinforcements, 5);
	Rule_AddOneShot(Mission_PlayerReinforcements, 20);
	
	Rule_Remove(Mission_AISupportUpdate);
	Rule_Remove(Mission_OnChurchillDeath);
	
end

function Mission_AIReinforcements()

	sg_cromwell01 = SGroup_CreateIfNotFound("sg_cromwell01");
	sg_cromwell02 = SGroup_CreateIfNotFound("sg_cromwell02");
	sg_cromwell03 = SGroup_CreateIfNotFound("sg_cromwell03");
	sg_churchill_croc = SGroup_CreateIfNotFound("sg_churchill_croc");

	Util_CreateSquads(player2, sg_cromwell01, BP_GetSquadBlueprint("cromwell_mk4_75mm_squad_mp"), mkr_player_offmap_reinforcement01, nil, 1);
	Util_CreateSquads(player2, sg_cromwell02, BP_GetSquadBlueprint("cromwell_mk4_75mm_squad_mp"), mkr_player_offmap_reinforcement02, nil, 1);
	Util_CreateSquads(player2, sg_cromwell03, BP_GetSquadBlueprint("cromwell_mk4_75mm_squad_mp"), mkr_player_offmap_reinforcement03, nil, 1);
	Util_CreateSquads(player2, sg_churchill_croc, BP_GetSquadBlueprint("churchill_crocodile_mp"), mkr_friendly_support, nil, 1);
	
	Modify_Vulnerability(sg_cromwell01, 1.35);
	Modify_Vulnerability(sg_cromwell01, 1.35);
	Modify_Vulnerability(sg_cromwell01, 1.35);
	Modify_Vulnerability(sg_churchill_croc, 2.25);
	
	Modify_UnitSpeed(sg_cromwell01, 0.8);
	Modify_UnitSpeed(sg_cromwell01, 0.8);
	Modify_UnitSpeed(sg_cromwell01, 0.8);
	Modify_UnitSpeed(sg_churchill_croc, 0.6);
	
	Cmd_Move(sg_cromwell01, mkr_cromwellmove01, true);
	Cmd_Move(sg_cromwell02, mkr_cromwellmove02, true);
	Cmd_Move(sg_cromwell03, mkr_cromwellmove03, true);
	
	Cmd_SquadPath(sg_cromwell01, "vehicle_drive", true, LOOP_TOGGLE_DIRECTION, true, 0, nil, true, true);
	Cmd_SquadPath(sg_cromwell02, "vehicle_drive", true, LOOP_TOGGLE_DIRECTION, true, 0, nil, true, true);
	Cmd_SquadPath(sg_cromwell03, "vehicle_drive", true, LOOP_TOGGLE_DIRECTION, true, 0, nil, true, false);
	Cmd_SquadPath(sg_churchill_croc, "vehicle_drive", true, LOOP_TOGGLE_DIRECTION, true, 0, nil, true, false);
	
	sg_tommy_section01 = SGroup_CreateIfNotFound("sg_tommy_section01");
	sg_tommy_section02 = SGroup_CreateIfNotFound("sg_tommy_section02");
	sg_tommy_section03 = SGroup_CreateIfNotFound("sg_tommy_section03");
	sg_tommy_section04 = SGroup_CreateIfNotFound("sg_tommy_section04");
	
	Util_CreateSquads(player2, sg_tommy_section01, BP_GetSquadBlueprint("tommy_squad_mp"), mkr_player_offmap_reinforcement01, nil, 2);
	Util_CreateSquads(player2, sg_tommy_section02, BP_GetSquadBlueprint("tommy_squad_mp"), mkr_player_offmap_reinforcement02, nil, 2);
	Util_CreateSquads(player2, sg_tommy_section03, BP_GetSquadBlueprint("tommy_squad_mp"), mkr_player_offmap_reinforcement03, nil, 2);
	Util_CreateSquads(player2, sg_tommy_section04, BP_GetSquadBlueprint("tommy_squad_mp"), mkr_friendly_support, nil, 2);
	
	Modify_Vulnerability(sg_tommy_section01, 1.25);
	Modify_Vulnerability(sg_tommy_section02, 1.25);
	Modify_Vulnerability(sg_tommy_section03, 1.25);
	Modify_Vulnerability(sg_tommy_section04, 1.25);
	
	Cmd_SquadPath(sg_tommy_section01, "infantry_walk", true, LOOP_TOGGLE_DIRECTION, true, 0, nil, false, true);
	Cmd_SquadPath(sg_tommy_section02, "infantry_walk", true, LOOP_TOGGLE_DIRECTION, true, 0, nil, false, true);
	Cmd_SquadPath(sg_tommy_section03, "infantry_walk", true, LOOP_TOGGLE_DIRECTION, true, 0, nil, false, false);
	Cmd_SquadPath(sg_tommy_section04, "infantry_walk", true, LOOP_TOGGLE_DIRECTION, true, 0, nil, false, false);
	
	Rule_AddOneShot(Mission_AIReinforcementDelayed, 2 * 60);

end

function Mission_AIReinforcementDelayed()

	Util_StartIntel(EVENTS.FIREFLY_ARRIVE);

	sg_firefly = SGroup_CreateIfNotFound("sg_firefly");
	sg_tommies_firefly = SGroup_CreateIfNotFound("sg_tommies_firefly");
	
	Util_CreateSquads(player2, sg_firefly, BP_GetSquadBlueprint("sherman_firefly_squad_mp"), mkr_tommy_spawn, nil, 1);
	Util_CreateSquads(player2, sg_tommies_firefly, BP_GetSquadBlueprint("tommy_squad_mp"), mkr_tommy_spawn, nil, 2);
	
	Modify_Vulnerability(sg_tommies_firefly, 1.25);
	Modify_Vulnerability(sg_firefly, 1.35);
	Modify_UnitSpeed(sg_firefly, 0.75);
	
	Cmd_SquadPath(sg_tommies_firefly, "infantry_walk", true, LOOP_TOGGLE_DIRECTION, true, 0, nil, false, true);
	Cmd_SquadPath(sg_firefly, "vehicle_drive", true, LOOP_TOGGLE_DIRECTION, true, 0, nil, false, true);
	
end

function Mission_PlayerReinforcements()

	local sg_tommies_player = SGroup_CreateIfNotFound("sg_tommies_player");
	local sg_bren_carrier = SGroup_CreateIfNotFound("sg_bren_carrier");
	
	Util_CreateSquads(player1, sg_tommies_player, BP_GetSquadBlueprint("tommy_squad_mp"), mkr_player_offmap_reinforcement03, mkr_church_assemble_point, 2);
	Util_CreateSquads(player1, sg_bren_carrier, BP_GetSquadBlueprint("universal_carrier_squad_mp"), mkr_player_offmap_reinforcement03, mkr_church_assemble_point, 1);

	Cmd_InstantUpgrade(sg_bren_carrier, BP_GetUpgradeBlueprint("universal_carrier_wasp_package_upgrade_mp"));
	
	Modify_Vulnerability(sg_player_commandos, 0.85);

end

function Mission_UpdateTerritoryPoints()
	
	if (OBJ_CLEARSOUTH.m01 ~= nil) then
		if (EGroup_IsCapturedByPlayer(eg_mun01, player1, ANY) == true) then
			Objective_RemoveUIElements(OBJ_CLEARSOUTH, OBJ_CLEARSOUTH.m01);
			OBJ_CLEARSOUTH.m01 = nil;
		end
	end
	
	if (OBJ_CLEARSOUTH.m02 ~= nil) then
		if (EGroup_IsCapturedByPlayer(eg_mun02, player1, ANY) == true) then
			Objective_RemoveUIElements(OBJ_CLEARSOUTH, OBJ_CLEARSOUTH.m02);
			OBJ_CLEARSOUTH.m02 = nil;
		end
	end
	
	if (OBJ_CLEARSOUTH.m03 ~= nil) then
		if (EGroup_IsCapturedByPlayer(eg_mun03, player1, ANY) == true) then
			Objective_RemoveUIElements(OBJ_CLEARSOUTH, OBJ_CLEARSOUTH.m03);
			OBJ_CLEARSOUTH.m03 = nil;
		end
	end
	
	if (OBJ_CLEARSOUTH.m01 == nil and OBJ_CLEARSOUTH.m02 == nil and OBJ_CLEARSOUTH.m03 == nil) then
		g_hascapturedall = true
	end
	
end

function Mission_InitializeAxisAISouth()

	t_posAxis = { mkr_axis_ai_south01, mkr_axis_ai_south02, mkr_axis_ai_south03, mkr_axis_ai_south04 };
	t_spawnAxis = { mkr_offmap_bridge01, mkr_offmap_bridge02 };
	t_unitsAxis = { BP_GetSquadBlueprint("panzerfusilier_squad_mp"), BP_GetSquadBlueprint("volksgrenadier_squad_mp"), BP_GetSquadBlueprint("obersoldaten_squad_mp"), BP_GetSquadBlueprint("fallschirmjager_squad_mp") };
	t_vehicleAxis = { BP_GetSquadBlueprint("panzer_ii_luchs_squad_mp"), BP_GetSquadBlueprint("panzer_iv_stubby_squad_mp"), BP_GetSquadBlueprint("panther_ausf_g_squad_mp") };
	t_unitSG = {};
	
	sg_axis_vehicles = SGroup_CreateIfNotFound("sg_axis_vehicles");
	
	for i=1, #t_posAxis do
		table.insert(t_unitSG, SGroup_CreateIfNotFound("sg_axis_city_defence_units"..i));
	end
	
	Rule_AddInterval(Mission_UpdateAxisAISouth, 25);

end

function Mission_UpdateAxisAISouth()

	for i=1, #t_unitSG do
		if (SGroup_Count(t_unitSG[i]) == 0) then
			local randunits = World_GetRand(1, 5);
			for j=1, randunits do
				local pos = Util_GetRandomPosition(t_posAxis[i], 40);
				Util_CreateSquads(player3, t_unitSG[i], t_unitsAxis[World_GetRand(1, #t_unitsAxis)], t_spawnAxis[World_GetRand(1, #t_spawnAxis)], pos, 1);
			end
		end
	end

	local dovehicle = World_GetRand(1, 20);
	
	if (dovehicle <= 3) then
		local pos = Util_GetRandomPosition(t_posAxis[World_GetRand(1, #t_posAxis)], 40);
		Util_CreateSquads(player3, sg_axis_vehicles, t_vehicleAxis[World_GetRand(1, #t_vehicleAxis)], t_spawnAxis[World_GetRand(1, #t_spawnAxis)], pos, 1);
	end
	
end

function Mission_HasClearedSouth()

	Mission_UpdateTerritoryPoints();

	if (SGroup_Count(sg_city_defence) == 0 and SGroup_Count(sg_city_defence_no_buildings) == 0 and g_hascapturedall == true) then
		
		Util_StartIntel(EVENTS.CROSSBRIDGE);
		
		Objective_Complete(OBJ_CLEARSOUTH, true);
		Objective_Start(OBJ_CROSS, true);
		
		World_IncreaseInteractionStage();
		
		Objective_AddUIElements(OBJ_CROSS, mkr_bridgecross01, true, "$08a0ac9c7e6144909909a02d533ce8aa:445", true, 2.7, nil, nil, nil);
		Objective_AddUIElements(OBJ_CROSS, mkr_bridgecross02, true, "$08a0ac9c7e6144909909a02d533ce8aa:445", true, 2.7, nil, nil, nil);
		Objective_AddUIElements(OBJ_CROSS, mkr_bridgecross03, true, "$08a0ac9c7e6144909909a02d533ce8aa:445", true, 2.7, nil, nil, nil);
		Objective_AddUIElements(OBJ_CROSS, mkr_bridgecross04, true, "$08a0ac9c7e6144909909a02d533ce8aa:445", true, 2.7, nil, nil, nil);
		
		Mission_MoveAIOnSouth();
		
		Rule_AddInterval(Mission_HasCrossedBridge, 5);
		
		--Rule_Remove(Mission_UpdateAxisAISouth);
		Rule_RemoveMe();
		
	end

end

function Mission_HasCrossedBridge()

	if (Player_AreSquadsNearMarker(player1, mkr_bridgecross01) == true or Player_AreSquadsNearMarker(player1, mkr_bridgecross02) == true 
		or Player_AreSquadsNearMarker(player1, mkr_bridgecross03) == true or Player_AreSquadsNearMarker(player1, mkr_bridgecross04) == true) then
		
		Util_StartIntel(EVENTS.CROSSED);
		
		Objective_Complete(OBJ_CROSS, true);
		Objective_Start(OBJ_ARTY_BATTLE, false);
		
		Rule_AddOneShot(Mission_FortifyNorth, 20);
		Rule_Add(Mission_BeginNorthernSection);
		
		Rule_RemoveMe();
		
	end

end

function Mission_BombardBridges()

	Player_AddAbility(player4, BP_GetAbilityBlueprint("allied_strategic_bombing"));
	Player_AddAbility(player4, BP_GetAbilityBlueprint("stuka_bombing_strike"));
	Player_AddAbility(player4, BP_GetAbilityBlueprint("stuka_fragmentation_bomb"));
	Player_AddAbility(player4, BP_GetAbilityBlueprint("stuka_incendiary_bombs"));
	Player_AddAbility(player4, BP_GetAbilityBlueprint("stuka_air_recon"));
	Player_AddAbility(player4, BP_GetAbilityBlueprint("stuka_strafing_run"));
	Player_AddAbility(player4, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT);
	
	t_crossings = { mkr_bridgecross01, mkr_bridgecross02, mkr_bridgecross03, mkr_bridgecross04 };
	
	for i=1, #t_crossings do
		
		Cmd_Ability(player4, BP_GetAbilityBlueprint("allied_strategic_bombing"), t_crossings[i], nil, true, true);
		Cmd_Ability(player4, BP_GetAbilityBlueprint("stuka_bombing_strike"), t_crossings[i], nil, true, true);
		Cmd_Ability(player4, BP_GetAbilityBlueprint("stuka_fragmentation_bomb"), t_crossings[i], nil, true, true);
		Cmd_Ability(player4, BP_GetAbilityBlueprint("stuka_incendiary_bombs"), t_crossings[i], nil, true, true);
		
	end
	
end

function Mission_MeetAtChurch()

	SGroup_SetPlayerOwner(Player_GetSquads(player1), player2);
	Cmd_Stop(Player_GetSquads(player2));
	
	sg_player_newsquads = SGroup_CreateIfNotFound("sg_player_newsquads");
	
	Util_CreateSquads(player1, sg_player_newsquads, BP_GetSquadBlueprint("tommy_squad_mp"), mkr_churchill_finish, mkr_church_assemble_point, 3);
	Util_CreateSquads(player1, sg_player_newsquads, BP_GetSquadBlueprint("sapper_squad_mp"), mkr_churchill_finish, mkr_church_assemble_point, 1);
	
end

function Mission_FortifyNorth()

	sg_pak1 = SGroup_CreateIfNotFound("sg_pak1");
	sg_pak2 = SGroup_CreateIfNotFound("sg_pak2");

	Util_CreateSquads(player4, sg_pak1, BP_GetSquadBlueprint("pak43_88mm_at_gun_squad_mp"), mkr_pak01, nil, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player4, sg_pak2, BP_GetSquadBlueprint("pak43_88mm_at_gun_squad_mp"), mkr_pak02, nil, 1, nil, false, nil, nil, nil);

	sg_north_defence = SGroup_CreateIfNotFound("sg_north_defence");
	
	Util_SpawnGarrison(player3, eg_north_city_structs, sg_north_defence, BP_GetSquadBlueprint("panzerfusilier_squad_mp"), 1);
	Util_SpawnGarrison(player3, eg_north_city_structs, sg_north_defence, BP_GetSquadBlueprint("assault_pioneer_squad_mp"), 1);
	
end

function Mission_MoveAIOnSouth()

	if (SGroup_Count(sg_axis_vehicles) > 0) then
		Cmd_Retreat(sg_axis_vehicles);
	end
	
	for i=1, #t_unitSG do
		if (SGroup_Count(t_unitSG[i]) > 0) then
			Cmd_Retreat(t_unitSG[i]);
		end
	end

	Cmd_Move(sg_tommy_section01, mkr_ally_infantry01);
	Cmd_Move(sg_tommy_section02, mkr_ally_infantry02);
	Cmd_Move(sg_tommy_section03, mkr_ally_infantry03);
	Cmd_Move(sg_tommy_section04, mkr_ally_infantry04);
	Cmd_Move(sg_tommies_firefly, mkr_ally_infantry05);
	
	Cmd_Move(sg_cromwell01, mkr_ally_bonusvehicle01);
	Cmd_Move(sg_cromwell02, mkr_ally_bonusvehicle02);
	Cmd_Move(sg_cromwell03, mkr_ally_bonusvehicle03);
	Cmd_Move(sg_churchill_croc, mkr_ally_bonusvehicle04);
	
	Cmd_Stop(sg_firefly);
	
	Rule_Remove(Mission_UpdateAxisAISouth);
	
end

function Mission_BeginNorthernSection()

	if (Event_IsAnyRunning() == false) then

		Objective_Start(OBJ_REPAIR_BRIDGE, true);

		Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("brit_repair_ability_sappers_mp"), ITEM_LOCKED);
		Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("brit_repair_ews_ability_sappers_mp"), ITEM_LOCKED);

		g_manpowercap = 1250;
		g_munitioncap = 750;
		
		EGroup_Kill(eg_bridge01k);
		EGroup_Kill(eg_bridge02k);
		EGroup_Kill(eg_bridge03k);
		
		Player_AddResource(player1, RT_Munition, t_difficulty.resourcebonus_a);
		Player_AddResource(player1, RT_Manpower, t_difficulty.resourcebonus_b);
		Player_SetPopCapOverride(player1, 125);

		Rule_AddOneShot(Mission_BoforGuide, 5);

		Rule_RemoveMe();
		
	end
	
end

function Mission_BoforGuide()

	t_boforhints = 
	{
		{hp = HintPoint_Add(mkr_bofor01, true, "$08a0ac9c7e6144909909a02d533ce8aa:450", 2.5, HPAT_FormationSetup, "Icons_buildings_building_british_bofors"), constructed = false, marker = mkr_bofor01},
		{hp = HintPoint_Add(mkr_bofor02, true, "$08a0ac9c7e6144909909a02d533ce8aa:450", 2.5, HPAT_FormationSetup, "Icons_buildings_building_british_bofors"), constructed = false, marker = mkr_bofor02},
		{hp = HintPoint_Add(mkr_bofor03, true, "$08a0ac9c7e6144909909a02d533ce8aa:450", 2.5, HPAT_FormationSetup, "Icons_buildings_building_british_bofors"), constructed = false, marker = mkr_bofor03},
	};
	
	Util_StartIntel(EVENTS.BOFORSETUP);

	local eg_hidebuilding = EGroup_CreateIfNotFound("sg_hidebuilding");
	Util_CreateEntities(player1, eg_hidebuilding, BP_GetEntityBlueprint("british_building_1_mp"), mkr_baseplayer, 1); 
	EGroup_Hide(eg_hidebuilding, true);
	
	Player_SetResource(player1, RT_Fuel, 100);
	
	Rule_Add(Mission_BeginRaids);
	
end

function Mission_BeginRaids()

	if (Event_IsAnyRunning() == false) then
		
		Rule_AddInterval(Mission_AmbientReconRuns, 45);
		Rule_AddInterval(Mission_AmbientArtillery, 15);
		Mission_InitializeAmbientTrucks();
		
		Rule_AddInterval(Mission_IsConstructingBoforOnPoint, 10);
		Rule_AddOneShot(Mission_TriggerRepaircrew, 20);
		
		Production_SPAWN = mkr_friendly_support;
		Production_GOTO = mkr_church_assemble_point;
		Production_Initialize();
		
		Rule_RemoveMe();
		
	end

end

function Mission_IsConstructingBoforOnPoint()

	if (Player_HasBuildingUnderConstruction(player1, BP_GetEntityBlueprint("brit_bofors_40mm_autocannon_mp")) == true) then
		for i=1, #t_boforhints do
			if (t_boforhints[i].constructed == false) then
				local eg_entities = EGroup_CreateIfNotFound("eg_entities");
				Player_GetAllEntitiesNearMarker(player1, eg_entities, t_boforhints[i].marker, 10);
				EGroup_Filter(eg_entities, BP_GetEntityBlueprint("brit_bofors_40mm_autocannon_mp"), FILTER_KEEP);
				if (EGroup_Count(eg_entities) > 0) then
					HintPoint_Remove(t_boforhints[i].hp);
					t_boforhints[i].constructed = true;
				end
			end
		end
	end

end

function Mission_RemoveBoforHints()

	for i=1, #t_boforhints do
		if (t_boforhints[i].constructed == false) then
			HintPoint_Remove(t_boforhints[i].hp);
		end
	end
	
	Rule_Remove(Mission_IsConstructingBoforOnPoint);

end

function Mission_TriggerRepaircrew()

	sg_repair_universal = SGroup_CreateIfNotFound("sg_repair_universal");
	sg_repair_crew = SGroup_CreateIfNotFound("sg_repair_crew");
	
	Util_CreateSquads(player2, sg_repair_universal, BP_GetSquadBlueprint("universal_carrier_squad_mp"), mkr_ambient_convoy_spawn, mkr_universal_carrier_drop, 1);
	Util_CreateSquads(player2, sg_repair_crew, BP_GetSquadBlueprint("sapper_squad_mp"), sg_repair_universal, nil, 1);
	
	Cmd_EjectOccupants(sg_repair_universal, mkr_sapper_out, true);
	Cmd_MoveToAndDespawn(sg_repair_universal, mkr_friendly_support, true);
	
	Event_Proximity(Mission_SappersAreOut, nil, sg_repair_crew, mkr_sapper_out, 5, ANY, 15);
	
	Util_StartIntel(EVENTS.REPAIRARRIVED);
	
	Rule_Remove(Mission_AmbientReconRuns);
	Rule_AddInterval(Mission_AmbientAirRaids, 30);

end

function Mission_SappersAreOut()

	t_bridgetypes = {
		BP_GetEntityBlueprint("bridge_35_stavelot"),
		BP_GetEntityBlueprint("bridge_35_stavelot_rebuilt"),
		BP_GetEntityBlueprint("bridge_35_stavelot_wrecked"),
	};

	-- Just to make sure
	if (EGroup_Count(eg_repair_bridge) == 0) then -- populate the EG
		
		World_GetNeutralEntitiesNearMarker(eg_repair_bridge, mkr_bridgecross01);
		EGroup_Filter(eg_repair_bridge, t_bridgetypes, FILTER_KEEP);
		
	end

	Cmd_Ability(sg_repair_crew, BP_GetAbilityBlueprint("brit_repair_ability_sappers_mp"), eg_repair_bridge, nil, true, false);
	
	Rule_AddInterval(Mission_HasRepairedBridge, 5);
	
end

function Mission_AmbientReconRuns()

	for i=1, #t_crossings do
		local rand = World_GetRand(1, 5);
		if (rand >= 3) then
			Cmd_Ability(player4, BP_GetAbilityBlueprint("stuka_air_recon"), t_crossings[i], nil, true, true);
		end
	end

end

function Mission_AmbientArtillery()

	for i=1, #t_boforhints do
		local rand = World_GetRand(1, 5);
		if (rand >= 3) then
			local pos = Util_GetRandomPosition(t_boforhints[i].marker, 60);
			Cmd_Ability(player4, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT, pos, nil, true, true);
		end
	end

end

function Mission_AmbientAirRaids()

	for i=1, #t_boforhints do
		local rand = World_GetRand(1, 5);
		if (rand >= 3) then
			Cmd_Ability(player4, BP_GetAbilityBlueprint("stuka_strafing_run"), t_boforhints[i].marker, nil, true, true);
		end
	end

end

function Mission_InitializeAmbientTrucks()
	
	t_ambient_convoy_vehicles = {BP_GetSquadBlueprint("aec_armoured_car_squad_mp"), BP_GetSquadBlueprint("m3_halftrack_squad__resupply_mp"), BP_GetSquadBlueprint("universal_carrier_squad_mp")};
	ambientconvoy_spawner = mkr_ambient_convoy_spawn;
	ambientconvoy_exit = mkr_ambient_convoy_despawn;
	
	sg_convoy_vehicle = SGroup_CreateIfNotFound("sg_convoy_vehicle");
	
	g_awardtime = 10;
	g_awardcounter = 1;
	
	t_rewards = {
		
		{
			
			name = "Resource Bonus (Manpower)",
			
			Callback = function()
				Player_AddResource(player1, RT_Manpower, t_difficulty.resourcebonus_b);
			end,
			
		},
		
		{
			
			name = "Resource Bonus (Munition)",
			
			Callback = function()
				Player_AddResource(player1, RT_Munition, t_difficulty.resourcebonus_a);
			end,
			
		},
		
	}
	
	Rule_AddInterval(Mission_AmbientTrucks, 35);
	
end

function Mission_AmbientTrucks() -- Note: this will randomly gift units (or other stuff) to the player.

	if (g_awardcounter == g_awardtime) then
		t_rewards[World_GetRand(1, #t_rewards)].Callback();
		g_awardcounter = 0;
	end
	
	Util_CreateSquads(player2, sg_convoy_vehicle, t_ambient_convoy_vehicles[World_GetRand(1, #t_ambient_convoy_vehicles)], ambientconvoy_spawner, nil, 1, nil, false, nil, nil, nil);
	Cmd_SquadPath(sg_convoy_vehicle, "ambient_convoy", true, LOOP_NONE, false, 0, ambientconvoy_exit, false, true); 
	
	g_awardcounter = g_awardcounter + 1;

end

function Mission_HasRepairedBridge()

	if (EGroup_Count(eg_repair_bridge) == 0 or EGroup_GetAvgHealth(eg_repair_bridge) >= 0.9) then
		
		Mission_RemoveBoforHints();
		
		Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("brit_repair_ability_sappers_mp"), ITEM_UNLOCKED);
		Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("brit_repair_ews_ability_sappers_mp"), ITEM_UNLOCKED);
		
		World_IncreaseInteractionStage();
		
		Objective_Complete(OBJ_REPAIR_BRIDGE, true);
		Util_StartIntel(EVENTS.BRIDGEREPAIR);
		
		Rule_Add(Mission_OnRepairIntelDone);
		Rule_Remove(Mission_AmbientArtillery);
		Rule_Remove(Mission_AmbientAirRaids);
		Rule_RemoveMe();
		
	end

	Mission_AreSappersDead();
	
end

function Mission_AreSappersDead()

	if (SGroup_Count(sg_repair_crew) == 0) then
		Codiex_EndGame(Player_GetRaceName(player1), false);
	end

end

function Mission_OnRepairIntelDone()

	if (Event_IsAnyRunning() == false) then
		
		Objective_Start(OBJ_CROSS_BRIDGE, true);
	
		Event_PlayerCanSeeElement(Mission_JagdtigerSpotted, nil, player1, sg_jagdtiger, ANY, 0); 
	
		Mission_InitializeNorthernUI();
		Rule_AddInterval(Mission_HasClearedNorth, 5);
		
		Rule_RemoveMe();
		
	end

end

function Mission_JagdtigerSpotted()
	OBJ_CROSS_BRIDGE.jagd = Objective_AddUIElements(OBJ_CROSS_BRIDGE, sg_jagdtiger, true, "$08a0ac9c7e6144909909a02d533ce8aa:461", true, 2.7, nil, nil, nil);
end

function Mission_InitializeNorthernUI()

	OBJ_CROSS_BRIDGE.m01 = Objective_AddUIElements(OBJ_CROSS_BRIDGE, eg_mun01n, true, "$08a0ac9c7e6144909909a02d533ce8aa:439", true, 2.7, nil, nil, nil);
	OBJ_CROSS_BRIDGE.m02 = Objective_AddUIElements(OBJ_CROSS_BRIDGE, eg_mun02n, true, "$08a0ac9c7e6144909909a02d533ce8aa:439", true, 2.7, nil, nil, nil);
	OBJ_CROSS_BRIDGE.m03 = Objective_AddUIElements(OBJ_CROSS_BRIDGE, eg_mun03n, true, "$08a0ac9c7e6144909909a02d533ce8aa:439", true, 2.7, nil, nil, nil);

	g_allnorth = false;
	
end

function Mission_UpdateNorthernUI()

	if (OBJ_CROSS_BRIDGE.m01 ~= nil) then
		if (EGroup_IsCapturedByPlayer(eg_mun01n, player1, ANY) == true) then
			Objective_RemoveUIElements(OBJ_CROSS_BRIDGE, OBJ_CROSS_BRIDGE.m01);
			OBJ_CROSS_BRIDGE.m01 = nil;
		end
	end
	
	if (OBJ_CROSS_BRIDGE.m02 ~= nil) then
		if (EGroup_IsCapturedByPlayer(eg_mun02n, player1, ANY) == true) then
			Objective_RemoveUIElements(OBJ_CROSS_BRIDGE, OBJ_CROSS_BRIDGE.m02);
			OBJ_CROSS_BRIDGE.m02 = nil;
		end
	end
	
	if (OBJ_CROSS_BRIDGE.m03 ~= nil) then
		if (EGroup_IsCapturedByPlayer(eg_mun03n, player1, ANY) == true) then
			Objective_RemoveUIElements(OBJ_CROSS_BRIDGE, OBJ_CROSS_BRIDGE.m03);
			OBJ_CROSS_BRIDGE.m03 = nil;
		end
	end
	
	if (OBJ_CROSS_BRIDGE.m01 == nil and OBJ_CROSS_BRIDGE.m02 == nil and OBJ_CROSS_BRIDGE.m03 == nil) then
		g_allnorth = true
	end

end

function Mission_HasClearedNorth()

	Mission_UpdateNorthernUI();
	
	if (g_allnorth == true and SGroup_Count(sg_jagdtiger) == 0 and SGroup_Count(sg_tanks) == 0) then
		
		Util_StartIntel(EVENTS.NORTHCLEAR);
		
		Objective_Complete(OBJ_CROSS_BRIDGE, true);
		Objective_Start(OBJ_DEFEND_POSITION, true);
		
		Mission_StartDefence();
		
		Rule_RemoveMe();
		
	end

end

function Mission_StartDefence()

	Timer_Start("___DEFENCETIMER", 3 * 60);

	Player_AddResource(player1, RT_Fuel, 500);
	
	Rule_Add(Mission_UpdatePrepUI);

end

function Mission_UpdatePrepUI()

	Obj_ShowProgress2("$08a0ac9c7e6144909909a02d533ce8aa:462", Timer_GetRemaining("___DEFENCETIMER") / (2 * 60));

	if (Timer_GetRemaining("___DEFENCETIMER") == 0) then
		
		Obj_HideProgress();
		
		Objective_UpdateText(OBJ_DEFEND_POSITION, "$08a0ac9c7e6144909909a02d533ce8aa:420", "$08a0ac9c7e6144909909a02d533ce8aa:420", true);
		Util_StartIntel(EVENTS.PREPOVER);
		Rule_AddOneShot(Mission_BeginDefence, 12);
		
		Rule_RemoveMe();
		
	end
	
end

function Mission_BeginDefence()

	t_assault_infantry = {};
	t_assault_infantry["Infantry01"] = BP_GetSquadBlueprint("assault_pioneer_squad_mp");
	t_assault_infantry["Infantry02"] = BP_GetSquadBlueprint("fallschirmjager_squad_mp");
	t_assault_infantry["Infantry03"] = BP_GetSquadBlueprint("jaeger_light_infantry_recon_squad_mp");
	t_assault_infantry["Infantry04"] = BP_GetSquadBlueprint("obersoldaten_squad_mp");
	t_assault_infantry["Infantry05"] = BP_GetSquadBlueprint("panzerfusilier_squad_mp");
	t_assault_infantry["Infantry06"] = BP_GetSquadBlueprint("urban_assault_light_infantry");
	t_assault_infantry["Infantry07"] = BP_GetSquadBlueprint("volksgrenadier_squad_mp");
	
	t_assault_vehicle = {};
	t_assault_vehicle["Vehicle01"] = BP_GetSquadBlueprint("jagdpanzer_tank_destroyer_squad_mp");
	t_assault_vehicle["Vehicle02"] = BP_GetSquadBlueprint("king_tiger_squad_mp");
	t_assault_vehicle["Vehicle03"] = BP_GetSquadBlueprint("ostwind_squad_westgerman_mp");
	t_assault_vehicle["Vehicle04"] = BP_GetSquadBlueprint("panther_ausf_g_squad_mp");
	t_assault_vehicle["Vehicle05"] = BP_GetSquadBlueprint("panzer_ii_luchs_squad_mp");
	t_assault_vehicle["Vehicle06"] = BP_GetSquadBlueprint("panzer_iv_ausf_j_battle_group_mp");
	t_assault_vehicle["Vehicle07"] = BP_GetSquadBlueprint("armored_car_sdkfz_234_squad_mp");
	t_assault_vehicle["Vehicle08"] = BP_GetSquadBlueprint("sturmtiger_squad_mp");
	
	t_spawners_north_assault = {mkr_defence_spawner01, mkr_defence_spawner02, mkr_defence_spawner03, mkr_defence_spawner04};
	
	sg_totalassault = SGroup_CreateIfNotFound("sg_totalassault");
	
	g_maxspawned = 0;
	g_currentwave = 0;
	
	g_wave1_display = "$08a0ac9c7e6144909909a02d533ce8aa:465";
	g_wave2_display = "$08a0ac9c7e6144909909a02d533ce8aa:466";
	g_wave3_display = "$08a0ac9c7e6144909909a02d533ce8aa:467";
	g_wave4_display = "$08a0ac9c7e6144909909a02d533ce8aa:468";
	g_wave5_display = "$08a0ac9c7e6144909909a02d533ce8aa:469";
	g_wave6_display = "$08a0ac9c7e6144909909a02d533ce8aa:470";
	g_display = g_wave1_display;
	
	if (EGroup_Count(eg_repair_bridge) == 0) then -- populate the EG
		
		World_GetNeutralEntitiesNearMarker(eg_repair_bridge, mkr_bridgecross01);
		EGroup_Filter(eg_repair_bridge, t_bridgetypes, FILTER_KEEP);
		
	end
	
	Rule_AddInterval(Mission_CheckBridgeSafety, 5);
	
	Mission_StartWave01();

end

function Mission_StartWave01()

	local sg_infantry1 = SGroup_CreateIfNotFound("sg_infantry1");
	local sg_infantry2 = SGroup_CreateIfNotFound("sg_infantry2");
	local sg_infantry3 = SGroup_CreateIfNotFound("sg_infantry3");

	Util_CreateSquads(player3, sg_infantry1, t_assault_infantry["Infantry05"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[1], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry2, t_assault_infantry["Infantry05"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[2], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry3, t_assault_infantry["Infantry05"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[3], 40), 1, nil, true, nil, nil, nil);
	
	Cmd_InstantUpgrade(sg_infantry1, BP_GetUpgradeBlueprint("panzerfusilier_g43"), 1);
	Cmd_InstantUpgrade(sg_infantry2, BP_GetUpgradeBlueprint("panzerfusilier_g43"), 1);
	Cmd_InstantUpgrade(sg_infantry3, BP_GetUpgradeBlueprint("panzerfusilier_g43"), 1);
	
	SGroup_IncreaseVeterancyRank(sg_infantry1, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry2, 4, true);
	SGroup_IncreaseVeterancyRank(sg_infantry3, 3, true);
	
	SGroup_AddGroup(sg_totalassault, sg_infantry1);
	SGroup_AddGroup(sg_totalassault, sg_infantry2);
	SGroup_AddGroup(sg_totalassault, sg_infantry3);
	
	local sg_vehicle01 = SGroup_CreateIfNotFound("sg_vehicle01");
	local sg_vehicle02 = SGroup_CreateIfNotFound("sg_vehicle02");
	local sg_vehicle03 = SGroup_CreateIfNotFound("sg_vehicle03");
	local sg_vehicle04 = SGroup_CreateIfNotFound("sg_vehicle04");
	
	Util_CreateSquads(player3, sg_vehicle01, t_assault_vehicle["Vehicle02"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[1], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_vehicle02, t_assault_vehicle["Vehicle06"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[2], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_vehicle03, t_assault_vehicle["Vehicle04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[3], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_vehicle04, t_assault_vehicle["Vehicle02"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[4], 40), 1, nil, true, nil, nil, nil);
	
	SGroup_IncreaseVeterancyRank(sg_vehicle01, 5, true);
	SGroup_IncreaseVeterancyRank(sg_vehicle02, 4, true);
	SGroup_IncreaseVeterancyRank(sg_vehicle03, 4, true);
	SGroup_IncreaseVeterancyRank(sg_vehicle04, 5, true);
	
	SGroup_AddGroup(sg_totalassault, sg_vehicle01);
	SGroup_AddGroup(sg_totalassault, sg_vehicle02);
	SGroup_AddGroup(sg_totalassault, sg_vehicle03);
	SGroup_AddGroup(sg_totalassault, sg_vehicle04);
	
	g_maxspawned = SGroup_Count(sg_totalassault);
	Rule_Add(Mission_WaveUpdate);

end

function Mission_StartWave02()

	local sg_infantry1 = SGroup_CreateIfNotFound("sg_infantry1");
	local sg_infantry2 = SGroup_CreateIfNotFound("sg_infantry2");
	local sg_infantry3 = SGroup_CreateIfNotFound("sg_infantry3");
	local sg_infantry4 = SGroup_CreateIfNotFound("sg_infantry4");
	local sg_infantry5 = SGroup_CreateIfNotFound("sg_infantry5");
	local sg_infantry6 = SGroup_CreateIfNotFound("sg_infantry6");

	Util_CreateSquads(player3, sg_infantry1, t_assault_infantry["Infantry07"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[1], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry2, t_assault_infantry["Infantry07"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[2], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry3, t_assault_infantry["Infantry07"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[3], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry4, t_assault_infantry["Infantry07"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[1], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry5, t_assault_infantry["Infantry07"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[2], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry6, t_assault_infantry["Infantry07"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[3], 40), 1, nil, true, nil, nil, nil);
	
	Cmd_InstantUpgrade(sg_infantry1, BP_GetUpgradeBlueprint("assault_pioneer_panzerschreck_upgrade"), 1);
	Cmd_InstantUpgrade(sg_infantry2, BP_GetUpgradeBlueprint("assault_pioneer_panzerschreck_upgrade"), 1);
	Cmd_InstantUpgrade(sg_infantry3, BP_GetUpgradeBlueprint("assault_pioneer_panzerschreck_upgrade"), 1);
	
	SGroup_IncreaseVeterancyRank(sg_infantry1, 1, true);
	SGroup_IncreaseVeterancyRank(sg_infantry2, 1, true);
	SGroup_IncreaseVeterancyRank(sg_infantry3, 1, true);
	SGroup_IncreaseVeterancyRank(sg_infantry4, 4, true);
	SGroup_IncreaseVeterancyRank(sg_infantry5, 4, true);
	SGroup_IncreaseVeterancyRank(sg_infantry6, 4, true);
	
	SGroup_AddGroup(sg_totalassault, sg_infantry1);
	SGroup_AddGroup(sg_totalassault, sg_infantry2);
	SGroup_AddGroup(sg_totalassault, sg_infantry3);
	SGroup_AddGroup(sg_totalassault, sg_infantry4);
	SGroup_AddGroup(sg_totalassault, sg_infantry5);
	SGroup_AddGroup(sg_totalassault, sg_infantry6);
	
	local sg_vehicle01 = SGroup_CreateIfNotFound("sg_vehicle01");
	
	Util_CreateSquads(player3, sg_vehicle01, t_assault_vehicle["Vehicle07"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[3], 40), 1, nil, true, nil, nil, nil);
	
	SGroup_IncreaseVeterancyRank(sg_vehicle01, 5, true);
	
	SGroup_AddGroup(sg_totalassault, sg_vehicle01);

	g_maxspawned = SGroup_Count(sg_totalassault);
	g_display = g_wave2_display;

end

function Mission_StartWave03()

	local sg_infantry1 = SGroup_CreateIfNotFound("sg_infantry1");
	local sg_infantry2 = SGroup_CreateIfNotFound("sg_infantry2");
	local sg_infantry3 = SGroup_CreateIfNotFound("sg_infantry3");
	local sg_infantry4 = SGroup_CreateIfNotFound("sg_infantry4");
	local sg_infantry5 = SGroup_CreateIfNotFound("sg_infantry5");
	local sg_infantry6 = SGroup_CreateIfNotFound("sg_infantry6");
	local sg_infantry7 = SGroup_CreateIfNotFound("sg_infantry7");
	local sg_infantry8 = SGroup_CreateIfNotFound("sg_infantry8");

	Util_CreateSquads(player3, sg_infantry1, t_assault_infantry["Infantry01"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[1], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry2, t_assault_infantry["Infantry01"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[2], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry3, t_assault_infantry["Infantry02"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[3], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry4, t_assault_infantry["Infantry02"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[1], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry5, t_assault_infantry["Infantry01"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[2], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry6, t_assault_infantry["Infantry01"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[3], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry7, t_assault_infantry["Infantry02"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[2], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry8, t_assault_infantry["Infantry02"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[3], 40), 1, nil, true, nil, nil, nil);
	
	SGroup_IncreaseVeterancyRank(sg_infantry1, 5, true);
	SGroup_IncreaseVeterancyRank(sg_infantry2, 5, true);
	SGroup_IncreaseVeterancyRank(sg_infantry3, 5, true);
	SGroup_IncreaseVeterancyRank(sg_infantry4, 5, true);
	SGroup_IncreaseVeterancyRank(sg_infantry5, 4, true);
	SGroup_IncreaseVeterancyRank(sg_infantry6, 4, true);
	SGroup_IncreaseVeterancyRank(sg_infantry7, 4, true);
	SGroup_IncreaseVeterancyRank(sg_infantry8, 4, true);
	
	SGroup_AddGroup(sg_totalassault, sg_infantry1);
	SGroup_AddGroup(sg_totalassault, sg_infantry2);
	SGroup_AddGroup(sg_totalassault, sg_infantry3);
	SGroup_AddGroup(sg_totalassault, sg_infantry4);
	SGroup_AddGroup(sg_totalassault, sg_infantry5);
	SGroup_AddGroup(sg_totalassault, sg_infantry6);
	SGroup_AddGroup(sg_totalassault, sg_infantry7);
	SGroup_AddGroup(sg_totalassault, sg_infantry8);

	local sg_vehicle01 = SGroup_CreateIfNotFound("sg_vehicle01");
	local sg_vehicle02 = SGroup_CreateIfNotFound("sg_vehicle02");
	local sg_vehicle03 = SGroup_CreateIfNotFound("sg_vehicle03");
	local sg_vehicle04 = SGroup_CreateIfNotFound("sg_vehicle04");
	
	Util_CreateSquads(player3, sg_vehicle01, t_assault_vehicle["Vehicle05"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[1], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_vehicle02, t_assault_vehicle["Vehicle06"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[2], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_vehicle03, t_assault_vehicle["Vehicle06"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[3], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_vehicle04, t_assault_vehicle["Vehicle05"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[4], 40), 1, nil, true, nil, nil, nil);
	
	SGroup_IncreaseVeterancyRank(sg_vehicle01, 3, true);
	SGroup_IncreaseVeterancyRank(sg_vehicle02, 3, true);
	SGroup_IncreaseVeterancyRank(sg_vehicle03, 3, true);
	SGroup_IncreaseVeterancyRank(sg_vehicle04, 3, true);
	
	SGroup_AddGroup(sg_totalassault, sg_vehicle01);
	SGroup_AddGroup(sg_totalassault, sg_vehicle02);
	SGroup_AddGroup(sg_totalassault, sg_vehicle03);
	SGroup_AddGroup(sg_totalassault, sg_vehicle04);
	
	g_maxspawned = SGroup_Count(sg_totalassault);
	g_display = g_wave3_display;

end

function Mission_StartWave04()

	local sg_infantry1 = SGroup_CreateIfNotFound("sg_infantry1");
	local sg_infantry2 = SGroup_CreateIfNotFound("sg_infantry2");
	local sg_infantry3 = SGroup_CreateIfNotFound("sg_infantry3");
	local sg_infantry4 = SGroup_CreateIfNotFound("sg_infantry4");
	local sg_infantry5 = SGroup_CreateIfNotFound("sg_infantry5");
	local sg_infantry6 = SGroup_CreateIfNotFound("sg_infantry6");
	local sg_infantry7 = SGroup_CreateIfNotFound("sg_infantry7");
	local sg_infantry8 = SGroup_CreateIfNotFound("sg_infantry8");
	local sg_infantry9 = SGroup_CreateIfNotFound("sg_infantry9");
	local sg_infantry10 = SGroup_CreateIfNotFound("sg_infantry10");

	Util_CreateSquads(player3, sg_infantry1, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[1], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry2, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[2], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry3, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[3], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry4, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[1], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry5, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[2], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry6, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[3], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry7, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[2], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry8, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[3], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry9, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[2], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry10, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[3], 40), 1, nil, true, nil, nil, nil);
	
	SGroup_IncreaseVeterancyRank(sg_infantry1, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry2, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry3, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry4, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry5, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry6, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry7, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry8, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry9, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry10, 3, true);
	
	SGroup_AddGroup(sg_totalassault, sg_infantry1);
	SGroup_AddGroup(sg_totalassault, sg_infantry2);
	SGroup_AddGroup(sg_totalassault, sg_infantry3);
	SGroup_AddGroup(sg_totalassault, sg_infantry4);
	SGroup_AddGroup(sg_totalassault, sg_infantry5);
	SGroup_AddGroup(sg_totalassault, sg_infantry6);
	SGroup_AddGroup(sg_totalassault, sg_infantry7);
	SGroup_AddGroup(sg_totalassault, sg_infantry8);
	SGroup_AddGroup(sg_totalassault, sg_infantry9);
	SGroup_AddGroup(sg_totalassault, sg_infantry10);

	local sg_vehicle01 = SGroup_CreateIfNotFound("sg_vehicle01");
	local sg_vehicle02 = SGroup_CreateIfNotFound("sg_vehicle02");
	local sg_vehicle03 = SGroup_CreateIfNotFound("sg_vehicle03");
	local sg_vehicle04 = SGroup_CreateIfNotFound("sg_vehicle04");
	local sg_vehicle05 = SGroup_CreateIfNotFound("sg_vehicle05");
	local sg_vehicle06 = SGroup_CreateIfNotFound("sg_vehicle06");
	local sg_vehicle07 = SGroup_CreateIfNotFound("sg_vehicle07");
	
	Util_CreateSquads(player3, sg_vehicle01, t_assault_vehicle["Vehicle03"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[1], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_vehicle02, t_assault_vehicle["Vehicle04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[2], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_vehicle03, t_assault_vehicle["Vehicle05"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[3], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_vehicle04, t_assault_vehicle["Vehicle03"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[4], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_vehicle05, t_assault_vehicle["Vehicle04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[1], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_vehicle06, t_assault_vehicle["Vehicle05"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[4], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_vehicle07, t_assault_vehicle["Vehicle08"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[4], 40), 1, nil, true, nil, nil, nil);
	
	SGroup_IncreaseVeterancyRank(sg_vehicle01, 3, true);
	SGroup_IncreaseVeterancyRank(sg_vehicle02, 3, true);
	SGroup_IncreaseVeterancyRank(sg_vehicle03, 3, true);
	SGroup_IncreaseVeterancyRank(sg_vehicle04, 3, true);
	SGroup_IncreaseVeterancyRank(sg_vehicle05, 3, true);
	SGroup_IncreaseVeterancyRank(sg_vehicle06, 3, true);
	SGroup_IncreaseVeterancyRank(sg_vehicle07, 3, true);
	
	SGroup_AddGroup(sg_totalassault, sg_vehicle01);
	SGroup_AddGroup(sg_totalassault, sg_vehicle02);
	SGroup_AddGroup(sg_totalassault, sg_vehicle03);
	SGroup_AddGroup(sg_totalassault, sg_vehicle04);
	SGroup_AddGroup(sg_totalassault, sg_vehicle05);
	SGroup_AddGroup(sg_totalassault, sg_vehicle06);
	SGroup_AddGroup(sg_totalassault, sg_vehicle07);

	Mission_RegisterSturmtiger(sg_vehicle07);
	
	g_maxspawned = SGroup_Count(sg_totalassault);
	g_display = g_wave4_display;

end

function Mission_StartWave05()

	local sg_infantry1 = SGroup_CreateIfNotFound("sg_infantry1");
	local sg_infantry2 = SGroup_CreateIfNotFound("sg_infantry2");
	local sg_infantry3 = SGroup_CreateIfNotFound("sg_infantry3");
	local sg_infantry4 = SGroup_CreateIfNotFound("sg_infantry4");
	local sg_infantry5 = SGroup_CreateIfNotFound("sg_infantry5");
	local sg_infantry6 = SGroup_CreateIfNotFound("sg_infantry6");
	local sg_infantry7 = SGroup_CreateIfNotFound("sg_infantry7");
	local sg_infantry8 = SGroup_CreateIfNotFound("sg_infantry8");
	local sg_infantry9 = SGroup_CreateIfNotFound("sg_infantry9");
	local sg_infantry10 = SGroup_CreateIfNotFound("sg_infantry10");

	Util_CreateSquads(player3, sg_infantry1, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[1], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry2, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[2], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry3, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[3], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry4, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[1], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry5, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[2], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry6, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[3], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry7, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[2], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry8, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[3], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry9, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[2], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry10, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[3], 40), 1, nil, true, nil, nil, nil);
	
	SGroup_IncreaseVeterancyRank(sg_infantry1, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry2, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry3, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry4, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry5, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry6, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry7, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry8, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry9, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry10, 3, true);
	
	SGroup_AddGroup(sg_totalassault, sg_infantry1);
	SGroup_AddGroup(sg_totalassault, sg_infantry2);
	SGroup_AddGroup(sg_totalassault, sg_infantry3);
	SGroup_AddGroup(sg_totalassault, sg_infantry4);
	SGroup_AddGroup(sg_totalassault, sg_infantry5);
	SGroup_AddGroup(sg_totalassault, sg_infantry6);
	SGroup_AddGroup(sg_totalassault, sg_infantry7);
	SGroup_AddGroup(sg_totalassault, sg_infantry8);
	SGroup_AddGroup(sg_totalassault, sg_infantry9);
	SGroup_AddGroup(sg_totalassault, sg_infantry10);

	local sg_vehicle01 = SGroup_CreateIfNotFound("sg_vehicle01");
	local sg_vehicle02 = SGroup_CreateIfNotFound("sg_vehicle02");
	local sg_vehicle03 = SGroup_CreateIfNotFound("sg_vehicle03");
	local sg_vehicle04 = SGroup_CreateIfNotFound("sg_vehicle04");
	local sg_vehicle05 = SGroup_CreateIfNotFound("sg_vehicle05");
	local sg_vehicle06 = SGroup_CreateIfNotFound("sg_vehicle06");
	
	Util_CreateSquads(player3, sg_vehicle01, t_assault_vehicle["Vehicle03"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[1], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_vehicle02, t_assault_vehicle["Vehicle04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[2], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_vehicle03, t_assault_vehicle["Vehicle05"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[3], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_vehicle04, t_assault_vehicle["Vehicle03"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[4], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_vehicle05, t_assault_vehicle["Vehicle04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[1], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_vehicle06, t_assault_vehicle["Vehicle02"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[4], 40), 1, nil, true, nil, nil, nil);
	
	SGroup_IncreaseVeterancyRank(sg_vehicle01, 3, true);
	SGroup_IncreaseVeterancyRank(sg_vehicle02, 3, true);
	SGroup_IncreaseVeterancyRank(sg_vehicle03, 3, true);
	SGroup_IncreaseVeterancyRank(sg_vehicle04, 3, true);
	SGroup_IncreaseVeterancyRank(sg_vehicle05, 3, true);
	SGroup_IncreaseVeterancyRank(sg_vehicle06, 3, true);
	
	SGroup_AddGroup(sg_totalassault, sg_vehicle01);
	SGroup_AddGroup(sg_totalassault, sg_vehicle02);
	SGroup_AddGroup(sg_totalassault, sg_vehicle03);
	SGroup_AddGroup(sg_totalassault, sg_vehicle04);
	SGroup_AddGroup(sg_totalassault, sg_vehicle05);
	SGroup_AddGroup(sg_totalassault, sg_vehicle06);

	g_maxspawned = SGroup_Count(sg_totalassault);
	g_display = g_wave5_display;

end

function Mission_StartWave06()

	local sg_infantry1 = SGroup_CreateIfNotFound("sg_infantry1");
	local sg_infantry2 = SGroup_CreateIfNotFound("sg_infantry2");
	local sg_infantry3 = SGroup_CreateIfNotFound("sg_infantry3");
	local sg_infantry4 = SGroup_CreateIfNotFound("sg_infantry4");
	local sg_infantry5 = SGroup_CreateIfNotFound("sg_infantry5");
	local sg_infantry6 = SGroup_CreateIfNotFound("sg_infantry6");
	local sg_infantry7 = SGroup_CreateIfNotFound("sg_infantry7");
	local sg_infantry8 = SGroup_CreateIfNotFound("sg_infantry8");
	local sg_infantry9 = SGroup_CreateIfNotFound("sg_infantry9");
	local sg_infantry10 = SGroup_CreateIfNotFound("sg_infantry10");

	Util_CreateSquads(player3, sg_infantry1, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[1], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry2, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[2], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry3, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[3], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry4, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[1], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry5, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[2], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry6, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[3], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry7, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[2], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry8, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[3], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry9, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[2], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_infantry10, t_assault_infantry["Infantry04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[3], 40), 1, nil, true, nil, nil, nil);
	
	SGroup_IncreaseVeterancyRank(sg_infantry1, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry2, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry3, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry4, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry5, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry6, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry7, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry8, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry9, 3, true);
	SGroup_IncreaseVeterancyRank(sg_infantry10, 3, true);
	
	SGroup_AddGroup(sg_totalassault, sg_infantry1);
	SGroup_AddGroup(sg_totalassault, sg_infantry2);
	SGroup_AddGroup(sg_totalassault, sg_infantry3);
	SGroup_AddGroup(sg_totalassault, sg_infantry4);
	SGroup_AddGroup(sg_totalassault, sg_infantry5);
	SGroup_AddGroup(sg_totalassault, sg_infantry6);
	SGroup_AddGroup(sg_totalassault, sg_infantry7);
	SGroup_AddGroup(sg_totalassault, sg_infantry8);
	SGroup_AddGroup(sg_totalassault, sg_infantry9);
	SGroup_AddGroup(sg_totalassault, sg_infantry10);

	local sg_vehicle01 = SGroup_CreateIfNotFound("sg_vehicle01");
	local sg_vehicle02 = SGroup_CreateIfNotFound("sg_vehicle02");
	local sg_vehicle03 = SGroup_CreateIfNotFound("sg_vehicle03");
	local sg_vehicle04 = SGroup_CreateIfNotFound("sg_vehicle04");
	local sg_vehicle05 = SGroup_CreateIfNotFound("sg_vehicle05");
	local sg_vehicle06 = SGroup_CreateIfNotFound("sg_vehicle06");
	local sg_vehicle07 = SGroup_CreateIfNotFound("sg_vehicle07");
	
	Util_CreateSquads(player3, sg_vehicle01, t_assault_vehicle["Vehicle02"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[1], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_vehicle02, t_assault_vehicle["Vehicle04"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[2], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_vehicle03, t_assault_vehicle["Vehicle05"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[3], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_vehicle04, t_assault_vehicle["Vehicle03"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[4], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_vehicle05, t_assault_vehicle["Vehicle02"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[1], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_vehicle06, t_assault_vehicle["Vehicle08"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[4], 40), 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_vehicle07, t_assault_vehicle["Vehicle08"], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], Util_GetRandomPosition(t_posAxis[4], 40), 1, nil, true, nil, nil, nil);
	
	SGroup_IncreaseVeterancyRank(sg_vehicle01, 3, true);
	SGroup_IncreaseVeterancyRank(sg_vehicle02, 3, true);
	SGroup_IncreaseVeterancyRank(sg_vehicle03, 3, true);
	SGroup_IncreaseVeterancyRank(sg_vehicle04, 3, true);
	SGroup_IncreaseVeterancyRank(sg_vehicle05, 3, true);
	SGroup_IncreaseVeterancyRank(sg_vehicle06, 3, true);
	SGroup_IncreaseVeterancyRank(sg_vehicle07, 3, true);
	
	SGroup_AddGroup(sg_totalassault, sg_vehicle01);
	SGroup_AddGroup(sg_totalassault, sg_vehicle02);
	SGroup_AddGroup(sg_totalassault, sg_vehicle03);
	SGroup_AddGroup(sg_totalassault, sg_vehicle04);
	SGroup_AddGroup(sg_totalassault, sg_vehicle05);
	SGroup_AddGroup(sg_totalassault, sg_vehicle06);
	SGroup_AddGroup(sg_totalassault, sg_vehicle07);

	Mission_RegisterSturmtiger(sg_vehicle06);
	Mission_RegisterSturmtiger(sg_vehicle07);

	g_maxspawned = SGroup_Count(sg_totalassault);
	g_display = g_wave6_display;

end

function Mission_WaveUpdate()

	Obj_ShowProgress2(g_display, SGroup_Count(sg_totalassault) / g_maxspawned);

	if (SGroup_Count(sg_totalassault) == 0) then
		
		g_currentwave = g_currentwave + 1;
		
		if (g_currentwave == 1) then
			Mission_StartWave02();
		elseif (g_currentwave == 2) then
			Mission_StartWave03();
		elseif (g_currentwave == 3) then
			Mission_StartWave04();
		elseif (g_currentwave == 4) then
			if (t_difficulty.skiptwolast == true) then
				Codiex_EndGame(Player_GetRaceName(player1), true);
			else
				Mission_StartWave05();
			end
		elseif (g_currentwave == 5) then
			Mission_StartWave06();
		else
			Codiex_EndGame(Player_GetRaceName(player1), true);
		end
		
	end
	
end

function Mission_CheckBridgeSafety() -- Because we need some sort of way to get units over the river

	if (EGroup_Count(eg_repair_bridge) == 0) then
		
		Codiex_EndGame(Player_GetRaceName(player1), false);
		
		Rule_RemoveMe();
		
	end

end

function Mission_RegisterSturmtiger(sgroup)

	if (t_sturmtigers == nil) then
		t_sturmtigers = {};
	end

	table.insert(t_sturmtigers, sgroup);
	
	if (Rule_Exists(_UpdateSturmtiger) == false) then
		Rule_AddInterval(_UpdateSturmtiger, 3);
	end

end

function _UpdateSturmtiger()

	local removeAt = nil;

	for i=1, #t_sturmtigers do
		if (SGroup_Count(t_sturmtigers[i]) > 0) then
			local sg_last = SGroup_CreateIfNotFound("sg_last");
			SGroup_GetLastAttacker(t_sturmtigers[i], sg_last);
			if (SGroup_Count(sg_last) > 0) then
				Cmd_Ability(t_sturmtigers[i], BP_GetAbilityBlueprint("sturmtiger_380mm_rocket_attack"), SGroup_GetPosition(sg_last), nil, true, false);
				Cmd_MoveToAndDespawn(t_sturmtigers[i], t_spawners_north_assault[World_GetRand(1, #t_spawners_north_assault)], true);
				removeAt = i;
			end
		else
			t_sturmtigers = i;
		end
	end

	if (removeAt ~= nil) then
		table.remove(t_sturmtigers, removeAt);
	end
	
	if (#t_sturmtigers == 0) then
		Rule_RemoveMe();
	end
	
end
