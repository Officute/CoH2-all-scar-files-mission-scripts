
------------------------------------------------------------------
-- /////////// External Functions
------------------------------------------------------------------
-- /// Spawner Functions (Timings, Delays, etc)

--? @shortdesc Sets spawner data for a wave manager or wave data table
--? @extdesc Specify a wave to set the delay for a specific wave
--? @args Integer/Table waveManagerTableID/waveManagerTable [, Integer waveDataTableID, Integer initialDelay , Integer staggeredSpawnDelay]
--? @result Void
function WM_SetSpawnerData(mngrIndex, wtblIndex, initialDelay, staggeredSpawnDelay)
	_waveManager_CheckManagerForEntries()
	local mngrIndex = mngrIndex or 1
	local waveManagerTable = WaveManager_GetManagerTable(mngrIndex)
	local wtblIndex = wtblIndex or WaveManager_GetWave(mngrIndex)
	
	local initialDelay = initialDelay or 0
	local staggeredSpawnDelay = staggeredSpawnDelay or 0
	
	local dataCheck = nil
	if wtblIndex == 0 then
		dataCheck = waveManagerTable
	else
		if WaveManager_CheckWaveIsValid(mngrIndex, wtblIndex) then
			dataCheck = waveManagerTable.waves[wtblIndex]
		else
			fatal("WAVE MANAGER: waveDataTableID specified in WM_SetSpawnerData not valid")
		end
	end
	
	if _waveManager_checkForComponent(mngrIndex, wtblIndex, "spawnerData") then
		dataCheck = waveManagerTable.waves[wtblIndex]
		if dataCheck.spawnerData.initialDelay ~= initialDelay then
			dataCheck.spawnerData.initialDelay = initialDelay
		end
		if dataCheck.spawnerData.staggeredSpawnDelay ~= staggeredSpawnDelay then
			dataCheck.spawnerData.staggeredSpawnDelay = staggeredSpawnDelay
		end
	else
		dataCheck.spawnerData = {}
		dataCheck.spawnerData.initialDelay = initialDelay
		dataCheck.spawnerData.staggeredSpawnDelay = staggeredSpawnDelay
	end
end

--? @shortdesc Returns the wave manager or wave data table's spawnerData table
--? @args Integer/Table waveManagerTableID/waveManagerTable[, Integer waveDataTableID]
--? @result Table spawnerTable
function WM_GetSpawnerData(mngrIndex, wtblIndex)
	_waveManager_CheckManagerForEntries()
	local mngrIndex = mngrIndex or 1
	local waveManagerTable = WaveManager_GetManagerTable(mngrIndex)
	local wtblIndex = wtblIndex or WaveManager_GetWave(mngrIndex)
	
	local data = _waveManager_getHighlevelComponentData(mngrIndex, wtblIndex, "spawnerData")
	if data ~= false then
		return data
	end
end

-- /// Randomize Functions

--? @shortdesc Sets randomzer data for a wave manager or wave data table
--? @extdesc Specify a wave to set the delay for a specific wave
--? @extdesc Booleans are set to false by default
--? @args Integer/Table waveManagerTableID/waveManagerTable [, Integer waveDataTableID, Integer randomEncounters, Boolean exclusiveSpawns, Boolean uniqueSpawns]
function WM_SetRandomizeData(mngrIndex, wtblIndex, randomEncounters, exclusive, uniqueSpawns)
	_waveManager_CheckManagerForEntries()
	local mngrIndex = mngrIndex or 1
	local waveManagerTable = WaveManager_GetManagerTable(mngrIndex)
	local wtblIndex = wtblIndex or WaveManager_GetWave(mngrIndex)
	
	local randomEncounters = randomEncounters or 0
	local exclusive = exclusive or false
	local uniqueSpawns = uniqueSpawns or false
	
	local dataCheck = nil
	if wtblIndex == 0 then
		dataCheck = waveManagerTable
	else
		if WaveManager_CheckWaveIsValid(mngrIndex, wtblIndex) then
			dataCheck = waveManagerTable.waves[wtblIndex]
		else
			fatal("WAVE MANAGER: waveDataTableID specified in WM_SetRandomizeData not valid")
		end
	end
	
	if scartype(_waveManager_checkForComponent(mngrIndex, wtblIndex, "randomizeData")) == ST_TABLE then
		dataCheck = waveManagerTable.waves[wtblIndex]
		if dataCheck.randomizeData.randomEncounters ~= randomEncounters then
			dataCheck.randomizeData.randomEncounters = randomEncounters
		end
		if dataCheck.randomizeData.exclusive ~= exclusive then
			dataCheck.randomizeData.exclusive = exclusive
		end
		if dataCheck.randomizeData.uniqueSpawns ~= uniqueSpawns then
			dataCheck.randomizeData.uniqueSpawns = uniqueSpawns
		end
	else
		dataCheck.randomizeData = {}
		dataCheck.randomizeData.randomEncounters = randomEncounters
		dataCheck.randomizeData.exclusive = exclusive
		dataCheck.randomizeData.uniqueSpawns = uniqueSpawns
	end
