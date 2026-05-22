import("ScarUtil.scar");

function OnGameSetup()
	player1 = World_GetPlayerAt(1);
	player2 = World_GetPlayerAt(2);
	player3 = World_GetPlayerAt(3);
	Setup_SetPlayerName(player2, "$08a0ac9c7e6144909909a02d533ce8aa:88");
	Setup_SetPlayerName(player3, "$08a0ac9c7e6144909909a02d533ce8aa:4");
end

function OnGameRestore()
	player1 = World_GetPlayerAt(1);
	player2 = World_GetPlayerAt(2);
	player3 = World_GetPlayerAt(3);
	Game_DefaultGameRestore();
end

function Mission_Init()

	t_fuelmonitor = {};
	t_production = {};
	t_production["conscript"] = {};
	t_production["conscript"].unit = "conscript";
	t_production["conscript"].name = "dialog.basic_infantry";
	t_production["t34/76"] = {};
	t_production["t34/76"].unit = "t34/76";
	t_production["t34/76"].name = "dialog.basic_vehicle";
	t_production["t34/85"] = {};
	t_production["t34/85"].unit = "t34/85";
	t_production["t34/85"].name = "dialog.medium_vehicle";
	t_production["kv1"] = {};
	t_production["kv1"].unit = "kv1";
	t_production["kv1"].name = "dialog.heavy_vehicle";

	patrol_spawn_markers = {mkr_german_bonus_spawner01, mkr_german_bonus_spawner02, mkr_german_tank_spawner};
	
	t_vehicles = {"ostwind_squad_mp", "panther_squad_mp", "panzer_iv_squad_mp", "panzer_iv_stubby_squad_mp", "scoutcar_sdkfz222_mp", "stug_iii_e_squad_mp"};
	t_infantry = {"panzer_grenadier_squad_mp", "stormtrooper_squad_mp", "grenadier_squad_mp"};
	t_upgrades = 
	{
		
		{blueprint="scoutcar_sdkfz222_mp", upgrade="sdkfz_222_20mm_gun_mp"},
		{blueprint="stug_iii_squad_mp", upgrade="stug_top_gunner_mp"},
		{blueprint="panzer_iv_stubby_squad_mp", upgrade="panzer_top_gunner_mp"},
		{blueprint="panzer_iv_stubby_squad_mp", upgrade="panzer_top_gunner_mp"},
		{blueprint="panzer_grenadier_squad_mp", upgrade="panzer_grenadier_panzershreck_atw_item_mp"},
		{blueprint="stormtrooper_squad_mp", upgrade="panzer_grenadier_panzershreck_atw_item_mp"},
		{blueprint="grenadier_squad_mp", upgrade="panzer_grenadier_panzershreck_atw_item_mp"},
		{blueprint="grenadier_squad_mp", upgrade="grenadier_mg42_lmg_mp"},
		
	};
	
	t_convoy_infantry_soviet =
	{
		"combat_engineer_squad_mp", "conscript_squad_mp", "guards_troops_assault_mp", "penal_battalion_mp"
	};
	
	t_convoy_infantry_axis =
	{
		"grenadier_squad_mp", "ostruppen_squad_mp", "panzer_grenadier_squad_mp", "pioneer_squad_mp", "stormtrooper_squad_mp"
	};
	
	t_convoy_soviet =
	{
		{blueprint = "m3a1_scout_car_squad_mp", hold = false, fuelvalue = 15},
		--{blueprint = "m5_halftrack_squad_mp", hold = false, fuelvalue = 15},
		{blueprint = "zis_6_transport_truck_mp", hold = false, fuelvalue = 15},
		{blueprint = "t-70m_mp", hold = false, fuelvalue = 5},
		--{blueprint = "su-76m_mp", hold = false, fuelvalue = 5},
	};
	
	t_convoy_axis =
	{
		{blueprint = "mechanized_250_halftrack_mp", hold = true, fuelvalue = 10},
		{blueprint = "opel_blitz_supply_squad", hold = false, fuelvalue = 10},
		{blueprint = "scoutcar_sdkfz222_mp", hold = false, fuelvalue = 10},
		{blueprint = "stug_iii_squad_mp", hold = false, fuelvalue = 10},
		{blueprint = "panzer_iv_stubby_squad_mp", hold = false, fuelvalue = 10},
		{blueprint = "ostwind_squad_mp", hold = false, fuelvalue = 10},
	};
	
	mkr_pak1 = mkr_pak01;
	
	Mission_Objectives();
	Mission_Difficulty();
	Mission_Restrictions();
	Mission_Reinforcements();
	
	sg_player_squads = SGroup_CreateIfNotFound("sg_player_squads");
	sg_attack_squads = SGroup_CreateIfNotFound("sg_attack_squads");
	sg_radio_cap_squads = SGroup_CreateIfNotFound("sg_radio_cap_squads");
	sg_engineers = SGroup_CreateIfNotFound("sg_engineers");
	sg_patrol = SGroup_CreateIfNotFound("sg_patrol");
	sg_soviet_reinforcements = SGroup_CreateIfNotFound("sg_soviet_reinforcements")
	sg_soviet_convoy = SGroup_CreateIfNotFound("sg_soviet_convoy");
	sg_axis_convoy = SGroup_CreateIfNotFound("sg_axis_convoy");
	
	g_fuelburnamount = 1; -- The amount a tank burns each time it moves
	g_tankfuelhunters = {};
	g_inrangeofrepair = {};
	g_panzerfaustwatch = {}; -- TODO: Add panzerfausts on medium and hard (50% chance on medium and 100% chance on hard)
	g_conscriptsupport = {};
	
	Game_EnableInput(false);
	AI_EnableAll(false);
	
	EGroup_SetInvulnerable(eg_invincible_sandbags, true);
	
	Player_ApplyMod(player1);
	Player_ApplyMod(player3);
	
	Rule_AddOneShot(m_playerreinforce, 2);
	Rule_AddOneShot(Mission_DelayIntel, 1);
	
end

Scar_AddInit(Mission_Init);

function Mission_DelayIntel()
	Util_StartIntel(EVENTS.INTRO);
end

function Mission_Restrictions()

	-- upgrade player and all that in here

end

function Mission_Objectives()

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

	OBJ_FUEL = {
		Parent = OBJ_SQUADS,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
			Rule_AdDOneShot(m_lose, 5);
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:89",
		Description = 0,
		Type = OT_Secondary,
	}
	
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

	OBJ_PAKS = {
		Parent = OBJ_MAIN,
		SetupUI = function()
			Objective_AddUIElements(OBJ_PAKS, mkr_pak1, true, "$08a0ac9c7e6144909909a02d533ce8aa:352", true, 1.7, nil, nil, nil);
			Objective_AddUIElements(OBJ_PAKS, mkr_pak2, true, "$08a0ac9c7e6144909909a02d533ce8aa:352", true, 1.7, nil, nil, nil);
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:351",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_RADIO = {
		Parent = OBJ_MAIN,
		SetupUI = function()
			Objective_AddUIElements(OBJ_RADIO, eg_radio, true, "$08a0ac9c7e6144909909a02d533ce8aa:94", true, 1.7, nil, nil, nil);
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:92",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_REPAIRBAY = {
		Parent = OBJ_MAIN,
		SetupUI = function()
			Objective_AddUIElements(OBJ_REPAIRBAY, eg_repair_bay, true, "$08a0ac9c7e6144909909a02d533ce8aa:105", true, 1.7, nil, nil, nil);
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:105",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_RERADIO = {
		Parent = OBJ_MAIN,
		SetupUI = function()
			Objective_AddUIElements(OBJ_RERADIO, eg_radio, true, "$08a0ac9c7e6144909909a02d533ce8aa:112", true, 1.7, nil, nil, nil);
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:111",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_AXIS_CONOY = {
		Parent = OBJ_MAIN,
		SetupUI = function()
			Objective_AddUIElements(OBJ_AXIS_CONOY, mkr_convoy_crossroad, true, "$08a0ac9c7e6144909909a02d533ce8aa:153", true, 1.7, nil, nil, nil);
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:121",
		Description = 0,
		Type = OT_Secondary,
	}
	
	OBJ_TANKHUNT = {
		Parent = OBJ_MAIN,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = "$08a0ac9c7e6144909909a02d533ce8aa:122",
		Description = 0,
		Type = OT_Secondary,
	}
	
	Objective_Register(OBJ_SQUADS);
	Objective_Register(OBJ_PLAYERSQUADS);
	Objective_Register(OBJ_FUEL);
	
	Objective_Register(OBJ_MAIN);
	Objective_Register(OBJ_PAKS);
	Objective_Register(OBJ_RADIO);
	Objective_Register(OBJ_REPAIRBAY);
	Objective_Register(OBJ_RERADIO);
	Objective_Register(OBJ_AXIS_CONOY);
	Objective_Register(OBJ_TANKHUNT);
	
end

