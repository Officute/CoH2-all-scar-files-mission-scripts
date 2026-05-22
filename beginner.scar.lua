--
-- BEGINNER HINT MANAGER
--
-- Provides hints to the player to remind them of opportunities to use certain abilities.
-- Used in the easier difficulty modes.
--
-- 2012 Relic Entertainment
--



HINT_LIGHTCOVER = 1			-- some enums to denote specific hint types that aren't actually abilities
HINT_HEAVYCOVER = 2
HINT_NEGATIVECOVER = 3
HINT_DEEPSNOW = 4
HINT_FLANK = 5
HINT_DEMOCHARGE = 6
HINT_RALLYPOINT = 7
HINT_MERGE = 8
HINT_REINFORCE = 9
HINT_PICKUP = 10


function BeginnerHint_Init()

	-- set up some constants, data tracking variables, etc
	beginnerhint_data = {
		last_used_id = 0,									-- id the return to the calling script to identify the opportunity
		last_hint_time = 0,
		screen_percent = 0.6,
		
		frequency = Util_DifVar({120, 180, 0, 0}),			-- how long to wait before thinking about putting up a hint
		ability_frequency = Util_DifVar({240, 360, 0, 0}),	-- the specific ability can't have been used in this amount of time before putting up a hint for it (this lets other abilities have a shot first)
		onscreen_length = Util_DifVar({27, 18, 0, 0}),		-- how long a hint should stay around before timing out and clearing itself away
		
		current_hint_id = nil,								-- this is the hintpoint id for the hint that's up
		current_hint = nil,									-- this is the opportunity data relating to the current hint
		current_hint_flash_id = nil,						-- this is the flash id for flashing the ability button
		remove_current_hint = false,						-- set this flag to remove a hint that's currently showing
	}
	
	sg_beginnerhint_nearbysquads = SGroup_CreateIfNotFound("sg_beginnerhint_nearbysquads")
	eg_beginnerhint_nearbyentities = EGroup_CreateIfNotFound("eg_beginnerhint_nearbyentities")
	sg_beginnerhint_hintarrow = SGroup_CreateIfNotFound("sg_beginnerhint_hintarrow")
	eg_beginnerhint_hintarrow = EGroup_CreateIfNotFound("eg_beginnerhint_hintarrow")
	
	-- table to hold opportunities declared by the mission scripts
	t_beginnerhint_opportunities = {}
	
	-- table to hold the timestamps of the latest use of each ability
	t_beginnerhint_abilitytimestamps = {}
	t_beginnerhint_commandtimestamps = {}
	
	-- add indexes to ability details table (used to help in reload situations)
	for index, ability in pairs(t_beginnerhint_abilitydetails) do 
		ability.index = index
	end
	beginnerhint_detect_reload = false
	
	-- we're only going to do this in easy and normal modes
	local difficulty = Game_GetSPDifficulty()
	if difficulty == GD_EASY or difficulty == GD_NORMAL then
		
		print("Beginner Hint system initialising...")
		
		-- add background rules for catching all ability and command uses
		Rule_AddGlobalEvent(BeginnerHint_MarkAbilityUse, GE_AbilityExecuted)
		Rule_AddGlobalEvent(BeginnerHint_MarkCommandUse, GE_SquadCommandIssued)
		
		-- kick off the manager
		Rule_AddInterval(BeginnerHint_Manager, 5, 251)
		
	end
	
end

Scar_AddInit(BeginnerHint_Init)




--? @group scardoc;BeginnerHint

--? @args Pos/Group/Table where, AbilityID/Table ability[, Bool repeating, LocText message, String icon, HPAT arrow, GD max_difficulty, Bool ignore_timers]
--? @result OpportunityID
--? @shortdesc Add an opportunity that may get highlighted by the hint manager system on easier difficulty modes. THIS IS NOT MP-SAFE!
function BeginnerHint_AddOpportunity(where, ability, repeating, message, icon, arrow, max_difficulty, ignore_timers)

	-- push the where parameter into a table if it isn't one already
	if scartype(where) ~= ST_TABLE then
		where = {where}
	end
	if scartype(ability) ~= ST_TABLE then
		ability = {ability}
	end
	if repeating == nil then
		repeating = false
	end
	if ignore_timers == nil then
		ignore_timers = false
	end
	
	-- bump up the counter to make a new id for this entry
	beginnerhint_data.last_used_id = beginnerhint_data.last_used_id + 1
	
	-- check to see if we want to include this at this difficulty mode
	if max_difficulty == nil or Game_GetSPDifficulty() <= max_difficulty then
		
		for k, this_location in pairs(where) do 
			
			for n, this_ability in pairs(ability) do 
				
--~ 				-- QUICK FIX
--~ 				if this_ability == HINT_MERGE then
--~ 					this_ability = ABILITY.SOVIET.MERGE_ABILITY
--~ 				end
				
				local details = BeginnerHint_GetDetailsForAbility(this_ability)
				
				for index, these_details in pairs(details) do 
					
					-- create the table entry with the passed in parameters and add it to the table
					local data = {
						id = beginnerhint_data.last_used_id,
						where = this_location,
						ability = this_ability,
						details = these_details,
						details_index = index,
						repeating = repeating,
						arrow = arrow,
						message = message,
						icon = icon,
						ignore_timers = ignore_timers,
					}
					
					-- add our data table to the list of opportunities
					table.insert(t_beginnerhint_opportunities, data)
					
				end
				
			end
			
		end
		
	end
	
	-- return the id, which may be used by the script to reference THIS opportunity
	return beginnerhint_data.last_used_id
	
end


