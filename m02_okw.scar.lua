import("ScarUtil.scar");
import("m02_okw_utilities.scar");

function OnGameSetup()
	player1 = World_GetPlayerAt(1);
	player2 = World_GetPlayerAt(2);
	player3 = World_GetPlayerAt(3);
	player4 = World_GetPlayerAt(4);
	
	Setup_SetPlayerName(player1, "$08a0ac9c7e6144909909a02d533ce8aa:361");
	Setup_SetPlayerName(player2, "$08a0ac9c7e6144909909a02d533ce8aa:361");
	Setup_SetPlayerName(player3, "$08a0ac9c7e6144909909a02d533ce8aa:362");
	Setup_SetPlayerName(player4, "$08a0ac9c7e6144909909a02d533ce8aa:362");
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

	g_currentTier = 0;
	
	AI_EnableAll(false);
	AI_Enable(player4, true);
	
	Cmd_InstantSetupTeamWeapon(sg_instant_setup, false);
	
	Game_EnableInput(false);
	Game_SetMode(UI_Cinematic);
	
	Game_SubTextFade("$08a0ac9c7e6144909909a02d533ce8aa:373", "$08a0ac9c7e6144909909a02d533ce8aa:374", 0.5, 4, 0.5);
	
	Rule_AddOneShot(Mission_DelayedIntro, 5);
	
end

function Mission_DelayedIntro()
	Util_StartIntel(EVENTS.INTRO);
end

Scar_AddInit(OnInit);

function Mission_Restrictions() --ITEM_LOCKED, ITEM_UNLOCKED, ITEM_REMOVED or ITEM_DEFAULT 

	g_popcapoverride = 360;

	Player_SetPopCapOverride(player1, g_popcapoverride); 
	Modify_PlayerResourceRate(player1, RT_Manpower, 1.95, MUT_Multiplication);
	Modify_PlayerResourceRate(player1, RT_Fuel, 3.95, MUT_Multiplication);
	Modify_PlayerResourceRate(player1, RT_Munition, 3.95, MUT_Multiplication);
	
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("sdkfz_251_17_flak_halftrack_squad_mp"), ITEM_LOCKED);
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("sdkfz_251_20_ir_searchlight_halftrack_squad_mp"), ITEM_LOCKED);
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("sdkfz_251_wurfrahmen_40_halftrack_squad_mp"), ITEM_LOCKED);
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("jagdpanzer_tank_destroyer_squad_mp"), ITEM_LOCKED);
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("king_tiger_squad_mp"), ITEM_REMOVED);
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("panther_ausf_g_squad_mp"), ITEM_LOCKED);
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("panzer_ii_luchs_squad_mp"), ITEM_LOCKED);
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("panzer_iv_ausf_j_battle_group_mp"), ITEM_LOCKED);
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("armored_car_sdkfz_234_squad_mp"), ITEM_LOCKED);
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("raketenwerfer43_88mm_puppchen_antitank_gun_squad_mp"), ITEM_LOCKED);
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("le_ig_18_inf_support_gun_squad_mp"), ITEM_LOCKED);
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("obersoldaten_squad_mp"), ITEM_LOCKED);
	
	Player_AddAbility(player1, BP_GetAbilityBlueprint("panzerfusiliers_dispatch"));
	Player_AddAbility(player1, BP_GetAbilityBlueprint("mg34_dispatch"));
	Player_StopEarningActionPoints(player1); 
	
	g_tier1 = false;
	g_tier2 = false;
	g_tier3 = false;
	
end

