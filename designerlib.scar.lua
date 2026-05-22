--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- DESIGNER LIBRARY
-- Provides some high level functions for us to set things up simply.
--
-- 'cos we're lazy like that.
-- 
-- (c) 2005 Relic Entertainment
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function DesignerLib_Init()
	
	_AutoReinforceTable = {}		-- Auto Reinforce
	_lastknownposcheckticker = 1
	
	_AutoRetreatTable = {}			-- Auto Retreat
	
	_AutoChargeTable = {}			-- Auto Charge
	_lastautochargeindex = 1
	
	_CeasefireTable = {}			-- Ceasefire
	
	_MarchTable = {}				-- March Territory Forwards
	
	_AutoTerritoryTable = {}		-- Auto Territory
	_lastautoterritoryindex = 1
	
	_ShootTheSkyTable = {}			-- Shoot the Sky
	sg_shoottheskygroup = SGroup_CreateIfNotFound("sg_shoottheskygroup")
	
	_BridgeTerritoryTable = {}
	
	_TeamWeaponTable = {}
	
	_ATGunSBPs = {
		SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD, 
		SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD,
		
		SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
	}
	
	_HMGGunSBPs = {
		SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD,
		
		SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
	}
	
end
Scar_AddInit(DesignerLib_Init)



--? @group scardoc;Stats

--? @shortdesc Takes a statistic function and totals up the results for all the players on a given team
--? @args Integer teamindex, Function statfunction
--? @result Integer
function Stats_TeamTally(team, statfunc)
	
	local result = 0
	
	local _OnePlayer = function(teamid, playerindex, playerid)
		result = result + statfunc(playerid)
	end

	Team_ForEach(team, _OnePlayer)
	
	return result
	
end



--? @group scardoc;DesignerLib

-------------------------------------------------------------------------
-- Auto Cinematic - In/Out
-- @degnan
-------------------------------------------------------------------------
--? @shortdesc Toggles all cinematic related settings. true = go to cinematic, false = go back to normal
--? @result Void
--? @args Boolean in/out, Real seconds
function AutoCinematic(boolean, secs)
	Game_Letterbox(boolean, secs)
	Game_FadeToBlack(boolean, secs)
end

-------------------------------------------------------------------------
--
-- AUTO-REINFORCE FUNCTIONS
--
-- These functions continually monitor a group on your behalf and
-- reinforce that group should it drop beneath half it's initial member
-- count. Currently it assumes one squad per group, but this might be
-- fixed later on if there's enough demand!
-- 
-- You can use this on several groups at once and each group is
-- independant of the others, so make sure you have everyone you want to
-- be in one autoreinforce set in one group.
--
-- This uses an SGroup to reference the group throughout, so you should
-- use a group that will always reference the same guys (i.e. don't use
-- a temp group which you subsequently clear out)
--
-------------------------------------------------------------------------

--? @shortdesc Adds an SGroup to the auto-reinforce functions
--? @result Void
--? @args SGroupID sgroup, Variable origin
function AutoReinforce_AddSGroup(sgroup, originpos)
	
	if (scartype(originpos) ~= ST_SCARPOS) then					
		originpos = Util_GetPosition(originpos)
	end
	
	-- do some type checking
	if (scartype(sgroup) ~= ST_SGROUP) then fatal("AutoReinforce_AddSGroup: SGroupID is invalid") end
	
	-- remove any old references to the SGroup from the table
	for n = table.getn(_AutoReinforceTable), 1, -1 do
		if (_AutoReinforceTable[n].sgroupid == sgroup) then
			table.remove(_AutoReinforceTable, n)
		end
	end
	
	if (SGroup_Count(sgroup) >= 1) then
		
		local thisplayer = Squad_GetPlayerOwner(SGroup_GetSpawnedSquadAt(sgroup, 1))
		local thisblueprint = Squad_GetBlueprint(SGroup_GetSpawnedSquadAt(sgroup, 1))
		local thispos = Squad_GetPosition(SGroup_GetSpawnedSquadAt(sgroup, 1))
		local thisthreshold = Squad_GetMax(SGroup_GetSpawnedSquadAt(sgroup, 1))*0.5
		
		-- add the new group
		table.insert(_AutoReinforceTable, {sgroupid = sgroup, playerid = thisplayer, blueprint = thisblueprint, lastknownpos = thispos, origin = originpos, threshold = thisthreshold})
		
		-- start up the manager rule if it isn't running already
		if (Rule_Exists(AutoReinforce_Manager) == false) and (table.getn(_AutoReinforceTable) >= 1) then
			Rule_Add(AutoReinforce_Manager)
		end
		
	else
		print("*** WARNING in AutoReinforce_AddSGroup: SGroup is empty ***")
	end
	
end


--? @shortdesc Removes an SGroup from the auto-reinforce functions
--? @result Void
--? @args SGroupID sgroup
function AutoReinforce_RemoveSGroup(sgroup)
	
	-- do some type checking
	if (scartype(sgroup) ~= ST_SGROUP) then fatal("AutoReinforce_RemoveSGroup: SGroupID is invalid") end
	
	for n = table.getn(_AutoReinforceTable), 1, -1 do
		if (_AutoReinforceTable[n].sgroupid == sgroup) then
			table.remove(_AutoReinforceTable, n)
		end
	end
	
	-- if we removed the last items from the table, remove the manager rule
	if (table.getn(_AutoReinforceTable) == 0) and (Rule_Exists(AutoReinforce_Manager) == true) then
		Rule_Remove(AutoReinforce_Manager)
	end
	
end


--? @shortdesc Stops monitoring all squads from the auto-reinforce functions
--? @result Void
--? @args Void
function AutoReinforce_RemoveAll()

	-- blank out the table
	_AutoReinforceTable = {}
	
	-- remove the manager rule
	if (Rule_Exists(AutoReinforce_Manager) == true) then
		Rule_Remove(AutoReinforce_Manager)
	end
	
end


