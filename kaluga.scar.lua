-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Act 1 - Mission 4
-- Kaluga
-- Designer: Mitch Lagran
-------------------------------------------------------------------------
-------------------------------------------------------------------------
import("ScarUtil.scar")
import("Beginner.scar")
import("Prototype/DeploymentPoints.scar")
import("Systems/AiManager/ai.scar")
import("Events.scar")
import("CampaignSetup.scar")
import("Global_Values/CampaignGlobalConstants.scar")

local obj1_sc1 = false
local obj1_sc3 = false
local obj2_sc1 = false
local obj2_sc2 = false
local obj2_sc3 = false

g_isWinterMap = true

-------------------------------------------------------------------------
-- [[ MISSION SETUP ]]
-------------------------------------------------------------------------
function OnGameSetup()
	-- Required Players
	player1 = Setup_Player(1, 11039128, "soviet", 1) -- LOCDB [11039128] '50th Army'
	player2 = Setup_Player(2,  11039129, "german", 2) -- LOCDB [11039129] '2nd Panzer Army'
	
	-- Optional Players
	player3 = Setup_Player(3, 11039128, "soviet", 1)		-- player3 is always the AI ally
	player4 = Setup_Player(4, 11039128, "soviet", TEAM_NEUTRAL)	
end

function OnGameRestore()	
	-- function takes care of restoring all global mission parameters after a save/load
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
    player3 = World_GetPlayerAt(3)
	player4 = World_GetPlayerAt(4)	
	Game_DefaultGameRestore()
end
   
function Mission_Setup()
	musicStart = "streamed/music/missions/m04/m04_cue_start_blizzard.bsc"
	musicFirstOutpost = "streamed/music/missions/m04/m04_cue_begin_first_outpost.bsc"
	musicCounterAttack = "streamed/music/missions/m04/m04_cue_g_counterattack.bsc"
		
	Sound_PreCacheSinglePlayerSpeech("mission/m04")  
	g_MissionSpeechPath = "mission/m04"
	
	sg_mergehints = SGroup_CreateIfNotFound("sg_mergehints")
	sg_reinforcehints = SGroup_CreateIfNotFound("sg_reinforcehints")
	eg_reinforcehints = EGroup_CreateIfNotFound("eg_reinforcehints")
	
	Player_SetConstructionMenuAvailability(player1, "tp_construction_soviet_engineer", ITEM_REMOVED)
	Player_SetConstructionMenuAvailability(player1, "tp_construction_soviet_conscripts", ITEM_LOCKED)
	
	World_EnableSharedLineOfSight(player1, player3, true)	
	Ghost_DisableSpotting()
--~ 	UI_TerritoryHide()

	sg_intro = SGroup_CreateIfNotFound("sg_intro")
	sg_introC = SGroup_CreateIfNotFound("sg_introC")	
	sg_player = SGroup_CreateIfNotFound("sg_player")
		
	Player_SetUpgradeAvailability(player1, UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE, ITEM_REMOVED)
	
	EGroup_InstantCaptureStrategicPoint(eg_betaPoint, player2)
	EGroup_InstantCaptureStrategicPoint(eg_gammaPoint, player2)
		
	Player_SetResource(player1, RT_Munition, 0)
	munitionsModifier = Modify_PlayerResourceRate(player1, RT_Munition, 0, MUT_Multiplication) 	
	
	Player_SetResource(player1, RT_Fuel, 60)
	Modify_PlayerResourceCap(player1, RT_Munition, 131, MUT_Addition)
	

	
	if campaignDifficulty == GD_EASY then	
		Modify_PlayerResourceCap(player1, RT_Manpower, 301, MUT_Addition)
	elseif campaignDifficulty == GD_NORMAL then
		Modify_PlayerResourceCap(player1, RT_Manpower, 201, MUT_Addition)	
	else
		Modify_PlayerResourceCap(player1, RT_Manpower, 121, MUT_Addition)		
	end
--~ 	Modify_PlayerResourceCap(player1, RT_Manpower, 400, MUT_Addition)
	Modify_PlayerResourceRate(player1, RT_Manpower, 0.33, MUT_Multiplication) 	
	Player_SetResource(player1, RT_Command, 1)
	UI_SetSoviet227Visibility(true)
	Modify_PlayerResourceCap(player1, RT_SovietProgression, -50, MUT_Addition)
	
	Player_SetPopCapOverride(player1, 54)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.SNIPER_SUPPRESSION_FIRE_ABILITY, ITEM_UNLOCKED)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.CONSCRIPT_OORAH, ITEM_UNLOCKED)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.MERGE_ABILITY, ITEM_LOCKED)
	SGroup_SetAvgHealth(sg_frozenHalftrack, 0.65)
	Modify_TargetPriority(eg_alphaMunitions, -100)
	
	Player_SetHeatLossRate(player1, 0)
	Player_SetHeatGainRate(player1, 0)
	Player_SetHeatLossRate(player2, 0)
	Player_SetHeatGainRate(player2, 0)
	
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.SNIPER_FIRE_FLARES_ABILITY, ITEM_UNLOCKED)
	Player_SetUpgradeAvailability(player1, BP_GetUpgradeBlueprint("upgrade/campaign/disable_abandon_critical"), ITEM_UNLOCKED)
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("upgrade/campaign/disable_abandon_critical"))
	Player_SetCommandAvailability(player1, SCMD_Retreat, ITEM_LOCKED)
	
	Player_SetUpgradeAvailability(player2, BP_GetUpgradeBlueprint("upgrade/campaign/disable_abandon_critical"), ITEM_UNLOCKED)
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("upgrade/campaign/disable_abandon_critical"))
	Player_SetAbilityAvailability(player2, ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN, ITEM_UNLOCKED)
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("panzerfaust_slow"))
	Player_SetAbilityAvailability(player2, ABILITY.GERMAN.MG42_PHOSPHORUS_ROUNDS, ITEM_REMOVED)
	
	
    Player_SetResource(player2, RT_Munition, 1500)

	Modify_ReceivedDamage(eg_introStug, 5)
	Modify_ReceivedDamage(eg_alphaTanks, 5)
	Modify_ReceivedDamage(eg_betaTanks, 5)
	
	Modify_PlayerSightRadius(player1, 0.8)	
	Modify_PlayerSightRadius(player2, 0.8)
	
	Modify_DisableHold(eg_ungarrisonable, true) 
	
	SGroup_SetRecrewable(sg_wreckedHalftracks, false)
	SGroup_SetRecrewable(sg_finalTanks, false)
	EGroup_SetRecrewable(eg_wreckedArty, false)
	EGroup_SetSelectable(eg_wreckedArty, false)
	EGroup_EnableUIDecorator(eg_wreckedArty, false)
	
	-- When the abandon crit is applied to the vehicle its reference is lost, so it must be reaquired and put into a new group
	
	local halftrackPosition1 = SGroup_GetPosition(sg_frozenHalftrack)	
	local halftrackPosition2 = SGroup_GetPosition(sg_frozenHalftrack_2)	
	local halftrackPosition3 = SGroup_GetPosition(sg_frozenHalftrack_3)	
	
	Cmd_CriticalHit(player2, sg_crewableHalftracks, CRIT.VEHICLE_ABANDON, 0)
	
	eg_frozenHalftrack = EGroup_CreateIfNotFound("eg_frozenHalftrack")
	World_GetNeutralEntitiesNearPoint(eg_frozenHalftrack, halftrackPosition1, 10)
	EGroup_Filter(eg_frozenHalftrack, EBP.GERMAN.HALFTRACK_SDKFZ_251, FILTER_KEEP)	
	
	eg_frozenHalftrack02 = EGroup_CreateIfNotFound("eg_frozenHalftrack02")
	World_GetNeutralEntitiesNearPoint(eg_frozenHalftrack02, halftrackPosition2, 10)
	EGroup_Filter(eg_frozenHalftrack02, EBP.GERMAN.HALFTRACK_SDKFZ_251, FILTER_KEEP)
	
	eg_frozenHalftrack03 = EGroup_CreateIfNotFound("eg_frozenHalftrack03")
	World_GetNeutralEntitiesNearPoint(eg_frozenHalftrack03, halftrackPosition3, 10)
	EGroup_Filter(eg_frozenHalftrack03, EBP.GERMAN.HALFTRACK_SDKFZ_251, FILTER_KEEP)

	SetupMainObjective()
	FindHeat_Setup()
	Rendevous_Setup()
	FirstOutpost_Setup()
	FuelDepot_Setup()
	Initialize_SecObjective()
	FinalDepot_Setup()
	Util_StartNIS(EVENTS.OpeningCinematic)	
	Util_CreateSquads(player1, sg_intro, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_playerSpawn, nil, 1)
	Util_CreateSquads(player1, sg_introC, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_playerSpawn2, nil, 1, 3)	
	Camera_SetZoomDist(20)
end

function SetupMainObjective()
	OBJ_ObjectiveParent = {		
		OnStart = function()
			Event_NarrativeEventsNotRunning(EventHandler_ObjectiveStart, {objective = OBJ_SniperObjective}, 4)
		end,
		Intel_Start = EVENTS.IntroSitrep,
		Intel_Complete = nil,
		Intel_Fail = nil,
		Title = 11035494, -- LOCDB [11035494] 'Retake the region from the Germans'
		Description = 11035495, -- LOCDB [11035495] 'The Germans have fallen back to key positions in this region. Take out each position using the limited forces available.'
		TitleEnd = 11035494, -- LOCDB [11035496] 'German forces have been destroyed.'
		TitleFail = 1459052,	
		Type = OT_Primary,		
	}	
	Objective_Register(OBJ_ObjectiveParent)
end

-------------------------------------------------------------------------
-- MISSION START
-------------------------------------------------------------------------
function Mission_Start()			
	FirstOutpost_SpawnEncounter()
	FindHeat_StartNIS()
	
	Util_PlayMusic(musicStart, 0, 0)
	
	UI_SetCPMeterVisibility(false) 
	evt_missionFail = Event_PlayerSquadCount(Kaluga_CheckMissionFail, nil, player1, 0, 1)
	
	-- hints about merging into damaged squads and reinforcing from halftracks and HQs
	Kaluga_UpdateHintGroups()
	BeginnerHint_AddOpportunity(sg_mergehints, HINT_MERGE, true)
	BeginnerHint_AddOpportunity(eg_pickuphints, HINT_PICKUP, true)	
	Rule_AddInterval(Kaluga_UpdateHintGroups, 30)	
	
	--Ensure a mortar is available at near the last depot
	sg_mortarTest = SGroup_CreateIfNotFound("sg_mortarTest")
	Util_CreateSquads(player2, sg_mortarTest, SBP.GERMAN.MORTAR_TEAM_81MM, mkr_mortar03)	
	Cmd_InstantSetupTeamWeapon(sg_mortarTest)
	Event_Timer(AbandonMortar, nil, 1)
end

function AbandonMortar()	
	Cmd_AbandonTeamWeapon(sg_mortarTest)
end

function Kaluga_CheckMissionFail()
	Mission_EndMission(false)
end	

function Defend_LostTerritory()
--~ 	Util_MissionTitle(11048793, 1, 5, 1) -- LOCDB [11048793] 'Mission Failed: Headquarters Destroyed'
	Camera_MoveTo(Util_GetPosition(mkr_finalCapZone_01), true, 0.25)
	Game_SetMode(UI_Cinematic)
	FOW_RevealArea(Marker_GetPosition(mkr_finalCapZone_01), 20, -1)
	Event_Timer(Kaluga_CheckMissionFail, nil, 4)
