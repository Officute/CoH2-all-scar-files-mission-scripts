print("\tLoading mission file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Hardpoint
-- Designer: started by Ryan McGechaen, completed by Jim Dodge and painfully polished by Matt P. 
-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScriptSetup.scar") -- <== ### CRITICAL ELEMENT. 
import("XP1.scar")				-- Ardennes Assault functionality
import("WinConditions/AABattle_VictoryPointPlusAnnihilate.scar")

-- [[ Objective files ]]
import("Hardpoint_obj_VICTORY.scar")
import("XP1_NarrativeObj.scar")

-- [[ Encounter data ]]
import("Hardpoint_encounters.scar")



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
	print("LOADING BATTLE: Hardpoint")
	

	if Marker_Exists("mkr_mapidentifier_marche", "") then	-- add some extra stuff to do with beginner hints IF and ONLY IF we are playing on Marche
		import("Libraries/BattleExtras/XP1_Marche_BeginnerHintSetup.scar")
		Marche_StartUpBeginnerHints("Hardpoint")
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
	}
	
	
	
	--[[GLOBAL VARIABLES]]
--~ 	g_buildingSpeedMod_01 = nil
--~ 	g_buildingSpeedMod_02 = nil
--~ 	g_buildingSpeedMod_03 = nil
--~ 	g_buildingSpeedMod_04 = nil
	
	
	t_AI_units = {
		SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
		SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
		SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
	}
	def1 = nil
	sg_def1 = SGroup_CreateIfNotFound("sg_def1")
	def2 = nil
	sg_def1 = SGroup_CreateIfNotFound("sg_def1")
	
	t_targets = {mkr_hardpoint_vp_01, mkr_hardpoint_vp_02, mkr_hardpoint_vp_03}
	mkr_currentEncounterTarget = mkr_hardpoint_vp_01
	
	i_offsetCounter = 0
	i_neutralizedVPs = 1 --must be changed if initial conditions are changed
	i_neutralizeBonus = 10 --given for each capture
	i_nbObjString = 11075629
	i_lastKnownCount_EnemyVPs = 0
	prevPingID = nil
	lullOnStart = 10
	delayDuration = 60
	b_delayComplete = false
	i_successLevel = 100
	i_neutralizeCounter = 0
	t_times = {
		320,
		680,
		1200,
		1800,
		2200,
		2800,
		3200,
		3800,
		4200,
		4700,
		5200,
	}
	currentEncounterID = 0 -- set in Hardpoint_encounter.scar
	t_instantVeterancy = {
		0,
		0,
		0,
		0,
		0,
		1,
		1,
		2,
		3,
		2,
		1,
		2,
		3,
	}
	i_encounter = 1
	id_hintTextVP = 0 -- set in Hardpoint_obj_VICTORY.scar
	b_onlySpeakOnce = true
	i_nPlayerTerritoriesAtStart = 3
	
	--[[MAP GROUPS]]
	eg_hardpoint_vp_01 = EGroup_CreateIfNotFound("eg_hardpoint_vp_01")
	eg_hardpoint_vp_02 = EGroup_CreateIfNotFound("eg_hardpoint_vp_02")
	eg_hardpoint_vp_03 = EGroup_CreateIfNotFound("eg_hardpoint_vp_03")
	sg_e_all = SGroup_CreateIfNotFound ("sg_e_all")------------------------------------------------------------------------------------added------------------------------------
	sg_sniper = SGroup_CreateIfNotFound ("sg_sniper")
	sg_howitzer = SGroup_CreateIfNotFound ("sg_howitzer")
	eg_vPoints = EGroup_CreateIfNotFound("eg_vPoints")
	eg_mines = EGroup_CreateIfNotFound("eg_mines") ----------------e group for mines---------------------------------------------
	eg_bunkers = EGroup_CreateIfNotFound("eg_bunkers") ----------------e group for bunkers---------------------------------------------
	eg_enemyVPpoints = EGroup_CreateIfNotFound("eg_enemyVPpoints") 
	t_encounterSpawns = {}
	t_enemyPoints = {}
	t_VPs = {
		{
			eg = eg_hardpoint_vp_01,
			spawn = mkr_hardpoint_vp_01,
		},
		{
			eg = eg_hardpoint_vp_02,
			spawn = mkr_hardpoint_vp_02,
		},
		{
			eg = eg_hardpoint_vp_03,
			spawn = mkr_hardpoint_vp_03,
		},
	}
	t_encounterDestinations = {
		{
			vp = mkr_hardpoint_vp_01,
			overwatch = mkr_hardpoint_vp_01_overwatch,
			rearDefense = mkr_hardpoint_vp_01_rearDefense,
			frontDefense = mkr_hardpoint_vp_01_frontDefense,
		},
		{
			vp = mkr_hardpoint_vp_02,
			overwatch = mkr_hardpoint_vp_02_overwatch,
			rearDefense = mkr_hardpoint_vp_02_rearDefense,
			frontDefense = mkr_hardpoint_vp_02_frontDefense,
		},
		{
			vp = mkr_hardpoint_vp_03,
			overwatch = mkr_hardpoint_vp_03_overwatch,
			rearDefense = mkr_hardpoint_vp_03_rearDefense,
			frontDefense = mkr_hardpoint_vp_03_frontDefense,
		},
	}
	
	
	sg_already_vet = SGroup_CreateIfNotFound("sg_already_vet")	-- group for units we have already given veterancy to
	
