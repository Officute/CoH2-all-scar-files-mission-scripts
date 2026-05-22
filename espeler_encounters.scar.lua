print("\tLoading encdata file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Espeler - Encounters data
-- Designer: B.Chow
-------------------------------------------------------------------------
-------------------------------------------------------------------------
ENCOUNTERS = {}

-- Left-side Encounters
ENCOUNTERS.LeftArea1 = function()
	-- The initial left-side of the road
	local encData = {
		name = "LeftArea1",
		sgroups = {sg_encounter_left1, sg_enemies_all},
		spawn = {mkr_enc_left1_spawn1, mkr_enc_left1_spawn2},
		units = {
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 4 or g_difficulty == GD_HARD},
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_left1_area,
			range = 25,
			leashRange = 35,
			tacticControlList = {},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

ENCOUNTERS.LeftArea2 = function()
	local encData = {
		name = "LeftArea2",
		sgroups = {sg_encounter_left2, sg_enemies_all},
		spawn = {mkr_enc_left2_spawn1, mkr_enc_left2_spawn2},
		intent = ENC_INTENT.basicInfantry,
		goal = {
			name = "Defend",
			target = mkr_enc_left2_area,
			range = 35,
			leashRange = 45,
			tacticControlList = {},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

ENCOUNTERS.LeftArea3 = function()
	local encData = {
		name = "LeftArea3",
		sgroups = {sg_encounter_left3, sg_enemies_all},
		spawn = {mkr_enc_left3_spawn1, mkr_enc_left3_spawn2},
		units = {
			-- normal
			{
				sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 3 or g_difficulty == GD_HARD},
			},
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 4},
			},
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_left3_area,
			range = 25,
			leashRange = 35,
			tacticControlList = {
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

ENCOUNTERS.Vehicles1 = function(spawn)
	local encData = {
		name = "LeftArea4",
		sgroups = {sg_encounter_vehicles1, sg_enemies_all},
		spawn = {spawn},
		units = {
			-- normal
			{
				sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 3},
			},
			{
				sbp = SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() <= 2},
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

ENCOUNTERS.Vehicles2 = function(spawn)
	local encData = {
		name = "LeftArea4",
		sgroups = {sg_encounter_vehicles2, sg_enemies_all},
		spawn = {spawn},
		units = {
			-- normal
			{
				sbp =  SBP.GERMAN.STUG_III_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() <= 2 and g_difficulty ~= GD_HARD},
			},
			-- hard
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 3 or g_difficulty == GD_HARD},
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

-- tank hanging out by encounter right7 area 
ENCOUNTERS.Vehicles3 = function()
	local encData = {
		name = "LeftArea4",
		sgroups = {sg_encounter_vehicles3, sg_enemies_all},
		spawn = {mkr_vehicle_spawn_03},
		triggerGoalOnEngage = true,
		units = {
			-- normal
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 3},
			},
			-- easier
			{
				sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() <= 2},
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_right_vehicles_area,
			range = 40,
			leashRange = 50,
			tacticControlList = {
				{tacticType = TACTIC_Vehicle, priority = 200},
			},
		},
		
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

-- tank guarding entrance to hq1 encounter
ENCOUNTERS.Vehicles4 = function()
	local encData = {
		name = "LeftArea4",
		sgroups = {sg_encounter_vehicles4, sg_enemies_all},
		spawn = {mkr_vehicle_spawn_04},
		triggerGoalOnEngage = true,
		units = {
			-- normal
			{
				sbp = SBP.WEST_GERMAN.JAGDPANZER_TANK_DESTROYER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() <= 4 and g_difficulty ~= GD_HARD},
			},
			{
				sbp = SBP.WEST_GERMAN.JAGDTIGER_TD_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 5 or g_difficulty == GD_HARD},
			},
		},
		goal = {
			name = "Defend",
			target = mkr_vehicle_spawn_04,
			range = 35,
			leashRange = 12,
			tacticControlList = {
				{tacticType = TACTIC_Vehicle, priority = 200},
			},
		},
		
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

ENCOUNTERS.LeftArea6 = function()
	local encData = {
		name = "LeftArea6",
		sgroups = {sg_encounter_left6, sg_enemies_all},
		spawn = {mkr_enc_left6_spawn1, mkr_enc_left6_spawn2},
		intent = ENC_INTENT.basicInfantry,
		goal = {
			name = "Defend",
			target = mkr_enc_left6_area,
			range = 35,
			leashRange = 45,
			tacticControlList = {},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end


ENCOUNTERS.LeftArea7 = function()
	local encData = {
		name = "LeftArea7",
		sgroups = {sg_enc_left7, sg_enemies_all},
		spawn = {mkr_enc_left7_spawn1, mkr_enc_left7_spawn2, mkr_enc_left7_spawn3},
		units = {
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 4},
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() <= 3},
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {g_difficulty ~= GD_HARD},
			},
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				conditions = {g_difficulty == GD_HARD},
			},
			{
				sbp = SBP.WEST_GERMAN.RAKETENWERFER43_88MM_PUPPCHEN_ANTITANK_GUN_SQUAD_MP,
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_left7_area,
			range = 30,
			leashRange = 45,
			tacticControlList = {
			},
		},
		coordinatedSetupFacingPositions = {mkr_enc_left7_facing},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end


ENCOUNTERS.LeftArea8 = function()
	local encData = {
		name = "LeftArea8",
		sgroups = {sg_encounter_left8, sg_enemies_all},
		spawn = {mkr_enc_left8_spawn1, mkr_enc_left8_spawn2},
		units = {
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 4},
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() <= 3},
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_left8_area,
			range = 35,
			leashRange = 45,
			tacticControlList = {
			},
		},
		coordinatedSetupFacingPositions = {mkr_enc_left7_facing},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end


-- Middle Encounters ------------------------------------------------------------------------------

ENCOUNTERS.MidArea1 = function()
	local encData = {
		name = "MidArea1",
		sgroups = {sg_encounter_mid1, sg_enemies_all},
		spawn = {mkr_enc_mid1_spawn1, mkr_enc_mid1_spawn2},
		units = {
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() <= 3},
			},
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 4},
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_mid1_area,
			range = 20,
			leashRange = 30,
			tacticControlList = {},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end


ENCOUNTERS.MidArea2 = function()
	local encData = {
		name = "MidArea2",
		sgroups = {sg_encounter_mid2, sg_enemies_all},
		spawn = {mkr_enc_mid2_spawn1, mkr_enc_mid2_spawn2},
		units = {
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_mid2_area,
			range = 30,
			leashRange = 40,
			tacticControlList = {},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end


ENCOUNTERS.MidArea3 = function()
	local encData = {
		name = "MidArea3",
		sgroups = {sg_encounter_mid3, sg_enemies_all},
		spawn = {mkr_enc_mid3_spawn1, mkr_enc_mid3_spawn2},
		units = {
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() > 3},
			},
			
		},
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_enc_mid3_area,
			range = 30,
			leashRange = 40,
			tacticControlList = {},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

ENCOUNTERS.MidArea4 = function()
	local encData = {
		name = "MidArea4",
		sgroups = {sg_encounter_mid4, sg_enemies_all},
		spawn = {mkr_enc_mid4_spawn1, mkr_enc_mid4_spawn2},
		units = {
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				upgrades = {UPG.WEST_GERMAN.ASSAULT_PIONEER_COMBAT_UPGRADE},
				conditions = {XP1_GetNodeStrength() >= 3 or g_difficulty == GD_HARD},
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 4},
			},
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() <= 3},
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_mid4_area,
			range = 25,
			leashRange = 35,
			garrisonidle = true,
			garrison = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 800, maxUsers = 1},
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end



