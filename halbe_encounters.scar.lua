-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Encounter/Goal data for M13_Halbe
-- Designer: Andres Molina
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
--[[ INTRO ROAD ]]
-------------------------------------------------------------------------
function EncTown()
	sg_townDefenses = SGroup_CreateIfNotFound("sg_townDefenses")
	g_townEncounters = {}
	
	Util_CreateSquads(player2, sg_townDefenses, SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD, mkr_townPak43)
	
	--Town HMG's
	local positions = Marker_GetSequence("mkr_townHMG")
	for i=1, #positions do
		local encData = {
			name = "townHMG_" .. i,
			sgroups = {sg_townDefenses},
			spawn = positions[i],
			moveTo = positions[i],
			units = {
				{
					sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				},
			},
		}
		local enc = Encounter:Create(encData)
		
		table.insert(g_townEncounters, enc)
		
		Event_PlayerCanSeeElement(_EngageStationaryWeapon, enc, player1, enc.sgroup, ANY, 2)
	end
	
	--Town AT's
	positions = Marker_GetSequence("mkr_townAT")
	for i=1, #positions do
		local encData = {
			name = "townHMG_" .. i,
			sgroups = {sg_townDefenses},
			spawn = positions[i],
			units = {
				{
					sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
				},
			},
		}
		local enc = Encounter:Create(encData)
		
		table.insert(g_townEncounters, enc)
		
		Event_PlayerCanSeeElement(_EngageStationaryWeapon, enc, player1, enc.sgroup, ANY, 2)
	end
	
	--HMG's in bldgs
	local bldgs = EGroup_GetSequence("eg_townBldg")
	for i=1, #bldgs do
		local hmg = Util_CreateSquads(player2, "townHold"..i, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, bldgs[i])
		Event_OnHealth(_DisableHold, {group = bldgs[i]}, hmg, 0.0, false)
		SGroup_AddGroup(sg_townDefenses, hmg)
	end
	
	mod_townDamage = Modify_WeaponDamage(sg_townDefenses, "hardpoint_01", 1.7)
	mod_townHealth = Modify_ReceivedDamage(sg_townDefenses, 0.4)
	mod_townHold = Modify_DisableHold(eg_disableHold, true)
end

function EncRoadblock()
	local encData = {
		name = "roadblock",
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_roadblock1,
				upgrades = UPG.GERMAN.GRENADIER_MG42_LMG,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = eg_guardpost,
				upgrades = UPG.GERMAN.GRENADIER_MG42_LMG,
			},
			{
				sbp = g_diffVariableSBP,
				spawn = mkr_roadblock2,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_roadblock5,
				difficulty = GD_EASY,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_roadblock5,
				upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM,
				difficulty = {GD_NORMAL, GD_HARD}
			},
		},
	}
	enc_roadblock = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_roadblock,
		range = mkr_roadblock,
		leashRange = mkr_roadblock,
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {mkr_roadblock1, mkr_tankDest1, mkr_117},
	}
	enc_roadblock:SetGoal(goalData)
	enc_roadblock:Disable()
end

function RoadAT()
	sg_roadAT = SGroup_CreateIfNotFound("sg_roadAT")
	
	local encData = {
		name = "roadAT",
		sgroups = {sg_roadAT},
		spawn = mkr_pak43,
		units = {
			{
				sbp = SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD,		
			},
		},
	}
	enc_roadAT1 = Encounter:Create(encData)
	
	local encData = {
		name = "roadAT",
		sgroups = {sg_roadAT},
		spawn = mkr_roadblock4,
		units = {
			{
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
			},
		},
	}
	enc_roadAT2 = Encounter:Create(encData)
	
	Event_PlayerCanSeeElement(_EngageStationaryWeapon, enc_roadAT1, player1, enc_roadAT1.sgroup, ANY, 1)
	Event_IsUnderAttack(_EngageStationaryWeapon, enc_roadAT2, enc_roadAT2.sgroup, ANY, 2, nil, 1)
end

function EncAttackRoad()
	local encData = {
		name = "attackRoad1",
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_htDest1,
				slotItems = Util_DifVar({nil, SLOT_ITEM.GRENADIER_MG42_LMG}, g_difficulty),
				moveTo = Marker_GetPosition(mkr_tankDest2)
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_htDest2,
				moveTo = Marker_GetPosition(mkr_tankDest1)
			},
		},
	}
	enc_attackRoad1 = Encounter:Create(encData)
	
	
	local encData = {
		name = "attackRoad2",
		spawn = mkr_roadblock6,
		units = {
			g_diffVariableSBP,
		},
	}
	enc_attackRoad2 = Encounter:Create(encData)
end

function StartAttackRoad()
	local goalData = {
		name = "Move",
		target = mkr_118,
		range = 5,
		coordinatedSetup = false,
		attackMove = true,
		movePathLengthFactor = 1.0,
		onSuccess = AttackPlayerStart,
	}
	enc_attackRoad1:SetGoal(goalData)
	
	local goalData = {
		name = "Move",
		target = mkr_117,
		range = 5,
		coordinatedSetup = false,
		attackMove = true,
		movePathLengthFactor = 1.0,
		onSuccess = AttackPlayerStart
	}
	enc_attackRoad2:SetGoal(goalData)
end

function AttackPlayerStart(enc)
	local goalData = {
		name = "Attack",
		target = mkr_playerDest5,
		range = 20,
		leashRange = 33,
		coordinatedSetup = false,
		movePathLengthFactor = 1.0,
		attackMove = true,
	}
	enc:SetGoal(goalData)
end

function EncReinforceRoadblock()
	local encData = {
		name = "reinforceRoadblock",
		units = {
			{
				sbp = g_diffVariableSBP,
				spawn = mkr_htSpawn,
				dynamicSpawnTarget = trg_tankBattle,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_tankSpawn,
				dynamicSpawnTarget = mkr_eTankDest,
			}
		},
	}
	
	if(not enc_roadblock:IsAlive() and g_difficulty > GD_EASY) then
		local unit = {
			sbp = SBP.GERMAN.GRENADIER_SQUAD,
			spawn = mkr_tankSpawn,
			dynamicSpawnTarget = mkr_eTankDest,
			upgrades = Util_DifVar({nil, nil, UPG.GERMAN.LIGHT_INFANTRY_PACKAGE}, g_difficulty)
		}
		table.insert(encData.units, unit)
	end
	
	enc_reinforceRoadblock = Encounter:Create(encData)
	
	
	local goalData = {
		name = "Attack",
		target = mkr_roadblock,
		range = mkr_roadblock,
		leashRange = mkr_roadblock,
		coordinatedSetup = false,
	}
	enc_reinforceRoadblock:SetGoal(goalData)
end

function PantherAttack()
	sg_tankBattle = SGroup_CreateIfNotFound("sg_tankBattle")
	sg_panther = SGroup_CreateIfNotFound("sg_panther")
	
	local encData = {
		name = "tankBattle",
		sgroups = {sg_tankBattle},
		units = {
			{
				sgroups = {sg_panther},
				sbp = SBP.GERMAN.PANTHER_SQUAD,
				spawn = mkr_tankSpawn,
				moveTo = mkr_eTankDest,
			},
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD,
				upgrades = UPG.GERMAN.PANZER_TOP_GUNNER,
				spawn = mkr_htSpawn,
				moveTo = mkr_ht1Dest,
				difficulty = {GD_NORMAL, GD_HARD}
			},
			{
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
				upgrades = UPG.GERMAN.SDKFZ_222_20MM_GUN_MP,
				spawn = mkr_htSpawn,
				moveTo = mkr_ht1Dest,
				difficulty = GD_EASY,
			},
		},
	}
	enc_tankBattle = Encounter:Create(encData)
	
	Util_CreateSquads(player2, nil, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, mkr_htSpawn2, mkr_ht2Dest, nil, nil, true)
	
	Event_Proximity(EngagePanther, nil, sg_panther, mkr_eTankDest, 5, ANY, Util_DifVar({30, 20, 15}, g_difficulty))
