--? @group scardoc;Encounter

Ai = Ai or fatal("Ai not loaded properly")
Ai.goals = Ai.goals or {}
Ai.goals.BaseGoal = {}
Ai.goals.DefaultGoalData = Ai.goals.DefaultGoalData or {} -- preserve data on soft-reload

local BaseGoal = Ai.goals.BaseGoal

BaseGoal.data = nil
BaseGoal.encounter = nil

-------------------------
-- metatable common functions
-------------------------

function _AIDefaultGoalData_metaAbilityBlackList_findValueByValueInTable(val, tbl)
	if (val == nil) then
		return nil
	end
	
	for k, v in pairs(tbl) do
		if (val == v) then
			return v
		end
	end
			
	return nil
end
	
function _AIDefaultGoalData_metaAbilityControlsList_findValueByValueInTable(val, tbl)
	if (val == nil or scartype(val) ~= ST_TABLE) then
		return nil
	end
	
	for k, v in pairs(tbl) do
		if (val.abilityPBG == v.abilityPBG) then
			return v
		end
	end
			
	return nil
end
	
function _AIDefaultGoalData_metaTacticControlsList_findValueByValueInTable(val, tbl)
	if (val == nil or scartype(val) ~= ST_TABLE) then
		return nil
	end
	
	for k, v in pairs(tbl) do
		if (val.tacticType == v.tacticType) then
			return v
		end
	end
	
	return nil
end

-------------------------
-------------------------

function _AIDefaultGoalData_SetDefaultGoalDataMetaData(goalData)
	if (goalData.abilityBlackList ~= nil and scartype(goalData.abilityBlackList) == ST_TABLE) then
		local mtbl = getmetatable(goalData.abilityBlackList) or {}
		mtbl._findValueByValueInTable = _AIDefaultGoalData_metaAbilityBlackList_findValueByValueInTable
		setmetatable(goalData.abilityBlackList, mtbl)
	end
	if (goalData.abilityControlsList ~= nil and scartype(goalData.abilityControlsList) == ST_TABLE) then
		local mtbl = getmetatable(goalData.abilityControlsList) or {}
		mtbl._findValueByValueInTable = _AIDefaultGoalData_metaAbilityControlsList_findValueByValueInTable
		setmetatable(goalData.abilityControlsList, mtbl)
	end
	if (goalData.tacticControlsList ~= nil and scartype(goalData.tacticControlsList) == ST_TABLE) then
		local mtbl = getmetatable(goalData.tacticControlsList) or {}
		mtbl._findValueByValueInTable = _AIDefaultGoalData_metaTacticControlsList_findValueByValueInTable
		setmetatable(goalData.tacticControlsList, mtbl)
	end
end

function _AIDefaultGoalData_ApplyModifiers(goalData, modifierTable)

	if (goalData == nil or scartype(goalData) ~= ST_TABLE or modifierTable == nil or scartype(modifierTable) ~= ST_TABLE) then
		return
	end
	
	-- general case
	for k, v in pairs(goalData) do
		local k_Mult = tostring(k).."_Multiplier"
		local v_Mult = modifierTable[k_Mult]
		
		if (v_Mult ~= nil and scartype(v_Mult) == ST_NUMBER) then
			if (scartype(v) == ST_NUMBER) then
				goalData[k] = v * v_Mult
			elseif (scartype(v) == ST_TABLE) then
				for kt, vt in pairs(v) do
					if (scartype(vt) == ST_NUMBER) then
						goalData[k][kt] = vt * v_Mult
					end
				end
			end
		end
	end

	-- special case - fallback
	_AIDefaultGoalData_ApplyModifiers(goalData.fallbackParams, modifierTable.fallbackParams)
	
	-- special case - ability
	if (goalData.abilityControlsList ~= nil and modifierTable.abilityControlsList ~= nil) then
		for k, v in pairs(goalData.abilityControlsList) do
			local m_v = _AIDefaultGoalData_metaAbilityControlsList_findValueByValueInTable(v, modifierTable.abilityControlsList)

			_AIDefaultGoalData_ApplyModifiers(v, m_v)
		end
	end
	
	-- special case - tactic
	if (goalData.tacticControlsList ~= nil and modifierTable.tacticControlsList ~= nil) then
		for k, v in pairs(goalData.tacticControlsList) do
			local m_v = _AIDefaultGoalData_metaTacticControlsList_findValueByValueInTable(v, modifierTable.tacticControlsList)

			_AIDefaultGoalData_ApplyModifiers(v, m_v)
		end
	end
end


--[[
-- Default Goal Data Interface
]]--

