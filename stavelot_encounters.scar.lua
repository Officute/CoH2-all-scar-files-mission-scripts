print("\tLoading encounters file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- MISSION NAME - Encounters data
-- Designer: A.Molina
-------------------------------------------------------------------------
-------------------------------------------------------------------------
ENCOUNTERS = {}

--Main plaza in front of the player base.
ENCOUNTERS.plaza = function()
	local encData = {
		name = "plaza",
		units = {
			{
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				--sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = mkr_plaza,
			},
			{
				sbp = SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP,
				sgroups = {sg_flak_halftracks},
				spawn = mkr_plaza_ht,
				conditions = {g_flak_halftracks == true},
			},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				spawn = Util_GetRandomPosition(mkr_plaza_reinforce, 10),
				conditions = {XP1_GetNodeStrength() >= 5},
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = Util_GetRandomPosition(mkr_plaza_ht, 5),
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				spawn = Util_GetRandomPosition(mkr_plaza_ht, 5),
				difficulty = {GD_HARD},
			},		
		},
		goal = {
			name = "Defend",
			target = mkr_plaza,
			leashRange = mkr_plaza,
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
				markers = {mkr_mainBridge},
				retreat = true,
			},
			onFailure = Despawn,
		},
		triggerGoalOnEngage = true,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end

--Ruins area in the center of the map
ENCOUNTERS.ruins = function()
	local encData = {
		name = "ruins",
		units = {
			{
				--sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				spawn = mkr_ruins_1,
				difficulty = {GD_EASY},
			},
			{
				--sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				spawn = mkr_ruins_1,
				difficulty = {GD_NORMAL, GD_HARD},
			},
			
--~ 			{
--~ 				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,				
--~ 				spawn = mkr_ruins_4,
--~ 			},
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				spawn = mkr_ruins_2,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},			
				spawn = mkr_ruins_2,
				difficulty = {GD_HARD},
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = mkr_ruins,
				conditions = {XP1_GetNodeStrength() >= 4}
			},
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				spawn = mkr_ruins_3,
				conditions = {XP1_GetNodeStrength() >= 5}
			},
		},
		goal = {
			name = "Defend",
			target = mkr_ruins,
			range = 45,
			leashRange = 35,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {mkr_plaza_hmg, mkr_plaza_ht},
			maxIdleTime = -1,
		},
		triggerGoalOnEngage = true,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end

