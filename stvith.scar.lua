print("\tLoading mission file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- MISSION NAME
-- Designer: A.Molina
-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScriptSetup.scar") -- <== ### CRITICAL ELEMENT. 
import("XP1.scar")				-- Ardennes Assault functionality

-- [[ Objective files ]]
import("StVith_obj_stopCounterAttack.scar")
import("StVith_obj_jammers.scar")

-- [[ Encounter data ]]
import("StVith_encounters.scar")

import("WaveDefense_TEMP.scar") --TODO: This is only a temporary fix! This should be ported over to WaveManager at some point
--~ import("Libraries/TerritoryMonitor.scar")


-------------------------------------------------------------------------
-- [[ MISSION SETUP ]]
-------------------------------------------------------------------------
-- Initializes players
function Mission_SetupPlayers()
	--For Missions/Challenges:
	player1 = Setup_Player(1, 11073202, "aef", 1)		-- player1 is always the human player
	player2 = Setup_Player(2, 11073205, "west_german", 2)		-- player2 is always the AI opponent
	player3 = Setup_Player(3, 11073202, "aef", 1)		-- player3 is always the AI ally
end

-- Defines key mission data and any global values used throughout the mission.
function Mission_SetupVariables()
	print("Initializing mission DATA...")
	
	-- ### CRITICAL ELEMENT. This table contains all the initialization data for the mission.
	g_missionData = {
		useBeginnerHints = false,					-- Wether or not to use the BeginnerHint system
		useEncounterSystem = true,					-- Whether or not to use the Encounter system
		useXP1Difficulty = true,					-- Whether or not this mission uses the XP1 Difficulty system
		missionType = MT_XP1_CHALLENGE,				-- What Mission Type is this mission? MT_
		introNIS = "XP1/StVith_Intro",			 			-- Movie filename
		introNISlet = nil,					 		-- NISlet triggered after introNIS
		introNISletSkipped = nil,	 				-- Function called if the introNISlet is skipped
		introSitRep = nil,							-- Movie (string) to play after intro nislet
		endNISlet = nil,							-- NISlet triggered on mission completion
		endNIS = nil,								-- Movie (string) to play on mission completion
		missionSpeechPath = "botb/gameplay",					-- Speech path to cache (string)
		precacheSounds = {							-- Any audio files you want precached (list of strings)
--~ 			"streamed/music/missions/m02/m02_cue_start_defend_front_line",
		},
		nisFiles = {								-- .nis files associated with the mission (path string)
		},
		nisInTransitionTime = 0,
		nisOutTransitionTime = 0,
		objectives = {								-- List of PARENT objective tables.
			OBJ_StopCounterattack,					-- These are the global references to the objective tables defined in the separete files.
			OBJ_DestroyJammers,
		},
		startingUnits = {							-- Units to be spawned for P1 on mission start. Follows same parameters as Encounters.
			{
				sbp = SBP.AEF.RIFLEMEN_SQUAD_MP,
				spawn = Prox_GetRandomPosition(mkr_company_startUnit_spawn_01, 15, 5),
			},
			{
				sbp = SBP.AEF.RIFLEMEN_SQUAD_MP,
				spawn = Prox_GetRandomPosition(mkr_attackRail, 15, 5),
			},
			{
				sbp = SBP.AEF.DODGE_WC51_AMBULANCE_SQUAD_MP,
				spawn = mkr_attackRail,
			},
			{
				sbp = SBP.AEF.RIFLEMEN_SQUAD_MP,
				spawn = Prox_GetRandomPosition(mkr_attackRoad, 10, 5),
			},
		}
	}
	
	
	
	--[[GLOBAL VARIABLES]]
	
	g_mission_failed = false				-- flag that's checked to prevent spamming mission failure sequence
	
	-- node strength variables
	g_less_player_defenses = false		-- reduced player's defenses
	g_panzers = false							-- more tanks in the enemy waves
	g_king_tiger = false						-- spawn a king tiger
	
	-- set up the table for radio jammer spawns and destinations
	t_radioJammerLocs = Marker_GetSequence("mkr_jammerSpawn","")	--List of radio jammer spawn positions and corresponding locations
	for k,v in pairs(t_radioJammerLocs) do
		t_radioJammerLocs[k] = {
			spawn = v,
			dest = Marker_FromName("mkr_jammer" .. k, ""),
		}
	end
	
	--Matrix used to determine what intelEvent to play based on which two directions the enemies are coming from.
	t_intelMatrix = {
		{1-1, 					EVENTS.HintChurchRail, EVENTS.HintChurchRoad},
		{EVENTS.HintChurchRail, 2-2					, EVENTS.HintRailRoad},
		{EVENTS.HintChurchRoad, EVENTS.HintRailRoad, 3-3},
	}
	
	-- Intel warnings for individual points
	t_intelSingle = {
		EVENTS.HintChurch,
		EVENTS.HintRail,
		EVENTS.HintRoad,
	}
	
	sg_finalHeavyTank = SGroup_CreateIfNotFound("sg_finalHeavyTank") -- sgroup used to detect final wave
	g_maxAttackDirs = 2				-- The maximum number of locations that can be attacked at a time.
	t_jammerEncounters = {}			-- List of Radio jammer encounters
	t_jammerDefenders = {}			-- List of Radio jammer defenders
	g_jammerActive = false			-- True if jammers are currently present
	t_previousAttackDirs = false	-- List of attack directions used in wave(n-1)
	
	t_waveDelays = {}			-- Delay time between attack waves. Written in long-form for readability
		t_waveDelays[1] = 40
		t_waveDelays[2] = 40
		t_waveDelays[3] = 40
		t_waveDelays[4] = 50	--MiniBoss1
		t_waveDelays[5] = 40
		t_waveDelays[6] = 40
		t_waveDelays[7] = 5
	
	--[[MAP GROUPS]]
		-- eg_terrChurch
		-- eg_terrRailyard
		-- eg_terrCrossroad
end

-- Defines difficulty tables/tuning variables
function Mission_SetDifficulty(diffVal)
	-- These variables should be stored in a t_difficulty table for readability and access.
	
	g_difficulty = diffVal or Game_GetSPDifficulty()
	AI_OverrideDifficulty(g_difficulty)
	
	--Global difficulty table
	t_difficulty = {
--~ 		setupTime = 12,			--Debug
		setupTime = Util_DifVar({240, 180, 130}, g_difficulty),				--Intro time before waves start attacking.
		idleBeforeAttack = Util_DifVar({60, 35, 20}, g_difficulty),			-- maxIdleTime for waves before they move forward and attack the player's base
		numJammers = Util_DifVar({1, 1, 2}, g_difficulty),					-- Number of radio jammers that will spawn for the secondary objective
		nextWaveDelayMod = Util_DifVar({1.25, 1.0, 0.8}, g_difficulty),		-- Time between attack waves
		enemyRevealTime = Util_DifVar({22, 18, 12}, g_difficulty),			-- Time waves are revealed through FoW on wave start (if no jammers present)
		comebackTime = Util_DifVar({300, 240, 180}, g_difficulty),			-- Time for player to retake a lost territory before mission failure.
		startManpower = Util_DifVar({700, 600, 500}, g_difficulty),				-- Starting Manpower
		startMunition = Util_DifVar({200, 150, 100}, g_difficulty),				-- Starting Munitions
		startFuel = Util_DifVar({120, 90, 80}, g_difficulty),					-- Starting Fuel
	}
	
	
	--XP1 Dynamic Difficulty settings:
	PM_PL_StartingResourceHit = true
	PM_AI_Aggression = true
	PM_PL_Defenses = true
	
	-- NODE STRENGTH TUNING ------------------------------
	if XP1_GetNodeStrength() >= 3 then 
		g_less_player_defenses = true
	end
	
	if XP1_GetNodeStrength() >= 4 then 
		g_panzers = true
	end
	
	if XP1_GetNodeStrength() >= 5 then 
		g_king_tiger = true
	end
end

-- Sets restrictions on units, teams, etc.
function Mission_SetupRestrictions()
	--[[ HUMAN PLAYER ]]
	Player_AddAbility(player3, ABILITY.AEF.MAJOR_QUICK_RECON_RUN)
	Player_AddAbility(player3, BP_GetAbilityBlueprint("sp_quick_recon_run"))
--~ 	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.IS_2_HEAVY_TANK, ITEM_REMOVED)
	
	--[[ ALLIED PLAYER ]]
	
	--[[ ENEMY PLAYER ]]
	
