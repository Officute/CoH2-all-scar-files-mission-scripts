print("\tLoading ObjCounterattack file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- OUREN
-- Objective File - COUNTERATTACK
-- Designer: NJR
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_ObjCounterattack()

	g_endGame = false

	print("Initializing ObjCounterattack...")
	
	-- Pre-condition:		TBD
	-- Success condition:	Counterattack is defeated
	-- Failure condition:	Counterattack clears all units from the peninsula
	-- Post-condition:
	--		Success:		No reaction - BOTH main objectives must be complete to win the mission
	--		Failure:		Mission fails
	OBJ_Counterattack = {
		--Info
		Title = 11076559,	-- LOCDB [11076559] 'Prepare for the Counterattack'
--~ 		TitleEnd = LOC("Counterattack repelled"),
--~ 		TitleFail = LOC("Counterattack "),
		Type = OT_Primary,
		Parent = nil,
		subObjectives = {},
		
		--Intel
		Intel_Start = 				nil,--EVENTS.Counterattack_Incoming_Start,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			EVENTS.MissionComplete,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				EVENTS.Counterattack_PlayerPushedOffPeninsula,
		Intel_Fail_SkipFunc = 		nil,
		
		--Functions
		SetupUI = function()
			
			-- changes the minimap to show the counterattack arrows
			World_IncreaseInteractionStage()
			
		end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = nil,		-- handled by Counterattack_EndCheck(), so both fail and complete tests are in the same place
		PreComplete = nil,
		OnComplete = function()
			
			-- Remove all current events and event callbacks, then call mission complete
			g_endGame = true
			Event_RemoveAll()
			if Rule_Exists(Bridges_FailCheck) == true then
				Rule_Remove(Bridges_FailCheck)			
			end			
			Rule_AddDelayedInterval(Mission_CompleteDelay, 1, 1)
			
			
			
		end,
		IsFailed = nil,			-- fail check handled by Counterattack_EndCheck(), a bit too intensive to be run every frame
		PreFail = nil,
		OnFail = function()
			
			-- Remove all current events and event callbacks, then call mission fail
			g_endGame = true
			Event_RemoveAll()
			if Rule_Exists(Bridges_FailCheck) == true then
				Rule_Remove(Bridges_FailCheck)			
			end
			Rule_AddDelayedInterval(Mission_FailDelay, 1, 1)			
			
		end,
	}
	
	
	--
	-- Initialization variables
	-- 
	counterattack_spawnlocation = nil
	
	counterattack_allies_have_joined = false
	counterattack_allspawned = false
	counterattack_stage = 1
	
	t_counterattack_countdown_announcements = {								-- a list of "time remaining" announcements, and when they should be played
		{threshold = 300, message = EVENTS.Counterattack_Incoming_5min},
		{threshold = 120, message = EVENTS.Counterattack_Incoming_2min},
		{threshold = 60,  message = EVENTS.Counterattack_Incoming_1min},
	}
	
	t_counterattack_potential_infantry_spawns = {							-- possible spawn locations for infantry-only spawns (i.e. routes through the trees)
		{spawn = mkr_east_spawn_hidden1, dest = mkr_east_dest_hidden1},
		{spawn = mkr_east_spawn_hidden2, dest = mkr_east_dest_hidden2},
		{spawn = mkr_east_spawn_hidden3, dest = mkr_east_dest_hidden3},
		{spawn = mkr_east_spawn_hidden4, dest = mkr_east_dest_hidden4},
		{spawn = mkr_east_spawn_hidden5, dest = mkr_east_dest_hidden5},
	}
	
	t_counterattack_potential_infantry_spawns_north = {							-- possible spawn locations for north bridge infantry spawns
		{spawn = mkr_east_spawn_hidden1, dest = mkr_east_dest_hidden1},		
	}
	
	t_counterattack_potential_vehicle_spawns = {							-- possible spawn locations for the vehicles (i.e. the roads into Ouren)
		{spawn = mkr_east_spawn1, dest = mkr_east_spawn1_dest},
		{spawn = mkr_east_spawn2, dest = mkr_east_spawn2_dest},
	}
	
	t_counterattack_potential_vehicle_spawns_north = {							-- possible spawn locations for the vehicles (i.e. the roads into Ouren)
		{spawn = mkr_east_spawn1, dest = mkr_east_spawn1_dest},		
	}

	
	t_counterattack_potential_heavyvehicle_spawns = {						-- possible spawn locations for the vehicles (i.e. the roads into Ouren)
		{spawn = mkr_east_spawn1, dest = mkr_east_spawn1_dest},
		{spawn = mkr_east_spawn2, dest = mkr_east_spawn2_dest},
		{spawn = mkr_east_spawn_hidden1, dest = mkr_east_dest_hidden1},
		{spawn = mkr_east_spawn_hidden2, dest = mkr_east_dest_hidden2},
		{spawn = mkr_east_spawn_hidden3, dest = mkr_east_dest_hidden3},
		{spawn = mkr_east_spawn_hidden4, dest = mkr_east_dest_hidden4},
		{spawn = mkr_east_spawn_hidden5, dest = mkr_east_dest_hidden5},
	}
	
	t_counterattack_potential_heavyvehicle_spawns_north = {						-- possible spawn locations for the vehicles (i.e. the roads into Ouren)
		{spawn = mkr_east_spawn1, dest = mkr_east_spawn1_dest},
	}
	
	
	--
	-- Stage 1 SBP lists
	--
	t_counterattack_stage1_potential_simple_infantry = {																				-- Stage 1 - SIMPLE INFANTRY
		-- EASY
		{
			sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() <= 2 end,
		},
		{
			sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() <= 2 end,
		},
		-- MEDIUM
		{
			sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, 
			conditions = function() return XP1_GetNodeStrength() >= 3 and XP1_GetNodeStrength() <= 4 end,
		},
		{
			sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() >= 3 and XP1_GetNodeStrength() <= 4 end,			
		},
		{
			sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() >= 3 and XP1_GetNodeStrength() <= 4 end,
		},
		
		{
			sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
			dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.0, exclusive = nil}},		
			conditions = function() return XP1_GetNodeStrength() >= 3 and XP1_GetNodeStrength() <= 4 and (g_difficulty == GD_HARD) end,
			max_amount = 2,
		},
		
		-- HARD
		{
			sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, 
			upgrades = {UPG.WEST_GERMAN.ASSAULT_PIONEER_COMBAT_UPGRADE},
			conditions = function() return XP1_GetNodeStrength() >= 5 end,
			max_amount = 3,
		},
		{
			sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, 
			conditions = function() return XP1_GetNodeStrength() >= 5 end,
		},
