print("\tLoading ObjSupport file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- TWIN VILLAGES
-- Objective File - SUPPORT SECTION
-- Designer: NJR
-------------------------------------------------------------------------
-------------------------------------------------------------------------



-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_ObjSupport()

	print("Initializing ObjSupport...")
	
	-- Pre-condition:		Kicked off by previous objective
	-- Success condition:	All sub-objectives tasks are completed
	-- Failure condition:	None
	-- Post-condition:
	--		Success:		Start Airborne section
	--		Failure:		N/A
	OBJ_Support = {
		--Info
		Title = 11076580,	-- LOCDB [11076580] 'Sentry Duty'
--~ 		TitleEnd = LOC("Objective Complete"),
--~ 		TitleFail = LOC("Objective Failed"),
		Type = OT_Primary,
		Parent = nil,
		subObjectives = {},
		
		--Intel
		Intel_Start = 				nil,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			EVENTS.Support_AttackFinished,
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
		OnComplete = function()
			Event_Timer(Airborne_Start, nil, 4)
		end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	
	
	
	
	-- Pre-condition:		None - populates with the parent objective
	-- Success condition:	Player units arrive at the first sentry location
	SOBJ_Support_MoveToLocation = {
		Title = 11076581,	-- LOCDB [11076581] 'Rendezvous at Checkpoint Fox'
		Type = OT_Primary,						
		Parent = OBJ_Support,				
		showTitle = false,
		
		Intel_Start = 				EVENTS.Intro_MoveOutToSentryLocation,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() 
			Objective_AddUIElements(SOBJ_Support_MoveToLocation, mkr_sentry1_destination, true, 11076582, true)	-- LOCDB [11076582] 'Checkpoint Fox'
		end,
		PreStart = nil,
		OnStart = function()
			World_IncreaseInteractionStage()
			Event_Proximity(EventHandler_StartIntel, {intel = EVENTS.Intro_MoveOutToSentryLocationFollowUp}, player1, mkr_sentry1_destination, 70, ANY, 0)
			SupportHints_MoveToLocation_PlayerHelp()
			SupportHints_Garrison_PlayerHelp()
		end,
		IsComplete = function()
			if Prox_ArePlayersNearMarker(player1, mkr_sentry1_destination, ANY) then
				return true
			end
		end,
		PreComplete = nil,
		OnComplete = function()
			Event_Timer(Support_Start, nil, 5)
		end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_Support.subObjectives, SOBJ_Support_MoveToLocation) -- Don't forget to add them to their parent!
	
	
	-- Pre-condition:		Populates after the handoff
	-- Success condition:	Player builds a fighting position
	SOBJ_Support_BuildFiringPosition = {
		Title = 11076583,	-- LOCDB [11076583] 'Construct a firing position'
		Type = OT_Primary,						
		Parent = OBJ_Support,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() 
			hpid_support_fightposition = Objective_AddUIElements(SOBJ_Support_BuildFiringPosition, mkr_support_fightingposition_location, true, 11076584, true, 0.5)	-- LOCDB [11076584] 'Use your Rear Echelon to build a fighting position here'
		end,
		PreStart = function()
			flashid_support_fightposition1 = UI_FlashConstructionMenu("basic_infantry", true)
			flashid_support_fightposition2 = UI_FlashConstructionButton(EBP.AEF.FIGHTING_POSITION_MP, true)
		end,
		OnStart = function()
				Player_SetEntityProductionAvailability(player1, EBP.AEF.FIGHTING_POSITION_MP, ITEM_DEFAULT)
			end,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_Support.subObjectives, SOBJ_Support_BuildFiringPosition) -- Don't forget to add them to their parent!


	-- Pre-condition:		Populates after the player has built a firing position
	-- Success condition:	N/A
	SOBJ_Support_BuildTankTraps = {
		Title = 11076585,	-- LOCDB [11076585] 'Construct tank traps'
		Type = OT_Primary,						
		Parent = OBJ_Support,				
		showTitle = false,
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() 
			hpid_support_tanktrap = Objective_AddUIElements(SOBJ_Support_BuildTankTraps, mkr_support_tanktrap_location, true, 11076586, true)	-- LOCDB [11076586] 'Use your Rear Echelon to build tank traps here'
		end,
		PreStart = function()
			flashid_support_tanktrap1 = UI_FlashConstructionMenu("basic_infantry", true)
			flashid_support_tanktrap2 = UI_FlashConstructionButton(EBP.AEF.AEF_TANK_TRAP_MP, true)
		end,
		OnStart = function()
		end,
		IsComplete = function()
		end,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_Support.subObjectives, SOBJ_Support_BuildTankTraps) -- Don't forget to add them to their parent!

	
	-- Pre-condition:		Populates during the attack
	-- Success condition:	Player triggers the defensive artillery ability
	SOBJ_Support_UseDefensiveArtillery = {
		Title = 11076587,	-- LOCDB [11076587] 'Call in 105mm Off-map Artillery'
		Type = OT_Primary,						
		Parent = OBJ_Support,				
		showTitle = false,
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function()
			hpid_support_callinartillery = Objective_AddUIElements(SOBJ_Support_UseDefensiveArtillery, mkr_sentry1_encounterarea, true, 11082892, true)	-- LOCDB [11082892] 'Call in artillery at this location'
		end,
		PreStart = nil,
		OnStart = function()
		end,
		IsComplete = function()
		end,
		PreComplete = nil,
		OnComplete = function()
			Objective_RemoveUIElements(SOBJ_Support_UseDefensiveArtillery, hpid_support_callinartillery)
		end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = function()
			Objective_RemoveUIElements(SOBJ_Support_UseDefensiveArtillery, hpid_support_callinartillery)
		end,
	}
	table.insert(OBJ_Support.subObjectives, SOBJ_Support_UseDefensiveArtillery) -- Don't forget to add them to their parent!
	
	
	-- Pre-condition:		Populates as the attack starts
	-- Success condition:	Player kills all the enemy units
	SOBJ_Support_DefendCheckpoint = {
		Title = 11076588,	-- LOCDB [11076588] 'Defend Checkpoint Fox'
		Type = OT_Primary,						
		Parent = OBJ_Support,				
		showTitle = false,
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() 
			Objective_AddUIElements(SOBJ_Support_DefendCheckpoint, mkr_sentry1_destination, true)
		end,
		PreStart = nil,
		OnStart = function()
		end,
		IsComplete = function()
		end,
		PreComplete = nil,
		OnComplete = function()
			Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("pm_man_the_defenses"), ITEM_DEFAULT)
			Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("assault_engineer_call_in"), ITEM_DEFAULT)
			Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("pm_artillery_support_105mm"), ITEM_DEFAULT)
			Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("pm_artillery_support_anti_tank"), ITEM_DEFAULT)
		end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_Support.subObjectives, SOBJ_Support_DefendCheckpoint) -- Don't forget to add them to their parent!
	
	
	

	
	-- initialise the objective
	Rule_AddOneShot(Support_Init, 5)
	
