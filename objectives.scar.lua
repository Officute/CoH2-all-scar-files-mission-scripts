--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- OBJECTIVE FUNCTIONS
-- Provides some wrappers to let us fire-and-forget details about objectives
-- and bypass the internal workings.
--
-- (c) 2005 Relic Entertainment
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--? @group scardoc;Objectives

COUNTER_TimerDecreasing	= 0
COUNTER_TimerIncreasing	= 1
COUNTER_Count			= 2
COUNTER_CountUpTo		= 3

-- ICON TYPES
IT_P_Default 		= "Icons_objectives_objective_primary"
IT_S_Default 		= "Icons_objectives_objective_secondary"
IT_B_Default 		= "Icons_objectives_objective_bonus"

COUNT_UP = 0
COUNT_DOWN = 1

-- SOUND FILES
SOUND_MEDAL_OP			= "ui/stingers/medal_opportunity"

-------------------------------------------------------------------------
-- Objective Helper functions - Outfit Style
-- @degnan
-- The Objective Helper functions are an attempt to centralize
-- all of the separate Objective functions into one set that 
-- can easily be added to or subtracted from as new functions
-- become available and old ones become obsolete.
-- Example of use: C:\WW2\BIA\Root\WW2\Data\Scar\Examples\Outfit_style_Objectives.scar
-------------------------------------------------------------------------

function RegisterObjectiveUpdate()

	g_SitRepObjective = nil
	
	Sound_PreCacheSound(SOUND_MEDAL_OP)
	
	Rule_AddInterval(__UpdateObjectives, 1, 10)
	RegisterObjectiveUpdate = nil
	__t_Objectives = {}
	__t_Objectives_started = {}
	__t_Objectives_completed = {}
	__t_Objectives_failed = {}
end

Scar_AddInit(RegisterObjectiveUpdate)

function __ObjectiveNothing()
end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--? @shortdesc 'Registers' an objective. Wrapper function for Objective_Create with a few other features.
--? @extdesc Includes pings as defined by the objective table created in the main scar file. You can pass in a team or player, so that the objective only applies to it.
--? @args LuaTable objTable[, PlayerID/TeamID owner]
--? @result ObjectiveID
function Objective_Register(objTable, owner)
	
	if scartype(objTable) ~= ST_TABLE then
		print("*** WARNING - objective table not valid! ***")
		return
	end
	
	-- setup empty tables if necessary
	if objTable.Pings == nil then objTable.Pings = {} end
	if objTable.UIElements == nil then objTable.UIElements = {} end
	
	objTable.Counter = {}
	
	local icon = objTable.Icon
	
	if icon == nil then
		-- set the icon according to the objective type
		if objTable.Type == OT_Primary then
			icon = IT_P_Default
		elseif objTable.Type == OT_Secondary then
			icon = IT_S_Default
		elseif objTable.Type == OT_Bonus then
			icon = IT_B_Default
		elseif objTable.Type == OT_Information then
			icon = ""
		end
	end
	
	-- setup cue
	objTable.Cue = {icon = icon, sound = "General_alert"}
	
	objTable.bAlwaysShowTitle = false
	objTable.bAlwaysShowHintpoints = false

	if objTable.Type == nil then
		fatal("Objective_Register: objective needs a 'Type' field! Use OT_Primary, OT_Secondary, OT_Bonus or OT_Information")
	end
	
	if owner == nil then
		
		-- this must be single player
		owner = Game_GetLocalPlayer()
		
	elseif scartype(owner) == ST_NUMBER then
		
		-- assign this objective to the local player on this team
		local localplayer = Game_GetLocalPlayer()
		if Team_IsPlayerOnTeam(localplayer, owner) then
			owner = localplayer
		else
			-- if this objective was for the enemy team, then assign it to one of their players so that it doesn't show up for the local player
			owner = Team_GetPlayers(owner)[1]
		end
		
	end

	local parentID = 0;
	if objTable.Parent ~= nil then
		parentID = objTable.Parent.ID
	end

	--NOTE: CoH2 does not have a TacMap, and thus the 'Description' field is never used.
	if objTable.Description == nil then
		objTable.Description = 0
	end
	
	objTable.ID = Obj_Create(owner, objTable.Title, objTable.Description or Loc_Empty(), icon, objTable.Type, parentID)
	objTable.owner = owner
	
	objTable.playingIntelStart = false
	
	-- register all callbacks
	Obj_SetObjectiveFunction(objTable.ID, FN_OnShow, __ObjectiveOnShowCallback)
	Obj_SetObjectiveFunction(objTable.ID, FN_OnSelect, __ObjectiveOnSelectCallback)
	if objTable.SitRep ~= nil then
		Obj_SetObjectiveFunction(objTable.ID, FN_OnActivate, __ObjectiveOnActivateCallback)
	end
	Obj_SetObjectiveFunction(objTable.ID, FN_OnCounterDisplay, __ObjectiveOnCounterDisplayCallback)
	Obj_SetObjectiveFunction(objTable.ID, FN_LuaTableQuery, __ObjectiveLuaTableQueryCallback)
	
	
	table.insert(__t_Objectives, objTable)
	
	return objTable.ID
	
end


