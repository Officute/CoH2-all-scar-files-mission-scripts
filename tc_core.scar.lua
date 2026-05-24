import("ScarUtil.scar")
import("WinConditions/victorypointplusannihilate.scar")
import("WinConditions/tc_data.scar")
import("WinConditions/tc_data_ebps.scar")
--import("WinConditions/annihilate.scar")
--import("WinConditions/none.scar")
import("Fatalities/Fatalities.scar")

function TC_PreInit()
	--loadfile("scar/tc_core.scar")()
	TC_DataInit()
	TC_DataInit_Ebps()
	TC_Init()
end

Scar_AddInit(TC_PreInit)


-- TODO
--[[
	* Ikonit resource transfer, arrow
	* Ikonit capture/defend blip hintPointeille

--]]

function TC_Init()
	g_guid = "6164c7152d43474498653333f42d51a1";
	g_enable_messages = false
	g_text = ""

	colorUnPacker = {
		__call = function(t)
			return unpack(t)
		end
	}
	Colors = {
		white = {255, 255, 255, 255},
		ownerWhite = {80, 138, 192, 255},
		whiteSmall = {255, 255, 255, 255},
		red = {255, 255, 0, 155},
		ownerRed = {255, 0, 0, 255},
		yellow = {255, 255, 0, 255},
		arrowColorSelf = { 80, 140, 200, 0 },
		circleColorSelf = { 0, 42, 84, 0 },
		arrowColorAlly1 = { 255, 255, 0 , 128},
		arrowColorAlly2 = { 0, 255, 255 , 128},
		arrowColorAlly3 = { 41, 177, 18 , 128},
		transferPrepare = {255, 255, 255, 255},
		transferComplete = {255, 255, 0, 255},
		transferCancel = {255, 128, 0, 255},
		resourceDonation = {255, 255, 255, 255},
	}
	
	for key, _t in pairs(Colors) do
		setmetatable(_t, colorUnPacker)
	end


	g_mineMarkers = {}
	g_temporaryMineMarkers = {}
	g_SMineFieldCorners = {}
	g_SMineFieldMarkers = {}
	g_ability_minimap_blip_capture = TC_GetAbilityBlueprint("hidden_minimap_ping_capture")
	g_ability_minimap_blip_defend = TC_GetAbilityBlueprint("hidden_minimap_ping_defend")
	g_ability_toggle_category = TC_GetAbilityBlueprint("category_toggle")
	g_ability_donate_manpower = TC_GetAbilityBlueprint("donate_manpower")
	g_ability_donate_munition = TC_GetAbilityBlueprint("donate_munition")
	g_ability_donate_fuel = TC_GetAbilityBlueprint("donate_fuel")
	g_ability_donate_unit = TC_GetAbilityBlueprint("donate_unit")
	g_ability_set_arrow_origin = TC_GetAbilityBlueprint("arrow_set_origin")
	g_ability_set_arrow_heading = TC_GetAbilityBlueprint("arrow_set_heading")
	g_ability_toggle_arrow_visibility = TC_GetAbilityBlueprint("arrow_toggle_visibility")
	g_ability_toggle_circle_visibility = TC_GetAbilityBlueprint("circle_toggle_visibility")
	g_ability_set_circle_origin = TC_GetAbilityBlueprint("circe_set_origin")
	g_upgrade_tiger_ace_restriction = BP_GetUpgradeBlueprint("tiger_tank_ace_callin_restriction")
	g_sbp_tiger_ace = BP_GetSquadBlueprint("tiger_ace_squad_mp")
	g_mine = "mine"
	g_mine_icon = TC_GetIcon("icon_mine")
	g_smine_icon = TC_GetIcon("icon_smine")
	g_icon_cue_manpower = TC_GetIcon("icon_resource_donation_cue_manpower")
	g_icon_cue_fuel = TC_GetIcon("icon_resource_donation_cue_fuel")
	g_icon_cue_munition = TC_GetIcon("icon_resource_donation_cue_munition")
	g_icon_blip_capture_here = TC_GetIcon("icon_blip_capture_here")
	g_icon_blip_defend_here = TC_GetIcon("icon_blip_defend_here")
	g_icon_arrow = TC_GetIcon("icon_arrow_enabled")
	g_icon_map_circle = TC_GetIcon("icon_map_circle")
	
	CUE.MINE_PLANTED = {icon = TC_GetIcon("icon_mine_planted"), sound = "General_alert"}
	CUE.MINE_EXPLODED = {icon = TC_GetIcon("icon_mine_removed"), sound = "General_alert"}
	CUE.MANPOWER = {icon = g_icon_cue_manpower, sound = "General_alert"}
	CUE.FUEL = {icon = g_icon_cue_fuel, sound = "General_alert"}
	CUE.MUNITION = {icon = g_icon_cue_munition, sound = "General_alert"}
	CUE.UNIT_TRANSFER = {icon = g_icon_cue_munition, sound = "General_alert"}
	
	g_sound_queue = {}
	g_minimap_blip_sound = {
		defend_here = "ui\pings\defend_here",
		capture_here = "ui\pings\capture_here",
	}
	
	for key, sound in pairs(g_minimap_blip_sound) do
		Sound_PreCacheSound(sound)
	end
	Rule_AddGlobalEvent(System_EntityConstructionCompleted, GE_ConstructionComplete)
	Rule_AddGlobalEvent(System_EntityKilled, GE_EntityKilled)
	Rule_Add(TC_MineMarkerManager)
	


	
	g_active_category = {}
	g_ability_display_config = {
		{
			abilities = {g_ability_donate_manpower, g_ability_donate_munition, g_ability_donate_fuel, g_ability_donate_unit},
		},
		{
			abilities = {g_ability_set_arrow_origin, g_ability_set_arrow_heading, g_ability_toggle_arrow_visibility, g_ability_set_circle_origin, g_ability_toggle_circle_visibility},
		},
		{	
			abilities = {},
		},
	}
	
	g_local_player_arrow_colors = {}
	g_local_player_cirle_colors = {}
	
	local allyCounter = 0
	local local_player = Game_GetLocalPlayer()
	Players_ForEachInTeam(Player_GetTeam(local_player), function(pid, idx, player)
		local key = Player_GetUniqueKey(player)
		if Player_IsLocalPlayer(player) then
			g_local_player_arrow_colors[key] = Colors.arrowColorSelf
			g_local_player_cirle_colors[key] = Colors.circleColorSelf
		else
			
			allyCounter = allyCounter + 1
			Msg("indexing with " .. "arrowColorAlly" .. allyCounter)
			g_local_player_arrow_colors[key] = Colors["arrowColorAlly" .. allyCounter]
			g_local_player_cirle_colors[key] = Colors["arrowColorAlly" .. allyCounter]
		end
		
		--setmetatable(g_local_player_arrow_colors[key], colorUnPacker)
	end)
	
	Msg("g_local_player_arrow_colors: " .. table.getn(g_local_player_arrow_colors))
	
	g_player_arrow_template = {player = nil, origin = nil, heading = nil}
	g_player_arrows = {}
	g_player_circles = {}
	g_player_unit_transfer = {
	}
	g_minimap_blip_hintpoint = {}
	g_ability_resource_donation = {
		[BP_GetName(g_ability_donate_manpower)] = {resourceType = RT_Manpower, amount = 100, name = "Manpower", cue = CUE.MANPOWER},
		[BP_GetName(g_ability_donate_fuel)] = {resourceType = RT_Fuel, amount = 25, name = "Fuel", cue = CUE.FUEL},
		[BP_GetName(g_ability_donate_munition)] = {resourceType = RT_Munition, amount = 25, name = "Munitions", cue = CUE.MUNITION},
	}
	g_minimapBlipConfig = {
		[BP_GetName(g_ability_minimap_blip_capture)] = {blipType = BT_CaptureHere, hintType = HPAT_Hint, name = ":\nCapture this!", icon = g_icon_blip_capture_here, sound = g_minimap_blip_sound.capture_here},
		[BP_GetName(g_ability_minimap_blip_defend)] = {blipType = BT_DefendHere, hintType = HPAT_Bonus, name = ":\nDefend here!", icon = g_icon_blip_defend_here, sound = g_minimap_blip_sound.defend_here},
	}
	g_arrowAbilityConfig = {
		[BP_GetName(g_ability_set_arrow_origin)] = {},
		[BP_GetName(g_ability_set_arrow_heading)] = {},
		[BP_GetName(g_ability_toggle_arrow_visibility)] = {},	
	}
	for key, category in ipairs(g_ability_display_config) do
		for key2, ability in ipairs(category.abilities) do
			Players_ForEach(function(pid, idx, player)
				Player_AddAbility(player, ability)
				Player_SetAbilityAvailability(player, ability, ITEM_REMOVED)
			end)
		end
	end
	Players_ForEach(function(pid, idx, player)
		if g_200pop then
			Player_SetPopCapOverride(player, 200)
		end
		--Player_SetResource(player, RT_Munition, 1000000)
		Player_AddAbility(player, g_ability_toggle_category)
		Rule_AddPlayerEvent(System_PlayerAbilityExecuted, player, GE_AbilityExecuted)
		Rule_AddPlayerEvent(System_PlayerAbilityComplete, player, GE_AbilityComplete)
		TC_TogglePlayerCategory(player)
		g_player_arrows[Player_GetUniqueKey(player)] = {id = nil, origin = nil, heading = nil, visibility = true}
		g_player_circles[Player_GetUniqueKey(player)] = {id = nil, origin = nil, visibility = true}
	end)
	--Misc_ScreenFadeStart(g_mine_icon, 0.0, 1.0, 1)
	Rule_Add(TC_GeneralManager)
