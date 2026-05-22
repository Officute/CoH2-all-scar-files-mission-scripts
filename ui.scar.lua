----------------------------------------------------------------------------------------------------------------
-- UI helper functions
-- (c) 2003 Relic Entertainment Inc.

--? @group scardoc;UI

--? @shortdesc Highlights an SGroup in the UI for the given duration
--? @args SGroupID sgroup, Real duration
--? @result Void
function UI_HighlightSGroup( sgroupid, duration )
	
	local _OneSquad = function (gid, idx, sid)
		UI_HighlightSquad(sid, duration)
	end
	
	SGroup_ForEach(sgroupid, _OneSquad)
	
end

function nothing()
end

--? @shortdesc Removes a blip already created on the minimap
--? @result Void
--? @args Integer blipID
function UI_DeleteMinimapBlip(blipID)
	if blipID ~= nil then
		UI_DeleteMinimapBlipInternal(blipID)
	end
end

--? @shortdesc Creates a blip on the minimap; return the ID of the blip.
--? @extdesc 'where' can be an entity, marker, position, egroup, sgroup, or squad.
--? The following blipTypes are available:
--? BT_AttackHere
--? BT_DefendHere
--? BT_CaptureHere
--? BT_General
--? BT_Combat
--? BT_Reveal
--? BT_ObjectivePrimary
--? BT_ObjectiveSecondary
--? @result blipID
--? @args StackVar where, Real lifetime, Integer blipType
function UI_CreateMinimapBlip(where, lifetime, blipType)

	local type = scartype(where)
	
	if type == ST_ENTITY then
		return UI_CreateMinimapBlipOnEntity(where, lifetime, blipType)
	elseif type == ST_MARKER then
		return UI_CreateMinimapBlipOnMarker(where, lifetime, blipType)
	elseif type == ST_SCARPOS then
		return UI_CreateMinimapBlipOnPos(where, lifetime, blipType)
	elseif type == ST_EGROUP then
		return UI_CreateMinimapBlipOnEGroup(where, lifetime, blipType)
	elseif type == ST_SGROUP then
		return UI_CreateMinimapBlipOnSGroup(where, lifetime, blipType)
	elseif type == ST_SQUAD then
		return UI_CreateMinimapBlipOnSquad(where, lifetime, blipType)
	else
		error("UI_CreateMinimapBlip: invalid type")
	end
	
end

--? @shortdesc Creates a hintpoint attached to a Marker, EGroup, SGroup or position
--? @extdesc If range is set to 0, then the hintpoint is rangeless, see the design document for rangeless features.
--? The following types of hintpoint actions are available.
--? HPAT_Objective
--? HPAT_Hint
--? HPAT_Critical
--? HPAT_Movement
--? HPAT_Attack
--? HPAT_FormationSetup
--? HPAT_RallyPoint
--? HPAT_DeepSnow
--? HPAT_CoverGreen
--? HPAT_CoverYellow
--? HPAT_CoverRed
--? HPAT_Detonation
--? HPAT_Vaulting
--? @args StackVar where, Boolean bVisible, LocString hintText[, number height, HintPointActionType actionType, String iconName]
--? @result HintPointID

function HintPoint_Add(where, bVisible, hintText, height, actionType, iconName, priority, visibleInFOW)
	
	local type = scartype(where)
	
	if height == nil then 
		if (type == ST_EGROUP and World_OwnsEGroup(where, ANY) == false)
		  or (type == ST_SGROUP and World_OwnsSGroup(where, ANY) == false)
		  or (type == ST_ENTITY and World_OwnsEntity(where) == false)
		  or (type == ST_SQUAD and World_OwnsSquad(where) == false)then
			height = 3
		else
			height = 0
		end
	end
	
	if actionType == nil then 
		actionType = HPAT_Hint
	end
	
	if iconName == nil then 
		iconName = ""
	end
	
	if priority == nil then 
		priority = 0
	end
	
	if (visibleInFOW == nil) then
		visibleInFOW = true
	end
	local Offset = World_Pos(0, height, 0)
	
	if type == ST_MARKER then
		return HintPoint_AddToPosition(Marker_GetPosition(where), priority, bVisible, nothing, hintText, true, Offset, 0, actionType, iconName, visibleInFOW)
	elseif type == ST_EGROUP then
		return HintPoint_AddToEGroup(where, priority, bVisible, nothing, hintText, true, Offset, actionType, iconName, visibleInFOW)
	elseif type == ST_SGROUP then
		return HintPoint_AddToSGroup(where, priority, bVisible, nothing, hintText, true, Offset, actionType, iconName, visibleInFOW)
	elseif type == ST_SCARPOS then
		return HintPoint_AddToPosition(where, priority, bVisible, nothing, hintText, true, Offset, 0, actionType, iconName, visibleInFOW)
	elseif type == ST_SQUAD then
		return HintPoint_AddToSquad(where, priority, bVisible, nothing, hintText, true, Offset, 0, actionType, iconName, visibleInFOW)
	elseif type == ST_ENTITY then
		return HintPoint_AddToEntity(where, priority, bVisible, nothing, hintText, true, Offset, 0, actionType, iconName, visibleInFOW)
	else
		error("HintPoint_Add: invalid type")
	end