end

-- Defines difficulty tables/tuning variables
function Mission_SetDifficulty(diffVal)
	--TODO: Define any difficulty-related settings or variables.
	-- These variables should be stored in a t_difficulty table for readability and access.
	
	g_difficulty = diffVal or Game_GetSPDifficulty() 	-- Note: Having the diffVal parameter allows for redefining difficulty settings during runtime.
	AI_OverrideDifficulty(g_difficulty)
	
	Select_AI_VPs()
	
	
--~ 	*******************************************************************************************************************
--~ 	WHY IS THIS HERE? THIS SHOULD NOT BE HERE???? UNCOMMENTING THIS CAUSES A SCAR ERROR
--~ 	REMINDER: BYRON TALKED TO RYAN ABOUT THIS WEIRD FUNCTION CALL THAT IS ATTEMPTING TO SPAWN UNITS FOR THE PLAYER

--~ 	Setup_Player_VP()
--~ 	*******************************************************************************************************************
	
--~ 	PM_PL_StartingResourceHit = true
--~ 	PM_AI_CPDefenses = true --changed to add encounters using the same method as Reverse Hardpoint, Jim Dodge April 10
	PM_AI_Aggression = true
	PM_PL_Defenses = true
	--Global difficulty table (adjusted by Jim Dodge, April 7 $$$)
	t_difficulty = {
		startingManpower = Util_DifVar({
			XP1_NodeDif({1000, 1000, 1000, 1000, 1000}),
			XP1_NodeDif({800, 800, 800, 800, 800}),
			XP1_NodeDif({600, 600, 600, 600, 600}),
		}, g_difficulty),
		startingMunitions = Util_DifVar({
			XP1_NodeDif({600, 600, 600, 600, 600}),
			XP1_NodeDif({300, 300, 300, 300, 300}),
			XP1_NodeDif({200, 200, 200, 200, 200}),
		}, g_difficulty),
		startingFuel = Util_DifVar({
			XP1_NodeDif({400, 400, 400, 400, 400}),
			XP1_NodeDif({150, 150, 150, 150, 150}),
			XP1_NodeDif({100, 100, 100, 100, 100}),
		}, g_difficulty),
	}
	
	--Easy
	if g_difficulty == GD_EASY then
	
		
	--Medium
	elseif g_difficulty == GD_NORMAL then

		
	--Hard
	elseif g_difficulty == GD_HARD  then


	--Expert (not currently planned for Persistant Mode)
	elseif g_difficulty == GD_EXPERT then

	end
end

