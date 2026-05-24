--loadfile("scar/ccm_action.scar")()

function CCM_AddInfiniteResourcesPopcap(caster, target)
	local settings_key = Player_GetSettingsKey(caster)
	for key, resource_type in ipairs(g_resource_type) do
		Player_AddResource(caster, resource_type, 1000000)
	end
	
	Player_SetPopCapOverride(caster, 1000000)
	
	g_settings[settings_key].infinite_resources = not g_settings[settings_key].infinite_resources
	
	CCM_EventCue(Player_GetName(caster)..": Infinite resources and population cap enabled.")
end

function CCM_ActionKillSelection(caster, target)
	target = Misc_CheckForParentSquad(target)
	if scartype(target) == ST_ENTITY or scartype(target) == ST_SQUAD then
		CCM_EventCue(Player_GetName(caster)..": Killed "..Util_GetBPName(target))
		Util_Kill(target)
	end
end
function CCM_ActionDeleteSelection(caster, target)
	target = Misc_CheckForParentSquad(target)
	if scartype(target) == ST_ENTITY or scartype(target) == ST_SQUAD then
		CCM_EventCue(Player_GetName(caster)..": Deleted "..Util_GetBPName(target))
		Util_Destroy(target)
	end
end

function CCM_ActionTeleportSelection(caster, target)
	local settings_key = Player_GetSettingsKey(caster)
	target = Misc_CheckForParentSquad(target)
	if not g_settings[settings_key].teleport_item then
		if scartype(target) == ST_ENTITY or scartype(target) == ST_SQUAD then
			g_settings[settings_key].teleport_item = Util_GetGameID(target)
			if scartype(target) == ST_SQUAD then
				CCM_EventCue(Player_GetName(caster)..": Added squad "..Util_GetBPName(target).." to teleport")
			elseif scartype(target) == ST_ENTITY then
				CCM_EventCue(Player_GetName(caster)..": Added entity "..Util_GetBPName(target).." to teleport")
			end
		end
	else
		local id = g_settings[settings_key].teleport_item
		local item = Util_DecodeGameID(id)
		if item then
			local target_pos = Util_GetPosition(target)
			Util_SetPosition(item, target_pos)
			CCM_EventCue(Player_GetName(caster)..": Teleported "..Util_GetBPName(item).. " to "..Pos_GetXYZString(target_pos))
		else
			CCM_EventCue(Player_GetName(caster)..": Unable to teleport - squad/entity no longer exists.")
		end
		g_settings[settings_key].teleport_item = nil
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

function Util_SetPosition(item, pos)
	if scartype(item) == ST_SQUAD then
		Squad_SetPosition(item, pos, pos)
	elseif scartype(item) == ST_ENTITY then
		Entity_SetPosition(item, pos)
	end
end

function CCM_ActionIncreaseSelectionVeterancy(caster, target)
	target = Misc_CheckForParentSquad(target)
	
	if scartype(target) == ST_SQUAD then
		Squad_IncreaseVeterancyRank(target, 1, false)
		CCM_EventCue(Player_GetName(caster)..": Increased veterancy for  "..Util_GetBPName(target))
	end
end

function CCM_ActionIncreaseSelectionHealth(caster, target)
	CCM_ModifySelectionHealth(caster, target, 0.1)
end

function CCM_ActionDecreaseSelectionHealth(caster, target)
	CCM_ModifySelectionHealth(caster, target, -0.1)
end

