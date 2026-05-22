print("\tLoading mission file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Tank Grab
-- Designer: Ryan McGechaen
-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScriptSetup.scar") -- <== ### CRITICAL ELEMENT. 
import("XP1.scar")				-- Ardennes Assault functionality
import("WinConditions/AABattle_VictoryPointPlusAnnihilate.scar")
-- [[ Objective files ]]
import("Tank_Grab_obj_VICTORY.scar")
import("XP1_NarrativeObj.scar")

-- [[ Encounter data ]]
import("Tank_Grab_encounters.scar")



-------------------------------------------------------------------------
-- [[ MISSION SETUP ]]
-------------------------------------------------------------------------
-- Initializes players
function Mission_SetupPlayers()
	-- Not used in battles
end

function Override_Player_Setup()
	local playerCount = World_GetPlayerCount()
	
	for i = 1, playerCount do
		local index = i
		if Player_IsHuman(World_GetPlayerAt(index)) then
			player1 = World_GetPlayerAt(index)
		else
			player2 = World_GetPlayerAt(index)
		end
	end
end

-- Defines key mission data and any global values used throughout the mission.
function Mission_SetupVariables()
	print("Initializing mission DATA...")
	print("LOADING BATTLE: Tank Grab")
	

	if Marker_Exists("mkr_mapidentifier_marche", "") then	-- add some extra stuff to do with beginner hints IF and ONLY IF we are playing on Marche
		import("Libraries/BattleExtras/XP1_Marche_BeginnerHintSetup.scar")
		Marche_StartUpBeginnerHints("Tank_Grab")
	end
	
	
	--TODO: Define mission initialization data. Example in comments on the bottom of this file.
	-- ### CRITICAL ELEMENT. This table contains all the initialization data for the mission.
	g_missionData = {
		useBeginnerHints = false,					-- Wether or not to use the BeginnerHint system
		useEncounterSystem = true,					-- Whether or not to use the Encounter system
		useXP1Difficulty = true,					-- Whether or not this mission uses the XP1 Difficulty system
		missionType = MT_XP1_BATTLE,					-- What Mission Type is this mission? MT_
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
			OBJ_Victory,							-- These are the global references to the objective tables defined in the separete files.
		},
		startingUnits = {							-- Units to be spawned for P1 on mission start. Follows same parameters as Encounters.
--~ 			{
--~ 				sbp = BP_GetSquadBlueprint("vehicle_crew_squad_mp"),
--~ 				spawn = mkr_tankGrab_crewSpawn_01,
--~ 			},
--~ 			{
--~ 				sbp = SBP.AEF.M2HB_50CAL_HMG_SQUAD_MP,
--~ 				spawn = mkr_tankGrab_crewSpawn_02,
--~ 			},
			{
				sbp = BP_GetSquadBlueprint("rear_echelon_squad_mp"),
				spawn = mkr_tankGrab_crewSpawn_01,
			},
		},
		
	}
	
	PM_PL_StartingVP = true
	PM_PL_StartingResourceHit = true
	
	--[[GLOBAL VARIABLES]]
	
	t_spawns = {}
	t_vehicles = {}
	t_wrecks = {}
	t_intents = {
		ENC_INTENT.basicInfantry,
	}
	
	t_abandoned_tank_ids = {}		-- tabke for abandoned tanks on the field
	
	flag_are_germans_capturing_tank = false	-- flag to check if the germans are trying to refuel a tank
	flag_first_capture_attempt_spawned = false	-- flag to check if the first capture team spawn has happened (so we can change the timing and difficulty of the subsequent ones)
	g_playerCapture = 0		-- how many tank wrecks the player has captured
	g_target_tank_group	= nil	-- current target tank wreck of the capture teams
	g_target_world_id	= nil	-- current target tank wreck of the capture teams
	g_player_score = 0	-- score to determine victory for player
	g_enemy_score = 0	-- score to determine victory for germans
	g_index = 1				-- index for numbering abandoned tank groups
	g_point_deduction = 5	-- how many victory points a player loses when an entity is killed
	g_point_deduction_vehicles = 5	-- how many victory points a player loses when a vehicle is killed
	g_abandon_chance = 25	-- the percentage chance a vehicle will decrew instead of dying
	g_first_player_kill = false	-- first time player gets a kill with a vehicle
	g_player_tank_already_killed = false	-- first time player loses a vehicle
	
	
	--[[MAP GROUPS]]

	
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	eg_temp = EGroup_CreateIfNotFound("eg_temp")
	sg_captureTeam1_Capture = SGroup_CreateIfNotFound("sg_captureTeam1_Capture")
	sg_captureTeam1_Repair = SGroup_CreateIfNotFound("sg_captureTeam1_Repair")
	sg_captureTeam_All = SGroup_CreateIfNotFound("sg_captureTeam_All")
	sg_capture_encounter = SGroup_CreateIfNotFound("sg_capture_encounter")
	sg_enemyBaseDef = SGroup_CreateIfNotFound("sg_enemyBaseDef")
	sg_already_vet = SGroup_CreateIfNotFound("sg_already_vet")	-- group for units we have already given veterancy to
	
	-- groups for managing abandon tank functions
	eg_player1_tanks = EGroup_CreateIfNotFound("eg_player1_tanks")
	eg_player2_tanks = EGroup_CreateIfNotFound("eg_player2_tanks")
	sg_player1_tanks = SGroup_CreateIfNotFound("sg_player1_tanks")
	sg_player2_tanks = SGroup_CreateIfNotFound("sg_player2_tanks")
	sg_alltanks = SGroup_CreateIfNotFound("sg_alltanks")
	sg_exclude_tanks = SGroup_CreateIfNotFound("sg_exclude_tanks")

	t_tanklist = {
		SBP.AEF.M15A1_AA_HALFTRACK_SQUAD_MP,
		SBP.AEF.M3_HALFTRACK_SQUAD_ASSAULT_MP,
		SBP.AEF.M3_HALFTRACK_SQUAD_MP,
		SBP.AEF.M10_TANK_DESTROYER_SQUAD_MP,
		SBP.AEF.M36_TANK_DESTROYER_SQUAD_MP,
		SBP.AEF.M4A3_76MM_SHERMAN_BULLDOZER_SQUAD_MP,
		SBP.AEF.M4A3_76MM_SHERMAN_SQUAD_MP,
		SBP.AEF.M4A3_SHERMAN_SQUAD_MP,
		SBP.AEF.M4A3E8_SHERMAN_EASY_8_SQUAD_MP,
		SBP.AEF.M5A1_STUART_SQUAD_MP,
		SBP.AEF.M7B1_PRIEST_SQUAD_MP,
		SBP.AEF.M20_UTILITY_CAR_SQUAD_MP,
		SBP.AEF.M8_GREYHOUND_SQUAD_MP,
		SBP.AEF.M8A1_HMC_SQUAD_MP,
		SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP,
		SBP.WEST_GERMAN.JAGDPANZER_TANK_DESTROYER_SQUAD_MP,
		SBP.WEST_GERMAN.JAGDTIGER_TD_SQUAD_MP,
		SBP.WEST_GERMAN.KING_TIGER_SQUAD_MP,
		SBP.WEST_GERMAN.OSTWIND_SQUAD_WESTGERMAN_MP,
		SBP.WEST_GERMAN.PANTHER_AUSF_G_SQUAD_MP,
		SBP.WEST_GERMAN.PANTHER_COMMANDER_SQUAD_MP,
		SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
		SBP.WEST_GERMAN.PANZER_IV_AUSF_J_BATTLE_GROUP_MP,
		SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP,
		SBP.WEST_GERMAN.SDKFZ_251_20_IR_SEARCHLIGHT_HALFTRACK_SQUAD_MP,
		SBP.WEST_GERMAN.SDKFZ_251_WURFRAHMEN_40_HALFTRACK_SQUAD_MP,
		SBP.WEST_GERMAN.STURMTIGER_SQUAD_MP,
	}