end

-- Sets up the map before the mission starts (starting units, ownership, etc.)
function Mission_Preset()
	Player_SetResource(player1, RT_Manpower, t_difficulty.startManpower)
	Player_SetResource(player1, RT_Fuel, t_difficulty.startFuel)
	Player_SetResource(player1, RT_Munition, t_difficulty.startMunition)
	
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("aef_base_egroup"))
	
	FOW_PlayerExploreAll(player1)
	SetupWaveData()
	SetupWaveUnits()
	
	-- NODE STRENGTH: Despawn extra defenses
	if g_less_player_defenses == true then
		EGroup_DeSpawn(eg_extra_defenses)
		EGroup_DeSpawn(LAYER_player_defense_2)
		EGroup_DeSpawn(LAYER_player_defense_3)
		EGroup_DeSpawn(LAYER_player_defense_4)
	end
end


-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
--Called once the intro nis/nislet/sitrep finishes playing.
function Mission_Start()
	Objective_Start(OBJ_StopCounterattack)
end

--Wave data initialization.
function SetupWaveData()

	__t_waveDefenseData = {
		parentObj = OBJ_StopCounterattack,

		t_attackDirs = {			-- Contains all possible attack direction data. Each chunk is for a different direction
			{						-- spawn = The spawn point, dynSpawn = Dynamic spawn target, ui = location for hintpoints, target = target for goal
				{
					spawn = mkr_spawnChurch02,
					target = EGroup_GetPosition(eg_terrChurch),
					ui = mkr_ui_church,
				},
				{
					spawn = mkr_spawnChurch03,
					target = EGroup_GetPosition(eg_terrChurch),
					ui = mkr_ui_church,
				},
			},
			{
				{
					spawn = mkr_spawnRail01,
					target = EGroup_GetPosition(eg_terrRailyard),
					ui = mkr_ui_rail,
				},
				{
					spawn = mkr_spawnRail02,
					target = EGroup_GetPosition(eg_terrRailyard),
					ui = mkr_ui_rail,
				},
				{
					spawn = mkr_spawnRail03,
					target = EGroup_GetPosition(eg_terrRailyard),
					ui = mkr_ui_rail,
				},
			},
			{
				{
					spawn = mkr_spawnRoad01,
					target = EGroup_GetPosition(eg_terrCrossroad),
					ui = mkr_ui_road,
				},
				{
					spawn = mkr_spawnRoad02,
					rallyPoint = mkr_dynSpawnRoad02,
					target = EGroup_GetPosition(eg_terrCrossroad),
					ui = mkr_ui_road,
				},
				{
					spawn = mkr_spawnRoad03,
					target = EGroup_GetPosition(eg_terrCrossroad),
					ui = mkr_ui_road,
				},
			},
		},

		t_retreatDirs = {mkr_spawnChurch03, mkr_spawnRail02, mkr_spawnRoad02},

		waveCompleteCondition = {
			condition = CONDITION_UNITS_LEFT,
			variable = 15,	--This later gets changed to 8 after wave1
			wave_retreats = true,
			vehicle = 3,
		},
		
		-- Optional Data
		waveComplete_func = WaveCompleted, 
		
		warningLevel_data = {
			warningLevel = WARNING_NONE,
			warningLow = 11076629,		-- LOCDB [11076629] 'Incoming enemy forces'
			warningBlip = BT_DefendHere,
		},
		
		goalData = {				
			name = "Defend",
			--target is defined by the attackDirs[].target
			target = nil,
			range = 10,
			leashRange = 20,
			attackMove = true,
--~ 			coordinatedSetup = false,
--~ 			tacticControlsList = {
--~ 				{tacticType = TACTIC_RushAtTarget, priority = -1},
--~ 			},
			movePathLengthFactor = 1.0,
--~ 			safeMoveWeight = 0.0,
--~ 			maxIdleTime = -1,
		},
	}
