print("\tLoading encdata file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Houffalize - Encounters data
-- Designer: B.Chow
-------------------------------------------------------------------------
-------------------------------------------------------------------------
ENCOUNTERS = {}

-- Left-side Encounters
-- First Encounter
ENCOUNTERS.startLeftArea1 = function()
	-- The initial left-side of the road
	local encData = {
		name = "Encounter1",
		sgroups = {sg_encounter1, sg_enemies_all},
		spawn = {mkr_enc_left1_01, mkr_enc_left1_02, mkr_enc_left1_03},
		units = {
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 3 },
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_left1_02,
			range = 15,
			leashRange = 20,
			tacticControlList = {},
			coordinatedSetupFacingPositions = {mkr_enc_left1_facing},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

-- Second Encounter
ENCOUNTERS.startLeftArea2 = function()
	-- Farther down the left-side of the road
	local encData = {
		name = "EncounterLeft2",
		sgroups = {sg_encounter2, sg_enemies_all},
		spawn = {mkr_enc_left2_01, mkr_enc_left2_02},
		units = {
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() <= 4},
			},
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 5},
			},
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc2_01,
			range = 30,
			leashRange = 30,
			tacticControlList = {
			},
--~ 			coordinatedSetupFacingPositions = {mkr_enc_left2_facing},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end



ENCOUNTERS.leftArea3 = function()
	local encData = {
		name = "Encounter5",
		sgroups = {sg_encounter5, sg_enemies_all},
		spawn = {mkr_enc_left3_01, mkr_enc_left3_02},
		units = {
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() == 3},
			},
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, 
				conditions = {XP1_GetNodeStrength() >= 4},
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc5_01,
			range = 30,
			leashRange = 30,
			tacticControlList = {
			},
--~ 			coordinatedSetupFacingPositions = {mkr_enc_left3_facing},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

-- garrison MG inside a building
ENCOUNTERS.leftArea3b = function()
	-- Farther down the left-side of the road
	local encData = {
		name = "EncounterLeft3",
		sgroups = {sg_encounter5, sg_enemies_all},
		spawn = {eg_building_left3},
		units = {
			-- normal
			{
				name = "garrison",
				sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 3}
			},
			-- easy
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() <= 2 }
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_left3b_01,
			range = 30,
			leashRange = 30,
			garrisonidle = true,
			garrison = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 800, maxUsers = 1},
			},
--~ 			coordinatedSetupFacingPositions = {mkr_enc_left3_facing},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end



