-------------------------------------
-- NIS
-------------------------------------

-- Cheat sheet
-- Russian 03 - Killed in Order 227
-- Russian 04 - Killed (or Survives) Bonus objective

function Audio_Init()
	
	Sound_PreCacheSinglePlayerSpeech("mission/m01")
	g_MissionSpeechPath = "mission/m01"
	
	NIS_Start = "SP/CoH2_Campaign/M01-Stalingrad_Rail_Station/nis/m01_camera_start"
	nis_load(NIS_Start)
	
	NIS_HMG = "SP/CoH2_Campaign/M01-Stalingrad_Rail_Station/nis/m01_hmg_camera"
	nis_load(NIS_HMG)
	
	g_music_docks = "streamed/music/missions/m01/m01_cue_start.bsc"
	g_music_howitzers = "streamed/music/missions/m01/m01_cue_take_howitzers.bsc"
	g_music_panzer = "streamed/music/missions/m01/m01_cue_take_panzer.bsc"
	g_music_railstation = "streamed/music/missions/m01/m01_cue_rail_station.bsc"
--~ 	g_music = "streamed/music/missions/m01/m01_full.bsc"
	
	Sound_PreCacheSound("campaign/m01_german_soldiers_charge")
	Sound_PreCacheSound("speech/sp/mission/m01/ambient/m01_tank_lost")

end



Scar_AddInit(Audio_Init)

EVENTS = {}
-- Intro
EVENTS.NIS01 = function()
	
	Game_FadeToBlack(FADE_OUT, 0)
	
	g_music_docks = "streamed/music/missions/m01/m01_cue_start.bsc"
	Util_PlayMusic(g_music_docks, 0, 0)
	
	CTRL.SitRep_PlayMovie("m01_cin01a")
	CTRL.WAIT()	
	
	sg_INTRO_squads_01_A = SGroup_CreateIfNotFound("sg_INTRO_squads_01_A")
	sg_INTRO_squads_01_B = SGroup_CreateIfNotFound("sg_INTRO_squads_01_B")
	
	Util_CreateSquads(player3, sg_INTRO_squads_01_A, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_INTRO_spawn_01)
	Util_CreateSquads(player3, sg_INTRO_squads_01_B, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_INTRO_spawn_02, nil, 1, 2)
	Util_CreateSquads(player3, sg_INTRO_squads_01_A, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_INTRO_spawn_03, nil, 1, 1)
	Util_CreateSquads(player3, sg_INTRO_squads_01_A, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_INTRO_spawn_04)
	Util_CreateSquads(player3, sg_INTRO_squads_01_B, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_INTRO_spawn_05)
	
	sg_INTRO_squads_02_A = SGroup_CreateIfNotFound("sg_INTRO_squads_02_A")
	sg_INTRO_squads_02_B = SGroup_CreateIfNotFound("sg_INTRO_squads_02_B")
	
	Util_CreateSquads(player3, sg_INTRO_squads_02_A, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_INTRO_spawn_06)
	Util_CreateSquads(player3, sg_INTRO_squads_02_A, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_INTRO_spawn_07)
	Util_CreateSquads(player3, sg_INTRO_squads_02_B, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_INTRO_spawn_08)
	
	sg_INTRO_squads_03 = SGroup_CreateIfNotFound("sg_INTRO_squads_03")
	
	Util_CreateSquads(player3, sg_INTRO_squads_03, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_INTRO_spawn_09)
	Util_CreateSquads(player3, sg_INTRO_squads_03, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_INTRO_spawn_10)
	
	CTRL.Scar_PlayNIS(NIS_Start)
	CTRL.SUB()
		CTRL.Event_Delay(4)
		CTRL.WAIT()
		Cmd_MoveToAndDespawn(sg_INTRO_squads_01_A, mkr_INTRO_despawn_A)
		Cmd_MoveToAndDespawn(sg_INTRO_squads_01_B, mkr_INTRO_despawn_B)
		Game_FadeToBlack(FADE_IN, 4.5)
		CTRL.Event_Delay(3)
		CTRL.WAIT()
		Rule_AddInterval(_docks_Commissar_Speech, 1)
		CTRL.Event_Delay(3)
		CTRL.WAIT()
		Cmd_MoveToAndDespawn(sg_INTRO_squads_02_A, mkr_INTRO_despawn_A)
		Cmd_MoveToAndDespawn(sg_INTRO_squads_02_B, mkr_INTRO_despawn_B)
		CTRL.Event_Delay(5)
		CTRL.WAIT()
		Cmd_MoveToAndDespawn(sg_INTRO_squads_03, mkr_INTRO_despawn_B)
		_ambient_bomb_player_boat()
		CTRL.Event_Delay(4)
		CTRL.WAIT()
		Mission_MoveUp_Shock()
		CTRL.Event_Delay(4)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036245)	-- LOCDB [11036245] 'Off the boats, now!' - 'Commissar'
		CTRL.WAIT()
		Entity_RemoveCritical(Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_a_t34, 1), 0), CRIT.VEHICLE_EXHAUST_DAMAGED)
		SGroup_SetAvgHealth(sg_a_t34, 1)
		SGroup_WarpToMarker(sg_a_t34, mkr_docks_t34)
		SGroup_DestroyAllSquads(sg_a_engineers)
		Cmd_Move(sg_a_t34, mkr_docks_t34, false, nil, Util_GetOffsetPosition(mkr_docks_t34, OFFSET_FRONT, 5))
		_ambient_dock_bombed()
	CTRL.END()
	CTRL.WAIT()
	
	FOW_RevealTerritory(player1, World_GetTerritorySectorID(Util_GetPosition(eg_docks_cp)), -1, false)
	
	_eventID_SpawnShock_01 = Event_GroupIsDead(_spawnShock01, nil, sg_p_shock_01, 1)
	_eventID_SpawnShock_02 = Event_GroupIsDead(_spawnShock02, nil, sg_p_shock_02, 1)
	
	_amb_arty_onScreen = true
	
	-- Rush Squads
	Docks_Rush_Init()
	
	Selection_Init()
	
	Rule_AddOneShot(_ambient_il2_crash, 10)
	Rule_AddOneShot(_ambient_artillery_reset, 5)
	
	Objective_Start(OBJ_AssaultStalingrad, true)
	
	Game_SetMode(UI_Normal)
	Game_EnableInput(true)
	Camera_SetInputEnabled(true)
	