end

--? @shortdesc Removes a hintpoint.
--? @args Integer HintPointID
--? @result Void
function HintPoint_Remove(id)

	if id == nil then
		print("HintPoint_Remove: parameter is nil!")
	elseif scartype(id) == ST_NUMBER then
		HintPoint_RemoveInternal(id)
	else
		print("HintPoint_Remove: parameter is not nil, but is not a number either!")
	end
	
end

--? @shortdesc Sets a hintpoint's visibility. Currently, FOW is not accounted for.
--? @args Integer HintPointID, Boolean bVisible
--? @result Void
function HintPoint_SetVisible(id, bVisible)

	if id == nil then
		print("HintPoint_SetVisible: parameter is nil!")
	elseif scartype(id) == ST_NUMBER then
		HintPoint_SetVisibleInternal(id, bVisible)
	else
		print("HintPoint_SetVisible: parameter is not nil, but is not a number either!")
	end
	
end

--? @shortdesc Sets a hintpoint's display offset, which is 3D for world hintpoints and 2D for taskbar binding hintpoints (ignore z)
--? @args Integer hintpointID, Real x, Real y[, Real z]
--? @result Void
function HintPoint_SetDisplayOffset(id, x, y, z)

	if id == nil then
		print("HintPoint_SetOffset: parameter is nil!")
	elseif scartype(id) == ST_NUMBER then
		if z == nil then
			z = 0
		end
		local offset = World_Pos(x, y, z)
		HintPoint_SetDisplayOffsetInternal(id, offset)
	else
		print("HintPoint_SetOffset: parameter is not nil, but is not a number either!")
	end
	
end



--[[ added by degnan ]]

--? @shortdesc Adds a Hint Point that will only appear on Mouseover of the target.
--? @args LocString hintText, Marker/Position/Egroup/Sgroup hintTarget, Real targetRadius, Boolean looping
--? @result Void
function HintMouseover_Add(text, where, range, boolean)
	
	if _HintMouseOver == nil then
		_HintMouseOver = {}
	end
	
	table.insert(_HintMouseOver, {pos = where, activehint = nil, locid = text, radius = range, loop = boolean})
	
	if Rule_Exists(HintMouseover_Manager) == false then
		Rule_AddInterval(HintMouseover_Manager, 1)
	end

end

