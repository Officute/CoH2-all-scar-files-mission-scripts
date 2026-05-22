print("\tLoading ObjCaptureRoad file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Siege of Bastogne
-- Objective File - Capture Road
-- Designer: Ryan McGechaen
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_CaptureRoad()
	print("Initializing OBJ_CaptureRoad..")
	
	OBJ_CaptureRoad = {
		--Info
		Title = 11076802,		-- LOCDB [11076802] 'Capture as many points as possible'
		Type = OT_Primary,
		Parent = nil,
		subObjectives = {SOBJ_CaptureRoadInfo},
		--Intel
		Intel_Start = 				EVENTS.CaptureTheRoad_Start,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			EVENTS.CaptureTheRoad_Complete,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				nil,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = function()
			hpid_obj_capture_01 = Objective_AddUIElements(OBJ_CaptureRoad, Util_GetOffsetPosition(eg_road_1, OFFSET_LEFT,1), true, 11076803, true)		-- LOCDB [11076803] 'Capture Road Point'
			hpid_obj_capture_02 = Objective_AddUIElements(OBJ_CaptureRoad, Util_GetOffsetPosition(eg_road_2, OFFSET_LEFT,1), true, 11076803, true)
			hpid_obj_capture_03 = Objective_AddUIElements(OBJ_CaptureRoad, Util_GetOffsetPosition(eg_road_3, OFFSET_LEFT,1), true, 11076803, true)
			hpid_obj_capture_04 = Objective_AddUIElements(OBJ_CaptureRoad, Util_GetOffsetPosition(eg_road_4, OFFSET_LEFT,1), true, 11076803, true)
			
			eventID_01_captured = Event_PlayerOwnsElement(EventHandler_RemoveObjectiveUI, {objective = OBJ_CaptureRoad, element = hpid_obj_capture_01}, player1, eg_road_1)
			eventID_02_captured = Event_PlayerOwnsElement(EventHandler_RemoveObjectiveUI, {objective = OBJ_CaptureRoad, element = hpid_obj_capture_02}, player1, eg_road_2)
			eventID_03_captured = Event_PlayerOwnsElement(EventHandler_RemoveObjectiveUI, {objective = OBJ_CaptureRoad, element = hpid_obj_capture_03}, player1, eg_road_3)
			eventID_04_captured = Event_PlayerOwnsElement(EventHandler_RemoveObjectiveUI, {objective = OBJ_CaptureRoad, element = hpid_obj_capture_04}, player1, eg_road_4)
		end,
		PreStart = function()
			Rule_AddInterval(CollectPlayers, 1)
		end,
		OnStart = function()
			Objective_Start(SOBJ_CaptureRoadInfo, false)
			Objective_StartTimer(OBJ_CaptureRoad, COUNT_DOWN, 6*60)
			--Sound_Play2D("streamed/ambience_beds/blizzard_wind_bastogne")
		end,
		IsComplete = function()
			return (Player_OwnsEGroup(player1, eg_road_all) or (Objective_IsTimerSet(OBJ_CaptureRoad) and Objective_GetTimerSeconds(OBJ_CaptureRoad) <= 0) or g_playerSquadCount <= 0)
		end,
		PreComplete = nil,
		OnComplete = function()
			if Player_OwnsEGroup(player1, eg_road_all) then
				Event_NarrativeEventsNotRunning(DefendRoad_Start, nil, 2)
				
				t_difficulty.defendStartTime = Util_DifVar({2*60, 2*60, 1.5*60}, g_difficulty)
			else
				Event_NarrativeEventsNotRunning(SecureRoad_Start, nil, 2)
				
				if Player_OwnsEGroup(player2, eg_road_1) then
					ENCOUNTERS.Build_Encounter(mkr_e_waveSpawn_03, nil, ENC_INTENT.basicInfantry, "Defend", mkr_e_road1_def, 25, 25, 0.2, mkr_e_retreat_01)
				end
				if Player_OwnsEGroup(player2, eg_road_2) then
					ENCOUNTERS.Build_Encounter(mkr_e_waveSpawn_03, nil, ENC_INTENT.basicInfantry, "Defend", mkr_e_road2_def, 25, 25, 0.2, mkr_e_retreat_01)
				end
				if Player_OwnsEGroup(player2, eg_road_3) then
					ENCOUNTERS.Build_Encounter(mkr_e_waveSpawn_02, nil, ENC_INTENT.basicInfantry, "Defend", mkr_e_road3_def, 25, 25, 0.2, mkr_e_retreat_01)
				end
				if Player_OwnsEGroup(player2, eg_road_4) then
					ENCOUNTERS.Build_Encounter(mkr_e_retreat_03, nil, ENC_INTENT.basicInfantry, "Defend", mkr_e_road4_def, 25, 25, 0.2, mkr_e_retreat_01)
				end
			end
			
			Bastogne_Transition_To_Snowing()
			
			Event_NarrativeEventsNotRunning(Bastogne_CaptureComplete, nil, 1)
			
			for k,v in pairs(t_startEncounters) do
				if v.enc:IsAlive() then
					v.enc:TriggerGoal()
				end
				if Event_Exists(v.eventID) then
					Event_Remove(v.eventID)
				end
			end
			
			if Timer_Exists(tmr_lastSpottedEvent) then
				Timer_End(tmr_lastSpottedEvent)
			end
			
			Rule_Remove(CollectPlayers)
		end,
		IsFailed = function()
			
		end,
		PreFail = nil,
		OnFail = function() 
			
		end,
	}
	
	SOBJ_CaptureRoadInfo = {
		--Info
		Title = 11078449,		-- LOCDB [11078449] 'Capture the points quickly to reduce the amount of wounded to evacuate'
		Type = OT_Primary,
		Parent = OBJ_CaptureRoad,
		subObjectives = {},
		--Intel
		Intel_Start = 				nil,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			nil,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				nil,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = nil,
		PreStart = nil,
		OnStart = nil,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	
	table.insert(OBJ_CaptureRoad.subObjectives, SOBJ_CaptureRoadInfo)
	
end
Scar_AddInit(INIT_CaptureRoad)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------
-- Collects player units to keep track of how many are alive
function CollectPlayers()
	Player_GetAll(player1)
	
	g_playerSquadCount = SGroup_CountSpawned(sg_allsquads)
	
end
