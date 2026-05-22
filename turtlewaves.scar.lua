

--------------------------------------------------------------
---- raw data for waves for German defense challenge "Schildkroteberg"
--------------------------------------------------------------


function SetUpWaveData()
	-- overall data
	t_defData = {
		waves = {},
		spawnMarkers = {
			{
				mkr = mkr_enemy_spawn_01,
				obj = mkr_target_right,
			},
			{
				mkr = mkr_enemy_spawn_02,
				obj = mkr_target_center,
			},
			{
				mkr = mkr_enemy_spawn_03,
				obj = mkr_target_center,
			},
			{
				mkr = mkr_enemy_spawn_04,
				obj = mkr_target_left,
			},
			{
				mkr = mkr_enemy_spawn_05,
				obj = mkr_target_right,
			},
		},
		target = eg_player_hq,
		playerSpawn = mkr_player_pioneer_01,
		objectives = {
			gold = OBJ_Gold,
			silver = OBJ_Silver,
		},
	}
	

	-- wave one -- conscript rush
	t_defData.waves[1] = { 
		units = {
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				numSquads = t_difficulty.squadsSome,
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				numSquads = t_difficulty.squadsSome,
				delay = 1,
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				numSquads = t_difficulty.squadsSome,
				delay = 5,
			},
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				numSquads = t_difficulty.squadsSome,
				delay = 6,
			},
		},
		abilityBlacklist = nil,
		startAbilities = {
		},
		fallbackParams = {
			thresholds = {0.5},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			retreat = true,
			retreatOnSuppression = true,
		},
		rewards = {
			resources = {
				{
					type = RT_Action,
					amount = t_difficulty.awardAction,
				},
			},
		},
	}

	t_defData.waves[2] = { 
		units = {
			{
				sbp = SBP.SOVIET.SHOCK_TROOPS,
				numSquads = t_difficulty.squadsSome,
			},
			{
				sbp = SBP.SOVIET.SHOCK_TROOPS,
				numSquads = t_difficulty.squadsSome,
				pos = 2,
			},
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				numSquads = t_difficulty.squadsFew,
				pos = 2,
				slotItems = {SLOT_ITEM.DP_28_LIGHT_MACHINE_GUN_PACKAGE},
				delay = 5,
				
			},
		},
		abilityBlacklist = nil,
		fallbackParams = {
			thresholds = {0.1},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			retreat = true,
			retreatOnSuppression = false,
		},
		rewards = {
			resources = {
				{
					type = RT_Munition,
					amount = t_difficulty.awardMunition,
				},
				{
					type = RT_Fuel,
					amount = t_difficulty.awardFuel,
				},
				{
					type = RT_Action,
					amount = t_difficulty.awardAction,
				},
			},
		},
	}

	t_defData.waves[3] = { 
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				numSquads = t_difficulty.squadsSome,
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				numSquads = t_difficulty.squadsFew,
				upgrades = {UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP},
				pos = 2,
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				numSquads = t_difficulty.squadsSome,
				pos = 3,
				delay = 2
			},
			{
				sbp = SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD,
				numSquads = t_difficulty.squadsFew,
				pos = 3,
				delay = 10,
			},
			{
				sbp = SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD,
				numSquads = t_difficulty.squadsFew,
				pos = 2,
				delay = 10,
			},
		},
		abilityBlacklist = nil,
		fallbackParams = {
			thresholds = {0.1},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			retreat = true,
			retreatOnSuppression = false,
		},
		rewards = {
			resources = {
				{
					type = RT_Munition,
					amount = t_difficulty.awardMunition,
				},
				{
					type = RT_Fuel,
					amount = t_difficulty.awardFuel,
				},
				{
					type = RT_Action,
					amount = t_difficulty.awardAction,
				},
			},
		},
	}

	t_defData.waves[4] = { 
		units = {
			{
				sbp = SBP.SOVIET.PENAL_BATTALION,
				numSquads = t_difficulty.squadsSome,
			},
			{
				sbp = SBP.SOVIET.PENAL_BATTALION,
				upgrades = {UPG.SOVIET.PENAL_BATTALION_FLAMETHROWER_PACKAGE,},
				numSquads = t_difficulty.squadsSome,
				delay = 2,
			},
			{
				sbp = SBP.SOVIET.PENAL_BATTALION,
				numSquads = t_difficulty.squadsFew,
				upgrades = {UPG.SOVIET.PENAL_BATTALION_FLAMETHROWER_PACKAGE,},
				pos = 3,
			},
			{
				sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD,
				numSquads = t_difficulty.squadsVeryFew,
				pos = 4,
				delay = 15,
			},
		},
		startAbilities = {
		},
		abilityBlacklist = nil,
		fallbackParams = {
			thresholds = {0.1},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			retreat = true,
			retreatOnSuppression = false,
		},
		rewards = {
			resources = {
				{
					type = RT_Munition,
					amount = t_difficulty.awardMunition,
				},
				{
					type = RT_Fuel,
					amount = t_difficulty.awardFuel,
				},
				{
					type = RT_Action,
					amount = t_difficulty.awardAction,
				},
			},
		},
	}

	t_defData.waves[5] = { 
		units = {
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				numSquads = t_difficulty.squadsVeryMany,
				upgrades = { UPG.SOVIET.CONSCRIPT_ASSAULT_PACKAGE_INGAME, },
			},
			{
				sbp = SBP.SOVIET.PENAL_BATTALION,
				numSquads = t_difficulty.squadsMany,
				delay = 20,
				pos = 3,
			},
			{
				sbp = SBP.SOVIET.PENAL_BATTALION,
				numSquads = t_difficulty.squadsFew,
				upgrades = {UPG.SOVIET.PENAL_BATTALION_FLAMETHROWER_PACKAGE,},
				delay = 20,
				pos = 3,
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				numSquads = t_difficulty.squadsSome,
				pos = 2,
				delay = 40,
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				numSquads = t_difficulty.squadsSome,
				upgrades = {UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP},
				delay = 40,
				pos = 2,
			},
			{
				sbp = SBP.SOVIET.SHOCK_TROOPS,
				numSquads = t_difficulty.squadsVeryMany,
				pos = 4,
				delay = 60,
			},
		},
		startAbilities = {
		},
		onWaveComplete = function ()
			Event_Timer(VehicleWarning, nil, 2)
		end,
		abilityBlacklist = nil,
		fallbackParams = {
			thresholds = {0.1},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			retreat = true,
			retreatOnSuppression = false,
		},
		rewards = {
			resources = {
				{
					type = RT_Munition,
					amount = t_difficulty.awardMunition,
				},
				{
					type = RT_Fuel,
					amount = t_difficulty.awardFuel,
				},
				{
					type = RT_Action,
					amount = t_difficulty.awardAction,
				},
			},
		},
	}

	t_defData.waves[6] = { 
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				numSquads = t_difficulty.squadsSome,
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				numSquads = t_difficulty.squadsSome,
				delay = 5,
			},
			{
				sbp = SBP.SOVIET.SNIPER_TEAM,
				numSquads = t_difficulty.squadsVeryFew,
				pos = 3,
				delay = 10,
			},
			{
				sbp = SBP.SOVIET.SNIPER_TEAM,
				numSquads = t_difficulty.squadsVeryFew,
				pos = 2,
				delay = 15
			},
		},
		abilityBlacklist = nil,
		fallbackParams = {
			thresholds = {0.2},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			retreat = true,
			retreatOnSuppression = false,
		},
		rewards = {
			resources = {
				{
					type = RT_Munition,
					amount = t_difficulty.awardMunition,
				},
				{
					type = RT_Fuel,
					amount = t_difficulty.awardFuel,
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
				sbp = SBP.SOVIET.T_70M,
				numSquads = t_difficulty.squadsFew,
--~ 				isTank = true,
			},
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				numSquads = t_difficulty.squadsSome,
				delay = 2,
			},
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				numSquads = t_difficulty.squadsFew,
				delay = 3,
			},
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				numSquads = t_difficulty.squadsSome,
				delay = 4,
			},
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				numSquads = t_difficulty.squadsSome,
				pos = 3,
				delay = 15,
			},
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				numSquads = t_difficulty.squadsFew,
				pos = 3,
				delay = 16,
			},
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				numSquads = t_difficulty.squadsSome,
				pos = 3,
				delay = 17,
			},
			{
				sbp = SBP.SOVIET.T_70M,
				numSquads = t_difficulty.squadsSome,
				delay = 45,
			},
			{
				sbp = SBP.SOVIET.T_34_76_SQUAD,
				numSquads = t_difficulty.squadsFew,
				delay = 45,
			},
		},
		abilityBlacklist = nil,
		fallbackParams = {
			thresholds = {0.2},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			retreat = true,
			retreatOnSuppression = true,
		},
		rewards = {
			resources = {
				{
					type = RT_Munition,
					amount = t_difficulty.awardMunition,
				},
				{
					type = RT_Fuel,
					amount = t_difficulty.awardFuel,
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
				sbp = SBP.SOVIET.SHOCK_TROOPS,
				numSquads = t_difficulty.squadsSome,
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				upgrades = {UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP},
				numSquads = t_difficulty.squadsFew,
			},
			{
				sbp = SBP.SOVIET.T_70M,
				numSquads = t_difficulty.squadsSome,
				pos = 2,
				delay = 10,
			},
			{
				sbp = SBP.SOVIET.T_34_76_SQUAD,
				numSquads = t_difficulty.squadsSome,
				pos = 3,
				delay = 5,
			},
			
		},
		abilityBlacklist = nil,
		fallbackParams = {
			thresholds = {0.2},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			retreat = true,
			retreatOnSuppression = false,
		},
		rewards = {
			resources = {
				{
					type = RT_Munition,
					amount = t_difficulty.awardMunition,
				},
				{
					type = RT_Fuel,
					amount = t_difficulty.awardFuel,
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
				sbp = SBP.SOVIET.SHOCK_TROOPS,
				numSquads = t_difficulty.squadsSome,
			},
			{
				sbp = SBP.SOVIET.SHOCK_TROOPS,
				numSquads = t_difficulty.squadsSome,
				delay = 5,
			},
			{
				sbp = SBP.SOVIET.SHOCK_TROOPS,
				numSquads = t_difficulty.squadsSome,
				delay = 7,
			},
			{
				sbp = SBP.SOVIET.T_70M,
				numSquads = t_difficulty.squadsSome,
				pos = 4,
				delay = 10,
			},
		},
		abilityBlacklist = nil,
		startAbilities = {
		},
		fallbackParams = {
			thresholds = {0.1},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			retreat = true,
			retreatOnSuppression = false,
		},
		rewards = {
			resources = {
				{
				type = RT_Munition,
				amount = t_difficulty.awardMunition,
				},
				{
					type = RT_Fuel,
					amount = t_difficulty.awardFuel,
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
				sbp = SBP.SOVIET.T_34_76_SQUAD,
				numSquads = t_difficulty.squadsSome,
			},
			{
				sbp = SBP.SOVIET.KV_1,
				numSquads = t_difficulty.squadsFew,
			},
		},
		abilityBlacklist = nil,
		fallbackParams = {
			thresholds = {0.2},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			retreat = true,
			retreatOnSuppression = true,
		},
		rewards = {
			resources = {
				{
					type = RT_Munition,
					amount = t_difficulty.awardMunition,
				},
				{
					type = RT_Fuel,
					amount = t_difficulty.awardFuel,
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




