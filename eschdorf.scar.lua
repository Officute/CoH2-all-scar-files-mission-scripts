print("\tLoading mission file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Eschdorf Challenge
-- Designer: Darwin Yuen
-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScriptSetup.scar") -- <== ### CRITICAL ELEMENT. 
import("XP1.scar")				-- Ardennes Assault functionality

-- [[ Objective files ]]
import("Eschdorf_obj_KillConvoy.scar")

-- [[ Encounter data ]]
import("Eschdorf_encounters.scar")


-------------------------------------------------------------------------
-- [[ MISSION SETUP ]]
-------------------------------------------------------------------------
-- Initializes players
function Mission_SetupPlayers()
	--TODO: Initialize your player variables. Depending on the type of scenario, this can vary.
	
	--For Missions/Challenges:
	player1 = Setup_Player(1, 11073202, "aef", 1)		-- player1 is always the human player
	player2 = Setup_Player(2, 11073205, "west_german", 2)		-- player2 is always the AI opponent
	player3 = Setup_Player(3, 11073202, "aef", 1)
end

-- Defines key mission data and any global values used throughout the mission.
function Mission_SetupVariables()
	print("Initializing mission DATA...")

	
	--[[MAP GROUPS]]
	
	sg_outpost1 = SGroup_CreateIfNotFound("sg_outpost1")
	sg_outpost2 = SGroup_CreateIfNotFound("sg_outpost2")
	sg_outpost3 = SGroup_CreateIfNotFound("sg_outpost3")
	
	sg_gunRunner = SGroup_CreateIfNotFound("sg_gunRunner")
	
	sg_farm1 = SGroup_CreateIfNotFound("sg_farm1")
	sg_farm1_2 = SGroup_CreateIfNotFound("sg_farm1_2")
	sg_farm2 = SGroup_CreateIfNotFound("sg_farm2")
	sg_farm2_2 = SGroup_CreateIfNotFound("sg_farm2_2")
	sg_farm3 = SGroup_CreateIfNotFound("sg_farm3")
	sg_farm4 = SGroup_CreateIfNotFound("sg_farm4")
	sg_farm5 = SGroup_CreateIfNotFound("sg_farm5")
	sg_farm5_2 = SGroup_CreateIfNotFound("sg_farm5_2")
	
	sg_forest1 = SGroup_CreateIfNotFound("sg_forest1")
	sg_forest2 = SGroup_CreateIfNotFound("sg_forest2")
	sg_forest3 = SGroup_CreateIfNotFound("sg_forest3")
	sg_forest3_2 = SGroup_CreateIfNotFound("sg_forest3_2")
	sg_urban1 = SGroup_CreateIfNotFound("sg_urban1")
	sg_urban1_4 = SGroup_CreateIfNotFound("sg_urban1_4")
	sg_urban2 = SGroup_CreateIfNotFound("sg_urban2")
	sg_urban2b = SGroup_CreateIfNotFound("sg_urban2b")
	sg_urban2_3b = SGroup_CreateIfNotFound("sg_urban2_3b")
	sg_urban2_4 = SGroup_CreateIfNotFound("sg_urban2_4")
	sg_urban3 = SGroup_CreateIfNotFound("sg_urban3")
	sg_urban4 = SGroup_CreateIfNotFound("sg_urban4")
	sg_urban4_2 = SGroup_CreateIfNotFound("sg_urban4_2")
	sg_urban5 = SGroup_CreateIfNotFound("sg_urban5")
	sg_urban5_2 = SGroup_CreateIfNotFound("sg_urban5_2")
	sg_urban5_3 = SGroup_CreateIfNotFound("sg_urban5_3")
	sg_urban6 = SGroup_CreateIfNotFound("sg_urban6")
	sg_urban7 = SGroup_CreateIfNotFound("sg_urban7")
	
	-- defending convoy
	sg_convoyDef1 = SGroup_CreateIfNotFound("sg_convoyDef1")
	sg_convoyDef2 = SGroup_CreateIfNotFound("sg_convoyDef2")
	sg_convoyDef3 = SGroup_CreateIfNotFound("sg_convoyDef3")
	
	sg_patrolVehicle1 = SGroup_CreateIfNotFound("sg_patrolVehicle1")
	sg_patrolVehicle2 = SGroup_CreateIfNotFound("sg_patrolVehicle2")
	sg_patrolVehicle3 = SGroup_CreateIfNotFound("sg_patrolVehicle3")
	
	sg_escort = SGroup_CreateIfNotFound("sg_escort")
	-- secondary defense group
	sg_tankDef = SGroup_CreateIfNotFound("sg_tankDef")
	
	sg_enemyOvergroup = SGroup_CreateIfNotFound("sg_enemyOvergroup")
	
	-- convoy
	sg_convoy1 = SGroup_CreateIfNotFound("sg_convoy1")
	sg_convoy2 = SGroup_CreateIfNotFound("sg_convoy2")
	sg_convoy3 = SGroup_CreateIfNotFound("sg_convoy3")
	sg_convoy4 = SGroup_CreateIfNotFound("sg_convoy4")
	sg_convoy5 = SGroup_CreateIfNotFound("sg_convoy5")
	sg_convoyAll = SGroup_CreateIfNotFound("sg_convoyAll")
	sg_convoyDead = SGroup_CreateIfNotFound("sg_convoyDead")
	sg_convoyAttacker = SGroup_CreateIfNotFound("sg_convoyAttacker")
	sg_retreatGroup = SGroup_CreateIfNotFound("sg_retreatGroup")
	-- randomized AT gun SGroups
	sg_ATGun = SGroup_CreateIfNotFound("sg_ATGun")
	sg_ATGun1 = SGroup_CreateIfNotFound("sg_ATGun1")
	sg_ATGun2 = SGroup_CreateIfNotFound("sg_ATGun2")
	sg_ATGun3 = SGroup_CreateIfNotFound("sg_ATGun3")
	
	-- randomized AA Flak
	sg_AAFlak = SGroup_CreateIfNotFound("sg_AAFlak")
	sg_AAFlak1 = SGroup_CreateIfNotFound("sg_AAFlak1")
	sg_AAFlak2= SGroup_CreateIfNotFound("sg_AAFlak2")
	sg_AAFlak3= SGroup_CreateIfNotFound("sg_AAFlak3")
	
	
	-- counterattack SGroups
	sg_leftCounter1 = SGroup_CreateIfNotFound("sg_leftCounter1")
	sg_leftCounter2 = SGroup_CreateIfNotFound("sg_leftCounter2")
	sg_rightCounter1 = SGroup_CreateIfNotFound("sg_rightCounter1")
	sg_rightCounter2 = SGroup_CreateIfNotFound("sg_rightCounter2")
	sg_centerCounter1 = SGroup_CreateIfNotFound("sg_centerCounter1")
	sg_centerCounter2 = SGroup_CreateIfNotFound("sg_centerCounter2")
	
	sg_playerStartUnit = SGroup_CreateIfNotFound("sg_playerStartUnit")
	
	-- table of HMG squads that will randomly be allocated in buildings
	tsg_HMG = SGroup_CreateTable("sg_HMG%d", 2) 
	-- list of buildings the HMG squads can spawn in
	--t_eg_farmhouse = {eg_farmhouse4, eg_farmhouse7} -- eg_farmhouse9, eg_farmhouse10	
	t_HMGInfo = {
		{sgroup = tsg_HMG[1], sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, loc = eg_farmhouse7},
		{sgroup = tsg_HMG[2], sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, loc = eg_farmhouse4},	
	}
	
	-- base defenders that start inside building in compound
	tsg_baseDef = SGroup_CreateTable("sg_baseDef%d", 4)	
	t_baseDefInfo = {
		{sgroup = tsg_baseDef[1], sbp = SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP, loc = eg_compound1},
		--{sgroup = tsg_baseDef[2], sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, loc = eg_compound2},	
		{sgroup = tsg_baseDef[3], sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, loc = mkr_convoyDefense_AT1},	
		{sgroup = tsg_baseDef[4], sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, loc = mkr_convoyDefense_AT2},	
	}
	
	--tsg_patrolVehicles = {{sgroup = sg_patrolVehicle1, enc = g_urban5}, {sgroup = sg_patrolVehicle2, enc = g_urban2_4}, {sgroup = sg_patrolVehicle3, enc = g_urban7}}
	
	-- list of possible AT gun positions
	t_mkr_ATPosition = {mkr_ATPossible1, mkr_ATPossible2}
	t_mkr_ATPosition2 = {mkr_ATPossible5} --mkr_ATPossible3, mkr_ATPossible4, -- mkr_ATPossible7, -- mkr_ATPossible6,
	--t_mkr_ATPosition3 = {mkr_ATPossible8, mkr_ATPossible9, mkr_ATPossible10} -- mkr_ATPossible7,
	
		
	-- ### CRITICAL ELEMENT. This table contains all the initialization data for the mission.
	g_missionData = {
		useBeginnerHints = false,					-- Wether or not to use the BeginnerHint system
		useEncounterSystem = true,					-- Whether or not to use the Encounter system
		useXP1Difficulty = true,					-- Whether or not this mission uses the XP1 Difficulty system
		missionType = MT_XP1_CHALLENGE,				-- What Mission Type is this mission? MT_
		introNIS = "XP1/Eschdorf_Intro", 					-- Movie filename				
		--introNISDarkDuration = 1,
		introNISlet = nil,					 		-- NISlet triggered after introNIS
		introNISletSkipped = nil,	 				-- Function called if the introNISlet is skipped				
		introSitRep = nil,							-- Movie (string) to play after intro nislet				
		--fadeTimeIntoMission = 1, 							-- Time to fade into the mission after NIS/Sitrep played
		endNISlet = nil,							-- NISlet triggered on mission completion
		endNIS = nil,								-- Movie (string) to play on mission completion
		missionSpeechPath = "botb/gameplay",					-- Speech path to cache (string)
		precacheSounds = {							-- Any audio files you want precached (list of strings)
			"speech/sp/botb/gameplay",
		},
		nisFiles = {								-- .nis files associated with the mission (path string)
		},
		nisInTransitionTime = 0,
		nisOutTransitionTime = 0,
		objectives = {								-- List of PARENT objective tables.
			OBJ_KillConvoy,							-- These are the global references to the objective tables defined in the separete files.
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
				--OnComplete = function() XP1_IncrementMissionSuccessLevel(10) end,
			},
			{
				obj = SecondaryOBJ_DestroyTank,
				data = {
					spawns = {
						{spawn = mkr_secondaryObj3, ui = mkr_secondaryObj3},
					},
					--goal = GOALS.AttackBase,
					protectEncounter = ENCOUNTERS.TankDef,
				},
				--OnComplete = function() XP1_IncrementMissionSuccessLevel(10) end,
			},
			{
				obj = SecondaryOBJ_CaptureIntel,
				data = {
					--locations = {mkr_enemyUrban2d, mkr_enemyUrban1d, mkr_enemyUrban3a, mkr_enemyUrban5d},
					locations = {mkr_enemyIntel1, mkr_enemyIntel2, mkr_enemyIntel3, mkr_enemyIntel4},
					number_to_spawn = 2,
					number_to_capture = 2,
					base_area = mkr_playerBaseArea,
				},
			},
		},
	}
	
	
	--[[GLOBAL VARIABLES]]
	g_secondaryTriggered = false
	g_fuelTimerPhysicalActivate = false
	g_convoyAttackedActivate = false
	g_showExit = false
	g_sideRoadsDetected = 0
	g_secondary2Success = false
	g_entry1Open = false
	g_entry2Open = false
	-- convoy related variables	and data
	
	-- hintpoint table setup for convoy vehicles
	t_hpidList = {} 
	
	-- list of convoy spawn points
	t_convoySpawn = {mkr_convoySpawn1, mkr_convoySpawn2, mkr_convoySpawn3, mkr_convoySpawn4, mkr_convoySpawn5} 
	
	-- list of convoy vehicles and their states
	t_convoy = {
		{sgroup = sg_convoy1, dead = false, moving = false, runnable = false},
		{sgroup = sg_convoy2, dead = false, moving = false, runnable = false},
		{sgroup = sg_convoy3, dead = false, moving = false, runnable = false},
		{sgroup = sg_convoy4, dead = false, moving = false, runnable = false},
		{sgroup = sg_convoy5, dead = false, moving = false, runnable = false}
	}
	
	-- list of exits for the convoy and associated paths
	t_exitList = {
		{exitPoint = mkr_exit, exitPath = "ExitPath1"}, 
		{exitPoint = mkr_exit2, exitPath = "ExitPath2"}
	}
	
	g_randomExit = World_GetRand(1, #t_exitList) -- used elsewhere in convoy spawner function to also help determine spawn order
	g_exitLoc = t_exitList[g_randomExit]
	g_convoyDead = false
	
	g_valueOfTrucks = 90/table.getn(t_convoy) -- value of trucks determined for mission success %, which accounts for 90% of the mission - the slottable should be the next 10%
	g_convoyKillCount = 0 -- number of convoy killed
	g_convoyCount = 0 -- defining the number spawned in convoy - initialized as 0 since none are spawned yet
	

	g_convoyDespawnCount = 0 -- tracks number of convoy vehicles that have despawned upon reaching exit point
	g_timerUp = false -- when convoy fuel timer is up?
	g_convoyRetreated = false
	g_convoyMoving = false
	g_convoyMovementDelay = 1
	g_convoyMostlyDead = false
	g_destroyMostConvoy = false
	g_destroyConvoyBeforeTimerOut = false
	g_truckRetreat = 0
	
	
	g_escortSpawned = false
	g_nearExit = false 
	g_nearPos = false
	g_onPath = false
	
	-- timer alternate
	g_clockCount = 0
	g_clockInterval = 1
	
	g_50PercentReached = false -- flag to tell the game when the convoy is 50% fuelled up for purposes of dialogue
	g_75PercentReached = false -- flag to tell the game when the convoy is 75% fuelled up for purposes of dialogue
	
	g_currentTime = 0
	
	g_entry1Open_HintRemoved = false
	g_entry2Open_HintRemoved = false
	-- counterattack related variables and data
	-- counterattack data table
	t_counterAttack = {
		
		{
			groups = {
				{sgroup = sg_leftCounter1, sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = mkr_leftCounterSpawn, slotBool = true},
				{sgroup = sg_leftCounter2, sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, spawn = mkr_leftCounterSpawn, slotBool = false},
			},
			points = {eg_point1, eg_point2},
			overPoint = eg_leftPoints,
			
		},
		{
			groups = {
				{sgroup = sg_centerCounter1, sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = mkr_centerCounterSpawn, slotBool = true},
				{sgroup = sg_centerCounter2, sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = mkr_centerCounterSpawn, slotBool = true},
			},
			points = {eg_point3, eg_point4},
			overPoint = eg_centerPoints,
			
		},
		{
			groups = {
				{sgroup = sg_rightCounter1, sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = mkr_rightCounterSpawn, slotBool = true},
				{sgroup = sg_rightCounter2, sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, spawn = mkr_rightCounterSpawn, slotBool = false},
			},
			points = {eg_point5, eg_point6},
			overPoint = eg_rightPoints,
			
		},
		
	}

	
end

-- Defines difficulty tables/tuning variables
function Mission_SetDifficulty(diffVal)
	--TODO: Define any difficulty-related settings or variables.
	-- These variables should be stored in a t_difficulty table for readability and access.
	
	g_difficulty = diffVal or Game_GetSPDifficulty() 	-- Note: Having the diffVal parameter allows for redefining difficulty settings during runtime.
	
	AI_OverrideDifficulty(g_difficulty)
	
	if g_difficulty == GD_EASY or g_difficulty == GD_NORMAL then
		g_showExit = true	
	end
	
	--Global difficulty table
	-- adjust timer values to account for difficulty
	t_difficulty = {
			convoyPrepTimerLength = Util_DifVar({9,8,7}, g_difficulty)*60, -- timer in seconds for length of time that the player can spend in the woods until the refuel timer kicks in (can be overridden when player exits woods)
			convoyTimerLength = Util_DifVar({18,17,16}, g_difficulty)*60, -- timer in seconds for length of time convoy waits before leaving 
			convoyFastestKillTime = Util_DifVar({26, 24, 22}, g_difficulty) *60, -- length of time the player gets to kill off the entire convoy, depending on difficulty
			convoyDmgResist = Util_DifVar({0.90, 0.75, 0.60}, g_difficulty),
	}
	
	g_convoySpeed = 0.33	
	--g_convoySpeed = Util_DifVar({0.25, 0.33, 0.45})
	--g_escortSpeed = Util_DifVar({0.23, 0.31, 0.43})
	
	g_escortStrength = XP1_GetNodeStrength()
	t_escortInfo = {{sbp = SBP.GERMAN.STUG_III_SQUAD_MP, speed = 0.34}, {sbp = SBP.GERMAN.STUG_III_SQUAD_MP, speed = 0.34}, {sbp = SBP.GERMAN.PANZER_IV_SQUAD, speed = 0.40}, {sbp = SBP.GERMAN.PANZER_IV_SQUAD, speed = 0.40}, {sbp = SBP.WEST_GERMAN.PANTHER_AUSF_G_SQUAD_MP, speed = 0.31}}
	
	--Modify_PlayerResourceRate(player1, RT_Manpower, 0.80)
	Player_SetResource(player1, RT_Manpower, 200)
	Player_SetResource(player1, RT_Munition, 50)
	Player_SetResource(player1, RT_Fuel, 50)
		
	--XP1 Dynamic Difficulty settings:
	-- player dynamic difficulty settings
	PM_PL_StartingResourceHit = true
	 
	-- enemy dynamic difficulty settings
	PM_AI_CPDefenses = true 
	PM_AI_BaseDefenses = true
	PM_AI_Defensiveness = true


	
end

-- Sets restrictions on units, teams, etc.
function Mission_SetupRestrictions()
	--TODO: Set any tech/ability restrictions on a players, as well as resource limits.
	--	Note: Resource Income/Caps should be defined in Mission_SetDifficulty()
	Camera_FocusOnPosition(Marker_GetPosition(mkr_cameraFocus), true)
	
	
	--[[ HUMAN PLAYER ]]
	Player_SetEntityProductionAvailability(player1, {BP_GetEntityBlueprint("aef_tank_trap_impassable_mp"),  BP_GetEntityBlueprint("aef_tank_trap_mp")}, ITEM_LOCKED)
	
	
	--[[ ALLIED PLAYER ]]
	
	--[[ ENEMY PLAYER ]]
	Player_SetUpgradeAvailability(player2, {BP_GetUpgradeBlueprint("sws_heavy_crush_enable")}, ITEM_UNLOCKED)
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("sws_heavy_crush_enable"))
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("building_1"))
end

