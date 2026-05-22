-------------------------------------------------------------------------
-- Designer: Mitch
--
--NOTES:
-- Scavenging wrecks requires that they have a cost extension set in the AE.
-- This is done by adding the Cost extension to the wrecked vehicle ebp, found under Environments/Art Ambient/Objects/Vehicles/Wrecked Vehicles
-- Any vehicle used in the mission will need this update. At this point they are set to 370 munitions (under Cost/time_cost/cost), at a rate of 100 percent (cost/scavenge_percentage_returns).
-- Currently setup vehicles: wrecked_t_34_85_red_banner, wrecked_m5_halftrack, wrecked_kv-1, wrecked_katyusha_bm_-13n, wrecked_t70, wrecked_t_34_76, wrecked_m5_halftrack, wrecked_m3a1_scout_car
-- Tuning for salvaging can be done from the EBP: german_salvage_ability_convoy/action_list/start_target_actions/salvage_from_wreck_action
--
-- All squads added to the group sg_convoy will be counted towards the player's goal. So only vehicles that are actually part of the convoy should be added to it
-------------------------------------------------------------------------

import("ScarUtil.scar")
import("Beginner.scar")
import("Systems/AiManager/ai.scar")
import("TheatreOfWar.scar")
import("Global_Values/CampaignGlobalConstants.scar")
import("Prototype/DeploymentPoints.scar")
import("Convoy_Obj.scar")

-------------------------------------------------------------------------
-- INITIALIZATION
-------------------------------------------------------------------------
function OnGameSetup()
	player1 = Setup_Player(1, 11038759, "german", 1)
	player2 = Setup_Player(2, 11038758, "soviet", 2)
end
function OnInit()		
	
	--SGROUPS
	sg_intro = SGroup_CreateIfNotFound("sg_intro")
	sg_intro2 = SGroup_CreateIfNotFound("sg_intro2")
	
	sg_playerSquads = SGroup_CreateIfNotFound("sg_playerSquads")
	sg_playerHalftrack = SGroup_CreateIfNotFound("sg_playerHalftrack")
	sg_convoy = SGroup_CreateIfNotFound("sg_convoy")	
	sg_convoyTrucks = SGroup_CreateIfNotFound("sg_convoyTrucks")
	sg_convoyTrucks_wave2 = SGroup_CreateIfNotFound("sg_convoyTrucks_wave2")
	sg_convoyHalftrack_01 = SGroup_CreateIfNotFound("sg_convoyHalftrack_01")
	sg_convoyT70 = SGroup_CreateIfNotFound("sg_convoyT70")
	sg_convoyT34 = SGroup_CreateIfNotFound("sg_convoyT34")	
	sg_convoyKVs = SGroup_CreateIfNotFound("sg_convoyKVs")	
	sg_convoyHalftracks = SGroup_CreateIfNotFound("sg_convoyHalftracks")
	
	sg_tempConvoy = SGroup_CreateIfNotFound("sg_tempConvoy")
	sg_convoyTargets = SGroup_CreateIfNotFound("sg_convoyTargets")
	
	sg_convoyTruck_01 = SGroup_CreateIfNotFound("sg_convoyTruck_01")
	sg_convoyTruck_02 = SGroup_CreateIfNotFound("sg_convoyTruck_02")
	sg_convoyTruck_03 = SGroup_CreateIfNotFound("sg_convoyTruck_03")
	sg_convoyTruck_04 = SGroup_CreateIfNotFound("sg_convoyTruck_04")
	
	sg_convoyGuards = SGroup_CreateIfNotFound("sg_convoyGuards")	
	
	sg_convoySquads_01 = SGroup_CreateIfNotFound("sg_convoySquads_01")	
	sg_convoySquads_02 = SGroup_CreateIfNotFound("sg_convoySquads_02")	
	sg_convoySquads_03 = SGroup_CreateIfNotFound("sg_convoySquads_03")	
	sg_convoySquads_04 = SGroup_CreateIfNotFound("sg_convoySquads_04")	
	sg_convoySquads_05 = SGroup_CreateIfNotFound("sg_convoySquads_05")	
	sg_convoySquads_06 = SGroup_CreateIfNotFound("sg_convoySquads_06")	
	
	sg_convoyGarrison_01 = SGroup_CreateIfNotFound("sg_convoyGarrison_01")	
	sg_convoyGarrison_02 = SGroup_CreateIfNotFound("sg_convoyGarrison_02")	
	sg_convoyGarrison_03 = SGroup_CreateIfNotFound("sg_convoyGarrison_03")	
	
	sg_convoyEngineers = SGroup_CreateIfNotFound("sg_convoyEngineers")
	sg_convoyEngineer_01 = SGroup_CreateIfNotFound("sg_convoyEngineer_01")	
	sg_convoyEngineer_02 = SGroup_CreateIfNotFound("sg_convoyEngineer_02")	
	sg_convoyEngineer_03 = SGroup_CreateIfNotFound("sg_convoyEngineer_03")
	sg_convoyEngineer_04 = SGroup_CreateIfNotFound("sg_convoyEngineer_04")	
	
	sg_convoyLeftover = SGroup_CreateIfNotFound("sg_convoyLeftover")
	sg_convoyScout = SGroup_CreateIfNotFound("sg_convoyScout")
	sg_convoyLeader = SGroup_CreateIfNotFound("sg_convoyLeader")
	sg_allPlayer2 = SGroup_CreateIfNotFound("sg_allPlayer2")
	
	sg_p_reinforcements1 = SGroup_CreateIfNotFound("sg_p_reinforcements1")
	sg_p_reinforcements2 = SGroup_CreateIfNotFound("sg_p_reinforcements2")
	
	eg_builtBarricade = EGroup_CreateIfNotFound("eg_builtBarricade")
	eg_mortars = EGroup_CreateIfNotFound("eg_mortars")
	eg_HMGs = EGroup_CreateIfNotFound("eg_HMGs")
	
	-- Global mission variables
	t_allPaths = {"path1", "path2", "path3", "path4"} -- A list of convoy paths defined in the WorldBuilder. Paths 5 and 6 are added later. Path 5 can never be removed.
	
	t_barricades = {mkr_barricadeLeftCenter, mkr_barricadeLeftTop, mkr_barricadeRightTop, mkr_barricadeRightCenter} -- Markers on the position of buildable barricades
	
	t_barricadeHints = {} -- A table of hintpoints placed on the pre-built barricade entities
	
	t_followingSquads = t_followingSquads or {} -- A list of infantry squads following the convoy vehicles
	
	g_leaderSquads = {} -- A list of squads that area leading the convoy -- i.e. the vehicle in front.
	
	g_convoyPath = "path1" -- The default convoy path. The convoy will pick a random path from the list above at the start of each wave.
	
	g_notMovingTimer = 0 -- How long has the convoy leader been immobile? If too long, tell the other vehicles to move past it.
	
	g_damagedVehicle = nil -- A pointer to convoy vehicle that has a critical. Engineers will be told to repair this vehicle.
	
	g_replacementEngineerCount = 0 -- How many times the enemy has called in new repair engineers during each wave.
	
	g_abandonSpeechIndex = 1 -- Speech event to play when an enemy vehicle is abandoned
	
	g_barricadeSpeechIndex = 1 -- Speech event to play when the enemy spots a barricade
	
	Mission_Debug()
	
	Mission_Restrictions()
	
	Mission_Difficulty()
	
	Mission_MissionPreset()
	
	Game_StartMuted(true)
	
	World_SetIceHealingRate(0.0333)
	EGroup_EnableMinimapIndicator(eg_hide, false)
	
	UI_SetCPMeterVisibility(true)
	Game_FadeToBlack(FADE_OUT, 0)
	Event_Timer(Mission_Start, nil, 1.5)	
	