end
Scar_AddInit(INIT_ObjSupport)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------

-- do some prep work so this is ready to go when the player arrives in the area
function Support_Init()

	-- create the allied squads that you take over sentry duty from
	Util_CreateSquads(player5, sg_jackson, SBP.AEF.JACKSON_SQUAD, eg_sentry1_watchtower)
	Util_CreateSquads(player5, sg_jackson_squad1, SBP.AEF.PATHFINDER_SQUAD_MP, mkr_sentry1_spawn1)
	Util_CreateSquads(player5, sg_jackson_squad2, SBP.AEF.PATHFINDER_SQUAD_MP, mkr_sentry1_spawn2)
	SGroup_AddGroup(sg_jackson_all, sg_jackson)
	SGroup_AddGroup(sg_jackson_all, sg_jackson_squad1)
	SGroup_AddGroup(sg_jackson_all, sg_jackson_squad2)

	SGroup_SetInvulnerable(sg_jackson_all, true)
	SGroup_SetMoodMode(sg_jackson, MM_ForceCalm)
	SGroup_IncreaseVeterancyRank(sg_jackson, 3, true)
	
	-- add some abilities to respective players that will get used later on in this script
	Player_AddAbility(player2, ABILITY.GLOBAL.OFF_MAP_ARTILLERY)

end




function Support_Start()

	Support_HandOff()

end

-- handing off duty between the guys who were here before and the player squads
function Support_HandOff()
	
	Util_StartIntel(EVENTS.Support_ShiftChange)
	
	-- get everyone out of the bunkers (so you can get in them)
	Cmd_EjectOccupants(eg_sentry1_watchtower, mkr_sentry1_dest3)
	Cmd_Move(sg_jackson_squad1, mkr_sentry1_dest1)
	Cmd_Move(sg_jackson_squad2, mkr_sentry1_dest2)
	
	Event_NarrativeEventsNotRunning(Support_HandOff_PartB, nil, 1)
	
end
function Support_HandOff_PartB()

	-- send Jackson and his men off back to Rocherath
	Cmd_Move(sg_jackson, mkr_sentry1_dest1)
	Event_Proximity(Support_HandOff_PartC, nil, sg_jackson, mkr_sentry1_dest1, 5, ANY, 4)
	
	Rule_AddOneShot(Support_ConstructFightingPosition, 4)

end
function Support_HandOff_PartC()
	
	Cmd_Move(sg_jackson_all, mkr_support_aliiesheadhome, nil, mkr_support_aliiesheadhome)

end






-- 
-- Get the player to build a fighting position
--

function Support_ConstructFightingPosition()

	
	Event_Timer(EventHandler_StartIntel, {intel = EVENTS.Support_BuildFightingPosition}, 2)
	Rule_AddDelayedInterval(Support_ConstructFightingPosition_WaitAfterEvent, 3, 1)

end

function Support_ConstructFightingPosition_WaitAfterEvent()

	if Event_IsAnyRunning() == false then
		Objective_Start(SOBJ_Support_BuildFiringPosition)
		Player_GetAll(player1)
		EGroup_Filter(eg_allentities, EBP.AEF.FIGHTING_POSITION_MP, FILTER_KEEP)
		EGroup_AddEGroup(eg_support_alreadybuiltfightingpositions, eg_allentities)
		
		Rule_AddDelayedInterval(Support_ConstructFightingPosition_InProgress, 2, 0.5)
		Rule_AddDelayedInterval(Support_ConstructFightingPosition_BuildingAlready, 3, 0.5)
		Rule_RemoveMe()
	end
