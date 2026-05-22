print("\tLoading encdata file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Elsenborn Ridge - Encounters data
-- Designer: Ryan McGechaen
-------------------------------------------------------------------------
-------------------------------------------------------------------------
ENCOUNTERS = {}

ENCOUNTERS.Wave01 = function()
    local waveData = {		
		encounters = {
			{
				units = {
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
				},
				weight = 7,
			},
			{
				units = {
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
				},
				weight = 9,
			},
			{
				units = {
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
				},
				weight = 6,
			},
			{
				units = {
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
					{
						sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() >= 5 or g_difficulty == GD_HARD},
					},
				},
				weight = 5,
			},
			{
				units = {
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
				},
				weight = 8,
			},
			{
				units = {
					{sbp = SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP},
				},
				weight = 3,
			},
		},
		randomizeData = {
			randomEncounters = 3,
			exclusive = true,
			uniqueSpawns = true,
		},
		waveCompleteConditionData = {
			condition = CONDITION_TIMER_ENDED,
			variable = 170,
			wave_retreats = false,
			vehicles = 0,
		},
		spawnerData = {
			initialDelay = 30,
			spawnDelay = 20,
		},
		sustainedAttackData = {
			newSpawnThreshold = Util_DifVar({0, 0, 1}, g_difficulty),
			newSpawnWait = 55,
			maxEncounters = 3,
		},
    }
    return waveData
end

ENCOUNTERS.Wave02 = function()
    local waveData = {
		encounters = {
			{
				units = {
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
				},
				weight = 7,
			},
			{
				units = {
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
				},
				weight = 9,
			},
			{
				units = {
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
					{
						sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
						conditions = {g_difficulty ~= GD_EASY},
					},
				},
				weight = 6,
			},
			{
				units = {
					{sbp = SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP},
				},
				weight = 5,
			},
			{
				units = {
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
				},
				weight = 8,
			},
			{
				units = {
					{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP},
					{
						sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
						conditions = {g_difficulty ~= GD_EASY},
					},
				},
				weight = 3,
				rare = true,
			},
		},
		randomizeData = {
			randomEncounters = 2,
			exclusive = true,
			uniqueSpawns = true,
		},
		waveCompleteConditionData = {
			condition = CONDITION_TIMER_ENDED,
			variable = 180,
			wave_retreats = false,
			vehicles = 0,
		},
		spawnerData = {
			initialDelay = 60,
			spawnDelay = 20,
		},
		sustainedAttackData = {
			newSpawnThreshold = Util_DifVar({0, 1, 2}, g_difficulty),
			newSpawnWait = 55,
			maxEncounters = 3,
		},
    }
    return waveData
end

ENCOUNTERS.Wave03 = function()
    local waveData = {
		encounters = {
			{
				units = {
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
					{
						sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
						conditions = {g_difficulty ~= GD_EASY},
					},
				},
				weight = 7,
			},
			{
				units = {
					{
						sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
					},
				},
				weight = 9,
			},
			{
				units = {
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
				},
				weight = 6,
			},
			{
				units = {
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
				},
				weight = 7,
			},
			{
				units = {
					{
						sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() >= 4 or g_difficulty == GD_HARD},
					},
					{
						sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() <= 3 or g_difficulty == GD_HARD},
					},
				},
				weight = 4,
			},
			{
				units = {
					{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP},
				},
				weight = 2,
			},
			{
				units = {
					{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP},
				},
				weight = 2,
			},
			{
				units = {
					{
						sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
						conditions = {g_difficulty ~= GD_HARD},
					},
					{
						sbp = SBP.GERMAN.STUG_III_SQUAD_MP,
						conditions = {g_difficulty == GD_HARD},
						sgroups = {sg_tankhints_targets},
					},
				},
				weight = 2,
				rare = true,
			},
		},
		randomizeData = {
			randomEncounters = 3,
			exclusive = true,
			uniqueSpawns = true,
		},
		waveCompleteConditionData = {
			condition = CONDITION_TIMER_ENDED,
			variable = 190,
			wave_retreats = false,
			vehicles = 0,
		},
		spawnerData = {
			initialDelay = 60,
			spawnDelay = 20,
		},
		sustainedAttackData = {
			newSpawnThreshold = Util_DifVar({1, 1, 2}, g_difficulty),
			newSpawnWait = 55,
			maxEncounters = 3,
		},
		callbackData = {
			preSpawn = Mission_SmokeScreen,
			preSpawn_delay = 15,
			onComplete = QueueNextWave,
		},
    }
    return waveData
