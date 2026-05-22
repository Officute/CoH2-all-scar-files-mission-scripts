-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- MISSION: Tiger Ace
-- Designer: Shannon Gadbois

-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScarUtil.scar")
import("Systems/AiManager/ai.scar")
import("Prototype/DeploymentPoints.scar")
import("TheatreOfWar.scar")
-- [[ IMPORT MISSION SCRIPTS ]]
import("Liberation_Obj.scar")
import("Liberation_Encounters.scar")

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------

function OnGameSetup()
	-- Required Players
	player1 = Setup_Player(1, 11038759, "german", 1) -- player1 is always the human player
	player2 = Setup_Player(2, 11038758, "soviet", 2) -- player2 is always the AI opponent

	-- Optional Players
--~ 	player3 = Setup_Player(3, 11038759, "german", 1)		-- player3 is always the AI ally

end

function OnGameRestore()

	UI_SetCPMeterVisibility(true)
	UI_SetAbilityCardVisibility(true)
	Rule_AddOneShot(Setup_OnGameRestore, 1.5)
	Game_DefaultGameRestore()
end

function Setup_OnGameRestore()
	UI_SetCPMeterVisibility(false)
end
-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------

function OnInit()
	
	--[[ PRESET DEBUG CONDITIONS ]]
	Mission_Debug()
	
	--[[ SET DIFFICULTY ]]
	Mission_Difficulty()
	
	--[[ SET RESTRICTIONS ]]
	Mission_Restrictions()
	
	--[[ MISSION PRESETS ]]
	Mission_MissionPreset()
	
	--[[ PLAY INTRO NIS]]

	
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
-- Difficulty Tables and Setup
function Mission_Difficulty()
	
	g_difficulty = Game_GetSPDifficulty() 

	t_difficulty = {
	
		starting_grenadiers = Util_DifVar( { 2, 1, 1, } ),
		starting_snipers = Util_DifVar( { 2, 2, 1, } ),
		starting_veterancy = Util_DifVar( { 3, 3, 2, } ),
		munition_bonus =  Util_DifVar( { 150, 100, 50, } ),
		manpower_bonus =  Util_DifVar( { 1200, 1000, 500, } ),
		fuel_bonus =  Util_DifVar( { 400, 300, 200, } ),
		vet_amount =  Util_DifVar( { 22, 16, 12, } ),
		manpower_rate = Util_DifVar({ 1.5, 1.25, 1, }),
		munition_rate = Util_DifVar({ 2.75, 2.75, 2.5, }),
		fuel_rate = Util_DifVar({ 2.5, 2.25, 2, }),
		
	}
end

function Mission_Restrictions()

	-- Utilize for setting restrictions on Units, teams, etc
	ToW_SetUpTechTreeByYear(player1, 1943) 
	ToW_SetUpTechTreeByYear(player2, 1943)
	
	-- Player 1 Setup

	-- Player 2 Setup (AI)

	-- Player 3 Setup

end

-------------------------------------------------------------------------
-- MISSION Preset 
-------------------------------------------------------------------------