end

function Kaluga_UpdateHintGroups()
	
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

-------------------------------------------------------------------------
-- Objective 1: Find Heat Objective 
-------------------------------------------------------------------------
function FindHeat_Setup()
	OBJ_FindHeatObjective = {		
		Intel_Start = nil,
		Intel_Complete = EVENTS.FoundFireSpeech,
		Intel_Fail = nil,
		Title = 11035497, -- LOCDB [11035497] 'Get your troops to a heat source'
		Description = 11035517, -- LOCDB [11035517] 'Your troops are freezing, find a nearby heat source to warm your troops'
		TitleEnd = 11035497, -- LOCDB [11035498] 'Found warmth'
		TitleFail = 11035518, -- LOCDB [11035518] 'Your troops have succumbed to the cold'
		Type = OT_Primary,
	}	
	Objective_Register(OBJ_FindHeatObjective)
end

function FindHeat_StartNIS()
	Util_SetNISMode()
	local location = 11048260			-- LOCDB [11048260] 'Outskirts of Moscow, USSR'
	local timeline = 11048261			-- LOCDB [11048261] 'January, 1941'
	Game_SubTextFade(location, timeline, 0.5, 4, 0.5)
	Event_Timer(FindFire_NIS2, nil, 5.0)
	Camera_FollowSquad(SGroup_GetSpawnedSquadAt(sg_intro, 1))
	Cmd_Move(sg_intro, mkr_playerSpawnMoveTo2)
	Cmd_Move(sg_introC, mkr_playerSpawnMoveTo)
end

function FindFire_NIS2()
	Util_StartIntel(EVENTS.FindFireSpeech)
	Event_NarrativeEventsNotRunning(FindHeat_Start, nil, 1)
end

function FindHeat_Start()
	Util_SetNISMode(false)
	
	Objective_Start(OBJ_FindHeatObjective) 
	-- Has player reached the 2nd fire? Send German tank crew	
	evt_startCold = Event_Proximity(FindHeat_StartCold, nil, {sg_introC, sg_intro}, mkr_startCold, nil, ANY)	
	evt_startFire = Event_PlayerCanSeeElement(FindHeat_NearFirstFireHint, nil, player1, mkr_canSeeFirstFire, ANY, 0.5)
	evt_findHeatComplete = Event_Proximity(FindHeat_Complete, nil, sg_intro, mkr_introFire, nil, ANY,3)
	evt_tracksInSnow = Event_Proximity(EventHandler_StartIntel, {intel_callback = EVENTS.TracksInSnow}, sg_intro, mkr_germanTracks)
	
	Camera_SetZoomDist(50)
	squadFreezeTime = 6
	evt_squadMemberFreezes = Event_Timer(FindHeat_SquadMemberFreezes, nil, squadFreezeTime)
	SGroup_SetInvulnerable(sg_introC, true)
	
	Player_SetDefaultSquadMoodMode(player1, MM_ForceTense)
		
	function _skip()		
		
		EGroup_InstantCaptureStrategicPoint(eg_gammaPoint, player1)
		Defend_Start()
		SGroup_Kill(Player_GetSquads(player2))
		Util_CreateSquads(player1, "players1", SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_mortar01)
		Util_CreateSquads(player1, "players1", SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_mortar02)
	end
end

function FindHeat_SquadMemberFreezes()
	
	if SGroup_TotalMembersCount(sg_introC) > 1 then
		CRIT.SOLDIER_FROZEN = BP_GetCriticalBlueprint("soldier_frozen")
		local entity = Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_introC, 1), 0)
		Entity_SetInvulnerable(entity, false, -1)
		Entity_ApplyCritical(entity, CRIT.SOLDIER_FROZEN, 1.1)
		if SGroup_TotalMembersCount(sg_introC) == 1 then
			evt_squadMemberFreezes = Event_Proximity(FindHeat_SquadMemberFreezes, nil, player1, mkr_lastSquadFreezes, nil, ANY)		
			evt_squadMemberFreezes2 = Event_Timer(FindHeat_SquadMemberFreezes, nil, squadFreezeTime*2) 	
		else
			evt_squadMemberFreezes = Event_Timer(FindHeat_SquadMemberFreezes, nil, squadFreezeTime) 		
		end 
	else 	
		local entity = Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_introC, 1), 0)
		Entity_SetInvulnerable(entity, true, -1)
		Event_Remove(evt_squadMemberFreezes)
		Event_Remove(evt_squadMemberFreezes2)
		Util_StartIntel(EVENTS.ConscriptFreezing)
		
		Entity_SetAnimatorEvent(Squad_EntityAt( SGroup_GetSpawnedSquadAt(sg_introC, 1), 0 ) ,"m04_freezing_death")
		
		Util_ApplyModifier(sg_introC, "move_enable_modifier", -1, MUT_Enable)
		Event_Timer(FindHeat_LastSquadFreezes, nil, 15)
	end
end

function FindHeat_LastSquadFreezes()
	CRIT.SOLDIER_FROZEN = BP_GetCriticalBlueprint("soldier_frozen")
	local entity = Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_introC, 1), 0)
	Entity_SetInvulnerable(entity, false, -1)
	Entity_ApplyCritical(entity, CRIT.SOLDIER_FROZEN, 1.1)
end

function FindHeat_StartCold ()
	if campaignDifficulty == GD_EASY then
		Player_SetHeatLossRate(player1, 0.75)
		Player_SetHeatGainRate(player1, 2)
		Player_SetHeatLossRate(player2, 2)
		Player_SetHeatGainRate(player2, 0.75)
	elseif campaignDifficulty == GD_NORMAL then	
		Player_SetHeatLossRate(player1, 0.9)
		Player_SetHeatGainRate(player1, 2)
		Player_SetHeatLossRate(player2, 1.75)
		Player_SetHeatGainRate(player2, 0.9)
	else
		Player_SetHeatLossRate(player1, 1.05)
		Player_SetHeatGainRate(player1, 1.75)
		Player_SetHeatLossRate(player2, 1.5)
		Player_SetHeatGainRate(player2, 1)	
	end
	
	Util_ApplyModifier(sg_introC, "squad_chill_per_tick_modifier", 100, MUT_Multiplication)
	
	hp_freezingToDeath = HintPoint_Add(sg_introC, true, 11035499, nil, nil, "Icons_tooltips_cold_troops") -- LOCDB [11035499] 'These conscripts are freezing to death'
	Event_Timer(EventHandler_RemoveHint, {hint = hp_freezingToDeath}, 10)
end

function FindHeat_NearFirstFireHint()
	hp_useHeat = HintPoint_Add(Util_GetPosition(mkr_canSeeFirstFire), true, 11035500, 2, nil, "Icons_commands_icon_command_build_fire") -- LOCDB [11035500] 'Use fires to warm your squads'
end

function FindHeat_Complete(showTitle)
	HintPoint_Remove(hp_useHeat)
	Objective_Complete(OBJ_FindHeatObjective, showTitle)
	Rendevous_Start()
end

-------------------------------------------------------------------------
-- Objective 2: Rendevous 
-------------------------------------------------------------------------
function Rendevous_Setup()
	OBJ_SniperObjective = {
		Parent = OBJ_ObjectiveParent,
		OnStart = function()			
			blip_rendevous = Objective_AddUIElements(OBJ_SniperObjective, mkr_sniperFire, true)
		end,
		Intel_Start = nil,	
		Intel_Complete = nil,
		Intel_Fail = nil,
		Title = 11035501, -- LOCDB [11035501] 'Meet with the advance snipers'
		Description = 11035519, -- LOCDB [11035519] 'Rendezvous with the sniper team that was sent ahead to scout the area'
		TitleEnd = 11035501,	 -- LOCDB [11035502] 'Met with advance snipers'
		TitleFail = 11035520, -- LOCDB [11035520] 'Your troops didn't make the rendezvous with the scouts'
		Type = OT_Primary,
	}	
	Objective_Register(OBJ_SniperObjective)
end


function Rendevous_Start()	
	Event_NarrativeEventsNotRunning(EventHandler_ObjectiveStart, {objective = OBJ_ObjectiveParent}, 0.5)
	evt_secondFire = Event_Proximity(EventHandler_StartIntel, {intel = EVENTS.FoundAdvanceCamp}, player1, {mkr_sniperFire_02, mkr_sniperFire}, nil, ANY)
	evt_secondFire = Event_Proximity(Rendevous_StartAmbush, nil, player1, {mkr_sniperFire_02, mkr_sniperFire}, nil, ANY, 2)
	evt_FreezingSquad = Event_Proximity(EventHandler_StartIntel, {intel_callback = EVENTS.FreezingSquad_Warning}, player1, mkr_firstEncCoverUI, nil, ANY)
	evt_FreezingSquad = Event_Proximity(EventHandler_StartIntel, {intel_callback = EVENTS.DeepSnow}, player1, mkr_deepSnow, nil, ANY)
	
	function _skip()
		Event_Remove(evt_secondFire)
		Event_Remove(evt_FreezingSquad)
		Event_Remove(evt_snipersAtk1)
		Event_Remove(evt_snipersAtk2)
		Event_Remove(evt_rendevousComplete)
		Rendevous_CreateSnipers()
		Rendevous_Complete(false)	
	end
end

function Rendevous_StartAmbush()	
	sg_germanAmbush = SGroup_CreateIfNotFound("sg_germanAmbush")
		
	Objective_RemoveUIElements(OBJ_SniperObjective, blip_rendevous)
	Event_PlayerCanSeeElement(EventHandler_StartIntel, {intel = EVENTS.Ambushed}, player1, sg_germanAmbush, ANY, 1)
	local encData = {
		name = "Germans_D1",
		player = player2,
		spawn = mkr_d_stug2,
		sgroups = {sg_germanAmbush},
		units = {
			{
				name = "intr_grenadiers3",
				sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,
				spawn = mkr_d_stug3,
				numSquads = 1,
				
			},
			{
				name = "intr_grenadiers1",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_d_stug,
				numSquads = 1,
			--	load = 3,
			},
			{
				name = "intr_grenadiers2",
				sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,
				spawn = mkr_d_stug2,
			--	numSquads = 1,
				load = 3,
			},
		},
	}
	g_enc_introStug2 = Encounter:Create(encData)
	local goalData = {
		name = "Attack",
		target = mkr_crew_attack,
		range = mkr_crew_attack,
		attackMove = true,
	}
	g_enc_introStug2:SetGoal(goalData)
	
	Modify_WeaponRange(sg_germanAmbush, "hardpoint_01", 0.5)
	
	if SGroup_TotalMembersCount(sg_intro) > 3 then
		evt_snipersAtk1 = Event_GroupLeftAlive(Rendevous_SnipersAttack, nil,sg_intro, SGroup_TotalMembersCount(sg_intro) - 1)	
	else
		evt_snipersAtk1 = Event_Timer(Rendevous_SnipersAttack, nil, 15)
	end
	evt_snipersAtk2 = Event_GroupLeftAlive(Rendevous_SnipersAttack, nil, sg_germanAmbush, 3)
	
	Cmd_Attack(sg_germanAmbush, sg_intro)
	
	evt_rendevousComplete = Event_GroupIsDead(Rendevous_Complete, nil, sg_germanAmbush)
end