end

function TC_TogglePlayerCategory(player)
	local playerKey = Player_GetUniqueKey(player)
	if not g_active_category[playerKey] then
		g_active_category[playerKey] = 2
		TC_TogglePlayerCategory(player)
	else
		local _activeCategory = g_active_category[playerKey]
		for key, ability in ipairs(g_ability_display_config[_activeCategory].abilities) do
			Player_SetAbilityAvailability(player, ability, ITEM_REMOVED)
		end
		if _activeCategory == table.getn(g_ability_display_config) then
			_activeCategory = 1
		else
			_activeCategory = _activeCategory + 1
		end
		
		g_active_category[playerKey] = _activeCategory
		for key, ability in ipairs(g_ability_display_config[_activeCategory].abilities) do
			Player_SetAbilityAvailability(player, ability, ITEM_UNLOCKED)
		end		
	end
end

function System_PlayerAbilityComplete(caster, ability, target)
	local casterKey = Player_GetUniqueKey(caster)
	Msg(Player_GetName(caster) .. " completed ability " .. BP_GetName(ability))
	if ability == g_ability_toggle_arrow_visibility then
		TC_UpdatePlayerArrow(caster, nil, nil, not g_player_arrows[casterKey].visibility)
	elseif ability == g_ability_toggle_circle_visibility then
		TC_UpdatePlayerCircle(caster, nil, not g_player_circles[casterKey].visibility)
	end
