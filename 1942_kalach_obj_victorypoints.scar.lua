-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- Kalach - 1942 Co-op Scenario
-- Objective File - Victory Points
-- Designer: NJR

-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------
function VP_Init()
	
	--[[ REGISTER OBJECTIVES ]]
	InitialiseObjective_VictoryPoints()
	
	eg_current_victorypoints = EGroup_CreateIfNotFound("eg_current_victorypoints")
	
	
	local soviet_friendly_speech_path	= "speech/mp/soviet/INT/intel/FriendlyTicker/"
	local german_friendly_speech_path	= "speech/mp/german/GAn/Intel/FriendlyTicker/"
	
	local soviet_enemy_speech_path 		= "speech/mp/soviet/INT/intel/EnemyTicker/"
	local german_enemy_speech_path		= "speech/mp/german/GAn/Intel/EnemyTicker/"
	
	t_FriendlyTickerSpeech = 
	{
		Ticker_10 	= { 	soviet	= soviet_friendly_speech_path.."SB_INT_FTS_010Gen_NT_L",	german	= german_friendly_speech_path.."XB_GAn_fts_010Gen_NT_L",	},
		Ticker_25 	= { 	soviet	= soviet_friendly_speech_path.."SB_INT_FTS_025Gen_NT_L",	german	= german_friendly_speech_path.."XB_GAn_fts_025Gen_NT_L",	},
		Ticker_50 	= { 	soviet	= soviet_friendly_speech_path.."SB_INT_FTS_050Gen_NT_L",	german	= german_friendly_speech_path.."XB_GAn_fts_050Gen_NT_L",	},
		Ticker_75 	= { 	soviet	= soviet_friendly_speech_path.."SB_INT_FTS_075Gen_NT_L",	german	= german_friendly_speech_path.."XB_GAn_fts_075Gen_NT_S",	},
		Ticker_100 	= { 	soviet	= soviet_friendly_speech_path.."SB_INT_FTS_100Gen_NT_L",	german	= german_friendly_speech_path.."XB_GAn_fts_100Gen_NT_L",	},
		Ticker_200 	= { 	soviet	= soviet_friendly_speech_path.."SB_INT_FTS_200Gen_NT_L",	german	= german_friendly_speech_path.."XB_GAn_fts_200Gen_NT_L",	},
		Ticker_300 	= { 	soviet	= soviet_friendly_speech_path.."SB_INT_FTS_300Gen_NT_L",	german	= german_friendly_speech_path.."XB_GAn_fts_300Gen_NT_L",	},
	}
	
	t_EnemyTickerSpeech = 
	{
		Ticker_10 	= { 	soviet 	= soviet_enemy_speech_path.."SB_INT_ETS_010Gen_NT_L",		german 	= german_enemy_speech_path.."XB_GAn_ets_010Gen_NT_L",		},
		Ticker_25 	= { 	soviet 	= soviet_enemy_speech_path.."SB_INT_ETS_025Gen_NT_L",		german 	= german_enemy_speech_path.."XB_GAn_ets_025Gen_NT_L",		},
		Ticker_50 	= { 	soviet 	= soviet_enemy_speech_path.."SB_INT_ETS_050Gen_NT_L",		german 	= german_enemy_speech_path.."XB_GAn_ets_050Gen_NT_L",		},
		Ticker_75 	= { 	soviet 	= soviet_enemy_speech_path.."SB_INT_ETS_075Gen_NT_L",		german 	= german_enemy_speech_path.."XB_GAn_ets_075Gen_NT_L",		},
		Ticker_100	= { 	soviet 	= soviet_enemy_speech_path.."SB_INT_ETS_100Gen_NT_S",		german 	= german_enemy_speech_path.."XB_GAn_ets_100Gen_NT_L",		},
		Ticker_200	= { 	soviet 	= soviet_enemy_speech_path.."SB_INT_ETS_200Gen_NT_S",		german 	= german_enemy_speech_path.."XB_GAn_ets_200Gen_NT_L",		},
		Ticker_300 	= { 	soviet 	= soviet_enemy_speech_path.."SB_INT_ETS_300Gen_NT_M",		german 	= german_enemy_speech_path.."XB_GAn_ets_300Gen_NT_L",		},
	}

	-- FIXME: Kill the existing VP stuff
	Rule_AddOneShot(VP_KillRealVPScript, 0.25)
	
