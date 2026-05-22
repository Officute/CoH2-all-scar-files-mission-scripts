MESSAGE_TYPE_CALLBACK = 1.0

function Mission_Reinforcements()

	sg_lastreinforcement = SGroup_CreateIfNotFound("sg_lastreinforcement");

	t_production = {};
	t_production["partisan"] = {};
	t_production["partisan"].unit = "partisan";
	t_production["partisan"].name = "dialog.partisan_infantry";
	t_production["partisan"].blueprint = "partisan_squad_kar98k_rifle_mp";
	t_production["partisan"].available = t_difficulty.unitclass["Partisans"];
	t_production["partisan"].icon = "Icons_units_unit_soviet_partisan_anti_infantry";
	t_production["partisan"].tag = "partisan";
	t_production["partisan"].intel = EVENTS.PARTISAN;
	t_production["volksgrenadier"] = {};
	t_production["volksgrenadier"].unit = "volksgrenadier";
	t_production["volksgrenadier"].name = "dialog.basic_infantry";
	t_production["volksgrenadier"].blueprint = "volksgrenadier_squad_mp";
	t_production["volksgrenadier"].available = t_difficulty.unitclass["Volks"];
	t_production["volksgrenadier"].icon = "Icons_units_unit_west_german_volksgrenadiers";
	t_production["volksgrenadier"].tag = "volksgrenadier";
	t_production["volksgrenadier"].intel = nil;
	t_production["grenadier"] = {};
	t_production["grenadier"].unit = "grenadier";
	t_production["grenadier"].name = "dialog.medium_infantry";
	t_production["grenadier"].blueprint = "grenadier_squad_mp";
	t_production["grenadier"].available = t_difficulty.unitclass["Grenadiers"];
	t_production["grenadier"].icon = "Icons_units_unit_german_grenadier";
	t_production["grenadier"].tag = "grenadier";
	t_production["grenadier"].intel = EVENTS.GRENADIERS;
	t_production["pgrenadier"] = {};
	t_production["pgrenadier"].unit = "pgrenadier";
	t_production["pgrenadier"].name = "dialog.heavy_infantry";
	t_production["pgrenadier"].blueprint = "panzer_grenadier_squad_mp";
	t_production["pgrenadier"].available = t_difficulty.unitclass["PGrens"];
	t_production["pgrenadier"].icon = "Icons_units_unit_german_panzer_grenadier";
	t_production["pgrenadier"].tag = "pgrenadier";
	t_production["pgrenadier"].intel = nil;
	t_production["panzer4"] = {};
	t_production["panzer4"].unit = "panzer4";
	t_production["panzer4"].name = "dialog.medium_vehicle";
	t_production["panzer4"].blueprint = "panzer_iv_squad_mp";
	t_production["panzer4"].available = t_difficulty.unitclass["PZ4"];
	t_production["panzer4"].icon = "Icons_vehicles_vehicle_german_panzer_iv";
	t_production["panzer4"].tag = "panzer4";
	t_production["panzer4"].intel = nil;
	t_production["panzer5"] = {};
	t_production["panzer5"].unit = "panzer5";
	t_production["panzer5"].name = "dialog.medium_hard_vehicle";
	t_production["panzer5"].blueprint = "panther_squad_mp";
	t_production["panzer5"].available = t_difficulty.unitclass["PZ5"];
	t_production["panzer5"].icon = "Icons_vehicles_vehicle_german_panther";
	t_production["panzer5"].tag = "panzer5";
	t_production["panzer5"].intel = nil;
	t_production["tiger"] = {};
	t_production["tiger"].unit = "tiger";
	t_production["tiger"].name = "dialog.heavy_vehicle";
	t_production["tiger"].blueprint = "tiger_squad_mp";
	t_production["tiger"].available = t_difficulty.unitclass["Tiger"];
	t_production["tiger"].icon = "Icons_vehicles_vehicle_german_tiger";
	t_production["tiger"].tag = "tiger";
	t_production["tiger"].intel = EVENTS.TIGER;
	t_production["kingtiger"] = {};
	t_production["kingtiger"].unit = "kingtiger";
	t_production["kingtiger"].name = "dialog.very_heavy_vehicle";
	t_production["kingtiger"].blueprint = "king_tiger_squad_mp";
	t_production["kingtiger"].available = t_difficulty.unitclass["KT"];
	t_production["kingtiger"].icon = "Icons_vehicles_vehicle_west_german_king_tiger";
	t_production["kingtiger"].tag = "kingtiger";
	t_production["kingtiger"].intel = EVENTS.KT;

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
                callback = "buttonCallback",
                enabled = true,
                icon = t_production["partisan"].icon,
                style = BIS_Icon,
                tag = t_production["partisan"].tag,
                text = Util_CreateLocString(""..t_production["partisan"].available)
            },
			{
                controlType = "button",
                name = "basic_infantry",
                top = 70.0,
				left = 0.0,
                width = 64.0,
                height = 64.0,
                callback = "buttonCallback",
                enabled = true,
                icon = t_production["volksgrenadier"].icon,
                style = BIS_Icon,
                tag = t_production["volksgrenadier"].tag,
				text = Util_CreateLocString(""..t_production["volksgrenadier"].available)
            },
			{
                controlType = "button",
                name = "medium_infantry",
                top = 140.0,
				left = 0.0,
                width = 64.0,
                height = 64.0,
                callback = "buttonCallback",
                enabled = true,
                icon = t_production["grenadier"].icon,
                style = BIS_Icon,
                tag = t_production["grenadier"].tag,
				text = Util_CreateLocString(""..t_production["grenadier"].available)
            },
			{
                controlType = "button",
                name = "heavy_infantry",
                top = 210.0,
				left = 0.0,
                width = 64.0,
                height = 64.0,
                callback = "buttonCallback",
                enabled = true,
                icon = t_production["pgrenadier"].icon,
                style = BIS_Icon,
                tag = t_production["pgrenadier"].tag,
				text = Util_CreateLocString(""..t_production["pgrenadier"].available)
            },
			{
                controlType = "button",
                name = "medium_vehicle",
                top = 0.0,
				left = 70.0,
                width = 64.0,
                height = 64.0,
                callback = "buttonCallback",
                enabled = true,
                icon = t_production["panzer4"].icon,
                style = BIS_Icon,
                tag = t_production["panzer4"].tag,
                text = Util_CreateLocString(""..t_production["panzer4"].available)
            },
			{
                controlType = "button",
                name = "medium_hard_vehicle",
                top = 70.0,
				left = 70.0,
                width = 64.0,
                height = 64.0,
                callback = "buttonCallback",
                enabled = true,
                icon = t_production["panzer5"].icon,
                style = BIS_Icon,
                tag = t_production["panzer5"].tag,
				text = Util_CreateLocString(""..t_production["panzer5"].available)
            },
			{
                controlType = "button",
                name = "heavy_vehicle",
                top = 140.0,
				left = 70.0,
                width = 64.0,
                height = 64.0,
                callback = "buttonCallback",
                enabled = true,
                icon = t_production["tiger"].icon,
                style = BIS_Icon,
                tag = t_production["tiger"].tag,
				text = Util_CreateLocString(""..t_production["tiger"].available)
            },
			{
                controlType = "button",
                name = "very_heavy_vehicle",
                top = 210.0,
				left = 70.0,
                width = 64.0,
                height = 64.0,
                callback = "buttonCallback",
                enabled = true,
                icon = t_production["kingtiger"].icon,
                style = BIS_Icon,
                tag = t_production["kingtiger"].tag,
				text = Util_CreateLocString(""..t_production["kingtiger"].available)
            },
			
		},
	}

	UI_AddControl(dialog);
	
	t_production.warningID = nil;
	t_production.spawners = {mkr_player_spawner01, mkr_player_spawner02};
	
	Rule_AddGlobalEvent(messageCallback, GE_BroadcastMessage);
	