function Mission_MissionPreset()

	-- Kicks off after SCAR Inits, but before MissionStart is called.
	Game_FadeToBlack(FADE_OUT, 0) -- initial fade out for intro movie to hide game interface popping in
	
	-- variables
	phase2_started = false
	enc2_started = false
	escort_active = false
	mission_complete = false

	-- Random Ammo Spawns
	eg_ammo = EGroup_CreateIfNotFound("eg_ammo")
	eg_ATGun_01 = EGroup_CreateIfNotFound("eg_ATGun_01")
	eg_ATGun_02 = EGroup_CreateIfNotFound("eg_ATGun_02")
	eg_MG_01 = EGroup_CreateIfNotFound("eg_MG_01")
	
	-- tables
	t_random_ammo_01 = { mkr_ammo01_01, mkr_ammo01_02, mkr_ammo01_03}
	t_random_ammo_02 = { mkr_ammo02_01, mkr_ammo02_02, mkr_ammo02_03}
	t_random_ammo_03 = { mkr_ammo03_01, mkr_ammo03_02, mkr_ammo03_03}
	-- AT Gun Random Spawn Positions
	t_AT_Gun_North = { mkr_ATGun_01, mkr_ATGun_02, mkr_ATGun_03, mkr_ATGun_04, mkr_ATGun_05}
	
	-- Enemy Mines
	t_west_mines = { mkr_mine_west_01, mkr_mine_west_02, mkr_mine_west_03}
	t_east_mines = { mkr_mine_east_01, mkr_mine_east_02, mkr_mine_east_03}
	t_south_mines = { mkr_mine_south_01, mkr_mine_south_02}
	
	Mission_Random_Item_Spawns() -- Spawn ammo and AT Guns in random positions
	
	-- Player Unit Setup
	sg_p_all = SGroup_CreateIfNotFound("sg_p_all")
	sg_p_pioneer = SGroup_CreateIfNotFound("sg_p_pioneer")
	sg_p_grenadier = SGroup_CreateIfNotFound("sg_p_grenadier")
	sg_scout = SGroup_CreateIfNotFound("sg_scout")
	sg_p_cmd = SGroup_CreateIfNotFound("sg_p_cmd")
	eg_p_hq = EGroup_CreateIfNotFound("eg_p_hq")
	eg_mines = EGroup_CreateIfNotFound("eg_mines")
	mod_manpower =  Modify_PlayerResourceRate(player1, RT_Manpower, 0)
	mod_munition = Modify_PlayerResourceRate(player1, RT_Munition, 0)
	mod_fuel = Modify_PlayerResourceRate(player1, RT_Fuel, 0)
	Modify_PlayerResourceCap(player1, RT_Manpower, 20001, MUT_Addition)

	-- Player Starting Squads
	Util_CreateSquads (player1, {sg_p_all,sg_p_pioneer}, SBP.GERMAN.PIONEER_SQUAD_TOW, mkr_player_start3, mkr_player_start3, 1)
	Util_CreateSquads (player1, {sg_p_all,sg_p_pioneer}, SBP.GERMAN.PIONEER_SQUAD_TOW, mkr_player_start4, mkr_player_start4, 1)
	Util_CreateSquads (player1, {sg_p_all, sg_p_grenadier}, SBP.GERMAN.GRENADIER_SQUAD, mkr_player_start, mkr_player_start, t_difficulty.starting_grenadiers )
	Util_CreateSquads (player1, {sg_p_all, sg_p_grenadier}, SBP.GERMAN.GRENADIER_SQUAD, mkr_player_start2, mkr_player_start2, t_difficulty.starting_grenadiers )
	Util_CreateSquads (player1, sg_p_all, SBP.GERMAN.SNIPER_SQUAD, mkr_player_start5, mkr_player_start5, t_difficulty.starting_snipers )
	Util_CreateSquads (player1, sg_p_all, SBP.GERMAN.SNIPER_SQUAD, mkr_player_start6, mkr_player_start6, t_difficulty.starting_snipers )

	SGroup_IncreaseVeterancyRank(sg_p_all, t_difficulty.starting_veterancy)
	
	-- Player Setup
	SGroup_EnableAttention(sg_p_all, false)
	Misc_SelectSquad(SGroup_GetSpawnedSquadAt(sg_p_all, 1), true)
	Misc_SetSquadControlGroup(SGroup_GetSpawnedSquadAt(sg_p_all, 1), 1)
	Player_AddResource(player1, RT_Munition, 300)
	Player_CompleteUpgrade(player1, UPG.GERMAN.BATTLE_PHASE_2)
	Player_CompleteUpgrade(player1, UPG.GERMAN.BATTLE_PHASE_3)
	Player_SetUpgradeAvailability(player1, UPG.GERMAN.BATTLE_PHASE_4,ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.GERMAN.SCHWERES_KRIEGSWERK, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.BARBED_WIRE_FENCE, ITEM_REMOVED)
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("pioneer_demolition"))
	Player_SetAbilityAvailability(player1, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY, ITEM_UNLOCKED)
	Player_SetUpgradeAvailability(player1,  UPG.GERMAN.PIONEER_MINESWEEPER, ITEM_REMOVED)
	Player_SetAbilityAvailability(player1, ABILITY.GERMAN.PIONEER_BARBED_WIRE_CUTTING_ABILITY, ITEM_UNLOCKED)
	Cmd_InstantUpgrade(sg_p_grenadier, UPG.GERMAN.GRENADIER_MG42_LMG)
	Player_AddUnspentCommandPoints(player1, 15)
	
	-- Abandoned Tank Setup
	local tank_squad_id = SGroup_GetSpawnedSquadAt(sg_tanks, 1)
	local tank_entity_id = Squad_EntityAt(tank_squad_id, 0)
	Tank_id = Entity_GetGameID(tank_entity_id)	
	SGroup_SetAvgHealth(sg_tanks, 0.85)
	Cmd_CriticalHit (player2, sg_tanks, CRIT.VEHICLE_LOSE_TREADS_OR_WHEELS, 1)
	Cmd_CriticalHit (player2, sg_tanks, CRIT.VEHICLE_ABANDON, 1)

	-- Scout Car Setup
	ScoutCar_Encounter = World_GetRand(1, 2)
	if ScoutCar_Encounter == 1 then
		scout_spawn = mkr_scoutcar_01
		scout_enc_space = mkr_scoutcar_space
		scout_enc_spawn = mkr_scout_sp_01
		scout_enc_spawn2 = mkr_scout_sp_01b
		ammo_spawn = mkr_scoutcar_02
		Util_CreateEntities(nil, eg_ammo, BP_GetEntityBlueprint("generic_instantuse_munitions_ammobox_item_small"), ammo_spawn, 1) -- spawn ammo in place of scout car when it is not present
	elseif ScoutCar_Encounter == 2 then
		scout_spawn = mkr_scoutcar_02
		scout_enc_space = mkr_scoutcar_space_02
		scout_enc_spawn = mkr_scout_sp_02
		scout_enc_spawn2 = mkr_scout_sp_02b
		ammo_spawn = mkr_scoutcar_01
		Util_CreateEntities(nil, eg_ammo, BP_GetEntityBlueprint("generic_instantuse_munitions_ammobox_item_small"), ammo_spawn, 1) -- spawn ammo in place of scout car when it is not present
	end
	Event_Proximity(Bonus_Car_Start, nil, player1, scout_spawn, 65, ANY)
	
	Util_CreateSquads (player2, sg_scout, SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD, scout_spawn, scout_spawn, 1)
	
	local squad_id = SGroup_GetSpawnedSquadAt(sg_scout, 1)
	local entity_id = Squad_EntityAt(squad_id, 0)
	Scout_Carid = Entity_GetGameID(entity_id)
	
	-- Abandoned Scout Car
	SGroup_SetAvgHealth(sg_scout, 0.9)
	Cmd_CriticalHit (player2, sg_scout, CRIT.VEHICLE_ABANDON, 1)
	Cmd_CriticalHit (player2, sg_scout, CRIT.VEHICLE_DAMAGE_ENGINE, 1)
	
	-- Enemy units Setup
	sg_bonus_escort_enc = SGroup_CreateIfNotFound("sg_bonus_escort_enc")
	Player_SetAbilityAvailability(player2, ABILITY.SOVIET.ANTI_TANK_GRENADE, ITEM_LOCKED)
	Player_SetAbilityAvailability(player2, ABILITY.SOVIET.GUARDS_THROW_DEFENSIVE_GRENADE, ITEM_LOCKED)
	
	-- Camera Setup
	Camera_ResetToDefault()
	Camera_MoveTo(mkr_camera_start)
	Camera_SetDefault(nil, nil, nil)
	
	-- World Setup
	World_SetIceHealingRate(0.005)
	EGroup_InstantCaptureStrategicPoint( eg_point1, player2 ) 
	EGroup_SetAvgHealth(eg_gate1_barrier, 0.5)
	EGroup_SetAvgHealth(eg_gate3_barrier, 0.5)
	EGroup_SetWorldOwned(eg_base_buildings)
	EGroup_SetInvulnerable(eg_base_buildings, true)
	FOW_PlayerRevealArea(player1, Util_GetPosition(mkr_bonus_ui_01), 2, 0.5)
	FOW_PlayerRevealArea(player1, Util_GetPosition(mkr_bonus_ui_02), 2, 0.5)
	Rule_AddInterval(Wreck_CleanUp, 2) -- Clean up wrecks blocking entry points
	EGroup_SetStrategicPointNeutral(eg_bonus_points)
	EGroup_EnableStrategicPoint(eg_bonus_points, false)
	EGroup_EnableMinimapIndicator(eg_bonus_points, false)
	
	Rule_AddInterval(Tank_Hint, 1)
	Event_Timer(UI_Setup, nil, 1)
