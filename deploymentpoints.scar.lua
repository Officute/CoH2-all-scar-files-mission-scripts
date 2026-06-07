import("prototype/WorldEntityCollector.scar")
import("prototype/AutoPointCapture.scar")
import("Prototype/SpecialAEFunctions.scar")

local withdrawLookup = { }

local SetupWithdrawPoint = function(player)
	local egroup = Player_GetEntities(player)
	for i=1, EGroup_CountSpawned(egroup) do
		local entity = EGroup_GetSpawnedEntityAt(egroup, i)
		if (BP_GetName(Entity_GetBlueprint(entity)) == "map_entry_point") then
			withdrawLookup[Player_GetID(player)] = Util_GetPosition(entity)
			break
		end
	end
end

function WithdrawFromMap(caster, target)
	local player = Util_GetPlayerOwner(caster)
	local position = withdrawLookup[Player_GetID(player)]
	if (position) then
		local sgroup = SGroup_Create("")
		SGroup_Add(sgroup, caster)
		Command_SquadPos(
			player,
			sgroup,
			SCMD_Retreat,
			position,
			false
		)
		local squadID = Squad_GetGameID(caster)
		Rule_AddDelayedInterval(function()
			if (Squad_IsValid(squadID)) then
				if not (Squad_IsRetreating(caster)) then
					Squad_Destroy(caster)
					Rule_RemoveMe()
				end
			else
				Rule_RemoveMe()
			end
		end, 1, 1)
	end
end

function DeploymentPoint_Placed(executer, target, territory)
	territory = territory or Territory:GetFromEntity(target)
	local player = Util_GetPlayerOwner(executer)
	if (territory) then
		territory:AddDeploymentPoint(player, target)
	else
		print("Tried to place a deployment point on an invalid object")
		print("Object was a "..scartype_tostring(target))
		local stype = scartype(target)
		local str
		if (stype == ST_ENTITY) then
			str = "an entity, blueprint = "..BP_GetName(Entity_GetBlueprint(target))
		elseif (stype == ST_EGROUP) then
			str = "an EGroup, target must be an entity"
		elseif (stype == ST_SQUAD) then
			str = "a Squad, target must be an entity"
		elseif (stype == ST_SGROUP) then
			str = "an SGroup, target must be an entity"
		elseif (stype == ST_PLAYER) then
			str = "a player, target must be an entity - Player # "..Player_GetID(target)
		elseif (stype == ST_NIL) then
			str = "nil"
		end
		fatal(str)
	end
end

function DeploymentPoint_Destroyed(executer, target)
	
end

local PresetDeploymentPoints = function()
	if not (isCampaign) then
		local deploymentPoints = WorldEntityCollector:GetEntitiesFromType("strategic_node")
		
		for i=1, World_GetPlayerCount() do
			local player = World_GetPlayerAt(i)
			SetupWithdrawPoint(player)
			local sgroup = Player_GetSquads(player)
			local position
			local currentDistance = 9999999
			local currentPoint
			for i=1, SGroup_CountSpawned(sgroup) do
				local squad = SGroup_GetSpawnedSquadAt(sgroup, i)
				local blueprint = BP_GetName(Squad_GetBlueprint(squad))
				if (blueprint == "command_squad") then
					position = Util_GetPosition(squad)
					break
				end
			end
			
			if not (position) then
				position = World_Pos(0, 0, 0)
			end
			
			for k, v in pairs(deploymentPoints) do
				local distance = World_DistancePointToPoint(position, Util_GetPosition(v))
				if (distance < currentDistance) and (not v.taken) then
					currentDistance = distance
					currentPoint = v
				end
			end
			
			if (currentPoint) then
				Entity_InstantCaptureStrategicPoint(currentPoint, player)
				local territory = Territory:GetFromEntity(currentPoint)
				territory:PresetCaptureOwner(Player_GetTeam(player))
				DeploymentPoint_Placed(player, currentPoint, territory)
			end
		end
	end
end

local produceStructures = { }

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

function DeleteOldProduceStructures()
	for i=#produceStructures, 1, -1 do
		local entity = produceStructures[i]
		if not (Entity_HasProductionQueue(entity) and (Entity_GetProductionQueueSize(entity) > 0)) then
			Entity_Kill(entity)
			table.remove(produceStructures, i)
		end
	end
end

function ProduceCommandSquad(executer, target)
	ProduceStructure(executer, target, "command_squad_structure", "command_squad")
end

function ProduceCombatEngineer(executer, target)
	ProduceStructure(executer, target, "combat_engineers_structure", "combat_engineer_squad")
end

function ProduceMotorcycle(executer, target)
	ProduceStructure(executer, target, "motorcycle_structure", "russian_motorcycle_squad")
end

function ProduceFieldATGun(executer, target)
	ProduceStructure(executer, target, "field_at_gun_structure", "at_57mm__gun_squad")
end

function ProduceHMG(executer, target)
	ProduceStructure(executer, target, "hmg_structure", "weapon_team")
end

function Produce120mmMortar(executer, target)
	ProduceStructure(executer, target, "mortar_120mm_structure", "mortar_120mm_squad")
end

function Produce80mmMortar(executer, target)
	ProduceStructure(executer, target, "mortar_80mm_structure", "mortar_80mm_squad")
end

function ProduceSniper(executer, target)
	ProduceStructure(executer, target, "sniper_structure", "sniper_squad")
end

function ProduceSU85(executer, target)
	ProduceStructure(executer, target, "su85_structure", "su-85_american")
end

function ProduceT34(executer, target)
	ProduceStructure(executer, target, "t34_structure", "t-34")
end

function ProduceIS2(executer, target)
	ProduceStructure(executer, target, "is2_structure", "is-2")
end

function ProduceISU122(executer, target)
	ProduceStructure(executer, target, "isu122_structure", "isu-122")
end

function ProduceT70m(executer, target)
	ProduceStructure(executer, target, "t70m_structure", "t-70m")
end

function ProduceVeteranInfantry(executer, target)
	ProduceStructure(executer, target, "veteran_infantry_structure", "ranger_team")
end

function ProduceRussianArmouredCar(executer, target)
	ProduceStructure(executer, target, "armoured_car_structure", "armoured_car_squad")
end

function ProduceRocketTruck(executer, target)
	ProduceStructure(executer, target, "rocket_truck_structure", "russian_rocket_truck")
end

function ProduceStructure(executer, target, structurePath, squadPath)
	local player = Util_GetPlayerOwner(executer)
	local egroup = Player_GetEntities(player)
	local location = FindMapEntryPosition(egroup)
	if not (location) then return end
	
	local structure = Entity_Create(
		BP_GetEntityBlueprint(structurePath), 
		Util_GetPlayerOwner(executer), 
		location, 
		World_Pos(0,0,0)
	)
	Entity_Spawn(structure)
	table.insert(produceStructures, structure)
	local egroup = EGroup_Create("")
	EGroup_Add(egroup, structure)
	Rule_AddOneShot(function()
		if (EGroup_Count(egroup) > 0) then
			Command_EntityPos(player, egroup, CMD_RallyPoint, Util_GetPosition(target))
			Command_EntityBuildSquad(player, egroup, BP_GetSquadBlueprint(squadPath))
		end
	end, 0.25)
end