ENCOUNTERS.ruinsMortar1 = function() --GD_HARD or node>=4
	local encData = {
		name = "ruins_Mortar",
		units = {
			{
				sbp =  SBP.WEST_GERMAN.LE_IG_18_INF_SUPPORT_GUN_SQUAD_MP,
				sgroups = {sg_ruinsMortarLeft, sg_ruinsMortars},
				spawn = mkr_ruins_mortar1,
				conditions = {g_mortars == true},
			},
--~ 			{
--~ 				sbp =  SBP.WEST_GERMAN.LE_IG_18_INF_SUPPORT_GUN_SQUAD_MP,
--~  				sgroups = {sg_ruinsMortarRight, sg_ruinsMortars},
--~ 				spawn = mkr_ruins_mortar2,
--~ 				conditions = {g_mortars == true},				
--~ 			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end

ENCOUNTERS.ruinsAT= function()
	local encData = {
		name = "ruins_AT",
		units = {
			{
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP,
				spawn = mkr_ruins_AT,
				difficulty = {XP1_GetNodeStrength() >= 2},
			},
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				spawn = mkr_ruins_AT,
				conditions = {XP1_GetNodeStrength() >= 4},
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				spawn = mkr_ruins_AT,
				conditions = {XP1_GetNodeStrength() >= 4},
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0.5, exclusive = nil}},				
				difficulty = {GD_HARD},
			},
		},
		goal = {
			name = "Defend",
			target = mkr_ruins_AT,
			range = 35,
			leashRange = 10,
			coordinatedSetup = false,
			maxIdleTime = -1,
		},
		triggerGoalOnEngage = true,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end

ENCOUNTERS.tankRuins = function()
	local encData = {
		name = "tankFuel3",
		spawn = mkr_retreat3,
		dynamicSpawnTarget = mkr_ruinsTank_altSpawn, --mkr_mainBridge,
		moveTo = mkr_ruins_tank,
		attackMoveTo = true,
		units = {
			{
				sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
				conditions = {g_tanks == false},
			},
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
				conditions = {g_tanks == true},
				upgrades = (g_difficulty == GD_HARD and UPG.GERMAN.PANZER_TOP_GUNNER_MP or nil)
			},
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end



-- Static units protecting the fuel depot
ENCOUNTERS.fuelStaticWeapons = function()
	local encData = {
		name = "fuelPointHMG",
		units = {
			{
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_MP,
				spawn = eg_garrison_fuelL,
				conditions = {eg_fuelLocation == eg_fuelLeft},
			},
			{
				sbp =  SBP.WEST_GERMAN.LE_IG_18_INF_SUPPORT_GUN_SQUAD_MP,
				spawn = mkr_fuelL_mortar,
				conditions = {eg_fuelLocation == eg_fuelLeft and g_mortars == true},
			},
			{
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_MP,
				spawn = eg_garrison_fuelR,
				conditions = {eg_fuelLocation == eg_fuelRight},
			},
			{
				sbp =  SBP.WEST_GERMAN.LE_IG_18_INF_SUPPORT_GUN_SQUAD_MP,
				spawn = mkr_fuelR_mortar,
				conditions = {eg_fuelLocation == eg_fuelRight and g_mortars == true},
			},
		},
	}
	return XP1_EncounterCreate(encData)
end



--LEFT FuelPoint
ENCOUNTERS.fuelLeft = function()
	local encData = {
		name = "fuelLeft",
		units = {
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				sgroups = {sg_lureLeft},
				spawn = Util_GetRandomPosition(mkr_fuelL, 8),
				conditions = {eg_fuelLocation == eg_fuelLeft},
				difficulty = {GD_EASY},
			},
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				sgroups = {sg_lureLeft},
				spawn = Util_GetRandomPosition(mkr_fuelL, 8),
				conditions = {eg_fuelLocation == eg_fuelLeft},
				difficulty = {GD_NORMAL},
			},
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				sgroups = {sg_lureLeft},
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},	
				spawn = Util_GetRandomPosition(mkr_fuelL, 8),
				conditions = {eg_fuelLocation == eg_fuelLeft},				
				difficulty = {GD_HARD}, 
			},		
			
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				spawn = Util_GetRandomPosition(mkr_fuelL, 10),
			},
			{
				sbp = SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP,
				sgroups = eg_fuelLocation == eg_fuelLeft and {sg_lure1} or nil,
				conditions = {g_flak_halftracks == false},
				spawn = mkr_fuelL_04,
			},
			{
				sbp = SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP,
				sgroups = eg_fuelLocation == eg_fuelLeft and {sg_lure1} or nil,
				conditions = {g_flak_halftracks == true},
				spawn = mkr_fuelL_04,
			},
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				spawn = mkr_fuelL_06,
				conditions = {eg_fuelLocation == eg_fuelLeft},
			},
			{
--~ 				sbp = SBP.WEST_GERMAN.RAKETENWERFER43_88MM_PUPPCHEN_ANTITANK_GUN_SQUAD_MP,
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP,
				spawn = mkr_fuelL_02,
				conditions = {eg_fuelLocation == eg_fuelLeft},
			},
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				spawn = mkr_fuelL_03,
				difficulty = {GD_EASY},
			},
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				spawn = mkr_fuelL_03,
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0.5, exclusive = nil}},		
				difficulty = {GD_NORMAL, GD_HARD},
			},
		},
		onDeath = nil,
		goal = {
			name = "Defend",
			target = EGroup_GetPosition(eg_fuelLeft),
			range = 45,
			leashRange = mkr_fuelL,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {mkr_ruins_3, mkr_fuelL_05},
			maxIdleTime = -1,
		},
		triggerGoalOnEngage = true,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end