end



-- Defines difficulty tables/tuning variables
function Mission_SetDifficulty(diffVal)
	--TODO: Define any difficulty-related settings or variables.
	-- These variables should be stored in a t_difficulty table for readability and access.
	
	g_difficulty = diffVal or Game_GetSPDifficulty() 	-- Note: Having the diffVal parameter allows for redefining difficulty settings during runtime.
	AI_OverrideDifficulty(g_difficulty)
	
	--Global difficulty table
	t_difficulty = {
		capture_spawn_delay = Util_DifVar({3*60, 2*60, 1.5*60}, g_difficulty),
		startFuel = Util_DifVar({40, 30, 20}, g_difficulty),					-- Starting Fuel
		startManpower = Util_DifVar({500, 400, 300}, g_difficulty),			-- Starting Manpower
		startMunition = Util_DifVar({60, 40, 20}, g_difficulty),					-- Starting Munitions
	}
	
	Player_SetResource(player1, RT_Fuel, t_difficulty.startFuel)
	Player_SetResource(player1, RT_Manpower, t_difficulty.startManpower)
	Player_SetResource(player1, RT_Munition, t_difficulty.startMunition)
	
--~ 	PM_AI_Aggression = true
--~ 	PM_PL_StartingResourceHit = true
--~ 	PM_AI_BaseDefenses = true
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
	
	Cmd_Upgrade(player1,  BP_GetUpgradeBlueprint("tanks_out_of_fuel"), nil, true)
	Cmd_Upgrade(player2,  BP_GetUpgradeBlueprint("tanks_out_of_fuel"), nil, true)
	
	-- Select Spawns
	SelectSpawns()
	
	-- Select Vehicles
	SelectTanks()
	
	-- Spawn Vehicles and Abandon them
	SpawnTanks()
	
	-- turn on VP bar and set tooltips, etc
	WinWarning_SetToolTip(0, 11079354, 11079355, "Icons_resources_flag_victory")
	WinWarning_SetToolTip(1, 11079356, 11079357, "Icons_resources_flag_victory")
	WinWarning_ScoreDisplayIconsClear()
	WinWarning_ScoreDisplayIconAdd("Icons_symbols_vehicle_aef_m4a3e8_sherman_symbol", 255, 255, 255, 0, 11076697, 11079678, "Icons_resources_flag_victory")
	WinWarning_ScoreDisplayIconAdd("Icons_symbols_aef_aim_destroy", 255, 255, 255, 0, 11076697, 11079678, "Icons_resources_flag_victory")
	
end


-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
--Called once the intro nis/nislet/sitrep finishes playing.
function Mission_Start()	

	AI_SetPersonality(player2, "botb_skirmish_tank_grab")

	-- remove victory point behaviour
	Rule_RemoveIfExist(VPTicker_UpdateTickers)
	Rule_RemoveIfExist(VPTicker_MainRule)
  
	-- Start Objectives
	Objective_Start(OBJ_Victory)
	Objective_Start(SOBJ_VictoryPoints, false)
	
	-- spawn base defenses
	Enemy_Base_Defense()
	
	-- start checking when to spawn the enemy capture teams
	Rule_AddDelayedInterval(EnemyCaptureAlert, t_difficulty.capture_spawn_delay, 5)
	-- grant veterancy to all units the ai produces based on node strength
	Rule_AddInterval(GrantEnemyVeterancy, 1)
	-- start checking for new tanks so that we can force them to abandon when they die
	Rule_AddInterval(TankManager, 0.1)
	Rule_AddInterval(AddAbandonedTanks, 0.5)
	-- start checking whenever a tank kills something
	Rule_AddGlobalEvent(UnitWasKilled, GE_EntityKilled)
	Rule_AddInterval(FirstTankSpotted, 1.0)
	
	
	--Heavy Tank call in group-----------------------------------