end

EVENTS.NIS02 = function()
	
	FOW_UnRevealTerritory(player1, World_GetTerritorySectorID(Util_GetPosition(eg_docks_cp)))
	
	Game_FadeToBlack(FADE_IN, 2.5)
	
	-- Spawn units	
	sg_a_HMG_kill_All = SGroup_CreateIfNotFound("sg_a_HMG_kill_All")
	sg_a_HMG_kill_01 = SGroup_CreateIfNotFound("sg_a_HMG_kill_01")
	sg_a_HMG_kill_02 = SGroup_CreateIfNotFound("sg_a_HMG_kill_02")
	sg_a_HMG_kill_03 = SGroup_CreateIfNotFound("sg_a_HMG_kill_03")
	sg_a_HMG_kill_04 = SGroup_CreateIfNotFound("sg_a_HMG_kill_04")
	sg_a_HMG_kill_05 = SGroup_CreateIfNotFound("sg_a_HMG_kill_05")
	sg_a_HMG_kill_06 = SGroup_CreateIfNotFound("sg_a_HMG_kill_06")
	sg_a_HMG_kill_07 = SGroup_CreateIfNotFound("sg_a_HMG_kill_07")
	sg_a_HMG_kill_08 = SGroup_CreateIfNotFound("sg_a_HMG_kill_08")
	sg_a_HMG_kill_09 = SGroup_CreateIfNotFound("sg_a_HMG_kill_09")
	sg_a_HMG_kill_10 = SGroup_CreateIfNotFound("sg_a_HMG_kill_10")
	
	Util_CreateSquads(player3, {sg_a_HMG_kill_01, sg_a_HMG_kill_All}, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_hmg_kill_01_spawn, nil, 1, 1)
	Util_CreateSquads(player3, {sg_a_HMG_kill_02, sg_a_HMG_kill_All}, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_hmg_kill_01_spawn, nil, 1, 1)
	Util_CreateSquads(player3, {sg_a_HMG_kill_03, sg_a_HMG_kill_All}, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_hmg_kill_01_spawn, nil, 1, 1)
	Util_CreateSquads(player3, {sg_a_HMG_kill_04, sg_a_HMG_kill_All}, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_hmg_kill_02_spawn, nil, 1, 1)
	Util_CreateSquads(player3, {sg_a_HMG_kill_05, sg_a_HMG_kill_All}, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_hmg_kill_02_spawn, nil, 1, 1)
	Util_CreateSquads(player3, {sg_a_HMG_kill_06, sg_a_HMG_kill_All}, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_hmg_kill_02_spawn, nil, 1, 1)
	Util_CreateSquads(player3, {sg_a_HMG_kill_07, sg_a_HMG_kill_All}, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_hmg_kill_02_spawn, nil, 1, 1)
	Util_CreateSquads(player3, {sg_a_HMG_kill_08, sg_a_HMG_kill_All}, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_hmg_kill_02_spawn, nil, 1, 1)
	Util_CreateSquads(player3, {sg_a_HMG_kill_09, sg_a_HMG_kill_All}, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_hmg_kill_02_spawn, nil, 1, 1)
	Util_CreateSquads(player3, {sg_a_HMG_kill_10, sg_a_HMG_kill_All}, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, mkr_hmg_kill_02_spawn, nil, 1, 1)
	
	Cmd_Upgrade(sg_a_HMG_kill_All, BP_GetUpgradeBlueprint("m01_hmg_death_squad_upgrade"), 1, true)
	
	Rule_Add(_removeSuppression)

	SGroup_SetInvulnerable(sg_a_HMG_kill_01, true)
	SGroup_SetInvulnerable(sg_a_HMG_kill_02, true)
	SGroup_SetInvulnerable(sg_a_HMG_kill_03, true)
	SGroup_SetInvulnerable(sg_a_HMG_kill_04, true)
	SGroup_SetInvulnerable(sg_a_HMG_kill_05, true)
	SGroup_SetInvulnerable(sg_a_HMG_kill_06, true)
	SGroup_SetInvulnerable(sg_a_HMG_kill_07, true)
	SGroup_SetInvulnerable(sg_a_HMG_kill_08, true)
	SGroup_SetInvulnerable(sg_a_HMG_kill_09, true)
	SGroup_SetInvulnerable(sg_a_HMG_kill_10, true)
	
	eventID_vaulnHMG_01 = Event_Proximity(_vulnHMG, {sgroup = sg_a_HMG_kill_01}, sg_a_HMG_kill_01, mkr_hmg_vault_vauln, nil, ANY)
	eventID_vaulnHMG_02 = Event_Proximity(_vulnHMG, {sgroup = sg_a_HMG_kill_02}, sg_a_HMG_kill_02, mkr_hmg_vault_vauln, nil, ANY, 0.5)
	eventID_vaulnHMG_03 = Event_Proximity(_vulnHMG, {sgroup = sg_a_HMG_kill_03}, sg_a_HMG_kill_03, mkr_hmg_vault_vauln, nil, ANY, 0.5)
	eventID_vaulnHMG_04 = Event_Proximity(_vulnHMG, {sgroup = sg_a_HMG_kill_04}, sg_a_HMG_kill_04, mkr_hmg_vault_vauln, nil, ANY)
	eventID_vaulnHMG_05 = Event_Proximity(_vulnHMG, {sgroup = sg_a_HMG_kill_05}, sg_a_HMG_kill_05, mkr_hmg_vault_vauln, nil, ANY, 1)
	eventID_vaulnHMG_06 = Event_Proximity(_vulnHMG, {sgroup = sg_a_HMG_kill_06}, sg_a_HMG_kill_06, mkr_hmg_vault_vauln, nil, ANY, 0.5)
	eventID_vaulnHMG_07 = Event_Proximity(_vulnHMG, {sgroup = sg_a_HMG_kill_07}, sg_a_HMG_kill_07, mkr_hmg_vault_vauln, nil, ANY)
	eventID_vaulnHMG_08 = Event_Proximity(_vulnHMG, {sgroup = sg_a_HMG_kill_08}, sg_a_HMG_kill_08, mkr_hmg_vault_vauln, nil, ANY)
	eventID_vaulnHMG_09 = Event_Proximity(_vulnHMG, {sgroup = sg_a_HMG_kill_09}, sg_a_HMG_kill_09, mkr_hmg_vault_vauln, nil, ANY, 0.5)
	eventID_vaulnHMG_10 = Event_Proximity(_vulnHMG, {sgroup = sg_a_HMG_kill_10}, sg_a_HMG_kill_10, mkr_hmg_vault_vauln, nil, ANY, 1)
	
	Game_SetMode(UI_Cinematic)
	
	CTRL.Scar_PlayNIS(NIS_HMG)
	CTRL.SUB()
		CTRL.Event_Delay(1)
		CTRL.WAIT()
		-- 1 second
		CTRL.Actor_PlaySpeech(ACTOR.None, 11046741)	-- LOCDB [11046741] 'Heavy Machine Gun north of the breach; they have the main route covered.' - 'Intel'
		CTRL.WAIT()
		-- 5 seconds
		CTRL.Event_Delay(3)
		CTRL.WAIT()
		_central_Allies_Max = 12
		
		Rule_AddOneShot(_hmg_findSquad, 6)
		Rule_AddDelayedInterval(_hmg_vaultSquad_Suppression, 6, 0.5)
		-- 8 seconds
		g_burstMod = Modify_WeaponBurstLength(sg_e_hmg_grenade, "hardpoint_01", 5)
		Cmd_Move(sg_a_HMG_kill_01, mkr_hmg_vault_01_dest)
		Command_SquadEntity(player3, sg_a_HMG_kill_01, SCMD_Move, eg_hmg_vault_01, true)
		Cmd_Move(sg_a_HMG_kill_01, mkr_hmg_kill_dest_02, true)
		Cmd_Move(sg_a_HMG_kill_02, mkr_hmg_vault_02_dest)
		Command_SquadEntity(player3, sg_a_HMG_kill_02, SCMD_Move, eg_hmg_vault_01, false)
		Cmd_Move(sg_a_HMG_kill_02, mkr_hmg_kill_dest_03, true)
		CTRL.Event_Delay(1)
		CTRL.WAIT()
		Cmd_Move(sg_a_HMG_kill_03, mkr_hmg_vault_02_dest)
		Command_SquadEntity(player3, sg_a_HMG_kill_03, SCMD_Move, eg_hmg_vault_01, false)
		Cmd_Move(sg_a_HMG_kill_03, mkr_hmg_kill_dest_04, true)
		Cmd_Move(sg_a_HMG_kill_04, mkr_hmg_vault_03_dest)
		Command_SquadEntity(player3, sg_a_HMG_kill_04, SCMD_Move, eg_hmg_vault_02, false)
		Cmd_Move(sg_a_HMG_kill_04, mkr_hmg_kill_dest_04, true)
		Cmd_Move(sg_a_HMG_kill_05, mkr_hmg_vault_01_dest)
		Command_SquadEntity(player3, sg_a_HMG_kill_05, SCMD_Move, eg_hmg_vault_01, false)
		Cmd_Move(sg_a_HMG_kill_05, mkr_hmg_kill_dest_02, true)
		CTRL.Event_Delay(1)
		CTRL.WAIT()
		Cmd_Move(sg_a_HMG_kill_06, mkr_hmg_vault_02_dest)
		Command_SquadEntity(player3, sg_a_HMG_kill_06, SCMD_Move, eg_hmg_vault_01, false)
		Cmd_Move(sg_a_HMG_kill_06, mkr_hmg_kill_dest_03, true)
		Cmd_Move(sg_a_HMG_kill_07, mkr_hmg_vault_03_dest)
		Command_SquadEntity(player3, sg_a_HMG_kill_07, SCMD_Move, eg_hmg_vault_02, false)
		Cmd_Move(sg_a_HMG_kill_07, mkr_hmg_kill_dest_04, true)
		CTRL.Event_Delay(2)
		CTRL.WAIT()
		Cmd_Move(sg_a_HMG_kill_08, mkr_hmg_vault_01_dest)
		Command_SquadEntity(player3, sg_a_HMG_kill_08, SCMD_Move, eg_hmg_vault_01, false)
		Cmd_Move(sg_a_HMG_kill_08, mkr_hmg_kill_dest_02, true)
		Cmd_Move(sg_a_HMG_kill_09, mkr_hmg_vault_03_dest)
		Command_SquadEntity(player3, sg_a_HMG_kill_09, SCMD_Move, eg_hmg_vault_02, false)
		Cmd_Move(sg_a_HMG_kill_09, mkr_hmg_kill_dest_03, true)
		Cmd_Move(sg_a_HMG_kill_10, mkr_hmg_vault_01_dest)
		Command_SquadEntity(player3, sg_a_HMG_kill_10, SCMD_Move, eg_hmg_vault_01, false)
		Cmd_Move(sg_a_HMG_kill_10, mkr_hmg_kill_dest_01, true)
		CTRL.Event_Delay(6)
		CTRL.WAIT()
		Modifier_Remove(g_burstMod)
		Cmd_Stop(sg_e_hmg_grenade)
		CTRL.Actor_PlaySpeech(ACTOR.None, 11046742)	-- LOCDB [11046742] 'Avoid his kill zone.' - 'Intel'
		CTRL.WAIT()
		-- 21 seconds
		CTRL.Event_Delay(5)
		CTRL.WAIT()
		-- 25 seconds
		CTRL.Actor_PlaySpeech(ACTOR.None, 11036255)	-- LOCDB [11036255] 'Flank the location and clear with grenades.' - 'Intel'
		CTRL.WAIT()
