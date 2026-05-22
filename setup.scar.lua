------------------------------------------------------------------------------------
-- SetupUtil.scar
-- (c) 2003 Relic Entertainment Inc.
--
-- Description:
--		Contains helper functions for OnGameSetup function.  OnGameSetup
--	is used for initializing the player settings (name, race, team etc)
--
-- Usage:
--		Currently, the only function you need is Setup_Player( ).  This function
--	is used to set a players settings all in one function.  The function returns
--	you the playersId so you can store it in a global variable.
--
-- Example:
--	function OnGameSetup( )
--		g_player1 = Setup_Player(0, "PlayerDisplayName", "Allies", 1) 
--		g_player2 = Setup_Player(1, "$20000", "Axis", 2)
--		g_player3 = Setup_Player(2, "$20001", "Axis", 2)
--	end
--
--		In the above example, g_player2 and g_player3 will be on the same team.
--	The Setup_Player function takes care of setting all player relationships.
--


--? @group scardoc;Setup

--? @shortdesc Initializes the all of the players settings in one function and returns the playerID.
--? @extdesc 
--? In most cases you will call this function from OnGameSetup and store the returned playerId in  a global variable.  The player index should be in the range [1 , (numPlayers)].\n\n
--? Valid player races: "Allied Airborne Company", "Allied Assault Company", "Allied Rifle Company", "Allied Tank Company", "Axis Armored Company","Axis Heavy Tank Company", "Axis Infantry Company","Axis Pioneer Company"\n\n
--? Example:\n
--?	function OnGameSetup( )\n
--?	\tg_player1 = Setup_Player(0, "PlayerDisplayName", "Allied Assault Company", 1)\n
--? \t-- g_player2 and g_player3 will be on the same team (allies)\n
--? \tg_player2 = Setup_Player(1, "$20000", "Axis Infantry Company", 2)\n
--? \tg_player3 = Setup_Player(2, "$20001", "Axis Infantry Company", 2)\n
--? --? The team ID starts from one!!
--?	end
--? @args Integer playerIndex, LocString playerName, String playerRace, Integer team
--? @result PlayerID
function Setup_Player(playerIndex, playerName, playerRace, team)

	-- translate race name
	if (playerRace == "Allies Rifle Company") then
		playerRace = "allies"
	elseif (playerRace == "Axis Infantry Company") then
		playerRace = "axis"
	end

	if (scartype(team) ~= ST_NUMBER or team < 1 ) then
		fatal( "Setup_Player: team ID has to be a number starting from 1")
	end
	
	-- accept raw strings for now... convert them to LocString
	if (scartype(playerName) == ST_STRING) then
		playerName = LOC(playerName)
	end
	
	-- get player handle
	local playerId = World_GetPlayerAt( playerIndex )
	
	-- set player name and race
	Setup_SetPlayerName(playerId, playerName)
	Setup_SetPlayerRace(playerId, World_GetRaceBlueprint(playerRace))
	
	-- start the index from 0
	if ( team ~= TEAM_NEUTRAL ) then
		team = team-1
	end

	-- mod
	Setup_SetPlayerTeam(playerId, team)
	
	return playerId
end

--? @group scardoc;Util

--? @shortdesc Takes in a table and chooses the right variable for the difficulty setting. 1-4 elements. Acquires current difficulty by default.
--? @args Table difficultyVariables[, Integer difficulty]
--? @result Variable
function Util_DifVar(tablename, dif)

	if scartype(tablename) ~= ST_TABLE then
		fatal( "Util_DifVar: invalid table")
	end
	if dif == nil then
		dif = Game_GetSPDifficulty()
	end
	local count = table.getn(tablename)
	if count == 0 then
		fatal( "Util_DifVar: table.getn cannot equal zero")
	else
		if (dif+1) > count then
			return tablename[count]
		else
			return tablename[dif+1]
		end
	end
	
end

-- loops through a table of unit introduction speeches, and finds
-- out if the player has one selected then plays the appropriate speech
-- and removes it from the table.
function __UnitIntroductionSpeech()

	if table.getn(__g_preset_unit_intro) == 0 then
		Rule_RemoveMe()
		return
	end

	sg_unit_intro = SGroup_CreateIfNotFound("sg_unit_intro")
	
	if Event_IsAnyRunning() == false then
	
		Misc_GetSelectedSquads(sg_unit_intro, false)
		if not SGroup_IsEmpty(sg_unit_intro) then
	
			for k, v in pairs(__g_preset_unit_intro) do
				
				SGroup_Clear(sg_temp)
				SGroup_AddGroup(sg_temp, sg_unit_intro)
				SGroup_Filter(sg_temp, v.sbp, FILTER_KEEP)
				
				if not SGroup_IsEmpty(sg_temp) then
					
					Util_AutoAmbient(v.speech)
					table.remove(__g_preset_unit_intro, k)
					
				end
			
			end
		end
		
	end
	