--~ 	Rule_AddInterval(Tank_Attack_1, 1)
	
	
	NodeUnitRestrictions1() ----restricts certain ai units at different node strengths
	
	TankSupport() ---calls in specific tanks for ai on different node strengths
	
	
	if g_difficulty == GD_HARD then
	
		Rule_AddOneShot(HardElements0, 30)
		Rule_AddOneShot(HardElements1, 300)
		Rule_AddOneShot(HardElements2, 600)
		Rule_AddOneShot(HardElements3, 900)

	end
	

end

-- adds extra units to the table of encounters to spawn based on node strength
function ChooseIntents()
	
	if XP1_GetNodeStrength() >= 2 then
		table.insert(t_intents, ENC_INTENT.scoutForce)
	end
	
	if XP1_GetNodeStrength() >= 3 then
		table.insert(t_intents, ENC_INTENT.basicHMG)
	end
	
	if XP1_GetNodeStrength() >= 4 then
		table.insert(t_intents, ENC_INTENT.smallAntiInfantryDefense)
		table.insert(t_intents, ENC_INTENT.smallAntiTankDefense)
	end
	
	if XP1_GetNodeStrength() >= 5 then
		table.insert(t_intents, ENC_INTENT.medAntiInfantryDefense)
	end
end



-- objective functions -----------------------





-- Tank functions --------------------------------------------------

-- Select spawns
-- called by Mission_Preset
function SelectSpawns()
	local nodeStrength = XP1_GetNodeStrength()
	
	t_spawns = Marker_GetTable("mkr_tankGrab_node"..nodeStrength.."_%02d")
	
	g_totalVehicles = table.getn(t_spawns)
	
end

-- selects what tanks to spawn
-- called by Mission_Preset
function SelectTanks()
	local tier1 = {
		{
			sbp = BP_GetSquadBlueprint("m8_greyhound_squad_mp"),
			ebp = BP_GetEntityBlueprint("m8_greyhound_mp"),
		},
		{
			sbp = BP_GetSquadBlueprint("armored_car_sdkfz_234_squad_mp"),
			ebp = BP_GetEntityBlueprint("puma_sdkfz_234_mp"),
		},
		{
			sbp = BP_GetSquadBlueprint("m5a1_stuart_squad_mp"),
			ebp = BP_GetEntityBlueprint("m5a1_stuart_mp"),
		},
	}
	local tier2 = {
		{
			sbp = BP_GetSquadBlueprint("m5a1_stuart_squad_mp"),
			ebp = BP_GetEntityBlueprint("m5a1_stuart_mp"),
		},
		{
			sbp = SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP,
			ebp = EBP.WEST_GERMAN.HALFTRACK_SDKFZ_251_17_FLAK_MP,
		},
		{
			sbp = BP_GetSquadBlueprint("panzer_ii_luchs_squad_mp"),
			ebp = BP_GetEntityBlueprint("panzer_ii_luchs_sdkfz_123_mp"),
		},
	}
	local tier3 = {
		{
			sbp = BP_GetSquadBlueprint("m4a3_sherman_squad_mp"),
			ebp = BP_GetEntityBlueprint("m4a3_sherman_mp"),
		},
		{
			sbp = SBP.WEST_GERMAN.PANZER_IV_AUSF_J_BATTLE_GROUP_MP,
			ebp = EBP.WEST_GERMAN.PANZER_IV_SDKFZ_AUSF_J_MP,
		},
		{
			sbp = SBP.WEST_GERMAN.OSTWIND_SQUAD_WESTGERMAN_MP,
			ebp = EBP.WEST_GERMAN.OSTWIND_FLAK_PANZER_WEST_GERMAN_MP,
		},
	}

	--rearranged number and position and tiers.
	t_vehicles[1] = Table_GetRandomItem(tier1)
	t_vehicles[2] = Table_GetRandomItem(tier2)
	t_vehicles[3] = Table_GetRandomItem(tier3)
	t_vehicles[4] = Table_GetRandomItem(tier2)
	t_vehicles[5] = Table_GetRandomItem(tier1)

end

function SpawnTanks()
	for i = 1, table.getn(t_spawns) do
		print("Spawning")

		local eg = EGroup_Create("")
		local spawn = Entity_CalculatePassableSpawnPosition(t_vehicles[i].ebp, Util_GetRandomPosition(t_spawns[i]))
		local t = {}
	
		Util_CreateEntities(nil, eg, t_vehicles[i].ebp, spawn, 1, t_spawns[i])

		-- set health and invulnerability
		EGroup_SetAvgHealth(eg, 0.3)
		EGroup_SetInvulnerable(eg, 0.3, 0)
		
		-- Apply Crits
		Cmd_CriticalHit(player2, eg, CRIT.VEHICLE_DESTROY_ENGINE, 1.0)
		Cmd_CriticalHit(player2, eg, CRIT.VEHICLE_TANK_GRAB_ABANDON_SP, 0.5)	
		EGroup_Destroy(eg)		
	end
	
	-- need to be delayed a few seconds due to the nature of the vehicles losing fuel 
	-- stuff happens that makes the vehicle not be a world entity until a couple of seconds later, and it drifts to a stop
	Rule_AddOneShot(DealWithTanks, 5) 
	