end

function SetupWaveUnits()
	--This is called separatly so that the waves can reference and choose a unique starting position from t_attackDirs.
	
	__t_waveDefenseData.t_waves	= {
		
		ENCOUNTERS.Wave1(),
		ENCOUNTERS.Wave2(),
		ENCOUNTERS.Wave3(),
		ENCOUNTERS.Wave4MiniBoss(),
		ENCOUNTERS.Wave5(),
		ENCOUNTERS.Wave6(),
		ENCOUNTERS.Wave7(),
		
	}
end


--Wave steps
--Start the wave defense. Called from SOBJ_SetupDefenses.OnComplete()
function StartWaveDefense()
	
	ReconFlyBy()
	Rule_AddOneShot(RevealEnemies, 5.0)
	Util_StartIntel(EVENTS.StartWaves)
	Rule_AddDelayedInterval(UpdateEnemyForces, 4, 1)
	
	--No warning for wave-1
	WaveDefense_SelectSpawns()
	WaveDefense_SpawnWave()
end


--Callback when a wave is defeated.
function WaveCompleted()
	print("Wave " .. WaveDefense_GetWave() .. " completed.")
	
	if(WaveDefense_GetWave() == 1) then
		--Wave 1 dead. Inform it was just a scout.
		Event_Timer(EventHandler_StartIntel, {intel = EVENTS.ScoutWave}, 3)
		--Change the wave complete conditions so that they no longer retreat
		local newParams = {
			condition = CONDITION_UNITS_LEFT,
			variable = 7,
			wave_retreats = false,
			vehicle = 3,
		}
		WaveDefense_SetCompletionParameters(newParams)
	elseif(WaveDefense_GetWave() == 4) then
		--Wave 4 dead. Spawn jammers.
		SpawnJammers()
	elseif(WaveDefense_GetWave() == WaveDefense_GetTotalWaves()-1) then
		--SecondToLast wave dead. Set last wave to retreat
		local newParams = {
			condition = CONDITION_UNITS_LEFT,
			variable = 7,
			wave_retreats = true,
			vehicle = 3,
		}
		WaveDefense_SetCompletionParameters(newParams)
	end
	
	Rule_AddOneShot(SpawnNextWave, t_waveDelays[WaveDefense_GetWave()] * t_difficulty.nextWaveDelayMod)