-- Sets up the map before the mission starts (starting units, ownership, etc.)
function Mission_Preset()
	--TODO: Make changes to the initial state of the map (spawn/despawn units or entities, diable holds, etc.).
	
	--Camera_ResetToDefault()
	--Camera_MoveTo(mkr_testCameraStart, false)
	XP1_SetMissionSuccessLevel(1) -- initializes mission success level to 1 at beginning
	
	--Util_CreateSquads(player1, sg_playerStartUnit, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_cinematicRifleman)
	
--~ 	t_towers = {
--~ 		{egroup = eg_sightTower1, hintPoint = HintPoint_Add(eg_sightTower1, true, 11076848, 2)},  -- LOCDB [11076848] 'Capture to see farther'
--~ 		{egroup = eg_sightTower2, hintPoint = HintPoint_Add(eg_sightTower2, true, 11076848, 2)}, 
--~ 		{egroup = eg_sightTower3, hintPoint = HintPoint_Add(eg_sightTower3, true, 11076848, 2)}, 
--~ 		{egroup = eg_sightTower4, hintPoint = HintPoint_Add(eg_sightTower4, true, 11076848, 2)}, 
--~ 		{egroup = eg_sightTower5, hintPoint = HintPoint_Add(eg_sightTower5, true, 11076848, 2)}, 
--~ 		{egroup = eg_sightTower6, hintPoint = HintPoint_Add(eg_sightTower6, true, 11076848, 2)}, 
--~ 		{egroup = eg_sightTower7, hintPoint = HintPoint_Add(eg_sightTower7, true, 11076848, 2)}, 
--~ 	}	

