
-------------------------------------------
-------------------------------------------
-- SEP
--
-- Ryan McGechaen
-- 
-------------------------------------------
-------------------------------------------

import("ScarUtil.scar")

function OnGameSetup()
	player1 = Setup_Player(1, 11049765, "german", 1)		-- LOCDB [11049765] 'Kampfgruppe Kastner'
	player2 = Setup_Player(2, 11049766, "soviet", 2)		-- LOCDB [11049766] 'Soviet 15th Army'
	player3 = Setup_Player(3, 11049765, "german", 1)
end

function OnGameRestore()
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	Game_DefaultGameRestore()
	Util_RestoreMusic()
end

function OnInit()
	
--~ 	g_music_sep = "streamed/music/missions/m01/m01_cue_start.bsc"
	
	print("Simplified Entry Point")
	SEP_Restrictions()
	
	-- Init Objectives
	Rendezvous_Init_Objectives()
	FindArtillery_Init_Objectives()
	SilenceArtillery_Init_Objectives()
	SecureArea_Init_Objectives()
	
	Intro_Init()
	
	Game_FadeToBlack(FADE_OUT, 0)
	Game_SetMode(UI_Cinematic)

end

Scar_AddInit(OnInit)

function SEP_Restrictions()
	
	Player_SetCommandAvailability(player1, SCMD_Retreat, ITEM_LOCKED)
	Player_SetCommandAvailability(player1, SCMD_ReinforceUnit, ITEM_REMOVED)
	
	Player_SetUpgradeAvailability(player1, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM, ITEM_REMOVED)
	Player_SetUpgradeAvailability(player1, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_SECOND, ITEM_REMOVED)
	Player_SetUpgradeAvailability(player1, UPG.GERMAN.GRENADIER_MG42_LMG, ITEM_REMOVED)
	Player_SetUpgradeAvailability(player1, UPG.GERMAN.PANZER_TOP_GUNNER, ITEM_REMOVED)
	
	Player_SetAbilityAvailability(player1, ABILITY.GERMAN.GRENADIER_PANZERFAUST, ITEM_REMOVED)
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("infantry_medkits"), ITEM_REMOVED)
	Player_SetAbilityAvailability(player1, ABILITY.GERMAN.PANZER_PANTHER_TIGER_OSTWIND_BLITZKRIEG, ITEM_REMOVED)
	
	Player_AddAbility(player2, ABILITY.GLOBAL.OFF_MAP_ARTILLERY_PERCISE)
	Player_AddAbility(player2, BP_GetAbilityBlueprint("off_map_artillery_percise_sep"))
	
	Player_SetEntityProductionAvailability(player1, EBP.GERMAN.SLIT_TRENCH_GERMAN, ITEM_REMOVED)
	
	Cmd_Upgrade(player1, UPG.GERMAN.BATTLE_PHASE_2, 1, true)
	Cmd_Upgrade(player2, BP_GetUpgradeBlueprint("disable_abandon_critical"), 1, true)
	Cmd_Upgrade(player1, BP_GetUpgradeBlueprint("shock_prevent_pin"), 1, true)

end

function Intro_Init()
	
--~ 	Util_PlayMusic(g_music_sep, 0, 0)
	
	UI_SetAllowLoadAndSave(false)
	
	Camera_SetInputEnabled(false)
	
	-- SGroups
	sg_player_squad1 = SGroup_CreateIfNotFound("sg_player_squad1")
	sg_player_squad2 = SGroup_CreateIfNotFound("sg_player_squad2")
	sg_player_all = SGroup_CreateIfNotFound("sg_player_all")
	
	-- EGroups
	eg_panzerschreck_abandoned = EGroup_CreateIfNotFound("eg_panzerschreck_abandoned")
	
	EGroup_EnableMinimapIndicator(eg_VP, false)
	
	EGroup_DeSpawn(LAYER_CheckPointMGBlocker)
	
	-- Disable Veterancy
	Modify_PlayerExperienceReceived(player1, 0)
	
	Modify_PlayerResourceRate(player1, RT_Manpower, 0)
	Modify_PlayerResourceRate(player1, RT_Munition, 0)
	Modify_PlayerResourceRate(player1, RT_Fuel, 0)
	Rule_Add(Mission_SetAction)
	
	g_ATsquad1 = nil
	g_munitions = 45
	
	g_firstSectionDone = false
	tmr_singleSelect = "tmr_singleSelect"
	tmr_multiSelect = "tmr_multiSelect"
	
	Modify_AbilityRechargeTime(player1, BP_GetAbilityBlueprint("panzer_grenadier_bundled_tutorial"), 0.35)
	
	-- Add Abilities
	Player_AddAbility(player2, ABILITY.GLOBAL.OFF_MAP_ARTILLERY_PERCISE)
	Player_AddAbility(player2, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT)
	
	-- Restore PG Bundled Grenade
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("tutorial_player_upgrade"))
	Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("tutorial_player_upgrade"))
	
	-- Set EGroups to be Invuln
	EGroup_SetInvulnerable(eg_footbridge, true)
	
	-- Spawn Player Units
	Util_CreateSquads(player1, {sg_player_squad1, sg_player_all}, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_player_squad1_spawn)
	SGroup_SetInvulnerable(sg_player_squad1, true)
	SGroup_SetCrushable(sg_player_squad1, false)
	Modify_SquadCaptureRate(sg_player_squad1, 2)
	
	mod_squad1Vulnerability = Modify_Vulnerability(sg_player_squad1, 0.5)
	mod_squad1Suppression = Modify_ReceivedSuppression(sg_player_squad1, 0.5)
	mod_squad1Range = Modify_WeaponRange(sg_player_squad1, "hardpoint_01", 0.8)
	
	g_fadeOut = false
	
	Util_StartNislet(EVENTS.Intro, _skipIntro, true)
--~ 	Event_NarrativeEventsNotRunning(SEP_StartSitRep, nil, 1)
	Event_NarrativeEventsNotRunning(_sitRep_Finish, nil, 1)

end

function _skipIntro()
	SGroup_WarpToMarker(sg_player_squad1, mkr_player_squad1_dest3)
	sg_skip_tank = SGroup_CreateIfNotFound("sg_skip_tank")
	eg_deadTank = EGroup_CreateIfNotFound("eg_deadTank")
	
	Camera_ClampToMarker(mkr_camLock)
	
	World_GetNeutralEntitiesNearPoint(eg_deadTank, Util_GetPosition(mkr_intro_tankFollow_trig), 30)
	EGroup_Filter(eg_deadTank, BP_GetEntityBlueprint("wrecked_panzer_iv_sdkfz_161"), FILTER_KEEP)
	EGroup_DestroyAllEntities(eg_deadTank)
	
	Util_CreateSquads(player3, sg_skip_tank, SBP.GERMAN.PANZER_IV_SQUAD, mkr_ally_tank1_dest)
	SGroup_Kill(sg_skip_tank)
end

function SEP_StartSitRep()
	if g_fadeOut == true then 
		Util_PlayMovie("m01_sitrep", 2.5, 2.5, _sitRep_Finish, nil, true)
	else
		Util_PlayMovie("m01_sitrep", 0, 2.5, _sitRep_Finish, nil, true)
	end
end

function _sitRep_Finish()
	
	-- Temp fix for pathing
--~ 	SGroup_WarpToMarker(sg_player_squad1, mkr_player_squad1_dest3)
	
	Game_FadeToBlack(FADE_IN, 2.5)
	
	Camera_ClampToMarker(mkr_camLock)

	Game_SetMode(UI_Cinematic)
	
	Squad_RemoveAbility(SGroup_GetSpawnedSquadAt(sg_player_squad1, 1), BP_GetAbilityBlueprint("sp_sprint"))
	Squad_SetReactionPlan(SGroup_GetSpawnedSquadAt(sg_player_squad1, 1), "reaction-plan")

	SGroup_SetInvulnerable(sg_player_squad1, false)
	SGroup_SetInvulnerable(sg_player_squad1, 0.8)
	SGroup_SetSelectable(sg_player_squad1, false)
	
	SGroup_DestroyAllSquads(sg_enemy_squad_intro)
	SGroup_DestroyAllSquads(sg_friendly_squad_all)
	
	Rule_AddOneShot(_sitRep_SetMode, 3)
	
	Mission_KickOff()

end

function _sitRep_SetMode() Game_SetMode(UI_Normal) end

function Mission_SetMunitions()
	if Player_GetResource(player1, RT_Munition) < g_munitions then
		Player_SetResource(player1, RT_Munition, g_munitions)
	end
end
function Mission_SetAction()
	
	Player_SetResource(player1, RT_Action, 0)

end

function Mission_KickOff()

	UI_SetCPMeterVisibility(false)
	
	Objective_Start(OBJ_Rendezvous)

end

