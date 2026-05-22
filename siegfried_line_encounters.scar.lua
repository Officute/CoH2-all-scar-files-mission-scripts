print("\tLoading encdata file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Siegfried Line - Encounters data
-- Designer: A.Molina
-------------------------------------------------------------------------
-------------------------------------------------------------------------
ENCOUNTERS = {}

---------------------------------
-- MAIN ROAD
---------------------------------
--Line1 - Left of main road - Mainly AT
ENCOUNTERS.Line1Left = function()
	local encData = {
		name = "line1_left",
		spawn = {mkr_line1_left01, mkr_line1_left03, mkr_line1_left04},
		uniqueSpawns = true,
		units = {
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				spawn = mkr_line1_left,
			},
			{
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP,
				spawn = mkr_line1_left02,
			},
		},
		intent = ENC_INTENT.medAntiTankDefense,
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_line1_left,
			range = 45,
			leashRange = mkr_line1_left,
			maxIdleTime = -1,
			retaliateAttackRange = 50,
			fallbackParams = {
				thresholds = {0.25},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_line3_left04},
				retreat = true,
			},
			onFailure = Despawn,
		},
		triggerGoalOnEngage = true,
		triggerGoalDelay = 1.5,
	}
	return Encounter:Create(encData)
end

--Line1 - Main road - Overall heavy defense
ENCOUNTERS.Line1Center = function()
	local encData = {
		name = "line1_center",
		spawn = {mkr_line1_center, mkr_line1_center02, mkr_line1_center05, mkr_line1_center06},
		uniqueSpawns = true,
		sgroups = {sg_line1},
		units = {
			{
				sbp = SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP,
				spawn = mkr_line1_center01,
				instantSetup = true,
			},
			{
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP,
				spawn = mkr_line1_center07,
			},
			{
				sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
				spawn = mkr_line1_center,
			},
		},
		intent = ENC_INTENT.medInfantry,
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_line1_center,
			range = 45,
			leashRange = mkr_line1_center,
			maxIdleTime = -1,
			retaliateAttacks = false,
			fallbackParams = {
				thresholds = {0.25},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_line3_left04},
				retreat = true,
			},
			onFailure = Despawn,
		},
		triggerGoalOnEngage = true,
		triggerGoalDelay = 1.5,
	}
	return Encounter:Create(encData)
end

ENCOUNTERS.Line1Tank = function()
	local encData = {
		name = "line1_tank",
		units = {
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
				spawn = mkr_line1_tank,
				upgrades = UPG.GERMAN.PANZER_TOP_GUNNER_MP,
				sgroups = {sg_line1},
			},
		},
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_line1_tank,
			range = 35,
--~ 			leashRange = mkr_line1_farm,
			maxIdleTime = -1,
			retaliateAttacks = true,
--~ 			fallbackParams = {
--~ 				thresholds = {0.25},
--~ 				thresholdType = Threshold_PercentageEntitiesRemaining,
--~ 				markers = {mkr_line3_left04},
--~ 				retreat = true,
--~ 			},
			onFailure = Despawn,
		},
		triggerGoalOnEngage = true,
		triggerGoalDelay = 2.0,
	}
	return Encounter:Create(encData)
end

ENCOUNTERS.Line1Farm = function()
	local encData = {
		name = "line1_farm",
		spawn = {mkr_line1_farm_01, mkr_line1_farm_02},
		uniqueSpawns = true,
		units = {
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				slotItems = SLOT_ITEM.PANZERSHRECK,
			},
		},
--~ 		intent = ENC_INTENT.medInfantry,
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_line1_farm,
			range = 35,
			leashRange = mkr_line1_farm,
			maxIdleTime = -1,
			retaliateAttacks = false,
			fallbackParams = {
				thresholds = {0.25},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_line3_left04},
				retreat = true,
			},
			onFailure = Despawn,
		},
		triggerGoalOnEngage = true,
		triggerGoalDelay = 2.0,
	}
	return Encounter:Create(encData)
end




