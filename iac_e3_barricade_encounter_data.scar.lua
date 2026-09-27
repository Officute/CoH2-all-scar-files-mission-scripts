-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- E3 Barricade/Beta City17 - Encounter data
-- Designer: Dr.Epav, with a bunch of help from Janne252
-- 
--
--
-------------
-- Old attack
-------------
--~
--~		-- Spawn wave
--~		Util_DelayRandom(1, 2, function()
--~			Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_counterattack}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), park_counterattack_spawnpoints, park_counterattack_destinations, 1, World_GetRand(4, 5), true)
--~			Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_counterattack}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), park_counterattack_spawnpoints, park_counterattack_destinations, 1, World_GetRand(4, 5), true)
--~		end)
--~		
--~		Util_DelayRandom(3, 4, function()
--~			Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_counterattack}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), park_counterattack_spawnpoints, park_counterattack_destinations, 1, World_GetRand(4, 5), true)
--~			Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_counterattack}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), park_counterattack_spawnpoints, park_counterattack_destinations, 1, World_GetRand(4, 5), true)
--~			---------------------------
--~			-- Start combat plan -- Similar to an encounter, but a bit more independent and script-friendly
--~			SGroup_AddAbility(sg_enemy_park_counterattack, BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_move_grenadier")) 
--~			-- SGroup_SetMoveType(sg_enemy_park_counterattack, BP_GetMoveTypeBlueprint("def_stance_test_move"))
--~			
--~			--local sbp = BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17")	
--~			--local loadout = World_GetRand(3, 5)
--~			local rand = World_GetRand(1, table.getn(t_CombatPlanBarricade))
--~			local Combat_Plan_Park = t_CombatPlanBarricade[rand]
--~		
--~			SGroup_AddGroups(sg_enemy_park_targets, {sg_ally_park_01, sg_ally_park_02, sg_player_all})
--~			CombatPlan_Add(sg_enemy_park_counterattack, Plan_Test, sg_enemy_park_targets)
--~			---------------------------
--~		end)

--********************************************************************************************************
---------------------------------------- ENCOUNTER UTIL FUNCTIONS ----------------------------------------
--********************************************************************************************************

function RetryGoal(enc)
	local goalData = enc:GetGoalData()
	
	if(goalData and scartype(goalData.target) == ST_SGROUP and SGroup_CountSpawned(goalData.target) > 0) then
		enc:RestartGoal()
	end
end

function Despawn(enc)
	if(SGroup_CountSpawned(enc.sgroup) > 0) then
		enc:RemoveOnDeath(true)
		SGroup_DestroyAllSquads(enc.sgroup)
	end
end

function _IsEncounterActive(enc)
	return enc ~= nil and enc:IsAlive() and enc:IsEnabled()
end

--~function ReplaceUnitLimited(unit)
--~	if _MaxAttackSquads then
--~		local enc = unit.encounter
--~		
--~		enc:AddUnit(unit.data)
--~		
--~		if(not enc:Goal_HasValidObjective()) then
--~			enc:RestartGoal()
--~		end
--~	end
--~end
--~
--~	_MaxAttackSquads = (SGroup_CountSpawned(sg_currentAttackers) < g_encounter_limited_respawn)

