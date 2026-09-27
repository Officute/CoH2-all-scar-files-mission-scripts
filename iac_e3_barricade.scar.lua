-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- E3 Barricade/Beta City17 - A Not-so-faithful recreation
-- Proper Mission
-- Designer: Dr.Epav, with scripting help from Janne252
-- "Kiitos kaveri"
--

-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScarUtil.scar")									-- Scar functionality
import("Systems/AiManager/ai.scar")						-- Encounter system
import("Prototype/DeploymentPoints.scar")
import("Beginner.scar")								-- BeginnerHint system
import("Global_Values/CampaignGlobalConstants.scar")	-- Global values used throughout the game
import("TheatreOfWar.scar")								-- Theater of War Functions
import("Prototype/SpecialAEFunctions.scar")				-- Special functions called from the AE
--~	import("IAC_E3_Barricade_combatplan.scar")				-- Dynamic command AI to replace encounter ai
import("IAC_E3_Barricade_encounter_data.scar")				-- Ecounter data

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------

function OnGameSetup( )
	print("Running OnGameSetup...")
	-----------------------------------------
	-- None of this is supported in MP, sadly.
	-- player1 = Setup_Player(1, "Rebels", "soviet", 1)	-- 
	--
	-- player3 = Setup_Player(3, 11040473, "german", 3) -- 
	--
	--
	-- player1name = Player_GetDisplayName(1)
	-- player3name = Player_GetDisplayName(3)
	-----------------------------------------
	player1 = World_GetPlayerAt(1) -- Player
	player2 = World_GetPlayerAt(2) -- Ally
	player3 = World_GetPlayerAt(3) -- Enemy Main
	player4 = World_GetPlayerAt(4) -- Enemy for abilities
	
end

function OnGameRestore()
	-- function takes care of restoring all global mission parameters after a save/load
	print("Restoring game from a saved session...")
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	player4 = World_GetPlayerAt(4)
	
	Game_DefaultGameRestore()
	-- Util_RestoreMusic()
end

-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------
-- Main initialization routine. Called 1 frame after all files have been loaded.

function OnInit()
	print("Initializing mission...")
	
	--[[ SET RESTRICTIONS ]]
	Mission_Restrictions()
	
	--[[ SET MODIFIERS ]]
	Mission_Modifiers()
	
	--[[ SET ABILITIES ]]
	Mission_Abilities()
	
	--[[ MISSION PRESETS ]]
	Mission_MissionPreset()
	
	--[[ MISSION DIFFICULTY ]]
	Mission_Difficulty()
	
	--[[ MISSION START ]]
	Mission_Start()
	
	--[[ REGISTER OBJECTIVES ]]
	-- Main obj
	INIT_MainOBJ()
	Objective_Start(OBJ_Main)
	
	-- Barricade obj
	INIT_BarricadeSOBJ()
	Objective_Start(SOBJ_Barricade, false)
	
	-- Park OBJ
	INIT_ParkSOBJ()
	INIT_HoldParkSOBJ()
	
	-- Trainstation OBJ
	INIT_TrainstationSOBJ()
	INIT_TrainstationSOBJ_bonus()
	
	--[[ REGISTER HINTS ]]

	
	print("Mission initialization finished.")
end

Scar_AddInit(OnInit)
	print("Scar actions executing...")
	
function Mission_Restrictions()	
	-- Player 1
	
	Player_SetCommandAvailability(player1, SCMD_Retreat, ITEM_LOCKED)
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("312430cd68d346ad8badb0bc1ef14b77:sp_mission_type_02"))
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_missions"))
	
	-- Player 2 Ally
	
	-- Player_SetCommandAvailability(player2, SCMD_Retreat, ITEM_LOCKED)
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("upgrade/campaign/disable_abandon_critical"))
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_missions"))
	
	-- Player 3 Main Enemy
	
	-- Player_SetCommandAvailability(player3, SCMD_Retreat, ITEM_LOCKED)
	Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("upgrade/campaign/disable_abandon_critical"))
	Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_missions"))
	
	-- Player 4 Enemy
	
	-- Player_SetCommandAvailability(player4, SCMD_Retreat, ITEM_LOCKED)
	-- Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("upgrade/campaign/disable_abandon_critical"))
	Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_missions"))
	
	local sbps = {SBP.GERMAN.BRUMMBAR_SQUAD, SBP.GERMAN.ELEFANT_TANK_DESTROYER_SQUAD}
	for i = 1, table.getn(sbps) do
		Player_SetSquadProductionAvailability(player4, sbps[i], ITEM_LOCKED)
	end
	
end

function Mission_Modifiers()
	-- Player 1
	Modify_PlayerResourceRate(player1, RT_Manpower, 0.0)
	Modify_PlayerResourceRate(player1, RT_Munition, 0.0)
	Modify_PlayerResourceRate(player1, RT_Fuel, 0.0)
	Modify_PlayerResourceRate(player1, RT_Action, 0.0, MUT_Multiplication) -- Command points are granted on obj completion
	Player_SetResource(player1, RT_Command, 0)
	Player_SetPopCapOverride(player1, 10)
	-- Player 2
	Modify_PlayerResourceRate(player2, RT_Manpower, 1.0)
	Modify_PlayerResourceRate(player2, RT_Munition, 0.5)
	Modify_PlayerResourceRate(player2, RT_Fuel, 0.5)
	-- Player 3
	Modify_PlayerResourceRate(player3, RT_Manpower, 0.0)
	Modify_PlayerResourceRate(player3, RT_Munition, 0.0)
	Modify_PlayerResourceRate(player3, RT_Fuel, 0.0)
	-- Player 4
	Modify_PlayerResourceRate(player4, RT_Manpower, 1.0)
	Modify_PlayerResourceRate(player4, RT_Munition, 1.25)
	Modify_PlayerResourceRate(player4, RT_Fuel, 0.8)

end