--? @shortdesc Shows an objective to the player and activates it
--? @extdesc Includes pings and FOW as defined by the objective table created in the main scar file.  SkipIntel will skip the defined INTEL_START event.
--? @args LuaTable objTable[, Boolean bShowTitle, Boolean skipIntel]
--? @result Void
function Objective_Start(objTable, bShowTitle, skipIntel)
	
	-- prevent multiple starts
	if objTable.started then
		return
	end
	
	if skipIntel == nil then skipIntel = false end
	
	-- check if the Objective has an Intel_Start
	if objTable.Intel_Start ~= nil and skipIntel ~= true then
		if objTable.Intel_Start_SkipFunc == nil then
			Util_StartIntel(objTable.Intel_Start)
		else
			Util_StartNislet(objTable.Intel_Start, objTable.Intel_Start_SkipFunc)
		end
	end
	
	objTable.playingIntelStart = true
	
	if bShowTitle ~= nil then
		objTable.shouldShowTitleThisTime = bShowTitle
	elseif objTable.showTitle ~= nil then
		objTable.shouldShowTitleThisTime = objTable.showTitle
	else
		objTable.shouldShowTitleThisTime = true
	end
	
	table.insert(__t_Objectives_started, objTable)
	
	
	--Check for a pre-start function
	if(scartype(objTable.PreStart) == ST_FUNCTION) then
		objTable.PreStart()
	end
	
	
	if Rule_Exists(__objectiveDelayedStart) == false then Rule_AddDelayedInterval(__objectiveDelayedStart, 1.5, 1) end

end
	

--? @shortdesc 'Completes' an objective. Wrapper function for Objective_SetState with a few other features. If you do not want the objective title to be shown on screen, pass in 'false' for bShowTitle
--? @extdesc Includes managing the blips and triggers the OnComplete() function as defined by the objective table created in the main scar file.  SkipIntel will skip the defined INTEL_COMPLTE event.
--? @args LuaTable objTable[, Boolean bShowTitle, Boolean skipIntel]
--? @result Void
function Objective_Complete(objTable, bShowTitle, skipIntel)

	-- only complete it once
	if Obj_GetState(objTable.ID) == OS_Complete or Obj_GetState(objTable.ID) == OS_Failed or objTable.playingIntelComplete then
		return
	end
	
	if skipIntel == nil then skipIntel = false end
	
	-- hide all minimap blips once it's been completed
	__ShowObjectiveBlips(objTable, false)
	
	-- remove all UI elements
	while table.getn(objTable.UIElements) > 0 do
		Objective_RemoveUIElements(objTable, objTable.UIElements[1].ElementID)
	end
	
	-- usability tracking information to show the time that an objective was completed in the scarlog
	local timex = World_GetGameTime()
	if timex >= 60 then
		timex = math.floor(timex/60)
	else
		timex = 1
	end
	
	if scartype(objTable.Title) == ST_NUMBER then
		print("########## OBJECTIVE COMPLETION TIME: "..Loc_ToAnsi(objTable.Title).." "..timex.." minutes #########")
	end

--~ 	Obj_SetState(objTable.ID, OS_Complete)
	
	-- stop any active timers or counters
	Objective_StopTimer(objTable)
	Objective_StopCounter(objTable)
	
	-- check if the Objective has an Intel_Complete
	if objTable.Intel_Complete ~= nil and skipIntel ~= true then
		if objTable.Intel_Complete_SkipFunc == nil then
			Util_StartIntel(objTable.Intel_Complete)
		else
			Util_StartNislet(objTable.Intel_Complete, objTable.Intel_Complete_SkipFunc)
		end
	end
	
	objTable.playingIntelComplete = true
	
	if bShowTitle ~= nil then
		objTable.shouldShowTitleThisTime = bShowTitle
	elseif objTable.showTitle ~= nil then
		objTable.shouldShowTitleThisTime = objTable.showTitle
	else
		objTable.shouldShowTitleThisTime = true
	end
	
	table.insert(__t_Objectives_completed, objTable)
	
	--Check for a pre-complete function
	if(scartype(objTable.PreComplete) == ST_FUNCTION) then
		objTable.PreComplete()
	end
	
	if Rule_Exists(__objectiveDelayedComplete) == false then Rule_Add(__objectiveDelayedComplete) end
	
end


--? @shortdesc 'Fails' an objective. Wrapper function for Objective_SetState with a few other features.
--? @extdesc Includes managing the blips and triggers the OnFail() function as defined by the objective table created in the main scar file. SkipIntel will skip the defined INTEL_FAIL event.
--? @args LuaTable objTable[, Boolean bShowTitle, Boolean skipIntel]
--? @result Void
function Objective_Fail(objTable, bShowTitle, skipIntel)

	if Obj_GetState(objTable.ID) == OS_Complete or objTable.playingIntelFail then
		return
	end
	
	if skipIntel == nil then skipIntel = false end
	
	__ShowObjectiveBlips(objTable, false)
	
	while table.getn(objTable.UIElements) > 0 do
		Objective_RemoveUIElements(objTable, objTable.UIElements[1].ElementID)
	end
	
	-- check if the Objective has an Intel_Fail
	if objTable.Intel_Fail ~= nil and skipIntel ~= true then
		if objTable.Intel_Fail_SkipFunc == nil then
			Util_StartIntel(objTable.Intel_Fail)
		else
			Util_StartNislet(objTable.Intel_Fail, objTable.Intel_Fail_SkipFunc)
		end
	end
	
	objTable.playingIntelFail = true
	
	if bShowTitle ~= nil then
		objTable.shouldShowTitleThisTime = bShowTitle
	elseif objTable.showTitle ~= nil then
		objTable.shouldShowTitleThisTime = objTable.showTitle
	else
		objTable.shouldShowTitleThisTime = true
	end
	
	table.insert(__t_Objectives_failed, objTable)
	
	--Check for a pre-fail function
	if(scartype(objTable.PreFail) == ST_FUNCTION) then
		objTable.PreFail()
	end
	
	if Rule_Exists(__objectiveDelayedFail) == false then Rule_Add(__objectiveDelayedFail) end
	
end