--? @shortdesc Adjust default goal data.  Sets the default GoalData to the current defaults plus additionalDefaultGoalData; any values specified are used for unspecified encounter goal values.
--? @args Table additionalDefaultGoalData
function AIBaseGoal_AdjustDefaultGoalData(additionalDefaultGoalData)
	Ai:Print("===============================================")
	Ai:Print("Adjusting BaseGoal default data...")

	local additionalGoalData = Clone(additionalDefaultGoalData)
	_AIDefaultGoalData_SetDefaultGoalDataMetaData(additionalGoalData)
	local DefaultGoalData = Ai.goals.DefaultGoalData
	DefaultGoalData.defaultGoalData = MergeCloneTable(DefaultGoalData.defaultGoalData, additionalGoalData)

	Ai:Print("-----------------------------------------------")
	Ai:Print("additionalDefaultGoalData")
	Ai:Print(additionalGoalData)
	Ai:Print("-----------------------------------------------")
	DebugPrintGoals(DefaultGoalData.defaultGoalData, DefaultGoalData.overrideGoalData, DefaultGoalData.modifyGoalData)
	Ai:Print("===============================================")
end

--? @shortdesc Set default goal data.  defaultGoalData is cloned; any values specified are used for unspecified encounter goal values.
--? @args Table defaultGoalData
function AIBaseGoal_SetDefaultGoalData(defaultGoalData)
	Ai:Print("===============================================")
	Ai:Print("Setting BaseGoal default data...")

	local DefaultGoalData = Ai.goals.DefaultGoalData
	DefaultGoalData.defaultGoalData = Clone(defaultGoalData)
	_AIDefaultGoalData_SetDefaultGoalDataMetaData(DefaultGoalData.defaultGoalData)

	DebugPrintGoals(DefaultGoalData.defaultGoalData, DefaultGoalData.overrideGoalData, DefaultGoalData.modifyGoalData)
	Ai:Print("===============================================")
end

--? @shortdesc Set override goal data.  overrideGoalData is cloned; any values specified are used for encounter goal values.
--? @args Table overrideGoalData
function AIBaseGoal_SetOverrideGoalData(overrideGoalData)
	Ai:Print("===============================================")
	Ai:Print("Setting BaseGoal override data...")

	local DefaultGoalData = Ai.goals.DefaultGoalData
	DefaultGoalData.overrideGoalData = Clone(overrideGoalData)
	_AIDefaultGoalData_SetDefaultGoalDataMetaData(DefaultGoalData.overrideGoalData)

	DebugPrintGoals(DefaultGoalData.defaultGoalData, DefaultGoalData.overrideGoalData, DefaultGoalData.modifyGoalData)
	Ai:Print("===============================================")
end

--? @shortdesc Set modify goal data.  modifyGoalData is cloned; values specified via keyname_Multiplier are used for the numeric keyname encounter goal value.
--? @args Table modifyGoalData
function AIBaseGoal_SetModifyGoalData(modifyGoalData)
	Ai:Print("===============================================")
	Ai:Print("Setting BaseGoal modify data...")

	local DefaultGoalData = Ai.goals.DefaultGoalData
	DefaultGoalData.modifyGoalData = Clone(modifyGoalData) 

	DebugPrintGoals(DefaultGoalData.defaultGoalData, DefaultGoalData.overrideGoalData, DefaultGoalData.modifyGoalData)
	Ai:Print("===============================================")
end


--[[
-- Goal Initialize
]]--

