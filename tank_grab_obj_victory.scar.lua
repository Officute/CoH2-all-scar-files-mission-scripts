print("\tLoading ObjExample file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Total Domination
-- Objective File - VICTORY
-- Designer: Ryan McGechaen
-------------------------------------------------------------------------
-------------------------------------------------------------------------


-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_ObjVictory()
	print("Initializing ObjVictory...")
	
	-- Pre-condition:		<What are the conditions before the objective starts?>
	-- Success condition:	<What conditions complete the objective?>
	-- Failure condition:	<What conditions fail the objective?>
	-- Post-condition:
	--		Success:		<What happens if the objective is completed?>
	--		Failure:		<What happens if the objective is failed?>
	OBJ_Victory = {
		--Info
		Title = 11075438, -- LOCDB [11075438] 'Use vehicles to kill enemy units'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,
		Parent = nil,
		subObjectives = {
		},
		
		--Intel
		Intel_Start = EVENTS.IntroMsg,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 	EVENTS.Victory,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 	EVENTS.Defeat,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = function()
		end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = function() Rule_AddInterval(Mission_Complete, 1) end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = function() Rule_AddInterval(Mission_Fail, 1) end,
	}
	
	
	
	-- Pre-condition:		
	-- Success condition:	
	-- Failure condition:	
	-- Post-condition:
	--		Success:		
	--		Failure:		
	SOBJ_VictoryPoints = {
		Title = 11075440, -- LOCDB [11075440] 'Only kills by vehicles will reduce enemy victory points'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Information,						
		Parent = OBJ_Victory,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 	nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = function()
			if VPTicker_GetTeamTickers(Player_GetTeam(player2)) <= 0 then
				return true
			end
		end,
		PreComplete = nil,
		OnComplete = function() Objective_Complete(OBJ_Victory) end,
		IsFailed = function()
			if VPTicker_GetTeamTickers(Player_GetTeam(player1)) <= 0 then
				return true
			end
		end,
		PreFail = nil,
		OnFail =  function() Objective_Fail(OBJ_Victory) end,
	}
	table.insert(OBJ_Victory.subObjectives, SOBJ_VictoryPoints) -- Don't forget to add them to their parent!
	
	
	

end
Scar_AddInit(INIT_ObjVictory)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------