---------------------------------
-- ARTILLERY
---------------------------------
ENCOUNTERS.Artillery_TreelineStatic = function(pos, blueprint, goal)
	local encData = {
		name = "artillery_treeline_static",
		spawn = pos,
		units = {
			{
				sbp = blueprint,
				instantSetup = true,
			},
		},
		onDeath = nil,
	}
	
	if(goal) then
		encData.goal = {
			name = "Defend",
			target = pos,
			range = 45,
			leashRange = 5,
			maxIdleTime = -1,
			fallbackParams = {
				thresholds = {0.25},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_retreat04},
				retreat = true,
			},
			onFailure = Despawn,
		}
		encData.triggerGoalOnAttacked = player1
		encData.triggerGoalDelay = 3.0
	end
	
	return Encounter:Create(encData)
end

ENCOUNTERS.Artillery_Treeline = function()
	local encData = {
		name = "artillery_treeline",
		spawn = {mkr_line1_top01, mkr_line1_top02},
		uniqueSpawns = true,
		units = {
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = mkr_line1_top03,
				slotItems = SLOT_ITEM.PANZERSHRECK_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = mkr_line1_top05,
				slotItems = SLOT_ITEM.DP_28_LIGHT_MACHINE_GUN_PACKAGE_MP,
			},
		},
		intent = ENC_INTENT.basicInfantry,
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_line1_top,
			range = 45,
			leashRange = mkr_line1_top,
			maxIdleTime = -1,
			retaliateAttackRange = 50,
			fallbackParams = {
				thresholds = {0.25},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_retreat04},
				retreat = true,
			},
			onFailure = Despawn,
		},
		triggerGoalOnAttacked = player1,
		triggerGoalDelay = 1.5,
	}
	return Encounter:Create(encData)
end

ENCOUNTERS.Artillery_DefendersVehicle = function()
	local encData = {
		name = "artilleryVehicle",
		units = {
			{
				sbp = SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP,
				spawn = mkr_artillery3_01,
			},
		},
		onDeath = nil,
		goal = {
			name = "Defend",
--~ 			target = Player_GetSquads(player1),
			range = 30,
			leashRange = mkr_artillery1,
			maxIdleTime = -1,
		},
		triggerGoalOnSight = player1,
		triggerGoalDelay = 3.0,
	}
	return Encounter:Create(encData)
end

ENCOUNTERS.Artillery_Defenders1 = function()
	local encData = {
		name = "artilleryDefenders1",
		spawn = {mkr_artillery1, mkr_artillery1_01, mkr_artillery1_02},
		uniqueSpawns = true,
		intent = ENC_INTENT.medInfantry,
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_artillery1,
			range = 30,
			leashRange = mkr_artillery1,
			maxIdleTime = -1,
			fallbackParams = {
				thresholds = {0.15},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_line3_left},
				retreat = true,
			},
			onFailure = Despawn,
		},
		triggerGoalOnAttacked = player1,
		triggerGoalDelay = 4.0,
	}
	return Encounter:Create(encData)
end

ENCOUNTERS.Artillery_Defenders2 = function()
	local encData = {
		name = "artilleryDefenders2",
		spawn = {mkr_artillery2, mkr_artillery2_02, mkr_artillery2_02, mkr_artillery2_03},
		uniqueSpawns = true,
		units = {
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			},
		},
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_artillery2,
			range = 30,
			leashRange = mkr_artillery2,
			retaliateAttacks = false,
			maxIdleTime = -1,
			fallbackParams = {
				thresholds = {0.15},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_line3_left},
				retreat = true,
			},
			onFailure = Despawn,
		},
		triggerGoalOnAttacked = player1,
		triggerGoalDelay = 4.0,
	}
	return Encounter:Create(encData)
end







---------------------------------
-- AA GUNS
---------------------------------
--Line1 - Bottom breach point - Mostly anti-infantry
ENCOUNTERS.Line1Right = function()
	local encData = {
		name = "line1_right",
		spawn = {mkr_line1_right01, mkr_line1_right02, mkr_line1_right03},
		uniqueSpawns = true,
--~ 		units = {
--~ 			{
--~ 				sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
--~ 				spawn = mkr_line1_right03,
--~ 				instantSetup = true,
--~ 			},
--~ 			{
--~ 				sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
--~ 				spawn = mkr_line1_right04,
--~ 				instantSetup = true,
--~ 			},
--~ 			{
--~ 				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
--~ 				slotItems = SLOT_ITEM.PANZERSHRECK_MP,
--~ 				spawn = mkr_line1_right01,
--~ 			},
--~ 		},
		intent = ENC_INTENT.medInfantry,
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_line1_right,
			range = 45,
			leashRange = mkr_line1_right,
			maxIdleTime = -1,
			retaliateAttackRange = 50,
			fallbackParams = {
				thresholds = {0.34},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_line3_right04},
				retreat = true,
			},
			onFailure = Despawn,
		},
		triggerGoalOnAttacked = true,
		triggerGoalDelay = 1.5,
	}
	return Encounter:Create(encData)