function LESSON_SingleSelection()
	if g_firstSectionDone == false then
		if Misc_IsSGroupSelected(sg_player_squad1, ANY) then
			if Timer_Exists(tmr_singleSelect) then
				Timer_End(tmr_singleSelect)
			end
			if hpid_selectSingleSquad ~= nil then
				HintPoint_Remove(hpid_selectSingleSquad)
				hpid_selectSingleSquad = nil
			end
		else
			if hpid_selectSingleSquad == nil then
				if Timer_Exists(tmr_singleSelect) == false then
					Timer_Start(tmr_singleSelect, 8)
					return
				else
					if Timer_GetRemaining(tmr_singleSelect) == 0 then
						Timer_End(tmr_singleSelect)
						hpid_selectSingleSquad = HintPoint_Add(sg_player_squad1, true, 11049763)	-- LOCDB [11049763] 'LEFT-CLICK to select your squad'
					end
				end
			end
		end
	else
		Rule_RemoveMe()
		if Timer_Exists(tmr_singleSelect) then
			Timer_End(tmr_singleSelect)
		end
		if hpid_selectSingleSquad ~= nil then
			HintPoint_Remove(hpid_selectSingleSquad)
			hpid_selectSingleSquad = nil
		end
	end
end

function LESSON_MultiSelection()
	if Misc_IsSGroupSelected(sg_player_squad1, ANY) and Misc_IsSGroupSelected(sg_player_squad2, ANY) then
		-- Both selected
		if Timer_Exists(tmr_multiSelect) then
			Timer_End(tmr_multiSelect)
		end
		if Timer_Exists(tmr_singleSelect) then
			Timer_End(tmr_singleSelect)
		end
		if hpid_selectSquad1 ~= nil then
			HintPoint_Remove(hpid_selectSquad1)
			hpid_selectSquad1 = nil
		end
		if hpid_selectSquad2 ~= nil then
			HintPoint_Remove(hpid_selectSquad2)
			hpid_selectSquad2 = nil
		end
		if hpid_multiSelectSquad1 ~= nil then
			HintPoint_Remove(hpid_multiSelectSquad1)
			hpid_multiSelectSquad1 = nil
		end
		if hpid_multiSelectSquad2 ~= nil then
			HintPoint_Remove(hpid_multiSelectSquad2)
			hpid_multiSelectSquad2 = nil
		end
	elseif Misc_IsSGroupSelected(sg_player_squad1, ANY) == false and Misc_IsSGroupSelected(sg_player_squad2, ANY) == false then
		-- Neither selected
		if Timer_Exists(tmr_multiSelect) then
			Timer_End(tmr_multiSelect)
		end
		if hpid_multiSelectSquad1 ~= nil then
			HintPoint_Remove(hpid_multiSelectSquad1)
			hpid_multiSelectSquad1 = nil
		end
		if hpid_multiSelectSquad2 ~= nil then
			HintPoint_Remove(hpid_multiSelectSquad2)
			hpid_multiSelectSquad2 = nil
		end
		if hpid_selectSquad1 == nil and hpid_selectSquad2 == nil then
			if Timer_Exists(tmr_singleSelect) == false then
				Timer_Start(tmr_singleSelect, 8)
				return
			else
				if Timer_GetRemaining(tmr_singleSelect) == 0 then
					Timer_End(tmr_singleSelect)
					hpid_selectSquad1 = HintPoint_Add(sg_player_squad1, true, 11049763)
					hpid_selectSquad2 = HintPoint_Add(sg_player_squad2, true, 11049763)
				end
			end
		end
	elseif Misc_IsSGroupSelected(sg_player_squad1, ANY) == false and Misc_IsSGroupSelected(sg_player_squad2, ANY) then
		-- First squad not selected, second is
		if Timer_Exists(tmr_singleSelect) then
			Timer_End(tmr_singleSelect)
		end
		if hpid_multiSelectSquad2 ~= nil then
			HintPoint_Remove(hpid_multiSelectSquad2)
			hpid_multiSelectSquad2 = nil
		end
		if hpid_selectSquad1 ~= nil then
			HintPoint_Remove(hpid_selectSquad1)
			hpid_selectSquad1 = nil
		end
		if hpid_selectSquad2 ~= nil then
			HintPoint_Remove(hpid_selectSquad2)
			hpid_selectSquad2 = nil
		end
		if hpid_multiSelectSquad1 == nil then
			if Timer_Exists(tmr_multiSelect) == false then
				Timer_Start(tmr_multiSelect, 4)
				return
			else
				if Timer_GetRemaining(tmr_multiSelect) == 0 then
					Timer_End(tmr_multiSelect)
					hpid_multiSelectSquad1 = HintPoint_Add(sg_player_squad1, true, 11049764)	-- LOCDB [11049764] 'Hold SHIFT and LEFT-CLICK to select your second squad'
				end
			end
		end
	elseif Misc_IsSGroupSelected(sg_player_squad1, ANY) and Misc_IsSGroupSelected(sg_player_squad2, ANY) == false then
		-- Second squad not selected, first is
		if Timer_Exists(tmr_singleSelect) then
			Timer_End(tmr_singleSelect)
		end
		if hpid_multiSelectSquad1 ~= nil then
			HintPoint_Remove(hpid_multiSelectSquad1)
			hpid_multiSelectSquad1 = nil
		end
		if hpid_selectSquad1 ~= nil then
			HintPoint_Remove(hpid_selectSquad1)
			hpid_selectSquad1 = nil
		end
		if hpid_selectSquad2 ~= nil then
			HintPoint_Remove(hpid_selectSquad2)
			hpid_selectSquad2 = nil
		end
		if hpid_multiSelectSquad2 == nil then
			if Timer_Exists(tmr_multiSelect) == false then
				Timer_Start(tmr_multiSelect, 4)
				return
			else
				if Timer_GetRemaining(tmr_multiSelect) == 0 then
					Timer_End(tmr_multiSelect)
					hpid_multiSelectSquad2 = HintPoint_Add(sg_player_squad2, true, 11049764)
				end
			end
		end
	end
end

function LESSON_Casualties()
	Player_GetAll(player2)
	
	_casualtyEntity = nil
	
	local _findCasualties = function(gid, idx, eid)
		if Entity_IsCasualty(eid) and Misc_IsEntityOnScreen(eid, 0.8) then
			_casualtyEntity = eid
			return
		end
	end
	
	EGroup_ForEach(eg_allentities, _findCasualties)
	
	if _casualtyEntity ~= nil then 
		Entity_SetInvulnerable(_casualtyEntity, true, 3)
		Rule_RemoveMe()
		Rule_AddOneShot(LESSON_Casualties_Mark, 2)
		return
	end
end

function LESSON_Casualties_Mark()
	hpid_casualty = HintPoint_Add(_casualtyEntity, true, 11050138, 0)	-- LOCDB [11050138] 'Enemy casualties provide vision to their team.\n Either kill them or wait until they bleed out'
	Entity_SetInvulnerable(_casualtyEntity, false, -1)
end

----------------------
----------------------
-- FIRST BEAT
function Rendezvous_Init_Objectives()

	OBJ_Rendezvous = {
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			hpid_selectSquad = HintPoint_Add(sg_player_squad1, true, 11049438, 1) -- LOCDB [11049438] 'LEFT-CLICK squads to select them'
			SGroup_SetSelectable(sg_player_squad1, true)
			Rule_AddInterval(LESSON_Select_SquadSelected, 1)
			
			SGroup_SetAutoTargetting(sg_player_squad1, "hardpoint_01", true)
			
			World_EnableSharedLineOfSight(player1, player3, false)
			
			-- Pre-spawn the Maxim
			sg_enemy_road_final = SGroup_CreateIfNotFound("sg_enemy_road_final")
			sg_enemy_suppressionHMG = SGroup_CreateIfNotFound("sg_enemy_suppressionHMG")
			Util_CreateSquads(player2, {sg_enemy_suppressionHMG, sg_enemy_road_final}, SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD, mkr_enemy_road_HMG_spawn, nil, 1, 5)
			Cmd_InstantSetupTeamWeapon(sg_enemy_suppressionHMG)
			Util_LogSyncWpn(sg_enemy_suppressionHMG, true)
			
			sg_enemy_squad4 = SGroup_CreateIfNotFound("sg_enemy_squad4")
			Util_CreateSquads(player2, {sg_enemy_squad4, sg_enemy_road_final}, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_enemy_road_HMG_defenders)
			
			SGroup_Hide(sg_enemy_road_final, true)
			SGroup_EnableMinimapIndicator(sg_enemy_road_final, false)
			
			-- Spawn the first enemy squad
			sg_enemy_squad1 = SGroup_CreateIfNotFound("sg_enemy_squad1")
			Util_CreateSquads(player2, sg_enemy_squad1, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_enemy_road_dest01)
			Modify_WeaponRange(sg_enemy_squad1, "hardpoint_01", 0.8)
		end,
		
		OnComplete = function()
			
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.ObjectiveA_Start,
		Intel_Complete = nil,
		Intel_Fail = nil,				
		Title = 11049565,				-- LOCDB [11049565] 'Rendezvous with Second Squad at the Bridge'
		Type = OT_Primary,				
	}
	Objective_Register(OBJ_Rendezvous)
	
	SOBJ_EliminateSoviets = Objective_QuickSub(OBJ_Rendezvous, 11049566, OT_Primary)	-- LOCDB [11049566] 'Eliminate Soviets along the road'
	SOBJ_RescueSecondSquad = Objective_QuickSub(OBJ_Rendezvous, 11049567, OT_Primary)	-- LOCDB [11049567] 'Kill Soviet Heavy Machinegun'

end

function LESSON_Select_SquadSelected()
	if Misc_IsSGroupSelected(sg_player_squad1, ANY) then
		Rule_RemoveMe()
		
		Camera_SetInputEnabled(true)
		
		HintPoint_Remove(hpid_selectSquad)
		
		Rule_AddOneShot(LESSON_Move_ToPosition, 1)
		
		tmr_lesson_cameraCheck = "tmr_lesson_cameraCheck"
		Timer_Start(tmr_lesson_cameraCheck, 15)
		
		
		Rule_Add(LESSON_SingleSelection)
	end
