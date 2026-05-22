print("\tLoading encdata file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Siege of Bastogne - Encounters data
-- Designer: Ryan McGechaen
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Encounters
ENCOUNTERS = {}

-- Encounter Builder
ENCOUNTERS.Build_Encounter = function(_spawnLocation, _units, _intent, _goalType, _target, _range, _leash, _threshold, _retreat)
	local spawn = _spawnLocation
	
	if scartype(_spawnLocation) == ST_TABLE then
		spawn = Table_GetRandomItem(_spawnLocation)
	end
	
	local encData = {
		name = "Road 4 Def",
		spawn = {
			Util_GetRandomPosition(spawn),
			Util_GetRandomPosition(spawn),
			Util_GetRandomPosition(spawn),
			Util_GetRandomPosition(spawn),
			Util_GetRandomPosition(spawn),
			Util_GetRandomPosition(spawn),
			Util_GetRandomPosition(spawn),
			Util_GetRandomPosition(spawn),
		},
		uniqueSpawns = true,
		sgroups = {},
		units = _units,
		intent = _intent,
		onDeath = nil,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	if scartype(_target) == ST_NIL then
		_target = spawn
	end
	
	GOALS.assignDefenseGoal(enc_newEncounter, _goalType, _target, nil, _range, _leash, _thresh, _retreat)
	
	return enc_newEncounter
end

-- Custom Encounters
ENCOUNTERS.Road1_Def = function()	
	local encData = {
		name = "Road 1 Def",
		spawn = {
			mkr_e_road1_def_01,
			mkr_e_road1_def_02,
			mkr_e_road1_def_03,
		},
		uniqueSpawns = true,
		sgroups = {},
		units = {
			{				
				name = "Road_1_1",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				load = 4,		
			},
			{				
				name = "Road_1_2",
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,	
			},
			{				
				name = "Road_1_3",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				load = 4,
				conditions = {XP1_GetNodeStrength() >= 3},			
			},
		},
		onDeath = nil,
		-- Goal
		triggerGoalOnEngage = true,
		triggerGoalDelay = 0.8,
		goal = {
			name = "Defend",
			target = mkr_e_road1_def,
			range = 25,
			leashRange = 12,
			onFailure = Bastogne_Despawn_Units,
			fallbackParams = {
				thresholds = {0.3},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				retreat = true,
				markers = {mkr_e_retreat_04},
			},
			tacticControlsList = {
				{
					tacticType = TACTIC_Cover,
					priority = 250,
				},
				{
					tacticType = TACTIC_CaptureTeamWeapon,
					priority = 250,
				},
				{
					tacticType = TACTIC_Recrew,
					priority = 500,
				},
			},
		}
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

ENCOUNTERS.Road2_Def = function()	
	local encData = {
		name = "Road 2 Def",
		spawn = {
			mkr_e_road2_def_01,
			mkr_e_road2_def_02,
			mkr_e_road2_def_03,
			mkr_e_road2_def_04,
			eg_e_road2_def_01,
		},
		triggerGoalOnEngage = true,
		triggerGoalDelay = 2,
		uniqueSpawns = true,
		sgroups = {},
		units = {
			{				
				name = "Road_1_1",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				load = 4,		
			},
			{				
				name = "Road_1_2",
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,		
			},
			{				
				name = "Road_1_3",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				load = 4,
				conditions = {XP1_GetNodeStrength() <= 2},				
			},
			{				
				name = "Road_1_3",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				load = 4,
				conditions = {XP1_GetNodeStrength() >= 3},				
			},
			{				
				name = "Road_1_3",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				load = 4,		
			},
			{				
				name = "Road_1_3",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 3},			
			},
		},
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_e_road2_def,
			range = 25,
			leashRange = 19,
			onFailure = Bastogne_Despawn_Units,
			fallbackParams = {
				thresholds = {0.25},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				retreat = true,
				markers = {mkr_e_retreat_02},
			},
			tacticControlsList = {
				{
					tacticType = TACTIC_Cover,
					priority = 250,
				},
				{
					tacticType = TACTIC_CaptureTeamWeapon,
					priority = 250,
				},
				{
					tacticType = TACTIC_Recrew,
					priority = 500,
				},
			},
		}
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

ENCOUNTERS.Road3_Def = function()	
	local encData = {
		name = "Road 3 Def",
		spawn = {
			mkr_e_road3_def_01,
			mkr_e_road3_def_02,
			mkr_e_road3_def_03,
			mkr_e_road3_def_04,
			mkr_e_road3_def_05,
		},
		triggerGoalOnEngage = true,
		triggerGoalDelay = 3,
		uniqueSpawns = true,
		sgroups = {},
		units = {
			{				
				name = "Road_1_1",
				sbp = SBP.WEST_GERMAN.PAK40_75MM_AT_GUN_SQUAD_WG_MP,
				spawn = mkr_e_road3_def_01,
			},
			{				
				name = "Road_1_2",
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
			},
			{				
				name = "Road_1_3",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				load = 4,		
			},
			{				
				name = "Road_1_4",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,	
				upgrades = {UPG.WEST_GERMAN.ASSAULT_PIONEER_PANZERSCHRECK_UPGRADE},	
				conditions = {g_starting_antitank == true},	
			},
			{				
				name = "Road_1_5",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				spawn = eg_e_road3_def_01,		
			},
		},
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_e_road3_def,
			range = 25,
			leashRange = 12,
			onFailure = Bastogne_Despawn_Units,
			fallbackParams = {
				thresholds = {0.2},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				retreat = true,
				markers = {mkr_e_retreat_05},
			},
			tacticControlsList = {
				{
					tacticType = TACTIC_Cover,
					priority = 250,
				},
				{
					tacticType = TACTIC_CaptureTeamWeapon,
					priority = 250,
				},
				{
					tacticType = TACTIC_Recrew,
					priority = 500,
				},
			},
		}
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

ENCOUNTERS.Road4_Def = function()	
	local encData = {
		name = "Road 4 Def",
		spawn = {
			mkr_e_road4_def_01,
			mkr_e_road4_def_02,
			mkr_e_road4_def_03,
			mkr_e_road4_def_04,
			mkr_e_road4_def_05,
			mkr_e_road4_def_06,
		},
		triggerGoalOnEngage = true,
		triggerGoalDelay = 1,
		uniqueSpawns = true,
		sgroups = {},
		units = {
			{				
				name = "Road_4_1",
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() <= 2 and g_difficulty ~= GD_HARD},			
			},
			{				
				name = "Road_4_1",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 3 or g_difficulty == GD_HARD},				
			},
			{				
				name = "Road_4_2",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				load = 4,		
			},
			{				
				name = "Road_4_3",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				spawn = eg_e_road3_def_01,		
			},
			{				
				name = "Road_4_4",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				load = 4,					
			},
			{				
				name = "Road_4_5",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,	
				conditions = {g_starting_antitank == true},	
			},
		},
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_e_road4_def,
			range = 25,
			leashRange = 19.15,
			onFailure = Bastogne_Despawn_Units,
			tacticControlsList = {
				{
					tacticType = TACTIC_Cover,
					priority = 250,
				},
				{
					tacticType = TACTIC_CaptureTeamWeapon,
					priority = 250,
				},
				{
					tacticType = TACTIC_Recrew,
					priority = 500,
				},
			},
		}
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