-- Right side Encounters ------------------------------------------------------------------------------

-- graveyard encounter
ENCOUNTERS.RightArea2 = function()
	-- By the church on the right
	local encData = {
		name = "RightArea2",
		sgroups = {sg_encounter_right2, sg_enemies_all},
		units = {
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				spawn = mkr_enc_right2_spawn1,
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = mkr_enc_right2_spawn2,
				conditions = {XP1_GetNodeStrength() >= 4},
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_right2_area,
			range = 35,
			leashRange = 45,
			tacticControlList = {},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

ENCOUNTERS.RightArea5 = function()
	-- The initial left-side of the road
	local encData = {
		name = "RightArea5",
		sgroups = {sg_encounter_right5, sg_enemies_all},
		spawn = {mkr_enc_right5_spawn1, mkr_enc_right5_spawn2, mkr_enc_right5_spawn3},
		units = {
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				upgrades = {UPG.WEST_GERMAN.ASSAULT_PIONEER_COMBAT_UPGRADE},
				conditions = {XP1_GetNodeStrength() >= 4},
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_right5_area,
			range = 35,
			leashRange = 45,
			tacticControlList = {},
		},
		coordinatedSetupFacingPositions = {mkr_enc_right5_facing},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

ENCOUNTERS.RightArea6 = function()
	-- The initial left-side of the road
	local encData = {
		name = "RightArea6",
		sgroups = {sg_encounter_right6, sg_enemies_all},
		spawn = {mkr_enc_right6_spawn1, mkr_enc_right6_spawn2},
		units = {
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 3},
			},
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_right6_area,
			range = 35,
			leashRange = 45,
			tacticControlList = {},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end


ENCOUNTERS.pak43 = function()
	local encData = {
		name = "EncounterPak43",
		sgroups = {sg_pak43, sg_enemies_all},
		spawn = {mkr_enemy_pak43},
		units = {
			{
				sbp = SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD_MP,
			},
		},
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_enemy_pak43,
			range = 50,
			leashRange = 10,
			tacticControlList = {
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

ENCOUNTERS.RightArea7 = function()
	-- The initial left-side of the road
	local encData = {
		name = "RightArea7",
		sgroups = {sg_encounter_right7, sg_enemies_all},
		spawn = {mkr_enc_right7_spawn1, mkr_enc_right7_spawn2},
		units = {
			{
				sbp = SBP.WEST_GERMAN.LE_IG_18_INF_SUPPORT_GUN_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_right7_area,
			range = 25,
			leashRange = 35,
			tacticControlList = {},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end


-- HQ encounters --------------------------------

ENCOUNTERS.Hq1 = function()
	-- The initial left-side of the road
	local encData = {
		name = "RightHq1",
		sgroups = {sg_encounter_right3, sg_enemies_all},
		spawn = {mkr_enc_hq1_spawn1, mkr_enc_hq1_spawn2, mkr_enc_hq1_spawn3, mkr_enc_hq1_spawn4},
		units = {
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				
			},
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				conditions = {g_difficulty ~= GD_HARD and XP1_GetNodeStrength() <= 3},
			},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				conditions = {g_difficulty == GD_HARD or  XP1_GetNodeStrength() >= 4},
			},
			{
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 3},
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_hq1_area,
			range = 30,
			leashRange = 45,
			tacticControlList = {},
		},
--~ 		coordinatedSetupFacingPositions = {mkr_enc_hq1_facing},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end


ENCOUNTERS.Hq2 = function()
	local encData = {
		name = "Hq2",
		sgroups = {sg_encounter_hq2, sg_enemies_all},
		spawn = {mkr_enc_hq2_spawn1, mkr_enc_hq2_spawn2, mkr_enc_hq2_spawn3, mkr_enc_hq2_spawn4},
		units = {
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() <= 2},
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 3},
			},
			{
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP,
				conditions = {g_difficulty ~= GD_EASY},
			},
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				conditions = {g_difficulty == GD_HARD},
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_hq2_area,
			range = 30,
			leashRange = 45,
			tacticControlList = {},
		},
		coordinatedSetupFacingPositions = {mkr_enc_hq2_facing},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

ENCOUNTERS.Hq3 = function()
	-- The initial left-side of the road
	local encData = {
		name = "Hq3",
		sgroups = {sg_encounter_hq3, sg_enemies_all},
		spawn = {mkr_enc_hq3_spawn1, mkr_enc_hq3_spawn2, mkr_enc_hq3_spawn3, mkr_enc_hq3_spawn4},
		units = {
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() <= 4},
			},
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 5 or g_difficulty == GD_HARD},
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() <= 2},
			},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 3},
			},
			{
				sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 3},
			},
			{
				sbp = SBP.WEST_GERMAN.RAKETENWERFER43_88MM_PUPPCHEN_ANTITANK_GUN_SQUAD_MP,
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_hq3_area,
			range = 25,
			leashRange = 40,
			garrisonidle = true,
			garrison = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 800, maxUsers = 1},
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end