end

ENCOUNTERS.AA_ForestLeft_01 = function()
	local encData = {
		name = "AA_ForestLeft_01",
		spawn = {mkr_forestLeft, mkr_forestLeft_01, mkr_forestLeft_03},
		uniqueSpawns = true,
--~ 		units = {
--~ 			{
--~ 				sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
--~ 				spawn = mkr_forestLeft_02,
--~ 			},
--~ 			{
--~ 				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP,
--~ 				spawn = mkr_forestLeft_01,
--~ 			},
--~ 		},
		intent = ENC_INTENT.basicInfantry,
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_forestLeft,
			range = 35,
			leashRange = mkr_forestLeft,
			maxIdleTime = -1,
			fallbackParams = {
				thresholds = {0.25},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_line3_right},
				retreat = true,
			},
			onFailure = Despawn,
		},
		triggerGoalOnAttacked = player1,
		triggerGoalDelay = 2.0,
	}
	return Encounter:Create(encData)
end

ENCOUNTERS.AA_ForestLeft_02 = function()
	local encData = {
		name = "AA_ForestLeft_02",
		spawn = {mkr_forestLeft_04, mkr_forestLeft_05},
		uniqueSpawns = true,
		units = {
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
			},
		},
		onDeath = nil,
		goal = {
			name = "Attack",
			target = Player_GetSquads(player1),
			range = 25,
			leashRange = 30,
			maxIdleTime = -1,
			fallbackParams = {
				thresholds = {0.25},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_line3_right},
				retreat = true,
			},
			onFailure = Despawn,
		},
		triggerGoalOnAttacked = player1,
		triggerGoalDelay = 2.0,
	}
	return Encounter:Create(encData)
end

ENCOUNTERS.AA_ForestLeft_03 = function()
	local encData = {
		name = "AA_ForestLeft_03",
		spawn = {mkr_AAGun1_01, mkr_AAGun1_02, mkr_AAGun1_03},
		uniqueSpawns = true,
		units = {
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
			},
		},
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_AAGun1,
			range = 45,
			leashRange = mkr_AAGun1,
			maxIdleTime = -1,
			fallbackParams = {
				thresholds = {0.21},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_line3_right},
				retreat = true,
			},
			onFailure = Despawn,
		},
		triggerGoalOnAttacked = player1,
		triggerGoalDelay = 2.0,
	}
	return Encounter:Create(encData)
end


ENCOUNTERS.AA_ForestRight = function()
	local encData = {
		name = "AA_forestRight",
		spawn = {mkr_forestRight, mkr_forestRight_04},
		uniqueSpawns = true,
		intent = ENC_INTENT.basicInfantry,
		onDeath = nil,
		goal = {
			name = "Attack",
			target = mkr_forestRight_target,
			range = 20,
			leashRange = 30,
			maxIdleTime = -1,
			movePathLengthFactor = 1.0,
			safeMoveWeight = 0.0,
			fallbackParams = {
				thresholds = {0.25},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_line3_right},
				retreat = true,
			},
			onFailure = Despawn,
		},
		triggerGoalOnAttacked = player1,
		triggerGoalDelay = 1.0,
	}
	return Encounter:Create(encData)
end

ENCOUNTERS.AA_Gun2Armor = function()
	local encData = {
		name = "AA_Gun2Armor",
		units = {
			{
				sbp = SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP,
				spawn = mkr_forestRight_07,
			},
			{
				sbp = SBP.WEST_GERMAN.PANZER_IV_AUSF_J_BATTLE_GROUP_MP,
				spawn = mkr_forestRight_08,
			},
		},		
		onDeath = nil,
		goal = {
			name = "Defend",
			target = sg_enemyAA_2,
			range = 40,
			leashRange = 30,
			maxIdleTime = -1,
			movePathLengthFactor = 1.0,
			safeMoveWeight = 0.0,
		},
		triggerGoalOnSight = player1,
		triggerGoalDelay = 1.0,
	}
	return Encounter:Create(encData)