-- internal function
function HintMouseover_Manager()
	
	local mousePos = Misc_GetMouseOnTerrain()
	
	if table.getn(_HintMouseOver) > 0 then
		
		for i = table.getn(_HintMouseOver), 1, -1 do 
			
			local this = _HintMouseOver[i]
			local type = scartype(this.pos)
			local mouseover = false
			
			-- is it a marker
			if this.radius == -1 then
				mouseover = true
			elseif type == ST_MARKER or type == ST_SCARPOS then
				local pos = Util_GetPosition(this.pos)
				if World_DistancePointToPoint(mousePos, pos) <= this.radius then
					mouseover = true
				end
				
			-- is it an egroup
			elseif type == ST_EGROUP and EGroup_IsEmpty(this.pos) == false and EGroup_CountSpawned(this.pos) >=1 then
				local pos = EGroup_GetPosition(this.pos)
				if World_DistancePointToPoint(mousePos, pos) <= this.radius then
					mouseover = true
				end
				
			-- is it an SGROUP
			elseif type == ST_SGROUP and SGroup_IsEmpty(this.pos) == false and SGroup_CountSpawned(this.pos) >=1 then
				local pos = SGroup_GetPosition(this.pos)
				if World_DistancePointToPoint(mousePos, pos) <= this.radius then
					mouseover = true
				end
			end
			
			-- have we seen it all?
			if mouseover then
				
				-- is the hint off
				if this.activehint == nil then
					
					-- set the count to full
					local delay = 5
					if this.loop == false then
						delay = delay*2
					end
					this.count = delay
					this.activehint = HintPoint_Add(this.pos, true, this.locid)
					
				end
				
			-- the hint is on
			elseif this.activehint ~= nil then
				-- increment the count
				this.count = this.count-1
				if this.count < 1 then
					HintPoint_Remove(this.activehint)
					this.activehint = nil
					if this.loop == false then
						table.remove(_HintMouseOver, i)
					end
				end
			end
			
		end
		
	else
		
		Rule_RemoveMe()
		
	end

end



--? @shortdesc Removes a Mouseover Hint Point from the managing function.
--? @args LocString hintText, Marker/Egroup/Sgroup hintTarget
--? @result Void
function HintMouseover_Remove(text, position)
	
	if _HintMouseOver ~= nil then
		
		for i = table.getn(_HintMouseOver), 1, -1 do
			local this = _HintMouseOver[i]
			if position == this.pos and text == this.locid then
				if this.activehint ~= nil then
					HintPoint_Remove(this.activehint)
				end
				table.remove(_HintMouseOver, i)
			end
		end
		
	end

end



--
-- Event Cue wrapper functions
-- NJR (blame him)
--

function _EventCue_Init()

	_EventCueList = {}
	_EventCueHintPointList = {}

end
Scar_AddInit(_EventCue_Init)


--? @shortdesc Creates an Event Cue message which automatically sends the camera to a specified point when clicked on. 
--? @extdesc Can optionally create a 5-second hintpoint at the location when clicked on, and/or call a specified function for you, too. Both of these only activate the first time you click on the event cue to avoid stacking.
--? @args CueStyleID style, LocString title, LocString description, Marker/Pos/EGroup/SGroup cameratarget[, LocString hintpointtext, LuaFunction function, Float lifetime, Boolean dismissOnClick]
--? @result event cue ID
function EventCue_Create(style, title, description, pos, hintpointmessage, func, lifetime, dismissOnClick)

	local snd = style.sound
	local class = style.class
	
	if snd == nil then
		snd = "General_alert"
	end
	
	if title == nil then
		title = 11046699 -- LOCDB [11046699] 'Reinforcements'
	end
	
	if description == nil then
		description = 11038803	-- LOCDB [11038803]	'Reinforcements have arrived'
	end
	
	-- special code that gets the icon from an ObjectiveTable if needed
	local icon = style.icon
	if icon == nil then
		icon = style.Cue.icon
	end
	
	if lifetime == nil then
		lifetime = 10
	end
	
	if dismissOnClick == nil then
		dismissOnClick = false
	end
	
	local datatable = {icon = icon, snd = snd, title = title, description = description, lifetime = lifetime, dismissOnClick = dismissOnClick}
	
	-- do the event cue, and make a record of where the camera should go if this event cue is ever clicked on
	local id = UI_CreateEventCueClickable(icon, snd, title, description, EventCue_InternalManager, lifetime, dismissOnClick)
	_EventCueList[id] = {location = pos, hintpoint = hintpointmessage, extrafunc = func, class = class, lasttrigger = World_GetGameTime(), data = datatable}

	-- make backup locations for sgroups and egroups, if all items get destroyed between now and when we move the camera
	if scartype(pos) == ST_SGROUP then
		if SGroup_Count(pos) >= 1 then
			_EventCueList[id].backuplocation = Squad_GetPosition(SGroup_GetSpawnedSquadAt(pos, 1))
		end
	elseif scartype(pos) == ST_EGROUP then
		if EGroup_Count(pos) >= 1 then
			_EventCueList[id].backuplocation = Entity_GetPosition(EGroup_GetSpawnedEntityAt(pos, 1))
		end
	end
	
	-- ping the location on the minimap
	if pos ~= nil then
		UI_CreateMinimapBlip(pos, 5, BT_General)
	end
	
	-- if it's a repeating type, start the checker rule
	if class == "repeating" and Rule_Exists(EventCue_RepeaterManager) == false then
		
		SGroup_Clear(sg_temp)
		EGroup_Clear(eg_temp)
		Misc_GetControlGroupContents(9, sg_temp, eg_temp)
		if EGroup_IsEmpty(eg_temp) and SGroup_IsEmpty(sg_temp) then
			
			-- if the "pos" is an SGroup and it's repreating, add it to control group "9"
			if scartype(pos) == ST_SGROUP then
				SGroup_CallSquadFunction(pos, Misc_SetSquadControlGroup, 9)
			end
			
		end
		
		if Rule_Exists(EventCue_RepeaterManager) == false then
			Rule_AddInterval(EventCue_RepeaterManager, 1)
		end
		
	end
	
	return id
