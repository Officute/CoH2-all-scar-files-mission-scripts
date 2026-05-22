print("\tLoading ObjAirborne file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- TWIN VILLAGES
-- Objective File - AIRBORNE SECTION
-- Designer: NJR
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- Sub-objectives:
--    


-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_ObjAirborne()

	print("Initializing ObjAirborne...")
	
	-- Pre-condition:		Kicked off by previous objective
	-- Success condition:	
	-- Failure condition:	None
	-- Post-condition:
	--		Success:		Start Mechanized section
	--		Failure:		N/A
	OBJ_Airborne = {
		
		--Info
		Title = 11076592,	-- LOCDB [11076592] 'Survive the enemy attack in Rocherath'
		Type = OT_Primary,
		Parent = nil,
		subObjectives = {},
		
		--Intel
		Intel_Start = 				nil,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			nil,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				nil,
		Intel_Fail_SkipFunc = 		nil,
		
		--Functions
		SetupUI = function()
		end,
		PreStart = nil,
		OnStart = function()
		end,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	
	
	

	-- Pre-condition:		None - populates with the parent objective
	-- Success condition:	
	SOBJ_Airborne_CallInParatroopers = {
		Title = 11076593,	-- LOCDB [11076593] 'Call in Paratroopers behind the enemy'
		Type = OT_Primary,						
		Parent = OBJ_Airborne,				
		showTitle = false,
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() 
			FOW_RevealArea(Util_GetPosition(mkr_airborne_callinparatroopers), 10, -1)
			hpid_callinparatroopers = Objective_AddUIElements(SOBJ_Airborne_CallInParatroopers, mkr_airborne_callinparatroopers, true, 11076594, true)	-- LOCDB [11076594] 'Call Paratroopers in to this clearing'
			Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("pm_airborne_paratroopers"), ITEM_DEFAULT)
			UI_FlashAbilityButton(BP_GetAbilityBlueprint("pm_airborne_paratroopers"), true)
		end,
		PreStart = function()
		end,
		OnStart = function()
			Camera_MoveTo(mkr_airborne_callinparatroopers, true, 0.1, false, true)
		end,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = function()
			Objective_RemoveUIElements(SOBJ_Airborne_CallInParatroopers, hpid_callinparatroopers)
			FOW_UnRevealArea(Util_GetPosition(mkr_airborne_callinparatroopers), 10)
		end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_Airborne.subObjectives, SOBJ_Airborne_CallInParatroopers) -- Don't forget to add them to their parent!
	
	
	-- Pre-condition:		None - populates with the parent objective
	-- Success condition:	Player kills all of the enemies trying to encroach into the village center
	SOBJ_Airborne_ReclaimVillage = {
		Title = 11076595,	-- LOCDB [11076595] 'Hold the village of Rocherath'
		Type = OT_Primary,						
		Parent = OBJ_Airborne,				
		showTitle = false,
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() 
		end,
		PreStart = function()
		end,
		OnStart = nil,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_Airborne.subObjectives, SOBJ_Airborne_ReclaimVillage) -- Don't forget to add them to their parent!
	
	
	-- Pre-condition:		None - populates with the parent objective
	-- Success condition:	Player has captured the radio antenna VP
	SOBJ_Airborne_CaptureRadioAntenna = {
		Title = 11076596,	-- LOCDB [11076596] 'Capture the Radio Antenna'
		Type = OT_Primary,						
		Parent = OBJ_Airborne,				
		showTitle = false,
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() 
			hpid_captureradiotower = Objective_AddUIElements(SOBJ_Airborne_CaptureRadioAntenna, eg_point_radiotower, true, 11076597, true)	-- LOCDB [11076597] 'Capture this Radio Antenna'
		end,
		PreStart = function()
		end,
		OnStart = nil,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = function()
			Objective_RemoveUIElements(SOBJ_Airborne_CaptureRadioAntenna, hpid_captureradiotower)
		end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_Airborne.subObjectives, SOBJ_Airborne_CaptureRadioAntenna) -- Don't forget to add them to their parent!
	
	
	
	-- objects a player can build - these need to be player-swapped when we change commanders
	t_buildable_objects = {
		EBP.AEF.AEF_TANK_TRAP_MP,
		EBP.AEF.AIRBORNE_BEACON_MP,
	}
	
	t_base_buildings = {
		
	}
	
	
	time_last_periphery_callout = 0
	
end
Scar_AddInit(INIT_ObjAirborne)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------


function Airborne_Init()
	
	

	
end


-- called from the previous section, Support. This starts the transition into this section.
function Airborne_Start()
	
	-- switch over to the airborne commander
	Mission_SwitchCommander(CD_AIRBORNE, false, mkr_rocherath)
	
	-- this switch takes two seconds... screen is black at 0.75 second in
	
	Rule_AddOneShot(Airborne_StartB, 0.8)				-- switch player ownerships when screen is black
	Rule_AddDelayedInterval(Airborne_Intro, 1, 1)		-- after the switch, start the intro for this section
	
end

-- now the screen is black, do the rest of the setup stuff...
function Airborne_StartB()
	
	-- cleanup from the previous section
	Support_Cleanup()
	for group_index = 0, 9 do
		Misc_ClearControlGroup(group_index)
	end
	Misc_ClearSelection()
	
	-- set commander name
	Setup_SetPlayerName(player1, locid_airborne_division)
	Setup_SetPlayerName(player3, locid_airborne_division)
	
	-- add in new map section
	World_IncreaseInteractionStage()
	
	-- make the base buildings unavailable for this section
	EGroup_SetPlayerOwner(eg_basebuildings, player4)

	EGroup_InstantCaptureStrategicPoint(eg_point_enemy1, player2)
	EGroup_InstantCaptureStrategicPoint(eg_point_enemy2, player2)
	EGroup_InstantCaptureStrategicPoint(eg_point_enemy3, player2)
	EGroup_InstantCaptureStrategicPoint(eg_point_enemy4, player2)
	FOW_RevealEGroupOnly(eg_point_enemy1, 1)
	FOW_RevealEGroupOnly(eg_point_enemy2, 1)
	FOW_RevealEGroupOnly(eg_point_enemy3, 1)
	FOW_RevealEGroupOnly(eg_point_radiotower, 1)
	
	-- switch out any p1 units
	EGroup_Clear(eg_temp)
	World_GetStrategyPoints(eg_temp, true)
	
	Player_GetAll(player1)
	SGroup_SetPlayerOwner(sg_allsquads, player6)
	EGroup_Filter(eg_allentities, t_buildable_objects, FILTER_KEEP)
	EGroup_SetPlayerOwner(eg_allentities, player6)
	EGroup_SetPlayerOwner(eg_sentry1_allbunkers, player6)
	
	-- set retreat point for this section
	EGroup_DestroyAllEntities(eg_retreatpoint)
	Util_CreateEntities(player1, eg_retreatpoint, BP_GetEntityBlueprint("sp_retreat_point"), mkr_retreatpoint_airborne, 1)
	
	-- create player units for this next section
	Util_CreateSquads(player1, sg_jackson, SBP.AEF.JACKSON_SQUAD, mkr_airborne_alliedspawn5)
	Util_CreateSquads(player1, sg_airborne_pathfinders, SBP.AEF.PATHFINDER_SQUAD_MP, eg_rocherath_alliedhouse1, nil, 1)
	Util_CreateSquads(player1, sg_airborne_pathfinders, SBP.AEF.PATHFINDER_SQUAD_MP, mkr_airborne_alliedspawn6, nil, 1)
	Util_CreateSquads(player1, sg_blah, SBP.AEF.M2HB_50CAL_HMG_SQUAD_MP, eg_rocherath_alliedhouse1, nil, 1)
	Util_CreateSquads(player1, sg_blah, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_airborne_alliedspawn1, nil, 1)
	Util_CreateSquads(player1, sg_blah, SBP.AEF.M2HB_50CAL_HMG_SQUAD_MP, mkr_airborne_alliedspawn2, nil, 1)
	Util_CreateSquads(player1, sg_blah, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_airborne_alliedspawn3, nil, 1)
	Util_CreateSquads(player1, sg_blah, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_airborne_alliedspawn4, nil, 1)
	
	Modify_ReceivedDamage(sg_jackson, 0.3)
	SGroup_SetInvulnerable(sg_jackson, 0.3)
	SGroup_IncreaseVeterancyRank(sg_jackson, 3, true)
	
	
	-- set up enemy encounters
	enc_Airborne_VillageAttackers1 = ENCOUNTERS.Airborne_VillageAttackers1()
	enc_Airborne_VillageAttackers2 = ENCOUNTERS.Airborne_VillageAttackers2()
	enc_Airborne_VillageAttackers3 = ENCOUNTERS.Airborne_VillageAttackers3()
	
	local t_encounter1_data = {
		encounter = enc_Airborne_VillageAttackers1,
		sgroup = sg_airborne_attackers1,
		threshold = 3,
		topup_choices = {
			{unit = {sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, load = 2}},
			{unit = {sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, load = 2}},
			{unit = {sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, load = 2}},
			{unit = {sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, load = 2}, goal_update = GOALS.Airborne_VillageAttackers1_Secondary()},
		}
	}
	
	local t_encounter2_data = {
		encounter = enc_Airborne_VillageAttackers2,
		sgroup = sg_airborne_attackers2,
		threshold = 6,
		topup_choices = {
			{unit = {sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, loadt = 2}},
			{unit = {sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, load = 3}},
			{unit = {sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, load = 2}, goal_update = GOALS.Airborne_VillageAttackers2_Secondary()},
		}
	}
	
	local t_encounter3_data = {
		encounter = enc_Airborne_VillageAttackers3,
		sgroup = sg_airborne_attackers3,
		threshold = 5,
		topup_choices = {
			{unit = {sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, load = 2}},
			{unit = {sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, load = 2}},
			{unit = {sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, load = 2}, goal_update = GOALS.Airborne_VillageAttackers3_Secondary()},
			{unit = {sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, load = 2}},
		}
	}
	
	Event_Timer(Airborne_TopUpAttacks, t_encounter1_data, World_GetRand(3, 7))
	Event_Timer(Airborne_TopUpAttacks, t_encounter2_data, World_GetRand(3, 7))
	Event_Timer(Airborne_TopUpAttacks, t_encounter3_data, World_GetRand(3, 7))
	
	num_villageattacks_completed = 0
	
	-- add more enemies into periphery buildings
	Util_CreateSquads(player2, sg_airborne_periphery_gunners, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, eg_rocherath_surroundedhouse1)
	Util_CreateSquads(player2, sg_airborne_periphery_gunners, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, eg_rocherath_surroundedhouse2)
	Util_CreateSquads(player2, sg_airborne_periphery_gunners, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, eg_rocherath_surroundedhouse3)
	Util_CreateSquads(player2, sg_airborne_periphery_gunners, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, eg_rocherath_surroundedhouse4)
	Util_CreateSquads(player2, sg_airborne_periphery_gunners, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, eg_rocherath_surroundedhouse5)
	Util_CreateSquads(player2, sg_airborne_periphery_gunners, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, eg_rocherath_surroundedhouse6)
	Util_CreateSquads(player2, sg_airborne_periphery_gunners, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, eg_rocherath_surroundedhouse7)
	
	Modify_WeaponDamage(sg_airborne_periphery_gunners, "hardpoint_01", 0.2)
	
	Event_IsDoingAttack(Airborne_StrayedIntoPeriphery, nil, sg_airborne_periphery_gunners, ANY, 3, 1)
	
end




--
-- INTRO
--

function Airborne_Intro()
	
	if g_transition_in_progress == false then
		
		Rule_RemoveMe()
		
		Camera_ClampToMarker(mkr_camera_clamp_airborne1)
		Player_AddAbilityLockoutZone(player1, BP_GetAbilityBlueprint("pm_airborne_paratroopers"), mkr_abilitylockoutzone_airborne)
		Player_AddAbilityLockoutZone(player1, BP_GetAbilityBlueprint("pm_airborne_strafe"), mkr_abilitylockoutzone_airborne)
		Player_AddAbilityLockoutZone(player1, BP_GetAbilityBlueprint("pm_airborne_supply"), mkr_abilitylockoutzone_airborne)
		Player_AddAbilityLockoutZone(player1, BP_GetAbilityBlueprint("pm_airborne_rocket"), mkr_abilitylockoutzone_airborne)
		Player_AddAbilityLockoutZone(player1, BP_GetAbilityBlueprint("pm_airborne_dispatch_pathfinders"), mkr_abilitylockoutzone_airborne)
		
		Objective_Start(OBJ_Airborne)
		Rule_AddOneShot(Airborne_IntroB, 4)
		Rule_AddInterval(Airborne_PlayerWipedOut, 2)
		
	end
	
end
function Airborne_IntroB()

	Util_StartIntel(EVENTS.Airborne_Intro)
	
	Event_NarrativeEventsNotRunning(Airborne_StartReclaimVillageObjective, nil, 5)
	Event_NarrativeEventsNotRunning(Airborne_StartParatroopersObjective, nil, 20)

end



--
-- Manage attacks on the village
--

function Airborne_TopUpAttacks(data)

	if num_villageattacks_completed < 3 then 
		
		if SGroup_TotalMembersCount(data.sgroup) < data.threshold then
			
			-- pick a random top-up from the list
			local rand = World_GetRand(1, #data.topup_choices)
			local choice = data.topup_choices[rand]
			table.remove(data.topup_choices, rand)
			
			-- add the units
			data.encounter:AddUnit(choice.unit)
			
			-- apply the new goal (if there was one)
			if choice.goal_update ~= nil then
				data.encounter:SetGoal(choice.goal_update)
			elseif data.encounter:HasGoal() == false then
				data.encounter:RestartGoal()
			end
			
		end
		
		
		if #data.topup_choices == 0 then
			-- we're done, chalk one up for the good guys
			num_villageattacks_completed = num_villageattacks_completed + 1
		else
			-- run this rule again in a few seconds
			Event_Timer(Airborne_TopUpAttacks, data, World_GetRand(3, 7))
		end
		
	end

end



function Airborne_StrayedIntoPeriphery(data)

	if Objective_IsComplete(OBJ_Airborne) == false then
		
		-- get all squads under attack by the gunners
		SGroup_Clear(sg_airborne_periphery_targets)
		local _CheckSquad = function(gid, idx, sid)
			Squad_GetAttackTargets(sid, sg_airborne_periphery_targets) 
		end
		SGroup_ForEach(sg_airborne_periphery_gunners, _CheckSquad)

		if SGroup_Count(sg_airborne_periphery_targets) >= 1 then
			
			if (World_GetGameTime() - time_last_periphery_callout) >= 20 and Event_IsAnyRunning() == false then
				Util_StartIntel(EVENTS.Airborne_DontGoOutThere)
				time_last_periphery_callout = World_GetGameTime()
			end
			
			Rule_AddOneShot(Airborne_StrayedIntoPeriphery_PartB, 4)
			
		end
		
	end
	
end
function Airborne_StrayedIntoPeriphery_PartB()
	
	-- add any units that have been attacked in the interim
	local _CheckSquad = function(gid, idx, sid)
		Squad_GetAttackTargets(sid, sg_airborne_periphery_targets) 
	end
	SGroup_ForEach(sg_airborne_periphery_gunners, _CheckSquad)
	
	Cmd_Retreat(sg_airborne_periphery_targets)
	
	Event_IsDoingAttack(Airborne_StrayedIntoPeriphery, nil, sg_airborne_periphery_gunners, ANY, 3, 1)

end





	
--
-- PARATROOPERS sub-objective
--

function Airborne_StartParatroopersObjective()
	
	Util_StartIntel(EVENTS.Airborne_CallInParatroopers)
	Event_NarrativeEventsNotRunning(Airborne_StartParatroopersObjective_PartB, nil, 0)
	
end
function Airborne_StartParatroopersObjective_PartB()

	Objective_Start(SOBJ_Airborne_CallInParatroopers)
	
	Rule_AddGlobalEvent(Airborne_PlayerCalledInParatroopers, GE_AbilityExecuted)

end

function Airborne_PlayerCalledInParatroopers(caster, ability, target)

	if caster == player1 and ability == BP_GetAbilityBlueprint("pm_airborne_paratroopers") then
		
		Rule_RemoveMe()
		Rule_AddOneShot(Airborne_ParatroopersEnRoute, 4)
		
	end

end

function Airborne_ParatroopersEnRoute()
	
	Util_StartIntel(EVENTS.Airborne_ParatroopersEnRoute)
	
	Rule_AddInterval(Airborne_ParatroopersOnGround, 0.5)

end

function Airborne_ParatroopersOnGround()

	Player_GetAll(player1)
	SGroup_Filter(sg_allsquads, SBP.AEF.PARATROOPER_SQUAD_MP, FILTER_KEEP)
	
	if Event_IsAnyRunning() == false and SGroup_Count(sg_allsquads) >= 1 and SGroup_HasUpgrade(sg_allsquads, UPG.AEF.ABILITY_LOCK_OUT_PARATROOPERS_LANDED, ANY) then
		
		Rule_RemoveMe()
		
		Objective_Complete(SOBJ_Airborne_CallInParatroopers)
		
		
		Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("pm_airborne_strafe"), ITEM_DEFAULT)
		Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("pm_airborne_supply"), ITEM_DEFAULT)
		Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("pm_airborne_rocket"), ITEM_DEFAULT)
		Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("pm_airborne_paratroopers"), ITEM_DEFAULT)
		
		Rule_AddOneShot(Airborne_ParatroopersOnGround_PartB, 3)
		
	end

