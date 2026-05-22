-- 1942 Vehicles --
-- German: Armored Car, Halftrack, Stug, Panzer IV
-- Soviet: Scout Car, Halftrack, T-70, T-34, KV-1, KV-8

------ Soviet defenders on the west side of the river -----
function Voronezh_WestBankEncounters()
	
	-- 1
	local WestBank_EncounterData = {
		name = "WestBank1",
		player = player4,
		spawn = mkr_westBank1,
		sgroups = {sg_e_all},
		units = {
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD_MP,
				spawn = mkr_westBank1,
			},
			{
				sbp = SBP.SOVIET.T_34_76_SQUAD_MP,
				spawn = mkr_westBank1,
			},
		},
		onDeath = nil,  
	}
	local WestBank_GoalData = {
		name = "Defend",
		target = mkr_westBank1,
		leashRange = 50,
		range = 75,
		coordinatedSetup = true,
		tacticTargetPreference = AITacticTargetPreference_Best,
		coordinatedSetupFacingPositions = {
			mkr_p1_baseEntrance,
		},
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = 100,
			},
			{
				tacticType = TACTIC_Recrew,
				priority = 50,
			},
			{
				tacticType = TACTIC_Pickup,
				priority = 25,
			},
			{
				tacticType = TACTIC_Vehicle,
				maxUsers = 1,
				maxRange = 10,
				retryTimeSecs = 45,
				waitTimeSecs = 22,
				useInitialWaitTime = true,
				priority = 1,
			},
			{
				tacticType = TACTIC_Avoid,
				priority = -1,
			},
		},
	}
	encID_westBank1 = Encounter:Create(WestBank_EncounterData)
	table.insert(t_AItoUnlock, encID_westBank1)
	encID_westBank1:SetGoal(WestBank_GoalData)
	
	-- 2
	
	WestBank_EncounterData.name = "WestBank2"
	WestBank_EncounterData.spawn = mkr_westBank2
	WestBank_EncounterData.units = {
		{
			sbp = SBP.SOVIET.CONSCRIPT_SQUAD_MP,
			spawn = mkr_westBank2,
		},
		{
			sbp = SBP.SOVIET.T_70M_MP,
			spawn = mkr_westBank2,
		},
		{
			sbp = SBP.SOVIET.T_70M_MP,
			spawn = mkr_westBank2_2,
		}, 
	}
	WestBank_GoalData.target = mkr_westBank2
	WestBank_GoalData.coordinatedSetupFacingPositions = {mkr_p1_baseEntrance}
	WestBank_GoalData.tacticTargetPreference = AITacticTargetPreference_Near
	encID_westBank2 = Encounter:Create(WestBank_EncounterData)
	table.insert(t_AItoUnlock, encID_westBank2)
	encID_westBank2:SetGoal(WestBank_GoalData)
	
	-- 3
	
	WestBank_EncounterData.name = "WestBank3"
	WestBank_EncounterData.spawn = mkr_westBank3
	WestBank_EncounterData.units = {
		{
			sbp = SBP.SOVIET.GUARDS_TROOPS_MP,
			spawn = mkr_westBank3,
		},
		{
			sbp = SBP.SOVIET.T_34_76_SQUAD,
			spawn = mkr_westBank3,
		},
	}
	
	WestBank_GoalData.target = mkr_westBank3
	WestBank_GoalData.leashRange = 35
	WestBank_GoalData.coordinatedSetupFacingPositions = {mkr_p1_baseEntrance}
	WestBank_GoalData.tacticTargetPreference = AITacticTargetPreference_Best
	encID_westBank3 = Encounter:Create(WestBank_EncounterData)
	table.insert(t_AItoUnlock, encID_westBank3)
	encID_westBank3:SetGoal(WestBank_GoalData)
	
	-- 4
	
	WestBank_EncounterData.name = "WestBank4"
	WestBank_EncounterData.spawn = mkr_westBank4
	WestBank_EncounterData.units = {
		{
			sbp = SBP.SOVIET.T_34_76_SQUAD_MP,
			spawn = mkr_westBank4,
		},
		{
			sbp = SBP.SOVIET.GUARDS_TROOPS_MP,
			upgrades = {UPG.SOVIET.GUARD_DP_28_LMG_PACKAGE_MP},
			spawn = mkr_westBank4,
		},
	}
	
	WestBank_GoalData.target = mkr_westBank4
	WestBank_GoalData.leashRange = 50
	WestBank_GoalData.coordinatedSetupFacingPositions = {mkr_p1_baseEntrance}
	WestBank_GoalData.tacticTargetPreference = AITacticTargetPreference_Near
	encID_westBank4 = Encounter:Create(WestBank_EncounterData)
	table.insert(t_AItoUnlock, encID_westBank4)
	encID_westBank4:SetGoal(WestBank_GoalData)

	-- 5
	
	WestBank_EncounterData.player = player3
	WestBank_EncounterData.name = "WestBank5"
	WestBank_EncounterData.spawn = mkr_westBank5
	WestBank_EncounterData.units = {
		{
			sbp = SBP.SOVIET.CONSCRIPT_SQUAD_MP,
			numSquads = 2,
			spawn = mkr_westBank5,
		},
		{
			sbp = SBP.SOVIET.KV_1_MP,
			spawn = mkr_westBank5,
		},
		{
			sbp = SBP.SOVIET.T_70M_MP,
			spawn = mkr_westBank5,
		},
	}
	
	WestBank_GoalData.target = mkr_westBank5
	WestBank_GoalData.coordinatedSetupFacingPositions = {mkr_p1_baseEntrance}
	WestBank_GoalData.tacticTargetPreference = AITacticTargetPreference_LowHealth
	encID_westBank5 = Encounter:Create(WestBank_EncounterData)
	table.insert(t_AItoUnlock, encID_westBank5)
	encID_westBank5:SetGoal(WestBank_GoalData)	
	
	-- 6
	
	WestBank_EncounterData.name = "WestBank6"
	WestBank_EncounterData.spawn = mkr_westBank6
	WestBank_EncounterData.units = {
		{
			sbp = SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD_MP,
			spawn = mkr_westBank6,
		},
		{
			sbp = SBP.SOVIET.T_34_76_SQUAD_MP,
			spawn = mkr_westBank6,
		},
	}
	
	WestBank_GoalData.target = mkr_westBank6
	WestBank_GoalData.fallbackParams = {
		retreat = false,
		markers = {Marker_FromName("mkr_westBank5", "")},
		thresholds = {0.5},
		thresholdType = Threshold_PercentageEntitiesRemaining,
	}
	WestBank_GoalData.coordinatedSetupFacingPositions = {mkr_p1_baseEntrance}
	WestBank_GoalData.tacticTargetPreference = AITacticTargetPreference_LowHealth
	encID_westBank6 = Encounter:Create(WestBank_EncounterData)
	table.insert(t_AItoUnlock, encID_westBank6)
	encID_westBank6:SetGoal(WestBank_GoalData)	
	
	-- 7
	
	WestBank_EncounterData.name = "WestBank7"
	WestBank_EncounterData.spawn = mkr_westBank7
	WestBank_EncounterData.units = {
		{
			sbp = SBP.SOVIET.GUARDS_TROOPS_MP,
			spawn = mkr_westBank7,
		},
		{
			sbp = SBP.SOVIET.T_70M_MP,
			spawn = mkr_westBank7,
		},
		{
			sbp = SBP.SOVIET.T_34_76_SQUAD_MP,
			spawn = mkr_westBank7,
		},
	}
	
	WestBank_GoalData.target = mkr_westBank7
	WestBank_GoalData.fallbackParams = {
		retreat = false,
		markers = {Marker_FromName("mkr_westBank7_fallback", "")},
		thresholds = {0.4},
		thresholdType = Threshold_PercentageEntitiesRemaining,
	}
	WestBank_GoalData.coordinatedSetupFacingPositions = {mkr_p1_baseEntrance}
	WestBank_GoalData.tacticTargetPreference = AITacticTargetPreference_HighDamage
	encID_westBank7 = Encounter:Create(WestBank_EncounterData)
	table.insert(t_AItoUnlock, encID_westBank7)
	encID_westBank7:SetGoal(WestBank_GoalData)	
	
	-- 8
	
	WestBank_EncounterData.name = "WestBank8"
	WestBank_EncounterData.spawn = mkr_westBank8
	WestBank_EncounterData.units = {
		{
			sbp = SBP.SOVIET.T_34_76_SQUAD_MP,
			spawn = mkr_westBank8,
		},
		{
			sbp = SBP.SOVIET.T_34_76_SQUAD_MP,
			spawn = mkr_westBank8_2,
		},
	}
	if AI_IsEnabled(player1) then
		WestBank_EncounterData.units[2] = nil 
	end
	WestBank_GoalData.target = mkr_westBank8
	WestBank_GoalData.fallbackParams = {
		retreat = false,
		markers = {Marker_FromName("mkr_westBank8_fallback", "")},
		thresholds = {0.6},
		thresholdType = Threshold_PercentageEntitiesRemaining,
	}
	WestBank_GoalData.coordinatedSetupFacingPositions = {mkr_p1_baseEntrance}
	WestBank_GoalData.tacticTargetPreference = AITacticTargetPreference_Best
	encID_westBank8 = Encounter:Create(WestBank_EncounterData)
	table.insert(t_AItoUnlock, encID_westBank8)
	encID_westBank8:SetGoal(WestBank_GoalData)	
	
	-- 9
	
	WestBank_EncounterData.name = "WestBank9"
	WestBank_EncounterData.spawn = mkr_westBank9
	WestBank_EncounterData.units = {
		{
			sbp = SBP.SOVIET.SHOCK_TROOPS_MP,
			spawn = mkr_westBank9,
		},
	}
	WestBank_GoalData.target = mkr_westBank9
	WestBank_GoalData.fallbackParams = nil
	WestBank_GoalData.range = 35
	WestBank_GoalData.leashRange = 22
	encID_westBank9 = Encounter:Create(WestBank_EncounterData)
	table.insert(t_AItoUnlock, encID_westBank9)
	encID_westBank9:SetGoal(WestBank_GoalData)		
	
	-- 10
	
	WestBank_EncounterData.name = "WestBank10"
	WestBank_EncounterData.spawn = mkr_westBank10
	WestBank_EncounterData.units = {
		{
			sbp = SBP.SOVIET.SNIPER_TEAM_MP,
			spawn = mkr_westBank10,
		},
	}
	WestBank_GoalData.target = mkr_westBank10
	WestBank_GoalData.fallbackParams = nil
	WestBank_GoalData.range = 45
	encID_westBank10 = Encounter:Create(WestBank_EncounterData)
	table.insert(t_AItoUnlock, encID_westBank10)
	encID_westBank10:SetGoal(WestBank_GoalData)
	
	if AI_IsAIPlayer(player1) then
		local player4Squads = Player_GetSquads(player4)
		SGroup_Filter(player4Squads, SBP.SOVIET.T_34_76_SQUAD_MP, FILTER_KEEP)
		local armorMod = Util_DifVar({0.5, 0.75, 1})
		local weaponMod = Util_DifVar({0.5, 0.75, 1})
		Modify_Armor(player4Squads, armorMod)
		Modify_WeaponPenetration(player4Squads, "hardpoint_01", weaponMod)
	end
	
	-- Periodically release these squads to skirmish AI control, if they remain static for too long
	Rule_AddDelayedInterval(_UnlockWestBankAI, 480, 120)
	