function Mission_UnlockT1()

	Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:364", 2.0, 2.0, 2.0);

	Player_AddAbility(player1, BP_GetAbilityBlueprint("jaeger_light_infantry_recon_dispatch"));
	Player_AddAbility(player1, BP_GetAbilityBlueprint("ostwind_dispatch"));
	
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("raketenwerfer43_88mm_puppchen_antitank_gun_squad_mp"), ITEM_UNLOCKED);
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("le_ig_18_inf_support_gun_squad_mp"), ITEM_UNLOCKED);
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("sdkfz_251_20_ir_searchlight_halftrack_squad_mp"), ITEM_UNLOCKED);
	
	World_IncreaseInteractionStage();
	
	Util_CreateSquads(player3, sg_patrol_tank01, BP_GetSquadBlueprint("churchill_default_squad_mp"), mkr_c_spawner01, nil, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_patrol_tank02, BP_GetSquadBlueprint("churchill_default_squad_mp"), mkr_c_spawner01, nil, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_patrol_tank03, BP_GetSquadBlueprint("churchill_default_squad_mp"), mkr_c_spawner02, nil, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_patrol_tank04, BP_GetSquadBlueprint("churchill_default_squad_mp"), mkr_c_spawner02, nil, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_patrol_tank05, BP_GetSquadBlueprint("churchill_default_squad_mp"), mkr_c_spawner01, nil, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_patrol_tank06, BP_GetSquadBlueprint("churchill_default_squad_mp"), mkr_c_spawner02, nil, nil, 1, nil, true, nil, nil, nil);
	Cmd_SquadPath(sg_patrol_tank01, "churchill01", true, LOOP_TOGGLE_DIRECTION, true, 0, nil, false, true);
	Cmd_SquadPath(sg_patrol_tank02, "churchill02", true, LOOP_TOGGLE_DIRECTION, true, 0, nil, false, true);
	Cmd_SquadPath(sg_patrol_tank03, "churchill03", true, LOOP_TOGGLE_DIRECTION, true, 0, nil, false, true);
	Cmd_SquadPath(sg_patrol_tank04, "churchill04", true, LOOP_TOGGLE_DIRECTION, true, 0, nil, false, true);
	Cmd_SquadPath(sg_patrol_tank05, "churchill05", true, LOOP_TOGGLE_DIRECTION, true, 0, nil, false, true);
	Cmd_SquadPath(sg_patrol_tank06, "churchill06", true, LOOP_TOGGLE_DIRECTION, true, 0, nil, false, true);
	
	g_tier1 = true;
	
	g_currentTier = g_currentTier + 1;
	
end

function Mission_UnlockT2()

	Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:365", 2.0, 2.0, 2.0);

	Player_AddAbility(player1, BP_GetAbilityBlueprint("fallschirmjaeger"));
	
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("obersoldaten_squad_mp"), ITEM_UNLOCKED);
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("sdkfz_251_17_flak_halftrack_squad_mp"), ITEM_UNLOCKED);
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("sdkfz_251_wurfrahmen_40_halftrack_squad_mp"), ITEM_UNLOCKED);
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("jagdpanzer_tank_destroyer_squad_mp"), ITEM_UNLOCKED);
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("panzer_ii_luchs_squad_mp"), ITEM_UNLOCKED);
	
	g_tier2 = true;
	
	g_currentTier = g_currentTier + 1;
	
end

function Mission_UnlockT3()

	Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:366", 2.0, 2.0, 2.0);

	Player_AddAbility(player1, BP_GetAbilityBlueprint("jagdtiger"));
	
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("panther_ausf_g_squad_mp"), ITEM_UNLOCKED);
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("armored_car_sdkfz_234_squad_mp"), ITEM_UNLOCKED);
	Player_SetSquadProductionAvailability(player1, BP_GetSquadBlueprint("panzer_iv_ausf_j_battle_group_mp"), ITEM_UNLOCKED);
	
	g_tier3 = true;
	
	g_currentTier = g_currentTier + 1;
	
end

function Mission_Difficulty()

	g_diff = Game_GetSPDifficulty();

	t_difficulty = {};
	
	if (g_diff == GD_EASY) then
	
		t_difficulty.time = 80 * 60;
		t_difficulty.max_base = 1;
		t_difficulty.penaltyUpdate = 15 * 60;
		t_difficulty.reinforceUpdate = 20 * 60;
		t_difficulty.RAFUpdate = 12 * 60;
		t_difficulty.baseUpdate = 24 * 50;
		
	elseif (g_diff == GD_NORMAL) then
		
		t_difficulty.time = 70 * 60;
		t_difficulty.max_base = 2;
		t_difficulty.penaltyUpdate = 10 * 60;
		t_difficulty.reinforceUpdate = 15 * 60;
		t_difficulty.RAFUpdate = 8 * 60;
		t_difficulty.baseUpdate = 16 * 50;
		
	elseif (g_diff == GD_HARD) then
		
		t_difficulty.time = 60 * 60;
		t_difficulty.max_base = 3;
		t_difficulty.penaltyUpdate = 7 * 60;
		t_difficulty.reinforceUpdate = 12 * 60;
		t_difficulty.RAFUpdate = 4 * 60;
		t_difficulty.baseUpdate = 12 * 50;
		
	end
	
end

