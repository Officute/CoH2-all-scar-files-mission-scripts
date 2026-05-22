print("\tLoading mission file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- MISSION NAME
-- Designer: Joe Smith
-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScriptSetup.scar") -- <== ### CRITICAL ELEMENT. 
import("XP1.scar")				-- Ardennes Assault functionality


-- [[ Objective files ]]
import("Stoumont_obj_DefendStoumont.scar") -- [[ Objective files ]]

-- [[ Encounter data ]]
import("Libraries/WaveManager/WaveManager_Core.scar")
import("Stoumont_encounters.scar")


-------------------------------------------------------------------------
-- [[ MISSION SETUP ]]
-------------------------------------------------------------------------
-- Initializes players
function Mission_SetupPlayers()
	--TODO: Initialize your player variables. Depending on the type of scenario, this can vary.
	
	--For Missions/Challenges:
	player1 = Setup_Player(1, 11073202, "aef", 1)		-- player1 is always the human player
	player2 = Setup_Player(2, 11073205, "west_german", 2)		-- player2 is always the AI opponent
	player3 = Setup_Player(3, 11073202, "aef", 1)		-- player3 is always the AI ally
	
	--For coop-scenarios/Battles:
--~ 	__Team_Init()
--~ 	player1, player2, player3, player4 = Team_DefineAllies()
--~ 	player5, player6, player7, player8 = Team_DefineEnemies()
end

-- Defines key mission data and any global values used throughout the mission.
function Mission_SetupVariables()
	print("Initializing mission DATA...")
	
	--TODO: Define mission initialization data. Example in comments on the bottom of this file.
	-- ### CRITICAL ELEMENT. This table contains all the initialization data for the mission.
	g_missionData = {
		useBeginnerHints = false,					-- Wether or not to use the BeginnerHint system
		useEncounterSystem = true,					-- Whether or not to use the Encounter system
		useXP1Difficulty = true,					-- Whether or not this mission uses the XP1 Difficulty system
		missionType = MT_XP1_CHALLENGE,				-- What Mission Type is this mission? MT_
		introNIS = "XP1/Stoumont_Intro",			 					-- Movie filename
		introNISlet = nil,					 		-- NISlet triggered after introNIS
		introNISletSkipped = nil,	 				-- Function called if the introNISlet is skipped
		introSitRep = nil,							-- Movie (string) to play after intro nislet
		endNISlet = nil,							-- NISlet triggered on mission completion
		endNIS = nil,								-- Movie (string) to play on mission completion
		missionSpeechPath = "botb/gameplay",					-- Speech path to cache (string)
		precacheSounds = {							-- Any audio files you want precached (list of strings)
		},
		nisFiles = {								-- .nis files associated with the mission (path string)
		},
		nisInTransitionTime = 0,
		nisOutTransitionTime = 0,
		objectives = {								-- List of PARENT objective tables.
			OBJ_DefendStoumont,							-- These are the global references to the objective tables defined in the separete files.
		},
		atmosphere = nil,							-- Loads an atmosphere for this mission. Useful for battles and mini challenges

		secondaryObjectives = {
			{
				obj = SecondaryOBJ_KillVIP,
				data = {
					spawns = {
						{spawn = mkr_secondaryObj1, ui = mkr_secondaryObj1},
					},
				},
			},

			{
				obj = SecondaryOBJ_DestroyTank,
				data = {
					spawns = {
						{spawn = mkr_tankObjective, ui = mkr_tankObjective},
					},
					--protectEncounter = ENCOUNTERS.protectVIP,
				},
			},
			{
				obj = SecondaryOBJ_CaptureIntel,
				data = {
					locations = {mkr_enemyRally1, mkr_ambush7_2, mkr_ambush1_2},
					number_to_spawn = 2,
					number_to_capture = 2,
					base_area = mkr_playerBaseArea,
				},
			},
		},
		
--~ 		startingUnits = {							-- Units to be spawned for P1 on mission start. Follows same parameters as Encounters.
--~ 			{
--~ 				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
--~ 				spawn = mkr_troopDrop,
--~ 				upgrades = nil,
--~ 				entityUpgrades = nil,
--~ 				slotItems = nil,
--~ 				numSquads = nil,
--~ 				load = nil,
--~ 				veterancyRank = nil,
--~ 				difficulty = nil,
--~ 				conditions = nil,
--~ 				commanderDivision = nil,
--~ 			},
--~ 			{
--~ 				sbp = SBP.GERMAN.GRENADIER_SQUAD,
--~ 				spawn = mkr_troopDrop,
--~ 			},
--~ 		}
	}
	
	
	
	--[[GLOBAL VARIABLES]]
	--TODO: Define any global egroups/sgroups and variables
	
	CameraPos = nil
	
	sg_test = SGroup_CreateIfNotFound("sg_test")
	sg_temp = SGroup_CreateIfNotFound("sg_temp") -- goes in oninit
	
	sg_allEnemyTroops = SGroup_CreateIfNotFound("sg_allEnemyTroops")
	sg_point1Def1 = SGroup_CreateIfNotFound("sg_point1Def1")
	sg_point2Def1 = SGroup_CreateIfNotFound("sg_point2Def1")
	sg_point3Def1 = SGroup_CreateIfNotFound("sg_point3Def1")
	sg_point4Def_1 = SGroup_CreateIfNotFound("sg_point4Def_1")
	sg_point4Def_2 = SGroup_CreateIfNotFound("sg_point4Def_2")
	sg_mun1Def1 = SGroup_CreateIfNotFound("sg_mun1Def1")
	sg_mun2Def1 = SGroup_CreateIfNotFound("sg_mun2Def1")
	sg_fuel1Def1 = SGroup_CreateIfNotFound("sg_fuel1Def1")
	sg_fuel2Def1 = SGroup_CreateIfNotFound("sg_fuel2Def1")
	sg_fuel2Def2 = SGroup_CreateIfNotFound("sg_fuel2Def2")
	sg_fuel2Def3 = SGroup_CreateIfNotFound("sg_fuel2Def3")
	sg_fuel2Def4 = SGroup_CreateIfNotFound("sg_fuel2Def4")
	sg_fuel3Def1 = SGroup_CreateIfNotFound("sg_fuel3Def1")
	sg_fuel3Def2 = SGroup_CreateIfNotFound("sg_fuel3Def2")
	sg_fuel4Def1 = SGroup_CreateIfNotFound("sg_fuel4Def1")
	
	
	sg_waveOvergroup = SGroup_CreateIfNotFound("sg_waveOvergroup")
	sg_waveOvergroup1 = SGroup_CreateIfNotFound("sg_waveOvergroup1")
	sg_waveOvergroup2 = SGroup_CreateIfNotFound("sg_waveOvergroup2")
	sg_waveOvergroup3 = SGroup_CreateIfNotFound("sg_waveOvergroup3")
	
	-- wave attack subgroup for vehicles
	sg_vehicleAttackSubgroup = SGroup_CreateIfNotFound("sg_vehicleAttackSubgroup")
	sg_sanatoriumOvergroup = SGroup_CreateIfNotFound("sg_sanatoriumOvergroup")
	
	sg_sanatoriumOvergroupWave1 = SGroup_CreateIfNotFound("sg_sanatoriumOvergroupWave1")
	sg_sanatoriumOvergroupWave2 = SGroup_CreateIfNotFound("sg_sanatoriumOvergroupWave2")
	sg_sanatoriumOvergroupWave3 = SGroup_CreateIfNotFound("sg_sanatoriumOvergroupWave3")
	sg_sanatoriumOvergroupWave4 = SGroup_CreateIfNotFound("sg_sanatoriumOvergroupWave4")
	sg_sanatoriumOvergroupWave5 = SGroup_CreateIfNotFound("sg_sanatoriumOvergroupWave5")
	sg_sanatoriumOvergroupWave6 = SGroup_CreateIfNotFound("sg_sanatoriumOvergroupWave6")
	
	sg_firstWaveOvergroup = SGroup_CreateIfNotFound("sg_firstWaveOvergroup")
	sg_fuelRaiders = SGroup_CreateIfNotFound("sg_fuelRaiders")
	
	sg_commandTanks = SGroup_CreateIfNotFound("sg_commandTanks")
	sg_minionTanks = SGroup_CreateIfNotFound("sg_minionTanks")
	sg_ambushTable = SGroup_CreateTable("sg_ambushTable%d", 10)
	sg_baseTable = SGroup_CreateTable("sg_baseTable%d", 3)
	
	sg_alliedSanatoriumDef = SGroup_CreateTable("sg_alliedSanatoriumDef%d", 7)
	
	sg_pointCap1 = SGroup_CreateIfNotFound("sg_pointCap1")
	sg_pointCap2 = SGroup_CreateIfNotFound("sg_pointCap2")
	
	sg_allPlayerSquads = SGroup_CreateIfNotFound("sg_allPlayerSquads")
	
	sg_capturableVehicles = SGroup_CreateIfNotFound("sg_capturableVehicles")
	sg_enemySanatoriumTroops = SGroup_CreateIfNotFound("sg_enemySanatoriumTroops")
	
--~ 	t_fuelPoints = {eg_point4, eg_point3}
--~ 	eg_allFuel = EGroup_CreateIfNotFound("eg_allFuel")
--~ 	if t_fuelPoints ~= nil then
--~ 		for i = 1, table.getn(t_fuelPoints) do
--~ 			EGroup_AddEGroup(eg_allFuel, t_fuelPoints[i])
--~ 		end
--~ 	end
--~ 	
	
	sg_axisTest = SGroup_CreateIfNotFound("sg_axisTest")
	sg_axisSubTest = SGroup_CreateIfNotFound("sg_axisSubTest")
	sg_exampleTank = SGroup_CreateIfNotFound("sg_exampleTank")
	sg_exampleTroops = SGroup_CreateIfNotFound("sg_exampleTroops")
	_exampleVehicle = SGroup_CreateIfNotFound("_exampleVehicle")
	t_pointDialog = {
		--{point = eg_point4, speech = EVENTS.Point4Capped, speech2 = EVENTS.Point4ReCap, state = false},
		--{point = eg_point3, speech = EVENTS.Point3Capped, speech2 = EVENTS.Point3ReCap, state = false},
		{point = eg_sanatorium, speech = EVENTS.SanatoriumCapped, speech2 = EVENTS.SanatoriumReCap, state = false},
	}	
	
	
	t_munitionPoints = {eg_munitions1, eg_munitions2}
	t_capPoints = {eg_point1, eg_point2, eg_point3, eg_point4}
	t_allPoints = {eg_allPoints}
	

	g_currentPhase = 1
	g_phase1 = true
	g_phase2 = false
	g_phase3 = false
	g_phase4 = false
	g_phase5 = false
	g_phase6 = false
	g_bossSpawned = false
	g_spawnSpeech = false
	g_axisBossDefeated = false
	g_axisBossTriggered = false
	g_axisKeptAwayFromFuel = false
	g_axisOutOfFuel = false
	g_axisRetreatedOrDestroyed = false
	g_sanatoriumCaptured = false
	g_secondaryStarted = false
	g_waveDestroyed = false
	
	g_lastWave = false
	g_waveNumber = 1
	g_youWin = false
	g_youLose = false
	g_fuelPointsCaptured = 1
	g_fuelPointNumber = EGroup_Count(eg_fuelPoints)
	g_firstWave = true
	g_percentChanceOutOfFuel = 0
	g_intervalForFuelCheck = 30
	g_refuelCounter = 0
	g_endTimerLength = 10
	
	g_randomMaxStart = 5 -- default value for g_randomMax
	g_randomMax = g_randomMaxStart -- assigning g_randomMax the default value - used later on to determine the percentage chance a vehicle will lose fuel (chance / g_randomMax)
	g_randomMin = 4 -- default value for g_randomMin
	g_randomMin = g_randomMinStart -- assigning g_randomMin as the default value - used later on to determine the minimum percentage chance a vehicle will lose fuel.  g_randomMax should not decrease beyond this point
	g_abandonCount = 0
	
	g_refuelOff = false
	g_totalFuelTimer = 40
	g_currentFuelTimer = 40
	g_timerBattalionUpdate = true
	g_internalTimerStart = true
	g_tankUpdate = true
	g_culled = false
	g_missionOver = false
	
	tmr_sanatoriumCapTimer = "tmr_sanatoriumCapTimer" -- timer to keep track of how long the sanatorium is out of player hands
	tmr_sanatoriumWaveTimer = "tmr_sanatoriumWaveTimer" -- timer to keep track of time until last uber wave appears
	tmr_visibilityTimer = "tmr_visibilityTimer" -- timer to keep track of how long vehicles are in sight of the player
	tmr_internalRandomTimer = "tmr_internalRandomTimer"
	tmr_refuelTimer = "tmr_refuelTimer"
	tmr_endTimer = "tmr_endTimer"
	--[[MAP GROUPS]]
	--TODO: Document any egroups that are defined within the worldbuilder. For example:
	-- eg_bunkerP1: This egroup contains all the player-controlled bunkers placed on the map.
	
	--Cmd_Upgrade(player2, UPG.WEST_GERMAN.FALLSCHRIMJAGER_DISPATCH, nil, true)	
	
	Cmd_Upgrade(player1,  BP_GetUpgradeBlueprint("tanks_out_of_fuel"), nil, true)
	
	scavengeTarget_ID = nil
	sanatoriumPoint_ID = nil --HintPoint_Add(eg_sanatorium, true, LOC("Capture the Sanatorium Fuel Point"), 1, nil, nil)
	
	--EGroup_SetWorldOwned(eg_XP1_player_base)
	
	-- NODE STRENGTH flags ----------------
	g_stronger_enemy_positions = false	-- More starting enemies
	g_less_starting_defenses = false			-- Less weapons/fuel pickups at start
	g_heavy_armour = false						-- Enemy tanks during waves
	

	
end


-- Defines difficulty tables/tuning variables
function Mission_SetDifficulty(diffVal)
	--TODO: Define any difficulty-related settings or variables.
	-- These variables should be stored in a t_difficulty table for readability and access.
	
	g_difficulty = diffVal or Game_GetSPDifficulty() 	-- Note: Having the diffVal parameter allows for redefining difficulty settings during runtime.
	AI_OverrideDifficulty(g_difficulty)
	
	--Global difficulty table
	t_difficulty = {
		--axisFuelAmount = Util_DifVar({30,25,20}, g_difficulty)*60,	-- base time in minutes the enemy fuel will run out given a base rate of one unit of fuel removed a second			
		--fuelGain = Util_DifVar({50, 100, 150}, g_difficulty),
		axisFuelAmount = Util_DifVar({2000, 3000, 4000}, g_difficulty), -- Easy, Normal, Hard, respectively
		
		capTimerLength = Util_DifVar({180, 135, 105}, g_difficulty),
		setWaveTime = Util_DifVar(
			{
				{120, 110, 100, 90}, 
				{110, 100, 90, 80}, 
				{100, 90, 80, 70}, 
				
			},				
			g_difficulty),
		refuelTime = Util_DifVar(
			{
				{90, 80, 70, 60},
				{85, 75, 65, 55},
				{80, 70, 60, 50},
				
			},
			g_difficulty),
		kickoffTime = Util_DifVar(  --WaveTime - RefuelTime = KickoffTime
			{
				{30, 30, 30, 30},
				{25, 25, 25, 25},
				{20, 20, 20, 20},
				
			},
			g_difficulty),
			
	}
	
	g_totalFuel = t_difficulty.axisFuelAmount -- total fuel available for Axis on this map
	g_currentFuel = t_difficulty.axisFuelAmount -- default is full fuel but can be changed to some other number
	
	Player_SetResource(player1, RT_Manpower, 250)
	Player_SetResource(player1, RT_Munition, 60)
	Player_SetResource(player1, RT_Fuel, 60)
	
	-- player dynamic difficulty settings
	PM_PL_StartingResourceHit = true
	  
	-- enemy dynamic difficulty settings
	PM_AI_CPDefenses = true 
	PM_AI_BaseDefenses = true
	PM_AI_Defensiveness = true
	
	-- NODE STRENGTH TUNING ------------------------------
	if XP1_GetNodeStrength() >= 3 then 
		g_less_starting_defenses = true
	end
	
	if XP1_GetNodeStrength() >= 4 then 
		g_stronger_enemy_positions = true
	end
	
	if XP1_GetNodeStrength() >= 5 then 
		g_heavy_armour = true
	end
end

function Raid_Test()

	local goalData = {
			name = "Defend",
			target = mkr_wreckArea2,
			range = 35,
			leashRange = 50,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
		}
		
	g_abilityTest:SetGoal(goalData)


end


-- Sets restrictions on units, teams, etc.
function Mission_SetupRestrictions()
	--TODO: Set any tech/ability restrictions on a players, as well as resource limits.
	--	Note: Resource Income/Caps should be defined in Mission_SetDifficulty()
	
	--[[ HUMAN PLAYER ]]
--~ 	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.IS_2_HEAVY_TANK, ITEM_REMOVED)
	
	--[[ ALLIED PLAYER ]]
	
	--[[ ENEMY PLAYER ]]
	
