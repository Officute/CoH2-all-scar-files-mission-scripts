-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- 1942 Bridge Defense
-- Designer: Ryan McGechaen

-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScarUtil.scar")
import("Systems/AiManager/ai.scar")
import("Prototype/DeploymentPoints.scar")
import("TheatreOfWar.scar")

import("Libraries/WaveDefense.scar")
import("Metrics.scar")
-- [[ IMPORT MISSION SCRIPTS ]]
import("1942_Bridge_Defense_Obj_DEFENDTHBRIDGE.scar")
import("1942_Bridge_Defense_Waves.scar")

-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------
-- DESCRIPTION TEXT "MISSION OBJECTIVES:\n\n-Defend both Victory Points at either end of the bridge.\n\n-If the enemy captures one of the points, or all of your units are lost, you will fail the mission.\n\n-Defend for the number of waves specified based on your chosen difficulty.\n\nSPECIAL CONDITIONS:\n\n-Spend Command Points to call in additional Partisan Squads.\n\n-Activate "We Surrender!" if you find yourself becoming overwhelmed.\n\n-Useful supplies can be found on the map - try to make supply runs between waves."
function OnGameSetup()
	player1 = Setup_Player(1, 11037048 , "soviet", 1)		-- LOCDB [11040470] '327th Rifle Division'
	player5 = Setup_Player(2, 11040471, "german", 2)		-- LOCDB [11040471] '502nd Heavy Panzer Battalion'
	player3 = Setup_Player(3, 11037048, "soviet", 1)		-- player3 is neutral
end

function OnGameRestore()
	Game_DefaultGameRestore()	
end

function OnInit()
	
	--[[ PRESET DEBUG CONDITIONS ]]
	Mission_Debug()
	
	--[[ SET RESTRICTIONS ]]
	Mission_Restrictions()
	
	--[[ SET DIFFICULTY ]]
	Mission_Difficulty()
	
	--[[ MISSION PRESETS ]]
	Mission_MissionPreset()
	
	--[[ SETUP WAVES ]]
	Waves_Init()
	
	--[[ PLAY INTRO NIS]]
--~ 	Util_MissionTitle(LOC("<INTRO NIS>"))		-- Placeholder until NIS is created
--~ 	Util_StartNIS(NIS_OPENING_BLEND)
	
	--[[ GAME START CHECK ]]
	Rule_Add(Mission_MissionStart)
	
end

Scar_AddInit(OnInit)

function Mission_Debug()

	-- looks for the command line option [-debug]
	if Misc_IsCommandLineOptionSet("debug") then
		g_debug = true
	end
	
	-- set up bindings for NISes
--~ 	Scar_DebugConsoleExecute("bind([[ALT+1]], [[Scar_DoString('Util_StartNIS(NIS_OPENING_BLEND)')]])")
--~ 	Scar_DebugConsoleExecute("bind([[ALT+2]], [[Scar_DoString('Util_StartNIS(NIS_CLOSING)')]])")

end

function Mission_Restrictions()

	-- Utilize for setting restrictions on Units, teams, etc
	ToW_SetUpTechTreeByYear(player1, 1942)
	ToW_SetUpTechTreeByYear(player5, 1942)
	
	Cmd_Upgrade(player1, UPG.SOVIET.HQ_MOLOTOV_GRENADE_MP, 1, true)
	
	Player_SetUpgradeAvailability(player1, UPG.GERMAN.BUNKER_COMMAND, ITEM_REMOVED)
	Player_SetUpgradeAvailability(player1, UPG.GERMAN.BUNKER_MEDIC_STATION, ITEM_REMOVED)
	Player_SetUpgradeAvailability(player1, UPG.GERMAN.BUNKER_MG42_ADDITION, ITEM_REMOVED)
	Player_SetAbilityAvailability(player1, ABILITY.GERMAN.PANZER_PANTHER_TIGER_OSTWIND_BLITZKRIEG, ITEM_REMOVED)
	
	Player_AddAbility(player1, BP_GetAbilityBlueprint("dispatch_bridge_partisan"))
	Player_AddAbility(player1, BP_GetAbilityBlueprint("dispatch_bridge_partisan_hmg"))
	Player_AddAbility(player1, BP_GetAbilityBlueprint("dispatch_bridge_partisan_at"))
	Player_AddAbility(player1, BP_GetAbilityBlueprint("dispatch_bridge_partisan_mortar"))
	
	
