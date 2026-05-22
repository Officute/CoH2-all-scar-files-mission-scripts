----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
-- Team helper functions
-- (c) 2006 Relic Entertainment Inc.

--------------------------------------------------------------------------------
-- Getting Players on a Team
--------------------------------------------------------------------------------

-- internal function to sort players into team buckets
function __Team_Init()
	
	HUMANS = 999
	ALLIES = nil
	ENEMIES = nil
	
	__TeamPlayerList = {}
	__TeamPlayerList[HUMANS] = {}
	
	for n = 1, World_GetPlayerCount() do 
		
		local playerid = World_GetPlayerAt(n)
		local team = Player_GetTeam(playerid)
		
		if __TeamPlayerList[team] == nil then
			__TeamPlayerList[team] = {}
		end
		
		table.insert(__TeamPlayerList[team], playerid)
		
		if Player_IsHuman(playerid) == true then
			table.insert(__TeamPlayerList[HUMANS], playerid)
		end
		
	end
	
	-- Sort through the teamlist now and assign variables for teh ALLIES and ENEMIES teams
	-- This can change depending on which team slot is chosen in the lobby, so we check player relationships to be certain
	for i = 0, table.getn(__TeamPlayerList) do
		for n = 1, table.getn(__TeamPlayerList[i]) do
			if Player_GetRelationship(__TeamPlayerList[i][n], __TeamPlayerList[HUMANS][1]) == R_ALLY then
				ALLIES = i
			elseif Player_GetRelationship(__TeamPlayerList[i][n], __TeamPlayerList[HUMANS][1]) == R_ENEMY then
				ENEMIES = i
			end
		end
	end
	
	-- Now set the variables
	TEAM_HUMANS = __TeamPlayerList[HUMANS]
	TEAM_ALLIES = __TeamPlayerList[ALLIES]
	TEAM_ENEMIES = __TeamPlayerList[ENEMIES]
	
end

--~ Scar_AddInit(__Team_Init)

----------------------------------------------------------------------------------------------------------------
-- Private Implementation

-----------------------------------------------------------------------------
-- External functions
-----------------------------------------------------------------------------

--? @group scardoc;Team

--? @shortdesc Returns 4 playerIDs (player1, player2, player3, player4) for Humans/Allies
--? @arts void
--? @result playerID, playerID, playerID, playerID
function Team_DefineAllies()
	
	local player1 = nil
	local player2 = nil
	local player3 = nil
	local player4 = nil
	
	local count = table.getn(TEAM_ALLIES)
	
	if count == 1 then
		player1 = TEAM_ALLIES[1]
	elseif count == 2 then 
		player1 = TEAM_ALLIES[1]
		player2 = TEAM_ALLIES[2]
	elseif count == 3 then
		player1 = TEAM_ALLIES[1]
		player2 = TEAM_ALLIES[2]
		player3 = TEAM_ALLIES[3]
	elseif count == 4 then
		player1 = TEAM_ALLIES[1]
		player2 = TEAM_ALLIES[2]
		player3 = TEAM_ALLIES[3]
		player4 = TEAM_ALLIES[4]
	elseif count > 4 then
		fatal("ERROR: Too many players in TEAM_ALLIES, must be 4 or fewer")
	end
	
	return player1, player2, player3, player4

end

--? @shortdesc Returns 4 playerIDs (player5, player6, player7, player8) for Enemy Players
--? @arts void
--? @result playerID, playerID, playerID, playerID
function Team_DefineEnemies()
	
	local player5 = nil
	local player6 = nil
	local player7 = nil
	local player8 = nil
	
	local count = table.getn(TEAM_ENEMIES)
	
	if count == 1 then
		player5 = TEAM_ENEMIES[1]
	elseif count == 2 then 
		player5 = TEAM_ENEMIES[1]
		player6 = TEAM_ENEMIES[2]
	elseif count == 3 then
		player5 = TEAM_ENEMIES[1]
		player6 = TEAM_ENEMIES[2]
		player7 = TEAM_ENEMIES[3]
	elseif count == 4 then
		player5 = TEAM_ENEMIES[1]
		player6 = TEAM_ENEMIES[2]
		player7 = TEAM_ENEMIES[3]
		player8 = TEAM_ENEMIES[4]
	elseif count > 4 then
		fatal("ERROR: Too many players in TEAM_ENEMIES, must be 4 or fewer")
	end
	
	return player5, player6, player7, player8

end

