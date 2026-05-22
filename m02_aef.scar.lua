import("ScarUtil.scar");
import("m02_aef_utilities.scar");
import("m02_aef_reinforcements.scar");

-- TODO: German Off beach Defences
-- TODO: Add Medics on the beach

function OnGameSetup()

	player1 = World_GetPlayerAt(1);
	player2 = World_GetPlayerAt(2);
	player3 = World_GetPlayerAt(3);
	player4 = World_GetPlayerAt(4); -- allied AI
	player5 = World_GetPlayerAt(5); -- Ukrainian Support
	player6 = World_GetPlayerAt(6); -- Grenadier Division
	player7 = World_GetPlayerAt(7); -- Heavy Panzer Division
	player8 = World_GetPlayerAt(8); -- axis AI dummy
	
end

function OnGameRestore()
	player1 = World_GetPlayerAt(1);
	player2 = World_GetPlayerAt(2);
	player3 = World_GetPlayerAt(3);
	player4 = World_GetPlayerAt(4);
	player5 = World_GetPlayerAt(5);
	player6 = World_GetPlayerAt(6);
	player7 = World_GetPlayerAt(7);
	player8 = World_GetPlayerAt(8);
	Game_DefaultGameRestore();
end

function OnInit()

	Mission_PlayerManager();
	Mission_Difficulty();
	Mission_Restrictions();
	Mission_Objectives();
	Mission_BeachDefence();
	
	AI_EnableAll(false);

	Rule_AddOneShot(Mission_SpawnFirstWave, 1);
	Rule_AddOneShot(Mission_TriggerHowitzer, 2 * 60);
	
	Cmd_InstantSetupTeamWeapon(sg_autosetup, false);
	
	EGroup_DeSpawn(eg_spawn_on_meet);
	EGroup_DeSpawn(eg_munition_meetup);
	
	Player_SetDefaultSquadMoodMode(player1, MM_ForceTense);
	Player_SetDefaultSquadMoodMode(player2, MM_ForceTense);
	Player_SetDefaultSquadMoodMode(player3, MM_ForceTense);
	Player_SetDefaultSquadMoodMode(player4, MM_ForceTense);
	
end

Scar_AddInit(OnInit);

function Mission_PlayerManager()

	local temp_spawners = {mkr_player1_start, mkr_player2_start, mkr_player3_start};
	local temp_moves = {mkr_player1_start_m, mkr_player2_start_m, mkr_player3_start_m};

	t_players = {};
	
	local temp_id = 1;
	
	for i=1, World_GetPlayerCount() do
		
		local player = World_GetPlayerAt(i);
		
		if (AI_IsAIPlayer(player) == false) then
			local t_temp = {};
			t_temp.player = player;
			t_temp.spawner = temp_spawners[temp_id];
			t_temp.move = temp_moves[temp_id];
			temp_id = temp_id + 1;
			table.insert(t_players, t_temp);
		end
		
	end

end

