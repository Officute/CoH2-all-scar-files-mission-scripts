function Fatality_Execute(winningPlayers, losingPlayers)
	local playerPairs = {}
		
	if (World_IsReplay()) then
		return
	end

	-- Pair each winner and loser
	if(#winningPlayers >= #losingPlayers) then
		-- Pair the extra winners with the first loser, if winners outnumber losers
		for i,player in ipairs(winningPlayers) do
			table.insert(playerPairs, {winner = player, loser = losingPlayers[i] or losingPlayers[1]})
		end
	else
		-- Pair the extra losers with the first winner, if losers outnumber winners
		for i,player in ipairs(losingPlayers) do
			table.insert(playerPairs, {winner = winningPlayers[i] or winningPlayers[1], loser = player})
		end
	end
	
	-- Play the winner's fatality script for each pair of winners/losers
	for i,playerPair in ipairs(playerPairs) do
		Fatality_Play(playerPair.winner, playerPair.loser)
	end
end

function Fatality_Play(winner, loser)
	local ability = Player_GetFatalityAbility(winner)
	if (ability ~= nil) then
		-- Only reveal and pan if the winner has a fatality equipped
		local position = Player_GetStartingPosition(loser)
		FOW_RevealArea(position, 50, -1)

		local localPlayerID = Player_GetID(Game_GetLocalPlayer())
		if(Player_GetID(winner) == localPlayerID or Player_GetID(loser) == localPlayerID) then
			Camera_MoveTo(position, true, 0.2, false, true)
		end
		
		Player_AddAbility(winner, ability);
		Cmd_Ability(winner, ability, position, nil, true);
	end
end