end

function System_PlayerAbilityExecuted(caster, ability, target)
	local abilityBPName = BP_GetName(ability)
	local casterKey = Player_GetUniqueKey(caster)
	Msg("Called ability " .. abilityBPName)

	local resource_donation = g_ability_resource_donation[abilityBPName]
	local minimap_blip = g_minimapBlipConfig[abilityBPName]
	local arrowAbility = g_arrowAbilityConfig[abilityBPName]
	if ability == g_ability_toggle_category then
		TC_TogglePlayerCategory(caster)
		
	elseif ability == g_ability_donate_unit then
		local unitTransfer = g_player_unit_transfer[casterKey]
		if unitTransfer then
			if unitTransfer.entityId and Entity_IsValid(unitTransfer.entityId) and not World_OwnsEntity(target) then
				local newOwner = Entity_GetPlayerOwner(target)
				local entity = Entity_FromWorldID(unitTransfer.entityId)
				
				local cue = CUE.UNIT_TRANSFER
				local bpName = BP_GetName(Entity_GetBlueprint(entity))
				local name = bpName
				local _ebpData = {icon = "Icons_symbols_building_german_hq_symbol", name = bpName}
				if g_ebp_data[bpName] then
					_ebpData = g_ebp_data[bpName]
				end
				if _ebpData then
					cue.icon = _ebpData.icon
					name = _ebpData.name
				end
				local unitPos = Util_GetPosition(entity)
				
				if Player_GetID(caster) == Player_GetID(newOwner) then
					UI_CreateColouredPositionKickerMessage(caster, unitPos, Util_CreateLocString("Transfer cancelled!"), Colors.transferCancel())
				elseif Player_GetTeam(caster) == Player_GetTeam(newOwner) then
					UI_CreateColouredPositionKickerMessage(caster, unitPos, Util_CreateLocString("Transferred!"), Colors.transferComplete())
					EventCue_Create(cue, Util_CreateLocString(Player_GetName(caster) .. " transferred '" .. name .. "' to " .. Player_GetName(newOwner)), nil, unitPos)
					Entity_SetPlayerOwner(entity, newOwner)
				else
					UI_CreateColouredPositionKickerMessage(caster, Util_GetPosition(target), Util_CreateLocString("Invalid recipient!"), Colors.transferCancel())
				end
				g_player_unit_transfer[casterKey] = nil
			elseif unitTransfer.squadId and Squad_IsValid(unitTransfer.squadId) and not World_OwnsEntity(target) then
				local newOwner = Entity_GetPlayerOwner(target)
				local squad = Squad_FromWorldID(unitTransfer.squadId)
				
				local cue = CUE.UNIT_TRANSFER
				local bpName = BP_GetName(Squad_GetBlueprint(squad))
				local name = bpName
				local _sbpData = {icon = "Icons_symbols_building_soviet_force_recon_symbol", name = bpName}
				if g_sbps_data[bpName] then
					_sbpData = g_sbps_data[bpName]
				end
				if _sbpData then
					cue.icon = _sbpData.icon
					name = _sbpData.name
				end
				local unitPos = Util_GetPosition(squad)
				
				if Player_GetID(caster) == Player_GetID(newOwner) then
					UI_CreateColouredPositionKickerMessage(caster, unitPos, Util_CreateLocString("Transfer cancelled!"), Colors.transferCancel())
				elseif Player_GetTeam(caster) == Player_GetTeam(newOwner) then
					if Squad_GetBlueprint(squad) == g_sbp_tiger_ace then
						Player_RemoveUpgrade(caster, g_upgrade_tiger_ace_restriction)
						Player_CompleteUpgrade(newOwner, g_upgrade_tiger_ace_restriction)
					end
					UI_CreateColouredPositionKickerMessage(caster, unitPos, Util_CreateLocString("Transferred!"), Colors.transferComplete())
					EventCue_Create(cue, Util_CreateLocString(Player_GetName(caster) .. " transferred '" .. name .. "' to " .. Player_GetName(newOwner)), nil, unitPos)
					Squad_SetPlayerOwner(squad, newOwner)
				else
					UI_CreateColouredPositionKickerMessage(caster, Util_GetPosition(target), Util_CreateLocString("Invalid recipient!"), Colors.transferCancel())
				end
				g_player_unit_transfer[casterKey] = nil
			elseif (unitTransfer.squadId or unitTransfer.entityId) and World_OwnsEntity(target) then
				g_player_unit_transfer[casterKey] = nil
				UI_CreateColouredPositionKickerMessage(caster, Util_GetPosition(target), Util_CreateLocString("Tranfer cancelled!"), Colors.transferCancel())
			end
		else
			g_player_unit_transfer[casterKey] = {}
			unitTransfer = g_player_unit_transfer[casterKey]
			local _target = Entity_CheckForParentSquad(target)
			Msg("target = " .. scartype_tostring(_target))
			local transferAllowed = true
			local ebpName = BP_GetName(Entity_GetBlueprint(target))
			local _ebpData = {icon = "Icons_symbols_building_german_hq_symbol", name = ebpName}
			if g_ebp_data[ebpName] then
				_ebpData =  g_ebp_data[ebpName]
			end
			if _ebpData.is_basebuilding then
				transferAllowed = false
			end
			if scartype(_target) == ST_ENTITY and not World_OwnsEntity(_target) and Player_GetID(caster) == Player_GetID(Entity_GetPlayerOwner(_target)) and transferAllowed then
				unitTransfer.entityId = Entity_GetGameID(_target)
				UI_CreateColouredPositionKickerMessage(caster, Util_GetPosition(_target), Util_CreateLocString("Prepared for transfer!"), Colors.transferPrepare())
			elseif scartype(_target) == ST_SQUAD and not World_OwnsSquad(_target) and Player_GetID(caster) == Player_GetID(Squad_GetPlayerOwner(_target)) and transferAllowed then
				unitTransfer.squadId = Squad_GetGameID(_target)
				UI_CreateColouredPositionKickerMessage(caster, Util_GetPosition(_target), Util_CreateLocString("Prepared for transfer!"), Colors.transferPrepare())
			elseif World_OwnsUnit(_target) or Player_GetID(caster) ~= Player_GetID(Util_GetUnitOwner(_target)) then
				UI_CreateColouredPositionKickerMessage(caster, Util_GetPosition(_target), Util_CreateLocString("You don't own this target!"), Colors.transferCancel())
				g_player_unit_transfer[casterKey] = nil
			elseif not transferAllowed then
				UI_CreateColouredPositionKickerMessage(caster, Util_GetPosition(_target), Util_CreateLocString("Disabled for transfers!"), Colors.transferCancel())
				g_player_unit_transfer[casterKey] = nil
			end		
		end
	elseif resource_donation then
		if not World_OwnsEntity(target) then
			
			local receiver = Entity_GetPlayerOwner(target)
			if Player_GetResource(caster, resource_donation.resourceType) >= resource_donation.amount and Player_GetID(caster) ~= Player_GetID(receiver) then
				Player_SetResource(caster, resource_donation.resourceType, Player_GetResource(caster, resource_donation.resourceType) - resource_donation.amount)
				Player_AddResource(receiver, resource_donation.resourceType, resource_donation.amount)
				local casterName = Player_GetName(caster)
				local receiverName = Player_GetName(receiver)
				EventCue_Create(resource_donation.cue, Util_CreateLocString(casterName .. " transferred " .. resource_donation.amount .. " " .. resource_donation.name .. " to " .. receiverName), nil, Util_GetPosition(target))
				UI_CreateColouredPositionKickerMessage(caster, Util_GetPosition(target), Util_CreateLocString("Received + " .. resource_donation.amount .. " " .. resource_donation.name), 255, 255, 255, 255)
			end
		end
		
	elseif minimap_blip then
		Players_ForEachInTeam(Player_GetTeam(caster), function(pid, idx, player)
			if Player_IsLocalPlayer(player) then
				UI_CreateMinimapBlip(target, 5, minimap_blip.blipType)
				local new_hintPoint = {
					id = HintPoint_Add(target, true, Util_CreateLocString(Player_GetName(caster) .. minimap_blip.name), 0, minimap_blip.hintType, minimap_blip.icon),
					dead = World_GetGameTime() + 30
				}
				table.insert(g_minimap_blip_hintpoint, new_hintPoint)
				Msg("creating minimap blip")
				Sound_Play2D(minimap_blip.sound)
				for i = 1, 5 do
					table.insert(g_sound_queue, minimap_blip.sound)
				end
			end
		end)	
		
	elseif arrowAbility then
		if ability == g_ability_set_arrow_origin then
			TC_UpdatePlayerArrow(caster, target, nil, nil)
		elseif ability == g_ability_set_arrow_heading then
			TC_UpdatePlayerArrow(caster, nil, target, nil)
		elseif ability == g_ability_toggle_arrow_visibility then
			TC_UpdatePlayerArrow(caster, nil, nil, not g_player_arrows[casterKey].visibility)
		end
	elseif ability == g_ability_set_circle_origin then
		TC_UpdatePlayerCircle(caster, target, nil)
	elseif ability == g_ability_toggle_circle_visibility then
		TC_UpdatePlayerCircle(caster, nil, not g_player_circles[casterKey].visibility)
	end
