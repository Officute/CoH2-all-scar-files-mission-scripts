--loadfile("scar/ccm_toggle.scar")()



function CCM_ToggleInstantProduction(caster, target)
	local settings_key = Player_GetSettingsKey(caster)
	
	local scalefactor = 0
	local scalefactor_construction = 0
	if g_settings[settings_key].instant_production then
		scalefactor_production = 0.001
		scalefactor_construction = 50
		scalefactor_abilityrecharge = 10000
		CCM_EventCue(Player_GetName(caster)..": Instant production, ability recharge, & building construction: Disabled")
	else
		scalefactor_production = 1000	
		scalefactor_construction = 0.02
		scalefactor_abilityrecharge = 0.0001
		CCM_EventCue(Player_GetName(caster)..": Instant production, ability recharge, & building construction: Enabled")
	end
	
	Modify_PlayerProductionRate(caster, scalefactor_production)

	for raceKey, race in pairs(ABILITY) do
		for key, abp in pairs(race) do
			Modify_AbilityRechargeTime(caster, abp, scalefactor_abilityrecharge)	
		end
	end

	for key, entity in ipairs(g_building_ebp) do
		Modify_EntityBuildTime(caster, BP_GetEntityBlueprint(entity.ebp), scalefactor_construction)
	end

	g_settings[settings_key].instant_production = not g_settings[settings_key].instant_production
end

function CCM_ToggleFOW(caster, target)
	if g_global_settings.fow_enabled then
		FOW_Enable(false)
		CCM_EventCue(Player_GetName(caster)..": Fow of War: Disabled")
	else
		FOW_Enable(true)
		CCM_EventCue(Player_GetName(caster)..": Fow of War: Enabled")
	end
	
	g_global_settings.fow_enabled = not g_global_settings.fow_enabled
end

function CCM_ToggleGlobalAI(caster, target)
	if g_global_settings.global_ai_enabled then
		AI_EnableAll(false)
		CCM_EventCue(Player_GetName(caster)..": Global AI: Disabled")
	else
		AI_EnableAll(true)
		CCM_EventCue(Player_GetName(caster)..": Global AI: Enabled")
	end
	
	g_global_settings.global_ai_enabled = not g_global_settings.global_ai_enabled
end

function CCM_ToggleSelectionInvulnerability(caster, target)
	target = Misc_CheckForParentSquad(target)
	if scartype(target) == ST_ENTITY or scartype(target) == ST_SQUAD then
		local key = Util_GetTablekey(target)
		
		if not g_invulnerability_state[key] then
			Util_SetInvulnerable(target, true)
			CCM_EventCue(Player_GetName(caster)..": Squad "..Util_GetBPName(target).." Invulnerability: ON")
		else
			Util_SetInvulnerable(target, false)
			CCM_EventCue(Player_GetName(caster)..": Squad "..Util_GetBPName(target).." Invulnerability: OFF")
		end
		
		g_invulnerability_state[key] = not g_invulnerability_state[key]
	end
end

function CCM_ToggleSelectionOwner(caster, target)
	target = Misc_CheckForParentSquad(target)
	if scartype(target) == ST_SQUAD then
		local squad = target
		local owner_idx
		local toggled = false
		for key, p in ipairs(g_players) do
			if Player_GetIDSafe(p) == Player_GetIDSafe(Squad_GetPlayerOwnerSafe(squad)) and not toggled then
				toggled = true
				owner_idx = key + 1
				if owner_idx > table.getn(g_players) then
					owner_idx = 1
				end
				local o_owner = Player_GetName(Squad_GetPlayerOwnerSafe(squad))
				local n_owner = Player_GetName(g_players[owner_idx])
				CCM_EventCue(Player_GetName(caster)..": Squad "..Util_GetBPName(squad).." owner changed: ["..o_owner.."] -> ["..n_owner.."]")
				if g_players[owner_idx] == "world" then
					Squad_SetWorldOwned(squad)
				else
					Squad_SetPlayerOwner(squad, g_players[owner_idx])
				end
			end
		end				
	elseif scartype(target) == ST_ENTITY then
		local entity = target
		local owner_idx
		local toggled = false
		for key, p in ipairs(g_players) do
			if Player_GetIDSafe(p) == Player_GetIDSafe(Entity_GetPlayerOwnerSafe(entity)) and not toggled then
				toggled = true
				owner_idx = key + 1
				if owner_idx > table.getn(g_players) then
					owner_idx = 1
				end
				local o_owner = Player_GetName(Entity_GetPlayerOwnerSafe(entity))
				local n_owner = Player_GetName(g_players[owner_idx])
				CCM_EventCue(Player_GetName(caster)..": Entity "..Util_GetBPName(entity).." owner changed: ["..o_owner.."] -> ["..n_owner.."]")
				if g_players[owner_idx] == "world" then
					if Entity_IsOfType(entity, "strategic_node") then
						Entity_SetStrategicPointNeutral(entity)
					else
						Entity_SetWorldOwned(entity)
					end
				else
					if Entity_IsOfType(entity, "strategic_node") then
						Entity_InstantCaptureStrategicPoint(entity, g_players[owner_idx])
					else
						Entity_SetPlayerOwner(entity, g_players[owner_idx])
					end
				end
			end
		end	
	end