function Mission_Difficulty()

	g_diff = Game_GetSPDifficulty();
	t_difficulty = {};
	
	if (g_diff == GD_EASY) then
		t_difficulty.fuelamount = 7500.0;
		t_difficulty.maxvet = 1;
		t_difficulty.maxpatroling = 4;
		t_difficulty.allowinfantry = false;
		t_difficulty.allowfueltarget = false;
		
		t_production["conscript"].available = 4; -- Conscript support will be controlled by player2 (AI)
		t_production["t34/76"].available = 10;
		t_production["t34/85"].available = 8;
		t_production["kv1"].available = 3;
		
		t_difficulty.modifier_unitspeed = 1.5;
		t_difficulty.modifier_armour = 1.2;
		t_difficulty.modifier_receiveddamage = 0.55;
		t_difficulty.modifier_capturerate = 1.75;
		t_difficulty.modifier_weaponaccuarcy= 1.5;
		t_difficulty.modifier_weapondamage =  1.5;
		t_difficulty.modifier_weaponscatter = 0.5;
		t_difficulty.modifier_weaponrange =  1.15;
		t_difficulty.modifier_weaponpen = 1.15;
		
		t_difficulty.modifier_unitspeed_E = 0.75;
		t_difficulty.modifier_armour_E = 0.75;
		t_difficulty.modifier_receiveddamage_E = 1.5;
		t_difficulty.modifier_capturerate_E = 1;
		t_difficulty.modifier_weaponaccuarcy_E= 0.5;
		t_difficulty.modifier_weapondamage_E =  0.55;
		t_difficulty.modifier_weaponscatter_E = 1.5;
		t_difficulty.modifier_weaponrange_E =  0.5;
		t_difficulty.modifier_weaponpen_E = 0.5;
		
		t_difficulty.maxcounterforce = 6;
		t_difficulty.max_soviet_convoy = 7;
		t_difficulty.max_axis_convoy = 6;
		t_difficulty.chanceofpanther = 8;
		
		t_difficulty.reinforcementunit01 = BP_GetSquadBlueprint("kv-2_mp");
		t_difficulty.reinforcementunit02 = BP_GetSquadBlueprint("kv-1_mp");
		
	elseif (g_diff == GD_NORMAL) then
		t_difficulty.fuelamount = 5000.0;
		t_difficulty.maxvet = 2;
		t_difficulty.maxpatroling = 5;
		t_difficulty.allowinfantry = true;
		t_difficulty.allowfueltarget = true;
		
		t_production["conscript"].available = 3; -- Conscript support will be controlled by player2 (AI)
		t_production["t34/76"].available = 8;
		t_production["t34/85"].available = 6;
		t_production["kv1"].available = 2;
		
		t_difficulty.modifier_unitspeed = 1.25;
		t_difficulty.modifier_armour = 1.25;
		t_difficulty.modifier_receiveddamage = 0.85;
		t_difficulty.modifier_capturerate = 1.5;
		t_difficulty.modifier_weaponaccuarcy= 1.25;
		t_difficulty.modifier_weapondamage =  1.25;
		t_difficulty.modifier_weaponscatter = 0.75;
		t_difficulty.modifier_weaponrange =  1.05;
		t_difficulty.modifier_weaponpen = 1.1;
		
		t_difficulty.modifier_unitspeed_E = 0.8;
		t_difficulty.modifier_armour_E = 0.9;
		t_difficulty.modifier_receiveddamage_E = 1.20;
		t_difficulty.modifier_capturerate_E = 1;
		t_difficulty.modifier_weaponaccuarcy_E= 0.75;
		t_difficulty.modifier_weapondamage_E =  0.75;
		t_difficulty.modifier_weaponscatter_E = 1.05;
		t_difficulty.modifier_weaponrange_E =  0.75;
		t_difficulty.modifier_weaponpen_E = 0.85;
		
		t_difficulty.maxcounterforce = 10;
		t_difficulty.max_soviet_convoy = 4;
		t_difficulty.max_axis_convoy = 8;
		t_difficulty.chanceofpanther = 7;
		
		t_difficulty.reinforcementunit01 = BP_GetSquadBlueprint("kv-1_mp");
		t_difficulty.reinforcementunit02 = BP_GetSquadBlueprint("t_34_85_squad_mp");
		
	elseif (g_diff == GD_HARD) then
		t_difficulty.fuelamount = 4000.0;
		t_difficulty.maxvet = 3;
		t_difficulty.maxpatroling = 6;
		t_difficulty.allowinfantry = true;
		t_difficulty.allowfueltarget = true;
		
		t_production["conscript"].available = 2; -- Conscript support will be controlled by player2 (AI)
		t_production["t34/76"].available = 6;
		t_production["t34/85"].available = 4;
		t_production["kv1"].available = 1;
		
		t_difficulty.modifier_unitspeed = 1.1;
		t_difficulty.modifier_armour = 1.1;
		t_difficulty.modifier_receiveddamage = 1;
		t_difficulty.modifier_capturerate = 1.25;
		t_difficulty.modifier_weaponaccuarcy= 1.1;
		t_difficulty.modifier_weapondamage =  1.1;
		t_difficulty.modifier_weaponscatter = 0.95;
		t_difficulty.modifier_weaponrange =  1;
		t_difficulty.modifier_weaponpen = 1;
		
		t_difficulty.modifier_unitspeed_E = 1;
		t_difficulty.modifier_armour_E = 1;
		t_difficulty.modifier_receiveddamage_E = 1;
		t_difficulty.modifier_capturerate_E = 1;
		t_difficulty.modifier_weaponaccuarcy_E= 1;
		t_difficulty.modifier_weapondamage_E =  1;
		t_difficulty.modifier_weaponscatter_E = 1;
		t_difficulty.modifier_weaponrange_E =  1;
		t_difficulty.modifier_weaponpen_E = 1;
		
		t_difficulty.maxcounterforce = 12;
		t_difficulty.max_soviet_convoy = 2;
		t_difficulty.max_axis_convoy = 10;
		t_difficulty.chanceofpanther = 6;
		
		t_difficulty.reinforcementunit01 = BP_GetSquadBlueprint("t_34_85_squad_mp");
		t_difficulty.reinforcementunit02 = BP_GetSquadBlueprint("t_34_85_squad_mp");
		
	end

end

function Mission_Reinforcements()

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
                callback = "Production_Buy",
                enabled = true,
                icon = "Icons_units_unit_soviet_guards",
                style = BIS_Icon,
                tag = "infantry_basic",
                text = Util_CreateLocString(""..t_production["conscript"].available)
            },
			{
                controlType = "button",
                name = "basic_vehicle",
                top = 70.0,
                width = 64.0,
                height = 64.0,
                callback = "Production_Buy",
                enabled = true,
                icon = "Icons_vehicles_vehicle_soviet_t34_76_heavy_tank",
                style = BIS_Icon,
				tag = "vehicle_basic",
				text = Util_CreateLocString(""..t_production["t34/76"].available)
            },
			{
                controlType = "button",
                name = "medium_vehicle",
                top = 140.0,
                width = 64.0,
                height = 64.0,
                callback = "Production_Buy",
                enabled = true,
                icon = "Icons_vehicles_vehicle_soviet_t34_85",
                style = BIS_Icon,
				tag = "vehicle_medium",
				text = Util_CreateLocString(""..t_production["t34/85"].available)
            },
			{
                controlType = "button",
                name = "heavy_vehicle",
                top = 210.0,
                width = 64.0,
                height = 64.0,
                callback = "Production_Buy",
                enabled = true,
                icon = "Icons_vehicles_vehicle_soviet_kv1_heavy_tank",
                style = BIS_Icon,
				tag = "vehicle_heavy",
				text = Util_CreateLocString(""..t_production["kv1"].available)
            },
			
		},
	}

	UI_AddControl(dialog);
	
	Production_Enable("conscript", false);
	Production_Enable("t34/76", false);
	Production_Enable("t34/85", false);
	Production_Enable("kv1", false);
	
end

function Production_Buy(tag)
	if (tag == "infantry_basic") then
		local sg_conscript_callin = SGroup_CreateIfNotFound("sg_conscript_callin"..t_production["conscript"].available); --g_conscriptsupport
		Misc_GetSelectedSquads(sg_conscript_callin, false);
		if (SGroup_Count(sg_conscript_callin) > 0) then
			if (Util_GetPlayerOwner(sg_conscript_callin) == Game_GetLocalPlayer()) then
				local squad = SGroup_GetSpawnedSquadAt(sg_conscript_callin, 1); -- We will only attach it to the first vehicle in the group
				local entity = Squad_EntityAt(squad, 0);
				if (Production_ConscriptTaken(squad) == false) then
					if (Entity_IsVehicle(entity)) then
						t_production["conscript"].available = t_production["conscript"].available - 1;
						local sg_conscript = SGroup_CreateIfNotFound("sg_conscript_support" ..t_production["conscript"].available);
						Util_CreateSquads(player2, sg_conscript, BP_GetSquadBlueprint("guards_troops_assault_mp"), mkr_player_unit_spawner, Squad_GetPosition(squad), 3);
						local t_conscript_support_temp = {sg = sg_conscript, target = squad, targetgroup = SGroup_FromSquad(squad)};
						table.insert(g_conscriptsupport, t_conscript_support_temp);
						if (Rule_Exists(m_updateconscript) == false) then
							Rule_AddInterval(m_updateconscript, 3);
						end
						Modify_UnitSpeed(t_conscript_support_temp.targetgroup, 0.5);
					end
				else
					Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:127", 1.0, 2.0, 1.0); 
				end
			else
				Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:128", 1.0, 2.0, 1.0); 
			end
		else
			Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:124", 1.0, 2.0, 1.0); 
		end
	elseif (tag == "vehicle_basic") then
		t_production["t34/76"].available = t_production["t34/76"].available - 1;
		local pos = Marker_GetPosition(mkr_repair_and_fuel);
		local sg_temp = SGroup_CreateIfNotFound("sg_reinforcement_t34/76"..t_production["t34/76"].available);
		Util_CreateSquads(player1, sg_temp, BP_GetSquadBlueprint("t_34_76_squad_mp"), mkr_player_unit_spawner, mkr_repair_and_fuel, 1, nil, false, nil, nil, nil);
		UI_ButtonSetText("dialog.basic_vehicle", Util_CreateLocString(""..t_production["t34/76"].available));
		UI_CreateMinimapBlip(pos, 5, BT_General);
		local t_tank_temp01 = {sg = sg_temp, IsAlive = true, Disabled = false, Fuel = 750, MaxFuel = 750};
		table.insert(t_fuelmonitor, t_tank_temp01);
	elseif (tag == "vehicle_medium") then
		t_production["t34/85"].available = t_production["t34/85"].available - 1;
		local sg_temp = SGroup_CreateIfNotFound("sg_reinforcement_t34/85"..t_production["t34/85"].available);
		local pos = Marker_GetPosition(mkr_repair_and_fuel);
		Util_CreateSquads(player1, sg_player_squads, BP_GetSquadBlueprint("t_34_85_squad_mp"), mkr_player_unit_spawner, mkr_repair_and_fuel, 1, nil, false, nil, nil, nil);
		UI_ButtonSetText("dialog.medium_vehicle", Util_CreateLocString(""..t_production["t34/85"].available));
		UI_CreateMinimapBlip(pos, 5, BT_General); 
		local t_tank_temp01 = {sg = sg_temp, IsAlive = true, Disabled = false, Fuel = 750, MaxFuel = 750};
		table.insert(t_fuelmonitor, t_tank_temp01);
	elseif (tag == "vehicle_heavy") then
		t_production["kv1"].available = t_production["kv1"].available - 1;
		local sg_temp = SGroup_CreateIfNotFound("sg_reinforcement_kv1"..t_production["kv1"].available);
		local pos = Marker_GetPosition(mkr_repair_and_fuel);
		Util_CreateSquads(player1, sg_player_squads, BP_GetSquadBlueprint("kv-1_mp"), mkr_player_unit_spawner, mkr_repair_and_fuel, 1, nil, false, nil, nil, nil);
		UI_ButtonSetText("dialog.heavy_vehicle", Util_CreateLocString(""..t_production["kv1"].available));
		UI_CreateMinimapBlip(pos, 5, BT_General); 
		local t_tank_temp01 = {sg = sg_temp, IsAlive = true, Disabled = false, Fuel = 750, MaxFuel = 750};
		table.insert(t_fuelmonitor, t_tank_temp01);
	end
	Production_Update();