function AutoReinforce_Manager()

	for n = 1, table.getn(_AutoReinforceTable) do
		
		if (SGroup_TotalMembersCount(_AutoReinforceTable[n].sgroupid) == 0) then
			-- squad is dead, recreate the squad and run them in
			
			print("Replacing Squad")
			
			local pos = World_GetHiddenPositionOnPath(_AutoReinforceTable[n].playerid, _AutoReinforceTable[n].origin, _AutoReinforceTable[n].lastknowpos, CHECK_BOTH)
			if (pos == nil) then
				Util_CreateSquadsAtMarkerFacing(_AutoReinforceTable[n].playerid, _AutoReinforceTable[n].sgroupid, _AutoReinforceTable[n].blueprint, _AutoReinforceTable[n].origin, _AutoReinforceTable[n].lastknownpos, 1)
			else
				Util_CreateSquadsAtMarkerFacing(_AutoReinforceTable[n].playerid, _AutoReinforceTable[n].sgroupid, _AutoReinforceTable[n].blueprint, pos, _AutoReinforceTable[n].lastknownpos, 1)
			end
			
		elseif (SGroup_TotalMembersCount(_AutoReinforceTable[n].sgroupid) < _AutoReinforceTable[n].threshold) then
			-- squad has dropped below threshold, reinforce it
			
			local reinforcecount = math.ceil(Squad_GetMax(SGroup_GetSpawnedSquadAt(_AutoReinforceTable[n].sgroupid, 1))*0.5)
			print("Reinforcing Squad: "..reinforcecount)
			Cmd_InstantReinforceUnitPos(_AutoReinforceTable[n].sgroupid, reinforcecount, _AutoReinforceTable[n].origin, CHECK_OFFCAMERA)
			
		else
			-- squad is fine, just update the squad's position (every so often)
			
			print("Saving Squad Position")
			
			if 	(_lastknownposcheckticker == 0) then
				_AutoReinforceTable[n].lastknownpos = SGroup_GetPosition(_AutoReinforceTable[n].squadid)
			end
			
		end
		
	end

	_lastknownposcheckticker = _lastknownposcheckticker + 1
	if 	(_lastknownposcheckticker == 10) then
		_lastknownposcheckticker = 0
	end

end

-------------------------------------------------------------------------
--
-- AUTO-RETREAT FUNCTIONS
--
-- These functions continually monitor a group on your behalf and
-- trigger a retreat action once they take a certain amount of
-- punsihment. The trigger conditions are:
-- a) SGroup_TotalMembersCount is reduced to half the starting size *or*
-- b) SGroup is pinned for 6 to 10 seconds (random per group)
-- 
-- You can use this on several groups at once and each group is
-- independant of the others, so make sure you have everyone you want to
-- be in one autoretreat set in one group. You can also specify a
-- threshold to use instead of half (the default)
--
-- This uses an SGroup to reference the group throughout, so you should
-- use a group that will always reference the same guys (i.e. don't use
-- a temp group which you subsequently clear out)
-- 
-------------------------------------------------------------------------


--? @shortdesc Sets an sgroup to retreat to the given destination or building once pinned for a certain duration, or reduced to a third of it's original size
--? @extdesc The optional threshold value should be a percentage (between 0.0 and 1.0) - when the member count drops below this, they retreat
--? @result Void
--? @args SGroupID sgroup, MarkerID/Position/EGroupID destination[, Real threshold, LuaFunction onTrigger]
function AutoRetreat_AddSGroup(sgroup, dest, threshold, func)
	
	if (scartype(dest) == ST_MARKER) then
		dest = Marker_GetPosition(dest)
	end
	
	if threshold == nil then
		threshold = 0.5
	end
	
	-- do some type checking
	if (scartype(sgroup) ~= ST_SGROUP) then fatal("AutoRetreat_AddSGroup: SGroupID is invalid") end
	
	if (SGroup_Count(sgroup) >= 1) then
		
		-- remove any old references to the SGroup from the table
		for n = table.getn(_AutoRetreatTable), 1, -1 do
			if (_AutoRetreatTable[n].group == sgroup) then
				table.remove(_AutoRetreatTable, n)
			end
		end
		
		-- add the new group
		table.insert(_AutoRetreatTable, {group = sgroup, destination = dest, pinnedtime = nil, duration = World_GetRand(6, 10), threshold = math.floor(SGroup_TotalMembersCount(sgroup) * threshold), ontrigger = func})
		
		-- start up the manager rule if it isn't running already
		if (Rule_Exists(AutoRetreat_Manager) == false) and (table.getn(_AutoRetreatTable) >= 1) then
			Rule_AddInterval(AutoRetreat_Manager, 1)
		end
		
	end
	
end


--? @shortdesc Removes a squad from being monitored by the auto-retreat functions
--? @result Void
--? @args SGroupID sgroup
function AutoRetreat_RemoveSGroup(sgroup)

	-- do some type checking
	if (scartype(sgroup) ~= ST_SGROUP) then fatal("AutoRetreat_RemoveSGroup: SGroupID is invalid") end
	
	-- remove any old references to the SGroup from the table
	for n = table.getn(_AutoRetreatTable), 1, -1 do
		if (_AutoRetreatTable[n].group == sgroup) then
			table.remove(_AutoRetreatTable, n)
		end
	end

	-- if we removed the last item, remove the manager rule
	if (Rule_Exists(AutoRetreat_Manager) == true) and (table.getn(_AutoRetreatTable) == 0) then
		Rule_Remove(AutoRetreat_Manager)
	end
	
end


--? @shortdesc Stops monitoring all squads from the auto-retreat functions
--? @result Void
--? @args Void
function AutoRetreat_RemoveAll()

	-- blank out the table
	_AutoRetreatTable = {}
	
	-- remove the manager rule
	if (Rule_Exists(AutoRetreat_Manager) == true) then
		Rule_Remove(AutoRetreat_Manager)
	end
	
end



function AutoRetreat_Manager()
	
	for n = table.getn(_AutoRetreatTable), 1, -1 do
		
		if (SGroup_Count(_AutoRetreatTable[n].group) == 0) then
			table.remove(_AutoRetreatTable, n)
		else
			
			-- see if the squad is pinned...
			if (SGroup_GetSuppression(_AutoRetreatTable[n].group) > 0.4) then
				if (_AutoRetreatTable[n].pinnedtime == nil) then
					-- just become pinned
					_AutoRetreatTable[n].pinnedtime = World_GetGameTime()
				elseif ((World_GetGameTime() - _AutoRetreatTable[n].pinnedtime) > _AutoRetreatTable[n].duration) then
					-- been pinned for more than 10 seconds
					AutoRetreat_Retreat(_AutoRetreatTable[n])
					table.remove(_AutoRetreatTable, n)
				else
					-- not 10 seconds yet: do nothing (but still check for dropping to the threshold)
					if (SGroup_TotalMembersCount(_AutoRetreatTable[n].group) <= _AutoRetreatTable[n].threshold) then
						AutoRetreat_Retreat(_AutoRetreatTable[n])
						table.remove(_AutoRetreatTable, n)					
					end
				end
			else
				-- not pinned, so ensure the pinned time is blank
				_AutoRetreatTable[n].pinnedtime = nil
				
				-- see if the squad has dropped to the threshold
				if (SGroup_TotalMembersCount(_AutoRetreatTable[n].group) <= _AutoRetreatTable[n].threshold) then
					AutoRetreat_Retreat(_AutoRetreatTable[n])
					table.remove(_AutoRetreatTable, n)					
				end
				
			end
			
		end
		
	end
	
	-- if we removed the last items from the table, remove the manager rule
	if (table.getn(_AutoRetreatTable) == 0) then
		Rule_Remove(AutoRetreat_Manager)
	end
	
