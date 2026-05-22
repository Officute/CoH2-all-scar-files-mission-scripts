-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- Act 1 - Mission 1
-- Stalingrad Rail Station
-- Designer: Ryan McGechaen

-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScarUtil.scar")
import("Systems/AiManager/ai.scar")
import("Prototype/DeploymentPoints.scar")
import("Stalingrad_Rail_Station_Allies.scar")
import("Beginner.scar")
import("Global_Values/CampaignGlobalConstants.scar")

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------

function OnGameSetup()
	player1 = Setup_Player(1, 11040465, "soviet", 1)		-- LOCDB [11040465] '13th Guards Rifle Division'
	player2 = Setup_Player(2, 11040466, "german", 2)		-- LOCDB [11040466] '71st Infantry Division'
	player3 = Setup_Player(3, 11040465, "soviet", 1)		-- player3 is always the AI ally
	player4 = Setup_Player(4, 11049983, "soviet", 1)			-- LOCDB [11049983] 'Civilians'
end

function OnGameRestore()
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	player4 = World_GetPlayerAt(4)
	Game_DefaultGameRestore()
	Util_RestoreMusic()
	if atRailstationObjective == true then
		Camera_ClampToMarker(mkr_rail_playZone)
		Misc_RestrictCommandsToMarker(mkr_rail_playZone)
	end		 
	
end

-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------

function OnInit()
	--[[ SET DIFFICULTY ]]
	Mission_Difficulty()
	--[[ SET RESTRICTIONS ]]
	Mission_Restrictions()
	--[[ SET MODIFIERS ]]
	Mission_Modifiers()
	--[[ SET ABILITIES ]]
	Mission_Abilities()
	--[[ MISSION PRESETS ]]
	Mission_MissionPreset()
	--[[ REGISTER OBJECTIVES ]]
	-- Stalingrad
	INIT_AssaultStalingrad()
	DOCKS_Init_Objective()
	HMG_Init_Objective()
	HOWITZERS_Init_Objective()
	-- Panzer
	INIT_Panzer()
	ATGUN_Init_Objective()
	-- Railstation
	INIT_Railstation()
	SOUTHLINE_Init_Objective()
	NORTHLINE_Init_Objective()
	BONUS_Init_Objective()
	--[[ START INITIAL OBJECTIVE ]]
	Game_SetMode(UI_Cinematic)
	--[[ MISSION START ]]
	Util_StartNislet(EVENTS.NIS01, _skipIntro, false, 1)
end

Scar_AddInit(OnInit)

function Mission_Restrictions()	
	Player_SetCommandAvailability(player1, SCMD_Retreat, ITEM_LOCKED)
	Player_SetCommandAvailability(player1, SCMD_ReinforceUnit, ITEM_REMOVED)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.RGD_1_SMOKE_GRENADE, ITEM_REMOVED)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.RG_42_ANTI_PERSONNEL_GRENADE, ITEM_REMOVED)
	Player_SetUpgradeAvailability(player1, BP_GetUpgradeBlueprint("ppsh-41_sub_machine_gun_upgrade"), ITEM_REMOVED)
	
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("upgrade/campaign/disable_abandon_critical")) 
end

function Mission_Modifiers()
	Modify_PlayerResourceRate(player1, RT_Manpower, 0)
	Modify_PlayerResourceRate(player1, RT_Munition, 4)
	Modify_PlayerResourceRate(player1, RT_Fuel, 0)
	Modify_AbilityRechargeTime(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH, 0.7)
end

function Mission_Abilities()
	-- Add Abilities	
	Player_AddAbility(player2, BP_GetAbilityBlueprint("campaign_stuka_strafe_long"))
	Player_AddAbility(player2, ABILITY.GLOBAL.OFF_MAP_ARTILLERY_PERCISE) 
	Player_AddAbility(player2, BP_GetAbilityBlueprint("m01_stuka_dogfight_pass"))
	Player_AddAbility(player2, BP_GetAbilityBlueprint("m01_mortar_single_precise_harmless"))
	Player_AddAbility(player2, BP_GetAbilityBlueprint("m01_stuka_bombing_strike"))
	Player_AddAbility(player2, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT)
	Player_AddAbility(player3, BP_GetAbilityBlueprint("m01_il2_precision_bomb_strike"))
	Player_AddAbility(player3, BP_GetAbilityBlueprint("m01_il2_dogfight_pass"))
	-- Add Upgrades
	Cmd_Upgrade(player1, BP_GetUpgradeBlueprint("shock_prevent_pin"), 1, true)
	Cmd_Upgrade(player1, BP_GetUpgradeBlueprint("mission01_upgrade"), 1, true)
	Cmd_Upgrade(player1, UPG.SOVIET.BASE_CONSCRIPT_MOLOTOV_UNLOCK, 1, true)
	Cmd_Upgrade(player2, BP_GetUpgradeBlueprint("disable_vehicle_criticals"), 1, true)
	Cmd_Upgrade(player3, BP_GetUpgradeBlueprint("mission01_upgrade"), 1, true)
end

function Mission_Difficulty()
	t_difficulty = {
		-- Popcap
		popcap_01					= Util_DifVar( {9*4, 9*4, 9*3, 9*3} ),	-- Popcap for the first part of the mission (up to Railstation)
		popcap_02					= Util_DifVar( {9*8, 9*7, 9*6, 9*4} ),	-- Popcap for the railstation
		-- Player Squad toughness
		receievedDamage				= Util_DifVar( {0.8, 0.9, 1.1, 1.1} ),	-- Receieved Damage for Player Squads
		-- Bonus Objective
		bonus_initial_delay			= Util_DifVar( {30, 20, 10, 10} ),	-- Initial delay before conscripts start dieing
		death_rate					= Util_DifVar( {25, 20, 15, 15} ),	-- How fast the defending soldiers die
	} 
end

-------------------------------------------------------------------------
-- MISSION Preset 
-------------------------------------------------------------------------
function Mission_MissionPreset()
	-- Squad_AddAbility(SGroup_GetSpawnedSquadAt(sg_p_shock_01, 1), BP_GetAbilityBlueprint("shock_troop_full_auto"))
--~ 	Sound_SetMusicCombatValue(3, 60*9999999)
	
	-- Boats
	EGroup_Hide(eg_hidden_dock, true)
	EGroup_Hide(eg_player_boat_floor, true)
	EGroup_SetInvulnerable(eg_hidden_dock, true)
	
	-- Disable enemy Spotted event cues
	UI_EnableUIEventCueType(UIE_EnemyReveal, false)
	
	UI_TerritoryHide()
	
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	sg_blah = SGroup_CreateIfNotFound("sg_blah")
	eg_temp = EGroup_CreateIfNotFound("eg_temp")
	eg_blah = EGroup_CreateIfNotFound("eg_blah")
	
	-- Setup Camera
	Camera_SetDefault(38, 45, 290)
	Camera_ResetToDefault()
	Camera_SetZoomDist(38)
	
	-- Set Egroups invulnerable
	EGroup_SetInvulnerable(eg_invuln, true)
	EGroup_SetInvulnerable(eg_hmg_wire, true)
	EGroup_SetInvulnerable(LAYER_INVULN_Wall, true)
	EGroup_SetInvulnerable(LAYER_wall_vault, true)
	EGroup_SetInvulnerable(eg_bonus_building, true)
	
	-- Despawn Ramp blocker
	EGroup_DeSpawn(eg_player_ramp_blocker)
	
	-- Despawn docks items
	EGroup_DeSpawn(eg_docks_debris_01)
	EGroup_DeSpawn(eg_docks_debris_02)
	EGroup_DeSpawn(eg_docks_player_boat_debris)
	Event_GroupIsDead(_ambient_respawnDebris, nil, eg_docks_pier_destroy_02)
	
	-- Spawn Player Units
	sg_p_all = SGroup_CreateIfNotFound("sg_p_all")
	sg_p_shock_01 = SGroup_CreateIfNotFound("sg_p_shock_01")
	sg_p_shock_02 = SGroup_CreateIfNotFound("sg_p_shock_02")
	
	Util_CreateSquads(player1, {sg_p_all, sg_p_shock_01}, SBP.SOVIET.SHOCK_TROOPS, mkr_p_shockSpawn_01)
	Util_CreateSquads(player1, {sg_p_all, sg_p_shock_02}, SBP.SOVIET.SHOCK_TROOPS, mkr_p_shockSpawn_02)
	
	Squad_SetReactionPlan(SGroup_GetSpawnedSquadAt("sg_p_shock_01", 1), "empty_plan")
	Squad_SetReactionPlan(SGroup_GetSpawnedSquadAt("sg_p_shock_02", 1), "empty_plan")
	
	Modify_Vulnerability(sg_p_shock_01, t_difficulty.receievedDamage)
	Modify_Vulnerability(sg_p_shock_02, t_difficulty.receievedDamage)
	
	Rule_AddPlayerEvent(Mission_ModShock, player1, GE_AbilityExecuted)
	
	-- Spawn Speech Commissar
	sg_a_docks_commissar_speech = SGroup_CreateIfNotFound("sg_a_docks_commissar_speech")
	Util_CreateSquads(player3, sg_a_docks_commissar_speech, SBP.SOVIET.SOVIET_OFFICER_SQUAD, mkr_docks_commissar, nil, 1, 1)
	SGroup_SetInvulnerable(sg_a_docks_commissar_speech, true)
	SGroup_SetSelectable(sg_a_docks_commissar_speech, false)
	SGroup_EnableUIDecorator(sg_a_docks_commissar_speech, false)
	SGroup_EnableMinimapIndicator(sg_a_docks_commissar_speech, false)
	SGroup_SetAnimatorState(sg_a_docks_commissar_speech, "m01_commissarspeech", "speech")
	
	-- Spawn Docks Commissars
	sg_a_docks_commissar = SGroup_CreateIfNotFound("sg_a_docks_commissar")
	local commissarTable = Marker_GetTable("mkr_docks_commissar_%02d")
	for i = 1, table.getn(commissarTable) do
		local tempSG = SGroup_Create("")
		Util_CreateSquads(player3, {sg_a_docks_commissar, tempSG}, SBP.SOVIET.SOVIET_OFFICER_SQUAD, commissarTable[i], nil, 1, 1)
		if i == 3 or i == 5 then
			SGroup_SetAnimatorState(tempSG, "m01_commissarspeech", "speech")
		end
		SGroup_Clear(tempSG)
		SGroup_Destroy(tempSG)
	end
	SGroup_SetInvulnerable(sg_a_docks_commissar, true)
	SGroup_SetSelectable(sg_a_docks_commissar, false)
	SGroup_EnableUIDecorator(sg_a_docks_commissar, false)
	SGroup_EnableMinimapIndicator(sg_a_docks_commissar, false)
	
	-- Medics
	Medics_Init()
	
	-- Spawn ambient conscripts
	sg_a_docks_con = SGroup_CreateIfNotFound("sg_a_docks_con")
	
	local conTable = Marker_GetTable("mkr_docks_allies_amb_con_%02d")
	for i = 1, table.getn(conTable) do
		Util_CreateSquads(player3, sg_a_docks_con, BP_GetSquadBlueprint("m01_conscript_squad_docks"), conTable[i], nil, 1, World_GetRand(1, 2))
	end
	SGroup_SetInvulnerable(sg_a_docks_con, true)
	SGroup_SetSelectable(sg_a_docks_con, false)
	SGroup_EnableUIDecorator(sg_a_docks_con, false)
	SGroup_EnableMinimapIndicator(sg_a_docks_con, false)
	
	-- Mood
	Player_SetDefaultSquadMoodMode(player1, MM_ForceTense)
	Player_SetDefaultSquadMoodMode(player2, MM_ForceTense)
	Player_SetDefaultSquadMoodMode(player3, MM_ForceTense)
	
	Player_SetPopCapOverride(player1, t_difficulty.popcap_01)
	
	-- Disable Experience
	Modify_PlayerExperienceReceived(player2, 0)
	Modify_PlayerExperienceReceived(player3, 0)
	
	Player_SetResource(player1, RT_SovietProgression, 50)
	
	Modify_PlayerResourceCap(player1, RT_Munition, 201, MUT_Addition)
	Modify_PlayerResourceCap(player1, RT_SovietProgression, -51, MUT_Addition)
	
	Rule_AddPlayerEvent(_checkForShockTroop, player1, GE_AbilityExecuted)
	
	-- Achievement Flag
	_calledInShockTroops = false
	
	-- Init Docks
	Docks_Init()
	
	-- Ambient Artillery
	tmr_amb_Artillery = "tmr_amb_Artillery"
	_amb_arty_onScreen = false
	g_arty_timer = 0
	t_ambArty = {}
	g_arty_freq_min = 1
	g_arty_freq_max = 2
	Rule_AddInterval(_ambient_artillery, 1)
	
	-- Ambient Stukas
	_stuka_Area = mkr_docks_stuka_area
	tmr_amb_Stukas = "tmr_amb_Stukas"
	g_stuka_freq_min = 8
	g_stuka_freq_max = 10
	Rule_AddInterval(_ambient_stukas, 1)
	
	-- Drop Rates
	Modify_SlotItemDropRate(player1, "grenadier_mg42lmg", 10)
	Modify_SlotItemDropRate(player2, "grenadier_mg42lmg", 10)
	
	Modify_SlotItemDropRate(player2, "pioneer_flamethrower", 0)
	
	-- Spawn the Blockers
	sg_a_blocker_hmg_left = SGroup_CreateIfNotFound("sg_a_blocker_hmg_left")
	sg_a_blocker_com_left = SGroup_CreateIfNotFound("sg_a_blocker_com_left")
	sg_a_blocker_guard_left = SGroup_CreateIfNotFound("sg_a_blocker_guard_left")
	Util_CreateSquads(player3, sg_a_blocker_hmg_left, SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD, mkr_blocker_hmg_left, nil, 1, 2)
	Util_CreateSquads(player3, sg_a_blocker_com_left, SBP.SOVIET.SOVIET_OFFICER_SQUAD, mkr_blocker_commissar_left)
	Util_CreateSquads(player3, sg_a_blocker_guard_left, SBP.SOVIET.GUARDS_TROOPS, mkr_blocker_guards_left, nil, 1, 4)
	SGroup_SetInvulnerable(sg_a_blocker_hmg_left, true)
	SGroup_SetInvulnerable(sg_a_blocker_com_left, true)
	SGroup_SetInvulnerable(sg_a_blocker_guard_left, true)
	SGroup_SetAutoTargetting(sg_a_blocker_hmg_left, "hardpoint_01", false)
	SGroup_SetAutoTargetting(sg_a_blocker_com_left, "hardpoint_01", false)
	SGroup_SetAutoTargetting(sg_a_blocker_guard_left, "hardpoint_01", false)
	Modify_WeaponRange(sg_a_blocker_hmg_left, "hardpoint_01", 0.5)
	SGroup_EnableMinimapIndicator(sg_a_blocker_hmg_left, false)
	SGroup_EnableMinimapIndicator(sg_a_blocker_com_left, false)
	SGroup_EnableMinimapIndicator(sg_a_blocker_guard_left, false)
	
	sg_a_blocker_hmg_center = SGroup_CreateIfNotFound("sg_a_blocker_hmg_center")
	sg_a_blocker_com_center = SGroup_CreateIfNotFound("sg_a_blocker_com_center")
	sg_a_blocker_guard_center = SGroup_CreateIfNotFound("sg_a_blocker_guard_center")
	Util_CreateSquads(player3, sg_a_blocker_hmg_center, SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD, mkr_blocker_hmg_center, nil, 1, 2)
	Util_CreateSquads(player3, sg_a_blocker_com_center, SBP.SOVIET.SOVIET_OFFICER_SQUAD, mkr_blocker_commissar_center)
	Util_CreateSquads(player3, sg_a_blocker_guard_center, SBP.SOVIET.GUARDS_TROOPS, mkr_blocker_guards_center, nil, 1, 4)
	SGroup_SetInvulnerable(sg_a_blocker_hmg_center, true)
	SGroup_SetInvulnerable(sg_a_blocker_com_center, true)
	SGroup_SetInvulnerable(sg_a_blocker_guard_center, true)
	SGroup_SetAutoTargetting(sg_a_blocker_hmg_center, "hardpoint_01", false)
	SGroup_SetAutoTargetting(sg_a_blocker_com_center, "hardpoint_01", false)
	SGroup_SetAutoTargetting(sg_a_blocker_guard_center, "hardpoint_01", false)
	Modify_WeaponRange(sg_a_blocker_hmg_center, "hardpoint_01", 0.5)
	SGroup_EnableMinimapIndicator(sg_a_blocker_hmg_center, false)
	SGroup_EnableMinimapIndicator(sg_a_blocker_com_center, false)
	SGroup_EnableMinimapIndicator(sg_a_blocker_guard_center, false)
	
	sg_a_blocker_hmg_right = SGroup_CreateIfNotFound("sg_a_blocker_hmg_right")
	sg_a_blocker_com_right = SGroup_CreateIfNotFound("sg_a_blocker_com_right")
	sg_a_blocker_guard_right = SGroup_CreateIfNotFound("sg_a_blocker_guard_right")
	Util_CreateSquads(player3, sg_a_blocker_hmg_right, SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD, mkr_blocker_hmg_right, nil, 1, 2)
	Util_CreateSquads(player3, sg_a_blocker_com_right, SBP.SOVIET.SOVIET_OFFICER_SQUAD, mkr_blocker_commissar_right)
	Util_CreateSquads(player3, sg_a_blocker_guard_right, SBP.SOVIET.GUARDS_TROOPS, mkr_blocker_guards_right, nil, 1, 4)
	SGroup_SetInvulnerable(sg_a_blocker_hmg_right, true)
	SGroup_SetInvulnerable(sg_a_blocker_com_right, true)
	SGroup_SetInvulnerable(sg_a_blocker_guard_right, true)
	SGroup_SetAutoTargetting(sg_a_blocker_hmg_right, "hardpoint_01", false)
	SGroup_SetAutoTargetting(sg_a_blocker_com_right, "hardpoint_01", false)
	SGroup_SetAutoTargetting(sg_a_blocker_guard_right, "hardpoint_01", false)
	Modify_WeaponRange(sg_a_blocker_hmg_right, "hardpoint_01", 0.5)
	SGroup_EnableMinimapIndicator(sg_a_blocker_hmg_right, false)
	SGroup_EnableMinimapIndicator(sg_a_blocker_com_right, false)
	SGroup_EnableMinimapIndicator(sg_a_blocker_guard_right, false)
	
	Rule_Add(Mission_SetAction)
	
	Rule_AddOneShot(Mission_HideCP, 1)
	
end

--------------------------
-- Ambient Events
--------------------------
function _ambient_bomb_player_boat() 
	Cmd_Ability(player2, BP_GetAbilityBlueprint("m01_stuka_bombing_strike"), mkr_player_boat_bomb, nil, true) 
	if Rule_Exists(_ambient_destroy_player_boat) == false then Rule_Add(_ambient_destroy_player_boat) end
end
function _ambient_destroy_player_boat()
	if EGroup_IsEmpty(eg_player_boat) then
		Rule_RemoveMe()
		EGroup_DestroyAllEntities(eg_player_boat_floor)
		EGroup_DestroyAllEntities(eg_player_ramp)
		EGroup_Kill(eg_player_ramp)
		EGroup_ReSpawn(eg_player_ramp_blocker)
		EGroup_ReSpawn(eg_docks_player_boat_debris)
		if Prox_AreSquadsNearMarker(sg_p_shock_01, mkr_p_shockDest_01, ALL, 3) == false then SGroup_WarpToMarker(sg_p_shock_01, mkr_p_shockDest_01, ALL, 3) end
		if Prox_AreSquadsNearMarker(sg_p_shock_02, mkr_p_shockDest_02, ALL, 3) == false then SGroup_WarpToMarker(sg_p_shock_02, mkr_p_shockDest_02, ALL, 4) end
	elseif EGroup_GetAvgHealth(eg_player_boat) < 1 then
		Rule_RemoveMe()
		EGroup_Kill(eg_player_boat)
		EGroup_DestroyAllEntities(eg_player_boat_floor)
		EGroup_Kill(eg_player_ramp)
		EGroup_ReSpawn(eg_player_ramp_blocker)
		EGroup_ReSpawn(eg_docks_player_boat_debris)
		if Prox_AreSquadsNearMarker(sg_p_shock_01, mkr_p_shockDest_01, ALL, 3) == false then SGroup_WarpToMarker(sg_p_shock_01, mkr_p_shockDest_01, ALL, 3) end
		if Prox_AreSquadsNearMarker(sg_p_shock_02, mkr_p_shockDest_02, ALL, 3) == false then SGroup_WarpToMarker(sg_p_shock_02, mkr_p_shockDest_02, ALL, 3) end
	end

end

function _ambient_respawnDebris() 
	EGroup_ReSpawn(eg_docks_debris_02) 
end
function _ambient_artillery()
	local target = nil
	if _amb_arty_onScreen == false then
		target = Table_GetRandomItem(_tAmbArtillery)
	else
		local targetsOnScreen = {}
		for i = 1, table.getn(_tAmbArtillery) do
			if Misc_IsPosOnScreen(Util_GetPosition(_tAmbArtillery[i]), 1) then
				table.insert(targetsOnScreen, _tAmbArtillery[i])
			end
		end
		
		if table.getn(targetsOnScreen) == 0 then return end
		
		target = Table_GetRandomItem(targetsOnScreen)
	end
	Cmd_Ability(player2, BP_GetAbilityBlueprint("m01_mortar_single_precise_harmless"), Util_GetPosition(target), nil, true)
	Rule_ChangeInterval(_ambient_artillery, World_GetRand(g_arty_freq_min, g_arty_freq_max))
end
function _ambient_artillery_reset()
	g_arty_freq_min = 5
	g_arty_freq_max = 9
	
	g_stuka_freq_min = 22
	g_stuka_freq_max = 26
end
function _ambient_stukas()

	if Timer_Exists(tmr_amb_Stukas) then
		if Timer_GetRemaining(tmr_amb_Stukas) == 0 then
			Timer_End(tmr_amb_Stukas)
			
			local num = World_GetRand(1, 2)
			local compass = Marker_GetTable("mkr_compass_%02d")
			
			for i = 1, num do
				local dir = Table_GetRandomItem(compass)
				Command_PlayerPosDirAbility(player2, player2, Util_GetRandomPosition(_stuka_Area), Marker_GetDirection(dir), BP_GetAbilityBlueprint("m01_stuka_dogfight_pass"), true)
			end
		end
	else
		Timer_Start(tmr_amb_Stukas, World_GetRand(g_stuka_freq_min, g_stuka_freq_max))
	end	

end
-- IL2 crashes into crane
function _ambient_il2_crash()
	sg_docks_il2_crash = SGroup_CreateIfNotFound("sg_docks_il2_crash")
	
	Command_PlayerPosDirAbility(player3, player3, Util_GetPosition(mkr_docks_il2_crash_tar), Marker_GetDirection(mkr_docks_il2_crash_tar), BP_GetAbilityBlueprint("m01_il2_dogfight_pass"), true)
	
	Cmd_Ability(player2, BP_GetAbilityBlueprint("m01_stuka_bombing_strike"), mkr_docks_stuka_01, nil, true)
	
	-- Invuln player troops
	Squad_SetInvulnerableMinCap(SGroup_GetSpawnedSquadAt(sg_p_shock_01, 1), 0.85, 30)
	Squad_SetInvulnerableMinCap(SGroup_GetSpawnedSquadAt(sg_p_shock_02, 1), 0.85, 30)
	
	Rule_Add(_ambient_il2_crash_collect)
	Rule_AddOneShot(_ambient_il2_crash_chasePlane, 0.85)
