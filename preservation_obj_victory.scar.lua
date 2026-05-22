print("\tLoading ObjExample file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Preservation
-- Objective File - VICTORY
-- Designer: Darwin Yuen
-------------------------------------------------------------------------
-------------------------------------------------------------------------


-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_ObjVictory()
	print("Initializing ObjVictory...")
	
	-- Pre-condition:		Mission start
	-- Success condition:	Callback from VP win conditions - see Battle_WinConditionEndCallback()
	-- Failure condition:	Callback from VP win conditions
	-- Post-condition:
	--		Success:		Mission Win
	--		Failure:		Mission loss
	OBJ_Victory = {
		--Info
		Title = 11075850,           -- LOCDB [11075850] 'Reduce the German VP Tickers to 0'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,
		Parent = nil,
		subObjectives = {
		},
		
		--Intel
		Intel_Start = 				nil,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			EVENTS.Victorious,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				EVENTS.Defeated,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = function()
		end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = function() Rule_AddInterval(Mission_Complete, 1)  end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = function() Rule_AddInterval(Mission_Fail, 1) end,
	}
	
	
	
	SOBJ_Manpower = {
		Title = 11075854,           -- LOCDB [11075854] 'Fight with limited manpower budget'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Information,						
		Parent = OBJ_Victory,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() end,
		PreStart = nil,
		OnStart = function()
			Timer_Start(tmr_manpowerTimer, g_grantTime)
			Rule_AddInterval(Display_Manpower_Countdown,1)
			Rule_AddInterval(ManpowerGrant, 1)
		end,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_Victory.subObjectives, SOBJ_Manpower) -- Don't forget to add them to their parent!
	
	
	SOBJ_OfficerPoints = {
		Title = 11075853,           -- LOCDB [11075853] 'Kill Enemy Officers to get resources faster'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Information,						
		Parent = OBJ_Victory,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_Victory.subObjectives, SOBJ_OfficerPoints) -- Don't forget to add them to their parent!
	
end
Scar_AddInit(INIT_ObjVictory)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------

