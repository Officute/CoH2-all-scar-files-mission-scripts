--loadfile("scar/ccm_extensions.scar")()


function Util_Destroy(var)
	if (scartype(var) == ST_PLAYER) then
		SGroup_DestroyAllSquads(Player_GetSquads(var))
	elseif(scartype(var) == ST_EGROUP) then
		EGroup_DestroyAllEntities(var)
	elseif(scartype(var) == ST_SGROUP) then
		SGroup_DestroyAllSquads(var)
	elseif(scartype(var) == ST_SQUAD) then
		Squad_Destroy(var)
	elseif(scartype(var) == ST_ENTITY) then
		Entity_Destroy(var)
	else
		fatal("Invalid type (" .. scartype_tostring(var) .. "). Must be Entity/Squad/EGroup/Egroup")
	end
end

function Util_GetBlueprint(var)
	if scartype(var) == ST_SQUAD then
		return Squad_GetBlueprint(var)
	elseif scartype(var) == ST_ENTITY then
		return Entity_GetBlueprint(var)
	else
		return var
	end
end

function Util_GetBPName(var)
	return BP_GetName(Util_GetBlueprint(var))
end
function Misc_CheckForParentSquad(target)
	if scartype(target) == ST_ENTITY then
		if Entity_GetSquad(target) then
			return Entity_GetSquad(target)
		else
			return target
		end
	else
		return target
	end
end


function Squad_GetTableKey(squad)
	return "squad_"..Squad_GetGameID(squad)
end

function Entity_GetTableKey(entity)
	return "entity_"..Entity_GetGameID(entity)
end

function Util_GetTablekey(var)
	if scartype(var) == ST_SQUAD then
		return Squad_GetTableKey(var)
	elseif scartype(var) == ST_ENTITY then
		return Entity_GetTableKey(var)
	end
end

function Util_SetInvulnerable(target, enable)
	if scartype(target) == ST_SQUAD then
		Squad_SetInvulnerable(target, enable, 0)
	elseif scartype(target) == ST_ENTITY then
		Entity_SetInvulnerable(target, enable, 0)
	end
end

function Player_GetIDSafe(player)
	if player ~= nil and player ~= "world" then
		return Player_GetID(player)
	elseif player == nil or player == "world" then
		return nil
	end
end

function Players_ForEach(f)
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		local pid = Player_GetID(player)
		f(pid, i, player)
	end
end

function Table_ForEach(t, _mode, f)
	for key, value in _mode(t) do
		f(key, value)
	end
end


function CCM_Msg(text)
	if g_enable_messages then
		g_text = text.."\n"..g_text
		dr_clear("CCM")
		dr_setautoclear("CCM", 0)
		dr_text2d("CCM", 0.615, 0.025, g_text, 0, 255, 0)
		
		if TimeRule_Exists(CCM_ClearMSG) then
			--TimeRule_Remove(CCM_ClearMSG)
			--Rule_AddOneShot(CCM_ClearMSG, 10)
		else
			--Rule_AddOneShot(CCM_ClearMSG, 10)
		end
	end
end

function CCM_ClearMSG()
	dr_clear("CCM")
end

function CCM_GetAbilityBleprint(blueprint)
	return BP_GetAbilityBlueprint(g_guid..":"..blueprint)
end

function CCM_GetSquadBlueprint(blueprint)
	return BP_GetSquadBlueprint(g_guid..":"..blueprint)
end

function CCM_GetEntityBlueprint(blueprint)
	return BP_GetEntityBlueprint(g_guid..":"..blueprint)
end
function CCM_GetUpgradeBlueprint(blueprint)
	return BP_GetUpgradeBlueprint(g_guid..":"..blueprint)
end

function CCM_GetIcon(icon) 
	return "ModIcons_"..g_guid.."_"..icon
end

function CCM_EventCue(msg)
	local title = Util_CreateLocString(msg)
	UI_CreateEventCueClickable(CCM_GetIcon("ccm_eventcue"), "", title, title, print, 10, true)
end

function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end



function Misc_AddSpawnedItemToSystem(item, caster)
	local settings_key = Player_GetSettingsKey(caster)
	local itemType = scartype(item)
	if itemType == ST_ENTITY then
		local eid = Entity_GetGameID(item)
		g_settings[settings_key].spawned_items["entity_"..eid] = eid

	elseif itemType == ST_SQUAD then
		local sid = Squad_GetGameID(item)
		g_settings[settings_key].spawned_items["squad_"..sid] = sid
	end
end

function Util_AddHealth(item, addition_percentage)
	if scartype(item) == ST_SQUAD then
		local curren_health = Squad_GetHealthPercentage(item)
		local new_health = Misc_DoPercentageSum(curren_health, addition_percentage)	
		Squad_SetHealth(item, new_health)
	elseif scartype(item) == ST_ENTITY then
		local curren_health = Entity_GetHealthPercentage(item)
		local new_health = Misc_DoPercentageSum(curren_health, addition_percentage)	
		Entity_SetHealth(item, new_health)
	end
end

function Misc_DoPercentageSum(value1, value2)
	local new_value = value1 + value2
	if new_value > 1 then
		new_value = 1
	elseif new_value < 0 then
		new_value = 0
	end
	return new_value
end

function Util_SetPosition(item, pos)
	if scartype(item) == ST_SQUAD then
		Squad_SetPosition(item, pos, pos)
	elseif scartype(item) == ST_ENTITY then
		Entity_SetPosition(item, pos)
	end
end


function Pos_GetXYZString(pos)
	local multiplier = 10
	local x = math.floor(pos.x * multiplier) / multiplier
	local y = math.floor(pos.y * multiplier) / multiplier
	local z = math.floor(pos.z * multiplier) / multiplier

	return "X: "..x..", Y:"..y..", Z: "..z
end

function Util_GetGameID(item)
	if scartype(item) == ST_SQUAD then
		return Squad_GetGameID(item)
	elseif scartype(item) == ST_ENTITY then
		return Entity_GetGameID(item)
	end	
end

function Util_DecodeGameID(id)
	if Squad_IsValid(id) then
		return Squad_FromWorldID(id)
	elseif Entity_IsValid(id) then
		return Entity_FromWorldID(id)
	else
		return false
	end
end

function Misc_SpawnSlotItemOnGround(item, pos)
	local new_squad = Squad_CreateAndSpawnToward(SBP.SOVIET.BASE_CONSCRIPT_SQUAD_MP, World_GetPlayerAt(1), 1, pos, pos)
	Squad_AddSlotItemToDropOnDeath(new_squad, item, 1.0, true)
	Squad_Destroy(new_squad)
end

function isset(var)
	if var ~= nil then
		return true
	else
		return false
	end
end

function Player_IsLocalPlayer(player)
	local localPlayerId = Player_GetID(Game_GetLocalPlayer())
	if Player_GetID(player) == localPlayerId then
		return true
	else
		return false
	end
end