end

ENCOUNTERS.AA_ForestRight_02 = function()
	local units = {
		{
			sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
			slotItems = SLOT_ITEM.PANZERSHRECK_MP,
			spawn = mkr_forestRight_03,
		},
	}
	
	return ENCOUNTERS.StaticDefenders(mkr_forestRight_03, units, true, mkr_line3_right)
end

ENCOUNTERS.AA_ForestRight_HMG = function()
	local units = {
		{
			sbp = SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP,
			instantSetup = true,
			spawn = mkr_forestRight_01,
		},
	}
	
	return ENCOUNTERS.StaticDefenders(mkr_forestRight_01, units, true, mkr_line3_right)
end





---------------------------------
-- COMMAND BUNKER
---------------------------------
--Line3 - Left
ENCOUNTERS.Line3Left = function()
	local encData = {
		name = "line3_left",
		spawn = {mkr_line3_left, mkr_line3_left02, mkr_line3_left06, mkr_line3_left07},
		uniqueSpawns = true,
		intent = ENC_INTENT.medAntiTankDefense,
		onDeath = nil,
		goalData = {
			name = "Defend",
			target = mkr_line3_left,
			range = 45,
			leashRange = mkr_line3_left,
			maxIdleTime = -1,
			garrison = true,
			garrisonIdle = true,
			retaliateAttacks = false,
			fallbackParams = {
				thresholds = {0.15},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_retreat01},
				retreat = true,
			},
			onFailure = Despawn,
		},
--~ 		triggerGoalOnSight = true,
	}
	return Encounter:Create(encData)
end

ENCOUNTERS.Line3Left_Attack = function()
	local encData = {
		name = "line3_left_attack",
		units = {
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				spawn = {mkr_line3_left, mkr_line3_left02, mkr_line3_left03, mkr_line3_left06, mkr_line3_left07},
			},
			{
				sbp = SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP,
				spawn = mkr_line3_left03,
			},
		},
		onDeath = nil,
		goal = {
			name = "Attack",
			target = mkr_line3_left,
			range = 45,
--~ 			leashRange = 45,
			maxIdleTime = -1,
			garrison = true,
			garrisonIdle = true,
			onFailure = Despawn,
		},
		triggerGoalOnSight = true,
	}
	return Encounter:Create(encData)
end

ENCOUNTERS.Line3Tank = function()
	local encData = {
		name = "line3_tank",
		units = {
			{
				sbp = SBP.WEST_GERMAN.JAGDPANZER_TANK_DESTROYER_SQUAD_MP,
				spawn = mkr_line3_left04,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				sbp = SBP.WEST_GERMAN.PANTHER_AUSF_G_SQUAD_MP,
				spawn = mkr_line3_left04,
				difficulty = GD_HARD,
			},
		},
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_line3_left04,
--~ 			range = 45,
--~ 			leashRange = mkr_line3_left,
			maxIdleTime = -1,
		},
		triggerGoalOnSight = true,
	}
	return Encounter:Create(encData)
end


--Line3 - Center
ENCOUNTERS.Line3Center = function()
	local encData = {
		name = "line3_center",
		spawn = {mkr_line3_center01, mkr_line3_center02},
		uniqueSpawns = true,
--~ 		units = {
--~ 			{
--~ 				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
--~ 			},
--~ 		},
		intent = ENC_INTENT.medInfantry,
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_line3_center,
			range = 45,
			leashRange = mkr_line3_center,
			maxIdleTime = -1,
			fallbackParams = {
				thresholds = {0.25},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_retreat01},
				retreat = true,
			},
			onFailure = Despawn,
		},
		triggerGoalOnEngage = true,
	}
	return Encounter:Create(encData)
end

ENCOUNTERS.Line3Road = function()
	local encData = {
		name = "line3_center",
		spawn = {mkr_line3_road01, mkr_line3_road02},
		uniqueSpawns = true,
		units = {
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
			},
		},
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_line3_road,
			range = 45,
			leashRange = mkr_line3_road,
			maxIdleTime = -1,
			fallbackParams = {
				thresholds = {0.25},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_retreat01},
				retreat = true,
			},
			onFailure = Despawn,
		},
		triggerGoalOnEngage = true,
	}
	return Encounter:Create(encData)
end