-----------------------------------------------------------------------------
-- TOW Utility Functions
-----------------------------------------------------------------------------

--? @shortdesc Sets up the tech tree for a whole team based off the year
--? @args TeamID team, Integer year
--? @result void
function Team_SetTechTreeByYear(teamid, year)
	for i = 1, table.getn(teamid) do
		ToW_SetUpTechTreeByYear(teamid[i], year)
	end
end

-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------



--? @shortdesc Returns whether a team is still alive or not (all member players must be 'alive')
--? @arts TeamID team
--? @result Boolean
function Team_IsAlive(teamid)
	for i = 1, table.getn(teamid) do
		if Player_IsAlive(teamid[i]) then
			return true
		end
	end
	return false
end


--? @shortdesc Returns true if this team owns any buildings listed in the table.
--? @extdesc This only looks at completed buildings - use Team_HasBuildingUnderConstruction to see if the team is building something
--? @extdesc Use ALL to check if all players on the team have this building
--? @args TeamID team, BlueprintTable entitytypes[, ANY bool]
--? @result boolean
function Team_HasBuilding(team, ebplist, any)
	if any == nil then any = ANY end
	
	_checkHasBuilding = function(teamid, idx, playerid)
		return Player_HasBuilding(playerid, ebplist)
	end
	
	return Team_ForEachAllOrAny(team, any, _checkHasBuilding)
	
end

--? @shortdesc Returns true if this team has any players that are human.
--? @args TeamID team[, ANY bool]
--? @result boolean
function Team_HasHuman(team, any)
	if any == nil then any = ANY end
	
	_checkHasHuman = function(teamid, idx, playerid)
		return Player_IsHuman(playerid)
	end
	
	return Team_ForEachAllOrAny(Team_GetPlayers(team), any, _checkHasHuman)
	
end

--? @shortdesc Returns true if this team owns any buildings. (with exclusions).
--? @extdesc Use ALL to check if all players on the team have buildings EXCEPT this one
--? @args TeamID team, BlueprintTable exceptions[, ANY bool]
--? @result boolean
function Team_HasBuildingsExcept( team, exceptions, any )
	if any == nil then any = ANY end
	
	_checkHasBuildingExcept = function(teamid, idx, playerid)
		return Player_HasBuildingsExcept(playerid, exceptions)
	end
	
	return Team_ForEachAllOrAny(team, any, _checkHasBuildingExcept)
	
end

--? @shortdesc Returns true if this team owns any buildings listed in the table currently under construction.
--? @extdesc Use ALL to check if all players on the team have this building under construction
--? @args TeamID team, BlueprintTable entitytypes[, ANY bool]
--? @result boolean
function Team_HasBuildingUnderConstruction(player, ebplist, any)
	if any == nil then any = ANY end
	
	_checkHasBuildingExcept = function(teamid, idx, playerid)
		return Player_HasBuildingUnderConstruction(playerid, ebplist)
	end
	
	return Team_ForEachAllOrAny(team, any, _checkHasBuildingExcept)
end

--? @shortdesc Returns the entityID of the first team owned building listed in the table.
--? @extdesc Use ALL to return a table containing the first building listed for each player on the team
--? @extdesc This only looks at completed buildings
--? @args PlayerID player, BlueprintTable entitytypes[, ANY bool]
--? @result EntityID/Table
function Team_GetBuildingID(team, ebplist, any )
	for i = 1, table.getn(team) do 
		local t = {}
		if any == ANY then
			return Player_GetBuildingID(team[i], ebplist)
		else
			local eid = Player_GetBuildingID(team[i], ebplist)
			table.insert(t, eid)
		end
		return t
	end
end

--? @shortdesc Returns the total number of buildings owned by this team.
--? @args TeamID team
--? @result Integer
function Team_GetBuildingsCount( team )
	local count = 0
	for i = 1, table.getn(team) do
		count = count+Player_GetBuildingsCount(team[i])
	end
	return count
end

--? @shortdesc Returns the total number of buildings owned by this team (with exclusions).
--? @args TeamID team, BlueprintTable exceptions
--? @result Integer
function Team_GetBuildingsCountExcept( player, exceptions )
	local count = 0
	for i = 1, table.getn(team) do
		count = count+Player_GetBuildingsCountExcept(team[i], exceptions)
	end
	return count
end