end

--? @shortdesc Returns the wave manager or wave data table's randomizeData table
--? @args Integer/Table waveManagerTableID/waveManagerTable[, Integer waveDataTableID]
--? @result Table randomizeTable
function WM_GetRandomizeData(mngrIndex, wtblIndex)
	_waveManager_CheckManagerForEntries()
	local mngrIndex = mngrIndex or 1
	local waveManagerTable = WaveManager_GetManagerTable(mngrIndex)
	local wtblIndex = wtblIndex or WaveManager_GetWave(mngrIndex)
	
	local data = _waveManager_getHighlevelComponentData(mngrIndex, wtblIndex, "randomizeData")
	if data ~= false then
		return data
	end
end

-- /// Callback Functions

--? @shortdesc Sets callback functions for a wave manager or wave data table
--? @extdesc Specify a wave to set the functions for a specific wave
--? @args Integer/Table waveManagerTableID/waveManagerTable [, Integer waveDataTableID, Function preSpawn, Integer preSpawnDelay, Function onSpawn , Function onComplete]
--? @result Void
function WM_SetCallbackData(mngrIndex, wtblIndex, preSpawn, preSpawn_delay, onSpawn, onComplete, onSpotted)
	_waveManager_CheckManagerForEntries()
	local mngrIndex = mngrIndex or 1
	local waveManagerTable = WaveManager_GetManagerTable(mngrIndex)
	local wtblIndex = wtblIndex or WaveManager_GetWave(mngrIndex)
	
	local preSpawn = preSpawn or nil
	local preSpawn_delay = preSpawn_delay or 0
	local onSpawn = onSpawn or nil
	local onComplete = onComplete or nil
	
	local dataCheck = nil
	if wtblIndex == 0 then
		dataCheck = waveManagerTable
	else
		if WaveManager_CheckWaveIsValid(mngrIndex, wtblIndex) then
			dataCheck = waveManager.Table.waves[wtblIndex]
		else
			fatal("WAVE MANAGER: waveDataTableID specified in WM_SetCallbackData not valid")
		end
	end
	
	if scartype(_waveManager_checkForComponent(mngrIndex, wtblIndex, "callbackData")) == ST_TABLE then
		dataCheck = waveManagerTable.waves[wtblIndex]
		if dataCheck.callbackData.preSpawn ~= preSpawn then
			dataCheck.callbackData.preSpawn = preSpawn
		end
		if dataCheck.callbackData.preSpawn_delay ~= preSpawn_delay then
			dataCheck.callbackData.preSpawn_delay = preSpawn_delay
		end
		if dataCheck.callbackData.onSpawn ~= onSpawn then
			dataCheck.callbackData.onSpawn = onSpawn
		end
		if dataCheck.callbackData.onComplete ~= onComplete then
			dataCheck.callbackData.onComplete = onComplete
		end
		if dataCheck.callbackData.onSpotted ~= onSpotted then
			dataCheck.callbackData.onSpotted = onSpotted
		end
	else
		dataCheck.callbackData = {}
		dataCheck.callbackData.preSpawn = preSpawn
		dataCheck.callbackData.preSpawn_delay = preSpawn_delay
		dataCheck.callbackData.onSpawn = onSpawn
		dataCheck.callbackData.onComplete = onComplete
		dataCheck.callbackData.onSpotted = onSpotted
	end 
