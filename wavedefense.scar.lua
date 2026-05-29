
--[[ DEFAULT DATA
	__t_waveDefenseData = {
		-- THE FOLLOWING DATA MUST BE DEFINED BY THE SCRIPTER --
		parentObj = OBJ_DefendTheBridge,		-- The main objective
		currentWaveObj = SOBJ_CurrWave,			-- Objective for "Defend against Current Wave"
		nextWaveObj = SOBJ_NextWave,			-- Objective for "Next Wave in"
		
		t_attackDirs = {			-- Contains all possible attack direction data. Each chunk is for a different direction
			{						-- spawn = The spawn point, dynSpawn = Dynamic spawn target, ui = location for hintpoints, target = target for goal
				{spawn = mkr_attack_northEast_spawn, dynSpawn = mkr_attack_ui_northEast, ui = mkr_attack_ui_northEast, target = mkr_attack_northCapture},
			},
		},	
		
		t_retreatDirs = {RETREAT_MARKER_DATA},
		
		-- Optional Data	
		waveComplete_func = nil,			-- Function to call at the start of an intermission
		
		warningLevel = WARNING_HIGH,				-- WARNING_NONE, WARNING_LOW, WARNING_HIGH is amount of warning the player gets for each attack direction
		warningLow = LOC("Attack Incoming"),		-- Customize warning text for WARNING_LOW
		warningHigh = {							-- Customize warning text for WARNING_HIGH
			{warning = WAVE_INFANTRY, text = LOC("Infantry Attack Incoming")},
			{warning = WAVE_VEHICLES, text = LOC("Vehicle Attack Incoming")},
			{warning = WAVE_MIXED, text = LOC("Infantry and Vehicle Attack Incoming")},
		},
		
		commandSGroup = {sg_e_wave_all},		-- The SGroup all wave units are assigned to
		
		waveCompleteCondition = {
			condition = CONDITION_UNITS_LEFT,
			variable = 5,
			wave_retreats = true,
		},
		
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
		
		--************************************************
		-- THE FOLLOWING DATA IS INTERNAL: DO NOT TOUCH --
		t_spawnWarnings = {},		-- Used for warning markers
		
		t_waves = {},				-- Contains the waves (Defined in accompanied file)
			
		waveCounter = 1,			-- Tracks which wave we're on
	}
	
	-- WAVE TABLE EXAMPLE
	__t_waveDefenseData.t_waves[1] = {
		{
			direction = NORTH, 
			units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG}},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG}},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = NORTH, 
			units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG}},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG}},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = SOUTH, 
			units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG}},
			},
			hint = WAVE_INFANTRY,
		},
	}
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
end

Scar_AddInit(WaveDefense_Init)
-- Function for selecting Spawn Locations
function WaveDefense_SelectSpawns()	
	-- First, we clear previous Hintpoints in case they are not
	-- Just in case this is called too often, we don't end up with orphaned hintpoints
	__waveDefense_int_ClearWarningMarkers()
	
	-- Store a backup of the attackDirs Table
	local temp_attackData = Table_Copy(__t_waveDefenseData.t_attackDirs)
	
	-- Define the current wave
	local currentWave = __t_waveDefenseData.waveCounter
	local waveTable = __t_waveDefenseData.t_waves[currentWave]
	
	-- Create a unique SGroup for the wave
	local sgroup = SGroup_CreateIfNotFound(SGroup_GetName(__t_waveDefenseData.commandSGroup).."_Wave_"..__t_waveDefenseData.waveCounter)
	
	for k, v in pairs(waveTable) do
		-- Get a random entry from the direction table
		local rand = World_GetRand(1, table.getn(temp_attackData[v.direction]))
		local chosenData = temp_attackData[v.direction][rand]
		
		-- Fill in additional data including players
		v.player = player5
		v.spawn = chosenData.spawn
		v.dynamicSpawnTarget = chosenData.dynSpawn
		v.sgroups = {sgroup, __t_waveDefenseData.commandSGroup}
		v.ui = chosenData.ui
		v.target = chosenData.target
		
		-- Remove the entry from the table
		table.remove(temp_attackData[v.direction], rand)
	end
	
	__waveDefense_int_MarkWarning()
end

-- Returns the current Wave
function WaveDefense_GetWave()
	return __t_waveDefenseData.waveCounter
end

-- Sets the current Wave
function WaveDefense_SetWave(wave)
	__t_waveDefenseData.waveCounter = wave
end