--? @shortdesc Returns the number of buildings owned by this team (inclusive).
--? @args TeamID team, BlueprintTable ebplist
--? @result Integer
function Team_GetBuildingsCountOnly( player, ebplist )
	local count = 0
	for i = 1, table.getn(team) do
		Player_GetBuildingsCountOnly( player, ebplist )
	end
	return count
end

--? @shortdesc Add resource to each member of a team, as opposed to just setting it. Possible resource types are RT_Manpower, RT_Munition, RT_Fuel, RT_Action 
--? @args TeamID team, Integer resourceType, Real value
--? @result Void
function Team_AddResource(team, resource, value)
	for i = 1, table.getn(team) do
		local i = Player_GetResource(team[i], resource)
		local resourceAmount = i + value
		Player_SetResource(team[i], resource, resourceAmount)
	end
end

--? @shortdesc For the given team, get all of the squads gathered into a squadgroup of your naming.  
--? @extdesc Squads will be added to given squad group.  If the given squad group does not exist it will be created.
--? @extdesc This will add all squads for the entire team to one group.  To do so for each player, iterate the team table
--? @args TeamID team, String squadgroupName
--? @result SGroupID
function Team_AddSquadsToSGroup(playerId, squadgroupName)	
	SGroup_CreateIfNotFound(squadgroupName)
	for i = 1, table.getn(team) do
		Player_AddSquadsToSGroup(team[i], squadgroupName)
	end
	return SGroup_FromName(squadgroupName)
end

--? @shortdesc Creates/Clears groups that contain all of a team's units and buildings. Defaults - sg_allsquads and eg_allentities
--? @extdesc Fills an SGroup with all of the given team's squads, and an EGroup with all the team's entities.
--? If you don't provide and groups, then it defaults to using sg_allsquads and eg_allentities.
--? @args TeamID team[, SGroupID sgroup, EGroupID egroup]
--? @result Void
function Team_GetAll(...)
	-- all of the arguments are passed in through a table called "arg" rather than named
	local teamID = arg[1]
	
	sg_allsquads = SGroup_CreateIfNotFound("sg_allsquads")
	SGroup_Clear(sg_allsquads)
	
	eg_allentities = EGroup_CreateIfNotFound("eg_allentities")
	EGroup_Clear(eg_allentities)
	
	if scartype(arg[2]) == ST_SGROUP then SGroup_Clear(arg[2]) end
	if scartype(arg[3]) == ST_EGROUP then EGroup_Clear(arg[3]) end
	
	for i = 1, table.getn(teamID) do 
		if (table.getn(arg) == 1) then
			
			-- put results into the default groups
			SGroup_AddGroup(sg_allsquads, Player_GetSquads(teamID[i]))
			
			EGroup_AddEGroup(eg_allentities, Player_GetEntities(teamID[i]))
			
		elseif (table.getn(arg) == 2) then
		
			if ( scartype( arg[2] ) == ST_SGROUP ) then
			
				SGroup_AddGroup(arg[2], Player_GetSquads(teamID[i]))
				
			elseif ( scartype( arg[2] ) == ST_EGROUP ) then
			
				EGroup_AddEGroup(arg[2], Player_GetEntities(teamID[i]))
				
			else
			
				fatal( "Player_GetAll() has 2 parameters but the second parameter is neither sgroup nor egroup" )

			end
		
		
		elseif (table.getn(arg) == 3) then
			
			if ( scartype( arg[2] ) ~= ST_SGROUP or scartype( arg[3] ) ~= ST_EGROUP ) then
				fatal( "Player_GetAll() has 3 parameters but did not have sgroup and egroup parameters in order" )
			end
			
			-- if there were some group names specified, use those instead
			
			SGroup_AddGroup(arg[2], Player_GetSquads(teamID[i]))
			
			EGroup_AddEGroup(arg[3], Player_GetEntities(teamID[i]))
			
		end
	end
	
end

--? @shortdesc Returns an EGroup containing all of the teams entities of a specific unit_type (as defined by the type_ext on the entity)
--? @extdesc This function returns a new EGroup to allow tracking of different types. 
--? @args TeamID team, String unitType
--? @result EGroup

function Team_GetEntitiesFromType(team, unitType)
	local entitiesFromType = EGroup_Create("")
	
	for i = 1, table.getn(team) do
		local allTheEntities = Player_GetEntities(team[i])
		
		for i=1, EGroup_CountSpawned(allTheEntities) do
			local entity = EGroup_GetSpawnedEntityAt(allTheEntities, i)
			if (Entity_IsOfType(entity, unitType)) then
				EGroup_Add(entitiesFromType, entity)
			end
		end
	end
	
	return entitiesFromType
