-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- OUREN - Encounters data (those not directly tied to objectives)
-- Designer: NJR
-------------------------------------------------------------------------
-------------------------------------------------------------------------

ENCOUNTERS = {}
GOALS = {}



---------------------------------------------------
--                                               --
--   ENCOUNTERS FOR THE SOUTH BRIDGE OBJECTIVE   --
--                                               --
---------------------------------------------------

ENCOUNTERS.SouthFieldDefenders = function()
	
	local encData = {
		
		name = "South Field Defenders",
		player = player2,
		spawn = mkr_southfield_spawn1,
		
		units = {
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, load = 2},
		},
		
		triggerGoalOnSight = true,
		goal = {
			name = "Defend",
			target = mkr_southfield_encounterarea,
			leashRange = Marker_GetProximityRadius(mkr_southfield_encounterarea),
			range = Marker_GetProximityRadius(mkr_southfield_encounterarea) + 30,
		},
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter
	
end

ENCOUNTERS.SouthBridgeDefenders = function()
	
	local encData = {
		
		name = "South Bridge Defenders",
		player = player2,
		spawn = mkr_southbridge_spawn7,
		sgroups = {sg_southbridge_encounter},
		
		units = {
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, 
				spawn = mkr_southbridge_spawn2, 
				load = 3, 
				sgroups = {sg_southbridge_southdefenders},
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, 
				spawn = mkr_southbridge_spawn3, load = 4, 
				sgroups = {sg_southbridge_southdefenders},
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, 
				spawn = mkr_southbridge_spawn6, 
				load = 4,
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, 
				spawn = mkr_southbridge_spawn4, 
				load = 3,
				conditions = {XP1_GetNodeStrength() >= 5 and g_difficulty ~= GD_HARD},
			},
			-- hard
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, 
				spawn = mkr_southbridge_spawn4,  
				conditions = {g_difficulty == GD_HARD},
			},
		},
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_southbridge_encounterarea,
			range = Marker_GetProximityRadius(mkr_southbridge_encounterarea) + 30,
			garrisonIdle = true,
			garrison = true,
		},
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter
	
end

GOALS.SouthBridgeDefenders_Fallback1 = function(encounter)

	local goalData = {
		name = "Defend",
		target = mkr_southbridge_encounterarea_fallback1,
		leashRange = Marker_GetProximityRadius(mkr_southbridge_encounterarea_fallback1),
		range = Marker_GetProximityRadius(mkr_southbridge_encounterarea_fallback1) + 30,
		garrisonIdle = true,
		garrison = true,
	}
	
	encounter:SetGoal(goalData)

end

GOALS.SouthBridgeDefenders_Fallback2 = function(encounter)

	local goalData = {
		name = "Defend",
		target = mkr_southbridge_encounterarea_fallback2,
		leashRange = Marker_GetProximityRadius(mkr_southbridge_encounterarea_fallback2),
		range = Marker_GetProximityRadius(mkr_southbridge_encounterarea_fallback2) + 30,
	}
	
	encounter:SetGoal(goalData)

end



---------------------------------------------------
--                                               --
--   ENCOUNTERS FOR THE NORTH BRIDGE OBJECTIVE   --
--                                               --
---------------------------------------------------

ENCOUNTERS.NorthBridgeDefenders = function()
	
	local encData = {
		
		name = "North Bridge Defenders",
		player = player2,
		spawn = mkr_northbridge_spawn7,
		sgroups = {sg_northbridge_encounter},
		
		units = {
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = eg_northbridge_tower},
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = mkr_northbridge_spawn7},
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = mkr_northbridge_spawn1},
		},
		
		goal = {
			name = "Defend",
			target = mkr_northbridge_encounterarea,
			range = Marker_GetProximityRadius(mkr_northbridge_encounterarea) + 30,
			leashRange = Marker_GetProximityRadius(mkr_northbridge_encounterarea),
			garrison = true,
			garrisonIdle = true,
		},
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter
	
end

