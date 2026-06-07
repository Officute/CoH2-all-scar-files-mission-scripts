WorldEntityCollector = { }

WorldEntityCollector.things = { 
	["victory_point"] = { },
	["radio_antenna"] = { },
}

WorldEntityCollector.thingTypes = {
	["strategic_node"] = { },
	["ambient_building"] = { },
}

function WorldEntityCollector.Collect(blueprintName)
	if not (blueprintName) then
		for i=0, World_GetNumEntities()-1 do
			local entity = World_GetEntity(i)
			local blueprint = BP_GetName(Entity_GetBlueprint(entity))
			if (WorldEntityCollector.things[blueprint]) then
				table.insert(WorldEntityCollector.things[blueprint], entity)
			end
			for k, v in pairs(WorldEntityCollector.thingTypes) do
				if (Entity_IsOfType(entity, k)) then
					table.insert(v, entity)
				end	
			end
		end
	else
		WorldEntityCollector.things[blueprintName] = { }
		for i=0, World_GetNumEntities()-1 do
			local entity = World_GetEntity(i)
			if (BP_GetName(Entity_GetBlueprint(entity)) == blueprintName) then
				table.insert(WorldEntityCollector.things[blueprintName], entity)
			end
		end
	end
end

function WorldEntityCollector:AddBlueprintName(blueprintName)
	WorldEntityCollector.things[blueprintName] = { }
end

function WorldEntityCollector:GetEntities(blueprintName)
	if (type(blueprintName) == "string") then
		if (WorldEntityCollector.things[blueprintName]) then
			return WorldEntityCollector.things[blueprintName]
		else
			print("SLOW WARNING: WorldEntityCollector was requested "..tostring(blueprintName).." - it is not pre-collected")
			self.Collect(blueprintName)
			return WorldEntityCollector.things[blueprintName]
		end
	elseif (type(blueprintName) == "table") then
		local entities = { }
		for k, v in pairs(blueprintName) do
			if (self.things[v]) then
				for entityKey, entity in pairs(self.things[v]) do
					table.insert(entities, entity)
				end
			end
		end
		return entities
	end
end

function WorldEntityCollector:GetEntitiesFromType(typeName)
	if (type(typeName) == "string") then
		return self.thingTypes[typeName]
	elseif (type(typeName) == "table") then
		local entities = { }
		for k, v in pairs(typeName) do
			if (self.thingTypes[v]) then
				for entityKey, entity in pairs(self.thingTypes[v]) do
					table.insert(entities, entity)
				end
			end
		end
		return entities
	end
end

Scar_AddInit( WorldEntityCollector.Collect )