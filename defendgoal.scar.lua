--? @group scardoc;Encounter

import("Systems/AiManager/Goals/BaseGoal.scar")

function AIObjective_MoveGuidance_EnableRelaxedPatrol(objective, relaxed)
--This function is here because old save games have a saved copy of the function DefendGoal:SetupSkirmishAI which tries to call this.
end

Ai = Ai or fatal("Ai not loaded properly")
Ai.goals = Ai.goals or {}
Ai.goals.DefendGoal = Clone(Ai.goals.BaseGoal)
Ai.goals.DefaultDefendGoalData = Ai.goals.DefaultDefendGoalData or {} -- preserve data on soft-reload

local DefendGoal = Ai.goals.DefendGoal

DefendGoal._BaseCreate = DefendGoal.Create
DefendGoal._BaseSetupSkirmishAI = DefendGoal.SetupSkirmishAI
DefendGoal._BaseUpdateGoalData = DefendGoal.UpdateGoalData


function DefendGoal:Create(encounter, goalData, defaultGoalData, overrideGoalData, modifyGoalData)
	local DefaultDefendGoalData = Ai.goals.DefaultDefendGoalData
	defaultGoalData = defaultGoalData or DefaultDefendGoalData.defaultGoalData
	overrideGoalData = overrideGoalData or DefaultDefendGoalData.overrideGoalData
	modifyGoalData = modifyGoalData or DefaultDefendGoalData.modifyGoalData
	
	local goal = self:_BaseCreate(encounter, goalData, defaultGoalData, overrideGoalData, modifyGoalData)
	
	if(goal.objective) then fatal("ERROR: Objective object already defined for encounter "  .. encounter.data.name) end
	
	goal:CreateSkirmishAI()
	
	return goal
end

function DefendGoal:UpdateGoalData(goalData, defaultGoalData, overrideGoalData, modifyGoalData)
	local DefaultDefendGoalData = Ai.goals.DefaultDefendGoalData
	defaultGoalData = defaultGoalData or DefaultDefendGoalData.defaultGoalData
	overrideGoalData = overrideGoalData or DefaultDefendGoalData.overrideGoalData
	modifyGoalData = modifyGoalData or DefaultDefendGoalData.modifyGoalData

	self:_BaseUpdateGoalData(goalData, defaultGoalData, overrideGoalData, modifyGoalData)
end

--Setup defend based on skirmish AI
function DefendGoal:CreateSkirmishAI()
	if (not AI_IsEnabled(self.encounter.data.player)) then
		Ai:Print("Skipping Skirmish AI - player not enabled AI")
		self.objective = nil
		return
	end
	
	Ai:Print("Creating AI Objective...")
	self.objective = AI_CreateObjective(self.encounter.data.player, AIObjectiveType_DefendArea)
	
	self:SetupEncounterSkirmishAI()
	self:SetupSkirmishAI()
end

--Setup defend based on skirmish AI
function DefendGoal:SetupSkirmishAI()
	if (self.objective == nil or not AIObjective_IsValid(self.objective)) then
		self.objective = nil
		return
	end
	
	Ai:Print("Setting up Skirmish AI...")
	
	self:_BaseSetupSkirmishAI()

	if (self.data.maxIdleTime) then
		AIObjective_EngagementGuidance_SetMaxIdleTime(self.objective, self.data.maxIdleTime)
	end
	if (self.data.coordinatedSetupFacingPositions) then
		if (scartype(self.data.coordinatedSetupFacingPositions) == ST_TABLE) then
			for i,pos in ipairs(self.data.coordinatedSetupFacingPositions) do
				AIObjective_DefenseGuidance_AddFacingPosition(self.objective, Util_GetPosition(pos))
			end
		else
			AIObjective_DefenseGuidance_AddFacingPosition(self.objective, Util_GetPosition(self.data.coordinatedSetupFacingPositions))
		end
	end
	
	AIObjective_DefenseGuidance_EnableIdleGarrison(self.objective, self.data.garrisonIdle or false)
	AIObjective_CombatGuidance_EnableCombatGarrison(self.objective, self.data.garrison or false)
	
	if (self.data.patrolParams) then
		if (self.data.patrolParams.path) then
			AIObjective_TargetGuidance_SetTargetPathByName(self.objective, self.data.patrolParams.path, self.data.patrolParams.wait or 0)
		else
			AIObjective_TargetGuidance_SetTargetPathWander(self.objective, self.data.patrolParams.wait or 0)
		end
	end
