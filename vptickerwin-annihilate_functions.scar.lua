function _initdata()

	-- Constant
	RACE_STRING_ALLIES = "soviet"
	RACE_STRING_AXIS = "german"
	
	-- SOUND FILES
	SOUND_VICTORY_BALANCE_ALLIES	= "speech/mp/soviet/INT/intel/VictoryBalChange/"
	SOUND_VICTORY_BALANCE_AXIS		= "speech/mp/german/GAn/Intel/VictoryBalChange/"
	
	SOUND_TICKER_WARNING_FINAL		= "UI/EventCues/CountdownBeep"
	
	Sound_PreCacheSound(SOUND_TICKER_WARNING_FINAL)

	--
	FINAL_TICKER_WARNING_TICKER_LEISURE	= 50
	FINAL_TICKER_WARNING_TICKER_URGENT	= 25
	
	
	table_VictoryBalanceStatusSpeech = 
	{
		-- has more points and more ticket than enemy
		Advantage_More_Ticket
					= {
						allies 	= SOUND_VICTORY_BALANCE_ALLIES.."SB_INT_VBL_MajMor_NT_S",
						axis 	= SOUND_VICTORY_BALANCE_AXIS.."XB_GAN_VBL_MajMor_NT_S",
					},
		
		-- has more points but less ticket currently than enemy
		Advantage_Less_Ticket
					= {
						allies 	= SOUND_VICTORY_BALANCE_ALLIES.."SB_INT_VBL_MajLss_NT_S",
						axis 	= SOUND_VICTORY_BALANCE_AXIS.."XB_GAN_VBL_MajLss_NT_S",
					},
		
		-- has less points and less ticket than enemy
		Disadvantage_Less_Ticket
					= {
						allies 	= SOUND_VICTORY_BALANCE_ALLIES.."SB_INT_VBL_MinLss_NT_S",
						axis 	= SOUND_VICTORY_BALANCE_AXIS.."XB_GAN_VBL_MinLss_NT_S",
					},
		
		-- has less points but more ticket currently than enemy
		Disadvantage_More_Ticket
					= {
						allies 	= SOUND_VICTORY_BALANCE_ALLIES.."SB_INT_VBL_MinMor_NT_S",
						axis 	= SOUND_VICTORY_BALANCE_AXIS.."XB_GAN_VBL_MinMor_NT_S",
					},
			
		-- enemy holds all points
		Disadvantage_Enemy_Hold_All 
					= {
						allies 	= SOUND_VICTORY_BALANCE_ALLIES.."SB_INT_VBL_EALGen_NT_S",
						axis 	= SOUND_VICTORY_BALANCE_AXIS.."XB_GAN_VBL_EALGen_NT_S",
					},
					
		Tie = 		{
						allies 	= SOUND_VICTORY_BALANCE_ALLIES.."SB_INT_VBL_TieGen_NT_S",
						axis 	= SOUND_VICTORY_BALANCE_AXIS.."XB_GAN_VBL_TieGen_NT_S",
					},					
	}

	-----------------------------------------------------------------------
	-- Private data for this win condition
	-----------------------------------------------------------------------
	VPTickerData =
	{
		-- number of points each team starts with
		-- TODO: this should be read in from the game options
		start_points = Setup_GetWinConditionOption(), 
		
		-- total number of victory points in the the level
		world_point_count = World_GetNumVictoryPoints(),
		
		-- number of tickers you get per strategic point
		ticker_per_point = 1.0,
		own_all_points_bonus = 2.0,
		
		-- interval (in seconds,) that the main rule is called
		main_rule_interval = 4.0,
		
		-- ui/audio cue warnings are issued to players at certain tick counts
		-- DO NOT TOUCH w/out asking UI and audio designers, speech/text may be specific
		ticker_warnings =
		{
			20,			-- warning#1 - very intense
			30,			-- warning#2 - intense
			60,			-- warning#3 - not intense
			150,		-- warning#4 - casual
		},
		
		-- stores ticker values and number of points captured, indexed by team (each team can have multiple players)
		team_data = {},
		
		-- stores flag when points held has been changed. Used to trigger victory balance speeches
		points_updated = false,
		
		-- stores flag for enabling or disabling ending the game when victory points reach zero
		endingEnabled = true,
		
		-- stores flag for being able to pause the countdown - to be used for Single Player ONLY
		paused = false,
	}