end

function _ambient_il2_crash_collect()
	
	if SGroup_IsEmpty(sg_docks_il2_crash) then
		Player_GetAllSquadsNearMarker(player3, sg_docks_il2_crash, mkr_docks_il2_crash_spawn)
	else
		Rule_RemoveMe()
		
		Rule_AddOneShot(_ambient_il2_crash_kill, 0.88)	--1.75
	end

end

function _ambient_il2_crash_chasePlane() Command_PlayerPosDirAbility(player2, player2, Util_GetPosition(mkr_docks_il2_crash_tar), Marker_GetDirection(mkr_docks_il2_crash_tar), BP_GetAbilityBlueprint("m01_stuka_dogfight_pass"), true) end
function _ambient_il2_crash_kill() SGroup_Kill(sg_docks_il2_crash) end
function _ambient_dock_bombed() 
	Cmd_Ability(player2, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT, mkr_docks_artillery, nil, true) 
	Event_OnHealth(_ambient_dock_destroy, nil, eg_docks_pier_destroy_01, 0.99, false)
end

function _ambient_dock_destroy() EGroup_Kill(eg_docks_pier_destroy_01) EGroup_ReSpawn(eg_docks_debris_01) end
--------------------------
-- Skip Intro
--------------------------
function _skipIntro()
	if SGroup_IsEmpty(sg_INTRO_squads_01_A) == false then SGroup_DestroyAllSquads(sg_INTRO_squads_01_A) end
	if SGroup_IsEmpty(sg_INTRO_squads_01_B) == false then SGroup_DestroyAllSquads(sg_INTRO_squads_01_B) end
	if SGroup_IsEmpty(sg_INTRO_squads_02_A) == false then SGroup_DestroyAllSquads(sg_INTRO_squads_02_A) end
	if SGroup_IsEmpty(sg_INTRO_squads_02_B) == false then SGroup_DestroyAllSquads(sg_INTRO_squads_02_B) end
	if SGroup_IsEmpty(sg_INTRO_squads_03) == false then SGroup_DestroyAllSquads(sg_INTRO_squads_03) end
	
	Camera_ResetToDefault()
	
	SGroup_WarpToMarker(sg_p_shock_01, mkr_p_shockDest_01)
	SGroup_WarpToMarker(sg_p_shock_02, mkr_p_shockDest_02)
	SGroup_WarpToMarker(sg_a_t34, mkr_docks_t34)
	Cmd_Move(sg_a_t34, mkr_docks_t34, false, nil, Util_GetOffsetPosition(mkr_docks_t34, OFFSET_FRONT, 5))
	
	EGroup_Kill(eg_player_boat)
	EGroup_DestroyAllEntities(eg_player_boat_floor)
	EGroup_DestroyAllEntities(eg_player_ramp)
end

---------------------------
-- Additional Startup Functions
---------------------------
function Mission_HideCP() UI_SetCPMeterVisibility(false) end

function _checkForShockTroop(caster, ability, target)
	if ability == ABILITY.SOVIET.SHOCK_TROOP_DISPATCH_SP then
		Rule_RemoveMe()
		_calledInShockTroops = true
	end
end

function Mission_MoveUp_Shock()
	SGroup_SetInvulnerable(sg_p_shock_01, true, 15)
	SGroup_SetInvulnerable(sg_p_shock_02, true, 15)
	Cmd_Move(sg_p_shock_01, mkr_p_shockDest_01)
	Rule_AddOneShot(Mission_MoveUp_Shock_02, 2)
	
	Rule_AddOneShot(Docks_Speech_01, 7)
end
function Mission_MoveUp_Shock_02() Cmd_Move(sg_p_shock_02, mkr_p_shockDest_02) end
function Mission_SetAction() Player_SetResource(player1, RT_Action, 0) end
function Mission_GrantMunitions()
	if Player_GetResource(player1, RT_Munition) <= 30 then
		Player_SetResource(player1, RT_Munition, 30)
	end
end

function Mission_ModShock(player, ability, target)
	if ability == ABILITY.SOVIET.SHOCK_TROOP_DISPATCH_SP then
		sg_allPlayerSquads = SGroup_CreateIfNotFound("sg_allPlayerSquads")
		SGroup_Clear(sg_allPlayerSquads)
		
		Player_GetAll(player1, sg_allPlayerSquads)
		SGroup_RemoveGroup(sg_allPlayerSquads, sg_p_all)
		
		local _modTough = function(gid, idx, sid)
			Modify_Vulnerability(gid, t_difficulty.receievedDamage)
			SGroup_Add(sg_p_all, sid)
		end
		
		SGroup_ForEach(sg_allPlayerSquads, _modTough)
	end
end
------------------------------
-- SitRep
------------------------------
function Mission_SitRep()
	
	Game_EnableInput(false)
	Camera_SetInputEnabled(false)
--~ 	Camera_ResetToDefault()
	
	Util_PlayMovie("m01_sitrep", 2.5, false, HMG_Init, nil, true)

end

-------------------------------------------------------------------------
-- DOCKS
-------------------------------------------------------------------------
--******
-- DOCKS Objective
--******
function INIT_AssaultStalingrad()

	OBJ_AssaultStalingrad = {
		
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			
		end,
		
		OnComplete = function()
			
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,
		Intel_Complete = nil,
		Intel_Fail = nil,				
		Title = 11036460,				-- LOCDB [11036460] 'Reclaim Stalingrad'
		Type = OT_Primary,				
	}
	
	Objective_Register(OBJ_AssaultStalingrad)

end



function DOCKS_Init_Objective()

	SOBJ_Docks = {
		
		SetupUI = function() 
			hpid_docks_Cen = Objective_AddUIElements(SOBJ_Docks, sg_a_t34, true, 11047647, true, 2)		-- LOCDB [11036462] 'Clear the German Line'
		end,
		
		OnStart = function()
			-- Update Allies
			_allies_center_min = 2
			_allies_center_max = 3
			_central_Allies_Max = 15
			
			Squad_SetReactionPlan(SGroup_GetSpawnedSquadAt("sg_p_shock_01", 1), "reaction-troop_plan")
			Squad_SetReactionPlan(SGroup_GetSpawnedSquadAt("sg_p_shock_02", 1), "reaction-troop_plan")
		end,
		
		OnComplete = function()	
			
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				
		Intel_Complete = nil,			
		Intel_Fail = nil,				
		Title = 11047647,								-- LOCDB [11047647] 'Support the T-34 Tank'
		Type = OT_Primary,				
		Parent = OBJ_AssaultStalingrad,
	}
	
	Objective_Register(SOBJ_Docks)

end
function Docks_Start() Objective_Start(SOBJ_Docks) end
function Docks_Complete_Check()
	
	if SGroup_TotalMembersCount(sg_e_docks_central) <= (_germansAlive-10)
	  or Timer_GetRemaining(tmr_docksComplete) == 0 then
		for i = 1, table.getn(_tLeft_events) do
			Event_Remove(_tLeft_events[i])
		end
		
		for i = 1, table.getn(_tRight_events) do
			Event_Remove(_tRight_events[i])
		end
		
		Cmd_StaggeredRetreat(sg_e_docks_left, {mkr_docks_e_retreat_01, mkr_docks_e_retreat_02, mkr_docks_e_retreat_03}, 5)
		Cmd_StaggeredRetreat(sg_e_docks_central, {mkr_docks_e_retreat_01, mkr_docks_e_retreat_02, mkr_docks_e_retreat_03}, 5)
		Cmd_StaggeredRetreat(sg_e_docks_right, {mkr_docks_e_retreat_01, mkr_docks_e_retreat_02, mkr_docks_e_retreat_03}, 5)
		
		if SGroup_IsEmpty(sg_e_docks_central) == false then
			local squad = SGroup_GetRandomSpawnedSquad(sg_e_docks_central)
			
			Squad_SetInvulnerable(squad, true, -1)
			
			Sound_Play3D("speech/sp/mission/m01/ambient/grenadier_retreat", Squad_EntityAt(squad, 0))
		end
		
		if SGroup_IsEmpty(sg_e_docks_left) == false then
			local squad = SGroup_GetRandomSpawnedSquad(sg_e_docks_left)
			
			Squad_SetInvulnerable(squad, true, -1)
			
			Sound_Play3D("speech/sp/mission/m01/ambient/grenadier_retreat", Squad_EntityAt(squad, 0))
		end
		
		if SGroup_IsEmpty(sg_e_docks_right) == false then
			local squad = SGroup_GetRandomSpawnedSquad(sg_e_docks_right)
			
			Squad_SetInvulnerable(squad, true, -1)
			
			Sound_Play3D("speech/sp/mission/m01/ambient/grenadier_retreat", Squad_EntityAt(squad, 0))
		end
		
		SGroup_SetInvulnerable(sg_p_shock_01, false)
		SGroup_SetInvulnerable(sg_p_shock_02, false)
		Rule_RemoveMe()
		
		-- Pulled from Objective OnComplete
		-- Move up blockers
			Cmd_Move(sg_a_blocker_hmg_right, mkr_blocker_hmg_right_dest01, false, nil, Util_GetOffsetPosition(mkr_blocker_hmg_right_dest01, OFFSET_FRONT, 10))
			Cmd_Move(sg_a_blocker_com_right, mkr_blocker_commissar_right_dest01)
			Cmd_Move(sg_a_blocker_guard_right, mkr_blocker_guards_right_dest01)
			
			Cmd_Move(sg_a_blocker_hmg_center, mkr_blocker_hmg_center_dest01, false, nil, Util_GetOffsetPosition(mkr_blocker_hmg_center_dest01, OFFSET_FRONT, 10))
			Cmd_Move(sg_a_blocker_com_center, mkr_blocker_commissar_center_dest01)
			Cmd_Move(sg_a_blocker_guard_center, mkr_blocker_guards_center_dest01)
			
			Cmd_Move(sg_a_blocker_hmg_left, mkr_blocker_hmg_left_dest01, false, nil, Util_GetOffsetPosition(mkr_blocker_hmg_left_dest01, OFFSET_FRONT, 10))
			Cmd_Move(sg_a_blocker_com_left, mkr_blocker_commissar_left_dest01)
			Cmd_Move(sg_a_blocker_guard_left, mkr_blocker_guards_left_dest01)
			
			if Rule_Exists(_selection_check) then Rule_Remove(_selection_check) end
			
			Rule_Remove(_docks_Commissar_Speech)
			
			EGroup_InstantCaptureStrategicPoint(eg_docks_cp, player1)
			World_IncreaseInteractionStage()
			
			Event_Remove(_eventID_SpawnShock_01)
			Event_Remove(_eventID_SpawnShock_02)
			
--~ 			Sound_SetMusicCombatValue(0, 0)
			
			_docks_bomb_stug_01()
			_docks_bomb_stug_02()
			
			_central_Allies_pin = true
			_central_Allies_vuln = false
			
			HMG_Allies_Init()
			
		Rule_AddOneShot(Docks_LineBreaking, 2)
	end

end

function Docks_LineBreaking()
	Util_StartIntel(EVENTS.DOCKS_COMPLETE)
	Event_NarrativeEventsNotRunning(Mission_SitRep, nil, 1)
end

function Docks_Complete() Objective_Complete(SOBJ_Docks) end
function Docks_Init()	
	-- Setup Ambient Artillery
	_tAmbArtillery = Marker_GetTable("mkr_docks_ambient_artillery_%02d")
	
	-- Spawn Allies
	Docks_Allies_Init()
	
	-- Spawn initial allies
	local leftTable = Marker_GetTable("mkr_docks_allies_left_s%02d")
	for i = 1, table.getn(leftTable) do
		local _spawnSG = SGroup_Create("")
		Util_CreateSquads(player3, {_spawnSG, sg_docks_allies_left}, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, leftTable[i], nil, 1, World_GetRand(2, 3))
		SGroup_EnableUIDecorator(_spawnSG, false)
		Rule_AddSquadEvent(_allies_left_die, SGroup_GetSpawnedSquadAt(_spawnSG, 1), GE_SquadKilled)
		SGroup_Destroy(_spawnSG)
		_left_Allies_Curr = _left_Allies_Curr + 1
	end
	
	local _moveUp = function(gid, idx, sid)
		Cmd_Move(sg_docks_allies_left, mkr_docks_allies_left_dest_01)
	end
	
	SGroup_ForEach(sg_docks_allies_left, _moveUp)
	
	local centerTable = Marker_GetTable("mkr_docks_allies_center_s%02d")
	for i = 1, table.getn(centerTable) do
		local _spawnSG = SGroup_Create("")
		Util_CreateSquads(player3, {_spawnSG, sg_docks_allies_central}, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, centerTable[i], nil, 1, World_GetRand(2, 3))
		SGroup_EnableUIDecorator(_spawnSG, false)
		Rule_AddSquadEvent(_allies_center_die, SGroup_GetSpawnedSquadAt(_spawnSG, 1), GE_SquadKilled)
		SGroup_Destroy(_spawnSG)
		_central_Allies_Curr = _central_Allies_Curr + 1
	end
	
	local _moveUp = function(gid, idx, sid)
		Cmd_Move(sg_docks_allies_central, mkr_docks_allies_center_dest_01)
	end
	
	SGroup_ForEach(sg_docks_allies_central, _moveUp)
	
	local rightTable = Marker_GetTable("mkr_docks_allies_right_s%02d")
	for i = 1, table.getn(rightTable) do
		local _spawnSG = SGroup_Create("")
		Util_CreateSquads(player3, {_spawnSG, sg_docks_allies_right}, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, rightTable[i], nil, 1, World_GetRand(2, 3))
		SGroup_EnableUIDecorator(_spawnSG, false)
		Rule_AddSquadEvent(_allies_right_die, SGroup_GetSpawnedSquadAt(_spawnSG, 1), GE_SquadKilled)
		SGroup_Destroy(_spawnSG)
		_right_Allies_Curr = _right_Allies_Curr + 1
	end
	
	local _moveUp = function(gid, idx, sid)
		Cmd_Move(sg_docks_allies_right, mkr_docks_allies_right_dest_01)
	end
	
	SGroup_ForEach(sg_docks_allies_right, _moveUp)
	
	-- Init Encounters
	Docks_Encounters_Init()
	
	-- Preload HMG
	HMG_Encounters_Preload()
	
	-- Spawn T-34
	sg_a_t34 = SGroup_CreateIfNotFound("sg_a_t34")
	Util_CreateSquads(player3, sg_a_t34, SBP.SOVIET.T_34_76_SQUAD, mkr_docks_t34_A)
	Cmd_CriticalHit(player2, sg_a_t34, CRIT.VEHICLE_EXHAUST_DAMAGED, 1)
	SGroup_SetAvgHealth(sg_a_t34, 0.2)
	SGroup_SetAutoTargetting(sg_a_t34, "hardpoint_01", false)
	Modify_UnitSpeed(sg_a_t34, 0.4)
	t34_dam_mod = Modify_WeaponDamage(sg_a_t34, "hardpoint_01", 0.3)
	
	sg_a_engineers = SGroup_CreateIfNotFound("sg_a_engineers")
	Util_CreateSquads(player3, sg_a_engineers, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_docks_engineer, nil, 1, 1)
	Cmd_Ability(sg_a_engineers, ABILITY.SOVIET.SOVIET_REPAIR_ABILITY, sg_a_t34)
	
	-- T34
--~ 	Rule_Add(_docks_t34_moveOut_A)
	Event_Proximity(_docks_t34_moveOut_A, nil, player1, mkr_docks_t34, 16, ANY, 3)
	Event_Proximity(Docks_Start, nil, player1, mkr_docks_t34, 16, ANY)
	
	-- Spawn Groups
	sg_e_docks_grp_01 = SGroup_CreateIfNotFound("sg_e_docks_grp_01")
	sg_e_docks_grp_02 = SGroup_CreateIfNotFound("sg_e_docks_grp_02")
	
	Util_CreateSquads(player2, sg_e_docks_grp_01, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_docks_e_grp01_A, nil, 1, 4)
	Util_CreateSquads(player2, sg_e_docks_grp_01, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_docks_e_grp01_B, nil, 1, 5)
	Event_IsUnderAttack(_vulnGroup_01, nil, sg_e_docks_grp_01, ANY, 3, player1, nil)
	
	Util_CreateSquads(player2, sg_e_docks_grp_02, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_docks_e_grp02_A, nil, 1, 4)
	Util_CreateSquads(player2, sg_e_docks_grp_02, SBP.GERMAN.GRENADIER_SQUAD, mkr_docks_e_grp02_B, nil, 1, 3)
	Util_CreateSquads(player2, sg_e_docks_grp_02, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_docks_e_grp02_C, nil, 1, 3)
	Event_IsUnderAttack(_vulnGroup_02, nil, sg_e_docks_grp_02, ANY, 3, player1, nil)
	
	-- Speech
	Event_Proximity(EventHandler_StartIntel, {intel_callback = EVENTS.DOCKS_SPEECH_01}, player1, mkr_docks_speech_01, nil, ANY)
	Event_Proximity(EventHandler_StartIntel, {intel_callback = EVENTS.DOCKS_SPEECH_02}, player1, mkr_docks_speech_02, nil, ANY)
	
	-- Cover
	Rule_AddInterval(_docks_Cover_01_Check, 1)

end

function _vulnGroup_01() Modify_Vulnerability(sg_e_docks_grp_01, 1.2 ) end
function _vulnGroup_02() Modify_Vulnerability(sg_e_docks_grp_02, 1.2) end
function Docks_Speech_01() 
	Util_StartIntel(EVENTS.OFF_THE_DOCKS_01)
	eventID_offDocks_02 = Event_NarrativeEventsNotRunning(EventHandler_StartIntel, {intel = EVENTS.OFF_THE_DOCKS_02}, 3)
end
function _docks_t34_moveOut_A()
	_amb_arty_onScreen = false
	SGroup_SetAutoTargetting(sg_a_t34, "hardpoint_01", true)
	if SGroup_IsEmpty(sg_e_docks_grp_01) == false then grp_01 = ThreatArrow_CreateGroup(sg_e_docks_grp_01) end
	Cmd_SquadPath(sg_a_t34, "pth_a_t34_01", true, false, false, 0)
	Rule_AddInterval(_docks_t34_grp_01_Dead, 1)
end

function _docks_t34_grp_01_Dead()
	if SGroup_TotalMembersCount(sg_e_docks_grp_01) <= 3 
	  or SGroup_IsEmpty(sg_e_docks_grp_01) 
	  or SGroup_IsRetreating(sg_e_docks_grp_01, ANY) then 
		SGroup_SetAutoTargetting(sg_a_t34, "hardpoint_01", false) 
		if SGroup_IsEmpty(sg_e_docks_grp_01) == false then
			ThreatArrow_DestroyGroup(grp_01)
			Cmd_Retreat(sg_e_docks_grp_01, mkr_docks_e_retreat_02, mkr_docks_e_retreat_02)
			Modify_Vulnerability(sg_e_docks_grp_01, 3)
		end
	end	
	if (SGroup_TotalMembersCount(sg_e_docks_grp_01) <= 3 or SGroup_IsEmpty(sg_e_docks_grp_01) or SGroup_IsRetreating(sg_e_docks_grp_01, ANY))
	  and Prox_ArePlayersNearMarker(player1, mkr_docks_speech_01, ANY) then
		Rule_RemoveMe()
		SGroup_SetAutoTargetting(sg_a_t34, "hardpoint_01", true)
		
		if SGroup_IsEmpty(sg_e_docks_grp_02) == false then grp_02 = ThreatArrow_CreateGroup(sg_e_docks_grp_02) end
		Cmd_SquadPath(sg_a_t34, "pth_a_t34_02", true, false, false, 0)
		Rule_AddInterval(_docks_t34_grp_02_Dead, 1)
	end
end

function _docks_t34_grp_02_Dead()
	if SGroup_TotalMembersCount(sg_e_docks_grp_02) <= 3
	  or SGroup_IsEmpty(sg_e_docks_grp_02) 
	  or SGroup_IsRetreating(sg_e_docks_grp_02, ANY) then 
		SGroup_SetAutoTargetting(sg_a_t34, "hardpoint_01", false) 
		if SGroup_IsEmpty(sg_e_docks_grp_02) == false then
			ThreatArrow_DestroyGroup(grp_02)
			Cmd_Retreat(sg_e_docks_grp_02, mkr_docks_e_retreat_02, mkr_docks_e_retreat_02)
			Modify_Vulnerability(sg_e_docks_grp_02, 3)
		end
	end
	if (SGroup_TotalMembersCount(sg_e_docks_grp_02) <= 4 or SGroup_IsEmpty(sg_e_docks_grp_02) or SGroup_IsRetreating(sg_e_docks_grp_02, ANY))
	  and Prox_ArePlayersNearMarker(player1, mkr_docks_speech_02, ANY) then
		Rule_RemoveMe()
		SGroup_SetAutoTargetting(sg_a_t34, "hardpoint_01", true)
		
		Cmd_SquadPath(sg_a_t34, "pth_a_t34_03", true, false, false, 0)
		Rule_AddInterval(_docks_t34_stuka, 1)
	end
end

function _docks_t34_stuka()
	if SGroup_IsMoving(sg_a_t34, ANY) and Prox_AreSquadsNearMarker(sg_a_t34, mkr_docks_t34_destroy_trig, ANY, 10) then
		Rule_RemoveMe()
		SGroup_SetAutoTargetting(sg_a_t34, "hardpoint_01", true)
		Cmd_Ability(player2, BP_GetAbilityBlueprint("m01_stuka_bombing_strike"), Util_GetPosition(sg_a_t34), nil, true)
		Modify_UnitSpeed(sg_a_t34, 0)
		location_t34_bombingstrike = Util_GetPosition(sg_a_t34)
		time_t34_bombingstrike = World_GetGameTime()
		Rule_Add(_docks_t34_death)
	end
end

function _docks_t34_death()
	if SGroup_GetAvgHealth(sg_a_t34) <= 0.99 or (World_GetGameTime() - time_t34_bombingstrike) >= 13 then
		Rule_RemoveMe()
		Sound_Play2D("speech/sp/mission/m01/ambient/m01_tank_lost")
		Rule_Remove(_docks_t34_changeTar)
		SGroup_Kill(sg_a_t34)
		Rule_AddOneShot(_docks_t34_ostruppen_counter, 8)
		Rule_AddOneShot(_docks_Cover_03, 2)
		_central_Allies_paths = {"pth_a_cen_A", "pth_a_cen_B", "pth_a_cen_C"}
		
		Rule_AddOneShot(Docks_Complete, 1)
	end
end

function _docks_t34_ostruppen_counter()
	local squad = SGroup_GetRandomSpawnedSquad(sg_e_docks_central)
	Sound_Play3D("campaign/m01_german_soldiers_charge", Squad_EntityAt(squad, 0))
	Rule_AddOneShot(_docks_t34_ostruppen_charge, 1)
end

function _docks_t34_ostruppen_charge()
	SGroup_SetInvulnerable(sg_p_shock_01, true)
	SGroup_SetInvulnerable(sg_p_shock_02, true)
	SGroup_SetInvulnerable(sg_e_docks_central, false)
	local _vuln = function(gid, idx, sid)
		if Squad_GetBlueprint(sid) == SBP.GERMAN.OSTRUPPEN_SQUAD then
			local tempSG = SGroup_Create("")
			SGroup_Add(tempSG, sid)
			Modify_Vulnerability(tempSG, 1.5)
			Cmd_Move(tempSG, Util_GetOffsetPosition(tempSG, OFFSET_FRONT, 12))
			SGroup_Destroy(tempSG)
		end
	end
	SGroup_ForEach(sg_e_docks_central, _vuln)
	_germansAlive = SGroup_TotalMembersCount(sg_e_docks_central)
	
	tmr_docksComplete = "tmr_docksComplete"
	Timer_Start(tmr_docksComplete, 30)
	
	Rule_AddInterval(Docks_Complete_Check, 1)

