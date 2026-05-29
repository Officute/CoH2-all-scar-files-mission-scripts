--
-- "SimpleDefendEncounter"
--
--  Prefab Script
--


--? @group scardoc;Prefabs


-- Initializer function should ALWAYS be named after the prefab name with _Init appended on the end
function simpledefendencounter_Init(data)

	local instance = Prefab_GetInstance(data)
	
	-- set up instance's data
	local data = {}
	instance.data = data
	instance.data.hasTriggered = false
	
	-- set up encounter details from the instance data
	local encounter = {}
	data.encounter = encounter
	encounter.player = instance.player
	encounter.name = instance.name
	if instance.sgroups ~= nil then
		encounter.sgroups = {instance.sgroup}
	end
	encounter.units = {}
	
	for index, this in pairs(instance.units) do
		
		local unit = {}
		unit.spawn = this.location
		
		if this.blueprint ~= "" then
			unit.sbp = this.blueprint
		else
			if this.sbp == "Light infantry" then
				unit.sbp = SBP.WEST_GERMAN.JAEGER_LIGHT_INFANTRY_RECON_SQUAD_MP
			elseif this.sbp == "Light armour" then
				unit.sbp = SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP
			elseif this.sbp == "Transport vehicle" then
				unit.sbp = SBP.WEST_GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP_2
			elseif this.sbp == "HMG" then
				unit.sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP
			elseif this.sbp == "AT Gun" then
				unit.sbp = SBP.WEST_GERMAN.PAK40_75MM_AT_GUN_SQUAD_WG_MP
			end
		end
		
		table.insert(encounter.units, unit)
		
	end
	
	-- set up the goal details from the instance data
	local goal = {}
	data.goal = goal
	goal.name = "Defend"
	goal.target = instance.goal.target
	goal.range = Marker_GetProximityRadius(instance.goal.target)
	goal.leashRange = Marker_GetProximityRadius(instance.goal.leashRange)
	goal.garrison = instance.goal.garrison
	goal.garrisonIdle = instance.goal.garrisonIdle
	
	if instance.goal.goal_trigger == "On sight" then					-- handle the way the goal is triggered
		encounter.triggerGoalOnSight = true
		encounter.goal = goal
	elseif instance.goal.goal_trigger == "On engage" then
		encounter.triggerGoalOnEngage = true
		encounter.goal = goal
	elseif instance.goal.goal_trigger == "Immediately" then
		encounter.goal = goal
	elseif instance.goal.goal_trigger == "Manually" then
		-- do nothing
	end
	
	if instance.abilityblacklist_enable == true then						-- if an ability blacklist was specified, create that
		goal.abilityBlacklist = {}
		for index, item in pairs(instance.abilityblacklist) do 
			table.insert(goal.abilityBlacklist, item.ability)
		end
	end
	
	if instance.tactics_enable == true then								-- if a tactic control list was specified, create that
		goal.tacticControlsList = {}
		for index, item in pairs(instance.tactics) do
			
			local tactic = {}
			
			if item.tactic_type == "Use abilities" then
				tactic.tacticType = TACTIC_Ability
			elseif item.tactic_type == "Garrison" then
				tactic.tacticType = TACTIC_Hold
			elseif item.tactic_type == "Avoid artillery/grenades" then
				tactic.tacticType = TACTIC_Avoid
			elseif item.tactic_type == "Maneuver vehicle" then
				tactic.tacticType = TACTIC_Vehicle
			elseif item.tactic_type == "Force attack" then
				tactic.tacticType = TACTIC_ForceAttack
			elseif item.tactic_type == "Pick up slot items" then
				tactic.tacticType = TACTIC_Pickup
			elseif item.tactic_type == "Pick up team weapons" then
				tactic.tacticType = TACTIC_CaptureTeamWeapon
			elseif item.tactic_type == "Recrew vehicles" then
				tactic.tacticType = TACTIC_Recrew
			elseif item.tactic_type == "Rush at target" then
				tactic.tacticType = TACTIC_RushAtTarget
			end

			if item.tactic_setting == "High" then
				
				tactic.priority = 1000
				
			elseif item.tactic_setting == "Medium" then
				
				tactic.priority = 500
				
			elseif item.tactic_setting == "Low" then
				
				tactic.priority = 200
				
			elseif item.tactic_setting == "Never" then
				
				tactic.priority = -1

			elseif item.tactic_setting == "Manual" then
				
				tactic.priority = item.tactic_priority
				tactic.maxUsers = item.tactic_maxusers
				tactic.maxRange = item.tactic_maxrange
				tactic.retryTimeSecs = item.tactic_retrytime
				tactic.waitTimeSecs = item.tactic_waittime
				tactic.timeoutTimeSecs = item.tactic_timeout
				tactic.useInitialWaitTime = item.tactic_useinitialwaittime
				
			end
			
			table.insert(goal.tacticControlsList, tactic)
			
		end		
		
	end
	
	if instance.when_to_spawn == "Immediately" then
		
		instance.data.encounterID = Encounter:Create(encounter)
		
	elseif instance.when_to_spawn == "Use trigger zone" then
		
		PrefabHelper_StandardTriggerSystem(instance)
		
	elseif instance.when_to_spawn == "Manually" then
		
		-- do nothing
		
	end
	
end



--? @args Table/String instance
--? @shortdesc Spawn the encounter in this instance (i.e. if it was set to trigger manually)
function simpledefendencounter_Trigger(data)	-- in this context, "Trigger" means "Spawn"

	local instance = Prefab_GetInstance(data)
	
	if instance.data.hasTriggered == false then

		instance.data.hasTriggered = true

		instance.data.encounterID = Encounter:Create(instance.data.encounter)
		
	end
	
end


--? @args Table/String instance
--? @shortdesc Start the goal for the encounter in this instance (i.e. if the goal was set to trigger manually)
function simpledefendencounter_TriggerGoal(data)

	local instance = Prefab_GetInstance(data)
	
	if instance.data.encounterID ~= nil and instance.data.encounterID:HasGoal() == false then
		instance.data.encounterID:SetGoal(instance.data.goal)
	end
	
end


-- Stop the encounter associated with this instance
function simpledefendencounter_Stop(data)

	local instance = Prefab_GetInstance(data)

	instance.data.encounterID:Disable()
	
end


--? @args Table/String instance
--? @shortdesc Get the encounterID of the encounter spawned by this instance
--? @result encounterID
function simpledefendencounter_GetEncounterID(data)

	local instance = Prefab_GetInstance(data)

	return instance.data.encounterID
	
end



--? @args Table/String instance
--? @shortdesc Get the encounterID of the encounter spawned by this instance
--? @result encounterID
function SimpleDefendEncounter_GetEncounterID(data)

	local instance = Prefab_GetInstance(data)

	return instance.data.encounterID
	
end