end

function CCM_ToggleDisableWeapons(caster, target)
	target = Misc_CheckForParentSquad(target)
	local critical_bp = BP_GetCriticalBlueprint("critical/vehicle_destroy_maingun.lua")
	if scartype(target) == ST_SQUAD then
		local squad = target
		if Squad_HasCritical(squad, critical_bp) then
			Squad_RemoveCritical(squad, critical_bp)
			CCM_EventCue(Player_GetName(caster)..": Main gun/weapons Enabled for squad "..Util_GetBPName(target))
		else
			Squad_ApplyCriticalHitTable(squad, {critical_bp})
			CCM_EventCue(Player_GetName(caster)..": Main gun/weapons Disabled for squad "..Util_GetBPName(target))
		end
	elseif scartype(target) == ST_ENTITY then
		local entity = target
		if Entity_HasCritical(entity, critical_bp) then
			Entity_RemoveCritical(entity, critical_bp)
			CCM_EventCue(Player_GetName(caster)..": Main gun/weapons Enabled for entity "..Util_GetBPName(target))
		else
			Entity_ApplyCritical(entity, BP_GetCriticalBlueprint("critical/vehicle_destroy_maingun.lua"), 1)
			CCM_EventCue(Player_GetName(caster)..": Main gun/weapons Disabled for entity "..Util_GetBPName(target))
		end	
	end
end

function CCM_ToggleEngineOrPostureState(caster, target)
	local engine_damage_crit = {
		[0] = "none",
		BP_GetCriticalBlueprint("vehicle_light_damage_engine"),
		BP_GetCriticalBlueprint("vehicle_damage_engine"),
		BP_GetCriticalBlueprint("vehicle_destroy_engine"),
		BP_GetCriticalBlueprint("vehicle_lose_treads_or_wheels"),
	}
	
	target = Misc_CheckForParentSquad(target)
	local critical_bp = BP_GetCriticalBlueprint("critical/vehicle_destroy_maingun.lua")
	if scartype(target) == ST_SQUAD then
		local squad = target
		if Squad_IsVehicle(squad) then
			
			local squad_key = "squad_"..Squad_GetGameID(squad)
			
			if g_engine_crit_state[squad_key] then
				g_engine_crit_state[squad_key] = g_engine_crit_state[squad_key] + 1
				if g_engine_crit_state[squad_key] > table.getn(engine_damage_crit) then
					g_engine_crit_state[squad_key] = 0
				end
			else
				g_engine_crit_state[squad_key] = 1
				
			end
			local crit_key = g_engine_crit_state[squad_key] 
			
			if engine_damage_crit[crit_key] == "none" then
				for key, crit in ipairs(engine_damage_crit) do
					Squad_RemoveCritical(squad, crit)
				end
				g_engine_crit_state[squad_key] = 1
				CCM_EventCue(Player_GetName(caster)..": Vehicle engine status: Normal for squad "..Util_GetBPName(target))
			else
				local crit_hit = engine_damage_crit[crit_key]
				Squad_ApplyCriticalHitTable(squad, {crit_hit})
				CCM_EventCue(Player_GetName(caster)..": Vehicle engine status: "..BP_GetName(crit_hit).." for squad "..Util_GetBPName(target))
			end
		else 
			local count_e = 0
			local count_s = 0
			local _getPostureTitle = function(posture)
				if posture == 0 then
					return "Prone"
				elseif posture == 1 then
					return "Kneel"
				elseif posture == 2 then
					return "Stand"
				elseif posture == 3 then
					return "Auto"
				end
			end
			
			local name = BP_GetName(Squad_GetBlueprint(squad))
			local id = Squad_GetGameID(squad)
			if not g_posture_state["squad_"..id] then
				g_posture_state["squad_"..id] = 0
			end
			local currentState = g_posture_state["squad_"..id]
			if currentState + 1 > 3 then
				currentState = 0
			else
				currentState = currentState + 1
			end
			g_posture_state["squad_"..id] = currentState
			if currentState < 3 then
				Squad_SuggestPosture(squad, currentState, -1)
			else
				Squad_ClearPostureSuggestion(squad)
			end
			CCM_EventCue(Player_GetName(caster)..": Squad posture state set to: ".._getPostureTitle(currentState).." for squad"..Util_GetBPName(target))
		end
	end