end

function _docks_t34_changeTar()
	
	sg_a_t34_target = SGroup_CreateIfNotFound("sg_a_t34_target")
	local target = SGroup_GetRandomSpawnedSquad(sg_e_docks_central)
	
	SGroup_Clear(sg_a_t34_target)
	SGroup_Add(sg_a_t34_target, target)
	
	Cmd_Stop(sg_a_t34)
	Cmd_Attack(sg_a_t34, sg_a_t34_target, false, true)

end


-- Respawn Shock Troops
function _spawnShock01()
	
	local camTar = Camera_GetCurrentTargetPos()
	local offScreen = World_GetHiddenPositionOnPath(player1, mkr_docks_p_reSpawn, camTar, CHECK_OFFCAMERA)
	local spawn = nil
	if offScreen == nil then
		spawn = mkr_docks_p_reSpawn
	else
		spawn = Util_GetPositionFromAtoB(offScreen, mkr_docks_p_reSpawn, 10)
	end
	
	if spawn == nil then spawn = mkr_docks_p_reSpawn end
	
	Util_CreateSquads(player1, {sg_p_all, sg_p_shock_01}, SBP.SOVIET.SHOCK_TROOPS, spawn, camTar, 1, 6, true)
	
	_eventID_SpawnShock_01 = Event_GroupIsDead(_spawnShock01, nil, sg_p_shock_01, 1)
	
	Util_StartIntel(EVENTS.DOCKS_REINFORCE)
	
	EventCue_Create(CUE.NORMAL, 11040512, 11040512, sg_p_shock_01, nil, _con01_zoom, 8, true)	-- LOCDB [11040512] 'Additional Shock Troops Deployed'
	
end

function _shock01_zoom() Camera_MoveTo(Util_GetPosition(sg_p_shock_01), true, 0.5, false, true) end
function _spawnShock02()
	
	local camTar = Camera_GetCurrentTargetPos()
	local offScreen = World_GetHiddenPositionOnPath(player1, mkr_docks_p_reSpawn, camTar, CHECK_OFFCAMERA)
	local spawn = nil
	if offScreen == nil then
		spawn = mkr_docks_p_reSpawn
	else
		spawn = Util_GetPositionFromAtoB(offScreen, mkr_docks_p_reSpawn, 10)
	end
	
	if spawn == nil then spawn = mkr_docks_p_reSpawn end
	
	Util_CreateSquads(player1, {sg_p_all, sg_p_shock_02}, SBP.SOVIET.SHOCK_TROOPS, spawn, camTar, 1, 6, true)
	
	_eventID_SpawnShock_02 = Event_GroupIsDead(_spawnShock02, nil, sg_p_shock_02, 1)
	
	Util_StartIntel(EVENTS.DOCKS_REINFORCE)
	
	EventCue_Create(CUE.NORMAL, 11040512, 11040512, sg_p_shock_02, nil, _con02_zoom, 8, true)
	
end

function _shock02_zoom() Camera_MoveTo(Util_GetPosition(sg_p_shock_02), true, 0.5, false, true) end
-- Commissar Speech
function _docks_Commissar_Speech()
	
	if _commissar_speech_01 == nil then 
		_commissar_speech_01 = Sound_Play3D("speech/sp/mission/m01/11036234", Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_a_docks_commissar_speech, 1), 0))
	end
	
	while Sound_IsPlaying(_commissar_speech_01) do
		return
	end
	
	if _commissar_speech_02 == nil then
		_commissar_speech_02 = Sound_Play3D("speech/sp/mission/m01/11036235", Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_a_docks_commissar_speech, 1), 0))
	end
	
	while Sound_IsPlaying(_commissar_speech_02) do
		return
	end
	
	if _commissar_speech_03 == nil then
		_commissar_speech_03 = Sound_Play3D("speech/sp/mission/m01/11036236", Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_a_docks_commissar_speech, 1), 0))
	end
	
	while Sound_IsPlaying(_commissar_speech_03) do
		return
	end
	
	if _commissar_speech_04 == nil then
		_commissar_speech_04 = Sound_Play3D("speech/sp/mission/m01/11036237", Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_a_docks_commissar_speech, 1), 0))
	end
	
	while Sound_IsPlaying(_commissar_speech_04) do
		return
	end
	
	if _commissar_speech_05 == nil then
		_commissar_speech_05 = Sound_Play3D("speech/sp/mission/m01/11036238", Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_a_docks_commissar_speech, 1), 0))
	end
	
	while Sound_IsPlaying(_commissar_speech_05) do
		return
	end
	
	if _commissar_speech_06 == nil then
		_commissar_speech_06 = Sound_Play3D("speech/sp/mission/m01/11036239", Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_a_docks_commissar_speech, 1), 0))
	end
	
	while Sound_IsPlaying(_commissar_speech_06) do
		return
	end
	
	if _commissar_speech_07 == nil then
		_commissar_speech_07 = Sound_Play3D("speech/sp/mission/m01/11036240", Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_a_docks_commissar_speech, 1), 0))
	end
	
	while Sound_IsPlaying(_commissar_speech_07) do
		return
	end
	
	if _commissar_speech_08 == nil then
		_commissar_speech_08 = Sound_Play3D("speech/sp/mission/m01/11036241", Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_a_docks_commissar_speech, 1), 0))
	end
	
	while Sound_IsPlaying(_commissar_speech_08) do
		return
	end
	
	_commissar_speech_01 = nil
	_commissar_speech_02 = nil
	_commissar_speech_03 = nil
	_commissar_speech_04 = nil
	_commissar_speech_05 = nil
	_commissar_speech_06 = nil
	_commissar_speech_07 = nil
	_commissar_speech_08 = nil

end
-- Squads Rush and die
function Docks_Rush_Init()

	sg_docks_rush_commissar = SGroup_CreateIfNotFound("sg_docks_rush_commissar")
	Util_CreateSquads(player3, sg_docks_rush_commissar, SBP.SOVIET.SOVIET_OFFICER_SQUAD, mkr_docks_commissar_rush)
	SGroup_EnableUIDecorator(sg_docks_rush_commissar, false)
	
	sg_docks_rush_conscripts = SGroup_CreateIfNotFound("sg_docks_rush_conscripts")
	local rushTable = Marker_GetTable("mkr_docks_conscript_rush_%02d")
	
	for i = 1, table.getn(rushTable) do
		Util_CreateSquads(player3, sg_docks_rush_conscripts, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, rushTable[i], nil, 1, World_GetRand(3, 5))
		SGroup_EnableUIDecorator(sg_docks_rush_conscripts, false)
		
	end
	SGroup_SetInvulnerable(sg_docks_rush_conscripts, true)
	
	Event_Proximity(_docks_rush_kickoff, nil, player1, mkr_docks_rush_trig, nil, ANY)
	
end

function _docks_rush_kickoff()
	if Event_Exists(eventID_offDocks_02) then Event_Remove(eventID_offDocks_02) end
	Util_StartIntel(EVENTS.INTRO_SPEECH)
	Sound_PreCacheSound("abilities/oorah_group_huge")
	Rule_AddDelayedInterval(_docks_rush_go, 1.5, 1)
end

function _docks_rush_go()

	if Event_IsAnyRunning() == false or Prox_ArePlayersNearMarker(player1, mkr_docks_rush_moveTrig, ANY) then
		Rule_RemoveMe()
		
		Command_PlayerPosDirAbility(player2, player2, Util_GetPosition(mkr_docks_rush_stuka), Marker_GetDirection(mkr_docks_rush_stuka), BP_GetAbilityBlueprint("campaign_stuka_strafe_long"), true)
		
		Sound_Play3D("abilities/oorah_group_huge", Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_docks_rush_conscripts, 1), 0))
		
		Cmd_Move(sg_docks_rush_commissar, Util_GetRandomPosition(mkr_docks_allies_center_dest_01))
		Cmd_Move(sg_docks_rush_conscripts, Util_GetRandomPosition(mkr_docks_allies_center_dest_01))
		SGroup_SetInvulnerable(sg_docks_rush_conscripts, false)
	end

end

-- Docks Cover
function _docks_Cover_01_Check()
	if Prox_ArePlayersNearMarker(player1, mkr_cover_heavy_01, ANY) then
		Rule_RemoveMe()
		hpid_heavy_cover_01 = HintPoint_Add(mkr_cover_heavy_01, true, 11036457, 3, HPAT_CoverYellow)
		Rule_AddInterval(_docks_Cover_01_Remove, 1)
	end
end

function _docks_Cover_01_Remove()
	if Prox_ArePlayersNearMarker(player1, mkr_cover_heavy_01, ANY, 6) or SGroup_IsEmpty(sg_e_docks_grp_01) or SGroup_IsRetreating(sg_e_docks_grp_01, ALL) then
		Rule_RemoveMe()
		Rule_AddOneShot(_docks_Cover_01_Delay, 3)
		Rule_AddInterval(_docks_Cover_02_Check, 1)
	end
end

function _docks_Cover_01_Delay() HintPoint_Remove(hpid_heavy_cover_01) end

function _docks_Cover_02_Check()
	if Prox_ArePlayersNearMarker(player1, mkr_cover_heavy_02, ANY) 
	  and (SGroup_IsEmpty(sg_e_docks_grp_01) or SGroup_IsRetreating(sg_e_docks_grp_01, ANY)) then
		Rule_RemoveMe()
		hpid_heavy_cover_02 = HintPoint_Add(mkr_cover_heavy_02, true, 11036457, 3, HPAT_CoverGreen)
		Rule_AddInterval(_docks_Cover_02_Remove, 1)
	end
end

function _docks_Cover_02_Remove()
	if Prox_ArePlayersNearMarker(player1, mkr_cover_heavy_02, ANY, 6) or SGroup_IsEmpty(sg_e_docks_grp_02) or SGroup_IsRetreating(sg_e_docks_grp_02, ALL) then
		Rule_RemoveMe()
		Rule_AddOneShot(_docks_Cover_02_Delay, 3)
	end
end

function _docks_Cover_02_Delay() HintPoint_Remove(hpid_heavy_cover_02) end

function _docks_Cover_03()
	hpid_heavy_cover_03 = HintPoint_Add(location_t34_bombingstrike, true, 11047648, 3, HPAT_CoverGreen)
	Rule_AddInterval(_docks_Cover_03_Remove, 1)
end

function _docks_Cover_03_Remove()
	if Prox_ArePlayersNearMarker(player1, location_t34_bombingstrike, ANY, 6) or SGroup_IsEmpty(sg_e_docks_central) or SGroup_IsRetreating(sg_e_docks_central, ALL) then
		Rule_RemoveMe()
		Rule_AddOneShot(_docks_Cover_03_Delay, 3)
	end
end

function _docks_Cover_03_Delay() HintPoint_Remove(hpid_heavy_cover_03) end

-- Selection
function Selection_Init()

	tmr_selection = "tmr_selection"
	_selectionTries = 3
	_selectionCurr = 0
	_selectionTutActive = false
	
	if Rule_Exists(_selection_check) == false then Rule_AddInterval(_selection_check, 1) end

end

function _selection_check()
	
	local text = nil
	if g_difficulty == GD_EASY then
		text = 11036455
	else
		text = 11036456
	end
	
	if Misc_IsSGroupSelected(sg_p_shock_01, ANY) == false and Misc_IsSGroupSelected(sg_p_shock_02, ANY) == false then
		if _selectionTutActive == false then
			if Timer_Exists(tmr_selection) == false then 
				Timer_Start(tmr_selection, 12) 
			else
				if Timer_GetRemaining(tmr_selection) == 0 then
					_selectionTutActive = true
					_selectionCurr = _selectionCurr + 1
					
					Util_StartIntel(EVENTS.DOCKS_REMIND)
					
					hpid_selection_01 = HintPoint_Add(sg_p_shock_01, true, 11036456, 2)
					hpid_selection_02 = HintPoint_Add(sg_p_shock_02, true, 11036456, 2)
				end
			end
		end
	elseif Misc_IsSGroupSelected(sg_p_shock_01, ANY) or Misc_IsSGroupSelected(sg_p_shock_02, ANY) then
		if Timer_Exists(tmr_selection) then
			Timer_End(tmr_selection)
		end
		if _selectionTutActive == true then _selectionTutActive = false end
		if hpid_selection_01 ~= nil then
			HintPoint_Remove(hpid_selection_01)
			hpid_selection_01 = nil
		end
		if hpid_selection_02 ~= nil then
			HintPoint_Remove(hpid_selection_02)
			hpid_selection_02 = nil
		end
		if _selectionCurr == _selectionTries then Rule_RemoveMe() end
	end

end
--*******
-- DOCKS Encounters
--*******
function Docks_Encounters_Init()
	
	sg_e_docks_left = SGroup_CreateIfNotFound("sg_e_docks_left")
	_tMKR_left = Marker_GetTable("mkr_docks_left_%02d")
	_tSG_left = SGroup_CreateTable("_tSG_left_%02d", table.getn(_tMKR_left))
	_tLeft_events = {}
	
	for i = 1, table.getn(_tSG_left) do
		local rand = World_GetRand(1, 3)
		local sbp = nil
		if rand == 1 or rand == 2 then
			sbp = SBP.GERMAN.OSTRUPPEN_SQUAD
		else
			sbp = SBP.GERMAN.GRENADIER_SQUAD
		end
		Util_CreateSquads(player2, {sg_e_docks_left, _tSG_left[i]}, sbp, _tMKR_left[i], nil, 1, World_GetRand(3, 5))
		local t = {sg = _tSG_left[i], sbp = sbp, loc = _tMKR_left[i], side = "left", eventID = i}
		
		local eID = Event_GroupIsDead(_respawnGermans, t, _tSG_left[i], 0, false)
		table.insert(_tLeft_events, eID)
	end
	
	sg_e_docks_right = SGroup_CreateIfNotFound("sg_e_docks_right")
	_tMKR_right = Marker_GetTable("mkr_docks_right_%02d")
	_tSG_right = SGroup_CreateTable("_tSG_right_%02d", table.getn(_tMKR_right))
	_tRight_events = {}
	
	for i = 1, table.getn(_tSG_right) do
		local rand = World_GetRand(1, 3)
		local sbp = nil
		if rand == 1 or rand == 2 then
			sbp = SBP.GERMAN.OSTRUPPEN_SQUAD
		else
			sbp = SBP.GERMAN.GRENADIER_SQUAD
		end
		Util_CreateSquads(player2, {sg_e_docks_right, _tSG_right[i]}, sbp, _tMKR_right[i], nil, 1, World_GetRand(3, 5))
		local t = {sg = _tSG_right[i], sbp = sbp, loc = _tMKR_right[i], side = "right", eventID = i}
		
		local eID = Event_GroupIsDead(_respawnGermans, t, _tSG_right[i], 0, false)
		table.insert(_tRight_events, eID)
	end
	
	-- Central 
	sg_e_docks_stug_01 = SGroup_CreateIfNotFound("sg_e_docks_stug_01")
	Util_CreateSquads(player2, sg_e_docks_stug_01, SBP.GERMAN.STUG_III_E_SQUAD, mkr_docks_stug_01)
	
	_central_Stug_bombed = false
	
	sg_e_docks_central = SGroup_CreateIfNotFound("sg_e_docks_central")
	sg_e_docks_central_gren = SGroup_CreateIfNotFound("sg_e_docks_central_gren")
	Util_CreateSquads(player2, sg_e_docks_central, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_docks_central_01, nil, 1, 4)
	Util_CreateSquads(player2, sg_e_docks_central, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_docks_central_02, nil, 1, 3)
	Util_CreateSquads(player2, sg_e_docks_central, SBP.GERMAN.GRENADIER_SQUAD, mkr_docks_central_03, nil, 1, 4)
	Util_CreateSquads(player2, sg_e_docks_central, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_docks_central_04, nil, 1, 4)
	Util_CreateSquads(player2, sg_e_docks_central, SBP.GERMAN.GRENADIER_SQUAD, mkr_docks_central_05, nil, 1, 5)
	Util_CreateSquads(player2, sg_e_docks_central, SBP.GERMAN.GRENADIER_SQUAD, mkr_docks_central_06, nil, 1, 4)
	Util_CreateSquads(player2, sg_e_docks_central, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_docks_central_07, nil, 1, 3)
	
	SGroup_SetInvulnerable(sg_e_docks_central, 0.75)
	
	-- Right
	sg_e_docks_stug_02 = SGroup_CreateIfNotFound("sg_e_docks_stug_02")
	Util_CreateSquads(player2, sg_e_docks_stug_02, SBP.GERMAN.STUG_III_E_SQUAD, mkr_docks_stug_02)
	
	_right_Stug_bombed = false
	
	Event_Proximity(_docks_bomb_stug_01, nil, player1, mkr_docks_stug_01, 35, ANY)
	Event_Proximity(_docks_bomb_stug_02, nil, player1, mkr_docks_stug_02, 35, ANY)

end

function _respawnGermans(data_table)
	
	local spawn = nil
	local sgroup = nil
	if data_table.side == "left" then
		spawn = Util_FindHiddenSpawn(mkr_docks_left_rein_01, mkr_docks_left_rein_01_visible)
		sgroup = sg_e_docks_left
	elseif data_table.side == "right" then
		spawn = Util_FindHiddenSpawn(mkr_docks_right_rein_01, mkr_docks_right_rein_01_visible)
		sgroup = sg_e_docks_right
	end
	
	Util_CreateSquads(player2, {sgroup, data_table.sg}, data_table.sbp, spawn, data_table.loc, 1, World_GetRand(3, 5))
	local t = {sg = data_table.sg, sbp = data_table.sbp, loc = data_table.loc, side = data_table.side, eventID = data_table.eventID}
	data_table.eventID = Event_GroupIsDead(_respawnGermans, t, data_table.sg, 0, false)

end

function _docks_bomb_stug_01()

	if _central_Stug_bombed == false then
		_central_Stug_bombed = true
		
		Cmd_Ability(player3, BP_GetAbilityBlueprint("m01_il2_precision_bomb_strike"), mkr_docks_stug_01, nil, true)
		Event_OnHealth(_docks_stug_01_kill, nil, sg_e_docks_stug_01, 0.99, false)
	end

end

function _docks_stug_01_kill() SGroup_Kill(sg_e_docks_stug_01) end
function _docks_bomb_stug_02()

	if _right_Stug_bombed == false then
		_right_Stug_bombed = true
		
		Cmd_Ability(player3, BP_GetAbilityBlueprint("m01_il2_precision_bomb_strike"), mkr_docks_stug_02, nil, true)
		Event_OnHealth(_docks_stug_02_kill, nil, sg_e_docks_stug_02, 0.99, false)
	end

end

function _docks_stug_02_kill() SGroup_Kill(sg_e_docks_stug_02) end
--*******
-- HMG Encounter (Preload)
--*******
function HMG_Encounters_Preload()

	-- Spawn HMG
	sg_e_hmg_grenade = SGroup_CreateIfNotFound("sg_e_hmg_grenade")
	
	Util_CreateSquads(player2, sg_e_hmg_grenade, SBP.GERMAN.M01_MG42_HEAVY_MACHINE_GUN_SQUAD_SINGLE, Util_GetOffsetPosition(mkr_hmg_spawn, OFFSET_BACK, 5))
	Rule_AddOneShot(_hmg_setup, 1)
	
	Util_LogSyncWpn(sg_e_hmg_grenade, true)

end

function _hmg_setup()

	Cmd_Move(sg_e_hmg_grenade, mkr_hmg_spawn, false, nil, Util_GetOffsetPosition(mkr_hmg_spawn, OFFSET_FRONT, 10))
	Command_SquadPos(player2, sg_e_hmg_grenade, SCMD_Attack, Util_GetPosition(mkr_hmg_target), true)
	Modify_Vulnerability(sg_e_hmg_grenade, 0.7)
--~ 	_hmg_armor_mod = Modify_Armor(sg_e_hmg_grenade, 35)
	
	sg_hmg_def = SGroup_CreateIfNotFound("sg_hmg_def")
	Util_CreateSquads(player2, sg_hmg_def, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_hmg_def_s01, nil, 1, 5)
	Util_CreateSquads(player2, sg_hmg_def, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_hmg_def_s02, nil, 1, 4)
	Util_CreateSquads(player2, sg_hmg_def, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_hmg_def_s03, nil, 1, 3)
	
	Util_CreateSquads(player2, sg_hmg_def, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_hmg_def_rightFlank_s01, nil, 1, 5)
	Util_CreateSquads(player2, sg_hmg_def, SBP.GERMAN.GRENADIER_SQUAD, mkr_hmg_def_rightFlank_s02, nil, 1, 4)
	
	Util_CreateSquads(player2, sg_hmg_def, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_hmg_def_leftFlank_s01, nil, 1, 4)
	Util_CreateSquads(player2, sg_hmg_def, SBP.GERMAN.GRENADIER_SQUAD, mkr_hmg_def_leftFlank_s02, nil, 1, 4)

end




-------------------------------------------------------------------------
-- HMG
-------------------------------------------------------------------------
--******
-- HMG Objective
--******
function HMG_Init_Objective()

	SOBJ_Hmg = {
		
		SetupUI = function() 
			hpid_hmg = Objective_AddUIElements(SOBJ_Hmg, sg_e_hmg_grenade, true, 11036465, true, 2)		-- LOCDB [11036462] 'Clear the German Line'
		end,
		
		OnStart = function()
			Game_EnableInput(true)
			Camera_SetInputEnabled(true)
			
			hpid_hmg_pin = HintPoint_Add(mkr_hmg_pin_hintPoint, true, 11036468)
			hpid_hmg_flank_left = HintPoint_Add(mkr_hmg_leftFlank_hintPoint, true, 11036469)
			hpid_hmg_flank_right = HintPoint_Add(mkr_hmg_rightFlank_hintPoint, true, 11036469)
			
			Event_Proximity(EventHandler_StartIntel, {intel_callback = EVENTS.HMG_AMBIENT}, player1, {mkr_hmg_rightFlank_hintPoint, mkr_hmg_leftFlank_hintPoint}, nil, ANY)
			
			SGroup_Kill(sg_e_docks_left)
			SGroup_Kill(sg_e_docks_central)
			SGroup_Kill(sg_e_docks_right)
			
			Rule_AddOneShot(_hmg_remind, 1.5*60)
			
			sg_hmg_allies_pin = SGroup_CreateIfNotFound("sg_hmg_allies_pin")
			
			-- Spawn the Howitzers
			sg_e_howitzer_01 = SGroup_CreateIfNotFound("sg_e_howitzer_01")
			sg_e_howitzer_02 = SGroup_CreateIfNotFound("sg_e_howitzer_02")
			
			Util_CreateSquads(player2, sg_e_howitzer_01, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, mkr_res_e_howitzer_01)
			Util_CreateSquads(player2, sg_e_howitzer_02, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, mkr_res_e_howitzer_02)
			
			Util_LogSyncWpn(sg_e_howitzer_01, false)
			Util_LogSyncWpn(sg_e_howitzer_02, false)
			
			Event_GroupIsDead(HMG_Objective_Complete, nil, sg_e_hmg_grenade, 2)
			Event_GroupIsDead(_hmg_fire_howitzers, nil, sg_e_hmg_grenade)
			
			Event_Proximity(_hmg_nearMG, nil, player1, {mkr_hmg_grant_gren_01, mkr_hmg_grant_gren_02}, nil, ANY)
			
			Rule_AddOneShot(_hmg_add_shock_troops, 4)
		end,
		
		OnComplete = function()	
			if SGroup_IsEmpty(sg_hmg_vault_squad) == false then SGroup_Kill(sg_hmg_vault_squad) end
			if Rule_Exists(_hmg_findSquad) then Rule_Remove(_hmg_findSquad) end
			if Event_Exists(eventID_vaulnVaultSquad) then Event_Remove(eventID_vaulnVaultSquad) end
			if Rule_Exists(_hmg_vaultSquad_Suppression) then Rule_Remove(_hmg_vaultSquad_Suppression) end
			
			if SGroup_IsEmpty(sg_hmg_vault_squad) == false then SGroup_Kill(sg_hmg_vault_squad) end
			
			_allies_despawn = mkr_res_despawn
			World_IncreaseInteractionStage()
			
			if encID_res_def02:IsAlive() then
				encID_res_def02:Disable()
				Cmd_StaggeredRetreat(sg_e_res_def_02, {mkr_res_a_right_despawn}, 3, true)
			end
			
			-- Beginner
			BeginnerHint_AddOpportunity(sg_e_res_def_03, ABILITY.SOVIET.RG_42_ANTI_PERSONNEL_GRENADE, true)
			
			if Rule_Exists(_hmg_remind) then Rule_Remove(_hmg_remind) end
			
			Rule_Remove(_hmg_suppress_ally)
			
			HintPoint_Remove(hpid_hmg_pin)
			HintPoint_Remove(hpid_hmg_flank_left)
			HintPoint_Remove(hpid_hmg_flank_right)
			
			Rule_Remove(_hmg_invuln_delay)
			
			Rule_AddOneShot(HOWITZERS_Init, 10)
			
			Rule_Remove(_hmg_suppress_player)
			_central_Allies_pin = nil
			
			EGroup_InstantCaptureStrategicPoint(eg_hmg_cp, player1)
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.NIS02,		
		Intel_Start_SkipFunc = _skipHMG_Start,
		Intel_Complete = EVENTS.HMG_COMPLETE,			
		Intel_Fail = nil,				
		Title = 11036465,							-- LOCDB [11036466] 'Flank the HMG'
		Type = OT_Primary,				
		Parent = OBJ_AssaultStalingrad,
	}
	
	Objective_Register(SOBJ_Hmg)