--? @args Pos/OpportunityID where
--? @shortdesc Remove an opportunity, either by ID or all opportunities at a location
function BeginnerHint_RemoveOpportunity(where)

	-- remove any matching opportunities from the table
	for index = #t_beginnerhint_opportunities, 1, -1 do
		
		if scartype(where) == ST_NUMBER then
			if t_beginnerhint_opportunities[index].id == where then
				table.remove(t_beginnerhint_opportunities, index)
			end
		else
			if t_beginnerhint_opportunities[index].where == where then
				table.remove(t_beginnerhint_opportunities, index)
			end
		end
		
	end
	
	-- if there's a hint up currently, check that to see if we should remove it 
	if beginnerhint_data.current_hint ~= nil then
		
		if scartype(where) == ST_NUMBER then
			if beginnerhint_data.current_hint.id == where then
				beginnerhint_data.remove_current_hint = true
			end
		else
			if beginnerhint_data.current_hint.where == where then
				beginnerhint_data.remove_current_hint = true
			end
		end
		
	end
	
end


--? @args Void
--? @shortdesc Remove all opportunities in one fell swoop!
function BeginnerHint_RemoveAllOpportunities()
	
	-- just replace the opportunity table with an empty table!
	t_beginnerhint_opportunities = {}
	
	-- if there's a hint up at the moment, set a flag to remove it
	if beginnerhint_data.current_hint ~= nil then
		beginnerhint_data.remove_current_hint = true
	end
	
end






--
--
-- INTERNAL FUNCTIONS below this line
--
--

-- this function looks to see if we should throw up a hint
function BeginnerHint_Manager()
	
	-- if we detect that a reload has occured, reset details in opportunities table
	if beginnerhint_detect_reload == true then
		
		for k, opportunity in pairs(t_beginnerhint_opportunities) do 
			opportunity.details = t_beginnerhint_abilitydetails[opportunity.details.index]
		end
		for index, ability in pairs(t_beginnerhint_abilitydetails) do 
			ability.index = index
		end
		
		beginnerhint_detect_reload = false
		
	end
	
	-- do the heavy processing to pick an opportunity
	local result = BeginnerHint_FindAnOpportunity()
	
	-- if we did indeed find an opportunity to hint, 
	if result ~= false then
		
		local message = (result.message or result.details.message) or LOC("THIS NEEDS A HINT WRITTEN FOR IT!")
		local icon = (result.icon or result.details.icon) or BeginnerHint_GetIconFromAbility(result.ability) or ""
		local arrow = (result.arrow or result.details.arrow) or HPAT_Hint
		local location = result.where
		
		-- if where is a group, pick a random visible item in the group
		if scartype(location) == ST_SGROUP or scartype(location) == ST_SQUAD then
			
			SGroup_Clear(sg_beginnerhint_hintarrow)
			SGroup_Add(sg_beginnerhint_hintarrow, BeginnerHint_PickASquad(result.where))
			location = sg_beginnerhint_hintarrow
			result.where = sg_beginnerhint_hintarrow
			
		elseif scartype(location) == ST_EGROUP or scartype(location) == ST_ENTITY then
			
			EGroup_Clear(eg_beginnerhint_hintarrow)
			EGroup_Add(eg_beginnerhint_hintarrow, BeginnerHint_PickAnEntity(result.where))
			location = eg_beginnerhint_hintarrow
			result.where = eg_beginnerhint_hintarrow
			
		end
		
		-- create the hint 
		beginnerhint_data.current_hint_id = HintPoint_Add(location, true, message, nil, arrow, icon, -1)
		beginnerhint_data.current_hint = result
		Sound_Play2D("ui/in_game/event_cues/hint_arrows")
		
--~ 		-- flash the ability button (maybe: depends on difficulty mode)
--~ 		if Game_GetSPDifficulty() == GD_EASY then
--~ 			if scartype(result.details.ability) == ST_PBG then
--~ 				beginnerhint_data.current_hint_flash_id = UI_FlashAbilityButton(result.details.ability, true)
--~ 			elseif result.details.ability == HINT_DEMOCHARGE then
--~ 				beginnerhint_data.current_hint_flash_id = UI_FlashSquadCommandButton(SCMD_PlaceCharge, true)
--~ 			end
--~ 		end
		
		-- add callbacks to monitor for the player doing the action 
		if result.details.callback == nil then
			Rule_AddGlobalEvent(BeginnerHint_AbilityCallback, GE_AbilityExecuted)
		else
			Rule_AddGlobalEvent(result.details.callback.func, result.details.callback.event)
		end
		
		-- do some bookkeeping about when we put this up
		beginnerhint_data.last_hint_time = World_GetGameTime()
		result.last_shown = World_GetGameTime()
		
		-- remove this rule for now
		Rule_RemoveMe()
		Rule_Add(BeginnerHint_OpportunityOver)
		
	end
	
end