ENCOUNTERS.fuelLeftPerimeter = function()
	local encData = {
		name = "fuelLeftPerimeter",
		units = {
			{
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),				
				--sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				spawn = Util_GetRandomPosition(mkr_fuelL_inf, 10),
				conditions = {eg_fuelLocation == eg_fuelLeft},
				difficulty = {GD_EASY},
			},
			{
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),				
				--sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},	
				spawn = Util_GetRandomPosition(mkr_fuelL_inf, 10),
				conditions = {eg_fuelLocation == eg_fuelLeft},
				difficulty = {GD_NORMAL, GD_HARD},
			},

			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				spawn = Util_GetRandomPosition(mkr_fuelL_inf, 10),
--~ 				conditions = {eg_fuelLocation == eg_fuelLeft},
			},
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
				spawn = mkr_fuelL_05,
				conditions = {eg_fuelLocation == eg_fuelLeft and g_tanks == true},
				upgrades = (g_difficulty == GD_HARD and UPG.GERMAN.PANZER_TOP_GUNNER_MP or nil)
			},
			{
				sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
				spawn = mkr_fuelL_05,
				conditions = {eg_fuelLocation == eg_fuelLeft and g_tanks == false},
			},
		},
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_fuelL_inf,
			range = 35,
			leashRange = mkr_fuelL_inf,
			coordinatedSetup = false,
			maxIdleTime = -1,
		},
		triggerGoalOnEngage = true,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end


--RIGHT fuelpoint
ENCOUNTERS.fuelRight = function()
	local encData = {
		name = "fuelRight",
		units = {
			
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				sgroups = {sg_lureRight},
				spawn = mkr_fuelR_04,
				difficulty = {GD_EASY},
			},
			
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				sgroups = {sg_lureRight},
				spawn = mkr_fuelR_04,
				difficulty = {GD_NORMAL},
			},
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				sgroups = {sg_lureRight},
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},	
				spawn = mkr_fuelR_04,
				difficulty = {GD_HARD},
			},
			
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				spawn = Util_GetRandomPosition(mkr_fuelR, 10),
			},
			{
				sbp = SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP,
				sgroups = eg_fuelLocation == eg_fuelRight and {sg_lure1} or nil,
				conditions = {g_flak_halftracks == false},
				spawn = mkr_fuelR_01,
			},
			{
				sbp = SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP,
				sgroups = eg_fuelLocation == eg_fuelRight and {sg_lure1} or nil,
				conditions = {g_flak_halftracks == true},
				spawn = mkr_fuelR_01,
			},
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				spawn = mkr_fuelR_05,
				conditions = {eg_fuelLocation == eg_fuelRight},
			},
			{
--~ 				sbp = SBP.WEST_GERMAN.RAKETENWERFER43_88MM_PUPPCHEN_ANTITANK_GUN_SQUAD_MP,
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP,
				spawn = mkr_fuelR_03,
				conditions = {eg_fuelLocation == eg_fuelRight},
			},
			
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				difficulty = {GD_EASY},
				spawn = mkr_fuelR_02,
			},
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0.5, exclusive = nil}},		
				difficulty = {GD_NORMAL, GD_HARD},
				spawn = mkr_fuelR_02,
			},
		},
		onDeath = nil,
		goal = {
			name = "Defend",
			target = eg_fuelRight,
			range = 55,
			leashRange = mkr_fuelR,
			retaliateAttacks = false,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {mkr_supplyRight},
			garrisonIdle = true,
			maxIdleTime = -1,
		},
		triggerGoalOnEngage = true,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end

ENCOUNTERS.fuelRightPerimeter = function()
	local encData = {
		name = "fuelRightPerimeter",
		units = {
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				spawn = Prox_GetRandomPosition(mkr_fuelR_06, 15, 10),
			},
			{
				--sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),				
				spawn = Prox_GetRandomPosition(mkr_fuelR_06, 15, 10),
				difficulty = {GD_EASY},
				conditions = {eg_fuelLocation == eg_fuelRight},
			},
						{
				--sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),				
				spawn = Prox_GetRandomPosition(mkr_fuelR_06, 15, 10),
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},	
				difficulty = {GD_NORMAL, GD_HARD},
				conditions = {eg_fuelLocation == eg_fuelRight},
			},
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
				spawn = mkr_fuelR_06,
				conditions = {eg_fuelLocation == eg_fuelRight and g_tanks == true},
				upgrades = (g_difficulty == GD_HARD and UPG.GERMAN.PANZER_TOP_GUNNER_MP or nil)
			},
			{
				sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
				spawn = mkr_fuelR_06,
				conditions = {eg_fuelLocation == eg_fuelRight and g_tanks == false},
			},
		},
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_fuelR_06,
			range = 35,
			leashRange = mkr_fuelR_06,
			coordinatedSetup = false,
			maxIdleTime = -1,
		},
		triggerGoalOnEngage = true,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end