end

--? @shortdesc Returns the wave manager or wave data table's callbackData table
--? @args Integer/Table waveManagerTableID/waveManagerTable[, Integer waveDataTableID]
--? @result Table callbackData
function WM_GetCallbackData(mngrIndex, wtblIndex)
	_waveManager_CheckManagerForEntries()
	local mngrIndex = mngrIndex or 1
	local waveManagerTable = WaveManager_GetManagerTable(mngrIndex)
	local wtblIndex = wtblIndex or WaveManager_GetWave(mngrIndex)
	
	local data = _waveManager_getHighlevelComponentData(mngrIndex, wtblIndex, "callbackData")
	if data ~= false then
		return data
	end
end

-- /// Rally Goal Functions

--? @shortdesc Sets rally goal data for a wave manager or wave data table
--? @extdesc Specify a wave to set the rally data for a specific wave
--? @args Integer/Table waveManagerTableID/waveManagerTable [, Integer waveDataTableID,] Table rallyGoal
--? @result Void
function WM_SetRallyGoalData(mngrIndex, wtblIndex, rallyGoal)
	_waveManager_CheckManagerForEntries()
	local mngrIndex = mngrIndex or 1
	local waveManagerTable = WaveManager_GetManagerTable(mngrIndex)
	local wtblIndex = wtblIndex or WaveManager_GetWave(mngrIndex)
	
	if scartype(rallyGoal) ~= ST_TABLE then
		fatal("WAVE MANAGER: rallyGoal is not defined or not a table in WM_SetRallyGoalData")
	end
	
	local dataCheck = nil
	if wtblIndex == 0 then
		dataCheck = waveManagerTable
	else
		if WaveManager_CheckWaveIsValid(mngrIndex, wtblIndex) then
			dataCheck = waveManager.Table.waves[wtblIndex]
		else
			fatal("WAVE MANAGER: waveDataTableID specified in WM_SetRallyGoalData not valid")
		end
	end
	
	dataCheck.rallyGoalData = rallyGoal
end

--? @shortdesc Returns the wave manager or wave data table's rallyGoalData table
--? @args Integer/Table waveManagerTableID/waveManagerTable[, Integer waveDataTableID]
--? @result Table callbackData
function WM_GetRallyGoalData(mngrIndex, wtblIndex)
	_waveManager_CheckManagerForEntries()
	local mngrIndex = mngrIndex or 1
	local waveManagerTable = WaveManager_GetManagerTable(mngrIndex)
	local wtblIndex = wtblIndex or WaveManager_GetWave(mngrIndex)
	
	local data = _waveManager_getHighlevelComponentData(mngrIndex, wtblIndex, "rallyGoalData")
	if data ~= false then
		return data
	end
end

-- /// Sustained Attack Functions

--? @shortdesc Sets Sustained Attack for a wave manager or wave data table
--? @extdesc Specify a wave to set the functions for a specific wave
--? @args Integer/Table waveManagerTableID/waveManagerTable [, Integer waveDataTableID, Integer newSpawnThreshold, Integer newSpawnWait]
--? @result Void
function WM_SetSustainedAttackData(mngrIndex, wtblIndex, newSpawnThreshold, newSpawnWait)
	_waveManager_CheckManagerForEntries()
	local mngrIndex = mngrIndex or 1
	local waveManagerTable = WaveManager_GetManagerTable(mngrIndex)
	local wtblIndex = wtblIndex or WaveManager_GetWave(mngrIndex)
	
	local newSpawnThreshold = newSpawnThreshold or 0
	local newSpawnWait = newSpawnWait or 0
	
	local dataCheck = nil
	if wtblIndex == 0 then
		dataCheck = waveManagerTable
	else
		if WaveManager_CheckWaveIsValid(mngrIndex, wtblIndex) then
			dataCheck = waveManager.Table.waves[wtblIndex]
		else
			fatal("WAVE MANAGER: waveDataTableID specified in WM_SetCallbackData not valid")
		end
	end
	
	if scartype(_waveManager_checkForComponent(mngrIndex, wtblIndex, "sustainedAttackData")) == ST_TABLE then
		dataCheck = waveManagerTable.waves[wtblIndex]
		if dataCheck.sustainedAttackData.newSpawnThreshold ~= newSpawnThreshold then
			dataCheck.sustainedAttackData.newSpawnThreshold = newSpawnThreshold
		end
		if dataCheck.sustainedAttackData.newSpawnWait ~= newSpawnWait then
			dataCheck.sustainedAttackData.newSpawnWait = newSpawnWait
		end
	else
		dataCheck.sustainedAttackData = {}
		dataCheck.sustainedAttackData.newSpawnThreshold = newSpawnThreshold
		dataCheck.sustainedAttackData.newSpawnWait = newSpawnWait
	end 