end

function EngagePanther()
	if(SGroup_Count(sg_tankBattle) > 0) then
		local goalData = {
			name = "Attack",
			target = mkr_eTankDest,
			leashRange = 35,
			range = 40,
		}
		enc_tankBattle:SetGoal(goalData)
	end
end



-------------------------------------------------------------------------
--[[ NORTHERN ENCOUNTERS ]]
-------------------------------------------------------------------------
function EncN1()
	local encData = {
		name = "enc_N1",
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_n1_1
			},
		},
	}
	enc_n1 = Encounter:Create(encData)
	
	
	local goalData = {
		name = "Defend",
		target = mkr_encN1,
		range = 35,
		leashRange = 27,
		coordinatedSetupFacingPositions = {mkr_n1Target},
		fallbackParams = {
			thresholds = {0.20},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_panzerNorth},
		},
		onFailure = Despawn,
	}
	enc_n1:SetGoal(goalData)
	
	if(g_difficulty >= GD_NORMAL) then
		Util_CreateSquads(player2, nil, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_n1_3)
	end
	sg_runnerN1 = Util_CreateSquads(player2, "sg_runnerN1", SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_n1_2, nil, nil, 4)
	
	Event_ElementOnScreen(_RunAway, {group = sg_runnerN1, dest = mkr_encN3}, player1, sg_runnerN1, ANY, 0.8, 3)
end

function BreachN1()
	--Stug from north. Pgrens on south ridge.
	local encData = {
		name = "stugBreachN1",
		spawn = mkr_townEntry6,
		moveTo = mkr_encN1,
		attackMoveTo = true,
		units = {
			{
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
				difficulty = {GD_NORMAL, GD_HARD}
			},
			{
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
				entityUpgrades = UPG.GERMAN.SDKFZ_222_20MM_GUN,
				difficulty = GD_EASY,
			},
		},
		engageGoalData = {
			name = "Attack",
			target = mkr_encN1,
			range = 30,
			leashRange = 25,
			attackMove = true,
		},
	}
	enc_stugN1 = Encounter:Create(encData)
	
	Event_IsEngaged(_EngageGoal, {encounter = enc_stugN1}, enc_stugN1.sgroup, ANY, 2, 3)
	
	
	local encData = {
		name = "breachN1",
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_ridgeN2,
				dynamicSpawnTarget = mkr_ridgeN1,
				difficulty = GD_NORMAL
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_ridgeN2,
				dynamicSpawnTarget = mkr_ridgeN1,
				upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM,
				difficulty = GD_HARD
			},
		},
	}
	enc_breachN1 = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = mkr_encN1,
		range = 25,
		leashRange = 25,
		coordinatedSetup = false,
	}
	enc_breachN1:SetGoal(goalData)	
end

function EncN2()
	local encData = {
		name = "enc_N2",
		spawn = mkr_encN2,
		units = {
			{
				sbp = g_diffVariableSBP,
				spawn = mkr_n2_1,
			},
		},
	}
	enc_n2 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_encN2,
		range = 30,
		leashRange = 15,
		tacticCoverPriority = -1,
		fallbackParams = {
			thresholds = {0.26},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_panzerNorth},
			retreat = true,
		},
		onFailure = Despawn,
	}
	enc_n2:SetGoal(goalData)
	
	sg_runnersN2 = Util_CreateSquads(player2, "sg_runnersN2", SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_n2_2)
	Event_OnHealth(_RunAway, {group = sg_runnersN2, dest = mkr_panzerNorth}, sg_runnersN2, 0.9, false, 2)
end

function RidgeN()
	if(g_difficulty >= GD_NORMAL) then
		Util_CreateSquads(player2, nil, SBP.GERMAN.MORTAR_TEAM_81MM, mkr_encN5, mkr_n5_1)
	end
	
	if(g_difficulty >= GD_HARD) then
		Util_CreateSquads(player2, nil, SBP.GERMAN.SNIPER_SQUAD, Util_FindHiddenSpawn(mkr_encN5, mkr_n5_1), mkr_ridgeN3, nil, nil, true)
	end
end

function EncN7()
	--AT GUN
	local encData = {
		name = "n7_AT",
		spawn = mkr_n7_1,
		units = {
			{
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
			},
		},
	}
	enc_n7_AT = Encounter:Create(encData)
	Event_PlayerCanSeeElement(_EngageStationaryWeapon, enc_n7_AT, player1, enc_n7_AT.sgroup, ANY, Util_DifVar({10, 6, 3}, g_difficulty))
	
	--HMG
	if(g_difficulty >= GD_HARD) then
		Util_CreateSquads(player2, nil, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_panzerNorth, mkr_hmgN7)
	end
	Util_CreateSquads(player2, nil, SBP.GERMAN.GRENADIER_SQUAD, eg_towerN7, nil, nil, nil, nil, nil, UPG.GERMAN.GRENADIER_MG42_LMG)
	
	--INFANTRY
	local encData = {
		name = "enc_N7",
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_n7_2,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_panzerNorth,
				veterancyRank = g_difficulty+1,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_townEntry6,
			},
		},
	}
	enc_n7 = Encounter:Create(encData)
	--Once the encounter on the road is seen, engage encounter and bring in troops through the northern (Right) road.
	Event_ElementOnScreen(TriggerN7, nil, player1, enc_n7.sgroup, ANY, 0.8, 2)
end

function TriggerN7()
	local n7GoalData = {
		name = "Defend",
		target = trg_reinforceNorth,
		range = 35,
		leashRange = 25,
		coordinatedSetup = false,
	}
	if(enc_n7:IsAlive()) then
		enc_n7:SetGoal(n7GoalData)
	end
	
	--Send in trucks and coward troops that simply run towards the town
	sg_runnersN7 = SGroup_CreateIfNotFound("runnersN7")
	Util_CreateSquads(player2, sg_runnersN7, SBP.GERMAN.OPEL_BLITZ_SQUAD, mkr_mapEntryNorth1, nil, 2)
	Modify_UnitSpeed(sg_runnersN7, 0.9)
	Util_CreateSquads(player2, sg_runnersN7, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_mapEntryNorth1, nil, nil, 4)
	Cmd_MoveToAndDespawn(sg_runnersN7, mkr_trainyard)
end

function ReinforceNorth()
	local encData = {
		name = "enc_reinforcementsNorth",
		spawn = mkr_townEntry6,
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				abilityBlacklist = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				upgrades = UPG.GERMAN.LIGHT_INFANTRY_PANZERGREN_PACKAGE,
				difficulty = {GD_NORMAL, GD_HARD}
			},
			{
				sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
				spawn = mkr_mapEntryNorth1,
			},			
		},
	}
	enc_reinforceNorth = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = trg_reinforceNorth,
		range = 35,
		leashRange = 28,
		coordinatedSetup = false,
		movePathLengthFactor = 1.0,
		safeMoveWeight = 0.0,
		abilityControlsList = {
			{
				abilityPBG = ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY,
				maxCasters = 1,
				waitTimeSecs = 18,
			},
			{
				abilityPBG = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
				maxCasters = 1,
				waitTimeSecs = 35,
			},
		},
		fallbackParams = {
			thresholds = {0.15},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_townEntry6},
			retreat = true,
		},
		onFailure = Despawn,
	}
	enc_reinforceNorth:SetGoal(goalData)	
	
	sg_panzerNorth = Util_CreateSquads(player2, "sg_panzerNorth", SBP.GERMAN.OSTWIND_SQUAD, mkr_townEntry6, mkr_panzerNorth)
	Event_PlayerCanSeeElement(EventHandler_StartIntel, {intel_callback = EVENTS.InformPanzerNorth}, player1, sg_panzerNorth)
	Event_Proximity(EngagePanzerNorth, nil, sg_panzerNorth, trg_reinforceNorth, nil, ANY, 2)