--~ 		
		{
			sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,		
			conditions = function() return XP1_GetNodeStrength() >= 5 end,
			
		},
		
		{
			sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
			dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},			
			conditions = function() return XP1_GetNodeStrength() >= 5 and (g_difficulty == GD_HARD) end,
			max_amount = 3,
		},
		
		{
			sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() >= 5 end,
		}
	}

	t_counterattack_stage1_potential_simple_vehicles = {																				-- Stage 1 - SIMPLE VEHICLES
		-- EASY
		{
			sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP,
			conditions = function() return XP1_GetNodeStrength() <= 2 end,
		},
		{
			sbp = SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() <= 2 end,
		},
	
		-- MEDIUM
		{
			sbp = SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() >= 3 and XP1_GetNodeStrength() <= 4 end,
		},
		{
			sbp = SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() >= 3 and XP1_GetNodeStrength() <= 4 end,
		},
		{
			sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP,
			conditions = function() return XP1_GetNodeStrength() >= 3 and XP1_GetNodeStrength() <= 4 end,
		},
	
		-- HARD
		{
			sbp = SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() >= 5 end,
		},
		{
			sbp = SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() >= 5 end,
		},
		{
			sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP,
			conditions = function() return XP1_GetNodeStrength() >= 5 end,
		},
	}
	
	
	--
	-- Stage 2 SBP lists
	--
	t_counterattack_stage2_potential_simple_infantry = {																				-- Stage 2 - SIMPLE INFANTRY
		-- EASY
		{
			sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() <= 2 end,
		},
	
		-- MEDIUM
		{
			sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, 
			conditions = function() return XP1_GetNodeStrength() >= 3 and XP1_GetNodeStrength() <= 4 end,
		},		
		
		{
			sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() >= 3 and XP1_GetNodeStrength() <= 4 end,
		},
		
		{
			sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
			dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},		
			conditions = function() return XP1_GetNodeStrength() >= 3 and XP1_GetNodeStrength() <= 4 and (g_difficulty == GD_HARD) end,
			max_amount = 4,
		},
		{
			sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() >= 3 and XP1_GetNodeStrength() <= 4 end,			
		},
	
		-- HARD
		{
			sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, 
			conditions = function() return XP1_GetNodeStrength() >= 5 end,
		},
		{
			sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, 
			conditions = function() return XP1_GetNodeStrength() >= 5 end,
		},		
		{
			sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,		
			conditions = function() return XP1_GetNodeStrength() >= 5 end,
			
		},		
		{
			sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			slotItems = {SLOT_ITEM.PANZERSHRECK},
			dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0.5, exclusive = nil}},				
			conditions = function() return XP1_GetNodeStrength() >= 5 and (g_difficulty == GD_HARD) end,
			max_amount = 2,
		},
		{
			sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
			conditions = function() return g_elite_infantry == true end,			
		},
	}
	
	t_counterattack_stage2_potential_specialist_infantry = {																				
		-- EASY
		{
			sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, 
			upgrades = {UPG.WEST_GERMAN.ASSAULT_PIONEER_COMBAT_UPGRADE},
			conditions = function() return XP1_GetNodeStrength() <= 2 end,
		},
		{
			sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() <= 2 end,
		},
		
		-- MEDIUM
		{
			sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() >= 3 and XP1_GetNodeStrength() <= 4 end,
		},
		{
			sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() >= 3 and XP1_GetNodeStrength() <= 4 end,
		},
		{
			sbp = SBP.WEST_GERMAN.LE_IG_18_INF_SUPPORT_GUN_SQUAD_MP,
			conditions = function() return g_mortars == true end,
			max_amount = 3,
		},

		-- HARD
		{
			sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, 
			upgrades = {UPG.WEST_GERMAN.ASSAULT_PIONEER_COMBAT_UPGRADE},
			conditions = function() return XP1_GetNodeStrength() >= 5 end,
		},
		{
			sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() >= 5 end,
		},
		{
			sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() >= 5 end,
		},
	}
	
	t_counterattack_stage2_potential_medium_vehicles = {																				
		-- EASY
		{
			sbp =  SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() <= 2 end,
		},
		{
			sbp =  SBP.GERMAN.SCOUTCAR_SDKFZ222_MP,
			conditions = function() return XP1_GetNodeStrength() <= 2 end,
		},
		{
			sbp =  SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() <= 2 end,
		},
	
		-- MEDIUM
		{
			sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() >= 3 and XP1_GetNodeStrength() <= 4 end,
			max_amount = 3,
		},
		{
			sbp =  SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() >= 3 and XP1_GetNodeStrength() <= 4 end,
		},	
		{
			sbp =  SBP.GERMAN.SCOUTCAR_SDKFZ222_MP,
			conditions = function() return XP1_GetNodeStrength() >= 3 and XP1_GetNodeStrength() <= 4 end,
		},
		{
			sbp =  SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() >= 3 and XP1_GetNodeStrength() <= 4 end,
		},
	
	
		-- HARD
		{
			sbp =  SBP.GERMAN.SCOUTCAR_SDKFZ222_MP,
			conditions = function() return g_tanks == true end,
		},
		{
			sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
			conditions = function() return g_tanks == true end,
			max_amount = 3,
		},
		{
			sbp = SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP,
			conditions = function() return g_tanks == true end,
		},
	}
	
	t_counterattack_stage2_potential_heavy_vehicles = {																				
		-- EASY
		{
			sbp = SBP.GERMAN.TIGER_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() <= 2 end,
			max_amount = 1,
		},
		{
			sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() <= 2 end,
		},
		{
			sbp = SBP.GERMAN.STUG_III_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() <= 2 end,
			max_amount = 4,
		},
	
		-- MEDIUM
		{
			sbp = SBP.WEST_GERMAN.JAGDPANZER_TANK_DESTROYER_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() >= 3 and XP1_GetNodeStrength() <= 4 end,
			max_amount = 1,
		},
		{
			sbp = SBP.GERMAN.STUG_III_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() >= 3 and XP1_GetNodeStrength() <= 4 end,
		},
		{
			sbp = SBP.GERMAN.TIGER_SQUAD_MP,
			conditions = function() return XP1_GetNodeStrength() >= 3 and XP1_GetNodeStrength() <= 4 end,
			max_amount = 1,
		},

		-- HARD
		{
			sbp = SBP.GERMAN.BRUMMBAR_SQUAD_MP,
			conditions = function() return g_tanks == true end,
			max_amount = 1,
		},
		{
			sbp = SBP.GERMAN.TIGER_SQUAD_MP, 
			upgrades = {UPG.GERMAN.TIGER_TOP_GUNNER_MP},
			conditions = function() return g_tanks == true end,
			max_amount = 1,
		},
		{
			sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
			upgrades = {UPG.GERMAN.PANZER_TOP_GUNNER_MP},
			conditions = function() return g_tanks == true end,
		},		
		{
			sbp = SBP.GERMAN.STUG_III_SQUAD_MP,
			conditions = function() return g_tanks == true end,
		},
	}
	
	
	
	
	Rule_AddInterval(Counterattack_StartCountdown, 1)
	
