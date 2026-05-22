----------------------------------------------------------------------------------------------------------------
-- Timer helper functions
-- (c) 2003 Relic Entertainment Inc.



----------------------------------------------------------------------------------------------------------------
-- Private data

function Timer_Init()	
	_TimerTable = {}
	TIMER_PAUSED = -1
end
Scar_AddInit( Timer_Init )




----------------------------------------------------------------------------------------------------------------
-- Functions

function Timer_Validate(id, number, bCheckExistance, caller)

	if id == nil or scartype( id ) == nil then
		fatal( caller .. ": id cannot be nil" )
	end
	
	if bCheckExistance == true and _TimerTable[id] == nil then
		fatal( caller .. ": Specified timerID (" .. id .. ") doesn't exist" )
	end
	
	if number ~= nil and scartype( number ) ~= ST_NUMBER then
		fatal( caller .. ": period has to be a number" )
	end

	if (_TimerTable[id] ~= nil and _TimerTable[id].elapsedTimeBeforePause == nil) then
		_TimerTable[id].elapsedTimeBeforePause = 0
	end

end

--? @group scardoc;Timer

--? @shortdesc Start a timer with the specified id, taking the required period ( in seconds )
--? @args Integer timerID, Real period
--? @result Void
function Timer_Start(id, period)
	
	Timer_Validate(id, period, false, "Timer_Start")
	
	_TimerTable[id] = {length = period, timeremaining = period, starttime = World_GetGameTime(), elapsedTimeBeforePause = 0}
end

--? @shortdesc Returns whether the timer with this ID exists
--? @args Integer timerID
--? @result Boolean
function Timer_Exists(id)

	return (_TimerTable[id] ~= nil)
	
end

--? @shortdesc Add the amount of time to the specified timer
--? @args Integer timerID, Real period
--? @result Void
function Timer_Add(id, period)

	Timer_Validate(id, period, false, "Timer_Add")
	
	_TimerTable[id].length = _TimerTable[id].length + period
end	

--? @shortdesc Advances the timer by the specified amount of time
--? @args Integer timerID, Real period
--? @result Void
function Timer_Advance(id, period)

	Timer_Validate(id, period, "Timer_Advance")
	
	_TimerTable[id].starttime = _TimerTable[id].starttime - period
end

--? @shortdesc Pause the specified timer.
--? @args Integer timerID
--? @result Void
function Timer_Pause(id)

	Timer_Validate(id, nil, false, "Timer_Pause")
	
	if (_TimerTable[id].starttime ~= TIMER_PAUSED)  then		-- check the timer isn't already paused
		-- work out how much of the timer is remaining
		_TimerTable[id].timeremaining = math.max(0, _TimerTable[id].length - (World_GetGameTime() - _TimerTable[id].starttime))
		
		_TimerTable[id].elapsedTimeBeforePause = _TimerTable[id].elapsedTimeBeforePause + math.max(0, _TimerTable[id].length - _TimerTable[id].timeremaining)
		
		_TimerTable[id].length = _TimerTable[id].timeremaining;	-- set the timer to have this much time left when it resumes
		_TimerTable[id].starttime = TIMER_PAUSED				-- mark the timer as paused
		
	end
end

--? @shortdesc Check if the timer is paused.
--? @args Integer timerID
--? @result Boolean
function Timer_IsPaused(id) 

	if ( scartype( id ) == nil ) then
		fatal( "Timer_GetRemaining: id cannot be nil" )
	end
	
	local isPaused = false
	
	if _TimerTable[id].starttime == TIMER_PAUSED then
		isPaused = true
	end
	
	return isPaused

end 

--? @shortdesc Get the remaining time for the specified timer.
--? @args Integer timerID
--? @result Real
function Timer_GetRemaining(id) 

	if ( scartype( id ) == nil ) then
		fatal( "Timer_GetRemaining: id cannot be nil" )
	end
	
	if (_TimerTable[id] == nil) then
		return 0
	end
	
	if (_TimerTable[id].starttime ~= TIMER_PAUSED) then
		_TimerTable[id].timeremaining = math.max(0, _TimerTable[id].length - (World_GetGameTime() - _TimerTable[id].starttime))
	end
	
	return _TimerTable[id].timeremaining