--~ 	for i = 1, table.getn(t_towers) do
--~ 		if EGroup_IsEmpty(t_towers[i].egroup) == false then
--~ 			Modify_SightRadius(t_towers[i].egroup, 2)
--~ 			
--~ 		end
--~ 	end
	
end


-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
--Called once the intro nis/nislet/sitrep finishes playing.
function Mission_Start()

	-- reveal area by paths
	FOW_RevealMarker(mkr_path1FOWReveal, 1)
	FOW_RevealMarker(mkr_path2FOWReveal, 1)
	FOW_RevealMarker(mkr_path3FOWReveal, 1)
	
	Objective_Start(OBJ_KillConvoy)
	Objective_Start(SOBJ_DestroyConvoy)
	Rule_AddOneShot(Starting_Encounters, 2)
	Rule_AddOneShot(Starting_Convoy, 1)
	Rule_AddOneShot(Convoy_Progress_Initialize, 20) -- use Event_NarrativeEventsNotRunning
	Rule_AddOneShot(Deploy_RandomAT, 2) -- spawn on frame 1?
	Rule_AddOneShot(Deploy_AA, 2)
	Rule_AddOneShot(Deploy_RandomHMG, 3)
	Rule_AddOneShot(Deploy_BaseDef, 4)
	
	--Rule_AddDelayedInterval(CounterAttack_Manager, 5,5)
	
	Rule_AddDelayedInterval(SeeAmbush, 3, 1) -- Event_ElementOnScreen? 
	--Rule_AddDelayedInterval(SeeMines, 4, 1) -- Event_ElementOnScreen?  
	

	-- setup hintpoints over vehicles
	for i = 1,table.getn(t_convoy) do
		
		local tempID =  HintPoint_Add(t_convoy[i].sgroup, true, 11076464, 1, nil, nil) -- LOCDB [11076464] 'Convoy Vehicle'
		table.insert(t_hpidList, i, tempID)
		
	end
	
	Rule_AddInterval(GunRunnerRetreat,1)
	
	--Event_PlayerOwnsElement(MapEntryPointCapture, nil, player1, eg_entryPoint2, nil, ANY)
	--Event_PlayerOwnsElement(MapEntryPointCapture, nil, player1, eg_entryPoint1, nil, ANY)
	Rule_AddDelayedInterval(MapEntryPointCapture,1, 1)
	
	
	Event_Proximity(SeeMines, {filterlist = LIST.AIRCRAFT, filtertype = FILTER_REMOVE}, player1, mkr_mineNotification1, nil, ANY, 1)  
	Event_Proximity(SecondaryObj_DelayStart, {filterlist = LIST.AIRCRAFT, filtertype = FILTER_REMOVE}, player1, mkr_entryDetect1_Secondary, nil, ANY, 1)  
	Event_Proximity(SecondaryObj_DelayStart, {filterlist = LIST.AIRCRAFT, filtertype = FILTER_REMOVE}, player1, mkr_entryDetect2_Secondary, nil, ANY, 1)  
	fuelTimerStartEvent = Event_Proximity(Convoy_Fuel_Timer_Physical_Activate, {filterlist = LIST.AIRCRAFT, filtertype = FILTER_REMOVE}, player1, mkr_prepTimerOver, nil, ANY)  
	Event_Proximity(SideRoadDetection, {filterlist = LIST.AIRCRAFT, filtertype = FILTER_REMOVE}, player1, mkr_sideRoadDetect1, nil, ANY)
	Event_Proximity(PathRevealDetection, mkr_pathReveal1, player1, mkr_pathDetect1, nil, ANY) 
	Event_Proximity(PathRevealDetection, mkr_pathReveal2, player1, mkr_pathDetect2, nil, ANY) 
	Event_Proximity(PathRevealDetection, mkr_pathReveal3, player1, mkr_pathDetect3, nil, ANY) 
	Event_Proximity(PathRevealDetection, mkr_pathReveal4, player1, mkr_pathDetect4, nil, ANY) 
	Event_Proximity(PathRevealDetection, mkr_pathReveal5, player1, mkr_pathDetect5, nil, ANY) 
	Event_Proximity(PathRevealDetection, mkr_pathReveal6, player1, mkr_pathDetect6, nil, ANY) 
	Event_Proximity(PathRevealDetection, mkr_pathReveal7, player1, mkr_pathDetect7, nil, ANY) 
	--entry1Hint = HintPoint_Add(mkr_entryPointIndicator1, true, 11076470) -- LOCDB [11076470] 'Connect this territory and set a rally point nearby to have new units appear here'
	--entry2Hint = HintPoint_Add(mkr_entryPointIndicator2, true, 11076470) -- LOCDB [11076470] 'Connect this territory and set a rally point nearby to have new units appear here'
		
end