end

--? @shortdesc Gather together all of a teams's squads that are in proximity to a marker, a position, or within a territory sector into an SGroup. The SGroup is cleared beforehand. 
--? @extdesc You can override a marker's normal proximity by specifying a range.
--? @args TeamID team, SGroupID sgroup, MarkerID/Pos/SectorID position[, Real range]
--? @result Void
function Team_GetAllSquadsNearMarker(team, sgroupid, pos, range)
	
	__tempSG_near = SGroup_Create("__tempSG_near")
	SGroup_Clear(__tempSG_near)
	SGroup_Clear(sgroupid)
	
	for i = 1, table.getn(team) do
		Player_GetAllSquadsNearMarker(team[i], __tempSG_near, pos, range)
		SGroup_AddGroup(sgroupid, __tempSG_near)
	end
	
	SGroup_Destroy(__tempSG_near)
	
end


--? @shortdesc Gather together all of a teams's entities that are in proximity to a marker, a position, or within a territory sector into an EGroup. The EGroup is cleared beforehand. 
--? @extdesc You can override a marker's normal proximity by specifying a range.
--? @args TeamID team, EGroupID egroup, MarkerID/Pos/SectorID position[, Real range]
--? @result Void
function Team_GetAllEntitiesNearMarker(team, egroupid, pos, range)
	
	__tempEG_near = EGroup_Create("__tempEG_near")
	EGroup_Clear(__tempEG_near)
	EGroup_Clear(egroupid)
	
	for i = 1, table.getn(team) do
		Player_GetAllEntitiesNearMarker(team[i], __tempEG_near, pos, range)
		EGroup_AddEGroup(egroupid, __tempEG_near)
	end
	
	EGroup_Destroy(__tempEG_near)
	
end

--? @shortdesc Returns true if a team can see ALL or ANY items
--? @args TeamID teamid, EGroupID/SGroupID/EntityID/SquadId/PositionID/MarkerID item, Boolean all
--? @result Boolean
function Team_CanSee(teamid, itemToSee, all)

	local __checkToSee = function(tid, pix, pid)
		if scartype(itemToSee) == ST_EGROUP then
			if Player_CanSeeEGroup(pid, itemToSee, all) then
				return true
			end
		elseif scartype(itemToSee) == ST_ENTITY then
			if Player_CanSeeEntity(pid, itemToSee) then
				return true
			end
		elseif scartype(itemToSee) == ST_SGROUP then
			if Player_CanSeeSGroup(pid, itemToSee, all) then
				return true
			end
		elseif scartype(itemToSee) == ST_SQUAD then
			if Player_CanSeeSquad(pid, itemToSee, all) then
				return true
			end
		elseif scartype(itemToSee) == ST_SCARPOS then
			if Player_CanSeePosition(pid, itemToSee) then
				return true
			end
		elseif scartype(itemToSee) == ST_MARKER then
			if Player_CanSeePosition(pid, Util_GetPosition(itemToSee)) then
				return true
			end
		end		
	end
	
	return Team_ForEachAllOrAny(teamid, ANY, __checkToSee)

end