end

function LESSON_Camera_CheckMovement()
	if Timer_GetRemaining(tmr_lesson_cameraCheck) == 0 then
		Rule_RemoveMe()
		if Marker_InProximity(mkr_player_squad1_dest3, Camera_GetCurrentTargetPos()) then
			Util_MissionTitle(11049769, 2.5, 4, 2.5)	-- LOCDB [11049769] 'Pan the camera with the mouse or arrow keys'
		end
	end
end

function LESSON_Move_ToPosition()
	hpid_moveToPosition = HintPoint_Add(mkr_moveTarget, true, 11049943, nil, HPAT_Movement)	-- LOCDB [11049943] 'RIGHT-CLICK to issue a move order'
	Event_PlayerCanSeeElement(LESSON_Combat_AttackFirstSquad, nil, player1, sg_enemy_squad1, ANY, 1)
	Rule_AddSGroupEvent(LESSON_Move_RemoveHintPoint, sg_player_squad1, GE_SquadCommandIssued)
end

function LESSON_Move_RemoveHintPoint(squad, command, target)
	if command == SCMD_Move or command == SCMD_AttackMove then
		Rule_RemoveMe()
		
		HintPoint_Remove(hpid_moveToPosition)
	end
end

-- LOCDB [11049441] 'RIGHT-CLICK the ground to issue move orders'
function LESSON_Combat_AttackFirstSquad()
	Cmd_Stop(sg_player_squad1)
	Camera_MoveTo(mkr_firstEnemy_pan, true, 0.3, false, true)
	
	Objective_Start(SOBJ_EliminateSoviets)
	
	hpid_attackFirstSquad = HintPoint_Add(sg_enemy_squad1, true, 11049472, 1, HPAT_Attack)	-- LOCDB [11049472] 'RIGHT-CLICK enemy squads and units to issue attack orders'
	Rule_AddSGroupEvent(LESSON_Combat_FirstSquadAttacked, sg_player_squad1, GE_SquadCommandIssued)
	Rule_Add(LESSON_Combat_AutoAttacked)
end

function LESSON_Combat_FirstSquadAttacked(squad, command, target)
	if command == SCMD_Attack then
		Rule_Remove(LESSON_Combat_AutoAttacked)
		Rule_RemoveSGroupEvent(LESSON_Combat_FirstSquadAttacked, sg_player_squad1)
		
		Modifier_RemoveAllFromSGroup(sg_enemy_squad1)
		Modify_Vulnerability(sg_enemy_squad1, 2)
		
		Modifier_Remove(mod_squad1Range)
		
		local pos = Util_GetPositionFromAtoB(Util_GetPosition(sg_enemy_squad1), Util_GetPosition(sg_player_squad1), 0.75)
		Camera_MoveTo(pos, true, 0.3, false, true)
		
		HintPoint_Remove(hpid_attackFirstSquad)
		hpid_killSquad = Objective_AddUIElements(SOBJ_EliminateSoviets, sg_enemy_squad1, true, 11049566, true, 1)
		
		Event_GroupIsDead(LESSON_Cover_MoveToHeavy, nil, sg_enemy_squad1, 1)
	end
end

function LESSON_Combat_AutoAttacked()
	if SGroup_IsDoingAttack(sg_player_squad1, ANY, 3)
	  or SGroup_IsDoingAttack(sg_enemy_squad1, ANY, 3) then
		Rule_RemoveMe()
		Rule_RemoveSGroupEvent(LESSON_Combat_FirstSquadAttacked, sg_player_squad1)
		
		Modifier_RemoveAllFromSGroup(sg_enemy_squad1)
		Modify_Vulnerability(sg_enemy_squad1, 2)
		
		Modifier_Remove(mod_squad1Range)
		
		local pos = Util_GetPositionFromAtoB(Util_GetPosition(sg_enemy_squad1), Util_GetPosition(sg_player_squad1), 0.75)
		Camera_MoveTo(pos, true, 0.3, false, true)
		
		HintPoint_Remove(hpid_attackFirstSquad)
		hpid_killSquad = Objective_AddUIElements(SOBJ_EliminateSoviets, sg_enemy_squad1, true, 11049566, true, 1)
		
		Event_GroupIsDead(LESSON_Cover_MoveToHeavy, nil, sg_enemy_squad1, 1)
	end
end

function LESSON_Cover_MoveToHeavy()
print("LESSON_Cover_MoveToHeavy")
	if (hpid_moveToHeavyCover == nil) then
		Util_StartIntel(EVENTS.MoveUp)
		Camera_MoveTo(mkr_secondEnemy_pan, true, 0.3, false, true)
		
		hpid_moveToHeavyCover = HintPoint_Add(mkr_heavyCover, true, 11049944, nil, HPAT_Movement) -- LOCDB [11049944] 'Order your squad to move into cover'
		Event_Proximity(LESSON_Cover_SquadInHeavyCover, nil, sg_player_squad1, mkr_heavyCover, 5, ANY)
	end
end

function LESSON_Cover_SquadInHeavyCover()
	HintPoint_Remove(hpid_moveToHeavyCover)
	Rule_AddOneShot(LESSON_Cover_TeachHeavy, 1)
	
	Rule_AddOneShot(Rendezvous_Spawn_Second_Enemy, 2)
end

function LESSON_Cover_TeachHeavy()
	hpid_heavyCover = HintPoint_Add(sg_player_squad1, true, 11049447, 1, HPAT_CoverGreen) -- LOCDB [11049447] 'Squads with a Green Shield on their icon are in Heavy Cover'
	Rule_AddOneShot(LESSON_Cover_RemoveHeavyHint, 5)
end

function LESSON_Cover_RemoveHeavyHint()
	HintPoint_Remove(hpid_heavyCover)
end

function Rendezvous_Spawn_Second_Enemy()
	sg_enemy_squad2 = SGroup_CreateIfNotFound("sg_enemy_squad2")
	Util_CreateSquads(player2, sg_enemy_squad2, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_enemy_road_spawn, mkr_enemy_road_dest02)
	SGroup_AddAbility(sg_enemy_squad2, BP_GetAbilityBlueprint("sp_sprint"))
	Cmd_Ability(sg_enemy_squad2, BP_GetAbilityBlueprint("sp_sprint"), nil, true, true)
	
	Event_PlayerCanSeeElement(LESSON_Combat_AttackSecondSquad, nil, player1, sg_enemy_squad2, ANY, 2)
	Event_GroupIsDead(Rendezvous_Spawn_Third_Enemy, nil, sg_enemy_squad2, 0.5)
end

function LESSON_Combat_AttackSecondSquad()
	hpid_attackSecondSquad = HintPoint_Add(sg_enemy_squad2, true, 11049945, 1) -- LOCDB [11049945] 'Squads will automatically attack any units within range'
	Rule_AddSGroupEvent(LESSON_Combat_SecondSquadAttacked, sg_player_squad1, GE_SquadCommandIssued)
	Rule_AddOneShot(LESSON_Combat_SecondSquadAttackedTimeout, 6)
end

function LESSON_Combat_SecondSquadAttacked(squad, command, target)
	if command == SCMD_Attack and target == sg_enemy_squad2 then
		Rule_RemoveMe()
		if Rule_Exists(LESSON_Combat_SecondSquadAttackedTimeout) then Rule_Remove(LESSON_Combat_SecondSquadAttackedTimeout) end
		
		HintPoint_Remove(hpid_attackSecondSquad)
		hpid_killSquad = Objective_AddUIElements(SOBJ_EliminateSoviets, sg_enemy_squad2, true, 11049566, true, 1)
	end
end

function LESSON_Combat_SecondSquadAttackedTimeout()
	if SGroup_IsEmpty(sg_enemy_squad2) == false then
		Rule_RemoveSGroupEvent(LESSON_Combat_SecondSquadAttacked, sg_player_squad1)
		
		HintPoint_Remove(hpid_attackSecondSquad)
		hpid_killSquad = Objective_AddUIElements(SOBJ_EliminateSoviets, sg_enemy_squad2, true, 11049566, true, 1)
	end
end

function Rendezvous_Spawn_Third_Enemy()
	print("Rendezvous_Spawn_Third_Enemy")
	sg_enemy_squad3 = SGroup_CreateIfNotFound("sg_enemy_squad3")
	Util_CreateSquads(player2, sg_enemy_squad3, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_enemy_road_spawn, mkr_enemy_road_dest03)
	SGroup_AddAbility(sg_enemy_squad3, BP_GetAbilityBlueprint("sp_sprint"))
	Cmd_Ability(sg_enemy_squad3, BP_GetAbilityBlueprint("sp_sprint"), nil, true, true)
	SGroup_SetInvulnerable(sg_enemy_squad3, 0.9)
	
	Rule_AddInterval(LESSON_Combat_GrenadeEnemySquad, 1)
end

