-----------------------------------------------------------------------
-- Conquest mode (modified from VPTicker)
-----------------------------------------------------------------------
import("ScarUtil.scar")
import("Fatalities/Fatalities.scar")
import("Prototype/WorldEntityCollector.scar")
import("Prototype/AABattle_VPTickerWin-Annihilate_Functions.scar")
import("Prototype/SpecialAEFunctions.scar")
import("PrintOnScreen.scar")
import("WinConditions/AABattle_Annihilate.scar")

-----------------------------------------------------------------------
-- Global flags (used externally)
--  must be global because we don't know the order the Init functions
--  are called.
-----------------------------------------------------------------------
function SetGlobals()
	-- this is used externally to know that this condition is running
	g_VPConditionsLoaded = true
	g_VictoryAchieved = false
	g_SectorsUpdated = 0
	g_TestCounter = 0
	g_sectors = {}
	g_sectors[0] = 0
	g_sectors[1] = 0
	ABILITY_TRANSFER_ORDERS = BP_GetAbilityBlueprint("transfer_orders")
end

function Init_Audio()
end

Scar_AddInit(Init_Audio)

-----------------------------------------------------------------------
-- OnInit - Main script entry point (not called for saved games)
-----------------------------------------------------------------------
function Main_Conquest()

	--g_SectorsUpdated = 0
	SetGlobals()

	-- call vanilla point control victory
	VPTicker_OnInit()



	-- objectives bit
	Init_Objectives()
	Objective_Start(obj_Conquest, false)

	-- check if a team holds all sectors
	Rule_AddInterval(Conquest, 3)
	--check for casualties
	Rule_AddGlobalEvent(checkCasualty, GE_EntityKilled)

	if VPTickerData.start_points == 2100 then
	  for i=1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		Player_SetPopCapOverride(player, 200)
	  end
    end
end

-----------------------------------------------------------------------
-- MainRules - Called every so often to process the win condition
-----------------------------------------------------------------------
function Conquest()
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		local enemyplayer = Player_FindFirstEnemyPlayer(player)
		local PlayerSectors = Player_GetNumStrategicPoints(player)
		local TotalSectors = World_GetNumStrategicPoints()
		local EnemySectors = Player_GetNumStrategicPoints(enemyplayer)
		local team = Player_GetTeam(Util_GetPlayerOwner(player))

		
		-- if VPTickerData.start_points == 1 then

			--if PlayerSectors ~= g_sectors[team] then
				--if PlayerSectors < g_sectors[team] then
				--	local morale_loss = VPTicker_GetTeamTickers(team) - 10
				--	VPTicker_SetTeamTickers(team, math.max(morale_loss, 0), true)
					if VPTicker_GetTeamTickers(team) == 0 and g_VictoryAchieved == false then
						g_VictoryAchieved = true
						VPTicker_GameOverLose(team)
					end


					--Player_AddResource(player, RT_Manpower, 100+5*(TotalSectors-PlayerSectors))
					--EGroup_CreateKickerMessage(eg_player_point, "+".. 100+5*(TotalSectors-PlayerSectors))
				--end
				--g_sectors[team] = PlayerSectors
			--end
		-- end

		if Player_IsAlive(player) and Player_IsAlive(enemyplayer) and PlayerSectors == TotalSectors and g_VictoryAchieved == false then
			-- g_VictoryAchieved = true
			-- VPTicker_GameOverLose(Player_GetTeam(Util_GetPlayerOwner(enemyplayer)))
			local morale_loss = VPTicker_GetTeamTickers(Player_GetTeam(Util_GetPlayerOwner(enemyplayer))) - 5
			VPTicker_SetTeamTickers(Player_GetTeam(Util_GetPlayerOwner(enemyplayer)), math.max(morale_loss, 0), true)
		end

	end
	Update_Objectives()
end