end
-------------------------------------------------------------------------
-- MISSION START 
-------------------------------------------------------------------------

function Mission_MissionStart()
	Util_PlayMovie("tow_occupation", 1, 1, Mission_StartObjective)
	Rule_RemoveMe()
end

-- Start Objective and Encounters once intro movie is complete
function Mission_StartObjective()
	print("Mission_StartObjective Part 1")
	Objective_Start(OBJ_Main) -- Start Primary Objective
	SetupEncounters()
end

-- Turn off unused UI
function UI_Setup()
	UI_SetCPMeterVisibility(false)
end

-------------------------------------
-- Bonus Item Random Spawns
-------------------------------------
function Mission_Random_Item_Spawns()
	-- Ammo Spawns
	Util_CreateEntities(nil, eg_ammo, BP_GetEntityBlueprint("generic_instantuse_munitions_ammobox_item_small"), Table_GetRandomItem(t_random_ammo_01), 1)
	Util_CreateEntities(nil, eg_ammo, BP_GetEntityBlueprint("generic_instantuse_munitions_ammobox_item_small"), Table_GetRandomItem(t_random_ammo_02), 1)
	Util_CreateEntities(nil, eg_ammo, BP_GetEntityBlueprint("generic_instantuse_munitions_ammobox_item_small"), Table_GetRandomItem(t_random_ammo_03), 1)
	-- Random MG Spawn 
	Util_CreateEntities(nil, eg_MG_01, EBP.GERMAN.MG42_HMG, Table_GetRandomItem({mkr_MG_01,mkr_MG_02 }), 1)
