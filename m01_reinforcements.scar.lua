MESSAGE_TYPE_CALLBACK = 1.0

function Mission_Reinforcements()

	sg_lastreinforcement = SGroup_CreateIfNotFound("sg_lastreinforcement");

	t_production = {};
	t_production["volksgrenadier"] = {};
	t_production["volksgrenadier"].unit = "volksgrenadier";
	t_production["volksgrenadier"].name = "dialog.partisan_infantry";
	t_production["volksgrenadier"].blueprint = "panzerfusilier_squad_mp";
	t_production["volksgrenadier"].available = t_difficulty.unitclass["Volks"];
	t_production["volksgrenadier"].icon = "Icons_units_unit_west_german_panzerfusilier";
	t_production["volksgrenadier"].tag = "volksgrenadier";
	t_production["volksgrenadier"].intel = nil;
	t_production["volksgrenadier"].upg = BP_GetUpgradeBlueprint("light_infantry_package");
	t_production["obersoldaten"] = {};
	t_production["obersoldaten"].unit = "obersoldaten";
	t_production["obersoldaten"].name = "dialog.basic_infantry";
	t_production["obersoldaten"].blueprint = "obersoldaten_squad_mp";
	t_production["obersoldaten"].available = t_difficulty.unitclass["Ober"];
	t_production["obersoldaten"].icon = "Icons_units_unit_west_german_waffen_honor_guard";
	t_production["obersoldaten"].tag = "obersoldaten";
	t_production["obersoldaten"].intel = nil;
	t_production["obersoldaten"].upg = BP_GetUpgradeBlueprint("waffen_infrared_stg44");
	t_production["fallschirmjäger"] = {};
	t_production["fallschirmjäger"].unit = "fallschirmjäger";
	t_production["fallschirmjäger"].name = "dialog.medium_infantry";
	t_production["fallschirmjäger"].blueprint = "fallschirmjager_squad_mp";
	t_production["fallschirmjäger"].available = t_difficulty.unitclass["Fall"];
	t_production["fallschirmjäger"].icon = "Icons_units_unit_west_german_fallschirmjager";
	t_production["fallschirmjäger"].tag = "fallschirmjäger";
	t_production["fallschirmjäger"].intel = nil;
	t_production["fallschirmjäger"].upg = nil;
	t_production["puma"] = {};
	t_production["puma"].unit = "puma";
	t_production["puma"].name = "dialog.heavy_infantry";
	t_production["puma"].blueprint = "armored_car_sdkfz_234_squad_mp";
	t_production["puma"].available = t_difficulty.unitclass["Puma"];
	t_production["puma"].icon = "Icons_vehicles_vehicle_west_german_234_puma_armored_car";
	t_production["puma"].tag = "puma";
	t_production["puma"].intel = nil;
	t_production["puma"].upg = nil;
	t_production["luchs"] = {};
	t_production["luchs"].unit = "luchs";
	t_production["luchs"].name = "dialog.medium_vehicle";
	t_production["luchs"].blueprint = "panzer_ii_luchs_squad_mp";
	t_production["luchs"].available = t_difficulty.unitclass["Luchs"];
	t_production["luchs"].icon = "Icons_vehicles_vehicle_west_german_panzer_ii_luchs";
	t_production["luchs"].tag = "luchs";
	t_production["luchs"].intel = nil;
	t_production["luchs"].upg = nil;
	t_production["irtruck"] = {};
	t_production["irtruck"].unit = "irtruck";
	t_production["irtruck"].name = "dialog.hard_medium_vehicle";
	t_production["irtruck"].blueprint = "sdkfz_251_20_ir_searchlight_halftrack_squad_mp";
	t_production["irtruck"].available = t_difficulty.unitclass["IR"];
	t_production["irtruck"].icon = "Icons_vehicles_vehicle_west_german_halftrack_251_infrared";
	t_production["irtruck"].tag = "irtruck";
	t_production["irtruck"].intel = nil;
	t_production["irtruck"].upg = nil;

	dialog =
	{
		controlType = "panel",
		name = "dialog",
		x = 1776.0,
		y = 390.0,
		width = 70.0,
		height = 300.0,
		margin = 12.0,
		children =
		{
		
            {
                controlType = "button",
                name = "partisan_infantry",
                top = 0.0,
				left = 0.0,
                width = 64.0,
                height = 64.0,
                callback = "Production_Middlecall",
                enabled = true,
                icon = t_production["volksgrenadier"].icon,
                style = BIS_Icon,
                tag = t_production["volksgrenadier"].tag,
                text = Util_CreateLocString(""..t_production["volksgrenadier"].available)
            },
			{
                controlType = "button",
                name = "basic_infantry",
                top = 70.0,
				left = 0.0,
                width = 64.0,
                height = 64.0,
                callback = "Production_Middlecall",
                enabled = true,
                icon = t_production["obersoldaten"].icon,
                style = BIS_Icon,
                tag = t_production["obersoldaten"].tag,
				text = Util_CreateLocString(""..t_production["obersoldaten"].available)
            },
			{
                controlType = "button",
                name = "medium_infantry",
                top = 140.0,
				left = 0.0,
                width = 64.0,
                height = 64.0,
                callback = "Production_Middlecall",
                enabled = true,
                icon = t_production["fallschirmjäger"].icon,
                style = BIS_Icon,
                tag = t_production["fallschirmjäger"].tag,
				text = Util_CreateLocString(""..t_production["fallschirmjäger"].available)
            },
			{
                controlType = "button",
                name = "heavy_infantry",
                top = 210.0,
				left = 0.0,
                width = 64.0,
                height = 64.0,
                callback = "Production_Middlecall",
                enabled = true,
                icon = t_production["puma"].icon,
                style = BIS_Icon,
                tag = t_production["puma"].tag,
				text = Util_CreateLocString(""..t_production["puma"].available)
            },
			{
                controlType = "button",
                name = "medium_vehicle",
                top = 0.0,
				left = 70.0,
                width = 64.0,
                height = 64.0,
                callback = "Production_Middlecall",
                enabled = true,
                icon = t_production["luchs"].icon,
                style = BIS_Icon,
                tag = t_production["luchs"].tag,
				text = Util_CreateLocString(""..t_production["luchs"].available)
            },
			{
                controlType = "button",
                name = "hard_medium_vehicle",
                top = 70.0,
				left = 70.0,
                width = 64.0,
                height = 64.0,
                callback = "Production_Middlecall",
                enabled = true,
                icon = t_production["irtruck"].icon,
                style = BIS_Icon,
                tag = t_production["irtruck"].tag,
				text = Util_CreateLocString(""..t_production["irtruck"].available)
            },
			
		},
	}
	
	t_production.warningID = nil;
	
	Rule_AddGlobalEvent(messageCallback, GE_BroadcastMessage);
	