end
function Airborne_ParatroopersOnGround_PartB()
	
	Util_StartIntel(EVENTS.Airborne_ParatroopersArrivedNowTakeTheVillage)
	
end



--
-- RECLAIM VILLAGE CENTRE sub-objective
-- 

function Airborne_StartReclaimVillageObjective()
	
	Objective_Start(SOBJ_Airborne_ReclaimVillage)
	
	Rule_AddInterval(Airborne_VillageReclaimed, 0.5)
	
end

function Airborne_VillageReclaimed()

	if Event_IsAnyRunning() == false then
		
		if num_villageattacks_completed >= 3 and (SGroup_Count(sg_airborne_attackers1) + SGroup_Count(sg_airborne_attackers2) + SGroup_Count(sg_airborne_attackers3) == 0)  then
			
			Rule_RemoveMe()
			
			Objective_Complete(SOBJ_Airborne_ReclaimVillage)
			
			Rule_AddOneShot(Airborne_StartRadioAntennaObjective, 1)
			
		end
		
	end

end



--
-- RADIO ANTENNA sub-objective 
-- 

function Airborne_StartRadioAntennaObjective()
	
	Util_StartIntel(EVENTS.Airborne_VillageTakenNowCaptureRadioTower)
	Event_NarrativeEventsNotRunning(Airborne_StartRadioAntennaObjective_PartB, nil, 0)
	