end

function buttonCallback(tag)
    Command_PlayerBroadcastMessage(Game_GetLocalPlayer(), Game_GetLocalPlayer(), MESSAGE_TYPE_CALLBACK, tag)
end

function messageCallback(player, messageType, message)
    if messageType == MESSAGE_TYPE_CALLBACK then
		Production_Buy(message, player);
    end
end

function Production_GetRandomSpawn()
	return t_production.spawners[World_GetRand(1, #t_production.spawners)];
end

function Production_Upgrade(unit, bp)
	
	local t_infantry = {"partisan_squad_kar98k_rifle_mp", "volksgrenadier_squad_mp", "grenadier_squad_mp", "panzer_grenadier_squad_mp"};
	local t_infantry_upgrades = {"grenadier_mg42_lmg_mp", "panzer_grenadier_panzershreck_atw_item_mp", "", "panzerbusche_39_mp", "stormtrooper_assault_package_mp", "", "light_infantry_package", "waffen_mg34_lmg_mp", ""};
	local IsInfantry = false;
	
	for i=1, #t_infantry do
		if (t_infantry[i] == bp) then
			IsInfantry = true;
			break;
		end
	end
	
	if (IsInfantry == true) then
		local upg = t_infantry_upgrades[World_GetRand(1, #t_infantry_upgrades)];
		if (upg ~= "") then
			Cmd_InstantUpgrade(unit, BP_GetUpgradeBlueprint(upg), 1);
		end
	else
		if (bp == "panzer_iv_squad_mp") then
			Cmd_InstantUpgrade(unit, BP_GetUpgradeBlueprint("panzer_top_gunner_mp"), 1);
		elseif (bp == "panther_squad_mp") then
			Cmd_InstantUpgrade(unit, BP_GetUpgradeBlueprint("panther_top_gunner_mp"), 1);
		elseif (bp == "tiger_squad_mp") then
			Cmd_InstantUpgrade(unit, BP_GetUpgradeBlueprint("tiger_top_gunner_mp"), 1);
		elseif (bp == "king_tiger_squad_mp") then
			Cmd_InstantUpgrade(unit, BP_GetUpgradeBlueprint("king_tiger_top_gunner_mp"), 1);
		end
	end
	
	if (bp == "partisan_squad_kar98k_rifle_mp") then
		SGroup_AddAbility(unit, BP_GetAbilityBlueprint("grenadier_panzerfaust")); 
	elseif (bp == "volksgrenadier_squad_mp") then
		SGroup_AddAbility(unit, BP_GetAbilityBlueprint("grenadier_panzerfaust")); 
	elseif (bp == "grenadier_squad_mp") then
		SGroup_AddAbility(unit, BP_GetAbilityBlueprint("grenadier_panzerfaust")); 
	end
	
	return false;
	
end

function Production_Buy(tag, player)
	if (player == nil or scartype(player) ~= ST_PLAYER) then
		player = player1;
	end
	if (t_production[tag].available > 0) then
		local result = true;
		local pos = Production_GetRandomSpawn();
		local sg_temp = SGroup_CreateIfNotFound("sg_temp"..tag..t_production[tag].available);
		Util_CreateSquads(player, sg_temp, BP_GetSquadBlueprint(t_production[tag].blueprint), pos, mkr_player_unit_dest, 1, nil, false, nil, nil, nil);
		SGroup_IncreaseVeterancyRank(sg_temp, World_GetRand(0, 3), true);
		Modify_WeaponRange(sg_temp, "hardpoint_01", 1.5);	
		Production_Upgrade(sg_temp, t_production[tag].blueprint)
		t_production[tag].available = t_production[tag].available - 1;
		UI_ButtonSetText(t_production[tag].name, Util_CreateLocString(t_production[tag].available));
		UI_CreateMinimapBlip(pos, 5, BT_General); 
		UI_CreateMinimapBlip(mkr_player_unit_dest, 10, BT_General); 
		if (t_production[tag].intel ~= nil) then
			if (Event_IsAnyRunning() == false) then
				local IgnoreIntel = World_GetRand(0, 15);
				if (IgnoreIntel >= 14) then
					Util_StartIntel(t_production[tag].intel);
				end
			end
		end
		Production_ModifyDemands(tag);
		SGroup_Clear(sg_lastreinforcement);
		SGroup_AddGroup(sg_lastreinforcement, sg_temp);
		SGroup_Clear(sg_temp);
		if (t_production[tag].available == 0) then
			UI_ButtonSetEnabled(t_production[tag].name, false);
		end
	else
		-- show warning
	end
end

function Production_Disable()
	UI_ButtonSetEnabled(t_production["partisan"].name, false);
	UI_ButtonSetEnabled(t_production["volksgrenadier"].name, false);
	UI_ButtonSetEnabled(t_production["grenadier"].name, false);
	UI_ButtonSetEnabled(t_production["pgrenadier"].name, false);
	UI_ButtonSetEnabled(t_production["panzer4"].name, false);
	UI_ButtonSetEnabled(t_production["panzer5"].name, false);
	UI_ButtonSetEnabled(t_production["tiger"].name, false);
	UI_ButtonSetEnabled(t_production["kingtiger"].name, false);
end

function Production_Enable()
	if (t_production["partisan"].available == 0) then
		UI_ButtonSetEnabled(t_production["partisan"].name, false);
	else
		UI_ButtonSetEnabled(t_production["partisan"].name, true);
	end
	if (t_production["volksgrenadier"].available == 0) then
		UI_ButtonSetEnabled(t_production["volksgrenadier"].name, false);
	else
		UI_ButtonSetEnabled(t_production["volksgrenadier"].name, true);
	end
	if (t_production["grenadier"].available == 0) then
		UI_ButtonSetEnabled(t_production["grenadier"].name, false);
	else
		UI_ButtonSetEnabled(t_production["grenadier"].name, true);
	end
	if (t_production["pgrenadier"].available == 0) then
		UI_ButtonSetEnabled(t_production["pgrenadier"].name, false);
	else
		UI_ButtonSetEnabled(t_production["pgrenadier"].name, true);
	end
	if (t_production["panzer4"].available == 0) then
		UI_ButtonSetEnabled(t_production["panzer4"].name, false);
	else
		UI_ButtonSetEnabled(t_production["panzer4"].name, true);
	end
	if (t_production["panzer5"].available == 0) then
		UI_ButtonSetEnabled(t_production["panzer5"].name, false);
	else
		UI_ButtonSetEnabled(t_production["panzer5"].name, true);
	end
	if (t_production["tiger"].available == 0) then
		UI_ButtonSetEnabled(t_production["tiger"].name, false);
	else
		UI_ButtonSetEnabled(t_production["tiger"].name, true);
	end
	if (t_production["kingtiger"].available == 0) then
		UI_ButtonSetEnabled(t_production["kingtiger"].name, false);
	else
		UI_ButtonSetEnabled(t_production["kingtiger"].name, true);
	end
end

function Production_DiscardWarning()
	UI_TitleDestroy(t_production.warningID);
end

function Production_ModifyDemands(tag)
	if (tag == "kingtiger") then
		S_Demand_ISU152 = S_Demand_ISU152 + DEMAND_MEDIUM;
	elseif (tag == "tiger" or tag == "panzer5") then
		S_Demand_IS2 = S_Demand_IS2 + DEMAND_LOW;
		S_Demand_ISU152 = S_Demand_ISU152 + 10;
	elseif (tag == "panzer4" or tag == "pgrenadier") then
		S_Demand_Tank = S_Demand_Tank + 5;
		S_Demand_IS2 = S_Demand_IS2 + 7;
		S_Demnad_OffMapArtillery = S_Demnad_OffMapArtillery + 2;
	else
		S_Demnad_OffMapArtillery = S_Demnad_OffMapArtillery + 5;
		S_Demand_PropagandaArtillery = S_Demand_PropagandaArtillery + 2;
		S_Demand_Commissar = S_Demand_Commissar + 3;
	end
end
