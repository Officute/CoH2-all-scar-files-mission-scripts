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
function INIT_ObjJammers()
	print("Initializing ObjJammers")
	

		
	-- Pre-condition:		Wave2 start + Timer.
	-- Success condition:	Mission end.
	-- Failure condition:	Mission end with Jammers still active.
	-- Post-condition:
	--		Success:		n/a
	--		Failure:		n/a
	OBJ_DestroyJammers = {
		Title = 11076641,		-- LOCDB [11076641] 'Locate and destroy the radio jammers'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Secondary,						
		
		Intel_Start = 				EVENTS.InformJammer,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = nil,
		PreStart = function()
				g_jammerActive = true
				Objective_SetCounter(OBJ_DestroyJammers, 0, t_difficulty.numJammers)
				World_EnableSharedLineOfSight(player1, player3, false)
			end,
		OnStart = function()
				
			end,
		IsComplete = function()
				return Objective_IsCounterSet(OBJ_DestroyJammers) and Objective_GetCounter(OBJ_DestroyJammers) >= t_difficulty.numJammers
			end,
		PreComplete = function()
				g_jammerActive = false
				World_EnableSharedLineOfSight(player1, player3, true) 
			end,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}	
end
Scar_AddInit(INIT_ObjJammers)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------