--~ 		Game_FadeToBlack(FADE_OUT, 2.5)
		-- 29 seconds
	CTRL.END()
	CTRL.WAIT()
	
	Rule_Remove(_removeSuppression)
	
	Camera_MoveTo(sg_p_shock_01, true, 0.4, false, true)
--~ 	Game_FadeToBlack(FADE_IN, 3.5)
	Game_SetMode(UI_Normal)
	Camera_SetInputEnabled(true)
	Camera_ResetToDefault()
	
	if Rule_Exists(_hmg_Fire_On_Target) == false then Rule_AddOneShot(_hmg_Fire_On_Target, 1) end
	
end

-- Order 227
EVENTS.NIS03 = function()
	
	Game_FadeToBlack(FADE_OUT, 0)
	
	SGroup_WarpToMarker(sg_p_at, mkr_rail_p_atGun_warp)
	
	Player_GetAll(player1, sg_temp)
	SGroup_Filter(sg_temp, SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD, FILTER_REMOVE)
	
	local _warp = function(gid, idx, sid)
		Squad_WarpToPos(sid, Util_GetRandomPosition(mkr_p_squads))
	end
	
	SGroup_ForEach(sg_temp, _warp)
	
	-- End the Bonus obj if it's still going
	if (Objective_IsStarted(OBJ_Bonus) and (Objective_IsComplete(OBJ_Bonus) == false or Objective_IsFailed(OBJ_Bonus) == false)) then
		Objective_Fail(OBJ_Bonus, false, true)
		if Objective_IsStarted(SOBJ_Bonus_Loss) then Objective_Fail(SOBJ_Bonus_Loss, false, true) Objective_Show(SOBJ_Bonus_Loss, false) end
		if Objective_IsStarted(SOBJ_Bonus_Win) then Objective_Fail(SOBJ_Bonus_Win, false, true) Objective_Show(SOBJ_Bonus_Win, false) end
	end

	CTRL.SitRep_PlayMovie("m01_cin02")
	CTRL.WAIT()
	
	atRailstationObjective = true -- used for setup on save game load (see OnGameRestore())

	-- Setup Play Area
	Camera_ClampToMarker(mkr_rail_playZone)
	Misc_RestrictCommandsToMarker(mkr_rail_playZone)	
	
	-- Kill all allied squads
	Player_GetAll(player3)
	SGroup_Filter(sg_allsquads, {SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD, SBP.SOVIET.SOVIET_OFFICER_SQUAD, SBP.SOVIET.GUARDS_TROOPS}, FILTER_REMOVE)
	SGroup_Kill(sg_allsquads)
	
	-- Spawn the new map entry points
	eg_spawns = EGroup_Create("eg_spawns")
	Util_CreateEntities(player1, eg_spawns, BP_GetEntityBlueprint("map_entry_point"), mkr_rail_p_spawnPoint_01, 1)
	Util_CreateEntities(player1, eg_spawns, BP_GetEntityBlueprint("map_entry_point"), mkr_rail_p_spawnPoint_02, 1)
	
	Player_SetPopCapOverride(player1, t_difficulty.popcap_02)
	
	-- Warp blockers who are not in place
	if Prox_AreSquadsNearMarker(sg_a_blocker_hmg_right, mkr_blocker_hmg_right_dest03, ANY, 5) == false then
		SGroup_WarpToPos(sg_a_blocker_hmg_right, Util_GetOffsetPosition(mkr_blocker_hmg_right_dest03, OFFSET_BACK, 5))
		Cmd_Move(sg_a_blocker_hmg_right, mkr_blocker_hmg_right_dest03, false, nil, Util_GetOffsetPosition(mkr_blocker_hmg_right_dest03, OFFSET_FRONT, 10))
	end
	if Prox_AreSquadsNearMarker(sg_a_blocker_com_center, mkr_blocker_commissar_right_dest03, ANY, 5) == false then
		SGroup_WarpToMarker(sg_a_blocker_com_center, mkr_blocker_commissar_right_dest03)
	end
	if Prox_AreSquadsNearMarker(sg_a_blocker_guard_center, mkr_blocker_guards_right_dest03, ANY, 5) == false then
		SGroup_WarpToMarker(sg_a_blocker_guard_center, mkr_blocker_guards_right_dest03)
	end
	
	if Prox_AreSquadsNearMarker(sg_a_blocker_hmg_center, mkr_blocker_hmg_center_dest03, ANY, 5) == false then
		SGroup_WarpToPos(sg_a_blocker_hmg_center, Util_GetOffsetPosition(mkr_blocker_hmg_center_dest03, OFFSET_BACK, 5))
		Cmd_Move(sg_a_blocker_hmg_center, mkr_blocker_hmg_center_dest03, false, nil, Util_GetOffsetPosition(mkr_blocker_hmg_center_dest03, OFFSET_FRONT, 10))
	end
	if Prox_AreSquadsNearMarker(sg_a_blocker_com_center, mkr_blocker_commissar_center_dest03, ANY, 5) == false then
		SGroup_WarpToMarker(sg_a_blocker_com_center, mkr_blocker_commissar_center_dest03)
	end
	if Prox_AreSquadsNearMarker(sg_a_blocker_guard_center, mkr_blocker_guards_center_dest03, ANY, 5) == false then
		SGroup_WarpToMarker(sg_a_blocker_guard_center, mkr_blocker_guards_center_dest03)
	end
	
	if Prox_AreSquadsNearMarker(sg_a_blocker_hmg_left, mkr_blocker_hmg_left_dest03, ANY, 5) == false then
		SGroup_WarpToPos(sg_a_blocker_hmg_left, Util_GetOffsetPosition(mkr_blocker_hmg_left_dest03, OFFSET_BACK, 5))
		Cmd_Move(sg_a_blocker_hmg_left, mkr_blocker_hmg_left_dest03, false, nil, Util_GetOffsetPosition(mkr_blocker_hmg_left_dest03, OFFSET_FRONT, 10))
	end
	if Prox_AreSquadsNearMarker(sg_a_blocker_com_left, mkr_blocker_commissar_left_dest03, ANY, 5) == false then
		SGroup_WarpToMarker(sg_a_blocker_com_left, mkr_blocker_commissar_left_dest03)
	end
	if Prox_AreSquadsNearMarker(sg_a_blocker_guard_left, mkr_blocker_guards_left_dest03, ANY, 5) == false then
		SGroup_WarpToMarker(sg_a_blocker_guard_left, mkr_blocker_guards_left_dest03)
	end
	
	EGroup_DestroyAllEntities(eg_clearForFinal)