end

--? @shortdesc Returns the wave manager or wave data table's Sustained Attack table
--? @args Integer/Table waveManagerTableID/waveManagerTable[, Integer waveDataTableID]
--? @result Table callbackData
function WM_GetSustainedAttackData(mngrIndex, wtblIndex)
	_waveManager_CheckManagerForEntries()
	local mngrIndex = mngrIndex or 1
	local waveManagerTable = WaveManager_GetManagerTable(mngrIndex)
	local wtblIndex = wtblIndex or WaveManager_GetWave(mngrIndex)
	
	local data = _waveManager_getHighlevelComponentData(mngrIndex, wtblIndex, "sustainedAttackData")
	if data ~= false then
		return data
	end
end

-- /// Horde Attack Functions

--? @shortdesc Sets Horde Attack for a wave manager or wave data table
--? @extdesc Specify a wave to set the functions for a specific wave
--? @args Integer/Table waveManagerTableID/waveManagerTable [, Integer waveDataTableID, Integer interval, Integer squadCap]
--? @result Void
function WM_SetHordeAttackData(mngrIndex, wtblIndex, interval, squadCap)
	_waveManager_CheckManagerForEntries()
	local mngrIndex = mngrIndex or 1
	local waveManagerTable = WaveManager_GetManagerTable(mngrIndex)
	local wtblIndex = wtblIndex or WaveManager_GetWave(mngrIndex)
	
	local interval = interval or 0
	local squadCap = squadCap or 0
	
	local dataCheck = nil
	if wtblIndex == 0 then
		dataCheck = waveManagerTable
	else
		if WaveManager_CheckWaveIsValid(mngrIndex, wtblIndex) then
			dataCheck = waveManager.Table.waves[wtblIndex]
		else
			fatal("WAVE MANAGER: waveDataTableID specified in WM_SetHordeAttackData not valid")
		end
	end
	
	if scartype(_waveManager_checkForComponent(mngrIndex, wtblIndex, "hordeAttackData")) == ST_TABLE then
		dataCheck = waveManagerTable.waves[wtblIndex]
		if dataCheck.hordeAttackData.interval ~= interval then
			dataCheck.hordeAttackData.interval = interval
		end
		if dataCheck.hordeAttackData.squadCap ~= squadCap then
			dataCheck.hordeAttackData.squadCap = squadCap
		end
	else
		dataCheck.hordeAttackData = {}
		dataCheck.hordeAttackData.interval = interval
		dataCheck.hordeAttackData.squadCap = squadCap
	end
end

--? @shortdesc Returns the wave manager or wave data table's Horde Attack table
--? @args Integer/Table waveManagerTableID/waveManagerTable[, Integer waveDataTableID]
--? @result Table callbackData
function WM_GetHordeAttackData(mngrIndex, wtblIndex)
	_waveManager_CheckManagerForEntries()
	local mngrIndex = mngrIndex or 1
	local waveManagerTable = WaveManager_GetManagerTable(mngrIndex)
	local wtblIndex = wtblIndex or WaveManager_GetWave(mngrIndex)
	
	local data = _waveManager_getHighlevelComponentData(mngrIndex, wtblIndex, "hordeAttackData")
	if data ~= false then
		return data
	end
