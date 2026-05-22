print("\tLoading mission file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Elsenborn Ridge
-- Designer: Ryan McGechaen
-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScriptSetup.scar") -- <== ### CRITICAL ELEMENT. 
import("XP1.scar")				-- Ardennes Assault functionality

--~ import("Libraries/WaveDefense.scar")
import("Libraries/WaveManager/WaveManager_Core.scar")
import("Metrics.scar")

-- [[ Objective files ]]
import("Elsenborn_Ridge_obj_HoldTheLine.scar")
import("Elsenborn_Ridge_obj_CaptureTheCheckpoint.scar")

-- [[ Encounter data ]]
import("Elsenborn_Ridge_encounters.scar")

-- early mission, so set up for beginner hints
import("XP1_BeginnerHints.scar")


-------------------------------------------------------------------------
-- [[ MISSION SETUP ]]
-------------------------------------------------------------------------
-- Initializes players
function Mission_SetupPlayers()
	player1 = Setup_Player(1, 11073202, "aef", 1)			-- player1 is always the human player	-- LOCDB [11073202] 'US Forces'
	player2 = Setup_Player(2, 11073205, "west_german", 2)	-- player2 is always the AI opponent	-- LOCDB [11073205] 'Oberkommando West'
	player3 = Setup_Player(3, 11079507, "aef", 1)			-- player3 is always the AI ally		-- LOCDB [11079507] '5th Corps'
end

-- Defines key mission data and any global values used throughout the mission.
function Mission_SetupVariables()
	print("Initializing mission DATA...")
	g_missionData = {
		useEncounterSystem = true,					-- Whether or not to use the Encounter system
		useXP1Difficulty = true,					-- Whether or not this mission uses the XP1 Difficulty system
		missionType = MT_XP1_CHALLENGE,				-- What Mission Type is this mission? MT_
		introNIS = "XP1/Elsenborn_Ridge_Intro",			 					-- Movie filename
		introNISlet = nil,					 		-- NISlet triggered after introNIS
		introNISletSkipped = nil,	 				-- Function called if the introNISlet is skipped
		introSitRep = nil,							-- Movie (string) to play after intro nislet
		endNISlet = nil,							-- NISlet triggered on mission completion
		endNIS = nil,								-- Movie (string) to play on mission completion
		missionSpeechPath = "botb/gameplay",					-- Speech path to cache (string)
		precacheSounds = {							-- Any audio files you want precached (list of strings)
			"streamed/music/missions/m02/m02_cue_start_defend_front_line",
		},
		nisFiles = {								-- .nis files associated with the mission (path string)
		},
		nisInTransitionTime = 0,
		nisOutTransitionTime = 0,
		objectives = {								-- List of PARENT objective tables.
			OBJ_HoldTheLine,							-- These are the global references to the objective tables defined in the separete files.
			OBJ_CaptureTheCheckpoint,
		}, -- Mission_StartSecondaryObjective(false, true, 2)
		secondaryObjectives = {
			{
				obj = SecondaryOBJ_KillVIP,
				data = {
					spawns = {
						{spawn = mkr_secObj_VIP_spawn01, ui = mkr_secObj_destroyTank_center},
						{spawn = mkr_secObj_VIP_spawn02, ui = mkr_secObj_destroyTank_center},
						{spawn = mkr_secObj_VIP_spawn03, ui = mkr_secObj_destroyTank_center},
					},
					additionalEncounters = {
						ENCOUNTERS.SecObj_VIP_smlDef_01,
--~ 						ENCOUNTERS.SecObj_VIP_smlDef_02,
--~ 						ENCOUNTERS.SecObj_VIP_smlDef_03,						
						ENCOUNTERS.SecObj_VIP_medDef_01,
					},
				},
			},
			{
				obj = SecondaryOBJ_RescueSquads,
				data = {
					spawns = {
						eg_secObj_rescueSquads_spawn01, eg_secObj_rescueSquads_spawn02,
						eg_secObj_rescueSquads_spawn03, eg_secObj_rescueSquads_spawn04,
					},
					exitOptions = {mkr_e_retreat_secObj},
					failTime = 5*60,
				},
			},
			{
				obj = SecondaryOBJ_DestroyTank,
				data = {
					protectEncounter = ENCOUNTERS.SecObj_destroyTank,
					spawns = {
						{spawn = mkr_secObj_destroyTank_spawn01, ui = mkr_secObj_destroyTank_center,},
						{spawn = mkr_secObj_destroyTank_spawn02, ui = mkr_secObj_destroyTank_center,},
						{spawn = mkr_secObj_destroyTank_spawn03, ui = mkr_secObj_destroyTank_center,},
						{spawn = mkr_secObj_destroyTank_spawn04, ui = mkr_secObj_destroyTank_center,},
						{spawn = mkr_secObj_destroyTank_spawn05, ui = mkr_secObj_destroyTank_center,},
					},
				},
			},
--~ 			{
--~ 				obj = SecondaryOBJ_DemolitionMan,
--~ 				data = {
--~ 					target = eg_secObj_demolitionMan_building,
--~ 					additionalEncounters = {
--~ 						ENCOUNTERS.SecObj_demoMan_smlDef_01,
--~ 						ENCOUNTERS.SecObj_demoMan_smlDef_02,
--~ 					},
--~ 				},
--~ 			},
			{
				obj = SecondaryOBJ_CaptureIntel,
				data = {
					locations = {mkr_secObj_captureIntel_01, mkr_secObj_captureIntel_02, mkr_secObj_captureIntel_03, mkr_secObj_captureIntel_04,
								mkr_secObj_captureIntel_05, mkr_secObj_captureIntel_06, mkr_secObj_captureIntel_07},
					number_to_spawn = 1,
					number_to_capture = 1,
					base_area = mkr_secObj_captureIntel_base,
					additionalEncounters = {
						ENCOUNTERS.SecObj_VIP_smlDef_01,
						ENCOUNTERS.SecObj_VIP_smlDef_02,
						ENCOUNTERS.SecObj_VIP_smlDef_03,						
						ENCOUNTERS.SecObj_VIP_medDef_01,
					},
				},
			},
		},
		startingUnits = {							-- Units to be spawned for P1 on mission start. Follows same parameters as Encounters.
			{
				sbp = SBP.AEF.REAR_ECHELON_SQUAD_MP,
				spawn = mkr_startingUnit_01,
			},
			{
				sbp = SBP.AEF.RIFLEMEN_SQUAD_MP,
				spawn = mkr_startingUnit_02,
			},
			{
				sbp = SBP.AEF.RIFLEMEN_SQUAD_MP,
				spawn = mkr_startingUnit_03,
			},
			{
				sbp = SBP.AEF.REAR_ECHELON_SQUAD_MP,
				spawn = mkr_startingUnit_04,
			},
--~ 			{
--~ 				sbp = SBP.AEF.REAR_ECHELON_SQUAD_MP,
--~ 				spawn = mkr_startingUnit_05,
--~ 			},
		}
	}
	
	--[[GLOBAL VARIABLES]]	
	sg_e_wave_all = SGroup_CreateIfNotFound("sg_e_wave_all")
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	sg_final_tank_01 = SGroup_CreateIfNotFound("sg_final_tank_01")
	sg_final_tank_02 = SGroup_CreateIfNotFound("sg_final_tank_02")
	
	sg_reinforcehints = SGroup_CreateIfNotFound("sg_reinforcehints")
	sg_capturehints_processed = SGroup_CreateIfNotFound("sg_capturehints_processed")
	sg_tankhints_targets = SGroup_CreateIfNotFound("sg_tankhints_targets")
	
	
	g_barrageCount = 0 		-- Used to track the number of times the player calls the artillery barrage.
	g_bufferTime = 15			-- Time between ending a barrage and starting a wave. Ensures the artillery is finished firing
	g_missionComplete = false
	g_missionTime = 0
	g_playerStoppedWave = false	-- flag for when the player presses the artillery button and we pause wave spawning
	g_artillery_removed = false	-- flag used to detect if the artillery ability was removed. Used for speech event purposes.
	g_artillery_ready = false			-- flag used to detect if the artillery ability is ready to be used. Used for speech event purposes.
	
	t_smokeScreenMkrs = Marker_GetTable("mkr_smokeScreen_%02d")
	
	tmr_objHoldTheLine_clock = "tmr_objHoldTheLine_clock"
	
	-- Define all timings
	g_initialBarrage = 2*60 + 30
	t_waveLengths = {140, 150, 160, 170, 180}
	t_barrageTimes = {105, 80, 80, 45}
	
	g_artilleryTimerMod = 20
	g_artilleryCooldownTimer = 180
	
	-- TEMP
	g_smokeDrops = 0
	
	--[[MAP GROUPS]]
	-- eg_atgun					-- group for the starting at gun (we despawn it on hard)
	--	eg_extra_defenses	-- group for a few extra team weapons for player to use, despawned at higher node strength
end

function Mission_SetDifficulty(diffVal)
	g_difficulty = diffVal or Game_GetSPDifficulty() 	-- Note: Having the diffVal parameter allows for redefining difficulty settings during runtime.
	AI_OverrideDifficulty(g_difficulty)
	
	--Global difficulty table
	t_difficulty = {
		startManpower = Util_DifVar({900, 700, 500}, g_difficulty),				-- Starting Manpower
		startMunition = Util_DifVar({240, 200, 50}, g_difficulty),				-- Starting Munitions
		startFuel = Util_DifVar({140, 120, 90}, g_difficulty),					-- Starting Fuel
--~ 		wave_pause_time = Util_DifVar({80, 60, 45}, g_difficulty),		-- how long the wave is paused when the player uses artillery
		
		barrageTime = {
			Util_DifVar({140, 120, 100}, g_difficulty),							-- First Break
			Util_DifVar({120, 100, 80}, g_difficulty),							-- Second Break
			Util_DifVar({120, 100, 80}, g_difficulty),							-- Third Break
			Util_DifVar({80, 60, 45}, g_difficulty),							-- Fourth Break
			Util_DifVar({80, 60, 45}, g_difficulty),							-- Fourth Break
		},
		
		-- Secondary Obj
		secObjStart = Util_DifVar({7*60, 11*60, 14*60}, g_difficulty),							-- How long into the mission before the secondary objective starts
	}
	
	Player_SetResource(player1, RT_Manpower, t_difficulty.startManpower)
	Player_SetResource(player1, RT_Munition, t_difficulty.startMunition)
	Player_SetResource(player1, RT_Fuel, t_difficulty.startFuel)
	
	PM_PL_StartingResourceHit = true
	PM_PL_Defenses = true
end

function Mission_SetupRestrictions()
	--TODO: Set any tech/ability restrictions on a players, as well as resource limits.
	--	Note: Resource Income/Caps should be defined in Mission_SetDifficulty()
	
	--[[ HUMAN PLAYER ]]
	
	--[[ ALLIED PLAYER ]]
	Player_AddAbility(player3, BP_GetAbilityBlueprint("sp_240mm_off_map_barrage"))
	Player_AddAbility(player3, BP_GetAbilityBlueprint("il-2_support"))
	Player_AddAbility(player3, BP_GetAbilityBlueprint("pm_airborne_strafe"))
	
	--[[ ENEMY PLAYER ]]
	Player_AddAbility(player2, BP_GetAbilityBlueprint("off_map_single_shot_smoke"))
	
end

-- Sets up the map before the mission starts (starting units, ownership, etc.)
function Mission_Preset()
	Cmd_CriticalHit(player1, eg_sherman_noInteract, CRIT.VEHICLE_LOSE_TREADS_OR_WHEELS, 0.99)
	EGroup_SetSelectable(eg_sherman_noInteract, false)
	Setup_Attack_Data()
	Player_AddAbility(player1, BP_GetAbilityBlueprint("pm_trigger_artillery"))
	
	-- NODE STRENGTH: if high enough, despawn some of the team weapons
	if XP1_GetNodeStrength() >= 3 or g_difficulty ~= GD_EASY then
		EGroup_DeSpawn(eg_extra_defenses)
	end
	
	if g_difficulty == GD_HARD then
		EGroup_DeSpawn(eg_atgun)
	end
	
	-- Reduce player experience because this mission gives way too much experience
	Modify_PlayerExperienceReceived(player1, 0.3)
end


-- Function called when player uses the artillery support
function AE_Trigger_Elsen_Artillery()
	Modify_AbilityRechargeTime(player1, BP_GetAbilityBlueprint("pm_trigger_artillery"), g_artilleryTimerMod, MUT_Addition)
	print("**** Player pressed artillery button!! ***")
	g_barrageCount = g_barrageCount + 1
	
	-- Stop attacks here
	Util_StartIntel(EVENTS.FireArtillery)
	Fire_Artillery_Delayed()	-- fire artillery
	Util_StartIntel(EVENTS.ArtilleryFiring)
	
	-- pause the waves, unpause them after a delay
	g_playerStoppedWave = true
	QueueNextWave()
	
	-- advance to the next wave so that when it resumes spawning, it iwll be on a harder wave
	WaveManager_FinishWave(wmdt_elsenborn_main)
	
	Event_Timer(Artillery_Ready, nil, (g_artilleryTimerMod+g_artilleryCooldownTimer))
	
	g_artilleryTimerMod = g_artilleryTimerMod + 20
end

function Artillery_Ready()
	if g_artillery_removed == false then
		Util_StartIntel(EVENTS.ArtilleryRecharged)
		flashID_ability = UI_FlashAbilityButton(BP_GetAbilityBlueprint("pm_trigger_artillery"), true)
		Rule_AddOneShot(StopFlashingArtilleryButton, 10)
		g_artillery_ready = true
	end
end


-- Fires the artillery barrage AFTER the player has clicked the button
-- called by AE_Trigger_Elsen_Artillery
function Fire_Artillery_Delayed()
	local currWave = WaveManager_GetWave(wmdt_elsenborn_main)
	local barrageTime = t_difficulty.barrageTime[currWave]
	g_artillery_ready = false
	
	Objective_Show(SOBJ_ArtilleryBarrageDuration, true)
	if barrageTime == nil then return end
	Objective_StartTimer(SOBJ_ArtilleryBarrageDuration, COUNT_DOWN, barrageTime+g_bufferTime, 60)
	
	-- fire artillery
	print("*** Firing artillery for "..barrageTime)
	Start_Artillery_Barrage()
	
	-- stop firing artillery and unpause wave spawning after a delay
	Event_Timer(Stop_Artillery_Barrage, nil, barrageTime)
	if Rule_Exists(UnpauseWave) == true then
		Rule_Remove(UnpauseWave)
	end
 	Rule_AddOneShot(UnpauseWave, barrageTime + g_bufferTime)
	
	if Rule_Exists(ArtilleryReminder) == true then
		Rule_Remove(ArtilleryReminder)
	end
	
	-- retreat enemies after a delay
	Rule_AddOneShot(RetreatEnemies, 20)
end

function AdvanceWave()
	if WaveManager_GetWave(wmdt_elsenborn_main) < WaveManager_GetTotalWaves(wmdt_elsenborn_main) then
		WaveManager_NextWave(wmdt_elsenborn_main)
		WaveManager_SelectSpawns(wmdt_elsenborn_main)
		WaveManager_SpawnWave(wmdt_elsenborn_main)
	end
end

-- retreats all enemies
function RetreatEnemies()

	SGroup_Clear(sg_temp)
	local sg = WaveManager_GetCommandSGroup(wmdt_elsenborn_main)

	-- retreat all enemies
	local _filterRetreat = function(gid, idx, sid)
		if SGroup_IsCapturing(gid, ALL) == false then
			SGroup_Add(sg_temp, sid)
		end
	end

	SGroup_ForEach(sg, _filterRetreat)
	Cmd_StaggeredRetreat(sg_temp, Marker_GetTable("mkr_e_retreat_%02d"), 3, true)
	Cmd_StaggeredRetreat(sg_final_tank_01, Marker_GetTable("mkr_e_retreat_%02d"), 3, true)
	Cmd_StaggeredRetreat(sg_final_tank_02, Marker_GetTable("mkr_e_retreat_%02d"), 3, true)
end


-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
--Called once the intro nis/nislet/sitrep finishes playing.
function Mission_Start()
	FOW_RevealAll()
	Rule_AddOneShot(__UnRevealAll, 0.5)
	
	-- add hintpoints to fighting positions
	t_hints = {
		{
			id = HintPoint_Add(eg_fighting_position_01, true, 11078115, 1.0), -- LOCDB [11078115] 'Upgrade with a Machine Gun'
			egroup = eg_fighting_position_01,
		},
		{
			id = HintPoint_Add(eg_fighting_position_02, true, 11078115, 1.0),  -- LOCDB [11078115] 'Upgrade with a Machine Gun'
			egroup = eg_fighting_position_02,
		},
		{
			id = HintPoint_Add(eg_fighting_position_03, true, 11078115, 1.0),  -- LOCDB [11078115] 'Upgrade with a Machine Gun'
			egroup = eg_fighting_position_03,
		},
		{
			id = HintPoint_Add(eg_fighting_position_04, true, 11078115, 1.0),  -- LOCDB [11078115] 'Upgrade with a Machine Gun'
			egroup = eg_fighting_position_04,
		},
	}
	
	-- Start Objectives
	Objective_Start(OBJ_HoldTheLine)
	Objective_Start(SOBJ_DefendVictoryPoints, false)
	Objective_Start(SOBJ_ArtilleryBarrageDuration, false)
	
	Event_ObjectiveStarted(Artillery_Barrage_Delay_Start, nil, SOBJ_ArtilleryBarrageDuration, 0)

	
	-- Start Music
--~ 	Sound_PlayMusic("streamed/music/missions/m02/m02_cue_start_defend_front_line", 0, 0)
	
	Event_Timer(Mission_Toggle_Lights, {toggleOn = true}, 6*60)
	Event_Timer(Mission_Toggle_Lights, {toggleOn = false}, 14*60)
	
	Event_Timer(Mission_StartSecondary_Objective, nil, t_difficulty.secObjStart)

	-- Start Secure the Flank
	Event_Timer(EventHandler_ObjectiveStart, {objective = OBJ_CaptureTheCheckpoint}, 285)
	
	g_missionTime = 0
	for i = 1, table.getn(t_waveLengths) do
		g_missionTime = g_missionTime + t_waveLengths[i]
	end
	for i = 1, table.getn(t_barrageTimes) do
		g_missionTime = g_missionTime + t_barrageTimes[i]
	end
	g_missionTime = g_missionTime + (g_bufferTime*5)
	g_missionTime = g_missionTime + g_initialBarrage
	
	-- Temp fix
	g_missionTime = g_missionTime + 30
	
	-- Start the mission timer
	Timer_Start(tmr_objHoldTheLine_clock, g_missionTime)
	
	Event_Timer(Mission_RemoveArtillery, nil, g_missionTime - 3*60)
	Event_Timer(SpawnFinalTanks, nil, g_missionTime - 1.5*60)
	Event_Timer(Mission_SkiesClearing, nil, g_missionTime - 2*60)
	Event_Timer(EventHandler_StartIntel, {intel = EVENTS.HoldTheLine_OneMinute}, g_missionTime - 1*60)
	Event_Timer(Mission_AirSupport_Arrival, nil, g_missionTime)
	Event_Timer(Mission_AddArtilleryAbility, nil, g_initialBarrage + g_bufferTime + 5)
	
	Rule_AddOneShot(RemoveHints, 50)
	
	-- hints about reinforcing from halftracks and HQs
	Elsenborn_UpdateHintGroups()
	BeginnerHint_AddOpportunity(sg_reinforcehints, HINT_REINFORCE, true)
	BeginnerHint_AddOpportunity(sg_reinforcehints, HINT_RETREAT, true)
	Rule_AddInterval(Elsenborn_UpdateHintGroups, 30)
	
	-- cover hints
	LeftVP_SwitchCoverHintsToFront()
	RightVP_SwitchCoverHintsToFront()
	
	BeginnerHint_AddOpportunity(mkr_secondary_flank1,  HINT_FLANK)
	BeginnerHint_AddOpportunity(mkr_secondary_flank2,  HINT_FLANK)
	
end

function __UnRevealAll()
	FOW_UnRevealAll()
end



function Elsenborn_UpdateHintGroups()
	
	Player_GetAll(player1, sg_reinforcehints)
	SGroup_Filter(sg_reinforcehints, LIST.AEF_INFANTRY, FILTER_KEEP)
	
end



----------------------////////////////////////////////////////////////////
-- Misc Functions

function Mission_AddArtilleryAbility()
	Util_StartIntel(EVENTS.ArtilleryReady)
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("elsenborn_arty_upg"))
	flashID_ability = UI_FlashAbilityButton(BP_GetAbilityBlueprint("pm_trigger_artillery"), true)
	Rule_AddOneShot(StopFlashingArtilleryButton, 10)
	g_artillery_ready = true