--~ 	RAILSTATION_Allies_Init()
	RAILSTATION_Allies_Init_A()
	
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 3)
	
end 

EVENTS.NIS04 = function()
	
	CTRL.SitRep_PlayMovie("m01_cin04")
	CTRL.WAIT()
	
	Game_EndSP(true)
	
end

-- LOCDB MISSION "M01"
-- LOCDB SCENE "SXX"

-- AMBIENT SPEECH

-- LOCDB [11036234] 'By order of Comrade Stalin, you are to re-take the city from the facist pigs.' - 'Commissar'
-- LOCDB [11036235] 'Drive them from it's streets.' - 'Commissar'
-- LOCDB [11036236] 'Burn them from it's buildings.' - 'Commissar'
-- LOCDB [11036237] 'Push them off every inch of ground and do not stop until every last German lies dead at your feet.' - 'Commissar'
-- LOCDB [11036238] 'Show them no mercy!' - 'Commissar'
-- LOCDB [11036239] 'Those who turn and run, will be shot.' - 'Commissar'
-- LOCDB [11036240] 'Those who attempt surrender; will be shot.' - 'Commissar'
-- LOCDB [11036241] 'You are soldiers of the Soviet Union; Not. One. Step. Back.' - 'Commissar'

--

--------------------------------------------
-- WARNINGS
----------------------------------
EVENTS.INCOMING_STUKA = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036242)	-- LOCDB [11036242] 'Incoming Stuka!' - 'Soldier_02'
	CTRL.WAIT()