end

function Production_Unlock()
	UI_AddControl(dialog);
end

function Production_Middlecall(tag)
	if (Util_IsCoop() == true) then
		Command_PlayerBroadcastMessage(Game_GetLocalPlayer(), Game_GetLocalPlayer(), MESSAGE_TYPE_CALLBACK, tag)
	else
		Production_Buy(tag, Game_GetLocalPlayer());
	end
end

function Production_Buy(tag, player)

	if (t_production[tag].available > 0) then
		
		local result = true;
		local pos = mkr_player_spawner;
		local sg_temp = SGroup_CreateIfNotFound("sg_temp"..tag..t_production[tag].available);
		
		Util_CreateSquads(player, sg_temp, BP_GetSquadBlueprint(t_production[tag].blueprint), pos, mkr_reinforcement_to_bridge, 1, nil, false, nil, t_production[tag].upg, nil);
		t_production[tag].available = t_production[tag].available - 1;
		Modify_Vulnerability(sg_temp, 0.65);
		
		UI_ButtonSetText(t_production[tag].name, Util_CreateLocString(t_production[tag].available));
		UI_CreateMinimapBlip(pos, 5, BT_General); 
		UI_CreateMinimapBlip(mkr_reinforcement_to_bridge, 10, BT_General); 
		
		if (t_production[tag].intel ~= nil) then
			if (Event_IsAnyRunning() == false) then
				local IgnoreIntel = World_GetRand(0, 15);
				if (IgnoreIntel >= 14) then
					Util_StartIntel(t_production[tag].intel);
				end
			end
		end
		
		SGroup_Clear(sg_temp);
		
		if (t_production[tag].available == 0) then
			UI_ButtonSetEnabled(t_production[tag].name, false);
		end
		
	end
	
end

function messageCallback(player, messageType, message)
    if messageType == MESSAGE_TYPE_CALLBACK then
		Production_Buy(message, player);
    end
end