-- Sets restrictions on units, teams, etc.
function Mission_SetupRestrictions()
	--TODO: Set any tech/ability restrictions on a players, as well as resource limits.
	--	Note: Resource Income/Caps should be defined in Mission_SetDifficulty()
	
	--[[ HUMAN PLAYER ]]
	Player_SetResource(player1, RT_Manpower, t_difficulty.startingManpower)
	Player_SetResource(player1, RT_Munition, t_difficulty.startingMunitions)
	Player_SetResource(player1, RT_Fuel, t_difficulty.startingFuel)
	
	--[[ ALLIED PLAYER ]]
	

	--[[ ENEMY PLAYER ]]
	Player_SetResource(player2, RT_Manpower, 400)
	Player_SetResource(player2, RT_Munition, 100)
	Player_SetResource(player2, RT_Fuel, 100)
	--$$$change node strength here
	Player_SetMaxCapPopulation(player2, CT_Personnel, 200)
	Player_SetMaxCapPopulation(player2, CT_Vehicle, 140)
	Player_SetMaxPopulation(player2, CT_Personnel, 200)
	Player_SetMaxPopulation(player2, CT_Vehicle, 140)
	
end

-- Sets up the map before the mission starts (starting units, ownership, etc.)
function Mission_Preset()
	
	-- Set player's success level to gold (we will lwoer it accordingly during mission)
	XP1_SetMissionSuccessLevel(3)
	
	-- Capture Territory for player
	--EGroup_InstantCaptureStrategicPoint(eg_hardpoint_playerCPs, player1)
	hpCaptureNearbyTerritories( i_nPlayerTerritoriesAtStart )
	
	--Capture Territory for enemy
	aiCaptureNearbyTerritories( XP1_GetNodeStrength() )
	
--~ 	Set AI Encounters

--~ 	encID_ai_point_attack_1 = ENCOUNTERS.ai_point_attack_1()
--~ 	encID_ai_point_attack_2 = ENCOUNTERS.ai_point_attack_2()
--~ 	encID_ai_point_attack_3 = ENCOUNTERS.ai_point_attack_3()
--~ 	encID_ai_point_attack_4 = ENCOUNTERS.ai_point_attack_4()
--~ 	encID_ai_point_attack_5 = ENCOUNTERS.ai_point_attack_5()
--~ 	encID_ai_point_attack_6 = ENCOUNTERS.ai_point_attack_6()
--~ 	encID_ai_point_attack_7 = ENCOUNTERS.ai_point_attack_7()
--~ 	encID_ai_point_attack_8 = ENCOUNTERS.ai_point_attack_8()
--~ 	encID_ai_point_attack_9 = ENCOUNTERS.ai_point_attack_9()
--~ 	encID_ai_point_attack_10 = ENCOUNTERS.ai_point_attack_10()
--~ 	encID_ai_point_attack_11 = ENCOUNTERS.ai_point_attack_11()

-----------------------------------------------------------------------------------------------------Timed Pushed Back Encounters that target VP's-----------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	

	Event_Timer(ENCOUNTERS.ai_point_attack_1, nil, t_times[1] + delayDuration + lullOnStart + World_GetRand(-5, 5))
--~ 	Event_Timer(_activateEncounters, {_encounterID = encID_ai_point_attack_1}, t_times[1] + delayDuration + lullOnStart + World_GetRand(-5, 5))
	
	Event_Timer(ENCOUNTERS.ai_point_attack_2, nil, t_times[2] + delayDuration + lullOnStart + World_GetRand(-5, 5))
--~ 	Event_Timer(_activateEncounters, {_encounterID = encID_ai_point_attack_2}, 79 + delayDuration + 10)
	
	Event_Timer(ENCOUNTERS.ai_point_attack_3, nil, t_times[3] + delayDuration + lullOnStart + World_GetRand(-5, 5))
--~ 	Event_Timer(_activateEncounters, {_encounterID = encID_ai_point_attack_3}, 147 + delayDuration + 10) 

	Event_Timer(ENCOUNTERS.ai_point_attack_4, nil, t_times[4] + delayDuration + lullOnStart + World_GetRand(-5, 5))
--~ 	Event_Timer(_activateEncounters, {_encounterID = encID_ai_point_attack_4}, 261 + delayDuration + 10)
--~ 	SGroup_IncreaseVeterancyRank(encID_ai_point_attack_4:GetSgroup(), 1)

	Event_Timer(ENCOUNTERS.ai_point_attack_5, nil, t_times[5] + delayDuration + lullOnStart + World_GetRand(-5, 5))