end

function TC_UpdatePlayerCircle(player, origin, visibility)
	Players_ForEachInTeam(Player_GetTeam(player), function(pid, idx, _player)
		if Player_IsLocalPlayer(_player) then
			local playerKey = Player_GetUniqueKey(player)
			local playerCircle = g_player_circles[playerKey]
			if origin then
				playerCircle.origin = origin
			elseif visibility ~= nil then
				playerCircle.visibility = visibility
			end		
			if playerCircle.id then
				MapIcon_Destroy(playerCircle.id)
				playerCircle.id = nil
			end	
			if playerCircle.hintId then
				HintPoint_Remove(playerCircle.hintId)
			end
			if playerCircle.origin and playerCircle.visibility then
				playerCircle.id = MapIcon_CreatePosition(playerCircle.origin, g_icon_map_circle, 50, g_local_player_cirle_colors[playerKey]())
			end
		end
	end)
end

function TC_UpdatePlayerArrow(player, origin, heading, visibility)
	Players_ForEachInTeam(Player_GetTeam(player), function(pid, idx, _player)
		if Player_IsLocalPlayer(_player) then
			local playerKey = Player_GetUniqueKey(player)
			local playerArrow = g_player_arrows[playerKey]
			if origin then
				playerArrow.origin = origin
			elseif heading then
				playerArrow.heading = heading
			elseif visibility ~= nil then
				playerArrow.visibility = visibility
			end
			
			if playerArrow.id then
				MapIcon_Destroy(playerArrow.id)
				playerArrow.id = nil
			end	
			if playerArrow.hintId then
				HintPoint_Remove(playerArrow.hintId)
			end
			if playerArrow.origin and playerArrow.heading and playerArrow.visibility then
				playerArrow.hintId = HintPoint_Add(playerArrow.heading, true, Util_CreateLocString(Player_GetName(player) .. "'s Arrow"), 0, HPAT_Artillery, g_icon_arrow)
				playerArrow.id = MapIcon_CreateArrow(playerArrow.origin, playerArrow.heading, g_local_player_arrow_colors[playerKey]())
			end
		end
	end)