end 

--? @shortdesc Returns how much time has elapsed since this timer has been started
--? @args Integer timerID
--? @result Real
function Timer_GetElapsed(id)
	Timer_Validate(id, nil, false, "Timer_GetElapsed")

	return _TimerTable[id].length - Timer_GetRemaining(id) + _TimerTable[id].elapsedTimeBeforePause
end

--? @shortdesc Returns TWO values: minutes and seconds. Provide it a function like Timer_GetRemaining or Timer_GetElapsed
--? @args Luafunction getTimeFunction, Integer TimerID
--? @results Real minutes, Real seconds
function Timer_GetMinutesAndSeconds(func, id)

	local seconds = func(id)
	local minutes = math.floor(seconds / 60)
	seconds = math.floor(math.mod(seconds, 60))
	
	return minutes, seconds
	
end

--? @shortdesc Resume the specified timer.
--? @args Integer timerID
--? @result Void
function Timer_Resume(id)

	Timer_Validate(id, nil, false, "Timer_Resume")
	
	if (_TimerTable[id].starttime == TIMER_PAUSED) then			-- check the timer is paused
		_TimerTable[id].starttime = World_GetGameTime()			-- resume the timer (set new start time, remaining time was already reduced when the timer was paused)
	end
end


--? @shortdesc Display (in the console) the amount of time remaining in the specified timer.
--? @args Integer timerID
--? @result Void
function Timer_Display(id)

	if ( scartype( id ) == nil ) then
		fatal( "Timer_Display: id cannot be nil" )
	end
	
	if (_TimerTable[id] ~= nil) then								-- check the timer exists
		if (_TimerTable[id].starttime ~= TIMER_PAUSED) then			-- update the timer if it isn't paused
			_TimerTable[id].timeremaining = math.max(0, _TimerTable[id].length - (World_GetGameTime() - _TimerTable[id].starttime))
		end
		
		local minutes = math.floor(_TimerTable[id].timeremaining / 60)
		local seconds = math.floor(math.mod(_TimerTable[id].timeremaining, 60))
		if (seconds < 10) then
			seconds = "0"..seconds
		end
		
		if (_TimerTable[id].starttime == TIMER_PAUSED) then
			print("Timer "..id.." (PAUSED) - "..minutes..":"..seconds)
		else
			print("Timer "..id.." - "..minutes..":"..seconds)
		end
	end
end


--? @shortdesc Stop the specified timer.
--? @args Integer timerID
--? @result Void
function Timer_End(id)

	if ( scartype( id ) == nil ) then
		fatal( "Timer_End: id cannot be nil" )
	end
	
	_TimerTable[id]=nil
end


--? @shortdesc Displays a timer on the screen - You need to call this regularly (i.e. every second) to update the onscreen display. THIS IS A TEMPORARY FUNCTION - WELL GET PROPER UI SUPPORT LATER ON
--? @args Integer timerID
--? @result Void
function Timer_DisplayOnScreen(id)

	if ( scartype( id ) == nil ) then
		fatal( "Timer_DisplayOnScreen: id cannot be nil" )
	end
	
	if (_TimerTable[id] ~= nil) then								-- check the timer exists
		if (_TimerTable[id].starttime ~= TIMER_PAUSED) then			-- update the timer if it isn't paused
			_TimerTable[id].timeremaining = math.max(0, _TimerTable[id].length - (World_GetGameTime() - _TimerTable[id].starttime))
		end
		
		dr_clear("timertext")
		dr_setautoclear("timertext", 0)
		
		local minutes = math.floor(_TimerTable[id].timeremaining / 60)
		local seconds = math.floor(math.mod(_TimerTable[id].timeremaining, 60))
		if (seconds < 10) then
			seconds = "0"..seconds
		end
		
		local timestring = minutes..":"..seconds
		
		if (_TimerTable[id].starttime == TIMER_PAUSED) then
			timestring = timestring.." (PAUSED)"
		end
		
		dr_text2d("timertext", 0.1, 0.6, timestring, 126, 213, 126)
	end
end