end

function Mission_GetTime()
	return World_GetGameTime()
end

function Mission_SkiesClearing()
	-- Skies clearing stuff here
	Util_StartIntel(EVENTS.SkiesClearing)
end


-- ENDING SEQUENCE: air strikes arrive at the end
function Mission_AirSupport_Arrival()	
	if Objective_IsFailed(OBJ_HoldTheLine) == false then
		g_missionComplete = true  -- player should not be able to fail the mission now
		g_playerStoppedWave = true	-- no more waves should spawn
		RocketStrikesOnFinalTanks()
		WaveManager_FinishWave(wmdt_elsenborn_main)
		WaveManager_RemoveWaveManager(wmdt_elsenborn_main)
		Rule_AddOneShot(Mission_AirSupport_Intel, 4)
		Rule_AddOneShot(AdditionalStrafingRuns, 10)
	end
end

-- some extra air strikes after the first few
function AdditionalStrafingRuns()
	Cmd_Ability(player3, BP_GetAbilityBlueprint("pm_airborne_strafe"), mkr_airSupport_01, mkr_airSupport_01_direction, true)	
	Cmd_Ability(player3, BP_GetAbilityBlueprint("pm_airborne_strafe"), mkr_airSupport_02, mkr_airSupport_02_direction, true)
end