-- Wandering Patrol encounters --------------------------------
-- these encounters patrol along paths

ENCOUNTERS.WanderingPatrol1 = function()
	local encData = {
		name = "WanderingPatrol1",
		sgroups = {sg_wandering_patrol1, sg_enemies_all},
		spawn = {mkr_enc_patrol1_spawn},
		units = {
			{
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP,
			},
			
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

ENCOUNTERS.WanderingPatrol2 = function()
	local encData = {
		name = "WanderingPatrol2",
		sgroups = {sg_wandering_patrol2, sg_enemies_all},
		spawn = {mkr_enc_patrol2_spawn},
		units = {
			{
				sbp = SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP,
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

-- encounters spawned by being spotted --------------------------------

-- weak patrol
ENCOUNTERS.PatrolWeak = function(spawnloc)
	local encData = {
		name = "PatrolWeak",
		sgroups = {sg_patrol, sg_enemies_all},
		spawn = {spawnloc},
		units = {
			-- all hq's alive
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			},
			-- at least 2 hq's alive
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {SGroup_Count(sg_enemy_hq_all) >= 3}
			},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				conditions = {SGroup_Count(sg_enemy_hq_all) < 3 and XP1_GetNodeStrength() < 5}
			},
			-- 1 hq left
			{
				sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
				conditions = {SGroup_Count(sg_enemy_hq_all) < 2 and XP1_GetNodeStrength() >= 5}
			},
		},
		onDeath = StartResetPatrol,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

-- medium strength patrol
ENCOUNTERS.PatrolMed = function(spawnloc)
	local encData = {
		name = "PatrolMed",
		sgroups = {sg_patrol, sg_enemies_all},
		spawn = {spawnloc},
		units = {
			-- normal difficulty
			-- always spawn
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				upgrades = {UPG.WEST_GERMAN.ASSAULT_PIONEER_COMBAT_UPGRADE},
				conditions = {},
			},
			-- 3 hq's left
			{
				sbp = SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP,
				conditions = { SGroup_Count(sg_enemy_hq_all) >= 3},
			},
			-- 2 hq's left
			{
				sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
				conditions = {SGroup_Count(sg_enemy_hq_all) == 2 and XP1_GetNodeStrength() >= 5},
			},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				conditions = {SGroup_Count(sg_enemy_hq_all) == 2 and XP1_GetNodeStrength() < 5},
			},
			--  1 hq left 
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
				conditions = {SGroup_Count(sg_enemy_hq_all) < 2 and XP1_GetNodeStrength() >= 5},
			},
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
				conditions = {SGroup_Count(sg_enemy_hq_all) < 2 and XP1_GetNodeStrength() >= 5},
			},
		},
		onDeath = StartResetPatrol,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