-- this function takes over once a hint is up... and this one looks to remove the hint
function BeginnerHint_OpportunityOver()
	
	-- check the item pointed at - if it been destroyed then remove it, likewise if it's a squad that is now world owned (i.e. it's probably something that became abandoned)
	if scartype(beginnerhint_data.current_hint.where) == ST_SGROUP then
		if SGroup_Count(sg_beginnerhint_hintarrow) == 0 or World_OwnsSGroup(sg_beginnerhint_hintarrow, ANY) or SGroup_IsRetreating(sg_beginnerhint_hintarrow, ALL) then
			beginnerhint_data.remove_current_hint = true
		end
	elseif scartype(beginnerhint_data.current_hint.where) == ST_EGROUP then
		if EGroup_Count(eg_beginnerhint_hintarrow) == 0 then
			beginnerhint_data.remove_current_hint = true
		end
	end
	
	
	-- now check to see if it needs to be removed
	if beginnerhint_data.remove_current_hint == true or															-- some flag has been set to remove the current hint OR
	   (World_GetGameTime() - beginnerhint_data.last_hint_time) >= beginnerhint_data.onscreen_length then		-- hint has been onscreen too long
	  	
	   
		-- remove the callbacks
		if Rule_Exists(BeginnerHint_AbilityCallback) then Rule_RemoveGlobalEvent(BeginnerHint_AbilityCallback) end
		if Rule_Exists(BeginnerHint_MergeCallback) then Rule_RemoveGlobalEvent(BeginnerHint_MergeCallback) end
		if Rule_Exists(BeginnerHint_MoveOrderCallback) then Rule_RemoveGlobalEvent(BeginnerHint_MoveOrderCallback) end
		if Rule_Exists(BeginnerHint_DemoPackCallback) then Rule_RemoveGlobalEvent(BeginnerHint_DemoPackCallback) end
		if Rule_Exists(BeginnerHint_RallyPointCallback) then Rule_RemoveGlobalEvent(BeginnerHint_RallyPointCallback) end
		if Rule_Exists(BeginnerHint_ReinforceCallback) then Rule_RemoveGlobalEvent(BeginnerHint_ReinforceCallback) end
		if Rule_Exists(BeginnerHint_PickUpCallback) then Rule_RemoveGlobalEvent(BeginnerHint_PickUpCallback) end
		
		-- mark the time, so we start measuring from now (rather than when we put this hint up)
		beginnerhint_data.last_hint_time = World_GetGameTime()
		
		-- if this was cleared by external reasons AND this hint was set to not be repeating, then remove it from the list
		if beginnerhint_data.remove_current_hint == true and beginnerhint_data.current_hint.repeating == false then
			BeginnerHint_RemoveOpportunity(beginnerhint_data.current_hint.where)
		end
		
		-- play a sound (depending on whether it just timed out or was actively cleared)
		if beginnerhint_data.remove_current_hint == true then
			Sound_Play2D("ui/in_game/event_cues/hint_player_reacts")		-- actively cleared
		else
			Sound_Play2D("ui/in_game/event_cues/hint_timeout")				-- timed out
		end
		
		-- remove the hint
		HintPoint_Remove(beginnerhint_data.current_hint_id)
		beginnerhint_data.current_hint = nil
		beginnerhint_data.remove_current_hint = false
		
		if beginnerhint_data.current_hint_flash_id ~= nil then
			UI_StopFlashing(beginnerhint_data.current_hint_flash_id)
			beginnerhint_data.current_hint_flash_id = nil
		end
		
		Rule_RemoveMe()
		Rule_AddInterval(BeginnerHint_Manager, 5, 251)
		
	end
	
end





-- iterates through all opportunities, finds all of the suitable ones and returns a random one of those (or returns false if there were none)
function BeginnerHint_FindAnOpportunity()
	
	local possibles = {}
	
	-- go through each opportunity to see if it can be used
	for k, item in pairs(t_beginnerhint_opportunities) do 
		
		-- run the tests on this item
		local test_results = BeginnerHint_TestOpportunity(item)
		
		-- add results to the list of possible opportunities
		if test_results == true then
			table.insert(possibles, item) 
		elseif scartype(test_results) == ST_TABLE then
			for k, result in pairs(test_results) do
				table.insert(possibles, result) 
			end
		end
		
	end
	
	-- choose from possible opportunities
	if #possibles == 0 then
		return false
	else
		return Table_GetRandomItem(possibles)
	end
	
end


