-----------------------------------------------------------------------
-- VPTicker Win Condition
--
-- (c) Relic Entertainment 2012
--
-----------------------------------------------------------------------
import("ScarUtil.scar")
import("Fatalities/Fatalities.scar")
import("Prototype/WorldEntityCollector.scar")
import("Prototype/SpecialAEFunctions.scar")

function WCNone_GameOver(winningTeam, losingTeam)
	--Callback for special win conditions. Should be declared within the win conditions .scar file (.../Scar/WinConditions/) or a scenario script
	if(scartype(WinConditionEndCallback) == ST_FUNCTION) then
		WinConditionEndCallback(winningTeam)
	else
		-- Set the winning team (this will fire win/loss events for each player)
		World_SetTeamWin(winningTeam)
	end
end

function WCNone_CheckSurrender()
	local results = {}
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		local team = Player_GetTeam(player)	
		
		results[team] = results[team] or { surrender_count = 0 }
		
		-- If any player on a team has surrendered, that team loses
		if(Player_IsSurrendered(player)) then
			results[team].surrender_count = results[team].surrender_count + 1
		end
	end
	
	-- Check if any team has surrendered
	for team,result in pairs(results) do
		if(result.surrender_count > 0) then
			Rule_RemoveAll()
			
			-- We have a winner!
			local losingTeam = team
			local winningTeam = Team_GetEnemyTeam(losingTeam)
			
			-- If this Scenario has a custom victory action/message (e.g. various ToW scenarios), call that
			if (VPVictoryMessage) and (scartype(VPVictoryMessage) == ST_FUNCTION) then
				-- Only fire the function if a human player's team has won
				if(Team_HasHuman(winningTeam)) then
					VPVictoryMessage()
					Event_Timer(WCNone_DelayedWin, {winningTeam = winningTeam, losingTeam = losingTeam}, 1)
				else
					Game_SetMode(UI_Normal)
					WCNone_GameOver(winningTeam, losingTeam)
				end
			else
				WCNone_GameOver(winningTeam, losingTeam)
			end
		end
	end
end

function WCNone_DelayedWin(data)
	if not Event_IsAnyRunning() then
		--Callback for special win conditions. Should be declared within the win conditions .scar file (.../Scar/WinConditions/) or a scenario script
		if(scartype(WinConditionEndCallback) == ST_FUNCTION) then
			WinConditionEndCallback(data.winningTeam)
		else
			Rule_RemoveAll()
			Game_SetMode(UI_Normal)
			Camera_SetInputEnabled(true)
			World_SetTeamWin(data.winningTeam)
		end
	else
		Event_Timer(WCNone_DelayedWin, data, 1)
	end
end

local function init()
	Rule_AddInterval(WCNone_CheckSurrender, 3)
end

Scar_AddInit(init)