end

function Mission_Difficulty()
	
	g_difficulty = Game_GetSPDifficulty() 
	
	t_difficulty = {
		manpowerRate		= Util_DifVar( {0.3, 0.4, 0.5, 0.5} ),	
		munitionsRate		= Util_DifVar( {2, 2, 2, 2} ),				-- Munitions rate
		actionRate			= Util_DifVar( {3, 4, 4.5, 4.5} ),			-- Action rate
		
		waves 				= Util_DifVar( {7, 13, 17, 17} ), 			-- How many waves until victory
		
		intermissionTime	= Util_DifVar( {60, 60, 60, 60} ),			-- Time for each intermission
						
		wavesReward			= Util_DifVar( {100, 75, 50, 50} ),		-- Action points reward at the end of each wave
		
		ai_abilityPriority 	= Util_DifVar( {-1, 10, 100, 1000} ),		-- AI ability priority value
		ai_movePathLength	= Util_DifVar( {2, 1, 0.8, 0.6} ),			-- AI Move path length

	}

end

-------------------------------------------------------------------------
-- MISSION Preset 
-------------------------------------------------------------------------

function Mission_MissionPreset()

	-- Kicks off after SCAR Inits, but before MissionStart is called.
	Game_FadeToBlack(FADE_OUT, 0) -- initial fade out for intro movie to hide game interface popping in
	-- Use for spawning units on the map at the start
	World_SetIceHealingRate(0)
	
	FOW_RevealArea(Util_GetPosition(mkr_bridge), 32, 0.5)
	Rule_AddInterval(West_Building_Check, 5)
	Rule_AddInterval(East_Building_Check, 5)
	-- Modify Resource income
	Modify_PlayerResourceRate(player1, RT_Manpower, t_difficulty.manpowerRate)
	Modify_PlayerResourceRate(player1, RT_Munition, t_difficulty.munitionsRate)
	Modify_PlayerResourceRate(player1, RT_Fuel, 0)
	Modify_PlayerResourceRate(player1, RT_Action, 0)
	
	-- Abandoned Vehicle
	SGroup_SetAvgHealth(sg_abandoned, 0.5)
	FOW_RevealSGroupOnly( sg_abandoned, -1) 
	Cmd_CriticalHit(player5, sg_abandoned, CRIT.VEHICLE_LOSE_TREADS_OR_WHEELS, 1.0)
	Cmd_CriticalHit(player5, sg_abandoned, CRIT.VEHICLE_DESTROY_MAINGUN, 1.0)
	Cmd_CriticalHit(player5, sg_abandoned, CRIT.VEHICLE_ABANDON, 1.0)
	Rule_AddInterval(AbandonedTank_AddGunner, 1)
	Rule_AddInterval(AbandonedTank_AddHintPoint, 1)
	
	sg_p_allInfantry = SGroup_CreateIfNotFound("sg_p_allInfantry")
	sg_e_allInfantry = SGroup_CreateIfNotFound("sg_e_allInfantry")
	
	sg_Vehicle = SGroup_CreateIfNotFound("sg_Vehicle")
	sg_Captureable = SGroup_CreateIfNotFound("sg_Captureable")
	sg_playerCaptured = SGroup_CreateIfNotFound("sg_playerCaptured")
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	Rule_AddDelayedInterval(Check_Vehicle_Health, 5, 2)
	
	Util_CreateSquads (player1, sg_p_allInfantry, BP_GetSquadBlueprint("tow_bridge_partisan_squad_base"), mkr_start_sp_01, mkr_start_sp_01, 1)
	Util_CreateSquads (player1, sg_p_allInfantry, BP_GetSquadBlueprint("tow_bridge_partisan_squad_base"), mkr_start_sp_02, mkr_start_sp_02, 1)
	Util_CreateSquads (player1, sg_p_allInfantry, BP_GetSquadBlueprint("tow_bridge_partisan_squad_base"), mkr_start_sp_03, mkr_start_sp_03, 1)
	Util_CreateSquads (player1, sg_p_allInfantry, BP_GetSquadBlueprint("tow_bridge_partisan_squad_base"), mkr_start_sp_04, mkr_start_sp_04, 1)

	sg_e_wave_all = SGroup_CreateIfNotFound("sg_e_wave_all")
	
	-- World Object Setup
	EGroup_SetInvulnerable(eg_bridge, true)
	EGroup_SetSelectable(eg_bridge, false)
	EGroup_SetSelectable(eg_fires, false)

	-- Add Abilities
	Player_AddAbility(player1, BP_GetAbilityBlueprint("ready_up"))
	Player_AddAbility(player1, BP_GetAbilityBlueprint("we_surrender"))

	_disable_We_Surrender()
	_disable_Ready_Up()
	
	-- UI Setup
	Event_Timer(UI_Setup, nil, 1)
	
	-- Player Squad Data
	g_playerSquads = {}
	Rule_AddInterval(_modifyPlayerSquadDropRate, 5)
	
	-- Set Wave Data
	g_currWave = 0

	t_attentionPoints = {
		{wave = 3, text = 11051688},
		{wave = 5, text = 11051690},
		{wave = 6, text = 11051689},
--~ 		{wave = 10, text = 11051692},
		{wave = 11, text = 11051693},
		{wave = 13, text = 11051694},
		{wave = 14, text = 11051691},
		{wave = t_difficulty.waves, text = 11051695, diff = GD_HARD},
	}
	
	Camera_ResetToDefault()
	
	-- Directions
	t_attackDirections = {}
	
	Rule_AddInterval(Mission_Grant_Enemy_Munitions, 1)
	
	-- Random Ammo Spawns
	eg_ammo = EGroup_CreateIfNotFound("eg_ammo")	
	
	t_random_ammo_01 = { mkr_ammo01_01, mkr_ammo01_02, mkr_ammo01_03}
	t_random_ammo_02 = { mkr_ammo02_01, mkr_ammo02_02, mkr_ammo02_03}
	t_random_ammo_03 = { mkr_ammo03_01, mkr_ammo03_02, mkr_ammo03_03}
	t_random_ammo_04 = { mkr_ammo04_01, mkr_ammo04_02, mkr_ammo04_03}
	
	-- AT Gun Random Spawn Positions
	t_AT_Gun_North = { mkr_AT_north_01, mkr_AT_north_02, mkr_AT_north_03}
	t_AT_Gun_South = { mkr_AT_south_01, mkr_AT_south_02, mkr_AT_south_03}
	
	Mission_Random_Item_Spawns() -- Spawn random items
