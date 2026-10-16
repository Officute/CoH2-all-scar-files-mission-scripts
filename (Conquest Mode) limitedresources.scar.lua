function Limited_Resources()
	for i=1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
			Modify_PlayerResourceRate(player, RT_Manpower, 0 )
			--Modify_PlayerResourceRate(player, RT_Munition, -Player_GetResourceRate(player, RT_Munition), MUT_Addition)
			Modify_PlayerResourceRate(player, RT_Munition, 1)
			Modify_PlayerResourceRate(player, RT_Fuel, 1)
			--Modify_PlayerResourceRate(player, RT_Fuel, 10, MUT_Addition)
			Player_SetResource(player, RT_Manpower, 5000)
			Player_SetResource(player, RT_Munition, 1000)
			Player_SetResource(player, RT_Fuel, 800)
			--Player_SetResource(player, RT_Action, 4)
			Player_SetPopCapOverride(player, 50)
			Player_AddAbility(player, ABILITY_TRANSFER_ORDERS)
	end
	--PrintOnScreen(g_TestCounter)
	--g_TestCounter = g_TestCounter + 1
end

function ru_obj_manpower()
	Objective_Start(obj_tmr_manpower, false)
	Timer_Start("tmr_manpower", 290)
	Rule_Add(Manpower_Objective)
end

function ru_obj_manpower_initial()
	Objective_Start(obj_tmr_manpower, false)
	Timer_Start("tmr_manpower", 290)
	Rule_Add(Manpower_Objective)
	Rule_RemoveMe()
end

function Sector_Manpower()
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		local enemyplayer = Player_FindFirstEnemyPlayer(player)
		local PlayerSectors = Player_GetNumStrategicPoints(player)
		local team = Player_GetTeam(Util_GetPlayerOwner(player))
		Player_AddResource(player, RT_Manpower, 100+20*PlayerSectors+2*VPTicker_GetTeamTickers(team))
		
	end
end



function Manpower_Objective()
	--Timer_Start("tmr_manpower", 20)
	if Timer_GetRemaining("tmr_manpower") <= 0 then
		Rule_RemoveMe()
		Sector_Manpower()
		Timer_End("tmr_manpower")
		--Objective_Show(obj_tmr_manpower, false)
		--Objective_RemoveUIElements(obj_tmr_manpower)
	else
		local _manpower_amount = 0
		if(Game_HasLocalPlayer() == true) then
			local player = Game_GetLocalPlayer()
			local PlayerSectors = Player_GetNumStrategicPoints(player)
			local team = Player_GetTeam(Util_GetPlayerOwner(player))
			_manpower_amount = 100+20*PlayerSectors+2*VPTicker_GetTeamTickers(team)
		end
		Objective_UpdateText(obj_tmr_manpower, Util_CreateLocString("Resupply: " .. _manpower_amount .. " MP " ..math.floor(Timer_GetRemaining("tmr_manpower")/60)..":"..math.floor(math.floor(Timer_GetRemaining("tmr_manpower") % 60)/10)..math.floor(Timer_GetRemaining("tmr_manpower") % 60) - math.floor(math.floor(Timer_GetRemaining("tmr_manpower") % 60)/10) * 10), nil, false)
	end
end