----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Utility Functions
-- 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------


local FindMapEntryPosition = function(egroup)
	for i=1, EGroup_CountSpawned(egroup) do
		local entity = EGroup_GetSpawnedEntityAt(egroup, i)
		local blueprint = BP_GetName(Entity_GetBlueprint(entity))
		if (blueprint == "map_entry_point") then
			return Util_GetPosition(entity)
		end
	end
	return false
end

local GetPlayerMapEntry = function(player)
	local team = Player_GetTeam(player)
	for i=1, World_GetPlayerCount() do
		local iplayer = World_GetPlayerAt(i)
		if (Player_GetTeam(iplayer) == team) then
			local position = FindMapEntryPosition(Player_GetEntities(player))
			if (position) then
				return position
			end
		end
	end
end

local GetPlayerHQ = function(player)
	local egroup = Player_GetEntities(player)
	for i=1, EGroup_CountSpawned(egroup) do
		local entity = EGroup_GetSpawnedEntityAt(egroup, i)
		if (Entity_IsOfType(entity, "hq")) then
			return entity
		end
	end
end

local worldLength = (World_GetLength()/2)-1
local worldWidth = (World_GetWidth()/2)-1

local GetNearestMapEdge = function(pos)
	--avoid a possible divide by 0
	local x = pos.x
	local z = pos.z
	if (x == 0) then x = 1 end
	if (z == 0) then z = 1 end
	
	local xdistance = worldWidth/x
	local zdistance = worldLength/z
	
	if (math.abs(xdistance) < math.abs(zdistance)) then
		if (x > 0) then
			return World_Pos(worldWidth, pos.y, pos.z)
		else
			return World_Pos(-worldWidth, pos.y, pos.z)
		end
	else
		if (z > 0) then
			return World_Pos(pos.x, pos.y, worldLength)
		else
			return World_Pos(pos.x, pos.y, -worldLength)
		end
	end
end

local FilterOutEnemyEntities = function(entities, player)
	local team = Player_GetTeam(player)
	local enemyTeam = Team_GetEnemyTeam(team)
	for i=#entities, -1, 1 do
		if ((not World_OwnsEntity(entities[i])) and (Player_GetTeam(Util_GetPlayer(entities[i])) == enemyTeam)) then
			table.remove(entities, i)
		end
	end
	return entities
end

local GetTableOfPositionsOfThings = function(things)
	local positions = { }
	for k, v in pairs(things) do
		table.insert(positions, Util_GetPosition(v))
	end
	return positions
end


----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- AE Functions
-- These are strictly functions that are called through the Attribute Editor.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
----- Extra damage to ice, mostly for mission 3 -----
-----------------------------------------------------------------------------------
function AE_DamageIce_Stug(target, executer)
	if g_enableExtraIceDamage then
		if scartype(executer) == ST_ENTITY then
			g_iceWeakenTarget = Entity_GetPosition(executer)
			Rule_RemoveIfExist(_AE_DamageIce_Stug_delayed)
			Rule_AddOneShot(_AE_DamageIce_Stug_delayed, 1.5)
		end
	end
end	

_AE_DamageIce_Stug_delayed = function ()
	if scartype(g_iceWeakenTarget) == ST_SCARPOS then
		World_DamageIce(g_iceWeakenTarget, 3, 10, 250, 50)
	end
end

function AE_DamageIce_grenade(target, executer)
	if g_enableExtraIceDamage and scartype(executer) == ST_SCARPOS then
		World_DamageIce(executer, 1, 2, 250, 50)
	end
end	

function AE_DamageIce_atHighExplosive(target, executer)
	if g_enableExtraIceDamage and scartype(executer) == ST_SCARPOS then
		World_DamageIce(executer, 4, 6, 250, 50)
	end
end

function AE_DamageIce_mine(target, executer)
	if g_enableExtraIceDamage then
		if scartype(executer) == ST_ENTITY then
			g_iceWeakenTarget = Entity_GetPosition(executer)
			if scartype(g_iceWeakenTarget) == ST_SCARPOS then
				World_DamageIce(g_iceWeakenTarget, 2, 4, 250, 50)
			end
		end
	end
end	

_AE_DamageIce = function (target, executer)
	
	World_DamageIce(Util_GetPosition(executer), 2, 4, 250, 50)

end

_AE_DamageIce_small = function (target, executer)
	
	World_DamageIce(Util_GetOffsetPosition(executer, OFFSET_FRONT, 1), 1, 1, 250, 250)
	
end

-----------------------------------------------------------------------------------
-- The Transfer Orders ability cause team weapons to be abandoned. 
-----------------------------------------------------------------------------------
function AE_AbandonTeamWeapon(executer, target)
	
	if scartype(target) == ST_SQUAD then
		local tempGroup = SGroup_Create("")
		SGroup_Add(tempGroup, target)
		
		Cmd_AbandonTeamWeapon(tempGroup)
		
		SGroup_Destroy(tempGroup)
	elseif scartype(target) == ST_ENTITY then
		local abandonSquadID = Entity_GetSquad(target)
		
		if abandonSquadID ~= nil then
			
			local tempGroup = SGroup_Create("")
			SGroup_Add(tempGroup, abandonSquadID)
			
			Cmd_AbandonTeamWeapon(tempGroup)
			
			SGroup_Destroy(tempGroup)
		end
	end
end

-----------------------------------------------------------------------------------
-- Event Cue UI for artillery abilities.
-----------------------------------------------------------------------------------
function AE_ArtilleryEvent(executer, target)
	
	if scartype(Util_GetPlayerOwner(executer)) == ST_PLAYER and Util_GetPlayerOwner(executer) ~= Game_GetLocalPlayer() and target ~= nil then
		EventCue_Create(CUE.ATTACKED, 11050128, LOC(""), Util_GetPosition(target))
	end
	
end

function AE_AirstrikeEvent(executer, target)
	
	if scartype(Util_GetPlayerOwner(executer)) == ST_PLAYER and Util_GetPlayerOwner(executer) ~= Game_GetLocalPlayer() then
		EventCue_Create(CUE.ATTACKED, 11046747, LOC(""), Util_GetPosition(target))
	end
	
end

function AE_BarrageEvent(executer, target)

	
	if scartype(Util_GetPlayerOwner(executer)) == ST_PLAYER and Player_GetRelationship(Util_GetPlayerOwner(executer), Game_GetLocalPlayer()) == R_ALLY and Util_GetPlayerOwner(executer) ~= Game_GetLocalPlayer() then
		EventCue_Create(CUE.ATTACKED, 11046746, LOC(""), Util_GetPosition(target))
	end

end

function AE_RefaceEvent(executer, target)
	
	sg_tempHowitzerRefacing = SGroup_CreateIfNotFound("sg_tempHowitzerRefacing")
	SGroup_Add(sg_tempHowitzerRefacing, executer)
	local teamWeapon 
	for i = 0, (Squad_Count(executer) - 1) do 
		if Entity_IsSyncWeapon(Squad_EntityAt(executer, i)) then
			teamWeapon = Squad_EntityAt(executer, i)
		end
	end
	if teamWeapon ~= nil then
		Command_SquadMovePosFacing(Util_GetPlayerOwner(executer), sg_tempHowitzerRefacing, Util_GetPosition(teamWeapon), Util_GetPosition(target), false, false)
	end
	SGroup_Clear(sg_tempHowitzerRefacing)

end

function AE_BarrageWarning(executer, target)
	
	if scartype(Util_GetPlayerOwner(executer)) == ST_PLAYER  then
		if ((scartype(target) == ST_ENTITY and World_OwnsEntity(target) == false) or (scartype(target) == ST_SQUAD and World_OwnsSquad(target) == false)) then
			local playerOwner = Util_GetPlayerOwner(executer)
			
			if Util_GetRelationship(Util_GetPlayerOwner(executer), Util_GetPlayerOwner(target)) == R_ENEMY then
				
				if Game_GetLocalPlayer() == playerOwner then
					UIWarning_Show(11049207)
				end
				
			end
		end
	end
	
end

-----------------------------------------------------------------------------------
-- Kneel animation used for visual ability trigger.
-----------------------------------------------------------------------------------
function AE_SuggestKneel(executer, target)
	
	if scartype(target) == ST_ENTITY then
		Entity_SuggestPosture(target, 1, 5)
	elseif scartype(target) == ST_SQUAD then
		Squad_SuggestPosture(target, 1, 5)
	end

end

-----------------------------------------------------------------------------------
-- Spawns munitions and fuel barrels around the supply truck when it sets up.
-----------------------------------------------------------------------------------
function AE_SpawnSupplyTruckSandbags(executer, target)
	
	local truckOwner = Util_GetPlayerOwner(executer)
	
	local sandbagPos_1 = Util_GetPositionFromAtoB(Util_GetOffsetPosition(executer, OFFSET_BACK, 1.5), Util_GetOffsetPosition(executer, OFFSET_BACK_RIGHT, 2.5), 0.5)
	local sandbagPos_2 = Util_GetPositionFromAtoB(Util_GetOffsetPosition(executer, OFFSET_BACK, 1.5), Util_GetOffsetPosition(executer, OFFSET_BACK_LEFT, 2.5), 0.5)
	
	eg_supplyAccessory = EGroup_CreateIfNotFound("eg_supplyAccessory")
	
	Util_CreateEntities(truckOwner, eg_supplyAccessory, BP_GetEntityBlueprint("supply_truck_sandbag_pile_02"), AE_ReturnGroundPos(sandbagPos_1), 1)
	Util_CreateEntities(truckOwner, eg_supplyAccessory, BP_GetEntityBlueprint("supply_truck_sandbag_pile_02"), AE_ReturnGroundPos(sandbagPos_2), 1)
	EGroup_Clear(eg_supplyAccessory)
end