function CCM_ModifySelectionHealth(caster, target, amount)
	target = Misc_CheckForParentSquad(target)

	local _protectHealth = function(health)
		if health < 0 then
			return 0
		elseif health > 1 then
			return 1
		else
			return health
		end		
	end
	if scartype(target) == ST_SQUAD then
		local squad = target
		local currentHealth = Squad_GetHealthTable(squad)
		local sum_health = 0
		for key, health in ipairs(currentHealth) do
			currentHealth[key] = health + amount
			if currentHealth[key] > 1 then 
				currentHealth[key] = 1
			elseif currentHealth[key] < 0 then
				currentHealth[key] = 0
			end
			sum_health = sum_health + currentHealth[key]
			--CCM_EventCue(Player_GetName(caster)..": currentHealth[key]: "..currentHealth[key]..", health: "..health..", amount: "..amount)
		end
		
		local average_health = math.floor(sum_health / table.getn(currentHealth) * 1000) / 1000 * 100
		Squad_ApplyHealthTable(squad, currentHealth)
		CCM_EventCue(Player_GetName(caster)..": Increased health for squad "..Util_GetBPName(squad).." to "..average_health.."%")

	elseif scartype(target) == ST_ENTITY then
		local entity = target
		local currentHealth = Entity_GetHealthPercentage(entity)
		local newHealth = _protectHealth(currentHealth + amount)

		Entity_SetHealth(entity, newHealth)
		newHealth = math.floor(newHealth * 10000) / 10000 * 100
		CCM_EventCue(Player_GetName(caster)..": Increased health for entity "..Util_GetBPName(entity).." to "..newHealth.."%")
	end
end

function CCM_ActionAbandonSelected(caster, target)
	target = Misc_CheckForParentSquad(target)
	
	if scartype(target) == ST_SQUAD then
		if Squad_HasTeamWeapon(target) then
			Cmd_AbandonTeamWeapon(Squad_GetTempSGroup(target), false, false)
			CCM_EventCue(Player_GetName(caster)..": Abandoned team weapon "..Util_GetBPName(target))
		elseif Squad_IsVehicle(target) then
			Command_PlayerSquadCriticalHit(caster, Squad_GetTempSGroup(target), PCMD_CriticalHit, BP_GetCriticalBlueprint("vehicle_abandon"), 1, false)
			CCM_EventCue(Player_GetName(caster)..": Abandoned vehicle "..Util_GetBPName(target))
		end
		
	end
end




function CCM_ActionRemoveCriticals(caster, target)
	target = Misc_CheckForParentSquad(target)
	
	if scartype(target) == ST_SQUAD then
		local squad = target
		Squad_ForEachEntity(squad, function(squad, idx, entity)
			for key, critbp in pairs(CRIT) do
				if Entity_HasCritical(entity, critbp) then
					Entity_RemoveCritical(entity, critbp)
					CCM_EventCue(Player_GetName(caster)..": Removed critical "..BP_GetName(critbp).." from squad "..Util_GetBPName(target))
				end
			end

		end)
	end
end

function CCM_ActionDropSlotItems(caster, target)
	target = Misc_CheckForParentSquad(target)
	
	if scartype(target) == ST_SQUAD then
		local squad = target
		local items = {}
		local pos = Squad_GetPosition(squad)	
		local item_spawn_pos = pos	
		for key, pbg in pairs(SLOT_ITEM) do
			local count = Squad_GetNumSlotItem(squad, pbg)
			if count > 0 then
				for i = 1, count do
					Misc_SpawnSlotItemOnGround(pbg, item_spawn_pos)
					item_spawn_pos = Util_GetRandomPosition(item_spawn_pos, 5)
					CCM_Msg("squad has "..count.." "..BP_GetName(pbg).." slot items. i = ["..i.."]\n\t\tkey = ["..key.."]")
				end
			end
		end

		Squad_DropSlotItems(squad)
		Squad_RemoveUpgrades(squad)
		
		CCM_EventCue(Player_GetName(caster)..": Dropped slot items for squad "..Util_GetBPName(target))	
	end

end


function CCM_ActionInstantReinforce(caster, target)
	target = Misc_CheckForParentSquad(target)
	if scartype(target) == ST_SQUAD then
		local squad = target
		Command_SquadPosExt(
			Squad_GetPlayerOwnerSafe(squad, true),
			Squad_GetTempSGroup(squad),
			SCMD_InstantReinforceUnit,
			Squad_GetPosition(squad),
			0,
			false
		)
		CCM_EventCue(Player_GetName(caster)..": Reinforced squad "..Util_GetBPName(target).." by one member")	
	end		