end

function CCM_ToggleHealthMonitor(caster, target)
	
	local playerKey = Player_GetSettingsKey(caster)
	g_settings[playerKey].health_monitor_enabled = not g_settings[playerKey].health_monitor_enabled
	CCM_Msg("Toggled health monitor, to " .. tostring(g_settings[playerKey].health_monitor_enabled))
end

function CCM_GetSquadKey(squad)
	return "squad_" .. Squad_GetGameID(squad)
end

function CCM_GetEntityKey(entity)
	return "entity_" .. Entity_GetGameID(entity)
end

function CCM_HealthMonitor()
	Players_ForEach(function(pid, idx, player)
		local sg_ccm_holder = SGroup_CreateIfNotFound("sg_ccm_holder")
		local eg_ccm_holder = EGroup_CreateIfNotFound("eg_ccm_holder")
		SGroup_Clear(sg_ccm_holder)
		EGroup_Clear(eg_ccm_holder)
		
		Player_GetAll(player, sg_ccm_holder, eg_ccm_holder)
		
		SGroup_ForEach(sg_ccm_holder, function(sgid, idx, squad)
			local squadKey = CCM_GetSquadKey(squad)
			if not g_health_monitor[squadKey] then
				g_health_monitor[squadKey] = {squadId = Squad_GetGameID(squad), health = Squad_GetHealth(squad)}
			end
		end)
		EGroup_ForEach(eg_ccm_holder, function(egid, idx, entity)
			local entityKey = CCM_GetEntityKey(entity)
			if not g_health_monitor[entityKey] then
				g_health_monitor[entityKey] = {entityId = Entity_GetGameID(entity), health = Entity_GetHealth(entity)}
			end
		end)
		
		for key, unit in pairs(g_health_monitor) do
			if unit.squadId then
				if Squad_IsValid(unit.squadId) then
					local squad = Squad_FromWorldID(unit.squadId)
					local currentHealth = Squad_GetHealth(squad)
					_CCM_HealthMonitor_HandleHealth(currentHealth, unit, Squad_GetPosition(squad))
					unit.health = currentHealth
				else
					g_health_monitor[key] = nil
				end
				
			elseif unit.entityId then
				if Entity_IsValid(unit.entityId) then
					local entity = Entity_FromWorldID(unit.entityId)
					local currentHealth = Entity_GetHealth(entity)
					_CCM_HealthMonitor_HandleHealth(currentHealth, unit, Entity_GetPosition(entity))
					unit.health = currentHealth
				else
					g_health_monitor[key] = nil
				end
			end
		end
	end)
end

function _CCM_HealthMonitor_HandleHealth(currentHealth, unit, pos)					
	if currentHealth > unit.health then
		local difference = currentHealth - unit.health
		_CCM_HealthMonitor_KickerMessage(pos, Util_CreateLocString("+ " .. difference), Colors.addedHealth)
	elseif currentHealth < unit.health then
		local difference = unit.health - currentHealth
		_CCM_HealthMonitor_KickerMessage(pos, Util_CreateLocString("- " .. difference), Colors.removedHealth)
	end
end

function _CCM_HealthMonitor_KickerMessage(pos, text, color)
	Players_ForEach(function(pid, idx, player)
		local playerKey = Player_GetSettingsKey(player)
		if g_settings[playerKey].health_monitor_enabled and Player_IsLocalPlayer(player) then
			UI_CreateColouredPositionKickerMessage(player, pos, text, color())
		end
	end)
end