end

function TC_GeneralManager()
	for key, hintPoint in ipairs(g_minimap_blip_hintpoint) do
		if hintPoint.dead <= World_GetGameTime() then
			HintPoint_Remove(hintPoint.id)
			table.remove(g_minimap_blip_hintpoint, key)
		end
	end
end

function TC_GetAbilityBlueprint(blueprint)
	return BP_GetAbilityBlueprint(g_guid .. ":" .. blueprint)
end

function TC_GetMineIcon(name)
	Msg("Getting icon for " .. name)
	local mineIcons = {
		{name = "mine_field_mp", icon = g_smine_icon},
	}
	for key, value in ipairs(mineIcons) do
		if name == value.name then
			return value.icon
		end
	end
	return g_mine_icon
end

function TC_GetMineIconScale(name)
	local mineIcons = {
		{name = "mine_field_mp", scale = 10},
	}
	for key, value in ipairs(mineIcons) do
		if name == value.name then
			return value.scale
		end
	end
	return 12
end

function TC_MineIsAllowedToMark(name)
	local disallowedMines = {"mine_field_mine_mp", "mine_field_border_mp"}
	for key, value in ipairs(disallowedMines) do
		if name == value then
			return false
		end
	end
	return true
end

function TC_MineIsPartOfSMineField(name)
	local sMineFieldNames = {"mine_field_border_mp", "mine_field_mine_mp"}
	for key, value in ipairs(sMineFieldNames) do
		if name == value then
			return true
		end
	end
	return false
