-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- KALACH (German Co-op Scenario)
-- ENCOUNTERS FILE
-- Designer: Neil Jones-Rodway

-------------------------------------------------------------------------
-------------------------------------------------------------------------



function Kalach_CreateAIBaseDefenders()

	--
	-- P3 Base (on the west)
	--
	local encData_P3BaseDefence = {
		name = "P3 Base Defence",
		player = player3,
		spawn = mkr_basedefend_p3,
		units = {
			{sbp = SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD_MP, spawn = mkr_basedefend_p3_spawn1, sgroup = sg_basedefender_p3_atgun},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_MP},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_MP},
		},
	}
	local goalData_P3BaseDefence = {
		name = "Defend",
		target = mkr_basedefend_p3,
		range = Marker_GetProximityRadius(mkr_basedefend_p3) + 30,
		leashRange = Marker_GetProximityRadius(mkr_basedefend_p3),
	}
	enc_P3BaseDefence = Encounter:Create(encData_P3BaseDefence)
	enc_P3BaseDefence:SetGoal(goalData_P3BaseDefence)

	--
	-- P4 Base (on the west)
	--
	local encData_P4BaseDefence = {
		name = "P4 Base Defence",
		player = player4,
		spawn = mkr_basedefend_p4,
		units = {
			{sbp = SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD_MP, spawn = mkr_basedefend_p4_spawn1, sgroup = sg_basedefender_p4_atgun},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_MP},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_MP},
		},
	}
	local goalData_P4BaseDefence = {
		name = "Defend",
		target = mkr_basedefend_p4,
		range = Marker_GetProximityRadius(mkr_basedefend_p4) + 30,
		leashRange = Marker_GetProximityRadius(mkr_basedefend_p4),
	}
	enc_P4BaseDefence = Encounter:Create(encData_P4BaseDefence)
	enc_P4BaseDefence:SetGoal(goalData_P4BaseDefence)

	Modify_WeaponRange(sg_basedefender_p3_atgun, "hardpoint_01", 0.66)
	Modify_WeaponRange(sg_basedefender_p4_atgun, "hardpoint_01", 0.66)
	
end


