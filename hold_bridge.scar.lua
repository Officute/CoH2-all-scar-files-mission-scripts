print("\tLoading mission file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- MISSION NAME
-- Designer: Darwin Yuen
-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScriptSetup.scar") -- <== ### CRITICAL ELEMENT. 

-- [[ Objective files ]]
import("Hold_Bridge_obj_HoldBridge.scar")

-- [[ Encounter data ]]
import("Hold_Bridge_encounters.scar")

import("Libraries/WaveManager/WaveManager_Core.scar")



-------------------------------------------------------------------------
-- [[ MISSION SETUP ]]
-------------------------------------------------------------------------
-- Initializes players
function Mission_SetupPlayers()
	--For Missions/Challenges:
	player1 = Setup_Player(1, 11073202, "aef", 1)		-- player1 is always the human player
	player2 = Setup_Player(2, 11073205, "west_german", 2)		-- player2 is always the AI opponent
	player3 = Setup_Player(3, 11073202, "aef", 1)		-- allied player to drop weapon in
end

-- Defines key mission data and any global values used throughout the mission.
function Mission_SetupVariables()
	print("Initializing mission DATA...")
	
	
	--[[MAP GROUPS]]
	sg_Reinforcements = SGroup_CreateIfNotFound("sg_Reinforcements")
	sg_Engineers = SGroup_CreateIfNotFound("sg_Engineers")
	sg_AllyInfantry = SGroup_CreateIfNotFound("sg_AllyInfantry")
	sg_AllyVehicle = SGroup_CreateIfNotFound("sg_AllyVehicle")
	sg_OverallAlly = SGroup_CreateIfNotFound("sg_OverallAlly")
	sg_Player1SGroups = SGroup_CreateIfNotFound("sg_Player1SGroups")
	sg_NPCEngineers = SGroup_CreateIfNotFound("sg_NPCENgineers")
	
	eg_ObjBridge = EGroup_CreateIfNotFound("eg_ObjBridge")	-- Main bridge
	eg_detPack = EGroup_CreateIfNotFound("eg_detPack")		-- Hidden demo pack placed on map
	
	sg_e_wave_all = SGroup_CreateIfNotFound("sg_e_wave_all")
	
--~ 	sg_EnemyWave1 = SGroup_CreateIfNotFound("sg_EnemyWave1") --not currently used
--~ 	sg_EnemyWave2 = SGroup_CreateIfNotFound("sg_EnemyWave2")
--~ 	sg_EnemyWave3 = SGroup_CreateIfNotFound("sg_EnemyWave3")
	
	sg_Panzer = SGroup_CreateIfNotFound("sg_Panzer")
	sg_PanzerGroup = SGroup_CreateIfNotFound("sg_PanzerGroup")
	
	sg_EnemySup1 = SGroup_CreateIfNotFound("sg_EnemySup1")
	sg_EnemySup2 = SGroup_CreateIfNotFound("sg_EnemySup2")
	sg_EnemySup3 = SGroup_CreateIfNotFound("sg_EnemySup3")
	
	
	Cmd_Upgrade(player1, UPG.AEF.RIFLE_COMMAND_GRENADE_MP, 1, true)
	Player_AddAbility(player3, BP_GetAbilityBlueprint("pm_airdrop_munitions"))
	
	
	-- ### CRITICAL ELEMENT. This table contains all the initialization data for the mission.
	g_missionData = {
		useBeginnerHints = false,					-- Wether or not to use the BeginnerHint system
		useEncounterSystem = true,					-- Whether or not to use the Encounter system
		useXP1Difficulty = true,					-- Whether or not this mission uses the XP1 Difficulty system
		missionType = MT_XP1_MINICHALLENGE,					-- What Mission Type is this mission? MT_
		introNIS = nil,			 					-- Movie filename
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
			OBJ_DefendZone							-- These are the global references to the objective tables defined in the separete files.
		},
		startingUnits = {							-- Units to be spawned for P1 on mission start. Follows same parameters as Encounters.
			{
				sgroups = {sg_OverallAlly, sg_AllyInfantry},
				sbp = SBP.AEF.RIFLEMEN_SQUAD_MP,
				spawn = mkr_allyspawn1,				
				entityUpgrades = nil,
				slotItems = nil,
				numSquads = nil,
				load = nil,
				veterancyRank = nil,
				difficulty = nil,
				conditions = nil,
				commanderDivision = nil,
			},
			{
				sgroups = {sg_Engineers, sg_OverallAlly, sg_AllyInfantry},
				sbp = SBP.AEF.PARATROOPER_SQUAD_MP,
				spawn = mkr_cameraStart,
				moveTo = mkr_allyspawn2,
			},
			{
				sgroups = {sg_OverallAlly, sg_AllyVehicle},
				sbp = SBP.AEF.DODGE_WC51_AMBULANCE_SQUAD_MP,
				spawn = mkr_allyspawn3,
			},
			{
				sgroups = {sg_OverallAlly, sg_AllyInfantry},
				sbp = SBP.AEF.M1_75MM_PACK_HOWITZER_SQUAD_MP,
				spawn = mkr_allyspawn4,
			},
			{
				sgroups = {sg_OverallAlly, sg_AllyInfantry},
				sbp = SBP.AEF.RIFLEMEN_SQUAD_MP,
				spawn = mkr_allyspawn5,
			},
		}
	}
	
	
	
	--[[GLOBAL VARIABLES]]
	g_youWin = false
	g_youFail = false
	g_detPackEngSpawned = false
	g_bridgeRigged = false
	g_panzerDead = false
	g_bridgeDestroyed = false
	g_sendInTheEngineers = false
	g_panzerEncounter = nil			-- The final panzer tank encounter
	
