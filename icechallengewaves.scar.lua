

--------------------------------------------------------------
---- raw data for waves for ice challenge (i.e. Russian Defense)
--------------------------------------------------------------


function SetUpWaveData()
	-- overall data
	t_defData = {
		waves = {},
		spawnMarkers = {
			{
				mkr = mkr_enemy_spawn1,
				obj = mkr_target_left,
			},
			{
				mkr = mkr_enemy_spawn2,
				obj = mkr_target_center,
			},
			{
				mkr = mkr_enemy_spawn3,
				obj = mkr_target_center,
			},
			{
				mkr = mkr_enemy_spawn4,
				obj = mkr_target_right,
			},
		},
		target = eg_player_point,
		playerSpawn = mkr_AllySpawn,
		objectives = {
			gold = OBJ_Gold,
			silver = OBJ_Silver,
		},
	}
	
	t_defData.waves[1] = { 
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				numSquads = t_difficulty.squadsMany,
			},
		},
		abilityBlacklist = nil,
		rewards = {
			resources = {
				{
					type = RT_Action,
					amount = t_difficulty.awardAction,
				},
			},
			reinforcements = {
				{
					sbp = SBP.SOVIET.GUARDS_TROOPS,
				},
				{
					sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				},
			},
		},
	}

	t_defData.waves[2] = { 
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				numSquads = t_difficulty.squadsMany,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				numSquads = t_difficulty.squadsFew,
			},
		},
		abilityBlacklist = nil,
		fallbackParams = nil,
		rewards = {
			resources = {
				{
					type = RT_Munition,
					amount = t_difficulty.awardMunition,
				},
				{
					type = RT_Action,
					amount = t_difficulty.awardAction,
				},
			},
			reinforcements = {
				{
					sbp = SBP.SOVIET.SNIPER_TEAM,
				},
			},
		},
	}

	t_defData.waves[3] = { 
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				numSquads = t_difficulty.squadsSome,
				delay = 8,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				numSquads = t_difficulty.squadsFew,
				delay = 8,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				numSquads = t_difficulty.squadsFew,
				pos = 3,
			},
			{
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				numSquads = t_difficulty.squadsFew,
				pos = 3,
			},
		},
		abilityBlacklist = nil,
		fallbackParams = nil,
		rewards = {
			resources = {
				{
					type = RT_Munition,
					amount = t_difficulty.awardMunition,
				},
				{
					type = RT_Action,
					amount = t_difficulty.awardAction,
				},
			},
			reinforcements = {
				{
					sbp = SBP.SOVIET.COMBAT_ENGINEER_SQUAD,
				},
			},
		},
	}

	t_defData.waves[4] = { 
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				numSquads = t_difficulty.squadsSome,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				numSquads = t_difficulty.squadsSome,
			},
			{
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
				numSquads = t_difficulty.squadsFew,
				entityUpgrades = { UPG.GERMAN.SDKFZ_222_20MM_GUN },
				isTank = true,
			},
		},
		abilityBlacklist = nil,
		fallbackParams = nil,
		rewards = {
			resources = {
				{
					type = RT_Munition,
					amount = t_difficulty.awardMunition,
				},
				{
					type = RT_Action,
					amount = t_difficulty.awardAction,
				},
			},
			reinforcements = {
				{
					sbp = t_difficulty.atGun,
				},
			},
		},
	}

	t_defData.waves[5] = { 
		units = {
			{
				sbp = SBP.GERMAN.PANZER_IV_STUBBY_SQUAD,
				numSquads = t_difficulty.squadsVeryFew,
				delay = 5,
				isTank = true,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				numSquads = t_difficulty.squadsFew,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				numSquads = t_difficulty.squadsFew,
			},
		},
		abilityBlacklist = nil,
		fallbackParams = nil,
		rewards = {
			resources = {
				{
					type = RT_Munition,
					amount = t_difficulty.awardMunition,
				},
				{
					type = RT_Action,
					amount = t_difficulty.awardAction,
				},
			},
			reinforcements = {
				{
					sbp = SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD,
				},
			},
		},
	}


	t_defData.waves[6] = { 
		units = {
			{
				sbp = SBP.GERMAN.SNIPER_SQUAD,
				pos = 4,
				delay = 8,
				numSquads = t_difficulty.squadsFew,
			},
			{
				sbp = SBP.GERMAN.SNIPER_SQUAD,
				pos = 3,
				numSquads = t_difficulty.squadsFew,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				numSquads = t_difficulty.squadsFew,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				numSquads = t_difficulty.squadsSome,
			},
		},
		abilityBlacklist = nil,
		fallbackParams = nil,
		rewards = {
			resources = {
				{
					type = RT_Munition,
					amount = t_difficulty.awardMunition,
				},
				{
					type = RT_Action,
					amount = t_difficulty.awardAction,
				},
			},
			reinforcements = {
				
			},
		},
	}


	t_defData.waves[7] = { 
		units = {
			{
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
				numSquads = t_difficulty.squadsFew,
				entityUpgrades = { UPG.GERMAN.SDKFZ_222_20MM_GUN, },
				isTank = true,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				numSquads = t_difficulty.squadsSome,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				numSquads = t_difficulty.squadsFew,
			},
		},
		startAbilities = {ABILITY.GERMAN.STUKA_STRAFING_RUN,},
		abilityBlacklist = nil,
		fallbackParams = nil,
		rewards = {
			resources = {
				{
					type = RT_Munition,
					amount = t_difficulty.awardMunition,
				},
				{
					type = RT_Action,
					amount = t_difficulty.awardAction,
				},
			},
			reinforcements = {
			},
		},
	}

	t_defData.waves[8] = { 
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				numSquads = t_difficulty.squadsSome,
			},
			{
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
				entityUpgrades = { UPG.GERMAN.SDKFZ_222_20MM_GUN, },
				numSquads = t_difficulty.squadsMany,
				isTank = true,
			},
			{
				sbp = SBP.GERMAN.MORTAR_TEAM_81MM,
				pos = 2,
				delay = 5,
				numSquads = t_difficulty.squadsFew,
			},
			
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				pos = 2,
				delay = 5,
				numSquads = t_difficulty.squadsFew,
			},
		},
		abilityBlacklist = nil,
		fallbackParams = nil,
		rewards = {
			resources = {
				{
					type = RT_Munition,
					amount = t_difficulty.awardMunition,
				},
				{
					type = RT_Action,
					amount = t_difficulty.awardAction,
				},
			},
			reinforcements = {
			},
		},
	}

	t_defData.waves[9] = { 
		units = {
			{
				sbp = SBP.GERMAN.MORTAR_250_HALFTRACK_SQUAD,
				numSquads = t_difficulty.squadsVeryFew,
				isTank = true,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				numSquads = t_difficulty.squadsSome,
			},
			{
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
				pos = 3, 
				delay = 10,
				numSquads = t_difficulty.squadsSome,
				isTank = true,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				pos = 3,
				delay = 10,
				numSquads = t_difficulty.squadsFew,
			},
		},
		abilityBlacklist = nil,
		fallbackParams = nil,
		rewards = {
			resources = {
				{
				type = RT_Munition,
				amount = t_difficulty.awardMunition,
				},
				{
				type = RT_Action,
				amount = t_difficulty.awardAction,
				},
			},
			reinforcements = {
			},
		},
	}

	t_defData.waves[10] = {  
		units = {
			{
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
				numSquads = t_difficulty.squadsSome,
				isTank = true,
			},
			{
				sbp = SBP.GERMAN.TIGER_SQUAD,
				pos = 4,
				delay = 5,
				numSquads = t_difficulty.squadsVeryFew,
				isTank = true,
			},
		},
		abilityBlacklist = nil,
		fallbackParams = nil,
		rewards = {
			resources = {
				{
					type = RT_Munition,
					amount = t_difficulty.awardMunition,
				},
				{
					type = RT_Action,
					amount = t_difficulty.awardAction,
				},
			},
			reinforcements = {
			},
		},
	}
end