end

function CCM_ActionAddPreciseManpower(caster, target)
	Player_AddResource(caster, RT_Manpower, 1000)
	
	CCM_EventCue(Player_GetName(caster)..": + 1000 Manpower")
end
function CCM_ActionAddPreciseFuel(caster, target)
	Player_AddResource(caster, RT_Fuel, 1000)
	
	CCM_EventCue(Player_GetName(caster)..": + 1000 Fuel")
end
function CCM_ActionAddPreciseMunition(caster, target)
	Player_AddResource(caster, RT_Munition, 1000)
	
	CCM_EventCue(Player_GetName(caster)..": + 1000 Munition")
end

function _CCM_SpawnSpawnerSquad(caster, target, sbp)
	local spawnPos = Util_GetPosition(target)
	local sbp = CCM_GetSquadBlueprint(sbp)
	local squad = Squad_CreateAndSpawnToward(sbp, caster, 0, spawnPos, spawnPos)
	
	Rule_AddSquadEvent(CCM_SquadAbilityListener, squad, GE_AbilityExecuted)
	_CCM_InitSpawnerSquad(squad)
end

function CCM_ActionSpawnSovietSpawner(caster, target)
	_CCM_SpawnSpawnerSquad(caster, target, "ccm_soviet_spawner_squad")
end
function CCM_ActionSpawnAEFSpawner(caster, target)
	_CCM_SpawnSpawnerSquad(caster, target, "ccm_aef_spawner_squad")
end
function CCM_ActionSpawnUKFSpawner(caster, target)
	_CCM_SpawnSpawnerSquad(caster, target, "ccm_ukf_spawner_squad")
end
function CCM_ActionSpawnGermanSpawner(caster, target)
	_CCM_SpawnSpawnerSquad(caster, target, "ccm_german_spawner_squad")
end
function CCM_ActionSpawnWestGermanSpawner(caster, target)
	_CCM_SpawnSpawnerSquad(caster, target, "ccm_west_german_spawner_squad")
end

function CCM_ActionAddFullHealth(caster, target)
	CCM_ModifySelectionHealth(caster, target, 1.0)
end

function CCM_ActionKillOneEntity(caster, target)
	if scartype(target) == ST_ENTITY or scartype(target) == ST_SQUAD then
		CCM_EventCue(Player_GetName(caster)..": Killed "..Util_GetBPName(target))
		Util_Kill(target)
	end
end

function CCM_ActionDeleteOneEntity(caster, target)
	if scartype(target) == ST_ENTITY or scartype(target) == ST_SQUAD then
		CCM_EventCue(Player_GetName(caster)..": Deleted "..Util_GetBPName(target))
		Util_Destroy(target)
	end		
end

function CCM_ActionSpawnGermanMiscSpawner(caster, target)
	_CCM_SpawnSpawnerSquad(caster, target, "ccm_german_misc_spawner_squad")
end
function CCM_ActionSpawnSovietMiscSpawner(caster, target)
	_CCM_SpawnSpawnerSquad(caster, target, "ccm_soviet_misc_spawner_squad")
end
function CCM_ActionSpawnWestGermanMiscSpawner(caster, target)
	_CCM_SpawnSpawnerSquad(caster, target, "ccm_west_german_misc_spawner_squad")
end
function CCM_ActionSpawnAEFMiscSpawner(caster, target)
	_CCM_SpawnSpawnerSquad(caster, target, "ccm_aef_misc_spawner_squad")
end
function CCM_ActionSpawnUKFMiscSpawner(caster, target)
	_CCM_SpawnSpawnerSquad(caster, target, "ccm_ukf_misc_spawner_squad")
end