end

-- If static west-bank enemies sit around for too long, release them to AI control
function _UnlockWestBankAI()
	local enc = t_AItoUnlock[g_unlockAIIndex] 
	if enc ~= nil and enc:IsAlive() and enc:IsEnabled() then
		if SGroup_Count(enc.sgroup) >0 then
			if SGroup_GetAvgHealth(enc.sgroup) >= 0.95 and SGroup_IsIdle(enc.sgroup, ANY) then
				if AI_IsEnabled(enc.data.player) == true then
--~ 					Util_MissionTitle(LOC("Unlocking encounter " .. enc.data.name))
					AI_UnlockSquads(enc.data.player, enc.sgroup)
				end
			end
		end
	end
	if g_unlockAIIndex == 10 then
		Rule_RemoveMe()
	else
		g_unlockAIIndex = g_unlockAIIndex + 1
	end
end

------ Soviet attackers on the WEST side of the river -----
function Voronezh_SpawnWestBankAttackers1()
	local WestBankAttack_EncounterData = {
		name = "WestBank_Attack1",
		player = player4,
		spawn = mkr_harassSpawn_north,
		sgroups = {sg_e_all, sg_e_westAttack1},
		units = {
			{
				sbp = SBP.SOVIET.COMBAT_ENGINEER_SQUAD_MP,
				upgrades = {UPG.SOVIET.ENGINEER_FLAMETHROWER_MP},
			},
			{
				sbp = SBP.SOVIET.T_70M_MP,
			},
			{
				sbp = SBP.SOVIET.M5_HALFTRACK_SQUAD_MP,
			},
		},
		onDeath = nil,
	}
	local WestBank_AttackData1 = {
		name = "Attack",
		target = mkr_hint_player1,
		leashRange = 35,
		range = 70,
		attackMove = true,
		coordinatedSetup = true,
		coordinatedMoveRadius = 20,
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = 100,
			},
			{
				tacticType = TACTIC_Recrew,
				priority = 50,
			},
			{
				tacticType = TACTIC_Pickup,
				priority = 25,
			},
			{
				tacticType = TACTIC_Vehicle,
				maxUsers = 1,
				maxRange = 10,
				retryTimeSecs = 45,
				waitTimeSecs = 22,
				useInitialWaitTime = true,
				priority = 1,
			},
		},
	}
	encID_westBankAttack1 = Encounter:Create(WestBankAttack_EncounterData)
	encID_westBankAttack1:SetGoal(WestBank_AttackData1)
	ThreatArrow_CreateGroup(sg_e_westAttack1)
	FOW_RevealSGroupOnly(sg_e_westAttack1, 30)
