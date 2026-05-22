

-- Difficulty Level functions
function XP1_DifficultyLevel_Init(difficultyLevel)

	__xp1DifficultyLevel = {}
	
	__xp1DifficultyLevel.NodeStrength = {}
	
	WEST_GERMAN_MINE = EBP.GERMAN.MINE_FIELD_MINE
	AEF_MINE = EBP.GERMAN.MINE_FIELD_MINE
	
	__g_NodeStrength = 1
	__g_localPlayer = Game_GetLocalPlayer()
	__g_localTeam = Player_GetTeam(__g_localPlayer)
	__g_difficulty = Game_GetSPDifficulty()
	__g_cpu = nil
	for i = 1, World_GetPlayerCount() do
		if World_GetPlayerAt(i) ~= __g_localPlayer then
			__g_cpu = World_GetPlayerAt(i)
		end
	end
	
	------------------------------------------------------------
	-- NODE STRENGTH                                           |
	
	-- Variables	
	PM_PL_StartingVP = false
	PM_PL_StartingResourceHit = false
	PM_PL_Defenses = false
	
	PM_AI_CPDefenses = false
	PM_AI_Aggression = false
	PM_AI_Defensiveness = false
	PM_AI_BaseDefenses = false
	
	-- Defense tables
	PM_PL_StartingVP_ID = 1
	PM_AI_CPDefenses_ID = 2
	PM_PL_StartingResourceHit_ID = 3
	PM_AI_Aggression_ID = 4
	PM_AI_Defensiveness_ID = 5
	PM_AI_BaseDefenses_ID = 6
	PM_PL_Defenses_ID = 7
	
	__g_NodeStrength = difficultyLevel
		
	-- VP Tickers
	__xp1DifficultyLevel.NodeStrength[1] = {
		0, 20, 50, 75, 100,			-- Starting VP hit for players
	}
	
	-- VP Defenses for AI
	LAYER_cp_defense_1 = EGroup_CreateIfNotFound("LAYER_cp_defense_1")
	LAYER_cp_defense_2 = EGroup_CreateIfNotFound("LAYER_cp_defense_2")
	LAYER_cp_defense_3 = EGroup_CreateIfNotFound("LAYER_cp_defense_3")
	LAYER_cp_defense_4 = EGroup_CreateIfNotFound("LAYER_cp_defense_4")
	LAYER_cp_defense_5 = EGroup_CreateIfNotFound("LAYER_cp_defense_5")
	
	__xp1DifficultyLevel.cpDefenses_Alt = false
	
	__xp1DifficultyLevel.NodeStrength[2] = {
		layers = {
			LAYER_cp_defense_1, LAYER_cp_defense_2, LAYER_cp_defense_3, LAYER_cp_defense_4, LAYER_cp_defense_5,
		},
		encounters = {
			{}, {}, {}, {}, {},
		},
	}
	
	-- Starting Resource Hit for Players
	__xp1DifficultyLevel.NodeStrength[3] = {
		manpower = {0, 20, 40, 60, 100},
		munitions = {0, 5, 10, 15, 25},
		fuel = {0, 0, 2, 5, 10},
	}
	
	-- AI Aggression
	__xp1DifficultyLevel.NodeStrength[4] = {
		-- Implemented later
	}
	
	-- AI Defensiveness
	__xp1DifficultyLevel.NodeStrength[5] = {
		-- Implemented later
	}
	
	-- Base Defenses for AI
	LAYER_base_defense_1 = EGroup_CreateIfNotFound("LAYER_base_defense_1")
	LAYER_base_defense_2 = EGroup_CreateIfNotFound("LAYER_base_defense_2")
	LAYER_base_defense_3 = EGroup_CreateIfNotFound("LAYER_base_defense_3")
	LAYER_base_defense_4 = EGroup_CreateIfNotFound("LAYER_base_defense_4")
	LAYER_base_defense_5 = EGroup_CreateIfNotFound("LAYER_base_defense_5")
	__xp1DifficultyLevel.NodeStrength[6] = {
		layers = {
			LAYER_base_defense_1, LAYER_base_defense_2, LAYER_base_defense_3, LAYER_base_defense_4, LAYER_base_defense_5,
		},
		encounters = {
			{},	{},	{},	{},	{},
		},
	}
	
	-- Defenses for Player
	LAYER_player_defense_1 = EGroup_CreateIfNotFound("LAYER_player_defense_1")
	LAYER_player_defense_2 = EGroup_CreateIfNotFound("LAYER_player_defense_2")
	LAYER_player_defense_3 = EGroup_CreateIfNotFound("LAYER_player_defense_3")
	LAYER_player_defense_4 = EGroup_CreateIfNotFound("LAYER_player_defense_4")
	LAYER_player_defense_5 = EGroup_CreateIfNotFound("LAYER_player_defense_5")
	__xp1DifficultyLevel.NodeStrength[7] = {
		layers = {
			LAYER_player_defense_1, LAYER_player_defense_2, LAYER_player_defense_3, LAYER_player_defense_4, LAYER_player_defense_5,
		},
		units = {
			{}, {}, {}, {}, {},
		},
	}
	
	Rule_AddOneShot(_NODE_Kickoff, 1)
	
	------------------------------------------------------------
	-- DIFFICULTY LEVEL                                        |
	_DIFF_TacticsTuning()
	_DIFF_SetStartingResource()
	
	if Misc_IsCommandLineOptionSet("NODE_STRENGTH_1") then
		__g_NodeStrength = 1
	elseif Misc_IsCommandLineOptionSet("NODE_STRENGTH_2") then
		__g_NodeStrength = 2
	elseif Misc_IsCommandLineOptionSet("NODE_STRENGTH_3") then
		__g_NodeStrength = 3
	elseif Misc_IsCommandLineOptionSet("NODE_STRENGTH_4") then
		__g_NodeStrength = 4
	elseif Misc_IsCommandLineOptionSet("NODE_STRENGTH_5") then
		__g_NodeStrength = 5
	end