--Counterattack if defenders are low on health
ENCOUNTERS.ReinforceFuel = function(spawnLoc, targetLoc)
	local encData = {
		name = "reinforceFuelLeft",
		spawn = spawnLoc,
		units = {
			{
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				onDeath = ReplaceUnit,
			},
			
			
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				onDeath = ReplaceUnit,
			},
			
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 3},
				onDeath = ReplaceUnit,
			},
			{
				sbp = SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 4},
			},
		},
		onDeath = nil,
		goal = {
			name = "Defend",
			target = targetLoc,
			range = 45,
			leashRange = 35,
			tacticControlList = {
				{tacticType = TACTIC_Cover, priority = 500},				
				{tacticType = TACTIC_CapturePoint, priority = 300},				
				{tacticType = TACTIC_Ability, priority = 100},
			},
			
			coordinatedSetup = false,
			maxIdleTime = -1,
		},
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end




-- LEFT Supply territory
ENCOUNTERS.SupplyLeft = function()
	local encData = {
		name = "supplyLeft",
		units = {
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				spawn = mkr_supplyLeft,
			},
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				spawn = mkr_supplyLeft_01,
			},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				spawn = mkr_supplyLeft_03,
				conditions = {XP1_GetNodeStrength() >= 4 and eg_fuelLocation == eg_fuelLeft}
			},
		},
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_supplyLeft,
			range = 50,
			leashRange = mkr_supplyLeft,
			coordinatedSetup = false,
			garrison = true,
			maxIdleTime = -1,
		},
		triggerGoalOnEngage = true,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end

ENCOUNTERS.ReinforceSupplyLeft = function()
	local encData = {
		name = "supplyReinforceLeft",
		spawn = mkr_retreat3,
		dynamicSpawnTarget = mkr_supplyLeft_02,
		moveTo = mkr_supplyLeft_02,
		attackMoveTo = true,
		units = {
			{
				sbp = SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP,
				conditions = {g_flak_halftracks == true},
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {g_flak_halftracks == false},
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				difficulty = {GD_HARD},
			},
		},
		goal = {
			name = "Defend",
			target = mkr_supplyLeft,
			range = 50,
			leashRange = mkr_supplyLeft,
			coordinatedSetup = false,
			maxIdleTime = -1,
		},
		triggerGoalOnEngage = true,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end



-- RIGHT Supply territory
ENCOUNTERS.SupplyRight = function()
	local encData = {
		name = "supplyRight",
		units = {
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				spawn = mkr_supplyRight_02,
			},
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				spawn = mkr_supplyRight_03,
			},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				spawn = mkr_supplyRight_01,
				conditions = {XP1_GetNodeStrength() >= 4 and eg_fuelLocation == eg_fuelRight}
			},
		},
		onDeath = nil,
		goal = {
			name = "Defend",
			target = mkr_supplyRight,
			range = 50,
			leashRange = mkr_supplyRight,
			coordinatedSetup = false,
			maxIdleTime = -1,
		},
		triggerGoalOnEngage = true,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end