function AE_SpawnSupplyTruckAccessory_1(executer, target)
	
	local truckOwner = Util_GetPlayerOwner(executer)
	
	local spawnPos = Util_GetPositionFromAtoB(Util_GetOffsetPosition(executer, OFFSET_BACK, 4.5), Util_GetOffsetPosition(executer, OFFSET_BACK_RIGHT, 5.5), 0.5)
	local sandbagPos_1 = Util_GetPositionFromAtoB(Util_GetOffsetPosition(executer, OFFSET_BACK, 1.5), Util_GetOffsetPosition(executer, OFFSET_BACK_RIGHT, 2.5), 0.5)
	local sandbagPos_2 = Util_GetPositionFromAtoB(Util_GetOffsetPosition(executer, OFFSET_BACK, 1.5), Util_GetOffsetPosition(executer, OFFSET_BACK_LEFT, 2.5), 0.5)
	
	eg_supplyAccessory = EGroup_CreateIfNotFound("eg_supplyAccessory")
	
	Util_CreateEntities(truckOwner, eg_supplyAccessory, BP_GetEntityBlueprint("supply_truck_munitions_case_ax_01"), AE_ReturnGroundPos(spawnPos), 1, Util_GetOffsetPosition(executer, OFFSET_BACK, 4.5))
	Util_CreateEntities(truckOwner, eg_supplyAccessory, BP_GetEntityBlueprint("supply_truck_sandbag_pile_02"), AE_ReturnGroundPos(sandbagPos_1), 1)
	Util_CreateEntities(truckOwner, eg_supplyAccessory, BP_GetEntityBlueprint("supply_truck_sandbag_pile_02"), AE_ReturnGroundPos(sandbagPos_2), 1)
	EGroup_Clear(eg_supplyAccessory)
end

function AE_SpawnSupplyTruckAccessory_2(executer, target)
	
	local truckOwner = Util_GetPlayerOwner(executer)
	
	local spawnPos = Util_GetPositionFromAtoB(Util_GetOffsetPosition(executer, OFFSET_RIGHT, 2.5), Util_GetOffsetPosition(executer, OFFSET_BACK_RIGHT, 3.5), 0.5)
	
	eg_supplyAccessory = EGroup_CreateIfNotFound("eg_supplyAccessory")
	
	Util_CreateEntities(truckOwner, eg_supplyAccessory, BP_GetEntityBlueprint("supply_truck_munitions_case_ax_03"), AE_ReturnGroundPos(spawnPos), 1, Util_GetOffsetPosition(executer, OFFSET_BACK_RIGHT, 3.5))
	EGroup_Clear(eg_supplyAccessory)
end

function AE_SpawnSupplyTruckAccessory_3(executer, target)
	
	local truckOwner = Util_GetPlayerOwner(executer)
	
	eg_supplyAccessory = EGroup_CreateIfNotFound("eg_supplyAccessory")
	
	local spawnPos = Util_GetPositionFromAtoB(Util_GetOffsetPosition(executer, OFFSET_LEFT, 3), Util_GetOffsetPosition(executer, OFFSET_BACK_LEFT, 4), 0.5)
	
	Util_CreateEntities(truckOwner, eg_supplyAccessory, BP_GetEntityBlueprint("supply_truck_metal_m_01"), AE_ReturnGroundPos(spawnPos), 1, Util_GetOffsetPosition(executer, OFFSET_BACK_LEFT, 4))
	EGroup_Clear(eg_supplyAccessory)
end

function AE_SpawnSupplyTruckAccessory_4(executer, target)
	
	local truckOwner = Util_GetPlayerOwner(executer)
	
	eg_supplyAccessory = EGroup_CreateIfNotFound("eg_supplyAccessory")
	
	local spawnPos = Util_GetPositionFromAtoB(Util_GetOffsetPosition(executer, OFFSET_BACK, 3), Util_GetOffsetPosition(executer, OFFSET_BACK_LEFT, 6), 0.5)
	
	Util_CreateEntities(truckOwner, eg_supplyAccessory, BP_GetEntityBlueprint("supply_truck_metal_m_02"), AE_ReturnGroundPos(spawnPos), 1, Util_GetOffsetPosition(executer, OFFSET_BACK_RIGHT, 10))
	EGroup_Clear(eg_supplyAccessory)
end

-----------------------------------------------------------------------------------
-- Shock Troop Fire superiority approach target ability
-----------------------------------------------------------------------------------
function AE_ShockApproachTarget(executer, target)
	
	if scartype(executer) == ST_SQUAD then
		sg_shockAttackTarget = SGroup_CreateIfNotFound("sg_shockAttackTarget")
		SGroup_Add(sg_shockAttackTarget, executer)
		
		Cmd_Move(sg_shockAttackTarget, Util_GetPositionFromAtoB(Util_GetPosition(executer), Util_GetPosition(target), 0.7), false) 
		
		SGroup_Clear(sg_shockAttackTarget)
	end

end

-----------------------------------------------------------------------------------
-- Spawns defensive structures around the pak-43 when constructed
-----------------------------------------------------------------------------------
function AE_SpawnPak43Defenses(executer, target)
	
	local ownerPlayer = Util_GetPlayerOwner(executer)
	local gunPosition = Util_GetPosition(executer)
	local t_directions = {OFFSET_BACK, OFFSET_FRONT}
	local t_sidePositions = {OFFSET_LEFT, OFFSET_RIGHT}
	eg_pak43DefensesTempSpawn = EGroup_CreateIfNotFound("eg_pak43DefensesTempSpawn")
	sg_constructionGroup = SGroup_CreateIfNotFound("sg_constructionGroup")
	
	-- Creates an invisible squad to construct the sandbags
	Util_CreateSquads(ownerPlayer, sg_constructionGroup, BP_GetSquadBlueprint("hack_invisi_pioneer_squad_mp"), gunPosition)
	
	-- Constructs the sandbag position immediately in front of the Pak-43 gun
	Cmd_Construct(sg_constructionGroup, BP_GetEntityBlueprint("antitank_88mm_pak43_sandbags"), Util_GetOffsetPosition(executer, OFFSET_FRONT, 6.3),  gunPosition, false)

	-- Constructs the sandbag to the rear of the gun
	Cmd_Construct(sg_constructionGroup, BP_GetEntityBlueprint("antitank_88mm_pak43_sandbags"), Util_GetOffsetPosition(executer, OFFSET_BACK, 7.5),  gunPosition, false)

	-- Constructs the right sandbags
	local midPoint = Util_GetPositionFromAtoB(Util_GetOffsetPosition(executer, OFFSET_RIGHT, 9), Util_GetOffsetPosition(executer, OFFSET_FRONT, 7.5), 0.32)
	Command_PlayerSquadConstructBuilding(ownerPlayer, sg_constructionGroup, BP_GetEntityBlueprint("antitank_88mm_pak43_sandbags"), midPoint, Util_GetOffsetPosition(executer, OFFSET_BACK, 1), false)  
	
	-- Constructs the left sandbags
	local midPoint = Util_GetPositionFromAtoB(Util_GetOffsetPosition(executer, OFFSET_LEFT, 9.8), Util_GetOffsetPosition(executer, OFFSET_FRONT, 7.5), 0.35)
	Command_PlayerSquadConstructBuilding(ownerPlayer, sg_constructionGroup, BP_GetEntityBlueprint("antitank_88mm_pak43_sandbags"), midPoint, Util_GetOffsetPosition(executer, OFFSET_BACK, 1), false)  
	
	SGroup_DestroyAllSquads(sg_constructionGroup)
	SGroup_Clear(sg_constructionGroup)
	
	EGroup_Clear(eg_pak43DefensesTempSpawn)
	
end

-----------------------------------------------------------------------------------
-- Selects the building that unit unlocks(commander abilities) are deployed from.
-----------------------------------------------------------------------------------
function AE_PassiveAbilityMortarHalftrack(executer, target)

	_passiveAbiltySelect(executer, target,"dolch_aktionen", "mortar_250_halftrack_squad", 11048222)

end

function AE_PassiveAbilityTiger(executer, target)

	_passiveAbiltySelect(executer, target,"schweres_kriegswerk", "tiger_squad", 11048224)

end

function AE_PassiveAbilityElefant(executer, target)

	_passiveAbiltySelect(executer, target,"schweres_kriegswerk", "elefant_tank_destroyer_squad", 11048224)
	
end

function AE_PassiveAbilityPanzerCommand(executer, target)

	_passiveAbiltySelect(executer, target,"hintere_panzerwerk", "panzer_iv_command_squad", 11048305)

end

function AE_PassiveAbility120mmMortar(executer, target)

	_passiveAbiltySelect(executer, target,"weapon_support_center", "hm-120_38_mortar_squad", 11048225)

end

function AE_PassiveAbilityGuard(executer, target)

	_passiveAbiltySelect(executer, target,"barracks", "guards_troops", 11048226)

end

function AE_PassiveAbilityShock(executer, target)

	_passiveAbiltySelect(executer, target,"barracks", "shock_troops", 11048226)

end

function AE_PassiveAbilityIS2(executer, target)

	_passiveAbiltySelect(executer, target,"motorpool", "is-2", 11048227)

end

function AE_PassiveAbilityKV8(executer, target)

	_passiveAbiltySelect(executer, target,"motorpool", "kv-8", 11048227)

end

function AE_PassiveAbilityT3485(executer, target)

	_passiveAbiltySelect(executer, target,"motorpool", "t_34_85_squad", 11048227)

end

function AE_PassiveAbilityISU152(executer, target)

	_passiveAbiltySelect(executer, target,"tank_depot", "isu-152", 11048228)

end

function AE_PassiveAbilityKatyusha(executer, target)

	_passiveAbiltySelect(executer, target, "tank_depot", "katyusha_bm-13n_squad", 11048228)	
	
end