function Mission_Abilities()
	-- Add Abilities
	-- Player 1 (player)
	Player_AddAbility(player1, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_conscript_dispatch"))
	Player_AddAbility(player1, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_rebel_dispatch"))
	-- Player 2 (ally)
	Player_AddAbility(player2, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_conscript_dispatch"))
	Player_AddAbility(player2, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_rebel_dispatch"))
	
	-- Axis Players
	Player_AddAbility(player3, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:seafloor_gunship_ability"))
	Player_AddAbility(player3, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_creeping_barrage_single"))
	Player_AddAbility(player3, BP_GetAbilityBlueprint("m01_stuka_dogfight_pass"))
	Player_AddAbility(player3, BP_GetAbilityBlueprint("stuka_aerial_superiority_recon"))
	
--~	Player_AddAbility(player4, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:seafloor_gunship_ability"))
	Player_AddAbility(player4, BP_GetAbilityBlueprint("m01_stuka_dogfight_pass"))
	
	-- Add Upgrades
	Cmd_Upgrade(player1, BP_GetUpgradeBlueprint("shock_prevent_pin"), 1, true)
	-- Modify_AbilityMaxCastRange(player1, ABILITY.SOVIET.CONSCRIPT_MOLOTOV_COCKTAIL, 0.75)
end

-------------------------------------------------------------------------
-- MISSION Preset 
-------------------------------------------------------------------------
-- Kicks off after SCAR Inits, but before MissionStart is called.
-- Use for spawning units on the map at the start

function Mission_MissionPreset()
	print("Scar initialized.")
	print("Mission Preset activating...")
	
	-- Spawn HQs
	-- eg_player_hq = EGroup_CreateIfNotFound("eg_player_hq")
	-- eg_ally_hq = EGroup_CreateIfNotFound("eg_ally_hq")
	-- eg_soviet_hqs = EGroup_CreateIfNotFound("eg_soviet_hqs")
	-- Util_CreateEntities(player1, {eg_player_hq, eg_soviet_hqs}, BP_GetEntityBlueprint("312430cd68d346ad8badb0bc1ef14b77:hq_sp_m01"), mkr_p_hqSpawn, 1, nil)
	-- Util_CreateEntities(player2, {eg_ally_hq, eg_soviet_hqs}, BP_GetEntityBlueprint("312430cd68d346ad8badb0bc1ef14b77:hq_sp_m01_ai"), mkr_a_hqSpawn, 1, nil)
	-- Axis
	-- eg_main_enemy_hq = EGroup_CreateIfNotFound("eg_main_enemy_hq")
	-- eg_support_enemy_hq = EGroup_CreateIfNotFound("eg_support_enemy_hq")
	-- eg_axis_hqs = EGroup_CreateIfNotFound("eg_axis_hqs")
	-- Util_CreateEntities(player3, {eg_support_enemy_hq, eg_axis_hqs}, BP_GetEntityBlueprint("312430cd68d346ad8badb0bc1ef14b77:german_hq_sp"), mkr_e_hqSpawn_1, 1, nil)
	-- Util_CreateEntities(player4, {eg_main_enemy_hq, eg_axis_hqs}, BP_GetEntityBlueprint("312430cd68d346ad8badb0bc1ef14b77:german_hq_sp"), mkr_e_hqSpawn_2, 1, nil)
	
 	Sound_SetMusicCombatValue(3, 60*9999999)
	
	AI_Enable(player2, false)  -- Disable ai before mission start to prevent moves
	AI_Enable(player3, false)
	--~ AI_Enable(player4, false)
	-- Set SP ai type
	AI_SetPersonality(player2, "default_campaign")
	AI_SetPersonality(player3, "default_campaign")
	AI_SetPersonality(player4, "default_campaign")
	AI_SetStaggeredSpawnDelay(1)
	
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	eg_temp = EGroup_CreateIfNotFound("eg_temp")
	
	-- Setup Camera
	Camera_SetDefault(40, 40, 5)  -- first is height, second is declination, last is angle/rotation
	Camera_ResetToDefault()
	
	-- Set Egroups invulnerable
	EGroup_SetInvulnerable(eg_invuln, true)
	
	-- Set Sgroups invulnerable
	
	-- Misc
	EGroup_DeSpawn(mb_barricade)
----------------------------------------------------------------------------------------
	--------------------------
	-- Spawn Player Units
	--------------------------
	sg_player_all = SGroup_CreateIfNotFound("sg_player_all")
	sg_player_01 = SGroup_CreateIfNotFound("sg_player_01") -- Morgan
	sg_player_02 = SGroup_CreateIfNotFound("sg_player_02") -- Morgan's followers
	
	-- Barricade Start
	Util_CreateSquads(player1, {sg_player_all, sg_player_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:morgan_squad_city17"), mkr_start_spawn, mkr_start_dest01, 1)
	print("Starting Player Units spawned.")
	
	--------------------------
	-- Spawn Ally Units
	--------------------------
	sg_ally_all = SGroup_CreateIfNotFound("sg_ally_all")
	sg_ally_barricade_all = SGroup_CreateIfNotFound("sg_ally_barricade_all")
	sg_ally_barricade_01 = SGroup_CreateIfNotFound("sg_ally_barricade_01") -- Bernoi's squad
	sg_ally_barricade_02 = SGroup_CreateIfNotFound("sg_ally_barricade_02") -- Gameplay-Affecting
	sg_ally_barricade_03 = SGroup_CreateIfNotFound("sg_ally_barricade_03") -- For looks
	sg_ally_barricade_04 = SGroup_CreateIfNotFound("sg_ally_barricade_04") -- Purely for scripts
	SGroup_EnableUIDecorator(sg_ally_barricade_02, false)
	SGroup_EnableUIDecorator(sg_ally_barricade_03, false)
	SGroup_EnableUIDecorator(sg_ally_barricade_04, false)
	
	-- Barricade Start
	Util_CreateSquads(player2, {sg_ally_barricade_all, sg_ally_barricade_01, sg_ally_all}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:bernoi_squad_city17"), mkr_start_spawn, mkr_start_dest_pause, 1, 3, true)
	Util_CreateSquads(player2, {sg_ally_barricade_all, sg_ally_barricade_02, sg_ally_all}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:partisan_squad_city17"), mkr_ally_entry01, mkr_ally_dest_barricade_back, 1, 3, false)
	Util_CreateSquads(player2, {sg_ally_barricade_all, sg_ally_barricade_03, sg_ally_all}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:partisan_squad_city17_harmless"), mkr_ally_spawn_barricade_01, mkr_ally_dest_flank_barricade, 1, 4, true)
	
	-- Bernoi MTR
	Rule_AddOneShot(Barricade_Bernoi_MIR, 3.5)
	
	print("Starting Ally Units spawned.")
	--------------------------
	-- Spawn Axis units
	--------------------------
	sg_enemy_all = SGroup_CreateIfNotFound("sg_enemy_all")
	sg_enemy_barricade_all = SGroup_CreateIfNotFound("sg_enemy_barricade_all")
	sg_enemy_barricade_01 = SGroup_CreateIfNotFound("sg_enemy_barricade_01") -- Shooting troops behind barricade
	sg_enemy_barricade_02 = SGroup_CreateIfNotFound("sg_enemy_barricade_02") -- Guys who die from grenade
	sg_enemy_barricade_03 = SGroup_CreateIfNotFound("sg_enemy_barricade_03") -- Everybody else
	sg_enemy_barricade_tiger = SGroup_CreateIfNotFound("sg_enemy_barricade_tiger") -- Tiger that pursues player
	
	-- Barricade
	Util_CreateSquads(player3, {sg_enemy_barricade_all, sg_enemy_barricade_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_barricade_01, nil, 1, 3, false)
	Util_CreateSquads(player3, {sg_enemy_barricade_all, sg_enemy_barricade_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_barricade_02, nil, 1, 3, false)
	Util_CreateSquads(player3, {sg_enemy_barricade_all, sg_enemy_barricade_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_barricade_03, nil, 1, 2, false)
	
	-- Outside Barricade
	Util_CreateSquads(player3, {sg_enemy_barricade_all, sg_enemy_barricade_02}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_barricade_04, nil, 1, 2, false)
	
	-- Flare troops

	-- Tiger
	
	-- Extras
	
	-- Traps

	
	print("Starting Axis Units spawned.")
	
	-- World/Neutral objects
	world_object_spawns = EGroup_CreateIfNotFound("world_object_spawns")
	world_caches = EGroup_CreateIfNotFound("world_caches") -- Hidden supply caches
	
	Util_CreateEntities(nil, {world_object_spawns, world_caches}, BP_GetEntityBlueprint("312430cd68d346ad8badb0bc1ef14b77:supply_cache_sp"), mkr_world_cache_01, 1, nil)
	Util_CreateEntities(nil, {world_object_spawns, world_caches}, BP_GetEntityBlueprint("312430cd68d346ad8badb0bc1ef14b77:supply_cache_sp"), mkr_world_cache_02, 1, nil)
	Util_CreateEntities(nil, {world_object_spawns, world_caches}, BP_GetEntityBlueprint("312430cd68d346ad8badb0bc1ef14b77:supply_cache_sp"), mkr_world_cache_03, 1, nil)
	Util_CreateEntities(nil, {world_object_spawns, world_caches}, BP_GetEntityBlueprint("312430cd68d346ad8badb0bc1ef14b77:supply_cache_sp"), mkr_world_cache_04, 1, nil)
	Util_CreateEntities(nil, {world_object_spawns, world_caches}, BP_GetEntityBlueprint("312430cd68d346ad8badb0bc1ef14b77:supply_cache_sp"), mkr_world_cache_05, 1, nil)
	Util_CreateEntities(nil, {world_object_spawns, world_caches}, BP_GetEntityBlueprint("312430cd68d346ad8badb0bc1ef14b77:supply_cache_sp"), mkr_world_cache_06, 1, nil)
	Util_CreateEntities(nil, {world_object_spawns, world_caches}, BP_GetEntityBlueprint("312430cd68d346ad8badb0bc1ef14b77:supply_cache_sp"), mkr_world_cache_07, 1, nil)
	
	print("World objects spawned.")
	
	-- Disable holds
	Modify_DisableHold(eg_hold_disable, true)
	mod_eg_park_player_hq = Modify_DisableHold(eg_park_player_hq, true)
	 
	-- Apply modifiers to squads
	Rule_AddOneShot(Barricade_Modifiers, 0)
	
	-- create temp groups for functions
	eg_temp = EGroup_CreateIfNotFound("eg_temp")
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	sg_temp2 = SGroup_CreateIfNotFound("sg_temp2")
	
	-------------------------------
	-- Set global variables
	-------------------------------
	g_missionFailed = false
	useEncounterSystem = true
	g_useSkirmishAI = true
	g_useWithdraw = true
	g_AUTOSAVE_DELAY = 10
----------------------------------------------------------------------------------------
	print("Mission Preset activated.")
end

function Intro_Start()
		g_intro_start = true
		Game_FadeToBlack(FADE_OUT, 0.0)
		Game_FadeToBlack(FADE_IN, 3.5)
		-- Game_Letterbox(true, 0.5)
		Game_SetMode(UI_Fullscreen)
end

function Intro_End()
		g_intro_start = false
		g_intro_end = true
		-- Game_Letterbox(false, 2)
		Game_SetMode(UI_Normal)
		Util_StartIntel(EVENTS.CLOSE_IN)
end

function Mission_Difficulty()
	-- Get AI difficulty
	g_Main_Difficulty = AI_GetDifficulty(player3)
	-- Main CPU
	if g_Main_Difficulty == AD_Hardest then
	-------------
	-- Barricade
	-------------
	g_damage_barricade_enemy = 0.9
	-------------
	-- Pursuit
	-------------
	Pursuit_loadout01 = World_GetRand(3, 4)
	-------------
	-- Park
	-------------
	Park_loadout01 = World_GetRand(3, 4)
	Park_Counterattack_loadout01 = World_GetRand(4, 5)
	Park_Counterattack_loadout02 = 5
	Park_Counterattack_wave2_delay = 25
	Park_Counterattack_wave3_delay = 12
	Park_Counterattack_Allies_delay = 35
	g_accuracy_park_wave1 = 1.3
	g_accuracy_park_wave2 = 1.1
	g_rec_damage_park_wave2 = 0.8
	g_rec_damage_park_puma = 1.0
	----------------
	-- Trainstation
	----------------
	Trainstation_bonus_loadout01 = World_GetRand(4, 5)
	Trainstation_bonus_loadout02 = World_GetRand(2, 3)
	g_truck_depart_time = 180
	Trainstation_loadout01 = 5
	Trainstation_loadout02 = World_GetRand(3, 4)
	Trainstation_loadout03 = World_GetRand(2, 3)
	g_damage_trainstation_1 = 1.0
	g_damage_trainstation_2 = 1.05
	-------------
	-- Global
	-------------
	g_hardDiff = true
	g_encounter_limited_respawn = 3
	g_player_grant_mp_1 = 100
	g_player_grant_mu_1 = 15
	AIBaseGoal_SetDefaultGoalData(g_defaultGoalData_attackHard)
	AIAttackGoal_SetDefaultGoalData(g_defaultGoalData_attackHard)
	AIDefendGoal_SetDefaultGoalData(g_defaultGoalData_defendHard)
	AI_SetDifficulty(player4, AD_Hard)
	end
	----------------------------------------------------
	if g_Main_Difficulty == AD_Hard then
	
	-------------
	-- Barricade
	-------------
	g_damage_barricade_enemy = 0.8
	-------------
	-- Pursuit
	-------------
	Pursuit_loadout01 = World_GetRand(2, 3)
	-------------
	-- Park
	-------------
	Park_loadout01 = World_GetRand(2, 4)
	Park_Counterattack_loadout01 = World_GetRand(3, 5)
	Park_Counterattack_loadout02 = World_GetRand(4, 5)
	Park_Counterattack_wave2_delay = 35
	Park_Counterattack_wave3_delay = 18
	Park_Counterattack_Allies_delay = 30
	g_accuracy_park_wave1 = 1.1
	g_accuracy_park_wave2 = 1.0
	g_rec_damage_park_wave2 = 0.9
	g_rec_damage_park_puma = 0.9
	----------------
	-- Trainstation
	----------------
	Trainstation_bonus_loadout01 = World_GetRand(3, 4)
	Trainstation_bonus_loadout02 = World_GetRand(1, 2)
	g_truck_depart_time = 300
	Trainstation_loadout01 = World_GetRand(4, 5)
	Trainstation_loadout02 = World_GetRand(3, 4)
	Trainstation_loadout03 = World_GetRand(2, 3)
	g_damage_trainstation_1 = 0.9
	g_damage_trainstation_2 = 0.95
	-------------
	-- Global
	-------------
	g_hardDiff = true
	g_encounter_limited_respawn = 2
	g_player_grant_mp_1 = 100
	g_player_grant_mu_1 = 20
	AIBaseGoal_SetDefaultGoalData(g_defaultGoalData_attackHard)
	AIAttackGoal_SetDefaultGoalData(g_defaultGoalData_attackHard)
	AIDefendGoal_SetDefaultGoalData(g_defaultGoalData_defendHard)
	AI_SetDifficulty(player4, AD_Hard)
	end
	----------------------------------------------------
	if g_Main_Difficulty == AD_Standard or AD_Easy then
	-------------
	-- Barricade
	-------------
	g_damage_barricade_enemy = 0.7
	-------------
	-- Pursuit
	-------------
	Pursuit_loadout01 = World_GetRand(2, 3)
	-------------
	-- Park
	-------------
	Park_loadout01 = World_GetRand(2, 3)
	Park_Counterattack_loadout01 = World_GetRand(3, 4)
	Park_Counterattack_loadout02 = World_GetRand(3, 5)
	Park_Counterattack_wave2_delay = 40
	Park_Counterattack_wave3_delay = 20
	Park_Counterattack_Allies_delay = 25
	g_accuracy_park_wave1 = 0.95
	g_accuracy_park_wave2 = 0.9
	g_rec_damage_park_wave2 = 0.9
	g_rec_damage_park_puma = 0.8
	----------------
	-- Trainstation
	----------------
	Trainstation_bonus_loadout01 = World_GetRand(3, 4)
	Trainstation_bonus_loadout02 = World_GetRand(1, 2)
	g_truck_depart_time = 360
	Trainstation_loadout01 = World_GetRand(3, 5)
	Trainstation_loadout02 = World_GetRand(2, 4)
	Trainstation_loadout03 = World_GetRand(2, 3)
	g_damage_trainstation_1 = 0.8
	g_damage_trainstation_2 = 0.9
	-------------
	-- Global
	-------------
	g_encounter_limited_respawn = 2
	g_player_grant_mp_1 = 200
	g_player_grant_mu_1 = 25
	AIBaseGoal_SetDefaultGoalData(g_defaultGoalData_attackEasy)
	AIAttackGoal_SetDefaultGoalData(g_defaultGoalData_attackEasy)
	AIDefendGoal_SetDefaultGoalData(g_defaultGoalData_defendEasy)
	AI_SetDifficulty(player4, AD_Standard)
	end
	----------------------------------------------------
	

end

function Mission_Start()
	print("Almost home free, mission is starting...")
	-- Hide CP Meter
	UI_SetCPMeterVisibility(true)
	
	-- Set needed variables
	
	-- Mood
	-- Player_SetDefaultSquadMoodMode(player1, MM_ForceTense)
	Player_SetDefaultSquadMoodMode(player2, MM_ForceTense)
	Player_SetDefaultSquadMoodMode(player3, MM_ForceTense)
	-- Player_SetDefaultSquadMoodMode(player4, MM_ForceTense)
	
	-- Disable Experience
	Modify_PlayerExperienceReceived(player2, 0)
	Modify_PlayerExperienceReceived(player3, 0)
	Modify_PlayerExperienceReceived(player4, 0)
	
	-- Music
	-- Sound_StopMusic(1.0, 0.5)
	
	-- Set resources
	-- Player
	Player_SetResource(player1, RT_Munition, 30)
	Player_SetResource(player1, RT_Manpower, 100)
	Player_SetResource(player1, RT_Fuel, 25)
	Player_SetResource(player1, RT_Popcap, 20)
	
	-- Ally
	
	-- Enemy
	
	print("Mission settings are all set, any errors from this point on are related to special functions and objectives.")
	
	-- Start playercheck
	Rule_Add(Player_Check, 900)
	
	if(not Event_Exists(Barricade_endcheck)) then
		Rule_RemoveMe()
		
		-- Fade in with flying camera
		-- Game_Letterbox(true, 1)
		-- Game_FadeToBlack(FADE_OUT, 0.125)
		Rule_AddOneShot(Intro_Start, 0.0)
		Rule_AddOneShot(Intro_End, 4.5)
		
		-- Start the barricade scripts
		Rule_AddOneShot(Barricade_Start, 0.125, 900)
		
		-- Objective_Start(SOBJ_Barricade, false, false)
	end
end

--------------------------
-- Ambient Events
--------------------------
function Barricade_camerazoom() Camera_MoveTo(Util_GetPosition(sg_enemy_barricade_01), false, 0.5, false, false) end

function _vulnHMG(data)
	SGroup_SetInvulnerable(data.sgroup, false)
	Modify_Vulnerability(data.sgroup, 5)
--~ 	SGroup_Kill(data.sgroup)
end

function _hmg_findSquad()
	sg_hmg_ally_squad = SGroup_CreateIfNotFound("sg_hmg_ally_squad")
	
	if SGroup_IsEmpty(sg_ally_park_04) then Rule_AddOneShot(_hmg_findSquad, 2) end
	
	local squad = SGroup_GetRandomSpawnedSquad(sg_ally_park_04)
	SGroup_Remove(sg_ally_park_04, squad)
	SGroup_Add(sg_hmg_ally_squad, squad)
	
	SGroup_SetInvulnerable(sg_hmg_ally_squad, true)
	Cmd_Move(sg_hmg_ally_squad, mkr_hmg_vault_02_dest)
	Command_SquadEntity(player3, sg_hmg_vault_squad, SCMD_Move, eg_hmg_vault_01, true)
	Cmd_Move(sg_hmg_ally_squad, mkr_hmg_kill_dest_02, true)
	
	Cmd_Upgrade(sg_hmg_ally_squad, BP_GetUpgradeBlueprint("m01_hmg_death_squad_upgrade"), 1, true)
	
	eventID_vaulnVaultSquad = Event_Proximity(_vulnHMG, {sgroup = sg_hmg_vault_squad}, sg_hmg_vault_squad, mkr_hmg_vault_vauln, nil, ANY)
	
	Event_GroupIsDead(_hmg_findSquad, nil, sg_hmg_ally_squad, 6)
	
end

function Ambient_Stukas()

	if Timer_Exists(tmr_amb_Stukas) then
		if Timer_GetRemaining(tmr_amb_Stukas) == 0 then
			Timer_End(tmr_amb_Stukas)
			
			local num = 1
			local compass = Marker_GetTable("mkr_compass_%02d")
			
			for i = 1, num do
				local dir = Table_GetRandomItem(compass)
				Command_PlayerPosDirAbility(player3, player3, Util_GetRandomPosition(_stuka_Area), Marker_GetDirection(dir), _stuka_Ability, true)
			end
		end
	else
		Timer_Start(tmr_amb_Stukas, World_GetRand(g_stuka_freq_min, g_stuka_freq_max))
	end	
end

--
--********************************************************************************************************
----------------------------------- Additional Startup Functions/Scripts ---------------------------------
--********************************************************************************************************
--
---------------------------
-- Barricade
---------------------------
function Barricade_Modifiers()
	-- Player
	Modify_ReceivedDamage(sg_player_01, 0.6)
	
	-- Enemy
	-- SGroup_SetInvulnerable(sg_enemy_barricade_01, 0.5)
	Modify_ReceivedAccuracy(sg_enemy_barricade_01, 0.4)
	Modify_ReceivedAccuracy(sg_enemy_barricade_02, 0.5)
	Modify_WeaponDamage(sg_enemy_barricade_01, "hardpoint_01", g_damage_barricade_enemy)
	
	-- Allies
	SGroup_SetInvulnerable(sg_ally_barricade_01, 0.75)
	SGroup_SetInvulnerable(sg_ally_barricade_02, 0.5)
	Modify_ReceivedDamage(sg_ally_barricade_02, 0.9)
	Modify_ReceivedDamage(sg_ally_barricade_03, 1.25)
	Modify_TargetPriority(sg_ally_barricade_03, 25)
	Rule_RemoveMe()
	
	print("Modifiers applied to barricade troops.")
end

function Barricade_DisableModifiers()
	-- Player
	Modify_ReceivedDamage(sg_player_01, 0.9)
	
	-- Enemy
	-- SGroup_SetInvulnerable(sg_enemy_barricade_01, false)
	Modifier_RemoveAllFromSGroup(sg_enemy_barricade_01)
	Modify_WeaponDamage(sg_enemy_barricade_01, "hardpoint_01", 0.6)
	
	-- Allies
	SGroup_SetInvulnerable(sg_ally_barricade_01, false)
	SGroup_SetInvulnerable(sg_ally_barricade_02, false)
	-- Modify_ReceivedDamage(sg_ally_barricade_02, 0.9)
	-- Modify_ReceivedDamage(sg_ally_barricade_03, 1.0)
	-- Modify_TargetPriority(sg_ally_barricade_03, -15)
	Rule_RemoveMe()
	
	print("Modifiers removed from barricade troops.")
end

function Barricade_Bernoi_MIR() -- MTR - Move Into Range
	Cmd_Move(sg_ally_barricade_01, mkr_start_dest01) -- Move Barno and his pals into firing range
	-- Maybe add some speech or something?
	-- Actor_SetFromSGroup(actor, sg_ally_barricade_01)
	
	Cmd_Move(sg_player_01, mkr_start_dest_pause) -- Move player into firing range
	FOW_RevealSGroupOnly(sg_enemy_barricade_01, 10)  -- Reveal squads
end

--------------------------
function Hint_Barricade_Grenade()
	if Event_Exists(Barricade_player_grenade) then
		hpid_barricade_grenade = HintPoint_Add(mkr_hint_barricade_grenade, true, 11035295, nil, HPAT_Objective)
		haid_barricade_grenade = UI_FlashAbilityButton(BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_grenade"), true)
		Event_Timer(_StopFlashing, {id = haid_barricade_grenade}, 5)
		Barricade_hint_grenade = Event_GroupIsDead(Hint_Barricade_Grenade_Stop, nil, sg_enemy_barricade_02, 0, false) -- Someone has killed grenade guys
	end
end

function Hint_Barricade_Grenade_Stop()
	if Event_Exists(Barricade_hint_grenade) then Event_Remove(Barricade_hint_grenade) end
	-- UI_StopFlashing(haid_barricade_grenade) 
	HintPoint_Remove(hpid_barricade_grenade)
end

--------------------------
function Barricade_Allies_moveup_01()
	-- End check
	if Event_Exists(Barricade_player_grenade) then Event_Remove(Barricade_player_grenade) end
	
	-- Start hint after player has idled too long
	Rule_AddOneShot(Hint_Barricade_Flank, 20)
	
	-- Leap-frog type move
	Util_Delay(4, function()
    Cmd_Move(sg_ally_barricade_01, mkr_ally_dest_barricade_middle) -- Move Barno and his pal up
	end)
	
	-- Cmd_Move(sg_ally_barricade_01, mkr_ally_dest_barricade_middle) -- Old move order
	Cmd_Move(sg_ally_barricade_02, mkr_start_dest01) -- Move other guys up
	print("Allies moving up 1")
end

--------------------------
function Hint_Barricade_Flank()
	if Event_Exists(Barricade_player_ruins) then
		hpid_barricade_flank = HintPoint_Add(mkr_hint_barricade_flank, true, 11036469)
		haid_barricade_flank = UI_FlashAbilityButton(BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_morgan_sprint"), true)
		Event_Timer(_StopFlashing, {id = haid_barricade_flank}, 5)
		Barricade_hint_flank = Event_Proximity(Hint_Barricade_Flank_Stop, nil, player1, mkr_player_trigger_barricade_ruins, nil, ANY) -- Player has entered ruins
		Util_StartIntel(EVENTS.BARRICADE_REMIND)
	end
end

function Hint_Barricade_Flank_Stop()
	if Event_Exists(Barricade_hint_flank) then Event_Remove(Barricade_hint_flank) end
	HintPoint_Remove(hpid_barricade_flank)
end
--------------------------

function Barricade_Allies_moveup_02()

	-- If Player ran past guys
	if Event_Exists(Barricade_player_grenade) then 
		Event_Remove(Barricade_player_grenade)
		-- Leap-frog type move
		Cmd_Move(sg_ally_barricade_01, mkr_ally_dest_barricade_middle) -- Move Barno and his pal up
		Cmd_Move(sg_ally_barricade_02, mkr_start_dest01) -- Move other guys up
	end
		
	if SGroup_IsAlive(sg_enemy_barricade_02) == true then
		SGroup_Kill(sg_enemy_barricade_02)
	end
	
	-- End check
	if Event_Exists(Barricade_player_ruins) then Event_Remove(Barricade_player_ruins) end
	-- Activate the rest of the script
	Cmd_Move(sg_ally_barricade_02, mkr_ally_dest_barricade_ruins) -- Move random dudes up to help Morgan
	print("Allies moving up 2")
end

function Barricade_Allies_moveup_03()
	-- End check
	if Event_Exists(Barricade_player_exitruins) then Event_Remove(Barricade_player_exitruins) end
	
	-- Give a move order, let the idle plan take care of the rest
	Cmd_Move(sg_ally_barricade_02, mkr_ally_dest_flank_barricade) -- Move random dudes up to shoot baddies
	
	-- Disable invuln/Remove modifiers
	Rule_AddOneShot(Barricade_DisableModifiers, 0)
	-- Play cue
	
	print("Allies moving up 3")
end

function Barricade_Ally_Respawn()

	if SGroup_IsAlive(sg_ally_barricade_02) == false then
		Util_CreateSquads(player2, {sg_ally_barricade_all, sg_ally_barricade_02, sg_ally_all}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:partisan_squad_city17"), mkr_ally_entry02, mkr_start_dest01, 1, 4, false)
		
	end
	
	if SGroup_IsAlive(sg_ally_barricade_03) == false then
		Util_CreateSquads(player2, {sg_ally_barricade_all, sg_ally_barricade_03, sg_ally_all}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:partisan_squad_city17_harmless"), mkr_ally_entry02, mkr_ally_dest_flank_barricade, 1, nil, true)
		Modify_TargetPriority(sg_ally_barricade_03, 20)
	end
	
	Util_StartIntel(EVENTS.REINFORCEMENTS)
	print("Allies respawned")
end

function Barricade_Start()

	-- Enemies behind barricade dont move
	Squad_SetRetaliationPlan(SGroup_GetSpawnedSquadAt("sg_enemy_barricade_01", 1), "infantry-idle-plan-nomove")
	Squad_SetRetaliationPlan(SGroup_GetSpawnedSquadAt("sg_enemy_barricade_01", 2), "infantry-idle-plan-nomove")
	Squad_SetRetaliationPlan(SGroup_GetSpawnedSquadAt("sg_enemy_barricade_01", 3), "guards-ptrs-idle-plan")
	-----------------------
	-- Player triggers
	
	-- First advance
	Barricade_player_grenade = Event_GroupIsDead(Barricade_Allies_moveup_01, nil, sg_enemy_barricade_02, 0, false) -- Two guys are dead, move allies up
	-- Barricade_player_ranpast = Event_Proximity(Barricade_Allies_moveup_01, nil, player1, mkr_player_trigger_barricade_ruins, nil, ANY) -- Player ran past the guys, kill them anyway and move-on
	
	-- Give the player a hint if idle
	Rule_AddOneShot(Hint_Barricade_Grenade, 25)
	
	-- Ruins
	Barricade_player_ruins = Event_Proximity(Barricade_Allies_moveup_02, nil, player1, mkr_player_trigger_barricade_ruins, nil, ANY) -- Player has entered ruins
	Barricade_player_exitruins = Event_Proximity(Barricade_Allies_moveup_03, nil, player1, mkr_player_trigger_barricade_flank, nil, ANY) -- Player is exiting ruins
	
	-----------------------
	-- Respawn Allies only once
	Barricade_ally_gameplayaredead = Event_GroupIsDead(Barricade_Ally_Respawn, nil, sg_ally_barricade_02, 0, false)
	Barricade_ally_looksaredead = Event_GroupIsDead(Barricade_Ally_Respawn, nil, sg_ally_barricade_03, 0, false)
	
	-- Stir them into the soup
	Barricade_ally_respawncheck = Event_CreateOR(Barricade_Ally_Respawn, nil, {Barricade_ally_gameplayaredead, Barricade_ally_looksaredead}, 1) -- Allied troops have died
	
	-----------------------
	-- End checks
	Barricade_enemy_endcheck = Event_GroupIsDead(Barricade_End, nil, sg_enemy_barricade_all, 0, false) -- All enemy troops are dead
	-- Barricade_ally_endcheck = not Event_GroupIsDead(Barricade_End, nil, sg_ally_barricade_01, 0, false) -- Allies are alive
	Barricade_speech_endcheck = Event_NarrativeEventsNotRunning(Barricade_End, nil, 0) -- Nobody important is talking
	
	-- Stir them into the broth
	Barricade_endcheck = Event_CreateAND(Barricade_End, nil, {Barricade_enemy_endcheck, Barricade_speech_endcheck}, 1)
	print("Barricade scripts initialized")
	
	-- Ambient stukas
	_stuka_Area = mkr_stuka_area_01
	_stuka_Ability = BP_GetAbilityBlueprint("stuka_aerial_superiority_recon")
	_stuka_Ability_hard = BP_GetAbilityBlueprint("m01_stuka_dogfight_pass")
	tmr_amb_Stukas = "tmr_amb_Stukas"
	g_stuka_freq_min = 20
	g_stuka_freq_max = 28
	Rule_AddInterval(Ambient_Stukas, 1, 700)
end

function Barricade_End()
	
	-- End barricade scripts
	if Event_Exists(Barricade_endcheck) then Event_Remove(Barricade_endcheck) end
	if Event_Exists(Barricade_ally_respawncheck) then Event_Remove(Barricade_ally_respawncheck) end
	-- For devtests, skip all scripts just in case
	if Event_Exists(Barricade_player_grenade) then Event_Remove(Barricade_player_grenade) end
	if Event_Exists(Barricade_player_ruins) then Event_Remove(Barricade_player_ruins) end
	if Event_Exists(Barricade_player_exitruins) then Event_Remove(Barricade_player_exitruins) end
	
	-- Event_Skip()
	
	print("Barricade scripts ended")
	
	-- Start the cut-scene
		
	-- Set point owner
	EGroup_InstantCaptureStrategicPoint(pg_barricade, player1) 
	
	-- Open up next stage
	World_IncreaseInteractionStage()
	Objective_Complete(SOBJ_Barricade, true)
	
	-- Move the rest of the troops move up
	Util_StartIntel(EVENTS.BARRICADE_END)
	
	-- Make fake guys run away
	Rule_AddOneShot(Pursuit_Old_Allies, 4.0)
	Cmd_Move(sg_ally_barricade_01, mkr_ally_dest_barricade_end)
	Cmd_Retreat(sg_ally_barricade_03, mkr_ally_entry01, mkr_ally_entry01)   -- fake troops run off into inaccessible city area
	-- Spawn Tiger
	
	-- End this script
	Rule_RemoveMe()
	
	-- Start new scripts
	Rule_AddOneShot(Pursuit_Start, 0.5)
	-- Rule_AddOneShot(Cafe_Start, 1)
	-- Rule_AddOneShot(Sniper_Test, 0.25)

end

-------------------------------------------------------
-- Lemme tell you a story behind the barricade section;
--
-- At first, it was to be the whole mission, predictable right?
-- Of course it was bigger than it was in this version, with alot more fancy,
-- E3 style cinematic events, but I scrapped that to make room for more gameplay.
-- It, like many things similar to this, morphed into something much bigger.
-- The original map and layout have been lost forever, but the development of
-- the full version/this map has been saved and is well kept in a single flash drive.
-- A flash drive in a very precarious spot that I tend to bump every-so-often.
--
-- So, anyways, after creating a new map and stamping what I had onto it, I got to work.
-- The first version was similar to what we have now, with the only exception being that
-- a tiger would spawn behind the player and then chase him throughout the level, stopping
-- at strangely convienient points because of engine trouble. It worked kind of like a soft-timer. 
-- Tried to make it work with a few funny ideas, but it just didnt seem fun being prodded around.
-- This was when I also got the idea of dotting caches around the map. This was scrapped 
-- before I even made a custom tiger entity.
--
-- The second version was going to be entirely different, and only borrow from HL2 in name.
-- This also didnt get far, as then I would have to rename the mission. Misleading advertising
-- and what-not. This version went from left to right rather than down to up, and was more of a
-- prototype for the pursuit section than anything else.
--
-- The third and final version is what is present here, and rest assured it has only changed in 
-- visual fidelity through the development cylce.
-------------------------------------------------------

---------------------------
-- Cafe (Old)
---------------------------
function Cafe_Start_Test()

	-----------------------
	-- Player triggers
	Cafe_player_ambush_prox = Event_Proximity(Cafe_Start_Ambush, nil, player1, mkr_player_trigger_cafe_ambush, nil, ANY, 0) -- Player has activated ambush zone
	
	-- Entering garden
	-- Cafe_player_enter = Event_Proximity(Hint_Cafe_Vault, nil, player1, mkr_player_trigger_garden, nil, ANY) -- Player has entered cafe area
	-- Give vault hint
	Cafe_player_blocked = Event_Proximity(Hint_Cafe_Vault, nil, player1, {mkr_player_trigger_cafe_block, mkr_player_trigger_cafe_entrance}, nil, ANY) -- Player is blocked
	

	print("Cafe scripts initialized")
end

function Hint_Cafe_Vault()
	if Event_Exists(Cafe_player_blocked) then Event_Remove(Cafe_player_blocked) end
	
--~	if Event_Exists(Sniper_player_cleared) then
		hpid_cafe_vault = HintPoint_Add(mkr_hint_cafe_vault, true, "$312430cd68d346ad8badb0bc1ef14b77:1348", nil, HPAT_Vaulting)
		Cafe_hint_vault_01 = Event_Proximity(Hint_Cafe_Vault_Stop, nil, player1, mkr_player_trigger_cafe_vaulted_01, nil, ANY) -- Player has vaulted over wall
		Cafe_hint_vault_02 = Event_Proximity(Hint_Cafe_Vault_Stop, nil, player1, mkr_player_trigger_cafe_vaulted_02, nil, ANY)
		
		Cafe_hint_vault = Event_CreateOR(Hint_Cafe_Vault_Stop, nil, {Cafe_hint_vault_01, Cafe_hint_vault_02}, 1)
--~	end
end

function Hint_Cafe_Vault_Stop()
	if Event_Exists(Cafe_hint_vault) then Event_Remove(Cafe_hint_vault) end
	HintPoint_Remove(hpid_cafe_vault)
	-- HintPoint_Remove(hpid_cafe_vault_test)
	-- HintPoint_RemoveAll()
end

function Cafe_Start_Ambush()

	-- End check
	if Event_Exists(Cafe_player_ambush_prox) then Event_Remove(Cafe_player_ambush_prox) end
	Rule_RemoveMe()
	
	-- Spawn enemies
	Rule_AddOneShot(Cafe_Ambush_Spawn, 0.125)
	
end

function Cafe_Ambush_New()
	-- End check
	if Event_Exists(Cafe_player_ambush_prox) then Event_Remove(Cafe_player_ambush_prox) end
	
	-- Create Sgroups
	sg_enemy_cafe_ambush = SGroup_CreateIfNotFound("sg_enemy_cafe_ambush") -- Ambushers
	sg_enemy_cafe_ambush_01 = SGroup_CreateIfNotFound("sg_enemy_cafe_ambush_01")
	
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_cafe_ambush, sg_enemy_cafe_ambush_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_cafe_02, mkr_enemy_dest_cafe_01, 1, 3, false)
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_cafe_ambush, sg_enemy_cafe_ambush_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_cafe_03, mkr_enemy_dest_cafe_02, 1, 4, false)
	
	-- Pursue player if moved to destination and player is out of range
	Cmd_Attack(sg_enemy_cafe_ambush, sg_player_01, true, false)
end

---------------------------
-- Sniper (Old)
---------------------------
function Sniper_Start_Test()

	-- Spawn Supply Protectors
	sg_enemy_sniper = SGroup_CreateIfNotFound("sg_enemy_sniper") -- The Sniper
	sg_enemy_sniper_troops = SGroup_CreateIfNotFound("sg_enemy_sniper_troops") -- Other troops
	
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_sniper_troops}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_sniper_01, nil, 1, 4, false)
	-----------------------
	-- Player triggers
	Sniper_player_ambush_prox = Event_Proximity(Sniper_Cache_Ambush, nil, player1, mkr_player_trigger_sniper_ambush, nil, ANY, 0.5) -- Player has activated ambush zone
	Sniper_player_blocked = Event_GroupIsDead(Hint_Sniper_Vault, nil, sg_enemy_sniper_troops, 1, false)

	print("Sniper scripts initialized")
end

function Sniper_Cache_Ambush()
	-- End check
	Event_Remove(Sniper_player_ambush_prox)
	
	-- Give command
	Cmd_Move(sg_enemy_sniper_troops, mkr_enemy_dest_sniper_01)
	-- Rule_RemoveMe()
end

function Hint_Sniper_Vault()
	if Event_Exists(Sniper_player_cleared) then Event_Remove(Sniper_player_cleared) end
	
	if Event_Exists(Cafe_player_blocked) then
		hpid_sniper_vault = HintPoint_Add(mkr_hint_sniper_vault, true, "$312430cd68d346ad8badb0bc1ef14b77:1348", nil, HPAT_Vaulting)
		Sniper_hint_vault = Event_Proximity(Hint_Sniper_Vault_Stop, nil, player1, mkr_player_trigger_sniper_vaulted, nil, ANY) -- Player has vaulted over wall
	end
end

function Hint_Sniper_Vault_Stop()
	if Event_Exists(Sniper_hint_vault) then Event_Remove(Sniper_hint_vault) end
	HintPoint_Remove(hpid_sniper_vault)
end

---------------------------
-- Pursuit
---------------------------
function Pursuit_Old_Allies()
	-- All real troops wait for Morgan or other to blow the barricade at end of street
	-- Command_SquadPos(player2, sg_ally_barricade_all, SCMD_AttackMove, Util_GetPosition(mkr_ally_dest_barricade_end))
	Cmd_AttackMove(sg_ally_barricade_all, mkr_ally_dest_barricade_end, false, nil, 8) -- Simpler command
	
	SGroup_SetInvulnerable(sg_ally_barricade_01, 0.5)
	Rule_AddInterval(Pursuit_PlantAnim, 1, 500)
end

function Pursuit_PlantAnim()
	if (not SGroup_IsMoving(sg_ally_barricade_all, ALL)) then
		Cmd_Ability(sg_ally_barricade_01, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_demo_vis_notarget"), nil, nil, true, false)
		Rule_RemoveMe()
	end
end

function Pursuit_Start()

	-----------------------
	-- Left Path (Main)
	-- Player triggers
	Cafe_player_ambush_prox = Event_Proximity(Cafe_Ambush_New, nil, player1, mkr_player_trigger_cafe_ambush, nil, ANY) -- Player has activated ambush zone
	-- Cafe_player_ambush_visible = Event_PlayerCanNotSeeElement(Cafe_Start_Ambush, nil, player1, mkr_enemy_spawn_cafe_02, ANY, 0) -- Player cant see spawn
	
	-- Cafe_player_ambush = Event_CreateAND(Cafe_Start_Ambush, nil, {Cafe_player_ambush_prox, Cafe_player_ambush_visible}, 1)
	
	-- Give vault hint
	Cafe_player_blocked = Event_Proximity(Hint_Cafe_Vault, nil, player1, {mkr_player_trigger_cafe_block, mkr_player_trigger_cafe_entrance}, nil, ANY) -- Player is blocked
	
	-- End Cafe scripts
	Cafe_player_exit_prox = Event_Proximity(Pursuit_End, nil, player1, mkr_player_trigger_cafe_exit, nil, ANY, 0) -- Player has activated ambush zone
	
	-- Spawn Supply Protectors
	sg_enemy_sniper = SGroup_CreateIfNotFound("sg_enemy_sniper") -- The Sniper
	sg_enemy_sniper_troops = SGroup_CreateIfNotFound("sg_enemy_sniper_troops") -- Other troops
	
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_sniper_troops}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_sniper_01, nil, 1, 4, false)
	-----------------------
	-- Right path (Side) -- If player goes this route and activates this first, it breaks the main path prox checks. --Find out why--.
	-- Player triggers
--~	Sniper_player_ambush_prox = Event_Proximity(Sniper_Cache_Ambush, nil, player1, mkr_player_trigger_sniper_ambush, nil, ANY) -- Player has activated ambush zone
	Sniper_player_cleared = Event_GroupIsDead(Hint_Sniper_Vault, nil, sg_enemy_sniper_troops, 1, false)

	Squad_SetRetaliationPlan(SGroup_GetSpawnedSquadAt("sg_enemy_sniper_troops", 1), "guards-ptrs-infantry-plan")
	
	-- Re-Start playercheck if need be -- Find out why playercheck is ending after first obj
	if Rule_Exists(Player_Check) == false then 
		Rule_Add(Player_Check, 900) 
	end
	
	-- Apply Modifiers
	Player_SetPopCapOverride(player1, 12)
	
	-- Start objective
	Objective_Start(SOBJ_Park, true)
	
	-- Create park hmg for ambient noise
	Rule_AddOneShot(HMG_Preload, 0)
	
	-- Rule_RemoveMe()
	print("Pursuit scripts initialized")
end

function Pursuit_End()

	-----------------------
	-- Left Path (Main)
	if Event_Exists(Cafe_player_exit_prox) then Event_Remove(Cafe_player_exit_prox) end
	if Event_Exists(Cafe_player_ambush_prox) then Event_Remove(Cafe_player_ambush_prox) end
	
	-----------------------
	-- Right path (Side)
	if Event_Exists(Sniper_player_cleared) then Event_Remove(Sniper_player_cleared) end
	
	-- Start Park Scripts
	Rule_AddOneShot(Park_Start, 0, 900)
	Rule_AddOneShot(Park_APC_Rollin, 1, 700)
	
	-- Get rid of path blockers
	EGroup_DeSpawn(mb_cafe_stairs)
	EGroup_Destroy(mb_cafe_stairs)
	
	-- Capture territory
	-- EGroup_InstantCaptureStrategicPoint(pg_pursuit, player1)
	
	print("Pursuit scripts ended")
end

---------------------------
-- HMG Encounter (Preload)
---------------------------

function HMG_Preload()
	-- Spawn HMG
	sg_enemy_park_hmg = SGroup_CreateIfNotFound("sg_enemy_park_hmg") -- The HMG
	sg_enemy_park_hmg_troops = SGroup_CreateIfNotFound("sg_enemy_park_hmg_troops") -- MG troops right next to it
	
	--Util_CreateSquads(player3, sg_enemy_park_hmg, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:hmg_squad_single_city17"), Util_GetOffsetPosition(mkr_enemy_spawn_park_hmg, OFFSET_BACK, 0.5))
	Util_CreateSquads(player3, sg_enemy_park_hmg, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:hmg_squad_single_city17"), eg_park_hq)
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_hmg_troops}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), eg_park_hq, nil, 1, 4)
	
	-- Log weapon for use in other things
	Util_LogSyncWpn(sg_enemy_park_hmg, true)
	
	-- Give attack command
	Util_Delay(1, function()
	Cmd_Ability(sg_enemy_park_hmg, BP_GetAbilityBlueprint("garrisoned_squad_facing"), Util_GetPosition(mkr_enemy_park_hmg_target))
    Command_SquadPos(player3, sg_enemy_park_hmg, SCMD_Attack, Util_GetPosition(mkr_enemy_park_hmg_target), true)
	Modify_Vulnerability(sg_enemy_park_hmg, 0.75)
	end)
	
	FOW_RevealArea(Util_GetPosition(mkr_fow_reveal_hmg), 20, -1)
	-- FOW_PlayerRevealAll(player3)
	FOW_RevealArea(Util_GetPosition(mkr_enemy_park_hmg_target), 25, 120) 
	
	-- Spawn some fake troops to shoot each-other endlessly
	sg_ally_park_preload = SGroup_CreateIfNotFound("sg_ally_park_preload")
	sg_enemy_park_preload = SGroup_CreateIfNotFound("sg_enemy_park_preload")
	Util_CreateSquads(player2, {sg_ally_all, sg_ally_park_preload}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:partisan_squad_city17"), mkr_ally_spawn_park_01, nil, 1)
	Util_CreateSquads(player2, {sg_ally_all, sg_ally_park_preload}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:partisan_squad_city17"), mkr_ally_spawn_park_02, nil, 1)
	Util_CreateSquads(player2, {sg_ally_all, sg_ally_park_preload}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:partisan_squad_city17_nomap"), mkr_ally_spawn_park_03, nil, 1, World_GetRand(1, 2))
	
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_preload}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_park_01, nil, 1, 5)
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_preload}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_park_l01, nil, 1, World_GetRand(1, 2))
	
	Squad_SetRetaliationPlan(SGroup_GetSpawnedSquadAt("sg_ally_park_preload", 1), "guards-ptrs-idle-plan")
	Squad_SetRetaliationPlan(SGroup_GetSpawnedSquadAt("sg_ally_park_preload", 2), "guards-ptrs-idle-plan")
	
	_DisableInteraction(sg_ally_park_preload)
	_DisableInteraction(sg_enemy_park_preload)
	
	-- Apply modifiers
	SGroup_SetSuppression(sg_ally_park_preload, 12.0)
	Modify_Vulnerability(sg_ally_park_preload, 0.1)
	SGroup_SuggestPosture(sg_ally_park_preload, 0, 60)
	Modify_Vulnerability(sg_enemy_park_preload, 0.1)
	-- HMG helpers
	Modify_Vulnerability(sg_enemy_park_hmg_troops, 1.25)
	mod_range_hmg_troops = Modify_WeaponRange(sg_enemy_park_hmg_troops, "hardpoint_01", 1.5)
	mod_accuracy_hmg_troops = Modify_WeaponAccuracy(sg_enemy_park_hmg_troops, "hardpoint_01", 0.5)
	mod_damage_hmg_troops = Modify_WeaponDamage(sg_enemy_park_hmg_troops, "hardpoint_01", 0.5)
	
	Util_Delay(2, function()
    Command_SquadPos(player3, sg_enemy_park_hmg, SCMD_Attack, Util_GetPosition(mkr_enemy_park_hmg_target), true)
	end)
	
	-- Bonus supplies
	sg_enemy_park_bonus = SGroup_CreateIfNotFound("sg_enemy_park_bonus")
	
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_bonus}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_park_bonus_01, nil, 1, World_GetRand(3, 4))
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_bonus}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_park_bonus_02, nil, 1, World_GetRand(1, 2))
	Squad_SetRetaliationPlan(SGroup_GetSpawnedSquadAt("sg_enemy_park_bonus", 1), "guards-ptrs-infantry-plan")
	-- Rule_AddInterval(Park_statue_check, 1, 300)
	
	-- Preload ambient speech
	hmg_squad_chatter_setup()
	print("Ambient park scripts loaded")
end

function hmg_player_nag()
	if SGroup_IsAlive(sg_enemy_park_hmg) then
		Util_StartIntel(EVENTS.HMG_AMBIENT)
		print("Get moving you slowpoke!")
	end
end

function hmg_player_idle()
	if Event_Exists(Park_hmg_endcheck) then
		Util_StartIntel(EVENTS.HMG_REMIND)
		Util_CreateSquads(player2, {sg_ally_all, sg_ally_park_02}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:partisan_squad_city17_nomap"), mkr_ally_entry03, mkr_enemy_dest_park_ca_01, 1, nil, true)
		Util_CreateSquads(player2, {sg_ally_all, sg_ally_park_02}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:partisan_squad_city17_nomap"), mkr_ally_entry03, mkr_enemy_dest_park_ca_02, 1, nil, true)
		print("Morgan must be high, we'll do it outselves!")
	end
end

function hmg_nag_suppressed()
	if Event_Exists(Park_player_underfire_hmg) then Event_Remove(Park_player_underfire_hmg) end
	Util_StartIntel(EVENTS.HMG_SUPPRESSED)
	Rule_AddOneShot_Exists(_hmg_flash, 1)
	Rule_AddOneShot_Exists(_hmg_stop_flash, 10)
end

function _hmg_flash() ta_park_hmg = ThreatArrow_CreateGroup(sg_enemy_park_hmg) end
function _hmg_stop_flash() ThreatArrow_DestroyGroup(ta_park_hmg) end

function Park_statue_check() 
	if EGroup_GetAvgHealth(eg_park_statue) <= 0.1 then 
		EGroup_Kill(eg_park_statue)
		Rule_RemoveMe()
	else
	
	end
end

function Park_hq_destroy()
	if Event_Exists(Park_hq_check) then Event_Remove(Park_hq_check) end
	if EGroup_Exists("eg_park_hq_items") then 
		EGroup_Kill(eg_park_hq_items)
		EGroup_Destroy(eg_park_hq_items)
	end
	SGroup_Kill(sg_enemy_park_hmg)
end

function Park_hq_healthcheck()
	if EGroup_GetAvgHealth(eg_park_hq) <= 0.25 then
		Rule_RemoveMe()
		Park_hq_destroy()
	end
end

function hmg_setup_old()
	-- Setup hmg
	Cmd_Move(sg_enemy_park_hmg, mkr_enemy_spawn_hmg, false, nil, Util_GetOffsetPosition(mkr_enemy_spawn_hmg, OFFSET_FRONT, 10))
	Command_SquadPos(player3, sg_enemy_park_hmg, SCMD_Attack, Util_GetPosition(mkr_enemy_hmg_target), true)
	Modify_Vulnerability(sg_enemy_park_hmg, 0.7)
--~ 	_hmg_armor_mod = Modify_Armor(sg_enemy_park_hmg, 35)
	
	-- Spawn other troops
	sg_enemy_park_01 = SGroup_CreateIfNotFound("sg_enemy_park_01") -- Proper troops
	sg_enemy_park_02 = SGroup_CreateIfNotFound("sg_enemy_park_02") -- Harmless troops
	sg_enemy_park_03 = SGroup_CreateIfNotFound("sg_enemy_park_03") -- Cutscene troops
	
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_park_01, nil, 1, 3)
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_park_02, nil, 1, 4)
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_park_03, nil, 1, 3)
	-- Left 
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_park_l01, nil, 1, 4)
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_park_l02, nil, 1, 4)
	-- Right 
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_park_r01, nil, 1, 3)
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_park_r02, nil, 1, 4)

end

----------------------
-- AMBIENT SPEECH NAGS
-- 3D SPEECH FOR USE FROM SQUADS
----------------------

function hmg_squad_chatter_setup()

	g_AMB_SPEECH_PATH = "sound/speech/sp/m01/"
	g_AMB_SPEECH_TIMER = "g_AMB_SPEECH_TIMER"
	
	-- Ambient speech table, mostly unused dialouge from old m01, some might not be compatible in 3d space
	park_ambient_speech_table = {11022127, 11022137, 11022144, 11036278, 11036280, 11036256, 11036248, 11036282, 11047645, 11046831}
	print("hmg chatter parameters setup")
end

function hmg_squad_chatter()
	
	if Timer_GetRemaining(g_AMB_SPEECH_TIMER) <= 0 then
		hmg_playambientspeech()
		local rand = World_GetRand(12, 18)
		Timer_Start(g_AMB_SPEECH_TIMER, rand)
	end
	
end

function hmg_playambientspeech()

	if SGroup_IsAlive(sg_ally_park_01) == true then
		--~ Util_StartAmbient(EVENTS.HMG_AMBIENT_NAGS)
		local squad = SGroup_GetRandomSpawnedSquad(sg_ally_park_01)
		
		local rand = World_GetRand(1, table.getn(park_ambient_speech_table))
		Sound_Play3D(g_AMB_SPEECH_PATH..park_ambient_speech_table[rand], Squad_EntityAt( squad, 0 ))
		print("*hmg chatter played*")
	else
		print("*hmg chatter stopped*")
		Rule_RemoveMe()
	--if SGroup_IsEmpty(sg_ally_park_01) == true then
	--	Rule_RemoveMe()
	end
	
end

----------------------

--****************************
-- PARK --
--****************************

function Park_APC_Rollin()
	-- Spawn other troops
	sg_enemy_park_apc = SGroup_CreateIfNotFound("sg_enemy_park_apc") -- 
	eg_enemy_park_apc = EGroup_CreateIfNotFound("eg_enemy_park_apc")
	
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_apc}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:puma_apc_city17"), mkr_enemy_spawn_park_apc, nil, 1, 1)
	Cmd_SquadPath(sg_enemy_park_apc, "path_park_apc", true, false, false, 0, nil, false)
	--~ Cmd_Move(sg_enemy_park_apc, mkr_enemy_dest_park_apc, false)
	
	-- Set squad-AI to not move
	Squad_SetRetaliationPlan(SGroup_GetSpawnedSquadAt("sg_enemy_park_apc", 1), "Weapon-team-plan")
	Squad_SetAttackPlan(SGroup_GetSpawnedSquadAt("sg_enemy_park_apc", 1), "Weapon-team-plan")
	
	-- Apply critical effects
	-- SGroup_SetAnimatorState(sg_enemy_park_apc, criticals_engine, red)
	APC_CRIT = BP_GetCriticalBlueprint("312430cd68d346ad8badb0bc1ef14b77:vehicle_park_apc_engine_damage")
	Squad_SetHealth(SGroup_GetSpawnedSquadAt("sg_enemy_park_apc", 1), 0.5)
	Entity_ApplyCritical(Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_enemy_park_apc, 1), 0), APC_CRIT, 1.1)
	
	-- Spawn the rocket allies
	sg_ally_park_rocketmen = SGroup_CreateIfNotFound("sg_ally_park_rocketmen")
	Util_CreateSquads(player2, {sg_ally_all, sg_ally_park_rocketmen}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:partisan_squad_city17_nomap"), mkr_ally_spawn_park_apc, nil, 1, World_GetRand(3, 4), true, nil, BP_GetUpgradeBlueprint("312430cd68d346ad8badb0bc1ef14b77:rpg_guided_hl2_upgrade"))
	Cmd_Attack(sg_ally_park_rocketmen, sg_enemy_park_apc, false, false)
	Cmd_AttackMove(sg_ally_park_rocketmen, Util_GetPosition(mkr_ally_dest_park_hmg_cutscene), true)
	print("Park apc is rolling in")
end

function Park_Start()

	-- Spawn enemy troops
	SGroup_DestroyAllSquads(sg_enemy_park_preload)
	sg_enemy_park_01 = SGroup_CreateIfNotFound("sg_enemy_park_01") -- Troops in trenches
	sg_enemy_park_02 = SGroup_CreateIfNotFound("sg_enemy_park_02") -- Troops not in trenches 
	sg_enemy_park_02l = SGroup_CreateIfNotFound("sg_enemy_park_02l") --
	sg_enemy_park_02r = SGroup_CreateIfNotFound("sg_enemy_park_02r") --
	sg_enemy_park_03 = SGroup_CreateIfNotFound("sg_enemy_park_03") -- Visual troops
	sg_enemy_park_blockers = SGroup_CreateIfNotFound("sg_enemy_park_blockers") -- Blockers
	
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_park_01, nil, 1, 5)
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_park_02, nil, 1, 2)
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_park_03, nil, 1, 3)
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_park_04, nil, 1, 4)
	-- Left 
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_02, sg_enemy_park_02l}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_park_l01, nil, 1, Park_loadout01)
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_02, sg_enemy_park_02l}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_park_l02, nil, 1, Park_loadout01)
	-- Right 
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_02, sg_enemy_park_02r}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_park_r01, nil, 1, Park_loadout01)
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_02, sg_enemy_park_02r}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), mkr_enemy_spawn_park_r02, nil, 1, Park_loadout01)
	-- Blockers
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_blockers}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_park_blocker_front, nil, 1, 2, false, nil, BP_GetUpgradeBlueprint("312430cd68d346ad8badb0bc1ef14b77:mg42_gren_noreq"))
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_blockers}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_park_blocker_right, nil, 1, 4, false, nil, BP_GetUpgradeBlueprint("312430cd68d346ad8badb0bc1ef14b77:mg42_gren_noreq"))
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_blockers}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_park_blocker_left, nil, 1, 3, false, nil, BP_GetUpgradeBlueprint("312430cd68d346ad8badb0bc1ef14b77:mg42_gren_noreq"))
	
	-- Apply settings
	Squad_SetRetaliationPlan(SGroup_GetSpawnedSquadAt("sg_enemy_park_02", 1), "guards-ptrs-infantry-plan")
	Squad_SetRetaliationPlan(SGroup_GetSpawnedSquadAt("sg_enemy_park_02", 2), "guards-ptrs-infantry-plan")
	Squad_SetRetaliationPlan(SGroup_GetSpawnedSquadAt("sg_enemy_park_02", 3), "guards-ptrs-infantry-plan")
	Squad_SetRetaliationPlan(SGroup_GetSpawnedSquadAt("sg_enemy_park_02", 4), "guards-ptrs-infantry-plan")
	Squad_SetRetaliationPlan(SGroup_GetSpawnedSquadAt("sg_enemy_park_blockers", 1), "infantry-idle-plan-nomove")
	Squad_SetRetaliationPlan(SGroup_GetSpawnedSquadAt("sg_enemy_park_blockers", 2), "infantry-idle-plan-nomove")
	Squad_SetRetaliationPlan(SGroup_GetSpawnedSquadAt("sg_enemy_park_blockers", 3), "infantry-idle-plan-nomove")
	
	local retreat_location = Table_GetRandomItem({mkr_enemy_park_retreat_01, mkr_enemy_park_retreat_02, mkr_enemy_park_retreat_03})
	AutoRetreat_AddSGroup(sg_enemy_park_02, retreat_location, 0.3, nil)
	-- Rule_AddInterval(Park_fw_troops_retreat, 1, 500) 
	
	-- Spawn allies
	SGroup_DestroyAllSquads(sg_ally_park_preload)
	sg_ally_park_01 = SGroup_CreateIfNotFound("sg_ally_park_01") -- Gameplay troops
	sg_ally_park_02 = SGroup_CreateIfNotFound("sg_ally_park_02") -- Alt Gameplay troops
	sg_ally_park_03 = SGroup_CreateIfNotFound("sg_ally_park_03") -- Fake and Script troops
	
	Util_CreateSquads(player2, {sg_ally_all, sg_ally_park_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:partisan_squad_city17"), mkr_ally_spawn_park_01, nil, 1)
	Util_CreateSquads(player2, {sg_ally_all, sg_ally_park_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:partisan_squad_city17"), mkr_ally_spawn_park_02, nil, 1)
	Util_CreateSquads(player2, {sg_ally_all, sg_ally_park_02}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:partisan_squad_city17_nomap"), mkr_ally_spawn_park_03, nil, 1, World_GetRand(2, 4))
	Util_CreateSquads(player2, {sg_ally_all, sg_ally_park_02}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:partisan_squad_city17_nomap"), mkr_ally_spawn_park_04, nil, 1, World_GetRand(2, 4))
	-- Officer
	Util_CreateSquads(player2, {sg_ally_all, sg_ally_park_03}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:conscript_squad_city17"), mkr_ally_spawn_park_officer, nil, 1, World_GetRand(2, 3))
	
	Squad_SetRetaliationPlan(SGroup_GetSpawnedSquadAt("sg_ally_park_01", 1), "guards-ptrs-idle-plan")
	Squad_SetRetaliationPlan(SGroup_GetSpawnedSquadAt("sg_ally_park_01", 2), "guards-ptrs-idle-plan")
	
	if g_hardDiff == true then
		sg_enemy_park_mortar = SGroup_CreateIfNotFound("sg_enemy_park_mortar")
		Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_mortar}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:mortar_team_city17"), mkr_enemy_spawn_park_05, nil)
		FOW_RevealSGroupOnly(sg_enemy_park_mortar, -1)
		Util_LogSyncWpn(sg_enemy_park_mortar, true)
		Modify_WeaponAccuracy(sg_enemy_park_mortar, "hardpoint_01", 0.5)
	end	
	
	--~Actor_SetFromSGroup(ACTOR.Partisans, sg_ally_park_01)
	
	-- Make sure player cant see or interact with them when they spawn
	_DisableInteraction(sg_ally_park_02)
	_DisableInteraction(sg_ally_park_03)
	
	-- Suppressed by MG
	SGroup_SetSuppression(sg_ally_park_01, 8.0)
	
	-- Apply modifiers
	Rule_AddOneShot(Park_Start_modifiers, 0)
	Player_SetPopCapOverride(player1, 14)
	
	-- Start intel
	Util_StartIntel(EVENTS.NIS_PARK)
	Rule_AddOneShot(Park_cameratrack_hmg, 0)
	Rule_AddOneShot(hmg_player_nag, 75)
	Rule_AddOneShot(hmg_player_idle, 600, 600) -- We arent going to sit here and get shot!
	Rule_AddInterval(hmg_squad_chatter, 1.5)
	
	Park_player_underfire_hmg = Event_GroupIsSuppressed(hmg_nag_suppressed, nil, sg_player_all, ANY, 1) -- Player is suppressed by mg
	
	-- Spawn satchel charges
	world_object_park_charges = EGroup_CreateIfNotFound("world_object_park_charges")
	Util_CreateEntities(nil, {world_object_spawns, world_object_park_charges}, BP_GetEntityBlueprint("312430cd68d346ad8badb0bc1ef14b77:satchel_charges_e3_barricade"), mkr_world_park_satchel_charges, 1, nil)
	
	-- Give hint
	
	-- Util_StartIntel(EVENTS.BARRAGE_01_WARNING)
	
	-- Check if park hq has been destroyed
	Park_hq_deathcheck = Event_GroupIsDead(Park_hq_destroy, nil, eg_park_hq, 0, false)
	Park_hq_burncheck = Event_GroupBurning(Park_hq_destroy, nil, eg_park_hq, 0)
	
	Park_hq_check = Event_CreateOR(Park_hq_destroy, nil, {Park_hq_deathcheck, Park_hq_burncheck}, 1)
	
	Rule_AddInterval(Park_hq_healthcheck, 0.5, 600)
	
	-- End checks
	Park_hmg_enemy_endcheck = Event_GroupIsDead(Park_hmg_end, nil, sg_enemy_park_hmg, 0, false) -- MG is dead
	Park_hmg_speech_endcheck = Event_NarrativeEventsNotRunning(Park_hmg_end, nil, 0) -- Nobody important is talking
	
	-- Stir them into the broth
	Park_hmg_endcheck = Event_CreateAND(Park_hmg_end, nil, {Park_hmg_enemy_endcheck, Park_hmg_speech_endcheck}, 1)
	
	Player_AddUnspentCommandPoints(player1, 1)
	-- Give hint about partisans
	
	print("Park scripts initialized")
end

function Park_cameratrack_hmg()
	
	Camera_MoveTo(sg_player_01, true, 1.0, false, false)
	-- Stop troops from taking damage during cutscene
	Cmd_Stop(sg_enemy_cafe_ambush)
	Cmd_Stop(sg_player_all)
	Modify_Vulnerability(sg_enemy_cafe_ambush, 0.1)
	Modify_Vulnerability(sg_player_all, 0.1)
	
	Util_Delay(0.125, function()
	Camera_SetOrbit(30)
	Camera_SetZoomDist(35)
    Camera_MoveTo(sg_enemy_park_hmg, true, 0.35, true, false)
	sg_ally_park_death = SGroup_CreateIfNotFound("sg_ally_park_death")
	Util_CreateSquads(player2, {sg_ally_all, sg_ally_park_death}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:partisan_squad_city17_nomap"), mkr_ally_spawn_park_hmg_cutscene, mkr_ally_dest_park_hmg_cutscene, 1, World_GetRand(3, 4))
	-- SGroup_SetMoveType(sg_ally_park_death, BP_GetMoveTypeBlueprint("fast_move_m01"))
	SGroup_AddAbility(sg_ally_park_death, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_oorah"))
	Cmd_Ability(sg_ally_park_death, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_oorah"), nil, nil, true, false)
	end)
	-- Camera_MoveTo(sg_enemy_park_hmg, true, 0.4, false, false)
	
	Util_Delay(4.0, function()
    Camera_MoveTo(sg_ally_park_01, true, 0.25, true, true)
	HMG_CRIT = BP_GetCriticalBlueprint("312430cd68d346ad8badb0bc1ef14b77:hmg_death_e3_barricade")
		Util_Delay(2.25, function()
		Entity_ApplyCritical(Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_ally_park_death, 1), 0), HMG_CRIT, 1.1)
		Entity_ApplyCritical(Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_ally_park_death, 1), 1), HMG_CRIT, 1.1)
		-- Entity_ApplyCritical(Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_ally_park_death, 1), 2), HMG_CRIT, 1.1)
		end)
	end)
	-- Camera_MoveTo(sg_ally_park_01, true, 0.4, false, true)
	
	Util_Delay(8.5, function()
    Camera_MoveTo(sg_player_01, true, 0.15, false, false)
	Game_SetMode(UI_Normal)
	Game_EnableInput(true)
	Camera_SetInputEnabled(true)
	Camera_ResetToDefault()
	-- Remove cutscene modifiers, also removes other buffs/nerfs from barricade for next section
	Modifier_RemoveAllFromSGroup(sg_enemy_cafe_ambush)
	Modifier_RemoveAllFromSGroup(sg_player_all)
	Cmd_AttackMove(sg_enemy_cafe_ambush, Util_GetPosition(mkr_enemy_park_hmg_target))
	Util_StartIntel(EVENTS.PARTISANS_AVAILABLE)
	end)
	-- Camera_MoveTo(sg_player_01, true, 0.4, false, true)
	print("Park cutscene finished")
	
end

function Park_Start_modifiers()
	Modify_WeaponAccuracy(sg_enemy_park_01, "hardpoint_01", 0.9)
	Modify_WeaponAccuracy(sg_enemy_park_02, "hardpoint_01", 0.8)
	-- Blockers
	Modify_WeaponAccuracy(sg_enemy_park_blockers, "hardpoint_01", 0.75)
	Modify_WeaponDamage(sg_enemy_park_blockers, "hardpoint_01", 0.75)
	Modify_Vulnerability(sg_enemy_park_blockers, 0.25)
	
	-- Allies
	Modify_WeaponAccuracy(sg_ally_park_02, "hardpoint_01", 0.9)
end

function Park_fw_troops_retreat()

	Util_StartIntel(EVENTS.ENEMY_BREAKING_02)
	-- AutoRetreat_RemoveAll()
	local retreat_location = Table_GetRandomItem({mkr_enemy_park_retreat_01, mkr_enemy_park_retreat_02})
	local retreat_delete = mkr_enemy_park_retreat_deletezone
	
	-- Check
	if (SGroup_Count(sg_enemy_park_02l) >= 1) then
		local thresholdl = World_GetRand(1, 3) -- Down to the last men
		if SGroup_TotalMembersCount(sg_enemy_park_02l) <= thresholdl then
			Cmd_Retreat(sg_enemy_park_02l, retreat_location, retreat_delete, false, nil, true) 
			Rule_RemoveMe()
		end
	end
	
	if (SGroup_Count(sg_enemy_park_02r) >= 1) then
		local thresholdr = World_GetRand(1, 3) -- Down to the last men
		if SGroup_TotalMembersCount(sg_enemy_park_02r) <= thresholdr then
			Cmd_Retreat(sg_enemy_park_02r, retreat_location, retreat_delete, false, nil, true) 
			Rule_RemoveMe()
		end
	end
	-- Check is over
	
end

function Park_hmg_end()
	--------------------
	-- Stop hmg scripts
	-- Rule_RemoveIfExist(hmg_player_nag)
	Rule_RemoveIfExist(hmg_squad_chatter)
	if Event_Exists(Park_hmg_endcheck) then Event_Remove(Park_hmg_endcheck) end
	if Event_Exists(Park_player_underfire_hmg) then Event_Remove(Park_player_underfire_hmg) end
	--------------------
	-- Troops run away in terror
	Cmd_Retreat(sg_enemy_park_01, mkr_enemy_park_retreat_end, mkr_enemy_park_retreat_end)
	Cmd_Retreat(sg_enemy_park_02, mkr_enemy_park_retreat_end, mkr_enemy_park_retreat_end)
	Cmd_Retreat(sg_enemy_cafe_ambush, mkr_enemy_dest_cafe_retreat, mkr_enemy_dest_cafe_retreat)
	-- Start barrage
	Creeping_barrage_rockets(mkr_arty_park_middle)
	Util_Delay(1.0, function()
		Creeping_barrage_rockets(mkr_arty_park_left)
	end)
	Util_Delay(2.0, function()
		Creeping_barrage_rockets(mkr_arty_park_right)
	end)

	Util_Delay(1.5, function()
	-- Execute stinger/intel
	Util_StartIntel(EVENTS.BARRAGE_01_WARNING)
	-- Enable retreat
	Rule_AddOneShot(Park_Counterattack_enableretreat, 1)
	end)
	
	Player_SetPopCapOverride(player1, 20)
	
	Rule_AddOneShot(Park_Counterattack, 9, 900)
	print("Park hmg phase ended, starting counterattack")
end

function Park_Counterattack_enableretreat()
	player_retreat_point_01 = EGroup_CreateIfNotFound("player_retreat_point_01")
	Util_CreateEntities(player1, {world_object_spawns, player_retreat_point_01}, BP_GetEntityBlueprint("sp_retreat_point"), mkr_player_retreat_park, 1, nil)
	
	Player_SetCommandAvailability(player1, SCMD_Retreat, ITEM_UNLOCKED)
	UI_FlashSquadCommandButton(SCMD_Retreat, true)
end

function Park_Counterattack()
	park_counterattack_spawnpoints = Table_GetRandomItem({mkr_enemy_spawn_park_b01, mkr_enemy_spawn_park_b02, mkr_enemy_spawn_park_b03})
	park_counterattack_destinations = Table_GetRandomItem({mkr_enemy_dest_park_ca_01, mkr_enemy_dest_park_ca_02, mkr_enemy_dest_park_ca_03})
	park_counterattack_targets = Table_GetRandomItem({mkr_enemy_target_park_ca_01, mkr_enemy_target_park_ca_02, mkr_enemy_dest_park_ca_03})
	park_counterattack_target = mkr_enemy_target_park_ca
	sg_enemy_park_counterattack = SGroup_CreateIfNotFound("sg_enemy_park_counterattack") -- Counterattack wave
	sg_enemy_park_targets = SGroup_CreateIfNotFound("sg_enemy_park_targets")
	SGroup_AddGroups(sg_enemy_park_targets, {sg_ally_park_01, sg_ally_park_02, sg_player_all})
	
	if SGroup_IsAlive(sg_enemy_park_counterattack) == true then
		print("Counterattack in progress")
	else
	-- Start encounter
	ENCOUNTERS.Park_Counterattack_Startwave()
	end
	FOW_UnRevealArea(Util_GetPosition(mkr_fow_reveal_hmg), 20)
	Objective_Start(SOBJ_HoldPark)
	
	Park_ca_underattack_player = Event_IsEngaged(Park_Counterattack_warn, nil, sg_player_all, ANY, 3, 2)
	Park_ca_underattack_ally = Event_IsEngaged(Park_Counterattack_warn, nil, sg_ally_all, ANY, 3, 2)
	
	Park_ca_underattack = Event_CreateOR(Park_Counterattack_warn, nil, {Park_ca_underattack_player, Park_ca_underattack_ally}, 4)
	-- Respawn some allies to help fight the attackers
	Util_CreateSquads(player2, {sg_ally_all, sg_ally_park_02}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:partisan_squad_city17_nomap"), mkr_ally_spawn_park_back, mkr_enemy_dest_park_ca_01, 1, World_GetRand(2, 3), true)
	Util_CreateSquads(player2, {sg_ally_all, sg_ally_park_02}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:partisan_squad_city17_nomap"), mkr_ally_spawn_park_back, mkr_enemy_dest_park_ca_02, 1, World_GetRand(2, 3), true)
	SGroup_AddAbility(sg_ally_park_02, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_oorah"))
	Cmd_Ability(sg_ally_park_02, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_oorah"), nil, nil, true, false)
	
	-- If player leaves the playzone, he gets nagged and has a timer applied
	--~ tmr_park_oub = 20
	tmr_park_oub = "tmr_park_oub"
	g_park_oub_warned = false
	Rule_AddInterval(Park_Counterattack_oub, 1, 700)
	
	print("Counterattack started")
end

function Park_Counterattack_oub()
	if Prox_ArePlayersNearMarker(player1, mkr_player_trigger_park_oub, false, nil, nil, nil) then
		if Timer_Exists(tmr_park_oub) == false then
			Timer_Start(tmr_park_oub, 20)
			Objective_StartTimer(SOBJ_HoldPark, COUNT_DOWN, 20, 10)
			Rule_AddOneShot(Park_Counterattack_oub_warn, 1, 500)
		else
			if Timer_GetRemaining(tmr_park_oub) == 0 then
				-- Fail OBJ and stop rule
				Rule_RemoveMe()
				Objective_Fail(SOBJ_HoldPark, true)
				Rule_AddOneShot(Mission_Fail, 2)
			end
		end
	else
		-- player left zone
		if Timer_Exists(tmr_park_oub) then 
			Timer_End(tmr_park_oub)
			Objective_StopTimer(SOBJ_HoldPark)
		end
	end
end

function Park_Counterattack_oub_warn()
	if g_park_oub_warned == false then
		Util_StartIntel(EVENTS.OUT_OF_BOUNDS_PARK_01)
		g_park_oub_warned = true
	end
end

function Park_Counterattack_warn()
	if Event_Exists(Park_ca_underattack) then Event_Remove(Park_ca_underattack) end
	Util_StartIntel(EVENTS.BARRAGE_01_WARNING_ALT)
end

function Park_Counterattack_wave2()
	-- Start encounter
	sg_enemy_park_counterattack_veh = SGroup_CreateIfNotFound("sg_enemy_park_counterattack_veh") -- Extra troops for courageous players
	sg_enemy_park_counterattack_wave2 = SGroup_CreateIfNotFound("sg_enemy_park_counterattack_wave2") --
	ENCOUNTERS.Park_Counterattack_wave2()
	if g_hardDiff == true then
		ENCOUNTERS.Park_Counterattack_wave2_veh()
	else
		ENCOUNTERS.Park_Counterattack_wave2_veh_easy()
	end
	
	Park_ca_enemy_endcheck_dead = Event_GroupIsDead(Park_ca_end, nil, sg_enemy_park_counterattack_veh, 1, false) -- Counterattack defeated
--~	Park_ca_enemy_endcheck_retreating = Event_GroupIsDead(Park_ca_end, nil, sg_enemy_park_counterattack, 1, true)
--~	Park_ca_enemy_endcheck_pinned = Event_GroupIsPinned(Park_ca_end, nil, sg_enemy_park_counterattack, ALL, 1)

--~	Park_ca_enemy_endcheck = Event_CreateOR(Park_ca_end, nil, {Park_ca_enemy_endcheck_dead, Park_ca_enemy_endcheck_retreating}, 1)

--~	Rule_AddInterval(Park_Counterattack_Endcheck, 1, 900) -- Using rule system instead

	-- Things are getting bad, here comes bernoi to the rescue
	Park_ca_desperate = Event_IsEngaged(Park_Counterattack_warn2, nil, sg_enemy_park_counterattack_wave2, ALL, 4, 2)
	Rule_AddOneShot(Park_Counterattack_Allies, Park_Counterattack_Allies_delay)
	print("Counterattack wave 2 started")
end

function Park_Counterattack_warn2()
	if Event_Exists(Park_ca_desperate) then Event_Remove(Park_ca_desperate) end
	Util_DelayRandom(4.0, 6.0, function()
	Util_StartIntel(EVENTS.PARK_WAVE2)
	end)
end

function Park_Counterattack_Endcheck()
	if (not SGroup_IsAlive(sg_enemy_park_counterattack)) or SGroup_IsRetreating(sg_enemy_park_counterattack, ALL) then
		Rule_RemoveMe()
		Park_ca_end()
		print("Counterattack defeated")
	end
end

function Park_Counterattack_Retreatcheck()
	if SGroup_IsRetreating(sg_enemy_park_counterattack, ANY) then
		Rule_RemoveMe()
		park_counterattack_defeated_speech = Table_GetRandomItem({EVENTS.ENEMY_BREAKING_01, EVENTS.ENEMY_BREAKING_02, EVENTS.ENEMY_BREAKING_03}, 1)
		Util_StartIntel(park_counterattack_defeated_speech)
		print("Counterattack running away")
	else
	end
end

function Park_Counterattack_Pumacheck()
	if  SGroup_IsAlive(sg_ally_park_puma) == false then
		Rule_RemoveMe()
		Util_CreateSquads(player1, {sg_ally_all, sg_player_all, sg_ally_park_reinforcements}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:conscript_squad_city17_callin"), mkr_ally_spawn_park_back, mkr_enemy_target_park_ca, 1, nil, true, nil, BP_GetUpgradeBlueprint("312430cd68d346ad8badb0bc1ef14b77:rpg_guided_hl2_upgrade"))
		print("New AT unit spawned")
	end
end

function Park_Counterattack_Allies()
	Game_Letterbox( true, 1 )
	-------------------------
	-- Spawn allies and init selection scripts
	-------------------------
	park_allies_cutscene_modifier1 = Modify_Vulnerability(sg_player_all, 0.0)
	park_allies_cutscene_modifier2 = Modify_Vulnerability(sg_enemy_all, 0.25)
	sg_ally_park_reinforcements = SGroup_CreateIfNotFound("sg_ally_park_reinforcements")
	sg_ally_park_puma = SGroup_CreateIfNotFound("sg_ally_park_puma")
	Util_CreateSquads(player2, {sg_player_all, sg_ally_park_reinforcements}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:conscript_squad_city17_callin"), mkr_ally_spawn_barricade_standback, nil, 1, World_GetRand(4, 5), true)
	Util_CreateSquads(player2, {sg_player_all, sg_ally_park_reinforcements, sg_ally_park_puma}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:puma_apc_city17_con"), mkr_ally_spawn_barricade_standback, nil, 1, nil, true)
	
	mod_rec_damage_park_puma = Modify_ReceivedDamage(sg_ally_park_puma, g_rec_damage_park_puma, false)
	
	--~ UI_SetAlliedBandBoxSelection( true )
	Rule_AddInterval(Park_Counterattack_Retreatcheck, 1, 600) -- Enemies are running away from bernoi
	Rule_AddInterval(Park_Counterattack_Pumacheck, 0.5, 600) -- Puma dies, send in some more AT
	-------------------------
	-- Cutscene
	-------------------------
	Util_Delay(1.0, function()
	SGroup_WarpToPos(sg_ally_park_reinforcements, Util_GetPosition(mkr_ally_dest_barricade_standback))
	SGroup_WarpToPos(sg_ally_barricade_all, Util_GetPosition(mkr_ally_dest_barricade_standback))
	Camera_SetOrbit(90) -- angle
	Camera_SetDeclination(-10) -- declination
	Camera_SetZoomDist(5) -- height
	Camera_MoveTo(mkr_camera_barricade_demo, true, 0.5, true, false)
	-- Camera_SetDefault(40, 40, 5) -- Reference for default camera, first is height, second is declination, last is angle/rotation
	Util_StartIntel(EVENTS.BERNOI_DEMO_MARK)
	end)
	-- Blow barricade
	Util_Delay(3.0, function()
		if Player_HasAbility(player2, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_arty_single_shot_instant")) == false then
			Player_AddAbility(player2, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_arty_single_shot_instant"))
		end
		-- Drop shell
		local demo_target = mkr_arty_barricade_demo
		Cmd_Ability(player2, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_arty_single_shot_instant"),  demo_target, Marker_GetDirection(demo_target), true, false)
		-- Kill barricade, just in case
		Util_Delay(0.5, function()
		EGroup_Kill(eg_barricade_roadblock2)
		EGroup_Destroy(eg_barricade_roadblock2)
		-- Kill original barricade for shorter pathing
		EGroup_Kill(eg_barricade_roadblock1)
		EGroup_Destroy(eg_barricade_roadblock1)
		end)
	end)
	Rule_AddOneShot(Park_Allies_demo_barricade_01, 5.0, 800)
end

function Park_Allies_demo_barricade_01()
	Util_StartIntel(EVENTS.BERNOI_DEMO_GO)
	Util_Delay(0.5, function()
	Cmd_Move(sg_ally_park_reinforcements, mkr_ally_dest_park_demo_inf, false, nil, nil, nil, nil, 8)
	Cmd_Move(sg_ally_barricade_all, mkr_ally_dest_park_demo_inf, false, nil, nil, nil, nil, 8)
	end)
	Util_Delay(1.5, function()
	Cmd_Move(sg_ally_park_puma, mkr_ally_dest_park_demo_apc, false)
	--~ Camera_MoveTo(mkr_camera_barricade_demo2, true, 0.15, true, true)
	end)
	Util_Delay(4.0, function()
	Cmd_Move(sg_ally_park_puma, mkr_ally_dest_park_demo_apc, false)
	end)
	Util_Delay(6.0, function()
	Camera_MoveTo(sg_player_01, true, 0.25, false, true)
	Modifier_Remove(park_allies_cutscene_modifier1)
	Modifier_Remove(park_allies_cutscene_modifier2)
	park_allies_cutscene_modifier_end1 = Modify_Vulnerability(sg_player_all, 0.75)
	park_allies_cutscene_modifier_end2 = Modify_Vulnerability(sg_player_01, 0.5)
	SGroup_SetPlayerOwner(sg_ally_park_reinforcements, player1)
	--~ Modify_Vulnerability(sg_enemy_park_counterattack_veh, 1.25)
	park_allies_cutscene_done = true
	_ResetCamera()
	Cmd_AttackMove(sg_ally_park_reinforcements, Util_GetPosition(mkr_enemy_dest_park_ca_03), false, nil, 8)
	Util_StartIntel(EVENTS.BERNOI_DEMO_AMBIENT)
	end)
end

function Park_ca_end()
	-- End scripts
	if Event_Exists(Park_ca_enemy_endcheck_dead) then Event_Remove(Park_ca_enemy_endcheck_dead) end
	--~ if Event_Exists(Park_ca_enemy_endcheck_pinned) then Event_Remove(Park_ca_enemy_endcheck_pinned) end
	--~ if Event_Exists(Park_ca_enemy_endcheck) then Event_Remove(Park_ca_enemy_endcheck) end
	Rule_RemoveIfExist(Park_Counterattack_Pumacheck)
	
	if SGroup_IsAlive(sg_enemy_park_counterattack) then
		local retreat_location = {mkr_enemy_park_retreat_end, }
		Cmd_StaggeredRetreat(sg_enemy_park_counterattack, retreat_location, 3, true)
	end
	-- Complete objective
	Util_Delay(1.0, function()
	Objective_Complete(SOBJ_HoldPark, false)
	Objective_Complete(SOBJ_Park, true)
	end)
	
	-- Capture territory
	EGroup_InstantCaptureStrategicPoint(pg_park, player1)
	World_IncreaseInteractionStage()
	
	-- Blockers are more vulnerable 
	Modifier_RemoveAllFromSGroup(sg_enemy_park_blockers)
	Modify_WeaponSuppression(sg_enemy_park_blockers, "hardpoint_01", 0.5)
	Modifier_Remove(park_allies_cutscene_modifier_end1)
	Modifier_Remove(park_allies_cutscene_modifier_end2)
	
	-- Add retreat point
	player_retreat_point_02 = EGroup_CreateIfNotFound("player_retreat_point_02")
	Util_CreateEntities(player1, {world_object_spawns, player_retreat_point_02}, BP_GetEntityBlueprint("sp_retreat_point"), mkr_player_retreat_park_hq, 1, nil)
	EGroup_DeSpawn(player_retreat_point_01)
	
	---------------------
	-- Create HQ
	if EGroup_GetAvgHealth(eg_park_player_hq) >= 0.5 then -- Building is not too damaged
		Modifier_Remove(mod_eg_park_player_hq)
		if Util_GetPlayerOwner(eg_park_player_hq) == nil then 
		--~	Util_SetPlayerOwner(EGroup_GetSpawnedEntityAt(eg_park_player_hq, 1), player2, true)
		--~	Util_CreateSquads(player2, sg_ally_all, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:conscript_squad_city17"), eg_park_player_hq, nil, 1)
		end
		if Player_HasAbility(player2, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:forward_hq_noreq_sp")) == false then
			Player_AddAbility(player2, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:forward_hq_noreq_sp"))
		end
		--~	Cmd_Ability(player2, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:forward_hq_noreq_sp"), EGroup_GetSpawnedEntityAt(eg_park_player_hq, 1), nil, true, false)
		eg_ally_forward_hq_aura = EGroup_CreateIfNotFound("eg_ally_forward_hq_aura")
		Util_CreateEntities(player2, {world_object_spawns, eg_ally_forward_hq_aura}, BP_GetEntityBlueprint("reinforcement_point_healing_aura"), Util_GetPosition(eg_park_player_hq), 1, nil)
		HintMouseover_Add(11084823, eg_park_player_hq, 12, false)
		print("HQ converted")
	else
		-- Spawn a half-track
		sg_ally_park_halftrack = SGroup_CreateIfNotFound("sg_ally_park_halftrack")
		Util_CreateSquads(player2, {sg_ally_all, sg_ally_park_halftrack}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:m5_halftrack"), mkr_ally_entry03, mkr_ally_dest_park_fhq_track, 1, nil, true)
		HintMouseover_Add(1449058, sg_ally_park_halftrack, 10, false)
		print("halftrack spawned")
	end
	---------------------
	
	-- Puma can smash walls
	if SGroup_IsAlive(sg_ally_park_puma) then
		Entity_SetCrushMode(Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_ally_park_puma, 1), 0), Crush_Medium)
	end
	
	-- Modifiers and other stats
	SGroup_SetInvulnerable(sg_ally_barricade_01, false)
	Player_SetPopCapOverride(player1, 24)
	
	-- Start Trainstation
	--~ Rule_AddOneShot(Trainstation_Start, 2, 900)
	Trainstation_Start_event = Event_NarrativeEventsNotRunning(Trainstation_Start, nil, 4)
	
	print("Park is done, onto the final task")
end

-------------------------------------------------------
-- Lemme tell you a story behind the counterattack;
--
-- The idea was to make it a infinite wave section, stopping once the player
-- was thoroughly beaten. This was thrown out right before I started any work
-- on it. Bernoi was always supposed to break through the barricade, though
-- I was planning on using a tank to crush it at first. Better camera angles
-- for the "epic" cinematic and such.
--
-- After that, I favored a more linear concept, the one which is used is the only version
-- really. This holds true with the train-station aswell. You might have guessed, this project
-- did not have much of a road-map. Most of it was getting cool ideas, throwing it at the game,
-- and seeing if they stuck.
--
-- The only noteworthy thing is how the attack was going to work. At first, I didnt want to
-- use the encounter system. I saw it in the main game and thought it was okay, but it all 
-- seemed a little stiff and obviously AI controlled. I wanted something seamless, a substitute
-- for the inability to add new squad-ai (as of 4/11/2018). I remembered this nifty thing in 
-- CoH that was similar to it, a in-between of the encounters and squad-ai. This was the combat-plan
-- system. I figured that, by using abilities in conjuction with cover-searches and moves, I could
-- create something close to squad-ai. I tried it, and no matter what I did I couldnt get the combat-plan
-- system to work on a large-scale. In TOV, you only control one or two units at once, heroes like 
-- its dota or something. This was designed with that in mind sadly, and I didnt have the patience or 
-- copyright holding to modify the system to suit my needs.
--
-- If you're wondering why I'm leaving these little stories, its because there is no "HL2 Beta Scenario"
-- for most games or works. I think its great to see behind the scenes, some people might like
-- the ideas I thought were bad, and somehow make them good. There's a reason I based this mission off
-- of a beta mission, I quite like the HL2 beta and its darker atmosphere, but I guess someone at
-- valve didnt. Who knows why they changed it, all that matters is that they still made a good game.
-------------------------------------------------------


--****************************
-- THE TRAINSTATION --
--****************************
function Trainstation_Start()
	
	-- Start scripts
	if Event_Exists(Trainstation_Start_event) then Event_Remove(Trainstation_Start_event) end
	Rule_AddOneShot(Trainstation_Main_Start, 5, 900)
	Rule_AddOneShot(Trainstation_Bonus_Start, 6, 800)
	
	-- Cutscene intel and Camera
	Rule_AddOneShot(Trainstation_Start_Cutscene, 3, 700)
	
	-- Set values
	
	-- Spawn blockers
	sg_enemy_trainstation_blockers = SGroup_CreateIfNotFound("sg_enemy_trainstation_blockers") --
	sg_enemy_trainstation_blockers_atguns = SGroup_CreateIfNotFound("sg_enemy_trainstation_blockers_atguns")
	
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_trainstation_blockers}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_indust_blocker_hmg, nil, 1, 4, false, nil, BP_GetUpgradeBlueprint("312430cd68d346ad8badb0bc1ef14b77:mg42_gren_noreq"))
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_trainstation_blockers, sg_enemy_trainstation_blockers_atguns}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:pak_36_at_gun_squad_sp"), mkr_enemy_spawn_indust_blocker_at, nil, 1, 3, false, nil)
	-- Modifiers
	Modify_WeaponDamage(sg_enemy_trainstation_blockers, "hardpoint_01", 0.75)
	Modify_Vulnerability(sg_enemy_trainstation_blockers, 0.25)
	Modify_WeaponRange(sg_enemy_trainstation_blockers_atguns, "hardpoint_01", 0.75)
	Modify_WeaponDamage(sg_enemy_trainstation_blockers, "hardpoint_01", 0.75)
	
	print("Trainstation scripts started")
end

function Trainstation_Start_Cutscene()
	print("Trainstation Cutscene in progress")
	-- Start intel
	Util_StartIntel(EVENTS.NIS_RAILWAY)
	-- LOCDB [11022142] 'Good work, comrade captain. But we still have much to do.' - 'Polivanov'
	Cmd_Stop(sg_player_all)
	
	Util_Delay(3.0, function()
    Camera_MoveTo(mkr_hint_train_main, true, 0.1, true, true)
	-- LOCDB [11022120] 'Our goal is here, the rail-station. However, there are entrenched fascists in our path.' - 'Polivanov'
	end)
	
	Util_Delay(12.0, function()
    Camera_MoveTo(mkr_hint_train_bonus, true, 0.2, true, false)
	print("Trainstation Cutscene finished")
	end)
	-- LOCDB [11022109] 'You will need machine-guns and mortars to clear the rats out of the railway station.' - 'Polivanov'
	
	Util_Delay(19.0, function()
    Camera_MoveTo(sg_player_01, true, 0.2, false, false)
	print("Trainstation Cutscene finished")
	end)
	
end

function Trainstation_Bonus_Start()
	-- Start scripts
	
	Objective_Start(SOBJ_Trainstation_bonus, false)
	
	-- Spawn bad-guys
	sg_enemy_trainstation_bonus = SGroup_CreateIfNotFound("sg_enemy_trainstation_bonus") -- Real troops
	sg_enemy_trainstation_bonus_alt = SGroup_CreateIfNotFound("sg_enemy_trainstation_bonus_alt") -- Alt troops
	
	-- Front
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_trainstation_bonus_alt}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_train_bonus_01, nil, 1, Trainstation_bonus_loadout02, true)
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_trainstation_bonus_alt}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_train_bonus_02, nil, 1, Trainstation_bonus_loadout02, true)
	-- Main
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_trainstation_bonus}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_train_bonus_03, nil, 1, Trainstation_bonus_loadout01, true)
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_trainstation_bonus}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_train_bonus_04, nil, 1, Trainstation_bonus_loadout02, true)
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_trainstation_bonus}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_train_bonus_05, nil, 1, Trainstation_bonus_loadout02, true)
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_trainstation_bonus}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_train_bonus_06, nil, 1, Trainstation_bonus_loadout01, true)
	
	-- Weapons
	eg_trainstation_bonus_weapons = EGroup_CreateIfNotFound("eg_trainstation_bonus_weapons")
	
	Util_CreateEntities(nil, {world_object_spawns, eg_trainstation_bonus_weapons}, BP_GetEntityBlueprint("axis_panzerbusche39_mp"), mkr_world_train_bonus_03, 1, nil)
	Util_CreateEntities(nil, {world_object_spawns, eg_trainstation_bonus_weapons}, BP_GetEntityBlueprint("312430cd68d346ad8badb0bc1ef14b77:axis_mg42_noreq"), mkr_world_train_bonus_01, 1, nil)
	if g_hardDiff == true then
		Util_CreateEntities(nil, {world_object_spawns, eg_trainstation_bonus_weapons}, BP_GetEntityBlueprint("312430cd68d346ad8badb0bc1ef14b77:axis_mg42_noreq"), mkr_world_train_bonus_02, 1, nil)
	else
		Util_CreateEntities(nil, world_object_spawns, BP_GetEntityBlueprint("granatewerfer_34_81mm_mortar_mp"), mkr_world_train_bonus_02, 1, nil)
	end
	-- Spawn satchel charges
	world_object_train_bonus_charges = EGroup_CreateIfNotFound("world_object_train_bonus_charges")
	Util_CreateEntities(nil, {world_object_spawns, world_object_train_bonus_charges}, BP_GetEntityBlueprint("312430cd68d346ad8badb0bc1ef14b77:satchel_charges_e3_barricade"), mkr_world_bonus_satchel_charges, 1, nil)
	
	-- Truck
	sg_enemy_trainstation_bonus_truck = SGroup_CreateIfNotFound("sg_enemy_trainstation_bonus_truck")
	eg_enemy_trainstation_bonus_truck = EGroup_CreateIfNotFound("eg_enemy_trainstation_bonus_truck")
	
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_trainstation_bonus_truck}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:halftrack_squad_city17_wep"), mkr_enemy_spawn_train_bonus_truck, nil, 1)
	
	-- If truck dies, it drops the weapons
	Entity_SetCrushMode(Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_enemy_trainstation_bonus_truck, 1), 0), Crush_Medium)
	Entity_SetAnimatorState(Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_enemy_trainstation_bonus_truck, 1), 0), "set_random_supplies", "canopy")
	Entity_SetAnimatorState(Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_enemy_trainstation_bonus_truck, 1), 0), "supplies_loaded", "partial")
	-- Start timer and related logic
	tmr_train_Truck = "tmr_train_Truck"
	Timer_Start(tmr_train_Truck, g_truck_depart_time)
	Rule_AddInterval(Trainstation_Bonus_trucklogic, 1, 600)
	
	-- Front guys retreat if main troops are killed
	Rule_AddInterval(Trainstation_Bonus_sentry_retreat, 2, 500)
	
	-- end checks
	Rule_AddInterval(Trainstation_Bonus_endcheck_clear, 1, 600)
	Rule_AddInterval(Trainstation_Bonus_endcheck_weapons, 1.5, 600)
	
	-- Stop obj hint when player gets close
	Trainstation_bonus_hint_01 = Event_Proximity(Trainstation_Bonus_Hint_Stop, nil, player1, mkr_player_trigger_train_bonus_enter, nil, ANY, 1)
	Trainstation_bonus_hint_02 = Event_Proximity(Trainstation_Bonus_Hint_Stop, nil, player1, mkr_player_trigger_train_bonus_back, nil, ANY, 1)
	Trainstation_bonus_hint_03 = Event_Proximity(Trainstation_Bonus_Hint_Stop, nil, player1, mkr_player_trigger_train_bonus_block, nil, ANY, 1)
	Trainstation_bonus_hint_04 = Event_Proximity(Trainstation_Bonus_Hint_Stop, nil, player1, mkr_player_trigger_train_bonus_road, nil, ANY, 1)
	
	Trainstation_bonus_hint = Event_CreateOR(Trainstation_Bonus_Hint_Stop, nil, {Trainstation_bonus_hint_01, Trainstation_bonus_hint_02, Trainstation_bonus_hint_03, Trainstation_bonus_hint_04}, 1)
	print("Trainstation Bonus scripts started")