--creates random AT gun in town
function Deploy_RandomAT()

	--local randomSpawnLoc = World_GetRand(1, table.getn(t_mkr_ATPosition))
	g_randomSpawnLoc = t_mkr_ATPosition[World_GetRand(1, table.getn(t_mkr_ATPosition))]
	g_ATGun1 = ENCOUNTERS.ATGun1()
	--Util_CreateSquads(player2, sg_ATGun1, SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD, t_mkr_ATPosition[randomSpawnLoc])
	AI_UnlockSquads(player2, sg_ATGun1)
	
	--local randomSpawnLoc2 = World_GetRand(1, table.getn(t_mkr_ATPosition2))
	g_randomSpawnLoc2 = t_mkr_ATPosition2[World_GetRand(1, table.getn(t_mkr_ATPosition2))]
	g_ATGun2 = ENCOUNTERS.ATGun2()
	--Util_CreateSquads(player2, sg_ATGun2, SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD, t_mkr_ATPosition2[randomSpawnLoc2])
	AI_UnlockSquads(player2, sg_ATGun2)
	--local randomSpawnLoc3 = World_GetRand(1, table.getn(t_mkr_ATPosition3))	
	--Util_CreateSquads(player2, sg_ATGun3, SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD, t_mkr_ATPosition3[randomSpawnLoc3])
	
end

--creates AA Def at higher difficulty
function Deploy_AA()

	local _nodeStrengthForAA = XP1_GetNodeStrength()

	if ((g_difficulty == GD_NORMAL or g_difficulty == GD_HARD) and  (_nodeStrengthForAA >= 4) )then
			
		Util_CreateSquads(player2, sg_AAFlak3, SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP, mkr_AA3)
	
	end
	
	
	if g_difficulty == GD_NORMAL and (_nodeStrengthForAA >= 5) then
		Util_CreateSquads(player2, sg_AAFlak1, SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP, mkr_AA1)			
		Util_CreateSquads(player2, sg_AAFlak2, SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP, mkr_AA2)
	elseif g_difficulty == GD_HARD and (_nodeStrengthForAA >= 4) then
		Util_CreateSquads(player2, sg_AAFlak1, SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP, mkr_enemyUrban1_vehicle2)			
		Util_CreateSquads(player2, sg_AAFlak2, SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP, mkr_enemyUrban5_vehicle2)	
	end
end



-- creates a couple of random HMG teams in the town
function Deploy_RandomHMG()
	if XP1_GetNodeStrength() >= 3 then	
		for i = 1, table.getn(t_HMGInfo) do
			Util_CreateSquads(player2, t_HMGInfo[i].sgroup, t_HMGInfo[i].sbp, t_HMGInfo[i].loc)	
		end
	end
end

function Deploy_BaseDef()

	for i = 1, table.getn(t_baseDefInfo) do
		Util_CreateSquads(player2, t_baseDefInfo[i].sgroup, t_baseDefInfo[i].sbp, t_baseDefInfo[i].loc)	
	end
	
end

-- encounters
function Starting_Encounters()

	g_outpost1 = ENCOUNTERS.Outpost1()
	--g_outpost1_2 = ENCOUNTERS.Outpost1_2()
	g_outpost2 = ENCOUNTERS.Outpost2()
	g_outpost2b = ENCOUNTERS.Outpost2b()
	g_outpost2e = ENCOUNTERS.Outpost2e()
	g_outpost2_2 = ENCOUNTERS.Outpost2_2()
	g_outpost2_2b = ENCOUNTERS.Outpost2_2b()
	g_outpost2_3 = ENCOUNTERS.Outpost2_3()
	g_forest1 = ENCOUNTERS.Forest1()
	g_forest1_2 = ENCOUNTERS.Forest1_2()
	g_forest1_3 = ENCOUNTERS.Forest1_3()
	g_forest1_3b = ENCOUNTERS.Forest1_3b()
	g_forest2 = ENCOUNTERS.Forest2()
	g_forest2_2 = ENCOUNTERS.Forest2_2()
 	g_forest3 = ENCOUNTERS.Forest3()
	g_farm1 = ENCOUNTERS.Farm1()
	g_farm1_2 = ENCOUNTERS.Farm1_2()
	g_farm1_2b = ENCOUNTERS.Farm1_2b()
	--g_farm2 = ENCOUNTERS.Farm2()
	g_farm2_2 = ENCOUNTERS.Farm2_2()
	g_farm3 = ENCOUNTERS.Farm3()
	g_farm4 = ENCOUNTERS.Farm4()
	g_farm5 = ENCOUNTERS.Farm5()
	g_farm5_2 = ENCOUNTERS.Farm5_2()
	g_urban1 = ENCOUNTERS.Urban1()
	g_urban1b = ENCOUNTERS.Urban1b()
	g_urban1_2 = ENCOUNTERS.Urban1_2()
	g_urban1_3 = ENCOUNTERS.Urban1_3()
	g_urban1_4 = ENCOUNTERS.Urban1_4()
	g_urban1_5 = ENCOUNTERS.Urban1_5()
	g_urban1_6 = ENCOUNTERS.Urban1_6()
	g_urban2 = ENCOUNTERS.Urban2()
	g_urban2_hard = ENCOUNTERS.Urban2_hard()
	g_urban2b = ENCOUNTERS.Urban2b()
	g_urban2_2 = ENCOUNTERS.Urban2_2()	
	g_urban2_3 = ENCOUNTERS.Urban2_3()
	g_urban2_3b = ENCOUNTERS.Urban2_3b()
	g_urban2_4 = ENCOUNTERS.Urban2_4()
	g_urban3 = ENCOUNTERS.Urban3()
	g_urban3b = ENCOUNTERS.Urban3b()
	g_urban4 = ENCOUNTERS.Urban4()
	g_urban4_2 = ENCOUNTERS.Urban4_2()
	g_urban5 = ENCOUNTERS.Urban5()
	g_urban5_2 = ENCOUNTERS.Urban5_2()
	g_urban5_3 = ENCOUNTERS.Urban5_3()
	g_urban5_4 = ENCOUNTERS.Urban5_4()
	g_urban6 = ENCOUNTERS.Urban6()
	g_urban7 = ENCOUNTERS.Urban7()
	g_convoyDef1 = ENCOUNTERS.ConvoyDef1()
	g_convoyDef2 = ENCOUNTERS.ConvoyDef2()
	g_convoyDef3 = ENCOUNTERS.ConvoyDef3()
	
	Util_CreateSquads(player2, sg_farm2, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, mkr_enemyFarm2a)
	Util_CreateSquads(player2, sg_forest3_2, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, mkr_enemyForest3a)
	
	tsg_patrolVehicles = {{sgroup = sg_patrolVehicle1, enc = g_urban5, goalData = nil}, {sgroup = sg_patrolVehicle2, enc = g_urban2_4, goalData = nil}, {sgroup = sg_patrolVehicle3, enc = g_urban7, goalData = nil}}
	for i = 1, table.getn(tsg_patrolVehicles) do 
		if SGroup_IsEmpty(tsg_patrolVehicles[i].sgroup) == false then
			Modify_SightRadius(tsg_patrolVehicles[i].sgroup, 0.5)
			Modify_WeaponRange(tsg_patrolVehicles[i].sgroup, "hardpoint_01", 0.5)
			Modify_UnitSpeed(tsg_patrolVehicles[i].sgroup, 0.80)
		end	
	end
	
	
	if SGroup_IsEmpty(sg_forest1) == false then
	
		Modify_SightRadius(sg_forest1, 0.25)
		
	end
	if SGroup_IsEmpty(sg_forest3) == false then
	
		Modify_SightRadius(sg_forest3, 0.3)
	end	
	
	if SGroup_IsEmpty(sg_forest3_2) == false then
	
		Modify_SightRadius(sg_forest3_2, 0.5)
		Modify_WeaponRange(sg_forest3_2, "hardpoint_01", 0.5)
	end
	
	if SGroup_IsEmpty(sg_farm2) == false then
	
		Modify_SightRadius(sg_farm2, 0.33)
	end	
end


-- convoy initialization stuff
function Starting_Convoy()
-- DO NOT REMOVE - original encounter spawn calls for convoy
--~ 	g_convoy1 = ENCOUNTERS.Convoy1()
--~ 	g_convoy2 = ENCOUNTERS.Convoy2()
--~ 	g_convoy3 = ENCOUNTERS.Convoy3()
--~ 	g_convoy4 = ENCOUNTERS.Convoy4()
--~ 	g_convoy5 = ENCOUNTERS.Convoy5()
	
