-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- KALACH (German Co-op Scenario)
-- Designer: Neil Jones-Rodway

-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScarUtil.scar")
import("TheatreOfWar.scar")
import("Systems/AiManager/ai.scar")

-- [[ IMPORT MISSION-SPECIFIC SCRIPTS ]]
import("1942_Kalach_OBJ_VictoryPoints.scar")
import("1942_Kalach_Encounters.scar")


-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------


function OnGameRestore()
	Game_DefaultGameRestore()
end


function OnInit()
	
	sg_temp   = SGroup_CreateIfNotFound("sg_temp")
	sg_blah   = SGroup_CreateIfNotFound("sg_blah")
	sg_single = SGroup_CreateIfNotFound("sg_single")
	eg_temp   = EGroup_CreateIfNotFound("eg_temp")
	eg_blah   = EGroup_CreateIfNotFound("eg_blah")
	eg_single = EGroup_CreateIfNotFound("eg_single")
	
	sg_basedefender_p3_atgun = SGroup_CreateIfNotFound("sg_basedefender_p3_atgun")
	sg_basedefender_p4_atgun = SGroup_CreateIfNotFound("sg_basedefender_p4_atgun")
	
	eg_ai_capture_overrides = EGroup_CreateIfNotFound("eg_ai_capture_overrides")		-- any point that has had a capture override applied is put in here so I can easily clear them again
	sg_bridgedefenders_east = SGroup_CreateIfNotFound("sg_bridgedefenders_east")
	sg_bridgedefenders_west = SGroup_CreateIfNotFound("sg_bridgedefenders_west")
	
	
	-- set the number of tickers the mission starts with
	vp_tickers = 1000
	vp_ticker_threshold = 150		-- change the flag configuration when one player has won this many tickers under the current set
	vp_time_threshold = 7			-- change the flag configuration when the current set has been in effect for this many minutes
	
	-- set the thresholds that will trigger the next round of points
	vp_team1_next_threshold = vp_tickers
	vp_team2_next_threshold = vp_tickers	
	time_of_last_round_change = World_GetGameTime()
	
	-- flags for triggering the correct speech for each round
	flag_ferry_points = false				-- these are set to true once the corresponding phase has been triggered (so we can tell if we're coming back to this phase a second time)
	flag_checkpoint_points = false
	flag_fuel_points = false
	flag_munitions_points = false
	flag_east_points = false
	flag_west_points = false
	flag_radio_points = false
	flag_river_points = false
	
	flag_repeated_points = false			-- set to true when we have triggered speech about going back to a set of points for a second time
	flag_first_order = true					-- set to true for the first round only (so we can ommit the bit about "new orders!")
	
	
	--[[ DEFINE PLAYERS ]]
	__Team_Init()
	player1, player2 = Team_DefineAllies()		-- Soviets
	player3, player4 = Team_DefineEnemies()		-- Germans
	
	--[[ PRESET DEBUG CONDITIONS ]]
	Mission_Debug()
	
	--[[ SET RESTRICTIONS ]]
	Mission_Restrictions()
	
	--[[ SET DIFFICULTY ]]
	Mission_Difficulty()
	
	--[[ MISSION PRESETS ]]
	Mission_Preset()
	
	--[[ GAME START CHECK ]]
	Rule_Add(Kalach_MissionStart)
	
end

Scar_AddInit(OnInit)



function Mission_Debug()

	-- looks for the command line option [-debug]
	if Misc_IsCommandLineOptionSet("debug") then
		g_debug = true
	end
	
end

function Mission_Restrictions()

	-- Utilize for setting restrictions on Units, teams, etc
	Team_SetTechTreeByYear(TEAM_ALLIES, 1942)
	Team_SetTechTreeByYear(TEAM_ENEMIES, 1942)
	
	-- Give the AI players some extra popcap to cover their base defenders
	Player_SetPopCapOverride(player3, Player_GetMaxPopulation(player3, CT_Personnel) + 20)
	Player_SetPopCapOverride(player4, Player_GetMaxPopulation(player4, CT_Personnel) + 20)
	
end

function Mission_Difficulty()
	
	g_difficulty = Game_GetSPDifficulty() 
	
	t_difficulty = {
		ai_advantage_adjustment		= Util_DifVar( {150, 0, -150} ),					-- add onto the AI's advantage (higher == less reinforcements)
	}

	if AI_IsAIPlayer(player3) then
		AI_SetPersonality(player3, "tow_kalach_enemy")
	end
	if AI_IsAIPlayer(player4) then
		AI_SetPersonality(player4, "tow_kalach_enemy")
	end
	
end

-------------------------------------------------------------------------
-- MISSION Preset 
-------------------------------------------------------------------------

function Mission_Preset()

	-- Kicks off after SCAR Inits, but before MissionStart is called.
	-- Use for spawning units on the map at the start
	
	
	-- data table for ALL of the VPs on the map - other data gets added to this (like objective UI element IDs, hintpoint IDs, etc)
	t_vp_data = {
		
		-- watchtowers
		{point = eg_vp_ferry1, hpid = nil},
		{point = eg_vp_ferry2},
		
		-- munitions points
		{point = eg_vp_munitions1},
		{point = eg_vp_munitions2},
		
		-- fuel points
		{point = eg_vp_fuel1},
		{point = eg_vp_fuel2},
		
		-- radio masts
		{point = eg_vp_radio1},
		{point = eg_vp_radio2},
		
		-- road checkpoints
		{point = eg_vp_checkpoint1},
		{point = eg_vp_checkpoint2},
		
		-- river vps
		{point = eg_vp_river1},
		{point = eg_vp_river2},
		
		-- west bank
		-- a combination of eg_vp_ferry1 and eg_vp_checkpoint1
		
		-- east bank
		-- a combination of eg_vp_ferry2 and eg_vp_checkpoint2
		
		-- bridge territory
		{point = eg_vp_bridge},
		
	}
	
	EGroup_Clear(eg_temp)
	for k, item in pairs(t_vp_data) do 
		EGroup_AddEGroup(eg_temp, item.point)
		local pos = Util_GetPosition(item.point)
		pos.y = pos.y - 3.2
		item.hpid = HintPoint_Add(pos, true, 11051993, nil, HPAT_None)
	end
	
	-- adjust initial settings for all VPs
	EGroup_EnableStrategicPoint(eg_temp, false)			-- can't capture them
	EGroup_SetAICaptureImportance(eg_temp, -100, ALL)	-- AI doesn't care about them
	EGroup_EnableMinimapIndicator(eg_temp, false)		-- hide from minimap
	
	t_watchtower_hold_modids = {
		{group = eg_vp_ferry1, modid = Modify_DisableHold(eg_vp_ferry1, true)},
		{group = eg_vp_ferry2, modid = Modify_DisableHold(eg_vp_ferry2, true)},
		{group = eg_vp_checkpoint1, modid = Modify_DisableHold(eg_vp_checkpoint1, true)},
		{group = eg_vp_checkpoint2, modid = Modify_DisableHold(eg_vp_checkpoint2, true)},
	}
	
	
	-- create pre-placed encounters
	Kalach_CreateAIBaseDefenders()
	Kalach_CreateInitialEncounters()
	
end

-------------------------------------------------------------------------
-- MISSION START 
-------------------------------------------------------------------------

function Kalach_MissionStart()

	Rule_RemoveMe()
	
	-- play mission intro speech
	Util_StartIntel(EVENTS.MissionStart)
	
	-- trigger the first VP in a bit...
	Event_Timer(Kalach_StartVPMode, nil, 30)
	
end



function Kalach_StartVPMode()

	VP_Start(vp_tickers)

	
	Objective_Start(OBJ_Description)
	
	time_of_last_round_change = World_GetGameTime()
	
	Kalach_SwitchVictoryPoints()
	Rule_AddInterval(Kalach_SwitchVictoryPoints, 1)
	
end


-- when the time comes, switch the points around
function Kalach_SwitchVictoryPoints()

	if VP_GetMinTickers() <= 150 then
		
		--
		-- we are at the magical 150 points, so it's time to shift to the finale!
		--
		
		-- clear the points from the previous round AND switch to the bridge
		Kalach_ClearVictoryPoints()
		Kalach_SwitchToBridge()
		
		-- as this is the last round, we can remove this rule as we won't switch again
		Rule_RemoveMe()
		
	elseif VP_GetMinTickers() > 180 and
		 ( VP_GetTeamTickers(1) <= vp_team1_next_threshold or 
		   VP_GetTeamTickers(2) <= vp_team2_next_threshold or 
	       World_GetGameTime() - time_of_last_round_change > (vp_time_threshold*60) ) then
		
		--
		-- either we've spent too long on the current round, or one of the players has lost 100 tickers, so it's time to switch to another round
		-- (we have a 180 ticker minimum, as if we're close to the magical 150 points we'll wait until we hit that instead)
		--
		
		-- clear the points from the previous round
		Kalach_ClearVictoryPoints()
		
		-- make a shortlist of all available types of rounds
		local rounds = nil
		if last_round == nil then
			
			rounds = {			-- restricted set of rounds for the first go (as we want things that are more in the center of the map)
				"ferry",
				"radio",
				"river",
			}
			
		else
			
			rounds = {			-- full set of round types (but we remove whatever the last round type was)
				"ferry",
				"fuel",
				"munitions",
				"radio",
				"checkpoints",
				"east",
				"west",
				"river",
			}
			for index, item in pairs(rounds) do
				if item == last_round then 
					table.remove(rounds, index)
				end
			end
			
		end
		
		-- and pick a random item from the shortlist
		local choice = Table_GetRandomItem(rounds)
		
		-- set the vps appropriately
		if choice == "ferry" then
			Kalach_SwitchToFerryPoints()
		elseif choice == "fuel" then
			Kalach_SwitchToFuelPoints()
		elseif choice == "munitions" then
			Kalach_SwitchToMunitionsPoints()
		elseif choice == "radio" then
			Kalach_SwitchToRadioPoints()
		elseif choice == "checkpoints" then
			Kalach_SwitchToCheckpoints()
		elseif choice == "east" then
			Kalach_SwitchToEastWatchtowers()
		elseif choice == "west" then
			Kalach_SwitchToWestWatchtowers()
		elseif choice == "river" then
			Kalach_SwitchToRiverPoints()
		end
		
		-- set the thresholds for the NEXT round
		vp_team1_next_threshold = VP_GetTeamTickers(1) - vp_ticker_threshold
		vp_team2_next_threshold = VP_GetTeamTickers(2) - vp_ticker_threshold
		time_of_last_round_change = World_GetGameTime()
		
		-- mark what we're doing so we don't repeat it
		last_round = choice
		
	end
	
end




--
-- individual functions to set up points for each type of round
--

function Kalach_SwitchToFerryPoints()

	-- add the points
	Kalach_AddVictoryPoint(eg_vp_ferry1)
	Kalach_AddVictoryPoint(eg_vp_ferry2)
	
	-- create encounters to go after these points
	Kalach_CreateEncounterToGrabPoint(eg_vp_ferry1)	
	Kalach_CreateEncounterToGrabPoint(eg_vp_ferry2)
	
	-- update UI
	Objective_UpdateText(OBJ_Description, 11051020, 0)		-- LOCDB [11051020] 'Capture the watchtowers overlooking the docks'
	
	-- trigger speech to kick off this round
	Kalach_PlayNewRoundSpeech(flag_ferry_points, "CaptureFerryPoints")
	flag_ferry_points = true
	
end


function Kalach_SwitchToRadioPoints()
	
	-- add the points
	Kalach_AddVictoryPoint(eg_vp_radio1)
	Kalach_AddVictoryPoint(eg_vp_radio2)
	
	-- create encounters to go after these points
	Kalach_CreateEncounterToGrabPoint(eg_vp_radio1)
	Kalach_CreateEncounterToGrabPoint(eg_vp_radio2)
	
	-- update UI
	Objective_UpdateText(OBJ_Description, 11051021, 0)		-- LOCDB [11051021] 'Capture the radio towers'
	
	-- trigger speech to kick off this round
	Kalach_PlayNewRoundSpeech(flag_radio_points, "CaptureRadioPoints")
	flag_radio_points = true
	
end

function Kalach_SwitchToFuelPoints()
	
	-- add the points
	Kalach_AddVictoryPoint(eg_vp_fuel1)
	Kalach_AddVictoryPoint(eg_vp_fuel2)
	
	-- create encounters to go after these points
	Kalach_CreateEncounterToGrabPoint(eg_vp_fuel1)
	Kalach_CreateEncounterToGrabPoint(eg_vp_fuel2)
	
	-- update UI
	Objective_UpdateText(OBJ_Description, 11051022, 0)		-- LOCDB [11051022] 'Capture the fuel points'
	
	-- trigger speech to kick off this round
	Kalach_PlayNewRoundSpeech(flag_fuel_points, "CaptureFuelPoints")
	flag_fuel_points = true
	
end

function Kalach_SwitchToMunitionsPoints()
	
	-- add the points
	Kalach_AddVictoryPoint(eg_vp_munitions1)
	Kalach_AddVictoryPoint(eg_vp_munitions2)
	
	-- create encounters to go after these points
	Kalach_CreateEncounterToGrabPoint(eg_vp_munitions1)
	Kalach_CreateEncounterToGrabPoint(eg_vp_munitions2)
	
	-- update UI
	Objective_UpdateText(OBJ_Description, 11051023, 0)		-- LOCDB [11051023] 'Capture the munitions points'
	
	-- trigger speech to kick off this round
	Kalach_PlayNewRoundSpeech(flag_munitions_points, "CaptureMunitionsPoints")
	flag_munitions_points = true
	
end

function Kalach_SwitchToCheckpoints()
	
	-- add the points
	Kalach_AddVictoryPoint(eg_vp_checkpoint1)
	Kalach_AddVictoryPoint(eg_vp_checkpoint2)
	
	-- create encounters to go after these points
	Kalach_CreateEncounterToGrabPoint(eg_vp_checkpoint1)
	Kalach_CreateEncounterToGrabPoint(eg_vp_checkpoint2)
	
	-- update UI
	Objective_UpdateText(OBJ_Description, 11051024, 0)		-- LOCDB [11051024] 'Capture the road checkpoints'
	
	-- trigger speech to kick off this round
	Kalach_PlayNewRoundSpeech(flag_checkpoint_points, "CaptureCheckpoints")
	flag_checkpoint_points = true
	
end

function Kalach_SwitchToWestWatchtowers()
	
	-- add the points
	Kalach_AddVictoryPoint(eg_vp_ferry1)
	Kalach_AddVictoryPoint(eg_vp_checkpoint1)
	
	-- create encounters to go after these points
	Kalach_CreateEncounterToGrabPoint(eg_vp_ferry1)
	Kalach_CreateEncounterToGrabPoint(eg_vp_checkpoint1)
	
	-- update UI
	Objective_UpdateText(OBJ_Description, 11051025, 0)		-- LOCDB [11051025] 'Capture the watchtowers on the west riverbank'
	
	-- trigger speech to kick off this round
	Kalach_PlayNewRoundSpeech(flag_west_points, "CaptureWestPoints")
	flag_west_points = true
	
end

function Kalach_SwitchToEastWatchtowers()
	
	-- add the points
	Kalach_AddVictoryPoint(eg_vp_ferry2)
	Kalach_AddVictoryPoint(eg_vp_checkpoint2)
	
	-- create encounters to go after these points
	Kalach_CreateEncounterToGrabPoint(eg_vp_ferry2)
	Kalach_CreateEncounterToGrabPoint(eg_vp_checkpoint2)
	
	-- update UI
	Objective_UpdateText(OBJ_Description, 11051026, 0)		-- LOCDB [11051026] 'Capture the watchtowers on the east riverbank'
	
	-- trigger speech to kick off this round
	Kalach_PlayNewRoundSpeech(flag_east_points, "CaptureEastPoints")
	flag_east_points = true
	
end

function Kalach_SwitchToRiverPoints()
	
	-- add the points
	Kalach_AddVictoryPoint(eg_vp_river1)
	Kalach_AddVictoryPoint(eg_vp_river2)
	
	-- create encounters to go after these points
	Kalach_CreateEncounterToGrabPoint(eg_vp_river1)
	Kalach_CreateEncounterToGrabPoint(eg_vp_river2)
	
	-- update UI
	Objective_UpdateText(OBJ_Description, 11051027, 0)		-- LOCDB [11051027] 'Capture the victory points on the river'
	
	-- trigger speech to kick off this round
	Kalach_PlayNewRoundSpeech(flag_river_points, "CaptureRiverPoints")
	flag_river_points = true
	
end

function Kalach_SwitchToBridge()		-- this is always the final wave, so it does a lot of special things

	-- open up the landscape
	World_IncreaseInteractionStage()
	EGroup_DestroyAllEntities(eg_bridge_blockers)
	
	-- add the points
	Kalach_AddVictoryPoint(eg_vp_bridge)
	
	-- reduce the priority of every other point
	EGroup_Clear(eg_temp)
	World_GetStrategyPoints(eg_temp, true)
	EGroup_RemoveGroup(eg_temp, eg_vp_bridge)
	EGroup_SetAICaptureImportance(eg_temp, -100, ALL)
	
	-- create the encounters
	Kalach_CreateBridgeDefences()
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_1942_kalach_02.aps", 90)
	
	-- update UI
	Objective_UpdateText(OBJ_Description, 11051028, 0)		-- LOCDB [11051028] 'Capture the bridge'
	
	-- trigger speech to kick off this round
	Util_StartIntel(EVENTS.CaptureBridge)
	
	Event_TeamOwnsTerritory(Kalach_PlayerCapturedBridge, nil, TEAM_ALLIES, eg_vp_bridge, ANY, 4)
	
end



-- create a retaliation once the player captures the bridge
function Kalach_PlayerCapturedBridge(data)
	
	Util_StartIntel(EVENTS.CaptureBridgeExpectRetaliation)
	
	Kalach_CreateMainBridgeRetaliation()
	
	Event_Timer(Kalach_TopUpBridgeRetaliation, nil, 60)

end

function Kalach_TopUpBridgeRetaliation(data)

	if Objective_IsComplete(OBJ_VictoryPoints) then
		return
	end
	
	if Team_OwnsEGroup(TEAM_ALLIES, eg_vp_bridge, ANY) then
		Kalach_CreateTopUpBridgeRetaliation()
		Event_Timer(Kalach_TopUpBridgeRetaliation, nil, 60)
	else
		Event_Timer(Kalach_TopUpBridgeRetaliation, nil, 10)
	end
	
end














-- picks the correct event to play for a round and plays it
function Kalach_PlayNewRoundSpeech(flag, event_name)

	if flag_first_order == true then							-- if this is the first round we're playing, play the _Initial version without "New orders!"
		Util_StartIntel( EVENTS[event_name.."_Initial"] )
		flag_first_order = false
	else
		if flag == true and flag_repeated_points == false then
			Util_StartIntel( EVENTS[event_name.."_Repeat"] )	-- first time we're told to grab points we covered earlier in the game, play the _Repeat version that mocks this
			flag_repeated_points = true
		else
			Util_StartIntel( EVENTS[event_name.."_Normal"] )	-- otherwise play the _Normal version
		end
	end

end




--
-- function to add a victory point to the current set of valid points - does everything mission-specific, and also takes care of adding it to the VP script
--
function Kalach_AddVictoryPoint(group, priority, message)

	-- set default values for missing params
	priority = priority or 1000
	message = message or true
	
	-- allow this point to be capturable again
	EGroup_EnableStrategicPoint(group, true)
	
	-- set AI capture overrides on the points (for all AI players)
	if VP_GetTeamTickers(1) < (VP_GetTeamTickers(2) - 250) then				-- if the enemy is more than 250 tickers ahead, make allies go directly for points
		EGroup_SetAICaptureImportance(group, 1500, TEAM_ALLIES)
		EGroup_SetAICaptureImportance(group, priority, TEAM_ENEMIES)
	elseif VP_GetTeamTickers(2) < (VP_GetTeamTickers(1) - 250) then			-- and vice versa
		EGroup_SetAICaptureImportance(group, priority, TEAM_ALLIES)
		EGroup_SetAICaptureImportance(group, 1500, TEAM_ENEMIES)
	else																	-- otherwise, set both players to normal capture priority
		EGroup_SetAICaptureImportance(group, priority, ALL)
	end
	
	-- add to group of things that have had capture overrides
	EGroup_AddEGroup(eg_ai_capture_overrides, group)

	
	-- adjust UI settings for this point
	EGroup_EnableMinimapIndicator(group, true)
	for k, item in pairs(t_vp_data) do 
		if EGroup_ContainsEGroup(item.point, group, ANY) then
			HintPoint_Remove(item.hpid)
			item.hpid = nil
		end
	end
	
	
	-- if this point is a watchtower, then make it garrisonable
	for k, item in pairs(t_watchtower_hold_modids) do 
		if item.group == group then
			Modifier_Remove(item.modid)
			item.modid = nil
		end
	end
	
	-- add to the VP ticker system
	VP_AddPoints(group, message)
	
end




--
-- function to clear all of the current victory points - does everything mission-specific, and also takes care of clearing VPs from the VP script
--
function Kalach_ClearVictoryPoints()

	-- reinstate any disable hold modifiers for watchtowers (and eject current occumpants, if any)
	for k, item in pairs(t_watchtower_hold_modids) do 
		if EGroup_ContainsEGroup(eg_ai_capture_overrides, item.group, ANY) then
			Cmd_EjectOccupants(item.group)
			item.modid = Modify_DisableHold(item.group, true)
		end
	end
	
	-- revert the points back to neutral and set them as uncapturable again
	EGroup_SetStrategicPointNeutral(eg_ai_capture_overrides)
	EGroup_EnableStrategicPoint(eg_ai_capture_overrides, false)
	
	-- adjust UI settings for this point
	EGroup_EnableMinimapIndicator(eg_ai_capture_overrides, false)
	for k, item in pairs(t_vp_data) do 
		if EGroup_ContainsEGroup(eg_ai_capture_overrides, item.point, ANY) then
			local pos = Util_GetPosition(item.point)
			pos.y = pos.y - 3.2
			item.hpid = HintPoint_Add(pos, true, 11051993, nil, HPAT_None)
		end
	end

	
	-- remove AI capture overrides on the points
	EGroup_SetAICaptureImportance(eg_ai_capture_overrides, -100, ALL)
	
	-- clear groups of things that have had capture overrides
	EGroup_Clear(eg_ai_capture_overrides)

	
	-- remove from the VP ticker system
	VP_RemoveAllPoints()
	
end




































--? @shortdesc Sets the capture importance for all territory points in the group for any given Skirmish AI players. Use a PlayerID for just a specific player, a Team table to apply to multiple players, or ALL to apply to every player.
--? @extdesc This takes care of checking if a player is running AI locally beforehand, so you can just pass in players and it only applies the override as appropriate.
--? @args EGroupID egroup, Int importance, PlayerID/TeamID/ALL player_or_team
function EGroup_SetAICaptureImportance(group, importance, player_or_team)
	
	local player_id = nil 
	
	-- internal iterator function for apply to a single entity / player combo
	local _ResetPoint = function(gid, idx, eid)	
		if AI_IsEnabled(player_id) then
			AI_SetCaptureImportanceBonus(player_id, eid, importance)
		end
	end

	if scartype(player_or_team) == ST_PLAYER then		-- do this for a single player
		
		player_id = player_or_team
		EGroup_ForEach(group, _ResetPoint)
		
	elseif player_or_team == ALL then					-- do this for EVERY player
		
		for index = 1, World_GetPlayerCount() do 
			player_id = World_GetPlayerAt(index)
			EGroup_ForEach(group, _ResetPoint)
		end
		
	else												-- do this for a team (a.k.a. a table of players)
		
		for index, player in pairs(player_or_team) do 
			player_id = player
			EGroup_ForEach(group, _ResetPoint)
		end
		
	end
	
end



--? @shortdesc Enable or disable capturing of a group of strategic points
--? @args EGroupID egroup, Boolean enable
function EGroup_EnableStrategicPoint(group, enable)

	local _Entity = function(gid, idx, eid)
		Entity_EnableStrategicPoint(eid, enable)
	end
	EGroup_ForEach(group, _Entity)
	
end