end

function OnGameRestore()
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	UI_SetCPMeterVisibility(true)
	Rule_AddOneShot(Convoy_OnGameRestore, 1)
	Game_DefaultGameRestore()
end

function Convoy_OnGameRestore()
	UI_SetCPMeterVisibility(false)
	if g_difficulty ~= GD_HARD then
		FOW_PlayerRevealAll(player1)
	end
end

Scar_AddInit(OnInit)

function Mission_Debug()
	if Misc_IsCommandLineOptionSet("debug") then
		g_debug = true
	end
end

function Mission_Restrictions()
	ToW_SetUpTechTreeByYear(player1, 1942)
	ToW_SetUpTechTreeByYear(player2, 1942)
	
	-- The flamethrowers are too powerful vs. ice, so they need to be disabled for this challenge
	Player_SetUpgradeAvailability(player1, UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE, ITEM_REMOVED)
	
	-- 
	Player_SetUpgradeAvailability(player1, UPG.GERMAN.AMBUSH_CAMOU_PACKAGE, ITEM_REMOVED)
end

function Mission_Difficulty()	
	g_difficulty = Game_GetSPDifficulty() 
	
	t_difficulty = {
 	-- Easy, Medium, Hard
		
		convoyLightMoveSpeedModifier	= Util_DifVar( {(2/5.5), (2.5/5.5), (3/5.5)} ), 
		convoyMediumMoveSpeedModifier	= Util_DifVar( {(2/5), (2.5/5), (3/5)} ), 
		convoyHeavyMoveSpeedModifier	= Util_DifVar( {(2/4.5), (2.5/4.5), (3/4.5)} ),
		setupTimeBeforeWave1 			=  Util_DifVar( {95, 65, 30} ),
		setupTimeBeforeWave2 			=  Util_DifVar( {45, 30, 30} ),
		setupTimeBeforeWave3 			=  Util_DifVar( {45, 30, 30} ),
		playerManpowerRate				= Util_DifVar( {0.5, 0.4, 0.3} ),
		
	}
	
	if g_difficulty == GD_HARD then
		g_mainObjective = OBJ_DestroyConvoyHard
	else
		g_mainObjective = OBJ_DestroyConvoy
--~ 		EGroup_DestroyAllEntities(eg_hardDefenses)
	end
end

function Mission_MissionPreset()
	-- No FoW for this mission on EASY and NORMAL (It's re-enabled on HARD.)
	FOW_PlayerRevealAll(player1)
--~ 	FOW_RevealMarker(mkr_playableArea, -1)
	
	Camera_SetDefault(nil, nil, 0)
	Camera_MoveTo(mkr_playerSpawn01, false, 0)
	Camera_ResetToDefault()
	
	Player_SetResource(player1, RT_Munition, 500)
	Player_SetResource(player1, RT_Manpower, 100)
	Player_SetResource(player1, RT_Fuel, 0)
	Player_SetResource(player1, RT_Command, 3)
	
	Modify_PlayerResourceRate(player1, RT_Munition, 0, MUT_Multiplication)
	Modify_PlayerResourceRate(player1, RT_Manpower, t_difficulty.playerManpowerRate, MUT_Multiplication)
	Modify_PlayerResourceRate(player1, RT_Fuel, 0, MUT_Multiplication)
	
	Modify_PlayerResourceCap(player1, RT_Manpower, 101, MUT_Addition)
	Modify_PlayerResourceCap(player1, RT_Munition, 5001, MUT_Addition)
	
	Player_AddAbility(player1, ABILITY.GERMAN.FAST_MARCH)
	Cmd_InstantUpgrade(player1, UPG.GERMAN.FAST_MARCH)	

	Cmd_InstantUpgrade(player1, UPG.GERMAN.BATTLE_PHASE_2)
	Cmd_InstantUpgrade(player1, UPG.GERMAN.AMBUSH_CAMOUFLAGE)	
	
	--The heavy mines are powerful, so their cost has to be tuned to make them less of a dominant strategy in this mission
	Modify_AbilityMunitionsCost(player1, ABILITY.GERMAN.LAY_HEAVY_AT_MINE, 1.5, MUT_Multiplication)
	-- As a trade-off, make Panzerfausts a bit cheaper, since they mostly just delay the convoy
	Modify_AbilityMunitionsCost(player1, ABILITY.GERMAN.GRENADIER_PANZERFAUST, 0.6667, MUT_Multiplication)
	-- Make regular mines a bit cheaper
	Modify_EntityCost(player1, EBP.GERMAN.GERMAN_MINE, RT_Munition, -10)
	
	--The default repair rate for the soviets is too slow for this mission, it's not fun waiting for them to finish
	Modify_VehicleRepairRate(player2, 2, EBP.SOVIET.COMBAT_ENGINEER)
		
	Mission_SetupPlayerSquads()
	
	-- Set up weapons that the player can pick up
	Mission_SetupWeaponPickups()
end

function Mission_SetupPlayerSquads()

	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("pioneer_demolition"))
	
	Util_CreateSquads(player1, sg_playerSquads, SBP.GERMAN.GRENADIER_SQUAD, mkr_playerSpawn01f, nil, 1)
	Util_CreateSquads(player1, sg_playerSquads, SBP.GERMAN.GRENADIER_SQUAD, mkr_playerSpawn01b, nil, 1) -- mkr_playerSpawn01e
	Cmd_InstantUpgrade(sg_playerSquads, UPG.GERMAN.AMBUSH_CAMOU_PACKAGE)
	Cmd_Ability(sg_playerSquads, ABILITY.GERMAN.AMBUSH_CAMOUFLAGE, nil, nil, true)
	Player_SetAbilityAvailability(player1, ABILITY.GERMAN.AMBUSH_CAMOUFLAGE, ITEM_REMOVED)
	SGroup_AddAbility(sg_playerSquads, ABILITY.GERMAN.AMBUSH_CAMO_HOLD_FIRE_MP)
	Util_CreateSquads(player1, sg_playerSquads, BP_GetSquadBlueprint("convoy_pioneer_squad"), mkr_playerSpawn01, nil, 1)
	Util_CreateSquads(player1, {sg_playerSquads, sg_playerHalftrack}, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, mkr_playerSpawn01d, nil, 1)
	Util_CreateSquads(player1, sg_playerSquads, SBP.GERMAN.SCOUTCAR_SDKFZ222, mkr_playerSpawn01g, nil, 1)
	Util_CreateSquads(player1, sg_playerSquads, BP_GetSquadBlueprint("convoy_pioneer_squad"), mkr_playerSpawn01c, nil, 1) -- mkr_playerSpawn01f
	Cmd_InstantUpgrade(sg_playerHalftrack, UPG.GERMAN.HEAVY_AT_MINE)
	
