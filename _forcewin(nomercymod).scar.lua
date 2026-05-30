function OnInit()
	UI_ButtonAdd("", "button", 0, 0, 5, 5, "EndRound", true, "Icons_abilities_ability_soviet_transfer_orders", BIS_Icon, "Forced ending with victory after 5 min", "Forced ending with victory after 5 min")
end

Scar_AddInit( OnInit )

function EndRound()
	local ttime = World_GetGameTime()
	if ttime > 301 then
		UI_LabelSetText('Status', 'Win')
		World_SetPlayerWin(Game_GetLocalPlayer())	
	end

end