end

function Trainstation_Bonus_sentry_retreat()
	if SGroup_IsAlive(sg_enemy_trainstation_bonus) == false or SGroup_IsRetreating(sg_enemy_trainstation_bonus, ALL) then
		Rule_RemoveMe()
		Cmd_Retreat(sg_enemy_trainstation_bonus_alt, mkr_enemy_park_retreat_end, mkr_enemy_park_retreat_end, false)
		print("Sentry retreating")
	end
end

function Trainstation_Bonus_trucklogic()
	if Timer_Exists(tmr_train_Truck) and SGroup_IsAlive(sg_enemy_trainstation_bonus_truck) and Objective_IsStarted(SOBJ_Trainstation_bonus) then
		if Timer_GetRemaining(tmr_train_Truck) == 0 then
			-- End timer
			Timer_End(tmr_train_Truck)
			-- Despawn weapons
			EGroup_DeSpawn(eg_trainstation_bonus_weapons)
			-- Path order
			Cmd_SquadPath(sg_enemy_trainstation_bonus_truck, "path_train_bonus_truck", true, false, false, 0, mkr_enemy_dest_train_bonus_truck, false)
			-- Fail obj
			Objective_StopTimer(SOBJ_Trainstation_bonus)
			Objective_Fail(SOBJ_Trainstation_bonus, false)
			Objective_Start(SOBJ_Trainstation_bonus_truck, true)
			-- Start truck death check
			
			Rule_RemoveMe()
		end
	else
		Objective_StopTimer(SOBJ_Trainstation_bonus)
		Rule_RemoveMe()
	end
