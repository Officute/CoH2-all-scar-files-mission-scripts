print("\tLoading ObjExample file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Eschdorf Challenge
-- Objective File - Eschdorf
-- Designer: Darwin Yuen
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_KillConvoy()
	print("Initializing ObjExample...")
	
	-- Pre-condition:		Mission start
	-- Success condition:	SOBJ_DestroyConvoy completed (Convoy destroyed or crippled)
	-- Failure condition:	Convoy retreats
	-- Post-condition:
	--		Success:		Mission win
	--		Failure:		Mission loss
	OBJ_KillConvoy = {
		--Info
		Title = 11076453, -- LOCDB [11076453] 'Prevent the enemy convoy from leaving Eschdorf'
--~ 		TitleEnd = 11076454, -- LOCDB [11076454] 'All convoy vehicles destroyed'
--~ 		TitleFail = 11076455, -- LOCDB [11076455] 'Enemy convoy escaped'
		Type = OT_Primary,
		Parent = nil,
		subObjectives = {},
		
		--Intel
		Intel_Start = 				EVENTS.KillTheConvoyStart, --nil,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			nil,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				nil,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = function()
				hpid_square = Objective_AddUIElements(OBJ_KillConvoy, mkr_convoyUI, true, 11076456) -- LOCDB [11076456] 'Enemy Convoy'
			end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = function() 
				return g_destroyConvoyBeforeTimerOut or g_destroyMostConvoy 
			end,
		PreComplete = nil,
		OnComplete = function()
				if exitArrow ~= nil then
					MapIcon_Destroy(exitArrow)
				end
				Event_NarrativeEventsNotRunning(Mission_Complete)
			end,
		IsFailed = function() return g_convoyRetreated end,
		PreFail = nil,
		OnFail = function()
				Event_NarrativeEventsNotRunning(Mission_Fail)
			end,
	}
	
	
	SOBJ_DestroyConvoy = {
		Title = 11076457, -- LOCDB [11076457] 'Destroy the enemy convoy before it refuels'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,						
		Parent = OBJ_KillConvoy,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() end,
		PreStart = nil,
		OnStart = function() 
				--Bit of a hack so that it shows on start, but not on end.
				SOBJ_DestroyConvoy.showTitle = false 
			end,
		IsComplete = function()
				if g_convoyDead or g_convoyMostlyDead then				
					return true
				end
			end,
		PreComplete = nil,
		OnComplete = function()
				if g_timerUp == false then
					g_destroyConvoyBeforeTimerOut = true
					
				elseif g_timerUp == true then
					g_destroyMostConvoy = true
				end
			end,
		IsFailed = function()
				return g_convoyRetreated
			end,
		PreFail = nil,
		OnFail = nil,
	}

	table.insert(OBJ_KillConvoy.subObjectives, SOBJ_DestroyConvoy) -- Don't forget to add them to their parent!

end
Scar_AddInit(INIT_KillConvoy)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------