end

-- internal function that checks if a reinforcement 
function EventCue_RepeaterManager()

	local noreinforcements = true
	
	for k, this in pairs(_EventCueList) do 
		
		if this.class == "repeating" then
			
			noreinforcements = false
			
			-- see if the player has selected the group
			if scartype(this.location) == ST_SGROUP then
				if SGroup_Count(this.location) == 0 or Misc_IsSGroupSelected(this.location, ANY) then
					this.class = nil
				end
			elseif scartype(this.location) == ST_EGROUP then
				if EGroup_Count(this.location) == 0 or Misc_IsEGroupSelected(this.location, ANY) then
					this.class = nil
				end
			end
			
			-- repeat this event cue
			if this.class == "repeating" and World_GetGameTime() > (this.lasttrigger + 60) then
				local id = UI_CreateEventCueClickable(this.data.icon, this.data.snd, this.data.title, this.data.description, EventCue_InternalManager, this.data.lifetime, this.data.dismissOnClick)
				_EventCueList[id] = {location = this.location, hintpoint = this.hintpoint, extrafunc = this.extrafunc, originalid = k}
				if this.location ~= nil then
					UI_CreateMinimapBlip(this.location, 5, BT_General)
				end
				this.lasttrigger = World_GetGameTime()
			end
		end
		
	end
	
	-- if there are no more reinforcement class event cues in the list, remove the rule
	if noreinforcements == true then
		Rule_RemoveMe()
	end
	
end

-- internal function that's activated when the event cue item is clicked on
function EventCue_InternalManager(id)
	
	-- get the details for this event cue
	local details = _EventCueList[id]
	
	-- move the camera
	if details.location ~= nil then
		if scartype(details.location) == ST_SCARPOS or scartype(details.location) == ST_MARKER then
			Camera_MoveTo(details.location, true)
		elseif scartype(details.location) == ST_SGROUP then
			-- only move if there are squads still in the group!
			if SGroup_CountSpawned(details.location) >= 1 then
				Camera_MoveTo(details.location, true)
			elseif details.backuplocation ~= nil then
				Camera_MoveTo(details.backuplocation, true)
			end
		elseif scartype(details.location) == ST_EGROUP then
			-- only move if there are squads still in the group!
			if EGroup_CountSpawned(details.location) >= 1 then
				Camera_MoveTo(details.location, true)
			elseif details.backuplocation ~= nil then
				Camera_MoveTo(details.backuplocation, true)
			end
		end
	end
	
	-- add the temporary hintpoint if there is one
	if details.hintpoint ~= nil then
		local hpid = HintPoint_Add(details.location, true, details.hintpoint)
		table.insert(_EventCueHintPointList, {id = hpid, expiretime = World_GetGameTime() + 5})
		if Rule_Exists(EventCue_InternalHintPointManager) == false then
			Rule_AddInterval(EventCue_InternalHintPointManager, 1)
		end
		details.hintpoint = nil			-- make sure it doesn't activate again if reclicked
	end
	
	-- call the extra function if there is one
	if details.extrafunc ~= nil then
		details.extrafunc()
		details.extrafunc = nil			-- make sure it doesn't activate again if reclicked
	end
	
	-- make sure this event cue doesn't repeat anymore if it's that type
	if details.class == "repeating" then
		details.class = nil
	elseif details.originalid ~= nil then
		_EventCueList[details.originalid].class = nil
	end
	
