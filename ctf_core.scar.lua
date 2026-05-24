import("ScarUtil.scar")
import("WinConditions/victorypointplusannihilate.scar")
import("Fatalities/Fatalities.scar")

function CTF_PreInit()
	--loadfile("scar/ctf.scar")()
	CTFSystem_Init()
end

Scar_AddInit(CTF_PreInit)


function CTFSystem_Init()
	g_debug = false
	g_text = ""
	g_flags = {}
	g_flag_spawn_positions = {}
	CTF_Msg("getting VPs..\n")
	g_victorypoints = World_GetEntitiesByBlueprint("victory_point")
	for k, v in pairs(g_victorypoints) do
		CTF_Msg(scartype_tostring(k).." = "..scartype_tostring(v).."\n");
	end
	
	local flag_counter = 0
	for key, entity in pairs(g_victorypoints) do
		flag_counter = flag_counter + 1
		if flag_counter <= 2 then
			table.insert(g_flags, {pos = Entity_GetPosition(entity)})
		end
		table.insert(g_flag_spawn_positions, {in_use = false, pos = Entity_GetPosition(entity)})
		Entity_Destroy(entity)
		
		
	end
	
	Rule_AddOneShot(CTFSystem_InitDelayed, 0.5)
end

--Scar_AddInit(CTFSystem_Init)

function World_GetEntitiesByBlueprint(ebp)
	local result = {}
	if scartype(ebp) == ST_STRING then
		ebp = BP_GetEntityBlueprint(ebp)
	end
	for i = 0, World_GetNumEntities() -1 do
		local entity = World_GetEntity(i)
		if Entity_GetBlueprint(entity) == ebp then
			table.insert(result, entity)
		end
	end
	
	return result
end

function CTF_GetRandomFlagSpawnPosition()
	local free_spawn_positions = {}
	for key, spawn in ipairs(g_flag_spawn_positions) do
		if not spawn.in_use then
			table.insert(free_spawn_positions, {key = key, pos = spawn.pos})
		end
	end
	
	local random_pos = Table_GetRandomItem(free_spawn_positions)
	g_flag_spawn_positions[random_pos.key].in_use = true
	CTF_Msg("returning pos "..random_pos.key.."\n")
	return random_pos.pos
end

function CTF_FreeFlagSpawnPosition(pos)
	for key, spawn in ipairs(g_flag_spawn_positions) do
		if spawn.pos == pos then
			spawn.in_use = false
			CTF_Msg("freed pos "..key.."\n")
			break
		end
	end
end

function CTFSystem_InitDelayed()
	for key, _flag in ipairs(g_flags) do
		local spawn_pos = CTF_GetRandomFlagSpawnPosition()
		_flag.id = key
		_flag.captured = false
		_flag.spawned = false
		_flag.carrier = ""
		_flag.eid = 0
		_flag.hintid = -1
		_flag.current_pos = spawn_pos
		_flag.pos = spawn_pos
		CTF_Msg("looped through flag #"..key.."\n")
	end
	
	local colorUnPacker = {
		__call = function(t)
			return unpack(t)
		end
	}
	colors = {
		yellow = {176, 253, 125, 0},
		red = {255, 0, 0, 0},
		green = {0, 255, 0, 0},
		
	}
	
	for key, _t in pairs(colors) do
		setmetatable(_t, colorUnPacker)
	end
	
	g_last_flag_spawn_time = World_GetGameTime()
	g_flag_score = {[0] = 0, [1] = 0}
	g_flag_carriers = {}
	g_flag_carrier_slot_items = {}
	g_disabled_carrier_vehicles = {}
	g_cant_load_squad_hint = {}
	g_unrecrewable_entities = {}
	g_unrecrewable_entities_msg = {}
	g_move_flag_here_ui = {}
	g_flagbases = {}
	g_drop_flag_requests = {}
	g_flag_carrying_squads = {}
	g_resource_modifiers = {}
	g_delayed_ability_duration_fixes = {}
	g_oorah_penalties = {}
	g_for_mother_russia_penalties = {}
	g_fast_march_penalties = {}
	g_players_doing_for_mother_russia = {}
	g_players_doing_fast_march = {}
	g_global_speed_ability_monitor_squads = {}
	g_added_flag_carrier_penalty_abilities = {}
	g_posture_speeed_modifiers = {}
	g_flag_cap_distance = 25
	g_win_flag_score = CTF_GetWinScoreLimit()
	g_victory_points_per_score = 50
	g_minimap_blip_time = 5
	g_minimap_blip_flag_is_here_time = 1
	g_flag_carrier_safe_radius = 10
	g_kickeroffset = 4
	g_flag_respawn_cooldown = 60
	g_flagcarrier_text = Util_CreateLocString("Flag Carrier")
	g_retreat_locked_reason = Util_CreateLocString("You cannot retreat while holding a flag.")
	g_obj_ui_flag_text = Util_CreateLocString("Capture")
	g_obj_ui_flag_prespawn_text = Util_CreateLocString("a Flag will soon spawn here")
	g_unable_to_hold_flag_text = Util_CreateLocString("Flags are too heavy for transport.")
	g_text_can_load_squads_again = Util_CreateLocString("Unlocked")
	g_text_entity_capture_disabled = Util_CreateLocString("Locked")
	g_text_entity_capture_enabled = Util_CreateLocString("Unlocked")
	g_text_cannot_load_squads = Util_CreateLocString("Can't load flags!")
	g_text_move_flag_here = Util_CreateLocString("Move captured flag here to score")
	g_text_dropped_flag = Util_CreateLocString("Flag dropped")
	g_text_resetted_flag = Util_CreateLocString("Flag reset")
	g_text_drop_flag_cancel = Util_CreateLocString("Flag drop cancelled")
	g_text_drop_flag_call = Util_CreateLocString("Preparing to drop flag")
	g_text_progressbar = Util_CreateLocString("Next Flag cooldown")
	g_intro_text = Util_CreateLocString("This is Capture the Flag. Capture and bring any of the flags to your base "..g_win_flag_score.." times to win.")
	g_text_drop_flag = Util_CreateLocString("Drop Flag")
	g_flag_captured_text = " captured a flag!"
	g_flag_scored_text = " scored a point!"
	g_flag_dropped_text = " dropped a flag!"
	g_objectives_started = false
	g_music = "streamed/music/multiplayer/complete_mp_music"
	g_icon_unable_to_hold_flag = "Icons_commands_icon_command_stop"
	g_flag_icon = "Icons_commands_icon_command_rallypoint"
	g_flag_icon_obj_ui = "Icons_commands_icon_command_rallypoint"
	g_flag_icon_squad = "Icons_commands_icon_command_rallypoint"
	g_damage_engine_icon = "Icons_tooltips_vehicle_critical_major_exhaustdamaged"
	g_team_allies_text = 	"Team Allies Score: "
	g_team_axis_text = 		"Team Axis Score:   "
	g_alarm_sound = "campaign/alarm_klaxon"
	g_score_sound = "speech/victory_defeat/gvictory"
	g_ability_drop_flag = BP_GetAbilityBlueprint("81548837018f4865b26b4cc84c87e722:ctf_drop_flag_ability")
	g_upgrade_flag_carrier_penalties_enable = BP_GetUpgradeBlueprint("81548837018f4865b26b4cc84c87e722:ctf_flag_carrier_speed_penalty")
	g_ability_flag_carrier_penalties = BP_GetAbilityBlueprint("81548837018f4865b26b4cc84c87e722:ctf_toggle_flag_carrier_penalties")
	g_misc_player = World_GetPlayerAt(1)
	
	Players_ForEach(function (pid, idx, player)
		g_flagbases["player_"..pid] = Player_GetStartingPosition(player)
	end)
	
	Sound_PreCacheSound(g_alarm_sound)
	Sound_PreCacheSound(g_score_sound)
	g_alarm_play = nil
	if g_debug then
		AI_EnableAll(false)
		FOW_Enable(false)
	end
	
	sg_flagseek = SGroup_CreateIfNotFound("sg_flagseek")
	sg_flagseek2 = SGroup_CreateIfNotFound("sg_flagseek2")
	sg_squadsheld = SGroup_CreateIfNotFound("sg_squadsheld")
	sg_squadsaround = SGroup_CreateIfNotFound("sg_squadsaround")
	eg_entitiesaround = EGroup_CreateIfNotFound("eg_entitiesaround")
	sg_clear_slotitems = SGroup_CreateIfNotFound("sg_clear_slotitems")
	sg_allctf = SGroup_CreateIfNotFound("sg_allctf")
	sid_flag_carrier = nil
	slotitem_flag = BP_GetSlotItemBlueprint("soviet_flag")
	ebp_flag = BP_GetEntityBlueprint("soviet_flag")

	Rule_AddOneShot(CTF_ObjctiveInit, 0.01)