--? @shortdesc Shows or hides an objective from the UI and tactical map
--? @args LuaTable objective_table, Boolean on/off	
--? @result Void
function Objective_Show(objTable, show)
	
	Obj_SetVisible(objTable.ID, show)
	
end

--? @shortdesc Toggles minimap blips on or off.
--? @args LuaTable objective_table, Boolean on/off	
--? @result Void
function Objective_TogglePings( objTable, boolean )

	__ShowObjectiveBlips(objTable, boolean)

end

--? @shortdesc Adds multiple UI elements on one position. 'pos' can be group/entity/squad/marker. worldArrow adds a 3D arrow which points to the thing in the world. hintpointText adds a hint point that appears on the thing when moused over. If you're adding an arrow or a hintpoint, this thing will be among those potentially pointed to by the 2D HUD arrow. objectiveArrowOffset is an offset applied to the arrow's position (you can specify a height offset or a 3D position offset).
--? @args LuaTable objTable, Position pos[, Boolean ping, LocString hintpointText, Boolean worldArrow, Float/Position objectiveArrowOffset, Entity/Squad/Position objectiveArrowFacing, HintPointActionType actionType, String iconName]
--? @result ElementID
function Objective_AddUIElements(objTable, pos, ping, hintpointText, worldArrow, objectiveArrowOffset, objectiveArrowFacing, actionType, iconName)

	if Game_GetLocalPlayer() ~= objTable.owner then
		return -1
	end
	
	if pos == nil then
		fatal("Objective_AddUIElements: 'pos' is nil!")
	end
	
	if ping == nil then
		ping = false
	end
	
	if hintpointText == nil then
		hintpointText = false
	end
	
	if worldArrow == nil then
		worldArrow = false
	end
	
	if scartype(objectiveArrowOffset) == ST_BOOLEAN then
		fatal("Objective_AddUIElements: Arrow Offset variable (6th value) must be a number or position")
	end
	
	-- set default arrow offset
	if objectiveArrowOffset == nil then 
		if (scartype(pos) == ST_SGROUP and World_OwnsSGroup(pos, ANY) == false) or (scartype(pos) == ST_SQUAD and World_OwnsSquad(pos) == false) then
			objectiveArrowOffset = 3
		else
			objectiveArrowOffset = 0
		end
	end
	
	-- turn height offset into 3d offset
	if scartype(objectiveArrowOffset) == ST_NUMBER then
		objectiveArrowOffset = World_Pos(0,objectiveArrowOffset,0)
	end
	
	--Default actionType set to Objective.
	if actionType == nil then
		actionType = HPAT_Objective
	end
	
	--Default icon set to None
	if iconName == nil then
		iconName = ""
	end
	
	local elementTable = {}
	
	if ping ~= false then
		elementTable.PingID = Objective_AddPing(objTable, pos, 10)
	end
	
	-- highlight this in the world?
	elementTable.HighlightedEntities = {} -- stores { eid, hintid }
	elementTable.HighlightedSquads = {} -- stores { sid, hintid }
	elementTable.HighlightedPositions = {} -- stores { pos, hintid }
	
	local posType = scartype(pos)
	if posType == ST_ENTITY then
		
		__HighlightEntity(objTable.ID, elementTable, pos, hintpointText, worldArrow, objectiveArrowOffset, objectiveArrowFacing, actionType, iconName)
		
	elseif posType == ST_SQUAD then
		
		__HighlightSquad(objTable.ID, elementTable, pos, hintpointText, worldArrow, objectiveArrowOffset, objectiveArrowFacing, actionType, iconName)
		
	elseif posType == ST_EGROUP then
		
		local _HighlightOneEntity = function(gid, idx, eid)
			__HighlightEntity(objTable.ID, elementTable, eid, hintpointText, worldArrow, objectiveArrowOffset, objectiveArrowFacing, actionType, iconName)
		end
		EGroup_ForEachEx(pos, _HighlightOneEntity, true, false)
		
	elseif posType == ST_SGROUP then
		
		local _HighlightOneSquad = function(gid, idx, sid)
			__HighlightSquad(objTable.ID, elementTable, sid, hintpointText, worldArrow, objectiveArrowOffset, objectiveArrowFacing, actionType, iconName)
		end
		SGroup_ForEachEx(pos, _HighlightOneSquad, true, false)
		
	elseif posType == ST_MARKER then
		
		-- GTA style "cone of light" ?
		__HighlightPosition(objTable.ID, elementTable, Marker_GetPosition(pos), hintpointText, worldArrow, objectiveArrowOffset, objectiveArrowFacing, actionType, iconName)
		
	elseif posType == ST_SCARPOS then
		
		-- ???
		__HighlightPosition(objTable.ID, elementTable, pos, hintpointText, worldArrow, objectiveArrowOffset, objectiveArrowFacing, actionType, iconName)
		
	end
	
	-- give this group an ID so it can be removed
	if objTable.NextElementID == nil then
		objTable.NextElementID = 1
	end
	
	elementTable.ElementID = objTable.NextElementID
	objTable.NextElementID = objTable.NextElementID + 1
	
	table.insert(objTable.UIElements, elementTable)
	
	return elementTable.ElementID
	
end