end

function TC_GetMineMarkerColor(planted, mineOwner, displayToPlayer)
	if Player_GetID(mineOwner) == Player_GetID(displayToPlayer) then
		if planted then
			return Colors.ownerWhite()
		else
			return Colors.ownerRed()
		end
	else
		if planted then
			return Colors.white()
		else
			return Colors.red()
		end
	end	
end

function TC_GetIcon(icon) 
	return "ModIcons_"..g_guid.."_"..icon
end

function TC_MineMarkerManager()
	for key, mineMarker in pairs(g_temporaryMineMarkers) do
		if mineMarker.removeWhen <= World_GetGameTime() then
			MapIcon_Destroy(mineMarker.markerId)
			g_temporaryMineMarkers[key] = nil
		end
	end
	
	for key, sMineCorner in pairs(g_SMineFieldCorners) do
		if not Entity_IsValid(sMineCorner.entityId) and not sMineCorner.scanned then
			sMineCorner.scanned = true
			--World_GetEntitiesNearPoint( Player* player, EGroup* egroup, ScarPosition pos, float radius, <a href="enum_list.htm#OwnerType">OwnerType</a> ownerType 
			local eg_tempMineHolder = EGroup_CreateIfNotFound("eg_tempMineHolder")
			EGroup_Clear(eg_tempMineHolder)
			World_GetEntitiesNearPoint(sMineCorner.owner, eg_tempMineHolder, sMineCorner.pos, 3, OT_Player)
			EGroup_Filter(eg_tempMineHolder, BP_GetEntityBlueprint("mine_field_mine_mp"), FILTER_KEEP)
			local count = 1
			EGroup_ForEach(eg_tempMineHolder, function(egid, idx, entity)
				Msg("Gathered entity [" .. Entity_GetGameID(entity) .. "] #" .. count.. " for SMine Corner #" .. key)
				count = count + 1
			end)
	
			local team = Player_GetTeam(sMineCorner.owner)
			Players_ForEachInTeam(team, function(pid, idx, player)
				if Player_IsLocalPlayer(player) and not EGroup_IsEmpty(eg_tempMineHolder) then
					TC_BlibMinePlanted(sMineCorner.pos, true, sMineCorner.owner, sMineCorner.ebpName)
					local sMineMarker = {
						entityIds = EGroup_GetEntityIds(eg_tempMineHolder),
						ebpName = sMineCorner.ebpName,
						owner = sMineCorner.owner,
						pos = sMineCorner.pos,
						markerId = MapIcon_CreatePosition(sMineCorner.pos, TC_GetMineIcon(sMineCorner.ebpName), TC_GetMineIconScale(sMineCorner.ebpName), TC_GetMineMarkerColor(true, sMineCorner.owner, player)),
					}
					
					table.insert(g_SMineFieldMarkers, sMineMarker)
				end
			end)
			g_SMineFieldCorners[key] = nil
		end
	end
	
	for key, sMineMarker in ipairs(g_SMineFieldMarkers) do
		if not EntityList_ContainsValidEntities(sMineMarker.entityIds) then
			local team = Player_GetTeam(sMineMarker.owner)
			Players_ForEachInTeam(team, function(pid, idx, player)
				if (Player_IsLocalPlayer(player)) then
					TC_BlibMinePlanted(sMineMarker.pos, false, sMineMarker.owner, sMineMarker.ebpName)
					MapIcon_Destroy(sMineMarker.markerId)
					g_temporaryMineMarkers["icon_" .. World_GetGameTime()] = {
						markerId = MapIcon_CreatePosition(sMineMarker.pos, TC_GetMineIcon(sMineMarker.ebpName), TC_GetMineIconScale(sMineMarker.ebpName), TC_GetMineMarkerColor(false, sMineMarker.owner, player)),
						removeWhen = World_GetGameTime() + 10,
					}
				end
			end)	
			table.remove(g_SMineFieldMarkers, key)
		end
	end
end

function TC_BlibMinePlanted(pos, planted, owner, ebpName)
	UI_CreateMinimapBlip(pos, 2, BT_General)
	local playerName = Player_GetName(owner)
	Msg("indexing mine blip with " .. ebpName)
	if planted then
		local mineName = ""
		local article = "a"
		local cue = CUE.MINE_PLANTED
		local mine_ebp_data = g_mine_ebps_data[ebpName]
		
		if mine_ebp_data then
			cue.icon = mine_ebp_data.icon
			mineName = mine_ebp_data.name
			article = mine_ebp_data.article
		end
		EventCue_Create(cue, Util_CreateLocString(playerName .. " planted " .. article .. " " .. mineName),  nil, pos)
	else
		local mineName = ""
		local article = "a"
		local cue = CUE.MINE_EXPLODED
		local mine_ebp_data = g_mine_ebps_data[ebpName]
		if mine_ebp_data then
			--cue.icon = mine_ebp_data.icon
			mineName = mine_ebp_data.name
			article = mine_ebp_data.article
		end
		EventCue_Create(cue, Util_CreateLocString(playerName .. "'s " .. mineName .. " exploded/has been defused"),  nil, pos)
	end
end

function System_EntityConstructionCompleted(caster, ebp)
	local ebpName = BP_GetName(ebp)
	World_ForEachEntities(function(entityId, idx, entity)
		local entityBPName = BP_GetName(Entity_GetBlueprint(entity))
		if string.find(entityBPName, g_mine) and Entity_GetBuildingProgress(entity) == 1.0 then
			local entityKey = Entity_GetUniqueKey(entity)
			local mineMarker = g_mineMarkers[entityKey]
			local team = Player_GetTeam(caster)
			Players_ForEachInTeam(team, function(pid, idx, player)
				if Player_IsLocalPlayer(player) and mineMarker == nil and not TC_MineIsPartOfSMineField(ebpName) then
					local sMineCorner = g_SMineFieldCorners[entityKey]
					local mineOwner = Entity_GetPlayerOwner(entity)
					local minePos = Entity_GetPosition(entity)
					if ebpName == "mine_field_mp" and not sMineCorner then
						g_SMineFieldCorners[entityKey] = {
							entityId = Entity_GetGameID(entity),
							pos = minePos,
							scanned = false,
							owner = mineOwner,
							ebpName = ebpName,
						}
					elseif ebpName ~= "mine_field_mp" and not mineMarker then
						Msg("Marking mine " .. ebpName)
						g_mineMarkers[entityKey] = {
							entityId = entityId,
							markerId = MapIcon_CreatePosition(minePos, TC_GetMineIcon(ebpName), TC_GetMineIconScale(ebpName), TC_GetMineMarkerColor(true, mineOwner, player))
						}											
						if pid ~= Player_GetID(caster) or true then
							TC_BlibMinePlanted(minePos, true, mineOwner, ebpName)
						end
					end
				end
			end)
		else
			
		end
	end)
end

function System_EntityKilled(entityTarget, entityCauser)
	local ebp = Entity_GetBlueprint(entityTarget)
	local ebpName = BP_GetName(ebp)
	local entityKey = Entity_GetUniqueKey(entityTarget)
	local mineMarker = g_mineMarkers[entityKey]
		
	if string.find(ebpName, g_mine) then
		if mineMarker then
			local owner = Entity_GetPlayerOwner(entityTarget)
			local team = Player_GetTeam(owner)	
			local minePos = Entity_GetPosition(entityTarget)
			Players_ForEachInTeam(team, function(pid, idx, player)
				if (Player_IsLocalPlayer(player)) then
					MapIcon_Destroy(mineMarker.markerId)
				end
			end)
			Players_ForEachInTeam(team, function(pid, idx, player)
				if (Player_IsLocalPlayer(player)) then
					TC_BlibMinePlanted(minePos, false, owner, ebpName)
					g_temporaryMineMarkers[entityKey] = {
						markerId = MapIcon_CreatePosition(minePos, TC_GetMineIcon(ebpName), TC_GetMineIconScale(ebpName), TC_GetMineMarkerColor(false, owner, player)),
						removeWhen = World_GetGameTime() + 10,
					}
				end
			end)	
		end
	end
end

function Player_IsLocalPlayer(player)
	local pid = Player_GetID(player)
	if pid == Game_GetLocalPlayerID() then
		return true
	end
	return false
end

function Player_GetUniqueKey(player)
	return "player_" .. Player_GetID(player) .. "_" .. Player_GetName(player)
end

function Player_GetName(player)
	return Player_GetDisplayName(player)[1]
end

function Players_ForEach(f)
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		local pid = Player_GetID(player)
		f(pid, i, player)
	end
end 

function Players_ForEachInTeam(team, f)
	Players_ForEach(function(pid, idx, player)
		if Player_GetTeam(player) == team then
			f(pid, idx, player)
		end
	end)
end

function Entity_GetPlayerOwnerSafe(entity)
	if World_OwnsEntity(entity) then 
		return "world"
	else
		return Entity_GetPlayerOwner(entity)
	end
end

function Entity_GetUniqueKey(entity)
	return "entity_" .. Entity_GetGameID(entity)
end

function Entity_CheckForParentSquad(target)
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

function EntityList_ContainsValidEntities(list)
	for key, entityId in ipairs(list) do
		if Entity_IsValid(entityId) then
			return true
		end
	end
	return false
end

function EGroup_GetEntityIds(egroup)
	local result = {}
	EGroup_ForEach(egroup, function(egid, idx, entity)
		table.insert(result, Entity_GetGameID(entity))
	end)
	return result
end

function Util_GlobalMessage(title, displaytime)
	Game_TextTitleFade(title, 0, displaytime, 2)
end

function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

function Util_GetBlueprint(item)
	if scartype(item) == ST_ENTITY then
		return Entity_GetBlueprint(item)
	elseif scartype(item) == ST_SQUAD then
		return Squad_GetBlueprint(item)
	else
		return nil
	end
end

function Util_GetUnitOwner(unit)
	if scartype(unit) == ST_ENTITY then
		return Entity_GetPlayerOwner(unit)
	elseif scartype(unit) == ST_SQUAD then
		return Squad_GetPlayerOwner(unit)
	end	
end

function Game_GetLocalPlayerID()
	return Player_GetID(Game_GetLocalPlayer())
end

function World_OwnsUnit(unit)
	if scartype(unit) == ST_ENTITY then
		return World_OwnsEntity(unit)
	elseif scartype(unit) == ST_SQUAD then
		return World_OwnsSquad(unit)
	end
end

function World_GetEntitiesByBlueprint(ebp)
	local result = {}
	if scartype(ebp) == ST_STRING then
		ebp = BP_GetEntityBlueprint(ebp)
	end
	for i = 0, World_GetNumEntities() -1 do
		local entity = World_GetEntity(i)
		if Entity_GetBlueprint(entity) == ebp then
			table.insert(result, entity)
		end
	end
	
	return result
end

function World_ForEachEntities(f)
	for i = 0, World_GetNumEntities() -1 do
		local entity = World_GetEntity(i)
		f(Entity_GetGameID(entity), i, entity)
	end
end

function Msg(text)
	if g_enable_messages then
		g_text = text.."\n"..g_text
		dr_clear("MSG")
		dr_setautoclear("MSG", 0)
		dr_text2d("MSG", 0.615, 0.025, g_text, 0, 255, 0)
	end
end