end

-------------------------------------------------------------------------
-- MISSION START 
-------------------------------------------------------------------------

function Mission_MissionStart()
	Rule_RemoveMe()
	Util_PlayMovie("tow_bridgedefense", 1, 2)
end


function UI_Setup()
	-- UI Setup
	UI_SetCPMeterVisibility(false)
end
-- ****Mission Functions****
function Mission_AllUnits_Dead()
	Player_GetAll(player1)
	
	if SGroup_IsEmpty(sg_allsquads) then
		Rule_RemoveMe()
		Rule_Remove(Bridge_Being_Captured)
		
		Util_StartIntel(EVENTS.Mission_Fail_Units_Lost)
		Event_NarrativeEventsNotRunning(Mission_Objective_Fail, nil, 1)
	end
end

function Mission_Objective_Fail()
	Objective_Fail(OBJ_DefendTheBridge)
	Objective_Fail(SOBJ_CurrWave, false)
	
	Event_NarrativeEventsNotRunning(Mission_Fail, nil, 3)
end

function Mission_Fail()
	Game_EndSP(false)
end

function Mission_Complete()
	Rule_AddDelayedInterval(Mission_MissionEnd, 4.5, 1)
end

function Mission_MissionEnd()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		Game_EndSP (true)
	end
end

-- check to see if a players buildings have been destroyed, if they have remove the map entry point
function West_Building_Check()
	if EGroup_Count(eg_west_sp_building) == 0 then
		EGroup_DeSpawn(eg_west_sp)
		Rule_RemoveMe()
	end
