import("ScarUtil.scar");
import("Fatalities/Fatalities.scar");

function OnGameSetup()
	player1 = World_GetPlayerAt(1);
	player2 = World_GetPlayerAt(2);
	player3 = World_GetPlayerAt(3);
	player4 = World_GetPlayerAt(4);
	
	Setup_SetPlayerName(player2, "$08a0ac9c7e6144909909a02d533ce8aa:3");
	Setup_SetPlayerName(player3, "$08a0ac9c7e6144909909a02d533ce8aa:4");
	Setup_SetPlayerName(player4, "$08a0ac9c7e6144909909a02d533ce8aa:4");
	
end

function OnGameRestore()
	player1 = World_GetPlayerAt(1);
	player2 = World_GetPlayerAt(2);
	player3 = World_GetPlayerAt(3);
	player4 = World_GetPlayerAt(4);
	Game_DefaultGameRestore();
end

function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

function OnInit()

	t_availablereinforcements = {};
	
	t_attack01 = { "grenadier_squad_mp", "assault_grenadier_squad_mp", "ostruppen_squad_mp", "panzer_grenadier_squad_mp" };
	
	t_ambush01 = { "assault_grenadier_squad_mp", "panzer_grenadier_squad_mp"};
	
	t_villagedefence = { "grenadier_squad_mp", "assault_grenadier_squad_mp", "ostruppen_squad_mp", "panzer_grenadier_squad_mp" };
	
	t_villagedefence_north = { "grenadier_squad_mp", "assault_grenadier_squad_mp", "ostruppen_squad_mp", "panzer_grenadier_squad_mp", "pioneer_squad_tow" };
	t_villagedefence_north_vehicles = { "scoutcar_sdkfz222_mp", "mechanized_250_halftrack_grenadiers_mp", "stug_iii_e_squad_mp" };
	
	t_convoy_units = {
		
		{blueprint = "m4a3_sherman_squad_mp", hold = "", sg = SGroup_FromName("sg_convoy_vehicle1")},
		{blueprint = "m4a3_sherman_squad_mp", hold = "", sg = SGroup_FromName("sg_convoy_vehicle2")},
		{blueprint = "m4a3_sherman_squad_mp", hold = "", sg = SGroup_FromName("sg_convoy_vehicle3")},
		{blueprint = "m4a3_sherman_squad_mp", hold = "", sg = SGroup_FromName("sg_convoy_vehicle4")},
		{blueprint = "m10_tank_destroyer_squad_mp", hold = "", sg = SGroup_FromName("sg_convoy_vehicle5")},
		{blueprint = "m3_halftrack_squad_mp", hold = "riflemen_squad_veteran_mp", sg = SGroup_FromName("sg_convoy_vehicle6")},
		{blueprint = "m3_halftrack_squad_mp", hold = "riflemen_squad_veteran_mp", sg = SGroup_FromName("sg_convoy_vehicle7")},
		{blueprint = "m4a3_76mm_sherman_bulldozer_squad_mp", hold = "", sg = SGroup_FromName("sg_convoy_vehicle8")},
		{blueprint = "m3_halftrack_squad_mp", hold = "riflemen_squad_veteran_mp", sg = SGroup_CreateIfNotFound("sg_convoy_vehicle9")},
		{blueprint = "m4a3_76mm_sherman_bulldozer_squad_mp", hold = "", sg = SGroup_CreateIfNotFound("sg_convoy_vehicle10")},
		
	}
	
	Mission_Difficulty();
	Mission_Restrictions();
	Mission_LoadReinforcements();
	InitializeObjective();
	
	sg_attack01 = SGroup_CreateIfNotFound("sg_attack01");
	sg_attack02 = SGroup_CreateIfNotFound("sg_attack02");
	sg_attack03 = SGroup_CreateIfNotFound("sg_attack03");
	sg_attack04 = SGroup_CreateIfNotFound("sg_attack04");
	sg_convoy = SGroup_CreateIfNotFound("sg_convoy");
	sg_ambush01 = SGroup_CreateIfNotFound("sg_ambush01");
	sg_ambush02 = SGroup_CreateIfNotFound("sg_ambush02");
	sg_fortifyforce01 = SGroup_CreateIfNotFound("sg_fortifyforce01");
	sg_fortifyforce02 = SGroup_CreateIfNotFound("sg_fortifyforce02");
	sg_fortifyforce03 = SGroup_CreateIfNotFound("sg_fortifyforce03");
	sg_fortifyforce04 = SGroup_CreateIfNotFound("sg_fortifyforce04");
	sg_pantherambush = SGroup_CreateIfNotFound("sg_pantherambush");
	sg_village_em_halftrack = SGroup_CreateIfNotFound("sg_village_em_halftrack");
	sg_village_em_halftrack_squad = SGroup_CreateIfNotFound("sg_village_em_halftrack_squad");
	sg_ai_defence01 = SGroup_CreateIfNotFound("sg_ai_defence01");
	sg_ai_defence02 = SGroup_CreateIfNotFound("sg_ai_defence02");
	sg_ai_defence03 = SGroup_CreateIfNotFound("sg_ai_defence03");
	sg_village_defence01 = SGroup_CreateIfNotFound("sg_village_defence01");
	sg_village_defence02 = SGroup_CreateIfNotFound("sg_village_defence02");
	sg_village_defence03 = SGroup_CreateIfNotFound("sg_village_defence03");
	sg_village_defence04 = SGroup_CreateIfNotFound("sg_village_defence04");
	sg_village_defence05 = SGroup_CreateIfNotFound("sg_village_defence05");
	sg_village_defence06 = SGroup_CreateIfNotFound("sg_village_defence06");
	sg_village_defence07 = SGroup_CreateIfNotFound("sg_village_defence07");
	sg_village_defence08 = SGroup_CreateIfNotFound("sg_village_defence08");
	sg_tiger_tank = SGroup_CreateIfNotFound("sg_tiger_tank");
	sg_engineers = SGroup_CreateIfNotFound("sg_engineers");
	sg_engineers_truck = SGroup_CreateIfNotFound("sg_engineers_truck");
	sg_northvillageattackers = SGroup_CreateIfNotFound("sg_northvillageattackers");
	sg_aihelp01 = SGroup_CreateIfNotFound("sg_aihelp01");
	sg_aihelp02 = SGroup_CreateIfNotFound("sg_aihelp02");
	sg_aihelp03 = SGroup_CreateIfNotFound("sg_aihelp03");
	sg_aicounterattack = SGroup_CreateIfNotFound("sg_aicounterattack");
	
	eg_shermans = EGroup_CreateIfNotFound("eg_shermans");
	
	AI_EnableAll(false);
	SGroup_Hide(sg_hidden_obj4, true);
	DeCrewVehicles();
	
	Rule_AddOneShot(Mission_DelayIntel, 2);
	Rule_AddOneShot(m01_awardm20, 5);
	Rule_Add(m01_Begin);
	
	if (Misc_IsDevMode()) then
		Scar_DebugConsoleExecute("bind([[SHIFT+F4]], [[Scar_DoString('Cheat_DisableFOW()')]])");
	end
	
end

function Mission_DelayIntel()
	Util_StartIntel(EVENTS.INTRO);
end

Scar_AddInit(OnInit);

function Mission_Restrictions()

	g_manpowerrate = Modify_PlayerResourceRate(player1, RT_Manpower, 0, MUT_Multiplication);
	g_fuelrate = Modify_PlayerResourceRate(player1, RT_Fuel, 0, MUT_Multiplication);
	g_munitionrate = Modify_PlayerResourceRate(player1, RT_Munition, 0.45, MUT_Multiplication);
	Player_SetResource(player1, RT_Manpower, 120);
	Player_SetResource(player1, RT_Fuel, 0);
	Player_SetResource(player1, RT_Munition, 185);

	Player_StopEarningActionPoints(player1); 
	
	Cmd_InstantUpgrade(player1, BP_GetUpgradeBlueprint("rifle_command_grenade_mp"), 1);
	
end