function Mission_Objectives()

	OBJ_KINGTIGER = {
	
		SetupUI = function() 
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:355",
		Description = 0,
		Type = OT_Primary,
	}

	OBJ_DEFENDHQ = {
	
		SetupUI = function() 
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:356",
		Description = 0,
		Type = OT_Primary,
	}
	
	OBJ_KINGTIGER_S = {
	
		SetupUI = function() 
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:369",
		Description = 0,
		Type = OT_Primary,
	}
	
	Objective_Register(OBJ_KINGTIGER);
	Objective_Register(OBJ_KINGTIGER_S);
	Objective_Register(OBJ_DEFENDHQ);
	
end

function Mission_Start()

	Objective_Start(OBJ_KINGTIGER, true);

	UI_SetCPMeterVisibility(false);
	FOW_UnRevealAll()
	
	Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:360", 2.0, 2.0, 2.0); 
	Event_Proximity(Mission_BeginAll, nil, player1, mkr_trigger_mission_begin, 15, ANY, 2);
	
end

function Mission_UI_Timer()
	Obj_ShowProgress2("$08a0ac9c7e6144909909a02d533ce8aa:363", Timer_GetRemaining("_TIMER_") / t_difficulty.time);
	if (Timer_GetRemaining("_TIMER_") == 0) then
		Objective_Fail(OBJ_KINGTIGER, true);
		Objective_Fail(OBJ_DEFENDHQ, true);
		Codiex_EndGame(Player_GetRaceName(player1), false);
	end
end

function Mission_BeginAll()

	Timer_Start("_TIMER_", t_difficulty.time);
	Rule_AddInterval(Mission_UI_Timer, 1);
	
	Objective_Start(OBJ_DEFENDHQ, true);

	Event_Proximity(Mission_KingTigerReached, nil, player1, mkr_kt_load, 7, ANY);
	
	Mission_PopulateCity();
	
	Rule_AddInterval(Mission_PenalisePlayer, t_difficulty.penaltyUpdate);
	Rule_AddInterval(Mission_BaseDestroyed, 5);
	Rule_AddInterval(Mission_UnlockTiers, 10);
	Rule_AddInterval(Mission_BritishReinforce, t_difficulty.reinforceUpdate);
	Rule_AddInterval(Mission_BritishRAF, t_difficulty.RAFUpdate);
	Rule_AddInterval(Mission_DoBaseAttack, t_difficulty.baseUpdate);
	
end

function Mission_PenalisePlayer()

	g_popcapoverride = g_popcapoverride - 20;

	if (g_popcapoverride >= 0) then
	
		Player_SetPopCapOverride(player1, g_popcapoverride);
		Modify_PlayerResourceRate(player1, RT_Manpower, 0.85, MUT_Multiplication);
		Modify_PlayerResourceRate(player1, RT_Fuel, 0.85, MUT_Multiplication);
		Modify_PlayerResourceRate(player1, RT_Munition, 0.85, MUT_Multiplication);
		
	end

end

function Mission_KingTigerReached()

	Objective_Complete(OBJ_KINGTIGER, true);
	Objective_Complete(OBJ_DEFENDHQ, false);

	Objective_Start(OBJ_KINGTIGER_S, true);
	Util_StartIntel(EVENTS.BASEKT);
	
	Player_AddAbility(player2, BP_GetAbilityBlueprint("stuka_bombing_strike"));
	Cmd_Ability(player2, BP_GetAbilityBlueprint("stuka_bombing_strike"), mkr_bomb_out, nil, true, false); 
	Rule_AddOneShot(Mission_ExplosionTimed, 3.5);
	
	SGroup_SetPlayerOwner(sg_kingtiger, player2); 
	Cmd_SquadPath(sg_kingtiger, "kt_move_path", true, LOOP_NONE, false, 0); 
	
	Obj_HideProgress();
	
	Event_Proximity(Mission_KingTiger_IsBack, nil, sg_kingtiger, mkr_trigger_mission_begin, 7, ANY);
	
	HintPoint_Add(sg_kingtiger, true, "$08a0ac9c7e6144909909a02d533ce8aa:376", 2.3, HPAT_Objective);
	
	Rule_Remove(Mission_PenalisePlayer);
	Rule_Remove(Mission_BaseDestroyed);
	Rule_Remove(Mission_BritishReinforce);
	Rule_Remove(Mission_DoBaseAttack);
	Rule_Remove(Mission_UI_Timer);
	Rule_AddInterval(Mission_IsKTDead, 5);
	
end

