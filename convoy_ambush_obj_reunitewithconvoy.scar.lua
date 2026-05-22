print("\tLoading ObjBurnCastle file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Convoy Ambush
-- Objective File - Reunite with the convoy
-- Designer: R.McGechaen
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_ObjReunite()
	print("Initializing ObjExample...")
	
	-- Variables related to tell the player to load his squads up
	tmr_loadSquads = "tmr_loadSquads"
	hpid_loadSquads = nil
	
	
	-- Pre-condition:		Mission starts
	-- Success condition:	All units reach extraction point
	-- Failure condition:	Truck is destroyed
	-- Post-condition:
	--		Success:		Mission complete
	--		Failure:		Mission failure
	OBJ_MainObjective = {
		--Info
		Title = 11076609, 	-- LOCDB [11076609] 'Reunite with the Convoy'
		Type = OT_Primary,
		Parent = nil,
		subObjectives = {},
		--Intel
		Intel_Start = 				EVENTS.ObjReunite_Intro,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			EVENTS.MissionSuccess,
		Intel_Fail = 				EVENTS.MissionFailure,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = nil,
		PreStart = nil,
		OnStart = function()
				Objective_Start(SOBJ_ReachExit, false)
				Objective_Start(SOBJ_KeepTruckAlive, false)
				Event_NarrativeEventsNotRunning(ENCOUNTERS.convoyAmbush_Attack, nil, t_difficulty.startAttackDelay)
			end,
		IsComplete = function() 
			return Prox_AreSquadsNearMarker(Player_GetSquads(player1), mkr_convoyAmbush_escape, ALL) 
		end,
		PreComplete = EvacComplete,
		OnComplete = function() Event_NarrativeEventsNotRunning(Mission_Complete, nil, 1) end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = function() Event_NarrativeEventsNotRunning(Mission_Fail, nil, 1) end,
	}
	
	
	
	-- Pre-condition:		
	-- Success condition:	
	-- Failure condition:	
	-- Post-condition:
	--		Success:		
	--		Failure:		
	SOBJ_ReachExit = {
		Title = 11076610, 	-- LOCDB [11076610] 'Move all troops to the Exit Point'
		Type = OT_Primary,						
		Parent = OBJ_MainObjective,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() 
				Objective_AddUIElements(SOBJ_ReachExit, mkr_convoyAmbush_escape, true, 11076611, true) 	-- LOCDB [11076611] 'Exit Point'
			end,
		OnStart = function()
				Event_Proximity(PlayerAtExit, nil, Player_GetSquads(player1), mkr_convoyAmbush_escape, nil, ANY, 1.5)
			end,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_MainObjective.subObjectives, SOBJ_ReachExit)
	
	
	
	-- Pre-condition:		
	-- Success condition:	
	-- Failure condition:	
	-- Post-condition:
	--		Success:		
	--		Failure:
	SOBJ_KeepTruckAlive = {
		Title = 11076612,  	-- LOCDB [11076612] 'Keep the truck alive'
		Type = OT_Primary,						
		Parent = OBJ_MainObjective,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function()
				local hpid_truck = HintPoint_Add(sg_truck, true, 11076612)
				Event_Timer(EventHandler_RemoveHint, {hint = hpid_truck}, 12)
			end,
		OnStart = function() 
				Event_GroupIsDead(KeepTruckAlive_Fail, nil, sg_truck, 3.0)
			end,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_MainObjective.subObjectives, SOBJ_KeepTruckAlive)
	
end
Scar_AddInit(INIT_ObjReunite)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------

function PlayerAtExit()
	Util_StartIntel(EVENTS.PlayerAtExit)
	HintPoint_Add(Util_GetOffsetPosition(mkr_convoyAmbush_escape, OFFSET_BACK, 0.5), true, 11076613, 3) 	-- LOCDB [11076613] 'Evacuate all remaining units'
	UI_CreateMinimapBlip(mkr_convoyAmbush_escape, 10, BT_General)
end

function KeepTruckAlive_Fail()
	Game_SetMode(UI_Cinematic)
	
	Objective_Fail(OBJ_MainObjective)
end

function EvacComplete()
	Event_RemoveAll()
	Game_SetMode(UI_Cinematic)
	HintPoint_RemoveAll()
	Camera_MoveTo(mkr_convoyAmbush_escape)
	SGroup_SetInvulnerable(sg_truck, true)
--~ 	Cmd_Move(Player_GetSquads(player1), mkr_truck_despawn, false)
	
	Objective_Complete(OBJ_MainObjective)
end