--
-- create all the initial encounters - each bank has two large defend areas and a patrol path
--
function Kalach_CreateInitialEncounters()
	
	--
	-- west bank
	--
	local encData_WestPatrol = {
		name = "West Patrol",
		player = player4,
		spawn = mkr_enc_west1,
		units = {
			
			{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD_MP, spawn = mkr_westpatrol_spawn1},
			{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD_MP, spawn = mkr_westpatrol_spawn1},
			
			{sbp = SBP.GERMAN.GRENADIER_SQUAD_MP, spawn = mkr_westpatrol_spawn2},
			
			{sbp = SBP.GERMAN.GRENADIER_SQUAD_MP, spawn = mkr_westpatrol_spawn3},
			
		},
	}
	local goalData_WestPatrol = {
		name = "Defend",
		patrolParams = {
			path = "path_west_patrol1",
		},
	}
	enc_WestPatrol = Encounter:Create(encData_WestPatrol)
	enc_WestPatrol:SetGoal(goalData_WestPatrol)
	
	local encData_WestDefend1 = {
		name = "West Defend 1",
		player = player4,
		spawn = mkr_enc_west1,
		units = {
			{sbp = SBP.GERMAN.GRENADIER_SQUAD_MP,			spawn = mkr_west1_spawn1},
			{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD_MP, 			spawn = mkr_west1_spawn2},
			{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD_MP, 			spawn = mkr_west1_spawn2},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD_MP, 			spawn = mkr_west1_spawn3},
			{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, spawn = mkr_west1_spawn3, difficulty = {GD_NORMAL, GD_HARD}},
		},                                  
	}
	local goalData_WestDefend1 = {
		name = "Defend",
		target = mkr_enc_west1,
		range = Marker_GetProximityRadius(mkr_enc_west1) + 30,
		leashRange = Marker_GetProximityRadius(mkr_enc_west1),
		retaliateAttacks = true,
	}
	enc_WestDefend1 = Encounter:Create(encData_WestDefend1)
	enc_WestDefend1:SetGoal(goalData_WestDefend1)
	
	local encData_WestDefend2 = {
		name = "West Defend 2",
		player = player4,
		spawn = mkr_enc_west2,
		units = {
			{sbp = SBP.GERMAN.GRENADIER_SQUAD_MP, 	spawn = mkr_west2_spawn1},
			{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD_MP, 	spawn = mkr_west2_spawn2},
			{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD_MP, 	spawn = mkr_west2_spawn2},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD_MP,	spawn = mkr_west2_spawn3},
			{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP, spawn = mkr_west2_spawn3, difficulty = {GD_NORMAL, GD_HARD}},
		},                                  
	}
	local goalData_WestDefend2 = {
		name = "Defend",
		target = mkr_enc_west2,
		range = Marker_GetProximityRadius(mkr_enc_west2) + 30,
		leashRange = Marker_GetProximityRadius(mkr_enc_west2),
		retaliateAttacks = true,
	}
	enc_WestDefend2 = Encounter:Create(encData_WestDefend2)
	enc_WestDefend2:SetGoal(goalData_WestDefend2)
	
	
	--
	-- east bank
	--
	local encData_EastPatrol = {
		name = "East Patrol",
		player = player3,
		spawn = mkr_eastpatrol_spawn1,
		units = {
			
			{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD_MP, spawn = mkr_eastpatrol_spawn1},
			{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD_MP, spawn = mkr_eastpatrol_spawn1},
			
			{sbp = SBP.GERMAN.GRENADIER_SQUAD_MP, spawn = mkr_eastpatrol_spawn2},
			
			{sbp = SBP.GERMAN.GRENADIER_SQUAD_MP, spawn = mkr_eastpatrol_spawn3},
			
		},
	}
	local goalData_EastPatrol = {
		name = "Defend",
		patrolParams = {
			path = "path_east_patrol1",
		},
	}
	enc_EastPatrol = Encounter:Create(encData_EastPatrol)
	enc_EastPatrol:SetGoal(goalData_EastPatrol)
	
	local encData_EastDefend1 = {
		name = "East Defend 1",
		player = player3,
		spawn = mkr_enc_east1,
		units = {
			{sbp = SBP.GERMAN.GRENADIER_SQUAD_MP, 	spawn = mkr_east1_spawn1},
			{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD_MP, 	spawn = mkr_east1_spawn2},
			{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD_MP, 	spawn = mkr_east1_spawn2},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD_MP, 	spawn = mkr_east1_spawn3},
			{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP, spawn = mkr_east1_spawn3, difficulty = {GD_NORMAL, GD_HARD}},
		},
	}
	local goalData_EastDefend1 = {
		name = "Defend",
		target = mkr_enc_east1,
		range = Marker_GetProximityRadius(mkr_enc_east1) + 30,
		leashRange = Marker_GetProximityRadius(mkr_enc_east1),
		retaliateAttacks = true,
	}
	enc_EastDefend1 = Encounter:Create(encData_EastDefend1)
	enc_EastDefend1:SetGoal(goalData_EastDefend1)
	
	local encData_EastDefend2 = {
		name = "East Defend 2",
		player = player4,
		spawn = mkr_enc_east2,
		units = {
			{sbp = SBP.GERMAN.GRENADIER_SQUAD_MP, 			spawn = mkr_east2_spawn1},
			{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD_MP, 			spawn = mkr_east2_spawn2},
			{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD_MP, 			spawn = mkr_east2_spawn2},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD_MP, 			spawn = mkr_east2_spawn3},
			{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, spawn = mkr_east2_spawn3, difficulty = {GD_NORMAL, GD_HARD}},
		},                                  
	}
	local goalData_EastDefend2 = {
		name = "Defend",
		target = mkr_enc_east2,
		range = Marker_GetProximityRadius(mkr_enc_east2) + 30,
		leashRange = Marker_GetProximityRadius(mkr_enc_east2),
		retaliateAttacks = true,
	}
	enc_EastDefend2 = Encounter:Create(encData_EastDefend2)
	enc_EastDefend2:SetGoal(goalData_EastDefend2)
	
	
	
end





