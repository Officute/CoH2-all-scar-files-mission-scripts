MESSAGE_TYPE_CALLBACK = 1.0

Production_SPAWN = nil;
Production_GOTO = nil;

function Production_Initialize()

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
                icon = t_production["riflemen"].icon,
                style = BIS_Icon,
                tag = t_production["riflemen"].tag,
                text = Util_CreateLocString(""..t_production["riflemen"].available)
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
                icon = t_production["engineers"].icon,
                style = BIS_Icon,
                tag = t_production["engineers"].tag,
				text = Util_CreateLocString(""..t_production["engineers"].available)
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
                icon = t_production["mortars"].icon,
                style = BIS_Icon,
                tag = t_production["mortars"].tag,
				text = Util_CreateLocString(""..t_production["mortars"].available)
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
                icon = t_production["shermans"].icon,
                style = BIS_Icon,
                tag = t_production["shermans"].tag,
				text = Util_CreateLocString(""..t_production["shermans"].available)
            },
			
		},
	}
	
	UI_AddControl(dialog);
	Rule_AddGlobalEvent(messageCallback, GE_BroadcastMessage);
	
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
		
		local sg_temp = SGroup_CreateIfNotFound("sg_temp"..tag..t_production[tag].available);
		
		Util_CreateSquads(player, sg_temp, BP_GetSquadBlueprint(t_production[tag].blueprint), Production_SPAWN, Production_GOTO, 1, nil, false, nil, t_production[tag].upg, nil);
		t_production[tag].available = t_production[tag].available - 1;
		
		UI_ButtonSetText(t_production[tag].name, Util_CreateLocString(t_production[tag].available));
		UI_CreateMinimapBlip(Production_SPAWN, 5, BT_General); 
		
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