end


function Support_ConstructFightingPosition_BuildingAlready()
	if Player_HasBuildingUnderConstruction(player1, {EBP.AEF.FIGHTING_POSITION_MP}) then

		if flashid_support_fightposition1 ~= nil then
			UI_StopFlashing(flashid_support_fightposition1)
		end
		if flashid_support_fightposition2 ~= nil then
			UI_StopFlashing(flashid_support_fightposition2)
		end
		Rule_RemoveMe()		
	end
end

function Support_ConstructFightingPosition_InProgress()

	if Event_IsAnyRunning() == false then
	
		Player_GetAll(player1)
		EGroup_Filter(eg_allentities, EBP.AEF.FIGHTING_POSITION_MP, FILTER_KEEP)
		EGroup_FilterUnderConstruction(eg_allentities, FILTER_KEEP)
		EGroup_RemoveGroup(eg_allentities, eg_support_alreadybuiltfightingpositions)
		
		if EGroup_Count(eg_allentities) >= 1 then
			
			local location_delta = Util_GetDistance(mkr_support_fightingposition_location, EGroup_GetSpawnedEntityAt(eg_allentities, 1))
			local direction_delta = Util_GetDistance(Marker_GetDirection(mkr_support_fightingposition_location), Entity_GetHeading(EGroup_GetSpawnedEntityAt(eg_allentities, 1)))
			
			if location_delta >= 6 then
				
				-- wrong location!
				
				Event_Timer(EventHandler_StartIntel, {intel = EVENTS.Support_BuildFightingPosition_WrongPosition}, 1)
				
				Rule_RemoveMe()
				Rule_AddOneShot(Support_ConstructFightingPosition_YouAreDoingItWrong, 2)
				Rule_AddDelayedInterval(Support_ConstructFightingPosition_InProgress, 2, 0.5)
				
			elseif direction_delta > 0.55 then
			
				-- facing the wrong way!
				
				Event_Timer(EventHandler_StartIntel, {intel = EVENTS.Support_BuildFightingPosition_WrongDirection}, 1)
				if hpid_support_direction == nil then
					hpid_support_direction = Objective_AddUIElements(SOBJ_Support_BuildFiringPosition, mkr_treeline, true, 11078037, true) -- LOCDB [11078037] 'Face the building in this direction'
				end
				
				Rule_RemoveMe()
				Rule_AddOneShot(Support_ConstructFightingPosition_YouAreDoingItWrong, 2)
				Rule_AddDelayedInterval(Support_ConstructFightingPosition_InProgress, 2, 0.5)
				
			else
				
				-- location is close enough, and facing is +/- 30 degrees from what we want
				
				
				
				if hpid_support_direction ~= nil then
					Objective_RemoveUIElements(SOBJ_Support_BuildFiringPosition, hpid_support_direction)
				end
				if flashid_support_fightposition1 ~= nil then
					UI_StopFlashing(flashid_support_fightposition1)
				end
				if flashid_support_fightposition2 ~= nil then
					UI_StopFlashing(flashid_support_fightposition2)
				end
				
				Event_Timer(EventHandler_RemoveObjectiveUI, {objective = SOBJ_Support_BuildFiringPosition, element = hpid_support_fightposition}, 2)
				Rule_AddInterval(Support_ConstructFightingPosition_Done, 0.5)
				
				Rule_RemoveMe()
				
			end
			
		end
	
	end
	
end

function Support_ConstructFightingPosition_YouAreDoingItWrong()

	-- if the player was building the fighting position in the wrong place or direction, remove it and get them to do it again
	Player_GetAll(player1)
	EGroup_Filter(eg_allentities, EBP.AEF.FIGHTING_POSITION_MP, FILTER_KEEP)
	EGroup_FilterUnderConstruction(eg_allentities, FILTER_KEEP)
	EGroup_RemoveGroup(eg_allentities, eg_support_alreadybuiltfightingpositions)
	EGroup_DestroyAllEntities(eg_allentities)
	
	-- refund the player's money
	Player_AddResource(player1, RT_Manpower, 125)
	
end

function Support_ConstructFightingPosition_Done()

	Player_GetAll(player1)
	EGroup_Filter(eg_allentities, EBP.AEF.FIGHTING_POSITION_MP, FILTER_KEEP)
	EGroup_FilterUnderConstruction(eg_allentities, FILTER_REMOVE)
	EGroup_RemoveGroup(eg_allentities, eg_support_alreadybuiltfightingpositions)
	
	if EGroup_Count(eg_allentities) >= 1 then
		
		Rule_RemoveMe()
		
		EGroup_AddEGroup(eg_sentry1_bunker1, eg_allentities)
		EGroup_AddEGroup(eg_sentry1_allbunkers, eg_allentities)
		
		Util_StartIntel(EVENTS.Support_BuildFightingPosition_AddHMG)
		Player_SetUpgradeAvailability(player1, UPG.AEF.FIGHTING_POSITION_MG_ADDITION_MP, ITEM_DEFAULT)
		flashid_support_fightingposition_hmg = UI_FlashProductionButton(PITEM_Upgrade, UPG.AEF.FIGHTING_POSITION_MG_ADDITION_MP, true)
		
		Rule_AddOneShot(Support_ConstructFightingPosition_AddHMG, 2)
		Rule_AddDelayedInterval(Support_ConstructFightingPosition_HMGInProgress, 2, 0.5)
		
	end
	
