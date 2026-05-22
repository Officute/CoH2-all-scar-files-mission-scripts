print("\tLoading encdata file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- MISSION NAME - Encounters data
-- Designer: Joe Smith
-------------------------------------------------------------------------
-------------------------------------------------------------------------
ENCOUNTERS = {}

-- Similar to the EVENTS file, each of these creates an encounter and returns a reference.
-- Remember to add a simple description for each encounter.

ENCOUNTERS.EnemySanatorium_1 = function()
	local encData = {
		name = "EnemySanatorium_1",
		sgroups = {sg_enemySanatoriumTroops},
		spawn = {mkr_sanatoriumDef1},
		units = {


			{				
				name = "EnemySanatorium_1",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
--~ 				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
--~ 				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},						
--~ 				difficulty = {GD_EASY, GD_NORMAL},
				spawn = mkr_sanatoriumDef1_spawn,
				conditions = {g_stronger_enemy_positions == false},
			},
			{				
				name = "EnemySanatorium_1",
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,											
				spawn = mkr_sanatoriumDef1_spawn,
				conditions = {g_stronger_enemy_positions == true},
				difficulty = {GD_NORMAL, GD_HARD},
			},
			
			{				
				name = "EnemySanatorium_1",
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				spawn = mkr_sanatoriumDef1_spawn,
				conditions = {g_stronger_enemy_positions == true},
				difficulty = {GD_EASY},
			},


		},		
		
--~ 		triggerGoalOnEngage = true,
--~ 		goal = {
--~ 			name = "Defend",
--~ 			target = mkr_sanatoriumDef1,
--~ 			--garrisonIdle = true,
--~ 			--garrison = true,
--~ 			range = 20,
--~ 			leashRange = 20,
--~ 			retaliateAttacks = false,
--~ 			instantSetup = true,
--~ 			tacticControlList = {
--~ 				{tacticType = TACTIC_Hold, priority = 200},
--~ 			},
--~ 			--coordinatedSetupFacingPositions = {mkr_ambush1_def1_Facing},
--~ 		},
	}
	local enc_EnemySanatorium_1 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_EnemySanatorium_1
end

ENCOUNTERS.EnemySanatorium_2 = function()
	local encData = {
		name = "EnemySanatorium_2",
		sgroups = {sg_enemySanatoriumTroops},
		spawn = {eg_bunker1},
		units = {
			{				
				name = "EnemySanatorium_2",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
--~ 				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
--~ 				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},						
--~ 				difficulty = {GD_EASY, GD_NORMAL},
				spawn = eg_bunker1,
				conditions = {XP1_GetNodeStrength() <= 4},
			},
			
			{				
				name = "EnemySanatorium_2",
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,						
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},						

				--difficulty = {GD_HARD},
				spawn = eg_bunker1,
				conditions = {XP1_GetNodeStrength() >= 5},
			},
		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target =  eg_bunker1,
			garrisonIdle = false,
			garrison = true,
			range = 20,
			leashRange = 20,
			retaliateAttacks = false,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_ambush1_def1_Facing},
		},
	}
	local enc_EnemySanatorium_2 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_EnemySanatorium_2
end


ENCOUNTERS.EnemySanatorium_3 = function()
	local encData = {
		name = "EnemySanatorium_3",
		sgroups = {sg_enemySanatoriumTroops},
		spawn = {mkr_sanatoriumDef3},
		units = {
			{				
				name = "EnemySanatorium_3",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
--~ 				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
--~ 				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},						
--~ 				difficulty = {GD_EASY, GD_NORMAL},
				spawn = mkr_sanatoriumDef3,
				conditions = {g_stronger_enemy_positions == false},
			},
			
			{				
				name = "EnemySanatorium_3",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				slotItems = {SLOT_ITEM.PANZERSHRECK_MP},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK_MP, dropChance = 0.5, exclusive = nil}},			
--~ 				difficulty = {GD_EASY, GD_NORMAL},
				spawn = mkr_sanatoriumDef3,
				conditions = {g_stronger_enemy_positions == true},
			},

		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_sanatoriumDef3,
			garrisonIdle = false,
			garrison = false,
			range = 20,
			leashRange = 20,
			retaliateAttacks = false,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_ambush1_def1_Facing},
		},
	}
	local enc_EnemySanatorium_3 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_EnemySanatorium_3
end


ENCOUNTERS.EnemySanatorium_4 = function()
	local encData = {
		name = "EnemySanatorium_4",
		sgroups = {sg_enemySanatoriumTroops},
		spawn = {eg_sanatoriumA},
		units = {
			{				
				name = "EnemySanatorium_4",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
--~ 				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
--~ 				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},						
--~ 				difficulty = {GD_EASY, GD_NORMAL},
				spawn = eg_sanatoriumA,
				conditions = {XP1_GetNodeStrength() <= 4},
			},
			
			{				
				name = "EnemySanatorium_4",
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,							
				difficulty = {GD_HARD},
				spawn = eg_sanatoriumA,
				conditions = {XP1_GetNodeStrength() >= 5},
			},
			{				
				name = "EnemySanatorium_4",
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,							
				difficulty = {GD_EASY, GD_NORMAL},
				spawn = eg_sanatoriumA,
				conditions = {XP1_GetNodeStrength() >= 5},
			},

		},		
		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = eg_sanatoriumA,
			garrisonIdle = true,
			garrison = true,
			range = 20,
			leashRange = 20,
			retaliateAttacks = false,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_ambush1_def1_Facing},
		},
	}
	local enc_EnemySanatorium_4 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_EnemySanatorium_4
end


ENCOUNTERS.EnemySanatorium_5 = function()
	local encData = {
		name = "EnemySanatorium_5",
		sgroups = {sg_enemySanatoriumTroops},
		spawn = {mkr_sanatoriumDef6},
		dynamicSpawnTarget = mkr_dyn_spawn_sanatoriumDef6,
		units = {
			{				
				name = "EnemySanatorium_5",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
--~ 				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
--~ 				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},						
--~ 				difficulty = {GD_EASY, GD_NORMAL},
				spawn = mkr_sanatoriumDef6,
				conditions = {g_stronger_enemy_positions == false},
			},
			
			{				
				name = "EnemySanatorium_5",
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,						
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},						

				--difficulty = {GD_HARD},
				spawn = mkr_sanatoriumDef6,
				conditions = {g_stronger_enemy_positions == true},
			},

		},		
		
--~ 		triggerGoalOnEngage = true,
--~ 		goal = {
--~ 			name = "Defend",
--~ 			target = mkr_sanatoriumDef6_Area,
--~ 			garrisonIdle = false,
--~ 			garrison = false,
--~ 			range = 15,
--~ 			leashRange = 15,
--~ 			retaliateAttacks = false,
--~ 			instantSetup = true,
--~ 			tacticControlList = {
--~ 				{tacticType = TACTIC_Hold, priority = 200},
--~ 			},
--~ 			--coordinatedSetupFacingPositions = {mkr_ambush1_def1_Facing},
--~ 		},
	}
	local enc_EnemySanatorium_5 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_EnemySanatorium_5
end


