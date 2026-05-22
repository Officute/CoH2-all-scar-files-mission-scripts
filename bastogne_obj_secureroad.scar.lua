print("\tLoading ObjSecureRoad file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Siege of Bastogne
-- Objective File - Secure Road
-- Designer: Ryan McGechaen
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_SecureRoad()
	print("Initializing OBJ_SecureRoad..")
	
	OBJ_SecureRoad = {
		--Info
		Title = 11076799,		-- LOCDB [11076799] 'Secure the remaining points'
		Type = OT_Primary,
		Parent = nil,
		subObjectives = {SOBJ_SecureRoadStart},
		--Intel
		Intel_Start = 				nil,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			EVENTS.SecureTheRoad_Complete,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				EVENTS.SecureTheRoad_Fail,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = function()
			if Player_OwnsEGroup(player1, eg_road_1) == false then		-- TODO: Update with event handler
				hpid_obj_secure_01 = Objective_AddUIElements(OBJ_SecureRoad, Util_GetOffsetPosition(eg_road_1, OFFSET_LEFT,1), true, 11076800, true)		-- LOCDB [11076800] 'Capture the Road Territory'
				eventID_01_captured = Event_PlayerOwnsElement(EventHandler_RemoveObjectiveUI, {objective = OBJ_SecureRoad, element = hpid_obj_secure_01}, player1, eg_road_1)
			end
			if Player_OwnsEGroup(player1, eg_road_2) == false then
				hpid_obj_secure_02 = Objective_AddUIElements(OBJ_SecureRoad, Util_GetOffsetPosition(eg_road_2, OFFSET_LEFT,1), true, 11076800, true)
				eventID_02_captured = Event_PlayerOwnsElement(EventHandler_RemoveObjectiveUI, {objective = OBJ_SecureRoad, element = hpid_obj_secure_02}, player1, eg_road_2)
			end
			if Player_OwnsEGroup(player1, eg_road_3) == false then
				hpid_obj_secure_03 = Objective_AddUIElements(OBJ_SecureRoad, Util_GetOffsetPosition(eg_road_3, OFFSET_LEFT,1), true, 11076800, true)
				eventID_03_captured = Event_PlayerOwnsElement(EventHandler_RemoveObjectiveUI, {objective = OBJ_SecureRoad, element = hpid_obj_secure_03}, player1, eg_road_3)
			end
			if Player_OwnsEGroup(player1, eg_road_4) == false then
				hpid_obj_secure_04 = Objective_AddUIElements(OBJ_SecureRoad, Util_GetOffsetPosition(eg_road_4, OFFSET_LEFT,1), true, 11076800, true)
				eventID_04_captured = Event_PlayerOwnsElement(EventHandler_RemoveObjectiveUI, {objective = OBJ_SecureRoad, element = hpid_obj_secure_04}, player1, eg_road_4)
			end
		end,
		PreStart = nil,
		OnStart = function()			
			Objective_Start(SOBJ_SecureRoadStart, false)
			Event_Timer(EventHandler_StartIntel, {intel = EVENTS.SecureTheRoad_Explain}, 20)
			Event_NarrativeEventsNotRunning(SecureRoad_StartBuilding, nil, 35)
		end,
		IsComplete = function()
			return (Player_OwnsEGroup(player1, eg_road_all, ALL))
		end,
		PreComplete = function()
			g_wounded = 1.0 - g_alliedStrength
			if Event_Exists(eventID_buildUpTimer) then 
				Event_Remove(eventID_buildUpTimer)
			end
			Obj_HideProgress()
		end,
		OnComplete = function()
			Event_NarrativeEventsNotRunning(DefendRoad_Start, nil, 3)
		end,
		IsFailed = function()
			return (g_alliedStrength <= 0)
		end,
		PreFail = function()
			if Event_Exists(eventID_buildUpTimer) then 
				Event_Remove(eventID_buildUpTimer)
			end
			Obj_HideProgress()
		end,
		OnFail = function() 
			Rule_AddInterval(Mission_Fail, 1)
		end,
	}
	
	SOBJ_SecureRoadStart = {
		--Info
		Title = 11078449,		-- LOCDB [11078449] 'Capture the points quickly to reduce the amount of wounded to evacuate'
		Type = OT_Primary,
		Parent = OBJ_SecureRoad,
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
	
	table.insert(OBJ_SecureRoad.subObjectives, SOBJ_SecureRoadStart)
	
end
Scar_AddInit(INIT_SecureRoad)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------

function SecureRoad_Start()
	Objective_Start(OBJ_SecureRoad)
end


-- Display the Progress bar for the German build-up initially
function SecureRoad_StartBuilding()	
	eventID_buildUpTimer = Event_Timer(SecureRoad_DecreaseAlliedStrength, nil, t_difficulty.germanBuildupTime)
end

-- Increases the German Build-up progress bar
function SecureRoad_DecreaseAlliedStrength()
	if Objective_IsComplete(OBJ_SecureRoad) or g_alliedStrength <= 0 then
		return
	end
	SecureRoad_UpdateProgress(0.05, true)
	
	eventID_buildUpTimer = Event_Timer(SecureRoad_DecreaseAlliedStrength, nil, t_difficulty.germanBuildupTime)
	
	if g_alliedStrength < 0.76 and g_alliedStrength > 0.74 then
		Util_StartIntel(EVENTS.SecureTheRoad_AlliedStrength75)
	elseif g_alliedStrength < 0.51 and g_alliedStrength > 0.49 then
		Util_StartIntel(EVENTS.SecureTheRoad_AlliedStrength50)
	elseif g_alliedStrength < 0.26 and g_alliedStrength > 0.24 then
		Util_StartIntel(EVENTS.SecureTheRoad_AlliedStrength25)
	end
end

-- Updates the progress bar
function SecureRoad_UpdateProgress(amount, increase)
	local newAmt = g_alliedStrength - amount
	local text = Loc_FormatText(11076801, Loc_ConvertNumber(math.floor(newAmt*100)))		-- LOCDB [11076801] 'Allied Strength in Bastogne: %1STRENGTH%%%'
	Obj_ShowProgress(text, newAmt)
	g_alliedStrength = newAmt
end