--? @shortdesc Sets the current personnel or vehicle cap for each player on a team. The captype is either CT_Personnel or CT_Vehicle (you can't adjust Medic caps just yet).
--? @extdesc Note that any modifiers that adjust the current cap will be applied on top of this.  Also note, the current cap cannot go higher than the max cap.
--? @args TeamID team, Integer captype, Integer newcap
--? @result Void
function Team_SetMaxPopulation(team, captype, value)
	
	for i = 1, table.getn(team) do
		Player_SetMaxPopulation(team[i], captype, value)
	end
	
end

--? @shortdesc Sets the current personnel or vehicle max-cap for each player on a team. The captype is either CT_Personnel or CT_Vehicle (you can't adjust Medic caps just yet).
--? @extdesc Note that any modifiers that adjust the current max cap will be applied on top of this.  Also note, this is only adjusting the max cap, not the current cap,
--? @extdesc you will have to call Team_SetMaxPopulation to adjust the current max population to do this.
--? @args TeamID team, Integer captype, Integer newcap
--? @result Void
function Team_SetMaxCapPopulation(team, captype, value)
	
	for i = 1, table.getn(team) do
		Player_SetMaxCapPopulation(team[i], captype, value)
	end
	
end

--? @shortdesc Restrict a list of addons.
--? @extdesc list should contain an array of strings to restrict.
--? @result Void
--? @args TeamID team, Table addonlist
function Team_RestrictAddOnList( team, list )
	for i = 1, table.getn(team) do
		Player_RestrictAddOnList(team[i], list)
	end
end

--? @shortdesc Restrict a list of buildings.
--? @extdesc list should contain an array of strings to restrict.
--? @result Void
--? @args TeamID team, Table blueprintlist
function Team_RestrictBuildingList( team, list )
	for i = 1, table.getn(team) do
		Player_RestrictBuildingList(team[i], list)
	end
end


--? @shortdesc Restrict a list of research items.
--? @extdesc list should contain an array of strings to restrict.
--? @result Void
--? @args TeamID team, StringTable list
function Team_RestrictResearchList( team, list )
	for i = 1, table.getn(team) do
		Player_RestrictResearchList(team[i], list)
	end
end

--? @shortdesc Returns true if a given team owns ALL or ANY items in a group
--? @args TeamID team, EGroupID egroup[, Boolean any]
--? @result Boolean
function Team_OwnsEGroup( team, egroupID, any )
	
	if any == nil then any = ANY end
	
	_ownsEGroup = function(teamid, idx, playerid)
		return Player_OwnsEGroup(playerid, egroupID, any)
	end
	
	return Team_ForEachAllOrAny(team, any, _ownsEGroup)
	
end


--? @shortdesc Returns true if a given team owns an entity
--? @args TeamID team, EntityID entity
--? @result Boolean
function Team_OwnsEntity( team, entityID )
	any = ANY
	
	_ownsEntity = function(teamid, idx, playerid)
		return Player_OwnsEntity(playerid, entityID)
	end
	
	return Team_ForEachAllOrAny(team, any, _ownsEntity)
	
end


--? @shortdesc Returns true if a given team owns ALL or ANY items in a group
--? @args TeamID team, SGroupID sgroup[, Boolean all]
--? @result Boolean
function Team_OwnsSGroup( team, sgroupID, all )

	if any == nil then any = ANY end
	
	_ownsSGroup = function(teamid, idx, playerid)
		return Player_OwnsSGroup(playerid, sgroupID, any)
	end
	
	return Team_ForEachAllOrAny(team, any, _ownsSGroup)

end


--? @shortdesc Returns true if a given team owns a squad
--? @args TeamID team, SquadID squad
--? @result Boolean
function Team_OwnsSquad( team, squadID )

	any = ANY
	
	_ownsSquad = function(teamid, idx, playerid)
		return Player_OwnsSquad(playerid, squadID)
	end
	
	return Team_ForEach(team, any, _ownsSquad)
	
end

--? @shortdesc Returns true if ANY of a teams squads are in proximity of a marker
--? @args TeamID team, MarkerID marker
--? @result Boolean
function Team_AreSquadsNearMarker( team, markerID )
	
	for i = 1, table.getn(team) do		
		if Player_AreSquadsNearMarker(team[i], markerID) then return true end
	end
	
end

--? @shortdesc Any of the team's units in the marker area move out of the area, and can be made invulnerable for a bit whilst they do it
--? @extdesc You can replace the marker with a position and a range - i.e. Team_ClearArea(team, pos, range, invulnerable)
--? @result Void
--? @args TeamID team, MarkerID marker, Bool invulnerable
function Team_ClearArea(...)
	
	local team = arg[1]
	for i = 1, table.getn(team) do 
		local pos = nil
		local range = nil
		local invulnerabe = nil
		if (table.getn(arg) == 3) then
			pos = Marker_GetPosition(arg[2])
			range = Marker_GetProximityRadius(arg[2])
			invulnerable = arg[3]
		elseif (table.getn(arg) == 4) then
			pos = arg[2]
			range = arg[3]
			invulnerable = arg[4]
		end
		
		internal_playercleararea = SGroup_CreateIfNotFound("internal_playercleararea")
		Player_GetAllSquadsNearMarker(team[i], internal_playercleararea, pos, range)
		
		Cmd_MoveAwayFromPos(internal_playercleararea, pos, range)
		if (invulnerable == true) then
			SGroup_SetInvulnerable(internal_playercleararea, true, 5)
		end
		
		SGroup_Destroy(internal_playercleararea)
	end
	
end

--? @shortdesc Sets the cost of an upgrade.
--? @args TeamID team, UpgradeID upgrade, Real manpower, Real fuel, Real munition, Real action, Real command
--? @result Void
function Team_SetUpgradeCost(team, upgrade, manpower, fuel, munition, action, command)
	
	for i = 1, table.getn(team) do
		Player_SetUpgradeCost(team[i], upgrade, manpower, fuel, munition, action, command)
	end
	
end

--? @shortdesc Sets the availability of an upgrade. Availability can be either ITEM_LOCKED, ITEM_UNLOCKED, ITEM_REMOVED or ITEM_DEFAULT
--? @args TeamID team, UpgradeBlueprint/Table bp, Integer availability
function Team_SetUpgradeAvailability( team, bp, availability, reason )
	for i = 1, table.getn(team) do
		Player_SetUpgradeAvailability( team[i], bp, availability, reason )
	end
end

--? @shortdesc Sets the availability of an ability. Availability can be either ITEM_LOCKED, ITEM_UNLOCKED, ITEM_REMOVED or ITEM_DEFAULT
--? @args TeamID team, AbilityBlueprint/Table bp, Integer availability
function Team_SetAbilityAvailability( team, bp, availability, reason )
	for i = 1, table.getn(team) do
		Player_SetAbilityAvailability( team[i], bp, availability, reason )
	end
end

--? @shortdesc Sets the availability of a squad production item. Availability can be either ITEM_LOCKED, ITEM_UNLOCKED, ITEM_REMOVED or ITEM_DEFAULT
--? @args TeamID team, SquadBlueprint/Table bp, Integer availability
function Team_SetSquadProductionAvailability( team, bp, availability, reason )
	for i = 1, table.getn(team) do
		Player_SetSquadProductionAvailability( team[i], bp, availability, reason )
	end
end

--? @shortdesc Sets the availability of an entity production item. Availability can be either ITEM_LOCKED, ITEM_UNLOCKED, ITEM_REMOVED or ITEM_DEFAULT
--? @args TeamID team, EntityBlueprint/Table bp, Integer availability
function Team_SetEntityProductionAvailability( team, bp, availability, reason )
	for i = 1, table.getn(team) do
		Player_SetEntityProductionAvailability( team[i], bp, availability, reason )
	end
end

--? @shortdesc Sets the availability of entity, squad and player commands. Availability can be either ITEM_LOCKED, ITEM_UNLOCKED, ITEM_REMOVED or ITEM_DEFAULT
--? @args TeamID team, Integer/Table command, Integer availability
function Team_SetCommandAvailability( team, command, availability, reason )
	for i = 1, table.getn(team) do
		Player_SetCommandAvailability( team[i], command, availability, reason )
	end
end

--? @shortdesc Sets the availability of a construction menu. Availability can be either ITEM_LOCKED, ITEM_UNLOCKED, ITEM_REMOVED or ITEM_DEFAULT
--? @args TeamID team, String/Table menuname, Integer availability
function Team_SetConstructionMenuAvailability( team, menu, availability, reason )
	for i = 1, table.getn(team) do
		Player_SetConstructionMenuAvailability( team[i], menu, availability, reason )
	end
end
























--~ --? @shortdesc Calls your function on each player on a team. Parameters of your function are: (TeamID, player index, PlayerID). You can return true to stop the loop
--~ --? @args TeamID team, LuaFunction function
--~ function Team_ForEach( team, func )

--~ 	local teamplayers = Team_GetPlayers(team)
--~ 	
--~ 	for i = 1, table.getn(teamplayers) do
--~ 		
--~ 		local player = teamplayers[i]
--~ 		if func(team, i, player) == true then
--~ 			return
--~ 		end
--~ 		
--~ 	end
--~ 	
--~ end

--? @shortdesc Tests a condition on teams. Calls your function for each player. Parameters of your function: (TeamID, player index, PlayerID). Your function must return true or false to indicate whether the player meets the condition.
--? @args TeamID team, Boolean all, LuaFunction function
--? @result Boolean
function Team_ForEachAllOrAny( team, all, func )
	
	for i = 1, table.getn(team) do
		
		local player = team[i]
		local result = func(team, i, player)
		
		if all and result ~= true then return false end
		if not all and result == true then return true end
		
	end
	
	return all
end

-----------------------------------------------------------------
-- LEGACY
-----------------------------------------------------------------

function Team_GetPlayers( team )

	local teamplayers = {}
	
	for i = 1, World_GetPlayerCount() do
		
		local player = World_GetPlayerAt(i)
		local pteam = Player_GetTeam(player)
		
		if pteam == team then
			table.insert(teamplayers, player)
		end
		
	end
	
	return teamplayers

end

function Team_ForEachAllOrAny_LEGACY( team, all, func )

	local teamplayers = Team_GetPlayers(team)
	
	for i = 1, table.getn(teamplayers) do
		
		local player = teamplayers[i]
		local result = func(team, i, player)
		
		if all and result ~= true then return false end
		if not all and result == true then return true end
		
	end
	
	return all
end

--~ --? @shortdesc Calls an existing Player_ function on every player on a team
--~ --? @extdesc Example: Team_CallPlayerFunction( allies_team, Player_AddResource, RT_Fuel, 50 )
--~ --? @extdesc will call Player_AddResource(player, RT_Fuel, 50) for every player on allies_team.
--~ --? @extdesc The first parameter of the supplied function must be PlayerID
--~ --? @args TeamID team, Function playerFunction, variable argument list
--~ function Team_CallPlayerFunction( team, func, ... )

--~ 	local teamplayers = Team_GetPlayers(team)
--~ 	
--~ 	local argsize = table.getn(arg)
--~ 	for i = 1, table.getn(teamplayers) do
--~ 		
--~ 		local player = teamplayers[i]
--~ 		
--~ 		-- pass along arguments. we have to pass in correct # of arguments for calling C++ functions
--~ 		if argsize == 0 then
--~ 			func(player)
--~ 		elseif argsize == 1 then
--~ 			func(player, arg[1])
--~ 		elseif argsize == 2 then
--~ 			func(player, arg[1], arg[2])
--~ 		elseif argsize == 3 then
--~ 			func(player, arg[1], arg[2], arg[3])
--~ 		elseif argsize == 4 then
--~ 			func(player, arg[1], arg[2], arg[3], arg[4])
--~ 		elseif argsize == 5 then
--~ 			func(player, arg[1], arg[2], arg[3], arg[4], arg[5])
--~ 		elseif argsize == 6 then
--~ 			func(player, arg[1], arg[2], arg[3], arg[4], arg[5], arg[6])
--~ 		elseif argsize == 7 then
--~ 			func(player, arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7])
--~ 		elseif argsize == 8 then
--~ 			func(player, arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8])
--~ 		elseif argsize == 9 then
--~ 			func(player, arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9])
--~ 		else
--~ 			fatal("Team_CallPlayerFunction: too many arguments! (" .. argsize .. ")")
--~ 		end
--~ 		
--~ 	end