ENCOUNTERS.Raid1 = function()
	
	local encData = {
		name = "Raid1",
		sgroups = {sg_axisTest},
		spawn = {mkr_bossRally1},
		
		units = {
			{				
				name = "Raid1b",
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				--spawn = mkr_enemyRaid1a,				
			},
			{				
				name = "Raid1b",
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				sgroups = {sg_axisSubTest},
				--spawn = mkr_enemyRaid1a,								
			},
			
			{				
				name = "Raid1a",
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				--spawn = mkr_enemyRaid1b,		
			},
		},		
		
		goal = {
			name = "Defend",
			target = mkr_wreckArea1,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Cover, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_farm4Facing},
		},
	}
	local enc_Raid1 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_Raid1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Raid1
end


ENCOUNTERS.SanatoriumFirstWave = function()
    local waveData = {		
		
		attackDirs = {
			{
				{spawn = mkr_enemySpawn3, dynSpawn = mkr_enemyDynSpawn3, ui = nil, target = eg_sanatorium, rallyPoint = mkr_enemyRally3},
			},
		},
		encounters = {
			{
				sgroups = {sg_firstWaveOvergroup},
				units = {
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
					{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),},
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},					
				},
				weight = 5,
			},
			{
				sgroups = {sg_firstWaveOvergroup},
				units = {
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
					{sbp = SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP, sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},					
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),},
				},
				weight = 5,
			},
			{
				sgroups = {sg_firstWaveOvergroup},
				units = {
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
					{sbp = SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP,sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},					
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),},
				},
				weight = 5,
			},
			{
				sgroups = {sg_firstWaveOvergroup},
				units = {
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
					{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),},					
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
				},
				weight = 5,
			},
			{
				sgroups = {sg_firstWaveOvergroup},
				units = {
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
					{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP, sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),},					
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
				},
				weight = 5,
				--rare = true,
			},
		},
		randomizeData = {
			randomEncounters = 1,
			exclusive = true,
			uniqueSpawns = true,
		},
		waveCompleteConditionData = {
			--condition = CONDITION_TIMER_ENDED,
--~ 			condition = CONDITION_INFINITE_DURATION,
--~ 			variable = 180, -- time this wave is still used
			condition = CONDITION_UNITS_LEFT,  --CONDITION_GROUP_IS_DEAD
			variable = 1,
			wave_retreats = true,
			vehicles = 0,
		},
		spawnerData = {
			initialDelay = 0,
			spawnDelay = 1,
		},
--~ 		sustainedAttackData = {
--~ 			newSpawnThreshold = 2,
--~ 			newSpawnWait = 25,
--~ 		},

		callbackData = {
			onComplete = function()
				print("DERP complete")
				--Rule_AddDelayedInterval(MainWaveCheck, 10, 1)
				Event_GroupIsDead(DelayedFullAttack, {}, sg_firstWaveOvergroup, 40)
				--g_refuelOff = false
				Rule_AddOneShot(RefuelKickoff, 30)
			end,
			
			onSpawn = function()
				
				-- to account for the fact that sometimes enemies spawn from two or more directions
					
				--Util_StartIntel(EVENTS.FirstWave)
				--Objective_Start(SOBJ_DefendSanatorium)				
				Rule_AddDelayedInterval(VisibleVehicleCheck, 5, 1)							
				Objective_SetCounter(SOBJ_DefendSanatorium, 1, 5)
			end
		},


    }
    return waveData
end

ENCOUNTERS.Sanatorium01_Overgroup1 = function()
    local waveData = {		
		
--~ 		attackDirs = {
--~ 			{
--~ 				{spawn = mkr_enemySpawn3, dynSpawn = mkr_enemyDynSpawn3, ui = nil, target = eg_sanatorium, rallyPoint = mkr_enemyRally3},
--~ 			},
--~ 		},
		encounters = {
			{
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave2},
				units = {
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
					{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},
					
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
						slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
						dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},
					},					
				},
				weight = 5,
			},
			{
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave2},
				units = {
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
					{sbp = SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP, sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},
					
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},					
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}), 
						slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
						dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},
					},
				},
				weight = 5,
			},
			{
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave2},
				units = {
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
					{sbp = SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP,sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},					
					
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}), 
						slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
						dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},
					},
				},
				weight = 5,
			},
			{
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave2},
				units = {
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
					{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},
					
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}), 
						slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
						dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},
					},				
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
				},
				weight = 5,
			},
			{
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave2},
				units = {
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
					{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP, sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},
					
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}), 
						slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
						dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},
					},				
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
				},
				weight = 5,
				--rare = true,
			},
		},
		randomizeData = {
			randomEncounters = 1,
			exclusive = true,
			uniqueSpawns = true,
		},
		waveCompleteConditionData = {
			--condition = CONDITION_TIMER_ENDED,
			condition = CONDITION_UNITS_LEFT,  --CONDITION_GROUP_IS_DEAD
			variable = 0,
			wave_retreats = false,
			vehicles = 0,
		},
		spawnerData = {
			initialDelay = 20,
			spawnDelay = 1,
		},
--~ 		sustainedAttackData = {
--~ 			newSpawnThreshold = 0,
--~ 			newSpawnWait = 1,
--~ 		},
    }
    return waveData
end

ENCOUNTERS.Sanatorium02_Overgroup1 = function()
    local waveData = {		
		encounters = {
			{
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave3},
				units = {
					{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
					{sbp = SBP.GERMAN.STUG_III_SQUAD_MP, sgroups = {sg_vehicleAttackSubgroup, sg_commandTanks}},	
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP})},
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}), 
						slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
						dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},
					},					
				},
				weight = 5,
			},
			{
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave3},
				units = {
					{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP, sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},
					{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},					
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}), 
						slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
						dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},
					},
				},
				weight = 5,
			},
			{
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave3},
				units = {
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}), 
						slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
						dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},
					},					
					{sbp = SBP.GERMAN.STUG_III_SQUAD_MP, sgroups = {sg_vehicleAttackSubgroup, sg_commandTanks}},
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
					{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},
				},
				weight = 5,
			},
			{
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave3},
				units = {
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP})},
					{sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP, sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},										
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
					{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP})},
				},
				weight = 5,
			},
			{
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave3},
				units = {
					{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},					
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP})}, 
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
						--slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
						--dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},
					},
					{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
					{sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP, sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},
				},
				weight = 5,
				--rare = true,
			},
		},
		randomizeData = {
			randomEncounters = 1,
			exclusive = true,
			uniqueSpawns = true,
		},
		waveCompleteConditionData = {
			--condition = CONDITION_TIMER_ENDED,
			condition = CONDITION_UNITS_LEFT,  --CONDITION_GROUP_IS_DEAD
			variable = 0,
			wave_retreats = false,
			vehicles = 0,
		},
		spawnerData = {
			initialDelay = 20,
			spawnDelay = 1,
		},
--~ 		sustainedAttackData = {
--~ 			newSpawnThreshold = 0,
--~ 			newSpawnWait = 1,
--~ 		},
    }
    return waveData
end

