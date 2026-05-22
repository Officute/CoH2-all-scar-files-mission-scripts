--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- MODIFIER FUNCTIONS
-- Provides a simple interface to add and remove specific modifiers from groups and players.
--
-- (c) 2005 Relic Entertainment
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


-- create the blank modifier storage table at the start of a mission
function Modifier_Init()
	_ModifiersSquadTable = {}
	_ModifiersEntityTable = {}
	_ModifiersReverseTable = {}
end
Scar_AddInit(Modifier_Init)




-- ALL Modify_* functions should call these function so that all SCAR-applied modifiers get indexed  <---- IMPORTANT!

-- this function adds a modifier id to the global modifier storage table
function Modifier_AddToSquadTable(squad, modid)

	-- each squad has it's own list in the table, indexed by it's unique game id
	local sid = Squad_GetGameID(squad)
	if _ModifiersSquadTable[sid] == nil then
		_ModifiersSquadTable[sid] = {}
	end
	table.insert(_ModifiersSquadTable[sid], modid)
	
	-- each modifier has a reverse lookup table, showing which squad/entity it was applied to
	_ModifiersReverseTable[modid] = {squad = sid}
	
end

-- this function adds a modifier id to the global modifier storage table
function Modifier_AddToEntityTable(entity, modid)

	-- each entity has it's own list in the table, indexed by it's unique game id
	local eid = Entity_GetGameID(entity)
	if _ModifiersEntityTable[eid] == nil then
		_ModifiersEntityTable[eid] = {}
	end
	table.insert(_ModifiersEntityTable[eid], modid)
	
	-- each modifier has a reverse lookup table, showing which squad/entity it was applied to
	_ModifiersReverseTable[modid] = {entity = eid}
	
end


-- this function adds a modifier id to the global modifier storage table
function Modifier_AddToMiscTable(modid)

	-- each modifier has a reverse lookup table, showing which squad/entity it was applied to
	_ModifiersReverseTable[modid] = {misc = true}
	
end

-- Weapon Modifier consts
WM_RANGE = "modifiers\\range_weapon_modifier.lua"
WM_PENETRATION = "modifiers\\weapon_penetration_modifier.lua"
WM_ACCURACY = "modifiers\\accuracy_weapon_modifier.lua"
WM_COOLDOWN = "modifiers\\cooldown_weapon_modifier.lua"
WM_RELOAD = "modifiers\\reload_weapon_modifier.lua"
WM_BURST = "modifiers\\burst_weapon_modifier.lua"
WM_DAMAGE = "modifiers\\damage_weapon_modifier.lua"













--? @group scardoc;Modifiers

--? @shortdesc Remove an applied modifier. 
--? @result Void
--? @args ModID modifier
function Modifier_Remove(modifier)

	-- if it's just one modID, put it in a table
	if (type(modifier) ~= "table") then
		modifier = {modifier}
	end
	
	-- remove each modID in turn
	for n = table.getn(modifier), 1, -1 do
		
		-- find what it was applied to and remove reference to it
		local modid = modifier[n]
		local entry = _ModifiersReverseTable[modid]
		
		if entry ~= nil then
			
			-- if it was applied to a squad, find out which one and amend that squad's records
			if entry.squad ~= nil then
				
				local squadlist = _ModifiersSquadTable[entry.squad]
				if squadlist ~= nil then
					for i = table.getn(squadlist), 1, -1 do
						if squadlist[i] == modid then
							table.remove(squadlist, i)
						end
					end
					if table.getn(squadlist) == 0 then
						_ModifiersSquadTable[entry.squad] = nil
					end
				end
			end
			
			-- if it was applied to an entity, find out which one and amend that entitiy's records
			if entry.entity ~= nil then
				local entitylist = _ModifiersEntityTable[entry.entity]
				if entitylist ~= nil then
					for i = table.getn(entitylist), 1, -1 do
						if entitylist[i] == modid then
							table.remove(entitylist, i)
						end
						if table.getn(entitylist) == 0 then
							_ModifiersEntityTable[entry.entity] = nil
						end
					end
				end
			end
			
			table.remove(_ModifiersReverseTable, modid)
			
		end
		
		Modifier_RemoveInternal(modid)
		
	end
	
	for n = table.getn(modifier), 1, -1 do
		table.remove(modifier, n)
	end
	
end



--? @shortdesc Removes all SCAR-applied modifiers for a specific SGroup. 
--? @result Void
--? @args SGroupID sgroup
function Modifier_RemoveAllFromSGroup(sgroup)
	
	local _RemoveFromSquad = function(gid, idx, sid)
		local id = Squad_GetGameID(sid)
		if _ModifiersSquadTable[id] ~= nil then
			Modifier_Remove(_ModifiersSquadTable[id])
			_ModifiersSquadTable[id] = nil
		end
	end
	
	SGroup_ForEach(sgroup, _RemoveFromSquad)

end





--? @shortdesc Removes all SCAR-applied modifiers for a specific EGroup. 
--? @result Void
--? @args EGroupID egroup
function Modifier_RemoveAllFromEGroup(egroup)
	
	local _RemoveFromEntity = function(gid, idx, eid)
		local id = Entity_GetGameID(eid)
		if _ModifiersEntityTable[id] ~= nil then
			Modifier_Remove(_ModifiersEntityTable[id])
			_ModifiersEntityTable[id] = nil
		end
	end
	
	EGroup_ForEach(egroup, _RemoveFromEntity)

end


--? @shortdesc Checks if a modifier is enabled on all or any entities in an egroup
--? @result Void
--? @args EGroupID egroup, String modifier, String modtype, Boolean all, Boolean bEnabledByDefault
function Modifier_IsEnabledOnEGroup(egroup, modtype, all, bEnabledByDefault)

	return EGroup_CallEntityFunctionAllOrAny(egroup, all, Modifier_IsEnabled, modtype, bEnabledByDefault)

end



--? @shortdesc Modifies the time taken to build a particular EBP. This only affects the given player. 
--? @result ModID
--? @args PlayerID playerId, String ebp, Real scalefactor
function Modify_EntityBuildTime(playerid, ebp, scalefactor)

	local modifier = Modifier_Create(MAT_EntityType, "modifiers\\cost_ticks_modifier.lua", MUT_Multiplication, false, scalefactor, ebp)

	return {Modifier_ApplyToPlayer(modifier, playerid)}
	
end



--? @shortdesc Modifies the build time for a particular upgrade. This only affects the given player. 
--? @result ModID
--? @args PlayerID playerId, UpgradeID upgrade, Real scalefactor
function Modify_UpgradeBuildTime(playerid, upgrade, scalefactor)
	
	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Upgrade, "modifiers\\upgrade_production_speed_modifier.lua", MUT_Multiplication, false, scalefactor, upgrade)

	return {Modifier_ApplyToPlayer(modifier, playerid)}
	
end


--? @shortdesc Modifies the build time for a particular upgrade. This only affects the given player. 
--? @result ModID
--? @args Entity entity, Real scalefactor
function Modify_ProductionSpeed(target, scalefactor)

	-- create the appropriate modifier
	local modifier = 0
	local result = {}
	
	if (scartype(target) == ST_ENTITY) then
		modifier = Modifier_Create(MAT_Entity, "modifiers\\production_speed_modifier.lua", MUT_Multiplication, false, scalefactor, "")
	end
	
	local modid = Modifier_ApplyToEntity(modifier, target)
	table.insert(result, modid)
	Modifier_AddToEntityTable(target, modid)
	
	return result
	
end



--? @shortdesc Modifies the upkeep for a player 
--? @result ModID
--? @args PlayerID playerId, Real scalefactor
function Modify_Upkeep(playerid, scalefactor)
	
	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Player, "modifiers\\income_upkeep_manpower_player_modifier.lua", MUT_Multiplication, false, scalefactor, "")

	return {Modifier_ApplyToPlayer(modifier, playerid)}
	
end


function Modify_SlotItemDropRate(playerid, weapon, scalefactor)
	
	if scartype(weapon) ~= ST_STRING then
		fatal("ERROR: Weapon param is not a valid string")
	end
	
	local weaponID = BP_GetWeaponBlueprint(weapon)
	
	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_WeaponType, "modifiers\\weapon_slot_item_drop_rate.lua", MUT_Multiplication, false, scalefactor, weaponID)

	return {Modifier_ApplyToPlayer(modifier, playerid)}
	
end



