print("\tLoading mission file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Tank Grab
-- Designer: Ryan McGechaen
-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScriptSetup.scar") -- <== ### CRITICAL ELEMENT. 
import("XP1.scar")				-- Ardennes Assault functionality

-- [[ Objective files ]]
import("Armored_Assault_obj_VICTORY.scar")
import("XP1_NarrativeObj.scar")

-- [[ Encounter data ]]
import("Armored_Assault_encounters.scar")



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
	print("LOADING BATTLE: Armoured Assault")
	
	
	if Marker_Exists("mkr_mapidentifier_marche", "") then	-- add some extra stuff to do with beginner hints IF and ONLY IF we are playing on Marche
		import("Libraries/BattleExtras/XP1_Marche_BeginnerHintSetup.scar")
		Marche_StartUpBeginnerHints("Armored_Assault")
	end
	
	
	--TODO: Define mission initialization data. Example in comments on the bottom of this file.
	-- ### CRITICAL ELEMENT. This table contains all the initialization data for the mission.
	g_missionData = {
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
			{
				sbp = SBP.AEF.M1_57MM_AT_GUN_SQUAD_MP,
				spawn = Util_GetOffsetPosition(mkr_assault_player_defense_01, OFFSET_BACK, 5),
			},
		},
		
	}
	
	PM_PL_StartingVP = true
	PM_PL_StartingResourceHit = true
	
	--[[GLOBAL VARIABLES]]
	
	t_player_vehicles = {
		SBP.AEF.M20_UTILITY_CAR_SQUAD_MP,
		SBP.AEF.M8_GREYHOUND_SQUAD_MP,
	}
	
	t_enemy_vehicles = {
		SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP,
		SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP,
	}

	g_success_rating = 0	-- success rating for mission
	g_enemy_tank_count = 0	-- total number of enemy tanks, used to compare to when we're figuring out if any died. Gets updated periodically.
	g_player_wave_number = 1	-- what wave of tank reinforcements player is on
	g_enemy_wave_number = 1	-- what wave of tank reinforcements enemy is on
	g_first_spawn = true				-- flag so we don't play an event for the first wave
	tmr_reinforcements = "tmr_reinforcements"
	
	--[[MAP GROUPS]]

	
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	eg_cannon = EGroup_CreateIfNotFound("eg_cannon")
	sg_player_tanks = SGroup_CreateIfNotFound("sg_player_tanks")
	sg_enemy_tanks = SGroup_CreateIfNotFound("sg_enemy_tanks")
	sg_enemy_defense = SGroup_CreateIfNotFound("sg_enemy_defense")
	sg_already_vet = SGroup_CreateIfNotFound("sg_already_vet")	-- group for units we have already given veterancy to
end