ENCOUNTERS.Sanatorium03_Overgroup1 = function()
    local waveData = {		
		encounters = {
			{
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave4},
				units = {
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}), 
						slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
						dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},
					},
					{sbp = SBP.GERMAN.STUG_III_SQUAD_MP, sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},	
				},
				weight = 5,
			},
			{
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave4},
				units = {
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},					
					{sbp = SBP.GERMAN.STUG_III_SQUAD_MP, sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
						slotItems = {SLOT_ITEM.PANZERSHRECK_MP},
						dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK_MP, dropChance = 0.5, exclusive = nil}},
					},
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
						slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
						dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},
					},

				},
				weight = 5,
			},
			{
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave4},
				units = {
					{
						sbp = SBP.GERMAN.STUG_III_SQUAD_MP, 
						sgroups = {sg_vehicleAttackSubgroup, sg_commandTanks}
					},
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP})},					
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}), 
						slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
						dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},
					},
			
				},
				weight = 15,
			},
			{
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave4},
				units = {
					{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},
					{sbp = SBP.GERMAN.STUG_III_SQUAD_MP, sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
						slotItems = {SLOT_ITEM.PANZERSHRECK_MP},
						dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK_MP, dropChance = 0.5, exclusive = nil}},
					},
				},
				weight = 5,
			},
			{
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave4},
				units = {
					{sbp = SBP.GERMAN.STUG_III_SQUAD_MP, sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},			
					{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP})},			
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
						slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
						dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},
					},
				},
				weight = 5,
				--rare = true,
			},
		},
		randomizeData = {
			randomEncounters = 2,
			exclusive = true,
			uniqueSpawns = true,
		},
		waveCompleteConditionData = {
			--condition = CONDITION_TIMER_ENDED,
			condition = CONDITION_UNITS_LEFT,  --CONDITION_GROUP_IS_DEAD
			variable = 0,
			wave_retreats = false,
			vehicles = 0,
		},
		spawnerData = {
			initialDelay = 20,
			spawnDelay = 1,
		},
--~ 		sustainedAttackData = {
--~ 			newSpawnThreshold = 0,
--~ 			newSpawnWait = 20,
--~ 		},
    }
    return waveData
end

ENCOUNTERS.Sanatorium04_Overgroup1 = function()
    local waveData = {		

		encounters = {
			{
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave5},
				units = {
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
					{
						sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP, 
						sgroups = {sg_vehicleAttackSubgroup, sg_commandTanks}
					},
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
						slotItems = {SLOT_ITEM.PANZERSHRECK_MP},
						dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK_MP, dropChance = 0.5, exclusive = nil}},
					},					
					{sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP},
					{
						sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
						difficulty = {GD_NORMAL,GD_HARD},
					},
				},
				weight = 15,
			},
			{
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave5},
				units = {
					{sbp = SBP.GERMAN.STUG_III_SQUAD_MP,  sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},
					{
						sbp = SBP.GERMAN.STUG_III_SQUAD_MP, 
						sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks},
						conditions = {g_heavy_armour == false},
					},
					{
						sbp = SBP.GERMAN.STUG_III_SQUAD_MP, 
						sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks},
						conditions = {g_heavy_armour == true},
						difficulty = {GD_EASY},
					},
					{
						sbp = SBP.GERMAN.BRUMMBAR_SQUAD_MP,
						sgroups = {sg_vehicleAttackSubgroup, sg_commandTanks},
						conditions = {g_heavy_armour == true},
						difficulty = {GD_NORMAL, GD_HARD},
					},
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},					
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
						slotItems = {SLOT_ITEM.PANZERSHRECK_MP},
						dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK_MP, dropChance = 0.5, exclusive = nil}},
					},
					{sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP},
					{
						sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
						difficulty = {GD_NORMAL, GD_HARD},
					},
				},
				weight = 3,
			},
			{
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave5 },
				units = {					
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
						slotItems = {SLOT_ITEM.PANZERSHRECK_MP},
						dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK_MP, dropChance = 0.5, exclusive = nil}},
					},
					{sbp = SBP.WEST_GERMAN.JAGDPANZER_TANK_DESTROYER_SQUAD_MP, sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
					{sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP},
					{
						sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
						difficulty = {GD_NORMAL, GD_HARD},
					},
				},
				weight = 5,
			},
			{
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave5},
				units = {
					{sbp = SBP.GERMAN.STUG_III_SQUAD_MP,  sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
						slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
						dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},
					},
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
					{sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP},
					{
						sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
						difficulty = {GD_NORMAL, GD_HARD},
					},

				},
				weight = 5,
			},
			{				
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave5},
				units = {
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
						slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
						dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},
					},
					{sbp = SBP.GERMAN.STUG_III_SQUAD_MP,  sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},
					{
						sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP, 
						sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks},
						conditions = {g_heavy_armour == false},
					},		
					{
						sbp = SBP.GERMAN.STUG_III_SQUAD_MP,
						sgroups = {sg_vehicleAttackSubgroup, sg_commandTanks},
						conditions = {g_heavy_armour == true},
						difficulty = {GD_EASY},
					},					
					{
						sbp = SBP.GERMAN.BRUMMBAR_SQUAD_MP,
						sgroups = {sg_vehicleAttackSubgroup, sg_commandTanks},
						conditions = {g_heavy_armour == true},
						difficulty = {GD_NORMAL, GD_HARD},
					},
					{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
					{sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP},					
				},
				weight = 15,
			--	rare = true,
			},
		},
		randomizeData = {
			randomEncounters = 2,
			exclusive = true,
			uniqueSpawns = true,
		},
		waveCompleteConditionData = {
			--condition = CONDITION_TIMER_ENDED,
			condition = CONDITION_UNITS_LEFT,  --CONDITION_GROUP_IS_DEAD
			variable = 0,
			wave_retreats = false,
			vehicles = 0,
		},
		spawnerData = {
			initialDelay = 10,
			spawnDelay = 1,
		},
--~ 		sustainedAttackData = {
--~ 			newSpawnThreshold = 0,-- hits 2 entities, so dudes
--~ 			newSpawnWait = 15, -- wait 20 seconds before spawning
--~ 		},
	
    }
    return waveData
end