-- takes a single opportunity and returns true or false to say whether it's suitable or not
function BeginnerHint_TestOpportunity(item)

	if item.ignore_timers == false then
		
		-- only think about adding hints if we aren't in the middle of some event
		if Event_IsAnyRunning() == true then
			return false
		end
		
		-- check it isn't too soon since the last hint
		if (World_GetGameTime() - beginnerhint_data.last_hint_time) <= beginnerhint_data.frequency then
			return false
		end
		
		-- if it's an ability, check that the last use of this ability wasn't too recent
		if scartype(item.ability) == ST_PBG then
			if ( World_GetGameTime() - BeginnerHint_GetLastAbilityUse(item.ability) ) <  beginnerhint_data.ability_frequency then
				return false
			end
		elseif item.details.equiv_command ~= nil then			-- okay, so this isn't actually an ability, but it does have an equivalent command listed, so look that up instead
			if ( World_GetGameTime() - BeginnerHint_GetLastAbilityUse(item.details.equiv_command) ) <  beginnerhint_data.ability_frequency then
				return false
			end
		end
		
	end
	
	-- if it's a group, check it has units and is visible on screen and in the FOW. These are "early-out" checks, before we do anything slow and complex.
	if scartype(item.where) == ST_SGROUP then
		if SGroup_CountSpawned(item.where) == 0 or Player_CanSeeSGroup(player1, item.where, ANY) == false or World_OwnsSGroup(item.where, ALL) == true or Misc_IsSGroupOnScreen(item.where, beginnerhint_data.screen_percent, ANY) == false then
			return false
		end
	elseif scartype(item.where) == ST_EGROUP then
		if EGroup_CountSpawned(item.where) == 0 or Player_CanSeeEGroup(player1, item.where, ANY) == false or Misc_IsEGroupOnScreen(item.where, beginnerhint_data.screen_percent, ANY) == false then
			return false
		end
	elseif scartype(item.where) == ST_SQUAD then
		if Player_CanSeeSquad(player1, item.where, ANY) == false or Misc_IsSquadOnScreen(item.where, beginnerhint_data.screen_percent, ANY) == false then
			return false
		end
	elseif scartype(item.where) == ST_ENTITY then
		if Player_CanSeeEntity(player1, item.where, ANY) == false or Misc_IsEntityOnScreen(item.where, beginnerhint_data.screen_percent, ANY) == false then
			return false
		end
	elseif scartype(item.where) == ST_MARKER or scartype(item.where) == ST_SCARPOS then
		if Misc_IsPosOnScreen(Util_GetPosition(item.where), beginnerhint_data.screen_percent) == false then
			return false
		end
	end
	
	
	--
	-- if this task needs squads nearby, gather them and filter them
	--
	Player_GetAll(player1, sg_beginnerhint_nearbysquads, eg_beginnerhint_nearbyentities)

	if item.details.squad_required ~= nil then
		SGroup_Filter(sg_beginnerhint_nearbysquads, item.details.squad_required, FILTER_KEEP)		
	elseif item.details.entity_required ~= nil then
		EGroup_Filter(eg_beginnerhint_nearbyentities, item.details.entity_required, FILTER_KEEP)
	end
	
	-- nearby-ness will be tested later, per squad/entity in the "where" group
	-- HOWEVER, if the "where" is a position, we can filter nearby-ness now
	if scartype(item.where) == ST_SCARPOS or scartype(item.where) == ST_MARKER then
		
		local pos = Util_GetPosition(item.where)
		local range = nil 
		
		if scartype(item.where) == ST_MARKER then
			local range = Marker_GetProximityRadius(item.where)
			local dir = Marker_GetDirection(item.where)
		end
		
		if (range == 0 or range == nil) then 
			range = 40 
		end
		
		
		local _CheckPosition = function(thispos)		-- function to check an item's position, and return false if it's outside the area we are interested in
			
			if Util_GetDistance(thispos, pos) > range then
				return false
			else
				
				-- if this ability specifies that it's directional,  filter out any squads in the wrong half of the marker
				if item.details.directional == true and scartype(item.where) == ST_MARKER then
					thispos.x = thispos.x - pos.x
					thispos.z = thispos.z - pos.z
					if ( (thispos.x * dir.x) + (thispos.z * dir.z) ) <= 0 then		-- dot product. Less than 0 means its facing the OTHER way
						return false
					end
				end
				
			end
			
			return true
			
		end
		
		if item.details.squad_required ~= nil then
			
			local _CheckSquad = function(gid, idx, sid)
				local result = _CheckPosition(Squad_GetPosition(sid))
				if result == false then
					SGroup_Remove(sg_beginnerhint_nearbysquads, sid)
				end
			end
			SGroup_ForEach(sg_beginnerhint_nearbysquads, _CheckSquad)
			
		elseif item.details.entity_required ~= nil then
			
			local _CheckEntity = function(gid, idx, eid)
				local result = _CheckPosition(Entity_GetPosition(eid))
				if result == false then
					EGroup_Remove(sg_beginnerhint_nearbysquads, eid)
				end
			end
			EGroup_ForEach(eg_beginnerhint_nearbyentities, _CheckEntity)
			
		end
		
	end
	
	-- if we're looking to merge units, filter squads to only those that are low on squad memebers
	if item.ability == HINT_MERGE then
		
		local _CheckSquad = function(gid, idx, sid)
			
			if Squad_Count(sid) > (Squad_GetMax(sid) / 2) then
				SGroup_Remove(sg_beginnerhint_nearbysquads, sid)
			end
		end
		SGroup_ForEach(sg_beginnerhint_nearbysquads, _CheckSquad)
		
	end
	
	

	-- create an empty table for results to go
	local results = {}

	-- test a squad (used directly, or via SGroup_ForEach)
	local _TestSquad = function(gid, idx, sid)
		local result = BeginnerHint_TestOpportunityOnSquad(item, sid)
		if result == true then
			local this_squad = {
				id = item.id,
				where = sid,
				ability = item.ability,
				details = item.details,
				repeating = item.repeating,
				arrow = item.arrow,
				message = item.message,
				icon = item.icon,
			}
			table.insert(results, this_squad)
		end
	end
	
	-- test an entity (used directly, or via EGroup_ForEach)
	local _TestEntity = function(gid, idx, eid)
		local result = BeginnerHint_TestOpportunityOnEntity(item, eid)
		if result == true then
			local this_entity = {
				id = item.id,
				where = eid,
				ability = item.ability,
				details = item.details,
				repeating = item.repeating,
				arrow = item.arrow,
				message = item.message,
				icon = item.icon,
			}
			table.insert(results, this_entity)
		end
	end
	
	
	if scartype(item.where) == ST_SGROUP then
		
		SGroup_ForEachEx(item.where, _TestSquad, true, false)
		return results
		
	elseif scartype(item.where) == ST_SQUAD then
		
		_TestSquad(nil, nil, item.where)
		return results
		
	elseif scartype(item.where) == ST_EGROUP then
		
		EGroup_ForEachEx(item.where, _TestEntity, true, false)
		return results
		
	elseif scartype(item.where) == ST_ENTITY then
		
		_TestEntity(nil, nil, item.where)
		return results
		
	else
		
		local result = BeginnerHint_TestOpportunityOnPosition(item, Util_GetPosition(item.where))
		
		if result == true then
			
			local this_entity = {
				id = item.id,
				where = item.where,
				ability = item.ability,
				details = item.details,
				repeating = item.repeating,
				arrow = item.arrow,
				message = item.message,
				icon = item.icon,
			}
			table.insert(results, this_entity)
			
		end
		
		return results
		
	end
	
	
end
	
	
	
-- take an opportunity (item), and see if it's appropriate for a target squad	
function BeginnerHint_TestOpportunityOnSquad(item, sid)

	
	-- only consider this point if it's on screen at the moment (this means it isn't MP-safe)
	if Misc_IsPosOnScreen(Util_GetPosition(sid), beginnerhint_data.screen_percent) == false or Player_CanSeeSquad(player1, sid, ANY) == false then
		return false
	end
	
	-- if this item has a squad / entity nearby requirement, exit if there isn't a suitable thing nearby
	if item.details.squad_required ~= nil then
		
		local range = item.details.range or 80
		if Prox_AreSquadsNearMarker(sg_beginnerhint_nearbysquads, Squad_GetPosition(sid), ANY, range) == false then
			return false
		end
		
		
	elseif item.details.entity_required ~= nil then
		
		local range = item.details.range or 80
		if Prox_AreEntitiesNearMarker(eg_beginnerhint_nearbyentities, Squad_GetPosition(sid), ANY, range) == false then
			return false
		end
		
	end
	
	-- check ability's cast-ability (yes, I just made that word up)
	if scartype(item.ability) == ST_PBG then
		
		if item.details.global_ability == true then													-- this is a hint pertaining to a specific ability that is GLOBAL to the player
			if Player_CanCastAbilityOnSquad(player1, item.ability, sid) then
				return true
			end
		elseif item.details.squad_required ~= nil then												-- this is a hint pertaining to a specific ability that is needs specific player squads nearby the target
			if SGroup_CanCastAbilityOnSquad(sg_beginnerhint_nearbysquads, item.ability, sid, ANY) then
				return true
			end
		elseif item.details.entity_required ~= nil then	
			return true
		end
		
		
	elseif scartype(item.ability) == ST_NUMBER then	
		
		if item.ability == HINT_REINFORCE and scartype(item.where) == ST_SGROUP then
			if Squad_Count(sid) <= (Squad_GetMax(sid) / 2) then			-- make sure that this squad is low on units, so you can merge into it
				return true
			end
		else
			return true	-- suitable opportunity
		end
		
	end
	
	-- if we've got this far, we can't have been deemed suitable
	return false
	