ENCOUNTERS.CheckPoint1 = function()	
	local encData = {
		name = "Checkpoint 1",
		spawn = {
			mkr_e_checkPoint_01_01,
			mkr_e_checkPoint_01_02,
		},
		triggerGoalOnEngage = true,
		uniqueSpawns = true,
		sgroups = {},
		units = {
			{				
				name = "Checkpoint 1 1",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				load = 4,		
			},
			{				
				name = "Checkpoint 1 2",
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,			
			},
		},
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_e_checkPoint_01,
			range = 25,
			leashRange = 8,
			onFailure = Bastogne_Despawn_Units,
			fallbackParams = {
				thresholds = {0.2},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				retreat = true,
				markers = {mkr_e_retreat_01},
			},
			tacticControlsList = {
				{
					tacticType = TACTIC_Cover,
					priority = 250,
				},
				{
					tacticType = TACTIC_CaptureTeamWeapon,
					priority = 250,
				},
				{
					tacticType = TACTIC_Recrew,
					priority = 500,
				},
			},
		}
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

ENCOUNTERS.BasicEnc_A = function()	
	local encData = {
		name = "Checkpoint 1",
		spawn = {
			mkr_e_basicEnc_A_01,
			mkr_e_basicEnc_A_02,
		},
		triggerGoalOnEngage = true,
		triggerGoalDelay = 2,
		uniqueSpawns = true,
		sgroups = {},
		units = {
			{				
				name = "Checkpoint 1 1",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				load = 3,	
			},
			{				
				name = "Checkpoint 1 2",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				load = 3,		
			},
		},
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_e_basicEnc_A,
			range = 15,
			leashRange = 8,
			onFailure = Bastogne_Despawn_Units,
			fallbackParams = {
				thresholds = {0.3},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				retreat = true,
				markers = {mkr_e_retreat_01},
			},
			tacticControlsList = {
				{
					tacticType = TACTIC_Cover,
					priority = 250,
				},
				{
					tacticType = TACTIC_CaptureTeamWeapon,
					priority = 250,
				},
				{
					tacticType = TACTIC_Recrew,
					priority = 500,
				},
			},
		}
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