ENCOUNTERS.Sanatorium05_Final = function()
    local waveData = {		

		encounters = {
			{
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave6},
				units = {
					{
						sbp = SBP.WEST_GERMAN.PANTHER_AUSF_G_SQUAD_MP, 
						sgroups = {sg_vehicleAttackSubgroup, sg_commandTanks},
						conditions = {g_heavy_armour == true},
						difficulty = {GD_NORMAL, GD_HARD},
					},
					{
						sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP, 
						sgroups = {sg_vehicleAttackSubgroup, sg_commandTanks},
						conditions = {g_heavy_armour == false},
						difficulty = {GD_NORMAL, GD_HARD},
					},
					{
						sbp = SBP.GERMAN.STUG_III_SQUAD_MP, 
						sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks},
						conditions = {XP1_GetNodeStrength() <= 2},
					},		
					{
						sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP, 
						sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks},
						conditions = {XP1_GetNodeStrength() >= 3},
					},					

					
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
						slotItems = {SLOT_ITEM.PANZERSHRECK_MP},
						dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK_MP, dropChance = 0.5, exclusive = nil}},
					},					
					{sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP},
					{
						sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
						difficulty = {GD_NORMAL, GD_HARD},
					},
				},
				weight = 15,
			},
			{
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave6},
				units = {
					{
						sbp = SBP.GERMAN.STUG_III_SQUAD_MP, 
						sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks},
						conditions = {XP1_GetNodeStrength() <= 2},
					},		
					{
						sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP, 
						sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks},
						conditions = {XP1_GetNodeStrength() >= 3},
					},		
					{
						sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,  
						sgroups = {sg_vehicleAttackSubgroup, sg_commandTanks},
						conditions = {g_heavy_armour == false},
						difficulty = {GD_NORMAL, GD_HARD},
					},	
					
					{
						sbp = SBP.GERMAN.BRUMMBAR_SQUAD_MP,
						sgroups = {sg_vehicleAttackSubgroup, sg_commandTanks},
						conditions = {g_heavy_armour == true},
						difficulty = {GD_NORMAL, GD_HARD},
						
					},
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
						slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
						dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},
					},
					{sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP},
					{sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP},
				},
				weight = 5,
			},
			{
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave6},
				units = {										
					{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks}},									
					{
						sbp = SBP.GERMAN.STUG_III_SQUAD_MP, 
						sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks},
						conditions = {XP1_GetNodeStrength() >= 3},						
					},
					{
						sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
						sgroups = {sg_vehicleAttackSubgroup, sg_commandTanks},
						conditions = {g_heavy_armour == false},
						difficulty = {GD_NORMAL, GD_HARD},
					},
					{
						sbp = SBP.WEST_GERMAN.PANTHER_AUSF_G_SQUAD_MP, 
						sgroups = {sg_vehicleAttackSubgroup, sg_commandTanks},
						conditions = {g_heavy_armour == true},
						difficulty = {GD_NORMAL, GD_HARD},
					},
					
					{sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP},	
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP})},
				},
				weight = 10,
			},
			{
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave6},
				units = {
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
						slotItems = {SLOT_ITEM.PANZERSHRECK_MP},
						dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK_MP, dropChance = 0.5, exclusive = nil}},
					},
					
					{
						sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP, 
						sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks},
						conditions = {XP1_GetNodeStrength() >= 3},		
					},
					
					{
						sbp = SBP.WEST_GERMAN.JAGDPANZER_TANK_DESTROYER_SQUAD_MP,
						sgroups = {sg_vehicleAttackSubgroup, sg_commandTanks},
						conditions = {g_heavy_armour == true},
						difficulty = {GD_EASY},
					},
					
					{
						sbp = SBP.GERMAN.BRUMMBAR_SQUAD_MP, 
						sgroups = {sg_vehicleAttackSubgroup, sg_commandTanks},
						conditions = {g_heavy_armour == true},
						difficulty = {GD_NORMAL, GD_HARD},
					},
					
					{
						sbp = SBP.GERMAN.STUG_III_SQUAD_MP, 
						sgroups = {sg_vehicleAttackSubgroup, sg_commandTanks},
						conditions = {g_heavy_armour == false},
						difficulty = {GD_EASY},
					},
					
					{
						sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
						sgroups = {sg_vehicleAttackSubgroup, sg_commandTanks},
						conditions = {g_heavy_armour == false},
						difficulty = {GD_NORMAL, GD_HARD},
					},
					
					{sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP},
					{
						sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
						difficulty = {GD_NORMAL, GD_HARD},
					},
				},
				weight = 5,
			},
			{
				sgroups = {sg_sanatoriumOvergroup, sg_sanatoriumOvergroupWave6},
				units = {
					{sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
						slotItems = {SLOT_ITEM.PANZERSHRECK_MP},
						dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK_MP, dropChance = 0.5, exclusive = nil}},
					},
					{
						sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP, 
						sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks},
						conditions = {XP1_GetNodeStrength() >= 3},						
					},					
					{
						sbp =  SBP.GERMAN.STUG_III_SQUAD_MP,  
						sgroups = {sg_vehicleAttackSubgroup, sg_minionTanks},
						conditions = {XP1_GetNodeStrength() <= 2},	
					},	
					
					{
						sbp = SBP.WEST_GERMAN.JAGDPANZER_TANK_DESTROYER_SQUAD_MP,
						sgroups = {sg_vehicleAttackSubgroup, sg_commandTanks},
						conditions = {g_heavy_armour == false},						
					},					
					
					{
						sbp = SBP.WEST_GERMAN.JAGDPANZER_TANK_DESTROYER_SQUAD_MP,
						sgroups = {sg_vehicleAttackSubgroup, sg_commandTanks},
						conditions = {g_heavy_armour == true},
						difficulty = {GD_EASY},
					},					
					{
						sbp =  SBP.WEST_GERMAN.PANTHER_AUSF_G_SQUAD_MP, 
						sgroups = {sg_vehicleAttackSubgroup, sg_commandTanks},
						conditions = {g_heavy_armour == true},
						difficulty = {GD_NORMAL},
					},					
					{
						sbp =  SBP.WEST_GERMAN.KING_TIGER_SQUAD_MP,
						sgroups = {sg_vehicleAttackSubgroup, sg_commandTanks},
						conditions = {g_heavy_armour == true},
						difficulty = {GD_HARD},
					},

					{sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP},					
				},
				weight = 15,
			--	rare = true,
			},
		},
		randomizeData = {
			randomEncounters = 3,
			exclusive = true,
			uniqueSpawns = true,
		},
		waveCompleteConditionData = {
			--condition = CONDITION_TIMER_ENDED,
condition = CONDITION_UNITS_LEFT,  --CONDITION_GROUP_IS_DEAD
				variable = 0,
			wave_retreats = false,
			vehicles = 0,
		},
		spawnerData = {
			initialDelay = 10,
			spawnDelay = 1,
		},
--~ 		sustainedAttackData = {
--~ 			newSpawnThreshold = 0,-- hits 2 entities, so dudes
--~ 			newSpawnWait = 30, -- wait 20 seconds before spawning
--~ 		},
    }
    return waveData
end


ENCOUNTERS.Point1_Def1 = function()
	
	local encData = {
		name = "Point1_Def1",
		sgroups = {sg_point1Def1, sg_allEnemyTroops},
		spawn = {mkr_point1_def1},
		units = {
			{				
				name = "Point1_Def1a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
--~ 				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
--~ 				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},						
--~ 				difficulty = {GD_EASY, GD_NORMAL},
				spawn = mkr_point1_def1,
				--conditions = {XP1_GetNodeStrength() <= 3},
			},
			
				{				
				name = "Point1_Def1a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				spawn = mkr_point1_def1,
				conditions = {XP1_GetNodeStrength() <= 3},
				difficulty = {GD_NORMAL, GD_HARD},
			},
			
			{				
				name = "Point1_Def1b",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},						
				spawn = mkr_point1_def1,
				conditions = {XP1_GetNodeStrength() >= 4},
				difficulty = {GD_NORMAL, GD_HARD},
			},

			{				
				name = "Point1_Def1b",
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				spawn = mkr_point1_def1,
				conditions = {XP1_GetNodeStrength() >= 5 and g_difficulty == GD_HARD},
			},
			
			
		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_point1_def1,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Cover, priority = 300},
				{tacticType = TACTIC_Ability, priority = 200},
				
			},
			coordinatedSetupFacingPositions = {mkr_point1_def1_Facing},
		},
	}
	local enc_Point1Def1 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Point1Def1
end