--~ 	Event_Timer(_activateEncounters, {_encounterID = encID_ai_point_attack_5}, 329 + delayDuration + 10)
--~ 	SGroup_IncreaseVeterancyRank(encID_ai_point_attack_5:GetSgroup(), 1)
	
	Event_Timer(ENCOUNTERS.ai_point_attack_6, nil, t_times[6] + delayDuration + lullOnStart + World_GetRand(-5, 5))
--~ 	Event_Timer(_activateEncounters, {_encounterID = encID_ai_point_attack_6}, 444 + delayDuration + 10)
--~ 	SGroup_IncreaseVeterancyRank(encID_ai_point_attack_6:GetSgroup(), 2)
	
	Event_Timer(ENCOUNTERS.ai_point_attack_7, nil, t_times[7] + delayDuration + lullOnStart + World_GetRand(-5, 5))
--~ 	Event_Timer(_activateEncounters, {_encounterID = encID_ai_point_attack_7}, 527 + delayDuration + 10)
--~ 	SGroup_IncreaseVeterancyRank(encID_ai_point_attack_7:GetSgroup(), 3)

	Event_Timer(ENCOUNTERS.ai_point_attack_8, nil, t_times[8] + delayDuration + lullOnStart + World_GetRand(-5, 5))
--~ 	Event_Timer(_activateEncounters, {_encounterID = encID_ai_point_attack_8}, 588 + delayDuration + 10)
--~ 	SGroup_IncreaseVeterancyRank(encID_ai_point_attack_8:GetSgroup(), 2)

	Event_Timer(ENCOUNTERS.ai_point_attack_9, nil, t_times[9] + delayDuration + lullOnStart + World_GetRand(-5, 5))
--~ 	Event_Timer(_activateEncounters, {_encounterID = encID_ai_point_attack_9}, 632 + delayDuration + 10)
--~ 	SGroup_IncreaseVeterancyRank(encID_ai_point_attack_9:GetSgroup(), 1)

	Event_Timer(ENCOUNTERS.ai_point_attack_10, nil, t_times[10] + delayDuration + lullOnStart + World_GetRand(-5, 5))
--~ 	Event_Timer(_activateEncounters, {_encounterID = encID_ai_point_attack_10}, 712 + delayDuration + 10)
--~ 	SGroup_IncreaseVeterancyRank(encID_ai_point_attack_10:GetSgroup(), 2)

	Event_Timer(ENCOUNTERS.ai_point_attack_11, nil, t_times[11] + delayDuration + lullOnStart + World_GetRand(-5, 5))
--~ 	Event_Timer(_activateEncounters, {_encounterID = encID_ai_point_attack_11}, 888 + delayDuration + 10)
--~ 	SGroup_IncreaseVeterancyRank(encID_ai_point_attack_11:GetSgroup(), 3)
end


-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
--Called once the intro nis/nislet/sitrep finishes playing.
function Mission_Start()
	
	AI_SetPersonality(player2, "botb_skirmish_hardpoint")
	
	--Intro Dialogue
	Util_StartIntel( EVENTS.Mission_Start)
	-- Start Objectives
	Objective_Start(OBJ_Victory)
	Objective_Start(SOBJ_VictoryPoints, false)
	
	-- create Victory Point references
	World_GetStrategyPoints(eg_vPoints, true)
	EGroup_Filter(eg_vPoints, BP_GetEntityBlueprint("victory_point"), FILTER_KEEP)
	Setup_AI_VPs()
	
	
	-- note the owner for each point (allows us to track which one gets decapped!)
	for k, point in pairs(t_VPs) do 
		
		if EGroup_Count(point.eg) >= 1 and World_OwnsEGroup(point.eg, ANY) == false then
			local eid = EGroup_GetSpawnedEntityAt(point.eg, 1)
			point.old_owner = Entity_GetPlayerOwner(eid)
		end
		
	end
	
	
	VPTickerData.paused = true  -- keep the player's VP tickers from going down at the start of the mission
	Rule_AddOneShot(EnableTickers, 60)	-- enable VP tickers again after a delay

	-- grant veterancy to all units the ai produces based on node strength
	Rule_AddInterval(GrantEnemyVeterancy, 1)
	
	--Heavy Tank call in group-----------------------------------
	Rule_AddInterval(Tank_Attack_1, 1)
	
	
	-- start checking if game is over so we can update success level
	Rule_AddInterval(CalculateMissionScore, 1)
	
	NodeUnitRestrictions1() ----restricts certain ai units at different node strengths
	
	Support() ------grants different support units based on node strength
	
	