end



-- take an opportunity (item), and see if it's appropriate for a target entity	
function BeginnerHint_TestOpportunityOnEntity(item, eid)

	
	-- only consider this point if it's on screen at the moment (this means it isn't MP-safe)
	if Misc_IsPosOnScreen(Util_GetPosition(eid), beginnerhint_data.screen_percent) == false or Entity_IsPartOfSquad(eid) == true or Player_CanSeeEntity(player1, eid) == false then
		return false
	end
	
	-- if this item has a squad / entity nearby requirement, exit if there isn't a suitable thing nearby
	if item.details.squad_required ~= nil then
		
		local range = item.details.range or 80
		if Prox_AreSquadsNearMarker(sg_beginnerhint_nearbysquads, Entity_GetPosition(eid), ANY, range) == false then
			return false
		end
		
		
	elseif item.details.entity_required ~= nil then
		
		local range = item.details.range or 80
		if Prox_AreEntitiesNearMarker(eg_beginnerhint_nearbyentities, Entity_GetPosition(eid), ANY, range) == false then
			return false
		end
		
	end
	
	-- check cast-ability (yes, I just made that word up)
	if scartype(item.ability) == ST_PBG then
		
		if item.details.global_ability == true then													-- this is a hint pertaining to a specific ability that is GLOBAL to the player
			if Player_CanCastAbilityOnEntity(player1, item.ability, eid) then
				return true
			end
		elseif item.details.squad_required ~= nil then												-- this is a hint pertaining to a specific ability that is needs specific player squads nearby the target
			if SGroup_CanCastAbilityOnEntity(sg_beginnerhint_nearbysquads, item.ability, eid, ANY) then
				return true
			end
		end
		
		
	elseif scartype(item.ability) == ST_NUMBER then	
		
		return true	-- suitable opportunity
		
	end
	
	-- if we've got this far, we can't have been deemed suitable
	return false
	
end



-- take an opportunity (item), and see if it's appropriate for a target position
function BeginnerHint_TestOpportunityOnPosition(item, position)

	if scartype(item.ability) == ST_PBG then
		
		if item.details.global_ability == true then													-- this is a hint pertaining to a specific ability that is GLOBAL to the player
			if Player_CanCastAbilityOnPosition(player1, item.ability, position) then
				return true
			end
		elseif item.details.squad_required ~= nil then												-- this is a hint pertaining to a specific ability that is needs specific player squads nearby the target
			if SGroup_CanCastAbilityOnPosition(sg_beginnerhint_nearbysquads, item.ability, position, ANY) then
				return true
			end
		end
		
		
	elseif scartype(item.ability) == ST_NUMBER then	
		
		return true	-- suitable opportunity
		
	end
	
	-- if we've got this far, we can't have been deemed suitable
	return false
	
end





























-- pick the details for this ability out of the details table
function BeginnerHint_GetDetailsForAbility(ability)

	local finds = {}
	
	for index, details in pairs(t_beginnerhint_abilitydetails) do
		
		if scartype(details.ability) == ST_TABLE then
			
			for k, v in pairs(details.ability) do
				if v == ability then
					table.insert(finds, details)
				end
			end
			
		else
			
			if details.ability == ability then
				table.insert(finds, details)
			end
			
		end
		
	end
	
	-- otherwise, return a blank table
	return finds
	
end


-- functions to find the first *visible* squad or entity in a group
function BeginnerHint_PickASquad(where)
	
	if scartype(where) == ST_SGROUP then
		local _CheckSquad = function(gid, idx, sid)
			if Player_CanSeeSquad(player1, sid, ANY) then
				return sid
			end
		end
		SGroup_ForEach(where, _CheckSquad)
	end
	
	return where	-- safety: if we get here, just return the group again
	
end
function BeginnerHint_PickAnEntity(where)
	
	if scartype(where) == ST_EGROUP then
		local _CheckEntity = function(gid, idx, eid)
			if Player_CanSeeEntity(player1, eid) then
				return eid
			end
		end
		EGroup_ForEach(where, _CheckEntity)
	end
	
	return where	-- safety: if we get here, just return the group again
	
end





-- function to get an icon for a given ability
function BeginnerHint_GetIconFromAbility(item)
	
	if scartype(item) ~= ST_PBG then
		
		return nil 
		
	else
		
		return UI_GetAbilityIconName(item)
		
	end
	
end



-- functions to catch the last time abilities and commands were used
function BeginnerHint_MarkAbilityUse(caster, ability, target)

	if BeginnerHint_TestAbilityIsFromPlayer(caster, ability, target) == false then		-- check it came for a player 1 unit
		return
	end

	local id = BP_GetName(ability)
	
	t_beginnerhint_abilitytimestamps[id] = World_GetGameTime()
	t_beginnerhint_abilitytimestamps.last_ability = World_GetGameTime()
	
end

-- functions to catch the last time abilities and commands were used
function BeginnerHint_MarkCommandUse(caster, command, target)

	if BeginnerHint_TestCommandIsFromPlayer(caster, command, target) == false then		-- check it came for a player 1 unit
		return
	end
	
	local id = Enum_ToString(command)
	
	t_beginnerhint_commandtimestamps[id] = World_GetGameTime()
	