--Line3 - Right
ENCOUNTERS.Line3Right = function()
	local encData = {
		name = "line3_Right",
		spawn = {mkr_line3_right, mkr_line3_right01, mkr_line3_right02, mkr_line3_right03},
		uniqueSpawns = true,
		units = {
			{
				sbp = SBP.WEST_GERMAN.PANTHER_AUSF_G_SQUAD_MP,
				spawn = mkr_line3_right04,
				difficulty = GD_HARD,
			},
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
				spawn = mkr_line3_right04,
				difficulty = {GD_EASY, GD_NORMAL},
			},
		},
		intent = ENC_INTENT.medInfantry,
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_line3_right,
			range = 45,
			leashRange = mkr_line3_right,
			maxIdleTime = -1,
			garrison = true,
			garrisonIdle = true,
			fallbackParams = {
				thresholds = {0.15},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_retreat03},
				retreat = true,
			},
			onFailure = Despawn,
		},
		triggerGoalOnEngage = true,
	}
	return Encounter:Create(encData)
end

-- Hill right side base
ENCOUNTERS.HillRight1 = function()
	local encData = {
		name = "hillRight1",
		spawn = {mkr_hillRight01, mkr_hillRight02, mkr_hillRight03},
		uniqueSpawns = true,
		intent = ENC_INTENT.medInfantry, 
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_hillRight,
			range = 35,
			leashRange = mkr_hillRight,
			maxIdleTime = -1,
			fallbackParams = {
				thresholds = {0.15},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_retreat02},
				retreat = true,
			},
			onFailure = Despawn,
		},
		triggerGoalOnSight = true,
		triggerGoalDelay = 1.5,
	}
	return Encounter:Create(encData)
end

-- Hill top
ENCOUNTERS.BunkerDefenders = function()
	local encData = {
		name = "bunkerDefenders",
		spawn = {mkr_commandBunker04, mkr_commandBunker01, mkr_commandBunker02, mkr_commandBunker02, mkr_commandBunker06},
		uniqueSpawns = true,
		units = {
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				spawn = mkr_commandBunker01,
				onDeath = ReplaceUnitBunker,
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = mkr_commandBunker02,
				onDeath = ReplaceUnitBunker,
			},
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				spawn = mkr_commandBunker03,
				onDeath = ReplaceUnitBunker,
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = mkr_commandBunker06,
				onDeath = ReplaceUnitBunker,
			},
		},
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_commandBunker,
			range = 45,
			leashRange = mkr_commandBunker,
			maxIdleTime = -1,
			garrison = false,
			garrisonIdle = false,
			fallbackParams = {
				thresholds = {0.15},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_bunkerSpawner},
				retreat = true,
			},
			onFailure = Despawn,
		},
		triggerGoalOnAttacked = player1,
		triggerGoalDelay = 1.5,
	}
	
	return Encounter:Create(encData)
end


--Units spawned from within the bunker
ENCOUNTERS.BunkerBoss = function()
	local encData = {
		name = "bunkerBoss",
		spawn = mkr_bunkerSpawner,
		sgroups = {sg_pillboxSquads},
		units = {
			{
				sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
			},
		},
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_commandBunker,
			leashRange = mkr_commandBunker,
--~ 			tacticControlsList = {
--~ 				{
--~ 					tacticType = TACTIC_Cover,
--~ 					priority = -1,
--~ 				}
--~ 			}
		},
	}
	return Encounter:Create(encData)
end


--Attack wave on start of DestroyBunker objective
ENCOUNTERS.GermanAttack = function(targetPosition)
	local encData = {
		name = "germanAttack",
		spawn = mkr_retreat01,
		dynamicSpawnTarget = mkr_hillLeft1,
		units = {
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.KING_TIGER_SQUAD_MP,
				upgrades = {UPG.WEST_GERMAN.KING_TIGER_TOP_GUNNER_MP},
			},
			--Diff dependant:
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				difficulty = {GD_EASY},
			},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				conditions = {g_difficulty ~= GD_EASY},
			},
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
				conditions = {g_difficulty ~= GD_EASY},
			},
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
				difficulty = {GD_HARD},
			},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				difficulty = {GD_HARD},
			},
		},
		onDeath = nil,
		goal = {
			name = "Attack",
			target = targetPosition,
			leashRange = 38,
			coordinatedSetup = true,
			coordinatedMoveRadius = 25,
			maxTime = -1,
			maxIdleTime = -1,
			movePathLengthFactor = 1.0,
			safeMoveWeight = 0.0,
			attackMove = true,
		},
	}
	return Encounter:Create(encData)
