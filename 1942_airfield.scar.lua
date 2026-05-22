print("\tLoading mission file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- 1942 ToW CHALLENGE: TATSINSKAIA AIRFIELD
-- Designer: NJR
-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScriptSetup.scar") -- <== ### CRITICAL ELEMENT. 
							--[[ 	The mission will not launch without this. It is the meat and potatoes of the new structure.
									All functions starting with 'Mission_' are automatically called by ScriptSetup.scar.
									Order of operations:
										Mission_SetupPlayers() 		-- Called by OnGameSetup() on frame1
										Mission_SetupVariables()
										Mission_SetDifficulty()
										Mission_SetupRestrictions()
										Mission_Preset()
										Objectives are registered
										Intro NIS
										Intro NISlet
										Sitrep
										Mission_Start()
							]]--

-- [[ Objective files ]]
import("1942_Airfield_Obj_DestroyAircraft.scar")
import("1942_Airfield_Obj_ControlTower.scar")
import("1942_Airfield_Obj_CounterAttack.scar")
import("1942_Airfield_Obj_FuelDepots.scar")

-- [[ Encounter data ]]
import("1942_Airfield_Encounters.scar")



-------------------------------------------------------------------------
-- [[ MISSION SETUP ]]
-------------------------------------------------------------------------
-- Initializes players
function Mission_SetupPlayers()
	--This is where you initialize your player variables. Depending on the type of scenario, this can vary.
	
	--For Missions/Challenges:
	player1 = Setup_Player(1, 11038758, "soviet", 1)		-- player1 is always the human player		"Red Army"
	player2 = Setup_Player(2, 11038759, "german", 2)		-- player2 is always the AI opponent		"Wehrmacht"
	
end

-- Defines key mission data and any global values used throughout the mission.
function Mission_SetupVariables()
	print("Initializing mission DATA...")
	
	-- ### CRITICAL ELEMENT. This table contains all the initialization data for the mission.
	-- All of these parameters are optional.
	g_missionData = {
		useBeginnerHints = true,					-- Wether or not to use the BeginnerHint system
		useEncounterSystem = true,					-- Whether or not to use the Encounter system
		introNIS = "tow_airfield",				-- Movie filename
		introNISlet = NIS_EVENTS.MissionStart, 		-- NISlet triggered after introNIS
		introNISletSkipped = nil,	 				-- Function called if the introNISlet is skipped
		introSitRep = nil,							-- Movie to play after intro nislet
		endNISlet = NIS_EVENTS.MissionComplete,		-- NISlet triggered on mission completion
		endNIS = nil,								-- Movie to play on mission completion
		missionSpeechPath = "theater_of_war/dlc1/c03",
		precacheSounds = {							-- Any audio files you want precached
--~ 			"campaign/train_depart_mission_2",
--~ 			"campaign/m02_panic_crowd"
		},
		nisFiles = {								-- .nis files associated with the mission
--~ 			"SP/CoH2_Campaign/M02-Scorched_Earth/nis/m02_introPan_v4",
		},
		nisInTransitionTime = 0,
		nisOutTransitionTime = 0,
		objectives = {								-- List of PARENT objective tables.
			OBJ_DestroyAircraft,	
			OBJ_ControlTower,	
			OBJ_Counterattack,	
			OBJ_FuelDepots,	
		}
	}
	
	
	--[[GLOBAL VARIABLES]]
	--	This is where you should define your global egroups/sgroups and variables
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	sg_blah = SGroup_CreateIfNotFound("sg_blah")
	sg_single = SGroup_CreateIfNotFound("sg_single")
	eg_temp = EGroup_CreateIfNotFound("eg_temp")
	eg_blah = EGroup_CreateIfNotFound("eg_blah")
	eg_single = EGroup_CreateIfNotFound("eg_single")
	
	
	sg_stuka_targets = SGroup_CreateIfNotFound("sg_stuka_targets")
	sg_controltower_hmg = SGroup_CreateIfNotFound("sg_controltower_hmg")
	
	
	--[[MAP GROUPS]]
	-- eg_aircraft			- all of the aircraft in the airfield that the player has to try and destroy
	-- eg_aircraft_1 to _7	- individual pockets of aircraft
	-- eg_controltower		- the control tower you have to try and get control of 
	-- eg_point_airfield	- the vp that controls the airfield (is sat on the control tower)
	-- eg_point_fueldepot1  - the point controlling the fuel depot to the south of the airfield
	-- eg_point_fueldepot2  - the point controlling the fuel depot to the north of the airfield
	
end

-- Defines difficulty tables/tuning variables
function Mission_SetDifficulty(diffVal)
	-- Define any difficulty-related settings or variables.
	-- These variables should be stored in a t_difficulty table for readability and access.
	
	g_difficulty = diffVal or Game_GetSPDifficulty() 	-- Note: Having the diffVal parameter allows for redefining difficulty settings during runtime.
	AI_OverrideDifficulty(g_difficulty)
	
	--Difficulty table
	t_difficulty = {
		stuka_wave_interval_min		= Util_DifVar({45,  45,  45}, g_difficulty),
		stuka_wave_interval_max		= Util_DifVar({60,  60,  60}, g_difficulty),
		starting_manpower			= Util_DifVar({120, 0,   0},  g_difficulty),
		starting_munitions			= Util_DifVar({75,  50,  25}, g_difficulty),
		aircraft_munitions_award	= Util_DifVar({75,  50,  25}, g_difficulty),
		topup_frequency				= Util_DifVar({180, 120, 60}, g_difficulty),
	}
	
	-- default encounter settings are for NORMAL, so if it's EASY or HARD we need to apply some modifiers to the AI encounter system
	if g_difficulty == GD_EASY then
		
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
				{
					tacticType = TACTIC_Pickup,
					priority = -1,
				},
			},
		}
		
		t_defaultGoalData_defendEasy = {
			
			retaliateAttacks = true,			
			
			tacticControlsList = {
				{
					tacticType = TACTIC_Cover,
					priority = 1,
					retryTimeSecs = 8,
					waitTimeSecs = 30,
				},
				{
					tacticType = TACTIC_Retaliate,
					priority = 1,
					retryTimeSecs = 8,
					waitTimeSecs = 15,
				},
				{
					tacticType = TACTIC_Vehicle,
					priority = -1,
				},
				{
					tacticType = TACTIC_Pickup,
					priority = -1,
				},
			},
		}
		
		AIAttackGoal_AdjustDefaultGoalData(t_defaultGoalData_attackEasy)
		AIDefendGoal_AdjustDefaultGoalData(t_defaultGoalData_defendEasy)	
		
		t_goalData_attackEasy = { 
			range_Multiplier = 0.9,
			movePathLengthFactor_Multiplier = 0.8,
			safeMoveWeight_Multiplier = 0.75,
		}
		
		t_goalData_defendEasy = { 
			range_Multiplier = 0.9,
			leashRange_Multiplier = 0.9,
			maxAttackers_Multiplier = -2,
			safeMoveWeight_Multiplier = 0.75,
		}
		
		AIAttackGoal_SetModifyGoalData(t_goalData_attackEasy)
		AIDefendGoal_SetModifyGoalData(t_goalData_defendEasy)
		
		
	elseif g_difficulty == GD_NORMAL then
		
		t_defaultGoalData_defendNormal = {
			
			retaliateAttacks = true,	
			
		}			
		
		AIDefendGoal_AdjustDefaultGoalData(t_defaultGoalData_defendNormal)	
		
		
	elseif g_difficulty == GD_HARD then
		
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
					retryTimeSecs = 2,
					waitTimeSecs = 2,
				},
				{
					tacticType = TACTIC_RushAtTarget,
					priority = 5,
					retryTimeSecs = 8,
					waitTimeSecs = 20,
				},
				{
					tacticType = TACTIC_Pickup,
					priority = 10,
					retryTimeSecs = 5,
					waitTimeSecs = 15,
				},
			},
		}
		
		t_defaultGoalData_defendHard = {
			
			retaliateAttacks = true,			
			retaliateAttackRange = 150,	
			
			tacticControlsList = {
				{
					tacticType = TACTIC_Cover,
					priority = 15,
					retryTimeSecs = 10,
					waitTimeSecs = 10,
				},
				{
					tacticType = TACTIC_Retaliate,
					priority = 10,
					retryTimeSecs = 2,
					waitTimeSecs = 2,
				},
				{
					tacticType = TACTIC_Vehicle,
					priority = 5,
					retryTimeSecs = 2,
					waitTimeSecs = 2,
				},
				{
					tacticType = TACTIC_Pickup,
					priority = 2,
					retryTimeSecs = 5,
					waitTimeSecs = 15,
				},
			},
		}
		
		AIAttackGoal_AdjustDefaultGoalData(t_defaultGoalData_attackHard)
		AIDefendGoal_AdjustDefaultGoalData(t_defaultGoalData_defendHard)	
		
		t_goalData_attackHard = { 		
			range_Multiplier = 1.2,
			movePathLengthFactor_Multiplier = 1.2,
			leashRange_Multiplier = 1.2,
			safeMoveWeight_Multiplier = 1.25,
		}
		t_goalData_defendHard = { 
			range_Multiplier = 1.2,
			movePathLengthFactor_Multiplier = 1.2,
			leashRange_Multiplier = 1.2,
			safeMoveWeight_Multiplier = 1.25,
		}		
		
		AIAttackGoal_SetModifyGoalData(t_goalData_attackHard)
		AIDefendGoal_SetModifyGoalData(t_goalData_defendHard)
		
	end
	
	if g_difficulty <= GD_NORMAL then
		Cmd_Upgrade(player2, BP_GetUpgradeBlueprint("panzerfaust_slow"))	
		ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_GRENADE = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN
	end
	
	