end

function _skipHMG_Start()
	Camera_MoveTo(sg_p_shock_01, false, 0.5, false, true)
	
	Game_SetMode(UI_Normal)
	Game_EnableInput(true)
	Camera_SetInputEnabled(true)
end

function HMG_Objective_Start()

	Objective_Start(SOBJ_Hmg)

end

function HMG_Objective_Complete()
	
	Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 0)
	Util_PlayMusic(g_music_howitzers, 0, 3)
	
	Cmd_StaggeredRetreat(sg_hmg_def, {mkr_arty_e_retreat_02}, 4, true)
	EGroup_Kill(eg_hmg_wire)
	
	Objective_Complete(SOBJ_Hmg)

end

function _hmg_fire_howitzers()
	
	Cmd_Ability(sg_e_howitzer_01, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, mkr_howitzer_barrage_01, nil, true)
	Rule_AddOneShot(HMG_Barrage_Delay, 1)

end

function HMG_Barrage_Delay() Cmd_Ability(sg_e_howitzer_02, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, mkr_howitzer_barrage_02, nil, true) end
function _hmg_remind() Util_StartIntel(EVENTS.HMG_REMIND) end
function _hmg_add_shock_troops() Util_StartIntel(EVENTS.SHOCK_TROOPS_AVAILABLE) end
function _hmg_remove_shock_ping() 
	UI_StopFlashing(hpid_shock_troop_dispatch) 
	tmr_shockRemind = "tmr_shockRemind"
	_remindedShockOnce = false
	Timer_Start(tmr_shockRemind, 8*60)
	Rule_AddDelayedInterval(LESSON_Shock_Troop_Dispatch_Reminder, 1, 1)
end

function LESSON_Shock_Troop_Dispatch_Reminder()
	if Event_IsAnyRunning() == false 
	  and (Timer_GetRemaining(tmr_shockRemind) == 0 or SGroup_TotalMembersCount(sg_p_all) <= 4) then
		Rule_RemoveMe()
		
		if _calledInShockTroops == false and _remindedShockOnce == false then
			_remindedShockOnce = true
			Util_StartIntel(EVENTS.SHOCK_TROOPS_AVAILABLE)
		end	
	end
end
-- Encounter Functions
function HMG_Init()
	
	SGroup_DestroyAllSquads(sg_e_docks_central)
		
	-- Kill Rush Conscripts
	if SGroup_IsEmpty(sg_docks_rush_conscripts) == false then SGroup_Kill(sg_docks_rush_conscripts) end
	
	SGroup_WarpToMarker(sg_p_shock_01, mkr_p_shock_01_warp)
	SGroup_WarpToMarker(sg_p_shock_02, mkr_p_shock_02_warp)
	
	Game_SetMode(UI_Cinematic)
	
	Player_SetResource(player1, RT_Command, 1)
	
	-- Reduce allies
	local spawned = SGroup_CountSpawned(sg_docks_allies_central)
	local kill = nil
	if spawned > _central_Allies_Max then
		kill = (spawned - _central_Allies_Max)
	end
	
	if kill ~= nil then
		local __cull = function(gid, idx, sid)
			if kill >= 1 then
				kill = kill-1
				Squad_Kill(sid)
			end
		end
		
		SGroup_ForEach(sg_docks_allies_central, __cull)
	end
	
	Rule_AddInterval(_allies_despawner, 6)
	
	-- Setup Ambient Artillery
	_tAmbArtillery = Marker_GetTable("mkr_res_ambient_artillery_%02d")
	
	_stuka_Area = mkr_res_stuka_area
	
	_playerHasBeenSuppressed = false
	
	HMG_Objective_Start()
	
	Camera_MoveTo(mkr_hmg_spawn, false, 1, false, true)
	FOW_RevealSGroup(sg_e_hmg_grenade, -1)
	
--~ 	-- Spawn scripted allies
--~ 	sg_a_hmg_SCR = SGroup_CreateIfNotFound("sg_a_hmg_SCR")
--~ 	Util_CreateSquads(player3, sg_a_hmg_SCR, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_hmg_SCR_a_s01, nil, 1, 3)
--~ 	Util_CreateSquads(player3, sg_a_hmg_SCR, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_hmg_SCR_a_s02, nil, 1, 4)
--~ 	Util_CreateSquads(player3, sg_a_hmg_SCR, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_hmg_SCR_a_s03, nil, 1, 3)
--~ 	SGroup_EnableUIDecorator(sg_a_hmg_SCR, false)
--~ 	Rule_AddInterval(_hmg_invuln_delay, 1)
	
	-- Start Firing
--~ 	Rule_AddInterval(_hmg_Fire_On_Target, 1)
	Rule_AddInterval(_hmg_suppress_ally, 3)
	Rule_AddInterval(_hmg_suppress_player, 1)
	
	-- Spawn Encounters
	HMG_Encounters_Init()

end

function _hmg_invuln_delay() SGroup_SetInvulnerable(sg_a_hmg_SCR, true) end

function _hmg_Fire_On_Target()
	
	if SGroup_IsEmpty(sg_e_hmg_grenade) == false then
		Command_SquadPos(player2, sg_e_hmg_grenade, SCMD_Attack, Util_GetPosition(mkr_hmg_target), true)
	else
		Rule_RemoveMe()
	end	

end

function _hmg_suppress_ally()

	sg_hmg_ally_suppress = SGroup_CreateIfNotFound("sg_hmg_ally_suppress")
	Player_GetAllSquadsNearMarker(player3, sg_hmg_ally_suppress, mkr_hmg_pin_dest)
	
	SGroup_SetSuppression(sg_hmg_ally_suppress, 0.6)

end

function _hmg_suppress_player()
	
	sg_hmg_player_suppress = SGroup_CreateIfNotFound("sg_hmg_player_suppress")
	
	Player_GetAllSquadsNearMarker(player1, sg_hmg_player_suppress, mkr_hmg_pin_dest)
	
	if SGroup_IsEmpty(sg_hmg_player_suppress) == false then
		SGroup_SetSuppression(sg_hmg_player_suppress, 0.5)
		
		if _playerHasBeenSuppressed == false then
			_playerHasBeenSuppressed = true
			
			Util_StartIntel(EVENTS.HMG_SUPPRESSED)
		end
		
		if hpid_suppressed == nil then
			hpid_suppressed = HintPoint_Add(sg_hmg_player_suppress, true, 11046818)	-- LOCDB [11046818] 'Suppressed squads are less-useful'
		end
	else
		if hpid_suppressed ~= nil then
			HintPoint_Remove(hpid_suppressed)
			hpid_suppressed = nil
		end
	end

end

function _hmg_nearMG() Util_StartIntel(EVENTS.HMG_NEAR) Rule_AddOneShot(_hmg_stop_flash, 30) end
function _hmg_stop_flash()
	if fpid_grenade ~= nil then UI_StopFlashing(fpid_grenade) end
end
function _hmg_makeVuln()
	
	if SGroup_IsEmpty(sg_e_hmg_grenade) == false then
		Modifier_Remove(_hmg_armor_mod)
	end

end


function _vulnHMG(data)
	SGroup_SetInvulnerable(data.sgroup, false)
	Modify_Vulnerability(data.sgroup, 5)
--~ 	SGroup_Kill(data.sgroup)
end
function _removeSuppression()
	if SGroup_IsEmpty(sg_a_HMG_kill_01) == false then SGroup_SetSuppression(sg_a_HMG_kill_01, 0) end
	if SGroup_IsEmpty(sg_a_HMG_kill_02) == false then SGroup_SetSuppression(sg_a_HMG_kill_02, 0) end
	if SGroup_IsEmpty(sg_a_HMG_kill_03) == false then SGroup_SetSuppression(sg_a_HMG_kill_03, 0) end
	if SGroup_IsEmpty(sg_a_HMG_kill_04) == false then SGroup_SetSuppression(sg_a_HMG_kill_04, 0) end
	if SGroup_IsEmpty(sg_a_HMG_kill_05) == false then SGroup_SetSuppression(sg_a_HMG_kill_05, 0) end
	if SGroup_IsEmpty(sg_a_HMG_kill_06) == false then SGroup_SetSuppression(sg_a_HMG_kill_06, 0) end
	if SGroup_IsEmpty(sg_a_HMG_kill_07) == false then SGroup_SetSuppression(sg_a_HMG_kill_07, 0) end
	if SGroup_IsEmpty(sg_a_HMG_kill_08) == false then SGroup_SetSuppression(sg_a_HMG_kill_08, 0) end
	if SGroup_IsEmpty(sg_a_HMG_kill_09) == false then SGroup_SetSuppression(sg_a_HMG_kill_09, 0) end
	if SGroup_IsEmpty(sg_a_HMG_kill_10) == false then SGroup_SetSuppression(sg_a_HMG_kill_10, 0) end
end


function _hmg_findSquad()
	sg_hmg_vault_squad = SGroup_CreateIfNotFound("sg_hmg_vault_squad")
	
	if SGroup_IsEmpty(sg_docks_allies_central) then Rule_AddOneShot(_hmg_findSquad, 2) end
	
	local squad = SGroup_GetRandomSpawnedSquad(sg_docks_allies_central)
	SGroup_Remove(sg_docks_allies_central, squad)
	SGroup_Add(sg_hmg_vault_squad, squad)
	
	SGroup_SetInvulnerable(sg_hmg_vault_squad, true)
	Cmd_Move(sg_hmg_vault_squad, mkr_hmg_vault_02_dest)
	Command_SquadEntity(player3, sg_hmg_vault_squad, SCMD_Move, eg_hmg_vault_01, true)
	Cmd_Move(sg_hmg_vault_squad, mkr_hmg_kill_dest_02, true)
	
	Cmd_Upgrade(sg_hmg_vault_squad, BP_GetUpgradeBlueprint("m01_hmg_death_squad_upgrade"), 1, true)
	
	eventID_vaulnVaultSquad = Event_Proximity(_vulnHMG, {sgroup = sg_hmg_vault_squad}, sg_hmg_vault_squad, mkr_hmg_vault_vauln, nil, ANY)
	
	Event_GroupIsDead(_hmg_findSquad, nil, sg_hmg_vault_squad, 6)
	
end

function _hmg_vaultSquad_Suppression()
	if SGroup_IsEmpty(sg_hmg_vault_squad) == false then SGroup_SetSuppression(sg_hmg_vault_squad, 0) end
end

--*******
-- HMG Encounters
--*******
function HMG_Encounters_Init()
	
	sg_e_res_all = SGroup_CreateIfNotFound("sg_e_res_all")
	
	_HMG_Encs_Def_01()
	_HMG_Encs_Def_02()

end

function _HMG_Encs_Def_01()
	
	sg_e_res_def_01 = SGroup_CreateIfNotFound("sg_e_res_def_01")
	
	local encData = {
		name = ("HMG_Enc_def_01"),
		player = player2,
		spawn = mkr_e_res_def_01,
		sgroups = {sg_e_res_def_01},
		units = {
			{
				name = (""),
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				spawn = mkr_e_res_def_s01,
				load = 3,
			},
			{
				name = (""),
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_e_res_def_s02,
				load = 4,
			},
			{
				name = (""),
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_e_res_def_s03,
				load = 4,
			},
		},
	}
	encID_res_def01 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_e_res_def_01,
		
		range = 20,
		leashRange = 10,
		
		retaliateAttacks = false,
		
--~ 		coordinatedSetup = true,
--~ 		coordinatedSetupFacingPositions = {
--~ 			Util_GetOffsetPosition(mkr_e_res_def_01, OFFSET_FRONT, 100),
--~ 		},
		
		abilityBlacklist = {
			ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY,
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = -1,
			},
		}
	}
	encID_res_def01:SetGoal(goalData)
	

end

function _HMG_Encs_Def_02()
	
	sg_e_res_def_02 = SGroup_CreateIfNotFound("sg_e_res_def_02")
	
	local encData = {
		name = ("HMG_Enc_def_02"),
		player = player2,
		spawn = mkr_e_res_def_02,
		sgroups = {sg_e_res_all, sg_e_res_def_02},
		units = {
			{
				name = (""),
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_e_res_def_02_s01,
				load = 3,
			},
			{
				name = (""),
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_e_res_def_02_s02,
				load = 4,
			},
			{
				name = (""),
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_e_res_def_02_s03,
				load = 4,
			},
			{
				name = (""),
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_e_res_def_02_s04,
				load = 3,
			},
		},
	}
	encID_res_def02 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_e_res_def_02,
		
		range = 20,
		leashRange = 10,
		
		retaliateAttacks = false,
--~ 		coordinatedSetup = true,
--~ 		coordinatedSetupFacingPositions = {
--~ 			Util_GetOffsetPosition(mkr_e_res_def_02, OFFSET_FRONT, 100),
--~ 		},
		
		abilityBlacklist = {
			ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY,
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = -1,
			},
		}
	}
	encID_res_def02:SetGoal(goalData)

end
-------------------------------------------------------------------------
-- HOWITZERS
-------------------------------------------------------------------------
--******
-- HOWITZERS Objective SBP.GERMAN.ELEFANT_TANK_DESTROYER_SQUAD
--******
function HOWITZERS_Init_Objective()

	SOBJ_Howitzers = {
		
		SetupUI = function() 
			hpid_howitzers_01 = Objective_AddUIElements(SOBJ_Howitzers, sg_e_howitzer_01, true, 11036470, true, 3)
			hpid_howitzers_02 = Objective_AddUIElements(SOBJ_Howitzers, sg_e_howitzer_02, true, 11036470, true, 3)
		end,
		
		OnStart = function()
			Rule_AddOneShot(BONUS_Delay_Trigger, 8)
			
			SGroup_SetInvulnerable(sg_e_howitzer_01, false)
			SGroup_SetInvulnerable(sg_e_howitzer_02, false)
			
			FOW_RevealArea(Util_GetPosition(sg_e_howitzer_01), 5, -1)
			FOW_RevealArea(Util_GetPosition(sg_e_howitzer_02), 5, -1)
			
			Objective_SetCounter(SOBJ_Howitzers, 0, 2)
			
			Event_GroupIsDead(HOWTIZERS_Gun_Dead, nil, sg_e_howitzer_01, 2, true)
			Event_GroupIsDead(HOWTIZERS_Gun_Dead, nil, sg_e_howitzer_02, 2, true)
		end,
		
		OnComplete = function()	
			Cmd_Move(sg_a_blocker_hmg_right, mkr_blocker_hmg_right_dest02, false, nil, Util_GetOffsetPosition(mkr_blocker_hmg_right_dest02, OFFSET_FRONT, 10))
			Cmd_Move(sg_a_blocker_com_right, mkr_blocker_commissar_right_dest02)
			Cmd_Move(sg_a_blocker_guard_right, mkr_blocker_guards_right_dest02)
			
			Cmd_Move(sg_a_blocker_hmg_center, mkr_blocker_hmg_center_dest02, false, nil, Util_GetOffsetPosition(mkr_blocker_hmg_center_dest02, OFFSET_FRONT, 10))
			Cmd_Move(sg_a_blocker_com_center, mkr_blocker_commissar_center_dest02)
			Cmd_Move(sg_a_blocker_guard_center, mkr_blocker_guards_center_dest02)
			
			_allies_despawn = mkr_p4_despawn
			
			PANZER_Init()
			
			EGroup_InstantCaptureStrategicPoint(eg_howitzer_cp, player1)
			World_IncreaseInteractionStage()
			
			-- Move up play area
			Camera_ClampToMarker(mkr_playzone_panzer)
			Misc_RestrictCommandsToMarker(mkr_playzone_panzer)
			
			-- Despawn the Wounded back at the docks
			for i = 1, table.getn(tsg_wounded) do
				SGroup_DestroyAllSquads(tsg_wounded[i])
			end
			
			-- And the Medics
			SGroup_DestroyAllSquads(sg_a_docks_medics)
			-- And the commissars
			SGroup_DestroyAllSquads(sg_a_docks_commissar)
			SGroup_DestroyAllSquads(sg_a_docks_commissar_speech)
			-- ... And the ambient conscripts
			SGroup_DestroyAllSquads(sg_a_docks_con)
			
			if Rule_Exists(_medic_01_Ability) then Rule_Remove(_medic_01_Ability) end
			if Rule_Exists(_medic_02_Ability) then Rule_Remove(_medic_02_Ability) end
			if Rule_Exists(_medic_01_at_patient) then Rule_Remove(_medic_01_at_patient) end
			if Rule_Exists(_medic_02_at_patient) then Rule_Remove(_medic_02_at_patient) end
			if Rule_Exists(_medic_01_healing_done) then Rule_Remove(_medic_01_healing_done) end
			if Rule_Exists(_medic_02_healing_done) then Rule_Remove(_medic_02_healing_done) end
			
			Player_GetAll(player1)
			
			local _moveUp = function(gid, idx, sid)
				local tempSG = SGroup_Create("")
				SGroup_Add(tempSG, sid)
				if Prox_AreSquadsNearMarker(tempSG, mkr_playzone_panzer, ANY) == false then
					if SGroup_IsOnScreen(player1, tempSG, ANY) == false then
						SGroup_WarpToPos(tempSG, Util_GetRandomPosition(mkr_p_panzer_warp))
					else
						Cmd_Move(tempSG, Util_GetRandomPosition(mkr_p_panzer_warp))
					end	
				end
				SGroup_Destroy(tempSG)
			end
			
			SGroup_ForEach(sg_allsquads, _moveUp)
			
			Cmd_StaggeredRetreat(sg_e_res_all, {mkr_arty_e_retreat_01, mkr_arty_e_retreat_02, }, 5, true)
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.ARTY_START,				
		Intel_Complete = EVENTS.ARTY_COMPLETE,			
		Intel_Fail = nil,				
		Title = 11036470,							-- LOCDB [11036466] 'Flank the HMG'
		Type = OT_Primary,				
		Parent = OBJ_AssaultStalingrad,
	}
	
	Objective_Register(SOBJ_Howitzers)

end

function HOWITZERS_Objective_Start()

	Objective_Start(SOBJ_Howitzers)

end

function HOWTIZERS_Gun_Dead()
	
	local count = Objective_GetCounter(SOBJ_Howitzers)
	if count == 0 then
		if SGroup_IsEmpty(sg_e_howitzer_01) or SGroup_IsRetreating(sg_e_howitzer_01, ANY) then 
			Objective_RemoveUIElements(SOBJ_Howitzers, hpid_howitzers_01) 
			if encID_how_def01:IsAlive() then
				encID_how_def01:Disable()
				Cmd_StaggeredRetreat(sg_e_how_def_01, {mkr_arty_e_retreat_01, mkr_arty_e_retreat_02}, 2, true)
			end
		end
		if SGroup_IsEmpty(sg_e_howitzer_02) or SGroup_IsRetreating(sg_e_howitzer_02, ANY) then 
			Objective_RemoveUIElements(SOBJ_Howitzers, hpid_howitzers_02)
			if encID_how_def02:IsAlive() then
				encID_how_def02:Disable()
				Cmd_StaggeredRetreat(sg_e_how_def_02, {mkr_arty_e_retreat_02, }, 2, true)
			end
		end
		Objective_SetCounter(SOBJ_Howitzers, (count+1), 2)
		Util_StartIntel(EVENTS.ARTY_DEAD)
	elseif count == 1 then
		Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 0)
		Util_PlayMusic(g_music_panzer, 0, 3)
		
		Objective_SetCounter(SOBJ_Howitzers, (count+1), 2)
		Objective_Complete(SOBJ_Howitzers, false)
		Objective_Complete(OBJ_AssaultStalingrad)
		
		-- Pre-create fodder SGroup
		sg_p4_fodder = SGroup_CreateIfNotFound("sg_p4_fodder")
		
		-- Spawn the Panzer
		sg_e_panzer = SGroup_CreateIfNotFound("sg_e_panzer")
		
		Util_CreateSquads(player2, sg_e_panzer, SBP.GERMAN.PANZER_IV_SQUAD, mkr_p4_e_panzer_spawn, mkr_p4_e_panzer_dest_01)
		SGroup_SetInvulnerable(sg_e_panzer, true)
		
		Event_PlayerCanSeeElement(_panzer_spotted, nil, player1, sg_e_panzer, ANY, 2)
	end

end
-- Encounter Functions
function HOWITZERS_Init()
	
	SGroup_SetInvulnerable(sg_e_howitzer_01, true)
	SGroup_SetInvulnerable(sg_e_howitzer_02, true)
	
	HOWITZERS_Objective_Start()
	
	Rule_AddDelayedInterval(_howitzer_01_ShootSky, 10, 1)
	Rule_AddDelayedInterval(_howitzer_02_ShootSky, 13, 1)
	
	HOWITZER_Allies_Init()
	HOWITZERS_Encounters_Init()

end

function _howitzer_01_ShootSky()
	if SGroup_IsEmpty(sg_e_howitzer_01) or SGroup_IsRetreating(sg_e_howitzer_01, ANY) or SGroup_TotalMembersCount(sg_e_howitzer_01) == 1 then Rule_RemoveMe() return end
	if SGroup_IsDoingAbility(sg_e_howitzer_01, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, ANY) == false then
		Cmd_Ability(sg_e_howitzer_01, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, mkr_howitzer_01_skyTarget, nil, true)
	end