function RocketAirstrike(marker)
	local direction = nil
	SGroup_Clear(sg_temp)
	Player_GetAllSquadsNearMarker(player2, sg_temp, marker)
	
	if Marker_GetName(marker) == mkr_airSupport_01 then
		direction = mkr_airSupport_01_direction
	else
		direction = mkr_airSupport_02_direction
	end
	
	for i = 1, SGroup_Count(sg_temp) do
		if Squad_HasVehicle(SGroup_GetSpawnedSquadAt(sg_temp, i)) then
			Cmd_Ability(player3, ABILITY.AEF.P47_ROCKET_ATTACK, marker, marker, true)
			return true
		end
	end

	return false
end


-- rocket strikes on the final tanks
function RocketStrikesOnFinalTanks()
	if SGroup_IsAlive("sg_final_tank_01") then
		if SGroup_ContainsBlueprints(sg_final_tank_01, SBP.GERMAN.BRUMMBAR_SQUAD_MP, ANY) then
			Cmd_Ability(player3, ABILITY.AEF.P47_ROCKET_ATTACK, mkr_final_group_01, mkr_airSupport_01_direction, true)
			Modifier_Remove(g_damage_mod_id1)
			Modify_ReceivedDamage(sg_final_tank_01, 1.75, true)
		
		else
			if RocketAirstrike(mkr_airSupport_01) == true then
				print("rocket strike on mkr_airSupport_01!")
			else
				print("strafing run on mkr_airSupport_01!**")
				Cmd_Ability(player3, BP_GetAbilityBlueprint("pm_airborne_strafe"), mkr_airSupport_01, mkr_airSupport_01_direction, true)	
			end
		end
	end
	
	if SGroup_IsAlive("sg_final_tank_02") then
		if SGroup_ContainsBlueprints(sg_final_tank_02, SBP.GERMAN.BRUMMBAR_SQUAD_MP, ANY) then
			Cmd_Ability(player3, ABILITY.AEF.P47_ROCKET_ATTACK, mkr_final_group_02, mkr_airSupport_02_direction, true)
			Modifier_Remove(g_damage_mod_id2)
			Modify_ReceivedDamage(sg_final_tank_02, 1.75, true)
				
		else
			if RocketAirstrike(mkr_airSupport_02) == true then
				print("rocket strike on mkr_airSupport_02!")
			else
				print("strafing run on mkr_airSupport_02!**")
				Cmd_Ability(player3, BP_GetAbilityBlueprint("pm_airborne_strafe"), mkr_airSupport_02, mkr_airSupport_02_direction, true)	
			end
		end
	end

