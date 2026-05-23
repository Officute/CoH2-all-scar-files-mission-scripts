ENCOUNTERS = {}

--[[ENCOUNTERS.ExampleEncounter = function()
    local encData = {
		name = "Second Objective Encounter", -- Encounter Name
		spawn = mkr_enemySpawn, --The default spawn marker for the encounter (can be overridden below)
--~ 		sgroups = {}, --Any sgroups that the encounter should be added to
		units = { --A list of unit tables spawned by the encounter
			{
				name = "Grens", --Unit name
				sbp = SBP.GERMAN.GRENADIER_SQUAD, -- Unit blueprint 
				spawn = mkr_enemySpawn, -- Spawn marker for the unit
			},
			{
				name = "MG",
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_MP,
				spawn = mkr_enemySpawn,
			},
		},
		goal = { --This represents the goal of the encounter - (ie: whether it is defending an area, attacking, etc...)
			name = "Defend", --The name defines the type of encounter this is
			target = mkr_enemyGoal, --The target the encounter is geared around
			range = 45, -- The area around target that is considered a part of the encounter
			leashRange = mkr_enemyGoal, --The distance from the target that units in the counter will wander (when using a marker, it will get the marker's radius)
		}
	}	
    local enc_newEncounter = Encounter:Create(encData)     
	
    return enc_newEncounter
end]]

ENCOUNTERS.building1_counterattack = function()
	local encData = {
		name = "building1_counterattack",
		player = player3,
		units = {
			{
				--sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				sbp = BP_GetSquadBlueprint("assault_grenadier_squad_mp"),
				spawn = mkr_building1_counterattack,
			},
			{
				sbp = BP_GetSquadBlueprint("assault_grenadier_squad_mp"),
				--sgroups = {sg_flak_halftracks},
				spawn = mkr_building1_counterattack,
			},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				spawn = Util_GetRandomPosition(mkr_building1_counterattack, 10),
			},
			{
				sbp = BP_GetSquadBlueprint("assault_grenadier_squad_mp"),
				spawn = Util_GetRandomPosition(mkr_building1_counterattack, 5),
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				sbp = BP_GetSquadBlueprint("grenadier_squad_sp"),
				spawn = Util_GetRandomPosition(mkr_building1_counterattack, 5),
				difficulty = {GD_HARD},
			},		
		},
		goal = {
			name = "Defend",
			target = mkr_building1_counterattack_trigger,
			leashRange = mkr_building1_counterattack_trigger,
			coordinatedSetup = true,
			maxIdleTime = -1,
			retaliateAttackRange = 45,
			tacticControlsList = {
				{
					tacticType = TACTIC_Pickup,
					priority = -1,
				},
			},
			fallbackParams = {
				thresholds = {0.33},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_building1_counterattack},
				retreat = false,
			},
			onFailure = Despawn,
		},
		triggerGoalOnEngage = true,
	}
	local enc_newEncounter = Encounter:Create(encData)
	
	return enc_newEncounter
end

ENCOUNTERS.obj3_defenders1 = function()
	local encData = {
		name = "obj3_defenders1",
		player = player3,
		spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn1, 10),
		sgroups = {sg_obj3_defenders},
		units = {
			{
				--sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				sbp = BP_GetSquadBlueprint("assault_grenadier_squad_mp"),
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn1, 10),
			},
			{
				sbp = BP_GetSquadBlueprint("assault_grenadier_squad_mp"),
				--sgroups = {sg_flak_halftracks},
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn1, 10),
			},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn1, 10),
				difficulty = {GD_HARD},
			},
			{
				sbp = BP_GetSquadBlueprint("assault_grenadier_squad_mp"),
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn1, 10),
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				sbp = BP_GetSquadBlueprint("grenadier_squad_sp"),
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn1, 10),
				difficulty = {GD_HARD},
			},
			{
				name = "MG",
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_MP,
				--spawn = mkr_enemySpawnsHMG,
			},
			{
				name = "AT gun",
				sbp = BP_GetSquadBlueprint("pak40_75mm_at_gun_squad"),
				--spawn = mkr_enemySpawnsHMG,
			},	
		},
		goal = {
			name = "Defend",
			target = mkr_obj3_defenders_dest1,
			leashRange = mkr_obj3_defenders_dest1,
			coordinatedSetup = true,
			maxIdleTime = -1,
			retaliateAttackRange = 45,
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
			fallbackParams = {
				thresholds = {0.33},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_obj3_defenders_retreat},
				retreat = true,
			},
			onFailure = Despawn,
		},
		triggerGoalOnEngage = true,
	}
	local enc_newEncounter = Encounter:Create(encData)
	
	return enc_newEncounter
