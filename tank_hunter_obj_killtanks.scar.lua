print("\tLoading ObjKillTanks file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Tank_Hunter
-- Objective File - Destroy the enemy tanks
-- Designer: A.Molina
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_ObjTankHunter()
	print("Initializing ObjExample...")
	
	-- Pre-condition:		Mission starts
	-- Success condition:	All enemy tanks are destroyed
	-- Failure condition:	All player units are killed
	-- Post-condition:
	--		Success:		Mission complete
	--		Failure:		Mission failure
	OBJ_KillTanks = {
		--Info
		Title = 11076621, -- LOCDB [11076621] 'Hunt down and destroy the enemy tanks'
		Type = OT_Primary,
		Parent = nil,
		subObjectives = {},
		--Intel
		Intel_Start = 				EVENTS.ObjKillTanks_Intro,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			EVENTS.MissionSuccess,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = nil,
		PreStart = nil,
		OnStart = function()
				Event_NarrativeEventsNotRunning(EventHandler_StartIntel, {intel = EVENTS.ExplainApproach}, 3.0)
				Objective_SetCounter(OBJ_KillTanks, 0, SGroup_CountSpawned(sg_enemyTanks))
				
				local _pingTanks = function(group, index, item)
					Objective_AddUIElements(OBJ_KillTanks, item, true, Loc_Empty(), true)
				end
				SGroup_ForEach(sg_enemyTanks, _pingTanks)
				
			end,
		IsComplete = function() return SGroup_CountSpawned(sg_enemyTanks) == 0 end,
		PreComplete = nil,
		OnComplete = function() Rule_AddDelayedInterval(Mission_Complete, 2, 0.5) end,
		IsFailed = function() return Player_GetSquadCount(player1) < 1 end,
		PreFail = nil,
		OnFail = function() Rule_AddDelayedInterval(Mission_Fail, 2, 0.5) end,
	}
	
end
Scar_AddInit(INIT_ObjTankHunter)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------

--Callback when a tank is killed
function TankKilled(unit)
	if Objective_IsCounterSet(OBJ_KillTanks) then
		Objective_IncreaseCounter(OBJ_KillTanks)
	end
	
	local enc = unit:GetEncounter()
	enc:ClearGoal()
	Cmd_Retreat(enc:GetSgroup(), mkr_retreat, mkr_retreat, false, true, true)
end