function Mission_Difficulty()

	g_diff = Game_GetSPDifficulty();

	t_difficulty = {};
	
	if (g_diff == nil or Util_IsCoop() == true) then
		if (#t_players == 2) then
			g_diff = GD_NORMAL;
		else
			g_diff = GD_HARD;
		end
	end
	
	if (g_diff == GD_EASY) then
		t_difficulty.max_start = 5;
		t_difficulty.max_waves = 10;
		t_difficulty.max_wave_reinforce = 6;
		t_difficulty.p_riflemen = 6 * #t_players;
		t_difficulty.p_engineers = 3 * #t_players;
		t_difficulty.p_mortars = 2 * #t_players;
		t_difficulty.p_sherman = 2 * #t_players;
	elseif (g_diff == GD_NORMAL) then
		t_difficulty.max_start = 4;
		t_difficulty.max_waves = 8;
		t_difficulty.max_wave_reinforce = 5;
		t_difficulty.p_riflemen = 5 * #t_players;
		t_difficulty.p_engineers = 3 * #t_players;
		t_difficulty.p_mortars = 2 * #t_players;
		t_difficulty.p_sherman = 2 * #t_players;
	elseif (g_diff == GD_HARD) then
		t_difficulty.max_start = 3;
		t_difficulty.max_waves = 6;
		t_difficulty.max_wave_reinforce = 4;
		t_difficulty.p_riflemen = 4 * #t_players;
		t_difficulty.p_engineers = 3 * #t_players;
		t_difficulty.p_mortars = 1 * #t_players;
		t_difficulty.p_sherman = 1 * #t_players;
	end

	t_production = {};
	t_production["riflemen"] = {};
	t_production["riflemen"].unit = "riflemen";
	t_production["riflemen"].name = "dialog.partisan_infantry";
	t_production["riflemen"].blueprint = "riflemen_squad_mp";
	t_production["riflemen"].available = t_difficulty.p_riflemen;
	t_production["riflemen"].icon = "Icons_units_unit_aef_riflemen";
	t_production["riflemen"].tag = "riflemen";
	t_production["riflemen"].intel = nil;
	t_production["riflemen"].upg = nil;
	t_production["engineers"] = {};
	t_production["engineers"].unit = "engineers";
	t_production["engineers"].name = "dialog.basic_infantry";
	t_production["engineers"].blueprint = "assault_engineer_squad_5_man_mp";
	t_production["engineers"].available = t_difficulty.p_engineers;
	t_production["engineers"].icon = "Icons_units_unit_aef_assault_engineers";
	t_production["engineers"].tag = "engineers";
	t_production["engineers"].intel = nil;
	t_production["engineers"].upg = nil;
	t_production["mortars"] = {};
	t_production["mortars"].unit = "mortars";
	t_production["mortars"].name = "dialog.medium_infantry";
	t_production["mortars"].blueprint = "m2_60mm_mortar_squad_mp";
	t_production["mortars"].available = t_difficulty.p_mortars;
	t_production["mortars"].icon = "Icons_units_unit_aef_mortar_crew";
	t_production["mortars"].tag = "mortars";
	t_production["mortars"].intel = nil;
	t_production["mortars"].upg = nil;
	t_production["shermans"] = {};
	t_production["shermans"].unit = "shermans";
	t_production["shermans"].name = "dialog.heavy_infantry";
	t_production["shermans"].blueprint = "m4a3_sherman_squad_mp";
	t_production["shermans"].available = t_difficulty.p_sherman;
	t_production["shermans"].icon = "Icons_vehicles_vehicle_aef_m4a3_sherman";
	t_production["shermans"].tag = "shermans";
	t_production["shermans"].intel = nil;
	t_production["shermans"].upg = nil;
	
end

function Mission_Restrictions()

	for i=1, #t_players do
		Player_SetCommandAvailability(t_players[i].player, SCMD_Retreat, ITEM_LOCKED)
		Player_CompleteUpgrade(t_players[i].player, BP_GetUpgradeBlueprint("rifle_command_grenade_mp"));
		Player_CompleteUpgrade(t_players[i].player, BP_GetUpgradeBlueprint("weapon_rack_upgrade_mp"));
		Player_SetResource(t_players[i].player, RT_Munition, 0);
		Player_SetResource(t_players[i].player, RT_Manpower, 0);
		Player_SetResource(t_players[i].player, RT_Fuel, 0);
		t_players[i].rate_manpower = Modify_PlayerResourceRate(t_players[i].player, RT_Manpower, 0, MUT_Multiplication);
		t_players[i].rate_munition = Modify_PlayerResourceRate(t_players[i].player, RT_Munition, 1.12, MUT_Multiplication);
		t_players[i].rate_fuel = Modify_PlayerResourceRate(t_players[i].player, RT_Fuel, 0, MUT_Multiplication);
		Modify_SlotItemDropRate(t_players[i].player, "grenadier_mg42lmg", 10);
	end

	Player_AddAbility(player8, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT);
	
end

function Mission_Objectives()

	OBJ_Beach = {
	
		SetupUI = function() 
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:389",
		Description = 0,
		Type = OT_Primary,
	}

	OBJ_COMMANDBUNKERS = {
	
		Parent = OBJ_Beach,
	
		SetupUI = function() 
		end,
		
		OnStart = function()
			--Objective_SetCounter(OBJ_COMMANDBUNKERS, 0, EGroup_Count(eg_mortar_bunkers));
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:388",
		Description = 0,
		Type = OT_Secondary,
		
		counter_max = EGroup_Count(eg_mortar_bunkers),
		counter_current = 0,
		
	}
	
	OBJ_HOWITZERS = {
	
		Parent = OBJ_Beach,
	
		SetupUI = function() 
		end,
		
		OnStart = function()
			Objective_SetCounter(OBJ_HOWITZERS, 0, 3);
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:390",
		Description = 0,
		Type = OT_Secondary,
		
		counter_max = 3,
		counter_current = 0,
		
	}
	
	OBJ_FLAK = {
	
		Parent = OBJ_Beach,
	
		SetupUI = function() 
		end,
		
		OnStart = function()
			Objective_SetCounter(OBJ_FLAK, 0, 2);
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:406",
		Description = 0,
		Type = OT_Secondary,
		
		counter_max = 2,
		counter_current = 0,
		
	}
	
	Objective_Register(OBJ_Beach);
	Objective_Register(OBJ_COMMANDBUNKERS);
	Objective_Register(OBJ_FLAK);
	Objective_Register(OBJ_HOWITZERS);
	
	OBJ_FrenchTown = {
	
		SetupUI = function() 
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:397",
		Description = 0,
		Type = OT_Primary,
	}
	
	OBJ_WEAPONRY = {
	
		Parent = OBJ_FrenchTown,
	
		SetupUI = function() 
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:398",
		Description = 0,
		Type = OT_Secondary,
		
	}
	
	Objective_Register(OBJ_FrenchTown);
	Objective_Register(OBJ_WEAPONRY);
	
end

function Mission_BeachDefence()

	sg_bunker_defence = SGroup_CreateIfNotFound("sg_bunker_defence");
	Util_SpawnGarrison(player5, eg_beach_mg_bunkers, sg_bunker_defence, BP_GetSquadBlueprint("mg42_heavy_machine_gun_squad_mp"), 1);
	Util_SpawnGarrison(player5, eg_beach_non_mg_bunker, sg_bunker_defence, BP_GetSquadBlueprint("grenadier_squad_mp"), 1);
	Util_SpawnGarrison(player5, eg_uphill_bunkers, sg_bunker_defence, BP_GetSquadBlueprint("grenadier_squad_mp"), 1);
	
	Modify_Vulnerability(sg_bunker_defence, 2.25);
	Modify_WeaponRange(sg_bunker_defence, "hardpoint_01", 3.52); 
	Modify_WeaponReload(sg_bunker_defence, "hardpoint_01", 0.5);
	Modify_SightRadius(sg_bunker_defence, 1.75);	
	Modify_WeaponSuppression(sg_bunker_defence, "hardpoint_01", 0.25);
	
	sg_commandefence = SGroup_CreateIfNotFound("sg_commanddefence");
	
	Util_SpawnGarrison(player6, eg_mortar_bunkers, sg_commandefence, BP_GetSquadBlueprint("officer_squad_mp"), 1);
	Util_SpawnGarrison(player6, eg_mortar_bunkers, sg_commandefence, BP_GetSquadBlueprint("grenadier_squad_mg42lmg_mp"), 2);
	
end

function Mission_SpawnFirstWave()

	t_demo_hints = {};

	for i=1, #t_players do
		local sg_temp = SGroup_CreateIfNotFound("sg_temp");
		for j=1, t_difficulty.max_start do
			local pos = Util_GetRandomPosition(t_players[i].move, 10);
			Util_CreateSquads(t_players[i].player, sg_temp, BP_GetSquadBlueprint("riflemen_squad_mp"), t_players[i].spawner, pos, 1, nil, false);
		end
		local pos = Util_GetRandomPosition(t_players[i].move, 10);
		local sg_engineers = SGroup_CreateIfNotFound("sg_engineers_temp");
		Util_CreateSquads(t_players[i].player, sg_engineers, BP_GetSquadBlueprint("assault_engineer_squad_5_man_mp"), t_players[i].spawner, pos, 1, nil, false);
		local hint = HintPoint_Add(sg_engineers, true, "$08a0ac9c7e6144909909a02d533ce8aa:393", 1.5, HPAT_Hint);
		table.insert(t_demo_hints, hint);
		UI_AddHintAndFlashAbility(t_players[i].player, BP_GetAbilityBlueprint("combat_engineer_timed_demo_mp"), "$08a0ac9c7e6144909909a02d533ce8aa:391", 25.0);
		Player_AddResource(t_players[i].player, RT_Munition, 180);
		Modify_Vulnerability(sg_temp, 0.5);
		Modify_ReceivedSuppression(sg_temp, 0.5);
	end
	
	local blow01 = HintPoint_Add(mkr_blow_guide01, true, "$08a0ac9c7e6144909909a02d533ce8aa:392", 1.5, HPAT_Hint, "Icons_abilities_ability_soviet_demo_charge");
	local blow02 = HintPoint_Add(mkr_blow_guide02, true, "$08a0ac9c7e6144909909a02d533ce8aa:392", 1.5, HPAT_Hint, "Icons_abilities_ability_soviet_demo_charge");
	local blow03 = HintPoint_Add(mkr_blow_guide03, true, "$08a0ac9c7e6144909909a02d533ce8aa:392", 1.5, HPAT_Hint, "Icons_abilities_ability_soviet_demo_charge");
	
	table.insert(t_demo_hints, blow01);
	table.insert(t_demo_hints, blow02);
	table.insert(t_demo_hints, blow03);
	
	Game_SubTextFade("$08a0ac9c7e6144909909a02d533ce8aa:386", "$08a0ac9c7e6144909909a02d533ce8aa:387", 0.5, 5, 0.5);
	
	UI_SetCPMeterVisibility(false);
	UI_SetAbilityCardVisibility(false);
	UI_EnableUIEventCueType(UIE_EnemyReveal, false);
	UI_TerritoryHide();
	
	Objective_Start(OBJ_Beach, true);
	Objective_Start(OBJ_COMMANDBUNKERS, false);
	Objective_Start(OBJ_FLAK, false);
	
	t_artillery = 
	{
		mkr_arty01, mkr_arty02, mkr_arty03, mkr_arty04, mkr_arty05, mkr_arty06, mkr_arty07, mkr_arty08, mkr_arty09, mkr_arty10, 
		mkr_arty11, mkr_arty12, mkr_arty13, mkr_arty14, mkr_arty15, mkr_arty16, mkr_arty17, mkr_arty18, mkr_arty19, mkr_arty20,
		mkr_arty21, mkr_arty22, mkr_arty23, mkr_arty24, mkr_arty25, mkr_arty26, mkr_arty27, mkr_arty28, mkr_arty29, mkr_arty30
	};
	
	t_ai_goto_positions = 
	{
		mkr_ai_goto01, mkr_ai_goto02, mkr_ai_goto03, mkr_ai_goto04, mkr_ai_goto05, mkr_ai_goto06, mkr_ai_goto07, mkr_ai_goto08, mkr_ai_goto09, mkr_ai_goto10,
		mkr_ai_goto11, mkr_ai_goto12, mkr_ai_goto13, mkr_ai_goto14, mkr_ai_goto15, mkr_ai_goto16, mkr_ai_goto17, mkr_ai_goto18, mkr_ai_goto19, mkr_ai_goto20,
		mkr_ai_goto21, mkr_ai_goto22, mkr_ai_goto23, mkr_ai_goto24, mkr_ai_goto25, mkr_ai_goto26, mkr_ai_goto27, mkr_ai_goto28, mkr_ai_goto29, mkr_ai_goto30,
		mkr_ai_goto31, mkr_ai_goto32, mkr_ai_goto33, mkr_ai_goto34, mkr_ai_goto35, mkr_ai_goto36, mkr_ai_goto37, mkr_ai_goto38, mkr_ai_goto39, mkr_ai_goto40,
		mkr_ai_goto41, mkr_ai_goto42, mkr_ai_goto43, mkr_ai_goto44, mkr_ai_goto45, mkr_ai_goto46, mkr_ai_goto47, mkr_ai_goto48, mkr_ai_goto49, mkr_ai_goto50,
		mkr_ai_goto51, mkr_ai_goto52, mkr_ai_goto53
	};
	
	t_ai_spawners = 
	{
		mkr_beachspawner01, mkr_beachspawner02, mkr_beachspawner03
	}
	
	sg_ai_units = SGroup_CreateIfNotFound("sg_ai_units");
	
	Mission_AI_PlaceDemo();
	Mission_BeachUI();
	
	Timer_Start("_REINFORCEMENTTIMER", 3 * 60);
	Timer_Start("_BEACHTIME", 20 * 60);
	
	g_wavecount = 1;
	g_half_defence = SGroup_Count(sg_beach_defence_units) / 2;
	
	Rule_AddOneShot(Mission_RemoveHints, 25);
	
	Rule_AddInterval(Mission_UpdateWaves, 1);
	Rule_AddInterval(Mission_BeachCaptured, 1);
	Rule_AddInterval(Mission_BunkersCleared, 1);
	Rule_AddInterval(Mission_FlakCleared, 1);
	Rule_AddInterval(Mission_Ambient_Explosions, 6);
	
end

function Mission_RemoveHints()

	for i=1, #t_demo_hints do
		HintPoint_Remove(t_demo_hints[i]);
	end

end

function Mission_Ambient_Explosions()

	local amount = World_GetRand(1, 5);

	for i=1, amount do
		local pos = t_artillery[World_GetRand(1, #t_artillery)];
		Cmd_Ability(player8, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT, pos, nil, true, true); 
	end
	
end

function Mission_AI_PlaceDemo()

	Cmd_Ability(player8, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT, mkr_ai_demo01, nil, true, true); 
	Cmd_Ability(player8, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT, mkr_ai_demo02, nil, true, true); 
	
	if (#t_players == 1) then
		Cmd_Ability(player8, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT, mkr_blow_guide01, nil, true, true); 
		Cmd_Ability(player8, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT, mkr_blow_guide03, nil, true, true); 
	elseif (#t_players == 2) then
		Cmd_Ability(player8, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT, mkr_blow_guide03, nil, true, true); 
	end
	
	Rule_AddDelayedInterval(Mission_AI_Waves, 30, 10);
	
end

g_current_goto = 1;

function Mission_AI_Waves()

	if (SGroup_Count(sg_ai_units) <= SGroup_Count(sg_beach_defence_units)-10) then

		local sg_ai_temp = SGroup_CreateIfNotFound("sg_ai_temp");
		
		Util_SpawnSquadWithMembers(player4, sg_ai_temp, BP_GetSquadBlueprint("riflemen_squad_mp"), World_GetRand(1, 3), t_ai_spawners[World_GetRand(1, #t_ai_spawners)], t_ai_goto_positions[g_current_goto]);
		SGroup_EnableUIDecorator(sg_ai_temp, false);
		SGroup_EnableMinimapIndicator(sg_ai_temp, false);
		SGroup_SetSelectable(sg_ai_temp, false);
		
		Modify_Vulnerability(sg_ai_temp, 1.5);
		Modify_ReceivedSuppression(sg_ai_temp, 1.5);
		
		g_current_goto = g_current_goto + 1;

		if (g_current_goto == #t_ai_goto_positions) then
			g_current_goto = 1;
		end
		
		SGroup_AddGroup(sg_ai_units, sg_ai_temp);
		
	end
	
end

_TYPE_UI_MISSION_DESTROY = 0;
_TYPE_UI_MISSION_CAPTURE = 1;
_TYPE_UI_MISSION_KILL = 2

function Mission_BeachUI()

	OBJ_Beach.t_ui = {};

	for i=1, EGroup_Count(eg_mortar_bunkers) do
		
		local entity = EGroup_GetSpawnedEntityAt(eg_mortar_bunkers, i);
		local hint = HintPoint_Add(EGroup_FromEntity(entity), false, "$08a0ac9c7e6144909909a02d533ce8aa:403", 1.5, HPAT_Objective);
		
		local t = {hp = hint, show = true, eg = EGroup_FromEntity(entity), type = _TYPE_UI_MISSION_DESTROY, sg = nil, showing = false};
		table.insert(OBJ_Beach.t_ui, t);
		
	end

	local t1 = {hp = HintPoint_Add(eg_vic01, false, "$08a0ac9c7e6144909909a02d533ce8aa:404", 1.5, HPAT_Objective), show = true, eg = eg_vic01, type = _TYPE_UI_MISSION_CAPTURE, sg = nil, showing = false};
	local t2 = {hp = HintPoint_Add(eg_vic02, false, "$08a0ac9c7e6144909909a02d533ce8aa:404", 1.5, HPAT_Objective), show = true, eg = eg_vic02, type = _TYPE_UI_MISSION_CAPTURE, sg = nil, showing = false};
	table.insert(OBJ_Beach.t_ui, t1);
	table.insert(OBJ_Beach.t_ui, t2);

	local t1 = {hp = HintPoint_Add(sg_how1, false, "$08a0ac9c7e6144909909a02d533ce8aa:405", 1.5, HPAT_Objective), show = true, eg = nil, type = nil, sg = sg_how1, showing = false};
	local t2 = {hp = HintPoint_Add(sg_how2, false, "$08a0ac9c7e6144909909a02d533ce8aa:405", 1.5, HPAT_Objective), show = true, eg = nil, type = nil, sg = sg_how2, showing = false};
	local t3 = {hp = HintPoint_Add(sg_how3, false, "$08a0ac9c7e6144909909a02d533ce8aa:405", 1.5, HPAT_Objective), show = true, eg = nil, type = nil, sg = sg_how3, showing = false};
	table.insert(OBJ_Beach.t_ui, t1);
	table.insert(OBJ_Beach.t_ui, t2);
	table.insert(OBJ_Beach.t_ui, t3);
	
	local t4 = {hp = HintPoint_Add(eg_flak01, false, "$08a0ac9c7e6144909909a02d533ce8aa:405", 1.5, HPAT_Objective), show = true, eg = eg_flak01, type = _TYPE_UI_MISSION_KILL, sg = nil, showing = false};
	local t5 = {hp = HintPoint_Add(eg_flak02, false, "$08a0ac9c7e6144909909a02d533ce8aa:405", 1.5, HPAT_Objective), show = true, eg = eg_flak02, type = _TYPE_UI_MISSION_KILL, sg = nil, showing = false};
	table.insert(OBJ_Beach.t_ui, t4);
	table.insert(OBJ_Beach.t_ui, t5);
	
	Rule_AddInterval(Mission_UpdateBeachUI, 5);
	
end

function Mission_UpdateBeachUI()

	for i=1, #OBJ_Beach.t_ui do
		if (OBJ_Beach.t_ui[i].show == true) then
			
			if (OBJ_Beach.t_ui[i].sg ~= nil) then
			
				if (OBJ_Beach.t_ui[i].showing == false) then
					for j=1, #t_players do
						if (Player_CanSeeSGroup(t_players[j].player, OBJ_Beach.t_ui[i].sg, ANY)) then
							HintPoint_SetVisible(OBJ_Beach.t_ui[i].hp, true);
							OBJ_Beach.t_ui[i].showing = true;
							break;
						end
					end
				end
			
				if (SGroup_Count(OBJ_Beach.t_ui[i].sg) == 0) then
					
					HintPoint_Remove(OBJ_Beach.t_ui[i].hp);
					OBJ_Beach.t_ui[i].show = false;
					OBJ_HOWITZERS.counter_current = OBJ_HOWITZERS.counter_current + 1;
					
				end
			
				Objective_SetCounter(OBJ_HOWITZERS, OBJ_HOWITZERS.counter_current, OBJ_HOWITZERS.counter_max);
			
			else
				
				if (OBJ_Beach.t_ui[i].showing == false) then
					for j=1, #t_players do
						if (Player_CanSeeEGroup(t_players[j].player, OBJ_Beach.t_ui[i].eg, ANY)) then
							HintPoint_SetVisible(OBJ_Beach.t_ui[i].hp, true);
							OBJ_Beach.t_ui[i].showing = true;
							break;
						end
					end
				end
				
				if (OBJ_Beach.t_ui[i].type == _TYPE_UI_MISSION_CAPTURE) then
					
					local capped = false;
					
					for j=1, #t_players do
						if (EGroup_IsCapturedByPlayer(OBJ_Beach.t_ui[i].eg, t_players[j].player, ANY)) then
							capped = true;
							break;
						end
					end
					
					if (capped == true) then
						HintPoint_Remove(OBJ_Beach.t_ui[i].hp);
						OBJ_Beach.t_ui[i].show = false;
					end
					
				elseif (OBJ_Beach.t_ui[i].type == _TYPE_UI_MISSION_DESTROY) then
					
					if (EGroup_IsHoldingAny(OBJ_Beach.t_ui[i].eg) == false) then
						HintPoint_Remove(OBJ_Beach.t_ui[i].hp);
						OBJ_Beach.t_ui[i].show = false;
						--OBJ_COMMANDBUNKERS.counter_current = OBJ_COMMANDBUNKERS.counter_current + 1;
					end
					
					--Objective_SetCounter(OBJ_COMMANDBUNKERS, OBJ_COMMANDBUNKERS.counter_current, OBJ_COMMANDBUNKERS.counter_max);
					
				elseif (OBJ_Beach.t_ui[i].type == _TYPE_UI_MISSION_KILL) then
					
					if (EGroup_GetAvgHealth(OBJ_Beach.t_ui[i].eg) < 0.15) then
						HintPoint_Remove(OBJ_Beach.t_ui[i].hp);
						EGroup_Kill(OBJ_Beach.t_ui[i].eg);
						OBJ_Beach.t_ui[i].show = false;
						OBJ_FLAK.counter_current = OBJ_FLAK.counter_current + 1;
					end
					
					Objective_SetCounter(OBJ_FLAK, OBJ_FLAK.counter_current, OBJ_FLAK.counter_max);
					
				end
				
			end
			
		end
	end

end

function Mission_TriggerHowitzer()

	Objective_Start(OBJ_HOWITZERS, true);

	Rule_AddInterval(Mission_FireHowitzers, 60);
	Rule_AddInterval(Mission_HowitzerCleared, 1);
	Rule_AddInterval(Mission_CheckBeachDefence, 1);
	
end

function Mission_FireHowitzers()
	
	if (SGroup_GetAvgHealth(sg_how1) > 0.15) then
		local target = t_artillery[World_GetRand(1, #t_artillery)];
		Cmd_Ability(sg_how1, BP_GetAbilityBlueprint("howitzer_105mm_barrage_ability_mp"), target, nil, true, true); 
	end

	if (SGroup_GetAvgHealth(sg_how2) > 0.15) then
		local target = t_artillery[World_GetRand(1, #t_artillery)];
		Cmd_Ability(sg_how2, BP_GetAbilityBlueprint("howitzer_105mm_barrage_ability_mp"), target, nil, true, true); 
	end
	
	if (SGroup_GetAvgHealth(sg_how3) > 0.15) then
		local target = t_artillery[World_GetRand(1, #t_artillery)];
		Cmd_Ability(sg_how3, BP_GetAbilityBlueprint("howitzer_105mm_barrage_ability_mp"), target, nil, true, true); 
	end
	
end

function Mission_UpdateWaves()

	if (Timer_GetRemaining("_REINFORCEMENTTIMER") == 0) then
		if (g_wavecount >= t_difficulty.max_waves) then
			for i=1, #t_players do
				local sg_temp = SGroup_CreateIfNotFound("sg_temp");
				for j=1, t_difficulty.max_wave_reinforce do
					local pos = Util_GetRandomPosition(t_players[i].move, 10);
					Util_CreateSquads(t_players[i].player, sg_temp, BP_GetSquadBlueprint("riflemen_squad_mp"), t_players[i].spawner, pos, 1, nil, false);
				end
				Modify_Vulnerability(sg_temp, 0.5);
				Modify_ReceivedSuppression(sg_temp, 0.5);
				Player_AddResource(t_players[i].player, RT_Munition, 60);
			end
			Rule_AddInterval(Mission_CheckAnnihilation, 5);
			Obj_HideProgress();
			Rule_RemoveMe();
		else
			for i=1, #t_players do
				local sg_temp = SGroup_CreateIfNotFound("sg_temp");
				for j=1, t_difficulty.max_wave_reinforce do
					local pos = Util_GetRandomPosition(t_players[i].move, 10);
					Util_CreateSquads(t_players[i].player, sg_temp, BP_GetSquadBlueprint("riflemen_squad_mp"), t_players[i].spawner, pos, 1, nil, false);
				end
				Modify_Vulnerability(sg_temp, 0.5);
				Modify_ReceivedSuppression(sg_temp, 0.5);
				Player_AddResource(t_players[i].player, RT_Munition, 60);
			end
			Timer_Start("_REINFORCEMENTTIMER", 3 * 60);
			g_wavecount = g_wavecount + 1;
		end
	else
		Obj_ShowProgress("$08a0ac9c7e6144909909a02d533ce8aa:394", Timer_GetRemaining("_REINFORCEMENTTIMER") / (3 * 60));
	end
	
end

function Mission_CheckAnnihilation()

	local remains = 0;
	
	for i=1, #t_players do
		remains = remains + Player_GetUnitCount(t_players[i].player);
	end

	if (remains == 0) then
		Objective_Fail(OBJ_Beach, true);
		Codiex_EndGame("aef", false);
	end
	
end

function Mission_CheckBeachDefence()

	if (SGroup_Count(sg_beach_defence_units) <= g_half_defence) then
	
		Mission_ReinforceBeach();
		Util_StartIntel(EVENTS.BEACH_REINFORCE);
		Rule_RemoveMe();
	
	end

end

g_reinforce_unit_bp01 = nil;
g_reinforce_unit_bp02 = nil;
g_reinforce_unit_bp03 = nil;
g_reinforce_unit_bp04 = nil;
g_reinforce_unit_bp05 = nil;
g_reinforce_unit_bp06 = nil;

g_sg_reinforce = nil;
g_sg_halftracks = nil;
g_sg_infantry01 = nil;
g_sg_infantry02 = nil;
g_sg_infantry03 = nil;
g_halftrack_stay = false;

function Mission_ReinforceBeach() --random_stop

	g_sg_reinforce = SGroup_CreateIfNotFound("sg_german_beach_reinforce");
	g_sg_halftracks = SGroup_CreateIfNotFound("sg_german_beach_halftracks");
	g_sg_infantry01 = SGroup_CreateIfNotFound("sg_german_infantry01");
	g_sg_infantry02 = SGroup_CreateIfNotFound("sg_german_infantry02");
	g_sg_infantry03 = SGroup_CreateIfNotFound("sg_german_infantry03");
	
	if (Timer_GetElapsed("_BEACHTIME") <= 5 * 60) then -- light reinforcements (Infantry only)
		
		g_reinforce_unit_bp01 = BP_GetSquadBlueprint("grenadier_squad_mp");
		g_reinforce_unit_bp02 = BP_GetSquadBlueprint("grenadier_squad_mp");
		g_reinforce_unit_bp03 = BP_GetSquadBlueprint("assault_grenadier_squad_mp");
		
		Rule_AddOneShot(Mission_ReinforceSpawn01, 5);
		Rule_AddOneShot(Mission_ReinforceSpawn02, 10);
		Rule_AddOneShot(Mission_ReinforceSpawn03, 15);
		
	elseif (Timer_GetElapsed("_BEACHTIME") <= 10 * 60) then -- medium reinforcements (Infantry + Halftracks stays + 1 Panzer IV)
		
		g_reinforce_unit_bp01 = BP_GetSquadBlueprint("grenadier_squad_mp");
		g_reinforce_unit_bp02 = BP_GetSquadBlueprint("panzer_grenadier_squad_mp");
		g_reinforce_unit_bp03 = BP_GetSquadBlueprint("assault_grenadier_squad_mp");
		g_reinforce_unit_bp04 = BP_GetSquadBlueprint("panzer_iv_stubby_squad_mp");
		
		g_halftrack_stay = true;
		
		Rule_AddOneShot(Mission_ReinforceSpawn01, 5);
		Rule_AddOneShot(Mission_ReinforceSpawn02, 10);
		Rule_AddOneShot(Mission_ReinforceSpawn03, 15);
		Rule_AddOneShot(Mission_ReinforceSpawn04, 20);
		
	elseif (Timer_GetElapsed("_BEACHTIME") <= 15 * 60) then -- heavy reinforcements (Infantry + Halftracks stays + 2 Panzer IV's)
		
		g_reinforce_unit_bp01 = BP_GetSquadBlueprint("panzer_grenadier_squad_mp");
		g_reinforce_unit_bp02 = BP_GetSquadBlueprint("panzer_grenadier_squad_mp");
		g_reinforce_unit_bp03 = BP_GetSquadBlueprint("assault_grenadier_squad_mp");
		g_reinforce_unit_bp04 = BP_GetSquadBlueprint("panzer_iv_stubby_squad_mp");
		g_reinforce_unit_bp05 = BP_GetSquadBlueprint("panzer_iv_stubby_squad_mp");
		
		g_halftrack_stay = true;
		
		Rule_AddOneShot(Mission_ReinforceSpawn01, 5);
		Rule_AddOneShot(Mission_ReinforceSpawn02, 10);
		Rule_AddOneShot(Mission_ReinforceSpawn03, 15);
		Rule_AddOneShot(Mission_ReinforceSpawn04, 20);
		Rule_AddOneShot(Mission_ReinforceSpawn05, 25);
		
	elseif (Timer_GetElapsed("_BEACHTIME") <= 20 * 60) then -- bombardment & heavy reinforcements (Infantry + 2 Panzer IV's + 1 Tiger)
		
		g_reinforce_unit_bp01 = BP_GetSquadBlueprint("panzer_grenadier_squad_mp");
		g_reinforce_unit_bp02 = BP_GetSquadBlueprint("panzer_grenadier_squad_mp");
		g_reinforce_unit_bp03 = BP_GetSquadBlueprint("panzer_grenadier_squad_mp");
		g_reinforce_unit_bp04 = BP_GetSquadBlueprint("panzer_iv_stubby_squad_mp");
		g_reinforce_unit_bp05 = BP_GetSquadBlueprint("panzer_iv_stubby_squad_mp");
		g_reinforce_unit_bp06 = BP_GetSquadBlueprint("tiger_squad_mp");
		
		g_halftrack_stay = true;
		
		Rule_AddOneShot(Mission_ReinforceSpawn01, 5);
		Rule_AddOneShot(Mission_ReinforceSpawn02, 10);
		Rule_AddOneShot(Mission_ReinforceSpawn03, 15);
		Rule_AddOneShot(Mission_ReinforceSpawn04, 20);
		Rule_AddOneShot(Mission_ReinforceSpawn05, 25);
		Rule_AddOneShot(Mission_ReinforceSpawn06, 30);
		
	end
	
	Timer_End("_BEACHTIME"); 
	
	Rule_AddOneShot(Mission_ReinforceBeachStop, 80);
	
end

function Mission_ReinforceSpawn01()
	local sg_halftrack = SGroup_CreateIfNotFound("sg_halftrack");
	local sg_infantry = SGroup_CreateIfNotFound("sg_infantry");
	Util_CreateSquads(player6, sg_halftrack, BP_GetSquadBlueprint("sdkfz_251_halftrack_squad_mp"), mkr_german_beach_reinforcements, mkr_walk_dummy, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player6, sg_infantry, g_reinforce_unit_bp01, sg_halftrack, nil, 1, nil, false, nil, nil, nil);
	Cmd_SquadPath(sg_halftrack, "random_stop", true, LOOP_NONE, false, 3, nil, true, true);
	SGroup_AddGroup(g_sg_halftracks, sg_halftrack);
	SGroup_AddGroup(g_sg_infantry01, sg_infantry);
	SGroup_Clear(sg_halftrack);
	SGroup_Clear(sg_infantry);
end

function Mission_ReinforceSpawn02()
	local sg_halftrack = SGroup_CreateIfNotFound("sg_halftrack");
	local sg_infantry = SGroup_CreateIfNotFound("sg_infantry");
	Util_CreateSquads(player6, sg_halftrack, BP_GetSquadBlueprint("sdkfz_251_halftrack_squad_mp"), mkr_german_beach_reinforcements, mkr_walk_dummy, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player6, sg_infantry, g_reinforce_unit_bp02, sg_halftrack, nil, 1, nil, false, nil, nil, nil);
	Cmd_SquadPath(sg_halftrack, "random_stop", true, LOOP_NONE, false, 3, nil, true, true);
	SGroup_AddGroup(g_sg_halftracks, sg_halftrack);
	SGroup_AddGroup(g_sg_infantry02, sg_infantry);
	SGroup_Clear(sg_halftrack);
	SGroup_Clear(sg_infantry);
end

function Mission_ReinforceSpawn03()
	local sg_halftrack = SGroup_CreateIfNotFound("sg_halftrack");
	local sg_infantry = SGroup_CreateIfNotFound("sg_infantry");
	Util_CreateSquads(player6, sg_halftrack, BP_GetSquadBlueprint("sdkfz_251_halftrack_squad_mp"), mkr_german_beach_reinforcements, mkr_walk_dummy, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player6, sg_infantry, g_reinforce_unit_bp03, sg_halftrack, nil, 1, nil, false, nil, nil, nil);
	Cmd_SquadPath(sg_halftrack, "random_stop", true, LOOP_NONE, false, 3, nil, true, true);
	SGroup_AddGroup(g_sg_halftracks, sg_halftrack);
	SGroup_AddGroup(g_sg_infantry03, sg_infantry);
	SGroup_Clear(sg_halftrack);
	SGroup_Clear(sg_infantry);
end

function Mission_ReinforceSpawn04()
	local sg_vehicle = SGroup_CreateIfNotFound("sg_vehicle");
	Util_CreateSquads(player6, sg_vehicle, g_reinforce_unit_bp04, mkr_german_beach_reinforcements, mkr_walk_dummy, 1, nil, false, nil, nil, nil);
	Cmd_SquadPath(sg_vehicle, "random_stop", true, LOOP_NONE, false, 3, nil, true, true);
	SGroup_AddGroup(g_sg_reinforce, sg_vehicle);
	SGroup_Clear(sg_vehicle);
end

function Mission_ReinforceSpawn05()
	local sg_vehicle = SGroup_CreateIfNotFound("sg_vehicle");
	Util_CreateSquads(player6, sg_vehicle, g_reinforce_unit_bp05, mkr_german_beach_reinforcements, mkr_walk_dummy, 1, nil, false, nil, nil, nil);
	Cmd_SquadPath(sg_vehicle, "random_stop", true, LOOP_NONE, false, 3, nil, true, true);
	SGroup_AddGroup(g_sg_reinforce, sg_vehicle);
	SGroup_Clear(sg_vehicle);
end

function Mission_ReinforceSpawn06()
	local sg_vehicle = SGroup_CreateIfNotFound("sg_vehicle");
	Util_CreateSquads(player6, sg_vehicle, g_reinforce_unit_bp06, mkr_german_beach_reinforcements, mkr_walk_dummy, 1, nil, false, nil, nil, nil);
	Cmd_SquadPath(sg_vehicle, "random_stop", true, LOOP_NONE, false, 3, nil, true, true);
	SGroup_AddGroup(g_sg_reinforce, sg_vehicle);
	SGroup_Clear(sg_vehicle);
end

function Mission_ReinforceBeachStop()

	Cmd_Stop(g_sg_halftracks);
	Cmd_Stop(g_sg_reinforce);

	Cmd_EjectOccupants(g_sg_halftracks); 
	
	if (g_halftrack_stay == false) then
		Rule_AddOneShot(Mission_ReinforceCallback, 30);
	end

end

function Mission_ReinforceCallback()
	Cmd_MoveToAndDespawn(sg_halftrack, mkr_german_beach_reinforcements, false);
	Cmd_Move(g_sg_infantry01, mkr_ai_goto01);
	Cmd_Move(g_sg_infantry02, mkr_ai_goto25);
	Cmd_Move(g_sg_infantry03, mkr_ai_goto50);
end

function Mission_BeachCaptured()

	if (Objective_IsComplete(OBJ_COMMANDBUNKERS) == true and Objective_IsComplete(OBJ_HOWITZERS) == true and Objective_IsComplete(OBJ_FLAK) == true) then
	
		local count = 0;
	
		for i=1, #t_players do
			if (EGroup_IsCapturedByPlayer(eg_vic01, t_players[i].player, ANY)) then
				count = count + 1;
				break;
			end
		end
	
		for i=1, #t_players do
			if (EGroup_IsCapturedByPlayer(eg_vic02, t_players[i].player, ANY)) then
				count = count + 1;
				break;
			end
		end
	
		if (count == 2) then
			
			Objective_Complete(OBJ_Beach, true);
			Game_FadeToBlack(FADE_OUT, 2.5);
			Mission_BeachDone();
			Rule_RemoveMe();
			
		end
	
	end

end

function Mission_BunkersCleared()

	if (SGroup_Count(sg_commandefence) == 0) then
		
		Objective_Complete(OBJ_COMMANDBUNKERS, true);
		Rule_RemoveMe();
		
	end

end

function Mission_FlakCleared()
	
	if (EGroup_Count(eg_flak01) == 0 and EGroup_Count(eg_flak02) == 0) then
		
		Objective_Complete(OBJ_FLAK, true);
		Rule_RemoveMe();
		
	end
	
end

function Mission_HowitzerCleared()

	if (SGroup_Count(sg_how1) == 0 and SGroup_Count(sg_how2) == 0 and SGroup_Count(sg_how3) == 0) then
		
		Objective_Complete(OBJ_HOWITZERS, true);
		Rule_Remove(Mission_FireHowitzers);
		Rule_RemoveMe();
		
	end

end

function Mission_BeachDone()
	
	Obj_HideProgress();
	
	World_IncreaseInteractionStage();
	
	Mission_MoveUnitsForMeet();
	Mission_ShowTempBase();
	
	Util_StartIntel(EVENTS.OFFBEACH);
	
	Rule_Add(Mission_BeachIntelOver);
	
	if (SGroup_Count(sg_beach_defence_units) > 0) then
		Cmd_Retreat(sg_beach_defence_units, mkr_french_town_units, nil, false, false, true);
		Rule_AddOneShot(Mission_DivideRetreat, 4 * 60);
	end
	
	UI_EnableUIEventCueType(UIE_EnemyReveal, true);
	
	Rule_Remove(Mission_UpdateWaves);
	Rule_Remove(Mission_UpdateBeachUI);
	Rule_Remove(Mission_Ambient_Explosions);
	
end

function Mission_MoveUnitsForMeet()

	for i=1, #t_players do
		
		local sg_all = Player_GetSquads(t_players[i].player);
		
		for j=1, SGroup_Count(sg_all) do
			
			local squad = SGroup_FromSquad(SGroup_GetSpawnedSquadAt(sg_all, j));
			SGroup_WarpToPos(squad, Util_GetRandomPosition(mkr_beach_meetup, 30));
			
		end
		
	end

end

function Mission_ShowTempBase()

	EGroup_ReSpawn(eg_spawn_on_meet);
	EGroup_ReSpawn(eg_munition_meetup);

	EGroup_Kill(eg_kill_on_meet);
	
	EGroup_SetPlayerOwner(eg_heal_station, player1);
	EGroup_SetPlayerOwner(eg_spawn_on_meet, player1);
	
end

function Mission_DivideRetreat()

	if (SGroup_Count(sg_beach_defence_units) > 0) then

		local t_positions = {mkr_extra_move01, mkr_extra_move02, mkr_extra_move03, mkr_extra_move04, mkr_extra_move05, mkr_extra_move06, mkr_extra_move07, mkr_extra_move08, mkr_extra_move09, mkr_extra_move10, mkr_extra_move11, mkr_extra_move12};
		local pos = 1;
		
		for i=1, SGroup_Count(sg_beach_defence_units) do
			
			local squad = SGroup_FromSquad(SGroup_GetSpawnedSquadAt(sg_beach_defence_units, i));
			
			Cmd_Move(squad, t_positions[pos]);
			
			pos = pos + 1;
			if (pos == #t_positions) then
				pos = 1;
			end
			
		end
		
	end
	
end

function Mission_BeachIntelOver()
	
	if (Event_IsAnyRunning() == false) then
		
		Objective_Start(OBJ_FrenchTown, true);
		Objective_Start(OBJ_WEAPONRY, false);
		
		Mission_PopulateCity();
	
		sg_heavy_weapons = SGroup_CreateIfNotFound("sg_heavy_weapons");
	
		Production_SPAWN = mkr_beachspawner02;
		Production_GOTO = mkr_goto_position;
	
		Production_Initialize();
		
		Mission_SetUpHeavyWeaponry();
		
		Rule_AddInterval(Mission_FrenchTownCapped, 1);
		Rule_AddInterval(Mission_HeavyWeaponryDestroyed, 10);
		
		Rule_RemoveMe();
		
	end
	
end

function Mission_PopulateCity()

	sg_village_french = SGroup_CreateIfNotFound("sg_village_french");
	sg_village_french_rifles = SGroup_CreateIfNotFound("sg_village_french_rifles");
	sg_village_church = SGroup_CreateIfNotFound("sg_village_church");

	Util_SpawnGarrison(player6, eg_offbeach_mg_houses, sg_village_french, BP_GetSquadBlueprint("mg42_heavy_machine_gun_squad_mp"), 1);

	Util_SpawnGarrison(player6, eg_rifle_houses, sg_village_french_rifles, BP_GetSquadBlueprint("grenadier_squad_mp"), 1);
	
	Util_SpawnGarrison(player6, eg_church, sg_village_church, BP_GetSquadBlueprint("mg42_heavy_machine_gun_squad_mp"), 1);
	Util_SpawnGarrison(player6, eg_church, sg_village_church, BP_GetSquadBlueprint("sniper_squad_mp"), 1);
	Util_SpawnGarrison(player6, eg_church, sg_village_church, BP_GetSquadBlueprint("officer_squad_mp"), 1);
	Util_SpawnGarrison(player6, eg_church, sg_village_church, BP_GetSquadBlueprint("grenadier_squad_mg42lmg_mp"), 1);
	
end

function Mission_SetUpHeavyWeaponry()
	
	sg_pak1 = SGroup_CreateIfNotFound("sg_pak1");
	sg_pak2 = SGroup_CreateIfNotFound("sg_pak2");
	sg_tiger_tank = SGroup_CreateIfNotFound("sg_tiger_tank");

	Util_CreateSquads(player7, sg_pak1, BP_GetSquadBlueprint("pak43_88mm_at_gun_squad_mp"), mkr_pak43_01, nil, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player7, sg_pak2, BP_GetSquadBlueprint("pak43_88mm_at_gun_squad_mp"), mkr_pak43_02, nil, 1, nil, false, nil, nil, nil);

	HintPoint_Add(sg_pak1, true, "$08a0ac9c7e6144909909a02d533ce8aa:399", 1.5, HPAT_Objective);
	HintPoint_Add(sg_pak2, true, "$08a0ac9c7e6144909909a02d533ce8aa:399", 1.5, HPAT_Objective);

	Util_CreateSquads(player7, sg_tiger_tank, BP_GetSquadBlueprint("tiger_squad_mp"), mkr_tiger_spawn, nil, 1, nil, false, nil, nil, nil);
	Cmd_SquadPath(sg_tiger_tank, "tiger_path", true, LOOP_TOGGLE_DIRECTION, true, 0); 
	
	Cmd_InstantUpgrade(sg_tiger_tank, BP_GetUpgradeBlueprint("tiger_top_gunner_mp"), 1);
	
	Modify_UnitSpeed(sg_tiger_tank, 0.55); 
	Modify_Vulnerability(sg_tiger_tank, 0.55); 
	
	--Rule_AddInterval(Mission_TigerSpotted, 5); 
	
	SGroup_AddGroup(sg_heavy_weapons, sg_pak1);
	SGroup_AddGroup(sg_heavy_weapons, sg_pak2);
	SGroup_AddGroup(sg_heavy_weapons, sg_tiger_tank);
	
end

function Mission_TigerSpotted() -- give a bonus to the players or something

	Util_StartIntel(EVENTS.SPOTTEDTIGER);

	for i=1, #t_players do
		if (Player_CanSeeSGroup(t_players[i].player, sg_tiger_tank, ANY)) then
			Player_AddResource(t_players[i].player, RT_Munition, 320);
			t_players[i].rate_munition = Modify_PlayerResourceRate(t_players[i].player, RT_Munition, 1.48, MUT_Multiplication);
			Util_StartIntel(EVENTS.SPOTTEDTIGER);
			Rule_RemoveMe();
			break;
		end
	end
	
end

function Mission_FrenchTownCapped()

	if (Objective_IsComplete(OBJ_WEAPONRY) == true) then
		
		local capped = false;
		
		for i=1, #t_players do
			if (EGroup_IsCapturedByPlayer(eg_vic_last, t_players[i].player, ANY)) then
				capped = true;
				break;
			end
		end
		
		if (capped == true) then
			
			local sg_town_count = SGroup_CreateIfNotFound("sg_town_count");
			Player_GetAllSquadsNearMarker(player3, sg_town_count, mkr_french_town_units, 75); 
			
			if (SGroup_Count(sg_town_count) == 0) then
				
				Objective_Complete(OBJ_FrenchTown, true);				
				Codiex_EndGame("aef", true);
				
			end
			
		end
		
	end

end

function Mission_HeavyWeaponryDestroyed()

	if (SGroup_Count(sg_heavy_weapons) == 0) then

		Objective_Complete(OBJ_WEAPONRY, true);
		Rule_RemoveMe();
	
	end
	
end

-- Spawns a squad without the specified amount of members
function Util_SpawnSquadWithMembers(player, sgroup, blueprint, members_to_remove, spawn, destination)

	local sg_member = SGroup_CreateIfNotFound("sg_member");

	Util_CreateSquads(player, sg_member, blueprint, spawn, destination, 1, nil, false, nil, nil, nil);
	
	local squad = SGroup_GetSpawnedSquadAt(sg_member, 1);
	
	for i=0, members_to_remove-1 do
		local entity = Squad_EntityAt(squad, i);
		Entity_Destroy(entity);
	end
	
	SGroup_AddGroup(sgroup, sg_member);
	SGroup_Clear(sg_member);
	
end