end

function Select_AI_VPs()
	
	local number_to_capture = 2	-- number of victory points to give to the enemy
	
	-- on node strength 2 and lower only give the enemy one victory point
	if XP1_GetNodeStrength() <= 2 then
		number_to_capture = 1
	end
	print("***** CAPTURING *******")
	print(number_to_capture)
	for i = 1, number_to_capture do
		local rand = World_GetRand(1, 4 - i) --change 4 to 3 for deterministic sorting that gives the same VP placement every time
		
		local t = t_VPs[rand]
		EGroup_InstantCaptureStrategicPoint(t.eg, player2)	
		table.insert(t_enemyPoints, t)
		print("captured a point")
		table.remove(t_VPs, rand)
	end
	-- restore t_VPs
	t_VPs = {
		{
			eg = eg_hardpoint_vp_01,
			spawn = mkr_hardpoint_vp_01,
		},
		{
			eg = eg_hardpoint_vp_02,
			spawn = mkr_hardpoint_vp_02,
		},
		{
			eg = eg_hardpoint_vp_03,
			spawn = mkr_hardpoint_vp_03,
		},
	}
end

function Select_AI_Defenses()
	--randomize defensive unit selection at each point
	for i = 1, 2 do
		local rand = World_GetRand(1, 4 - i)
	
		local chosenUnit = t_AI_units[rand]
		
		if i == 1 then
			def1 = chosenUnit
		else
			def2 = chosenUnit
		end
		
		table.remove(t_AI_units, rand)
	end
	-- restore t_AI_units, note that it is restored to different set of SBPs than on initialization
	t_AI_units = {
		SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
		SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
		SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
	}
end

function Setup_AI_VPs()
	--variables for node strength effects
	local t_nodeStrengthSpawns = {mkr_reverseHardpoint_artillery1, mkr_reverseHardpoint_artillery2}
	local indexOfSpawns = 1
	
	--add common units for all node strengths and difficulties
	--local overwatch = SBP.WEST_GERMAN.RAKETENWERFER43_88MM_PUPPCHEN_ANTITANK_GUN_SQUAD_MP
	local overwatch = SBP.GERMAN.MORTAR_TEAM_81MM_MP
	local defenses1 = SGroup_CreateIfNotFound("defenses")
	local defenses2 = SGroup_CreateIfNotFound("defenses")
	local infantry = {defenses1, defenses2}
	for k,v in pairs(t_enemyPoints) do
		if EGroup_Compare(v.eg, t_VPs[1].eg) then
			local vp1 = SGroup_CreateIfNotFound("vp1")
			Util_CreateSquads(player2,vp1,overwatch,mkr_hardpoint_vp_01_overwatch)
			Select_AI_Defenses()
			Util_CreateSquads(player2,defenses1,def1,mkr_hardpoint_vp_01_frontDefense)
--~ 			Util_CreateSquads(player2,defenses2,def2,mkr_hardpoint_vp_01_rearDefense)
			SGroup_AddGroups(vp1, infantry)
			AI_LockSquads(player2, vp1)
			t_nodeStrengthSpawns[indexOfSpawns] = mkr_hardpoint_vp_01_rearDefense
			indexOfSpawns = 2
		elseif EGroup_Compare(v.eg, t_VPs[2].eg) then
			local vp2 = SGroup_CreateIfNotFound("vp2")
			Util_CreateSquads(player2,vp2,overwatch,mkr_hardpoint_vp_02_overwatch)
			Select_AI_Defenses()
			Util_CreateSquads(player2,defenses1,def1,mkr_hardpoint_vp_02_frontDefense)