end

ENCOUNTERS.obj3_defenders2 = function()
	local encData = {
		name = "obj3_defenders2",
		player = player3,
		spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn2, 10),
		sgroups = {sg_obj3_defenders},
		units = {
			{
				--sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				sbp = BP_GetSquadBlueprint("assault_grenadier_squad_mp"),
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn2, 10),
			},
			{
				sbp = BP_GetSquadBlueprint("assault_grenadier_squad_mp"),
				--sgroups = {sg_flak_halftracks},
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn2, 10),
			},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn2, 10),
				difficulty = {GD_HARD},
			},
			{
				sbp = BP_GetSquadBlueprint("assault_grenadier_squad_mp"),
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn2, 10),
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				sbp = BP_GetSquadBlueprint("grenadier_squad_sp"),
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn2, 10),
				difficulty = {GD_HARD},
			},
			{
				name = "MG",
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_MP,
				--spawn = mkr_enemySpawnsHMG,
			},
			{
				name = "AT gun",
				sbp = BP_GetSquadBlueprint("pak40_75mm_at_gun_squad"),
				--spawn = mkr_enemySpawnsHMG,
			},			
		},
		goal = {
			name = "Defend",
			target = mkr_obj3_defenders_dest2,
			leashRange = mkr_obj3_defenders_dest2,
			coordinatedSetup = true,
			maxIdleTime = -1,
			retaliateAttackRange = 45,
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
			fallbackParams = {
				thresholds = {0.33},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_obj3_defenders_retreat},
				retreat = true,
			},
			onFailure = Despawn,
		},
		triggerGoalOnEngage = true,
	}
	local enc_newEncounter = Encounter:Create(encData)
	
	return enc_newEncounter
end

ENCOUNTERS.obj3_waves = function()
	local encData = {
		name = "obj3_waves",
		player = player3,
		spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn, 10),
		units = {
			{
				--sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				sbp = BP_GetSquadBlueprint("assault_grenadier_squad_mp"),
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn, 10),
			},
			{
				sbp = BP_GetSquadBlueprint("assault_grenadier_squad_mp"),
				--sgroups = {sg_flak_halftracks},
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn, 10),
			},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn, 10),
				difficulty = {GD_HARD},
			},
			{
				sbp = BP_GetSquadBlueprint("assault_grenadier_squad_mp"),
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn, 10),
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				sbp = BP_GetSquadBlueprint("grenadier_squad_sp"),
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn, 10),
				difficulty = {GD_HARD},
			},		
		},
		goal = {
			name = "Defend",
			target = mkr_obj3_defenders_dest2,
			leashRange = mkr_obj3_defenders_dest2,
			coordinatedSetup = true,
			maxIdleTime = -1,
			retaliateAttackRange = 45,
			tacticControlsList = {
				{
					tacticType = TACTIC_Pickup,
					priority = -1,
				},
			},
			fallbackParams = {
				thresholds = {0.33},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_obj3_defenders_dest2},
				retreat = true,
			},
			onFailure = Despawn,
		},
		triggerGoalOnEngage = true,
	}
	local enc_newEncounter = Encounter:Create(encData)
	
	return enc_newEncounter
end