end

function Trainstation_Bonus_endcheck_weapons()
	if EGroup_IsEmpty(eg_trainstation_bonus_weapons) == true then
		Objective_StopTimer(SOBJ_Trainstation_bonus)
		Objective_Complete(SOBJ_Trainstation_bonus, true)
		print("All Weapons picked up")
		Rule_RemoveIfExist(Trainstation_Bonus_trucklogic)
		Rule_RemoveMe()
		if SGroup_IsAlive(sg_ally_barricade_01) then
			Util_StartIntel(EVENTS.BONUS_COMPLETE)
		end
	end
end

function Trainstation_Bonus_endcheck_clear()
	if SGroup_IsAlive(sg_enemy_trainstation_bonus) == false then
		Objective_StopTimer(SOBJ_Trainstation_bonus)
		print("All bad guys dead")
		Rule_RemoveIfExist(Trainstation_Bonus_trucklogic)
		-- Good job, now get the guns
		if SGroup_IsAlive(sg_ally_barricade_01) then
		--~	Util_StartIntel(EVENTS.PICKUP_WEAPONS_01)
		end
		Util_DelayRandom(2.0, 4.0, function()
			-- Truck drives for it
			Cmd_SquadPath(sg_enemy_trainstation_bonus_truck, "path_train_bonus_truck", true, false, false, 0, mkr_enemy_dest_train_bonus_truck, false)
		end)
		Rule_RemoveMe()
	end
