function Squad_ModifySpeed(squad, addition)
	local found = false
	for key, s in ipairs(g_speed_multiplier) do
		if s.id == Squad_GetGameID(squad) then
			found = true
		end		
	end
	
	if found == false then
		local s_speed = {
			id = Squad_GetGameID(squad),
			scalefactor = 1.0,
			addition = 0,
			modid = {
				inf,
				veh,
			},
		}
		table.insert(g_speed_multiplier, s_speed)
	end
		
	for key, s in ipairs(g_speed_multiplier) do
		if s.id == Squad_GetGameID(squad) then
			s.scalefactor = s.scalefactor + addition
			s.addition = s.addition + addition
			if s.scalefactor < 0.1 then s.scalefactor = 0 end
			if s.addition < 0.1 and s.addition > 0.1 then s.addition = 0 end
			if s.addition > -0.1 and s.addition < -0.1 then s.addition = 0 end
			SGroup_Clear(sg_ccm)
			if s.modid.inf then Modifier_Remove(s.modid.inf) end
			if s.modid.veh then Modifier_Remove(s.modid.veh) end
			local s_entity = Squad_EntityAt(squad, 0)
			
			if Entity_IsOfType(s_entity, "infantry") then
				s.modid.inf = Squad_ModifyInfantrySpeed(squad, s.addition)
				return Squad_GetText(squad).." speed + "..s.addition
			elseif Entity_IsOfType(s_entity, "vehicle") then
				SGroup_Add(sg_ccm, squad)
				s.modid.veh = Modify_UnitSpeed(sg_ccm, s.scalefactor)
				return Squad_GetText(squad).." speed * "..s.scalefactor
			elseif Entity_IsOfType(s_entity, "atgun") then
				SGroup_Add(sg_ccm, squad)
				s.modid.veh = Modify_UnitSpeed(sg_ccm, s.scalefactor)
				return Squad_GetText(squad).." speed * "..s.scalefactor
			else
				return "Unable to modify speed for "..Squad_GetText(squad)
			end		
		end
	end
end

function Squad_ModifyInfantrySpeed(squad, addition)
	local modifier = Modifier_Create(MAT_Squad, "modifiers\\posture_speed_modifier.lua", MUT_Addition, false, addition, "")
	local result = {}
	
	local modid = Modifier_ApplyToSquad(modifier, squad)
	table.insert(result, modid)
	Modifier_AddToSquadTable(squad, modid)	
	return result	
end

function Squad_GetHealthTable(squad)
	local result = {}
	Squad_ForEachEntity(squad, function(squad, idx, entity)
		table.insert(result, Entity_GetHealthPercentage(entity))
	end)
	return result
end

function Squad_ApplyHealthTable(squad, health)
	Squad_ForEachEntity(squad, function(squad, idx, entity)
		local health = health[idx+1]
		if health < 0 or health > 1.0 then
			CCM_EventCue("[EXECPTION] INVALID HEALTH PERCENTAGE "..health)
		else
			Entity_SetHealth(entity, health)
		end
	end)
end

function Squad_GetPlayerOwnerSafe(squad, safe)
	if World_OwnsSquad(squad) then 
		if not safe then
			return nil
		else
			return World_GetPlayerAt(1)
		end
	else
		return Squad_GetPlayerOwner(squad)
	end
end

function Squad_GetHeadingTable(squad)
	local heading = {}
	Squad_ForEachEntity(squad, function(squad, idx, entity)
		table.insert(heading, Entity_GetHeading(entity))
	end)
	return heading
end

function Squad_ApplyHeadingTable(squad, headings)
	Squad_ForEachEntity(squad, function(squad, idx, entity)
		Entity_SetHeading(entity, headings[idx+1], false)
	end)
end

function Squad_GetUpgradesTable(squad)
	local t_upg = {}
	for key, t_upg_table in ipairs({UPG.SOVIET, UPG.GERMAN}) do
		for key, upg in pairs(t_upg_table) do

			if Squad_HasUpgrade(squad, upg) then
				table.insert(t_upg, upg)
			end
		end
	end
	return t_upg
end

function Squad_GetText(squad)
	return BP_GetName(Squad_GetBlueprint(squad)).." - "..Squad_GetGameID(squad).." "
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