end

-- /// Wave Warning Functions
--[[
	waveWarningData = {
		useObjective = true,
		
		objectiveID = nil,
		warningBlip = BT_General,
		warningBlipTime = 3,
		
		warningLevel = WARN_HIGH,
		warningLevelData = {
			WAVE_INFANTRY = LOC("Incoming Infantry"),
			WAVE_VEHICLES = LOC("Incoming Vehicles"),
			WAVE_MIXED = LOC("Incoming Forces"),
		},
	}
]]
--? @shortdesc Sets Wave Warning for a wave manager or wave data table
--? @extdesc Specify a wave to set the functions for a specific wave
--? @args Integer/Table waveManagerTableID/waveManagerTable[, Integer waveDataTableID], Boolean useObjective[, ObjectiveID objectiveID, Integer warningBlip, Integer warningBlipTime, Integer warningLevel
--? @result Void
function WM_SetWaveWarningData(mngrIndex, wtblIndex, useObjective, objectiveID, warningBlip, warningBlipTime, warningLevel)
	_waveManager_CheckManagerForEntries()
	local mngrIndex = mngrIndex or 1
	local waveManagerTable = WaveManager_GetManagerTable(mngrIndex)
	local wtblIndex = wtblIndex or WaveManager_GetWave(mngrIndex)
	
	local objectiveID = objectiveID or nil
	local warningBlip = warningBlip or BT_General
	local warningBlipTime = warningBlipTime or 2
	local warningLevel = warningLevel or WARN_LOW
	
	if useObjective then
		if scartype(objectiveID) == ST_NIL then
			fatal("WAVE MANAGER: Objective ID specificed in WaveWarningData not valid or nil")
		end
	end
	
	if scartype(_waveManager_checkForComponent(mngrIndex, wtblIndex, "waveWarningData")) == ST_TABLE then
		dataCheck = waveManagerTable.waves[wtblIndex]
		if dataCheck.waveWarningData.useObjective ~= useObjective then
			dataCheck.waveWarningData.useObjective = useObjective
		end
		if dataCheck.waveWarningData.objectiveID ~= objectiveID then
			dataCheck.waveWarningData.objectiveID = objectiveID
		end
		if dataCheck.waveWarningData.warningBlip ~= warningBlip then
			dataCheck.waveWarningData.warningBlip = warningBlip
		end
		if dataCheck.waveWarningData.warningBlipTime ~= warningBlipTime then
			dataCheck.waveWarningData.warningBlipTime = warningBlipTime
		end
		if dataCheck.waveWarningData.warningLevel ~= warningLevel then
			dataCheck.waveWarningData.warningLevel = warningLevel
		end
	else
		dataCheck.hordeAttackData = {}
		dataCheck.waveWarningData.useObjective = useObjective
		dataCheck.waveWarningData.objectiveID = objectiveID
		dataCheck.waveWarningData.warningBlip = warningBlip
		dataCheck.waveWarningData.warningBlipTime = warningBlipTime
		dataCheck.waveWarningData.warningLevel = warningLevel
	end
end

--? @shortdesc Returns the wave manager or wave data table's Wave Warning table
--? @args Integer/Table waveManagerTableID/waveManagerTable[, Integer waveDataTableID]
--? @result Table callbackData
function WM_GetWaveWarningData(mngrIndex, wtblIndex)
	_waveManager_CheckManagerForEntries()
	local mngrIndex = mngrIndex or 1
	local waveManagerTable = WaveManager_GetManagerTable(mngrIndex)
	local wtblIndex = wtblIndex or WaveManager_GetWave(mngrIndex)
	
	local data = _waveManager_getHighlevelComponentData(mngrIndex, wtblIndex, "waveWarningData")
	if data ~= false then
		return data
	end
end

------------------------------------------------------------------
-- /////////// Internal Functions
------------------------------------------------------------------
-- /// Rally Goal Functions

-- Sets up rally point data
function _WM_SetupRallyPointData(rallyGoalData, target)
	local rallyData = Table_Copy(rallyGoalData)
	if(target ~= nil) then
		rallyData.target = target
	end
	rallyData.onSuccess = _WM_RallyPointSuccess
	
	return rallyData
end

-- Assigns the main goal once rally point is reached
function _WM_RallyPointSuccess(encounterID)
	WMPrint("WAVE MANAGER: Rally Point reached")
	local newGoal = encounterID.data.storedGoal
	encounterID:SetGoal(newGoal)
end

-- /// Sustained Attack Functions

function _WM_setSustainedAttack(mngrIndex, sustainedAttackRef, encounterID, eventID)
	local newSpawnThreshold = sustainedAttackRef.newSpawnThreshold or 0
	local newSpawnWait = sustainedAttackRef.newSpawnWait or 0
	local mngrIndex = mngrIndex or 1
	
	local event = nil
	local sgroup = encounterID:GetSgroup()
	local totalUnits = SGroup_TotalMembersCount(sgroup, true)
	local eventID = eventID or __WM_eventID
	
	-- TODO: doing this with newSpawnWait > 0 causes issues.
	-- Need to be able to count the total number of units in an Encounter
	-- Or delay this until the encounter is fully spawned
	if totalUnits <= newSpawnThreshold then
		event = Event_GroupIsDead(_WM_sustainedAttack_respawn, {_eventID = event, _encounterID = encounterID, _mngrIndex = mngrIndex}, sgroup, newSpawnWait)
	else
		event = Event_GroupLeftAlive(_WM_sustainedAttack_respawn, {_eventID = event, _encounterID = encounterID, _mngrIndex = mngrIndex}, sgroup, newSpawnThreshold, newSpawnWait)
	end
	
	return event
end

-- Respawns a Sustained Attack Wave
function _WM_sustainedAttack_respawn(dataInt)
	WMPrint("WAVE MANAGER: Respawning a Sustained Attack")
	
	Event_Remove(dataInt.__eventID)
	
	local mngrIndex = dataInt._mngrIndex or 1
	local waveManagerTable = WaveManager_GetManagerTable(mngrIndex)
	local currWave = WaveManager_GetWave(mngrIndex)
	local waveDataTable = WaveManager_GetWaveDataTable(mngrIndex, currWave)
	
	if waveManagerTable.waveManagerInternal.state == WAVE_STOPPED then
		return
	end
	
	local sustainedAttackData = WM_GetSustainedAttackData(mngrIndex, currWave)
--~ 	local wave_encountersData = waveManagerTable.waveManagerInternal.wave_encounters
	local randomizeData = WM_GetRandomizeData(mngrIndex, currWave)
	local events = WaveManager_GetEventsTable(mngrIndex)
	
	local eventID = dataInt._eventID
	local encounterID = dataInt._encounterID
	local encData = encounterID.data
	
	if scartype(sustainedAttackData.maxEncounters) ~= ST_NIL then
		if (mngrIndex) > sustainedAttackData.maxEncounters then
			return
		end
	end
	
	-- Clear up the events
	for i = table.getn(events), 1, -1 do
		if Event_Exists(event[i]) == false then
			table.remove(events, i)
		end
	end
	
	if encData.rare ~= true then
		local units = encounterID.data.units
		-- shuffle back into the sustained attack table
		-- Just to make it easier, we'll always shuffle it back in.
		local t = {}
		t.weight = encData.weight or nil
		t.units = encData.units
		t.direction = encData.direction
		t.player = encData.player or nil
		t.sgroups = encData.sgroups or nil
		
		table.insert(waveManagerTable.waveManagerInternal.allEncounterData, t)
		for k,v in pairs(waveManagerTable.waveManagerInternal.waveEncounters) do
			if v.data.eventID == eventID then
				table.remove(waveManagerTable.waveManagerInternal.waveEncounters, k)
			end
		end
	end
	_waveManager_selectSpawns_Internal(mngrIndex, 1, true)

end


-- /// Wave Warning Functions
function _WM_MarkHintPoint()
	
end

