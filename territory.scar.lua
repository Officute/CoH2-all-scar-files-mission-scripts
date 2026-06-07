Territory = { }

Territory.__index = function(territory, key)
	return Territory[key]
end

Territory.targetProgress = 30
Territory.commanderValue = 1
Territory.multipleValue = 0
Territory.defenseTargetProgress = 90

Territory.filteredEntityTypes = {
	"vehicle"
}

Territory.secureEntityTypes = {
	"defence_building",
}

Territory.entityLookup = { }
Territory.deploymentLookup = { }

function Territory:New(entity)
	if not (Territory.entityLookup[Entity_GetGameID(entity)]) then
		local new =  { }
		setmetatable(new, self)
		new.entity = entity
		new.sectorID = World_GetTerritorySectorID(Util_GetPosition(entity))
		new.progress = 0
		new.lastUpdate = World_GetGameTime()
		new.captured = false
		Territory.entityLookup[Entity_GetGameID(entity)] = new
		new.deploymentPoints = { }
		new.defenses = { }
		new.defenseProgress = 0
		return new
	else
		return Territory.entityLookup[Entity_GetGameID(entity)]
	end
end

function Territory:CapturePoll()
	local teams = self:GetTeams()
	local winningTeam
	local losingTeam
	local current = 0
	local tie
	for k, v in pairs(teams) do
		if (v.num > current) then
			if (losingTeam) then
				losingTeam = winningTeam
			end
			current = v.num
			winningTeam = v
		elseif (winningTeam) and (v.num == current) then
			tie = true
			losingTeam = v
		end
	end
	
	local currentProgress
	local currentCommandProgress
	
	if (not tie) and (winningTeam) and (losingTeam) then
		currentProgress, currentCommandProgress = self:GetProgress(winningTeam.num - losingTeam.num, winningTeam.commander, losingTeam.commander)
	elseif (not tie) and (winningTeam) then
		currentProgress, currentCommandProgress = self:GetProgress(winningTeam.num, winningTeam.commander)
	elseif (not tie) then
		currentProgress = self:GetProgress(1)
	end
	
	if (currentProgress) then
		if (self.captured) then
			if not (self:IsSecured()) then
				if (winningTeam) and (winningTeam.team ~= self.owner) then
					self:UpdateProgress(currentProgress*-1)
				else
					self:UpdateProgress(currentProgress)
				end
			else
				self:UpdateProgress(0)
			end
		elseif (self.owner) then
			if (winningTeam) and (winningTeam.team == self.owner) then
				self:UpdateProgress(currentProgress)
			else
				self:UpdateProgress(currentProgress*-1)
			end
		else
			if (winningTeam) then
				self.owner = winningTeam.team
				self:UpdateProgress(currentProgress)
			end
		end
	end
	
	self.lastUpdate = World_GetGameTime()
end

function Territory:UpdateProgress(progress)
	if (progress ~= 0) then
		self.progress = self.progress + progress
		if (self.progress <= 0) then
			self.captured = false
			self:SetNeutral()
		elseif (self.progress >= self.targetProgress) then
			self.progress = self.targetProgress
			self.captured = true
			self:Captured()
		else
			self:DisplayKicker()
		end
	end
end

function Territory:SetNeutral()
	self.progress = 0
	self.defenseProgress = 0
	self.owner = nil
	self:RemoveDeploymentPoints()
	Entity_SetStrategicPointNeutral(self.entity)
end

function Territory:DisplayKicker()
--~ 	for i=1, World_GetPlayerCount() do
--~ 		local player = World_GetPlayerAt(i)
		UI_CreateColouredEntityKickerMessage(World_GetPlayerAt(1), self.entity, LOC(math.floor(self.progress/self.targetProgress*100).."% Captured by Team "..self.owner), 255, 255, 255, 255)
--~ 	end
end

function Territory:Captured()
	local player
	for i=1, World_GetPlayerCount() do
		local currentPlayer = World_GetPlayerAt(i)
		if (self.owner == Player_GetTeam(currentPlayer)) then
			player = currentPlayer
			break
		end
	end
	Entity_InstantCaptureStrategicPoint(self.entity, player)
end

function Territory:GetTeams()
	local teams = { }
	for i=1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		local team = Player_GetTeam(player)
		teams[team] = teams[team] or { sgroup = SGroup_Create(""), num = 0, team = team }
		World_GetSquadsWithinTerritorySector(player, teams[team].sgroup, self.sectorID, OT_Player)
		self:FilterEntityTypes(teams[team].sgroup)
		teams[team].num = SGroup_CountSpawned(teams[team].sgroup)
		if (self:GroupHasCommander(teams[team].sgroup)) then
			teams[team].commander = true
		end
	end
	for k, v in pairs(teams) do
		SGroup_Destroy(v.sgroup)
		v.sgroup = nil
	end
	return teams
end

function Territory:GetProgress(num, winCommander, loseCommander)
	local update = World_GetGameTime()
	local progress = 0
	local commandProgress = 0
	
	progress = ((1+((num-1)*self.multipleValue))*(update - self.lastUpdate))/(World_GetPlayerCount()/2)
	
	return progress, progress
end

function Territory:GetFromEntity(entity)
	return Territory.entityLookup[Entity_GetGameID(entity)]
end