end

function BeginnerHint_GetLastAbilityUse(ability)

	local result
	
	if ability == ANY then
		local id = "last_ability"
		result = t_beginnerhint_abilitytimestamps[id]
	elseif scartype(ability) == ST_PBG then
		local id = BP_GetName(ability)
		result = t_beginnerhint_abilitytimestamps[id]
	else
 		result = t_beginnerhint_commandtimestamps[ability]
	end
	
	if result == nil then
		result = 0
	end
	
	return result
	
end




-- event callback function that catches the player using abilities
function BeginnerHint_AbilityCallback(caster, ability, target)
	
	if BeginnerHint_TestAbilityIsFromPlayer(caster, ability, target) == false then				-- check it came for a player 1 unit
		return
	end
	
	-- check the hint that is currently up, let's check to see if we should cancel it...
	if beginnerhint_data.current_hint ~= nil and beginnerhint_data.current_hint.ability == ability then
		
		if target == nil or																		-- ability didn't have a location OR
		   Util_GetDistance(beginnerhint_data.current_hint.where, target) <= 40 then			-- ability was cast near the current hint location
			
			-- set the flag to remove the current hint
			beginnerhint_data.remove_current_hint = true
			
		end
		
	end
	
end


-- event callback function that catches the player using the Merge ability
function BeginnerHint_MergeCallback(caster, ability, target)
	
	if BeginnerHint_TestAbilityIsFromPlayer(caster, ability, target) == false then				-- check it came for a player 1 unit
		return
	end
	
	-- check the hint that is currently up, let's check to see if we should cancel it...
	if beginnerhint_data.current_hint ~= nil and beginnerhint_data.current_hint.ability == ABILITY.SOVIET.MERGE_ABILITY then
		
		if scartype(caster) ~= ST_SQUAD or																		-- ability didn't have a location OR
		   Util_GetDistance(beginnerhint_data.current_hint.where, caster) <= 40 then			-- ability was cast near the current hint location
			
			-- set the flag to remove the current hint
			beginnerhint_data.remove_current_hint = true
			
		end
		
	end
	
end


-- event callback function that catches the player ordering a unit to move
function BeginnerHint_MoveOrderCallback(caster, command, target)
	
	if BeginnerHint_TestCommandIsFromPlayer(caster, command, target) == false then				-- check it came for a player 1 unit
		return
	end
	
	if command == SCMD_Move or command == SCMD_AttackMove or command == SCMD_DefaultAction then
		
		if Util_GetDistance(target, beginnerhint_data.current_hint.where) <= 20 then
			
			-- set the flag to remove the current hint
			beginnerhint_data.remove_current_hint = true
			
		end		
		
	end
	
end




-- event callback function that catches the player ordering a unit to place a demo charge
function BeginnerHint_DemoPackCallback(caster, command, target)
	
	if BeginnerHint_TestCommandIsFromPlayer(caster, command, target) == false then				-- check it came for a player 1 unit
		return
	end
	
	if beginnerhint_data.current_hint ~= nil then
		
		if command == SCMD_PlaceCharge and Util_GetDistance(target, beginnerhint_data.current_hint.where) <= 20 then
			
			-- set the flag to remove the current hint
			beginnerhint_data.remove_current_hint = true
			
		end
		
	end
	
end



-- event callback function that catches the player setting the rally point on a factory building
function BeginnerHint_RallyPointCallback(caster, command, target)
	
	if BeginnerHint_TestCommandIsFromPlayer(caster, command, target) == false then				-- check it came for a player 1 unit
		return
	end
	
	if beginnerhint_data.current_hint ~= nil then
		
		if command == CMD_RallyPoint and Util_GetDistance(target, beginnerhint_data.current_hint.where) <= 20 then
			
			-- set the flag to remove the current hint
			beginnerhint_data.remove_current_hint = true
			
		end
		
	end
	
end


-- event callback function that catches the player reinforcing a squad
function BeginnerHint_ReinforceCallback(caster, command, target)
	
	if BeginnerHint_TestCommandIsFromPlayer(caster, command, target) == false then		-- check it came for a player 1 unit
		return
	end
	
	if beginnerhint_data.current_hint ~= nil then
		
		if command == SCMD_ReinforceUnit then
			
			-- set the flag to remove the current hint
			beginnerhint_data.remove_current_hint = true
			
		end
		
	end
	
end


-- event callback function that catches the player picking something up off the battlefield
function BeginnerHint_PickUpCallback(caster, command, target)
	
	if BeginnerHint_TestCommandIsFromPlayer(caster, command, target) == false then		-- check it came for a player 1 unit
		return
	end
	
	if beginnerhint_data.current_hint ~= nil then
		
		if command == SCMD_PickUpSlotItem and Util_GetDistance(target, beginnerhint_data.current_hint.where) <= 20 then
			
			-- set the flag to remove the current hint
			beginnerhint_data.remove_current_hint = true
			
		end
		
	end
	
end





function BeginnerHint_TestCommandIsFromPlayer(caster, command, target)

	if scartype(caster) == ST_PLAYER then
		
--~ 		print("Player ".. Player_GetID(caster).." - Command "..Enum_ToString(command))
		
		if caster == player1 then
			return true
		end
		
	elseif scartype(caster) == ST_SQUAD then
		
--~ 		print("Squad "..BP_GetName(Squad_GetBlueprint(caster)).." - Command "..Enum_ToString(command))
		
		if Player_OwnsSquad(player1, caster) then
			return true
		end
		
	elseif scartype(caster) == ST_ENTITY then
		
--~ 		print("Entity "..BP_GetName(Entity_GetBlueprint(caster)).." - Command "..Enum_ToString(command))
		
		if Player_OwnsEntity(player1, caster) then
			return true
		end
		
	end
	
	return false
	
end


function BeginnerHint_TestAbilityIsFromPlayer(caster, ability, target)

	if scartype(caster) == ST_PLAYER then
		