end

function CTF_StartCore()
	Rule_Add(CTF_FlagStateMonitor)
	Rule_Add(CTF_FlagRespawnMonitor)
	
	
	Rule_AddInterval(CTF_FlagScoreMonitor, 1)
	Rule_AddInterval(CTF_BlinkFlagCarriers, 7)
	Rule_Add(CTF_DropFlagRequestManager)
	Rule_Add(CTF_PreventFlagCarrierReCrewAndVehicleGarrisoning)
end

function CTF_GetWinScoreLimit()
	local vp_tickers = VPTicker_GetTeamTickers(0)
	
	if vp_tickers > 0 and vp_tickers <= 250 then
		return 5
	elseif vp_tickers > 250 and vp_tickers <= 500 then
		return 10
	elseif vp_tickers > 500 then
		return 20
	else
		return 10
	end
end
--[[
	Squad_AddFlagCarrierEffects:
		- Add drop flag ability
		- register as flag carrier
		- enable flag carrier UI
		- monitor Death
		- Modify speed
		- Disable capping ability
		- modify vulnerability
		- monitor abilities
	Squad_RemoveFlagCarrierEffects:
		- disable flag carrier UI
		- unregister as flag carrier
		- modify speed
		- remove drop flag ability
		- modify vulnerability
		- remove ability monitor
		- enable capping

]]

function CTF_FlagScoreMonitor()
	if g_flag_score[0] >= g_win_flag_score then
		Rule_RemoveAll()
		Annihilate_GameOver(0, 1)
	elseif g_flag_score[1] >= g_win_flag_score then
		Rule_RemoveAll()
		Annihilate_GameOver(1, 1)
	end
end

function CTF_BlinkFlagCarriers()
	for key, flag_carrier_sid in pairs(g_flag_carrying_squads) do
		if Squad_IsValid(flag_carrier_sid) then
			local squad = Squad_FromWorldID(flag_carrier_sid)
			if Squad_CarriesFlag(squad) then
				local pos = Squad_GetPosition(squad)
				UI_CreateMinimapBlip(pos, g_minimap_blip_flag_is_here_time, BT_CaptureHere)
				CTF_Msg("blinking squad..\n")
			end
		end
	end
	
	if g_flag_respawn_running then
		local pos = g_next_flag_spawn.spawn_pos
		UI_CreateMinimapBlip(pos, g_minimap_blip_flag_is_here_time, BT_General)
	end
end