end 

EVENTS.INTRO_SPEECH = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036243)	-- LOCDB [11036243] 'Up the hill, comrades - to glory!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.OFF_THE_DOCKS_01 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11048730)	-- LOCDB [11048730] 'They're shelling the docks, get off the docks!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.OFF_THE_DOCKS_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11048731)	-- LOCDB [11048731] 'Move! Get off the docks!' - 'Commissar'
	CTRL.WAIT()
end

--------------------------------------------------------------------------------
-- DOCKS
--------------------------------------------------------------------------------
EVENTS.DOCKS_START = function()
	
	
end

EVENTS.DOCKS_REMIND = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11037838)	-- LOCDB [11037838] 'Comrade, get up that hill!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.DOCKS_CONSCRIPT_REMIND = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036247)	-- LOCDB [11036247] 'Get those squads moving, up the hill!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.DOCKS_REINFORCE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036248)	-- LOCDB [11036248] 'Replacements, move up!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.DOCKS_SPEECH_01 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036249)	-- LOCDB [11036249] 'Move up the hill, drive them back!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.DOCKS_SPEECH_02 = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036250)		-- LOCDB [11036250] 'Charge! Drive the fascists from their holes!' - 'Commissar'
--~ 	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11046947)		-- LOCDB [11046947] 'Charge! Break the German line!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.DOCKS_STUG_SPOTTED = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11036251)	-- LOCDB [11036251] 'StuG!' - 'Soldier_03'
--~ 	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036252)	-- LOCDB [11036252] 'Keep moving; our fighters will deal with them.' - 'Commissar'
--~ 	CTRL.WAIT()
end

EVENTS.DOCKS_CLOSE_IN = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11046653)	-- LOCDB [11046653] 'Close ground and tear them apart!' - 'Commissar'
--~ 	Objective_RemoveUIElements(SOBJ_Docks, hpid_docks_Cen)
--~ 	hpid_docks_Cen = Objective_AddUIElements(SOBJ_Docks, sg_e_docks_central_target, true, 11046814, true)		-- LOCDB [11046814] 'Close-in on enemies in cover.'
	CTRL.WAIT()
end

EVENTS.DOCKS_COMPLETE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11036253)	-- LOCDB [11036253] 'Their line is breaking, they run like cowards!' - 'Soldier_04'
	CTRL.WAIT()
end

------------------------
-- OBJECTIVE: HMG
------------------------

EVENTS.HMG_START = function()
	Game_SetMode(UI_Cinematic)
	
	FOW_RevealArea(Util_GetPosition(mkr_hmg_pin_hintPoint), 20, 8)
	CTRL.Actor_PlaySpeech(ACTOR.None, 11046741)	-- LOCDB [11046741] 'Heavy Machine Gun north of the breach; they have the main route covered.' - 'Intel'
	CTRL.WAIT()
	Camera_MoveTo(mkr_hmg_pin_hintPoint, true, 0.4, false, true)
	CTRL.Actor_PlaySpeech(ACTOR.None, 11046742)	-- LOCDB [11046742] 'Avoid his kill zone.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11036255)	-- LOCDB [11036255] 'Flank the location and clear with grenades.' - 'Intel'
	Camera_MoveTo(mkr_hmg_leftFlank_hintPoint, true, 0.4, false, true)
	CTRL.WAIT()
	Camera_MoveTo(sg_p_shock_01, true, 0.4, false, true)
	
	SGroup_SetInvulnerable(sg_a_hmg_SCR, false)
	
	Game_SetMode(UI_Normal)
	Game_EnableInput(true)
	Camera_SetInputEnabled(true)
end

EVENTS.SHOCK_TROOPS_AVAILABLE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040474)	-- LOCDB [11040474] 'More Shock Troops are available for deployment, comrade!' - 'Commissar'
	CTRL.WAIT()
	if Player_HasAbility(player1, ABILITY.SOVIET.SHOCK_TROOP_DISPATCH_SP) == false then Player_AddAbility(player1, ABILITY.SOVIET.SHOCK_TROOP_DISPATCH_SP) end
	hpid_shock_troop_dispatch = UI_FlashAbilityButton(ABILITY.SOVIET.SHOCK_TROOP_DISPATCH_SP, true)
	CTRL.UI_NewHUDFeature(HUDF_AbilityCard, 11040513, "Icons_units_unit_soviet_shock", 5)
	CTRL.WAIT()
	Rule_AddOneShot(_hmg_remove_shock_ping, 15)
end

EVENTS.HMG_REMIND = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11046743)	-- LOCDB [11046743] 'Get up there and flank that Heavy Machine Gun!' - 'Intel'
	CTRL.WAIT()
end