end

-- Sets restrictions on units, teams, etc.
function Mission_SetupRestrictions()
	-- Set any tech/ability restrictions on a players, as well as resource limits.
	--	Note: Resource Income/Caps should be defined in Mission_SetDifficulty()

	--[[ ToW YEAR SETTINGS ]]
	ToW_SetUpTechTreeByYear(player1, 1942)
	ToW_SetUpTechTreeByYear(player2, 1942)
	
	--[[ HUMAN PLAYER ]]
	Cmd_InstantUpgrade(player1, UPG.SOVIET.VEHICLE_SELF_REPAIR_TRAINING)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.CMD_VEHICLE_CREW_REPAIR_TRAINING, ITEM_REMOVED)
	--Player_SetUpgradeAvailability(player1, UPG.SOVIET.ENGINEER_MINESWEEPER, ITEM_REMOVED)
	Modify_AbilityMunitionsCost(player1, ABILITY.SOVIET.VEHICLE_CREW_REPAIR_ABILITY, 10, MUT_Addition)
	
	--[[ ALLIED PLAYER ]]
	
	--[[ ENEMY PLAYER ]]
	Player_AddAbility(player2, BP_GetAbilityBlueprint("tow_airfield_stuka_bombing_run"))				-- this objective script requires P2 has access to a specific ability
	