end

function Trainstation_Bonus_Hint_Stop()
	if Event_Exists(Trainstation_bonus_hint) then Event_Remove(Trainstation_bonus_hint) end
	Objective_RemoveUIElements(SOBJ_Trainstation_bonus, hpid_train_bonus)
end

function Trainstation_Main_Start()
	-- Start scripts
	
	-- Start OBJ
	Objective_Start(SOBJ_Trainstation, true)
	Util_StartIntel(EVENTS.CONSCRIPTS_AVAILABLE)
	
	-- Spawn units
	sg_enemy_trainstation_01 = SGroup_CreateIfNotFound("sg_enemy_trainstation_01") -- Main troops
	sg_enemy_trainstation_ai = SGroup_CreateIfNotFound("sg_enemy_trainstation_ai") -- Main troops for ai
	sg_enemy_trainstation_02 = SGroup_CreateIfNotFound("sg_enemy_trainstation_02") -- Alt troops
	sg_enemy_trainstation_03 = SGroup_CreateIfNotFound("sg_enemy_trainstation_03") -- Troops outside the main station area
	sg_enemy_trainstation_04 = SGroup_CreateIfNotFound("sg_enemy_trainstation_04") -- Harmless troops
	
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_trainstation_03}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_train_01, nil, 1, Trainstation_loadout02, true)
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_trainstation_03}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_train_02, nil, 1, Trainstation_loadout02, true)
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_trainstation_03}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_train_03, nil, 1, Trainstation_loadout01, true, nil)
	
	-- Give slot item
	if g_hardDiff == true then
		Squad_CompleteUpgrade(SGroup_GetSpawnedSquadAt(sg_enemy_trainstation_03, 2), BP_GetUpgradeBlueprint("312430cd68d346ad8badb0bc1ef14b77:mg42_gren_noreq"))
	--~	Cmd_InstantUpgrade(sg_enemy_trainstation_03, BP_GetUpgradeBlueprint("312430cd68d346ad8badb0bc1ef14b77:mg42_gren_noreq"), 1)
	else
		Squad_CompleteUpgrade(SGroup_GetSpawnedSquadAt(sg_enemy_trainstation_03, 1), BP_GetUpgradeBlueprint("312430cd68d346ad8badb0bc1ef14b77:axis_panzerbusche39_mp"))
	end
	
	-- Main defenders
	ENCOUNTERS.Trainstation_Defenders()
	
	sg_enemy_trainstation_atgun = SGroup_CreateIfNotFound("sg_enemy_trainstation_atgun")
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_trainstation_atgun}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:pak_36_at_gun_squad_sp"), mkr_enemy_spawn_train_05, nil, 1, 4, false) -- AT gun
	Modify_WeaponDamage(sg_enemy_trainstation_atgun, "hardpoint_01", 0.75)
	Modify_WeaponAccuracy(sg_enemy_trainstation_atgun, "hardpoint_01", 1.15)
	
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_trainstation_03}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_train_06, nil, 1, Trainstation_loadout03, true)
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_trainstation_03}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_train_07, nil, 1, Trainstation_loadout03, true)
	
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_trainstation_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), eg_trainstation, nil, 1, Trainstation_loadout01, true)
	Modify_WeaponDamage(sg_enemy_trainstation_01, "hardpoint_01", g_damage_trainstation_1)
	-- Upgrades
	Squad_CompleteUpgrade(SGroup_GetSpawnedSquadAt(sg_enemy_trainstation_01, 1), BP_GetUpgradeBlueprint("312430cd68d346ad8badb0bc1ef14b77:mg42_gren_noreq"))
	Squad_CompleteUpgrade(SGroup_GetSpawnedSquadAt(sg_enemy_trainstation_01, 1), BP_GetUpgradeBlueprint("312430cd68d346ad8badb0bc1ef14b77:mg34_ost"))
	
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_trainstation_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_train_09, nil, 1, Trainstation_loadout02, true)
	Squad_CompleteUpgrade(SGroup_GetSpawnedSquadAt(sg_enemy_trainstation_01, 2), BP_GetUpgradeBlueprint("312430cd68d346ad8badb0bc1ef14b77:panzerbusche_39"))
	
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_trainstation_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_train_10, nil, 1, Trainstation_loadout03, true)
	
	-- Squad-ai makes them move about without orders from ai
	Squad_SetRetaliationPlan(SGroup_GetSpawnedSquadAt("sg_enemy_trainstation_03", 2), "infantry-idle-plan-nomove")
	Squad_SetRetaliationPlan(SGroup_GetSpawnedSquadAt("sg_enemy_trainstation_03", 3), "guards-ptrs-infantry-plan")
	Squad_SetRetaliationPlan(SGroup_GetSpawnedSquadAt("sg_enemy_trainstation_03", 4), "guards-ptrs-infantry-plan")
	Squad_SetRetaliationPlan(SGroup_GetSpawnedSquadAt("sg_enemy_trainstation_03", 5), "guards-infantry-plan")
	
	Squad_SetRetaliationPlan(SGroup_GetSpawnedSquadAt("sg_enemy_trainstation_01", 3), "guards-ptrs-infantry-plan")
	
	-- Spawn allies to endlessly die trying to take the station
	sg_ally_trainstation = SGroup_CreateIfNotFound("sg_ally_trainstation") -- Allies spawned for trainstation
	sg_ally_trainstation_ambient = SGroup_CreateIfNotFound("sg_ally_trainstation_ambient")
	
	g_trainstation_ally_wavecount = 1
	Rule_AddInterval(Trainstation_Allies_Ambient, 3, 600)
	-- Waves get better troops after awhile
	--~
	Rule_AddInterval(Trainstation_Enemy_Ambient, 3, 600)
	-- Stuka comes in when enemies are dying
	Rule_AddInterval(Trainstation_Stuka_Gunship, 5, 600)

	-- Stop obj hint when player gets close
	Trainstation_prox_01 = Event_Proximity(Trainstation_Zone_Enter, nil, player1, mkr_player_trigger_train_westalley, nil, ANY, 1)
	Trainstation_prox_02 = Event_Proximity(Trainstation_Zone_Enter, nil, player1, mkr_player_trigger_train_westroad, nil, ANY, 1)
	Trainstation_prox_03 = Event_Proximity(Trainstation_Zone_Enter, nil, player1, mkr_player_trigger_train_southroad, nil, ANY, 1)
	
	Trainstation_prox = Event_CreateOR(Trainstation_Zone_Enter, nil, {Trainstation_prox_01, Trainstation_prox_02, Trainstation_prox_03}, 1)
	
	-- Endchecks
	Rule_AddInterval(Trainstation_Endcheck_Stg1, 1, 800)
	trainstation_defeated_speech = Table_GetRandomItem({EVENTS.ENEMY_BREAKING_01, EVENTS.ENEMY_BREAKING_02, EVENTS.ENEMY_BREAKING_03}, 1)
	-- Music and other ambient stuff
	Sound_SetMusicCombatValue(0, 0)
	
	-- Take care of leftover allies
	Cmd_AttackMove(sg_ally_all, Util_GetPosition(mkr_ally_dest_park_fhq_track), false, nil, 7)
	-- Combat
	Cmd_AttackMove(sg_ally_barricade_01, Util_GetPosition(mkr_ally_dest_train_blocker_02), true, nil, 5)
	Cmd_AttackMove(sg_ally_barricade_02, Util_GetPosition(mkr_ally_dest_train_blocker_01), true, nil, 5)
	
	print("Trainstation main started")