function Rendevous_SnipersAttack()		
	Event_Remove(evt_snipersAtk1)
	Event_Remove(evt_snipersAtk2)

	-- Allied snipers	
	Rendevous_CreateSnipers()
	
	Cmd_Move(sg_introsniper1, mkr_sniper1_move)	
	Cmd_Move(sg_introsniper2, mkr_sniper2_move)	
	Cmd_AttackMove(sg_introsniper1, sg_germanAmbush, true)		
	Cmd_AttackMove(sg_introsniper2, sg_germanAmbush, true)		
	
	sniperAccuracyMod = Modify_WeaponAccuracy(sg_introsnipers, "hardpoint_01", 100)
	
	evt_enableIntroInvuln = Event_GroupLeftAlive(Rendevous_SetLastSquadInvulnerable, nil, sg_intro, 1)
	
	Event_Timer(Rendevous_ShowSnipers, nil, 1)	
end

function Rendevous_SetLastSquadInvulnerable()
	SGroup_SetInvulnerable(sg_intro, 0.1)
end

function Rendevous_CreateSnipers()
	sg_introsnipers		= SGroup_CreateIfNotFound("sg_introsnipers")
	sg_introsniper1		= SGroup_CreateIfNotFound("sg_introsniper1")
	sg_introsniper2		= SGroup_CreateIfNotFound("sg_introsniper2")
	
	Util_CreateSquads(player3, {sg_introsnipers, sg_introsniper1}, SBP.SOVIET.SNIPER_TEAM, mkr_sniper1, nil, 1)
	Util_CreateSquads(player3, {sg_introsnipers, sg_introsniper2}, SBP.SOVIET.SNIPER_TEAM, mkr_sniper2, nil, 1)
	
	while SGroup_IsFemale(sg_introsnipers, ALL) == true do
		SGroup_DestroyAllSquads(sg_introsniper1)
		SGroup_Clear(sg_introsniper1)
		Util_CreateSquads(player3, {sg_introsnipers, sg_introsniper1}, SBP.SOVIET.SNIPER_TEAM, mkr_sniper1, nil, 1)
	end
	
	SGroup_SetInvulnerable(sg_introsnipers, true)
	SGroup_AddAbility(sg_introsnipers, ABILITY.SOVIET.SNIPER_SUPPRESSION_FIRE_ABILITY)
	SGroup_IncreaseVeterancyRank(sg_introsnipers, 1, true) 
end

function Rendevous_ShowSnipers()
	Util_StartIntel(EVENTS.SnipersArrive)
	SGroup_SetInvulnerable(sg_intro, true)	
	Camera_ResetToDefault()
	camStartPosition = Camera_GetCurrentTargetPos()
	Camera_MoveTo(mkr_sniper1_move, true, 0.5)
	Event_Timer(Rendevous_ReturnCam, nil, 4)	
end

function Rendevous_ReturnCam()
	Camera_MoveTo(camStartPosition, true, 0.5)
	if Event_Exists(evt_enableIntroInvuln) then
		Event_Remove(evt_enableIntroInvuln)
	end
	SGroup_SetInvulnerable(sg_intro, false)	
end
	
function Rendevous_Complete(showTitle)		
	Objective_Complete(OBJ_SniperObjective, showTitle)
	
	SGroup_SetInvulnerable(sg_intro, false)
	
	Cmd_Move(sg_introsniper1, mkr_sniper1EndPos, false)
	Cmd_Move(sg_introsniper2, mkr_sniper2EndPos, false)
	FirstOutpost_Start()
	Modifier_Remove(sniperAccuracyMod)
	SGroup_SetPlayerOwner(sg_introsnipers, player1)		
	SGroup_SetInvulnerable(sg_introsnipers, false)
	
	Modifier_Remove(munitionsModifier)
	Player_SetResource(player1, RT_Munition, 60)
	munitionsModifier = Modify_PlayerResourceRate(player1, RT_Munition, 1.7, MUT_Multiplication) 	
end

-------------------------------------------------------------------------
-- Objective 1: First outpost
-------------------------------------------------------------------------
function FirstOutpost_Setup()
	OBJ_ScoutOutpost = {
		Parent = OBJ_ObjectiveParent,
		
		OnStart = function() 
			Event_Timer(EventHandler_RemoveHint, {hint = HintPoint_Add(sg_introsniper1, true, 11035505)}, 5) -- LOCDB [11035505] 'Snipers are immune to the effects of cold'
			Event_Timer(EventHandler_RemoveHint, {hint = HintPoint_Add(sg_introsniper2, true, 11035505)}, 5) -- LOCDB [11035505] 'Snipers are immune to the effects of cold'
			
			OBJ1_SB1 = Objective_AddUIElements(OBJ_SniperObjective, mkr_d1_westApp, true)
			OBJ1_SB3 = Objective_AddUIElements(OBJ_SniperObjective, mkr_d1_eastApp, true)
			
			Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 0)
			Util_PlayMusic(musicFirstOutpost, 0, 3)
		end,
		OnComplete = FirstOutpost_Complete,		
		
		Intel_Start = EVENTS.SnipersScout,	
		Intel_Complete = nil,			
		Intel_Fail = nil,	
		Title = 11035503, -- LOCDB [11035503] 'Scout approaches to the German Forward Outpost'
		Description = 11035521, -- LOCDB [11035521] 'Scout the approaches to the German Forward Outpost to aid in planning an attack'
		TitleEnd = 11035492, -- LOCDB [11035504] 'Forward Outpost captured.'
		TitleFail = 11035522, -- LOCDB [11035522] 'Failed to reach the first outpost'
		Type = OT_Primary,			
	}	
	Objective_Register(OBJ_ScoutOutpost)	
end

function FirstOutpost_SpawnEncounter()
	sg_d1_grens			= SGroup_CreateIfNotFound("sg_d1_grens")
	sg_d1_grensEast		= SGroup_CreateIfNotFound("sg_d1_grensEast")
	sg_d1_grensWest		= SGroup_CreateIfNotFound("sg_d1_grensWest")

	-- EAST LINE (lightly defended)
	local encData = {
		player = player2,
		spawn = mkr_alphaGren1,
		sgroups = {sg_d1_grens, sg_d1_grensEast},
		units = {
			{sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,	spawn = mkr_alphaGren1,		load = 3,},
			
			{sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,	spawn = mkr_alphaGren2,		load = 4,	upgrades = {GRENADIER_MG42_LMG},},
			
			{difficulty = GD_EASY,	sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,		spawn = mkr_alphaGren3,		load = 3,	veterancyRank = 0,},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,	spawn = mkr_alphaGren3,		load = 3,	veterancyRank = 1,},
			{difficulty = GD_HARD,	sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,		spawn = mkr_alphaGren3,		load = 3,	veterancyRank = 2,},
			
			{difficulty = GD_EASY,	sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,		spawn = mkr_alphaGren3,		load = 2,	veterancyRank = 0,},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,	spawn = mkr_alphaGren3,		load = 2,	veterancyRank = 2,},
			{difficulty = GD_HARD,	sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,		spawn = mkr_alphaGren3,		load = 2,	veterancyRank = 3,},
		},
	}
	g_enc_d1_East = Encounter:Create(encData)
	local goalData = {
		name = "Defend",
		target = mkr_d1_eastApp_target,
		garrisonIdle = true,
		garrison = true,
	}
	g_enc_d1_East:SetGoal(goalData)
	
	-- WEST LINE (Heavily defended)
	local encData = {
		player = player2,
		spawn = mkr_es_depotWest_01,
		sgroups = {sg_d1_grens, sg_d1_grensWest},
		units = {
			{sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,	spawn = mkr_es_depotWest_02,	load = 1,},
			
			{sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,	spawn = mkr_es_depotWest_01,	load = 3,	upgrades = {GRENADIER_MG42_LMG},},
			
			{difficulty = GD_EASY,	sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,		spawn = mkr_es_depotWest_01,	load = 2,	veterancyRank = 0,},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,	spawn = mkr_es_depotWest_01,	load = 2,	veterancyRank = 2,},
			{difficulty = GD_HARD,	sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,		spawn = mkr_es_depotWest_01,	load = 2,	veterancyRank = 3,},
			
			{difficulty = GD_EASY,	sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,		spawn = mkr_es_depotWest_01,	load = 3,	veterancyRank = 0,},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,	spawn = mkr_es_depotWest_01,	load = 3,	veterancyRank = 1,},
			{difficulty = GD_HARD,	sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,		spawn = mkr_es_depotWest_01,	load = 3,	veterancyRank = 2,},
		},
	}
	g_enc_d1_West = Encounter:Create(encData)
	local goalData = {
		name = "Defend",
		target = mkr_d1_westApp_target,
		range = 50,
		leashRange = 50,
		garrisonIdle = false,
		garrison = false,
	}
	g_enc_d1_West:SetGoal(goalData)	
	
	-- WEST LINE (Heavily defended)
	local encData = {
		player = player2,
		spawn = mkr_es_depotWest_01,
		sgroups = {sg_d1_grens, sg_d1_grensWest},
		units = {	
			{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_alphaHMG_02,},			
		},
	} 
	g_enc_d1_WestHMG = Encounter:Create(encData)
	local goalData = {
		name = "Defend",
		target = mkr_alphaHMG_02,
		range = 50,
		leashRange = mkr_alphaHMG_02,
		coordinatedSetupFacingPositions = {mkr_snipWestFlare},
		garrisonIdle = true,
		garrison = true,
	}
	g_enc_d1_WestHMG:SetGoal(goalData)	
	
	-- WEST LINE (Heavily defended)
	local encData = {
		name = "Germans_D3",
		player = player2,
		spawn = mkr_es_depotWest_01,
		sgroups = {sg_d1_grens, sg_d1_grensWest},
		units = {	
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_alphaHMG,	load = 3,	veterancyRank = 2},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_alphaHMG,	load = 3, 	veterancyRank = 3},
		},
	}
	g_enc_d1_WestHMG2 = Encounter:Create(encData)
	local goalData = {
		name = "Defend",
		target = mkr_alphaHMG,
		range = 50,
		leashRange = mkr_alphaHMG,
		coordinatedSetupFacingPositions = mkr_snipWestFlare,--{mkr_snipWestFlare},

--~ 		garrisonIdle = true,
--~ 		garrison = true,
	}
	g_enc_d1_WestHMG2:SetGoal(goalData)			
end