end
function _howitzer_02_ShootSky()
	if SGroup_IsEmpty(sg_e_howitzer_02) or SGroup_IsRetreating(sg_e_howitzer_02, ANY) or SGroup_TotalMembersCount(sg_e_howitzer_02) == 1 then Rule_RemoveMe() return end
	if SGroup_IsDoingAbility(sg_e_howitzer_02, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, ANY) == false then
		Cmd_Ability(sg_e_howitzer_02, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, mkr_howitzer_02_skyTarget, nil, true)
	end
end
--******
-- HOWITZERS Encounters
--******
function HOWITZERS_Encounters_Init()
	
	_HOWITZER_Encs_Def_01()
	_HOWITZER_Encs_Def_02()
	_HOWITZER_Encs_Def_03()
	
	_HOWITZER_Encs_How_Def_01()
	_HOWITZER_Encs_How_Def_02()
	
	sg_e_res_left = SGroup_CreateIfNotFound("sg_e_res_left")
	-- Scripted
	Util_CreateSquads(player2, sg_e_res_all, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_e_res_SCR_01, mkr_e_res_SCR_01_dest, 1, 3)
	Util_CreateSquads(player2, sg_e_res_all, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_e_res_SCR_02, mkr_e_res_SCR_02_dest, 1, 4)
	Util_CreateSquads(player2, sg_e_res_all, SBP.GERMAN.GRENADIER_SQUAD, mkr_e_res_SCR_03, nil, 1, 3)
	Util_CreateSquads(player2, sg_e_res_all, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_e_res_SCR_04, nil, 1, 4)
	Util_CreateSquads(player2, sg_e_res_all, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_e_res_SCR_05, nil, 1, 3)
	Util_CreateSquads(player2, sg_e_res_all, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_e_res_SCR_06, nil, 1, 2)
	Util_CreateSquads(player2, {sg_e_res_left, sg_e_res_all}, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_e_res_SCR_07, nil, 1, 2)
	Util_CreateSquads(player2, {sg_e_res_left, sg_e_res_all}, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_e_res_SCR_08, nil, 1, 3)
	Util_CreateSquads(player2, {sg_e_res_left, sg_e_res_all}, SBP.GERMAN.GRENADIER_SQUAD, mkr_e_res_SCR_09, nil, 1, 3, false, nil, UPG.GERMAN.GRENADIER_MG42_LMG)
	Util_CreateSquads(player2, sg_e_res_all, SBP.GERMAN.GRENADIER_SQUAD, mkr_e_res_SCR_10, nil, 1, 2)
	
	sg_e_how_def_hmg = SGroup_CreateIfNotFound("sg_e_how_def_hmg")
	
	Util_CreateSquads(player2, {sg_e_how_def_hmg, sg_e_how_def_01, sg_e_res_all}, SBP.GERMAN.M01_MG42_HEAVY_MACHINE_GUN_SQUAD_SINGLE, Util_GetOffsetPosition(mkr_e_res_how_def_HMG, OFFSET_BACK, 5))
	Cmd_Move(sg_e_how_def_hmg, mkr_e_res_how_def_HMG, false, nil, mkr_p4_allyFodder_spawn_02)
	Util_LogSyncWpn(sg_e_how_def_hmg)
	
	Rule_Add(_HOWITZER_Hmg_Firing)

end

function _HOWITZER_Hmg_Firing()

	sg_e_how_def_hmg_TARGET = SGroup_CreateIfNotFound("sg_e_how_def_hmg_TARGET")
	
	if SGroup_IsEmpty(sg_e_how_def_hmg) then Rule_RemoveMe() end
	
	if SGroup_IsDoingAttack(sg_e_how_def_hmg, ANY, 3) then
		Squad_GetAttackTargets(SGroup_GetSpawnedSquadAt(sg_e_how_def_hmg, 1), sg_e_how_def_hmg_TARGET)
		
		if Player_OwnsSGroup(player1, sg_e_how_def_hmg_TARGET, ANY) then
			Rule_RemoveMe()
			
			Util_StartIntel(EVENTS.HOWTIZER_01_HMG)
			
			Rule_AddOneShot(_HOWITZER_Hmg_MarkFlank, 10)
		end
	end

end

function _HOWITZER_Hmg_MarkFlank()

	if Prox_ArePlayersNearMarker(player1, mkr_res_hmg_flank_trig, ANY, nil) == false then
		hpid_res_hmg = HintPoint_Add(mkr_res_hmg_flank_hintPoint, true, 11036469)
		
		Event_Proximity(_HOWTIZER_Hmg_RemoveHintPoint, nil, player1, mkr_res_hmg_flank_hintPoint, nil, ANY)
	end

end

function _HOWTIZER_Hmg_RemoveHintPoint()

	if hpid_res_hmg ~= nil then HintPoint_Remove(hpid_res_hmg) end

end

function _HOWITZER_Encs_Def_01()

	sg_e_res_def_03 = SGroup_CreateIfNotFound("sg_e_res_def_03")
	sg_e_res_pickup_01 = SGroup_CreateIfNotFound("sg_e_res_pickup_01")
	
	local encData = {
		name = ("HOW_Enc_def_01"),
		player = player2,
		spawn = mkr_e_res_def_03,
		sgroups = {sg_e_res_all, sg_e_res_def_03},
		units = {
			{
				name = (""),
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				sgroups = {sg_e_res_pickup_01},
				spawn = mkr_e_res_def_03_s01,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				load = 3,
			},
			{
				name = (""),
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_e_res_def_03_s02,
				load = 4,
			},
			{
				name = (""),
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_e_res_def_03_s02,
				load = 3,
			},
			{
				name = (""),
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_e_res_def_03_s03,
				load = 2,
			},
		},
	}
	encID_res_def03 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_e_res_def_03,
		
		range = 20,
		leashRange = 10,
		
		fallback = {
			thresholds = {0.5},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_arty_e_retreat_02},
			retreat = true,
		},
		
		onFailure = _Kickoff_Bonus,
		onTransition = _Kickoff_Bonus,
		
		retaliateAttacks = false,
		
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_e_res_def_03, OFFSET_FRONT, 100),
		},
		
		abilityBlacklist = {
			ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY,
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = -1,
			},
		}
	}
	encID_res_def03:SetGoal(goalData)
	
	Rule_AddInterval(_HOWITZER_Enc_01_Retreating, 1)
	Rule_AddInterval(_HOWITZER_Enc_01_Track, 1)

end

function _HOWITZER_Enc_01_Retreating()
	
	if SGroup_IsEmpty(sg_e_res_pickup_01) then Rule_RemoveMe() return end
	
	if SGroup_IsRetreating(sg_e_res_pickup_01, ANY) then
		Rule_RemoveMe()
		
		SGroup_Kill(sg_e_res_pickup_01)
	end

end

function _HOWITZER_Enc_01_Track()
	
	if SGroup_IsEmpty(sg_e_res_pickup_01) then
		Rule_RemoveMe()
		
		eg_pickup = EGroup_CreateIfNotFound("eg_pickup")
		World_GetNeutralEntitiesNearPoint(eg_pickup, _enc01_loc, 50)
		
		EGroup_Filter(eg_pickup, BP_GetEntityBlueprint("axis_mg42"), FILTER_KEEP)
		
		if EGroup_IsEmpty(eg_pickup) == false then
			BeginnerHint_AddOpportunity(eg_pickup, HINT_PICKUP, false, 11046958, nil, nil, nil, true)	-- LOCDB [11046958] 'Infantry squads can pick up dropped weapons'
		end
	else
		_enc01_loc = Util_GetPosition(sg_e_res_pickup_01)
	end

end

function _HOWITZER_Encs_Def_02()

	sg_e_res_def_04 = SGroup_CreateIfNotFound("sg_e_res_def_04")
	sg_e_res_hmg = SGroup_CreateIfNotFound("sg_e_res_hmg")
	
	local encData = {
		name = ("HOW_Enc_def_01"),
		player = player2,
		spawn = mkr_e_res_def_04,
		sgroups = {sg_e_res_all, sg_e_res_def_04},
		units = {
			{
				name = (""),
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				load = 3,
			},
			{
				name = (""),
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				load = 4,
			},
			{
				name = (""),
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				sgroups = {sg_e_res_hmg},
				load = 4,
			},
		},
	}
	encID_res_def04 = Encounter:Create(encData)
	
	Util_LogSyncWpn(sg_e_res_hmg)
	
	local goalData = {
		name = "Defend",
		target = mkr_e_res_def_04,
		
		range = 20,
		leashRange = 10,
		
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_e_res_def_04, OFFSET_FRONT, 100),
		},
		
		retaliateAttacks = false,
		
		abilityBlacklist = {
			ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY,
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = -1,
			},
		}
	}
	encID_res_def04:SetGoal(goalData)

end

function _HOWITZER_Encs_Def_03()

	sg_e_res_def_05 = SGroup_CreateIfNotFound("sg_e_res_def_05")
	
	local encData = {
		name = ("HOW_Enc_def_01"),
		player = player2,
		spawn = mkr_e_res_def_05,
		sgroups = {sg_e_res_all, sg_e_res_def_05},
		units = {
			{
				name = (""),
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_e_res_def_05_s01,
				load = 3,
			},
			{
				name = (""),
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_e_res_def_05_s02,
				load = 4,
			},
			{
				name = (""),
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_e_res_def_05_s03,
				load = 2,
			},
		},
	}
	encID_res_def05 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_e_res_def_05,
		
		range = 15,
		leashRange = 9,
		
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_e_res_def_05, OFFSET_FRONT, 100),
		},
		
		retaliateAttacks = false,
		
		abilityBlacklist = {
			ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY,
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = -1,
			},
		}
	}
	encID_res_def05:SetGoal(goalData)

end


function _HOWITZER_Encs_How_Def_01()

	sg_e_how_def_01 = SGroup_CreateIfNotFound("sg_e_how_def_01")
	
	local encData = {
		name = ("HOW_def_02"),
		player = player2,
		spawn = mkr_e_res_how_def_01,
		sgroups = {sg_e_res_all, sg_e_how_def_01},
		units = {
			{
				name = (""),
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_e_res_how_def_01_s01,
				load = 3,
			},
			{
				name = (""),
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_e_res_how_def_01_s02,
				load = 4,
			},
			{
				name = (""),
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				load = 3,
			},
		},
	}
	encID_how_def01 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_e_res_how_def_01,
		
		range = 20,
		leashRange = 12,
		
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_e_res_how_def_01, OFFSET_FRONT, 100),
		},
		
		retaliateAttacks = false,
		
		abilityBlacklist = {
			ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY,
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = -1,
			},
		}
	}
	encID_how_def01:SetGoal(goalData)
	
	BeginnerHint_AddOpportunity(sg_e_how_def_01, ABILITY.SOVIET.RG_42_ANTI_PERSONNEL_GRENADE, true)

end

function _HOWITZER_Encs_How_Def_02()

	sg_e_how_def_02 = SGroup_CreateIfNotFound("sg_e_how_def_02")
	
	local encData = {
		name = ("HOW_def_01"),
		player = player2,
		spawn = mkr_e_res_how_def_02,
		sgroups = {sg_e_res_all, sg_e_how_def_02},
		units = {
			{
				name = (""),
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_e_res_how_def_02_s01,
				load = 3,
			},
			{
				name = (""),
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_e_res_how_def_02_s02,
				load = 4,
			},
			{
				name = (""),
				sbp = SBP.GERMAN.PIONEER_SQUAD,
				spawn = mkr_e_res_how_def_02_s03,
				load = 3,
			},
			{
				name = (""),
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				load = 3,
			},
		},
	}
	encID_how_def02 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_e_res_how_def_02,
		
		range = 20,
		leashRange = 12,
		
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_e_res_how_def_02, OFFSET_FRONT, 100),
		},
		
		retaliateAttacks = false,
		
		abilityBlacklist = {
			ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY,
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = -1,
			},
		}
	}
	encID_how_def02:SetGoal(goalData)
	
	BeginnerHint_AddOpportunity(sg_e_how_def_02, ABILITY.SOVIET.RG_42_ANTI_PERSONNEL_GRENADE, true)

end

-- Allies

-------------------------------------------------------------------------
-- PANZER GUN
-------------------------------------------------------------------------
--******
-- PANZER Objective
--******
function INIT_Panzer()

	OBJ_Panzer = {
		
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			Rule_AddOneShot(ATGUN_Delay_Start, 2)
		end,
		
		OnComplete = function()		
			if Rule_Exists(LESSON_Shock_Troop_Dispatch_Reminder) then Rule_Remove(LESSON_Shock_Troop_Dispatch_Reminder) end
			if Rule_Exists(_hmg_remove_shock_ping) then Rule_Remove(_hmg_remove_shock_ping) end
			
			-- Move up blockers
			Cmd_Move(sg_a_blocker_hmg_right, mkr_blocker_hmg_right_dest03, false, nil, Util_GetOffsetPosition(mkr_blocker_hmg_right_dest03, OFFSET_FRONT, 10))
			Cmd_Move(sg_a_blocker_com_right, mkr_blocker_commissar_right_dest03)
			Cmd_Move(sg_a_blocker_guard_right, mkr_blocker_guards_right_dest03)
			
			Cmd_Move(sg_a_blocker_hmg_center, mkr_blocker_hmg_center_dest03, false, nil, Util_GetOffsetPosition(mkr_blocker_hmg_center_dest03, OFFSET_FRONT, 10))
			Cmd_Move(sg_a_blocker_com_center, mkr_blocker_commissar_center_dest03)
			Cmd_Move(sg_a_blocker_guard_center, mkr_blocker_guards_center_dest03)
			
			Cmd_Move(sg_a_blocker_hmg_left, mkr_blocker_hmg_left_dest03, false, nil, Util_GetOffsetPosition(mkr_blocker_hmg_left_dest03, OFFSET_FRONT, 10))
			Cmd_Move(sg_a_blocker_com_left, mkr_blocker_commissar_left_dest03)
			Cmd_Move(sg_a_blocker_guard_left, mkr_blocker_guards_left_dest03)
			
			EGroup_InstantCaptureStrategicPoint(eg_panzer_cp, player1)
			
			Event_NarrativeEventsNotRunning(RAILSTATION_Init, nil, 1)
			
			Cmd_StaggeredRetreat(sg_e_p4_all, {mkr_rail_e_retreat_01, mkr_rail_e_retreat_02}, 3, true)
			if SGroup_IsEmpty(sg_e_res_all) == false then SGroup_Kill(sg_e_res_all) end
			
			if encID_p4_def01:IsAlive() then encID_p4_def01:Disable() Cmd_StaggeredRetreat(sg_e_p4_def_01, {mkr_rail_e_retreat_01, mkr_rail_e_retreat_02}, 3, true) end
			if encID_p4_def02:IsAlive() then encID_p4_def02:Disable() Cmd_StaggeredRetreat(sg_e_p4_def_02, {mkr_rail_e_retreat_01, mkr_rail_e_retreat_02}, 3, true) end
			
			if Event_Exists(eventID_smoke_01) then Event_Remove(eventID_smoke_01) end
			
			Rule_Remove(_allies_despawner)
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.PANZER_START,				
		Intel_Complete = EVENTS.PANZER_COMPLETE,			
		Intel_Fail = nil,				
		Title = 11036474,							-- LOCDB [11036466] 'Flank the HMG'
		Type = OT_Primary,				
	}
	
	Objective_Register(OBJ_Panzer)

end

function ATGUN_Init_Objective()

	SOBJ_ATGun = {
		
		SetupUI = function() 
			hpid_obj_AT = Objective_AddUIElements(SOBJ_ATGun, sg_e_at, true, 11040516, true, 3)
		end,
		
		OnStart = function()
			Event_GroupIsDead(_at_defeated, nil, sg_e_at, 1, true)
			
			Rule_AddInterval(PANZER_ATGun_Remind, 2*60)
		end,
		
		OnComplete = function()				
			Rule_AddOneShot(_panzer_Destroy_Panzer, 2)
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.ATGUN_START,				
		Intel_Complete = EVENTS.ATGUN_COMPLETE,			
		Intel_Fail = nil,				
		Title = 11040516,							-- LOCDB [11036466] 'Flank the HMG'
		Type = OT_Primary,	
		Parent = OBJ_Panzer,
	}
	
	Objective_Register(SOBJ_ATGun)

end

function ATGUN_Delay_Start() Objective_Start(SOBJ_ATGun) end

function PANZER_Complete()

	Objective_Complete(OBJ_Panzer)

end

function PANZER_ATGun_Remind()
	Util_StartIntel(EVENTS.INDUSTRIAL_REMIND_PAK)
	Rule_ChangeInterval(PANZER_ATGun_Remind, 3*60)
end

-- Encounter Functions
function PANZER_Init()
	
	-- Spawn the AT Gun
	sg_e_at = SGroup_CreateIfNotFound("sg_e_at")
	sg_p_at = SGroup_CreateIfNotFound("sg_p_at")
	eg_at = EGroup_CreateIfNotFound("eg_at")
	
	Util_CreateSquads(player2, sg_e_at, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_p4_at)
	
	-- Update allies
	PANZER_Allies_Init()
	
	-- Setup smoke tutorial
	SMOKE_Init()
	
	-- Encounters
	PANZER_Encounters_Init()
	
	-- Update Stuka
	_stuka_Area = mkr_p4_stuka_area
	
	-- Setup Ambient Artillery
	_tAmbArtillery = Marker_GetTable("mkr_p4_ambient_artillery_%02d")
	
	-- Spawn the fodder
	local pos = Util_FindHiddenSpawn(mkr_p4_allyFodder_spawn_01, mkr_p4_allyFodder_spawn_02)
--~ 	local hiddenPos = World_GetHiddenPositionOnPath(player1, Util_GetPosition(mkr_p4_allyFodder_spawn_01), Util_GetPosition(mkr_p4_allyFodder_spawn_02), CHECK_OFFCAMERA)
	
	if pos == nil then pos = mkr_p4_allyFodder_spawn_01 end
	
	Util_CreateSquads(player3, sg_p4_fodder, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, pos, Util_GetRandomPosition(mkr_p4_fodder_dest), 1, 3)
	Util_CreateSquads(player3, sg_p4_fodder, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, pos, Util_GetRandomPosition(mkr_p4_fodder_dest), 1, 4)
	Util_CreateSquads(player3, sg_p4_fodder, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, pos, Util_GetRandomPosition(mkr_p4_fodder_dest), 1, 2)
	Util_CreateSquads(player3, sg_p4_fodder, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, pos, Util_GetRandomPosition(mkr_p4_fodder_dest), 1, 3)
	Modify_Vulnerability(sg_p4_fodder, 0.5)
	SGroup_EnableUIDecorator(sg_p4_fodder, false)
	
	SGroup_SetInvulnerable(sg_p4_fodder, true)
	
end

function _panzer_spotted()

	Util_StartIntel(EVENTS.PANZER_SPOTTED)
	
	Cmd_Stop(sg_docks_allies_central)
	
	Rule_AddInterval(_panzer_Stopped, 1)
	
	Rule_AddInterval(_panzer_Attack_Fodder, 1)

end

function _panzer_Attack_Fodder()

	if Prox_AreSquadsNearMarker(sg_e_panzer, mkr_p4_e_panzer_dest_01, ANY, 5) then
		if SGroup_IsEmpty(sg_p4_fodder) == false then
			Rule_RemoveMe()
			
			Cmd_Attack(sg_e_panzer, sg_p4_fodder, true)
		end
	end

end

function _panzer_Stopped()

	if SGroup_IsMoving(sg_e_panzer, ANY) == false then
		Rule_RemoveMe()
		
		SGroup_SetInvulnerable(sg_p4_fodder, 0.25)
		
		Rule_AddOneShot(_panzer_retreat, 10)
	end

end

function _panzer_retreat()
	
	SGroup_SetInvulnerable(sg_p4_fodder, false)
	Rule_AddOneShot(_panzer_moveUp_Fodder, 4)
	
	Command_SquadMovePosFacing(player2, sg_e_panzer, Util_GetOffsetPosition(mkr_p4_e_panzer_dest_02, OFFSET_BACK, 6), Util_GetOffsetPosition(mkr_p4_e_panzer_dest_02, OFFSET_FRONT, 10), false, true)
	Cmd_Move(sg_e_panzer, mkr_p4_e_panzer_dest_02, true, false, Util_GetOffsetPosition(mkr_p4_e_panzer_dest_02, OFFSET_FRONT, 10))
	
	Modify_VehicleTurretRotationSpeed(sg_e_panzer, "hardpoint_01", 0.45)
	
	Rule_AddOneShot(_panzer_spawn_Scripted, 15)
	
	Event_Proximity(_panzer_fire, nil, sg_e_panzer, mkr_p4_e_panzer_dest_02, 5, ANY)
	
	Objective_Start(OBJ_Panzer)
	
	Event_Proximity(_panzer_spawnTruck, nil, sg_e_panzer, mkr_p4_e_panzer_dest_02, 5, ANY)

end

function _panzer_spawnTruck()
	sg_a_truck = SGroup_CreateIfNotFound("sg_a_truck")
end

function _panzer_moveUp_Fodder()

	Cmd_Move(sg_p4_fodder, mkr_p4_allies_right_dest_01)

end

function _panzer_fire()

	Rule_AddInterval(_panzer_fire_Foward, 10)

end

function _panzer_fire_Foward()
	if SGroup_IsEmpty(sg_e_panzer) then
		Rule_RemoveMe()
		return
	end
	
	local target = Util_GetRandomPosition(mkr_p4_allies_right_dest_01)
	
	Cmd_Stop(sg_e_panzer)
	Command_SquadPos(player1, sg_e_panzer, SCMD_StationaryAttack, target, false)

end

function _panzer_spawn_Scripted()
	
	-- Spawn the Scripted guys
	sg_p4_a_SCR_all = SGroup_CreateIfNotFound("sg_p4_a_SCR_all")
	sg_p4_a_SCR_01 = SGroup_CreateIfNotFound("sg_p4_a_SCR_01")
	sg_p4_a_SCR_02 = SGroup_CreateIfNotFound("sg_p4_a_SCR_02")
	sg_p4_a_SCR_03 = SGroup_CreateIfNotFound("sg_p4_a_SCR_03")
	sg_p4_a_SCR_04 = SGroup_CreateIfNotFound("sg_p4_a_SCR_04")
	sg_p4_a_SCR_05 = SGroup_CreateIfNotFound("sg_p4_a_SCR_05")
	
	Util_CreateSquads(player3, {sg_p4_a_SCR_all, sg_p4_a_SCR_01}, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_allies_right_spawn_01, mkr_p4_a_SCR_01, 1, 4)
	Util_CreateSquads(player3, {sg_p4_a_SCR_all, sg_p4_a_SCR_02}, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_allies_right_spawn_01, mkr_p4_a_SCR_02, 1, 2)
	Util_CreateSquads(player3, {sg_p4_a_SCR_all, sg_p4_a_SCR_03}, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_allies_right_spawn_01, mkr_p4_a_SCR_03, 1, 2)
	Util_CreateSquads(player3, {sg_p4_a_SCR_all, sg_p4_a_SCR_04}, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_allies_right_spawn_02, mkr_p4_a_SCR_04, 1, 3)
	Util_CreateSquads(player3, {sg_p4_a_SCR_all, sg_p4_a_SCR_05}, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_allies_right_spawn_02, mkr_p4_a_SCR_05, 1, 2)
	SGroup_SetInvulnerable(sg_p4_a_SCR_all, true)
	SGroup_EnableUIDecorator(sg_p4_a_SCR_all, false)

end