end

Scar_AddInit(VP_Init)


function VP_KillRealVPScript()
	Rule_RemoveIfExist(VPTicker_UpdateTickers)
	Rule_RemoveIfExist(VPTicker_MainRule)
end


-------------------------------------------------------------------------
-- [[ REGISTER OBJECTIVE ]]
-------------------------------------------------------------------------
function InitialiseObjective_VictoryPoints()
	
	OBJ_VictoryPoints = {
		
		--
		-- OBJECTIVE INFO
		--
		Title = 11051019,				-- Objective Title   -- LOCDB [11051019] 'Capture and hold the Victory Points'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		
		
		--
		-- START functions
		--
		Intel_Start = nil,				-- This EVENT is called _before_ the new objective actually starts
		Intel_Start_SkipFunc = nil,		-- Function to play if Intel_Start is Skipped
		
		OnStart = function()			-- This is called after any Intel_Start items, and the objective is considered officially started here
			
		end,
		
		SetupUI = function() 			-- This is called alongside the new objective ui animation, but this may occur sometime _after_ the OnStart depending on any running Events
			
		end,
		
		
		--
		-- COMPLETE functions (all ObjectiveUIElements are removed as soon as you call Objective_Complete)
		--
		Intel_Complete = nil,			-- This EVENT is called _before_ the objective actually completes
		Intel_Complete_SkipFunc = nil,	-- Function to play if Intel_Complete is Skipped
		
		OnComplete = function()			-- This is called after any Intel_Complete items, and the objective is considered officially completed here. The objective ui animation happens at this time as well.
			
		end,
		
		
		--
		-- FAIL functions (all ObjectiveUIElements are removed as soon as you call Objective_Fail)
		--
		Intel_Fail = nil,				-- This EVENT is called _before_ the objective actually fails
		Intel_Fail_SkipFunc = nil,		-- Function to play if Intel_Fail is Skipped
		
		OnFail = function()				-- This is called after any Intel_Fail items, and the objective is considered officially failed here. The objective ui animation happens at this time as well.
			
		end,		
	}
	
	Objective_Register(OBJ_VictoryPoints)
	
	
	
	--
	-- Define and register any sub-objectives here, using the same format as above (but include the Parent reference in the Info section)
	--

	OBJ_Description = {
		
		--
		-- OBJECTIVE INFO
		--
		Title = 0,						-- Objective Title -- IN THIS CASE, THIS WILL GET FILLED IN LATER
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		Parent = OBJ_VictoryPoints,		-- Used for sub-objectives to specify its' parent. Remove for top-level objectives.
		
		
		--
		-- START functions
		--
		Intel_Start = nil,				-- This EVENT is called _before_ the new objective actually starts
		Intel_Start_SkipFunc = nil,		-- Function to play if Intel_Start is Skipped
		
		OnStart = function()			-- This is called after any Intel_Start items, and the objective is considered officially started here
			
		end,
		
		SetupUI = function() 			-- This is called alongside the new objective ui animation, but this may occur sometime _after_ the OnStart depending on any running Events
			
		end,
		
		
		--
		-- COMPLETE functions (all ObjectiveUIElements are removed as soon as you call Objective_Complete)
		--
		Intel_Complete = nil,			-- This EVENT is called _before_ the objective actually completes
		Intel_Complete_SkipFunc = nil,	-- Function to play if Intel_Complete is Skipped
		
		OnComplete = function()			-- This is called after any Intel_Complete items, and the objective is considered officially completed here. The objective ui animation happens at this time as well.
			
		end,
		
		
		--
		-- FAIL functions (all ObjectiveUIElements are removed as soon as you call Objective_Fail)
		--
		Intel_Fail = nil,				-- This EVENT is called _before_ the objective actually fails
		Intel_Fail_SkipFunc = nil,		-- Function to play if Intel_Fail is Skipped
		
		OnFail = function()				-- This is called after any Intel_Fail items, and the objective is considered officially failed here. The objective ui animation happens at this time as well.
			
		end,		
	}
	
	Objective_Register(OBJ_Description)
	