function FirstOutpost_Start()
	sg_playerEng =  SGroup_CreateIfNotFound("sg_playerEng")	
	sg_westEngineers = SGroup_CreateIfNotFound("sg_westEngineers")
	sg_eastEngineers = SGroup_CreateIfNotFound("sg_eastEngineers")	

	foundFirstTank = false

	Objective_Start(OBJ_ScoutOutpost) 	
		
	Rule_AddInterval(FirstOutpost_UpdateCheck, 1)
	Rule_AddInterval(FirstOutpost_scoutCheck1, 2)
	Rule_AddInterval(FirstOutpost_scoutCheck3, 2)
	
	Event_IsEngaged(FirstOutpost_EndScout, nil, sg_d1_grens, ANY)
	evt_engWest1 = Event_ElementOnScreen(FirstOutpost_FoundEngineersWest, nil, player1, eg_engiGarrisonWest, ANY)
	evt_engEast1 = Event_ElementOnScreen(FirstOutpost_FoundEngineersEast, nil, player1, eg_engiGarrisonEast, ANY)	
	evt_engWest2 = Event_Proximity(FirstOutpost_FoundEngineersWest, nil, player1, mkr_foundWestEngineers, nil, ANY)
	evt_engEast2 = Event_Proximity(FirstOutpost_FoundEngineersEast, nil, player1, mkr_foundEastEngineers, nil, ANY)	
				
	Util_CreateSquads(player4, {sg_playerEng, sg_westEngineers}, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_westEngineers)
	Util_CreateSquads(player4, {sg_playerEng, sg_eastEngineers}, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_eastEngineers)	
	Cmd_Garrison(sg_westEngineers, eg_engiGarrisonWest, nil, false, true)
	Cmd_Garrison(sg_eastEngineers, eg_engiGarrisonEast, nil, false, true)
	
	Event_Proximity(FirstOutpost_AttackCapture, nil, player1, mkr_alphaCapture, nil, ANY)
		
	sniperTutorialDataWest = {
		mkr_cover = mkr_snipWestCover, 
		mkr_flare = mkr_snipWestFlare, 
		mkr_attack = mkr_snipWestAttack, 
		mkr_flareTarget = mkr_snipWestFlareTarget,
		sg_enemyGrp = sg_d1_grensWest,
	}
	sniperTutorialDataEast = {
		mkr_cover = mkr_snipEastCover, 
		mkr_flare = mkr_snipEastFlare, 
		mkr_attack = mkr_snipEastAttack, 
		mkr_flareTarget = mkr_snipEastFlareTarget,
		sg_enemyGrp = sg_d1_grensEast,
	}
	
	evt_flareTut01 = Event_PlayerCanSeeElement(FirstOutpost_FlareTutorial, sniperTutorialDataWest, player1, mkr_snipWestFlare, ANY)
	evt_flareTut02 = Event_PlayerCanSeeElement(FirstOutpost_FlareTutorial, sniperTutorialDataEast, player1, mkr_snipEastFlare, ANY)
	
	Event_Timer(FirstOutpost_FlareTutorialCancelStart, nil, 4)	
	
	Event_Proximity(EventHandler_StartIntel, {intel = EVENTS.Sniper_Holdfire_Lesson}, sg_introsnipers, {mkr_holdFireDialogueEast, mkr_holdFireDialogueWest}, nil, ANY)

	sg_germanSquads = SGroup_CreateIfNotFound("sg_germanSquads")
	Player_GetAll(player2, sg_germanSquads)
	
	evt_failedSnipers = Event_IsUnderAttack(FailedSnipersOnlyAchievements, nil, sg_germanSquads, ANY, 0.5)
	
	function _skip ()
		FirstOutpost_EndScout()
	end
end

function FirstOutpost_AttackCapture()
	if SGroup_Count(sg_d1_grens) > 0 then
		g_enc_d1_East:Disable()
		g_enc_d1_West:Disable()
		g_enc_d1_WestHMG:Disable()
		g_enc_d1_WestHMG2:Disable()
		
		local enc = Encounter:ConvertSgroup(sg_d1_grens)
		local goalData = {
			name = "Defend",
			target = mkr_alphaCapture,
			range = mkr_alphaCapture,
			leashRange = 50,
		}
		enc:SetGoal(goalData)	
	end
end

function FailedSnipersOnlyAchievements(data)	
	local _check = function(thing, thang, squad)
		if Squad_GetPlayerOwner(squad) == player1 and Squad_GetBlueprint(squad) ~= SBP.SOVIET.SNIPER_TEAM then		
			print("::: FailedSnipersOnlyAchievements :::")
			failedSniperAchievement = true
		end
	end
	SGroup_ForEach(data.attacker, _check)
	
	if failedSniperAchievement ~= true then
		evt_failedSnipers = Event_IsUnderAttack(FailedSnipersOnlyAchievements, nil, sg_germanSquads, ANY, 0.5)	
	end
end


function FirstOutpost_FlareTutorialCancelStart()
	evt_flareTutCancel = Event_IsDoingAttack(FirstOutpost_FlareTutorialCancel, nil, sg_introsnipers, ANY, 1)
end

function FirstOutpost_FlareTutorialCancel()
	Event_Remove(evt_flareTut01)
	Event_Remove(evt_flareTut02)		
	HintPoint_Remove(hp_sniperTut)
end

function FirstOutpost_FlareTutorial(data)
	Event_Remove(evt_flareTut01)
	Event_Remove(evt_flareTut02)	

	hp_sniperTut = HintPoint_Add(data.mkr_flare, true, 11047712, nil, nil, "Icons_abilities_ability_common_camouflage_on") -- LOCDB [11047712] 'Move the snipers into cover to camouflage them'
	Util_StartIntel(EVENTS.Sniper_Camouflage)
	evt_flareTut01 = Event_Proximity(FirstOutpost_FlareTutorial2, data, sg_introsnipers, data.mkr_flare, nil, ANY)	
end

function FirstOutpost_FlareTutorial2(data)
	HintPoint_Remove(hp_sniperTut)
	Util_StartIntel(EVENTS.ShootFlare)
	UI_AddHintAndFlashAbility(player1, ABILITY.SOVIET.SNIPER_FIRE_FLARES_ABILITY, 11035506, 5) -- LOCDB [11035506] 'Use the Sniper's 'Flare' ability to safely scout ahead.'
	hp_sniperTut = HintPoint_Add(data.mkr_flareTarget, true, 11047713, nil, nil, BeginnerHint_GetIconFromAbility(ABILITY.SOVIET.SNIPER_FIRE_FLARES_ABILITY)) -- LOCDB [11047713] 'Use flares here to reveal areas out of your line of sight'
	
	evt_flareTut01 = Event_PlayerCanSeeElement(FirstOutpost_CoverTutorial, data, player1, data.sg_enemyGrp, ANY)
end

function FirstOutpost_CoverTutorial(data)
	HintPoint_Remove(hp_sniperTut)
	hp_sniperTut = HintPoint_Add(data.mkr_cover, true, 11047714) -- LOCDB [11047714] 'Move the snipers into cover, out of range of the Germans'
	Util_StartIntel(EVENTS.TakeCover)
	
	evt_flareTut01 = Event_Proximity(FirstOutpost_CoverTutorial2, data, sg_introsnipers, data.mkr_cover, nil, ANY)
end

function FirstOutpost_CoverTutorial2(data)
	HintPoint_Remove(hp_sniperTut)
	hp_sniperTut = HintPoint_Add(data.mkr_attack, true, 11047715, nil, nil, "Icons_commands_icon_command_attackmove") -- LOCDB [11047715] 'While hold fire is active, right click on enemies to attack'
	
	Event_Remove(evt_flareTutCancel)
	
	Event_IsDoingAttack(EventHandler_RemoveHint, {hint = hp_sniperTut}, sg_introsnipers, ANY, 1)
end

function FirstOutpost_FoundEngineersWest()	
	Event_Remove(evt_engWest1)
	Event_Remove(evt_engWest2)

	if foundFirstTank == false then
		Objective_Start(OBJ_SecObjective, true)
		foundFirstTank = true
	else	
		Util_StartIntel(EVENTS.Engineers)
	end
	SGroup_SetPlayerOwner(sg_westEngineers, player1)
	Cmd_UngarrisonSquad(sg_westEngineers, mkr_westEngineersDest, false)
		
	Event_Timer(FirstOutpost_ShowGarrisonToolTip, {building = eg_engiGarrisonWest}, 1)
end

function FirstOutpost_FoundEngineersEast()
	Event_Remove(evt_engEast1)
	Event_Remove(evt_engEast2)
	if foundFirstTank == false then
		Objective_Start(OBJ_SecObjective, true)
		foundFirstTank = true
	else	
		Util_StartIntel(EVENTS.Engineers)
	end
	SGroup_SetPlayerOwner(sg_eastEngineers, player1)	
	Cmd_UngarrisonSquad(sg_eastEngineers, mkr_eastEngineersDest, false)
	
	
	Event_Timer(FirstOutpost_ShowGarrisonToolTip, {building = eg_engiGarrisonEast}, 1)
end

function FirstOutpost_ShowGarrisonToolTip(data)	
	if hp_garrison == nil then
		hp_garrison = HintPoint_Add(data.building, true, 11035491, nil, nil, nil) -- LOCDB [11035491] 'Squads will warm up when garrisoned in a building'
		Event_IsHoldingAny(EventHandler_RemoveHint, {hint = hp_garrison}, data.building, false)
	end
end

function FirstOutpost_EndScout()
	FirstOutpost_scoutDone1 ()
	Rule_RemoveIfExist(FirstOutpost_scoutCheck1)
	FirstOutpost_scoutDone3 ()
	Rule_RemoveIfExist(FirstOutpost_scoutCheck3)
end

function FirstOutpost_scoutCheck1()
	if Player_CanSeePosition(player1, Util_GetPosition(mkr_d1_westApp)) then
		FirstOutpost_scoutDone1 ()
		Rule_RemoveMe()
	end
end

function FirstOutpost_scoutDone1 ()
	Objective_RemoveUIElements(OBJ_SniperObjective, OBJ1_SB1)
	HintPoint_Remove(OBJ1_HINT1)
	obj1_sc1 = true
end

function FirstOutpost_scoutCheck3()
	if Player_CanSeePosition(player1, Util_GetPosition(mkr_d1_eastApp)) then
		FirstOutpost_scoutDone3()
		Rule_RemoveMe()
	end
end

function FirstOutpost_scoutDone3 ()
	Objective_RemoveUIElements(OBJ_SniperObjective, OBJ1_SB3)
	obj1_sc3 = true
end

function FirstOutpost_UpdateCheck()
	if (obj1_sc1 and obj1_sc3) then
		FirstOutpost_ScoutCompleted ()
	end
end
 
function FirstOutpost_ScoutCompleted()
	Objective_UpdateText(OBJ_ScoutOutpost, 11035492, 11035493)  -- LOCDB [11035492] 'Capture the Forward Outpost' -- LOCDB [11035493] 'Assault and capture the German Forward Outpost.'
	Rule_Remove(FirstOutpost_UpdateCheck)
	
	OBJ1_Main = Objective_AddUIElements(OBJ_ScoutOutpost, eg_alphaPoint, true)
			
	Rule_Add(FirstOutpost_CheckComplete)
	function _skip ()
		SGroup_Kill(sg_d1_grens)
		EGroup_InstantCaptureStrategicPoint(eg_alphaPoint, player1)
		SGroup_WarpToMarker(Player_GetSquads(player1), mkr_obj1_reinf_dest)
		Camera_FocusOnPosition(Util_GetPosition(mkr_d1_engaged), false)
	end
end

function FirstOutpost_CheckComplete()
	if EGroup_IsCapturedByPlayer(eg_alphaPoint, player1, false) then 			
		if sg_d1_grens ~= nil then
			Cmd_StaggeredRetreat(sg_d1_grens, {mkr_secondDepotRetreat})		
		end
		if g_enc_d1_East ~= nil then
			g_enc_d1_East:ClearGoal()
		end
		if g_enc_d1_West ~= nil then
			g_enc_d1_West:ClearGoal()
		end
		Objective_RemoveUIElements(OBJ_ScoutOutpost, OBJ1_Main)
		Objective_Complete(OBJ_ScoutOutpost, true)
		Rule_RemoveMe()	
		
		if nonSniperCapturedPoint then
			failedSniperAchievement = true
		end
	end
	nonSniperCapturedPoint = IsNonSniperCapturing(mkr_firstCaptureZone_01, mkr_firstCaptureZone_02, mkr_firstCaptureZone_03, mkr_firstCaptureZone_04) 
end