function LESSON_Combat_GrenadeEnemySquad()
	if Player_CanSeeSGroup(player1, sg_enemy_squad3, ANY) and Prox_AreSquadsNearMarker(sg_enemy_squad3, mkr_enemy_road_dest03, ANY, 5) then
		Rule_RemoveMe()
		
		Util_StartIntel(EVENTS.GrenadeUse)
		Event_NarrativeEventsNotRunning(LESSON_Combat_UnlockGrenade, nil)
	elseif (SGroup_IsIdle(sg_enemy_squad3, ANY)) then
		
		Cmd_Move(sg_enemy_squad3, mkr_enemy_road_dest03, false)
		
	end
end

function LESSON_Combat_UnlockGrenade()
	Rule_AddInterval(LESSON_Casualties, 1)
	
	Player_SetResource(player1, RT_Munition, 45)
	Player_SetAbilityAvailability(player1, ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_GRENADE, ITEM_DEFAULT)
	UI_NewHUDFeature(HUDF_AbilityCard, 11049519, "Icons_abilities_ability_german_bundled_grenade", 5)	-- LOCDB [11049519] 'LEFT-CLICK the Grenade Ability'
	fpid_grenade = UI_FlashAbilityButton(BP_GetAbilityBlueprint("panzer_grenadier_bundled_tutorial"), false)
	
	Rule_AddInterval(Mission_SetMunitions, 1)
	
	hpid_grenadeSquad = HintPoint_Add(sg_enemy_squad3, true, 11049453, 1, nil, "Icons_abilities_ability_german_bundled_grenade")
	Rule_AddSGroupEvent(LESSON_Combat_GrenadeThrown, sg_player_squad1, GE_AbilityExecuted)
end

function LESSON_Combat_GrenadeThrown(squad, ability, target)
	if ability == BP_GetAbilityBlueprint("panzer_grenadier_bundled_tutorial")
	  and (target == sg_enemy_squad3 
		  or Marker_InProximity(mkr_enemy_road_dest03, target)
		  or Prox_AreSquadsNearMarker(sg_enemy_squad3, Util_GetPosition(target), ANY, 5)) then
		Rule_RemoveMe()
		
		UI_StopFlashing(fpid_grenade)
		
		HintPoint_Remove(hpid_grenadeSquad)
		hpid_killSquad = Objective_AddUIElements(SOBJ_EliminateSoviets, sg_enemy_squad3, true, 11049566, true, 1)
		Rule_AddOneShot(Rendezvous_VulnThirdSquad, 1.5)
	end
end

function Rendezvous_VulnThirdSquad()
	SGroup_SetInvulnerable(sg_enemy_squad3, false)
	
	Event_GroupIsDead(Rendezvous_Complete_FirstObjective, nil, sg_enemy_squad3, 1.5)
end

function Rendezvous_Complete_FirstObjective()
	Objective_Complete(SOBJ_EliminateSoviets)
	
	g_firstSectionDone = true
	
	hpid_roadUI = Objective_AddUIElements(OBJ_Rendezvous, mkr_road_UI, true, 11049565, true)
	
	World_IncreaseInteractionStage()
	
	Util_CreateSquads(player3, sg_player_squad2, SBP.GERMAN.GRENADIER_SQUAD, mkr_player_squad2_spawn)
	SGroup_SetInvulnerable(sg_player_squad2, true)
	SGroup_SetSuppression(sg_player_squad2, 500)
	Modify_SquadCaptureRate(sg_player_squad2, 2)
	
	Cmd_Attack(sg_enemy_squad4, sg_player_squad2, false, true)
	
	-- Disable the Autotargetting
	SGroup_SetAutoTargetting(sg_player_squad1, "hardpoint_01", false)
	
	Event_Proximity(Rendezvous_Start_SecondObjective, nil, sg_player_squad1, mkr_road_trig_secondObj, nil, ANY)
	Event_Proximity(Rendezvous_UnHideEnemyUnits, nil, player1, mkr_unHide_enemyUnits, nil, ANY)
end

function LESSON_Grenade_RemoveHint() HintPoint_Remove(hpid_grenadeRemind) end

function Rendezvous_Start_SecondObjective()
	Cmd_Stop(sg_player_squad1)
	Game_SetMode(UI_Cinematic)
	Util_StartIntel(EVENTS.Suppressed)
	
	World_EnableSharedLineOfSight(player1, player3, true)
	
	Objective_RemoveUIElements(OBJ_Rendezvous, hpid_roadUI)
	
	Event_NarrativeEventsNotRunning(Rendezvous_Kickoff_SecondObjective, nil)
end

function Rendezvous_UnHideEnemyUnits()
	SGroup_Hide(sg_enemy_road_final, false)
	SGroup_EnableMinimapIndicator(sg_enemy_road_final, true)
end

function Rendezvous_Kickoff_SecondObjective()
	eventID_suppression = Event_GroupIsSuppressed(LESSON_Player_Suppressed, nil, sg_player_squad1, ANY, 1)
	
	Camera_MoveTo(sg_player_squad1, true, 0.3, false, true)
	
	-- Start the Hint
	Event_Timer(LESSON_Grenade_Remind, nil, 10)
	
	Objective_Start(SOBJ_RescueSecondSquad)
	hpid_hmg = Objective_AddUIElements(SOBJ_RescueSecondSquad, sg_enemy_suppressionHMG, true, 11049567, true, 1)
	SGroup_SetAutoTargetting(sg_player_squad1, "hardpoint_01", true)
	
	Rule_AddSGroupEvent(Rendezvous_EnemySquadAttackPlayer, sg_player_squad1, GE_SquadCommandIssued)
	Event_GroupIsDead(Rendezvous_HMG_Dead, nil, sg_enemy_suppressionHMG, 1)
	Event_GroupIsDead(Rendezvous_Complete_Check, nil, sg_enemy_road_final, 2, true)
end

function LESSON_Player_Suppressed()
	-- LOCDB [11049979] 'Squads with flashing '!' indicate they are suppressed.\nSuppressed squads crawl and are less combat effective.'
	if SGroup_IsSuppressed(sg_player_squad1, ANY) then
		if hpid_suppressed == nil then
			hpid_suppressed = HintPoint_Add(sg_player_squad1, true, 11049979, 1)
			Event_GroupIsNotSuppressed(LESSON_Player_NotSuppressed, nil, sg_player_squad1, ANY, 1)
		end
	elseif SGroup_IsEmpty(sg_player_squad2) == false and SGroup_IsSuppressed(sg_player_squad2, ANY) then
		if hpid_suppressed == nil then
			hpid_suppressed = HintPoint_Add(sg_player_squad1, true, 11049979, 1)
			Event_GroupIsNotSuppressed(LESSON_Player_NotSuppressed, nil, sg_player_squad2, ANY, 1)
		end
	end
	if Event_Exists(eventID_suppression_01) then Event_Remove(eventID_suppression_01) end
	if Event_Exists(eventID_suppression_02) then Event_Remove(eventID_suppression_02) end
end

function LESSON_Player_NotSuppressed()
	HintPoint_Remove(hpid_suppressed)
	hpid_suppressed = nil
end

function Rendezvous_HMG_Dead()
	if SGroup_IsEmpty(sg_enemy_squad4) == false then
		Cmd_Retreat(sg_enemy_squad4, mkr_secondSquad_retreat, mkr_secondSquad_retreat)
		
		if Event_Exists(eventID_suppression) then Event_Remove(eventID_suppression) end
	end
end

function LESSON_Grenade_Remind()
	if SGroup_IsEmpty(sg_enemy_squad4) == false then
		hpid_grenadeRemind = HintPoint_Add(sg_enemy_squad4, false, 11049753) -- LOCDB [11049753] 'Use Grenades against squads in cover'
		Rule_AddOneShot(LESSON_Grenade_RemoveHint, 5)
	end
end

function Rendezvous_EnemySquadAttackPlayer(squad, command, target)
	if command == SCMD_Attack then
		Rule_RemoveMe()
		
		Cmd_Attack(sg_enemy_squad4, sg_player_squad1, false, true)
	end
end

function Rendezvous_Complete_Check()
	SGroup_SetSuppression(sg_player_squad2, 0)
	
	Objective_Complete(OBJ_Rendezvous)
	
	-- Kickoff the Checkpoint
	FindArtillery_Checkpoint_Init()
	Event_NarrativeEventsNotRunning(FindArtillery_Kickoff, nil, 1)
end

----------------------
----------------------
-- Second BEAT
function FindArtillery_Init_Objectives()

	OBJ_FindArtillery = {
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			World_IncreaseInteractionStage()
			Event_Proximity(FindArtillery_TargetBridge, nil, player1, mkr_bridgeArty_trig, 23, ANY)
			g_multiSelect = true
		end,
		
		OnComplete = function()
			
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.ObjectiveB_Start,
		Intel_Complete = nil,
		Intel_Fail = nil,				
		Title = 11049614,				-- LOCDB [11049614] 'Locate the Artillery Battery'
		Type = OT_Primary,				
	}
	Objective_Register(OBJ_FindArtillery)
	
	SOBJ_FindAlternateCrossing = Objective_QuickSub(OBJ_FindArtillery, 11049615, OT_Primary)	-- LOCDB [11049615] 'Find an Alternate Crossing'
	SOBJ_RetrieveATWeapon = Objective_QuickSub(OBJ_FindArtillery, 11049617, OT_Primary)	-- LOCDB [11049617] 'Retrieve the Anti-Tank Rifle'

end

function FindArtillery_Kickoff()
	Objective_Start(OBJ_FindArtillery)
end