--~ 			Util_CreateSquads(player2,defenses2,def2,mkr_hardpoint_vp_02_rearDefense)
			SGroup_AddGroups(vp2, infantry)
			AI_LockSquads(player2, vp2)
			t_nodeStrengthSpawns[indexOfSpawns] = mkr_hardpoint_vp_02_rearDefense
			indexOfSpawns = 2
		elseif EGroup_Compare(v.eg, t_VPs[3].eg) then
			local vp3 = SGroup_CreateIfNotFound("vp3")
			Util_CreateSquads(player2,vp3,overwatch,mkr_hardpoint_vp_03_overwatch)
			Select_AI_Defenses()
			Util_CreateSquads(player2,defenses1,def1,mkr_hardpoint_vp_03_frontDefense)
--~ 			Util_CreateSquads(player2,defenses2,def2,mkr_hardpoint_vp_03_rearDefense)
			SGroup_AddGroups(vp3, infantry)
			AI_LockSquads(player2, vp3)
			t_nodeStrengthSpawns[indexOfSpawns] = mkr_hardpoint_vp_03_rearDefense
			indexOfSpawns = 2
		end
	end
	
--------------------------------------------------------------------------------------------------NODE STRENGTH ------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	
		if XP1_GetNodeStrength() >= 4 then
		local sg_mg1 = SGroup_CreateIfNotFound("sg_mg1")
		local sg_mg2 = SGroup_CreateIfNotFound("sg_mg2")
		Util_CreateSquads(player2, sg_mg1, SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP, Util_GetOffsetPosition(t_nodeStrengthSpawns[1], OFFSET_FRONT, 15) ) --, World_GetTerritorySectorPosition( World_GetTerritorySectorID(t_nodeStrengthSpawn[1]))) --static
		AI_LockSquads(player2, sg_mg1)
--~ 		Util_CreateSquads(player2, sg_mg2, SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP, Util_GetOffsetPosition(t_nodeStrengthSpawns[2], OFFSET_FRONT, 15) ) --, World_GetTerritorySectorPosition( World_GetTerritorySectorID(t_nodeStrengthSpawn[2]))) --static
--~ 		AI_LockSquads(player2, sg_mg2)
	
	end

	if XP1_GetNodeStrength() == 5 then
--~ 		local sg_ober1 = SGroup_CreateIfNotFound("sg_ober1")
--~ 		local sg_ober2 = SGroup_CreateIfNotFound("sg_ober2")
--~ 		Util_CreateSquads(player2, sg_ober1, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, Util_GetRandomPosition(World_GetTerritorySectorPosition( World_GetTerritorySectorID(Marker_GetPosition(t_nodeStrengthSpawns[1]))), 5 ) ) --static
--~ 		Util_CreateSquads(player2, sg_ober2, SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP, Util_GetRandomPosition(World_GetTerritorySectorPosition( World_GetTerritorySectorID(Marker_GetPosition(t_nodeStrengthSpawns[2]))), 5 ) ) --static
--~ 		AI_LockSquads(player2, SGroup_FromName("sg_ober1"))
--~ 		AI_LockSquads(player2, SGroup_FromName("sg_ober2"))
	end

end
	



-- enable victory point logic so that tickers can count down
function EnableTickers()
	VPTickerData.paused = false
end



function Get_VP_Target()
	local size = table.getn(t_targets)
	--spread the attacks over all three points, then restore the table to initial values
	if size <= 0 then
		t_targets = {mkr_hardpoint_vp_01, mkr_hardpoint_vp_02, mkr_hardpoint_vp_03}
	end
	local index = World_GetRand(1, math.max(1,size)) -- first parameter in World_GetRand must be less than or equal to second parameter
	
	local target = t_targets[index]
	
	table.remove(t_targets, index)

	return target
end