function AIDefaultGoalData_Initialize()
	local DefaultGoalData = Ai.goals.DefaultGoalData

	print("Initializing Default Goal Data...")

	if(DefaultGoalData.initialized)then
		return
	end

	DefaultGoalData.defaultGoalData = 
	{
		range = 20,
		leashRange = nil,
		abilityControlsList = {},
		tacticControlsList = {},
		abilityBlackList = {},
		tacticTargetPreference = AITacticTargetPreference_None,
		tacticCloseGround = false,
		garrison = false,
		garrisonIdle = false,
		safeMoveWeight = 1,
		movePathLengthFactor = -1,
		maxAttackers = -1,
		attackMove = false,
		attackEngagementMove = true,
		fallbackParams = nil,
		retaliateAttacks = true,
		retaliateAttackRange = nil,
		
		-- DEPRECATED: remove at first opportunity -- defaults should be closer to Skirmish behaviours; 
		-- added this because campaign couldn't handle when pickup/teamweapon capture/recrew started working great. ;-)
		pickupWeapons = false,
	}
	_AIDefaultGoalData_SetDefaultGoalDataMetaData(DefaultGoalData.defaultGoalData)
	
	DefaultGoalData.overrideGoalData = 
	{
		range = nil,
		leashRange = nil,
		abilityControlsList = nil,
		tacticControlsList = nil,
		abilityBlackList = nil,
		tacticTargetPreference = nil,
		tacticCloseGround = nil,
		garrison = nil,
		garrisonIdle = nil,
		safeMoveWeight = nil,
		movePathLengthFactor = nil,
		maxAttackers = nil,
		attackMove = nil,
		attackEngagementMove = nil,
		fallbackParams = nil,
		retaliateAttacks = nil,
		retaliateAttackRange = nil,
	}
	_AIDefaultGoalData_SetDefaultGoalDataMetaData(DefaultGoalData.overrideGoalData)
	
	DefaultGoalData.modifyGoalData = 
	{
		range_Multiplier = 1,
		leashRange_Multiplier = 1,
		safeMoveWeight_Multiplier = 1,
		movePathLengthFactor_Multiplier = 1,
		maxAttackers_Multiplier = 1,
		coordinatedMoveRadius_Multiplier = 1,
		abilityControlsList = {},
		tacticControlsList = {},
		fallbackParams = 
		{
			thresholds_Multiplier = 1,
			globalPercentage_Multiplier = 1,
		},
	} 
	
	DefaultGoalData.initialized = true
end

--[[ Init ]]
Scar_AddInit( AIDefaultGoalData_Initialize )


----------------------------------------------------------------------------------------------------------------------------------------------------------
local _mergeCloneTableStack = {}

function MergeCloneTable(defaultTable, overrideTable)
	
	if (defaultTable == nil and overrideTable == nil) then
		return nil
	elseif (defaultTable == nil) then
		return Clone(overrideTable)
	elseif (overrideTable == nil) then
		return Clone(defaultTable)
	end
	
	if( DoesTableContain(_mergeCloneTableStack, defaultTable) or DoesTableContain(_mergeCloneTableStack, overrideTable) ) then
		fatal( "Recursive Merge Cloning Error Detected." )
	end    
    
	table.insert( _mergeCloneTableStack, defaultTable ) -- push
	table.insert( _mergeCloneTableStack, overrideTable ) -- push
	
	local defaultMetatable = getmetatable(defaultTable)
	local defaultFindEntry = defaultMetatable and defaultMetatable._findValueByValueInTable or nil

	local tbl = {}
	for k, dv in pairs(defaultTable) do
		local ov = nil
		
		if (defaultFindEntry ~= nil) then
			ov = defaultFindEntry(dv, overrideTable)
		else
			ov = overrideTable[k]
		end

		if (ov ~= nil and scartype(dv) ~= scartype(ov)) then
			print( "Warning in MergeCloneTable - key("..tostring(k)..") - default value("..tostring(dv)..") type("..tostring(type(dv))..
					") differs from override value("..tostring(ov)..") type("..tostring(type(ov))..")")
		end
			
		if (scartype(dv) ~= ST_TABLE)then 
			if (ov == nil) then
				tbl[k] = dv
			else
				tbl[k] = Clone(ov)
			end
		else
			tbl[k] = MergeClone(dv, ov)
		end
	end

	for k, ov in pairs(overrideTable) do
		local tv = nil
		if (defaultFindEntry ~= nil) then
			tv = defaultFindEntry(ov, tbl)
		else
			tv = tbl[k]
		end
	
		-- if tbl has a value, we created it above, so it's already merge-cloned
		if (tv == nil) then
			if (defaultFindEntry ~= nil) then
				table.insert(tbl, Clone(ov))
			else
				tbl[k] = Clone(ov)
			end
			
		end
	end
	
	setmetatable(tbl, MergeClone(getmetatable(defaultTable),getmetatable(overrideTable)))
		
	table.remove(_mergeCloneTableStack,table.getn(_mergeCloneTableStack)) -- pop
	table.remove(_mergeCloneTableStack,table.getn(_mergeCloneTableStack)) -- pop
	
	return tbl
end

--? @shortdesc Merge clones two table (recursively) into a single table combining into a new table allowing for unadulterated use of the data
--? @args Table defaultTable, Table overrideTable
--? @result Table 
function MergeClone(defaultTable, overrideTable)
	if( scartype(defaultTable) == ST_TABLE or scartype(overrideTable) == ST_TABLE ) then
		return MergeCloneTable(defaultTable, overrideTable)
	elseif( overrideTable == nil ) then
		return Clone(defaultTable)
	else
		return Clone(overrideTable)
	end
end

---------------

function CloneGoal(goal)
	if (goal ~= nil) then
		local clonedGoal = Clone(goal)
		clonedGoal.objective = nil
		clonedGoal.objectiveID = -1;
		clonedGoal.callbackFn = nil;
		
		return clonedGoal
	end
	return nil