end


function Support_ConstructFightingPosition_AddHMG()
	
	hpid_support_fightposition_hmg = Objective_AddUIElements(SOBJ_Support_BuildFiringPosition, eg_sentry1_bunker1, true, 11076589, true)	-- LOCDB [11076589] 'Upgrade this fighting position with a HMG'
	
end

function Support_ConstructFightingPosition_HMGInProgress()
	
	if EGroup_IsProducingItem(eg_sentry1_bunker1, UPG.AEF.FIGHTING_POSITION_MG_ADDITION_MP, PITEM_Upgrade, ANY) then
		
		Rule_RemoveMe()
		
		Event_Timer(EventHandler_RemoveObjectiveUI, {objective = SOBJ_Support_BuildFiringPosition, element = hpid_support_fightposition_hmg}, 2)
		
		Rule_AddDelayedInterval(Support_ConstructFightingPosition_HMGDone, 2, 0.5)
		Rule_AddOneShot(Support_ConstructTankTraps, 1)
		
	end
	
end


function Support_ConstructFightingPosition_HMGDone()
	
	if EGroup_HasUpgrade(eg_sentry1_bunker1, UPG.AEF.FIGHTING_POSITION_MG_ADDITION_MP, ANY) == true then
		
		Rule_RemoveMe()
		
		Event_Timer(EventHandler_ObjectiveComplete, {objective = SOBJ_Support_BuildFiringPosition, showTitle = false}, 1)
		
	end
	
end


-- 
-- Get the player to build tank traps
--

function Support_ConstructTankTraps()

	Objective_Start(SOBJ_Support_BuildTankTraps)
	Event_Timer(EventHandler_StartIntel, {intel = EVENTS.Support_BuildTankTraps}, 2)
	Player_SetEntityProductionAvailability(player1, EBP.AEF.AEF_TANK_TRAP_MP, ITEM_DEFAULT)
	Player_GetAll(player1)
	EGroup_Filter(eg_allentities, EBP.AEF.AEF_TANK_TRAP_MP, FILTER_KEEP)
	EGroup_AddEGroup(eg_support_alreadybuilttanktraps, eg_allentities)
	
	Rule_AddDelayedInterval(Support_ConstructTankTraps_Done, 2, 0.5)

end

function Support_ConstructTankTraps_Done()

	World_GetNeutralEntitiesNearPoint(eg_allentities, Util_GetPosition(mkr_support_tanktrap_location), 20)
	EGroup_Filter(eg_allentities, EBP.AEF.AEF_TANK_TRAP_MP, FILTER_KEEP)
	EGroup_FilterUnderConstruction(eg_allentities, FILTER_REMOVE)
	EGroup_RemoveGroup(eg_allentities, eg_support_alreadybuilttanktraps)
	
	if EGroup_Count(eg_allentities) >= 1 then
		
		Rule_RemoveMe()
		
		Event_Timer(EventHandler_ObjectiveComplete, {objective = SOBJ_Support_BuildTankTraps, showTitle = false}, 1)
		
		Rule_AddOneShot(Support_StartMortarAttack, 1)
		
	end
	
end










--
-- Start the mortar attack!!!
--

function Support_StartMortarAttack()			

	-- trigger a series of off-map mortar attacks around the sentry location
	Event_Timer(Support_DropMortar, {location = mkr_sentry1_artillery1}, 1)
	Event_Timer(Support_DropMortar, {location = mkr_sentry1_artillery2}, 8)
	Event_Timer(Support_DropMortar, {location = mkr_sentry1_artillery3}, 11)
	Event_Timer(Support_DropMortar, {location = mkr_sentry1_artillery4}, 20)
	Event_Timer(Support_DropMortar, {location = mkr_sentry1_artillery5}, 23)
	Event_Timer(Support_DropMortar, {location = mkr_sentry1_artillery6}, 29)
	Event_Timer(Support_DropMortar, {location = mkr_sentry1_artillery7}, 31)
	
	-- speed up the transition to daybreak atmosphere
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/xp1/_twin_villages_mid_morning.aps", 60)	

	-- trigger some speech
	Event_Timer(EventHandler_StartIntel, {intel = EVENTS.Support_ArtilleryStart}, 10)
	Event_Timer(Support_TakeCover, nil, 15)
	
	-- kick off the infantry attack after the mortar attack has finished
	Event_Timer(Support_StartEnemyAttack, nil, 41)
	
	
end
function Support_DropMortar(data)
	Cmd_Ability(player2, ABILITY.GLOBAL.OFF_MAP_ARTILLERY, data.location, nil, true)
end





--
-- Tell the player to take cover now that artillery is firing
--

function Support_TakeCover()
	
	local _CheckEntity = function(gid, idx, eid)
		return Entity_IsHoldingAny(eid)
	end
	
	if EGroup_ForEachAllOrAny(eg_sentry1_allbunkers, ALL, _CheckEntity) then			-- they're already in the bunkers, just carry on with the report
		
		Util_StartIntel(EVENTS.Support_ArtilleryAlreadyInCover)
		Event_NarrativeEventsNotRunning(EventHandler_StartIntel, {intel = EVENTS.Support_ArtilleryReport}, 2)

	else																				-- tell player to get in bunkers, then do the report
		
		Util_StartIntel(EVENTS.Support_ArtilleryGetInCover)
		time_Support_settlein = World_GetGameTime()	-- mark this time for later on
		Event_Timer(Support_TakeCover_PartB, nil, 3)
		
	end
	