--? @shortdesc Sets the cost of an upgrade. This only affects the given player
--? @result ModID
--? @args PlayerID playerId, UpgradeID upgrade, Integer resourceType, Real newCost
function Modify_SetUpgradeCost(playerid, upgrade, resource, newCost)

	local modifiertype
	if (resource == RT_Manpower) then
		modifiertype = "modifiers\\upgrade_cost_manpower_modifier.lua"
	elseif (resource == RT_Munition) then
		modifiertype =  "modifiers\\upgrade_cost_munition_modifier.lua"
	elseif (resource == RT_Fuel) then
		modifiertype =  "modifiers\\upgrade_cost_fuel_modifier.lua"
	elseif (resource == RT_Action) then
		modifiertype =  "modifiers\\upgrade_cost_action_modifier.lua"
	elseif (resource == RT_Command) then
		modifiertype =  "modifiers\\upgrade_cost_command_modifier.lua"
	end
	
	local currentCost = Player_GetUpgradeCost(playerid, upgrade, resource)
	local modifier = Modifier_Create(MAT_Upgrade, modifiertype, MUT_Addition, true, newCost - currentCost, upgrade)
	
	return {Modifier_ApplyToPlayer(modifier, playerid)}
end


--? @shortdesc Modifies a player's incoming resource rate. Possible resource types are RT_Manpower, RT_Munition, RT_Fuel, RT_Action. Possible math types are MUT_Multiplication, MUT_Addition.
--? @result ModID
--? @args PlayerID playerId, Integer resourceType, Real scalefactor[, Integer mathtype] 
function Modify_PlayerResourceRate(playerid, resource, scalefactor, mathtype)

	local modifiertype = ""

	if mathtype == nil then
		mathtype = MUT_Multiplication
	end
	
	if (resource == RT_Manpower) then
		modifiertype = "modifiers\\income_manpower_player_modifier.lua"
	elseif (resource == RT_Munition) then
		modifiertype =  "modifiers\\income_munition_player_modifier.lua"
	elseif (resource == RT_Fuel) then
		modifiertype =  "modifiers\\income_fuel_player_modifier.lua"
	elseif (resource == RT_Action) then
		modifiertype =  "modifiers\\income_combat_player_modifier.lua"
	end
	
	local modifier = Modifier_Create(MAT_Player, modifiertype, mathtype, false, scalefactor, "")

	return {Modifier_ApplyToPlayer(modifier, playerid)}
	
end




--? @shortdesc Modifies a player's resource bonus received (ie. one-time resource gifts) Possible resource types are RT_Manpower, RT_Munition, RT_Fuel, RT_Action 
--? @result ModID
--? @args PlayerID playerId, Integer resourceType, Real scalefactor
function Modify_PlayerResourceGift(playerid, resource, scalefactor)

	local modifiertype = ""
	
	if (resource == RT_Manpower) then
		modifiertype = "modifiers\\gift_manpower_player_modifier.lua"
	elseif (resource == RT_Munition) then
		modifiertype =  "modifiers\\gift_munition_player_modifier.lua"
	elseif (resource == RT_Fuel) then
		modifiertype =  "modifiers\\gift_fuel_player_modifier.lua"
	elseif (resource == RT_Action) then
		modifiertype =  "modifiers\\gift_combat_player_modifier.lua"
	end
	
	local modifier = Modifier_Create(MAT_Player, modifiertype, MUT_Multiplication, false, scalefactor, "")

	return {Modifier_ApplyToPlayer(modifier, playerid)}
	
end


--? @shortdesc Modifies a player's resource cap. Possible resource types are RT_Manpower, RT_Munition, RT_Fuel. Possible math types are MUT_Multiplication, MUT_Addition.
--? @result ModID
--? @args PlayerID playerId, Integer resourceType, Real scalefactor[, Integer mathtype] 
function Modify_PlayerResourceCap(playerid, resource, scalefactor, mathtype)

	local modifiertype = ""

	if mathtype == nil then
		mathtype = MUT_Multiplication
	end
	
	if (resource == RT_Manpower) then
		modifiertype = "modifiers\\player_cap_manpower_modifier.lua"
	elseif (resource == RT_Munition) then
		modifiertype =  "modifiers\\player_cap_munition_modifier.lua"
	elseif (resource == RT_Fuel) then
		modifiertype =  "modifiers\\player_cap_fuel_modifier.lua"
	elseif (resource == RT_SovietProgression) then
		modifiertype =  "modifiers\\player_cap_sovietprogression_modifier.lua"
	end
	
	local modifier = Modifier_Create(MAT_Player, modifiertype, mathtype, false, scalefactor, "")

	return {Modifier_ApplyToPlayer(modifier, playerid)}
	
end


--? @shortdesc Allows paratroopers to reinforce from the sky.  Set to true to enable, false to disable.
--? @args PlayerID playerId, Boolean enable
function Modify_Enable_ParadropReinforcements(playerid, value)
	
	if value == true then
		value = 1
	elseif value == false then
		value = 0
	end
	
	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Player, "modifiers\\paradrop_reinforcements_modifier.lua", MUT_Enable, false, value, upgrade)
	Modifier_ApplyToPlayer( modifier, playerid )
	
end


--? @shortdesc Modifies a sync weapon only. 
--? @extdesc The hardpoint defaults to "hardpoint_01"
--? @result ModID
--? @args SGroupID/EGroupID group, String modifier, Real scalefactor, [String hardpoint]
function Modify_TeamWeapon(groupid, modifier, factor, hardpoint)
	
	if hardpoint == nil then hardpoint = "hardpoint_01" end
	
	-- Locate the Team Weapon Entity
	local eid = nil
	local _findTeamWeapon = function(gid, idx, sid)
		local squadCount = Squad_Count(sid)
		for i = 1, squadCount do
			if Entity_IsSyncWeapon(Squad_EntityAt(sid, i-1)) then
				eid = Squad_EntityAt(sid, i-1)
				return
			end
		end
	end
	
	SGroup_ForEach(groupid, _findTeamWeapon)
	
	-- Found the team weapon, apply the modifier
	local modifier = Modifier_Create(MAT_Weapon, modifier, MUT_Multiplication, false, factor, hardpoint)
	local result = {}
	
	if Entity_IsValid(Entity_GetGameID(eid)) then
		local modid = Modifier_ApplyToEntity(modifier, eid)
		table.insert(result, modid)
		Modifier_AddToEntityTable(eid, modid)
	end
	
	return result
	
end


--? @shortdesc Enables or disables a weapon hardpoint
--? @extdesc The hardpoint should be specified as a string - i.e. "hardpoint_01"
--? @result ModID
--? @args SGroupID/EGroupID group, String hardpoint, Boolean enabled
function Modify_WeaponEnabled(groupid, hardpoint, enabled)

	-- Create the appropriate modifier
	local factor = -1.0
	if ( enabled == true ) then
		factor = 1.0
	end
	
	local modifier = Modifier_Create(MAT_Weapon, "modifiers\\enable_weapon_modifier.lua", MUT_Enable, false, factor, hardpoint)
	local result = {}
	
	local _ApplyModifierToSquad = function(gid, idx, sid)
		if Squad_IsValid(Squad_GetGameID(sid)) and Squad_Count(sid) > 0 and Squad_HasWeaponHardpoint(sid, hardpoint) then
      -- For Weapon Modifiers with specified hardpoint, the modifier is added to each Squad Entity.  This matches the logic on the code side.
      local squadCount = Squad_Count(sid)
      local eid = nil
      for i = 1, squadCount do
        eid = Squad_EntityAt(sid, i-1)
        if (Entity_IsSpawned(eid)) and (Entity_IsAlive(eid)) then
          local modid = Modifier_ApplyToEntity(modifier, eid)
          table.insert(result, modid)
          Modifier_AddToEntityTable(eid, modid)      
        end
      end
		end
	end
	local _ApplyModifierToEntity = function(gid, idx, eid)
		if Entity_IsValid(Entity_GetGameID(eid)) then
			local modid = Modifier_ApplyToEntity(modifier, eid)
			table.insert(result, modid)
			Modifier_AddToEntityTable(eid, modid)
		end
	end
	
	if (scartype(groupid) == ST_SGROUP) then
		-- apply this to each squad in the group
		SGroup_ForEachEx(groupid, _ApplyModifierToSquad, true, true)
	elseif (scartype(groupid) == ST_EGROUP) then
		-- apply this to each entity in the group
		EGroup_ForEach(groupid, _ApplyModifierToEntity)
	end

	return result
	
end