end

----------------------------------------------------------------------------------------------------------------------------------------------------------

function DebugPrintGoals(defaultGoalData, overrideGoalData, modifyGoalData)
	Ai:Print("GoalData defaults/overrides/modifiers. Use AI_SetDebugLevel(2) to view details.")
	Ai:Print("-----------------------------------------------", 2)
	Ai:Print("defaultGoalData", 2)
	Ai:Print(defaultGoalData, 2)
	Ai:Print("overrideGoalData", 2)
	Ai:Print(overrideGoalData, 2)
	Ai:Print("modifyGoalData", 2)
	Ai:Print(modifyGoalData, 2)
	Ai:Print("-----------------------------------------------", 2)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------


--Creates the goal. Receives data table
function BaseGoal:Create(encounter, goalData, defaultGoalData, overrideGoalData, modifyGoalData)
	local DefaultGoalData = Ai.goals.DefaultGoalData
	defaultGoalData = defaultGoalData or DefaultGoalData.defaultGoalData or {}
	overrideGoalData = overrideGoalData or DefaultGoalData.overrideGoalData or {}
	modifyGoalData = modifyGoalData or DefaultGoalData.modifyGoalData or {}

	local goal = CloneGoal(self)
	
	Ai:Print("Applying GoalData defaults/overrides/modifiers. Use AI_SetDebugLevel(2) to view details.")
	Ai:Print("===============================================", 2)
	Ai:Print("BaseGoal:Create:defaultGoalData", 2)
	Ai:Print(defaultGoalData, 2)
	Ai:Print("BaseGoal:Create:overrideGoalData", 2)
	Ai:Print(overrideGoalData, 2)
	Ai:Print("BaseGoal:Create:modifyGoalData", 2)
	Ai:Print(modifyGoalData, 2)
	Ai:Print("BaseGoal:Create:goalData", 2)
	Ai:Print(goalData, 2)

	Ai:Print("Applying DEFAULT GoalData...")
	goal.data = MergeClone(defaultGoalData, goalData)

	Ai:Print("BaseGoal:Create:defaults+goalData", 2)
	Ai:Print(goal.data, 2)

	Ai:Print("Applying OVERRIDE GoalData...")
	goal.data = MergeClone(goal.data, overrideGoalData)
	
	Ai:Print("BaseGoal:Create:goalData+override", 2)
	Ai:Print(goal.data, 2)
	
	goal.encounter = encounter
	goal.objective = nil
	goal.objectiveID = EventRule_GetNextUniqueRuleID();
	goal.callbackFn = nil -- create entry to reference from within function
	goal.callbackFn = function(objectiveID, notificationType, objectiveStage) 
						if (objectiveID == goal.objectiveID and notificationType == AIObjectiveNotification_Success) then
							goal:OnSuccess(goal.encounter)
						elseif (objectiveID == goal.objectiveID and notificationType == AIObjectiveNotification_Failure) then
							goal:OnFailure(goal.encounter) 
						elseif (objectiveID == goal.objectiveID and notificationType == AIObjectiveNotification_Transition) then
							goal:OnTransition(goal.encounter, objectiveStage) 
						end 
					end
	UnsavedEventRule_AddRuleIDEvent(goal.callbackFn, goal.objectiveID, GE_AIPlayer_ObjectiveNotification)
	
	goal:__InitializeGoalDataDefaults(encounter)
	
	Ai:Print("Applying MODIFIERS to GoalData...")
	_AIDefaultGoalData_ApplyModifiers(goal.data, modifyGoalData)
	
	Ai:Print("BaseGoal:Create:goalData+modifiers", 2)
	Ai:Print(goal.data, 2)
	Ai:Print("===============================================", 2)
	
	
	return goal
end