ENCOUNTERS.BasicEnc_B = function()	
	local encData = {
		name = "Checkpoint 1",
		spawn = {
			mkr_e_basicEnc_B_01,
			mkr_e_basicEnc_B_02,
		},
		triggerGoalOnEngage = true,
		triggerGoalDelay = 2,
		uniqueSpawns = true,
		sgroups = {},
		units = {
			{				
				name = "Checkpoint 1 1",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				load = 4,			
			},
			{				
				name = "Checkpoint 1 2",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				load = 3,		
			},
			{				
				name = "Checkpoint 1 2",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				load = 1,
				spawn = mkr_e_basicEnc_B_03,		
			},
		},
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_e_basicEnc_B,
			range = 20,
			leashRange = 13,
			onFailure = Bastogne_Despawn_Units,
			fallbackParams = {
				thresholds = {0.3},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				retreat = true,
				markers = {mkr_e_retreat_01},
			},
			tacticControlsList = {
				{
					tacticType = TACTIC_Cover,
					priority = 250,
				},
				{
					tacticType = TACTIC_CaptureTeamWeapon,
					priority = 250,
				},
				{
					tacticType = TACTIC_Recrew,
					priority = 500,
				},
			},
		}
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

ENCOUNTERS.BasicEnc_C = function()	
	local encData = {
		name = "Checkpoint 1",
		spawn = {
			mkr_e_basicEnc_C_01,
			mkr_e_basicEnc_C_02,
		},
		triggerGoalOnEngage = true,
		triggerGoalDelay = 2,
		uniqueSpawns = true,
		sgroups = {},
		units = {
			{				
				name = "Checkpoint 1 1",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				load = 4,		
			},
			{				
				name = "Checkpoint 1 2",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				load = 4,
				conditions = {XP1_GetNodeStrength() <= 2},				
			},
			{				
				name = "Checkpoint 1 2",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				load = 3,
				conditions = {XP1_GetNodeStrength() >= 3},				
			},
		},
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_e_basicEnc_C,
			range = 14,
			leashRange = 7.8,
			retaliateAttacks = false,
			onFailure = Bastogne_Despawn_Units,
			fallbackParams = {
				thresholds = {0.3},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				retreat = true,
				markers = {mkr_e_retreat_01},
			},
			tacticControlsList = {
				{
					tacticType = TACTIC_Cover,
					priority = 250,
				},
				{
					tacticType = TACTIC_Pickup,
					priority = 350,
				},
			},
		}
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