function FirstOutpost_Complete()	
	local maxReinforcements = 2
	if campaignDifficulty == GD_HARD then
		local maxReinforcements = 1
	end	
	
	local engiCount = maxReinforcements - SGroup_CountSpawned(sg_playerEng)
	local sniperCount = maxReinforcements - SGroup_CountSpawned(sg_introsnipers)
	local guardCount = maxReinforcements - SGroup_CountSpawned(sg_intro)

	print(engiCount)
	print(sniperCount)
	print(guardCount)
	
	if sniperCount > 0 then
		local sg_temp = SGroup_CreateIfNotFound("")
		Util_CreateSquads(player1, {sg_temp, sg_introsnipers}, SBP.SOVIET.SNIPER_TEAM, mkr_obj1_reinf, mkr_obj1_reinf_dest, sniperCount)
		Squad_AddAbility(SGroup_GetSpawnedSquadAt(sg_temp, 1), ABILITY.SOVIET.SNIPER_SUPPRESSION_FIRE_ABILITY)
		if SGroup_Count(sg_temp) > 1 then
			Squad_AddAbility(SGroup_GetSpawnedSquadAt(sg_temp, 2), ABILITY.SOVIET.SNIPER_SUPPRESSION_FIRE_ABILITY)
		end
	end	
	if engiCount > 0 then
		Util_CreateSquads(player1, sg_playerEng, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_obj1_reinf, mkr_obj1_reinf_dest, engiCount)
	end
	if guardCount > 0 then
		Util_CreateSquads(player1, sg_intro, SBP.SOVIET.GUARDS_TROOPS, mkr_obj1_reinf, mkr_obj1_reinf_dest, guardCount)
	end
	
	UI_CreateMinimapBlip(Util_GetPosition(mkr_obj1_reinf), 5, BT_General) 
		
	Util_Autosave()
	Objective_RemoveUIElements(OBJ_SniperObjective, OBJ1_SB1)
	Objective_RemoveUIElements(OBJ_SniperObjective, OBJ1_SB3)
	HintPoint_RemoveAll()
	Objective_Start(OBJ_Objective2, true)
end

-------------------------------------------------------------------------
-- Objective 3: Fuel Depot
-------------------------------------------------------------------------
function FuelDepot_Setup()
	OBJ_Objective2 = {
		Parent = OBJ_ObjectiveParent,
		OnStart = function()
			OBJ2_SB1 = Objective_AddUIElements(OBJ_Objective2, mkr_d2_scoutWest, true)
			Rule_AddInterval(FuelDepot_scoutCheck1, 2)
			OBJ2_SB2 = Objective_AddUIElements(OBJ_Objective2, mkr_d2_scoutSouth, true)
			Rule_AddInterval(FuelDepot_scoutCheck2, 2)
			OBJ2_SB3 = Objective_AddUIElements(OBJ_Objective2, mkr_d2_scoutSouthEast, true)
			
			FuelDepot_SpawnEncounter()
			World_IncreaseInteractionStage()
			
			Rule_AddInterval(FuelDepot_scoutCheck3, 2)
			Rule_AddInterval(FuelDepot_UpdateCheck, 1)
			Rule_AddInterval(FuelDepot_checkEngaged, 2)
			
			Player_SetCommandAvailability(player1, SCMD_Retreat, ITEM_UNLOCKED)
			
			evt_halftrackHint01 = Event_Proximity(FuelDepot_HalfTrack, nil, player1, eg_frozenHalftrack, 10, ANY)
			evt_halftrackHint02 = Event_Proximity(FuelDepot_HalfTrack, nil, player1, eg_frozenHalftrack02, 10, ANY)
			evt_halftrackHint03 = Event_Proximity(FuelDepot_HalfTrack, nil, player1, eg_frozenHalftrack03, 10, ANY)
--~ 			Event_Proximity(FuelDepot_HalfTrack, nil, player1, mkr_nearHalftrack, nil, ANY)
			
			evt_needReinforcements = Event_PlayerSquadCount(EventHandler_StartIntel, {intel = EVENTS.NeedReinforcements}, player1, 2, 1)
			function _skip ()
				FuelDepot_EndScout()
			end
		end,
		
		OnComplete = function()
			HintPoint_RemoveAll()	
			FuelDepot_SpawnReinforcements()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.FindSecondDepot,	
		Intel_Complete = nil,	
		Intel_Fail = nil,	
		Title = 11035507, -- LOCDB [11035507] 'Scout approaches to the German fuel depot'
		Description = 11035523, -- LOCDB [11035523] 'Scout the approaches to the German Fuel Depot to aid in planning your attack'
		TitleEnd = 11035512, -- LOCDB [11035508] 'Fuel depot captured.'
		TitleFail = 11035524, -- LOCDB [11035524] 'Failed to scout the German Fuel Depot'
		Type = OT_Primary,
	}	
	Objective_Register(OBJ_Objective2)
end

function FuelDepot_SpawnEncounter()

	sg_d2_grens = SGroup_CreateIfNotFound("sg_d2_grens")
	sg_d2_reinf = SGroup_CreateIfNotFound("sg_d2_reinf")
	
	local encData = {
		player = player2,
		spawn = mkr_d2_reinf1,
		sgroups = {sg_d2_grens, sg_d2_reinf},
		units = {		
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_d2_reinf1,	load = 4,},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_d2_reinf1,	load = 3,	upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},},
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,		spawn = mkr_d2_reinf1,	load = 2, veterancyRank = 0,},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,		spawn = mkr_d2_reinf1,	load = 2, veterancyRank = 2,},
			{difficulty =  GD_HARD,		sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,		spawn = mkr_d2_reinf1,	load = 2, veterancyRank = 3,},	
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,		spawn = mkr_d2_reinf1,	load = 3, veterancyRank = 0,},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,		spawn = mkr_d2_reinf1,	load = 3, veterancyRank = 1,},
			{difficulty =  GD_HARD,		sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,		spawn = mkr_d2_reinf1,	load = 3, veterancyRank = 2,},	
		},
	}
	g_enc_d2_reinf = Encounter:Create(encData)
	Rule_AddInterval(FuelDepot_GermansCounter, 3)
	
	-- SOUTH LINE
	encData = {
		name = "Germans_D2",
		player = player2,
		
		sgroups = {sg_d2_grens},
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_beta_trench01,	load = 3,},
			
			{sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,	spawn = mkr_beta_trench02,	load = 2,},
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,		spawn = mkr_beta_trench02,	veterancyRank = 0,},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,		spawn = mkr_beta_trench02,	veterancyRank = 2,},
			{difficulty =  GD_HARD,		sbp = SBP.GERMAN.GRENADIER_SQUAD_SP,		spawn = mkr_beta_trench02,	veterancyRank = 3,},	
		},
	}
	g_enc_d2_1 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_d2SouthTarget,
		targetRange = mkr_d2SouthTarget,
		leashRange = mkr_d2SouthTarget_leash,
		garrisonIdle = true,
		garrison = true,
	}
	g_enc_d2_1:SetGoal(goalData)
	
	encData = {
		player = player2,
		spawn = mkr_beta_trench01,
		sgroups = {sg_d2_grens},
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_beta_trench01},
		},
	}
	g_enc_d2_2 = Encounter:Create(encData)
	goalData = {
		name = "Defend",
		target = mkr_betaCapture,
		garrisonIdle = true,
		garrison = true,
	}
	g_enc_d2_2:SetGoal(goalData)
	

	-- WEST LINE
	encData = {
		name = "Germans_D2",
		player = player2,
		spawn = mkr_d2_west1,
		sgroups = {sg_d2_grens},
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_d2_west1,	load = 3,},
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_beta_trench02,	load = 2,	veterancyRank = 0,},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_beta_trench02,	load = 2, 	veterancyRank = 1,},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_beta_trench02,	load = 2,	veterancyRank = 2,},	
		},
	}
	g_enc_d2_5 = Encounter:Create(encData)
	goalData = {
		name = "Defend",
		target = mkr_d2_west1,
	}
	g_enc_d2_5:SetGoal(goalData)
	
	encData = {
		name = "Germans_D2",
		player = player2,
		spawn = mkr_d2_scoutWest,
		sgroups = {sg_d2_grens},
		units = {
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_d2_scoutWest,	veterancyRank = 0,},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_d2_scoutWest, 	veterancyRank = 1,},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_d2_scoutWest,	veterancyRank = 2,},	
		},
	}
	g_enc_d2_4 = Encounter:Create(encData)
	goalData = {
		name = "Defend",
		target = mkr_d2_west1,
		garrisonIdle = false,
		garrison = false,
	}
	g_enc_d2_4:SetGoal(goalData)	
	
	encData = {
		name = "Germans_D2",
		player = player2,
		spawn = mkr_d2_HMG,
		sgroups = {sg_d2_grens},
		units = {
			{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_d2_HMG,},	
		},
	}
	g_enc_d2_4 = Encounter:Create(encData)
	goalData = {
		name = "Defend",
		target = mkr_d2_west1,
		garrisonIdle = true,
		garrison = true,
	}
	g_enc_d2_4:SetGoal(goalData)	
	
	encData = {
		name = "Germans_D2",
		player = player2,
		spawn = mkr_beta_hmgPost_3,
		sgroups = {sg_d2_grens},
		units = {
			{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_beta_hmgPost_3,},	
		},
	}
	g_enc_d2_3 = Encounter:Create(encData)
	goalData = {
		name = "Defend",
		target = mkr_d2SouthTarget,
		garrisonIdle = true,
		garrison = true,
	}
	g_enc_d2_3:SetGoal(goalData)	
end

function FuelDepot_HalfTrack(data)
	print("++FuelDepot_HalfTrack++")
	Event_Remove(evt_halftrackHint01)
	Event_Remove(evt_halftrackHint02)
	Event_Remove(evt_halftrackHint03)

	eg_hintedHalftrack = data._location
	if EGroup_Count(data._location) > 0 and EGroup_IsHoldingAny(data._location) == false then
		print("--FuelDepot_HalfTrack--")
		halftrackHint = HintPoint_Add(data._location, true, 11035509, nil, nil, "Icons_tooltips_garrison") -- LOCDB [11035509] 'Garrison an abandoned vehicle to commandeer it for your use.'
		Util_StartIntel(EVENTS.HalfTrack)
		Rule_AddInterval(FuelDepot_InHalfTrack,1)		
	end
end

function FuelDepot_InHalfTrack()
	if Player_OwnsEGroup( player1, eg_hintedHalftrack, ANY ) then
		
		print("++FuelDepot_InHalfTrack++")
		Rule_RemoveMe()
		
		sg_frozenHalftrack = SGroup_CreateIfNotFound("sg_frozenHalftrack")
		SGroup_Clear(sg_frozenHalftrack)
		World_GetSquadsNearPoint(player1, sg_frozenHalftrack, EGroup_GetPosition(eg_hintedHalftrack), 10, OT_Player)
		SGroup_Filter(sg_frozenHalftrack, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, FILTER_KEEP)
		
		if SGroup_Count(sg_frozenHalftrack) > 0 then
			HintPoint_Remove(halftrackHint)
			halftrackHint = HintPoint_Add(sg_frozenHalftrack, true, 11035510, nil, nil, "Icons_odds_reinforce") -- LOCDB [11035510] 'Troops near a friendly half-track can reinforce.'
			Event_Timer(EventHandler_RemoveHint, {hint = halftrackHint}, 10)
			Rule_AddOneShot(FuelDepot_InHalfTrack_StartReminders, 60)
		end
	end
end