end

--Spawns the next wave.
function SpawnNextWave()
	
	if(WaveDefense_GetWave() < WaveDefense_GetTotalWaves()) then
		WaveDefense_NextWave()
		print("Spawning wave #" .. WaveDefense_GetWave() .."...")
		WaveDefense_SelectSpawns()
		WaveDefense_SpawnWave()
		
		--Used to update progress bar
		g_maxLoadout = 0
		for k=1, SGroup_CountSpawned(WaveDefense_GetCommandSGroup()) do
			g_maxLoadout = g_maxLoadout + Squad_GetMax(SGroup_GetSpawnedSquadAt(WaveDefense_GetCommandSGroup(), k))
		end
		
		ReconFlyBy()
		Rule_AddOneShot(WarnNextWave, 4)
	else
		print("All waves defeated. Well done.")
		Objective_Complete(OBJ_StopCounterattack)
		
		Event_NarrativeEventsNotRunning(CompleteMission, nil, 2)
	end
end


--Warns incoming wave directions
function WarnNextWave()	
	print("Warning next wave...")
	if g_jammerActive then
		print("Jammers active...")
		Util_StartIntel(EVENTS.GarbledRadio)
	else
		-- Play warning intel event. Can be wave-custom, or else defined by incoming attack directions.
		if WaveDefense_GetWave() == 4 and g_panzers == true then 
			Util_StartIntel(EVENTS.WarnMiniBoss1)	--miniboss 1.
		else
			local dirs = Util_GetAttackDirections()
			if(#dirs > 2) then
				--Incoming from multiple directions
				Util_StartIntel(t_intelMatrix[dirs[1]][dirs[3]])
			else
				--Incoming from single direction
				Util_StartIntel(t_intelSingle[dirs[1]])
			end
		end
		--Blip positions
		WaveDefense_ShowWarnings()
		Rule_AddOneShot(WaveDefense_ClearWarnings, 8)
		Rule_AddOneShot(RevealEnemies, 2)
	end
	
	if WaveDefense_GetWave() == 7 then
		if g_king_tiger == true then
			Util_StartIntel(EVENTS.WarnKingTiger)
		end
		Event_ElementOnScreen(EventHandler_StartIntel, {intel = EVENTS.WarnFinalWave}, player1, sg_finalHeavyTank, ANY, 1)
	end
end


--Triggers a simple allied plane fly-by
function ReconFlyBy()
	if WaveDefense_GetWave()%2 == 1 then
		Cmd_Ability(player3, BP_GetAbilityBlueprint("sp_quick_recon_run"), Marker_GetPosition(mkr_dynSpawnChurch02), Marker_GetPosition(mkr_dynSpawnRoad02), true)
	else
		Cmd_Ability(player3, BP_GetAbilityBlueprint("sp_quick_recon_run"), Marker_GetPosition(mkr_dynSpawnRoad02), Marker_GetPosition(mkr_dynSpawnChurch02), true)
	end
end

--Reveals incomming enemies through FoW
function RevealEnemies()
	FOW_RevealSGroupOnly(WaveDefense_GetCommandSGroup(), t_difficulty.enemyRevealTime)
end



--Mission end
--Called if any of the points are lost
function FailMission(location)
	print("Mission failed!")
	if not Rule_Exists(Mission_Complete) and g_mission_failed == false then
		g_mission_failed = true
		Rule_RemoveAll()
		Event_RemoveAll()
		
		Util_StartIntel(EVENTS.MissionFail)
		Game_SetMode(UI_Fullscreen)
		Camera_MoveTo(location, true, 0.25)
		FOW_PlayerRevealAll(player1)
		
		Event_NarrativeEventsNotRunning(Mission_Fail, nil, 1.5)
--~ 		Rule_AddDelayedInterval(Mission_Fail, 3, 1)
	end
end

--Success
function CompleteMission()
	print("Mission complete!")
	if not Rule_Exists(Mission_Fail) then
		Rule_RemoveAll()
		Event_RemoveAll()
		
		--Success level. Determined by the number of times territories were lost.
		if(g_numTerrsLost == 0) then
			XP1_SetMissionSuccessLevel(XPT_MSL_GOLD)
		elseif(g_numTerrsLost == 1) then
			XP1_SetMissionSuccessLevel(XPT_MSL_SILVER)
		else
			XP1_SetMissionSuccessLevel(XPT_MSL_BRONZE)
		end
		
		Rule_AddInterval(Mission_Complete, 1)
	end
end





---------------------------------------------
-- Radio Jammers
---------------------------------------------
--Starts the Radio Jammer objective
function SpawnJammers()
	Objective_Start(OBJ_DestroyJammers)
	
	--Determine where to spawn/send jammers.
	local jammerPositions = Table_GetRandomItem(t_radioJammerLocs, t_difficulty.numJammers)
	
	if(t_difficulty.numJammers == 1) then
		SpawnJammer(jammerPositions.spawn, jammerPositions.dest)
	else
		for k,pos in pairs(jammerPositions) do
			SpawnJammer(pos.spawn, pos.dest)
		end
	end
end

-- Spawn a jammer+defenders and send it to a destination.
function SpawnJammer(spawn, destination)
	local enc_jammer = ENCOUNTERS.RadioJammer(spawn, destination)
	
	table.insert(t_jammerEncounters, enc_jammer)
	
	local enc_defender = ENCOUNTERS.JammerDefender(spawn, enc_jammer:GetSgroup())
	--Mark general destination area. Save it so we can remove it on death
	enc_jammer.data.objPing = Objective_AddPing(OBJ_DestroyJammers, Util_GetPosition(destination))
	table.insert(t_jammerDefenders, enc_defender)
	
	UI_CreateMinimapBlip(Util_GetPosition(destination), 8, BT_General)
	HintPoint_Add(enc_jammer:GetSgroup(), true, 11076630, nil, HPAT_Bonus)		-- LOCDB [11076630] 'Radio Jammer'
end

--Callback when radio jammer gets destroyed
function JammerDestroyed(enc)
	print("Jammer has been destroyed")
	Objective_RemovePing(OBJ_DestroyJammers, enc.data.objPing)
	Objective_IncreaseCounter(OBJ_DestroyJammers)
end











---------------------------------------------
-- Util Functions
---------------------------------------------

--Return item/table of unique potential spawn positions from the wave defense table.
-- It uses t_previousAttackDirs to ensure that future spawns use points that wave(n-1) didn't use.
function Util_GetUniqueRandomSpawns(num)
	--Grab INDICES for attack dirs and place them in a temp table
	local _possibleDirs = {}
	for k,v in pairs(__t_waveDefenseData.t_attackDirs) do
		table.insert(_possibleDirs, k)
	end
	
	local _newDirections = {}
	if t_previousAttackDirs ~= false then
		--Find all the items (attack directions) that were not used in the previous wave
		for k=1, #_possibleDirs do
		
			local _found = false
			for i=1, #t_previousAttackDirs do
				if _possibleDirs[k] == t_previousAttackDirs[i]  then
					_found = true
					break
				end
			end
			
			if not _found then
				table.insert(_newDirections, _possibleDirs[k])
			end	
		end
		
		--Pad the table with however many additional items are needed. At this point, repetition is ok.
		if(#_newDirections < num) then
			local _padding = Table_GetRandomItem(t_previousAttackDirs, num - #_newDirections)
			if scartype(_padding) == ST_TABLE then
				for k,v in pairs(_padding) do
					table.insert(_newDirections, v)
				end
			else
				table.insert(_newDirections, _padding)
			end
		end
	else
		--No previous bias. Return random positions
		_newDirections = Table_GetRandomItem(_possibleDirs, num)
	end
	
	t_previousAttackDirs = _newDirections
	return _newDirections
end

--Returns the attack directions indices for the current wave.
function Util_GetAttackDirections()
	local dirs = {}
	for k,v in pairs(__t_waveDefenseData.t_waves[WaveDefense_GetWave()].encounters) do
		table.insert(dirs, v.direction)
	end
	
	return dirs
end

--Returns the attack directions indices for the current wave.
local function Util_GetAttackDirections()
	local dirs = {}
	for k,v in pairs(__t_waveDefenseData.t_waves[WaveDefense_GetWave()].encounters) do
		table.insert(dirs, v.direction)
	end
	
	return dirs
end



---------------------------------------------
-- Debug Functions
---------------------------------------------
--Test a specific wave
function testWave(num)
	if Misc_IsCommandLineOptionSet("dev") then
		Rule_Remove(UpdateEnemyForces)
		ReconFlyBy()
		SetupWaveUnits()
		WaveDefense_SetWave(num-1)
--~ 		WaveDefense_SelectSpawns()
--~ 		WaveDefense_SpawnWave()	
		SpawnNextWave()
	end
end

function cancelWave()
	Event_RemoveAll()
	Util_Kill(player2)
end

function resetWave()
	if Misc_IsCommandLineOptionSet("dev") then
		Rule_Remove(UpdateEnemyForces)
		WaveDefense_ClearWarnings()
		SetupWaveData()
		SetupWaveUnits()
		__waveDefense_setupInternal()
	end
end

--Debug. Insta-cap a selected territory point.
function Capture(player)
	if Misc_IsCommandLineOptionSet("dev") then
		local point = Util_Grab()
		if point ~= nil then
			EGroup_InstantCaptureStrategicPoint(point, player)
		end
	end
end