end

function Production_Add(unit, amount)
	t_production[unit].available = t_production[unit].available + amount;
	Production_Update();
end

function Production_Enable(unit, enable)
	if (unit=="conscript") then
		UI_ButtonSetEnabled("dialog.basic_infantry", enable);
		t_production[unit].enabled = enable;
	elseif (unit=="t34/76") then
		UI_ButtonSetEnabled("dialog.basic_vehicle", enable);
		t_production[unit].enabled = enable;
	elseif (unit=="t34/85") then
		UI_ButtonSetEnabled("dialog.medium_vehicle", enable);
		t_production[unit].enabled = enable;
	elseif (unit=="kv1") then
		UI_ButtonSetEnabled("dialog.heavy_vehicle", enable);
		t_production[unit].enabled = enable;
	end
	if (enable == false) then
		UI_ButtonSetText(t_production[unit].name, Util_CreateLocString("0"));
	else
		UI_ButtonSetText(t_production[unit].name, Util_CreateLocString(""..t_production[unit].available));
	end
end

function Production_Update()
	for i=1, #t_production do
		if (t_production.units[i].enabled == true) then
			if (t_production[i].available == 0) then
				Production_Enable(t_production[i].unit, false);
				UI_ButtonSetText(t_production[i].name, Util_CreateLocString("0"));
			else
				Production_Enable(t_production[i].name, true);
			end
		end
	end
end