function CTF_FlagRespawnMonitor()
	if g_flag_respawn_running then
		Objective_Show(OBJ_Main, false)
		Obj_ShowProgress(Util_CreateLocString("Flag "..g_next_flag_spawn.id.." dispatch progress"), Objective_GetTimerSeconds(OBJ_Main) / g_flag_respawn_cooldown)
	end
	for key, flag in ipairs(g_flags) do
		if not Entity_IsValid(flag.eid) then
			if not flag.captured and not flag.spawned and not flag.dropped and not flag.reset then
				if not g_flag_respawn_running then
					
					local title = Util_CreateLocString("Time until Flag "..flag.id.." spanws")

					Objective_StartTimer(OBJ_Main, COUNT_DOWN, g_flag_respawn_cooldown, 10)
					Objective_Show(OBJ_Main, false)
					g_flag_respawn_running = true
					g_next_flag_spawn = {spawn_pos = flag.current_pos, id = flag.id}
					flag.minimap_blip_prespawn = UI_CreateMinimapBlip(flag.current_pos, -1, BT_ObjectiveSecondary)

					FOW_RevealArea(flag.current_pos, 5, -1)
											--HintPoint_AddToPosition(where, priority, bVisible, nothing, hintText, true, Offset, 0, actionType, iconName)
											--HintPoint_AddToPosition(flag.current_pos, 1, true, print, g_obj_ui_flag_prespawn_text, true, World_Pos(0, 4.5, 0), 0, HPAT_Critical, g_flag_icon_obj_ui)
											
					flag.prespawn_hint = HintPoint_Add(flag.current_pos, true, g_obj_ui_flag_prespawn_text, 4.5, HPAT_Critical, g_flag_icon_obj_ui, 1)
				elseif g_flag_respawn_running and Objective_GetTimerSeconds(OBJ_Main) <= 0 then
					if flag.id == g_next_flag_spawn.id then
						Obj_HideProgress()
						g_flag_respawn_running = false
						HintPoint_RemoveInternal(flag.prespawn_hint)
						Objective_Show(OBJ_Main, false)
						local msg = Util_CreateLocString("Flag "..flag.id.." is now available for capturing!")
						Util_GlobalMessage(msg, 4)
						local spawn_pos = g_next_flag_spawn.spawn_pos
						e_flag = Entity_Create(ebp_flag, World_GetPlayerAt(1), spawn_pos, spawn_pos)

						Entity_Spawn(e_flag)
						CTF_FixFlagColorDelayed()

						flag.spawned = true
						flag.eid = Entity_GetGameID(e_flag)	
						flag.minimap_blip = UI_CreateMinimapBlip(flag.current_pos, -1, BT_ObjectivePrimary)
						UI_DeleteMinimapBlip(flag.minimap_blip_prespawn)

						CTF_Msg("spawning flag #" .. key.." with id "..flag.eid.."\n")
						if g_objectives_started then
							CTF_UpdateObjectiveUI(flag)
							CTF_Msg("Adding obj hint for "..flag.objui_id.."\n")
						end
					end
				end
			elseif not flag.captured and not flag.spawned and (flag.dropped or flag.reset) then
				local spawn_pos = flag.current_pos
				e_flag = Entity_Create(ebp_flag, World_GetPlayerAt(1), spawn_pos, spawn_pos)

				Entity_Spawn(e_flag)
				CTF_FixFlagColorDelayed()

				flag.spawned = true
				flag.dropped = false
				flag.reset = false
				flag.eid = Entity_GetGameID(e_flag)	
				flag.minimap_blip = UI_CreateMinimapBlip(flag.current_pos, -1, BT_ObjectivePrimary)
				UI_DeleteMinimapBlip(flag.minimap_blip_prespawn)
				FOW_RevealArea(flag.current_pos, 5, -1)
				CTF_Msg("spawning flag #" .. key.." with id "..flag.eid.."\n")
				if g_objectives_started then
					CTF_UpdateObjectiveUI(flag)
					CTF_Msg("Adding obj hint for "..flag.objui_id.."\n")
				end
			end
		end
	end	
end

function CTF_FlagStateMonitor()
	for key, flag in ipairs(g_flags) do
		if not Entity_IsValid(flag.eid) then	
			if not flag.captured and flag.spawned then
				Players_ForEach(function (pid, idx, player)
					SGroup_Clear(sg_flagseek)
					Player_GetAll(player, sg_flagseek)
					
					SGroup_ForEach(sg_flagseek, function(sgid, idx, squad)
						if Squad_CarriesFlag(squad) and not Squad_IsRegisteredFlagCarrier(squad) then
							Squad_AddFlagCarrierEffects(squad, flag)
							flag.captured = true
							flag.spawned = false
							flag.carrier = Squad_GetGameID(squad)
							FOW_UnRevealArea(flag.current_pos, 5)
							UI_DeleteMinimapBlip(flag.minimap_blip)
							CTF_Msg("Removing obj hint for "..flag.objui_id.."\n")
							HintPoint_RemoveInternal(flag.objui_id)
						end
					end)
				end)
			elseif flag.captured then
				if Squad_IsValid(flag.carrier) then
					local squad = Squad_FromWorldID(flag.carrier)
					local player = Squad_GetPlayerOwner(squad)
					local pid = Player_GetID(player)
					local team = Player_GetTeam(player)
					local destination = g_flagbases["player_"..pid]
					local spos = Squad_GetPosition(squad)
			
					if World_DistancePointToPoint(spos, destination) < g_flag_cap_distance then
						flag.current_pos = flag.pos
						flag.captured = false
						CTF_FreeFlagSpawnPosition(flag.current_pos)
						flag.current_pos = CTF_GetRandomFlagSpawnPosition()
						Squad_IncreaseVeterancyExperience(squad, 500, false, true)
						Squad_RemoveFlagCarrierEffects(squad, flag)
						CTF_FlagScored(squad)
					end
				end
			end
		end
	end
end