end


--[[
-- Defend Goal Data Interface
]]--

--? @shortdesc Adjust default goal data for defend goals.  Sets the default GoalData to the current defaults plus additionalDefaultGoalData; any values specified are used for unspecified encounter defend goal values.
--? @args Table additionalDefaultGoalData
function AIDefendGoal_AdjustDefaultGoalData(additionalDefaultGoalData)
	Ai:Print("===============================================")
	Ai:Print("Adjusting DefendGoal default data...")

	local additionalGoalData = Clone(additionalDefaultGoalData)
	_AIDefaultGoalData_SetDefaultGoalDataMetaData(additionalGoalData)
	local DefaultBaseGoalData = Ai.goals.DefaultGoalData
	local DefaultDefendGoalData = Ai.goals.DefaultDefendGoalData
	local defaultGoalData = DefaultDefendGoalData.defaultGoalData or DefaultBaseGoalData.defaultGoalData
	DefaultDefendGoalData.defaultGoalData = MergeCloneTable(defaultGoalData, additionalGoalData)

	Ai:Print("-----------------------------------------------")
	Ai:Print("additionalDefaultGoalData")
	Ai:Print(additionalGoalData)
	Ai:Print("-----------------------------------------------")
	DebugPrintGoals(DefaultDefendGoalData.defaultGoalData, DefaultDefendGoalData.overrideGoalData, DefaultDefendGoalData.modifyGoalData)
	Ai:Print("===============================================")
end

--? @shortdesc Set default goal data for defend goals.  defaultGoalData is cloned; any values specified are used for unspecified encounter defend goal values.
--? @args Table defaultGoalData
function AIDefendGoal_SetDefaultGoalData(defaultGoalData)
	Ai:Print("===============================================")
	Ai:Print("Setting DefendGoal default data...")

	local DefaultDefendGoalData = Ai.goals.DefaultDefendGoalData
	DefaultDefendGoalData.defaultGoalData = Clone(defaultGoalData)
	_AIDefaultGoalData_SetDefaultGoalDataMetaData(DefaultDefendGoalData.defaultGoalData)

	DebugPrintGoals(DefaultDefendGoalData.defaultGoalData, DefaultDefendGoalData.overrideGoalData, DefaultDefendGoalData.modifyGoalData)
	Ai:Print("===============================================")
end

--? @shortdesc Set override goal data for defend goals.  overrideGoalData is cloned; any values specified are used for encounter defend goal values.
--? @args Table overrideGoalData
function AIDefendGoal_SetOverrideGoalData(overrideGoalData)
	Ai:Print("===============================================")
	Ai:Print("Setting DefendGoal override data...")

	local DefaultDefendGoalData = Ai.goals.DefaultDefendGoalData
	DefaultDefendGoalData.overrideGoalData = Clone(overrideGoalData)
	_AIDefaultGoalData_SetDefaultGoalDataMetaData(DefaultDefendGoalData.overrideGoalData)

	DebugPrintGoals(DefaultDefendGoalData.defaultGoalData, DefaultDefendGoalData.overrideGoalData, DefaultDefendGoalData.modifyGoalData)
	Ai:Print("===============================================")
end

--? @shortdesc Set modify goal data for defend goals.  modifyGoalData is cloned; values specified via keyname_Multiply are used for the numeric keyname encounter defend goal value.
--? @args Table modifyGoalData
function AIDefendGoal_SetModifyGoalData(modifyGoalData)
	Ai:Print("===============================================")
	Ai:Print("Setting DefendGoal modify data...")
	local DefaultDefendGoalData = Ai.goals.DefaultDefendGoalData
	DefaultDefendGoalData.modifyGoalData = Clone(modifyGoalData) 

	DebugPrintGoals(DefaultDefendGoalData.defaultGoalData, DefaultDefendGoalData.overrideGoalData, DefaultDefendGoalData.modifyGoalData)
	Ai:Print("===============================================")
end