end

-- Sets up the map before the mission starts (starting units, ownership, etc.)
function Mission_Preset()
	--TODO: Make changes to the initial state of the map (spawn/despawn units or entities, diable holds, etc.).
	Setup_StoumontAttack_Data()
	
	local _UIFuelEntityOff = function(gid, idx, eid)
		
		UI_EnableEntityMinimapIndicator(eid, false)
		
	end
	EGroup_ForEach(eg_fuel2, _UIFuelEntityOff)
	EGroup_ForEach(eg_fuel3, _UIFuelEntityOff)
	EGroup_ForEach(eg_fuel4, _UIFuelEntityOff)
	EGroup_ForEach(eg_outsidePoint, _UIFuelEntityOff)
	EGroup_ForEach(eg_otherPoints, _UIFuelEntityOff) -- eg_otherPoints defined in WB
	
	--EGroup_SetWorldOwned(eg_XP1_player_base)
	
	-- dudes given to the player in the beginning
	Util_CreateSquads(player1, sg_alliedSanatoriumDef[1], SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_startSpawn1, nil, 1)
	--Squad_GiveSlotItem(SGroup_GetSpawnedSquadAt(sg_alliedSanatoriumDef[1], 1), SLOT_ITEM.BAZOOKA_MP)
	
	Util_CreateSquads(player1, sg_alliedSanatoriumDef[2], SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_startSpawn2, nil, 1)
	--Squad_GiveSlotItem(SGroup_GetSpawnedSquadAt(sg_alliedSanatoriumDef[1], 1), SLOT_ITEM.BAZOOKA_MP)
	
--~ 	Util_CreateSquads(player1, sg_alliedSanatoriumDef[5], SBP.AEF.ASSAULT_ENGINEER_SQUAD_MP, mkr_startSpawn2, nil, 1)
--~ 	Squad_GiveSlotItem(SGroup_GetSpawnedSquadAt(sg_alliedSanatoriumDef[5], 1), SLOT_ITEM.ASSAULT_ENGINEER_FLAMETHROWER)
--~ 	
--~ 	Util_CreateSquads(player1, sg_alliedSanatoriumDef[6], SBP.AEF.M3_HALFTRACK_SQUAD_MP, mkr_startSpawn2, nil, 1)
	
	XP1_SetMissionSuccessLevel(1) -- initializes mission success level to 0 at beginning
	
	-- NODE STRENGTH: Despawn extra defenses
	if g_less_starting_defenses == true then
		EGroup_DeSpawn(eg_extra_defenses)
	end
end


-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
--Called once the intro nis/nislet/sitrep finishes playing.
function Mission_Start()
	Obj_ShowProgress2(11076829, g_currentFuelTimer/g_totalFuelTimer)		-- LOCDB [11076829] 'Enemy Fuel Reserves'
	
	Objective_Start(OBJ_DefendStoumont)
	
	Rule_AddDelayedInterval(DelayedStart, 1, 1)
	
	Util_StartIntel(EVENTS.GetReady)
	Rule_AddDelayedInterval(CheckInitCapOfSanatorium, 1, 1)

	Starting_Encounters()
end

-- delayed start for capture sanatorium fuel point objective so that the player gets this after the dialogue in the beginning
function DelayedStart()

	if Event_IsAnyRunning() == false then
		
		Objective_Start(SOBJ_CapSanatorium)
		CapPing = Objective_AddPing(SOBJ_CapSanatorium, Util_GetPosition(eg_sanatorium))
		Rule_RemoveMe()
		
	end
end