end

function EngagePanzerNorth()
	UI_CreateMinimapBlip(mkr_panzerNorth, 9, BT_General)
	
	if(enc_reinforceNorth:IsAlive() and SGroup_CountSpawned(sg_panzerNorth) > 0) then
		enc_reinforceNorth:AddSgroup(sg_panzerNorth)
	end
end

function EncN10()
	local encData = {
		name = "enc_N10",
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_n8_1,
				slotItems = SLOT_ITEM.GRENADIER_MG42_LMG,
				abilityBlacklist = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_n8_2,
				abilityBlacklist = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_n8_3,
				upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM
			},			
		},
	}
	enc_n10 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_encN10,
		range = 35,
		leashRange = mkr_encN10,
		coordinatedSetupFacingPositions = {mkr_panzerNorth, mkr_n8_4},
		abilityControlsList = {
			{
				abilityPBG = ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY,
				maxCasters = 1,
				waitTimeSecs = 18,
			},
			{
				abilityPBG = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
				maxCasters = 1,
				waitTimeSecs = 25,
			},
			{
				abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_GRENADE,
				maxCasters = 1,
				waitTimeSecs = 18,
			},
		},
		fallbackParams = {
			thresholds = {0.33},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_145},
			retreat = true,
		},
		onFailure = Despawn,
	}
	enc_n10:SetGoal(goalData)	
	
	--AT gun
	local encData = {
		name = "enc10_AT",
		spawn = mkr_n8_AT,
		units = {
			SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD
		},
	}
	enc_n10_AT = Encounter:Create(encData)
	Event_PlayerCanSeeElement(_EngageStationaryWeapon, enc_n10_AT, player1, enc_n10_AT.sgroup, ANY, 2)
	
	--HMG
	local encData = {
		name = "enc10_HMG",
		spawn = mkr_n8_hmg,
		units = {
			SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD
		},
	}
	enc_n10_HMG = Encounter:Create(encData)
	Event_PlayerCanSeeElement(_EngageStationaryWeapon, enc_n10_HMG, player1, enc_n10_HMG.sgroup, ANY, 2)
	
	Event_ElementOnScreen(StartTrafficNorth2, nil, player1, mkr_125, nil, 0.99)
end

--Periodically spawns a set of "runners" on the top-right entrance to the map.
function StartTrafficNorth2()
	t_trafficEntryNorth2 = {
		{
			sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
			loadout = 4,
			attack = false,
		},
		{
			sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
			health = 0.35,
			attack = false,
		},
		{
			sbp = SBP.GERMAN.MORTAR_TEAM_81MM,
			attack = false,
		},
		{
			sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
			health = 0.6,
			attack = true,
		},
		{
			sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
			loadout = 2,
			attack = true,
		},
		{
			sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
			loadout = 3,
			attack = false,
		},
		{
			sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
			loadout = 3,
			attack = true,
		},
		{
			sbp = SBP.GERMAN.M01_MG42_HEAVY_MACHINE_GUN_SQUAD_SINGLE,
			loadout = 2,
			attack = false,
		},
	}
--~ 	view(t_trafficEntryNorth2) --Debug
	
	Rule_AddDelayedInterval(SpawnTrafficNorth2, 0.5, 4)
end

function SpawnTrafficNorth2()
	if(#t_trafficEntryNorth2 > 0) then
		local encData = {
			name = "runnerN10",
			spawn = mkr_entryNorth2,
			units = {
				{
					sbp = t_trafficEntryNorth2[1].sbp,
					load = t_trafficEntryNorth2[1].loadout,
				},
			},
		}
		local enc_runnerNorth2 = Encounter:Create(encData)
		
		if(t_trafficEntryNorth2[1].health) then
			SGroup_SetAvgHealth(enc_runnerNorth2.sgroup, t_trafficEntryNorth2[1].health)
		end
		
		if(t_trafficEntryNorth2[1].attack) then
			AttackN10(enc_runnerNorth2)
		else
			MoveToTown(enc_runnerNorth2)
		end
		
		table.remove(t_trafficEntryNorth2, 1)
	else
		Rule_RemoveMe()
	end
end

function AttackN10(enc)
	local goalData = {
		name = "Attack",
		target = mkr_125,
		range = 30,
		leashRange = 30,
		maxIdleTime = 13,
		onSuccess = MoveToTown,
	}
	enc:SetGoal(goalData)
end

function MoveToTown(enc)
	local goalData = {
		name = "Move",
		target = mkr_escapeNorth,
		range = 15,
		attackMove = false,
		maxIdleTime = 10,
		onSuccess = Despawn,
	}
	enc:SetGoal(goalData)
end


function EncRail()
	local encData = {
		name = "enc_rail",
		units = {
			{
				sbp = SBP.GERMAN.MORTAR_TEAM_81MM,
				spawn = mkr_126,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_rail,
			},
		},
	}
	enc_rail = Encounter:Create(encData)
	
	Event_ElementOnScreen(RailVehicleAttack, nil, player1, enc_rail.sgroup, ANY, 0.9)
	
	--Attackers that advance on sight
	local encData = {
		name = "enc_railAttack",
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_338,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_mortarDest,
				upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_escapeNorth,
			},
		},
	}
	enc_railAttack = Encounter:Create(encData)
	Event_PlayerCanSeeElement(RailwayAttack, enc_railAttack, player1, enc_railAttack.sgroup, ANY, 1)
		
	--AT gun
	local encData = {
		name = "rail_AT",
		spawn = mkr_rail,
		units = {
			SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD
		},
	}
	enc_rail_AT = Encounter:Create(encData)
	Event_PlayerCanSeeElement(_EngageStationaryWeapon, enc_rail_AT, player1, enc_rail_AT.sgroup, ANY, 2)
	
	--HMG
	if(EGroup_CountSpawned(eg_bldg2) > 0) then
		sg_railHMG = Util_CreateSquads(player2, "sg_railHMG", SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, eg_bldg2)
	end
end

function RailwayAttack()
	local goalData = {
		name = "Attack",
		target = mkr_housesRailway,
		range = 30,
		leashRange = 22,
		coordinatedSetup = false,
		fallbackParams = {
			thresholds = {0.20},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_exitNorth},
			retreat = true,
		},
		maxIdleTime = -1,
		onFailure = Despawn,
	}
	enc_railAttack:SetGoal(goalData)
end

function RailVehicleAttack()
	sg_mortarHT = SGroup_CreateIfNotFound("mortarHT")
	
	local encData = {
		name = "railStug",
		spawn = Util_GetPositionFromAtoB(mkr_townEntry5, mkr_road1, 30),
		units = {
			{
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
				upgrades = UPG.GERMAN.STUG_TOP_GUNNER,
			},
			{
				sbp = SBP.GERMAN.MORTAR_250_HALFTRACK_SQUAD,
				sgroups = {sg_mortarHT},
				spawn = Util_GetPositionFromAtoB(mkr_townEntry5, mkr_road1, 45),
			},
		},
	}
	enc_stugRail = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = mkr_escapeNorth,
		leashRange = 35,
	}
	enc_stugRail:SetGoal(goalData)
	
	Event_PlayerCanSeeElement(EventHandler_StartIntel, {intel_callback = EVENTS.InformMortarHT}, player1, sg_mortarHT, ANY, 1)
end