EVENTS.HMG_NEAR = function()
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.RG_42_ANTI_PERSONNEL_GRENADE, ITEM_DEFAULT)
	fpid_grenade = UI_FlashAbilityButton(ABILITY.SOVIET.RG_42_ANTI_PERSONNEL_GRENADE, true)
	CTRL.UI_NewHUDFeature(HUDF_CommandCard, 11045529, "Icons_abilities_ability_soviet_rg_42_grenade", 5)	-- LOCDB [11045529] 'Shock Troop RG-42 Grenade now available!'
	Rule_AddInterval(Mission_GrantMunitions, 1)
	CTRL.WAIT()
end

EVENTS.HMG_AMBIENT = function()
	if g_difficulty == GD_NORMAL or g_difficulty == GD_HARD then
		HintPoint_Remove(hpid_hmg_flank_left)
		HintPoint_Remove(hpid_hmg_flank_right)
	end
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11036257)		-- LOCDB [11036257] 'This HMG is chewing us apart!' - 'Soldier_03'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036258)		-- LOCDB [11036258] 'Keep advancing, comrade! He cannot stop you all!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.HMG_SUPPRESSED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036259)	-- LOCDB [11036259] 'What are you doing? Stay out of its firing arc!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.HMG_COMPLETE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036476)		-- LOCDB [11036476] 'Their HMG is down - advance!' - 'Commissar'
	CTRL.WAIT()
end

-- Shock troops
EVENTS.SHOCK_TROOPS_DEAD = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036260)	-- LOCDB [11036260] 'Call in more shock troops, comrade commander' - 'Commissar'
	CTRL.WAIT()
end

------------------------
-- OBJECTIVE: Residential
------------------------
EVENTS.ARTY_START = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036261)		-- LOCDB [11036261] 'Comrade; those fucking howitzers are going to annihilate our troops.' - 'Commissar'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036262)	-- LOCDB [11036262] 'Move up, locate and destroy them quickly!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.ARTY_REMIND = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11037840)	-- LOCDB [11037840] 'Silence those howitzers, comrade!' - 'Commissar'
	CTRL.WAIT()
end

--~ EVENTS.BARRAGE_02_WARNING = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11036263)	-- LOCDB [11036263] 'Barrage incoming!' - 'Soldier_03'
--~ 	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036264)	-- LOCDB [11036264] 'Forward, they will not target close to their own!' - 'Commissar'
--~ 	CTRL.WAIT()
--~ end

EVENTS.BARRAGE_03_WARNING = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_06, 11036265)		-- LOCDB [11036265] 'Another artillery barrage!' - 'Soldier_06'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_06, 11036266)	-- LOCDB [11036266] 'Close ground!' - 'Soldier_06'
	CTRL.WAIT()
end

EVENTS.HOWTIZER_01_HMG = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11036267)		-- LOCDB [11036267] 'German MG42 up ahead; we should look for another flanking route.' - 'Soldier_02'
	CTRL.WAIT()
end

EVENTS.ARTY_DEAD = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036268)	-- LOCDB [11036268] 'One gun is down; destroy the other.' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.ARTY_COMPLETE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036269)		-- LOCDB [11036269] 'Artillery guns are down.' - 'Commissar'
	CTRL.WAIT()
end

TEST = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11045528)		-- LOCDB [11045528] 'Your shock troops cannot damage that tank!' - 'Commissar'
	CTRL.WAIT()
end

------------------------
-- OBJECTIVE: Industrial
------------------------
EVENTS.PANZER_SPOTTED = function()
	EventCue_Create(CUE.ATTACKED, 11046815, 11046815, sg_e_panzer, nil, _panToPanzer)	-- LOCDB [11046815] 'Panzer IV'
--~ 	ThreatArrow_CreateGroup(sg_e_panzer)
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11037841)		-- LOCDB [11037841] 'Panzer IV!' - 'Soldier_02'
	CTRL.WAIT()
	hpid_los_01 = HintPoint_Add(mkr_p4_sight_block_01, true, 11046816)		-- LOCDB [11046816] 'Get out of the Panzer's line of sight'
	hpid_los_02 = HintPoint_Add(mkr_p4_sight_block_02, true, 11046816)
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11037842)		-- LOCDB [11037842] 'Comrade, get out of line of sight of it.' - 'Commissar'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11045528)		-- LOCDB [11045528] 'Your shock troops cannot damage that tank!' - 'Commissar'
	CTRL.WAIT()
	HintPoint_Remove(hpid_los_01)
	HintPoint_Remove(hpid_los_02)
end

EVENTS.PANZER_START = function()
	if hpid_los_01 ~= nil then HintPoint_Remove(hpid_los_01) end
	CTRL.Actor_PlaySpeech(ACTOR.None, 11037844)		-- LOCDB [11037844] 'Comrade, that Panzer is going to be an annoyance as we advance.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11037845)		-- LOCDB [11037845] 'The conscripts will keep it occupied - you need to find something to take it out with.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.INDUSTRIAL_REMIND_PAK = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11043341)	-- LOCDB [11043341] 'Capture that Anti-Tank gun!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.INDUSTRIAL_START_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11036270)		-- LOCDB [11036270] 'Comrade, a Panzer IV has been spotted in the ruins to the north.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11036271)		-- LOCDB [11036271] 'Locate an anti-tank weapon to use against it.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.PANZER_COMPLETE = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11036272)	-- LOCDB [11036272] 'Panzer IV is down - you should have a clear attack on the Rail Station!' - 'Intel'
	CTRL.WAIT()
end

EVENTS.ATGUN_START = function()
	FOW_RevealArea(Util_GetPosition(sg_e_at), 5, -1)
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11043342)	-- LOCDB [11043342] 'A German Anti-Tank gun has been spotted in the ruins' - 'Commissar'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036274)	-- LOCDB [11036274] 'Comrade, 'requisition' it for our own use.' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.PANZER_CAPTURE_AT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036275)		-- LOCDB [11036275] 'On that weapon, take possession!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.ATGUN_COMPLETE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11043343)		-- LOCDB [11043343] 'We have the Anti-Tank gun!' - 'Soldier_03'
end

EVENTS.DESTROY_PANZER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11046737)		-- LOCDB [11046737] 'Commander, take the Anti-Tank Gun through the ruins and destroy that Tank!' - 'Commissar'
	CTRL.WAIT()
	hpid_p4_obj = Objective_AddUIElements(OBJ_Panzer, mkr_p4_flank, true, 11040521, true)