end




function AutoRetreat_Retreat(me)
	
	print("Retreating: "..SGroup_GetName(me.group))
	
	-- retreat to the location and/or garrison the destination building
	if scartype(me.destination) == ST_SCARPOS then
		Cmd_Retreat(me.group, me.destination)
	elseif scartype(me.destination) == ST_EGROUP then
		Cmd_Retreat(me.group, EGroup_GetPosition(me.destination))
		Cmd_Garrison(me.group, me.destination, false, true) -- queued
	end
	
	-- call the trigger function if one exists
	if scartype(me.ontrigger) == ST_FUNCTION then
		me.ontrigger()
	end
	
--~ 	-- remove this squad from the autocharge routines if it's in there
--~ 	AutoCharge_RemoveSGroup(me.group)
	
end

-------------------------------------------------------------------------
--
-- CEASEFIRE FUNCTIONS
--
-- The Ceasefire library helps in setting up ambushes. All units in a 
-- group you add to a ceasefire will NOT auto-target anything, until one
-- unit amongst them starts firing (either via a player order or a forced
-- SCAR command). At that point, all units in the group break their 
-- ceasefire and start auto-targetting again.
--
-- You can use this on several groups at once and each group is
-- independant of the others, so make sure you have everyone you want to
-- be in one ceasefire in one group.
--
-- This uses an SGroup to reference the group throughout, so you should
-- use a group that will always reference the same guys (i.e. don't use
-- a temp group which you subsequently clear out)
--
-------------------------------------------------------------------------

--? @shortdesc Stops an SGroup from auto-targetting, until one of their members is explicity given an attack order or Ceasefire_RemoveSGroup() is called (at which point they all start firing again)
--? @extdesc You can optionally specify a function that will be called when the ceasefire is broken by the game (rather than by calling Ceasefire_RemoveSGroup)
--? @result Void
--? @args SGroupID sgroup[, LuaFunction function]
function Ceasefire_AddSGroup(sgroup, onattack)
	
	-- create the appropriate modifier
	local modifier = Modifier_Create(MAT_Weapon, "modifiers\\auto_target_enable_weapon_modifier.lua", MUT_Enable, true, -1, "hardpoint_01")
	local result = {}
	
	-- apply this to each squad in the group
	local _ApplyModifier = function (gid, idx, sid)
		for n = 1, Squad_Count(sid) do
			local eid = Squad_EntityAt(sid, n-1)
			table.insert(result, Modifier_ApplyToEntity(modifier, eid))
		end
	end
	SGroup_ForEach(sgroup, _ApplyModifier)
	
	table.insert(_CeasefireTable, {sgroup = sgroup, egroup = nil, modifier = result, func = onattack})
	
	if (Rule_Exists(Ceasefire_Manager) == false) then
		Rule_AddInterval(Ceasefire_Manager, 2)
	end
	
end


--? @shortdesc Removes the ceasefire effect from an sgroup. This may already have been removed by issuing an attack order directly to the group.
--? @result Void
--? @args SGroupID sgroup
function Ceasefire_RemoveSGroup(sgroup)

	-- remove the auto-targetting disabler modifiers applied to the sgroup
	for n = table.getn(_CeasefireTable), 1, -1 do
		
		if (_CeasefireTable[n].sgroup == sgroup) then
			Modifier_Remove(_CeasefireTable[n].modifier)
			table.remove(_CeasefireTable, n)
		end
		
	end
	
	-- remove the manager rule if we just removed the last group
	if (table.getn(_CeasefireTable) == 0) then
		if (Rule_Exists(Ceasefire_Manager) == true) then
			Rule_Remove(Ceasefire_Manager)
		end
	end
	
end


-- internal function that manages the ceasefires
function Ceasefire_Manager()

	for n = table.getn(_CeasefireTable), 1, -1 do
		
		if SGroup_IsEmpty(_CeasefireTable[n].sgroup) then
			table.remove(_CeasefireTable, n)
			return
		end
		
		-- if anyone in this group is attacking...
		if SGroup_IsDoingAttack(_CeasefireTable[n].sgroup, ANY, 5) then
			
			-- run the associated function if specified
			if (_CeasefireTable[n].func ~= nil) then
				_CeasefireTable[n].func()
			end
			
			-- remove the modifiers from everybody
			Ceasefire_RemoveSGroup(_CeasefireTable[n].sgroup)
			
		end
		
	end
	
end

--~ --TEMP
--~ function SGroup_IsAttacking(group, all)

--~ 	local _CheckSqaud = function (gid, idx, sid)
--~ 		if Squad_HasActiveCommand(sid) then
--~ 			local command = Squad_GetActiveCommand(sid)
--~ 			if (command == SQUADSTATEID_Combat) then
--~ 				return true
--~ 			else
--~ 				return false
--~ 			end
--~ 		else
--~ 			return false
--~ 		end
--~ 	end

--~ 	return SGroup_ForEachAllOrAny(group, all, _CheckSqaud)
--~ 	
--~ end


-------------------------------------------------------------------------
--
-- SHOOT THE SKY FUNCTIONS
--
-- Registering a Sync Weapon with this system makes it shoot up in the
-- air continually, until it is either destroyed or told to stop.
-- 
-------------------------------------------------------------------------