end

ENCOUNTERS.Wave04 = function()
    local waveData = {
		encounters = {
			{
				units = {
					{
						sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, 
						conditions = {g_difficulty ~= GD_EASY},
					},
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
				},
				weight = 7,
			},
			{
				units = {
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
				},
				weight = 9,
			},
			{
				units = {
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
				},
				weight = 6,
			},
			{
				units = {
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
				},
				weight = 7,
			},
			{
				units = {
					{
						sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() >= 4 or g_difficulty == GD_HARD},
					},
					{
						sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() <= 3 or g_difficulty == GD_HARD},
					},
				},
				weight = 5,
			},
			{
				units = {
					{
						sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() >= 4 or g_difficulty == GD_HARD},
					},
					{
						sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() <= 3 or g_difficulty == GD_HARD},
					},
				},
				weight = 5,
			},
			{
				units = {
					{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP},
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
				},
				weight = 3,
			},
			{
				units = {
					{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP},
				},
				weight = 2,
			},
			{
				units = {
					{
						sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP,
						conditions = {g_difficulty ~= GD_HARD},
					},
					{
						sbp = SBP.WEST_GERMAN.STURMTIGER_SQUAD_MP,
						conditions = {g_difficulty == GD_HARD},
						sgroups = {sg_tankhints_targets},
					},
				},
				weight = 1,
				rare = true,
			},
		},
		randomizeData = {
			randomEncounters = 3,
			exclusive = true,
			uniqueSpawns = true,
		},
		waveCompleteConditionData = {
			condition = CONDITION_TIMER_ENDED,
			variable = 230,
			wave_retreats = false,
			vehicles = 0,
		},
		spawnerData = {
			initialDelay = 60,
			spawnDelay = 20,
		},
		sustainedAttackData = {
			newSpawnThreshold = Util_DifVar({1, 1, 2}, g_difficulty),
			newSpawnWait = 55,
			maxEncounters = 3,
		},
    }
    return waveData
end

ENCOUNTERS.Wave05 = function()
    local waveData = {
		encounters = {
			{
				units = {
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
				},
				weight = 7,
			},
			{
				units = {
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
					{
						sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
						conditions = {g_difficulty == GD_HARD},
					},
				},
				weight = 9,
			},
			{
				units = {
					{
						sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() >= 4 or g_difficulty == GD_HARD},
					},
					{
						sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() <= 3 or g_difficulty == GD_HARD},
					},
				},
				weight = 5,
			},
			{
				units = {
					{
						sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() >= 4 or g_difficulty == GD_HARD},
					},
					{
						sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() <= 3 or g_difficulty == GD_HARD},
					},
				},
				weight = 5,
			},
			{
				units = {
					{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP},
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
				},
				weight = 3,
			},
			{
				units = {
					{
						sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP,
						conditions = {g_difficulty ~= GD_HARD},
					},
					{
						sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
						conditions = {g_difficulty == GD_HARD},
						sgroups = {sg_tankhints_targets},
					},
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
				},
				weight = 3,
			},
			{
				units = {
					{
						sbp = SBP.GERMAN.STUG_III_SQUAD_MP,
						conditions = {g_difficulty ~= GD_HARD},
						sgroups = {sg_tankhints_targets},
					},
					{
						sbp = SBP.GERMAN.BRUMMBAR_SQUAD_MP,
						conditions = {g_difficulty == GD_HARD},
						sgroups = {sg_tankhints_targets},
					},
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
				},
				weight = 2,
				rare = true,
			},
			{
				units = {
					{
						sbp = SBP.GERMAN.STUG_III_SQUAD_MP,
						conditions = {g_difficulty ~= GD_HARD},
						sgroups = {sg_tankhints_targets},
					},
					{
						sbp = SBP.GERMAN.BRUMMBAR_SQUAD_MP,
						conditions = {g_difficulty == GD_HARD},
						sgroups = {sg_tankhints_targets},
					},
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
				},
				weight = 2,
				rare = true,
			},
		},
		randomizeData = {
			randomEncounters = 4,
			exclusive = true,
			uniqueSpawns = true,
		},
		waveCompleteConditionData = {
			condition = CONDITION_INFINITE_DURATION,
			variable = 180,
			wave_retreats = false,
			vehicles = 0,
		},
		spawnerData = {
			initialDelay = 60,
			spawnDelay = 15,
		},
		sustainedAttackData = {
			newSpawnThreshold = Util_DifVar({1, 1, 2}, g_difficulty),
			newSpawnWait = 55,
			maxEncounters = 3,
		},
		callbackData = {
			preSpawn = Mission_SmokeScreen,
			preSpawn_delay = 15,
			onComplete = QueueNextWave,
		},
    }
    return waveData