-- Custom Encounters
ENCOUNTERS.Objective3_attackers = function()	
	local encData = {
		name = "Objective3_attackers",
		player = player3,
		spawn = {
			mkr_e_obj3_attackers_spawn1,
			mkr_e_obj3_attackers_spawn2,
			mkr_e_obj3_attackers_spawn3,
		},
		uniqueSpawns = true,
		sgroups = {},
		units = {
			{				
				name = "Objective_3_1",
				sbp = BP_GetSquadBlueprint("grenadier_squad_sp"),
				load = 4,		
			},
			{				
				name = "Objective_3_2",
				sbp = BP_GetSquadBlueprint("assault_grenadier_squad_mp"),	
			},
			{				
				name = "Objective_3_3",
				sbp = BP_GetSquadBlueprint("grenadier_squad_sp"),
				load = 4,
				--conditions = {XP1_GetNodeStrength() >= 3},			
			},
			{				
				name = "Objective_3_4",
				sbp = BP_GetSquadBlueprint("grenadier_squad_sp"),
				load = 4,		
			},
			{				
				name = "Objective_3_5",
				sbp = BP_GetSquadBlueprint("assault_grenadier_squad_mp"),	
			},
			{				
				name = "Objective_3_6",
				sbp = BP_GetSquadBlueprint("grenadier_squad_sp"),
				load = 4,
				--conditions = {XP1_GetNodeStrength() >= 3},			
			},
			{sbp = SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP},
			{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
			{sbp = SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP},
			{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
			{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
		},
		onDeath = nil,
		-- Goal
		triggerGoalOnEngage = true,
		triggerGoalDelay = 0.8,
		goal = {
			name = "Defend",
			target = {
				mkr_e_obj3_target1,
				mkr_e_obj3_target2,
				mkr_e_obj3_target3,
			},
			range = 25,
			leashRange = 12,
			onFailure = Despawn,
			fallbackParams = {
				thresholds = {0.3},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				retreat = true,
				markers = {mkr_obj3_defenders_dest2},
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
		} --]]
	}
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end

ENCOUNTERS.obj4_defenders1 = function()
	local encData = {
		name = "obj4_defenders1",
		player = player3,
		spawn = Util_GetRandomPosition(mkr_spawn_german_artillery1, 10),
		sgroups = {},
		units = {
			{
				--sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				sbp = BP_GetSquadBlueprint("assault_grenadier_squad_mp"),
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn2, 10),
			},
			{
				sbp = BP_GetSquadBlueprint("assault_grenadier_squad_mp"),
				--sgroups = {sg_flak_halftracks},
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn2, 10),
			},
			{
				name = "panzer",
				sbp = BP_GetSquadBlueprint("panzer_iv_squad"),
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn2, 10),
				difficulty = {GD_HARD},
			},
			{
				sbp = BP_GetSquadBlueprint("assault_grenadier_squad_mp"),
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn2, 10),
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				sbp = BP_GetSquadBlueprint("grenadier_squad_sp"),
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn2, 10),
				difficulty = {GD_HARD},
			},
			{
				name = "MG",
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_MP,
				--spawn = mkr_enemySpawnsHMG,
			},
			{
				name = "grens",
				sbp = BP_GetSquadBlueprint("panzer_grenadier_squad"),
				--spawn = mkr_enemySpawnsHMG,
			},			
		},
		goal = {
			name = "Defend",
			target = mkr_spawn_german_artillery1,
			leashRange = 20,
			coordinatedSetup = true,
			maxIdleTime = -1,
			retaliateAttackRange = 45,
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
			onFailure = Despawn,
		},
		triggerGoalOnEngage = true,
	}
	local enc_newEncounter = Encounter:Create(encData)
	
	return enc_newEncounter
end

