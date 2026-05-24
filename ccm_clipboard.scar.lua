--loadfile("scar/ccm_clipboard.scar")()


function CCM_CopySelection(caster, target)
	local settings_key = Player_GetSettingsKey(caster)
	Clipboard_Clear(caster)
	target = Misc_CheckForParentSquad(target)
	if scartype(target) == ST_SQUAD then	
		local squad = target		
		local item = {
			type = "squad",
			bp = Squad_GetBlueprint(squad),
			owner = Squad_GetPlayerOwnerSafe(squad),
			health = Squad_GetHealthTable(squad),
			heading = Squad_GetHeadingTable(squad),
			upg = Squad_GetUpgradesTable(squad),
			slotitem = Squad_GetSlotItemTable(squad),
			critical = Squad_GetCriticalsTable(squad),
			veterancy = Squad_GetVeterancyExperience(squad),
			count = Squad_Count(squad),
		}
		table.insert(g_settings[settings_key].clipboard, item)
		CCM_EventCue(Player_GetName(caster)..": Copied squad "..BP_GetName(item.bp))
	elseif scartype(target) == ST_ENTITY then
		local entity = target
		local item = {
			type = "entity",
			bp = Entity_GetBlueprint(entity),
			owner = Entity_GetPlayerOwnerSafe(entity),
			health = Entity_GetHealthPercentage(entity),
			heading = Entity_GetHeading(entity),
			upg = Entity_GetUpgradeTable(entity),
			count = 1,
		}
		table.insert(g_settings[settings_key].clipboard, item)
		CCM_EventCue(Player_GetName(caster)..": Copied entity "..BP_GetName(item.bp))
	
	elseif scartype(target) == ST_POSITION then
		--[[
		local item = {
			type = "entity",
			bp = Entity_GetBlueprint(entity),
			owner = Entity_GetPlayerOwnerSafe(entity),
			health = Entity_GetHealthPercentage(entity),
			heading = Entity_GetHeading(entity),
			upg = Entity_GetUpgradeTable(entity),
			count = 1,
		}
		table.insert(g_clipboard, item)
		msg = msg..BP_GetName(item.bp).."\n"	
		--]]	
	end
end

function CCM_PasteSelection(caster, target)
	local pos = Util_GetPosition(target)
	local settings_key = Player_GetSettingsKey(caster)
	local sg_garrison = SGroup_CreateIfNotFound("sg_garrison")

	for key, item in ipairs(g_settings[settings_key].clipboard) do
		local squad
		local entity
		
		if item.type == "squad" then

			local squad = Squad_CreateAndSpawnToward(item.bp, World_GetPlayerAt(1), item.count, pos, pos)
			Squad_ApplyHealthTable(squad, item.health)
			Misc_AddSpawnedItemToSystem(squad, caster)
			if scartype(target) == ST_SQUAD or scartype(target) == ST_ENTITY then
				SGroup_Clear(sg_garrison)
				SGroup_Add(sg_garrison, squad)
				
				if scartype(target) == ST_SQUAD and Squad_CanLoadSquad(target, squad, true, false) then
					Command_SquadSquadLoad(Squad_GetPlayerOwnerSafe(squad), sg_garrison, SCMD_InstantLoad, Squad_GetTempSGroup(target), false, false)
				elseif scartype(target) == ST_ENTITY and Entity_CanLoadSquad(target, squad, true, false) then
					Command_SquadEntityLoad(Squad_GetPlayerOwnerSafe(squad), sg_garrison, SCMD_InstantLoad, Entity_GetTempEGroup(target), false, false)
				end
			end
			if not item.owner then
				Squad_SetWorldOwned(squad)
			else
				Squad_SetPlayerOwner(squad, item.owner)
			end
			Squad_ApplyHeadingTable(squad, item.heading)
			for key, upg in ipairs(item.upg) do
				Squad_CompleteUpgrade(squad, upg)
			end
			local currentitems = Squad_GetSlotItemTable(squad)
			
			for key, s_item1 in ipairs(currentitems) do
				for key, s_item2 in ipairs(item.slotitem) do
					if s_item1 == s_item2 then
						table.remove(item.slotitem, key)
					end
				end
			end
			Squad_ApplyCriticalHitTable(squad, item.critical)
			for key, pbg in ipairs(item.slotitem) do
				Squad_GiveSlotItem(squad, pbg)
			end
			Squad_IncreaseVeterancyExperience(squad, item.veterancy, true, true)
			CCM_EventCue(Player_GetName(caster)..": Pasted squad "..BP_GetName(item.bp))		
		elseif item.type == "entity" then
			local entity = Entity_CreateAndSpawnToward(item.bp, owner, pos, pos)
			Entity_SetHealth(entity, item.health)
			Misc_AddSpawnedItemToSystem(entity, caster)
			if item.owner then
				Entity_SetPlayerOwner(entity, item.owner)
			end
			Entity_ForceConstruct(entity)
			Entity_Spawn(entity)
			Entity_SetHeading(entity, item.heading, false)
			if item.owner ~= nil then
				for key, upg in ipairs(item.upg) do
					Entity_CompleteUpgrade(entity, upg)
				end
			end
			CCM_EventCue(Player_GetName(caster)..": Pasted entity "..BP_GetName(item.bp))		
		end
	end
end

function Clipboard_Clear(caster)
	local settings_key = Player_GetSettingsKey(caster)
	g_settings[settings_key].clipboard = {}
end