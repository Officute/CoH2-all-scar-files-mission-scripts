--? @group scardoc;Encounter

import("Systems/AiManager/Goals/BaseGoal.scar")

Ai = Ai or fatal("Ai not loaded properly")
Ai.goals = Ai.goals or {}
Ai.goals.AttackGoal = Clone(Ai.goals.BaseGoal)
Ai.goals.DefaultAttackGoalData = Ai.goals.DefaultAttackGoalData or {} -- preserve data on soft-reload

local AttackGoal = Ai.goals.AttackGoal

AttackGoal._BaseCreate = AttackGoal.Create
AttackGoal._BaseSetupSkirmishAI = AttackGoal.SetupSkirmishAI
AttackGoal._BaseUpdateGoalData = AttackGoal.UpdateGoalData
AttackGoal._UpdateResourceGuidance = AttackGoal.UpdateResourceGuidance


function AttackGoal:Create(encounter, goalData, defaultGoalData, overrideGoalData, modifyGoalData)
	local DefaultAttackGoalData = Ai.goals.DefaultAttackGoalData
	defaultGoalData = defaultGoalData or DefaultAttackGoalData.defaultGoalData
	overrideGoalData = overrideGoalData or DefaultAttackGoalData.overrideGoalData
	modifyGoalData = modifyGoalData or DefaultAttackGoalData.modifyGoalData
	
	local goal = self:_BaseCreate(encounter, goalData, defaultGoalData, overrideGoalData, modifyGoalData)
	
	if(not goal.data.target) then fatal("ERROR: No attack target defined for encounter "  .. encounter.data.name) end
	if(goal.objective) then fatal("ERROR: Objective object already defined for encounter "  .. encounter.data.name) end
	
	goal:CreateSkirmishAI()
	
	return goal
end

function AttackGoal:UpdateGoalData(goalData, defaultGoalData, overrideGoalData, modifyGoalData)
	local DefaultAttackGoalData = Ai.goals.DefaultAttackGoalData
	defaultGoalData = defaultGoalData or DefaultAttackGoalData.defaultGoalData
	overrideGoalData = overrideGoalData or DefaultAttackGoalData.overrideGoalData
	modifyGoalData = modifyGoalData or DefaultAttackGoalData.modifyGoalData

	self:_BaseUpdateGoalData(goalData, defaultGoalData, overrideGoalData, modifyGoalData)
end

--Create and Setup attack based on skirmish AI
function AttackGoal:CreateSkirmishAI()
	if (not AI_IsEnabled(self.encounter.data.player)) then
		Ai:Print("Skipping Skirmish AI - player not enabled AI")
		self.objective = nil
		return
	end
	
	Ai:Print("Creating AI Objective...")
	self.objective = AI_CreateObjective(self.encounter.data.player, AIObjectiveType_AttackArea)
	
	self:SetupEncounterSkirmishAI()
	self:SetupSkirmishAI()
end

--Setup attack based on skirmish AI
function AttackGoal:SetupSkirmishAI()
	if (self.objective == nil or not AIObjective_IsValid(self.objective)) then
		self.objective = nil
		return
	end
	
	Ai:Print("Setting up Skirmish AI...")
	
	self:_BaseSetupSkirmishAI()
	
	AIObjective_EngagementGuidance_SetMaxIdleTime(self.objective, self.data.maxIdleTime or 60)
	
	AttackGoal_SetupObjective_Tactics(self.objective, self.data)
end

-- Internal. Updates what squads and abilities are available for the objective to use
function AttackGoal:UpdateResourceGuidance()
	assert(self.objective ~= nil)
	assert(AI_IsEnabled(self.encounter.data.player))
	assert(AIObjective_IsValid(self.objective))
	
	self:_UpdateResourceGuidance()

	AttackGoal_SetupObjective_Tactics(self.objective, self.data)
end


-- for internal use only 
function AttackGoal_SetupObjective_Tactics(objective, data)
	assert(objective ~= nil)
	assert(AIObjective_IsValid(objective))

	-- only set AttackGoal specific guidance
	if (scartype(data.tacticCloseGround) == ST_BOOLEAN and data.tacticCloseGround) then
		AIObjective_TacticFilter_EnableCloseGround(objective, 50)
	elseif (scartype(data.tacticCloseGround) == ST_NUMBER and data.tacticCloseGround > 0) then
		AIObjective_TacticFilter_EnableCloseGround(objective, data.tacticCloseGround)
	end