--~ end


--~ --? @shortdesc Calls a UI related function for the local player if he is on the team. NOTE: this is non-deterministic, so only use this for UI functions, otherwise your game may go out of sync (don't use this to spawn squads or anything affecting the simulation)
--~ --? @extdesc Example: Team_CallUIFunction(allies_team, EventCue_Create, CUE.ATTACKED, 123, 456, point )
--~ --? @extdesc will call EventCue_Create(CUE.ATTACKED, 123, 456, point) for the local player if he's on the allies team. In other words, every player on the team will see the event cue, but the enemies will not.
--~ --? @args TeamID team, Function UI_Function, variable argument list
--~ function Team_CallUIFunction( team, func, ... )

--~ 	local teamplayers = Team_GetPlayers(team)
--~ 	
--~ 	local argsize = table.getn(arg)
--~ 	for i = 1, table.getn(teamplayers) do
--~ 		
--~ 		local player = teamplayers[i]
--~ 		if player == Game_GetLocalPlayer() then	
--~ 			-- pass along arguments. we have to pass in correct # of arguments for calling C++ functions
--~ 			if argsize == 0 then
--~ 				func(player)
--~ 			elseif argsize == 1 then
--~ 				func( arg[1])
--~ 			elseif argsize == 2 then
--~ 				func( arg[1], arg[2])
--~ 			elseif argsize == 3 then
--~ 				func( arg[1], arg[2], arg[3])
--~ 			elseif argsize == 4 then
--~ 				func( arg[1], arg[2], arg[3], arg[4])
--~ 			elseif argsize == 5 then
--~ 				func( arg[1], arg[2], arg[3], arg[4], arg[5])
--~ 			elseif argsize == 6 then
--~ 				func( arg[1], arg[2], arg[3], arg[4], arg[5], arg[6])
--~ 			elseif argsize == 7 then
--~ 				func( arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7])
--~ 			elseif argsize == 8 then
--~ 				func( arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8])
--~ 			elseif argsize == 9 then
--~ 				func( arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9])
--~ 			else
--~ 				fatal("Team_CallPlayerFunction: too many arguments! (" .. argsize .. ")")
--~ 			end
--~ 		end	
--~ 	end
--~ 	
--~ end