function FindArtillery_Checkpoint_Init()
	sg_enemy_checkpoint = SGroup_CreateIfNotFound("sg_enemy_checkpoint")
	sg_enemy_hmg02 = SGroup_CreateIfNotFound("sg_enemy_hmg02")
	Util_CreateSquads(player2, {sg_enemy_hmg02, sg_enemy_checkpoint}, SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD, mkr_enemy_hmg02)
	Util_LogSyncWpn(sg_enemy_checkpoint, true)
	Cmd_InstantSetupTeamWeapon(sg_enemy_hmg02)
	mod_hmgRange = Modify_WeaponRange(sg_enemy_hmg02, "hardpoint_01", 0.25)
	
	sg_enemy_squad5 = SGroup_CreateIfNotFound("sg_enemy_squad5")
	Util_CreateSquads(player2, {sg_enemy_squad5, sg_enemy_checkpoint}, SBP.SOVIET.GUARDS_TROOPS, mkr_enemy_squad5_spawn, nil, 1, 6, false, nil, UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP)
	SGroup_AddSlotItemToDropOnDeath(sg_enemy_squad5, SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP, 1.0, true)
	SGroup_SetInvulnerable(sg_enemy_squad5, 0.9)
end

function FindArtillery_TargetBridge()
	Cmd_Ability(player2, BP_GetAbilityBlueprint("off_map_artillery_percise_sep"), mkr_bridgeArty, nil, true)
	Rule_AddOneShot(FindArtillery_Warn, 3)
	FindArtillery_MoveAway()
	Rule_AddOneShot(FindArtillery_BridgeKill, 18)
end

function FindArtillery_MoveAway()
	Misc_SelectSquad(SGroup_GetSpawnedSquadAt(sg_player_squad1, 1), false)
	Misc_SelectSquad(SGroup_GetSpawnedSquadAt(sg_player_squad2, 1), false)
	Cmd_Move(sg_player_squad1, mkr_player_safe_01)
	Cmd_Move(sg_player_squad2, mkr_player_safe_02)
	
	EGroup_ReSpawn(LAYER_CheckPointMGBlocker)
end

function FindArtillery_Warn()
	Rule_AddOneShot(LESSON_RedSmoke_MarkHint, 1)

	Util_StartIntel(EVENTS.BridgeTarget)
end

function LESSON_RedSmoke_MarkHint()
	hpid_redSmoke = HintPoint_Add(mkr_bridgeArty, true, 11049971, nil, HPAT_Hint)	-- LOCDB [11049971] 'Red Smoke warns of incoming enemy abilities like Artillery'
	Rule_AddOneShot(LESSON_RedSmoke_RemoveHint, 8)
end

function LESSON_RedSmoke_RemoveHint()
	HintPoint_Remove(hpid_redSmoke)
end

function FindArtillery_BridgeKill()
	EGroup_Kill(eg_bridge)
	
	Objective_Start(SOBJ_FindAlternateCrossing)
	hpid_altCrossing = Objective_AddUIElements(SOBJ_FindAlternateCrossing, mkr_altCrossing_UI, true, 11049615, true)	-- LOCDB [11049618] 'Alternate Crossing Route'
	
	Event_Proximity(FindArtillery_CrossingReached, nil, player1, mkr_altCrossing_UI, 10, ANY, 2)
	Event_Proximity(LESSON_Cover_CratersProvideCover, nil, player1, mkr_crater_cover, 17, ANY)
	Event_Proximity(FindArtillery_GuardsAttack, nil, player1, mkr_guards_attack_trig, 14.75, ANY)
	Event_GroupIsDead(FindArtillery_CheckpointDead, nil, sg_enemy_checkpoint, 1)
end

function FindArtillery_CrossingReached()
	Objective_RemoveUIElements(SOBJ_FindAlternateCrossing, hpid_altCrossing)
	Objective_Complete(SOBJ_FindAlternateCrossing)
	
	Modifier_Remove(mod_hmgRange)
	
	hpid_findArtillery = Objective_AddUIElements(OBJ_FindArtillery, mkr_findArtillery_UI, true, 11049614, true)
end

function LESSON_Cover_CratersProvideCover()
	hpid_craterCover = HintPoint_Add(mkr_crater_cover, true, 11049450, nil, HPAT_CoverYellow) -- LOCDB [11049450] 'Some terrain features, like craters, provide natural cover'
	Rule_AddOneShot(LESSON_Cover_RemoveCraterHint, 5)
end

function LESSON_Cover_RemoveCraterHint()
	HintPoint_Remove(hpid_craterCover)
end

function FindArtillery_GuardsAttack()
	Cmd_Move(sg_enemy_squad5, mkr_enemy_squad5_dest)
	Event_PlayerCanSeeElement(LESSON_Cover_NegativeCover, nil, player1, sg_enemy_squad5, ANY, 6)
end

function LESSON_Cover_NegativeCover()
	SGroup_SetInvulnerable(sg_enemy_squad5, false)
	Modify_ReceivedDamage(sg_enemy_squad5, 1.3)
	hpid_negativeCover = HintPoint_Add(sg_enemy_squad5, true, 11049448, 1, HPAT_CoverRed) -- LOCDB [11049448] 'Squads with a Red Shield on their icon are in Negative Cover and exposed'
	Rule_AddOneShot(LESSON_Cover_RemoveNegativeCoverHint, 8)
end

function LESSON_Cover_RemoveNegativeCoverHint()
	if SGroup_IsEmpty(sg_enemy_squad5) == false then
		HintPoint_Remove(hpid_negativeCover)
	end
end

function FindArtillery_CheckpointDead()
	Objective_Complete(SOBJ_FindAlternateCrossing)
	
	Util_StartIntel(EVENTS.CheckpointDestroyed)
	
	World_GetNeutralEntitiesNearMarker(eg_panzerschreck_abandoned, mkr_atWeapon)
	EGroup_Filter(eg_panzerschreck_abandoned, BP_GetEntityBlueprint("soviet_guard_ptrs"), FILTER_KEEP)
	EGroup_SetInvulnerable(eg_panzerschreck_abandoned, true)
	
	hpid_weapon = HintPoint_Add(eg_panzerschreck_abandoned, true, 11049463, nil, nil, "Icons_tooltips_pick_up_item") -- LOCDB [11049463] 'Select a squad and RIGHT-CLICK on this Anti-Tank Rifle to pick it up'
	Rule_Add(FindArtillery_SquadHasSlotItem)
end

function FindArtillery_SquadHasSlotItem()
	if Squad_HasSlotItem(SGroup_GetSpawnedSquadAt(sg_player_squad1, 1), SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP) then
		g_ATsquad1 = sg_player_squad1
	elseif Squad_HasSlotItem(SGroup_GetSpawnedSquadAt(sg_player_squad2, 1), SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP) then
		g_ATsquad1 = sg_player_squad2
	end
	
	if g_ATsquad1 ~= nil then
		Rule_RemoveMe()
		
		SilenceArtillery_Init()
		
		Util_StartIntel(EVENTS.ArtyEncounter)
		
		World_IncreaseInteractionStage()
		
		Rule_AddInterval(SilenceArtillery_FireArty, 1)
		
		Event_PlayerCanSeeElement(FindArtillery_Complete, nil, player1, sg_artillery_defenders, ANY)
	end
end

function FindArtillery_Complete()
	Objective_Complete(OBJ_FindArtillery)
	
	Rule_Remove(LESSON_MultiSelection)
	-- Clean up MultiSelection
	if Timer_Exists(tmr_multiSelect) then
		Timer_End(tmr_multiSelect)
	end
	if Timer_Exists(tmr_singleSelect) then
		Timer_End(tmr_singleSelect)
	end
	if hpid_selectSquad1 ~= nil then
		HintPoint_Remove(hpid_selectSquad1)
		hpid_selectSquad1 = nil
	end
	if hpid_selectSquad2 ~= nil then
		HintPoint_Remove(hpid_selectSquad2)
		hpid_selectSquad2 = nil
	end
	if hpid_multiSelectSquad1 ~= nil then
		HintPoint_Remove(hpid_multiSelectSquad1)
		hpid_multiSelectSquad1 = nil
	end
	if hpid_multiSelectSquad2 ~= nil then
		HintPoint_Remove(hpid_multiSelectSquad2)
		hpid_multiSelectSquad2 = nil
	end
	
	Rule_Add(LESSON_Squad_Suppressed_2)
	
	Event_NarrativeEventsRunning(SilenceArtillery_Kickoff, nil, 2)
end

function LESSON_Squad_Suppressed_2()
	if SGroup_IsSuppressed(sg_player_squad1, ANY) then
		Rule_RemoveMe()
		hpid_suppressed_2 = HintPoint_Add(sg_player_squad1, true, 11049979, 1)
		Event_GroupIsNotSuppressed(LESSON_Player_NotSuppressed_2, nil, sg_player_squad1, ANY, 2)
	elseif SGroup_IsSuppressed(sg_player_squad2, ANY) then
		Rule_RemoveMe()
		hpid_suppressed_2 = HintPoint_Add(sg_player_squad2, true, 11049979, 1)
		Event_GroupIsNotSuppressed(LESSON_Player_NotSuppressed_2, nil, sg_player_squad2, ANY, 2)
	end
end

function LESSON_Player_NotSuppressed_2()
	HintPoint_Remove(hpid_suppressed_2)
	hpid_suppressed_2 = nil
end