end

function IsAllies(raceString)
	return raceString == RACE_STRING_ALLIES
end

function IsAxis(raceString)
	return raceString == RACE_STRING_AXIS
end

-----------------------------------------------------------------------
-- Global flags (used externally)
--  must be global because we don't know the order the Init functions
--  are called.
-----------------------------------------------------------------------
function SetGlobals()
	-- this is used externally to know that this condition is running
	g_VPConditionsLoaded = true
end

-----------------------------------------------------------------------
-- OnInit - Main script entry point (not called for saved games)
-----------------------------------------------------------------------
local totalPointsOnMap = 0
function VPTicker_OnInit()
	-- initialize the data for this gametype
	_initdata()
	
	WinWarning_SetMaxTickers(VPTickerData.start_points, VPTickerData.start_points)
	
	-- must set these everytime because the global vars are cleared at gameend, so 
	-- a restart will not work since the vars are nil
	SetGlobals()
	totalPointsOnMap = #WorldEntityCollector:GetEntities("victory_point")
	
	-- initialize the team data table
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		local teamId = Player_GetTeam(player)
		if VPTickerData.team_data[teamId] == nil then
			VPTickerData.team_data[teamId] = 
			{
				tickers = VPTickerData.start_points,
				points_held = 0,
				victory_balance = 0,
				pausedPoints = 0,
			}
		end
	end

	-- register the main rule to get called at given interval
	Rule_AddInterval(VPTicker_MainRule, VPTickerData.main_rule_interval)
	Rule_AddInterval(VPTicker_UpdateTickers, 0.25)

	-- add reminders when ticker points reach certain levels
	Rule_AddInterval(VPTicker_PointReminder, 1)
end

--This function exists to fix data in old saved games that are using teams 1 and 2 instead of teams 0 and 1
function FixUpVPTickerData()
	if VPTickerData.team_data[0] == nil and VPTickerData.team_data[1] ~= nil and VPTickerData.team_data[2] ~= nil then
		VPTickerData.team_data[0] = VPTickerData.team_data[1]
		VPTickerData.team_data[1] = VPTickerData.team_data[2]
		VPTickerData.team_data[2] = nil
	end
end

function VPTicker_UpdateTickers()
	FixUpVPTickerData()

	local team1Tickers = VPTicker_GetTeamTickers(0)
	local team2Tickers = VPTicker_GetTeamTickers(1)
	
	WinWarning_SetTickers(team1Tickers, team2Tickers)
	WinWarning_SetCritical(100 * team1Tickers / VPTickerData.start_points <= 20, 100 * team2Tickers / VPTickerData.start_points <= 20)
	
	Misc_SyncCheckVariable("Team 1 Tickers", team1Tickers)
	Misc_SyncCheckVariable("Team 2 Tickers", team2Tickers)
end

-----------------------------------------------------------------------
-- MainRule - Called every so often to process the win condition
-----------------------------------------------------------------------
function VPTicker_MainRule()

	if VPTickerData.paused == true then
		return
	end
	
	FixUpVPTickerData()

	-- reset updated flag 
	VPTickerData.points_updated = false
	
	-- update points count
	local mostVP = 0
	for teamId,data in pairs(VPTickerData.team_data) do
		local points = VPTicker_GetTeamVictoryPoints(teamId)
		
		if points > mostVP then
			mostVP = points
		end
		
		-- check for changes
		if (points ~= data.points_held) then
			VPTickerData.points_updated = true
		end
		
		data.points_held = points
		Misc_SyncCheckVariable("Points Held", data.points_held)
	end
	
	-- decrement all other teams points
	local losers = {}
	for teamId,data in pairs(VPTickerData.team_data) do
		if (data.points_held < mostVP) then
			if (not(data.updatePaused)) then
				-- decrement
				local diffVP = mostVP - data.points_held
				local newTickers = math.max(0, VPTicker_GetTeamTickers(teamId) - (diffVP * VPTickerData.ticker_per_point))
				
				VPTicker_SetTeamTickers(teamId, newTickers)
				
				-- check for win
				if newTickers == 0 then
					table.insert(losers, teamId)
				end
			else
				-- team is currently no longer losing victory points, track what they may have lost during this time
				data.pausedPoints = data.pausedPoints + (mostVP - data.points_held)
			end
		end
	end
	
	if #losers >= 1 then
		if #losers == 1 then
			VPTicker_GameOverLose(losers[1])
		else
			VPTicker_GameOverTie()
		end
	end