--~ 		print("Player ".. Player_GetID(caster).." - Ability "..BP_GetName(ability))
		
		if caster == player1 then
			return true
		end
		
	elseif scartype(caster) == ST_SQUAD then
		
--~ 		print("Squad "..BP_GetName(Squad_GetBlueprint(caster)).." - Ability "..BP_GetName(ability))
		
		if Player_OwnsSquad(player1, caster) then
			return true
		end
		
	elseif scartype(caster) == ST_ENTITY then
		
--~ 		print("Entity "..BP_GetName(Entity_GetBlueprint(caster)).." - Ability "..BP_GetName(ability))
		
		if Player_OwnsEntity(player1, caster) then
			return true
		end
		
	end
	
	return false
	
end




-- this table holds details about requirements for certain abilities (so we don't show an ability hint if the player doesn't have the necessary units, etc)
t_beginnerhint_abilitydetails = {			
	
	-- each entry can have the following keys:
	--   ability 			- REQUIRED - name of the ability (or set of abilities that are grouped under the same category)
	--   message			- REQUIRED - the default message that is shown alongside the hint for this ability (although it may be overridden by the script)
	--   icon				- OPTIONAL - the icon that will appear alongside the hintpoint (should match the icon in the player's control bar) - it will try to derive the icon from the ability if left off
	--   arrow				- OPTIONAL - the arrow type to use (HPAT_something) if you don't want the default
	--   squad_required		- OPTIONAL - the blueprints of the squads that are needed nearby in order to use this ability (i.e. squads that have that ability)
	--   entity_required	- OPTIONAL - the blueprints of the entities that are needed nearby in order to use this ability (i.e. proximity requirements)
	--   range				- OPTIONAL - how close a squad needs to be to the hint location (default is 80 if this is omitted, but you may want to increase this for long range abilities)
	--   directional		- OPTIONAL - set this to true if you only want to look for squads on the side of the marker the direction arrow points towards
	--   global_ability		- OPTIONAL - set this to true to mean this is triggered by the player from their global ability bar, and doesn't need a squad nearby
	--   callback			- OPTIONAL - table with the values func and event, specify the details for setting up the callback checker function. If ommitted it uses BeginnerHint_AbilityCallback and GE_AbilityExecuted
	
	-- ALWAYS ADD NEW ENTRIES TO THE END OF THE LIST ONCE A VERSION HAS SHIPPED (else you may break save games)
	
	{ability = ABILITY.SOVIET.ANTI_TANK_GRENADE,					squad_required = SBP.SOVIET.CONSCRIPT_SQUAD,			message = 11043093},					-- LOCDB [11043093] 'Conscripts have Anti-Tank Grenades they can use here'
	{ability = ABILITY.SOVIET.CONSCRIPT_MOLOTOV_COCKTAIL,			squad_required = {SBP.SOVIET.CONSCRIPT_SQUAD,
																					  SBP.SOVIET.BASE_CONSCRIPT_SQUAD},		message = 11043082},					-- LOCDB [11043082] 'Conscripts have Molotov Cocktails they can use here'
	{ability = ABILITY.SOVIET.RG_42_ANTI_PERSONNEL_GRENADE,			squad_required = SBP.SOVIET.SHOCK_TROOPS, 				message = 11043193},					-- LOCDB [11043193] 'Shock Troops have Grenades they can use here'
	{ability = ABILITY.SOVIET.RGD_1_SMOKE_GRENADE,					squad_required = SBP.SOVIET.GUARDS_TROOPS, 				message = 11043192},					-- LOCDB [11043192] 'Guard Rifle Infantry have Smoke Grenades they can throw here to cover your approach'
	{ability = ABILITY.SOVIET.IL_2_ATTACK_STRAFE,					global_ability = true,									message = 11043094},					-- LOCDB [11043094] 'Your commander can call in an IL-2 Sturmovik Attack here'
	{ability = ABILITY.SOVIET.IL_2_BOMBING_RUN_SP,					global_ability = true, 									message = 11043095},					-- LOCDB [11043095] 'Your commander can call in an IL-2 Sturmovik Bombing Run here'
	{ability = ABILITY.SOVIET.IL_2_RECON,							global_ability = true,                                  message = 11043096},					-- LOCDB [11043096] 'Your commander can call in a Recon Overflight here'
	{ability = ABILITY.SOVIET.SYNC_MORTAR_BARRAGE_120MM,			squad_required = SBP.SOVIET.HM_120_38_MORTAR_SQUAD,		message = 11043080,	range = 150},		-- LOCDB [11043080] 'Mortar Squads have a Barrage ability they can target here'
	{ability = ABILITY.SOVIET.SYNC_MORTAR_BARRAGE,					squad_required = SBP.SOVIET.PM_82_41_MORTAR_SQUAD,		message = 11043080,	range = 150},		-- LOCDB [11043080] 'Mortar Squads have a Barrage ability they can target here'
	{ability = ABILITY.SOVIET.SU_76_BARRAGE_ABILITY,				squad_required = SBP.SOVIET.SU_76M,						message = 11043081,	range = 230},		-- LOCDB [11043081] 'SU-76s have a Barrage ability they can target here'
	{ability = ABILITY.SOVIET.ISU_152_PIERCING_SHOT_ABILITY,		squad_required = SBP.SOVIET.ISU_152,					message = 11043083,	range = 200},		-- LOCDB [11043083] 'ISU-152's have a Piercing Shot ability they can target here'
	
	{ability = ABILITY.SOVIET.RGD_1_SMOKE_GRENADE,					squad_required = {SBP.SOVIET.SHOCK_TROOPS,
																					  SBP.SOVIET.SHOCK_TROOPS_M11},			message = 11043084},					-- LOCDB [11043084] 'Shock Troops have Smoke Grenades they can throw here to cover your approach'
	
	{ability = ABILITY.GLOBAL.CAMOUFLAGE_CONSTRUCTION,				squad_required = {SBP.SOVIET.M11_ANIA_SNIPER_SQUAD, 
																					  SBP.SOVIET.M11_SNIPER_TEAM}, 			message = 11043085},					-- LOCDB [11043085] 'Snipers can set up cover here'
	
	-- non-ability locational items
	{ability = HINT_LIGHTCOVER,										squad_required = LIST.INFANTRY,							directional = true, message = 11043086, arrow = HPAT_CoverYellow, callback = {func = BeginnerHint_MoveOrderCallback, event = GE_SquadCommandIssued}},				-- LOCDB [11043086] 'Move your infantry into cover here'
	{ability = HINT_HEAVYCOVER,										squad_required = LIST.INFANTRY,							directional = true, message = 11043087, arrow = HPAT_CoverGreen, callback = {func = BeginnerHint_MoveOrderCallback, event = GE_SquadCommandIssued}},				-- LOCDB [11043087] 'Move your infantry into heavy cover here'
	{ability = HINT_NEGATIVECOVER,									squad_required = LIST.INFANTRY,							directional = true, message = 11043088, arrow = HPAT_CoverRed, callback = {func = BeginnerHint_MoveOrderCallback, event = GE_SquadCommandIssued}},					-- LOCDB [11043088] 'Beware of leaving units out in the open here'
	{ability = HINT_DEEPSNOW,										squad_required = LIST.INFANTRY,							directional = true, message = 11043089, arrow = HPAT_DeepSnow, callback = {func = BeginnerHint_MoveOrderCallback, event = GE_SquadCommandIssued}},					-- LOCDB [11043089] 'Beware of deep snow here'
	{ability = HINT_FLANK,											squad_required = LIST.INFANTRY,							directional = true, message = 11043090, arrow = HPAT_FormationSetup, callback = {func = BeginnerHint_MoveOrderCallback, event = GE_SquadCommandIssued}},			-- LOCDB [11043090] 'Flank the enemy here'
	
	-- other misc special cases
	{ability = HINT_MERGE,											squad_required = {
																					  SBP.SOVIET.SHOCK_TROOPS, 					-- no hints for snipers (you can't merge into them), or other conscripts (we don't want to tell you to merge conscripts into other conscripts!)
																					  SBP.SOVIET.GUARDS_TROOPS,
																					  SBP.SOVIET.COMBAT_ENGINEER_SQUAD,
	                                                                                  SBP.SOVIET.HM_120_38_MORTAR_SQUAD,
	                                                                                  SBP.SOVIET.PM_82_41_MORTAR_SQUAD,
	                                                                                  SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD,
	                                                                                  SBP.SOVIET.DSHK_38_HMG_SQUAD,
																					  SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD,
																					  SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD,
																					  SBP.SOVIET.M08_COMBAT_ENGINEER_SQUAD,
																					  
	                                                                                  SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	-- player can steal these off the enemy
	                                                                                  SBP.GERMAN.MORTAR_TEAM_81MM,
																			 		  SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
																					  SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD, 
																					 },																												icon = "Icons_abilities_ability_soviet_merge", message = 11049991, range = 35, callback = {func = BeginnerHint_MergeCallback, event = GE_AbilityExecuted}},					-- LOCDB [11049991] 'You can merge this squad into other, injured squads'
	{ability = HINT_DEMOCHARGE,										squad_required = SBP.SOVIET.COMBAT_ENGINEER_SQUAD,						equiv_command = Enum_ToString(SCMD_PlaceCharge),		icon = "Icons_abilities_ability_soviet_demo_charge", message = 11043091, range = 35, callback = {func = BeginnerHint_DemoPackCallback, event = GE_SquadCommandIssued}},		-- LOCDB [11043091] 'Combat Engineers can place demo charges here'
	{ability = HINT_RALLYPOINT,										global_ability = true,																											icon = "Icons_commands_icon_command_rallypoint", message = 11043092, callback = {func = BeginnerHint_RallyPointCallback, event = GE_EntityCommandIssued}},	 				-- LOCDB [11043092] 'You can set your base building's Rally Point here'
	{ability = HINT_REINFORCE,										squad_required = {SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
																					  SBP.SOVIET.M5_HALFTRACK_SQUAD},						equiv_command = Enum_ToString(SCMD_ReinforceUnit),		icon = "Icons_odds_reinforce", message = 11049992, range = 35, callback = {func = BeginnerHint_ReinforceCallback, event = GE_SquadCommandIssued}},						-- LOCDB [11049992] 'You can reinforce this squad at a nearby Halftrack'
	{ability = HINT_REINFORCE,										entity_required = {EBP.SOVIET.HQ,
																					   BP_GetEntityBlueprint("sp_hq")},						equiv_command = Enum_ToString(SCMD_ReinforceUnit),		icon = "Icons_odds_reinforce", message = 11049993, range = 50, callback = {func = BeginnerHint_ReinforceCallback, event = GE_SquadCommandIssued}},						-- LOCDB [11049993] 'You can reinforce this squad at your HQ'
	{ability = HINT_REINFORCE,										entity_required =  BP_GetEntityBlueprint("m11_military_hospital"),		equiv_command = Enum_ToString(SCMD_ReinforceUnit),		icon = "Icons_odds_reinforce", message = 11050047, range = 50, callback = {func = BeginnerHint_ReinforceCallback, event = GE_SquadCommandIssued}},						-- LOCDB [11050047] 'You can reinforce this squad at the Military Hospital'
	{ability = HINT_PICKUP,											squad_required = LIST.INFANTRY,											equiv_command = Enum_ToString(SCMD_PickUpSlotItem),		icon = "Icons_tooltips_pick_up_item", message = 11045933, range = 35, callback = {func = BeginnerHint_PickUpCallback, event = GE_SquadCommandIssued}},						-- LOCDB [11045933] 'Infantry squads can pick this item up'

	
	
	
	-- FIRST RELEASE VERSION
	
}

beginnerhint_detect_reload = true