function EscapeAttemptNorth()
	local encData = {
		name = "escapeAttemptNorth",
		spawn = trg_gateCheck2,
		dynamicSpawnTarget = mkr_exitNorth,
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				onDeath = ReplaceUnit,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				onDeath = ReplaceUnit,
			},
		},
	}
	enc_attemptNorth = Encounter:Create(encData)
	
	_AttackNorthExit(enc_attemptNorth)
end



-------------------------------------------------------------------------
--[[ SOUTHERN ENCOUNTERS ]]
-------------------------------------------------------------------------
function Treeline()
	--Top
	local encData = {
		name = "treelineTop",
		spawn = mkr_107,
		dynamicSpawnTarget = mkr_135,
		units = {
			SBP.GERMAN.GRENADIER_SQUAD,
		},
	}
	enc_treelineTop = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_135,
		range = 30,
		leashRange = mkr_135,
		abilityBlacklist = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
		fallbackParams = {
			thresholds = {0.51},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_107},
			retreat = true,
		},
		onFailure = Despawn,
	}
	enc_treelineTop:SetGoal(goalData)

	--Center (HMG)
	sg_treelineHMG = Util_CreateSquads(player2, "treelineHMG", SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, Util_FindHiddenSpawn(mkr_107, mkr_encS1), mkr_encS1)
	Event_OnHealth(_RunAway, {group = sg_treelineHMG, dest = mkr_107}, sg_treelineHMG, 0.35, false, 1)
	
	Event_PlayerCanSeeElement(EngageTreeline, nil, player1, {enc_treelineTop.sgroup, sg_treelineHMG}, ANY)
end

function EngageTreeline()
	Util_StartIntel(EVENTS.InformTreeline)
	UI_CreateMinimapBlip(sg_treelineHMG, 9, BT_AttackHere)

	--Attack the player
	local encData = {
		name = "treelineBottom",
		spawn = mkr_106,
		dynamicSpawnTarget = mkr_134,
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				upgrades = Util_DifVar({nil, nil, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM}, g_difficulty),
			}
		},
	}
	enc_treelineBottom = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = trg_treeline,
		range = 30,
		leashRange = 20,
		fallbackParams = {
			thresholds = {0.26},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_106},
		},
	}
	enc_treelineBottom:SetGoal(goalData)
end

function South2()
	sg_s2Top2 = Util_CreateSquads(player2, "sg_s2Top2", SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_108)
	Event_OnHealth(_RunAway, {group = sg_s2Top2, dest = mkr_townEntry2}, sg_s2Top2, 0.8)
	
	sg_s2Top = Util_CreateSquads(player2, "sg_s2Top", SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_107)
	Event_OnHealth(_RunAway, {group = sg_s2Top, dest = mkr_townEntry2}, sg_s2Top, 0.55)
	event_attackS2Top = Event_IsEngaged(S2_Attack, {pos = mkr_107}, sg_s2Top, ANY, 2)
	
	sg_s2Middle = Util_CreateSquads(player2, "sg_s2Middle", SBP.GERMAN.GRENADIER_SQUAD, mkr_162)
	Event_OnHealth(_RunAway, {group = sg_s2Middle, dest = mkr_167}, sg_s2Middle, 0.33)
	event_attackS2Middle = Event_IsEngaged(S2_Attack, {pos = mkr_162}, sg_s2Middle, ANY, 2)
	
	sg_hmgS2 = Util_CreateSquads(player2, "sg_hmgS2", SBP.GERMAN.GRENADIER_SQUAD, mkr_encS2, nil, nil, nil, nil, nil, UPG.GERMAN.GRENADIER_MG42_LMG)
	Event_OnHealth(_RunAway, {group = sg_hmgS2, dest = mkr_167}, sg_hmgS2, 0.33)
	event_attackS2HMG = Event_IsEngaged(S2_Attack, {pos = mkr_encS2}, sg_hmgS2, ANY, 2)
	
	g_s2Attacked = false
end

function S2_Attack(data)
	if(g_s2Attacked) then return end --This prevents multiple attacks from being called in the event two events are triggered on the same frame.
	g_s2Attacked = true
	
	Event_Remove(event_attackS2Middle)
	Event_Remove(event_attackS2Top)
	Event_Remove(event_attackS2HMG)
	
	local encData = {
		name = "south2",
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM,
				spawn = mkr_167,
				dynamicSpawnTarget = mkr_166,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_163,
				dynamicSpawnTarget = mkr_106,
			}
		},
	}
	enc_s2_attack = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = data.pos,
		range = 30,
		leashRange = 17,
		coordinatedSetup = false,
		fallbackParams = {
			thresholds = {0.25},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_s4_at},
		},
		onFailure = Despawn,
	}
	enc_s2_attack:SetGoal(goalData)
end


function SouthHill()
	--HMG's
	Util_CreateSquads(player2, nil, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_hmgHill1, mkr_hmgHill1)
	if(g_difficulty >= GD_HARD) then
		Util_CreateSquads(player2, nil, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_hmgHill2, mkr_hmgHill2)
	else
		Util_CreateSquads(player2, nil, SBP.GERMAN.GRENADIER_SQUAD, mkr_hmgHill2, mkr_hmgHill2, nil, nil, nil, nil, UPG.GERMAN.GRENADIER_MG42_LMG)
	end
	
	--Runners
	sg_runnersS4 = Util_CreateSquads(player2, "runnersS4", SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_mortarS4)
	Event_OnHealth(_RunAway, {group = sg_runnersS4, dest = mkr_entrySouth1}, sg_runnersS4, 0.80)
	
	Event_ElementOnScreen(EventHandler_StartIntel, {intel_callback = EVENTS.InformHill}, player1, sg_runnersS4, ANY, 0.8, 1)
	
	
	--Hill defenders
	local encData = {
		name = "hillDefenders",
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_encS6,
				upgrades = UPG.GERMAN.LIGHT_INFANTRY_PACKAGE,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_encS8,
				dynamicSpawnTarget = mkr_hmgHill2,
				upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_townEntry2,
				dynamicSpawnTarget = mkr_truckSpawn,
			},
			{
				sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
				spawn = mkr_truckSpawn,
			},
		},
	}
	enc_hillDefenders = Encounter:Create(encData)
	Event_Proximity(EngageHillDefenders, nil, player1, trg_truckS4, nil, ANY, 5.0)
	
	
	--Stationary AI AT gun
	local encData = {
		name = "south4_AT",
		spawn = mkr_s4_at,
		units = {
			SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
		},
	}
	enc_s4_AT = Encounter:Create(encData)
	Event_IsEngaged(_EngageStationaryWeapon, enc_s4_AT, enc_s4_AT.sgroup, ANY, 3, Util_DifVar({3, 2, 1}, g_difficulty))
	
	if(g_difficulty >= GD_HARD) then
		sg_scoutS3 = Util_CreateSquads(player2, "sg_scoutS3", SBP.GERMAN.SCOUTCAR_SDKFZ222, mkr_mines3)
		Event_Proximity(TriggerScoutS3, nil, player1, trg_scoutS3, nil, ANY, 3.0)
	end
	
	sg_exitTruck = Util_CreateSquads(player2, "sg_exitTruck", SBP.GERMAN.OPEL_BLITZ_SQUAD, mkr_truckS4)
	Event_PlayerCanSeeElement(_RunAway, {group = sg_exitTruck, dest = mkr_entrySouth1}, player1, sg_exitTruck, ANY, 1.0)
end

function TriggerScoutS3()
	if(SGroup_IsAlive(sg_scoutS3)) then
		Cmd_AttackMove(sg_scoutS3, mkr_destScoutS3)
	end
end