function Squad_GetCriticalsTable(squad)
	local crit = {}
	Squad_ForEachEntity(squad, function(squad, idx, entity)
		for key, pbg in pairs(CRIT) do
			if Entity_HasCritical(entity, pbg) then
				table.insert(crit, pbg)
			end
		end
	end)
	return crit	
end

function Squad_ApplyCriticalHitTable(squad, criticals)
	for key, pbg in ipairs(criticals) do
		local player
		if World_OwnsSquad(squad) then
			player = World_GetPlayerAt(1)
		else
			player = Squad_GetPlayerOwner(squad)
		end
		 Command_PlayerSquadCriticalHit(player, Squad_GetTempSGroup(squad), PCMD_CriticalHit, pbg, 0, false)
	end
end

function Squad_ModifyDamage(squad, addition)
	local found = false
	for key, s in ipairs(g_damagemultiplier) do
		if s.id == Squad_GetGameID(squad) then
			found = true
		end		
	end
	
	if found == false then
		local s_damage = {
			id = Squad_GetGameID(squad),
			scalefactor = 1.0,
			modid,
		}
		table.insert(g_damagemultiplier, s_damage)
	end
		
	for key, s in ipairs(g_damagemultiplier) do
		if s.id == Squad_GetGameID(squad) then
			s.scalefactor = s.scalefactor + addition
			if s.scalefactor < 0.1 then s.scalefactor = 0 end
			Misc_ClearGroups()
			if s.modid then Modifier_Remove(s.modid) end
			SGroup_Add(sg_ccm, squad)
			s.modid = Modify_WeaponDamage(sg_ccm, "hardpoint_01", s.scalefactor, "sgroup")
			return Squad_GetText(squad).." damage * "..s.scalefactor
		end
	end	
end

function Squad_ForEachEntity(squad, f)
	for i = 1, Squad_Count(squad) do
		local entity = Squad_EntityAt(squad, i-1)
		f(squad, i-1, entity)
	end
end

function Squad_DropSlotItems(squad)
	Command_Squad(Squad_GetPlayerOwnerSafe(squad, true), Squad_GetTempSGroup(squad), SCMD_SlotItemRemove, false)
end

function Squad_GetTempSGroup(squad)
	local sg_squadtemp = SGroup_CreateIfNotFound("sg_squadtemp")
	SGroup_Clear(sg_squadtemp)
	SGroup_Add(sg_squadtemp, squad)
	return sg_squadtemp
end

function Squad_RemoveUpgrades(squad)
	for key, race in pairs(UPG) do
		for k, ubp in pairs(race) do
			if Squad_HasUpgrade(squad, ubp) then
				Squad_RemoveUpgrade(squad, ubp)
			end
		end
	end	
end

function Squad_RemoveCritical(squad, critical)
	Squad_ForEachEntity(squad, function(squad, idx, entity)
		if Entity_HasCritical(entity, critical) then
			Entity_RemoveCritical(entity, critical)
		end
	end)
end

function Squad_HasCritical(squad, critical)
	local result = false
	Squad_ForEachEntity(squad, function(squad, idx, entity)
		if Entity_HasCritical(entity, critical) then
			result = true
		end
	end)
	
	return result
end

function Squad_GetEntityPositionList(squad)
	local list = {}
	
	Squad_ForEachEntity(squad, function(squad, idx, entity)
		list["entity_"..Entity_GetGameID(entity)] = Entity_GetPosition(entity)
	end)
	
	return list
end

function Squad_ApplyEntityPositionList(squad, list)
	Squad_ForEachEntity(squad, function(squad, idx, entity)
		local key = "entity_"..Entity_GetGameID(entity)
		if list[key] then
			Entity_SetPosition(entity, list[key])
		end
	end)
end

function Squad_SetHealthPercentage(squad, percentage)
	Squad_ForEachEntity(squad, function(squad, idx, entity)
		Entity_SetHealth(entity, percentage)
	end)
end

function Squad_IsVehicle(squad)
	return Entity_IsVehicle(Squad_EntityAt(squad, 0))
end

function Squad_GetUniqueKey(squad)
	return "squad_"..Squad_GetGameID(squad)
end