end

-----------------------------------------------------------------------
-- GameOverLose - The game has ended with a losing team
-----------------------------------------------------------------------
function VPTicker_GameOver(winningTeam, losingTeam)
	--Callback for special win conditions. Should be declared within the win conditions .scar file (.../Scar/WinConditions/) or a scenario script
	if(scartype(WinConditionEndCallback) == ST_FUNCTION) then
		WinConditionEndCallback(winningTeam)
	else
		-- Set the winning team (this will fire win/loss events for each player)
		World_SetTeamWin(winningTeam)

		local winningPlayers = Team_GetPlayers(winningTeam)
		local losingPlayers = Team_GetPlayers(losingTeam)
		
		Fatality_Execute(winningPlayers, losingPlayers)
	end
end

function VPTicker_GameOverLose(losingTeam)
	if VPTickerData.endingEnabled == false then
		Rule_RemoveMe()
	else
		Rule_RemoveAll()
		VPTicker_UpdateTickers()
		
		local winningTeam = Team_GetEnemyTeam(losingTeam)
		
		-- If this Scenario has a custom victory action/message (e.g. various ToW scenarios), call that
		if (VPVictoryMessage) and (scartype(VPVictoryMessage) == ST_FUNCTION) then
			-- Only fire the function if a human player's team has won
			if(Team_HasHuman(winningTeam)) then
				VPVictoryMessage()
				Event_NarrativeEventsNotRunning(VPTicker_DelayedWin, {winningTeam = winningTeam, losingTeam = losingTeam}, 1)
			else
				VPTicker_GameOver(winningTeam, losingTeam)
			end
		else
			VPTicker_GameOver(winningTeam, losingTeam)
		end
	end
end

function VPTicker_DelayedWin(data)
	Game_SetMode(UI_Normal)
	Camera_SetInputEnabled(true)
	VPTicker_GameOver(data.winningTeam, data.losingTeam)
end

-----------------------------------------------------------------------
-- The game has ended in a tie
-----------------------------------------------------------------------
function VPTicker_GameOverTie()
	if VPTickerData.endingEnabled == false then
		Rule_RemoveMe()
	else
		Rule_RemoveAll()
		VPTicker_UpdateTickers()
		
		-- No teams win, no teams lose, the game is just over
		World_SetGameOver()
	end
end

-----------------------------------------------------------------------
-- Helper functions
-----------------------------------------------------------------------

-----------------------------------------------------------------------
-- Sets the ticker points for a given team and updates the UI.
-- Also issues a UI/Audio ticker warning if applicable
-----------------------------------------------------------------------
function VPTicker_SetTeamTickers(teamId, tickers, silent)
	-- validate params
	if VPTickerData.team_data[teamId] == nil then error("invalid teamId "..teamId) end

	if silent == true then
		if (tickers < table_VPTickerLastPlayed[0]) then
			table_VPTickerLastPlayed[0] = tickers
		end
		if (tickers < table_VPTickerLastPlayed[1]) then
			table_VPTickerLastPlayed[1] = tickers
		end
	end
	
	-- check if we need to issue a ticker warning
	local curTickers = VPTickerData.team_data[teamId].tickers
	for k,v in pairs(VPTickerData.ticker_warnings) do
		if curTickers >= v and tickers < v then
			-- the lower the value of k is, the more intense the warning is
			VPTicker_PublishLoseReminder(teamId, k)
		end
	end
	
	-- store new value
	VPTickerData.team_data[teamId].tickers = tickers
end

function VPTicker_SetAllTeamTickers(tickers, silent)

	if silent == true then
		if (tickers < table_VPTickerLastPlayed[0]) then
			table_VPTickerLastPlayed[0] = tickers
		end
		if (tickers < table_VPTickerLastPlayed[1]) then
			table_VPTickerLastPlayed[1] = tickers
		end
	end
	
	for a,b in pairs(VPTickerData.team_data) do
		
		-- validate params
		if VPTickerData.team_data[a] == nil then error("invalid teamId "..teamId) end
		
		-- check if we need to issue a ticker warning
		local curTickers = VPTickerData.team_data[a].tickers
		for k,v in pairs(VPTickerData.ticker_warnings) do
			if curTickers >= v and tickers < v then
				-- the lower the value of k is, the more intense the warning is
				VPTicker_PublishLoseReminder(a, k)
			end
		end
		
		-- store new value
		VPTickerData.team_data[a].tickers = tickers
		
	end