end

function Voronezh_SpawnWestBankAttackers2()
	local WestBankAttack_EncounterData = {
		name = "WestBank_Attack2",
		player = player4,
		spawn = mkr_harassSpawn_south,
		sgroups = {sg_e_all,sg_e_westAttack2},
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS_MP,
			},
			{
				sbp = SBP.SOVIET.T_70M_MP,
			},
			{
				sbp = SBP.SOVIET.T_34_76_SQUAD_MP,
			},
		},
		onDeath = nil,
	}
	local WestBank_AttackData2 = {
		name = "Attack",
		target = mkr_hint_player1,
		leashRange = 35,
		range = 70,
		attackMove = true,
		coordinatedSetup = true,
		coordinatedMoveRadius = 20,
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = 100,
			},
			{
				tacticType = TACTIC_Recrew,
				priority = 50,
			},
			{
				tacticType = TACTIC_Pickup,
				priority = 25,
			},
			{
				tacticType = TACTIC_Vehicle,
				maxUsers = 1,
				maxRange = 10,
				retryTimeSecs = 45,
				waitTimeSecs = 22,
				useInitialWaitTime = true,
				priority = 1,
			},

		},
	}
	encID_westBankAttack2 = Encounter:Create(WestBankAttack_EncounterData)
	encID_westBankAttack2:SetGoal(WestBank_AttackData2)
	ThreatArrow_CreateGroup(sg_e_westAttack2)
	FOW_RevealSGroupOnly(sg_e_westAttack2, 30)