--------------------------------
---- Set encounter AI settings
--------------------------------
	
	g_defaultGoalData_attackEasy = {
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 5,
				retryTimeSecs = 8,
				waitTimeSecs = 10,
			},
			{
				tacticType = TACTIC_Vehicle,
				priority = -1,
			},
			{
				tacticType = TACTIC_RushAtTarget,
				priority = -1,
			},
		},
	}
	
	g_defaultGoalData_attackHard = {
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 10,
				retryTimeSecs = 10,
				waitTimeSecs = 5,
			},
			{
				tacticType = TACTIC_Vehicle,
				priority = 10,
				retryTimeSecs = 10,
				waitTimeSecs = 20,
			},
			{
				tacticType = TACTIC_RushAtTarget,
				priority = 1,
				retryTimeSecs = 10,
				waitTimeSecs = 20,
			},
		},
	}
	
	g_defaultGoalData_defendHard = {
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 5,
				retryTimeSecs = 15,
				waitTimeSecs = 10,
			},
			{
				tacticType = TACTIC_ForceAttack,
				priority = 5,
				retryTimeSecs = 15,
				waitTimeSecs = 5,
			},
			{
				tacticType = TACTIC_Vehicle,
				priority = 5,
				retryTimeSecs = 15,
				waitTimeSecs = 25,
			},
			{
				tacticType = TACTIC_RushAtTarget,
				priority = -1,
			},
		},
	}
	
	g_defaultGoalData_defendEasy = {
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = -1,
				retryTimeSecs = 16,
				waitTimeSecs = 8,
			},
			{
				tacticType = TACTIC_ForceAttack,
				priority = 5,
				retryTimeSecs = 20,
				waitTimeSecs = 10,
			},
			{
				tacticType = TACTIC_Vehicle,
				priority = -1,
			},
			{
				tacticType = TACTIC_RushAtTarget,
				priority = -1,
			},
		},
	}
	
-----------------------
-- Tatic Modifiers
-----------------------

	g_disableCoverTactic = {
		{
			tacticType = TACTIC_Cover,
			priority = -1,
		},
	}
	
	g_reduceCoverTactic = {
		{
			tacticType = TACTIC_Cover,
			priority = 1,
			retryTimeSecs = 25,
			waitTimeSecs = 15,
		},
	}
	
	g_ampCoverTactic = {
		{
			tacticType = TACTIC_Cover,
			priority = 90,
			retryTimeSecs = 5,
			waitTimeSecs = 1,
		},
		{
			tacticType = TACTIC_RushAtTarget,
			priority = -1,
		},
	}
	
	g_disableForceAttackTactic = {
		{
			tacticType = TACTIC_ForceAttack,
			priority = -1,
		},
	}
	
	g_ampForceAttackTactic = {
		{
			tacticType = TACTIC_ForceAttack,
			priority = 80,
			retryTimeSecs = 5,
			waitTimeSecs = 1,
		},
	}
	
	g_RushAtTargetTactic = {
		{
			tacticType = TACTIC_RushAtTarget,
			priority = 25,
		},
	}
	
	g_disableVehicleTactic = {
		{
			tacticType = TACTIC_Vehicle,
			priority = -1,
		},
		{
			tacticType = TACTIC_Retaliate,
			priority = -1,
		},
		{
			tacticType = TACTIC_Help,
			priority = -1,
		},
	}

	-- AIBaseGoal_SetDefaultGoalData(t_defaultGoalData_attackEasy)
	-- AIBaseGoal_SetDefaultGoalData(t_defaultGoalData_attackHard)
	
--------------------------------
ENCOUNTERS = {}

--********************************************************************************************************
----------------------------------------- PARK COUNTERATTACK ---------------------------------------------
--********************************************************************************************************
------------
-- WAVE 1 --
------------

