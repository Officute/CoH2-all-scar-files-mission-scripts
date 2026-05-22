print("\tLoading ObjBridges file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- OUREN
-- Objective File - BRIDGES
-- Designer: NJR
-------------------------------------------------------------------------
-------------------------------------------------------------------------



-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_ObjBridges()

	print("Initializing ObjBridges...")
	
	-- Pre-condition:		None - Objective populates on mission start
	-- Success condition:	Both subobjectives are complete
	-- Failure condition:	Either subobjective is failed - i.e. bridge blown up
	-- Post-condition:
	--		Success:		No reaction - BOTH main objectives must be complete to win the mission
	--		Failure:		Mission fails
	OBJ_Bridges = {
		--Info
		Title = 11076554,	-- LOCDB [11076554] 'Secure and hold the two Bridges'
--~ 		TitleEnd = LOC("Objective Complete"),
--~ 		TitleFail = LOC("Objective Failed"),
		Type = OT_Primary,
		Parent = nil,
		subObjectives = {},
		
		--Intel
		Intel_Start = 				EVENTS.MissionIntro,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			nil,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				nil,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = function()
		end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = function()
			if Objective_IsFailed(SOBJ_SouthBridge) or Objective_IsFailed(SOBJ_NorthBridge) then
				return true
			end
		end,
		PreFail = nil,
		OnFail = function()
			if Rule_Exists(Mission_Fail) == false then
				Allies_Stop()
				Counterattack_Stop()
				XP1_SetMissionSuccessLevel(0)
				Rule_AddDelayedInterval(Mission_Fail, 5, 1)
			end
		end,
	}
	
	
	
	
	-- Pre-condition:		None - populates with the parent objective
	-- Success condition:	Encounters around the bridge are dealt with
	-- Failure condition:	Bridge gets blown up
	-- Post-condition:
	--		Success:		No reaction to this alone - BOTH subobjectives need to be completed in order to complete the parent objective
	--		Failure:		Parent objective fails, which leads to a Mission fail
	SOBJ_SouthBridge = {
		Title = 11076555,	-- LOCDB [11076555] 'Secure the Southern Bridge'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,						
		Parent = OBJ_Bridges,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			EVENTS.SouthBridge_Secured,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				EVENTS.SouthBridge_Destroyed,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() 
			hpid_southbridge = Objective_AddUIElements(SOBJ_SouthBridge, eg_bridge_south, true, 11076555, true)		-- LOCDB [11076555] 'Secure the Southern Bridge'
		end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = function()
			if (((SGroup_Count(sg_southbridge_all) == 0) or (Prox_ArePlayersNearMarker(player2, mkr_southbridge_encounterarea, ANY, 42) == false)) and EGroup_IsCapturedByPlayer(eg_southbridgeCap, player1, ANY) and EGroup_Count(eg_bridge_south) >= 1) then
				return true
			end
		end,
		PreComplete = nil,
		OnComplete = function()
			Objective_RemoveUIElements(SOBJ_SouthBridge, hpid_southbridge)
			Objective_UpdateText(SOBJ_SouthBridge, 11076556, 0, false)		-- LOCDB [11076556] 'Hold the Southern Bridge'
			Event_Timer(Bridges_TalkAboutHelpingNorthBridge, nil, 10)
		end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_Bridges.subObjectives, SOBJ_SouthBridge) -- Don't forget to add them to their parent!
	
	
	-- Pre-condition:		None - populates with the parent objective
	-- Success condition:	Encounters around the bridge are dealt with
	-- Failure condition:	Bridge gets blown up
	-- Post-condition:
	--		Success:		No reaction to this alone - BOTH subobjectives need to be completed in order to complete the parent objective
	--		Failure:		Parent objective fails, which leads to a Mission fail
	SOBJ_NorthBridge = {
		Title = 11076557,	-- LOCDB [11076557] 'Secure the Northern Bridge'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,						
		Parent = OBJ_Bridges,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			EVENTS.NorthBridge_Secured,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				EVENTS.NorthBridge_Destroyed,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function()
			hpid_northbridge = Objective_AddUIElements(SOBJ_NorthBridge, eg_bridge_north, true, 11076557, true)	-- LOCDB [11076557] 'Secure the Northern Bridge'
		end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = function()
			if northbridge_approached_by_player == true and EGroup_Count(eg_bridge_north) >= 1 and
			( (SGroup_Count(sg_northbridge_all) == 0 and SGroup_Count(sg_northfield_all) == 0) or Player_OwnsEGroup(player1, eg_point_northbridge, ALL) ) then
				return true
			end
		end,
		PreComplete = nil,
		OnComplete = function()
			Objective_RemoveUIElements(SOBJ_NorthBridge, hpid_northbridge)
			Objective_UpdateText(SOBJ_NorthBridge, 11076558, 0, false)		-- LOCDB [11076558] 'Hold the Northern Bridge'
		end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_Bridges.subObjectives, SOBJ_NorthBridge) -- Don't forget to add them to their parent!
	
	
	Rule_AddInterval(Bridges_FailCheck, 1)
	
end
Scar_AddInit(INIT_ObjBridges)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------

function Bridges_FailCheck()
	
	-- check is externalised because you can still fail a subobjective AFTER it's marked as complete 
	-- (the internal methods will stop checking)
	
	if Objective_IsFailed(SOBJ_SouthBridge) == false and EGroup_Count(eg_bridge_south) == 0 then
		Obj_SetState(SOBJ_SouthBridge.ID, OS_Incomplete)
		Objective_Fail(SOBJ_SouthBridge)
	end
	
	if Objective_IsFailed(SOBJ_NorthBridge) == false and EGroup_Count(eg_bridge_north) == 0 then
		Obj_SetState(SOBJ_NorthBridge.ID, OS_Incomplete)
		Objective_Fail(SOBJ_NorthBridge)
	end

end


function Bridges_TalkAboutHelpingNorthBridge()

	if Objective_IsComplete(SOBJ_NorthBridge) == false and Objective_IsFailed(SOBJ_NorthBridge) == false then
		
		-- call out the fact that you should go and help the allies at the north bridge
		Event_NarrativeEventsNotRunning(EventHandler_StartIntel, {intel = EVENTS.Bridges_TalkAboutHelpingAllies}, 1)
		
	end
	
end






------------------------------------------------
--                                            --
--  Functions pertaining to the SOUTH bridge  --
--                                            --
------------------------------------------------

function SouthBridge_Init()

	-- spawn some "static" units
	Util_CreateSquads(player2, sg_southbridge_hmg1, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, mkr_southbridge_spawn1)
	Util_CreateSquads(player2, sg_southbridge_mortar1, SBP.WEST_GERMAN.GRW34_81MM_MORTAR_SQUAD_MP, mkr_southbridge_spawn6)
	Util_CreateSquads(player2, sg_southbridge_atgun1, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, mkr_southbridge_spawn7)

	Cmd_InstantSetupTeamWeapon(sg_southbridge_hmg1)
	Cmd_InstantSetupTeamWeapon(sg_southbridge_mortar1)
	
	-- node strength veterancy
	SGroup_IncreaseVeterancyRank(sg_southbridge_hmg1, XP1_GetNodeStrengthVeterancy(), true)
	SGroup_IncreaseVeterancyRank(sg_southbridge_mortar1, XP1_GetNodeStrengthVeterancy(), true)
	SGroup_IncreaseVeterancyRank(sg_southbridge_atgun1, XP1_GetNodeStrengthVeterancy(), true)
	
	-- create an encounter on top of the static units 
	enc_SouthField = ENCOUNTERS.SouthFieldDefenders()
	enc_SouthBridge = ENCOUNTERS.SouthBridgeDefenders()
	
	-- set up the larger meta-groups
	SGroup_AddGroups(sg_southbridge_southdefenders, {sg_southbridge_hmg1})
	SGroup_AddGroups(sg_southbridge_all, {sg_southbridge_southdefenders, sg_southbridge_encounter, sg_southbridge_mortar1, sg_southbridge_hmg1, sg_southbridge_atgun1})
	
	-- set up triggers
	Event_CreateOR(SouthBridge_FallBackAcrossBridge, nil, {
		Event_GroupLeftAlive(__DoNothing, nil, sg_southbridge_southdefenders, 6),
		Event_Proximity(__DoNothing, nil, player1, mkr_southbridge_fallback_trigger, nil, ANY, 3),
	})
	Event_OnHealth(EventHandler_StartIntel, {intel = EVENTS.SouthBridge_HeavilyDamaged}, eg_bridge_south, 0.35, false)
	Event_OnHealth(EventHandler_StartIntel, {intel = EVENTS.SouthBridge_HeavilyDamaged_Stage2}, eg_bridge_south, 0.15, false)
	
end


function SouthBridge_FallBackAcrossBridge()

	-- give fallback commands to scripted units on the player's side of the bridge
	Cmd_Retreat(sg_southbridge_southdefenders, mkr_southbridge_spawn5, nil, nil, true)
	
	-- add the AT gun to the encounter
	enc_SouthBridge:AddSgroup(sg_southbridge_atgun1)
	
	-- reset encounter goal location
	GOALS.SouthBridgeDefenders_Fallback1(enc_SouthBridge)
	
	-- call out the fact the germans are falling back
	Event_Timer(EventHandler_StartIntel, {intel = EVENTS.SouthBridge_Fallback}, 4)
	
	-- script the mortar to start attacking the bridge
	southbridge_attackbridge_range = 30
	southbridge_attackbridge_firecount = 0	
	Rule_AddInterval(SouthBridge_FireMortarAtBridge, 15)
	
	
	-- set up triggers
	Event_CreateOR(SouthBridge_FallBackToMortar, nil, {
		Event_GroupLeftAlive(__DoNothing, nil, sg_southbridge_all, 9),
		Event_Proximity(__DoNothing, nil, player1, mkr_southbridge_encounterarea_fallback1, nil, ANY, 3),
	})
	
end


function SouthBridge_FallBackToMortar()

	-- give fallback commands to all the bridge defenders (apart from the mortar guy who stays where he is)
	SGroup_Clear(sg_temp)
	SGroup_AddGroup(sg_temp, sg_southbridge_all)
	SGroup_RemoveGroup(sg_temp, sg_southbridge_mortar1)
	SGroup_RemoveGroup(sg_temp, sg_southbridge_atgun1)
	
	Cmd_Retreat(sg_temp, mkr_southbridge_spawn6, nil, nil, true)
	
	-- reset encounter goal location
	GOALS.SouthBridgeDefenders_Fallback2(enc_SouthBridge)
	
end


function SouthBridge_FireMortarAtBridge()

	if EGroup_Count(eg_bridge_south) == 0 or SGroup_Count(sg_southbridge_mortar1) == 0 or SGroup_HasTeamWeapon(sg_southbridge_mortar1, ANY) == false then
		
		Rule_RemoveMe()
		
	else
		
		-- fire the mortar
		local targetpos = Util_GetRandomPosition(Util_GetPosition(eg_bridge_south), southbridge_attackbridge_range)
		Cmd_Ability(sg_southbridge_mortar1, ABILITY.WEST_GERMAN.GRW34_MORTAR_TEAM_MORTAR_BARRAGE_WG_MP, targetpos)
		
		-- call out the fact the germans are attacking the bridge _after 1 barrage_
		southbridge_attackbridge_firecount = southbridge_attackbridge_firecount + 1

		if southbridge_attackbridge_firecount == 1 then
			Rule_AddDelayedInterval(SouthBridge_FireMortarAtBridgeB, 5, 1)
		end
		-- shrink the range for NEXT time, so the mortar narrows in on the bridge
		southbridge_attackbridge_range = math.max(10, (southbridge_attackbridge_range - 4))
		
	end
	
end

function SouthBridge_FireMortarAtBridgeB()
	
	if Event_IsAnyRunning() == false then
		
		FOW_RevealSGroupOnly(sg_southbridge_mortar1, -1)
		Util_StartIntel(EVENTS.SouthBridge_MortarAttackingBridge)
		
		Rule_RemoveMe()
		
	end
	
end









------------------------------------------------
--                                            --
--  Functions pertaining to the NORTH bridge  --
--                                            --
------------------------------------------------

function NorthBridge_Init()

	-- spawn some "static" units
	Util_CreateSquads(player2, sg_northbridge_hmg1, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, mkr_northbridge_spawn7)
	Util_CreateSquads(player2, sg_northbridge_hmg2, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, mkr_northbridge_spawn6)
	Util_CreateSquads(player2, sg_northbridge_atgun1, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, mkr_northbridge_spawn2)
	
	Util_CreateSquads(player2, sg_northfield_hmg1, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, mkr_northfield_spawn1)
	Util_CreateSquads(player2, sg_northfield_atgun1, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, mkr_northfield_spawn2)
	
	Cmd_InstantSetupTeamWeapon(sg_northbridge_hmg1)
	Cmd_InstantSetupTeamWeapon(sg_northbridge_hmg2)
	Cmd_InstantSetupTeamWeapon(sg_northbridge_atgun1)

	Cmd_InstantSetupTeamWeapon(sg_northfield_hmg1)
	Cmd_InstantSetupTeamWeapon(sg_northfield_atgun1)
	
	-- node strength veterancy
	SGroup_IncreaseVeterancyRank(sg_northbridge_hmg1, XP1_GetNodeStrengthVeterancy(), true)
	SGroup_IncreaseVeterancyRank(sg_northbridge_hmg2, XP1_GetNodeStrengthVeterancy(), true)
	SGroup_IncreaseVeterancyRank(sg_northbridge_atgun1, XP1_GetNodeStrengthVeterancy(), true)
	SGroup_IncreaseVeterancyRank(sg_northfield_hmg1, XP1_GetNodeStrengthVeterancy(), true)
	SGroup_IncreaseVeterancyRank(sg_northfield_atgun1, XP1_GetNodeStrengthVeterancy(), true)
	
	swid_northbridge_hmg1 = SyncWeapon_GetFromSGroup(sg_northbridge_hmg1)
	swid_northbridge_hmg2 = SyncWeapon_GetFromSGroup(sg_northbridge_hmg2)
	swid_northbridge_atgun1 = SyncWeapon_GetFromSGroup(sg_northbridge_atgun1)

	EGroup_SetInvulnerable(eg_bridge_north, 0.5)	-- set the bridge partially invulnerable for now (gets removed when player approaches bridge)
	
	-- create encounters on top of the static units 
	enc_NorthBridge = ENCOUNTERS.NorthBridgeDefenders()
	enc_NorthField = ENCOUNTERS.NorthFieldDefenders()
	
	-- set up the larger meta-groups
	SGroup_AddGroups(sg_northbridge_all, {sg_northbridge_atgun1, sg_northbridge_hmg1, sg_northbridge_hmg2, sg_northbridge_encounter})
	SGroup_AddGroups(sg_northfield_all, {sg_northfield_atgun1, sg_northfield_hmg1, sg_northfield_encounter})
	
	-- set up triggers
	Event_CreateOR(NorthBridge_FieldEncounter_Fallback, nil, {																-- have the field defenders fold back into the bridge defence
--~ 		Event_GroupLeftAlive(__DoNothing, nil, sg_northbridge_all, math.floor(SGroup_TotalMembersCount(sg_northbridge_all) / 2)),
		Event_GroupLeftAlive(__DoNothing, nil, sg_northfield_all, math.floor(SGroup_TotalMembersCount(sg_northfield_all) / 2)),
		Event_Proximity(__DoNothing, nil, player1, mkr_northbridge_encounterarea, nil, ANY, 3),
		Event_Proximity(__DoNothing, nil, player1, mkr_northfield_encounterarea, nil, ANY, 3),
	})
	
	Event_CreateOR(NorthBridge_PlayerApproachedBridge, nil, {																-- mark that the player has started interacting with the bridge defenders
		Event_IsUnderAttack(__DoNothing, nil, sg_northbridge_all, ANY, 3, player1, 3),
		Event_Proximity(__DoNothing, nil, player1, mkr_northbridge_encounterarea, nil, ANY, 3),
		Event_Proximity(__DoNothing, nil, player1, mkr_northfield_encounterarea, nil, ANY, 3),
	})
	
	Event_OnHealth(EventHandler_StartIntel, {intel = EVENTS.NorthBridge_HeavilyDamaged}, eg_bridge_north, 0.35, false)
	Event_OnHealth(EventHandler_StartIntel, {intel = EVENTS.NorthBridge_HeavilyDamaged_Stage2}, eg_bridge_north, 0.15, false)
	
	-- add top-up rules for the team weapons
	local data1 = {
		swid = swid_northbridge_hmg1,
		sgroup = sg_northbridge_hmg1,
		recrew_sgroup = sg_northbridge_hmg1_recrew,
		marker = mkr_northbridge_spawn7,
		facing = mkr_northbridge_muster2,
		sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
	}
	local data2 = {
		swid = swid_northbridge_hmg2,
		sgroup = sg_northbridge_hmg2,
		recrew_sgroup = sg_northbridge_hmg2_recrew,
		marker = mkr_northbridge_spawn6,
		facing = mkr_northbridge_muster2,
		sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
	}
	local data3 = {
		swid = swid_northbridge_atgun1,
		sgroup = sg_northbridge_atgun1,
		recrew_sgroup = sg_northbridge_atgun1_recrew,
		marker = mkr_northbridge_spawn2,
		facing = mkr_northbridge_muster2,
		sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP,
	}
	Event_Timer(NorthBridge_TopUpDefenders_TeamWeapons, data1, 0.5)
	Event_Timer(NorthBridge_TopUpDefenders_TeamWeapons, data2, 1)
	Event_Timer(NorthBridge_TopUpDefenders_TeamWeapons, data3, 1.5)
	
	-- some variables
	northbridge_approached_by_player = false
	
end


-- when either of the groups gets depleted, bind the two together at the bridge
function NorthBridge_FieldEncounter_Fallback()
	
	if enc_NorthBridge:IsAlive() then
		
		-- stop the field encounter and throw its units into the bridge encounter
		enc_NorthField:ClearGoal()	
		enc_NorthField:Disable()	
		enc_NorthBridge:AddSgroup(sg_northfield_all)
		
		-- restart goal if necessary
		if enc_NorthBridge:HasGoal() == false then
			enc_NorthBridge:RestartGoal()
		end
		
	end
	
end

function NorthBridge_PlayerApproachedBridge()
	
	northbridge_approached_by_player = true
	EGroup_SetInvulnerable(eg_bridge_north, false)		-- remove the bridge's invulnerability
	
end

-- while they're in the perpetual fight with the allies, top up any bridge defenders that get killed
function NorthBridge_TopUpDefenders_TeamWeapons(data)

	-- only do this if we haven't triggered the fallback from the field to the bridge yet
	if northbridge_approached_by_player == false then
		
		if SGroup_Count(data.sgroup) == 0 then
			
			if SyncWeapon_Exists(data.swid) == false then
				
				Util_CreateSquads(player2, data.sgroup, data.sbp, mkr_east_spawn1, data.marker, nil, nil, nil, data.facing)
				SGroup_AddGroup(sg_northbridge_all, data.sgroup)
				data.swid = SyncWeapon_GetFromSGroup(data.sgroup)
				
			else
				
				if SyncWeapon_IsOwnedByPlayer(data.swid, player2) and Entity_IsPartOfSquad(SyncWeapon_GetEntity(data.swid)) then		-- recrew group has recrewed the gun
					
					-- rebind the hmg to the group
					SGroup_Single(data.sgroup, Entity_GetSquad(SyncWeapon_GetEntity(data.swid)))
					SGroup_AddGroup(sg_northbridge_all, data.sgroup)
					SGroup_RemoveGroup(data.recrew_sgroup, data.sgroup)
					
					-- give a move command if the gun was picked up somewhere other than it's designated location
					if Util_GetDistance(data.sgroup, data.marker) >= 3 then
						Cmd_Move(data.sgroup, data.marker, nil, nil, data.marker)
					end
					
					-- add the rest of the guys to the general encounter
					enc_NorthBridge:AddSgroup(data.recrew_sgroup)
					SGroup_AddGroup(sg_northbridge_all, data.recrew_sgroup)
					SGroup_Clear(data.recrew_sgroup)
					
					-- restart goal if necessary
					if enc_NorthBridge:HasGoal() == false then
						enc_NorthBridge:RestartGoal()
					end
					
				elseif SGroup_TotalMembersCount(data.recrew_sgroup) <= 2 then															-- need to spawn a group to recrew the gun
					
					-- if there are any remnants in the group, add them to the general encounter
					enc_NorthBridge:AddSgroup(data.recrew_sgroup)
					SGroup_AddGroup(sg_northbridge_all, data.recrew_sgroup)
					SGroup_Clear(data.recrew_sgroup)
					
					-- restart goal if necessary
					if enc_NorthBridge:HasGoal() == false then
						enc_NorthBridge:RestartGoal()
					end
					
					-- spawn a new group
					Util_CreateSquads(player2, data.recrew_sgroup, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_east_spawn1)
					
					-- and command them to go capture the hmg
					EGroup_Single(eg_temp, SyncWeapon_GetEntity(data.swid))
					Cmd_CaptureTeamWeapon(data.recrew_sgroup, eg_temp)
					
				else
					
					-- group is en-route to pick up the gun, so do nothing 
					
				end
				
			end
			
		end
		
		-- check this unit again in a few secs
		Event_Timer(NorthBridge_TopUpDefenders_TeamWeapons, data, 2)
		
	end
	
end