function PANZER_Allies_Init()
	
	_left_Allies_Dests = {mkr_docks_allies_left_dest_01, mkr_panzer_allies_left_dest_01, mkr_panzer_a_left_despawn}
	_left_Allies_despawn = mkr_panzer_a_left_despawn
	_left_Allies_AttackMove = true
	_left_Allies_Spawns = {mkr_ALLIES_left_spawn_panzer}
	
	local spawned = SGroup_CountSpawned(sg_docks_allies_left)
	local kill = nil
	if spawned > _left_Allies_Max then
		kill = (spawned - (_left_Allies_Max-5))
	end
	
	local __moveUp = function(gid, idx, sid)
		if kill == nil or kill == 0 then
			Cmd_Move(gid, Util_GetRandomPosition(_left_Allies_Dests[3]))
		elseif kill >= 1 then
			kill = kill-1
			Squad_Kill(sid)
		end
	end
	
	SGroup_ForEach(sg_docks_allies_left, __moveUp)
	
	_central_Allies_Max = 20
	
	_central_Allies_Dests = {mkr_docks_allies_center_dest_01, mkr_panzer_allies_center_dest_01, mkr_panzer_a_center_despawn}
	_central_Allies_despawn = mkr_panzer_a_center_despawn
	_central_Allies_AttackMove = true
	_central_Allies_Spawns = {mkr_ALLIES_central_spawn_panzer}
	
	local spawned = SGroup_CountSpawned(sg_docks_allies_central)
	local kill = nil
	if spawned > _central_Allies_Max then
		kill = (spawned - (_central_Allies_Max-4))
	end
	
	local __moveUp = function(gid, idx, sid)
		if kill == nil or kill == 0 then
			Cmd_Move(gid, Util_GetRandomPosition(_central_Allies_Dests[3]))
		elseif kill >= 1 then
			kill = kill-1
			Squad_Kill(sid)
		end
	end
	
	SGroup_ForEach(sg_docks_allies_central, __moveUp)
	
	_right_Allies_Max = 8
	
	_right_Allies_Spawns = Marker_GetTable("mkr_allies_right_spawn_%02d")
	_right_Allies_Dests = {mkr_p4_allies_right_dest_01}
	_right_Allies_despawn = nil
	_right_Allies_AttackMove = false
	
	local spawned = SGroup_CountSpawned(sg_docks_allies_right)
	local kill = nil
	if spawned > _right_Allies_Max then
		kill = (spawned - (_right_Allies_Max-5))
	end
	
	local __moveUp = function(gid, idx, sid)
		if kill == nil or kill == 0 then
			Cmd_Move(gid, Util_GetRandomPosition(_right_Allies_Dests[1]))
		elseif kill >= 1 then
			kill = kill-1
			Squad_Kill(sid)
		end
	end
	
	SGroup_ForEach(sg_docks_allies_right, __moveUp)

end

function _panzer_Destroy_Panzer()

	Util_StartIntel(EVENTS.DESTROY_PANZER)
	
--~ 	Event_Proximity(_panzer_vuln_tank, nil, sg_p_at, mkr_p4_vuln_trig, nil, ANY)
	Rule_Add(_panzer_vuln_tank)

end

function _panzer_vuln_tank()
	
	sg_checkP4 = SGroup_CreateIfNotFound("sg_checkP4")
	
	Squad_GetAttackTargets(SGroup_GetSpawnedSquadAt(sg_p_at, 1), sg_checkP4)
	SGroup_Filter(sg_checkP4, SBP.GERMAN.PANZER_IV_SQUAD, FILTER_KEEP)
	
	if SGroup_IsDoingAttack(sg_p_at, ANY, 3) and SGroup_IsEmpty(sg_checkP4) == false then
		Rule_RemoveMe()
		
		Objective_RemoveUIElements(OBJ_Panzer, hpid_p4_obj)
		
		Util_StartIntel(EVENTS.PANZER_REMIND)
		
		SGroup_SetInvulnerable(sg_e_panzer, false)
		Squad_SetInvulnerableMinCap(SGroup_GetSpawnedSquadAt(sg_e_panzer, 1), 0.99, -1)
		
		Rule_Add(_panzer_damaged)
	end

end

function _panzer_damaged()

	if SGroup_GetAvgHealth(sg_e_panzer) < 1 then
		Rule_RemoveMe()
		
		SGroup_SetSelectable(sg_p_at, false)
		
		
		
		Util_StartIntel(EVENTS.PANZER_DEFLECT)
		
		_panzer_health = SGroup_GetAvgHealth(sg_e_panzer)
		
		Player_RemoveUpgrade(player2, BP_GetUpgradeBlueprint("disable_vehicle_criticals"))
		
		Squad_SetInvulnerableMinCap(SGroup_GetSpawnedSquadAt(sg_e_panzer, 1), 0, 0)
		
		Rule_Add(_panzer_destroy)
	end

end

function _panzer_destroy()

	if SGroup_GetAvgHealth(sg_e_panzer) < _panzer_health then
		Rule_RemoveMe()
		
		Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 0)
		
		Scar_CompleteIntelBulletinTask(player1, "camp01_stalingrad_rail_german_engineering")
		
		SGroup_Kill(sg_e_panzer)
		
		local atGun = nil
		
		local _findAT = function(gid, idx, sid)
			local num = Squad_Count(sid)
			
			for i = 0, num do
				local eid = Entity_GetGameID(Squad_EntityAt(sid, i))
				if Entity_IsSyncWeapon(Entity_FromWorldID(eid)) then
					atGun = eid
					return
				end
			end
			
		end
		
		Modifier_Remove(_at_Pen_mod)
		Modifier_Remove(_at_Acc_mod)
		Modifier_Remove(_at_Rel_mod)
		
		SGroup_ForEach(sg_p_at, _findAT)
		Entity_SetAnimatorState(Entity_FromWorldID(atGun), "m01_custom_reload", "off")
		
		SGroup_SetInvulnerable(sg_p_at, false)
		Entity_SetInvulnerable(Entity_FromWorldID(atGun), true, -1)
		
		SGroup_SetSelectable(sg_p_at, true)
		
		EGroup_SetInvulnerable(LAYER_wall_vault, false)
		
		Rule_AddOneShot(PANZER_Complete, 2)
	end

end
-- Anti Tank Gun Functions
function _at_defeated()
	
	World_GetNeutralEntitiesNearMarker(eg_at, mkr_vault_check)
	EGroup_Filter(eg_at, EBP.GERMAN.PAK40_75MM_AT_GUN, FILTER_KEEP)
	EGroup_SetInvulnerable(eg_at, true)
	
	Util_StartIntel(EVENTS.PANZER_CAPTURE_AT)
	
	Event_NarrativeEventsNotRunning(_at_mark_vault, nil)

end

function _at_mark_vault()

	if Prox_ArePlayersNearMarker(player1, mkr_vault_check, ANY) == false then
		hpid_p4_vault = HintPoint_Add(EGroup_GetSpawnedEntityAt(LAYER_wall_vault, 3), true, 11040518, nil, HPAT_Vaulting)	-- LOCDB [11040518] 'RIGHT-CLICK to VAULT'
		Event_Proximity(_at_mark, nil, player1, mkr_vault_check, nil, ANY, 1.5)
	else
		_at_mark()
	end

end

function _at_mark()

	if hpid_p4_vault ~= nil then HintPoint_Remove(hpid_p4_vault) end
	
	hpid_obj_AT = Objective_AddUIElements(SOBJ_ATGun, eg_at, true, 11040516, true, 3)
	
	Rule_Add(_at_captured)

end

function _at_captured()

	Player_GetAllSquadsNearMarker(player1, sg_p_at, mkr_vault_check, 10)
	SGroup_Filter(sg_p_at, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, FILTER_KEEP)
	
	if SGroup_IsEmpty(sg_p_at) == false then
		Rule_RemoveMe()
		
		Rule_Remove(PANZER_ATGun_Remind)
		
		Rule_AddInterval(_at_setCustom_Reload, 1)
--~ 		SGroup_SetAnimatorState(sg_p_at, "m01_custom_reload", "on")
--~ 		SGroup_SetAnimatorState(sg_p_at, "antitankgun_state", "reload")
		SGroup_SetInvulnerable(sg_p_at, true)
		
		Rule_AddOneShot(at_modGun, 2)
		
		Objective_Complete(SOBJ_ATGun)
	end

end

function _at_setCustom_Reload()
	
	local atGun = nil
	
	local _findAT = function(gid, idx, sid)
		local num = Squad_Count(sid)
		
		for i = 0, num do
			local eid = Entity_GetGameID(Squad_EntityAt(sid, i))
			if Entity_IsSyncWeapon(Entity_FromWorldID(eid)) then
				atGun = eid
				Entity_SetAnimatorState(Entity_FromWorldID(atGun), "m01_custom_reload", "on")
				Rule_RemoveMe()
				return
			end
		end
		
	end
	
	if SGroup_HasTeamWeapon(sg_p_at, ANY) then SGroup_ForEach(sg_p_at, _findAT) end
	
end

function at_modGun()

	local _modPenetration = function(gid, idx, sid)
		for i = 1, Squad_Count(sid) do
			local eid = Squad_EntityAt(sid, i-1)
			
			if Entity_IsSyncWeapon(eid) then
				local modifier = Modifier_Create(MAT_Weapon, "modifiers\\weapon_penetration_modifier.lua", MUT_Multiplication, false, 5, "hardpoint_01")
				_at_Pen_mod = Modifier_ApplyToEntity(modifier, eid)
				
				local modifier = Modifier_Create(MAT_Weapon, "modifiers\\accuracy_weapon_modifier.lua", MUT_Multiplication, false, 5, "hardpoint_01")
				_at_Acc_mod = Modifier_ApplyToEntity(modifier, eid)
				
				local modifier = Modifier_Create(MAT_Weapon, "modifiers\\reload_weapon_modifier.lua", MUT_Multiplication, false, 4, "hardpoint_01")
				_at_Rel_mod = Modifier_ApplyToEntity(modifier, eid)
				return
			end
		end
	end
	
	SGroup_ForEach(sg_p_at, _modPenetration)

end
-- Smoke Grenade
function SMOKE_Init()

	_tSmokes = {
		{
			sg = SGroup_CreateIfNotFound("sg_p4_hmg_01"),
			trig = mkr_p4_hmg_01_trig,
			smoke = mkr_p4_hmg_01_smoke,
		},
	}
	
	eventID_smoke_01 = Event_Proximity(_smoke01, nil, player1, mkr_p4_hmg_01_trig, nil, ANY)
	
end

function _smoke01()
	
	if SGroup_IsEmpty(_tSmokes[1].sg) == false then
		Util_StartIntel(EVENTS.SMOKE_GRENADE_01)
		
		Event_NarrativeEventsNotRunning(_pingSmoke, nil, 1)
		
		Rule_AddOneShot(_smoke_StopFlash, 30)
		
		Rule_AddInterval(_smoke01_SmokeAway, 1)
	end

end

function _smoke_StopFlash()
	if fpid_smoke ~= nil then UI_StopFlashing(fpid_smoke) end
end

function _pingSmoke()
	hpid_smokeGren = UI_NewHUDFeature(HUDF_CommandCard, 11043338, "Icons_abilities_ability_soviet_rgd_1_smoke_grenade", 10)	-- LOCDB [11043338] 'Smoke Grenades temporarily block Line of Sight.'
end

function _smoke01_SmokeAway()
	
	eg_smoke = EGroup_CreateIfNotFound("eg_smoke")
	
	World_GetNeutralEntitiesNearMarker(eg_smoke, mkr_p4_hmg_01_smoke)
	
	EGroup_Filter(eg_smoke, BP_GetEntityBlueprint("smoke_cloud_grenade"), FILTER_KEEP)
	
	if EGroup_IsEmpty(eg_smoke) == false then
		Rule_RemoveMe()
		
		HintPoint_Remove(hpid_smokeGren)
		
		Cmd_Stop(_tSmokes[1].sg)
		
		Rule_Remove(_panzer_hmg_01_suppress)
		
		Rule_AddOneShot(_smoke01_Go, 1.5)
	end

end

function _smoke01_Go()
	
	HintPoint_Remove(hpid_smoke_grenade)
	
	Util_StartIntel(EVENTS.SMOKE_GRENADE_AWAY)

end

function _smoke01_clearFlank()

	HintPoint_Remove(hpid_smoke_flank)

end

--******
-- PANZER Encounters
--******
function PANZER_Encounters_Init()
	
	sg_e_p4_all = SGroup_CreateIfNotFound("sg_e_p4_all")
	
	Util_CreateSquads(player2, {sg_e_p4_all, _tSmokes[1].sg}, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, Util_GetOffsetPosition(mkr_p4_hmg_01, OFFSET_BACK, 5))
	Cmd_Move(_tSmokes[1].sg, mkr_p4_hmg_01, false, nil, Util_GetOffsetPosition(mkr_p4_hmg_01, OFFSET_FRONT, 10))
	Util_LogSyncWpn(_tSmokes[1].sg)
	
--~ 	BeginnerHint_AddOpportunity(_tSmokes[1].sg, ABILITY.SOVIET.RG_42_ANTI_PERSONNEL_GRENADE, true, 11046827, nil, nil, nil, true)		-- LOCDB [11046827] 'Throw your Grenades over the wall at this HMG'
	
	Rule_AddInterval(_panzer_hmg_01_suppress, 4)
	
	-- Encounters 
	_P4_Encs_Def_01()
	_P4_Encs_Def_02()
	
	-- Scripted
	sg_e_p4_all = SGroup_CreateIfNotFound("sg_e_p4_all")
	
	Util_CreateSquads(player2, sg_e_p4_all, SBP.GERMAN.GRENADIER_SQUAD, mkr_e_p4_SCR_01, nil, 1, 2)
	Util_CreateSquads(player2, sg_e_p4_all, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_e_p4_SCR_02, nil, 1, 5)
	Util_CreateSquads(player2, sg_e_p4_all, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_e_p4_SCR_03, nil, 1, 3)
	Util_CreateSquads(player2, sg_e_p4_all, SBP.GERMAN.GRENADIER_SQUAD, mkr_e_p4_SCR_04, nil, 1, 3, false, nil, UPG.GERMAN.GRENADIER_MG42_LMG)
	Util_CreateSquads(player2, sg_e_p4_all, SBP.GERMAN.GRENADIER_SQUAD, mkr_e_p4_SCR_05, nil, 1, 4)
	Util_CreateSquads(player2, sg_e_p4_all, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_e_p4_SCR_06, nil, 1, 3)
	Util_CreateSquads(player2, sg_e_p4_all, SBP.GERMAN.GRENADIER_SQUAD, mkr_e_p4_SCR_07, nil, 1, 3, false, nil, UPG.GERMAN.GRENADIER_MG42_LMG)
	Util_CreateSquads(player2, sg_e_p4_all, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_e_p4_SCR_08, nil, 1, 5)
	Util_CreateSquads(player2, sg_e_p4_all, SBP.GERMAN.GRENADIER_SQUAD, mkr_e_p4_SCR_09, nil, 1, 3, false, nil, UPG.GERMAN.GRENADIER_MG42_LMG)
	Util_CreateSquads(player2, sg_e_p4_all, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_e_p4_SCR_10, nil, 1, 4)
	
	Rule_AddInterval(_panzer_hmg_grenade_mark, 1)
	
end

function _panzer_hmg_grenade_mark()

	if SGroup_IsEmpty(_tSmokes[1].sg) then
		Rule_RemoveMe()
		return
	else
		if Prox_ArePlayersNearMarker(player1, mkr_p4_grenadeTrig, ANY) then
			Rule_RemoveMe()
			
			hpid_grenadeWall = HintPoint_Add(_tSmokes[1].sg, true, 11046827, 2, HPAT_Hint, "Icons_abilities_ability_soviet_rg_42_grenade")
			Rule_AddOneShot(_panzer_hmg_grenade_removeMark, 10)
		end
	end

end

function _panzer_hmg_grenade_removeMark()

	if hpid_grenadeWall ~= nil then HintPoint_Remove(hpid_grenadeWall) end

end

function _panzer_hmg_01_suppress()

	if SGroup_IsEmpty(_tSmokes[1].sg) == false then
		sg_allies_suppress = SGroup_CreateIfNotFound("sg_allies_suppress")
		Player_GetAllSquadsNearMarker(player3, sg_allies_suppress, mkr_p4_hmg_01_suppress)
		
		if SGroup_IsEmpty(sg_allies_suppress) == false then
			SGroup_SetSuppression(sg_allies_suppress, 1)
		end
		
		-- Player
		sg_player_suppress = SGroup_CreateIfNotFound("sg_player_suppress")
		
		Player_GetAllSquadsNearMarker(player1, sg_player_suppress, mkr_p4_hmg_01_suppress)
		
		if SGroup_IsEmpty(sg_player_suppress) == false then
			SGroup_SetSuppression(sg_player_suppress, 0.4)
		end
		
	else
		Rule_RemoveMe()
	end

end

function _P4_Encs_Def_01()
	
	sg_e_p4_def_01 = SGroup_CreateIfNotFound("sg_e_p4_def_01")
	
	local encData = {
		name = ("HMG_Enc_def_01"),
		player = player2,
		spawn = mkr_e_p4_def_01,
		sgroups = {sg_e_p4_def_01},
		units = {
			{
				name = (""),
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_e_p4_def_01_s01,
				load = 3,
			},
			{
				name = (""),
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_e_p4_def_01_s02,
				load = 4,
			},
			{
				name = (""),
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_e_p4_def_01_s03,
				load = 4,
			},
		},
	}
	encID_p4_def01 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_e_p4_def_01,
		
		range = 12,
		leashRange = 12,
		
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_e_p4_def_01, OFFSET_FRONT, 100),
		},
		
		retaliateAttacks = false,
		
		abilityBlacklist = {
			ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY,
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = -1,
			},
		}
	}
	encID_p4_def01:SetGoal(goalData)

end

function _P4_Encs_Def_02()
	
	sg_e_p4_def_02 = SGroup_CreateIfNotFound("sg_e_p4_def_02")
	
	local encData = {
		name = ("HMG_Enc_def_01"),
		player = player2,
		spawn = mkr_e_p4_def_02,
		sgroups = {sg_e_p4_def_02},
		units = {
			{
				name = (""),
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_e_p4_def_02_s01,
				load = 3,
			},
			{
				name = (""),
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_e_p4_def_02_s02,
				load = 3,
			},
			{
				name = (""),
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_e_p4_def_02_s03,
				load = 4,
			},
			{
				name = (""),
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_e_p4_def_02_s04,
				load = 2,
			},
		},
	}
	encID_p4_def02 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_e_p4_def_02,
		
		range = 12,
		leashRange = 12,
		
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_e_p4_def_02, OFFSET_FRONT, 100),
		},
		
		retaliateAttacks = false,
		
		abilityBlacklist = {
			ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY,
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = -1,
			},
		}
	}
	encID_p4_def02:SetGoal(goalData)

end

-------------------------------------------------------------------------
-- RAILSTATION
-------------------------------------------------------------------------
--******
-- RAILSTAION Objective
--******
function INIT_Railstation()

	OBJ_Railstation = {
		
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			World_IncreaseInteractionStage()
			
			Rule_Remove(_ambient_artillery)
			Rule_Remove(_ambient_stukas)
			
			Objective_Start(SOBJ_SouthLine)
			
			g_killed_infantry = 0
			
			-- HACK: Clear phantom MG42s 
			World_GetNeutralEntitiesNearPoint(eg_temp, Util_GetPosition(mkr_rail_e_south_B_hmg_01), 10)
			EGroup_Filter(eg_temp, EBP.GERMAN.MG42_HMG, FILTER_KEEP)
			EGroup_DestroyAllEntities(eg_temp)
			
			World_GetNeutralEntitiesNearPoint(eg_temp, Util_GetPosition(mkr_rail_e_south_A_hmg_01), 10)
			EGroup_Filter(eg_temp, EBP.GERMAN.MG42_HMG, FILTER_KEEP)
			EGroup_DestroyAllEntities(eg_temp)
		end,
		
		OnComplete = function()				
			if _calledInShockTroops == false then
				Scar_CompleteIntelBulletinTask(player1, "camp01_stalingrad_rail_soviet_zeal")
			end
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				
		Intel_Complete = EVENTS.RAILSTATION_COMPLETE,			
		Intel_Fail = nil,				
		Title = 11040523,							-- LOCDB [11036466] 'Flank the HMG'
		Type = OT_Primary,				
	}
	
	Objective_Register(OBJ_Railstation)

end

function SOUTHLINE_Init_Objective()

	SOBJ_SouthLine = {
		
		SetupUI = function() 
			hpid_obj_south_01 = Objective_AddUIElements(SOBJ_SouthLine, sg_e_rail_south_hmg_01, true, 11049767, true, 1)
			hpid_obj_south_02 = Objective_AddUIElements(SOBJ_SouthLine, sg_e_rail_south_hmg_02, true, 11049767, true, 1)
		end,
		
		OnStart = function()
			FOW_RevealArea(Util_GetPosition(sg_e_rail_south_hmg_01), 5, -1)
			FOW_RevealArea(Util_GetPosition(sg_e_rail_south_hmg_02), 5, -1)
			
			Rule_AddInterval(_railstation_south_complete_check, 1)
			
			Util_StartIntel(EVENTS.RAILSTATION_ATTACK)
			
			Rule_AddInterval(_railstation_hmg_down, 1)
		end,
		
		OnComplete = function()				
			Objective_RemoveUIElements(SOBJ_SouthLine, hpid_obj_south)
			
			if SGroup_IsEmpty(sg_e_rail_south_at) == false then Cmd_AbandonTeamWeapon(sg_e_rail_south_at, true) end
			
			if SGroup_IsEmpty(sg_e_rail_south) == false then
				Cmd_StaggeredRetreat(sg_e_rail_south, {mkr_rail_e_retreat_01, mkr_rail_e_retreat_02}, 4)
			end
			
			RAILSTATION_Allies_Init_B()
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.RAILSTATION_HMG_START,				
		Intel_Complete = nil,			
		Intel_Fail = nil,				
		Title = 11049767,							-- LOCDB [11049767] 'Eliminate the Heavy Machineguns'
		Type = OT_Primary,	
		Parent = OBJ_Railstation,
	}
	
	Objective_Register(SOBJ_SouthLine)

end

function NORTHLINE_Init_Objective()

	SOBJ_NorthLine = {
		
		SetupUI = function() 
			hpid_obj_north_01 = Objective_AddUIElements(SOBJ_SouthLine, sg_e_rail_north_stug_01, true, 11049768, true, 1)
		end,
		
		OnStart = function()
			FOW_RevealTerritory(player1, World_GetTerritorySectorID(Util_GetPosition(eg_railstation_cp)), -1, false)
			
			Cmd_Move(sg_e_rail_north_stug_01, mkr_rail_e_north_stug_01_dest, false, nil, Util_GetOffsetPosition(mkr_rail_e_north_stug_01_dest, OFFSET_FRONT, 6))
--~ 			Cmd_Move(sg_e_rail_north_stug_02, mkr_rail_e_north_stug_02_dest)
			
--~ 			RAILSTATION_Allies_Init_B()
			Util_StartIntel(EVENTS.NORTHLINE_START)
			
			Rule_AddInterval(_railstation_stug_remind, 1)
			
			local _count = SGroup_TotalMembersCount(sg_e_rail_north)
			Event_GroupLeftAlive(EventHandler_StartIntel, {intel_callback = EVENTS.RAILSTATION_LINE_BREAKING}, sg_e_rail_north, (_count-8))
			Rule_AddInterval(_railstation_north_complete_check, 1)
		end,
		
		OnComplete = function()				
			Rule_AddOneShot(RAILSTATION_Complete, 5)
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.RAILSTATION_STUG_START,				
		Intel_Complete = nil,			
		Intel_Fail = nil,				
		Title = 11049768,							-- LOCDB [11049768] 'Eliminate the Panzer IV'
		Type = OT_Primary,	
		Parent = OBJ_Railstation,
	}
	
	Objective_Register(SOBJ_NorthLine)