end
-------------------------------------
-- Setup Phase 2 once the player has captured the base
-------------------------------------
function Setup_Phase2()
	-- Phase 2 Enemy Setup
	Enemy_Retreat()
	Enemy_Retreat_Base() -- Any remaining enemies retreat
	Player_AddResource(player2, RT_Munition, 9999)

	-- Player Unit Setup
	Tiger_Commander_Setup()
	phase2_started = true
	EGroup_SetPlayerOwner(eg_base_buildings, player1)
	EGroup_InstantCaptureStrategicPoint( eg_point1, player1 ) 
	EGroup_SetInvulnerable(eg_base_buildings, false)
	EGroup_DeSpawn(eg_retreat_point)
	Player_AddResource(player1, RT_Fuel, t_difficulty.fuel_bonus)
	Player_AddResource(player1, RT_Manpower, t_difficulty.manpower_bonus)
	Modifier_Remove(mod_manpower)
	Modifier_Remove(mod_munition)
	Modifier_Remove(mod_fuel)
	Modify_PlayerResourceRate(player1, RT_Manpower, t_difficulty.manpower_rate )
	Modify_PlayerResourceRate(player1, RT_Munition, t_difficulty.munition_rate )
	Modify_PlayerResourceRate(player1, RT_Fuel, t_difficulty.fuel_rate)
		
	-- Objective Setup
	Objective_Complete(OBJ_Capture)
	Objective_Start(OBJ_Setup)
		

	-- add watch tower hints
	if EGroup_Count(eg_watchtower_01) ~= 0 then
		wt_hint_01 = HintPoint_Add(eg_watchtower_01, true, 11055212, 3)
		Rule_AddInterval(Remove_Watchtower_Hint, 2)
	end
	if EGroup_Count(eg_watchtower_02) ~= 0 then
		wt_hint_02 = HintPoint_Add(eg_watchtower_02, true, 11055212, 3)
		Rule_AddInterval(Remove_Watchtower_Hint_02, 2)
	end
	if EGroup_Count(eg_watchtower_03) ~= 0 then
		wt_hint_03 = HintPoint_Add(eg_watchtower_03, true, 11055212, 3)
		Rule_AddInterval(Remove_Watchtower_Hint_03, 2)
	end