ENCOUNTERS.NorthFieldDefenders = function()
	
	local encData = {
		
		name = "North Field Defenders",
		player = player2,
		spawn = mkr_northfield_spawn1,
		sgroups = {sg_northfield_encounter},
		
		units = {
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, 
				spawn = mkr_northfield_spawn3,
--~ 				conditions = {g_difficulty ~= GD_HARD},
			},
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, 
				spawn = mkr_northfield_spawn3,
				conditions = {g_difficulty == GD_HARD},
			},
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = eg_northfield_barn},
		},
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_northfield_encounterarea,
			range = Marker_GetProximityRadius(mkr_northfield_encounterarea) + 30,
			leashRange = Marker_GetProximityRadius(mkr_northfield_encounterarea),
			garrison = true,
			garrisonIdle = true,
		},
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter
	
end




---------------------------------------------------
--                                               --
--  ENCOUNTERS FOR THE COUNTER-ATTACK OBJECTIVE  --
--                                               --
---------------------------------------------------

ENCOUNTERS.Counterattack_Stage1 = function()
	
	local encData = {
		
		name = "Counterattack Stage 1 Units",
		player = player2,
		spawn = mkr_east_spawn2,
		sgroups = {sg_counterattack_stage1_encounter},
		
		units = {
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = mkr_east_spawn_hidden1},
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = mkr_east_spawn_hidden3},
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = mkr_east_spawn_hidden5},
		},
		
		goal = {
			name = "Defend",
			target = mkr_counterattack_mid_encounterarea,
			range = Marker_GetProximityRadius(mkr_counterattack_mid_encounterarea),
			leashRange = Marker_GetProximityRadius(mkr_counterattack_mid_encounterarea) + 30,
			garrison = true,
			garrisonIdle = true,
			maxTime = -1,
			maxIdleTime = -1,
		},
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter
	
end


ENCOUNTERS.Counterattack_Stage2_North = function()
	
	local encData = {
		
		name = "Counterattack Stage 2 North Units",
		player = player2,
		spawn = mkr_east_spawn1,
		sgroups = {sg_counterattack_stage2_northencounter},
		
		units = {
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = mkr_east_spawn_hidden1, sgroups = {sg_counterattack_all}},
		},
		
		goal = {
			name = "Defend",
			target = mkr_counterattack_north_encounterarea,
			range = Marker_GetProximityRadius(mkr_counterattack_north_encounterarea),
			leashRange = Marker_GetProximityRadius(mkr_counterattack_north_encounterarea) + 30,
			garrison = true,
			garrisonIdle = true,
			coordinatedSetup = false,
--~ 			maxTime = -1,
--~ 			maxIdleTime = -1,
			attackMove = true,
		},
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter
	
end

ENCOUNTERS.Counterattack_Stage2_Middle = function()
	
	local encData = {
		
		name = "Counterattack Stage 2 Mid Units",
		player = player2,
		spawn = mkr_east_spawn2,
		sgroups = {sg_counterattack_stage2_midencounter},
		
		units = {
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = mkr_east_spawn_hidden1, sgroups = {sg_counterattack_all}},
		},
		
		goal = {
			name = "Defend",
			target = mkr_counterattack_mid_encounterarea,
			range = Marker_GetProximityRadius(mkr_counterattack_mid_encounterarea),
			leashRange = Marker_GetProximityRadius(mkr_counterattack_mid_encounterarea) + 30,
			garrison = true,
			garrisonIdle = true,
			coordinatedSetup = false,
--~ 			maxTime = -1,
--~ 			maxIdleTime = -1,
			attackMove = true,
		},
		
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter
	
end