function Mission_IsKTDead()

	if (SGroup_Count(sg_kingtiger) == 0) then
		Objective_Fail(OBJ_KINGTIGER_S);
		Codiex_EndGame(Player_GetRaceName(player1), false);
	end

end

function Mission_ExplosionTimed()
	EGroup_DestroyAllEntities(eg_blow_on_capture);
end

function Mission_KingTiger_IsBack()

	Objective_Complete(OBJ_KINGTIGER_S, true);

	Codiex_EndGame(Player_GetRaceName(player1), true);
	
end

function Mission_BaseDestroyed()

	if (EGroup_Count(eg_base) == 0) then
		Objective_Fail(OBJ_DEFENDHQ, true);
		Objective_Fail(OBJ_KINGTIGER, false);
		Codiex_EndGame(Player_GetRaceName(player1), false);
		Rule_RemoveMe();
	end

end

function Mission_PopulateCity()

	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	t_houses = 
	{
		eg_house01, eg_house02, eg_house03, eg_house04, eg_house05, eg_house06, eg_house07, eg_house08, eg_house09, eg_house10,
		eg_house11, eg_house12, eg_house13, eg_house14, eg_house15, eg_house16, eg_house17, eg_house18, eg_house19, eg_house20,
		eg_house21, eg_house22, eg_house23, eg_house24, eg_house25, eg_house26, eg_house27, eg_house28, eg_house29, eg_house30,
		eg_house31, eg_house32, eg_house33, eg_house34
	};
	t_additional_squads = 
	{
		BP_GetSquadBlueprint("tommy_squad_tank_hunter_mp"), BP_GetSquadBlueprint("british_machine_gun_squad_mp")
	};
	t_additional_squads_free =
	{
		BP_GetSquadBlueprint("tommy_squad_mp"), BP_GetSquadBlueprint("tommy_squad_tank_hunter_mp"), BP_GetSquadBlueprint("tommy_squad_mp"), BP_GetSquadBlueprint("british_machine_gun_squad_mp"), BP_GetSquadBlueprint("tommy_squad_mp")
	};
	t_random_spawners = 
	{
		mkr_enemy_spawner01, mkr_enemy_spawner02
	}
	t_base_assault_units =
	{
		BP_GetSquadBlueprint("tommy_squad_mp"), BP_GetSquadBlueprint("tommy_squad_tank_hunter_mp")
	}
	t_airraids =
	{
		BP_GetAbilityBlueprint("strafing_run"), BP_GetAbilityBlueprint("officer_recon_sweep"), BP_GetAbilityBlueprint("allied_strategic_bombing"), 
	}
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	eg_mortars = EGroup_CreateIfNotFound("eg_mortars");
	sg_church_defence = SGroup_CreateIfNotFound("sg_church_defence");
	sg_house_defence = SGroup_CreateIfNotFound("sg_house_defence");
	sg_patrol_tank01 = SGroup_CreateIfNotFound("sg_patrol_tank01");
	sg_patrol_tank02 = SGroup_CreateIfNotFound("sg_patrol_tank02");
	sg_patrol_tank03 = SGroup_CreateIfNotFound("sg_patrol_tank03");
	sg_patrol_tank04 = SGroup_CreateIfNotFound("sg_patrol_tank04");
	sg_patrol_tank05 = SGroup_CreateIfNotFound("sg_patrol_tank05");
	sg_patrol_tank06 = SGroup_CreateIfNotFound("sg_patrol_tank06");
	sg_base_assault = SGroup_CreateIfNotFound("sg_base_assault");
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	Util_CreateEntities(player3, eg_mortars, BP_GetEntityBlueprint("brit_3_inch_mortar_emplacement"), mkr_mortar_spawner01 , 1);
	Util_CreateEntities(player3, eg_mortars, BP_GetEntityBlueprint("brit_3_inch_mortar_emplacement"), mkr_mortar_spawner01 , 1);	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	Util_CreateSquads(player3, sg_church_defence, BP_GetSquadBlueprint("tommy_squad_mp"), eg_church, nil, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_church_defence, BP_GetSquadBlueprint("tommy_squad_tank_hunter_mp"), eg_church, nil, 2, nil, true, nil, nil, nil);
	Util_CreateSquads(player3, sg_church_defence, BP_GetSquadBlueprint("british_machine_gun_squad_mp"), eg_church, nil, 1, nil, true, nil, nil, nil);
	for i=1, #t_houses do
		Util_CreateSquads(player3, sg_house_defence, BP_GetSquadBlueprint("tommy_squad_mp"), t_houses[i] , nil, 1, nil, true, nil, nil, nil);
		local random = World_GetRand(1, 6);
		if (random >= 5) then
			Util_CreateSquads(player3, sg_house_defence, t_additional_squads[World_GetRand(1, #t_additional_squads)], t_houses[i], nil, 1, nil, true, nil, nil, nil);
		end
	end
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	Event_OnHealth(Mission_LoseMove1, nil, sg_free_unit_move01, 0.75, false, 1);
	Event_OnHealth(Mission_LoseMove2, nil, sg_free_unit_move02, 0.75, false, 1);
	Event_OnHealth(Mission_LoseMove3, nil, sg_free_unit_move03, 0.75, false, 1);
	Event_OnHealth(Mission_LoseMove4, nil, sg_free_unit_move04, 0.75, false, 1);
	Event_OnHealth(Mission_LoseMove5, nil, sg_free_unit_move05, 0.75, false, 1);
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	HintPoint_Add(eg_tier1_unlock, true, "$08a0ac9c7e6144909909a02d533ce8aa:375", 2.3, HPAT_Objective);
	HintPoint_Add(eg_tier1_unlock_2, true, "$08a0ac9c7e6144909909a02d533ce8aa:375", 2.3, HPAT_Objective);
	HintPoint_Add(eg_tier2_unlock, true, "$08a0ac9c7e6144909909a02d533ce8aa:375", 2.3, HPAT_Objective);
	HintPoint_Add(eg_tier3_unlock, true, "$08a0ac9c7e6144909909a02d533ce8aa:375", 2.3, HPAT_Objective);
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	g_maxforattack = SGroup_Count(sg_house_defence) / 2;
	
	Player_AddAbility(player3, t_airraids[1]);
	Player_AddAbility(player3, t_airraids[2]);
	Player_AddAbility(player3, t_airraids[3]);
	
end

function Mission_LoseMove1()
	Cmd_Move(sg_free_unit_move01, Util_GetRandomPosition(mkr_enemy_base_target, 30));
	Mission_DoBaseAttack(true);
end

function Mission_LoseMove2()
	Cmd_Move(sg_free_unit_move02, Util_GetRandomPosition(mkr_enemy_base_target, 30));
	Mission_DoBaseAttack(true);
end

function Mission_LoseMove3()
	Cmd_Move(sg_free_unit_move03, Util_GetRandomPosition(mkr_enemy_base_target, 30));
	Mission_DoBaseAttack(true);
end

function Mission_LoseMove4()
	Cmd_Move(sg_free_unit_move04, Util_GetRandomPosition(mkr_enemy_base_target, 30));
	Mission_DoBaseAttack(true);
end

function Mission_LoseMove5()
	Cmd_Move(sg_free_unit_move05, Util_GetRandomPosition(mkr_enemy_base_target, 30));
	Mission_DoBaseAttack(true);
end

function Mission_UnlockTiers()

	if (g_tier1 == false) then

		if (EGroup_IsCapturedByPlayer(eg_tier1_unlock, player1, ANY) == true and EGroup_IsCapturedByPlayer(eg_tier1_unlock_2, player1, ANY) == true) then
			Mission_UnlockT1();
		end

	else
		
		if (g_tier2 == false) then
		
			if (EGroup_IsCapturedByPlayer(eg_tier2_unlock, player1, ANY) == true) then
				Mission_UnlockT2();
			end
		
		else
			
			if (g_tier3 == true) then
				Rule_RemoveMe();
			else
				
				if (EGroup_IsCapturedByPlayer(eg_tier3_unlock, player1, ANY) == true) then
					Mission_UnlockT3();
				end
				
			end
			
		end
		
	end
	
end

function Mission_BritishReinforce()

	for i=1, #t_houses do
		
		if (SGroup_Count(sg_house_defence) <= g_maxforattack) then
			Mission_DoBaseAttack(false);
		end
		
		if (EGroup_IsHoldingAny(t_houses[i]) == false) then
			if (EGroup_GetAvgHealth(t_houses[i]) >= 0.4) then
				local sg_temp = SGroup_CreateIfNotFound("sg_temp");
				Util_CreateSquads(player3, sg_temp, t_additional_squads_free[World_GetRand(1, #t_additional_squads_free)], t_random_spawners[World_GetRand(1, #t_random_spawners)], nil, 1, nil, true, nil, nil, nil);
				Cmd_Garrison(sg_temp, t_houses[i], true, false, false); 
				SGroup_AddGroup(sg_house_defence, sg_temp);
				SGroup_Clear(sg_temp);
			end
		end
		
	end
	
end

function Mission_BritishRAF()

	local sg_last = SGroup_CreateIfNotFound("sg_last");

	SGroup_GetLastAttacker(Player_GetSquads(player3), sg_last); 
	
	if (SGroup_Count(sg_last) > 0) then
	
		local pos = SGroup_GetPosition(sg_last);
		local doairraid = World_GetRand(1, 4);
		
		if (doairraid >= 2) then
			local i = World_GetRand(1, #t_airraids);
			Cmd_Ability(player3, t_airraids[i], pos, nil, true, false); 
		end
		
	end
	
	SGroup_Clear(sg_last);
	
end

function Mission_DoBaseAttack(forced)

	if (forced == nil) then
		forced = false;
	end

	if (forced == true) then
		
		if (g_diff == GD_NORMAL) then
			local doit = World_GetRand(1, 2);
			if (doit == 1) then
				return;
			end
		else
			if (g_diff == GD_EASY) then
				return;
			end
		end
		
	end

	if (forced == true) then
	
		for i=1, World_GetRand(1, t_difficulty.max_base) do
			local sg_temp = SGroup_CreateIfNotFound("sg_temp");
			Util_CreateSquads(player3, sg_temp, t_base_assault_units[World_GetRand(1, #t_base_assault_units)], t_random_spawners[World_GetRand(1, #t_random_spawners)], nil, 1, nil, true, nil, nil, nil);
			Cmd_Move(sg_temp, Util_GetRandomPosition(mkr_enemy_base_target, 30));
			SGroup_AddGroup(sg_base_assault, sg_temp);
			SGroup_Clear(sg_temp);
		end
		
	else
		
		local t_targets = 
		{
			{target_object = mkr_enemy_base_target, intel = EVENTS.ATTACKEDBASE};
			{target_object = eg_bridge, intel = EVENTS.ATTACKEDBRIDGE};
		};
		
		local target = t_targets[World_GetRand(1, #t_targets)];
		
		if (scartype(target.target_object) == ST_MARKER) then
			
			local sg_chargers = SGroup_CreateIfNotFound("sg_chargers");
			
			Util_CreateSquads(player3, sg_chargers, BP_GetSquadBlueprint("tommy_squad_mp"), mkr_enemy_spawner02, nil, t_difficulty.max_base, nil, true, nil, nil, nil);
			Cmd_Move(sg_chargers, Util_GetRandomPosition(mkr_enemy_base_target, 30), true);
			
			SGroup_Clear(sg_chargers);
			
		else -- it's an EGroup
			
			if (EGroup_Count(target.target_object) > 0) then
				
				local sg_chargers = SGroup_CreateIfNotFound("sg_chargers");
				local sg_churchill = SGroup_CreateIfNotFound("sg_churchill");
				
				Util_CreateSquads(player3, sg_churchill, BP_GetSquadBlueprint("churchill_avre_squad_mp"), mkr_enemy_spawner01, nil, 1, nil, true, nil, nil, nil);
				Util_CreateSquads(player3, sg_chargers, BP_GetSquadBlueprint("tommy_squad_mp"), mkr_enemy_spawner01, nil, 1, nil, true, nil, nil, nil);
				Util_CreateSquads(player3, sg_chargers, BP_GetSquadBlueprint("tommy_squad_tank_hunter_mp"), mkr_enemy_spawner01, nil, 2, nil, true, nil, nil, nil);
				
				Cmd_SquadPath(sg_churchill, "base_assault_path", true, LOOP_NONE, true, 0, nil, false, true);
				Cmd_SquadPath(sg_chargers, "base_assault_path", true, LOOP_NONE, true, 0, nil, false, true);
				
				Cmd_Ability(sg_churchill, BP_GetAbilityBlueprint("avre_spigot_mortar_attack_mp"), EGroup_GetPosition(target.target_object), nil, true, true);
				Cmd_Move(sg_chargers, Util_GetRandomPosition(mkr_enemy_base_target, 30), true);
				
				SGroup_AddGroup(sg_chargers, sg_churchill);
				SGroup_Clear(sg_chargers);
				
			end
			
		end
		
		Util_StartIntel(target.intel);
		
	end
	
end