-- defining the attack wave data
function Setup_StoumontAttack_Data()
	local wmdt_sanatorium = function()
		local waveManagerData = {
			waves = {
				--ENCOUNTERS.SanatoriumFirstWave(),
				ENCOUNTERS.Sanatorium01_Overgroup1(),
				ENCOUNTERS.Sanatorium02_Overgroup1(),
				ENCOUNTERS.Sanatorium03_Overgroup1(),
				ENCOUNTERS.Sanatorium04_Overgroup1(),
				ENCOUNTERS.Sanatorium05_Final(),

			},
			-- each chunk is a different direction
			attackDirs = {
				{						-- spawn = The spawn point, dynSpawn = Dynamic spawn target, ui = location for hintpoints, target = target for goal
					{spawn = mkr_enemySpawn1, dynSpawn = mkr_enemyDynSpawn1, ui = nil, target = eg_sanatorium, rallyPoint = mkr_enemyRally1},
				},	
--~ 				{
--~ 					{spawn = mkr_enemySpawn3, dynSpawn = mkr_enemyDynSpawn3, ui = nil, target = mkr_enemyDest2, rallyPoint = mkr_enemyRally2},
--~ 				},
				{
					{spawn = mkr_enemySpawn3, dynSpawn = mkr_enemyDynSpawn3, ui = nil, target = eg_sanatorium, rallyPoint = mkr_enemyRally3},
				},
--~ 				{
--~ 					{spawn = mkr_enemySpawn3, dynSpawn = mkr_enemyDynSpawn3, ui = nil, target = mkr_enemyDest4, rallyPoint = mkr_enemyRally4},					
--~ 				},
				{
					{spawn = mkr_enemySpawn5, dynSpawn = mkr_enemyDynSpawn5, ui = nil, target = eg_sanatorium, rallyPoint = mkr_enemyRally5},					
				},
				
			},
			
			retreatDirs = {mkr_enemyRetreat1, mkr_enemyRetreat2, mkr_enemyRetreat3, mkr_enemyRetreat4, mkr_enemyRetreat5}, -- list of retreat points, closest one out of this list is picked
			
			waveCompleteConditionData = {
				--condition = CONDITION_INFINITE_DURATION,
				--condition = CONDITION_TIMER_ENDED,
				condition = CONDITION_UNITS_LEFT,  --CONDITION_GROUP_IS_DEAD
				variable = 1,
				wave_retreats = true,
				vehicles = 0, -- used when condition is check alive, check for minimum threshold of vehicles - 0 means vehicles have to die first or have 0 vehicles and 1 means at least 1 vehicle can remain alive before retreat, works only for condition_units_left
			},
			
			groups = {
				commandGroup = SGroup_CreateIfNotFound("sg_e_sanatorium_all"),
				vehicleGroup = SGroup_CreateIfNotFound("sg_vehicleSanatoriumSGroup"),
			},
			defaultGoalData = {
				name = "Attack",
				--name = "Move",
				target = nil,
				range = 15,
				leashRange = 30,				
				attackMove = true,		
				attackEngagementMove = true,
				garrison = true,
				pickupWeapons = true,
				movePathLengthFactor = 1,
				coordinatedMoveRadius = 10,
			},
			rallyGoalData = {
				name = "Move",
				target = nil,
				range = 20,
				leashRange = 20,
				attackMove = true,
			},
			callbackData = {
				onComplete = function()
					print("DERP stoumont wave complete")
					--XP1_IncrementMissionSuccessLevel(10) -- add to success level
					
					if Timer_IsPaused(tmr_sanatoriumWaveTimer) == true then
						print("RESUME TIMER")
						Timer_Resume(tmr_sanatoriumWaveTimer)
					end


				end,
				
				onSpawn = function()
					
				-- to account for the fact that sometimes enemies spawn from two or more directions
					if g_lastWave == false then
						if g_spawnSpeech == false then
							g_spawnSpeech = true
							
							Rule_AddDelayedInterval(ResetSpawnSpeech, 30,1)						
							--Event_PlayerCanSeeElement(VisibleTimerStart, {vehicles = sg_vehicleAttackSubgroup}, player1, sg_vehicleAttackSubgroup, ALL)
							
							if Rule_Exists(VisibleVehicleCheck) == false then
								Rule_AddDelayedInterval(VisibleVehicleCheck, 5, 1)
							end
							
							Event_GroupIsDead(WaveDead, {}, sg_sanatoriumOvergroup)
						end	
					elseif g_lastWave == true then
						print("LAST CALL!!!!!")

						Util_StartIntel(EVENTS.LastWave)						
					
						if Rule_Exists(HeavyTankSpeech) == false then
							Rule_AddDelayedInterval(HeavyTankSpeech, 1, 1)
						end
						
						if Rule_Exists(VisibleVehicleCheck) == false then
							Rule_AddDelayedInterval(VisibleVehicleCheck, 5, 1)
						end
					
					
						if Rule_Exists(LastWaveCheck) == false then
							print("last wave check added")
							Rule_AddDelayedInterval(LastWaveCheck, 15, 0)			
						end			
						WaveManager_RemoveWaveManager(wmdt_sanatorium_attack)	
					end
					if g_timerBattalionUpdate == false then
						g_timerBattalionUpdate = true -- reactivate the possibility of progress bar
					end
					
				end
			},
		}
		
		return waveManagerData
	end
	
	wmdt_sanatorium_attack = WaveManager_SetupNewManagerTable(wmdt_sanatorium, false)

end

-- defining the enemies on the map
function Starting_Encounters()
	--g_fuel1 = ENCOUNTERS.Fuel1_Def1
	g_fuel2 = ENCOUNTERS.Fuel2_Def1()
	g_fuel2_2 = ENCOUNTERS.Fuel2_Def2()
	g_fuel2_3 = ENCOUNTERS.Fuel2_Def3()
	g_fuel2_4 = ENCOUNTERS.Fuel2_Def4()
	g_fuel3 = ENCOUNTERS.Fuel3_Def1()
	g_fuel3_2 = ENCOUNTERS.Fuel3_Def2()
	g_fuel4 = ENCOUNTERS.Fuel4_Def1()
	g_enemySanatorium_1 = ENCOUNTERS.EnemySanatorium_1()
	g_enemySanatorium_2 = ENCOUNTERS.EnemySanatorium_2()
	g_enemySanatorium_3 = ENCOUNTERS.EnemySanatorium_3()
	g_enemySanatorium_4 = ENCOUNTERS.EnemySanatorium_4()
	g_enemySanatorium_5 = ENCOUNTERS.EnemySanatorium_5()
	g_point1 = ENCOUNTERS.Point1_Def1()
	g_point1_2 = ENCOUNTERS.Point1_Def2()
	--g_point1_3 = ENCOUNTERS.Point1_Def3()
	g_point2 = ENCOUNTERS.Point2_Def1()
	g_ambush3_1 = ENCOUNTERS.Ambush3_1() 
	g_ambush3_2 = ENCOUNTERS.Ambush3_2() 
	g_ambush3_3 = ENCOUNTERS.Ambush3_3() 
	g_ambush7_1 = ENCOUNTERS.Ambush7_1() 
	g_ambush7_2 = ENCOUNTERS.Ambush7_2() 
	g_ambush8_1 = ENCOUNTERS.Ambush8_1() 
	g_ambush8_2 = ENCOUNTERS.Ambush8_2() 
	--g_base1_1 = ENCOUNTERS.Base1_1() 
	--g_base1_2 = ENCOUNTERS.Base1_2() 
	--g_base1_3 = ENCOUNTERS.Base1_3() 
	g_point3_def1 = ENCOUNTERS.EnemyPoint3_Def1() 
	g_point4_def1 = ENCOUNTERS.EnemyPoint4_Def1() 
	g_point4_def1b = ENCOUNTERS.EnemyPoint4_Def1b() 
	g_point4_def1c = ENCOUNTERS.EnemyPoint4_Def1c()
	g_point4_def2 = ENCOUNTERS.EnemyPoint4_Def2() 
	
	-- making specific enemies move into a spot when triggered to make their response more dynamic
	Event_Proximity(
		EventHandler_AssignEncounterGoal, {
			encounter = g_enemySanatorium_5,
			goalData = {
				name = "Defend",
				target = mkr_sanatoriumDef6_Area,
				range = 15,
				leashRange = 15,
				retaliateAttacks = false,
				
				tacticControlList = {
					{tacticType = TACTIC_Ability, priority = 200},
					{tacticType = TACTIC_CaptureTeamWeapon, priority = 300},
				},
				
			},
		},
			player1, mkr_sanatoriumDef6_Area_Trigger, 30, ANY
	)
	
	Event_Proximity(
		EventHandler_AssignEncounterGoal, {
			encounter = g_enemySanatorium_1,
			goalData = {
				name = "Defend",
				target = mkr_sanatoriumDef1,
				range = 10,
				leashRange = 10,
				retaliateAttacks = false,
				
				tacticControlList = {
					{tacticType = TACTIC_Hold, priority = 200},
				},
				
			},
		},
			player1, mkr_sanatoriumDef1_Trigger, 30, ANY
	)
	
	Event_Proximity(
		EventHandler_AssignEncounterGoal, {
			encounter = g_fuel2_2,
			goalData = {
				name = "Defend",
				target = mkr_fuel2_prox,			
				garrison = true,
				range = 20,
				leashRange = 20,
				retaliateAttacks = false,
				
				tacticControlList = {
					{tacticType = TACTIC_Hold, priority = 200},
				},
				
			},
		},
			player1, mkr_fuel2_prox, 25, ANY
	)
	
	Event_Proximity(
		EventHandler_AssignEncounterGoal, {
			encounter = g_fuel2_3,
			goalData = {
				name = "Defend",
				target = mkr_fuel2_prox,
				range = 20,
				leashRange = 20,
				retaliateAttacks = false,
				
				tacticControlList = {
					{tacticType = TACTIC_Hold, priority = 200},
				},
				
			},
		},
			player1, mkr_fuel2_prox, 25, ANY
	)
	
	
	Event_Proximity(
		EventHandler_AssignEncounterGoal, {
			encounter = g_fuel3_2,
			goalData = {
				name = "Defend",
				target = mkr_fuel3TargetArea,
				range = 30,
				leashRange = 30,
				retaliateAttacks = false,
				
				tacticControlList = {
					{tacticType = TACTIC_Ability, priority = 200},
				},
				
			},
		},
		player1, mkr_fuel3TargetArea, 15, ANY
	)
	
	Event_Proximity(
		EventHandler_AssignEncounterGoal, {
			encounter = g_point1,
			goalData = {
				name = "Defend",
				target = mkr_point1TargetArea,
				range = 20,
				leashRange = 20,
				retaliateAttacks = true,
				garrisonIdle = false,
				garrison = false,
				tacticControlList = {
					{tacticType = TACTIC_Cover, priority = 500},
					{tacticType = TACTIC_Ability, priority = 200},
				},
				
			},
		},
			player1, mkr_point1TargetArea, 25, ANY
	)