ENCOUNTERS.BasicEnc_D = function()	
	local encData = {
		name = "Checkpoint 1",
		spawn = {
			mkr_e_basicEnc_D_01,
			mkr_e_basicEnc_D_02,
			mkr_e_basicEnc_D_03,
			mkr_e_basicEnc_D_04,
		},
		triggerGoalOnEngage = true,
		triggerGoalDelay = 2,
		uniqueSpawns = true,
		sgroups = {},
		units = {
			{				
				name = "Checkpoint 1 1",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				load = 4,
			},
			{				
				name = "Checkpoint 1 2",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				load = 4,		
			},
			{				
				name = "Checkpoint 1 2",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {g_difficulty ~= GD_EASY},	
				load = 3,		
			},
			{				
				name = "Checkpoint 1 2",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				load = 4,
				conditions = {XP1_GetNodeStrength() <= 2},			
			},
			{				
				name = "Checkpoint 1 2",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				load = 3,
				conditions = {XP1_GetNodeStrength() >= 3},				
			},
		},
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_e_basicEnc_D,
			range = 20,
			leashRange = 13,
			onFailure = Bastogne_Despawn_Units,
			fallbackParams = {
				thresholds = {0.2},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				retreat = true,
				markers = {mkr_e_retreat_06},
			},
			tacticControlsList = {
				{
					tacticType = TACTIC_Cover,
					priority = 250,
				},
				{
					tacticType = TACTIC_CaptureTeamWeapon,
					priority = 250,
				},
				{
					tacticType = TACTIC_Recrew,
					priority = 500,
				},
			},
		}
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

ENCOUNTERS.BasicEnc_E = function()	
	local encData = {
		name = "Checkpoint 1",
		spawn = {
			mkr_e_basicEnc_E_01,
			mkr_e_basicEnc_E_02,
			mkr_e_basicEnc_E_03,
			mkr_e_basicEnc_E_04,
		},
		triggerGoalOnEngage = true,
		triggerGoalDelay = 2,
		uniqueSpawns = true,
		sgroups = {},
		units = {
			{				
				name = "Checkpoint 1 1",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				load = 4,			
			},
			{				
				name = "Checkpoint 1 2",
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				load = 2,		
			},
			{				
				name = "Checkpoint 1 2",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {g_difficulty ~= GD_EASY},	
				load = 3,		
			},
			{				
				name = "Checkpoint 1 2",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				load = 4,
				conditions = {XP1_GetNodeStrength() <= 2 and g_difficulty ~= GD_HARD},			
			},
			{				
				name = "Checkpoint 1 2",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				load = 3,
				conditions = {XP1_GetNodeStrength() >= 3 or g_difficulty == GD_HARD},				
			},
		},
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_e_basicEnc_E,
			range = 20,
			leashRange = 13,
			onFailure = Bastogne_Despawn_Units,
			fallbackParams = {
				thresholds = {0.2},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				retreat = true,
				markers = {mkr_e_retreat_05},
			},
			tacticControlsList = {
				{
					tacticType = TACTIC_Cover,
					priority = 250,
				},
				{
					tacticType = TACTIC_CaptureTeamWeapon,
					priority = 250,
				},
				{
					tacticType = TACTIC_Recrew,
					priority = 500,
				},
			},
		}
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

