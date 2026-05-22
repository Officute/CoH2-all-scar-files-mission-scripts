----------------------------------------------------------------------------------------------------------------
-- Squad helper functions
-- (c) 2003 Relic Entertainment Inc.

--? @group scardoc;Squad

----------------------------------------------------------------------------------------------------------------
-- Squad helper functions

--? @shortdesc Returns true if ALL or ANY troopers in a squad are in cover.
--? @extdesc Set all to true to check if all troopers are in cover or set to false to check if any.
--? @args SquadID squadId, Boolean all
--? @result Boolean
function Squad_IsInCover( squadId, all )
	local n = Squad_Count( squadId )
	local i
	for i = 1, n do
		if( Squad_GetCoverType( squadId, n-1 ) == CT_None ) then
			if( all ) then return false end
		else
			if( any ) then return true end
		end
	end
	
	return all
end


--? @shortdesc Warps a squad immediately to a new position
--? @args SquadID squad, Position pos
--? @result Void
function Squad_WarpToPos(squad, pos)

	Squad_SetPosition(squad, pos, pos)
	
end

--? @shortdesc Set invulnerability on the squad. Reset time is in seconds. If it it set, the invulnerability will expire after this time.
--? @args SquadID squad, Bool enable, Float reset_time
--? @result Void
function Squad_SetInvulnerable(squad, enable, reset_time)

	local cap
	if ( enable == true ) then
		cap = 1.0
	elseif (enable == false) then
		cap = 0.0
	else
		cap = enable
	end
	
	Squad_SetInvulnerableMinCap( squad, cap, reset_time )
end


--? @shortdesc Check if the squad is invulnerable or not
--? @args SquadID squad
--? @result Bool
function Squad_GetInvulnerable(squad)

	return ( Squad_GetInvulnerableMinCap( squad ) == 1.0 )
end



--? @shortdesc Check if a squad has a critical or not
--? @args SquadID squad, CriticalID critical
--? @result Bool
function Squad_HasCritical(squad, critical)
	
	local result = false
	
	for n = 1, Squad_Count(squad) do
		
		if Entity_HasCritical(Squad_EntityAt(squad, n-1), critical) then
			result = true
			break
		end
		
	end
	
	return result

end

--? @shortdesc Check if a squad has a specific slot item
--? @args SquadID squad, SlotItemID slotItem
--? @result Bool
function Squad_HasSlotItem(squad, slotItem)

	local result = false
	local count = Squad_GetNumSlotItem(squad, slotItem)
	
	if count > 0 then
		result = true
	end
	
	return result
	
end


--? @shortdesc Returns true if the squad is currently retreating
--? @args SquadID squadid
--? @result Boolean
function Squad_IsRetreating(squad)

	if Squad_HasActiveCommand(squad) then
		
		if Squad_GetActiveCommand(squad) == SQUADSTATEID_Retreat then
			return true
		end
		
	end
	
	return false
	
end


--? @shortdesc Returns a table of SlotItem ID's that this squad currently owns
--? @args SquadID squadid
--? @result LuaTable
function Squad_GetSlotItemsTable(squadid)

	local slotItems = {}
	local itemcount = Squad_GetSlotItemCount(squadid)
	for i = 1, itemcount do
		
		local item = Squad_GetSlotItemAt(squadid, i)
		table.insert(slotItems, item)
		
	end
	
	return slotItems
	
end


--? @shortdesc Gives all slot items in a table to the squad. The table should come from Squad_GetSlotItemsTable
--? @args SquadID squadid, LuaTable itemTable
--? @result Void
function Squad_GiveSlotItemsFromTable(squadid, itemTable)
	
	for i = 1, table.getn(itemTable) do
		
		Squad_GiveSlotItem(squadid, itemTable[i])
		
	end
	
end

--? @shortdesc Returns a position relative to a squad's current position and orientation. see ScarUtil.scar for explanation of 'offset' parameter.
--? @args SquadID squad, Integer offset, Real distance
--? @result Position
function Squad_GetOffsetPosition(squad, offset, distance)
	return World_GetOffsetPosition(Squad_GetPosition(squad), Squad_GetHeading(squad), offset, distance)
end

--? @shortdesc Returns whether ANY entity in the squad is camouflaged
--? @args SquadID squad
--? @result Boolean
function Squad_IsCamouflaged(squad)

	for i = 1, Squad_Count(squad) do
		local entity = Squad_EntityAt(squad, i - 1)
		if Entity_IsCamouflaged(entity) then
			return true
		end
	end
	
	return false

end

--? @shortdesc Set animation state of a state machine for a squad Please only use this for simple animations
--? @args SquadID squadid, String stateMachineName, String stateName
--? @result Void
function Squad_SetAnimatorState(squadid, stateMachineName, stateName)
	for n = 1, Squad_Count(squadid) do
		local eid = Squad_EntityAt(squadid, n-1)
		if (Entity_IsSyncWeapon(eid) == false) then
			Entity_SetAnimatorState(eid, stateMachineName, stateName)
		end
	end
end




--? @shortdesc Test whether a squad can be ordered to do this ability on any member of the target SGroup
--? @args SquadID caster, AbilityBlueprint ability, SGroup target_sgroup
function Squad_CanCastAbilityOnSGroup(caster, ability, target_sgroup)
	local _CheckSquad = function(gid, idx, sid)
		return Squad_CanCastAbilityOnSquad(caster, ability, sid)
	end
	return SGroup_ForEachAllOrAny(target_sgroup, ANY, _CheckSquad)
end

--? @shortdesc Test whether a squad can be ordered to do this ability on any member of the target EGroup
--? @args SquadID caster, AbilityBlueprint ability, EGroup target_egroup
function Squad_CanCastAbilityOnEGroup(caster, ability, target_egroup)
	local _CheckEntity = function(gid, idx, eid)
		return Squad_CanCastAbilityOnEntity(caster, ability, eid)
	end
	return EGroup_ForEachAllOrAny(target_egroup, ANY, _CheckEntity)
end