--? @group scardoc;Encounter

import("Systems/AiManager/Goals/BaseGoal.scar")

Ai = Ai or fatal("Ai not loaded properly")
Ai.goals = Ai.goals or {}
Ai.goals.MoveGoal = Clone(Ai.goals.BaseGoal)
Ai.goals.DefaultMoveGoalData = Ai.goals.DefaultMoveGoalData or {} -- preserve data on soft-reload

local MoveGoal = Ai.goals.MoveGoal

MoveGoal._BaseCreate = MoveGoal.Create
MoveGoal._BaseSetupSkirmishAI = MoveGoal.SetupSkirmishAI
MoveGoal._BaseUpdateGoalData = MoveGoal.UpdateGoalData


function MoveGoal:Create(encounter, goalData, defaultGoalData, overrideGoalData, modifyGoalData)
	local DefaultMoveGoalData = Ai.goals.DefaultMoveGoalData
	defaultGoalData = defaultGoalData or DefaultMoveGoalData.defaultGoalData
	overrideGoalData = overrideGoalData or DefaultMoveGoalData.overrideGoalData
	modifyGoalData = modifyGoalData or DefaultMoveGoalData.modifyGoalData
	
	local goal = self:_BaseCreate(encounter, goalData, defaultGoalData, overrideGoalData, modifyGoalData)
	
	if(not goal.data.target) then fatal("ERROR: No move target defined for encounter "  .. encounter.data.name) end
	if(goal.objective) then fatal("ERROR: Objective object already defined for encounter "  .. encounter.data.name) end
	
	goal:CreateSkirmishAI()
	
	return goal
end

function MoveGoal:UpdateGoalData(goalData, defaultGoalData, overrideGoalData, modifyGoalData)
	local DefaultMoveGoalData = Ai.goals.DefaultMoveGoalData
	defaultGoalData = defaultGoalData or DefaultMoveGoalData.defaultGoalData
	overrideGoalData = overrideGoalData or DefaultMoveGoalData.overrideGoalData
	modifyGoalData = modifyGoalData or DefaultMoveGoalData.modifyGoalData

	self:_BaseUpdateGoalData(goalData, defaultGoalData, overrideGoalData, modifyGoalData)
end

--Create and Setup move based on skirmish AI
function MoveGoal:CreateSkirmishAI()
	if (not AI_IsEnabled(self.encounter.data.player)) then
		Ai:Print("Skipping Skirmish AI - player not enabled AI")
		self.objective = nil
		return
	end
	
	Ai:Print("Creating AI Objective...")
	self.objective = AI_CreateObjective(self.encounter.data.player, AIObjectiveType_Move)
	
	self:SetupEncounterSkirmishAI()
	self:SetupSkirmishAI()
end

--Setup move based on skirmish AI
function MoveGoal:SetupSkirmishAI()
	if (self.objective == nil or not AIObjective_IsValid(self.objective)) then
		self.objective = nil
		return
	end
	
	Ai:Print("Setting up Skirmish AI...")
	
	self:_BaseSetupSkirmishAI()
	
end


--[[
-- Move Goal Data Interface
]]--

--? @shortdesc Adjust default goal data for move goals.  Sets the default GoalData to the current defaults plus additionalDefaultGoalData; any values specified are used for unspecified encounter move goal values.
--? @args Table additionalDefaultGoalData
function AIMoveGoal_AdjustDefaultGoalData(additionalDefaultGoalData)
	Ai:Print("===============================================")
	Ai:Print("Adjusting MoveGoal default data...")
	
	local additionalGoalData = Clone(additionalDefaultGoalData)
	_AIDefaultGoalData_SetDefaultGoalDataMetaData(additionalGoalData)
	local DefaultBaseGoalData = Ai.goals.DefaultGoalData
	local DefaultMoveGoalData = Ai.goals.DefaultMoveGoalData
	local defaultGoalData = DefaultMoveGoalData.defaultGoalData or DefaultBaseGoalData.defaultGoalData
	DefaultMoveGoalData.defaultGoalData = MergeCloneTable(defaultGoalData, additionalGoalData)

	Ai:Print("-----------------------------------------------")
	Ai:Print("additionalDefaultGoalData")
	Ai:Print(additionalGoalData)
	Ai:Print("-----------------------------------------------")
	DebugPrintGoals(DefaultMoveGoalData.defaultGoalData, DefaultMoveGoalData.overrideGoalData, DefaultMoveGoalData.modifyGoalData)
	Ai:Print("===============================================")
end

--? @shortdesc Set default goal data for move goals.  defaultGoalData is cloned; any values specified are used for unspecified encounter move goal values.
--? @args Table defaultGoalData
function AIMoveGoal_SetDefaultGoalData(defaultGoalData)
	Ai:Print("===============================================")
	Ai:Print("Setting MoveGoal default data...")

	local DefaultMoveGoalData = Ai.goals.DefaultMoveGoalData
	DefaultMoveGoalData.defaultGoalData = Clone(defaultGoalData)
	_AIDefaultGoalData_SetDefaultGoalDataMetaData(DefaultMoveGoalData.defaultGoalData)

	DebugPrintGoals(DefaultMoveGoalData.defaultGoalData, DefaultMoveGoalData.overrideGoalData, DefaultMoveGoalData.modifyGoalData)
	Ai:Print("===============================================")
end

--? @shortdesc Set override goal data for move goals.  overrideGoalData is cloned; any values specified are used for encounter move goal values.
--? @args Table overrideGoalData
function AIMoveGoal_SetOverrideGoalData(overrideGoalData)
	Ai:Print("===============================================")
	Ai:Print("Setting MoveGoal override data...")

	local DefaultMoveGoalData = Ai.goals.DefaultMoveGoalData
	DefaultMoveGoalData.overrideGoalData = Clone(overrideGoalData)
	_AIDefaultGoalData_SetDefaultGoalDataMetaData(DefaultMoveGoalData.overrideGoalData)

	DebugPrintGoals(DefaultMoveGoalData.defaultGoalData, DefaultMoveGoalData.overrideGoalData, DefaultMoveGoalData.modifyGoalData)
	Ai:Print("===============================================")
end

--? @shortdesc Set modify goal data for move goals.  modifyGoalData is cloned; values specified via keyname_Multiply are used for the numeric keyname encounter move goal value.
--? @args Table modifyGoalData
function AIMoveGoal_SetModifyGoalData(modifyGoalData)
	Ai:Print("===============================================")
	Ai:Print("Setting MoveGoal modify data...")

	local DefaultMoveGoalData = Ai.goals.DefaultMoveGoalData
	DefaultMoveGoalData.modifyGoalData = Clone(modifyGoalData) 

	DebugPrintGoals(DefaultMoveGoalData.defaultGoalData, DefaultMoveGoalData.overrideGoalData, DefaultMoveGoalData.modifyGoalData)
	Ai:Print("===============================================")
end


