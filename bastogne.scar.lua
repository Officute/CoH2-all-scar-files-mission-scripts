print("\tLoading mission file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Bastogne
-- Designer: Ryan McGechaen
-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScriptSetup.scar") -- <== ### CRITICAL ELEMENT. 
import("XP1.scar")				-- Ardennes Assault functionality
import("Libraries/WaveManager/WaveManager_Core.scar")



-- [[ Objective files ]]
import("Bastogne_obj_CaptureRoad.scar")
import("Bastogne_obj_SecureRoad.scar")
import("Bastogne_obj_DefendRoad.scar")

-- [[ Encounter data ]]
import("Bastogne_encounters.scar")

-- early mission, so set up for beginner hints
import("XP1_BeginnerHints.scar")


-------------------------------------------------------------------------
-- [[ MISSION SETUP ]]
-------------------------------------------------------------------------
-- Initializes players
function Mission_SetupPlayers()
	player1 = Setup_Player(1, 11073202, "aef", 1)		-- player1 is always the human player
	player2 = Setup_Player(2, 11073205, "west_german", 2)		-- player2 is always the AI opponent
	player3 = Setup_Player(3, 11073202, "aef", 1)		-- player3 is always the AI ally
end

-- Defines key mission data and any global values used throughout the mission.
function Mission_SetupVariables()
	print("Initializing mission DATA...")
	g_missionData = {
		useBeginnerHints = false,					-- Wether or not to use the BeginnerHint system
		useEncounterSystem = true,					-- Whether or not to use the Encounter system
		useXP1Difficulty = true,					-- Whether or not this mission uses the XP1 Difficulty system
		missionType = MT_XP1_CHALLENGE,				-- What Mission Type is this mission? MT_
		introNIS = "XP1/Bastogne_Intro",			 					-- Movie filename
		introNISlet = nil,					 		-- NISlet triggered after introNIS
		introNISletSkipped = nil,	 				-- Function called if the introNISlet is skipped
		introSitRep = nil,							-- Movie (string) to play after intro nislet
		endNISlet = nil,							-- NISlet triggered on mission completion
		endNIS = nil,								-- Movie (string) to play on mission completion
		missionSpeechPath = "botb/gameplay",					-- Speech path to cache (string)
		precacheSounds = {							-- Any audio files you want precached (list of strings)
			"streamed/music/missions/m02/m02_cue_start_defend_front_line",
			"streamed/ambience_beds/blizzard_wind_bastogne",
			"emitters/blizzard_transition_out",

		},
		nisFiles = {								-- .nis files associated with the mission (path string)
		},
		nisInTransitionTime = 0,
		nisOutTransitionTime = 0,
		objectives = {								-- List of PARENT objective tables.
			OBJ_CaptureRoad,
			OBJ_SecureRoad,
			OBJ_DefendRoad,
		},
		secondaryObjectives = {
			{
				obj = SecondaryOBJ_KillVIP,
				data = {
					spawns = {
						{spawn = mkr_secObj_VIP_spawn01, ui = mkr_secObj_VIP_spawn01},
					},
					protectEncounter = ENCOUNTERS.SECOBJ_TANK_PROTECTION,
					additionalEncounters = {
						ENCOUNTERS.SecObj_VIP_medDef_01,
					},
				},
			},
			{
				obj = SecondaryOBJ_DestroyTank,
				data = {
					spawns = {
						{spawn = mkr_secObj_destroyTank_spawn01, ui = mkr_secObj_destroyTank_center,},
						{spawn = mkr_secObj_destroyTank_spawn02, ui = mkr_secObj_destroyTank_center,},
						{spawn = mkr_secObj_destroyTank_spawn03, ui = mkr_secObj_destroyTank_center,},
						{spawn = mkr_secObj_destroyTank_spawn04, ui = mkr_secObj_destroyTank_center,},
					},
					protectEncounter = ENCOUNTERS.SECOBJ_TANK_PROTECTION,
					additionalEncounters = {
						ENCOUNTERS.SecObj_destroyTank_medDef_01,
					},
				},
			},
--~ 			{
--~ 				obj = SecondaryOBJ_DemolitionMan,
--~ 				data = {
--~ 					target = eg_secObj_demolitionMan_target01,
--~ 					additionalEncounters = {
--~ 						ENCOUNTERS.SecObj_demolitionMan_medDef_01,
--~ 					},
--~ 				},
--~ 			},
			{
				obj = SecondaryOBJ_CaptureIntel,
				data = {
					locations = {
						mkr_secObj_captureIntel_spawn01,
						mkr_secObj_captureIntel_spawn02,
						mkr_secObj_captureIntel_spawn03,
						mkr_secObj_captureIntel_spawn04,
					},
					base_area = mkr_intelDropOff,
					number_to_spawn = 3,
					number_to_capture = 3,
					additionalEncounters = {
						ENCOUNTERS.SecObj_destroyTank_medDef_01,
						ENCOUNTERS.SecObj_VIP_medDef_01,
					},
				},
			},
			{
				obj = SecondaryOBJ_RescueSquads,
				data = {
					spawns = {
						eg_secObj_rescueAllies_spawn01,
						eg_secObj_rescueAllies_spawn02,
						eg_secObj_rescueAllies_spawn03,
					},
					failTime = 5*60,
				},
			},
		},
		startingUnits = {							-- Units to be spawned for P1 on mission start. Follows same parameters as Encounters.
		}
	}
--~ 	World_IncreaseInteractionStage()
--~ 	World_IncreaseInteractionStage()
--~ 	Mission_StartSecondaryObjective(true, false, 3)

	--[[GLOBAL VARIABLES]]	
	
	eg_weaponsrack_bar = EGroup_CreateIfNotFound("eg_weaponsrack_bar")
	eg_weaponsrack_bazooka = EGroup_CreateIfNotFound("eg_weaponsrack_bazooka")
	eg_weaponsrack_lmg = EGroup_CreateIfNotFound("eg_weaponsrack_lmg")
	
	-- node strength tuning flags
	g_starting_antitank = false				-- there will be anti-tank units on the field
	g_enemy_tanks = false					-- enemy will attack with tanks
	g_less_starting_vehicles = false		-- less startingvehicles for the player
	
	sg_starting_units = SGroup_CreateIfNotFound("sg_starting_units")
	sg_p_baseEchelon = SGroup_CreateIfNotFound("sg_p_baseEchelon")
	sg_p_officer = SGroup_CreateIfNotFound("sg_p_officer")
	
	sg_p_allStarting = SGroup_CreateIfNotFound("sg_p_allStarting")
	sg_p_sherman_01 = SGroup_CreateIfNotFound("sg_p_sherman_01")
	sg_p_sherman_02 = SGroup_CreateIfNotFound("sg_p_sherman_02")
	sg_p_sherman_03 = SGroup_CreateIfNotFound("sg_p_sherman_03")
	sg_p_greyhound_01 = SGroup_CreateIfNotFound("sg_p_greyhound_01")
	sg_p_riflemen_01 = SGroup_CreateIfNotFound("sg_p_riflemen_01")
	sg_p_riflemen_02 = SGroup_CreateIfNotFound("sg_p_riflemen_02")
	sg_p_riflemen_03 = SGroup_CreateIfNotFound("sg_p_riflemen_03")
	
	sg_e_truck_01 = SGroup_CreateIfNotFound("sg_e_truck_01")
	sg_e_truck_02 = SGroup_CreateIfNotFound("sg_e_truck_02")
	
	sg_e_at_01 = SGroup_CreateIfNotFound("sg_e_at_01")
	sg_e_forestBunk_01 = SGroup_CreateIfNotFound("sg_e_forestBunk_01")
	
	eg_p_retreat = EGroup_CreateIfNotFound("eg_p_retreat")
	
	sg_a_ambulences_entering = SGroup_CreateIfNotFound("sg_a_ambulences_entering")
	sg_a_ambulences_leaving = SGroup_CreateIfNotFound("sg_a_ambulences_leaving")
	
	sg_a_rearEchelon_01 = SGroup_CreateIfNotFound("sg_a_rearEchelon_01")
	sg_a_rearEchelon_02 = SGroup_CreateIfNotFound("sg_a_rearEchelon_02")
	sg_a_rearEchelon_03 = SGroup_CreateIfNotFound("sg_a_rearEchelon_03")
	sg_a_rearEchelon_04 = SGroup_CreateIfNotFound("sg_a_rearEchelon_04")
	
	sg_reinforcehints = SGroup_CreateIfNotFound("sg_reinforcehints")
	sg_vehiclesdecrewhints = SGroup_CreateIfNotFound("sg_vehiclesdecrewhints")
	
	eg_hints_fuelpoints = EGroup_CreateIfNotFound("eg_hints_fuelpoints")
	eg_hints_munitionspoints = EGroup_CreateIfNotFound("eg_hints_munitionspoints")
	eg_hints_garrison = EGroup_CreateIfNotFound("eg_hints_garrison")
	
	t_startEncounters = {}		-- Contains all encounters at start (so we can activate their goals later)
	t_startEvents = {}
	
	g_ambulence_current = 0
	g_ambulence_count = 7
	g_ambulence_entering = true
	
	g_alliedStrength = 1		-- Initial Allied Strength in Bastogne
	g_wounded = 0				-- How much wounded need to be evaced
	g_waves_complete = false	-- whether the enemy counterattacks are done
	
	tmr_lastSpottedEvent = "tmr_lastSpottedEvent"		-- Timer for spacing the 'spotted' events
	
	--[[MAP GROUPS]]
end

function Mission_SetDifficulty(diffVal)
	g_difficulty = diffVal or Game_GetSPDifficulty() 	-- Note: Having the diffVal parameter allows for redefining difficulty settings during runtime.
	AI_OverrideDifficulty(g_difficulty)
	
	--Global difficulty table
	t_difficulty = {
		startManpower = Util_DifVar({800, 600, 500}, g_difficulty),				-- Starting Manpower
		startMunition = Util_DifVar({120, 80, 50}, g_difficulty),				-- Starting Munitions
		startFuel = Util_DifVar({80, 60, 40}, g_difficulty),					-- Starting Fuel
		
		-- Node Strength
--~ 		germanBuildupTime = XP1_NodeDif({1.5*60, 1.2*60, 60, 55, 55}),			-- How fast does the German Buildup tick
		germanBuildupTime = Util_DifVar({1.5*60, 1.2*60, 60}, g_difficulty),			-- How fast does the German Buildup tick
		
		-- Defend Start time
		defendStartTime = Util_DifVar({2.5*60, 2.0*60, 1.5*60}, g_difficulty),
	}
	
	Player_SetResource(player1, RT_Manpower, t_difficulty.startManpower)
	Player_SetResource(player1, RT_Munition, t_difficulty.startMunition)
	Player_SetResource(player1, RT_Fuel, t_difficulty.startFuel)
	
	PM_AI_CPDefenses = true
	PM_PL_StartingResourceHit = true
	
	-- NODE STRENGTH TUNING ------------------------------
	if XP1_GetNodeStrength() >= 3 then 
		g_starting_antitank = true
	end
	
	if XP1_GetNodeStrength() >= 4 then 
		g_enemy_tanks = true
	end
	
	if XP1_GetNodeStrength() >= 5 then 
		g_less_starting_vehicles = true
	end
end

function Mission_SetupRestrictions()
	
end

-- Sets up the map before the mission starts (starting units, ownership, etc.)
function Mission_Preset()

	Camera_MoveTo(mkr_camera)
	
	-- Spawn Starting Units
	Util_CreateSquads(player1, {sg_p_sherman_01, sg_p_allStarting}, SBP.AEF.M4A3_SHERMAN_SQUAD_MP, mkr_p_sherman_spawn_01, mkr_p_sherman_dest_01)
	Util_CreateSquads(player1, {sg_p_greyhound_01, sg_p_allStarting}, SBP.AEF.M8_GREYHOUND_SQUAD_MP, mkr_p_greyhound_spawn_01, mkr_p_greyhound_dest_01)
	if XP1_GetDivision() == CD_MECHANIZED then
		Util_CreateSquads(player1, {sg_p_riflemen_01, sg_p_allStarting}, SBP.AEF.PM_RIFLEMEN_SQUAD_OMCG, mkr_p_rifle_spawn_01, mkr_p_rifle_dest_01)
		Util_CreateSquads(player1, {sg_p_riflemen_02, sg_p_allStarting}, SBP.AEF.PM_RIFLEMEN_SQUAD_OMCG, mkr_p_rifle_spawn_02, mkr_p_rifle_dest_02)
	elseif XP1_GetDivision() == CD_RANGER then
		Util_CreateSquads(player1, {sg_p_riflemen_01, sg_p_allStarting}, SBP.AEF.RANGER_SQUAD_MP, mkr_p_rifle_spawn_01, mkr_p_rifle_dest_01)
		Util_CreateSquads(player1, {sg_p_riflemen_02, sg_p_allStarting}, SBP.AEF.RANGER_SQUAD_MP, mkr_p_rifle_spawn_02, mkr_p_rifle_dest_02)
	else
		Util_CreateSquads(player1, {sg_p_riflemen_01, sg_p_allStarting}, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_p_rifle_spawn_01, mkr_p_rifle_dest_01)
		Util_CreateSquads(player1, {sg_p_riflemen_02, sg_p_allStarting}, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_p_rifle_spawn_02, mkr_p_rifle_dest_02)
	end
	
	-- NODE STRENGTH: less vehicles for player
	if g_less_starting_vehicles == false then
		Util_CreateSquads(player1, {sg_p_sherman_02, sg_p_allStarting}, SBP.AEF.M4A3_SHERMAN_SQUAD_MP, mkr_p_sherman_spawn_02, mkr_p_sherman_dest_02)
	end
	
	Util_CreateEntities(player1, eg_p_retreat, BP_GetEntityBlueprint("sp_retreat_point"), mkr_p_retreat_spawn, 1)
	
	-- Spawn Enemy HQs
--~ 	Util_CreateSquads(player2, sg_e_truck_01, SBP.WEST_GERMAN.SWS_HALFTRACK_SQUAD_MP, mkr_e_hq_03)
--~ 	Util_CreateSquads(player2, sg_e_truck_02, SBP.WEST_GERMAN.SWS_HALFTRACK_SQUAD_MP, mkr_e_hq_04)
--~ 	Cmd_Ability(sg_e_truck_01, BP_GetAbilityBlueprint("support_truck_target_setup"), mkr_e_hq_03, Util_GetOffsetPosition(mkr_e_hq_03, OFFSET_FRONT, 5))
--~ 	Cmd_Ability(sg_e_truck_02, BP_GetAbilityBlueprint("support_truck_target_setup"), mkr_e_hq_04, Util_GetOffsetPosition(mkr_e_hq_04, OFFSET_FRONT, 5))
--~ 	Event_PlayerCanSeeElement(CaptureRoad_MarkHQ, {_sgroup = sg_e_truck_01}, player1, sg_e_truck_01)
--~ 	Event_PlayerCanSeeElement(CaptureRoad_MarkHQ, {_sgroup = sg_e_truck_02}, player1, sg_e_truck_02)
	
	-- Spawn Allied Troops to repair
	Util_CreateSquads(player3, sg_a_rearEchelon_01, SBP.AEF.REAR_ECHELON_SQUAD_MP, Util_GetOffsetPosition(eg_XP1_player_base, OFFSET_FRONT, 5))
	Util_CreateSquads(player3, sg_a_rearEchelon_02, SBP.AEF.REAR_ECHELON_SQUAD_MP, Util_GetOffsetPosition(eg_XP1_player_base, OFFSET_BACK, 5))
	Util_CreateSquads(player3, sg_a_rearEchelon_03, SBP.AEF.REAR_ECHELON_SQUAD_MP, Util_GetOffsetPosition(eg_XP1_player_base, OFFSET_LEFT, 5))
	Util_CreateSquads(player3, sg_a_rearEchelon_04, SBP.AEF.REAR_ECHELON_SQUAD_MP, Util_GetOffsetPosition(eg_XP1_player_base, OFFSET_RIGHT, 5))
	
	-- Despawn Units
	SGroup_DeSpawn(sg_starting_units)
	Player_GetAllSquadsNearMarker(player1, sg_p_baseEchelon, Util_GetPosition(eg_XP1_player_base), 20)
	SGroup_Filter(sg_p_baseEchelon, {SBP.AEF.LIEUTENANT_SQUAD_MP, SBP.AEF.CAPTAIN_SQUAD_MP, SBP.AEF.MAJOR_SQUAD_MP}, FILTER_REMOVE, sg_p_officer)
	SGroup_DeSpawn(sg_p_baseEchelon)	
	if SGroup_IsEmpty(sg_p_officer) == false then
		SGroup_DeSpawn(sg_p_officer)
	end
	
	-- assign weapon rack buildings to groups
	EGroup_Clear(eg_temp)
	Player_GetAllEntitiesNearMarker(player1, eg_temp,  Util_GetPosition(eg_XP1_player_base), 20)
	EGroup_Filter(eg_temp, EBP.AEF.AEF_WEAPON_RACK_BROWNING_AUTOMATIC_RIFLE_MP, FILTER_REMOVE, eg_weaponsrack_bar)
	EGroup_Filter(eg_temp, EBP.AEF.AEF_WEAPON_RACK_BAZOOKA_MP, FILTER_REMOVE, eg_weaponsrack_bazooka)
	EGroup_Filter(eg_temp, EBP.AEF.AEF_WEAPON_RACK_M1919_LMG, FILTER_REMOVE, eg_weaponsrack_lmg)
	EGroup_AddEGroup(eg_XP1_player_base, eg_weaponsrack_bar)
	EGroup_AddEGroup(eg_XP1_player_base, eg_weaponsrack_bazooka)
	EGroup_AddEGroup(eg_XP1_player_base, eg_weaponsrack_lmg)
	EGroup_SetWorldOwned(eg_XP1_player_base)
	EGroup_SetSelectable(eg_XP1_player_base, false)
	
	-- Damage the base
	local _damagePlayerBase = function(gid, idx, eid)
		Entity_SetHealth(eid, 0)
	end
	EGroup_ForEach(eg_XP1_player_base, _damagePlayerBase)
	
	Rule_AddInterval(Bastogne_KeepBasesDamaged, 1)		-- Keep the base buildings damaged
	
	EGroup_EnableMinimapIndicator(eg_obb_cps, false)
	
	t_startEncounters = {
		{
			enc = ENCOUNTERS.Road1_Def(),
			eventID = nil,
			played = false,
		},
		{
			enc = ENCOUNTERS.Road2_Def(),
			eventID = nil,
			played = false,
		},
		{
			enc = ENCOUNTERS.Road3_Def(),
			eventID = nil,
			played = false,
		},
		{
			enc = ENCOUNTERS.Road4_Def(),
			eventID = nil,
			played = false,
		},
		{
			enc = ENCOUNTERS.CheckPoint1(),
			eventID = nil,
			played = false,
		},
		{
			enc = ENCOUNTERS.BasicEnc_C(),
			eventID = nil,
			played = false,
		},
		{
			enc = ENCOUNTERS.BasicEnc_D(),
			eventID = nil,
			played = false,
		},
		{
			enc = ENCOUNTERS.BasicEnc_E(),
			eventID = nil,
			played = false,
		},
	}
	
	for k,v in pairs(t_startEncounters) do
		local group = v.enc:GetSgroup()
		local event1 = Event_Proximity(DoNothing, nil, player1, group, 60)
		local event2 = Event_IsEngaged(DoNothing, nil, group, ANY, 2)
		
		local eventID = Event_CreateAND(Bastogne_Spotted, {_eventID = i}, {event1, event2})
		v.eventID = eventID
	end
	
	
	-- Stop Resource Income
	Resources_Disable()
	
	-- NODE STRENGTH TUNING
	-- spawn anti-tank guns
	if g_starting_antitank == true then
		Util_CreateSquads(player2, sg_e_at_01,SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, mkr_e_at_spawn_01)
	else
		EGroup_DeSpawn(eg_at_guns)
	end
	
end

function DoNothing()
end

-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
--Called once the intro nis/nislet/sitrep finishes playing.
function Mission_Start()
	Objective_Start(OBJ_CaptureRoad)	
	blizzardSound = Sound_Play2D("streamed/ambience_beds/blizzard_wind_bastogne")
	
	-- tell allied squads to repair the base
	Cmd_Ability(sg_a_rearEchelon_01, ABILITY.AEF.AEF_REPAIR_ABILITY_REAR_ECHELON_MP, eg_XP1_weapons_pool)
	Cmd_Ability(sg_a_rearEchelon_02, ABILITY.AEF.AEF_REPAIR_ABILITY_REAR_ECHELON_MP, eg_XP1_armor_command)
	Cmd_Ability(sg_a_rearEchelon_03, ABILITY.AEF.AEF_REPAIR_ABILITY_REAR_ECHELON_MP, eg_XP1_armored_rifle_command)
	Cmd_Ability(sg_a_rearEchelon_04, ABILITY.AEF.AEF_REPAIR_ABILITY_REAR_ECHELON_MP, eg_XP1_rifle_command)
	
	-- start up hints for capturable weapons and tanks
	Bastogne_UpdateHintGroups()
	Rule_AddInterval(Bastogne_UpdateHintGroups, 30)
	BeginnerHint_AddOpportunity(sg_vehiclesdecrewhints, ABILITY.AEF.VEHICLE_DECREW_GENERIC_MP, true)
	BeginnerHint_AddOpportunity(sg_vehiclesdecrewhints, ABILITY.AEF.VEHICLE_DECREW_VEHICLE_CREW_MP, true)
	BeginnerHint_AddOpportunity(eg_hints_munitionsboxes, HINT_PICKUP, true)
	
	BeginnerHint_TeamWeapons(eg_capturableTeamWeapons)
	BeginnerHint_AbandonedVehicles()
	
end

-- Called by above function in Mission_Start
function CaptureRoad_MarkHQ(data)
	HintPoint_Add(data._sgroup, true, 11076797)		-- LOCDB [11076797] 'Destroy Truck to allow territory capture'
end

function Bastogne_StartSlottable()
	World_IncreaseInteractionStage()
	Mission_StartSecondaryObjective(true, false)
end

function Bastogne_Transition_To_Snowing()
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/xp1/Bastogne_clear.aps", 40)
	blizzardSoundEnd = Sound_Play2D("emitters/blizzard_transition_out")
	Rule_AddOneShot(Bastogne_Transition_Out_Of_Blizzard, 45)
end

function Bastogne_Transition_Out_Of_Blizzard()	
	Sound_Stop(blizzardSound)
	Sound_Stop(blizzardSoundEnd)
end

function Bastogne_RemoveSoundContainer()
	Sound_Stop(blizzardSoundEnd)

end

function Bastogne_Transition_To_Overcast()
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/xp1/Bastogne_Overcast.aps", 2*60)	
end

-- Destroy Wrecks to clear for Ambulences
function Bastogne_ClearWrecksOffRoad()
	local t_wrecks = Marker_GetTable("mkr_clearWrecks_%02d")
	for i = 1, table.getn(t_wrecks) do
		Util_ClearWrecksFromMarker(t_wrecks[i])
	end
end

-- Spawn an ambulence and drive it down the road (if there's space)
function Bastogne_SpawnAmbulence()
	if g_ambulence_current <= g_ambulence_count then
		local sg = SGroup_Create("")
		local rand = World_GetRand(1, 3)
		local bp = SBP.AEF.DODGE_WC51_AMBULANCE_SQUAD_MP
		if rand == 3 then
			bp = SBP.AEF.DODGE_WC51_SQUAD_MP
		end
		local parentSG = sg_a_ambulences_entering
		local spawn = mkr_ambulence_spawn
		local path = "pth_ambulence"
		local deSpawn = mkr_ambulence_deSpawn
		if g_ambulence_entering == false then
			parentSG = sg_a_ambulences_leaving
			spawn = mkr_ambulence_return_spawn
			path = "pth_ambulence_exit"
			deSpawn = mkr_ambulence_return_deSpawn
		end
		
		Util_CreateSquads(player3, sg, bp, spawn)
		SGroup_AddGroup(parentSG, sg)
		Cmd_SquadPath(sg, path, true, false, false, 0)
		Cmd_MoveToAndDespawn(sg, deSpawn, true)
		
		g_ambulence_current = g_ambulence_current + 1
	else
		Rule_RemoveMe()
		g_ambulence_current = 0
		if g_ambulence_entering == true then
			g_ambulence_entering = false
		else
			g_ambulence_entering = true
		end
		return
	end
	Rule_ChangeInterval(Bastogne_SpawnAmbulence, World_GetRand(3, 6))
end

-- Despawn units that have retreated
function Bastogne_Despawn_Units(encounterID)
	local sg = encounterID:GetSgroup()
	SGroup_DestroyAllSquads(sg)
end

-- Plays when an encounter 'activates', plays some audio
function Bastogne_Spotted(data)		-- Fix this
	
	table.remove(t_startEvents, data._eventID)
	if (Timer_Exists(tmr_lastSpottedEvent) and Timer_GetRemaining(tmr_lastSpottedEvent) <= 0) or Timer_Exists(tmr_lastSpottedEvent) == false then
		Util_StartIntel(EVENTS.CaptureTheRoad_American_Spotted)
		Timer_Start(tmr_lastSpottedEvent, 20)
	end
end

-- Function is called after OBJ_CaptureRoad is completed
function Bastogne_CaptureComplete()
	Resources_Enable()
	
	SGroup_ReSpawn(sg_starting_units)		
	
	local _moveInStartingUnits = function(gid, idx, sid)
		local sg = SGroup_Create("")
		local markers = Marker_GetTable("mkr_company_startUnit_dest_%02d")
		
		SGroup_Add(sg, sid)
		Cmd_Move(sg, markers[idx])
		SGroup_Destroy(sg)
	end
	SGroup_ForEach(sg_starting_units, _moveInStartingUnits)
	
	if SGroup_IsEmpty(sg_p_officer) == false then
		SGroup_ReSpawn(sg_p_officer)
		Cmd_Move(sg_p_officer, Util_GetPosition(eg_XP1_player_base))
	end
	
	Rule_Remove(Bastogne_KeepBasesDamaged)
	
	EGroup_SetAvgHealth(eg_XP1_weapons_pool, 1)
	EGroup_SetAvgHealth(eg_XP1_armor_command, 1)
	EGroup_SetAvgHealth(eg_XP1_armored_rifle_command, 1)
	EGroup_SetAvgHealth(eg_XP1_rifle_command, 1)
	
	EGroup_SetPlayerOwner(eg_XP1_player_base, player1)
	EGroup_SetSelectable(eg_XP1_player_base, true)
	
	Cmd_Move(sg_a_rearEchelon_01, Util_GetPosition(eg_XP1_player_base))
	SGroup_SetPlayerOwner(sg_a_rearEchelon_01, player1)
	
	--Cmd_MoveToAndDespawn(sg_a_rearEchelon_02, mkr_a_deSpawn)
	--Cmd_MoveToAndDespawn(sg_a_rearEchelon_03, mkr_a_deSpawn)
	--Cmd_MoveToAndDespawn(sg_a_rearEchelon_04, mkr_a_deSpawn)
	
	Cmd_Move(sg_a_rearEchelon_02, mkr_a_deSpawn, nil, mkr_a_deSpawn)
	Cmd_Move(sg_a_rearEchelon_03, mkr_a_deSpawn, nil, mkr_a_deSpawn)
	Cmd_Move(sg_a_rearEchelon_04, mkr_a_deSpawn, nil, mkr_a_deSpawn)
	
	-- Base will be granted, de-spawn retreat point
	EGroup_DeSpawn(eg_p_retreat)
	
	-- Re-enable out of bounds resource points
	EGroup_EnableMinimapIndicator(eg_obb_cps, true)
	
	World_IncreaseInteractionStage()
	
	Util_MissionTitle(11076798, 2.5, 5, 2.5)		-- LOCDB [11076798] 'Base now available'
	
	UI_CreateMinimapBlip(eg_XP1_player_base, 5, BT_Reveal)
	
	-- Start Slottable Objective
	Event_Timer(Bastogne_StartSlottable, nil, 60)
	
	Event_Timer(Bastogne_Transition_To_Overcast, nil, 60)
	
	
	-- set up territory point groups
	World_GetStrategyPoints(eg_hints_fuelpoints, true)
	EGroup_Filter(eg_hints_fuelpoints, BP_GetEntityBlueprint("territory_fuel_point_mp"), FILTER_KEEP)
	World_GetStrategyPoints(eg_hints_munitionspoints, true)
	EGroup_Filter(eg_hints_munitionspoints, BP_GetEntityBlueprint("territory_munitions_point_mp"), FILTER_KEEP)
	
	-- start up some more beginnerhints
	BeginnerHint_AddOpportunity(sg_reinforcehints, HINT_REINFORCE, true)
	BeginnerHint_AddOpportunity(sg_reinforcehints, HINT_RETREAT, true)
	BeginnerHint_AddOpportunity(eg_hints_munitionspoints, HINT_MUNITIONSPOINT, true)
	BeginnerHint_AddOpportunity(eg_hints_fuelpoints, HINT_FUELPOINT, true)
	BeginnerHint_AddOpportunity(eg_hints_garrison, HINT_GARRISON, true)

end

function Bastogne_UpdateHintGroups()
	
	Player_GetAll(player1, sg_reinforcehints)
	SGroup_Filter(sg_reinforcehints, LIST.AEF_INFANTRY, FILTER_KEEP)
	
	local vehicle_list = {
		SBP.AEF.M10_TANK_DESTROYER_SQUAD_MP,
		SBP.AEF.M4A3_SHERMAN_SQUAD_MP,
		SBP.AEF.M15A1_AA_HALFTRACK_SQUAD_MP,
		SBP.AEF.M36_TANK_DESTROYER_SQUAD_MP,
		SBP.AEF.M3_HALFTRACK_SQUAD_MP,
		SBP.AEF.M5A1_STUART_SQUAD_MP,
		SBP.AEF.M7B1_PRIEST_SQUAD_MP,
		SBP.AEF.M8_GREYHOUND_SQUAD_MP,
		SBP.AEF.DODGE_WC51_AMBULANCE_SQUAD_MP,
		SBP.AEF.M20_UTILITY_CAR_SQUAD_MP,
		SBP.AEF.M4A3_76MM_SHERMAN_SQUAD_MP,
		SBP.AEF.M4A3_76MM_SHERMAN_BULLDOZER_SQUAD_MP,
		SBP.AEF.M8A1_HMC_SQUAD_MP,
	}
	
	Player_GetAll(player1, sg_vehiclesdecrewhints)
	SGroup_Filter(sg_vehiclesdecrewhints, vehicle_list, FILTER_KEEP)

end





function Bastogne_KeepBasesDamaged()
	if EGroup_GetAvgHealth(eg_XP1_weapons_pool) > 0.75 then
		EGroup_SetAvgHealth(eg_XP1_weapons_pool, 0.75)
	end
	if EGroup_GetAvgHealth(eg_XP1_armor_command) > 0.75 then
		EGroup_SetAvgHealth(eg_XP1_armor_command, 0.75)
	end
	if EGroup_GetAvgHealth(eg_XP1_armored_rifle_command) > 0.75 then
		EGroup_SetAvgHealth(eg_XP1_armored_rifle_command, 0.75)
	end
	if EGroup_GetAvgHealth(eg_XP1_rifle_command) > 0.75 then
		EGroup_SetAvgHealth(eg_XP1_rifle_command, 0.75)
	end
end

function SoundTest()

	--Sound_Play2D("streamed/ambience_beds/blizzard_wind_bastogne")
	--Sound_Play2D("emitters/blizzard_transition_out")

end
