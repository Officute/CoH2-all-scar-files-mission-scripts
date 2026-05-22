-------------------------------------------------------------------------
-- Act 1 - Mission 2
-- Scorched Earth
-- Designer: A.Molina
-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScarUtil.scar")
import("Systems/AiManager/ai.scar")
import("Prototype/DeploymentPoints.scar")
import("Beginner.scar")
import("Global_Values/CampaignGlobalConstants.scar")
import("Scorched_Earth_Encounters.scar")

-------------------------------------------------------------------------
-- [[ TUNABLE/Global VARIABLES ]]
-------------------------------------------------------------------------
function SetupData() 
	g_panSpeed = 0.3
	
	g_weaponAccuracy = Util_DifVar({0.2, 0.3, 0.3}, g_difficulty) -- "Harmless" units for flavour
	
	--Timings
	g_endHoldLine = Util_DifVar({75, 95, 150}, g_difficulty)
	g_endDefendTrucks = Util_DifVar({75, 96, 140}, g_difficulty)
	
	g_teachFlamethrowerDelay = 30
	
	--Burn fields
	g_hayThreshold = 0.75
	g_houseThreshold = 0.5
	g_flankNorthDelay = 60

	--The BP used for fire (this might change in the near future)
	g_bpFire = BP_GetEntityBlueprint("circle_of_fire")
	--Lists containing the fire entityID's
	g_firesNorth = {}
	g_firesSouth = {}

	--Defend trainyard
	g_Defend_waitAttack = Util_DifVar({130, 105, 75}, g_difficulty)
	g_mineCheckDelay = 60
	g_tankDeathThreshold = Util_DifVar({0.2, 0.4, 0.5}, g_difficulty)
	g_evacTime = 300 -- Time the evac lasts
	g_countEvac = 0.1
	g_vehicleSpeed = 0.88
	g_roadHTDelay = Util_DifVar({18, 11, 5}, g_difficulty)
	t_wreckEBPs = {
		BP_GetEntityBlueprint("wrecked_halftrack_sdkfz_251"), 
		BP_GetEntityBlueprint("wrecked_armored_car_sdkfz_222")
	}
	g_maxEntitiesBreach = Util_DifVar({8, 5, 4}, g_difficulty)
	
	g_modRetreatDamage = Util_DifVar({0.6, 0.8, 1}, g_difficulty)

	--The currently active objective. Updated on each Objective_start. Used in SkipObjective()
	m02_CurrentObjective = nil
end


-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------
function OnGameSetup()
	-- Required Players
	player1 = Setup_Player(1, 11038758, "soviet", 1)		-- player1 is always the human player
	player2 = Setup_Player(2, 11038759, "german", 2)		-- player2 is always the AI opponent
	player3 = Setup_Player(3, 11038758, "soviet", 1)		-- player3 is always the AI ally
end

function OnGameRestore()
	-- function takes care of restoring all global mission parameters after a save/load
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	
	Game_DefaultGameRestore()
end

-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------
function OnInit()
	--[[ PRESET DEBUG CONDITIONS ]]
	Mission_Debug()
	
	--[[ SET RESTRICTIONS ]]
	Mission_Restrictions()
	
	--[[ SET AI ]]
	Mission_CpuInit()
	
	--[[ SET DIFFICULTY ]]
	Mission_Difficulty()
	
	--[[Setup tunable data]]
	SetupData()
	
	--[[ MISSION PRESETS ]]
	Mission_MissionPreset()
	
	--[[ REGISTER OBJECTIVES ]]
	Initialize_ObjReinforce()
	Initialize_ObjDestroy()
	Initialize_ObjScorch()
	Initialize_ObjDefend()
	Initialize_ObjEscape()
	Initialize_ObjBonus()
	
	if(not g_debug) then
		--[[ PLAY INTRO NIS]]
		Game_FadeToBlack(FADE_OUT, 0)
		Util_StartNIS(EVENTS.NIS_Intro)
		
		--[[ GAME START CHECK ]]
		Rule_Add(Mission_MissionStart)
	else
		DEBUG_Beat_Selection_01()
	end
end
Scar_AddInit(OnInit)

function Mission_Debug()
	-- look for the command line option [-debug]
	g_debug = Misc_IsCommandLineOptionSet("debug")
	
	-- set up bindings
--~ 	Scar_DebugConsoleExecute("bind([[ALT+1]], [[Scar_DoString('Util_StartNIS(NIS_OPENING_BLEND)')]])")
end

function Mission_Restrictions()
	---------------------- [[PLAYER 1]] ----------------------------
	--[[Criticals]]
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("upgrade/campaign/disable_abandon_critical"))
	
	--[[Upgrades]]
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("mission02_upgrade"))
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("flamethrower_ability_upgrade"))
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("sp_mine_upgrade")) -- More powerful mines
	
	--[[Abilities]]
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.SOVIET_BARBED_WIRE_CUTTING_ABILITY, ITEM_REMOVED)
	Player_AddAbility(player1, ABILITY.SOVIET.FRONTOVIKI_CONSCRIPT_DISPATCH)
	Player_AddAbility(player1, ABILITY.SOVIET.PENAL_TROOP_DISPATCH_SP)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH, ITEM_LOCKED)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.FRONTOVIKI_CONSCRIPT_DISPATCH, ITEM_LOCKED)
	Player_AddAbility(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH) --Lock dispatch initially
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.SHOCK_TROOPS, ITEM_LOCKED) -- Prevents shocktroops from reinforcing at HQ
	
	
	--[[Availability]]
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.BARBED_WIRE_FIELD, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.M1937_152MM_ML_20_ARTILLERY, ITEM_REMOVED)
	Player_SetUpgradeAvailability(player1, UPG.SOVIET.ENGINEER_FLAMETHROWER, ITEM_REMOVED)
	Player_SetUpgradeAvailability(player1, UPG.SOVIET.ENGINEER_MINESWEEPER, ITEM_REMOVED)
	Player_SetUpgradeAvailability(player1, UPG.SOVIET.HQ_ANTI_TANK_GRENADE, ITEM_REMOVED)
	Player_SetConstructionMenuAvailability(player1, "tp_construction_soviet_engineer", ITEM_REMOVED)
	Player_SetConstructionMenuAvailability(player1, "tp_construction_soviet_conscripts", ITEM_REMOVED)
	
	
	--[[Resources]]
	--Start
	Player_SetResource(player1, RT_Manpower, 250)
	Player_SetResource(player1, RT_Munition, 70)
	Player_SetResource(player1, RT_Fuel, 15)
	Player_SetResource(player1, RT_Command, 1)
--~ 	Player_SetResource(player1, RT_SovietProgression, 1) 
	
	--Caps
	Player_SetPopCapOverride(player1, Util_DifVar({72, 60, 54}, g_difficulty))
	Modify_PlayerResourceCap(player1, RT_Manpower, 1251, MUT_Addition)
	Modify_PlayerResourceCap(player1, RT_Munition, 251, MUT_Addition)
	Modify_PlayerResourceCap(player1, RT_Fuel, 301, MUT_Addition)
	Modify_PlayerResourceCap(player1, RT_SovietProgression, 0, MUT_Multiplication)
	--Rates
	Modify_PlayerResourceRate(player1, RT_Munition, 2.1, MUT_Multiplication)
end

function Mission_CpuInit()
	---------------------- [[PLAYER 2]] ----------------------------
	--[[Upgrades]]
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("panzerfaust_slow"))
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("rifle_grenade_slow"))
	--[[Criticals]]
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("upgrade/campaign/disable_abandon_critical"))
	--[[Abilities]]
	Player_AddAbility(player2, ABILITY.GLOBAL.M01_MORTAR_SINGLE_PRECISE_HARMLESS)
	Player_AddAbility(player2, ABILITY.GLOBAL.STUKA_STRAFE_M02)
	Player_AddAbility(player2, BP_GetAbilityBlueprint("stuka_fake_strafe"))
	Player_AddAbility(player2, BP_GetAbilityBlueprint("stuka_fake_bombing_strike"))
	Player_AddAbility(player2, ABILITY.GLOBAL.STUKA_BOMBING_STRIKE_W_SMOKE)
	--[[Availability]]
	Player_SetAbilityAvailability(player2, ABILITY.GERMAN.GRENADIER_PANZERFAUST, ITEM_LOCKED)
	--[[Resources]]
	Player_SetResource(player2, RT_Munition, 2000)
	Player_SetResource(player2, RT_Fuel, 2000)
	
	
	
	---------------------- [[PLAYER 3]] ----------------------------
	--[[Upgrades]]
	Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("upgrade/campaign/disable_abandon_critical"))
	Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("flamethrower_ability_upgrade"))
	--[[Resources]]
	Player_SetResource(player3, RT_Munition, 2000)
	Player_SetResource(player3, RT_Fuel, 2000)
end

function Mission_Difficulty(diff)
	g_difficulty = diff or Game_GetSPDifficulty()
	AI_OverrideDifficulty(diff)
	Campaign_InitializeConstants(diff)
	print("********* DIFFICULTY: "..g_difficulty)
	
	--Modifiers
	t_modifiers = {
		pgren_bundled_timer = Modify_ProjectileDelayTime(player2, BP_GetEntityBlueprint("bundled_stielgranate_campaign"), CAMPAIGN_PGREN_BUNDLED_TIMER),
		dispatchLvl1 = Modify_AbilityRechargeTime(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH, CAMPAIGN_DISPATCH_COOLDOWN),
		dispatchLvl2 = Modify_AbilityRechargeTime(player1, ABILITY.SOVIET.FRONTOVIKI_CONSCRIPT_DISPATCH, CAMPAIGN_DISPATCH_COOLDOWN),
		dispatchLvl3 = Modify_AbilityRechargeTime(player1, ABILITY.SOVIET.PENAL_TROOP_DISPATCH_SP, CAMPAIGN_DISPATCH_COOLDOWN),
	}
	
	if(g_difficulty > GD_NORMAL) then
		Player_SetAbilityAvailability(player2, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY, ITEM_UNLOCKED)
	end
	
	g_diffVariableSBP = Util_DifVar({SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.GRENADIER_SQUAD}, g_difficulty)
	
	t_defaultGoalData_attackEasy = {
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 1,
				retryTimeSecs = 8,
				waitTimeSecs = 30,
			},
			{
				tacticType = TACTIC_Vehicle,
				priority = -1,
			},
			{
				tacticType = TACTIC_RushAtTarget,
				priority = -1,
			},
		},
	}
	
	t_defaultGoalData_attackHard = {
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 15,
				retryTimeSecs = 10,
				waitTimeSecs = 10,
			},
			{
				tacticType = TACTIC_Vehicle,
				priority = 10,
				retryTimeSecs = 10,
				waitTimeSecs = 20,
			},
			{
				tacticType = TACTIC_RushAtTarget,
				priority = 5,
				retryTimeSecs = 8,
				waitTimeSecs = 20,
			},
		},
	}
	
	AIAttackGoal_AdjustDefaultGoalData(Util_DifVar({t_defaultGoalData_attackEasy, {}, t_defaultGoalData_attackHard}, g_difficulty))
end

--[[ DEBUG ]]--
function DEBUG_Beat_Selection_01()
	UI_MessageBoxSetText(LOC("SELECT START"), LOC("Select the Mission beat to play"))
	UI_MessageBoxSetButton(DB_Button1, LOC("WITH INTRO"), LOC("Play intro"), "", true)
	UI_MessageBoxSetButton(DB_Button2, LOC("NO INTRO"), LOC("Don't play intro NIS"), "", true)
	UI_MessageBoxSetButton(DB_Button3, LOC("NO MISSION"), LOC("No mission logic"), "", true)
	UI_MessageBoxShow(DC_Default, DEV_SelectPhase_Menu_01)
end

function DEV_SelectPhase_Menu_01(button)
	if button == DB_Button1 then
		Game_FadeToBlack(FADE_OUT, 0)
		Util_StartNIS(EVENTS.NIS_Intro)
		Rule_Add(Mission_MissionStart)
	elseif button == DB_Button2 then
		SkipIntroCam()
		ClearIntro()
		Camera_MoveTo(mkr_intersectionCenter)
		Rule_AddOneShot(Obj1_DelayedStart, 1)
	elseif button == DB_Button3 then
		ClearEnemies()
		print("No mission!")
	end
end


-------------------------------------------------------------------------
-- MISSION Preset 
-------------------------------------------------------------------------
function Mission_MissionPreset()
	UI_SetSoviet227Visibility(false)

	Entity_SetOnFire(EGroup_GetSpawnedEntityAt(eg_burningHouse, 1)) --Set frontline houses on fire
	EGroup_SetInvulnerable(eg_burningHouse, true)
	Entity_SetOnFire(EGroup_GetSpawnedEntityAt(eg_burningHouse2, 1))
	EGroup_SetInvulnerable(eg_burningHouse2, true)
	
	
	--Civilians++ fleeing during intro setup
	SetupStartingRunners()
	
	
	--Starting player conscripts
	sg_startingCons1 = Util_CreateSquads(player1, "sg_startingCons1", SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_flameDest1)
	sg_startingCons2 = Util_CreateSquads(player1, "sg_startingCons2", SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_civilians2)
	mod_startCons1 = Modify_ReceivedDamage(sg_startingCons1, 0.35)
	mod_startCons2 = Modify_ReceivedDamage(sg_startingCons2, 0.35)
	sg_startingConscripts = SGroup_CreateIfNotFound("startingConscripts")
	SGroup_AddGroups(sg_startingConscripts, {sg_startingCons1, sg_startingCons2})
	
	
	--[[ FRONT LINE ]]
	--Attackers
	sg_frontLine = SGroup_CreateIfNotFound("frontLine")
	SetupFrontLineLeft() -- *_Encounters.scar file
	SetupFrontLineRight()
	
	
	--Frontline ShockTroops
	sg_shock1 = Util_CreateSquads(player3, "sg_shock1", SBP.SOVIET.SHOCK_TROOPS, mkr_sandbags1, nil, nil, 3)
	SGroup_IncreaseVeterancyRank(sg_shock1, 1, true)
	sg_shock2 = Util_CreateSquads(player3, "sg_shock2", SBP.SOVIET.SHOCK_TROOPS, mkr_sandbags2, nil, nil, (g_difficulty >= GD_HARD and 3 or nil))
	sg_frontSovietsL = SGroup_CreateIfNotFound("sg_frontSovietsL")
	SGroup_AddGroups(sg_frontSovietsL, {sg_shock1, sg_shock2})

	sg_shock3 = Util_CreateSquads(player3, "sg_shock3", SBP.SOVIET.SHOCK_TROOPS, mkr_sandbags3, nil, nil, 3)
	SGroup_IncreaseVeterancyRank(sg_shock3, 1, true)
	sg_shock4 = Util_CreateSquads(player3, "sg_shock4", SBP.SOVIET.SHOCK_TROOPS, mkr_sandbags4, nil, nil, (g_difficulty >= GD_HARD and 3 or nil))
	sg_frontSovietsR = SGroup_CreateIfNotFound("sg_frontSovietsR")
	SGroup_AddGroups(sg_frontSovietsR, {sg_shock3, sg_shock4})
	
	--No vet for front line squads. This modifier is removed once the player gains control of them.
	mod_noVetL = Util_ApplyModifier(sg_frontSovietsL, "received_experience_squad_modifier", 0, MUT_Multiplication)
	mod_noVetR = Util_ApplyModifier(sg_frontSovietsR, "received_experience_squad_modifier", 0, MUT_Multiplication)
	
	--Make ShockTroops units invulnerable initially
	SGroup_SetInvulnerable(sg_frontSovietsL, true)
	SGroup_SetInvulnerable(sg_frontSovietsR, true)
	
	
	--[[ FIELDS ]]
	FieldAllies()
	
	
	
	--[[ RESOURCES ]]
	eg_truck1 = EGroup_CreateIfNotFound("eg_truck1")
	Util_CreateEntities(player3, eg_truck1, EBP.SOVIET.US6_TRUCK, mkr_truck1, 1)
	eg_truck2 = EGroup_CreateIfNotFound("eg_truck2")
	Util_CreateEntities(player3, eg_truck2, EBP.SOVIET.US6_TRUCK, mkr_truck2, 1)
	
	eg_destroyVehicles = EGroup_CreateIfNotFound("eg_destroyVehicles")
	EGroup_AddEGroup(eg_destroyVehicles, eg_truck1)
	EGroup_AddEGroup(eg_destroyVehicles, eg_truck2)
	EGroup_SetSelectable(eg_destroyVehicles, false)
	
	--Vehicles
	EGroup_SetRecrewable(eg_destroyVehicles, false)
	Entity_SetHealth(EGroup_GetSpawnedEntityAt(eg_destroyVehicles, 1), 0.50)
	Entity_SetHealth(EGroup_GetSpawnedEntityAt(eg_destroyVehicles, 2), 0.50)
	Entity_ApplyCritical(EGroup_GetSpawnedEntityAt(eg_destroyVehicles, 1), CRIT.VEHICLE_ABANDON, 1.1)
	Entity_ApplyCritical(EGroup_GetSpawnedEntityAt(eg_destroyVehicles, 2), CRIT.VEHICLE_ABANDON, 1.1)
	EGroup_EnableUIDecorator(eg_destroyVehicles, false)
	EGroup_SetInvulnerable(eg_destroyVehicles, true)
	--M5 Halftrack
	Entity_ApplyCritical(EGroup_GetSpawnedEntityAt(eg_truck1, 1), CRIT.VEHICLE_DESTROY_ENGINE, 1.1)
	--Howitzers
	EGroup_SetRecrewable(eg_howitzers, false)
	Entity_SetHealth(EGroup_GetSpawnedEntityAt(eg_howitzers, 1), 0.7)
	Entity_SetHealth(EGroup_GetSpawnedEntityAt(eg_howitzers, 2), 0.7)
	EGroup_EnableUIDecorator(eg_howitzers, false)
	EGroup_SetInvulnerable(eg_howitzers, true)
	
	
	
	--[[ ALLIED ENGINEERS ]]
	sg_alliedEngineers = SGroup_CreateIfNotFound("sg_alliedEngineers")
	sg_allies1 = Util_CreateSquads(player3, "sg_allies1", SBP.SOVIET.M02_COMBAT_ENGINEER_SQUAD, mkr_engineers1)
	sg_allies2 = Util_CreateSquads(player3, "sg_allies2", SBP.SOVIET.M02_COMBAT_ENGINEER_SQUAD, mkr_engineers2)
	sg_allies3 = Util_CreateSquads(player3, "sg_allies3", SBP.SOVIET.M02_COMBAT_ENGINEER_SQUAD, mkr_engineers3)
	SGroup_AddGroups(sg_alliedEngineers, {sg_allies1, sg_allies2, sg_allies3})
	SGroup_EnableMinimapIndicator(sg_alliedEngineers, false)
	SGroup_SetSelectable(sg_alliedEngineers, false)
	--Loading train
	sg_allies4 = Util_CreateSquads(player3, "sg_allies4", SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_alliesTrain, nil, nil, 3)
	sg_allies5 = Util_CreateSquads(player3, "sg_allies5", SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_alliesTrain, nil, nil, 2)
	SGroup_EnableMinimapIndicator(sg_allies4, false)
	SGroup_EnableMinimapIndicator(sg_allies5, false)
	SGroup_SetSelectable(sg_allies4, false)
	SGroup_SetSelectable(sg_allies5, false)
	
	
	--Have engineers doing their loading animation
	Cmd_SquadPath(sg_allies1, "pth_load1", true, LOOP_TOGGLE_DIRECTION, false, 1.7)
	Cmd_SquadPath(sg_allies2, "pth_load2", true, LOOP_TOGGLE_DIRECTION, false, 1.2)
	Cmd_SquadPath(sg_allies3, "pth_load3", true, LOOP_TOGGLE_DIRECTION, false, 1.3)
	Cmd_SquadPath(sg_allies4, "pth_load4", true, LOOP_TOGGLE_DIRECTION, false, 1.1)
	Cmd_SquadPath(sg_allies5, "pth_load5", true, LOOP_TOGGLE_DIRECTION, false, 1.5)
	
	
	--[[ FOW ]]
	--First line
	FOW_RevealTerritory(player1, World_GetTerritorySectorID(EGroup_GetPosition(vp_fuel)), 5, false)
	FOW_RevealTerritory(player1, World_GetTerritorySectorID(EGroup_GetPosition(vp_motorPool)), 5, false)
	FOW_RevealArea(Marker_GetPosition(mkr_flankLeft1), 40, 5)
	--Fields
	FOW_RevealArea(Marker_GetPosition(mkr_fireSouth1), 40, -1)
	FOW_RevealArea(EGroup_GetPosition(vp_fieldRight), 40, -1)
	--Objective 3
	FOW_RevealTerritory(player1, World_GetTerritorySectorID(EGroup_GetPosition(eg_hq)), -1, false)
	FOW_RevealTerritory(player1, World_GetTerritorySectorID(EGroup_GetPosition(vp_center)), -1, false)
	FOW_RevealTerritory(player1, World_GetTerritorySectorID(EGroup_GetPosition(vp_houses)), -1, false)
	FOW_RevealArea(Util_GetPosition(mkr_bridgeObj), 50, -1)
	

	
	--[[ EXPLOSIVES ]]
	t_demoMarkers = Marker_GetSequence("mkr_bomb")
	t_demopacks = {}
	for k,mkr in pairs(t_demoMarkers) do
		local egroup = EGroup_CreateIfNotFound("eg_demopack"..k)
		Util_CreateEntities(player3, egroup, BP_GetEntityBlueprint("demo_charge_fake_sp"), mkr, 1)
		table.insert(t_demopacks, egroup)
		EGroup_EnableUIDecorator(egroup, false)
		EGroup_SetSelectable(egroup, false)
	end
	
	
	
	--[[ TRAINYARD ]]
	--Train
	EGroup_DestroyAllEntities(eg_trainWB) --Remove the train placed in WB
	eg_train = EGroup_CreateIfNotFound("eg_train")
	local id = Entity_CreateENV(EBP.SOVIET.STEAM_TRAIN, Util_GetPosition(mkr_trainSpawn), Util_GetPosition(mkr_trainDestination))
	EGroup_Add(eg_train, id)
	EGroup_SetAnimatorState(eg_train, "supplies_loaded", "half")
	EGroup_SetSelectable(eg_train, false)
	EGroup_SetInvulnerable(eg_train, true)
	
	--Allied Tanks
	sg_t70 = Util_CreateSquads(player3, "sg_t70", SBP.SOVIET.T_70M, mkr_t70)
	sg_t34_1 = Util_CreateSquads(player3, "sg_t34_1", SBP.SOVIET.T_34_76_SQUAD, mkr_t34_1)
	sg_t34_2 = Util_CreateSquads(player3, "sg_t34_2", SBP.SOVIET.T_34_76_SQUAD, mkr_t34_2)
	
	sg_tanks = SGroup_CreateIfNotFound("sg_tanks")
	t_tanks = {sg_t70, sg_t34_1, sg_t34_2}
	SGroup_AddGroups(sg_tanks, t_tanks)
	SGroup_SetInvulnerable(sg_tanks, true) --Tanks start off invulnerable to prevent errors.
	
	SGroup_SetAutoTargetting(sg_tanks, "hardpoint_01", false) --Disable weapons on parked tanks and make them uncrewable
	SGroup_SetRecrewable(sg_tanks, false)
	_ModifySpeed(sg_tanks, 0.8)
	_DisableInteraction(sg_tanks)
	
	
	
	--[[ MISC ]]
	--Flamethrowers
	EGroup_SetSelectable(eg_flamethrowers, false)
	EGroup_EnableUIDecorator(eg_flamethrowers, false, false)
	--Haystack invulnerability
	EGroup_SetInvulnerable(eg_hay1, true)
	EGroup_SetInvulnerable(eg_hay2, true)
	--Prevent bridges from being destroyed by Player
	EGroup_SetSelectable(eg_trainBridge, false)
	EGroup_SetInvulnerable(eg_trainBridge, true)
	EGroup_SetSelectable(eg_bridge, false)
	EGroup_SetInvulnerable(eg_bridge, true)
	--BurnHouses invulnerability
	EGroup_SetInvulnerable(eg_burnHouses, true)
	--Trainyard garrison
	Modify_DisableHold(eg_disableHold, true)
	
	
	--HQ setup
	EGroup_SetRallyPoint(eg_hq, mkr_rallyPoint)
	EGroup_SetSelectable(eg_hq, false)
	
	--Supply trucks
	SGroup_SetWorldOwned(sg_supplyTrucks)
	Modify_DisableHold(sg_supplyTrucks, true)
	SGroup_EnableUIDecorator(sg_supplyTrucks, false)
	SGroup_EnableMinimapIndicator(sg_supplyTrucks, false)
	SGroup_SetAnimatorState(sg_supplyTrucks, "supplies_loaded", "partial")
	_ModifySpeed(sg_supplyTrucks, 0.7)
	--Trainyard trucks
	SGroup_SetAnimatorState(sg_trainyardTrucks, "supplies_loaded", "partial")
	_ModifySpeed(sg_trainyardTrucks, 0.7)
	
	
	-- for merge hints AFTER the first objective
	sg_mergehints = SGroup_CreateIfNotFound("sg_mergehints")
	sg_reinforcehints = SGroup_CreateIfNotFound("sg_reinforcehints")
