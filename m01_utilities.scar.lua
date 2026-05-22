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

-- Disables all visible signs of this unit (Rename this)
function SGroup_DisableUI(sgroup)

	Cmd_Stop(sgroup);

	SGroup_EnableAttention(sgroup, false);
	SGroup_EnableMinimapIndicator(sgroup, false);
	SGroup_EnableSurprise(sgroup, false);
	SGroup_EnableUIDecorator(sgroup, false); 
	SGroup_SetSelectable(sgroup, false);
	SGroup_Hide(sgroup, true); 
	
end

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

-- Makes the squad(s) surrender and move to the position
function Util_Surrender(sgroupid, exitpos, delete, removeWeapon)

	if SGroup_CountSpawned(sgroupid) < 1 then
		return;
	end
	
	SGroup_CreateKickerMessage(sgroupid, Game_GetLocalPlayer(), 42812);

	if _surrender == nil then
		_surrender = {};
	end
		
	_sg_temp = SGroup_CreateIfNotFound("_sg_temp");
	_eg_all = EGroup_CreateIfNotFound("_eg_all");
	
	if exitpos == nil then
		fatal("Attempted to call Cmd_Surrender() with a nil exit position.");
	end
	
	if delete == nil then
		delete = true;
	end
	
	if removeWeapon == nil then
		removeWeapon = true;
	end
	
	SGroup_Clear(_sg_temp);
	EGroup_Clear(_eg_all);
	
	local _AddSquad = function( gid, idx, sid )
	
		local temp = {
			pos_exit 	= exitpos,
			state		= false,
			deleteSquad	= delete,
			disarm		= removeWeapon,
		}
		
		table.insert(_surrender, temp);
		local num = #_surrender;
		
		_surrender[num].sgroup = SGroup_CreateIfNotFound("_sg_surrender"..num);
		_surrender[num].timer = "_SURRENDER_TIMER"..num;
		
		SGroup_Add(_surrender[num].sgroup, sid);
		
	end
	
	SGroup_ForEach(sgroupid, _AddSquad);
	Cmd_Stop(sgroupid);
	
	if SGroup_HasTeamWeapon(sgroupid, ANY) then
		Cmd_AbandonTeamWeapon(sgroupid, true);
	end
	
	SGroup_SetSuppression(sgroupid, 0);
	SGroup_SetAutoTargetting(sgroupid, "hardpoint_01", false);
	SGroup_SetAutoTargetting(sgroupid, "hardpoint_02", false);
	SGroup_SetAutoTargetting(sgroupid, "hardpoint_03", false);
	SGroup_SetAutoTargetting(sgroupid, "hardpoint_04", false);
	SGroup_SetInvulnerable(sgroupid, true);
	SGroup_SetCrushable(sgroupid, false);
	SGroup_EnableAttention(sgroupid, false);

	SGroup_GetLastAttacker(sgroupid, _sg_temp);
	if not SGroup_IsEmpty(_sg_temp) then
		Cmd_Stop(_sg_temp);
	end
	
	SGroup_EnableUIDecorator(sgroupid, false );
	SGroup_EnableMinimapIndicator(sgroupid, false);
	SGroup_SetSelectable(sgroupid, false);
	
	SGroup_SetPlayerOwner(sgroupid, player1);
	
	if Rule_Exists(_SurrenderInternal2) == false then
		Rule_AddInterval(_SurrenderInternal2, 0.5);
	end

end

function _SurrenderInternal2()

	for k, v in pairs(_surrender) do
		
		if (SGroup_Count(v.sgroup) == 0) then
			table.remove(_surrender, k);
		else
		
			if SGroup_IsMoving( v.sgroup, ALL ) == false and v.state == false then
				
				if SGroup_HasTeamWeapon(v.sgroup, ANY) then
					Cmd_AbandonTeamWeapon(v.sgroup, true);
				elseif SGroup_IsInHoldEntity(v.sgroup, ANY) 
				or SGroup_IsInHoldSquad(v.sgroup, ANY) then
					Cmd_UngarrisonSquad(v.sgroup);
				else
					v.state = "surrender";
					Timer_Start(v.timer, 3*60);
					SGroup_SetMoodMode(v.sgroup, MM_ForceCalm);
					SGroup_SetAnimatorState(v.sgroup, "surrender", "on");
					if v.disarm == true then
						SGroup_CallSquadFunction(v.sgroup, function(id) Squad_AddAbility(id, ABILITY.GLOBAL.SP_DROP_WEAPONS) end, nil)
						Cmd_Ability(v.sgroup, ABILITY.GLOBAL.SP_DROP_WEAPONS, nil, nil, true, true )
					end
					Cmd_DoPlan(v.sgroup, "surrender", v.pos_exit, true);
				end
				
			elseif v.state == "surrender" then		
				if Prox_AreSquadMembersNearMarker(v.sgroup, v.pos_exit, ANY, 5)
				  or Timer_GetRemaining(v.timer) <= 0 then
					if v.deleteSquad == true then
						SGroup_DestroyAllSquads(v.sgroup);
					end
				elseif not SGroup_IsMoving(v.sgroup, ANY) then
					Cmd_DoPlan(v.sgroup, "surrender", v.pos_exit, true);
				end
				local sg_attackers = SGroup_CreateIfNotFound("_sg_surrender_attacker");
				SGroup_GetLastAttacker(v.sgroup, sg_attackers);
				if (SGroup_Count(sg_attackers) > 0) then
					Cmd_Stop(sg_attackers);
				end
				SGroup_Clear(sg_attackers);
			end
			
		end
		
	end
	
	if #_surrender == 0 then
		Rule_RemoveMe();
	end

end

function Object_CreateCCSlotItem(entityName, slotItemName)
	local object = 
	{
		entity_file = entityName,
		entity_bp = BP_GetEntityBlueprint(entityName),
		slot_file = slotItemName,
		slot_bp = BP_GetSlotItemBlueprint(slotItemName)
	};
	return object;
end

-- Adds a CC slot item to the squad - does not seem to work
function SGroup_AddSlotItem(group, item, amount, first)

	if (first == nil) then
		first = false;
	end

	if (amount == nil) then
		amount = 1;
	end
	
	local sCount = SGroup_Count(group);

	if (sCount == 0) then -- ignore empty groups
		return 
	end
	
	if (sCount > 1 or first == false) then
	
		for i=1, sCount do
		
			local squad = SGroup_GetSpawnedSquadAt(group, i);
			
			for i=1, amount do
				Squad_GiveSlotItem(squad, BP_GetSlotItemBlueprint(item.slot_file));
			end
			
		end
	
	else
		
		local squad = SGroup_GetSpawnedSquadAt(group, 1);
		
		for i=1, amount do
			Squad_GiveSlotItem(squad, BP_GetSlotItemBlueprint(item.slot_file));
		end
		
	end

end