end


function East_Building_Check()
	if EGroup_Count(eg_east_sp_building) == 0 then
		EGroup_DeSpawn(eg_east_sp)
		Rule_RemoveMe()
	end
end

function _modifyPlayerSquadDropRate()
	local player1Squads = Player_GetSquads(player1)
	local f = function (gid, idx, squad)
		if Squad_IsValid(squad.id) and Util_TableContains(g_playerSquads, squad.id) == false then
			table.insert(g_playerSquads, squad.id)
			Squad_AddSlotItemToDropOnDeath(squad, SLOT_ITEM.DP_28_LIGHT_MACHINE_GUN_PACKAGE, 0, true)
		end
	end
	SGroup_ForEach(player1Squads, f)
end

--checks to see if a vehicle is capturable
function Check_Vehicle_Health()

	local f = function (gid, idx, squad)
		local random_choice = World_GetRand(0, 3)

		if Squad_GetHealthPercentage(squad) <= 0.4 then
			if random_choice == 0 then
				SGroup_Clear(sg_temp)
				SGroup_Add(sg_temp, squad)
				SGroup_AddGroup(sg_playerCaptured, sg_temp)
				Cmd_CriticalHit(player5, sg_temp, CRIT.VEHICLE_ABANDON, 1)
				SGroup_Remove(sg_Captureable, squad)
			else
				SGroup_Clear(sg_temp)
				SGroup_Add(sg_temp, squad)
				SGroup_Remove(sg_Captureable, squad)
			end
		end
	end

	SGroup_ForEach(sg_Captureable, f)
end


-- ****Bonus Items****
function Mission_Random_Item_Spawns()
	-- Ammo Spawns
	Util_CreateEntities(nil, eg_ammo, BP_GetEntityBlueprint("generic_instantuse_munitions_ammobox_bridge_defense"), Table_GetRandomItem(t_random_ammo_01), 1)
	Util_CreateEntities(nil, eg_ammo, BP_GetEntityBlueprint("generic_instantuse_munitions_ammobox_bridge_defense"), Table_GetRandomItem(t_random_ammo_02), 1)
	Util_CreateEntities(nil, eg_ammo, BP_GetEntityBlueprint("generic_instantuse_munitions_ammobox_bridge_defense"), Table_GetRandomItem(t_random_ammo_03), 1)
	Util_CreateEntities(nil, eg_ammo, BP_GetEntityBlueprint("generic_instantuse_munitions_ammobox_bridge_defense"), Table_GetRandomItem(t_random_ammo_04), 1)
	
	-- AT Gun Spawns
	Util_CreateEntities(nil, eg_ATGun_01, BP_GetEntityBlueprint("pak40_75mm_at_gun"), Table_GetRandomItem(t_AT_Gun_North), 1)
	Util_CreateEntities(nil, eg_ATGun_02, BP_GetEntityBlueprint("pak40_75mm_at_gun"), Table_GetRandomItem(t_AT_Gun_South), 1)
end


-- ****Grant enemy Munitions****
function Mission_Grant_Enemy_Munitions()
	Player_SetResource(player5, RT_Munition, 500)