end

-- Sets up the map before the mission starts (starting units, ownership, etc.)
function Mission_Preset()
	-- This should only contain changes to the initial state of the map (spawn/despawn units or entities, diable holds, etc.).
	
	Camera_ResetToDefault()		-- there's a new default, but it takes this to reset the camera to it!
	
	-- various modifiers
	Modify_ReceivedDamage(eg_controltower, 0.1)		-- make the control tower tougher (it's gonna get hit with a lot of airstrikes!)
	
	-- create player's starting units
	Util_CreateSquads(player1, sg_blah, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, sg_halftrack)
	
	local _Squad1 = function(gid, idx, sid)
		Misc_SetSquadControlGroup(sid, 1)
	end
	SGroup_ForEach(sg_tanks1, _Squad1)
	
	local _Squad2 = function(gid, idx, sid)
		Misc_SetSquadControlGroup(sid, 2)
	end
	SGroup_ForEach(sg_tanks2, _Squad2)
	
	-- give player call-in abilities 
	Player_AddAbility(player1, BP_GetAbilityBlueprint("tow_airfield_dispatch_kv1"))
	Player_AddAbility(player1, BP_GetAbilityBlueprint("tow_airfield_dispatch_kv2"))
	Player_AddAbility(player1, BP_GetAbilityBlueprint("tow_airfield_dispatch_kv8"))
	Player_AddAbility(player1, BP_GetAbilityBlueprint("tow_airfield_dispatch_t34"))

	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("tow_airfield_dispatch_kv1"), ITEM_REMOVED)
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("tow_airfield_dispatch_kv2"), ITEM_REMOVED)
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("tow_airfield_dispatch_kv8"), ITEM_REMOVED)
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("tow_airfield_dispatch_t34"), ITEM_REMOVED)

	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.KV_1, ITEM_UNLOCKED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.KV_2, ITEM_UNLOCKED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.KV_8, ITEM_UNLOCKED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.T_34_76_SQUAD, ITEM_UNLOCKED)
	
	-- starting resources
	Player_SetResource(player1, RT_Munition, t_difficulty.starting_munitions)	-- 100, 75 or 50	
	Player_SetResource(player1, RT_Manpower, t_difficulty.starting_manpower)	-- 100, 0 or 0		
	Player_SetResource(player1, RT_Fuel, 0)		
	Player_SetResource(player1, RT_Command, 6)			-- make sure abilities are unlocked (hidden from player)
	
	Player_SetResource(player2, RT_Munition, 100)
	Modify_PlayerResourceRate(player2, RT_Munition, 5)
	
	Player_SetPopCapOverride(player1, 150)
	
	Resources_Disable()	-- no extra resource incoming for you!
	
	Rule_AddOneShot(HideCPMeter, 1)
	
