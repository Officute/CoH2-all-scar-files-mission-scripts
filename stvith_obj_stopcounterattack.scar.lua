print("\tLoading Obj file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- St. Vith
-- Objective File - Stop the counter attack
-- Designer: A.Molina
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_ObjStopCounterattack()
	print("Initializing OBJ_StopCounterattack...")
	
	g_numTerrsLost = 0		-- The number of times a territory has been lost.
	
	-- Pre-condition:		Mission start.
	-- Success condition:	All waves are defeated.
	-- Failure condition:	Player base is destroyed.
	-- Post-condition:
	--		Success:		Mission Complete.
	--		Failure:		Mission failed.
	OBJ_StopCounterattack = {
		--Info
		Title = 11076632,		-- LOCDB [11076632] 'Stop the German Counterattack'
		Type = OT_Primary,
		Parent = nil,
		subObjectives = {},
		checkSubObjectives = true,
		--Intel
		Intel_Start = 				EVENTS.Intro,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			EVENTS.Outro,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				nil,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = nil,
		PreStart = nil,
		OnStart = function()
				Objective_Start(SOBJ_SetupDefenses, false)
			end,
		IsComplete = nil,
		PreComplete = function()
				Obj_HideProgress()
				Rule_Remove(UpdateEnemyForces)
			end,
		OnComplete = function()
				Objective_Complete(SOBJ_HoldChurch, false, true)
				Objective_Complete(SOBJ_HoldRailyard, false, true)
				Objective_Complete(SOBJ_HoldCrossroad, false, true)
			end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	
	
	
	-----------------------------------------
	-- Sub-Objectives
	-----------------------------------------
	-- Pre-condition:		OBJ_StopCounterattack start.
	-- Success condition:	Timeout.
	-- Failure condition:	N/a
	-- Post-condition:
	--		Success:		n/a
	--		Failure:		n/a
	SOBJ_SetupDefenses = {
		Title = 11076633,		-- LOCDB [11076633] 'Setup defenses'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,						
		Parent = OBJ_StopCounterattack,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function()
				Objective_AddUIElements(SOBJ_SetupDefenses, mkr_ui_road, true, 11076633, true)
				Objective_AddUIElements(SOBJ_SetupDefenses, mkr_ui_rail, true, 11076633, true)
				Objective_AddUIElements(SOBJ_SetupDefenses, mkr_ui_church, true, 11076633, true)
			end,
		PreStart = nil,
		OnStart = function()
				Objective_StartTimer(SOBJ_SetupDefenses, COUNT_DOWN, t_difficulty.setupTime, 30)
				Event_Timer(EventHandler_ObjectiveComplete, {objective = SOBJ_SetupDefenses, showTitle = false}, t_difficulty.setupTime+1)
				
				Event_Timer(EventHandler_StartIntel, {intel = EVENTS.InformRecon}, t_difficulty.setupTime-15)
			end,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = function()
				Obj_SetVisible(SOBJ_SetupDefenses.ID, false)
	
				Objective_Start(SOBJ_HoldChurch, false, true)
				Objective_Start(SOBJ_HoldRailyard, false, true)
				Objective_Start(SOBJ_HoldCrossroad, false, true)

				StartWaveDefense()
			end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_StopCounterattack.subObjectives, SOBJ_SetupDefenses)
	
	
	
	
	-- Pre-condition:		SOBJ_SetupDefenses completed.
	-- Success condition:	OBJ_StopCounterattack completed.
	-- Failure condition:	Church territory point is lost.
	-- Post-condition:
	--		Success:		n/a
	--		Failure:		Mission failure.
	SOBJ_HoldChurch = {
		Title = 11076634,		-- LOCDB [11076634] 'Hold the Church'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,						
		Parent = OBJ_StopCounterattack,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = nil,
		PreStart = nil,
		OnStart = function()
				local data = {
					obj = SOBJ_HoldChurch,
					terr = eg_terrChurch,
					eventLoss = EVENTS.LostChurch,
					holdTitle = 11076634,
					recapTitle = 11076635,		-- LOCDB [11076635] 'Recapture the Church territory'
				}
				Event_PlayerOwnsTerritory(TerritoryLost, data, player2, eg_terrChurch, 2)
				Event_PlayerDoesntOwnTerritory(EventHandler_StartIntel, {intel = EVENTS.LosingChurch}, player1, eg_terrChurch, 1)
			end,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = function() 
				Rule_RemoveAll()
				Event_RemoveAll()
			end,
		OnFail = function() FailMission(eg_terrChurch) end,
	}
	table.insert(OBJ_StopCounterattack.subObjectives, SOBJ_HoldChurch)
	
	
	
	-- Pre-condition:		SOBJ_SetupDefenses completed.
	-- Success condition:	OBJ_StopCounterattack completed.
	-- Failure condition:	Railyard territory point is lost.
	-- Post-condition:
	--		Success:		n/a
	--		Failure:		Mission failure.
	SOBJ_HoldRailyard = {
		Title = 11076636,		-- LOCDB [11076636] 'Hold the Railyard'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,						
		Parent = OBJ_StopCounterattack,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = nil,
		PreStart = nil,
		OnStart = function()
				local data = {
					obj = SOBJ_HoldRailyard,
					terr = eg_terrRailyard,
					eventLoss = EVENTS.LostRailyard,
					holdTitle = 11076636,
					recapTitle = 11076637,		-- LOCDB [11076637] 'Recapture the Railyard territory'
				}
				Event_PlayerOwnsTerritory(TerritoryLost, data, player2, eg_terrRailyard, ANY, 2)
				Event_PlayerDoesntOwnTerritory(EventHandler_StartIntel, {intel = EVENTS.LosingRailyard}, player1, eg_terrRailyard)
			end,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = function() 
				Rule_RemoveAll()
				Event_RemoveAll()
			end,
		OnFail = function() FailMission(eg_terrRailyard) end,
	}
	table.insert(OBJ_StopCounterattack.subObjectives, SOBJ_HoldRailyard)
	
	
	
	-- Pre-condition:		SOBJ_SetupDefenses completed.
	-- Success condition:	OBJ_StopCounterattack completed.
	-- Failure condition:	Crossroad territory point is lost.
	-- Post-condition:
	--		Success:		n/a
	--		Failure:		Mission failure.
	SOBJ_HoldCrossroad = {
		Title = 11076638,		-- LOCDB [11076638] 'Hold the Crossroads'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,						
		Parent = OBJ_StopCounterattack,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = nil,
		PreStart = nil,
		OnStart = function()
				local data = {
					obj = SOBJ_HoldCrossroad,
					terr = eg_terrCrossroad,
					eventLoss = EVENTS.LostCrossroad,
					holdTitle = 11076638,
					recapTitle = 11076639,		-- LOCDB [11076639] 'Recapture the Crossroads territory'
				}
				Event_PlayerOwnsTerritory(TerritoryLost, data, player2, eg_terrCrossroad, ANY, 2)
				Event_PlayerDoesntOwnTerritory(EventHandler_StartIntel, {intel = EVENTS.LosingCrossroad}, player1, eg_terrCrossroad)
			end,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = function() 
				Rule_RemoveAll()
				Event_RemoveAll()
			end,
		OnFail = function() FailMission(eg_terrCrossroad) end,
	}
	table.insert(OBJ_StopCounterattack.subObjectives, SOBJ_HoldCrossroad)
	
end
Scar_AddInit(INIT_ObjStopCounterattack)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------
-- Shows and updates a counter with the percentage of units left in the wave defense.
function UpdateEnemyForces()
	
	
	if(g_maxLoadout ~=nil and g_maxLoadout > 0) then
		wavePerc = (WaveDefense_GetTotalWaves() - WaveDefense_GetWave())/WaveDefense_GetTotalWaves()
		alivePerc = (SGroup_TotalMembersCount(WaveDefense_GetCommandSGroup())/g_maxLoadout) / WaveDefense_GetTotalWaves()

		Obj_ShowProgress2(11076640, wavePerc + alivePerc)		-- LOCDB [11076640] 'Remaining Enemy Forces'
	end
end



--Called when a territory is lost. Starts comeback.
function TerritoryLost(data)
	--update the count on how many times a territory has been lost
	g_numTerrsLost = g_numTerrsLost + 1

	-- Inform and update objective display
	Util_StartIntel(data.eventLoss)
	Objective_UpdateText(data.obj, data.recapTitle, nil, false)
	Objective_StartTimer(data.obj, COUNT_DOWN, t_difficulty.comebackTime, t_difficulty.comebackTime/3)
	local hpid_recap = Objective_AddUIElements(data.obj, data.terr, true, data.recapTitle, true, 4)
	local flashObj = UI_FlashObjectiveIcon(data.obj.ID, true)
	Event_Timer(EventHandler_StopFlashing, {flashID = flashObj}, 5)
	
	--Start a timer for full mission failure
	local timer_fail = Event_Timer(FailRecapture, {obj = data.obj}, t_difficulty.comebackTime + 3)
	
	-- Start check for recapture by player
	local newData = {
		obj = data.obj,
		terr = data.terr,
		eventLoss = data.eventLoss,
		holdTitle = data.holdTitle,
		recapTitle = data.recapTitle,
		timerFail = timer_fail,
		hintpoint = hpid_recap,
		blip = UI_CreateMinimapBlip(data.terr, -1, BT_CaptureHere)
	}
	Event_PlayerDoesntOwnTerritory(TerritoryRecaptured, newData, player2, data.terr)
end

--Called if a territory is lost and then recaptured by player.
function TerritoryRecaptured(data)
	-- Stop that particular fail timer (other lost territories can still fail the mission)
	Event_Remove(data.timerFail)
	
	-- Update objective display
	Objective_StopTimer(data.obj)
	Objective_RemoveUIElements(data.obj, data.hintpoint)
	Objective_UpdateText(data.obj, data.holdTitle, nil, false)
	UI_DeleteMinimapBlip(data.blip)
	
	--Start checking again for territory loss
	local newData = {
		obj = data.obj,
		terr = data.terr,
		eventLoss = data.eventLoss,
		holdTitle = data.holdTitle,
		recapTitle = data.recapTitle,
	}
	Event_PlayerOwnsTerritory(TerritoryLost, newData, player2, data.terr, 2)
end

function FailRecapture(data)
	Objective_Fail(data.obj)
end