end










--
-- Victory Point ticker functions
--



function VP_Start(team1_start_tickers, team2_start_tickers)

	-- if the team2 start tickers was omitted, just make it the same as team1
	team2_start_tickers = team2_start_tickers or team1_start_tickers
	
	-- set up the data
	vp_data = {
		
		team1_start_tickers = team1_start_tickers,
		team1_current_tickers = team1_start_tickers,
		
		team2_start_tickers = team2_start_tickers,
		team2_current_tickers = team2_start_tickers,
		
		active = true,
		
		hintpoints = {},
		
		reminders = {
			{tickers = 750,		friendly_warning = 39367},
			{tickers = 500,		friendly_warning = 39366},
			{tickers = 400,		friendly_warning = 39360},
			{tickers = 300,		friendly_warning = 39361,		enemy_warning = 11046920,	friendly_speech = t_FriendlyTickerSpeech.Ticker_300, 	enemy_speech = t_EnemyTickerSpeech.Ticker_300,	},
			{tickers = 200,		friendly_warning = 39362,		enemy_warning = 11046921,	friendly_speech = t_FriendlyTickerSpeech.Ticker_200, 	enemy_speech = t_EnemyTickerSpeech.Ticker_200,	},
			{tickers = 100,		friendly_warning = 39363,		enemy_warning = 11046922,	friendly_speech = t_FriendlyTickerSpeech.Ticker_100, 	enemy_speech = t_EnemyTickerSpeech.Ticker_100,	},
			{tickers = 75,		friendly_warning = 11046928,	enemy_warning = 11046923,	friendly_speech = t_FriendlyTickerSpeech.Ticker_75, 	enemy_speech = t_EnemyTickerSpeech.Ticker_75,	},
			{tickers = 50,		friendly_warning = 39364,		enemy_warning = 11046924,	friendly_speech = t_FriendlyTickerSpeech.Ticker_50, 	enemy_speech = t_EnemyTickerSpeech.Ticker_50,	},
			{tickers = 25,		friendly_warning = 39365,		enemy_warning = 11046925,	friendly_speech = t_FriendlyTickerSpeech.Ticker_25, 	enemy_speech = t_EnemyTickerSpeech.Ticker_25, 	},
			{tickers = 10,		friendly_warning = 11046929,	enemy_warning = 11046926,	friendly_speech = t_FriendlyTickerSpeech.Ticker_10, 	enemy_speech = t_EnemyTickerSpeech.Ticker_10,	},
			{tickers = 5,		friendly_warning = 11046930,	enemy_warning = 11046927,	friendly_speech = t_FriendlyTickerSpeech.Ticker_5, 		enemy_speech = t_EnemyTickerSpeech.Ticker_5,	},
		},
	}

	-- set the scoreboard in the initial state
	WinWarning_SetMaxTickers(vp_data.team1_start_tickers, vp_data.team2_start_tickers)
	WinWarning_SetTickers(vp_data.team1_current_tickers, vp_data.team2_current_tickers)
	
	Objective_Start(OBJ_VictoryPoints, false)

	-- make the scoring system active
	if Rule_Exists(VP_TickManager) == false then
		Rule_AddInterval(VP_TickManager, 1.5)
	end
	
end


-- Call this and the VP tickers will stop updating
function VP_PauseTickers()
	vp_data.active = false