--
-- creates an encounter and spawns units to go after a specific point - it deals with all the logic for deciding what that ecounter should contain
--
function Kalach_CreateEncounterToGrabPoint(point)


	-- choose a player to use to spawn this encounter (whichever has fewer units)
	local spawn_player = {player = player3, spawnpoint = mkr_spawnpoint_p3}
	if Player_GetCurrentPopulation(player4, CT_Personnel) < Player_GetCurrentPopulation(player3, CT_Personnel) then
		spawn_player = {player = player4, spawnpoint = mkr_spawnpoint_p4}
	end
	
	
	-- check how much room this player has in their popcap for new units
	local remaining_popcap = Player_GetMaxPopulation(spawn_player.player, CT_Personnel) - Player_GetCurrentPopulation(spawn_player.player, CT_Personnel)
	
	
	--
	-- Figure out how much a headway the AI has...
	-- This is based off the difference in VP tickers, but gets adjusted by a number of other factors: difficulty mode, population difference, and a random factor (just for fun)
	-- The end result is that positive numbers indicate the AI being ahead, negative numbers indicate the player being ahead.
	--
	local team1pop = Player_GetCurrentPopulation(player1, CT_Personnel) + Player_GetCurrentPopulation(player2, CT_Personnel)
	local team2pop = Player_GetCurrentPopulation(player3, CT_Personnel) + Player_GetCurrentPopulation(player4, CT_Personnel)
	
	local base 					= VP_GetTeamTickers(2) - VP_GetTeamTickers(1)
	local difficulty 			= t_difficulty.ai_advantage_adjustment			-- adjust the value +- 150 depending of difficulty mode
	local random_factor 		= ( World_GetRand(0, 150) - 75 )				-- adjust the value +- 75 randomly
	local population_difference = (team2pop - team1pop)							-- adjust the value +- pop difference
	
	local ai_advantage = base + difficulty + random_factor + population_difference
	
	print("-----")
	print("AI advantage is " .. ai_advantage .. " - base:" .. base .. "  difficulty:" .. difficulty .. "  popcap:" .. population_difference .. "  random:" .. random_factor)
	print("Remaining pop is " .. remaining_popcap)
	
	
	-- figure out if we're early, mid or late game
	local game_stage = nil
	if World_GetGameTime() < 9*60 and VP_GetMinTickers() > 700 then
		game_stage = "early"
	elseif World_GetGameTime() < 25*60 and VP_GetMinTickers() > 350 then
		game_stage = "mid"
	else
		game_stage = "late"
	end
	
	
	-- set up the basic encounter and goal data
	local encData = {
		name = "Grab point "..EGroup_GetName(point),
		player = spawn_player.player,
		spawn = spawn_player.spawnpoint,
		units = {
			-- we'll fill in the units in a bit
		},
	}
	
	local goalData = {
		name = "Attack",
		target = point,
		range = 40,
		leashRange = 80,
		coordinatedMoveRadius = 40,
		coordinatedSetup = true,
		retaliateAttacks = true,
	}
	
	
	-- define the encounter's units 
	-- they will vary according to the AI advantage and the game stage
	if ai_advantage < -250 and remaining_popcap >= 40 then						-- AI is way behind - spawn lots and lots of units
		
		print("Spawning a very large, " .. game_stage .. "-game set of units for Player " .. Player_GetID(spawn_player.player) .. " to go after point " .. EGroup_GetName(point))
		
		if game_stage == "early" then
			encData.units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD_MP},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD_MP},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP},
				{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP},
			}
		elseif game_stage == "mid" then
			encData.units = {
				{sbp = SBP.GERMAN.GRENADIER_SQUAD_MP},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP},
				{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP},
				{sbp = SBP.GERMAN.STUG_III_SQUAD_MP},
			}
		elseif game_stage == "late" then
			encData.units = {
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP},
				{sbp = SBP.GERMAN.MORTAR_250_HALFTRACK_SQUAD_MP},
				{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP},
				{sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP},
			}
		end
		
	elseif ai_advantage < -100 and remaining_popcap >= 30 then					-- AI is behind - spawn more units
		
		print("Spawning a large, " .. game_stage .. "-game set of units for Player " .. Player_GetID(spawn_player.player) .. " to go after point " .. EGroup_GetName(point))
		
		if game_stage == "early" then
			encData.units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD_MP},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD_MP},
				{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP},
			}
		elseif game_stage == "mid" then
			encData.units = {
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD_MP},
				{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_MP},
				{sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP},
			}
		elseif game_stage == "late" then
			encData.units = {
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP},
				{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP},
				{sbp = SBP.GERMAN.STUG_III_SQUAD_MP},
			}
		end
		
	elseif ai_advantage < 100  and remaining_popcap >= 20 then						-- AI and player are almost neck and neck - spawn some units
		
		print("Spawning a regular, " .. game_stage .. "-game set of units for Player " .. Player_GetID(spawn_player.player) .. " to go after point " .. EGroup_GetName(point))
		
		if game_stage == "early" then
			encData.units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD_MP},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD_MP},
			}
		elseif game_stage == "mid" then
			encData.units = {
				{sbp = SBP.GERMAN.GRENADIER_SQUAD_MP},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP},
				{sbp = SBP.GERMAN.MORTAR_TEAM_81MM_MP},
			}
		elseif game_stage == "late" then
			encData.units = {
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP},
				{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP},
				{sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP},
			}
		end
		
	elseif ai_advantage < 250 and remaining_popcap >= 10 then						-- AI is ahead - spawn only a few units
		
		print("Spawning a small, " .. game_stage .. "-game set of units for Player " .. Player_GetID(spawn_player.player) .. " to go after point " .. EGroup_GetName(point))
		
		if game_stage == "early" then
			encData.units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD_MP},
			}
		elseif game_stage == "mid" then
			encData.units = {
				{sbp = SBP.GERMAN.GRENADIER_SQUAD_MP},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP},
			}
		elseif game_stage == "late" then
			encData.units = {
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP},
				{sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP},
			}
		end
		
	else 																			-- AI is way ahead - don't spawn any units at all, actually
		
		print("Choosing not to spawn any units to go after point " .. EGroup_GetName(point))
		
		return	-- early exit (so skip the encounter creation below)
		
	end
	
	
	-- actual create the encounter and send it off
	local encounter_id = Encounter:Create(encData)
	encounter_id:SetGoal(goalData)
	
