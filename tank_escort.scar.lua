

-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Tank Escort - Mini Challenge
-- Designer: Byron Chow
-------------------------------------------------------------------------
-------------------------------------------------------------------------
import("ScriptSetup.scar") -- <== ### CRITICAL ELEMENT.
-- [[ Objective files ]]
import("Tank_Escort_obj_protectTheTank.scar")
-- [[ Encounter data ]]
import("Tank_Escort_encounters.scar")

 
-------------------------------------------------------------------------
-- [[ MISSION SETUP ]]
-------------------------------------------------------------------------
-- Initializes players
function Mission_SetupPlayers()
    player1 = Setup_Player(1, 11073202, "aef", 1)		-- player1 is always the human player
	player2 = Setup_Player(2, 11073205, "west_german", 2)		-- player2 is always the AI opponent
	player3 = Setup_Player(3, 11073202, "aef", 1)		-- player3 is the allied tank
end



 
-- Defines key mission data and any global4 values used throughout the mission.
function Mission_SetupVariables()
	
	-- randomly select a path (or use the one specified in the command line)
	if Misc_IsCommandLineOptionSet("path1") then
		g_path_number = 1
	elseif Misc_IsCommandLineOptionSet("path2") then
		g_path_number = 2
	else
		-- Randomly select one of the two paths
		g_path_number =  World_GetRand(1, 2)
	end
	
	g_waypoint_count = 0	-- how many waypoints has the tank gone through (used to determine which wyapoints to show)
	sg_enemies = SGroup_CreateIfNotFound("sg_enemies")
	
	-- path specific variables
	if g_path_number == 1 then
		g_camera_start = mkr_camera_start1
		g_tank_path = "path_tank1"
		g_tank_spawn = mkr_starting_tank1
		g_player_spawn1 = mkr_path1_starting_squad1
		g_player_spawn2 = mkr_path1_starting_squad2
		g_player_spawn3 = mkr_path1_starting_squad3
		g_player_spawn4 = mkr_path1_starting_squad4
		g_escape_point = mkr_escape_point1
		t_waypoints = {mkr_path1_waypoint1, mkr_path1_waypoint2, mkr_escape_point1}
		
	else
		g_camera_start = mkr_camera_start2
		g_tank_path = "path_tank2"
		g_tank_spawn = mkr_starting_tank2
		g_player_spawn1 = mkr_path2_starting_squad1
		g_player_spawn2 = mkr_path2_starting_squad2
		g_player_spawn3 = mkr_path2_starting_squad3
		g_player_spawn4 = mkr_path2_starting_squad4
		g_escape_point = mkr_escape_point2
		t_waypoints = {mkr_path2_waypoint1, mkr_path2_waypoint2, mkr_escape_point2}
	end
	
	-- Had to define these first for the startingUnits
	sg_tank = SGroup_CreateIfNotFound("sg_tank")
	sg_playerTroops = SGroup_CreateIfNotFound("sg_playerTroops")

    g_missionData = {
        useBeginnerHints = false,                   -- Wether or not to use the BeginnerHint system
        useEncounterSystem = true,                  -- Whether or not to use the Encounter system
        useXP1Difficulty == true,                   -- Enable/Disable use of CoH2-XP1 dynamic difficulty settings
        missionType = MT_XP1_MINICHALLENGE,                    -- Defines the mission type MT_BATTLE, MT_CHALLENGE, MT_SCENARIO
        introNIS = nil,                   -- Movie filename
        introNISlet = nil,         -- NISlet triggered after introNIS
        introNISletSkipped = nil,              -- Function called if the introNISlet is skipped
        introSitRep = nil,                   -- Movie to play after intro nislet
        endNISlet = nil,                            -- NISlet triggered on mission completion
        endNIS = nil,                     -- Movie to play on mission completion
        missionSpeechPath = "botb/gameplay",
        precacheSounds = {                          -- Any audio files you want precached
        },
        nisFiles = {                                -- .nis files associated with the mission
        },
        nisInTransitionTime = 0,
        nisOutTransitionTime = 0,
        objectives = {                              -- List of PARENT objective tables.
            OBJ_MainObjective,                            -- These are the global references to the objective tables defined in the separete files.
        },
        startingUnits = {                           -- Starting units for the player. See Encounter System for details on parameters.
			{
				sbp = SBP.AEF.RIFLEMEN_SQUAD_MP,
				spawn = g_player_spawn1,
				--upgrades = UPG.GERMAN.GRENADIER_MG42_LMG_MP,
				sgroups = {sg_playerTroops},
				--conditional = Util_GetCommander() == CD_AIRBORNE,
			},
			{
				sbp = SBP.AEF.RIFLEMEN_SQUAD_MP,
				spawn = g_player_spawn2,
				sgroups = {sg_playerTroops},
			},
			{
				sbp = SBP.AEF.PATHFINDER_SQUAD_MP,
				spawn = g_player_spawn3,
				sgroups = {sg_playerTroops},
			},
			{
				sbp = SBP.AEF.PARATROOPER_SQUAD_MP,
				spawn = g_player_spawn4,
				sgroups = {sg_playerTroops},
			},
        },
    }