function CTF_EnableResources(enable)
	local _restypes = {RT_Manpower, RT_Fuel, RT_Munition}
	if enable then
		Players_ForEach(function (pid, idx, player)
			CTF_Msg("removing modifier for "..pid.."\n")
			for key, RT in ipairs(_restypes) do
				Modifier_Remove(g_resource_modifiers["player_"..pid..key])
			end
		end)
	else
		Players_ForEach(function (pid, idx, player)
			CTF_Msg("adding modifier for "..pid.."\n")
			for key, RT in ipairs(_restypes) do
				g_resource_modifiers["player_"..pid..key] = Modify_PlayerResourceRate(player, RT, 0)
			end
		end)
	end
end


function CTF_UpdateObjectiveUI(flag)
	Objective_RemoveUIElements(OBJ_Main_TEAM1, flag.objui_id)
	flag.objui_id = CTF_AddObjectiveUI(flag)
end

function CTF_FixFlagColor()
	for key, flag in ipairs(g_flags) do
		if Entity_IsValid(flag.eid) then
			local e_flag = Entity_FromWorldID(flag.eid)
			Entity_SetWorldOwned(e_flag)
		end
	end
	Rule_RemoveMe()
end

function CTF_FixFlagColorDelayed()
	if TimeRule_Exists(CTF_FixFlagColor) then
		TimeRule_Remove(CTF_FixFlagColor)
	end
	Rule_AddOneShot(CTF_FixFlagColor, 0.01)
end

function CTF_StopAlarm()
	Sound_Stop(g_alarm_play)
	Rule_RemoveMe()
end

function CTF_FlagCarrierAbilityExecuted(caster, ability, target)
	local sid = Squad_GetGameID(caster)
	local owner = Squad_GetPlayerOwner(caster)
	local pos = Squad_GetPosition(caster)
	if ability == g_ability_drop_flag and not g_drop_flag_requests["squad_"..sid] then
		g_drop_flag_requests["squad_"..sid] = {
			activation_time = World_GetGameTime(),
			sid = sid,
		}
		UI_GlobalKickerMessage(owner, {pos, g_text_drop_flag_call, colors.red()})
		
	elseif ability == g_ability_drop_flag and g_drop_flag_requests["squad_"..sid] then
		g_drop_flag_requests["squad_"..sid] = nil
		UI_GlobalKickerMessage(owner, {pos, g_text_drop_flag_cancel, colors.green()})
	end
end

function CTF_DropFlagRequestManager()
	for key, dropper in pairs(g_drop_flag_requests) do
		if Squad_IsValid(dropper.sid) then
			local squad = Squad_FromWorldID(dropper.sid)
			if World_GetGameTime() - dropper.activation_time >= 5 then
				Squad_FlagCarrierDeath(squad, "disable_ui", false)
				g_drop_flag_requests[key] = nil
			end
		else
			g_drop_flag_requests[key] = nil
		end
	end
end

function CTF_PreventFlagCarrierReCrewAndVehicleGarrisoning()
	for key, squad_id in pairs(g_disabled_carrier_vehicles) do
		if Squad_IsValid(squad_id) then
			local squad = Squad_FromWorldID(squad_id)
			local pos = Squad_GetPosition(squad)
			SGroup_Clear(sg_squadsaround)
			World_GetSquadsNearPoint(Squad_GetPlayerOwner(squad), sg_squadsaround, pos, g_flag_carrier_safe_radius+1, OT_Player)
			if not SGroup_IsCarryingFlag(sg_squadsaround) then
				Modify_DisableHold(Squad_GetTempSGroup(squad), false)
				CTF_Msg("Squad is now able to carry units\n")
				g_disabled_carrier_vehicles[key] = nil
				pos.y = pos.y + g_kickeroffset
				local owner = Squad_GetPlayerOwner(squad)
				UI_LocalKickerMessage(owner, {pos, g_text_can_load_squads_again, colors.green()})
			end
		else
			g_disabled_carrier_vehicles[key] = nil
		end
	end
	for key, _entity in pairs(g_unrecrewable_entities) do
		if Entity_IsValid(_entity) then
			local entity = Entity_FromWorldID(_entity)
			local pos = Entity_GetPosition(entity)
			local flags_nearby = false

			Players_ForEach(function (pid, idx, player)
				SGroup_Clear(sg_squadsaround)
				World_GetSquadsNearPoint(player, sg_squadsaround, pos, g_flag_carrier_safe_radius+1, OT_Player)
				if SGroup_IsCarryingFlag(sg_squadsaround) then
					flags_nearby = true
				end
			end
			)
			
			if not flags_nearby and Entity_IsReCrewable(entity) then
				Entity_SetRecrewable(entity, true)
				local pos = Entity_GetPosition(entity)
				UI_GlobalKickerMessage(g_misc_player, {pos, g_text_entity_capture_enabled, colors.green()})
				g_unrecrewable_entities[key] = nil
				g_unrecrewable_entities_msg[key] = nil
			end
		else
			g_unrecrewable_entities[key] = nil
		end
	end
	
	Players_ForEach(function (pid, idx, player)
		SGroup_Clear(sg_squadsheld)
		Player_GetAll(player, sg_squadsheld)
		
		SGroup_ForEach(sg_squadsheld, function(sgid, idx, squad)
			if Squad_CarriesFlag(squad) then
				local pos = Squad_GetPosition(squad)
				SGroup_Clear(sg_squadsaround)
				EGroup_Clear(eg_entitiesaround)
				World_GetSquadsNearPoint(player, sg_squadsaround, pos, g_flag_carrier_safe_radius, OT_Player)
				World_GetNeutralEntitiesNearPoint(eg_entitiesaround, pos, g_flag_carrier_safe_radius)
				
				EGroup_ForEach(eg_entitiesaround, function(egid, idx, entity)
					local eid = Entity_GetGameID(entity)
					local entity_key = "entity_"..eid
					if Entity_IsReCrewable(entity) then
						Entity_SetRecrewable(entity, false)
						if not g_unrecrewable_entities_msg[entity_key] then
							local pos = Entity_GetPosition(entity)
							UI_GlobalKickerMessage(g_misc_player, {pos, g_text_entity_capture_disabled, colors.red()})
							g_unrecrewable_entities_msg[entity_key] = true
						end
						
						g_unrecrewable_entities[entity_key] = eid
					end
				end)
				
				SGroup_ForEach(sg_squadsaround, function(sgid, idx, _squad)
					local sid = Squad_GetGameID(_squad)
					if Squad_CanHold(_squad) and not g_disabled_carrier_vehicles["squad_"..sid] then
						g_disabled_carrier_vehicles["squad_"..sid] = sid
						Modify_DisableHold(Squad_GetTempSGroup(_squad), true)
						local pos = Squad_GetPosition(_squad)
						pos.y = pos.y + g_kickeroffset
						local owner = Squad_GetPlayerOwner(_squad)
						UI_LocalKickerMessage(owner, {pos, g_text_cannot_load_squads, colors.red()})
						CTF_Msg("squad is no longer able to carry squads\n")
					end
				end)
			end
		end)
	end)
	
	for key, carrier in pairs(g_flag_carrying_squads) do
		if Squad_IsValid(carrier) then
			local squad = Squad_FromWorldID(carrier)
			if Squad_CarriesFlag(squad) and Squad_IsRetreating(squad) then
				Squad_FlagCarrierDeath(squad, "disable_ui", true)
				g_flag_carriers[key] = nil
			end
		else
			g_flag_carriers[key] = nil
		end
	end