end


-- Call this and the VP tickers will start updating again
function VP_ResumeTickers()
	vp_data.active = true
end


-- Call this to add a point to consideration (optionally pass in true to get a world arrow on this point, or a LocString to get an arrow plus that message)
function VP_AddPoints(item, worldarrow)

	-- add the item to the internal group of victory points
	if scartype(item) == ST_EGROUP then
		EGroup_AddEGroup(eg_current_victorypoints, item)
	elseif scartype(item) == ST_ENTITY then
		EGroup_Add(eg_current_victorypoints, item)
	end
	
	-- if a world arrow was requested, add that to the objective ui elements
	if worldarrow ~= nil then
		
		local message = 0								-- blank message
		if scartype(worldarrow) ~= ST_BOOLEAN then
			message = worldarrow						-- or the specified message if one was passed in
		end
		
		local hpid = Objective_AddUIElements(OBJ_VictoryPoints, Util_GetPosition(item), false, message, true, 3.7)
		table.insert(vp_data.hintpoints, {where = item, hpid = hpid})
		
	end
	
end


-- Call this to remove a point from consideration
function VP_RemovePoints(item)
	
	if scartype(item) == ST_EGROUP then
		EGroup_RemoveGroup(eg_current_victorypoints, item)
	elseif scartype(item) == ST_ENTITY then
		EGroup_Remove(eg_current_victorypoints, item)
	end

	for n = #vp_data.hintpoints, 1, -1 do 
		
		local this = vp_data.hintpoints[n]
		
		if this.where == item then
			Objective_RemoveUIElements(OBJ_VictoryPoints, this.hpid)
			table.remove(vp_data.hintpoints, n)
		end
		
	end
	
end


-- Call this to remove all points from consideration
function VP_RemoveAllPoints()

	EGroup_Clear(eg_current_victorypoints)

	for n = #vp_data.hintpoints, 1, -1 do 
		
		Objective_RemoveUIElements(OBJ_VictoryPoints, vp_data.hintpoints[n].hpid)
		table.remove(vp_data.hintpoints, n)
		
	end

end


-- Call this to get the current tickers for team 1 or team 2
function VP_GetTeamTickers(index)
	
	if index == 1 then
		return vp_data.team1_current_tickers
	elseif index == 2 then
		return vp_data.team2_current_tickers
	end

end


-- Call this to get the higher ticker count of the two teams
function VP_GetMaxTickers()

	return math.max(vp_data.team1_current_tickers, vp_data.team2_current_tickers)

end


-- Call this to get the lower ticker count of the two teams
function VP_GetMinTickers()

	return math.min(vp_data.team1_current_tickers, vp_data.team2_current_tickers)

end









-- This gets called every second
function VP_TickManager()
	
	if vp_data.active == true then
		
		-- count the number of vps owned for each team
		local vp_count_team1 = 0
		local vp_count_team2 = 0
		local _CountVP = function(gid, idx, eid)
			
			if Team_OwnsEntity(TEAM_ALLIES, eid) then
				vp_count_team1 = vp_count_team1 + 1
			elseif Team_OwnsEntity(TEAM_ENEMIES, eid) then
				vp_count_team2 = vp_count_team2 + 1
			else
				
			end
			
		end
		EGroup_ForEach(eg_current_victorypoints, _CountVP)
		
		-- calculate new ticker values
		if vp_count_team1 > vp_count_team2 then
			
			local difference = vp_count_team1 - vp_count_team2
			vp_data.team2_current_tickers = math.max( (vp_data.team2_current_tickers - difference), 0)
			
		elseif vp_count_team2 > vp_count_team1 then
			
			local difference = vp_count_team2 - vp_count_team1
			vp_data.team1_current_tickers = math.max( (vp_data.team1_current_tickers - difference), 0)
			
		end
		
		
		-- update the scoreboard
		WinWarning_SetTickers(vp_data.team1_current_tickers, vp_data.team2_current_tickers)
		
		
		-- trigger speech when necessary 
		if Player_GetTeam(Game_GetLocalPlayer()) == 0 then
			VP_TriggerSpeech(vp_data.team1_current_tickers, vp_data.team2_current_tickers)
		else
			VP_TriggerSpeech(vp_data.team2_current_tickers, vp_data.team1_current_tickers)
		end
		
		
		-- trigger a win if necessary
		if vp_data.team1_current_tickers == 0 then
			