--? @shortdesc Forces a sync weapon to shoot at the sky, so long as it's manned by a given player.
--? @result Void
--? @args SyncWeaponID syncweapon, PlayerID player
function ShootTheSky_AddSyncWeapon(swid, playerid)
	
	if SyncWeapon_Exists(swid) then
		
		-- remove any previous entries
		for n = table.getn(_ShootTheSkyTable), 1, -1 do
			if _ShootTheSkyTable[n].weapon == swid then
				table.remove(_ShootTheSkyTable, n)
			end
		end
		
		-- add the new weapon to the table
		table.insert(_ShootTheSkyTable, {weapon = swid, pos = Entity_GetPosition(SyncWeapon_GetEntity(swid)), player = playerid} )
		
		-- fire off the manager rule if it isn't already going
		if Rule_Exists(ShootTheSky_Manager) == false then
			Rule_AddInterval(ShootTheSky_Manager, 3)
		end
		
	end
	
end


--? @shortdesc Removes a sync weapon from the "shoot at the sky" system. It can then target people again.
--? @result Void
--? @args SyncWeaponID syncweapon
function ShootTheSky_RemoveSyncWeapon(swid)
	
	
	-- remove any existing entries with this swid
	for n = table.getn(_ShootTheSkyTable), 1, -1 do
		
		local this = _ShootTheSkyTable[n]
		if this.weapon == swid then
		
			-- stop the gun firing
			if SyncWeapon_Exists(this.weapon) and SyncWeapon_IsOwnedByPlayer(this.weapon, this.player) then
				if Entity_IsPartOfSquad(SyncWeapon_GetEntity(this.weapon)) then
					local squad = Entity_GetSquad(SyncWeapon_GetEntity(this.weapon))
					SGroup_Single(sg_shoottheskygroup, squad)
					Cmd_Stop(sg_shoottheskygroup)
				end
			end
			
			table.remove(_ShootTheSkyTable, n)
			
		end
	end

	-- remove the manager rule if we just removed the last weapon
	if table.getn(_ShootTheSkyTable) == 0 then
		if Rule_Exists(ShootTheSky_Manager) then
			Rule_Remove(ShootTheSky_Manager)
		end	
	end
	
end


--? @shortdesc Stops all sync weapons from going through their "shooting at the sky" routine.
--? @result Void
--? @args Void
function ShootTheSky_RemoveAll()
	
	-- remove any existing entries with this swid
	for n = table.getn(_ShootTheSkyTable), 1, -1 do
		
		local this = _ShootTheSkyTable[n]
		
		-- stop the gun firing
		if SyncWeapon_Exists(this.weapon) and SyncWeapon_IsOwnedByPlayer(this.weapon, this.player) then
			if Entity_IsPartOfSquad(SyncWeapon_GetEntity(this.weapon)) then
				local squad = Entity_GetSquad(SyncWeapon_GetEntity(this.weapon))
				SGroup_Single(sg_shoottheskygroup, squad)
				Cmd_Stop(sg_shoottheskygroup)
			end
		end
		
		table.remove(_ShootTheSkyTable, n)
		
	end
	
	-- remove the manager rule
	if Rule_Exists(ShootTheSky_Manager) then
		Rule_Remove(ShootTheSky_Manager)
	end	
	
end





function ShootTheSky_Manager()
	
	for n = 1, table.getn(_ShootTheSkyTable) do
		
		local this = _ShootTheSkyTable[n]
		
		-- check to see if it's owned by the correct player first
		if SyncWeapon_Exists(this.weapon) and SyncWeapon_IsOwnedByPlayer(this.weapon, this.player) then
			
			if Entity_IsPartOfSquad(SyncWeapon_GetEntity(this.weapon)) then
				
				local squad = Entity_GetSquad(SyncWeapon_GetEntity(this.weapon))
				
				SGroup_Single(sg_shoottheskygroup, squad)
				
				local dir = World_GetRand(1, 3141) / 1000
				local pos = World_Pos(this.pos.x + (math.sin(dir) * 30), this.pos.y + (World_GetRand(90, 140)/3), this.pos.z + (math.cos(dir) * 30))
				
				Command_SquadPos(this.player, sg_shoottheskygroup, SCMD_Attack, pos, false)			
				
			end
			
		end
		
	end
	
end


-------------------------------------------------------------------------
--
-- MISCELLANEOUS FUNCTIONS
--
-------------------------------------------------------------------------

--? @shortdesc Returns a random item from a table. You can return multiple items (without duplicates) by passing in an optional number parameter.
--? @args Table table[, Integer numberofitems]
--? @result Item/Table
function Table_GetRandomItem(thistable, num)
	
	if scartype(thistable) ~= ST_TABLE then
		fatal("Table_GetRandomItem: Table is invalid")
	end

	local size = table.getn(thistable)
	
	if num == nil or num == 1 then
		
		return thistable[World_GetRand(1, size)]
		
	else
		
		if num > size then
			num = size
		end
		
		local indexes = {}
		local result = {}
		
		for n = 1, size do
			indexes[n] = n
		end
		
		for n = 1, num do
			
			local rand = World_GetRand(1, table.getn(indexes))
			local value = indexes[rand]
			table.remove(indexes, rand)
			
			table.insert(result, thistable[value])
			
		end
		
		return result
		
	end
	
end

--? @shortdesc Checks if a table contains the specified item 
--? @args LuaTable OriginalTable, Item item
--? @result Boolean
function Table_Contains(table_id, item)
	
	if table_id == nil then
		fatal("Table: "..tostring(table_id).." does not exist!")
		return
	end
	
	if table.getn(table_id) == 0 then
		return false
	else
		for i = 1, table.getn(table_id) do
			if table_id[i] == item then
				return true
			end
		end
		return false
	end

end

--? @shortdesc Copies the contents of the original table returns a new table with the contents of that table 
--? @args LuaTable OriginalTable
--? @result LuaTable
function Table_Copy(temp)

	local new_table = {}

	for k,v in pairs(temp) do
		if scartype(temp[k]) == ST_TABLE then
			new_table[k] = Table_Copy(temp[k])
		else
			new_table[k] = temp[k]
		end
	end
	
	return new_table

end


--? @shortdesc Disables any resource income - useful to stop resources accruing during the opening movie
--? @args Void
--? @result Void
function Resources_Disable()

	if _resourcekillers == nil then
		_resourcekillers = {}
	end
	
	if _resourcekillers[1] == nil then
		_resourcekillers[1] = Modify_PlayerResourceRate(player1, RT_Manpower, 0)
		_resourcekillers[2] = Modify_PlayerResourceRate(player1, RT_Munition, 0)
		_resourcekillers[3] = Modify_PlayerResourceRate(player1, RT_Fuel, 0)
	end
	