function Mission_Difficulty()

	g_diff = Game_GetSPDifficulty();

	t_difficulty = {};
	
	if (g_diff == GD_EASY) then
		t_difficulty.shermanhealth = 0.20;
		t_difficulty.defend1_amount = 1;
		t_difficulty.defend1_vetmax = 0;
		t_difficulty.ambush = 2;
		t_difficulty.maxinfantryadd = 2;
		t_difficulty.maxvehicleadd = 2;
		t_difficulty.resourcebonus = 175;
		t_difficulty.convoy_damage = 0.125;
		t_difficulty.convoy_givendamage = 0.75;
		t_difficulty.northdefence_maxunits = 10;
		t_difficulty.northdefence_vehicles = false;
		t_difficulty.northdefence_maxvet = 0;
		t_difficulty.northdefence_allowupgrades = false;
		t_difficulty.maxAIhelp = 3;
		t_difficulty.maxvillagecounters = 6;
		SGroup_DestroyAllSquads(sg_only_on_hard);
		
		t_availablereinforcements.riflemen = 5;
		t_availablereinforcements.sherman = 0;
		
	elseif (g_diff == GD_NORMAL) then
		t_difficulty.shermanhealth = 0.10;
		t_difficulty.defend1_amount = 2;
		t_difficulty.defend1_vetmax = 1;
		t_difficulty.ambush = 2;
		t_difficulty.maxinfantryadd = 1;
		t_difficulty.maxvehicleadd = 1;
		t_difficulty.resourcebonus = 125;
		t_difficulty.convoy_damage = 0.2;
		t_difficulty.convoy_givendamage = 0.5;
		t_difficulty.northdefence_maxunits = 12;
		t_difficulty.northdefence_vehicles = true;
		t_difficulty.northdefence_maxvet = 1;
		t_difficulty.northdefence_allowupgrades = true;
		t_difficulty.maxAIhelp = 2;
		t_difficulty.maxvillagecounters = 8;
		SGroup_DestroyAllSquads(sg_only_on_hard);
		
		t_availablereinforcements.riflemen = 4;
		t_availablereinforcements.sherman = 0;
		
		table.insert(t_villagedefence, "mg42_heavy_machine_gun_squad_mp");
		table.insert(t_villagedefence, "pioneer_squad_tow");
		table.insert(t_villagedefence_north, "stormtrooper_squad_mp");
		
	elseif (g_diff == GD_HARD) then
		t_difficulty.shermanhealth = 0.07;
		t_difficulty.defend1_amount = 3;
		t_difficulty.defend1_vetmax = 3;
		t_difficulty.ambush = 3;
		t_difficulty.maxinfantryadd = 0;
		t_difficulty.maxvehicleadd = 0;
		t_difficulty.resourcebonus = 100;
		t_difficulty.convoy_damage = 0.4;
		t_difficulty.convoy_givendamage = 0.25;
		t_difficulty.northdefence_maxunits = 15;
		t_difficulty.northdefence_vehicles = true;
		t_difficulty.northdefence_maxvet = 3;
		t_difficulty.northdefence_allowupgrades = true;
		t_difficulty.maxAIhelp = 1;
		t_difficulty.maxvillagecounters = 12;
		
		t_availablereinforcements.riflemen = 2;
		t_availablereinforcements.sherman = 0;
		
		table.insert(t_villagedefence, "stormtrooper_squad_mp");
		table.insert(t_villagedefence, "mg42_heavy_machine_gun_squad_mp");
		table.insert(t_villagedefence, "pioneer_squad_tow");
		table.insert(t_villagedefence, "sniper_squad_mp");
		table.insert(t_villagedefence_north, "stormtrooper_squad_mp");
		table.insert(t_villagedefence_north, "sniper_squad_mp");
		table.insert(t_villagedefence_north_vehicles, "stug_iii_squad_mp");
		table.insert(t_villagedefence_north_vehicles, "panzer_iv_stubby_squad_mp");
		
	end
	
end

function Production(tag)
	if (t_availablereinforcements.hintpoint ~= nil) then
		HintPoint_Remove(t_availablereinforcements.hintpoint);
	end
	if (tag=="infantry_basic") then
		
		if (t_availablereinforcements.riflemen == 0) then
			t_availablereinforcements.warningID = UIWarning_Show("$08a0ac9c7e6144909909a02d533ce8aa:5");
			if (Rule_Exists(Production_WarningClean) == false) then
				Rule_AddOneShot(Production_WarningClean, 5);
			end
		else
			local pos = SGroup_GetPosition(sg_player_squads);
			Util_CreateSquads(player1, sg_player_squads, BP_GetSquadBlueprint("riflemen_squad_mp"), mkr_player_reinforcements, pos, 1, nil, false, nil, nil, nil);
			t_availablereinforcements.hintpoint = HintPoint_Add(pos, true, "$08a0ac9c7e6144909909a02d533ce8aa:6", 1.7, HPAT_RallyPoint);
			if (Rule_Exists(Production_HintpointClean) == false) then
				Rule_AddOneShot(Production_HintpointClean, 5);
			end
			t_availablereinforcements.riflemen = t_availablereinforcements.riflemen - 1;
			UI_ButtonSetText("dialog.basic_infantry", Util_CreateLocString(""..t_availablereinforcements.riflemen));
			UI_CreateMinimapBlip(pos, 5, BT_General); 
		end
		
	elseif (tag=="vehicle_basic") then
		
		if (t_availablereinforcements.sherman == 0) then
			t_availablereinforcements.warningID = UIWarning_Show("$08a0ac9c7e6144909909a02d533ce8aa:5");
			if (Rule_Exists(Production_WarningClean) == false) then
				Rule_AddOneShot(Production_WarningClean, 5);
			end
		else
			local pos = SGroup_GetPosition(sg_player_squads);
			Util_CreateSquads(player1, sg_player_squads, BP_GetSquadBlueprint("m4a3_sherman_squad_mp"), mkr_player_reinforcements, pos, 1, nil, false, nil, nil, nil);
			t_availablereinforcements.hintpoint = HintPoint_Add(pos, true, "$08a0ac9c7e6144909909a02d533ce8aa:6", 1.7, HPAT_RallyPoint);
			if (Rule_Exists(Production_HintpointClean) == false) then
				Rule_AddOneShot(Production_HintpointClean, 5);
			end
			t_availablereinforcements.sherman = t_availablereinforcements.sherman - 1;
			UI_ButtonSetText("dialog.basic_vehicle", Util_CreateLocString(""..t_availablereinforcements.sherman));
			UI_CreateMinimapBlip(pos, 5, BT_General); 
		end
		
	else
		return;
	end
	Production_Update();
end

function Production_WarningClean()
	UI_TitleDestroy(t_availablereinforcements.warningID); 
end

function Production_HintpointClean()
	HintPoint_Remove(t_availablereinforcements.hintpoint);
end

function Mission_LoadReinforcements()

	t_availablereinforcements.warningID = nil;
	t_availablereinforcements.hintpoint = nil;
	--COH2HUDStyles_HUD_Primary
	dialog =
	{
		controlType = "panel",
		name = "dialog",
		x = 1846.0,
		y = 460.0,
		width = 70.0,
		height = 300.0,
		margin = 12.0,
		children =
		{
		
            {
                controlType = "button",
                name = "basic_infantry",
                top = 0.0,
                width = 64.0,
                height = 64.0,
                callback = "Production",
                enabled = true,
                icon = "Icons_units_unit_aef_riflemen",
                style = BIS_Icon,
                tag = "infantry_basic",
                text = Util_CreateLocString(""..t_availablereinforcements.riflemen)
            },
			{
                controlType = "button",
                name = "basic_vehicle",
                top = 70.0,
                width = 64.0,
                height = 64.0,
                callback = "Production",
                enabled = true,
                icon = "Icons_vehicles_vehicle_aef_m4a3_sherman",
                style = BIS_Icon,
				tag = "vehicle_basic",
				text = Util_CreateLocString(""..t_availablereinforcements.sherman)
            },
			
		},
	}

	UI_AddControl(dialog);
	
	Production_EnableBasicInfantry(false);
	Production_EnableBasicVehicle(false);
	
end

function Production_EnableBasicInfantry(enable)
	UI_ButtonSetEnabled("dialog.basic_infantry", enable);
	if (enable == false) then
		UI_ButtonSetText("dialog.basic_infantry", Util_CreateLocString("0"));
	else
		UI_ButtonSetText("dialog.basic_infantry", Util_CreateLocString(""..t_availablereinforcements.riflemen));
	end
end

function Production_EnableBasicVehicle(enable)
	UI_ButtonSetEnabled("dialog.basic_vehicle", enable);
	if (enable == false) then
		UI_ButtonSetText("dialog.basic_vehicle", Util_CreateLocString("0"));
	else
		UI_ButtonSetText("dialog.basic_vehicle", Util_CreateLocString(""..t_availablereinforcements.sherman));
	end
end

function Production_Update()

	if (t_availablereinforcements.riflemen == 0) then
		Production_EnableBasicInfantry(false);
	else
		Production_EnableBasicInfantry(true);
	end
	
	if (t_availablereinforcements.sherman == 0) then
		Production_EnableBasicVehicle(false);
	else
		Production_EnableBasicVehicle(true);
	end
	
end