----------------------
----------------------
-- Third BEAT
function SilenceArtillery_Init_Objectives()

	OBJ_SilenceArtillery = {
		SetupUI = function() 
			hpid_arty01 = Objective_AddUIElements(OBJ_SilenceArtillery, sg_artillery_01, true, 11049619, true, 2.5)
			hpid_arty02 = Objective_AddUIElements(OBJ_SilenceArtillery, sg_artillery_02, true, 11049619, true, 2.5)
		end,
		
		OnStart = function()
			if Rule_Exists(LESSON_Casualties) == false then Rule_AddInterval(LESSON_Casualties, 1) end
			
			Objective_Start(SOBJ_ArtilleryDestroyed, false)
			Objective_SetCounter(SOBJ_ArtilleryDestroyed, 0, 2)
			
			FOW_RevealArea(Util_GetPosition(sg_artillery_01), 4, -1)
			FOW_RevealArea(Util_GetPosition(sg_artillery_02), 4, -1)
			
			Rule_AddOneShot(SilenceArtillery_Halftrack, 8)
			Event_PlayerCanSeeElement(LESSON_AntiTank_MarkATSquad, nil, player1, sg_artillery_halftrack, ANY, 2)
			Event_GroupIsDead(SilenceArtillery_GunsDead, nil, sg_artillery_guns, 1)
		end,
		
		OnComplete = function()
			Rule_Remove(SilenceArtillery_FireArty)
			
			if SGroup_IsEmpty(sg_artillery_defenders) == false then Cmd_StaggeredRetreat(sg_artillery_defenders, {mkr_retreat_01}, 2) end
			if SGroup_IsEmpty(sg_artillery_defenders_hmg) == false then Cmd_StaggeredRetreat(sg_artillery_defenders_hmg, {mkr_retreat_01}, 2) end
			
			if Event_Exists(eventID_flank) then Event_Remove(eventID_flank) end
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.ArtyUnderAttack,
		Intel_Complete = nil,
		Intel_Fail = nil,				
		Title = 11049619,				-- LOCDB [11049619] 'Neutralize the Artillery'
		Type = OT_Primary,				
	}
	Objective_Register(OBJ_SilenceArtillery)
	
	SOBJ_ArtilleryDestroyed = Objective_QuickSub(OBJ_SilenceArtillery, 11049620, OT_Primary)	-- LOCDB [11049620] 'Artillery Guns Neutralized'

end

function SilenceArtillery_Kickoff()
	Objective_Start(OBJ_SilenceArtillery)
end

function SilenceArtillery_Init()
	eg_hmg = EGroup_CreateIfNotFound("eg_hmg")
	Util_CreateEntities(nil, eg_hmg, BP_GetEntityBlueprint("dp28_lmg_item"), mkr_hmgSpawn, 1)
	
	-- Enemies
	sg_artillery_01 = SGroup_CreateIfNotFound("sg_artillery_01")
	sg_artillery_02 = SGroup_CreateIfNotFound("sg_artillery_02")
	sg_artillery_guns = SGroup_CreateIfNotFound("sg_artillery_guns")
	sg_artillery_defenders = SGroup_CreateIfNotFound("sg_artillery_defenders")
	sg_artillery_defenders1 = SGroup_CreateIfNotFound("sg_artillery_defenders1")
	sg_artillery_defenders_hmg = SGroup_CreateIfNotFound("sg_artillery_defenders_hmg")
	
	sg_artillery_halftrack = SGroup_CreateIfNotFound("sg_artillery_halftrack")
	
	
	Util_CreateSquads(player2, {sg_artillery_01, sg_artillery_guns}, SBP.SOVIET.M1937_152MM_ML_20_ARTILLERY, mkr_enemyArtySpawn1)
	Util_CreateSquads(player2, {sg_artillery_02, sg_artillery_guns}, SBP.SOVIET.M1937_152MM_ML_20_ARTILLERY, mkr_enemyArtySpawn2)
	Util_LogSyncWpn(sg_artillery_01, false)
	Util_LogSyncWpn(sg_artillery_02, false)
	
	Util_CreateSquads(player2, sg_artillery_defenders, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_artyDef_spawn01)
	Util_CreateSquads(player2, sg_artillery_defenders, SBP.SOVIET.GUARDS_TROOPS, mkr_artyDef_spawn02, nil, 1, 4)
	Util_CreateSquads(player2, sg_artillery_defenders, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_artyDef_spawn03, nil, 1, 5)
	Util_CreateSquads(player2, sg_artillery_defenders, SBP.SOVIET.GUARDS_TROOPS, mkr_artyDef_spawn04, nil, 1, 5)
	Util_CreateSquads(player2, sg_artillery_defenders, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_artyDef_spawn05, nil, 1, 4)
	Util_CreateSquads(player2, sg_artillery_defenders, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_artyDef_spawn06, nil, 1, 4)
	Util_CreateSquads(player2, sg_artillery_defenders_hmg, SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD, mkr_artyDef_hmg)
	Util_LogSyncWpn(sg_artillery_defenders_hmg, true)
	Cmd_InstantSetupTeamWeapon(sg_artillery_defenders_hmg)
	TeamWeapon_AddGroup(sg_artillery_defenders_hmg, nil, nil, false, 6, 1)
	
	Util_CreateSquads(player2, {sg_artillery_halftrack, sg_artillery_defenders}, SBP.SOVIET.M5_HALFTRACK_SQUAD, mkr_halftrack_spawn)
	Util_CreateSquads(player2, {sg_artillery_defenders1, sg_artillery_defenders}, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, sg_artillery_halftrack, nil, 1, 5)
	SGroup_SetInvulnerable(sg_artillery_halftrack, 0.4)
	Modify_ReceivedDamage(sg_artillery_halftrack, 2)
	
	Event_GroupIsDead(SilenceArtillery_Gun_Dead, nil, sg_artillery_01)
	Event_GroupIsDead(SilenceArtillery_Gun_Dead, nil, sg_artillery_02)
	
	Event_PlayerCanSeeElement(LESSON_PickupWeapon_LMG, nil, player1, eg_hmg, ANY, 5)
	eventID_flank = Event_Proximity(LESSON_Flank_MarkFlank, nil, player1, mkr_artyDef_flank_Trig, 20, ANY)
end

function LESSON_Flank_MarkFlank()
	hpid_flank = HintPoint_Add(mkr_artyDef_flank, true, 11049754) -- LOCDB [11049754] 'Flanking routes are used to outmaneuver enemies'
	Util_StartIntel(EVENTS.FlankGuns)
	Event_Proximity(LESSON_Flank_RemoveHint, nil, player1, mkr_artyDef_flank, 8, ANY, 2)
end

function LESSON_Flank_RemoveHint()
	HintPoint_Remove(hpid_flank)
end

function LESSON_PickupWeapon_LMG()
	hpid_pickupLMG = HintPoint_Add(eg_hmg, true, 11049623)	-- LOCDB [11049623] 'RIGHT-CLICK to pickup this Lightmachine Gun'
	Rule_AddOneShot(LESSON_PickupWeapon_RemoveHint, 10)
end

function LESSON_PickupWeapon_RemoveHint()
	if EGroup_IsEmpty(eg_hmg) then HintPoint_Remove(hpid_pickupLMG) end
end

function SilenceArtillery_Gun_Dead()
	local count = Objective_GetCounter(SOBJ_ArtilleryDestroyed)
	Objective_SetCounter(SOBJ_ArtilleryDestroyed, (count+1), 2)
end

function SilenceArtillery_FireArty()
	if SGroup_IsEmpty(sg_artillery_01) == false then
		if SGroup_IsRetreating(sg_artillery_01, ANY) == false 
		  and SGroup_IsDoingAbility(sg_artillery_01, ABILITY.SOVIET.ML_20_152MM_BARRAGE_ABILITY, ANY) == false
		  and SGroup_TotalMembersCount(sg_artillery_01) > 1 then
			Cmd_Ability(sg_artillery_01, ABILITY.SOVIET.ML_20_152MM_BARRAGE_ABILITY, mkr_arty02_target, nil, true)
		end
	end
	
	if SGroup_IsEmpty(sg_artillery_02) == false then
		if SGroup_IsRetreating(sg_artillery_02, ANY) == false 
		  and SGroup_IsDoingAbility(sg_artillery_02, ABILITY.SOVIET.ML_20_152MM_BARRAGE_ABILITY, ANY) == false
		  and SGroup_TotalMembersCount(sg_artillery_02) > 1 then
			Cmd_Ability(sg_artillery_02, ABILITY.SOVIET.ML_20_152MM_BARRAGE_ABILITY, mkr_arty02_target, nil, true)
		end
	end
end

function SilenceArtillery_Halftrack()
	Cmd_Move(sg_artillery_halftrack, mkr_halftrack_dest)
	Event_OnHealth(SilenceArtillery_HalftrackBail, nil, sg_artillery_halftrack, 0.6, false)
end

function SilenceArtillery_HalftrackBail()
	if SGroup_IsEmpty(sg_artillery_halftrack) == false then
		Cmd_UngarrisonSquad(sg_artillery_defenders1, Util_GetOffsetPosition(sg_artillery_halftrack, OFFSET_BACK, 6))
		Cmd_Retreat(sg_artillery_defenders1, mkr_retreat_01, mkr_retreat_01)
		SGroup_SetInvulnerable(sg_artillery_halftrack, false)
		
		Event_GroupIsDead(SilenceArtillery_HalftrackDestroyed, nil, sg_artillery_halftrack, 1)
	end