end


--? @shortdesc Re-enables resource income. 
--? @args Void
--? @result Void
function Resources_Enable()

	if _resourcekillers == nil then
		_resourcekillers = {}
	end
	
	if _resourcekillers[1] ~= nil then
		
		Modifier_Remove(_resourcekillers[1])
		Modifier_Remove(_resourcekillers[2])
		Modifier_Remove(_resourcekillers[3])
		
		_resourcekillers[1] = nil
		_resourcekillers[2] = nil
		_resourcekillers[3] = nil
		
	end
	
end

--? @shortdesc Adds a function and set of arguments to be automatically called during restore from a saved game. Maxiumum of 9 parameters. Callback will be called like this: Callback(arg[1], arg[2], ...)
--?	@args Function callback, [parmeter1, parameter2, ...]
--? @result Void
function Game_SetGameRestoreCallback(...)
	if __defaultGameRestoreSavedCallbacks == nil then
		__defaultGameRestoreSavedCallbacks = {}
	end

	if (arg.n > 10) then
		fatal("Game_SetGameRestoreCallback can take a maxiumum of 10 arguments")
	end

	if (scartype(arg[1]) == ST_FUNCTION) then
		table.insert(__defaultGameRestoreSavedCallbacks, arg)
	else
		fatal("Game_SetGameRestoreCallback must recieve a function to callback")
	end
end
--? @shortdesc Removes a callback from being called on game restore
--?	@args Function callback
--? @result Void
function Game_RemoveGameRestoreCallback(callback)
	if __defaultGameRestoreSavedCallbacks ~= nil and table.getn(__defaultGameRestoreSavedCallbacks) > 0 then
		for k=table.getn(__defaultGameRestoreSavedCallbacks), 1, -1 do
			if __defaultGameRestoreSavedCallbacks[k][1] == callback then
				table.remove(__defaultGameRestoreSavedCallbacks, k)
			end
		end
	end
end

--? @shortdesc Checks whether a callback 
--?	@args Function callback
--? @result Void
function Game_GetGameRestoreCallbackExists(callback)
	if __defaultGameRestoreSavedCallbacks == nil or table.getn(__defaultGameRestoreSavedCallbacks) < 1 then
		return false
	else
		for k,v in pairs(__defaultGameRestoreSavedCallbacks) do
			if v == callback then
				return true
			end
		end
	end
	return false
end

--? @shortdesc Restores various aspects of the single player game after loading a mission from a save game
--?	@args Void
--? @result Void
function Game_DefaultGameRestore()

	-- restore the sound precache file for the mission
	local path = ""
	
	if g_MissionSpeechPath ~= nil then
		path = g_MissionSpeechPath
	end
	
	Sound_PreCacheSinglePlayerSpeech(path)

	-- resume playing the appropriate music track
	Util_RestoreMusic()
	
	-- set the nistransition times
	nis_setintransitiontime(0)
	nis_setouttransitiontime(0)
	
	AI_RestartEncounters()
	
	if (__defaultGameRestoreSavedCallbacks ~= nil) then
		local callbacks = {}		
		for k,v in pairs(__defaultGameRestoreSavedCallbacks) do
			table.insert(callbacks, v)
		end	
		
		for k,v in pairs(callbacks) do
			local numParams = table.getn(v)
			if numParams == 1 then			
				v[1]() 
			elseif numParams == 2 then			
				v[1](v[2]) 
			elseif numParams == 3 then			
				v[1](v[2], v[3]) 
			elseif numParams == 4 then			
				v[1](v[2], v[3], v[4]) 
			elseif numParams == 5 then			
				v[1](v[2], v[3], v[4], v[5]) 
			elseif numParams == 6 then			
				v[1](v[2], v[3], v[4], v[5], v[6]) 
			elseif numParams == 7 then			
				v[1](v[2], v[3], v[4], v[5], v[6], v[7]) 
			elseif numParams == 8 then			
				v[1](v[2], v[3], v[4], v[5], v[6], v[7], v[8]) 
			elseif numParams == 9 then			
				v[1](v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9]) 
			elseif numParams == 10 then			
				v[1](v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9], v[10]) 
			end
		end	
	end
end

-------------------------------------------------------------------------
--
-- BRIDGE MANAGEMENT FUNCTIONS
--
-- This allows you to hook up a bridge so that it cuts supply lines when
-- destroyed. It does this by having its own territory which is managed
-- by the script.
-- 
-- See: http://relicjira.thqinc.com/confluence/display/COHXP/Bridge+Territory+Manager
-- 
-------------------------------------------------------------------------