function EngageHillDefenders()
	local goalData = {
		name = "Defend",
		target = mkr_mortarS4,
		range = 30,
		leashRange = 25,
		coordinatedSetup = false,
		fallbackParams = {
			thresholds = {0.31},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_entrySouth1},
			retreat = true,
		},
		maxIdleTime = -1,
		onFailure = Despawn,
	}
	
	if(enc_hillDefenders:IsAlive()) then
		enc_hillDefenders:SetGoal(goalData)
	end
end


function South6()
	Util_CreateSquads(player2, nil, SBP.GERMAN.SNIPER_SQUAD, mkr_sniperS8)

	sg_runnersS6 = Util_CreateSquads(player2, "runnersS6", SBP.GERMAN.GRENADIER_SQUAD, mkr_encS8)
	Event_OnHealth(_RunAway, {group = sg_runnersS6, dest = mkr_townEntry3}, sg_runnersS6, 0.55)

	local encData = {
		name = "ridgeS",
		spawn = mkr_ridgeS,
		units = {
			SBP.GERMAN.GRENADIER_SQUAD,
		},
	}
	enc_ridgeS = Encounter:Create(encData)
	Event_PlayerCanSeeElement(_EngageStationaryWeapon, enc_ridgeS, player1, enc_ridgeS.sgroup, ANY, 1)
	
	local encData = {
		name = "south6",
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_encS7,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_131,
			},
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD,
				spawn = mkr_tankS8,
				upgrades = UPG.GERMAN.PANZER_TOP_GUNNER,
			},
		},
	}
	enc_s6 = Encounter:Create(encData)

	event_ambushS6 = Event_Proximity(TriggerAmbushS6, {pos = mkr_ambushS6}, player1, trg_tankS6, nil, ANY)
	event_roadS6 = Event_Proximity(EngageS6, {pos = mkr_encS8}, player1, trg_tankS8, nil, ANY)
end

function TriggerAmbushS6(data)
	EngageS6(data)
	Event_ElementOnScreen(EventHandler_StartIntel, {intel_callback = EVENTS.InformValley}, player1, enc_s6.sgroup, ANY, 0.8, 1)
	UI_CreateMinimapBlip(data.pos, 9, BT_AttackHere)
end

function EngageS6(data)
	if(g_encS6Active) then return end
	g_encS6Active = true --Used to prevent both events from triggering it.
	
	local goalData = {
		name = "Attack",
		target = data.pos,
		range = 35,
		leashRange = 20,
		coordinatedSetup = false,
		attackMove = true,
		fallbackParams = {
			thresholds = {0.10},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_entrySouth2},
			retreat = true,
		},
		onFailure = Despawn,
	}
	enc_s6:SetGoal(goalData)
end

function DefendS6()
	local goalData = {
		name = "Defend",
		target = mkr_tankS8,
		range = 25,
		leashRange = 17,
		coordinatedSetup = false,
		attackMove = true,
		fallbackParams = {
			thresholds = {0.10},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_entrySouth2},
			retreat = true,
		},
		onFailure = Despawn,
	}
	if(enc_s6 ~= nil and enc_s6:IsAlive()) then
		enc_s6:SetGoal(goalData)
	end
end

function South7()
	local encData = {
		name = "south7",
		spawn = mkr_townEntry3,
		abilityBlacklist = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
		units = {
			SBP.GERMAN.GRENADIER_SQUAD,
			SBP.GERMAN.GRENADIER_SQUAD,
			{
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
				difficulty = GD_EASY,
			},
			{
				sbp = SBP.GERMAN.STUG_III_SQUAD,
				upgrades = UPG.GERMAN.STUG_TOP_GUNNER,
				difficulty = {GD_NORMAL, GD_HARD},
			}
		},
	}
	AI_SetStaggeredSpawnDelay(4.0)
	enc_south7 = Encounter:Create(encData, nil, true)
	
	local goalData = {
		name = "Attack",
		target = mkr_tankS8,
		movePathLengthFactor = 1.0,
		range = 35,
		leashRange = 28,
		coordinatedSetup = false,
	}
	enc_south7:SetGoal(goalData)
	
	--Additionally, send in South6 to assist
	DefendS6()
end

function SouthEsc()
	sg_partisans2 = Util_CreateSquads(player2, "sg_partisans2", BP_GetSquadBlueprint("partisan_squad_m13"), mkr_escapeSouth)
	
	sg_truckRoad = Util_CreateSquads(player2, "sg_truckRoad", SBP.GERMAN.OPEL_BLITZ_SQUAD, mkr_truckRoad)
	sg_truckRoad2 =	Util_CreateSquads(player2, "sg_truckRoad2", SBP.GERMAN.OPEL_BLITZ_SQUAD, mkr_truckRoad2)
	
	sg_partisans1 = Util_CreateSquads(player4, "sg_partisans1", SBP.SOVIET.M02_REFUGEE_SQUAD, mkr_172)
		Util_CreateSquads(player4, sg_partisans1, SBP.SOVIET.M02_REFUGEE_SQUAD, mkr_138)
	SGroup_EnableUIDecorator(sg_partisans1, false)
	
	Event_ElementOnScreen(MoveTrucksSouth, nil, player1, sg_truckRoad, ALL, 0.9, 4.0)
	Event_ElementOnScreen(_RunAway, {group = sg_truckRoad2, dest = mkr_exitSouth}, player1, sg_truckRoad2, ANY, 0.9, 6)
	Event_ElementOnScreen(TriggerSouthEsc, nil, player1, sg_partisans1, ANY, 0.9, 4.0)
end

function MoveTrucksSouth()
	Util_CreateSquads(player2, sg_truckRoad, SBP.GERMAN.OPEL_BLITZ_SQUAD, mkr_townEntry4, mkr_exitSouth)
	if(SGroup_CountSpawned(sg_truckRoad) > 0) then
		Cmd_MoveToAndDespawn(sg_truckRoad, mkr_exitSouth)
	end
	
	sg_runPartisans = Util_CreateSquads(player2, "sg_runPartisans", SBP.SOVIET.M02_REFUGEE_SQUAD, mkr_ATExitSouth, nil, 2)
	Cmd_Retreat(sg_runPartisans, mkr_exitSouth, mkr_exitSouth)
end

function TriggerSouthEsc()
	Util_StartIntel(EVENTS.Partisans1)
	
	UI_CreateMinimapBlip(mkr_138, 10, BT_AttackHere)
	
	if(SGroup_CountSpawned(sg_partisans1) > 0) then
		Cmd_MoveToAndDespawn(sg_partisans1, mkr_exitSouth)
	end

	if(SGroup_CountSpawned(sg_partisans2) > 0) then
		Cmd_Move(sg_partisans2, mkr_172)
	end
end

function EscapeAttemptSouth()
	local encData = {
		name = "escapeAttemptNorth",
		spawn = mkr_escSpawn3,
		dynamicSpawnTarget = mkr_exitSouth,
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				onDeath = ReplaceUnit,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				onDeath = ReplaceUnit,
			},
		},
	}
	enc_attemptSouth = Encounter:Create(encData)
	
	_AttackSouthExit(enc_attemptSouth)
end