end

function RAILSTATION_Complete()
	
	Camera_MoveTo(mkr_mission_complete_camPan_02, true, 0.3, false, true)
	
	Game_SetMode(UI_Cinematic)
	Game_EnableInput(false)
	Camera_SetInputEnabled(false)
	
	SGroup_DeSpawn(sg_e_rail_north_garrissoned)
	g_finalBegin = true
	
	Player_GetAll(player1)
	SGroup_SetInvulnerable(sg_allsquads, true)
	Player_GetAll(player2)
	SGroup_SetInvulnerable(sg_allsquads, true)
	Player_GetAll(player3)
	SGroup_SetInvulnerable(sg_allsquads, true)
	
	Rule_AddOneShot(RAILSTATION_Start_Retreat, 2)

end

function RAILSTATION_Start_Retreat()

	Cmd_StaggeredRetreat(sg_e_rail_north, {mkr_rail_e_retreat_01, mkr_rail_e_retreat_02}, 3)
	Cmd_StaggeredRetreat(sg_e_rail_north_garrissoned, {mkr_rail_e_retreat_01, mkr_rail_e_retreat_02}, 3)
	
	Rule_AddOneShot(RAILSTATION_Fade_Out, 5)
	
end



function RAILSTATION_Fade_Out()

	Game_FadeToBlack(FADE_OUT, 5)
	Objective_Complete(OBJ_Railstation)
	Rule_AddOneShot(RAILSTATION_Complete_Delay, 6)

end

function RAILSTATION_Complete_Delay()
	
	Util_StartNIS(EVENTS.NIS04)

end

-- Encounter functions
function RAILSTATION_Init()
	
	if EGroup_IsEmpty(eg_railstation_center) == false then Entity_SetInvulnerable(EGroup_GetSpawnedEntityAt(eg_railstation_center, 1), true, -1) end
	if EGroup_IsEmpty(eg_railstation_center_left) == false then Entity_SetInvulnerable(EGroup_GetSpawnedEntityAt(eg_railstation_center_left, 1), true, -1) end
	if EGroup_IsEmpty(eg_railstation_center_right) == false then Entity_SetInvulnerable(EGroup_GetSpawnedEntityAt(eg_railstation_center_right, 1), true, -1) end
	if EGroup_IsEmpty(eg_railstation_right) == false then Entity_SetInvulnerable(EGroup_GetSpawnedEntityAt(eg_railstation_right, 1), true, -1) end
	
	Util_PlayMusic(g_music_railstation, 0, 3)
	
	
	Game_SetMode(UI_Cinematic)
	Game_FadeToBlack(FADE_OUT, 2.5)
	
	Rule_AddOneShot(RAILSTATION_Start_227, 2.6)

end

function RAILSTATION_Start_227()
	Util_StartNIS(EVENTS.NIS03)
	
	RAILSTATION_Encounters_Init()
	
	Objective_Start(OBJ_Railstation, false)
	
	EGroup_SetSelectable(eg_railstation_noGarrison, false)
	Event_NarrativeEventsNotRunning(RAILSTATION_Return_Control, nil, 3)
end

function RAILSTATION_Return_Control()
	Game_SetMode(UI_Normal)
	Camera_MoveTo(mkr_rail_p_atGun_warp, false, 1, false, true)
end
function _railstation_ping_oorah()
	
	Rule_AddInterval(_railstation_ping_oorah_check, 1)

end

function _railstation_ping_oorah_check()

	Player_GetAll(player1)
	
	if Misc_IsSGroupSelected(sg_allsquads, ANY) then
		Rule_RemoveMe()
		
		Util_NewHUDFeatureEvent(HUDF_CommandCard, 11046959, "Icons_abilities_ability_soviet_oorah", 10)	-- LOCDB [11046959] 'Use Oorah to increase your Conscripts' effectiveness'
		UI_FlashAbilityButton(ABILITY.SOVIET.CONSCRIPT_OORAH, true)
	end

end


function _railstation_south_complete_check()

	if SGroup_IsEmpty(sg_e_rail_south_hmg_01) and SGroup_IsEmpty(sg_e_rail_south_hmg_02) then
		Rule_RemoveMe()
		
		Objective_Complete(SOBJ_SouthLine, false)
		_railstation_attack_north()
	end

end

function _railstation_hmg_down()
	if SGroup_IsEmpty(sg_e_rail_south_hmg_01) or SGroup_IsEmpty(sg_e_rail_south_hmg_02) then
		Rule_RemoveMe()
		Util_StartIntel(EVENTS.RAILSTATION_ONE_HMG_DEAD)
	end
end

function _railstation_north_complete_check()
	if SGroup_IsEmpty(sg_e_rail_north_stug_01) then
		Rule_RemoveMe()
		
		Objective_Complete(SOBJ_NorthLine, false)
	end
end

function _railstation_callIn_More()

	Player_GetAll(player1)
	
	if SGroup_TotalMembersCount(sg_allsquads) < 10 then
		Rule_RemoveMe()
		Util_StartIntel(EVENTS.RAILSTATION_CALL_IN_MORE)
	end

end

function _railstation_attack_north()
	
	Objective_Complete(SOBJ_SouthLine, false)
	
	Event_NarrativeEventsNotRunning(EventHandler_ObjectiveStart, {objective = SOBJ_NorthLine})

end

function RAILSTATION_Allies_Init_A()
	
	_left_Allies_Max = 15
	
	_left_Allies_Spawns = Marker_GetTable("mkr_allies_rail_left_spawn_%02d")
	_left_Allies_Dests = {mkr_rail_allies_left_dest_01}
	_left_Allies_AttackMove = true
	
	local spawned = SGroup_CountSpawned(sg_docks_allies_left)
	local kill = nil
	if spawned > _left_Allies_Max then
		kill = (spawned - _left_Allies_Max)
	end
	
--~ 	local __moveUp = function(gid, idx, sid)
--~ 		if kill == nil or kill == 0 then
--~ 			Cmd_Move(gid, Util_GetRandomPosition(_left_Allies_Dests[1]))
--~ 		elseif kill >= 1 then
--~ 			kill = kill-1
--~ 			Squad_Kill(sid)
--~ 		end
--~ 	end
--~ 	
--~ 	SGroup_ForEach(sg_docks_allies_left, __moveUp)
	
	_central_Allies_Max = 15
	
	_central_Allies_Spawns = Marker_GetTable("mkr_allies_rail_center_spawn_%02d")
	_central_Allies_Dests = {mkr_rail_allies_center_dest_01}
	_central_Allies_AttackMove = true
	
	local spawned = SGroup_CountSpawned(sg_docks_allies_central)
	local kill = nil
	if spawned > _central_Allies_Max then
		kill = (spawned - _central_Allies_Max)
	end
	
--~ 	local __moveUp = function(gid, idx, sid)
--~ 		if kill == nil or kill == 0 then
--~ 			Cmd_Move(gid, Util_GetRandomPosition(_central_Allies_Dests[1]))
--~ 		elseif kill >= 1 then
--~ 			kill = kill-1
--~ 			Squad_Kill(sid)
--~ 		end
--~ 	end
--~ 	
--~ 	SGroup_ForEach(sg_docks_allies_central, __moveUp)
	
	_right_Allies_Max = 15
	
	_right_Allies_Spawns = Marker_GetTable("mkr_allies_rail_right_spawn_%02d")
	_right_Allies_Dests = {mkr_rail_allies_right_dest_01}
	_right_Allies_AttackMove = true
	
	local spawned = SGroup_CountSpawned(sg_docks_allies_right)
	local kill = nil
	if spawned > _right_Allies_Max then
		kill = (spawned - _right_Allies_Max)
	end
	
--~ 	local __moveUp = function(gid, idx, sid)
--~ 		if kill == nil or kill == 0 then
--~ 			Cmd_Move(gid, Util_GetRandomPosition(_right_Allies_Dests[1]))
--~ 		elseif kill >= 1 then
--~ 			kill = kill-1
--~ 			Squad_Kill(sid)
--~ 		end
--~ 	end
--~ 	
--~ 	SGroup_ForEach(sg_docks_allies_right, __moveUp)

end

function RAILSTATION_Allies_Init_B()

	_left_Allies_Dests = {mkr_rail_allies_left_dest_01, mkr_rail_allies_left_dest_02}
	
	local spawned = SGroup_CountSpawned(sg_docks_allies_left)
	local kill = nil
	if spawned > _left_Allies_Max then
		kill = (spawned - _left_Allies_Max)
	end
	
	local __moveUp = function(gid, idx, sid)
		if kill == nil or kill == 0 then
			Cmd_Move(gid, Util_GetRandomPosition(_left_Allies_Dests[2]))
		elseif kill >= 1 then
			kill = kill-1
			Squad_Kill(sid)
		end
	end
	
	SGroup_ForEach(sg_docks_allies_left, __moveUp)
	
	_central_Allies_Dests = {mkr_rail_allies_center_dest_01, mkr_rail_allies_center_dest_02}
	
	local spawned = SGroup_CountSpawned(sg_docks_allies_central)
	local kill = nil
	if spawned > _central_Allies_Max then
		kill = (spawned - _central_Allies_Max)
	end
	
	local __moveUp = function(gid, idx, sid)
		if kill == nil or kill == 0 then
			Cmd_Move(gid, Util_GetRandomPosition(_central_Allies_Dests[2]))
		elseif kill >= 1 then
			kill = kill-1
			Squad_Kill(sid)
		end
	end
	
	SGroup_ForEach(sg_docks_allies_central, __moveUp)
	
	_right_Allies_Dests = {mkr_rail_allies_right_dest_01, mkr_rail_allies_right_dest_02}
	
	local spawned = SGroup_CountSpawned(sg_docks_allies_right)
	local kill = nil
	if spawned > _right_Allies_Max then
		kill = (spawned - _right_Allies_Max)
	end
	
	local __moveUp = function(gid, idx, sid)
		if kill == nil or kill == 0 then
			Cmd_Move(gid, Util_GetRandomPosition(_right_Allies_Dests[2]))
		elseif kill >= 1 then
			kill = kill-1
			Squad_Kill(sid)
		end
	end
	
	SGroup_ForEach(sg_docks_allies_right, __moveUp)

end
--******
-- RAILSTATION Encounters
--******
function RAILSTATION_Encounters_Init()

	sg_e_rail_south = SGroup_CreateIfNotFound("sg_e_rail_south")
	sg_e_rail_south_hmg_01 = SGroup_CreateIfNotFound("sg_e_rail_south_hmg_01")
	sg_e_rail_south_hmg_02 = SGroup_CreateIfNotFound("sg_e_rail_south_hmg_02")
	sg_e_rail_south_A = SGroup_CreateIfNotFound("sg_e_rail_south_A")
	sg_e_rail_south_B = SGroup_CreateIfNotFound("sg_e_rail_south_B")
	sg_e_rail_south_C = SGroup_CreateIfNotFound("sg_e_rail_south_C")
	sg_e_rail_south_D = SGroup_CreateIfNotFound("sg_e_rail_south_D")
	sg_e_rail_south_at = SGroup_CreateIfNotFound("sg_e_rail_south_at")
	sg_e_rail_scout01 = SGroup_CreateIfNotFound("sg_e_rail_scout01")
	sg_e_rail_scout02 = SGroup_CreateIfNotFound("sg_e_rail_scout02")
	
	-- A
	Util_CreateSquads(player2, {sg_e_rail_south, sg_e_rail_south_hmg_01, sg_e_rail_south_A}, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_rail_e_south_A_hmg_01)
	Cmd_InstantSetupTeamWeapon(sg_e_rail_south_hmg_01)
	Modify_WeaponRange(sg_e_rail_south_hmg_01, "hardpoint_01", 0.8)
	Util_LogSyncWpn(sg_e_rail_south_hmg_01, true)
	
	Util_CreateSquads(player2, {sg_e_rail_south, sg_e_rail_south_A}, SBP.GERMAN.GRENADIER_SQUAD, mkr_rail_e_south_A_01, nil, 1, 3)
--~ 	Util_CreateSquads(player2, {sg_e_rail_south, sg_e_rail_south_A}, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_rail_e_south_A_02, nil, 1, 3)
	
	Util_CreateSquads(player2, {sg_e_rail_south, sg_e_rail_south_A, sg_e_rail_scout01}, SBP.GERMAN.SCOUTCAR_SDKFZ222, mkr_rail_e_south_scoutcar_01)
	
	-- B	
	Util_CreateSquads(player2, {sg_e_rail_south, sg_e_rail_south_hmg_02, sg_e_rail_south_B}, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_rail_e_south_B_hmg_01)
	Cmd_InstantSetupTeamWeapon(sg_e_rail_south_hmg_02)
	Util_LogSyncWpn(sg_e_rail_south_hmg_02, true)
	
	Util_CreateSquads(player2, {sg_e_rail_south, sg_e_rail_south_B, sg_e_rail_scout02}, SBP.GERMAN.SCOUTCAR_SDKFZ222, mkr_rail_e_south_scoutcar_02)
	
	Util_CreateSquads(player2, {sg_e_rail_south, sg_e_rail_south_B}, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_rail_e_south_B_01, nil, 1, 3)
--~ 	Util_CreateSquads(player2, {sg_e_rail_south, sg_e_rail_south_B}, SBP.GERMAN.GRENADIER_SQUAD, mkr_rail_e_south_B_02)
	
	-- C
	Util_CreateSquads(player2, {sg_e_rail_south, sg_e_rail_south_C, sg_e_rail_south_at}, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_rail_e_south_C_at_01)
	Util_CreateSquads(player2, {sg_e_rail_south, sg_e_rail_south_C}, SBP.GERMAN.GRENADIER_SQUAD, mkr_rail_e_south_C_01)
--~ 	Util_CreateSquads(player2, {sg_e_rail_south, sg_e_rail_south_C}, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_rail_e_south_C_02, nil, 1, 3)
	
	-- D
	Util_CreateSquads(player2, {sg_e_rail_south, sg_e_rail_south_D}, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_rail_e_south_D_01, nil, 1, 4)
--~ 	Util_CreateSquads(player2, {sg_e_rail_south, sg_e_rail_south_D}, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_rail_e_south_D_02, nil, 1, 3)
	
	-- Solo
--~ 	Util_CreateSquads(player2, sg_e_rail_south, SBP.GERMAN.GRENADIER_SQUAD, mkr_rail_e_south_01, nil, 1, 3)
	Util_CreateSquads(player2, sg_e_rail_south, SBP.GERMAN.GRENADIER_SQUAD, mkr_rail_e_south_02, nil, 1, 4, false, nil, UPG.GERMAN.GRENADIER_MG42_LMG)
	Util_CreateSquads(player2, sg_e_rail_south, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_rail_e_south_03)
	Util_CreateSquads(player2, sg_e_rail_south, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_rail_e_south_04, nil, 1, 3)
	Util_CreateSquads(player2, sg_e_rail_south, SBP.GERMAN.GRENADIER_SQUAD, mkr_rail_e_south_05, nil, 1, 4, false, nil, UPG.GERMAN.GRENADIER_MG42_LMG)
	
	Modify_ReceivedDamage(sg_e_rail_scout01, 2.5)
	Modify_ReceivedDamage(sg_e_rail_scout02, 2.5)
	
	RAILSTATION_Encounters_North()

end

function RAILSTATION_Encounters_North()

	sg_e_rail_north = SGroup_CreateIfNotFound("sg_e_rail_north")
	tsg_e_rail_north = SGroup_CreateTable("sg_e_rail_north_%02d", 6)
	sg_e_rail_north_stug_01 = SGroup_CreateIfNotFound("sg_e_rail_north_stug_01")
	sg_e_rail_north_stug_02 = SGroup_CreateIfNotFound("sg_e_rail_north_stug_02")
	sg_e_rail_north_garrissoned = SGroup_CreateIfNotFound("sg_e_rail_north_garrissoned")
	
	Util_CreateSquads(player2, sg_e_rail_north_stug_01, SBP.GERMAN.PANZER_IV_SQUAD, mkr_rail_e_north_stug_01)
	Cmd_Upgrade(sg_e_rail_north_stug_01, UPG.GERMAN.PANZER_TOP_GUNNER, 1, true)
	Modify_ReceivedDamage(sg_e_rail_north_stug_01, 2)
--~ 	Util_CreateSquads(player2, sg_e_rail_north_stug_02, SBP.GERMAN.STUG_III_E_SQUAD, mkr_rail_e_north_stug_02)
--~ 	Modify_ReceivedDamage(sg_e_rail_north_stug_02, 3)
	
	Util_CreateSquads(player2, {sg_e_rail_north, tsg_e_rail_north[1]}, SBP.GERMAN.GRENADIER_SQUAD, mkr_rail_e_north_01, nil, 1, 4, false, nil, UPG.GERMAN.GRENADIER_MG42_LMG)
	Util_CreateSquads(player2, {sg_e_rail_north, tsg_e_rail_north[2]}, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_rail_e_north_02, nil, 1, 4)
	Util_CreateSquads(player2, {sg_e_rail_north, tsg_e_rail_north[3]}, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_rail_e_north_03, nil, 1, 5)
	Util_CreateSquads(player2, {sg_e_rail_north, tsg_e_rail_north[4]}, SBP.GERMAN.GRENADIER_SQUAD, mkr_rail_e_north_04, nil, 1, 4)
	Util_CreateSquads(player2, {sg_e_rail_north, tsg_e_rail_north[5]}, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_rail_e_north_05, nil, 1, 5)
	Util_CreateSquads(player2, {sg_e_rail_north, tsg_e_rail_north[6]}, SBP.GERMAN.GRENADIER_SQUAD, mkr_rail_e_north_06, nil, 1, 4)
	
	Event_GroupIsDead(_respawnDefender, {sgroup = tsg_e_rail_north[1], sbp = SBP.GERMAN.GRENADIER_SQUAD, pos = mkr_rail_e_north_01}, tsg_e_rail_north[1], 3, false)
	Event_GroupIsDead(_respawnDefender, {sgroup = tsg_e_rail_north[2], sbp = SBP.GERMAN.GRENADIER_SQUAD, pos = mkr_rail_e_north_02}, tsg_e_rail_north[2], 3, false)
	Event_GroupIsDead(_respawnDefender, {sgroup = tsg_e_rail_north[3], sbp = SBP.GERMAN.GRENADIER_SQUAD, pos = mkr_rail_e_north_03}, tsg_e_rail_north[3], 3, false)
	Event_GroupIsDead(_respawnDefender, {sgroup = tsg_e_rail_north[4], sbp = SBP.GERMAN.GRENADIER_SQUAD, pos = mkr_rail_e_north_04}, tsg_e_rail_north[4], 3, false)
	Event_GroupIsDead(_respawnDefender, {sgroup = tsg_e_rail_north[5], sbp = SBP.GERMAN.GRENADIER_SQUAD, pos = mkr_rail_e_north_05}, tsg_e_rail_north[5], 3, false)
	Event_GroupIsDead(_respawnDefender, {sgroup = tsg_e_rail_north[6], sbp = SBP.GERMAN.GRENADIER_SQUAD, pos = mkr_rail_e_north_06}, tsg_e_rail_north[6], 3, false)
	
	if EGroup_Count(eg_railstation_center_left) >= 1 then
		Util_CreateSquads(player2, sg_e_rail_north_garrissoned, SBP.GERMAN.GRENADIER_SQUAD, eg_railstation_center_left, nil, 1, 4)
		Util_CreateSquads(player2, sg_e_rail_north_garrissoned, SBP.GERMAN.OSTRUPPEN_SQUAD, eg_railstation_center_left, nil, 1, 3)
	end
	if EGroup_Count(eg_railstation_center) >= 1 then
		Util_CreateSquads(player2, sg_e_rail_north_garrissoned, SBP.GERMAN.OSTRUPPEN_SQUAD, eg_railstation_center, nil, 1, 5)
	end
	if EGroup_Count(eg_railstation_center_right) >= 1 then
		Util_CreateSquads(player2, sg_e_rail_north_garrissoned, SBP.GERMAN.OSTRUPPEN_SQUAD, eg_railstation_center_right, nil, 1, 3)
	end
	if EGroup_Count(eg_railstation_right) >= 1 then
		Util_CreateSquads(player2, sg_e_rail_north_garrissoned, SBP.GERMAN.GRENADIER_SQUAD, eg_railstation_right, nil, 1, 4)
	end
	
	Modify_WeaponDamage(sg_e_rail_north_garrissoned, "hardpoint_01", 0)

end

function _respawnDefender(data_table)
	if g_finalBegin == nil then
		local spawn = nil
		local sgroup = nil
		
		Util_CreateSquads(player2, {sg_e_rail_north, data_table.sgroup}, data_table.sbp, eg_railstation_center, nil, 1, World_GetRand(3, 5))
		Cmd_UngarrisonSquad(data_table.sgroup, data_table.pos)
		local t = {sgroup = data_table.sgroup, sbp = data_table.sbp, pos = data_table.pos}
		Event_GroupIsDead(_respawnDefender, t, data_table.sgroup, 3, false)
		
		g_killed_infantry = g_killed_infantry + 1
	end
end

function _railstation_stug_remind()
	if g_killed_infantry >= 4 then
		
		Util_StartIntel(EVENTS.RAILSTATION_STUG_REMIND)
		g_killed_infantry = 0
	end
end