end

-- Defines difficulty tables/tuning variables
function Mission_SetDifficulty(diffVal)
	-- These variables should be stored in a t_difficulty table for readability and access.
	g_difficulty = diffVal or Game_GetSPDifficulty() 	-- Note: Having the diffVal parameter allows for redefining difficulty settings during runtime.
	AI_OverrideDifficulty(g_difficulty)
	
	--Global difficulty table
	t_difficulty = {
--~ 		myTimeoutValue = Util_DifVar({15, 10, 5}, g_difficulty),
	}
	
	--XP1 Dynamic Difficulty settings:
--~ 	PM_PL_StartingResourceHit = false -- XP reduction 
	--PM_AI_CPDefenses = true
	PM_AI_Aggression = true
	PM_AI_Defensiveness = true
	
end

-- Sets restrictions on units, teams, etc.
function Mission_SetupRestrictions()
	--	Note: Resource Income/Caps should be defined in Mission_SetDifficulty()
	
	--[[ HUMAN PLAYER ]]
	Modify_PlayerResourceRate(player1, RT_Manpower, 0.25)
	Modify_PlayerResourceRate(player1, RT_Munition, 0)
	Modify_PlayerResourceRate(player1, RT_Fuel, 0)
	
	--[[ ALLIED PLAYER ]]
	
	--[[ ENEMY PLAYER ]]
	
end

-- Sets up the map before the mission starts (starting units, ownership, etc.)
function Mission_Preset()
	Camera_ResetToDefault()
	Camera_MoveTo(mkr_cameraStart, false)
	
	XP1_SetActiveCommander(CD_NONE)
	
	EGroup_Kill(eg_bridgeLeft)
	EGroup_SetInvulnerable(eg_ObjBridge, 0.80)
	EGroup_DeSpawn(eg_detPack)
	
	Player_SetResource(player1, RT_Manpower, 200)
	Player_SetResource(player1, RT_Fuel, 100)
	Player_SetResource(player1, RT_Munition, 40)
	
	Setup_BridgeAttack_Data()
end


-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
--Called once the intro nis/nislet/sitrep finishes playing.
function Mission_Start()
	Objective_Start(OBJ_DefendZone)
	
	Rule_AddOneShot(StartWaves, 45) 
	Rule_AddDelayedInterval(Fail_Tracker, 1, 1)