end

-- Add a hintpoint over the tank to let players know they can capture it.
function Tank_Hint()
	if Entity_IsValid(Tank_id) == false then
		Rule_RemoveMe()
	elseif Player_CanSeeEntity(player1, Entity_FromWorldID(Tank_id) ) == true then
		Tank_Hint_point = HintPoint_Add(mkr_capture_tank, true, 11055213, 2)
		Rule_RemoveMe()
		Rule_AddInterval(Remove_Tank_Hint, 1)
	end
end
function Remove_Tank_Hint()
	if Entity_IsValid(Tank_id) == false or World_OwnsEntity(Entity_FromWorldID(Tank_id)) == false then
		HintPoint_Remove(Tank_Hint_point)
		Rule_RemoveMe()
	end
end

-- Add a hintpoint over the watchtowers to let players know they can capture it.
function Remove_Watchtower_Hint()
	if Player_OwnsEGroup(player1, eg_watchtower_01) == true or EGroup_Count(eg_watchtower_01) == 0 then
		HintPoint_Remove(wt_hint_01)
		Rule_RemoveMe()
	end
end
function Remove_Watchtower_Hint_02()
	if Player_OwnsEGroup(player1, eg_watchtower_02) == true or EGroup_Count(eg_watchtower_02) == 0 then
		HintPoint_Remove(wt_hint_02)
		Rule_RemoveMe()
	end
end
function Remove_Watchtower_Hint_03()
	if Player_OwnsEGroup(player1, eg_watchtower_03) == true or EGroup_Count(eg_watchtower_03) == 0 then
		HintPoint_Remove(wt_hint_03)
		Rule_RemoveMe()
	end
end

-- clean up function to prevent wrecks from blocking entry points
function Wreck_CleanUp()

	if marker == 1 then
		World_GetNeutralEntitiesNearMarker(eg_temp, mkr_cleanup_01)
		EGroup_Filter(eg_temp, EBP.WRECKED_VEHICLES, FILTER_KEEP )
		EGroup_Kill(eg_temp)
		marker = 2
	elseif marker == 2 then
		World_GetNeutralEntitiesNearMarker(eg_temp, mkr_cleanup_02)
		EGroup_Filter(eg_temp, EBP.WRECKED_VEHICLES, FILTER_KEEP )
		EGroup_Kill(eg_temp)
		marker = 3
	elseif marker == 3 then
		World_GetNeutralEntitiesNearMarker(eg_temp, mkr_cleanup_03)
		EGroup_Filter(eg_temp, EBP.WRECKED_VEHICLES, FILTER_KEEP )
		EGroup_Kill(eg_temp)
		marker = 4
	elseif marker == 4 then
		World_GetNeutralEntitiesNearMarker(eg_temp, mkr_cleanup_04)
		EGroup_Filter(eg_temp, EBP.WRECKED_VEHICLES, FILTER_KEEP )
		EGroup_Kill(eg_temp)
		marker = 5
	elseif marker == 5 then
		World_GetNeutralEntitiesNearMarker(eg_temp, mkr_cleanup_05)
		EGroup_Filter(eg_temp, EBP.WRECKED_VEHICLES, FILTER_KEEP )
		EGroup_Kill(eg_temp)
		marker = 1
	end