end

EVENTS.PANZER_REMIND = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11037847)	-- LOCDB [11037847] 'Take out that Panzer IV!' - 'Commissar'
	CTRL.WAIT()
	hpid_obj_panzer = Objective_AddUIElements(OBJ_Panzer, sg_e_panzer, true, 11036474, true)
end

EVENTS.PANZER_DEFLECT = function()
--~ 	Sound_SetMusicCombatValue(2, 60*99999999)
	Rule_Remove(_panzer_fire_Foward)
	Cmd_Stop(sg_e_panzer)
	Cmd_Attack(sg_e_panzer, sg_p_at, false, true)
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_07, 11036276)	-- LOCDB [11036276] 'Chyort voz'mi! Deflection - fire again!' - 'Soldier_07'
	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_07, 11036277)	-- LOCDB [11036277] 'Oh no! It's turning! Fire!' - 'Soldier_07'
--~ 	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11046831)	-- LOCDB [11046831] 'Shit, reload - hurry!' - 'Soldier_07'
	CTRL.WAIT()
end

EVENTS.PANZER_ALMOST_THERE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_07, 11047645)	-- LOCDB [11047645] 'Oh shit... shit, shit!' - 'Soldier_07'
	CTRL.WAIT()
end

EVENTS.SMOKE_GRENADE_01 = function()
	FOW_RevealSGroupOnly(_tSmokes[1].sg, -1)
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040477)	-- LOCDB [11040477] 'Another HMG' - 'Commissar'
	CTRL.WAIT()
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.RGD_1_SMOKE_GRENADE, ITEM_UNLOCKED)
	hpid_smoke_grenade = HintPoint_Add(mkr_p4_hmg_01_smoke, true, 11046817)		-- LOCDB [11046817] 'Throw a Smoke Grenade.'
	hpid_smoke_flank = HintPoint_Add(mkr_p4_hmg_01_flank, true, 11036469)
	Event_Proximity(_smoke01_clearFlank, nil, player1, mkr_p4_hmg_01_flank, 3, ANY)
	fpid_smoke = UI_FlashAbilityButton(ABILITY.SOVIET.RGD_1_SMOKE_GRENADE, true)
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040478)	-- LOCDB [11040478] 'We need to blind it before we can attempt a flank.  Use a smoke grenade.' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.SMOKE_GRENADE_AWAY = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11046748)	-- LOCDB [11046748] 'Now! Go! Before the smoke clears!' - 'Commissar'
	CTRL.WAIT()
end


------------------------
-- OBJECTIVE: Rail Station
------------------------
--~ EVENTS.RAILSTATION_PINNED = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_05, 11036278)	-- LOCDB [11036278] 'There are too many - we must retreat!' - 'Soldier_05'
--~ 	CTRL.WAIT()
--~ end

--~ EVENTS.RAILSTATION_RETREAT_01 = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11036279)	-- LOCDB [11036279] 'Retreat! We must retreat!' - 'Soldier_03'
--~ 	CTRL.WAIT()
--~ end

EVENTS.RAILSTATION_ATTACK = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_05, 11036280)	-- LOCDB [11036280] 'A frontal assault is suicide!' - 'Soldier_05'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036281)	-- LOCDB [11036281] 'You will attack the German line, or you will die by my pistol!' - 'Commissar'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036282)	-- LOCDB [11036282] 'Now, move!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.RAILSTATION_HMG_START = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11048732)	-- LOCDB [11048732] 'Deal with those machineguns, Commander!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.RAILSTATION_ONE_HMG_DEAD = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11048733)	-- LOCDB [11048733] 'One Machinegun is down!' - 'Soldier_01'
	CTRL.WAIT()
end

EVENTS.RAILSTATION_HMG_REMIND = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11048734)	-- LOCDB [11048734] 'Commander - focus on the machineguns!' - 'Commissar'
	CTRL.WAIT()
end



EVENTS.RAILSTATION_STUG_START = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11048735)	-- LOCDB [11048735] 'Stugs entering the square!' - 'Soldier_01'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11048736)	-- LOCDB [11048736] 'Commander, utilize the Anti-Tank gun and destroy that German Armor!' - 'Commissar'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11048737)	-- LOCDB [11048737] 'Remember to attempt to flank them if you can!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.RAILSTATION_ONE_STUG_DEAD = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11048738)	-- LOCDB [11048738] 'Stug down!' - 'Soldier_01'
	CTRL.WAIT()
end

EVENTS.RAILSTATION_STUG_REMIND = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11048739)	-- LOCDB [11048739] 'Commander! Focus on the Stugs, do not waste your time with the German infantry.' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.RAILSTATION_COMPLETE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11048740)	-- LOCDB [11048740] 'That's it! The Germans are starting to break!' - 'Soldier_01'
	CTRL.WAIT()
end

--~ EVENTS.RAILSTATION_RETREAT_02 = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11037848)	-- LOCDB [11037848] 'There are too many, we must run!' - 'Soldier_03'
--~ 	CTRL.WAIT()
--~ end


--~ EVENTS.RAILSTATION_PICKUP_WEAPONS = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11037849)	-- LOCDB [11037849] 'Comrades, move up and take the weapons of the fallen!' - 'Commissar'
--~ 	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11037850)	-- LOCDB [11037850] 'Use the smokescreen to retrieve those weapons!' - 'Commissar'
--~ 	CTRL.WAIT()
--~ end

--~ EVENTS.RAILSTATION_CALL_IN_MORE = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11041884)	-- LOCDB [11041884] 'Do not be discouraged by losses, call in more conscripts!' - 'Commissar'
--~ 	CTRL.WAIT()
--~ 	UI_FlashAbilityButton(ABILITY.SOVIET.FRONTOVIKI_CONSCRIPT_DISPATCH, true)
--~ end

