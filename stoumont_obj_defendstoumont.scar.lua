print("\tLoading ObjExample file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- MISSION NAME
-- Objective File - EXAMPLE
-- Designer: Joe Smith
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_DefendStoumont()
	print("Initializing DefendStoumont...")
	
	-- Pre-condition:		<What are the conditions before the objective starts?>
	-- Success condition:	<What conditions complete the objective?>
	-- Failure condition:	<What conditions fail the objective?>
	-- Post-condition:
	--		Success:		<What happens if the objective is completed?>
	--		Failure:		<What happens if the objective is failed?>
	OBJ_DefendStoumont = {
		--Info
		Title = 11076834,		-- LOCDB [11076834] 'Take and Hold Stoumont'
		Type = OT_Primary,
		Parent = nil,
		subObjectives = {},
		
		--Intel
		Intel_Start = 				nil,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			nil,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				nil,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = function()
			
		end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = function()
		
			if g_axisRetreatedOrDestroyed == true and g_missionOver == false then
				g_missionOver = true
				g_youWin = true		
				return g_axisRetreatedOrDestroyed
			end
		end
		,
		PreComplete = nil,
		OnComplete = function()
			Event_RemoveAll()
			Rule_AddInterval(DelayedEnd, 1) --Event_NarrativeEventsNotRunning?
		end,
		IsFailed = function()
			if g_sanatoriumCaptured == true and g_missionOver == false then
				g_missionOver = true
				g_youFail = true
				return g_youFail
			end
			
		end,
		PreFail = nil,
		OnFail = function()
			Event_RemoveAll()
			Rule_AddInterval(DelayedFailEnd, 1) --Event_NarrativeEventsNotRunning?
		end,
	}
	
	
	
	--TODO: Define any sub-objectives. Remember to add them into the parent's 'subObjectives' table.
	
	
	-- Pre-condition:		
	-- Success condition:	
	-- Failure condition:	
	-- Post-condition:
	--		Success:		
	--		Failure:		
	SOBJ_CapSanatorium = {
		Title = 11076835,		-- LOCDB [11076835] 'Capture the Fuel Point by the Sanatorium'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,						
		Parent = OBJ_DefendStoumont,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() 
			hpid_capture = Objective_AddUIElements(SOBJ_CapSanatorium, eg_sanatorium, true, 11076835, true)			-- [11076835] 'Capture the Fuel Point by the Sanatorium'
		end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = function()
			--XP1_IncrementMissionSuccessLevel(1)
--~ 			if g_axisBossTriggered and g_axisBossDefeated then				
--~ 				if EGroup_IsCapturedByPlayer(eg_allFuel, player2, ANY) == false then
--~ 					g_axisKeptAwayFromFuel = true
--~ 					return g_axisKeptAwayFromFuel
--~ 				end
--~ 			end
		end	
		,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_DefendStoumont.subObjectives, SOBJ_CapSanatorium) -- Don't forget to add them to their parent!
	
	
	SOBJ_CapFuelPoints = {
		Title = 11076836,		-- LOCDB [11076836] 'Seize a Fuel Point to deny Germans fuel for their counterattacks'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Secondary,						
		Parent = SOBJ_CapFuelPoints,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() 
			
			--hpid_fuel2 = Objective_AddUIElements(SOBJ_CapFuelPoints, eg_fuel2, true, 11076837, true)		-- LOCDB [11076837] 'Capture and Hold this Fuel Point'
			--hpid_fuel3 = Objective_AddUIElements(SOBJ_CapFuelPoints, eg_fuel3, true, LOC("Capture and Hold this Fuel Point"), true)
			--hpid_fuel4 = Objective_AddUIElements(SOBJ_CapFuelPoints, eg_fuel4, true, LOC("Capture and Hold this Fuel Point"), true)

			--fuel2Ping = Objective_AddPing(SOBJ_CapFuelPoints, Util_GetPosition(eg_fuel2))			
			--fuel3Ping = Objective_AddPing(SOBJ_CapFuelPoints, Util_GetPosition(eg_fuel3))			
			--fuel4Ping = Objective_AddPing(SOBJ_CapFuelPoints, Util_GetPosition(eg_fuel4))			
		end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = function()
			if EGroup_IsCapturedByPlayer(eg_fuel2, player1, ANY) then

				return true
			
			end
--~ 			if g_axisBossTriggered and g_axisBossDefeated then				
--~ 				if EGroup_IsCapturedByPlayer(eg_allFuel, player2, ANY) == false then
--~ 					g_axisKeptAwayFromFuel = true
--~ 					return g_axisKeptAwayFromFuel
--~ 				end
--~ 			end
		end	
		,
		PreComplete = nil,
		OnComplete = function()
				
			if hpid_fuel2 ~= nil then
				Objective_RemoveUIElements(SOBJ_CapFuelPoints, hpid_fuel2)
			end
				
			if fuel2Ping ~= nil then
				Objective_RemovePing(SOBJ_CapFuelPoints, fuel2Ping)
			end
				
			XP1_IncrementMissionSuccessLevel(1)
				
			if Rule_Exists(NextCapPointObjectiveStart) == false then	
				Util_StartIntel(EVENTS.CapFuelPoints2)
				Rule_AddDelayedInterval(NextCapPointObjectiveStart, 5, 1)
			end
				
		
		end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_DefendStoumont.subObjectives, SOBJ_CapFuelPoints) -- Don't forget to add them to their parent!
	
	SOBJ_CapFuelPoints2 = {
		Title = 11076838,		-- LOCDB [11076838] 'Seize another Fuel Point to deny Germans additional fuel for their counterattacks'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Secondary,						
		Parent = SOBJ_CapFuelPoints2,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() 
			
			--hpid_fuel2 = Objective_AddUIElements(SOBJ_CapFuelPoints2, eg_fuel2, true, LOC("Capture and Hold this Fuel Point"), true)				
			--hpid_fuel3 = Objective_AddUIElements(SOBJ_CapFuelPoints2, eg_fuel3, true, 11076837, true)
			--hpid_fuel4 = Objective_AddUIElements(SOBJ_CapFuelPoints, eg_fuel4, true, LOC("Capture and Hold this Fuel Point"), true)

			--fuel2Ping = Objective_AddPing(SOBJ_CapFuelPoints2, Util_GetPosition(eg_fuel2))			
			--fuel3Ping = Objective_AddPing(SOBJ_CapFuelPoints2, Util_GetPosition(eg_fuel3))			
			--fuel4Ping = Objective_AddPing(SOBJ_CapFuelPoints, Util_GetPosition(eg_fuel4))			
		end,
		PreStart = nil,
		OnStart = function()
			Rule_AddDelayedInterval(DelayedPing2, 5, 1)

		end,
		IsComplete = function()
			if EGroup_IsCapturedByPlayer(eg_fuel3, player1, ANY) then
				
				if hpid_fuel3 ~= nil then
					Objective_RemoveUIElements(SOBJ_CapFuelPoints2, hpid_fuel3)
				end
				
				if fuel3Ping ~= nil then
					Objective_RemovePing(SOBJ_CapFuelPoints2, fuel3Ping)
				end
				
				XP1_IncrementMissionSuccessLevel(1)
				return true
			
			end
--~ 			if g_axisBossTriggered and g_axisBossDefeated then				
--~ 				if EGroup_IsCapturedByPlayer(eg_allFuel, player2, ANY) == false then
--~ 					g_axisKeptAwayFromFuel = true
--~ 					return g_axisKeptAwayFromFuel
--~ 				end
--~ 			end
		end	
		,
		PreComplete = nil,
		OnComplete = function()
		
			
			Util_StartIntel(EVENTS.AllFuelTaken)
		end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_DefendStoumont.subObjectives, SOBJ_CapFuelPoints2) -- Don't forget to add them to their parent!
	
	SOBJ_DefendSanatorium = {
		Title = 11076839,		-- LOCDB [11076839] 'Resist German counterattacks on the Fuel Point at the Sanatorium'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,						
		Parent = OBJ_DefendStoumont,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() 
			hpid_hold = Objective_AddUIElements(SOBJ_DefendSanatorium, eg_sanatorium, true, 11076840, true)			-- LOCDB [11076840] 'Hold the Fuel Point'
		end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = function()
			
--~ 			if g_axisBossTriggered and g_axisBossDefeated then				
--~ 				if EGroup_IsCapturedByPlayer(eg_allFuel, player2, ANY) == false then
--~ 					g_axisKeptAwayFromFuel = true
--~ 					return g_axisKeptAwayFromFuel
--~ 				end
--~ 			end
		end	
		,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_DefendStoumont.subObjectives, SOBJ_DefendSanatorium) -- Don't forget to add them to their parent!
	
	SOBJ_DefeatFinalAssault = {
		Title = 11076841,		-- LOCDB [11076841] 'Defeat the German Final Assault'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Secondary,						
		Parent = OBJ_DefendStoumont,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = function()
			
--~ 			if g_axisBossTriggered and g_axisBossDefeated then				
--~ 				if EGroup_IsCapturedByPlayer(eg_allFuel, player2, ANY) == false then
--~ 					g_axisKeptAwayFromFuel = true
--~ 					return g_axisKeptAwayFromFuel
--~ 				end
--~ 			end
		end	
		,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_DefendStoumont.subObjectives, SOBJ_DefeatFinalAssault) -- Don't forget to add them to their parent!
	
	SOBJ_RefuelVehicle = {
		Title = 11076842,		-- LOCDB [11076842] 'Capture and refuel an abandoned vehicle (50 Fuel)'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Secondary,						
		Parent = SOBJ_RefuelVehicle,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = function()
			
--~ 			if g_axisBossTriggered and g_axisBossDefeated then				
--~ 				if EGroup_IsCapturedByPlayer(eg_allFuel, player2, ANY) == false then
--~ 					g_axisKeptAwayFromFuel = true
--~ 					return g_axisKeptAwayFromFuel
--~ 				end
--~ 			end
		end	
		,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_DefendStoumont.subObjectives, SOBJ_RefuelVehicle) -- Don't forget to add them to their parent!
	
--~ 	SOBJ_AxisDestroyed = {
--~ 		Title = LOC("Destroy remaining German forces"),
--~ 		TitleEnd = nil,
--~ 		TitleFail = nil,
--~ 		Type = OT_Secondary,						
--~ 		Parent = OBJ_DefendStoumont,				
--~ 		
--~ 		Intel_Start = 				nil,		
--~ 		Intel_Start_SkipFunc = 		nil,		
--~ 		Intel_Complete = 			nil,		
--~ 		Intel_Complete_SkipFunc = 	nil,		
--~ 		Intel_Fail = 				nil,		
--~ 		Intel_Fail_SkipFunc = 		nil,		
--~ 		
--~ 		SetupUI = function() end,
--~ 		PreStart = nil,
--~ 		OnStart = nil,
--~ 		IsComplete = function()
--~ 			
--~ 			if g_axisRetreatedOrDestroyed then				
--~ 				return g_axisRetreatedOrDestroyed
--~ 			end
--~ 		end	
--~ 		,
--~ 		PreComplete = nil,
--~ 		OnComplete = nil,
--~ 		IsFailed = nil,
--~ 		PreFail = nil,
--~ 		OnFail = nil,
--~ 	}
--~ 	table.insert(OBJ_DefendStoumont.subObjectives, SOBJ_AxisDestroyed) -- Don't forget to add them to their parent!
	
end
Scar_AddInit(INIT_DefendStoumont)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------

-- This is where any supplemental functions should be written.
-- If any of the objective functions are too big/complex, they should be defined here.




function DelayedEnd()
	--Event_RemoveAll()
	
	if Event_IsAnyRunning() == false then
		Rule_AddInterval(Mission_Complete, 0.5)				
		print("MISSION SUCCESS")
		Rule_RemoveMe()
	end
end

function DelayedFailEnd()
	--Event_RemoveAll()
	if Event_IsAnyRunning() == false then
		Rule_AddInterval(Mission_Fail, 0.5)				
		print("MISSION FAILED")
		Rule_RemoveMe()
	end
end