end


function Mission_AirSupport_Intel()
	-- Air support arrival stuff here
	Util_StartIntel(EVENTS.AirSupportArrives)
	Rule_AddOneShot(Mission_Enemy_Begin_Retreat, 10)
end

function Mission_Enemy_Begin_Retreat()
	local _sg_waveEnemies = WaveManager_GetCommandSGroup(wmdt_elsenborn_main)
	
	Cmd_StaggeredRetreat(_sg_waveEnemies, {mkr_e_retreat_01, mkr_e_retreat_02, mkr_e_retreat_03}, 5, true)
	Cmd_StaggeredRetreat(sg_final_tank_01, {mkr_e_retreat_01, mkr_e_retreat_02, mkr_e_retreat_03}, 5, true)
	Cmd_StaggeredRetreat(sg_final_tank_02, {mkr_e_retreat_01, mkr_e_retreat_02, mkr_e_retreat_03}, 5, true)
	
	Rule_AddOneShot(HoldTheLine_Complete, 4)
end

function Mission_Toggle_Lights(data)
	t_lights = {}
	g_turnOnLights = data.toggleOn
	local _toggleLights = function(gid, id, eid)
		if Entity_IsAlive(eid) then
			table.insert(t_lights, eid)
		end 
	end
	
	if EGroup_IsEmpty(eg_searchLights) == false then
		EGroup_ForEach(eg_searchLights, _toggleLights)
	end
	
	Rule_AddInterval(Mission_Toggle_Lights_Call, 2)