-- Slottable Secondary
ENCOUNTERS.SECOBJ_TANK_PROTECTION = function()
	local encData = {
		name = "Checkpoint 1",
		spawn = {
			Util_GetRandomPosition(mkr_secObj_VIP_spawn01),
			Util_GetRandomPosition(mkr_secObj_VIP_spawn01),
			Util_GetRandomPosition(mkr_secObj_VIP_spawn01),
			Util_GetRandomPosition(mkr_secObj_VIP_spawn01),
		},
		uniqueSpawns = true,
		sgroups = {},
		units = {
			{				
				name = "Checkpoint 1 1",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				load = 4,		
			},
			{				
				name = "Checkpoint 1 2",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,		
			},
			{				
				name = "Checkpoint 1 2",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {g_difficulty ~= GD_EASY},	
				load = 4,		
			},
		},
		onDeath = nil,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
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
				markers = {mkr_e_retreat_01},
				retreat = true,
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end

ENCOUNTERS.SecObj_destroyTank_medDef_01 = function()
    local encData = {
		name = "VIP_04",
		spawn = mkr_secObj_destroyTank_medDef_01,
		intent = ENC_INTENT.medAntiInfantryDefense,
		
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_secObj_destroyTank_medDef_01,
			leashRange = mkr_secObj_destroyTank_medDef_01,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {
				Util_GetOffsetPosition(mkr_secObj_destroyTank_medDef_01, OFFSET_FRONT, 90),
				Util_GetOffsetPosition(mkr_secObj_destroyTank_medDef_01, OFFSET_LEFT, 90),
				Util_GetOffsetPosition(mkr_secObj_destroyTank_medDef_01, OFFSET_RIGHT, 90),
			},
			maxIdleTime = -1,
			retaliateAttacks = true,
			fallbackParams = {
				thresholds = {0.25},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_e_retreat_01},
				retreat = true,
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end

ENCOUNTERS.SecObj_demolitionMan_medDef_01 = function()
    local encData = {
		name = "VIP_04",
		spawn = mkr_secObj_demolitionMan_medDef_01,
		intent = ENC_INTENT.medAntiInfantryDefense,
		
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_secObj_demolitionMan_medDef_01,
			leashRange = mkr_secObj_demolitionMan_medDef_01,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {
				Util_GetOffsetPosition(mkr_secObj_demolitionMan_medDef_01, OFFSET_FRONT, 90),
				Util_GetOffsetPosition(mkr_secObj_demolitionMan_medDef_01, OFFSET_LEFT, 90),
				Util_GetOffsetPosition(mkr_secObj_demolitionMan_medDef_01, OFFSET_RIGHT, 90),
			},
			maxIdleTime = -1,
			retaliateAttacks = true,
			fallbackParams = {
				thresholds = {0.25},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_e_retreat_01},
				retreat = true,
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end

-- Goals
GOALS = {}

-- A goal that will be assigned to multiple encounters throughout the course of a single mission
GOALS.assignDefenseGoal = function(encounterID, goalType, newTarget, condition, range, leash, thresh, retreat)
	local FallbackParams = nil
	
	local goalData = {
		name = goalType,
		target = newTarget,
		range = range,
		leashRange = leash,
		fallbackParams = {
			thresholds = {0.3},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			retreat = true,
			markers = {retreat},
		},
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(newTarget, OFFSET_FRONT, 40)
		},
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 250,
			},
			{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = 250,
			},
			{
				tacticType = TACTIC_Recrew,
				priority = 500,
			},
		},
		onSuccess = condition,
	}
	
	encounterID:SetGoal(goalData)
end

-- Wavemanagers
WAVEMANAGERS = {}