end
function Airborne_StartRadioAntennaObjective_PartB()
	
	-- increase the map to include the radio area
	World_IncreaseInteractionStage()
	Camera_ClampToMarker(mkr_camera_clamp_airborne2)

	BeginnerHint_AddOpportunity(mkr_airborne_coverhint1, HINT_LIGHTCOVER)
	BeginnerHint_AddOpportunity(mkr_airborne_coverhint2, HINT_LIGHTCOVER)
	BeginnerHint_AddOpportunity(mkr_airborne_coverhint3, HINT_LIGHTCOVER)
	BeginnerHint_AddOpportunity(mkr_airborne_coverhint4, HINT_LIGHTCOVER)
	
	-- set up the new area
	enc_Airborne_Forest = ENCOUNTERS.Airborne_ForestDefenders()
	enc_Airborne_Radio = ENCOUNTERS.Airborne_RadioDefenders()
	Event_Proximity(EventHandler_TriggerEncounterGoal, {encounter = enc_Airborne_Forest}, player1, mkr_rocherath_forest_encounterarea, nil, ANY, 6)
	Event_GroupIsDead(Airborne_StartBeaconHint, nil, sg_airborne_forest_defenders, 3)
	
	-- start the objective and the checker rule
	Objective_Start(SOBJ_Airborne_CaptureRadioAntenna)
	Rule_AddInterval(Airborne_RadioAntennaCaptured, 0.5)
	