--? @shortdesc Add a bridge to the Bridge Territory Manager. 
--? @extdesc bridgepoint, bank1point and bank2point should be egroups each containing one territory flag
--? @args EGroupID bridge_egroup, EGroupID bridgepoint, EGroupID bank1point, EGroupID bank2point
--? @result Void
--? @refs http://relicjira.thqinc.com/confluence/display/COHXP/Bridge+Territory+Manager
function BridgeTerritory_Add(egroup, bridgepoint, bank1point, bank2point)

	if _BridgesAll == nil or _BridgesBroken == nil then
		_BridgesAll = {
			BP_GetEntityBlueprint("best_bridge_l_01"),
			BP_GetEntityBlueprint("best_bridge_l_01_wrecked"),
			BP_GetEntityBlueprint("bridge_35_01"),
			BP_GetEntityBlueprint("bridge_35_01_rebuilt"),
			BP_GetEntityBlueprint("bridge_35_01_wrecked"),
			BP_GetEntityBlueprint("bridge_m6_pont_tourant"),
			BP_GetEntityBlueprint("bridge_m6_pont_tourant_rebuilt"),
			BP_GetEntityBlueprint("bridge_m6_pont_tourant_wrecked"),
		}
		_BridgesBroken = {
			BP_GetEntityBlueprint("bridge_35_01_wrecked"),
			BP_GetEntityBlueprint("best_bridge_l_01_wrecked"),
			BP_GetEntityBlueprint("bridge_m6_pont_tourant_wrecked"),
		}
	end
	
	if scartype(bridgepoint) ~= ST_EGROUP then fatal("BridgeTerritory_Add: bridgepoint isn't a valid EGroup") end
	if EGroup_Count(bridgepoint) ~= 1 then fatal("BridgeTerritory_Add: bridgepoint has too many items in the EGroup, or is empty") end
	if Entity_IsStrategicPoint( EGroup_GetSpawnedEntityAt(bridgepoint, 1) ) == false then fatal("BridgeTerritory_Add: bridgepoint EGroup doesn't contain a strategic point") end
	
	if scartype(bank1point) ~= ST_EGROUP then fatal("BridgeTerritory_Add: bank1point isn't a valid EGroup") end
	if EGroup_Count(bank1point) ~= 1 then fatal("BridgeTerritory_Add: bank1point has too many items in the EGroup, or is empty") end
	if Entity_IsStrategicPoint( EGroup_GetSpawnedEntityAt(bank1point, 1) ) == false then fatal("BridgeTerritory_Add: bank1point EGroup doesn't contain a strategic point") end
	
	if scartype(bank2point) ~= ST_EGROUP then fatal("BridgeTerritory_Add: bank2point isn't a valid EGroup") end
	if EGroup_Count(bank2point) ~= 1 then fatal("BridgeTerritory_Add: bank2point has too many items in the EGroup, or is empty") end
	if Entity_IsStrategicPoint( EGroup_GetSpawnedEntityAt(bank2point, 1) ) == false then fatal("BridgeTerritory_Add: bank2point EGroup doesn't contain a strategic point") end
	
	-- find the team of whoever owns the territory under the bridge
	local currentteam = Util_GetPlayerOwner(bridgepoint)
	if currentteam ~= nil then
		currentteam = Player_GetTeam(currentteam)
	end
	
	table.insert(_BridgeTerritoryTable, {bridge = egroup, position = EGroup_GetPosition(egroup), bridgepoint = bridgepoint, currentteam = currentteam, bank1point = bank1point, bank2point = bank2point})
	
	if Rule_Exists(BridgeTerritory_Manager) == false then
		Rule_AddInterval(BridgeTerritory_Manager, 1)
	end

end



function BridgeTerritory_Manager()

	for n = 1, table.getn(_BridgeTerritoryTable) do 
		
		local this = _BridgeTerritoryTable[n]
		
		-- if the bridge has changed (i.e. been destroyed or repaired), rebind it to the egroup
		if EGroup_Count(this.bridge) == 0 then
			World_GetNeutralEntitiesNearPoint(this.bridge, this.position, 20)
			EGroup_Filter(this.bridge, _BridgesAll, FILTER_KEEP)
		end
		
		if EGroup_ContainsBlueprints(this.bridge, _BridgesBroken, ANY) then
			
			-- bridge is out, set the territory to neutral if it isn't already
			if this.currentteam ~= nil then
				Entity_SetStrategicPointNeutral(EGroup_GetSpawnedEntityAt(this.bridgepoint, 1))
				this.currentteam = nil
			end
			
		else
			
			-- find the team of whoever owns the territories on banks 1 and 2
			local bank1team = Util_GetPlayerOwner(this.bank1point)
			local bank2team = Util_GetPlayerOwner(this.bank2point)
			if bank1team ~= nil then
				bank1team = Player_GetTeam(bank1team)
			end
			if bank2team ~= nil then
				bank2team = Player_GetTeam(bank2team)
			end
			
			-- if a team owns both sides, and it's NOT the same team as that which owns the bridge...
			if bank1team == bank2team and bank1team ~= this.currentteam and bank1team ~= nil then
				
				-- set the bridge to link the two sides
				EGroup_InstantCaptureStrategicPoint(this.bridgepoint, Team_GetPlayers(bank1team)[1])
				this.currentteam = bank1team
				
			-- or if the bridge is owned by a team that owns NEITHER of the two sides anymore...
			elseif bank1team ~= this.currentteam and bank2team ~= this.currentteam then
				
				-- set the bridge to neutral
				Entity_SetStrategicPointNeutral(EGroup_GetSpawnedEntityAt(this.bridgepoint, 1))
				this.currentteam = nil
				
			end
			
		end
		
	end

end

-------------------------------------------------------------------------
--
-- TEAM WHEAPON MANAGEMENT FUNCTIONS
--
-- This controls some of the AT guns across the map, making sure they
-- turn to face the enemy as appropriate and generally look a bit more
-- intelligent
-- 
-- See: http://relicjira.thqinc.com/confluence/display/COHXP/AT+Gun+Manager
-- 
-------------------------------------------------------------------------


--? @shortdesc Add a gun to the gun manager. The manager will take care of turning it around to attack units.  Turntime is how often the weapon can turn (default 10 seconds), Total Responses is how many times he will adjust before stopping.
--? @extdesc If you pass in an EGroup, it will automatically find or create a corresponding SGroup with sg_ instead of the eg_ prefix.
--? @args SGroupID/EGroupID group, [, Table facingdirections, Integer currentfacing, Boolean threatarrow, Integer turnTime, Integer totalResponses]
--? @result Void
--? @refs http://relicjira.thqinc.com/confluence/display/COHXP/AT+Gun+Manager
function TeamWeapon_AddGroup(group, directions, currentfacing, threatarrow, turnTime, totalResponses)

	local swid
	
	if threatarrow == nil then
		threatarrow = false
	end
	
	if totalResponses == nil then
		totalResponses = -1
	end
	
	player = Squad_GetPlayerOwner(SGroup_GetSpawnedSquadAt(group, 1))
	
	if scartype(group) == ST_SGROUP then
		swid = SyncWeapon_GetFromSGroup(group)
	elseif scartype(group) == ST_EGROUP then
		swid = SyncWeapon_GetFromEGroup(group)
		local str = "sg_"..string.sub(EGroup_GetName(group), 4)
		group = SGroup_CreateIfNotFound(str)
	else
		fatal("ATGun_AddGroup: Invalid group - it's not an SGroup nor an EGroup")
	end
	
	if turnTime == nil then
		turnTime = 10
	end
	
	table.insert(_TeamWeaponTable, {group = group, 
									player = player, 
									team = Player_GetTeam(player), 
									enemyteam = Team_GetEnemyTeam(Player_GetTeam(player)), 
									swid = swid, 
									directions = directions, 
									currentfacing = currentfacing, 
									lastturn = -10, 
									threatarrow_enable = threatarrow, 
									threatarrow_on = false, 
									threatarrow_id = ThreatArrow_CreateGroup(), 
									turnTime = turnTime, 
									totalResponse = totalResponses,
									lastResponse = 0,})
	
	if Rule_Exists(_TeamWeapon_Manager) == false then
		Rule_AddInterval(_TeamWeapon_Manager, 2)
	end
	