--? @shortdesc Removes a group of UI elements that were added by Objective_AddUIElements
--? @args LuaTable objTable, Integer elementID
--? @result Void
function Objective_RemoveUIElements(objTable, elementID)

	if objTable.UIElements == nil then
		return
	end
		
	for i = table.getn(objTable.UIElements), 1, -1 do
		
		local v = objTable.UIElements[i]
		if v.ElementID == elementID then
			
			-- try deleting each type of UI element (if nil, will fail silently)
			Objective_RemovePing(objTable, v.PingID)
			
			-- remove world highlights
			for j = 1, table.getn(v.HighlightedEntities) do
				
				local entityid = v.HighlightedEntities[j].eid
				if Entity_IsValid(entityid) then
					local entity = Entity_FromWorldID(entityid)
					Obj_HighlightEntity(objTable.ID, entity, false)
				end
				
				local hintid = v.HighlightedEntities[j].hintid
				if hintid ~= nil then
					HintPoint_Remove(hintid)
				end
				
			end
			
			for j = 1, table.getn(v.HighlightedSquads) do
				
				local squadid = v.HighlightedSquads[j].sid
				if Squad_IsValid(squadid) then
					local squad = Squad_FromWorldID(squadid)
					if Squad_Count(squad) > 0 then
						Obj_HighlightSquad(objTable.ID, squad, false)
					end
				end
				
				local hintid = v.HighlightedSquads[j].hintid
				if hintid ~= nil then
					HintPoint_Remove(hintid)
				end
				
			end
			
			for j = 1, table.getn(v.HighlightedPositions) do
				
				local pos = v.HighlightedPositions[j].pos
				Obj_HighlightPosition(objTable.ID, pos, false)
				
				local hintid = v.HighlightedPositions[j].hintid
				if hintid ~= nil then
					HintPoint_Remove(hintid)
				end
				
			end
			
			-- forget all about it
			table.remove(objTable.UIElements, i)
			return
			
		end
		
	end
	
end

--? @shortdesc Adds a tactical map ping to an objective
--? @result PingID
--? @args LuaTable objectiveTable, Position pos
function Objective_AddPing(objTable, pos)
	
	if Game_GetLocalPlayer() ~= objTable.owner then
		return -1
	end
	
	-- convert entities and squads to groups so that their death does not access invalid objects
	local groupcaller = __GetGroupCaller(pos)
	local type = scartype(pos)
	if type == ST_ENTITY or type == ST_SQUAD then
		local group = groupcaller.CreateIfNotFound("eg_temp_OBJ_" .. objTable.ID .. "_" .. groupcaller.GetGameID(pos))
		groupcaller.ClearItems(group)
		groupcaller.AddItem(group, pos)
		pos = group
	end
	
	local newPing = { pos = pos }
	table.insert(objTable.Pings, newPing)
	
	-- show it on minimap right away
	__ShowSingleBlip(objTable, newPing, true)
	
	return newPing.BlipID
end

--? @shortdesc Removes a tactical map ping from an objective
--? @result Void
--? @args LuaTable objectiveTable, Integer PingID
function Objective_RemovePing(objTable, pingID)

	-- delete the minimap blip too
	-- uhhh, BlipID is stored in the same table entry as the PingID, so we must find it manually in order to retrieve the BlipID

	for i = 1, table.getn(objTable.Pings) do
		
		-- find the entry for the ping, and it will have the blip ID as well
		local entry = objTable.Pings[i]
		if entry.BlipID ~= nil and entry.BlipID == pingID then
			
			UI_DeleteMinimapBlip(entry.BlipID)
			table.remove(objTable.Pings, i)
			break
			
		end
	end
	
end

--? @shortdesc Returns whether an objective is complete
--? @args LuaTable objTable
--? @result Boolean
function Objective_IsComplete(objTable)

	if Obj_GetState(objTable.ID) == OS_Complete then
		return true
	else
		return false
	end

end

--? @shortdesc Returns whether an objective is failed
--? @args LuaTable objTable
--? @result Boolean
function Objective_IsFailed(objTable)

	if Obj_GetState(objTable.ID) == OS_Failed then
		return true
	else
		return false
	end
	
end

--? @shortdesc Returns whether an objective has been started. Completed objectives will return true.
--? @args LuaTable objTable
--? @result Boolean
function Objective_IsStarted(objTable)

	if objTable.started == true then
		return true
	else
		return false
	end
	
end

--? @shortdesc Returns whether an objective is visible or not.
--? @args LuaTable objTable
--? @result Boolean
function Objective_IsVisible(objTable)

	if Obj_GetVisible(objTable.ID) == true then
		return true
	else
		return false
	end
	
end

--? @shortdesc Returns whether all primary objectives have been completed.
--? @args none
--? @result Boolean
function Objective_AreAllPrimaryObjectivesComplete()

	local bAnyPrimaryObjectives = false
	
	for k, v in pairs(__t_Objectives) do
		
		if v.Type == OT_Primary then
			
			bAnyPrimaryObjectives = true
			if not Objective_IsComplete(v) then
				return false
			end
			
		end
		
	end
	
	-- if there were not any primary objectives found, then treat it as not all of them being completed
	return bAnyPrimaryObjectives
	
end

--? @shortdesc Updates the title and description for the objective. If you only want to set one of them, pass in nil for the other
--? @args LuaTable objTable, LocString title, LocString description[, Boolean bShowTitle]
--? @result Void
function Objective_UpdateText(objTable, title, description, bShowTitle)

	if title ~= nil then
		objTable.Title = title
		Obj_SetTitle(objTable.ID, title)
		
		if bShowTitle == nil then
			bShowTitle = true
		end
		
		if bShowTitle ~= false then
			local title = Loc_FormatText(39307, title)
			__createPopup(objTable.ID, title)
			--Util_MissionTitle( title )
		end
	end
	
	if description ~= nil then
		objTable.Description = description
		Obj_SetDescription(objTable.ID, description)
	end
	
end