end

function SetupStartingRunners()
	sg_introTrucks = SGroup_CreateIfNotFound("sg_introTrucks")
	Util_CreateSquads(player3, sg_introTrucks, SBP.SOVIET.US6_TRUCK_SQUAD, mkr_introTruck1)
	Util_CreateSquads(player3, sg_introTrucks, SBP.SOVIET.US6_TRUCK_SQUAD, mkr_introTruck2)
	Util_CreateSquads(player3, sg_introTrucks, SBP.SOVIET.US6_TRUCK_SQUAD, Marker_GetPosition(mkr_startUnit), nil, nil, nil, nil, nil, nil, Marker_GetPosition(mkr_intersectionCenter))
	SGroup_SetAnimatorState(sg_introTrucks, "supplies_loaded", "full") -- empty/partial/half/majority/full
	_DisableInteraction(sg_introTrucks)

	sg_introSquad1 = Util_CreateSquads(player3, "sg_introSquad1", SBP.SOVIET.CONSCRIPT_SQUAD, mkr_rallyPoint)
		Util_CreateSquads(player3, sg_introSquad1, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_spawn2)
--~ 		Util_CreateSquads(player3, sg_introSquad1, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_spawn5)
		Util_CreateSquads(player3, sg_introSquad1, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_trainLoad)
	_DisableInteraction(sg_introSquad1)
	
	sg_introSquad2 = Util_CreateSquads(player3, "sg_introSquad2", SBP.SOVIET.COMBAT_ENGINEER_SQUAD, trg_roadMain)
		Util_CreateSquads(player3, sg_introSquad2, BP_GetSquadBlueprint("m02_refugee_squad"), mkr_civilians1)
	_DisableInteraction(sg_introSquad2)
	
	sg_civilians = SGroup_CreateIfNotFound("sg_civilians")
	Util_CreateSquads(player3, sg_civilians, BP_GetSquadBlueprint("m02_refugee_squad"), mkr_burnHouse6, nil, nil, 4)
	Util_CreateSquads(player3, sg_civilians, BP_GetSquadBlueprint("m02_refugee_squad"), mkr_civilians4, nil, nil, 4)
	Util_CreateSquads(player3, sg_civilians, BP_GetSquadBlueprint("m02_refugee_squad"), mkr_civilians1)
	_DisableInteraction(sg_civilians)
	SGroup_SetMoodMode(sg_civilians, MM_ForceCalm)
	
	sg_civilians2 = SGroup_CreateIfNotFound("sg_civilians2")
--~ 	Util_CreateSquads(player3, sg_civilians2, BP_GetSquadBlueprint("m02_refugee_squad"), mkr_line1, nil, nil, 5)
	Util_CreateSquads(player3, sg_civilians2, BP_GetSquadBlueprint("m02_refugee_squad"), mkr_engineers1)
	_DisableInteraction(sg_civilians2)
	SGroup_SetMoodMode(sg_civilians2, MM_ForceCalm)
	
	sg_civiliansTown = SGroup_CreateIfNotFound("sg_civiliansTown")
	Util_CreateSquads(player3, sg_civiliansTown, BP_GetSquadBlueprint("m02_refugee_squad"), mkr_flameDest1, nil, nil, 4)
	Util_CreateSquads(player3, sg_civiliansTown, BP_GetSquadBlueprint("m02_refugee_squad"), mkr_introTruck3, nil, nil, 5)
--~ 	Util_CreateSquads(player3, sg_civiliansTown, BP_GetSquadBlueprint("m02_refugee_squad"), mkr_engineers2)
	Util_CreateSquads(player3, sg_civiliansTown, BP_GetSquadBlueprint("m02_refugee_squad"), mkr_engineers3)
	_DisableInteraction(sg_civiliansTown)
	SGroup_SetMoodMode(sg_civiliansTown, MM_ForceCalm)
	
	sg_civiliansHouse = Util_CreateSquads(player3, "sg_civiliansHouse", BP_GetSquadBlueprint("m02_refugee_squad"), EGroup_GetPosition(eg_house1))
	_DisableInteraction(sg_civiliansHouse)
	SGroup_SetMoodMode(sg_civiliansHouse, MM_ForceCalm)
	
	t_introUnits = {sg_introTrucks, sg_introSquad1, sg_introSquad2, sg_civilians, sg_civilians2, sg_civiliansTown}
end



-------------------------------------------------------------------------
-- MISSION START/END
-------------------------------------------------------------------------
function Mission_MissionStart()
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		
		Rule_AddInterval(_CheckHQ, 3)
		Rule_AddPlayerEvent(_CheckMinePlacement, player1, GE_ConstructionComplete)
		
		-- update groups for merge hints
		Rule_AddInterval(Mission_UpdateHintGroups, 30)
		UI_SetCPMeterVisibility(false)
		
		--Music
		Sound_PlayMusic("streamed/music/missions/m02/m02_cue_start_defend_front_line", 0, 0)
		
		Game_FadeToBlack(FADE_IN, 0.5)
		Util_StartNislet(EVENTS.NIS_Setup, SkipIntroCam, true)
		
		Rule_AddDelayedInterval(Mission_StartSitRep, 2, 0.5)
	end
end

function SkipIntroCam()
	print("#Skipping Intro camera NISlet...")
	Game_EndTextTitleFade()
	Subtitle_EndCurrentSpeech()
	
	SGroup_WarpToMarker(sg_startingCons1, mkr_startUnit)
	SGroup_WarpToMarker(sg_startingCons2, mkr_intersectionCenter)
	
	SGroup_DestroyAllSquads(sg_civilians2)
	SGroup_DestroyAllSquads(sg_civiliansTown)
	SGroup_DestroyAllSquads(sg_introTrucks)
end

function Mission_StartSitRep()
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		Util_PlayMovie("m02_sitrep", 0, 2, _ResetCamera, nil, true)
		Rule_AddDelayedInterval(Obj1_DelayedStart, 1.5, 1)
	end
end

function Mission_MissionFail()
	if(not Rule_Exists(Mission_MissionEnd)) then
		g_win = false
		Rule_AddDelayedInterval(Mission_MissionEnd, 1.5, 1)
	end
end

function Mission_MissionComplete()
	if(not Misc_IsCommandLineOptionSet("nomovies")) then
		Util_StartNIS(EVENTS.NIS_End)
	end
	
	if(not Objective_IsFailed(OBJ_Bonus)) then
		Objective_Complete(OBJ_Bonus, false)
	end
	
	if(not Rule_Exists(Mission_MissionEnd)) then
		g_win = true
		Rule_AddDelayedInterval(Mission_MissionEnd, 1.5, 1)
	end
end

function Mission_MissionEnd()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		Game_EndSP(g_win)
	end
end




function Mission_UpdateHintGroups()

	local conscripts = {
		SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
		SBP.SOVIET.CONSCRIPT_SQUAD,
		SBP.SOVIET.PENAL_BATTALION,
	}
	Player_GetAll(player1, sg_mergehints)
	SGroup_Filter(sg_mergehints, conscripts, FILTER_KEEP)
	
	
	local infantry = {}
	local _add = function(k, v) table.insert(infantry, v) end
	table.foreach(LIST.INFANTRY, _add)
	table.foreach(LIST.ATGUNS, _add)
	table.foreach(LIST.HMGS, _add)
	
	Player_GetAll(player1, sg_reinforcehints)
	SGroup_Filter(sg_reinforcehints, infantry, FILTER_KEEP)


end




