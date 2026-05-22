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
	
	-- Pre-condition:		Mission start
	-- Success condition:	SOBJ_VictoryPoints completed
	-- Failure condition:	SOBJ_VictoryPoints  failed
	-- Post-condition:
	--		Success:		Mission win
	--		Failure:		Mission loss
	OBJ_Victory = {
		--Info
		Title = 11075445, -- LOCDB [11075445] 'Reduce the Germans to zero Victory Point tickers'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,
		Parent = nil,
		subObjectives = {
		},
		
		--Intel
		Intel_Start = 				EVENTS.IntroMsg,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			EVENTS.Victory,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				EVENTS.Defeat,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = function()
		end,
		PreStart = nil,
		OnStart = function()
			Objective_Start(SOBJ_VictoryPoints, false)
	
		end,
		IsComplete = function()
			return VPTicker_GetTeamTickerFromPlayerID(player2) <= 0 
		end,
		PreComplete = nil,
		OnComplete = function() 
			Rule_AddInterval(Mission_Complete, 1) 
			print("OnComplete has been triggered")
		end,
		IsFailed = function()
			return VPTicker_GetTeamTickerFromPlayerID(player1) <= 0 
		end,
		PreFail = nil,
		OnFail = function() 
			Rule_AddInterval(Mission_Fail, 1) 
		end,
	}
	
	
	
	-- Pre-condition:		OBJ_Victory starts
	-- Success condition:	Called from global WinConditions logic. See Battle_WinConditionEndCallback()
	-- Failure condition:	..
	-- Post-condition:
	--		Success:		Complete OBJ_Victory
	--		Failure:		Fail OBJ_Victory
	SOBJ_VictoryPoints = {
		Title = 11075446, -- LOCDB [11075446] 'Destroying enemy vehicles will also reduce the enemy’s tickers'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Information,						
		Parent = OBJ_Victory,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			EVENTS.Victory,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				EVENTS.Defeat,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() end,
		PreStart = nil,
		OnStart = function()
			Objective_Start(SOBJ_VictoryInfo, false)
			-- start reinforcements timer
			Timer_Start(tmr_reinforcements, t_difficulty.g_player_delay)
			Rule_AddInterval(CheckRespawnTimer, 1)
			Rule_AddInterval(Display_Countdown,1)
		end,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_Victory.subObjectives, SOBJ_VictoryPoints) -- Don't forget to add them to their parent!
	
	
	-- this objective is just help text to explain to the player that destroying vehicles makes the Germans lose VPs
	SOBJ_VictoryInfo = {
		Title = 11075447, -- LOCDB [11075447] 'You will receive periodic armor reinforcements'
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
	table.insert(OBJ_Victory.subObjectives, SOBJ_VictoryInfo) -- Don't forget to add them to their parent!
	
	
end
Scar_AddInit(INIT_ObjVictory)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------