end
Scar_AddInit(INIT_ObjCounterattack)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------

--
-- this starts the countdown to the counterattack, which can happen when either: 
--     [a] the player progresses far enough into the map and hits a trigger zone 
--  or [b] enough time has elapsed since the start of the mission (exact time changes with difficulty)
-- 
function Counterattack_StartCountdown()
	
	if World_GetGameTime() >= t_difficulty.CountdownStartTime 
	or Prox_ArePlayersNearMarker(player1, mkr_counterattack_north_encounterarea, ANY) then
		
		if Event_IsAnyRunning() == false then
			Rule_RemoveMe()
			
			counterattack_countdowntimer = t_difficulty.CountdownLength
			Objective_Start(OBJ_Counterattack)
			Util_StartIntel(EVENTS.Counterattack_Incoming_Start) -- had to be added here for some reason, as it didn't start by adding it to Intel_Start in OBJ_Counterattack
			Event_NarrativeEventsNotRunning(Counterattack_StartCountdown_PartB, nil, 1)
		end
	end
	
end
function Counterattack_StartCountdown_PartB()
	
	Obj_ShowProgress(11076560, 1)	-- LOCDB [11076560] 'Estimated time until arrival'
	
	Rule_AddInterval(Counterattack_Countdown, 1)
	
end



--
-- this manages the actual countdown; it reduces the countdown by an amount depending on player progress, updates the objective UI, and triggers all the countdown time announcement messages when necessary
--
function Counterattack_Countdown()
	
	-- figure out how much to reduce the timer by
	-- "normal" amount to reduce countdown by is 1;	reduce by LESS than 1 to go easy on the player (give them more time) or reduce by MORE than 1 to make things harder (start the counterattack sooner)
	local enemy_count = Player_GetSquadCount(player2)	-- figure out the ratio of player units to enemy units
	local player_count = Player_GetSquadCount(player1)
	if counterattack_allies_have_joined == true then
		player_count = player_count + Player_GetSquadCount(player3)
	end
	local ratio = player_count / math.max(enemy_count, 1)
	
	ratio = math.min(ratio, 2)	-- clamp the ratio between 0 and 2, then scale so it's between 0.5 and 1.5
	ratio = math.max(ratio, 0)
	ratio = (ratio + 1) / 2
	
	-- reduce the timer and update the ui
	counterattack_countdowntimer = counterattack_countdowntimer - ratio
	Obj_ShowProgress(11076560, (counterattack_countdowntimer / t_difficulty.CountdownLength) )	-- LOCDB [11076560] 'Estimated time until arrival'
	
	-- if we've hit the next message threshold, play the message and move on to the next
	if #t_counterattack_countdown_announcements >= 1 and counterattack_countdowntimer <= t_counterattack_countdown_announcements[1].threshold then
		Util_StartIntel(t_counterattack_countdown_announcements[1].message)
		table.remove(t_counterattack_countdown_announcements, 1)
	end
	
	-- if we've hit 0, stop the countdown and begin the counterattack
	if counterattack_countdowntimer <= 0 then
		
		-- call out the fact the timer is up
		Util_StartIntel(EVENTS.Counterattack_Incoming_TimerUp)
		Obj_HideProgress()
		
		-- update the objective text
		Objective_UpdateText(OBJ_Counterattack, 11076561, 0)	-- LOCDB [11076561] 'Hold out against the Counterattack'
		
		-- and actually begin the counterattack!
		Rule_AddOneShot(Counterattack_Stage1_Begin, 3)
		Rule_AddDelayedInterval(Counterattack_Stage1_ProgressToStage2, 10, 5)
		Rule_AddDelayedInterval(Counterattack_EndCheck, 10, 2)
		
		Rule_RemoveMe()
		
	end
	
end



--
-- move the counterattack to Stage 2, where the enemy spreads across all three zones and steps up the spawns
--
function Counterattack_Stage1_ProgressToStage2()
	
	if counterattack_units_still_to_spawn <= t_difficulty.CounterattackSize * 0.66 then
		
		Rule_RemoveMe()
		
		-- also remove the rules that inject new units
		Rule_RemoveIfExist(Counterattack_Stage1_AddSimpleInfantryUnit)
		Rule_RemoveIfExist(Counterattack_Stage1_AddSimpleVehicleUnit)
		
		-- go to phase 2 (where the injection rules will start up again) after a pre-determined lull
		Rule_AddOneShot(Counterattack_Stage2_Begin, t_difficulty.CounterattackLullTime)
		Rule_AddDelayedInterval(Counterattack_Stage2_AttackNorthBridge, t_difficulty.CounterattackLullTime + 10, 20)
		Rule_AddDelayedInterval(Counterattack_Stage2_AttackSouthBridge, t_difficulty.CounterattackLullTime + 20, 20)
		
	end
	
end