end

function Mission_Toggle_Lights_Call()	
	if table.getn(t_lights) > 0 then
		for i = table.getn(t_lights), 1, -1 do 
			if Entity_IsAlive(t_lights[i]) == false then
				table.remove(t_lights, i)
			end
		end
		
		local index = World_GetRand(1, table.getn(t_lights))
		
		if g_turnOnLights == true then
			Entity_SetAnimatorState(t_lights[index], "light", "on")
		else
			Entity_SetAnimatorState(t_lights[index], "light", "off")
		end
		
		table.remove(t_lights, index)
	else
		Rule_RemoveMe()
		return
	end
	
	newTime =  World_GetRand(1, 3)
	if newTime == 2 then
		newTime = 1.5
	elseif newTime == 3 then
		newTime = 0.5
	end
	
	Rule_ChangeInterval(Mission_Toggle_Lights_Call, newTime)
end

function Mission_SmokeScreen()
	t_cloneSmoke = Table_Copy(t_smokeScreenMkrs)
	
	Rule_AddInterval(_smokeDrop, 1)
	
	if g_smokeDrops == 0 then
		Event_Timer(EventHandler_StartIntel, {intel = EVENTS.SmokeScreen}, 3)
	end
end

function _smokeDrop()
	local size = table.getn(t_cloneSmoke)
	if size == 0 then
		Rule_RemoveMe()
		g_smokeDrops = g_smokeDrops + 1
		
		if g_smokeDrops < 5 then
			Rule_AddOneShot(Mission_SmokeScreen, 8)
		end
		return
	end
	local sizeOverride = 2
	if size == 1 then
		sizeOverride = 1
	end
	for i = 1, sizeOverride do
		local rand = World_GetRand(1, size)
		local target = t_cloneSmoke[rand]
		
		Cmd_Ability(player2, BP_GetAbilityBlueprint("off_map_single_shot_smoke"), target, nil, true)
		
		table.remove(t_cloneSmoke, rand)
	end
	
	Rule_ChangeInterval(_smokeDrop, World_GetRand(1, 2))