--? @shortdesc Modifies a squad's weapon range. Does not work on artillery (mortar, nebelwerfer, etc.)
--? @extdesc The hardpoint should be specified as a string - i.e. "hardpoint_01"
--? @result ModID
--? @args SGroupID/EGroupID group, String hardpoint, Real scalefactor
function Modify_WeaponRange(groupid, hardpoint, factor)

	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Weapon, "modifiers\\range_weapon_modifier.lua", MUT_Multiplication, false, factor, hardpoint)
	local result = {}
	
	local _ApplyModifierToSquad = function(gid, idx, sid)
		if Squad_IsValid(Squad_GetGameID(sid)) and Squad_Count(sid) > 0 and Squad_HasWeaponHardpoint(sid, hardpoint)then
      -- For Weapon Modifiers with specified hardpoint, the modifier is added to each Squad Entity.  This matches the logic on the code side.
      local squadCount = Squad_Count(sid)
      local eid = nil
      for i = 1, squadCount do
        eid = Squad_EntityAt(sid, i-1)
        if (Entity_IsSpawned(eid)) and (Entity_IsAlive(eid)) then
          local modid = Modifier_ApplyToEntity(modifier, eid)
          table.insert(result, modid)
          Modifier_AddToEntityTable(eid, modid)      
        end
      end
		end
	end
	local _ApplyModifierToEntity = function(gid, idx, eid)
		if Entity_IsValid(Entity_GetGameID(eid)) then
			local modid = Modifier_ApplyToEntity(modifier, eid)
			table.insert(result, modid)
			Modifier_AddToEntityTable(eid, modid)
		end
	end
	
	if (scartype(groupid) == ST_SGROUP) then
		-- apply this to each squad in the group
		SGroup_ForEachEx(groupid, _ApplyModifierToSquad, true, true)
	elseif (scartype(groupid) == ST_EGROUP) then
		-- apply this to each entity in the group
		EGroup_ForEach(groupid, _ApplyModifierToEntity)
	end

	return result
	
end


--? @shortdesc Modifies a squad's weapon penetration. Does not work on artillery (mortar, nebelwerfer, etc.)
--? @extdesc The hardpoint should be specified as a string - i.e. "hardpoint_01"
--? @result ModID
--? @args SGroupID/EGroupID group, String hardpoint, Real scalefactor
function Modify_WeaponPenetration(groupid, hardpoint, factor)

	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Weapon, "modifiers\\weapon_penetration_modifier.lua", MUT_Multiplication, false, factor, hardpoint)
	local result = {}
	
	local _ApplyModifierToSquad = function(gid, idx, sid)
		if Squad_IsValid(Squad_GetGameID(sid)) and Squad_Count(sid) > 0 and Squad_HasWeaponHardpoint(sid, hardpoint)then
      -- For Weapon Modifiers with specified hardpoint, the modifier is added to each Squad Entity.  This matches the logic on the code side.
      local squadCount = Squad_Count(sid)
      local eid = nil
      for i = 1, squadCount do
        eid = Squad_EntityAt(sid, i-1)
        if (Entity_IsSpawned(eid)) and (Entity_IsAlive(eid)) then
          local modid = Modifier_ApplyToEntity(modifier, eid)
          table.insert(result, modid)
          Modifier_AddToEntityTable(eid, modid)      
        end
      end
		end
	end
	local _ApplyModifierToEntity = function(gid, idx, eid)
		local modid = Modifier_ApplyToEntity(modifier, eid)
		table.insert(result, modid)
		Modifier_AddToEntityTable(eid, modid)
	end
	
	if (scartype(groupid) == ST_SGROUP) then
		-- apply this to each squad in the group
		SGroup_ForEachEx(groupid, _ApplyModifierToSquad, true, true)
	elseif (scartype(groupid) == ST_EGROUP) then
		-- apply this to each entity in the group
		EGroup_ForEach(groupid, _ApplyModifierToEntity)
	end

	return result
	
end


--? @shortdesc Modifies a squad's weapon suppression. Does not work on artillery (mortar, nebelwerfer, etc.)
--? @extdesc The hardpoint should be specified as a string - i.e. "hardpoint_01"
--? @result ModID
--? @args SGroupID/EGroupID group, String hardpoint, Real scalefactor
function Modify_WeaponSuppression(groupid, hardpoint, factor)

	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Weapon, "modifiers\\weapon_suppression_modifier.lua", MUT_Multiplication, false, factor, hardpoint)
	local result = {}
	
	local _ApplyModifierToSquad = function(gid, idx, sid)
		if Squad_IsValid(Squad_GetGameID(sid)) and Squad_Count(sid) > 0 and Squad_HasWeaponHardpoint(sid, hardpoint) then
      -- For Weapon Modifiers with specified hardpoint, the modifier is added to each Squad Entity.  This matches the logic on the code side.
      local squadCount = Squad_Count(sid)
      local eid = nil
      for i = 1, squadCount do
        eid = Squad_EntityAt(sid, i-1)
        if (Entity_IsSpawned(eid)) and (Entity_IsAlive(eid)) then
          local modid = Modifier_ApplyToEntity(modifier, eid)
          table.insert(result, modid)
          Modifier_AddToEntityTable(eid, modid)      
        end
      end
		end
	end
	local _ApplyModifierToEntity = function(gid, idx, eid)
		local modid = Modifier_ApplyToEntity(modifier, eid)
		table.insert(result, modid)
		Modifier_AddToEntityTable(eid, modid)
	end
	
	if (scartype(groupid) == ST_SGROUP) then
		-- apply this to each squad in the group
		SGroup_ForEachEx(groupid, _ApplyModifierToSquad, true, true)
	elseif (scartype(groupid) == ST_EGROUP) then
		-- apply this to each entity in the group
		EGroup_ForEach(groupid, _ApplyModifierToEntity)
	end

	return result
	
end



--? @shortdesc Modifies a squad's weapon accuracy.
--? @extdesc The hardpoint should be specified as a string - i.e. "hardpoint_01"
--? @result ModID
--? @args SGroupID/EGroupID group, String hardpoint, Real scalefactor
function Modify_WeaponAccuracy(groupid, hardpoint, factor)

	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Weapon, "modifiers\\accuracy_weapon_modifier.lua", MUT_Multiplication, false, factor, hardpoint)
	local result = {}
	
	local _ApplyModifierToSquad = function(gid, idx, sid)
		if Squad_IsValid(Squad_GetGameID(sid)) and Squad_Count(sid) > 0 and Squad_HasWeaponHardpoint(sid, hardpoint) then
      -- For Weapon Modifiers with specified hardpoint, the modifier is added to each Squad Entity.  This matches the logic on the code side.
      local squadCount = Squad_Count(sid)
      local eid = nil
      for i = 1, squadCount do
        eid = Squad_EntityAt(sid, i-1)
        if (Entity_IsSpawned(eid)) and (Entity_IsAlive(eid)) then
          local modid = Modifier_ApplyToEntity(modifier, eid)
          table.insert(result, modid)
          Modifier_AddToEntityTable(eid, modid)      
        end
      end
		end
	end
	local _ApplyModifierToEntity = function(gid, idx, eid)
		local modid = Modifier_ApplyToEntity(modifier, eid)
		table.insert(result, modid)
		Modifier_AddToEntityTable(eid, modid)
	end
	
	if (scartype(groupid) == ST_SGROUP) then
		-- apply this to each squad in the group
		SGroup_ForEachEx(groupid, _ApplyModifierToSquad, true, true)
	elseif (scartype(groupid) == ST_EGROUP) then
		-- apply this to each entity in the group
		EGroup_ForEach(groupid, _ApplyModifierToEntity)
	end

	return result
	
end



--? @shortdesc Modifies a squad's weapon cooldown time.
--? @extdesc The hardpoint should be specified as a string - i.e. "hardpoint_01"
--? @result ModID
--? @args SGroupID/EGroupID group, String hardpoint, Real scalefactor
function Modify_WeaponCooldown(groupid, hardpoint, factor)

	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Weapon, "modifiers\\cooldown_weapon_modifier.lua", MUT_Multiplication, false, factor, hardpoint)
	local result = {}
	
	local _ApplyModifierToSquad = function(gid, idx, sid)
		if Squad_IsValid(Squad_GetGameID(sid)) and Squad_Count(sid) > 0 and Squad_HasWeaponHardpoint(sid, hardpoint) then
      -- For Weapon Modifiers with specified hardpoint, the modifier is added to each Squad Entity.  This matches the logic on the code side.
      local squadCount = Squad_Count(sid)
      local eid = nil
      for i = 1, squadCount do
        eid = Squad_EntityAt(sid, i-1)
        if (Entity_IsSpawned(eid)) and (Entity_IsAlive(eid)) then
          local modid = Modifier_ApplyToEntity(modifier, eid)
          table.insert(result, modid)
          Modifier_AddToEntityTable(eid, modid)      
        end
      end
		end
	end
	local _ApplyModifierToEntity = function(gid, idx, eid)
		local modid = Modifier_ApplyToEntity(modifier, eid)
		table.insert(result, modid)
		Modifier_AddToEntityTable(eid, modid)
	end
	
	if (scartype(groupid) == ST_SGROUP) then
		-- apply this to each squad in the group
		SGroup_ForEachEx(groupid, _ApplyModifierToSquad, true, true)
	elseif (scartype(groupid) == ST_EGROUP) then
		-- apply this to each entity in the group
		EGroup_ForEach(groupid, _ApplyModifierToEntity)
	end
	
	return result
	