end

function LESSON_AntiTank_MarkATSquad()
	Util_StartIntel(EVENTS.SeeHalfTrack)
	hpid_atSquad = HintPoint_Add(g_ATsquad1, true, 11049622)	-- LOCDB [11049622] 'Take out the Halftrack with this squad!'
end

function SilenceArtillery_HalftrackDestroyed()
	HintPoint_Remove(hpid_atSquad)
end

function SilenceArtillery_GunsDead()
	Objective_Complete(OBJ_SilenceArtillery)
	
	Event_NarrativeEventsNotRunning(SecureArea_Kickoff, nil, 1)
end

----------------------
----------------------
-- Fourth BEAT
function SecureArea_Init_Objectives()

	OBJ_SecureArea = {
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			g_captureClear = false
			
			Objective_Start(SOBJ_CaptureVP)
			
			World_IncreaseInteractionStage()
			
			sg_vp_defenders = SGroup_CreateIfNotFound("sg_vp_defenders")
			sg_vp_defenders_01 = SGroup_CreateIfNotFound("sg_vp_defenders_01")
			sg_vp_defenders_02 = SGroup_CreateIfNotFound("sg_vp_defenders_02")
			
			Util_CreateSquads(player2, {sg_vp_defenders_01, sg_vp_defenders}, SBP.SOVIET.GUARDS_TROOPS, mkr_vp_defenders_01_spawn)
			SGroup_AddAbility(sg_vp_defenders_01, BP_GetAbilityBlueprint("sp_sprint"))
			
			Util_CreateSquads(player2, {sg_vp_defenders_02, sg_vp_defenders}, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_vp_defenders_02_spawn, nil, 1, 4)
			SGroup_AddAbility(sg_vp_defenders_02, BP_GetAbilityBlueprint("sp_sprint"))
			
			SGroup_SetInvulnerable(sg_vp_defenders, 0.8)
			
			Event_Proximity(SecureArea_MoveDefenders, nil, player1, mkr_vp_moveDefenders, nil, ANY)
			
			hpid_captureVP = Objective_AddUIElements(SOBJ_CaptureVP, mkr_vp_hp, true, 11049756, true, 4)
--~ 			Rule_AddOneShot(LESSON_Capture_DropHintPoint, 2)
		end,
		
		OnComplete = function()
			
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.VPCapture,
		Intel_Complete = EVENTS.ConvoyDestroyed,
		Intel_Fail = nil,				
		Title = 11049755,				-- LOCDB [11049755] 'Secure the Area'
		Type = OT_Primary,				
	}
	Objective_Register(OBJ_SecureArea)
	
	SOBJ_CaptureVP = Objective_QuickSub(OBJ_SecureArea, 11049756, OT_Primary)	-- LOCDB [11049756] 'Capture the Victory Point'
	SOBJ_DefendVP = Objective_QuickSub(OBJ_SecureArea, 11049759, OT_Primary)	-- LOCDB [11049759] 'Defend the Victory Point'

end

function SecureArea_MoveDefenders()
	Cmd_Move(sg_vp_defenders_01, mkr_vp_defenders_01_dest)
	Cmd_Ability(sg_vp_defenders_01, BP_GetAbilityBlueprint("sp_sprint"), nil, nil, true)
	
	Cmd_Move(sg_vp_defenders_02, mkr_vp_defenders_02_dest)
	Cmd_Ability(sg_vp_defenders_02, BP_GetAbilityBlueprint("sp_sprint"), nil, nil, true)
	
	Event_Proximity(LESSON_Capture_Blockers, nil, {sg_vp_defenders_01, sg_vp_defenders_02}, {mkr_vp_defenders_01_dest, mkr_vp_defenders_02_dest}, 2.5, ANY, 1)
end

function LESSON_Capture_Blockers()
	-- LOCDB [11049980] 'The Capture radius must clear of hostile squads or capture progress will halt'
	hpid_blockers_01 = HintPoint_Add(sg_vp_defenders_01, true, 11049980, 1)
	hpid_blockers_02 = HintPoint_Add(sg_vp_defenders_02, true, 11049980, 1)
	HintPoint_Remove(hpid_capture)
	SGroup_SetInvulnerable(sg_vp_defenders, false)
	
	g_captureClear = true
	
	Event_GroupIsDead(LESSON_Capture_DropHintPoint, nil, sg_vp_defenders, 1)
end

function SecureArea_Kickoff()
	Objective_Start(OBJ_SecureArea, false)
end

function LESSON_Capture_DropHintPoint()
	hpid_capture = HintPoint_Add(mkr_capture_UI, true, 11049758)	-- LOCDB [11049758] 'Move a squad into the point's Capture Radius'
	
	if g_captureClear == true then
		Event_PlayerOwnsElement(LESSON_Capture_StartedCheck, nil, player1, eg_VP)
	end
end

function LESSON_Capture_StartedCheck()
	if Player_OwnsEGroup(player1, eg_VP) then
		Rule_RemoveMe()
		
		HintPoint_Remove(hpid_capture)
		Objective_Complete(SOBJ_CaptureVP)
		
		Event_NarrativeEventsNotRunning(SecureArea_DefenseKickoff, nil, 1)
	end
end

function SecureArea_DefenseKickoff()
	Util_StartIntel(EVENTS.VPisCaptured)
	
	Event_NarrativeEventsNotRunning(SecureArea_Start, nil, 1)
end

function SecureArea_Start()
	Objective_Start(SOBJ_DefendVP)
	hpid_defend = Objective_AddUIElements(SOBJ_DefendVP, mkr_vp_hp, true, 11049759, true, 4) -- LOCDB [11049759] 'Defend the Victory Point'
	
	hpid_cover01 = HintPoint_Add(mkr_heavyCover_01, true, 11049760, nil, HPAT_CoverGreen)		-- LOCDB [11049760] 'Trenches provide Heavy Cover'
	hpid_cover02 = HintPoint_Add(mkr_heavyCover_02, true, 11049760, nil, HPAT_CoverGreen)
	
	Event_Proximity(LESSON_CoverReminder_RemoveHint, nil, player1, {mkr_heavyCover_01, mkr_heavyCover_02}, 5, ANY, 2)
	
	Event_NarrativeEventsNotRunning(SecureArea_FirstAttack, nil, 12)
end

function LESSON_CoverReminder_RemoveHint()
	HintPoint_Remove(hpid_cover01)
	HintPoint_Remove(hpid_cover02)
end

function SecureArea_FirstAttack()
	sg_firstAttack = SGroup_CreateIfNotFound("sg_firstAttack")
	sg_firstAttack_tank = SGroup_CreateIfNotFound("sg_firstAttack_tank")
	
	local spawn = Util_FindHiddenSpawn(mkr_enemy_spawn_01, mkr_enemy_dest_01)
	Util_CreateSquads(player2, sg_firstAttack, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, spawn, mkr_enemy_dest_01, 1, 4)
	local spawn = Util_FindHiddenSpawn(mkr_enemy_spawn_02, mkr_enemy_dest_02)
	Util_CreateSquads(player2, sg_firstAttack, SBP.SOVIET.GUARDS_TROOPS, spawn, mkr_enemy_dest_02, 1, 5)
	local spawn = Util_FindHiddenSpawn(mkr_enemy_spawn_01, mkr_enemy_dest_03)
	Util_CreateSquads(player2, sg_firstAttack, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, spawn, mkr_enemy_dest_03, 1, 4)
	local spawn = Util_FindHiddenSpawn(mkr_enemy_spawn_01, mkr_enemy_dest_04)
	Util_CreateSquads(player2, sg_firstAttack, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, spawn, mkr_enemy_dest_04, 1, 3)
	
	Rule_AddOneShot(SecureArea_FirstAttack_T34, 2)
end

function SecureArea_FirstAttack_T34()
	Util_StartIntel(EVENTS.Incoming)
	Rule_AddOneShot(SecureArea_FirstAttack_T34_Spawn, 2)
end

function SecureArea_FirstAttack_T34_Spawn()
	local spawn = Util_FindHiddenSpawn(mkr_enemy_t34_01_spawn, mkr_enemy_t34_01_dest)
	Util_CreateSquads(player2, {sg_firstAttack, sg_firstAttack_tank}, SBP.SOVIET.T_34_76_SQUAD, spawn, mkr_enemy_t34_01_dest)
	
	Rule_AddOneShot(SecureArea_Panzer_IV_Arrives, 10)
	Rule_Add(SecureArea_FirstAttack_Retreat)
	Event_GroupIsDead(SecureArea_FirstAttack_Dead, nil, sg_firstAttack, 2, true)
end

function SecureArea_Panzer_IV_Arrives()
	sg_player_panzer = SGroup_CreateIfNotFound("sg_player_panzer")
	
	local hiddenPoint = World_GetHiddenPositionOnPath(player1, mkr_player_tank_spawn, mkr_player_tank_dest, CHECK_OFFCAMERA)
	local spawn = nil
	if hiddenPoint ~= nil then
		spawn = Util_GetPositionFromAtoB(hiddenPoint, mkr_player_tank_spawn, 10)
	else
		spawn = mkr_player_tank_spawn
	end
	
	Util_CreateSquads(player3, sg_player_panzer, SBP.GERMAN.PANZER_IV_SQUAD, spawn, mkr_player_tank_dest)
	SGroup_SetInvulnerable(sg_player_panzer, 0.8)
	SGroup_SetInvulnerableToCritical(sg_player_panzer, true)
	g_weaponDamage = Modify_WeaponDamage(sg_player_panzer, "hardpoint_01", 0)
	
	Modify_ReceivedDamage(sg_firstAttack_tank, 2)
	
	Util_StartIntel(EVENTS.CavalryArrived)
	
	Rule_Add(LESSON_Facing_Start)