function BaseGoal:UpdateGoalData(goalData, defaultGoalData, overrideGoalData, modifyGoalData)
	local DefaultGoalData = Ai.goals.DefaultGoalData
	defaultGoalData = defaultGoalData or DefaultGoalData.defaultGoalData
	overrideGoalData = overrideGoalData or DefaultGoalData.overrideGoalData
	modifyGoalData = modifyGoalData or DefaultGoalData.modifyGoalData

	Ai:Print("Applying GoalData defaults/overrides/modifiers. Use AI_SetDebugLevel(2) to view details.")
	Ai:Print("===============================================", 2)
	Ai:Print("BaseGoal:UpdateGoalData:defaultGoalData", 2)
	Ai:Print(defaultGoalData, 2)
	Ai:Print("BaseGoal:UpdateGoalData:overrideGoalData", 2)
	Ai:Print(overrideGoalData, 2)
	Ai:Print("BaseGoal:UpdateGoalData:modifyGoalData", 2)
	Ai:Print(modifyGoalData, 2)
	Ai:Print("BaseGoal:UpdateGoalData:goalData", 2)
	Ai:Print(goalData, 2)

	self.data = MergeClone(defaultGoalData, goalData)

	Ai:Print("BaseGoal:UpdateGoalData:defaults+goalData", 2)
	Ai:Print(self.data)

	self.data = MergeClone(self.data, overrideGoalData)
	
	Ai:Print("BaseGoal:UpdateGoalData:goalData+override", 2)
	Ai:Print(self.data)
	
	self:__InitializeGoalDataDefaults(self.encounter)
	
	_AIDefaultGoalData_ApplyModifiers(self.data, modifyGoalData)
	
	Ai:Print("BaseGoal:UpdateGoalData:goalData+modifiers", 2)
	Ai:Print(self.data)
	Ai:Print("===============================================", 2)
	
	if (self.objective ~= nil and AIObjective_IsValid(self.objective)) then
		self:SetupSkirmishAI()
	end
end

--Setup Encounter specific data for created AIObjective based on common goal data
-- NOTE: only call from sub-class after objective is created, and only for enabled AI
function BaseGoal:SetupEncounterSkirmishAI()
	assert(self.objective ~= nil)
	assert(AI_IsEnabled(self.encounter.data.player))
	assert(AIObjective_IsValid(self.objective))
		
	AIObjective_SetName(self.objective, self.encounter.data.name)

	-- Resource Guidance -- encounters update this
	AIObjective_ResourceGuidance_SquadGroup(self.objective, self.encounter.sgroup)
end

--Setup created AIObjective based on common goal data
-- NOTE: only call from sub-class after objective is created, and only for enabled AI
function BaseGoal:SetupSkirmishAI()
	assert(self.objective ~= nil)
	assert(AI_IsEnabled(self.encounter.data.player))
	assert(AIObjective_IsValid(self.objective))
	
	-- Target Guidance
	BaseGoal_SetupObjective_Target(self.objective, self.data.target, self.data.range, self.data.leashRange, self.data.retaliateAttacks, self.data.retaliateAttackRange)
	
	-- Tactics / Abilities Guidance
	BaseGoal_SetupObjective_Tactics(self.objective, self.data, self.data.abilityControlsList, self.data.tacticControlsList, self.encounter.units, self.encounter.sgroup)
	
	-- Fallback Guidance
	BaseGoal_SetupObjective_FallbackParams(self.objective, self.data.fallbackParams)

	-- Move Guidance
	AIObjective_MoveGuidance_EnableAggressiveMove(self.objective, self.data.attackMove and true or false)
	if (scartype(self.data.safeMoveWeight) == ST_NUMBER) then
		AIObjective_MoveGuidance_SetSafePathingWeight(self.objective, self.data.safeMoveWeight)
	else
		AIObjective_MoveGuidance_ResetSafePathingWeight(self.objective)
	end
	if (scartype(self.data.movePathLengthFactor) == ST_NUMBER) then
		AIObjective_MoveGuidance_SetPathingLengthFactor(self.objective, self.data.movePathLengthFactor)
	else
		AIObjective_MoveGuidance_ResetPathingLengthFactor(self.objective)
	end
	if (scartype(self.data.coordinatedMoveRadius) == ST_NUMBER) then
		AIObjective_MoveGuidance_SetSquadCoherenceRadius(self.objective, self.data.coordinatedMoveRadius)
	end

	-- Engagement Guidance
	AIObjective_EngagementGuidance_EnableAggressiveEngagementMove(self.objective, self.data.attackEngagementMove and true or false)
	if (self.data.maxTime) then
		AIObjective_EngagementGuidance_SetMaxEngagementTime(self.objective, self.data.maxTime)
	end
	AIObjective_EngagementGuidance_SetCoordinatedSetup(self.objective, self.data.coordinatedSetup ~= false)
	AIObjective_EngagementGuidance_SetAllowReturnToPreviousStages(self.objective, self.data.engagementAllowReturnToPreviousStages)

	-- Combat Guidance
	AIObjective_CombatGuidance_EnableCombatGarrison(self.objective, self.data.garrison and true or false)
	
	-- needed to enable callbacks	
	AIObjective_Notify_SetPlayerEventObjectiveID(self.objective, self.objectiveID)
end