--~ 			World_SetTeamWin(Player_GetTeam(player3))
			
			Rule_RemoveMe()
			Kalach_MissionFailed()
			
		elseif vp_data.team2_current_tickers == 0 then
			
--~ 			World_SetTeamWin(Player_GetTeam(player1))
			
			Rule_RemoveMe()
			Kalach_MissionComplete()
			
		end
		
		
		
		
		
	end
	
end




function VP_TriggerSpeech(friendly_score, enemy_score)
	
	-- check to see if the player has dropped under a new threshold
	for index = 1, #vp_data.reminders do
		
		local level = vp_data.reminders[index]
		
		if level.friendly_warning ~= nil then
			
			if friendly_score <= level.tickers then
				
				-- show the warning (and remove it so we don't play it again)
				WinWarning_ShowLoseWarning(level.friendly_warning, 0.125, 2.25, 0.125)				
				level.friendly_warning = nil
				
				-- if there's speech to accompany it, play that too
				if level.friendly_speech ~= nil then
					
					local race = Player_GetRaceName(Game_GetLocalPlayer())
					Sound_PlayStreamed( level.friendly_speech[race] )
					
				end
				
				return
				
			end
			
			break
			
		end
		
	end
	



	-- now if we didn't trigger anything there, check to see if the ENEMY has dropped under a new threshold
	for index = 1, #vp_data.reminders do
		
		local level = vp_data.reminders[index]
		
		if level.enemy_warning ~= nil then
			
			if enemy_score <= level.tickers then
				
				-- show the warning (and remove it so we don't play it again)
				WinWarning_ShowLoseWarning(level.enemy_warning, 0.125, 2.25, 0.125)				
				level.enemy_warning = nil
				
				-- if there's speech to accompany it, play that too
				if level.enemy_speech ~= nil then
					
					local race = Player_GetRaceName(Game_GetLocalPlayer())
					Sound_PlayStreamed( level.enemy_speech[race] )
					
				end
				
				return
				
			end
			
			break
			
		end
		
	end
	
end












--
-- Mission Complete
-- 
function Kalach_MissionComplete()
	
	Objective_Complete(OBJ_VictoryPoints)
	Util_StartIntel(EVENTS.MissionWin)
	
	-- retreat all the enemies
	Player_GetAll(player3)
	Cmd_AbandonTeamWeapon(sg_allsquads, false)
	Cmd_Retreat(sg_allsquads, mkr_spawnpoint_p3, mkr_spawnpoint_p3, true)
	Player_GetAll(player4)
	Cmd_AbandonTeamWeapon(sg_allsquads, false)
	Cmd_Retreat(sg_allsquads, mkr_spawnpoint_p4, mkr_spawnpoint_p4, true)
	
	Rule_AddInterval(Kalach_MissionComplete_Done, 0.5)
	
end
function Kalach_MissionComplete_Done()
	
	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		World_SetTeamWin(Player_GetTeam(player1))
		
	end
	
end



--
-- Mission Failed
-- 
function Kalach_MissionFailed()
	
	Objective_Fail(OBJ_VictoryPoints)
	Util_StartIntel(EVENTS.MissionFail)
	
	Rule_AddInterval(Kalach_MissionFailed_Done, 0.5)
	
end
function Kalach_MissionFailed_Done()
	
	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		World_SetTeamWin(Player_GetTeam(player3))
		
	end
	
end