-------------------------------------------------------------------------
--[[ BREAKOUT ATTEMPTS ]]
-------------------------------------------------------------------------
--Wave 1
function SpawnEscape1a()
	sg_currentEscapers = SGroup_CreateIfNotFound("sg_currentEscapers") --Debug.

	local encData = {
		name = "escape1a",
		sgroups = {sg_currentEscapers},
		units = {
			{
				sbp = (g_difficulty == GD_EASY and SBP.GERMAN.SCOUTCAR_SDKFZ222 or SBP.GERMAN.STUG_III_E_SQUAD),
				spawn = mkr_despawn1,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_escSpawn2,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_escSpawn0,
				upgrades = (g_failedAwareness and UPG.GERMAN.GRENADIER_MG42_LMG or nil)
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_escSpawn3,
			}
		},
	}
	enc_escape1a = Encounter:Create(encData, nil, true)
	
	
	local goalData = {
		name = "Attack",
		target = mkr_escapeSouth,
		range = 30,
		leashRange = 40,
		coordinatedSetup = false,
		movePathLengthFactor = 1.0,
		fallbackParams = {
			thresholds = {0.25},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_despawn1},
			retreat = true,
		},
		onTransition = _CheckRetreat,
		maxIdleTime = 10,
		onSuccess = EvacuateSouth,
		onFailure = Despawn,
	}
	enc_escape1a:SetGoal(goalData)
	
	
	--Sneak side encounter that tries to escape
	local encData = {
		name = "escape1bSneak",
		units = {
			{
				sbp = (g_failedAwareness and SBP.GERMAN.PANZER_GRENADIER_SQUAD or SBP.GERMAN.GRENADIER_SQUAD),
				spawn = mkr_escSpawn1,
			}
		}
	}
	enc_escape1bSneak = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = mkr_172,
		range = 20,
		leashRange = 20,
		safeMoveWeight = 0.55,
		fallbackParams = {
			thresholds = {0.25},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_escSpawn1},
			retreat = true,
		},
		onTransition = _CheckRetreat,
		onSuccess = EvacuateSouth,
		onFailure = Despawn,
	}
	enc_escape1bSneak:SetGoal(goalData)
	
	
	Util_StartIntel(EVENTS.Breakout_Inform1) --Warning on start
	UI_CreateMinimapBlip(mkr_pingSouth, 10, BT_AttackHere)
	
	--Once the player sees the first wave, send another encounter towards the railway
	Event_PlayerCanSeeElement(SpawnEscape1b, nil, player1, enc_escape1a.sgroup, ANY)
end

function SpawnEscape1b()
	sg_currentEscapers = SGroup_CreateIfNotFound("sg_currentEscapers") --Debug.
	
	--Direct assault
	local encData = {
		name = "escape1b",
		sgroups = {sg_currentEscapers},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_escSpawn4,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_escSpawn7,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_escSpawn6,
			},
			{
				sbp = (g_failedAwareness and SBP.GERMAN.STUG_III_SQUAD or SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD),
				spawn = mkr_escSpawn5,
			},
		},
	}
	if(g_failedAwareness) then
		local unit = {
			sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
			spawn = mkr_escSpawn7,
			upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM,
		}
		table.insert(encData.units, unit)
	end
	enc_escape1b = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = mkr_escapeNorth,
		range = 35,
		leashRange = mkr_escapeNorth,
		coordinatedSetup = false,
		fallbackParams = {
			thresholds = {0.1},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_escSpawn5},
			retreat = true,
		},
		maxIdleTime = 10,
		onTransition = _CheckRetreat,
		onSuccess = EvacuateNorth,
		onFailure = Despawn,
	}
	enc_escape1b:SetGoal(goalData)
	
	
	Event_PlayerCanSeeElement(EventHandler_StartIntel, {intel_callback = EVENTS.Breakout_Railway}, player1, enc_escape1b.sgroup, ANY)
end

--Civilians/Partisans
function SpawnCivilianEscape()
	sg_enemyTrucks = SGroup_CreateIfNotFound("sg_enemyTrucks")
	sg_currentEscapers = SGroup_CreateIfNotFound("sg_currentEscapers") --Debug.

	--[[Units in the North]]
	--Civilians
	sg_civiliansNorth = SGroup_CreateIfNotFound("sg_civiliansNorth")
	Util_CreateSquads(player4, sg_civiliansNorth, SBP.SOVIET.M02_REFUGEE_SQUAD, Util_FindHiddenSpawn(mkr_townAT2, mkr_housesRailway), mkr_exitNorth, nil, 6)
	Util_CreateSquads(player4, sg_civiliansNorth, SBP.SOVIET.M02_REFUGEE_SQUAD, Util_FindHiddenSpawn(mkr_escSpawn5, mkr_road1), mkr_exitNorth, nil, 5)
	Util_CreateSquads(player4, sg_civiliansNorth, SBP.SOVIET.M02_REFUGEE_SQUAD, Util_FindHiddenSpawn(mkr_escSpawn7, mkr_road1), mkr_exitNorth, nil, 6)
	mod_civiliansN = Util_ApplyModifier(sg_civiliansNorth, "posture_speed_modifier", -1.0, MUT_Addition)
	
	--Partisans
	sg_partisansNorth = SGroup_CreateIfNotFound("partisansNorth")
	Util_CreateSquads(player4, sg_partisansNorth, BP_GetSquadBlueprint("partisan_squad_m13"), Util_FindHiddenSpawn(mkr_townAT2, mkr_housesRailway), mkr_exitNorth, nil, 4)
	Util_CreateSquads(player4, sg_partisansNorth, BP_GetSquadBlueprint("partisan_squad_m13"), Util_FindHiddenSpawn(mkr_escSpawn5, mkr_road1), mkr_exitNorth, nil, 5)
	Util_CreateSquads(player4, sg_partisansNorth, BP_GetSquadBlueprint("partisan_squad_m13"), Util_FindHiddenSpawn(mkr_escSpawn7, mkr_road1), mkr_exitNorth, nil, 5)
	mod_partisansN = Util_ApplyModifier(sg_partisansNorth, "posture_speed_modifier", -1.0, MUT_Addition)
	
	SGroup_AddGroups(sg_currentEscapers, {sg_civiliansNorth, sg_partisansNorth})
	SGroup_EnableUIDecorator(sg_civiliansNorth, false)
	SGroup_EnableUIDecorator(sg_partisansNorth, false)
	FOW_RevealSGroupOnly(sg_civiliansNorth, 10)
	
	
	--[[Units in the South]]
	--Civilians
	sg_civiliansSouth = SGroup_CreateIfNotFound("sg_civiliansNorth")
	Util_CreateSquads(player4, sg_civiliansSouth, SBP.SOVIET.M02_REFUGEE_SQUAD, Util_FindHiddenSpawn(mkr_escSpawn0, mkr_pingSouth), mkr_exitSouth, nil, 6)
	Util_CreateSquads(player4, sg_civiliansSouth, SBP.SOVIET.M02_REFUGEE_SQUAD, Util_FindHiddenSpawn(mkr_escSpawn3, mkr_pingSouth), mkr_exitSouth, nil, 5)
	Util_CreateSquads(player4, sg_civiliansSouth, SBP.SOVIET.M02_REFUGEE_SQUAD, Util_FindHiddenSpawn(mkr_escSpawn2, mkr_ATExitSouth), mkr_exitSouth, nil, 5)
	mod_civiliansS = Util_ApplyModifier(sg_civiliansSouth, "posture_speed_modifier", -1.0, MUT_Addition)
	
	--Partisans
	sg_partisansSouth = SGroup_CreateIfNotFound("partisansSouth")
	Util_CreateSquads(player4, sg_partisansSouth, BP_GetSquadBlueprint("partisan_squad_m13"), Util_FindHiddenSpawn(mkr_escSpawn0, mkr_pingSouth), mkr_exitSouth, nil, 4)
	Util_CreateSquads(player4, sg_partisansSouth, BP_GetSquadBlueprint("partisan_squad_m13"), Util_FindHiddenSpawn(mkr_escSpawn3, mkr_pingSouth), mkr_exitSouth, nil, 5)
	Util_CreateSquads(player4, sg_partisansSouth, BP_GetSquadBlueprint("partisan_squad_m13"), Util_FindHiddenSpawn(mkr_escSpawn2, mkr_ATExitSouth), mkr_exitSouth, nil, 5)
	mod_partisansS = Util_ApplyModifier(sg_partisansSouth, "posture_speed_modifier", -1.0, MUT_Addition)
	
	SGroup_AddGroups(sg_currentEscapers, {sg_civiliansSouth, sg_partisansSouth})
	SGroup_EnableUIDecorator(sg_civiliansSouth, false)
	SGroup_EnableUIDecorator(sg_partisansSouth, false)
	FOW_RevealSGroupOnly(sg_civiliansSouth, 10)
	
	
	--Once the civilians are seen, trigger the intel event and engage the partisans
	Event_PlayerCanSeeElement(InformPartisans, nil, player1, {sg_civiliansNorth, sg_civiliansSouth}, ANY, 2)