end

function Mission_SetupWeaponPickups()
	-- Remove two of three PTRS AT rifle pickups (pre-placed on the map)
	Entity_Destroy(EGroup_GetRandomSpawnedEntity(eg_atRifles))
	Entity_Destroy(EGroup_GetRandomSpawnedEntity(eg_atRifles))
	if g_difficulty ~= GD_HARD then
		HintPoint_Add(eg_atRifles, true, 11046412)
		FOW_RevealArea(EGroup_GetPosition(eg_atRifles), 2.5, -1)
	end
	
	-- ZIS and 53-K AT guns (pre-placed on the map)
	if g_difficulty == GD_HARD then
		EGroup_DestroyAllEntities(eg_zis3)
		EGroup_DestroyAllEntities(eg_53k)
	elseif g_difficulty == GD_NORMAL then
		EGroup_DestroyAllEntities(eg_zis3)
	end
	
	-- Mortars
	local mortarMarkers = Table_GetRandomItem({mkr_mortarSpawn1, mkr_mortarSpawn2, mkr_mortarSpawn3}, 3)
	Util_CreateEntities(nil, eg_mortars, EBP.SOVIET.PM41_82MM_MORTAR, mortarMarkers[1], 1)
	if g_difficulty >= GD_NORMAL then
		Util_CreateEntities(nil, eg_mortars, EBP.SOVIET.PM41_82MM_MORTAR, mortarMarkers[2], 1)
	end
	if g_difficulty == GD_HARD then
		Util_CreateEntities(nil, eg_mortars, EBP.SOVIET.PM41_82MM_MORTAR, mortarMarkers[3], 1)
	end
	
	-- HMGs
	local mgMarkers = Table_GetRandomItem({mkr_mgSpawn1, mkr_mgSpawn2, mkr_mgSpawn3}, 3)
	Util_CreateEntities(nil, eg_HMGs, EBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN, mgMarkers[1], 1)
	if g_difficulty >= GD_NORMAL then
		Util_CreateEntities(nil, eg_HMGs, EBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN, mgMarkers[2], 1)
	end
	if g_difficulty == GD_HARD then
		Util_CreateEntities(nil, eg_HMGs, EBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN, mgMarkers[3], 1)
	end	
	
end

-------------------------------------------------------------------------
-- MISSION START 
-------------------------------------------------------------------------
function Mission_Start()
	Game_FadeToBlack(FADE_OUT, 0)
	Util_PlayMovie("tow_convoy", 0, 0)
	UI_SetCPMeterVisibility(false)
	--reenable FOW, now without shroud, for HARD difficulty
	Objective_Start(g_mainObjective)
	World_EnableSharedLineOfSight(player1, player2, false)	
	
	-- LOSS CONDITION: No player squads left
	Event_PlayerSquadCount(OBJ_DestroyConvoy_PlayerDead, nil, player1, 0)
	
end

-------------------------------------------------------------------------
-- GENERAL MISSION 
-------------------------------------------------------------------------

function Mission_SendPlayerReinforcements()	
	if Player_IsAlive(player1) then
		Util_StartIntel(EVENTS.Reinforcements)
		Util_CreateSquads(player1, {sg_playerSquads, sg_p_reinforcements2}, SBP.GERMAN.GRENADIER_SQUAD, mkr_playerSpawn02, mkr_playerSpawn01)
		Util_CreateSquads(player1, {sg_playerSquads, sg_p_reinforcements2}, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_playerSpawn02, mkr_playerSpawn01, 1)
		SGroup_AddAbility(sg_p_reinforcements2, ABILITY.GERMAN.AMBUSH_CAMO_HOLD_FIRE_MP)
		Cmd_InstantUpgrade(sg_p_reinforcements2, UPG.GERMAN.AMBUSH_CAMOU_PACKAGE)
		Player_SetAbilityAvailability(player1, ABILITY.GERMAN.AMBUSH_CAMOUFLAGE, ITEM_DEFAULT)
		Cmd_Ability(sg_p_reinforcements2, ABILITY.GERMAN.AMBUSH_CAMOUFLAGE, nil, nil, true)
		Player_SetAbilityAvailability(player1, ABILITY.GERMAN.AMBUSH_CAMOUFLAGE, ITEM_REMOVED)
		if g_difficulty == GD_EASY and SGroup_IsEmpty(sg_playerHalftrack) then
			Util_CreateSquads(player1, {sg_playerSquads, sg_p_reinforcements2, sg_playerHalftrack}, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, mkr_playerSpawn02, mkr_playerSpawn01d)
			Cmd_InstantUpgrade(sg_playerHalftrack, UPG.GERMAN.HEAVY_AT_MINE)
		end
		Util_ReinforceEvent(sg_p_reinforcements2)
	end
end

-------------------------------------------------------------------------
-- CONVOY --
-------------------------------------------------------------------------

-- Tell the convoy to pick a random path from the list of remaining paths
-- Remove that path from the list, so it isn't picked again. Keep "path5" -- we need to keep at least one.
-- Forcibly remove a path from the list when the convoy hits a barricade that is blocking that path
function Convoy_ChooseRandomPath(pathToRemove)
	g_convoyPath = pathToRemove or Table_GetRandomItem(t_allPaths)
	local removePath = function (index, path)
		if path == g_convoyPath and path ~= "path5" then
			table.remove(t_allPaths, index)
		end
	end
	table.foreach(t_allPaths, removePath)
	if pathToRemove then
		g_convoyPath = Table_GetRandomItem(t_allPaths)
	end		
end