end

------ Soviet attackers on the EAST side of the river -----
function Voronezh_SpawnEastBankAttackers1()
	
	local EastBankAttack_EncounterData = {
		name = "EastBank_Attack1",
		player = player3,
		spawn = mkr_roadSpawnNorth,
		sgroups = {sg_e_all, sg_e_eastAttack1},
		units = {
			{
				sbp = SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD_MP,
				sgroups = {sg_e_eastAttack1_car1},
			},
			{
				sbp = SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD_MP,
				sgroups = {sg_e_eastAttack1_car2},
			},
		},
		onDeath = nil,
	}
	
	local EastBankAttack_EncounterData2 = {
		name = "EastBank_Attack1_2",
		player = player3,
		sgroups = {sg_e_all, sg_e_eastAttack1},
		units = {
			{
				sbp = SBP.SOVIET.COMBAT_ENGINEER_SQUAD_MP,
				upgrades = {UPG.SOVIET.ENGINEER_FLAMETHROWER_MP},
				spawn = sg_e_eastAttack1_car1
			},
			{
				sbp = SBP.SOVIET.COMBAT_ENGINEER_SQUAD_MP,
				upgrades = {UPG.SOVIET.ENGINEER_FLAMETHROWER_MP},
				spawn = sg_e_eastAttack1_car2
			},
		},
		onDeath = nil,
	}
	
	local EastBank_AttackData1 = {
		name = "Attack",
		target = mkr_hint_player2,
		leashRange = 35,
		range = 70,
		attackMove = true,
		coordinatedSetup = true,
		coordinatedMoveRadius = 20,
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = 100,
			},
			{
				tacticType = TACTIC_Recrew,
				priority = 50,
			},
			{
				tacticType = TACTIC_Pickup,
				priority = 25,
			},
			{
				tacticType = TACTIC_Vehicle,
				maxUsers = 1,
				maxRange = 10,
				retryTimeSecs = 45,
				waitTimeSecs = 22,
				useInitialWaitTime = true,
				priority = 1,
			},

		},
	}
	encID_eastBankAttack1 = Encounter:Create(EastBankAttack_EncounterData)
	encID_eastBankAttack1:SetGoal(EastBank_AttackData1)
	ThreatArrow_CreateGroup(sg_e_eastAttack1)
	FOW_RevealSGroupOnly(sg_e_eastAttack1, 30)
	
	encID_eastBankAttack1_2 = Encounter:Create(EastBankAttack_EncounterData2)
