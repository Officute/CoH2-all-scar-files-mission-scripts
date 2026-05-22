print("\tLoading ObjExample file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Hardpoint
-- Objective File - VICTORY
-- Designer: Ryan McGechaen
-------------------------------------------------------------------------
-------------------------------------------------------------------------


-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_ObjVictory()
	print("Initializing ObjVictory...")

	OBJ_Victory = {
		--Info
		Title = 11075626, -- LOCDB [11075626] 'Reduce German VP Ticker to 0'
--~ 		TitleEnd = 11075627, -- LOCDB [11075627] 'Heroic Victory'
--~ 		TitleFail = 11075628, -- LOCDB [11075628] 'Brutal Defeat'
		Type = OT_Primary,
		Parent = nil,
		subObjectives = {
		},
		
		--Intel
		Intel_Start = 				nil,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			EVENTS.Victory,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				EVENTS.Defeat,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = function()
			
--~ 			t_captureVPHints = {}
--~ 			
--~ 			for k, point in pairs(t_VPs) do
--~ 				if World_OwnsEGroup(point.eg, ANY) then
--~ 					local hpid = Objective_AddUIElements(OBJ_Victory, EGroup_GetPosition(point.eg), false, 11076794, false, 3)	-- LOCDB [11076794] 'Holding at least one VP will slowly reduce German VP Ticker'
--~ 					table.insert(t_captureVPHints, hpid)
--~ 					point.has_hint = true
--~ 				end
--~ 			end
			
		end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = function() return VPTicker_GetTeamTickers(Player_GetTeam(player2)) <= 0 end,
		PreComplete = nil,
		OnComplete = function() Rule_AddInterval(Mission_Complete, 1) end,
		IsFailed = nil, --function() return VPTicker_GetTeamTickers(Player_GetTeam(player1)) <= 0 end,
		PreFail = nil,
		OnFail = function() Rule_AddInterval(Mission_Fail, 1) end,
	}

	SOBJ_VictoryPoints = {
		Title = 11075629, -- LOCDB [11075629] 'Neutralizing enemy VPs adds 10 to your VP Tickers immediately'
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
--~ 			Rule_AddInterval(HardpointUpdate, VPTickerData.main_rule_interval*2) --seems to require modifier to match normal ticker speed, otherwise slightly faster than normal
			Rule_AddInterval(CheckForNewlyChangedPoints, 0.5)
		end, 
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_Victory.subObjectives, SOBJ_VictoryPoints) -- Don't forget to add them to their parent!
	
end
Scar_AddInit(INIT_ObjVictory)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------

function HardpointUpdate()
	--set values of variables used in this update loop
	if  i_lastKnownCount_EnemyVPs > Player_GetNumVictoryPoints(player2) then
		i_neutralizedVPs = World_GetNumVictoryPoints() - Player_GetNumVictoryPoints(player2) - Player_GetNumVictoryPoints(player1)
	end
	--OffsetPlayerVPLosses()
	--run desired VP Ticker modification functions
	CheckForNewlyChangedPoints()
	--reset variables for the next runthrough of the update
	i_neutralizedVPs = 0
	i_lastKnownCount_EnemyVPs = Player_GetNumVictoryPoints(player2)
end




-- not used any more
function BoostCountdownForAIVPTickers()

	if b_delayComplete and Player_GetNumVictoryPoints(player1) >= 1 then
		
		local adjustedTicker = VPTicker_GetTeamTickers(Player_GetTeam(player2)) - 1 --subtracts one from enemy tickers in addition to points taken using normal VP Match logic
 		VPTicker_SetTeamTickers(Player_GetTeam(player2), adjustedTicker, true)
		
		if t_captureVPHints ~= nil then
			for k, hpid in pairs(t_captureVPHints) do
				Objective_RemoveUIElements(OBJ_Victory, hpid)
			end
			t_captureVPHints = nil
		end
		
		
	end
	
end





function CheckForNewlyChangedPoints()

	-- go through each point
	for index, point in pairs(t_VPs) do 
		
		if EGroup_CountSpawned(point.eg) >= 1 then
			
			local entity = EGroup_GetSpawnedEntityAt(point.eg, 1)
			
			local new_owner = nil
			if World_OwnsEntity(entity) == false then 
				new_owner = Entity_GetPlayerOwner(entity)
			end
			
			-- if it was p2 last turn but is now neutral...
			if point.old_owner == player2 and new_owner == nil then
				
				-- DECAPPED!
				
				local text = Loc_FormatText(11079729, Loc_ConvertNumber(i_neutralizeBonus))
				local pos = Util_GetPosition(entity)
				pos.y = pos.y + 3
				
				UI_CreateColouredPositionKickerMessage(player1, pos, text, 80, 40, 200, 0)
				
				local new_score = VPTicker_GetTeamTickers(Player_GetTeam(player1)) + i_neutralizeBonus
				VPTicker_SetTeamTickers(Player_GetTeam(player1), math.min(new_score, 250), true)
				
			end
			
			-- note the current owner for compariosn next turn
			point.old_owner = new_owner
			
		end
		
	end

end