end

-- despawns the crews of the abandoned vehicles
function DespawnCrews()
	SGroup_Clear(sg_temp)
	
	Player_GetAll(player2, sg_temp)
	SGroup_Filter(sg_temp, SBP.WEST_GERMAN.ABANDON_VEHICLE_CREW_SQUAD, FILTER_KEEP)
	SGroup_DeSpawn(sg_temp)

end

-- adds hintpoints to the spawned tanks
-- called once 
function DealWithTanks()
	for i = 1, table.getn(t_spawns) do
		local t = {}
		local spawn = t_spawns[i]
		t.eg = EGroup_CreateIfNotFound("eg_wreck_"..g_index)
		g_index = g_index + 1
		World_GetNeutralEntitiesNearMarker(t.eg, spawn)
		EGroup_Filter(t.eg, t_vehicles[i].ebp, FILTER_KEEP)
		
		t.blipID = {}
		t.hintID = {}
--~ 		t.blipID[1] = UI_CreateMinimapBlip(t_spawns[i], -1, BT_General)
		t.hintID[1] = HintPoint_Add(t.eg, true, 11075442, 3, nil, nil, nil, false)	-- LOCDB [11075442] 'Refuel for 50 Fuel'
		
--~ 		print("***************************** ADD HINT ***********************************")
		table.insert(t_wrecks, t)
	end
	Rule_AddInterval(ManageWreckBlips, 1)
	
end


-- checks when the player first sees a tank and plays an event
function FirstTankSpotted()
	for i = 1, table.getn(t_wrecks) do
			
		if Player_CanSeeEGroup(player1, t_wrecks[i].eg, ANY) then
			Util_StartIntel(EVENTS.FirstTankSpotted)
			Rule_RemoveMe()
			break
		end
	end
end


-- handles the removal of the hintpoints on tank wrecks
-- called by a rule in DealWithTanks
function ManageWreckBlips()

	for k,v in pairs(t_wrecks) do
		if World_OwnsEGroup(v.eg, ANY) == false then
			
			-- check to see if player captured a wreck
			if Player_OwnsEGroup(player1, v.eg, ANY) then
				g_playerCapture = g_playerCapture + 1
			end
			
			-- remove hints on non-neutral tanks
			for i = 1, table.getn(v.hintID) do
				HintPoint_Remove(v.hintID[i])
--~ 				print("**************** REMOVING ARROW ************************")
			end

			EGroup_Clear(v.eg)
			table.remove(t_wrecks, k)
		end
	end
end




-- Enemy tank refuel team functions -------------------------------------------------


-- plays an alert about the  enemy attempting to capture a wreck
-- after a delay it calls EnemyCaptureSoldiersSpawn
function EnemyCaptureAlert()

		
	if flag_are_germans_capturing_tank == false and table.getn(t_wrecks) > 0 then
		-- we will restart the rule later
		Rule_RemoveMe()
		
		flag_are_germans_capturing_tank = true
		g_target_tank_group = t_wrecks[ World_GetRand(1, table.getn(t_wrecks)) ].eg	-- pick a random wreck
		local entityID = EGroup_GetSpawnedEntityAt(g_target_tank_group, 1)
		g_target_world_id = Entity_GetGameID(entityID)
		
		-- play alert speech and ping the location of the tank
		Util_StartIntel(EVENTS.EnemyCapturing)
		g_capture_ping_id = UI_CreateMinimapBlip(g_target_tank_group, 40.0, BT_AttackHere)
		
		-- spawn the capture squads after a delay
		Rule_AddOneShot(EnemyCaptureSoldiersSpawn, 15.0)
		
	end
end

-- spawns the capture teams
function EnemyCaptureSoldiersSpawn()
	
	-- if there are no wrecks left to capture or the target tank was destroyed, then stop spawning
	if table.getn(t_wrecks) < 1 or EGroup_IsEmpty(g_target_tank_group) then
	
		Rule_RemoveMe()
		flag_are_germans_capturing_tank = false
		Rule_AddDelayedInterval(EnemyCaptureAlert, t_difficulty.capture_spawn_delay, 5)
		
	-- time to spawn soldiers to capture a wreck
	else
		-- we will restart the rule later
		Rule_RemoveMe()
		
		-- spawn capture team 
		Util_CreateSquads(player2, {sg_captureTeam1_Capture, sg_captureTeam_All}, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_captureEntryPoint)
--~ 		Util_CreateSquads(player2, {sg_captureTeam1_Repair, sg_captureTeam_All}, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_captureEntryPoint)
		AI_LockSquads(player2, sg_captureTeam_All)

		-- spawn encounter of troops to escort the capture team
		ENCOUNTERS.capture_encounter(g_target_tank_group)
		
		-- if this is not the first time we're spawning them, add more possible encounters
		if flag_first_capture_attempt_spawned == false then
			flag_first_capture_attempt_spawned = true
			ChooseIntents()
		end
		
		-- start managing behavior of the squads
		Rule_AddInterval(EnemyCaptureSoldiersManager, 2)	
--~ 		Rule_AddOneShot(GoCapture, 2)	
		
	end
end

-- After a delay tell the capture teams to go get the tank (necessary to avoid a bug where they would just sit there and do nothing)
-- called by EnemyCaptureSoldiersSpawn
function GoCapture()
	if SGroup_IsAlive(sg_captureTeam1_Capture) then
		Cmd_Ability(sg_captureTeam1_Capture, ABILITY.WEST_GERMAN.REFUEL_TANK_WG_SP, g_target_tank_group, nil, nil, true)