--~ 	Event_Proximity(
--~ 		EventHandler_AssignEncounterGoal, {
--~ 			encounter = g_point1_2,
--~ 			goalData = {
--~ 				name = "Defend",
--~ 				target = mkr_point1TargetArea,
--~ 				range = 15,
--~ 				leashRange = 15,
--~ 				garrisonIdle = false,
--~ 				garrison = false,
--~ 				retaliateAttacks = false,
--~ 				
--~ 				tacticControlList = {
--~ 					{tacticType = TACTIC_Cover, priority = 500},
--~ 					{tacticType = TACTIC_Ability, priority = 200},
--~ 				},
--~ 				
--~ 			},
--~ 		},
--~ 			player1, mkr_point1TargetArea, 25, ANY
--~ 	)
--~ 	
--~ 		Event_Proximity(
--~ 		EventHandler_AssignEncounterGoal, {
--~ 			encounter = g_point1_3,
--~ 			goalData = {
--~ 				name = "Defend",
--~ 				target = mkr_point1TargetArea,
--~ 				range = 15,
--~ 				leashRange = 15,
--~ 				garrisonIdle = false,
--~ 				garrison = false,
--~ 				retaliateAttacks = false,
--~ 				
--~ 				tacticControlList = {
--~ 					{tacticType = TACTIC_Cover, priority = 600},
--~ 					{tacticType = TACTIC_Ability, priority = 200},
--~ 				},
--~ 				
--~ 			},
--~ 		},
--~ 			player1, mkr_point1TargetArea, 25, ANY
--~ 	)
	
		Event_Proximity(
		EventHandler_AssignEncounterGoal, {
			encounter = g_point4_def2,
			goalData = {
				name = "Defend",
				target = mkr_point4TargetArea,
				range = 25,
				leashRange = 25,
				retaliateAttacks = true,
				
				tacticControlList = {
					{tacticType = TACTIC_Ability, priority = 200},
					{tacticType = TACTIC_CaptureTeamWeapon, priority = 300},
				},
				
			},
		},
			player1, mkr_point4TargetArea, 25, ANY
	)
	
end

-- function for starting secondary objective, with event checking
function StartSecondary()

	if Event_IsAnyRunning() == false then
		
		--World_IncreaseInteractionStage()
		Mission_StartSecondaryObjective()
		
		Rule_RemoveMe()
	end
end




-- Initial attack on Sanatorium
-- Init check of capture by player of first area
function CheckInitCapOfSanatorium()

	if EGroup_IsCapturedByPlayer(eg_sanatorium, player1, ANY) == true then

		if Event_IsAnyRunning() == false then
			
			Objective_Complete(SOBJ_CapSanatorium)
			g_currentFuelTimer = 30
			
			Obj_ShowProgress2(11076829, g_currentFuelTimer/g_totalFuelTimer)	
			
			Rule_AddDelayedInterval(DefendSanatoriumObjectivePreDelay, 2, 1)
			
			Rule_AddDelayedInterval(RetreatEnemySanatoriumTroops, 1, 1)
			
			--XP1_IncrementMissionSuccessLevel(10)
			
			Rule_RemoveMe()
			
		end
	end
end

-- ensures that no event is running until dialogue telling the player to hold the position gets played
function DefendSanatoriumObjectivePreDelay()

	if Event_IsAnyRunning() == false then
		Util_StartIntel(EVENTS.SanatoriumTaken)		
		Rule_AddInterval(DefendSanatoriumObjectiveStart, 1)
		Rule_RemoveMe()
		
	end
end


-- Once Sanatorium fuel point is captured, enemy troops will retreat
function RetreatEnemySanatoriumTroops()

	if SGroup_IsAlive(sg_enemySanatoriumTroops)then
		
		if SGroup_IsRetreating(sg_enemySanatoriumTroops, ANY) == false then
			
			Cmd_Retreat(sg_enemySanatoriumTroops, mkr_enemyRetreat1, mkr_enemyRetreat1)			
		end

	end
end

-- delayed start, ensures objective is displayed after dialogue and the "capture vehicle" section starts
function DefendSanatoriumObjectiveStart()
	if Event_IsAnyRunning() == false then	
		Objective_Start(SOBJ_DefendSanatorium)				
		--Objective_SetCounter(SOBJ_DefendSanatorium, 1, 5)
		
		-- initialize example tank/vehicle section
		Rule_AddDelayedInterval(StartExampleTank, 30, 1)
		Rule_RemoveMe()
	end
end




-- EXAMPLE TANK/VEHICLE
-- Once Sanatorium captured, a vehicle will pop into view and become abandoned and immobilized.  this is to open up the interactive area and start the generation function.  
-- Event_IsAnyRunning is used to ensure it occurs after the objective is given
function StartExampleTank()

	if Event_IsAnyRunning() == false then
		--Rule_AddOneShot(CinematicStart, 3.5)
		Rule_AddOneShot(CreateDecrewedVehicleAndEscort, 4, 1)
		Rule_RemoveMe()
	end	
end

-- Function for creating the crewed vehicle to lose fuel and its escort and dialogue about it, and kicks off the fuel loss timer when it's visible
function CreateDecrewedVehicleAndEscort()
	
	Util_CreateSquads(player2, sg_exampleTank, SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP, mkr_enemyVehicleExample, mkr_tankDest, nil, nil, false, EGroup_GetPosition(eg_sanatorium))
	Util_CreateSquads(player2, sg_exampleTroops, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_enemyVehicleExample, mkr_tankDest2, 1, nil, false, EGroup_GetPosition(eg_sanatorium))
	Util_CreateSquads(player2, sg_exampleTroops, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_enemyVehicleExample, mkr_tankDest3, 1, nil, false, EGroup_GetPosition(eg_sanatorium))
	Modify_WeaponDamage(sg_exampleTank, "hardpoint_01", 0.05)
	Modify_WeaponAccuracy(sg_exampleTank, "hardpoint_01", 0.10)
	
	SGroup_SetInvulnerable(sg_exampleTank, 0.5)
		
	--Cmd_Move(sg_exampleTank, mkr_tankDest, nil, nil, EGroup_GetPosition(eg_sanatorium), nil, nil, nil)
	Util_StartIntel(EVENTS.ExampleAppear)
	
	-- Kicks off the fuel loss timer when it's visible
	Event_PlayerCanSeeElement(ExampleTimerStart, {}, player1, sg_exampleTank, ANY)
	--Event_IsUnderAttack(ExampleTimerStart, {}, sg_exampleTank, ANY, 1, player1)
end

-- "example" tank stuff - the tank that loses fuel at the beginning after points are capped - initializes the time it takes to lose fuel, and display of such information
function ExampleTimerStart()
	print("TimerStarted!")
	if Timer_Exists(tmr_visibilityTimer) then
	
		Timer_End(tmr_visibilityTimer)
		g_refuelOff = true
		Timer_Start(tmr_visibilityTimer, g_currentFuelTimer/2) -- restarts timer
	else
	
		Timer_Start(tmr_visibilityTimer, g_currentFuelTimer/2)
	end
	
	if Rule_Exists(DisplayTankTimer) == false then
		Rule_AddInterval(DisplayTankTimer, 1)
	end
	
	if Rule_Exists(ManageExampleTank) == false then
		Rule_AddInterval(ManageExampleTank, 1)
	end
end

-- displays the progress bar of example vehicle/tank
function DisplayTankTimer()

	if g_tankUpdate== true then
		-- shows progress bar of fuel, according to time elapsed of current fuel timer out of total fuel timer
		Obj_ShowProgress2(11076829, 1 - (Timer_GetElapsed(tmr_visibilityTimer)*2/g_totalFuelTimer) - (1 - (g_currentFuelTimer/g_totalFuelTimer)))	
	
	elseif g_tankUpdate == false then
		Obj_ShowProgress2(11076829, 0)
		-- keep bar at 0
		--Obj_HideProgress()
		
		Rule_RemoveMe()
	
	end

end

-- makes sure that when the example vehicle is visible, and time limit is up, then the vehicle gets the "loss of fuel" state
function ManageExampleTank()
	
	if SGroup_IsEmpty(sg_exampleTank) == false then
	
		if Timer_GetElapsed(tmr_visibilityTimer) *2>= g_currentFuelTimer then
			--Obj_HideProgress()
			g_tankUpdate = false


			if Player_CanSeeSGroup(player1, sg_exampleTank, ANY) then
				ExampleAbandon(sg_exampleTank)
				Rule_AddDelayedInterval(ExampleTroopsDead, 1,1)
			
				g_refuelOff = true -- for the meter
				Rule_RemoveMe()
			end
			
			
			--Rule_AddDelayedInterval(CapPointObjectiveSetup, 5, 1)			
			
		end
	elseif SGroup_IsEmpty(sg_exampleTank) == true then -- or if tank destroyed!
		--Rule_AddDelayedInterval(CapPointObjectiveSetup, 5, 1)			
		Rule_AddDelayedInterval(ExampleTroopsDead, 1,1)
		Rule_RemoveMe()
	end
end	

-- checks to see when example troops are dead so that the cap extra fuel points objective gets kicked off
function ExampleTroopsDead()

	if SGroup_IsAlive(sg_exampleTroops) == false then
		Rule_AddDelayedInterval(CapPointObjectiveSetup, 5, 1)				
		--XP1_IncrementMissionSuccessLevel(10)
		Obj_ShowProgress2(0,0)
		Obj_HideProgress() -- disables fuel bar when this wave is over
		Rule_RemoveMe()
	end

end

-- function to cause the example vehicle to get abandoned.
function ExampleAbandon(vehicleSGroup)
	local vehicle = vehicleSGroup
	local _DisableVehicle = function(gid, idx, sid)
		
		if Squad_Count(sid) >= 1 then
			if Entity_IsVehicle(Squad_EntityAt(sid, 0)) then
				
				--local tempVehicle = SGroup_Create("tempVehicle")
				SGroup_Add(_exampleVehicle, sid)				
				FOW_RevealSGroup(_exampleVehicle, 15)
				Cmd_CriticalHit(player2, _exampleVehicle, CRIT.VEHICLE_OUT_OF_FUEL_GERMAN_SP, 0.5)							
				Event_Timer(TankHint, {vehicle = _exampleVehicle}, 3.5)
				--exampleTank = HintPoint_Add(SGroup_GetPosition(tempVehicle), true, LOC("Capture and refuel this vehicle!"), 2)
				
				--SGroup_SetWorldOwned(tempVehicle)
				
				SGroup_AddGroup(sg_capturableVehicles, _exampleVehicle)
				
				Util_StartIntel(EVENTS.TankNoFuel)
				
				Event_NarrativeEventsNotRunning(StartCapVehicleObjective, {}) -- when narrative events not running, kick off the "capture and refuel vehicle" objective
				
			end
		end
	end
	
	SGroup_ForEach(vehicle, _DisableVehicle)
	SGroup_Clear(vehicle)
	
end

function TankHint(data)
	exampleTank = HintPoint_Add(SGroup_GetPosition(data.vehicle), true, 11076830, 2)		-- LOCDB [11076830] 'Capture and refuel this vehicle'
end

-- Kicks off the actual capture and refuel vehicle objective, for the example vehicle
function StartCapVehicleObjective()
	Objective_Start(SOBJ_RefuelVehicle)
	Rule_AddDelayedInterval(DetectExampleTankCapture, 1, 1)

end