end	

--[[
-- Attack Goal Data Interface
]]--

--? @shortdesc Adjust default goal data for attack goals.  Sets the default GoalData to the current defaults plus additionalDefaultGoalData; any values specified are used for unspecified encounter attack goal values.
--? @args Table additionalDefaultGoalData
function AIAttackGoal_AdjustDefaultGoalData(additionalDefaultGoalData)
	Ai:Print("===============================================")
	Ai:Print("Adjusting AttackGoal default data...")

	local additionalGoalData = Clone(additionalDefaultGoalData)
	_AIDefaultGoalData_SetDefaultGoalDataMetaData(additionalGoalData)
	local DefaultBaseGoalData = Ai.goals.DefaultGoalData
	local DefaultAttackGoalData = Ai.goals.DefaultAttackGoalData
	local defaultGoalData = DefaultAttackGoalData.defaultGoalData or DefaultBaseGoalData.defaultGoalData
	DefaultAttackGoalData.defaultGoalData = MergeCloneTable(defaultGoalData, additionalGoalData)

	Ai:Print("-----------------------------------------------")
	Ai:Print("additionalDefaultGoalData")
	Ai:Print(additionalGoalData)
	Ai:Print("-----------------------------------------------")
	DebugPrintGoals(DefaultAttackGoalData.defaultGoalData, DefaultAttackGoalData.overrideGoalData, DefaultAttackGoalData.modifyGoalData)
	Ai:Print("===============================================")
end

--? @shortdesc Set default goal data for attack goals.  defaultGoalData is cloned; any values specified are used for unspecified encounter attack goal values.
--? @args Table defaultGoalData
function AIAttackGoal_SetDefaultGoalData(defaultGoalData)
	Ai:Print("===============================================")
	Ai:Print("Setting AttackGoal default data...")

	local DefaultAttackGoalData = Ai.goals.DefaultAttackGoalData
	DefaultAttackGoalData.defaultGoalData = Clone(defaultGoalData)
	_AIDefaultGoalData_SetDefaultGoalDataMetaData(DefaultAttackGoalData.defaultGoalData)

	DebugPrintGoals(DefaultAttackGoalData.defaultGoalData, DefaultAttackGoalData.overrideGoalData, DefaultAttackGoalData.modifyGoalData)
	Ai:Print("===============================================")
end

--? @shortdesc Set override goal data for attack goals.  overrideGoalData is cloned; any values specified are used for encounter attack goal values.
--? @args Table overrideGoalData
function AIAttackGoal_SetOverrideGoalData(overrideGoalData)
	Ai:Print("===============================================")
	Ai:Print("Setting AttackGoal override data...")

	local DefaultAttackGoalData = Ai.goals.DefaultAttackGoalData
	DefaultAttackGoalData.overrideGoalData = Clone(overrideGoalData)
	_AIDefaultGoalData_SetDefaultGoalDataMetaData(DefaultAttackGoalData.overrideGoalData)

	DebugPrintGoals(DefaultAttackGoalData.defaultGoalData, DefaultAttackGoalData.overrideGoalData, DefaultAttackGoalData.modifyGoalData)
	Ai:Print("===============================================")
end

--? @shortdesc Set modify goal data for attack goals.  modifyGoalData is cloned; values specified via keyname_Multiplier are used for the numeric keyname encounter attack goal value.
--? @args Table modifyGoalData
function AIAttackGoal_SetModifyGoalData(modifyGoalData)
	Ai:Print("===============================================")
	Ai:Print("Setting AttackGoal modify data...")

	local DefaultAttackGoalData = Ai.goals.DefaultAttackGoalData
	DefaultAttackGoalData.modifyGoalData = Clone(modifyGoalData) 

	DebugPrintGoals(DefaultAttackGoalData.defaultGoalData, DefaultAttackGoalData.overrideGoalData, DefaultAttackGoalData.modifyGoalData)
	Ai:Print("===============================================")
end