-- spawning this way to ensure that the convoy is spawned such that they are spawned in order of movement towards the selected exit point
-- it will spawn convoy in the order of sgroups, but will spawn at markers in a different order depending on the spawn point.  i.e. if Exit 1 is selected, the spawning should start at mkr_convoySpawn5 and work its way to mkr_convoySpawn1
-- if Exit 2 is selected, the spawning should start at mkr_convoySpawn1 and work its way to mkr_convoySpawn5.  If you look at the .sgb it's quite apparent why, taking into account the exit paths.
	
	if g_randomExit == 1 then

		local spawnSpot = table.getn(t_convoySpawn)
		
		for i = 1, table.getn(t_convoy) do
			Util_CreateSquads(player2, t_convoy[i].sgroup, SBP.WEST_GERMAN.SWS_HALFTRACK_SQUAD_SP, t_convoySpawn[spawnSpot])
			
			--Util_CreateSquads(player2, t_convoy[i].sgroup, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, t_convoySpawn[spawnSpot])
			SGroup_AddGroup(sg_convoyAll, t_convoy[i].sgroup)
			spawnSpot = spawnSpot - 1
		end

	elseif g_randomExit == 2 then

		
		local spawnSpot = table.getn(t_convoySpawn) --5
		
		for i = table.getn(t_convoy), 1, -1 do
			Util_CreateSquads(player2, t_convoy[i].sgroup, SBP.WEST_GERMAN.SWS_HALFTRACK_SQUAD_SP, t_convoySpawn[spawnSpot])
			
			--Util_CreateSquads(player2, t_convoy[i].sgroup, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, t_convoySpawn[spawnSpot])
			SGroup_AddGroup(sg_convoyAll, t_convoy[i].sgroup)
			spawnSpot = spawnSpot - 1 
		end
	
	end
	
	g_convoyCount = SGroup_Count(sg_convoyAll) -- grabs number of spawned convoy members
	g_convoyMoveCount = 1 -- initializes convoy movement counter, to start the kickoff from the first vehicle to be used later on in Convoy_Spacing()
	
	-- slows down convoy movement speed
	Modify_UnitSpeed(sg_convoyAll, g_convoySpeed)
	Modify_ReceivedDamage(sg_convoyAll, t_difficulty.convoyDmgResist)
	--Modify_SightRadius(sg_convoyAll, 0.1)
	Rule_AddDelayedInterval(Convoy_Tracker, 1, 1)
	
	--Event_IsEngaged(Convoy_Attacked_Activation, nil, sg_convoyAll, ANY, 1)
	Rule_Add(Convoy_Attacked_Activation)
	
	--Event_Proximity(ClearRoad, {exit = g_exitLoc.exitPoint, group = sg_convoyAll}, sg_convoyAll, g_exitLoc.exitPoint, 20, ANY, 0)
end

function ClearRoad(data)
	-- Remove any wrecks that could potentially block the escape route
	Util_ClearWrecksFromMarker(Marker_GetPosition(data.exit), 20)
	Util_ClearWrecksFromMarker(Marker_GetPosition(data.exit), 20)

end

function SecondaryObj_DelayStart()	
	if g_secondaryTriggered == false then
		Mission_StartSecondaryObjective()
		g_secondaryTriggered = true
	elseif g_secondaryTriggered == true then
		Rule_RemoveMe()	
	end
end

-- throws up a dialogue when the player sees enemy units for the first time on the map
function SeeAmbush()

	-- didn't use a list because there wouldn't be a big gain in space savings
	if Prox_ArePlayersNearMarker(player1, mkr_dialogueStart1, ANY) or Prox_ArePlayersNearMarker(player1, mkr_dialogueStart2, ANY) or Prox_ArePlayersNearMarker(player1, mkr_dialogueStart3, ANY) then
		Util_StartIntel(EVENTS.ForestEnemies)
		Rule_RemoveMe()	
	end
	
end

-- throws up a dialogue when the player sees mines for the first time on the map
function SeeMines()
	-- didn't use a list because there wouldn't be a big gain in space savings with 1 area
	Util_StartIntel(EVENTS.ForestMines)
end

-- tracks the status of the convoy to see if it is dead or not and how it died
function Convoy_Tracker()
	
	--if SGroup_IsAlive(sg_convoyAll) == false and g_timerUp == false then
	
	if SGroup_IsAlive(sg_convoyAll) == false and (World_GetGameTime() <= t_difficulty.convoyFastestKillTime) and SGroup_CountDeSpawned(sg_convoyAll) <= 0 then
		
		if g_convoyDead == false then
			g_convoyDead = true
			Util_StartIntel(EVENTS.ConvoyAllDead)
			--XP1_IncrementMissionSuccessLevel(90)			
			XP1_SetMissionSuccessLevel(3)
			Rule_RemoveMe()
		end
	elseif g_timerUp == true and g_convoyMoving == true and g_convoyDead == false then
		
		-- repeated this check because the convoy can start moving before the fastest kill time is up
		if SGroup_IsAlive(sg_convoyAll) == false and (World_GetGameTime() <= t_difficulty.convoyFastestKillTime) and SGroup_CountDeSpawned(sg_convoyAll) <= 0 then
		
			if g_convoyDead == false then
				g_convoyDead = true
				Util_StartIntel(EVENTS.ConvoyAllDead)
				--XP1_IncrementMissionSuccessLevel(90)			
				XP1_SetMissionSuccessLevel(3)
				Rule_RemoveMe()
			end
		
		elseif SGroup_IsAlive(sg_convoyAll) == false and SGroup_CountDeSpawned(sg_convoyAll) <= 0 then
			g_convoyMostlyDead = true
			Util_StartIntel(EVENTS.ConvoyAllDead) -- on purpose done this way instead of g_convoyDead because this g_convoyDead is looked at after fuel timer stopped			
			XP1_SetMissionSuccessLevel(2)
			Rule_RemoveMe()
		
		-- if convoy is moving already then if > 3 get away then most of the convoy escaped	
		elseif SGroup_CountDeSpawned(sg_convoyAll) >= 3 then
		
			if g_convoyRetreated == false then
				g_convoyRetreated = true -- mission failed!
				Util_StartIntel(EVENTS.KillTheConvoyFail)
				Rule_RemoveMe()
			end
		
		-- otherwise, if less than 2 have escaped, then if all the convoy is dead at this point then it's mostly dead
		elseif SGroup_CountDeSpawned(sg_convoyAll) <= 2 then
			
			if SGroup_IsAlive(sg_convoyAll) == false then
				g_convoyMostlyDead = true
				Util_StartIntel(EVENTS.ConvoyMostDead)
				XP1_SetMissionSuccessLevel(1)
				Rule_RemoveMe()
			end
		end
	end
end


-- starts the timer for prep time before convoy refuelling
function Convoy_Progress_Initialize()

	tmr_objPrep_clock = "tmr_objPrep_clock"
	Timer_Start(tmr_objPrep_clock, t_difficulty.convoyPrepTimerLength)
	Rule_AddInterval(Convoy_UpdatePrepClock, 1)
	
end

-- makes the enemy convoy flee when under physical attack from planes or otherwise?
function Convoy_Attacked_Activation()
	
	if SGroup_IsAlive(sg_convoyAll) then
		
		--if SGroup_IsUnderAttack(sg_convoyAll, ANY, 1) then
		if SGroup_IsUnderAttackByPlayer(sg_convoyAll, player1, 2) then
			print("convoy was attacked by player")
			g_convoyAttackedActivate = true
			Rule_RemoveMe()
		end
	end
end


-- starts the Convoy Fuel Timer proximity via a flag used by Convoy_UpdatePrepClock
function Convoy_Fuel_Timer_Physical_Activate()
	print("player moved into convoy refuel activation zone")
	g_fuelTimerPhysicalActivate = true
end