end





----------------------------------------------
-- COMMANDER STARTING UNITS
----------------------------------------------
--AIRBORNE
ENCOUNTERS.AirbornePreStartUnits = function()
	local encData = {
		name = "challengeUnits_Airborne",
		player = player1,
		units = {
			{
				sbp = SBP.AEF.PATHFINDER_SQUAD_MP,
				spawn = mkr_spawnArty_01,
			},
			{
				sbp = SBP.AEF.PATHFINDER_SQUAD_MP,
				spawn = mkr_spawnArty_03,
			},
			{
				sbp = SBP.AEF.PARATROOPER_SQUAD_MP,
				upgrades = UPG.AEF.ABILITY_LOCK_OUT_PARATROOPERS_LANDED,
				slotItems = SLOT_ITEM.BAZOOKA_MP,
				spawn = mkr_spawnArty_02,
			},
		},
	}
	
	return Encounter:Create(encData)
end

ENCOUNTERS.AirborneStartingUnits = function()
	local encData = {
		name = "challengeUnits_Airborne",
		player = player1,
		units = {
			{
				sbp = SBP.AEF.PARATROOPER_SQUAD_MP,
				upgrades = {UPG.AEF.PARATROOPER_THOMPSON_SUB_MACHINE_GUN_UPGRADE_MP, UPG.AEF.ABILITY_LOCK_OUT_PARATROOPERS_LANDED},
				spawn = mkr_spawnArty,
				moveTo = mkr_spawnArty_03,
			},
			{
				sbp = SBP.AEF.M20_UTILITY_CAR_SQUAD_MP,
				spawn = mkr_spawnArty,
				moveTo = mkr_spawnArty_06,
			},
			{
				sbp = SBP.AEF.M3_HALFTRACK_SQUAD_MP,
				spawn = mkr_spawnArty,
				moveTo = mkr_spawnArty_05,
			},
		},
	}
	
	return Encounter:Create(encData)
end


--SUPPORT
ENCOUNTERS.SupportPreStartUnits = function()
	
	local encData = {
		name = "challengeUnits_Support",
		player = player1,
		units = {
			{
				sbp = SBP.AEF.RIFLEMEN_SQUAD_MP,
				load = 3,
				spawn = mkr_camStart_AA,
			},
			{
				sbp = SBP.AEF.RIFLEMEN_SQUAD_MP,
				slotItems = SLOT_ITEM.RIFLEMEN_M1918_BAR_MP,
				spawn = mkr_spawnAA_01,
			},
			{
				sbp = SBP.AEF.DODGE_WC51_AMBULANCE_SQUAD_MP,
				spawn = mkr_spawnAA,
			},
			{
				sbp = SBP.AEF.M1_57MM_AT_GUN_SQUAD_MP,
				spawn = mkr_spawnAA_03,
			},
		}
	}
	
	return Encounter:Create(encData)
end

ENCOUNTERS.SupportStartingUnits = function()
	-- If the player has the extra unit upgrade, we need to spawn the right squad
	local assaultEngy = SBP.AEF.ASSAULT_ENGINEER_SQUAD_MP
	if Player_HasUpgrade(Game_GetLocalPlayer(), BP_GetUpgradeBlueprint("pm_assault_engineer_extra_entity")) then
		assaultEngy = SBP.AEF.ASSAULT_ENGINEER_SQUAD_5_MAN_MP
	end
	
	local encData = {
		name = "challengeUnits_Support",
		player = player1,
		units = {
			{
				sbp = assaultEngy,
				spawn = mkr_spawnAA_road,
				moveTo = mkr_spawnAA_04,
			},
			{
				sbp = assaultEngy,
				slotItems = SLOT_ITEM.BAZOOKA_MP,
				spawn = mkr_spawnAA,
				moveTo = mkr_spawnAA_06,
			},
			{
				sbp = SBP.AEF.REAR_ECHELON_SQUAD_MP,
				spawn = mkr_spawnAA,
				moveTo = mkr_camStart_AA,
			},
			{
				sbp = SBP.AEF.M20_UTILITY_CAR_SQUAD_MP,
				spawn = mkr_spawnAA,
				moveTo = mkr_spawnAA_02,
			},
			{
				sbp = SBP.AEF.DODGE_WC51_50CAL_SQUAD_MP,
				spawn = mkr_spawnAA_road,
				moveTo = mkr_spawnAA_05,
			},
		}
	}
	
	return Encounter:Create(encData)
