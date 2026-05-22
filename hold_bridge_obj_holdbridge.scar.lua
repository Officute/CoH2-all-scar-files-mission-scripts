-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Hold the Bridge - Mini-challenge
-- Objective File - Hold the bridge
-- Designer: Darwin Yuen
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_ObjDefendZone()
	print("Initializing ObjDarwinTest...")
	
	-- Pre-condition:		Mission start
	-- Success condition:	Panzer tank is killed, or bridge is destroyed
	-- Failure condition:	All player units killed OR allied engineers are killed before detpack is placed
	-- Post-condition:
	--		Success:		Mission complete
	--		Failure:		Mission failure
	OBJ_DefendZone = {
		--Info
		Title = LOC("Hold the bridge until engineers arrive"),
		Type = OT_Primary,
		Parent = nil,
		subObjectives = {},
		--Intel
		Intel_Start = 				EVENTS.InstructionIntelEvent,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			nil,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				nil,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = nil,
		PreStart = nil,
		OnStart = nil,
		IsComplete = function() 
				return g_panzerDead or g_bridgeDestroyed
			end,
		PreComplete = function()
				if g_bridgeDestroyed == true and g_tigerDestroyed == false then	
					Util_StartIntel(EVENTS.BridgeDestroyed)
				elseif g_bridgeDestroyed == false and g_tigerDestroyed == true then
					Util_StartIntel(EVENTS.ArmorDestroyed)
				elseif g_bridgeDestroyed == true and g_tigerDestroyed == true then
					Util_StartIntel(EVENTS.DestroyPanzerBridge)
				end
			end,
		OnComplete = function()
				Event_NarrativeEventsNotRunning(Mission_Complete, nil, 2)
			end,
		IsFailed = function()
				return g_youFail
			end,
		PreFail = function()
				Event_RemoveAll()
				Rule_RemoveIfExist(Detpack_UpdateClock)
				
				if g_detPackEngSpawned == true and g_bridgeRigged == false then	
					Util_StartIntel(EVENTS.EngineersKilled)
				elseif g_detPackEngSpawned == true and g_bridgeRigged == true then
					Util_StartIntel(EVENTS.MissionFailEvent)
				else	
					Util_StartIntel(EVENTS.MissionFailEvent)					
				end
			end,
		OnFail = function()
				Event_NarrativeEventsNotRunning(Mission_Fail, nil, 2)		
			end,
	}
	
end

Scar_AddInit(INIT_ObjDefendZone)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!


-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------