end

function CTF_FlagCaptured(squad)
	local player = Squad_GetPlayerOwner(squad)
	local title = Util_CreateLocString(Player_GetName(player)..g_flag_captured_text)
	local pos = Squad_GetPosition(squad)
	UI_CreateEventCueClickable(g_flag_icon, "", title, title, print, 10, true)
	UI_CreateMinimapBlip(pos, g_minimap_blip_time, BT_General)
	if g_alarm_play then Sound_Stop(g_alarm_play) end
	g_alarm_play = Sound_Play2D(g_alarm_sound)
	if TimeRule_Exists(CTF_StopAlarm) then
		TimeRule_Remove(CTF_StopAlarm)
	end
	Rule_AddOneShot(CTF_StopAlarm, 2)
	Player_EnableMoveFlagHereUI(player, true)
end

function CTF_FlagDropped(squad, reset)
	local player = Squad_GetPlayerOwner(squad)
	local title = Util_CreateLocString(Player_GetName(player)..g_flag_dropped_text)
	local pos = Squad_GetPosition(squad)
	UI_CreateEventCueClickable(g_flag_icon, "", title, title, print, 10, true)
	UI_CreateMinimapBlip(pos, g_minimap_blip_time, BT_General)
	if reset then
		UI_LocalKickerMessage(player, {pos, g_text_resetted_flag, colors.red()})
	else 
		UI_LocalKickerMessage(player, {pos, g_text_dropped_flag, colors.yellow()})
	end
	Player_EnableMoveFlagHereUI(player, false)
end

function CTF_FlagScored(squad)
	local player = Squad_GetPlayerOwner(squad)
	local title = Util_CreateLocString(Player_GetName(player)..g_flag_scored_text)
	local pos = Squad_GetPosition(squad)
	UI_CreateEventCueClickable(g_flag_icon, "", title, title, print, 10, true)	
	UI_CreateMinimapBlip(pos, g_minimap_blip_time, BT_General)
	local team = Player_GetTeam(player)
	g_flag_score[team] = g_flag_score[team] + 1
	local more_scores = (g_win_flag_score - g_flag_score[team]).. " more scores to victory!"
	
	if g_flag_score[team] == g_win_flag_score then
		more_scores = ""
	end
	
	CTF_Msg("Team #"..team.." scored and their score is now "..g_flag_score[team]..". "..more_scores.."\n")
	local base_text = Team_GetTitle(team)
	local obj
	if team == 0 then
		obj = OBJ_Main_TEAM1
	elseif team == 1 then
		obj = OBJ_Main_TEAM2
	end
	CTF_TeamFlagScore(team)
	local title = Util_CreateLocString("Team "..base_text.."\n scored and their new score is "..g_flag_score[team]..". "..more_scores.."\n")
	Util_GlobalMessage(title, 4)
	
	local title = Util_CreateLocString("Team "..base_text.." score: "..g_flag_score[team].."/"..g_win_flag_score)
	Objective_UpdateText(obj, title, title, false)
	Sound_Play2D(g_score_sound)
	--local title = Util_CreateLocString(Player_GetName(player)..g_flag_scored_text.." ["..g_flag_score[team].."/"..g_win_flag_score.."]")
	
	Player_EnableMoveFlagHereUI(player, false)
end



function CTF_GetOpposingTeam(team)
	if team == 0 then
		return 1
	elseif team == 1 then
		return 0
	end
end
function CTF_TeamFlagScore(team)
	local opposingTeam = CTF_GetOpposingTeam(team)
	local tickers = VPTicker_GetTeamTickers(opposingTeam)
	local new_tickers = tickers - g_victory_points_per_score
	if new_tickers < 0 then new_tickers = 0 end
	VPTicker_SetTeamTickers(opposingTeam, new_tickers, true)
end

