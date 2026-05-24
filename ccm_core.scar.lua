import("Fatalities/Fatalities.scar")
import("winconditions/ccm_squad.scar")
import("winconditions/ccm_entity.scar")
import("winconditions/ccm_extensions.scar")
import("winconditions/ccm_clipboard.scar")
import("winconditions/ccm_toggle.scar")
import("winconditions/ccm_action.scar")
import("winconditions/ccm_data.scar")

function CCM_PreInit()
	--loadfile("scar/ccm_core.scar")()
	CCM_SystemInit()
end

Scar_AddInit(CCM_PreInit)



g_resource_type = {RT_Manpower, RT_Munition, RT_Fuel, RT_Command}

function CCM_SystemInit()
	g_text = ""
	g_version = "0.1"
	g_guid = "77d2aff43aa04b05857ed9e310a0c1e0"
	g_enable_messages = false
	g_health_monitor_enabled = {}
	-- data holders
	g_invulnerability_state = {}
	g_owner_state = {}
	g_settings = {}
	g_clipboard = {}
	g_spawned_items = {}
	g_engine_crit_state = {}
	g_posture_state = {}
	g_spawner_squad_current_upgrade = {}
	g_last_action_executed = {}
	g_players = {"world"}
	g_ability_hide_cheats = CCM_GetAbilityBleprint("ccm_hideabilities")
	g_global_settings = {
		fow_enabled = true,
		global_ai_enabled = true,
	}
	g_settings_template = {
		instant_production = false,
		clipboard = {},
		spawned_items = {},
		teleport_item = false,
		health_monitor_enabled = false, --initial toggle happens before event are registered
	}
	
	g_health_monitor = {}
	
	Players_ForEach(function(pid, idx, player)
		g_settings[Player_GetSettingsKey(player)] = Table_Copy(g_settings_template)
		table.insert(g_players, player)
	end)
	
	CCM_Msg("CheatCommands Mod WCP"..g_version)

	CCM_DataInit()
	Players_ForEach(function(pid, idx, player)
		-- add all category abilities so that they are accessible
		--[[for key, category in ipairs(g_ccm_category_ability) do
			
			Player_AddAbility(player, category.ability)
			for key2, action in ipairs(category.actions) do
				Player_AddAbility(player, action.ability)
				Player_SetAbilityAvailability(player, action.ability, ITEM_REMOVED)
			end
			if category.ability ~= g_ccm_category_ability[1].ability then
				Player_SetAbilityAvailability(player, category.ability, ITEM_REMOVED)
			end
		end
		--]]
		
		
		Player_AddAbility(player, g_ability_hide_cheats)
		Rule_AddPlayerEvent(CCM_PlayerAbilityListener, player, GE_AbilityExecuted)
		Rule_AddPlayerEvent(CCM_PlayerAbilityCompleteListener, player, GE_AbilityComplete)
		CCM_PlayerResetAbilities(player)
	end)
	Rule_AddInterval(CCM_HealthMonitor, 1)
	Camera_SetTuningValue(TV_DistMax, 2048)
	--Rule_AddInterval(CCM_AutoHideAbilities, 1)
end

function CCM_PlayerResetAbilities(player)
	for key, category in ipairs(g_ccm_category_ability) do
		
		Player_AddAbility(player, category.ability)
		for key2, action in ipairs(category.actions) do
			Player_AddAbility(player, action.ability)
			Player_SetAbilityAvailability(player, action.ability, ITEM_REMOVED)
		end
		if category.ability ~= g_ccm_category_ability[1].ability then
			Player_SetAbilityAvailability(player, category.ability, ITEM_REMOVED)
		else
			Player_SetAbilityAvailability(player, category.ability, ITEM_UNLOCKED)
		end
	end
end

function Player_GetSettingsKey(player)
	return "settings_"..Player_GetName(player)
end

function Player_GetName(player)
	if player == "world" or not player then 
		return "World"
	end
	return Player_GetDisplayName(player)[1]
end

function CCM_PlayerAbilityCompleteListener(caster, ability, target)
	if ability == CCM_GetAbilityBleprint("category_04_action_05") then
		CCM_ToggleHealthMonitor(caster, target)
	end