end
function Support_TakeCover_PartB()

	-- add hints onto any of the buildings not occupied
	if EGroup_IsHoldingAny(eg_sentry1_bunker1) == false then
		hpid_Support_bunker1 = Objective_AddUIElements(OBJ_Support, eg_sentry1_bunker1, false, 11076590, true)	-- LOCDB [11076590] 'Garrison this fighting position'
		Event_IsHoldingAny(EventHandler_RemoveObjectiveUI, {objective = OBJ_Support, element = hpid_Support_bunker1}, eg_sentry1_bunker1, false, 0)
	end
	if EGroup_IsHoldingAny(eg_sentry1_watchtower) == false then
		hpid_Support_watchtower = Objective_AddUIElements(OBJ_Support, eg_sentry1_watchtower, false, 11076591, true, 1.2)	-- LOCDB [11076591] 'Garrison this watchtower'
		Event_IsHoldingAny(EventHandler_RemoveObjectiveUI, {objective = OBJ_Support, element = hpid_Support_watchtower}, eg_sentry1_watchtower, false, 0)
	end

	Rule_AddInterval(Support_TakeCover_Done, 1)
	
end

function Support_TakeCover_Done()

	local _CheckEntity = function(gid, idx, eid)
		return Entity_IsHoldingAny(eid)
	end
	
	if EGroup_ForEachAllOrAny(eg_sentry1_allbunkers, ALL, _CheckEntity) or (World_GetGameTime() - time_Support_settlein) > 25 then
		
		if Player_OwnsEGroup(player1, eg_sentry1_allbunkers, ALL) then
			Util_StartIntel(EVENTS.Support_ArtilleryReport)
		end
		
		Objective_RemoveUIElements(OBJ_Support, hpid_Support_bunker1)
		Objective_RemoveUIElements(OBJ_Support, hpid_Support_watchtower)
		
		BeginnerHint_AddOpportunity(mkr_support_coverhint1, HINT_HEAVYCOVER)
		BeginnerHint_AddOpportunity(mkr_support_coverhint2, HINT_HEAVYCOVER)
		BeginnerHint_AddOpportunity(mkr_support_coverhint3, HINT_HEAVYCOVER)
		
		Rule_RemoveMe()
		
	end
	
end




--
-- Now start the infantry coming through the trees
--

function Support_StartEnemyAttack()

	enc_Sentry1_EnemyAttack = ENCOUNTERS.Support_EnemyAttack()
	Event_PlayerCanSeeElement(EventHandler_StartIntel, {intel = EVENTS.Support_InfantryAttackStart}, player1, sg_sentry1_attackers, ANY, 6)
	Event_PlayerCanSeeElement(EventHandler_ObjectiveStart, {objective = SOBJ_Support_DefendCheckpoint}, player1, sg_sentry1_attackers, ANY, 4)
	
	t_support_enemyattack_reinforcements = {
		{sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, load = 3},
		{sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, load = 3},
		{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, load = 4},
		{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, load = 3},
		{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, load = 4},
		{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, load = 3},
	}
	support_num_enemyattack_members = SGroup_TotalMembersCount(sg_sentry1_attackers)
	support_num_enemyattack_reinforcements = #t_support_enemyattack_reinforcements

	modid_support_attackers = Modify_ReceivedDamage(sg_sentry1_attackers, 1.1)

	Rule_AddInterval(Support_EnemyAttack_AddUnit, 5)
	Rule_AddInterval(Support_UnlockDefensiveArtillery, 5)
	Rule_AddOneShot(Support_EnemyAttack_AddRightFlankUnit, World_GetRand(20, 25))
	Rule_AddOneShot(Support_EnemyAttack_AddLeftFlankUnit, World_GetRand(27, 35))
	
	Rule_AddInterval(Support_PlayerWipedOut, 2)
	
	Event_Timer(Support_CaptureTerritoryPoint, {marker = mkr_capturepoint1_spawn, capturepoint = eg_point_enemy1}, 32)
	Event_Timer(Support_CaptureTerritoryPoint, {marker = mkr_capturepoint2_spawn, capturepoint = eg_point_enemy2}, 25)
	Event_Timer(Support_CaptureTerritoryPoint, {marker = mkr_capturepoint3_spawn, capturepoint = eg_point_enemy3}, 23)
	Event_Timer(Support_CaptureTerritoryPoint, {marker = mkr_capturepoint4_spawn, capturepoint = eg_point_enemy4}, 16)
	Event_Timer(Support_CaptureTerritoryPoint, {marker = mkr_capturepoint5_spawn, capturepoint = eg_point_enemy5}, 19)
	Event_Timer(Support_CaptureTerritoryPoint, {marker = mkr_capturepointradio_spawn, capturepoint = eg_point_radiotower}, 20)

end


function Support_EnemyAttack_AddUnit()
	
	if #t_support_enemyattack_reinforcements == 0 then
		Rule_RemoveMe()
	else
		Rule_AddOneShot(Support_EnemyAttack_AddUnit_PartB, World_GetRand(1, 4))		-- this line randomly staggers the addition of new units
	end
	