function Convoy_UpdatePrepClock()

	if ((Timer_GetElapsed(tmr_objPrep_clock) >= t_difficulty.convoyPrepTimerLength) or g_fuelTimerPhysicalActivate) and g_convoyAttackedActivate == false then --	Prox_ArePlayersNearMarker(player1, mkr_prepTimerOver, ANY) then
		
		if fuelTimerStartEvent ~= nil then
			Event_Remove(fuelTimerStartEvent)
		end
		
		-- stops prep timer
		if Timer_GetElapsed(tmr_objPrep_clock) > 0 then
			Timer_End(tmr_objPrep_clock)		
		end
		
		-- indicate to player convoy is starting fuelling		
		Util_StartIntel(EVENTS.ConvoyStartedFuelling)		
		
		-- initialize the atmosphere change to morning
		Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/xp1/eschdorf_morning.aps", t_difficulty.convoyPrepTimerLength)
		
		-- starts new timer and its attendant things
		Rule_AddOneShot(Convoy_StartClock, 5)		
		Rule_RemoveMe()
	elseif g_convoyAttackedActivate == true then
		Timer_End(tmr_objPrep_clock)		
		Rule_AddInterval(Convoy_UpdateClock, 1)	
		Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/xp1/eschdorf_morning.aps", t_difficulty.convoyPrepTimerLength)
		
		Rule_RemoveMe()
		
	
	end
end


function Convoy_StartClock()

-- Start visual indicator of the progress of convoy refueled
	--tmr_objConvoy_clock = "tmr_objConvoy_clock"
	--Timer_Start(tmr_objConvoy_clock, t_difficulty.convoyTimerLength)	
	Obj_ShowProgress2(11076465, g_currentTime) -- LOCDB [11076465] 'Convoy Refuelling Progress'
	Rule_AddInterval(Convoy_UpdateClock, 1)	
end

function Convoy_UpdateClock()
	--local percentage = (1 - (Timer_GetElapsed(tmr_objConvoy_clock)/(t_difficulty.convoyTimerLength)))	
	--local percentage = (Timer_GetElapsed(tmr_objConvoy_clock)/t_difficulty.convoyTimerLength)
	g_clockCount = g_clockCount + g_clockInterval
	local percentage = (g_clockCount/t_difficulty.convoyTimerLength)
	
	if g_75PercentReached == false then
		Obj_ShowProgress2(11076466, percentage)	-- LOCDB [11076466] 'Convoy Refuelling Progress'
	elseif g_75PercentReached == true then
		Obj_ShowProgressEx(1, 11076466, percentage, true)
	end
	
	if g_convoyDead == false then -- if convoy is already killed before timer, just remove this check
		
		if percentage >= 1 or g_convoyAttackedActivate then -- if timer is full (as opposed to 0 before) or convoy attacked
			
			Obj_HideProgress() -- hide progress bar of "refueling" of convoy	
			g_timerUp = true
				
			Rule_AddOneShot(Convoy_Activation, 1)
			Rule_AddInterval(Convoy_Ping, 1)			
			
			
			if g_convoyAttackedActivate then
				if SGroup_IsAlive(sg_escort) == false and g_escortSpawned == false then
					g_escortSpawned = true
					Rule_AddOneShot(SpawnEscort, 1)
				end
			end
			
			Rule_RemoveMe()
			
		elseif percentage >= 0.5 and g_50PercentReached== false then
			g_50PercentReached = true
			Util_StartIntel(EVENTS.Convoy50PercentTimerReached)					
		elseif percentage >= 0.75 and g_75PercentReached == false then
			--Obj_SetProgressBlinking(true)
			Obj_ShowProgressEx(1, 11076466, percentage, true)
			g_75PercentReached = true	
			Util_StartIntel(EVENTS.Convoy75PercentTimerReached)	
			if SGroup_IsAlive(sg_escort) == false and g_escortSpawned == false then
				g_escortSpawned = true
				Rule_AddOneShot(SpawnEscort, 1)
			end
		end
	else
		Rule_RemoveMe()
	end
end


function SpawnEscort()
	if g_randomExit == 1 then
		Util_CreateSquads(player2, sg_escort, t_escortInfo[g_escortStrength].sbp, mkr_leftCounterSpawn, mkr_escortStart)		
	elseif g_randomExit == 2 then
		--Util_CreateSquads(player2, sg_escort, t_escortInfo[g_escortStrength], mkr_rightCounterSpawn, mkr_escortStart2)
		Util_CreateSquads(player2, sg_escort, t_escortInfo[g_escortStrength].sbp, mkr_centerCounterSpawn, mkr_escortStart2)
	end
	
	--AI_LockSquads(player2, sg_escort)
	Modify_WeaponAccuracy(sg_escort, "hardpoint_01", 0.2)
	Modify_WeaponDamage(sg_escort, "hardpoint_01", 0.33)
	Modify_WeaponRange(sg_escort, "hardpoint_01", 0.75)
	Modify_ReceivedDamage(sg_escort, 1.5)
	if Rule_Exists(SpawnEscortBehaviourKickoff) == false then
		Rule_AddDelayedInterval(SpawnEscortBehaviourKickoff, 3, 1)
	end
	if g_escortStrength == 3 or g_escortStrength == 4 then
		Util_StartIntel(EVENTS.PanzerIVEscortSpotted)
	elseif g_escortStrength >= 5 then
		Util_StartIntel(EVENTS.PantherEscortSpotted)
	end
	--g_escortSpawned = true
end

function SpawnEscortBehaviourKickoff()
	if g_randomExit == 1 then
	--if g_convoyMoving == true and Prox_SGroupSGroup(sg_escort, sg_convoyAll, PROX_SHORTEST)  <= 30 then
		if g_convoyMoving == true and Prox_AreSquadsNearMarker(sg_convoyAll, mkr_escortStartTrigger, ANY, 5) then
			--Modify_UnitSpeed(sg_escort, g_escortSpeed)
			Modify_UnitSpeed(sg_escort, t_escortInfo[g_escortStrength].speed)
			Rule_AddDelayedInterval(SpawnEscortBehaviour, 1, 1)
			Rule_RemoveMe()
		end
	elseif g_randomExit == 2 then
		if g_convoyMoving == true and Prox_AreSquadsNearMarker(sg_convoyAll, mkr_escortStartTrigger2, ANY, 5) then
			Modify_UnitSpeed(sg_escort, t_escortInfo[g_escortStrength].speed)
			Rule_AddDelayedInterval(SpawnEscortBehaviour, 1, 2)
			Rule_RemoveMe()
		end
	end
	
end

function SpawnEscortBehaviour()

	if SGroup_IsAlive(sg_escort) and g_convoyMoving == true then 

		local _exitlocation = nil
		
		if g_randomExit == 1 then
			_exitlocation = mkr_exit
			_exitguardtrigger = mkr_guardInit
			_guardlocation = mkr_guardPosition
			_guardfacing = mkr_guardFacing
		elseif g_randomExit == 2 then
			_exitlocation = mkr_exit2
			_exitguardtrigger = mkr_guardInit2
			_guardlocation = mkr_guardPosition2
			_guardfacing = mkr_guardFacing2
		end
		
		if Prox_AreSquadsNearMarker(sg_escort, _exitguardtrigger, ANY, 20) and g_nearExit == false then
		
			Cmd_Move(sg_escort, _guardlocation, nil, nil, mkr_guardFacing)
			g_nearExit = true
		
		elseif Prox_AreSquadMembersNearMarker(sg_escort, _guardlocation, ANY, 3) and g_nearExit == true and g_nearPos == false then
		
			Cmd_Move(sg_escort, _guardlocation, nil, nil, mkr_guardFacing)
			g_nearPos = true
		elseif (Prox_AreSquadsNearMarker(sg_escort, _exitlocation, ANY, 20) == false) and (g_nearExit == false) and (g_nearPos == false) and (g_onPath == false) then

			Cmd_SquadPath(sg_escort, g_exitLoc.exitPath, true, false, false, nil)
			g_onPath = true
		end
	
	else
	
		Rule_RemoveMe()
	
	end
end