end

-- Checks to see if the enemy is capturing the base point and warns the player
function Enemy_Capture_Check()
	if not Player_OwnsEGroup(player1, eg_point1) and Prox_ArePlayersNearMarker(player2, mkr_base_point, ANY, 15) then
		Util_StartIntel(EVENTS.Enemy_Capturing)
		UI_CreateMinimapBlip(Util_GetPosition(mkr_base_point), 5, BT_DefendHere)
		Rule_RemoveMe()
		Rule_AddDelayedInterval(Enemy_Capture_Check, 25, 1)
	elseif not Player_OwnsEGroup(player1, eg_point1) and not Prox_ArePlayersNearMarker(player2, mkr_base_point, ANY, 30) then
		Util_StartIntel(EVENTS.Recapture_Warning)
		UI_CreateMinimapBlip(Util_GetPosition(mkr_base_point), 5, BT_CaptureHere)
		Rule_RemoveMe()
		Rule_AddDelayedInterval(Enemy_Capture_Check, 25, 1)
	else
		Rule_RemoveMe()
		Rule_AddDelayedInterval(Enemy_Capture_Check, 2, 1)
	end
end

--? @shortdesc Enable or disable capturing of a group of strategic points
--? @args EGroupID egroup, Boolean enable
function EGroup_EnableStrategicPoint(group, enable)

	local _Entity = function(gid, idx, eid)
		Entity_EnableStrategicPoint(eid, enable)
	end
	EGroup_ForEach(group, _Entity)
	
end

function Check_Player_Status()
	if Player_GetPopulationPercentage(player1) >= 0.5 then
		print(Player_GetPopulationPercentage(player1).."Player population is above 50%!!!!!!!!!!!!!!!")
		g_buffer_time = Util_DifVar({ 10, 5, 0 })
	elseif Player_GetPopulationPercentage(player1) <= 0.49 and Player_GetPopulationPercentage(player1) >= 0.26 then
		print(Player_GetPopulationPercentage(player1).."Player population is below 50%!!!!!!!!!!!!!!!")
		g_buffer_time = Util_DifVar({ 25, 20, 15 })
	elseif Player_GetPopulationPercentage(player1) <= 0.25 then
		print(Player_GetPopulationPercentage(player1).."Player population is below 25%!!!!!!!!!!!!!!!")
		g_buffer_time = Util_DifVar({ 30, 25, 20 })
	end
end

------------------------------
-- Hidden Objective Setup and Functions
------------------------------
function Tiger_Commander_Setup()
	if SGroup_TotalMembersCount(sg_p_all) >= t_difficulty.vet_amount then

		-- random encounter variable setup
		escort_enc = World_GetRand(1, 2) 
		if escort_enc == 1 then
			t_escort_enc_01 = {mkr_south_sp_01, mkr_west_sp_01}
			cmd_spawn = mkr_cmd_bonus_01
			
		elseif escort_enc == 2 then
			t_escort_enc_01 = {mkr_south_sp_02, mkr_east_sp_01}
			cmd_spawn = mkr_cmd_bonus_02
		end
		
		Rule_AddInterval(Tiger_Bonus_Start, 1)
		Rule_AddDelayedInterval(Tiger_Bonus_Hint, 60, 1)
		UI_CreateMinimapBlip(Util_GetPosition(cmd_spawn), 5, BT_DefendHere)
		print("Requirements met, spawning tiger unit"..SGroup_TotalMembersCount(sg_p_all))
	else
		print("Requirements not met"..SGroup_TotalMembersCount(sg_p_all))
	end