ENCOUNTERS.Counterattack_Stage2_South = function()
	
	local encData = {
		
		name = "Counterattack Stage 2 South Units",
		player = player2,
		spawn = mkr_east_spawn1,
		sgroups = {sg_counterattack_stage2_southencounter},
		
		units = {
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = mkr_east_spawn_hidden1, sgroups = {sg_counterattack_all}},
		},
		
		goal = {
			name = "Defend",
			target = mkr_counterattack_south_encounterarea,
			range = Marker_GetProximityRadius(mkr_counterattack_south_encounterarea),
			leashRange = Marker_GetProximityRadius(mkr_counterattack_south_encounterarea) + 30,
			garrison = true,
			garrisonIdle = true,
			coordinatedSetup = false,
--~ 			maxTime = -1,
--~ 			maxIdleTime = -1,
			attackMove = true,
		},
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter
	
end

GOALS.Counterattack_Stage2_AttackBridge_North = function(encounter)

	local goalData = {
		name = "Attack",
		target = eg_bridge_north,
		range = 30,
		leashRange = 60,
		coordinatedSetup = false,
		maxTime = -1,
		maxIdleTime = -1,
		garrison = false,
	}
	
	encounter:SetGoal(goalData)

end

GOALS.Counterattack_Stage2_AttackBridge_South = function(encounter)

	local goalData = {
		name = "Attack",
		target = eg_bridge_south,
		range = 30,
		leashRange = 60,
		coordinatedSetup = false,
		maxTime = -1,
		maxIdleTime = -1,
		garrison = false,
	}
	
	encounter:SetGoal(goalData)

end



---------------------------------------------------
--                                               --
--  ENCOUNTERS FOR THE ALLIES' BRIDGE BEHAVIOUR  --
--                                               --
---------------------------------------------------