end

function InformPartisans()
	Util_StartIntel(EVENTS.Civilians2)
	UI_CreateMinimapBlip(mkr_road1, 9, BT_DefendHere)
	UI_CreateMinimapBlip(mkr_pingSouth, 9, BT_DefendHere)
	
	Rule_Add(EnablePartisans)
end

function EnablePartisans()
	if(not Event_IsRunning(EVENTS.Civilians2) and not Event_IsQueued(EVENTS.Civilians2)) then
		Rule_RemoveMe()
		
		--Set civilians and partisans as enemies.
		--North
		SGroup_SetPlayerOwner(sg_civiliansNorth, player2)
		SGroup_SetPlayerOwner(sg_partisansNorth, player2)
		Modifier_Remove(mod_civiliansN)
		Modifier_Remove(mod_partisansN)
		SGroup_EnableUIDecorator(sg_civiliansNorth, true)
		SGroup_EnableUIDecorator(sg_partisansNorth, true)
		--Screams
		Sound_PlayOnSquad("streamed/speech_exertions/exertion_death_flame_female", sg_civiliansNorth)
		Sound_PlayOnSquad("streamed/speech_exertions/exertion_death_flame_male", sg_civiliansNorth)
		
		--South
		SGroup_SetPlayerOwner(sg_civiliansSouth, player2)
		SGroup_SetPlayerOwner(sg_partisansSouth, player2)
		Modifier_Remove(mod_civiliansS)
		Modifier_Remove(mod_partisansS)
		SGroup_EnableUIDecorator(sg_civiliansSouth, true)
		SGroup_EnableUIDecorator(sg_partisansSouth, true)
		--Screams
		Sound_PlayOnSquad("streamed/speech_exertions/exertion_death_flame_female", sg_civiliansSouth)
		Sound_PlayOnSquad("streamed/speech_exertions/exertion_death_flame_male", sg_civiliansSouth)
		
		
--~ 		--Opel Truck
--~ 		sg_enemyTrucks = Util_CreateSquads(player2, "sg_enemyTrucks", SBP.GERMAN.SCOUTCAR_SDKFZ222, mkr_despawn1)
--~ 		Cmd_InstantUpgrade(sg_enemyTrucks, BP_GetUpgradeBlueprint("disable_abandon_critical_squad"))
--~ 		Modify_UnitSpeed(sg_enemyTrucks, g_opelSpeed)
--~ 		Cmd_SquadPath(sg_enemyTrucks, "pth_escape2", true, LOOP_NONE, (g_failedAwareness and true or false), 0)
--~ 		SGroup_AddGroup(sg_currentEscapers, sg_enemyTrucks)
		
		
		
		--Turn partisans into encounters and engage
		enc_partisansNorth = Encounter:ConvertSgroup(sg_partisansNorth)
		
		local goalData = {
			name = "Attack",
			target = mkr_escapeNorth,
			range = 30,
			leashRange = mkr_escapeNorth,
			safeMoveWeight = 0.0,
			coordinatedSetup = false,
			fallbackParams = {
				thresholds = {0.20},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_escSpawn5},
				retreat = true,
			},
			maxIdleTime = 10,
			onTransition = _CheckRetreat,
			onSuccess = EvacuateNorth,
			onFailure = Despawn,
		}
		enc_partisansNorth:SetGoal(goalData)
		
		
		--Same thing, but for the south
		enc_partisansSouth = Encounter:ConvertSgroup(sg_partisansSouth)
		
		local goalData = {
			name = "Attack",
			target = mkr_escapeSouth,
			range = 28,
			leashRange = 30,
			safeMoveWeight = 0.0,
			coordinatedSetup = false,
			fallbackParams = {
				thresholds = {0.20},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_escSpawn3},
				retreat = true,
			},
			maxIdleTime = 10,
			onTransition = _CheckRetreat,
			onSuccess = EvacuateSouth,
			onFailure = Despawn,
		}
		enc_partisansSouth:SetGoal(goalData)
	end
end

--Wave 2
function SpawnEscape2()
	sg_enemyTrucks = SGroup_CreateIfNotFound("sg_enemyTrucks")
	sg_currentEscapers = SGroup_CreateIfNotFound("sg_currentEscapers") --Debug.
	
	AI_SetStaggeredSpawnDelay(6)
	
	_Escape2North()
	Event_PlayerCanSeeElement(_Escape2South, nil, player1, enc_escape2North.sgroup, ANY)
end

function _Escape2North()
	local encData = {
		name = "escape2North",
		sgroups = {sg_currentEscapers},
		units = {
			{
				sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
				spawn = trg_gateCheck2,
				upgrades = UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_escSpawn7,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_escSpawn6,
				slotItems = SLOT_ITEM.GRENADIER_MG42_LMG,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_escSpawn7,
			},
			{
				sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
				spawn = trg_gateCheck2,
			},
			{
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
				spawn = trg_gateCheck2,
			},
		},
	}
	enc_escape2North = Encounter:Create(encData, nil, true)
	
	local goalData = {
		name = "Attack",
		target = mkr_escapeNorth,
		range = 15,
		leashRange = 35,
		coordinatedSetup = false,
		fallbackParams = {
			thresholds = {0.15},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_escSpawn5},
			retreat = true,
		},
		maxIdleTime = 10,
		onTransition = _CheckRetreat,
		onFailure = Despawn,
		onSuccess = EvacuateNorth,
	}
	enc_escape2North:SetGoal(goalData)
end

function _Escape2South()
	local encData = {
		name = "escape2South",
		sgroups = {sg_currentEscapers},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_escSpawn1,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_escSpawn0,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_escSpawn3,
				numSquads = 2,
			},
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD,
				spawn = mkr_escSpawn2,
			},
			{
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
				spawn = mkr_escSpawn3,
			},
		},
	}
	encescape2South = Encounter:Create(encData, nil, true)
	
	local goalData = {
		name = "Attack",
		target = mkr_escapeSouth,
		range = 30,
		leashRange = 35,
		coordinatedSetup = false,
		fallbackParams = {
			thresholds = {0.15},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_despawn1},
			retreat = true,
		},
		maxIdleTime = 10,
		onTransition = _CheckRetreat,
		onSuccess = EvacuateSouth,
		onFailure = Despawn,
	}
	encescape2South:SetGoal(goalData)
end

--Wave 3
function SpawnEscape3()
	sg_currentEscapers = SGroup_CreateIfNotFound("sg_currentEscapers") --Debug.
	
	--Alert
	Util_StartIntel(EVENTS.Breakout_Attempt3)
	
	_Escape3North()
	_Escape3South()
end