end

-- internal function to clean up hintpoints after 5 seconds
function EventCue_InternalHintPointManager()

	for n = table.getn(_EventCueHintPointList), 1, -1 do
		
		if World_GetGameTime() >= _EventCueHintPointList[n].expiretime then
			HintPoint_Remove(_EventCueHintPointList[n].id)
			table.remove(_EventCueHintPointList, n)
		end
		
	end
	
	-- kill off the rule if we just removed the last item
	if table.getn(_EventCueHintPointList) == 0 then
		Rule_RemoveMe()
	end
	
end

--? @shortdesc Create a custom kicker message on the squad and display to the player.
--? @args PlayerID player, SGroup sgroup, LocString message
--? @result Void
function UI_CreateSGroupKickerMessage(player, sgroup, message)

	local _CheckSGroup = function(gid, idx, sid)
		UI_CreateSquadKickerMessage(player,sid, message)
	end
	
	SGroup_ForEach(sgroup, _CheckSGroup)

end

--? @shortdesc Enables or disables the FOW, including out of bound areas and all entities on the map
--? @args Boolean enable
--? @result Void
function FOW_Enable(enable)
	FOW_EnableTint(enable)
	if enable then		
		FOW_UnRevealAll()
		Ghost_EnableSpotting()
	else
		Ghost_DisableSpotting()
		FOW_RevealAll()		
	end
end

--? @shortdesc Creates an event cue without a callback (you won't know when it's clicked)
--? @args String iconPath, String soundPath, LocString title, LocString description[, Float lifetime, Boolean dismissOnClick]
--? @result ID
function UI_CreateEventCue(iconPath, soundPath, title, description, lifetime, dismissOnClick)

	if description == nil then
		description = 0
	end
	
	if lifetime == nil then
		lifetime = -1
	end
	
	if dismissOnClick == nil then
		dismissOnClick = false
	end
	
	return UI_CreateEventCueClickable(iconPath, soundPath, title, description, nothing, lifetime, dismissOnClick)
	
end

--? @shortdesc Creates and flashes an ability button on the taskbar if the unit is selected
--? @extdesc Length parameter determines how long to flash the item, and the blueprint filter is used if 
--?		certain squad types need to be selected before flashing the button.
--? @args PlayerID playerid, AbilityID abilityID, LocString text, Integer length, [Table/Blueprint blueprint_filter]
--? @result Void
function UI_AddHintAndFlashAbility(player, ability, text, length, blueprint)
	
	if _t_internal_hint_manager == nil then
		_t_internal_hint_manager = {}
	end
	
	if length <= 0 then
		fatal("Length of hint and flash cannot be less than one")
	end
	
	if ability == nil then
		fatal("Invalid ability")
	end

	local temp = {
		
		ability		= ability,
		flash_id 	= nil,
		player		= player,
		text		= text, 
		length 		= length,
		blueprint 	= blueprint,
		selected	= false,
		timer_id	= nil,
	}
	
	table.insert(_t_internal_hint_manager, temp)
	
	sg_interal_hint_button = SGroup_CreateIfNotFound("sg_interal_hint_button")
	
	if Rule_Exists(_HintAndFlashButtonManager) == false then
		Rule_AddInterval(_HintAndFlashButtonManager, 1.3)
	end

end


function _HintAndFlashButtonManager()

	for i=table.getn(_t_internal_hint_manager), 1, -1 do
		this = _t_internal_hint_manager[i]
		
		if this.selected == false then
			
			SGroup_Clear(sg_interal_hint_button)
			
			if this.blueprint ~= nil then
				Misc_GetSelectedSquads(sg_interal_hint_button, false)
				SGroup_Filter(sg_interal_hint_button, this.blueprint, FILTER_KEEP)
			end
			
			if this.blueprint == nil or SGroup_IsEmpty(sg_interal_hint_button) == false then
				this.flash_id = UI_FlashAbilityButton(this.ability, true )
				this.timer_id = this.flash_id + 1000
				Timer_Start(this.timer_id, this.length)
				this.selected = true
			end
			
		elseif Timer_GetRemaining(this.timer_id) <= 0 then
			
			if this.flash_id ~= nil then
				UI_StopFlashing(this.flash_id)
			end
			
			table.remove(_t_internal_hint_manager, i)
		end
	end
	
	if table.getn(_t_internal_hint_manager) <= 0 then
		Rule_RemoveMe()
	end