end
 
-- Defines difficulty tables/tuning variables
function Mission_SetDifficulty(diffVal)
    --TODO: Define any difficulty-related settings or variables.
end
 
-- Sets restrictions on units, teams, etc.
function Mission_SetupRestrictions()
    --TODO: Set any tech/ability restrictions on a players, as well as resource limits.
end
 
-- Sets up the map before the mission starts (starting units, ownership, etc.)
function Mission_Preset()
	
	-- turn off resources, give appropriate resources and unlocks
	Resources_Disable()
	Player_SetResource(player1, RT_Manpower, 0.0)
	Player_SetResource(player1, RT_Munition, 200.0)
	Player_SetResource(player1, RT_Fuel, 0.0)
	Command_PlayerUpgrade(player1, UPG.AEF.RIFLE_COMMAND_GRENADE_MP, true, false)
	
	XP1_SetActiveCommander(CD_NONE)
	
	-- starting camera
	Camera_ResetToDefault()
	Camera_MoveTo(g_camera_start)

	-- set up tank
	Util_CreateSquads(player3, sg_tank, SBP.AEF.M4A3_SHERMAN_SQUAD_MP, g_tank_spawn)
	Squad_SetHealth(SGroup_GetSpawnedSquadAt(sg_tank, 1), 0.75)
	Cmd_CriticalHit(player1, sg_tank, CRIT.VEHICLE_DAMAGE_ENGINE, 100.0)
	Modify_UnitSpeed(sg_tank, 0.4)
	Cmd_InstantUpgrade(sg_tank, UPG.AEF.SHERMAN_TOP_GUNNER_MP)
	
	-- Initialize Encounters
	TankEscort_SetupEncounters()
end
 
-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
--Called once the intro nis/nislet/sitrep finishes playing.
function Mission_Start()
    
	-- start main objective
	Objective_Start(OBJ_MainObjective)
	Event_NarrativeEventsNotRunning(EventHandler_StartIntel, {intel = EVENTS.ArmorComplain}, 1.0)

	-- start checking if the tank escaped
	Rule_AddInterval(CheckTankEscaped, 1)
	
	-- start waypoint manager
	Rule_AddInterval(WaypointManager, 1)
	-- show waypoint
	g_waypoint_id = Objective_AddUIElements(SOBJ_ScoutAhead, t_waypoints[1], true, 11076617, true) 	-- LOCDB [11076617] 'Tank Waypoint'
	
	
	-- send the tank along the path
	Rule_AddOneShot(MoveTank, 10.0)
	
end

-- called to start to the tank moving
function MoveTank()
	Cmd_SquadPath(sg_tank, g_tank_path, true, LOOP_NONE, false)
end

-- Encounter setup (only enable encounters along the path we are using
function TankEscort_SetupEncounters()

	if g_path_number == 1 then
		ENCOUNTERS.encounter1a()
		ENCOUNTERS.encounter2a()
		ENCOUNTERS.encounter3a()
	else
		ENCOUNTERS.encounter1b()
		ENCOUNTERS.encounter2b()
		ENCOUNTERS.encounter3b()
	end
end



-- Show waypoints to indicate where the tank is heading
function WaypointManager()

	if (g_waypoint_count < 1 and Prox_AreSquadsNearMarker(sg_tank, t_waypoints[1], true, 15.0)) then
		g_waypoint_count = 1
		Objective_RemoveUIElements(SOBJ_ScoutAhead, g_waypoint_id)
		g_waypoint_id = Objective_AddUIElements(SOBJ_ScoutAhead, t_waypoints[2], true, 11076617, true)
		
	elseif (g_waypoint_count == 1 and Prox_AreSquadsNearMarker(sg_tank, t_waypoints[2], true, 15.0)) then
		g_waypoint_count = 2
		Objective_RemoveUIElements(SOBJ_ScoutAhead, g_waypoint_id)
		g_waypoint_id = Objective_AddUIElements(SOBJ_ScoutAhead, t_waypoints[3], true, 11076618, true) 	-- LOCDB [11076618] 'Escape Point'
		
	end
end


-- Mission Complete check: Check if tank escaped or died 
function CheckTankEscaped()
	
	if not SGroup_IsAlive(sg_tank) then
		Objective_Fail(OBJ_MainObjective)
		print("************* FAILED *****************")
		Rule_RemoveMe()
		
	elseif ( Prox_AreSquadsNearMarker(sg_tank, g_escape_point, ALL) or (not SGroup_IsAlive(sg_enemies)) ) then
		Objective_Complete(OBJ_MainObjective)
		print("************* WIN *****************")
		Rule_RemoveMe()
	
	end
end