-------------------------
-- BONUS OBJECTIVE
-- RESCUE TRAPPED SQUADS
-------------------------
-- || INIT FUNCTIONS ||
function BONUS_Init_Objective()

	OBJ_Bonus = {
		
		SetupUI = function() 
			hpid_bonus_building = Objective_AddUIElements(OBJ_Bonus, eg_bonus_building, true, 11040525, true, 5)	-- LOCDB [11040525] 'Rescue the trapped civilians'
		end,
		
		OnStart = function()
			Objective_Start(SOBJ_Bonus_Loss, false)
			Objective_Start(SOBJ_Bonus_Win, false)
			
			Sound_PreCacheSound("speech/sp/mission/m01/ambient/building_exit")
		end,
		
		OnComplete = function()			
			-- Move up blockers
			Cmd_Move(sg_a_blocker_hmg_left, mkr_blocker_hmg_left_dest02, false, nil, Util_GetOffsetPosition(mkr_blocker_hmg_left_dest02, OFFSET_FRONT, 10))
			Cmd_Move(sg_a_blocker_com_left, mkr_blocker_commissar_left_dest02)
			Cmd_Move(sg_a_blocker_guard_left, mkr_blocker_guards_left_dest02)
			
			sg_bonus_a_civ_01 = SGroup_CreateIfNotFound("sg_bonus_a_civ_01")
			
			Util_CreateSquads(player4, sg_bonus_a_civ_01, BP_GetSquadBlueprint("m02_refugee_squad"), eg_bonus_building)
			Cmd_UngarrisonSquad(sg_bonus_a_civ_01, Util_GetOffsetPosition(mkr_bonus_e_dest_01, OFFSET_RIGHT, 7))
			SGroup_EnableUIDecorator(sg_bonus_a_civ_01, false)
			
			sg_bonus_a_civ_02 = SGroup_CreateIfNotFound("sg_bonus_a_civ_02")
			
			Util_CreateSquads(player4, sg_bonus_a_civ_02, BP_GetSquadBlueprint("m02_refugee_squad"), eg_bonus_building, nil, 1, 4)
			Cmd_UngarrisonSquad(sg_bonus_a_civ_02, Util_GetOffsetPosition(mkr_bonus_e_dest_01, OFFSET_LEFT, 10))
			SGroup_EnableUIDecorator(sg_bonus_a_civ_02, false)
			
			if not SGroup_IsEmpty(sg_bonus_a_all) then
				local squad = SGroup_GetSpawnedSquadAt(sg_bonus_a_all, 1)
				Sound_Play3D("speech/sp/mission/m01/ambient/building_exit", Squad_EntityAt(squad, 0))
			end
			
			EGroup_SetSelectable(eg_bonus_building, true)
			
			Rule_AddOneShot(_BonusObjective_MoveOut, 3)
			
			Modify_ReceivedSuppression(sg_bonus_a_civ_01, 0.01)
			Modify_ReceivedSuppression(sg_bonus_a_civ_02, 0.01)
			
			SGroup_SetInvulnerable(sg_bonus_a_civ_01, true)
			SGroup_SetInvulnerable(sg_bonus_a_civ_02, true)
			-- Move up Blockers
--~ 			Cmd_Move(sg_a_blocker_03_hmg, mkr_a_blocker_03_hmg_dest_02)
--~ 			Cmd_Move(sg_a_blocker_03_officer, mkr_a_blocker_03_officer_dest_02)
		end,
		
		OnFail = function()
			-- Move up blockers
			Cmd_Move(sg_a_blocker_hmg_left, mkr_blocker_hmg_left_dest02, false, nil, Util_GetOffsetPosition(mkr_blocker_hmg_left_dest02, OFFSET_FRONT, 10))
			Cmd_Move(sg_a_blocker_com_left, mkr_blocker_commissar_left_dest02)
			Cmd_Move(sg_a_blocker_guard_left, mkr_blocker_guards_left_dest02)
			
			if encID_res_def01:IsAlive() then encID_res_def01:Disable() Cmd_StaggeredRetreat(sg_e_res_def_01, {mkr_e_left_RETREAT}, 3, true) end
			if encID_res_def05:IsAlive() then encID_res_def05:Disable() Cmd_StaggeredRetreat(sg_e_res_def_05, {mkr_e_left_RETREAT}, 3, true) end
			if SGroup_IsEmpty(sg_e_res_left) == false then Cmd_StaggeredRetreat(sg_e_res_left, {mkr_e_left_RETREAT}, 3, true) end
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.BONUS_START,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = EVENTS.BONUS_LOSS,				-- Event will play when obj fails but before UI is cleared
		Title = 11040525,				-- Objective Title
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary, OT_Medal)
	}
	
	Objective_Register(OBJ_Bonus)
	
	SOBJ_Bonus_Loss = {
		
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			Objective_SetCounter(SOBJ_Bonus_Loss, 15)
			
			_bonusObj_firstWarning = false
			_bonusObj_secondWarning = false
			
			Rule_AddOneShot(_BonusObjective_StartTimer, t_difficulty.bonus_initial_delay)
			Rule_Add(_BonusObjective_CiviliansRescued)
		end,
		
		OnComplete = function()
			
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11040528,				-- LOCDB [11040528] 'Defending soldiers left:'
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary, OT_Medal)
		Parent = OBJ_Bonus,
	}
	
	Objective_Register(SOBJ_Bonus_Loss)
	
	SOBJ_Bonus_Win = {
		
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			
		end,
		
		OnComplete = function()
			
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11040529,				-- LOCDB [11040529] 'Defeat soldiers around the building'
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary, OT_Medal)
		Parent = OBJ_Bonus,
	}
	
	Objective_Register(SOBJ_Bonus_Win)

end
-- || OBJECTIVE FUNCTIONS ||
function BONUS_Delay_Trigger()

	eventID_bonus_center = Event_GroupIsDead(_BonusObjective_Init, nil, sg_e_res_def_03, 0, true)
	eventID_bonus_trig = Event_Proximity(_BonusObjective_Init, nil, player1, {mkr_bonus_trig_01, mkr_bonus_trig_02, mkr_bonus_trig_03}, nil, ANY)

end
-- || BEAT FUNCTIONS ||
function _BonusObjective_Init()
	
	if Event_Exists(eventID_bonus_center) then Event_Remove(eventID_bonus_center) end
	if Event_Exists(eventID_bonus_trig) then Event_Remove(eventID_bonus_trig) end
	
	Objective_Start(OBJ_Bonus)
	
	_forceBonusFail = false
	
	Rule_AddDelayedInterval(BONUS_Encounters_Init, 1.5, 1)

end

function _BonusObjective_Timer()
	
	if SGroup_TotalMembersCount(sg_bonus_e_01) <= 0 and SGroup_TotalMembersCount(sg_bonus_e_02) <= 0 then
		Rule_RemoveMe()
		return
	end
	
	if _forceBonusFail == true then
		Rule_RemoveMe()
		Rule_Remove(_BonusObjective_CiviliansRescued)
		
		Cmd_Retreat(sg_bonus_e_01, mkr_bonus_e_spawn_02, mkr_bonus_e_spawn_02)
		Cmd_Retreat(sg_bonus_e_02, mkr_bonus_e_spawn_02, mkr_bonus_e_spawn_02)
		
		Objective_SetCounter(SOBJ_Bonus_Loss, 0)
		
		Objective_Fail(OBJ_Bonus, true)
		return
	end
	
	if Timer_Exists(tmr_bonus) then
--~ 		print(Timer_GetRemaining(tmr_bonus))
		if Timer_GetRemaining(tmr_bonus) <= 0 and SGroup_IsUnderAttack(sg_bonus_a_all, ANY, 3) then
			
			local sid = SGroup_GetRandomSpawnedSquad(sg_bonus_a_all)
			
			local count = Squad_Count(sid)
			
			local index = World_GetRand(1, count)
			
			local eid = Squad_EntityAt(sid, (index-1))
			
			Entity_Kill(eid)
			
			-- Update the Counter
			
			Objective_SetCounter(SOBJ_Bonus_Loss, SGroup_TotalMembersCount(sg_bonus_a_all))
			
			Timer_End(tmr_bonus)
			
		end	
		
	elseif Timer_Exists(tmr_bonus) == false then
		
		if SGroup_TotalMembersCount(sg_bonus_a_all) <= 10 and _bonusObj_firstWarning == false then
			if Event_IsAnyRunning() == false then
				Util_StartIntel(EVENTS.BONUS_WARNING_01)
				_bonusObj_firstWarning = true
			end
		end
		
		if SGroup_TotalMembersCount(sg_bonus_a_all) <= 6 and _bonusObj_secondWarning == false then
			if Event_IsAnyRunning() == false then
				Util_StartIntel(EVENTS.BONUS_WARNING_02)
				_bonusObj_secondWarning = true
			end
		end
		
		if SGroup_TotalMembersCount(sg_bonus_a_all) <= 0 then
			Rule_RemoveMe()
			Rule_Remove(_BonusObjective_CiviliansRescued)
			
			Cmd_Retreat(sg_bonus_e_01, mkr_bonus_e_retreat, mkr_bonus_e_retreat)
			Cmd_Retreat(sg_bonus_e_02, mkr_bonus_e_retreat, mkr_bonus_e_retreat)
			
			Objective_Fail(OBJ_Bonus)
			return
		end
		
		Timer_Start(tmr_bonus, t_difficulty.death_rate)
		
	end
	
end

function _BonusObjective_StartTimer()

	tmr_bonus = "tmr_bonus"
	Timer_Start(tmr_bonus, t_difficulty.death_rate)
	
	Rule_AddInterval(_BonusObjective_Timer, 1)

end

function _BonusObjective_CiviliansRescued()

	if (SGroup_TotalMembersCount(sg_bonus_e_01) <= 0 and SGroup_TotalMembersCount(sg_bonus_e_02) <= 0)
	  or SGroup_IsRetreating(sg_bonus_e_all, ALL) then
		Rule_RemoveMe()
		
		Scar_CompleteIntelBulletinTask(player1, "camp01_stalingrad_rail_rescue_civilians")
		
		Objective_Complete(SOBJ_Bonus_Loss, false, true)
		Objective_Complete(SOBJ_Bonus_Win, false, true)
		
		if Timer_Exists(tmr_bonus) then Timer_End(tmr_bonus) end
		if Rule_Exists(_BonusObjective_Timer) then Rule_Remove(_BonusObjective_Timer) end
		
		EGroup_SetSelectable(eg_bonus_building, false)
		
		Rule_AddOneShot(_BonusObjective_Complete_Delay, 2)
	end

end

function _BonusObjective_Complete_Delay()

	-- Eject the Defenders
	Cmd_UngarrisonSquad(sg_bonus_a_all, mkr_bonus_e_dest_01)
	
	if encID_res_def01:IsAlive() then encID_res_def01:Disable() Cmd_StaggeredRetreat(sg_e_res_def_01, {mkr_e_left_RETREAT}, 3, true) end
	if encID_res_def05:IsAlive() then encID_res_def05:Disable() Cmd_StaggeredRetreat(sg_e_res_def_05, {mkr_e_left_RETREAT}, 3, true) end
	if SGroup_IsEmpty(sg_e_res_left) == false then Cmd_StaggeredRetreat(sg_e_res_left, {mkr_e_left_RETREAT}, 3, true) end
	
	Rule_AddOneShot(_BonusObjective_KillEnemies, 4)
	
	if SGroup_TotalMembersCount(sg_bonus_a_all) > 10 then
		Util_StartIntel(EVENTS.BONUS_COMPLETE_GOOD)
	elseif SGroup_TotalMembersCount(sg_bonus_a_all) > 6 and SGroup_TotalMembersCount(sg_bonus_a_all) <= 10 then
		Util_StartIntel(EVENTS.BONUS_FAIR)
	elseif SGroup_TotalMembersCount(sg_bonus_a_all) <= 6 then
		Util_StartIntel(EVENTS.BONUS_POOR)
	end
	
	Rule_AddDelayedInterval(_BonusObjective_Complete_Finish, 1.5, 1)
--~ 	Objective_Complete(OBJ_Bonus)

end

function _BonusObjective_KillEnemies()

	if SGroup_IsEmpty(sg_e_res_def_01) then
		local _delete = function(gid, idx, sid)
			if Squad_IsRetreating(sid) == false then
				Squad_Kill(sid)
			end
		end
		
		SGroup_ForEach(sg_e_res_def_01, _delete)
	end
	
	if SGroup_IsEmpty(sg_e_res_def_05) then
		local _delete = function(gid, idx, sid)
			if Squad_IsRetreating(sid) == false then
				Squad_Kill(sid)
			end
		end
		
		SGroup_ForEach(sg_e_res_def_05, _delete)
	end
	
	if SGroup_IsEmpty(sg_e_res_left) then
		local _delete = function(gid, idx, sid)
			if Squad_IsRetreating(sid) == false then
				Squad_Kill(sid)
			end
		end
		
		SGroup_ForEach(sg_e_res_left, _delete)
	end

end

function _BonusObjective_Complete_Finish() 

	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		
		Objective_Complete(OBJ_Bonus)
	end

end

function _BonusObjective_MoveOut()
	if SGroup_Exists("sg_bonus_a_all") and not SGroup_IsEmpty(sg_bonus_a_all) then
		Cmd_MoveToAndDespawn(sg_bonus_a_all, mkr_docks_allies_left_spawn_02)
	end
	if SGroup_Exists("sg_bonus_a_civ_01") and not SGroup_IsEmpty(sg_bonus_a_civ_01) then
		Cmd_MoveToAndDespawn(sg_bonus_a_civ_01, mkr_docks_allies_left_spawn_02)
	end
	if SGroup_Exists("sg_bonus_a_civ_02") and not SGroup_IsEmpty(sg_bonus_a_civ_02) then
		Cmd_MoveToAndDespawn(sg_bonus_a_civ_02, mkr_docks_allies_left_spawn_02)
	end
end

function _BonusObjective_Retreat_Enemies()
	if SGroup_Exists("sg_bonus_e_all") and not SGroup_IsEmpty(sg_bonus_e_all) then
		Cmd_Retreat(sg_bonus_e_all, mkr_arty_e_retreat_02, mkr_arty_e_retreat_02)
	end
end

-- || Beat Encounters ||
function BONUS_Encounters_Init()
	
	if Objective_IsStarted(OBJ_Bonus) then
		Rule_RemoveMe()
		
		World_IncreaseInteractionStage()
		
		sg_bonus_e_all = SGroup_CreateIfNotFound("sg_bonus_e_all")
		
		BONUS_Enemy_01()
		BONUS_Enemy_02()
		
		EGroup_SetSelectable(eg_bonus_building, true)
		
		-- Spawn the units
		sg_bonus_a_all = SGroup_CreateIfNotFound("sg_bonus_a_all")
		
		Util_CreateSquads(player3, sg_bonus_a_all, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, eg_bonus_building)
		Util_CreateSquads(player3, sg_bonus_a_all, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, eg_bonus_building)
		Util_CreateSquads(player3, sg_bonus_a_all, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, eg_bonus_building)
		
		Modify_WeaponDamage(sg_bonus_a_all, "hardpoint_01", 0)
		
		EGroup_EnableUIDecorator(eg_bonus_building, false)
		
		SGroup_SetInvulnerable(sg_bonus_a_all, true)
		
		Event_GroupLeftAlive(_BonusObjective_Retreat_Enemies, nil, sg_bonus_e_all, 3)
	end

end

function BONUS_Enemy_01()

	sg_bonus_e_01 = SGroup_CreateIfNotFound("sg_bonus_e_01")
	
	Util_CreateSquads(player2, {sg_bonus_e_all, sg_bonus_e_01}, SBP.GERMAN.GRENADIER_SQUAD, mkr_bonus_def_01_s01, nil, 1, 4, false, nil, UPG.GERMAN.GRENADIER_MG42_LMG)
	Util_CreateSquads(player2, {sg_bonus_e_all, sg_bonus_e_01}, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_bonus_def_01_s02, nil, 1, 5)
	Util_CreateSquads(player2, {sg_bonus_e_all, sg_bonus_e_01}, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_bonus_def_01_s03, nil, 1, 4)
	Util_CreateSquads(player2, {sg_bonus_e_all, sg_bonus_e_01}, SBP.GERMAN.GRENADIER_SQUAD, mkr_bonus_def_01_s04, nil, 1, 4)
	Util_CreateSquads(player2, {sg_bonus_e_all, sg_bonus_e_01}, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_bonus_def_01_s05, nil, 1, 4)

end

function BONUS_Enemy_02()

	sg_bonus_e_02 = SGroup_CreateIfNotFound("sg_bonus_e_02")
	
	Util_CreateSquads(player2, {sg_bonus_e_all, sg_bonus_e_02}, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_bonus_def_02_s01, nil, 1, 4)
	Util_CreateSquads(player2, {sg_bonus_e_all, sg_bonus_e_02}, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_bonus_def_02_s02, nil, 1, 5)
	Util_CreateSquads(player2, {sg_bonus_e_all, sg_bonus_e_02}, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_bonus_def_02_s03, nil, 1, 5)
	Util_CreateSquads(player2, {sg_bonus_e_all, sg_bonus_e_02}, SBP.GERMAN.GRENADIER_SQUAD, mkr_bonus_def_02_s04, nil, 1, 3)

end


-- AMBIENT STUFF
function Medics_Init()

	-- Spawn Docks Medics
	sg_a_docks_medics = SGroup_CreateIfNotFound("sg_a_docks_medics")
	sg_a_docks_medics_01 = SGroup_CreateIfNotFound("sg_a_docks_medics_01")
	sg_a_docks_medics_02 = SGroup_CreateIfNotFound("sg_a_docks_medics_02")
	sg_a_docks_medics_03 = SGroup_CreateIfNotFound("sg_a_docks_medics_03")
	sg_a_docks_medics_04 = SGroup_CreateIfNotFound("sg_a_docks_medics_04")
	
	_medic01_target = eg_wounded_01 
	_medic02_target = eg_wounded_05 
	
	Util_CreateSquads(player3, {sg_a_docks_medics, sg_a_docks_medics_01}, SBP.SOVIET.M01_MEDIC, mkr_docks_medic_01, nil, 1, 1)
	Util_CreateSquads(player3, {sg_a_docks_medics, sg_a_docks_medics_02}, SBP.SOVIET.M01_MEDIC, mkr_docks_medic_02, nil, 1, 1)
	Util_CreateSquads(player3, {sg_a_docks_medics, sg_a_docks_medics_03}, SBP.SOVIET.M01_MEDIC, mkr_docks_medic_03, nil, 1, 1)
	Util_CreateSquads(player3, {sg_a_docks_medics, sg_a_docks_medics_04}, SBP.SOVIET.M01_MEDIC, mkr_docks_medic_04, nil, 1, 1)
	SGroup_SetInvulnerable(sg_a_docks_medics, true)
	SGroup_SetSelectable(sg_a_docks_medics, false)
	SGroup_EnableUIDecorator(sg_a_docks_medics, false)
	SGroup_EnableMinimapIndicator(sg_a_docks_medics, false)
	
	tmkr_spawns = Marker_GetTable("mkr_docks_medic_wounded_%02d")
	tsg_wounded = SGroup_CreateTable("sg_a_wounded_%02d", table.getn(tmkr_spawns))
	
	for i = 1, table.getn(tsg_wounded) do
		Util_CreateSquads(player3, tsg_wounded[i], BP_GetSquadBlueprint("m01_conscript_squad_wounded"), tmkr_spawns[i], nil, 1, 1, false, Util_GetOffsetPosition(tmkr_spawns[i], OFFSET_FRONT, 5))
		SGroup_SetInvulnerable(tsg_wounded[i], true)
		SGroup_EnableMinimapIndicator(tsg_wounded[i], false)
		SGroup_SetSelectable(tsg_wounded[i], false)
	end
	_medics_work()
	
	sg_a_docks_medic_03_wounded = SGroup_CreateIfNotFound("sg_a_docks_medic_03_wounded")
	sg_a_docks_medic_04_wounded = SGroup_CreateIfNotFound("sg_a_docks_medic_04_wounded")
	Util_CreateSquads(player3, sg_a_docks_medic_03_wounded, BP_GetSquadBlueprint("m01_conscript_squad_wounded"), mkr_docks_medic_03_wounded, nil, 1, 1, false, Util_GetOffsetPosition(mkr_docks_medic_03_wounded, OFFSET_FRONT, 5))
	Util_CreateSquads(player3, sg_a_docks_medic_04_wounded, BP_GetSquadBlueprint("m01_conscript_squad_wounded"), mkr_docks_medic_04_wounded, nil, 1, 1, false, Util_GetOffsetPosition(mkr_docks_medic_04_wounded, OFFSET_FRONT, 5))
	Cmd_Ability(sg_a_docks_medics_03, BP_GetAbilityBlueprint("m01_medic_heal_constant"), sg_a_docks_medic_03_wounded)
	Cmd_Ability(sg_a_docks_medics_04, BP_GetAbilityBlueprint("m01_medic_heal_constant"), sg_a_docks_medic_04_wounded)
	SGroup_SetSelectable(sg_a_docks_medic_03_wounded, false)
	SGroup_SetSelectable(sg_a_docks_medic_04_wounded, false)

end

function _medics_work()
	_medic_wounded = tsg_wounded
	_medic_being_treated = {}
	
	_medic_01_Ability()
	Rule_AddOneShot(_medic_02_Ability, 1)
end
-- Medic 01
function _medic_01_Ability()
	local size = table.getn(_medic_wounded)
	local id = World_GetRand(1, size)
	if SGroup_IsEmpty(_medic_wounded[id]) then table.remove(_medic_wounded, id) if Rule_Exists(_medic_01_Ability) == false then Rule_AddOneShot(_medic_01_Ability, 1) end return end
	_medic01_target = _medic_wounded[id]
	
	table.insert(_medic_being_treated, _medic01_target)
	table.remove(_medic_wounded, id)
	
	_medic01_target_pos = Util_GetOffsetPosition(_medic01_target, OFFSET_LEFT, 1.5)
	
	-- Move to the target
	Cmd_Move(sg_a_docks_medics_01, _medic01_target_pos, false, nil, Util_GetPosition(_medic01_target))
	
	Rule_AddInterval(_medic_01_at_patient, 1)
end

function _medic_01_at_patient()
	if Prox_AreSquadsNearMarker(sg_a_docks_medics_01, _medic01_target_pos, ANY, 1) 
	  and SGroup_IsMoving(sg_a_docks_medics_01, ALL) == false then
		Rule_RemoveMe()
		Cmd_Ability(sg_a_docks_medics_01, BP_GetAbilityBlueprint("m01_medic_heal"), _medic01_target)
		
		Rule_AddInterval(_medic_01_healing_done, 1)
	elseif Prox_AreSquadsNearMarker(sg_a_docks_medics_01, _medic01_target_pos, ANY, 1) == false then
		Cmd_Move(sg_a_docks_medics_01, _medic01_target_pos, false, nil, Util_GetPosition(_medic01_target))
	end
end

function _medic_01_healing_done()
	if SGroup_IsDoingAbility(sg_a_docks_medics_01, BP_GetAbilityBlueprint("m01_medic_heal"), ANY) == false then
		Rule_RemoveMe()
		
		for i = 1, table.getn(_medic_being_treated) do
			if _medic_being_treated[i] == _medic01_target then
				table.insert(_medic_wounded, _medic_being_treated[i])
				table.remove(_medic_being_treated, i)
			end
		end
		
		_medic01_target = nil
		
		Rule_AddOneShot(_medic_01_Ability, World_GetRand(2, 4))
	end
end

-- Medic 02
function _medic_02_Ability()
	local size = table.getn(_medic_wounded)
	local id = World_GetRand(1, size)
	if SGroup_IsEmpty(_medic_wounded[id]) then table.remove(_medic_wounded, id) if Rule_Exists(_medic_02_Ability) == false then Rule_AddOneShot(_medic_02_Ability, 1) end return end
	_medic02_target = _medic_wounded[id]
	
	table.insert(_medic_being_treated, _medic02_target)
	table.remove(_medic_wounded, id)
	_medic02_target_pos = Util_GetOffsetPosition(_medic02_target, OFFSET_LEFT, 1.5)
	
	-- Move to the target
	Cmd_Move(sg_a_docks_medics_02, _medic02_target_pos, false, nil, Util_GetPosition(_medic02_target))
	
	Rule_AddInterval(_medic_02_at_patient, 1)
end

function _medic_02_at_patient()
	if Prox_AreSquadsNearMarker(sg_a_docks_medics_02, _medic02_target_pos, ANY, 1) 
	  and SGroup_IsMoving(sg_a_docks_medics_02, ALL) == false then
		Rule_RemoveMe()
		Cmd_Ability(sg_a_docks_medics_02, BP_GetAbilityBlueprint("m01_medic_heal"), _medic02_target)
		
		Rule_AddInterval(_medic_02_healing_done, 1)
	elseif Prox_AreSquadsNearMarker(sg_a_docks_medics_02, _medic02_target_pos, ANY, 1) == false then
		Cmd_Move(sg_a_docks_medics_02, _medic02_target_pos, false, nil, Util_GetPosition(_medic02_target))
	end
end

function _medic_02_healing_done()
	if SGroup_IsDoingAbility(sg_a_docks_medics_02, BP_GetAbilityBlueprint("m01_medic_heal"), ANY) == false then
		Rule_RemoveMe()
		
		for i = 1, table.getn(_medic_being_treated) do
			if _medic_being_treated[i] == _medic02_target then
				table.insert(_medic_wounded, _medic_being_treated[i])
				table.remove(_medic_being_treated, i)
			end
		end
		
		_medic02_target = nil
		
		Rule_AddOneShot(_medic_02_Ability, World_GetRand(2, 4))
	end
end