function Convoy_Activation()
	
	if SGroup_IsAlive(sg_convoyAll) then
		
		-- updates objective to kill as many of the convoy as possible, at least 3 vehicles
		--Objective_UpdateText(OBJ_KillConvoy, 11076467) -- LOCDB [11076467] 'Prevent at least 3 vehicles from the enemy convoy from escaping'
		
		for i = 1, table.getn(t_convoy) do
			
			if SGroup_IsAlive(t_convoy[i].sgroup) == false and t_convoy[i].dead == false then					
				t_convoy[i].dead = true					
				g_convoyKillCount = g_convoyKillCount + 1
				
				-- to account for dead vehicles already 
				--XP1_IncrementMissionSuccessLevel(g_valueOfTrucks)					
				
			end
		end	
		
		-- updates secondary objective to reflect how many of the convoy has been killed
		--Objective_UpdateText(SOBJ_DestroyConvoy, Loc_FormatText(11076728, Loc_ConvertNumber(g_convoyKillCount), Loc_ConvertNumber(#t_convoy)))				-- LOCDB [11076728] '%1PART% / %2TOTAL% convoy elements destroyed'
		
		Objective_UpdateText(SOBJ_DestroyConvoy, 11077137)		-- LOCDB [11077137] 'Destroy at least three of the convoy vehicles'
		Objective_SetCounter(SOBJ_DestroyConvoy, g_convoyKillCount, g_convoyCount)
		
		-- removes hintpoint for convoy's general area
		Objective_RemoveUIElements(OBJ_KillConvoy, hpid_square)
		
		g_convoyMoving = true
		Rule_AddOneShot(Convoy_Moving, g_convoyMovementDelay)	-- 30 second delay until convoy moves was default, now changing to immediately
		Rule_AddInterval(Convoy_UpdateObjective, 0)
		Rule_AddInterval(Convoy_RunAway, 5)
		Rule_AddInterval(Convoy_RunAwayAllow, 5)
		
	end
end

-- function for updating the number of convoy vehicles destroyed into the objective text
function Convoy_UpdateObjective()

	if g_convoyKillCount < table.getn(t_convoy) then		
		for i = 1, table.getn(t_convoy) do
			-- checks to see if the SGroup specified is dead and if the flag for it is set
			-- if so the flag is set so the sgroup is not counted again and the number is increased by 1
			--print(SGroup_CountDeSpawned(t_convoy[i].sgroup))
			if SGroup_IsAlive(t_convoy[i].sgroup) == false and t_convoy[i].dead == false and (SGroup_CountDeSpawned(t_convoy[i].sgroup) < 1) then					
				t_convoy[i].dead = true					
				g_convoyKillCount = g_convoyKillCount + 1
				
				-- update mission success level when convoy member dies
				--XP1_IncrementMissionSuccessLevel(g_valueOfTrucks)	
				
				-- updates objective text to reflect updated kill count
				--Objective_UpdateText(SOBJ_DestroyConvoy, Loc_FormatText(11076728, Loc_ConvertNumber(g_convoyKillCount), Loc_ConvertNumber(#t_convoy))	)					
				Objective_SetCounter(SOBJ_DestroyConvoy, g_convoyKillCount, g_convoyCount)
			end
			
			if g_convoyKillCount >= table.getn(t_convoy) then
				-- once objective is finished, update the objective so when it finishes it doesn't repeat the last updated title, thus it is a hidden change indicated by the false boolean
				Objective_UpdateText(SOBJ_DestroyConvoy, 11076468, nil, false) -- LOCDB [11076468] 'All convoy vehicles destroyed'
				Rule_RemoveMe()
			end			
		end	
	end
end



-- loops so that the convoy's general location gets pinged to notify the player where it is when it moves
function Convoy_Ping()

	if (convoyping == nil) == false then
		Objective_RemovePing(OBJ_KillConvoy, convoyping)
	end
	if SGroup_IsAlive(sg_convoyAll) == true then
		convoyping = Objective_AddPing(OBJ_KillConvoy, Util_GetPosition(sg_convoyAll))
	else
		Rule_RemoveMe()
	end

end

-- kick off convoy movement stuff
function Convoy_Moving()
	
	if SGroup_IsAlive(sg_convoyAll) then
		
		Util_StartIntel(EVENTS.ConvoyMoving)
		
		--Cmd_Move(sg_convoyAll, g_exitLoc.exitPoint) -- move to exit
		Rule_AddInterval(Convoy_Spacing, 10)
		Rule_AddInterval(Convoy_DeSpawnTracker, 1)
		--Rule_AddInterval(Convoy_Distance, 1)
		
		if g_showExit == true then
			
			local _exitlocation = nil
		
			if g_randomExit == 1 then
				_exitLocation = mkr_exit
				_exitguardtrigger = mkr_guardInit
				_exitArrowOrigin = mkr_exit1ArrowOrigin
				_guardlocation = mkr_guardPosition
				_guardfacing = mkr_guardFacing
			elseif g_randomExit == 2 then
				_exitLocation = mkr_exit2
				_exitguardtrigger = mkr_guardInit2
				_exitArrowOrigin = mkr_exit2ArrowOrigin
				_guardlocation = mkr_guardPosition2
				_guardfacing = mkr_guardFacing2
			end
			
			
			Objective_AddPing(OBJ_KillConvoy, Marker_GetPosition(g_exitLoc.exitPoint))
			FOW_RevealMarker(g_exitLoc.exitPoint, -1)
			ExitHint = HintPoint_Add(Marker_GetPosition(g_exitLoc.exitPoint), true, 11076469) -- LOCDB [11076469] 'Convoy Escape Route'
			UI_CreateMinimapBlip(Marker_GetPosition(g_exitLoc.exitPoint), -1, BT_General)
			
			exitArrow = MapIcon_CreateArrow(_exitArrowOrigin, _exitLocation, 255, 0, 0, 0)
			
			--MapIcon_CreateArrow(mkr_exit1ArrowOrigin, mkr_exit, 255, 0, 0, 0)
			
			--FOW_RevealSGroupOnly(sg_convoyAll)
		end
	end
end


-- function to space out the convoy's vehicles when they go down the exit path - this doesn't account for vehicle in front though
function Convoy_Spacing()

	for i = 1, table.getn(t_convoy) do
		
		if SGroup_IsAlive(t_convoy[i].sgroup) and t_convoy[i].moving == false then
			
			Cmd_SquadPath(t_convoy[i].sgroup, g_exitLoc.exitPath, false, false, false, nil)
			t_convoy[i].moving = true
			break
		end
		
	end

end



-- wait until convoy vehicle is out of the base before running
function Convoy_RunAwayAllow()
	
	local _retreatThreshold = nil
	
	if g_randomExit == 1 or g_randomExit == nil then
		_retreatThreshold = mkr_retreatThreshold
	elseif g_randomExit == 2 then
		_retreatThreshold = mkr_retreatThreshold2
	end
	
	for i = 1, table.getn(t_convoy) do
		
		if SGroup_IsAlive(t_convoy[i].sgroup) then
			if t_convoy[i].runnable == false then
				if Prox_AreSquadsNearMarker(t_convoy[i].sgroup, _retreatThreshold, ANY) then
					t_convoy[i].runnable = true
				end
			end
		end
	end
end

-- go to other exit point in panic.  only 2 out of the 5 do, and they speed up as well

function Convoy_RunAway()
	
	if g_truckRetreat < 2 then
		for i = 1, table.getn(t_convoy) do
			
			if SGroup_IsAlive(t_convoy[i].sgroup) then

				if SGroup_IsUnderAttackByPlayer(t_convoy[i].sgroup, player1, 5) then
					
					local chanceOfRetreat = World_GetRand(1, 2)
					--print(chanceOfRetreat)
					if chanceOfRetreat == 1 and t_convoy[i].runnable == true then
						Modify_UnitSpeed(t_convoy[i].sgroup, 1.90)
						SGroup_AddGroup(sg_retreatGroup, t_convoy[i].sgroup)						
						
						if g_randomExit == 1 or g_randomExit == nil then
							Cmd_Retreat(t_convoy[i].sgroup, mkr_exit)
						elseif g_randomExit == 2 then
							Cmd_Retreat(t_convoy[i].sgroup, mkr_exit2)
						end
						Event_Proximity(ChangeRetreatCounter, nil, t_convoy[i].sgroup, mkr_exit, 16, ANY)					
						t_convoy[i].runnable = false
						table.remove(t_convoy[i].sgroup)		
						
						--Cmd_Move(sg_retreatGroup, mkr_exit2, nil, mkr_exit2)
						--Cmd_Retreat(sg_demoEscort1, mkr_exit2, mkr_exit2)
						
						g_truckRetreat = g_truckRetreat + 1
					end
				end
				
			end
			
		end
	end
	
end


function ChangeRetreatCounter()
	
	g_convoyCount = g_convoyCount - 1
	--print(g_convoyCount)
	Objective_SetCounter(SOBJ_DestroyConvoy, g_convoyKillCount, g_convoyCount)

end

-- function here to ensure vehicles stay X distance away
--STUB IN HERE
--~ function Convoy_Distance()
--~ 	for i = 1, table.getn(t_convoy) do
--~ 		if i ~= 1 then
--~ 			if Prox_SGroupSGroup(t_convoy[i].sgroup, t_convoy[i-1].sgroup, PROX_SHORTEST) < 20 and t_convoy[i].moving == true then
--~ 				Cmd_Stop(t_convoy[i].sgroup)
--~ 				t_convoy[i].moving = false
--~ 			elseif Prox_SGroupSGroup(t_convoy[i].sgroup, t_convoy[i-1].sgroup, PROX_SHORTEST) >= 21 and t_convoy[i].moving == false then
--~ 				Cmd_SquadPath(t_convoy[i].sgroup, g_exitLoc.exitPath, false, false, false, nil)
--~ 				t_convoy[i].moving = true
--~ 			end
--~ 		else
--~ 		
--~ 			--Cmd_SquadPath(t_convoy[i].sgroup, g_exitLoc.exitPath, false, false, false, nil)
--~ 		
--~ 		end
--~ 	end
--~ end



-- tracks the number of vehicles that get despawned
function Convoy_DeSpawnTracker()

	if SGroup_IsAlive(sg_convoyAll) then		
		for i = 1, table.getn(t_convoy) do		
			if SGroup_IsAlive(t_convoy[i].sgroup) then	-- checks to see if applicable SGroup is even on the board		
				if Prox_AreSquadsNearMarker(t_convoy[i].sgroup, g_exitLoc.exitPoint, ANY) then					
					SGroup_DeSpawn(t_convoy[i].sgroup)
					g_convoyDespawnCount = g_convoyDespawnCount + 1 -- iterates number of despawned squads			
					
					if XP1_GetMissionSuccessLevel() >= g_valueOfTrucks then
						--XP1_IncrementMissionSuccessLevel(-(g_valueOfTrucks))
					end
					
				end
			end
		end
		
	else
		Rule_RemoveMe()	
	end

end


-- works with t_counterAttack to generate counterattack units that spawn whenever a player takes over a point in the urban area, and randomly gives an item if specified
function CounterAttack_Manager()

	for z = 1, table.getn(t_counterAttack) do
		
		local _Points = t_counterAttack[z].points
		local _Groups = t_counterAttack[z].groups
		
		for i = 1, table.getn(_Points) do
		
			if Player_OwnsEGroup(player1, _Points[i]) then -- checks to see if the point in question is captured by the player
			
				local counterOrNot = {true, true, false}		 -- 66% of the time!		
				
				local _t_randomItemTable = {SLOT_ITEM.GRENADIER_MG42_LMG_MP, SLOT_ITEM.PANZERSHRECK}
				
				if counterOrNot[World_GetRand(1, table.getn(counterOrNot))] then -- randomly select if counterattack will show up after all
				
					for y = 1, table.getn(_Groups) do
						
						Util_CreateSquads(player2, _Groups[y].sgroup, _Groups[y].sbp, _Groups[y].spawn, _Points[i], nil, nil, true)
						
						if _Groups[y].slotBool == true then -- checks to see if this squad can get an item
							
							local randomItem = World_GetRand(1,2)
							
							if randomItem == 1 then -- if the result is 1, then add an item otherwise the group gets nothing
								
								local itemToAdd = World_GetRand(1,table.getn(_t_randomItemTable)) -- roll for random item
								
								Squad_GiveSlotItem(SGroup_GetSpawnedSquadAt(_Groups[y].sgroup, 1), _t_randomItemTable[itemToAdd]) -- adds item
								Squad_AddSlotItemToDropOnDeath(SGroup_GetSpawnedSquadAt(_Groups[y].sgroup, 1), _t_randomItemTable[itemToAdd], 0.5, true) -- percentage chance the SGroup will drop this item when dead
								
							end				
						end
						
						Cmd_AttackMove(_Groups[y].sgroup, _Points[i], nil, nil, 15)
						
					end
				end
				
				table.remove(_Points, i) -- removes the group from the left points table
				break
				
			end
		end
	end

end

function GunRunnerRetreat()
	if SGroup_IsAlive(sg_outpost1) and SGroup_IsAlive(sg_gunRunner) then
	
		if SGroup_IsUnderAttackByPlayer(sg_outpost1, player1, 5) then
		
			Cmd_Move(sg_gunRunner, mkr_gunRunnerDest)
			Rule_RemoveMe()
		end
	else
		Rule_RemoveMe()
	end
end

-- reveals larger side road for vehicles

function SideRoadDetection()
	
	Util_StartIntel(EVENTS.SideRoad)
	FOW_RevealMarker(mkr_sideRoadReveal1, 10)		
	UI_CreateMinimapBlip(Marker_GetPosition(mkr_sideRoadReveal1), 10, BT_General)
end

function PathRevealDetection(data)
	FOW_RevealMarker(data, 10)
end

function MapEntryPointCapture()
	if g_entry1Open and g_entry2Open then
		Rule_RemoveMe()
	else
		if Event_IsAnyRunning() == false then
			if EGroup_IsCapturedByPlayer(eg_entryPoints, player1, ANY) then
				if EGroup_IsCapturedByPlayer(eg_entryPoint1, player1, ANY) and (g_entry1Open == false or g_entry1Open == nil) then
				
					Util_StartIntel(EVENTS.MapEntryPointCleared)	
					UI_CreateMinimapBlip(Marker_GetPosition(mkr_entryPointIndicator1), 15, BT_General)
					entry1Hint = HintPoint_Add(mkr_entryPointIndicator1, true, 11076471) -- LOCDB [11076471] 'Connect this territory and set a rally point nearby to have new units appear here'
					FOW_RevealMarker(mkr_entryPointIndicator1, 1)
					g_entry1Open = true	
					
					Rule_AddGlobalEvent(RallyCallbackFunction1, GE_EntityCommandIssued)
						
				
				elseif EGroup_IsCapturedByPlayer(eg_entryPoint2, player1, ANY) and (g_entry2Open == false or g_entry2Open == nil) then
					
					Util_StartIntel(EVENTS.MapEntryPointCleared)
					UI_CreateMinimapBlip(Marker_GetPosition(mkr_entryPointIndicator2), 15, BT_General)
					entry2Hint = HintPoint_Add(mkr_entryPointIndicator2, true, 11076471) -- LOCDB [11076471] 'Connect this territory and set a rally point nearby to have new units appear here'
					FOW_RevealMarker(mkr_entryPointIndicator2, 1)
					g_entry2Open = true	
					
					Rule_AddGlobalEvent(RallyCallbackFunction2, GE_EntityCommandIssued)
				end
			end
		end
	end
end

function RallyCallbackFunction1(caller, CMD, target) -- callback gets info from Rule_AddGlobalEvent

	if CMD == CMD_RallyPoint then
		print("rally!")
		if scartype(caller) == ST_ENTITY and Player_OwnsEntity(player1, caller) == true then
			print("valid")
			
			if World_IsTerritorySectorOwnedByPlayer(  player1, World_GetTerritorySectorID(Util_GetPosition(eg_entryPoint1))) then
				if World_TeamTerritoryPointsConnected(0, Marker_GetPosition(mkr_specialVehicleStart), Marker_GetPosition(mkr_entryPointIndicator1)) then
					if World_GetTerritorySectorID(Util_GetPosition(target)) == World_GetTerritorySectorID(Util_GetPosition(eg_entryPoint1)) then
						
						print("ADFDSFDS")
						
						if entry1Hint ~= nil then
							HintPoint_Remove(entry1Hint)
							g_entry1Open_HintRemoved = true
							Rule_RemoveMe()
						end
						
					end
				end
			end
		end
	end

end

function RallyCallbackFunction2(caller, CMD, target) -- callback gets info from Rule_AddGlobalEvent

	if CMD == CMD_RallyPoint then
		
		if scartype(caller) == ST_ENTITY and Player_OwnsEntity(player1, caller) == true then
			
			if World_IsTerritorySectorOwnedByPlayer(  player1, World_GetTerritorySectorID(Util_GetPosition(eg_entryPoint2))) then
				if World_TeamTerritoryPointsConnected(0, Marker_GetPosition(mkr_specialVehicleStart), Marker_GetPosition(mkr_entryPointIndicator2)) then			
					if World_GetTerritorySectorID(Util_GetPosition(target)) == World_GetTerritorySectorID(Util_GetPosition(eg_entryPoint2)) then
						
						if entry2Hint ~= nil then
							HintPoint_Remove(entry2Hint)							
							g_entry2Open_HintRemoved = true
							Rule_RemoveMe()
						end
						
					end
				end
			end
		end
	end

end