--Skirmish AI goal success callback
function BaseGoal:OnSuccess(encounter)
	self.objective = nil  -- onSuccess is a final message; can't assume objective is valid now (could be partial destructed)
	EventRule_RemoveRuleIDEvent( self.callbackFn, self.objectiveID );
	Ai:Print("Encounter " .. encounter.data.name .. " has succeeded.")
	
	if(self.data.onSuccess) then
		Ai:Print("\t\tCalling onSuccess function...")
		self.data.onSuccess(encounter)
	end
end

--Skirmish AI goal failure callback
function BaseGoal:OnFailure(encounter)
	self.objective = nil  -- onFailure is a final message; can't assume objective is valid now (could be partial destructed)
	EventRule_RemoveRuleIDEvent( self.callbackFn, self.objectiveID );
	Ai:Print("Encounter " .. encounter.data.name .. " has failed.")
	
	if(self.data.onFailure) then
		Ai:Print("\t\tCalling onFailure function...")
		self.data.onFailure(encounter)
	end
end

--Skirmish AI goal was canceled
function BaseGoal:OnCanceled()
	self.objective = nil  -- onCanceled can't assume objective is valid beyond now
	EventRule_RemoveRuleIDEvent( self.callbackFn, self.objectiveID );
	self.callbackFn = nil

	if(self.data.onCanceled) then
		self.data.onCanceled()
	end
end

--Skirmish AI goal transition callback
function BaseGoal:OnTransition(encounter, objectiveStage)
	if(self.data.onTransition) then
		self.data.onTransition(encounter, objectiveStage)
	end
end

function BaseGoal:__InitializeGoalDataDefaults(encounter)
	--[[ Set defaults ]]
	self.data.target = self.data.target or encounter.sgroup

	if (self.data.attackEngagementMove == nil) then
		self.data.attackEngagementMove = true
	end
	
	self.data.tacticTargetPreference = self.data.tacticTargetPreference or AITacticTargetPreference_None

	if (scartype(self.data.tacticCoverPriority) == ST_BOOLEAN) then
		self.data.tacticCoverPriority = self.data.tacticCoverPriority and 1000 or -1
	end
	
	if (scartype(self.data.pickupWeapons) == ST_BOOLEAN) then
		self.data.pickupWeapons = self.data.pickupWeapons and 1000 or -1
	end
	
	if (self.data.fallbackParams ~= nil) then
		if (self.data.fallbackParams.thresholdType == nil) then
			self.data.fallbackParams.thresholdType = Threshold_PercentageHealth
		end
		if (self.data.fallbackParams.globalPercentage ~= nil and self.data.fallbackParams.globalPercentage > 1.0) then
			self.data.fallbackParams.globalPercentage = self.data.fallbackParams.globalPercentage / 100
		end
	end

	--range
	if scartype(self.data.range) == ST_MARKER then
		self.data.range = Marker_GetProximityRadius(self.data.range)
	end
	
	--if the range was not defined, try getting it from the target
	if (self.data.range == nil) then
		if (scartype(self.data.target) == ST_MARKER and Marker_GetProximityType(self.data.target) == PT_Circle) then
			self.data.range = Marker_GetProximityRadius(self.data.target)
		else
			self.data.range = 20.0
		end
	end
	self.data.range = math.max(10, self.data.range)
	
	
	--leashRange
	if(scartype(self.data.leashRange) == ST_MARKER) then
		self.data.leashRange = math.max(5, Marker_GetProximityRadius(self.data.leashRange))
	end
	
	if (self.data.engagementAllowReturnToPreviousStages == nil) then
		self.data.engagementAllowReturnToPreviousStages = false
	end
	
	if(self.data.retaliateAttacks == nil) then
		self.data.retaliateAttacks = true
	end
	
	if(self.data.retaliateAttackRange == nil) then
		self.data.retaliateAttackRange = 121
	end
	
end

--[[ SETUP AI Helper Function]]--