end

function Mission_RemoveArtillery()
	Util_StartIntel(EVENTS.ArtilleryGone)
	g_artillery_removed = true
	g_artillery_ready = false
	Player_RemoveUpgrade(player1, BP_GetUpgradeBlueprint("elsenborn_arty_upg"))
--~ 	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("pm_trigger_artillery"), ITEM_REMOVED)
end


-- spawns the final tanks that hang out in front of the player's line
function SpawnFinalTanks()
	ENCOUNTERS.Final_Tank_01()
	ENCOUNTERS.Final_Tank_02()
end


-- removes hints from fighting positions after a delay
-- called by Mission_Start
function RemoveHints()
	
	for index = table.getn(t_hints), 1, -1  do
		HintPoint_Remove(t_hints[index].id)
	end
	
	Rule_AddOneShot(RemoveHints_PartB, 5)
	
end
function RemoveHints_PartB()

	-- now set up beginner hints on the capturable team weapons
	BeginnerHint_TeamWeapons(eg_capturableTeamWeapons)
	Hints_ArtilleryLocations()

end











-------------------------
-- Secondary Objectives

-- Called to start the objective
function Mission_StartSecondary_Objective()
	World_IncreaseInteractionStage()
	
	Mission_StartSecondaryObjective(true, false)
end



----------------------////////////////////////////////////////////////////
-- Delay Functions

function Artillery_Barrage_Delay_Start()
	-- Start Artillery Barrage
	local initialBarrageTime = g_initialBarrage
	
	Start_Artillery_Barrage()
	Event_Timer(Stop_Artillery_Barrage, nil, initialBarrageTime)
	Objective_StartTimer(SOBJ_ArtilleryBarrageDuration, COUNT_DOWN, (initialBarrageTime+g_bufferTime), 60)
	
	local oneMin = initialBarrageTime-60+g_bufferTime
	local twentySecs = initialBarrageTime-20+g_bufferTime
	Event_Timer(EventHandler_StartIntel, {intel = EVENTS.Barrage_OneMinute}, oneMin)
	Event_Timer(EventHandler_StartIntel, {intel = EVENTS.Barrage_TwentySeconds}, twentySecs)
	
	-- Start Attack Wave Timer
	Event_Timer(Start_Attack_Wave, nil, (initialBarrageTime+g_bufferTime))
	
end


----------------------////////////////////////////////////////////////////
-- Artillery Barrage