end



--? @shortdesc Modifies a squad's weapon reload time.
--? @extdesc The hardpoint should be specified as a string - i.e. "hardpoint_01"
--? @result ModID
--? @args SGroupID/EGroupID group, String hardpoint, Real scalefactor
function Modify_WeaponReload(groupid, hardpoint, factor)

	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Weapon, "modifiers\\reload_weapon_modifier.lua", MUT_Multiplication, false, factor, hardpoint)
	local result = {}
	
	local _ApplyModifierToSquad = function(gid, idx, sid)
		if Squad_IsValid(Squad_GetGameID(sid)) and Squad_Count(sid) > 0 and Squad_HasWeaponHardpoint(sid, hardpoint) then
      -- For Weapon Modifiers with specified hardpoint, the modifier is added to each Squad Entity.  This matches the logic on the code side.
      local squadCount = Squad_Count(sid)
      local eid = nil
      for i = 1, squadCount do
        eid = Squad_EntityAt(sid, i-1)
        if (Entity_IsSpawned(eid)) and (Entity_IsAlive(eid)) then
          local modid = Modifier_ApplyToEntity(modifier, eid)
          table.insert(result, modid)
          Modifier_AddToEntityTable(eid, modid)      
        end
      end
		end
	end
	local _ApplyModifierToEntity = function(gid, idx, eid)
		local modid = Modifier_ApplyToEntity(modifier, eid)
		table.insert(result, modid)
		Modifier_AddToEntityTable(eid, modid)
	end
	
	if (scartype(groupid) == ST_SGROUP) then
		-- apply this to each squad in the group
		SGroup_ForEachEx(groupid, _ApplyModifierToSquad, true, true)
	elseif (scartype(groupid) == ST_EGROUP) then
		-- apply this to each entity in the group
		EGroup_ForEach(groupid, _ApplyModifierToEntity)
	end
	
	return result
	
end


--? @shortdesc Modifies a squad's weapon scatter.
--? @extdesc The hardpoint should be specified as a string - i.e. "hardpoint_01"
--? @result ModID
--? @args SGroupID/EGroupID group, String hardpoint, Real scalefactor
function Modify_WeaponScatter(groupid, hardpoint, factor)

	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Weapon, "modifiers\\weapon_scatter.lua", MUT_Multiplication, false, factor, hardpoint)
	local result = {}
	
	local _ApplyModifierToSquad = function(gid, idx, sid)
		if Squad_IsValid(Squad_GetGameID(sid)) and Squad_Count(sid) > 0 and Squad_HasWeaponHardpoint(sid, hardpoint) then
      -- For Weapon Modifiers with specified hardpoint, the modifier is added to each Squad Entity.  This matches the logic on the code side.
      local squadCount = Squad_Count(sid)
      local eid = nil
      for i = 1, squadCount do
        eid = Squad_EntityAt(sid, i-1)
        if (Entity_IsSpawned(eid)) and (Entity_IsAlive(eid)) then
          local modid = Modifier_ApplyToEntity(modifier, eid)
          table.insert(result, modid)
          Modifier_AddToEntityTable(eid, modid)      
        end
      end
		end
	end
	local _ApplyModifierToEntity = function(gid, idx, eid)
		local modid = Modifier_ApplyToEntity(modifier, eid)
		table.insert(result, modid)
		Modifier_AddToEntityTable(eid, modid)
	end
	
	if (scartype(groupid) == ST_SGROUP) then
		-- apply this to each squad in the group
		SGroup_ForEachEx(groupid, _ApplyModifierToSquad, true, true)
	elseif (scartype(groupid) == ST_EGROUP) then
		-- apply this to each entity in the group
		EGroup_ForEach(groupid, _ApplyModifierToEntity)
	end
	
	return result
	
end


--? @shortdesc Modifies a squad's weapon burst length (time).
--? @extdesc The hardpoint should be specified as a string - i.e. "hardpoint_01"
--? @result ModID
--? @args SGroupID/EGroupID group, String hardpoint, Real scalefactor
function Modify_WeaponBurstLength(groupid, hardpoint, factor)

	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Weapon, "modifiers\\weapon_burst_length_modifier.lua", MUT_Multiplication, false, factor, hardpoint)
	local result = {}
	
	local _ApplyModifierToSquad = function(gid, idx, sid)
		if Squad_IsValid(Squad_GetGameID(sid)) and Squad_Count(sid) > 0 and Squad_HasWeaponHardpoint(sid, hardpoint) then
      -- For Weapon Modifiers with specified hardpoint, the modifier is added to each Squad Entity.  This matches the logic on the code side.
      local squadCount = Squad_Count(sid)
      local eid = nil
      for i = 1, squadCount do
        eid = Squad_EntityAt(sid, i-1)
        if (Entity_IsSpawned(eid)) and (Entity_IsAlive(eid)) then
          local modid = Modifier_ApplyToEntity(modifier, eid)
          table.insert(result, modid)
          Modifier_AddToEntityTable(eid, modid)      
        end
      end
		end
	end
	local _ApplyModifierToEntity = function(gid, idx, eid)
		local modid = Modifier_ApplyToEntity(modifier, eid)
		table.insert(result, modid)
		Modifier_AddToEntityTable(eid, modid)
	end
	
	if (scartype(groupid) == ST_SGROUP) then
		-- apply this to each squad in the group
		SGroup_ForEachEx(groupid, _ApplyModifierToSquad, true, true)
	elseif (scartype(groupid) == ST_EGROUP) then
		-- apply this to each entity in the group
		EGroup_ForEach(groupid, _ApplyModifierToEntity)
	end
	
	return result
	
end


--? @shortdesc Modifies a squad's weapon rate of fire.
--? @extdesc The hardpoint should be specified as a string - i.e. "hardpoint_01"
--? @result ModID
--? @args SGroupID/EGroupID group, String hardpoint, Real scalefactor
function Modify_WeaponBurstRateOfFire(groupid, hardpoint, factor)

	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Weapon, "modifiers\\weapon_burst_rate_of_fire_modifier.lua", MUT_Multiplication, false, factor, hardpoint)
	local result = {}
	
	local _ApplyModifierToSquad = function(gid, idx, sid)
		if Squad_IsValid(Squad_GetGameID(sid)) and Squad_Count(sid) > 0 and Squad_HasWeaponHardpoint(sid, hardpoint) then
      -- For Weapon Modifiers with specified hardpoint, the modifier is added to each Squad Entity.  This matches the logic on the code side.
      local squadCount = Squad_Count(sid)
      local eid = nil
      for i = 1, squadCount do
        eid = Squad_EntityAt(sid, i-1)
        if (Entity_IsSpawned(eid)) and (Entity_IsAlive(eid)) then
          local modid = Modifier_ApplyToEntity(modifier, eid)
          table.insert(result, modid)
          Modifier_AddToEntityTable(eid, modid)      
        end
      end
		end
	end
	local _ApplyModifierToEntity = function(gid, idx, eid)
		local modid = Modifier_ApplyToEntity(modifier, eid)
		table.insert(result, modid)
		Modifier_AddToEntityTable(eid, modid)
	end
	
	if (scartype(groupid) == ST_SGROUP) then
		-- apply this to each squad in the group
		SGroup_ForEachEx(groupid, _ApplyModifierToSquad, true, true)
	elseif (scartype(groupid) == ST_EGROUP) then
		-- apply this to each entity in the group
		EGroup_ForEach(groupid, _ApplyModifierToEntity)
	end
	
	return result
	
end




