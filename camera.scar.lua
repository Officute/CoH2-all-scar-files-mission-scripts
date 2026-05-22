----------------------------------------------------------------------------------------------------------------
-- Camera helper functions
-- (c) 2003 Relic Entertainment Inc.
-- Updated: 2011 - Ryan

--? @group scardoc;Camera

----------------------------------------------------------------------------------------------------------------
 
function _Camera_Init()
	-- put camera init code here...
end

Scar_AddInit(_Camera_Init)

SLOW_CAMERA_PANNING = 0.5

--? @shortdesc Move the camera to an entity/marker/pos/egroup/sgroup/squad
--? @extdesc This function canNOT be called through a CTRL object in NISlets.
--? @args Variable var[, Boolean pan, Float panRate, Boolean keepInputLocked, Boolean resetToDefault]
--? @result Void
function Camera_MoveTo(pos, pan, panRate, keepLocked, resetToDefault)
	
	-- if we were passed in a marker, convert it to a pos
	if scartype(pos) ~= ST_SCARPOS then
		pos = Util_GetPosition(pos)
	end
	-- get the nearest position the camera can move to
	pos = World_GetNearestInteractablePoint(pos)
	
	if keepLocked == nil then keepLocked = false end
	_MoveToPosition_KeepLocked = keepLocked
	if resetToDefault == true then 
		Camera_ResetToDefault()
	else
		resetToDefault = false
	end
	
	if (pan == nil) then pan = false end

	-- attempt to prevent multiple calls
	Camera_SetInputEnabled(false)
	
	if Rule_Exists(_MoveToPosition_CamLock) == false then Rule_Add(_MoveToPosition_CamLock) end

	_MoveToPosition_camLock = true
	_MoveToPosition_position = pos
	
	-- track the camera position in case we get stuck
	_MoveToPosition_lastPosition = Camera_GetCurrentTargetPos()
	_MoveToPosition_lastTime = World_GetGameTime()
	
	-- shift the camera
	Camera_FocusOnPosition(pos, pan)
	
	if pan == true and panRate ~= nil then
		Camera_SetSlideTargetRate(panRate)
	end
end

function _MoveToPosition_CamLock()

	if _MoveToPosition_camLock == true then
		if _MoveToPosition_position == nil or Misc_IsPosOnScreen(_MoveToPosition_position, 0.16) or ((World_GetGameTime() - _MoveToPosition_lastTime) > 0 and World_DistancePointToPoint(_MoveToPosition_lastPosition, Camera_GetCurrentTargetPos()) < 0.0125) then
			-- don't interfere with camera input during letterbox (it will handle re-enabling it at the right time) -- attempt to prevent multiple calls
			if Game_IsLetterboxed() == false and _MoveToPosition_KeepLocked ~= true then
				Camera_SetInputEnabled(true)
			end
			_MoveToPosition_KeepLocked = nil
			_MoveToPosition_position = nil
			_MoveToPosition_camLock = false
			Rule_RemoveMe()
		else
			_MoveToPosition_lastPosition = Camera_GetCurrentTargetPos()
			_MoveToPosition_lastTime = World_GetGameTime()
		end
	else
		Rule_RemoveMe() -- shouldn't happen
	end
end

--? @shortdesc Slightly refocus the camera to rest on an entity/squad/squad/sgroup/egroup/pos/marker if it's close by.
--? @extdesc This function can be called through a CTRL object in NISlets.
--? @args Variable var
--? @result Void
function Camera_MoveToIfClose(pos)
	
	-- if we were passed in a marker, convert it to a pos
	if scartype(pos) ~= ST_SCARPOS then
		pos = Util_GetPosition(pos)
	end
	
	-- work out how close we are to the position already
	local dist = World_DistancePointToPoint(Camera_GetTargetPos(), pos)
	
	-- shift the camera is it's within our range
	if dist > 5 and dist < 20 then
		
		Camera_FocusOnPosition(pos, true)
		Camera_SetSlideTargetRate(SLOW_CAMERA_PANNING)
		
	end
	
end

--? @shortdesc Set the camera to follow an sgroup/squad/egroup/entity.
--? @extdesc The camera will follow them until the player takes control again.
--? @args Variable var
--? @result Void
function Camera_Follow(var)
	
	if scartype(var) == ST_SGROUP then
		if (SGroup_CountSpawned(var) >= 1) then
			Camera_FollowSquad(SGroup_GetSpawnedSquadAt(var, 1))
		end
	elseif scartype(var) == ST_EGROUP then
		if (EGroup_CountSpawned(var) >= 1) then
			Camera_FollowEntity(EGroup_GetSpawnedEntityAt(var, 1))
		end
	elseif scartype(var) == ST_SQUAD then
		Camera_FollowSquad(var)
	elseif scartype(var) == ST_ENTITY then
		Camera_FollowEntity(var)
	else
		fatal("Camera_Follow variable is not a valid EGroup/SGroup/Squad/Entity")
	end
	
end

--? @shortdesc Helper function to set the default camera parameters
--? @extdesc If the parameter is nil, the particular property is not modified
--? @result Void
--? @args Float height, Float declination, Float angle
function Camera_SetDefault( height, declination, angle )
	if ( height ~= nil and scartype(height) == ST_NUMBER ) then
		Camera_SetTuningValue( TV_DefaultHeight, height )
	end

	if ( declination ~= nil and scartype(declination) == ST_NUMBER ) then
		Camera_SetTuningValue( TV_DefaultDeclination, declination )
	end

	if ( angle ~= nil and scartype(angle) == ST_NUMBER ) then
		Camera_SetTuningValue( TV_DefaultAngle, (angle ) )
	end
	
	Game_RemoveGameRestoreCallback(Camera_SetDefault)
	Game_SetGameRestoreCallback(Camera_SetDefault, height, declination, angle)
end

--? @shortdesc Moves the camera through a list of positions.
--? @result Void
--? @args Table list[, Boolean pan, Float panRate, ScarFn callback]
function Camera_CyclePositions(list, pan, panRate, callback)
	
	if(scartype(list) == ST_TABLE and #list > 0) then
		__cycleData = {
			["list"] = list,
			["pan"] = pan or false,
			["panRate"] = panRate or 1.0,
			["callback"] = callback,
		}			
			
		Camera_MoveTo(list[1], pan, panRate)
		Rule_AddDelayedInterval(_CamCycle_Check, 2, 1)
	else
		__cycleData = nil
		if(callback) then callback() end
	end
end

function _CamCycle_Check()
	local pos = __cycleData.list[1]
	if(Misc_IsPosOnScreen(Util_GetPosition(pos), 0.25)) then
		Rule_RemoveMe()
		table.remove(__cycleData.list, 1)
		Camera_CyclePositions(__cycleData.list, __cycleData.pan, __cycleData.panRate, __cycleData.callback)
	end
end