-- Initializing the variable for the passive unit flash ID
local g_passiveBbilityFlashID = nil
-- When a passive unit replacement or unit unlock ability is pressed the associated building is selected and the unit is flashed.
function _passiveAbiltySelect(executerID, targetID, buildingBP, squadBP, warningLOC)

	local playerOwner = Util_GetPlayerOwner(executerID)
	local buildingID = Player_GetBuildingID(playerOwner, {BP_GetEntityBlueprint(buildingBP),}, true) 

	if buildingID ~= nil then
		
		Misc_SelectEntity(buildingID)
		
		if g_passiveBbilityFlashID ~= nil then
			UI_StopFlashing(g_passiveBbilityFlashID)
		end
		g_passiveBbilityFlashID = UI_FlashProductionButton(PITEM_Spawn, BP_GetSquadBlueprint(squadBP), true)
			
		if Rule_Exists(_removeUnitFlash) then
			Rule_Remove(_removeUnitFlash)
			Rule_AddOneShot(_removeUnitFlash, 1)
		else
			Rule_AddOneShot(_removeUnitFlash, 1)
		end

	else
		if Game_GetLocalPlayer() == playerOwner then
			-- Displays a warning message if the required building is not present.
			UIWarning_Show(warningLOC)
		end
	end	
	
end

function _removeUnitFlash()
	
	UI_StopFlashing(g_passiveBbilityFlashID)
	g_passiveBbilityFlashID = nil
	
end

-----------------------------------------------------------------------------------
-- Protoype Functions
-----------------------------------------------------------------------------------
function AE_SpawnInHold(target, executer)

	local tempHoldGroup = SGroup_CreateIfNotFound("tempHoldGroup")
	SGroup_Clear(tempHoldGroup)
	SGroup_Add(tempHoldGroup, executer)

	Util_CreateSquads(Game_GetLocalPlayer(), SGroup_Create(""), BP_GetSquadBlueprint("assault_pioneer_squad_mp"), tempHoldGroup)

end

function AE_SpawnTrenchMines(executer, target)
	local radius = 10
	local numTrenchMines = 6
	local minebp = BP_GetEntityBlueprint("german_mine")
	local pos = Util_GetPosition(executer)
	local player = Util_GetPlayerOwner(executer)
	local offsetTable = { Entity_GetOffsetPosition(executer, OFFSET_FRONT, 15), Entity_GetOffsetPosition(executer, OFFSET_BACK, 15), Entity_GetOffsetPosition(executer, OFFSET_RIGHT, 20), Entity_GetOffsetPosition(executer, OFFSET_LEFT, 20) }
	
	local mineGroup = EGroup_Create("")
	for k, v in pairs(offsetTable) do 
		for i=1, numTrenchMines do
			local entity = Entity_Create(BP_GetEntityBlueprint("mine_field_mine"), player, AE_ReturnGroundPos(Prox_GetRandomPosition(v, radius, i)), pos)
			Entity_ForceConstruct(entity)
			Entity_Spawn(entity)
			EGroup_Add(mineGroup, entity)
		end
	end

end

function AE_SpawnTrenchWire(executer, target)
	local radius = 10
	local numTrenchwire = 1
	local wirebp = BP_GetEntityBlueprint("barbed_wire_fence_mp")
	local pos = Util_GetPosition(executer)
	local player = Util_GetPlayerOwner(executer)
	local offsetTable = { 
		Entity_GetOffsetPosition(executer, OFFSET_FRONT, 15), 
		Entity_GetOffsetPosition(executer, OFFSET_BACK, 15), 
		Entity_GetOffsetPosition(executer, OFFSET_FRONT_LEFT, 15), 
		Entity_GetOffsetPosition(executer, OFFSET_FRONT_RIGHT, 15), 
		Entity_GetOffsetPosition(executer, OFFSET_BACK_RIGHT, 15), 
		Entity_GetOffsetPosition(executer, OFFSET_BACK_LEFT, 15), 
		Entity_GetOffsetPosition(executer, OFFSET_RIGHT, 15), 
		Entity_GetOffsetPosition(executer, OFFSET_LEFT, 15), 
		
		Util_GetPositionFromAtoB(Entity_GetOffsetPosition(executer, OFFSET_FRONT, 12), Entity_GetOffsetPosition(executer, OFFSET_FRONT_RIGHT, 12), 0.5), 
		Util_GetPositionFromAtoB(Entity_GetOffsetPosition(executer, OFFSET_RIGHT, 12), Entity_GetOffsetPosition(executer, OFFSET_FRONT_RIGHT, 12), 0.5), 
		Util_GetPositionFromAtoB(Entity_GetOffsetPosition(executer, OFFSET_BACK_RIGHT, 12), Entity_GetOffsetPosition(executer, OFFSET_BACK, 12), 0.5), 
		Util_GetPositionFromAtoB(Entity_GetOffsetPosition(executer, OFFSET_BACK, 12), Entity_GetOffsetPosition(executer, OFFSET_BACK_LEFT, 12), 0.5), 
		Util_GetPositionFromAtoB(Entity_GetOffsetPosition(executer, OFFSET_BACK_LEFT, 12), Entity_GetOffsetPosition(executer, OFFSET_LEFT, 12), 0.5), 
		Util_GetPositionFromAtoB(Entity_GetOffsetPosition(executer, OFFSET_LEFT, 12), Entity_GetOffsetPosition(executer, OFFSET_FRONT_LEFT, 12), 0.5), 
		Util_GetPositionFromAtoB(Entity_GetOffsetPosition(executer, OFFSET_FRONT_LEFT, 12), Entity_GetOffsetPosition(executer, OFFSET_FRONT, 12), 0.5), 
		Util_GetPositionFromAtoB(Entity_GetOffsetPosition(executer, OFFSET_RIGHT, 12), Entity_GetOffsetPosition(executer, OFFSET_BACK_RIGHT, 12), 0.5), 
	}
	local offsetSpawn = {OFFSET_BACK }
	
	local wireGroup = EGroup_Create("")
	for k, v in pairs(offsetTable) do 
		for a, b in pairs(offsetSpawn) do
			local entity = Entity_Create(wirebp, player, AE_ReturnGroundPos(Util_GetOffsetPosition(v, b, 1)), pos)
			
			Entity_ForceConstruct(entity)
			Entity_Spawn(entity)
			EGroup_Add(wireGroup, entity)
		end
	end

end

----------------------------------------
-- Order 227
----------------------------------------
__g_Order227_CommissarTargetTable = nil
__g_Order227_MAX_COMMISSARS_PER_TARGET = 1

function AE_DoOrder227_RegisterExecuter(executer, _target)
	if (World_OwnsEntity(executer)) then
		error("AE_DoOrder227_RegisterExecuter failed - world owns executer!")
		return
	end

	local ex_player = Entity_GetPlayerOwner(executer)
	local ex_player_id = Player_GetID(ex_player)

	if __g_Order227_CommissarTargetTable == nil then
		__g_Order227_CommissarTargetTable = {}
	end
	
	if __g_Order227_CommissarTargetTable[ex_player_id] == nil then
		__g_Order227_CommissarTargetTable[ex_player_id] = 
		{
			ex_player = ex_player,
			egroup_executers = EGroup_Create("eg_order227_execs"..ex_player_id),
			executer_idx = 0
		}
	end

	EGroup_Add(__g_Order227_CommissarTargetTable[ex_player_id].egroup_executers, executer)
end

function AE_DoOrder227_Target(executer, target)
	
	if (World_OwnsEntity(executer)) then
		error("AE_DoOrder227 Failed - world owns executer!")
		return
	end

	local ability_bp = ABILITY.GLOBAL.COMMISSAR_SHOT_227
	local ex_player = Entity_GetPlayerOwner(executer)
	local ex_player_id = Player_GetID(ex_player)

	if __g_Order227_CommissarTargetTable == nil or __g_Order227_CommissarTargetTable[ex_player_id] == nil then
		return
	end
	
	local eg_ex_count = EGroup_CountSpawned(__g_Order227_CommissarTargetTable[ex_player_id].egroup_executers)
	if eg_ex_count < 1 then
		return
	end
	
	local ex_group = EGroup_Create("")
	
	for x = 1, __g_Order227_MAX_COMMISSARS_PER_TARGET do
		__g_Order227_CommissarTargetTable[ex_player_id].executer_idx = __g_Order227_CommissarTargetTable[ex_player_id].executer_idx + 1
		if (__g_Order227_CommissarTargetTable[ex_player_id].executer_idx > eg_ex_count) then
			__g_Order227_CommissarTargetTable[ex_player_id].executer_idx = 1
		end
		
		EGroup_Add(ex_group, EGroup_GetSpawnedEntityAt(__g_Order227_CommissarTargetTable[ex_player_id].egroup_executers, 
														__g_Order227_CommissarTargetTable[ex_player_id].executer_idx))
	end
	
	Command_EntityTargetEntityAbility(ex_player, ex_group, target, ability_bp, true, true)
	
	EGroup_Destroy(ex_group)
end	

----------------------------------------


function AE_ReturnGroundPos(position)
	
	return Util_ScarPos(position.x, position.z, nil)
	
end

function AE_AEFBaseSpawn(target, executer)
	local mapCentre = World_Pos(0, 0, 0)
	
	local weaponPoolPos = Util_GetPositionFromAtoB(Util_GetPosition(executer), mapCentre, 20)
	local midPos = Util_GetPositionFromAtoB(weaponPoolPos, Util_GetPosition(executer), 0.5)
	
	local _eg_weaponsPool = EGroup_CreateIfNotFound("_eg_weaponsPool")
	EGroup_Clear(_eg_weaponsPool)
	
	Util_CreateEntities(Util_GetPlayerOwner(executer), _eg_weaponsPool, BP_GetEntityBlueprint("company_weapons_pool_mp"), weaponPoolPos, 1, mapCentre)
	
	local offLeft = Util_GetOffsetPosition(_eg_weaponsPool, OFFSET_LEFT, 12)
	local offRight = Util_GetOffsetPosition(_eg_weaponsPool, OFFSET_RIGHT, 12)
	
	local posleft_x = offLeft.x - (weaponPoolPos.x - midPos.x)
	local posleft_z = offLeft.z - (weaponPoolPos.z - midPos.z)
	local armoredRiflePos = World_Pos(posleft_x, weaponPoolPos.y, posleft_z)
	
	local posRight_x = offRight.x - (weaponPoolPos.x - midPos.x)
	local posRight_z = offRight.z - (weaponPoolPos.z - midPos.z)
	local armorCommandPos = World_Pos(posRight_x, weaponPoolPos.y, posRight_z)
	
	Util_CreateEntities(Util_GetPlayerOwner(executer), nil, BP_GetEntityBlueprint("armored_rifle_command_mp"), armoredRiflePos, 1)
	Util_CreateEntities(Util_GetPlayerOwner(executer), nil, BP_GetEntityBlueprint("armor_command_mp"), armorCommandPos, 1)
	