end

--? @shortdesc Creates a group of threats that are represented by a single arrow. Threats can be entities, squads, egroups, sgroups, positions or markers
--? @args variable argument list: threats
--? @result Integer (ID)
function ThreatArrow_CreateGroup(...)

	-- comment this out to enable multiple threat arrows
	-- ThreatGroup_DestroyAll()
	
	local id = ThreatGroup_Create()
	
	for i = 1, table.getn(arg) do
		
		ThreatArrow_Add(id, arg[i])
		
	end
	
	return id

end

--? @shortdesc Destroy a threat group
--? @args Integer GroupID
function ThreatArrow_DestroyGroup(id)
	ThreatGroup_Destroy(id)
end

--? @shortdesc Destroy all threat groups
function ThreatArrow_DestroyAllGroups()
	ThreatGroup_DestroyAll()
end

--? @shortdesc Adds a threat to an existing group
--? @args Integer GroupID, entity/squad/egroup/sgroup/position/marker Threat[, String icon]
function ThreatArrow_Add(id, threat, icon)

	if icon == nil then icon = "" end
	
	local threattype = scartype(threat)
		
	if threattype == ST_ENTITY then
		ThreatGroup_AddEntity(id, threat, icon)
	elseif threattype == ST_EGROUP then
		local _AddEntity = function(gid, idx, eid)
			ThreatGroup_AddEntity(id, eid, icon)
		end
		EGroup_ForEach(threat, _AddEntity)
	elseif threattype == ST_SQUAD then
		ThreatGroup_AddSquad(id, threat, icon)
	elseif threattype == ST_SGROUP then
		local _AddSquad = function(gid, idx, sid)
			ThreatGroup_AddSquad(id, sid, icon)
		end
		SGroup_ForEach(threat, _AddSquad)
	elseif threattype == ST_MARKER then
		local pos = Marker_GetPosition(threat)
		ThreatGroup_AddPosition(id, pos, icon)
	elseif threattype == ST_SCARPOS then
		ThreatGroup_AddPosition(id, threat, icon)
	else
		fatal("ThreatArrow_Add: invalid type of threat: " .. threattype)
	end
	
end

--? @shortdesc Removes a threat from an existing group
--? @args Integer GroupID, entity/squad/egroup/sgroup/position/marker Threat
function ThreatArrow_Remove(id, threat)
	
	local threattype = scartype(threat)
	if threattype == ST_ENTITY then
		ThreatGroup_RemoveEntity(id, threat)
	elseif threattype == ST_EGROUP then
		local _AddEntity = function(gid, idx, eid)
			ThreatGroup_RemoveEntity(id, eid)
		end
		EGroup_ForEach(threat, _AddEntity)
	elseif threattype == ST_SQUAD then
		ThreatGroup_RemoveSquad(id, threat)
	elseif threattype == ST_SGROUP then
		local _AddSquad = function(gid, idx, sid)
			ThreatGroup_RemoveSquad(id, sid)
		end
		SGroup_ForEach(threat, _AddSquad)
	elseif threattype == ST_MARKER then
		local pos = Marker_GetPosition(threat)
		ThreatGroup_RemovePosition(id, pos)
	elseif threattype == ST_SCARPOS then
		ThreatGroup_RemovePosition(id, threat)
	else
		fatal("ThreatArrow_Remove: invalid type of threat: " .. threattype)
	end
	
end


--? @shortdesc Fade in and out two or three lines of subtext.
--? @args LocString location, LocString time, LocString detail, Real in, Real lifetime, Real out
--? @extdesc This function has to support two lines, for backwards compatibility. The 'detail' line is therefore optional.
function Game_SubTextFade(...)

	if table.getn(arg) == 5 then
		Game_SubTextFadeInternal(arg[1], arg[2], 0, arg[3], arg[4], arg[5])
	elseif table.getn(arg) == 6 then
		Game_SubTextFadeInternal(arg[1], arg[2], arg[3], arg[4], arg[5], arg[6])
	else
		fatal("Game_SubTextFade: invalid # of arguments")
	end

