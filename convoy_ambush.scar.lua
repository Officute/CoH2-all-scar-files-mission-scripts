print("\tLoading mission file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Convoy Ambush
-- Designer: R.McGechaen
-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScriptSetup.scar") -- <== ### CRITICAL ELEMENT. 

-- [[ Objective files ]]
import("Convoy_Ambush_obj_reuniteWithConvoy.scar")

-- [[ Encounter data ]]
import("Convoy_Ambush_encounters.scar")


-------------------------------------------------------------------------
-- [[ MISSION SETUP ]]
-------------------------------------------------------------------------
-- Initializes players
function Mission_SetupPlayers()
	--For Missions/Challenges:
	player1 = Setup_Player(1, 11073202, "aef", 1)		-- player1 is always the human player
	player3 = Setup_Player(3, 11073202, "aef", 1)		-- allied player
	player5 = Setup_Player(2, 11073205, "west_german", 2)		-- player2 is always the AI opponent
	
end

-- Defines key mission data and any global values used throughout the mission.
function Mission_SetupVariables()
	print("Initializing mission DATA...")
	
	-- Had to define these first for the startingUnits
	sg_truck = SGroup_CreateIfNotFound("sg_truck")
	sg_echelonTroops = SGroup_CreateIfNotFound("sg_echelonTroops")
	
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
			OBJ_MainObjective,							-- These are the global references to the objective tables defined in the separete files.
		},
		startingUnits = {
			{
				sbp = SBP.AEF.DODGE_WC51_SQUAD_MP,
				spawn = mkr_convoyAmbush_truckSpawn,
				sgroups = {sg_truck},
			},
			{
				sbp = SBP.AEF.ASSAULT_ENGINEER_SQUAD_MP,
				spawn = mkr_convoyAmbush_unitsSpawn_01,
				sgroups = {sg_echelonTroops},
			},
			{
				sbp = SBP.AEF.RIFLEMEN_SQUAD_MP,
				spawn = mkr_convoyAmbush_unitsSpawn_02,
				sgroups = {sg_echelonTroops},
			},
			{
				sbp = SBP.AEF.PATHFINDER_SQUAD_MP,
				spawn = mkr_convoyAmbush_unitsSpawn_03,
			},
		},
	}
	
	
	--[[GLOBAL VARIABLES]]
	sg_convoy_all = SGroup_CreateIfNotFound("sg_convoy_all") --all enemies spawned on-start
	
	
	--[[MAP GROUPS]]
	
end

-- Defines difficulty tables/tuning variables
function Mission_SetDifficulty(diffVal)
	-- These variables should be stored in a t_difficulty table for readability and access.
	
	g_difficulty = diffVal or Game_GetSPDifficulty() 	-- Note: Having the diffVal parameter allows for redefining difficulty settings during runtime.
	AI_OverrideDifficulty(g_difficulty)
	
	--Global difficulty table
	t_difficulty = {
		startAttackDelay = Util_DifVar({90, 60, 45}, g_difficulty),
	}
end

-- Sets restrictions on units, teams, etc.
function Mission_SetupRestrictions()
	--	Note: Resource Income/Caps should be defined in Mission_SetDifficulty()
	
	--[[ HUMAN PLAYER ]]
	Modify_PlayerResourceCap(player1, RT_Manpower, 51, MUT_Addition)
	Modify_PlayerResourceCap(player1, RT_Munition, 151, MUT_Addition)
	Modify_PlayerResourceCap(player1, RT_Fuel, 1, MUT_Addition)
	
	--[[ ALLIED PLAYER ]]
	
	--[[ ENEMY PLAYER ]]
	
end

-- Sets up the map before the mission starts (starting units, ownership, etc.)
function Mission_Preset()
	Camera_ResetToDefault()
	Camera_MoveTo(mkr_convoyAmbush_camStart)
	
	XP1_SetActiveCommander(CD_NONE)
	
	--Damage the truck
	Cmd_CriticalHit(player1, sg_truck, CRIT.VEHICLE_DAMAGE_ENGINE, 110.0)
	
	--Give player grenades
	Cmd_Upgrade(player1, UPG.AEF.RIFLE_COMMAND_GRENADE_MP, 1, true)
	
	--Prevent the player from de-crewing truck
	Player_SetAbilityAvailability(player1, ABILITY.AEF.VEHICLE_DECREW_VEHICLE_CREW_MP, ITEM_LOCKED)
	
	-- Remove all territory points
	EGroup_DestroyAllEntities(eg_allTerrPoints)
	EGroup_EnableMinimapIndicator(eg_allTerrPoints, false)
	
	--Spawn allies
	local t_alliedSpawns = Marker_GetSequence("mkr_allies", "")
	for k,pos in pairs(t_alliedSpawns) do
		Util_CreateSquads(player3, nil, SBP.AEF.RIFLEMEN_SQUAD_MP, pos)
	end
	
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
	
	-- Initialize Encounters
	ConvoyAmbush_SetupEncounters()
	
end




-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
--Called once the intro nis/nislet/sitrep finishes playing.
function Mission_Start()
	Objective_Start(OBJ_MainObjective)
end


function ConvoyAmbush_SetupEncounters()
	ENCOUNTERS.convoyAmbush_01()
	ENCOUNTERS.convoyAmbush_02()
	ENCOUNTERS.convoyAmbush_03()
	ENCOUNTERS.convoyAmbush_04()
	ENCOUNTERS.convoyAmbush_05()
	ENCOUNTERS.convoyAmbush_06()
	
	-- Static Encounters
end

-- Signals an encounter to attack sg_truck. Triggered when an encounter _IsEngaged.
function _ChangeToAttack(data)
	GOALS.attackTruck(data.encTable)
end