--~ 		Cmd_Ability(sg_captureTeam1_Repair, ABILITY.WEST_GERMAN.WEST_GERMAN_REPAIR_ABILITY_MP, g_target_tank_group, nil, nil, true)
	end
end

-- tells the capture teams to recrew and repair the tank wrecks
-- responsible for resetting the rule for spawning another capture team and removing the pings
function EnemyCaptureSoldiersManager()
	
	
	if SGroup_IsAlive(sg_captureTeam_All) then
		
		-- check whether to give these units to ai control
		-- conditions to give the capture team to ai:
		--		- the target tank is gone (either somebody captured it or it died)
		--		- the sgroup responsible for capturing the tank is dead
		if Player_OwnsEGroup(player2, g_target_tank_group) or Player_OwnsEGroup(player1, g_target_tank_group) or EGroup_IsEmpty(g_target_tank_group) or SGroup_IsAlive(sg_captureTeam1_Capture) == false or SGroup_TotalMembersCount(sg_captureTeam1_Capture, false) < 3 then
			
			flag_are_germans_capturing_tank = false
			
			-- give units to ai, remove the minimap blip and restart the rule to spawn another capture team
			UnlockCaptureTeams()
			Rule_AddDelayedInterval(EnemyCaptureAlert, t_difficulty.capture_spawn_delay, 5)
			UI_DeleteMinimapBlip(g_capture_ping_id)
			
			-- play a message that the germans captured a tank
			if Entity_IsValid(g_target_world_id) then
				if Player_OwnsEntity(player2, Entity_FromWorldID(g_target_world_id)) then
					Util_StartIntel(EVENTS.EnemyCapturedTank)
					print (" ** ENEMY CAPTURED TANK **")
				end
			end
			
			Rule_RemoveMe()
		else	
			-- keep telling the capture team to refuel the vehicle
			GoCapture()
		end
		
	-- player killed the capture squads, so reset the timer for the next capture attempt
	else
		flag_are_germans_capturing_tank = false
		Rule_AddDelayedInterval(EnemyCaptureAlert, t_difficulty.capture_spawn_delay, 5)
		UI_DeleteMinimapBlip(g_capture_ping_id)
		Rule_RemoveMe()
		print("** CAPTURE TEAM WAS KILLED **")
	end
end

-- returns the capture team units to the ai's control after a capture
function UnlockCaptureTeams()
	if SGroup_IsAlive(sg_captureTeam_All) then
--~ 		print("*****************UNLOCKING SQUADS********************")
	
		AI_UnlockSquads(player2, sg_captureTeam_All)

		SGroup_Clear(sg_captureTeam_All)
		SGroup_Clear(sg_captureTeam1_Capture)
		SGroup_Clear(sg_captureTeam1_Repair)
	end
	
	-- retreat the encounter squads
	if SGroup_IsAlive(sg_capture_encounter) then
		Rule_AddOneShot(RetreatEncounter, 25)
	end
end

-- retreats the encounter and despawns them
function RetreatEncounter()
	Cmd_Retreat(sg_capture_encounter, mkr_captureEntryPoint, mkr_captureEntryPoint)
end



-- Abandon Vehicle Functions ------------------------------------------------------------------------------------

-- handles the invulnerability of tanks and abandoning of them when they're low in health.
-- called by rule at start
function TankManager()

	GrabAllPlayerTanks()
	SGroup_ForEach(sg_alltanks, AbandonHurtTanks)
end

-- whenever a tank gets low in health, abandon it
-- called by TankManager
function AbandonHurtTanks(gid, idx, sid)
	-- if the tank is low, abandon it
	if Squad_GetHealthPercentage(sid) <= 0.11 then
--~ 		print("************ ABANDON VEHICLE *******************")
		
		-- store the id of the tank so we exclude it from the manager
		local entityID = Squad_EntityAt(sid, 0)
		local entityWorldID = Entity_GetGameID(entityID)
		local player = Squad_GetPlayerOwner(sid)
		local killer = nil
		
		-- get last attacker
		SGroup_Clear(sg_temp)
		Squad_GetLastAttacker(sid, sg_temp)
		
		if SGroup_IsEmpty(sg_temp) == false then
			killer = SGroup_GetSpawnedSquadAt(sg_temp, 1)
		end
		
		if killer ~= nil then
			local blueprint = Squad_GetBlueprint(killer)
			
			-- check if killer was a tank, and if it is then deduct victory points
			if Table_Contains(t_tanklist, blueprint) then
				AdjustPoints(entityID)
			end
		end
		
		if table.getn(t_wrecks) == 0 or World_GetRand(1 , 100) <= g_abandon_chance then
			-- now set its health higher and make it invulnerable at that threshold so that you don't get abandoned again when you capture it
			Squad_SetHealth(sid, 0.3)
			Squad_SetInvulnerable(sid, 0.3, 0)
			Cmd_CriticalHit(player, sid, CRIT.VEHICLE_TANK_GRAB_ABANDON_SP, 0.5)
			
			-- now add the decrewed tank to the list of newly abandoned tanks so that the function AddAbandonedTanks can add it to t_wrecks
			table.insert(t_abandoned_tank_ids, entityWorldID)
		
		-- otherwise kill it
		else
			
			Squad_Kill(sid)
		end
		
	else
		-- otherwise the tank isn't hurt so it should be invulnerable to a low health threshold
		Squad_SetInvulnerable(sid, 0.1, 0)
	end