-- LOCDB CREATE  MISSION "M02" SCENE "TEXT"
--[[********************************************************************************************************]]
------------------------------------------ OBJECTIVE 1 - Reinforce -------------------------------------------
--[[********************************************************************************************************]]
function Initialize_ObjReinforce()
	OBJ_Reinforce = {
		SetupUI = nil,
		
		OnStart = function()
			--Update current objective
			m02_CurrentObjective = OBJ_Reinforce
			
			for k, sObj in pairs(OBJ_Reinforce.subObjectives) do
				if(sObj.onParentStart) then
					Objective_Start(sObj, false)
				end
			end
			
			--Light mortarts hitting front line
			Rule_AddInterval(LightMortarsL, 12)
			Rule_AddDelayedInterval(LightMortarsR, 2, 13)
			
			--Increase frontline threat
			Event_ElementOnScreen(IncreaseThreatLeft, nil, player1, sg_frontSovietsL, ANY, 0.90, 1)
			Event_ElementOnScreen(IncreaseThreatRight, nil, player1, sg_frontSovietsR, ANY, 0.90, 1)
			
			--Setup wave1 prox-checks
			event_frontline = Event_Proximity(Obj1_UnlockFrontLine, nil, player1, trg_frontLine, nil, ANY)
			
			Rule_AddDelayedInterval(Obj1_WarnFail, 30, 3)
			
			Rule_AddDelayedInterval(Obj1_CheckCompletion, 5, 1)
		end,
		
		OnComplete = function()
			Rule_AddInterval(Destroy_DelayedStart, 0.5)
			Rule_Remove(Obj1_WarnFail)
		end,
		
		OnFail = function()
			Rule_RemoveAll()
			Game_SetMode(UI_Cinematic)
			if(g_win == nil and not Rule_Exists(Mission_MissionFail)) then Rule_AddOneShot(Mission_MissionFail, 2) end
		end,
		
		IsComplete = function()
			return Objective_IsComplete(SOBJ_Merge) and Objective_IsComplete(SOBJ_HoldLine) and Objective_IsComplete(SOBJ_DefendTrucks)
		end,
		
		IsFailed = function()
			return Objective_IsFailed(SOBJ_Merge) or Objective_IsFailed(SOBJ_HoldLine) or Objective_IsFailed(SOBJ_DefendTrucks)
		end,
		
		subObjectives = {},
		
		Intel_Start = EVENTS.Obj1_Intro,
		Intel_Complete = nil,
		Intel_Fail = nil,
		Title =  11042796, -- LOCDB [11042796] 'Defend the front line'
		TitleEnd = nil,
--~ 		TitleEnd = 11042797, -- LOCDB [11042797] 'Front line defended'
		TitleFail = nil,
--~ 		TitleFail = 11042798, -- LOCDB [11042798] 'The Germans have breached the front line'
		Type = OT_Primary,
	}
	
	
	--[[ Sub-objectives ]]
	SOBJ_Merge = { --Reinforce squads
		SetupUI = function()			
			hpid_pingMergeL = Objective_AddUIElements(SOBJ_Merge, mkr_frontLineL, true, nil, false)
			hpid_pingMergeR = Objective_AddUIElements(SOBJ_Merge, mkr_frontLineR, true, nil, false)
		end,
		
		OnStart = function()
			t_reinforceSquads = {}
			t_reinforceSquads.left = {
				{
					squad = sg_shock1,
					coverPos = mkr_sandbags1,
					reinforced = false,
					ui = Objective_AddUIElements(SOBJ_Merge, sg_shock1, false, 11042800, true) -- LOCDB [11042800] 'Merge Conscripts into squad to reinforce',
				},
			}
			t_reinforceSquads.right = {
				{
					squad = sg_shock3,
					coverPos = mkr_sandbags3,
					reinforced = false,
					ui = Objective_AddUIElements(SOBJ_Merge, sg_shock3, false, 11042800, true),
				},
			}
			
			if(g_difficulty >= GD_HARD) then
				local squad2 = {
					squad = sg_shock2,
					coverPos = mkr_sandbags2,
					reinforced = false,
					ui = Objective_AddUIElements(SOBJ_Merge, sg_shock2, false, 11042800, true)
				}
				
				local squad4 = {
					squad = sg_shock4,
					coverPos = mkr_sandbags4,
					reinforced = false,
					ui = Objective_AddUIElements(SOBJ_Merge, sg_shock4, false, 11042800, true)
				}
				
				table.insert(t_reinforceSquads.left, squad2)
				table.insert(t_reinforceSquads.right, squad4)
			end
			
			--Counter
			SOBJ_Merge.maxCounter = #t_reinforceSquads.left + #t_reinforceSquads.right
			Objective_SetCounter(SOBJ_Merge, 0, SOBJ_Merge.maxCounter)
		
			SGroup_SetInvulnerable(g_enc_frontRight.sgroup, false)
			SGroup_SetInvulnerable(g_enc_frontLeft.sgroup, false)
			
			Util_StartIntel(EVENTS.Merge_TeachMerge)
			
			if(g_difficulty <= GD_NORMAL) then
				for i=1, SGroup_CountSpawned(sg_startingConscripts) do
					local squad = SGroup_GetSpawnedSquadAt(sg_startingConscripts, i)
					local hint_conscripts = HintPoint_Add(squad, true, 11049987) -- LOCDB [11049987] 'Conscript Squad'
					Event_IsSelected(EventHandler_RemoveHint, {hint = hint_conscripts}, sg_startingConscripts, ANY, 1.5)
				end
			end
		
			--Reminder - in case the player sits around doing nothing
			Rule_AddDelayedInterval(Merge_Reminder, 60, 60)
		end,
		
		OnComplete = function()
			Rule_Remove(Merge_Reminder)
		
			Modifier_Remove(mod_shockL)
			Modifier_Remove(mod_shockR)
			
			SGroup_SetPlayerOwner(sg_frontSovietsL, player1)
			SGroup_SetPlayerOwner(sg_frontSovietsR, player1)
			
			--Allow player to reinforce shocktroops normally.
			Player_SetSquadProductionAvailability(player1, SBP.SOVIET.SHOCK_TROOPS, ITEM_DEFAULT)
			
			Objective_Start(SOBJ_HoldLine)
			
			BeginnerHint_AddOpportunity(sg_mergehints, HINT_MERGE, true)		-- the beginner hint system will take care of future hints about merging
		end,
		
		OnFail = function()
			if(SOBJ_HoldLine.IsFailed()) then
				Util_StartIntel(EVENTS.Obj1_FailHold)
			end
		end,
		
		IsComplete = function()
			for i,side in pairs(t_reinforceSquads) do
				for k,unit in pairs(side) do
					if(SGroup_CountSpawned(unit.squad) > 0) then
						local squad = SGroup_GetSpawnedSquadAt(unit.squad, 1)
						for i=0, Squad_Count(squad)-1 do
							local entity = Squad_EntityAt(squad, i)
							if(Entity_IsSpawned(entity) and Entity_GetBlueprint(entity) == EBP.SOVIET.BASE_CONSCRIPT_SOLDIER) then
								Objective_RemoveUIElements(SOBJ_Merge, unit.ui)
								table.remove(side, k)
								Objective_SetCounter(SOBJ_Merge, Objective_GetCounter(SOBJ_Merge)+1, SOBJ_Merge.maxCounter)
								break
							end
						end
					end
				end
			end
			
			if(#t_reinforceSquads.left == 0) then Objective_RemoveUIElements(SOBJ_Merge, hpid_pingMergeL) end
			if(#t_reinforceSquads.right == 0) then Objective_RemoveUIElements(SOBJ_Merge, hpid_pingMergeR) end
			
			return #t_reinforceSquads.left + #t_reinforceSquads.right == 0
		end,
		
		IsFailed = function()
			if(g_difficulty < GD_HARD) then
				return SGroup_CountSpawned(sg_startingConscripts) == 0
						or SGroup_CountSpawned(sg_shock1) == 0 
						or SGroup_CountSpawned(sg_shock3) == 0
						or SOBJ_HoldLine.IsFailed()
			else		
				return SGroup_CountSpawned(sg_startingConscripts) == 0
						or SGroup_CountSpawned(sg_frontSovietsL) < 2
						or SGroup_CountSpawned(sg_frontSovietsR) < 2
						or SOBJ_HoldLine.IsFailed()
			end
		end,
		
		Intel_Start = nil,
		Intel_Complete = nil,
		Intel_Fail = EVENTS.Merge_Fail,
		Title =  11046796, -- LOCDB [11046796] 'Use Conscript's 'Merge' ability to reinforce Shock Troops'
		TitleEnd = nil,
--~ 		TitleFail = 11042801, -- LOCDB [11042801] 'Reinforcements have been killed'
		TitleFail = 11048699, -- LOCDB [11048699] 'Shock Troops could not be reinforced'
		Type = OT_Primary,
		onParentStart = true,
		Parent = OBJ_Reinforce,
	}
	
	
	SOBJ_HoldLine = { --Hold the front line
		SetupUI = function()
			hpid_holdLineR = Objective_AddUIElements(SOBJ_HoldLine, mkr_frontLineR, true, 11042802, true, 1.5) -- LOCDB [11042802] 'Prevent German advance'
			hpid_holdLineL = Objective_AddUIElements(SOBJ_HoldLine, mkr_frontLineL, true, 11042802, true, 1.5)
		end,
		
		OnStart = function()
			Modifier_Remove(mod_startCons1)
			Modifier_Remove(mod_startCons2)

			--Beginner hints
			bhid_grenade1 = BeginnerHint_AddOpportunity(g_enc_frontLeft.sgroup, ABILITY.SOVIET.RG_42_ANTI_PERSONNEL_GRENADE, false, 11042803, "Icons_abilities_ability_soviet_rg_42_grenade") -- LOCDB [11042803] 'Use grenades against enemy clusters'
			bhid_grenade2 = BeginnerHint_AddOpportunity(g_enc_frontRight.sgroup, ABILITY.SOVIET.RG_42_ANTI_PERSONNEL_GRENADE, false, 11042803, "Icons_abilities_ability_soviet_rg_42_grenade")

			if(g_difficulty <= GD_NORMAL) then
				Rule_AddDelayedInterval(HintCover, 15, 2)
			end
			
			Rule_AddInterval(Bonus_DelayedStart, 4)
			Rule_AddInterval(RemindConscripts, 19)
			
			Rule_AddOneShot(EndHoldLine, g_endHoldLine)
		end,
		
		OnComplete = function()
			--Stop frontline beginner hints
			BeginnerHint_RemoveOpportunity(bhid_grenade1)
			BeginnerHint_RemoveOpportunity(bhid_grenade2)
			
			Util_StartIntel(EVENTS.GermanFallback)
			
			--Make the frontline attackers retreat
			--Left side
			g_enc_frontLeft:Disable()
			for k, unit in pairs(g_enc_frontLeft.units) do
				if(SGroup_Count(unit.sgroup) > 0) then
					Cmd_Retreat(unit.sgroup, Util_GetOffsetPosition(unit.sgroup, OFFSET_BACK, 30), nil, nil, true)
				end
			end
			if(SGroup_Count(sg_harmlessLeft) > 0) then
				Cmd_Retreat(sg_harmlessLeft, mkr_espawn1, mkr_espawn1)
			end

			
			--Right side
			g_enc_frontRight:Disable()
			for k, unit in pairs(g_enc_frontRight.units) do
				if(SGroup_Count(unit.sgroup) > 0) then
					Cmd_Retreat(unit.sgroup, Util_GetOffsetPosition(unit.sgroup, OFFSET_BACK, 30), nil, nil, true)
				end
			end
			if(SGroup_Count(sg_harmlessRight) > 0) then
				Cmd_Retreat(sg_harmlessRight, mkr_espawn3, mkr_espawn3)
			end
			
			
			Rule_AddInterval(StukasIntro, 1)
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		IsFailed = function()
			return Util_GetPlayerOwner(vp_fuel) == player2 and Util_GetPlayerOwner(vp_motorPool) == player2
		end,
		
		Intel_Start = EVENTS.Obj1_StartHold,
		Intel_Complete = nil,
		Intel_Fail = EVENTS.Obj1_FailHold,
		Title =  11042804, -- LOCDB [11042804] 'Prevent the Germans from advancing'
		TitleEnd = nil,
		TitleFail = 11048700, -- LOCDB [11048700] 'Front line territories have been lost'
		Type = OT_Primary,
		onParentStart = false,
		Parent = OBJ_Reinforce,
	}
	
	
	SOBJ_DefendTrucks = { --Fallback and defend the trucks
		SetupUI = function()
			hpid_trucksR = Objective_AddUIElements(SOBJ_DefendTrucks, sg_supplyTruck3, true, 11042805, true, 1.25) -- LOCDB [11042805] 'Protect supply trucks'
			hpid_trucksL1 = Objective_AddUIElements(SOBJ_DefendTrucks, sg_supplyTruck1, false, 11042805, true, 1.25)
			hpid_trucksL2 = Objective_AddUIElements(SOBJ_DefendTrucks, sg_supplyTruck2, true, 11042805, true, 2)
		end,
		
		OnStart = function()
			--Remove forward spawns
			EGroup_DeSpawn(eg_forwardEntry1)
			SGroup_SetSuppression( Player_GetSquads(player1), 0.0 )
			
			Event_Timer(EventHandler_StartIntel, {intel_callback = EVENTS.SetupDefensive}, 2)
			
			--Enable trucks
			SGroup_SetPlayerOwner(sg_supplyTrucks, player1)
			SGroup_SetSelectable(sg_supplyTrucks, false)
			SGroup_EnableUIDecorator(sg_supplyTrucks, true)
			SGroup_EnableMinimapIndicator(sg_supplyTrucks, true)
			
			--Fallback hints
			local hpid_defendTrucksR = HintPoint_Add(mkr_terrMotorPool, true, 11047649) -- LOCDB [11047649] 'Defend this position'
			local hpid_defendTrucksL = HintPoint_Add(mkr_terrFuel, true, 11047649)
			Event_ElementOnScreen(_RemoveHintPoint, {hpid = hpid_defendTrucksR}, player1, mkr_terrMotorPool, ANY, 0.7, 9.0)
			Event_ElementOnScreen(_RemoveHintPoint, {hpid = hpid_defendTrucksL}, player1, mkr_terrFuel, ANY, 0.7, 9.0)
			
			if(g_difficulty <= GD_NORMAL) then
				Rule_AddOneShot(HintGarrisons, 35)
			end
			Rule_AddOneShot(UpdateTruckCargo1, g_endDefendTrucks * 1/3)
			Rule_AddOneShot(UpdateTruckCargo2, g_endDefendTrucks * 2/3)
			Rule_AddOneShot(UpdateTruckCargo3, g_endDefendTrucks - 10)
			
			Rule_AddOneShot(EndDefendTrucks, g_endDefendTrucks)
		end,
		
		OnComplete = function()
			Modifier_Remove(mod_suppression)
			
			HintPoint_Remove(hpid_garrison1)
			HintPoint_Remove(hpid_garrison2)
			HintPoint_Remove(hpid_garrison3)
		end,
		
		OnFail = function()
			Rule_Remove(HintGarrisons)
			Rule_Remove(UpdateTruckCargo1)
			Rule_Remove(UpdateTruckCargo2)
			Rule_Remove(UpdateTruckCargo3)
			Rule_Remove(EndDefendTrucks)
		end,
		
		IsComplete = function()
			return false
		end,
		
		IsFailed = function()
			--Fails if any of the trucks are destroyed or damaged
			return SGroup_CountSpawned(sg_supplyTrucks) < 3 or SGroup_HasCritical(sg_supplyTrucks, CRIT.VEHICLE_DESTROY_ENGINE, ANY)
		end,
		
		Intel_Start = EVENTS.Obj1_EndHold,
		Intel_Complete = EVENTS.Obj1_Complete,
		Intel_Fail = EVENTS.FailTrucks,
		Title =  11042806, -- LOCDB [11042806] 'Protect the supply trucks until they depart'
		TitleEnd = nil,
		TitleFail = 11048701, -- LOCDB [11048701] 'Supply trucks have been critically damaged'
		Type = OT_Primary,
		onParentStart = false,
		Parent = OBJ_Reinforce,
	}
	
	
	table.insert(OBJ_Reinforce.subObjectives, SOBJ_Merge)
	table.insert(OBJ_Reinforce.subObjectives, SOBJ_HoldLine)
	table.insert(OBJ_Reinforce.subObjectives, SOBJ_DefendTrucks)
	
	Objective_Register(OBJ_Reinforce)
	for k, obj in pairs(OBJ_Reinforce.subObjectives) do
		Objective_Register(obj)
	end
end

--[[ Intro ]]
function Obj1_DelayedStart() --Called after sitrep ends
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		
		Game_FadeToBlack(FADE_IN, 1.5)
		Taskbar_SetVisibility(true)
		Camera_SetInputEnabled(true)
		Cmd_Retreat(sg_civiliansHouse, mkr_exit2, mkr_exit2)
		Objective_Start(OBJ_Reinforce) 
	end
end

function Obj1_CheckCompletion()
	local isComplete = _CheckObjectiveCompletion(OBJ_Reinforce)

	if(isComplete == true) then
		Rule_RemoveMe()
		Objective_Complete(OBJ_Reinforce, false)
	elseif(isComplete == false) then
		Rule_RemoveMe()
		Objective_Fail(OBJ_Reinforce, false)
	end
end


function LightMortarsL()
	local loc = Util_GetPositionAwayFromPlayer(mkr_frontLineL, player1, 20, 9) or mkr_frontLineL
	Cmd_Ability(player2, ABILITY.GLOBAL.M01_MORTAR_SINGLE_PRECISE_HARMLESS, loc, nil, true)
end

function LightMortarsR()
	local loc = Util_GetPositionAwayFromPlayer(mkr_frontLineR, player1, 20, 9) or mkr_frontLineR
	Cmd_Ability(player2, ABILITY.GLOBAL.M01_MORTAR_SINGLE_PRECISE_HARMLESS, loc, nil, true)
end

--[[ Actions ]]
function Merge_Reminder()
	Util_StartIntel(EVENTS.Obj1_Reminder)
	
	--Remove low-damage modifiers
	Modifier_Remove(mod_shockL)
	Modifier_Remove(mod_shockR)
	
	--Update the objective markers to show icons
	for i,side in pairs(t_reinforceSquads) do
		for k,v in pairs(side) do
			Objective_RemoveUIElements(SOBJ_Merge, v.ui)
			v.ui = Objective_AddUIElements(SOBJ_Merge, v.squad, false, 11042800, true, nil, nil, nil, "Icons_abilities_ability_soviet_merge")
		end
	end
	
	--TODO: Only blip if player hasn't reinforced side yet
	UI_CreateMinimapBlip(mkr_frontLineL, 10, BT_DefendHere)
	UI_CreateMinimapBlip(mkr_frontLineR, 10, BT_DefendHere)
end

function Obj1_UnlockFrontLine()
	--Take away invulnerability for fake troops
	SGroup_SetInvulnerable(sg_frontSovietsL, false)
	SGroup_SetInvulnerable(sg_frontSovietsR, false)
	
	UI_FlashAbilityButton(ABILITY.SOVIET.MERGE_ABILITY, true)
	Util_NewHUDFeatureEvent(HUDF_CommandCard, 11042807, "Icons_abilities_ability_soviet_merge", 8) -- LOCDB [11042807] 'Conscript's 'Merge' ability reinforces squads to full strength.'
	
	Obj1_StartAttackLeft() --Defined in Scorched_Earth_Encounters.scar
	Obj1_StartAttackRight()
	
	mod_shockL = Modify_ReceivedDamage(sg_frontSovietsL, 0.4)
	mod_shockR = Modify_ReceivedDamage(sg_frontSovietsR, 0.4)
	
	Modifier_Remove(mod_noVetL)
	Modifier_Remove(mod_noVetR)
	
	--Give frontline squads
	for i,side in pairs(t_reinforceSquads) do
		for k,unit in pairs(side) do
			SGroup_SetPlayerOwner(unit.squad, player1)
		end
	end
end

function RemindConscripts()
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		
		Player_SetAbilityAvailability(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH, ITEM_DEFAULT)
		Player_SetAbilityAvailability(player1, ABILITY.SOVIET.FRONTOVIKI_CONSCRIPT_DISPATCH, ITEM_DEFAULT)
		
		Util_StartIntel(EVENTS.RemindReinforcements)
		
		Rule_AddInterval(FlashConscripts, 1)
	end
end

function FlashConscripts()
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
--~ 		if(Player_CanCastAbilityOnPosition(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH, Marker_GetPosition(trg_frontLine))) then
		Util_NewHUDFeatureEvent(HUDF_AbilityCard, 11049988, "Icons_units_unit_soviet_conscript_01", 8) -- LOCDB [11049988] 'Conscript Squads can be called in using the 'Mobilize' ability.'
		local flash_conscripts = UI_FlashAbilityButton(ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH, true)
		Event_Timer(_StopFlashing, {id = flash_conscripts}, 5)
	end
end



--Hints
function HintCover()
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		
		local t_coverHints = Marker_GetSequence("mkr_sandbags")
		
		for k,marker in pairs(t_coverHints) do
			local hint_cover = HintPoint_Add(marker, true, 11042808, 3.6, HPAT_CoverYellow) -- LOCDB [11042808] 'Squads behind cover take less damage'
			Event_Timer(EventHandler_RemoveHint, {hint = hint_cover}, 7)
		end
	end
end

function HintGarrisons()
	local sg_search = SGroup_CreateIfNotFound("sg_search")
	
	--Left side
	World_GetSquadsWithinTerritorySector(player1, sg_search, World_GetTerritorySectorID(EGroup_GetPosition(vp_fuel)), OT_Player)
	if(SGroup_CountSpawned(sg_search) < 3) then
		if(EGroup_GetAvgHealth(eg_garrison1) > 0.2) then
			hpid_garrison1 = HintPoint_Add(eg_garrison1, true, 11042809) -- LOCDB [11042809] 'Garrison buildings for cover'
		end
		
		if(EGroup_GetAvgHealth(eg_garrison2) > 0.2) then
			hpid_garrison2 = HintPoint_Add(eg_garrison2, true, 11042809)
		end
	end
	
	SGroup_Clear(sg_search)
	
	--Right side
	World_GetSquadsWithinTerritorySector(player1, sg_search, World_GetTerritorySectorID(EGroup_GetPosition(vp_motorPool)), OT_Player)
	if(SGroup_CountSpawned(sg_search) < 3 and EGroup_GetAvgHealth(eg_garrison3) > 0.2) then
		hpid_garrison3 = HintPoint_Add(eg_garrison3, true, 11042809)
	end
	
	SGroup_Clear(sg_search)
	Rule_AddInterval(CheckHintGarrisons, 2)
end

function CheckHintGarrisons()
	local sg_search = SGroup_CreateIfNotFound("sg_search")
	
	EGroup_GetSquadsHeld(eg_garrison1, sg_search)
	if(hpid_garrison1 ~= nil and (EGroup_GetAvgHealth(eg_garrison1) < 0.2 or SGroup_CountSpawned(sg_search) >= 1)) then
		HintPoint_Remove(hpid_garrison1)
		hpid_garrison1 = nil
	end
	
	EGroup_GetSquadsHeld(eg_garrison2, sg_search)
	if(hpid_garrison2 ~= nil and (EGroup_GetAvgHealth(eg_garrison2) < 0.2 or SGroup_CountSpawned(sg_search) >= 1)) then
		HintPoint_Remove(hpid_garrison2)
		hpid_garrison2 = nil
	end
	
	EGroup_GetSquadsHeld(eg_garrison3, sg_search)
	if(hpid_garrison3 ~= nil and (EGroup_GetAvgHealth(eg_garrison3) < 0.2 or SGroup_CountSpawned(sg_search) >= 1)) then
		HintPoint_Remove(hpid_garrison3)
		hpid_garrison3 = nil
	end
	
	if(hpid_garrison1 == nil and hpid_garrison2 == nil and hpid_garrison3 == nil) then
		Rule_RemoveMe()
	end
end


function EndHoldLine() --Called on a timer.
	g_enc_frontLeft:RemoveOnDeath(true)
	g_enc_frontRight:RemoveOnDeath(true)
	
	Rule_AddInterval(CheckGermanWithdraw, 2)
end

function CheckGermanWithdraw() --When frontline goes below threshold, ends holdLine objective.
	if(SGroup_TotalMembersCount(sg_frontLine) <= 13) then
		Rule_RemoveMe()
		
		Rule_Remove(LightMortarsL)
		Rule_Remove(LightMortarsR)
		
		HintPoint_RemoveAll()

		Objective_Complete(SOBJ_HoldLine, false)
	end
end






--[[********************************************************************************************************]]
---------------------------------------- Fallback event - Stukas --------------------------------------------
--[[********************************************************************************************************]]
function StukasIntro()
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		
		mod_suppression = Modify_ReceivedSuppression(Player_GetSquads(player1), 0)

		Cmd_Ability(player2, ABILITY.GLOBAL.STUKA_BOMBING_STRIKE_W_SMOKE, mkr_bomb2, nil, true, false)
		Event_Timer(EventHandler_StartIntel, {intel_callback = EVENTS.StukaAttack}, 4.5)

		Rule_AddOneShot(Stucka2, 11)
		Rule_AddOneShot(StartFlank, 16)
		Rule_AddOneShot(RestoreAttack, 24)
	end
end

function Stucka2()
	FOW_RevealArea(Marker_GetPosition(mkr_frontLineR), 13, 8)
	Command_PlayerPosDirAbility(player2, player2, Marker_GetPosition(mkr_sandbags4), Marker_GetDirection(mkr_bomb1), ABILITY.GLOBAL.STUKA_STRAFE_M02, true)
end

function StartFlank()
	FrontLine_Flank() -- *_Encounters.scar
	Rule_AddOneShot(FrontLine_Flank_Left, 15)	-- Delay the left flank a bit
	Event_PlayerCanSeeElement(StartDefendTrucks, nil, player1, sg_flank_All, ANY)
end

function RestoreAttack()
	--Left
	if(g_enc_frontLeft:IsAlive()) then
		g_enc_frontLeft:Enable()
	else
		g_enc_frontLeft = Encounter:Create(g_enc_frontLeft.data)
	end
	
	while(#g_enc_frontLeft.units < 2) do
		local unit = {
			sbp = SBP.GERMAN.GRENADIER_SQUAD,
			spawn = Table_GetRandomItem({mkr_espawn1, mkr_espawn2}),
			dynamicSpawnTarget = mkr_terrFuel,
		}
		g_enc_frontLeft:AddUnit(unit)
	end
	
	for k,unit in pairs(g_enc_frontLeft.units) do
		unit:SetOnDeath(ReplaceUnit)
	end
	
	AttackTruckLeft(g_enc_frontLeft)
	
	
	--Right
	if(g_enc_frontRight:IsAlive()) then
		g_enc_frontRight:Enable()
	else
		g_enc_frontRight = Encounter:Create(g_enc_frontRight.data)
	end
	
	while(#g_enc_frontRight.units < 2) do
		local unit = {
			sbp = SBP.GERMAN.GRENADIER_SQUAD,
			spawn = Table_GetRandomItem({mkr_espawn3, mkr_espawn4}),
			dynamicSpawnTarget = mkr_bomb9,
		}
		g_enc_frontRight:AddUnit(unit)
	end
	
	for k,unit in pairs(g_enc_frontRight.units) do
		unit:SetOnDeath(ReplaceUnit)
	end
	
	AttackTruckRight(g_enc_frontRight)
	
	--Beginner hints
	bhid_grenade1 = BeginnerHint_AddOpportunity(g_enc_frontLeft.sgroup, ABILITY.SOVIET.RG_42_ANTI_PERSONNEL_GRENADE, false, 11042803, "Icons_abilities_ability_soviet_rg_42_grenade")
	bhid_grenade2 = BeginnerHint_AddOpportunity(g_enc_frontRight.sgroup, ABILITY.SOVIET.RG_42_ANTI_PERSONNEL_GRENADE, false, 11042803, "Icons_abilities_ability_soviet_rg_42_grenade")
	
	--Spawn more harmless soldiers for added spice
	Rule_AddOneShot(SpawnHarmless2, 2) --*_encounters.scar
	
	--An additional unit down the middle road. No respawn.
	if(g_difficulty >= GD_NORMAL) then
		sg_middleRoad = Util_CreateSquads(player2, "sg_middleRoad", SBP.GERMAN.GRENADIER_SQUAD, Util_FindHiddenSpawn(mkr_enemySpawn, trg_frontLine), mkr_line1, nil, nil, true)
	end
end

function StartDefendTrucks()
	Util_StartIntel(EVENTS.Obj1_Flanks)
	
	Objective_Start(SOBJ_DefendTrucks)
--~ 	Util_StartIntel(EVENTS.Obj1_EndHold)
end




--Supply truck cargo updates
function UpdateTruckCargo1()
	SGroup_SetAnimatorState(sg_supplyTrucks, "supplies_loaded", "half")
end

function UpdateTruckCargo2()
	SGroup_SetAnimatorState(sg_supplyTrucks, "supplies_loaded", "majority")
end

function UpdateTruckCargo3()
	SGroup_SetAnimatorState(sg_supplyTrucks, "supplies_loaded", "full")
	SGroup_SetAnimatorState(sg_supplyTrucks, "engine_state", "on")
end


--[[ Exit ]]
function EndDefendTrucks()
	--This checks in case the objective is playing IntelEvents, but hasn't registered as failed.
	if(not SOBJ_DefendTrucks.IsFailed()) then
		SGroup_SetInvulnerable(sg_supplyTrucks, true)
		SGroup_SetPlayerOwner(sg_supplyTrucks, player3)
		
		Objective_Complete(SOBJ_DefendTrucks)
		
		SGroup_SetInvulnerable(Player_GetSquads(player1), true)
		
		--Remove behinner hints
		BeginnerHint_RemoveOpportunity(bhid_grenade1)
		BeginnerHint_RemoveOpportunity(bhid_grenade2)

		Rule_AddOneShot(EvacTrucks, 2)
		Rule_AddOneShot(GiveEngineerReinforcements, 3)
		Rule_AddOneShot(Obj1_Complete, 11)
	end
end

function EvacTrucks()
	--Move trucks away
	SGroup_SetInvulnerable(sg_supplyTrucks, true)
	
	SGroup_SetAnimatorState(sg_supplyTrucks, "engine_state", "on")
	
	Rule_AddOneShot(EvacTrucks_Delay, 2)
	
	Cmd_Stop(sg_alliedEngineers)
end

function EvacTrucks_Delay()	-- Delays for the engine start-up sound
	Event_Timer(MoveTruckToExit, {group = sg_supplyTruck1}, 0)
	Event_Timer(MoveTruckToExit, {group = sg_supplyTruck3}, 4)
	
	--Special case for truck on the left.
	Cmd_Move(sg_supplyTruck2, mkr_intersectionCenter)
	Event_Proximity(MoveTruckToExit, {group = sg_supplyTruck2}, sg_supplyTruck2, mkr_intersectionCenter, 7, ANY)
end

function MoveTruckToExit(data)
	if(not SGroup_IsEmpty(data.group)) then
		Cmd_MoveToAndDespawn(data.group, mkr_exit2)
	end
end

function GiveEngineerReinforcements()
	--Give more engineers if they all died
	if(SGroup_CountSpawned(sg_allies1) == 0 and g_difficulty < GD_HARD) then 
		Util_CreateSquads(player3, sg_allies1, SBP.SOVIET.M02_COMBAT_ENGINEER_SQUAD, mkr_civilians3, mkr_engineers1)
		SGroup_AddGroup(sg_alliedEngineers, sg_allies1)
		
		SGroup_AddAbility(sg_allies1, BP_GetAbilityBlueprint("sp_sprint_toggleable"))
		Cmd_Ability(sg_allies1, BP_GetAbilityBlueprint("sp_sprint_toggleable"), nil, nil, true) 
		Event_Proximity(RemoveSprint, {sgroup = sg_allies1}, sg_allies1, mkr_engineers1, 7, ANY)
	end
	if(SGroup_CountSpawned(sg_allies2) == 0) then 
		Util_CreateSquads(player3, sg_allies2, SBP.SOVIET.M02_COMBAT_ENGINEER_SQUAD, mkr_civilians3, mkr_engineers2)
		SGroup_AddGroup(sg_alliedEngineers, sg_allies2)
		
		SGroup_AddAbility(sg_allies2, BP_GetAbilityBlueprint("sp_sprint_toggleable"))
		Cmd_Ability(sg_allies2, BP_GetAbilityBlueprint("sp_sprint_toggleable"), nil, nil, true) 
		Event_Proximity(RemoveSprint, {sgroup = sg_allies2}, sg_allies2, mkr_engineers2, 7, ANY)
	end
	if(SGroup_CountSpawned(sg_allies3) == 0) then 
		Util_CreateSquads(player3, sg_allies3, SBP.SOVIET.M02_COMBAT_ENGINEER_SQUAD, mkr_civilians3, mkr_engineers3)  
		SGroup_AddGroup(sg_alliedEngineers, sg_allies3)
		
		SGroup_AddAbility(sg_allies3, BP_GetAbilityBlueprint("sp_sprint_toggleable"))
		Cmd_Ability(sg_allies3, BP_GetAbilityBlueprint("sp_sprint_toggleable"), nil, nil, true) 
		Event_Proximity(RemoveSprint, {sgroup = sg_allies3}, sg_allies3, mkr_engineers3, 7, ANY)
	end
end

function Obj1_Complete()
	--Called after trucks leave
	SGroup_SetInvulnerable(Player_GetSquads(player1), false)
end


function Obj1_WarnFail()
	if(Util_GetPlayerOwner(vp_fuel) ~= player1 or Util_GetPlayerOwner(vp_motorPool) ~= player1) then
		Rule_RemoveMe()
		Util_StartIntel(EVENTS.Obj1_WarnFail)
	end
end


--[[ Util ]]
function RemoveSprint(data)
	if(SGroup_CountSpawned(data.sgroup) > 0 and SGroup_IsDoingAbility(data.sgroup, BP_GetAbilityBlueprint("sp_sprint_toggleable"), ANY)) then
		Cmd_Ability(data.sgroup, BP_GetAbilityBlueprint("sp_sprint_toggleable"), nil, nil, true)
	end
end
---------------------------------------------- END OBJECTIVE 1 -----------------------------------------------








--[[********************************************************************************************************]]
---------------------------------------- OBJECTIVE 2 - Destroy Military assets -------------------------------
--[[********************************************************************************************************]]
function Initialize_ObjDestroy()
	OBJ_DestroySupplies = { --Destroy assets left behind
		SetupUI = function()
		end,
		
		OnStart = function()
			for k, sObj in pairs(OBJ_DestroySupplies.subObjectives) do
				if(sObj.onParentStart) then
					Objective_Start(sObj, false)
				end
			end
			
			hint_pickups = BeginnerHint_AddOpportunity(eg_pickup_objects, HINT_PICKUP, true)
			
			Rule_AddInterval(Destroy_WarnFailure, 2)
			
			Rule_AddOneShot(Destroy_GiveDemoEngineers, 4)
			Rule_AddOneShot(Destroy_Reminder, 11)
			
			Rule_AddOneShot(AdvanceFlanks, 8) --*_encounters.scar
			
			Rule_AddOneShot(Destroy_Discussion, 8)
			
			Rule_AddDelayedInterval(Destroy_CheckCompletion, 1, 2)
		end,
		
		OnComplete = function()
			Rule_Remove(Destroy_WarnFailure)
			Rule_Remove(Destroy_Reminder)
			Rule_Remove(Destroy_CheckDemoPlacementHowitzers)
			Rule_Remove(Destroy_CheckDemoPlacementTrucks)
			
			Modifier_Remove(mod_alliedEngineers) --Only present at this poing if GD_EASY
			
			Rule_AddOneShot(StartExplosivesScene, 2)
		end,
		
		OnFail = function()
			Rule_RemoveAll()
			Game_SetMode(UI_Cinematic)
			if(g_win == nil and not Rule_Exists(Mission_MissionFail)) then Rule_AddOneShot(Mission_MissionFail, 2) end
		end,
		
		IsComplete = function()
			return Objective_IsComplete(SOBJ_DestroyVehicles) and Objective_IsComplete(SOBJ_DestroyHowitzers)
		end,
		
		IsFailed = function()
			--Failed if all engineers are killed and no demopacks have been placed
			return SGroup_CountSpawned(sg_alliedEngineers) == 0 
				and (not _CheckDemoPlacement(mkr_pingTrucks, 9) and not SOBJ_DestroyVehicles.IsComplete()
						or not _CheckDemoPlacement(mkr_pingSupplies2, 9) and not SOBJ_DestroyHowitzers.IsComplete())
		end,
		
		subObjectives = {},
		
		Intel_Start = EVENTS.Destroy_Intro,
		Intel_Complete = EVENTS.Destroy_Complete,
		Intel_Fail = EVENTS.Destroy_Fail,
		Title =  11042812, -- LOCDB [11042812] 'Destroy remaining assets using demolition packs'
		TitleEnd = 11042813, -- LOCDB [11042813] 'Supplies destroyed'
		TitleFail = 11046797,-- LOCDB [11046797] 'All engineers have been killed'
		Type = OT_Primary,
	}
	
	
	--[[ Sub-objectives ]]
	SOBJ_DestroyVehicles = { --Destroy the vehicles
		SetupUI = function()
			UI_CreateMinimapBlip(EGroup_GetPosition(eg_destroyVehicles), 10, BT_General)
			hpid_vehicles = Objective_AddUIElements(SOBJ_DestroyVehicles, EGroup_GetPosition(eg_destroyVehicles), true, 11042811, true, 2.5) -- LOCDB [11042811] 'Destroy Vehicles'
		end,
		
		OnStart = function()
			EGroup_SetInvulnerable(eg_destroyVehicles, false)
		end,
		
		OnComplete = function()
			Objective_RemoveUIElements(SOBJ_DestroyVehicles, hpid_vehicles)
			if(EGroup_CountSpawned(eg_destroyVehicles) > 0) then
				EGroup_Kill(eg_destroyVehicles)
			end
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return EGroup_GetAvgHealth(eg_destroyVehicles) == 0
		end,
		
		IsFailed = function()
			return false
		end,
		
		Intel_Start = nil,
		Intel_Complete = nil,
		Intel_Fail = nil,
		Title =  11046798,-- LOCDB [11046798] 'Destroy the abandoned vehicles'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,
		onParentStart = true,
		Parent = OBJ_DestroySupplies,
	}
	
	
	SOBJ_DestroyHowitzers = { --Destroy the howitzers
		SetupUI = function()
			UI_CreateMinimapBlip(EGroup_GetPosition(eg_howitzers), 10, BT_General)
			hpid_howitzers = Objective_AddUIElements(SOBJ_DestroyHowitzers, EGroup_GetPosition(eg_howitzers), true, 11046799, true, 2.5) -- LOCDB [11046799] 'Destroy the howitzers'
		end,
		
		OnStart = function()
			EGroup_SetInvulnerable(eg_howitzers, false)
		end,
		
		OnComplete = function()
			Objective_RemoveUIElements(SOBJ_DestroyHowitzers, hpid_howitzers)
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return EGroup_GetAvgHealth(eg_howitzers) == 0
		end,
		
		IsFailed = function()
			return false
		end,
		
		Intel_Start = nil,
		Intel_Complete = nil,
		Intel_Fail = nil,
		Title = 11046799,-- LOCDB [11046799] 'Destroy the howitzers'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,
		onParentStart = true,
		Parent = OBJ_DestroySupplies,
	}
	
	
	table.insert(OBJ_DestroySupplies.subObjectives, SOBJ_DestroyVehicles)
	table.insert(OBJ_DestroySupplies.subObjectives, SOBJ_DestroyHowitzers)
	
	Objective_Register(OBJ_DestroySupplies)
	for k, sObj in pairs(OBJ_DestroySupplies.subObjectives) do 
		Objective_Register(sObj)
	end
end

--[[ Intro ]]
function Destroy_DelayedStart()
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		Objective_Start(OBJ_DestroySupplies)
	end
end

--[[ Actions ]]
function Destroy_CheckCompletion()
	local isComplete = _CheckObjectiveCompletion(OBJ_DestroySupplies)

	if(isComplete == true) then
		Rule_RemoveMe()
		Objective_Complete(OBJ_DestroySupplies, false)
	elseif(isComplete == false) then
		Rule_RemoveMe()
		Objective_Fail(OBJ_DestroySupplies)
	end
end

function Destroy_Reminder()
	if(SGroup_CountSpawned(sg_allies1) > 0) then 
		HintPoint_Remove(hpid_demoEngineer1)
		hpid_demoEngineer1 = HintPoint_Add(sg_allies1, true, 11042816, nil, nil, "Icons_abilities_ability_soviet_demo_charge")  -- LOCDB [11042816] 'Engineers'
	end
	if(SGroup_CountSpawned(sg_allies2) > 0) then 
		HintPoint_Remove(hpid_demoEngineer2)
		hpid_demoEngineer2 = HintPoint_Add(sg_allies2, true, 11042816, nil, nil, "Icons_abilities_ability_soviet_demo_charge")
	end
	if(SGroup_CountSpawned(sg_allies3) > 0) then 
		HintPoint_Remove(hpid_demoEngineer3)
		hpid_demoEngineer3 = HintPoint_Add(sg_allies3, true, 11042816, nil, nil, "Icons_abilities_ability_soviet_demo_charge")
	end
	
	Event_IsSelected(Destroy_RemoveReminder, nil, sg_alliedEngineers, ANY, 1.0)
end

function Destroy_RemoveReminder()
	RemoveEngResourceHint1()
	RemoveEngResourceHint2()
	Rule_AddOneShot(Destroy_Reminder2, 15)
end

function Destroy_Reminder2()
	--Place icons hints on top of resources if player hasn't placed a demo pack yet
	if(EGroup_CountSpawned(eg_destroyVehicles) > 0 and not _CheckDemoPlacement(mkr_pingTrucks, 9)) then
		Objective_RemoveUIElements(SOBJ_DestroyVehicles, hpid_vehicles)
		hpid_vehicles = Objective_AddUIElements(SOBJ_DestroyVehicles, EGroup_GetPosition(eg_destroyVehicles), true, 11042811, true, 2.5, nil, nil, "Icons_abilities_ability_soviet_demo_charge")
		
		Rule_AddInterval(Destroy_CheckDemoPlacementHowitzers, 2)
	end
	
	if(EGroup_CountSpawned(eg_howitzers) > 0 and not _CheckDemoPlacement(mkr_pingSupplies2, 9)) then
		Objective_RemoveUIElements(SOBJ_DestroyHowitzers, hpid_howitzers)
		hpid_howitzers = Objective_AddUIElements(SOBJ_DestroyHowitzers, EGroup_GetPosition(eg_howitzers), true, 11046799, true, 2.5, nil, nil, "Icons_abilities_ability_soviet_demo_charge")
		
		Rule_AddInterval(Destroy_CheckDemoPlacementTrucks, 2)
	end
end

--Remove icon hints once player placed demo packs.
function Destroy_CheckDemoPlacementHowitzers()
	if(EGroup_CountSpawned(eg_howitzers) > 0 and _CheckDemoPlacement(mkr_pingSupplies2, 9)) then
		Rule_RemoveMe()
		Objective_RemoveUIElements(SOBJ_DestroyHowitzers, hpid_howitzers)
		hpid_howitzers = Objective_AddUIElements(SOBJ_DestroyHowitzers, EGroup_GetPosition(eg_howitzers), true, 11046799, true, 2)
	end
end

function Destroy_CheckDemoPlacementTrucks()
	if(EGroup_CountSpawned(eg_destroyVehicles) > 0 and _CheckDemoPlacement(mkr_pingTrucks, 9)) then
		Rule_RemoveMe()
		Objective_RemoveUIElements(SOBJ_DestroyVehicles, hpid_vehicles)
		hpid_vehicles = Objective_AddUIElements(SOBJ_DestroyVehicles, EGroup_GetPosition(eg_destroyVehicles), true, 11042811, true)
	end
end


function Destroy_WarnFailure()
	--Warn if the player is low on engineers.
	if(SGroup_CountSpawned(sg_alliedEngineers) == 1 and not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		if(not Objective_IsComplete(OBJ_DestroySupplies)) then
			Util_StartIntel(EVENTS.Destroy_WarnFailure)
		end
	end
end

function Destroy_Discussion()
	Util_StartIntel(EVENTS.Destroy_Discussion)
end

function Destroy_FailObjective()
	Game_SetMode(UI_Fullscreen)
	if(g_win == nil  and not Rule_Exists(Mission_MissionFail)) then Rule_AddOneShot(Mission_MissionFail, 2) end
end

function Destroy_GiveDemoEngineers()
	
	if(g_difficulty == GD_EASY) then
		mod_alliedEngineers = Modify_ReceivedDamage(sg_alliedEngineers, 0.85)
	end
	
	SGroup_SetPlayerOwner(sg_alliedEngineers, player1)
	SGroup_EnableMinimapIndicator(sg_alliedEngineers, true)
	SGroup_SetSelectable(sg_alliedEngineers, true)
	
	--Give control of engineers to player
	if(SGroup_CountSpawned(sg_allies1) > 0) then 
		if(g_difficulty < GD_HARD) then
			hpid_demoEngineer1 = HintPoint_Add(sg_allies1, true, 11042816)  -- LOCDB [11042816] 'Engineers'
			Cmd_Move(sg_allies1, mkr_engineers1)
			Rule_AddSGroupEvent(RemoveEngResourceHint1, sg_allies1, GE_SquadCommandIssued)
		else
			Cmd_MoveToAndDespawn(sg_allies1, mkr_bridgeObj)
		end
	end
	if(SGroup_CountSpawned(sg_allies2) > 0) then 
		hpid_demoEngineer2 = HintPoint_Add(sg_allies2, true, 11042816)
		Cmd_Move(sg_allies2, mkr_engineers2)
		Rule_AddSGroupEvent(RemoveEngResourceHint1, sg_allies2, GE_SquadCommandIssued)
	end
	if(SGroup_CountSpawned(sg_allies3) > 0) then 
		hpid_demoEngineer3 = HintPoint_Add(sg_allies3, true, 11042816)
		Cmd_Move(sg_allies3, mkr_engineers3)
		Rule_AddSGroupEvent(RemoveEngResourceHint2, sg_allies3, GE_SquadCommandIssued)
	end
	
	--Highlight engineer demo packs
	UI_FlashSquadCommandButton(SCMD_PlaceCharge, true)
end


--[[ Util ]]
function RemoveEngResourceHint1()
	Rule_RemoveSGroupEvent(RemoveEngResourceHint1, sg_allies1)
	Rule_RemoveSGroupEvent(RemoveEngResourceHint1, sg_allies2)
	
	HintPoint_Remove(hpid_demoEngineer1)
	HintPoint_Remove(hpid_demoEngineer2)
	
	Rule_Remove(Destroy_Reminder)
end

function RemoveEngResourceHint2()
	Rule_RemoveSGroupEvent(RemoveEngResourceHint2, sg_allies3)
	HintPoint_Remove(hpid_demoEngineer3)
end
-----------------------------------------------END OBJECTIVE 2------------------------------------------------








--[[********************************************************************************************************]]
------------------------------------------------ Explosives scene --------------------------------------------
--[[********************************************************************************************************]]
function StartExplosivesScene()
	sg_htExplosives = Util_CreateSquads(player2, "sg_htExplosives", SBP.GERMAN.SCOUTCAR_SDKFZ222, Util_FindHiddenSpawn(mkr_enemySpawn, mkr_line1), mkr_line1, nil, nil, nil, nil, nil, trg_frontLine)
	Modify_UnitSpeed(sg_htExplosives, 1.3)
	SGroup_SetInvulnerable(sg_htExplosives, true)
	
	Event_OnHealth(DestroyHT, nil, sg_htExplosives, 0.33)
	Event_Proximity(InformHT, nil, sg_htExplosives, mkr_line1, 16, ANY)
end

function InformHT()
	Util_StartIntel(EVENTS.Explosives_InformHT)
	UI_CreateMinimapBlip(sg_htExplosives, 10, BT_AttackHere)
	EventCue_Create(CUE.ATTACKED, 11042817, 11042817, sg_htExplosives, nil, nil, 20, false)  -- LOCDB [11042817] 'Enemy Vehicle'
	ThreatArrow_CreateGroup(sg_htExplosives)
	FOW_RevealSGroup(sg_htExplosives, 25)
	
	Rule_AddInterval(StartExplosives, 1)
end

function DestroyHT()
	if(SGroup_CountSpawned(sg_htExplosives) > 0) then SGroup_Kill(sg_htExplosives) end
	ThreatArrow_DestroyAllGroups()
end

function StartExplosives()
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
	
		--Disable existing enemy encounters
		for k, enc in pairs(AI_GetActiveEncounters()) do
			enc:ClearGoal()
			enc:RemoveOnDeath(true)
		end
		
		SGroup_SetInvulnerable(sg_htExplosives, false)
		
		Rule_AddInterval(Obj1_DetonateExplosives, 0.45)
	end
end

function Obj1_DetonateExplosives()
	if(#t_demopacks == 0) then
		Rule_RemoveMe()
		RetreatLeftOvers()
		Rule_AddOneShot(EndExplosivesScene, 2)
	else
		--Retreat nearby units
		local nearby = SGroup_CreateIfNotFound("nearby")
		SGroup_Clear(nearby)
		World_GetSquadsNearPoint(player2, nearby, Util_GetPosition(t_demopacks[1]), 9, OT_Player)
		Cmd_Retreat(nearby, mkr_enemySpawn, mkr_enemySpawn)
		
		--Detonate
		Command_PlayerEntity(player3, player3, PCMD_DetonateCharges, t_demopacks[1])
		table.remove(t_demopacks, 1)
	end
end

function RetreatLeftOvers()
	local nearby = SGroup_CreateIfNotFound("nearby")
	SGroup_Clear(nearby)
	World_GetSquadsWithinTerritorySector(player2, nearby, World_GetTerritorySectorID(Marker_GetPosition(mkr_terrFuel)), OT_Player)
	Cmd_Retreat(nearby, mkr_espawn1, mkr_espawn1)
	
	World_GetSquadsWithinTerritorySector(player2, nearby, World_GetTerritorySectorID(Marker_GetPosition(mkr_terrMotorPool)), OT_Player)
	Cmd_Retreat(nearby, mkr_espawn3, mkr_espawn3)
	
	if(SGroup_IsAlive(sg_flankLeft)) then
		Cmd_Retreat(sg_flankLeft, mkr_spawnTrapLeft, mkr_spawnTrapLeft)
	end
	
	if(SGroup_IsAlive(sg_flankRight)) then
		Cmd_Retreat(sg_flankRight, mkr_roadNorthEast, mkr_roadNorthEast)
	end
end

function EndExplosivesScene()
	Util_StartIntel(EVENTS.Obj1_end)
	
	--Music
	Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 0)
	
	Rule_AddDelayedInterval(Scorch_DelayedStart, 1, 1)
end









--[[********************************************************************************************************]]
----------------------------------------------- OBJECTIVE 3 - ScorchEarth ------------------------------------
--[[********************************************************************************************************]]
function Initialize_ObjScorch() --Scorch the earth and prepare to defend the train station. 

	OBJ_ScorchEarth = {
		SetupUI = function() 
		end,
		
		OnStart = function()
			--Update current objective
			m02_CurrentObjective = OBJ_ScorchEarth
			
			for k, sObj in pairs(OBJ_ScorchEarth.subObjectives) do
				if(sObj.onParentStart) then
					Objective_Start(sObj, false)
				end
			end
			
			--No longer have houses in front line on fire.
			EGroup_SetInvulnerable(eg_burningHouse, false)
			EGroup_SetInvulnerable(eg_burningHouse2, false)
			
			--Reinforce Hint
			hint_reinforce = BeginnerHint_AddOpportunity(sg_reinforcehints, HINT_REINFORCE, true)
			
			--Remove access to center entry points
			EGroup_DeSpawn(eg_forwardEntry2)
			
			--Send in enemy units to attack the fields (defined in encounters file)
			Rule_AddOneShot(FlankFieldLeft, 10)
			Rule_AddOneShot(FlankFieldRight, 10)
			Rule_AddOneShot(TownAttackers, 8)
			
			Rule_AddOneShot(Scorch_SetBlockers, 20)
			
			
			--After the camera pans to the flamethrowers, the HQ is introduced
			Rule_AddDelayedInterval(InformHQ, 1, 1)
			
			Rule_AddInterval(Scorch_CheckCompletion, 2)
		end,
		
		OnComplete = function()
			Rule_Remove(Scorch_CheckCompletion)
			Rule_Remove(Scorch_Reminder)
			
			--Stop the center town encounter from respawning
			enc_townAttackers1:RemoveOnDeath(true)
			enc_townAttackers2:RemoveOnDeath(true)
			
			
			--Stop flashing the flamethrower upgrade
			if(flash_upgFlame) then
				UI_StopFlashing(flash_upgFlame)
			end
			
			--In case all fields OBJ was completed immediately
			Objective_RemoveUIElements(SOBJ_TorchFields, hpid_hayRight)
			Objective_RemoveUIElements(SOBJ_TorchFields, hpid_hayLeft)
			
			--Music
			Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT,0)
			
			--Change atmosphere and reset music values once beat is done
			Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/_m02_scorchedearth_SMOKE.aps", 13)
			
			--If the farthest house is still alive and burning, destroy it.
			if(EGroup_CountSpawned(eg_burnHouse3) > 0) then
				EGroup_Kill(eg_burnHouse3)
			end
			
			Util_Autosave(nil, 1)
			
			Rule_AddDelayedInterval(Defend_DelayedStart, 7, 1)
		end,
		
		OnFail = function()
			Rule_RemoveAll()
			
			if(g_win == nil  and not Rule_Exists(Mission_MissionFail)) then Rule_AddOneShot(Mission_MissionFail, 3) end
		end,
		
		IsComplete = function()
			return Objective_IsComplete(SOBJ_TorchFields) and Objective_IsComplete(SOBJ_BurnHouses)
		end,
		
		IsFailed = function()
			return false
		end,
		
		subObjectives = {},
		
		Intel_Start = EVENTS.Scorch_Intro, --Pans camera to the flamethrowers
		Intel_Complete = EVENTS.Scorch_Complete, 
		Intel_Fail = nil,
		Title =  11042818, -- LOCDB [11042818] 'Scorch the Earth'
		TitleEnd = nil,
		TitleFail = 11042819, -- LOCDB [11042819] 'The Germans have taken control of the territories'
		Type = OT_Primary,
	}
	
	
	--[[ Sub-objectives ]]
	SOBJ_GetFlamethrowers = { --Get flamethrowers from trainyard
		SetupUI = function()
			hpid_flamethrowers = Objective_AddUIElements(SOBJ_GetFlamethrowers, eg_flamethrowers, true, 11042820, true, 0, nil, HPAT_Critical) -- LOCDB [11042820] 'Flamethrowers'
		end,
		
		OnStart = function()
			--Unlock the flamethrowers and upgrade
			Player_SetAbilityAvailability(player1, ABILITY.GLOBAL.FLAME_THROWER_ABILITY, ITEM_DEFAULT)
			EGroup_SetSelectable(eg_flamethrowers, true)
			EGroup_EnableUIDecorator(eg_flamethrowers, true, true)
			
			Rule_AddSGroupEvent(CheckCommandInput, Player_GetSquads(player1), GE_SquadCommandIssued)
			
			--Ensure munitions
			Player_SetResource(player1, RT_Munition, math.max(Player_GetResource(player1, RT_Munition), Util_DifVar({200, 180, 0}, g_difficulty)))
		end,
		
		OnComplete = function()
			Util_StartIntel(EVENTS.Scorch_BurnOrders)
			
			EGroup_SetInvulnerable(eg_burnHouses, false)
			
			Player_SetUpgradeAvailability(player1, UPG.SOVIET.ENGINEER_FLAMETHROWER, ITEM_DEFAULT)
			
			Rule_RemoveSGroupEvent(CheckCommandInput, Player_GetSquads(player1))
			
			Rule_AddDelayedInterval(CheckFlamethrowerUpgrade, g_teachFlamethrowerDelay, 1)
			
			Rule_AddOneShot(Scorch_StartHouses, 1)
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return EGroup_CountSpawned(eg_flamethrowers) <= 1
		end,
		
		Intel_Start = nil,
		Intel_Complete = nil,
		Intel_Fail = nil,
		Title =  11048208, -- LOCDB [11048208] 'Equip engineers with flamethrowers'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,
		onParentStart = true,
		Parent = OBJ_ScorchEarth,
	}
	
	
	SOBJ_BurnHouses = { --Burn down houses
		SetupUI = function()
			Objective_SetCounter(SOBJ_BurnHouses, 0, 4)
		end,
		
		OnStart = function()
			t_burnHouses = {
				{ building = eg_burnHouse1, offset = 4},
				{ building = eg_burnHouse2, offset = 0},
				{ building = eg_burnHouse3, offset = 0},
				{ building = eg_burnHouse4, offset = 0},
			} 
			Objective_SetCounter(SOBJ_BurnHouses, 0, #t_burnHouses)			
			
			for k,bldg in pairs(t_burnHouses) do
				t_burnHouses[k] = {
					group = bldg.building,
					ui = Objective_AddUIElements(SOBJ_BurnHouses, bldg.building, false, 11042822, true, bldg.offset) -- LOCDB [11042822] 'Burn houses'
				}
			end
			
			g_housesPing = Objective_AddUIElements(SOBJ_BurnHouses, eg_burnHouse2, true)
		
			--Disable garrison
			Modify_DisableHold(eg_burnHouses, true)
			
			Rule_AddOneShot(PlayShockLine1, 14)
			
			Rule_AddDelayedInterval(Scorch_Reminder, 90, 60)
			
			Rule_AddDelayedInterval(Scorch_CheckArrowsHouses, 2, 2)
			Rule_AddDelayedInterval(CheckCiviliansFire, 2, 2)
		end,
		
		OnComplete = function()
			Rule_Remove(Scorch_CheckArrowsHouses)
			
			Objective_Start(SOBJ_TorchFields)
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return EGroup_IsBurning(eg_burnHouses, ALL) or EGroup_IsEmpty(eg_burnHouses)
		end,
		
		Intel_Start = nil,
		Intel_Complete = nil,
		Intel_Fail = nil,
		Title =  11042823, -- LOCDB [11042823] 'Ignite the houses'
		TitleEnd = 11042824, -- LOCDB [11042824] 'Houses torched'
		TitleFail = 11042825, -- LOCDB [11042825] 'The Germans have secured the territory'
		Type = OT_Primary,
		onParentStart = false,
		Parent = OBJ_ScorchEarth,
	}
	
	
	SOBJ_TorchFields = { --Torch north and south fields
		SetupUI = function()
			hpid_hayRight = Objective_AddUIElements(SOBJ_TorchFields, mkr_fireNorth1, true, 11042826, true, 5) -- LOCDB [11042826] 'Target haystacks using flamethrowers'
			hpid_hayLeft = Objective_AddUIElements(SOBJ_TorchFields, mkr_fireSouth1, true, 11042826, true, 4)
		end,
		
		OnStart = function()
			--Stop the two center houses from perpetually burning.
			EGroup_SetInvulnerable(eg_burnHouses2_3, false)
		
			--Prox triggers
			Event_Proximity(Scorch_AttackLeftField, nil, player1, trg_fieldSouth, nil, ANY, 2)
			Scorch_AttackRightField()
			
			Util_StartIntel(EVENTS.Scorch_WarnGasoline)
			
			Rule_AddInterval(Scorch_CheckFieldRight, 1)
			Rule_AddInterval(Scorch_CheckFieldLeft, 1)
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			--Both fields are torched. Set by Scorch_CheckField<X>()
			return g_leftFieldTorched and g_rightFieldTorched
		end,
		
		Intel_Start = EVENTS.Scorch_StartFields,
		Intel_Complete = nil,
		Intel_Fail = EVENTS.Scorch_Failed,
		Title =  11042827, -- LOCDB [11042827] 'Torch the fields to the North and South'
		TitleEnd = 11042828, -- LOCDB [11042828] 'Fields torched'
		TitleFail = 11042829, -- LOCDB [11042829] 'The Germans have captured the fields'
		Type = OT_Primary,
		onParentStart = false,
		Parent = OBJ_ScorchEarth,
	}
	
	
	
	table.insert(OBJ_ScorchEarth.subObjectives, SOBJ_GetFlamethrowers)
	table.insert(OBJ_ScorchEarth.subObjectives, SOBJ_BurnHouses)
	table.insert(OBJ_ScorchEarth.subObjectives, SOBJ_TorchFields)
	
	Objective_Register(OBJ_ScorchEarth)
	for k, obj in pairs(OBJ_ScorchEarth.subObjectives) do
		Objective_Register(obj)
	end
end

function Scorch_DelayedStart()
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		--Music
		Sound_PlayMusic("streamed/music/missions/m02/m02_cue_scorched_earth", 0, 0)
		Objective_Start(OBJ_ScorchEarth)
	end
end

-- Loop to check for each subObj fail or pass
function Scorch_CheckCompletion()
	--SubObjectives
	for k, subObj in pairs(OBJ_ScorchEarth.subObjectives) do
		if(Objective_IsStarted(subObj) and not Objective_IsComplete(subObj) and not Objective_IsFailed(subObj)) then
			if(subObj.IsComplete()) then
				Objective_Complete(subObj, false)
			elseif(subObj.IsFailed ~= nil and subObj.IsFailed()) then
				Objective_Fail(subObj)
			end
		end
	end
	
	
	--Main objective
	if(OBJ_ScorchEarth.IsComplete()) then
		Rule_RemoveMe()
		Rule_Remove(Scorch_Reminder)
		Objective_Complete(OBJ_ScorchEarth)
	elseif(OBJ_ScorchEarth.IsFailed()) then
		Rule_RemoveMe()
		Rule_Remove(Scorch_Reminder)
		Objective_Fail(OBJ_ScorchEarth)
	end
end

function Scorch_Reminder()
	Util_StartIntel(EVENTS.Scorch_Reminder)
	
	local engineers = Player_GetSquads(player1)
	SGroup_Filter(engineers, SBP.SOVIET.M02_COMBAT_ENGINEER_SQUAD, FILTER_KEEP)
	
	if(SGroup_CountSpawned(engineers) < 1) then
		Util_NewHUDFeatureEvent(HUDF_CommandCard, 11049990, "Icons_units_unit_soviet_engineer", 7) -- LOCDB [11049990] 'Additional engineers can be requested from the Headquaters'
		UI_FlashProductionButton(PITEM_Spawn, BP_GetSquadBlueprint("m02_combat_engineer_squad"), true)
	end
	
	if(not (Rule_Exists(CheckFlamethrowerUpgrade) or Rule_Exists(TeachFlamethrowerUpgrade))) then
		Rule_AddDelayedInterval(CheckFlamethrowerUpgrade, 3, 1)
	end
	
	
	for k,v in pairs(t_burnHouses) do
		Objective_RemoveUIElements(SOBJ_BurnHouses, v.ui)
		v.ui = Objective_AddUIElements(SOBJ_BurnHouses, v.group, false, 11042822, true, nil, nil, nil, "Icons_abilities_ability_soviet_flame_burst")
	end
end

function Scorch_SetBlockers()
	Util_CreateSquads(player2, nil, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, Util_FindHiddenSpawn(mkr_espawn3, mkr_front7), mkr_front7, nil, nil, true)
	Util_CreateSquads(player2, nil, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, Util_FindHiddenSpawn(mkr_espawn2, mkr_sandbags1), mkr_sandbags1, nil, nil, true)
	Util_CreateSquads(player2, nil, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, Util_FindHiddenSpawn(mkr_espawn3, trg_frontLine), trg_frontLine, nil, nil, true, mkr_line1)
	Util_CreateSquads(player2, nil, SBP.GERMAN.MORTAR_TEAM_81MM, Util_FindHiddenSpawn(mkr_enemySpawn, mkr_front5), mkr_front5)
end

function CheckCommandInput(squad, command, target) --If the player tries to pickup with non-engineers, notify him
	if(command == SCMD_Move and Squad_GetBlueprint(squad) ~= SBP.SOVIET.M02_COMBAT_ENGINEER_SQUAD) and 
			scartype(target) == ST_ENTITY and EGroup_ContainsEntity(eg_flamethrowers, target) then
		
		if(not Event_IsRunning(EVENTS.Scorch_UseEngineers) and not Event_IsQueued(EVENTS.Scorch_UseEngineers)) then
			Util_StartAmbient(EVENTS.Scorch_UseEngineers)
		end
	end
end



function Scorch_StartHouses()
	Objective_Start(SOBJ_BurnHouses, true)
	Rule_AddDelayedInterval(Scorch_FlamethrowerHint, 1, 1)
end

function Scorch_FlamethrowerHint()
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		UI_FlashAbilityButton(ABILITY.GLOBAL.FLAME_THROWER_ABILITY, true)
		Util_NewHUDFeatureEvent(HUDF_CommandCard, 11042830, "Icons_abilities_ability_soviet_flame_burst", 5) -- LOCDB [11042830] 'Use 'Flamethrower Attack' to set buildings on fire'
	end
end

function Scorch_CheckArrowsHouses()
	--Check the objective arrows
	for k=#t_burnHouses, 1, -1 do
		local bldg = t_burnHouses[k]
		if(EGroup_IsBurning(bldg.group, ANY) or EGroup_IsEmpty(bldg.group)) then
			Objective_RemoveUIElements(SOBJ_BurnHouses, bldg.ui)
			EGroup_SetInvulnerable(bldg.group, true)
			EGroup_EnableUIDecorator(bldg.group, false)
			
			if(Objective_IsCounterSet(SOBJ_BurnHouses)) then
				Objective_SetCounter(SOBJ_BurnHouses, Objective_GetCounter(SOBJ_BurnHouses)+1, 4)
			end
			
			table.remove(t_burnHouses, k)
		end
	end
	
	
	if(#t_burnHouses == 0) then
		Objective_RemoveUIElements(SOBJ_BurnHouses, g_housesPing)
		Rule_RemoveMe()
	elseif(#t_burnHouses <= 2 and sg_alliedFlame1 == nil and not Rule_Exists(Scorch_AlliedFlamethrowers)) then
		--Have allied engineers torch other houses.
		Rule_AddOneShot(Scorch_AlliedFlamethrowers, 3)
	end
end

function CheckCiviliansFire()
	if(EGroup_IsBurning(eg_burnHouse2, ANY)) then
		Rule_RemoveMe()
		sg_civiliansFire = Util_CreateSquads(player3, "sg_civiliansFire", BP_GetSquadBlueprint("m02_refugee_squad"), mkr_civilians3)
		_DisableInteraction(sg_civiliansFire)
		
		Cmd_MoveToAndDespawn(sg_civiliansFire, mkr_exit2)

		Sound_PlayOnSquad("streamed/speech_exertions/exertion_death_flame_female", sg_civiliansFire)
		Sound_PlayOnSquad("streamed/speech_exertions/exertion_death_flame_male", sg_civiliansFire)

		Rule_AddOneShot(PlayShockLine2, 3)
	end
end

function PlayShockLine1()
	local playerSquads = Player_GetSquads(player1)
	local squad = nil
	
	for k=1, SGroup_CountSpawned(playerSquads) do
		squad = SGroup_GetSpawnedSquadAt(playerSquads, k)
		if(Misc_IsSquadOnScreen(squad, 0.95)) then
--~ 			view(squad) --Debug.
--~ 			Util_StartAmbient(EVENTS.Scorch_ShockLine1)
			Sound_PlayOnSquad("speech/sp/mission/m02/11046486", squad)
			break
		end
	end
	
	Command_PlayerPosDirAbility(player2, player2, Marker_GetPosition(mkr_civilians3), Marker_GetDirection(mkr_pathLeftDest), BP_GetAbilityBlueprint("stuka_fake_strafe"), true)
end

function PlayShockLine2()
	local playerSquads = Player_GetSquads(player1)
	local squad = nil
	
	for k=1, SGroup_CountSpawned(playerSquads) do
		squad = SGroup_GetSpawnedSquadAt(playerSquads, k)
		if(Misc_IsSquadOnScreen(squad, 0.95)) then
--~ 			view(squad) --Debug.
--~ 			Util_StartAmbient(EVENTS.Scorch_ShockLine2)
			Sound_PlayOnSquad("speech/sp/mission/m02/11049556", squad)
			break
		end
	end
end

--Allied engineers burning houses
function Scorch_AlliedFlamethrowers()
	sg_alliedFlame1 = Util_CreateSquads(player3, "sg_alliedFlame1", SBP.SOVIET.M02_COMBAT_ENGINEER_SQUAD, mkr_trainLoad, nil, nil, nil, nil, nil, UPG.SOVIET.ENGINEER_FLAMETHROWER)
	sg_alliedFlame2 = Util_CreateSquads(player3, "sg_alliedFlame2", SBP.SOVIET.M02_COMBAT_ENGINEER_SQUAD, mkr_trainLoad, nil, nil, nil, nil, nil, UPG.SOVIET.ENGINEER_FLAMETHROWER)
	
	mod_house5 = Modify_ReceivedDamage(eg_burnHouse5, 0.5)
	mod_house6 = Modify_ReceivedDamage(eg_burnHouse6, 0.5)
	
	Cmd_Ability(sg_alliedFlame1, ABILITY.GLOBAL.FLAME_THROWER_ABILITY, eg_burnHouse5, nil, true)
	Cmd_Ability(sg_alliedFlame2, ABILITY.GLOBAL.FLAME_THROWER_ABILITY, eg_burnHouse6, nil, true)
	
	Rule_AddDelayedInterval(Scorch_CheckAlliedFlames, 10, 3)
end

function Scorch_CheckAlliedFlames()
	if((EGroup_IsBurning(eg_burnHouse5, ANY) or EGroup_GetAvgHealth(eg_burnHouse5) == 0) and SGroup_CountSpawned(sg_alliedFlame1) > 0) then
		Cmd_MoveToAndDespawn(sg_alliedFlame1, mkr_exit2)
		Modifier_Remove(mod_house5)
	else
		Cmd_Ability(sg_alliedFlame1, ABILITY.GLOBAL.FLAME_THROWER_ABILITY, eg_burnHouse5, nil, true)
	end
	
	if((EGroup_IsBurning(eg_burnHouse6, ANY) or EGroup_GetAvgHealth(eg_burnHouse6) == 0) and SGroup_CountSpawned(sg_alliedFlame2) > 0) then
		Cmd_MoveToAndDespawn(sg_alliedFlame2, mkr_exit2)
		Modifier_Remove(mod_house6)
	else
		Cmd_Ability(sg_alliedFlame2, ABILITY.GLOBAL.FLAME_THROWER_ABILITY, eg_burnHouse6, nil, true)
	end
	
	if(SGroup_CountSpawned(sg_alliedFlame1) == 0 and SGroup_CountSpawned(sg_alliedFlame2) == 0) then
		Rule_RemoveMe()
	end
end


--Teach flamethrower upgrade
function CheckFlamethrowerUpgrade()
	--Run through engineers. If one of them can get the flamethrower upgrade, teach player.
	local engineers = Player_GetSquads(player1)
	SGroup_Filter(engineers, SBP.SOVIET.M02_COMBAT_ENGINEER_SQUAD, FILTER_KEEP)
	
	for i=1, SGroup_CountSpawned(engineers) do
		squad_flameUpgrade = SGroup_GetSpawnedSquadAt(engineers, i)
		if(Squad_GetNumSlotItem(squad_flameUpgrade, SLOT_ITEM.FLAMETHROWER_ROKS3_FAKE) < 1
			and not Squad_HasUpgrade(squad_flameUpgrade, UPG.SOVIET.ENGINEER_FLAMETHROWER)
			and not Squad_IsUpgrading(squad_flameUpgrade, UPG.SOVIET.ENGINEER_FLAMETHROWER)
			and not Rule_Exists(TeachFlamethrowerUpgrade)) then
				--Un-upgraded engineer found.
				Rule_RemoveMe()
				hpid_engineerUpgrade = HintPoint_Add(squad_flameUpgrade, true, 11042831) -- LOCDB [11042831] 'Engineers can be upgraded to carry flamethrowers.'
				Rule_AddInterval(TeachFlamethrowerUpgrade, 0.5)
				break
		end
	end
end

function TeachFlamethrowerUpgrade()
	local selected = SGroup_CreateIfNotFound("selected")
	Misc_GetSelectedSquads(selected, false)
	
	if(SGroup_HasSquadBlueprint(selected, SBP.SOVIET.M02_COMBAT_ENGINEER_SQUAD, ALL) 
			and SGroup_GetNumSlotItem(selected, SLOT_ITEM.FLAMETHROWER_ROKS3_FAKE) < 1
			and not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		if squad_flameUpgrade ~= nil and scartype(squad_flameUpgrade) == ST_SQUAD then
			if(not Squad_IsValid(squad_flameUpgrade.id)) then
				--The squad with the Hintpoint is dead. Show newHUD hint.
				Util_NewHUDFeatureEvent(HUDF_CommandCard, 11042831, "Icons_upgrades_icon_upgrade_soviet_flamethrower", 6.5) -- LOCDB [11042831] 'Engineers can be upgraded to carry flamethrowers.'
			end
		end
		
		Event_Timer(EventHandler_RemoveHint, {hint = hpid_engineerUpgrade}, 3.0)		
		
		local flash_upgFlame = UI_FlashProductionButton(PITEM_SquadUpgrade, UPG.SOVIET.ENGINEER_FLAMETHROWER, true)
		Event_Timer(_StopFlashing, {id = flash_upgFlame}, 8)
	end
end




--Teach HQ usage
function InformHQ() --Called after camera pans to flamethrowers
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		Util_StartIntel(EVENTS.InformHQ)
		
		if(SGroup_CountSpawned(sg_alliedEngineers) > 0) then
			hpid_hq = HintPoint_Add(eg_hq, true, 11042844, 0.5)  -- LOCDB [11042844] 'HQ - Request reinforcements'
		else
			hpid_hq = HintPoint_Add(eg_hq, true, 11048209, 0.5)  -- LOCDB [11048209] 'HQ - Request engineers and reinforcements'
		end
		EGroup_SetSelectable(eg_hq, true)
		
		Event_IsSelected(TeachHQ, nil, eg_hq, ANY, 0.75)
		Rule_AddInterval(CheckHintHQ, 2.5)
	end
end

function TeachHQ()
	if(EGroup_IsOnScreen(player1, eg_hq, ANY, 0.75) and not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		Util_NewHUDFeatureEvent(HUDF_CommandCard, 11042845, "Icons_units_unit_soviet_engineer", 5)  -- LOCDB [11042845] 'Additional squads can be requested through the Headquarters'
	end
end

function CheckHintHQ()
	if(EGroup_IsProducingSquads(eg_hq, ANY)) then
		Rule_RemoveMe()
		HintPoint_Remove(hpid_hq)
	end
end



--[[ Field RIGHT ]]
function Scorch_CheckFieldRight() --Checks if the North fields have been torched
	if(EGroup_IsBurning(eg_hay2, ANY)) then
		Rule_RemoveMe()
		Objective_RemoveUIElements(SOBJ_TorchFields, hpid_hayRight)
		
		EGroup_SetInvulnerable(eg_hay2, false)
		
		Modifier_Remove(mod_fieldRight)
		
		--Stop flank encounter from re-spawning
		if(g_enc_flankFieldRight ~= nil) then 
			g_enc_flankFieldRight:RemoveOnDeath(true)
		end
		
		--Make allies run away
		if(SGroup_IsAlive(sg_alliesFieldRight)) then Cmd_Retreat(sg_alliesFieldRight, mkr_bridgeObj, mkr_bridgeObj) end
		
		--Set fields on fire
		g_markersNorth = Marker_GetSequence("mkr_fireNorth")
		Rule_AddInterval(BurnFieldRight, 1.2)
		
		g_rightFieldTorched = true
	end
end

function Scorch_AttackRightField()
	UI_CreateMinimapBlip(mkr_fireNorth1, 5, BT_AttackHere)
	EventCue_Create(CUE.ATTACKED, 11042832, nil, vp_fieldRight) -- LOCDB [11042832] 'Northern fields under attack'
	
	AttackRightField(g_enc_flankFieldRight)
end

function BurnFieldRight()
	if(#g_markersNorth == 0) then
		Rule_RemoveMe()
	else
		pos = Util_GetPosition(g_markersNorth[1])
		local id = Entity_Create(g_bpFire, player2, pos, pos)
		Entity_Spawn(id)
		
		table.insert(g_firesNorth, id)
		table.remove(g_markersNorth, 1)
	end
end



--[[ Field LEFT ]]
function Scorch_CheckFieldLeft() --Checks if the South fields have been torched
	if(EGroup_IsBurning(eg_hay1, ANY)) then
		Rule_RemoveMe()
		Objective_RemoveUIElements(SOBJ_TorchFields, hpid_hayLeft)
		
		EGroup_SetInvulnerable(eg_hay1, false)
		
		Modifier_Remove(mod_fieldLeft)
		
		--Stop flank encounter from re-spawning
		if(g_enc_flankFieldLeft ~= nil) then 
			g_enc_flankFieldLeft:RemoveOnDeath(true)
		end
		
		--Send 222 away
		Rule_AddOneShot(WithdrawLeftField, 5)
		
		--Start panic
		if(SGroup_IsAlive(sg_alliesFieldLeft)) then
			Sound_PlayOnSquad("speech/sp/mission/m02/11035421", sg_alliesFieldLeft)
			
			SGroup_SetInvulnerable(sg_alliesFieldLeft, true, 1)
			Rule_AddInterval(AlliedPanicRun, 0.5)
		end
		
		--Set fields on fire
		g_markersSouth = Marker_GetSequence("mkr_fireSouth")
		Rule_AddInterval(BurnFieldLeft, 0.75)
		
		g_leftFieldTorched = true
	end
end

function AlliedPanicRun()
	local posList = {mkr_fireSouth2, mkr_alliesFieldLeft2, mkr_engineersFieldLeft}
	if(SGroup_IsAlive(sg_alliesFieldLeft)) then
		Cmd_Retreat(sg_alliesFieldLeft, posList[World_GetRand(1, #posList)])
	else
		Rule_RemoveMe()
	end
end

function WithdrawLeftField() --Send attackers away
	if(sg_htFieldSouth and SGroup_CountSpawned(sg_htFieldSouth) > 0) then Cmd_Move(sg_htFieldSouth, mkr_spawnTrapLeft, nil, mkr_spawnTrapLeft) end
	
	if(g_enc_flankFieldLeft ~= nil) then 
		g_enc_flankFieldLeft:RemoveOnDeath(true)
		g_enc_flankFieldLeft:ClearGoal()
		if(SGroup_CountSpawned(g_enc_flankFieldLeft.sgroup) > 0) then
			Cmd_Move(g_enc_flankFieldLeft.sgroup, mkr_fireSouth1)
		end
	end
end

function Scorch_AttackLeftField()
	if(not EGroup_IsBurning(eg_hay1, ANY)) then
		Util_StartIntel(EVENTS.Scorch_Argument)
	end

	--Send in scout card for greater tension
	sg_htFieldSouth = Util_CreateSquads(player2, "sg_htFieldSouth", SBP.GERMAN.SCOUTCAR_SDKFZ222, mkr_flankSouth, mkr_destFieldHT, nil, nil, true)
	_ModifySpeed(sg_htFieldSouth, 0.85)
	
	--Increase intensity of attack
	AttackLeftField(g_enc_flankFieldLeft)
	
	UI_CreateMinimapBlip(mkr_fieldSouth, 5, BT_AttackHere)
	EventCue_Create(CUE.ATTACKED, 11042833, nil, mkr_engineersFieldLeft) -- LOCDB [11042833] 'Southern fields under attack'
end

function BurnFieldLeft()
	if(#g_markersSouth == 0) then
		Rule_RemoveMe()
	else
		pos = Util_GetPosition(g_markersSouth[1])
		local id = Entity_Create(g_bpFire, player2, pos, pos)
		Entity_Spawn(id)
		table.insert(g_firesSouth, id)
		table.remove(g_markersSouth, 1.2)
	end
end

-----------------------------------------------END OBJECTIVE 3------------------------------------------------











--[[********************************************************************************************************]]
----------------------------------------- OBJECTIVE 4 - Defend Trainyard -------------------------------------
--[[********************************************************************************************************]]
function Initialize_ObjDefend() --Setup defenses and hold off the Germans until the supply train is ready to depart

	OBJ_DefendTrainyard = {
		SetupUI = function()
		end,
		
		OnStart = function()
			--Update current objective
			m02_CurrentObjective = OBJ_DefendTrainyard
			
			for k, sObj in pairs(OBJ_DefendTrainyard.subObjectives) do
				if(sObj.onParentStart) then
					Objective_Start(sObj, false)
				end
			end
			
			Rule_AddDelayedInterval(Defend_RemindMobilize, 30, 90)
			
			--Music
			Sound_PlayMusic("streamed/music/missions/m02/m02_cue_set_trainyard_defenses", 0, 0)
			
			--If the house by the road is still alive and burning, destroy it.
			if(EGroup_CountSpawned(eg_burnHouse2) > 0) then
				EGroup_Kill(eg_burnHouse2)
			end
		end,
		
		OnComplete = function()
			--[[ACHIEVEMENT: Defend trainyard without using mines]]
			if(not Objective_IsComplete(SOBJ_PlaceMines) and not g_playerBuiltMines) then
				print("Achievement unlocked: Defended trainyard without using any mines")
				Scar_CompleteIntelBulletinTask(player1, "camp02_scorched_earth_no_mines")
			end
		
			Rule_AddOneShot(Defend_StartTrain, 2)
			Rule_Add(Escape_DelayedStart)
			
			BeginnerHint_RemoveAllOpportunities()
			
			Rule_Remove(Defend_RemindMobilize)
			Rule_Remove(Defend_MineCheck)
		end,
		
		OnFail = function()
			if(g_win == nil  and not Rule_Exists(Mission_MissionFail)) then Rule_AddOneShot(Mission_MissionFail, 3) end
		end,
		
		IsComplete = function()
			return false
		end,
		
		subObjectives = {},
		
		Intel_Start = EVENTS.Defend_Intro,
		Intel_Complete = EVENTS.Defend_EnemyTanks,
		Intel_Fail = nil,
		Title =  11042834, -- LOCDB [11042834] 'Defend the trainyard'
		TitleEnd = 11042835, -- LOCDB [11042835] 'Held off attacks'
		TitleFail = nil,
		Type = OT_Primary,
	}
	
	
	--[[ Sub-Objectives ]]
	SOBJ_PrepareDefenses = { --Prep defenses
		SetupUI = function()
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
			--Music
			Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT,0)
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,
		Intel_Complete = nil,			
		Intel_Fail = nil,				
		Title =  11048166, -- LOCDB [11048166] 'Prepare defenses'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,
		Parent = OBJ_DefendTrainyard,
		onParentStart = true,
	}
	
	SOBJ_PlaceMines = { --Setup mines and demopacks around trainyard
		SetupUI = function()
			t_mineHints = {
				{
					marker = trg_roadLeft,
					ui = Objective_AddUIElements(SOBJ_PlaceMines, trg_roadLeft, true, 11042837, true) -- LOCDB [11042837] 'Place mines'
				},
				{
					marker = trg_roadMain,
					ui = Objective_AddUIElements(SOBJ_PlaceMines, trg_roadMain, true, 11042837, true) -- LOCDB [11042837] 'Place mines'
				}
			}
			
			--Highlight mines
			Util_NewHUDFeatureEvent(HUDF_AbilityCard, 11049804, "Icons_abilities_ability_soviet_tm35_mines", 8) -- LOCDB [11049804] 'Engineers can lay anti-vehicle mines.'
			UI_FlashConstructionMenu("basic", true)
			UI_FlashConstructionButton(EBP.SOVIET.SOVIET_MINE_SP, true)
		end,
		
		OnStart = function()
			--T34 argument
			Event_Timer(EventHandler_StartIntel, {intel_callback = EVENTS.Defend_NoTanks}, 15)
			Event_Timer(EventHandler_StartIntel, {intel_callback = EVENTS.Defend_NoTanksInterrupt}, 16)
			Rule_AddOneShot(StukaFlyby, g_Defend_waitAttack*0.65)
			
			--Timer and reminders
			Objective_StartTimer(SOBJ_PrepareDefenses, COUNT_DOWN, g_Defend_waitAttack, 10)
			Rule_AddInterval(Defend_UpdateCountdown, 1)
			Rule_AddOneShot(Defend_FlashCountdown, g_Defend_waitAttack - 25) --Start flashing the ObjCounter when T-20s
			Rule_AddOneShot(Defend_RemindMines, g_Defend_waitAttack*0.5)
			
			--Check for mine placement
			Rule_AddDelayedInterval(Defend_MineCheck, 3, 2)
			
			Rule_AddOneShot(StartAttack, g_Defend_waitAttack)
		end,
		
		OnComplete = function()
			Rule_Remove(Defend_RemindMines)
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.Defend_Roads,				
		Intel_Complete = nil,			
		Intel_Fail = nil,				
		Title =  11042838,	 -- LOCDB [11042838] 'Place mines on roads leading to the trainyard'
		TitleEnd = 11048167, -- LOCDB [11048167] 'Mines have been placed'
		TitleFail = 11042840, -- LOCDB [11042840] 'No defenses were placed'
		Type = OT_Primary,
		Parent = OBJ_DefendTrainyard,
		onParentStart = true,
	}
	
	SOBJ_PreventBreach = { --Prevent germans from breaching trainyard
		SetupUI = function()
			hpid_trainyard = Objective_AddUIElements(SOBJ_PreventBreach, vp_hq, true, 11042841, true, 2.8) -- LOCDB [11042841] 'Prevent the Germans from breaching the trainyard'
		end,
		
		OnStart = function()
			--Setup waves
			sg_htCenter = SGroup_CreateIfNotFound("htCenter")
			sg_htLeft = SGroup_CreateIfNotFound("htLeft")
			sg_htRight = SGroup_CreateIfNotFound("htRight")
			
			sg_currentAttackers = SGroup_CreateIfNotFound("sg_currentAttackers")
			g_currentWave = 0
			t_encs_attack = {}
			
			t_attackList = {
				{
					wave = OpeningWave,
					threshold = 0.5,
					actions = {UpdateTrainyardTruckCargo1},
				},
				{
					wave = Wave2,
					timeout = 60,
					delay = 4,
					actions = {UpdateTrainyardTruckCargo2},
				},
				{
					wave = Wave3,
					timeout = 90,
					actions = {UpdateTrainyardTruckCargo3},
				},
				{
					wave = Wave4,
					timeout = 90,
					actions = {EvacTrainyardTrucks},
				},
				{
					wave = Wave5,
					timeout = 120,
					actions = {StartEvacTanks},
				},
			}
			
			Rule_AddOneShot(SpawnNextWave, 4)
			
			
			--Music
			Sound_PlayMusic("streamed/music/missions/m02/m02_cue_trainyard_battle", 0, 0)
			
			-- Player can now lose if tanks are destroyed.
			SGroup_SetInvulnerable(sg_tanks, false)
			
			--Prevent wrecks from blocking roads
			if(not Rule_Exists(_PreventWrecks)) then Rule_AddInterval(_PreventWrecks, 3, 750) end
			
			--Setup breach prox-checks and failure
			sg_moveEngineers = SGroup_CreateIfNotFound("sg_moveEngineers")
			
			Rule_AddInterval(Defend_WarnFailure, 1)
			Rule_AddInterval(Defend_CheckFailure, 1)
			
			--Give rifle grenades
			if(g_difficulty >= GD_NORMAL) then
				Player_SetAbilityAvailability(player2, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY, ITEM_UNLOCKED)
			end
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
			Game_SetMode(UI_Cinematic)
			Rule_Remove(SpawnNextWave)
			Rule_Remove(TimeoutWave)
			Rule_Remove(CheckWaveStrength)
			Objective_Fail(OBJ_DefendTrainyard, false)
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.Defend_Start,				
		Intel_Complete = nil,			
		Intel_Fail = EVENTS.Defend_Fail,
		Title =  11042841, -- LOCDB [11042841] 'Prevent the Germans from breaching the trainyard'
		TitleEnd = 11042842, -- LOCDB [11042842] 'Trainyard defended'
		TitleFail = 11042843, -- LOCDB [11042843] 'The Germans breached the train yard'
--~ 		TitleFail = 11042836, -- LOCDB [11042836] 'Critical assets have been lost'
		Type = OT_Primary,
		Parent = OBJ_DefendTrainyard,
		onParentStart = false,
	}
	
	
	table.insert(OBJ_DefendTrainyard.subObjectives, SOBJ_PrepareDefenses)
	table.insert(OBJ_DefendTrainyard.subObjectives, SOBJ_PlaceMines)
	table.insert(OBJ_DefendTrainyard.subObjectives, SOBJ_PreventBreach)
	
	
	Objective_Register(OBJ_DefendTrainyard)
	for k, obj in pairs(OBJ_DefendTrainyard.subObjectives) do
		Objective_Register(obj)
	end
end

function Defend_DelayedStart()
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		Objective_Start(OBJ_DefendTrainyard)
	end
end

function Defend_WarnFailure()
	if(Util_GetPlayerOwner(vp_hq) == nil) then
		Rule_RemoveMe()
		Util_StartIntel(EVENTS.Obj1_WarnFail)
		UI_CreateMinimapBlip(vp_hq, 8, BT_DefendHere)
		local hint_reclaim = HintPoint_Add(mkr_trainStation, true, 11050198, 1.0, HPAT_Critical) -- LOCDB [11050198] 'Reclaim the territory'
		Event_PlayerOwnsTerritory(EventHandler_RemoveHint, {hint = hint_reclaim}, player1, vp_hq)
		Event_PlayerOwnsTerritory(EventHandler_RemoveHint, {hint = hint_reclaim}, player2, vp_hq)
	end
end

function Defend_CheckFailure() --Check if trainyard territory is lost.
	if(Util_GetPlayerOwner(vp_hq) == player2) then
		Rule_RemoveMe()
		Objective_Fail(SOBJ_PreventBreach)
	end
end

function Defend_Complete()
	ThreatArrow_DestroyAllGroups()
	HintPoint_Remove(hpid_hq)
	HintPoint_Remove(hpid_munitions)
	
	Objective_Complete(SOBJ_PreventBreach, false)
	Objective_Complete(OBJ_DefendTrainyard, false)
end

function Defend_LaunchTanks() -- Scripted 3xPanzer attack on train yard from sides.
	t_tankEncs = {}
	sg_enemyTanks = SGroup_CreateIfNotFound("enemyTanks")
	
	TankCenter() -- *_encounters.scar file
	TankLeft()
	TankRight()
	Rule_AddOneShot(TankSupport, 4)
	
	SGroup_SetInvulnerable(sg_enemyTanks, true)
	SGroup_SetAnimatorState(sg_enemyTanks, "vehicle_variant", "f1")
	Event_PlayerCanSeeElement(Defend_Complete, nil, player1, sg_enemyTanks, ANY, 4.0)
end

function Defend_RemindMobilize()
	if(Player_GetPopulationPercentage(player1, CT_Personnel) <= 0.5
		and Player_CanCastAbilityOnPosition(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH, Marker_GetPosition(mkr_troopDrop))) then
			local flash_mobilize = UI_FlashAbilityButton(ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH, true)
			Event_Timer(EventHandler_StopFlashing, {flashID = flash_mobilize}, 6)
	end
end

--[[ MINES ]]
function Defend_RemindMines()
	if(#t_mineHints > 0) then
		Util_StartIntel(EVENTS.RemindMines)
		
		if(#t_mineHints > 1 and g_difficulty <= GD_NORMAL) then
			local engineers = Player_GetSquads(player1)
			SGroup_Filter(engineers, SBP.SOVIET.M02_COMBAT_ENGINEER_SQUAD, FILTER_KEEP)
			
			for i=1, SGroup_CountSpawned(engineers) do
				local hint_engineerMines = HintPoint_Add(SGroup_GetSpawnedSquadAt(engineers, i), true, 11049804)
				Event_IsSelected(EventHandler_RemoveHint, {hint = hint_engineerMines}, engineers, ANY, 2.0)
			end
		end
		
		for k,v in pairs(t_mineHints) do
			UI_CreateMinimapBlip(v.marker, 8, BT_DefendHere)
			Objective_RemoveUIElements(SOBJ_PlaceMines, v.ui)
			v.ui = Objective_AddUIElements(SOBJ_PlaceMines, v.marker, true, 11042837, true, nil, nil, nil, "Icons_abilities_ability_soviet_tm35_mines")
		end
	end
end

function Defend_MineCheck()
	local nearMarker = EGroup_CreateIfNotFound("nearMarker")
	
	if scartype(t_mineHints) == ST_TABLE then		-- This check is in case the objective's setupUI is called too late.
		for k=#t_mineHints, 1, -1 do
			--Check for mines
			Player_GetAllEntitiesNearMarker(player1, nearMarker, t_mineHints[k].marker)
			EGroup_Filter(nearMarker, EBP.SOVIET.SOVIET_MINE_SP, FILTER_KEEP)
			EGroup_FilterUnderConstruction(nearMarker, FILTER_REMOVE) --Make sure only completed mines are taking into account.
			
			if(EGroup_CountSpawned(nearMarker) > 0) then
				Objective_RemoveUIElements(SOBJ_PlaceMines, t_mineHints[k].ui)
				
				if(g_difficulty <= GD_NORMAL) then
					local hpid_moreMines = HintPoint_Add(t_mineHints[k].marker, true, 11049995, 1.0) -- LOCDB [11049995] 'Place additional mines to stop multiple vehicles'
					Event_Timer(EventHandler_RemoveHint, {hint = hpid_moreMines}, 11)
				end
				
				table.remove(t_mineHints, k)
			end
		end
		
		if(#t_mineHints == 0) then
			Rule_RemoveMe()
			Objective_Complete(SOBJ_PlaceMines)
		end
	end
end

function WarnMines()
	--Called from ScoutCar1 onDeath
	Util_StartIntel(EVENTS.Mines)
	
	if(g_difficulty == GD_EASY) then
		local nearMarker = EGroup_CreateIfNotFound("nearMarker")
		Player_GetAllEntitiesNearMarker(player1, nearMarker, trg_roadMain)
		EGroup_Filter(nearMarker, EBP.SOVIET.SOVIET_MINE_SP, FILTER_KEEP)
		EGroup_FilterUnderConstruction(nearMarker, FILTER_REMOVE) --Make sure only completed mines are taking into account.
		
		if(EGroup_CountSpawned(nearMarker) == 0) then
			local hpid_moreMines = HintPoint_Add(trg_roadMain, true, 11049995, 1.0) -- LOCDB [11049995] 'Place additional mines to stop multiple vehicles'
			Event_Timer(EventHandler_RemoveHint, {hint = hpid_moreMines}, 10)
		end
	end
end

function Defend_UpdateCountdown()
	if(g_countEvac <= g_Defend_waitAttack) then
		g_countEvac = g_countEvac + 1
		Obj_ShowProgress2(11042847, (g_Defend_waitAttack - g_countEvac)/g_Defend_waitAttack)  -- LOCDB [11042847] 'Time to prepare defenses'
	else
		Rule_RemoveMe()
		Obj_HideProgress()
	end
end

function Defend_FlashCountdown()
	Obj_SetProgressBlinking(true)
end



--[[ ATTACK ]]
function StartAttack() --Delayed Call from Scorch start
	Objective_StopTimer(SOBJ_PrepareDefenses)
	Objective_Complete(SOBJ_PrepareDefenses, false)
	Objective_Start(SOBJ_PreventBreach)
end

function Defend_UpdateTitle()
	Objective_UpdateText(SOBJ_PreventBreach, 11049616, nil) -- LOCDB [11049616] 'Protect the tanks'
	Objective_RemoveUIElements(SOBJ_PreventBreach, hpid_trainyard)
	hpid_protectTanks = Objective_AddUIElements(SOBJ_PreventBreach, sg_t34_2, true, 11049616, true) -- LOCDB [11049616] 'Protect the tanks'
end

function WarnTankHunters()
	Util_StartIntel(EVENTS.AttackTanks)
	for k,v in pairs (g_enc_tankAttackers.units) do
		HintPoint_Add(v.sgroup, true, 11048760)  -- LOCDB [11048760] 'Anti-Tank squads'
	end
end


--[[ Waves ]]
function SpawnNextWave()
	--Increase counter
	g_currentWave = g_currentWave + 1
	
	if(g_currentWave <= #t_attackList) then
		print("Spawning wave " .. g_currentWave .. "...") --Debug
		
		local currentEnemyCount = SGroup_TotalMembersCount(sg_currentAttackers)
		t_attackList[g_currentWave].wave()
		t_attackList[g_currentWave].numEntities = SGroup_TotalMembersCount(sg_currentAttackers) - currentEnemyCount
	
		if(t_attackList[g_currentWave].timeout) then
			print("Set to time-out in " .. t_attackList[g_currentWave].timeout .. " seconds.") --Debug
			Rule_AddOneShot(TimeoutWave, t_attackList[g_currentWave].timeout)
		elseif(t_attackList[g_currentWave].threshold ~= nil) then
			print("Threshold set to " .. t_attackList[g_currentWave].threshold .. " seconds.") --Debug
			Rule_AddDelayedInterval(CheckWaveStrength, 2, 2)
		else
			fatal("Wave does not have timeout or threshold.")
		end
		
		if(t_attackList[g_currentWave].actions ~= nil) then
			for k,action in pairs(t_attackList[g_currentWave].actions) do
				action()
			end
		end
	else
		Rule_Remove(TimeoutWave)
		Rule_Remove(CheckWaveStrength)
		--No longer check for failures or mines
		Rule_Remove(Defend_CheckFailure)
		Rule_Remove(Defend_MineCheck)
		
		Rule_AddOneShot(Defend_LaunchTanks, 1)
	end
end	

function TimeoutWave()
	print("Wave timeout!") --Debug
	
	for k,enc in pairs(t_encs_attack) do
		enc:RemoveOnDeath(true)
--~ 		enc:SetGoalOnSuccess(nil)
	end
	t_encs_attack = {}
	Rule_Remove(SpawnHalftrackCenter)
	Rule_Remove(SpawnHalftrackLeft)
	Rule_Remove(SpawnHalftrackRight)
	
	Rule_AddOneShot(SpawnNextWave, t_attackList[g_currentWave].delay or 0)
end

function CheckWaveStrength()
	if(SGroup_TotalMembersCount(sg_currentAttackers)/ t_attackList[g_currentWave].numEntities <= t_attackList[g_currentWave].threshold) then
		Rule_RemoveMe()
		
		print("Wave threshold reached!") --Debug
		
		Rule_AddOneShot(SpawnNextWave, t_attackList[g_currentWave].delay or 0)
	end
end

function StukaFlyby()
	Command_PlayerPosDirAbility(player2, player2, Marker_GetPosition(trg_roadMain), Marker_GetDirection(mkr_fireNorth2), BP_GetAbilityBlueprint("stuka_fake_bombing_strike"), true)
end

--Trainyard trucks
function UpdateTrainyardTruckCargo1()
	if(SGroup_IsAlive(sg_allies4)) then
		SGroup_SetAnimatorState(sg_trainyardTruck1, "supplies_loaded", "half")
	end
	
	if(SGroup_IsAlive(sg_allies5)) then
		SGroup_SetAnimatorState(sg_trainyardTruck2, "supplies_loaded", "half")
	end
end

function UpdateTrainyardTruckCargo2()
	if(SGroup_IsAlive(sg_allies4)) then
		SGroup_SetAnimatorState(sg_trainyardTruck1, "supplies_loaded", "majority")
	end
	
	if(SGroup_IsAlive(sg_allies5)) then
		SGroup_SetAnimatorState(sg_trainyardTruck2, "supplies_loaded", "majority")
	end
end

function UpdateTrainyardTruckCargo3()
	SGroup_SetAnimatorState(sg_trainyardTrucks, "engine_state", "on")
	
	if(SGroup_IsAlive(sg_allies4)) then
		SGroup_SetAnimatorState(sg_trainyardTruck1, "supplies_loaded", "full")
	end
	
	if(SGroup_IsAlive(sg_allies5)) then
		SGroup_SetAnimatorState(sg_trainyardTruck2, "supplies_loaded", "full")
	end
end

function EvacTrainyardTrucks()
	EGroup_SetAnimatorState(eg_train, "supplies_loaded", "full")
	
	if(SGroup_CountSpawned(sg_trainyardTruck2) ~= 0) then
		Cmd_MoveToAndDespawn(sg_trainyardTruck2, mkr_exit2)
	end
	
	Rule_AddOneShot(EvacTrainyardTrucks2, 6)
end

function EvacTrainyardTrucks2()
	if(SGroup_CountSpawned(sg_trainyardTruck1) ~= 0) then
		Cmd_MoveToAndDespawn(sg_trainyardTruck1, mkr_exit2)
	end
	
	if(SGroup_CountSpawned(sg_allies4) > 0) then
		Cmd_MoveToAndDespawn(sg_allies4, mkr_exit2)
	end
	
	if(SGroup_CountSpawned(sg_allies5) > 0) then
		Cmd_MoveToAndDespawn(sg_allies5, mkr_exit2)
	end
end

--[[ Evac Tanks ]]
function StartEvacTanks()
	Util_StartIntel(EVENTS.Defend_EvacVehicles)
	SGroup_EnableMinimapIndicator(sg_tanks, true)
	SGroup_SetSelectable(sg_tanks, true)
	EGroup_SetAnimatorState(eg_train, "supplies_loaded", "majority")
	Rule_AddOneShot(MoveEngineers, 4)
end

function MoveEngineers()
	if(SGroup_CountSpawned(sg_tanks) > 0) and t_tanks ~= nil then
		if scartype(t_tanks) == ST_TABLE and scartype(t_tanks[1]) == ST_SGROUP and SGroup_CountSpawned(t_tanks[1]) > 0 then
			local pos = SGroup_GetOffsetPosition(t_tanks[1], OFFSET_LEFT, 3.2)
			Util_CreateSquads(player3, sg_moveEngineers, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_trainLoad, pos, nil, nil, false)
			SGroup_SetInvulnerable(sg_moveEngineers, true)
			SGroup_SetAutoTargetting(sg_moveEngineers, "hardpoint_01", false)
			
			--Turn on tank engine
			SGroup_SetAnimatorState(t_tanks[1], "engine_state", "on")
			
			Event_Proximity(MoveTank, nil, sg_moveEngineers, t_tanks[1], 10, ANY, 4.0)
		end
	end
end

function MoveTank()
	--Despawn engineers
	SGroup_DestroyAllSquads(sg_moveEngineers)

	sg_tank = t_tanks[1]
	table.remove(t_tanks, 1)
	
	SGroup_SetPlayerOwner(sg_tank, player3)
	
	Cmd_SquadPath(sg_tank, "pth_tankExit", true, LOOP_NONE, false)
	
	Event_Proximity(DespawnTank, nil, sg_tank, mkr_bridgeObj, 6, ANY, 1)
end

function DespawnTank()
	Cmd_MoveToAndDespawn(sg_tank, mkr_exit2)
	if(table.getn(t_tanks) > 0) then
		Rule_AddOneShot(MoveEngineers, 1)
	end
end



--[[ Train ]]
function Defend_StartTrain()
	EGroup_DeSpawn(eg_blockerTrainFront)
	Rule_AddOneShot(RemoveTrainBlockers, 5)
	
	EGroup_SetPlayerOwner(eg_train, player3)
	
	Sound_Play3D("campaign/train_depart_mission_2", EGroup_GetSpawnedEntityAt(eg_train, 1))
	Rule_AddInterval(MoveTrain, 1.5)
end

function RemoveTrainBlockers()
	EGroup_DeSpawn(eg_blockersTrain)
end

function MoveTrain()
	if(Prox_AreEntitiesNearMarker(eg_train, mkr_trainDestination, ANY, 8)) then
		Rule_RemoveMe()
		EGroup_DeSpawn(eg_train)
	else
		local moveto = Util_GetPositionFromAtoB(EGroup_GetPosition(eg_train), mkr_trainDestination, 10)
		Command_EntityPos(player1, eg_train, CMD_Move, moveto)
	end
end

-----------------------------------------------END OBJECTIVE 4------------------------------------------------







--[[********************************************************************************************************]]
----------------------------------------------- OBJECTIVE 5 - Escape -----------------------------------------
--[[********************************************************************************************************]]
function Initialize_ObjEscape() --Fall back to the bridge before it is destroyed. 

	OBJ_Retreat = {
		SetupUI = function() 
			hpid_bridge = Objective_AddUIElements(OBJ_Retreat, mkr_bridgeObj, true, 11042850, true)  -- LOCDB [11042850] 'Fall back to the bridge'
		end,
		
		OnStart = function()
			--Update current objective
			m02_CurrentObjective = OBJ_Retreat
			
			--Give the player a little help (easy/normal) while retreating.
			mod_retreatHelp = Modify_ReceivedDamage(Player_GetSquads(player1), g_modRetreatDamage)
			
			Obj_HideProgress()
			--Take away HQ and conscript deploy
			EGroup_SetWorldOwned(eg_hq)
			Player_SetAbilityAvailability(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH, ITEM_LOCKED)
			Player_SetAbilityAvailability(player1, ABILITY.SOVIET.FRONTOVIKI_CONSCRIPT_DISPATCH, ITEM_LOCKED)
			Player_SetAbilityAvailability(player1, ABILITY.SOVIET.PENAL_TROOP_DISPATCH_SP, ITEM_LOCKED)
			
			local remindTimer = 40
			if(Player_GetPopulationPercentage(player1, CT_Personnel) <= 0.45) then
				remindTimer = 10
			end
			Rule_AddOneShot(Escape_Reminder, remindTimer)
			
			--Check player reached bridge
			Event_Proximity(Escape_Completed, nil, player1, {mkr_retreatCheck, mkr_bridgeObj}, nil, ANY, 2.0)
			Rule_AddInterval(Escape_CheckFailure, 2)
		end,
		
		OnComplete = function()
			if(not Misc_IsPosOnScreen(Marker_GetPosition(mkr_bridgeObj), 0.9)) then
				Game_SetMode(UI_Cinematic)
				Game_Letterbox(true, 1.5)
				Camera_ResetToDefault()
				Camera_SetSlideTargetRate(0.55)
				Camera_MoveTo(mkr_bridgeObj, true, g_panSpeed*0.33)
				
				Event_ElementOnScreen(Mission_MissionComplete, nil, player1, mkr_bridgeObj, nil, 0.6, 1.5)
			else
				Rule_AddOneShot(Mission_MissionComplete, 1.5)
			end
		end,
		
		OnFail = function()
			if(g_win == nil and not Rule_Exists(Mission_MissionFail)) then Rule_AddOneShot(Mission_MissionFail, 3) end
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.Escape_Intro,				
		Intel_Complete = nil,			
		Intel_Fail = nil,				
		Title =  11042850, -- LOCDB [11042850] 'Fall back to the bridge'
		TitleEnd = 11042851, -- LOCDB [11042851] 'Bridge reached'
		TitleFail = 11042852, -- LOCDB [11042852] 'Soviet forces have been destroyed'
		Type = OT_Primary,
	}
	Objective_Register(OBJ_Retreat)
end

function Escape_DelayedStart()
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		Objective_Start(OBJ_Retreat)
	end
end

function Escape_Completed() --Called when player1 reaches the fallback trigger
	Rule_Remove(Escape_Reminder)
	Rule_Remove(Escape_CheckFailure)
	Objective_Complete(OBJ_Retreat, false)
end

function Escape_Reminder()
	Util_StartIntel(EVENTS.Escape_NoFight)
	UI_CreateMinimapBlip(mkr_bridgeObj, 15, BT_General)
	UI_FlashSquadCommandButton(SCMD_Retreat, true)
end

function Escape_CheckFailure()
	if(Player_GetSquadCount(player1) == 0) then
		Rule_RemoveMe()
		Objective_Fail(OBJ_Retreat)
	end
end

--Not used
function Escape_AttackEvac()
	Event_Remove(event_retreatCheck)
	
	if(enc_tankCenter ~= nil and enc_tankCenter:IsAlive()) then
--~ 		print("center") --Debug
		Cmd_Stop(enc_tankCenter.sgroup)
		Cmd_SquadPath(enc_tankCenter.sgroup, "pth_tankAttack", true, LOOP_NONE, false, 0)
		enc_tankCenter:SetOnDeath(Escape_AttackEvac2)
		_ModifySpeed(enc_tankCenter.sgroup, 0.5)
	elseif(enc_tankRight ~= nil and enc_tankRight:IsAlive()) then 
--~ 		print("right") --debug
		Cmd_Stop(enc_tankRight.sgroup)
		Cmd_SquadPath(enc_tankRight.sgroup, "pth_tankAttack", true, LOOP_NONE, false, 0)
		enc_tankRight:SetOnDeath(Escape_AttackEvac2)
		_ModifySpeed(enc_tankRight.sgroup, 0.5)
	elseif(enc_tankLeft ~= nil and enc_tankLeft:IsAlive()) then
--~ 		print("left") --debug
		Cmd_Stop(enc_tankLeft.sgroup)
		Cmd_SquadPath(enc_tankLeft.sgroup, "pth_tankAttack", true, LOOP_NONE, false, 0)
		enc_tankLeft:SetOnDeath(Escape_AttackEvac2)
		_ModifySpeed(enc_tankLeft.sgroup, 0.5)
	end
end

--Not used
function Escape_AttackEvac2(enc)
--~ 	print("attack TWO: " .. enc.data.name) --debug
	--Replace tank
	if(enc.data.name == "tankCenter") then
		TankCenter()
	elseif(enec.data.name == "tankRight") then
		TankRight()
	elseif(enc.data.name == "tankLeft") then
		TankLeft()
	end

	if(not Objective_IsComplete(OBJ_Retreat)) then
		Util_StartIntel(EVENTS.Escape_NoFight)
	end

	--Find whichever tank is nearest and send him to attack
	local minDist = 999999
	local closest = nil
	for k,v in pairs(t_tankEncs) do
		if(not SGroup_IsEmpty(v.sgroup) and v.data.name ~= enc.data.name) then
			local dist = World_DistanceSGroupToPoint(v.sgroup, Marker_GetPosition(mkr_retreatCheck), true)
			if(dist < minDist) then
				closest = t_tankEncs[k]
			end
		end
	end
	
	if(closest ~= nil) then
--~ 		print("closest: " .. closest.data.name) --Debug
		Cmd_SquadPath(closest.sgroup, "pth_tankAttack", true, LOOP_NONE, false, 0)
	end
end

-----------------------------------------------END OBJECTIVE 5------------------------------------------------







--[[********************************************************************************************************]]
----------------------------------------------- BONUS OBJ - Keep ShockTroops alive ---------------------------
--[[********************************************************************************************************]]
function Initialize_ObjBonus() --Keep all 4 shocktroop squads alive
	--This objective is completed if the mission ends and the player has ShockTroops alive.
	OBJ_Bonus = {
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			Rule_AddInterval(Bonus_CheckFailure, 3)
		end,
		
		OnComplete = function()
			--[[ACHIEVEMENT: Kept shock troops alive]]
			print("Achievement unlocked: Kept shock troops alive")
			Scar_CompleteIntelBulletinTask(player1, "camp02_scorched_earth_bonus_shocktroops")
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.Bonus_Intro,				
		Intel_Complete = nil,			
		Intel_Fail = nil,				
		Title =  11046800, -- LOCDB [11046800] 'Keep Shock Troops alive'
		TitleEnd = nil,
		TitleFail = 11046801, -- LOCDB [11046801] 'All Shock Troop squads have been killed'
		Type = OT_Secondary,
	}
	Objective_Register(OBJ_Bonus)
end

function Bonus_DelayedStart()
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		Objective_Start(OBJ_Bonus)
	end
end

function Bonus_CheckFailure()
	if(SGroup_CountSpawned(sg_frontSovietsR) == 0 and SGroup_CountSpawned(sg_frontSovietsL) == 0) then
		Rule_RemoveMe()
		Objective_Fail(OBJ_Bonus, false)
	end
end







-------------------------------------------------------------------------
-- UTIL FUNCTIONS
-------------------------------------------------------------------------
function _CheckObjectiveCompletion(objTable)
	--SubObjectives
	for k, subObj in pairs(objTable.subObjectives) do
		if(Objective_IsStarted(subObj) and not Objective_IsComplete(subObj) and not Objective_IsFailed(subObj)) then
			if(subObj.IsComplete()) then
				Objective_Complete(subObj, false)
			elseif(subObj.IsFailed ~= nil and subObj.IsFailed()) then
				Objective_Fail(subObj, subObj.ShowFailTitle)
			end
		end
	end
	
	
	--Main objective
	if(objTable.IsComplete()) then
		return true
	elseif(objTable.IsFailed ~= nil and objTable.IsFailed()) then
		return false
	else
		return nil
	end
end

function _PreventWrecks()
	local wrecks = EGroup_CreateIfNotFound("wrecks")
	
	World_GetEntitiesNearMarker(player2, wrecks, trg_wrecks, OT_Neutral)
	EGroup_Filter(wrecks, t_wreckEBPs, FILTER_KEEP)
	EGroup_Kill(wrecks)
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

function _DisableInteraction(group)
	SGroup_EnableUIDecorator(group, false)
	SGroup_EnableMinimapIndicator(group, false)
	SGroup_SetSelectable(group, false)
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

function _CheckDemoPlacement(marker, range)
	local nearMarker = EGroup_CreateIfNotFound("nearMarker")
	Player_GetAllEntitiesNearMarker(player1, nearMarker, marker, range)
	EGroup_Filter(nearMarker, BP_GetEntityBlueprint("demo_charge"), FILTER_KEEP)
	
	return EGroup_CountSpawned(nearMarker) > 0
end

function _StopFlashing(data)
	UI_StopFlashing(data.id)
end

function _CheckHQ()
	if(EGroup_GetAvgHealth(eg_hq) <= 0) then
		Rule_RemoveMe()
		Util_MissionTitle(11048793, 1, 5, 1) -- LOCDB [11048793] 'Mission Failed: Headquarters Destroyed'
		Rule_AddOneShot(Mission_MissionFail, 5)
	end
end

function _CheckMinePlacement(player, blueprint)
	if(blueprint == EBP.SOVIET.SOVIET_MINE_SP) then
		Rule_RemoveMe()
		g_playerBuiltMines = true
	end
end



-- DEBUG FUNCTIONS
function SkipObjective()
	if(m02_CurrentObjective ~= nil and Misc_IsCommandLineOptionSet("dev")) then
		Objective_Complete(m02_CurrentObjective)
		--End sub-Objectives
		for k,obj in pairs(m02_CurrentObjective.subObjectives) do
			Objective_Complete(obj, false)
		end
	end
end

function TestBurnNorth()
	if Misc_IsCommandLineOptionSet("dev") then
		g_markersNorth = Marker_GetSequence("mkr_fireNorth")
		Rule_AddInterval(BurnFieldRight, 1)
	end
end

function TestBurnSouth()
	if Misc_IsCommandLineOptionSet("dev") then
		g_markersSouth = Marker_GetSequence("mkr_fireSouth")
		Rule_AddInterval(BurnFieldLeft, 1)
	end
end

function PrepDefend()
	if Misc_IsCommandLineOptionSet("dev") then
		Player_SetAbilityAvailability(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH, ITEM_DEFAULT)
		Player_SetAbilityAvailability(player1, ABILITY.SOVIET.FRONTOVIKI_CONSCRIPT_DISPATCH, ITEM_DEFAULT)
		
		Player_SetAbilityAvailability(player1, ABILITY.GLOBAL.FLAME_THROWER_ABILITY, ITEM_DEFAULT)
		Player_SetUpgradeAvailability(player1, UPG.SOVIET.ENGINEER_FLAMETHROWER, ITEM_DEFAULT)
		EGroup_SetSelectable(eg_flamethrowers, true)
		EGroup_EnableUIDecorator(eg_flamethrowers, true)
		
		SGroup_WarpToMarker(Player_GetSquads(player1), mkr_intersection)
		SGroup_SetSelectable(Player_GetSquads(player1), true)
		
		EGroup_DeSpawn(eg_forwardEntry1)
		EGroup_DeSpawn(eg_forwardEntry1L)
		EGroup_DeSpawn(eg_forwardEntry1R)
		EGroup_DeSpawn(eg_forwardEntry2)
		SGroup_DeSpawn(sg_supplyTrucks)
		EGroup_Kill(eg_burnHouses)
		SGroup_Kill(sg_alliesFieldRight)
		SGroup_Kill(sg_alliesFieldLeft)
		TestBurnNorth()
		TestBurnSouth()
		
		SGroup_SetInvulnerable(Player_GetSquads(player1), false)
		Player_SetSquadProductionAvailability(player1, SBP.SOVIET.SHOCK_TROOPS, ITEM_DEFAULT)
		
		EGroup_SetSelectable(eg_hq, true)
		
		Rule_AddInterval(_PreventWrecks, 3, 750)
		
		sg_htCenter = SGroup_CreateIfNotFound("htCenter")
		sg_htLeft = SGroup_CreateIfNotFound("htLeft")
		sg_htRight = SGroup_CreateIfNotFound("htRight")
		sg_currentAttackers = SGroup_CreateIfNotFound("sg_currentAttackers")
		g_currentWave = 0
		t_encs_attack = {}
	end
end

function LaunchWave(val)
	if Misc_IsCommandLineOptionSet("dev") then
		g_currentWave = val-1
		SpawnNextWave()
	end
end

function ClearAll()
	ClearEnemies()
	ClearAllies()
end

function ClearAllies()
	if Misc_IsCommandLineOptionSet("dev") then
		SGroup_SetPlayerOwner(sg_frontSovietsL, player1)
		SGroup_SetPlayerOwner(sg_frontSovietsR, player1)
		SGroup_SetPlayerOwner(sg_alliedEngineers, player1)
		SGroup_SetSelectable(sg_alliedEngineers, true)
		
		SGroup_SetWorldOwned(sg_tanks)
		SGroup_SetWorldOwned(sg_trainyardTruck1)
		SGroup_SetWorldOwned(sg_trainyardTruck2)
		SGroup_SetWorldOwned(sg_alliesFieldLeft)
		SGroup_SetWorldOwned(sg_alliesFieldRight)
		
		SGroup_DestroyAllSquads(Player_GetSquads(player3))
		
		SGroup_SetPlayerOwner(sg_tanks, player3)
		SGroup_SetPlayerOwner(sg_trainyardTruck1, player3)
		SGroup_SetPlayerOwner(sg_trainyardTruck2, player3)
		SGroup_SetPlayerOwner(sg_alliesFieldLeft, player3)
		SGroup_SetPlayerOwner(sg_alliesFieldRight, player3)
	end
end

function ClearEnemies()
	if Misc_IsCommandLineOptionSet("dev") then
		AI_RemoveAllEncounters()
		SGroup_DestroyAllSquads(Player_GetSquads(player2))
	end
end

function ClearIntro()
	if Misc_IsCommandLineOptionSet("dev") then
		for k,v in pairs(t_introUnits) do
			SGroup_DestroyAllSquads(v)
		end
	end
end

function Grab() --Grabs units currently selected and places them in sg_selected
	if Misc_IsCommandLineOptionSet("dev") then
		sg_selected = SGroup_CreateIfNotFound("sg_selected")
		Misc_GetSelectedSquads(sg_selected, false)
	end
end