----------------- WAVE 1 ------------------
function Convoy_SetupFirstGroup()
	g_convoyStage = 1
	Util_CreateSquads(player2, {sg_convoyTrucks, sg_convoy, sg_convoyHalftrack_01, sg_convoyTargets}, SBP.SOVIET.M5_HALFTRACK_SQUAD, mkr_convoySpawn02)	
	Util_CreateSquads(player2, {sg_convoyTrucks, sg_convoyTruck_01, sg_convoy, sg_convoyTargets}, SBP.SOVIET.ZIS_6_TRANSPORT_TRUCK, mkr_convoySpawn03)
	Util_CreateSquads(player2, {sg_convoy, sg_convoyT70, sg_convoyTargets}, SBP.SOVIET.T_70M, mkr_convoySpawn04)
	
	SGroup_SetAutoTargetting(sg_convoyTrucks, "hardpoint_01", false)
	
	-- Slow vehicles to squad movement speed
	Modify_UnitSpeed(sg_convoyTrucks, t_difficulty.convoyLightMoveSpeedModifier)
	Modify_UnitSpeed(sg_convoyT70, t_difficulty.convoyLightMoveSpeedModifier)
	
	Util_CreateSquads(player2, {sg_convoyGuards, sg_convoySquads_01}, SBP.SOVIET.GUARDS_TROOPS, mkr_convoySpawn02, nil, nil, 4)
	Util_CreateSquads(player2, {sg_convoyGuards, sg_convoySquads_02}, SBP.SOVIET.GUARDS_TROOPS, mkr_convoySpawn02, nil, nil, 4)
	Convoy_SGroupFollowVehicles(sg_convoyGuards)
	
	Util_CreateSquads(player2, {sg_convoyEngineer_01, sg_convoyEngineers}, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_convoySpawn03)
	
	Cmd_Garrison(sg_convoyEngineer_01, sg_convoyTruck_01, nil, nil, true)
	if g_difficulty ~= GD_HARD then
		evt_wave1_halftrack = Event_GroupIsDead(Convoy_Wave1_TransportDestroyed, nil, sg_convoyHalftrack_01)
		evt_wave1_truck = Event_GroupIsDead(Convoy_Wave1_TransportDestroyed, nil, sg_convoyTruck_01)
		evt_wave1_t70 = Event_GroupIsDead(Convoy_Wave1_T70Destroyed, nil, sg_convoyT70)
	else
		Util_ApplyModifier(sg_convoySquads_01, "posture_speed_modifier", 1, MUT_Addition)
		Util_ApplyModifier(sg_convoySquads_02, "posture_speed_modifier",  1, MUT_Addition)
		Util_ApplyModifier(sg_convoyEngineer_01, "posture_speed_modifier",  1, MUT_Addition)
	end
	Event_GroupIsDead(Convoy_SetupSecondGroup, nil, sg_convoyTargets, (30 + t_difficulty.setupTimeBeforeWave2))
	Event_GroupIsDead(Convoy_TimerBeforeWave2, nil, sg_convoyTargets, 5)
	evt_secondReinforce = Event_GroupIsDead(Mission_SendPlayerReinforcements, nil, sg_convoyTargets, 10)
	Event_Proximity(Convoy_KillSquadsInMarker, {sgroup = sg_convoy, marker = mkr_convoyEnd}, sg_convoy, mkr_convoyEnd, 15, ANY)	
	ThreatArrow_CreateGroup(sg_convoy)
	
	t_allPaths = {"path1", "path2", "path3", "path4"} -- Remove two possible paths for the first wave
	Convoy_ChooseRandomPath()
	table.insert(t_allPaths, "path6")
	Convoy_HideConvoy()
	
end

function Convoy_RevealSGroup()
	FOW_RevealSGroupOnly(sg_convoy, 240)
end

-- Briefly hide the convoy as it moves in through the soft map edge
function Convoy_HideConvoy()
	if not SGroup_IsEmpty(sg_convoy) then
		SGroup_EnableMinimapIndicator(sg_convoy, false)
		SGroup_Hide(sg_convoy, true)
	end
	if not SGroup_IsEmpty(sg_convoyGuards) then
		SGroup_EnableMinimapIndicator(sg_convoyGuards, false)
		SGroup_Hide(sg_convoyGuards, true)
	end
	if not SGroup_IsEmpty(sg_convoyEngineers) then
		SGroup_EnableMinimapIndicator(sg_convoyEngineers, false)
		SGroup_Hide(sg_convoyEngineers, true)
	end
	Rule_RemoveIfExist(Convoy_UnHideConvoy)
	Rule_AddOneShot(Convoy_UnHideConvoy, 10)
end

function Convoy_UnHideConvoy()
	if not SGroup_IsEmpty(sg_convoy) then
		SGroup_EnableMinimapIndicator(sg_convoy, true)
		SGroup_Hide(sg_convoy, false)
	end
	if not SGroup_IsEmpty(sg_convoyGuards) then
		SGroup_EnableMinimapIndicator(sg_convoyGuards, true)
		SGroup_Hide(sg_convoyGuards, false)
	end
	if not SGroup_IsEmpty(sg_convoyEngineers) then
		SGroup_EnableMinimapIndicator(sg_convoyEngineers, true)
		SGroup_Hide(sg_convoyEngineers, false)
	end
end

-- Notify when a halftrack or truck is destroyed in Wave 1
function Convoy_Wave1_TransportDestroyed()
	Objective_Complete(SOBJ_TargetOne)
	Objective_Complete(SOBJ_TargetOne)
	if SGroup_CountSpawned(sg_convoyHalftrack_01) > 0 then
		SGroup_RemoveGroup(sg_convoyTargets, sg_convoyHalftrack_01)
	end
	if SGroup_CountSpawned(sg_convoyTruck_01) > 0 then
		SGroup_RemoveGroup(sg_convoyTargets, sg_convoyTruck_01)
	end
	Event_Remove(evt_wave1_halftrack)
	Event_Remove(evt_wave1_truck)
end

-- Notify when the T-70 is destroyed in Wave 1
function Convoy_Wave1_T70Destroyed()
	Objective_Complete(SOBJ_TargetTwo)
	Event_Remove(evt_wave1_t70)
end

----------------- WAVE 2 ------------------
function Convoy_SetupSecondGroup()
	t_followingSquads = {}
	g_replacementEngineerCount = 0
	if SGroup_Count(sg_convoy) > 0 then
		SGroup_AddGroup(sg_convoyLeftover, sg_convoy)
		Cmd_MoveToAndDespawn(sg_convoyLeftover, mkr_convoyEnd, false)
		SGroup_Clear(sg_convoy)
	end
	Convoy_ChooseRandomPath()
	g_convoyStage = 2
	if g_difficulty ~= GD_HARD then
		Objective_Show(SOBJ_WaitingTime, false)
		Objective_Start(SOBJ_TargetThree)
		Objective_Start(SOBJ_TargetFour)
	end
	Util_CreateSquads(player2, {sg_convoyHalftracks, sg_convoy}, SBP.SOVIET.M5_HALFTRACK_SQUAD, mkr_convoySpawn02)
	Util_CreateSquads(player2, {sg_convoyTrucks, sg_convoyTruck_02, sg_convoyTrucks_wave2, sg_convoy, sg_convoyTargets}, SBP.SOVIET.ZIS_6_TRANSPORT_TRUCK, mkr_convoySpawn03)
	Util_CreateSquads(player2, {sg_convoyTrucks, sg_convoyTruck_03, sg_convoyTrucks_wave2, sg_convoy, sg_convoyTargets}, SBP.SOVIET.ZIS_6_TRANSPORT_TRUCK, mkr_convoySpawn04)	
	Util_CreateSquads(player2, {sg_convoyT34, sg_convoy, sg_convoyTargets}, SBP.SOVIET.T_34_76_SQUAD, mkr_convoySpawn05)
	
	SGroup_SetAutoTargetting(sg_convoyTrucks_wave2, "hardpoint_01", false)
	SGroup_SetAutoTargetting(sg_convoyHalftracks, "hardpoint_01", false)
	
	Util_CreateSquads(player2, {sg_convoyGuards, sg_convoySquads_03}, SBP.SOVIET.GUARDS_TROOPS, mkr_convoySpawn01, nil, nil, 4)
	Util_CreateSquads(player2, {sg_convoyGuards, sg_convoySquads_04}, SBP.SOVIET.GUARDS_TROOPS, mkr_convoySpawn01, nil, nil, 4)
	Convoy_SGroupFollowVehicles(sg_convoyGuards)
	
	Util_CreateSquads(player2, {sg_convoyEngineer_02, sg_convoyEngineers}, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_convoySpawn03)
	Util_CreateSquads(player2, {sg_convoyEngineer_03, sg_convoyEngineers}, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_convoySpawn04)
		
	-- Slow vehicles to squad movement speed
	Modify_UnitSpeed(sg_convoyTrucks, t_difficulty.convoyLightMoveSpeedModifier)
	Modify_UnitSpeed(sg_convoyHalftracks, t_difficulty.convoyLightMoveSpeedModifier)
	Modify_UnitSpeed(sg_convoyT34, t_difficulty.convoyMediumMoveSpeedModifier)
	
	Cmd_Garrison(sg_convoyEngineer_02, sg_convoyTruck_02, nil, nil, true)
	Cmd_Garrison(sg_convoyEngineer_03, sg_convoyTruck_03, nil, nil, true)
	
	--Make sure the convoy doesn't continue moving due to the last group
	Convoy_StopMovement()
	
	Event_Proximity(Convoy_KillSquadsInMarker, {sgroup = sg_convoy, marker = mkr_convoyEnd}, sg_convoy, mkr_convoyEnd, 15, ANY)
	
	if g_difficulty ~= GD_HARD then
		evt_wave2_t34 = Event_GroupIsDead(Convoy_Wave2_T34Destroyed, nil, sg_convoyT34)
		evt_wave2_trucks = Event_GroupIsDead(Convoy_Wave2_TrucksDestroyed, nil, sg_convoyTrucks_wave2)	
	else
		Util_ApplyModifier(sg_convoySquads_03, "posture_speed_modifier",  1, MUT_Addition)
		Util_ApplyModifier(sg_convoySquads_04, "posture_speed_modifier",  1, MUT_Addition)
		Util_ApplyModifier(sg_convoyEngineer_02, "posture_speed_modifier",  1, MUT_Addition)
		Util_ApplyModifier(sg_convoyEngineer_03, "posture_speed_modifier",  1, MUT_Addition)
	end
	Event_GroupIsDead(Convoy_SetupThirdGroup, nil, sg_convoyTargets, (30 + t_difficulty.setupTimeBeforeWave3))	
	Event_GroupIsDead(Convoy_TimerBeforeWave3, nil, sg_convoyTargets, 5)
	
	Event_Timer(Convoy_BeginSecondGroup, nil, 5)

	if g_difficulty == GD_EASY then
		Rule_RemoveIfExist(Convoy_RevealSGroup)
	elseif g_difficulty == GD_HARD then
		Cmd_InstantUpgrade(player1, UPG.SOVIET.TANK_DETECTION)
		Player_AddAbility(player1, BP_GetAbilityBlueprint("tank_detection_ability_convoy"))	
		flashID_tankDetect = UI_FlashAbilityButton(BP_GetAbilityBlueprint("tank_detection_ability_convoy"), true)
		Rule_AddOneShot(UI_StopFlashingTankDetect, 6)
	end
	if g_difficulty ~= GD_HARD then
		ThreatArrow_CreateGroup(sg_convoy)
	end
	
	table.insert(t_allPaths, "path5")
	Convoy_HideConvoy()
	