-- Right-side Encounters --------------------------------------------------------------------------
ENCOUNTERS.rightArea1 = function()
	-- The initial right-side road
	local encData = {
		name = "Encounter3",
		sgroups = {sg_encounter3, sg_enemies_all},
		spawn = {mkr_enc_right1_01, mkr_enc_right1_02},
		units = {
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_right1_01,
			range = 15,
			leashRange = 20,
			tacticControlList = {
			},
			coordinatedSetupFacingPositions = {mkr_enc_right1_facing},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end


ENCOUNTERS.rightArea2 = function()
	local encData = {
		name = "Encounter4",
		sgroups = {sg_encounter4, sg_enemies_all},
		spawn = {mkr_enc_right2_01, mkr_enc_right2_02, mkr_enc_right2_03},
		garrisonidle = true,
		garrison = true,
		units = {
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_right2_02,
			range = 20,
			leashRange = 20,
			tacticControlList = {
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

-- garrison soldiers inside a building
ENCOUNTERS.rightArea2b = function()
	local encData = {
		name = "EncounterRight2b",
		sgroups = {sg_encounter4, sg_enemies_all},
		spawn = {mkr_enc_right2b_01},
		units = {
			{
				name = "garrison",
				sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 3}
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_right2b_01,
			range = 10,
			leashRange = 10,
			garrisonidle = true,
			garrison = true,
			tacticControlList = {
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end


ENCOUNTERS.rightArea3 = function()
	local encData = {
		name = "EncounterRight3",
		sgroups = {sg_encounter6, sg_enemies_all},
		spawn = {mkr_enc_right3_01, mkr_enc_right3_02},
		
		goal = {
			name = "Defend",
			target = mkr_enc_right3_01,
			range = 15,
			leashRange = 30,
			tacticControlList = {
			},
		},
		units = {
			-- normal
			{
				sbp = SBP.WEST_GERMAN.MORTAR_250_HALFTRACK_SQUAD_WESTGERMAN_MP,
				conditions = {XP1_GetNodeStrength() >= 3 and g_difficulty ~= GD_EASY},
			},
			-- hard
			{
				sbp = SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 4 and g_difficulty == GD_HARD},
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end


ENCOUNTERS.rightArea3Infantry = function()
	local encData = {
		name = "EncounterRight3b",
		sgroups = {sg_encounter4, sg_enemies_all},
		spawn = {mkr_enc_right3b_01, mkr_enc_right3b_02},
		units = {
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 4},
			},
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() <= 3},
			},
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 3 and g_difficulty ~= GD_EASY},
			},
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() <= 2},
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_right3b_01,
			range = 25,
			leashRange = 30,
			tacticControlList = {
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return

	return enc_newEncounter
end

-- Encounters inside the alleyways  ---------------------------------------------------------------------
ENCOUNTERS.encounter7 = function()
	local encData = {
		name = "Encounter7",
		sgroups = {sg_encounter7, sg_enemies_all},
		spawn = {mkr_enc7_01, mkr_enc7_02},
		units = {
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				upgrades = {UPG.WEST_GERMAN.ASSAULT_PIONEER_COMBAT_UPGRADE},
			},
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 3},
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc7_01,
			range = 10,
			leashRange = 20,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

ENCOUNTERS.encounter8 = function()
	local encData = {
		name = "Encounter8",
		sgroups = {sg_encounter8, sg_enemies_all, sg_final_enemies},
		spawn = {mkr_enc8_01, mkr_enc8_02},
		units = {
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 4},
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc8_01,
			range = 10,
			leashRange = 20,
			tacticControlList = {
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end


-- Final road encounters --------------------------------------------------------------------------------------------


ENCOUNTERS.encounterMortars = function()
	local encData = {
		name = "EncounterMortars",
		sgroups = {sg_encounter_mortars, sg_enemies_all},
		spawn = {mkr_enc_mortars_01, mkr_enc_mortars_02},
		units = {
			{
				sbp = SBP.WEST_GERMAN.LE_IG_18_INF_SUPPORT_GUN_SQUAD_MP,
				conditions = {g_difficulty ~= GD_EASY and XP1_GetNodeStrength() >= 3},
			},
			{
				sbp = SBP.WEST_GERMAN.LE_IG_18_INF_SUPPORT_GUN_SQUAD_MP,
				conditions = {g_difficulty == GD_EXPERT or XP1_GetNodeStrength() >= 5},
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_mortars_01,
			range = 30,
			leashRange = 10,
			tacticControlList = {
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

-- encounter by the victory point
ENCOUNTERS.encounter10 = function()
	local encData = {
		name = "Encounter10",
		sgroups = {sg_encounter10, sg_enemies_all, sg_enemies_final},
		spawn = {mkr_enc10_01, mkr_enc10_02, mkr_enc10_03, mkr_enc10_04},
		units = {
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() <= 2},
			},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 3},
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 4},
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enemy_pak34,
			range = 30,
			leashRange = 40,
			tacticControlList = {
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

-- garrison soldiers inside a building
ENCOUNTERS.centerBuildings = function()
	-- Farther down the left-side of the road
	local encData = {
		name = "EncounterCenterBuildings",
		sgroups = {sg_encounter5, sg_enemies_all, sg_enemies_final},
		spawn = {mkr_enc_center_buildings_01, mkr_enc_center_buildings_02},
		units = {
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {g_difficulty ~= GD_HARD},
			},
			{
				sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
				conditions = {g_difficulty == GD_HARD},
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_center_buildings_03,
			range = 25,
			leashRange = 30,
			garrisonidle = true,
			garrison = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 800, maxUsers = 2},
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter
end


ENCOUNTERS.encounterFinal = function()
	local encData = {
		name = "EncounterFinal",
		sgroups = {sg_encounter11, sg_enemies_all, sg_enemies_final},
		spawn = {mkr_enc_final_01, mkr_enc_final_02, mkr_enc_final_03, mkr_enc_final_04, mkr_enc_final_05},
		units = {
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() <= 2}
			},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 4}
			},
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 3}
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_final_01,
			range = 15,
			leashRange = 25,
			tacticControlList = {
			},
			coordinatedSetupFacingPositions = {mkr_enc_final_facing},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

ENCOUNTERS.pak43 = function()
	local encData = {
		name = "EncounterPak43",
		sgroups = {sg_pak43, sg_enemies_all, sg_enemies_final},
		spawn = {mkr_enemy_pak43},
		units = {
			{
				sbp = SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 3},
			},
			{
				sbp =  SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() <= 2},
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

-- final wave of enemies that spawns when the final objective starts
ENCOUNTERS.encounterLastDefense = function()
	local encData = {
		name = "LastDefense",
		sgroups = {sg_enemies_all, sg_enemies_final},
		spawn = {mkr_enemy_wave_spawn},
		units = {
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				conditions = {g_difficulty == GD_HARD or XP1_GetNodeStrength() >= 3},
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() <= 2 or g_difficulty == GD_EASY},
			},
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				conditions= {g_difficulty ~= GD_EASY},
			},
			{
				sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
				conditions = {g_difficulty ~= GD_HARD and (XP1_GetNodeStrength() >= 3 and XP1_GetNodeStrength() <= 4)},
			},
			{
				sbp = SBP.WEST_GERMAN.JAGDPANZER_TANK_DESTROYER_SQUAD_MP,
			},
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
				conditions = {g_difficulty == GD_HARD or XP1_GetNodeStrength() >= 5},
				upgrades = (g_difficulty == GD_HARD and UPG.GERMAN.PANZER_TOP_GUNNER_MP or nil),
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_final_defense_area,
			range = 40,
			leashRange = 30,
			tacticControlList = {
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end


ENCOUNTERS.encounterMedArmour = function()
	local encData = {
		name = "EncounterMedArmour",
		sgroups = {sg_enemy_tanks, sg_enemies_all, sg_enemies_final},
		units = {
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
				spawn = mkr_enc_med_armour_01,
				conditions = {XP1_GetNodeStrength() >= 4},
				upgrades = (g_difficulty == GD_HARD and UPG.GERMAN.PANZER_TOP_GUNNER_MP or nil),
			},
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
				spawn = mkr_enc_med_armour_02,
				upgrades = (g_difficulty == GD_HARD and UPG.GERMAN.PANZER_TOP_GUNNER_MP or nil),
			},
		},
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_enc_med_armour_01,
			range = 30,
			leashRange = 30,
			retaliateAttacks = true,
			tacticControlList = {
				{tacticType = TACTIC_Vehicle, priority = 200},
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	
	return enc_newEncounter
end

ENCOUNTERS.RespawnTanks = function()
	local encData = {
		name = "EncounterMedArmour",
		sgroups = {sg_enemy_tanks, sg_enemies_all, sg_enemies_final},
		units = {
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
				spawn = mkr_enemy_wave_spawn,
				upgrades = (g_difficulty == GD_HARD and UPG.GERMAN.PANZER_TOP_GUNNER_MP or nil),
			},
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
				spawn = mkr_enemy_wave_spawn,
				conditions = {XP1_GetNodeStrength() >= 4},
				upgrades = (g_difficulty == GD_HARD and UPG.GERMAN.PANZER_TOP_GUNNER_MP or nil),
			},
		},
		goal = {
			name = "Defend",
			target = mkr_tank_defend_area,
			range = 35,
			leashRange = 50,
			tacticControlList = {
				{tacticType = TACTIC_Vehicle, priority = 200},
			},
		}
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	
	return enc_newEncounter
end

-- ************************************************************
-- Secondary Objective Encounters
-- ************************************************************


ENCOUNTERS.ProtectVIP = function()
	local encData = {
		name = "encounterProtectVIP",
		sgroups = {sg_protect},
		spawn = {mkr_secondary_spawn2, mkr_secondary_spawn3},
		intent = ENC_INTENT.lightArmour,
		goal = {
			name = "Defend",
			target = mkr_secondary_spawn1,
			range = 10,
			leashRange = 30,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	
	return enc_newEncounter
end

ENCOUNTERS.Demolition = function()
	local encData = {
		name = "encounterDemolition",
		sgroups = {sg_protect},
		spawn = {mkr_secondary2_spawn1, mkr_secondary2_spawn2, mkr_secondary2_spawn3},
		intent = ENC_INTENT.medAntiInfantryDefense,
		goal = {
			name = "Defend",
			target = mkr_secondary2_spawn1,
			range = 10,
			leashRange = 30,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	
	return enc_newEncounter
end

ENCOUNTERS.rescue = function()
	local encData = {
		name = "encounterRescue",
		sgroups = {sg_rescue_enemies},
		spawn = {mkr_secondary_spawn2, mkr_secondary_spawn3},
		units = {
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 4},
			},
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() <= 3},
			},
		},
		goal = {
			name = "Defend",
			target = mkr_secondary_spawn1,
			range = 20,
			leashRange = 20,
			tacticControlList = {
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

ENCOUNTERS.ProtectTank = function()
	local encData = {
		name = "encounterProtectTank",
		sgroups = {sg_protect},
		spawn = {mkr_secondary_spawn2, mkr_secondary_spawn3},
		units = {
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 4},
			},
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
			},
		},
		goal = {
			name = "Defend",
			target = mkr_secondary_spawn1,
			range = 20,
			leashRange = 30,
			tacticControlList = {
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

-- ************************************************************


ENCOUNTERS.LeftHill = function()
	local encData = {
		name = "encounterLeftHill",
		sgroups = {sg_left_hill_enemies},
		spawn = {mkr_enc_left_hill_01, mkr_enc_left_hill_02},
		units = {
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 3 and g_difficulty ~= GD_HARD},
			},
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 3 or g_difficulty == GD_HARD},
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_left_hill_area,
			range = 25,
			leashRange = 35,
			tacticControlList = {
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end


ENCOUNTERS.LeftHillMG = function()
	local encData = {
		name = "encounterLeftHill",
		sgroups = {sg_left_hill_enemies},
		spawn = {mkr_enc_left_hill_mg},
		units = {
			{
				sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enc_left_hill_mg,
			range = 10,
			leashRange = 10,
			tacticControlList = {},
			coordinatedSetupFacingPositions = {mkr_enc_left_hill_01},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

-- ************************************************************
-- Light Armour Counterattack
-- ************************************************************



ENCOUNTERS.counterattack = function()
	local encData = {
		name = "counterattack",
		sgroups = {sg_enemies_all, sg_enemy_counterattack},
		spawn = {mkr_enemy_wave_spawn},
		units = {
			-- always
			{
				sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
			},
			-- low difficulty
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				conditions = {g_difficulty == GD_EASY}
			},
			{
				sbp = SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP,
				conditions = {g_difficulty == GD_EASY}
			},
			-- medium difficulty
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {g_difficulty == GD_NORMAL}
			},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				conditions = {g_difficulty == GD_NORMAL}
			},
			{
				sbp = SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP,
				conditions = {g_difficulty == GD_NORMAL}
			},
			-- hard
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				conditions = {g_difficulty == GD_HARD}
			},
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				conditions = {g_difficulty == GD_HARD}
			},
			{
				sbp = SBP.WEST_GERMAN.OSTWIND_SQUAD_WESTGERMAN_MP,
				conditions = {g_difficulty == GD_HARD}
			},
		},
		goal = {
			name = "Attack",
			target = mkr_enemy_artillery_01,
			range = 30,
			leashRange = 40,
			tacticControlList = {
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end


GOALS = {}

-- A goal that will be assigned to multiple encounters throughout the course of a single mission