--? @shortdesc Modifies a squad's weapon damage.
--? @extdesc The hardpoint should be specified as a string - i.e. "hardpoint_01"
--? @result ModID
--? @args SGroupID/EGroupID group, String hardpoint, Real scalefactor
function Modify_WeaponDamage(groupid, hardpoint, factor)

	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Weapon, "modifiers\\damage_weapon_modifier.lua", MUT_Multiplication, false, factor, hardpoint)
	local result = {}
	
	local _ApplyModifierToSquad = function(gid, idx, sid)
		if Squad_IsValid(Squad_GetGameID(sid)) and Squad_Count(sid) > 0 and Squad_HasWeaponHardpoint(sid, hardpoint) then
      -- For Weapon Modifiers with specified hardpoint, the modifier is added to each Squad Entity.  This matches the logic on the code side.
      local squadCount = Squad_Count(sid)
      local eid = nil
      for i = 1, squadCount do
        eid = Squad_EntityAt(sid, i-1)
        if (Entity_IsSpawned(eid)) and (Entity_IsAlive(eid)) then
          local modid = Modifier_ApplyToEntity(modifier, eid)
          table.insert(result, modid)
          Modifier_AddToEntityTable(eid, modid)      
        end
      end
		end
	end
	local _ApplyModifierToEntity = function(gid, idx, eid)
		local modid = Modifier_ApplyToEntity(modifier, eid)
		table.insert(result, modid)
		Modifier_AddToEntityTable(eid, modid)
	end
	
	if (scartype(groupid) == ST_SGROUP) then
		-- apply this to each squad in the group
		SGroup_ForEachEx(groupid, _ApplyModifierToSquad, true, true)
	elseif (scartype(groupid) == ST_EGROUP) then
		-- apply this to each entity in the group
		EGroup_ForEach(groupid, _ApplyModifierToEntity)
	end
	
	return result
	
end




--? @shortdesc Modifies the damage a squad/entity receives.
--? @result ModID
--? @args SGroupID/EGroupID group, Real scalefactor[, Boolean exclusive]
function Modify_ReceivedDamage(groupid, factor, exclusive)

	-- create the appropriate modifier
	local modifier = 0
	local result = {}
	
	if scartype(exclusive) ~= ST_BOOLEAN then
		exclusive = false
	end
	
	if (scartype(groupid) == ST_SGROUP) then
		modifier = Modifier_Create(MAT_Squad, "modifiers\\received_damage_modifier.lua", MUT_Multiplication, exclusive, factor, "")
	elseif (scartype(groupid) == ST_EGROUP) then
		modifier = Modifier_Create(MAT_Entity, "modifiers\\received_damage_modifier.lua", MUT_Multiplication, exclusive, factor, "")
	end
	
	local _ApplyModifierToSquad = function(gid, idx, sid)
		if Squad_IsValid(Squad_GetGameID(sid)) and Squad_Count(sid) > 0 then
			local modid = Modifier_ApplyToSquad(modifier, sid)
			table.insert(result, modid)
			Modifier_AddToSquadTable(sid, modid)
		end
	end
	local _ApplyModifierToEntity = function(gid, idx, eid)
		local modid = Modifier_ApplyToEntity(modifier, eid)
		table.insert(result, modid)
		Modifier_AddToEntityTable(eid, modid)
	end
	
	if (scartype(groupid) == ST_SGROUP) then								-- apply this to each squad in the group
		SGroup_ForEachEx(groupid, _ApplyModifierToSquad, true, true)
	elseif (scartype(groupid) == ST_EGROUP) then							-- apply this to each entity in the group
		EGroup_ForEach(groupid, _ApplyModifierToEntity)
	end
	
	return result
	
end


--? @shortdesc Modifies a squad or entity's armor
--? @result ModID
--? @args SGroupID/EGroupID group, Real scalefactor[, Boolean exclusive]
function Modify_Armor(groupid, factor, exclusive)

	-- create the appropriate modifier
	local modifier = 0
	local result = {}
	
	if scartype(exclusive) ~= ST_BOOLEAN then
		exclusive = false
	end
	
	if (scartype(groupid) == ST_SGROUP) then
		modifier = Modifier_Create(MAT_Squad, "modifiers\\armor_modifier.lua", MUT_Multiplication, exclusive, factor, "")
	elseif (scartype(groupid) == ST_EGROUP) then
		modifier = Modifier_Create(MAT_Entity, "modifiers\\armor_modifier.lua", MUT_Multiplication, exclusive, factor, "")
	end
	
	local _ApplyModifierToSquad = function(gid, idx, sid)
		if Squad_IsValid(Squad_GetGameID(sid)) and Squad_Count(sid) > 0 then
			local modid = Modifier_ApplyToSquad(modifier, sid)
			table.insert(result, modid)
			Modifier_AddToSquadTable(sid, modid)
		end
	end
	local _ApplyModifierToEntity = function(gid, idx, eid)
		local modid = Modifier_ApplyToEntity(modifier, eid)
		table.insert(result, modid)
		Modifier_AddToEntityTable(eid, modid)
	end
	
	if (scartype(groupid) == ST_SGROUP) then								-- apply this to each squad in the group
		SGroup_ForEachEx(groupid, _ApplyModifierToSquad, true, true)
	elseif (scartype(groupid) == ST_EGROUP) then							-- apply this to each entity in the group
		EGroup_ForEach(groupid, _ApplyModifierToEntity)
	end
	
	return result
	
end





--? @shortdesc Modifies the chance of a squad/entity being hit
--? @result ModID
--? @args SGroupID/EGroupID group, Real scalefactor[, Boolean exclusive]
function Modify_ReceivedAccuracy(groupid, factor, exclusive)

	-- create the appropriate modifier
	local modifier = 0
	local result = {}
	
	if scartype(exclusive) ~= ST_BOOLEAN then
		exclusive = false
	end
	
	if (scartype(groupid) == ST_SGROUP) then
		modifier = Modifier_Create(MAT_Squad, "modifiers\\received_accuracy_modifier.lua", MUT_Multiplication, exclusive, factor, "")
	elseif (scartype(groupid) == ST_EGROUP) then
		modifier = Modifier_Create(MAT_Entity, "modifiers\\received_accuracy_modifier.lua", MUT_Multiplication, exclusive, factor, "")
	end
	
	local _ApplyModifierToSquad = function(gid, idx, sid)
		if Squad_IsValid(Squad_GetGameID(sid)) and Squad_Count(sid) > 0 then
			local modid = Modifier_ApplyToSquad(modifier, sid)
			table.insert(result, modid)
			Modifier_AddToSquadTable(sid, modid)
		end
	end
	local _ApplyModifierToEntity = function(gid, idx, eid)
		local modid = Modifier_ApplyToEntity(modifier, eid)
		table.insert(result, modid)
		Modifier_AddToEntityTable(eid, modid)
	end
	
	if (scartype(groupid) == ST_SGROUP) then								-- apply this to each squad in the group
		SGroup_ForEachEx(groupid, _ApplyModifierToSquad, true, true)
	elseif (scartype(groupid) == ST_EGROUP) then							-- apply this to each entity in the group
		EGroup_ForEach(groupid, _ApplyModifierToEntity)
	end
	
	return result
	
end


--? @shortdesc Modifies the rate at which a squad gets suppressed
--? @result ModID
--? @args SGroupID sgroup, Real scalefactor
function Modify_ReceivedSuppression(group, factor)

	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Squad, "modifiers\\received_suppression_squad_modifier.lua", MUT_Multiplication, false, factor, "")
	local result = {}
	
	-- apply this to each squad in the group
	local _ApplyModifier = function (gid, idx, sid)
		if Squad_IsValid(Squad_GetGameID(sid)) and Squad_Count(sid) > 0 then
			local modid = Modifier_ApplyToSquad(modifier, sid)
			table.insert(result, modid)
			Modifier_AddToSquadTable(sid, modid)
		end
	end
	SGroup_ForEachEx(group, _ApplyModifier, true, true)
	
	return result
	
end





--? @shortdesc Modifies the maximum speed for a vehicle. This has no effect on infantry.
--? @result ModID
--? @args SGroupID sgroup, Real scalefactor
function Modify_UnitSpeed(group, factor)

	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Squad, "modifiers\\speed_maximum_modifier.lua", MUT_Multiplication, false, factor, "")
	local result = {}
	
	-- apply this to each squad in the group
	local _ApplyModifier = function (gid, idx, sid)
		if Squad_IsValid(Squad_GetGameID(sid)) and Squad_Count(sid) > 0 then
			local modid = Modifier_ApplyToSquad(modifier, sid)
			table.insert(result, modid)
			Modifier_AddToSquadTable(sid, modid)
		end
	end
	SGroup_ForEachEx(group, _ApplyModifier, true, true)
	
	return result
	
end