end

function Convoy_TimerBeforeWave2()
	Objective_Show(SOBJ_TargetOne, false)
	Objective_Show(SOBJ_TargetTwo, false)
	Objective_Show(SOBJ_WaitingTime, true)
	Objective_StartTimer(SOBJ_WaitingTime, COUNT_DOWN, (30 + t_difficulty.setupTimeBeforeWave2), 5)
end

-- Notify when the T-34 is destroyed in Wave 2
function Convoy_Wave2_T34Destroyed()
	Objective_Complete(SOBJ_TargetThree)
	Event_Remove(evt_wave2_t34)
end

-- Notify when the trucks are destroyed in Wave 2
function Convoy_Wave2_TrucksDestroyed()
	Objective_Complete(SOBJ_TargetFour)
	Event_Remove(evt_wave2_trucks)
end

function UI_StopFlashingTankDetect()
	UI_StopFlashing(flashID_tankDetect)
end

----------------- WAVE 3 ------------------
function Convoy_SetupThirdGroup()
	t_followingSquads = {}
	g_replacementEngineerCount = 0
	if SGroup_Count(sg_convoy) > 0 then
		SGroup_AddGroup(sg_convoyLeftover, sg_convoy)
		Cmd_MoveToAndDespawn(sg_convoyLeftover, mkr_convoyEnd, false)
		SGroup_Clear(sg_convoy)
	end
	Convoy_ChooseRandomPath()
	g_convoyStage = 3
	if g_difficulty ~= GD_HARD then
		Objective_Show(SOBJ_WaitingTime, false)
		Objective_Start(SOBJ_TargetFive)
		Objective_Start(SOBJ_TargetSix)
	end
	Util_CreateSquads(player2, {sg_convoy, sg_convoyTargets, sg_convoyKVs}, SBP.SOVIET.KV_1, mkr_convoySpawn01)
	Util_CreateSquads(player2, {sg_convoyTrucks, sg_convoyTruck_04, sg_convoy, sg_convoyTargets}, SBP.SOVIET.ZIS_6_TRANSPORT_TRUCK, mkr_convoySpawn02)
	
	Util_CreateSquads(player2, {sg_convoyKVs, sg_convoy, sg_convoyTargets}, SBP.SOVIET.KV_8, mkr_convoySpawn08)
	
	Util_CreateSquads(player2, {sg_convoyGuards, sg_convoySquads_05}, SBP.SOVIET.GUARDS_TROOPS, mkr_convoySpawn01, nil, nil, 4)	
	Util_CreateSquads(player2, {sg_convoyGuards, sg_convoySquads_06}, SBP.SOVIET.GUARDS_TROOPS, mkr_convoySpawn01, nil, nil, 4)
	Convoy_SGroupFollowVehicles(sg_convoyGuards)
	
	Util_CreateSquads(player2, {sg_convoyEngineer_04, sg_convoyEngineers}, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_convoySpawn05)
	
	SGroup_SetAutoTargetting(sg_convoyTrucks, "hardpoint_01", false)
		
	-- Slow vehicles to squad movement speed
	Modify_UnitSpeed(sg_convoyTrucks, t_difficulty.convoyLightMoveSpeedModifier)
	Modify_UnitSpeed(sg_convoyHalftracks, t_difficulty.convoyLightMoveSpeedModifier)
	Modify_UnitSpeed(sg_convoyKVs, t_difficulty.convoyHeavyMoveSpeedModifier)
	
	Cmd_Garrison(sg_convoyEngineer_04, sg_convoyTruck_04, nil, nil, true)
	
	--Make sure the convoy doesn't continue moving due to the last group still being on the map
	Convoy_StopMovement()
	if g_difficulty ~= GD_HARD then
		evt_wave3_kvs = Event_GroupIsDead(Convoy_Wave3_KVsDestroyed, nil, sg_convoyKVs)
		evt_wave3_truck = Event_GroupIsDead(Convoy_Wave3_TransportDestroyed, nil, sg_convoyTruck_04)
	else
		Util_ApplyModifier(sg_convoySquads_05, "posture_speed_modifier",  1, MUT_Addition)
		Util_ApplyModifier(sg_convoySquads_06, "posture_speed_modifier",  1, MUT_Addition)
		Util_ApplyModifier(sg_convoyEngineer_04, "posture_speed_modifier",  1, MUT_Addition)
	end
	Event_Proximity(Convoy_KillSquadsInMarker, {sgroup = sg_convoy, marker = mkr_convoyEnd}, sg_convoy, mkr_convoyEnd, 15, ANY)	
	
	Event_Timer(Convoy_BeginThirdGroup, nil, 5)
	if g_difficulty == GD_EASY then
		Rule_RemoveIfExist(Convoy_RevealSGroup)
	end
	if g_difficulty ~= GD_HARD then
		ThreatArrow_CreateGroup(sg_convoy)
	end
	
	if g_difficulty == GD_EASY or g_difficulty == GD_NORMAL then
		Player_SetResource(player1, RT_Command, 8)
		Cmd_InstantUpgrade(player1, UPG.GERMAN.LIGHT_ARTILLERY_SUPPORT)
		Player_AddAbility(player1, ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY)	
		Player_SetAbilityAvailability(player1, ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY, ITEM_UNLOCKED)
		flashID_arty = UI_FlashAbilityButton(ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY, true)
		Rule_AddOneShot(UI_StopFlashingArtyAbility, 6)
		if g_difficulty == GD_NORMAL then
			Modify_AbilityMunitionsCost(player1, ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY, 2)
		end
	end
	
	Convoy_HideConvoy()
	
