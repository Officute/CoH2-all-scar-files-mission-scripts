


function OnGameRestore()
	
	-- function takes care of restoring all global mission parameters after a save/load
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)	
	player4 = World_GetPlayerAt(4)
	
	Game_DefaultGameRestore()
end
function Util_SetNISMode(enabled)
	if enabled == nil then enabled = true end
	if enabled == true then	
		Game_Letterbox(true, 1)
		Game_EnableInput(false)
		Camera_SetInputEnabled(false)
	else
		Game_Letterbox(false, 1)
		Game_EnableInput(true)
		Camera_SetInputEnabled(true)	
	end
end
function InitializeMission()
	
	--[[ PRESET DEBUG CONDITIONS ]]
	InitializeDebug()
		
	--[[ SET DIFFICULTY ]]
	
--~ 	UI_OutOfBoundsLinesHide()
	
	--[[ MISSION PRESETS ]]
	Mission_Setup()
		
	--[[ GAME START CHECK ]]
	Rule_Add(Mission_MissionStart)
	
end

function InitializeDebug()

	-- looks for the command line option [-debug]
	if Misc_IsCommandLineOptionSet("debug") then
		g_debug = true
	end
	
	if Misc_IsCommandLineOptionSet("dev") then
		Scar_DebugConsoleExecute("bind([[CONTROL+SPACE]], [[Scar_DoString('_skip()')]])")
	end

end

function InitializeDifficulty()
	campaignDifficulty = Game_GetSPDifficulty()  -- set a global difficulty variable 
	
	if campaignDifficulty == GD_EASY then
		attackGoalModifier = { 
			range_Multiplier = 0.9,
			movePathLengthFactor_Multiplier = 0.8,
			safeMoveWeight_Multiplier = 0.75,
			tacticTargetPreference = AITacticTargetPreference_Near,
		}
		defendGoalModifier = { 
			range_Multiplier = 0.9,
			leashRange_Multiplier = 0.9,
			maxAttackers_Multiplier = -2,
			safeMoveWeight_Multiplier = 0.75,
			tacticTargetPreference = AITacticTargetPreference_Near,
		}
	elseif campaignDifficulty == GD_NORMAL then
		attackGoalModifier = { 
			range_Multiplier = 1,
			movePathLengthFactor_Multiplier = 1,
			safeMoveWeight_Multiplier = 1,
			tacticTargetPreference = AITacticTargetPreference_Near,
		}
		defendGoalModifier = { 
			range_Multiplier = 1,
			leashRange_Multiplier = 1,
			maxAttackers_Multiplier = 1,
			safeMoveWeight_Multiplier = 1,
			tacticTargetPreference = AITacticTargetPreference_Near,
		}
	elseif campaignDifficulty == GD_HARD then
		attackGoalModifier = { 		
			range_Multiplier = 1.2,
			movePathLengthFactor_Multiplier = 1.2,
			leashRange_Multiplier = 1.2,
			safeMoveWeight_Multiplier = 1.25,
			tacticTargetPreference = AITacticTargetPreference_Near,
		}
		defendGoalModifier = { 
			range_Multiplier = 1.2,
			movePathLengthFactor_Multiplier = 1.2,
			leashRange_Multiplier = 1.2,
			safeMoveWeight_Multiplier = 1.25,
			tacticTargetPreference = AITacticTargetPreference_Near,
		}
	elseif campaignDifficulty == GD_EXPERT then
		attackGoalModifier = { 		
			range_Multiplier = 1.4,
			movePathLengthFactor_Multiplier = 1.4,
			leashRange_Multiplier = 1.4,
			safeMoveWeight_Multiplier = 1.5,
			tacticTargetPreference = AITacticTargetPreference_Near,
		}
		defendGoalModifier = { 
			range_Multiplier = 1.4,
			movePathLengthFactor_Multiplier = 1.4,
			leashRange_Multiplier = 1.4,
			safeMoveWeight_Multiplier = 1.5,
			tacticTargetPreference = AITacticTargetPreference_Near,
		}
	end		
	
	Modify_ProjectileDelayTime(player2, BP_GetEntityBlueprint("bundled_stielgranate_campaign"), CAMPAIGN_PGREN_BUNDLED_TIMER)
	
	AIAttackGoal_SetModifyGoalData(attackGoalModifier)
	AIDefendGoal_SetModifyGoalData(defendGoalModifier)
end

function Mission_MissionStart()

	if Event_IsAnyRunning() == false then
		InitializeDifficulty()
		Rule_RemoveMe()
		
		Mission_Start()
	end
end


function Mission_EndMission(win)
	missionWin = win
	Rule_AddDelayedInterval(_MissionEndCheck, 1.5, 1)
end

function _MissionEndCheck()
	if scartype(missionWin) ~= ST_BOOLEAN then
		missionWin = true
	end
	if Event_IsAnyRunning() == false then
		Game_EndSP(missionWin)		-- Mission completes successfully
	end
end

Scar_AddInit(InitializeMission)