end

function Trainstation_Zone_Enter()
	-- Stop prox check
	if Event_Exists(Trainstation_hint) then Event_Remove(Trainstation_hint) end
	-- Stop hint
	Objective_RemoveUIElements(SOBJ_Trainstation, hpid_train_main)
	-- Whats all that racket?
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_trainstation_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_train_04, mkr_enemy_dest_train_01, 1, Trainstation_loadout02, true)
end

function Trainstation_Allies_Ambient()
	if SGroup_IsAlive(sg_ally_trainstation_ambient) then
		print("Ambient allies are still alive")
	else
		Util_CreateSquads(player2, {sg_ally_all, sg_ally_trainstation_ambient}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:partisan_squad_city17_nomap"), mkr_ally_entry03, mkr_ally_dest_train_main, 1, World_GetRand(3, 5), true)
		Util_CreateSquads(player2, {sg_ally_all, sg_ally_trainstation_ambient}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:partisan_squad_city17_harmless"), mkr_ally_entry03, mkr_ally_dest_train_main, 1, World_GetRand(4, 5), true)
		
		_SgroupSetAmbient(sg_ally_trainstation_ambient, false)
		--~	g_trainstation_ally_wavecount = 
		print("Ambient allies spawned")
	end
end

function Trainstation_Enemy_Ambient()
	if SGroup_IsAlive(sg_enemy_trainstation_02) then
		print("Ambient enemies are still alive")
	else
		Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_trainstation_02}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_train_entry_01, mkr_enemy_dest_park_ca_03, 1, Trainstation_loadout02, true)
		Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_trainstation_02}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_train_entry_02, mkr_enemy_dest_park_ca_03, 1, Trainstation_loadout02, true)
		
		--~	_SgroupSetAmbient(sg_enemy_trainstation_02, false)
		print("Ambient enemies spawned")
	end
	if SGroup_IsAlive(sg_enemy_trainstation_03) == false then
		Rule_RemoveMe()
		print("Ambient enemies stopped")
	end