--? @shortdesc Modifies the Veterancy Experience value of the target SGroup, EGroup, Entity, or Squad. Mathtype is Multiplication by default
--? @result ModID
--? @args SGroup/EGroup group, Real scalefactor[, Integer mathtype, exclusive] 
function Modify_UnitVeterancyValue(group, factor, mathtype, exclusive)

	modifier = "modifiers\\entity_veterency_experience_modifier.lua"
	mathtype = mathtype or MUT_Multiplication

	Util_ApplyModifier(group, modifier, factor, mathtype, exclusive)
	
end



--? @shortdesc Modifies the sight radius for a player.
--? @result ModID
--? @args PlayerID player, Real scalefactor
function Modify_PlayerSightRadius(playerid, factor)

	local result = {}

	local modifier = Modifier_Create(MAT_Player, "modifiers\\sight_radius_player_modifier.lua", MUT_Multiplication, false, factor, "")
	table.insert(result, Modifier_ApplyToPlayer(modifier, playerid))
	
	return result
	
end


--? @shortdesc Modifies the sight radius of a squad type for any given player
--? @result ModID
--? @args PlayerID player, String blueprint, Real scalefactor
function Modify_SquadTypeSightRadius(playerid, blueprint, factor)
	
	local modifier = 0
	local result = {}
	
	__sg_playerTempGroup = SGroup_CreateIfNotFound("__sg_playerTempGroup")
	Player_GetAll(playerid, __sg_playerTempGroup)
	
	-- create the appropriate modifier
	modifier = Modifier_Create(MAT_Squad, "modifiers\\sight_radius_modifier.lua", MUT_Multiplication, false, factor, "")
	
	local _ApplyModifierToSquad = function(gid, idx, sid)
		if Squad_GetBlueprint(sid) == blueprint then
			if Squad_IsValid(Squad_GetGameID(sid)) and Squad_Count(sid) > 0 then
				local modid = Modifier_ApplyToSquad(modifier, sid)
				table.insert(result, modid)
				Modifier_AddToSquadTable(sid, modid)
			end
		end
	end
	
	if (scartype(__sg_playerTempGroup) == ST_SGROUP) then
		-- apply this to each squad in the group
		SGroup_ForEachEx(__sg_playerTempGroup, _ApplyModifierToSquad, true, true)
	end

	return result
	
end



--? @shortdesc Modifies the sight radius for an egroup or an sgroup.
--? @result ModID
--? @args SGroupID/EGroupID group, Real scalefactor
function Modify_SightRadius(groupid, factor)

	local modifier = 0
	local result = {}
	
	if (scartype(groupid) == ST_SGROUP) then
		modifier = Modifier_Create(MAT_Squad, "modifiers\\sight_radius_modifier.lua", MUT_Multiplication, false, factor, "")
	elseif (scartype(groupid) == ST_EGROUP) then
		modifier = Modifier_Create(MAT_Entity, "modifiers\\sight_radius_modifier.lua", MUT_Multiplication, false, factor, "")
	end
	
	local _ApplyModifierToSquad = function(gid, idx, sid)
		if Squad_IsValid(Squad_GetGameID(sid)) and Squad_Count(sid) > 0 then
			local modid = Modifier_ApplyToSquad(modifier, sid)
			table.insert(result, modid)
			Modifier_AddToSquadTable(sid, modid)
		end
	end
	local _ApplyModifierToEntity = function(gid, idx, eid)
		local modid = Modifier_ApplyToEntity(modifier, eid)
		table.insert(result, modid)
		Modifier_AddToEntityTable(eid, modid)
	end
	
	if (scartype(groupid) == ST_SGROUP) then
		-- apply this to each squad in the group
		print("SGROUP")
		SGroup_ForEachEx(groupid, _ApplyModifierToSquad, true, true)
	elseif (scartype(groupid) == ST_EGROUP) then
		-- apply this to each entity in the group
		print("EGROUP")
		EGroup_ForEach(groupid, _ApplyModifierToEntity)
	end

	return result
	
end



--? @shortdesc Modifies the territory radius for an egroup or an sgroup.
--? @result ModID
--? @args EGroupID group, Real scalefactor
function Modify_TerritoryRadius(groupid, factor)

	local modifier = Modifier_Create(MAT_Entity, "modifiers\\territory_radius_max.lua", MUT_Multiplication, false, factor, "")
	local result = {}
	
	local _ApplyModifierToEntity = function(gid, idx, eid)
		local modid = Modifier_ApplyToEntity(modifier, eid)
		table.insert(result, modid)
		Modifier_AddToEntityTable(eid, modid)
	end
	
	if (scartype(groupid) == ST_EGROUP) then
		-- apply this to each entity in the group
		print("EGROUP")
		EGroup_ForEach(groupid, _ApplyModifierToEntity)
	end

	return result
	
end



--? @shortdesc Increases the received accuracy, penetration, and damage on a squad by the scalefactor.  For example, a scalefactor of 2 means that the squad gets 2x the received accuracy, 2x the received penetration, and 2x the received damage.
--? @result ModID
--? @args EGroupID/SGroupID group, Real scalefactor
function Modify_Vulnerability(group, factor)

	local mod_types = {
		"modifiers\\received_penetration_modifier.lua",
		"modifiers\\received_accuracy_modifier.lua",
		"modifiers\\received_damage_modifier.lua",
	}
	
	local modifiers = {}
	local result = {}

	if scartype(group) == ST_SGROUP then
		-- create the appropriate modifier
		for i=1, table.getn(mod_types) do
			modifiers[i] = Modifier_Create(MAT_Squad,	mod_types[i], MUT_Multiplication, false, factor, "")
		end
		
		-- apply this to each squad in the group
		local _ApplyModifierToSquad = function (gid, idx, sid)
			for i=1, table.getn(modifiers) do 
				if Squad_IsValid(Squad_GetGameID(sid)) and Squad_Count(sid) > 0 then
					local modid = Modifier_ApplyToSquad(modifiers[i], sid)
					table.insert(result, modid)
					Modifier_AddToSquadTable(sid, modid)
				end
			end
		end
		
		SGroup_ForEachEx(group, _ApplyModifierToSquad, true, true)
		
	elseif scartype(group) == ST_EGROUP then
	
		-- create the appropriate modifier
		for i=1, table.getn(mod_types) do
			modifiers[i] = Modifier_Create(MAT_Entity,	mod_types[i], MUT_Multiplication, false, factor, "")
		end
		
		-- apply this to each squad in the group
		local _ApplyModifierToEntity = function (gid, idx, eid)
			for i=1, table.getn(modifiers) do 
				local modid = Modifier_ApplyToEntity(modifiers[i], eid)
				table.insert(result, modid)
				Modifier_AddToEntityTable(eid, modid)
			end
		end
		
		EGroup_ForEachEx(group, _ApplyModifierToEntity, true, true)
		
	end
	
	return result
	
end




--? @shortdesc Modifies the availability limit of a squad type for any given player
--? @result ModID
--? @args PlayerID player, String blueprint, Integer addition
function Modify_SquadAvailability(playerid, blueprint, addition)

	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_SquadType, "modifiers\\squad_availability_modifier.lua", MUT_Addition, false, addition, blueprint)

	return {Modifier_ApplyToPlayer(modifier, playerid)}
	
end



--? @shortdesc Modifies a squad's rate at which it will capture a strategic point.
--? @result ModID
--? @args SGroupID group, Real scalefactor
function Modify_SquadCaptureRate(groupid, factor)

	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Squad, "modifiers\\capture_rate_squad_modifier.lua", MUT_Multiplication, false, factor, "")
	local result = {}
	
	local _ApplyModifierToSquad = function(gid, idx, sid)
		if Squad_IsValid(Squad_GetGameID(sid)) and Squad_Count(sid) > 0 then
			local modid = Modifier_ApplyToSquad(modifier, sid)
			table.insert(result, modid)
			Modifier_AddToSquadTable(sid, modid)
		end
	end
	
	if (scartype(groupid) == ST_SGROUP) then
		-- apply this to each squad in the group
		SGroup_ForEachEx(groupid, _ApplyModifierToSquad, true, true)
	end

	return result

end