end







--
-- when we finally open up the bridge, these are the encounters that are pre-populated on the bridge area
--
function Kalach_CreateBridgeDefences()

	-- create the guys that focus on the things coming from the west bank
	local encData_West = {
		name = "Bridge West",
		player = player4,
		spawn = mkr_bridge_defenders1,
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_MP	},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP	},
		},
	}
	local goalData_West = {
		name = "Defend",
		target = mkr_enc_bridge_left,
		range = Marker_GetProximityRadius(mkr_enc_bridge_left) + 30,
		leashRange = Marker_GetProximityRadius(mkr_enc_bridge_left),
	}

	enc_BridgeWest = Encounter:Create(encData_West)
	enc_BridgeWest:SetGoal(goalData_West)

	
	-- create the guys that focus on the things coming from the east bank
	local encData_East = {
		name = "Bridge East",
		player = player3,
		spawn = mkr_bridge_defenders1,
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_MP	},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP	},
		},
	}
	local goalData_East = {
		name = "Defend",
		target = mkr_enc_bridge_right,
		range = Marker_GetProximityRadius(mkr_enc_bridge_right) + 30,
		leashRange = Marker_GetProximityRadius(mkr_enc_bridge_right),
	}

	enc_BridgeEast = Encounter:Create(encData_East)
	enc_BridgeEast:SetGoal(goalData_East)

	
	-- and create guns that will be added to the encounters later
	Util_CreateSquads(player3, sg_bridgedefenders_east, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_MP, mkr_bridge_hmg2)
	Util_CreateSquads(player3, sg_bridgedefenders_east, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, mkr_bridge_atgun2)
	Util_CreateSquads(player4, sg_bridgedefenders_west, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_MP, mkr_bridge_hmg1)
	Util_CreateSquads(player4, sg_bridgedefenders_west, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, mkr_bridge_atgun1)
	if AI_IsEnabled(player3) then
		AI_LockSquads(player3, sg_bridgedefenders_east)
	end
	if AI_IsEnabled(player4) then
		AI_LockSquads(player4, sg_bridgedefenders_west)
	end
	
	-- add events so they become part of encounters as the player approaches
	Event_Proximity(Kalach_AddGunsToBridgeDefences_East, nil, TEAM_ALLIES, mkr_enc_bridge_right, 33, ANY, 3)
	Event_Proximity(Kalach_AddGunsToBridgeDefences_West, nil, TEAM_ALLIES, mkr_enc_bridge_left, 33, ANY, 3)
	