end

--Adds AEF base buildings into an egroup on spawn. Used by XP1 persistent mode.
function AE_AEFBaseGroup(target, executer)
	local _eg_playerBase = EGroup_CreateIfNotFound("eg_playerBase_" .. Player_GetID(Util_GetPlayerOwner(executer)))
	EGroup_Add(_eg_playerBase, executer)
end

function AE_AEFHQReplace_v2(executer, target)

	local spawnPosition = AE_ReturnGroundPos(Util_GetPosition(target))
	local techReplacePlayerOwner = Util_GetPlayerOwner(target)
	
	local buildingList = {
		BP_GetEntityBlueprint("company_weapons_pool_mp"),
		BP_GetEntityBlueprint("armored_rifle_command_mp"),
		BP_GetEntityBlueprint("armor_command_mp")
	}
	
	local playerBuildings = Player_GetEntitiesFromType(techReplacePlayerOwner, "building")
	
	EGroup_Filter(playerBuildings, buildingList, FILTER_KEEP)
	
	EGroup_DestroyAllEntities(playerBuildings)
	
	EGroup_Clear(playerBuildings)
	
	local mapCentre = World_Pos(0, 0, 0)
	
	local weaponPoolPos = Util_GetPositionFromAtoB(spawnPosition, mapCentre, 15)
	
	local _eg_weaponsPool = EGroup_CreateIfNotFound("_eg_weaponsPool")
	EGroup_Clear(_eg_weaponsPool)
	
	Util_CreateEntities(techReplacePlayerOwner, _eg_weaponsPool, BP_GetEntityBlueprint("company_weapons_pool_v2_mp"), weaponPoolPos, 1, mapCentre)
	
	local armoredRiflePos = Util_GetOffsetPosition(_eg_weaponsPool, OFFSET_BACK_LEFT, 12)
	local armorCommandPos = Util_GetOffsetPosition(_eg_weaponsPool, OFFSET_BACK_RIGHT, 12)
	
	Util_CreateEntities(techReplacePlayerOwner, EGroup_Create(""), BP_GetEntityBlueprint("armored_rifle_command_v2_mp"), armoredRiflePos, 1)
	Util_CreateEntities(techReplacePlayerOwner, EGroup_Create(""), BP_GetEntityBlueprint("armor_command_v2_mp"), armorCommandPos, 1)
	
	Entity_Destroy(target)
	
	Util_CreateEntities(techReplacePlayerOwner, EGroup_Create(""), BP_GetEntityBlueprint("rifle_command_v2_mp"), spawnPosition, 1)

end

function AE_AEFBaseSpawn_v2(executer, target)

	local buildingList = {
		BP_GetEntityBlueprint("company_weapons_pool_mp"),
		BP_GetEntityBlueprint("armored_rifle_command_mp"),
		BP_GetEntityBlueprint("armor_command_mp")
	}
	
	local playerBuildings = Player_GetEntitiesFromType(Util_GetPlayerOwner(executer), "building")
	
	EGroup_Filter(playerBuildings, buildingList, FILTER_KEEP)
	
	EGroup_DestroyAllEntities(playerBuildings)
	
	EGroup_Clear(playerBuildings)
	
	
	local mapCentre = World_Pos(0, 0, 0)
	
	local weaponPoolPos = Util_GetPositionFromAtoB(Util_GetPosition(executer), mapCentre, 15)
	
	local _eg_weaponsPool = EGroup_CreateIfNotFound("_eg_weaponsPool")
	EGroup_Clear(_eg_weaponsPool)
	
	Util_CreateEntities(Util_GetPlayerOwner(executer), _eg_weaponsPool, BP_GetEntityBlueprint("company_weapons_pool_v2_mp"), weaponPoolPos, 1, mapCentre)
	
	local armoredRiflePos = Util_GetOffsetPosition(_eg_weaponsPool, OFFSET_BACK_LEFT, 12)
	local armorCommandPos = Util_GetOffsetPosition(_eg_weaponsPool, OFFSET_BACK_RIGHT, 12)
	
	Util_CreateEntities(Util_GetPlayerOwner(executer), EGroup_Create(""), BP_GetEntityBlueprint("armored_rifle_command_v2_mp"), armoredRiflePos, 1)
	Util_CreateEntities(Util_GetPlayerOwner(executer), EGroup_Create(""), BP_GetEntityBlueprint("armor_command_v2_mp"), armorCommandPos, 1)

end


function AE_ConstructHelper(executer, target, blueprintName)

	local ownerPlayer = Util_GetPlayerOwner(executer)
	local targetPosition = Util_GetPosition(executer)
	eg_infBarracks = EGroup_CreateIfNotFound("eg_infBarracks")
	sg_constructionGroup = SGroup_CreateIfNotFound("sg_constructionGroup")

	-- Creates an invisible squad to construct the sandbags
	Util_CreateSquads(ownerPlayer, sg_constructionGroup, BP_GetSquadBlueprint("hack_invisi_pioneer_squad_mp"), targetPosition)
	
	-- Check if the Player can build the structure at the specified position.
	if Player_CanConstructOnPosition(ownerPlayer, sg_constructionGroup, BP_GetEntityBlueprint(blueprintName), targetPosition) == true then
		Squad_StopAbility(Entity_GetSquad(executer), BP_GetAbilityBlueprint("support_truck_lockdown"), true)

		Squad_DeSpawn(Entity_GetSquad(executer))
		Squad_Kill(Entity_GetSquad(executer))
		
		-- Constructs the sandbag position immediately in front of the Pak-43 gun
		Cmd_Construct(sg_constructionGroup, BP_GetEntityBlueprint(blueprintName), targetPosition)
	end
	
	-- Clean up temporary data
	SGroup_DestroyAllSquads(sg_constructionGroup)
	SGroup_Clear(sg_constructionGroup)
	
	EGroup_Clear(eg_infBarracks)	
	
end


function AE_ConstructInfantryBarracks(executer, target)
	
	local blueprintToConstruct = "infantry_support_mp"
	AE_ConstructHelper(executer, target, blueprintToConstruct)
	
end

function AE_ConstructLightArmorSupport(executer, target)
	
	local blueprintToConstruct = "light_armor_support_mp"
	AE_ConstructHelper(executer, target, blueprintToConstruct)
	
end

function AE_ConstructHeavyArmorSupport(executer, target)

	local blueprintToConstruct = "heavy_armor_support_mp"
	AE_ConstructHelper(executer, target, blueprintToConstruct)
	
end

-----------------------------------------------------------------------------------
-- Battle Plan Prototype
-----------------------------------------------------------------------------------

function AE_KingTigerArmorBlitz(executer, target)

	Entity_StopAbility(executer, BP_GetAbilityBlueprint("tiger_prowl_mp"), true)
	Entity_StopAbility(executer, BP_GetAbilityBlueprint("spearhead_mp"), true)
	
	AE_ArmorBlitzAddUnit(executer)

end

function AE_KingTigerTigerProwl(executer, target)

	Entity_StopAbility(executer, BP_GetAbilityBlueprint("armor_blitz_mp"), true)
	Entity_StopAbility(executer, BP_GetAbilityBlueprint("spearhead_mp"), true)

end


function AE_KingTigerSpearhead(executer, target)

	Entity_StopAbility(executer, BP_GetAbilityBlueprint("armor_blitz_mp"), true)
	Entity_StopAbility(executer, BP_GetAbilityBlueprint("tiger_prowl_mp"), true)

end


function AE_ArmorBlitzAddUnit(newSquad)
	
	local addSquad
	
	if _t_armorBlitz == nil then
		_t_armorBlitz = {}
	end
	
	if scartype(newSquad) == ST_ENTITY then
		addSquad = Entity_GetSquad(newSquad)
	else
		addSquad = newSquad
	end
	
	local _addSquadTable = {
		squadID = addSquad,
		sgroupID = SGroup_Create(""),
		attackerSgroup = SGroup_Create(""),
		facingTimer = World_GetRand(217, 12329878),
	}
	
	SGroup_Add(_addSquadTable.sgroupID, addSquad)
	
	table.insert(_t_armorBlitz, _addSquadTable)
	
	if Rule_Exists(AE_ArmorBlitzManager) == false then
		Rule_AddInterval(AE_ArmorBlitzManager, 3)
	end
	
end

function AE_ArmorBlitzManager()
	
	if table.getn(_t_armorBlitz) == 0 then
		Rule_RemoveMe()
	end
	
	for k,v in pairs(_t_armorBlitz) do 
		
		if SGroup_IsAlive(v.sgroupID) == false or Squad_HasSlotItem(v.squadID, BP_GetSlotItemBlueprint("armor_blitz_item")) == false then 
			table.remove(_t_armorBlitz, k)
		elseif Timer_GetRemaining(v.facingTimer) <= 0 and Squad_IsMoving(v.squadID) == false and Squad_IsUnderAttack(v.squadID, 5) then
			local attacker = Squad_GetLastAttacker(v.squadID, v.attackerSgroup)
			if SGroup_IsEmpty(v.attackerSgroup) == false then
				Squad_FacePosition(v.squadID, Util_GetPosition(v.attackerSgroup))
				
				Timer_Start(v.facingTimer, 15)
			end
		end
		
	end
	
end