function Territory:PresetCaptureOwner(team)
	self.owner = team
	self.captured = true
	self.progress = self.targetProgress
end

function Territory:GroupHasCommander(sgroup)
	for i=1, SGroup_CountSpawned(sgroup) do
		local squad = SGroup_GetSpawnedSquadAt(sgroup, i)
		if (BP_GetName(Squad_GetBlueprint(squad)) == "command_squad") then
			UI_CreateSquadKickerMessage(World_GetPlayerAt(1), squad, LOC("In Territory"))
			return true
		end
	end
	return false
end

function Territory:FilterEntityTypes(sgroup)
	for i=SGroup_CountSpawned(sgroup), 1, -1 do
		local squad = SGroup_GetSpawnedSquadAt(sgroup, i)
		for i=0, Squad_Count(squad)-1 do
			local found = false
			if (found) then break end
			local entity = Squad_EntityAt(squad, i)
			for k, v in pairs(Territory.filteredEntityTypes) do
				if (Entity_IsOfType(entity, v)) then
					SGroup_Remove(sgroup, squad)
					found = true
					break
				end
			end
		end
	end
end

function Territory:IsSecured()
	local player = Util_GetPlayerOwner(self.entity)
	if (player) then
		local team = Player_GetTeam(player)
		for i=1, World_GetPlayerCount() do
			local player = World_GetPlayerAt(i)
			if (team == Player_GetTeam(player)) then
				local egroup = EGroup_Create("")
				World_GetEntitiesWithinTerritorySector(player, egroup, self.sectorID, OT_Player)
				for i=1, EGroup_CountSpawned(egroup) do
					local entity = EGroup_GetSpawnedEntityAt(egroup, i)
					for k, v in pairs(Territory.secureEntityTypes) do
						if (Entity_IsOfType(entity, v)) then
							EGroup_Destroy(egroup)
							return true
						end
					end
				end
				EGroup_Destroy(egroup)
			end
		end
	end
	return false
end

function Territory:DefenseCheck()
	if (isCampaign) then return false else return false end
	local count = 0
	for i=#self.defenses, 1, -1 do
		if (Entity_IsValid(self.defenses[i])) then
			count = count + 1
		else
			table.remove(self.defenses, i)
		end
	end
	
	local newCount = self:ProgressDefenses(count)
	
	if (newCount > 0) then
		return true
	else
		return false
	end
end

function Territory:ProgressDefenses(count)
	local multiplier = count + 1
	for k, v in pairs(self.deploymentPoints) do
		local defenseProgress = self.defenseProgress + (1*(World_GetGameTime() - self.lastUpdate))
		if (defenseProgress > self.defenseTargetProgress*multiplier) then
			self.defenseProgress = 0
			multiplier = multiplier + 1
			local rootPosition = World_GetTerritorySectorPosition(self.sectorID)
			local position = Prox_GetRandomPosition(rootPosition, 20, 10)
			local defense = Entity_Create(BP_GetEntityBlueprint("bofors_gun_nest"), Player_FromId(k), position, World_Pos(0, 0, 0))
			Entity_ForceConstruct(defense)
			Entity_Spawn(defense)
			table.insert(self.defenses, Entity_GetGameID(defense))
		else
			self.defenseProgress = defenseProgress
		end
	end
	return multiplier-1
end

function Territory:AddDeploymentPoint(player)
	local playerID = Player_GetID(player)
	self:ClearMapEntryPoint(player)
	self:RemoveDeploymentPoint(player)
	Territory.deploymentLookup[playerID] = self
	self.deploymentPoints[playerID] = true
	self:AddMapEntryPoint(player, self.entity)
end

function Territory:RemoveDeploymentPoint(player)
	local playerID = Player_GetID(player)
	if (Territory.deploymentLookup[playerID]) then
		Territory.deploymentLookup[playerID].deploymentPoints[playerID] = nil
		Territory.deploymentLookup[playerID] = nil
	end
	self:ClearMapEntryPoint(player)
end

function Territory:RemoveDeploymentPoints()
	for k, v in pairs(Territory.deploymentLookup) do
		if (v == self) then
			Territory.deploymentLookup[k] = false
			self.deploymentPoints[k] = nil
			local player = Player_FromId(k)
			self:ClearMapEntryPoint(player)
		end
	end
end

function Territory:GetDeploymentPoint(player)
	local playerID = Player_GetID(player)
	return Territory.deploymentLookup[playerID]
end

function Territory:ClearMapEntryPoint(player)
	local egroup = Player_GetEntities(player)
	for i=1, EGroup_CountSpawned(egroup) do
		local entity = EGroup_GetSpawnedEntityAt(egroup, i)
		local blueprint = BP_GetName(Entity_GetBlueprint(entity))
		if (blueprint == "map_entry_point") then
			Entity_Destroy(entity)
			break
		end
	end
	Player_RemoveUpgrade(player, BP_GetUpgradeBlueprint("has_deployment_point"))
end

function Territory:AddMapEntryPoint(player, entity)
	local position = Prox_GetRandomPosition(entity, 10, 5)
	local entity = Entity_Create(BP_GetEntityBlueprint("map_entry_point"), player, position, World_Pos(0, 0, 0))
	Entity_Spawn(entity)
	Command_PlayerUpgrade(player, BP_GetUpgradeBlueprint("has_deployment_point"), true, false)
end