end
function Tiger_Bonus_Start()
	if Player_CanSeePosition(player1, Util_GetPosition(cmd_spawn) ) and mission_complete == false then
		escort_active = true 
		Objective_Start(OBJ_Bonus_Escort)
		Util_CreateSquads (player1, sg_p_cmd, BP_GetSquadBlueprint("command_officer_squad_tow") , cmd_spawn, cmd_spawn, 1)
		Bonus_Escort_UI_01 = Objective_AddUIElements(OBJ_Bonus_Escort, sg_p_cmd, true, 11055297, true, 3, nil, HPAT_Objective)
		mod_com_movement = Modify_UnitSpeed(sg_p_cmd, 0.6)
		SGroup_SetAvgHealth(sg_p_cmd, 0.5)
		Rule_RemoveMe()
		Rule_AddInterval(Tiger_Bonus_Completion_Check, 2)
		
		Rule_AddDelayedInterval(Loop_Bonus_Escort_Enc, 10, 1)
		
	end
end

function Tiger_Bonus_Hint()
	if escort_active == false and Objective_IsStarted(OBJ_Bonus_Escort) == false then
		UI_CreateMinimapBlip(Util_GetPosition(cmd_spawn), 5, BT_DefendHere)
		Rule_RemoveMe()
		Rule_AddDelayedInterval(Tiger_Bonus_Hint, 120, 1)
		print("Bonus Objective Inactive - Looping Hint")
	else
		print("Bonus Objective Active - Removing Hint")
		Rule_RemoveMe()
	end
end

function Tiger_Bonus_Completion_Check()
	if Prox_AreSquadsNearMarker(sg_p_cmd, mkr_player_hq, ANY, 15) then
		-- Objective Complete
		escort_active = false
		Objective_Complete(OBJ_Bonus_Escort)
		Objective_RemoveUIElements(OBJ_Bonus_Escort, Bonus_Escort_UI_01)
		-- Grant ability
		Cmd_InstantUpgrade(player1,  UPG.GERMAN.TIGER_TANK)
		Player_AddAbility(player1, ABILITY.GERMAN.TIGER_TANK)
		Player_SetAbilityAvailability(player1, ABILITY.GERMAN.TIGER_TANK,ITEM_UNLOCKED )
		UI_AddHintAndFlashAbility(player1, ABILITY.GERMAN.TIGER_TANK, LOC("Tiger Tank"), 3)
		-- Clean Up Units
		Modifier_Remove(mod_com_movement)
		SGroup_SetSelectable(sg_p_cmd, false)
		Cmd_Move(sg_p_cmd, mkr_player_hq, false, mkr_player_hq , nil, nil, 8)
		Bonus_Retreat()
		Rule_RemoveMe()
	elseif SGroup_CountSpawned(sg_p_cmd) == 0 then
		--Objective Failed
		escort_active = false
		Objective_Fail(OBJ_Bonus_Escort)
		Objective_RemoveUIElements(OBJ_Bonus_Escort, Bonus_Escort_UI_01)
		Bonus_Retreat()
		Rule_RemoveMe()
	end
end

-- Looping encounter for rescue mission
function Loop_Bonus_Escort_Enc()
	if SGroup_TotalMembersCount(sg_bonus_escort_enc) <= 8 and escort_active == true then
		Bonus_escort_01()
		Rule_RemoveMe()
		Rule_AddDelayedInterval(Loop_Bonus_Escort_Enc, 30, 1)
	end
end

function Bonus_escort_01()
	local random_spawn = Table_GetRandomItem(t_escort_enc_01)
	local encData = {
		player = player2,
		sgroups = {sg_bonus_escort_enc},
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = random_spawn,
				dynamicSpawnTarget = sg_p_cmd,
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = random_spawn,
				dynamicSpawnTarget = sg_p_cmd,
			},
		},
		onDeath = nil,
	}
	bonus_escort_01 = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		attackMove = true,
		target = sg_p_cmd,
		range = 40,
		leashRange = 10, 
	}
	bonus_escort_01:SetGoal(goalData)

end	

-- Retreat once objective is completed
function Bonus_Retreat()
	Cmd_Retreat(sg_bonus_escort_enc, Util_GetPosition(mkr_south_sp_01), mkr_south_sp_01, true )
end

	