end

function Airborne_RadioAntennaCaptured()
	
	if Event_IsAnyRunning() == false and Player_OwnsEGroup(player1, eg_point_radiotower) then
		
		Rule_RemoveMe()
		
		Objective_Complete(SOBJ_Airborne_CaptureRadioAntenna)
		Objective_Complete(OBJ_Airborne)
		
		BeginnerHint_RemoveOpportunity(mkr_airborne_coverhint1)
		BeginnerHint_RemoveOpportunity(mkr_airborne_coverhint2)
		BeginnerHint_RemoveOpportunity(mkr_airborne_coverhint3)
		BeginnerHint_RemoveOpportunity(mkr_airborne_coverhint4)
	
		Rule_AddOneShot(Airborne_Outro, 3)
		
	end
	
end





--
-- BEACON hint
--

function Airborne_StartBeaconHint()
	
	-- make sure the player hasn't built a beacon already
	Player_GetAll(player1)
	if EGroup_ContainsBlueprints(eg_allentities, EBP.AEF.AIRBORNE_BEACON_MP, ANY) == false then
		
		hpid_airborne_beacon = HintPoint_Add(mkr_airborne_beacon_hint, true, 11076598, nil, nil, UI_GetAbilityIconName(ABILITY.AEF.PATHFINDER_PLANT_BEACON))	-- LOCDB [11076598] 'Use Pathfinders to build a beacon here'
		
		Rule_AddInterval(Airborne_ClearBeaconHint, 0.5)
		
	end
	