function Setup_Encounters() --not called $$$
	--initialize table of spawn locations by finding map_entry_points (SKIPPED FOR NOW)
	--World_GetSpawnablePosition(
	
end



function ScoutReport(ping) 
	--Util_MissionTitle(11075444, 1.5, 5, 0.5) -- LOCDB [11075444] 'German Forces Approaching!'
	Util_StartIntel( EVENTS.Wave_Approaching )
	prevPingID = UI_CreateMinimapBlip(Marker_GetPosition(ping), 6, BT_AttackHere)
	Rule_AddOneShot(ClearReport, 5)
end

function ClearReport()
	UI_DeleteMinimapBlip(prevPingID)
end



--these four functions remove dependancies on EGroups
function aiOrderTerritoriesByDistFromHQ(v1, v2) --accepts EGroups
	if World_DistancePointToPoint(Player_GetStartingPosition(player2), Entity_GetPosition(v1)) < World_DistancePointToPoint(Player_GetStartingPosition(player2), Entity_GetPosition(v2)) then
		return true
	else
		return false
	end
end

function aiCaptureNearbyTerritories(n)

	local t_entities_territories = {}
	local eg_strategicPoints = EGroup_CreateIfNotFound("eg_strategicPoints")
	World_GetStrategyPoints(eg_strategicPoints, false)
	EGroup_Filter(eg_strategicPoints, BP_GetEntityBlueprint("victory_point"), FILTER_REMOVE) --just to be safe
	
	for index = 1, EGroup_Count(eg_strategicPoints) do
		table.insert(t_entities_territories, EGroup_GetSpawnedEntityAt(eg_strategicPoints, index))
	end
	table.sort( t_entities_territories, aiOrderTerritoriesByDistFromHQ )
	
	for index = 1, n do
		Entity_InstantCaptureStrategicPoint( t_entities_territories[index], player2 )
	end
	
end

function hpOrderTerritoriesByDistFromHQ(v1, v2) --accepts EGroups
	if World_DistancePointToPoint(Player_GetStartingPosition(player1), Entity_GetPosition(v1)) < World_DistancePointToPoint(Player_GetStartingPosition(player1), Entity_GetPosition(v2)) then
		return true
	else
		return false
	end
end

function hpCaptureNearbyTerritories(n) -------------------------------captures friendly territory for the player----------------------------

	local t_entities_territories = {}
	local eg_strategicPoints = EGroup_CreateIfNotFound("eg_strategicPoints")
	World_GetStrategyPoints(eg_strategicPoints, false)
	EGroup_Filter(eg_strategicPoints, BP_GetEntityBlueprint("victory_point"), FILTER_REMOVE) --just to be safe
	
	for index = 1, EGroup_Count(eg_strategicPoints) do
		table.insert(t_entities_territories, EGroup_GetSpawnedEntityAt(eg_strategicPoints, index))
	end
	table.sort( t_entities_territories, hpOrderTerritoriesByDistFromHQ )
	
	for index = 1, n do
		Entity_InstantCaptureStrategicPoint( t_entities_territories[index], player1 )
	end
	
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


------------------------------------------------------------------------------------------------------------------Veterancy functions ---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
-- called by a rule
function GrantEnemyVeterancy(sgroup, index, squad)
	local	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	Player_GetAll(player2, sg_temp)
	SGroup_ForEach(sg_temp, RandomVeterancy)
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
	
			
	elseif XP1_GetNodeStrength() == 3 then
		
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
		
				-------Pre Placed Mines, Mine posts and Bunkers on map-----
			
		Util_CreateEntities(player2, eg_mines, EBP.WEST_GERMAN.SCHU_MINE_42_MP, mkr_mines_1,  1)
		Util_CreateEntities(player2, eg_mines, EBP.WEST_GERMAN.SCHU_MINE_42_MP, mkr_mines_2,  1)
		Util_CreateEntities(player2, eg_mines, EBP.WEST_GERMAN.SCHU_MINE_42_MP, mkr_mines_3,  1)
					
		Util_CreateEntities(player2, eg_mines, EBP.WEST_GERMAN.SCHU_MINE_42_MP, mkr_mines_4,  1)
		Util_CreateEntities(player2, eg_mines, EBP.WEST_GERMAN.SCHU_MINE_42_MP, mkr_mines_5,  1)
		Util_CreateEntities(player2, eg_mines, EBP.WEST_GERMAN.SCHU_MINE_42_MP, mkr_mines_6,  1)

						
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER_MP, mkr_post_1,  1)
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER_MP, mkr_post_2,  1)
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER_MP, mkr_post_3,  1)
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER_MP, mkr_post_4,  1)
					
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER_MP, mkr_post_5,  1)
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER_MP, mkr_post_6,  1)
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER_MP, mkr_post_7,  1)
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER_MP, mkr_post_8,  1)
						
		----Pre placed enemy howitzer-----
						
	--~ 	Util_CreateSquads(player2, sg_e_all, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY_MP, mkr_arty)
					
		RandomBunker() ------function that places random bunkers on the map------
		
		-- start events for node strength call outs
		Rule_AddInterval(SpottedBunker, 2)
		Rule_AddInterval(SpottedMines, 2)

		Rule_AddOneShot(CreateHowy, 300)
		
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
			Util_CreateEntities(player2, eg_bunkers, EBP.GERMAN.AXIS_BUNKER_STARTING_POSITION_MP, marker,  1)
		end
		
	end