ENCOUNTERS.Allies_Bridge_Muster1 = function()			-- muster 1 - next to bridge, short range. Ideal for infantry.
	
	local encData = {
		
		name = "Allies 1",
		player = player3,
		spawn = mkr_ally_spawn1,
		sgroups = {sg_allies_muster1},
		
		units = {
			{sbp = SBP.AEF.RIFLEMEN_SQUAD_MP},
		},
		
		goal = {
			name = "Defend",
			target = mkr_northbridge_muster1,
			range = Marker_GetProximityRadius(mkr_northbridge_muster1) + 30,
			leashRange = Marker_GetProximityRadius(mkr_northbridge_muster1),
		},
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter
	
end

ENCOUNTERS.Allies_Bridge_Muster2 = function()			-- muster 2 - end of bridge. Ideal for vehicles, AT guns.
	
	local encData = {							
		
		name = "Allies 2",
		player = player3,
		spawn = mkr_ally_spawn2,
		sgroups = {sg_allies_muster2},
		
		units = {
			{sbp = SBP.AEF.RIFLEMEN_SQUAD_MP},
		},
		
		goal = {
			name = "Defend",
			target = mkr_northbridge_muster2,
			range = Marker_GetProximityRadius(mkr_northbridge_muster2) + 30,
			leashRange = Marker_GetProximityRadius(mkr_northbridge_muster2),
		},
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter
	
end

ENCOUNTERS.Allies_Bridge_Muster3 = function()			-- muster 3 - waters edge, short range. Ideal for infantry.
	
	local encData = {						
		
		name = "Allies 3",
		player = player3,
		spawn = mkr_ally_spawn1,
		sgroups = {sg_allies_muster3},
		
		units = {
			{sbp = SBP.AEF.RIFLEMEN_SQUAD_MP},
		},
		
		goal = {
			name = "Defend",
			target = mkr_northbridge_muster3,
			range = Marker_GetProximityRadius(mkr_northbridge_muster3) + 30,
			leashRange = Marker_GetProximityRadius(mkr_northbridge_muster3),
		},
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter
	
end

ENCOUNTERS.Allies_Bridge_Muster4 = function()			-- muster 4 - back row, long range. Ideal for mortars.
	
	local encData = {						
		
		name = "Allies 4",
		player = player3,
		spawn = mkr_ally_spawn1,
		sgroups = {sg_allies_muster4},
		
		units = {
			{sbp = SBP.AEF.RIFLEMEN_SQUAD_MP},
		},
		
		goal = {
			name = "Defend",
			target = mkr_northbridge_muster4,
			range = Marker_GetProximityRadius(mkr_northbridge_muster4) + 30,
			leashRange = Marker_GetProximityRadius(mkr_northbridge_muster4),
		},
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter
	
end

ENCOUNTERS.Allies_Bridge_Muster5 = function()			-- muster 5 - back row, long range. Ideal for mortars.
	
	local encData = {						
		
		name = "Allies 5",
		player = player3,
		spawn = mkr_ally_spawn2,
		sgroups = {sg_allies_muster5},
		
		units = {
			{sbp = SBP.AEF.RIFLEMEN_SQUAD_MP},
		},
		
		goal = {
			name = "Defend",
			target = mkr_northbridge_muster5,
			range = Marker_GetProximityRadius(mkr_northbridge_muster5) + 30,
			leashRange = Marker_GetProximityRadius(mkr_northbridge_muster5),
		},
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter
	
end



---------------------------------------------------
--                                               --
--  ENCOUNTERS FOR THE ALLIES STAGE 1 BEHAVIOUR  --
--                                               --
---------------------------------------------------

ENCOUNTERS.Allies_Counterattack_Stage1 = function()	
	
	local encData = {
		
		name = "Allied Counterattack Stage 1 Units",
		player = player3,
		spawn = mkr_ally_spawn1,
		sgroups = {sg_allies_stage1_encounter},
		
		units = {
			{sbp = SBP.AEF.RIFLEMEN_SQUAD_MP},
		},
		
		goal = {
			name = "Attack",
			target = mkr_counterattack_north_encounterarea,
			range = Marker_GetProximityRadius(mkr_counterattack_north_encounterarea),
			leashRange = Marker_GetProximityRadius(mkr_counterattack_north_encounterarea) + 30,
			garrison = true,
			garrisonIdle = true,
			coordinatedSetup = false,
			maxTime = -1,
			maxIdleTime = -1,
		},
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter
	
end



---------------------------------------------------
--                                               --
--  ENCOUNTERS FOR THE ALLIES STAGE 2 BEHAVIOUR  --
--                                               --
---------------------------------------------------

ENCOUNTERS.Allies_Counterattack_Stage2_North = function()	
	
	local encData = {
		
		name = "Allied Counterattack Stage 2 North Units",
		player = player3,
		spawn = mkr_ally_spawn1,
		sgroups = {sg_allies_stage2_northencounter},
		
		units = {
			{sbp = SBP.AEF.RIFLEMEN_SQUAD_MP},
		},
		
		goal = {
			name = "Attack",
			target = mkr_counterattack_north_encounterarea,
			range = Marker_GetProximityRadius(mkr_counterattack_north_encounterarea),
			leashRange = Marker_GetProximityRadius(mkr_counterattack_north_encounterarea) + 30,
			garrison = true,
			garrisonIdle = true,
			coordinatedSetup = false,
			maxTime = -1,
			maxIdleTime = -1,
		},
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter
	
end

ENCOUNTERS.Allies_Counterattack_Stage2_Middle = function()	
	
	local encData = {
		
		name = "Allied Counterattack Stage 2 Middle Units",
		player = player3,
		spawn = mkr_ally_spawn1,
		sgroups = {sg_allies_stage2_midencounter},
		
		units = {
			{sbp = SBP.AEF.RIFLEMEN_SQUAD_MP},
		},
		
		goal = {
			name = "Attack",
			target = mkr_counterattack_mid_encounterarea,
			range = Marker_GetProximityRadius(mkr_counterattack_mid_encounterarea),
			leashRange = Marker_GetProximityRadius(mkr_counterattack_mid_encounterarea) + 30,
			garrison = true,
			garrisonIdle = true,
			coordinatedSetup = false,
			maxTime = -1,
			maxIdleTime = -1,
		},
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter
	
end
















---------------------------------------------------
--                                               --
-- OTHER MISCELLANEOUS ENCOUNTERS AROUND THE MAP --
--                                               --
---------------------------------------------------

--
-- Mini-encounter around the fuel depot
--
ENCOUNTERS.FuelDepotEncounter = function()
	
	local encData = {
		
		name = "Fuel Depot defenders",
		spawn = mkr_fueldepot_encounterarea,
		player = player2,
		
		units = {
			{
				sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, 
				spawn = mkr_fueldepot_spawn1,
				conditions = {g_difficulty == GD_HARD},
			},
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = mkr_fueldepot_spawn2},
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = mkr_fueldepot_spawn3},
			{
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, 
				spawn = mkr_fueldepot_spawn3,
				conditions = {g_difficulty >= GD_NORMAL},
			},
		},
		
		goal = {
			name = "Defend",
			target = mkr_fueldepot_encounterarea,
			range = Marker_GetProximityRadius(mkr_fueldepot_encounterarea) + 30,
			leashRange = Marker_GetProximityRadius(mkr_fueldepot_encounterarea),
		},
		triggerGoalOnEngage = true,
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter
	
end


--
-- Mini-encounter around the munitions depot
--
ENCOUNTERS.MunitionsDepotEncounter = function()
	
	local encData = {
		
		name = "Munitions Depot defenders",
		spawn = mkr_munitionsdepot_encounterarea,
		player = player2,
		
		units = {
			{
				sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, 
				spawn = mkr_munitionsdepot_spawn1,
				conditions = {g_difficulty >= GD_NORMAL},
			},
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = mkr_munitionsdepot_spawn2},
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = mkr_munitionsdepot_spawn3},
		},
		
		goal = {
			name = "Defend",
			target = mkr_munitionsdepot_encounterarea,
			range = Marker_GetProximityRadius(mkr_munitionsdepot_encounterarea) + 30,
			leashRange = Marker_GetProximityRadius(mkr_munitionsdepot_encounterarea),
		},
		triggerGoalOnEngage = true,
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter
	
end


--
-- Mini-encounter in the buildings south the enemy base
--
ENCOUNTERS.Stronghold1 = function()
	
	local encData = {
		
		name = "Stronghold 1 defenders",
		spawn = mkr_stronghold1_encounterarea,
		player = player2,
		
		units = {
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
			{
				sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 4},
			},
		},
		
		goal = {
			name = "Defend",
			target = mkr_stronghold1_encounterarea,
			range = Marker_GetProximityRadius(mkr_stronghold1_encounterarea) + 30,
			leashRange = Marker_GetProximityRadius(mkr_stronghold1_encounterarea),
			garrisonIdle = true,
			garrison = true,
			fallbackParams = {
				thresholds = {0.5},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				retreat = true,
				markers = {mkr_enemybase_encounterarea},
			},
			onTransition = Stronghold_MergeIntoBaseEncounter,
		},
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter
	
end


--
-- Mini-encounter in the buildings south the enemy base
--
ENCOUNTERS.Stronghold2 = function()
	
	local encData = {
		
		name = "Stronghold 2 defenders",
		spawn = mkr_stronghold2_encounterarea,
		player = player2,
		
		units = {
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
		},
		
		goal = {
			name = "Defend",
			target = mkr_stronghold2_encounterarea,
			range = Marker_GetProximityRadius(mkr_stronghold2_encounterarea) + 30,
			leashRange = Marker_GetProximityRadius(mkr_stronghold2_encounterarea),
			garrisonIdle = true,
			garrison = true,
			fallbackParams = {
				thresholds = {0.5},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				retreat = true,
				markers = {mkr_enemybase_encounterarea},
			},
			onTransition = Stronghold_MergeIntoBaseEncounter,
		},
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter
	
end


--
-- Mini-encounter in the courtyard to the north of the base area
--
ENCOUNTERS.Stronghold3 = function()
	
	local encData = {
		
		name = "Stronghold 3 defenders",
		spawn = mkr_stronghold3_encounterarea,
		player = player2,
		
		units = {
			{
				sbp = SBP.WEST_GERMAN.LE_IG_18_INF_SUPPORT_GUN_SQUAD_MP,
				conditions = {g_mortars == true},
			},
			{sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP},
		},
		
		goal = {
			name = "Defend",
			target = mkr_stronghold3_encounterarea,
			range = Marker_GetProximityRadius(mkr_stronghold3_encounterarea) + 30,
			leashRange = Marker_GetProximityRadius(mkr_stronghold3_encounterarea),
			garrisonIdle = true,
			garrison = true,
			fallbackParams = {
				thresholds = {0.5},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				retreat = true,
				markers = {mkr_enemybase_encounterarea},
			},
			onTransition = Stronghold_MergeIntoBaseEncounter,
		},
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter
	
end



-- function called when any of the stronghold encounters fall back - this makes them merge into the Defend Base encounter
function Stronghold_MergeIntoBaseEncounter(encounter, state)

	if state == AIObjectiveStage_Fallback then
		
		local sgroup = encounter:GetSgroup()
		
		encounter:Disable()
		
		enc_EnemyBase:AddSgroup(sgroup)
		
		-- restart goal if necessary
		if enc_EnemyBase:HasGoal() == false then
			enc_EnemyBase:RestartGoal()
		end
		
	end
	
end




--
-- Wandering path encounters (guys on paths, just to create random interactions)
--
ENCOUNTERS.WanderingEncounter1 = function()
	
	local encData = {
		
		name = "Wanderers 1",
		player = player2,
		
		units = {
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, 			load = 2, spawn = mkr_wander_spawn1},
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, 			load = 3, spawn = mkr_wander_spawn3},
		},
		
		goal = {
			name = "Defend",
			garrisonIdle = true,
			garrison = true,
			patrolParams = {
				path = "path_wander1",
				wait = 9,
				loop = LOOP_TOGGLE_DIRECTION,
			},
			fallbackParams = {
				thresholds = {0.2},
				retreat = true,
				retreatOnSuppression = true,
				retreatDelay = 3,
			},
			onTransition = Stronghold_MergeIntoBaseEncounter,
		},
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter

end

ENCOUNTERS.WanderingEncounter2 = function()
	
	local encData = {
		
		name = "Wanderers 2",
		player = player2,
		
		units = {
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, 			load = 3, spawn = mkr_wander_spawn2},
			{sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, 	load = 3, spawn = mkr_wander_spawn4},
		},
		
		goal = {
			name = "Defend",
			garrisonIdle = true,
			garrison = true,
			patrolParams = {
				path = "path_wander1",
				wait = 4,
				loop = LOOP_NORMAL,
			},
			fallbackParams = {
				thresholds = {0.3},
				retreat = true,
				retreatOnSuppression = true,
				retreatDelay = 3,
			},
			onTransition = Stronghold_MergeIntoBaseEncounter,
		},
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter

end

ENCOUNTERS.WanderingEncounter3 = function()
	
	local encData = {
		
		name = "Wanderers 3",
		player = player2,
		
		units = {
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, 			load = 2, spawn = mkr_wander_spawn1},
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, 			load = 2, spawn = mkr_wander_spawn3},
		},
		
		goal = {
			name = "Defend",
			garrisonIdle = true,
			garrison = true,
			patrolParams = {
				path = "path_wander2",
				wait = 8,
				loop = LOOP_TOGGLE_DIRECTION,
			},
			fallbackParams = {
				thresholds = {0.2},
				retreat = true,
				retreatOnSuppression = true,
				retreatDelay = 3,
			},
			onTransition = Stronghold_MergeIntoBaseEncounter,
		},
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter

end


ENCOUNTERS.WanderingEncounter4 = function()
	
	local encData = {
		
		name = "Wanderers 4",
		player = player2,
		
		units = {
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, 			load = 3, spawn = mkr_wander_spawn2},
			{sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, 	load = 3, spawn = mkr_wander_spawn4},
		},
		
		goal = {
			name = "Defend",
			garrisonIdle = true,
			garrison = true,
			patrolParams = {
				path = "path_wander2",
				wait = 6,
				loop = LOOP_NORMAL,
			},
			fallbackParams = {
				thresholds = {0.3},
				retreat = true,
				retreatOnSuppression = true,
				retreatDelay = 3,
			},
			onTransition = Stronghold_MergeIntoBaseEncounter,
		},
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter

end


ENCOUNTERS.WanderingEncounter5 = function()
	
	local encData = {
		
		name = "Wanderers 5",
		player = player2,
		
		units = {
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, 			load = 2, spawn = mkr_wander_spawn3},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, 			
				load = 2, 
				spawn = mkr_wander_spawn4,
				conditions = {g_elite_infantry == false},
			},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, 				
				load = 2, 
				spawn = mkr_wander_spawn4,
				conditions = {g_elite_infantry == true},
			},
		},
		
		goal = {
			name = "Defend",
			garrisonIdle = true,
			garrison = true,
			patrolParams = {
				path = "path_wander3",
				wait = 7,
				loop = LOOP_TOGGLE_DIRECTION,
			},
			fallbackParams = {
				thresholds = {0.2},
				retreat = true,
				retreatOnSuppression = true,
				retreatDelay = 3,
			},
			onTransition = Stronghold_MergeIntoBaseEncounter,
		},
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter

end


ENCOUNTERS.WanderingEncounter6 = function()
	
	local encData = {
		
		name = "Wanderers 6",
		player = player2,
		
		units = {
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, 			load = 2, spawn = mkr_wander_spawn1},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, 				
				load = 3, 
				spawn = mkr_wander_spawn2,
				conditions = {g_elite_infantry == true},
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, 				
				load = 3, 
				spawn = mkr_wander_spawn2,
				conditions = {g_elite_infantry == false},
			},
		},
		
		goal = {
			name = "Defend",
			garrisonIdle = true,
			garrison = true,
			patrolParams = {
				path = "path_wander3",
				wait = 5,
				loop = LOOP_NORMAL,
			},
			fallbackParams = {
				thresholds = {0.3},
				retreat = true,
				retreatOnSuppression = true,
				retreatDelay = 3,
			},
			onTransition = Stronghold_MergeIntoBaseEncounter,
		},
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter

end


--
-- Encounter in the enemy base area itself
--
ENCOUNTERS.EnemyBase = function()	
	
	local encData = {
		
		name = "Enemy Base defenders",
		spawn = mkr_enemybase_encounterarea,
		player = player2,
		
		units = {
			{sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, spawn = mkr_enemybase_spawn1},
			{sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, spawn = mkr_enemybase_spawn2},
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = eg_base_tower1, backupSpawn = mkr_enemybase_spawn3},
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = mkr_enemybase_spawn3},
		},
		
		goal = {
			name = "Defend",
			target = mkr_enemybase_encounterarea,
			range = Marker_GetProximityRadius(mkr_enemybase_encounterarea) + 30,
			leashRange = Marker_GetProximityRadius(mkr_enemybase_encounterarea),
			garrisonIdle = true,
			garrison = true,
		},
		triggerGoalOnEngage = true,
		
	}
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter
	
end



---------------------------------------------
-- Secondary objective encounters
---------------------------------------------
ENCOUNTERS.protectVIP = function(spawnloc)
	local encData = {
		name = "vipProtector",
		units = {
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				spawn = Prox_GetRandomPosition(spawnloc, 9, 5),
				conditions = {g_elite_infantry == true},
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = Prox_GetRandomPosition(spawnloc, 9, 5),
				conditions = {g_elite_infantry == false},
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = Prox_GetRandomPosition(spawnloc, 9, 5),
			},
		},
		onDeath = nil,
	}
	encID_newEncounter = XP1_EncounterCreate(encData)
	
	return encID_newEncounter
end

ENCOUNTERS.protectTank = function(spawnloc)
	local encData = {
		name = "tankProtector",
		spawn = spawnloc,
		units = {
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				conditions = {g_elite_infantry == true},
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {g_elite_infantry == false},
			},
		},
		onDeath = nil,
	}
	encID_newEncounter = XP1_EncounterCreate(encData)
	
	return encID_newEncounter
end