function AE_InfDefMove(executer, target)

	AE_DefMoveAddUnit(executer)
	
	Squad_StopAbility(executer, BP_GetAbilityBlueprint("stalker_state_mp"), true)
	Squad_StopAbility(executer, BP_GetAbilityBlueprint("assault_move_mp"), true)
	Squad_StopAbility(executer, BP_GetAbilityBlueprint("suppressive_fire_mp"), true)
	Squad_StopAbility(executer, BP_GetAbilityBlueprint("fortify_position_mp"), true)

end

function AE_StalkState(executer, target)

	Squad_StopAbility(executer, BP_GetAbilityBlueprint("assault_move_mp"), true)
	Squad_StopAbility(executer, BP_GetAbilityBlueprint("suppressive_fire_mp"), true)
	Squad_StopAbility(executer, BP_GetAbilityBlueprint("fortify_position_mp"), true)
	Squad_StopAbility(executer, BP_GetAbilityBlueprint("defensive_move_mp"), true)

end

function AE_InfAssaultMove(executer, target)
	
	Squad_StopAbility(executer, BP_GetAbilityBlueprint("stalker_state_mp"), true)
	Squad_StopAbility(executer, BP_GetAbilityBlueprint("defensive_move_mp"), true)
	Squad_StopAbility(executer, BP_GetAbilityBlueprint("suppressive_fire_mp"), true)
	Squad_StopAbility(executer, BP_GetAbilityBlueprint("fortify_position_mp"), true)

end

function AE_InfSuppressiveFire(executer, target)

	Squad_StopAbility(executer, BP_GetAbilityBlueprint("defensive_move_mp"), true)
	Squad_StopAbility(executer, BP_GetAbilityBlueprint("assault_move_mp"), true)
	Squad_StopAbility(executer, BP_GetAbilityBlueprint("fortify_position_mp"), true)

end

function AE_InfFortifyPos(executer, target)

	Squad_StopAbility(executer, BP_GetAbilityBlueprint("defensive_move_mp"), true)
	Squad_StopAbility(executer, BP_GetAbilityBlueprint("assault_move_mp"), true)
	Squad_StopAbility(executer, BP_GetAbilityBlueprint("suppressive_fire_mp"), true)

end

function AE_DefMoveAddUnit(newSquad)
	
	local addSquad
	
	if _t_defMove == nil then
		_t_defMove = {}
	end
	
	if scartype(newSquad) == ST_ENTITY then
		addSquad = Entity_GetSquad(newSquad)
	else
		addSquad = newSquad
	end
		
	local _addSquadTable = {
		squadID = addSquad,
		sgroupID = SGroup_Create(""),
		attackerSgroup = SGroup_Create(""),
		facingTimer = World_GetRand(217, 12329878),
	}
	
	SGroup_Add(_addSquadTable.sgroupID, newSquad)
	
	table.insert(_t_defMove, _addSquadTable)
	
	if Rule_Exists(AE_DefMoveManager) == false then
		Rule_AddInterval(AE_DefMoveManager, 3)
	end
	
end

function AE_DefMoveManager()
	
	if table.getn(_t_defMove) == 0 then
		Rule_RemoveMe()
	end
	
	for k,v in pairs(_t_defMove) do 
		
		if SGroup_IsAlive(v.sgroupID) == false or Squad_HasSlotItem(v.squadID, BP_GetSlotItemBlueprint("def_move_item")) == false then 
			table.remove(_t_defMove, k)
		elseif Timer_GetRemaining(v.facingTimer) <= 0 and Squad_IsMoving(v.squadID) == false and Squad_IsUnderAttack(v.squadID, 5) then
			local attacker = Squad_GetLastAttacker(v.squadID, v.attackerSgroup)
			if SGroup_IsEmpty(v.attackerSgroup) == false and Util_GetDistance(v.sgroupID, v.attackerSgroup) < 25 then
				Cmd_MoveAwayFromPos(v.sgroupID, Util_GetPosition(v.attackerSgroup), 25)
				Squad_FacePosition(v.squadID, Util_GetPosition(v.attackerSgroup))
				Timer_Start(v.facingTimer, 15)
			end
		end
		
	end
	
end

-----------------------------------------------------------------------------------
-- Officer Garrison Prototype
-----------------------------------------------------------------------------------

function AE_OfficerGarrisonBarracks(executer, target)
	
	local playerOwner = Util_GetPlayerOwner(executer)
	local getAllTemp = SGroup_CreateIfNotFound("getAllTemp")
	local buildingGroup = EGroup_CreateIfNotFound("buildingGroup")
	local officerSgroup = SGroup_CreateIfNotFound("officerSgroup")
	SGroup_Add(officerSgroup, executer)
	
	Player_GetAll(playerOwner, getAllTemp, buildingGroup)
	EGroup_Filter(buildingGroup, BP_GetEntityBlueprint("rifle_command_mp"), FILTER_KEEP)
	
	if Squad_IsInHoldEntity(executer) then
		Cmd_UngarrisonSquad(officerSgroup)
		Cmd_Garrison(officerSgroup, buildingGroup, nil, true) 
	else
		Cmd_Garrison(officerSgroup, buildingGroup) 
	end
	
	EGroup_Clear(buildingGroup)
	SGroup_Clear(officerSgroup)
	SGroup_Clear(getAllTemp)

end

function AE_OfficerGarrisonRecon(executer, target)
	
	local playerOwner = Util_GetPlayerOwner(executer)
	local getAllTemp = SGroup_CreateIfNotFound("getAllTemp")
	local buildingGroup = EGroup_CreateIfNotFound("buildingGroup")
	local officerSgroup = SGroup_CreateIfNotFound("officerSgroup")
	SGroup_Add(officerSgroup, executer)
	
	Player_GetAll(playerOwner, getAllTemp, buildingGroup)
	EGroup_Filter(buildingGroup, BP_GetEntityBlueprint("armored_rifle_command_mp"), FILTER_KEEP)
	
	if Squad_IsInHoldEntity(executer) then
		Cmd_UngarrisonSquad(officerSgroup)
		Cmd_Garrison(officerSgroup, buildingGroup, nil, true) 
	else
		Cmd_Garrison(officerSgroup, buildingGroup) 
	end
	
	EGroup_Clear(buildingGroup)
	SGroup_Clear(officerSgroup)
	SGroup_Clear(getAllTemp)

end

function AE_OfficerGarrisonWeaponPool(executer, target)
	
	local playerOwner = Util_GetPlayerOwner(executer)
	local getAllTemp = SGroup_CreateIfNotFound("getAllTemp")
	local buildingGroup = EGroup_CreateIfNotFound("buildingGroup")
	local officerSgroup = SGroup_CreateIfNotFound("officerSgroup")
	SGroup_Add(officerSgroup, executer)
	
	Player_GetAll(playerOwner, getAllTemp, buildingGroup)
	EGroup_Filter(buildingGroup, BP_GetEntityBlueprint("company_weapons_pool_mp"), FILTER_KEEP)
	
	if Squad_IsInHoldEntity(executer) then
		Cmd_UngarrisonSquad(officerSgroup)
		Cmd_Garrison(officerSgroup, buildingGroup, nil, true) 
	else
		Cmd_Garrison(officerSgroup, buildingGroup) 
	end
	
	EGroup_Clear(buildingGroup)
	SGroup_Clear(officerSgroup)
	SGroup_Clear(getAllTemp)

end

function AE_OfficerGarrisonTankDepot(executer, target)
	
	local playerOwner = Util_GetPlayerOwner(executer)
	local getAllTemp = SGroup_CreateIfNotFound("getAllTemp")
	local buildingGroup = EGroup_CreateIfNotFound("buildingGroup")
	local officerSgroup = SGroup_CreateIfNotFound("officerSgroup")
	SGroup_Add(officerSgroup, executer)
	
	Player_GetAll(playerOwner, getAllTemp, buildingGroup)
	EGroup_Filter(buildingGroup, BP_GetEntityBlueprint("armor_command_mp"), FILTER_KEEP)
	
	if Squad_IsInHoldEntity(executer) then
		Cmd_UngarrisonSquad(officerSgroup)
		Cmd_Garrison(officerSgroup, buildingGroup, nil, true) 
	else
		Cmd_Garrison(officerSgroup, buildingGroup) 
	end
	
	EGroup_Clear(buildingGroup)
	SGroup_Clear(officerSgroup)
	SGroup_Clear(getAllTemp)

end

-----------------------------------------------------------------------------------
-- Officer Dispatch Garrison 
-----------------------------------------------------------------------------------

function AE_GarrisonTarget(executer, target)
	
	if scartype(target) == ST_ENTITY then
		
		local playerGroup = Player_GetSquads(Util_GetPlayerOwner(executer))
		local newSquad = SGroup_GetSpawnedSquadAt(playerGroup, SGroup_Count(playerGroup))
		local __garrisonGroup = SGroup_CreateIfNotFound("__garrisonGroup")
		SGroup_Add(__garrisonGroup, newSquad)
		
		local __garrisonTarget = EGroup_CreateIfNotFound("__garrisonTarget")
		EGroup_Add(__garrisonTarget, target)
		
		Cmd_Garrison(__garrisonGroup, __garrisonTarget) 
		
		SGroup_Clear(__garrisonGroup)
		
	end

end

-----------------------------------------------------------------------------------
-- West German Dispatch Setup
-----------------------------------------------------------------------------------

function AE_HalftrackDispatchSetup(executer, target)
	
	local __halftrackGroup = SGroup_CreateIfNotFound("__halftrackGroup")
	SGroup_Add(__halftrackGroup, executer)

	Cmd_Ability(__halftrackGroup, BP_GetAbilityBlueprint("support_truck_lockdown"), nil, nil, nil, true)
	
	SGroup_Clear(__halftrackGroup)

end

-----------------------------------------------------------------------------------
-- AEF Officer smoke support ability
-----------------------------------------------------------------------------------