end

-- ****Abandoned Tank****
function AbandonedTank_AddGunner()
	Player_GetAllSquadsNearMarker(player1, sg_abandoned, mkr_abandoned)
	SGroup_Filter(sg_abandoned, BP_GetSquadBlueprint("panzer_mg_squad"), FILTER_KEEP)
	
	if not SGroup_IsEmpty(sg_abandoned) then
		Rule_RemoveMe()
		Cmd_Upgrade(sg_abandoned, UPG.GERMAN.PANZER_TOP_GUNNER_MP, 1, true)
		
		g_p4_accuracy = Modify_WeaponAccuracy(sg_abandoned, "hardpoint_04", 2)
		g_p4_damage = Modify_WeaponDamage(sg_abandoned, "hardpoint_04", 2)
		
		if hpid_tank ~= nil then HintPoint_Remove(hpid_tank) end
		
		SGroup_SetAvgHealth(sg_abandoned, 0.4)
		
		Rule_AddInterval(AbandonedTank_LoseGunner, 1)
	end
end

function AbandonedTank_LoseGunner()
	if not SGroup_IsEmpty(sg_abandoned) then
		if SGroup_HasCritical(sg_abandoned, CRIT.VEHICLE_KILL_TOP_GUNNER_HARDPOINT_4, ANY) then
			Rule_RemoveMe()
			Entity_RemoveCritical(Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_abandoned, 1), 0), CRIT.VEHICLE_KILL_TOP_GUNNER_HARDPOINT_4)
			
			Modifier_RemoveAllFromSGroup(sg_abandoned)
			
			Cmd_CriticalHit(player5, sg_abandoned, CRIT.VEHICLE_ABANDON, 1.0)
			Rule_AddInterval(AbandonedTank_AddGunner, 1)
		end
	else
		Rule_RemoveMe()
	end
end

function AbandonedTank_AddHintPoint()
	eg_abandoned = EGroup_CreateIfNotFound("eg_abandoned")
	World_GetNeutralEntitiesNearMarker(eg_abandoned, mkr_abandoned)
	
	EGroup_Filter(eg_abandoned, BP_GetEntityBlueprint("panzer_mg"), FILTER_KEEP)
	if not EGroup_IsEmpty(eg_abandoned) then
		Rule_RemoveMe()
		
		
		hpid_tank = HintPoint_Add(eg_abandoned, true, 11051674, 2)
	end
end


-- ****We Surrender! Functions****
-- Eventually we need to move these to the AE
function Bridge_Defense_We_Surrender()
	
	-- Disable the AI so it won't fight our move
	AI_DisableAllEncounters()
	
	-- Collect players and put them into a table
	Player_GetAll(player1, sg_p_allInfantry)
	local t = {}
	
	-- //TEMP// Until we can add new types to units in the AE
	-- We need to fake ceasefire here
	SGroup_SetAutoTargetting(sg_p_allInfantry, "hardpoint_01", false)
	SGroup_SetAutoTargetting(sg_p_allInfantry, "hardpoint_02", false)
	SGroup_SetAutoTargetting(sg_p_allInfantry, "hardpoint_03", false)
	SGroup_SetAutoTargetting(sg_p_allInfantry, "hardpoint_04", false)
	
	local _sortToTable = function(gid, idx, sid)
		table.insert(t, sid)
	end
	
	SGroup_ForEach(sg_p_allInfantry, _sortToTable)
	
	-- Collect enemies
	sg_e_allInfantry = SGroup_CreateIfNotFound("sg_e_allInfantry")
	
	Player_GetAll(player5, sg_e_allInfantry)
	
	-- //TEMP// Until we can add new types to units in the AE
	-- We need to fake ceasefire here
	SGroup_SetAutoTargetting(sg_e_allInfantry, "hardpoint_01", false)
	SGroup_SetAutoTargetting(sg_e_allInfantry, "hardpoint_02", false)
	SGroup_SetAutoTargetting(sg_e_allInfantry, "hardpoint_03", false)
	SGroup_SetAutoTargetting(sg_e_allInfantry, "hardpoint_04", false)
	
	local _moveInfantry = function(gid, idx, sid)
		if not Entity_IsVehicle(Squad_EntityAt(sid, 0)) then
			local tar = World_GetClosest(sid, t)
			if Util_GetDistance(Util_GetPosition(sid), Util_GetPosition(tar)) > 12 then
				local moveTo = Util_GetPositionFromAtoB(Util_GetPosition(tar), Util_GetPosition(sid), 12)
				local group = SGroup_Create("")
				SGroup_Add(group, sid)
				Cmd_Move(group, moveTo)
				SGroup_Destroy(group)
			end
		end
	end
	
	SGroup_ForEach(sg_e_allInfantry, _moveInfantry)
	
	Rule_AddOneShot(_disable_We_Surrender, 10)
	Rule_AddOneShot(_resume_AI_Encounters, 10)