function Production_ConscriptTaken(squadCheck)
	if (#g_conscriptsupport == 0) then
		return false;
	else
		for i=1, #g_conscriptsupport do
			if (g_conscriptsupport[i].squad == squadCheck) then
				return true
			end
		end
		return false;
	end
end

function m_updateconscript()
	if (#g_conscriptsupport == 0) then
		Rule_RemoveMe();
	else
		local RemoveAt = nil;
		for i=1, #g_conscriptsupport do
			if (SGroup_Count(g_conscriptsupport[i].sg) > 0) then
				if (SGroup_Count(g_conscriptsupport[i].targetgroup) > 0) then
					if (g_conscriptsupport[i].targetpos == nil or g_conscriptsupport[i].targetpos ~= Squad_GetPosition(g_conscriptsupport[i].target)) then
						g_conscriptsupport[i].targetpos = Squad_GetPosition(g_conscriptsupport[i].target);
						Cmd_Move(g_conscriptsupport[i].sg, g_conscriptsupport[i].targetpos);
					end
				else
					Cmd_Retreat(g_conscriptsupport[i].sg, mkr_player_unit_spawner, mkr_player_unit_spawner, false, false, true);
					RemoveAt = i;
				end
			else
				RemoveAt = i;
			end
		end
		if (RemoveAt ~= nil) then
			table.remove(g_conscriptsupport, RemoveAt);
		end
	end
end

function m_playerreinforce()
	g_spawnpoint = mkr_player_unit_spawner;
	local sg_tank01 = SGroup_CreateIfNotFound("sg_tank01");
	local sg_tank02 = SGroup_CreateIfNotFound("sg_tank02");
	local sg_tank03 = SGroup_CreateIfNotFound("sg_tank03");
	local sg_tank04 = SGroup_CreateIfNotFound("sg_tank04");
	local sg_tank05 = SGroup_CreateIfNotFound("sg_tank05");
	local sg_tank06 = SGroup_CreateIfNotFound("sg_tank06");
	Util_CreateSquads(player1, sg_tank01, BP_GetSquadBlueprint("t_34_76_squad_mp"), g_spawnpoint, mkr_player_first_t34_76_1, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player1, sg_tank02, BP_GetSquadBlueprint("t_34_76_squad_mp"), g_spawnpoint, mkr_player_first_t34_76_2, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player1, sg_tank03, BP_GetSquadBlueprint("t_34_85_squad_mp"), g_spawnpoint, mkr_player_first_t34_85, 1, nil, false, nil, nil, nil);
	local t_tank_temp01 = {sg = sg_tank01, IsAlive = true, Disabled = false, Fuel = 750, MaxFuel = 750};
	local t_tank_temp02 = {sg = sg_tank02, IsAlive = true, Disabled = false, Fuel = 750, MaxFuel = 750};
	local t_tank_temp03 = {sg = sg_tank03, IsAlive = true, Disabled = false, Fuel = 750, MaxFuel = 750};
	table.insert(t_fuelmonitor, t_tank_temp01);
	table.insert(t_fuelmonitor, t_tank_temp02);
	table.insert(t_fuelmonitor, t_tank_temp03);
	Player_ApplyMod(player1, sg_tank01);
	Player_ApplyMod(player1, sg_tank02);
	Player_ApplyMod(player1, sg_tank03);
	
	if (g_diff == GD_EASY) then
		Util_CreateSquads(player1, sg_tank04, BP_GetSquadBlueprint("t_34_85_squad_mp"), g_spawnpoint, mkr_ally_goto_tank01, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player1, sg_tank05, BP_GetSquadBlueprint("t_34_85_squad_mp"), g_spawnpoint, mkr_ally_goto_tank02, 1, nil, false, nil, nil, nil);
		--Util_CreateSquads(player1, sg_tank06, BP_GetSquadBlueprint("t_34_85_squad_mp"), g_spawnpoint, mkr_ally_goto_tank03, 1, nil, false, nil, nil, nil);
		local t_tank_temp01 = {sg = sg_tank04, IsAlive = true, Disabled = false, Fuel = 750, MaxFuel = 750};
		local t_tank_temp02 = {sg = sg_tank05, IsAlive = true, Disabled = false, Fuel = 750, MaxFuel = 750};
		--local t_tank_temp03 = {sg = sg_tank06, IsAlive = true, Disabled = false, Fuel = 750, MaxFuel = 750};
		table.insert(t_fuelmonitor, t_tank_temp04);
		table.insert(t_fuelmonitor, t_tank_temp05);
		--table.insert(t_fuelmonitor, t_tank_temp06);
		Player_ApplyMod(player1, sg_tank04);
		Player_ApplyMod(player1, sg_tank05);
		--Player_ApplyMod(player1, sg_tank06);
	elseif (g_diff == GD_NORMAL) then
		Util_CreateSquads(player1, sg_tank04, BP_GetSquadBlueprint("t_34_85_squad_mp"), g_spawnpoint, mkr_ally_goto_tank01, 1, nil, false, nil, nil, nil);
		--Util_CreateSquads(player1, sg_tank05, BP_GetSquadBlueprint("t_34_85_squad_mp"), g_spawnpoint, mkr_ally_goto_tank02, 1, nil, false, nil, nil, nil);
		local t_tank_temp01 = {sg = sg_tank04, IsAlive = true, Disabled = false, Fuel = 750, MaxFuel = 750};
		--local t_tank_temp02 = {sg = sg_tank05, IsAlive = true, Disabled = false, Fuel = 750, MaxFuel = 750};
		table.insert(t_fuelmonitor, t_tank_temp04);
		--table.insert(t_fuelmonitor, t_tank_temp05);
		Player_ApplyMod(player1, sg_tank04);
		--Player_ApplyMod(player1, sg_tank05);
	elseif (g_diff == GD_HARD) then
		--Util_CreateSquads(player1, sg_tank04, BP_GetSquadBlueprint("t_34_85_squad_mp"), g_spawnpoint, mkr_ally_goto_tank01, 1, nil, false, nil, nil, nil);
		--local t_tank_temp01 = {sg = sg_tank04, IsAlive = true, Disabled = false, Fuel = 750, MaxFuel = 750};
		--table.insert(t_fuelmonitor, t_tank_temp04);
		--Player_ApplyMod(player1, sg_tank04);
	end
	
end

function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

function Player_ApplyMod(player, target)

	IsPlayer = false;
	IsSGroup = false;

	if (target ~= nil) then
			
		if (scartype(target) == ST_SGROUP) then
			IsSGroup = true;
		elseif (scartype(target) == ST_EGROUP) then
			IsSGroup = false;
		end

	else
		IsPlayer = true;
	end
	
	if (IsPlayer) then
		
		if (player == Game_GetLocalPlayer()) then -- apply stuff
			Modify_PlayerResourceRate(player, RT_Munition, 0.5, MUT_Multiplication);
			Modify_PlayerResourceRate(player, RT_Fuel, 0, MUT_Multiplication);
			Modify_PlayerResourceRate(player, RT_Manpower, 0, MUT_Multiplication);
		end
		
	else
		
		if (player == Game_GetLocalPlayer()) then -- give bonus
			if (IsSGroup) then
				Modify_UnitSpeed(target, t_difficulty.modifier_unitspeed);
				Modify_Armor(target, t_difficulty.modifier_armour);
				Modify_ReceivedDamage(target, t_difficulty.modifier_receiveddamage);
				Modify_SquadCaptureRate(target, t_difficulty.modifier_capturerate);
				Modify_WeaponAccuracy(target, "hardpoint_01", t_difficulty.modifier_weaponaccuarcy);
				Modify_WeaponDamage(target, "hardpoint_01", t_difficulty.modifier_weapondamage);
				Modify_WeaponScatter(target, "hardpoint_01", t_difficulty.modifier_weaponscatter);
				Modify_WeaponRange(target, "hardpoint_01", t_difficulty.modifier_weaponrange);
				Modify_WeaponPenetration(target, "hardpoint_01", t_difficulty.modifier_weaponpen);
			else
				
			end
		else -- penalise
			if (IsSGroup) then
				Modify_UnitSpeed(target, t_difficulty.modifier_unitspeed_E);
				Modify_Armor(target, t_difficulty.modifier_armour_E);
				Modify_ReceivedDamage(target, t_difficulty.modifier_receiveddamage_E);
				Modify_SquadCaptureRate(target, t_difficulty.modifier_capturerate_E);
				Modify_WeaponAccuracy(target, "hardpoint_01", t_difficulty.modifier_weaponaccuarcy_E);
				Modify_WeaponDamage(target, "hardpoint_01", t_difficulty.modifier_weapondamage_E);
				Modify_WeaponScatter(target, "hardpoint_01", t_difficulty.modifier_weaponscatter_E);
				Modify_WeaponRange(target, "hardpoint_01", t_difficulty.modifier_weaponrange_E);
				Modify_WeaponPenetration(target, "hardpoint_01", t_difficulty.modifier_weaponpen_E);
			else
				
			end
		end

	end
	
end

function m_begin()

	if (Event_IsAnyRunning() == false) then
		
		Objective_Start(OBJ_SQUADS, false);
		Objective_Start(OBJ_FUEL, false);
		Objective_Start(OBJ_PLAYERSQUADS, false);
		
		Objective_Start(OBJ_MAIN, false);
		Objective_Start(OBJ_PAKS, true);
		
		HintPoint_Add(eg_repair_bay, true, "$08a0ac9c7e6144909909a02d533ce8aa:106", 2.5, HPAT_Hint, "Icons_abilities_ability_west_german_salvage_operations"); 
		
		Game_EnableInput(true);
		
		Player_ApplyMod(player3, sg_first_defence_tanks);
		
		sg_pakguns = SGroup_CreateIfNotFound("sg_pakguns");
		sg_infantry_soviet_ally_support_m_begin = SGroup_CreateIfNotFound("sg_infantry_soviet_ally_support_m_begin");
		
		Util_CreateSquads(player3, sg_pakguns, BP_GetSquadBlueprint("pak43_88mm_at_gun_squad_mp"), mkr_pak1, nil, 1, nil, false, mkr_pak1, nil, nil);
		Util_CreateSquads(player3, sg_pakguns, BP_GetSquadBlueprint("pak43_88mm_at_gun_squad_mp"), mkr_pak2, nil, 1, nil, false, mkr_pak2, nil, nil);
		
		Rule_AddInterval(m_fuelUpdate, 0.5);
		Rule_AddInterval(m_updateinfantry_m_new, 5);
		Rule_AddInterval(m_paksDead, 5);
		Rule_AddOneShot(m_delayedally, 15);
		
		UI_SetCPMeterVisibility(false);
		
		Rule_RemoveMe();
		
	end
	
end

function m_updateinfantry_m_new()

	if (SGroup_Count(sg_infantry_soviet_ally_support_m_begin) == 0) then
		
		-- west
		for i=1, 3 do
			local sg_temp = SGroup_CreateIfNotFound("sg_temp");
			Util_CreateSquads(player2, sg_temp, BP_GetSquadBlueprint("conscript_squad_mp"), mkr_urgent_support_spawner, mkr_pak1, 1, nil, true, nil, nil, nil);
			Cmd_AttackMove(sg_temp, eg_radio, true);
			SGroup_AddGroup(sg_infantry_soviet_ally_support_m_begin, sg_temp);
			SGroup_Clear(sg_temp);
		end
		
		-- east
		for i=1, 3 do
			local sg_temp = SGroup_CreateIfNotFound("sg_temp");
			Util_CreateSquads(player2, sg_temp, BP_GetSquadBlueprint("conscript_squad_mp"), mkr_urgent_support_spawner, mkr_pak2, 1, nil, true, nil, nil, nil);
			Cmd_AttackMove(sg_temp, eg_radio, true);
			SGroup_AddGroup(sg_infantry_soviet_ally_support_m_begin, sg_temp);
			SGroup_Clear(sg_temp);
		end
		
		Modify_Vulnerability(sg_infantry_soviet_ally_support_m_begin, 1.22);
		
	end

end

function m_reinforceonpakdeath()

	local sg_new_reinforcements_m_new = SGroup_CreateIfNotFound("sg_new_reinforcements_m_new");

	Util_CreateSquads(player1, sg_new_reinforcements_m_new, t_difficulty.reinforcementunit01, mkr_urgent_support_spawner, mkr_reinforcements_new01, 1, nil, true, nil, nil, nil);
	Util_CreateSquads(player1, sg_new_reinforcements_m_new, t_difficulty.reinforcementunit01, mkr_urgent_support_spawner, mkr_reinforcements_new02, 1, nil, true, nil, nil, nil);

	table.insert(t_fuelmonitor, sg_new_reinforcements_m_new);
	
end

function m_paksDead()

	if (SGroup_Count(sg_pakguns) == 0) then
		
		Objective_Complete(OBJ_PAKS, true);
		Objective_Start(OBJ_RADIO, true);
		
		UI_FlashAbilityButton(BP_GetAbilityBlueprint("tank_vet_point_capture_ability_mp"), true);
		
		m_reinforceonpakdeath();
		
		Rule_AddInterval(m_HasCapturedRadio, 5);
		Rule_RemoveMe();
		
	end

end

function m_populate()

	if (SGroup_Count(sg_patrol) < t_difficulty.maxpatroling) then
		
		local t_paths = { "axis_tank01", "axis_tank02", "axis_tank03", "axis_tank04", "axis_tank05", "axis_tank06" };
		local r_path = t_paths[World_GetRand(1, #t_paths)];
		local sg_temp_p = SGroup_CreateIfNotFound("sg_temp_p");
		local RandMArker = patrol_spawn_markers[World_GetRand(1, #patrol_spawn_markers)];
		local bp = t_vehicles[World_GetRand(1, #t_vehicles)];
		
		Util_CreateSquads(player3, sg_temp_p, BP_GetSquadBlueprint(bp), RandMArker, nil, 1, nil, false, nil, nil, nil);
		Cmd_SquadPath(sg_temp_p, r_path, true, LOOP_NORMAL, true, 0, nil, false, true); 
		SGroup_IncreaseVeterancyRank(sg_temp_p, m_vetproperly(bp), true);
		
		SGroup_Clear(sg_temp_p);
		SGroup_AddGroup(sg_patrol, sg_temp_p);
		
	end

end

function m_vetproperly(blueprint)
	
	local t_panzers = {"panzer_iv_squad_mp", "panzer_iv_stubby_squad_mp"};
	if (blueprint == t_panzers[1] or blueprint == t_panzers[2]) then
		return World_GetRand(0, t_difficulty.maxvet);
	else
		return 0;
	end
	
end

function m_delayedally()

	sg_tank01_ally = SGroup_CreateIfNotFound("sg_tank01_ally");
	sg_tank02_ally = SGroup_CreateIfNotFound("sg_tank02_ally");
	sg_tank03_ally = SGroup_CreateIfNotFound("sg_tank03_ally");
	Util_CreateSquads(player2, sg_tank01_ally, BP_GetSquadBlueprint("t_34_76_squad_mp"), g_spawnpoint, mkr_ally_repair01, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player2, sg_tank02_ally, BP_GetSquadBlueprint("t_34_76_squad_mp"), g_spawnpoint, mkr_ally_repair02, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player2, sg_tank03_ally, BP_GetSquadBlueprint("t_34_76_squad_mp"), g_spawnpoint, mkr_ally_repair03, 1, nil, false, nil, nil, nil);
	SGroup_SetAvgHealth(sg_tank01_ally, 0.25);
	SGroup_SetAvgHealth(sg_tank02_ally, 0.30);
	SGroup_SetAvgHealth(sg_tank03_ally, 0.45);

	--Util_CreateSquads(player2, sg_engineers, BP_GetSquadBlueprint("combat_engineer_squad_mp"), mkr_ally_conscript_spawner, nil, 1, nil, false, nil, nil, nil); -- This is actually handled by the repair bay
	
	--Cmd_Repair(sg_engineers, sg_tank01_ally, "soviet_repair_ability_mp", true);
	--Cmd_Repair(sg_engineers, sg_tank02_ally, "soviet_repair_ability_mp", true);
	--Cmd_Repair(sg_engineers, sg_tank03_ally, "soviet_repair_ability_mp", true);
	
	Event_OnHealth(m_tank01_done_repairs, nil, sg_tank01_ally, 0.98, true, 5);
	Event_OnHealth(m_tank02_done_repairs, nil, sg_tank02_ally, 0.98, true, 5);
	Event_OnHealth(m_tank03_done_repairs, nil, sg_tank03_ally, 0.98, true, 5);
	
end

function m_tank01_done_repairs()
	SGroup_SetPlayerOwner(sg_tank01_ally, player1);
	Util_StartIntel(EVENTS.ONREPAIR);
	UI_CreateMinimapBlip(sg_tank01_ally, 5, BT_General);
	local t_temp = {sg = sg_tank01_ally, IsAlive = true, Disabled = false, Fuel = 600, MaxFuel = 750};
	table.insert(t_fuelmonitor, t_temp);
	Player_ApplyMod(player1, sg_tank01_ally);
	SGroup_Clear(sg_tank01_ally);
end

function m_tank02_done_repairs()
	SGroup_SetPlayerOwner(sg_tank02_ally, player1);
	Util_StartIntel(EVENTS.ONREPAIR);
	UI_CreateMinimapBlip(sg_tank02_ally, 5, BT_General);
	local t_temp = {sg = sg_tank02_ally, IsAlive = true, Disabled = false, Fuel = 600, MaxFuel = 750};
	table.insert(t_fuelmonitor, t_temp);
	Player_ApplyMod(player1, sg_tank01_ally);
	SGroup_Clear(sg_tank02_ally);
end

function m_tank03_done_repairs()
	SGroup_SetPlayerOwner(sg_tank03_ally, player1);
	Util_StartIntel(EVENTS.ONREPAIR);
	UI_CreateMinimapBlip(sg_tank03_ally, 5, BT_General);
	local t_temp = {sg = sg_tank03_ally, IsAlive = true, Disabled = false, Fuel = 600, MaxFuel = 750};
	table.insert(t_fuelmonitor, t_temp);
	Player_ApplyMod(player1, sg_tank01_ally);
	SGroup_Clear(sg_tank03_ally);
end

function m_fuelUpdate()

	if (SpentFuel == nil) then
		SpentFuel = 0;
	end

	remainingFuel = ((SpentFuel/t_difficulty.fuelamount));
	Obj_ShowProgress2("$08a0ac9c7e6144909909a02d533ce8aa:87", 1.0 - remainingFuel);

	local removeAt = nil;
	
	for i=1, #t_fuelmonitor do
		if (t_fuelmonitor[i].IsAlive == true and t_fuelmonitor[i].Disabled == false) then
			if (SGroup_IsMoving(t_fuelmonitor[i].sg, ANY) == true and t_fuelmonitor[i].Fuel > 0) then
				if (t_fuelmonitor[i].Fuel > 0) then
					SpentFuel = SpentFuel + g_fuelburnamount;
					t_fuelmonitor[i].Fuel = t_fuelmonitor[i].Fuel - g_fuelburnamount;
					if (t_fuelmonitor[i].Fuel <= 75 and remainingFuel > 0 and t_fuelmonitor[i].ModifierApplied == false) then
						t_fuelmonitor[i].modifier = Modify_UnitSpeed(t_fuelmonitor[i].sg, 0.5);
						t_fuelmonitor[i].ModifierApplied = true;
						SGroup_CreateKickerMessage(t_fuelmonitor[i].sg, player1, "$08a0ac9c7e6144909909a02d533ce8aa:95");
						EventCue_Create(nil, "$08a0ac9c7e6144909909a02d533ce8aa:123", "$08a0ac9c7e6144909909a02d533ce8aa:125", t_fuelmonitor[i].sg, "$08a0ac9c7e6144909909a02d533ce8aa:126", nil, 15, true);
					end
				end
			else
				if (t_fuelmonitor[i].Fuel <= 0) then
					t_fuelmonitor[i].modifier = Modify_UnitSpeed(t_fuelmonitor[i].sg, 0);
					t_fuelmonitor[i].Disabled = true;
					SGroup_CreateKickerMessage(t_fuelmonitor[i].sg, player1, "$08a0ac9c7e6144909909a02d533ce8aa:87");
					Util_StartIntel(EVENTS.OUTOFFUEL);
					m_targetweaktank(t_fuelmonitor[i].sg);
				end
			end
			if (SGroup_Count(t_fuelmonitor[i].sg) == 0) then
				removeAt = i;
			end
		end
	end

	if (removeAt ~= nil) then
		table.remove(t_fuelmonitor,removeAt);
	end
	
	if (SpentFuel == t_difficulty.fuelamount) then
		Objective_Fail(OBJ_FUEL, true);
	else
		pcall(m_refuel);
	end
	
end

function _PlayerObjective_Check()
	local sg_all_player_squads = Player_GetSquads(player1);
	if (SGroup_Count(sg_all_player_squads) == 0) then
		Objective_Fail(OBJ_PLAYERSQUADS, true);
		Objective_Fail(OBJ_SQUADS, false);
		Rule_AddOneShot(m_lose, 5);
		Rule_RemoveMe();
	end
end

function m_win()
	Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:37", 5.0, 5.0, 5.0); 
	Game_EndSP(true);
	Rule_RemoveAll();
end

function m_lose()
	Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:38", 5.0, 5.0, 5.0); 
	Game_EndSP(false);
	Rule_RemoveAll();
end

function m_HasCapturedRadio()
	if (EGroup_IsCapturedByPlayer(eg_radio, player1, ANY)) then
		Objective_Complete(OBJ_RADIO, true);
		Rule_AddOneShot(m_connectradio, 5);
		Rule_AddInterval(m_populate, 30);
		Rule_Remove(m_updateinfantry_m_new);
		Rule_RemoveMe();
	end
end

function m_targetweaktank(target) -- hunt down the tanks that does not have any fuel

	if (t_difficulty.allowfueltarget == true) then
		
		local t_temp = 
		{
			m_sg = SGroup_CreateIfNotFound("sg_temp_ai_fuel_hunt"),
			m_target = target,
		};
		
		Util_CreateSquads(player3, t_temp.m_sg, BP_GetSquadBlueprint("panzer_iv_squad_mp"), mkr_german_tank_spawner, nil, 1, nil, false, nil, nil, nil);
		SGroup_IncreaseVeterancyRank(t_temp.m_sg, World_GetRand(0, t_difficulty.maxvet), true);
		Cmd_Attack(t_temp.m_sg, t_temp.m_target, false, false, nil); 
		
		table.insert(g_tankfuelhunters, t_temp);
		
		if (Rule_Exists(_updatetankhunters) == false) then
			Rule_Add(_updatetankhunters);
		end
		
	end

end

function m_refuel()

	local sg_fueltanks = SGroup_CreateIfNotFound("sg_fueltanks");
	World_GetSquadsNearMarker(player1, sg_fueltanks, mkr_repair_and_fuel, OT_Player);

	if (SGroup_Count(sg_fueltanks) > 0) then
		
		for i=1, SGroup_Count(sg_fueltanks) do
			for j=1, #t_fuelmonitor do
				if (SGroup_Count(t_fuelmonitor[j].sg) > 0) then
					if (SGroup_GetSpawnedSquadAt(t_fuelmonitor[j].sg, 1) == SGroup_GetSpawnedSquadAt(sg_fueltanks, i)) then
						if (t_fuelmonitor[j].Fuel < t_fuelmonitor[j].MaxFuel) then
							local toRemoveAmount = t_fuelmonitor[j].MaxFuel - t_fuelmonitor[j].Fuel;
							t_fuelmonitor[j].Fuel = t_fuelmonitor[j].MaxFuel;
							SpentFuel = SpentFuel + toRemoveAmount;
						end
					end
				end
			end
		end
		
	end
	
end

function _updatetankhunters()
	for i=1, #g_tankfuelhunters do
		if (SGroup_Count(g_tankfuelhunters[i].m_target) == 0 and SGroup_Count(g_tankfuelhunters[i].m_sg) > 0) then
			Cmd_MoveToAndDespawn(g_tankfuelhunters[i].m_sg, mkr_german_tank_spawner, false); 
			table.remove(g_tankfuelhunters, i);
		end
	end
	if (#g_tankfuelhunters == 0) then
		Rule_RemoveMe();
	end
end

function SGroup_FromSquad(squad)
	local sg_temp = SGroup_CreateIfNotFound("sg_temp_from_squad");
	SGroup_Add(sg_temp, squad);
	return sg_temp;
end

function SGroup_GetFuelAmount(sgroup)
	if (SGroup_Count(sgroup) > 1) then
		fatal("Can only check one squad for fuel");
	else
		for i=1, #t_fuelmonitor do
			if (t_fuelmonitor[i].sg == sgroup) then
				return t_fuelmonitor[i].Fuel;
			end
		end
	end
	return -1; -- This means the sgroup doesn't have any fuel
end

function SGroup_GetFuelMoniterIndex(sgroup)
	if (SGroup_Count(sgroup) > 0) then
		for i=1, #t_fuelmonitor do
			if (t_fuelmonitor[i].sg == sgroup or SGroup_GetSpawnedSquadAt(t_fuelmonitor[i].sg, 1) == SGroup_GetSpawnedSquadAt(sgroup, 1)) then
				return i;
			end
		end
	end
	return -1; -- This means the sgroup doesn't have any fuel
end

function Cmd_Repair(executer, target, ability, queued)
	if (ability == nil) then
		ability = "aef_repair_ability_vehicle_crew_mp";
	end
	Cmd_Ability(executer, BP_GetAbilityBlueprint(ability), target, nil, true, queued);
end

function Util_GetUpgradeFromTable(bp, t)
	local t_upgrades = {};
	for i=1, #t do
		if (t[i].blueprint == bp or t[i].blueprint == "any") then
			table.insert(t_upgrades, t[i]);
		end
	end
	
	if (#t_upgrades == 1) then
		return BP_GetUpgradeBlueprint(t_upgrades[1].upgrade);
	elseif (#t_upgrades > 1) then
		return BP_GetUpgradeBlueprint(t_upgrades[World_GetRand(1, #t_upgrades)].upgrade);
	else
		return nil;
	end
end

function m_connectradio()

	Util_StartIntel(EVENTS.RADIOTRANSMISSION);
	Objective_Start(OBJ_REPAIRBAY, true);
	
	OBJ_REPAIRBAY.reinforcementprogress = 1.0;
	Obj_ShowProgress("$08a0ac9c7e6144909909a02d533ce8aa:108", OBJ_REPAIRBAY.reinforcementprogress);
	
	SGroup_DeSpawn(sg_patrol);
	
	Rule_Remove(m_populate);
	
	--m_movetoquickdefend();
	
	Rule_AddInterval(m_attackbay, 10);
	Rule_AddInterval(m_recapradio, 5);
	Rule_AddInterval(m_reinforcements, 40);
	
end

function m_attackbay()

	if (SGroup_Count(sg_attack_squads) < t_difficulty.maxcounterforce) then
		
		local sg_temp = SGroup_CreateIfNotFound("sg_temp_bay");
		
		local randomVar = World_GetRand(1, 10);
		local Markers = {mkr_german_bonus_spawner01, mkr_german_bonus_spawner02, mkr_german_tank_spawner};
		local RandMArker = Markers[World_GetRand(1, #Markers)];
		
		if (randomVar >= 8) then -- spawn infantry
			
			local bp = t_infantry[World_GetRand(1, #t_infantry)];
			
			Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(bp), RandMArker, nil, 1, nil, false, nil, nil, nil);
			SGroup_IncreaseVeterancyRank(sg_temp, World_GetRand(0, t_difficulty.maxvet), true);
			--Cmd_InstantUpgrade(sg_temp, Util_GetUpgradeFromTable(bp, t_upgrades));
			Cmd_AttackMoveThenCapture(sg_temp, eg_repair_bay, false);
			
		else
		
			local bp = t_vehicles[World_GetRand(1, #t_vehicles)];
			
			if (bp == "panther_squad_mp") then
				local DoPanzerInstead = World_GetRand(0, 10);
				if (DoPanzerInstead < t_difficulty.chanceofpanther) then
					bp = "panzer_iv_stubby_squad_mp";
				end
			end
			
			Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(bp), RandMArker, nil, 1, nil, false, nil, nil, nil);
			Cmd_AttackMove(sg_temp, EGroup_GetPosition(eg_repair_bay));
		
		end
		
		SGroup_Clear(sg_temp);
		
		SGroup_AddGroup(sg_attack_squads, sg_temp);
		
	end

end

function m_reinforcements()

	OBJ_REPAIRBAY.reinforcementprogress = OBJ_REPAIRBAY.reinforcementprogress - 0.1;
	Obj_ShowProgress("$08a0ac9c7e6144909909a02d533ce8aa:108", OBJ_REPAIRBAY.reinforcementprogress);
	if (OBJ_REPAIRBAY.reinforcementprogress <= 0.0) then
		Obj_HideProgress();
		m_finishdefence();
		Rule_RemoveMe();
	end
	
	if (EGroup_IsCapturedByPlayer(eg_repair_bay, player3, ANY)) then
		Objective_Fail(OBJ_REPAIRBAY, true);
		Objective_Fail(OBJ_MAIN, true);
		
		m_lose();
		Rule_RemoveMe();
	end
	
end

function m_recapradio()

	if (SGroup_Count(sg_radio_cap_squads) < 4) then
		
		local sg_temp = SGroup_CreateIfNotFound("sg_temp_recap");
		local Markers = {mkr_german_bonus_spawner01, mkr_german_bonus_spawner02, mkr_german_tank_spawner};
		local RandMArker = Markers[World_GetRand(1, #Markers)];
		local bp = t_infantry[World_GetRand(1, #t_infantry)];
		
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(bp), RandMArker, nil, 1, nil, false, nil, nil, nil);
		SGroup_IncreaseVeterancyRank(sg_temp, World_GetRand(0, t_difficulty.maxvet), true);
		Cmd_InstantUpgrade(sg_temp, Util_GetUpgradeFromTable(bp, t_upgrades));
		Cmd_AttackMoveThenCapture(sg_temp, eg_radio, false); 
		
		SGroup_AddGroup(sg_radio_cap_squads, sg_temp);
		
	end

end

function m_movetoquickdefend()

	SGroup_WarpToMarker(Player_GetSquads(player1), mkr_warp_tanks);
	Cmd_Move(Player_GetSquads(player1), mkr_after_radio_defence);
	--m_delayedally();
	
	SGroup_SetAvgHealth(Player_GetSquads(player1), 1.0);
	
end

function m_finishdefence()

	Objective_Complete(OBJ_REPAIRBAY, true);
	Objective_Start(OBJ_RERADIO, true);
	Util_StartIntel(EVENTS.DEFENCEDONE);
	
	m_urgent_reinforcements();
	
	Rule_Remove(m_attackbay);
	Rule_Remove(m_recapradio);
	--Rule_AddInterval(m_populate, 40);
	
	Event_Proximity(m_begin_reinforcements, nil, Player_GetSquads(player1), mkr_soviet_reinforcement_check, 100, ANY, 10); 
	
	m_deployseconddefensiveline();
	
end

function m_deployseconddefensiveline()

	local t_easy = {"ostwind_squad_mp", "panzer_iv_stubby_squad_mp", "scoutcar_sdkfz222_mp", "stug_iii_e_squad_mp"};
	local t_normal = {"ostwind_squad_mp", "panzer_iv_squad_mp", "panzer_iv_stubby_squad_mp", "scoutcar_sdkfz222_mp", "stug_iii_e_squad_mp"};
	local t_hard = {"panther_squad_mp", "panzer_iv_squad_mp", "panzer_iv_stubby_squad_mp", "stug_iii_e_squad_mp"};

	local sg_temp = SGroup_CreateIfNotFound("sg_temp");
	local sg_tiger_temp = SGroup_CreateIfNotFound("sg_tiger_temp");
	
	if (g_diff == GD_EASY) then
		
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_easy[World_GetRand(1, #t_easy)]), mkr_ambush_spawner02, mkr_reradio01, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_easy[World_GetRand(1, #t_easy)]), mkr_ambush_spawner02, mkr_reradio02, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_easy[World_GetRand(1, #t_easy)]), mkr_ambush_spawner02, mkr_reradio03, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_easy[World_GetRand(1, #t_easy)]), mkr_ambush_spawner02, mkr_reradio04, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_easy[World_GetRand(1, #t_easy)]), mkr_ambush_spawner02, mkr_reradio05, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_easy[World_GetRand(1, #t_easy)]), mkr_ambush_spawner02, mkr_reradio06, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint("stug_iii_e_squad_mp"), mkr_ambush_spawner02, mkr_reradio07, 1, nil, false, nil, nil, nil);
		
	elseif (g_diff == GD_NORMAL) then
		
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_normal[World_GetRand(1, #t_normal)]), mkr_ambush_spawner02, mkr_reradio01, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_normal[World_GetRand(1, #t_normal)]), mkr_ambush_spawner02, mkr_reradio02, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_normal[World_GetRand(1, #t_normal)]), mkr_ambush_spawner02, mkr_reradio03, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_normal[World_GetRand(1, #t_normal)]), mkr_ambush_spawner02, mkr_reradio04, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_normal[World_GetRand(1, #t_normal)]), mkr_ambush_spawner02, mkr_reradio05, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_normal[World_GetRand(1, #t_normal)]), mkr_ambush_spawner02, mkr_reradio06, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint("panther_squad_mp"), mkr_ambush_spawner02, mkr_reradio07, 1, nil, false, nil, nil, nil);
		
	elseif (g_diff == GD_HARD) then
		
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_hard[World_GetRand(1, #t_hard)]), mkr_ambush_spawner02, mkr_reradio01, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_hard[World_GetRand(1, #t_hard)]), mkr_ambush_spawner02, mkr_reradio02, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_hard[World_GetRand(1, #t_hard)]), mkr_ambush_spawner02, mkr_reradio03, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_hard[World_GetRand(1, #t_hard)]), mkr_ambush_spawner02, mkr_reradio04, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_hard[World_GetRand(1, #t_hard)]), mkr_ambush_spawner02, mkr_reradio05, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_hard[World_GetRand(1, #t_hard)]), mkr_ambush_spawner02, mkr_reradio06, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_tiger_temp, BP_GetSquadBlueprint("tiger_squad_mp"), mkr_ambush_spawner02, mkr_reradio07, 1, nil, false, nil, nil, nil);
		SGroup_IncreaseVeterancyRank(sg_tiger_temp, 3, true);
		
	end
	
	SGroup_Clear(sg_temp);
	
end

function m_urgent_reinforcements()

	Util_CreateSquads(player2, sg_soviet_reinforcements, BP_GetSquadBlueprint("t_34_85_squad_mp"), mkr_urgent_support_spawner, mkr_urgent_reinforcement01, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player2, sg_soviet_reinforcements, BP_GetSquadBlueprint("t_34_85_squad_mp"), mkr_urgent_support_spawner, mkr_urgent_reinforcement02, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player2, sg_soviet_reinforcements, BP_GetSquadBlueprint("t_34_85_squad_mp"), mkr_urgent_support_spawner, mkr_urgent_reinforcement03, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player2, sg_soviet_reinforcements, BP_GetSquadBlueprint("su-85_mp"), mkr_urgent_support_spawner, mkr_urgent_reinforcement04, 1, nil, false, nil, nil, nil);
	
end

function m_begin_reinforcements()

	Util_StartIntel(EVENTS.ARRIVE);
	
	Util_CreateSquads(player2, sg_soviet_reinforcements, BP_GetSquadBlueprint("t_34_85_squad_mp"), mkr_german_bonus_spawner02, mkr_soviet_t34_ally_01, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player2, sg_soviet_reinforcements, BP_GetSquadBlueprint("t_34_85_squad_mp"), mkr_german_bonus_spawner02, mkr_soviet_t34_ally_02, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player2, sg_soviet_reinforcements, BP_GetSquadBlueprint("t_34_85_squad_mp"), mkr_german_bonus_spawner02, mkr_soviet_t34_ally_03, 1, nil, false, nil, nil, nil);
	
	Rule_AddInterval(m_playerrecapture, 5);
	
	Rule_AddOneShot(m_soft_reradio_defence, 15);
	
end

function m_soft_reradio_defence()

	local t_easy = {"ostwind_squad_mp", "panzer_iv_stubby_squad_mp", "scoutcar_sdkfz222_mp", "stug_iii_e_squad_mp"};
	local t_normal = {"ostwind_squad_mp", "panzer_iv_squad_mp", "panzer_iv_stubby_squad_mp", "scoutcar_sdkfz222_mp", "stug_iii_e_squad_mp"};
	local t_hard = {"panther_squad_mp", "panzer_iv_squad_mp", "panzer_iv_stubby_squad_mp", "stug_iii_e_squad_mp"};

	local sg_temp = SGroup_CreateIfNotFound("sg_temp");
	
	if (g_diff == GD_EASY) then
		
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_easy[World_GetRand(1, #t_easy)]), mkr_ambush_spawner01, mkr_ambush_pos01, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_easy[World_GetRand(1, #t_easy)]), mkr_ambush_spawner01, mkr_ambush_pos01, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_easy[World_GetRand(1, #t_easy)]), mkr_ambush_spawner02, mkr_ambush_pos02, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_easy[World_GetRand(1, #t_easy)]), mkr_ambush_spawner02, mkr_ambush_pos02, 1, nil, false, nil, nil, nil);
		
	elseif (g_diff == GD_NORMAL) then
		
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_normal[World_GetRand(1, #t_normal)]), mkr_ambush_spawner01, mkr_ambush_pos01, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_normal[World_GetRand(1, #t_normal)]), mkr_ambush_spawner01, mkr_ambush_pos01, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_normal[World_GetRand(1, #t_normal)]), mkr_ambush_spawner02, mkr_ambush_pos02, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_normal[World_GetRand(1, #t_normal)]), mkr_ambush_spawner02, mkr_ambush_pos02, 1, nil, false, nil, nil, nil);
		
	elseif (g_diff == GD_HARD) then
		
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_hard[World_GetRand(1, #t_hard)]), mkr_ambush_spawner01, mkr_ambush_pos01, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_hard[World_GetRand(1, #t_hard)]), mkr_ambush_spawner01, mkr_ambush_pos01, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_hard[World_GetRand(1, #t_hard)]), mkr_ambush_spawner02, mkr_ambush_pos02, 1, nil, false, nil, nil, nil);
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_hard[World_GetRand(1, #t_hard)]), mkr_ambush_spawner02, mkr_ambush_pos02, 1, nil, false, nil, nil, nil);
		
	end
	
	SGroup_Clear(sg_temp);

end

function m_playerrecapture()

	if (EGroup_IsCapturedByPlayer(eg_radio, player1, ANY)) then
		
		Objective_Complete(OBJ_RERADIO, true);
		Util_StartIntel(EVENTS.RECAPPEDRAIO);
		
		m_enable_reinforcements();
		m_germanambush();
		
		Objective_Start(OBJ_AXIS_CONOY, true);
		--Objective_Start(OBJ_TANKHUNT, true);
		
		OBJ_AXIS_CONOY.convoyWatch = {};
		OBJ_AXIS_CONOY.KilledVehicles = 0;
		OBJ_AXIS_CONOY.SpawnedVehicles = 0;
		
		table.remove(patrol_spawn_markers, 2);
		
		Rule_AddInterval(m_axis_beginhunt, 5);
		Rule_AddInterval(m_populate, 40);
		Rule_AddInterval(m_soviet_award_fuel, 4);
		Rule_AddDelayedInterval(m_soviet_conoy_do, 60, 35);
		Rule_AddDelayedInterval(m_axis_convoy_do, 40, 20);
		
		Rule_RemoveMe();
		
	end

end

function m_enable_reinforcements()
	
	Production_Enable("conscript", true);
	Production_Enable("t34/76", true);
	Production_Enable("t34/85", true);
	Production_Enable("kv1", true);
	
end

function m_germanambush()

	local sg_temp = SGroup_CreateIfNotFound("sg_temp_a");

	Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_vehicles[World_GetRand(1, #t_vehicles)]), mkr_german_tank_spawner, Util_GetRandomPosition(mkr_random_pos_for_ambush, 5), 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_vehicles[World_GetRand(1, #t_vehicles)]), mkr_german_tank_spawner, Util_GetRandomPosition(mkr_random_pos_for_ambush, 5), 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_vehicles[World_GetRand(1, #t_vehicles)]), mkr_german_bonus_spawner03, Util_GetRandomPosition(mkr_random_pos_for_ambush, 5), 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(t_vehicles[World_GetRand(1, #t_vehicles)]), mkr_german_bonus_spawner03, Util_GetRandomPosition(mkr_random_pos_for_ambush, 5), 1, nil, false, nil, nil, nil);

end

function m_soviet_conoy_do()

	if (SGroup_Count(sg_soviet_convoy) < t_difficulty.max_soviet_convoy) then
		
		local squadData = t_convoy_soviet[World_GetRand(1, #t_convoy_soviet)];
		local sg_temp = SGroup_CreateIfNotFound("sg_temp_convoy_soviet".. OBJ_AXIS_CONOY.SpawnedVehicles);
		local bp = squadData.blueprint;
		
		Util_CreateSquads(player2, sg_temp, BP_GetSquadBlueprint(bp), mkr_soviet_reinforcements, nil, 1, nil, false, nil, nil, nil);
		
		if (squadData.hold) then
			Util_CreateSquads(player2, SGroup_CreateIfNotFound("sg_temp_hold"), BP_GetSquadBlueprint(t_convoy_infantry_soviet[World_GetRand(1, #t_convoy_infantry_soviet)]), sg_temp, nil, 1, nil, false, nil, nil, nil);
		end
		
		Cmd_Move(sg_temp, mkr_soviet_convoy_dest01, true);
		Cmd_Move(sg_temp, mkr_soviet_convoy_dest02, true);
		Cmd_MoveToAndDespawn(sg_temp, mkr_soviet_convoy_dest03, true);
		
		OBJ_AXIS_CONOY.SpawnedVehicles = OBJ_AXIS_CONOY.SpawnedVehicles + 1;
		
		Event_Proximity(m_sovietconvoyfuel, nil, sg_temp, mkr_soviet_convoy_dest03, 10, ANY, 0); 
		
	end

end

function m_soviet_award_fuel()
	
	local sg_temp = SGroup_CreateIfNotFound("sg_soviet_convoy_issafe");
	World_GetSquadsNearMarker(player2, sg_temp, mkr_player_unit_spawner, OT_Ally); 
	
	if (SGroup_Count(sg_temp) > 0) then
		
		for i=1, SGroup_Count(sg_temp) do
			
			local random_amount = World_GetRand(1, 5);
			
			if (random_amoun == 1) then
				SGroup_CreateKickerMessage(sg_temp, player1, "$08a0ac9c7e6144909909a02d533ce8aa:129");
				SpentFuel = SpentFuel - 5;
			elseif (random_amount == 2) then
				SGroup_CreateKickerMessage(sg_temp, player1, "$08a0ac9c7e6144909909a02d533ce8aa:130");
				SpentFuel = SpentFuel - 10;
			elseif (random_amount == 3) then
				SGroup_CreateKickerMessage(sg_temp, player1, "$08a0ac9c7e6144909909a02d533ce8aa:131");
				SpentFuel = SpentFuel - 15;
			elseif (random_amount == 4) then
				SGroup_CreateKickerMessage(sg_temp, player1, "$08a0ac9c7e6144909909a02d533ce8aa:132");
				SpentFuel = SpentFuel - 20;
			elseif (random_amount == 5) then
				SGroup_CreateKickerMessage(sg_temp, player1, "$08a0ac9c7e6144909909a02d533ce8aa:133");
				SpentFuel = SpentFuel - 30;
			end
			
		end
		
	end
	
	SGroup_Clear(sg_temp);
	
end

function m_axis_convoy_do()

	if (SGroup_Count(sg_axis_convoy) < t_difficulty.max_axis_convoy) then
		
		local squadData = t_convoy_axis[World_GetRand(1, #t_convoy_axis)];
		
		local sg_temp = SGroup_CreateIfNotFound("sg_temp_convoy_axis"..OBJ_AXIS_CONOY.SpawnedVehicles);
		local bp = squadData.blueprint;
		
		Util_CreateSquads(player3, sg_temp, BP_GetSquadBlueprint(bp), mkr_german_bonus_spawner01, nil, 1, nil, false, nil, nil, nil);
		
		if (squadData.hold) then
			Util_CreateSquads(player3, SGroup_CreateIfNotFound("sg_temp_hold_axis"), BP_GetSquadBlueprint(t_convoy_infantry_axis[World_GetRand(1, #t_convoy_infantry_axis)]), sg_temp, nil, 1, nil, false, nil, nil, nil);
		end
		
		Cmd_Move(sg_temp, mkr_axis_convoy_dest01, true);
		Cmd_Move(sg_temp, mkr_axis_convoy_dest02, true);
		Cmd_MoveToAndDespawn(sg_temp, mkr_axis_convoy_dest03, true);
		
		SGroup_SetAvgHealth(sg_temp, Util_GetRandomHealth());
		
		OBJ_AXIS_CONOY.SpawnedVehicles = OBJ_AXIS_CONOY.SpawnedVehicles + 1;
		table.insert(OBJ_AXIS_CONOY.convoyWatch, sg_temp);
		
	end

end

function Util_GetRandomHealth()

	local rand = World_GetRand(1, 100);
	local rand2 = World_GetRand(1, 10);
	local rand3 = World_GetRand(1, 10) / 2;
	local sum = rand3/rand;
	if (sum > 0.1) then
		return sum
	else
		return rand3/rand + 0.1;
	end
	
end

function m_sovietconvoyfuel()
	SpentFuel = SpentFuel - 5;
end

function m_axisconvoykill()
	OBJ_AXIS_CONOY.KilledVehicles = OBJ_AXIS_CONOY.KilledVehicles + 1;
end

function m_axis_beginhunt()

	local RemoveAt = nil;

	for i=1, #OBJ_AXIS_CONOY.convoyWatch do
		if (SGroup_Count(OBJ_AXIS_CONOY.convoyWatch[i]) == 0) then
			RemoveAt = i;
			m_axisconvoykill();
			break;
		end
	end
	
	if (RemoveAt ~= nil) then
		table.remove(OBJ_AXIS_CONOY.convoyWatch, RemoveAt);
	end
	
	if (OBJ_AXIS_CONOY.KilledVehicles >= 6) then
		
		OBJ_TANKHUNT.tanks = 
		{
			{sg = sg_panzerhunt_elefant01, killed = false},
			{sg = sg_panzerhunt_elefant02, killed = false},
			{sg = sg_panzerhunt_elefant03, killed = false},
			{sg = sg_panzerhunt_tiger01, killed = false},
		};
		
		if (Objective_IsStarted(OBJ_TANKHUNT) == false) then
			Objective_Start(OBJ_TANKHUNT, true);
		end
		
		m_axis_hunt_spawn();
		
		Objective_SetCounter(OBJ_TANKHUNT, 0, 8); 
		World_IncreaseInteractionStage();
		
		Rule_AddInterval(m_axis_alldone, 5);
		Rule_RemoveMe();
		
	end

end

function m_axis_hunt_spawn()

	sg_tiger2_PH = SGroup_CreateIfNotFound("sg_tiger2_PH");
	sg_tiger3_PH = SGroup_CreateIfNotFound("sg_tiger3_PH");
	sg_elefant_PH = SGroup_CreateIfNotFound("sg_elefant_PH");
	sg_panther_PH = SGroup_CreateIfNotFound("sg_panther_PH");

	local sg_grenadiers_support = SGroup_CreateIfNotFound("sg_grenadiers_support");
	local sg_panther_support = SGroup_CreateIfNotFound("sg_panther_support");
	
	Util_CreateSquads(player3, sg_tiger2_PH, BP_GetSquadBlueprint("tiger_squad_mp"), mkr_german_bonus_spawner03, mkr_panzerhunt_tiger01, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, sg_tiger3_PH, BP_GetSquadBlueprint("tiger_squad_mp"), mkr_german_bonus_spawner01, mkr_panzerhunt_tiger02, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, sg_elefant_PH, BP_GetSquadBlueprint("elefant_tank_destroyer_squad_mp"), mkr_german_tank_spawner, mkr_panzerhunt_elefant01, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, sg_panther_PH, BP_GetSquadBlueprint("panther_squad_mp"), mkr_german_bonus_spawner01, nil, 1, nil, false, nil, nil, nil);
	
	Util_CreateSquads(player3, sg_panther_support, BP_GetSquadBlueprint("stormtrooper_squad_mp"), mkr_german_bonus_spawner01, nil, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, sg_panther_support, BP_GetSquadBlueprint("stormtrooper_squad_mp"), mkr_german_bonus_spawner01, nil, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, sg_panther_support, BP_GetSquadBlueprint("stormtrooper_squad_mp"), mkr_german_bonus_spawner01, nil, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, sg_panther_support, BP_GetSquadBlueprint("stormtrooper_squad_mp"), mkr_german_bonus_spawner01, nil, 1, nil, false, nil, nil, nil);
	
	Modify_UnitSpeed(sg_panther_PH, 0.75);
	
	Cmd_SquadPath(sg_panther_PH, "axis_vetpanther", true, LOOP_TOGGLE_DIRECTION, true, 0, nil, false, true);
	Cmd_SquadPath(sg_panther_support, "axis_vetpanther", true, LOOP_TOGGLE_DIRECTION, true, 0, nil, false, true); 
	
	Util_CreateSquads(player3, sg_grenadiers_support, BP_GetSquadBlueprint("stormtrooper_squad_mp"), mkr_german_tank_spawner, mkr_panzerhunt_elefant01_01, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, sg_grenadiers_support, BP_GetSquadBlueprint("stormtrooper_squad_mp"), mkr_german_tank_spawner, mkr_panzerhunt_elefant01_02, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, sg_grenadiers_support, BP_GetSquadBlueprint("stormtrooper_squad_mp"), mkr_german_tank_spawner, mkr_panzerhunt_elefant01_03, 1, nil, false, nil, nil, nil);
	
	Util_CreateSquads(player3, sg_grenadiers_support, BP_GetSquadBlueprint("stormtrooper_squad_mp"), mkr_german_bonus_spawner03, mkr_panzerhunt_tiger01_01, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, sg_grenadiers_support, BP_GetSquadBlueprint("stormtrooper_squad_mp"), mkr_german_bonus_spawner03, mkr_panzerhunt_tiger01_02, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, sg_grenadiers_support, BP_GetSquadBlueprint("stormtrooper_squad_mp"), mkr_german_bonus_spawner03, mkr_panzerhunt_tiger01_03, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, sg_grenadiers_support, BP_GetSquadBlueprint("stormtrooper_squad_mp"), mkr_german_bonus_spawner03, mkr_panzerhunt_tiger01_04, 1, nil, false, nil, nil, nil);
	
	Util_CreateSquads(player3, sg_grenadiers_support, BP_GetSquadBlueprint("stormtrooper_squad_mp"), mkr_german_bonus_spawner01, mkr_panzerhunt_tiger02_01, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, sg_grenadiers_support, BP_GetSquadBlueprint("stormtrooper_squad_mp"), mkr_german_bonus_spawner01, mkr_panzerhunt_tiger02_02, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, sg_grenadiers_support, BP_GetSquadBlueprint("stormtrooper_squad_mp"), mkr_german_bonus_spawner01, mkr_panzerhunt_tiger02_03, 1, nil, false, nil, nil, nil);
	
	SGroup_IncreaseVeterancyRank(sg_panzerhunt_tiger01, 3, true);
	SGroup_IncreaseVeterancyRank(sg_tiger2_PH, 3, true);
	SGroup_IncreaseVeterancyRank(sg_tiger3_PH, 3, true);
	SGroup_IncreaseVeterancyRank(sg_panzerhunt_elefant01, 3, true);
	SGroup_IncreaseVeterancyRank(sg_panzerhunt_elefant02, 3, true);
	SGroup_IncreaseVeterancyRank(sg_panzerhunt_elefant03, 3, true);
	SGroup_IncreaseVeterancyRank(sg_elefant_PH, 3, true);
	SGroup_IncreaseVeterancyRank(sg_panther_PH, 3, true);
	
	local t_temp01 = {sg = sg_tiger2_PH, killed = false};
	local t_temp02 = {sg = sg_tiger3_PH, killed = false};
	local t_temp03 = {sg = sg_elefant_PH, killed = false};
	local t_temp04 = {sg = sg_panther_PH, killed = false, supportgrouppe = sg_panther_support};
	
	table.insert(OBJ_TANKHUNT.tanks, t_temp01);
	table.insert(OBJ_TANKHUNT.tanks, t_temp02);
	table.insert(OBJ_TANKHUNT.tanks, t_temp03);
	table.insert(OBJ_TANKHUNT.tanks, t_temp04);
	
end

function m_axis_alldone()

	local killed = 0;

	for i=1, #OBJ_TANKHUNT.tanks do
		
		if (SGroup_Count(OBJ_TANKHUNT.tanks[i].sg) == 0) then
			killed = killed + 1;
			if (OBJ_TANKHUNT.tanks[i].supportgrouppe ~= nil and OBJ_TANKHUNT.tanks[i].killed == false) then
				Cmd_Retreat(OBJ_TANKHUNT.tanks[i].sg, mkr_german_tank_spawner, mkr_german_tank_spawner, false, false, true);
				OBJ_TANKHUNT.tanks[i].killed = true;
			end
		end
		
	end

	Objective_SetCounter(OBJ_TANKHUNT, killed, 8); 
	
	if (killed == 8) then
		
		Objective_Complete(OBJ_TANKHUNT, true);
		Objective_Complete(OBJ_AXIS_CONOY, false);
		Objective_Complete(OBJ_MAIN, true);
		
		Objective_Complete(OBJ_PLAYERSQUADS, false);
		Objective_Complete(OBJ_FUEL, false);
		Objective_Complete(OBJ_SQUADS, true);
		
		Rule_AddOneShot(m_win, 20);
		Rule_RemoveMe();
		
	end
	
end