end




--? @shortdesc Remove a gun from the gun manager.
--? @args SGroupID/EGroupID/SyncWeaponID gun 
--? @result Void
--? @refs http://relicjira.thqinc.com/confluence/display/COHXP/AT+Gun+Manager
function TeamWeapon_RemoveGroup(swid)

	if scartype(swid) == ST_SGROUP then
		swid = SyncWeapon_GetFromSGroup(swid)
	elseif scartype(swid) == ST_EGROUP then
		swid = SyncWeapon_GetFromEGroup(swid)
	end
	
	for n = table.getn(_TeamWeaponTable), 1, -1 do 
		
		local this = _TeamWeaponTable[n]
		
		if this.swid == swid then
			
			table.remove(_TeamWeaponTable, n)
			
		end
		
	end

	if table.getn(_TeamWeaponTable) == 0 then
		Rule_Remove(_TeamWeapon_Manager)
	end
	
end


--? @shortdesc Remove's the direction settings for a gun, turning it into a fire-at-anything type. 
--? @extdesc Use this if you are relocating a gun. Also removes any special first-trigger speech if you have any hooked up, as it may no longer be suitable if you're moving it.
--? @args SGroupID/EGroupID/SyncWeaponID gun 
--? @result Void
--? @refs http://relicjira.thqinc.com/confluence/display/COHXP/AT+Gun+Manager
function TeamWeapon_RemoveDirections(swid)

	if scartype(swid) == ST_SGROUP then
		swid = SyncWeapon_GetFromSGroup(swid)
	elseif scartype(swid) == ST_EGROUP then
		swid = SyncWeapon_GetFromEGroup(swid)
	end
	
	for n = table.getn(_TeamWeaponTable), 1, -1 do 
		
		local this = _TeamWeaponTable[n]
		
		if this.swid == swid then
			
			this.directions = nil
			
			-- clear any special speech triggers (as they may no longer be appropriate)
			if scartype(this.threatarrow_enable) == ST_FUNCTION then
				this.threatarrow_enable = true
			end
			
		end
		
	end

	if table.getn(_TeamWeaponTable) == 0 then
		Rule_Remove(_TeamWeapon_Manager)
	end
	
end



-- have the AT guns turn to face incoming units
function _TeamWeapon_Manager()
	
	if table.getn(_TeamWeaponTable) == 0 then Rule_RemoveMe() return end
	
	for n = table.getn(_TeamWeaponTable), 1, -1 do
		
		local this = _TeamWeaponTable[n]
		local current = this.currentfacing
		local group = this.group
		local directions = this.directions
		local lastturn = this.lastturn
		local turnTime = this.turnTime
		
		if SGroup_IsEmpty(group) then table.remove(_TeamWeaponTable, n) return end
		
		if this.totalResponse ~= -1 and this.lastResponse >= this.totalResponse then
			table.remove(_TeamWeaponTable, n)
			return
		end
		
		-- enforce a 10 second grace time between turns
		if World_GetGameTime() >= (lastturn + turnTime) then
			
			if directions ~= nil then
				
				-- we have a set number of directions, so see if we need to turn
				-- *** brw 02/27/2007: this needs to be updated to NOT use player1 as the primary player
				if (current == nil) or Prox_ArePlayersNearMarker(Game_GetLocalPlayer(), directions[current].trigger, ANY) == false then
					
					for i = 1, table.getn(directions) do
						
						if (current ~= i) and Prox_ArePlayersNearMarker(Game_GetLocalPlayer(), directions[i].trigger, ANY) == true then
							
							if this.totalResponse ~= -1 then 
								this.lastResponse = this.lastResponse + 1 
							end
							this.currentfacing = i
							this.lastturn = World_GetGameTime()
							Cmd_Move(group, directions[i].dest, nil, nil, directions[i].trigger)
							break
							
						end
						
					end
					
				end
				
			else
				
				local __isVehicle = function(gid, idx, sid)
					if Entity_IsVehicle(Squad_EntityAt(sid, 0)) then return true end
				end
				
				-- we have no directions, so just turn in place
				if SGroup_IsMoving(group, ANY) == false and SGroup_IsUnderAttack(group, ANY, 7) and SyncWeapon_IsAttacking(this.swid, 7) == false then
					
					SGroup_Clear(sg_temp)
					SGroup_GetLastAttacker(group, sg_temp)
					
					if SGroup_Count(sg_temp) >= 1 and SyncWeapon_CanAttackNow(this.swid, sg_temp) == false then
						
						-- Determine the weapon type
						for i = 1, table.getn(_ATGunSBPs) do
							if Squad_GetBlueprint(SGroup_GetSpawnedSquadAt(group, 1)) == _ATGunSBPs[i] then
								if SGroup_ForEach(sg_temp, __isVehicle) then
									if this.totalResponse ~= -1 then 
										this.lastResponse = this.lastResponse + 1 
									end
									this.lastturn = World_GetGameTime()
									Cmd_Move(group, SyncWeapon_GetPosition(this.swid), nil, nil, SGroup_GetPosition(sg_temp))
								end
							end
						end
						
						for i = 1, table.getn(_HMGGunSBPs) do
							if Squad_GetBlueprint(SGroup_GetSpawnedSquadAt(group, 1)) == _HMGGunSBPs[i] then
								if SGroup_ForEach(sg_temp, __isVehicle) == false then
									if this.totalResponse ~= -1 then 
										this.lastResponse = this.lastResponse + 1 
									end
									this.lastturn = World_GetGameTime()
									Cmd_Move(group, SyncWeapon_GetPosition(this.swid), nil, nil, SGroup_GetPosition(sg_temp))
								end
							end
						end
						
						
					end
					
				end
				
			end
			
		end
		
		
		-- deal with the threat arrows
		if this.threatarrow_enable ~= false then
			
			if this.threatarrow_on == false then
				
				-- see if it's started attacking, and enable the arrow if it has
				if SGroup_IsDoingAttack(group, ANY, 5) == true then
					
					this.threatarrow_on = true
					ThreatArrow_Add(this.threatarrow_id, this.group)
					
					if scartype(this.threatarrow_enable) == ST_FUNCTION then
						Util_StartIntel(this.threatarrow_enable)
						this.threatarrow_enable = true
					end
					
				end
				
			else
				
				-- see if it's stopped attacking
				if SGroup_IsDoingAttack(group, ANY, 25) == false then
					this.threatarrow_on = false
					ThreatArrow_Remove(this.threatarrow_id, this.group)
				end
				
			end
			
		end
		
	end
	