end
function Airborne_ClearBeaconHint()

	Player_GetAll(player1)
	EGroup_FilterUnderConstruction(eg_allentities, FILTER_REMOVE)
	EGroup_Filter(eg_allentities, EBP.AEF.AIRBORNE_BEACON_MP, FILTER_KEEP)
	
	if Objective_IsComplete(SOBJ_Airborne_CaptureRadioAntenna) or EGroup_Count(eg_allentities) >= 1 then
		
		Rule_RemoveMe()
		
		HintPoint_Remove(hpid_airborne_beacon)
		
		if  EGroup_Count(eg_allentities) >= 1 then
			
			EGroup_AddEGroup(eg_airborne_beacon, eg_allentities)
			Event_Timer(Airborne_AddSecondBeaconHint, nil, 1)
			
		end
		
	end

end
function Airborne_AddSecondBeaconHint()

	hpid_airborne_beacon2 = HintPoint_Add(Util_GetPosition(eg_airborne_beacon), true, 11083635, 4)				-- LOCDB [11083635] 'Paratroopers can land more accurately and reinforce next to a Beacon'
	Event_Timer(EventHandler_RemoveHint, {hint = hpid_airborne_beacon2}, 8)

end





function Airborne_PlayerWipedOut()

	if Objective_IsComplete(SOBJ_Airborne_CaptureRadioAntenna) then
		
		Rule_RemoveMe()
		
	else
		
		Player_GetAll(player1)
		SGroup_RemoveGroup(sg_allsquads, sg_jackson)
		
		if SGroup_Count(sg_allsquads) == 0 and Event_IsAnyRunning() == false then
			
			-- player is overrun
			if Objective_IsStarted(SOBJ_Airborne_ReclaimVillage) and Objective_IsComplete(SOBJ_Airborne_ReclaimVillage) == false then
				Objective_Fail(SOBJ_Airborne_ReclaimVillage)
			end
			if Objective_IsStarted(SOBJ_Airborne_CaptureRadioAntenna) then
				Objective_Fail(SOBJ_Airborne_CaptureRadioAntenna)
			end
			
			Util_StartIntel(EVENTS.Airborne_Failed)
			Rule_AddDelayedInterval(Mission_Fail, 2, 1)
			
			Rule_RemoveMe()
			
		end
	
	end
	
end





--
-- OUTRO
-- 

function Airborne_Outro()

	-- now Jackson gets on the radio and calls for assistance
	Util_StartIntel(EVENTS.Airborne_Outro)
	
	Event_NarrativeEventsNotRunning(Airborne_OutroB, nil)

end

function Airborne_OutroB()
	
	-- start the mechanzied section
	Mechanized_Init()
	Mechanized_Start()

end




--
-- CLEANUP
-- 

-- called during the intro section of the next division - can remove any units no longer needed here
function Airborne_Cleanup()
	
	-- swap everyone to airborne player (p5)
	Player_GetAll(player1)
	SGroup_SetPlayerOwner(sg_allsquads, player5)
	
	
	
	Camera_Unclamp()
	
	
	
	
	
	
end