end


--MECHANIZED
ENCOUNTERS.MechanizedPreStartUnits = function()
	local encData = {
		name = "challengeUnits_Mechanized",
		player = player1,
		units = {
			{
				sbp = SBP.AEF.RIFLEMEN_SQUAD_MP,
				slotItems = SLOT_ITEM.RIFLEMEN_M1918_BAR_MP,
				spawn = mkr_spawnRoad_02,
			},
			{
				sbp = SBP.AEF.M8_GREYHOUND_SQUAD_MP,
				spawn = mkr_spawnRoad_01,
			},
			{
				sbp = SBP.AEF.M1_57MM_AT_GUN_SQUAD_MP,
				spawn = mkr_spawnRoad_03,
			},
			{
				sbp = SBP.AEF.M4A3_SHERMAN_SQUAD_MP,
				entityUpgrades = UPG.AEF.SHERMAN_TOP_GUNNER_MP,
				spawn = mkr_spawnRoad_04,
			},
		},
	}
	
	return Encounter:Create(encData)
end

ENCOUNTERS.MechanizedStartingUnits = function()
	local encData = {
		name = "challengeUnits_Mechanized",
		player = player1,
		units = {
			{
				sbp = SBP.AEF.RIFLEMEN_SQUAD_MP,
				numSquads = 2,
				spawn = mkr_spawnRoad,
				moveTo = mkr_camStart_road,
			},
			{
				sbp = SBP.AEF.REAR_ECHELON_SQUAD_MP,
				slotItems = SLOT_ITEM.RIFLEMEN_M1918_BAR_MP,
				spawn = mkr_spawnRoad,
				moveTo = mkr_spawnRoad_06,
			},
			{
				sbp = SBP.AEF.M36_TANK_DESTROYER_SQUAD_MP,
				spawn = mkr_spawnRoad,
				moveTo = mkr_spawnRoad_05,
			},
		},
	}
	
	return Encounter:Create(encData)
end


--RECON
-- Recon prestart units are the same as the original commanders.
ENCOUNTERS.ReconPreStartUnits = function()
	local encData = {
		name = "challengeUnits_Recon",
		player = player1,
	}
	
	if g_currentChallenge == 1 then
		-- Artillery
		encData.units = {
			{
				sbp = SBP.AEF.RANGER_SQUAD_MP,
				spawn = mkr_spawnArty,
				moveTo = mkr_spawnArty_03,
			},
			{
				sbp = SBP.AEF.RIFLEMEN_SQUAD_MP,
				spawn = mkr_spawnArty,
				moveTo = mkr_spawnArty_06,
			},
			{
				sbp = SBP.AEF.RIFLEMEN_SQUAD_MP,
--~ 				spawn = mkr_spawnArty,
				spawn = mkr_spawnArty_05,
			},
		}
		
	elseif g_currentChallenge == 2 then
		-- Road
		encData.units = {
			{
				sbp = SBP.AEF.RIFLEMEN_SQUAD_MP,
				slotItems = SLOT_ITEM.RIFLEMEN_M1918_BAR_MP,
				spawn = mkr_spawnRoad_02,
			},
			{
				sbp = SBP.AEF.M8_GREYHOUND_SQUAD_MP,
				spawn = mkr_spawnRoad_01,
			},
			{
				sbp = SBP.AEF.M1_57MM_AT_GUN_SQUAD_MP,
				spawn = mkr_spawnRoad_03,
			},
			{
				sbp = SBP.AEF.M4A3_SHERMAN_SQUAD_MP,
				entityUpgrades = UPG.AEF.SHERMAN_TOP_GUNNER_MP,
				spawn = mkr_spawnRoad_04,
			},
		}
		
	elseif g_currentChallenge == 3 then
		-- AA Guns
		encData.units = {
			{
				sbp = SBP.AEF.REAR_ECHELON_SQUAD_MP,
				spawn = mkr_camStart_AA,
			},
			{
				sbp = SBP.AEF.RIFLEMEN_SQUAD_MP,
				slotItems = SLOT_ITEM.RIFLEMEN_M1918_BAR_MP,
				spawn = mkr_spawnAA_01,
			},
			{
				sbp = SBP.AEF.DODGE_WC51_AMBULANCE_SQUAD_MP,
				spawn = mkr_spawnAA,
			},
			{
				sbp = SBP.AEF.M1_57MM_AT_GUN_SQUAD_MP,
				spawn = mkr_spawnAA_03,
			},
		}
		
	end
	
	return Encounter:Create(encData)