--~ 	encID_eastBankAttack1_2:SetGoal(EastBank_AttackData1)
end

function Voronezh_SpawnEastBankAttackers2()
	
	local EastBankAttack_EncounterData = {
		name = "EastBank_Attack2",
		player = player3,
		spawn = mkr_roadSpawnSouth,
		sgroups = {sg_e_all, sg_e_eastAttack2},
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS_MP,
			},
			{
				sbp = SBP.SOVIET.T_70M_MP,
			},
		},
		onDeath = nil,
	}
	local EastBank_AttackData2 = {
		name = "Attack",
		target = mkr_hint_player2,
		leashRange = 35,
		range = 70,
		attackMove = true,
		coordinatedSetup = true,
		coordinatedMoveRadius = 20,
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = 100,
			},
			{
				tacticType = TACTIC_Recrew,
				priority = 50,
			},
			{
				tacticType = TACTIC_Pickup,
				priority = 25,
			},
			{
				tacticType = TACTIC_Vehicle,
				maxUsers = 1,
				maxRange = 10,
				retryTimeSecs = 45,
				waitTimeSecs = 22,
				useInitialWaitTime = true,
				priority = 1,
			},

		},
	}
	encID_eastBankAttack2 = Encounter:Create(EastBankAttack_EncounterData)
	encID_eastBankAttack2:SetGoal(EastBank_AttackData2)
	ThreatArrow_CreateGroup(sg_e_eastAttack2)
	FOW_RevealSGroupOnly(sg_e_eastAttack2, 30)