end

----------------------------------------------------------------------
-- Returns the number of tickers for a given team
-----------------------------------------------------------------------
function VPTicker_GetTeamTickers(teamId)
	-- validate params
	if VPTickerData.team_data[teamId] == nil then error("invalid teamId "..teamId) end
	
	return VPTickerData.team_data[teamId].tickers
end

----------------------------------------------------------------------
-- Returns the number of tickers for a given player
-----------------------------------------------------------------------
function VPTicker_GetTeamTickerFromPlayerID(playerId)
	local teamId = Player_GetTeam(playerId)	
	return VPTicker_GetTeamTickers(teamId)
end

-----------------------------------------------------------------------
-- Send a reminder event for all players on a given team that they're
--  about to lose the game.
-- The lower the warningLevel, the more intense the event is
-----------------------------------------------------------------------
function VPTicker_PublishLoseReminder(teamId, warningLevel)
	-- validate params
	if warningLevel < 1 then error("invalid warningLevel "..warningLevel.." (out of range)") end
	
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		if teamId == (Player_GetTeam(player)) then
			WinWarning_PublishLoseReminder(player, warningLevel)
		end
	end
end

-----------------------------------------------------------------------
-- Returns the number of victory points for a given team
-----------------------------------------------------------------------
function VPTicker_GetTeamVictoryPoints(teamId)
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		if Player_IsAlive(player) and teamId == (Player_GetTeam(player)) then
			-- this actually returns the victory points for that player's TEAM!
			-- if you want to count manually in lua, you must iterate all the team's players
			return Player_GetNumVictoryPoints(player)
		end
	end
	
	return 0
end

--This function exists to fix data in old saved games that are using teams 1 and 2 instead of teams 0 and 1
function FixUpVPTickerLastPlayedData()
	if table_VPTickerLastPlayed[0] == nil and table_VPTickerLastPlayed[1] ~= nil and table_VPTickerLastPlayed[2] ~= nil then
		table_VPTickerLastPlayed[0] = table_VPTickerLastPlayed[1]
		table_VPTickerLastPlayed[1] = table_VPTickerLastPlayed[2]
		table_VPTickerLastPlayed[2] = nil
	end
end

-- Remind players what ticker points are at
function VPTicker_PointReminder()
	if _VPTickerReminders_runOnce ~= 1 then
				
		table_VPTickerReminders = {}
		
		table_VPTickerReminders[1] = {tickerValue = 750, loseWarning = 39367}
		table_VPTickerReminders[2] = {tickerValue = 500, loseWarning = 39366}
		table_VPTickerReminders[3] = {tickerValue = 400, loseWarning = 39360}
		table_VPTickerReminders[4] = {tickerValue = 300, loseWarning = 39361, 	enemyLoseWarning = 11046920}
		table_VPTickerReminders[5] = {tickerValue = 200, loseWarning = 39362, 	enemyLoseWarning = 11046921}
		table_VPTickerReminders[6] = {tickerValue = 100, loseWarning = 39363, 	enemyLoseWarning = 11046922}
		table_VPTickerReminders[7] = {tickerValue = 75,  loseWarning = 11046928,enemyLoseWarning = 11046923}
		table_VPTickerReminders[8] = {tickerValue = 50,  loseWarning = 39364, 	enemyLoseWarning = 11046924}
		table_VPTickerReminders[9] = {tickerValue = 25,  loseWarning = 39365, 	enemyLoseWarning = 11046925}
		table_VPTickerReminders[10] = {tickerValue = 10, loseWarning = 11046929,enemyLoseWarning = 11046926}
		table_VPTickerReminders[11] = {tickerValue = 5,  loseWarning = 11046930,enemyLoseWarning = 11046927}
		
		-- Mark the team data as have already having played any ticker warnings at or above the starting values
		table_VPTickerLastPlayed = {}
		table_VPTickerLastPlayed[0] = VPTickerData.start_points;
		table_VPTickerLastPlayed[1] = VPTickerData.start_points;

		_VPTickerReminders_runOnce = 1
	end
	
	FixUpVPTickerData()
	FixUpVPTickerLastPlayedData()

	-- Victory status speech
	VPTicker_VictorySpeechReminder()

	-- Victory balance Speech
	if (VPTickerData.points_updated) then
		if(Game_HasLocalPlayer() == true) then
			-- TODO there seems to be no speech for this, some unrelated speech is in the folder however
			Rule_AddOneShot(VPTicker_VictoryBalanceReminder, VPTickerData.main_rule_interval*0.5)
		end
		
		-- reset ticket until next time points are updated
		VPTickerData.points_updated = false
	end
	
	-- Final ticker warning speech
	VPTicker_FinalTickerWarningReminder()