--~ --? @shortdesc Calls an existing Player_ function on every player on a team
--~ --? @shortdesc Returns whether ALL or ANY players on a team satisfy a condition, using a Player_ function to perform the query on each player
--~ --? @extdesc Example: Team_CallPlayerFunctionAllOrAny( allies_team, ANY, Player_HasUpgrade, UPG.ALLIES.HALFTRACK_QUAD )
--~ --? @extdesc will call Player_HasUpgrade( player, UPG.ALLIES.HALFTRACK_QUAD ) to determine whether ANY player in allies_team has that upgrade
--~ --? @extdesc restriction: the first parameter of the supplied function must be PlayerID
--~ --? @args TeamID team, Boolean all, Function playerFunction, variable argument list
--~ function Team_CallPlayerFunctionAllOrAny( team, all, func, ... )

--~ 	local teamplayers = Team_GetPlayers(team)
--~ 	
--~ 	local argsize = table.getn(arg)
--~ 	for i = 1, table.getn(teamplayers) do
--~ 		
--~ 		local player = teamplayers[i]
--~ 		local result
--~ 		
--~ 		-- pass along arguments. we have to pass in correct # of arguments for calling C++ functions
--~ 		if argsize == 0 then
--~ 			result = func(player)
--~ 		elseif argsize == 1 then
--~ 			result = func(player, arg[1])
--~ 		elseif argsize == 2 then
--~ 			result = func(player, arg[1], arg[2])
--~ 		elseif argsize == 3 then
--~ 			result = func(player, arg[1], arg[2], arg[3])
--~ 		elseif argsize == 4 then
--~ 			result = func(player, arg[1], arg[2], arg[3], arg[4])
--~ 		elseif argsize == 5 then
--~ 			result = func(player, arg[1], arg[2], arg[3], arg[4], arg[5])
--~ 		elseif argsize == 6 then
--~ 			result = func(player, arg[1], arg[2], arg[3], arg[4], arg[5], arg[6])
--~ 		elseif argsize == 7 then
--~ 			result = func(player, arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7])
--~ 		elseif argsize == 8 then
--~ 			result = func(player, arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8])
--~ 		elseif argsize == 9 then
--~ 			result = func(player, arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9])
--~ 		else
--~ 			fatal("Team_CallPlayerFunctionAllOrAny: too many arguments! (" .. argsize .. ")")
--~ 		end
--~ 		
--~ 		if all and result ~= true then return false end
--~ 		if not all and result == true then return true end
--~ 		
--~ 	end
--~ 	
--~ 	return all