end

function Convoy_TimerBeforeWave3()
	Objective_Show(SOBJ_TargetThree, false)
	Objective_Show(SOBJ_TargetFour, false)
	Objective_Show(SOBJ_WaitingTime, true)
	Objective_StartTimer(SOBJ_WaitingTime, COUNT_DOWN, (30 + t_difficulty.setupTimeBeforeWave3), 5)
end

function UI_StopFlashingArtyAbility()
	UI_StopFlashing(flashID_arty)
end

function Convoy_Wave3_KVsDestroyed()
	Objective_Complete(SOBJ_TargetFive)
	Event_Remove(evt_wave3_kvs)
end

function Convoy_Wave3_TransportDestroyed()
	Objective_Complete(SOBJ_TargetSix)
	Event_Remove(evt_wave3_truck)
end

--Repair Behaviour: enemy engineers will attempt to repair convoy vehicles that have received criticals

function Convoy_EngineersStartRepair(data)	
	if scartype(data.engineer) == ST_SGROUP and SGroup_Count(data.engineer) >= 1 then
		if SGroup_IsInHoldSquad(data.engineer, ALL) then
			Cmd_UngarrisonSquad(data.engineer)
			Event_Timer(Convoy_DelayEngineersStartRepair, {engineer = data.engineer, sgroup = data.sgroup}, 1)
		elseif not SGroup_IsDoingAbility(data.engineer, ABILITY.SOVIET.SOVIET_REPAIR_ABILITY, ANY) then
			if Prox_SGroupSGroup(data.engineer, data.sgroup, PROX_LONGEST) > 8  and not SGroup_IsMoving(data.engineer, ANY) then
				Cmd_Move(data.engineer, data.sgroup)
			else
				Cmd_Ability(data.engineer, ABILITY.SOVIET.SOVIET_REPAIR_ABILITY, data.sgroup, nil, true, nil)
			end
		end
		if Util_TableContains(t_followingSquads, data.engineer) == false then
			Convoy_SGroupFollowVehicles(data.engineer)
		end
	end
end

function Convoy_DelayEngineersStartRepair(data)
	if not SGroup_IsDoingAbility(data.engineer, ABILITY.SOVIET.SOVIET_REPAIR_ABILITY, ANY) then
		Cmd_Ability(data.engineer, ABILITY.SOVIET.SOVIET_REPAIR_ABILITY, data.sgroup, nil, true, nil)
	end
end

function Convoy_Begin()	
	Convoy_SetupFirstGroup()
	Objective_Show(SOBJ_WaitingTime, false)
	if g_difficulty ~= GD_HARD then
		Event_Timer(EventHandler_ObjectiveStart, {objective = SOBJ_TargetOne}, 2) 
		Event_Timer(EventHandler_ObjectiveStart, {objective = SOBJ_TargetTwo}, 8)
	end
	Event_Timer(EventHandler_StartIntel, {intel = EVENTS.Barricades}, 15) 
	if g_difficulty ~= GD_HARD then
		Rule_AddInterval(Convoy_PingWaypoint, 6)
	end
	Event_GroupIsDead(Convoy_SGroupFollowVehicles, {sgroup = sg_convoyEngineer_01}, sg_convoyTruck_01, 1)	
	
	Event_GroupIsDead(EventHandler_Retreat, {group = sg_convoyGuards, location = mkr_convoyEnd, deleteAtMarker = true}, sg_convoyTargets)
	Event_GroupIsDead(EventHandler_Retreat, {group = sg_convoyEngineer_01, location = mkr_convoyEnd, deleteAtMarker = true}, sg_convoyTargets)
	
	Convoy_StartMovement(sg_convoy)
	Rule_AddInterval(Convoy_KillNonConvoySquads, 5)

end

function Convoy_BeginSecondGroup()		
	
	Event_GroupIsDead(Convoy_SGroupFollowVehicles, {sgroup = sg_convoyEngineer_02}, sg_convoyTruck_02, 1)
	Event_GroupIsDead(Convoy_SGroupFollowVehicles, {sgroup = sg_convoyEngineer_03}, sg_convoyTruck_03, 1)
	
	Event_GroupIsDead(EventHandler_Retreat, {group = sg_convoyGuards, location = mkr_convoyEnd, deleteAtMarker = true}, sg_convoyTargets)
	Event_GroupIsDead(EventHandler_Retreat, {group = sg_convoyEngineer_02, location = mkr_convoyEnd, deleteAtMarker = true}, sg_convoyTargets)
	Event_GroupIsDead(EventHandler_Retreat, {group = sg_convoyEngineer_03, location = mkr_convoyEnd, deleteAtMarker = true}, sg_convoyTargets)

	Convoy_ResumeMovement()
	
	Util_StartIntel(EVENTS.OBJDestroySecondGroup)
end

function Convoy_BeginThirdGroup()		

	Event_GroupIsDead(Convoy_SGroupFollowVehicles, {sgroup = sg_convoyEngineer_03}, sg_convoyTruck_03, 1)
	
	Event_GroupIsDead(EventHandler_Retreat, {group = sg_convoyGuards, location = mkr_convoyEnd, deleteAtMarker = true}, sg_convoyTargets)
	Event_GroupIsDead(EventHandler_Retreat, {group = sg_convoyEngineer_03, location = mkr_convoyEnd, deleteAtMarker = true}, sg_convoyTargets)

	Convoy_ResumeMovement()
	
	Event_GroupIsDead(OBJ_DestroyConvoy_EndMission, nil, sg_convoy, 5)
	
	Util_StartIntel(EVENTS.OBJDestroyThirdGroup)
end


function Convoy_StartMovement(sgroup)
	--Used only to initialize convoy movement. After this "Convoy_ResumeMovement" should be used when the convoy is stopped
	Convoy_MovementHandler({convoyGroup = sgroup})
end

function Convoy_ResumeMovement()
	convoyIsStopped = false
end

function Convoy_StopMovement() 
	-- This technically will only cause the first vehicle to pause. This makes the stop more believable, and allows vehicles to catch up to one another
	Cmd_Stop(sg_convoy)
	convoyIsStopped = true
end