function _Escape3North()	
	local encData = {
		name = "escape1_final",
		sgroups = {sg_currentEscapers},
		units = {
			{
				sbp = SBP.GERMAN.PANTHER_SQUAD,
				spawn = mkr_escSpawn5,
				upgrades = UPG.GERMAN.PANTHER_TOP_GUNNER,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_escSpawn6,
			},
			{
				name = "gren1",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				slotItems = (g_failedAwareness and SLOT_ITEM.GRENADIER_MG42_LMG or nil),
				spawn = mkr_escSpawn5,
			},
			{
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
				spawn = mkr_escSpawn7,
			},
			{
				name = "gren2",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_escSpawn4,
			},
			{
				sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
				spawn = mkr_escSpawn5,
			},
			{
				name = "panz1",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM,
				spawn = mkr_escSpawn4,
			},
			
		},
	}
	AI_SetStaggeredSpawnDelay(2.0)
	enc_escape3a = Encounter:Create(encData, true, true)
	
	local goalData = {
		name = "Attack",
		target = mkr_escapeNorth,
		leashRange = 35,
		coordinatedSetup = false,
		fallbackParams = {
			thresholds = {0.1},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_escSpawn5},
			retreat = true,
		},
		maxIdleTime = 10,
		onTransition = _CheckRetreat,
		onSuccess = EvacuateNorth,
		onFailure = Despawn,
	}
	enc_escape3a:SetGoal(goalData)
	
	
	Event_IsUnderAttack(_Escape3North_Side, nil, enc_escape3a.sgroup, ANY, 1)
end

function _Escape3North_Side()
	sg_currentEscapers = SGroup_CreateIfNotFound("sg_currentEscapers") --Debug.

	local encData = {
		name = "escape3SideNorth",
		sgroups = {sg_currentEscapers},
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_townAT2,
				dynamicSpawnTarget = mkr_housesRailway,
				upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_escSpawn7,
				dynamicSpawnTarget = mkr_hillRailway,
			},
		},
	}
	enc_escape3NorthSide = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = mkr_rail,
		range = 28,
		leashRange = 20,
		coordinatedSetup = false,
		fallbackParams = {
			thresholds = {0.1},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_escSpawn5},
			retreat = true,
		},
		attackMove = true,
		maxIdleTime = 10,
		onTransition = _CheckRetreat,
		onSuccess = EvacuateNorth,
		onFailure = Despawn,
	}
	enc_escape3NorthSide:SetGoal(goalData)
end

function _Escape3South()
	local encData = {
		name = "escape2_final",
		sgroups = {sg_currentEscapers},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_escSpawn3,
			},
			{
				name = "gren2",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				slotItems = SLOT_ITEM.GRENADIER_MG42_LMG,
				spawn = mkr_escSpawn3,
			},
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD,
				spawn = mkr_escSpawn3,
				upgrades = (g_difficulty == GD_HARD and UPG.GERMAN.PANZER_TOP_GUNNER or nil)
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_escSpawn1,
			},
			{
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
				spawn = mkr_escSpawn3,
			},
			{
				name = "panz2",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				upgrades = (g_failedAwareness and UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM or nil),
				spawn = mkr_escSpawn1,
			},
			{
				sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
				spawn = mkr_escSpawn2,
			},
			{
				sbp = (g_failedAwareness and SBP.GERMAN.STUG_III_SQUAD or SBP.GERMAN.STUG_III_E_SQUAD),
				spawn = mkr_despawn1,
				upgrades = UPG.GERMAN.STUG_TOP_GUNNER,
			},
			{
				sbp = SBP.GERMAN.OSTWIND_SQUAD,
				spawn = mkr_woodsRoad,
			}
		},
	}
	enc_escape3South = Encounter:Create(encData, nil, true)
	
	local goalData = {
		name = "Attack",
		target = mkr_escapeSouth,
		range = 15,
		leashRange = 35,
		coordinatedSetup = false,
		movePathLengthFactor = 1.2,
		fallbackParams = {
			thresholds = {0.1},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_despawn1},
			retreat = true,
		},
		maxIdleTime = 10,
		onTransition = _CheckRetreat,
		onSuccess = EvacuateSouth,
		onFailure = Despawn,
	}
	enc_escape3South:SetGoal(goalData)
	
	Event_IsUnderAttack(_Escape3South_Side, nil, enc_escape3South.sgroup, ANY, 1)
end

function _Escape3South_Side()
	sg_currentEscapers = SGroup_CreateIfNotFound("sg_currentEscapers") --Debug.

	local encData = {
		name = "escape3SideSouth",
		sgroups = {sg_currentEscapers},
		spawn = mkr_escSpawn0,
		dynamicSpawnTarget = mkr_woodsRoad,
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
			},
		},
	}
	enc_escape3SouthSide = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = mkr_road2,
		range = 28,
		leashRange = 20,
		coordinatedSetup = false,
		attackMove = true,
		fallbackParams = {
			thresholds = {0.1},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_escSpawn1},
			retreat = true,
		},
		maxIdleTime = 10,
		onTransition = _CheckRetreat,
		onSuccess = EvacuateSouth,
		onFailure = Despawn,
	}
	enc_escape3SouthSide:SetGoal(goalData)
end






-------------------------------------------------------------------------
-- UTIL FUNCTIONS
-------------------------------------------------------------------------
function Despawn(enc)
	enc:RemoveOnDeath(true)
	SGroup_DestroyAllSquads(enc.sgroup)
end

function ReplaceUnit(unit)
	local enc = unit.encounter
	if(enc:IsAlive()) then
		enc:AddUnit(unit.data)
		
		if(not enc:Goal_HasValidObjective()) then
			enc:RestartGoal()
		end
	end
end

--Used to assign a defend goal to an AT gun encounter.
function _EngageStationaryWeapon(enc)
	local goalData = {
		name = "Defend",
		target = enc.data.spawn,
		leashRange = 8,
		range = 38,
		coordinatedSetup = false,
		tacticControlsList = {
			{
				tacticType  = TACTIC_Cover,
				priority = -1,
			},
			{
				tacticType  = TACTIC_TeamWeapon,
				priority = 500,
				waitTimeSecs = 5,
			},
		},
		maxIdleTime = -1,
	}
	enc:SetGoal(goalData)
end

function _EngageGoal(data)
	local enc = data.encounter
	if(enc:IsAlive()) then
		enc:SetGoal(enc.data.engageGoalData)
	end
end

function _DisableHold(data)
	Modify_DisableHold(data.group, true)
end

function _RunAway(data)
	Cmd_Retreat(data.group, data.dest, data.dest)
end

function _RemoveModifier(data)
	Modifier_Remove(data.modifier)
end

function _CheckRetreat(enc, state)
	if(state == AIObjectiveStage_Fallback) then
		print("Encounter " .. enc.data.name .. " is retreating. Removing from sg_currentEscapers.")
		SGroup_RemoveGroup(sg_currentEscapers, enc.sgroup)
	end
end

function _AttackNorthExit(enc)
	local goalData = {
		name = "Attack",
		target = mkr_escapeNorth,
		range = 35,
		leashRange = mkr_escapeNorth,
		coordinatedSetup = false,
		fallbackParams = {
			thresholds = {0.1},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_escSpawn5},
			retreat = true,
		},
		maxIdleTime = 10,
		onSuccess = _ExitNorth,
		onFailure = Despawn,
	}
	enc:SetGoal(goalData)
end

function _ExitNorth(enc)
	enc:Disable()
	Cmd_MoveToAndDespawn(enc.sgroup, mkr_exitNorth)
end

function _AttackSouthExit(enc)
	local goalData = {
		name = "Attack",
		target = mkr_escapeSouth,
		range = 30,
		leashRange = 40,
		coordinatedSetup = false,
		fallbackParams = {
			thresholds = {0.33},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_despawn1},
			retreat = true,
		},
		maxIdleTime = 10,
		onSuccess = _ExitSouth,
		onFailure = Despawn,
	}
	enc:SetGoal(goalData)
end

function _ExitSouth(enc)
	enc:Disable()
	Cmd_MoveToAndDespawn(enc.sgroup, mkr_exitSouth)
end

