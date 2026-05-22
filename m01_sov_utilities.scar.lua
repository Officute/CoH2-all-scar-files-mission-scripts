-- Creates a local Localized string, this is good FOR "here and now" situations
function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

-- Checks IF the game runs in a COOP mode
function Util_IsCoop()
	if (AI_IsAIPlayer(player2) == false) then
		return true;
	else
		return false;
	end
end

-- Creates a temporary SGroup from a squadID
function SGroup_FromSquad(squad)
	local sg_temp = SGroup_CreateIfNotFound("sg_temp_from_squad");
	SGroup_Clear(sg_temp);
	SGroup_Add(sg_temp, squad);
	return sg_temp;
end

-- Creates a temporary EGroup from an EntityID
function EGroup_FromEntity(e)
	local eg_temp = EGroup_CreateIfNotFound("eg_temp_from_entity");
	EGroup_Clear(eg_temp);
	EGroup_Add(eg_temp, e);
	return eg_temp;
end

-- Disables all visible signs of this unit
function SGroup_DisableUI(sgroup, enable, hide)

	if (hide == nil) then
		hide = false;
	end

	if (enable == nil) then
		enable = false;
	end
	
	SGroup_EnableAttention(sgroup, enable);
	SGroup_EnableMinimapIndicator(sgroup, enable);
	SGroup_EnableSurprise(sgroup, enable);
	SGroup_EnableUIDecorator(sgroup, enable); 
	SGroup_SetSelectable(sgroup, enable);
	SGroup_Hide(sgroup, hide); 
	
end

-- Disables or enables weapons of said unit (Cannot be reversed)
function SGroup_SetWeaponState(sgroup, state)
	SGroup_SetAutoTargetting(sgroup, "hardpoint_01", false);
	if (state == false) then
		Cmd_Ability(sgroup, ABILITY.GLOBAL.SP_DROP_WEAPONS, nil, nil, true, true);
	end
end

-- Returns a temporary SGroup
function SGroup_Temp()
	return SGroup_CreateIfNotFound("sg_temp");
end

-- Returns a random object from a table
function Util_GetRandomObject(objects)

	local num = #objects;
	
	if (num > 1) then
		return objects[World_GetRand(1, num)];
	else
		if (num == 1) then
			return objects[1];
		else
			return nil;
		end
	end
	
end

-- Spawns a garrison (quick way of spawning units inside multiple buildings)
function Util_SpawnGarrison(player, egroup, sgroup, blueprint, max)

	if (max == nil) then
		max = 1;
	end

	if (scartype(blueprint) == ST_TABLE) then
		if (#blueprint > 1) then
			blueprint = blueprint[World_GetRand(1, #blueprint)];
		else
			fatal("not enough items inside of table");
		end
	end
	
	for i=1, EGroup_Count(egroup) do
		
		local entity = EGroup_FromEntity(EGroup_GetSpawnedEntityAt(egroup, i));
		
		for i=1, max do
			
			local sg_temp = SGroup_CreateIfNotFound("_sg_temp");
			Util_CreateSquads(player, sg_temp, blueprint, entity, nil, 1);
			SGroup_AddGroup(sgroup, sg_temp);
			SGroup_Clear(sg_temp);
			
		end
		
	end
	
end

-- Ends the game with proper settings
function Codiex_EndGame(race, result)
	if (race == "aef") then
		if (result == true) then
			Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:248", 5.0, 5.0, 5.0);
		else
			Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:252", 5.0, 5.0, 5.0);
		end
		_EndProperly(result);
		Rule_RemoveAll();
	elseif (race == "german" or race == "west_german") then
		if (result == true) then
			Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:247", 5.0, 5.0, 5.0);
		else
			Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:250", 5.0, 5.0, 5.0);
		end
		_EndProperly(result);
		Rule_RemoveAll();
	elseif (race == "soviet") then
		if (result == true) then
			Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:245", 5.0, 5.0, 5.0);
		else
			Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:249", 5.0, 5.0, 5.0);
		end
		_EndProperly(result);
		Rule_RemoveAll();
	else
		if (result == true) then
			Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:37", 5.0, 5.0, 5.0);
		else
			Util_MissionTitle("$08a0ac9c7e6144909909a02d533ce8aa:38", 5.0, 5.0, 5.0);
		end
		_EndProperly(result);
		Rule_RemoveAll();
	end
end

function _EndProperly(result)
	if (Util_IsCoop() == true) then
		if (result == true) then
			World_SetTeamWin(Player_GetTeam(player1));
		else
			World_SetTeamWin(Player_GetTeam(Player_FindFirstEnemyPlayer(player1)));
		end
	else
		Game_EndSP(result);
	end
end