--? @shortdesc Starts a timer that is associated with this objective in the UI. Use COUNT_DOWN or COUNT_UP for the 'direction' parameter
--? @args LuaTable objTable, Integer direction[, Float initialTime, Float flashThreshold]
--? @result Void
function Objective_StartTimer(objTable, direction, initialTime, flashThreshold)
	
	local previousFlashID = objTable.Counter.FlashID
	Objective_StopTimer(objTable)
	objTable.Counter.TimerID = objTable.ID + 1000
	objTable.Counter.FlashThreshold = flashThreshold
	objTable.Counter.FlashID = previousFlashID
	
	if direction == COUNT_UP then
		
		objTable.Counter.Type = COUNTER_TimerIncreasing
		Timer_Start(objTable.Counter.TimerID, 9999)
		if initialTime ~= nil then
			Timer_Advance(objTable.Counter.TimerID, initialTime)
		end
		
	elseif direction == COUNT_DOWN then
		
		objTable.Counter.Type = COUNTER_TimerDecreasing
		Timer_Start(objTable.Counter.TimerID, initialTime)
		
	else
		fatal("Objective_StartTimer: 'direction' is not valid; use COUNT_UP or COUNT_DOWN")
	end
	
end


--? @shortdesc Pauses the objective's timer. If a timer has not been set, it does nothing.
--? @args LuaTable objTable
--? @result Void
function Objective_PauseTimer(objTable)

	if Objective_IsTimerSet(objTable) then
		Timer_Pause(objTable.Counter.TimerID)
	end

end


--? @shortdesc Resume the objective's timer. If a timer has not been set, it does nothing.
--? @args LuaTable objTable
--? @result Void
function Objective_ResumeTimer(objTable)

	if Objective_IsTimerSet(objTable) then
		Timer_Resume(objTable.Counter.TimerID)
	end

end


--? @shortdesc Stops the objective's timer. If a timer has not been set, it does nothing.
--? @args LuaTable objTable
--? @result Void
function Objective_StopTimer(objTable)

	if Objective_IsTimerSet(objTable) then
		Timer_End(objTable.Counter.TimerID)
		objTable.Counter = {}
	end

end

--? @shortdesc Returns the amount of seconds on the timer (time remaining or time elapsed, based on the type of timer used)
--? @args LuaTable objTable
--? @result Integer
function Objective_GetTimerSeconds(objTable)

	if objTable.Counter.Type == COUNTER_TimerIncreasing then
		
		return Timer_GetElapsed(objTable.Counter.TimerID)
		
	elseif objTable.Counter.Type == COUNTER_TimerDecreasing then
		
		return Timer_GetRemaining(objTable.Counter.TimerID)
		
	else	
		fatal("Objective_GetTimerSeconds: no timer set!")
	end
	
end

--? @shortdesc Returns true if a timer has been set for this objective
--? @args LuaTable objTable
--? @result Boolean
function Objective_IsTimerSet(objTable)

	if objTable.Counter == nil then
		return false
	end
	
	return objTable.Counter.Type == COUNTER_TimerIncreasing or objTable.Counter.Type == COUNTER_TimerDecreasing
end

--? @shortdesc Sets a counter that is associated with this objective in the UI. You can provide a 'maximum' so that it shows up as "1 of 5"
--? @args LuaTable objTable, Float current[, Float maximum]
--? @result Void
function Objective_SetCounter(objTable, current, maximum)

	Objective_StopTimer(objTable)
	
	objTable.Counter.Count = current
	
	if maximum == nil then
		-- basic counter
		objTable.Counter.Type = COUNTER_Count
	else
		-- counter with maximum (ex: 2 of 5)
		objTable.Counter.Type = COUNTER_CountUpTo
		objTable.Counter.Maximum = maximum
	end
	
end

--? @shortdesc Increases the counter that is associated with this objective in the UI. You can provide an amount to increase by.
--? @args LuaTable objTable[, Int amount]
--? @result Void
function Objective_IncreaseCounter(objTable, amount)
	if Objective_IsCounterSet(objTable) then
		amount = amount or 1
		Objective_SetCounter(objTable, objTable.Counter.Count+amount, objTable.Counter.Maximum)
	else
		fatal("Objective_IncreaseCounter: no counter set!")
	end
end

--? @shortdesc Stops the objective's counter. If a counter has not been set, it does nothing.
--? @args LuaTable objTable
--? @result Void
function Objective_StopCounter(objTable)

	if Objective_IsCounterSet(objTable) then
		objTable.Counter = {}
	end
	
end

--? @shortdesc Returns the current count associated with this objective.
--? @args LuaTable objTable
--? @result Integer
function Objective_GetCounter(objTable)

	if Objective_IsCounterSet(objTable) then
		return objTable.Counter.Count
	else
		fatal("Objective_GetCounter: no counter set!")
	end
	
end

--? @shortdesc Returns true if a counter has been set for this objective
--? @args LuaTable objTable
--? @result Boolean
function Objective_IsCounterSet(objTable)

	if objTable.Counter == nil then
		return false
	end
	
	return objTable.Counter.Type == COUNTER_Count or objTable.Counter.Type == COUNTER_CountUpTo
	
end

--? @shortdesc Sets whether this objective always shows detailed text, the HUD arrow, or the hintpoints. There can only be one objective at a time that forces the HUD arrow to show up. If you pass in 'nil' for hud_arrow then its behavior is not affected.
--? @args LuaTable objTable, Boolean title, Boolean hud_arrow, Boolean hintpoints
--? @result Void
function Objective_SetAlwaysShowDetails(objTable, title, hud_arrow, hintpoints)

	objTable.bAlwaysShowTitle = title
	objTable.bAlwaysShowHintpoints = hintpoints
	
	if hud_arrow == true then
		UI_ForceHudArrowOnObjective(objTable.ID)
	elseif hud_arrow == false then
		UI_ForceHudArrowOnObjective(0)
	end
	