ENCOUNTERS.Point1_Def2 = function()
	
	local encData = {
		name = "Point1_Def2",
		sgroups = {sg_point1Def2, sg_allEnemyTroops},
		spawn = {mkr_point1_def2},
		units = {
			
			
			
			{				
				name = "Point1_Def2a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
--~ 				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
--~ 				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},						
--~ 				difficulty = {GD_EASY, GD_NORMAL},
				spawn = mkr_point1_def2,
				--conditions = {XP1_GetNodeStrength() <= 3},
			},
			
			{				
				name = "Point1_Def2a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),								
				spawn = mkr_point1_def2,
				conditions = {XP1_GetNodeStrength() <= 2},
				difficulty = {GD_NORMAL},
			},
			{				
				name = "Point1_Def2a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),				
				slotItems = {SLOT_ITEM.PANZERSHRECK_MP},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK_MP, dropChance = 0.5, exclusive = nil}},			
				spawn = mkr_point1_def2,
				conditions = {XP1_GetNodeStrength() >= 3},
				difficulty = {GD_NORMAL},
			},
			{				
				name = "Point1_Def2b",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP }),
				slotItems = {SLOT_ITEM.PANZERSHRECK_MP},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK_MP, dropChance = 0.5, exclusive = nil}},						
				spawn = mkr_point1_def2,
				difficulty = {GD_HARD},
			},
			
		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_point1TargetArea, -- mkr_point1_def2
			range = 20,
			leashRange = 20,
			garrisonIdle = false,
			garrison = true,
			retaliateAttacks = false,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
				{tacticType = TACTIC_Cover, priority = 600},
				{tacticType = TACTIC_Ability, priority = 400},
			},
			coordinatedSetupFacingPositions = {mkr_point1_def2_Facing},
		},
	}
	local enc_Point1Def2 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Point1Def2
end


--~ ENCOUNTERS.Point1_Def3 = function()
--~ 	
--~ 	local encData = {
--~ 		name = "Point1_Def3",
--~ 		sgroups = {sg_point1Def3, sg_allEnemyTroops},
--~ 		spawn = {mkr_point1_def3},
--~ 		units = {

--~ 			{				
--~ 				name = "Point1_Def3b",
--~ 				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
--~ 				spawn = mkr_point1_def3,
--~ 				conditions = {XP1_GetNodeStrength() >= 4 and g_difficulty == GD_HARD},
--~ 			},
--~ 			
--~ 		},		
--~ 		
--~ 		triggerGoalOnEngage = true,
--~ 		goal = {
--~ 			name = "Defend",
--~ 			target = mkr_fuel1_prox,
--~ 			range = 15,
--~ 			leashRange = 15,
--~ 			retaliateAttacks = true,
--~ 			instantSetup = true,
--~ 			tacticControlList = {
--~ 				{tacticType = TACTIC_Cover, priority = 500},
--~ 				{tacticType = TACTIC_Ability, priority = 200},
--~ 			},
--~ 			
--~ 		},
--~ 	}
--~ 	local enc_Point1Def3 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
--~ 	--enc_Farm1:SetGoal(encData.goalData)
--~ 	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
--~ 	
--~ 	return enc_Point1Def3
--~ end

ENCOUNTERS.Point2_Def1 = function()
	
	local encData = {
		name = "Point2_Def1",
		sgroups = {sg_point2Def1, sg_allEnemyTroops},
		spawn = {mkr_point2_def1},
		units = {
			{				
				name = "Point2_Def1a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				spawn = mkr_point2_def3,
				conditions = {XP1_GetNodeStrength() <= 3},
			},
			{				
				name = "Point2_Def1a",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},										
				spawn = mkr_point2_def3,
				conditions = {XP1_GetNodeStrength() >= 4 and XP1_GetNodeStrength() < 5},
			},			
			{				
				name = "Point2_Def2a",
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,							
				--difficulty = {GD_HARD},
				spawn = mkr_point2_def3,
				conditions = {XP1_GetNodeStrength() >= 5},
			},
			{				
				name = "Point2_Def2a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				slotItems = {SLOT_ITEM.PANZERSHRECK_MP},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK_MP, dropChance = 0.5, exclusive = nil}},		
				spawn = mkr_point2_def2,				
			},
			
			{				
				name = "Point2_Def1b",
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
				spawn = mkr_point2_def1,
			},			
		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_point2_def1,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_point2_def1_Facing},
		},
	}
	local enc_Point2Def1 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Point2Def1
end

--~ ENCOUNTERS.Fuel1_Def1 = function()
--~ 	local encData = {
--~ 		name = "Fuel1_Def1",
--~ 		sgroups = {sg_fuel1Def1, sg_allEnemyTroops},
--~ 		spawn = {mkr_fuel1_def1},
--~ 		units = {
--~ 			{				
--~ 				name = "Fuel1_Def1a",
--~ 				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
--~ 				--slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
--~ 				--dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},						
--~ 				--difficulty = {GD_EASY, GD_NORMAL},
--~ 				spawn = mkr_fuel1_def1,
--~ 				conditions = {g_difficulty == GD_EASY or (g_difficulty == GD_NORMAL and XP1_GetNodeStrength() <= 4)},
--~ 			},
--~ 			{				
--~ 				name = "Fuel1_Def1a",
--~ 				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
--~ 				--slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
--~ 				--dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},						
--~ 				--difficulty = {GD_EASY, GD_NORMAL},
--~ 				spawn = mkr_fuel1_def1,
--~ 				conditions = {g_difficulty == GD_NORMAL and XP1_GetNodeStrength() >= 5},
--~ 			},
--~ 			{				
--~ 				name = "Fuel1_Def1a",
--~ 				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
--~ 				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
--~ 				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},									
--~ 				--difficulty = {GD_HARD},
--~ 				spawn = mkr_fuel1_def1,
--~ 				conditions = {g_difficulty == GD_HARD and XP1_GetNodeStrength() <= 4},
--~ 			},
--~ 			
--~ 			{				
--~ 				name = "Fuel1_Def1a",
--~ 				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,							
--~ 				--difficulty = {GD_HARD},
--~ 				spawn = mkr_fuel1_def1,
--~ 				conditions = {g_difficulty == GD_HARD and XP1_GetNodeStrength() >= 5},
--~ 			},
--~ 			{				
--~ 				name = "Fuel1_Def1b",
--~ 				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
--~ 				spawn = mkr_fuel1_def1,

--~ 			},
--~ 			
--~ 		},		
--~ 		
--~ 		triggerGoalOnEngage = true,
--~ 		goal = {
--~ 			name = "Defend",
--~ 			target = mkr_fuel1_def1,
--~ 			range = 15,
--~ 			leashRange = 15,
--~ 			retaliateAttacks = false,
--~ 			instantSetup = true,
--~ 			tacticControlList = {
--~ 				{tacticType = TACTIC_Hold, priority = 200},
--~ 			},
--~ 			coordinatedSetupFacingPositions = {mkr_fuel1_def1_Facing},
--~ 		},
--~ 	}
--~ 	local enc_Fuel1Def1 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
--~ 	--enc_Farm1:SetGoal(encData.goalData)
--~ 	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
--~ 	
--~ 	return enc_Fuel1Def1
--~ end

ENCOUNTERS.Fuel2_Def1 = function()
	local encData = {
		name = "Fuel2_Def1",
		sgroups = {sg_fuel2Def1, sg_allEnemyTroops},
		spawn = {mkr_fuel2_def1},
		units = {
			
			{				
				name = "Fuel2_Def1a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				spawn = mkr_fuel2_def1,
				--conditions = {XP1_GetNodeStrength() <= 3},				
			},
			
			-- in addition to above at strength 4:
			{				
				name = "Fuel2_Def1a",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,				
				spawn = mkr_fuel2_def1a,
				conditions = {XP1_GetNodeStrength() >= 4},
			},		

		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_fuel2TargetArea,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_fuel2_def1_Facing},
		},
	}
	local enc_Fuel2Def1 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Fuel2Def1
end