----------------------------function that creates a howitzer for node strength 5---------------------------
	
function CreateHowy()

	Util_CreateSquads(player2, {sg_e_all, sg_howitzer}, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY_MP, mkr_arty)
	Rule_AddInterval(ArtilleryAttack, 1)
	
end



--------------------------------------specific unit support for different node strengths----------------------------------------------


function Support()

	if XP1_GetNodeStrength() >= 2 then
	
	Rule_AddInterval(CreatePanzer, 500)
		
--~ 	elseif XP1_GetNodeStrength() == 3 then
	
	Rule_AddInterval(CreateSniper, 600)
	
--~ 	elseif XP1_GetNodeStrength() == 4 then
--~ 	
--~ 	Rule_AddOneShot(CreateJadtiger, 180)

--~ 	elseif XP1_GetNodeStrength() == 5 then
--~ 	
--~ 	Rule_AddOneShot(CreateTigerAce, 180)

	end
end



function CreatePanzer()


	
	Util_CreateSquads(player2, sg_e_all, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_reverseHardpoint_point1)
	

end
	
	
function CreateSniper()

	if XP1_GetNodeStrength() >= 3 then

		Util_CreateSquads(player2, {sg_e_all, sg_sniper}, SBP.GERMAN.SNIPER_SQUAD_MP, mkr_reverseHardpoint_point1)
		if Rule_Exists(SpottedSniper) == false then
			Rule_AddInterval(SpottedSniper, 2)
		end

	end

end
	

function CreateJadtiger()

	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.JAGDTIGER_TD_SQUAD_MP, mkr_reverseHardpoint_point1)

end
	
function CreateTigerAce()

	Util_CreateSquads(player2, sg_e_all, SBP.GERMAN.TIGER_ACE_SQUAD_MP, mkr_reverseHardpoint_point1)

end
	

-- Call out events ----------------------------------------------

function SpottedBunker()
	if EGroup_IsEmpty(eg_bunkers) then
		Rule_RemoveMe()
	
	elseif Player_CanSeeEGroup(player1, eg_bunkers, ANY) then
		Util_StartIntel(EVENTS.Bunker)
		Rule_RemoveMe()
	end
end

function SpottedMines()
	if EGroup_IsEmpty(eg_mines) then
		Rule_RemoveMe()
	
	elseif Player_CanSeeEGroup(player1, eg_mines, ANY) then
		Util_StartIntel(EVENTS.Minefield)
		Rule_RemoveMe()
	end
end

function SpottedSniper()
	if Player_CanSeeSGroup(player1, sg_sniper, ANY) then
		Util_StartIntel(EVENTS.Sniper)
		Rule_RemoveMe()
	end
end

function ArtilleryAttack()
	SGroup_Clear(sg_temp)
	Player_GetAll(player1)
	
	if SGroup_IsUnderAttack(sg_allsquads, ANY, 1) then
		SGroup_GetLastAttacker(sg_allsquads, sg_temp, 1)
		
		if SGroup_ContainsSGroup(sg_temp, sg_howitzer, ANY) then
			Util_StartIntel(EVENTS.Artillery)
			Rule_RemoveMe()
		end
	end
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




	
	
-------------------------------------------------------------------------
-- [[ MISSION END ]]
-------------------------------------------------------------------------
--This function is called by the Win conditions scar file. 
--See .../scar/WinConditions/xp1_vpplusannihilate.scar or ...xp1_none.scar
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