end

---------------------------------------------------
-- Secure the Flank Encounters
ENCOUNTERS.CaptureTheCheckpoint_smlForest = function()
    local encData = {
		name = "",
		spawn = {
			Util_GetRandomPosition(mkr_checkpoint_e_smlForest),
			Util_GetRandomPosition(mkr_checkpoint_e_smlForest),
			Util_GetRandomPosition(mkr_checkpoint_e_smlForest),
			Util_GetRandomPosition(mkr_checkpoint_e_smlForest),
		},
		intent = ENC_INTENT.basicInfantry,
		
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_checkpoint_e_smlForest,
			leashRange = mkr_checkpoint_e_smlForest,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {
				Util_GetOffsetPosition(mkr_checkpoint_e_smlForest, OFFSET_FRONT, 90),
			},
			maxIdleTime = -1,
			retaliateAttacks = true,
			fallbackParams = {
				thresholds = {0.25},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_checkpoint_e_medDefense},
				retreat = true,
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end

ENCOUNTERS.CaptureTheCheckpoint_medForest = function()
    local encData = {
		name = "",
		spawn = {
			Util_GetRandomPosition(mkr_checkpoint_e_medForest),
			Util_GetRandomPosition(mkr_checkpoint_e_medForest),
			Util_GetRandomPosition(mkr_checkpoint_e_medForest),
			Util_GetRandomPosition(mkr_checkpoint_e_medForest),
		},
		intent = ENC_INTENT.basicInfantry,
		
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_checkpoint_e_medForest,
			leashRange = mkr_checkpoint_e_medForest,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {
				Util_GetOffsetPosition(mkr_checkpoint_e_medForest, OFFSET_FRONT, 90),
			},
			maxIdleTime = -1,
			retaliateAttacks = true,
			fallbackParams = {
				thresholds = {0.15},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_checkpoint_e_medDefense},
				retreat = true,
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end



ENCOUNTERS.CaptureTheCheckpoint_road = function()
    local encData = {
		name = "",
		spawn = {
			Util_GetRandomPosition(mkr_checkpoint_e_road),
			Util_GetRandomPosition(mkr_checkpoint_e_road),
			Util_GetRandomPosition(mkr_checkpoint_e_road),
			Util_GetRandomPosition(mkr_checkpoint_e_road),
		},
		intent = ENC_INTENT.basicHMG,
		
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_checkpoint_e_road,
			leashRange = mkr_checkpoint_e_road,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {
				Util_GetOffsetPosition(mkr_checkpoint_e_road, OFFSET_FRONT, 90),
			},
			maxIdleTime = -1,
			retaliateAttacks = true,
			fallbackParams = {
				thresholds = {0.15},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_checkpoint_e_medDefense},
				retreat = true,
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end

ENCOUNTERS.CaptureTheCheckpoint_medDefense = function()
    local encData = {
		name = "",
		spawn = {
			Util_GetRandomPosition(mkr_checkpoint_e_medDefense),
			Util_GetRandomPosition(mkr_checkpoint_e_medDefense),
			Util_GetRandomPosition(mkr_checkpoint_e_medDefense),
			Util_GetRandomPosition(mkr_checkpoint_e_medDefense),
		},
		intent = ENC_INTENT.basicInfantry,
		
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_checkpoint_e_medDefense,
			leashRange = mkr_checkpoint_e_medDefense,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {
				Util_GetOffsetPosition(mkr_checkpoint_e_medDefense, OFFSET_FRONT, 90),
			},
			maxIdleTime = -1,
			retaliateAttacks = true,
--~ 			fallbackParams = {
--~ 				thresholds = {0.20},
--~ 				thresholdType = Threshold_PercentageEntitiesRemaining,
--~ 				markers = {mkr_e_retreat_05},
--~ 				retreat = true,
--~ 			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end


ENCOUNTERS.Final_Tank_01 = function()
    local encData = {
		name = "FinalTank01",
		spawn = mkr_spawn_01,
		player = player2,
		sgroups = {sg_final_tank_01},
		units = {
			{
				sbp = SBP.GERMAN.BRUMMBAR_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			},
		},
		
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_final_group_01,
			leashRange = 10,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {},
			maxIdleTime = -1,
			retaliateAttacks = false,
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	Modify_WeaponAccuracy(sg_final_tank_01, "hardpoint_01", 0.25)
	Modify_WeaponDamage(sg_final_tank_01, "hardpoint_01", 0.15)
	g_damage_mod_id1 = Modify_ReceivedDamage(sg_final_tank_01, 0.5, true)
	return enc_newEncounter
end

ENCOUNTERS.Final_Tank_02 = function()
    local encData = {
		name = "FinalTank02",
		spawn = mkr_spawn_02,
		player = player2,
		sgroups = {sg_final_tank_02},
		units = {
			{
				sbp = SBP.GERMAN.BRUMMBAR_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			},
		},
		
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_final_group_02,
			leashRange = 10,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {},
			maxIdleTime = -1,
			retaliateAttacks = false,
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	Modify_WeaponAccuracy(sg_final_tank_02, "hardpoint_01", 0.25)
	Modify_WeaponDamage(sg_final_tank_02, "hardpoint_01", 0.15)
	g_damage_mod_id2 = Modify_ReceivedDamage(sg_final_tank_02, 0.5, true)
	return enc_newEncounter
end



ENCOUNTERS.Allied_Reinforcements_01 = function()
    local encData = {
		name = "",
		spawn = mkr_a_truck_spawn,
		player = player3,
		sgroups = {sg_a_rein_01},
		units = {
			{
				sbp = SBP.AEF.REAR_ECHELON_SQUAD_MP,
				slotItems = {SLOT_ITEM.BAZOOKA_MP},
			},
			{
				sbp = SBP.AEF.RIFLEMEN_SQUAD_MP,
				slotItems = {SLOT_ITEM.RIFLEMEN_M1918_BAR_MP},
			},
		},
		
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_left_VP,
			leashRange = 30,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {
				Util_GetOffsetPosition(mkr_left_VP, OFFSET_FRONT, 90),
			},
			maxIdleTime = -1,
			retaliateAttacks = false,
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	enc_newEncounter:Disable()
	
	return enc_newEncounter
end

ENCOUNTERS.Allied_Reinforcements_02 = function()
    local encData = {
		name = "",
		spawn = mkr_a_truck_spawn,
		player = player3,
		sgroups = {sg_a_rein_02},
		units = {
			{
				sbp = SBP.AEF.REAR_ECHELON_SQUAD_MP,
				slotItems = {SLOT_ITEM.BAZOOKA_MP},
			},
			{
				sbp = SBP.AEF.RIFLEMEN_SQUAD_MP,
				slotItems = {SLOT_ITEM.RIFLEMEN_M1918_BAR_MP},
			},
		},
		
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_right_VP,
			leashRange = 30,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {
				Util_GetOffsetPosition(mkr_right_VP, OFFSET_FRONT, 90),
			},
			maxIdleTime = -1,
			retaliateAttacks = false,
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	enc_newEncounter:Disable()
	
	return enc_newEncounter
end


-- TEMP
ENCOUNTERS.SecureTheFlank_left_wave = function()
    local encData = {
		name = "",
		spawn = mkr_spawn_05,
		dynamicSpawnTarget = mkr_spawn_05_dynSpawn,
		intent = ENC_INTENT.medInfantry,
		
		onDeath = _secureTheLine_Reset,
		goal = {
			name = "Attack",
			target = mkr_left_VP,
			leashRange = mkr_left_VP,
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end


ENCOUNTERS.SecObj_VIP_smlDef_01 = function()
    local encData = {
		name = "VIP_01",
		spawn = mkr_secObj_VIP_smlDef_01,
		intent = ENC_INTENT.smallAntiInfantryDefense,
		
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_secObj_VIP_smlDef_01,
			leashRange = mkr_secObj_VIP_smlDef_01,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {
				Util_GetOffsetPosition(mkr_secObj_VIP_smlDef_01, OFFSET_FRONT, 90),
			},
			maxIdleTime = -1,
			retaliateAttacks = true,
			fallbackParams = {
				thresholds = {0.25},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_e_retreat_secObj},
				retreat = true,
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end

ENCOUNTERS.SecObj_VIP_smlDef_02 = function()
    local encData = {
		name = "VIP_02",
		spawn = mkr_secObj_VIP_smlDef_02,
		intent = ENC_INTENT.smallAntiInfantryDefense,
		
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_secObj_VIP_smlDef_02,
			leashRange = mkr_secObj_VIP_smlDef_02,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {
				Util_GetOffsetPosition(mkr_secObj_VIP_smlDef_02, OFFSET_FRONT, 90),
			},
			maxIdleTime = -1,
			retaliateAttacks = true,
			fallbackParams = {
				thresholds = {0.25},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_e_retreat_secObj},
				retreat = true,
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end

ENCOUNTERS.SecObj_VIP_smlDef_03 = function()
    local encData = {
		name = "VIP_03",
		spawn = mkr_secObj_VIP_smlDef_03,
		intent = ENC_INTENT.smallAntiInfantryDefense,
		
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_secObj_VIP_smlDef_03,
			leashRange = mkr_secObj_VIP_smlDef_03,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {
				Util_GetOffsetPosition(mkr_secObj_VIP_smlDef_03, OFFSET_FRONT, 90),
			},
			maxIdleTime = -1,
			retaliateAttacks = true,
			fallbackParams = {
				thresholds = {0.25},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_e_retreat_secObj},
				retreat = true,
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end

ENCOUNTERS.SecObj_VIP_medDef_01 = function()
    local encData = {
		name = "VIP_04",
		spawn = mkr_secObj_VIP_medDef_01,
		intent = ENC_INTENT.medAntiInfantryDefense,
		
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_secObj_VIP_medDef_01,
			leashRange = mkr_secObj_VIP_medDef_01,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {
				Util_GetOffsetPosition(mkr_secObj_VIP_medDef_01, OFFSET_FRONT, 90),
				Util_GetOffsetPosition(mkr_secObj_VIP_medDef_01, OFFSET_LEFT, 90),
				Util_GetOffsetPosition(mkr_secObj_VIP_medDef_01, OFFSET_RIGHT, 90),
			},
			maxIdleTime = -1,
			retaliateAttacks = true,
			fallbackParams = {
				thresholds = {0.25},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_e_retreat_secObj},
				retreat = true,
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end

ENCOUNTERS.SecObj_demoMan_smlDef_01 = function()
    local encData = {
		name = "VIP_04",
		spawn = mkr_secObj_demolitionMan_smlDef_01,
		intent = ENC_INTENT.smallAntiInfantryDefense,
		
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_secObj_demolitionMan_smlDef_01,
			leashRange = mkr_secObj_demolitionMan_smlDef_01,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {
				Util_GetOffsetPosition(mkr_secObj_demolitionMan_smlDef_01, OFFSET_FRONT, 90),
				Util_GetOffsetPosition(mkr_secObj_demolitionMan_smlDef_01, OFFSET_LEFT, 90),
				Util_GetOffsetPosition(mkr_secObj_demolitionMan_smlDef_01, OFFSET_RIGHT, 90),
			},
			maxIdleTime = -1,
			retaliateAttacks = true,
			fallbackParams = {
				thresholds = {0.25},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_e_retreat_secObj},
				retreat = true,
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end

ENCOUNTERS.SecObj_demoMan_smlDef_02 = function()
    local encData = {
		name = "VIP_04",
		spawn = mkr_secObj_demolitionMan_smlDef_02,
		intent = ENC_INTENT.smallAntiInfantryDefense,
		
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_secObj_demolitionMan_smlDef_02,
			leashRange = mkr_secObj_demolitionMan_smlDef_02,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {
				Util_GetOffsetPosition(mkr_secObj_demolitionMan_smlDef_02, OFFSET_FRONT, 90),
				Util_GetOffsetPosition(mkr_secObj_demolitionMan_smlDef_02, OFFSET_LEFT, 90),
				Util_GetOffsetPosition(mkr_secObj_demolitionMan_smlDef_02, OFFSET_RIGHT, 90),
			},
			maxIdleTime = -1,
			retaliateAttacks = true,
			fallbackParams = {
				thresholds = {0.25},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_e_retreat_secObj},
				retreat = true,
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end

ENCOUNTERS.SecObj_destroyTank = function(spawnPos)
    local encData = {
		name = "VIP_01",
		spawn = spawnPos,
		intent = ENC_INTENT.smallAntiInfantryDefense,
		
		onDeath = nil,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end

GOALS = {}

-- A goal that will be assigned to multiple encounters throughout the course of a single mission
GOALS.myGenericGoal = function(encounter)
	local goalData = {
		name = "Defend",
		target = mkr_O1_space,
		range = 45,
		leashRange = mkr_O1_space,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 500,
			},
		},
	}
	
	encounter:SetGoal(goalData)
end
