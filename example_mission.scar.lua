-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- EXAMPLE MISSION
-------------------------------------------------------------------------
-------------------------------------------------------------------------
import("ScriptSetup.scar") -- Imports the SP Script Setup file 
--The following functions are called (in order) by ScriptSetup.scar. If you wish to create your own structure, Scar_AddInit(functionName) can be used to set a function call on mission initialization
--[[ 
		Mission_SetupPlayers() 		-- Called by OnGameSetup() on frame1
		Mission_SetupVariables()
		Mission_SetDifficulty()
		Mission_SetupRestrictions()
		Mission_Preset()
		Objectives are registered
		Intro NIS
		Intro NISlet
		Sitrep
		Mission_Start()
]]--

-- [[ Objective files ]]
	--Import Objectives files you want to include. 
	--Filename Format: <scenarioName>_obj_<objectiveName>.scar -- Eg. import("newTemplate_Obj_EXAMPLE.scar")
import("Example_Mission_obj_FirstObjective.scar")
import("Example_Mission_obj_SecondObjective.scar")

-- [[ Encounter data ]]
	--Import encounter data. 
	--Filename format: <scenarioName>_encounters.scar -- Eg. import("newTemplate_encounters.scar")
import("Example_Mission_Encounters.scar")

-------------------------------------------------------------------------
-- [[ MISSION SETUP ]]
-------------------------------------------------------------------------
-- Initializes players
function Mission_SetupPlayers()	
	player1 = World_GetPlayerAt(1)		-- player1 is always the human player
	player2 = World_GetPlayerAt(2)				-- player2 is always the AI opponent
end

-- Defines key mission data and any global values used throughout the mission.
function Mission_SetupVariables()
	print("Initializing mission DATA...")
	
	-- Defines mission initialization data. Example in comments on the bottom of this file.
	-- This table contains initialization data for the mission, and is useful for easily setting up the mission's information in one place
	g_missionData = {
		useEncounterSystem = true,					-- Whether or not to use the Encounter system
		missionSpeechPath =  "mission/m02",					-- Speech path to cache (string)
		objectives = {								-- List of PARENT objective tables.
			OBJ_FirstObjective,							-- These are the global references to the objective tables defined in the separete files.
			OBJ_SecondObjective,							-- These are the global references to the objective tables defined in the separete files.
		},
		startingUnits = {							-- Units to be spawned for P1 on mission start. Follows same parameters as Encounters.
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD_MP, --The blueprint of the unit. Exisitng units can be referenced as enums, but units can also be referenced by name by using BP_GetSquadBlueprint("unit_name")
				spawn = mkr_playerSpawns, --The location to spawn the unit at
				upgrades = UPG.SOVIET.CONSCRIPT_AT_GRENADE_ASSAULT, --Any upgrade blueprints the unit should have (can be referenced by string via BP_GetUpgradeBlueprint("upgrade_name"))
				entityUpgrades = nil, --Any upgrade blueprints the unit should have (can be referenced by string via BP_GetUpgradeBlueprint("upgrade_name"))
				slotItems = nil, --Any slot items  the unit should have (can be referenced by string via BP_GetSlotItemBlueprint("item_name"))
				numSquads = 2, --The number of squads to spawn
				load = 3, -- Units per squad
				veterancyRank = 2, --The veterancy the units should start at
			},
			{
				-- Unused parameters can be left out to keep your script clean
				sbp = SBP.SOVIET.COMBAT_ENGINEER_SQUAD_MP,
				spawn = mkr_playerSpawns,
			}
		}
	}
end

-- Setup restrictions on units, teams, resources etc.
function Mission_SetupRestrictions()	
	Player_SetMaxPopulation(player1, CT_Personnel, 30)
end

-- Setup any units, the camera or anything else that needs to bes et prior to the mission starting
function Mission_Preset()
	--Move the camera to the start position
	Camera_MoveTo(mkr_playerSpawns, false)	
	
	--This is a helper function to gather all of the player's base buildings into one egroup
	Util_CollectPlayerBase()
	
	-- We don't want the player to start with the initial set of Rear Eschlon, as we scripted in their units already
	SGroup_Clear(sg_temp)
	Player_GetAllSquadsNearMarker(player1, sg_temp,  Util_GetPosition(eg_playerBase), 20)
	SGroup_DeSpawn(sg_temp)
	
	-- In this example mission, the player begins without having control of their base - so we set their base to be owned by the world until they capture it (See Example_Mission_obj_FirstObjective.scar)
	EGroup_SetWorldOwned(eg_playerBase)	
end

-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
--Called once the intro nis/nislet/sitrep finishes playing.
function Mission_Start()	
	Objective_Start(OBJ_FirstObjective)	--Starts the first objective. Each objective holds its own logic. They are typically held in their own script file, in this case Example_Mission_obj_FirstObjective.scar
end
 
-------------------------------------------------------------------------
-- [[ UTILITY FUNCTIONS]]
-------------------------------------------------------------------------
-- Puts the player's base buildings into an egroup for easy access
function Util_CollectPlayerBase() 
	Player_GetAll(player1) --Sets the egroup eg_allentities to hold all of the player's currently owned buildings
	
	eg_playerBase = EGroup_CreateIfNotFound("eg_playerBase")
	
	--Checks each entity the player owns, and assigns to to the egroup eg_playerBase if it is a base building
	local _sortBase = function(gid, idx, eid)
		if Entity_GetBlueprint(eid) == EBP.SOVIET.HQ_MP then
			EGroup_Add(eg_playerBase, eid)
		end
	end
	
	EGroup_ForEach(eg_allentities, _sortBase) --This calls the above function on each entity in the egroup
end

-------------------------------------------------------------------------
-- [[ ***************   EXAMPLES MISSION DATA  ***************** ]]
-------------------------------------------------------------------------
--[[ Sample 'g_missionData'
	g_missionData = {
		useBeginnerHints = false,					-- Wether or not to use the BeginnerHint system
		useEncounterSystem = true,					-- Whether or not to use the Encounter system
		introNIS = "m02_cin02", 					-- Movie filename
		introNISlet = NIS_EVENTS.NIS_Setup, 		-- NISlet triggered after introNIS
		introNISletSkipped = testSkip, 				-- Function called if the introNISlet is skipped
		introSitRep = "m02_sitrep",					-- Movie to play after intro nislet
		endNISlet = nil,							-- NISlet triggered on mission completion
		endNIS = "m02_cin03",						-- Movie to play on mission completion
		missionSpeechPath = "mission/m02",
		precacheSounds = {							-- Any audio files you want precached
			"campaign/train_depart_mission_2",
			"campaign/m02_panic_crowd"
		},
		nisFiles = {								-- .nis files associated with the mission
			"SP/CoH2_Campaign/M02-Scorched_Earth/nis/m02_introPan_v4",
		},
		nisInTransitionTime = 0,
		nisOutTransitionTime = 0,
		objectives = {								-- List of PARENT objective tables.
			OBJ_Example,							-- These are the global references to the objective tables defined in the separete files.
		}
		startingUnits = {							-- Units to be spawned for P1 on mission start. Follows same parameters as Encounters.
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_troopDrop,
				upgrades = nil,
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
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_troopDrop,
			},
		}
	}
]]--