ENCOUNTERS.Park_Counterattack_Startwave = function()

	if useEncounterSystem == true then
		local encData = {
			name = "Park_Wave1", 
			spawn = mkr_enemy_spawn_park_b03, 
			dynamicSpawnTarget = park_counterattack_destinations,
			player = player4,
			sgroups = {sg_enemy_all, sg_enemy_park_counterattack},
			units = {
			{
				name = "Grenadier_p_w1_01", 
				sbp = BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"),
				load = Park_Counterattack_loadout01,
				attackMoveTo = true,
			},
			{
				name = "Grenadier_p_w1_02", 
				sbp = BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"),
				load = Park_Counterattack_loadout01,
				attackMoveTo = true,
			},
		},
	}
		encID_Park_Wave1 = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			target = park_counterattack_targets,
			useSkirmishAI = g_useSkirmishAI,
			leashRange = 40,
			range = 50,
			maxIdleTime = 10,
			attackMove = true,
			safeMoveWeight = 0.1,
			movePathLengthFactor = 1.1,
			tacticControlsList = g_RushAtTargetTactic,
			tacticTargetPreference = AITacticTargetPreference_Near,
			
			abilityControlsList = {
				{
					abilityPBG = BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_grenadier_rifle_grenade"),
					maxCasters = 1,
					maxRange = 40,
					waitTimeSecs = 20,
				},
				{
					abilityPBG = BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_grenade"),
					maxCasters = 1,
					maxRange = 30,
					waitTimeSecs = 15,
				},
			},
			fallback = true,
			fallbackParams = {
				thresholds = {0.1},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_enemy_spawn_park_b01, mkr_enemy_spawn_park_b02, mkr_enemy_spawn_park_b03},
				retreat = true,
				retreatDespawn = true,
			},
			
			coordinatedSetup = false,
			-- onSuccess = FrontLineBrokenLeft,
		}
		encID_Park_Wave1:SetGoal(goalData)
	
	else
		Util_DelayRandom(1, 2, function()
			Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_counterattack}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), park_counterattack_spawnpoints, park_counterattack_destinations, 1, Park_Counterattack_loadout01, true)
			-- Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_counterattack}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), park_counterattack_spawnpoints, park_counterattack_destinations, 1, Park_Counterattack_loadout01, true)
		end)
		
		Util_DelayRandom(3, 4, function()
			Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_counterattack}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), park_counterattack_spawnpoints, park_counterattack_destinations, 1, Park_Counterattack_loadout01, true)
			-- Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_counterattack}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), park_counterattack_spawnpoints, park_counterattack_destinations, 1, Park_Counterattack_loadout01, true)
		end)
		--------------------------------
	end
	if g_hardDiff == true then
		Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_counterattack}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), park_counterattack_spawnpoints, park_counterattack_destinations, 1, Park_Counterattack_loadout01, true)
	end
	mod_accuracy_park_wave1 = Modify_WeaponAccuracy(sg_enemy_park_counterattack, "hardpoint_01", g_accuracy_park_wave1)
	Rule_AddOneShot(Park_Counterattack_wave2, Park_Counterattack_wave2_delay, 900)
end

------------
-- WAVE 2 --
------------