end

--? @shortdesc Sets a level decorator that's defined in all of the squads squad_ui_ext in the target SGroup
--? @extdesc fields in the squad_ui_ext are special_decorator_friendly and special_decorator_enemy
--? @extdesc if level value is -1 it will hide the special decorator, if no level is defined -1 is default
--? @args SGroup sgroup, Int level
function UI_SetSGroupSpecialLevel(sgroup, level)
	
	local level = level or -1
	if level < -1 then level = -1 end
	
	local _apply = function(gid, idx, sid)
		UI_SetSquadSpecialLevel(sid, level)
	end
	
	SGroup_ForEach(sgroup, _apply)
end

--? @shortdesc Creates an arrow on the metamap between the two locations provided
--? @args Marker/Pos position_from, Marker/Pos position_to, Int red, Int green, Int blue, Int alpha
function MapIcon_CreateArrow(position_from, position_to, color_red, color_green, color_blue, color_alpha)

	-- force the from and to into positions
	position_from = Util_GetPosition(position_from)
	position_to = Util_GetPosition(position_to)
	
	-- calculate the scale and midpoint required
	local scale = Util_GetDistance(position_from, position_to)
	local midpoint = Util_GetPositionFromAtoB(position_from, position_to, 0.5)
	
	-- create the arrow and make it face the right way
	local id = MapIcon_CreatePosition(midpoint, "Icons_minimap_movement_arrow", math.floor(scale/1.8), color_red, color_green, color_blue, color_alpha)
	MapIcon_SetFacingPosition(id, position_to)
	
	return id	-- return the id back to the script

end

function UI_AddControl(control, path, rectLeft, rectTop, rectRight, rectBottom)
	if path == nil then
		path = ""
	end
	if rectLeft == nil then
		rectLeft = 0.0
	end
	if rectTop == nil then
		rectTop = 0.0
	end
	if rectRight == nil then
		rectRight = UI_GetViewportWidth()
	end
	if rectBottom == nil then
		rectBottom = UI_GetViewportHeight()
	end
	
	local controlType = control.controlType
	local name = control.name or ""
	
	local x = rectLeft
	if control.x ~= nil then
		x = rectLeft + control.x
	elseif control.left ~= nil then
		x = rectLeft + control.left
	end
	
	local y = rectTop
	if control.y ~= nil then
		y = rectTop + control.y
	elseif control.top ~= nil then
		y = rectTop + control.top
	end
	
	local width = math.max(1.0, rectRight - x)
	if control.width ~= nil then
		width = control.width
	elseif control.right ~= nil then
		width = math.max(1.0, (rectRight - control.right) - x)
	end
	
	local height = math.max(1.0, rectBottom - y)
	if control.height ~= nil then
		height = control.height
	elseif control.bottom ~= nil then
		height = math.max(1.0, (rectBottom - control.bottom) - y)
	end
	
	if controlType == "button" then
		UI_ButtonAdd(path, name, x, y, width, height, control.callback or "", control.enabled or true, control.icon or "", control.style or BIS_Icon, control.tag or "", control.text or Loc_Empty())
	elseif controlType == "label" then
		UI_LabelAdd(path, name, x, y, width, height, control.alignHorizontal or LAH_Left, control.alignVertical or LAV_Top, control.bold or false, control.italic or false, control.size or 12.0, control.text or Loc_Empty())
	elseif controlType == "icon" then
		UI_IconAdd(path, name, x, y, width, height, control.icon or "")
	elseif controlType == "panel" then
		UI_PanelAdd(path, name, x, y)
		if name ~= "" then
			if path == "" then
				path = name
			else
				path = path .. "." .. name
			end
			local children = control.children
			if children ~= nil then
				local margin = control.margin
				if margin == nil then
					x = 0.0
					y = 0.0
				else
					x = margin
					y = margin
					width = math.max(1.0, width - 2.0 * margin)
					height = math.max(1.0, height - 2.0 * margin)
				end
				for i, child in ipairs(children) do
					UI_AddControl(child, path, x, y, width, height)
				end
			end
		end
	elseif controlType == "statusIndicator" then
		UI_StatusIndicatorAdd(path, name, x, y, width, height, control.value or 0.0)
	end
end