function CTF_ObjctiveInit()
	UI_NewHUDFeature(HUDF_None, g_intro_text, g_flag_icon, 15)
	Sound_PlayMusic(g_music, 0, 0)
	OBJ_Main = {
		Title = Util_CreateLocString("Time left until Flag 1 spawns"), Type = OT_Primary, Intel_Start = nil, Intel_Start_SkipFunc = nil,	
		SetupUI = function() 
		end,	
		OnStart = function()
		end,	
		Intel_Complete = nil, Intel_Complete_SkipFunc = nil,	
		OnComplete = function()		
		end,
		Intel_Fail = nil, Intel_Fail_SkipFunc = nil,
		OnFail = function()	
		end,
	}
	OBJ_Main_TEAM1 = {
		Title = Util_CreateLocString("Team "..Team_GetTitle(0).." score: 0/"..g_win_flag_score), Type = OT_Primary, Intel_Start = nil, Intel_Start_SkipFunc = nil,	
		SetupUI = function() 
		end,	
		OnStart = function()
		end,	
		Intel_Complete = nil, Intel_Complete_SkipFunc = nil,	
		OnComplete = function()		
		end,
		Intel_Fail = nil, Intel_Fail_SkipFunc = nil,
		OnFail = function()	
		end,
	}
	OBJ_Main_TEAM2 = {
		Title = Util_CreateLocString("Team "..Team_GetTitle(1).." score: 0/"..g_win_flag_score), Type = OT_Primary, Intel_Start = nil, Intel_Start_SkipFunc = nil,	
		SetupUI = function() 	
		end,	
		OnStart = function()
		end,	
		Intel_Complete = nil, Intel_Complete_SkipFunc = nil,	
		OnComplete = function()		
		end,
		Intel_Fail = nil, Intel_Fail_SkipFunc = nil,
		OnFail = function()	
		end,
	}
	
	Objective_Register(OBJ_Main)
	Objective_Register(OBJ_Main_TEAM1)
	Objective_Register(OBJ_Main_TEAM2)
	Objective_Start(OBJ_Main, false)
	Objective_Start(OBJ_Main_TEAM1, false)
	Objective_Start(OBJ_Main_TEAM2, false)
	
	Objective_Show(OBJ_Main, false)
	
	g_objectives_started = true
	Rule_AddOneShot(CTF_StartCore, 0.125)
end

function CTF_AddObjectiveUI(flag)
	return HintPoint_Add(flag.current_pos, true, g_obj_ui_flag_text, 4.5, HPAT_Critical, g_flag_icon_obj_ui, 1)
	--return HintPoint_AddToPosition(flag.current_pos, 1, true, print, g_obj_ui_flag_text, true, World_Pos(0, 4.5, 0), 0, HPAT_Critical, g_flag_icon_obj_ui)
end

function Util_GlobalMessage(title, displaytime)
	Game_TextTitleFade(title, 0, displaytime, 2)
end
function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end
function Util_Tester(f, v)
	local success, result = xpcall(function() return f(unpack(v)) end, function() end)
	return success or false	
end
function Entity_IsReCrewable(entity)
	if Util_Tester(Entity_SetRecrewable, {entity, true}) then
		return true
	end
	return false
end

function Squad_AddFlagCarrierEffects(squad, flag)
	local owner = Squad_GetPlayerOwner(squad)
	Squad_AddAbility(squad, g_ability_drop_flag)
	g_text_drop_flag_ability_hint = Util_CreateLocString("Click here to drop the flag (5 second timer)")
	UI_AddHintAndFlashAbility(owner, g_ability_drop_flag, g_text_drop_flag_ability_hint, 3)
	Squad_RegisterFlagCarrier(squad, flag.id)
	Squad_EnableFlagCarrierUI(squad, flag)
	Squad_MonitorDeath(squad)
	--Squad_CompleteUpgrade(squad, g_upgrade_flag_carrier_penalties_enable)
	local key = "squad_"..Squad_GetGameID(squad)
	if not g_added_flag_carrier_penalty_abilities[key] then
		g_added_flag_carrier_penalty_abilities[key] = true
		--Squad_AddAbility(squad, g_ability_flag_carrier_penalties)
		CTF_Msg("added ability g_ability_flag_carrier_penalties\n")
	end
	local sid = "squad_"..Squad_GetGameID(squad)
	g_posture_speeed_modifiers[sid] = Squad_ModifyInfantrySpeed(squad, -1000, true)
	--Cmd_Ability(Squad_GetTempSGroup(squad), g_ability_flag_carrier_penalties)
	
	CTF_Msg("~~Modified squad posture speed with an upgrade\n")
	Squad_SetCaptureEnabled(squad, false)
	Modify_Vulnerability(Squad_GetTempSGroup(squad), 1.25)
	Rule_AddSquadEvent(CTF_FlagCarrierAbilityExecuted, squad, GE_AbilityExecuted)
end

function Squad_RemoveFlagCarrierEffects(squad, flag)
	Squad_DisableFlagCarrierUI(squad, false, flag)
	Squad_UnRegisterFlagCarrier(squad)
	--Squad_RemoveUpgrade(squad, g_upgrade_flag_carrier_penalties_enable)
	CTF_Msg("~~removed squad posture speed modifier (upgrade)\n")
	--Cmd_Ability(Squad_GetTempSGroup(squad), g_ability_flag_carrier_penalties)
	local sid = "squad_"..Squad_GetGameID(squad)
	Modifier_Remove(g_posture_speeed_modifiers[sid])
	Squad_RemoveAbility(squad, g_ability_drop_flag)
	Modify_Vulnerability(Squad_GetTempSGroup(squad), 0.8)
	Rule_RemoveSquadEvent(CTF_FlagCarrierAbilityExecuted, squad)
	Squad_SetCaptureEnabled(squad, true)
end

function Squad_SetCaptureEnabled(squad, enabled)
	local _enable = -1
	if enabled then
		_enable = 1
	end
	Util_ApplyModifier(Squad_GetTempSGroup(squad), "capture_enable_squad_modifier", _enable, MUT_Enable)