end

function Kalach_AddGunsToBridgeDefences_East()
	
	enc_BridgeEast:AddSgroup(sg_bridgedefenders_east)
	enc_BridgeEast:RestartGoal()
	
end
function Kalach_AddGunsToBridgeDefences_West()
	
	enc_BridgeWest:AddSgroup(sg_bridgedefenders_west)
	enc_BridgeWest:RestartGoal()
	
end






--
-- once the player captures the bridge point, trigger a retaliation
--
function Kalach_CreateMainBridgeRetaliation()

	-- create the guys that focus on the things coming from the west bank
	local encData_West = {
		name = "Retaliate West",
		player = player4,
		spawn = mkr_spawnpoint_p4,
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP,},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP,},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_MP},
			{sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP},
			{sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP},
		},
	}
	local goalData_West = {
		name = "Attack",
		target = eg_vp_bridge,
		range = 100,
		leashRange = 70,
		onSuccess = function(encounter)
			local newGoal = {
				name = "Defend",
				target = mkr_enc_bridge_left,
				range = Marker_GetProximityRadius(mkr_enc_bridge_left),
				leashRange = Marker_GetProximityRadius(mkr_enc_bridge_left) + 30,
			}
			encounter:SetGoal(newGoal)
		end,
	}

	enc_RetaliateWest = Encounter:Create(encData_West)
	enc_RetaliateWest:SetGoal(goalData_West)


	-- create the guys that focus on the things coming from the east bank
	local encData_East = {
		name = "Retaliate East",
		player = player3,
		spawn = mkr_spawnpoint_p3,
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP,},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP,},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_MP},
			{sbp = SBP.GERMAN.PANTHER_SQUAD_MP},
		},
	}
	local goalData_East = {
		name = "Attack",
		target = eg_vp_bridge,
		range = 100,
		leashRange = 70,
		onSuccess = function(encounter)
			local newGoal = {
				name = "Defend",
				target = mkr_enc_bridge_right,
				range = Marker_GetProximityRadius(mkr_enc_bridge_right),
				leashRange = Marker_GetProximityRadius(mkr_enc_bridge_right) + 30,
			}
			encounter:SetGoal(newGoal)
		end,
	}

	enc_RetaliateEast = Encounter:Create(encData_East)
	enc_RetaliateEast:SetGoal(goalData_East)


end




function Kalach_CreateTopUpBridgeRetaliation()
	
	local encData = nil 
	local goalData = {
		name = "Attack",
		target = eg_vp_bridge,
		range = 100,
		leashRange = 70,
		onSuccess = function(encounter)
			local newGoal = {
				name = "Defend",
				target = mkr_enc_bridge_left,
				range = Marker_GetProximityRadius(mkr_enc_bridge_left) + 30,
				leashRange = Marker_GetProximityRadius(mkr_enc_bridge_left),
			}
			encounter:SetGoal(newGoal)
		end,
	}
	
	if Player_GetCurrentPopulation(player3, CT_Personnel) < Player_GetCurrentPopulation(player4, CT_Personnel) then
		
		encData = {
			name = "Retaliate East",
			player = player3,
			spawn = mkr_spawnpoint_p3,
			units = {
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP,},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_MP},
			},
		}
		
	else
		
		encData = {
			name = "Retaliate West",
			player = player4,
			spawn = mkr_spawnpoint_p4,
			units = {
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP,},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_MP},
			},
		}
		
	end
	
	
	local new_encounter = Encounter:Create(encData)
	new_encounter:SetGoal(goalData)
	
	
end