end

function Voronezh_SpawnEastBankAttackers3()
	
	local EastBankAttack_EncounterData1 = {
		name = "EastBank_Attack3_1",
		player = player3,
		spawn = mkr_roadSpawnNorth,
		sgroups = {sg_e_all, sg_e_eastAttack3},
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS_MP,
			},
			{
				sbp = SBP.SOVIET.T_70M_MP,
			},
		},
		onDeath = nil,
	}
	local EastBankAttack_EncounterData2 = {
		name = "EastBank_Attack3_2",
		player = player3,
		spawn = mkr_roadSpawnSouth,
		sgroups = {sg_e_all, sg_e_eastAttack3},
		units = {
			{
				sbp = SBP.SOVIET.T_34_76_SQUAD_MP,
			},
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD_MP,
			},
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD_MP,
			},
		},
		onDeath = nil,
	}
	local EastBank_AttackData3 = {
		name = "Attack",
		target = mkr_hint_player2,
		leashRange = 35,
		range = 70,
		attackMove = true,
		coordinatedSetup = true,
		coordinatedMoveRadius = 20,
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = 100,
			},
			{
				tacticType = TACTIC_Recrew,
				priority = 50,
			},
			{
				tacticType = TACTIC_Pickup,
				priority = 25,
			},
			{
				tacticType = TACTIC_Vehicle,
				maxUsers = 1,
				maxRange = 10,
				retryTimeSecs = 45,
				waitTimeSecs = 22,
				useInitialWaitTime = true,
				priority = 1,
			},

		},
	}
	encID_eastBankAttack3_1 = Encounter:Create(EastBankAttack_EncounterData1)
	encID_eastBankAttack3_1:SetGoal(EastBank_AttackData3)
	encID_eastBankAttack3_2 = Encounter:Create(EastBankAttack_EncounterData2)
	encID_eastBankAttack3_2:SetGoal(EastBank_AttackData3)
	ThreatArrow_CreateGroup(sg_e_eastAttack3)
	FOW_RevealSGroupOnly(sg_e_eastAttack3, 30)
end