function AE_OfficerSmokeSupport(executer, target)
	
	local __smokeGroups = SGroup_CreateIfNotFound("__smokeGroups")
	
	World_GetSquadsNearPoint(Util_GetPlayerOwner(executer), __smokeGroups, Util_GetPosition(target), 25, OT_Ally)
	
	for i = 1, SGroup_Count(__smokeGroups) do 
		
		local _tmpSmkGrp = SGroup_CreateIfNotFound("_tmpSmkGrp")
		SGroup_Add(_tmpSmkGrp, SGroup_GetSpawnedSquadAt(__smokeGroups, i))
		
		local smokeTarget = Util_GetRandomPosition(target, 15)
		
		if SGroup_CanCastAbilityOnPosition(_tmpSmkGrp, BP_GetAbilityBlueprint("officer_smoke_grenade_mp"), smokeTarget, ANY) then  
			Cmd_Ability(_tmpSmkGrp, BP_GetAbilityBlueprint("officer_smoke_grenade_mp"), smokeTarget, nil, true)
		end
		
		SGroup_Clear(_tmpSmkGrp)
	end
	
	SGroup_Clear(__smokeGroups)
	
end


function AE_DispatchLieutenant(executer, target)

	Cmd_Ability(Util_GetPlayerOwner(target), BP_GetAbilityBlueprint("lieutenant_dispatch"), Util_GetPosition(target), nil, true)
	

end

function AE_SpawnActiveLight(executer, target)

	local eg_lightGroup = EGroup_CreateIfNotFound("eg_lightGroup")
	
	Util_CreateEntities(nil, eg_lightGroup, BP_GetEntityBlueprint("temp_active_structure_searchlight"), Util_GetOffsetPosition(target, OFFSET_BACK, 6), 1, Util_GetPosition(target))
	Util_CreateEntities(nil, eg_lightGroup, BP_GetEntityBlueprint("temp_active_structure_searchlight"), Util_GetOffsetPosition(target, OFFSET_FRONT, 6), 1, Util_GetPosition(target))
	
	EGroup_SetAnimatorState(eg_lightGroup, "light", "on")
	EGroup_SetAnimatorState(eg_lightGroup, "light_state", "on")
	
	EGroup_SetAnimatorVariable(eg_lightGroup, "hinge", -0.060)
	
	EGroup_Clear(eg_lightGroup)

end

-----------------------------------------------------------------------------------
-- AEF Rear Echelon Attrition Dispatch Ability
-----------------------------------------------------------------------------------

function AE_RearEchAddDeadInf(executer, target)

	if _t_rearEchAttrit ~= nil then
		for k,v in pairs(_t_rearEchAttrit) do 
			if Util_GetPlayerOwner(executer) == v.player then
				v.infDead = v.infDead + 1
			end
		end
	end

end

function AE_RearEchAddDeadVeh(executer, target)
	
	if _t_rearEchAttrit ~= nil then
		for k,v in pairs(_t_rearEchAttrit) do 
			if Util_GetPlayerOwner(executer) == v.player then
				v.vehDead = v.vehDead + 1
			end
		end	
	end

end

function AE_RearEchelonAttritionInit(executer, target)
	
--~ 	if _t_rearEchAttrit == nil then
--~ 		_t_rearEchAttrit = {}
--~ 		_RearEchelonAttritionPopulate()
--~ 	end

end

function _RearEchelonAttritionInit()
	
	if _t_rearEchAttrit == nil then
		_t_rearEchAttrit = {}
	end
	
	local playerCount = World_GetPlayerCount()
	
	local aefPlayer = false
	
	for i = 1, playerCount do 
		if Player_GetRaceName(World_GetPlayerAt(i)) == "aef" then
			aefPlayer = true
		end
	end
	
	
	if aefPlayer then
		__t_rearEchWarnings = {
			LOC("Emergency forces are being dispatched to the front."),
			LOC("Loses are too high, Rear Echelon are being deployed."),
			LOC("Rear Echelon are available for use.")
		}
		
		for i = 1, playerCount do 
			
			local playerOwner = Util_GetPlayerOwner(World_GetPlayerAt(i))
			local playerBuildings = Player_GetEntitiesFromType(playerOwner, "building")
			
			if __randSpawnTimer == nil then
				__randSpawnTimer = 1232349
			else
				__randSpawnTimer = __randSpawnTimer + 1
			end
			
			EGroup_Filter(playerBuildings, BP_GetEntityBlueprint("rifle_command_mp"), FILTER_KEEP)
			
			if _t_rearEchAttrit == nil then
				_t_rearEchAttrit = {}
			end
			
			_t_rearEchAttrit[i] = {
				player = playerOwner,
				vehDead = 0,
				infDead = 0,
				vehValueMulti = 3,
				spawnTresholdMin = 6,
				spawnTresholdMax = 9,
				spawnTreshold = 8,
				runCount = 0,
				spwnTimer = __randSpawnTimer, 
				spawnCooldown = 60,
				spawnInit = false,
				aef = false,
				spawnSgroup = SGroup_CreateIfNotFound("sg_rearEch"..__randSpawnTimer),
				spawnMax = 5,
			}
			
			if EGroup_IsEmpty(playerBuildings) == false then
				_t_rearEchAttrit[i].aef = true
				_t_rearEchAttrit[i].playerHQPos = Util_GetOffsetPosition(playerBuildings, OFFSET_RIGHT, 5)
				_t_rearEchAttrit[i].playerHQ = playerBuildings
			else
				_t_rearEchAttrit[i].aef = false
				_t_rearEchAttrit[i].playerHQPos = World_Pos(0, 0, 0)
				_t_rearEchAttrit[i].playerHQ = nil
			end
			
		end
		
		if Rule_Exists(__rearEchelonAttrition) == false then
			Rule_AddDelayedInterval(__rearEchelonAttrition, 2, 1)
		end
	end
end

--~ Scar_AddInit(_RearEchelonAttritionInit)

function __rearEchelonAttrition()

	for k,v in pairs(_t_rearEchAttrit) do 
		if v.aef == true then
			if v.spawnInit == false then
				v.spawnInit = true
				Timer_Start(v.spwnTimer, 10)
			elseif SGroup_Count(v.spawnSgroup) < v.spawnMax and Timer_GetRemaining(v.spwnTimer) <= 0 and v.infDead + (v.vehDead*v.vehValueMulti) >= v.spawnTreshold then
				local warnMsg = Table_GetRandomItem(__t_rearEchWarnings)
				if Game_GetLocalPlayer() == v.player then
					UIWarning_Show(warnMsg)
				end
				Cmd_Ability(v.player, BP_GetAbilityBlueprint("rear_echelon_dispatch"), v.playerHQPos, nil, false, false)
				v.infDead = 0
				v.vehDead = 0
				v.spawnTresholdMin = v.spawnTresholdMin + 2
				v.spawnTresholdMax = v.spawnTresholdMax + 3
				v.spawnTreshold = World_GetRand(v.spawnTresholdMin, v.spawnTresholdMax)
				v.runCount = 0
				Timer_Start(v.spwnTimer, v.spawnCooldown)
			elseif v.runCount >= 120 then
				v.runCount = 0
				if v.spawnTresholdMin > 6 then
					v.spawnTresholdMin = v.spawnTresholdMin - 1
				end
				if v.spawnTresholdMax > 9 then
					v.spawnTresholdMax = v.spawnTresholdMax - 1
				end 
			else
				v.runCount = v.runCount + 1
				if v.runCount%100 == 0 then
					if v.infDead > 0 then
						v.infDead = v.infDead - 1
					end
					if v.vehDead > 0 then
						v.vehDead = v.vehDead - 1
					end
				end
			end
		end
	end
	
end

function AE_RearEchelonSpawnEnable(bool)
	
	if bool == false then
		if Rule_Exists(__rearEchelonAttrition) then
			Rule_Remove(__rearEchelonAttrition)
			_t_rearEchAttrit = nil
		end
	elseif bool then
		if Rule_Exists(__rearEchelonAttrition) == false then
			_RearEchelonAttritionInit()
		end
	end

end

function AE_RearEchelonSpawn(executer, target)

	local tempHoldGroup = SGroup_CreateIfNotFound("tempHoldGroup")
	SGroup_Clear(tempHoldGroup)
	SGroup_Add(tempHoldGroup, executer)
	
	for k,v in pairs(_t_rearEchAttrit) do 
		if v.player == Util_GetPlayerOwner(executer) then
			Util_CreateSquads(Util_GetPlayerOwner(executer), v.spawnSgroup, BP_GetSquadBlueprint("rear_echelon_squad_mp"), tempHoldGroup)
		end
	end

end

function AE_ShermanSpawnBarrier(executer, target)
	
	local shermanGroup = SGroup_CreateIfNotFound("shermanGroup")
	
	SGroup_Add(shermanGroup, Entity_GetSquad(executer))
	
	Cmd_Move(shermanGroup, Util_GetOffsetPosition(executer, OFFSET_BACK, 4))
	
	Util_CreateEntities(nil, EGroup_Create(""),  BP_GetEntityBlueprint("sherman_barrier_mp"), Util_GetOffsetPosition(executer, OFFSET_FRONT, 9), 1, Util_GetOffsetPosition(executer, OFFSET_FRONT, 25))
	
	SGroup_Clear(shermanGroup)
	
end

function AE_ShermanBarrierDeform(executer, target)
	
	local shermanGroup = SGroup_CreateIfNotFound("shermanGroup")
	
	SGroup_Add(shermanGroup, Entity_GetSquad(executer))
	
	Util_CreateEntities(nil, EGroup_Create(""),  BP_GetEntityBlueprint("sherman_barrier_deform_mp"), Util_GetOffsetPosition(executer, OFFSET_FRONT, 6.5), 1, Util_GetOffsetPosition(executer, OFFSET_FRONT, 25))
	
	SGroup_Clear(shermanGroup)
	
end