end

function Setup_BridgeAttack_Data()
	local wmdt_bridgeAttack = function()
		local waveManagerData = {
			waves = {
				ENCOUNTERS.Wave01(),
				ENCOUNTERS.Wave02(),
				ENCOUNTERS.Wave03(),
			},
			
			-- each chunk is a different direction
			attackDirs = {
				{						-- spawn = The spawn point, dynSpawn = Dynamic spawn target, ui = location for hintpoints, target = target for goal
					{spawn = mkr_challenge_axisspawn1, dynSpawn = mkr_challenge_axisspawn1, ui = nil, target = mkr_enemyDest, rallyPoint = mkr_enemyRallyPoint1},
				},	
				{
					{spawn = mkr_challenge_axisspawn2, dynSpawn = mkr_challenge_axisspawn2, ui = nil, target = mkr_enemyDest, rallyPoint = mkr_enemyRallyPoint1},
				},
				{
					{spawn = mkr_challenge_axisspawn3, dynSpawn = mkr_challenge_axisspawn3, ui = nil, target = mkr_enemyDest, rallyPoint = mkr_enemyRallyPoint3},
				},
				{
					{spawn = mkr_challenge_axisspawn4, dynSpawn = mkr_challenge_axisspawn4, ui = nil, target = mkr_enemyDest, rallyPoint = mkr_enemyRallyPoint2},					
				},
				{
					{spawn = mkr_challenge_axisspawn5, dynSpawn = mkr_challenge_axisspawn5, ui = nil, target = mkr_enemyDest, rallyPoint = mkr_enemyRallyPoint2},					
				},
			},
			
			retreatDirs = {mkr_enemyRetreat}, -- list of retreat points, closest one out of this list is picked
			
			waveCompleteConditionData = {
				condition = CONDITION_UNITS_LEFT,  --CONDITION_GROUP_IS_DEAD
				variable = 2,
				wave_retreats = true,
				vehicles = 0, -- used when condition is check alive, check for minimum threshold of vehicles - 0 means vehicles have to die first or have 0 vehicles and 1 means at least 1 vehicle can remain alive before retreat, works only for condition_units_left
			},
			
			groups = {
				commandGroup = SGroup_CreateIfNotFound("sg_waveCommandGroup"),
				vehicleGroup = SGroup_CreateIfNotFound("sg_waveVehicleGroup"),
			},
			
			defaultGoalData = {
				name = "Attack",
				target = nil,
				range = nil,
				leashRange = 35,
				attackMove = true,		
				attackEngagementMove = true,
				garrison = true,
				pickupWeapons = true,
				movePathLengthFactor = 1,
				safeMoveWeight = 0.0,
				coordinatedMoveRadius = 10,
			},
--~ 			rallyGoalData = {
--~ 				name = "Move",
--~ 				target = nil,
--~ 				range = 20,
--~ 				leashRange = 20,
--~ 				attackMove = true,
--~ 			},
			spawnerData = {
				initialDelay = 5,
				spawnDelay = 0,
			},
			callbackData = {
				onComplete = WaveCompleteCallback,
				onSpawn = nil,
			},
		}
		
		return waveManagerData
	end
	
	wmdt_bridge_attack = WaveManager_SetupNewManagerTable(wmdt_bridgeAttack, false)

end


--Starts the wave manager
function StartWaves()
	WaveManager_SelectSpawns(wmdt_bridge_attack)
	WaveManager_SpawnWave(wmdt_bridge_attack)
end

--Called by WaveManager once a wave is completed
function WaveCompleteCallback()
	if WaveManager_GetWave(wmdt_bridge_attack) < WaveManager_GetTotalWaves(wmdt_bridge_attack) then
		if WaveManager_GetWave(wmdt_bridge_attack) == 2 then
			--Wave3. Send in engineers and reinforcements
			StartDefendEngineers()
			Rule_AddOneShot(Spawn_Engineer_Reinforcements, 5)
		end
	
		WaveManager_NextWave(wmdt_bridge_attack)
		WaveManager_SelectSpawns(wmdt_bridge_attack)
		WaveManager_SpawnWave(wmdt_bridge_attack)
		Spawn_EnemyMinions()
	end