end
function Support_EnemyAttack_AddUnit_PartB()
	
	if SGroup_TotalMembersCount(sg_sentry1_attackers) < (support_num_enemyattack_members - 2) then
		
		-- add a new unit!
		local choice = World_GetRand(1, #t_support_enemyattack_reinforcements)
		enc_Sentry1_EnemyAttack:AddUnit(t_support_enemyattack_reinforcements[choice])
		
		if enc_Sentry1_EnemyAttack:HasGoal() == false then
			enc_Sentry1_EnemyAttack:RestartGoal()
		end
		
		Modifier_Remove(modid_support_attackers)
		modid_support_attackers = Modify_ReceivedDamage(sg_sentry1_attackers, 1.1)
		
		-- remove from the remaining reinforcements
		table.remove(t_support_enemyattack_reinforcements, choice)
		
		-- if this was the last unit spawned, start monitoring for all these guys being killed
		if #t_support_enemyattack_reinforcements <= 0 then
			
			Rule_AddInterval(Support_EnemyAttackAlmostDead, 1)
			
		end
		
	end
	
end


function Support_EnemyAttack_AddRightFlankUnit()
	Util_CreateSquads(player2, sg_sentry1_attackers_rightflank, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_sentry1_enemyspawn6, mkr_sentry1_enemydest6, 1, 4)
	Event_IsDoingAttack(EventHandler_StartIntel, {intel = EVENTS.Support_InfantryAttack_FlankRight}, sg_sentry1_attackers_rightflank, ANY, 3, 2)
	BeginnerHint_AddOpportunity(sg_sentry1_attackers_rightflank, ABILITY.AEF.MK2_FRAGMENTATION_GRENADE_MP)
end
function Support_EnemyAttack_AddLeftFlankUnit()
	Util_CreateSquads(player2, sg_sentry1_attackers_leftflank, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_sentry1_enemyspawn7, mkr_sentry1_enemydest7, 1, 4)
	Event_IsDoingAttack(EventHandler_StartIntel, {intel = EVENTS.Support_InfantryAttack_FlankLeft}, sg_sentry1_attackers_leftflank, ANY, 3, 2)
	BeginnerHint_AddOpportunity(sg_sentry1_attackers_leftflank, ABILITY.AEF.MK2_FRAGMENTATION_GRENADE_MP)

end




-- when *most* of the attackers are killed, make it wrap up quickly
function Support_EnemyAttackAlmostDead()
	
	if SGroup_TotalMembersCount(sg_sentry1_attackers) + SGroup_TotalMembersCount(sg_sentry1_attackers_leftflank) + SGroup_TotalMembersCount(sg_sentry1_attackers_rightflank) <= 13 then
		
		Rule_RemoveMe()
		
		Cmd_StaggeredRetreat(sg_sentry1_attackers, {mkr_sentry1_enemyspawn1, mkr_sentry1_enemyspawn2, mkr_sentry1_enemyspawn3, mkr_sentry1_enemyspawn4, mkr_sentry1_enemyspawn5}, 5, true)
		
		Cmd_StaggeredRetreat(sg_sentry1_attackers_rightflank, {mkr_sentry1_enemyspawn6}, 5, true)
		Cmd_StaggeredRetreat(sg_sentry1_attackers_leftflank, {mkr_sentry1_enemyspawn7}, 5, true)
		
--~ 		Modify_ReceivedAccuracy(sg_sentry1_attackers, 2)
--~ 		Modify_ReceivedDamage(sg_sentry1_attackers, 2)
		
		-- now start the transition to the daytime atmosphere
		Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/xp1/_twin_villages_late_morning.aps", 600)	
		
		Rule_AddOneShot(Support_EnemyAttackFinished, 6)
		
	end
	
end

-- when *all* of the attackers are killed
function Support_EnemyAttackFinished()
	
	if Objective_IsFailed(SOBJ_Support_DefendCheckpoint) == false then
		
		UI_StopFlashing(flashid_artilleryability)
		
		if Rule_Exists(Support_DefensiveArtilleryTriggered) then
			Rule_RemoveGlobalEvent(Support_DefensiveArtilleryTriggered)
		end
		
		BeginnerHint_RemoveOpportunity(mkr_support_coverhint1)
		BeginnerHint_RemoveOpportunity(mkr_support_coverhint2)
		BeginnerHint_RemoveOpportunity(mkr_support_coverhint3)
		
		if Objective_IsComplete(SOBJ_Support_UseDefensiveArtillery) == false then
			Objective_Fail(SOBJ_Support_UseDefensiveArtillery, false)
		end
		Objective_Complete(SOBJ_Support_DefendCheckpoint, false)
		
		Rule_AddOneShot(Support_EnemyAttackFinished_PartB, 1)
		
	end
	
end
function Support_EnemyAttackFinished_PartB()

	Objective_Complete(OBJ_Support)

end





function Support_PlayerWipedOut()

	if Objective_IsComplete(SOBJ_Support_DefendCheckpoint) == true then
		
		Rule_RemoveMe()
		
	elseif Prox_ArePlayersNearMarker(player1, mkr_sentry1_encounterarea, ANY, 40) == false and Event_IsAnyRunning() == false then
		
		-- player is overrun
		Objective_Fail(SOBJ_Support_DefendCheckpoint)
		
		Util_StartIntel(EVENTS.Support_Failed)
		Rule_AddDelayedInterval(Mission_Fail, 2, 1)
		
		Rule_RemoveMe()
		
	end
	
end









--
-- Grab extra points, so the player sees them flash and change on the minimap
--

function Support_CaptureTerritoryPoint(data)

	data.sgroup = SGroup_CreateIfNotFound("")
	Util_CreateSquads(player2, data.sgroup, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, data.marker, data.capturepoint)
	
	Event_PlayerOwnsTerritory(Support_CaptureTerritoryPoint_PartB, data, player2, data.capturepoint, ANY, 2)
	
end
function Support_CaptureTerritoryPoint_PartB(data)
	
	FOW_RevealEGroupOnly(data.capturepoint, 0.5)
	
	if SGroup_CountSpawned(data.sgroup) >= 1 then
		Cmd_MoveToAndDespawn(data.sgroup, data.marker)
	end
	
end



--
-- Tell the player to use the defensive artillery
--

function Support_UnlockDefensiveArtillery()

	if #t_support_enemyattack_reinforcements < (support_num_enemyattack_reinforcements - 1) then 
		
		Rule_RemoveMe()
		
		
		-- show subobjective
		Objective_Start(SOBJ_Support_UseDefensiveArtillery)
		
		-- unlock the artillery abilities
		Player_SetResource(player1, RT_Command, 5)
		
		-- flash the ability we want the player to use
		Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("pm_artillery_support_105mm"), ITEM_UNLOCKED)
		flashid_artilleryability = UI_FlashAbilityButton(BP_GetAbilityBlueprint("pm_artillery_support_105mm"), true)
		SupportHints_Artillery_PlayerHelp()
		
		-- monitor for the player triggering any of the artillery abilities
		Rule_AddGlobalEvent(Support_DefensiveArtilleryTriggered, GE_AbilityExecuted)
		
		Util_StartIntel(EVENTS.Support_UseBarrageAbility)
		
	end
	
