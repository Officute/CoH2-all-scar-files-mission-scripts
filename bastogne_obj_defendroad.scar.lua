print("\tLoading ObjDefendRoad file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Siege of Bastogne
-- Objective File - Defend Road
-- Designer: Ryan McGechaen
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_DefendRoad()
	print("Initializing OBJ_DefendRoad..")
	
	OBJ_DefendRoad = {
		--Info
		Title = 11076804,		-- LOCDB [11076804] 'Defend the Central Road Points'
		Type = OT_Primary,
		Parent = nil,
		subObjectives = {SOBJ_DefendRoadStart},
		--Intel
		Intel_Start = 				EVENTS.DefendTheRoad_Start,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			EVENTS.DefendTheRoad_Complete,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				EVENTS.DefendTheRoad_Fail,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = function()
			hpid_obj_defend_02 = Objective_AddUIElements(OBJ_DefendRoad, Util_GetOffsetPosition(eg_road_2, OFFSET_LEFT,1), true, 11076805, true)		-- LOCDB [11076805] 'Defend the Territory'
			hpid_obj_defend_03 = Objective_AddUIElements(OBJ_DefendRoad, Util_GetOffsetPosition(eg_road_3, OFFSET_LEFT,1), true, 11076805, true)
			
			hpid_attackDir_01 = HintPoint_Add(mkr_counterAttack_dir_01, true, 11076806)		-- LOCDB [11076806] 'Potential attack direction'
			hpid_attackDir_02 = HintPoint_Add(mkr_counterAttack_dir_02, true, 11076806)
			hpid_attackDir_03 = HintPoint_Add(mkr_counterAttack_dir_03, true, 11076806)
			
			World_IncreaseInteractionStage()
		end,
		PreStart = function()
			Rule_AddInterval(Bastogne_ClearWrecksOffRoad, 1)
			
			for k,v in pairs(t_startEncounters) do
				local sg = v.enc:GetSgroup()
				Cmd_Retreat(sg, mkr_e_retreat_01, mkr_e_retreat_01)
			end
		end,
		OnStart = function()
			-- Define Variables
			t_spotted = {
				EVENTS.DefendTheRoad_Contact_01,
				EVENTS.DefendTheRoad_Contact_02,
				EVENTS.DefendTheRoad_Contact_03,
				EVENTS.DefendTheRoad_Contact_04,
				EVENTS.DefendTheRoad_Contact_05,
			}
			
			-- Defines territory monitor data
			__terrMonitorData = {}
			__terrMonitorData.territories = {
				{
					egroup = eg_road_2,
					counter = 0,
				},
				{
					egroup = eg_road_3,
					counter = 0,
				},
			}
			
			-- Determine how many attacks will occur and divide the 
			-- progress bar accordingly
			
			-- If the player managed to skip SecureObj, we set the German Strength
			if g_wounded == 0 then
				g_wounded = 0.5
			end
			
			local text = Loc_FormatText(11076807, Loc_ConvertNumber(100))	-- LOCDB [11076807] 'Allied Wounded left to Evac: %1PERCENT%%%'
			Obj_ShowProgress2(text, 1)
			
			g_amount = 0
			g_totalWaves = 0
			if g_wounded <= 0.5 then
				g_amount = 0.33
				g_totalWaves = 3
				print("3 Defense Waves will spawn")
				XP1_SetMissionSuccessLevel(3)
			elseif g_wounded > 0.50 and g_wounded <= 0.75 then
				g_amount = 0.25
				g_totalWaves = 4
				print("4 Defense Waves will spawn")
				XP1_SetMissionSuccessLevel(2)
			elseif g_wounded > 0.75 and g_wounded <= 1 then
				g_amount = 0.2
				g_totalWaves = 5
				print("5 Defense Waves will spawn")
				XP1_SetMissionSuccessLevel(1)
			end
			
			g_startProgress = 1		-- Progress that we start at each time we count down the progress bar
									-- This will update each time a chunk of wounded escape
			g_finishProgress = 0	-- Determines when we should stop counting down the progress bar for this chunk of wounded
									-- Set in the functions below
			
			-- Wave Manager Data setup
			g_counterAttack = WaveManager_SetupNewManagerTable(WAVEMANAGERS.Enemy_Road_Counter_Attack)
			
			Event_Timer(DefendRoad_StartWave, nil, t_difficulty.defendStartTime)
			
			-- Start Intel events for ambulences spotted
			Event_PlayerCanSeeElement(EventHandler_StartIntel, {intel = EVENTS.DefendTheRoad_AmbulencesEntering}, player1, sg_a_ambulences_entering, 5)
			Event_PlayerCanSeeElement(EventHandler_StartIntel, {intel = EVENTS.DefendTheRoad_AmbulencesLeaving}, player1, sg_a_ambulences_leaving, 5)
			
			Rule_AddDelayedInterval(Bastogne_SpawnAmbulence, 3, 3)
			
			Objective_Start(SOBJ_DefendRoadStart, false)
		end,
		IsComplete = function()
--~ 			return (g_startProgress <= 0.01)
			return (g_waves_complete == true)
		end,
		PreComplete = nil,
		OnComplete = function()
			Rule_AddInterval(Mission_Complete, 1) 
		end,
		IsFailed = function()
			return (Player_OwnsEGroup(player2, eg_defendRoadPoints, ANY)) --(Player_OwnsEGroup(player2, eg_road_2, ANY) or Player_OwnsEGroup(player2, eg_road_2))
		end,
		PreFail = nil,
		OnFail = function() 
			Rule_Remove(Bastogne_SpawnAmbulence)
			Rule_AddInterval(Mission_Fail, 1) 
		end,
	}
	
	SOBJ_DefendRoadStart = {
		--Info
		Title = 11076808,		-- LOCDB [11076808] 'Time until German Attack:'
		Type = OT_Primary,
		Parent = OBJ_DefendRoad,
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
		OnStart = function()
			Objective_StartTimer(SOBJ_DefendRoadStart, COUNT_DOWN, t_difficulty.defendStartTime)
			UI_CreateMinimapBlip(eg_road_2, 20.0, BT_DefendHere)
			UI_CreateMinimapBlip(eg_road_3, 20.0, BT_DefendHere)
		end,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	
	table.insert(OBJ_DefendRoad.subObjectives, SOBJ_DefendRoadStart)
	
end
Scar_AddInit(INIT_DefendRoad)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------

function DefendRoad_Start()
	Objective_Start(OBJ_DefendRoad)
	Modify_CaptureTime(eg_defendRoadPoints, 0.25) 
end

function DefendRoad_NextWave()
--~ 	if WaveManager_GetWave(g_counterAttack) < WaveManager_GetTotalWaves(g_counterAttack) then
	if WaveManager_GetWave(g_counterAttack) < g_totalWaves then
		WaveManager_NextWave(g_counterAttack)
		DefendRoad_StartWave()
	end
end

function DefendRoad_StartWave()
	if Objective_IsVisible(SOBJ_DefendRoadStart) then
		Objective_Show(SOBJ_DefendRoadStart, false)
	end
	
	WaveManager_SelectSpawns(g_counterAttack)
	WaveManager_SpawnWave(g_counterAttack)
	
--~ 	SGroup_Clear(sg_temp)
--~ 	Player_GetAll(player2, sg_temp)
--~ 	Modify_SquadCaptureRate(sg_temp, 0.001)
	
	if scartype(hpid_attackDir_01) ~= ST_NIL then
		HintPoint_Remove(hpid_attackDir_01)
		hpid_attackDir_01 = nil
	end
	if scartype(hpid_attackDir_02) ~= ST_NIL then
		HintPoint_Remove(hpid_attackDir_02)
		hpid_attackDir_02 = nil
	end
	if scartype(hpid_attackDir_03) ~= ST_NIL then
		HintPoint_Remove(hpid_attackDir_03)
		hpid_attackDir_03 = nil
	end
end

function DefendRoad_WaveSpawn()
	FOW_RevealSGroupOnly(sg_e_counter_attack_all, 0)
end

-- Plays when the player sees a wave
function DefendRoad_WaveSpotted()

	if table.getn(t_spotted) >= 1 then
		local num = World_GetRand(1, table.getn(t_spotted))
		
		Util_StartIntel(t_spotted[num])
		
		table.remove(t_spotted, num)
	end
end

-- Occurs at end of attack wave
function DefendRoad_WaveEnd()
	-- if we're done with waves, then do nothing
	if WaveManager_GetWave(g_counterAttack) >= g_totalWaves then
		Obj_HideProgress()
		g_waves_complete = true
		return
	else
		-- start a new wave
		if Objective_IsVisible(SOBJ_DefendRoadStart) then
			Objective_Show(SOBJ_DefendRoadStart, true)
			Objective_StartTimer(SOBJ_DefendRoadStart, COUNT_DOWN, 60)
		end
		Rule_AddDelayedInterval(Bastogne_SpawnAmbulence, 0, 3)
		Rule_AddOneShot(DefendRoad_WoundedEvacUI, 6)
		Event_Timer(DefendRoad_NextWave, nil, 60)
	end
end

-- Fires off the logic to decrease the UI bar after a wave
function DefendRoad_WoundedEvacUI()
	g_finishProgress = g_startProgress-g_amount
	
	Rule_AddInterval(DefendRoad_DecreaseUI, 0.5)
end

-- Actually decreases the progress bar
function DefendRoad_DecreaseUI()
	local amountToRemove = g_startProgress - 0.01
	g_startProgress = g_startProgress - 0.01
	
	if amountToRemove < 0 then
		amountToRemove = 0
	end
	
	local text = Loc_FormatText(11076809, Loc_ConvertNumber(math.floor(amountToRemove*100)))		-- LOCDB [11076809] 'Allied Wounded left to Evac: %1WOUNDED%%%'
	Obj_ShowProgress2(text, g_startProgress)
	
	if g_startProgress <= g_finishProgress then
		Rule_Remove(DefendRoad_DecreaseUI)
		return
	end
end