function checkCasualty(victim, killer)
	if victim ~= nil then
		if Util_GetPlayerOwner(victim) ~= nil then
			local lossInflicted = 0
			if Entity_IsOfType(victim, "kubelwagen") then lossInflicted = 15
			elseif Entity_IsOfType(victim, "officer") then lossInflicted = 30
			elseif Entity_IsOfType(victim, "production_building") then lossInflicted = 30
			elseif Entity_IsOfType(victim, "wg_flak_emplacement_buildable") then lossInflicted = 30
			elseif Entity_IsOfType(victim, "brits_bofors") then lossInflicted = 30
			elseif Entity_IsOfType(victim, "defence_building") then lossInflicted = 10
			elseif Entity_IsOfType(victim, "conscripts") then lossInflicted = 2
			elseif Entity_IsOfType(victim, "heavy_tank") then lossInflicted = 150
			elseif Entity_IsOfType(victim, "medium_tank") then lossInflicted = 80
			elseif Entity_IsOfType(victim, "armour") then lossInflicted = 50
			elseif Entity_IsOfType(victim, "halftrack") then lossInflicted = 40
			elseif Entity_IsOfType(victim, "light_vehicle") then lossInflicted = 20
			elseif Entity_IsOfType(victim, "snipers") then lossInflicted = 12
			-- elseif Entity_IsOfType(victim, "infantry_elite") then lossInflicted = 4
			elseif Entity_IsOfType(victim, "infantry") then lossInflicted = 3
			end
			local morale_loss = VPTicker_GetTeamTickers(Player_GetTeam(Util_GetPlayerOwner(victim))) - lossInflicted
			VPTicker_SetTeamTickers(Player_GetTeam(Util_GetPlayerOwner(victim)), math.max(morale_loss, 0), true)
			if killer ~= nil then
				if Util_GetPlayerOwner(killer) ~= nil then
					local morale_boost = VPTicker_GetTeamTickers(Player_GetTeam(Util_GetPlayerOwner(killer))) + math.ceil(lossInflicted/2)
					VPTicker_SetTeamTickers(Player_GetTeam(Util_GetPlayerOwner(killer)), math.min(morale_boost, VPTickerData.start_points), true)
				end
			end
			if VPTicker_GetTeamTickers(Player_GetTeam(Util_GetPlayerOwner(victim))) == 0 and g_VictoryAchieved == false then
				g_VictoryAchieved = true
				VPTicker_GameOverLose(Player_GetTeam(Util_GetPlayerOwner(victim)))
			end
		end
	end
end


--UI functions
function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end


function Init_Objectives()

	obj_Conquest = {
	
		SetupUI = function() 
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = Util_CreateLocString("Capture and hold all sectors."),
		Description = 0,
		Type = OT_Primary,
	}
	

	obj_tmr_manpower = {
		--Parent = obj_Conquest,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = Util_CreateLocString(""),
		Description = 0,
		Type = OT_Secondary,
	}


		
	Objective_Register(obj_Conquest)
	Objective_Register(obj_tmr_manpower)

end

function Update_Objectives()
	if(Game_HasLocalPlayer() == true) then
		local localplayer = Game_GetLocalPlayer()
		local localRace = Player_GetRaceName(localplayer)

		if Player_GetNumStrategicPoints(localplayer) > World_GetNumStrategicPoints()-3 then
			Objective_UpdateText(obj_Conquest, Util_CreateLocString("We've almost won. Capture the remaining sectors!"), nil, false)

		elseif Player_GetNumStrategicPoints(localplayer) > Player_GetNumStrategicPoints(Player_FindFirstEnemyPlayer(localplayer)) then
			Objective_UpdateText(obj_Conquest, Util_CreateLocString("We control more sectors than the enemy!"), nil, false)

		elseif Player_GetNumStrategicPoints(localplayer) < Player_GetNumStrategicPoints(Player_FindFirstEnemyPlayer(localplayer)) then
			Objective_UpdateText(obj_Conquest, Util_CreateLocString("The enemy controls more sectors than us!"), nil, false)
		
		elseif Player_GetNumStrategicPoints(Player_FindFirstEnemyPlayer(localplayer)) > World_GetNumStrategicPoints()-2 then
			Objective_UpdateText(obj_Conquest, Util_CreateLocString("We've almost lost. Do not let the enemy capture the last sector!"), nil, false)
		end
	end
end

----------------------Limited supplies code----------------------------

function Limited_Command()
	for i=1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
			Player_SetResource(player, RT_Command, 2)
	end
end


function Limited_Resources()
	for i=1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
			Modify_PlayerResourceRate(player, RT_Manpower, 0 )
			--Modify_PlayerResourceRate(player, RT_Munition, -Player_GetResourceRate(player, RT_Munition), MUT_Addition)
			Modify_PlayerResourceRate(player, RT_Munition, 0)
			Modify_PlayerResourceRate(player, RT_Fuel, 0)
			--Modify_PlayerResourceRate(player, RT_Fuel, 10, MUT_Addition)
			Player_SetResource(player, RT_Manpower, 1800)
			Player_SetResource(player, RT_Munition, 300)
			Player_SetResource(player, RT_Fuel, 200)
			Player_SetResource(player, RT_Command, 10)
			Player_SetPopCapOverride(player, 50)
			-- Player_AddAbility(player, ABILITY_TRANSFER_ORDERS)
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
		Objective_UpdateText(obj_tmr_manpower, Util_CreateLocString("Based on captured territory and current tickets, you will receive " .. _manpower_amount .. " manpower in " ..math.floor(Timer_GetRemaining("tmr_manpower")/60)..":"..math.floor(math.floor(Timer_GetRemaining("tmr_manpower") % 60)/10)..math.floor(Timer_GetRemaining("tmr_manpower") % 60) - math.floor(math.floor(Timer_GetRemaining("tmr_manpower") % 60)/10) * 10), nil, false)
	end
end



-----------------------------------------------------------------------
-- Register the OnInit function w/ the SCAR system
-----------------------------------------------------------------------


Scar_AddInit( Main_Conquest )
