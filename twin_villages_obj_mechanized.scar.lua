print("\tLoading ObjAirborne file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- TWIN VILLAGES
-- Objective File - MECHANIZED SECTION (now know as INFANTRY)
-- Designer: NJR
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- Sub-objectives:
--    * Reach the allies at the village
--    * Protect your allies' evacuation to the base in Krinkelt


-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_ObjMechanized()

	print("Initializing ObjMechanized...")
	
	-- Pre-condition:		Kicked off by previous objective
	-- Success condition:	
	-- Failure condition:	None
	-- Post-condition:
	--		Success:		
	--		Failure:		N/A
	OBJ_Mechanized = {
		
		--Info
		Title = 11076599,	-- LOCDB [11076599] 'Rescue Jackson's unit from Rocherath'
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
	-- Success condition:	Player unlocks the BAR weapons rack
	SOBJ_Mechanized_UnlockBARWeaponsRack = {
		Title = 11076600,	-- LOCDB [11076600] 'Unlock the BAR Weapon Rack and equip your infantry'
		Type = OT_Primary,						
		Parent = OBJ_Mechanized,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() 
			hpid_mechanized_weaponsrack = Objective_AddUIElements(SOBJ_Mechanized_UnlockBARWeaponsRack, eg_hq, true, 11076601, true, 1)	-- LOCDB [11076601] 'Unlock the BAR Weapon Rack from the HQ'
		end,
		PreStart = function()
			flashid_mechanized_weaponsrack = UI_FlashProductionButton(PITEM_Upgrade, UPG.AEF.WEAPON_RACK_UPGRADE_MP, true)
		end,
		OnStart = nil,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = function()
		end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_Mechanized.subObjectives, SOBJ_Mechanized_UnlockBARWeaponsRack) -- Don't forget to add them to their parent!
	

	-- Pre-condition:		After player has equipped BARs
	-- Success condition:	
	SOBJ_Mechanized_ReachVillage = {
		Title = 11076602,	-- LOCDB [11076602] 'Rendezvous at the edge of the village'
		Type = OT_Primary,						
		Parent = OBJ_Mechanized,				
		showTitle = false,
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() 
			hpid_mechanized_village = Objective_AddUIElements(SOBJ_Mechanized_ReachVillage, mkr_mechanized_village_rendezvous, true, 11076603, true)	-- LOCDB [11076603] 'Reach the allies in Rocherath'
		end,
		PreStart = function()
		end,
		OnStart = nil,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = function()
			
			Objective_RemoveUIElements(SOBJ_Mechanized_ReachVillage, hpid_mechanized_village)
			
		end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_Mechanized.subObjectives, SOBJ_Mechanized_ReachVillage) -- Don't forget to add them to their parent!
	
	
	-- Pre-condition:		None - populates with the parent objective
	-- Success condition:	
	SOBJ_Mechanized_EvacuateAllies = {
		Title = 11076604,	-- LOCDB [11076604] 'Protect the evacuation corridor as your allies return to the base'
		Type = OT_Primary,						
		Parent = OBJ_Mechanized,				
		showTitle = false,
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() 

			hpid_mechanized_evacuateping = Objective_AddUIElements(SOBJ_Mechanized_EvacuateAllies, mkr_mechanized_evacuateping, true)
			hpid_mechanized_evacuatearrow1 = MapIcon_CreateArrow(mkr_mechanized_evacuatearrow1a, mkr_mechanized_evacuatearrow1b, 255, 225, 0, 0)
			hpid_mechanized_evacuatearrow2 = MapIcon_CreateArrow(mkr_mechanized_evacuatearrow2a, mkr_mechanized_evacuatearrow2b, 255, 225, 0, 0)
			
		end,
		PreStart = function()
		end,
		OnStart = nil,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = function()
			
			Objective_RemoveUIElements(SOBJ_Mechanized_EvacuateAllies, hpid_mechanized_evacuateping)
			MapIcon_Destroy(hpid_mechanized_evacuatearrow1)
			MapIcon_Destroy(hpid_mechanized_evacuatearrow2)
			
		end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_Mechanized.subObjectives, SOBJ_Mechanized_EvacuateAllies) -- Don't forget to add them to their parent!
	
	
	
	t_list_infantry = {
		SBP.AEF.ASSAULT_ENGINEER_SQUAD_MP,
		SBP.AEF.CAPTAIN_SQUAD_MP,
		SBP.AEF.LIEUTENANT_SQUAD_MP,
		SBP.AEF.M1919A4_HMG_SQUAD_MP,
		SBP.AEF.M1_81MM_MORTAR_SQUAD_MP,
		SBP.AEF.MAJOR_SQUAD_MP,
		SBP.AEF.REAR_ECHELON_SQUAD_MP,
		SBP.AEF.RIFLEMEN_SQUAD_MP,
	}
	t_list_tanks = {
		SBP.AEF.DODGE_WC51_AMBULANCE_SQUAD_MP,
		SBP.AEF.M3_HALFTRACK_SQUAD_MP,
		SBP.AEF.DODGE_WC51_50CAL_SQUAD_MP,
		SBP.AEF.M15A1_AA_HALFTRACK_SQUAD_MP,
		SBP.AEF.M5A1_STUART_SQUAD_MP,
		SBP.AEF.M4A3_SHERMAN_SQUAD_MP,
		SBP.AEF.M8A1_HMC_SQUAD_MP,
		SBP.AEF.M10_TANK_DESTROYER_SQUAD_MP,
	}
	
end
Scar_AddInit(INIT_ObjMechanized)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------


function Mechanized_Init()
	
	
end


function Mechanized_Start()
	
	-- switch over to the airborne commander
	Mission_SwitchCommander(CD_MECHANIZED, false, mkr_camera_mechanized_start)
	
	-- this switch takes two seconds... screen is black at 0.75 second in
	Player_SetUpgradeAvailability(player1, UPG.AEF.WEAPON_RACK_UPGRADE_MP, ITEM_LOCKED)
	Rule_AddOneShot(Mechanized_StartB, 0.8)				-- switch player ownerships when screen is black
	Rule_AddDelayedInterval(Mechanized_Intro, 1, 1)		-- after the switch, start the intro for this section
	
end
function Mechanized_StartB()
	
	-- cleanup from the previous section
	Airborne_Cleanup()
	for group_index = 0, 9 do
		Misc_ClearControlGroup(group_index)
	end
	Misc_ClearSelection()
	
	-- set name to the division we are 
	Setup_SetPlayerName(player1, locid_mechanized_division)
	Setup_SetPlayerName(player3, locid_mechanized_division)
	
	-- add in new map section
	World_IncreaseInteractionStage()
	
	-- set retreat point for this section
	EGroup_DestroyAllEntities(eg_retreatpoint)
	Util_CreateEntities(player1, eg_retreatpoint, BP_GetEntityBlueprint("sp_retreat_point"), mkr_retreatpoint_mechanized, 1)
	
	-- make the base buildings available to the player again (and unlock the items within them)
	EGroup_SetPlayerOwner(eg_basebuildings, player1)
	Mission_SetProductionItems(ITEM_DEFAULT)
	Player_SetUpgradeAvailability(player1, UPG.AEF.WEAPON_RACK_UPGRADE_MP, ITEM_LOCKED)
	
	--
	-- ALLIED UNITS
	--
	
	-- switch out any p1 units
	EGroup_Clear(eg_temp)
	World_GetStrategyPoints(eg_temp, true)
	
	Player_GetAll(player1)
	SGroup_SetPlayerOwner(sg_allsquads, player5)
	EGroup_Filter(eg_allentities, t_buildable_objects, FILTER_KEEP)
	EGroup_SetPlayerOwner(eg_allentities, player5)
	
	if SGroup_Count(sg_jackson) == 0 then
		Util_CreateSquads(player5, sg_blah, SBP.AEF.PATHFINDER_SQUAD_MP, mkr_rocherath)
		Util_CreateSquads(player5, sg_blah, SBP.AEF.PATHFINDER_SQUAD_MP, mkr_rocherath)
		Util_CreateSquads(player5, sg_blah, SBP.AEF.PARATROOPER_SQUAD_MP, mkr_rocherath, nil, nil, nil, nil, nil, UPG.AEF.ABILITY_LOCK_OUT_PARATROOPERS_LANDED)
		
		Util_CreateSquads(player5, sg_blah, SBP.AEF.PATHFINDER_SQUAD_MP, mkr_rocherath)
		Util_CreateSquads(player5, sg_blah, SBP.AEF.PATHFINDER_SQUAD_MP, mkr_rocherath)
		Util_CreateSquads(player5, sg_blah, SBP.AEF.PARATROOPER_SQUAD_MP, mkr_rocherath, nil, nil, nil, nil, nil, UPG.AEF.ABILITY_LOCK_OUT_PARATROOPERS_LANDED)
		Util_CreateSquads(player5, sg_jackson, SBP.AEF.JACKSON_SQUAD, mkr_mechanized_evacuees2_meetup)
		
	end
	
	-- split the airborne survivors into two evacuee groups
	Player_GetAll(player5)
	SGroup_Clear(sg_temp)
	SGroup_RemoveGroup(sg_allsquads, sg_jackson)
	SGroup_WarpToPos(sg_jackson, Util_GetPosition(mkr_mechanized_evacuees2_meetup))
	
	SGroup_Filter(sg_allsquads, SBP.AEF.PARATROOPER_SQUAD_MP, FILTER_REMOVE, sg_temp)	-- separate all the paratroopers into sg_temp, add one to group 1 and then split the rest between groups 1 and 2
	
	-- split any paratroopers between groups 1 and 2
	local _SplitSquads = function(group)
	
		for num = SGroup_Count(group), 1, -1 do
			
			local sid = SGroup_GetSpawnedSquadAt(group, num)
			SGroup_Remove(group, sid)
			
			if math.mod(num, 2) == 0 then
				
				SGroup_Add(sg_mechanized_evacuees_stage1, sid)
				
				if Squad_IsInHoldEntity(sid) == true then
					SGroup_Single(sg_single, sid)
					Cmd_UngarrisonSquad(sg_single, Util_GetPosition(mkr_mechanized_evacuees1_warp))
				else
					Squad_WarpToPos(sid, Util_GetPosition(mkr_mechanized_evacuees1_warp))
				end
				
			else
				
				SGroup_Add(sg_mechanized_evacuees_stage2, sid)
				
				if Squad_IsInHoldEntity(sid) == true then
					SGroup_Single(sg_single, sid)
					Cmd_UngarrisonSquad(sg_single, Util_GetPosition(mkr_mechanized_evacuees2_warp))
				else
					Squad_WarpToPos(sid, Util_GetPosition(mkr_mechanized_evacuees2_warp))
				end
				
			end
			
		end
		
	end
	
	_SplitSquads(sg_temp)
	_SplitSquads(sg_allsquads)
	
	Util_CreateSquads(player5, sg_mechanized_evacuees_stage1, SBP.AEF.PARATROOPER_SQUAD_MP, mkr_jackson_aides)	-- add another paratrooper to group 1
	
	
	
	Player_GetAll(player5)
	SGroup_EnableUIDecorator(sg_jackson, true) 
	
	-- give evacuees some defensive bonuses
	Modify_ReceivedDamage(sg_mechanized_evacuees_stage1, 0.6)
	Modify_ReceivedDamage(sg_mechanized_evacuees_stage2, 0.6)
	
	
	-- create new allies who occupy checkpoint delta, and move up with you at the support location
	enc_Mechanized_SentryDefenders1 = ENCOUNTERS.Mechanized_SentryDefenders1()
	enc_Mechanized_ForwardSentryDefenders1 = ENCOUNTERS.Mechanized_ForwardSentryDefenders1() 	
	enc_Mechanized_ForwardSentryDefenders2 = ENCOUNTERS.Mechanized_ForwardSentryDefenders2() 	
	Util_CreateSquads(player4, sg_mechanized_sentrydefenders2_extra1, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_mechanized_sentryspawn3, nil, 1, 3)
	Util_CreateSquads(player4, sg_mechanized_sentrydefenders2_extra2, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_mechanized_sentryspawn4, nil, 1, 4)
	Util_CreateSquads(player4, sg_mechanized_sentrydefenders2_extra3, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_mechanized_sentryspawn5, nil, 1, 3)
	Event_Proximity(Mechanized_MoveSupportUnitsForward, {encounter = enc_Mechanized_ForwardSentryDefenders1, sgroup = sg_mechanized_sentrydefenders2_extra1}, player1, sg_mechanized_sentrydefenders2_extra1, 10, ANY, 2)
	Event_Proximity(Mechanized_MoveSupportUnitsForward, {encounter = enc_Mechanized_ForwardSentryDefenders2, sgroup = sg_mechanized_sentrydefenders2_extra2}, player1, sg_mechanized_sentrydefenders2_extra2, 10, ANY, 1)
	Event_Proximity(Mechanized_MoveSupportUnitsForward, {encounter = enc_Mechanized_ForwardSentryDefenders2, sgroup = sg_mechanized_sentrydefenders2_extra3}, player1, sg_mechanized_sentrydefenders2_extra3, 10, ANY, 0)

	Event_Timer(Mechanized_TopUpSupportUnits, {encounter = enc_Mechanized_ForwardSentryDefenders1, threshold = 3}, World_GetRand(15, 25))
	Event_Timer(Mechanized_TopUpSupportUnits, {encounter = enc_Mechanized_ForwardSentryDefenders2, threshold = 3}, World_GetRand(15, 25))
	
	--
	-- PLAYER UNITS
	--
	Util_CreateSquads(player1, sg_blah, SBP.AEF.M10_TANK_DESTROYER_SQUAD_MP, mkr_rescue_tankspawn1, mkr_rescue_tankdest1)	-- tanks
	Util_CreateSquads(player1, sg_blah, SBP.AEF.M5A1_STUART_SQUAD_MP, mkr_rescue_tankspawn2, mkr_rescue_tankdest2)
	Util_CreateSquads(player1, sg_blah, SBP.AEF.M5A1_STUART_SQUAD_MP, mkr_rescue_tankspawn3, mkr_rescue_tankdest3)
	
	Util_CreateSquads(player1, sg_blah, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_mechanized_riflemenspawn, mkr_rescue_riflemendest1)		-- infantry
	Util_CreateSquads(player1, sg_blah, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_mechanized_riflemenspawn, mkr_rescue_riflemendest2)
	Util_CreateSquads(player1, sg_blah, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_mechanized_riflemenspawn, mkr_rescue_riflemendest3)
	
	
	--
	-- ENEMY UNITS
	--
	enc_MechanizedAttackers1 = ENCOUNTERS.Mechanized_Attackers1()
	enc_MechanizedAttackers2 = ENCOUNTERS.Mechanized_Attackers2()
	enc_MechanizedAttackers3 = ENCOUNTERS.Mechanized_Attackers3()
	Event_Timer(Mechanized_TopUpEnemy_Attackers, {encounter = enc_MechanizedAttackers1, topup_amount = 2}, 17)
	Event_Timer(Mechanized_TopUpEnemy_Attackers, {encounter = enc_MechanizedAttackers2, topup_amount = 2}, 27)
	Event_Timer(Mechanized_TopUpEnemy_Attackers, {encounter = enc_MechanizedAttackers3, topup_amount = 2}, 37)

	
	-- specific enemy units that sit still until under attack
	Util_CreateSquads(player2, sg_mechanized_static1, SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP, mkr_mechanized_infantryspawn7)
	Event_IsUnderAttack(Mechanized_AddSGroupToEncounter, {sgroup = sg_mechanized_static1, encounter = enc_MechanizedAttackers2}, sg_mechanized_static1, ANY, 3, player1, 6)
	
	Util_CreateSquads(player2, sg_mechanized_static2, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, mkr_mechanized_infantryspawn3)
	Event_IsUnderAttack(Mechanized_AddSGroupToEncounter, {sgroup = sg_mechanized_static2, encounter = enc_MechanizedAttackers1}, sg_mechanized_static2, ANY, 3, player1, 7)
	
	Util_CreateSquads(player2, sg_mechanized_static3, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, mkr_mechanized_infantryspawn8)
	Event_IsUnderAttack(Mechanized_AddSGroupToEncounter, {sgroup = sg_mechanized_static3, encounter = enc_MechanizedAttackers3}, sg_mechanized_static3, ANY, 3, player1, 5)
	
	Util_CreateSquads(player2, sg_mechanized_static4, SBP.GERMAN.PANZER_IV_SQUAD_MP, mkr_mechanized_additionalspawn1)
	SGroup_SetAvgHealth(sg_mechanized_static4, 0.65)
	Event_CreateOR(Mechanized_AddSGroupToEncounter, {sgroup = sg_mechanized_static4, encounter = enc_MechanizedAttackers2}, {
		Event_IsUnderAttack(__DoNothing, nil, sg_mechanized_static4, ANY, 3, player1, 1),
		Event_IsUnderAttack(__DoNothing, nil, sg_mechanized_static1, ANY, 3, player1, 1),
	})
	Event_PlayerCanSeeElement(EventHandler_StartIntel, {intel = EVENTS.Mechanized_PanzerIVSpotted}, player1, sg_mechanized_static4, ANY, 2)
	
	-- hint that the base is available again
	hpid_mechanized_base = HintPoint_Add(mkr_playerBase_target, true, 11076605, 2)	-- LOCDB [11076605] 'Base buildings are now available for you to order units from'
	Event_IsSelected(EventHandler_RemoveHint, {hint = hpid_mechanized_base}, eg_basebuildings, ANY, 2)
	
	BeginnerHint_TeamWeapons()
	
end










--
-- INTRO
--

function Mechanized_Intro()
	
	if g_transition_in_progress == false then
		
		Rule_RemoveMe()
		
		SGroup_FaceMarker(sg_jackson, mkr_mechanized_evacuees1_meetup)
		Camera_ClampToMarker(mkr_camera_clamp_mechanized1)
		
		Util_StartIntel(EVENTS.Mechanized_Intro)
		Event_NarrativeEventsNotRunning(Mechanized_BuildWeaponsRack_Start, nil, 1)
		
		
	end
	
end







--
-- Get player to build BAR weapons rack
--
function Mechanized_BuildWeaponsRack_Start()
	
	Util_StartIntel(EVENTS.Mechanized_WeaponsRack)
	
	Rule_AddInterval(Mechanized_BuildWeaponsRack_Start_PartB, 0.5)
	
end
function Mechanized_BuildWeaponsRack_Start_PartB()

	if Event_IsAnyRunning() == false then
		
		Objective_Start(OBJ_Mechanized, false)
		Objective_Start(SOBJ_Mechanized_UnlockBARWeaponsRack)
		Player_SetUpgradeAvailability(player1, UPG.AEF.WEAPON_RACK_UPGRADE_MP, ITEM_DEFAULT)	
		
		Rule_AddDelayedInterval(Mechanized_BuildWeaponsRack_InProgress, 2, 0.5)
		
		Rule_RemoveMe()
		
	end
	
end

function Mechanized_BuildWeaponsRack_InProgress()
	
	if hpid_mechanized_weaponsrack ~= nil and EGroup_IsProducingItem(eg_hq, UPG.AEF.WEAPON_RACK_UPGRADE_MP, PITEM_Upgrade, ANY) then
		
		Rule_RemoveMe()
		
		Event_Timer(EventHandler_StartIntel, {intel = EVENTS.Mechanized_WeaponsRack_InProgress}, 1)
		Event_Timer(EventHandler_RemoveObjectiveUI, {objective = SOBJ_Mechanized_UnlockBARWeaponsRack, element = hpid_mechanized_weaponsrack}, 2)
		
		Rule_AddDelayedInterval(Mechanized_BuildWeaponsRack_Done, 2, 0.5)

	end
	
end

function Mechanized_BuildWeaponsRack_Done()
	
	if Event_IsAnyRunning() == false then
		
		if  Player_HasUpgrade(player1, UPG.AEF.WEAPON_RACK_UPGRADE_MP) then
			
			Rule_RemoveMe()
			
			Event_Timer(EventHandler_StartIntel, {intel = EVENTS.Mechanized_WeaponsRack_Done}, 1)

			Rule_AddOneShot(Mechanized_EquipFromWeaponsRack, 2.5)
			
		end
		
	end
	
end

--
-- ...and equip an infantry unit with a BAR
--

function Mechanized_EquipFromWeaponsRack()

	hpid_mechanized_weaponsrack_equip = Objective_AddUIElements(SOBJ_Mechanized_UnlockBARWeaponsRack, eg_weaponsrack_bar, true, 11076606, true, 1)	-- LOCDB [11076606] 'Collect BARs from this weapons rack'
	
	Rule_AddDelayedInterval(Mechanized_EquipFromWeaponsRack_Done, 2, 0.5)

end
function Mechanized_EquipFromWeaponsRack_Done()
	
	if Event_IsAnyRunning() == false then
		
		Player_GetAll(player1)
		SGroup_Filter(sg_allsquads, SBP.AEF.LIEUTENANT_SQUAD_MP, FILTER_REMOVE)
		
		if SGroup_HasSlotItem(sg_allsquads, SLOT_ITEM.RIFLEMEN_M1918_BAR_MP, ANY) then
			
			Rule_RemoveMe()
			
			Event_Timer(EventHandler_ObjectiveComplete, {objective = SOBJ_Mechanized_UnlockBARWeaponsRack, showTitle = false}, 1)
			Event_Timer(EventHandler_StartIntel, {intel = EVENTS.Mechanized_WeaponsRack_BARPickedUp}, 2.5)
			
			Rule_AddDelayedInterval(Mechanized_StartReachVillageObjective, 3, 0.5)

		end
		
	end
	
end




















--
-- REACH VILLAGE sub-objective
--

function Mechanized_StartReachVillageObjective()
	
--~ 	Objective_Start(OBJ_Mechanized)
	
	if Event_IsAnyRunning() == false then
	
		Rule_RemoveMe()
		
		-- add in new map section
	 	World_IncreaseInteractionStage()
		Camera_Unclamp()
		
		-- start the objective
		Objective_Start(SOBJ_Mechanized_ReachVillage)
		
		flag_combinedarms_triggered = false
		Rule_AddGlobalEvent(Mechanized_PlayerTriggeredCombinedArms, GE_AbilityExecuted)
		Rule_AddInterval(Mechanized_VillageReached, 1)
		Event_PlayerCanSeeElement(Mechanized_GetSightLinesFromSupport, nil, player1, sg_mechanized_sentrydefenders1, ANY, 1)
		
		Rule_AddInterval(Mechanized_CheckPlayerIsOutOfTanksOrInfantry, 5)

	end
	
end



-- as you drive by the support guys at checkpoint delta, they share their LOS.
function Mechanized_GetSightLinesFromSupport()
	
	-- start the speech that leads to the shared LOS
	Util_StartIntel(EVENTS.Mechanized_GetSightLinesFromSupport)
	Event_Timer(Mechanized_GetSightLinesFromSupport_PartB, nil, 4)
	
	-- but also activate the enemy encounters at this point (so they arrive sort of the right time)
	enc_MechanizedAttackers1:TriggerGoal()
	enc_MechanizedAttackers2:TriggerGoal()
	enc_MechanizedAttackers3:TriggerGoal()
	
end
function Mechanized_GetSightLinesFromSupport_PartB()

	-- share LOS with the Support division
	World_EnableSharedLineOfSight(player1, player4, true)
	World_EnableSharedLineOfSight(player3, player4, true)
	
	Rule_AddDelayedInterval(Mechanized_MentionCombinedArms, 20, 4)
	
end




-- add extra units to the enemy attack if the size of the attack drops too low (runs on each attacker encounter)
function Mechanized_TopUpEnemy_Attackers(data)
	
	if Objective_IsComplete(OBJ_Mechanized) == false and Objective_IsFailed(OBJ_Mechanized) == false  then
		
		local sgroup = data.encounter:GetSgroup()
		
		if SGroup_Count(sgroup) < data.topup_amount then
			
			local unit = {
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, load = World_GetRand(2, 4),
			}
			data.encounter:AddUnit(unit)
			
			if data.encounter:HasGoal() == false then
				data.encounter:RestartGoal()
			end
			
		end
		
		Event_Timer(Mechanized_TopUpEnemy_Attackers, data, World_GetRand(30, 40))
		
	end
	
end




-- make the support units push forwards when the player gets near them
function Mechanized_MoveSupportUnitsForward(data)
	
	data.encounter:AddSgroup(data.sgroup)

	if data.encounter:HasGoal() == false then
		data.encounter:RestartGoal()
	end
	
end

function Mechanized_TopUpSupportUnits(data)

	if Objective_IsComplete(OBJ_Mechanized) == false and Objective_IsFailed(OBJ_Mechanized) == false then
		
		local sgroup = data.encounter:GetSgroup()
		
		if SGroup_TotalMembersCount(sgroup) <= data.threshold then
			
			local unit = {
				sbp = SBP.AEF.RIFLEMEN_SQUAD_MP,
			}
			data.encounter:AddUnit(unit)
			
			if data.encounter:HasGoal() == false then
				data.encounter:RestartGoal()
			end
			
		end
		
		Event_Timer(Mechanized_TopUpSupportUnits, data, World_GetRand(15, 25))
		
	end
	
end





function Mechanized_AddSGroupToEncounter(data)

	data.encounter:AddSgroup(data.sgroup)
	
	if data.encounter:HasGoal() == false then
		data.encounter:RestartGoal()
	end

end



-- make a note if the player has used the combined arms ability
function Mechanized_PlayerTriggeredCombinedArms(caster, ability, target)

	if caster == player1 and ability == BP_GetAbilityBlueprint("pm_american_combined_arms") then
		flag_combinedarms_triggered = true
		Rule_RemoveMe()
	end
	
end


function Mechanized_MentionCombinedArms()

	if flag_combinedarms_triggered == true then
		
		Rule_RemoveMe()
		
	elseif Event_IsAnyRunning() == false and Player_CanCastAbilityOnPlayer(player1, BP_GetAbilityBlueprint("pm_american_combined_arms"), player1) == true then
		
		Player_GetAll(player1)
		if SGroup_IsUnderAttack(sg_allsquads, ANY, 4) == true then
			
			Rule_RemoveMe()
			
			Util_StartIntel(EVENTS.Mechanized_MentionCombinedArms)
			UI_FlashAbilityButton(BP_GetAbilityBlueprint("pm_american_combined_arms"), true)
			
			Rule_AddInterval(Mechanized_MentionCombinedArms_PartB, 0.5)
			
		end
		
	end
	
end
function Mechanized_MentionCombinedArms_PartB()

	if flag_combinedarms_triggered == true then
		
		Rule_RemoveMe()
		Util_StartIntel(EVENTS.Mechanized_CombinedArmsTriggered)
		
	end

end



function Mechanized_CheckPlayerIsOutOfTanksOrInfantry()

	if Objective_IsComplete(SOBJ_Mechanized_EvacuateAllies) or Objective_IsFailed(SOBJ_Mechanized_EvacuateAllies) then
		
		Rule_RemoveMe()
		
	elseif Event_IsAnyRunning() == false then
		
		SGroup_Clear(sg_temp)
		
		Player_GetAll(player1)
		SGroup_Filter(sg_allsquads, t_list_infantry, FILTER_KEEP, sg_temp)
		SGroup_Filter(sg_temp, t_list_tanks, FILTER_KEEP)
		
		if SGroup_Count(sg_allsquads) == 0 then
			
			Util_StartIntel(EVENTS.Mechanized_OutOfInfantry)
			Rule_ChangeInterval(Mechanized_CheckPlayerIsOutOfTanksOrInfantry, 45)
			
		elseif SGroup_Count(sg_temp) == 0 then
			
			--Util_StartIntel(EVENTS.Mechanized_OutOfTanks)
			--Rule_ChangeInterval(Mechanized_CheckPlayerIsOutOfTanksOrInfantry, 45)

		else
			
			Rule_ChangeInterval(Mechanized_CheckPlayerIsOutOfTanksOrInfantry, 5)
			
		end
		
	end
end














function Mechanized_VillageReached()

	if Prox_ArePlayersNearMarker(player1, mkr_mechanized_village_rendezvous, ANY, 15) then
		
		Rule_RemoveMe()
		
		Objective_Complete(SOBJ_Mechanized_ReachVillage, false)
		Util_StartIntel(EVENTS.Mechanized_ArrivedAtVillage)
		
		Cmd_Move(sg_mechanized_evacuees_stage1, mkr_mechanized_evacuees1_meetup)
		Cmd_Move(sg_mechanized_evacuees_stage2, mkr_mechanized_evacuees2_meetup)
		
		Rule_AddOneShot(Mechanized_VillageReached_PartB, 4)
		
	end
	
end
function Mechanized_VillageReached_PartB()

	World_EnableSharedLineOfSight(player1, player5, true)
	World_EnableSharedLineOfSight(player3, player5, true)
	World_EnableSharedLineOfSight(player4, player5, true)
	
	
	-- share LOS with the Support division
	World_EnableSharedLineOfSight(player1, player5, true)
	World_EnableSharedLineOfSight(player3, player5, true)
	World_EnableSharedLineOfSight(player4, player5, true)
	
	Event_NarrativeEventsNotRunning(Mechanized_StartEscapeObjective, nil, 1)
	
end



--
-- ESCAPE sub-objective
--

function Mechanized_StartEscapeObjective()
	
	Objective_Start(SOBJ_Mechanized_EvacuateAllies)
	Rule_AddDelayedInterval(Mechanized_EvacuateStage_Retreat_Ensure, 5, 1)
	Util_StartIntel(EVENTS.Mechanized_StartEvacuation_Stage1)
	Event_NarrativeEventsNotRunning(Mechanized_EvacuateStage1_Start, nil, 0)
	SGroup_SetInvulnerable(sg_jackson, 0.5)
	Modify_ReceivedSuppression(sg_jackson, 0)
	if SGroup_IsAlive(sg_jackson_aides) then
		SGroup_SetInvulnerable(sg_jackson_aides, 0.75)
		Modify_ReceivedSuppression(sg_jackson_aides, 0)
	end
end

function Mechanized_EvacuateStage_Retreat_Ensure()

	if SGroup_IsAlive(sg_mechanized_evacuees_sent) == true then
	
		Cmd_Move(sg_mechanized_evacuees_sent, mkr_playerBase_target, true)
	end
end

function Mechanized_EvacuateStage1_Start()

	Rule_AddInterval(Mechanized_EvacuateStage1_SendOneGuy, 1)

end

function Mechanized_EvacuateStage1_SendOneGuy()
	
	if SGroup_Count(sg_mechanized_evacuees_stage1) == 0 then
		
		Rule_RemoveMe()
		Rule_AddOneShot(Mechanized_EvacuateStage2_Start, 20)
		
	else
		
		-- pick a random guy from the evacuees
		local squad = SGroup_GetRandomSpawnedSquad(sg_mechanized_evacuees_stage1)
		SGroup_Remove(sg_mechanized_evacuees_stage1, squad)
		SGroup_Single(sg_temp, squad)
		HintPoint_Add(squad, true, 11076607)	-- LOCDB [11076607] 'Evacuee'
		
		-- send him off on the escape route
		SGroup_SetInvulnerable(sg_temp, false)
		SGroup_SetAutoTargetting(sg_temp, "hardpoint_01", false)
		Cmd_UngarrisonSquad(sg_temp)
		Cmd_Move(sg_temp, mkr_playerBase_target, true)
		
		SGroup_Add(sg_mechanized_evacuees_sent, squad) 
		
		Rule_ChangeInterval(Mechanized_EvacuateStage1_SendOneGuy, World_GetRand(3, 5))
		
	end
	
end


function Mechanized_EvacuateStage2_Start()

	Util_StartIntel(EVENTS.Mechanized_StartEvacuation_Stage2)
	Event_NarrativeEventsNotRunning(Mechanized_EvacuateStage2_StartB, nil, 0)
	
end
function Mechanized_EvacuateStage2_StartB()

	Rule_AddInterval(Mechanized_EvacuateStage2_SendOneGuy, 1)
	
end

function Mechanized_EvacuateStage2_SendOneGuy()
	
	if SGroup_Count(sg_mechanized_evacuees_stage2) == 0 then
		
		Rule_RemoveMe()
		
		-- send jackson behind everyone else
		Cmd_Move(sg_jackson, mkr_mechanized_jacksoncapturezone)
		Rule_AddInterval(JacksonPreAmbushMove, 1)
		hpid_jackson = HintPoint_Add(sg_jackson, true, 11076608)	-- LOCDB [11076608] 'Jackson'
		
		Mechanized_StartJacksonAmbush()
		Event_Proximity(Mechanized_CaptureJackson, nil, sg_jackson, mkr_mechanized_jacksoncapturezone, nil, ANY)
		
		Rule_AddInterval(Mechanized_EvacuationComplete, 2)
		
	else
		
		-- pick a random guy from the evacuees
		local squad = SGroup_GetRandomSpawnedSquad(sg_mechanized_evacuees_stage2)
		SGroup_Remove(sg_mechanized_evacuees_stage2, squad)
		SGroup_Single(sg_temp, squad)
		HintPoint_Add(squad, true, 11076607)	-- LOCDB [11076607] 'Evacuee'
		
		-- send him off on the escape route
		SGroup_SetInvulnerable(sg_temp, false)
		SGroup_SetAutoTargetting(sg_temp, "hardpoint_01", false)
		Cmd_UngarrisonSquad(sg_temp)
		Cmd_Move(sg_temp, mkr_playerBase_target, true)
		
		SGroup_Add(sg_mechanized_evacuees_sent, squad) 
		
		if SGroup_Count(sg_mechanized_evacuees_stage2) == 0 then
			Rule_ChangeInterval(Mechanized_EvacuateStage2_SendOneGuy, 10)	-- this last run will be for Jackson
			Event_Timer(EventHandler_StartIntel, {intel = EVENTS.Mechanized_StartEvacuation_Jackson}, 4)
		else
			Rule_ChangeInterval(Mechanized_EvacuateStage2_SendOneGuy, World_GetRand(3, 5))
		end
		
	end
	
	
end


function JacksonPreAmbushMove()

	if g_jacksonAmbushed == false then
		Cmd_Move(sg_jackson, mkr_mechanized_jacksoncapturezone)
	elseif g_jacksonAmbushed then
	
		Rule_RemoveMe()
	end
end

--
-- AMBUSH during ESCAPE sub-objective
--
function Mechanized_StartJacksonAmbush()

	local t_encounterarea1_ambush_units = {
		{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
		{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
		{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
		{sbp = SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP},
	}
	local t_encounterarea2_ambush_units = {
		{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
		{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
		{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
		{sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP},
	}
	local t_encounterarea3_ambush_units = {
		{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
		{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
		{sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP},
		{sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP},
	}
	
	for index, unit in pairs(t_encounterarea1_ambush_units) do 
		enc_MechanizedAttackers1:AddUnit(unit)
	end
	for index, unit in pairs(t_encounterarea2_ambush_units) do 
		enc_MechanizedAttackers2:AddUnit(unit)
	end
	for index, unit in pairs(t_encounterarea3_ambush_units) do 
		enc_MechanizedAttackers3:AddUnit(unit)
	end
	
	-- restart goals if necessary
	if enc_MechanizedAttackers1:HasGoal() == false then
		enc_MechanizedAttackers1:RestartGoal()
	end
	if enc_MechanizedAttackers2:HasGoal() == false then
		enc_MechanizedAttackers2:RestartGoal()
	end
	if enc_MechanizedAttackers3:HasGoal() == false then
		enc_MechanizedAttackers3:RestartGoal()
	end
	
	
	Util_CreateSquads(player2, sg_mechanized_jacksonkillers, SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP, mkr_mechanized_additionalspawn1, mkr_mechanized_jacksonambush_dest1)
	Util_CreateSquads(player2, sg_mechanized_jacksonkillers, SBP.GERMAN.PANZER_IV_SQUAD_MP, mkr_mechanized_additionalspawn2, mkr_mechanized_jacksonambush_dest2)

	Util_CreateSquads(player2, sg_mechanized_jacksonkillers, SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP, mkr_mechanized_additionalspawn4, mkr_mechanized_jacksonambush_dest4)
	Util_CreateSquads(player2, sg_mechanized_jacksonkillers, SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP, mkr_mechanized_additionalspawn5, mkr_mechanized_jacksonambush_dest5)


--	Util_CreateSquads(player2, sg_mechanized_jacksonkillers, SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP, mkr_jackson_attackers, mkr_jackson_attackers_dest)
--	Util_CreateSquads(player2, sg_mechanized_jacksonkillers, SBP.GERMAN.PANZER_IV_SQUAD_MP,  mkr_jackson_attackers, mkr_jackson_attackers_dest)

	

end




--
-- Jackson's capture scene
--
function Mechanized_CaptureJackson()
	g_jacksonAmbushed = true
	-- call out the ambush
	Util_StartIntel(EVENTS.Mechanized_JacksonCapture_Part1)
	Rule_AddOneShot(Mechanized_CaptureJackson_PartB, 3)

end	
function Mechanized_CaptureJackson_PartB()

	--SGroup_SetMoodMode(sg_jackson, MM_ForceCalm)

	-- get all the units near jackson, split into tanks and infantry
	Player_GetAllSquadsNearMarker(player1, sg_temp, mkr_mechanized_jacksoncapturezone, 25)
	SGroup_Filter(sg_temp, t_list_infantry, FILTER_KEEP, sg_mechanized_jacksonkillertargets)
	
	-- concentrate fire on the remaining tanks
	Cmd_Attack(sg_mechanized_jacksonkillers, sg_mechanized_jacksonkillertargets)
	Modify_ReceivedAccuracy(sg_mechanized_jacksonkillertargets, 2.5)
	Modify_ReceivedDamage(sg_mechanized_jacksonkillertargets, 2.5)
	
	-- retreat player infantry in the area
	Cmd_Retreat(sg_temp)
	
	Rule_AddInterval(Mechanized_CaptureJackson_PartC, 1)
	
end
function Mechanized_CaptureJackson_PartC()

	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		
		HintPoint_Remove(hpid_jackson)
		Util_CreateSquads(player2, sg_mechanized_jacksonattackers, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, mkr_jackson_attackers, mkr_jackson_attackers_dest3)
		Util_CreateSquads(player2, sg_mechanized_jacksonattackers, SBP.GERMAN.PANZER_IV_SQUAD_MP,  mkr_jackson_attackers, mkr_jackson_attackers_dest1)
		Util_CreateSquads(player2, sg_mechanized_jacksonattackers, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  mkr_jackson_attackers, mkr_jackson_attackers_dest2)
		Util_CreateSquads(player2, sg_mechanized_jacksonattackers, SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,  mkr_jackson_attackers, mkr_jackson_attackers_dest4)
		SGroup_SetInvulnerable(sg_mechanized_jacksonattackers, 0.75)
		Modify_WeaponAccuracy(sg_mechanized_jacksonattackers, "hardpoint_01", 1.25)
		Modify_WeaponDamage(sg_mechanized_jacksonattackers, "hardpoint_01", 1.25)
		
		-- surrender sequence
		Rule_AddOneShot(Mechanized_CaptureJackson_PartD, 2)		-- surrender
		Rule_AddOneShot(Mechanized_CaptureJackson_PartE, 5)		-- move out
		Rule_AddOneShot(Mechanized_CaptureJackson_PartF, 10)	-- fade into the FOW
		
	end
	
end
function Mechanized_CaptureJackson_PartD()

	SGroup_SetSelectable(sg_jackson, false)
	Util_StartIntel(EVENTS.Mechanized_JacksonCapture_Part2)
	
end
function Mechanized_CaptureJackson_PartE()

	Cmd_MoveToAndDespawn(sg_jackson, mkr_jackson_retreat)
	Rule_AddDelayedInterval(Mechanized_DespawnJackson, 1, 1)
	
end

function Mechanized_CaptureJackson_PartF()

	SGroup_SetPlayerOwner(sg_jackson, player6)	
	
	-- FOW to not be revealed around Jackson
	World_EnableSharedLineOfSight(player6, player1, false)
--~ 	World_EnableSharedLineOfSight(player5, player1, true)
--~ 	World_EnableSharedLineOfSight(player4, player1, true)
--~ 	World_EnableSharedLineOfSight(player3, player1, true)
--~ 	World_EnableSharedLineOfSight(player1, player5, true)
--~ 	World_EnableSharedLineOfSight(player1, player4, true)
--~ 	World_EnableSharedLineOfSight(player1, player3, true)

end

function Mechanized_DespawnJackson()

	if SGroup_Count(sg_jackson) == 0 then
		
		Rule_RemoveMe()
		
	else
	
		if Player_CanSeeSGroup(player1, sg_jackson, ANY) == false then
		
			SGroup_DestroyAllSquads(sg_jackson)
			Rule_RemoveMe()
		
		end
		
	end
end

function Mechanized_EvacuationComplete()
	
	if SGroup_Count(sg_mechanized_evacuees_sent) == 0 then
		
		Rule_RemoveMe()
		Objective_Fail(SOBJ_Mechanized_EvacuateAllies)
		
		Util_StartIntel(EVENTS.Mechanized_EvacuationFailed)
		Rule_AddDelayedInterval(Mission_Fail, 2, 1)
		
	elseif Prox_AreSquadsNearMarker(sg_mechanized_evacuees_sent, mkr_evacuees_safezone, ALL) then
		
		Rule_RemoveMe()
		
		if SGroup_Count(sg_mechanized_evacuees_sent) >= 2 then
			
			-- can have different speech according to how many people escape
			
		else
			
			
			
		end
		
		Objective_Complete(SOBJ_Mechanized_EvacuateAllies)
		Objective_Complete(OBJ_Mechanized)
		
		Rule_AddOneShot(Mechanized_Outro, 3)
		
	end
	
end



--
-- OUTRO
-- 

function Mechanized_Outro()

	Util_StartIntel(EVENTS.Mechanized_Outro)
	Util_StartIntel(EVENTS.Mission_Outro)
	
	Event_NarrativeEventsNotRunning(Mechanized_OutroB, nil, 2)

end

function Mechanized_OutroB()
	
	Rule_AddInterval(Mission_Complete, 1)
	
	-- have the attack intensify, and the commanders argue about holding or falling back
	-- they decide to fall back, and we trigger a staggered retreat. Then, fade to black.
	
end