--~ EVENTS.RAILSTATION_SHOCK_LOST = function()
--~ 	Game_FadeToBlack(FADE_IN, 2.5)
--~ 	Game_SetMode(UI_Normal)
--~ 	Game_EnableInput(true)
--~ 	Camera_SetInputEnabled(true)
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11041881)		-- LOCDB [11041881] 'We have no Shock Troops left to send, commander.' - 'Commissar'
--~ 	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11041882)		-- LOCDB [11041882] 'You will need to press the attack with conscripts' - 'Commissar'
--~ 	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11041883)		-- LOCDB [11041883] 'Push forward, do not stop until you drive them from the Railstation!' - 'Commissar'
--~ 	CTRL.WAIT()
--~ 	Player_AddAbility(player1, ABILITY.SOVIET.FRONTOVIKI_CONSCRIPT_DISPATCH)
--~ 	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.FRONTOVIKI_CONSCRIPT_DISPATCH, ITEM_DEFAULT)
--~ 	UI_FlashAbilityButton(ABILITY.SOVIET.FRONTOVIKI_CONSCRIPT_DISPATCH, true)
--~ 	CTRL.UI_NewHUDFeature(HUDF_AbilityCard, 11045531, "Icons_units_unit_soviet_frontviki", 10)	-- LOCDB [11045531] 'Mobilize Conscripts are now available!'
--~ 	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11037851)	-- LOCDB [11037851] 'Now, comrades - charge!' - 'Commissar'
--~ 	CTRL.WAIT()
--~ end

EVENTS.NORTHLINE_START = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11041885)		-- LOCDB [11041885] 'Onward, comrades - drive them from your city!' - 'Commissar'
	CTRL.WAIT()
end

--~ EVENTS.RAILSTATION_WEAPONS = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_05, 11036283)	-- LOCDB [11036283] 'Pick up those weapons!' - 'Soldier_05'
--~ 	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_05, 11036284)	-- LOCDB [11036284] 'We need those weapons!' - 'Soldier_05'
--~ 	CTRL.WAIT()
--~ end

--~ EVENTS.RAILSTATION_SMOKE_GRENADES = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11036285)	-- LOCDB [11036285] 'Our shock troops have smoke grenades, we should use them!' - 'Soldier_02'
--~ 	CTRL.WAIT()
--~ end

--~ EVENTS.RAILSTATION_FLANK = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11036286)		-- LOCDB [11036286] 'Maybe we can flank their line - through the ruins to the east and west.' - 'Soldier_02'
--~ 	CTRL.WAIT()
--~ end

--~ EVENTS.RAILSTATION_LINE_BREAKING = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11036287)		-- LOCDB [11036287] 'Keep it up! They're taking losses!' - 'Soldier_02'
--~ 	CTRL.WAIT()
--~ end

-- NEW LINES
-- Docks
-- LOCDB [11048730] 'They're shelling the docks, get off the docks!' - 'Commissar'
-- LOCDB [11048731] 'Move! Get off the docks!' - 'Commissar'
-- LOCDB [11048732] 'Deal with those machineguns, Commander!' - 'Commissar'
-- LOCDB [11048733] 'One Machinegun is down!' - 'Soldier_01'
-- LOCDB [11048734] 'Commander - focus on the machineguns!' - 'Commissar'
-- LOCDB [11048735] 'Stugs entering the square!' - 'Soldier_01'
-- LOCDB [11048736] 'Commander, utilize the Anti-Tank gun and destroy that German Armor!' - 'Commissar'
-- LOCDB [11048737] 'Remember to attempt to flank them if you can!' - 'Commissar'
-- LOCDB [11048738] 'Stug down!' - 'Soldier_01'
-- LOCDB [11048739] 'Commander! Focus on the Stugs, do not waste your time with the German infantry.' - 'Commissar'
-- LOCDB [11048740] 'That's it! The Germans are starting to break!' - 'Soldier_01'


-- Germans shout retreat
-- "Scheisze, R�ckzug!"

------------------------
-- OBJECTIVE: Bonus
------------------------
EVENTS.BONUS_ATTENTION = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11036288)		-- LOCDB [11036288] 'Comrade, we have located civilians - they are holed up in a building to the west.' - 'Soldier_04'
	CTRL.WAIT()
end

EVENTS.BONUS_START = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11040479)		-- LOCDB [11040479] 'Help! This is Corporal Aleks; we are requesting support!' - 'Soldier_04'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11040480)		-- LOCDB [11040480] 'We are pinned in an apartment building one kilometer north of the docks.' - 'Soldier_04'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11040481)		-- LOCDB [11040481] 'We have civilians, the Germans are all around us - please help!.' - 'Soldier_04'
	CTRL.WAIT()
end

EVENTS.BONUS_WARNING_01 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11036291)	-- LOCDB [11036291] 'We need help, we have civilians trapped - the Germans are all around us!' - 'Soldier_04'
	CTRL.WAIT()
end

EVENTS.BONUS_WARNING_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11036292)		-- LOCDB [11036292] 'Someone hurry; we can't hold them off for much longer!' - 'Soldier_04'
	CTRL.WAIT()
end

EVENTS.BONUS_LOSS = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_05, 11036293)	-- LOCDB [11036293] 'We have lost contact with the encircled building, commander' - 'Soldier_05'
	CTRL.WAIT()
end

EVENTS.BONUS_COMPLETE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11036294)		-- LOCDB [11036294] 'Thank you, commander - I thought we were done for.' - 'Soldier_04'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_05, 11036295)		-- LOCDB [11036295] 'Let's get these civilians back to the river - go.' - 'Soldier_05'
	CTRL.WAIT()
end

EVENTS.BONUS_COMPLETE_GOOD = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11036294)		-- LOCDB [11036294] 'Thank you, commander - I thought we were done for.' - 'Soldier_04'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_05, 11036295)		-- LOCDB [11036295] 'Let's get these civilians back to the river - go.' - 'Soldier_05'
	CTRL.WAIT()
end

EVENTS.BONUS_FAIR = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11046722)		-- LOCDB [11046722] 'My thanks, commander - it was not looking good.' - 'Soldier_04'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_05, 11046723)		-- LOCDB [11046723] 'Comrades, gather the wounded - we'll take them to the river.' - 'Soldier_05'
	CTRL.WAIT()
end

EVENTS.BONUS_POOR = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11046724)		-- LOCDB [11046724] 'I... thank you, commander.  We managed to save some, but there were so many who...' - 'Soldier_04'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_05, 11046725)		-- LOCDB [11046725] 'Come, we will bury the dead later -get the wounded to the boats.' - 'Soldier_05'
	CTRL.WAIT()
end