end

-- In order to account for different starting slots, DLC commander units need to have conditional encounter units
-- 'override' parameter is only used for debug purposes.
ENCOUNTERS.ReconStartingUnits = function(override)
	
	local _challengeIndex = override or g_currentChallenge
	local _spawnStart = t_challengeData[_challengeIndex].spawnStart
	local _spawnPositions = t_challengeData[_challengeIndex].spawnPositions
	
	local encData = {
		name = "challengeUnits_Recon",
		player = player1,
		units = {
			{
				sbp = SBP.AEF.RANGER_SQUAD_MP,
				spawn = _spawnStart,
				moveTo = _spawnPositions[2],
			},
			{
				sbp = SBP.AEF.REAR_ECHELON_SQUAD_MP,
				spawn = _spawnStart,
				moveTo = _spawnPositions[1],
			},
			{
				sbp = SBP.AEF.M20_UTILITY_CAR_SQUAD_MP,
				spawn = _spawnStart,
				moveTo = _spawnPositions[6],
			},
			--ARTILLERY
			{
				sbp = SBP.AEF.M3_HALFTRACK_SQUAD_MP,
				spawn = mkr_spawnArty,
				moveTo = mkr_spawnArty_05,
				conditions = {_challengeIndex == 1}
			},
			--AA GUNS
			{
				sbp = SBP.AEF.REAR_ECHELON_SQUAD_MP,
				spawn = mkr_spawnAA,
				moveTo = _spawnPositions[2],
				conditions = {_challengeIndex == 3}
			},
		},
	}
	
	return Encounter:Create(encData)
end



---------------------------------
-- MISC. ENCOUNTERS
---------------------------------
--Generic encounter used to spawn units that sit still but have AI.
ENCOUNTERS.StaticDefenders = function(pos, unitsData, hasGoal, retreatPoint)
	local encData = {
		name = "staticDefender",
		spawn = pos,
		units = {},
		onDeath = nil,
	}
	
	for k,v in pairs(unitsData) do
		table.insert(encData.units, v)
	end
	
	if(hasGoal) then
		encData.goal = {
			name = "Defend",
			target = pos,
			range = 30,
			leashRange = 5,
			maxIdleTime = -1,
			retaliateAttacks = false,
			fallbackParams = {
				thresholds = {0.21},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {retreatPoint},
				retreat = true,
			},
			onFailure = Despawn,
		}
		encData.triggerGoalOnAttacked = player1
		encData.triggerGoalDelay = 3.0
	end
	
	return Encounter:Create(encData)
end







--SHARED GOALS
GOALS = {}

GOALS.DefendLocation = function(encounter, position)
	local goalData = {
		name = "Defend",
		target = Util_GetPosition(position),
		range = 35,
		leashRange = 25,
--~ 		fallbackParams = {
--~ 			thresholds = {0.21},
--~ 			thresholdType = Threshold_PercentageEntitiesRemaining,
--~ 			markers = {mkr_allySpawn01},
--~ 			retreat = true,
--~ 		},
		maxIdleTime = -1,
		maxTime = -1,
		onFailure = Despawn,
	}
	
	encounter:SetGoal(goalData)
end

GOALS.AlliedAttackBunker = function(encounter)
	local goalData = {
		name = "Attack",
		target = mkr_commandBunker04,
		range = 55,
		leashRange = 50,
--~ 		fallbackParams = {
--~ 			thresholds = {0.21},
--~ 			thresholdType = Threshold_PercentageEntitiesRemaining,
--~ 			markers = {mkr_allySpawn01},
--~ 			retreat = true,
--~ 		},
		maxIdleTime = -1,
		maxTime = -1,
		attackMove = true,
		movePathLengthFactor = 1.0,
		safeMoveWeight = 0.0,
		coordinatedSetup = false,
--~ 		onFailure = Despawn,
	}
	
	encounter:SetGoal(goalData)
end