ENCOUNTERS.ReinforceSupplyRight = function()
	local encData = {
		name = "supplyReinforceRight",
		spawn = mkr_retreat2,
		dynamicSpawnTarget = mkr_mainBridge,
		moveTo = mkr_supplyRight_03,
		attackMoveTo = true,
		units = {
			{
				sbp = SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP,
				conditions = {g_flak_halftracks == true},
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {g_flak_halftracks == false},
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				difficulty = {GD_HARD},
			},
		},
		goal = {
			name = "Defend",
			target = mkr_supplyRight,
			range = 50,
			leashRange = mkr_supplyRight,
			coordinatedSetup = false,
			maxIdleTime = -1,
		},
		triggerGoalOnEngage = true,
		onDeath = nil,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end



ENCOUNTERS.NorthCrossroads = function()
	local encData = {
		name = "northcrossroads",
		units = {
			{
				--sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				spawn = mkr_northCrossroads_1,
			},
			{
				sbp = SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP,
				spawn = mkr_northCrossroads_2				
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = mkr_northCrossroads_3,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				spawn = mkr_northCrossroads_3,
				difficulty = {GD_HARD},
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = mkr_northCrossroads_4,
				conditions = {XP1_GetNodeStrength() >= 4},
			},

		},
		goal = {
			name = "Defend",
			target = mkr_northCrossroadsArea,
			range = 45,
			leashRange = 35,
			tacticControlList = {
				{tacticType = TACTIC_Cover, priority = 200},
			},
			maxIdleTime = -1,
		},
		triggerGoalOnEngage = true,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end



ENCOUNTERS.NorthWestCrossroads = function()
	local encData = {
		name = "northwestcrossroads",
		units = {
			{
				--sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				spawn = mkr_northWestCrossroads_1,
			},
			{
				sbp = SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP,
				spawn = mkr_northWestCrossroads_2				
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = mkr_northWestCrossroads_3,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				spawn = mkr_northWestCrossroads_3,
				difficulty = {GD_HARD},
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = mkr_northWestCrossroads_4,
				conditions = {XP1_GetNodeStrength() >= 4}
			},

		},
		goal = {
			name = "Defend",
			target = mkr_northWestCrossroadsArea,
			range = 45,
			leashRange = 35,
			tacticControlList = {
				{tacticType = TACTIC_Cover, priority = 200},
			},
			maxIdleTime = -1,
		},
		triggerGoalOnEngage = true,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData)
	
	return enc_newEncounter
end



-- Supply truck defenders
ENCOUNTERS.TruckDefenders = function(spawnLoc, defendTarget, level)
	local encData = {
		name = "truckDefenders",
		spawn = spawnLoc,
--~ 		dynamicSpawnTarget = Util_GetOffsetPosition(defendTarget, OFFSET_BACK, 6),
--~ 		dynamicSpawnTarget = g_truckDynSpawn,
		dynamicSpawnTarget = g_defDynSpawn,
		units = {
			{
				sbp = SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP,
				conditions = {level == 2},
			},
			{
				sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
				conditions = {level == 3},
			},
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
				upgrades = UPG.GERMAN.PANZER_TOP_GUNNER_MP,
				conditions = {level >= 4 and g_tanks == true},
			},
			{
				sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
				conditions = {level >= 4 and g_tanks == false},
			},
		},
		goal = {
			name = "Move",
			target = g_defDest, --g_truckDest
			range = 5, -- 35
			leashRange = 5, -- 17
			attackMove = true,
			coordinatedSetup = false,
			maxIdleTime = -1,
			maxTime = -1,
--~ 	 		onFailure = GOALS.defendPosition,
		},
		--triggerGoalOnEngage = true,
	}
	return XP1_EncounterCreate(encData)
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
			},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
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
			SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
			SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
		},
		onDeath = nil,
	}
	encID_newEncounter = XP1_EncounterCreate(encData)
	
	return encID_newEncounter
end




GOALS = {}

-- A goal that will be assigned to multiple encounters throughout the course of a single mission
GOALS.defendPosition = function(encounter)
	if SGroup_CountSpawned(encounter:GetSgroup()) > 0 then
		print("Encounter " .. encounter.data.name .. " switching to defense...")
		
		local goalData = {
			name = "Defend",
			range = 45,
			leashRange = 30,
			maxIdleTime = -1,
			maxTime = -1,
		}
		encounter:SetGoal(goalData)
	end
end

GOALS.moveToExit = function(encounter)
	if SGroup_CountSpawned(encounter:GetSgroup()) > 0 then
		print("Ordering " .. encounter.data.name .. " to exit map")
		local goalData = {
			name = "Move",
			target = t_pathTrucks.exitPt,
			range = 10,
			leashRange = 10,
			attackMove = true,
			movePathLengthFactor = 1,
			safeMoveWeight = 0,
			maxTime = -1,
			maxIdleTime = -1,
			onSuccess = Despawn,
		}
		encounter:SetGoal(goalData)
	end
end

