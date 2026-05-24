import("ScarUtil.scar")
import("Fatalities/Fatalities.scar")

function WinCondition_GameOver(winningTeam, losingTeam)
	-- Set the winning team (this will fire win/loss events for each player).
	World_SetTeamWin(winningTeam)
	
	local winningPlayers = Team_GetPlayers(winningTeam)
	local losingPlayers = Team_GetPlayers(losingTeam)
	
	Fatality_Execute(winningPlayers, losingPlayers)
end

function WinCondition_Check()
	local results = {}

	-- Check every player on each team for ownership of the "annihilation_condition" entity.
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		local team = Player_GetTeam(player)
	
		results[team] = results[team] or { surrender_count = 0, annihilation_condition_count = 0 }
		
		-- If any player on a team has surrendered, that team loses.
		if Player_IsSurrendered(player) then
			results[team].surrender_count = results[team].surrender_count + 1
		end
		
		-- If at least one player on a given team owns an "annihilation_condition" entity, then that team has not yet lost.
		if Player_IsAlive(player) then
			local raceName = Player_GetRaceName(player)
			if raceName == "aef" or raceName == "soviet" then
				if Player_GetSquadCount(player) >= 1 then
					results[team].annihilation_condition_count = results[team].annihilation_condition_count + 1
				end
			else
				local entities = Player_GetEntities(player)
				for entityCount = 1, EGroup_CountSpawned(entities) do
					local entity = EGroup_GetSpawnedEntityAt(entities, entityCount)
					if Entity_IsOfType(entity, "annihilation_condition") then
						results[team].annihilation_condition_count = results[team].annihilation_condition_count + 1
						break
					end
				end
			end
		end
	end
	
	-- Check if any team has lost.
	for team,result in pairs(results) do
		if result.surrender_count > 0 or result.annihilation_condition_count == 0 then
			Rule_RemoveAll()
			
			local winningTeam = Team_GetEnemyTeam(team)
			local losingTeam = team

			WinCondition_GameOver(winningTeam, losingTeam)
		end
	end
end

local function WinCondition_Init()
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		local raceName = Player_GetRaceName(player)
		--Player_SetConstructionMenuAvailability(player, "advanced", ITEM_REMOVED)
		Player_SetPopCapOverride(player, 50)
		
		if raceName == "aef" or raceName == "soviet" then
			Modify_PlayerResourceRate(player, RT_Manpower, 0, MUT_Multiplication)
			Modify_PlayerResourceRate(player, RT_Fuel, 0, MUT_Multiplication)
		
			Player_SetResource(player, RT_Manpower, 0)
			Player_SetResource(player, RT_Munition, 1000)
			Player_SetResource(player, RT_Fuel, 0)
		else
			Modify_PlayerResourceRate(player, RT_Manpower, 0.5, MUT_Multiplication)
			
			Player_SetResource(player, RT_Manpower, 2000)
			Player_SetResource(player, RT_Munition, 200)
			Player_SetResource(player, RT_Fuel, 20)
			
			if raceName == "german" then
				Cmd_Upgrade(player, BP_GetUpgradeBlueprint("battle_phase_2"), 1, true)
				Cmd_Upgrade(player, BP_GetUpgradeBlueprint("battle_phase_3"), 1, true)
				Cmd_Upgrade(player, BP_GetUpgradeBlueprint("battle_phase_4"), 1, true)
				
				Player_AddAbility(player, BP_GetAbilityBlueprint("8fa2fab75c21418fa3061fe86e76cad9:pak40_75mm_at_gun"))
			elseif raceName == "west_german" then
				Cmd_Upgrade(player, BP_GetUpgradeBlueprint("building_1"), 1, true)
				Cmd_Upgrade(player, BP_GetUpgradeBlueprint("building_2"), 1, true)
				Cmd_Upgrade(player, BP_GetUpgradeBlueprint("building_3"), 1, true)
				Cmd_Upgrade(player, BP_GetUpgradeBlueprint("panzerschreck_unlocked"), 1, true)
				
				Player_AddAbility(player, BP_GetAbilityBlueprint("8fa2fab75c21418fa3061fe86e76cad9:raketenwerfer43_88mm_puppchen_antitank_gun"))
			end
		end
	end
	
	Rule_AddInterval(WinCondition_Check, 3)
end

Scar_AddInit(WinCondition_Init)