local teamResources = { }

local PrepManager = function()
	for i=1, World_GetPlayerCount() do
		local team = Player_GetTeam(World_GetPlayerAt(i))
		if not (teamResources[team]) then
			teamResources[team] = { 
				popModifiers = { },
				tech = { },
				munition = { },
				importantEntities = {
					["strategic_node"] = 0,
					["strategic_node_fuel"] = 0,
					["strategic_node_munitions"] = 0,
					["hq"] = 0,
				},
			}
		end
		teamResources[team].popModifiers[i] = { }
		teamResources[team].tech[i] = 0
		teamResources[team].munition[i] = 0
	end
	
end

local ResetResources = function()
	for k, v in pairs(teamResources) do
		for key, value in pairs(v.importantEntities) do
			v.importantEntities[key] = 0
		end
	end
end

local CollectResources = function()
	ResetResources()
	
	for i=1, World_GetPlayerCount() do
		
		local player = World_GetPlayerAt(i)
		local playerid = Player_GetID(player)
		local team = Player_GetTeam(player)
		local egroup = Player_GetEntities(player)
		for i=1, EGroup_CountSpawned(egroup) do
			local entity = EGroup_GetSpawnedEntityAt(egroup, i)
			local entityid = Entity_GetGameID(entity)
			for k, v in pairs(teamResources[team].importantEntities) do
				if (Entity_IsOfType(entity, k)) --[[ and (World_IsInSupply(player, Util_GetPosition(entity))) ]] then
					teamResources[team].importantEntities[k] = v + 1
				end
			end
		end
	end
end



local EconomyManager = function()
	CollectResources()
	local gameOver = { }
	for i=1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		local team = Player_GetTeam(player)
		local path = teamResources[team].importantEntities
		local totalPopEntities = path["strategic_node"]
		local numModifiers = #teamResources[team].popModifiers[i]
		
		if (numModifiers ~= totalPopEntities) then
			if (numModifiers < totalPopEntities) then
				for modi=numModifiers+1, totalPopEntities do
					local pop = 50
					local income = -0.0208333
					local numModifiers = #teamResources[team].popModifiers[i]
					if (numModifiers == 0) then
						pop = 200
						income = 0
					elseif (numModifiers < 3) then
						pop = 150
					elseif (numModifiers > 10) then
						income = 0
					end
					
					table.insert( teamResources[team].popModifiers[i], { 
--~ 						Util_ApplyModifier(
--~ 							player, 
--~ 							"player_cap_manpower_modifier", 
--~ 							pop, 
--~ 							MUT_Addition
--~ 						),
						Util_ApplyModifier(
							player, 
							"income_manpower_player_modifier", 
							income, 
							MUT_Addition
						),
					})
				end
			else
				for modi=totalPopEntities+1, numModifiers do
					local modifiers = teamResources[team].popModifiers[i][#teamResources[team].popModifiers[i]]
					for k, v in pairs(modifiers) do
						Modifier_Remove(v)
					end
					table.remove(teamResources[team].popModifiers[i])
				end
			end
		end
		
		local totalTechEntities = path["strategic_node_fuel"]
		local numTech = teamResources[team].tech[i]
		if (numTech ~= totalTechEntities) then
			if (numTech < totalTechEntities) then
				for itech=numTech+1, totalTechEntities do
					local tech = techList[itech]
					teamResources[team].tech[i] = itech
					if (tech) then
						Command_PlayerUpgrade(player, tech, true, false)
						Player_AddResource(player, RT_Fuel, 1)
					end
				end
			else
				for itech=numTech, totalTechEntities+1, -1 do
					local tech = techList[itech]
					teamResources[team].tech[i] = itech-1
					if (tech) then
						Player_RemoveUpgrade(player, tech)
						Player_AddResource(player, RT_Fuel, -1)
					end
				end
			end
		end
		
		local totalMunitionEntities = path["strategic_node_munitions"]
		local numMunition = teamResources[team].munition[i]
		if (numMunition ~= totalMunitionEntities) then
			if (numMunition < totalMunitionEntities) then
				for itech=numMunition+1, totalMunitionEntities do
					local munition = munitionList[itech]
					teamResources[team].munition[i] = itech
					if (munition) then
						Command_PlayerUpgrade(player, munition, true, false)
						Player_AddResource(player, RT_Munition, 1)
					end
				end
			else
				for itech=numMunition, totalMunitionEntities+1, -1 do
					local munition = munitionList[itech]
					teamResources[team].munition[i] = itech-1
					if (munition) then
						Player_RemoveUpgrade(player, munition)
						Player_AddResource(player, RT_Munition, -1)
					end
				end
			end
		end
		
		if not (isCampaign) then
			local hqs = path["strategic_node"]
			if (hqs == 0) then
				gameOver[team] = gameOver[team] or 0
				local sgroup = Player_GetSquads(player)
				for i=1, SGroup_CountSpawned(sgroup) do
					local squad = SGroup_GetSpawnedSquadAt(sgroup, i)
					local blueprint = BP_GetName(Squad_GetBlueprint(squad))
					if (blueprint == "command_squad") then
						gameOver[team] = gameOver[team] + 1
						break
					end
				end
			end
		end
	end
	
	for k, v in pairs(gameOver) do
		if (v == 0) then
			World_SetTeamWin( Team_GetEnemyTeam( k ) )
		end
	end
end

local OnInit = function()
	PrepManager()
	Rule_Add(EconomyManager)
end

function DebugEconomy()
	Util_PrintObject(teamResources)
end