ENCOUNTERS.Fuel2_Def2 = function()
	local encData = {
		name = "Fuel2_Def2",
		sgroups = {sg_fuel2Def2, sg_allEnemyTroops},
		spawn = {mkr_fuel2_def2},
		units = {
			{				
				name = "Fuel2_Def1b",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				spawn = mkr_fuel2_def2,
				difficulty = {GD_EASY},
			},		
			{				
				name = "Fuel2_Def1b",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				spawn = mkr_fuel2_def2,
				difficulty = {GD_NORMAL},
				conditions = {XP1_GetNodeStrength() <= 2},
			},
			{				
				name = "Fuel2_Def1b",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},	
				spawn = mkr_fuel2_def2,
				difficulty = {GD_NORMAL},
				conditions = {XP1_GetNodeStrength() >= 3},
			},
			
			
			
			{				
				name = "Fuel2_Def1b",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},	
				spawn = mkr_fuel2_def2,
				difficulty = {GD_HARD},
			},
		
		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_fuel2TargetArea,
			range = 20,
			leashRange = 20,
			retaliateAttacks = false,
			instantSetup = false,
			tacticControlList = {
				{tacticType = TACTIC_HOLD, priority = 200},
			},
			
		},
	}
	local enc_Fuel2Def2 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Fuel2Def2
end


ENCOUNTERS.Fuel2_Def3 = function()
	local encData = {
		name = "Fuel2_Def3",
		sgroups = {sg_fuel2Def3, sg_allEnemyTroops},
		spawn = {mkr_fuel2_def3},
		units = {
			

			{				
				name = "Fuel2_Def1c",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				spawn = mkr_fuel2_def3,
				difficulty = {GD_EASY},
			},
			{				
				name = "Fuel2_Def1c",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				spawn = mkr_fuel2_def3,
				difficulty = {GD_NORMAL},
				conditions = {XP1_GetNodeStrength() <= 3},
			},
			
			{				
				name = "Fuel2_Def1c",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				spawn = mkr_fuel2_def3,
				slotItems = {SLOT_ITEM.PANZERSHRECK_MP},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK_MP, dropChance = 0.5, exclusive = nil}},
				difficulty = {GD_NORMAL},
				conditions = {XP1_GetNodeStrength() >= 4},
			},
			
			{				
				name = "Fuel2_Def1c",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				slotItems = {SLOT_ITEM.PANZERSHRECK_MP},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK_MP, dropChance = 0.5, exclusive = nil}},
				spawn = mkr_fuel2_def3,
				difficulty = {GD_HARD},
			},

			
		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_fuel2TargetArea,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_fuel2_def1_Facing},
		},
	}
	local enc_Fuel2Def3 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Fuel2Def3
end

ENCOUNTERS.Fuel2_Def4 = function()
	local encData = {
		name = "Fuel2_Def4",
		sgroups = {sg_fuel2Def4, sg_allEnemyTroops},
		spawn = {eg_fuel2Building},
		units = {
			-- at str 5:
			{				
				name = "Fuel2_Def1a",
				sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
				---slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				---dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},										
				difficulty = {GD_HARD},
				conditions = {XP1_GetNodeStrength() >= 5},				
			},
		},		
		
		--triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_fuel2TargetArea,
			garrison = true,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_fuel2_def1_Facing},
		},
	}
	local enc_Fuel2Def4 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Fuel2Def4
end

ENCOUNTERS.Fuel3_Def1 = function()
	local encData = {
		name = "Fuel3_Def1",
		sgroups = {sg_fuel3Def1, sg_allEnemyTroops},
		spawn = {mkr_fuel3_def1},
		units = {
			
			{				
				name = "Fuel3_Def1a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},						
				--difficulty = {GD_EASY, GD_NORMAL},
				spawn = mkr_fuel3_def1,				
			},

			
			-- in addition
			{				
				name = "Fuel3_Def1a",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,				
				spawn = mkr_fuel3_def2,
				conditions = {XP1_GetNodeStrength() >= 4 and XP1_GetNodeStrength() < 5},
			},		
			
			{				
				name = "Fuel3_Def1a",
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				spawn = mkr_fuel3_def2,
				conditions = {XP1_GetNodeStrength() >= 5},
			},		
			
			{				
				name = "Fuel3_Def1b",
				sbp = SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP,
				spawn = eg_fuel3Shed,
				instantSetup = true,

			},
			{				
				name = "Fuel3_Def1c",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				slotItems = {SLOT_ITEM.PANZERSHRECK_MP},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK_MP, dropChance = 0.5, exclusive = nil}},
				--difficulty = {GD_EASY, GD_NORMAL},
				spawn = mkr_fuel3_def5,				
			},
			{				
				name = "Fuel3_Def1d",
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,				
				spawn = mkr_fuel3_def4,				
			},
			
		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_fuel3TargetArea,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_fuel3_def3_Facing},
		},
	}
	local enc_Fuel3Def1 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Fuel3Def1
end


ENCOUNTERS.Fuel3_Def2 = function()
	local encData = {
		name = "Fuel3_Def2",
		sgroups = {sg_fuel3Def2, sg_allEnemyTroops},
		spawn = {mkr_fuel3_def5},
		units = {
			-- first guy
			{				
				name = "Fuel3_Def2a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},						
				difficulty = {GD_EASY, GD_NORMAL},
				spawn = mkr_fuel3_def5,				
			},
			{				
				name = "Fuel3_Def2a",
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},						
				conditions = {XP1_GetNodeStrength() <= 4},
				difficulty = {GD_HARD},
				spawn = mkr_fuel3_def5,				
			},
			{				
				name = "Fuel3_Def2a",
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,				
				conditions = {XP1_GetNodeStrength() >= 5},
				difficulty = {GD_HARD},
				spawn = mkr_fuel3_def5,				
			},
			
			-- second guy -- only shows up on Hard
			
			{				
				name = "Fuel3_Def2b",
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
				difficulty = {GD_NORMAL, GD_HARD},
				spawn = mkr_fuel3_def5,				
			},
			-- third guy -- only shows up on normal/Hard
			{				
				name = "Fuel3_Def2c",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				slotItems = {SLOT_ITEM.PANZERSHRECK_MP},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK_MP, dropChance = 0.5, exclusive = nil}},
				difficulty = {GD_HARD},
				spawn = mkr_fuel3_def5,				
			},
		},	
		
		--triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_fuel3_def5,
			range = 5,
			leashRange = 5,
			retaliateAttacks = false,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Ability, priority = 200},
			},
			
		},
	}
	local enc_Fuel3Def2 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)	
	return enc_Fuel3Def2
end



ENCOUNTERS.Fuel4_Def1 = function()
	local encData = {
		name = "Fuel4_Def1",
		sgroups = {sg_fuel4Def1, sg_allEnemyTroops},
		spawn = {mkr_fuel4_def1},
		units = {
			{				
				name = "Fuel4_Def1a",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				--slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				--dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},						
				--difficulty = {GD_EASY, GD_NORMAL},
				spawn = mkr_fuel4_def1,
				conditions = {g_difficulty == GD_EASY or (g_difficulty == GD_NORMAL and XP1_GetNodeStrength() <= 4)},
			},
			{				
				name = "Fuel4_Def1a",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				--slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				--dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},						
				--difficulty = {GD_EASY, GD_NORMAL},
				spawn = mkr_fuel4_def1,
				conditions = {g_difficulty == GD_NORMAL and XP1_GetNodeStrength() >= 5},
			},
			{				
				name = "Fuel4_Def1a",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},									
				--difficulty = {GD_HARD},
				spawn = mkr_fuel4_def1,
				conditions = {g_difficulty == GD_HARD and XP1_GetNodeStrength() <= 4},
			},
			
			{				
				name = "Fuel4_Def1a",
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,							
				--difficulty = {GD_HARD},
				spawn = mkr_fuel4_def1,
				conditions = {g_difficulty == GD_HARD and XP1_GetNodeStrength() >= 5},
			},
			{				
				name = "Fuel4_Def1b",
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				--instantSetup = true,
				spawn = mkr_fuel4_def2,

			},
			
		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_fuel4_def1,
			range = 15,
			leashRange = 15,
			retaliateAttacks = true,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Ability, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_fuel4_def1_Facing},
		},
	}
	local enc_Fuel4Def1 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Fuel4Def1