end

function VPTicker_VictorySpeechReminder()
	if(Game_HasLocalPlayer() == false) then
		return
	end
	
	local localRaceSTRING = Player_GetRaceName(Game_GetLocalPlayer())
	local localTeamId = Player_GetTeam(Game_GetLocalPlayer())
	local enemyTeamId = Team_GetEnemyTeam(localTeamId)
	
	local localTeamTickers = VPTicker_GetTeamTickers(localTeamId);
	local enemyTeamTickers = VPTicker_GetTeamTickers(enemyTeamId);

	for i = 1, table.getn(table_VPTickerReminders) do
		local reminder = table_VPTickerReminders[i]

		-- check for friendly messages (warnings that we will lose)
		if reminder.tickerValue < table_VPTickerLastPlayed[localTeamId] then
			if localTeamTickers < reminder.tickerValue then
				if (reminder.loseWarning ~= nil) then
					WinWarning_ShowLoseWarning(reminder.loseWarning, 0.125, 2.25, 0.125)				
				end

				-- Mark as played
				table_VPTickerLastPlayed[localTeamId] = reminder.tickerValue
			end
		end
			
		-- check for enemy messages (notifications that we are winning)
		if reminder.tickerValue < table_VPTickerLastPlayed[enemyTeamId] then
			if enemyTeamTickers < reminder.tickerValue then
				if (reminder.enemyLoseWarning ~= nil) then
					WinWarning_ShowLoseWarning(reminder.enemyLoseWarning, 0.125, 2.25, 0.125)				
				end
				
				-- Mark as played
				table_VPTickerLastPlayed[enemyTeamId] = reminder.tickerValue
			end
		end
	end
end