ENCOUNTERS.obj4_defenders2 = function()
	local encData = {
		name = "obj4_defenders2",
		player = player3,
		spawn = Util_GetRandomPosition(mkr_spawn_german_artillery2, 10),
		sgroups = {},
		units = {
			{
				--sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				sbp = BP_GetSquadBlueprint("assault_grenadier_squad_mp"),
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn2, 10),
			},
			{
				sbp = BP_GetSquadBlueprint("assault_grenadier_squad_mp"),
				--sgroups = {sg_flak_halftracks},
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn2, 10),
			},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn2, 10),
				difficulty = {GD_HARD},
			},
			{
				sbp = BP_GetSquadBlueprint("panzer_grenadier_squad"),
				--spawn = mkr_enemySpawnsHMG,
			},
			{
				name = "MG",
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_MP,
				--spawn = mkr_enemySpawnsHMG,
			},
			{
				name = "grens",
				sbp = BP_GetSquadBlueprint("panzer_grenadier_squad"),
				--spawn = mkr_enemySpawnsHMG,
			},			
		},
		goal = {
			name = "Defend",
			target = mkr_spawn_german_artillery2,
			leashRange = 20,
			coordinatedSetup = true,
			maxIdleTime = -1,
			retaliateAttackRange = 45,
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
			onFailure = Despawn,
		},
		triggerGoalOnEngage = true,
	}
	local enc_newEncounter = Encounter:Create(encData)
	
	return enc_newEncounter
end

ENCOUNTERS.obj4_defenders3 = function()
	local encData = {
		name = "obj4_defenders3",
		player = player3,
		spawn = Util_GetRandomPosition(mkr_spawn_german_artillery3, 10),
		sgroups = {},
		units = {
			{
				--sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				sbp = BP_GetSquadBlueprint("assault_grenadier_squad_mp"),
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn2, 10),
			},
			{
				sbp = BP_GetSquadBlueprint("brummbar_squad"),
				--sgroups = {sg_flak_halftracks},
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn2, 10),
			},
			{
				sbp = BP_GetSquadBlueprint("stormtrooper_squad_mp"),
				--spawn = mkr_enemySpawnsHMG,
			},	
			{
				sbp = BP_GetSquadBlueprint("grenadier_squad_sp"),
				--spawn = Util_GetRandomPosition(mkr_obj3_defenders_spawn2, 10),
				difficulty = {GD_HARD},
			},
			{
				name = "MG",
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_MP,
				--spawn = mkr_enemySpawnsHMG,
			},
			{
				sbp = BP_GetSquadBlueprint("stormtrooper_squad_mp"),
				--spawn = mkr_enemySpawnsHMG,
			},			
		},
		goal = {
			name = "Defend",
			target = mkr_spawn_german_artillery3,
			leashRange = 20,
			coordinatedSetup = true,
			maxIdleTime = -1,
			retaliateAttackRange = 45,
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
			onFailure = Despawn,
		},
		triggerGoalOnEngage = true,
	}
	local enc_newEncounter = Encounter:Create(encData)
	
	return enc_newEncounter
end

--WaveDefense waves
--[[
ENCOUNTERS.Wave1 = function()
	return {
		encounters = {
			-- Direction 1 - These are split so they don't clump on spawn.
			{
				direction = 1, 
				units = {
					SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				},
			},
			{
				direction = 1, 
				units = {
					{
						sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
						--conditions = {XP1_GetNodeStrength() >= 3 and g_difficulty ~= GD_EASY},
					}
				},
			},
			
			-- Direction 2
			{
				direction = 2,
				units = {
					SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				}
			},
			{
				direction = 2,
				units = {
					{
						sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
						--conditions = {XP1_GetNodeStrength() >= 3 and g_difficulty ~= GD_EASY},
					}
				}
			},
			
			-- Direction 3
			{
				direction = 3,
				units = {
					SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				}
			},
			{
				direction = 3,
				units = {
					{
						sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
						--conditions = {XP1_GetNodeStrength() >= 3 and g_difficulty ~= GD_EASY},
					}
				}
			},
		},
	}
end -- ]]