-- it's a check to see if the player has captured any of the west german vehicles, in case the player doesn't capture the initial vehicle and just decides to do his own thing
function DetectExampleTankCapture()

	Player_GetAll(player1, sg_allPlayerSquads)
	--SGroup_AddGroup(sg_allPlayerSquads, Player_GetSquads(player1))
	if SGroup_ContainsBlueprints(sg_allPlayerSquads,
	{
		SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP,
		SBP.WEST_GERMAN.JAGDPANZER_TANK_DESTROYER_SQUAD_MP,
		SBP.WEST_GERMAN.JAGDTIGER_TD_SQUAD_MP,
		SBP.WEST_GERMAN.KING_TIGER_SQUAD_MP,
		SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP,
		SBP.WEST_GERMAN.PANTHER_AUSF_G_SQUAD_MP,
		SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
		SBP.GERMAN.PANZER_IV_SQUAD_MP,
		SBP.GERMAN.SCOUTCAR_SDKFZ222_MP,
		SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP,
		SBP.WEST_GERMAN.SDKFZ_251_20_IR_SEARCHLIGHT_HALFTRACK_SQUAD_MP,
		SBP.WEST_GERMAN.SDKFZ_251_20_IR_SEARCHLIGHT_HALFTRACK_SQUAD_SP,
		SBP.WEST_GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP_2,
		SBP.WEST_GERMAN.SDKFZ_251_WURFRAHMEN_40_HALFTRACK_SQUAD_MP,		
		SBP.GERMAN.STUG_III_SQUAD_MP,
		SBP.WEST_GERMAN.STURMTIGER_SQUAD_MP,
		
		SBP.GERMAN.TIGER_SQUAD,
	}, ANY) then
		
		Objective_Complete(SOBJ_RefuelVehicle)
		Util_StartIntel(EVENTS.TankCaptured)
 		
		if exampleTank ~= nil then
			HintPoint_Remove(exampleTank)
		end
		
		
		local _grabExampleTank = function(gid, idx, sid)
		
			if Squad_Count(sid) >= 1 then
				if Entity_IsVehicle(Squad_EntityAt(sid, 0)) and Squad_GetBlueprint(sid) == SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP then
					SGroup_Add(sg_exampleTank, sid)
					return
				end
			end	
		
		end
		SGroup_ForEach(sg_allPlayerSquads, _grabExampleTank)
		if SGroup_IsAlive(sg_exampleTank) then
			SGroup_SetInvulnerable(sg_exampleTank, false)
		end
		
		Rule_RemoveMe()
 	end
	
end



-- Fuel Point capture stuff
-- sets up the capture fuel points secondary objective
function CapPointObjectiveSetup()
	
	if Event_IsAnyRunning() == false then-- and g_focusReturned == true then
		Util_StartIntel(EVENTS.CapFuelPoints)
		Objective_Start(SOBJ_CapFuelPoints)
		
		Rule_Add(CheckFuelPoints)
		Rule_Add(FuelPointCapTracker)
		Rule_AddDelayedInterval(CheckSanatorium, 1,1)		
		Rule_AddDelayedInterval(DelayedPing, 5, 1)
		-- offset to after fuel point captured?
		Rule_AddDelayedInterval(DelayedAttackWave, 120, 1)
		Rule_RemoveMe()
	end
end

--~ -- delayed event for the dialogue displayed when the wave with the example vehicle is beaten off/finished
--~ function DelayedCapPointText()
--~ 	if Event_IsAnyRunning == false then
--~ 		Util_StartIntel(EVENTS.CapFuelPoints)
--~ 		Rule_RemoveMe()
--~ 	end
--~ end

--~ -- next capture objective kickoff
function NextCapPointObjectiveStart()	
	if Event_IsAnyRunning() == false then
		Util_StartIntel(EVENTS.CapFuelPoints2b)
		--Objective_Start(SOBJ_CapFuelPoints2)
		Rule_AddDelayedInterval(NextCapPointObjectiveStartDelay, 1, 1)
		
		Rule_RemoveMe()
	end

end

function NextCapPointObjectiveStartDelay()
	if Event_IsAnyRunning() == false then
		Objective_Start(SOBJ_CapFuelPoints2)
		Rule_RemoveMe()
	end
end

function DelayedPing() -- for first Fuel Point, turns on the fuel entity icon and kicks off ping
	if Event_IsAnyRunning() == false then
		
		if World_GetCurrentInteractionStage() < 1 then
			World_IncreaseInteractionStage() -- opens up area
		end
		
		hpid_fuel2 = Objective_AddUIElements(SOBJ_CapFuelPoints, eg_fuel2, true, 11076837, true)		-- LOCDB [11076837] 'Capture and Hold this Fuel Point'
		fuel2Ping = Objective_AddPing(SOBJ_CapFuelPoints, Util_GetPosition(eg_fuel2))		
		
		local _UIFuelEntityOn = function(gid, idx, eid)
			
			UI_EnableEntityMinimapIndicator(eid, true)
			
		end		
		
		EGroup_ForEach(eg_fuel2, _UIFuelEntityOn)
		--EGroup_ForEach(eg_fuel3, _UIFuelEntityOn)
		--EGroup_ForEach(eg_fuel4, _UIFuelEntityOn)
		EGroup_ForEach(eg_otherPoints, _UIFuelEntityOn) -- eg_otherPoints defined in WB
		
		--fuelBlip2 = UI_CreateMinimapBlip(Util_GetPosition(eg_fuel2), 3, BT_CaptureHere)
		--fuelBlip3 = UI_CreateMinimapBlip(Util_GetPosition(eg_fuel3), 3, BT_CaptureHere)
		--fuelBlip4 = UI_CreateMinimapBlip(Util_GetPosition(eg_fuel4), 10, BT_CaptureHere)
		Rule_AddInterval(DelayedPingB, 1)
		Rule_RemoveMe()
	end
end
-- ping kickoff from DelayedPing, done this way to ensure the ping appears after the icon shows up
function DelayedPingB()
	if Event_IsAnyRunning() == false then
		fuelBlip2 = UI_CreateMinimapBlip(Util_GetPosition(eg_fuel2), 5, BT_CaptureHere)
		Rule_RemoveMe()
	end
end

function DelayedPing2() -- for second Fuel Point
	if Event_IsAnyRunning() == false then
		if World_GetCurrentInteractionStage() < 2 then
			World_IncreaseInteractionStage() -- opens up scavenge area (area 2)
		end
		hpid_fuel3 = Objective_AddUIElements(SOBJ_CapFuelPoints2, eg_fuel3, true, 11076837, true)
		fuel3Ping = Objective_AddPing(SOBJ_CapFuelPoints2, Util_GetPosition(eg_fuel3))		
		local _UIFuelEntityOn = function(gid, idx, eid)
			
			UI_EnableEntityMinimapIndicator(eid, true)
			
		end				
		EGroup_ForEach(eg_fuel3, _UIFuelEntityOn)
		EGroup_ForEach(eg_outsidePoint, _UIFuelEntityOn)
		--fuelBlip2 = UI_CreateMinimapBlip(Util_GetPosition(eg_fuel2), 3, BT_CaptureHere)
		--fuelBlip3 = UI_CreateMinimapBlip(Util_GetPosition(eg_fuel3), 3, BT_CaptureHere)
		--fuelBlip4 = UI_CreateMinimapBlip(Util_GetPosition(eg_fuel4), 10, BT_CaptureHere)
		Rule_AddInterval(DelayedPing2B, 1)
		Rule_AddOneShot(StartSecondary, 10)
		Rule_RemoveMe()
	end
end

-- ping kickoff from DelayedPing2, done this way to ensure the ping appears after the icon shows up
function DelayedPing2B()
	if Event_IsAnyRunning() == false then
		fuelBlip3 = UI_CreateMinimapBlip(Util_GetPosition(eg_fuel3), 5, BT_CaptureHere)
		Rule_RemoveMe()
	end
end



-- Wave initialization and refuelling mechanics
-- kicks off the start of the multi-wave defend objective 
-- TO DO, set the counter so that it dynamically updates to number of waves we set
function DelayedAttackWave()
	
	if Event_IsAnyRunning() == false then
		Util_StartIntel(EVENTS.FirstWave)
		--Objective_Start(SOBJ_DefendSanatorium) 	
		g_waveNumber = 1
		Objective_SetCounter(SOBJ_DefendSanatorium, g_waveNumber, 5) -- sets wave counter to 5
		Rule_AddOneShot(Start_Attack_Wave, 60) --delay until after cap fuel point objective added
		
		--start refuelling "timer" here
		--Rule_AddOneShot(RefuelKickoff, 30)
		g_refuelTime = 30
		Rule_AddOneShot(RefuelKickoff, 30 )
		
		Rule_RemoveMe()
	end
end

-- for kicking off the dialogue that tells when the enemy is "fueling up" for their attack and initializes the progress bar for that purpose
function RefuelKickoff()
	g_refuelOff = false
	Util_StartIntel(EVENTS.FuelUp)
	--Timer_Start(tmr_refuelTimer, g_refuelTime)
	Rule_AddInterval(RefuelIterator, 1)
	Rule_Add(RefuelDisplayFunction)
end

-- assuming g_refuelTime = a value in seconds, iterates to give the fuel counter a value to display
function RefuelIterator()
	local totalvalue = (g_currentFuelTimer/g_totalFuelTimer)/g_refuelTime
	
	if g_refuelCounter < (g_currentFuelTimer/g_totalFuelTimer) then
	
		g_refuelCounter = g_refuelCounter + totalvalue	
	elseif g_refuelCounter >= (g_currentFuelTimer/g_totalFuelTimer) then
		--g_refuelCounter = g_currentFuelTimer -- ensures the value is equal
		Rule_RemoveMe()
	end
end

-- displays the progress bar during the "refuel" part
function RefuelDisplayFunction()
	if g_refuelOff == false then
		
		--if Timer_GetElapsed(tmr_visibilityTimer) < g_currentFuelTimer then
		if g_refuelCounter < (g_currentFuelTimer/g_totalFuelTimer) then
			Obj_ShowProgress2(11076829, g_refuelCounter)
		else
			Obj_ShowProgress2(11076829, g_currentFuelTimer/g_totalFuelTimer)
		end
		
	elseif g_refuelOff == true then
		g_refuelCounter = 0
		Rule_RemoveMe()
	end

end

-- checks fuel points, to see how many are captured.  number determined is used elsewhere 
function CheckFuelPoints()
	local localFuelCount = 0
	
	local countFuelPoints = function(gid, idx, eid)		
		if World_OwnsEntity(eid) == false then
			if Entity_GetPlayerOwner(eid) == player1 then
			--if EGroup_IsCapturedByPlayer(eid, player1, ANY) then
				localFuelCount = localFuelCount + 1
			end		
		end
	end
	
	EGroup_ForEach(eg_fuelPoints, countFuelPoints)
	
	g_fuelPointsCaptured = localFuelCount
	
	