end

function _resume_AI_Encounters()
	AI_EnableAllEncounters()
end

function _enable_We_Surrender()
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("we_surrender"), ITEM_UNLOCKED)
end

function _disable_We_Surrender()
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("we_surrender"), ITEM_LOCKED)
	
	-- //TEMP// Until we can add new types to units in the AE
	-- We need to fake ceasefire here
	if not SGroup_IsEmpty(sg_p_allInfantry) then
		SGroup_SetAutoTargetting(sg_p_allInfantry, "hardpoint_01", true)
		SGroup_SetAutoTargetting(sg_p_allInfantry, "hardpoint_02", true)
		SGroup_SetAutoTargetting(sg_p_allInfantry, "hardpoint_03", true)
		SGroup_SetAutoTargetting(sg_p_allInfantry, "hardpoint_04", true)
	end
	
	if not SGroup_IsEmpty(sg_e_allInfantry) then
		SGroup_SetAutoTargetting(sg_e_allInfantry, "hardpoint_01", true)
		SGroup_SetAutoTargetting(sg_e_allInfantry, "hardpoint_02", true)
		SGroup_SetAutoTargetting(sg_e_allInfantry, "hardpoint_03", true)
		SGroup_SetAutoTargetting(sg_e_allInfantry, "hardpoint_04", true)
	end
end