--~ end

--? @shortdesc Returns the TeamID for a given race. See ScarUtil.scar for constants to use.
--? @extdesc You can pass in multiple races.
--? @args String race[, String race2, ...]
--? @result TeamID
function Team_FindByRace( ... )
	
	for i = 1, World_GetPlayerCount() do
		
		local player = World_GetPlayerAt(i)
		local player_race = Player_GetRaceName(player)
		
		for j = 1, table.getn(arg) do
			local race = arg[j]
			if type(race) ~= "string" then
				fatal("Team_FindByRace: race must be a string!")
			end
			
			if player_race == race then
				return Player_GetTeam(player)
			end
		end
		
	end
	
end

--? @shortdesc Returns a team's enemy
--? @args TeamID team
--? @result TeamID
function Team_GetEnemyTeam( team )

	for i = 1, World_GetPlayerCount() do
		
		local player = World_GetPlayerAt(i)
		local player_team = Player_GetTeam(player)
		
		if player_team ~= team then
			return player_team
		end
		
	end

end

--~ --? @shortdesc Returns whether a player is on that team
--~ --? @args PlayerID player, TeamID team
--~ --? @result Boolean
--~ function Team_IsPlayerOnTeam( player, team )
--~ 	
--~ 	local players = Team_GetPlayers(team)
--~ 	
--~ 	for i = 1, table.getn(players) do
--~ 		if players[i] == player then
--~ 			return true
--~ 		end
--~ 	end
--~ 	
--~ 	return false
--~ 	
--~ end