end

function HideCPMeter()
	UI_SetCPMeterVisibility(false)
end




-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
function Mission_Start()
	--Called once the intro nis/nislet/sitrep finishes playing.
	
	-- issue move orders to all the player's tanks, so they come into view
	Cmd_SquadPath(sg_t34a, "path_t34a", false, LOOP_NONE, false, 0)
	Cmd_SquadPath(sg_t34b, "path_t34b", false, LOOP_NONE, false, 0)
	Cmd_SquadPath(sg_m5, "path_m5", false, LOOP_NONE, false, 0)
	
	Cmd_SquadPath(sg_kv1, "path_kv1", false, LOOP_NONE, false, 0)
	Cmd_SquadPath(sg_kv8, "path_kv8", false, LOOP_NONE, false, 0)
	Cmd_SquadPath(sg_t70a, "path_t70a", false, LOOP_NONE, false, 0)
	Cmd_SquadPath(sg_t70b, "path_t70b", false, LOOP_NONE, false, 0)
	Cmd_SquadPath(sg_t70c, "path_t70c", false, LOOP_NONE, false, 0)
	Cmd_SquadPath(sg_t70d, "path_t70d", false, LOOP_NONE, false, 0)
	
	-- intro speech 
	Util_StartIntel(EVENTS.MissionStart)
	
	-- kick off the main objective
	Event_Timer(EventHandler_ObjectiveStart, {objective = OBJ_ControlTower}, 2)

	-- start the mission complete / mission fail checks
	Rule_AddInterval(Mission_Complete, 1)
	Rule_AddDelayedInterval(Mission_Fail, 0.5, 1)
	
	-- set some misc functions going
	Rule_AddInterval(HintAtSelfRepair, 5)		-- when the player has a damaged tank selected, hint the self-repair ability