end

-- defines specific variables when specific fuel points are captured.  
-- TO DO could be set up as a table
function FuelPointCapTracker()
-- use timer instead of fuel percentage?

	if g_currentFuel > 0 then
		local sanatoriumwave = WaveManager_GetWave(wmdt_sanatorium_attack)
		
		if g_fuelPointsCaptured == 1 then
			
			g_intervalForFuelCheck = 35 -- for internal timer of fuel check - if fuel is already gone, interval of time before next check of enemy vehicle out of fuel
			g_randomMaxStart = 8
			g_currentFuelTimer = 45
			g_totalFuelTimer = 60
			g_randomMin = 6
			
		elseif g_fuelPointsCaptured == 2 then		
			
			g_intervalForFuelCheck = 30
			g_randomMaxStart = 6
			g_currentFuelTimer = 35
			g_randomMin = 4
			
		elseif g_fuelPointsCaptured == 3 then
			
			g_intervalForFuelCheck = 25
			g_randomMaxStart = 4
			g_currentFuelTimer = 25
			g_randomMin = 2
			
		elseif g_fuelPointsCaptured == 4 then
			
			g_intervalForFuelCheck = 20
			g_randomMaxStart = 2
			g_currentFuelTimer = 10
			g_randomMin = 1
		end	
		
--~ 	elseif g_currentFuel <= 0 then
--~ 		
--~ 			
--~ 		if g_lastWave == true and g_lastWaveDeadOrDying == true then
--~ 			
--~ 			if World_GetCurrentInteractionStage() == 0 then			
--~ 				World_IncreaseInteractionStage() -- opens up scavenge area (area 1)
--~ 				World_IncreaseInteractionStage() -- opens up secondary area (area 2)
--~ 				World_IncreaseInteractionStage() -- opens up boss area (area 3)
--~ 			elseif World_GetCurrentInteractionStage() == 1 then
--~ 				World_IncreaseInteractionStage() -- opens up secondary area (area 2)
--~ 				World_IncreaseInteractionStage() -- opens up boss area (area 3)
--~ 			elseif World_GetCurrentInteractionStage() == 2 then
--~ 				World_IncreaseInteractionStage() -- opens up boss area (area 3)
--~ 			end
--~ 			
--~ 			-- call retreat here
--~ 			g_retreating = true
--~ 			Rule_AddDelayedInterval(CheckAxisState,1, 1)		
--~ 			
--~ 	
--~ 			Rule_RemoveMe()
--~ 		end	
	end

end




-- Sanatorium Fuel Point tracking
-- checks to see if the player loses the sanatorium fuel point.  if so, it kicks off a recapture objective and its attendant timer for recapturing the point, as well as UI to support that
function CheckSanatorium()

	if EGroup_IsCapturedByPlayer(eg_sanatorium, player1, ALL) == false then
		--g_sanatoriumCaptured = true	
		if Event_IsAnyRunning() == false then
			
			Timer_Start(tmr_sanatoriumCapTimer, t_difficulty.capTimerLength)
			Objective_StartTimer(SOBJ_DefendSanatorium, COUNT_DOWN, t_difficulty.capTimerLength, t_difficulty.capTimerLength)
			
			Util_StartIntel(EVENTS.SanatoriumCapped)
			Objective_UpdateText(SOBJ_DefendSanatorium, 11076831)		-- LOCDB [11076831] 'Recapture the Stoumont Sanatorium Fuel Point'
			Objective_StopCounter(SOBJ_DefendSanatorium)
			if hpid_hold ~= nil then
				Objective_RemoveUIElements(SOBJ_DefendSanatorium, hpid_hold)
			end
			hpid_hold = Objective_AddUIElements(SOBJ_DefendSanatorium, eg_sanatorium, true, 11076831, true)						
			
			Rule_AddInterval(SanatoriumCapTimer, 1)
			
			Rule_RemoveMe()
		end
	end
end

-- timer to check to see if the player recaptures the sanatorium point in time 
function SanatoriumCapTimer()
	
	-- checks to see if enemy player has captured it within the time limit
	if EGroup_IsCapturedByPlayer(eg_sanatorium, player1, ALL) == true and EGroup_IsCapturedByPlayer(eg_sanatorium, player2, ALL) == false then --and (Timer_Exists(tmr_sanatoriumCapTimer) and (Timer_GetElapsed(tmr_sanatoriumCapTimer) <= t_difficulty.capTimerLength)) then
		
		if Event_IsAnyRunning() == false then
			
			Timer_End(tmr_sanatoriumCapTimer)		
			Objective_StopTimer(SOBJ_DefendSanatorium)
			Util_StartIntel(EVENTS.SanatoriumRecap)
			Rule_AddInterval(CheckSanatorium, 1)
			Objective_UpdateText(SOBJ_DefendSanatorium, 11076832)		-- LOCDB [11076832] 'Resist German counterattacks at the Sanatorium Fuel Point'
			Objective_SetCounter(SOBJ_DefendSanatorium, g_waveNumber, 5)
			if hpid_hold ~= nil then
				Objective_RemoveUIElements(SOBJ_DefendSanatorium, hpid_hold)
			end
			hpid_hold = Objective_AddUIElements(SOBJ_DefendSanatorium, eg_sanatorium, true, 11076833, true)		-- LOCDB [11076833] 'Hold the Sanatorium Fuel Point'
			
			Rule_RemoveMe()
		end
		
	elseif EGroup_IsCapturedByPlayer(eg_sanatorium, player1, ALL) == false and EGroup_IsCapturedByPlayer(eg_sanatorium, player2, ALL) == true then
	
		if Timer_Exists(tmr_sanatoriumCapTimer) == false then
		
--~ 			Timer_Start(tmr_sanatoriumCapTimer, t_difficulty.capTimerLength)
--~ 			Objective_StartTimer(SOBJ_DefendSanatorium, COUNT_DOWN, t_difficulty.capTimerLength, t_difficulty.capTimerLength)
--~ 			
		elseif Timer_Exists(tmr_sanatoriumCapTimer) == true and Timer_GetElapsed(tmr_sanatoriumCapTimer) >= t_difficulty.capTimerLength then
			
			if g_axisRetreatedOrDestroyed == false then
				g_sanatoriumCaptured = true	-- captured by enemy player or player has lost control.  this is a GAME OVER condition			
				Util_StartIntel(EVENTS.SanatoriumFail)
			
			end
			Rule_RemoveMe()	
		end		
	elseif EGroup_IsCapturedByPlayer(eg_sanatorium, player1, ALL) == false and EGroup_IsCapturedByPlayer(eg_sanatorium, player2, ALL) == false then
	
		
--~ 		if Timer_Exists(tmr_sanatoriumCapTimer) == true then
--~ 			
--~ 			Timer_End(tmr_sanatoriumCapTimer)
--~ 			Objective_StopTimer(SOBJ_DefendSanatorium)
--~ 		end
	end
end

-- makes sure only one spawn speech gets played at a time
function ResetSpawnSpeech()
	if g_spawnSpeech == true then
		g_spawnSpeech = false
		Rule_RemoveMe()	
	elseif g_lastWave == true then
	
		Rule_RemoveMe()
	end
end




-- Wave mechanic stuff here
-- used when the attack wave actually gets launched
function Start_Attack_Wave()
print("first attack wave started!!!!")
-- Select Spawns and start -- random?
-- deliberate delay until next attack wave - therefore, ALWAYS single wave first
	Util_StartIntel(EVENTS.WaveLaunched)

	WaveManager_SelectSpawns(wmdt_sanatorium_attack)
	WaveManager_SpawnWave(wmdt_sanatorium_attack)
	
	Timer_Start(tmr_sanatoriumWaveTimer, 1200) -- starts timer of 20 minutes		
	Rule_AddInterval(WaveEscalationMonitor, 1)
	Rule_AddDelayedInterval(WaveDeadCheck, 10, 1)
	--Rule_Add(FuelDecreaseCheck) -- DELAY UNTIL LATER -- when phase 2
	--Rule_AddInterval(Wave_DifficultyChanger, 1)	
end

-- delay the wave attack
function DelayWaveAttack()
	if g_lastWave == false and SGroup_IsEmpty(sg_sanatoriumOvergroup) then
		WaveManager_SelectSpawns(wmdt_sanatorium_attack)
		WaveManager_SpawnWave(wmdt_sanatorium_attack)	
	end
end


-- For fuel loss and abandonment	
function VisibleVehicleCheck()

	if SGroup_IsEmpty(sg_vehicleAttackSubgroup) == false then
		
		if Player_CanSeeSGroup(player1, sg_vehicleAttackSubgroup, ANY) then
		--Event_PlayerCanSeeElement(VisibleTimerStart, {vehicles = sg_vehicleAttackSubgroup}, player1, sg_vehicleAttackSubgroup, ALL)
			if Rule_Exists(VisibleTimerStart) == false then
				VisibleTimerStart()
			end
			Rule_RemoveMe()
		end
	end
end

--function VisibleTimerStart(infoTable)
function VisibleTimerStart()
	print("TimerStarted!")
	if Timer_Exists(tmr_visibilityTimer) then
	
		Timer_End(tmr_visibilityTimer)
		g_refuelOff = true
		Timer_Start(tmr_visibilityTimer, g_currentFuelTimer) -- restarts timer
	else
	
		Timer_Start(tmr_visibilityTimer, g_currentFuelTimer)
	end
	
	if Rule_Exists(DisplayVisibleTimer) == false then
		Rule_AddInterval(DisplayVisibleTimer, 1)
	end
	
	if Rule_Exists(VisibleTimerCount) == false then
		Rule_AddInterval(VisibleTimerCount, 1)
	end
end

function DisplayVisibleTimer()

	if g_timerBattalionUpdate== true then
		-- shows progress bar of fuel, according to time elapsed of current fuel timer out of total fuel timer
		Obj_ShowProgress2(11076829, 1 - (Timer_GetElapsed(tmr_visibilityTimer)/g_totalFuelTimer) - (1 - (g_currentFuelTimer/g_totalFuelTimer)))	
	
	elseif g_timerBattalionUpdate == false then
		Obj_ShowProgress2(11076829, 0)
		-- keep bar at 0?
		--Obj_HideProgress()
		
		Rule_RemoveMe()
	
	end

end