end

-- takes any newly abandoned vehicles and adds them to t_wrecks
-- this function is necessary because you can't add a newly abandoned tank to an egroup in the same frame as when it's decrewed
-- called by a rule at start of mission
function AddAbandonedTanks()
	
	if table.getn(t_abandoned_tank_ids) > 0 then
	
		for i = table.getn(t_abandoned_tank_ids), 1, -1 do
		
			local entityWorldID = t_abandoned_tank_ids[i]
			
			-- if this tank is abandoned, add it to the list of wrecks
			if Entity_IsValid(entityWorldID) then
					
				local entityID = Entity_FromWorldID(entityWorldID)
				
				if Entity_IsPartOfSquad(entityID) == false then
					local t = {}
					local index = table.getn(t_wrecks) + 1
					
					t.eg = EGroup_CreateIfNotFound("eg_abandoned_"..g_index)
					g_index = g_index + 1
					EGroup_Add(t.eg, entityID)		
					t.blipID = {}
					t.hintID = {}
					t.hintID[1] = HintPoint_Add(t.eg, true, 11075442, 2, nil, nil, nil, false) -- LOCDB [11075442] 'Refuel for 50 Fuel'
--~ 					print("***************************** ADD HINT ***********************************")
					
					table.insert(t_wrecks, t)
					table.remove(t_abandoned_tank_ids, i)
				end
			else
				table.remove(t_abandoned_tank_ids, i)
			end
		end
	end
end