end





-- tell the player about the self-repair ability
function HintAtSelfRepair()
	
	if Event_IsAnyRunning() == false then
		
		-- get the selected units
		Misc_GetSelectedSquads(sg_temp, false)
		SGroup_Filter(sg_temp, LIST.INFANTRY, FILTER_REMOVE)
		
		-- filter the group down so that it's only player 1, selected, damaged vehicles in the group
		local _CheckSquad = function(gid, idx, sid)
			if Player_OwnsSquad(player1, sid) == false or Squad_GetHealthPercentage(sid) >= 0.6 or Squad_IsUnderAttack(sid, 5) then	
				SGroup_Remove(gid, sid)
			end
		end
		SGroup_ForEach(sg_temp, _CheckSquad)
		
		-- if there is a P1 damaged vehicle, then show the hint
		if SGroup_Count(sg_temp) >= 1 and Player_GetResource(player1, RT_Munition) >= 40 then
			
			UI_NewHUDFeature(HUDF_None, 11052229, "Icons_abilities_ability_soviet_crew_repair", 10)	-- LOCDB [11052229] "Vehicle crews can repair their own vehicle, but it costs munitions. The vehicle is also inoperable while it is repairing."
			flashid_repair = UI_FlashAbilityButton(ABILITY.SOVIET.VEHICLE_CREW_REPAIR_ABILITY, true)
			
			Rule_Add(HintAtSelfRepair_Remove)
			Rule_RemoveMe()
			
		end
		
	end
	
end
function HintAtSelfRepair_Remove()

	-- get the selected units
	Misc_GetSelectedSquads(sg_temp, false)
	SGroup_Filter(sg_temp, LIST.INFANTRY, FILTER_REMOVE)
	
	-- filter the group down so that it's only player 1, selected, damaged vehicles in the group
	local _CheckSquad = function(gid, idx, sid)
		if Player_OwnsSquad(player1, sid) == false or Squad_GetHealthPercentage(sid) >= 0.6 or Squad_IsUnderAttack(sid, 5) then	
			SGroup_Remove(gid, sid)
		end
	end
	SGroup_ForEach(sg_temp, _CheckSquad)
	
	if SGroup_Count(sg_temp) == 0 or Player_GetResource(player1, RT_Munition) < 40 then
		
		UI_StopFlashing(flashid_repair)
		Rule_RemoveMe()
		
	end
	
end



-- Mission Complete sequence
function Mission_Complete()

	if Objective_IsComplete(OBJ_ControlTower) and Objective_IsComplete(OBJ_DestroyAircraft) and Objective_IsComplete(OBJ_Counterattack) then
		
		Event_RemoveAll()
		Rule_RemoveAll()
		
		if Util_GetDistance(Camera_GetTargetPos(), last_know_tiger_position) <= 40 then
			Camera_MoveTo(last_know_tiger_position, true, 0.2, true)
		end
		
		Util_StartIntel(EVENTS.MissionComplete)
		Event_NarrativeEventsNotRunning(Mission_Complete_PartB, nil, 1)
		
	end
	
end
function Mission_Complete_PartB()
	Game_EndSP(true)
end


-- Mission Fail sequence
function Mission_Fail()
	
	if Event_IsAnyRunning() == false then
		
		Player_GetAll(player1)
		if SGroup_CountSpawned(sg_allsquads) == 0 then
			
			Event_RemoveAll()
			Rule_RemoveAll()
			
			Util_StartIntel(EVENTS.MissionFailed)
			Event_NarrativeEventsNotRunning(Mission_Fail_PartB, nil, 1)
			
		end
		
	end
	
end
function Mission_Fail_PartB()
	Game_EndSP(false)
end