end
function Squad_EnableFlagCarrierUI(squad, flag)
	if flag.hintid then
		HintPoint_RemoveInternal(flag.hintid)
	end
	sid_flag_carrier = Squad_GetGameID(squad)
	--flag.hintid = HintPoint_AddToSquad(squad, 1, true, print, g_flagcarrier_text, true, 0.7, 0, HPAT_Attack, g_flag_icon_squad)
	flag.hintid = HintPoint_Add(squad, true, g_flagcarrier_text, 0.7, HPAT_Attack, g_flag_icon_squad, 1)
	CTF_FlagCaptured(squad)
end
function Squad_EnableCantHoldUI(squad)
	local owner = Squad_GetPlayerOwner(squad)
	
	if Player_IsLocalPlayer(owner) then
		local sid = Squad_GetGameID(squad)
		if g_cant_load_squad_hint["squad_"..sid] then
			HintPoint_RemoveInternal(g_cant_load_squad_hint["squad_"..sid].id)
		end
		local new_hint = {
			id = HintPoint_AddToSquad(squad, 1, true, print, g_unable_to_hold_flag_text, true, 0.5, 0, HPAT_Attack, g_icon_unable_to_hold_flag),
			spawn_time = World_GetGameTime(),
			owner = Player_GetID(owner),
		}
		g_cant_load_squad_hint["squad_"..sid] = new_hint
	end
end
function Squad_ModifyInfantrySpeed(squad, addition, exclusive)
	local modifier = Modifier_Create(MAT_Squad, "modifiers\\posture_speed_modifier.lua", MUT_Addition, exclusive, addition, "")
	local result = {}
	
	local modid = Modifier_ApplyToSquad(modifier, squad)
	table.insert(result, modid)
	Modifier_AddToSquadTable(squad, modid)	
	return result	
end


function Squad_MonitorDeath(squad)
	Rule_RemoveSquadEvent(Squad_FlagCarrierDeath, squad)
	Rule_AddSquadEvent(Squad_FlagCarrierDeath, squad, GE_SquadKilled)
end
function Squad_GetTempSGroup(squad)
	local sg_squadtemp = SGroup_CreateIfNotFound("sg_squadtemp")
	SGroup_Clear(sg_squadtemp)
	SGroup_Add(sg_squadtemp, squad)
	return sg_squadtemp
end
function Squad_DisableFlagCarrierUI(squad, dead, flag)
	if flag.hintid then
		HintPoint_RemoveInternal(flag.hintid)
	end
	
	if not dead then
		local sid = Squad_GetGameID(squad)
		local items = g_flag_carrier_slot_items["squad_"..sid]
		local player = Squad_GetPlayerOwner(squad)
		SGroup_Clear(sg_clear_slotitems)
		SGroup_Add(sg_clear_slotitems, squad)
		Command_Squad(player, sg_clear_slotitems, SCMD_SlotItemRemove, false)
		
		for key, slotitem in ipairs(items) do
			if slotitem ~= BP_GetSlotItemBlueprint("soviet_flag") then
				Squad_GiveSlotItem(squad, slotitem)
			end
		end	
	end
end

function isset(var)
	if var ~= nil then
		return true
	else
		return false
	end
end

function Squad_FlagCarrierDeath(...) --squad, disable_ui, reset_pos
	for key, value in ipairs(arg) do
		CTF_Msg("["..key.."] = "..tostring(value).."\n")
	end
	
	CTF_Msg("arg count: "..table.getn(arg).."\n")
	local disable_ui
	local reset_pos
	local squad = arg[1]
		
	if isset(arg[2]) then
		disable_ui = arg[2]
	end
	
	if isset(arg[3]) then
		reset_pos = arg[3]
		CTF_Msg("!!!!! setting reset pos to "..tostring(reset_pos).."\n")
	end
	
	
	if reset_pos == nil then
		reset_pos = true
		CTF_Msg("????? setting reset pos to "..tostring(reset_pos).."\n")
	end
	if Squad_CarriesFlag(squad) then
		local sid = Squad_GetGameID(squad)
		local flagid = g_flag_carriers["squad_"..sid]
		
		Squad_DisableFlagCarrierUI(squad, true, g_flags[flagid])
		if disable_ui == "disable_ui" then
			Squad_RemoveFlagCarrierEffects(squad, g_flags[flagid])
		end
		CTF_FlagDropped(squad, reset_pos)
		local player = Squad_GetPlayerOwner(squad)
		Player_UnlockRetreat(player)
		local pos = Squad_GetPosition(squad)
		if reset_pos == true then
			g_flags[flagid].current_pos = g_flags[flagid].pos
			g_flags[flagid].reset = true
			CTF_Msg("-----------flag position now reset\n")
		else
			CTF_Msg("-----------flag position now using current squad position\n")
			g_flags[flagid].current_pos = pos
			g_flags[flagid].dropped = pos
		end
		g_flags[flagid].captured = false
		
	end
end

function Squad_DropFlag(squad)
	if Squad_CarriesFlag(squad) then
		local sid = Squad_GetGameID(squad)
		local flagid = g_flag_carriers["squad_"..sid]
		Squad_DisableFlagCarrierUI(squad, true, g_flags[flagid])
		CTF_FlagDropped(squad, false)
		local player = Squad_GetPlayerOwner(squad)
		Player_UnlockRetreat(player)
		local pos = Squad_GetPosition(squad)
		g_flags[flagid].current_pos = pos
		g_flags[flagid].captured = false		
	end	
end

function Squad_CarriesFlag(squad)
	local count = Squad_GetNumSlotItem(squad, slotitem_flag)
	if count > 0 then
		return true
	end
end

function Squad_IsRegisteredFlagCarrier(squad)
	local sid = Squad_GetGameID(squad)
	if g_flag_carriers["squad_"..sid] then
		return true
	end
	return false