end

function Support_DefensiveArtilleryTriggered(caster, ability, target)

	if target ~= nil then
		
		target = Util_GetPosition(target)
		
		if ability == BP_GetAbilityBlueprint("pm_artillery_support_105mm") then
			
			Rule_RemoveGlobalEvent(Support_DefensiveArtilleryTriggered)
			UI_StopFlashing(flashid_artilleryability)
			
			if Util_GetDistance(target, mkr_sentry1_encounterarea) <= 15 then
			
				-- hurrah, they targetted the ability in the correct zone
				Objective_Complete(SOBJ_Support_UseDefensiveArtillery, false)
				Util_StartIntel(EVENTS.Support_BarrageAbilityUsed)
				
			else
				
				-- what a tool
				Objective_Fail(SOBJ_Support_UseDefensiveArtillery, false)
				Util_StartIntel(EVENTS.Support_BarrageAbilityUsedInWrongTerritory)
				
			end
			
		elseif ability == BP_GetAbilityBlueprint("pm_artillery_support_anti_tank") then
			
			-- well, it's some kind of artillery I suppose
			Rule_RemoveGlobalEvent(Support_DefensiveArtilleryTriggered)
			UI_StopFlashing(flashid_artilleryability)
			
			Objective_Fail(SOBJ_Support_UseDefensiveArtillery, false)
			Util_StartIntel(EVENTS.Support_WrongBarrageAbilityUsed)
			
		end
		
	end
	
end










--
-- TUTORIALS
--

-- walk the player through the Move Out stage if necessary
function SupportHints_MoveToLocation_PlayerHelp()

	if g_difficulty <= GD_NORMAL then
	
		flag_playerHasGivenMoveOrder = false

		Rule_AddGlobalEvent(SupportHints_MoveToLocation_MoveOrderGiven, GE_SquadCommandIssued)
		Rule_AddOneShot(SupportHints_MoveToLocation_ShowSelectHelp, 30)
		
	end
	
end
function SupportHints_MoveToLocation_MoveOrderGiven(squad, command, target)
	if Player_OwnsSquad(player1, squad) == true and (command == SCMD_Move or command == SCMD_AttackMove or command == SCMD_Load) then
		flag_playerHasGivenMoveOrder = true
		Rule_RemoveGlobalEvent(SupportHints_MoveToLocation_MoveOrderGiven)
	end
end


function SupportHints_MoveToLocation_ShowSelectHelp()
	if flag_playerHasGivenMoveOrder == false then
	
		Player_GetAll(player1)
		if Misc_IsSGroupSelected(sg_allsquads, ALL) == false then		-- only kick in if the player HASN'T selected all squads
			Camera_MoveTo(sg_allsquads, true, 0.1, false, true)
			titleid_selectUnits = UI_NewHUDFeature(HUDF_None, 11083630, "Icons_tooltips_controls_drag_select", 999999999)		-- LOCDB [11083630] 'Hold the left mouse button and drag a selection box over your squads to select them all'
			Rule_AddInterval(SupportHints_MoveToLocation_ShowSelectHelp_PartB, 0.5)
		else
			SupportHints_MoveToLocation_ShowMoveHelp()
		end
	
	end