function Convoy_SGroupFollowVehicles(data)
	local sgroup = data
	if scartype(data) == ST_TABLE then
		sgroup  = data.sgroup
	end

	table.insert(t_followingSquads, sgroup)
end


---------- VEHICLE MOVEMENT --------------
-- Beware: This script is a gnarly Mitch/Sacha hybrid
-- The leading vehicle follows a Worldbuilder path
-- Following vehicles are issued move commands to a position behind the vehicle in front of them
-- Infantry squads are issued move commands to a position behind a convoy vehicle
-- If the leading vehicle receives a critical, the convoy will stop and attempt to repair the vehicle
-- Once all target vehicles are destroyed, convoy infantry will retreat off the map

function Convoy_MovementHandler(data)
	-- Setup the next tick for the movement handler. The time between ticks is important for smooth movement. 0.25 seems to work well, but it may require more tuning
	evt_convoyMovementHandler = Event_Timer(Convoy_MovementHandler, data, 1)
	
	--Only allow movement if there's a convoy to move
	if SGroup_IsAlive(data.convoyGroup) == false then
		return
	end
	
	-- Barricades
	if #t_barricades > 0 and t_allPaths ~= {"path5","path6"} then
		Convoy_CheckForBuiltBarricades()
	end
	
	-- See function below
	SGroup_ForEach(data.convoyGroup, Convoy_SetMovement)	
	
	-- Convoy infantry movement
	if convoyIsStopped ~= true then
		-- Grabs the closest vehicle to each squad following the convoy, and sets that squad to follow the vehicle
		if t_followingSquads ~= nil and table.getn(t_followingSquads) > 0 then
			for i = table.getn(t_followingSquads), 1, -1 do
				if SGroup_IsAlive(t_followingSquads[i]) then
					local vehicleToFollow = Util_GetClosestSquadInSGroup(t_followingSquads[i], sg_convoy)
					if SGroup_IsMoving(t_followingSquads[i], ALL) == false then
						if not SGroup_IsDoingAbility(t_followingSquads[i], ABILITY.SOVIET.SOVIET_REPAIR_ABILITY, ANY) then
							local dest = Util_GetOffsetPosition(vehicleToFollow, OFFSET_BACK, 5)
							if World_DistancePointToPoint(SGroup_GetPosition(t_followingSquads[i]), dest) > 6 then
								Cmd_Move(t_followingSquads[i], dest)  -- Squad_GetOffsetPosition(vehicleToFollow, Util_GetRelativeOffset(t_followingSquads[i], vehicleToFollow), 8)
							end
						end
					end
				else
					table.remove(t_followingSquads, i)
				end
			end
		end
	end
	
	-- Send in engineers to repair Convoy vehicles that have criticals
	-- Spawn replacement engineers, or abandon crippled vehicle if more engineers are not available
	g_damagedVehicle = nil
	local findDamagedVehicle = function (gid, idx, vehicle)
		if Squad_HasAnyCritical(vehicle) then
			g_damagedVehicle = vehicle
			return true
		end
	end
	SGroup_ForEach(sg_convoy, findDamagedVehicle)
	if g_damagedVehicle ~= nil and scartype(g_damagedVehicle) == ST_SQUAD then
		if SGroup_IsEmpty(sg_convoyEngineers) == false then
			SGroup_Clear(sg_tempConvoy)
			SGroup_Add(sg_tempConvoy, g_damagedVehicle)
			if Squad_IsMoving(g_damagedVehicle) then
				Cmd_Stop(sg_tempConvoy)
			end
			Convoy_EngineersStartRepair({engineer = sg_convoyEngineers, sgroup = sg_tempConvoy})
		elseif SGroup_IsEmpty(sg_convoyEngineers) and g_replacementEngineerCount < 1 then
			g_replacementEngineerCount = g_replacementEngineerCount + 1
			Util_CreateSquads(player2, sg_convoyEngineers, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_convoySpawn01)
		elseif SGroup_IsEmpty(sg_convoyEngineers) and g_replacementEngineerCount >= 1 then
			Util_StartIntel(EVENTS.Abandoned[g_abandonSpeechIndex])
			g_abandonSpeechIndex = g_abandonSpeechIndex + 1
			if g_abandonSpeechIndex > 3 then
				g_abandonSpeechIndex = 1
			end
			Cmd_CriticalHit(player1, g_damagedVehicle, CRIT.VEHICLE_ABANDON, 0)
		end
	end
end

-- Vehicle movement
-- The leading vehicle follows a path set in the Worldbuilder
-- The following vehicles move towards the leader
function Convoy_SetMovement(a, index, squad)
	SGroup_Clear(sg_tempConvoy)
	SGroup_Add(sg_tempConvoy, squad)
	local squadBehind = nil
	if index < SGroup_CountSpawned(sg_convoy) then
		squadBehind = SGroup_GetSpawnedSquadAt(sg_convoy, index + 1)
	end
	local squadAhead = nil
	if index > 1 then
		squadAhead = SGroup_GetSpawnedSquadAt(sg_convoy, index - 1)
	end
	if index == 1  then
		if Squad_IsValid(squad.id) and Util_TableContains(g_leaderSquads, squad.id) == false then
			table.insert(g_leaderSquads, squad.id)
			Modify_UnitSpeed(sg_tempConvoy, 0.95)
		end
		if g_notMovingTimer >= 10 then
			if Squad_IsMoving(squad) then
				g_notMovingTimer = 0
			elseif not Squad_HasAnyCritical(squad) then
				if g_notMovingTimer >= 20 then
					Cmd_Move(sg_tempConvoy, mkr_convoyEnd)
				else
					Cmd_SquadPath(sg_tempConvoy, g_convoyPath, true, LOOP_NONE, false, 0)
				end
			end
		elseif g_notMovingTimer < 10 and (Squad_IsMoving(squad) == false) then
			g_notMovingTimer = g_notMovingTimer + 1
			if Squad_HasAnyCritical(squad) == false then
				if squadBehind == nil or (squadBehind ~= nil and Util_GetDistance(sg_tempConvoy, squadBehind) < 28) then
					Cmd_SquadPath(sg_tempConvoy, g_convoyPath, true, LOOP_NONE, false, 0)
					g_notMovingTimer = 0
				end
			end
		elseif (squadBehind ~= nil and Util_GetDistance(sg_tempConvoy, squadBehind) > 25) then
			Cmd_Stop(sg_tempConvoy)
		end
	elseif index > 1 then	
		local squadToFollow = SGroup_GetSpawnedSquadAt(sg_convoy, index - 1)
		if g_notMovingTimer >= 10 and not Squad_HasAnyCritical(squad) and not Squad_IsMoving(squad) then	
			if g_notMovingTimer >= 45 then
				Cmd_Move(sg_tempConvoy, mkr_convoyEnd)
			elseif SGroup_IsEmpty(sg_convoyEngineers) then
				Cmd_SquadPath(sg_tempConvoy, g_convoyPath, true, LOOP_NONE, false, 0)
			end
		elseif Util_GetDistance(sg_tempConvoy, squadToFollow) < 10 or (squadBehind ~= nil and Util_GetDistance(sg_tempConvoy, squadBehind) > 25 and Squad_HasAnyCritical(squadBehind) == false) then
			Cmd_Stop(sg_tempConvoy)
		elseif (Squad_IsMoving(squadToFollow) and not Squad_HasAnyCritical(squadToFollow)) or Util_GetDistance(sg_tempConvoy, squadToFollow) > 15 then 
			if Squad_IsMoving(squad) == false and Squad_HasAnyCritical(squad) == false then
				Cmd_Move(sg_tempConvoy, Squad_GetOffsetPosition(squadToFollow, OFFSET_BACK, 5), nil, nil, Squad_GetPosition(squadToFollow))
			end
		end
	end