function FuelDepot_InHalfTrack_StartReminders()
	BeginnerHint_AddOpportunity(sg_reinforcehints, HINT_REINFORCE, true)
end

function FuelDepot_checkEngaged()
	if Prox_ArePlayersNearMarker(player1, mkr_betaCapture, false) then
		FuelDepot_EndScout()
		Rule_RemoveMe()
	end
end

function FuelDepot_EndScout()
	FuelDepot_scoutDone1 ()
	Rule_RemoveIfExist(FuelDepot_scoutCheck1)
	FuelDepot_scoutDone2 ()
	Rule_RemoveIfExist(FuelDepot_scoutCheck2)
	FuelDepot_scoutDone3 ()
	Rule_RemoveIfExist(FuelDepot_scoutCheck3)
end

function FuelDepot_scoutCheck1()
	if Player_CanSeePosition(player1, Util_GetPosition(mkr_d2_scoutWest)) then
		FuelDepot_scoutDone1 ()
		Rule_RemoveMe()
	end
end

function FuelDepot_scoutDone1 ()
	Objective_RemoveUIElements(OBJ_Objective2, OBJ2_SB1)
	HintPoint_Remove(OBJ2_HINT1)
	obj2_sc1 = true
end

function FuelDepot_scoutCheck2()
	if Player_CanSeePosition(player1, Util_GetPosition(mkr_d2_scoutSouth)) then
		FuelDepot_scoutDone2()
		Rule_RemoveMe()
	end
end

function FuelDepot_scoutDone2 ()
	Objective_RemoveUIElements(OBJ_Objective2, OBJ2_SB2)
	obj2_sc2 = true
end


function FuelDepot_scoutCheck3()
	if Player_CanSeePosition(player1, Util_GetPosition(mkr_d2_scoutSouthEast)) then
		FuelDepot_scoutDone3()
		Rule_RemoveMe()
	end
end

function FuelDepot_scoutDone3 ()
	Objective_RemoveUIElements(OBJ_Objective2, OBJ2_SB3)
	HintPoint_Remove(OBJ2_HINT3)
	obj2_sc3 = true
end

function FuelDepot_UpdateCheck()
	if (obj2_sc1 or obj2_sc2 or obj2_sc3) then
		FuelDepot_EndScout()
		FuelDepot_ScoutCompleted ()
	end

end

function FuelDepot_ScoutCompleted ()
	locid = 11035511 -- LOCDB [11035511] 'Capture the fuel depot'
	Objective_UpdateText(OBJ_Objective2, locid, 11035512) -- LOCDB [11035512] 'Assault and capture the German Fuel Depot.'
	Rule_RemoveIfExist(FuelDepot_checkEngaged)
	Rule_RemoveIfExist(FuelDepot_UpdateCheck)
--~ 		Objective_Complete(OBJ_ScoutOutpost)
--~ 		Objective_Start(OBJ_Objective2)
		
	OBJ2_CAP = Objective_AddUIElements(OBJ_Objective2, eg_betaPoint, true)
	
	function _skip ()
		SGroup_Kill(sg_d2_grens)
		EGroup_InstantCaptureStrategicPoint(eg_betaPoint, player1)
		SGroup_WarpToMarker(Player_GetSquads(player1), mkr_d2_reinf1)
		Camera_FocusOnPosition(Util_GetPosition(mkr_d2_reinf1), false)
	end
	
	Rule_Add(FuelDepot_CheckComplete)
end

function FuelDepot_CheckComplete()
	if EGroup_IsCapturedByPlayer(eg_betaPoint, player1, false) then 
		Event_Remove(evt_needReinforcements)
		Cmd_StaggeredRetreat(sg_d2_grens, {mkr_secondDepotRetreat, mkr_enemyGammaRetreatRear})
				
		Objective_Complete(OBJ_Objective2, true)
		Objective_Start(OBJ_Objective3, true)
		Rule_RemoveMe()		
		if nonSniperCapturedPoint then
			failedSniperAchievement = true
		end
	end
	nonSniperCapturedPoint = IsNonSniperCapturing(mkr_fuelDepotCapZone) 
end

function FuelDepot_GermansCounter ()
	if (Prox_ArePlayersNearMarker(player1, mkr_d2_reinf1_trigger, false)) then
		local goalData = {
			name = "Attack",
			target = mkr_d2_reinf1_targ,
			attackMove = true,
			tacticCloseGround = true,
			useSkirmishAI = true,
			leashRange = 10,
		}
		g_enc_d2_reinf:SetGoal(goalData)
		Rule_RemoveMe()
	elseif (SGroup_IsUnderAttack(sg_d2_grens, false, 3)) then
		local sg_temp = SGroup_CreateIfNotFound("sg_temp")
		SGroup_GetLastAttacker(sg_d2_grens, sg_temp)
		if SGroup_CountSpawned(sg_temp) > 0 then
			Cmd_AttackMove(sg_d2_reinf, Util_GetPosition(sg_temp), false, nil, 20)
		end
		Cmd_Move(sg_d2_reinf, mkr_d2_reinf1_targ, true, nil, nil, nil, nil, 20)
		Rule_RemoveMe()
	end
end


function FuelDepot_SpawnReinforcements()		
	local maxReinforcements = 2
	if campaignDifficulty == GD_HARD then
		local maxReinforcements = 1
	end	
	
	local engiCount = maxReinforcements - SGroup_CountSpawned(sg_playerEng)
	local sniperCount = maxReinforcements - SGroup_CountSpawned(sg_introsnipers)
	local guardCount = maxReinforcements - SGroup_CountSpawned(sg_intro)
		
	if sniperCount > 0 then
		local sg_temp = SGroup_CreateIfNotFound("sg_temp")
		SGroup_Clear(sg_temp)
		Util_CreateSquads(player1, {sg_temp, sg_introsnipers}, SBP.SOVIET.SNIPER_TEAM, mkr_secondDepotReinforcements, mkr_d2_reinf1, sniperCount)
		Squad_AddAbility(SGroup_GetSpawnedSquadAt(sg_temp, 1), ABILITY.SOVIET.SNIPER_SUPPRESSION_FIRE_ABILITY)
		if SGroup_Count(sg_temp) > 1 then 
			Squad_AddAbility(SGroup_GetSpawnedSquadAt(sg_temp, 2), ABILITY.SOVIET.SNIPER_SUPPRESSION_FIRE_ABILITY)
		end
		SGroup_Destroy(sg_temp)
	end	
	if engiCount > 0 then
		Util_CreateSquads(player1, sg_playerEng, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_secondDepotReinforcements, mkr_d2_reinf1, engiCount)
	end
	if guardCount > 0 then
		Util_CreateSquads(player1, sg_intro, SBP.SOVIET.GUARDS_TROOPS, mkr_secondDepotReinforcements, mkr_d2_reinf1, guardCount)
	end
end

-------------------------------------------------------------------------
-- Objective 4: Final Depot
-------------------------------------------------------------------------
function FinalDepot_Setup()

	OBJ_Objective3 = {
		Parent = OBJ_ObjectiveParent,
		
		OnStart = function()		
			Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 0)
			Util_PlayMusic(musicCounterAttack, 0, 3)
		
			Rule_Add(FinalDepot_Captured)
			
			World_IncreaseInteractionStage()
			FinalDepot_SpawnEncounter()
			
			OBJ3_Main = Objective_AddUIElements(OBJ_Objective3, eg_gammaPoint, true)
		end,
		
		Intel_Start = EVENTS.FindThirdDepot,
		Intel_Complete = nil,
		Intel_Fail = nil,
		Title = 11035513,	 -- LOCDB [11035513] 'Secure the final German outpost'
		Description = 11035525, -- LOCDB [11035525] 'Gain control over the final German outpost, securing the region.'
		TitleEnd =  11047620, -- LOCDB [11047620] 'Repel the German forces, or die trying'
		TitleFail = 11035526, -- LOCDB [11035526] 'Failed to gain control of the final German outpost'
		Type = OT_Primary,
	}
	
	Objective_Register(OBJ_Objective3)
end

function FinalDepot_SpawnEncounter()	
	sg_d3_grens = SGroup_CreateIfNotFound("sg_d3_grens")
	encData = {
		player = player2,
		spawn = mkr_beta_trench01,
		sgroups = {sg_d3_grens},
		units = {
			{difficulty = {GD_NORMAL, GD_HARD},	sbp = SBP.GERMAN.MORTAR_TEAM_81MM,	spawn = mkr_mortar01,},
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.MORTAR_TEAM_81MM,	spawn = mkr_mortar02,	veterancyRank = 0,},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.MORTAR_TEAM_81MM,	spawn = mkr_mortar02,	veterancyRank = 1,},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.MORTAR_TEAM_81MM,	spawn = mkr_mortar02,	veterancyRank = 2,},	
		},
	}
	g_enc_d3_1 = Encounter:Create(encData)
	local goalData = {
		name = "Defend",
		target = mkr_gammaCapture,
		range = mkr_gammaCapture,
		useSkirmishAI = true,
		leashRange = 10,
	}
	g_enc_d3_1:SetGoal(goalData)
	
	if campaignDifficulty ~= GD_HARD then
		Modify_WeaponRange(sg_d3_grens, "hardpoint_01", 0.6)
	end
	
	--mkr_d3_g1
	encData = {
		player = player2,
		spawn = mkr_d3_g1,
		sgroups = {sg_d3_grens},
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_d3_g1, load = 3,},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_d3_g1, load = 2,},
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,	spawn = mkr_d3_open2,	load = 5,	veterancyRank = 0,},
			
			{difficulty = {GD_NORMAL, GD_HARD},	sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_d3_open2,	veterancyRank = 1,},
			{difficulty = GD_HARD,				sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_mortar02, 	veterancyRank = 3,	load = 3,},	
		},
	}
	g_enc_d3_2 = Encounter:Create(encData)
	goalData = {
		name = "Defend", 
		target = mkr_gammaCapture,
		range = mkr_gammaCapture,
		useSkirmishAI = true,
	}
	g_enc_d3_2:SetGoal(goalData)
	
	encData = {
		player = player2,
		spawn = mkr_d3_g2,
		sgroups = {sg_d3_grens},
		units = {
			{difficulty = {GD_NORMAL, GD_HARD},	sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_d3_g2,},
		},
	}
	g_enc_d3_3 = Encounter:Create(encData)
	goalData = {
		name = "Defend",
		target = mkr_d3_g2,
		range = mkr_d3_g2,
		garrisonIdle = true,
		garrison = true,
	}
	g_enc_d3_3:SetGoal(goalData)
	
	encData = {
		player = player2,
		spawn = mkr_d3_g4,
		sgroups = {sg_d3_grens},
		units = {
			{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_d3_g4,},
		},
	}
	g_enc_d3_4 = Encounter:Create(encData)
	goalData = {
		name = "Defend",
		target = mkr_d3_g4,
		range = mkr_d3_g4,
		garrisonIdle = true,
		garrison = true,
	}
	g_enc_d3_4:SetGoal(goalData)
	
	sg_finalOutpostHMG = SGroup_Create("sg_finalOutpostHMG")
	--post
	encData = {
		player = player2,
		spawn = mkr_gamma_hmgPost_4,
		sgroups = {sg_d2_grens_b, sg_d3_grens, sg_finalOutpostHMG},
		units = {
			{difficulty = GD_EASY,	sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = sg_d2_grens_b,	veterancyRank = 0,},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = sg_d2_grens_b,	veterancyRank = 1,},
			{difficulty = GD_HARD,	sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = sg_d2_grens_b,	veterancyRank = 2,},
		},
	} 
	g_enc_d2_5 = Encounter:Create(encData)
	goalData = {
		name = "Defend",
		target = mkr_gamma_hmgPost_4,
		range = mkr_gamma_hmgPost_4,
		garrisonIdle = true,
		garrison = true,
	}
	g_enc_d2_5:SetGoal(goalData)
	
	if campaignDifficulty ~= GD_HARD then
		Modify_SightRadius(eg_hmgBuilding, 0.5)
	end