function AE_SpawnBaseFlak(executer, target)

	local spawnPos = Util_GetOffsetPosition(executer, OFFSET_FRONT, 10)
	local _eg_baseFlak = EGroup_CreateIfNotFound("_eg_baseFlak")
	
	Util_CreateEntities(nil, _eg_baseFlak, BP_GetEntityBlueprint("base_flak_gun_mp"), AE_ReturnGroundPos(spawnPos), 1)
	Util_CreateEntities(nil, EGroup_Create(""), BP_GetEntityBlueprint("base_flak_sandbags"), AE_ReturnGroundPos(Util_GetOffsetPosition(_eg_baseFlak, OFFSET_RIGHT, 4)), 1, AE_ReturnGroundPos(Util_GetOffsetPosition(_eg_baseFlak, OFFSET_LEFT, 6)))
	Util_CreateEntities(nil, EGroup_Create(""), BP_GetEntityBlueprint("base_flak_sandbags"), AE_ReturnGroundPos(Util_GetOffsetPosition(_eg_baseFlak, OFFSET_LEFT, 4)), 1, AE_ReturnGroundPos(Util_GetOffsetPosition(_eg_baseFlak, OFFSET_RIGHT, 6)))
	
	EGroup_Clear(_eg_baseFlak)
end

function AE_RepairCriticals(executer, target)
	
	if Entity_HasCritical(target, BP_GetCriticalBlueprint("vehicle_damage_engine")) then
		Entity_RemoveCritical(target, BP_GetCriticalBlueprint("vehicle_damage_engine"))
	end
	if Entity_HasCritical(target, BP_GetCriticalBlueprint("vehicle_damage_engine_rear")) then
		Entity_RemoveCritical(target, BP_GetCriticalBlueprint("vehicle_damage_engine_rear"))
	end
	if Entity_HasCritical(target, BP_GetCriticalBlueprint("vehicle_damage_engine_rear_ramming")) then
		Entity_RemoveCritical(target, BP_GetCriticalBlueprint("vehicle_damage_engine_rear_ramming"))
	end
	if Entity_HasCritical(target, BP_GetCriticalBlueprint("vehicle_destroy_engine")) then
		Entity_RemoveCritical(target, BP_GetCriticalBlueprint("vehicle_destroy_engine"))
	end
	if Entity_HasCritical(target, BP_GetCriticalBlueprint("vehicle_destroy_engine_rear")) then
		Entity_RemoveCritical(target, BP_GetCriticalBlueprint("vehicle_destroy_engine_rear"))
	end
	if Entity_HasCritical(target, BP_GetCriticalBlueprint("vehicle_destroy_maingun")) then
		Entity_RemoveCritical(target, BP_GetCriticalBlueprint("vehicle_destroy_maingun"))
	end
	if Entity_HasCritical(target, BP_GetCriticalBlueprint("vehicle_destroy_maingun_ramming")) then
		Entity_RemoveCritical(target, BP_GetCriticalBlueprint("vehicle_destroy_maingun_ramming"))
	end
	if Entity_HasCritical(target, BP_GetCriticalBlueprint("vehicle_exhaust_damaged")) then
		Entity_RemoveCritical(target, BP_GetCriticalBlueprint("vehicle_exhaust_damaged"))
	end
	if Entity_HasCritical(target, BP_GetCriticalBlueprint("vehicle_light_damage_engine")) then
		Entity_RemoveCritical(target, BP_GetCriticalBlueprint("vehicle_light_damage_engine"))
	end
	if Entity_HasCritical(target, BP_GetCriticalBlueprint("vehicle_lose_treads_or_wheels")) then
		Entity_RemoveCritical(target, BP_GetCriticalBlueprint("vehicle_lose_treads_or_wheels"))
	end
	if Entity_HasCritical(target, BP_GetCriticalBlueprint("vehicle_kill_top_gunner_hardpoint_1")) then
		Entity_RemoveCritical(target, BP_GetCriticalBlueprint("vehicle_kill_top_gunner_hardpoint_1"))
	end
	if Entity_HasCritical(target, BP_GetCriticalBlueprint("vehicle_kill_top_gunner_hardpoint_2")) then
		Entity_RemoveCritical(target, BP_GetCriticalBlueprint("vehicle_kill_top_gunner_hardpoint_2"))
	end
	if Entity_HasCritical(target, BP_GetCriticalBlueprint("vehicle_kill_top_gunner_hardpoint_4")) then
		Entity_RemoveCritical(target, BP_GetCriticalBlueprint("vehicle_kill_top_gunner_hardpoint_4"))
	end

end

function AE_OfficerOnMe(executer, target)

	local targetGroup = SGroup_CreateIfNotFound("targetGroup")
	
	if scartype(target) == ST_SQUAD then
		
		SGroup_Add(targetGroup, target)
		
		if SGroup_IsDoingAbility(targetGroup, BP_GetAbilityBlueprint("cover_specialization_hunker_down"), ANY) then
			Cmd_Ability(targetGroup, BP_GetAbilityBlueprint("cover_specialization_hunker_down"))
		end
		
		Cmd_Move(targetGroup, Util_GetPosition(executer))
		
	end
	
	SGroup_Clear(targetGroup)

end

function AE_AmbushAtk(executer, target)

	local ambushTargetGroup = SGroup_CreateIfNotFound("ambushTargetGroup")
	local ambushAttacker = SGroup_CreateIfNotFound("ambushAttacker")

	SGroup_Clear(ambushAttacker)
	SGroup_Clear(ambushTargetGroup)
	
	if scartype(target) == ST_ENTITY then
		SGroup_Add(ambushTargetGroup, Entity_GetSquad(target))
	else
		SGroup_Add(ambushTargetGroup, target)
	end
	SGroup_Add(ambushAttacker, executer)
	
	Cmd_Attack(ambushAttacker, ambushTargetGroup) 
	Cmd_Move(ambushAttacker, Util_GetPositionFromAtoB(Util_GetPosition(ambushAttacker), Util_GetPosition(ambushTargetGroup), 0.5))
	
	Squad_StopAbility(executer, BP_GetAbilityBlueprint("pathfinder_ambush_mp"), false)

end


--~ function AE_SpawnStartingSWS(executer, target)
--~ 	
--~ 	Cmd_Ability(Util_GetPlayerOwner(executer), BP_GetAbilityBlueprint("sws_halftrack_dispatch"), Util_GetOffsetPosition(executer, OFFSET_RIGHT, 12), nil, true)
--~ 	
--~ end

function AE_ParaLandingMove(executer, target)
	
	local moveGroup = SGroup_CreateIfNotFound("moveGroup")
	
	SGroup_Clear(moveGroup)
	
	if scartype(executer) == ST_SQUAD then
		SGroup_Add(moveGroup, executer)  
	elseif scartype(executer) == ST_ENTITY then
		SGroup_Add(moveGroup, Entity_GetSquad(executer))
	end
	
	Cmd_Move(moveGroup, Util_GetOffsetPosition(moveGroup, OFFSET_RIGHT, 4)) 
	
end

function AE_OutOfFuelCrit(executer, target)
	
	local outOfFuelGroup = SGroup_CreateIfNotFound("outOfFuelGroup")
	
	SGroup_Clear(outOfFuelGroup)
	
	if scartype(executer) == ST_SQUAD then
		SGroup_Add(outOfFuelGroup, executer)  
	elseif scartype(executer) == ST_ENTITY then
		if Entity_IsPartOfSquad(executer) == false then
			return
		end
		SGroup_Add(outOfFuelGroup, Entity_GetSquad(executer))
	end
	
	SGroup_SetSelectable(outOfFuelGroup, false)
	
	Cmd_Move(outOfFuelGroup, Util_GetOffsetPosition(outOfFuelGroup, OFFSET_FRONT, 50))
	
end

function AE_OutOfFuelNoRecrew(executer, target)
	
	local outOfFuel = EGroup_CreateIfNotFound("eg_outOfFuel")
	
--~ 	EGroup_Add(outOfFuel, executer)
--~ 	EGroup_SetSelectable(outOfFuel, false)
	
	Entity_SetRecrewable(executer, false)
	
--~ 	EGroup_Clear(outOfFuel)

end

function AE_MedicHeal(executer, target)
	
	if scartype(executer) == ST_SQUAD and scartype(target) == ST_SQUAD then
		local __medicGroup = SGroup_CreateIfNotFound("__medicGroup")
		local __medicTarget = SGroup_CreateIfNotFound("__medicTarget")
		SGroup_Add(__medicGroup, executer)
		SGroup_Add(__medicTarget, target)
		
		if SGroup_IsDoingAbility(__medicGroup, BP_GetAbilityBlueprint("usf_medic_heal_mp"), ANY) == false then
			Cmd_Ability(__medicGroup, BP_GetAbilityBlueprint("usf_medic_heal_mp"), __medicTarget, nil, nil, true)
		end
		
		SGroup_Clear(__medicGroup)
		SGroup_Clear(__medicTarget)
	end
	
end

function AE_CrewRepair(executer, target)
	
	if scartype(executer) == ST_SQUAD and scartype(target) == ST_ENTITY then
		if Entity_IsPartOfSquad(target) then
			local __crewGroup = SGroup_CreateIfNotFound("__crewGroup")
			local __crewTarget = SGroup_CreateIfNotFound("__crewTarget")
			SGroup_Add(__crewGroup, executer)
			SGroup_Add(__crewTarget, Entity_GetSquad(target))
			
			if SGroup_IsDoingAbility(__crewGroup, BP_GetAbilityBlueprint("aef_repair_ability_vehicle_crew_mp"), ANY) == false then
				Cmd_Ability(__crewGroup, BP_GetAbilityBlueprint("aef_repair_ability_vehicle_crew_mp"), __crewTarget, nil, nil, true)
			end
			
			SGroup_Clear(__crewGroup)
			SGroup_Clear(__crewTarget)
		else
			local __crewGroup = SGroup_CreateIfNotFound("__crewGroup")
			local __crewTarget = EGroup_CreateIfNotFound("__crewTarget")
			SGroup_Add(__crewGroup, executer)
			EGroup_Add(__crewTarget, target)
			
			if SGroup_IsDoingAbility(__crewGroup, BP_GetAbilityBlueprint("aef_repair_ability_vehicle_crew_mp"), ANY) == false then
				Cmd_Ability(__crewGroup, BP_GetAbilityBlueprint("aef_repair_ability_vehicle_crew_mp"), __crewTarget, nil, nil, true)
			end
			
			SGroup_Clear(__crewGroup)
			EGroup_Clear(__crewTarget)
		end
	end
	