end


ENCOUNTERS.Ambush3_1 = function()
	local encData = {
		name = "Ambush3_1",
		sgroups = {sg_ambushTable[3], sg_allEnemyTroops},
		spawn = {mkr_ambush3_1},
		units = {
			{				
				name = "Ambush3_1a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				spawn = mkr_ambush3_1,
				--conditions = {XP1_GetNodeStrength() <= 3},				
			},
			
			-- in addition to above at strength 4:
			{				
				name = "Ambush3_1a",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,				
				spawn = mkr_ambush3_1,
				conditions = {XP1_GetNodeStrength() >= 4 and XP1_GetNodeStrength() < 5},
			},		
			-- at str 5:
			{				
				name = "Ambush3_1a",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,				
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},										
				spawn = mkr_ambush3_1,				
				conditions = {XP1_GetNodeStrength() >= 5},				
			},
			
		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_ambush3_1,
			garrisonIdle = true,
			garrison = true,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_ambush3_2_Facing},
		},
	}
	local enc_Ambush3_1 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Ambush3_1
end

ENCOUNTERS.Ambush3_2 = function()
	local encData = {
		name = "Ambush3_2",
		sgroups = {sg_ambushTable[3], sg_allEnemyTroops},
		spawn = {mkr_ambush3_2},
		units = {
			{				
				name = "Ambush3_2a",
				sbp = SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP,
				instantSetup = true,
				spawn = mkr_ambush3_2,			
			},			
		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_ambush3_2,
			garrisonIdle = true,
			garrison = true,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_ambush3_2_Facing},
		},
	}
	local enc_Ambush3_2 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Ambush3_2
end

ENCOUNTERS.Ambush3_3 = function()
	local encData = {
		name = "Ambush3_3",
		sgroups = {sg_ambushTable[3], sg_allEnemyTroops},
		spawn = {mkr_ambush3_3},
		units = {
			{				
				name = "Ambush3_3",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP}),
				spawn = mkr_ambush3_3,
				--conditions = {XP1_GetNodeStrength() <= 3},				
			},

		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_ambush3_3,
			garrisonIdle = true,
			garrison = true,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_ambush1_def1_Facing},
		},
	}
	local enc_Ambush3_3 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Ambush3_3
end



ENCOUNTERS.Ambush7_1 = function()
	local encData = {
		name = "Ambush7_1",
		sgroups = {sg_ambushTable[7], sg_allEnemyTroops},
		spawn = {mkr_ambush7_1},
		units = {
			
			{				
				name = "Ambush7_1",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP}),
				spawn = mkr_ambush7_1,
				conditions = {XP1_GetNodeStrength() <= 3},				
			},
			
			{				
				name = "Ambush7_1a",
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},									
				--difficulty = {GD_HARD},
				spawn = mkr_ambush7_1,
				conditions = {XP1_GetNodeStrength() == 4},
			},
			{				
				name = "Ambush7_1a",
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,											
				spawn = mkr_ambush7_1,
				conditions = {XP1_GetNodeStrength() >= 5},
			},

		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_ambush7Def,
			garrisonIdle = true,
			garrison = true,
			range = 15,
			leashRange = 15,
			retaliateAttacks = true,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_ambush1_def1_Facing},
		},
	}
	local enc_Ambush7_1 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Ambush7_1
end

ENCOUNTERS.Ambush7_2 = function()
	local encData = {
		name = "Ambush7_2",
		sgroups = {sg_ambushTable[7], sg_allEnemyTroops},
		spawn = {mkr_ambush7_2},
		units = {
			{				
				name = "Ambush7_2",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP}),
				spawn = mkr_ambush7_2,
				conditions = {XP1_GetNodeStrength() <= 3},				
			},
			
			{				
				name = "Ambush7_2",
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				slotItems = {SLOT_ITEM.PANZERSHRECK_MP},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK_MP, dropChance = 0.5, exclusive = nil}},
				--difficulty = {GD_HARD},
				spawn = mkr_ambush7_2,
				conditions = {XP1_GetNodeStrength() >= 4},
			},
			

		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_ambush7Def,
			garrisonIdle = false,
			garrison = false,
			range = 15,
			leashRange = 15,
			retaliateAttacks = true,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Ability, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_ambush1_def1_Facing},
		},
	}
	local enc_Ambush7_2 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Ambush7_2
end

ENCOUNTERS.Ambush8_1 = function()
	local encData = {
		name = "Ambush8_1",
		sgroups = {sg_ambushTable[8], sg_allEnemyTroops},
		spawn = {mkr_ambush8_1},
		units = {
			{				
				name = "Ambush8_1",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP}),
				spawn = mkr_ambush8_1,
				conditions = {XP1_GetNodeStrength() <= 3},				
			},
			
			{				
				name = "Ambush8_1a",
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},									
				--difficulty = {GD_HARD},
				spawn = mkr_ambush8_1,
				conditions = {XP1_GetNodeStrength() == 4},
			},
			{				
				name = "Ambush8_1a",
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,											
				spawn = mkr_ambush8_1,
				conditions = {XP1_GetNodeStrength() >= 5},
			},

		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_ambush8Def,
			garrisonIdle = true,
			garrison = true,			
			range = 15,
			leashRange = 15,
			retaliateAttacks = true,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_ambush1_def1_Facing},
		},
	}
	local enc_Ambush8_1 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Ambush8_1
end


ENCOUNTERS.Ambush8_2 = function()
	local encData = {
		name = "Ambush8_2",
		sgroups = {sg_ambushTable[8], sg_allEnemyTroops},
		spawn = {mkr_ambush8_2},
		units = {
			{				
				name = "Ambush8_2",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP}),
				spawn = mkr_ambush8_2,
				conditions = {XP1_GetNodeStrength() <= 3},				
			},
			
			{				
				name = "Ambush8_2a",
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},									
				--difficulty = {GD_HARD},
				spawn = mkr_ambush8_2,
				conditions = {XP1_GetNodeStrength() == 4},
			},
			{				
				name = "Ambush8_2a",
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,											
				spawn = mkr_ambush8_2,
				conditions = {XP1_GetNodeStrength() >= 5},
			},


		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_ambush8Def,
			garrisonIdle = false,
			garrison = false,			
			range = 15,
			leashRange = 15,
			retaliateAttacks = true,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Ability, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_ambush1_def1_Facing},
		},
	}
	local enc_Ambush8_2 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Ambush8_2
end