-------------------------------------------------------------------------
-- WAVES LOGIC
-------------------------------------------------------------------------
function Waves_Init()
	__t_waveDefenseData = {
		-- THE FOLLOWING DATA MUST BE DEFINED BY THE SCRIPTER --
		parentObj = nil,		-- The main objective
		currentWaveObj = nil,			-- Objective for "Defend against Current Wave"
		nextWaveObj = nil,			-- Objective for "Next Wave in"
		
		waveComplete_func = Start_Intermission,			-- Function to call at the start of an intermission
		
		t_attackDirs = {			-- Contains all possible attack direction data. Each chunk is for a different direction
			{		-- North
				{spawn = mkr_attack_northEast_spawn, dynSpawn = mkr_attack_northEast_dyn, ui = mkr_attack_ui_northEast, target = mkr_attack_northCapture},
				{spawn = mkr_attack_north_spawn, dynSpawn = mkr_attack_north_dyn, ui = mkr_attack_ui_north, target = mkr_attack_northCapture},
				{spawn = mkr_attack_northWest_spawn, dynSpawn = mkr_attack_northWest_dyn, ui = mkr_attack_ui_northWest, target = mkr_attack_northCapture},
			},
			{		-- South
				{spawn = mkr_attack_southEast_spawn, dynSpawn = mkr_attack_southEast_dyn, ui = mkr_attack_ui_southEast, target = mkr_attack_southCapture},
				{spawn = mkr_attack_south_spawn, dynSpawn = mkr_attack_south_dyn, ui = mkr_attack_ui_south, target = mkr_attack_southCapture},
				{spawn = mkr_attack_southWest_spawn, dynSpawn = mkr_attack_southWest_dyn, ui = mkr_attack_ui_southWest, target = mkr_attack_southCapture},
			},
			{		-- East
				{spawn = mkr_attack_southEast_spawn, dynSpawn = mkr_attack_southEast_dyn, ui = mkr_attack_ui_southEast, target = mkr_attack_southCapture},
				{spawn = mkr_attack_northEast_spawn, dynSpawn = mkr_attack_northEast_dyn, ui = mkr_attack_ui_northEast, target = mkr_attack_northCapture},
			},
			{		-- West
				{spawn = mkr_attack_southWest_spawn, dynSpawn = mkr_attack_southWest_dyn, ui = mkr_attack_ui_southWest, target = mkr_attack_southCapture},
				{spawn = mkr_attack_northWest_spawn, dynSpawn = mkr_attack_northWest_dyn, ui = mkr_attack_ui_northWest, target = mkr_attack_northCapture},
			},
			{		-- North/South Cross
				{spawn = mkr_attack_southWest_spawn, dynSpawn = mkr_attack_southWest_dyn, ui = mkr_attack_ui_southWest, target = mkr_attack_northCapture},
				{spawn = mkr_attack_northEast_spawn, dynSpawn = mkr_attack_northEast_dyn, ui = mkr_attack_ui_northEast, target = mkr_attack_southCapture},
			},
		},	
		
		t_retreatDirs = {mkr_attack_northEast_spawn, mkr_attack_north_spawn, mkr_attack_northWest_spawn,
							 mkr_attack_southEast_spawn, mkr_attack_south_spawn, mkr_attack_southWest_spawn},
		
		-- Optional Data		
		warningLevel = WARNING_HIGH,				-- WARNING_NONE, WARNING_LOW, WARNING_HIGH is amount of warning the player gets for each attack direction
		warningLow = 11051675,		-- Customize warning text for WARNING_LOW
		warningHigh = {							-- Customize warning text for WARNING_HIGH
			{warning = WAVE_INFANTRY, text = 11051676},
			{warning = WAVE_VEHICLES, text = 11051677},
			{warning = WAVE_MIXED, text = 11051678},
			{warning = WAVE_ARTILLERY, text = 11051813},
		},
		
		commandSGroup = nil,		-- The SGroup all wave units are assigned to
		
		waveCompleteCondition = {
			condition = CONDITION_UNITS_LEFT,
			variable = 5,
			wave_retreats = true,
			vehicle = 0,
		},
		
		goalData = {				-- Goal Data for the attack waves
			name = "Attack",
			target = nil,
			range = 5,
			leashRange = 15,
			attackMove = true,
			coordinatedSetup = false,
			tacticControlsList = {{tacticType = TACTIC_Pickup, priority = -1},
								  {tacticType = TACTIC_Recrew, priority = -1},
								  {tacticType = TACTIC_CaptureTeamWeapon, priority = -1},
								  {tacticType = TACTIC_RushAtTarget, priority = -1},
								  {tacticType = TACTIC_Ability, priority = t_difficulty.ai_abilityPriority},},
			movePathLengthFactor = t_difficulty.ai_movePathLength,
		},
		
		--************************************************
		-- THE FOLLOWING DATA IS INTERNAL: DO NOT TOUCH --
		t_spawnWarnings = {},		-- Used for warning markers
		
		t_waves = {},				-- Contains the waves (Defined in accompanied file)
			
		waveCounter = 0,			-- Tracks which wave we're on
	}
	
	-- Defining some Alias for directions
	
	NORTH = 1
	SOUTH = 2
	EAST = 3
	WEST = 4
	CROSS = 5
	
	RANDOM_DIRECTION = World_GetRand(1,2)
	
	Waves_Setup()

end