end 

function Squad_RegisterFlagCarrier(squad, flagid)
	local sid = Squad_GetGameID(squad)
	g_flag_carriers["squad_"..sid] = flagid
	g_flag_carrier_slot_items["squad_"..sid] = Squad_GetSlotItemTable(squad)
	g_flag_carrying_squads["squad_"..sid] = sid
	for i = 1, 10 do
		local pos = Squad_GetPosition(squad)
		local flag_test = Entity_CreateENV(ebp_flag, pos, pos)
		Entity_Spawn(flag_test)
		if Squad_CanPickupSlotItem(squad, flag_test) then
			CTF_Msg("Gave slot item for squad\n")
			Squad_GiveSlotItem(squad, slotitem_flag)
			Entity_Destroy(flag_test)
		else
			Entity_Destroy(flag_test)
			break
		end
	end
end

function Squad_UnRegisterFlagCarrier(squad)
	local sid = Squad_GetGameID(squad)
	g_flag_carriers["squad_"..sid] = nil
	g_flag_carrying_squads["squad_"..sid] = nil
end

function Squad_GetSlotItemTable(squad)
	local items = {}
	for key, pbg in pairs(SLOT_ITEM) do
		local count = Squad_GetNumSlotItem(squad, pbg)
		if count > 0 then
			for i = 1, count do
				table.insert(items, pbg)
			end
		end
	end
	return items
end

function Team_GetTitle(team)
	local teamName = "[ "
	local players = {}
	Players_ForEach(function(pid, idx, player)
		if Player_GetTeam(player) == team then
			table.insert(players, player)
		end
	end)
	
	for key, player in ipairs(players) do
		local comma = ", "
		if key == table.getn(players) then
			comma = ""
		end
		teamName = teamName.. Player_GetName(player).. comma
	end
	
	return teamName .." ]"
end

function Player_EnableMoveFlagHereUI(player, enable)
	if Player_IsLocalPlayer(player) then
		local pid = Player_GetID(player)
		local holding_flags = Player_IsHoldingAnyFlags(player)
		CTF_Msg("disable UI check\n")
		if not holding_flags then
			HintPoint_RemoveInternal(g_move_flag_here_ui["player_"..pid])
			CTF_Msg("UI disabled\n")
		
		end
		if enable and holding_flags then
			CTF_Msg("UI Added\n")
			local pos = g_flagbases["player_"..pid]
			
			g_move_flag_here_ui["player_"..pid] = HintPoint_Add(pos, true, g_text_move_flag_here, 3, HPAT_Attack, g_flag_icon_squad, 1)
			--g_move_flag_here_ui["player_"..pid] = HintPoint_AddToPosition(pos, 1, true, print, g_text_move_flag_here, true, World_Pos(0, 3, 0), 0, HPAT_Attack, g_flag_icon_squad)
			UI_CreateMinimapBlip(pos, g_minimap_blip_time, BT_General)
		end
	end
end
function Player_GetName(player)
	return Player_GetDisplayName(player)[1]
end
function Player_IsLocalPlayer(player)
	local pid = Player_GetID(player)
	if pid == Game_GetLocalPlayerID() then
		return true
	end
	return false
end
function Player_UnlockRetreat(player)
	if not Player_IsHoldingAnyFlags(player) then
		Player_SetCommandAvailability(player, SCMD_Retreat, ITEM_DEFAULT)
	end
end
function Player_IsHoldingAnyFlags(player)
	SGroup_Clear(sg_flagseek2)
	Player_GetAll(player, sg_flagseek2)
	local flag_found = false
	SGroup_ForEach(sg_flagseek2, function(sgid, idx, squad)
		if Squad_CarriesFlag(squad) then
			flag_found = true
		end
	end)
	return flag_found
end
function Players_ForEach(f)
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		local pid = Player_GetID(player)
		f(pid, i, player)
	end
end
function SGroup_IsCarryingFlag(sgroup)
	local carries_flag = false
	SGroup_ForEach(sgroup, function(sgid, idx, squad)
		if Squad_CarriesFlag(squad) then
			carries_flag = true
		end
	end)
	
	return carries_flag
end

function Game_GetLocalPlayerID()
	return Player_GetID(Game_GetLocalPlayer())
end

function UI_LocalKickerMessage(owner, params)
	if Player_IsLocalPlayer(owner) then
		UI_CreateColouredPositionKickerMessage(owner, unpack(params))
	end
end

function UI_GlobalKickerMessage(owner, params)
	UI_CreateColouredPositionKickerMessage(owner, unpack(params))
end

function CTF_Msg(text)
	if g_debug then
		g_text = text..g_text
		dr_clear("CTF")
		dr_setautoclear("CTF", 0)
		dr_text2d("CTF", 0.615, 0.025, g_text, 0, 255, 0)
		
		if TimeRule_Exists(ClearCTF_Msg) then
			TimeRule_Remove(ClearCTF_Msg)
			--Rule_AddOneShot(ClearCTF_Msg, 10)
		else
			--Rule_AddOneShot(ClearCTF_Msg, 10)
		end
	end
end

function ClearCTF_Msg()
	dr_clear("CTF")
end
function Listener(...)
	local msg = ""
	for key, value in pairs(arg) do
		msg = msg..tostring(key).." = "..scartype(value)..":"..scartype_tostring(value).."\n"
	end
	
	CTF_Msg(msg)	
end

function Table_Shuffle(tab)
	local n, order, res = table.getn(tab), {}, {}

	for i=1,n do order[i] = { rnd = World_GetRand(1, n), idx = i } end
	table.sort(order, function(a,b) return a.rnd < b.rnd end)
	for i=1,n do res[i] = tab[order[i].idx] end
	return res
end