function InitializeObjective()

	OBJ_SQUADS = {
	
		SetupUI = function() 
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:7",
		Description = 0,
		Type = OT_Primary,
	}

	OBJ_PLAYERSQUADS = {
		Parent = OBJ_SQUADS,
		SetupUI = function()
		end,
		OnStart = function()
			Rule_AddInterval(_PlayerObjective_Check, 3);
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:8",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_DEFENDPATROL = {
	
		SetupUI = function() 
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
			Rule_AddOneShot(obj2_end, 10);
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:9",
		Description = 0,
		Type = OT_Primary,
	}
	
	OBJ_REPAIR = {
		Parent = OBJ_DEFENDPATROL,
		SetupUI = function()
		end,
		OnStart = function()
			Rule_AddDelayedInterval(obj1_spawnwaves, 15, 10, 0);
			Rule_AddInterval(obj1_repaired, 5);
			Cmd_Repair(sg_crews, sg_shermans);
			SGroup_Hide(sg_hidden_convoy, true);
			Rule_AddDelayedInterval(m01_update, 10, 1);
		end,
		OnComplete = function()
			Camera_MoveTo(mkr_camera_destination01, true, SLOW_CAMERA_PANNING, false, true); 
			Rule_AddOneShot(obj1_end, 5);
			World_IncreaseInteractionStage();
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:10",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_TIGERHUNT = {
		Parent = OBJ_DEFENDPATROL,
		SetupUI = function()
		end,
		OnStart = function()
			Production_EnableBasicInfantry(true); Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:39", 2.0, 5.0, 2.0); 
			Player_AddResource(player1, RT_Manpower, t_difficulty.resourcebonus);
		end,
		OnComplete = function()
			Player_AddResource(player1, RT_Manpower, t_difficulty.resourcebonus + 100);
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:11",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_BANKCONTROL = {
	
		SetupUI = function() 
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
		
			Rule_AddOneShot(obj4_begin, 8);
		
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:12",
		Description = 0,
		Type = OT_Primary,
	}
	
	OBJ_RIVER1 = {
		Parent = OBJ_BANKCONTROL,
		SetupUI = function()
			Objective_AddUIElements(OBJ_RIVER1, eg_side1_river, true, "$08a0ac9c7e6144909909a02d533ce8aa:14", true, 1.7, nil, nil, nil);
		end,
		OnStart = function()
			Modifier_Remove(g_manpowerrate);
			g_manpowerrate= Modify_PlayerResourceRate(player1, RT_Manpower, 0.40, MUT_Multiplication);
		end,
		OnComplete = function()
			t_availablereinforcements.sherman = Util_DifVar({3,2,1,1});
			Production_EnableBasicVehicle(true);
			Production_Update();
			Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:40", 2.0, 5.0, 2.0); 
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:13",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_RIVER2 = {
		Parent = OBJ_BANKCONTROL,
		SetupUI = function()
			Objective_AddUIElements(OBJ_RIVER2, eg_side2_river, true, "$08a0ac9c7e6144909909a02d533ce8aa:16", true, 1.7, nil, nil, nil);
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:15",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_VILLAGE = {
		Parent = OBJ_BANKCONTROL,
		SetupUI = function()
		end,
		OnStart = function()
			Rule_AddInterval(obj3_hasclearedvillage, 5);
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:17",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_ESCORT = {
		Parent = OBJ_BANKCONTROL,
		SetupUI = function()
		end,
		OnStart = function()
			Rule_Add(obj3_updatehealth);
		end,
		OnComplete = function()
		end,
		OnFail = function()
			Rule_AddOneShot(obj3_lose, 5);
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:22",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_BREAKTHROUGH = {
	
		SetupUI = function() 
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:25",
		Description = 0,
		Type = OT_Primary,
	}
	
	OBJ_CAPTURE_WEST_VILLAGE = {
		Parent = OBJ_BREAKTHROUGH,
		SetupUI = function()
			Objective_AddUIElements(OBJ_CAPTURE_WEST_VILLAGE, eg_enemy_hotspot_cap, true, "$08a0ac9c7e6144909909a02d533ce8aa:27", true, 1.7, nil, nil, nil);
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:26",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_CROSS = {
		Parent = OBJ_BREAKTHROUGH,
		SetupUI = function()
			Objective_AddUIElements(OBJ_CROSS, mkr_tiger_trigger_ui, true, "$08a0ac9c7e6144909909a02d533ce8aa:29", true, 1.7, nil, nil, nil);
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:28",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_DESTROY_TIGER = {
		Parent = OBJ_BREAKTHROUGH,
		SetupUI = function()
			Objective_AddUIElements(OBJ_DESTROY_TIGER, sg_tiger_tank, true, "$08a0ac9c7e6144909909a02d533ce8aa:31", true, 1.7, nil, nil, nil);
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:30",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_BRIDGEBUILDING = {
		Parent = OBJ_BREAKTHROUGH,
		SetupUI = function()
			Objective_AddUIElements(OBJ_BRIDGEBUILDING, eg_wrecked_stone_bridge, true, "$08a0ac9c7e6144909909a02d533ce8aa:34", true, 1.7, nil, nil, nil);
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
			Rule_AddOneShot(obj4_failed, 5);
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:32",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_ONELASTTIME = {
		Parent = OBJ_BREAKTHROUGH,
		SetupUI = function()
			Objective_AddUIElements(OBJ_ONELASTTIME, mkr_clear_location_ui_marker, true, "$08a0ac9c7e6144909909a02d533ce8aa:36", true, 1.7, nil, nil, nil);	
		end,
		OnStart = function()
			Rule_AddInterval(obj4_hasclearedarea, 5);
			Rule_AddOneShot(obj4_garrisonlast, 12);
		end,
		OnComplete = function()
			Rule_AddOneShot(Mission_Complete, 5);
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:35",
		Description = 0,
		Type = OT_Secondary,
	}
	
	Objective_Register(OBJ_SQUADS);
	Objective_Register(OBJ_PLAYERSQUADS);
	
	Objective_Register(OBJ_DEFENDPATROL);
	Objective_Register(OBJ_REPAIR);
	Objective_Register(OBJ_TIGERHUNT);
	
	Objective_Register(OBJ_BANKCONTROL);
	Objective_Register(OBJ_RIVER1);
	Objective_Register(OBJ_RIVER2);
	Objective_Register(OBJ_VILLAGE);
	Objective_Register(OBJ_ESCORT);
	
	Objective_Register(OBJ_BREAKTHROUGH);
	Objective_Register(OBJ_CAPTURE_WEST_VILLAGE);
	Objective_Register(OBJ_CROSS);
	Objective_Register(OBJ_DESTROY_TIGER);
	Objective_Register(OBJ_BRIDGEBUILDING);
	Objective_Register(OBJ_ONELASTTIME);
	
end

function _PlayerObjective_Warp()
	local sg_temp = SGroup_CreateIfNotFound("sg_temp");
	SGroup_Filter(sg_player_squads, BP_GetSquadBlueprint("m1_81mm_mortar_squad_mp"), FILTER_REMOVE, sg_temp);
	SGroup_Filter(sg_player_squads, BP_GetSquadBlueprint("m2_60mm_mortar_squad_mp"), FILTER_REMOVE, sg_temp);
	SGroup_SetPlayerOwner(sg_temp, player2);
	--[[SGroup_WarpToMarker(sg_player_squads, mkr_player_warp);]] Cmd_Move(sg_player_squads, mkr_player_warp);
	SGroup_SetAvgHealth(sg_player_squads, 1.0); 
end

function _PlayerObjective_Warp2()
	SGroup_WarpToMarker(sg_player_squads, mkr_playervillagewarp);
	SGroup_SetAvgHealth(sg_player_squads, 1.0);
end

function _PlayerObjective_Check()
	sg_player_squads = Player_GetSquads(player1);
	if (SGroup_Count(sg_player_squads) == 0) then
	
		Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:38", 5.0, 5.0, 5.0); 
		Game_EndSP(false);
		Rule_RemoveAll();
		
	end
end

function m01_Begin()

	if (Event_IsAnyRunning() == false) then

		Objective_Start(OBJ_SQUADS, false);
		Objective_Start(OBJ_PLAYERSQUADS, false);

		Objective_Start(OBJ_DEFENDPATROL, true);
		Objective_Start(OBJ_REPAIR, true);
		
		if (g_diff == GD_NORMAL or g_diff == GD_HARD) then
			Rule_Add(obj1_forceplayerback);
		end
		
		Rule_RemoveMe();

	end
	
end

function m01_awardm20()
	Util_CreateSquads(player1, sg_player_squads, BP_GetSquadBlueprint("m20_utility_car_squad_mp"), mkr_allied_engineers_spawner, mkr_enemy_path4, 1, nil, true, nil, nil, nil);
end

function m01_update()

	Obj_ShowProgress("$08a0ac9c7e6144909909a02d533ce8aa:19", EGroup_GetAvgHealth(eg_shermans));
	
end

function m01_readdshermans()
	World_GetNeutralEntitiesNearMarker(eg_shermans, mkr_99);
	World_GetNeutralEntitiesNearMarker(eg_shermans, mkr_100);
	World_GetNeutralEntitiesNearMarker(eg_shermans, mkr_101);
	World_GetNeutralEntitiesNearMarker(eg_shermans, mkr_102);
end

function DeCrewVehicles()
	SGroup_SetAvgHealth(sg_shermans, t_difficulty.shermanhealth);
	SGroup_SetRecrewable(sg_shermans, false);
	Command_PlayerSquadCriticalHit(player2, sg_toabandon, PCMD_CriticalHit, BP_GetCriticalBlueprint("vehicle_abandon"), 1, false);
	Modify_VehicleRepairRate(player2, 0.25, BP_GetEntityBlueprint("vehicle_crew_troop_mp"));
	m01_readdshermans();
end