end



-- Difficulty Levels
-- Sets the base tactics tuning for encounters
function _DIFF_TacticsTuning()
	
	-- TODO
	
end

-- Sets the player's starting resources based on difficulty levels
function _DIFF_SetStartingResource()
	
	if g_missionData.missionType == MT_XP1_BATTLE then
		local manpower = Util_DifVar({500, 400, 350})
		local munitions = Util_DifVar({50, 40, 20})
		local fuel = Util_DifVar({15, 10, 5})
		
		Player_SetResource(__g_localPlayer, RT_Manpower, manpower)
		Player_SetResource(__g_localPlayer, RT_Munition, munitions)
		Player_SetResource(__g_localPlayer, RT_Fuel, fuel)
		
		--Change difficulty to a lesser one by default.
		AI_SetDifficulty(Game_GetLocalPlayer(), math.max(Game_GetSPDifficulty()-1, 0))
	end

end

-- Node Strength
-- Kickoff function has to be called on delay to account for mission parameters passed
function _NODE_Kickoff()
	if PM_PL_StartingVP then Rule_AddInterval(_NODE_playerStartVP, 0.5) end
	if PM_PL_StartingResourceHit then _NODE_playerStartResourceHit() end
	if PM_PL_Defenses then _NODE_playerDefenses() end
	
	if PM_AI_CPDefenses then _NODE_aiCPDefenses() end
	if PM_AI_Aggression then _NODE_aiAggression() end
	if PM_AI_Defensiveness then _NODE_aiDefensiveness() end
	if PM_AI_BaseDefenses then _NODE_aiBaseDefenses() end
	
end

--------------------////////////////////////////////////
-- EXTERNAL FUNCTIONS

-- Used for spawning items for the enemy ai
-- Pass in a table containing five layers
-- Works like CPDefense
function XP1_NODE_customAISpawner(layers)
	for i = 2, table.getn(layers) do
		if i > __g_NodeStrength +1 then
			EGroup_DeSpawn(layers[i])
		else
			local _setMines = function(gid, idx, eid)
				if Entity_GetBlueprint(eid) == WEST_GERMAN_MINE then
					Entity_SetPlayerOwner(eid, __g_cpu)
				end
			end
			EGroup_ForEach(layers[i], _setMines)
		end
	end
end