-- gets all the tanks owned by players and filters them for tanks that have already been used
function GrabAllPlayerTanks()
	
	-- get all the tanks and filter them for tanks we've already marked
	Player_GetAll(player1, sg_player1_tanks, eg_player1_tanks)
	Player_GetAll(player2, sg_player2_tanks, eg_player2_tanks)
	SGroup_AddGroup(sg_alltanks, sg_player1_tanks)
	SGroup_AddGroup(sg_alltanks, sg_player2_tanks)
	SGroup_Filter(sg_alltanks, t_tanklist, FILTER_KEEP)
	-- filter out abandoned tanks (necessary because the out of fuel critical takes time to abandon the tank and during that time it's possible to accidentally reset its invulnerability)
	SGroup_ForEach(sg_alltanks, FilterExcludedTanks)
	
end

-- removes any tanks that are on the exclude list from the group
function FilterExcludedTanks(gid, idx, sid)
	
	if Squad_Count(sid) >= 1 then
		
		local entityID = Squad_EntityAt(sid, 0)
		local entityWorldID = Entity_GetGameID(entityID)
		
		if Table_Contains(t_abandoned_tank_ids, entityWorldID) then
			SGroup_Remove(gid, sid)
		end
	end
end



-- Utility Functions -----------------------------------------------------------------------------------------------------------


-- add veterancy based on node strength
function RandomVeterancy(group, index, squadid)

	if SGroup_ContainsSquad(sg_already_vet, Squad_GetGameID(squadid)) == false then
		
		if Squad_GetVeterancyRank(squadid) == 0 then
			Squad_IncreaseVeterancyRank(squadid, XP1_GetNodeStrengthVeterancy(), true)
		end
		
		-- add to list of already vet units so they don't get veterancy again
		SGroup_Add(sg_already_vet, squadid)
	end
end

-- increase veterancy for units produced by ai player
function GrantEnemyVeterancy(sgroup, index, squad)
	SGroup_Clear("sg_temp")
	Player_GetAll(player2, sg_temp)
	SGroup_ForEach(sg_temp, RandomVeterancy)
end


-- reduces VPs of either team when a vehicle makes a kill
function UnitWasKilled(victim, killer)

	if World_OwnsEntity(victim) == false and killer ~= nil then
		local killer_squad = Entity_GetSquad(killer)
		local victim_squad = Entity_GetSquad(victim)

		if killer_squad ~= nil then
			local blueprint = Squad_GetBlueprint(killer_squad)
			
			-- check if killer was a tank, and if it is then deduct victory points
			if Table_Contains(t_tanklist, blueprint) then
				AdjustPoints(victim)
			end
			
			
		end
		
		-- play a message if this is the first time a player lost a vehicle
		if Player_OwnsEntity(player1, victim) then
			if Entity_IsVehicle(victim) and g_player_tank_already_killed == false then
				g_player_tank_already_killed = true
				Util_StartIntel(EVENTS.FirstGermanKill)
			end
		end
	end
end


-- reduces player victory points by a value based on whether the victim was a tank or not
-- victim_entity: the entity that was killed
function AdjustPoints(victim_entity)
	if victim_entity ~= nil then
		local victim_squad = Entity_GetSquad(victim_entity)
		local player_vps = VPTicker_GetTeamTickers(Player_GetTeam(player1))
		local enemy_vps = VPTicker_GetTeamTickers(Player_GetTeam(player2))
		local point_deduction = g_point_deduction
		
		
		-- if a vehicle died, then we will use a different victory point deduction
		if victim_squad ~= nil and Table_Contains(t_tanklist, Squad_GetBlueprint(victim_squad)) == true then
			point_deduction = g_point_deduction_vehicles
		end
		
		local pos = Util_GetPosition(victim_entity)
		pos.y = pos.y + 3
		
		-- reduce VPs for the player who lost the unit
		if Entity_GetPlayerOwner(victim_entity) == player2 then
			enemy_vps = enemy_vps - point_deduction
			VPTicker_SetTeamTickers(Player_GetTeam(player2), math.max(enemy_vps, 0), true)
			WinWarning_SetTickers(math.max(player_vps, 0), math.max(enemy_vps, 0))
			local kicker_text = Loc_FormatText(11079485, Loc_ConvertNumber(point_deduction))
			UI_CreateColouredPositionKickerMessage(player1, pos, kicker_text, 255, 0, 0, 0)
			-- play a message if this is the first time the player got a kill
			if g_first_player_kill == false then
				g_first_player_kill = true
				Util_StartIntel(EVENTS.FirstPlayerKill)
			end
		else
			player_vps = player_vps - point_deduction
			VPTicker_SetTeamTickers(Player_GetTeam(player1), math.max(player_vps, 0), true)
			WinWarning_SetTickers(math.max(player_vps, 0), math.max(enemy_vps, 0))
			local kicker_text = Loc_FormatText(11079484, Loc_ConvertNumber(point_deduction))
			UI_CreateColouredPositionKickerMessage(player1, pos, kicker_text, 80, 140, 200, 0)
		end
		
		print("Deducting "..point_deduction)
		
		-- update player success rating
		if VPTicker_GetTeamTickers(Player_GetTeam(player1)) <= 0 or VPTicker_GetTeamTickers(Player_GetTeam(player2)) <= 0 then
			CalculateMissionScore()
		end
	else
		print("ADJUST POINTS GOT NIL")
	end
end




-- spawn some defenses at the enemy base so that the player doesn't immediately overwhelm the ai with captured vehicles
function Enemy_Base_Defense()
	local Base_Defense_EncounterData = {
		name = "Base Defense Encounter 01",
		player = player2,
		sgroups = {sg_enemyBaseDef},
		units = {
			{
				sbp = Util_DifVar( { SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP} ),
				spawn = mkr_tankGrabEnemyBaseDef_1,
			},
			{
				sbp = Util_DifVar( { SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP} ),
				spawn = mkr_tankGrabEnemyBaseDef_2,
			},
		},
		onDeath = nil,
	}
	local Base_Defense_AttackData = {
		name = "Defend",
		target = mkr_tankGrabEnemyBaseArea,
		leashRange = 25,
		range = 45,
		attackMove = true,
		useSkirmishAI = true,
		tacticControlsList = {

		},
	}
	encID_Base_Defense = XP1_EncounterCreate(Base_Defense_EncounterData)
	encID_Base_Defense:SetGoal(Base_Defense_AttackData)
end



-- calculates final mission score
function CalculateMissionScore()
	
	if World_GetGameTime() <= 14*60 then
		XP1_SetMissionSuccessLevel(3)
	elseif World_GetGameTime() <= 18*60 then
		XP1_SetMissionSuccessLevel(2)
	else
		XP1_SetMissionSuccessLevel(1)
	end
	
--~ 	print("***** SUCCESS LEVEL *****")
--~ 	print(XP1_GetMissionSuccessLevel())

end



------------------------------------------------------------------------------------------------------------------Random Heavy Tank Call In for Node Strength 4/5---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Tank_Attack_1()
	if VPTicker_GetTeamTickers(1) <= 100 then
		if XP1_GetNodeStrength() >= 4 then
			Spawn_T1()
			Rule_RemoveMe()
		end
	end
end

function Spawn_T1()

	local potential_units =
	{	
		SBP.WEST_GERMAN.PANTHER_COMMANDER_SQUAD_MP,
		SBP.WEST_GERMAN.PANTHER_AUSF_G_SQUAD_MP,
		SBP.WEST_GERMAN.STURMTIGER_SQUAD_MP,
		SBP.WEST_GERMAN.KING_TIGER_SQUAD_MP,
		SBP.WEST_GERMAN.JAGDTIGER_TD_SQUAD_MP,
	}
	
	local choice = Table_GetRandomItem(potential_units)
	
	Util_CreateSquads(player2, sg_e_all, choice, mkr_reverseHardpoint_point1)

end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------Unit Restrictions on Node Strengths and other node strength elements---------------------------------------------

function NodeUnitRestrictions1()

	if XP1_GetNodeStrength() == 1 then
	
	
	------disabled infantry----

	Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, ITEM_LOCKED)
	Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.LE_IG_18_INF_SUPPORT_GUN_SQUAD_MP, ITEM_LOCKED)
	Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, ITEM_LOCKED)
	Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, ITEM_LOCKED)
	Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, ITEM_LOCKED)
		
	----disabled armor----
		
	Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.KING_TIGER_SQUAD_MP, ITEM_LOCKED)
	Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.PANTHER_AUSF_G_SQUAD_MP, ITEM_LOCKED)
	Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.STURMTIGER_SQUAD_MP, ITEM_LOCKED)
	Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.JAGDTIGER_TD_SQUAD_MP, ITEM_LOCKED)
		
	----disabled base buildings----
	
	Player_SetAbilityAvailability(player2, ABILITY.WEST_GERMAN.CONSTRUCT_ARMORED_INFANTRY_COMMAND, ITEM_LOCKED)
		
	----disabled unit abilities----
	
	Player_SetAbilityAvailability(player2, ABILITY.WEST_GERMAN.VOLKSGRENADIER_GRENADE_MP, ITEM_LOCKED)
	
		
	elseif XP1_GetNodeStrength() == 2 then
		
	------disabled infantry----

		
	Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, ITEM_LOCKED)
	Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, ITEM_LOCKED)
	Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, ITEM_LOCKED)
			
	----disabled armor----

	Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.KING_TIGER_SQUAD_MP, ITEM_LOCKED)
	Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.STURMTIGER_SQUAD_MP, ITEM_LOCKED)
	Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.JAGDTIGER_TD_SQUAD_MP, ITEM_LOCKED)

	elseif XP1_GetNodeStrength() == 4 then
		
	elseif XP1_GetNodeStrength() == 5 then
		
		
	end
