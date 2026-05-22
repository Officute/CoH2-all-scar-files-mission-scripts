
function __Event_Init()
	__Event_eventTable = {}
	__Event_eventsToAdd = {}
	__Event_eventCounter = 0
	__Event_timerCounter = 0
end

Scar_AddInit(__Event_Init)

--? @group scardoc;Event System

-----------------------------------------------------------

--? @shortdesc Callback helper function for Intel events, name of intel parameter is intel
--? @extdesc Invokes Util_StartIntel on your data.intel EVENTS function
--? @extdesc Example usage: Event_*(EventHandler_StartIntel, {intel = EVENTS.Speech01}, ...
--? @args Table data
function EventHandler_StartIntel(data)
	if data.intel_callback ~= nil then
		Util_StartIntel(data.intel_callback)
	elseif data.intel ~= nil then	
		Util_StartIntel(data.intel)
	end
end

--? @shortdesc Callback helper function for Intel Nislet events, name of intel parameter is intel
--? @extdesc Invokes Util_StartNislet on your data.intel EVENTS function
--? @extdesc Example usage: Event_*(EventHandler_StartIntel, {intel = EVENTS.Nislet01}, ...
--? @args Table data
function EventHandler_StartNislet(data)
	if data.intel_callback ~= nil then
		Util_StartNislet(data.intel_callback, data.skipCallback)
	elseif data.intel ~= nil then	
		Util_StartNislet(data.intel, data.skipCallback)
	end
end

--? @shortdesc Callback helper function that causes the input group to retreat, name of parameters: group, location, deleteAtMarker, queued
--? @extdesc Invokes Cmd_Retreat on data.group, with optional parameters data.location, data.deleteAtMarker, and data.queued
--? @extdesc Example usage: Event_*(EventHandler_Retreat, {group = sg_group, location = mkr_option, deleteAtMarker = true, queued = false}, ...
--? @args Table data
function EventHandler_Retreat(data)
	if data.deleteAtMarker == nil then
		data.deleteAtMarker = true
	end
	
	Cmd_Retreat(data.group, data.location, data.deleteAtMarker, data.queued)
end

--? @shortdesc Callback helper function that causes the input group to retreat, name of parameters: group, location, maxTries
--? @extdesc Invokes Cmd_StaggeredRetreat on data.group, with optional parameters data.location, and datamaxTries
--? @extdesc Example usage: Event_*(EventHandler_Retreat, {group = sg_group, location = mkr_option, maxTries = 8}, ...
--? @args Table data
function EventHandler_StaggeredRetreat(data)
	local loc = data.location
	if scartype(data.location) == ST_MARKER then
		loc = {data.location}
	end
	
	Cmd_StaggeredRetreat(data.group, loc, data.maxTries)
end

--? @shortdesc Callback helper function that removes objective UI elements, name of parameters: objective, element
--? @extdesc Invokes Objective_RemoveUIElements on data.objective and data.element
--? @extdesc Example usage: Event_*(Objective_RemoveUIElements, {element = elementID, objective = objectiveID}, ...
--? @args Table data, 
function EventHandler_RemoveObjectiveUI(data)
	Objective_RemoveUIElements(data.objective, data.element)
end

--? @shortdesc Callback helper function for removing in-game hints. Name of hintpointID parameter is 'hint'. Can receive a table of ID's.
--? @extdesc Invokes HintPoint_Remove on data.hint.
--? @extdesc Example usage: Event_*(EventHandler_RemoveHint, {hint = hp_hintPointID}, ...
--? @args Table data
function EventHandler_RemoveHint(data)
	if scartype(data.hint) ~= ST_TABLE then
		data.hint = {data.hint}
	end
	
	for k,hpid in pairs(data.hint) do
		if scartype(hpid) == ST_NUMBER then
			HintPoint_Remove(hpid)
		else
			fatal("Invalid HintPoint ID. Expected Integer, received " .. scartype_tostring(hpid))
		end
	end
end

--? @shortdesc Callback helper function for removing UI flashing. Name of ID parameter is flashID
--? @extdesc Invokes UI_StopFlashing on data.flashID
--? @extdesc Example usage: Event_*(EventHandler_StopFlashing, {flashID = myFlashID}, ...
--? @args Table data
function EventHandler_StopFlashing(data)
	if(data.flashID ~= nil) then
		UI_StopFlashing(data.flashID)
	end
end

--? @shortdesc Callback helper function for removing in minimap blips, name of blipID parameter is blip
--? @extdesc Invokes UI_DeleteMinimapBlip on data.blip
--? @extdesc Example usage: Event_*(EventHandler_RemoveMinimapBlip, {blip = blipID}, ...
--? @args Table data
function EventHandler_RemoveMinimapBlip(data)
	if data.blip ~= nil then
		UI_DeleteMinimapBlip(data.blip)
	end
end

--? @shortdesc Callback helper function for starting an objective, name of objective parameter is objective, additional parameters: Bool showTitle, Bool skipIntel
--? @extdesc Invokes Objective_Start on data.objective 
--? @extdesc Example usage: Event_*(EventHandler_ObjectiveStart, {objective = objectiveID, showTitle = true, skipIntel = true}, ...
--? @args Table data
function EventHandler_ObjectiveStart(data)
	if data.objective ~= nil then
		Objective_Start(data.objective, data.showTitle, data.skipIntel)
	end
end

--? @shortdesc Callback helper function for completing an objective. Received parameters: Table objective, Bool showTitle, Bool skipIntel
--? @extdesc Invokes Objective_Complete on data.objective 
--? @extdesc Example usage: Event_*(EventHandler_ObjectiveComplete, {objective = objectiveID}, ...
--? @args Table data
function EventHandler_ObjectiveComplete(data)
	if data.objective ~= nil then
		Objective_Complete(data.objective, data.showTitle, data.skipIntel)
	end
end

--? @shortdesc Callback helper function for assigning a goal to an Encounter. Name of parameters: 'goalData', 'encounter'.
--? @extdesc Invokes Encounter:SetGoal() on data.goalData
--? @extdesc Example usage: Event_*(EventHandler_AssignEncounterGoal, {encounter = myEncounter, goalData = myGoalData}, ...
--? @args Table data
function EventHandler_AssignEncounterGoal(data)
	if data.encounter:IsAlive() then
		data.encounter:SetGoal(data.goalData)
	end
end

--? @shortdesc Callback helper function for adding unitse an Encounter. Name of parameters: 'units'.
--? @extdesc Invokes Encounter:AddUnit() for each item in data.units
--? @extdesc Example usage: Event_*(EventHandler_AddEncounterUnits, {units = {<unitDataTable>, <unitDataTable2>}}, ...)
--? @args Table data
function EventHandler_AddEncounterUnits(data)
	for k,v in pairs(data.units) do
		data.encounter:AddUnit(v)
	end
end

--? @shortdesc Callback helper function for triggering an Encounter goal. Name of parameters: 'encounter'.
--? @extdesc Invokes Encounter:TriggerGoal() for data.encounter
--? @extdesc Example usage: Event_*(EventHandler_TriggerEncounterGoal, {encounter = <myEncounter>}, ...)
--? @args Table data
function EventHandler_TriggerEncounterGoal(data)
	data.encounter:TriggerGoal()
end


-----------------------------------------------------------

-- Creates event that invokes *callback* with arg value *data*, *delay* seconds after *precondition* is true
function Event_Add(precondition, callback, data, delay)
	assert(scartype(precondition) == ST_FUNCTION, "Expect precondition to be function in Event_Add")
	assert(scartype(callback) == ST_FUNCTION, "Expect callback to be function in Event_Add")
	assert(scartype(delay) == ST_NIL or scartype(delay) == ST_NUMBER, "Expected valid delay; nil or positive number")
	
	if (delay ~= nil and delay <= 0) then
		delay = nil
	end
	
	local newID = __Event_eventCounter
	if (data.__eventID)then
		newID = data.__eventID
	end
	
	local newEvent = 
	{
		eventID = newID,
		precondition = precondition,
		preconditionName = "<RTM - n/a>",
		callback = callback,
		callbackName = "<RTM - n/a>",
		data = data,
		delay = delay,
	}
	
	if not Game_IsRTM() then
		newEvent.preconditionName = string.gsub(debug.getinfo(precondition).name, "__Event_", "", 1) or "<unknown>"
		newEvent.callbackName = debug.getinfo(callback).name or "<unknown>"
	end
	
	if (data.__eventID == nil)then
		__Event_eventCounter = __Event_eventCounter + 1
		data.__eventID = newID
	end
	table.insert(__Event_eventsToAdd, newEvent)	
	
	if Rule_Exists(__Event_eventChecker) == false then
		Rule_Add(__Event_eventChecker)
	end
	
	return newEvent.eventID
end

function __Event_eventChecker()
	for k=table.getn(__Event_eventsToAdd), 1, -1 do 
		table.insert(__Event_eventTable, __Event_eventsToAdd[k])
	end
	__Event_eventsToAdd = {}

	if table.getn(__Event_eventTable) > 0 then	
		for k=table.getn(__Event_eventTable), 1, -1 do 
			event = __Event_eventTable[k]
			
			if event.remove == true then
				table.remove(__Event_eventTable, k) -- flagged for delete
			elseif event.precondition(event.data) == true then
				if event.delay == nil then
					event.callback(event.data)
				else
					event.data.__eventID = event.eventID
					Event_Timer(event.callback, event.data, event.delay)
				end
				
				_AnnounceEventTriggered(k)
				table.remove(__Event_eventTable, k)
			end
		end 
	else
		Rule_Remove(__Event_eventChecker)
	end
end



--? @shortdesc Creates a Callback Event that triggers when ANY of the specified events are triggered.
--? @extdesc Original events are removed.
--? @args Function callback, Table data, Table events, [Float delay]
--? @result EventID
function Event_CreateOR(callback, data, events, delay)
	data = data or {}
	data.preconditions = {}
	
	for k,eventID in pairs(events) do
		local event = Event_GetEvent(eventID)
		local precon = {
			precondition = event.precondition,
			data = event.data,
			preconditionName = event.preconditionName,
		}
		table.insert(data.preconditions, precon)
		
		Event_Remove(eventID)
	end
	
	return Event_Add(__Event_OR_Check, callback, data, delay)
end

function __Event_OR_Check(data)
	for k,check in pairs(data.preconditions) do
		if(check.precondition(check.data)) then
			data._triggerData = check.data
			return true
		end
	end
	
	return false
end


--? @shortdesc Creates a Callback Event that triggers when ALL of the specified events are triggered.
--? @extdesc Original events are removed.
--? @args Function callback, Table data, Table events, [Float delay]
--? @result EventID
function Event_CreateAND(callback, data, events, delay)
	data = data or {}
	data.preconditions = {}
	
	for k,eventID in pairs(events) do
		local event = Event_GetEvent(eventID)
		local precon = {
			precondition = event.precondition,
			data = event.data,
			preconditionName = event.preconditionName,
		}
		table.insert(data.preconditions, precon)
		
		Event_Remove(eventID)
	end
	
	return Event_Add(__Event_AND_Check, callback, data, delay)
end

function __Event_AND_Check(data)
	for k,check in pairs(data.preconditions) do
		if(not check.precondition(check.data)) then
			return false
		end
	end
	return true
end



--? @shortdesc Callback given callback function with data, after a specified delay. 
--? @extdesc Delay can be a table containing two numbers and will randomly select a delay from between the two
--? @result EventID
--? @args Function callback, Table data, INT/Table delay
function Event_Timer(callback, data, delay)

	data = data or {} -- handle nil data
	data._timer = "_Event_Timer_id_"..__Event_timerCounter
	
	__Event_timerCounter = __Event_timerCounter + 1
	
	if scartype(delay) == ST_TABLE then
		local d1 = delay[1] * 10
		local d2 = delay[2] * 10
	
		if delay[1] < delay[2] then
			delay = World_GetRand(d1, d2)
		else		
			delay = World_GetRand(d2, d1)
		end
		
		delay = delay / 10
	end
	
	Timer_Start(data._timer, delay)
	
	return Event_Add(__Event_Timer_Check, callback, data) -- important: don't add delay here
end

function __Event_Timer_Check(data)
	return Timer_GetRemaining(data._timer) <= 0
end

--? @shortdesc Callback given callback function with data, when player has more than amount of resourceType. 
--? @extdesc Callback data parameter is augmented with: _player = PlayerID player, _resourceType = ResourceType resourceType, _amount = Int amount
--? @result EventID
--? @args Function callback, Table data, PlayerID player, ResourceType resourceType, Int amount, [Float delay]
function Event_PlayerResourceLevel(callback, data, player, resourceType, amount, delay)
	data = data or {}
	data._player = player
	data._resourceType = resourceType
	data._amount = amount
	
	return Event_Add(__Event_PlayerResourceLevel, callback, data, delay)
end

function __Event_PlayerResourceLevel(data) 
	data.currentAmount = Player_GetResource(data._player, data._resourceType)
	return data.currentAmount >= data._amount
end


--? @shortdesc Callback given callback function with data, when a team has a combined amount more than amount of resourceType. 
--? @extdesc Callback data parameter is augmented with: _team = TeamID team, _resourceType = ResourceType resourceType, _amount = Int amount
--? @result EventID
--? @args Function callback, Table data, TeamID team, ResourceType resourceType, Int amount, [Float delay]
function Event_TeamResourceLevel(callback, data, team, resourceType, amount, delay)
	data = data or {}
	data._team = team
	data._resourceType = resourceType
	data._amount = amount
	
	return Event_Add(__Event_TeamResourceLevel, callback, data, delay)
end

function __Event_TeamResourceLevel(data) 
	local total = 0
	for i = 1, table.getn(data._team) do
		total = (total + Player_GetResource(data._team[i], data._resourceType))
	end
	return total >= data._amount
end


--? @shortdesc Callback given callback function with data, when the given player can see the element. 
--? @extdesc Callback data parameter is augmented with: _player = PlayerID player, _elements = Table inputElements, _seenElements = Table allSeenElements
--? @result EventID
--? @args Function callback, Table data, PlayerID/TeamID player/team, SquadID/SGroupID/EntityID/EGroupID/Marker/Position Table element[, ANY/ALL all, Float delay]
function Event_PlayerCanSeeElement(callback, data, player, element, all, delay)
		
	data = data or {} -- handle nil data
	data._player = player
	data._elements = element
	data._all = all or all==nil and ALL
	data.seenElements = {}	
		
	if scartype(data._elements) ~= ST_TABLE then
		data._elements = {element}		
	end
	
	if (scartype(data._elements[1]) == ST_ENTITY) then
		local newList = {}
		for k,element in ipairs(data._elements) do
			table.insert(newList, Entity_GetGameID(element))
		end
		data._elements = newList
	end	
	 
	return Event_Add(__Event_PlayerCanSeeElement_Check, callback, data, delay)
end

function __Event_PlayerCanSeeElement_Check(data)
	data.seenElements = {}

	if table.getn(data._elements) < 1 then
		Event_Remove(data.__eventID)
		return false
	end
	
	for i = table.getn(data._elements), 1, -1 do	
		local isValid = true
		local element = data._elements[i]
		if (scartype(element) == ST_NUMBER) then
			if Entity_IsValid(element) then
				element = Entity_FromWorldID(element)
			else
				table.remove(data._elements, i)
				isValid = false
			end
		end
		if (isValid) then
			if Util_ElementCanSee(data._player, element, data._all) then
				table.insert(data.seenElements, element)
			end
		end
	end
	
	if data._all == ANY then
		if table.getn(data.seenElements) > 0 then
			return true
		end
	else
		if table.getn(data.seenElements) >= table.getn(data._elements) then
			data.seenElements = data._elements
			return true
		end
	end
	return false		
end


--? @shortdesc Callback given callback function with data, when the given team can see the element. 
--? @extdesc Callback data parameter is augmented with: _team = TeamID team, _elements = Table inputElements, _seenElements = Table allSeenElements
--? @result EventID
--? @args Function callback, Table data, TeamID team, SquadID/SGroupID/EntityID/EGroupID/Marker/Position Table element[, ANY/ALL all, Float delay]
function Event_TeamCanSeeElement(callback, data, team, element, all, delay)
	
	data = data or {} -- handle nil data
	data._team = team
	data._elements = element
	data._all = all or all==nil and ALL
	data.seenElements = {}	
	
	if scartype(data._elements) ~= ST_TABLE then
		data._elements = {element}		
	end
	
	return Event_Add(__Event_TeamCanSeeElement_Check, callback, data, delay)
end

function __Event_TeamCanSeeElement_Check(data)
	data.seenElements = {}
	
	for k,element in ipairs(data._elements) do
		if Util_ElementCanSee(data._team, element, data._all) then
			table.insert(data.seenElements, element)
		end
	end
	if data._all == ANY then
		if table.getn(data.seenElements) > 0 then
			return true
		end
	else
		if table.getn(data.seenElements) >= table.getn(data._elements) then
			data.seenElements = data._elements
			return true
		end
	end
	return false
		
end

--? @shortdesc Callback given callback function with data, when the given player can not see the element. 
--? @extdesc Callback data parameter is augmented with: _player = PlayerID player, _elements = Table inputElements, _seenElements = Table allSeenElements
--? @result EventID
--? @args Function callback, Table data, PlayerID player, SquadID/SGroupID/EntityID/EGroupID/Marker/Position Table element[, ANY/ALL all, Float delay]
function Event_PlayerCanNotSeeElement(callback, data, player, element, all, delay)
	
	data = data or {} -- handle nil data
	data._player = player
	data._elements = element
	data._all = all or all==nil and ALL
	data.seenElements = {}	
	
	if scartype(data._elements) ~= ST_TABLE then
		data._elements = {element}		
	end
	
	return Event_Add(__Event_PlayerCanNotSeeElement_Check, callback, data, delay)
end

function __Event_PlayerCanNotSeeElement_Check(data)
	data.unSeenElements = {}
	for k,element in ipairs(data._elements) do
		if Util_ElementCanSee(data._player, element, data._all) == false then
			table.insert(data.unSeenElements, element)
		end
	end
	if data._all == ANY then
		if table.getn(data.unSeenElements) > 0 then
			return true
		end
	else
		if table.getn(data.unSeenElements) >= table.getn(data._elements) then
			data.unSeenElements = data._elements
			return true
		end
	end
	return false	
end

--? @shortdesc Callback given callback function with data, when the given team can not see the element. 
--? @extdesc Callback data parameter is augmented with: _team = TeamID team, _elements = Table inputElements, _seenElements = Table allSeenElements
--? @result EventID
--? @args Function callback, Table data, TeamID team, SquadID/SGroupID/EntityID/EGroupID/Marker/Position Table element[, ANY/ALL all, Float delay]
function Event_TeamCanNotSeeElement(callback, data, team, element, all, delay)
	
	data = data or {} -- handle nil data
	data._team = team
	data._elements = element
	data._all = all or all==nil and ALL
	data.seenElements = {}	
	
	if scartype(data._elements) ~= ST_TABLE then
		data._elements = {element}		
	end
	
	return Event_Add(__Event_TeamCanNotSeeElement_Check, callback, data, delay)
end

function __Event_TeamCanNotSeeElement_Check(data)
	data.unSeenElements = {}
	for k,element in ipairs(data._elements) do
		if Util_ElementCanSee(data._team, element, data._all) == false then
			table.insert(data.unSeenElements, element)
		end
	end
	if data._all == ANY then
		if table.getn(data.unSeenElements) > 0 then
			return true
		end
	else
		if table.getn(data.unSeenElements) >= table.getn(data._elements) then
			data.unSeenElements = data._elements
			return true
		end
	end
	return false	
end


--? @shortdesc Callback given callback function with data, when the given squad/entity/position is on screen. 
--? @extdesc NOT DETERMINISM SAFE for multiplayer or coop.
--? @extdesc Callback data parameter is agumented with: _player = PlayerID player, _element = SGroup/EGroup element
--? @result EventID
--? @args Function callback, Table data, PlayerID player, Marker/Pos/SGroup/EGroup element, [ANY/ALL all, Float percent, bool canSee, Float delay]
function Event_ElementOnScreen(callback, data, player, element, all, percent, canSee, delay)

	if (not Table_Contains({ST_MARKER, ST_SCARPOS, ST_SGROUP, ST_EGROUP}, scartype(element))) then
		fatal("Invalid element type (".. scartype_tostring(element) ..").")
	end

	data = data or {} -- handle nil data
	data._player = player
	data._element = element
	data._percent = percent or 0.8
	data._all = all or all==nil and ALL
	
	data._playerCanSee = canSee
	
	if scartype(canSee) == ST_NUMBER then
		data._playerCanSee = true
		delay = canSee
	elseif canSee == nil then
		data._playerCanSee = true
	end
	
	return Event_Add(__Event_ElementOnScreen_Check, callback, data, delay)
end

function __Event_ElementOnScreen_Check(data)
	if scartype(data._element) == ST_SGROUP then 
		return SGroup_IsOnScreen(data._player, data._element, data._all, data._percent)
	elseif scartype(data._element) == ST_EGROUP then
		if data._playerCanSee == true then
			if Player_CanSeeEGroup(data._player, data._element, data._all) then			
				return EGroup_IsOnScreen(data._player, data._element, data._all, data._percent)
			end
		else
			return EGroup_IsOnScreen(data._player, data._element, data._all, data._percent)
		end
	elseif scartype(data._element) == ST_MARKER or scartype(data._element) == ST_SCARPOS then
		if data._playerCanSee == true then
			if Player_CanSeePosition(data._player, Util_GetPosition(data._element)) then			
				return Misc_IsPosOnScreen(Util_GetPosition(data._element), data._percent)
			end
		else
			return Misc_IsPosOnScreen(Util_GetPosition(data._element), data._percent)
		end
	end
end
	

--? @shortdesc Callback given callback function with data when target enters location.
--? @extdesc Set data.filterlist and data.filtertype if you want to filter out specific SBP's when target is a player.
--? @extdesc Callback data parameter augmented with (could be nil): _result_location = Pos/Marker/Table/SGroup/EGroup/SectorID proximity position.
--? @result EventID
--? @args Function callback, Table data, PlayerID/Squad/Table/TeamID target, Marker/Pos/SectorID/Table/SGroup/EGroup location, REAL range, [ANY/ALL all, Float delay]
function Event_Proximity(callback, data, target, location, range, all, delay)
	data = data or {} -- handle nil data
	data._target = target
	data._location = location
	data._range = range
	data._all = all or all==nil and ALL
	
	local check = nil	
	
	local checkType = scartype(data._location)
	if checkType == ST_TABLE then
		checkType = scartype(data._location[1])
	end
	
	if data._all ~= ALL and data._all ~= ANY then fatal("Event_Proximity recieved invalid type of "..scartype_tostring(scartype(data._all)).." in parameter all. Expected ANY or ALL") end
	
	if scartype(data._target) == ST_PLAYER then
		if data._all and scartype(location) == ST_TABLE then
			fatal("Event_Proximity cannot currently check to see if all of the player's squads are within a set of markers. Talk to Mitch Lagran about getting this functionality implemented if needed.")
		end
		
		check = __Event_Proximity_Player
	elseif scartype(data._target) == ST_TABLE and __isTableTeam(data._target) then
		check = __Event_Proximity_Player
	elseif checkType == ST_SCARPOS or checkType == ST_MARKER then
		data._targetGroup = SGroup_Create("")

		if scartype(data._target) == ST_TABLE then 
			for k, sq in ipairs(data._target) do
				SGroup_AddGroup(data._targetGroup, sq)
			end
		else 
			SGroup_AddGroup(data._targetGroup, data._target)
		end
		
		check = __Event_Proximity_Pos
	elseif checkType == ST_SGROUP or checkType == ST_SQUAD then
		data._locationGroup = SGroup_Create("")
		data._targetGroup = SGroup_Create("")

		if scartype(data._location) == ST_SQUAD then
			SGroup_Add(data._locationGroup, data._location)
		else
			SGroup_AddGroup(data._locationGroup, data._location)
		end
		
		if scartype(data._target) == ST_TABLE then 
			for k, sq in ipairs(data._target) do
				SGroup_AddGroup(data._targetGroup, sq)
			end
		else 
			SGroup_AddGroup(data._targetGroup, data._target)
		end

		check = __Event_Proximity_Squads
	elseif checkType == ST_EGROUP or checkType == ST_ENTITY then
		data._locationGroup = EGroup_Create("")
		data._targetGroup = SGroup_Create("")
		
		if scartype(data._location) == ST_ENTITY then
			EGroup_Add(data._locationGroup, data._location)
		else
			EGroup_AddEGroup(data._locationGroup, data._location)
		end
		
		if scartype(data._target) == ST_TABLE then 
			for k, sq in ipairs(data._target) do
				SGroup_AddGroup(data._targetGroup, sq)
			end
		else 
			SGroup_AddGroup(data._targetGroup, data._target)
		end

		check = __Event_Proximity_Entities
	end		
	
	if check == nil then 
		fatal("Event_Proximity recieved invalid target or location type (nil)")
	end
	
	return Event_Add(check, callback, data, delay)
end

function __Event_Proximity_Player(data)
	if scartype(data._target) == ST_TABLE then
		for i = 1, table.getn(data._target) do
			if scartype(data._location) == ST_TABLE then
				for k, loc in ipairs(data._location) do
					if _PlayerProxCheck(data._target[i], loc, data._range, data._all, data.filterlist, data.filtertype) then
						if not data._all then
							data._result_location = loc 
							return true
						end
					elseif data._all then
						return false
					end
				end
			elseif _PlayerProxCheck(data._target[i], data._location, data._range, data._all, data.filterlist, data.filtertype) then
				data._result_location = data._location
				return true
			end
		end
		return false
	else
		if scartype(data._location) == ST_TABLE then
			for k, loc in ipairs(data._location) do
				if _PlayerProxCheck(data._target, loc, data._range, data._all, data.filterlist, data.filtertype) then
					if not data._all then
						data._result_location = loc 
						return true
					end
				elseif data._all then
					return false
				end
			end
		elseif _PlayerProxCheck(data._target, data._location, data._range, data._all, data.filterlist, data.filtertype) then
			data._result_location = data._location
			return true
		end
		
		return false
	end
end		

function __Event_Proximity_Pos(data)
	if SGroup_TotalMembersCount(data._targetGroup, true) > 0 then	
		if scartype(data._location) == ST_TABLE then	
			for i, marker in ipairs(data._location) do
				if Prox_AreSquadsNearMarker(data._targetGroup, marker, data._all, data._range) then		
--~ 					SGroup_Clear(data._targetGroup)
--~ 					SGroup_Destroy(data._targetGroup)
					data._result_location = marker
					return true
				end
			end				
		elseif Prox_AreSquadsNearMarker(data._targetGroup, data._location, data._all, data._range) then		
--~ 			SGroup_Clear(data._targetGroup)
--~ 			SGroup_Destroy(data._targetGroup)	
			data._result_location = data._location
			return true
		end
	end	

	return false -- no life, no position	
end	

function __Event_Proximity_Squads(data)
	if SGroup_TotalMembersCount(data._targetGroup, true) > 0 then		
		if scartype(data._location) == ST_TABLE then	
			for i, locGroup in ipairs(data._location) do
				if Prox_SquadsInProximityOfSquads(data._targetGroup, locGroup, data._range, data._all) then	
--~ 					SGroup_Clear(data._targetGroup)
--~ 					SGroup_Destroy(data._targetGroup)
--~ 					SGroup_Clear(data._locationGroup)
--~ 					SGroup_Destroy(data._locationGroup)
					data._result_location = locGroup
					return true
				end
			end				
		elseif Prox_SquadsInProximityOfSquads(data._targetGroup, data._locationGroup, data._range, data._all) then	
--~ 			SGroup_Clear(data._targetGroup)
--~ 			SGroup_Destroy(data._targetGroup)	
--~ 			SGroup_Clear(data._locationGroup)
--~ 			SGroup_Destroy(data._locationGroup)
			data._result_location = data._location
			return true
		end
	end	
	
	return false		
end	

function __Event_Proximity_Entities(data)
	if SGroup_TotalMembersCount(data._targetGroup, true) > 0 then		
		if scartype(data._location) == ST_TABLE then	
			for i, locGroup in ipairs(data._location) do
				if Prox_SquadsInProximityOfEntities(data._targetGroup, locGroup, data._range, data._all) then	
--~ 					SGroup_Clear(data._targetGroup)
--~ 					SGroup_Destroy(data._targetGroup)
--~ 					EGroup_Clear(data._locationGroup)
--~ 					EGroup_Destroy(data._locationGroup)
					data._result_location = locGroup
					return true
				end
			end				
		elseif Prox_SquadsInProximityOfEntities(data._targetGroup, data._locationGroup, data._range, data._all) then	
--~ 			SGroup_Clear(data._targetGroup)
--~ 			SGroup_Destroy(data._targetGroup)	
--~ 			EGroup_Clear(data._locationGroup)
--~ 			EGroup_Destroy(data._locationGroup)
			data._result_location = data._location
			return true
		end
	end	
	
	return false		
end	

function _PlayerProxCheck(player, location, range, all, filterlist, filtertype)
	if scartype(location) == ST_SGROUP then
		return Prox_PlayerSquadsInProximityOfSquads(player, location, range, all, nil, filterlist, filtertype)
	elseif scartype(location) == ST_EGROUP then
		return Prox_PlayerSquadsInProximityOfEntities(player, location, range, all, filterlist, filtertype)
	elseif scartype(location) == ST_MARKER then
		return Prox_ArePlayersNearMarker(player, location, all, range, filterlist, filtertype)
	else
		return false
	end
end

-----------------------------------------------------------
-----------------------------------------------------------
--? @shortdesc Callback given callback function with data, when narrative events are running. 
--? @result EventID
--? @args Function callback, Table data, [Float delay]
function Event_NarrativeEventsRunning(callback, data, delay)
	data = data or {}	
	return Event_Add(__Event_NarrativeEventsRunning, callback, data, delay)
end

--? @shortdesc Callback given callback function with data, when no narrative event are running. 
--? @result EventID
--? @args Function callback, Table data, [Float delay]
function Event_NarrativeEventsNotRunning(callback, data, delay)
	data = data or {}	
	return Event_Add(__Event_NoNarrativeEventsRunning, callback, data, delay)
end

function __Event_NoNarrativeEventsRunning(data)
	return not Event_IsAnyRunning()
end
function __Event_NarrativeEventsRunning(data)
	return Event_IsAnyRunning()
end

--? @shortdesc Callback when a player's squad count <= amount.
--? @extdesc Callback data parameter augmented with: _player, _squadCount
--? @result EventID
--? @args Function callback, Table data, PlayerID player, Int amount[, Float delay]
function Event_PlayerSquadCount(callback, data, player, amount, delay)
	data = data or {}
	data._player = player
	data._squadCount = amount
	
	if scartype(data._player) ~= ST_PLAYER then	fatal("Event_PlayerSquadCount recieved scartype "..scartype_tostring(data._player).." for parameter player, expected scartype ST_PLAYER") end
	if scartype(data._squadCount) ~= ST_NUMBER then	fatal("Event_PlayerSquadCount recieved scartype "..scartype_tostring(data._squadCount).." for parameter amount, expected type ST_NUMBER") end
	
	return Event_Add(__Event_PlayerSquadCount, callback, data, delay)
end

function __Event_PlayerSquadCount(data)
	if Player_GetSquadCount(data._player) <= data._squadCount then
		return true
	end
	return false	
end

--? @shortdesc Callback when a Team's squad count <= amount.
--? @extdesc Callback data parameter augmented with: _team, _squadCount
--? @result EventID
--? @args Function callback, Table data, TeamID team, Int amount[, Float delay]
function Event_TeamSquadCount(callback, data, team, amount, delay)
	data = data or {}
	data._team = team
	data._squadCount = amount
	
	if scartype(data._team) ~= ST_TABLE then fatal("Event_TeamSquadCount recieved scartype "..scartype_tostring(data._team).." for parameter team, expected scartype ST_TABLE") end
	if scartype(data._squadCount) ~= ST_NUMBER then	fatal("Event_PlayerSquadCount recieved scartype "..scartype_tostring(data._squadCount).." for parameter amount, expected type ST_NUMBER") end
	
	return Event_Add(__Event_TeamSquadCount, callback, data, delay)
end

function __Event_TeamSquadCount(data)
	local count = 0
	for i = 1, table.getn(data._team) do
		count = count+Player_GetSquadCount(data._team[i])
	end
	
	if count <= data._squadCount then
		return true
	end
	return false	
end


--? @shortdesc Callback when an SGroup's member count <= amount.
--? @extdesc Callback data parameter augmented with: _sgroup, _amount
--? @result EventID
--? @args Function callback, Table data, SGroupID sgroup, Int amount[, Float delay]
function Event_MembersCount(callback, data, sgroup, amount, delay)
	data = data or {}
	data._sgroup = sgroup
	data._amount = amount
	
	return Event_Add(__Event_MembersCount_Check, callback, data, delay)
end

function __Event_MembersCount_Check(data)
	return SGroup_TotalMembersCount(data._sgroup, false) <= data._amount
end




--? @shortdesc Callback given callback function with data, when entire group has a specified critical. 
--? @extdesc Callback parameter data augmented with: _group = EGroup/SGroup group. 
--? @result EventID
--? @args Function callback, Table data,SGroup group, Float delay, BP Critical, Bool ANY/ALL, [Float delay]
function Event_GroupHasCritical(callback, data, group, critical, all, delay)
	if scartype(group) ~= ST_SGROUP and scartype(group) ~= ST_SQUAD and scartype(group) ~= ST_ENTITY and scartype(group) ~= ST_EGROUP then
		fatal("Event_GroupIsDead received object of type "..scartype_tostring(scartype(group)).." instead of an SGroup or squad or EGroup or entity")
	end
	
	data = data or {} -- handle nil data
	data._group = group
	data._critical = critical
	data._all = all		
	return Event_Add(__Event_GroupHasCritical_Check, callback, data, delay)
end


function __Event_GroupHasCritical_Check(data)
	if scartype(data._group) == ST_SGROUP then 
		if data._critical ~= nil then
		
			if SGroup_HasCritical(data._group, data._critical, data._all) then
		
				return true
		
			end
		end
	elseif scartype(data._group) == ST_SQUAD then
		if data._critical ~= nil then
		
			if Squad_HasCritical(data._group, data._critical) then
		
				return true
		
			end
		end
		
	elseif scartype(data._group) == ST_ENTITY then
		if data._critical ~= nil then
		
			if Entity_HasCritical(data._group, data._critical) then
		
				return true
		
			end
		end	
	elseif scartype(data._group) == ST_EGROUP then
		if data._critical ~= nil then
		
			local _checkEntity = function(gid, idx, eid)
				
				return Entity_HasCritical(data._group, data._critical)
			end
			
			return EGroup_ForEachAllOrAny(data._group, data._all, _checkEntity)
			
		end		
		
	end
end


--? @shortdesc Callback given callback function with data, when group is dead (empty). 
--? @extdesc Callback parameter data augmented with: _group = EGroup/SGroup group. Optional Retreating param will check if the unit is retreating as an alternate (for team weapons)
--? @result EventID
--? @args Function callback, Table data, EGroup/SGroup group[, Float delay, Boolean retreating]
function Event_GroupIsDead(callback, data, group, delay, retreating)
	if scartype(group) ~= ST_SGROUP and scartype(group) ~= ST_EGROUP then
		fatal("Event_GroupIsDead received object of type "..scartype_tostring(scartype(group)).." instead of an SGroup or EGroup")
	end
	
	if retreating == nil then retreating = true end
	
	data = data or {} -- handle nil data
	data._group = group
	data._retreating = retreating
			
	return Event_Add(__Event_GroupIsDead_Check, callback, data, delay)
end


function __Event_GroupIsDead_Check(data)
	if scartype(data._group) == ST_SGROUP then 
		if data._retreating == false then
			return SGroup_IsEmpty(data._group)
		else
			if SGroup_IsEmpty(data._group) or SGroup_IsRetreating(data._group, ALL) then
				return true
			end
		end
	elseif scartype(data._group) == ST_EGROUP then
		return EGroup_IsEmpty(data._group)
	elseif scartype(data._group) == ST_SQUAD then
		if data._retreating == false then
			return Squad_Count(data._group) <= 0
		else
			if Squad_Count(data._group) <= 0 or Squad_IsRetreating(data._group) then
				return true
			end
		end
	elseif scartype(data._group) == ST_ENTITY then
		return Entity_IsAlive(data._group) == false
	else
		return true -- no group is a dead group
	end
end

--? @shortdesc Callback given callback function with data, when group is suppressed. 
--? @extdesc Callback parameter data augmented with: _group = SGroup group. 
--? @result EventID
--? @args Function callback, Table data, SGroup group[, bool ANY/ALL, Float delay]
function Event_GroupIsSuppressed(callback, data, group, all, delay)
	if scartype(group) ~= ST_SGROUP then
		fatal("Event_GroupIsSuppressed received object of type "..scartype_tostring(scartype(group)).." instead of an SGroup")
	end
	
	if all == nil then all = true end
	
	data = data or {} -- handle nil data
	data._group = group
	data._all = all
			
	return Event_Add(__Event_GroupIsSuppressed_Check, callback, data, delay)
end

function __Event_GroupIsSuppressed_Check(data)
	if scartype(data._group) == ST_SGROUP then 
		if SGroup_IsSuppressed(data._group, data._all) then
			return true
		end
	end
end

--? @shortdesc Callback given callback function with data, when group is not suppressed. 
--? @extdesc Callback parameter data augmented with: _group = SGroup group. Note: being pinned counts as not being suppressed.
--? @result EventID
--? @args Function callback, Table data, SGroup group[, bool ANY/ALL, Float delay]
function Event_GroupIsNotSuppressed(callback, data, group, all, delay)
	if scartype(group) ~= ST_SGROUP then
		fatal("Event_GroupIsNotSuppressed received object of type "..scartype_tostring(scartype(group)).." instead of an SGroup")
	end
	
	if all == nil then all = true end
	
	data = data or {} -- handle nil data
	data._group = group
	data._all = all
			
	return Event_Add(__Event_GroupIsNotSuppressed_Check, callback, data, delay)
end

function __Event_GroupIsNotSuppressed_Check(data)
	if scartype(data._group) == ST_SGROUP then 
		if SGroup_IsSuppressed(data._group, data._all) == false then
			return true
		end
	end
end

--? @shortdesc Callback given callback function with data, when group is pinned 
--? @extdesc Callback parameter data augmented with: _group = SGroup group. 
--? @result EventID
--? @args Function callback, Table data, SGroup group[, bool ANY/ALL, Float delay]
function Event_GroupIsPinned(callback, data, group, all, delay)
	if scartype(group) ~= ST_SGROUP then
		fatal("Event_GroupIsPinned received object of type "..scartype_tostring(scartype(group)).." instead of an SGroup")
	end
	
	if all == nil then all = true end
	
	data = data or {} -- handle nil data
	data._group = group
	data._all = all
			
	return Event_Add(__Event_GroupIsPinned_Check, callback, data, delay)
end

function __Event_GroupIsPinned_Check(data)
	if scartype(data._group) == ST_SGROUP then 
		if SGroup_IsPinned(data._group, data._all) then
			return true
		end
	end
end

--? @shortdesc Callback given callback function with data, when group is not pinned 
--? @extdesc Callback parameter data augmented with: _group = SGroup group. Note: being suppressed counts as not being pinned
--? @result EventID
--? @args Function callback, Table data, SGroup group[, bool ANY/ALL, Float delay]
function Event_GroupIsNotPinned(callback, data, group, all, delay)
	if scartype(group) ~= ST_SGROUP then
		fatal("Event_GroupIsNotPinned received object of type "..scartype_tostring(scartype(group)).." instead of an SGroup")
	end
	
	if all == nil then all = true end
	
	data = data or {} -- handle nil data
	data._group = group
	data._all = all
			
	return Event_Add(__Event_GroupIsNotPinned_Check, callback, data, delay)
end

function __Event_GroupIsNotPinned_Check(data)
	if scartype(data._group) == ST_SGROUP then 
		if SGroup_IsPinned(data._group, data._all) == false then
			return true
		end
	end
end
	

--? @shortdesc Callback given callback function with data, when group is under attack in the last attackTime seconds. 
--? @extdesc Callback parameter data augmented with: _group = EGroup/SGroup group, _attackTime = Float attackTime
--? @result EventID
--? @args Function callback, Table data, EGroup/SGroup group, bool ANY/ALL, Float attackTime[, PlayerID player, Float delay]
function Event_IsUnderAttack(callback, data, group, all, attackTime, player, delay)
	if scartype(group) == ST_SGROUP and SGroup_IsEmpty(group) then fatal("Empty sgroup received (" .. SGroup_GetName(group) ..")") end
	if scartype(group) == ST_EGROUP and EGroup_IsEmpty(group) then fatal("Empty egroup received (" .. EGroup_GetName(group) ..")") end
	
	if scartype(player) ~= ST_PLAYER and player ~= nil then fatal("Player value must be valid PlayerID or nil") end
	
	data = data or {} -- handle nil data
	data._group = group
	data._player = player
	data._all = all or all==nil and ALL
	data._attackTime = attackTime
			
	return Event_Add(__Event_IsUnderAttack_Check, callback, data, delay)
end

function __Event_IsUnderAttack_Check(data)
	if scartype(data._group) == ST_SGROUP then 
		if data._player ~= nil then
			if SGroup_IsUnderAttackByPlayer(data._group, data._player, data._attackTime) then
				data.attacker = SGroup_Create("")
				SGroup_GetLastAttacker(data._group, data.attacker)
				return true
			end
		else
			if SGroup_IsUnderAttack(data._group, data._all, data._attackTime) then			
				data.attacker = SGroup_Create("")
				SGroup_GetLastAttacker(data._group, data.attacker)
				return true
			end
		end
	elseif scartype(data._group) == ST_EGROUP then
		if data._player ~= nil then
			if EGroup_IsUnderAttackByPlayer(data._group, data._player, data._attackTime) then
				data.attacker = SGroup_Create("")
				EGroup_GetLastAttacker(data._group, data.attacker)
				return true
			end
		else
			if EGroup_IsUnderAttack(data._group, data._all, data._attackTime) then
				data.attacker = SGroup_Create("")
				EGroup_GetLastAttacker(data._group, data.attacker)
				return true
			end
		end
	end
	return false
end


--? @shortdesc Callback given callback function with data, when group is doing an attack in the last attackTime seconds. 
--? @extdesc Callback parameter data augmented with: _group = EGroup/SGroup group, _attackTime = Float attackTime
--? @result EventID
--? @args Function callback, Table data, EGroup/SGroup group, ANY/ALL all, Float attackTime[, Float delay]
function Event_IsDoingAttack(callback, data, group, all, attackTime, delay)
	if scartype(group) == ST_SGROUP and SGroup_IsEmpty(group) then fatal("Empty sgroup received (" .. SGroup_GetName(group) ..")") end
	if scartype(group) == ST_EGROUP and EGroup_IsEmpty(group) then fatal("Empty egroup received (" .. EGroup_GetName(group) ..")") end
			
	data = data or {} -- handle nil data
	data._group = group
	data._all = all or all==nil and ALL
	data._attackTime = attackTime
	
	return Event_Add(__Event_IsDoingAttack_Check, callback, data, delay)
end

function __Event_IsDoingAttack_Check(data)
	if scartype(data._group) == ST_SGROUP then 
		return SGroup_IsDoingAttack(data._group, data._all, data._attackTime)
	elseif scartype(data._group) == ST_EGROUP then
		return EGroup_IsDoingAttack(data._group, data._all, data._attackTime)
	else
		return false -- nobody's doin' nothin'
	end
end

--? @shortdesc Callback given function with data, when player has greater than or equal to amountOfBuildings 
--? @extdesc Callback parameter data augmented with: _player = PlayerID player, _amountOfBuildings = Int amountOfBuildings
--? @result EventID
--? @args Function callback, Table data, PlayerID player, Int amountOfBuilding [, Float delay]
function Event_PlayerBuildingCount(callback, data, player, amountOfBuildings, delay)			
	data = data or {} -- handle nil data
	data._player = player
	data._amountOfBuildings = amountOfBuildings
	data._race = Player_GetRaceName(data._player)
	return Event_Add(__Event_PlayerBuildingCount, callback, data, delay)
end 

function __Event_PlayerBuildingCount(data)
	local ebpList = LIST.SOVIETBASEBUILDINGS
	if data._race == TRACE_GERMAN then
		ebpList = LIST.GERMANBASEBUILDINGS 
	end	
	
	return Player_GetBuildingsCountOnly(data._player, ebpList) >= data._amountOfBuildings
end

--? @shortdesc Callback given function with data, when player has greater than or equal to amountOfBuildings 
--? @extdesc Callback parameter data augmented with: _player = PlayerID player, _amountOfBuildings = Int amountOfBuildings
--? @result EventID
--? @args Function callback, Table data, TeamID team, Int amountOfBuilding [, Float delay]
function Event_TeamBuildingCount(callback, data, player, amountOfBuildings, delay)			
	data = data or {} -- handle nil data
	data._player = player
	data._amountOfBuildings = amountOfBuildings
	data._race = Player_GetRaceName(data._player)
	return Event_Add(__Event_PlayerBuildingCount, callback, data, delay)
end 

function __Event_PlayerBuildingCount(data)
	local ebpList = LIST.SOVIETBASEBUILDINGS
	if data._race == TRACE_GERMAN then
		ebpList = LIST.GERMANBASEBUILDINGS 
	end	
	
	return Player_GetBuildingsCountOnly(data._player, ebpList) >= data._amountOfBuildings
end

--? @shortdesc Callback given callback function with data, when group is doing an attack or is under attack in the last attackTime seconds. 
--? @extdesc Callback parameter data augmented with: _group = EGroup/SGroup group, _attackTime = Float attackTime
--? @result EventID
--? @args Function callback, Table data, EGroup/SGroup group, ANY/ALL all, Float attackTime[, Float delay]
function Event_IsEngaged(callback, data, group, all, attackTime, delay)
	if scartype(group) == ST_SGROUP and SGroup_IsEmpty(group) then fatal("Empty sgroup received (" .. SGroup_GetName(group) ..")") end
	if scartype(group) == ST_EGROUP and EGroup_IsEmpty(group) then fatal("Empty egroup received (" .. EGroup_GetName(group) ..")") end
			
	data = data or {} -- handle nil data
	data._group = group
	data._all = all or all==nil and ALL
	data._attackTime = attackTime or 1
	
	return Event_Add(__Event_IsEngaged, callback, data, delay)
end

function __Event_IsEngaged(data)
	if scartype(data._group) == ST_SGROUP then 
		return SGroup_IsDoingAttack(data._group, data._all, data._attackTime) or SGroup_IsUnderAttack(data._group, data._all, data._attackTime)
	elseif scartype(data._group) == ST_EGROUP then
		return EGroup_IsDoingAttack(data._group, data._all, data._attackTime) or EGroup_IsUnderAttack(data._group, data._all, data._attackTime)
	else
		return false -- nobody's doin' nothin'
	end
end

--? @shortdesc Callback given callback function with data, when player owns all given territories. 
--? @extdesc Callback parameter data augmented with: _player = PlayerID player, _territory = sectorID/EGroup/Entity/Table of a capture point
--? @result EventID
--? @args Function callback, Table data, PlayerID player, SectorID/EGroup/Entity/Table territory[, ANY/ALL all, Float delay]
function Event_PlayerOwnsTerritory(callback, data, player, territory, all, delay)
	
	if(scartype(territory) ~= ST_TABLE) then
		territory = {territory}
	end
	
	local sectorIDs = {}
	for k, terr in pairs(territory) do
		if(scartype(terr) == ST_NUMBER) then
			-- Got the sectorID, straight up
			table.insert(sectorIDs, terr)
		elseif scartype(terr) == ST_EGROUP then
			-- Egroup. Cycle through entities and add each corresponding sectorID
			local _findStrategicPoint = function(gid, idx, eid)
				if Entity_IsStrategicPoint(eid) then
					table.insert(sectorIDs, World_GetTerritorySectorID(Entity_GetPosition(eid)))
				end
			end
			
			EGroup_ForEach(terr, _findStrategicPoint)
		elseif scartype(terr) == ST_ENTITY and Entity_IsStrategicPoint(terr) then
			-- Entity. Get the sectorID
			table.insert(sectorIDs, World_GetTerritorySectorID(Entity_GetPosition(terr)))
		end
	end
	
	
	data = data or {} -- handle nil data
	data._player = player
	data._territory = sectorIDs
	data._all = all
	
	if scartype(all) == ST_NUMBER then
		delay = all
		data._all = ALL
	elseif all == nil then
		data._all = ALL
	end

	return Event_Add(__Event_PlayerOwnsTerritory_Check, callback, data, delay)
end

function __Event_PlayerOwnsTerritory_Check(data)
	--Because of old save-files, cannot assume that the data has been sanitized. Must check for different types of territory data
	if scartype(data._territory) ~= ST_TABLE then
		data._territory = {data._territory}
	end
	
	for k, ter in ipairs(data._territory) do 
		local terrID = ter
		if(scartype(ter) ~= ST_NUMBER) then
			terrID = World_GetTerritorySectorID(Util_GetPosition(ter))
		end
		
		if World_IsTerritorySectorOwnedByPlayer(data._player, terrID) == false then
			if data._all == ALL then
				return false
			end
		elseif data._all == ANY then
			data.captured = ter
			return true
		end
	end
	
	if data._all == ALL then
		return true
	end
end

--? @shortdesc Callback when a territory is/is not in supply.
--? @extdesc Callback parameter data augmented with: _player = PlayerID player, _territory = position sectorID
--? @result EventID
--? @args Function callback, Table data, PlayerID player, ScarPos territory, Boolean inSupply[, Float delay]
function Event_TerritoryInSupply(callback, data, player, territory, inSupply, delay)
	
	data = data or {}
	data._player = player
	data._territory = Util_GetPosition(territory)
	
	if(inSupply) then
		return Event_Add(__Event_TerritoryInSupply, callback, data, delay)
	else
		return Event_Add(__Event_TerritoryNotInSupply, callback, data, delay)
	end
end
function __Event_TerritoryInSupply(data)
	return World_IsInSupply(data._player, data._territory)
end

function __Event_TerritoryNotInSupply(data)
	return World_IsInSupply(data._player, data._territory) == false
end



--? @shortdesc Callback given callback function with data, when a team owns all given territories. 
--? @extdesc Callback parameter data augmented with: _team = TeamID team, _territory = Int/Table sectorID OR EGroup/Entity of a capture point
--? @result EventID
--? @args Function callback, Table data, TeamID team, Int/Table/EGroup/Entity sectorID/group/entity[, ANY/ALL all, Float delay]
function Event_TeamOwnsTerritory(callback, data, team, territory, all, delay)
	
	if scartype(territory) == ST_EGROUP then
		
		local _findStrategicPoint = function(gid, idx, eid)
			if Entity_IsStrategicPoint(eid) then
				territory = World_GetTerritorySectorID(Util_GetPosition(eid))
			end
		end
		
		EGroup_ForEach(territory, _findStrategicPoint)
	elseif scartype(territory) == ST_ENTITY and Entity_IsStrategicPoint(territory) then
		territory = World_GetTerritorySectorID(Util_GetPosition(eid))
	end
	
	data = data or {} -- handle nil data
	data._team = team
	data._territory = territory
	data._all = all
	
	if scartype(all) == ST_NUMBER then
		delay = all
		data._all = ALL
	elseif all == nil then
		data._all = ALL
	end

	return Event_Add(__Event_TeamOwnsTerritory_Check, callback, data, delay)
end

function __Event_TeamOwnsTerritory_Check(data)
	for i = 1, table.getn(data._team) do
		if scartype(data._territory) == ST_TABLE then	
			for k, ter in ipairs(data._territory) do 
				local terrID = World_GetTerritorySectorID(Util_GetPosition(ter))
				
				if World_IsTerritorySectorOwnedByPlayer(data._team[i], terrID) == false then
					if data._all == ALL then
						return false
					end
				elseif data._all == ANY then
					data.captured = ter
					return true
				end
			end
			if data._all == ALL then
				return true
			end
		else
			return World_IsTerritorySectorOwnedByPlayer(data._team[i], data._territory)
		end
	end
end

--? @shortdesc Callback given callback function with data, when player owns none of the given territories. 
--? @extdesc Callback parameter data augmented with: _player = PlayerID player, _territory = Int/Table sectorID OR EGroup/Entity of a capture point
--? @result EventID
--? @args Function callback, Table data, PlayerID player, Int/Table/EGroup/Entity sectorID/group/entity[, Float delay]
function Event_PlayerDoesntOwnTerritory(callback, data, player, territory, delay)
	
	if scartype(territory) == ST_EGROUP then
		
		local _findStrategicPoint = function(gid, idx, eid)
			if Entity_IsStrategicPoint(eid) then
				territory = World_GetTerritorySectorID(Util_GetPosition(eid))
			end
		end
		
		EGroup_ForEach(territory, _findStrategicPoint)
	elseif scartype(territory) == ST_ENTITY and Entity_IsStrategicPoint(territory) then
		territory = World_GetTerritorySectorID(Util_GetPosition(eid))
	end
	
	data = data or {} -- handle nil data
	data._player = player
	data._territory = territory

	return Event_Add(__Event_PlayerDoesntOwnTerritory_Check, callback, data, delay)
end

function __Event_PlayerDoesntOwnTerritory_Check(data)
	if scartype(data._territory) == ST_TABLE then
		for k, ter in ipairs(data._territory) do 
			if World_IsTerritorySectorOwnedByPlayer(data._player, ter) == true then
				return false
			end
		end
		return true
	else
		return not World_IsTerritorySectorOwnedByPlayer(data._player, data._territory)
	end
end

--? @shortdesc Callback given callback function with data, when a team owns none of the given territories. 
--? @extdesc Callback parameter data augmented with: _team = TeamID team, _territory = Int/Table sectorID OR EGroup/Entity of a capture point
--? @result EventID
--? @args Function callback, Table data, TeamID team, Int/Table/EGroup/Entity sectorID/group/entity[, Float delay]
function Event_TeamDoesntOwnTerritory(callback, data, team, territory, delay)
	
	if scartype(territory) == ST_EGROUP then
		
		local _findStrategicPoint = function(gid, idx, eid)
			if Entity_IsStrategicPoint(eid) then
				territory = World_GetTerritorySectorID(Util_GetPosition(eid))
			end
		end
		
		EGroup_ForEach(territory, _findStrategicPoint)
	elseif scartype(territory) == ST_ENTITY and Entity_IsStrategicPoint(territory) then
		territory = World_GetTerritorySectorID(Util_GetPosition(eid))
	end
	
	data = data or {} -- handle nil data
	data._team = team
	data._territory = territory

	return Event_Add(__Event_TeamDoesntOwnTerritory_Check, callback, data, delay)
end

function __Event_TeamDoesntOwnTerritory_Check(data)
	for i = 1, table.getn(data._team) do
		if scartype(data._territory) == ST_TABLE then
			for k, ter in ipairs(data._territory) do 
				if World_IsTerritorySectorOwnedByPlayer(data._team[i], ter) == true then
					return false
				end
			end
			return true
		else
			return not World_IsTerritorySectorOwnedByPlayer(data._team, data._territory)
		end
	end
end

--? @shortdesc Callback given  function with data, when player owns the given element
--? @extdesc Callback parameter data augmented with: _player = PlayerID player, _element = Entity/EGroup/Squad/SGroup element
--? @result EventID
--? @args Function callback, Table data, PlayerID player, Entity/EGroup/Squad/SGroup element [, Float delay, Boolean all]
function Event_PlayerOwnsElement(callback, data, player, element, delay, all)
	data = data or {} -- handle nil data
	data._player = player
	data._element = element
	data._all = all or true

	return Event_Add(__Event_IsOwnedBy, callback, data, delay)	
end

function __Event_IsOwnedBy(data)
	if scartype(data._element) == ST_EGROUP then	
		return Player_OwnsEGroup(data._player, data._element, data._all)
	elseif scartype(data._element) == ST_ENTITY then
		return Player_OwnsEntity(data._player, data._element)
	elseif scartype(data._element) == ST_SGROUP then	
		return Player_OwnsSGroup(data._player, data._element, data._all)
	elseif scartype(data._element) == ST_SQUAD then
		return Player_OwnsSquad(data._player, data._element)
	end
end

--? @shortdesc Callback given  function with data, when a team owns the given element
--? @extdesc Callback parameter data augmented with: _team = TeamID team, _element = Entity/EGroup/Squad/SGroup element
--? @result EventID
--? @args Function callback, Table data, TeamID team, Entity/EGroup/Squad/SGroup element [, Float delay]
function Event_TeamOwnsElement(callback, data, element, team, delay)
	data = data or {} -- handle nil data
	data._team = team
	data._element = element

	return Event_Add(__Event_IsOwnedByTeam, callback, data, delay)	
end

function __Event_IsOwnedByTeam(data)
	for i = 1, table.getn(data._team) do 
		if scartype(data._element) == ST_EGROUP then	
			return Player_OwnsEGroup(data._team[i], data._element)
		elseif scartype(data._element) == ST_ENTITY then
			return Player_OwnsEntity(data._team[i], data._element)
		elseif scartype(data._element) == ST_SGROUP then	
			return Player_OwnsSGroup(data._team[i], data._element)
		elseif scartype(data._element) == ST_SQUAD then
			return Player_OwnsSquad(data._team[i], data._element)
		end
	end
end

--? @shortdesc Callback given callback function with data, when the given objective has started. 
--? @extdesc NOT DETERMINISM SAFE for multiplayer or coop.
--? @extdesc Callback data parameter is agumented with: _objective = ObjectiveID objective
--? @result EventID
--? @args Function callback, Table data, ObjectiveID Objective, Float delay]
function Event_ObjectiveStarted(callback, data, objective, delay)

	data = data or {} -- handle nil data
	data._objective = objective
	
	data._playerCanSee = canSee
	
	return Event_Add(__Event_ObjectiveStarted_Check, callback, data, delay)
end

function __Event_ObjectiveStarted_Check(data)
	if Objective_IsStarted(data._objective) then
		return true
	end
end

--? @shortdesc Callback given callback function with data, when an element's health falls below (or above if higher is true) given threshold. 
--? @result EventID
--? @args Function callback, Table data, EGroup/SGroup/Entity/Squad target, Float threshold, Boolean higher[, Float delay]
function Event_OnHealth(callback, data, target, threshold, higher, delay)
	
	data = data or {} -- handle nil data
	data._target = target
	data._threshold = threshold
	data._higher = higher or false
			
	return Event_Add(__Event_OnHealth_Check, callback, data, delay)
end

function __Event_OnHealth_Check(data)
	if not data._higher then
		return Util_GetHealth(data._target) <= data._threshold
	else
		return Util_GetHealth(data._target) >= data._threshold	
	end
end
	

--? @shortdesc Callback given callback function with data, when an element is holding anything or nothing. 
--? @extdesc Callback parameter data augmented with: _target = EGroup/SGroup/Entity/Squad target, _empty = Bool isEmpty
--? @result EventID
--? @args Function callback, Table data, EGroup/SGroup/Entity/Squad target, Boolean empty[, Float delay]
function Event_IsHoldingAny(callback, data, target, empty, delay)

	data = data or {} -- handle nil data
	data._target = target
	data._empty = empty or false

	return Event_Add(__Event_IsHoldingAny_Check, callback, data, delay)
end

function __Event_IsHoldingAny_Check(data)
	if scartype(data._target) == ST_SQUAD then
		return Squad_IsHoldingAny(data._target) ~= data._empty
	elseif scartype(data._target) == ST_SGROUP then
		return SGroup_IsHoldingAny(data._target) ~= data._empty
	elseif scartype(data._target) == ST_ENTITY then
		return Entity_IsHoldingAny(data._target) ~= data._empty
	elseif scartype(data._target) == ST_EGROUP then
		return EGroup_IsHoldingAny(data._target) ~= data._empty
	else
		print("__Event_IsHoldingAny_Check lost reference to it's group")
		return data._empty -- no hold is empty; no hold can't hold anything
	end
end

--? @shortdesc Callback given callback function with data, when an element is holding a specific BP. 
--? @extdesc Callback parameter data augmented with: _target = EGroup/SGroup/Entity/Squad target, _empty = Bool isEmpty
--? @result EventID
--? @args Function callback, Table data, EGroup/SGroup/Entity/Squad target, SquadBP/Table blueprint[, Float delay]
function Event_IsHoldingBP(callback, data, target, blueprint, delay)

	data = data or {} -- handle nil data
	data._target = target
	data._empty = empty or false
	data._blueprint = blueprint

	return Event_Add(__Event_IsHoldingBP_Check, callback, data, delay)
end

function __Event_IsHoldingBP_Check(data)
	local sid = nil
	local sg = SGroup_Create("")
	if scartype(data._target) == ST_SQUAD then
		if Squad_IsHoldingAny(data._target) then
			sid = Squad_GetHoldSquad(data._target)
		end
	elseif scartype(data._target) == ST_SGROUP then
		if SGroup_IsHoldingAny(data._target) then
			sid = Squad_GetHoldSquad(SGroup_GetSpawnedSquadAt(data._target, 1))
		end
	elseif scartype(data._target) == ST_ENTITY then
		if Entity_IsHoldingAny(data._target) then
			Entity_GetSquadsHeld(data._target, sg)
			sid = SGroup_GetSpawnedSquadAt(sg, 1)
			SGroup_Destroy(sg)
		end
	elseif scartype(data._target) == ST_EGROUP then
		if EGroup_IsHoldingAny(data._target) then
			EGroup_GetSquadsHeld(data._target, sg)
			sid = SGroup_GetSpawnedSquadAt(sg, 1)
			SGroup_Destroy(sg)
		end
	else
		print("__Event_IsHoldingAny_Check lost reference to it's group")
		return data._empty -- no hold is empty; no hold can't hold anything
	end

	if scartype(data._blueprint) == ST_PBG then
		if scartype(sid) == ST_SQUAD then
			return Squad_GetBlueprint(sid) == data._blueprint
		end
	elseif scartype(data._blueprint) == ST_TABLE then
		if scartype(sid) == ST_SQUAD then
			for i=1, table.getn(data._blueprint) do
				if Squad_GetBlueprint(sid) == data._blueprint[i] then
					return true
				end
			end
		end
	end
end
	

--? @shortdesc Callback given callback function with data, when a target element is in a hold or not. 
--? @extdesc Callback parameter data augmented with: _target = SGroup/Squad target, _inHold = Bool inHold
--? @result EventID
--? @args Function callback, Table data, SGroup/Squad target, Boolean inHold, ANY/ALL[, Float delay]
function Event_IsInHold(callback, data, target, inHold, all, delay)

	data = data or {} -- handle nil data
	data._target = target
	data._inHold = inHold or inHold==nil and true
	data._all = all or all==nil and ALL
	
	return Event_Add(__Event_IsInHold_Check, callback, data, delay)
end

function __Event_IsInHold_Check(data)
	if scartype(data._target) == ST_SQUAD then
		return (Squad_IsInHoldSquad(data._target, data._all) or Squad_IsInHoldEntity(data._target, data._all)) == data._inHold
	elseif scartype(data._target) == ST_SGROUP then
		return (SGroup_IsInHoldSquad(data._target, data._all) or SGroup_IsInHoldEntity(data._target, data._all)) == data._inHold
	else
		return false
	end
end
	

--? @shortdesc Callback when a target element is selected. 
--? @extdesc Callback parameter data augmented with: _target = EGroup/Entity/SGroup/Squad target, _all = Bool ANY/ALL
--? @result EventID
--? @args Function callback, Table data, SGroup/Squad/EGroup/entity target, ANY/ALL[, Float delay]
function Event_IsSelected(callback, data, target, all, delay)
	
	data = data or {} -- handle nil data
	data._target = target
	data._all = all or all==nil and ALL
	
	return Event_Add(__Event_IsSelected_Check, callback, data, delay)
end

function __Event_IsSelected_Check(data)
	if scartype(data._target) == ST_SQUAD then
		return Misc_IsSquadSelected(data._target)
	elseif(scartype(data._target) == ST_SGROUP) then
		return Misc_IsSGroupSelected(data._target, data._all)
	elseif(scartype(data._target) == ST_ENTITY) then
		return Misc_IsEntitySelected(data._target)
	elseif(scartype(data._target) == ST_EGROUP) then
		return Misc_IsEGroupSelected(data._target, data._all)
	else
		return false
	end
end
	
	
--? @shortdesc Callback given callback function with data, when the amount of entities left in a group drops below amount. 
--? @extdesc Callback parameter data augmented with: _group = EGroup/SGroup group, _amount = Int amount
--? @result EventID
--? @args Function callback, Table data, EGroup/SGroup group, Int amount[, Float delay]
function Event_GroupLeftAlive(callback, data, group, amount, delay)
	local groupType = scartype(group)
	
	data = data or {} -- handle nil data
	data._group = group
	data._amount = amount
		
	local check = nil

	if groupType == ST_SGROUP then
		check = __Event_GroupLeftAlive_SGroup
	elseif groupType == ST_EGROUP then
		check = __Event_GroupLeftAlive_EGroup
	else		
		fatal("Event_GroupLeftAlive recieved a "..scartype_tostring(groupType).." instead of an sgroup or egroup")
	end

	return Event_Add(check, callback, data, delay)
end

function __Event_GroupLeftAlive_SGroup(data)
	return SGroup_TotalMembersCount(data._group, true) <= data._amount
end

function __Event_GroupLeftAlive_EGroup(data)
	return EGroup_Count(data._group) <= data._amount
end

--? @shortdesc Callback given callback function with data, when the egroup is burning 
--? @extdesc Callback parameter data augmented with: _group = EGroup/Entity group/entityID
--? @result EventID
--? @args Function callback, Table data, EGroup/Entity group/entityID[, Float delay]
function Event_GroupBurning(callback, data, group, delay)
	local groupType = scartype(group)
	
	data = data or {} -- handle nil data
	data._group = group
	data._amount = amount
	
	local check = nil

	if groupType == ST_ENTITY or groupType == ST_EGROUP then
		check = __Event_GroupBurning_EGroup
	else
		fatal("Event_GroupLeftAlive recieved a "..scartype_tostring(groupType).." instead of an egroup or entity")
	end

	return Event_Add(check, callback, data, delay)
end

function __Event_GroupBurning_EGroup(data)
	local groupType = scartype(data._group)
	
	if groupType == ST_ENTITY then
		return Entity_IsBurning(data._group)
	elseif groupType == ST_EGROUP then
		return EGroup_IsBurning(data._group, ANY)
	end
end


--? @shortdesc Callback when the number of squads/entities in a group is <= count
--? @extdesc Callback parameter data augmented with: _group = EGroup/SGroup
--? @args ScarFN callback, Table data, EGroup/SGroup group, Int count[, bool spawned, Float delay]
--? @result EventID
function Event_GroupCount(callback, data, group, count, spawned, delay)
	data = data or {}
	data._group = group
	data._count = count
	data._spawned = spawned
	
	return Event_Add(__Event_GroupCount_Check, callback, data, delay)
end

function __Event_GroupCount_Check(data)
	if data._spawned == nil then
		if scartype(data._group) == ST_EGROUP then
			return EGroup_Count(data._group) <= data._count
		elseif scartype(data._group) == ST_SGROUP then
			return SGroup_Count(data._group) <= data._count
		end
	elseif data._spawned == true then
		if scartype(data._group) == ST_EGROUP then
			return EGroup_CountSpawned(data._group) <= data._count
		elseif scartype(data._group) == ST_SGROUP then
			return SGroup_CountSpawned(data._group) <= data._count
		end
	elseif data._spawned == false then
		if scartype(data._group) == ST_EGROUP then
			return EGroup_CountDeSpawned(data._group) <= data._count
		elseif scartype(data._group) == ST_SGROUP then
			return SGroup_CountDeSpawned(data._group) <= data._count
		end
	end
end


--? @shortdesc Trigger a Callback when an encounter is killed. 
--? @extdesc Callback parameter data augmented with: _encounterID, the encounter's reference
--? @args Function callback, Table data, Table encID [, Float delay]
--? @result EventID
function Event_EncounterIsDead(callback, data, encounterID, delay)
	data = data or {} -- handle nil data
	data._encounterID = encounterID
	
	return Event_Add(__Event_EncounterIsDead_Check, callback, data, delay)
end

function __Event_EncounterIsDead_Check(data)
	return (not data._encounterID:IsAlive())
end



--? @shortdesc checks to see if the given event currently exists
--? @result BOOL
--? @args EventID eventID
function Event_Exists(eventID)
	for k,event in ipairs(__Event_eventTable) do
		if event.eventID == eventID then
			return true
		end
	end
	return false
end

--? @shortdesc Remove the given callback
--? @result Void
--? @args EventID eventID
function Event_Remove(eventID)
	-- remove it from add list
	for k, event in ipairs(__Event_eventsToAdd) do		
		if event.eventID == eventID then
			table.remove(__Event_eventsToAdd, k)
			return
		end
	end
	-- flag for removal from event list 
	-- rational: if we're in this list, then we will get processed; but, we may be in the middle of processing, so don't remove yet
	for k,event in ipairs(__Event_eventTable) do
		if event.eventID == eventID then
			event.remove = true
			return
		end
	end
end

--? @shortdesc Remove all existing callback events.
--? @args Bool immediate
--? @result Void
function Event_RemoveAll(immediate)
	if immediate then
		--Simply drop the table and all the associated data.
		__Event_eventTable = {}
		__Event_eventsToAdd = {}
	else
		-- remove it from add list
		for k=#__Event_eventsToAdd, 1, -1 do	
			table.remove(__Event_eventsToAdd, k)
		end
		
		-- flag for removal from event list 
		-- rational: if we're in this list, then we will get processed; but, we may be in the middle of processing, so don't remove yet
		for k,event in ipairs(__Event_eventTable) do
			event.remove = true
		end
	end
end

--Gets an existing event based on the ID. Internal.
function Event_GetEvent(eventID)
	for k,event in ipairs(__Event_eventTable) do
		if event.eventID == eventID then
			return event
		end
	end
	
	--Event might still be in the "toAdd" list.
	for k,event in pairs(__Event_eventsToAdd) do
		if event.eventID == eventID then
			return event
		end
	end
end

---------------------------------------------
-- Team functions
---------------------------------------------


-----------------------------------------------------------
-- Debug functions
-----------------------------------------------------------

--? @shortdesc Toggles the ScarEvent debugger ON and OFF
function Event_ToggleDebug()
	if(Rule_Exists(_ScarEventsDebugger)) then
		Rule_Remove(_ScarEventsDebugger)
		dr_clear("scarEventDebugger")
	else
		Rule_Add(_ScarEventsDebugger)
	end
end

-- Internal rule used to update the ScarEvents information displayed on screen.
function _ScarEventsDebugger()

	local color = { r = 0,	g = 238,	b = 238 } --CYAN
	local ypos = 0.4
	local xpos = 0.6
	local name = "scarEventDebugger"
	local text = ""
	
	dr_clear (name)
	dr_setautoclear(name, false)
	
	--Print the heading
	text = "=============================  SCAR EVENTS (" .. #__Event_eventTable .. ")  ============================="
	dr_text2d(name, xpos, ypos, text, color.r, color.g, color.b)
	
	ypos = ypos + 0.018
	dr_text2d(name, xpos, ypos, "ID", color.r, color.g, color.b) 
	dr_text2d(name, xpos+0.03, ypos, "TYPE", color.r, color.g, color.b)
	dr_text2d(name, xpos+0.14, ypos, "TARGET", color.r, color.g, color.b)
	dr_text2d(name, xpos+0.26, ypos, "CALLBACK", color.r, color.g, color.b)
	
	
	--Cycle through events and print info
	for k,v in pairs(__Event_eventTable) do
		local target = _GetTargetName(v.data._target)
		
		dr_text2d(name, xpos-0.02, ypos+(k*0.02), k, color.r, color.g, color.b) 
		dr_text2d(name, xpos, ypos+(k*0.02), v.eventID, color.r, color.g, color.b) 
		dr_text2d(name, xpos+0.03, ypos+(k*0.02), v.preconditionName, color.r, color.g, color.b)
		dr_text2d(name, xpos+0.14, ypos+(k*0.02), target, color.r, color.g, color.b)
		dr_text2d(name, xpos+0.26, ypos+(k*0.02), v.callbackName, color.r, color.g, color.b)
	end
end

--? @shortdesc Calls the view_manager on a ScarEvent with a specific ID.
--? @args INT eventID
function Event_View(id)
	view(Event_GetEvent(id))
end

-- Internal debug function used to get the string equivalent to a scarEvent's target.
function _GetTargetName(val)
	local target
	if(scartype(val) == ST_SGROUP) then
		target = SGroup_GetName(val)
	elseif(scartype(val) == ST_EGROUP) then
		target = EGroup_GetName(val)
	elseif(scartype(val) == ST_PLAYER) then
		target = "player" .. Player_GetID(val)
	elseif(scartype(val) == ST_MARKER) then
		target = Marker_GetName(val)
	else
		target = "<unidentified>"
	end
	
	return target
end

-- Internal debug function used to announce when a scarEvent is triggered.
function _AnnounceEventTriggered(index)
	if(g_debug) then
		local event = __Event_eventTable[index]
		local text = "EVENT   " .. event.eventID .. "   TRIGGERED!       " .. event.preconditionName .. "    -    " .. _GetTargetName(event.data._target) .. "    -    " .. event.callbackName
		
		dr_setautoclear("scarEventPopup", false)
		dr_text2d("scarEventPopup", 0.6, 0.45+(0.02*#__Event_eventTable), text, 255, 0, 150)
		
		Rule_Remove(_RemoveEventAnnounce)
		Rule_AddOneShot(_RemoveEventAnnounce, 5.0)
	end
end

-- Removes scarEvent announcements after 5 seconds. Restarts count every time _AnnounceEventTriggered is called.
function _RemoveEventAnnounce()
	dr_clear("scarEventPopup")
end