WAVEMANAGERS.Enemy_Road_Counter_Attack = function()
	local waveManagerData = {
		waves = {
			WAVES.Enemy_First_Attack(), 
			WAVES.Enemy_Road_CA_01(),
			WAVES.Enemy_Road_CA_02(),
			WAVES.Enemy_Road_CA_03(),
			WAVES.Enemy_Road_CA_04(),
		},
		
		attackDirs = {
			{						-- spawn = The spawn point, dynSpawn = Dynamic spawn target, ui = location for hintpoints, target = target for goal
				{spawn = mkr_e_waveSpawn_01, dynSpawn = mkr_e_waveDynSpawn_01, ui = nil, target = mkr_e_road2_def, rallyPoint = nil},
			},
			{						-- spawn = The spawn point, dynSpawn = Dynamic spawn target, ui = location for hintpoints, target = target for goal
				{spawn = mkr_e_waveSpawn_02, dynSpawn = mkr_e_waveDynSpawn_02, ui = nil, target = mkr_e_road3_def, rallyPoint = nil},
			},
			{						-- spawn = The spawn point, dynSpawn = Dynamic spawn target, ui = location for hintpoints, target = target for goal
				{spawn = mkr_e_waveSpawn_03, dynSpawn = mkr_e_waveDynSpawn_03, ui = nil, target = mkr_e_road2_def, rallyPoint = nil},
			},
			{						-- spawn = The spawn point, dynSpawn = Dynamic spawn target, ui = location for hintpoints, target = target for goal
				{spawn = mkr_e_waveSpawn_03, dynSpawn = mkr_e_waveDynSpawn_03, ui = nil, target = mkr_e_road3_def, rallyPoint = nil},
			},
		},
		
		waveCompleteConditionData = {
			condition = CONDITION_UNITS_LEFT,
			variable = 3,
			vehicles = 0,
			wave_retreats = true,
			retreatDirs = {}
		},
		
		groups = {
			commandGroup = SGroup_CreateIfNotFound("sg_e_counter_attack_all"),
			vehicleGroup = SGroup_CreateIfNotFound("sg_e_vehicleSGroup"),
		},
		
		callbackData = {
			onStart = DefendRoad_WaveSpawn,
			onComplete = DefendRoad_WaveEnd,
			onSpotted = DefendRoad_WaveSpotted,
		},
		
		defaultGoalData = {
			name = "Defend",
			target = nil,
			range = 15,
			leashRange = 15,
			attackMove = true,
			movePathLengthFactor = -1,
			safeMoveWeight = 0,
		},
	}
	
	return waveManagerData
end

-- Waves
WAVES = {}


WAVES.Enemy_First_Attack = function()
	local waveData = {
		encounters = {
			{
				units = {
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,},
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,},
					{
						sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP,
						conditions = {g_difficulty == GD_HARD},	
					},
				},
			},
		},
	}
	return waveData
end

WAVES.Enemy_Road_CA_01 = function()
	local waveData = {
		encounters = {
			{
				units = {
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,},
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,},
					{
						sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
						conditions = {g_difficulty == GD_HARD},	
					},
					{
						sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP,
						conditions = {g_difficulty ~= GD_HARD},	
					},
				},
			},
		},
	}
	return waveData
end

WAVES.Enemy_Road_CA_02 = function()
	local waveData = {
		encounters = {
			{
				units = {
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,},
					{
						sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
						conditions = {g_difficulty == GD_NORMAL},	
					},
					{
						sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
						conditions = {g_difficulty == GD_HARD},	
					},
					{
						sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
						conditions = {g_difficulty == GD_HARD},	
					},
					{
						sbp = SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP,
					},
					{
						sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
						conditions = {g_difficulty == GD_EASY},	
					},
				},
			},
		},
	}
	
	return waveData
end

WAVES.Enemy_Road_CA_03 = function()
	local waveData = {
		encounters = {
			{
				units = {
					{sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,},
					{sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,},
					{
						sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
						conditions = {g_difficulty ~= GD_HARD},
					},
					{
						sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
						conditions = {g_difficulty == GD_HARD},	
					},
					{
						sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
						conditions = {g_enemy_tanks == true},
					},
					{
						sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
						conditions = {g_enemy_tanks == false and g_difficulty == GD_HARD},
					},
				},
			},
		},
	}
	
	return waveData
end

WAVES.Enemy_Road_CA_04 = function()
	local waveData = {
		encounters = {
			{
				units = {
					{
						sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
					},
					{
						sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
						conditions = {g_difficulty ~= GD_HARD},
					},
					{
						sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
						conditions = {g_difficulty == GD_HARD},
					},
					{
						sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
						conditions = {g_enemy_tanks == false},
					},
					{
						sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
						conditions = {g_enemy_tanks == true},
					},
					{
						sbp =  SBP.GERMAN.STUG_III_SQUAD_MP,
						conditions = {g_enemy_tanks == true or g_difficulty == GD_HARD},
					},
				},
			},
		},
	}
	
	return waveData
end