end

function __MonitorPlayerResourceRates()
		
	local pop = Player_GetCurrentPopulation(Game_GetLocalPlayer(), CT_Personnel)
		
	for k,v in pairs(__t_res_preset.t_factors) do 
		if pop >= v.popLimit and pop <= v.popMax then
			
			-- slowly scale down the resources over time rather than immediately dropping the player's resources
			-- running a timer to drop the amount by 0.01 every 30 seconds until the ideal limit has been reached.
			if v.thisTier == true 
			and __t_res_preset.current_scale > v.scale
			and ( Timer_Exists( __t_res_preset.timer ) == false or Timer_GetRemaining( __t_res_preset.timer ) <= 0) then
				
				Modifier_Remove(__t_res_preset.res_rate_id)
				__t_res_preset.current_scale = __t_res_preset.current_scale - 0.01
				__t_res_preset.res_rate_id = Modify_PlayerResourceRate(Game_GetLocalPlayer(), RT_Manpower, __t_res_preset.current_scale)
--~ 				print("__MonitorPlayerResourceRates (Pop Cap: ("..pop.." Scale factor: "..__t_res_preset.current_scale..")")
				Timer_Start( __t_res_preset.timer, __t_res_preset.timer_amount )
				
			elseif v.thisTier ~= true then
				
				Modifier_Remove(__t_res_preset.res_rate_id)
				
				-- if the scale factor is going up then immediately jump the player to the correct factor
				-- so that they get the instant resource 
				if v.scale >= __t_res_preset.current_scale then
					
					__t_res_preset.current_scale = v.scale
--~ 					print("__MonitorPlayerResourceRates (Pop Cap: ("..pop.." Scale factor: "..__t_res_preset.current_scale..")")
					__t_res_preset.res_rate_id = Modify_PlayerResourceRate(Game_GetLocalPlayer(), RT_Manpower, v.scale)
					
				-- otherwise slowly reduce it over a period of time from the current scale factor, rather than 
				-- instantly jumping them to the next rate.
				else
					
					Modifier_Remove(__t_res_preset.res_rate_id)
					__t_res_preset.current_scale = __t_res_preset.current_scale - 0.01
					__t_res_preset.res_rate_id = Modify_PlayerResourceRate(Game_GetLocalPlayer(), RT_Manpower, __t_res_preset.current_scale)
--~ 					print("__MonitorPlayerResourceRates (Pop Cap: ("..pop.." Scale factor: "..__t_res_preset.current_scale..")")
					Timer_Start( __t_res_preset.timer, __t_res_preset.timer_amount )
					
				end
				
				v.thisTier = true
				
			end
			
		else
			v.thisTier = false
		end
		
	end


end

-- is called by the game. clears stuff in preparation for starting a counterattack mission.
function __SetupCounterattack()

	print("__SetupCounterattack")
	Rule_RemoveAll()
	Game_SkipEvent()
	
	Player_ClearAvailabilities(player1)
	Entity_ClearDemolitionCallbacks()
	
	StateMachine_RemoveAll()
	TankCombat_RemoveAll()
	HintPoint_RemoveAll()
	
	-- removing the command point capping rule
	if Rule_Exists(Rule_CapCommandPoints) then
		Rule_Remove(Rule_CapCommandPoints)
	end
	
	-- fixing additional problems with the resource rates command points
	if g_commandPoint_res_id ~= nil then
		Modifier_Remove(g_commandPoint_res_id)
		g_commandPoint_res_id = nil
	end
	
	g_commandPointLimit = nil
	g_commandPointMaxReached = false

	-- remove any modifiers that might have been applied to the player's resource rates
	if __t_res_preset and __t_res_preset.res_rate_id ~= nil then
		Modifier_Remove(__t_res_preset.res_rate_id)
	end
	
	-- removing the rule monitor player resources
	if Rule_Exists(__MonitorPlayerResourceRates) then
		Rule_Remove(__MonitorPlayerResourceRates)
	end
	
	if scartype(__t_preset_resource_id) == ST_TABLE then
		for i=1, table.getn(__t_preset_resource_id) do
			Modifier_Remove(__t_preset_resource_id[i])
		end
	end
	
	if Rule_Exists(__UnitIntroductionSpeech) then
		Rule_Remove(__UnitIntroductionSpeech)
	end
	
	FOW_Enable(true)
	
	Player_ResetResource(Game_GetLocalPlayer(), RT_Command)
	Player_ResetResource(Game_GetLocalPlayer(), RT_Action)
	
	-- restore control groups (saved in Game_EndSP)
	if t_control_groups then
		for i = 1, table.getn(t_control_groups) do
			local ctrl = t_control_groups[i]
			SGroup_CallSquadFunction(ctrl[1], Misc_SetSquadControlGroup, i - 1)
			EGroup_CallEntityFunction(ctrl[2], Misc_SetEntityControlGroup, i - 1)
		end
	end
	
end