function VisibleTimerCount()

	local abandonLimit = g_fuelPointsCaptured --math.floor(g_fuelPointsCaptured/2)
	--local g_abandonCount = 0
	
	if SGroup_IsEmpty(sg_vehicleAttackSubgroup) == false then --and g_abandonCount < abandonLimit then
	
	--if g_abandonCount >= abandonLimit then
	--	g_abandonCount = 0
	--	g_randomMax = g_randomMaxStart
	--	Rule_RemoveMe()
		
	--else
		--print(_TimerTable[tmr_visibilityTimer].length)

		--if _TimerTable[tmr_visibilityTimer].length < g_currentFuelTimer then
			--_TimerTable[tmr_visibilityTimer].length = g_currentFuelTimer
		--end
	
		if Timer_GetElapsed(tmr_visibilityTimer) >= g_currentFuelTimer then
			--Obj_HideProgress()
			g_timerBattalionUpdate = false
			
			local tempVisibleVehicle = SGroup_CreateIfNotFound("tempVisibleVehicle")	
			local tempVisibleMinionVehicle = SGroup_CreateIfNotFound("tempVisibleMinionVehicle")	
			local tempVisibleCommandVehicle = SGroup_CreateIfNotFound("tempVisibleCommandVehicle")	
			
			local _VisibleVehicles = function(gid, idx, sid)
			
				if Squad_Count(sid) >= 1 then
					if Entity_IsVehicle(Squad_EntityAt(sid, 0)) and Player_CanSeeSquad(player1, sid, ALL) then --and (Squad_GetBlueprint(sid) ~= BP_GetEntityBlueprint("panther_ausf_g_squad_mp")) then
						
						--SGroup_Add(tempVisibleVehicle, sid)	
						
						
						
						if SGroup_ContainsSquad(sg_commandTanks, Squad_GetGameID(sid)) then
							SGroup_Add(tempVisibleCommandVehicle, sid)	
						
						elseif SGroup_ContainsSquad(sg_minionTanks, Squad_GetGameID(sid)) then
							SGroup_Add(tempVisibleMinionVehicle, sid)	
						end
					end
				end
				
				
			end		
				
			SGroup_ForEach(sg_vehicleAttackSubgroup, _VisibleVehicles)	
			
			if SGroup_IsEmpty(tempVisibleMinionVehicle) == false then
				SGroup_AddGroup(tempVisibleVehicle, tempVisibleMinionVehicle)
			elseif SGroup_IsEmpty(tempVisibleMinionVehicle) == true and SGroup_IsEmpty(tempVisibleCommandVehicle) == false then
				SGroup_AddGroup(tempVisibleVehicle, tempVisibleCommandVehicle)
			end
			
--~ 			if SGroup_IsEmpty(tempVisibleVehicle) == false then
--~ 				if SGroup_Count(tempVisibleVehicle) > 1 then
--~ 					if SGroup_ContainsSGroup(tempVisibleVehicle, sg_commandTanks, ANY) then
--~ 							SGroup_RemoveGroup(tempVisibleVehicle, sg_commandTanks, FILTER_REMOVE)
--~ 					end
--~ 				elseif SGroup_Count(tempVisibleVehicle) == 1 then
--~ 					
--~ 					if SGroup_ContainsSGroup(tempVisibleVehicle, sg_commandTanks, ANY) then
--~ 						print("only command tank is remaining")						
--~ 					end
--~ 				end
--~ 			end
--~ 			
			if g_culled == false and SGroup_IsEmpty(tempVisibleVehicle) == false then
				
				SGroup_Single(sg_temp, SGroup_GetRandomSpawnedSquad(tempVisibleVehicle))
				WaveAbandon(sg_temp)
				print("culled")
				g_abandonCount = g_abandonCount + 1					
				g_culled = true
				
			end
			
			
			if g_internalTimerStart == true then
			
				Timer_Start(tmr_internalRandomTimer, g_intervalForFuelCheck) -- plug in g_intervalForFuelCheck here?
				g_internalTimerStart = false
				
			end
			
			if Timer_GetElapsed(tmr_internalRandomTimer) >= g_intervalForFuelCheck then
				
				if SGroup_IsEmpty(tempVisibleVehicle) == false then
					print("looking for visible vehicles")
					local randomOutOfFuel = World_GetRand(1, g_randomMax)
					print("choosing "..randomOutOfFuel)
					--print(randomOutOfFuel)
					if randomOutOfFuel == 1 then
						SGroup_Single(sg_temp, SGroup_GetRandomSpawnedSquad(tempVisibleVehicle))
						WaveAbandon(sg_temp)
						print("abandoned")
						g_abandonCount = g_abandonCount + 1
						g_internalTimerStart = true
						--Timer_Start(tmr_internalRandomTimer, g_intervalForFuelCheck) -- plug in g_intervalForFuelCheck here?
						g_randomMax = g_randomMaxStart --?
						
					else
						--restarting count, making it more likely a vehicle will lose fuel
						if g_randomMax - 1 > g_randomMin then
						
							g_randomMax = g_randomMax - 1

							g_internalTimerStart = true
							--Timer_Start(tmr_internalRandomTimer, g_intervalForFuelCheck) -- plug in g_intervalForFuelCheck here?
						-- when at last at 1
--~ 						else
--~ 							g_randomMax = 1
--~ 							g_internalTimerStart = true
						end
					end
				end
			else	
				
			end
		end
		
	-- if the vehicle attack subgroup is dead
	elseif SGroup_IsEmpty(sg_vehicleAttackSubgroup) == true then --or g_abandonCount >= abandonLimit then 
		
		g_abandonCount = 0
		g_randomMax = g_randomMaxStart
		g_internalTimerStart = true -- for the next time
		g_culled = false
		g_timerBattalionUpdate = true
		SGroup_Clear(sg_temp)
		Rule_RemoveMe()
	
	end

end