end

-- Barricades
-- The convoy will divert away from built barricades when they get close enough
-- The barricade forces the convoy to pick a new path set in the Worldbuilder
function Convoy_CheckForBuiltBarricades()

	for i = 1, #t_barricades do
		if i > #t_barricades then
			break
		end
		EGroup_Clear(eg_builtBarricade)
		World_GetNeutralEntitiesNearPoint(eg_builtBarricade, Marker_GetPosition(t_barricades[i]), 1)
		EGroup_Filter(eg_builtBarricade, BP_GetEntityBlueprint("rubble_barricade_double_convoy"), FILTER_KEEP)
		
		if not EGroup_IsEmpty(eg_builtBarricade) and not SGroup_IsEmpty(sg_convoy) then
			if Prox_AreSquadsNearMarker(sg_convoy, EGroup_GetPosition(eg_builtBarricade), ANY, 25) then
				if t_barricades[i] == mkr_barricadeLeftCenter then
					if g_convoyPath == "path2" then
						g_convoyPath = "path4"
						table.remove(t_barricades, i)
						Convoy_Divert()
					elseif g_convoyPath == "path4" then
						Convoy_ChooseRandomPath()
						table.remove(t_barricades, i)
						Convoy_Divert()
					end
				elseif t_barricades[i] == mkr_barricadeLeftTop and g_convoyPath == "path2" then
					Convoy_ChooseRandomPath("path2")
					table.remove(t_barricades, i)
					Convoy_Divert()
				elseif t_barricades[i] == mkr_barricadeRightTop and g_convoyPath == "path1" then
					g_convoyPath = "path5"
					table.remove(t_barricades, i)
					Convoy_Divert()
				elseif t_barricades[i] == mkr_barricadeRightCenter and (g_convoyPath == "path2" or g_convoyPath == "path3") then
					local removePath = function (index, path)
						if path == "path2" or path == "path3" then
							table.remove(t_allPaths, index)
						end
					end
					table.foreach(t_allPaths, removePath)
					g_convoyPath = "path5"
					table.remove(t_barricades, i)
					Convoy_Divert()
				end
			end
		end
	end
	
	if EGroup_IsEmpty(eg_allBarricades) then
		t_allPaths = {"path5","path6"}
	end
	
end

function Convoy_Divert()
	Util_StartIntel(EVENTS.PathBlocked[g_barricadeSpeechIndex])
	g_barricadeSpeechIndex = g_barricadeSpeechIndex + 1
	Cmd_Stop(sg_convoy)
end

-- Ping pre-placed vehicle wrecks for munitions scavenging
function Convoy_PingWrecks()
	if EGroup_IsEmpty(eg_wrecks) then
		return
	else
		local target = EGroup_GetRandomSpawnedEntity(eg_wrecks)
		UI_CreateMinimapBlip(target, 5, BT_General)
		Rule_RemoveMe()
		Rule_AddOneShot(Convoy_PingWrecks, World_GetRand(60, 120))
	end
end

-- Ping the convoy leader's current destination
function Convoy_PingWaypoint()
	HintPoint_Remove(hint_currentWaypoint)
	if SGroup_Count(sg_convoy) > 0 then
		local squad = SGroup_GetSpawnedSquadAt(sg_convoy, 1)
		if Squad_HasDestination(squad) then
			local dest = Squad_GetDestination(squad)
			local squadPos = Squad_GetPosition(squad)
			dest.y = Misc_GetTerrainHeight(dest) 
			if World_DistancePointToPoint(dest, Marker_GetPosition(mkr_convoyStart)) > 10 and World_DistancePointToPoint(dest, Marker_GetPosition(mkr_convoyDest)) > 10 then
				hint_currentWaypoint = HintPoint_Add(dest, true, 11051659, nil, HPAT_Bonus)
			end
		end
	end
end
	
	
-------------------------------------------------------------------------
-- UTILITIES --
-------------------------------------------------------------------------
function Util_GetClosestSquadInSGroup(var, sgroup) 

	local dist
	local closest = 99999
	local result

	local _check = function(a,b,squad)
		dist = World_DistancePointToPoint(Util_GetPosition(var), Util_GetPosition(squad))
		if dist < closest then
			closest = dist
			result = squad
		end
	end
	
	SGroup_ForEach(sgroup, _check)
	
	return result
end

function Convoy_KillSquadsInMarker(data)
	--Remove the event that counts vehicle deaths, so that it doesn't include these despawned vehicles
	Event_Remove(evt_objCounter)
	if g_convoyStage == 1 then
		if SGroup_ContainsSGroup(data.sgroup, sg_convoyHalftrack_01, ANY) then
			Event_Remove(evt_wave1_halftrack)
		elseif SGroup_ContainsSGroup(data.sgroup, sg_convoyTruck_01, ANY) then
			Event_Remove(evt_wave1_truck)
		elseif SGroup_ContainsSGroup(data.sgroup, sg_convoyT70, ANY) then
			Event_Remove(evt_wave1_t70)
		end
	elseif g_convoyStage == 2 then
		if SGroup_ContainsSGroup(data.sgroup, sg_convoyT34, ANY) then
			Event_Remove(evt_wave2_t34)
		elseif SGroup_ContainsSGroup(data.sgroup, sg_convoyTruck_02, ANY) then
			Event_Remove(evt_wave2_trucks)
		end
	elseif g_convoyStage == 3 then
		if SGroup_ContainsSGroup(data.sgroup, sg_convoyKVs, ANY) then
			Event_Remove(evt_wave3_kvs4)
		elseif SGroup_ContainsSGroup(data.sgroup, sg_convoyTruck_04, ANY) then
			Event_Remove(evt_wave3_truck)
		end
	end
	
	Player_GetAllSquadsNearMarker(player2, sg_tempConvoy, mkr_convoyEnd)
	
	if SGroup_ContainsSGroup(sg_tempConvoy, sg_convoyTargets, ANY) or g_difficulty == GD_HARD then
		OBJ_DestroyConvoy_ConvoyEscaped()
	elseif SGroup_Count(data.sgroup) > 0 then
		Event_Proximity(Convoy_KillSquadsInMarker, {sgroup = data.sgroup, marker = data.marker}, data.sgroup, data.marker, 15, ANY)
	end
	SGroup_DestroyAllInMarker(data.sgroup, data.marker)
end

function Convoy_KillNonConvoySquads()
	local player2Squads = Player_GetSquads(player2)
	SGroup_RemoveGroup(player2Squads, sg_convoy)
	if not SGroup_IsEmpty(player2Squads) then
		SGroup_DestroyAllInMarker(player2Squads, mkr_convoyEnd)
	end
end

-- HAXX
function SkipWave()
	SGroup_DestroyAllSquads(sg_convoy)
end