end

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

--
-- private functions
--

function __ObjectiveOnShowCallback(id)
	
	local objTable = __FindObjectiveTable(id)
	
	-- only show pings for incomplete objectives
	if Obj_GetState(objTable.ID) ~= OS_Incomplete then
		return
	end
	
	-- show all pings for this objective
	for k, v in pairs(objTable.Pings) do
		
		if v.TacMapID == nil then
			-- ignore empty groups
			if not ((scartype(v.pos) == ST_EGROUP and EGroup_IsEmpty(v.pos)) or (scartype(v.pos) == ST_SGROUP and SGroup_IsEmpty(v.pos))) then
				v.TacMapID = UI_CreateMinimapBlip( v.pos, -1, __GetBlipType(objTable) )
			end
		end
		
	end
	
end

function __ObjectiveOnSelectCallback(id)

end

function __ObjectiveOnActivateCallback(id)

	local objTable = __FindObjectiveTable(id)
	
end

function __ObjectiveOnCounterDisplayCallback(id)

	local objTable = __FindObjectiveTable(id)
	local counter = objTable and objTable.Counter or nil
	if counter == nil or counter.Type == nil then
		return 0
	end
	
	-- "Error"
	local strResult = 2700
	
	if Objective_IsTimerSet(objTable) then
	--if counter.Type == COUNTER_TimerIncreasing or counter.Type == COUNTER_TimerDecreasing then
		
		strResult = Loc_FormatTime(math.floor(Objective_GetTimerSeconds(objTable)), false, false)
		
	elseif counter.Type == COUNTER_Count then
		
		strResult = Loc_ConvertNumber(counter.Count)
		
	elseif counter.Type == COUNTER_CountUpTo then
		
		local strNumCurrent = Loc_ConvertNumber(counter.Count)
		local strNumMax = Loc_ConvertNumber(counter.Maximum)
		strResult = Loc_FormatText(39320, strNumCurrent, strNumMax)
		
	end
	
	if strResult == 2700 then
		print("__ObjectiveOnCounterDisplayCallback (objectives): unexpected counter type: " .. counter.Type)
	end
	
	return strResult
	
end

function __ObjectiveLuaTableQueryCallback(id, arg1)

	local objTable = __FindObjectiveTable(id)
	
	if arg1 == "always_show_title" then
		if Game_GetSPDifficulty() == GD_EASY or Game_GetSPDifficulty() == GD_NORMAL then return 1 end
		if objTable.bAlwaysShowTitle == true then return 1 else return 0 end
	elseif arg1 == "always_show_hintpoints" then
		if Game_GetSPDifficulty() == GD_EASY or Game_GetSPDifficulty() == GD_NORMAL then return 1 end
		if objTable.bAlwaysShowHintpoints == true then return 1 else return 0 end
	end
	
	return -1
	
end

function __UpdateObjectives()

	for k, v in pairs(__t_Objectives) do
		
		local objTable = v
		if objTable.owner == Game_GetLocalPlayer() then
			
			--If the objective started, but hasn't been displayed yet, display it.
			if 	objTable.started == true and objTable.Displayed ~= true 
				and Event_IsAnyRunning() == false and UI_IsTacticalMapShown() == false then
				
					objTable.Displayed = true
					__DoObjectiveStartUI(objTable)
			end
			
			
			-- Update flashing timers --TODO: Improve this logic
			if v.Counter.FlashThreshold then
				
				-- comparison functions. they return whether the threshold has been reached
				local _TimerIncComparison = function(objTable, val)
					return val >= objTable.Counter.FlashThreshold
				end
				
				local _TimerDecComparison = function(objTable, val)
					return val <= objTable.Counter.FlashThreshold
				end
				
				local comp
				local counter
				if v.Counter.Type == COUNTER_TimerIncreasing then
					
					comp = _TimerIncComparison
					counter = Objective_GetTimerSeconds(v)
					
				elseif v.Counter.Type == COUNTER_TimerDecreasing then
					
					comp = _TimerDecComparison
					counter = Objective_GetTimerSeconds(v)
					
				elseif v.Counter.Type == COUNTER_Count then
					
				elseif v.Counter.Type == COUNTER_CountUpTo then
					
				end
				
				
				if comp and comp(v, counter) then
					-- we hit the threshold, so start flashing using widget animation
					if v.Counter.FlashID == nil then
						v.Counter.FlashID = UI_FlashObjectiveCounter(v.ID)
					end
					
				elseif comp and not comp(v, counter) then
					
					-- if the counter is not beyond the threshold anymore, stop flashing
					if v.Counter.FlashID ~= nil then	
						UI_StopFlashing(v.Counter.FlashID)
						v.Counter.FlashID = nil
					end
					
				end
				
			end
			
		end
		
	end

end

function __FindObjectiveTable(id)

	if __t_Objectives ~= nil then
		for k, v in pairs(__t_Objectives) do
			if v.ID == id then
				return v
			end
		end
	end
	
	-- is this redundant in Lua?
	return nil
	
end

function __GetBlipType(objTable)

	if objTable.Type == OT_Primary then
		return BT_ObjectivePrimary
	elseif objTable.Type == OT_Secondary then
		return BT_ObjectiveSecondary
	elseif objTable.Type == OT_Bonus then
		return BT_ObjectiveBonus
	end
	
	return BT_General
	
end

