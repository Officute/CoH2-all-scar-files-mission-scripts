function Entity_AutoAlign(entity)
	Entity_SetHeading(entity, Entity_GetHeading(entity), false)
end

function Entity_CreateAndSpawnToward(ebp, player, pos, toward)
	local entity 
	local spawn_as_netural = false
	if not player then
		player = World_GetPlayerAt(1)
		spawn_as_netural = true
	end
	entity = Entity_Create(ebp, player, pos, toward)
	
	Entity_ForceConstruct(entity)
	Entity_Spawn(entity)
	Entity_AutoAlign(entity)
	if spawn_as_netural then
		Entity_SetWorldOwned(entity)
	end
	return entity
end

function Entity_CreateAndSpawnTowardTeamWeapon(ebp, player, pos, toward)
	local entity = Entity_CreateAndSpawnToward(ebp, player, pos, toward)
	Entity_Abandon(entity)
end

function Entity_GetUpgradeTable(entity)
	local t_upg = {}
	for key, t_upg_table in ipairs({UPG.SOVIET, UPG.GERMAN}) do
		for key, upg in pairs(t_upg_table) do

			if Entity_HasUpgrade(entity, upg) then
				table.insert(t_upg, upg)
			end	
		end	
	end		
	return t_upg
end

function Entity_ApplyCriticalHit(entity, criticals)
	for key, pbg in ipairs(criticals) do
		local player
		if World_OwnsEntity(entity) then
			player = World_GetPlayerAt(1)
		else
			player = Entity_GetPlayerOwner(entity)
		end
		Misc_ClearGroups()
		EGroup_Add(eg_ccm, entity)
		Command_PlayerEntityCriticalHit(player, eg_ccm, PCMD_CriticalHit, pbg, 0, false)
	end
end

function Entity_GetPlayerOwnerSafe(entity, safe)
	if World_OwnsEntity(entity) then 
		if not safe then
			return nil
		else 
			return World_GetPlayerAt(1)
		end
	else
		return Entity_GetPlayerOwner(entity)
	end
end

function Entity_GetText(entity)
	return BP_GetName(Entity_GetBlueprint(entity)).." - "..Entity_GetGameID(entity).." "
end

function Entity_GetTempEGroup(entity)
	local eg_entitytemp = EGroup_CreateIfNotFound("eg_entitytemp")
	EGroup_Clear(eg_entitytemp)
	EGroup_Add(eg_entitytemp, entity)
	return eg_entitytemp
end

function Entity_Abandon(entity)
	local owner = Entity_GetPlayerOwnerSafe(entity, true)
	Command_PlayerEntityCriticalHit(owner, Entity_GetTempEGroup(entity), PCMD_CriticalHit, BP_GetCriticalBlueprint("vehicle_abandon"), 1, false)
end

function EntityBP_IsBuilding(ebp)
	local isbuilding = false
	local player = World_GetPlayerAt(1)
	local entity = Entity_Create(ebp, player, World_Pos(-1024, -1024, -1024), World_Pos(0, 0, 0))
	if Entity_IsOfType(entity, "building") or Entity_IsOfType(entity, "team_weapon") then
		isbuilding = true
	end
	Entity_Destroy(entity)
	return isbuilding
end