--
-- when the north or south encounters have defeated all the player/allied units in their area, they should start attacking the respective bridge
--
function Counterattack_Stage2_AttackNorthBridge()

	if EGroup_Count(eg_bridge_north) >= 1 and Prox_AreTeamsNearMarker(Player_GetTeam(player1), mkr_counterattack_north_encounterarea, ANY) == false and (g_endGame == false) then
		
		GOALS.Counterattack_Stage2_AttackBridge_North(enc_CounterattackStage2North)						-- give new goal
		EGroup_SetPlayerOwner(eg_bridge_north, player1)
		
		Event_Timer(EventHandler_StartIntel, {intel = EVENTS.Counterattack_TargetNorthBridge}, 7)		-- call out that the counterattack is now targetting the bridge
		
		Rule_RemoveMe()
		
	end
	
end

function Counterattack_Stage2_AttackSouthBridge()

	if EGroup_Count(eg_bridge_south) >= 1 and Prox_AreTeamsNearMarker(Player_GetTeam(player1), mkr_counterattack_south_encounterarea, ANY) == false and (g_endGame == false) then
		
		GOALS.Counterattack_Stage2_AttackBridge_South(enc_CounterattackStage2South)						-- give new goal
		EGroup_SetPlayerOwner(eg_bridge_south, player1)
		
		Event_Timer(EventHandler_StartIntel, {intel = EVENTS.Counterattack_TargetSouthBridge}, 7)		-- call out that the counterattack is now targetting the bridge
		
		Rule_RemoveMe()
		
	end

end