ENCOUNTERS.Park_Counterattack_wave2 = function()

	if useEncounterSystem == true then
		local encData = {
			name = "Park_Wave2", 
		--~ spawn = park_counterattack_spawnpoints, 
			dynamicSpawnTarget = park_counterattack_destinations,
			player = player4,
			sgroups = {sg_enemy_all, sg_enemy_park_counterattack, sg_enemy_park_counterattack_wave2},
			units = {
			{
				name = "Grenadier_p_w2_01", 
				sbp = BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"),
				load = Park_Counterattack_loadout02,
				spawn = mkr_enemy_spawn_park_b01,
				attackMoveTo = true,
				
			},
			{
				name = "Grenadier_p_w2_02", 
				sbp = BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"),
				load = Park_Counterattack_loadout02,
				spawn = mkr_enemy_spawn_park_b02,
			--~ upgrades = UPG.GERMAN.GRENADIER_MG42_LMG,
			},
			{
				name = "Grenadier_p_w2_03", 
				sbp = BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"),
				load = Park_Counterattack_loadout02,
				spawn = mkr_enemy_spawn_park_b03,
				attackMoveTo = true,
			},
		--{
		--	name = "APC_p_w2_03", 
        --  sbp = BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:puma_apc_city17"),
		--},
		},
	}
		encID_Park_Wave2 = Encounter:Create(encData, true, true)
		
		local goalData = {
			name = "Attack",
			target = park_counterattack_target,
			useSkirmishAI = g_useSkirmishAI,
			leashRange = 45,
			range = 55,
			maxIdleTime = 12,
			attackMove = true,
			safeMoveWeight = 0.1,
			movePathLengthFactor = 1.1,
			tacticControlsList = g_ampForceAttackTactic,
			tacticTargetPreference = AITacticTargetPreference_Near,
			
			abilityControlsList = {
				{
					abilityPBG = BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_grenadier_rifle_grenade"),
					maxCasters = 1,
					maxRange = 45,
					waitTimeSecs = 20,
				},
				{
					abilityPBG = BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_grenade"),
					maxCasters = 1,
					maxRange = 30,
					waitTimeSecs = 10,
				},
			},
			fallback = true,
			fallbackParams = {
				thresholds = {0.05},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_enemy_spawn_park_b01, mkr_enemy_spawn_park_b02, mkr_enemy_spawn_park_b03},
				retreat = true,
				retreatDespawn = true,
			},
		}
		encID_Park_Wave2:SetGoal(goalData)
		print("Counterattack wave 2 spawned")
	else
		--------------------------------
		Util_DelayRandom(1, 2, function()
			Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_counterattack, sg_enemy_park_counterattack_wave2}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), park_counterattack_spawnpoints, park_counterattack_destinations, 1, Park_Counterattack_loadout02, true)
			Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_counterattack, sg_enemy_park_counterattack_wave2}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), park_counterattack_spawnpoints, park_counterattack_destinations, 1, Park_Counterattack_loadout02, true)
		end)
		
		Util_DelayRandom(3, 4, function()
			Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_counterattack, sg_enemy_park_counterattack_wave2}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), park_counterattack_spawnpoints, park_counterattack_destinations, 1, Park_Counterattack_loadout02, true)
		end)
		print("Counterattack wave 2 spawned")
		--------------------------------
	end
	Modifier_Remove(mod_accuracy_park_wave1)
	Util_CreateSquads(player3, {sg_enemy_all, sg_enemy_park_counterattack}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"), park_counterattack_spawnpoints, park_counterattack_destinations, 1, Park_Counterattack_loadout02, true)
	mod_accuracy_park_wave2 = Modify_WeaponAccuracy(sg_enemy_park_counterattack, "hardpoint_01", g_accuracy_park_wave2)
	mod_rec_damage_park_wave2 = Modify_ReceivedDamage(sg_enemy_park_counterattack, g_rec_damage_park_wave2, false)
	Rule_AddOneShot(Park_Counterattack_wave3, Park_Counterattack_wave3_delay, 700)
	
end

ENCOUNTERS.Park_Counterattack_wave2_veh = function()

	if useEncounterSystem == true then
		local encData = {
			name = "Park_Wave2veh", 
			spawn = mkr_enemy_spawn_park_bvehicle,
			dynamicSpawnTarget = park_counterattack_destinations,
			player = player4,
			sgroups = {sg_enemy_all, sg_enemy_park_counterattack, sg_enemy_park_counterattack_veh},
			units = {
			{
				name = "Osttruppen_p_w2_01", 
				sbp = BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:osttruppen_squad_city17"),
				load = Park_Counterattack_loadout02,
			},
			{
				name = "APC_p_1", 
                sbp = BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:puma_apc_city17"),
			--~ conditions = {_CheckPlayerState, _MaxVehicles},
			},
		},
	}
		encID_Park_Wave2_veh = Encounter:Create(encData, true, true)
		
		local goalData = {
			name = "Attack",
			target = park_counterattack_targets,
			useSkirmishAI = g_useSkirmishAI,
			leashRange = 35,
			range = 40,
			maxIdleTime = 14,
			attackMove = true,
			safeMoveWeight = 0.0,
			movePathLengthFactor = 1.2,
			tacticControlsList = g_disableCoverTactic,
			tacticTargetPreference = AITacticTargetPreference_Near,
			
			abilityControlsList = {
				{
					abilityPBG = BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_grenade"),
					maxCasters = 1,
					maxRange = 35,
					waitTimeSecs = 10,
				},
			},
		}
		encID_Park_Wave2_veh:SetGoal(goalData)
		print("Counterattack wave 2 vehicle spawned")
	end
	-- Modifier_Remove(mod_accuracy_park_wave2)
	
end

ENCOUNTERS.Park_Counterattack_wave2_veh_easy = function()

	if useEncounterSystem == true then
		local encData = {
			name = "Park_Wave2veh", 
			spawn = mkr_enemy_spawn_park_bvehicle,
			dynamicSpawnTarget = park_counterattack_destinations,
			player = player4,
			sgroups = {sg_enemy_all, sg_enemy_park_counterattack, sg_enemy_park_counterattack_veh},
			units = {
			{
				name = "APC_p_1", 
                sbp = BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:puma_apc_city17"),
			--~ conditions = {_CheckPlayerState, _MaxVehicles},
			},
		},
	}
		encID_Park_Wave2_veh = Encounter:Create(encData, true, true)
		
		local goalData = {
			name = "Attack",
			target = park_counterattack_targets,
			useSkirmishAI = g_useSkirmishAI,
			leashRange = 35,
			range = 40,
			maxIdleTime = 18,
			attackMove = true,
			safeMoveWeight = 0.0,
			movePathLengthFactor = 1.2,
			tacticControlsList = g_disableCoverTactic,
			tacticTargetPreference = AITacticTargetPreference_Near,
			
			abilityControlsList = {
				{
					abilityPBG = BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_grenade"),
					maxCasters = 1,
					maxRange = 35,
					waitTimeSecs = 10,
				},
			},
		}
		encID_Park_Wave2_veh:SetGoal(goalData)
		print("Counterattack wave 2 vehicle spawned")
	end
	-- Modifier_Remove(mod_accuracy_park_wave2)
	
end

------------
-- WAVE 3 --
------------
function Park_Counterattack_wave3() ENCOUNTERS.Park_Counterattack_wave3() end

ENCOUNTERS.Park_Counterattack_wave3 = function()

	if useEncounterSystem == true then
		local encData = {
			name = "Park_Wave3", 
		--~ spawn = park_counterattack_spawnpoints, 
			dynamicSpawnTarget = park_counterattack_destinations,
			player = player4,
			sgroups = {sg_enemy_all, sg_enemy_park_counterattack},
			units = {
			{
				name = "Grenadier_p_w3_01", 
				sbp = BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"),
				load = Park_Counterattack_loadout02,
				spawn = park_counterattack_spawnpoints,
				attackMoveTo = true,
			},
			{
				name = "Grenadier_p_w3_02", 
				sbp = BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"),
				load = Park_Counterattack_loadout01,
				spawn = park_counterattack_spawnpoints,
				attackMoveTo = true,
			},
		--{
		--	name = "APC_p_w2_03", 
        --  sbp = BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:puma_apc_city17"),
		--},
		},
	}
		encID_Park_Wave3 = Encounter:Create(encData, true, true)
		
		local goalData = {
			name = "Attack",
			target = park_counterattack_target,
			useSkirmishAI = false,
			leashRange = 45,
			range = 50,
			maxIdleTime = 12,
			attackMove = true,
			safeMoveWeight = 0.1,
			movePathLengthFactor = 1.1,
			tacticControlsList = g_ampForceAttackTactic,
			tacticTargetPreference = AITacticTargetPreference_Near,
			
			abilityControlsList = {
				{
					abilityPBG = BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_grenade"),
					maxCasters = 1,
					maxRange = 30,
					waitTimeSecs = 20,
				},
			},
			fallback = true,
			fallbackParams = {
				thresholds = {0.5},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_enemy_spawn_park_b01, mkr_enemy_spawn_park_b02, mkr_enemy_spawn_park_b03},
				retreat = true,
				retreatDespawn = false,
			},
		}
		encID_Park_Wave3:SetGoal(goalData)
	
	end
	Modifier_Remove(mod_accuracy_park_wave2)
	mod_accuracy_park_wave3 = Modify_WeaponAccuracy(sg_enemy_park_counterattack, "hardpoint_01", g_accuracy_park_wave1)
	