end

function Trainstation_Stuka_Gunship()
	if (not SGroup_IsAlive(sg_enemy_trainstation_03)) then
		Cmd_Ability(player3, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:seafloor_gunship_ability"), mkr_stuka_trainstation, nil, true)
		Util_DelayRandom(2.0, 4.0, function()
		Util_StartIntel(EVENTS.INCOMING_STUKA)
		end)
		Rule_RemoveMe()
		print("Stuka coming in")
	end
end

function Trainstation_Endcheck_Stg1()
	if (not SGroup_IsAlive(sg_enemy_trainstation_01)) then
		Rule_RemoveMe()
		if SGroup_IsAlive(sg_enemy_trainstation_ai) then
			Cmd_StaggeredRetreat(sg_enemy_trainstation_ai, {mkr_enemy_spawn_train_entry_01, mkr_enemy_spawn_train_entry_02}, 4, true)
			Util_StartIntel(trainstation_defeated_speech)
		else
			
		end
		-- Spawn molotov troops
		Util_CreateSquads(player2, {sg_ally_all, sg_ally_trainstation}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:partisan_squad_city17_nomap"), mkr_ally_spawn_train_alley, Util_GetRandomPosition(mkr_ally_dest_train_main, 8), 1, World_GetRand(3, 5), true)
		Util_CreateSquads(player2, {sg_ally_all, sg_ally_trainstation}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:partisan_squad_city17_nomap"), mkr_ally_spawn_train_alley, Util_GetRandomPosition(mkr_ally_dest_train_main, 8), 1, World_GetRand(3, 5), true)
		-- Give command
		SGroup_AddAbility(sg_ally_trainstation, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_oorah"))
		Cmd_Ability(sg_ally_trainstation, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_oorah"), nil, nil, true, false)
		--~	Command_SquadPosAbility(player2, SGroup_GetSpawnedSquadAt(sg_ally_trainstation, 1), Util_GetPosition(mkr_ally_ability_train_moly1), BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:molotov_cocktail_squad"), true, true)
		Command_SquadPosAbility(player2, sg_ally_trainstation, Util_GetPosition(mkr_ally_ability_train_moly3), BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:molotov_cocktail_squad"), true, false)
		-- Rest of the end stuff
		Trainstation_endcheck_speech = Event_NarrativeEventsNotRunning(Trainstation_Endcheck_Stg2, nil, 2)
		-- Check if HQ is burning or dead
		Trainstation_hq_deathcheck = Event_GroupIsDead(Trainstation_hq_destroy, nil, eg_trainstation, 0, false)
		Trainstation_hq_burncheck = Event_GroupBurning(Trainstation_hq_destroy, nil, eg_trainstation, 0)
	
		Trainstation_hq_check = Event_CreateOR(Trainstation_hq_destroy, nil, {Trainstation_hq_deathcheck, Trainstation_hq_burncheck}, 1)
		--~	Rule_AddOneShot(Trainstation_Endcheck_Stg2, 1, 800)
		print("First endcheck done")
	end
end

function Trainstation_Endcheck_Stg2()
	-- Start actual end check
	if Event_Exists(Trainstation_endcheck_speech) then Event_Remove(Trainstation_endcheck_speech) end
	-- Start speech
	Camera_MoveTo(mkr_camera_trainstation_end, true, 0.1, true, false)
	Util_StartIntel(EVENTS.NIS_END)
	
	Trainstation_endcheck_end = Event_NarrativeEventsNotRunning(Trainstation_End, nil, 1)
	print("Second endcheck done")
end

function Trainstation_hq_destroy()
	if Event_Exists(Trainstation_hq_check) then Event_Remove(Trainstation_hq_check) end
	if EGroup_Exists("eg_trainstation_gun") then 
		EGroup_Kill(eg_trainstation_gun)
		EGroup_DeSpawn(eg_trainstation_gun)
	end
	if EGroup_Exists("eg_trainstation") then 
		EGroup_Kill(eg_trainstation)
	end
end

function Trainstation_End()
	if Event_Exists(Trainstation_endcheck_end) then Event_Remove(Trainstation_endcheck_end) end
	-- End mission
	Rule_RemoveIfExist(Player_Check) 
	End_Mission()
	Rule_RemoveMe()
	print("Congraturlation!")
end

--
--********************************************************************************************************
------------------------------------------- END OF MAIN SCRIPTS ------------------------------------------
--********************************************************************************************************
--

---------------------------
-- End-game Functions
---------------------------
function Player_Check()
	-----------------------
	-- Player triggers
	-- Player_is_dead = Event_GroupIsDead(Fail_All_Obj, nil, sg_player_01, 0, false) -- Morgan is dead
	if SGroup_IsAlive(sg_player_01) == false then
		Rule_AddOneShot(Fail_Obj_player, 0)
		Rule_RemoveMe()
	end
end

function Fail_Obj_player()
	-- Disable all ally invuln for visuals
	SGroup_SetInvulnerable(sg_ally_all, false)
	-- Main obj
	Objective_Fail(OBJ_Main, true)
	-- Secondary objs
	Objective_Fail(SOBJ_Barricade, false)
	Objective_Fail(SOBJ_Park, false)
	Objective_Fail(SOBJ_Trainstation, false)
	Objective_Fail(SOBJ_Trainstation_bonus, false)
	
	if Timer_Exists(tmr_train_Truck) then
		Timer_End(tmr_train_Truck)
	end
	-- Objective_Fail(OBJ_sampletext, false)
	Rule_RemoveMe()
	
end

function End_Mission()
	g_missionWon = true
	Event_Skip()
	
	----------- Section for special scripts
	if EGroup_Exists("eg_trainstation_gun") then
		Rule_AddOneShot(Trainstation_hq_destroy, 0, 500)
	end
	
	Player_GetAll(player3, sg_enemy_all)
	if SGroup_Exists("sg_enemy_all") or SGroup_IsAlive(sg_enemy_all) then
		SGroup_Kill(sg_enemy_all)
	end
	----------- End of section
	
	--~	UI_ScreenFade(118, 74, 29, 100, 7, false)
	
	Util_MuteAmbientSound(true, 4.5)
	
	Rule_AddOneShot(Mission_Complete, 4.0)
	Objective_Complete(OBJ_Main, true)
	Rule_RemoveMe()

end

function Mission_Complete()

	-- Set the winning team (this will fire win/loss events for each player)
	-- World_SetTeamWin(1)
	World_SetPlayerWin(player1)

end

function Mission_Fail()
	g_missionFailed = true
	Event_Skip()
	
	UI_ScreenFade(118, 74, 29, 100, 7, false)
	
	Util_MuteAmbientSound(true, 1.5)
	
	Rule_AddOneShot(Mission_Fail_Complete, 2.5)
	Rule_RemoveMe()

end

function Mission_Fail_Complete()

	-- Set the winning team (this will fire win/loss events for each player)
	-- World_SetTeamWin(3)
	World_SetPlayerWin(player3)

end

--
--********************************************************************************************************
------------------------------------------------ OBJECTIVES ----------------------------------------------
--********************************************************************************************************
--
---------------------------
--******
-- MAIN Objective
--******
---------------------------
function INIT_MainOBJ()

	OBJ_Main = {
		-- Info			
		Title = "$312430cd68d346ad8badb0bc1ef14b77:1334",		-- LOCDB [1334] 'Secure the City' 
		TitleEnd = "$312430cd68d346ad8badb0bc1ef14b77:1336", 	-- LOCDB [1336] 'City Taken'
		TitleFail = "$312430cd68d346ad8badb0bc1ef14b77:1337", 	-- LOCDB [1337] 'Attack Failed - Morgan is Dead'  -- alt -- [1335] 'Attack Failed'
		Type = OT_Primary,	-- Objective Type (OT_Primary, OT_Secondary)
		Parent = nil,
		subObjectives = {},
		
		--Intel
		Intel_Start = 				nil,	-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = 		nil,	-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			nil,	-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = 	nil,	-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				nil,	-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = 		nil,	-- Function to play if Intel_Fail is Skipped
		
		--Functions
		SetupUI = function() 
			
		end,
		
		PreStart = nil,
		
		OnStart = function()
		
		-- Rule_AddOneShot(Barricade_Start, 1) -- Started on mission start instead
		
		end,
		
		IsComplete = function()
			return false
		end,
		
		PreComplete = nil,
		
		OnComplete = function()
			
		end, 
		
		IsFailed = nil,
		
		PreFail = nil,
		
		OnFail = function()
			if g_missionFailed == false then
				g_missionFailed = true
				Rule_AddOneShot(Mission_Fail, 2.5)			
			end	
		end,
		
		
		-- IsComplete = function() -- Template for functions that do stuff
		--	return false
		-- end,			
	}
	
	Objective_Register(OBJ_Main)

end

---------------------------
--******
-- Secondary Objectives
--******
---------------------------
function INIT_BarricadeSOBJ()

	SOBJ_Barricade = {
		-- Info			
		Title = "$312430cd68d346ad8badb0bc1ef14b77:1368",		-- LOCDB [1368] 'Secure Western District' 
		TitleEnd = "$312430cd68d346ad8badb0bc1ef14b77:1380", 	-- LOCDB [1380] 'Barricade Taken'
		TitleFail = "$312430cd68d346ad8badb0bc1ef14b77:1370", 	-- LOCDB [1370] 'Attack Failed - Enemy Troops Held'  -- alt -- [1335] 'Attack Failed'
		Type = OT_Secondary,	-- Objective Type (OT_Primary, OT_Secondary)
		Parent = nil,
		subObjectives = {},
		
		--Intel
		Intel_Start = 				nil,	-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = 		nil,	-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			nil,	-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = 	nil,	-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				nil,	-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = 		nil,	-- Function to play if Intel_Fail is Skipped
		
		--Functions
		SetupUI = function() 
			
		end,
		
		PreStart = nil,
		
		OnStart = function()
		
		
		end,
		
		IsComplete = function()
			return false
		end,
		
		PreComplete = nil,
		
		OnComplete = function()
			-- Save
			-- Util_Autosave("$312430cd68d346ad8badb0bc1ef14b77:1334", 0, false)
		end, 
		
		IsFailed = nil,
		
		PreFail = nil,
		
		OnFail = function()
		
		end,
		
		
		-- IsComplete = function() -- Template for functions that do stuff
		--	return false
		-- end,			
	}
	
	Objective_Register(SOBJ_Barricade)

end

function INIT_ParkSOBJ()

	SOBJ_Park = {
		-- Info			
		Title = "$312430cd68d346ad8badb0bc1ef14b77:1390",		-- LOCDB [1390] 'Secure the City Square' 
		TitleEnd = "$312430cd68d346ad8badb0bc1ef14b77:1391", 	-- LOCDB [1391] 'Square Secured'
		TitleFail = "$312430cd68d346ad8badb0bc1ef14b77:1370", 	-- LOCDB [1370] 'Attack Failed - Enemy Troops Held'  -- alt -- [1335] 'Attack Failed'
		Type = OT_Secondary,	-- Objective Type (OT_Primary, OT_Secondary)
		Parent = nil,
		subObjectives = {},
		
		--Intel
		Intel_Start = 				nil,	-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = 		nil,	-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			nil,	-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = 	nil,	-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				nil,	-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = 		nil,	-- Function to play if Intel_Fail is Skipped
		
		--Functions
		SetupUI = function() 
			
		end,
		
		PreStart = nil,
		
		OnStart = function()
			-- Save
		if Rule_Exists(E3_AutosaveDelay) == false then
			Rule_AddOneShot(E3_AutosaveDelay, g_AUTOSAVE_DELAY)
		end
		Modify_PlayerResourceRate(player1, RT_Action, 0.0) -- Command points are granted on obj completion
		-- Rule_Remove(ambientstukas)
		Rule_RemoveIfExist(Ambient_Stukas)
		end,
		
		IsComplete = function()
			return false
		end,
		
		PreComplete = nil,
		
		OnComplete = function()
			
		end, 
		
		IsFailed = nil,
		
		PreFail = nil,
		
		OnFail = function()
		
		end,
		
		
		-- IsComplete = function() -- Template for functions that do stuff
		--	return false
		-- end,			
	}
	
	Objective_Register(SOBJ_Park)

end

function INIT_HoldParkSOBJ()

	SOBJ_HoldPark = {
		-- Info			
		Title = "$312430cd68d346ad8badb0bc1ef14b77:1433",		-- LOCDB [1433] 'Hold the City Square' 
		TitleEnd = "$312430cd68d346ad8badb0bc1ef14b77:1391", 	-- LOCDB [1391] 'Square Secured'
		TitleFail = "$312430cd68d346ad8badb0bc1ef14b77:1370", 	-- LOCDB [1370] 'Attack Failed - Enemy Troops Held'  -- alt -- [1335] 'Attack Failed'
		Type = OT_Secondary,	-- Objective Type (OT_Primary, OT_Secondary)
		Parent = SOBJ_Park,
		subObjectives = {},
		
		--Intel
		Intel_Start = 				nil,	-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = 		nil,	-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			nil,	-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = 	nil,	-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				nil,	-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = 		nil,	-- Function to play if Intel_Fail is Skipped
		
		--Functions
		SetupUI = function() 
			
		end,
		
		PreStart = nil,
		
		OnStart = function()
		Player_AddResource(player1, RT_Manpower, g_player_grant_mp_1)
		end,
		
		IsComplete = function()
			return false
		end,
		
		PreComplete = nil,
		
		OnComplete = function()
			
		end, 
		
		IsFailed = nil,
		
		PreFail = nil,
		
		OnFail = function()
		
		end,
		
		
		-- IsComplete = function() -- Template for functions that do stuff
		--	return false
		-- end,			
	}
	
	Objective_Register(SOBJ_HoldPark)

end

function INIT_TrainstationSOBJ()

	SOBJ_Trainstation = {
		-- Info			
		Title = "$312430cd68d346ad8badb0bc1ef14b77:1441",		-- LOCDB [1441] 'Secure the Trainstation' 
		TitleEnd = "$312430cd68d346ad8badb0bc1ef14b77:1442", 	-- LOCDB [1442] 'Trainstation Secured'
		TitleFail = "$312430cd68d346ad8badb0bc1ef14b77:1370", 	-- LOCDB [1370] 'Attack Failed - Enemy Troops Held'  -- alt -- [1335] 'Attack Failed'
		Type = OT_Secondary,	-- Objective Type (OT_Primary, OT_Secondary)
		Parent = nil,
		subObjectives = {},
		
		--Intel
		Intel_Start = 				nil,	-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = 		nil,	-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			nil,	-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = 	nil,	-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				nil,	-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = 		nil,	-- Function to play if Intel_Fail is Skipped
		
		--Functions
		SetupUI = function() 
			hpid_train_main = Objective_AddUIElements(SOBJ_Trainstation, Util_GetPosition(mkr_hint_train_main), true, "$312430cd68d346ad8badb0bc1ef14b77:1441", true, nil, nil, HPAT_Objective)
		end,
		
		PreStart = nil,
		
		OnStart = function()
		Player_AddResource(player1, RT_Manpower, g_player_grant_mp_1)
		-- Save
		if Rule_Exists(E3_AutosaveDelay) == false then
			Rule_AddOneShot(E3_AutosaveDelay, g_AUTOSAVE_DELAY)
		end
		
		end,
		
		IsComplete = function()
			return false
		end,
		
		PreComplete = nil,
		
		OnComplete = function()
			
		end, 
		
		IsFailed = nil,
		
		PreFail = nil,
		
		OnFail = function()
		
		end,
		
		
		-- IsComplete = function() -- Template for functions that do stuff
		--	return false
		-- end,			
	}
	
	Objective_Register(SOBJ_Trainstation)

end

function INIT_TrainstationSOBJ_bonus()

	SOBJ_Trainstation_bonus = {
		-- Info			
		Title = "$312430cd68d346ad8badb0bc1ef14b77:1443",		-- LOCDB [1443] 'Obtain Heavy Weapons' 
		TitleEnd = "$312430cd68d346ad8badb0bc1ef14b77:1444", 	-- LOCDB [1444] 'Heavy Weapons Obtained'
		TitleFail = "$312430cd68d346ad8badb0bc1ef14b77:1445", 	-- LOCDB [1445] 'Heavy Weapons Scuttled'
		Type = OT_Secondary,	-- Objective Type (OT_Primary, OT_Secondary)
		Parent = SOBJ_Trainstation,
		subObjectives = {},
		
		--Intel
		Intel_Start = 				nil,	-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = 		nil,	-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			nil,	-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = 	nil,	-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				nil,	-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = 		nil,	-- Function to play if Intel_Fail is Skipped
		
		--Functions
		SetupUI = function() 
			Objective_StartTimer(SOBJ_Trainstation_bonus, COUNT_DOWN, g_truck_depart_time, 60)
			hpid_train_bonus = Objective_AddUIElements(SOBJ_Trainstation_bonus, Util_GetPosition(mkr_hint_train_bonus), true, "$312430cd68d346ad8badb0bc1ef14b77:1443", true)
		end,
		
		PreStart = nil,
		
		OnStart = function()
		
		end,
		
		IsComplete = function()
			return false
		end,
		
		PreComplete = nil,
		
		OnComplete = function()
			Player_AddResource(player1, RT_Manpower, g_player_grant_mp_1)
			Player_AddResource(player1, RT_Munition, g_player_grant_mu_1)
		end, 
		
		IsFailed = nil,
		
		PreFail = nil,
		
		OnFail = function()
		
		end,
		
		
		-- IsComplete = function() -- Template for functions that do stuff
		--	return false
		-- end,			
	}
	
	Objective_Register(SOBJ_Trainstation_bonus)

end

function INIT_TrainstationSOBJ_bonus_truck()

	SOBJ_Trainstation_bonus_truck = {
		-- Info			
		Title = "$312430cd68d346ad8badb0bc1ef14b77:1443",		-- LOCDB [1443] 'Destroy or Capture Halftrack' 
		TitleEnd = "$312430cd68d346ad8badb0bc1ef14b77:1444", 	-- LOCDB [1444] 'Heavy Weapons Obtained'
		TitleFail = "$312430cd68d346ad8badb0bc1ef14b77:1445", 	-- LOCDB [1445] 'Heavy Weapons Scuttled'
		Type = OT_Secondary,	-- Objective Type (OT_Primary, OT_Secondary)
		Parent = SOBJ_Trainstation,
		subObjectives = {},
		
		--Intel
		Intel_Start = 				nil,	-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = 		nil,	-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			nil,	-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = 	nil,	-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				nil,	-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = 		nil,	-- Function to play if Intel_Fail is Skipped
		
		--Functions
		SetupUI = function() 
			
		end,
		
		PreStart = nil,
		
		OnStart = function()
		
		end,
		
		IsComplete = function()
			return false
		end,
		
		PreComplete = nil,
		
		OnComplete = function()
			
		end, 
		
		IsFailed = nil,
		
		PreFail = nil,
		
		OnFail = function()
		
		end,
		
		
		-- IsComplete = function() -- Template for functions that do stuff
		--	return false
		-- end,			
	}
	
	Objective_Register(SOBJ_Trainstation_bonus_truck)

end
---------------------------
--******
-- Util Functions
--******
---------------------------
function _PreventWrecks()
	local wrecks = EGroup_CreateIfNotFound("wrecks")
	
	World_GetEntitiesNearMarker(player3, wrecks, trg_wrecks, OT_Neutral)
	EGroup_Filter(wrecks, t_wreckEBPs, FILTER_KEEP)
	EGroup_Kill(wrecks)
end

function _PutSquadsIntoGroup()
	Player_GetAll(player1, sg_player_all)
end

function _ModifySpeed(group, factor)
	Util_ApplyModifier(group, "speed_maximum_modifier", factor, MUT_Multiplication)
end

function _PanToPosition(pos)
	Camera_ResetToDefault()
	Camera_SetSlideTargetRate(0.55)
	Camera_MoveTo(pos, true, g_panSpeed*0.75)
	Camera_SetInputEnabled(false)
	
	Event_ElementOnScreen(_ReturnCameraControl, nil, player1, pos, ANY, 0.75)
end

function _ReturnCameraControl()
--~ 	print("Returning camera control...") --Debug
	Camera_SetInputEnabled(true)
end

function _DisableInteraction(sgroup)
	SGroup_EnableUIDecorator(sgroup, false)
	SGroup_EnableMinimapIndicator(sgroup, false)
	SGroup_SetSelectable(sgroup, false)
end

function _ResetCamera()
	Camera_SetSlideTargetRate(9999)
	Camera_ResetToDefault()
	Game_SetMode(UI_Normal)
--~ 	Game_FadeToBlack(FADE_IN, 0)
end

function _RemoveHintPoint(data)
	HintPoint_Remove(data.hpid)
end

function _StopFlashing(data)
	UI_StopFlashing(data.id)
end

function _SgroupSetAmbient(sgroup, invulnerable)
	--~	SGroup_AddAbility(sgroup, SP_SPRINT)
	--~	Cmd_Ability(sgroup, SP_SPRINT, nil, nil, true)		-- make squad move faster
	SGroup_EnableSurprise(sgroup, false)				-- turn off surprise so squads don't run backwards
	Modify_ReceivedSuppression(sgroup, 0.75)				-- squads don't get suppressed too easily
	Modify_Vulnerability(sgroup, 1.5) 					-- squad loses more members than player squads
	Modify_WeaponAccuracy(sgroup, "hardpoint_01", 0.75) -- squads dont do as much damage, but can still do something
	_DisableInteraction(sgroup) 						-- Disable all interaction
	
	if invulnerable == true then
		SGroup_SetInvulnerable(sgroup, true, -1)		-- set SGroup to invulnerable																																	
	else
	
	end
end

function Creeping_barrage_rockets_old(target)

	------------------------
	-- Starts a generic creeping barrage on the location, starting slightly behind
	-- the target, ending 40 meters from the original location
	------------------------
	-- MEDIUM ROCKETS
	creeping_barrage_active = true
	UI_CreateMinimapBlip(target, 5, BT_Combat)
	
	Cmd_Ability(player3, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_creeping_barrage_single"), Util_GetOffsetPosition(target, OFFSET_BACK, 8))

	
	-- Placeholder delay functions
	Util_Delay(1.5, function()
	Cmd_Ability(player3, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_creeping_barrage_single"), target)
	end)
	Util_Delay(3.0, function()
	Cmd_Ability(player3, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_creeping_barrage_single"), Util_GetOffsetPosition(target, OFFSET_FRONT, 8))
	end)
	Util_Delay(4.5, function()
	Cmd_Ability(player3, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_creeping_barrage_single"), Util_GetOffsetPosition(target, OFFSET_FRONT, 16))
	end)
	Util_Delay(6.0, function()
	Cmd_Ability(player3, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_creeping_barrage_single"), Util_GetOffsetPosition(target, OFFSET_FRONT, 24))
	end)
	Util_Delay(7.0, function()
	Cmd_Ability(player3, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_creeping_barrage_single"), Util_GetOffsetPosition(target, OFFSET_FRONT, 32))
	end)
	Util_Delay(8.0, function()
	Cmd_Ability(player3, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_creeping_barrage_single"), Util_GetOffsetPosition(target, OFFSET_FRONT, 40))
	end)
	Util_Delay(9.0, function()
	Cmd_Ability(player3, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_creeping_barrage_single"), Util_GetOffsetPosition(target, OFFSET_FRONT, 48))
	creeping_barrage_active = false
	end)
	
	-- Execute stinger/intel
	-- Util_StartIntel(EVENTS.BARRAGE_02_WARNING)
	print("Barrage away")
end

function Creeping_barrage_rockets(target)

	------------------------
	-- Starts a generic creeping barrage on the location, starting slightly behind
	-- the target, ending 50 meters from the original location
	------------------------
	-- Create blip
	UI_CreateMinimapBlip(target, 5, BT_Combat)
	-- Set values
	local creeping_barrage_active = true
	local ability = Cmd_Ability(player3, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_creeping_barrage_single"), target)
	-- Do the barrage
	
	Util_Delay(1.5, function()
	Cmd_Ability(player3, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_creeping_barrage_single"), target)
	end)
	Util_Delay(3.0, function()
	Cmd_Ability(player3, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_creeping_barrage_single"), Util_GetOffsetPosition(target, OFFSET_FRONT, 8))
	end)
	Util_Delay(4.5, function()
	Cmd_Ability(player3, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_creeping_barrage_single"), Util_GetOffsetPosition(target, OFFSET_FRONT, 16))
	end)
	Util_Delay(6.0, function()
	Cmd_Ability(player3, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_creeping_barrage_single"), Util_GetOffsetPosition(target, OFFSET_FRONT, 24))
	end)
	Util_Delay(7.0, function()
	Cmd_Ability(player3, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_creeping_barrage_single"), Util_GetOffsetPosition(target, OFFSET_FRONT, 32))
	end)
	Util_Delay(8.0, function()
	Cmd_Ability(player3, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_creeping_barrage_single"), Util_GetOffsetPosition(target, OFFSET_FRONT, 40))
	end)
	Util_Delay(9.0, function()
	Cmd_Ability(player3, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_creeping_barrage_single"), Util_GetOffsetPosition(target, OFFSET_FRONT, 48))
	local creeping_barrage_active = false
	end)
	
	print("Barrage away")
end

function E3_AutosaveDelay()
	if Rule_Exists(E3_Autosave) == false then
		Rule_Add(E3_Autosave)
	end
end

function E3_Autosave()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		Util_Autosave("$312430cd68d346ad8badb0bc1ef14b77:1334", 1, false)
	end
end

---------------------------
-- Following util code is all written up by Janne252
---------------------------

function Util_Delay(delay, task)
    local ruleName = "DelayedTask_" .. tostring(task) .. World_GetGameTime()
    _G[ruleName] = task
    Rule_AddOneShot(_G[ruleName], delay)
    return ruleName
end

function Util_DelayRandom(minDelay, maxDelay, task)
	Util_Delay(World_GetRand(minDelay, maxDelay), task)
end

function Squad_IsIdle(squad)
	return Squad_HasActiveCommand(squad) and Squad_GetActiveCommand(squad) == SQUADSTATEID_Idle
end

function UI_FlashSquad(squad)
	Squad_ForEachEntity(squad, function(squad, idx, entity)
		UI_FlashEntity(entity)
	end)
end

function Rule_AddOneShot_Exists( f, delay, priority)
    if not Rule_Exists( f) then
        Rule_AddOneShot( f, delay, priority)
    end
end

---------------------------
-- End of Janne's section
---------------------------

---------------------------
--******
-- Hint Initialization
--******
---------------------------

--******
-- Barricade Hints
--******
	
--******
-- City Center Hints
--******