-- Used for spawning items for the enemy ai
-- Pass in a table containing five layers
-- Works like CPDefense
function XP1_NODE_customPlayerSpawner(layers)
	for i = 1, table.getn(layers) do
		EGroup_DeSpawn(layers[i])
	end
	for i = table.getn(layers), 1, -1 do
		if i > __g_NodeStrength then
			EGroup_ReSpawn(layers[i])
			local _setMines = function(gid, idx, eid)
				if Entity_GetBlueprint(eid) == AEF_MINE then
					Entity_SetPlayerOwner(eid, __g_localPlayer)
				end
			end
			EGroup_ForEach(layers[i], _setMines)
		end
	end
end

-- Adds Encounter tables for various node strength tuning
-- Allows designers to add any number of encounters to spawn at particular node strengths
function Register_Node_Encounter(difficultyNode, difficultyLevel, encounterID)
	if difficultyNode == PM_AI_CPDefenses_ID then
		table.insert(__xp1DifficultyLevel.NodeStrength[2].encounters[difficultyLevel], encounterID)
	elseif difficultyNode == PM_AI_BaseDefenses_ID then
		table.insert(__xp1DifficultyLevel.NodeStrength[6].encounters[difficultyLevel], encounterID)
	else
		fatal("XP1 DIFFICULTY: Invalid difficultyNode type entered.")
	end
end

-- Adds Unit tables for the player defense encounter 
function Register_Node_Units(difficultyNode, difficultyLevel, unitTable)
	if difficultyNode == PM_PL_Defenses_ID then
		table.insert(__xp1DifficultyLevel.NodeStrength[7].units[difficultyLevel], unitTable)
	else
		fatal("XP1 DIFFICULTY: Invalid difficultyNode type entered.")
	end
end

--? @group scardoc;XP1

--? @shortdesc Returns the current node strength
--? @result Int[1,5]
function XP1_GetNodeStrength()
	return __g_NodeStrength
end

--? @shortdesc Takes in a table and chooses the right variable for the current node strength setting. 1-5 elements. 
--? @args Table nodeDifficultyVariables
--? @result Variable
function XP1_NodeDif(vars)
	if scartype(vars) == ST_TABLE and table.getn(vars) == 5 then
		if scartype(XP1_GetNodeStrength()) == ST_NUMBER then
			return vars[XP1_GetNodeStrength()]
		end
	else
		fatal("XP1 DIFFICULTY: XP1_NodeDif parameter is either not a table, or has more or less than 5 entries")
	end
end

--~ XP1_NodeDif({1, 2, 3, 4, 5})

--------------------////////////////////////////////////
-- INTERNAL FUNCTIONS

-- Reduces the player's starting VP tickers
function _NODE_playerStartVP()
	if VPTickerData ~= nil then
		Rule_RemoveMe()
		local vpHit = __xp1DifficultyLevel.NodeStrength[1][XP1_GetNodeStrength()]
		
		VPTicker_SetTeamTickers( 1, (VPTicker_GetTeamTickers(1)-vpHit), false )
	end
	
end

-- Reduces the player's starting Resources
function _NODE_playerStartResourceHit()
	
	local currManpower = Player_GetResource(__g_localPlayer, RT_Manpower)
	local manpowerHit = __xp1DifficultyLevel.NodeStrength[3].manpower[XP1_GetNodeStrength()]
	
	Player_SetResource(__g_localPlayer, RT_Manpower, (currManpower-manpowerHit))
	
	local currMunition = Player_GetResource(__g_localPlayer, RT_Munition)
	local munitionHit = __xp1DifficultyLevel.NodeStrength[3].munitions[XP1_GetNodeStrength()]
	
	Player_SetResource(__g_localPlayer, RT_Munition, (currMunition-munitionHit))
	
	local currFuel = Player_GetResource(__g_localPlayer, RT_Fuel)
	local fuelHit = __xp1DifficultyLevel.NodeStrength[3].fuel[XP1_GetNodeStrength()]
	
	Player_SetResource(__g_localPlayer, RT_Fuel, (currFuel-fuelHit))

end