end
function SupportHints_MoveToLocation_ShowSelectHelp_PartB()
	Player_GetAll(player1)
	if Misc_IsSGroupSelected(sg_allsquads, ALL) == true or flag_playerHasGivenMoveOrder == true then
		UI_TitleDestroy(titleid_selectUnits)
		Rule_AddOneShot(SupportHints_MoveToLocation_ShowMoveHelp, 1)
		Rule_RemoveMe()
	end
end


function SupportHints_MoveToLocation_ShowMoveHelp()
	if flag_playerHasGivenMoveOrder == false then
	
		if Misc_IsSGroupSelected(sg_allsquads, ALL) == true then
			titleid_giveMoveOrder = UI_NewHUDFeature(HUDF_None, 11083631, "Icons_tooltips_tooltip_miniclick", 999999999)		-- LOCDB [11083631] 'Right-click on the ground at Checkpoint Fox to order the selected squads to move there'
			Camera_MoveTo(mkr_sentry1_destination, true, 0.1, false, true)
			Rule_AddInterval(SupportHints_MoveToLocation_ShowMoveHelp_PartB, 0.5)
		else
			SupportHints_MoveToLocation_ShowSelectHelp()
		end
		
	end
	
end
function SupportHints_MoveToLocation_ShowMoveHelp_PartB()
	if flag_playerHasGivenMoveOrder == true or Misc_IsSGroupSelected(sg_allsquads, ALL) == false then
		UI_TitleDestroy(titleid_giveMoveOrder)
		Rule_RemoveMe()
		
		if Misc_IsSGroupSelected(sg_allsquads, ALL) == false then
			Rule_AddOneShot(SupportHints_MoveToLocation_ShowSelectHelp, 1)
		else
			Rule_AddOneShot(SupportHints_MoveToLocation_ShowMoveHelp_PartC, 3)
		end
		
	end	
end
function SupportHints_MoveToLocation_ShowMoveHelp_PartC()
	-- this is just an addendum
	UI_NewHUDFeature(HUDF_None, 11083632, "Icons_tooltips_tooltip_miniclick", 8)			-- LOCDB [11083632] 'Right-click orders are contextual; click on ground to move, on buildings to garrison, or on enemies to attack'
end









-- walk the player through calling in artillery
function SupportHints_Artillery_PlayerHelp()

	if g_difficulty <= GD_NORMAL then
	
		flag_playerHasCalledInArtillery = false

		Rule_AddInterval(SupportHints_Artillery_OrderGiven, 0.5)
		Rule_AddOneShot(SupportHints_Artillery_ShowAbilityHelp, 20)
		
	end
	
end
function SupportHints_Artillery_OrderGiven()
	if Objective_IsComplete(SOBJ_Support_UseDefensiveArtillery) or Objective_IsFailed(SOBJ_Support_UseDefensiveArtillery) then
		flag_playerHasCalledInArtillery = true
		Rule_RemoveMe()
	end
end


function SupportHints_Artillery_ShowAbilityHelp()

	if flag_playerHasCalledInArtillery == false then		-- only kick in if the player HASN'T called in artillery
		Player_GetAll(player1)
		Camera_MoveTo(mkr_sentry1_encounterarea, true, 0.1, false, true)
		titleid_callInArtillery = UI_NewHUDFeature(HUDF_AbilityCard, 11083633, "Icons_abilities_ability_aef_106mm_barrage", 999999999)		-- LOCDB [11083633] 'Left-click on the Artillery button flashing below, then left-click on the target location'
		Rule_AddInterval(SupportHints_Artillery_ShowAbilityHelp_PartB, 0.5)
	end
	
end
function SupportHints_Artillery_ShowAbilityHelp_PartB()
	if flag_playerHasCalledInArtillery == true or Objective_IsComplete(SOBJ_Support_DefendCheckpoint) then
		UI_TitleDestroy(titleid_callInArtillery)
		titleid_callInArtillery = nil
		Rule_RemoveMe()
	end
end




-- tell players how to get out of buildings again!
function SupportHints_Garrison_PlayerHelp()

	Rule_AddInterval(SupportHints_Garrison_ShowEjectHelp, 0.5)
	
end
function SupportHints_Garrison_ShowEjectHelp()

	Player_GetAll(player1)
	if SGroup_IsInHoldEntity(sg_allsquads, ANY) and Event_IsAnyRunning() == false then
		
		Util_NewHUDFeatureEvent(HUDF_None, 11083634, "Icons_commands_icon_command_unload_here", 8)				-- LOCDB [11083634] 'To get squads back out, select the building and click the Eject button in the command panel'
		
		Rule_RemoveMe()
		
	elseif Objective_IsComplete(SOBJ_Support_DefendCheckpoint) then
		
		Rule_RemoveMe()
		
	end
	
end









--
-- CLEANUP
-- 

-- called during the intro section of the next division - can remove any units no longer needed here
function Support_Cleanup()

	Player_GetAll(player1)
	SGroup_SetPlayerOwner(sg_allsquads, player4)
	
	World_EnableSharedLineOfSight(player4, player1, false)
	World_EnableSharedLineOfSight(player4, player3, false)
	World_EnableSharedLineOfSight(player4, player5, false)
	World_EnableSharedLineOfSight(player4, player6, false)

end


