MESSAGE_TYPE_CALLBACK = 1.0

local UI_YPOSITION = 0.0;
local UI_XPOSITION = 0.0;

local UI_MAXYPOS = 210.0;

function Production_AddUnit(name, blueprint, amount, icon, tag, intel, upgrade, callback)
	
	t_production.units[name] = {};
	t_production.units[name].name = name;
	t_production.units[name].blueprint = blueprint;
	t_production.units[name].available = amount;
	t_production.units[name].icon = icon;
	t_production.units[name].tag = tag;
	t_production.units[name].intel = intel;
	t_production.units[name].upg = upgrade;
	t_production.units[name].additional_callback = callback
	
	local t = 
	{
		controlType = "button",
		name = name,
        top = UI_YPOSITION,
		left = UI_XPOSITION,
        width = 64.0,
        height = 64.0,
        callback = "Production_Middlecall",
        enabled = true,
        icon = t_production.units[name].icon,
        style = BIS_Icon,
        tag = t_production.units[name].tag,
		text = Util_CreateLocString(""..t_production.units[name].available)
	};
	
	UI_YPOSITION = UI_YPOSITION + 70.0;
	
	if (UI_YPOSITION > UI_MAXYPOS) then
		UI_YPOSITION = 0.0;
		UI_XPOSITION = UI_XPOSITION + 70;
	end
	
	table.insert(dialog.children, t);
	
	Production_Update();
	
end

function Production_Remove(name)
	local RemoveAt = 0;
	for i=1, #dialog.children do
		if (dialog.children[i].name == name) then
			RemoveAt = i;
		end
	end
	if (RemoaveAt > 0) then
		table.remove(dialog.children, RemoveAt);
	end
	Production_Update();
end

function Mission_ExtraUI()

	sg_lastreinforcement = SGroup_CreateIfNotFound("sg_lastreinforcement");

	t_production = {};
	t_production.units = {};
	t_production.enabled = true;
	
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
			
		},
	}
	
	t_production.warningID = nil;
	
	Rule_AddGlobalEvent(messageCallback, GE_BroadcastMessage);
	
end

function Production_Unlock()
	UI_AddControl(dialog);
	t_production.enabled = true;
end

function Production_Lock()
	for i=1, #t_production.units do
		UI_ButtonSetEnabled(t_production.units[tag].name, false);
	end
	t_production.enabled = false;
end

function Production_Remove()
	UI_ControlRemove(dialog);
	t_production.enabled = false;
end

function Production_Update()
	if (t_production.enabled == true) then
		Production_Remove();
		Production_Unlock();
	end
end

function Production_Middlecall(tag)
	if (Util_IsCoop() == true) then
		Command_PlayerBroadcastMessage(Game_GetLocalPlayer(), Game_GetLocalPlayer(), MESSAGE_TYPE_CALLBACK, tag)
	else
		Production_Buy(tag, Game_GetLocalPlayer());
	end
end

function Production_Buy(tag, player)

	if (t_production.units[tag].available > 0) then
		
		if (t_production.units[tag].blueprint ~= nil) then
			
			local result = true;
			local pos = mkr_player_spawner;
			local sg_temp = SGroup_CreateIfNotFound("sg_temp"..tag..t_production.units[tag].available);
			
			Util_CreateSquads(player, sg_temp, BP_GetSquadBlueprint(t_production.units[tag].blueprint), pos, mkr_reinforcement_to_bridge, 1, nil, false, nil, t_production.units[tag].upg, nil);
			t_production.units[tag].available = t_production.units[tag].available - 1;
			Modify_Vulnerability(sg_temp, 0.65);
			
			UI_ButtonSetText(t_production.units[tag].name, Util_CreateLocString(t_production.units[tag].available));
			UI_CreateMinimapBlip(pos, 5, BT_General); 
			UI_CreateMinimapBlip(mkr_reinforcement_to_bridge, 10, BT_General); 
			
			if (t_production.units[tag].intel ~= nil) then
				if (Event_IsAnyRunning() == false) then
					local IgnoreIntel = World_GetRand(0, 15);
					if (IgnoreIntel >= 14) then
						Util_StartIntel(t_production.units[tag].intel);
					end
				end
			end
			
			SGroup_Clear(sg_temp);
			
			if (t_production.units[tag].available == 0) then
				UI_ButtonSetEnabled(t_production.units[tag].name, false);
			end
			
			if (t_production.units[tag].additional_callback ~= nil) then
				t_production.units[tag].additional_callback();
			end
			
		else
			
			if (t_production.units[tag].additional_callback ~= nil) then
				t_production.units[tag].additional_callback();
			end
			
		end
		
	end
	
end

function messageCallback(player, messageType, message)
    if messageType == MESSAGE_TYPE_CALLBACK then
		Production_Buy(message, player);
    end
end