function __ShowSingleBlip(objTable, ping, bShow)

	if bShow == true then
		
		-- only create it if it doesn't exist yet
		if ping.BlipID == nil then
			ping.BlipID = UI_CreateMinimapBlip(ping.pos, -1, __GetBlipType(objTable))
		end
		
	else
		
		-- only delete it if it already exists
		if ping.BlipID ~= nil then
			UI_DeleteMinimapBlip(ping.BlipID)
			ping.BlipID = nil
		end
		
	end
	
end

function __ShowObjectiveBlips(objTable, bShow)

	for k, v in pairs(objTable.Pings) do
		__ShowSingleBlip(objTable, v, bShow)
	end
	
end

function __HighlightEntity(objID, elementTable, entity, hintpoint, arrow, arrowOffset, arrowFacing, actionType, iconName)

	if hintpoint ~= false or arrow == true then
		Obj_HighlightEntity(objID, entity, true)
	end
	
	local hintpointLocID = hintpoint
	if hintpointLocID == false then
		hintpointLocID = 0
	end
	
	-- the "3d arrow" is tied to a hintpoint, so if no hintpoint is requested we just create one anyway and hide it.
	local hintid = HintPoint_AddToEntity(entity, 1, hintpoint ~= false, __ObjectiveNothing, hintpointLocID, arrow, arrowOffset, objID, actionType, iconName, true)
	
	if arrowFacing ~= nil then
		if scartype(arrowFacing) == ST_MARKER then
			arrowFacing = Util_GetPosition(arrowFacing)
		end
		
		if scartype(arrowFacing) == ST_ENTITY then	
			HintPoint_SetFacingEntity(hintid, arrowFacing)
		elseif scartype(arrowFacing) == ST_SQUAD then
			HintPoint_SetFacingSquad(hintid, arrowFacing)
		elseif scartype(arrowFacing) == ST_SCARPOS then
			HintPoint_SetFacingPosition(hintid, arrowFacing)
		end
	end
	
	table.insert(elementTable.HighlightedEntities, { eid = Entity_GetGameID(entity), hintid = hintid } )

end

function __HighlightSquad(objID, elementTable, squad, hintpoint, arrow, arrowOffset, arrowFacing, actionType, iconName)

	if Squad_Count(squad) > 0 then
		if hintpoint ~= false or arrow == true then
			Obj_HighlightSquad(objID, squad, true)
		end
		
		local hintpointLocID = hintpoint
		if hintpointLocID == false then
			hintpointLocID = 0
		end
		
		-- the "3d arrow" is tied to a hintpoint, so if no hintpoint is requested we just create one anyway and hide it.
		local hintid = HintPoint_AddToSquad(squad, 1, hintpoint ~= false, __ObjectiveNothing, hintpointLocID, arrow, arrowOffset, objID, actionType, iconName, true)
		
		if arrowFacing ~= nil then
			if scartype(arrowFacing) == ST_MARKER then
				arrowFacing = Util_GetPosition(arrowFacing)
			end
			
			if scartype(arrowFacing) == ST_ENTITY then	
				HintPoint_SetFacingEntity(hintid, arrowFacing)
			elseif scartype(arrowFacing) == ST_SQUAD then
				HintPoint_SetFacingSquad(hintid, arrowFacing)
			elseif scartype(arrowFacing) == ST_SCARPOS then
				HintPoint_SetFacingPosition(hintid, arrowFacing)
			end
		end
		
		table.insert(elementTable.HighlightedSquads, { sid = Squad_GetGameID(squad), hintid = hintid } )
	end
	
end

function __HighlightPosition(objID, elementTable, pos, hintpoint, arrow, arrowOffset, arrowFacing, actionType, iconName)

	if hintpoint ~= false or arrow == true then
		Obj_HighlightPosition(objID, pos, true)
	end

	local hintpointLocID = hintpoint
	if hintpointLocID == false then
		hintpointLocID = 0
	end
	
	-- the "3d arrow" is tied to a hintpoint, so if no hintpoint is requested we just create one anyway and hide it.
	local hintid = HintPoint_AddToPosition(pos, 1, hintpoint ~= false, __ObjectiveNothing, hintpointLocID, arrow, arrowOffset, objID, actionType, iconName, true)
	
	if arrowFacing ~= nil then
		if scartype(arrowFacing) == ST_MARKER then
			arrowFacing = Util_GetPosition(arrowFacing)
		end
		
		if scartype(arrowFacing) == ST_ENTITY then	
			HintPoint_SetFacingEntity(hintid, arrowFacing)
		elseif scartype(arrowFacing) == ST_SQUAD then
			HintPoint_SetFacingSquad(hintid, arrowFacing)
		elseif scartype(arrowFacing) == ST_SCARPOS then
			HintPoint_SetFacingPosition(hintid, arrowFacing)
		end
	end
	
	table.insert(elementTable.HighlightedPositions, { pos = pos, hintid = hintid } )
	
end

