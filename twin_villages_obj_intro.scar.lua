print("\tLoading ObjIntro file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- TWIN VILLAGES
-- Objective File - INTRO SECTION
-- Designer: NJR
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Sub-objectives:
--    Build infantry
--    Unlock the BAR weapons rack
--    Equip soldiers with BARs
--    Move to location


-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_ObjIntro()

	print("Initializing ObjIntro...")
	
	-- Pre-condition:		None - Objective populates on mission start
	-- Success condition:	All sub-objectives tasks are completed
	-- Failure condition:	None
	-- Post-condition:
	--		Success:		Start Support section
	--		Failure:		N/A
	OBJ_Intro = {
		--Info
		Title = 11076574,	-- LOCDB [11076574] 'Prepare for Sentry Duty'
--~ 		TitleEnd = LOC("Objective Complete"),
--~ 		TitleFail = LOC("Objective Failed"),
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
		IsComplete = function()
--~ 			if Objective_IsComplete(SOBJ_Intro_MoveToLocation) then
--~ 				return true
--~ 			end
		end,
		PreComplete = nil,
		OnComplete = function()
--~ 			Event_Timer(Support_Start, nil, 5)
		end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	
	
	
	
	-- Pre-condition:		None - populates with the parent objective
	-- Success condition:	Player builds some infantry units
	SOBJ_Intro_BuildUnits = {
		Title = 11076575,	-- LOCDB [11076575] 'Request two Rear Echelon infantry units'
		Type = OT_Primary,						
		Parent = OBJ_Intro,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() 
			hpid_intro_buildunits = Objective_AddUIElements(SOBJ_Intro_BuildUnits, eg_hq, true, 11076576, true, 1)		-- LOCDB [11076576] 'Order two Rear Echelon infantry units from the HQ'
		end,
		PreStart = function()
			flashid_intro_buildunits = UI_FlashProductionButton(PITEM_Spawn, SBP.AEF.REAR_ECHELON_SQUAD_MP, true)
		end,
		OnStart = function()
		end,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = function()
		end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_Intro.subObjectives, SOBJ_Intro_BuildUnits) -- Don't forget to add them to their parent!
	
	
	-- Pre-condition:		None - populates with the parent objective
	-- Success condition:	Player unlocks the BAR weapons rack
	SOBJ_Intro_UnlockBARWeaponsRack = {
		Title = 11076577,	-- LOCDB [11076577] 'Unlock the BAR Weapon Rack and equip your units'
		Type = OT_Primary,						
		Parent = OBJ_Intro,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() 
			hpid_intro_weaponsrack = Objective_AddUIElements(SOBJ_Intro_UnlockBARWeaponsRack, eg_hq, true, 11076578, true, 1)	-- LOCDB [11076578] 'Unlock the BAR Weapon Rack from the HQ'
		end,
		PreStart = function()
			Player_SetUpgradeAvailability(player1, UPG.AEF.WEAPON_RACK_UPGRADE_MP, ITEM_DEFAULT)
			flashid_intro_weaponsrack = UI_FlashProductionButton(PITEM_Upgrade, UPG.AEF.WEAPON_RACK_UPGRADE_MP, true)
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
	table.insert(OBJ_Intro.subObjectives, SOBJ_Intro_UnlockBARWeaponsRack) -- Don't forget to add them to their parent!
	
	


	
	
	
end
Scar_AddInit(INIT_ObjIntro)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!






-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------

function Intro_Start()

	-- start off the sequence that drop guys at the base
	Intro_TruckDropoff_Part1()
	
	-- set the retreat point for this section
	Util_CreateEntities(player1, eg_retreatpoint, BP_GetEntityBlueprint("sp_retreat_point"), mkr_retreatpoint_support, 1)
	
	-- remove any accidentally created majors, etc
	Player_GetAll(player1)
	SGroup_Filter(sg_allsquads, {SBP.AEF.CAPTAIN_SQUAD_MP, SBP.AEF.LIEUTENANT_SQUAD_MP, SBP.AEF.MAJOR_SQUAD_MP}, FILTER_KEEP)
	SGroup_DestroyAllSquads(sg_allsquads)
	
	-- lock out most base production
	Mission_SetProductionItems(ITEM_LOCKED)
	
	Util_StartIntel(EVENTS.Intro_SupportDivisionIntro)
	Event_NarrativeEventsNotRunning(Intro_StartB, nil, 1)
	
end
function Intro_StartB()

	Objective_Start(OBJ_Intro)
	Event_NarrativeEventsNotRunning(Intro_StartC, nil, 1)

end
	
function Intro_StartC()

	Event_NarrativeEventsNotRunning(Intro_BuildUnits_Start, nil, 2)
--~ 	Event_NarrativeEventsNotRunning(EventHandler_ObjectiveStart, {objective = SOBJ_Support_MoveToLocation, showTitle = true}, 2)
	
end








function Intro_TruckDropoff_Part1()

	-- first truck drives straight through
	Util_CreateSquads(player1, sg_intro_truck1, SBP.AEF.M3_HALFTRACK_SQUAD_MP, mkr_intro_truck1_spawn)
	Cmd_SquadPath(sg_intro_truck1, "path_intro_truck1_through", true, LOOP_NONE, false, 0, mkr_intro_truckleave)
	
	-- second truck drops guys off
	Util_CreateSquads(player1, sg_intro_truck2, SBP.AEF.M3_HALFTRACK_SQUAD_MP, mkr_intro_truck2_spawn)
	Cmd_SquadPath(sg_intro_truck2, "path_intro_truck2_in", true, LOOP_NONE, false, 0)
	Util_CreateSquads(player1, sg_intro_rifleman1, SBP.AEF.RIFLEMEN_SQUAD_MP, sg_intro_truck2, nil, 1)
	Util_CreateSquads(player1, sg_intro_rifleman2, SBP.AEF.RIFLEMEN_SQUAD_MP, sg_intro_truck2, nil, 1)
	
	-- trucks are non-selectable
	SGroup_SetSelectable(sg_intro_truck1, false)
	SGroup_SetSelectable(sg_intro_truck2, false)
	SGroup_SetSelectable(sg_intro_rifleman1, false)
	SGroup_SetSelectable(sg_intro_rifleman2, false)
	SGroup_EnableUIDecorator(sg_intro_truck1, false)
	SGroup_EnableUIDecorator(sg_intro_truck2, false)
	SGroup_EnableUIDecorator(sg_intro_rifleman1, false)
	SGroup_EnableUIDecorator(sg_intro_rifleman2, false)

	Event_Proximity(Intro_TruckDropoff_Part2, nil, sg_intro_truck2, mkr_intro_truck2_dropoff, 3, ANY, 4)

	Modify_ReceivedDamage(sg_intro_rifleman1, 0.8)
	Modify_ReceivedDamage(sg_intro_rifleman2, 0.8)
	
end

function Intro_TruckDropoff_Part2()

	Cmd_EjectOccupants(sg_intro_truck2)
	
	Event_Timer(Intro_TruckDropoff_Part3, nil, 3)
	Event_Timer(Intro_TruckDropoff_Part4, nil, 4)
	Event_Timer(Intro_TruckDropoff_Part5, nil, 6)
	
end

function Intro_TruckDropoff_Part3()
	Cmd_Move(sg_intro_rifleman1, mkr_intro_baserally1)
	SGroup_SetSelectable(sg_intro_rifleman1, true)
	SGroup_EnableUIDecorator(sg_intro_rifleman1, true)
end
function Intro_TruckDropoff_Part4()
	Cmd_Move(sg_intro_rifleman2, mkr_intro_baserally2)
	SGroup_SetSelectable(sg_intro_rifleman2, true)
	SGroup_EnableUIDecorator(sg_intro_rifleman2, true)
end
function Intro_TruckDropoff_Part5()
	Cmd_SquadPath(sg_intro_truck2, "path_intro_truck2_out", true, LOOP_NONE, false, 0, mkr_intro_truckleave)
end







--
-- Get player to build some rear echelon
--
function Intro_BuildUnits_Start()
	
	Event_Timer(EventHandler_StartIntel, {intel = EVENTS.Intro_BuildUnits}, 2)
	Rule_AddDelayedInterval(Intro_BuildUnits_DelayedStart, 2, 1)
	
end

function Intro_BuildUnits_DelayedStart()

	if Event_IsAnyRunning() == false then
		
		Objective_Start(SOBJ_Intro_BuildUnits)
		Player_SetSquadProductionAvailability(player1, SBP.AEF.REAR_ECHELON_SQUAD_MP, ITEM_DEFAULT)	
		Rule_AddDelayedInterval(Intro_BuildUnits_InProgress, 2, 0.5)
		Rule_RemoveMe()
		
		-- add something to check the player knows how to select / build units
		IntroHints_BuildRearEchelon_PlayerHelp()
		
	end
	
end

function Intro_BuildUnits_InProgress()
	
	-- count the RE on the map
	Player_GetAll(player1)
	SGroup_Filter(sg_allsquads, SBP.AEF.REAR_ECHELON_SQUAD_MP, FILTER_KEEP)
	local on_map = SGroup_CountSpawned(sg_allsquads)
	
	-- count the RE in the production queue
	local on_order = 0
	if EGroup_Count(eg_hq) >= 1 then
		
		local eid = EGroup_GetSpawnedEntityAt(eg_hq, 1)
		
		if Entity_HasProductionQueue(eid) then
			
			for index = 0, (Entity_GetProductionQueueSize(eid) - 1) do
				
				local production_item = Entity_GetProductionQueueItem(eid, index)
				local production_type = Entity_GetProductionQueueItemType(eid, index)
				
				if production_type == PITEM_Spawn and production_item == SBP.AEF.REAR_ECHELON_SQUAD_MP then
					on_order = on_order + 1
				end
				
			end
			
		end
		
	end
	
	-- if that's the two we need...
	if (on_map + on_order) >= 2 then
		
		Rule_RemoveMe()
		
		flag_playerHasOrderedUnits = true
		
		Event_Timer(EventHandler_StartIntel, {intel = EVENTS.Intro_BuildUnits_InProgress}, 1)
		Event_Timer(EventHandler_RemoveObjectiveUI, {objective = SOBJ_Intro_BuildUnits, element = hpid_intro_buildunits}, 2)
		
		Rule_AddDelayedInterval(Intro_BuildUnits_Done, 2, 0.5)

	end
	
end

function Intro_BuildUnits_Done()
	
	if Event_IsAnyRunning() == false then
		
		Player_GetAll(player1)
		SGroup_Filter(sg_allsquads, SBP.AEF.REAR_ECHELON_SQUAD_MP, FILTER_KEEP)
		
		if SGroup_Count(sg_allsquads) >= 2 then
			
			Rule_RemoveMe()
			
			Event_Timer(EventHandler_ObjectiveComplete, {objective = SOBJ_Intro_BuildUnits, showTitle = false}, 1)
			Event_Timer(EventHandler_StartIntel, {intel = EVENTS.Intro_BuildUnits_Done}, 2.5)
			
			Rule_AddDelayedInterval(Intro_Done, 3, 0.5)
			Player_SetSquadProductionAvailability(player1, SBP.AEF.RIFLEMEN_SQUAD_MP, ITEM_DEFAULT)	
			Player_SetSquadProductionAvailability(player1, SBP.AEF.DODGE_WC51_AMBULANCE_SQUAD_MP, ITEM_DEFAULT)	
		end
		
	end
	
end











function Intro_Done()

	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		
		Objective_Complete(OBJ_Intro)
		
		Event_Timer(EventHandler_ObjectiveStart, {objective = OBJ_Support, showTitle = true}, 3)
		Event_Timer(EventHandler_ObjectiveStart, {objective = SOBJ_Support_MoveToLocation, showTitle = false}, 2)
		
	end
	
end















-- group wrapper functions

function EGroup_IsProducingItem(egroup, item, ptype, all)
	
	local _CheckEntity = function(gid, idx, eid)
		
		if Entity_HasProductionQueue(eid) then
			
			for index = 0, (Entity_GetProductionQueueSize(eid) - 1) do
				
				local production_item = Entity_GetProductionQueueItem(eid, index)
				local production_type = Entity_GetProductionQueueItemType(eid, index)
				
				if production_type == ptype and production_item == item then
					return true
				end
				
			end
			
		end
		
	end
	
	return EGroup_ForEachAllOrAny(egroup, all, _CheckEntity)
	
end


function SGroup_HasSlotItem(sgroup, slotitem, all)

	local _CheckSquad = function(gid, idx, sid)
		return Squad_HasSlotItem(sid, slotitem)
	end
	return SGroup_ForEachAllOrAny(sgroup, all, _CheckSquad)
	
end








--
-- TUTORIALS
--

-- walk the player through the BuildRearEchelon stage if necessary
function IntroHints_BuildRearEchelon_PlayerHelp()

	if g_difficulty <= GD_NORMAL then
		
		flag_playerHasSelectedABuilding = false
		flag_playerHasOrderedUnits = false			-- Note: this is set to true in the Intro_BuildUnits_InProgress() function
		
		Rule_AddInterval(IntroHints_BuildRearEchelon_BuildingSelected, 0.5)
		Rule_AddOneShot(IntroHints_BuildRearEchelon_ShowSelectHelp, 30)
		
	end
	
end
function IntroHints_BuildRearEchelon_BuildingSelected()
	if Misc_IsEGroupSelected(eg_hq, ANY) == true then
		flag_playerHasSelectedABuilding = true
		Rule_RemoveMe()
	end
end



function IntroHints_BuildRearEchelon_ShowSelectHelp()
	if flag_playerHasOrderedUnits ~= true then
		
		if Misc_IsEGroupSelected(eg_hq, ANY) == false then
			Camera_MoveTo(eg_hq, true, 0.1, false, true)
			titleid_selectHQ = UI_NewHUDFeature(HUDF_None, 11083622, "Icons_tooltips_tooltip_miniclick", 999999999)			-- LOCDB [11083622] 'Left-click on the Barracks to select it'
			Rule_AddInterval(IntroHints_BuildRearEchelon_ShowSelectHelp_PartB, 0.5)
		else
			IntroHints_BuildRearEchelon_ShowOrderHelp()
		end
		
	end
end
function IntroHints_BuildRearEchelon_ShowSelectHelp_PartB()
	if Misc_IsEGroupSelected(eg_hq, ANY) == true then
		UI_TitleDestroy(titleid_selectHQ)
		Rule_AddOneShot(IntroHints_BuildRearEchelon_ShowOrderHelp, 1)
		Rule_RemoveMe()
	end
end



function IntroHints_BuildRearEchelon_ShowOrderHelp()
	if flag_playerHasOrderedUnits ~= true then
		
		if Misc_IsEGroupSelected(eg_hq, ANY) == true then
			titleid_orderUnits = UI_NewHUDFeature(HUDF_CommandCard, 11083623, "Icons_units_unit_aef_rear_echelon_troops", 999999999)			-- LOCDB [11083623] 'In the command panel (bottom right), click on the Rear Echelon button twice to call in two squads'
			Rule_AddInterval(IntroHints_BuildRearEchelon_ShowOrderHelp_PartB, 0.5)
		else
			IntroHints_BuildRearEchelon_ShowSelectHelp()
		end
		
	end
end
function IntroHints_BuildRearEchelon_ShowOrderHelp_PartB()
	if flag_playerHasOrderedUnits == true or Misc_IsEGroupSelected(eg_hq, ANY) == false then
	
		UI_TitleDestroy(titleid_orderUnits)
		Rule_RemoveMe()
		
		if Misc_IsEGroupSelected(eg_hq, ANY) == false then
			Rule_AddOneShot(IntroHints_BuildRearEchelon_ShowSelectHelp, 1)
		end
		
	end	
end













--
-- CLEANUP
-- 

-- called during the intro section of the next division - can remove any units no longer needed here
function Intro_Cleanup()



end