function obj1_spawnwaves()
	
	if (SGroup_Count(sg_attack01) == 0) then
		Util_CreateSquads(player3, sg_attack01, BP_GetSquadBlueprint(t_attack01[World_GetRand(1, #t_attack01)]), mkr_enemy_attack_spawn, nil, World_GetRand(1, t_difficulty.defend1_amount), nil, true, nil, nil, nil);
		Cmd_AttackMove(sg_attack01, mkr_enemy_path1, true, nil, 10);
		Cmd_AttackMove(sg_attack01, mkr_enemy_path2, true, nil, 10);
		Cmd_AttackMove(sg_attack01, mkr_enemy_path3, true, nil, 10);
		Cmd_AttackMove(sg_attack01, mkr_enemy_final, true, nil, 10);
		SGroup_IncreaseVeterancyRank(sg_attack01, World_GetRand(0, t_difficulty.defend1_vetmax), true); 
	end
	
	if (SGroup_Count(sg_attack02) == 0) then
		Util_CreateSquads(player3, sg_attack02, BP_GetSquadBlueprint(t_attack01[World_GetRand(1, #t_attack01)]), mkr_enemy_attack_spawn, nil, World_GetRand(1, t_difficulty.defend1_amount), nil, true, nil, nil, nil);
		Cmd_AttackMove(sg_attack02, mkr_enemy_path4, true, nil, 10);
		Cmd_AttackMove(sg_attack02, mkr_enemy_path5, true, nil, 10);
		Cmd_AttackMove(sg_attack02, mkr_enemy_final, false, nil, 10);
		SGroup_IncreaseVeterancyRank(sg_attack02, World_GetRand(0, t_difficulty.defend1_vetmax), true); 
	end
	
	if (SGroup_Count(sg_attack03) == 0) then
		Util_CreateSquads(player3, sg_attack03, BP_GetSquadBlueprint(t_attack01[World_GetRand(1, #t_attack01)]), mkr_enemy_attack_spawn, nil, World_GetRand(1, t_difficulty.defend1_amount), nil, true, nil, nil, nil);
		Cmd_AttackMove(sg_attack03, mkr_enemy_path6, true, nil, 10);
		Cmd_AttackMove(sg_attack03, mkr_enemy_path7, true, nil, 10);	
		Cmd_AttackMove(sg_attack03, mkr_enemy_path8, true, nil, 10);
		Cmd_AttackMove(sg_attack03, mkr_enemy_final, true, nil, 10);	
		SGroup_IncreaseVeterancyRank(sg_attack03, World_GetRand(0, t_difficulty.defend1_vetmax), true); 
	end
	
end

function obj1_forceplayerback()
	
	if (EGroup_GetAvgHealth(eg_shermans) >= 0.65) then
		
		if (Prox_AreSquadsNearMarker(sg_player_squads, mkr_arty_intel_detector, ANY, 40)) then
			Util_StartIntel(EVENTS.ARTY_CORRECT);
		else
			Util_StartIntel(EVENTS.ARTY_WRONG);
		end
		
		Rule_AddOneShot(obj1_mortarspawn, 16);
		Rule_AddOneShot(obj1_delayedartillery, 5);
		
		Rule_RemoveMe();
		
	end
	
end

function obj1_mortarspawn()
	Util_CreateSquads(player3, sg_attack04, BP_GetSquadBlueprint("mortar_team_81mm_mp"), mkr_enemy_attack_spawn, mkr_german_mortar_marker, 1, nil, true, nil, nil, nil);
end

function obj1_delayedartillery()

	Player_AddAbility(player3, BP_GetAbilityBlueprint("light_support_artillery"));
	Cmd_Ability(player3, BP_GetAbilityBlueprint("light_support_artillery"), mkr_arty01, nil, true, false);
	Cmd_Ability(player3, BP_GetAbilityBlueprint("light_support_artillery"), mkr_arty02, nil, true, false);
	Cmd_Ability(player3, BP_GetAbilityBlueprint("light_support_artillery"), mkr_arty03, nil, true, false);

end

function obj1_repaired()
	if (EGroup_GetAvgHealth(eg_shermans) == 1.0) then
		Objective_Complete(OBJ_REPAIR, true);
		obj1_recrew();
		Rule_Remove(obj1_spawnwaves);
		Rule_Remove(m01_update);
		Rule_RemoveMe();
	end
end

function obj1_recrew()
	local eg_temp = EGroup_CreateIfNotFound("eg_temp");
	World_GetNeutralEntitiesNearPoint(eg_temp, SGroup_GetPosition(sg_crew1), 2);
	EGroup_SetRecrewable(eg_temp, true);
	Cmd_RecrewVehicle(sg_crew1, eg_temp, false);
	EGroup_Clear(eg_temp);
	World_GetNeutralEntitiesNearPoint(eg_temp, SGroup_GetPosition(sg_crew2), 2);
	EGroup_SetRecrewable(eg_temp, true);
	Cmd_RecrewVehicle(sg_crew2, eg_temp, false);
	EGroup_Clear(eg_temp);
	World_GetNeutralEntitiesNearPoint(eg_temp, SGroup_GetPosition(sg_crew3), 2);
	EGroup_SetRecrewable(eg_temp, true);
	Cmd_RecrewVehicle(sg_crew3, eg_temp, false);
	EGroup_Clear(eg_temp);
	World_GetNeutralEntitiesNearPoint(eg_temp, SGroup_GetPosition(sg_crew4), 2);
	EGroup_SetRecrewable(eg_temp, true);
	Cmd_RecrewVehicle(sg_crew4, eg_temp, false);
	EGroup_Clear(eg_temp);
	m02_readdshermans();
end

function Cmd_Repair(executer, target, ability)
	if (ability == nil) then
		ability = "aef_repair_ability_vehicle_crew_mp";
	end
	Cmd_Ability(executer, BP_GetAbilityBlueprint(ability), target, nil, true, false);
end

incrementedInteger = 0;

function obj1_end()
	
	if (SGroup_Count(sg_attack01) > 0) then
		Cmd_Retreat(sg_attack01, mkr_axis_retreat, mkr_axis_retreat, false, false, true);
	end
	
	if (SGroup_Count(sg_attack02) > 0) then
		Cmd_Retreat(sg_attack02, mkr_axis_retreat, mkr_axis_retreat, false, false, true);
	end
	
	if (SGroup_Count(sg_attack03) > 0) then
		Cmd_Retreat(sg_attack03, mkr_axis_retreat, mkr_axis_retreat, false, false, true);
	end
	
	if (SGroup_Count(sg_attack04) > 0) then
		Cmd_Retreat(sg_attack04, mkr_axis_retreat, mkr_axis_retreat, false, false, true);
	end
	
	Rule_AddInterval(obj2_begin_convoy, 2);
	Rule_AddInterval(obj2_inrange, 1);
	
	SGroup_Hide(sg_hidden_convoy, false);
	Camera_Follow(SGroup_FromName("sg_convoy_vehicle1"));
	Game_EnableInput(false); 
	
	Util_StartIntel(EVENTS.TANKSDONE);
	
	_PlayerObjective_Warp();
	
	Obj_HideProgress();
	
end

function obj2_begin_convoy()
	incrementedInteger = incrementedInteger + 1;
	if (incrementedInteger == 9) then
		Rule_RemoveMe();
	elseif (incrementedInteger == 5) then
		Rule_RemoveMe();
		Rule_AddDelayedInterval(obj2_begin_convoy, 7, 2);
	end
	sg_temp = SGroup_FromName("sg_convoy_vehicle" ..incrementedInteger);
	if (SGroup_Count(sg_temp) == 0) then
		Util_CreateSquads(player2, sg_temp, BP_GetSquadBlueprint(t_convoy_units[incrementedInteger].blueprint), mkr_convoy_spawner, nil, 1, nil, false, nil, nil, nil);
		Modify_UnitSpeed(sg_temp, 0.4);
		if (t_convoy_units[incrementedInteger].hold ~= "") then
			Util_CreateSquads(player2, SGroup_CreateIfNotFound("_sg_temp_local_hold"), BP_GetSquadBlueprint(t_convoy_units[incrementedInteger].hold), sg_temp, nil, 1, nil, false, nil, nil, nil);
		end
	else
		Modify_UnitSpeed(sg_temp, 0.325);
	end
	Cmd_SquadPath(sg_temp, "convoy", true, LOOP_NONE, true, 0, nil);
	SGroup_AddGroup(sg_convoy, sg_temp);
end

function obj2_inrange()
	if (Prox_AreSquadMembersNearMarker(sg_convoy, mkr_convoy_stop, ANY, 8) == true) then
		Cmd_Stop(sg_convoy);
		Objective_Start(OBJ_TIGERHUNT, true);
		if (SGroup_Count(sg_allied_vet) > 0) then
			SGroup_SetPlayerOwner(sg_allied_vet, player1);
		end
		Camera_MoveTo(mkr_camera_destination02, true, SLOW_CAMERA_PANNING, false, true);
		Game_EnableInput(true); 
		World_IncreaseInteractionStage();
		Util_StartIntel(EVENTS.TIGER_WARNING);
		Rule_AddInterval(m02_ambush, 5);
		Rule_RemoveMe();
	end
end

function m02_readdshermans()
	World_GetSquadsNearMarker(player2, SGroup_FromName("sg_convoy_vehicle1"), mkr_102, OT_Player);
	World_GetSquadsNearMarker(player2, SGroup_FromName("sg_convoy_vehicle2"), mkr_101, OT_Player);
	World_GetSquadsNearMarker(player2, SGroup_FromName("sg_convoy_vehicle3"), mkr_100, OT_Player);
	World_GetSquadsNearMarker(player2, SGroup_FromName("sg_convoy_vehicle4"), mkr_99, OT_Player);
end

function m02_ambush()

	if (SGroup_CanSeeSGroup(sg_german_ambush_watchout, sg_player_squads, ANY)) then
		
		Util_CreateSquads(player3, sg_ambush01, BP_GetSquadBlueprint(t_ambush01[World_GetRand(1, #t_ambush01)]), mkr_german_ambush, nil, t_difficulty.ambush, nil, true, nil, nil, nil);
		Cmd_Move(sg_ambush01, Util_GetRandomPosition(mkr_inf_ambush_dest, 30), false);
		
		Rule_AddOneShot(m02_ambushdelayed, 15);
		Rule_RemoveMe();
		
	end

end

function m02_ambushdelayed()
	Util_CreateSquads(player3, sg_ambush02, BP_GetSquadBlueprint(t_ambush01[World_GetRand(1, #t_ambush01)]), mkr_german_ambush, nil, t_difficulty.ambush, nil, true, nil, nil, nil);
	Cmd_Move(sg_ambush02, Util_GetRandomPosition(mkr_inf_ambush_dest, 30), false);
	Cmd_InstantSetupTeamWeapon(sg_hmg_ambush, false);
	Rule_AddInterval(m02_playercanseetiger, 1);
end

function m02_playercanseetiger()
	if (SGroup_CanSeeSGroup(sg_player_squads, sg_tiger_hiding, ANY)) then
		World_IncreaseInteractionStage();
		m02_highlight_tiger();
		Rule_RemoveMe();
	end
end

function m02_highlight_tiger()

	Objective_UpdateText(OBJ_TIGERHUNT, "$08a0ac9c7e6144909909a02d533ce8aa:20", 0, true); 
	Objective_AddUIElements(OBJ_TIGERHUNT, SGroup_GetPosition(sg_tiger_hiding), true, "$08a0ac9c7e6144909909a02d533ce8aa:21", true, 1.7, nil, nil, nil);
	
	Event_OnHealth(m02_tiger_dead, nil, sg_tiger_hiding, 0.95, false, 2); 
	
end

function m02_tiger_dead()

	SGroup_Kill(sg_tiger_hiding);
	Objective_Complete(OBJ_TIGERHUNT, false);
	Objective_Complete(OBJ_DEFENDPATROL, true);

	Util_StartIntel(EVENTS.TIGER_DONE);
	
	sg_player_squads = Player_GetSquads(player1);
	
end

function obj2_end()

	obj3_fortify();

	Event_PlayerCanSeeElement(obj3_intelwarning, nil, player1, sg_intel_housewarning, ANY, 5);
	
	Rule_AddInterval(obj3_checksouth, 5);
	Rule_AddInterval(obj3_checknorth, 5);
	Rule_AddInterval(obj3_pantherambush, 7);
	Rule_AddInterval(obj3_inside_village, 4);
	Rule_AddInterval(obj3_part01_done, 9);
	
	Objective_Start(OBJ_BANKCONTROL, true);
	Objective_Start(OBJ_RIVER1, false);
	Objective_Start(OBJ_RIVER2, false);
	
end

function obj3_fortify()

	Util_CreateSquads(player3, sg_fortifyforce01, BP_GetSquadBlueprint("panzer_grenadier_squad_mp"), eg_building_next_to_church, nil, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, sg_fortifyforce02, BP_GetSquadBlueprint("mg42_heavy_machine_gun_squad_mp"), eg_grenadierx2_hmg, nil, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, sg_fortifyforce02, BP_GetSquadBlueprint("grenadier_squad_mp"), eg_grenadierx2_hmg, nil, 2, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, sg_fortifyforce03, BP_GetSquadBlueprint("mg42_heavy_machine_gun_squad_mp"), eg_house_mg_and_grenader, nil, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, sg_fortifyforce03, BP_GetSquadBlueprint("grenadier_squad_mp"), eg_house_mg_and_grenader, nil, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, sg_fortifyforce04, BP_GetSquadBlueprint("grenadier_squad_mp"), eg_house_sniper_and_grenadier, nil, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, sg_fortifyforce04, BP_GetSquadBlueprint("sniper_squad_mp"), eg_house_sniper_and_grenadier, nil, 1, nil, false, nil, nil, nil);
	
end

function obj3_intelwarning()
	Util_StartIntel(EVENTS.CAPSOUTHNORTH);
end

function obj3_checksouth()

	if (EGroup_IsCapturedByPlayer(eg_side1_river, player1, ALL)) then
	
		Objective_Complete(OBJ_RIVER1, true);
		t_availablereinforcements.riflemen = t_availablereinforcements.riflemen + t_difficulty.maxinfantryadd;
		Production_Update();
	
		if (g_diff == GD_HARD) then
			--obj3_doexpertrecon();
			--Util_StartIntel(EVENTS.RECON);
		end
	
		Rule_RemoveMe();
	
	end

end

function obj3_doexpertrecon()
	Player_AddAbility(player2, BP_GetAbilityBlueprint("recon_sweep"));
	Cmd_Ability(player2, BP_GetAbilityBlueprint("recon_sweep"), mkr_ally_recon_start, mkr_ally_recon_end, true, false);
end

function obj3_checknorth()

	if (EGroup_IsCapturedByPlayer(eg_side2_river, player1, ALL)) then
		
		Util_StartIntel(EVENTS.AITAKEOVER);
		
		Objective_Complete(OBJ_RIVER2, true);
		
		if (EGroup_IsHoldingAny(eg_grenadierx2_hmg)) then
			Cmd_EjectOccupants(eg_grenadierx2_hmg, nil, true);
		end

		if (EGroup_IsHoldingAny(eg_house_mg_and_grenader)) then
			Cmd_EjectOccupants(eg_house_mg_and_grenader, nil, true);
		end
		
		if (EGroup_IsHoldingAny(eg_house_sniper_and_grenadier)) then
			Cmd_EjectOccupants(eg_house_sniper_and_grenadier, nil, true);
		end
		
		Rule_RemoveMe();
		
	end

end

function obj3_pantherambush()

	if (Prox_AreSquadsNearMarker(sg_player_squads, mkr_panthercheck, ANY, 15) == true or Prox_AreSquadsNearMarker(sg_player_squads, mkr_panthercheck2, ANY, 15) == true) then
		
		Util_CreateSquads(player3, sg_pantherambush, BP_GetSquadBlueprint("panther_squad_mp"), mkr_panther_ambush, mkr_panther_destination, 1, nil, false, nil, nil, nil);
		Rule_RemoveMe();
		
	end

end

local HasSpawnedHalftrack = false;

function obj3_inside_village()

	if (SGroup_Count(sg_village_em_halftrack) == 0) then

		if (Prox_AreSquadsNearMarker(sg_player_squads, mkr_inside_village, ANY, 40) == true and HasSpawnedHalftrack == false) then
			
			Util_CreateSquads(player3, sg_village_em_halftrack, BP_GetSquadBlueprint("sdkfz_251_halftrack_squad_mp"), mkr_panther_ambush, nil, 1, nil, false, nil, nil, nil);
			Util_CreateSquads(player3, sg_village_em_halftrack_squad, BP_GetSquadBlueprint("grenadier_squad_mp"), sg_village_em_halftrack, nil, 2, nil, false, nil, nil, nil);
			Cmd_Move(sg_village_em_halftrack, mkr_dropoff_halftrack, true);
			Cmd_EjectOccupants(sg_village_em_halftrack, nil, true); 
			Cmd_Move(sg_village_em_halftrack, mkr_halftrack_detour01, true);
			Cmd_Move(sg_village_em_halftrack, mkr_halftrack_detour02, true);
			Cmd_Move(sg_village_em_halftrack, mkr_halftrack_detour03, true);
			Cmd_Move(sg_village_em_halftrack, mkr_panther_ambush, true);
			
			HasSpawnedHalftrack = true;
			
		elseif (HasSpawnedHalftrack == true) then
			Rule_RemoveMe();
		end

	else
		
		if (Prox_AreSquadsNearMarker(sg_village_em_halftrack, mkr_panther_ambush, ANY, 5)) then
			SGroup_DestroyAllSquads(sg_village_em_halftrack);
			Rule_RemoveMe();
		end
		
	end
	
end

function obj3_part01_done()

	if (Objective_IsComplete(OBJ_RIVER1) == true and Objective_IsComplete(OBJ_RIVER2) == true) then
		
		Objective_Start(OBJ_VILLAGE, true);
		Objective_Start(OBJ_ESCORT, true);
		
		obj3_ai_takeover();
		obj3_fortifymainvillage();
		
		World_IncreaseInteractionStage();
		Camera_MoveTo(mkr_camera_destination03, true, SLOW_CAMERA_PANNING, false, true);
		--Cmd_Move(sg_player_squads, mkr_camera_destination03);
		
		EGroup_DeSpawn(eg_los_blocking_interaction01);
		
		Rule_AddInterval(obj3_convoyativatepanther, 5);
		Rule_AddInterval(obj3_hasreachedlastpoint, 7);
		Rule_AddOneShot(obj3_moveconvoy, 20);
		
		Rule_RemoveMe();
		
	end	

end

function obj3_ai_takeover()
	
	if (EGroup_Count(eg_grenadierx2_hmg) > 0) then
		Util_CreateSquads(player2, sg_ai_defence01, BP_GetSquadBlueprint("riflemen_squad_veteran_mp"), mkr_spawn_riflesupport, nil, 2, nil, false, nil, nil, nil);
		SGroup_SetInvulnerable(sg_ai_defence01, true, nil);
		Cmd_Garrison(sg_ai_defence01, eg_grenadierx2_hmg, true, false, false); 
	end
	
	if (EGroup_Count(eg_house_mg_and_grenader) > 0) then
		Util_CreateSquads(player2, sg_ai_defence02, BP_GetSquadBlueprint("riflemen_squad_veteran_mp"), mkr_spawn_riflesupport, nil, 2, nil, false, nil, nil, nil);
		SGroup_SetInvulnerable(sg_ai_defence02, true, nil);
		Cmd_Garrison(sg_ai_defence02, eg_house_mg_and_grenader, true, false, false); 
	end
	
	if (EGroup_Count(eg_house_sniper_and_grenadier) > 0) then
		Util_CreateSquads(player2, sg_ai_defence03, BP_GetSquadBlueprint("riflemen_squad_veteran_mp"), mkr_spawn_riflesupport, nil, 2, nil, false, nil, nil, nil);
		SGroup_SetInvulnerable(sg_ai_defence03, true, nil);
		Cmd_Garrison(sg_ai_defence03, eg_house_sniper_and_grenadier, true, false, false);
	end
	
end

function obj3_fortifymainvillage()
	
	OBJ_VILLAGE.buildings = 
	{	
		{ui = Objective_AddUIElements(OBJ_VILLAGE, eg_clear01, true, "$08a0ac9c7e6144909909a02d533ce8aa:18", true, 1.7, nil, nil, nil), eg = eg_clear01, sg=sg_village_defence01},
		{ui = Objective_AddUIElements(OBJ_VILLAGE, eg_clear02, true, "$08a0ac9c7e6144909909a02d533ce8aa:18", true, 1.7, nil, nil, nil), eg = eg_clear02, sg=sg_village_defence02},
		{ui = Objective_AddUIElements(OBJ_VILLAGE, eg_clear03, true, "$08a0ac9c7e6144909909a02d533ce8aa:18", true, 1.7, nil, nil, nil), eg = eg_clear03, sg=sg_village_defence03},
		{ui = Objective_AddUIElements(OBJ_VILLAGE, eg_clear04, true, "$08a0ac9c7e6144909909a02d533ce8aa:18", true, 1.7, nil, nil, nil), eg = eg_clear04, sg=sg_village_defence04},
		{ui = Objective_AddUIElements(OBJ_VILLAGE, eg_clear05, true, "$08a0ac9c7e6144909909a02d533ce8aa:18", true, 1.7, nil, nil, nil), eg = eg_clear05, sg=sg_village_defence05},
		{ui = Objective_AddUIElements(OBJ_VILLAGE, eg_clear06, true, "$08a0ac9c7e6144909909a02d533ce8aa:18", true, 1.7, nil, nil, nil), eg = eg_clear06, sg=sg_village_defence06},
		{ui = Objective_AddUIElements(OBJ_VILLAGE, eg_clear07, true, "$08a0ac9c7e6144909909a02d533ce8aa:18", true, 1.7, nil, nil, nil), eg = eg_clear07, sg=sg_village_defence07},
		{ui = Objective_AddUIElements(OBJ_VILLAGE, eg_church, true, "$08a0ac9c7e6144909909a02d533ce8aa:18", true, 1.7, nil, nil, nil), eg = eg_church, sg=sg_village_defence08},
	};
	
	for i=1, 8 do
		
		local building = OBJ_VILLAGE.buildings[i].eg;
		local amount = World_GetRand(1, 2);
		
		Util_CreateSquads(player3, OBJ_VILLAGE.buildings[i].sg, BP_GetSquadBlueprint(t_villagedefence[World_GetRand(1, #t_villagedefence)]), building, nil, amount, nil, false, nil, nil, nil);
		SGroup_IncreaseVeterancyRank(OBJ_VILLAGE.buildings[i].sg, World_GetRand(0, t_difficulty.defend1_vetmax), true);
		
		Event_GroupIsDead(obj3_updatevillageUI, nil, OBJ_VILLAGE.buildings[i].sg, 5, false);
		
	end
	
	Cmd_Upgrade(sg_diggin01, BP_GetUpgradeBlueprint("instant_german_hulldown"), 1, true);
	Cmd_Upgrade(sg_diggin02, BP_GetUpgradeBlueprint("instant_german_hulldown"), 1, true);
	Cmd_Upgrade(sg_diggin03, BP_GetUpgradeBlueprint("instant_german_hulldown"), 1, true);
	
end

function obj3_moveconvoy()

	Modify_ReceivedDamage(sg_convoy, t_difficulty.convoy_damage, false);
	Modify_WeaponDamage(sg_convoy, "hardpoint_01", t_difficulty.convoy_givendamage);
	
	Modify_UnitSpeed(sg_convoy, 0.55);
	Cmd_AttackMove(sg_convoy, mkr_convoy_last_stop_before_bridge);

	Util_StartIntel(EVENTS.COMPANYSUPPORT);
	
	Event_GroupIsDead(obj3_onconvoyvehicledown, nil, sg_convoy_vehicle1, 5, false);
	Event_GroupIsDead(obj3_onconvoyvehicledown, nil, sg_convoy_vehicle2, 5, false);
	Event_GroupIsDead(obj3_onconvoyvehicledown, nil, sg_convoy_vehicle3, 5, false);
	Event_GroupIsDead(obj3_onconvoyvehicledown, nil, sg_convoy_vehicle4, 5, false);
	Event_GroupIsDead(obj3_onconvoyvehicledown, nil, sg_convoy_vehicle5, 5, false);
	Event_GroupIsDead(obj3_onconvoyvehicledown, nil, sg_convoy_vehicle6, 5, false);
	Event_GroupIsDead(obj3_onconvoyvehicledown, nil, sg_convoy_vehicle7, 5, false);
	Event_GroupIsDead(obj3_onconvoyvehicledown, nil, sg_convoy_vehicle8, 5, false);
	
	Event_Proximity(obj3_stug1, nil, sg_convoy, mkr_stug_seen, 7, ANY, 1);
	Event_Proximity(obj3_stug2, nil, sg_convoy, mkr_stug2_seen, 7, ANY, 1);

	Rule_AddInterval(obj3_ai_north, 1);
	Rule_AddInterval(obj3_ai_center, 2);
	Rule_AddInterval(obj3_ai_south, 3);
	
	Rule_AddInterval(obj3_ai_counterattack, 7);
	
end

function obj3_stug1()

	Cmd_Stop(sg_convoy);
	Util_StartIntel(EVENTS.STUG_ENCOUNTER01);
	Rule_Add(obj3_beginmoving01);

end

function obj3_stug2()
	
	Cmd_Stop(sg_convoy);
	Util_StartIntel(EVENTS.STUG_ENCOUNTER02);
	Rule_Add(obj3_beginmoving02);
	
end

function obj3_beginmoving01()
	if (SGroup_Count(sg_diggin01) == 0) then
		Cmd_AttackMove(sg_convoy, mkr_convoy_last_stop_before_bridge);
		Rule_RemoveMe();
	end
end

function obj3_beginmoving02()
	if (SGroup_Count(sg_diggin03) == 0) then
		Cmd_AttackMove(sg_convoy, mkr_convoy_last_stop_before_bridge);
		Rule_RemoveMe();
	end
end

function obj3_stopAIhelp()
	Rule_Remove(obj3_ai_north);
	Rule_Remove(obj3_ai_center);
	Rule_Remove(obj3_ai_south);
end

function obj3_ai_north()

	if (SGroup_Count(sg_aihelp01) <= t_difficulty.maxAIhelp) then
		
		local sg_temp = SGroup_CreateIfNotFound("sg_temp_ai1");
		Util_CreateSquads(player2, sg_temp, BP_GetSquadBlueprint("riflemen_squad_mp"), mkr_player_reinforcements, nil, 1, nil, false, nil, nil, nil);
		SGroup_EnableUIDecorator(sg_temp, false);
		SGroup_EnableMinimapIndicator(sg_temp, false);
		SGroup_SetSelectable(sg_temp, false); 
		Modify_ReceivedDamage(sg_temp, 2.0, false); 
		Cmd_SquadPath(sg_temp, "village_assault_north", true, LOOP_NONE, true, 0, nil, false, true); 
		SGroup_AddGroup(sg_aihelp01, sg_temp);
		
	end

end

function obj3_ai_center()

	if (SGroup_Count(sg_aihelp02) <= t_difficulty.maxAIhelp) then
		
		local sg_temp = SGroup_CreateIfNotFound("sg_temp_ai2");
		Util_CreateSquads(player2, sg_temp, BP_GetSquadBlueprint("riflemen_squad_mp"), mkr_player_reinforcements, nil, 1, nil, false, nil, nil, nil);
		SGroup_EnableUIDecorator(sg_temp, false);
		SGroup_EnableMinimapIndicator(sg_temp, false);
		SGroup_SetSelectable(sg_temp, false);
		Modify_ReceivedDamage(sg_temp, 2.0, false); 
		Cmd_SquadPath(sg_temp, "village_assault_center", true, LOOP_NONE, true, 0, nil, false, true); 
		SGroup_AddGroup(sg_aihelp02, sg_temp);
		
	end

end

function obj3_ai_south()

	if (SGroup_Count(sg_aihelp03) <= t_difficulty.maxAIhelp) then
		
		local sg_temp = SGroup_CreateIfNotFound("sg_temp_ai3");
		Util_CreateSquads(player2, sg_temp, BP_GetSquadBlueprint("riflemen_squad_mp"), mkr_player_reinforcements, nil, 1, nil, false, nil, nil, nil);
		SGroup_EnableUIDecorator(sg_temp, false);
		SGroup_EnableMinimapIndicator(sg_temp, false);
		SGroup_SetSelectable(sg_temp, false);
		Modify_ReceivedDamage(sg_temp, 2.0, false); 
		Cmd_SquadPath(sg_temp, "village_assault_south", true, LOOP_NONE, true, 0, nil, false, true); 
		SGroup_AddGroup(sg_aihelp03, sg_temp);
		
	end

end

function obj3_updatehealth()
	Obj_ShowProgress("$08a0ac9c7e6144909909a02d533ce8aa:24", SGroup_GetAvgHealth(sg_convoy));
end

function obj3_convoyalive()
	if (SGroup_Count(sg_convoy) == 0) then
		Objective_Fail(OBJ_ESCORT, true);
		Objective_Fail(OBJ_BANKCONTROL, true);
	end
end

function obj3_onconvoyvehicledown()
	Util_StartIntel(EVENTS.CONVOY_DOWN);
end

function obj3_lose()
	SGroup_Kill(sg_convoy);
	Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:38", 5.0, 5.0, 5.0); 
	Game_EndSP(false);
	Rule_RemoveAll();
end

function obj3_convoyativatepanther()
	if (Prox_AreSquadMembersNearMarker(sg_convoy, mkr_panther_village, ANY, 15) == true) then
		Util_CreateSquads(player3, SGroup_CreateIfNotFound("sg_temp_panther"), BP_GetSquadBlueprint("panther_squad_mp"), mkr_panther2_spawner, mkr_panther_village_destination, 1, nil, false, nil, nil, nil);
		obj3_player_reinforcements();
		Rule_RemoveMe();
	end
end

function obj3_player_reinforcements() -- these are free for the player!
	Util_CreateSquads(player1, SGroup_CreateIfNotFound("sg_temp_player_reinforcement"), BP_GetSquadBlueprint("riflemen_squad_veteran_mp"), mkr_player_village_assault_spawn, mkr_player_village_assault, 3, nil, false, nil, nil, nil);
	Player_AddResource(player1, RT_Manpower, t_difficulty.resourcebonus + 50);
	Player_AddResource(player1, RT_Munition, t_difficulty.resourcebonus + 125);
end

function obj3_hasreachedlastpoint()

	if (Prox_AreSquadMembersNearMarker(sg_convoy, mkr_convoy_last_stop_before_bridge, ANY, 5) == true) then
		
		Cmd_Stop(sg_convoy);
		
		Objective_Complete(OBJ_ESCORT, true);
		
		if (Rule_Exists(obj3_hasallobjectives) == false) then
			Rule_AddInterval(obj3_hasallobjectives, 5);
		end
		
		Obj_HideProgress();
		
		Rule_RemoveMe();
		
	end
	
end

function obj3_updatevillageUI()

	for i=1, 8 do
		if (SGroup_Count(OBJ_VILLAGE.buildings[i].sg) == 0) then
			Objective_RemoveUIElements(OBJ_VILLAGE, OBJ_VILLAGE.buildings[i]); 
		end
	end

end

function obj3_ai_counterattack()
	
	if (SGroup_Count(sg_aicounterattack) <= t_difficulty.maxvillagecounters) then
		
		local t_markers = 
		{
			mkr_village_counterattack01, mkr_village_counterattack02, mkr_village_counterattack03, mkr_village_counterattack04, mkr_village_counterattack05, mkr_village_counterattack06,
			mkr_village_counterattack07, mkr_village_counterattack08, mkr_village_counterattack09, mkr_village_counterattack10, mkr_village_counterattack11, mkr_village_counterattack12,
			mkr_village_counterattack13, mkr_village_counterattack14, mkr_village_counterattack15, mkr_village_counterattack16, mkr_village_counterattack17, mkr_village_counterattack18
		};
		
		local sg_temp = SGroup_CreateIfNotFound("sg_temp");
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_attack01[World_GetRand(1, #t_attack01)]), mkr_panther2_spawner, t_markers[World_GetRand(1, #t_markers)], 1, nil, false, nil, nil, nil);
		
		SGroup_AddGroup(sg_aicounterattack, sg_temp);
		
	end
	
end

function obj3_hasclearedvillage()

	local dead = 0;
	
	for i=1, 8 do
		if (SGroup_Count(OBJ_VILLAGE.buildings[i].sg) == 0 or EGroup_Count(OBJ_VILLAGE.buildings[i].eg) == 0) then
			Objective_RemoveUIElements(OBJ_VILLAGE, OBJ_VILLAGE.buildings[i].ui);
			dead = dead+1;
		end
	end
	
	if (dead==8) then
		
		Objective_Complete(OBJ_VILLAGE, true);
		Rule_Remove(obj3_ai_counterattack);
		Rule_RemoveMe();
		if (Rule_Exists(obj3_hasallobjectives) == false) then
			Rule_AddInterval(obj3_hasallobjectives, 5);
		end
		
	end
	
end

function obj3_hasallobjectives()
	if (Objective_IsComplete(OBJ_ESCORT) == true and Objective_IsComplete(OBJ_VILLAGE) == true) then
	
		obj3_stopAIhelp();
	
		Util_StartIntel(EVENTS.BRIDGECROSS);
	
		Objective_Complete(OBJ_BANKCONTROL, true);
	
		World_IncreaseInteractionStage();
	
		Rule_RemoveMe();
	
	end
end

function obj4_begin()

	Objective_Start(OBJ_BREAKTHROUGH, true);
	Objective_Start(OBJ_CAPTURE_WEST_VILLAGE, true);
	
	obj4_fortify();
	
	Rule_AddInterval(obj4_checkstrong, 5);
	
end

function obj4_fortify() -- I feel like this is becoming a must for every objective

	SGroup_Hide(sg_hidden_obj4, false);

	local squad = SGroup_CreateIfNotFound("_sg_temp");
	
	Util_CreateSquads(player4, squad, BP_GetSquadBlueprint(t_villagedefence[World_GetRand(1, #t_villagedefence)]), eg_before_bridge_house01, nil, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player4, squad, BP_GetSquadBlueprint(t_villagedefence[World_GetRand(1, #t_villagedefence)]), eg_before_bridge_house02, nil, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player4, squad, BP_GetSquadBlueprint(t_villagedefence[World_GetRand(1, #t_villagedefence)]), eg_before_bridge_house03, nil, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player4, squad, BP_GetSquadBlueprint(t_villagedefence[World_GetRand(1, #t_villagedefence)]), eg_before_bridge_house04, nil, 1, nil, false, nil, nil, nil);
	
end

function obj4_checkstrong()

	if (EGroup_IsCapturedByPlayer(eg_enemy_hotspot_cap, player1, ALL)) then
		
		Objective_Complete(OBJ_CAPTURE_WEST_VILLAGE, true);
		Objective_Start(OBJ_CROSS, true);
		
		obj4_retreatremaining();
		
		Rule_AddInterval(obj4_hascrossed, 5);
		Rule_RemoveMe();
		
	end

end

function obj4_retreatremaining()

	Cmd_EjectOccupants(eg_before_bridge_house01, nil, true); 
	Cmd_EjectOccupants(eg_before_bridge_house02, nil, true); 
	Cmd_EjectOccupants(eg_before_bridge_house03, nil, true); 
	Cmd_EjectOccupants(eg_before_bridge_house04, nil, true); 
	
	local sg_temp = Player_GetSquads(player4);
	
	SGroup_SetPlayerOwner(sg_temp, player3);
	SGroup_AddGroup(sg_stronghold_free, sg_temp);
	
	if (SGroup_Count(sg_stronghold_free) > 0) then
		Cmd_Retreat(sg_stronghold_free, mkr_tiger_retreat, nil, false, false, true); 
	end
	
end

function obj4_hascrossed()

	if (Prox_AreSquadMembersNearMarker(sg_player_squads, mkr_tiger_trigger_ui, ANY, 20) == true) then
		
		Util_CreateSquads(player3, sg_tiger_tank, BP_GetSquadBlueprint("tiger_squad_mp"), mkr_tiger_spawner, mkr_tiger_moveto_and_defend, 1, nil, false, nil, nil, nil);
		obj4_tigersupport();
		Event_PlayerCanSeeElement(obj4_playercanseetiger, nil, player1, sg_tiger_tank, ANY, 5);
		Rule_RemoveMe();
		
	end

end

function obj4_tigersupport()
	Util_CreateSquads(player3, SGroup_CreateIfNotFound("_SG_TEMP_"), BP_GetSquadBlueprint("grenadier_squad_mp"), mkr_tiger_spawner, mkr_mustfail01, 2, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, SGroup_CreateIfNotFound("_SG_TEMP_"), BP_GetSquadBlueprint("grenadier_squad_mp"), mkr_tiger_spawner, mkr_mustfail02, 2, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, SGroup_CreateIfNotFound("_SG_TEMP_"), BP_GetSquadBlueprint("grenadier_squad_mp"), mkr_tiger_spawner, mkr_mustfail03, 2, nil, false, nil, nil, nil);
end

function obj4_playercanseetiger()

	obj4_retreatplayer();

	Objective_Fail(OBJ_CROSS, true);
	Objective_Start(OBJ_DESTROY_TIGER, true);
	
	if (SGroup_Count(sg_stronghold_free) > 0) then
		Cmd_Move(sg_stronghold_free, mkr_mustfail01);
	end
	
	Event_OnHealth(obj4_ontigerdead, nil, sg_tiger_tank, 0.35, false, 2); 
	
	Camera_MoveTo(mkr_camera_destination04, true, SLOW_CAMERA_PANNING, false, true);
	
end

function obj4_retreatplayer()
	local sg_retreatgroup = SGroup_CreateIfNotFound("sg_retreatgroup");
	World_GetSquadsNearMarker(player1, sg_retreatgroup, mkr_tiger_trigger_ui, OT_Player);
	Cmd_Retreat(sg_retreatgroup, mkr_retreat_from_tiger, nil, false, false, false); 
end

function obj4_ontigerdead()

	SGroup_Kill(sg_tiger_tank);

	Objective_Complete(OBJ_DESTROY_TIGER, true);
	
	Camera_MoveTo(mkr_camera_destination05, true, SLOW_CAMERA_PANNING, false, true);
	EGroup_Kill(eg_wood_bridge);
	_PlayerObjective_Warp2();
	Cmd_Move(sg_player_squads, mkr_player_goto_after_warp);
	
	Util_StartIntel(EVENTS.NEWBRIDGE);
	
	FOW_RevealArea(Marker_GetPosition(mkr_camera_destination05), 15, 10);
	
	obj4_addreinforcements();
	
	Rule_AddOneShot(obj4_beginnortherndefence, 15);
	
end

function obj4_addreinforcements()

	t_availablereinforcements.riflemen = t_availablereinforcements.riflemen + t_difficulty.maxinfantryadd;
	--t_availablereinforcements.sherman = t_availablereinforcements.sherman + t_difficulty.maxvehicleadd;
	Production_Update();

end

function obj4_beginnortherndefence()

	Objective_Start(OBJ_BRIDGEBUILDING, true);
	
	Rule_AddDelayedInterval(obj4_playerhasfailed, 25, 4);
	Rule_AddDelayedInterval(obj4_assaultwaves, 10, 5);
	Rule_AddOneShot(obj4_spawndelayedengineers, 20);
	
end

function obj4_spawndelayedengineers()

	Util_CreateSquads(player1, sg_engineers, BP_GetSquadBlueprint("assault_engineer_squad_mp"), mkr_allied_engineers_spawner, mkr_halftrack_detour01, 1, nil, false, nil, nil, nil);
	
	OBJ_BRIDGEBUILDING.UI = {};
	OBJ_BRIDGEBUILDING.UI.Engineers_Hintpoint = HintPoint_Add(sg_engineers, true, "$08a0ac9c7e6144909909a02d533ce8aa:33", 1.7, HPAT_Objective, nil); 
	
	Rule_Add(obj4_bridgerepaired);
	
end

function obj4_straferun()

	Player_AddAbility(player3, BP_GetAbilityBlueprint("stuka_bombing_strike"));
	Cmd_Ability(player3, BP_GetAbilityBlueprint("stuka_bombing_strike"), mkr_halfway_fixed_engineers, mkr_halfway_fixed_engineers, true, false);
	SGroup_SetInvulnerable(sg_engineers, true, nil);
	Cmd_Repair(sg_engineers, eg_wrecked_stone_bridge, "aef_repair_ability_rear_echelon_mp");
	Util_StartIntel(EVENTS.ENGINEERS_PLANE);
	
end

local t_randomtask = 
{
	{command="capture",target="eg_side2_river"},
	{command="move",target="mkr_panther_destination"},
	{command="move",target="mkr_player_goto_after_warp"},
	{command="move",target="mkr_halftrack_detour01"},
};

function obj4_assaultwaves()
	
	if (SGroup_Count(sg_northvillageattackers) ~= t_difficulty.northdefence_maxunits) then
		
		local sg_temp = SGroup_CreateIfNotFound("sg_temp_village_north");
		
		local t_upgrades = 
		{
			{blueprint="any", upgrade="pioneer_flamethrower_mp"},
			{blueprint="any", upgrade="panzer_grenadier_panzershreck_atw_item_mp"},
			{blueprint="any", upgrade="grenadier_mg42_lmg_mp"},
			{blueprint="any", upgrade="stormtrooper_assault_package_mp"},
		};
		local t_upgrades_v = 
		{  
			{blueprint="scoutcar_sdkfz222_mp", upgrade="sdkfz_222_20mm_gun_mp"},
			{blueprint="stug_iii_squad_mp", upgrade="stug_top_gunner_mp"},
			{blueprint="panzer_iv_stubby_squad_mp", upgrade="panzer_top_gunner_mp"},
		};
		
		local t_markers = { mkr_end_enemy_spawner1, mkr_end_enemy_spawner2, mkr_end_enemy_spawner3 };
		local randomcommand = t_randomtask[World_GetRand(1, #t_randomtask)];
		local IsVehicle = World_GetRand(1, 10);
		
		if (t_difficulty.northdefence_vehicles == true) then
		
			if (IsVehicle >= 8) then
				
				local bp = BP_GetSquadBlueprint(t_villagedefence_north_vehicles[World_GetRand(1, #t_villagedefence_north_vehicles)]);
				Util_CreateSquads(player3, sg_temp, bp, t_markers[World_GetRand(1, #t_markers)], nil, 1, nil, false, nil, nil, nil);
				
				if (t_difficulty.northdefence_allowupgrades) then
					--Cmd_InstantUpgrade(sg_temp, BP_GetUpgradeBlueprint(Util_GetUpgradeFromTable(bp, t_upgrades_v)), 1);
				end
				
				if (t_difficulty.northdefence_maxvet ~= 0) then
					SGroup_IncreaseVeterancyRank(sg_temp, World_GetRand(0, t_difficulty.northdefence_maxvet), true); 
				end
				
				randomcommand = t_randomtask[World_GetRand(2, #t_randomtask)];
				
				Cmd_Move(sg_temp, Marker_FromName(randomcommand.target, ""));
				
			else
				
				local bp = BP_GetSquadBlueprint(t_villagedefence_north[World_GetRand(1, #t_villagedefence_north)]);
				Util_CreateSquads(player3, sg_temp, bp, t_markers[World_GetRand(1, #t_markers)], nil, 1, nil, false, nil, nil, nil);
				
				if (t_difficulty.northdefence_allowupgrades) then
					--Cmd_InstantUpgrade(sg_temp, BP_GetUpgradeBlueprint(Util_GetUpgradeFromTable(bp, t_upgrades)), 1);
				end
				
				if (t_difficulty.northdefence_maxvet ~= 0) then
					SGroup_IncreaseVeterancyRank(sg_temp, World_GetRand(0, t_difficulty.northdefence_maxvet), true); 
				end
				
				if (randomcommand.command == "move") then
					Cmd_Move(sg_temp, Marker_FromName(randomcommand.target, ""));
				else
					Cmd_AttackMoveThenCapture(sg_temp, EGroup_FromName(randomcommand.target), false); 
				end
				
			end
		
		else
			
			local bp = BP_GetSquadBlueprint(t_villagedefence_north[World_GetRand(1, #t_villagedefence_north)]);
			Util_CreateSquads(player3, sg_temp, bp, t_markers[World_GetRand(1, #t_markers)], nil, 1, nil, false, nil, nil, nil);
				
			if (t_difficulty.northdefence_allowupgrades) then
				--Cmd_InstantUpgrade(sg_temp, BP_GetUpgradeBlueprint(Util_GetUpgradeFromTable(bp, t_upgrades)), 1);
			end
				
			if (t_difficulty.northdefence_maxvet ~= 0) then
				SGroup_IncreaseVeterancyRank(sg_temp, World_GetRand(0, t_difficulty.northdefence_maxvet), true); 
			end
			
			if (randomcommand.command == "move") then
				Cmd_Move(sg_temp, Marker_FromName(randomcommand.target, ""));
			else
				Cmd_AttackMoveThenCapture(sg_temp, EGroup_FromName(randomcommand.target), false); 
			end
			
		end
		
		SGroup_AddGroup(sg_northvillageattackers, sg_temp);
		
	end

end

function Util_GetUpgradeFromTable(bp, t)
	local t_upgrades = {};
	for i=1, #t do
		if (t[i].blueprint == bp or t[i].blueprint == "any") then
			table.insert(t_upgrades, t[i]);
		end
	end
	if (#t_upgrades == 1) then
		return t_upgrades[1];
	else
		return t_upgrades[World_GetRand(1, #t_upgrades)];
	end
end

local failedamount = 0;

function obj4_playerhasfailed()

	if (SGroup_Count(sg_engineers) == 0) then
		
		if (g_diff == GD_EASY) then
			
			if (failedamount == 2) then
				Objective_Fail(OBJ_BRIDGEBUILDING, true);
			else
				obj4_failedretry();
				failedamount = failedamount + 1;
			end
			
		elseif (g_diff == GD_NORMAL) then
			
			if (failedamount == 1) then
				Objective_Fail(OBJ_BRIDGEBUILDING, true);
			else
				obj4_failedretry();
				failedamount = failedamount + 1;
			end
			
		else
			Objective_Fail(OBJ_BRIDGEBUILDING, true);
		end
		
	end

end

function obj4_failedretry()

	Util_CreateSquads(player1, sg_engineers, BP_GetSquadBlueprint("assault_engineer_squad_mp"), mkr_allied_engineers_spawner, mkr_halftrack_detour01, 1, nil, false, nil, nil, nil);
	Cmd_Repair(sg_engineers, eg_wrecked_stone_bridge, "aef_repair_ability_rear_echelon_mp");
	
end

function obj4_failedcangetthere()
	Cmd_Repair(sg_engineers, eg_wrecked_stone_bridge, "aef_repair_ability_rear_echelon_mp");
end

function obj4_bridgerepaired()

	if (EGroup_Count(eg_wrecked_stone_bridge) == 0 or EGroup_GetAvgHealth(eg_wrecked_stone_bridge) >= 0.85) then -- when bridges have been repaired they're replaced, meaning the bridge will no longer be in the group
		
		HintPoint_Remove(OBJ_BRIDGEBUILDING.UI.Engineers_Hintpoint);
		
		Objective_Complete(OBJ_BRIDGEBUILDING, true);
		Objective_Start(OBJ_ONELASTTIME, true);
		
		obj4_retreatnorth();
		Util_StartIntel(EVENTS.BRIDGE_REPAIRED);
		
		Rule_AddOneShot(obj4_beingnewrouteconvoy, 15);
		Rule_Remove(obj4_playerhasfailed);
		Rule_Remove(obj4_assaultwaves);
		
		World_IncreaseInteractionStage();
		
		Rule_RemoveMe();
		
	end

end

function obj4_retreatnorth()
	Cmd_Retreat(sg_northvillageattackers, mkr_tiger_retreat, nil, false, false, true);
end

function obj4_failed()

	Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:38", 5.0, 5.0, 5.0); 
	Game_EndSP(false);
	
	Rule_RemoveAll();
	
end

function obj4_hasclearedarea()

	if (Prox_ArePlayersNearMarker(player3, mkr_checkclearofenemy, ANY, 50, nil, nil) == false) then
		
		Objective_Complete(OBJ_ONELASTTIME, true);
		Objective_Complete(OBJ_BREAKTHROUGH, true);
		
		Util_StartIntel(EVENTS.CONVOY_SAFE);
		Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:37", 5.0, 5.0, 5.0); 
		
		Rule_RemoveMe();
		
	end

end

function obj4_garrisonlast()

	local t_buildings = {eg_northwest_village01, eg_northwest_village02, eg_northwest_village03, eg_northwest_village04, eg_northwest_village05, eg_northwest_village06, eg_northwest_village07, eg_northwest_village08};

	for i=1, #t_buildings do
		
		local building = t_buildings[i];
		Util_CreateSquads(player3, SGroup_CreateIfNotFound("sg_newtemp"), BP_GetSquadBlueprint(t_villagedefence[World_GetRand(1, #t_villagedefence)]), building, nil, World_GetRand(1, 2), nil, false, nil, nil, nil);
		
	end
	
	obj4_spreadnorthattackers();

end

function obj4_spreadnorthattackers()

	local t_markers = {mkr_spreadto01, mkr_spreadto02, mkr_spreadto03, mkr_spreadto04, mkr_spreadto05, mkr_spreadto06, mkr_spreadto07};

	local newsquadcommand = function(sgroupid, itemindex, squadID)
		local sg_temp = SGroup_CreateIfNotFound("sg_temp");
		SGroup_Add(sg_temp, squadID);
		Cmd_Move(sg_temp, t_markers[World_GetRand(1, #t_markers)]);
	end
	
	SGroup_ForEach(sg_northvillageattackers, newsquadcommand); 
	
end

function obj4_beingnewrouteconvoy()
	Cmd_SquadPath(sg_convoy, "convoy_reroute", true, LOOP_NONE, true, 0, nil);
end

function Mission_Complete()
	Game_EndSP(true);
	Rule_RemoveAll();
end

function Cheat_SkipToobj3_02()

	
	EGroup_SetAvgHealth(eg_shermans, 1.0);
	
	Objective_Start(OBJ_TIGERHUNT, false);
	Objective_Complete(OBJ_TIGERHUNT, false);
	Objective_Complete(OBJ_DEFENDPATROL, false);
	Objective_Start(OBJ_RIVER1, false);
	Objective_Start(OBJ_RIVER2, false);
	SGroup_SetAvgHealth(sg_tiger_hiding, 0.5);
	Game_EnableInput(true); 
	
	Rule_AddOneShot();
	
end

local g_fowenabled = false

function Cheat_FortifyVillage()
	obj3_fortifymainvillage();
	FOW_Enable(g_fowenabled);
end

function Cheat_DisableFOW()
	FOW_Enable(g_fowenabled);
	SGroup_SetInvulnerable(sg_player_squads, true, nil);
	if (g_fowenabled == true) then
		g_fowenabled = false
	else
		g_fowenabled = true
	end
end