-- Begins the 240mm Artillery Barrage
function Start_Artillery_Barrage()
	print("Starting Barrage")
	t_artilleryBarrage = {
		Event_Timer(Artillery_Barrage, {dropPos = mkr_arty_01, eventID = 1}, {4, 6}),
		Event_Timer(Artillery_Barrage, {dropPos = mkr_arty_01, eventID = 2}, {2, 3}),
		Event_Timer(Artillery_Barrage, {dropPos = mkr_arty_02, eventID = 3}, {4, 6}),
		Event_Timer(Artillery_Barrage, {dropPos = mkr_arty_02, eventID = 4}, {2, 3}),
		Event_Timer(Artillery_Barrage, {dropPos = mkr_arty_03, eventID = 5}, {4, 6}),
		Event_Timer(Artillery_Barrage, {dropPos = mkr_arty_03, eventID = 6}, {2, 3}),
		Event_Timer(Artillery_Barrage, {dropPos = mkr_arty_04, eventID = 7}, {4, 6}),
		Event_Timer(Artillery_Barrage, {dropPos = mkr_arty_04, eventID = 8}, {2, 3}),
	}
end

-- The event used for the artillery barrage
function Artillery_Barrage(data)

	local target = Util_GetRandomPosition(data.dropPos)
	SGroup_Clear(sg_temp)
	Player_GetAllSquadsNearMarker(player2, sg_temp, mkr_front_line)
	
	-- fire a barrage at a random squad if the enemy is at the front line (50% chance)
	if SGroup_IsEmpty(sg_temp) == false and World_GetRand(1, 2) == 1 then
		target = Squad_GetPosition(SGroup_GetRandomSpawnedSquad(sg_temp))
	end
	
	Cmd_Ability(player3, BP_GetAbilityBlueprint("sp_240mm_off_map_barrage"), target, nil, true)
	t_artilleryBarrage[data.eventID] = Event_Timer(Artillery_Barrage, {dropPos = data.dropPos, eventID = data.eventID}, {4, 6})

end

-- Stops the 240mm Artillery Barrage
function Stop_Artillery_Barrage()
	print("** Stopping Artillery Now ***")
	for k,v in pairs(t_artilleryBarrage) do
		Event_Remove(v)
	end
	
end

-- Brings up the objective for next artillery barrage
function Display_Next_Arty_Objective()
	local currWave = WaveManager_GetWave(wmdt_elsenborn_main)
	local totWaves = WaveManager_GetTotalWaves(wmdt_elsenborn_main)
	
	if Objective_IsStarted(SOBJ_NextArtilleryBarrage) == false then
		Objective_Start(SOBJ_NextArtilleryBarrage, false)
	else
		if currWave ~= totWaves then
			Objective_Show(SOBJ_NextArtilleryBarrage, true)
		end
	end
end


-- plays a reminder for the player to use artillery if the enemy gets too close
-- first called by Start_Attack_Wave
function ArtilleryReminder()
	SGroup_Clear(sg_temp)
	Player_GetAll(player2, sg_temp)
	print("waiting to alert player")
	-- play speech reminding player of artillery button when there are enough enemies nearby
	if g_artillery_ready == true and g_artillery_removed == false and ( SGroup_Count(sg_temp) >= 5 or EGroup_IsCapturedByPlayer(eg_left_vp, player1, ALL) == false or EGroup_IsCapturedByPlayer(eg_right_vp, player1, ALL) == false ) then
		Util_StartIntel(EVENTS.ArtilleryAvailableReminder)
		flashID_ability = UI_FlashAbilityButton(BP_GetAbilityBlueprint("pm_trigger_artillery"), true)
		Rule_RemoveMe()
		Rule_AddDelayedInterval(ArtilleryReminder, 4*60, 3)
	
	elseif g_artillery_removed == true then
		if flashID_ability ~=nil then
			UI_StopFlashing(flashID_ability)
		end
		
		Rule_RemoveMe()
	end
end


function StopFlashingArtilleryButton()
	if flashID_ability ~=nil then
		UI_StopFlashing(flashID_ability)
	end
end

----------------------////////////////////////////////////////////////////
-- Attack Waves

-- starts the very first attack wave (ONLY the first)
function Start_Attack_Wave()
	local completionData = WaveManager_GetCompletionData(wmdt_elsenborn_main)
	local callbackData = WM_GetCallbackData(wmdt_elsenborn_main)
	local currWave = WaveManager_GetWave(wmdt_elsenborn_main)
	local totWaves = WaveManager_GetTotalWaves(wmdt_elsenborn_main)
	local additionalTime = 0
	
	-- Select Spawns and start
	WaveManager_SelectSpawns(wmdt_elsenborn_main)
	WaveManager_SpawnWave(wmdt_elsenborn_main)
	
	-- Show/hide Objectives
	Objective_Show(SOBJ_ArtilleryBarrageDuration, false)
	
	if scartype(callbackData) == ST_TABLE then
		if scartype(callbackData.preSpawn_delay) == ST_NUMBER and callbackData.preSpawn_delay > 0 then
			additionalTime = callbackData.preSpawn_delay
		end
	end
	
	
	if scartype(callbackData.preSpawn_delay) == ST_NUMBER then
		additionalTime = callbackData.preSpawn_delay
	end
	
	Objective_StopTimer(SOBJ_ArtilleryBarrageDuration)
	
	-- remind player of artillery button
	Rule_AddDelayedInterval(ArtilleryReminder, 5*60, 3)