end

--********************************************************************************************************
--------------------------------------------- TRAINSTATION -----------------------------------------------
--********************************************************************************************************
---------------
-- DEFENDERS --
---------------

ENCOUNTERS.Trainstation_Defenders = function()

	if useEncounterSystem == true then
		local encData = {
			name = "Trainstation_Defenders", 
			--~	dynamicSpawnTarget = mkr_enemy_target_train,
			player = player4,
			sgroups = {sg_enemy_all, sg_enemy_trainstation_ai},
			units = {
			{
				name = "Grenadier_t_d01", 
				sbp = BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"),
				load = Trainstation_loadout02,
				spawn = mkr_enemy_spawn_train_entry_01,
				dynamicSpawnTarget = mkr_enemy_target_train_01,
				attackMoveTo = true,
			},
			{
				name = "Grenadier_t_d02", 
				sbp = BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"),
				load = Trainstation_loadout01,
				spawn = mkr_enemy_spawn_train_entry_01,
				dynamicSpawnTarget = mkr_enemy_target_train_02,
				attackMoveTo = true,
				--~	if g_hardDiff == true then
				upgrades = BP_GetUpgradeBlueprint("312430cd68d346ad8badb0bc1ef14b77:rpg_guided_hl2_upgrade_lowac"),
				--~	else
				--~	upgrades = BP_GetUpgradeBlueprint("panzerbusche_39"),
				--~	end
			},
			{
				name = "Grenadier_t_d03", 
				sbp = BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"),
				load = Trainstation_loadout01,
				spawn = mkr_enemy_spawn_train_entry_02,
				dynamicSpawnTarget = mkr_enemy_target_train_03,
				attackMoveTo = true,
			},
			{
				name = "Grenadier_t_d04", 
				sbp = BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"),
				load = Trainstation_loadout02,
				spawn = mkr_enemy_spawn_train_entry_02,
				dynamicSpawnTarget = mkr_enemy_target_train_04,
				attackMoveTo = true,
			},
		},
	}
		encID_Trainstation_Defenders = Encounter:Create(encData, true, true)
		
		local goalData = {
			name = "Defend",
			target = mkr_enemy_target_train_defend,
			--~	useSkirmishAI = g_useSkirmishAI,
			leashRange = 25,
			range = 35,
			maxIdleTime = 18,
			tacticCloseGround = 0.0,
			--~	attackMove = true,
			safeMoveWeight = 0.0,
			movePathLengthFactor = 1.1,
			tacticControlsList = g_reduceCoverTactic,
			tacticTargetPreference = AITacticTargetPreference_Near,
			--~	maxAttackers = 2,
			coordinatedSetup = false,
			
			abilityControlsList = {
				{
					abilityPBG = BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_grenadier_rifle_grenade"),
					maxCasters = 1,
					maxRange = 35,
					waitTimeSecs = 20,
				},
				{
					abilityPBG = BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_grenade"),
					maxCasters = 1,
					maxRange = 25,
					waitTimeSecs = 10,
				},
			},
			fallback = true,
			fallbackParams = {
				thresholds = {0.15},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_enemy_spawn_train_entry_01, mkr_enemy_spawn_train_entry_02},
				retreat = true,
				retreatDespawn = true,
			},
		}
		encID_Trainstation_Defenders:SetGoal(goalData)
		print("Trainstation Defenders spawned")
	else
		--------------------------------
		Util_DelayRandom(1, 2, function()
			Util_CreateSquads(player4, {sg_enemy_all, sg_enemy_trainstation_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_train_entry_01, mkr_enemy_target_train, 1, Trainstation_loadout02, true)
			Util_CreateSquads(player4, {sg_enemy_all, sg_enemy_trainstation_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_train_entry_01, mkr_enemy_target_train, 1, Trainstation_loadout02, true)
		end)
		
		Util_DelayRandom(3, 4, function()
			Util_CreateSquads(player4, {sg_enemy_all, sg_enemy_trainstation_01}, BP_GetSquadBlueprint("312430cd68d346ad8badb0bc1ef14b77:grenadier_squad_city17"), mkr_enemy_spawn_train_entry_02, mkr_enemy_target_train, 1, Trainstation_loadout02, true)
		end)
		print("Trainstation Defenders spawned")
		--------------------------------
	end
	-- Modify damage
	Modify_WeaponDamage(sg_enemy_trainstation_ai, "hardpoint_01", g_damage_trainstation_2)
	
end