end
function CCM_PlayerAbilityListener(caster, ability, target)
	CCM_Msg("triggered ability")
	local unlock_next_category = false
	local next_category_unlocked = false
	local next_category_unlock_requested = false
	
	if ability == g_ability_hide_cheats then
		CCM_PlayerResetAbilities(caster)
		return true
	end
	
	for key, category in ipairs(g_ccm_category_ability) do
		--CCM_Msg("Loop - "..tostring(key))
		if unlock_next_category then
			Player_SetAbilityAvailability(caster, category.ability, ITEM_UNLOCKED)
			next_category_unlocked = true
			unlock_next_category = false
			--CCM_Msg("new ability unlocked (next mode) - added "..BP_GetName(category.ability))

		end
		if ability == category.ability then
			--CCM_Msg("ability match found - removed "..BP_GetName(ability))
			Player_SetAbilityAvailability(caster, ability, ITEM_REMOVED)
			--remove all category abilities
			for key_category, category in ipairs(g_ccm_category_ability) do
				for key_action_ability, action in ipairs(category.actions) do
					Player_SetAbilityAvailability(caster, action.ability, ITEM_REMOVED)
				end
			end
			--add abilities for the selected category
			for key_category_ability, action in ipairs(category.actions) do
				Player_SetAbilityAvailability(caster, action.ability, ITEM_UNLOCKED)
			end
			unlock_next_category = true
			next_category_unlock_requested = true
			CCM_RegisterPlayerAction(caster)
		end
	end
	
	if next_category_unlock_requested and not next_category_unlocked then
		Player_SetAbilityAvailability(caster, g_ccm_category_ability[1].ability, ITEM_UNLOCKED)
		CCM_Msg("new ability unlocked (after mode) - added "..BP_GetName(g_ccm_category_ability[1].ability))
	end
	
	for key, category in ipairs(g_ccm_category_ability) do
		for key2, action in ipairs(category.actions) do
			if ability == action.ability then
				action.action(caster, target)
				CCM_RegisterPlayerAction(caster)
			end
		end
	end
end

function CCM_RegisterPlayerAction(player)
	g_last_action_executed[Player_GetSettingsKey(player)] = {player  = player, expires = World_GetGameTime() + 20, expired = false}
end


function Squad_GetSpawnerRaceIndex(squad)
	local sbp = Squad_GetBlueprint(squad)
	
	local spawnerSquadBP = {
		{CCM_GetSquadBlueprint("ccm_german_spawner_squad"), 0},
		{CCM_GetSquadBlueprint("ccm_soviet_spawner_squad"), 1},
		{CCM_GetSquadBlueprint("ccm_west_german_spawner_squad"), 2},
		{CCM_GetSquadBlueprint("ccm_aef_spawner_squad"), 3},
		{CCM_GetSquadBlueprint("ccm_ukf_spawner_squad"), 4},
		
		{CCM_GetSquadBlueprint("ccm_german_misc_spawner_squad"), 0},
		{CCM_GetSquadBlueprint("ccm_soviet_misc_spawner_squad"), 1},
		{CCM_GetSquadBlueprint("ccm_west_german_misc_spawner_squad"), 2},
		{CCM_GetSquadBlueprint("ccm_aef_misc_spawner_squad"), 3},
		{CCM_GetSquadBlueprint("ccm_ukf_misc_spawner_squad"), 4},
	}
	
	for key, compareSBP in ipairs(spawnerSquadBP) do
		if sbp == compareSBP[1] then
			return compareSBP[2]
		end
	end
end

function Squad_GetSpawnerTable(squad)
	local bp = Squad_GetBlueprint(squad)
	
	local spawnerSquadBP = {
		{CCM_GetSquadBlueprint("ccm_german_spawner_squad"), spawner_spawn_ability},
		{CCM_GetSquadBlueprint("ccm_soviet_spawner_squad"), spawner_spawn_ability},
		{CCM_GetSquadBlueprint("ccm_west_german_spawner_squad"), spawner_spawn_ability},
		{CCM_GetSquadBlueprint("ccm_aef_spawner_squad"), spawner_spawn_ability},
		{CCM_GetSquadBlueprint("ccm_ukf_spawner_squad"), spawner_spawn_ability},
		
		{CCM_GetSquadBlueprint("ccm_german_misc_spawner_squad"), spawner_misc_spawn_ability},
		{CCM_GetSquadBlueprint("ccm_soviet_misc_spawner_squad"), spawner_misc_spawn_ability},
		{CCM_GetSquadBlueprint("ccm_west_german_misc_spawner_squad"), spawner_misc_spawn_ability},
		{CCM_GetSquadBlueprint("ccm_aef_misc_spawner_squad"), spawner_misc_spawn_ability},
		{CCM_GetSquadBlueprint("ccm_ukf_misc_spawner_squad"), spawner_misc_spawn_ability},
	}
	
	for key, spawner in ipairs(spawnerSquadBP) do
		if bp == spawner[1] then
			return spawner[2]
		end
	end
end

