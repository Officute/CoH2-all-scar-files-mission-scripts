print("\tLoading mission file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Tank Hunter
-- Designer: A.Molina
-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScriptSetup.scar") -- <== ### CRITICAL ELEMENT. 

-- [[ Objective files ]]
import("Tank_Hunter_obj_killTanks.scar")

-- [[ Encounter data ]]
import("Tank_Hunter_encounters.scar")


-------------------------------------------------------------------------
-- [[ MISSION SETUP ]]
-------------------------------------------------------------------------
-- Initializes players
function Mission_SetupPlayers()
	--For Missions/Challenges:
	player1 = Setup_Player(1, 11073202, "aef", 1)		-- player1 is always the human player
--~ 	player3 = Setup_Player(3, LOC("AEF"), "aef", 1)		-- allied player
	player2 = Setup_Player(2, 11073205, "west_german", 2)		-- player2 is always the AI opponent
	
end

-- Defines key mission data and any global values used throughout the mission.
function Mission_SetupVariables()
	print("Initializing mission DATA...")
	
	-- ### CRITICAL ELEMENT. This table contains all the initialization data for the mission.
	g_missionData = {
		useBeginnerHints = false,					-- Wether or not to use the BeginnerHint system
		useEncounterSystem = true,					-- Whether or not to use the Encounter system
		useXP1Difficulty = true,					-- Whether or not this mission uses the XP1 Difficulty system
		missionType = MT_XP1_MINICHALLENGE,			-- Whether or not this missino is a mini challenge
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
			OBJ_KillTanks,							-- These are the global references to the objective tables defined in the separete files.
		},
		startingUnits = {
			{
				sbp = SBP.AEF.M10_TANK_DESTROYER_SQUAD_MP,
				spawn = mkr_spawn1,
				veterancyRank = 1,
			},
			{
				sbp = SBP.AEF.M5A1_STUART_SQUAD_MP,
				spawn = mkr_spawn2,
			},
		},
	}
	
	
	--[[GLOBAL VARIABLES]]
	sg_enemyTanks = SGroup_CreateIfNotFound("sg_enemyTanks")
	t_tankEncounters = {
		ENCOUNTERS.enemyTank_01,
		ENCOUNTERS.enemyTank_02,
		ENCOUNTERS.enemyTank_03,
	}
	
	--[[MAP GROUPS]]
	-- eg_allTerrPoints		-- All territory points on the map
end

-- Defines difficulty tables/tuning variables
function Mission_SetDifficulty(diffVal)
	-- These variables should be stored in a t_difficulty table for readability and access.
	
	g_difficulty = diffVal or Game_GetSPDifficulty() 	-- Note: Having the diffVal parameter allows for redefining difficulty settings during runtime.
	AI_OverrideDifficulty(g_difficulty)
	
	--Global difficulty table
	t_difficulty = {
--~ 		startAttackDelay = Util_DifVar({90, 60, 45}, g_difficulty),
	}
end

-- Sets restrictions on units, teams, etc.
function Mission_SetupRestrictions()
	--	Note: Resource Income/Caps should be defined in Mission_SetDifficulty()
	
	--[[ HUMAN PLAYER ]]
	Modify_PlayerResourceRate(player1, RT_Manpower, 0, MUT_Multiplication)
	Modify_PlayerResourceRate(player1, RT_Munition, 0, MUT_Multiplication)
	Modify_PlayerResourceRate(player1, RT_Fuel, 0, MUT_Multiplication)
	
	--[[ ALLIED PLAYER ]]
	
	--[[ ENEMY PLAYER ]]
	
end

-- Sets up the map before the mission starts (starting units, ownership, etc.)
function Mission_Preset()
	Camera_ResetToDefault()
	Camera_MoveTo(mkr_camStart)
	
	XP1_SetActiveCommander(CD_NONE)
	
	--Map cleanup
	EGroup_EnableMinimapIndicator(eg_allTerrPoints, false)
	EGroup_DestroyAllEntities(eg_allTerrPoints)	
	
	-- Spawn munitions crates
	local tmkr_munitions = Marker_GetTable("mkr_convoyAmbush_munitions_%02d")
	for i=1, table.getn(tmkr_munitions) do
		local eg = EGroup_Create("")
		Util_CreateEntities(nil, eg, BP_GetEntityBlueprint("generic_instantuse_munitions_ammobox_item_15"), tmkr_munitions[i], 1)
		EGroup_Destroy(eg)
	end
	
	-- Setup Starting Resources
	Player_SetResource(player1, RT_Manpower, 0)
	Player_SetResource(player1, RT_Munition, 100)
	Player_SetResource(player1, RT_Fuel, 0)
	
	--Enemy
	Player_SetResource(player2, RT_Munition, 350)
	
	-- Initialize Encounters
	TankHunter_SetupEncounters()
end




-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
--Called once the intro nis/nislet/sitrep finishes playing.
function Mission_Start()
	Objective_Start(OBJ_KillTanks)
end


function TankHunter_SetupEncounters()
	local t_spawnLocs = Marker_GetTable("mkr_tankSpawn_%02d")
	
	for k,enc in pairs(t_tankEncounters) do
		local i = World_GetRand(1, #t_spawnLocs)
		local tankEncounter = enc(t_spawnLocs[i])
		t_tankEncounters[k] = tankEncounter
		table.remove(t_spawnLocs, i)
	end
	
	--Send in support for every tank attacked.
	Event_GroupCount(EnableSupport, nil, sg_enemyTanks, 2, true, 3)
	Event_GroupCount(EnableSupport, nil, sg_enemyTanks, 1, true, 3)
	
	-- Static Encounters
	-- None so far.
end

--Start Checking if enemy tank is under attack. Callback count(sg_enemyTanks) <= 2
function EnableSupport(data)
	local _events = {}
	for k,enc in pairs(t_tankEncounters) do
		if enc:HasGoal() then
			table.insert(_events, Event_IsUnderAttack(__DoNothing, {encounter = enc}, enc:GetSgroup(), ANY, 5))
		end
	end
	
	Event_CreateOR(SendSupport, nil, _events, 2)
end

--Callback to send support units to a tank under attack.
function SendSupport(data)
--~ 	view(data)
	local unitData = {
		sbp = -1,
		spawn = mkr_retreat,
		dynamicSpawnTarget = data._triggerData._group,
	}
	
	if(Objective_IsCounterSet(OBJ_KillTanks) and Objective_GetCounter(OBJ_KillTanks) == 1) then
		print("spawn pioneers!")
		unitData.sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP
	elseif(Objective_IsCounterSet(OBJ_KillTanks) and Objective_GetCounter(OBJ_KillTanks) == 2) then
		print("spawn panzershreck!")
		unitData.sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP
		unitData.slotItems = {SLOT_ITEM.PANZERSHRECK_MP}
	end
	
	data._triggerData.encounter:AddUnit(unitData)
end