--? @shortdesc Modifies the target priority of a squad or entity group from the attacker. The value is an addition
--? @result ModID
--? @args SGroupID/EGroupID group, Integer addition
function Modify_TargetPriority(groupid, addition)

	-- create the appropriate modifiers
	local modifier = 0
	local result = {}
	
	if (scartype(groupid) == ST_SGROUP) then
		modifier = Modifier_Create(MAT_Squad, "modifiers\\target_priority_squad_modifier.lua", MUT_Addition, false, addition, "")
	elseif (scartype(groupid) == ST_EGROUP) then
		modifier = Modifier_Create(MAT_Entity, "modifiers\\target_priority_modifier.lua", MUT_Addition, false, addition, "")
	end
	
	local _ApplyModifierToSquad = function(gid, idx, sid)
		if Squad_IsValid(Squad_GetGameID(sid)) and Squad_Count(sid) > 0 then
			local modid = Modifier_ApplyToSquad(modifier, sid)
			table.insert(result, modid)
			Modifier_AddToSquadTable(sid, modid)
		end
	end
	local _ApplyModifierToEntity = function(gid, idx, eid)
		local modid = Modifier_ApplyToEntity(modifier, eid)
		table.insert(result, modid)
		Modifier_AddToEntityTable(eid, modid)
	end
	
	if (scartype(groupid) == ST_SGROUP) then
		-- apply this to each squad in the group
		SGroup_ForEachEx(groupid, _ApplyModifierToSquad, true, true)
	elseif (scartype(groupid) == ST_EGROUP) then
		-- apply this to each entity in the group
		EGroup_ForEach(groupid, _ApplyModifierToEntity)
	end
	
	return result
	
end



--? @shortdesc Modifies the capture time of all strategic points in an EGroup. DO NOT USE THIS FUNCTION.
--? @result ModID
--? @args EGroupID sgroup, Real scalefactor
function Modify_CaptureTime(group, factor)

	-- create the appropriate modifier
	if factor ~= 0 then
		factor = 1.0 / factor
	else
		factor = 99999 -- capture instantly
	end
	local modifier = Modifier_Create(MAT_Entity, "modifiers\\strategic_point_capture_ticks_modifier.lua", MUT_Multiplication, false, factor, "")
	local result = {}
	
	-- apply this to each squad in the group
	local _ApplyModifier = function (gid, idx, sid)
		if Entity_IsStrategicPoint(sid) then
			local modid = Modifier_ApplyToEntity(modifier, sid)
			table.insert(result, modid)
			Modifier_AddToEntityTable(sid, modid)
		end
	end
	EGroup_ForEachEx(group, _ApplyModifier, true, true)
	
	return result
	
end




--? @shortdesc Modifies the production rate of all factories in an EGroup
--? @result ModID
--? @args EGroupID sgroup, Real scalefactor
function Modify_ProductionRate(group, factor)

	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Entity, "modifiers\\production_speed_modifier.lua", MUT_Multiplication, false, factor, "")
	local result = {}
	
	-- apply this to each squad in the group
	local _ApplyModifier = function (gid, idx, sid)
		local modid = Modifier_ApplyToEntity(modifier, sid)
		table.insert(result, modid)
		Modifier_AddToEntityTable(sid, modid)
	end
	EGroup_ForEachEx(group, _ApplyModifier, true, true)
	
	return result
	
end




--? @shortdesc Modifies the production rate of a player.
--? @result ModID
--? @args PlayerID sgroup, Real scalefactor
function Modify_PlayerProductionRate(player, factor)

	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Player, "modifiers\\production_speed_player_modifier.lua", MUT_Multiplication, false, factor, "")
	
	return Modifier_ApplyToPlayer(modifier, player)
	
end




--? @shortdesc Modifies the recharge time of an ability
--? @result ModID
--? @args PlayerID player, AbilityID ability, Real scalefactor[, Integer mathtype]
function Modify_AbilityRechargeTime(playerid, abilityid, factor, mathtype)
	
	mathtype = mathtype or MUT_Multiplication
	
	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Ability, "modifiers\\ability_recharge_time_modifier.lua", mathtype, false, factor, abilityid)

	return {Modifier_ApplyToPlayer(modifier, playerid)}

end




--? @shortdesc Modifies the munitions cost of an ability
--? @result ModID
--? @args PlayerID player, AbilityID ability, Real scalefactor[, Integer mathtype]
function Modify_AbilityMunitionsCost(playerid, abilityid, factor, mathtype)
	
	mathtype = mathtype or MUT_Multiplication
	
	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Ability, "modifiers\\ability_cost_munition_multiplier.lua", mathtype, false, factor, abilityid)

	return {Modifier_ApplyToPlayer(modifier, playerid)} 

end


--? @shortdesc Modifies the manpower cost of an ability
--? @result ModID
--? @args PlayerID player, AbilityID ability, Real scalefactor[, Integer mathtype]
function Modify_AbilityManpowerCost(playerid, abilityid, factor, mathtype)
	
	mathtype = mathtype or MUT_Multiplication
	
	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Ability, "modifiers\\ability_cost_manpower_modifier.lua", mathtype, false, factor, abilityid)

	return {Modifier_ApplyToPlayer(modifier, playerid)} 

end


--? @shortdesc Modifies the initial delay time of an ability
--? @result ModID
--? @args PlayerID player, AbilityID ability, Real scalefactor
function Modify_AbilityDelayTime(playerid, abilityid, factor)
	
	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Ability, "modifiers\\ability_delay_time_modifier.lua", MUT_Multiplication, false, factor, abilityid)

	return {Modifier_ApplyToPlayer(modifier, playerid)}

end

--? @shortdesc Modifies the minimum casting range of an ability. NOTE: it assumes that the actions that the ability executes can also handle the modified range
--? @result ModID
--? @args PlayerID player, AbilityID ability, Real scalefactor
function Modify_AbilityMinCastRange(playerid, abilityid, factor)

	local modifier = Modifier_Create(MAT_Ability, "modifiers\\ability_min_range_modifier.lua", MUT_Multiplication, false, factor, abilityid)
	
	return {Modifier_ApplyToPlayer(modifier, playerid)}
	
end


--? @shortdesc Modifies the maximum casting range of an ability. NOTE: it assumes that the actions that the ability executes can also handle the modified range
--? @result ModID
--? @args PlayerID player, AbilityID ability, Real scalefactor
function Modify_AbilityMaxCastRange(playerid, abilityid, factor)

	local modifier = Modifier_Create(MAT_Ability, "modifiers\\ability_max_range_modifier.lua", MUT_Multiplication, false, factor, abilityid)
	
	return {Modifier_ApplyToPlayer(modifier, playerid)}
	
end

--? @shortdesc Modifies the duration of an ability
--? @result ModID
--? @args PlayerID player, AbilityID ability, Real scalefactor
function Modify_AbilityDurationTime(playerid, abilityid, factor)

	local modifier = Modifier_Create(MAT_Ability, "modifiers\\ability_duration_time_modifier.lua", MUT_Multiplication, false, factor, abilityid)
	
	return {Modifier_ApplyToPlayer(modifier, playerid)}
	
end




--? @shortdesc Modifies the cost of an entity for a particular player. Possible resource types are RT_Manpower, RT_Munition, RT_Fuel, RT_Action 
--? @result ModID
--? @args PlayerID player, String blueprint, Integer resourcetype, Integer addition
function Modify_EntityCost(playerid, blueprint, resource, addition)

	local modifiertype = ""
	
	if (resource == RT_Manpower) then
		modifiertype = "modifiers\\cost_manpower_modifier.lua"
	elseif (resource == RT_Munition) then
		modifiertype =  "modifiers\\cost_munition_modifier.lua"
	elseif (resource == RT_Fuel) then
		modifiertype =  "modifiers\\cost_fuel_modifier.lua"
	elseif (resource == RT_Action) then
		modifiertype =  "modifiers\\cost_action_modifier.lua"
	end

	local modifier = Modifier_Create(MAT_EntityType, modifiertype, MUT_Addition, false, addition, blueprint)

	return {Modifier_ApplyToPlayer(modifier, playerid)}

end	


--? @shortdesc Modifies the vehicle repair rate of all a player's engineers
--? @result ModID
--? @args PlayerID player, Real factor, String engineer_entity_blueprint
function Modify_VehicleRepairRate(playerid, factor, engineer_blueprint)

--~ 	if engineer_blueprint == nil then
--~ 		engineer_blueprint = "ebps\\races\\allies\\soldiers\\engineer.lua"
--~ 	end
	
	local modifier = Modifier_Create(MAT_EntityType, "modifiers\\vehicle_repair_rate_modifier.lua", MUT_Multiplication, false, factor, engineer_blueprint)
	return {Modifier_ApplyToPlayer(modifier, playerid)}
	
end




