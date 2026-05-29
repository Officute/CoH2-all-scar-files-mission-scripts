--? @group scardoc;Encounter

-- encounter class template
Encounter = {}

Encounter.units = {}
Encounter.data = {}
Encounter.goal = nil
Encounter.sgroup = nil
Encounter.spawned = false
Encounter.enabled = false
Encounter.wasKilled = false --If the encounter had been already spawned and was killed.
Encounter.storedGoalData = nil


--? @shortdesc Create a new encounter from encounter data. If spawnNow is true, spawns specified units immediately.
--? @extdesc See: http://relicwiki/display/REL/Ai+Encounters
--? @args EncounterData data[, Bool spawnNow, Bool spawnStaggered]
--? @result Encounter
function Encounter:Create(data, spawnNow, spawnStaggered)
	
	__AI_encounterCounter = __AI_encounterCounter + 1
	
	local encounter = Clone(self)
	if(spawnNow == nil) then spawnNow = true end
	if(spawnStaggered == nil) then spawnStaggered = false end
	
	--setup encounter data
	encounter.data = Clone(data)
	encounter.data.name = "enc" .. __AI_encounterCounter .. "_" .. (data.name or "encounter" .. (AI_GetNumEncounters()+1))
	if(encounter.data.player == nil) then encounter.data.player = __defaultEnemyPlayer end
	encounter.sgroup = SGroup_Create(encounter.data.name)
	
	Ai:Print("**** Creating encounter: " .. encounter.data.name .. " ****")
	
	--The encounter needs to have either units, or an intent (predefined units)
	if(data.units == nil and data.intent == nil) then
		fatal("No units or intent defined for encounter " .. encounter.data.name)
	end
	
	--If the encounter has an intent, add them to the units list
	if(data.intent ~= nil) then
		data.units = data.units or {}
		
		local intent = data.intent[World_GetRand(1, #data.intent)]
		
		for k,v in pairs(intent) do
			table.insert(data.units, v)
		end
	end
	
	--Create each of the units based on data
	--Debug: Performance debugging. '-enc_percsquads <X>' determines the fraction of squads to add per encounter. eg. x=0.5 spawns only half.
	local maxNumSquads = #data.units
	if(Misc_IsCommandLineOptionSet("enc_percsquads")) then
		maxNumSquads = math.ceil(tonumber(Misc_GetCommandLineString("enc_percsquads")) * #data.units)
	end
	
	for k=1, maxNumSquads do
		encounter:AddUnit(data.units[k])
	end
	
	
	if(spawnNow) then
		encounter:Spawn(spawnStaggered)
	end

	Ai:AddEncounter(encounter)
	
	Ai:Print("**** Finished creating encounter ****")
	return encounter
end


--? @shortdesc Create a new encounter with a generic Attack goal.
--? @args String name, SBP/Table encUnits, Marker/Pos spawnLoc, EGroup/SGeoup/Marker/Pos encTarget[, Marker/Pos dynamicSpawn, Marker/INT encRange, Marker/INT encLeash]
--? @result Encounter
function Encounter:CreateAttack(encName, encUnits, spawnLoc, encTarget, dynamicSpawn, encRange, encLeash)
	--Create and spawn
	local attackEnc = Encounter:CreateBasic(encName, spawnLoc, encUnits, dynamicSpawn)
	
	--Attacl goal
	local goalData = {
		name = GOAL_ATTACK,
		target = encTarget or spawnLoc,
		range = encRange,
		leashRange = encLeash,
		maxIdleTime = -1,
	}
	attackEnc:SetGoal(goalData)
	
	return attackEnc
end

--? @shortdesc Create a new encounter with a generic Defend goal.
--? @args String name, SBP/Table encUnits, Marker/Pos spawnLoc, EGroup/SGeoup/Marker/Pos encTarget[, Marker/Pos dynamicSpawn, Marker/INT encRange, Marker/INT encLeash]
--? @result Encounter
function Encounter:CreateDefend(encName, encUnits, spawnLoc, encTarget, dynamicSpawn, encRange, encLeash)
	--Create and spawn
	local defendEnc = Encounter:CreateBasic(encName, spawnLoc, encUnits, dynamicSpawn)
	
	--Attack goal
	local goalData = {
		name = GOAL_DEFEND,
		target = encTarget or spawnLoc,
		range = encRange,
		leashRange = encLeash,
		maxIdleTime = -1,
	}
	defendEnc:SetGoal(goalData)
	
	return defendEnc
end

--? @shortdesc Create a new encounter with a generic Patrol goal. 
--? @extdesc pathLoop can be: LOOP_NONE, LOOP_NORMAL, LOOP_TOGGLE_DIRECTION
--? @args String name, SBP/Table encUnits, Marker/Pos spawnLoc, Marker/String encPath[, Marker/Pos dynamicSpawn, INT pathWait, INT pathLoop]
--? @result Encounter
function Encounter:CreatePatrol(encName, encUnits, spawnLoc, encPath, dynamicSpawn, pathWait, pathLoop)
	--Create and spawn
	local patrolEnc = Encounter:CreateBasic(encName, spawnLoc, encUnits, dynamicSpawn)
	
	if(encPath == nil) then encPath = spawnLoc end
	
	--Patrol goal (defend with patrol parameters)
	local goalData = {
		name = GOAL_DEFEND,
		target = spawnLoc,
		patrolParams = {
			marker = nil,
			path = nil,
			wait = pathWait,
			loop = pathLoop,
		},
		maxIdleTime = -1,
	}
	
	if(scartype(encPath) == ST_MARKER or scartype(encPath) == ST_SCARPOS) then
		goalData.patrolParams.marker = encPath
	elseif(scartype(encPath) == ST_STRING) then
		goalData.patrolParams.path = encPath
	else
		fatal("Invalid parameter for patrol. Must be marker or waypoints (string)")
	end
	
	patrolEnc:SetGoal(goalData)
	
	return patrolEnc
end

--? @shortdesc Create a new encounter with a generic Move goal.
--? @args String name, SBP/Table encUnits, Marker/Pos spawnLoc, EGroup/SGeoup/Marker/Pos encTarget[, Marker/Pos dynamicSpawn, INT moveRange]
--? @result Encounter
function Encounter:CreateMove(encName, encUnits, spawnLoc, encTarget, dynamicSpawn, moveRange)
	--Create and spawn
	local moveEnc = Encounter:CreateBasic(encName, spawnLoc, encUnits, dynamicSpawn)
	
	--Move goal
	local goalData = {
		name = GOAL_MOVE,
		target = encTarget or spawnLoc,
		range = moveRange,
		maxIdleTime = -1,
	}
	moveEnc:SetGoal(goalData)
	
	return moveEnc
end

--? @shortdesc Create a new encounter with a generic Ability goal.
--? @args String name, SBP/Table encUnits, Marker/Pos spawnLoc, EGroup/SGeoup/Marker/Pos encTarget[, Marker/Pos dynamicSpawn, INT moveRange]
--? @result Encounter
function Encounter:CreateAbility(encName, encUnits, spawnLoc, targetAbility, encTarget, dynamicSpawn)
	--Create and spawn
	local abilityEnc = Encounter:CreateBasic(encName, spawnLoc, encUnits, dynamicSpawn)
	
	--Ability goal
	local goalData = {
		name = GOAL_ABILITY,
		target = encTarget or spawnLoc,
		maxIdleTime = -1,
		abilityParams = {
			abilityPBG = targetAbility,
		},
	}
	abilityEnc:SetGoal(goalData)
	
	return abilityEnc
end

--? @shortdesc Create a new basic encounter.
--? @args String name, Marker/Pos spawnLoc, SBP/Table encUnits[, Marker/Pos dynamicSpawn]
--? @result Encounter
function Encounter:CreateBasic(encName, spawnLoc, encUnits, dynamicSpawn)
	local encData = {
		name = encName,
		spawn = spawnLoc,
		dynamicSpawnTarget = dynamicSpawn,
	}
	
	if(scartype(encUnits) == ST_PBG) then
		encData.units = {encUnits}
	elseif(scartype(encUnits) == ST_TABLE) then
		encData.units = encUnits
	end
	
	return Encounter:Create(encData)
end




--? @shortdesc Create a new encounter from an SGroup, with default encounter data
--? @extdesc Encounter player is derived from sgroup; all squads in sgroup must be owned by same player.
--? @args SGroup squadgroup 
--? @result Encounter
function Encounter:ConvertSgroup(squadgroup)
	
	if(SGroup_CountSpawned(squadgroup) > 0) then
		local encData = {
			name = "converted_" .. (AI_GetNumEncounters() + 1),
			player = Squad_GetPlayerOwner(SGroup_GetSpawnedSquadAt(squadgroup, 1)),
			units = {}
		}
		for i=1, SGroup_CountSpawned(squadgroup) do
			table.insert(encData.units, Squad_GetBlueprint( SGroup_GetSpawnedSquadAt(squadgroup, i) ))
		end
		
		local enc = Encounter:Create(encData, false)
		enc.spawned = true
		enc.enabled = true
		if enc.sgroup ~= nil then
			SGroup_AddGroup(enc.sgroup, squadgroup)
		else
			enc.sgroup = squadgroup
		end
		
		for i,unit in ipairs(enc.units) do
			unit.sgroup = SGroup_Create("")
			SGroup_Add(unit.sgroup, SGroup_GetSpawnedSquadAt(squadgroup, i))
		end
		
		--Define a spawn point in case it needs to be re-spawned
		enc.data.spawn = SGroup_GetPosition(enc.sgroup)
		
		--Make sure that all squads are designer locked immediately
		if AI_IsEnabled(enc.data.player) then
			AI_LockSquads(enc.data.player, enc.sgroup)
		end
		
		Ai:Print("**** Finished creating encounter from sgroup ****")
		
		return enc
	else
		fatal("Unable to convert sgroup into encounter. Sgroup is empty (" .. SGroup_GetName(squadgroup) .. ")")
	end
	
	return nil
end


--Encounter update logic
function Encounter:Update()
	
	--Run through units and update them
	for k=#self.units, 1, -1 do
		local unit = self.units[k]
	
		if(unit.sgroup and SGroup_CountSpawned(unit.sgroup) == 0) then
			Ai:Print("Unit '" .. unit.data.name .. "' is dead. Removing from encounter '" .. self.data.name .. "'...")
			
			if(unit.data.onDeath ~= nil) then 
				unit.data.onDeath(unit)
			end
			table.remove(self.units, k)
		end
	end
	
	if(not self:IsAlive() and not self.wasKilled) then
		Ai:Print("Encounter '" .. self.data.name .. "' has been killed.")
		self.spawned = false
		self.enabled = false
		self.wasKilled = true
		if(self.goalTrigger) then Event_Remove(self.goalTrigger) end
		if(self.data.onDeath) then self.data.onDeath(self) end
	end
end


--? @shortdesc Spawns the units within an. Does nothing if the encounter has already been spawned.
--? @args Bool spawnStaggered
function Encounter:Spawn(spawnStaggered)
	--Don't do anything if the encounter is already spawned
	if(self.spawned) then return end
	
	Ai:Print("Spawning encounter: " .. self.data.name)
	
	self.spawned = true
	self.enabled = true
	if(spawnStaggered == nil) then spawnStaggered = false end
	
	if(not spawnStaggered) then
		--Spawn all units at once
		for k,unit in pairs(self.units) do
			self:SpawnUnit(unit)
		end
		
	else
		--Spawn first unit. Delay the rest
		local unit = self.units[1]
		
		self:SpawnUnit(unit)
		self.nextSpawned = 2 --used by staggeredSpawn to keep track of units
		
		Ai:AddStaggeredSpawnEncounter(self)
	end
	
	
	--Check for triggerOnSight/Engaged events.
	if(self.data.goal) then
		if SGroup_IsEmpty(self:GetSgroup()) == false then
			if self.data.triggerGoalOnSight then
				self.goalTrigger = Event_PlayerCanSeeElement(EventHandler_AssignEncounterGoal, {encounter = self, goalData = self.data.goal}, player1, self:GetSgroup(), ANY, self.data.triggerGoalDelay)
			elseif self.data.triggerGoalOnEngage then
				self.goalTrigger = Event_IsEngaged(EventHandler_AssignEncounterGoal, {encounter = self, goalData = self.data.goal}, self:GetSgroup(), ANY, 3, self.data.triggerGoalDelay)
			elseif self.data.triggerGoalOnAttacked then
				self.goalTrigger = Event_IsUnderAttack(EventHandler_AssignEncounterGoal, {encounter = self, goalData = self.data.goal}, self:GetSgroup(), ANY, 5.0, (scartype(self.data.triggerGoalOnAttacked) == ST_PLAYER and self.data.triggerGoalOnAttacked or nil), self.data.triggerGoalDelay)
			else
				self:SetGoal(self.data.goal)
			end
		else
			self:SetGoal(self.data.goal)
		end
	end
end

--Creates a new unit and adds it to the encounter
function Encounter:AddUnit(unitData)
	Ai:Print("Adding unit " .. (unitData.name ~= nil and unitData.name or "<noName>") .. "...")
	
	--Check to see if the unit meets the requirements to be added
	if (not AI_IsMatchingDifficulty(unitData.difficulty)) then
		Ai:Print("Ignoring unit based on difficulty.")
		return
	end
	
	if(not _PassesConditions(unitData.conditions)) then
		Ai:Print("Ignoring unit based on conditions.")
		return
	end		
		
	if unitData.commanderDivision ~= nil then
		if scartype(unitData.commanderDivision) == ST_TABLE then
			local __NoCDMatch = true
			for i=1, table.getn(unitData.commanderDivision) do
				if XP1_IsMatchingDivision(unitData.commanderDivision[i]) then
					__NoCDMatch = false
					break
				end
			end
			if __NoCDMatch then 
				Ai:Print("Ignoring unit based on deployed commander division")
				return 
			end
		else
			if(not XP1_IsMatchingDivision(unitData.commanderDivision)) then
				Ai:Print("Ignoring unit based on deployed commander division")
				return
			end
		end
	end
	
	
	if (self.wasKilled) then
		--Added a unit into an encounter that was previously killed. Needs to be added back into the encounter list.
		self.spawned = true
		self.wasKilled = false
		self.enabled = true
		Ai:AddEncounter(self)
	end
	
	local tempData = {}
	if(scartype(unitData) == ST_PBG) then
		tempData = {
			sbp = unitData,
		}
	elseif(scartype(unitData) == ST_TABLE) then
		tempData = unitData
	else
		fatal("Invalid unit data for encounter " .. self.data.name)
	end
	
	--Handle unique spawning (single unit per spawn point)
	if tempData.spawn == nil and self.data.uniqueSpawns and scartype(self.data.spawn) == ST_TABLE and #self.data.spawn > 1 then
		local i = World_GetRand(1, #self.data.spawn)
		tempData.spawn = self.data.spawn[i]
		table.remove(self.data.spawn, i)
	end
	
	--Take default values from encounter
	--TODO: Take all generic values from encounter.data table (without units), clone it and then iterate and assign new specific unit values.
	tempData.player = self.data.player
	tempData.spawn = tempData.spawn or self.data.spawn
	tempData.dynamicSpawnTarget = tempData.dynamicSpawnTarget or self.data.dynamicSpawnTarget
	tempData.backupSpawn = tempData.backupSpawn or self.data.backupSpawn
	tempData.moveTo = tempData.moveTo or self.data.moveTo
	tempData.attackMoveTo = tempData.attackMoveTo or self.data.attackMoveTo
	tempData.abilityBlacklist = tempData.abilityBlacklist or self.data.abilityBlacklist
	tempData.veterancyRank = tempData.veterancyRank or self.data.veterancyRank
	--Handle numSquads parameter
	if(tempData.numSquads == nil) then tempData.numSquads = 1 end
	
	
	for i=1, tempData.numSquads do
		if(i>1 and tempData.name ~= nil) then tempData.name = tempData.name .. i end
		
		local unit = Unit:Create(tempData, self)
		
		table.insert(self.units, unit)
		
		if(self.spawned) then
			self:SpawnUnit(unit)
		end
	end
end

function Encounter:SpawnUnit(unit)
	unit:Spawn()
	
	if (AI_IsEnabled(self.data.player)) then
		AI_LockSquads( self.data.player, unit.sgroup )
	end
	
	SGroup_AddGroup(self.sgroup, unit.sgroup)
	
	if(self.data.sgroups)then
		for k,v in pairs(self.data.sgroups) do 
			SGroup_AddGroup(v, self.sgroup)
		end	
	end
	
	--Update resource guidance for the goal
	self:UpdateResourceGuidance()
end


--? @shortdesc Creates encounter goal from goal data; goals determine unit objectives and behaviours.
--? @extdesc See: http://relicwiki/display/REL/Ai+Goal
--? @args GoalData goalData 
--? @result Void
function Encounter:SetGoal(goalData)
	-- clone before clear, so we can also accept our own goal.data 
	if goalData ~= nil then
		self.storedGoalData = Clone(goalData)
	end
	self:ClearGoal()
	
	if not self.enabled then
		Ai:Print("Encounter: " .. self.data.name .. " is disabled. Delaying goal: " .. self.storedGoalData.name)
		return
	end

	Ai:Print("Encounter: " .. self.data.name .. " setting goal: " .. self.storedGoalData.name)
	
	if(self.storedGoalData.name == "Defend") then
		self.goal = Ai.goals.DefendGoal:Create(self, self.storedGoalData)
	elseif(self.storedGoalData.name == "Attack") then
		self.goal = Ai.goals.AttackGoal:Create(self, self.storedGoalData)
	elseif(self.storedGoalData.name == "Move") then
		self.goal = Ai.goals.MoveGoal:Create(self, self.storedGoalData)
	elseif(self.storedGoalData.name == "Ability") then
		self.goal = Ai.goals.AbilityGoal:Create(self, self.storedGoalData)
	else
		fatal("Invalid goal name (" .. self.storedGoalData.name .. ")")
	end
end

--? @shortdesc Determines whether or not the encounter has an active and valid goal.
--? @result Bool
function Encounter:HasGoal()
	return self.goal ~= nil and self.goal.objective ~= nil and AIObjective_IsValid(self.goal.objective)
end

--? @shortdesc Clears the current goal.
--? @result Void
function Encounter:ClearGoal()
	if(self.goal) then
		if(self.goal.objective ~= nil) then
			local objective = self.goal.objective
			self.goal.objective = nil
			if (AIObjective_IsValid(objective)) then
				AIObjective_Notify_ClearCallbacks(objective)
				AIObjective_Cancel(objective)
			end
		end
		self.goal:OnCanceled()
	end
	
	self.goal = nil
	
	--Remove any event triggers, if present.
	if(self.goalTrigger) then
		Event_Remove(self.goalTrigger)
	end
end

--? @shortdesc Removes an encounter's onSight/onEngage event and immediately starts its goal.
--? @extdesc Only works if the encounter has both data.goal, and a valid goal trigger
--? @result Void
function Encounter:TriggerGoal()
	if(self.data.goal and self.goalTrigger) then
		Event_Remove(self.data.goalTrigger)
		self:SetGoal(self.data.goal)
	end
end

--? @shortdesc If encounter has a goal, but no currently running objective, restarts the goal.
--? @extdesc Returns true if goal was restarted, false otherwise.
--? @result Bool
function Encounter:RestartGoal()
	if (self.storedGoalData and Util_HasPosition(self.storedGoalData.target) and (not self:Goal_HasValidObjective()) and SGroup_IsAlive(self.sgroup)) then
		-- StoredGoalData will be used. Assuming self.goal.data is equivalent to self.storedGoalData.
		self:SetGoal()
		return true
	end
	return false
end

--? @shortdesc Sets the goal data for the encounter. If encounter has a goal with a running objective, updates the goal.
--? @extdesc See: http://relicwiki/display/REL/Ai+Goal
--? @extdesc Use GetGoalData() to get 
--? @args GoalData goalData 
--? @result Void
function Encounter:UpdateGoal(goalData)
	if goalData ~= nil then
		self.storedGoalData = Clone(goalData)
	end

	if (self.storedGoalData and self:Goal_HasValidObjective()) then
		self.goal:UpdateGoalData(self.storedGoalData)
	end
end

--? @shortdesc Gets clone of current goal data.  May be nil.
--? @result GoalData
function Encounter:GetGoalData()
	return Clone(self.storedGoalData)
end

--? @shortdesc Gets the encounter's sgroup. Caution: sgroup may be empty
--? @result SGroup sgroup
function Encounter:GetSgroup()
	return self.sgroup
end

--? @shortdesc Starts encounter running (encounters are enabled by default) if it was disabled previously.
--? @result Void
function Encounter:Enable()
	if self.enabled then return end
	
	if not self.spawned then fatal("Attempted to enable an encounter with no spawned squads") end

	self.enabled = true
	
	--For skirmishAI
	if(self.storedGoalData) then
		Ai:Print("Enabling encounter " .. self.data.name)
		self:SetGoal()
	end
end

--? @shortdesc Stops running the encounter and clears the current goal.
--? @result Void
function Encounter:Disable()
	if not self.enabled then return end
	self.enabled = false
	
	--For skirmishAI
	if(self.goal) then
		Ai:Print("Disabling encounter " .. self.data.name)
		-- self.storedGoalData expected to be equivalent to self.goal.data
		self:ClearGoal()
	end
	
	Cmd_Stop(self.sgroup)
end


--? @shortdesc Removes all encounter units that belong to the given sgroup
--? @result Void
function Encounter:RemoveUnitsBySgroup(squadgroup)
	for i,unit in ipairs(self.units) do
		if(SGroup_ContainsSGroup(unit.sgroup, squadgroup, ANY)) then
			self:RemoveUnit(i)
		end
	end
end

--Find and removes a unit from an encounter based on the squad.
function Encounter:RemoveUnitBySquad(squad)
	for i,unit in ipairs(self.units) do
		if SGroup_ContainsSquad(unit.sgroup, Squad_GetGameID(squad)) then
			self:RemoveUnit(i)
		end
	end
end

function Encounter:RemoveUnit(pos)
	Ai:Print("Removed unit[" .. pos .. "]: " .. self.units[pos].data.name .. " from encounter: " .. self.data.name)
	
	SGroup_RemoveGroup(self.sgroup, self.units[pos].sgroup)
	
	table.remove(self.units, pos)
	
	self:UpdateResourceGuidance()
	
	--Remove the onDeath event, if any
	if(#self.units == 0) then
		self.data.onDeath = nil
	end
end

--? @shortdesc Adds an sgroup to an encounter
--? @result Void
function Encounter:AddSgroup(squadgroup, name, onDeath)
	if(name == nil) then name = "addedSgroup_" .. (#self.units+1) end

	if (not self:IsAlive()) then
		self.spawned = true
		Ai:AddEncounter(self)
	end

	for i=1, SGroup_CountSpawned(squadgroup) do
		local unitData = {}
		unitData.name = name
		unitData.sbp = Squad_GetBlueprint( SGroup_GetSpawnedSquadAt(squadgroup, i) )
		
		local unit = Unit:Create(unitData, self)
		unit.sgroup = SGroup_Create("")
		SGroup_Add(unit.sgroup, SGroup_GetSpawnedSquadAt(squadgroup, i))
		
		if(onDeath ~= nil) then unit:SetOnDeath(onDeath) end		
		
		table.insert(self.units, unit)
		SGroup_AddGroup(self.sgroup, unit.sgroup)
	end
	
	self:UpdateResourceGuidance()
end



--Returns whether or not this encounter is currently enabled in the update loop
function Encounter:IsEnabled()
	return self.enabled
end

--Returns whether or not the encounter is alive
function Encounter:IsAlive()
	return self.sgroup and SGroup_CountSpawned(self.sgroup) > 0
end


--? @shortdesc Clears the encounter's onDeath callback. If includeUnits is set to true, it clears onDeath callbacks for units as well.
--? @args Bool includeUnits
--? @result Void
function Encounter:RemoveOnDeath(includeUnits)
	self.data.onDeath = nil
	
	if(includeUnits) then
		for k,unit in pairs(self.units) do
			unit:SetOnDeath(nil)
		end
	end
end

--? @shortdesc Sets a new onDeath callback for the encounter
--? @args ScarFn func 
--? @result Void
function Encounter:SetOnDeath(func)
	self.data.onDeath = func
end



--[[
-- Encounter: private functions
]]--

function Encounter:__OnLoadRestart()
	assert(self ~= nil, "Invalid nil encounter")
	assert(self.data ~= nil, "Encounter missing data, can't reload.")
	
	if (AI_IsEnabled(self.data.player)) then
		if (self.sgroup ~= nil) then
			AI_LockSquads(self.data.player, self.sgroup)
		end
	end
	
	if (self.goal == nil) then
		return -- Encounter didn't have goal, nothing to do
	end
	
	local hadObjective = self.goal.objective ~= nil

	-- IMPORTANT: on load, objective may refer to handles that no longer exist, so we *MUST* clear them.
	self.goal.objective = nil

	if (hadObjective and self.enabled and self:IsAlive()) then
		Ai:Print("RESTARTED ENCOUNTER:"..tostring(self.data.name))
		self:RestartGoal()
	else
		Ai:Print("Found Inactive Encounter (did nothing):"..tostring(self.data.name))
	end
end

function Encounter:__OnAIMigrated(player)
	assert(self ~= nil, "Invalid nil encounter")
	assert(self.data ~= nil, "Encounter missing data, can't migrate.")
	assert(self.data.player ~= nil, "Encounter missing player, can't migrate.")
	
	if (self.data.player ~= player) then
		return -- Encounter player didn't migrate, nothing to do
	end
	
	if (AI_IsEnabled(self.data.player)) then
		if (self.sgroup ~= nil) then
			AI_LockSquads(self.data.player, self.sgroup)
		end
	else
		-- IMPORTANT: if AI isn't enabled on this machine now, objective might refer to handles that no longer exist, so we *MUST* clear them.
		self.goal.objective = nil
	end

	-- need to restart goal (if there is one) to enable objective on machine with AI
	if (self.enabled and self:IsAlive()) then
		Ai:Print("RESTARTED ENCOUNTER:"..tostring(self.data.name))
		self:RestartGoal()
	else
		Ai:Print("Found Inactive Encounter (did nothing):"..tostring(self.data.name))
	end
end


--[[
-- Encounter:Goal_* guidance functions
]]--

--? @shortdesc Set the goal's OnSuccess callback.
--? @result Void
function Encounter:SetGoalOnSuccess(func)
	if(not (scartype(func) == ST_FUNCTION or scartype(func) == ST_NIL)) then
		fatal("Attempted to set an invalid type on a Goal's OnSuccess callback (" .. scartype_tostring(func) .. ")")
	elseif(self.goal) then
		self.goal.data.onSuccess = func
	end
end

--Updates what resources the ai_goal can work with.
function Encounter:UpdateResourceGuidance()
	if (self.goal and self.goal.objective ~= nil) then
		if (AIObjective_IsValid(self.goal.objective)) then
			self.goal:UpdateResourceGuidance()
		else
			self.goal.objective = nil
		end
	end
end


--Returns True if all the conditions in the conditionList are true.
function _PassesConditions(conditionList)
	if(conditionList == nil) then
		return true
	else
		if(scartype(conditionList) ~= ST_TABLE) then
			conditionList = {conditionList}
		end
		
		for k,condition in pairs(conditionList) do
			if(scartype(condition) == ST_BOOLEAN and condition == false) then
				return false
			elseif(scartype(condition) == ST_FUNCTION and condition() ~= true) then
				return false
			end
		end
		return true
	end
end

-- Determine if encounter has a valid goal and objective; returns true if goal and objective are valid, false otherwise.
function Encounter:Goal_HasValidObjective()
	return (self.goal and self.goal.objective ~= nil and AIObjective_IsValid(self.goal.objective))
end



------------------------------------------------
-- DEBUG
------------------------------------------------
--Debug. Kills half of the enemy entities in all encounters belonging to 'player'.
function Encounter_KillHalf(player)
	for k,enc in pairs(AI_GetActiveEncounters()) do
		if enc.data.player == player then
			for i,unit in pairs(enc.units) do
				if(SGroup_CountSpawned(unit.sgroup) > 0) then
					local count = SGroup_TotalMembersCount(unit.sgroup, true)
					local targetCount = math.floor(count/2)
					
					local squad = SGroup_GetSpawnedSquadAt(unit.sgroup,1)
					for j=count-1, 0, -1 do
						if count > targetCount then
							local entity = Squad_EntityAt(squad, j)
							if Entity_IsOfType(entity, "infantry") then
								Entity_Kill(entity)
								count = count-1
							end
						else
							break
						end
					end				
				end
			end
		end
	end
end