--
-- this checks for the objective's win and lose conditions
-- (not done in the objective IsComplete/IsFailed functions as they're a bit too intensive to be run every frame)
--
function Counterattack_EndCheck()
	
	if Event_IsAnyRunning() == false then
		
		if counterattack_allspawned == true and SGroup_CountSpawned(sg_counterattack_all) <= 6 then
			
			-- retreat all the units!
			Cmd_Retreat(sg_counterattack_all, mkr_east_spawn2, mkr_east_spawn2)		-- run away!
			Cmd_Move(sg_counterattack_all, mkr_east_spawn2, nil, mkr_east_spawn2)	-- move if you don't respond to retreating. That's you, tanks.
			
			-- gloat about it
			Util_StartIntel(EVENTS.Counterattack_UnitsFlee)
			
			-- set the objective to complete
			Event_Timer(EventHandler_ObjectiveComplete, {objective = OBJ_Counterattack}, 5)
			
			Rule_RemoveMe()
			
		else
			
			-- get all the player 1 and 3 units
			SGroup_Clear(sg_temp)
			
			Player_GetAll(player1)
			SGroup_AddGroup(sg_temp, sg_allsquads)
			Player_GetAll(player3)
			SGroup_AddGroup(sg_temp, sg_allsquads)
			
			-- check an individual unit to see if it's on the peninsula
			local _CheckSquadIsOnPeninsula = function(gid, idx, sid)
				
				local pos = Squad_GetPosition(sid)
				
				if Marker_InProximity(mkr_counterattack_north_encounterarea, pos) or 			-- TODO: this check may need to be updated as the zones shift about a bit
				   Marker_InProximity(mkr_counterattack_mid_encounterarea, pos) or 
				   Marker_InProximity(mkr_counterattack_south_encounterarea, pos) then
					
					return true
					
				end
				
			end
			
			-- we fail the objective if there is not even a single unit on the peninsula
			if SGroup_ForEachAllOrAny(sg_temp, ANY, _CheckSquadIsOnPeninsula) == false then
				
				Objective_Fail(OBJ_Counterattack)
				Rule_RemoveMe()
				
			end
			
		end
		
	end
	
end



function Counterattack_Stop()
	
	-- stop spawning any more counterattack units
	counterattack_units_still_to_spawn = 0

end




---------------------------------------------------------------------------------
--                                                                             --
--  Functions to add units of various types into PHASE 1 of the Counterattack  --
--                                                                             --
---------------------------------------------------------------------------------

function Counterattack_Stage1_Begin()

	if counterattack_units_still_to_spawn == nil then
		
		-- create the encounter that we put units into
		-- guards the middle area of the peninsula, next to the map entry points for the counterattack
		enc_CounterattackStage1 = ENCOUNTERS.Counterattack_Stage1()
		
		-- we spawned three units as part of the encounter, so take that off the total
		counterattack_units_still_to_spawn = t_difficulty.CounterattackSize - 3
		
		-- set up the timers for pumping in units in the initial phase
		Rule_AddInterval(Counterattack_Stage1_AddSimpleInfantryUnit, 13)
		Rule_AddInterval(Counterattack_Stage1_AddSimpleVehicleUnit, 60)
		
	end
	
end



function Counterattack_Stage1_AddSimpleInfantryUnit()
	if counterattack_units_still_to_spawn <= 0 then
		Rule_RemoveMe()
	else
		if SGroup_Count(sg_counterattack_simpleinfantry) < t_difficulty.MaxSimpleInfantry and Rule_Exists(Counterattack_Stage1_AddSimpleInfantryUnit_PartB) == false then
			Rule_AddOneShot(Counterattack_Stage1_AddSimpleInfantryUnit_PartB, World_GetRand(10, 50) / 10)
			Rule_ChangeInterval(Counterattack_Stage1_AddSimpleInfantryUnit, (13 * t_difficulty.CounterattackSpawnScaler))
		else
			Rule_ChangeInterval(Counterattack_Stage1_AddSimpleInfantryUnit, 5)
		end
	end
end
function Counterattack_Stage1_AddSimpleInfantryUnit_PartB()	

	if counterattack_units_still_to_spawn >= 1 then
		
		SGroup_Clear(sg_temp)
		
		-- choose location and intended destination encounter
		local spawnloc = Table_GetRandomItem(t_counterattack_potential_infantry_spawns)
		local encounter = Counterattack_PickSuitableEncounter()
		
		-- choose and spawn a unit
		local choice1 = UnitTable_GetRandomItem(t_counterattack_stage1_potential_simple_infantry)
		local unit1 = {sbp = choice1.sbp, spawn = spawnloc.spawn, moveTo = spawnloc.dest, attackMoveTo = false, sgroups = {sg_temp, sg_counterattack_all, sg_counterattack_simpleinfantry}, upgrades = choice1.upgrades, slotItems = choice1.slotItems, dropItems = choice1.dropItems }
		encounter:AddUnit(unit1)
		
		-- add node strength veterancy to spawned units
		SGroup_ForEach(sg_temp, NodeStrengthVeterancy)
		
		-- restart goal if necessary
		if encounter:HasGoal() == false then
			encounter:RestartGoal()
		end
		
		-- account for this in the counterattack's  unit count
		counterattack_units_still_to_spawn = counterattack_units_still_to_spawn - 1
		if counterattack_units_still_to_spawn <= 0 then
			counterattack_allspawned = true
		end
		
	end
	
end



function Counterattack_Stage1_AddSimpleVehicleUnit()
	if counterattack_units_still_to_spawn <= 0 then
		Rule_RemoveMe()
	else
		if SGroup_Count(sg_counterattack_simplevehicles) < t_difficulty.MaxSimpleVehicles and Rule_Exists(Counterattack_Stage1_AddSimpleVehicleUnit_PartB) == false then
			Rule_AddOneShot(Counterattack_Stage1_AddSimpleVehicleUnit_PartB, World_GetRand(10, 50) / 10)
			Rule_ChangeInterval(Counterattack_Stage1_AddSimpleVehicleUnit, (60 * t_difficulty.CounterattackSpawnScaler))
		else
			Rule_ChangeInterval(Counterattack_Stage1_AddSimpleVehicleUnit, 15)
		end
	end
end
function Counterattack_Stage1_AddSimpleVehicleUnit_PartB()

	if counterattack_units_still_to_spawn >= 1 then
		
		SGroup_Clear(sg_temp)
		
		-- choose location and intended destination encounter
		local spawnloc = Table_GetRandomItem(t_counterattack_potential_vehicle_spawns)
		local encounter = Counterattack_PickSuitableEncounter()
		
		-- choose and spawn units
		local choice1 = UnitTable_GetRandomItem(t_counterattack_stage1_potential_simple_vehicles)			-- simple vehicle
		local unit1	= {sbp = choice1.sbp, spawn = spawnloc.spawn, moveTo = spawnloc.dest, attackMoveTo = false, sgroups = {sg_temp, sg_counterattack_all, sg_counterattack_simplevehicles}, upgrades = choice1.upgrades}
		encounter:AddUnit(unit1)
		
		local choice2 = UnitTable_GetRandomItem(t_counterattack_stage1_potential_simple_infantry)			-- accompanying infantry squad
		local unit2 = {sbp = choice2.sbp, spawn = spawnloc.spawn, moveTo = spawnloc.dest, attackMoveTo = false, sgroups = {sg_temp, sg_counterattack_all, sg_counterattack_simpleinfantry}, upgrades = choice2.upgrades}
		encounter:AddUnit(unit2)
		
		-- add node strength veterancy to spawned units
		SGroup_ForEach(sg_temp, NodeStrengthVeterancy)
		
		-- restart goal if necessary
		if encounter:HasGoal() == false then
			encounter:RestartGoal()
		end
		
		-- account for this in the counterattack's  unit count
		counterattack_units_still_to_spawn = counterattack_units_still_to_spawn - 1
		if counterattack_units_still_to_spawn <= 0 then
			counterattack_allspawned = true
		end
		
	end
	
end






---------------------------------------------------------------------------------
--                                                                             --
--  Functions to add units of various types into PHASE 2 of the Counterattack  --
--                                                                             --
---------------------------------------------------------------------------------

function Counterattack_Stage2_Begin()
	
	-- trigger some speech 
	Util_StartIntel(EVENTS.Counterattack_Stage2_Begin)
	
	-- stop the old encounter
	enc_CounterattackStage1:ClearGoal()
	enc_CounterattackStage1:Disable()
	
	
	-- split off 30% of that encounter's units that are closest to the north area and create a new encounter for them
	SGroup_Clear(sg_temp)
	local totalunitcount = SGroup_CountSpawned(sg_counterattack_stage1_encounter)
	for n = 1, math.floor(totalunitcount * 0.3) do 
		
		local closest_distance = 99999
		local closest_squad = nil 
		
		local _CheckSquad = function(gid, idx, sid)
			local this_distance = Util_GetDistance(mkr_counterattack_north_encounterarea, sid)
			if this_distance < closest_distance then
				closest_distance = this_distance
				closest_squad = sid
			end
		end
		SGroup_ForEach(sg_counterattack_stage1_encounter, _CheckSquad)
		
		SGroup_Add(sg_temp, closest_squad)
		SGroup_Remove(sg_counterattack_stage1_encounter, closest_squad)
		
	end
	
	enc_CounterattackStage2North = ENCOUNTERS.Counterattack_Stage2_North()
	enc_CounterattackStage2North:AddSgroup(sg_temp)

	
	-- split off another 25% closest to the south area and create a new encounter for them
	SGroup_Clear(sg_temp)

	for n = 1, math.floor(totalunitcount * 0.25) do 
		
		local closest_distance = 99999
		local closest_squad = nil 
		
		local _CheckSquad = function(gid, idx, sid)
			local this_distance = Util_GetDistance(mkr_counterattack_south_encounterarea, sid)
			if this_distance < closest_distance then
				closest_distance = this_distance
				closest_squad = sid
			end
		end
		SGroup_ForEach(sg_counterattack_stage1_encounter, _CheckSquad)
		
		SGroup_Add(sg_temp, closest_squad)
		SGroup_Remove(sg_counterattack_stage1_encounter, closest_squad)
		
	end
	
	enc_CounterattackStage2South = ENCOUNTERS.Counterattack_Stage2_South()
	enc_CounterattackStage2South:AddSgroup(sg_temp)

	
	-- assign the rest back to the middle
	enc_CounterattackStage2Middle = ENCOUNTERS.Counterattack_Stage2_Middle()
	enc_CounterattackStage2Middle:AddSgroup(sg_counterattack_stage1_encounter)
	
	
	-- if the allies are already in the fight, cancel their north encounter and split them between north and middle
	if counterattack_allies_have_joined == true then
		
		enc_AlliedCounterattackStage1:ClearGoal()
		enc_AlliedCounterattackStage1:Disable()
		
		Player_GetAll(player3)
		
		-- split the group of P3 units in half
		SGroup_Clear(sg_temp)
		for n = 1, math.floor((SGroup_CountSpawned(sg_allsquads) / 2)) do 
			local sid = SGroup_GetRandomSpawnedSquad(sg_allsquads)
			SGroup_Remove(sg_allsquads, sid)
			SGroup_Add(sg_temp, sid)
		end
		
		-- set the first half a new encounter attacking the north area
		enc_AlliedCounterattackStage2North = ENCOUNTERS.Allies_Counterattack_Stage2_North()
		enc_AlliedCounterattackStage2North:AddSgroup(sg_allsquads)
		
		-- set the second half a new encounter attacking the middle area
		enc_AlliedCounterattackStage2Middle = ENCOUNTERS.Allies_Counterattack_Stage2_Middle()
		enc_AlliedCounterattackStage2Middle:AddSgroup(sg_temp)
		
	end
	
	-- set counterattack stage to 2
	counterattack_stage = 2
	
	-- set up the timers for pumping in units in the initial phase
	Rule_AddInterval(Counterattack_Stage2_AddSimpleInfantryUnit, 10)
	Rule_AddInterval(Counterattack_Stage2_AddSpecialistInfantryUnit, 11)
	Rule_AddInterval(Counterattack_Stage2_AddMediumVehicleUnit, 12)
	Rule_AddInterval(Counterattack_Stage2_AddHeavyVehicleUnit, 13)
	
end



function Counterattack_Stage2_AddSimpleInfantryUnit()
	if counterattack_units_still_to_spawn <= 0 then
		Rule_RemoveMe()
	else
		if SGroup_Count(sg_counterattack_simpleinfantry) < t_difficulty.MaxSimpleInfantry and Rule_Exists(Counterattack_Stage2_AddSimpleInfantryUnit_PartB) == false then
			Rule_AddOneShot(Counterattack_Stage2_AddSimpleInfantryUnit_PartB, World_GetRand(10, 50) / 10)
			Rule_ChangeInterval(Counterattack_Stage2_AddSimpleInfantryUnit, (60 * t_difficulty.CounterattackSpawnScaler))
		else
			Rule_ChangeInterval(Counterattack_Stage2_AddSimpleInfantryUnit, 15)
		end
	end
end
function Counterattack_Stage2_AddSimpleInfantryUnit_PartB()

	if counterattack_units_still_to_spawn >= 1 then
		
		SGroup_Clear(sg_temp)
		
		-- choose location and intended destination encounter
		local spawnloc = Table_GetRandomItem(t_counterattack_potential_infantry_spawns)
		local encounter = Counterattack_PickSuitableEncounter()
		
		-- by design for now, middle and south share the default spawn while north is only applicable to paths along the northernmost route to minimize interference of their transit to their intended destination
		if counterattack_spawnLocation == "north" then
			spawnloc = Table_GetRandomItem(t_counterattack_potential_infantry_spawns_north) -- north
		elseif counterattack_spawnLocation == "middle" then
			spawnloc = Table_GetRandomItem(t_counterattack_potential_infantry_spawns) -- middle
		elseif counterattack_spawnLocation == "south" then
			spawnloc = Table_GetRandomItem(t_counterattack_potential_infantry_spawns) -- south
		end
		
		
		
		-- choose and spawn a unit
		local choice1 = UnitTable_GetRandomItem(t_counterattack_stage2_potential_simple_infantry)
		local unit1 = {sbp = choice1.sbp, spawn = spawnloc.spawn, moveTo = spawnloc.dest, attackMoveTo = false, sgroups = {sg_temp, sg_counterattack_all, sg_counterattack_simpleinfantry}, upgrades = choice1.upgrades, slotItems = choice1.slotItems, dropItems = choice1.dropItems }
		encounter:AddUnit(unit1)
		
		-- add node strength veterancy to spawned units
		SGroup_ForEach(sg_temp, NodeStrengthVeterancy)
		
		-- restart goal if necessary
		if encounter:HasGoal() == false then
			encounter:RestartGoal()
		end
		
		-- account for this in the counterattack's  unit count
		counterattack_units_still_to_spawn = counterattack_units_still_to_spawn - 1
		if counterattack_units_still_to_spawn <= 0 then
			counterattack_allspawned = true
		end
		
	end
	
end



function Counterattack_Stage2_AddSpecialistInfantryUnit()
	if counterattack_units_still_to_spawn <= 0 then
		Rule_RemoveMe()
	else
		if SGroup_Count(sg_counterattack_specialistinfantry) < t_difficulty.MaxSpecialistInfantry and Rule_Exists(Counterattack_Stage2_AddSpecialistInfantryUnit_PartB) == false then
			Rule_AddOneShot(Counterattack_Stage2_AddSpecialistInfantryUnit_PartB, World_GetRand(10, 50) / 10)
			Rule_ChangeInterval(Counterattack_Stage2_AddSpecialistInfantryUnit, (120 * t_difficulty.CounterattackSpawnScaler))
		else
			Rule_ChangeInterval(Counterattack_Stage2_AddSpecialistInfantryUnit, 15)
		end
	end
end
function Counterattack_Stage2_AddSpecialistInfantryUnit_PartB()

	if counterattack_units_still_to_spawn >= 1 then
		
		SGroup_Clear(sg_temp)
		
		-- choose location and intended destination encounter
		local spawnloc = Table_GetRandomItem(t_counterattack_potential_infantry_spawns)
		local encounter = Counterattack_PickSuitableEncounter()
		
		-- by design for now, middle and south share the default spawn while north is only applicable to paths along the northernmost route to minimize interference of their transit to their intended destination
		if counterattack_spawnLocation == "north" then
			spawnloc = Table_GetRandomItem(t_counterattack_potential_infantry_spawns_north) -- north
		elseif counterattack_spawnLocation == "middle" then
			spawnloc = Table_GetRandomItem(t_counterattack_potential_infantry_spawns) -- middle
		elseif counterattack_spawnLocation == "south" then
			spawnloc = Table_GetRandomItem(t_counterattack_potential_infantry_spawns) -- south
		end
		
		-- choose and spawn units
		local choice1 = UnitTable_GetRandomItem(t_counterattack_stage2_potential_specialist_infantry)		-- specialist infantry
		local unit1	= {sbp = choice1.sbp, spawn = spawnloc.spawn, moveTo = spawnloc.dest, attackMoveTo = false, sgroups = {sg_temp, sg_counterattack_all, sg_counterattack_specialistinfantry}, upgrades = choice1.upgrades, slotItems = choice1.slotItems, dropItems = choice1.dropItems }
		encounter:AddUnit(unit1)
		
		local choice2 = UnitTable_GetRandomItem(t_counterattack_stage2_potential_simple_infantry)			-- accompanying infantry squad
		local unit2 = {sbp = choice2.sbp, spawn = spawnloc.spawn, moveTo = spawnloc.dest, attackMoveTo = false, sgroups = {sg_temp, sg_counterattack_all, sg_counterattack_simpleinfantry}, upgrades = choice2.upgrades, slotItems = choice1.slotItems, dropItems = choice1.dropItems}
		encounter:AddUnit(unit2)
		
		-- add node strength veterancy to spawned units
		SGroup_ForEach(sg_temp, NodeStrengthVeterancy)
		
		-- restart goal if necessary
		if encounter:HasGoal() == false then
			encounter:RestartGoal()
		end
		
		-- account for this in the counterattack's  unit count
		counterattack_units_still_to_spawn = counterattack_units_still_to_spawn - 1
		if counterattack_units_still_to_spawn <= 0 then
			counterattack_allspawned = true
		end
		
	end
	
end



function Counterattack_Stage2_AddMediumVehicleUnit()
	if counterattack_units_still_to_spawn <= 0 then
		Rule_RemoveMe()
	else
		if SGroup_Count(sg_counterattack_mediumvehicles) < t_difficulty.MaxMediumVehicles and Rule_Exists(Counterattack_Stage2_AddMediumVehicleUnit_PartB) == false then
			Rule_AddOneShot(Counterattack_Stage2_AddMediumVehicleUnit_PartB, World_GetRand(10, 50) / 10)
			Rule_ChangeInterval(Counterattack_Stage2_AddMediumVehicleUnit, (40 * SGroup_Count(sg_counterattack_mediumvehicles) * t_difficulty.CounterattackSpawnScaler))
		else
			Rule_ChangeInterval(Counterattack_Stage2_AddMediumVehicleUnit, 15)
		end
	end
end
function Counterattack_Stage2_AddMediumVehicleUnit_PartB()
	
	if counterattack_units_still_to_spawn >= 1 then
		
		SGroup_Clear(sg_temp)
		
		-- choose location and intended destination encounter
		local spawnloc = Table_GetRandomItem(t_counterattack_potential_vehicle_spawns)
		local encounter = Counterattack_PickSuitableEncounter()
		
		-- by design for now, middle and south share the default spawn while north is only applicable to paths along the northernmost route to minimize interference of their transit to their intended destination
		if counterattack_spawnLocation == "north" then
			spawnloc = Table_GetRandomItem(t_counterattack_potential_vehicle_spawns_north) -- north
		elseif counterattack_spawnLocation == "middle" then
			spawnloc = Table_GetRandomItem(t_counterattack_potential_vehicle_spawns) -- middle
		elseif counterattack_spawnLocation == "south" then
			spawnloc = Table_GetRandomItem(t_counterattack_potential_vehicle_spawns) -- south
		end
		
		-- choose and spawn units
		local choice1 = UnitTable_GetRandomItem(t_counterattack_stage2_potential_medium_vehicles)			-- medium vehicle
		local unit1	= {sbp = choice1.sbp, spawn = spawnloc.spawn, moveTo = spawnloc.dest, attackMoveTo = false, sgroups = {sg_temp, sg_counterattack_all, sg_counterattack_mediumvehicles}, upgrades = choice1.upgrades}
		encounter:AddUnit(unit1)
		
		local choice2 = UnitTable_GetRandomItem(t_counterattack_stage2_potential_simple_infantry)			-- accompanying infantry squad
		local unit2 = {sbp = choice2.sbp, spawn = spawnloc.spawn, moveTo = spawnloc.dest, attackMoveTo = false, sgroups = {sg_temp, sg_counterattack_all, sg_counterattack_simpleinfantry}, upgrades = choice2.upgrades}
		encounter:AddUnit(unit2)
		
		-- add node strength veterancy to spawned units
		SGroup_ForEach(sg_temp, NodeStrengthVeterancy)
		
		-- restart goal if necessary
		if encounter:HasGoal() == false then
			encounter:RestartGoal()
		end
	
		-- account for this in the counterattack's  unit count
		counterattack_units_still_to_spawn = counterattack_units_still_to_spawn - 1
		if counterattack_units_still_to_spawn <= 0 then
			counterattack_allspawned = true
		end
		
	end
	
end



function Counterattack_Stage2_AddHeavyVehicleUnit()
	if counterattack_units_still_to_spawn <= 0 then
		Rule_RemoveMe()
	else
		if SGroup_Count(sg_counterattack_heavyvehicles) < t_difficulty.MaxHeavyVehicles and Rule_Exists(Counterattack_Stage2_AddHeavyVehicleUnit_PartB) == false then
			Rule_AddOneShot(Counterattack_Stage2_AddHeavyVehicleUnit_PartB, World_GetRand(10, 50) / 10)
			Rule_ChangeInterval(Counterattack_Stage2_AddHeavyVehicleUnit, (120 * t_difficulty.CounterattackSpawnScaler))
		else
			Rule_ChangeInterval(Counterattack_Stage2_AddHeavyVehicleUnit, 15)
		end
	end
end
function Counterattack_Stage2_AddHeavyVehicleUnit_PartB()

	if counterattack_units_still_to_spawn >= 1 then
		
		SGroup_Clear(sg_temp)
		
		-- choose location and intended destination encounter
		local spawnloc = Table_GetRandomItem(t_counterattack_potential_heavyvehicle_spawns)
		local encounter = Counterattack_PickSuitableEncounter()
		
		
				-- by design for now, middle and south share the default spawn while north is only applicable to paths along the northernmost route to minimize interference of their transit to their intended destination
		if counterattack_spawnLocation == "north" then
			spawnloc = Table_GetRandomItem(t_counterattack_potential_heavyvehicle_spawns_north) -- north
		elseif counterattack_spawnLocation == "middle" then
			spawnloc = Table_GetRandomItem(t_counterattack_potential_heavyvehicle_spawns) -- middle
		elseif counterattack_spawnLocation == "south" then
			spawnloc = Table_GetRandomItem(t_counterattack_potential_heavyvehicle_spawns) -- south
		end
		
		-- choose and spawn units
		local choice1 = UnitTable_GetRandomItem(t_counterattack_stage2_potential_heavy_vehicles)			-- heavy vehicle comes in alone
		local unit1	= {sbp = choice1.sbp, spawn = spawnloc.spawn, moveTo = spawnloc.dest, attackMoveTo = false, sgroups = {sg_temp, sg_counterattack_all, sg_counterattack_heavyvehicles}, upgrades = choice1.upgrades }
		encounter:AddUnit(unit1)
		
		-- add node strength veterancy to spawned units
		SGroup_ForEach(sg_temp, NodeStrengthVeterancy)
		
		-- restart goal if necessary
		if encounter:HasGoal() == false then
			encounter:RestartGoal()
		end
		
		-- account for this in the counterattack's  unit count
		counterattack_units_still_to_spawn = counterattack_units_still_to_spawn - 1
		if counterattack_units_still_to_spawn <= 0 then
			counterattack_allspawned = true
		end
		
		-- add this route to the regular vehicle spawner's routes now its cleared by this heavy tank :)
		Event_Timer(AddRouteToNormalVehicleSpawns, {spawnloc = spawnloc}, 30)
		
	end
	
end





function AddRouteToNormalVehicleSpawns(data)

	-- early return if the spawnloc passed in is already the regular vehicle list
	for index, item in pairs(t_counterattack_potential_vehicle_spawns) do
		if item.spawn == data.spawnloc.spawn then
			return
		end
	end
	
	-- if not, we add this as a new spawn route
	table.insert(t_counterattack_potential_vehicle_spawns, data.spawnloc)
	
end




--------------------------------------
--                                  --
--  Miscellaneous helper functions  --
--                                  --
--------------------------------------

function Counterattack_PickSuitableEncounter()	-- returns an encounter

	if counterattack_stage == 1 then
		
		-- there's only one encounter at this point...
		return enc_CounterattackStage1
		
	elseif counterattack_stage == 2 then
		
		-- figure out the ratio of enemy units to player units in each encounter area
		Team_GetAllSquadsNearMarker(TEAM_ALLIES, sg_temp, mkr_counterattack_north_encounterarea)
		local north_ratio = SGroup_CountSpawned(sg_counterattack_stage2_northencounter) / (math.max(1, SGroup_Count(sg_temp)))
		
		Team_GetAllSquadsNearMarker(TEAM_ALLIES, sg_temp, mkr_counterattack_mid_encounterarea)
		local middle_ratio = SGroup_CountSpawned(sg_counterattack_stage2_midencounter) / (math.max(1, SGroup_Count(sg_temp)))
		
		Team_GetAllSquadsNearMarker(TEAM_ALLIES, sg_temp, mkr_counterattack_south_encounterarea)
		local south_ratio = SGroup_CountSpawned(sg_counterattack_stage2_southencounter) / (math.max(1, SGroup_Count(sg_temp)))
		
		-- return the encounter with the lowest ratio
		if north_ratio <= middle_ratio and north_ratio <= south_ratio then
			counterattack_spawnLocation = "north"
			return enc_CounterattackStage2North
			
		elseif middle_ratio <= north_ratio and middle_ratio <= south_ratio then
			counterattack_spawnLocation = "middle"
			return enc_CounterattackStage2Middle
		else
			counterattack_spawnLocation = "south"
			return enc_CounterattackStage2South
		end
		
	end

end



-- picking a random unit from the tables (exluding units whose node strength condition wasn't met)
function UnitTable_GetRandomItem(unittable)

	local possible_choices = {}
	
	for index, item in pairs(unittable) do
		
		if item.conditions == nil or (scartype(item.conditions) == ST_FUNCTION and item.conditions() == true) then
			if item.max_amount == nil or (scartype(item.max_amount) == ST_NUMBER and item.max_amount >= 1) then

				table.insert(possible_choices, item)
				
			end
		end
		
	end
	
	local choice = Table_GetRandomItem(possible_choices)
	
	if choice.max_amount ~= nil then
		choice.max_amount = choice.max_amount - 1
	end
	
	return choice
	
end


-- Node strength veterancy, called when spawning new units in counterattack waves
function NodeStrengthVeterancy(groupid, itemindex, itemid) 
	Squad_IncreaseVeterancyRank(itemid, XP1_GetNodeStrengthVeterancy(), true)
end

-- mission success script, and assigns medals accordingly
function Mission_CompleteDelay()

	if Event_IsAnyRunning() == false then
		Objective_Complete(OBJ_Bridges, false, true)
		XP1_SetMissionSuccessLevel(1)
		if Objective_IsComplete(SOBJ_NorthBridge) and EGroup_GetAvgHealth(eg_bridge_north) >= 0.50 then
			XP1_IncrementMissionSuccessLevel(1)
		end
		if Objective_IsComplete(SOBJ_SouthBridge) and EGroup_GetAvgHealth(eg_bridge_south) >= 0.50 then
			XP1_IncrementMissionSuccessLevel(1)
		end
		
		Allies_Stop()
		Counterattack_Stop()
		Rule_AddInterval(Mission_Complete, 1)
		Rule_RemoveMe()
	end
end

-- mission fail script, and also stops the bridge secondary objectives 
function Mission_FailDelay()

	if Event_IsAnyRunning() == false then
		if Rule_Exists(Mission_Fail) == false then
			
			-- silently end north bridge objective
			if SOBJ_NorthBridge ~=nil and Objective_IsFailed(SOBJ_NorthBridge) == false then
				Obj_SetState(SOBJ_NorthBridge.ID, OS_Incomplete)
				Objective_Fail(SOBJ_NorthBridge, false, true)			
			end
			
			-- silently end south bridge objective
			if SOBJ_SouthBridge ~= nil and Objective_IsFailed(SOBJ_SouthBridge) == false then
				Obj_SetState(SOBJ_SouthBridge.ID, OS_Incomplete)
				Objective_Fail(SOBJ_SouthBridge, false, true)			
			end
			
			
			Allies_Stop()
			Counterattack_Stop()
			XP1_SetMissionSuccessLevel(0)
			Rule_AddDelayedInterval(Mission_Fail, 1, 1)
		end
		Rule_RemoveMe()
		
	end
	
end