function __DoObjectiveStartUI(objTable)

	--[[ moved from Objective_Start ]]
	
	-- setup initial UI elements
	if objTable.SetupUI ~= nil then
		objTable.SetupUI()
	end
	
	-- add blips
	__ShowObjectiveBlips(objTable, true)
	
	-- FOW
	if objTable.FOW ~= nil then
		
		for m, p in pairs(objTable.FOW) do
			
			local duration = p.duration
			if duration == nil then duration = 20 end
			
			local type = scartype(p.target)
			if type == ST_ENTITY then
				FOW_RevealEntity(p.target, duration)
			elseif type == ST_MARKER then
				FOW_RevealMarker(p.target, duration)
			elseif type == ST_SCARPOS then
				error("Objective_Start: positions are not valid FOW reveal types (use marker instead)")
			elseif type == ST_EGROUP then
				FOW_RevealEGroup(p.target, duration)
			elseif type == ST_SGROUP then
				FOW_RevealSGroup(p.target, duration)
			elseif type == ST_SQUAD then
				FOW_RevealSquad(p.target, duration)
			else
				error("Objective_Start: invalid FOW type")
			end
			
		end
		
	end
	
	local bShowTitle = objTable.shouldShowTitleThisTime
	
	if bShowTitle ~= false then
		
		local title = objTable.Title
		if objTable.DisplayTitleStart ~= nil then
			title = objTable.DisplayTitleStart
		end
		
		-- flash title card (replace with localized text)
		if objTable.Type == OT_Primary or objTable.Type == OT_Secondary or objTable.Type == OT_Bonus then
			if objTable.Type == OT_Bonus then
				title = Loc_FormatText(11080213, title)	-- prepend "Bonus Objective: " to the objective title in the popup
			end
			__createPopup(objTable.ID, title)
		elseif objTable.Type ~= OT_Information then
			fatal("Objective_Start: invalid objective type!")
		end
	end


end


function __objectiveDelayedStart()
	
	if table.getn(__t_Objectives_started) == 0 then 
		Rule_RemoveMe() 
		return
	end
	
	for k, this in pairs(__t_Objectives_started) do
		
		if this.playingIntelStart == true then
			
			if this.Intel_Start == nil or (this.Intel_Start ~= nil and Event_IsRunning(this.Intel_Start) == false and Event_IsQueued(this.Intel_Start) == false) then
				this.playingIntelStart = false
				
				-- grant obj
				Obj_SetVisible(this.ID, true)
				Obj_SetState(this.ID, OS_Incomplete)
				
				-- skip any events playing to allow the Objective to play
				if Event_IsAnyRunning() then
					--Event_Skip()
				end
				
				if this.OnStart ~= nil then
					this.OnStart()
				end
				
				--[[ added to delay titlecards and other actions until after any events have played ]]
--~ 				this.showtitle = bShowTitle
				
				-- if not showing the title, then it's a silent start. do the UI setup right away instead of delaying it
				if this.showTitle == false then
					
					__DoObjectiveStartUI(__t_Objectives_started[k])
					
					this.Displayed = true -- don't do the delayed UI start
					
				end
				
				this.started = true
				
				table.remove(__t_Objectives_started, k)
				
			end
			
		end
		
	end

end

function __createPopup( objectiveID, title )
	
	local popup = function()
		CTRL.Obj_CreatePopup( objectiveID, title )
		CTRL.WAIT()
	end
	
	-- we will try it as an Intel Event first
	-- the IE's and NIS's have different sets of priorities
	Util_StartIntel(popup)
end

function __objectiveDelayedComplete()

	if table.getn(__t_Objectives_completed) == 0 then 
		Rule_RemoveMe() 
		return
	end
	
	for k, this in pairs(__t_Objectives_completed) do
		
		if this.playingIntelComplete == true then
			
			if this.Intel_Complete == nil or (this.Intel_Complete ~= nil and Event_IsRunning(this.Intel_Complete) == false and Event_IsQueued(this.Intel_Complete) == false) then
				
				this.playingIntelComplete = false
				
				-- perform the complete tasks
				if this.OnComplete ~= nil then
					this.OnComplete()
				end
				
				Obj_SetState(this.ID, OS_Complete)
				
				-- flash title card
				if Game_GetLocalPlayer() == this.owner and this.shouldShowTitleThisTime ~= false then
					
					-- some objs want a different closing message
					local objtitle = this.Title
					if this.TitleEnd ~= nil then
						objtitle = this.TitleEnd
					end
						
					if this.Type == OT_Primary or this.Type == OT_Secondary or this.Type == OT_Bonus then
						local title = Loc_FormatText(39300, objtitle)
						__createPopup( this.ID, title )
					elseif this.Type ~= OT_Information then
						fatal("Objective_Complete: invalid objective type!")
					end
					
--~ 					Obj_SetState(this.ID, OS_Complete)
--~ 					table.remove(__t_Objectives_completed, k)
					
				end
				table.remove(__t_Objectives_completed, k)
				
				-- If the objective is a parent, remove it
				if this.Parent == nil then
					Obj_SetVisible(this.ID, false)
				end
				
			end
			
		end
		
	end

end


function __objectiveDelayedFail()

	if table.getn(__t_Objectives_failed) == 0 then 
		Rule_RemoveMe() 
		return
	end
	
	for k, this in pairs(__t_Objectives_failed) do
		
		if this.playingIntelFail == true then
			
			if this.Intel_Fail == nil or (this.Intel_Fail ~= nil and Event_IsRunning(this.Intel_Fail) == false and Event_IsQueued(this.Intel_Fail) == false) then
				this.playingIntelFail = false
				
				-- perform the fail tasks
				if this.OnFail ~= nil then
					this.OnFail()
				end
				
				Obj_SetState(this.ID, OS_Failed)
				
				-- flash title card
				if Game_GetLocalPlayer() == this.owner and this.shouldShowTitleThisTime ~= false then
					
					local titleText = nil
					if this.TitleFail ~= nil then
						titleText = this.TitleFail
					else
						titleText = this.Title
					end
					
					if this.Type == OT_Primary or this.Type == OT_Secondary or this.Type == OT_Bonus then
						local title = Loc_FormatText(39301, titleText)
						__createPopup( this.ID, title )
					elseif this.Type ~= OT_Information then
						fatal("Objective_Start: invalid objective type!")
					end
					
					table.remove(__t_Objectives_failed, k)
					
					-- If the objective is a parent, remove it
					if this.Parent == nil then
						Obj_SetVisible(this.ID, false)
					end
					
				end
				
			end
			
		end
		
	end

end
