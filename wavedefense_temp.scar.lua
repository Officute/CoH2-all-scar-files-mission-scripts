
--[[ DEFAULT DATA
	__t_waveDefenseData = {
		-- THE FOLLOWING DATA MUST BE DEFINED BY THE SCRIPTER --		
		t_waves = {	-- Contains wave data, suggest you add to this elsewhere
			ENCOUNTERS.wave01(),
		},		
		
		t_attackDirs = {			-- Contains all possible attack direction data. Each chunk is for a different direction
			{						-- spawn = The spawn point, dynSpawn = Dynamic spawn target, ui = location for hintpoints, target = target for goal
				{spawn = mkr_attack_northEast_spawn, dynSpawn = mkr_attack_ui_northEast, ui = mkr_attack_ui_northEast, target = mkr_attack_northCapture, rallyPoint = mkr_rallyPoint},
			},
		},	
		
		t_retreatDirs = {RETREAT_MARKER_DATA},
		
		waveCompleteCondition = {
			condition = CONDITION_UNITS_LEFT,
			variable = 5,
			wave_retreats = true,
		},
		
		-- Optional Data	
		parentObj = OBJ_DefendTheBridge,		-- The main objective
		currentWaveObj = SOBJ_CurrWave,			-- Objective for "Defend against Current Wave"
		nextWaveObj = SOBJ_NextWave,			-- Objective for "Next Wave in"
		
		waveComplete_func = nil,			-- Function to call at the start of an intermission
		waveSpawn_func = nil,				-- Function to call when the wave Spawns
		
		warningLevel_data = {
			warningLevel = WARNING_HIGH,				-- WARNING_NONE, WARNING_LOW, WARNING_HIGH is amount of warning the player gets for each attack direction
			warningLow = LOC("Attack Incoming"),		-- Customize warning text for WARNING_LOW
			warningHigh = {							-- Customize warning text for WARNING_HIGH
				{warning = WAVE_INFANTRY, text = LOC("Infantry Attack Incoming")},
				{warning = WAVE_VEHICLES, text = LOC("Vehicle Attack Incoming")},
				{warning = WAVE_MIXED, text = LOC("Infantry and Vehicle Attack Incoming")},
			},
			warningUseObjective = true,		-- Warning system uses the nextObj hintpoints instead of standard hintpoints
		},
		
		commandSGroup = sg_e_wave_all,		-- The SGroup all wave units are assigned to
		
		goalData = {				-- Goal Data for the attack waves
			name = "Attack",
			target = target,
			range = 5,
			leashRange = 40,
			attackMove = true,
			coordinatedSetup = false,
			tacticControlsList = {{tacticType = TACTIC_Pickup, priority = -1},
								  {tacticType = TACTIC_Recrew, priority = -1},
								  {tacticType = TACTIC_CaptureTeamWeapon, priority = -1},
								  {tacticType = TACTIC_RushAtTarget, priority = -1},
								  {tacticType = TACTIC_Ability, priority = -1},},
			movePathLengthFactor = -1,
		},
		
		sustainedAttack = {
			newSpawnThreshold = 3,		-- How many units left alive in an encounter before we spawn a new one
			newSpawnWaitTime = 5,		-- How many seconds before we actually spawn the next encounter
		},
		
		randomEncounters = {
			numEncounters = {3},		-- Number of encounters for each wave.  Enter numbers for each wave, or it will use the furthest right
			exclusive = false,			-- Determines if the system should draw from the current wave only, or all previous waves
			uniqueSpawns = false,		-- Determines if only one instance of a wave composition should be used at a time.
		},
		
		randomSpawnDirection = false,		-- Determines if units should ignore direction on wave tables and spawn at random directions
		randomEncounterTarget = false,		-- Determines if units should ignore associated targets with spawns and target any possible target
		
		staggeredSpawnTime = {
			delay = 3,					-- Delay between spawns
		},
		
		rallyData = {
			name = "Move",
			target = target,
			range = 5,
			leashRange = 40,
			attackMove = true,
			tacticControlsList = {{tacticType = TACTIC_Pickup, priority = -1},
								  {tacticType = TACTIC_Recrew, priority = -1},
								  {tacticType = TACTIC_CaptureTeamWeapon, priority = -1},
								  {tacticType = TACTIC_RushAtTarget, priority = -1},
								  {tacticType = TACTIC_Ability, priority = -1},},
			movePathLengthFactor = -1,
			
		}
	}
	
	-- WAVE TABLE EXAMPLE	
	ENCOUNTERS.wave01 = function()
		local waveData = {
			{
				direction = 1, 
				units = {
					{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				},
				hint = WAVE_INFANTRY,
				weight = 5,
			},
			{
				direction = 1, 
				units = {
					{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
					{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG}},
				},
				hint = WAVE_INFANTRY,
				weight = 1,
			},
			{
				direction = 2, 
				units = {
					{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
					{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
					{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG}},
				},
				hint = WAVE_INFANTRY,
				weight = 10,
			},
		}
		return waveData
	end
]]

function WaveDefense_Init()
	-- Setup some ENUMS
	WARNING_NONE = 0
	WARNING_LOW = 1
	WARNING_HIGH = 2
	
	WAVE_INFANTRY = 0
	WAVE_VEHICLES = 1
	WAVE_MIXED = 2
	
	CONDITION_UNITS_LEFT = 0
	CONDITION_TIMER_ENDED = 1
	
	__waveDefense_debug = false
	
	if Misc_IsCommandLineOptionSet("WDPrint") then
		__waveDefense_debug = true
	end	
	
	__waveDefense_vehicleSGroup = SGroup_CreateIfNotFound("__waveDefense_vehicleSGroup")
	
	Rule_Add(__waveDefense_setupInternal)
end

Scar_AddInit(WaveDefense_Init)

--? @group WaveDefense

-- Function for selecting Spawn Locations
function WaveDefense_SelectSpawns()
	WDPrint("Wave Defense: Selecting Spawns")
	-- First, we clear previous Hintpoints in case they are not
	-- Just in case this is called too often, we don't end up with orphaned hintpoints
	WaveDefense_ClearWarnings()
	
	-- Store a backup of the attackDirs Table
	__t_waveDefenseData.temp_attackData = Table_Copy(__t_waveDefenseData.t_attackDirs)
	
	-- Define the current wave
	local currentWave = WaveDefense_GetWave()
	local waveTable = __t_waveDefenseData.t_waves[currentWave]
	
	-- Create a unique SGroup for the wave
	if __t_waveDefenseData.commandSGroup == nil then
		__t_waveDefenseData.commandSGroup = SGroup_CreateIfNotFound("__waveDefense_commandSGroup")
	end
	local sgroup = SGroup_CreateIfNotFound(SGroup_GetName(__t_waveDefenseData.commandSGroup).."_Wave_"..__t_waveDefenseData.waveCounter)
	
	-- Table of encounters used for random spawns
	local encounterTable = {}
	
	local randomSpawnDir = false
	if __t_waveDefenseData.randomSpawnDirection ~= nil and __t_waveDefenseData.randomSpawnDirection == true then
		randomSpawnDir = true
	end
	
	local spawnTable = waveTable.encounters
	
	if scartype(__t_waveDefenseData.randomEncounters) == ST_TABLE then		
		-- Random encounters
		local encounterTableSize = table.getn(__t_waveDefenseData.randomEncounters.numEncounters)
		local numSpawns = 0
		if encounterTableSize < currentWave then
			numSpawns = __t_waveDefenseData.randomEncounters.numEncounters[encounterTableSize]
		else
			numSpawns = __t_waveDefenseData.randomEncounters.numEncounters[currentWave]
		end
		
		-- First, we populate a grabbag table based on exclusive (this wave only) or not (this wave and all previous waves)
		if __t_waveDefenseData.randomEncounters.exclusive == true then
			encounterTable = Table_Copy(spawnTable)
		else
			for i = 1, currentWave do
				for m = 1, table.getn(__t_waveDefenseData.t_waves[i].encounters) do
					table.insert(encounterTable, __t_waveDefenseData.t_waves[i].encounters[m])
				end
			end
		end
		
		if table.getn(encounterTable) < numSpawns then
			fatal("WAVE DEFENSE: WAVE "..WaveDefense_GetWave().." Does not have enough encounters to draw from.  Got "..table.getn(encounterTable)..", needed "..numSpawns)
		end
		
		-- Check if there are weights - if one encounter does not have weights, use traditional random
		WDPrint("WAVE DEFENSE: Checking for weights")
		local useWeights = true
		for k,v in pairs(encounterTable) do
			if v.weight == nil then
				useWeights = false
				WDPrint("WAVE DEFENSE: At least one encounter did not have a weight set, using standard randomization.")
				break
			end
		end
		
		-- Now we go through and spawn our encounters
		for i = numSpawns, 1, -1 do
			local rand = 0
			if useWeights == true then
				rand = __waveDefense_DetermineWeights(encounterTable)
				WDPrint("WAVE DEFENSE: Weight system selected at index "..rand)
			else
				rand = World_GetRand(1, table.getn(encounterTable))
			end
			local encounterID = encounterTable[rand]
			
			local chosenData = nil
			if randomSpawnDir == true then
				chosenData = _waveDefense_pickWaveSpawns(__t_waveDefenseData.temp_attackData, World_GetRand(1, table.getn(__t_waveDefenseData.t_attackDirs)), false)
			else
				chosenData = _waveDefense_pickWaveSpawns(__t_waveDefenseData.temp_attackData, encounterID.direction, false)
			end
			
			-- Fill in additional data including players
			encounterID.player = player5
			encounterID.spawn = chosenData.spawn
			encounterID.dynamicSpawnTarget = chosenData.dynSpawn
			encounterID.sgroups = {sgroup, __t_waveDefenseData.commandSGroup}
			encounterID.ui = chosenData.ui
			encounterID.target = chosenData.target
			encounterID.attackWaveDir = chosenData
			encounterID.rallyPoint = chosenData.rallyPoint
			
			table.insert(__t_waveDefenseData.t_wavesRandom, encounterID)
			
			if __t_waveDefenseData.randomEncounters.uniqueSpawns == true then
				table.remove(encounterTable, rand)
			end
		end
	else	
		for k, v in pairs(spawnTable) do
			-- Get a random direction to spawn from
			local chosenData = nil
			if randomSpawnDir == true then
				chosenData = _waveDefense_pickWaveSpawns(__t_waveDefenseData.temp_attackData, World_GetRand(1, table.getn(__t_waveDefenseData.t_attackDirs)), false)
			else
				chosenData = _waveDefense_pickWaveSpawns(__t_waveDefenseData.temp_attackData, v.direction, false)
			end
			
			-- Fill in additional data including players
			v.player = player5
			v.spawn = chosenData.spawn
			v.dynamicSpawnTarget = chosenData.dynSpawn
			v.sgroups = {sgroup, __t_waveDefenseData.commandSGroup}
			v.ui = chosenData.ui
			v.target = chosenData.target
			v.attackWaveDir = chosenData
			v.rallyPoint = chosenData.rallyPoint
		end
	end
	
	-- If using respawn and random encounters, we grab the remained of the unused encounters
	-- We draw from this for respawning
	if scartype(__t_waveDefenseData.sustainedAttack) == ST_TABLE and
      (__t_waveDefenseData.randomEncounters ~= nil and __t_waveDefenseData.randomEncounters.uniqueSpawns == true) then
		if table.getn(encounterTable) > 0 then
			__t_waveDefenseData.t_wavesRandom_unused = Table_Copy(encounterTable)
		end
	end
	
	if __t_waveDefenseData.warningLevel > WARNING_NONE then
		WaveDefense_ShowWarnings()
	end
	
	__waveDefense_DEBUG_selectSpawn()
end

-- Returns the current Wave
function WaveDefense_GetWave()
	if scartype(__t_waveDefenseData) == ST_TABLE then
		return __t_waveDefenseData.waveCounter or 0
	else
		return 0
	end
end

-- Sets the current Wave
function WaveDefense_SetWave(wave)
	if wave > WaveDefense_GetTotalWaves() then
		fatal("WAVE DEFENSE: Wave "..wave.." Too high! There are only "..WaveDefense_GetTotalWaves().." waves defined!")
	end
	__t_waveDefenseData.waveCounter = wave
	
	__waveDefense_DEBUG_setWave()
end

-- Increment the Wave forward one
function WaveDefense_NextWave()
	if (WaveDefense_GetWave() + 1) > WaveDefense_GetTotalWaves() then
		fatal("WAVE DEFENSE: No more waves beyond wave "..WaveDefense_GetWave())
	end
	__t_waveDefenseData.waveCounter = __t_waveDefenseData.waveCounter + 1
	
	__waveDefense_DEBUG_setWave()
end

-- Decrease the Wave back one
function WaveDefense_PreviousWave()
	__t_waveDefenseData.waveCounter = __t_waveDefenseData.waveCounter - 1
	
	__waveDefense_DEBUG_setWave()
end

-- Returns the total waves the player has
function WaveDefense_GetTotalWaves()
	return table.getn(__t_waveDefenseData.t_waves)
end

-- Sets the objectives for the wave defense system
function WaveDefense_SetObjectives(primary, nextObj, currObj)
	if primary ~= nil then 
		__t_waveDefenseData.parentObj = primary
	end
	if currObj ~= nil then
		__t_waveDefenseData.currentWaveObj = currObj
	end
	if nextObj ~= nil then
		__t_waveDefenseData.nextWaveObj = nextObj
	end
end

-- Sets the command SGroup for the wave defense system
function WaveDefense_SetCommandSGroup(sgroup)
	__t_waveDefenseData.commandSGroup = sgroup
end

--? @shortdesc Get the internal SGroup that contains all current WaveDefense units
--? @result SGroup
function WaveDefense_GetCommandSGroup()
	return __t_waveDefenseData.commandSGroup
end

-- Function that actuall spawns the next wave
function WaveDefense_SpawnWave()
	WDPrint("Wave Defense: Spawning Waves")
	
	-- Define the current wave
	local currentWave = __t_waveDefenseData.waveCounter
	local waveTable = __t_waveDefenseData.t_waves[currentWave]
	__t_waveDefenseData.wave_encounters = {}
	
	local spawnFunc = __t_waveDefenseData.waveSpawn_func
	if spawnFunc ~= ST_FUNCTION then
		spawnFunc = waveTable.waveSpawn_func
	end
	
	if scartype(spawnFunc) == ST_FUNCTION then
		spawnFunc()
	end
	
	-- Create a new goalData table if it does not exist
	if __t_waveDefenseData.goalData == nil then
		__t_waveDefenseData.goalData = {				
			name = "Attack",
			target = target,
			range = 5,
			leashRange = 40,
			attackMove = true,
			coordinatedSetup = false,
			tacticControlsList = {{tacticType = TACTIC_Pickup, priority = -1},
								  {tacticType = TACTIC_Recrew, priority = -1},
								  {tacticType = TACTIC_CaptureTeamWeapon, priority = -1},
								  {tacticType = TACTIC_RushAtTarget, priority = -1},
								  {tacticType = TACTIC_Ability, priority = -1},},
			movePathLengthFactor = -1,
		}
	end
	
	local spawnTable = waveTable.encounters
	
	if scartype(__t_waveDefenseData.randomEncounters) == ST_TABLE then
		spawnTable = __t_waveDefenseData.t_wavesRandom
	end
	
	for k, v in pairs(spawnTable) do
		-- Spawn the Encounter
		local staggeredSpawn = false
		if scartype(__t_waveDefenseData.staggeredSpawnTime) == ST_TABLE then
			staggeredSpawn = true
			if __t_waveDefenseData.staggeredSpawnTime.delay >= 0 then
				AI_SetStaggeredSpawnDelay(__t_waveDefenseData.staggeredSpawnTime.delay)
			end
		end
		
		local encounter = XP1_EncounterCreate(spawnTable[k], true, staggeredSpawn)
		table.insert(__t_waveDefenseData.wave_encounters, encounter)
		
		-- Now fill in goal data and assign
		local t_goalData = Table_Copy(__t_waveDefenseData.goalData)
		t_goalData.target = v.target
		
		if scartype(__t_waveDefenseData.rallyData) == ST_TABLE then
			-- Rally point set
			-- Store goal data in the encounter
			encounter.storedGoal = t_goalData
			-- Set a new rally goal
			t_goalData = Table_Copy(__t_waveDefenseData.rallyData)
			t_goalData.target = v.rallyPoint
			t_goalData.onSuccess = __waveDefense_RallyPointSuccess
		end
		
		encounter:SetGoal(t_goalData)
		
		if scartype(__t_waveDefenseData.sustainedAttack) == ST_TABLE then
			local sustainedAtk = __t_waveDefenseData.sustainedAttack
			local event = nil
			
			local totalUnits = SGroup_TotalMembersCount(encounter:GetSgroup(), true)
			
			if totalUnits <= sustainedAtk.newSpawnThreshold then
				event = Event_GroupIsDead(_waveDefense_sustainedRespawnAttack, {eventID = k, encounterID = encounter}, encounter:GetSgroup(), sustainedAtk.newSpawnWaitTime)
			else
				event = Event_GroupLeftAlive(_waveDefense_sustainedRespawnAttack, {eventID = k, encounterID = encounter}, encounter:GetSgroup(), sustainedAtk.newSpawnThreshold, sustainedAtk.newSpawnWaitTime)
			end
			
			table.insert(__t_waveDefenseData.t_sustainedAttackData, event)
		end
	end
	
	-- Add all vehicles to the vehicle sgroup
	local countVehicles = function(gid, idx, sid)
		local squadSize = Squad_Count(sid)
		for i = 1, squadSize do
			local eid = Squad_EntityAt(sid, i-1)
			if Entity_IsVehicle(eid) then
				SGroup_Add(__waveDefense_vehicleSGroup, sid)
			end
		end
	end
	SGroup_ForEach(__t_waveDefenseData.commandSGroup, countVehicles)
	
	-- Clear the warning markers
	WaveDefense_ClearWarnings()
	
	-- Start the Finish Wave Rule
	local completeConditionTable = __t_waveDefenseData.waveCompleteCondition
	if scartype(__t_waveDefenseData.t_waves[WaveDefense_GetWave()].waveCompleteCondition) == ST_TABLE then
		completeConditionTable = __t_waveDefenseData.t_waves[WaveDefense_GetWave()].waveCompleteCondition
	end
	
	if completeConditionTable.condition == CONDITION_UNITS_LEFT then
		
		__waveCompleteEvent = Event_CreateAND(_waveDefense_FinishWave,  {encounterIDs = __t_waveDefenseData.wave_encounters}, {
					Event_CreateOR(__DoNothing, nil, {
						Event_GroupCount(__DoNothing, nil, __waveDefense_vehicleSGroup, completeConditionTable.vehicle or 0, true),		-- vehicles in the group get down to a set amount
						Event_GroupHasCritical(__DoNothing, nil, __waveDefense_vehicleSGroup, CRIT.VEHICLE_DESTROY_MAINGUN, ALL, nil),												-- or all the vehicles have a critical
					}),
					Event_GroupLeftAlive(__DoNothing, nil, spawnTable[1].sgroups[1], completeConditionTable.variable),			-- group gets down to a set amount
			},
		1)
		
		if scartype(__t_waveDefenseData.sustainedAttack) == ST_TABLE then
			fatal("WAVE DEFENSE: Sustained Attack Does not work with CONDITION_UNITS_LEFT.  Use CONDITION_TIMER_ENDED instead.")
		end
	elseif completeConditionTable.condition == CONDITION_TIMER_ENDED then
		__waveCompleteEvent = Event_Timer(_waveDefense_FinishWave, {encounterIDs = __t_waveDefenseData.wave_encounters}, completeConditionTable.variable)
	end
	
	__waveDefense_DEBUG_waveSpawn()
end 

--? @shortdesc Shows warning for incoming waves by placing hintpoints on target locations.
--? @result Void
function WaveDefense_ShowWarnings()
	
	WDPrint("Adding Warning Markers")
	local warningLevelData = __t_waveDefenseData.warningLevel_data
	local warningLevel = warningLevelData.warningLevel
	
	-- Define the current wave
	local currentWave = __t_waveDefenseData.waveCounter
	local waveTable = __t_waveDefenseData.t_waves[currentWave]
	
	local spawnTable = waveTable.encounters
	
	if scartype(__t_waveDefenseData.randomEncounters) == ST_TABLE then
		spawnTable = __t_waveDefenseData.t_wavesRandom
	end
	
	-- Go through and mark each spawn based on the warning level
	for k, v in pairs(spawnTable) do
		-- Mark each
		local text = warningLevelData.warningLow --WarningLow by default
		
		if warningLevel == WARNING_HIGH and v.hint ~= nil then
			for i, e in pairs(warningLevelData.warningHigh) do
				if e.warning == v.hint then
					text = e.text
					break
				end
			end
		end
		
		if(text == nil) then
			fatal("WaveDefense_ShowWarnings: No warningLow or hint defined.")
		end
		
		-- Uses spawn position as default is ui == nil
		local uiPos = v.ui or v.spawn
		if(scartype(uiPos) == ST_TABLE) then
			uiPos = Table_GetRandomItem(uiPos)
		end
		
		local hpid = 0
		if warningLevelData.warningUseObjective == true then
			hpid = Objective_AddUIElements(warningLevelData.nextWaveObj, uiPos, true, text, true)
		else
			hpid = HintPoint_Add(uiPos, true, text)
		end
		
		--Show mag pings
		if warningLevelData.warningBlip then
			UI_CreateMinimapBlip(uiPos, warningLevelData.warningBlipLifetime or 5, warningLevelData.warningBlip)
		end
		
		table.insert(__t_waveDefenseData.t_spawnWarnings, hpid)
	end
end

--? @shortdesc Clears any existing Warning Markers
--? @result Void
function WaveDefense_ClearWarnings()
	WDPrint("Clearing Warning Markers")
	local warningLevelData = __t_waveDefenseData.warningLevel_data
	-- Go through the spawn Warnings table and clear all spawn markers
	if scartype(__t_waveDefenseData.t_spawnWarnings) == ST_TABLE and table.getn(__t_waveDefenseData.t_spawnWarnings) > 0 then
		for i = 1, table.getn(__t_waveDefenseData.t_spawnWarnings) do
			if warningLevelData.warningUseObjective == true then
				Objective_RemoveUIElements(__t_waveDefenseData.nextWaveObj, __t_waveDefenseData.t_spawnWarnings[i])
			else
				HintPoint_Remove(__t_waveDefenseData.t_spawnWarnings[i])
			end
		end
		
		__t_waveDefenseData.t_spawnWarnings = {}
	end
end

--? @shortdesc Set the wave completion conditions. Must be set BEFORE the wave is spawned.
--? @extdesc Requires the following parameters: condition, variable, wave_retreats. See http://relicwiki.relic.sega.us/display/REL/Wave+Defense for details.
--? @@args Table params
--? @result Void
function WaveDefense_SetCompletionParameters(params)
	if scartype(params) == ST_TABLE then
		__t_waveDefenseData.waveCompleteCondition = params
	else
		fatal("Invalid parameter type. Expected table, got " .. scartype_tostring(params))
	end
end

-- Sets the completion variable for a wave
function WaveDefense_SetCompletion_Variable(newVariable)
	__t_waveDefenseData.waveCompleteCondition.variable = newVariable
end

-- Gets the completion variable for a wave
function WaveDefense_GetCompletion_Variable()
	return __t_waveDefenseData.waveCompleteCondition.variable
end

-- Sets the warning level
function WaveDefense_SetWarningLevel(level)
	__t_waveDefenseData.warningLevel = level
end

-- Forces the wave to complete
function WaveDefense_ForceComplete()
	if Event_Exists(__waveCompleteEvent) then
		Event_Remove(__waveCompleteEvent)
	end
	
	local data = {encounterIDs = __t_waveDefenseData.wave_encounters}
	
	_waveDefense_FinishWave(data)
end

function __DoNothing()
end

--? @shortdesc Toggle wave defense debug on or off
--? @result Void
function WaveDefense_DEBUG_Toggle()
	if __waveDefense_debug == true then
		__waveDefense_debug = false
	elseif __waveDefense_debug == false then
		__waveDefense_debug = true
	end
	
	__waveDefense_DEBUG_ToggleUI()
end



----------------------------------------------------------
-- INTERNAL FUNCTIONS
----------------------------------------------------------
-- Function for setting up default interal data
function __waveDefense_setupInternal()
	__waveDefense_DEBUG_Init()
	
	if scartype(__t_waveDefenseData) ~= ST_TABLE then
		return
	end
	
	if scartype(__t_waveDefenseData.dataSet) ~= ST_BOOLEAN then
		__t_waveDefenseData.dataSet = true
		
		__t_waveDefenseData.t_spawnWarnings = {}
		__t_waveDefenseData.t_wavesRandom = {}
		__t_waveDefenseData.t_wavesRandom_unused = {}
		__t_waveDefenseData.waveCounter = 1
		__t_waveDefenseData.t_sustainedAttackData = {}
		__t_waveDefenseData.temp_attackData = {}
		__t_waveDefenseData.warningLevel = __t_waveDefenseData.warningLevel or WARNING_NONE
		__t_waveDefenseData.warningUseObjective = false
		
		-- Debug
		__waveCompleteTimer = "__waveCompleteTimer"
		if __waveDefense_debug == true then
			if Rule_Exists(__waveDefense_DEBUG_SetupDebug) == false then Rule_Add(__waveDefense_DEBUG_SetupDebug) end
		end
	end
end

-- Called when a wave finishes
function _waveDefense_FinishWave(data)
	WDPrint("Wave Complete")
	-- Once the number of units alive reaches the waveComplete threshold, end the wave
	if __t_waveDefenseData.waveCompleteCondition.wave_retreats == true then
		local __findVehicles = function(gid, idx, sid)
			if Entity_IsVehicle(Squad_EntityAt(sid, 0)) then
				return
			end
		end
		
		SGroup_ForEach(__t_waveDefenseData.commandSGroup, __findVehicles)		-- We only retreat if there are no vehicles alive
		
		-- Cleanup
		for i = 1, table.getn(data.encounterIDs) do
			data.encounterIDs[i]:Disable()
		end
		Cmd_StaggeredRetreat(__t_waveDefenseData.commandSGroup, __t_waveDefenseData.t_retreatDirs, 3, true)
	end
	
	-- Remove sustained spawn events (if any)
	if scartype(__t_waveDefenseData.t_sustainedAttackData) == ST_TABLE then
		for k,v in pairs(__t_waveDefenseData.t_sustainedAttackData) do
			Event_Remove(v)
		end
	end
	
	-- Clear Random Waves Table (if any)
	if scartype(__t_waveDefenseData.randomEncounters) == ST_TABLE then
		__t_waveDefenseData.t_wavesRandom = {}
		__t_waveDefenseData.t_wavesRandom_unused = {}
	end
	
	-- If there's an intermission function defined, call it now
	if __t_waveDefenseData.waveComplete_func ~= nil then
		__t_waveDefenseData.waveComplete_func()
	end
	
	--Clean out the control sgroups
	SGroup_Clear(__waveDefense_vehicleSGroup)
	SGroup_Clear(__t_waveDefenseData.commandSGroup)
	
	__waveDefense_DEBUG_waveComplete()
end

-- Respawns a Sustained Attack Wave
function _waveDefense_sustainedRespawnAttack(dataInt)
	WDPrint("Sustained Attack: Respawning Attack")
	local units = dataInt.encounterID.data.units
	local sustainedAtk = __t_waveDefenseData.sustainedAttack
	
	local chosenGoalData = nil
	
	if __t_waveDefenseData.randomSpawnDirection ~= nil and __t_waveDefenseData.randomSpawnDirection == true then
		local chosenData = _waveDefense_pickWaveSpawns(__t_waveDefenseData.t_attackDirs, World_GetRand(1, table.getn(__t_waveDefenseData.t_attackDirs)), false)
		
		dataInt.encounterID.data.spawn = chosenData.spawn
		dataInt.encounterID.data.dynamicSpawnTarget = chosenData.dynSpawn
		
		for i = 1, table.getn(dataInt.encounterID.data.units) do
			dataInt.encounterID.data.units[i].spawn = chosenData.spawn
			dataInt.encounterID.data.units[i].dynamicSpawnTarget = chosenData.dynSpawn
		end
		
		if __t_waveDefenseData.randomEncounterTarget ~= nil and __t_waveDefenseData.randomEncounterTarget == false then
			chosenGoalData = chosenData
		end
	end
	
	if __t_waveDefenseData.randomEncounterTarget ~= nil and __t_waveDefenseData.randomEncounterTarget == true then
		chosenGoalData = _waveDefense_pickWaveSpawns(__t_waveDefenseData.t_attackDirs, World_GetRand(1, table.getn(__t_waveDefenseData.t_attackDirs)), false)
	end
	
	-- If we're using random encounters, we need to select a new one
	if scartype(__t_waveDefenseData.randomEncounters) == ST_TABLE then
		if table.getn(__t_waveDefenseData.t_wavesRandom_unused) > 0 then
			-- Shuffle the current encounter back in
			local t = {}
			t.direction = dataInt.encounterID.data.direction
			t.units = dataInt.encounterID.data.units
			
			table.insert(__t_waveDefenseData.t_wavesRandom_unused, t)
			-- Now select a new encounter
			-- Now we go through and spawn our encounters
			local rand = World_GetRand(1, table.getn(__t_waveDefenseData.t_wavesRandom_unused))
			local encounterID = __t_waveDefenseData.t_wavesRandom_unused[rand]
			
			units = encounterID.units
			
			if __t_waveDefenseData.randomEncounters.uniqueSpawns == true then
				table.remove(__t_waveDefenseData.t_wavesRandom_unused, rand)
			end
		end
	end
	
	for i = 1, table.getn(units) do
		dataInt.encounterID:AddUnit(units[i])
	end
	
	-- Update Goal
	local goalData = dataInt.encounterID:GetGoalData()
	if scartype(chosenGoalData) == ST_TABLE then
		goalData.target = chosenGoalData.target
	end
	WDPrint("WAVE DEFENSE: Sustained Attack: Setting Goal Data")
	
	if scartype(__t_waveDefenseData.rallyData) == ST_TABLE then
		WDPrint("WAVE DEFENSE: Sustained Attack: Overriding with RallyPoint Data")
		-- Rally point set
		-- Store goal data in the encounter
		dataInt.encounterID.data.storedGoal = goalData
		-- Set a new rally goal
		goalData = Table_Copy(__t_waveDefenseData.rallyData)
		goalData.target = chosenGoalData.rallyPoint
		goalData.onSuccess = __waveDefense_RallyPointSuccess		
	end
	
	dataInt.encounterID:SetGoal(goalData)
	
	local totalUnits = SGroup_TotalMembersCount(dataInt.encounterID:GetSgroup(), true)
	
	if totalUnits <= sustainedAtk.newSpawnThreshold then
		__t_waveDefenseData.t_sustainedAttackData[dataInt] = Event_GroupIsDead(_waveDefense_sustainedRespawnAttack, {eventID = dataInt.eventID, encounterID = dataInt.encounterID}, dataInt.encounterID:GetSgroup(), sustainedAtk.newSpawnWaitTime)
	else
		__t_waveDefenseData.t_sustainedAttackData[dataInt] = Event_GroupLeftAlive(_waveDefense_sustainedRespawnAttack, {eventID = dataInt.eventID, encounterID = dataInt.encounterID}, dataInt.encounterID:GetSgroup(), sustainedAtk.newSpawnThreshold, sustainedAtk.newSpawnWaitTime)
	end
	
	dataInt.encounterID:RestartGoal()
end

-- Function to select a spawn point
function _waveDefense_pickWaveSpawns(dataTable, direction, removeFromDataTable)
	local rand = World_GetRand(1, table.getn(dataTable[direction]))
	local chosenData = dataTable[direction][rand]
	
	if removeFromDataTable then
		table.remove(dataTable[direction], rand)
	end
	
	return chosenData
end

-- Function to move from rally point onto main goal
function __waveDefense_RallyPointSuccess(encounterID)
	local newGoal = encounterID.storedGoal
	encounterID:SetGoal(newGoal)
end

-- Find a randomly selected index for spawning based on weight
function __waveDefense_DetermineWeights(encounters)
	local threshold = World_GetRand(0, __waveDefense_weightedTotal(encounters))
	local last_choice
	for k,v in pairs(encounters) do
		threshold = threshold - v.weight
		if threshold <= 0 then return k end
		last_choice = k
	end
	return last_choice
end

-- Get weight totals for the weight system
function __waveDefense_weightedTotal(encounters)
	local total = 0
	for k,v in pairs(encounters) do
		total = total + v.weight
	end
	return total
end

function __waveDefense_UpdateWaveData()
	
end


----------------------------------------------------------
-- DEBUG FUNCTIONS
----------------------------------------------------------
function WDPrint(stringToPrint)
	if __waveDefense_debug == true then
		print(stringToPrint)
	end
end

-- debug: Sets up wave debug overlay
function __waveDefense_DEBUG_Init()
	__g_hideTempWDUI = false
	dr_setautoclear("waveDefenseUI", __g_hideTempWDUI)
	dr_setautoclear("waveDefenseUI_Wave", __g_hideTempWDUI)
	dr_setautoclear("waveDefenseUI_Status", __g_hideTempWDUI)
	dr_setautoclear("waveDefenseUI_Completion", __g_hideTempWDUI)
	dr_setautoclear("waveDefenseUI_CompletionVar1", __g_hideTempWDUI)
	dr_setautoclear("waveDefenseUI_CompletionVar2", __g_hideTempWDUI)
	
	dr_clear("waveDefenseUI")
	dr_clear("waveDefenseUI_Wave")
	dr_clear("waveDefenseUI_Status")
	dr_clear("waveDefenseUI_Completion")
	dr_clear("waveDefenseUI_CompletionVar1")
	dr_clear("waveDefenseUI_CompletionVar2")
end

-- Toggle the UI for wave defense
function __waveDefense_DEBUG_ToggleUI()
	if __waveDefense_debug == true then
		dr_text2d( "waveDefenseUI", 0.02, 0.46, "----- WAVE DEFENSE -----", 0,238,238 )
		dr_clear("waveDefenseUI_Status")
		dr_text2d( "waveDefenseUI_Status", 0.02, 0.50, "No Wave Currently", 255,20,147 )
		
		__waveDefense_DEBUG_setWave()
	else
		__g_hideTempWDUI = false
		dr_setautoclear("waveDefenseUI", __g_hideTempWDUI)
		dr_setautoclear("waveDefenseUI_Wave", __g_hideTempWDUI)
		dr_setautoclear("waveDefenseUI_Status", __g_hideTempWDUI)
		dr_setautoclear("waveDefenseUI_Completion", __g_hideTempWDUI)
		dr_setautoclear("waveDefenseUI_CompletionVar1", __g_hideTempWDUI)
		dr_setautoclear("waveDefenseUI_CompletionVar2", __g_hideTempWDUI)
		
		dr_clear("waveDefenseUI")
		dr_clear("waveDefenseUI_Wave")
		dr_clear("waveDefenseUI_Status")
		dr_clear("waveDefenseUI_Completion")
		dr_clear("waveDefenseUI_CompletionVar1")
		dr_clear("waveDefenseUI_CompletionVar2")
	end
end

-- debug: Draw data on screen
function __waveDefense_DEBUG_SetupDebug()
	if scartype(__t_waveDefenseData) ~= ST_TABLE then
		return
	end
	
	Rule_RemoveMe()
	
	dr_text2d( "waveDefenseUI", 0.02, 0.46, "----- WAVE DEFENSE -----", 0,238,238 )
	dr_clear("waveDefenseUI_Status")
	dr_text2d( "waveDefenseUI_Status", 0.02, 0.50, "No Wave Currently", 255,20,147 )
	
	__waveDefense_DEBUG_setWave()
end

-- debug: Select a Wave
function __waveDefense_DEBUG_setWave()
	if __waveDefense_debug == true then
		dr_clear("waveDefenseUI_Wave")
		dr_text2d( "waveDefenseUI_Wave", 0.02, 0.48, ("Wave: "..WaveDefense_GetWave()), 255,20,147 )
		dr_clear("waveDefenseUI_Status")
		dr_text2d( "waveDefenseUI_Status", 0.02, 0.50, "Wave Changed", 255,20,147 )
	end
end

-- debug: Set up a new ave
function __waveDefense_DEBUG_selectSpawn()
	if __waveDefense_debug == true then
		dr_clear("waveDefenseUI_Status")
		dr_text2d( "waveDefenseUI_Status", 0.02, 0.50, ("Wave Spawns Selected"), 255,20,147 )
	end
end

-- debug: Calls on wave Spawn
function __waveDefense_DEBUG_waveSpawn()
	if __waveDefense_debug == true then
		if WaveDefense_GetWave() > 0 then
			dr_clear("waveDefenseUI_Status")
			dr_text2d( "waveDefenseUI_Status", 0.02, 0.50, ("Wave Active"), 255,20,147 )
			
			local conditionText = ""
			if __t_waveDefenseData.waveCompleteCondition.condition == CONDITION_UNITS_LEFT then
				conditionText = "CONDITION_UNITS_LEFT"
			elseif __t_waveDefenseData.waveCompleteCondition.condition == CONDITION_TIMER_ENDED then
				conditionText = "CONDITION_TIMER_ENDED"
				
				Timer_Start(__waveCompleteTimer, __t_waveDefenseData.waveCompleteCondition.variable)
			end
			
			dr_clear("waveDefenseUI_Completion")
			dr_text2d( "waveDefenseUI_Completion", 0.02, 0.53, (conditionText), 255,20,147 )
		end
	end
	if Rule_Exists(__waveDefense_DEBUG_updateDisplay) == false then Rule_AddInterval(__waveDefense_DEBUG_updateDisplay, 1) end
end

-- debug: update a wave status
function __waveDefense_DEBUG_updateDisplay()	
	if __waveDefense_debug == true then
		if __t_waveDefenseData.waveCompleteCondition.condition == CONDITION_UNITS_LEFT then
			local unitsToKill = (SGroup_TotalMembersCount(__t_waveDefenseData.commandSGroup, true)-__t_waveDefenseData.waveCompleteCondition.variable)
			if unitsToKill < 0 then
				unitsToKill = 0
			end
			local vehiclesToKill = 0
			if SGroup_IsEmpty(__waveDefense_vehicleSGroup) == false then
				vehiclesToKill = SGroup_TotalMembersCount(__waveDefense_vehicleSGroup)
			end
			
			if unitsToKill >= 0 and vehiclesToKill > 0 then
				dr_clear("waveDefenseUI_CompletionVar1") 
				dr_text2d( "waveDefenseUI_CompletionVar1", 0.02, 0.56, ("Units To Kill: "..unitsToKill), 255,20,147 )
				dr_clear("waveDefenseUI_CompletionVar2") 
				dr_text2d( "waveDefenseUI_CompletionVar2", 0.02, 0.58, ("Vehicles To Kill: "..vehiclesToKill), 255,20,147 )
			elseif unitsToKill == 0 and vehiclesToKill == 0 then
				__waveDefense_DEBUG_waveComplete()
			end
		elseif __t_waveDefenseData.waveCompleteCondition.condition == CONDITION_TIMER_ENDED then
			local seconds = Timer_GetRemaining(__waveCompleteTimer)
			
			if seconds > 0 then 
				local minutes = math.floor(seconds / 60)
				seconds = math.floor(math.mod(seconds, 60))
				
				dr_clear("waveDefenseUI_CompletionVar1") 
				dr_text2d( "waveDefenseUI_CompletionVar1", 0.02, 0.56, ("Wave Complete in: "..minutes..":"..seconds), 255,20,147 )
			elseif seconds <= 0 then
				__waveDefense_DEBUG_waveComplete()
			end
		end
	end
end

-- debug: Calls on wave completion
function __waveDefense_DEBUG_waveComplete()
	if __waveDefense_debug == true then
		if Rule_Exists(__waveDefense_DEBUG_updateDisplay) then Rule_Remove(__waveDefense_DEBUG_updateDisplay) end
		if Timer_Exists(__waveCompleteTimer) then Timer_End(__waveCompleteTimer) end
		dr_clear("waveDefenseUI_Completion")
		dr_clear("waveDefenseUI_CompletionVar1") 
		dr_clear("waveDefenseUI_CompletionVar2") 
		
		dr_clear("waveDefenseUI_Status")
		dr_text2d( "waveDefenseUI_Status", 0.02, 0.50, ("Wave Finished"), 255,20,147 )
	end
end