------ Anti-tank Soviet squads within the city-----
function Voronezh_AntiTankEncounters()
	
	t_cityATEncounters = {}
	----- North Bridge
	local AntiTank_EncounterData = {
		name = "AntiTank_northBridge1",
		player = player4,
		spawn = mkr_northBridge_AT1,
		sgroups = {sg_e_all, sg_e_cityAT},
		units = {
			{
				sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP,
				spawn = mkr_northBridge_AT1,
			},
		},
		onDeath = nil,
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_northBridge_AT1,
			leashRange = 22,
			range = 80,
			coordinatedSetup = true,
			useSkirmishAI = true,
			tacticControlsList = {
				{
					tacticType = TACTIC_Cover,
					priority = -1,
				},
			},
			  abilityControlsList = {
				{
					abilityPBG = ABILITY.SOVIET.AT_76MM_HE_BARRAGE_ABILITY_MP,
					retryTimeSecs = 30,
					waitTimeSecs = Util_DifVar({180, 120, 60}),
					useInitialWaitTime = true,
				},
			},
			onFailure = function()
			end,
		},
	}
	Encounter:Create(AntiTank_EncounterData)
	
	
	--
	AntiTank_EncounterData.name = "AntiTank_northBridge2"
	AntiTank_EncounterData.spawn = mkr_northBridge_AT2
	AntiTank_EncounterData.units = {
		{
			sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP,
			spawn = mkr_northBridge_AT2,
		},
	}
	AntiTank_EncounterData.goal.target = mkr_northBridge_AT2
	Encounter:Create(AntiTank_EncounterData)
	
	
	----- South Bridge
	AntiTank_EncounterData.name = "AntiTank_southBridge1"
	AntiTank_EncounterData.spawn = mkr_southBridge_AT1
	AntiTank_EncounterData.units = {
		{
			sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP,
			spawn = mkr_southBridge_AT1,
		},
	}
	AntiTank_EncounterData.goal.target = mkr_southBridge_AT1
	Encounter:Create(AntiTank_EncounterData)
	
	
	--
	AntiTank_EncounterData.name = "AntiTank_southBridge2"
	AntiTank_EncounterData.spawn = mkr_southBridge_AT2
	AntiTank_EncounterData.units = {
		{
			sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP,
			spawn = mkr_southBridge_AT2,
		},
	}
	AntiTank_EncounterData.goal.target = mkr_southBridge_AT2
	Encounter:Create(AntiTank_EncounterData)
	
	
	----- Main Road
	AntiTank_EncounterData.name = "AntiTank_mainRoad1"
	AntiTank_EncounterData.spawn = mkr_city_AT1
	AntiTank_EncounterData.units = {
		{
			sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP,
			spawn = mkr_city_AT1,
		},
	}
	AntiTank_EncounterData.goal.target = mkr_city_AT1
	Encounter:Create(AntiTank_EncounterData)

	
	--
	AntiTank_EncounterData.name = "AntiTank_mainRoad2"
	AntiTank_EncounterData.spawn = mkr_city_AT2
	AntiTank_EncounterData.units = {
		{
			sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP,
			spawn = mkr_city_AT2,
		},
	}
	AntiTank_EncounterData.goal.target = mkr_city_AT2
	Encounter:Create(AntiTank_EncounterData)
	
	
	--
	AntiTank_EncounterData.name = "AntiTank_mainRoad3"
	AntiTank_EncounterData.spawn = mkr_city_AT3
	AntiTank_EncounterData.units = {
		{
			sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP,
			spawn = mkr_city_AT3,
		},
	}
	AntiTank_EncounterData.goal.target = mkr_city_AT3
	Encounter:Create(AntiTank_EncounterData)

	
	--
	AntiTank_EncounterData.name = "AntiTank_mainRoad4"
	AntiTank_EncounterData.spawn = mkr_city_AT4
	AntiTank_EncounterData.units = {
		{
			sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP,
			spawn = mkr_city_AT4,
		},
	}
	AntiTank_EncounterData.goal.target = mkr_city_AT4
	Encounter:Create(AntiTank_EncounterData)
	
	
	--
	AntiTank_EncounterData.name = "AntiTank_mainRoad5"
	AntiTank_EncounterData.spawn = mkr_city_AT5
	AntiTank_EncounterData.units = {
		{
			sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP,
			spawn = mkr_city_AT5,
		},
	}
	AntiTank_EncounterData.goal.target = mkr_city_AT5
	Encounter:Create(AntiTank_EncounterData)
	

end



------ East VP Defenders --------
function Voronezh_EastVPDefenders()
	
	local EastVP_EncounterData = {
		name = "EastVP1",
		player = player4,
		spawn = mkr_eastVP,
		sgroups = {sg_e_all},
		units = {
			{
				sbp = SBP.SOVIET.SHOCK_TROOPS_MP,
				spawn = mkr_eastVP,
				veterancyRank = 1,
			},
			{
				sbp = SBP.SOVIET.SHOCK_TROOPS_MP,
				spawn = mkr_eastVP,
				veterancyRank = 1,
			},
			{
				sbp = SBP.SOVIET.DSHK_38_HMG_SQUAD_MP,
				spawn = mkr_eastVP,
				difficulty = {GD_HARD, GD_EXPERT},
				veterancyRank = 1,
			},
		},
		onDeath = nil,
	}
	local EastVP_GoalData = {
		name = "Defend",
		target = mkr_eastVP,
		leashRange = 35,
		range = 55,
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {
			mkr_eastVP_face1,
			mkr_eastVP_face2,
			mkr_eastVP_face3,
		},
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Ability,
				priority = 30,
				retryTimeSecs = 10,
				waitTimeSecs = 20,
			},
			{
				tacticType = TACTIC_Avoid,
				priority = 20,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 10,
			},
		},
		onFailure = function()
		end,
	}
	encID_eastVP1 = Encounter:Create(EastVP_EncounterData)
	encID_eastVP1:SetGoal(EastVP_GoalData)