function VPTicker_VictoryBalanceReminder()

	local localRaceSTRING = Player_GetRaceName(Game_GetLocalPlayer())
	local localTeamId = Player_GetTeam(Game_GetLocalPlayer())
	local localTeamPointsHeld = VPTicker_GetTeamVictoryPoints(localTeamId)
	local localTeamTicker = VPTicker_GetTeamTickers(localTeamId)
	
	-- find the team other than the local team with the most victory points
	local mostVP = localTeamPointsHeld
	local mostVPTeam = localTeamId
	local mostVPTeamTicker = localTeamTicker
	
	-- also find the sum of tickers for all teams
	local currentTickerSum = 0
	local startingTickerSum = 0
	
	-- loop
	for teamId,Data in pairs(VPTickerData.team_data) do
	
		--
		currentTickerSum  = currentTickerSum + Data.tickers
		startingTickerSum = startingTickerSum + VPTickerData.start_points
		
		--
		if teamId ~= localTeamId and Data.points_held >= mostVP then
			mostVP = Data.points_held
			mostVPTeam = teamId
			mostVPTeamTicker = Data.tickers
		end
	end
	
	-- will only play victory balance reminder if sum of current tickers is less than 75% of sum of original tickers
	-- victory balance will need to be updated anyway
	local shouldPlaySound = (currentTickerSum / startingTickerSum < 0.75)
	
	-- 1 is advantage, 0 is tie, -1 is disadvantage for the local player's team
	local currentVictoryBalance = 0
	-- give local team 100 pt handicap before playing less ticket speech
	local localHasMoreTicker = ((localTeamTicker + 100) >= mostVPTeamTicker)
	
	-- find out the new victory balance
	if (mostVPTeam ~= localTeamId) then
		if (localTeamPointsHeld < mostVP) then
			currentVictoryBalance = -1
		end
	else
		currentVictoryBalance = 1
	end
	
	local isOneTeamHoldingAllPoints = (mostVP == World_GetNumVictoryPoints())
	
	-- only need to play victory balance speech when different from previous victory balance
	if (isOneTeamHoldingAllPoints == true or VPTickerData.team_data[localTeamId].victory_balance ~= currentVictoryBalance) then

		-- update current victory balance for all teams
		for teamId,Data in pairs(VPTickerData.team_data) do
			if (teamId == localTeamId) then
				Data.victory_balance = currentVictoryBalance
			else
				-- negative victory balance for the enemy
				Data.victory_balance = -currentVictoryBalance
			end
		end
		
		-- early exit if not playing any sound at this moment
		if (shouldPlaySound == false) then
			return
		end
		
		-- play sound!
		local soundFile = nil
		
		if (IsAllies(localRaceSTRING)) then
			if (currentVictoryBalance == 1) 	then 
				if (localHasMoreTicker) then 				soundFile = table_VictoryBalanceStatusSpeech.Advantage_More_Ticket.allies
				else										soundFile = table_VictoryBalanceStatusSpeech.Advantage_Less_Ticket.allies
				end
			elseif 	(currentVictoryBalance == 0) 	then 	soundFile = table_VictoryBalanceStatusSpeech.Tie.allies
			elseif 	(currentVictoryBalance == -1) then 	
				if (isOneTeamHoldingAllPoints) then
															soundFile = table_VictoryBalanceStatusSpeech.Disadvantage_Enemy_Hold_All.allies
				elseif (localHasMoreTicker) then 			soundFile = table_VictoryBalanceStatusSpeech.Disadvantage_More_Ticket.allies
				else										soundFile = table_VictoryBalanceStatusSpeech.Disadvantage_Less_Ticket.allies
				end
			end
		elseif (IsAxis(localRaceSTRING)) then
			if (currentVictoryBalance == 1) 	then 	
				if (localHasMoreTicker) then 				soundFile = table_VictoryBalanceStatusSpeech.Advantage_More_Ticket.axis
				else										soundFile = table_VictoryBalanceStatusSpeech.Advantage_Less_Ticket.axis
				end
			elseif 	(currentVictoryBalance == 0) 	then 	soundFile = table_VictoryBalanceStatusSpeech.Tie.axis
			elseif 	(currentVictoryBalance == -1) then 	
				if (isOneTeamHoldingAllPoints) then
															soundFile = table_VictoryBalanceStatusSpeech.Disadvantage_Enemy_Hold_All.axis 
				elseif (localHasMoreTicker) then 			soundFile = table_VictoryBalanceStatusSpeech.Disadvantage_More_Ticket.axis
				else										soundFile = table_VictoryBalanceStatusSpeech.Disadvantage_Less_Ticket.axis
				end
			end			
		end	
		
		if (soundFile ~= nil) then
			Sound_PlayStreamed(soundFile)
		end
	end
end

function VPTicker_FinalTickerWarningReminder()
	local localTeamId = Player_GetTeam(Game_GetLocalPlayer())
	local localTeamPointsHeld = VPTicker_GetTeamVictoryPoints(localTeamId)
	local localTeamTicker = VPTicker_GetTeamTickers(localTeamId)

	local localTeamData = VPTickerData.team_data[ localTeamId ]
	
	local shouldPlayWarning = false
	
	-- play victory final warning if ticker is under the threshold
	if (localTeamData.tickers <= FINAL_TICKER_WARNING_TICKER_URGENT) then
		shouldPlayWarning = true	
	elseif (localTeamData.tickers <= FINAL_TICKER_WARNING_TICKER_LEISURE) then
		
		-- only play final warning speech when ticker is going down for the local player
		if (localTeamData.victory_balance < 0) then
			shouldPlayWarning = true	
		end
	end

	if (localTeamData.playingFinalWarning == nil) then
		if (shouldPlayWarning) then 
			-- play the warning sound
			localTeamData.playingFinalWarning = Sound_Play2D(SOUND_TICKER_WARNING_FINAL)
		end
	else
		if not(shouldPlayWarning) then 
			-- stop the warning sound
			Sound_Stop(localTeamData.playingFinalWarning)
			localTeamData.playingFinalWarning = nil
		 end
	end
end