function Squad_GetSpawnAbilityPrefix(squad)
	local bp = Squad_GetBlueprint(squad)
	
	local spawnerSquadBP = {
		{CCM_GetSquadBlueprint("ccm_german_spawner_squad"), "spawner_german_"},
		{CCM_GetSquadBlueprint("ccm_soviet_spawner_squad"), "spawner_soviet_"},
		{CCM_GetSquadBlueprint("ccm_west_german_spawner_squad"), "spawner_west_german_"},
		{CCM_GetSquadBlueprint("ccm_aef_spawner_squad"), "spawner_aef_"},
		{CCM_GetSquadBlueprint("ccm_ukf_spawner_squad"), "spawner_ukf_"},
		
		{CCM_GetSquadBlueprint("ccm_german_misc_spawner_squad"), "misc_spawner_german_"},
		{CCM_GetSquadBlueprint("ccm_soviet_misc_spawner_squad"), "misc_spawner_soviet_"},
		{CCM_GetSquadBlueprint("ccm_west_german_misc_spawner_squad"), "misc_spawner_west_german_"},
		{CCM_GetSquadBlueprint("ccm_aef_misc_spawner_squad"), "misc_spawner_aef_"},
		{CCM_GetSquadBlueprint("ccm_ukf_misc_spawner_squad"), "misc_spawner_ukf_"},
		
	}
	
	for key, spawner in ipairs(spawnerSquadBP) do
		if bp == spawner[1] then
			return spawner[2]
		end
	end	
end

function CCM_SquadAbilityListener(caster, ability, target)
	local ability_table = Squad_GetSpawnerTable(caster)
	local raceIndex = Squad_GetSpawnerRaceIndex(caster)
	local spawnItemCount = CCM_CountSpawnTableItems(ability_table[raceIndex])
	CCM_Msg("triggered ability "..BP_GetName(ability))	local next_abilityIndex = 1
	local ability_found = false
	
	for key, item in ipairs(spawner_page_ability) do
		if ability == item.abp then
			if key < table.getn(spawner_page_ability) and spawnItemCount > ((key) * 10) then
				next_abilityIndex = key + 1
			else
				next_abilityIndex = 1
			end
			ability_found = true
			break
		end
	end
	
	if not ability_found then
		for key, item in ipairs(ability_table[raceIndex]) do
			if ability == item.ability then
				if isset(item.sbp) and item.sbp ~= "" then
					local sbp = ""
					if item.special then 
						sbp = CCM_GetSquadBlueprint(item.sbp)
					else
						sbp = BP_GetSquadBlueprint(item.sbp)
					end
					local owner = Squad_GetPlayerOwner(caster)
					local spawnPos = Util_GetPosition(target)
					local squad = Squad_CreateAndSpawnToward(sbp, owner, 0, spawnPos, spawnPos)
				elseif isset(item.slot_item) and item.slot_item ~= "" then
					local slotbp = BP_GetSlotItemBlueprint(item.slot_item)
					local spawnPos = Util_GetPosition(target)
					Misc_SpawnSlotItemOnGround(slotbp, spawnPos)
				elseif isset(item.ebp) and item.ebp ~= "" then
					local ebp = ""
					local spawnPos = Util_GetPosition(target)
					if item.special then
						ebp = CCM_GetEntityBlueprint(item.ebp)
					else
						ebp = BP_GetEntityBlueprint(item.ebp)
					end
					Entity_CreateAndSpawnTowardTeamWeapon(ebp, nil, spawnPos, spawnPos)
				elseif isset(item.abp) and item.abp ~= "" then
					
				end
			end
		end
		return false
	end
	
	for key, item in ipairs(spawner_page_ability) do
		Squad_RemoveAbility(caster, item.abp)
	end
	Squad_AddAbility(caster, spawner_page_ability[next_abilityIndex].abp)
	
	local ability_prefix = Squad_GetSpawnAbilityPrefix(caster)
	
	for i = 1, 40 do
		local index = i
		if i < 10 then
			index = "0"..i
		end
		local ability = CCM_GetAbilityBleprint(ability_prefix..index)
		Squad_RemoveAbility(caster, ability)
	end
	
	local spawn_abilityRange = spawner_page_ability[next_abilityIndex].abilityRange
	local rangeEnd = spawn_abilityRange[2]
	if rangeEnd > spawnItemCount then
		rangeEnd = spawnItemCount
	end
	for i = spawn_abilityRange[1], rangeEnd do
		local index = i
		if i < 10 then
			index = "0"..i
		end
		local ability = CCM_GetAbilityBleprint(ability_prefix..index)
		Squad_AddAbility(caster, ability)
	end
end

function CCM_CountSpawnTableItems(t)
	local count = 0
	for key, item in ipairs(t) do
		count = count + 1
		if item.sbp == "" or item.ebp == "" or item.abp == "" or item.slot_item == "" then
			count = count - 1
		end
	end
	
	return count
end

function _CCM_InitSpawnerSquad(squad)
	CCM_SquadAbilityListener(squad, CCM_GetAbilityBleprint("spawner_page_04"), nil)
end



function CCM_AutoHideAbilities()
	for key, user in pairs(g_last_action_executed) do
		CCM_Msg("expires in ".. (user.expires - World_GetGameTime()))
		if user.expires <= World_GetGameTime() and not user.expired then
			user.expired = true
			CCM_PlayerResetAbilities(user.player)
		end
		
	end
end





