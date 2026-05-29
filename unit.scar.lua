--Unit class
--Represents a type of unit within an encounter

Unit = {}

Unit.state = "Idle"
Unit.prevState = "Idle"
Unit.data = {}
Unit.encounter = nil --The encounter to which this unit belongs. can be nil
--~ Unit.allowedBehaviors = {} --Behaviors this unit is allowed to have
--~ Unit.activeBehavior = nil --The currently active behavior
--~ Unit.roles = {} --e.g. Antitank, transport,
--~ Unit.enabled = true
--~ Unit.isScripted = false


--Creates and returns a new unit based on given data table or SBP.
function Unit:Create(data, encounter)
	local unit = Clone(self)
	unit.encounter = encounter
	
	unit.data = Clone(data)
	
	--Set the name
	if(unit.data.name == nil) then
		if(encounter.units == nil) then
			unit.data.name = encounter.data.name .. "_unit1"
		else
			unit.data.name = encounter.data.name .. "_unit" .. (#encounter.units + 1)
		end
	end
	
	return unit
end

--Spawns the unit and gives upgrades if necessary
function Unit:Spawn()
	
	local spawnLocation = self.data.spawn
	
	if scartype(spawnLocation) == ST_TABLE then
		spawnLocation = Table_GetRandomItem(spawnLocation)
	end
	
	--Check to see if it's trying to spawn in an invalid location. Use the backupSpawn if one is defined.
	if((scartype(spawnLocation) == ST_EGROUP and EGroup_CountAlive(spawnLocation) == 0)
		or (scartype(spawnLocation) == ST_SGROUP and SGroup_CountSpawned(spawnLocation) == 0)) then
			if(self.data.backupSpawn) then
				Ai:Print("\tWARNING: Spawn location is invaled. Using 'backupSpawn' as spawn position")
				spawnLocation = self.data.backupSpawn
			else
				fatal("Attempted to spawn a squad in an invalid egroup. No 'backupSpawn' defined.")
			end
	end
	
	--Dynamic spawning
	local facingPos = nil
	if(self.data.dynamicSpawnTarget)  then
		Ai:Print("\tUsing dynamic spawn")

		spawnLocation = Util_FindHiddenSpawn(Util_GetPosition(spawnLocation), Util_GetPosition(self.data.dynamicSpawnTarget))
		
		facingPos = Util_GetPosition(self.data.dynamicSpawnTarget)
	end
	
	self.sgroup = SGroup_Create(self.data.name)
	Util_CreateSquads(self.data.player, self.sgroup, self.data.sbp, spawnLocation, self.data.moveTo, 1, self.data.load, self.data.attackMoveTo, nil, nil, facingPos)
	
	--DEBUG: Performance debugging. '-enc_percload <X>' determines the loadout fraction per squad. eg. x=0.5 spawns only half of the squad loadout.
	if(Misc_IsCommandLineOptionSet("enc_percload")) then
		local load = SGroup_TotalMembersCount(self.sgroup)
		local maxLoad = math.ceil(load * tonumber(Misc_GetCommandLineString("enc_percload")))
		print("Max loadout for encounter set at: " .. maxLoad)
		
		local squad = SGroup_GetSpawnedSquadAt(self.sgroup, 1)
		for k=0,maxLoad-1 do
			Entity_Kill(Squad_EntityAt(squad, k))
		end
	end
	
	if(self.data.killSyncWeapon ~= nil) then
		Util_LogSyncWpn(self.sgroup, self.data.killSyncWeapon)
	end
	
	if(self.data.veterancyRank) then
		SGroup_IncreaseVeterancyRank(self.sgroup, self.data.veterancyRank, true)
	end	
	
	--Regular squad upgrades
	if (self.data.upgrades) then
		if(scartype(self.data.upgrades) == ST_TABLE) then
			for i=1, #self.data.upgrades do
				Cmd_InstantUpgrade(self.sgroup, self.data.upgrades[i])
			end
		elseif(scartype(self.data.upgrades) == ST_PBG) then
			Cmd_InstantUpgrade(self.sgroup, self.data.upgrades)
		else
			fatal("Invalid UPGRADE defined for unit " ..  self.data.name ..". Must be UPG or table of UPG's")
		end
	end
	
	--Entity upgrades (usually applied to vehicles)
	if(self.data.entityUpgrades) then
		if(scartype(self.data.entityUpgrades) == ST_PBG) then
			self.data.entityUpgrades = {self.data.entityUpgrades}
		end
		
		local squad = SGroup_GetSpawnedSquadAt(self.sgroup, 1)
		for i=0, Squad_Count(squad)-1 do
			for k, upg in pairs(self.data.entityUpgrades) do
				Entity_CompleteUpgrade(Squad_EntityAt(squad, i), upg)
			end
		end
	end
	
	if(self.data.slotItems) then
		local squad = SGroup_GetSpawnedSquadAt(self.sgroup, 1)
		if(scartype(self.data.slotItems) == ST_TABLE) then
			for i=1, #self.data.slotItems do
				Squad_GiveSlotItem(squad, self.data.slotItems[i])
			end
		elseif(scartype(self.data.slotItems) == ST_PBG) then
			Squad_GiveSlotItem(squad, self.data.slotItems)
		else
			fatal("Invalid SLOT_ITEM defined for unit " ..  self.data.name ..". Must be SLOT_ITEM or table of SLOT_ITEM's")
		end
	end
	
	if(self.data.dropItems) then
		local squad = SGroup_GetSpawnedSquadAt(self.sgroup, 1)
		for k,item in pairs(self.data.dropItems) do
			if(item.difficulty == nil or AI_IsMatchingDifficulty(item.difficulty)) then
				Squad_AddSlotItemToDropOnDeath(squad, item.slotItem, item.dropChance, item.exlusive or false)
			end
		end
	end
	
	if(self.data.recrewable ~= nil) then
		SGroup_SetRecrewable(self.sgroup, self.data.recrewable)
	end
	
	if(self.data.abandonable ~= nil and self.data.abandonable == false) then
		Cmd_InstantUpgrade(self.sgroup, BP_GetUpgradeBlueprint("disable_abandon_critical_squad"))
	end
	
	if(self.data.instantSetup) then
		Cmd_InstantSetupTeamWeapon(self.sgroup)
	end
	
	if(self.data.sgroups) then
		for k,v in pairs(self.data.sgroups) do 
			SGroup_AddGroup(v, self.sgroup)
		end	
	end
end


--Main update logic for the unit
function Unit:Update()

	if(SGroup_GetAvgHealth(self.sgroup) <= 0) then
		Ai:Print(self.data.name .. " unit has been killed")
	elseif(SGroup_CountSpawned(self.sgroup) <= 0) then
		return
	elseif(not self.enabled) then
		return
	elseif(self:UpdateState())then 
		return 
	end
	
	if(self.activeBehavior and self:IsAlive()) then
		self.activeBehavior:Update(self.state, "Update")
	end
end

--Checks status of the unit and updates the state if needed.
function Unit:UpdateState()
	if(self.state == "Idle" and (SGroup_IsDoingAttack(self.sgroup, ANY, 5) or SGroup_IsUnderAttack(self.sgroup, ANY, 5)))then
		self:SetState("Combat")
		
		return true
	elseif(self.state == "Combat" and not (SGroup_IsDoingAttack(self.sgroup, ANY, 5) or SGroup_IsUnderAttack(self.sgroup, ANY, 5))) then
		self:SetState("Idle")
		
		return true
	end
end


function Unit:SetState(state)
	Ai:Print(self.data.name .. " unit set state: " .. state)
	if(self.activeBehavior) then
		self.activeBehavior:Update(self.state, "Exit")
		self.activeBehavior:Update(state, "Enter")
	end
	
	self.prevState = self.state
	self.state = state
end


--Determines if a unit has a specific role
function Unit:HasRole(role)
	for i=1, #self.roles do
		if(self.roles[i] == "role") then
			return true
		end
	end
	
	return false
end

--Determines whether the unit has an allowed behavior or not
function Unit:AllowsBehavior(behaviorName)
	return (self.allowedBehaviors[behaviorName])
end


function Unit:Enable()
	self.enabled = true
end

function Unit:Disable()
	self.enabled = false
end

function Unit:IsEnabled()
	return self.enabled
end

function Unit:IsAlive()
	return self.sgroup and SGroup_CountSpawned(self.sgroup) > 0
end

--Changes the onDeath event for the unit
function Unit:SetOnDeath(func)
--~ 	Rule_RemoveSGroupEvent(self.data.onDeath, self.sgroup)
	
	self.data.onDeath = func
--~ 	Rule_AddSGroupEvent(func, self.sgroup)
end

--Returns the encounter this unit belongs to
function Unit:GetEncounter()
	return self.encounter
end
