----------------------------------------------------------------------------------------------------------------
-- Entity helper functions
-- (c) 2003 Relic Entertainment Inc.

--? @group scardoc;Entity

--? @shortdesc Returns true if entity is in cover.
--? @args EntityID entityId
--? @result Boolean
function Entity_IsInCover( entityId )
	return (Entity_GetCoverType( entityId ) ~= CT_None)
end

--? @shortdesc Set invulnerability on the entity. Reset time is in seconds. If it it set, the invulnerability will expire after this time.
--? @args EntityID entity, Bool enable, Float reset_time
--? @result Void
function Entity_SetInvulnerable(squad, enable, reset_time)

	local cap
	if ( enable == true ) then
		cap = 1.0
	elseif (enable == false) then
		cap = 0.0
	else
		cap = enable
	end

	Entity_SetInvulnerableMinCap( squad, cap, reset_time )
end

--? @shortdesc Check if the entity is invulnerable or not
--? @args SquadID squad
--? @result Bool
function Entity_GetInvulnerable(entity)

	return ( Entity_GetInvulnerableMinCap( entity ) == 1.0 )
end

function __EntityDemolitionCallback(entity)

	-- call all callbacks matching this entity
	if __t_EntityDemolitionCallbacks ~= nil then
		for k, v in pairs(__t_EntityDemolitionCallbacks) do
			if Entity_IsValid(v.entityID) and v.entityID == Entity_GetGameID(entity) then
				v.func(entity)
			end
		end
	end
	
end

function Entity_ClearDemolitionCallbacks()
	__t_EntityDemolitionCallbacks = nil
end

--? @shortdesc Calls a function when an entity gets destroyed by the player clicking the "Detonate me" button next to an entity.
--? @args Entity entity, LuaFunction function
--? @result Void
function Entity_NotifyOnPlayerDemolition(entity, f)

	if __t_EntityDemolitionCallbacks == nil then
		__t_EntityDemolitionCallbacks = {}
	end
	
	table.insert(__t_EntityDemolitionCallbacks, { entityID = Entity_GetGameID(entity), func = f } )
end

--? @shortdesc Returns a position relative to an entity's current position and orientation. see ScarUtil.scar for explanation of 'offset' parameter.
--? @args EntityID entity, Integer offset, Real distance
--? @result Position
function Entity_GetOffsetPosition(entity, offset, distance)
	return World_GetOffsetPosition(Entity_GetPosition(entity), Entity_GetHeading(entity), offset, distance)
end