-- for internal use only 
function BaseGoal_SetupObjective_Target(objective, target, radius, leashRadius, retaliateAttacks, retaliateAttackRange)
	assert(objective ~= nil)
	assert(AIObjective_IsValid(objective))
	
	if (scartype(target) == ST_SQUAD) then
		AIObjective_TargetGuidance_SetTargetSquad(objective, target)
	elseif (scartype(target) == ST_ENTITY) then
		AIObjective_TargetGuidance_SetTargetEntity(objective, target)
	elseif (scartype(target) == ST_SGROUP and  SGroup_CountSpawned(target) >= 1) then
		AIObjective_TargetGuidance_SetTargetSquad(objective, SGroup_GetSpawnedSquadAt(target, 1))
	elseif (scartype(target) == ST_EGROUP and EGroup_CountSpawned(target) >= 1) then
		AIObjective_TargetGuidance_SetTargetEntity(objective, EGroup_GetSpawnedEntityAt(target, 1))
	else
		AIObjective_TargetGuidance_SetTargetPosition(objective, Util_GetPosition(target))
	end	
	
	if (radius) then -- if range not set here; leave to previous/default value
		AIObjective_TargetGuidance_SetTargetArea(objective, radius)
	end
	if (leashRadius) then -- if leash not set here; leave to previous/default value
		AIObjective_TargetGuidance_SetTargetLeash(objective, leashRadius)
	end
	
	if (retaliateAttacks ~= nil) then
		AIObjective_CombatGuidance_EnableRetaliateAttacks(objective, retaliateAttacks)
	end
	
	if(retaliateAttackRange ~= nil) then
		AIObjective_CombatGuidance_SetRetaliateAttackTargetAreaRadius(objective, retaliateAttackRange)
	end
	
end

-- for internal use only 
function BaseGoal_SetupObjective_Tactics(objective, data, abilityControlsList, tacticControlsList, units, encounterGroup)
	assert(objective ~= nil)
	assert(AIObjective_IsValid(objective))

	-- resets all tactic / ability guidance before setting tactic / ability filters below
	AIObjective_TacticFilter_Reset(objective)
	
	-- tacticControlsList takes priority over tacticCoverPriority and pickupWeapons, so do lower priority first
	if (data.tacticCoverPriority) then
		AIObjective_TacticFilter_SetPriority(objective, TACTIC_Cover, data.tacticCoverPriority)
	end
	
	if (data.pickupWeapons) then
		AIObjective_TacticFilter_SetPriority(objective, TACTIC_CaptureTeamWeapon, data.pickupWeapons)
		AIObjective_TacticFilter_SetPriority(objective, TACTIC_Pickup, data.pickupWeapons)
		AIObjective_TacticFilter_SetPriority(objective, TACTIC_Recrew, data.pickupWeapons)
	end
	
	AIObjective_TacticFilter_SetTargetPolicy(objective, data.tacticTargetPreference)
	
	if (scartype(data.maxAttackers) == ST_NUMBER and data.maxAttackers >= 0) then
		AIObjective_TacticFilter_SetDefaultTargetGuidance(objective, data.maxAttackers)
	else
		AIObjective_TacticFilter_ResetTargetGuidance(objective)
	end
	
	-- Ability Blacklists, per squad
	for k, unit in pairs(units) do
		if (unit.sgroup ~= nil) then
			if (scartype(unit.data.abilityBlacklist) == ST_PBG) then
				AIObjective_TacticFilter_DisableAbilityForSquadGroup(objective, unit.sgroup, unit.data.abilityBlacklist)
			elseif (scartype(unit.data.abilityBlacklist) == ST_TABLE) then
				for i, abilityPBG in pairs(unit.data.abilityBlacklist) do
					AIObjective_TacticFilter_DisableAbilityForSquadGroup(objective, unit.sgroup, abilityPBG)
				end
			end
		end
	end	
	
	-- Ability blacklist, GLOBAL (set in goal)
	if(scartype(data.abilityBlacklist) == ST_PBG) then
		AIObjective_TacticFilter_DisableAbilityForSquadGroup(objective, encounterGroup, data.abilityBlacklist)
	elseif(scartype(data.abilityBlacklist) ==  ST_TABLE) then
		for k, ability in pairs(data.abilityBlacklist) do
			AIObjective_TacticFilter_DisableAbilityForSquadGroup(objective, encounterGroup, ability)
		end
	end

	if (abilityControlsList ~= nil) then
		for i,abilityControls in pairs(abilityControlsList) do
			if (abilityControls.abilityPBG == nil) then
				AIObjective_TacticFilter_SetDefaultAbilityGuidance(objective, 
											abilityControls.maxCasters or -1, 
											abilityControls.retryTimeSecs or -1, abilityControls.waitTimeSecs or -1, abilityControls.timeoutTimeSecs or -1,
											abilityControls.useInitialWaitTime or false,
											abilityControls.maxRange or 100)
			else
				AIObjective_TacticFilter_SetAbilityGuidance(objective, 
											abilityControls.abilityPBG, 
											abilityControls.maxCasters or -1, 
											abilityControls.retryTimeSecs or -1, abilityControls.waitTimeSecs or -1, abilityControls.timeoutTimeSecs or -1,
											abilityControls.useInitialWaitTime or false,
											abilityControls.maxRange or 100)
			end
		end
	end
	
	if (tacticControlsList ~= nil) then
		for i,tacticControls in pairs(tacticControlsList) do
			if (tacticControls.tacticType == nil) then
				AIObjective_TacticFilter_SetDefaultTacticGuidance(objective, 
											tacticControls.maxUsers or -1, 
											tacticControls.retryTimeSecs or -1, tacticControls.waitTimeSecs or -1, tacticControls.timeoutTimeSecs or -1,
											tacticControls.useInitialWaitTime or false,  
											tacticControls.maxRange or 100)
			else
				if (tacticControls.maxUsers or tacticControls.waitTimeSecs or tacticControls.maxRange) then
					AIObjective_TacticFilter_SetTacticGuidance(objective, 
											tacticControls.tacticType, 
											tacticControls.maxUsers or -1, 
											tacticControls.retryTimeSecs or -1, tacticControls.waitTimeSecs or -1, tacticControls.timeoutTimeSecs or -1,
											tacticControls.useInitialWaitTime or false,  
											tacticControls.maxRange or 100)
				end
				
				if (tacticControls.priority ~= nil) then
					AIObjective_TacticFilter_SetPriority(objective, tacticControls.tacticType, tacticControls.priority)
				end
			end
		end
	end