-- strong patrol
ENCOUNTERS.PatrolStrong = function(spawnloc)
	local encData = {
		name = "PatrolStrong",
		sgroups = {sg_patrol, sg_enemies_all},
		spawn = {spawnloc},
		units = {
			-- always spawn
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				upgrades = {UPG.WEST_GERMAN.ASSAULT_PIONEER_COMBAT_UPGRADE},
				conditions = {},
			},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				conditions = {},
			},
			-- normal
			-- 3 hq's left
			{
				sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
				conditions = {SGroup_Count(sg_enemy_hq_all) >= 3},
			},
			-- hard
			-- 2 hq's left and not easy mode
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
				conditions = {SGroup_Count(sg_enemy_hq_all) == 2 and XP1_GetNodeStrength() >= 5},
			},
			-- expert or only one hq left and node strength 3 or higher
			{
				sbp = SBP.WEST_GERMAN.PANTHER_AUSF_G_SQUAD_MP,
				conditions = {SGroup_Count(sg_enemy_hq_all) < 2 and XP1_GetNodeStrength() >= 5},
				entityUpgrades = {},
			},
		},
		onDeath = StartResetPatrol,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end



ENCOUNTERS.ProtectTank = function()
	-- The initial left-side of the road
	local encData = {
		name = "ProtectTank",
		sgroups = {sg_enc_protect_tank, sg_enemies_all},
		spawn = {mkr_enc_secondary_spawn_01, mkr_enc_secondary_spawn_02},
		units = {
		-- normal
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 2}
			},
			{
				sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 3}
			},
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() <= 2}
			},
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() <= 1}
			},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 5}
			},
		
		},
		goal = {
			name = "Defend",
			target = mkr_enc_secondary_area,
			range = 30,
			leashRange = 40,
			tacticControlList = {},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end



ENCOUNTERS.ProtectVIP = function()
	-- The initial left-side of the road
	local encData = {
		name = "ProtectVIP",
		sgroups = {sg_enc_protect_vip, sg_enemies_all},
		spawn = {mkr_enc_secondary_spawn_01, mkr_enc_secondary_spawn_02},
		units = {
			-- normal
			{
				sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 3}
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			},
			-- hard
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 5}
			},
			{
				sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 4}
			},
			-- easy
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() < 3}
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_secondary_area,
			range = 30,
			leashRange = 40,
			tacticControlList = {},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

GOALS = {}

-- A goal that will be assigned to multiple encounters throughout the course of a single mission