-- Increment the Wave forward one
function WaveDefense_NextWave()
	__t_waveDefenseData.waveCounter = __t_waveDefenseData.waveCounter + 1
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

-- Decrease the Wave back one
function WaveDefense_PreviousWave()
	
end

-- Function that actuall spawns the next wave
function WaveDefense_SpawnWave()
	-- Define the current wave
	local currentWave = __t_waveDefenseData.waveCounter
	local waveTable = __t_waveDefenseData.t_waves[currentWave]
	local waveEncounters = {}
	
	for k, v in pairs(waveTable) do
		-- Spawn the Encounter
		local encounter = Encounter:Create(waveTable[k])
		table.insert(waveEncounters, encounter)
		
		-- Now fill in goal data and assign
		local t_goalData = Table_Copy(__t_waveDefenseData.goalData)
		t_goalData.target = v.target
		
		encounter:SetGoal(t_goalData)
	end
	
	-- Clear the warning markers
	__waveDefense_int_ClearWarningMarkers()
	
	-- Start the Finish Wave Rule
	if __t_waveDefenseData.waveCompleteCondition.condition == CONDITION_UNITS_LEFT then
		local Event1 = Event_GroupLeftAlive(__DoNothing, {encounterIDs = waveEncounters}, waveTable[1].sgroups[1], __t_waveDefenseData.waveCompleteCondition.variable)
		local Event2 = Event_GroupLeftAlive(__DoNothing, {encounterIDs = waveEncounters}, SGroup_CreateIfNotFound("sg_Vehicle"), __t_waveDefenseData.waveCompleteCondition.vehicle or 0)
		
		Event_CreateAND(_waveDefense_FinishWave,  {encounterIDs = waveEncounters}, {Event1,Event2}, 1)
	elseif __t_waveDefenseData.waveCompleteCondition.condition == CONDITION_TIMER_ENDED then
		Event_Timer(_waveDefense_FinishWave, {encounterIDs = waveEncounters}, __t_waveDefenseData.waveCompleteCondition.variable)
	end
end

function __DoNothing()
end

----------------------------------------------------------
-- INTERNAL FUNCTIONS
----------------------------------------------------------
-- Function for marking spawn locations
function __waveDefense_int_MarkWarning()
	-- Define the warning level or override if it's set to nil
	local warningLevel = __t_waveDefenseData.warningLevel
	if warningLevel == -1 or warningLevel == nil then
		if Game_GetSPDifficulty() == GD_EASY or Game_GetSPDifficulty() == GD_NORMAL then
			warningLevel = WARNING_HIGH
		elseif Game_GetSPDifficulty() == GD_HARD then
			warningLevel = WARNING_LOW
		elseif Game_GetSPDifficulty() == GD_EXPERT then
			warningLevel = WARNING_NONE
		end
	end
	
	-- Define the current wave
	local currentWave = __t_waveDefenseData.waveCounter
	local waveTable = __t_waveDefenseData.t_waves[currentWave]
	
	-- Go through and mark each spawn based on the warning level
	for k, v in pairs(waveTable) do
		-- Mark each
		local text = ""
		if warningLevel == 0 then
			return								-- No Warning, no markers
		elseif warningLevel == 1 then
			text = __t_waveDefenseData.warningLow		-- Basic warning
		elseif warningLevel == 2 then
			for i, e in pairs(__t_waveDefenseData.warningHigh) do
				if v.hint == nil then
					text = __t_waveDefenseData.warningLow
				elseif v.hint == e.warning then
					text = e.text
				end
			end
		end
		
		local hpid = Objective_AddUIElements(__t_waveDefenseData.nextWaveObj, v.ui, true, text, true)
		table.insert(__t_waveDefenseData.t_spawnWarnings, hpid)
	end
end

-- Clears Warning Markers
function __waveDefense_int_ClearWarningMarkers()
	-- Go through the spawn Warnings table and clear all spawn markers
	if table.getn(__t_waveDefenseData.t_spawnWarnings) == 0 then
		return
	else
		for i = 1, table.getn(__t_waveDefenseData.t_spawnWarnings) do
			Objective_RemoveUIElements(__t_waveDefenseData.nextWaveObj, __t_waveDefenseData.t_spawnWarnings[i])
		end
	end
	
	__t_waveDefenseData.t_spawnWarnings = {}
end

-- Called when a wave finishes
function _waveDefense_FinishWave(data)
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
	-- If there's an intermission function defined, call it now
	if __t_waveDefenseData.waveComplete_func ~= nil then
		__t_waveDefenseData.waveComplete_func()
	end
end