end

------ North VP Defenders --------
function Voronezh_NorthVPDefenders()
	
	local NorthVP_EncounterData = {
		name = "NorthVP1",
		player = player3,
		spawn = mkr_northVP,
		sgroups = {sg_e_all},
		units = {
			{
				sbp = SBP.SOVIET.SHOCK_TROOPS_MP,
				veterancyRank = 1,
			},
			{
				sbp = SBP.SOVIET.DSHK_38_HMG_SQUAD_MP,
				veterancyRank = 2,
			},
		},
		onDeath = nil,
	}
	local NorthVP_GoalData = {
		name = "Defend",
		target = mkr_northVP,
		leashRange = 35,
		range = 55,
		coordinatedSetup = true,
		garrisonIdle = true,
		coordinatedSetupFacingPositions = {
			mkr_northVP_face1,
			mkr_northVP_face2,
			mkr_northVP_face3,
		},
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Ability,
				priority = 30,
			},
			{
				tacticType = TACTIC_Avoid,
				priority = 20,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 10,
			},
		},
		onFailure = function()
		end,
	}
	encID_northVP1 = Encounter:Create(NorthVP_EncounterData)
	encID_northVP1:SetGoal(NorthVP_GoalData)
end

------ KV-8 Patrol -------

function Voronezh_KV8Patroller()

	local KV8_EncounterData = {
		name = "KV8",
		player = player4,
		
		sgroups = {sg_e_all},
		units = {
			{
				sbp = SBP.SOVIET.KV_8_MP,
				spawn = mkr_kv8_spawn,
				veterancyRank = 1,
			},
		},
		onDeath = nil,
	}

	local KV8_goalData = {
		name = "Defend",
		target = mkr_kv8_dest,
		leashRange = 25,
		range = 40,
		coordinatedSetup = true,
		useSkirmishAI = true,
--~ 		patrolParams = {
--~ 			path = "kv8",
--~ 			wait = 60,
--~ 			attackMove = true,
--~ 		},
		tacticControlsList = {
			{
				tacticType = TACTIC_Vehicle,
				maxUsers = 1,
				maxRange = 10,
				retryTimeSecs = 45,
				waitTimeSecs = 22,
				useInitialWaitTime = true,
				priority = 1,
			},
		},
	}
	
	encID_KV8 = Encounter:Create(KV8_EncounterData)
	encID_KV8:SetGoal(KV8_goalData)
	
end

------ Enemy Base Defenders --------
function Voronezh_EnemyBaseDefenders()
	
	local EnemyBase_EncounterData = {
		name = "BaseDefender1",
		player = player3,
		
		sgroups = {sg_e_all, sg_e_baseDefenders},
		units = {
			{
				sbp = SBP.SOVIET.KV_1_MP,
				spawn = mkr_baseDefender1,
				veterancyRank = 2,
			},
			{
				sbp = SBP.SOVIET.KV_1_MP,
				spawn = mkr_baseDefender2,
				veterancyRank = 2,
			},
		},
		onDeath = nil,
	}
	local EnemyBase_GoalData = {
		name = "Defend",
		target = mkr_enemyBaseEntrance,
		leashRange = 30,
		range = 45,
		coordinatedSetup = true,
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Vehicle,
				maxUsers = 1,
				maxRange = 10,
				retryTimeSecs = 45,
				waitTimeSecs = 22,
				useInitialWaitTime = true,
				priority = 1,
			},
		},
		onFailure = function()
		end,
	}
	encID_baseDefender1 = Encounter:Create(EnemyBase_EncounterData)
	encID_baseDefender1:SetGoal(EnemyBase_GoalData)
end