end

function FinalDepot_Captured()
	if EGroup_IsCapturedByPlayer(eg_gammaPoint, player1, false) then 		
		
		Cmd_StaggeredRetreat(sg_d3_grens, {mkr_finalRetreat})	
	
		evt_obj3Complete = Event_GroupIsDead(FinalDepot_Complete, nil, sg_d3_grens)
		evt_obj3CompleteFailsafe = Event_Timer(FinalDepot_Complete, nil, 30)
		Rule_RemoveMe()
		
		if failedSniperAchievement ~= true then
			Event_Remove(evt_failedSnipers)
			Scar_CompleteIntelBulletinTask(player1, "camp04_kaluga_snipers_only")
		end		
		if nonSniperCapturedPoint then
			failedSniperAchievement = true
		end
	end 
	nonSniperCapturedPoint = IsNonSniperCapturing(mkr_finalCapZone_01, mkr_finalCapZone_02, mkr_finalCapZone_03) 
end

function FinalDepot_Complete()	
	Event_Remove(evt_obj3Complete)	
	Event_Remove(evt_obj3CompleteFailsafe)

	Util_Autosave()
	Objective_RemoveUIElements(OBJ_Objective3, OBJ3_Main)
	Event_Timer(Defend_Start, nil, 2)
end

-------------------------------------------------------------------------
-- Objective 5: Defend
-------------------------------------------------------------------------
function Defend_Start()
	Event_Remove(evt_missionFail)	
	Util_StartIntel(EVENTS.PrepareAmbush)
	locid = 11035515 -- LOCDB [11035515] 'More Germans are falling back to this position with numbers. Prepare an ambush, victory will secure the region.'
	Objective_UpdateText(OBJ_Objective3, 11047620, locid, true)  -- LOCDB [11047620] 'Repel the German forces, or die trying'
	
	Player_SetHeatLossRate(player2, 0.5)
	Player_SetHeatGainRate(player2, 0.5)

	Event_Timer(Defense_SpawnGermanScout, nil, 35)
	Event_Timer(Defend_StopBlizzard, nil, 15)
	
	evt_playerLostTerritory = Event_PlayerOwnsTerritory(Defend_LostTerritory, nil, player2, eg_gammaPoint)
	evt_playerDead = Event_PlayerSquadCount(Defend_FailCheck, nil, player1, 0, 1)
	
	manpowerStatusGood = 45
	manpowerStatusNormal = 30
	
	if campaignDifficulty == GD_NORMAL then
		manpowerStatusGood = 35
		manpowerStatusNormal = 20
	elseif campaignDifficulty == GD_HARD then
		manpowerStatusGood = 25
		manpowerStatusNormal = 10	
	end
	
	Event_Timer(SetScatter, nil, 1)
end

function SetScatter()
	playerMortarGroups = playerMortarGroups or {}

	local playerSquads = Player_GetSquads(player1)
	SGroup_Filter(playerSquads, SBP.GERMAN.MORTAR_TEAM_81MM, FILTER_KEEP)
	
	if SGroup_CountSpawned(playerSquads) > 0 then		
		for i = table.getn(playerMortarGroups), 1, -1 do
			local squad = playerMortarGroups[i]
			
			if Squad_IsValid(squad) then
				SGroup_Remove(playerSquads, Squad_FromWorldID(squad))			
			else 
				table.remove(playerSquads, i)
			end
		end
		if SGroup_CountSpawned(playerSquads) > 0 then
			table.insert(playerMortarGroups, Squad_GetGameID(SGroup_GetSpawnedSquadAt(playerSquads, 1)))
			Modify_WeaponScatter( playerSquads, "hardpoint_01", 0.35) 
		end
	end
	Event_Timer(SetScatter, nil, 1)	
end

function Defend_StopBlizzard()
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/_m04_kaluga_02.aps", 30) 
	Player_SetHeatLossRate(player1, 0)
	Player_SetHeatLossRate(player2, 0)	
end

function Defend_FailCheck()
	Event_Remove(evt_playerDead)
	Event_Remove(evt_playerLostTerritory)
	Event_Remove(evt_playerVictory)
	Util_StartIntel(EVENTS.FailedDefense)
end

function Defense_SpawnGermanScout()
	sg_defenseScouts01 = SGroup_CreateIfNotFound("sg_defenseScouts01")	
	sg_defenseScouts02 = SGroup_CreateIfNotFound("sg_defenseScouts02")	
	counterAttackMoveFactor = 1.5
	
	local encData = {
		name = "finalEnc_01",
		player = player2,
		spawn = mkr_enemyGammaRetreat,
		sgroups = {sg_defenseScouts01},
		units = {
			{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,	spawn = mkr_enemyGammaRetreat,},
		},
	}
	local enc = Encounter:Create(encData)	
	local finalGoalWest = {
		name = "Attack",
		target = mkr_counterTarget_01,
		range = mkr_counterTarget_01,
		leashRange = mkr_counterTarget_01,
		tacticCloseGround = true,			
		movePathLengthFactor = counterAttackMoveFactor,
	}
	enc:SetGoal(finalGoalWest)

	encData = {
		name = "finalEnc_01",
		player = player2,
		spawn = mkr_d3_flank,
		sgroups = {sg_defenseScouts02},
		units = {
			{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,	spawn = mkr_d3_flank,},
		},
	}
	enc = Encounter:Create(encData)	
	finalGoalWest = {
		name = "Attack",
		target = mkr_finalAttack01,
		tacticCloseGround = true,			
		movePathLengthFactor = counterAttackMoveFactor,
	}
	enc:SetGoal(finalGoalWest)
	threatArrow01 = ThreatArrow_CreateGroup(sg_defenseScouts01)
	threatArrow02 = ThreatArrow_CreateGroup(sg_defenseScouts02)	
	
	Event_PlayerCanSeeElement(RemoveThreatArrow, {arrow = threatArrow01, group = sg_defenseScouts01}, player1, sg_defenseScouts01, ANY) 
	Event_PlayerCanSeeElement(RemoveThreatArrow, {arrow = threatArrow02, group = sg_defenseScouts02}, player1, sg_defenseScouts02, ANY) 
	
	Event_Timer(Defense_SpawnGermans, nil, 25) 
end

function RemoveThreatArrow(data)
	ThreatArrow_Remove(data.arrow, data.group)
end

function Defense_SpawnGermans()
	sg_d4_grens = SGroup_CreateIfNotFound("sg_d4_grens")	
	sg_d4_grensEast = SGroup_CreateIfNotFound("sg_d4_grensEast")	
	sg_d4_grensWest = SGroup_CreateIfNotFound("sg_d4_grensWest")	
	counterAttackMoveFactor = 1.5
	if Player_GetCurrentPopulation(player1, CT_Personnel) > manpowerStatusNormal then
		local encData = {
			name = "finalEnc_01",
			player = player2,
			spawn = mkr_enemyGammaRetreat,
			sgroups = {sg_d4_grens},
			units = {
				{difficulty = GD_EASY,		sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,			spawn = mkr_enemyGammaRetreat,},
				{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.GRENADIER_SQUAD,			spawn = mkr_enemyGammaRetreat,},
				{difficulty = GD_HARD,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_enemyGammaRetreat,},			
			},
		}
		local enc = Encounter:Create(encData)	
		local finalGoalWest = {
			name = "Attack",
			target = mkr_counterTarget_01,
			range = mkr_counterTarget_01,
			leashRange = mkr_counterTarget_01,
			tacticCloseGround = true,			
			movePathLengthFactor = counterAttackMoveFactor,
		}
		enc:SetGoal(finalGoalWest)
	end

	encData = {
		player = player2,
		spawn = mkr_d3_flank,
		sgroups = {sg_d4_grens},
		units = {
			{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,	spawn = mkr_d3_flank2, sgroups = {sg_d4_grensEast},},
		},
	} 
	enc = Encounter:Create(encData)
	local finalGoalEast = {
		name = "Attack",
		target = mkr_finalAttack01,
		range = mkr_finalAttack01,
		leashRange = mkr_finalAttack01,
		tacticCloseGround = true,		
		movePathLengthFactor = counterAttackMoveFactor,
	}
	enc:SetGoal(finalGoalEast)
	
	Event_Timer(Defense_SpawnGermans2, nil,7.5)
end

function Defense_SpawnGermans2()
	sg_d4_grens = SGroup_CreateIfNotFound("sg_d4_grens")	
	sg_d4_grensEast = SGroup_CreateIfNotFound("sg_d4_grensEast")	
	sg_d4_grensWest = SGroup_CreateIfNotFound("sg_d4_grensWest")	
	
	counterAttackMoveFactor = 1.5
	
	encData = {
		name = "finalEnc_01",
		player = player2,
		spawn = mkr_enemyGammaRetreat,
		sgroups = {sg_d4_grens},
		units = {
			{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,	spawn = mkr_enemyGammaRetreat, sgroups = {sg_d4_grensWest},},
		},
	}
	local enc = Encounter:Create(encData)	
	finalGoalWest = {
		name = "Attack",
		target = mkr_counterTarget_01,
		range = mkr_counterTarget_01,
		leashRange = mkr_counterTarget_01,
		tacticCloseGround = true,			
		movePathLengthFactor = counterAttackMoveFactor,
	}
	enc:SetGoal(finalGoalWest)

		
	if Player_GetCurrentPopulation(player1, CT_Personnel) > manpowerStatusGood then
		encData = {
			player = player2,
			spawn = mkr_d3_flank,
			sgroups = {sg_d4_grens},
			units = {
				{difficulty = GD_EASY,		sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,	spawn = mkr_d3_flank2,},
				{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,	spawn = mkr_d3_flank2,	veterancyRank = 2},
				{difficulty = GD_HARD,		sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,	spawn = mkr_d3_flank2, 	veterancyRank = 3},
			},
		} 
		enc = Encounter:Create(encData)
		finalGoalEast = {
			name = "Attack",
			target = mkr_finalAttack01,
			range = mkr_finalAttack01,
			leashRange = mkr_finalAttack01,
			tacticCloseGround = true,		
			movePathLengthFactor = counterAttackMoveFactor,
		}
		enc:SetGoal(finalGoalEast)
	end
	
	Event_Timer(Defense_SpawnGermans3, nil, 7.5)
end