--? @shortdesc Modifies the vehicle rotation speed
--? @result ModID
--? @args EGroupID/SGroupID group, Real factor
function Modify_VehicleRotationSpeed(groupid, factor)

	local modifier = 0
	local result = {}
	
	if (scartype(groupid) == ST_SGROUP) then
		modifier = Modifier_Create(MAT_Squad, "modifiers\\rotation_speed_modifier.lua", MUT_Multiplication, false, factor, "")
	elseif (scartype(groupid) == ST_EGROUP) then
		modifier = Modifier_Create(MAT_Entity, "modifiers\\rotation_speed_modifier.lua", MUT_Multiplication, false, factor, "")
	end
	
	local _ApplyModifierToSquad = function(gid, idx, sid)
		if Squad_IsValid(Squad_GetGameID(sid)) and Squad_Count(sid) > 0 then
			local modid = Modifier_ApplyToSquad(modifier, sid)
			table.insert(result, modid)
			Modifier_AddToSquadTable(sid, modid)
		end
	end
	local _ApplyModifierToEntity = function(gid, idx, eid)
		local modid = Modifier_ApplyToEntity(modifier, eid)
		table.insert(result, modid)
		Modifier_AddToEntityTable(eid, modid)
	end
	
	if (scartype(groupid) == ST_SGROUP) then
		-- apply this to each squad in the group
		print("SGROUP")
		SGroup_ForEachEx(groupid, _ApplyModifierToSquad, true, true)
	elseif (scartype(groupid) == ST_EGROUP) then
		-- apply this to each entity in the group
		print("EGROUP")
		EGroup_ForEach(groupid, _ApplyModifierToEntity)
	end

	return result
	
end



--? @shortdesc Modifies the turret rotation speed of a vehicle squad
--? @extdesc The hardpoint should be specified as a string - i.e. "hardpoint_01"
--? @result ModID
--? @args SGroupID/EGroupID group, String hardpoint, Real scalefactor
function Modify_VehicleTurretRotationSpeed(groupid, hardpoint, factor)

	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Weapon, "modifiers\\horizontal_speed_weapon_modifier.lua", MUT_Multiplication, false, factor, hardpoint)
	local result = {}
	
	local _ApplyModifierToSquad = function(gid, idx, sid)
		if Squad_IsValid(Squad_GetGameID(sid)) and Squad_Count(sid) > 0 and Squad_HasWeaponHardpoint(sid, hardpoint) then
			local modid = Modifier_ApplyToSquad(modifier, sid)
			table.insert(result, modid)
			Modifier_AddToSquadTable(sid, modid)
		end
	end
	local _ApplyModifierToEntity = function(gid, idx, eid)
		local modid = Modifier_ApplyToEntity(modifier, eid)
		table.insert(result, modid)
		Modifier_AddToEntityTable(eid, modid)
	end
	
	if (scartype(groupid) == ST_SGROUP) then
		-- apply this to each squad in the group
		SGroup_ForEachEx(groupid, _ApplyModifierToSquad, true, true)
	elseif (scartype(groupid) == ST_EGROUP) then
		-- apply this to each entity in the group
		EGroup_ForEach(groupid, _ApplyModifierToEntity)
	end
	
	return result
	
end




--? @shortdesc Modifies the veterancy experience received by a player
--? @result ModID
--? @args PlayerID player, Real factor
function Modify_PlayerExperienceReceived(playerid, factor)

	local modifier = Modifier_Create(MAT_Player, "modifiers\\received_experience_player_modifier.lua", MUT_Multiplication, false, factor, "")
	return {Modifier_ApplyToPlayer(modifier, playerid)}
	
end


--? @shortdesc Enable or disable hold (garrisoning) for an egroup or sgroup
--? @result ModID
--? @args EGroupID group, Boolean disable
function Modify_DisableHold(groupid, disable)

	local factor = -1.0
	if ( disable == true ) then
		factor = 1.0
	end
	
	local modifier = Modifier_Create(MAT_Entity, "modifiers\\hold_disable.lua", MUT_Enable, false, factor, "")
	local result = {}
	
	local _ApplyModifierToSquad = function(gid, idx, sid)
		if Squad_IsValid(Squad_GetGameID(sid)) and Squad_Count(sid) > 0 then
			local modid = Modifier_ApplyToSquad(modifier, sid)
			table.insert(result, modid)
			Modifier_AddToSquadTable(sid, modid)
		end
	end
	local _ApplyModifierToEntity = function(gid, idx, eid)
		local modid = Modifier_ApplyToEntity(modifier, eid)
		table.insert(result, modid)
		Modifier_AddToEntityTable(eid, modid)
	end
	
	if (scartype(groupid) == ST_SGROUP) then
		-- apply this to each squad in the group
		SGroup_ForEachEx(groupid, _ApplyModifierToSquad, true, true)
	elseif (scartype(groupid) == ST_EGROUP) then
		-- apply this to each entity in the group
		EGroup_ForEach(groupid, _ApplyModifierToEntity)
	end

	return result
	
end


--? @shortdesc Modifies a projectile's delay_detonate_time.
--? @result ModID
--? @args PlayerID player, PBG entityBP, Real factor
function Modify_ProjectileDelayTime(playerid, entityBP, factor)
	local modifier = Modifier_Create(MAT_EntityType, "modifiers\\projectile_delay_time.lua", MUT_Multiplication, false, factor, entityBP)
	return Modifier_ApplyToPlayer(modifier, playerid)
end


--? @group scardoc;Util

--? @shortdesc Applies any modifier to the target SGroup, EGroup, or Player
--? @extdesc Valid applytypes are MAT_...(Entity, Squad etc.), if left default assumption is default type for the target
--? Cases you want to define applytype: Weapon Modifiers, Enable Modifiers, or a player modifier for all entity or squad types
--? Valid mathtypes are MUT...(Addition, Multiplication, etc.)
--? Exclusive modifiers will replace all pre-existing modifiers of that modifier type on the target
--? @result ModID
--? @args SGroupID/EGroupID/Player groupid, String modifier, Real scalefactor, Real mathtype[, Real applytype, Bool exclusive, String targetname]
function Util_ApplyModifier(targetid, modifier, factor, mathtype, applytype, exclusive, targetname)
	
	local result = {}
	
	-- Special logic to handle Weapon Modifiers with specified hardpoint in the targetname.
	if (applytype == MAT_Weapon) and (targetname ~= nil) then
	  fatal("ERROR: Util_ApplyModifier does not support MAT_Weapon with specified hardpoint.  Use methods Modify_WeaponEnable, Modify_WeaponRange, etc. instead.")
	  return result
	end
	
	if targetname == nil then
		if type(applytype) == "string" then
			targetname = applytype
			applytype = nil
		elseif type(exclusive) == "string" then
			targetname = exclusive
			exclusive = nil
		else
			targetname = ""
		end
	end
	
	local modifier = "modifiers\\"..modifier..".lua"
	
	if exclusive == nil then
		if type(applytype) == "boolean" then
			exclusive = applytype
			applytype = nil
		else
			exclusive = false
		end
	end
	
	local modtable = {
		{ 
			targetscarid = ST_SGROUP,
			applytype = MAT_Squad,
			applyto = {
				apply = Modifier_ApplyToSquad,
				run = SGroup_ForEach,
				addtoTable = Modifier_AddToSquadTable
			}
		},
		{ 
			targetscarid = ST_EGROUP,
			applytype = MAT_Entity,
			applyto = {
				apply = Modifier_ApplyToEntity,
				run = EGroup_ForEach,
				addtoTable = Modifier_AddToEntityTable
			}
		},
		{ 
			targetscarid = ST_ENTITY,
			applytype = MAT_Entity,
			applyto = {
				apply = Modifier_ApplyToEntity,
				addtoTable = Modifier_AddToEntityTable
			}
		},
		{ 
			targetscarid = ST_SQUAD,
			applytype = MAT_Squad,
			applyto = {
				apply = Modifier_ApplyToSquad,
				addtoTable = Modifier_AddToSquadTable
			}
		},
		{ 
			targetscarid = ST_PLAYER,
			applytype = MAT_Player,
			applyto = {
				apply = Modifier_ApplyToPlayer
			}
		}
	}
	
	
	for k, v in pairs(modtable) do
		
		if scartype(targetid) == v.targetscarid then
			
			applytype = applytype or v.applytype
			
			local scarModifier = Modifier_Create(applytype, modifier, mathtype, exclusive, factor, targetname)
			
			local _ApplyModifier = function(gid, idx, id)
				local modid = v.applyto.apply(scarModifier, id)
				table.insert(result, modid)
				v.applyto.addtoTable(id, modid)		
			end
			
			if (v.applyto.run ~= nil) and (v.applyto.addtoTable ~= nil) then
				v.applyto.run(targetid, _ApplyModifier)
				return result
				
			elseif (v.applyto.run == nil) and (v.applyto.addtoTable ~= nil) then
				_ApplyModifier(nil, nil, targetid)
				return result
				
			else
				return { v.applyto.apply(scarModifier, targetid) }
				
			end
		end
	end
end