end

function LESSON_Facing_Start()
	if SGroup_IsMoving(sg_player_panzer, ANY) == false and Prox_AreSquadsNearMarker(sg_player_panzer, mkr_player_tank_dest, ANY, 5) then
		Rule_RemoveMe()
		
		Rule_AddOneShot(LESSON_Facing_RevertControl, 3)
	end
end

function LESSON_Facing_RevertControl()
	hpid_facing = HintPoint_Add(sg_player_panzer, true, 11049981, 1)	-- LOCDB [11049981] 'RIGHT-CLICK and hold to issue a facing order towards the Soviet Tank'
	hpid_facingTar = HintPoint_Add(mkr_enemy_t34_01_dest, true, 11049982, 3)	-- LOCDB [11049982] 'Issue a facing order here'
	
	SGroup_SetPlayerOwner(sg_player_panzer, player1)
	Modifier_Remove(g_weaponDamage)
	
	tankID = Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_player_panzer, 1), 0)
	
	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Entity, "modifiers\\facing_only_enable.lua", MUT_Enable, false, 1, "")
	local result = {}
	
	g_modid = Modifier_ApplyToEntity(modifier, tankID)
	table.insert(result, g_modid)
	Modifier_AddToEntityTable(tankID, g_modid)
	
	Rule_Add(LESSON_Facing_Check)
end

function LESSON_Facing_Check()
	if (Marker_InProximity(mkr_enemy_t34_01_dest, Util_GetOffsetPosition(sg_player_panzer, OFFSET_FRONT, 20)) 
	  and SGroup_IsMoving(sg_player_panzer, ANY))
	  or SGroup_IsEmpty(sg_firstAttack_tank) then
		Rule_RemoveMe()
		
		HintPoint_Remove(hpid_facing)
		hpid_facing = nil
		HintPoint_Remove(hpid_facingTar)
		hpid_facingTar = nil
		
		Modifier_Remove(g_modid)
	end
end

function SecureArea_FirstAttack_Retreat()
	if SGroup_IsEmpty(sg_firstAttack_tank)
	  and SGroup_TotalMembersCount(sg_firstAttack) <= 7 then
		Rule_RemoveMe()
		
		Cmd_StaggeredRetreat(sg_firstAttack, {mkr_retreat_01, mkr_retreat_02}, 2)
	end
end

function SecureArea_FirstAttack_Dead()
	Util_StartIntel(EVENTS.Incoming2)
	
	Event_NarrativeEventsNotRunning(SecureArea_SecondAttack, nil, 6)
end

function SecureArea_SecondAttack()
	sg_secondAttack = SGroup_CreateIfNotFound("sg_secondAttack")
	sg_secondAttack_flank = SGroup_CreateIfNotFound("sg_secondAttack_flank")
	sg_secondAttack_tank = SGroup_CreateIfNotFound("sg_secondAttack_tank")
	
	local spawn = Util_FindHiddenSpawn(mkr_enemy_t34_02_spawn, mkr_enemy_t34_02_dest)
	Util_CreateSquads(player2, sg_secondAttack_tank, SBP.SOVIET.T_34_76_SQUAD, spawn, mkr_enemy_t34_02_dest)
	Modify_ReceivedDamage(sg_secondAttack_tank, 2)
	Modify_Vulnerability(sg_secondAttack_tank, 2)
	
	local spawn = Util_FindHiddenSpawn(mkr_enemy_spawn_01, mkr_enemy_dest_01)
	Util_CreateSquads(player2, sg_secondAttack, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, spawn, Util_GetOffsetPosition(mkr_enemy_t34_02_dest, OFFSET_LEFT, 5))
	local spawn = Util_FindHiddenSpawn(mkr_enemy_spawn_02, mkr_enemy_dest_02)
	Util_CreateSquads(player2, sg_secondAttack, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, spawn, Util_GetOffsetPosition(mkr_enemy_t34_02_dest, OFFSET_FRONT_RIGHT, 5))
	local spawn = Util_FindHiddenSpawn(mkr_enemy_spawn_01, mkr_enemy_dest_03)
	Util_CreateSquads(player2, sg_secondAttack, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, spawn, Util_GetOffsetPosition(mkr_enemy_t34_02_dest, OFFSET_RIGHT, 8))
	local spawn = Util_FindHiddenSpawn(mkr_enemy_spawn_01, mkr_enemy_dest_04)
	Util_CreateSquads(player2, sg_secondAttack_flank, SBP.SOVIET.GUARDS_TROOPS, spawn, mkr_enemy_dest_04)
	
	SGroup_SetInvulnerable(sg_secondAttack, 0.7)
	
	SGroup_AddAbility(sg_secondAttack, BP_GetAbilityBlueprint("sp_sprint"))
	Cmd_Ability(sg_secondAttack, BP_GetAbilityBlueprint("sp_sprint"), nil, nil, true)
	
	Event_Proximity(LESSON_Commander_DropHintPoint, nil, sg_secondAttack, mkr_artillery_UI, 19, ANY, 3)
end

function LESSON_Commander_DropHintPoint()
	Cmd_Upgrade(player1, UPG.SOVIET.FIRE_ARTILLERY, 1, true)
	Player_SetResource(player1, RT_Command, 7)
	Player_SetResource(player1, RT_Munition, 200)
	g_munitions = 200
	Player_AddAbility(player1, ABILITY.SOVIET.FIRE_ARTILLERY)
	Modify_AbilityRechargeTime(player1, ABILITY.SOVIET.FIRE_ARTILLERY, 0.25)
	
	UI_NewHUDFeature(HUDF_AbilityCard, 11049761, "Icons_abilities_ability_incendiary_artillery", 5)	-- LOCDB [11049761] 'LEFT-CLICK the Incendiary Artillery Barrage Ability'
	fpid_artillery = UI_FlashAbilityButton(ABILITY.SOVIET.FIRE_ARTILLERY, false)
	
	FOW_RevealMarker(mkr_artillery_UI, -1)
	
	Camera_MoveTo(mkr_artillery_UI, true, 0.3, true, true)
	Camera_SetInputEnabled(false)
	Misc_RestrictCommandsToMarker(mkr_artillery_UI)
	hpid_target = HintPoint_Add(mkr_artillery_UI, true, 11049762, nil, HPAT_Hint)	-- LOCDB [11049762] 'LEFT-CLICK here to order an Artillery Strike'
	
	Rule_AddPlayerEvent(LESSON_Commander_ArtilleryDropped, player1, GE_AbilityExecuted)
end

function LESSON_Commander_ArtilleryDropped(player, command, target)
	if command == ABILITY.SOVIET.FIRE_ARTILLERY
	  and target == sg_secondAttack or Marker_InProximity(mkr_artillery_UI, target) then
		Rule_AddOneShot(SecureArea_EnemyFallback, 14)
		Rule_AddOneShot(SecureArea_VulnEnemyToArtillery, 10)
		
		SGroup_SetInvulnerable(sg_secondAttack, false)
		
		Camera_SetInputEnabled(true)
		Misc_RemoveCommandRestriction()
		
		HintPoint_Remove(hpid_target)
		UI_StopFlashing(fpid_artillery)
	end	
end

function SecureArea_VulnEnemyToArtillery()
	if SGroup_IsEmpty(sg_secondAttack) == false then Modify_ReceivedDamage(sg_secondAttack, 2) end
end

function SecureArea_EnemyFallback()
	Cmd_StaggeredRetreat(sg_secondAttack, {mkr_retreat_01, mkr_retreat_02}, 3)
	Cmd_StaggeredRetreat(sg_secondAttack_flank, {mkr_retreat_01, mkr_retreat_02}, 3)
	if SGroup_IsEmpty(sg_secondAttack_tank) == false then Command_SquadMovePos(player2, sg_secondAttack_tank, Util_GetPosition(mkr_enemy_t34_01_spawn), false, true) end
	
	Rule_AddOneShot(SecureArea_Victory, 3)
end

function SecureArea_Victory()
	Objective_Complete(OBJ_SecureArea)
	
	Event_NarrativeEventsNotRunning(Mission_FadeToBlack, nil, 1)
end

function Mission_FadeToBlack()
	Game_FadeToBlack(FADE_OUT, 3.5)
	if Rule_Exists(Mission_Complete_OVERRIDE) == false then
		Rule_AddOneShot(Mission_Complete_OVERRIDE, 4)
	end 
end

function Mission_Complete_OVERRIDE()
	Misc_AbortToFE()
end

-- Utilities
function Objective_QuickSub(parent, title, OType)
	local objectiveName = {
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			
		end,
		
		OnComplete = function()
			
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,
		Intel_Complete = nil,
		Intel_Fail = nil,				
		Title = title,				-- LOCDB [11036460] 'Reclaim Stalingrad'
		Type = OType,	
		Parent = parent,
	}
	Objective_Register(objectiveName)
	
	return objectiveName
end
	