end

-- for internal use only 
function BaseGoal_SetupObjective_FallbackParams(objective, fallbackParams)
	assert(objective ~= nil)
	assert(AIObjective_IsValid(objective))
	
	if (fallbackParams) then
		local retreat = fallbackParams.retreat and true or false
		local retreatDelay = fallbackParams.retreatDelay or 0
		if (fallbackParams.thresholdType == Threshold_PercentageHealth) then
			if( retreat ) then
				AIObjective_FallbackGuidance_SetFallbackSquadHealthPercentage(objective, fallbackParams.thresholds[1])
				AIObjective_FallbackGuidance_SetFallbackVehicleHealthPercentage(objective, fallbackParams.thresholds[1])
				AIObjective_FallbackGuidance_SetRetreatHealthPercentage(objective, fallbackParams.thresholds[1])
			else
				AIObjective_FallbackGuidance_SetFallbackSquadHealthPercentage(objective, fallbackParams.thresholds[1])
				AIObjective_FallbackGuidance_SetFallbackVehicleHealthPercentage(objective, fallbackParams.thresholds[1])
				AIObjective_FallbackGuidance_SetRetreatHealthPercentage(objective, 0)
			end
		elseif (fallbackParams.thresholdType == Threshold_PercentageCombatRating) then
			if( retreat ) then
				AIObjective_FallbackGuidance_SetFallbackCombatRatingPercentage(objective, fallbackParams.thresholds[1])
				AIObjective_FallbackGuidance_SetRetreatCombatRatingPercentage(objective, fallbackParams.thresholds[1])
			else
				AIObjective_FallbackGuidance_SetFallbackCombatRatingPercentage(objective, fallbackParams.thresholds[1])
				AIObjective_FallbackGuidance_SetRetreatCombatRatingPercentage(objective, 0)
			end
		elseif (fallbackParams.thresholdType == Threshold_PercentageEntitiesRemaining) then
			AIObjective_FallbackGuidance_SetEntitiesRemainingThreshold(objective, fallbackParams.thresholds[1])
		end
		
		AIObjective_FallbackGuidance_SetRetreatDelayTime(objective, retreatDelay)
		
		AIObjective_FallbackGuidance_SetGlobalFallbackRetreat(objective, retreat)
		AIObjective_FallbackGuidance_SetGlobalFallbackPercentage(objective, fallbackParams.globalPercentage or 1)
		
		if (fallbackParams.markers) then 
			AIObjective_FallbackGuidance_SetTargetPosition(objective, Util_GetPosition(fallbackParams.markers[1]))
		end
		
		AIObjective_FallbackGuidance_EnableRetreatOnSuppression(objective, fallbackParams.retreatOnSuppression and true or false) 
		AIObjective_FallbackGuidance_EnableRetreatOnPinned(objective, fallbackParams.retreatOnSuppression and true or false) 
	end
end

-- Internal. Updates what squads and abilities are available for the objective to use
function BaseGoal:UpdateResourceGuidance()
	assert(self.objective ~= nil)
	assert(AI_IsEnabled(self.encounter.data.player))
	assert(AIObjective_IsValid(self.objective))
	
	-- Resource Guidance
	AIObjective_ResourceGuidance_SquadGroup(self.objective, self.encounter.sgroup)
	
	-- Tactics / Abilities Guidance
	BaseGoal_SetupObjective_Tactics(self.objective, self.data, self.data.abilityControlsList, self.data.tacticControlsList, self.encounter.units, self.encounter.sgroup)
end