-- function for the actual abandoning of vehicles for fuel
function WaveAbandon(vehicleSGroup)
	local vehicle = vehicleSGroup
	local _DisableVehicle = function(gid, idx, sid)
		
		if Squad_Count(sid) >= 1 then
			if Entity_IsVehicle(Squad_EntityAt(sid, 0)) then
				
				-- make a new group for this specific airdrop
				local tempVehicle = SGroup_Create("tempVehicle")
				SGroup_Add(tempVehicle, sid)				
				FOW_RevealSGroup(tempVehicle, 15)
				Cmd_CriticalHit(player2, tempVehicle, CRIT.VEHICLE_OUT_OF_FUEL_GERMAN_SP, 0.5)							

				SGroup_SetWorldOwned(tempVehicle)
				-- mark this SGroup as processed (so it doesn't get processed again)
				--SGroup_Add(sg_vehiclesDealtWith, eid)	
				Util_StartIntel(EVENTS.VehicleOutOfFuel)
			end
		end
	end
	
	SGroup_ForEach(vehicle, _DisableVehicle)
	SGroup_Clear(vehicle)
	
end

-- delayed event for when a wave is defeated
function WaveDead()	
	
	if g_missionOver == false then
		if g_waveNumber == 2 then
			Util_StartIntel(EVENTS.SecondWaveOver)
			--Obj_HideProgress()
		elseif g_waveNumber == 3 then
			Util_StartIntel(EVENTS.ThirdWaveOver)
			--Obj_HideProgress()
		elseif g_waveNumber == 4 then
			Util_StartIntel(EVENTS.FourthWaveOver)
			--Obj_HideProgress()
		else
			Util_StartIntel(EVENTS.WaveBeaten)
		end
	end
end


function WaveDeadCheck()

	if SGroup_IsAlive(sg_sanatoriumOvergroup) == false or (SGroup_IsAlive(sg_sanatoriumOvergroup) and SGroup_CountSpawned(sg_sanatoriumOvergroup) <= 1) then
	
		if SGroup_IsAlive(sg_sanatoriumOvergroup) == true and SGroup_IsAlive(sg_commandTanks) == false then
			
			local _squadThreshold = 2
			local _squadCrit = false
			
			local _countLastSquad = function(gid, idx, sid)
			
				_squadThreshold = Squad_Count(sid)
				
			end		
			
			local _countCrit = function(gid, idx, sid)
			
				_squadCrit = Squad_HasCritical(sid, CRIT.VEHICLE_DESTROY_MAINGUN) and Entity_IsVehicle(Squad_EntityAt(sid, 0))
				
			end		
			
			
			
			SGroup_ForEach(sg_sanatoriumOvergroup, _countLastSquad)
			SGroup_ForEach(sg_sanatoriumOvergroup, _countCrit)
			
			--print(_squadThreshold)
			
			if _squadThreshold <= 2 and _squadThreshold > 1 then 
			
				Cmd_Move(sg_sanatoriumOvergroup, mkr_enemyRetreat3, nil, mkr_enemyRetreat3)
				Cmd_Retreat(sg_sanatoriumOvergroup, mkr_enemyRetreat3, mkr_enemyRetreat3)				
				SGroup_Clear(sg_sanatoriumOvergroup)
				g_waveDestroyed = true
				Obj_ShowProgress2(0,0)
				Obj_HideProgress()
				Rule_RemoveMe()
				
			elseif _squadThreshold <= 1 and _squadCrit then 
			
				Cmd_Move(sg_sanatoriumOvergroup, mkr_enemyRetreat3, nil, mkr_enemyRetreat3)
				Cmd_Retreat(sg_sanatoriumOvergroup, mkr_enemyRetreat3, mkr_enemyRetreat3)				
				SGroup_Clear(sg_sanatoriumOvergroup)
				g_waveDestroyed = true
				Obj_ShowProgress2(0,0)
				Obj_HideProgress()
				Rule_RemoveMe()
				
			end
			
		elseif SGroup_IsAlive(sg_sanatoriumOvergroup) == false then
		
			g_waveDestroyed = true
			Obj_ShowProgress2(0,0)
			Obj_HideProgress()
			Rule_RemoveMe()
		
		end
	end
	
end


-- a bit hacky at the moment, this function tells us what to do each wave.  Originally it was this way due to some custom stuff happening.
-- Could possibly be changed into a table based function
function WaveEscalationMonitor()
	local sanatoriumWave = WaveManager_GetWave(wmdt_sanatorium_attack)
	local currentTime = Timer_GetElapsed(tmr_sanatoriumWaveTimer)
	
	if g_phase2 == false and sanatoriumWave < 2 then
			if g_waveDestroyed == true then
			--if SGroup_IsAlive(sg_sanatoriumOvergroup) == false then
				if Rule_Exists(ManualSetWave2) == false then
					Rule_AddOneShot(ManualSetWave2, t_difficulty.setWaveTime[1])
					
					g_refuelTime = t_difficulty.refuelTime[1]
					Rule_AddOneShot(RefuelKickoff, t_difficulty.kickoffTime[1])
					
				end
				
			elseif SGroup_IsAlive(sg_sanatoriumOvergroup) == true and Timer_IsPaused(tmr_sanatoriumWaveTimer) == false then
				print("PAUSED TIMER")
			
				Timer_Pause(tmr_sanatoriumWaveTimer)
			end
	
	elseif g_phase3 == false and sanatoriumWave < 3 then -- + amount of fuel?
			if g_waveDestroyed == true then
				if Rule_Exists(ManualSetWave3) == false then
					Rule_AddOneShot(ManualSetWave3,  t_difficulty.setWaveTime[2])
					g_refuelTime = t_difficulty.refuelTime[2]
					Rule_AddOneShot(RefuelKickoff, t_difficulty.kickoffTime[2])
				end
			elseif SGroup_IsAlive(sg_sanatoriumOvergroup) == true and Timer_IsPaused(tmr_sanatoriumWaveTimer) == false then
				print("PAUSED TIMER")
			
				Timer_Pause(tmr_sanatoriumWaveTimer)
			end
	elseif g_phase4 == false and sanatoriumWave < 4 then -- + amount of fuel?
			
			if g_waveDestroyed == true then
				if Rule_Exists(ManualSetWave4) == false then
					Rule_AddOneShot(ManualSetWave4, t_difficulty.setWaveTime[3])
					g_refuelTime = t_difficulty.refuelTime[3]
					Rule_AddOneShot(RefuelKickoff,  t_difficulty.kickoffTime[3])
					--Rule_AddOneShot(RefuelKickoff, 90)
					
				end
			elseif SGroup_IsAlive(sg_sanatoriumOvergroup) == true and Timer_IsPaused(tmr_sanatoriumWaveTimer) == false then
				print("PAUSED TIMER")
			
				Timer_Pause(tmr_sanatoriumWaveTimer)
			end
	elseif g_bossSpawned == false and sanatoriumWave < 5 then -- + amount of fuel?	
		if Event_IsAnyRunning() == false and g_waveDestroyed == true then
			if Rule_Exists(ManualSetFinal) == false then
				Rule_AddOneShot(ManualSetFinal, t_difficulty.setWaveTime[4])
				
				g_refuelTime = t_difficulty.refuelTime[4]
				Rule_AddOneShot(RefuelKickoff,  t_difficulty.kickoffTime[4])
				
				--Rule_AddOneShot(RefuelKickoff, 90)
				Rule_RemoveMe()
			end
		end	
	end
end

--The follwing functions dictate what happens when a wave gets started, as determined by WaveEscalationMonitor()

function ManualSetWave2()
	g_waveNumber = 2
	Objective_SetCounter(SOBJ_DefendSanatorium, g_waveNumber, 5)
	Util_StartIntel(EVENTS.SecondWave)
	
	WaveManager_SetWave(wmdt_sanatorium_attack, 2, true)
	WaveManager_SelectSpawns(wmdt_sanatorium_attack)	
	WaveManager_SpawnWave(wmdt_sanatorium_attack)
	g_waveDestroyed = false
	Rule_AddDelayedInterval(WaveDeadCheck, 10, 1)
	g_phase2 = true
--~ 	if Timer_IsPaused(tmr_sanatoriumWaveTimer) == true then
--~ 		print("RESUME TIMER")
--~ 		Timer_Resume(tmr_sanatoriumWaveTimer)
--~ 	end
end

function ManualSetWave3()
	g_waveNumber = 3
	Objective_SetCounter(SOBJ_DefendSanatorium, g_waveNumber, 5)
	Util_StartIntel(EVENTS.ThirdWave)
	
	WaveManager_SetWave(wmdt_sanatorium_attack, 3, true)
	WaveManager_SelectSpawns(wmdt_sanatorium_attack)	
	WaveManager_SpawnWave(wmdt_sanatorium_attack)	
	g_waveDestroyed = false
	Rule_AddDelayedInterval(WaveDeadCheck, 10, 1)	
	--Rule_AddOneShot(StartSecondary, 30)
	g_phase3 = true
--~ 	if Timer_IsPaused(tmr_sanatoriumWaveTimer) == true then
--~ 		print("RESUME TIMER")
--~ 		Timer_Resume(tmr_sanatoriumWaveTimer)
--~ 	end
end

function ManualSetWave4()
	g_waveNumber = 4
	Objective_SetCounter(SOBJ_DefendSanatorium, g_waveNumber, 5)
	Util_StartIntel(EVENTS.FourthWave)
	
	WaveManager_SetWave(wmdt_sanatorium_attack, 4, true)
	WaveManager_SelectSpawns(wmdt_sanatorium_attack)	
	WaveManager_SpawnWave(wmdt_sanatorium_attack)
	g_waveDestroyed = false
	Rule_AddDelayedInterval(WaveDeadCheck, 10, 1)
	g_phase4 = true
--~ 	if Timer_IsPaused(tmr_sanatoriumWaveTimer) == true then
--~ 		print("RESUME TIMER")
--~ 		Timer_Resume(tmr_sanatoriumWaveTimer)
--~ 	end
end

--~ function ManualSetWave5()
--~ 	g_waveNumber = 5
--~ 	Util_StartIntel(EVENTS.FifthWave)
--~ 	Objective_SetCounter(SOBJ_DefendSanatorium, g_waveNumber, 5)
--~ 	
--~ 	WaveManager_SetWave(wmdt_sanatorium_attack, 5, true)
--~ 	WaveManager_SelectSpawns(wmdt_sanatorium_attack)	
--~ 	WaveManager_SpawnWave(wmdt_sanatorium_attack)	
--~ 	g_phase5 = true
	
	--if Timer_IsPaused(tmr_sanatoriumWaveTimer) == true then
		--print("RESUME TIMER")
		--Timer_Resume(tmr_sanatoriumWaveTimer)
	--end
--~ 	
--~ end

-- for final wave
function ManualSetFinal()
	if g_bossSpawned == false then
		g_bossSpawned = true
		g_lastWave = true
		g_waveDestroyed = false
		Objective_Start(SOBJ_DefeatFinalAssault)
		
		WaveManager_SetWave(wmdt_sanatorium_attack, 5, true)
		WaveManager_SelectSpawns(wmdt_sanatorium_attack)	
		WaveManager_SpawnWave(wmdt_sanatorium_attack)	
		
		
		-- insert boss track stuff here
		
		
--~ 				if Rule_Exists(LastWaveCheck) == false then
--~ 					Rule_AddDelayedInterval(LastWaveCheck, 15, 1)			
--~ 				end		
--~ 				
		if World_GetCurrentInteractionStage() == 0 then			
			World_IncreaseInteractionStage() -- opens up scavenge area (area 1)
			World_IncreaseInteractionStage() -- opens up secondary area (area 2)
			World_IncreaseInteractionStage() -- opens up boss area (area 3)
		elseif World_GetCurrentInteractionStage() == 1 then
			World_IncreaseInteractionStage() -- opens up secondary area (area 2)
			World_IncreaseInteractionStage() -- opens up boss area (area 3)
		elseif World_GetCurrentInteractionStage() == 2 then
			World_IncreaseInteractionStage() -- opens up boss area (area 3)
		end
		g_waveNumber = 5
		Objective_SetCounter(SOBJ_DefendSanatorium, g_waveNumber, 5)
		Rule_RemoveMe()
	end

end

-- checks to see if the casualty conditions for the last wave are met before causing a retreat and "finishing" the wave
function LastWaveCheck()

	if g_lastWave == true and ((SGroup_IsAlive(sg_sanatoriumOvergroup) and SGroup_CountSpawned(sg_sanatoriumOvergroup) <= 3) or (SGroup_IsAlive(sg_sanatoriumOvergroup) == false)) then
		
		WaveManager_FinishWave(wmdt_sanatorium_attack)	
		
		--g_lastWaveDeadOrDying = true		
		
		g_retreating = true
		Obj_ShowProgress2(0,0)
		Obj_HideProgress()
		Rule_AddDelayedInterval(CheckAxisState,1, 1)		

		Rule_RemoveMe()
	end
end

-- ensures that if it's the last wave, and retreat is happening, then all remaining enemy vehicles get the out of fuel critical
function CheckAxisState()

	if g_lastWave == true and g_retreating == true then

		if Event_IsAnyRunning() == false then
			
			
			local _DisableVehicle = function(gid, idx, sid)
		
				if Squad_Count(sid) >= 1 then
					--print((Entity_IsSyncWeapon(Squad_EntityAt(sid, 0)) == false) )
					if Entity_IsVehicle(Squad_EntityAt(sid, 0)) and (Entity_IsSyncWeapon(Squad_EntityAt(sid, 0)) == false)   then
					
					local tempVehicle = SGroup_Create("tempVehicle")
					SGroup_Add(tempVehicle, sid)	
					
					--Cmd_CriticalHit(player2, tempVehicle, CRIT.VEHICLE_DECREW, 50)					
					Cmd_CriticalHit(player2, tempVehicle, CRIT.VEHICLE_OUT_OF_FUEL_GERMAN_SP, 0.5)
					
					SGroup_SetWorldOwned(tempVehicle)
				
					else
					end
				end
			end
			
			-- moves or retreats static encounter troops to retreat point
			if SGroup_IsEmpty(sg_allEnemyTroops) == false then
				SGroup_ForEach(sg_allEnemyTroops, _DisableVehicle)			
				Cmd_Move(sg_allEnemyTroops, mkr_enemyRetreat3, nil, mkr_enemyRetreat3)				
				Cmd_Retreat(sg_allEnemyTroops, mkr_enemyRetreat3, mkr_enemyRetreat3)
				
			end

			-- moves or retreats wave troops to retreat point
			if SGroup_IsEmpty(sg_sanatoriumOvergroup) == false then
				SGroup_ForEach(sg_sanatoriumOvergroup, _DisableVehicle)
				Cmd_Move(sg_sanatoriumOvergroup, mkr_bossRetreat, nil, mkr_bossRetreat)				
				Cmd_Retreat(sg_sanatoriumOvergroup, mkr_bossRetreat, mkr_bossRetreat)
			end
			
			-- moves or retreats wave troops to retreat point
			if SGroup_IsEmpty(sg_waveOvergroup) == false then
				SGroup_ForEach(sg_waveOvergroup, _DisableVehicle)
				Cmd_Move(sg_waveOvergroup, mkr_enemyRetreat2, nil, mkr_enemyRetreat2)				
				Cmd_Retreat(sg_waveOvergroup, mkr_enemyRetreat2, mkr_enemyRetreat2)
			end			
			if g_sanatoriumCaptured == false then
				Util_StartIntel(EVENTS.NoFuel)
				g_axisRetreatedOrDestroyed = true		
				Rule_AddInterval(CheckEnd, 1)		
				--Timer_Start(tmr_endTimer, g_endTimerLength)
			end
			Rule_RemoveMe()
		end
	end
end

-- delay so that the Objective Complete msg is played and the mission complete state is handled after the speech 
function CheckEnd() 

	if Event_IsAnyRunning() == false then
		Objective_Complete(SOBJ_DefeatFinalAssault)
		Rule_RemoveMe()
	end
end

function HeavyTankSpeech()
	if Event_IsAnyRunning() == false then
		Util_StartIntel(EVENTS.HeavyTanks)
		Rule_RemoveMe()
	end
end