end

function Spawn_EnemyMinions() -- used to supplement the main wave encounter
	
	local t_randomMinion = {
			{ENCOUNTERS.Wave1SupLeft, ENCOUNTERS.Wave1SupRight, ENCOUNTERS.Wave1SupCenter},
			{ENCOUNTERS.Wave2SupLeft, ENCOUNTERS.Wave2SupRight, ENCOUNTERS.Wave2SupCenter},
			{ENCOUNTERS.Wave3SupLeft, ENCOUNTERS.Wave3SupRight, ENCOUNTERS.Wave3SupCenter},	
	}
	
	local g_waveNumber = WaveManager_GetWave(wmdt_bridge_attack)
	local randomMinion = t_randomMinion[g_waveNumber][World_GetRand(1, #t_randomMinion[g_waveNumber])]
	
	g_encWaveMinions = randomMinion()

end

-- Called after Wave2 completed
function StartDefendEngineers()  
	Util_StartIntel(EVENTS.EngineerIntelEvent)
	UI_CreateMinimapBlip(mkr_supplyDrop, 8, BT_General)
	Objective_UpdateText(OBJ_DefendZone, 11076614, Loc_Empty(), true) 	-- LOCDB [11076614] 'Defend the Engineers'
	Rule_AddOneShot(Spawn_Detpack_Engineers, 1)
end

-- Send player reinforcements. Called after Wave2 completed
function Spawn_Engineer_Reinforcements()
	
--~ 	Util_CreateSquads(player1, sg_Reinforcements, SBP.AEF.M1_57MM_AT_GUN_SQUAD_MP, mkr_allySpawn, mkr_cameraStart, 1, nil, true)
	Util_CreateSquads(player1, sg_AllyInfantry, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_allySpawn, mkr_cameraStart, 2, nil, true)
	SGroup_AddGroup(sg_OverallAlly, sg_AllyInfantry)
	
	Cmd_Ability(player3, BP_GetAbilityBlueprint("pm_airdrop_munitions"), mkr_supplyDrop, nil, true, nil)
end


function Spawn_Detpack_Engineers()
	Util_CreateSquads(player3, sg_NPCEngineers, SBP.AEF.ASSAULT_ENGINEER_SQUAD_MP, mkr_allySpawn, mkr_detPack1, 1, nil, true, nil, nil, Marker_GetPosition(mkr_detPack1))
	SGroup_AddGroup(sg_OverallAlly, sg_NPCEngineers)
	
	objID_engineers = Objective_AddUIElements(OBJ_DefendZone, sg_NPCEngineers, true, 11076614, true, 3)
	
	-- flag to track the detpack engineers for objective purposes now
	g_detPackEngSpawned = true 
	
	Event_Proximity(Detpack_StartSequence, nil, sg_NPCEngineers, mkr_detPack1, 4, ANY, 1.5)
end

--Callback when NPCEngineers reach detpack marker
function Detpack_StartSequence()
	Modify_WeaponEnabled(sg_NPCEngineers, "hardpoint_01", false)
	Squad_SetAnimatorState(SGroup_GetSpawnedSquadAt(sg_NPCEngineers, 1), "shovel_digin_state", "active")
	
	Rule_AddOneShot(Detpack_Progress_Initialize, 0)
	Rule_AddOneShot(Spawn_Panzer, 30)
end

-- Start visual indicator of the progress of charges planted
function Detpack_Progress_Initialize()
	tmr_objDetPack_clock = "tmr_objDetPack_clock"
	Timer_Start(tmr_objDetPack_clock, 2*60)	
	Obj_ShowProgress(11076615, 0) 	-- LOCDB [11076615] 'Time until charges are planted'
	
	Rule_AddInterval(Detpack_UpdateClock, 1)
end

-- Updates the detpack timer
function Detpack_UpdateClock()
	local percentage = (Timer_GetElapsed(tmr_objDetPack_clock)/(2*60))	
	
	Obj_ShowProgress(11076615, percentage)	
	
	if percentage >= 1 then
		Rule_AddOneShot(Detpack_Activation, 1)
		Rule_RemoveMe()
	end
end

function Detpack_Activation()
	Objective_RemoveUIElements(OBJ_DefendZone, objID_engineers)
	Obj_HideProgress() -- hide progress bar of "construction" of detpack
	
	EGroup_SetInvulnerable(eg_ObjBridge, false)
	EGroup_ReSpawn(eg_detPack)
	Util_StartIntel(EVENTS.BridgeRigged)
	g_bridgeRigged = true
	
	Objective_UpdateText(OBJ_DefendZone, 11076616, nil, true) 	-- LOCDB [11076616] 'Destroy the Bridge'
	
	if SGroup_IsAlive(sg_NPCEngineers) then
		Modify_WeaponEnabled(sg_NPCEngineers, "hardpoint_01", true)
		Squad_SetAnimatorState(SGroup_GetSpawnedSquadAt(sg_NPCEngineers, 1), "shovel_digin_state", "inactive")
		SGroup_SetPlayerOwner(sg_NPCEngineers, player1)
		Cmd_Retreat(sg_NPCEngineers, mkr_mainBridge)
	end
	
	Rule_AddDelayedInterval(Bridge_Tracker, 1, 1)

end

--Checks if the bridge is destroyed
function Bridge_Tracker()
	if EGroup_IsEmpty(eg_ObjBridge) then
		g_bridgeDestroyed = true
		g_panzerEncounter:ClearGoal()
		Rule_RemoveMe()
	end
end

-- used when Panzer spawns at the end
function Spawn_Panzer() 
	g_panzerEncounter = ENCOUNTERS.PanzerEncounter()
	Util_StartIntel(EVENTS.PanzerIncoming)
	
	-- once Panzer is spawned, check its status.
	Rule_AddDelayedInterval(Panzer_Tracker, 1, 1)
end

function Panzer_Tracker()
	if (SGroup_IsAlive(sg_Panzer) == false) then
		g_panzerDead = true
		if (SGroup_IsAlive(sg_e_wave_all) == true) then
			Cmd_StaggeredRetreat(sg_e_wave_all, {mkr_enemyRetreat})	
		end
		
		if (SGroup_IsAlive(sg_PanzerGroup) == true) then
			Cmd_StaggeredRetreat(sg_PanzerGroup, {mkr_enemyRetreat})
		end
		Rule_RemoveMe()
	end
end


--Checks if the mission is completed
function Win_Tracker()

	if g_panzerDead or g_bridgeDestroyed then
		
		g_youWin = true
		
	end

end

-- Checks if the mission is failed
function Fail_Tracker() 
	sg_Player1SGroups = Player_GetSquads(player1)
	
	-- if the det pack engineers have appeared and the bridge is not rigged... and the det pack engineers are dead... then the failure condition is triggered
	if g_detPackEngSpawned == true and g_bridgeRigged == false then 
		
		if SGroup_IsAlive(sg_NPCEngineers) == false then
			if g_youFail == false then
				g_youFail = true			
				Rule_RemoveMe()
			end
		end
		
	end
	
	-- if the player has no infantry left amongst the units assigned to them, then the failure condition gets realized
	if SGroup_ContainsBlueprints(sg_Player1SGroups, {SBP.AEF.RIFLEMEN_SQUAD_MP, SBP.AEF.ASSAULT_ENGINEER_SQUAD_MP, SBP.AEF.PATHFINDER_SQUAD_MP, SBP.AEF.PARATROOPER_SQUAD_MP}, ANY) == false then
		if g_youFail == false then
			g_youFail = true			
			Rule_RemoveMe()
		end
	end

end



--Debug function to restart wave manager
function _ResetWaves()
	if Misc_IsCommandLineOptionSet("dev") then
		Event_RemoveAll()
		WaveManager_ClearWaveManager()
		Setup_BridgeAttack_Data()
	end
end