-- process the PM_AI_CPDefenses option: sets the level of defenses around AI control points
function _NODE_aiCPDefenses()

	-- go through each of the layers in the table (each entry corresponds to a node strength level) and despawn all layers OVER the current node strength
	-- [2] appears to be the magic table index where the egroups associated with this are stored
	for i = 1, table.getn(__xp1DifficultyLevel.NodeStrength[2].layers) do
		
		local layer = __xp1DifficultyLevel.NodeStrength[2].layers[i]
		
		if scartype(layer) == ST_EGROUP then
			
			if i > __g_NodeStrength then
				
				-- layer is ABOVE our threshold, so despawn it
				EGroup_DeSpawn(layer)
				
			else
				
				-- layer is BELOW (or at) our threshold, so keep it around
				-- BUT check all the mines in this layer are owned by the enemy
				local layer_copy = EGroup_Create("")
				EGroup_AddEGroup(layer_copy, layer)
				EGroup_Filter(layer_copy, WEST_GERMAN_MINE, FILTER_KEEP)
				EGroup_SetPlayerOwner(layer_copy, __g_cpu)
				EGroup_Destroy(layer_copy)	-- destroy means "dealloc"
				
			end
		end
	end
	
	local encounterTable = __xp1DifficultyLevel.NodeStrength[2].encounters[XP1_GetNodeStrength()]
	if table.getn(encounterTable) > 0 then
		for i = 1, table.getn(encounterTable) do
			encounterTable[i]()
		end
	end
	
end


-- process the PM_AI_BaseDefenses option: sets the level of defenses around AI Bases
function _NODE_aiBaseDefenses()
	
	-- go through each of the layers in the table (each entry corresponds to a node strength level) and despawn all layers OVER the current node strength
	-- [6] appears to be the magic number where the egroups associated with this are stored
	for i = 1, table.getn(__xp1DifficultyLevel.NodeStrength[6].layers) do
		
		local layer = __xp1DifficultyLevel.NodeStrength[6].layers[i]
		
		if scartype(layer) == ST_EGROUP then
			
			if i > __g_NodeStrength then
				
				-- layer is ABOVE our threshold, so despawn it
				EGroup_DeSpawn(layer)
				
			else
				
				-- layer is BELOW (or at) our threshold, so keep it around
				-- BUT check all the mines in this layer are owned by the enemy
				local layer_copy = EGroup_Create("")
				EGroup_AddEGroup(layer_copy, layer)
				EGroup_Filter(layer_copy, WEST_GERMAN_MINE, FILTER_KEEP)
				EGroup_SetPlayerOwner(layer_copy, __g_cpu)
				EGroup_Destroy(layer_copy)	-- destroy means "dealloc"
				
			end
		end
	end
	
	local encounterTable = __xp1DifficultyLevel.NodeStrength[6].encounters[XP1_GetNodeStrength()]
	if table.getn(encounterTable) > 0 then
		for i = 1, table.getn(encounterTable) do
			encounterTable[i]()
		end
	end
	
end

-- Sets the AI's Aggressiveness
function _NODE_aiAggression()

end

-- Sets the AI's defensiveness
function _NODE_aiDefensiveness()

end

-- Sets Player Defenses
function _NODE_playerDefenses()
	for i = 1, table.getn(__xp1DifficultyLevel.NodeStrength[7]) do
		if scartype(__xp1DifficultyLevel.NodeStrength[7].layers[i]) == ST_EGROUP then
			EGroup_DeSpawn(__xp1DifficultyLevel.NodeStrength[7][i])
		end
	end
	for i = table.getn(__xp1DifficultyLevel.NodeStrength[7]), 1, -1 do
		if scartype(__xp1DifficultyLevel.NodeStrength[7].layers[i]) == ST_EGROUP then
			if i > __g_NodeStrength then
				EGroup_ReSpawn(__xp1DifficultyLevel.NodeStrength[7][i])
				local _setMines = function(gid, idx, eid)
					if Entity_GetBlueprint(eid) == AEF_MINE then
						Entity_SetPlayerOwner(eid, __g_localPlayer)
					end
				end
				EGroup_ForEach(__xp1DifficultyLevel.NodeStrength[7][i], _setMines)
			end
		end
	end
	
	local unitTable = __xp1DifficultyLevel.NodeStrength[7].units[XP1_GetNodeStrength()]
	if table.getn(unitTable) > 0 then
		for i = 1, table.getn(unitTable) do
			for k,v in pairs(unitTable[i]) do
				Util_CreateSquads(player1, nil, v.sbp, v.spawn)
			end
		end
	end
	
end