end


-------------------------------------------------random bunker placement function------------------------------

function RandomBunker()

		local potential_markers =
		{	
		mkr_bunker_1,
		mkr_bunker_2,
		mkr_bunker_3,
		mkr_bunker_4,
		}
	
		local choice = Table_GetRandomItem(potential_markers, 2)
	
		for index, marker in pairs(choice) do
			Util_CreateEntities(player2, eg_mines, EBP.GERMAN.AXIS_BUNKER_STARTING_POSITION_MP, marker,  1)
		end
		
	end


----------------------------function that creates a howitzer for node strength 5---------------------------
	
function CreateHowy()

	Util_CreateSquads(player2, sg_e_all, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY_MP, mkr_arty)


end


--------------------------------------specific tank support for different node strengths----------------------------------------------


function TankSupport()

	if XP1_GetNodeStrength() >= 2 then
	
	Rule_AddInterval(CreateMortarHT, 430)
		
	Rule_AddInterval(CreateLightSupport, 500)
	
	Rule_AddInterval(CreateJadtiger,600 )

	Rule_AddInterval(CreateTigerAce, 700)

	end
end



function CreateMortarHT()

	Util_CreateSquads(player2, sg_e_all, SBP.GERMAN.MORTAR_250_HALFTRACK_SQUAD_MP, mkr_reverseHardpoint_point1)

end
	
	
function CreateLightSupport()

	if XP1_GetNodeStrength() == 3 then		
		Spawn_T1()

	end
end

function Spawn_T1()

	local potential_units =
	{	
		
		{sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP},
		{sbp = SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP},
		{sbp = SBP.WEST_GERMAN.OSTWIND_SQUAD_WESTGERMAN_MP},
		
	}
	
	local choice = Table_GetRandomItem(potential_units)
	
	Util_CreateSquads(player2, sg_e_all, choice.sbp, mkr_reverseHardpoint_point1, nil, nil, nil, nil, nil, choice.upg)

end

function CreateJadtiger()

	if XP1_GetNodeStrength() == 4 then		
		Spawn_T1()

	end
end

function Spawn_T1()

	local potential_units =
	{	
		{sbp = SBP.WEST_GERMAN.OSTWIND_SQUAD_WESTGERMAN_MP},
		{sbp = SBP.WEST_GERMAN.PANTHER_COMMANDER_SQUAD_MP},
		{sbp = SBP.WEST_GERMAN.PANZER_IV_AUSF_J_BATTLE_GROUP_MP, upg = UPG.WEST_GERMAN.PANZER_IV_SIDE_SKIRTS_MP},
		
	}
	
	local choice = Table_GetRandomItem(potential_units)
	
	Util_CreateSquads(player2, sg_e_all, choice.sbp, mkr_reverseHardpoint_point1, nil, nil, nil, nil, nil, choice.upg)

end
	
function CreateTigerAce()
	
	if XP1_GetNodeStrength() == 5 then		
		Spawn_T1()

	end
end

function Spawn_T1()

	local potential_units =
	{	
		
		{sbp = SBP.WEST_GERMAN.KING_TIGER_SQUAD_MP},
		{sbp = SBP.WEST_GERMAN.JAGDTIGER_TD_SQUAD_MP},
		{sbp = SBP.GERMAN.TIGER_ACE_SQUAD_MP},
		{sbp = SBP.WEST_GERMAN.PANTHER_COMMANDER_SQUAD_MP},
	
		
	}
	
	local choice = Table_GetRandomItem(potential_units)
	
	Util_CreateSquads(player2, sg_e_all, choice.sbp, mkr_reverseHardpoint_point1, nil, nil, nil, nil, nil, choice.upg)

end

----last minute difficulty changes to make battle harder on hard---

function HardElements0()
	
	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, mkr_reverseHardpoint_point1)
	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_reverseHardpoint_point1)

end

function HardElements1()

	Player_AddResource(player2, RT_Manpower, 150)
	Player_AddResource(player2, RT_Fuel, 40)
	Player_AddResource(player2, RT_Munition, 60)
	
	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, mkr_reverseHardpoint_point1)
	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_reverseHardpoint_point1)

end

function HardElements2()

	Player_AddResource(player2, RT_Manpower, 200)
	Player_AddResource(player2, RT_Fuel, 60)
	Player_AddResource(player2, RT_Munition, 80)
	
	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.PANZER_IV_AUSF_J_BATTLE_GROUP_MP, mkr_reverseHardpoint_point1)
	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_reverseHardpoint_point1)

end

function HardElements3()

	Player_AddResource(player2, RT_Manpower, 100)
	Player_AddResource(player2, RT_Fuel, 40)
	Player_AddResource(player2, RT_Munition, 50)
	
	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.LE_IG_18_INF_SUPPORT_GUN_SQUAD_MP, mkr_reverseHardpoint_point1)

end
	-------------------------------------------------------------------------
-- [[ MISSION END ]]
-------------------------------------------------------------------------
--This function is called by the Win conditions scar file. 
--See .../scar/WinConditions/vpplusannihilate.scar or .../none.scar
function WinConditionEndCallback(winningTeam)
	if(Player_GetTeam(player1) == winningTeam) then
		if Objective_IsComplete(OBJ_Victory) == false then
			Objective_Complete(OBJ_Victory)
		end
	else
		if Objective_IsFailed(OBJ_Victory) == false then
			Objective_Fail(OBJ_Victory)
		end
	end
end