end




------------------------------------------------------------------------------------------------------------------------------------------
-- Pause Wave Functions
------------------------------------------------------------------------------------------------------------------------------------------


-- Queues up the next wave
function QueueNextWave()
	if Rule_Exists(Start_Next_Wave) == false then
		Rule_Add(Start_Next_Wave)	
	end
end

-- Resets the wave, called as a delayed one shot by 
function UnpauseWave()
	g_playerStoppedWave = false
	-- Show/hide Objectives
	Objective_Show(SOBJ_ArtilleryBarrageDuration, false)
	Objective_StopTimer(SOBJ_ArtilleryBarrageDuration)
	
	-- remind player of artillery button
	if Rule_Exists(ArtilleryReminder) == false then
		Rule_AddDelayedInterval(ArtilleryReminder, 4*60, 3)
	end
end



-- spawns the next wave when g_playerStoppedWave is true
function Start_Next_Wave()	
	
	if g_playerStoppedWave == false then
		local currWave = WaveManager_GetWave(wmdt_elsenborn_main)
		local totWaves = WaveManager_GetTotalWaves(wmdt_elsenborn_main)
		
		Metrics_CheckPoint("End of wave "..currWave)
		
		if currWave < totWaves then
		
			WaveManager_NextWave(wmdt_elsenborn_main)
			WaveManager_SelectSpawns(wmdt_elsenborn_main)
			print("***************** SPAWNING NEXT WAVE ********************")
			WaveManager_SpawnWave(wmdt_elsenborn_main)

			
		else
		
			print("Repeating Final Wave")
			WaveManager_SelectSpawns(wmdt_elsenborn_main)
			print("***************** SPAWNING NEXT WAVE ********************")
			WaveManager_SpawnWave(wmdt_elsenborn_main)
		end
	
		Rule_RemoveMe()
	end
end


-- Set up attack wave data

function Setup_Attack_Data()
	
	local wmdt_elsenborn = function()
		local waveManagerData = {
			waves = {
				ENCOUNTERS.Wave01(),
				ENCOUNTERS.Wave02(),
				ENCOUNTERS.Wave03(),
				ENCOUNTERS.Wave04(),
				ENCOUNTERS.Wave05(),
			},
			
			attackDirs = {
				{						-- spawn = The spawn point, dynSpawn = Dynamic spawn target, ui = location for hintpoints, target = target for goal
					{spawn = mkr_spawn_01, dynSpawn = mkr_spawn_01_dynSpawn, ui = mkr_attack_ui_spawn_01, target = mkr_right_VP, rallyPoint = mkr_spawn_01_dynSpawn},
				},
				{						-- spawn = The spawn point, dynSpawn = Dynamic spawn target, ui = location for hintpoints, target = target for goal
					{spawn = mkr_spawn_02, dynSpawn = mkr_spawn_02_dynSpawn, ui = mkr_attack_ui_spawn_02, target = mkr_right_VP, rallyPoint = mkr_spawn_02_dynSpawn},
				},
				{						-- spawn = The spawn point, dynSpawn = Dynamic spawn target, ui = location for hintpoints, target = target for goal
					{spawn = mkr_spawn_03, dynSpawn = mkr_spawn_03_dynSpawn, ui = mkr_attack_ui_spawn_03, target = mkr_left_VP, rallyPoint = mkr_spawn_03_dynSpawn},
				},
				{						-- spawn = The spawn point, dynSpawn = Dynamic spawn target, ui = location for hintpoints, target = target for goal
					{spawn = mkr_spawn_04, dynSpawn = mkr_spawn_04_dynSpawn, ui = mkr_attack_ui_spawn_04, target = mkr_left_VP, rallyPoint = mkr_spawn_04_dynSpawn},
				},
			},
			
			retreatDirs = {mkr_e_retreat_01, mkr_e_retreat_02, mkr_e_retreat_03},
			
			waveCompleteConditionData = {
				condition = CONDITION_TIMER_ENDED,
				variable = 4*60,
				wave_retreats = false,
				vehicles = 0,
			},
			
			groups = {
				commandGroup = SGroup_CreateIfNotFound("sg_e_wave_all"),
				vehicleGroup = SGroup_CreateIfNotFound("sg_vehicleSGroup"),
			},
			
			defaultGoalData = {
				name = "Attack",
				target = nil,
				range = 5,
				leashRange = 25,
				attackMove = true,
				movePathLengthFactor = 1,
				safeMoveWeight = 0,
				tacticControlsList = {
					{tacticType = TACTIC_CaptureTeamWeapon, priority = -1},
					{tacticType = TACTIC_Recrew, priority = -1},
				},
			},
			
			callbackData = {
				onComplete = QueueNextWave,
			},
		}
		
		return waveManagerData
	end
	
	wmdt_elsenborn_main = WaveManager_SetupNewManagerTable(wmdt_elsenborn, false)
	
end