function Defense_SpawnGermans3()
	if Player_GetCurrentPopulation(player1, CT_Personnel) > manpowerStatusNormal then
		encData = {
			name = "finalEnc_01",
			player = player2,
			spawn = mkr_enemyGammaRetreat,
			sgroups = {sg_d4_grens,sg_d4_grensWest},
			units = {
				{difficulty = GD_EASY,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_enemyGammaRetreat,},
				{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_enemyGammaRetreat,	veterancyRank = 2},
				{difficulty = GD_HARD,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_enemyGammaRetreat, 	veterancyRank = 3},
				
				{sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_enemyGammaRetreat,	upgrades = UPG.GERMAN.GRENADIER_MG42_LMG,},
			},
		}
		local enc = Encounter:Create(encData)	
		finalGoalWest = {
			name = "Attack",
			target = mkr_counterTarget_01,
			range = mkr_counterTarget_01,
			leashRange = mkr_counterTarget_01,
			tacticCloseGround = true,	
			movePathLengthFactor = counterAttackMoveFactor,
		}
		enc:SetGoal(finalGoalWest)
	end
	
	encData = {
		player = player2,
		spawn = mkr_d3_flank,
		sgroups = {sg_d4_grens, sg_d4_grensEast},
		units = {
			{sbp = SBP.GERMAN.SNIPER_SQUAD,	spawn = mkr_d3_flank2,},
		},
	}
	enc = Encounter:Create(encData)
	finalGoalEast = {
		name = "Attack",
		target = mkr_finalAttack01,
		range = mkr_finalAttack01,
		leashRange = mkr_finalAttack01,
		tacticCloseGround = true,		
		movePathLengthFactor = counterAttackMoveFactor,
	}
	enc:SetGoal(finalGoalEast)

	Event_Timer(Defense_SpawnGermans4, nil, 15)
end

function Defense_SpawnGermans4()

	encData = {
		name = "finalEnc_01",
		player = player2,
		spawn = mkr_enemyGammaRetreat,
		sgroups = {sg_d4_grens,sg_d4_grensWest},
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_enemyGammaRetreatRear},
		},
	}
	finalEncWest = Encounter:Create(encData)	
	finalGoalWest = {
		name = "Attack",
		target = mkr_counterTarget_01,
		range = mkr_counterTarget_01,
		leashRange = mkr_counterTarget_01,
		tacticCloseGround = true,	
		movePathLengthFactor = counterAttackMoveFactor,
	}
	finalEncWest:SetGoal(finalGoalWest)
	
	if Player_GetCurrentPopulation(player1, CT_Personnel) > manpowerStatusGood then	
		encData = {
			player = player2,
			spawn = mkr_d3_flank,
			sgroups = {sg_d4_grens, sg_d4_grensEast},
			units = {			
				{sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_d3_flank3,},
				
				{difficulty = {GD_EASY, GD_NORMAL}, sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_d3_flank4,},
				{difficulty = GD_HARD, 				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_d3_flank4, upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
			},
		}
		finalEncEast = Encounter:Create(encData)
		finalGoalEast = {
			name = "Attack",
			target = mkr_finalAttack01,
			range = mkr_finalAttack01,
			leashRange = mkr_finalAttack01,
			tacticCloseGround = true,
			movePathLengthFactor = counterAttackMoveFactor,
		}
		finalEncEast:SetGoal(finalGoalEast)
	end

	Event_Timer(Defense_SpawnTank, nil, 3)
end

function Defense_SpawnTank()
	sg_d4_tank = SGroup_CreateIfNotFound("sg_d4_tank")

	encData = {
		name = "finalEnc_05",
		player = player2,
		spawn = mkr_d3_tank,
		sgroups = {sg_d4_grens, sg_d4_tank},
		units = {
			{
				name = "finalAttack_05",
				sbp = SBP.GERMAN.STUG_III_SQUAD,
				numSquads = 1,
			},
		},
	}
	g_enc_d4_1 = Encounter:Create(encData)
	goalData = {
		name = "Defend",
		target = mkr_d3_tank_attack,
		leashRange = 5,
		path = d3_tank,
		movePathLengthFactor = counterAttackMoveFactor,
	}
	g_enc_d4_1:SetGoal(goalData)

	Event_GroupIsDead(Defend_TankDead, nil, sg_d4_tank)
	Event_Proximity(Defend_TankNearPlayer, nil, sg_d4_tank, mkr_d3_tank_attack, nil, ANY)

	Event_Timer(Defense_SpawnPostTank, nil, 5)
end

function Defense_SpawnPostTank()
	sg_finalAttackPanzers3 = SGroup_CreateIfNotFound("sg_finalAttackPanzers3")
	sg_finalAttackPanzers4 = SGroup_CreateIfNotFound("sg_finalAttackPanzers4")
	
	encData = {
		player = player2,
		spawn = mkr_d3_tank2,
		sgroups = {sg_finalAttackPanzers3},
		units = {			
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_d3_tank2,},
		},
	}
	local enc = Encounter:Create(encData)
	finalGoalEast = {
		name = "Attack",
		target = mkr_finalAttack01,
		range = mkr_finalAttack01,
		leashRange = mkr_finalAttack01,
		tacticCloseGround = true,
		movePathLengthFactor = counterAttackMoveFactor,
	}
	enc:SetGoal(finalGoalEast)
	
	if Player_GetCurrentPopulation(player1, CT_Personnel) > manpowerStatusNormal then	
		encData = {
			player = player2,
			spawn = mkr_d3_tank,
			sgroups = {sg_finalAttackPanzers4},
			units = {			
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_d3_tank2,},
			},
		}
		local enc = Encounter:Create(encData)
		finalGoalEast = {
			name = "Attack",
			target = mkr_counterTarget_01,
			range = mkr_counterTarget_01,
			leashRange = mkr_counterTarget_01,
			tacticCloseGround = true,
			movePathLengthFactor = counterAttackMoveFactor,
		}
		enc:SetGoal(finalGoalEast)
	end
end

function Defend_TankDead()
	Util_StartIntel(EVENTS.TankSunk)
	Event_Timer(Defend_SpawnRetreatingGermans, nil, 2)
	
	local sg_allEnemies = Player_GetSquads(player2)
	Cmd_StaggeredRetreat(sg_allEnemies, {mkr_enemyGammaRetreatRear, mkr_d3_flank})
end

function Defend_SpawnRetreatingGermans()
	sg_retreatingGermans = SGroup_CreateIfNotFound("sg_retreatingGermans")

	Util_CreateSquads(player2, sg_retreatingGermans, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_retreatingGermans)	
	Util_CreateSquads(player2, sg_retreatingGermans, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_retreatingGermans02)	
	Cmd_Retreat(sg_retreatingGermans, mkr_enemyGammaRetreatRear, mkr_enemyGammaRetreatRear)
end

function Defend_ReturnCam()
	Camera_MoveTo(camStartPosition, true, 0.5)
	SGroup_SetInvulnerable(Player_GetSquads(player1), false)
end	

function Defend_TankNearPlayer()
	Util_StartIntel(EVENTS.BreakIce)	
	
	FOW_RevealArea(Util_GetPosition(mkr_d3_tank_attack), 5, -1)
	Event_Timer(Defend_TankHintPoint, nil, 2)
end

function Defend_TankHintPoint()
	hp_barrageIce = HintPoint_Add(sg_d4_tank, true, 11047722, nil, nil, "Icons_abilities_ability_german_mortar_barrage") -- LOCDB [11047722] 'Use barrage to destroy the ice.'
	Event_Timer(Defend_TankHintPointRemove, nil, 2)
	
	UI_CreateMinimapBlip(sg_d4_tank, 4, BT_AttackHere)
	UI_AddHintAndFlashAbility(player1, ABILITY.GERMAN.MORTAR_TEAM_MORTAR_BARRAGE, 11047723, 5) -- LOCDB [11047723] 'Use barrage to destroy the ice.'
end

function Defend_TankHintPointRemove()
	HintPoint_Remove(hp_barrageIce)
end

-------------------------------------------------------------------------
-- Mission Complete
-------------------------------------------------------------------------
function EndMission()
	Event_Remove(evt_playerVictory)
	Event_Remove(evt_playerLostTerritory)
	Event_Remove(event_playerFailCheck)
	
	Util_StartIntel(EVENTS.ClosingCinematic)
end

-------------------------------------------------------------------------
-- Secondary Objective: Destroy German Tanks
-------------------------------------------------------------------------
int_tanks_total = 10
int_tanks_sofar = 0
str_description = 11042755 -- LOCDB [11042755] 'Destroy all frozen German tanks while they are defenseless.'
tanks_objectiveText = 11042756 -- LOCDB [11042756] 'Destroy the German tanks. (%1NUMDESTROYED% / %2NUMTOTAL%)'

function Initialize_SecObjective()
	eg_tanks = EGroup_CreateIfNotFound("eg_tanks")
	
	EGroup_AddEGroup(eg_tanks, eg_betaTanks)
	EGroup_AddEGroup(eg_tanks, eg_alphaTanks)
	EGroup_AddEGroup(eg_tanks, eg_introStug)
--~ 	SGroup_AddGroup(sg_tanks, sg_finalTanks)
	Event_Proximity(TankRunAway, nil, player1, mkr_nearFinalTank, nil, ANY)
	
	EGroup_SetInvulnerable(eg_tanks, 0.1)
	local obj_text = Loc_FormatText(tanks_objectiveText, Loc_ConvertNumber(0), Loc_ConvertNumber(int_tanks_total))
	OBJ_SecObjective = {				
		OnStart = function()
			Rule_AddInterval(Rule_MonitorTankHealth, 1)
		end,
		
		Intel_Start = EVENTS.DestroyTanks,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = obj_text,				-- Objective Title
		Description = str_description,			-- Objective Description
		TitleEnd = 11047471,				-- LOCDB [11047471] 'Destroy the German tanks.'
		TitleFail = nil,			-- Failed Title
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}	
	Objective_Register(OBJ_SecObjective)
end

function TankRunAway()
	SGroup_SetPlayerOwner(sg_finalTanks, player2)		
	SGroup_SetInvulnerable(sg_finalTanks, true)
	Util_StartIntel(EVENTS.TankRunAway)
	SGroup_DisableCombatPlans(sg_finalTanks)
	Cmd_Move(sg_finalTanks, mkr_tankRunAway, nil, mkr_tankRunAway)
end

function Rule_MonitorTankHealth()
	local f = function (gid, ind, iid)
		local eg_temp = EGroup_CreateIfNotFound("eg_temp")
		EGroup_Add(eg_temp, iid)
		if EGroup_GetAvgHealth(eg_temp) < 0.75 then
			EGroup_Kill(eg_temp)
			int_tanks_sofar = int_tanks_sofar + 1
			local obj_text = Loc_FormatText(tanks_objectiveText, Loc_ConvertNumber(int_tanks_sofar), Loc_ConvertNumber(int_tanks_total))
			Objective_UpdateText(OBJ_SecObjective, obj_text, str_description, false)
			if Event_IsAnyRunning() == false then
				Event_Timer(PlayTankDeadIntel, nil, 1.5)
			end
		end
		EGroup_Destroy(eg_temp)
	end
	
	if (EGroup_Count(eg_tanks) < 1) then
		Objective_Complete(OBJ_SecObjective)
		Scar_CompleteIntelBulletinTask(player1, "camp04_kaluga_tank_destruction")
		Rule_RemoveMe()
	else
		EGroup_ForEach(eg_tanks, f)
	end	
end

function PlayTankDeadIntel()
	if Event_IsAnyRunning() == false then
		Util_StartIntel(EVENTS.DestroyedTank)
	end
end

function IsNonSniperCapturing(...)
	if failedSniperAchievement ~= true then
		local sg_nonSnipers = SGroup_CreateIfNotFound("sg_nonSnipers")
		
		for k, marker in pairs(arg) do
			Player_GetAllSquadsNearMarker(player1, sg_nonSnipers, marker)
			SGroup_Filter(sg_nonSnipers, SBP.SOVIET.SNIPER_TEAM, FILTER_REMOVE)
			if SGroup_Count(sg_nonSnipers) > 0 then
				return true
			end
		end
		return false
	end
end