-- Defines difficulty tables/tuning variables
function Mission_SetDifficulty(diffVal)
	--TODO: Define any difficulty-related settings or variables.
	-- These variables should be stored in a t_difficulty table for readability and access.
	
	g_difficulty = diffVal or Game_GetSPDifficulty() 	-- Note: Having the diffVal parameter allows for redefining difficulty settings during runtime.
	AI_OverrideDifficulty(g_difficulty)
	
	--Global difficulty table
	t_difficulty = {
		g_player_delay = Util_DifVar({4*60, 5*60, 6*60}, g_difficulty),	-- delay between player reinforcements
		g_enemy_delay = Util_DifVar({5*60, 4*60, 4*60}, g_difficulty),	-- delay between enemy reinforcements
		startManpower = Util_DifVar({500, 400, 300}, g_difficulty),			-- Starting Manpower
		startMunition = Util_DifVar({60, 40, 20}, g_difficulty),					-- Starting Munitions
		startFuel = Util_DifVar({20, 10, 5}, g_difficulty),							-- Starting Fuel
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
	Util_CreateEntities(nil, eg_cannon, EBP.GERMAN.PAK43_88MM_AT_GUN_MP, mkr_assault_01, 1)
--~ 	Modify_WeaponRange(eg_cannon, "hardpoint_01", 0.8)
	EGroup_SetInvulnerable(eg_cannon, true)
	-- spawn base defenses
	Enemy_Base_Defense()
end


-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
--Called once the intro nis/nislet/sitrep finishes playing.
function Mission_Start()
	
		
	-- default to gold success level
	XP1_SetMissionSuccessLevel(3)
	
	AI_SetPersonality(player2, "botb_skirmish_armored_assault")

--~ 	WinWarning_SetMaxTickers(250,250)
--~ 	VPTicker_SetTeamTickers(Player_GetTeam(player1), 250, true)
--~ 	VPTicker_SetTeamTickers(Player_GetTeam(player2), 250, true)

	-- spawn first tank wave
	SpawnPlayerTanks()
	SpawnEnemyTanks()
	g_first_spawn = false	-- set flag to start warning when the enemy gets tanks
	
	-- Start Objectives
	Objective_Start(OBJ_Victory)
	
	-- grant veterancy to all units the ai produces based on node strength
	Rule_AddInterval(GrantEnemyVeterancy, 1)
	-- start checking when german tanks die to reduce their vps
	Rule_AddInterval(CheckTanksKilled, 0.5)
	Rule_AddGlobalEvent(ShowKickerOnEnemyTanks, GE_SquadKilled)
	

	--Heavy Tank call in group-----------------------------------
--~ 	Rule_AddInterval(Tank_Attack_1, 1)
	
	NodeUnitRestrictions1() ----restricts certain ai units at different node strengths
	
	TankSupport() ---calls in specific tanks for ai on different node strengths
	
	-- start checking if game is over so we can update success level
	Rule_AddInterval(CalculateMissionScore, 1)
	
	if g_difficulty == GD_HARD then
	
		Rule_AddOneShot(HardElements0, 30)
		Rule_AddOneShot(HardElements1, 300)
		Rule_AddOneShot(HardElements2, 600)
		Rule_AddOneShot(HardElements3, 900)

	end
	
	
end



-- Tank functions --------------------------------------------------------------------

-- spawns reinforcement tanks for player
function SpawnPlayerTanks()
	local count = 1
	
	if XP1_GetNodeStrength() <= 2 then
		count = 2
	end
	
	local leftover_number = SGroup_Count(sg_player_tanks)
	local max_number = Util_DifVar({6, 5, 4}, g_difficulty)
	
	-- increase number of spawns over time
	if g_player_wave_number > 2 and g_player_wave_number <= 4 then
		count = 2
	elseif g_player_wave_number >= 5 then
		count = 3
	end
	
	-- spawn tanks but don't let there be more than the max_number, including the tanks we previously spawned for the player. Spawns a minimum of 1 tank
	for i = 1, count do
		-- minimum one tank spawned
		if i == 1 then
			Util_CreateSquads(player1, sg_player_tanks, Table_GetRandomItem(t_player_vehicles), mkr_assault_player_spawn, mkr_assault_player_rally) 
		
		-- spawn the rest up to maximum
		elseif i + leftover_number <= max_number then
			Util_CreateSquads(player1, sg_player_tanks, Table_GetRandomItem(t_player_vehicles), mkr_assault_player_spawn, mkr_assault_player_rally) 
		end
	end
	
	g_player_wave_number = g_player_wave_number + 1
	PopulatePlayerTankList()
end


-- spawns a wave of enemy tanks
function SpawnEnemyTanks()
	
	if SGroup_Count(sg_enemy_tanks) <= 3 then
		
		local count = 2
		local leftover_number = SGroup_Count(sg_enemy_tanks)
		local max_number = Util_DifVar({5, 6, 7}, g_difficulty)
		SGroup_Clear(sg_temp)
		
		-- increase number of spawns over time
		if g_enemy_wave_number >= 3 and g_enemy_wave_number < 4 then
			count = 3
		elseif g_enemy_wave_number >= 5 then
			count = 4
		end
		
		for i = 1, count do
			-- minimum one tank spawned
			if i == 1 then
				Util_CreateSquads(player2, sg_temp, Table_GetRandomItem(t_enemy_vehicles), mkr_assault_enemy_spawn) 

				-- spawn the rest up to maximum
			elseif i + leftover_number <= max_number then
				Util_CreateSquads(player2, sg_temp, Table_GetRandomItem(t_enemy_vehicles), mkr_assault_enemy_spawn) 
			end
		end
		
		SGroup_AddGroup(sg_enemy_tanks, sg_temp)
		g_enemy_wave_number = g_enemy_wave_number + 1
		PopulateEnemyTankList()
		Rule_RemoveMe()
		
		if g_first_spawn == false then
			Util_StartIntel(EVENTS.EnemyTanks)
		end
		
		-- queue up another tank wave
		Rule_AddDelayedInterval(SpawnEnemyTanks, t_difficulty.g_enemy_delay, 5)
	end
end

-- when the reinforcement timer reaches 0, spawn more tanks for both sides
function CheckRespawnTimer()

--~ 	if  Objective_GetTimerSeconds(OBJ_Victory) == 0 then
	if math.floor(Timer_GetElapsed(tmr_reinforcements)) >= t_difficulty.g_player_delay then
		SpawnPlayerTanks()
--~ 		Objective_StartTimer(OBJ_Victory, COUNT_DOWN, t_difficulty.g_player_delay)
		Timer_End(tmr_reinforcements)
		Timer_Start(tmr_reinforcements, t_difficulty.g_player_delay)
		g_player_wave_number = g_player_wave_number + 1
		Util_StartIntel(EVENTS.Reinforcements)
	end
	
end

-- check if any enemy tanks were destroyed and adjust german vp's if they did
function CheckTanksKilled()
	SGroup_Clear(sg_temp)
	Player_GetAll(player2, sg_temp)
	SGroup_Filter(sg_temp, t_enemy_vehicles, FILTER_KEEP)
	
	local current_count = SGroup_Count(sg_temp)
	
	-- if the germans have less tanks than the last time we checked, reduce their vp's
	if current_count < g_enemy_tank_count then
	
		-- subtract vp's based on how many tanks they lost
		local number_of_tanks_killed = g_enemy_tank_count - current_count
		local adjustedTicker = VPTicker_GetTeamTickers(Player_GetTeam(player2)) - ( 10 * number_of_tanks_killed )
		VPTicker_SetTeamTickers(Player_GetTeam(player2), math.max(adjustedTicker, 0), true)
		
		-- play speech
		Util_StartIntel(EVENTS.EnemyTankDestroyed)
	end
	
	g_enemy_tank_count = current_count
end

-- Utility functions -----------------------------------------------------------------
function ShowKickerOnEnemyTanks(victim, killer)

	if Util_GetPlayerOwner(victim) == player2 then
	
		if Table_Contains(t_enemy_vehicles, Squad_GetBlueprint(victim)) then
			
			local pos = Util_GetPosition(victim)
			pos.y = pos.y + 3
			
			local kicker_text = Loc_FormatText(11079493, Loc_ConvertNumber(10))
			UI_CreateColouredPositionKickerMessage(player1, pos, kicker_text, 255, 0, 0, 0)
			
		end
	
	end
	
end




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

function Display_Countdown()	
	
	local timeString = Loc_FormatTime((t_difficulty.g_player_delay - math.floor(Timer_GetElapsed(tmr_reinforcements))), false, false)
	Obj_ShowProgress(Loc_FormatText(11075448, timeString), (t_difficulty.g_player_delay- math.floor(Timer_GetElapsed(tmr_reinforcements)))/t_difficulty.g_player_delay)
end


--- Tank Functions -----------------------------------------------------------------


-- adds more player tanks to the list of spawnable tanks
function PopulatePlayerTankList()
	
	-- populate player tank spawn list
	-- wave 2
	if g_player_wave_number == 2 then
		
		table.insert(t_player_vehicles, SBP.AEF.M15A1_AA_HALFTRACK_SQUAD_MP)
		table.insert(t_player_vehicles, SBP.AEF.M5A1_STUART_SQUAD_MP)
	
	-- wave 3
	elseif g_player_wave_number == 3 then
		
		table.insert(t_player_vehicles, SBP.AEF.M4A3_SHERMAN_SQUAD_MP)
		
		-- node strength tuning
		if XP1_GetNodeStrength() <= 3 then
			table.insert(t_player_vehicles, SBP.AEF.M10_TANK_DESTROYER_SQUAD_MP)
		end
		
	-- wave 4
	elseif g_player_wave_number == 4 then
		table.insert(t_player_vehicles, SBP.AEF.M4A3_76MM_SHERMAN_SQUAD_MP)
		
		if XP1_GetNodeStrength() >= 4 then
			table.insert(t_player_vehicles, SBP.AEF.M10_TANK_DESTROYER_SQUAD_MP)
		end
		
	-- wave 5
	elseif g_player_wave_number == 5 then
		table.insert(t_player_vehicles, SBP.AEF.M4A3E8_SHERMAN_EASY_8_SQUAD_MP)
		
		if XP1_GetNodeStrength() <= 2 then
			table.insert(t_player_vehicles, SBP.AEF.M36_TANK_DESTROYER_SQUAD_MP)
		end
	end
end

-- adds more enemy tanks to the list of spawnable tanks
function PopulateEnemyTankList()
	
	-- populate enemy tank spawn list
	-- wave 2
	if g_enemy_wave_number == 2 then
		table.insert(t_enemy_vehicles, 	SBP.WEST_GERMAN.MORTAR_250_HALFTRACK_SQUAD_WESTGERMAN_MP)
		
		if XP1_GetNodeStrength() >= 3 then
			table.insert(t_enemy_vehicles, 	SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP)
		end
		
	-- wave 3
	elseif g_enemy_wave_number == 3 then
		table.insert(t_enemy_vehicles, 	SBP.WEST_GERMAN.OSTWIND_SQUAD_WESTGERMAN_MP)
		table.insert(t_enemy_vehicles, SBP.GERMAN.STUG_III_SQUAD_MP)
		
		if XP1_GetNodeStrength() >= 4 then
			table.insert(t_enemy_vehicles, SBP.WEST_GERMAN.JAGDPANZER_TANK_DESTROYER_SQUAD_MP)
		end
		
		if XP1_GetNodeStrength() <= 2 then
			table.insert(t_enemy_vehicles, 	SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP)
		end
		
	-- wave 4
	elseif g_enemy_wave_number == 4 then
		
		table.insert(t_enemy_vehicles, SBP.GERMAN.PANZER_IV_SQUAD_MP)
		
		if XP1_GetNodeStrength() >= 4 then
			table.insert(t_enemy_vehicles, SBP.WEST_GERMAN.PANTHER_AUSF_G_SQUAD_MP)
		end

		
	-- wave 5
	elseif g_enemy_wave_number == 5 then
		
		if XP1_GetNodeStrength() >= 4 then
			table.insert(t_enemy_vehicles, SBP.WEST_GERMAN.KING_TIGER_SQUAD_MP)
		end
		
		if XP1_GetNodeStrength() >= 5 then
			table.insert(t_enemy_vehicles, SBP.WEST_GERMAN.STURMTIGER_SQUAD_MP)
		end
	
	-- wave 6
	elseif g_enemy_wave_number == 6 then
		
		if XP1_GetNodeStrength() >= 4 then
			table.insert(t_enemy_vehicles, SBP.WEST_GERMAN.JAGDTIGER_TD_SQUAD_MP)
		end
		
		if XP1_GetNodeStrength() >= 5 then
			table.insert(t_enemy_vehicles, SBP.WEST_GERMAN.KING_TIGER_SQUAD_MP)
		end
	
	end
end

-- spawn some defenses at the enemy base so that the player doesn't immediately overwhelm the ai with captured vehicles
function Enemy_Base_Defense()
	local Base_Defense_EncounterData = {
		name = "Base Defense Encounter 01",
		player = player2,
		sgroups = {sg_enemy_defense},
		units = {
			{
				sbp = Util_DifVar( { SBP.WEST_GERMAN.RAKETENWERFER43_88MM_PUPPCHEN_ANTITANK_GUN_SQUAD_MP, SBP.WEST_GERMAN.RAKETENWERFER43_88MM_PUPPCHEN_ANTITANK_GUN_SQUAD_MP, SBP.WEST_GERMAN.RAKETENWERFER43_88MM_PUPPCHEN_ANTITANK_GUN_SQUAD_MP} ),
				spawn = mkr_assault_enemy_defense_01,
			},
			{
				sbp = Util_DifVar( { SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP} ),
				spawn = mkr_assault_enemy_defense_02,
				upgrades = {UPG.WEST_GERMAN.ASSAULT_PIONEER_COMBAT_UPGRADE},
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
		
	Rule_AddInterval(CreateLightSupport, 680)
	
	Rule_AddInterval(CreateJadtiger,720 )

	Rule_AddInterval(CreateTigerAce, 800)

	end
end



function CreateMortarHT()

	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.MORTAR_250_HALFTRACK_SQUAD_WESTGERMAN_MP, mkr_reverseHardpoint_point1)

end
	
	
function CreateLightSupport()

	if XP1_GetNodeStrength() == 3 then		
		Spawn_T1()

	end
end

function Spawn_T1()

	local potential_units =
	{	
		
		{sbp = SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP},
		{sbp = SBP.WEST_GERMAN.PANZER_IV_AUSF_J_BATTLE_GROUP_MP},
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
		{sbp = SBP.WEST_GERMAN.PANZER_IV_AUSF_J_BATTLE_GROUP_MP},
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



	

-- SUCCESS LEVEL ----------------------------------------------------
	-- calculates final mission score
function CalculateMissionScore()
	
	-- assuming player starts at gold, we keep checking if the player's vp's drop below a threshold then lower their success level accordingly
	
	-- silver
	if VPTicker_GetTeamTickerFromPlayerID(player1) < 200 and VPTicker_GetTeamTickerFromPlayerID(player1) >= 100 then
		XP1_SetMissionSuccessLevel(2)

	-- bronze
	elseif VPTicker_GetTeamTickerFromPlayerID(player1) < 100 then
		XP1_SetMissionSuccessLevel(1)

	end
	
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

	Player_AddResource(player2, RT_Manpower, 200)
	Player_AddResource(player2, RT_Fuel, 50)
	Player_AddResource(player2, RT_Munition, 80)
	
	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.PANTHER_COMMANDER_SQUAD_MP, mkr_reverseHardpoint_point1)
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
			print("Called WinConditionEndCallback win!")
			
--~ 		elseif Rule_Exists(Mission_Complete) == false then
--~ 			Rule_AddInterval(Mission_Complete, 1)
--~ 			print("Failsafe win!")
		end
	else
		if Objective_IsFailed(OBJ_Victory) == false then
			Objective_Fail(OBJ_Victory)
			print("Called WinConditionEndCallback loss!")
		
--~ 		elseif Rule_Exists(Mission_Fail) == false then
--~ 			Rule_AddInterval(Mission_Fail, 1)
--~ 			print("Failsafe loss!")
		end
	end
end


