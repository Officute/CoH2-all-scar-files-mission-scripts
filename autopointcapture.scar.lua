import("prototype/WorldEntityCollector.scar")
import("prototype/Territory.scar")

local territories = { }

local CreateTerritories = function()
	local points = WorldEntityCollector:GetEntitiesFromType("strategic_node")
	
	for k, v in pairs(points) do
		table.insert(territories, Territory:New(v))
	end
	
	--~for i=1, #territories do
	--~	local delay = ((23%i)+1)/10
	--~	Rule_AddDelayedInterval(function()
	--~		territories[i]:CapturePoll()
	--~	end, delay, 3)
	--~end
end

Scar_AddInit(CreateTerritories)