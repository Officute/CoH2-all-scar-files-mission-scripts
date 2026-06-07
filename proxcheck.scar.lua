--[[-------------------------------------------------------------------
***********************************************************************

-- WARNING: This system and its functionality has been deprecated.
-- Use Event_Proximity() (Scar/Events.scar) instead.

***********************************************************************
---------------------------------------------------------------------]]




--[[    Proximity Checker    ]]
function __ProxCheck_Init()
	print("*WARNING*: Using deprecated ProxCheck.scar")
	_proxChecks = {}
	_proxChecks.nextCheckID = 1
end
Scar_AddInit(__ProxCheck_Init)

--? @shortdesc [DEPRECATED. Use Event_Proximity() instead.] Add a proximity check.
--? @extdesc Checks if ANY or ALL the units in the element are within range of the location. If location is a CIRCLE marker, default range will be max(radius, 5)
--? @result checkID
--? @args PlayerID/SGroup element, EGroup/SGroup/Pos/MarkerID location, Boolean all, Real range, LuaFunction callback, Int delay
function Util_AddProxCheck(element, location, all, range, callback, delay)
	print("*WARNING*: Using deprecated Util_AddProxCheck()")
	--Validate element. Has to be either player or SGroup
	if(not(scartype(element) == ST_PLAYER or scartype(element) == ST_SGROUP)) then
		fatal("Util_AddProxCheck: Invalid element type (" .. scartype_tostring(element) ..")")
	end
	
	--Validate location. Can be EGroup/SGroup/Position/Marker
	--TODO: handle Squad as well? Depends on Util_GetPos, but might screw up when element=PlayerId
	if(not(scartype(location) == ST_EGROUP or scartype(location) == ST_SGROUP or scartype(location) == ST_SCARPOS or scartype(location) == ST_MARKER)) then
		fatal("Util_AddProxCheck: Invalid location type (" .. scartype_tostring(location) ..")")
	end
	
	--Create check object
	local check = {}
	check.element = element
	check.location = location
	check.all = all or ANY
	check.range = range
	check.callback = callback
	check.delay = delay or 0
	check.checkID = _proxChecks.nextCheckID
	
	_proxChecks.nextCheckID = _proxChecks.nextCheckID + 1
	
	if(check.range == nil and scartype(check.location) == ST_MARKER and Marker_GetProximityType(check.location) == PT_Circle) then
		check.range = math.max(Marker_GetProximityRadius(check.location), 5)
	end
	
	--Add object to list of proxchecks
	table.insert(_proxChecks, check)
	
	--Start the proxChecker if it's not currently running
	if(not Rule_Exists(_ProxChecker)) then
		Rule_AddInterval(_ProxChecker, 2)
	end
	
	return check.checkID
end

--? @shortdesc [DEPRECATED. DO NOT USE.] Remove proximity checks assigned to a location. 
--? @extdesc Removes all proximity checks associated with the defined location.
--? @result Void
--? @args EGroup/SGroup/Pos/MarkerID location
function Util_RemoveProxCheck(location)
	if(not(scartype(location) == ST_EGROUP or scartype(location) == ST_SGROUP or scartype(location) == ST_SCARPOS or scartype(location) == ST_MARKER)) then
		fatal("Util_RemoveProxCheck: Invalid location type (" .. scartype_tostring(location) ..")")
	end

	for i=#_proxChecks, 1, -1 do
		local check = _proxChecks[i]
		if(check.location == location) then
			table.remove(_proxChecks, i)
		end
	end
end

--? @shortdesc [DEPRECATED. DO NOT USE.] Remove a specific proximity check based on its ID.
--? @result Void
--? @args Integer checkID
function Util_RemoveProxCheckByID(checkID)
	if(not scartype(checkID) == ST_NUMBER) then
		fatal("Util_RemoveProxCheckByID: Invalid checkID type (" .. scartype_tostring(checkID) ..")")
	end
	
	for i=#_proxChecks, 1, -1 do
		local check = _proxChecks[i]
		if(check.checkID == checkID) then
			table.remove(_proxChecks, i)
		end
	end
end


--? @shortdesc [DEPRECATED. DO NOT USE.] Removes all existing proximity checks.
--? @extdesc Clears the list of prox checks that are currently active and shis down the procChecker.
--? @result Void
function Util_ClearProxChecks()
	local lastID = _proxChecks.nextCheckID
	_proxChecks = {}
	_proxChecks.nextCheckID = lastID
	Rule_Remove(_ProxChecker)
end

function _ProxChecker()
	for i=#_proxChecks, 1, -1 do
		local check = _proxChecks[i]
		--TODO: Modify to accept diff. location types
		if(scartype(check.element) == ST_PLAYER) then
			local nearMarker = SGroup_CreateIfNotFound("nearMarker")
			Player_GetAllSquadsNearMarker(check.element, nearMarker, check.location, check.range)
			if(SGroup_CountSpawned(nearMarker) > 0) then
				Rule_Remove(check.callback)
				Rule_AddOneShot(check.callback, check.delay)
				table.remove(_proxChecks, i)
			end
		elseif(scartype(check.element) == ST_SGROUP) then
			if(SGroup_GetAvgHealth(check.element) == 0) then
				--remove if sgroup dead.
				table.remove(_proxChecks, i)
			elseif(_Prox_AreSquadsNearPosition(check.element, Util_GetPosition(check.location), check.range, check.all)) then
				Rule_Remove(check.callback)
				Rule_AddOneShot(check.callback, check.delay)
				table.remove(_proxChecks, i)
			end
		end
	end
	
	if(#_proxChecks == 0) then
		Rule_RemoveMe()
	end
end