ENCOUNTERS.Base1_1 = function()
	local encData = {
		name = "Base1_1",
		sgroups = {sg_baseTable[1], sg_allEnemyTroops},
		spawn = {mkr_base1_1},
		units = {
			{				
				name = "Base1_1",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP}),
				spawn = mkr_base1_1,
				conditions = {XP1_GetNodeStrength() <= 3},				
			},
			
			{				
				name = "Base1_1",
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},													
				spawn = mkr_base1_1,
				conditions = {XP1_GetNodeStrength() == 4},
			},
			{				
				name = "Base1_1",
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,											
				spawn = mkr_base1_1,
				conditions = {XP1_GetNodeStrength() >= 5},
			},

		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_base1_1,
			garrisonIdle = true,
			garrison = true,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_ambush1_def1_Facing},
		},
	}
	local enc_Base1_1 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Base1_1
end

ENCOUNTERS.Base1_2 = function()
	local encData = {
		name = "Base1_2",
		sgroups = {sg_baseTable[1], sg_allEnemyTroops},
		spawn = {mkr_base1_2},
		units = {
			{				
				name = "Base1_2a",
				sbp = SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP,
				spawn = mkr_base1_2,			
			},
			
			{				
				name = "Base1_2b",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP}),
				spawn = mkr_base1_2,
				conditions = {XP1_GetNodeStrength() <= 3},				
			},
			
			{				
				name = "Base1_2b",
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},													
				spawn = mkr_base1_2,
				conditions = {XP1_GetNodeStrength() == 4},
			},
			{				
				name = "Base1_2b",
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,											
				spawn = mkr_base1_2,
				conditions = {XP1_GetNodeStrength() >= 5},
			},

		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_base1_2,
			garrisonIdle = true,
			garrison = true,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_ambush1_def1_Facing},
		},
	}
	local enc_Base1_2 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Base1_2
end

ENCOUNTERS.Base1_3 = function()
	local encData = {
		name = "Base1_3",
		sgroups = {sg_baseTable[1], sg_allEnemyTroops},
		spawn = {mkr_base1_3},
		units = {
			{				
				name = "Base1_3a",
				sbp = SBP.WEST_GERMAN.GRW34_81MM_MORTAR_SQUAD_MP,
--~ 				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
--~ 				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},						
--~ 				difficulty = {GD_EASY, GD_NORMAL},
				instantSetup = true,
				spawn = mkr_base1_3,			
			},
			
			{				
				name = "Base1_3b",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP}),
				spawn = mkr_base1_3,
				conditions = {XP1_GetNodeStrength() <= 3},				
			},
			
			{				
				name = "Base1_3b",
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},													
				spawn = mkr_base1_3,
				conditions = {XP1_GetNodeStrength() == 4},
			},
			{				
				name = "Base1_3b",
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,											
				spawn = mkr_base1_3,
				conditions = {XP1_GetNodeStrength() >= 5},
			},

		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_base1_3,
			garrisonIdle = true,
			garrison = true,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_ambush1_def1_Facing},
		},
	}
	local enc_Base1_3 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Base1_3
end


ENCOUNTERS.EnemyPoint4_Def1 = function()
	local encData = {
		name = "EnemyPoint4_Def1",
		sgroups = {sg_point4Def_1, sg_allEnemyTroops},
		spawn = {mkr_point4_def1},
		units = {	
			
			{				
				name = "EnemyPoint4_Def1a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				--slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				--dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},						
				difficulty = {GD_EASY},
				spawn = mkr_point4_def3,				
			},			
			{				
				name = "EnemyPoint4_Def1a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},						
				difficulty = {GD_NORMAL, GD_HARD},
				spawn = mkr_point4_def3,				
			},			
			
			{				
				name = "EnemyPoint4_Def1a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				--difficulty = {GD_HARD},
				spawn = mkr_point4_def1,				
			},
		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_point4TargetArea,
			garrisonIdle = false,
			garrison = false,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_point4_def1_Facing},
		},
	}
	local enc_Point4_Def1 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Point4_Def1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	return enc_Point4_Def1
end

ENCOUNTERS.EnemyPoint4_Def1b = function()
	local encData = {
		name = "EnemyPoint4_Def1b",
		sgroups = {sg_point4Def_1, sg_allEnemyTroops},
		spawn = {mkr_point4_def1},
		units = {	

			{				
				name = "EnemyPoint4_Def1b",
				sbp = SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP,
				instantSetup = true,
				spawn = mkr_point4_def2,
				difficulty = {GD_NORMAL, GD_HARD},
			},			
		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = eg_point4Building,
			garrisonIdle = false,
			garrison = true,
			range = 20,
			leashRange = 20,
			retaliateAttacks = false,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_point4_def1_Facing},
		},
	}
	local enc_Point4_Def1b = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Point4_Def1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	return enc_Point4_Def1b
end

ENCOUNTERS.EnemyPoint4_Def1c = function()
	local encData = {
		name = "EnemyPoint4_Def1c",
		sgroups = {sg_point4Def_1, sg_allEnemyTroops},
		spawn = {mkr_point4_def1},
		units = {	

			{				
				name = "EnemyPoint4_Def1c",
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
				instantSetup = true,
				spawn = mkr_point4_def4,
				difficulty = {GD_NORMAL, GD_HARD},
			},				
		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_point4_def4,
			garrisonIdle = false,
			garrison = true,
			range = 30,
			leashRange = 2,
			retaliateAttacks = false,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_point4_def1_Facing},
		},
	}
	local enc_Point4_Def1c = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Point4_Def1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	return enc_Point4_Def1c
end


ENCOUNTERS.EnemyPoint4_Def2 = function()
	local encData = {
		name = "EnemyPoint4_Def2",
		sgroups = {sg_point4Def_2, sg_allEnemyTroops},
		spawn = {mkr_point4_def2_1},
		units = {	
			
			{				
				name = "EnemyPoint4_Def2a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				--slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				--dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},						
				difficulty = {GD_EASY},				
			},			
			
			{				
				name = "EnemyPoint4_Def2a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},						
				difficulty = {GD_NORMAL},				
			},			
			{				
				name = "EnemyPoint4_Def2a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				slotItems = {SLOT_ITEM.PANZERSHRECK_MP},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK_MP, dropChance = 0.5, exclusive = nil}},						
				difficulty = {GD_HARD},				
			},	
			{				
				name = "EnemyPoint4_Def2b",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP}),				
				difficulty = {GD_HARD},				
			},				

			
		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_point4_def3,
			
			range = 20,
			leashRange = 20,
			retaliateAttacks = false,			
			tacticControlList = {
				{tacticType = TACTIC_Cover, priority = 300},
				{tacticType = TACTIC_Ability, priority = 200},
			},
			
		},
	}
	local enc_Point4_Def2 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Point4_Def1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	return enc_Point4_Def2
end


ENCOUNTERS.EnemyPoint3_Def1 = function()
	local encData = {
		name = "EnemyPoint3_Def1",
		sgroups = {sg_point3Def1, sg_allEnemyTroops},
		spawn = {mkr_point3_def1},
		units = {
			{				
				name = "EnemyPoint3_Def1a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				--slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				--dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},						
				--difficulty = {GD_EASY, GD_NORMAL},
				spawn = mkr_point3_def1,				
			},			
			{				
				name = "EnemyPoint3_Def1a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				--difficulty = {GD_HARD},
				spawn = mkr_point3_def2,				
			},
			{				
				name = "EnemyPoint3_Def1b",
				sbp = SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP,
				instantSetup = true,
				spawn = mkr_point3_def3,

			},
			
		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_point3_def1,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_point3_def1_Facing},
		},
	}
	local enc_EnemyPoint3Def1 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_EnemyPoint3Def1
end



-- add reinforcement waves.  

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