end





-------------------------------------------------------------------------
--
-- Auto Targetting Artillery
--
-- Artillery that homes-in on a target's location. If the target does not 
-- move over a specified number of attempts, attacks get progressively closer
-- to its position.
--
-- It uses a GLOBAL table to keep track of tracking attempts and locations.
-- A seperate table should be used for each instance of the artillery. It's the Designer's
-- responsibility to ensure the targetting data is not destroyed or overwritten.
--
--[[
	targettingParameters:

		t_targettingParameters = {
			prevTarget = , 			--Position - The position where the artillery last fired
			currentCount = 0, 		--Int. - Starting value for number of tries before the artillery zeroes-in on the target.
			maxCount = , 			--Int. - Number of tries it takes for the artillery to zero-in on the target.
			maxTargetDistance = , 	--Int. - Maximum distance when trying to find a safe position to fire.
			minTargetDistance = , 	--Int. - Minimum distance when trying to find a safe position to fire.
			lockOnDistance = , 		--Float - Check radius to determine whether the target has moved or not.
			warningTargetted = nil, --IntelEventFn - Intel event to play when the artillery fires. Optional.
			abilityLocked = , 		--AbilityBP - Ability to use when firing artillery
			warningLocked = nil, 	--IntelEventFn - Intel event to play when the artillery has zeroed-in on the target. Optional.
			abilityTargetted = , 	--AbilityBP - Ability to use when firing on a target that has been zeroed-in on.
			hintTargetted = { 		--Hintpoint data to display when the artillery fires. Optional.
				text = ,
				offset = ,
				actionType = ,
				icon = ,
				timeout = 5, 		--Int. - Lifetime for the hint.
			},
			hintLocked = { 			--Hintpoint data to display when the artillery has locked on a target. Optional.
				text = ,
				offset = ,
				actionType = ,
				icon = ,
				timeout = 5, 		--Int. - Lifetime for the hint.
			},
			eventCue = { 			--EventCue to display whenever the artillery fires. Optional.
				cueStyle = ,
				text = ,
				description = ,
			}
		}

]]--
-- 
-------------------------------------------------------------------------

--? @shortdesc Uses targettingData to determine if a target has moved or not and progressively homes-in on it.
--? @extdesc See DesignerLib.scar for details on targettingData values.
--? @args SGroupID/Player caster, SGroupID target, Table targettingData
--? @result Void
function FireTargettingArtillery(caster, target, targettingData)
	if(target ~= nil and SGroup_CountSpawned(target) > 0) then
		local pos = SGroup_GetPosition(target)
		local targetPos = pos
		local ability = nil
		
		--Check if the player is in the same spot. Update counter accordingly
		if(World_PointPointProx(pos, targettingData.prevTarget, targettingData.lockOnDistance)) then
			targettingData.currentCount = math.min(targettingData.currentCount + 1, targettingData.maxCount)
		else
			targettingData.currentCount = 1
		end
		
		--If locked-on, fire precise. Else, home-in on location
		if(targettingData.currentCount == targettingData.maxCount) then
			--Fire precise
			ability = targettingData.abilityLocked
			--Warning
			if(targettingData.warningLocked) then Event_Timer(EventHandler_StartIntel, {intel_callback = targettingData.warningLocked}, 2.0) end
			--Hint
			if(targettingData.hintLocked) then
				local hpid_artyHint = HintPoint_Add(pos, true, targettingData.hintLocked.text, targettingData.hintLocked.offset, targettingData.hintLocked.actionType, targettingData.hintLocked.icon)
				Event_Timer(RemoveTargettingArtilleryHint, {hintID = hpid_artyHint}, targettingData.hintLocked.timeout)
			end
		else
			--Fire close
			ability = targettingData.abilityTargetted
			--Warning
			if(targettingData.warningTargetted) then Event_Timer(EventHandler_StartIntel, {intel_callback = targettingData.warningTargetted}, 2.0) end
			--Close in (only if > first shot)
			local factor = 1
			if(targettingData.currentCount > 1) then
				factor = 1 - ((targettingData.currentCount-1)/targettingData.maxCount)
			end
			
			targetPos = Util_GetPositionAwayFromPlayer(pos, player1, math.ceil(targettingData.maxTargetDistance * factor), math.ceil(targettingData.minTargetDistance * factor)) or pos
			
			--Hint
			if(targettingData.hintTargetted) then
				local hpid_artyHint = HintPoint_Add(targetPos, true, targettingData.hintTargetted.text, targettingData.hintTargetted.offset, targettingData.hintTargetted.actionType, targettingData.hintTargetted.icon)
				Event_Timer(RemoveTargettingArtilleryHint, {hintID = hpid_artyHint}, targettingData.hintTargetted.timeout)
			end
		end

		--Update targetting data
		targettingData.prevTarget = pos
		
		--Fire the ability
		if(scartype(caster) == ST_PLAYER) then
			Command_PlayerPosAbility(caster, caster, targetPos, ability, true)
		elseif(scartype(caster) == ST_SGROUP) then
			Command_SquadPosAbility(player2, caster, targetPos, ability, true, false)
		end
		
		--Show event
		if(targettingData.eventCue) then
			EventCue_Create(targettingData.eventCue.cueStyle, targettingData.eventCue.text, targettingData.eventCue.description, pos, nil, nil, 6)
		end
		--Minimap blip
		UI_CreateMinimapBlip(targetPos, 9, BT_Combat)
	else
--~ 		print("**FireTargettingArtillery() found no target") --Debug
		targettingData.currentCount = 0
	end
	
	--TargettingData is a table passed in as reference. No need to return it.
end

function RemoveTargettingArtilleryHint(data)
	HintPoint_Remove(data.hintID)
end










-- Temp function for video capturing purposes!
function ResourceCheat()
	Player_SetResource(Game_GetLocalPlayer(), RT_Munition, 225)
	Player_SetResource(Game_GetLocalPlayer(), RT_Manpower, 425)
	Player_SetResource(Game_GetLocalPlayer(), RT_Fuel, 175) 
end