end

function AE_RecrewVehicle(executer, target)

	local __capGroup = SGroup_CreateIfNotFound("__capGroup")
	local __targetVehicle = EGroup_CreateIfNotFound("__targetVehicle")
	SGroup_Add(__capGroup, executer)
	EGroup_Add(__targetVehicle, target)
	
	Entity_SetRecrewable(target, true)
	
	Cmd_RecrewVehicle(__capGroup, __targetVehicle, true)
	
	SGroup_Clear(__capGroup)
	EGroup_Clear(__targetVehicle)
end

function AE_SuggestKneelExtended(executer, target)
	
	if scartype(target) == ST_ENTITY then
		Entity_SuggestPosture(target, 1, 1000)
	elseif scartype(target) == ST_SQUAD then
		Squad_SuggestPosture(target, 1, 1000)
	end

end

function AE_MunitionsTransfer(executer, target)

	Entity_StopAbility(executer, BP_GetAbilityBlueprint("building_switch_fuel"), true)

end

function AE_FuelTransfer(executer, target)

	Entity_StopAbility(executer, BP_GetAbilityBlueprint("building_switch_munitions"), true)

end


function AE_PinpointWarningText_2(executer, target)

	UIWarning_Show(LOC("Target two more positions."))

end

function AE_PinpointWarningText_1(executer, target)

	UIWarning_Show(LOC("Target one more position."))

end


function AE_RangerReconPlane(executer, target)
	
	Player_AddAbility(Util_GetPlayerOwner(target), BP_GetAbilityBlueprint("pm_manpower_boost_recon"))
	
	Cmd_Ability(Util_GetPlayerOwner(target), BP_GetAbilityBlueprint("pm_manpower_boost_recon"), World_Pos(0, 0, 0))
	
end

function AE_OutOfFuelWarning(executer, target)

	UIWarning_Show(11079327)

end

function AE_NotEnoughCrew(executer, target)

	UIWarning_Show(11079370)

end

function AE_DisableCrateSelection(executer, target)
	
	local __eg_crate = EGroup_CreateIfNotFound("__eg_crate")
	
	EGroup_Add(__eg_crate, target)
	EGroup_SetSelectable(__eg_crate, false)
	
end

function AE_DisableSelfRepair(executer, target)
	
	bp = BP_GetAbilityBlueprint("vehicle_crew_repair_toggle_mp")
	if scartype(executer) == ST_SQUAD and Squad_HasAbility(executer, bp) and Squad_CanCastAbilityOnSquad(executer, bp, target) then 
		
		local _sg_selfRepair = SGroup_CreateIfNotFound("_sg_selfRepair")
		
		SGroup_Add(_sg_selfRepair, executer)
		
		Cmd_Ability(_sg_selfRepair, bp)
		
		SGroup_Clear(_sg_selfRepair)
		
	end
	
end

function AE_ReverseMoveArcher(executer, target)
	
	_sg_archReverse = SGroup_CreateIfNotFound("_sg_archReverse")
	
	if scartype(executer) == ST_SQUAD then
		SGroup_Add(_sg_archReverse, executer)
		Command_SquadMovePos(Util_GetPlayerOwner(executer), _sg_archReverse, Util_GetPosition(target), false, true)
	end
	SGroup_Clear(_sg_archReverse)
	
end

function AE_DisableLoading(executer, target)

	Entity_StopAbility(executer, BP_GetAbilityBlueprint("land_mattress_load_rockets_mp"), true)
	Entity_StopAbility(executer, BP_GetAbilityBlueprint("land_mattress_25lb_rocket"), true)
	Entity_StopAbility(executer, BP_GetAbilityBlueprint("land_mattress_60lb_rocket"), true)
	Entity_StopAbility(executer, BP_GetAbilityBlueprint("land_mattress_phosphorus_rocket"), true)

end

function AE_DisableFiring(executer, target)

	Entity_StopAbility(executer, BP_GetAbilityBlueprint("land_mattress_fire_all"), true)

end

function AE_BritDefaultRally(executer, target)
	
	local _eg_defRally = EGroup_CreateIfNotFound("_eg_defRally")
	EGroup_Add(_eg_defRally, executer)
	
	Command_EntityPos(Util_GetPlayerOwner(executer), _eg_defRally, CMD_RallyPoint, Util_GetOffsetPosition(executer, OFFSET_BACK, 15))
	
	EGroup_Clear(_eg_defRally)

end

function AE_BritDefaultRally_Front(executer, target)
	
	local _eg_defRally = EGroup_CreateIfNotFound("_eg_defRally")
	EGroup_Add(_eg_defRally, executer)
	
	Command_EntityPos(Util_GetPlayerOwner(executer), _eg_defRally, CMD_RallyPoint, Util_GetOffsetPosition(executer, OFFSET_FRONT, 10))
	
	EGroup_Clear(_eg_defRally)

end

-----------------------------------------------------------------------------------
-- Forces the target squad to abandon their team weapon
-----------------------------------------------------------------------------------
function AE_AbandonTeamWeapon(executer, target)

	sg_TempGroup = SGroup_CreateIfNotFound("sg_TempGroup")
	SGroup_Add(sg_TempGroup, target)
	
	Cmd_AbandonTeamWeapon(sg_TempGroup, true, false)

	SGroup_Clear(sg_TempGroup)
end

--? @author Janne "Janne252" Varjo (June 3, 2019)
--? @shortdesc Replaces a fully constructed crushable entity with a standard entity.
--? @args Entity oldEntity, Entity executer
--? @extdesc
--? To use this function, create a new copy of the desired entity and add "__construction__" to its name
--? so that when replaced with an underscore the name of the original entity is the result, e.g.
--? "wg_sandbag_fence__construction__mp" -> "wg_sandbag_fence_mp"
--? 
--? The newly created entity, e.g. "wg_sandbag_fence__construction__mp" should have its impass_ext set to:
--? 	cant_build = true
--? 	heavy_crush = false
--? 	land = false
--? 	light_crush = false		
--? 	medium_crush = false
--? 
--? And	the following action added to construction_ext/on_construction_actions:
--? 	scar_function_call
--? 		funtion_name = AE_ReplaceCrushableConstructionEntity
--? 
--? To control a __construction__ entity crushing behavior with vehicles, add/remove crushee_ext.
function AE_ReplaceCrushableConstructionEntity(oldEntity, executer)
	local oldEntityID = Entity_GetGameID(oldEntity)
	local oldEBPName = BP_GetName(Entity_GetBlueprint(oldEntity))

	local magic = "__construction__"
	local replacement = "_"
	-- If the blueprint ends with the magic, replace the magic with an empty string instead
	if string.sub(oldEBPName, - string.len(magic)) == magic then
		replacement = ""
	end	
	local newEBPName = string.gsub(oldEBPName, magic, replacement)

	-- Clean possible Mod GUID (replacement entity is likely to be a "vanilla" entity)
	local modGUIDSeparatorStart = string.find(newEBPName, ":")
	if modGUIDSeparatorStart ~= nil then
		newEBPName = string.sub(newEBPName, modGUIDSeparatorStart + 1)
	end

	local newEBP = BP_GetEntityBlueprint(newEBPName)
	local pos = Entity_GetPosition(oldEntity)
	local newEntity = Entity_CreateENV(newEBP, pos, pos)

	-- Copy attributes to the new entity
	if not World_OwnsEntity(oldEntity) then
		Entity_SetPlayerOwner(newEntity, Entity_GetPlayerOwner(oldEntity))
	end
	Entity_SetHeading(newEntity, Entity_GetHeading(oldEntity), false)
	Entity_SetHealth(newEntity, Entity_GetHealthPercentage(oldEntity))
	
	-- Find out of the current entity is selected by the local player
	local oldEntityIsSelected = false
	local eg_selectedEntities = EGroup_CreateIfNotFound("")
	Misc_GetSelectedEntities(eg_selectedEntities, false)

	EGroup_ForEach(eg_selectedEntities, function(eg, idx, entity)
		if Entity_GetGameID(entity) == oldEntityID then
			oldEntityIsSelected = true
		end
	end)
	
	-- Destory the old entity
	Entity_Destroy(oldEntity)

	-- Spawn and construct the new entity
	Entity_Spawn(newEntity)
	Entity_ForceConstruct(newEntity)

	-- Create a new function in global scope in order to use in rule system
	local taskName = "__normalize_replaced_crushable_construction_entity_" .. Entity_GetGameID(newEntity)
	_G[taskName] = function() 
		local pos = Entity_GetPosition(newEntity)
		-- Normalize entity Y component to the terrain height to prevent 
		-- terrain deforming entities from sinking
		pos.y = Misc_GetTerrainHeight(pos)
		Entity_SetPosition(newEntity, pos)

		-- Normalize entity heading to align it to the terrain
		Entity_SetHeading(newEntity, Entity_GetHeading(newEntity), false)

		-- Remove the task from the global scope
		_G[taskName] = nil
	end

	-- Delay entity normalization task by one frame
	Rule_AddOneShot(_G[taskName], 1/8)

	-- Restore selection locally per player
	if oldEntityIsSelected then
		local localPlayerID = Player_GetID(Game_GetLocalPlayer())
		for playerIndex = 1, World_GetPlayerCount() do
			local player = World_GetPlayerAt(playerIndex)
			if Player_GetID(player) == localPlayerID then
				Misc_SelectEntity(newEntity)
			end
		end
	end		
end


