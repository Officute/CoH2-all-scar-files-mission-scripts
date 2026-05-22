-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Encounter/Goal data for M02_Scorched_Earth
-- Designer: A.Molina
-------------------------------------------------------------------------
-------------------------------------------------------------------------


--[[********************************************************************************************************]]
------------------------------------------------ FRONT LINE --------------------------------------------------
--[[********************************************************************************************************]]
--LEFT
function SetupFrontLineLeft() --On mission start
	local encData = {
		name = "frontlineLeft",
		sgroups = {sg_frontLine},
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_espawn2,
				dynamicSpawnTarget = mkr_front4,
				moveTo = mkr_front4,
				onDeath = ReplaceUnit,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_espawn1,
				dynamicSpawnTarget = mkr_front2,
				moveTo = mkr_front2,
				onDeath = ReplaceUnit,
			},
		},
	}
	g_enc_frontLeft = Encounter:Create(encData)
	
	SGroup_SetInvulnerable(g_enc_frontLeft.sgroup, true)
	
	--Harmless units
	sg_harmlessLeft = SGroup_CreateIfNotFound("sg_harmlessLeft")
	Util_CreateSquads(player2, sg_harmlessLeft, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_harmless2, nil, nil, 4)
	Util_CreateSquads(player2, sg_harmlessLeft, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_front1, nil, nil, 5)
	
	mod_accuracyLeft = Modify_WeaponAccuracy(sg_harmlessLeft, "hardpoint_01", g_weaponAccuracy)
end

function IncreaseThreatLeft() --On Obj1 start
	local unit = {
		sbp = g_diffVariableSBP,
		spawn = mkr_espawn1,
		dynamicSpawnTarget = mkr_attackLeft,
		moveTo = mkr_attackLeft,
	}
	g_enc_frontLeft:AddUnit(unit)
	
	--Add another harmless unit
	Util_CreateSquads(player2, sg_harmlessLeft, SBP.GERMAN.OSTRUPPEN_SQUAD, Util_FindHiddenSpawn(mkr_espawn1, mkr_harmless1), mkr_harmless1)
	Modifier_Remove(mod_accuracyLeft)
	mod_accuracyLeft = Modify_WeaponAccuracy(sg_harmlessLeft, "hardpoint_01", g_weaponAccuracy)
end

function Obj1_StartAttackLeft()
	local goalData = {
		name = "Attack",
		target = mkr_attackLeft,
		range = 30,
		leashRange = 22,
		safeMoveWeight = 0.0,
		tacticCloseGround = true,
		tacticTargetPreference = AITacticTargetPreference_Near,
		maxAttackers = 2,
		coordinatedSetup = false,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
		},
		maxIdleTime = 6,
		onSuccess = FrontLineBrokenLeft,
	}
	
	SGroup_SetInvulnerable(g_enc_frontLeft.sgroup, false)
	g_enc_frontLeft:SetGoal(goalData)
end


-- RIGHT
function SetupFrontLineRight()
	local encData = {
		name = "frontlineRight",
		sgroups = {sg_frontLine},
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_espawn4,
				dynamicSpawnTarget = mkr_front8,
				moveTo = mkr_front8,
				attackMoveTo = true,
				onDeath = ReplaceUnit,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_espawn3,
				dynamicSpawnTarget = mkr_front5,
				moveTo = mkr_front6,
				attackMoveTo = true,
				onDeath = ReplaceUnit,
			},
		}
	}
	g_enc_frontRight = Encounter:Create(encData)
	
	SGroup_SetInvulnerable(g_enc_frontRight.sgroup, true)
	
	--Harmless units
	sg_harmlessRight = SGroup_CreateIfNotFound("sg_harmlessRight")
	Util_CreateSquads(player2, sg_harmlessRight, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_front5, nil, nil, 5)
	
	mod_accuracyRight = Modify_WeaponAccuracy(sg_harmlessRight, "hardpoint_01", g_weaponAccuracy)
end

function IncreaseThreatRight()
	local unit = {
		sbp = SBP.GERMAN.GRENADIER_SQUAD,
		spawn = mkr_espawn4,
		dynamicSpawnTarget = mkr_attackRight,
		moveTo = mkr_attackRight,
		attackMoveTo = true,
	}
	g_enc_frontRight:AddUnit(unit)
	
	
	--Add another harmless unit
	Util_CreateSquads(player2, sg_harmlessRight, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_roadNorthEast, mkr_front9)
	Modifier_Remove(mod_accuracyRight)
	mod_accuracyRight = Modify_WeaponAccuracy(sg_harmlessRight, "hardpoint_01", g_weaponAccuracy)
end

function Obj1_StartAttackRight()
	local goalData = {
		name = "Attack",
		target = mkr_attackRight,
		range = 33,
		leashRange = mkr_attackRight,
		safeMoveWeight = 0.0,
		tacticCloseGround = 0.0,
		attackMove = true,
		tacticTargetPreference = AITacticTargetPreference_Near,
		maxAttackers = 2,
		coordinatedSetup = false,
		maxIdleTime = 6,
		onSuccess = FrontLineBrokenRight,
	}
	g_enc_frontRight:SetGoal(goalData)
	
	SGroup_SetInvulnerable(g_enc_frontRight.sgroup, false)
end


-- Front line is broken
function FrontLineBrokenRight(enc)
	Rule_Remove(LightMortarsR)
	AttackTruckRight(enc)
end

function FrontLineBrokenLeft(enc)
	Rule_Remove(LightMortarsL)
	AttackTruckLeft(enc)
end



--[[ ATTACK ON RESOURCES ]]
function FrontLine_Flank()
	
	sg_flank_All = SGroup_CreateIfNotFound("sg_flank_All")
	
	--RIGHT
	sg_flankRight = SGroup_CreateIfNotFound("frontFlankRight")
	
	local encData = {
		name = "frontFlankleft",
		sgroups = {sg_flankRight, sg_flank_All},
		units = {
			{
				sbp = g_diffVariableSBP,
				spawn = mkr_roadNorthEast,
				dynamicSpawnTarget = mkr_flankRight_dynamic,
				onDeath = Util_DifVar({nil, ReplaceUnit}, g_difficulty),
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_spawnFlankRight,
				dynamicSpawnTarget = mkr_flankRight_dynamic,
				onDeath = ReplaceUnit,
			},
		},
	}
	enc_frontFlankRight = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = mkr_flankRight,
		range = 20,
		leashRange = 14,
		coordinatedSetup = false,
		maxIdleTime = 6,
		onSuccess = AttackTruckRight,
	}
	enc_frontFlankRight:SetGoal(goalData)
--~ 	AttackTruckRight(enc_frontFlankRight)
end

function FrontLine_Flank_Left()
	--LEFT
	sg_flankLeft = SGroup_CreateIfNotFound("frontFlankLeft")
	
	local encData = {
		name = "frontFlankleft",
		sgroups = {sg_flankLeft, sg_flank_All},
		units = {
			{
				sbp = g_diffVariableSBP,
				spawn = mkr_spawnTrapLeft,
				dynamicSpawnTarget = mkr_flankLeft_dynamic,
				onDeath = Util_DifVar({nil, ReplaceUnit}, g_difficulty),
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_flankSouth,
				dynamicSpawnTarget = mkr_flankLeft_dynamic,
				onDeath = ReplaceUnit,
			},
		},
	}
	enc_frontFlankLeft = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = mkr_flankLeft1,
		range = 20,
		leashRange = 14,
		coordinatedSetup = false,
		maxIdleTime = 10,
		onSuccess = AttackTruckLeft,
	}
	enc_frontFlankLeft:SetGoal(goalData)
--~ 	AttackTruckLeft(enc_frontFlankLeft)
end

function AdvanceFlanks()
	enc_frontFlankLeft:RemoveOnDeath(true)
	AttackTruckLeft(enc_frontFlankLeft)
	
	enc_frontFlankRight:RemoveOnDeath(true)
	AttackTruckRight(enc_frontFlankRight)
end

function AttackTruckLeft(enc)
	if(enc ~= nil) then
		local goalData = {
			name = "Attack",
			target = mkr_terrFuel,
			range = 37,
			leashRange = 28,
			attackMove = true,
			tacticTargetPreference = AITacticTargetPreference_Near,
			maxAttackers = 2,
			movePathLengthFactor = 1.0,
			coordinatedSetup = false,
			maxIdleTime = 6,
			onSuccess = SecureHowitzers,
		}
		enc:SetGoal(goalData)
	end
end

function AttackTruckRight(enc)
	if(enc ~= nil) then
		local goalData = {
			name = "Attack",
			target = mkr_terrMotorPool,
			range = mkr_terrMotorPool,
			leashRange = mkr_terrMotorPool,
			safeMoveWeight = 0.3,
			movePathLengthFactor = 1.0,
			attackMove = true,
			coordinatedSetup = false,
			tacticTargetPreference = AITacticTargetPreference_Near,
			maxAttackers = 2,
			maxIdleTime = 6,
			onSuccess = SecureMotorpool,
		}
		enc:SetGoal(goalData)
	end
end

function SpawnHarmless2()
	sg_harmlessLeft = SGroup_CreateIfNotFound("sg_harmlessLeft")
	Util_CreateSquads(player2, sg_harmlessLeft, SBP.GERMAN.OSTRUPPEN_SQUAD, Util_FindHiddenSpawn(mkr_espawn0, mkr_harmless1), mkr_pincerLeft, nil, 4, true)
	
	if(g_difficulty >= GD_HARD) then
		Util_CreateSquads(player2, sg_harmlessLeft, SBP.GERMAN.OSTRUPPEN_SQUAD, Util_FindHiddenSpawn(mkr_espawn2, mkr_harmless2), mkr_bomb3, nil, 5, true)
	end
	
	mod_accuracyLeft = Modify_WeaponAccuracy(sg_harmlessLeft, "hardpoint_01", g_weaponAccuracy)
	
	
	sg_harmlessRight = SGroup_CreateIfNotFound("sg_harmlessRight")
	Util_CreateSquads(player2, sg_harmlessRight, SBP.GERMAN.OSTRUPPEN_SQUAD, Util_FindHiddenSpawn(mkr_espawn4, mkr_attackRight), mkr_bomb8, nil, 5, true)
	
	mod_accuracyRight = Modify_WeaponAccuracy(sg_harmlessRight, "hardpoint_01", g_weaponAccuracy)
end


--Secure and defend the territory points
function SecureMotorpool(enc)
	if(enc ~= nil) then
		local goalData = {
			name = "Defend",
			target = mkr_pingTrucks,
			range = 30,
			leashRange = 14,
			movePathLengthFactor = 1.0,
			attackMove = true,
			tacticTargetPreference = AITacticTargetPreference_Near,
			maxIdleTime = -1,
		}
		enc:SetGoal(goalData)
	end
end

function SecureHowitzers(enc)
	if(enc ~= nil) then
		local goalData = {
			name = "Defend",
			target = mkr_engineers1,
			range = 30,
			leashRange = 14,
			movePathLengthFactor = 1.0,
			attackMove = true,
			tacticTargetPreference = AITacticTargetPreference_Near,
			maxIdleTime = -1,
		}
		enc:SetGoal(goalData)
	end
end



--[[********************************************************************************************************]]
------------------------------------------------- FIELDS -----------------------------------------------------
--[[********************************************************************************************************]]
function FieldAllies()
	--Right field
	sg_alliesFieldRight = SGroup_CreateIfNotFound("sg_alliesFieldRight")
	local encData = {
		name = "fieldRight",
		player = player3,
		sgroups = {sg_alliesFieldRight},
		units = {
			{
				sbp = SBP.SOVIET.COMBAT_ENGINEER_SQUAD,
				spawn = mkr_alliesFieldRight,
			},
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				spawn = mkr_alliesFieldRight2,
			},
			{
				sbp = SBP.SOVIET.COMBAT_ENGINEER_SQUAD,
				spawn = mkr_fireNorth4,
			},
		},
	}
	enc_alliesRight = Encounter:Create(encData)
	mod_fieldRight = Modify_ReceivedDamage(sg_alliesFieldRight, 0.30, true)
	Modify_WeaponAccuracy(sg_alliesFieldRight, "hardpoint_01", 0.5)
	
	
	--Left field
	sg_alliesFieldLeft = SGroup_CreateIfNotFound("sg_alliesFieldLeft")
	local encData = {
		name = "fieldLeft",
		player = player3,
		sgroups = {sg_alliesFieldLeft},
		units = {
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				spawn = mkr_engineersFieldLeft
			},
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				spawn = mkr_alliesFieldLeft
			},
			{
				sbp = SBP.SOVIET.COMBAT_ENGINEER_SQUAD,
				spawn = mkr_alliesFieldLeft2,
			},
		},
	}
	enc_alliesLeft = Encounter:Create(encData)
	mod_fieldLeft = Modify_ReceivedDamage(sg_alliesFieldLeft, 0.20, true)
	Modify_WeaponAccuracy(sg_alliesFieldLeft, "hardpoint_01", 0.5)
end

function TownAttackers()
	local encData = {
		name = "townAttackers1",
		units = {
			{
				sbp = g_diffVariableSBP,
				spawn = mkr_espawn0,
				dynamicSpawnTarget = mkr_pincerLeft,
				onDeath = ReplaceUnit,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_espawn1,
				dynamicSpawnTarget = mkr_terrFuel,
				onDeath = ReplaceUnit,
				difficulty = GD_HARD,
			},
		}
	}
	enc_townAttackers1 = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = mkr_flameDest1,
		leashRange = 30,
		range = 30,
		coordinatedSetup = false,
		attackMove = true,
		garrison = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
		},
		maxIdleTime = -1,
	}
	enc_townAttackers1:SetGoal(goalData)
	
	
	
	local encData = {
		name = "townAttackers2",
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_espawn4,
				dynamicSpawnTarget = mkr_engineers3,
				onDeath = ReplaceUnit,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_roadNorthEast,
				dynamicSpawnTarget = mkr_fireNorth3,
				onDeath = ReplaceUnit,
				difficulty = GD_HARD,
			},
		},
	}
	enc_townAttackers2 = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = mkr_introTruck2,
		leashRange = 30,
		range = 30,
		coordinatedSetup = false,
		attackMove = true,
		garrison = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
		},
		maxIdleTime = -1,
	}
	enc_townAttackers2:SetGoal(goalData)
end


--[[ Right field ]]
function FlankFieldRight()
	local encData = {
		name = "FlankFieldNorth",
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_espawn4,
				dynamicSpawnTarget = mkr_fireNorth2,
				moveTo = mkr_fireNorth2,
				attackMoveTo = true,
				onDeath = ReplaceUnit,
			},
			{
				sbp = (g_difficulty == GD_HARD and SBP.GERMAN.GRENADIER_SQUAD or SBP.GERMAN.OSTRUPPEN_SQUAD),
				spawn = mkr_roadNorthEast,
				dynamicSpawnTarget = mkr_fireNorth2,
				moveTo = mkr_fireNorth2,
				attackMoveTo = true,
				onDeath = ReplaceUnit,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_roadNorthEast,
				dynamicSpawnTarget = mkr_fireNorth4,
				moveTo = mkr_fireNorth4,
				attackMoveTo = true,
				onDeath = ReplaceUnit,
			},
		},
		onDeath = FlankFieldRight,
	}
	g_enc_flankFieldRight = Encounter:Create(encData)
end

function AttackRightField(enc)
	local unitData = {
		sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
		spawn = mkr_spawnFlankRight,
		onDeath = ReplaceUnit,
	}
	enc:AddUnit(unitData)

	local goalData = {
		name = "Attack",
		target = mkr_fireNorth1,
		leashRange = 22,
		range = 28,
		coordinatedSetup = false,
		movePathLengthFactor = 1.0,
		abilityBlacklist = ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
		},
	}
	enc:SetGoal(goalData)
end


--[[ Left field ]]
function FlankFieldLeft()
	local encData = {
		name = "FlankFieldSouth",
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_flankSouth,
				moveTo = mkr_fireSouth2,
				attackMoveTo = true,
				onDeath = ReplaceUnit,
			},
			{
				sbp = (g_difficulty == GD_HARD and SBP.GERMAN.GRENADIER_SQUAD or SBP.GERMAN.OSTRUPPEN_SQUAD),
				spawn = mkr_flankSouth2,
				moveTo = mkr_fireSouth4,
				attackMoveTo = true,
				onDeath = ReplaceUnit,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_spawnTrapLeft,
				dynamicSpawnTarget = mkr_fireSouth2,
				moveTo = mkr_fireSouth3,
				attackMoveTo = true,
				onDeath = ReplaceUnit,
			},
		},
	}
	g_enc_flankFieldLeft = Encounter:Create(encData)
end

function AttackLeftField(enc)
	local unitData = {
		sbp = SBP.GERMAN.GRENADIER_SQUAD,
		spawn = mkr_spawnTrapLeft,
		dynamicSpawnTarget = mkr_fireSouth2,
		onDeath = ReplaceUnit,
	}
	enc:AddUnit(unitData)

	local goalData = {
		name = "Attack",
		target = mkr_fieldSouth,
		leashRange = mkr_fieldSouth,
		range = 25,
		attackMove = false,
		coordinatedSetup = false,
--~ 		tacticCloseGround = true,
		movePathLengthFactor = 1.0,
		abilityBlacklist = ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
		},
		maxIdleTime = 10,
		onSuccess = CaptureFieldLeft,
	}
	enc:SetGoal(goalData)
end

function CaptureFieldLeft(enc)
	local goalData = {
		name = "Attack",
		target = vp_fieldLeft,
		leashRange = 15,
		safeMoveWeight = 0.0,
	}
	enc:SetGoal(goalData)
	
	if(not SGroup_IsEmpty(sg_htFieldSouth)) then
		Cmd_Move(sg_htFieldSouth, trg_fieldSouth)
	end
end





--[[********************************************************************************************************]]
---------------------------------------------- TRAINYARD ATTACK ----------------------------------------------
--[[********************************************************************************************************]]
function OpeningWave()
	local encData = {
		name = "openingWave",
		spawn = trg_frontLine,
		dynamicSpawnTarget = Marker_GetPosition(mkr_startUnit),
		sgroups = {sg_currentAttackers},
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				difficulty = GD_HARD,
			},
		},
	}
	enc_openingWave = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = mkr_intersection,
		range = 10,
		leashRange = 15,
		safeMoveWeight = 0.0,
		movePathLengthFactor = 1.0,
--~ 		attackMove = true,
		coordinatedSetup = false,
		abilityBlacklist = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
		},
		fallbackParams = {
			thresholds = {0.65},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_line1},
			retreat = true,
		},
		maxTime = 60,
		maxIdleTime = 5,
		onTransition = _CheckRetreat,
		onSuccess = AttackStation,
		onFailure = Despawn,
	}
	enc_openingWave:SetGoal(goalData)
	
	
	--Scout car
	local encData = {
		spawn = trg_frontLine,
		dynamicSpawnTarget = mkr_intersectionCenter,
		units = {
			{
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
			},
		},
		moveTo = mkr_intersection,
		onDeath = WarnMines,
	}
	enc_scout1 = Encounter:Create(encData)
	_ModifySpeed(enc_scout1.sgroup, 0.7)
	
	--Debuff if not mines are placed - only on easy/normal
	if(g_difficulty <= GD_NORMAL) then
		Event_Proximity(_DebuffUnit, {group = enc_scout1.sgroup, newArmorMod = 0.5}, enc_scout1.sgroup, mkr_intersection, 7.5, ANY)
	end
	
	Event_ElementOnScreen(EventHandler_StartIntel, {intel_callback = EVENTS.ScoutCar1}, player1, enc_scout1.sgroup, ANY, 0.95)
end

function Wave2()
	local encData = {
		name = "wave2a",
		sgroups = {sg_currentAttackers},
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_espawn0,
				dynamicSpawnTarget = trg_roadLeft,
				onDeath = ReplaceUnitLimited,
			},
		},
	}
	enc_wave2a = Encounter:Create(encData)
	
	AttackLeftRoad(enc_wave2a)
	
	
	local encData = {
		name = "wave2b",
		sgroups = {sg_currentAttackers},
		units = {
			{
				sbp = Util_DifVar({SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.GRENADIER_SQUAD}, g_difficulty),
				spawn = mkr_sandbags1,
				dynamicSpawnTarget = mkr_flameDest1,
				upgrades = Util_DifVar({nil, nil, UPG.GERMAN.GRENADIER_MG42_LMG}, g_difficulty),
				onDeath = ReplaceUnitLimited,
			},
		},
	}
	enc_wave2b = Encounter:Create(encData)
	
	AttackCenter(enc_wave2b)
	
	
	local encData = {
		name = "wave2c",
		sgroups = {sg_currentAttackers},
		units = {
			{
				sbp = Util_DifVar({SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.GRENADIER_SQUAD}, g_difficulty),
				spawn = mkr_enemySpawn,
				dynamicSpawnTarget = mkr_intersectionCenter,
				onDeath = ReplaceUnitLimited,
			},
		},
	}
	enc_wave2c = Encounter:Create(encData)
	
	AttackIntersection(enc_wave2c)

	
	table.insert(t_encs_attack, enc_wave2a)
	table.insert(t_encs_attack, enc_wave2b)
	table.insert(t_encs_attack, enc_wave2c)
	
	
	Event_ElementOnScreen(EventHandler_StartIntel, {intel_callback = EVENTS.Defend_HalftrackLeft}, player1, sg_htLeft, ANY, 0.95)
	Rule_AddOneShot(SpawnHalftrackLeft, 20)
end

function Wave3()
	local encData = {
		name = "wave3a",
		sgroups = {sg_currentAttackers},
		spawn = mkr_enemySpawn,
		dynamicSpawnTarget = mkr_intersectionCenter,
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = Util_DifVar({nil, nil, UPG.GERMAN.GRENADIER_MG42_LMG}, g_difficulty),
				onDeath = ReplaceUnitLimited,
			},
			{
				sbp = Util_DifVar({SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.GRENADIER_SQUAD}, g_difficulty),
				conditions = {_CheckPlayerPopulation, _MaxAttackSquads},
				onDeath = ReplaceUnitLimited,
			},
		},
	}
	enc_wave3a = Encounter:Create(encData)
	
	AttackIntersection(enc_wave3a)


	local encData = {
		name = "wave3b",
		sgroups = {sg_currentAttackers},
		units = {
			{
				sbp = Util_DifVar({SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.GRENADIER_SQUAD}, g_difficulty),
				spawn = mkr_espawn2,
				dynamicSpawnTarget = mkr_engineers2,
				onDeath = ReplaceUnitLimited,
			},
		},
	}
	enc_wave3b = Encounter:Create(encData)
	
	AttackCenter(enc_wave3b)
	
	
	--A small force that tries to flank the player on the right-hand side.
	local encData = {
		name = "wave3c",
		sgroups = {sg_currentAttackers},
		spawn = mkr_frontLineR,
		dynamicSpawnTarget = mkr_fieldRightTop,
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				difficulty = {GD_NORMAL, GD_HARD},
				onDeath = ReplaceUnitLimited,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = Util_DifVar({nil, nil, UPG.GERMAN.GRENADIER_MG42_LMG}, g_difficulty),
				difficulty = {GD_NORMAL, GD_HARD},
				onDeath = ReplaceUnitLimited,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_roadNorth,
				dynamicSpawnTarget = mkr_intersection,
				conditions = {_CheckPlayerPopulation, _MaxAttackSquads},
				onDeath = (g_difficulty == GD_HARD and ReplaceUnitLimited or nil),
			},
		},
	}
	enc_wave3c = Encounter:Create(encData)
	
	AttackHouses(enc_wave3c)
	
	
	table.insert(t_encs_attack, enc_wave3a)
	table.insert(t_encs_attack, enc_wave3b)
	table.insert(t_encs_attack, enc_wave3c)
	
	--Vehicles
	Rule_AddOneShot(SpawnHalftrackCenter, World_GetRand(3, 6))
	Rule_AddOneShot(SpawnHalftrackRight, World_GetRand(25, 30))
	Rule_AddOneShot(SpawnHalftrackLeft, World_GetRand(45, 50))
	
	Event_ElementOnScreen(EventHandler_StartIntel, {intel_callback = EVENTS.Defend_HalftrackCenter}, player1, sg_htCenter, ANY, 0.95)
	Event_ElementOnScreen(EventHandler_StartIntel, {intel_callback = EVENTS.Defend_HalftrackRight}, player1, sg_htRight, ANY, 0.95)
end

function Wave4()
	local encData = {
		name = "wave4a",
		sgroups = {sg_currentAttackers},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_pincerLeft,
				dynamicSpawnTarget = trg_roadLeft,
				upgrades = Util_DifVar({nil, UPG.GERMAN.GRENADIER_MG42_LMG}, g_difficulty),
				onDeath = ReplaceUnitLimited,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_sandbags1,
				dynamicSpawnTarget = mkr_flameDest1,
				onDeath = ReplaceUnitLimited,
			},
		},
	}
	enc_wave4a = Encounter:Create(encData)
	
	AttackLeftRoad(enc_wave4a)
	
	
	local encData = {
		name = "wave4b",
		sgroups = {sg_currentAttackers},
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_sandbags1,
				dynamicSpawnTarget = mkr_flameDest1,
				conditions = {_CheckPlayerPopulation, _MaxAttackSquads},
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_terrMotorPool,
				dynamicSpawnTarget = mkr_introTruck2,
				difficulty = {GD_NORMAL, GD_HARD},
				onDeath = ReplaceUnitLimited,
			},
		},
	}
	enc_wave4b = Encounter:Create(encData)
	
	AttackIntersection(enc_wave4b)
	
	
	--Another encounter farther East (Right)
	local encData2 = {
		name = "wave4c",
		sgroups = {sg_currentAttackers},
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_roadNorth,
				dynamicSpawnTarget = mkr_intersection,
				upgrades = Util_DifVar({nil, nil, UPG.GERMAN.GRENADIER_MG42_LMG}, g_difficulty),
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_frontLineR,
				dynamicSpawnTarget = mkr_fieldRightTop,
				conditions = {_CheckPlayerPopulation, _MaxAttackSquads},
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_frontLineR,
				dynamicSpawnTarget = mkr_fieldRightTop,
				difficulty = {GD_NORMAL, GD_HARD},
				onDeath = ReplaceUnitLimited,
			},
		},
	}
	enc_wave4c = Encounter:Create(encData2)
	
	AttackHouses(enc_wave4c)
	
	table.insert(t_encs_attack, enc_wave4a)
	table.insert(t_encs_attack, enc_wave4b)
	table.insert(t_encs_attack, enc_wave4c)
	
	
	--Vehicles
	if(g_difficulty >= GD_HARD and _CheckPlayerPopulation()) then
		SpawnHalftrackRight()
	end
	SpawnHalftrackCenter(g_difficulty >= GD_NORMAL)
	Rule_AddOneShot(SpawnHalftrackLeft, World_GetRand(35, 40))
	
	Rule_AddOneShot(SpawnHalftrackCenter, 50)
end

function Wave5()
	--Left
	local encData = {
		name = "wave5_1",
		sgroups = {sg_currentAttackers},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_pincerLeft,
				dynamicSpawnTarget = trg_roadLeft,
				upgrades = Util_DifVar({nil, UPG.GERMAN.GRENADIER_MG42_LMG}, g_difficulty),
				onDeath = ReplaceUnitLimited,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_sandbags1,
				dynamicSpawnTarget = mkr_flameDest1,
				conditions = {_CheckPlayerPopulation, _MaxAttackSquads},
			},
			
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_enemySpawn,
				dynamicSpawnTarget = mkr_intersectionCenter,
				difficulty = {GD_NORMAL, GD_HARD},
				onDeath = ReplaceUnitLimited,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_sandbags1,
				dynamicSpawnTarget = mkr_flameDest1,
				difficulty = GD_HARD,
				onDeath = ReplaceUnitLimited,
			},
		},
	}
	enc_wave5_1 = Encounter:Create(encData)
	
	AttackCenter(enc_wave5_1)
	
	--Right
	local encData = {
		name = "wave5_2",
		sgroups = {sg_currentAttackers},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_roadNorth,
				dynamicSpawnTarget = mkr_intersection,
				upgrades = Util_DifVar({nil, nil, UPG.GERMAN.GRENADIER_MG42_LMG}, g_difficulty),
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_frontLineR,
				dynamicSpawnTarget = mkr_fieldRightTop,
				conditions = {_CheckPlayerPopulation, _MaxAttackSquads},
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_frontLineR,
				dynamicSpawnTarget = mkr_fieldRightTop,
				difficulty = {GD_NORMAL, GD_HARD},
				conditions = {_CheckPlayerPopulation, _MaxAttackSquads},
				onDeath = ReplaceUnit,
			},
		},
	}
	enc_wave5_2 = Encounter:Create(encData)
	
	AttackHouses(enc_wave5_2)
	
	table.insert(t_encs_attack, enc_wave5_1)
	table.insert(t_encs_attack, enc_wave5_2)
	table.insert(t_encs_attack, enc_wave5_3)
	
	--Vehicles
	SpawnHalftrackCenter()
	if(g_difficulty >= GD_HARD) then
		SpawnHalftrackRight(true)
	end
	SpawnHalftrackLeft()
	
	if(g_difficulty > GD_EASY) then
		if(g_difficulty >= GD_HARD) then
			Rule_AddDelayedInterval(SpawnHalftrackRight, World_GetRand(25, 30), World_GetRand(22,25))
		end
		Rule_AddDelayedInterval(SpawnHalftrackCenter, World_GetRand(30, 35), World_GetRand(22,25))
		Rule_AddDelayedInterval(SpawnHalftrackLeft, World_GetRand(30, 35), World_GetRand(22,25))
	end
end



--[[ Halftracks ]]
function SpawnHalftrackCenter(attackMove)
	if(SGroup_CountSpawned(sg_htCenter) > 0) then return end
	
	local encData = {
		name = "htCenter",
		spawn = mkr_line1,
		dynamicSpawnTarget = mkr_intersectionCenter,
		sgroups = {sg_htCenter},
		units = {
			{
				sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
			},
		},
	}
	enc_htCenter = Encounter:Create(encData)
	
	Cmd_SquadPath(sg_htCenter, "pth_roadCenter", true, LOOP_NONE, attackMove or false)
	_ModifySpeed(sg_htCenter, g_vehicleSpeed)
	
	--Debuff (only in easy/normal)
	if(g_difficulty <= GD_NORMAL) then
		local newArmorVal = Util_DifVar({0.6, 0.75}, g_difficulty)
		Event_Proximity(_DebuffUnit, {group = sg_htCenter, newArmorMod = newArmorVal}, sg_htCenter, mkr_intersection, 7.0, ANY)
	end
	
	--On normal/hard, have the Vehicle drive into the trainyard after a delay.
	if(g_difficulty >= GD_NORMAL) then
		Event_Proximity(VehicleAttackStation, enc_htCenter, sg_htCenter, mkr_intersection, 6.0, ANY, g_roadHTDelay)
	end
end

function SpawnHalftrackLeft()
	--Only spawn one at a time
	if(SGroup_CountSpawned(sg_htLeft) > 0) then return end
	
	local encData = {
		name = "htLeft",
		spawn = mkr_pincerLeft,
		dynamicSpawnTarget = trg_roadLeft,
		sgroups = {sg_htLeft},
		units = {
			{
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
			},
		},
	}
	enc_htLeft = Encounter:Create(encData)
	
	Cmd_SquadPath(sg_htLeft, "pth_roadLeft", true, LOOP_NONE, false)
	_ModifySpeed(sg_htLeft, g_vehicleSpeed)
	
	ThreatArrow_CreateGroup(sg_htLeft)
	
	--Debuff (only in easy/normal)
	if(g_difficulty <= GD_NORMAL) then
		local newArmorVal = Util_DifVar({0.65, 0.8}, g_difficulty)
		Event_Proximity(_DebuffUnit, {group = sg_htLeft, newArmorMod = newArmorVal}, sg_htLeft, mkr_pathLeftDest, 7.0, ANY)
	end
	
	--On normal/hard, have the Vehicle drive into the trainyard after a delay.
	if(g_difficulty >= GD_NORMAL) then
		Event_Proximity(VehicleAttackStation, enc_htLeft, sg_htLeft, mkr_pathLeftDest, 6.0, ANY, g_roadHTDelay)
	end
end

function SpawnHalftrackRight()
	--Only spawn one at a time
	if(SGroup_CountSpawned(sg_htRight) > 0) then return end
	
	local encData = {
		name = "htRight",
		spawn = mkr_frontLineR,
		dynamicSpawnTarget = mkr_fieldRightTop,
		sgroups = {sg_htRight},
		units = {
			{
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
			},
		},
	}
	enc_htRight = Encounter:Create(encData)
	
	Cmd_SquadPath(sg_htRight, "pth_roadRight", true, LOOP_NONE, false)
	_ModifySpeed(sg_htRight, g_vehicleSpeed)
	
	ThreatArrow_CreateGroup(sg_htRight)
	
	--Debuff (only in easy/normal)
	if(g_difficulty <= GD_NORMAL) then
		local newArmorVal = Util_DifVar({0.65, 0.8}, g_difficulty)
		Event_Proximity(_DebuffUnit, {group = sg_htRight, newArmorMod = newArmorVal}, sg_htRight, mkr_intersection, 9.0, ANY)
	end
	
	--On hard, have the Vehicle drive into the trainyard after a delay.
	if(g_difficulty >= GD_HARD) then
		Event_Proximity(VehicleAttackStation, enc_htRight, sg_htRight, mkr_intersection, 10, ANY, g_roadHTDelay)
	end
end


--[[ Trainyard attack goals]]
function AttackLeftRoad(encounter) --Attack road on left side
	local goalData = {
		name = "Attack",
		target = trg_roadLeft,
		range = 25,
		leashRange = 20,
		movePathLengthFactor = 1.0,
		attackMove = true,
		tacticTargetPreference = AITacticTargetPreference_Near,
		coordinatedSetup = false,
		abilityBlacklist = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
		},
		fallbackParams = {
			thresholds = {0.15},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_pincerLeft},
			retreat = true,
		},
		maxIdleTime = 10,
		onTransition = _CheckRetreat,
		onSuccess = AttackStation,
		onFailure = Despawn,
	}
	encounter:SetGoal(goalData)
end

function AttackCenter(encounter) -- Attack houses in the middle of the map
	local goalData = {
		name = "Attack",
		target = trg_wrecks,
		range = 25,
		leashRange = 20,
		movePathLengthFactor = 1.0,
		attackMove = true,
		tacticTargetPreference = AITacticTargetPreference_Near,
		maxAttackers = 2,
		coordinatedSetup = false,
		abilityBlacklist = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				waitTimeSecs = 13,
			},
		},
		fallbackParams = {
			thresholds = {0.15},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_sandbags1},
			retreat = true,
		},
		maxIdleTime = 10,
		onTransition = _CheckRetreat,
		onSuccess = AttackStation,
		onFailure = Despawn,
	}
	encounter:SetGoal(goalData)
end

function AttackIntersection(encounter) --Attack the middle intersection
	local goalData = {
		name = "Attack",
		target = mkr_introTruck1,
		range = 25,
		leashRange = 20,
		movePathLengthFactor = 1.0,
		attackMove = true,
		tacticTargetPreference = AITacticTargetPreference_Near,
		maxAttackers = 2,
		coordinatedSetup = false,
		abilityBlacklist = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
		},
		fallbackParams = {
			thresholds = {0.25},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_line1},
			retreat = true,
		},
		maxIdleTime = 10,
		onTransition = _CheckRetreat,
		onSuccess = AttackStation,
		onFailure = Despawn,
	}
	encounter:SetGoal(goalData)
end

function AttackHouses(encounter) --Attacks houses to the right-hand side of the trainyard (northern road)
	local goalData = {
		name = "Attack",
		target = mkr_civilians1,
		range = 22,
		leashRange = 18,
		movePathLengthFactor = 1.0,
		attackEngagementMove = true,
		attackMove = true,
		coordinatedSetup = false,
		abilityBlacklist = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 100,
			},
		},
		fallbackParams = {
			thresholds = {0.15},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_roadNorth},
			retreat = true,
		},
		maxIdleTime = 9,
		onTransition = _CheckRetreat,
		onSuccess = AttackStation,
		onFailure = Despawn,
	}
	encounter:SetGoal(goalData)
end

function AttackStation(encounter) --Orders the encounter to attack the trainyard
	local goalData = {
		name = "Attack",
		target = mkr_trainStation,
		leashRange = 20,
--~ 		tacticCloseGround = true,
		movePathLengthFactor = 1.0,
--~ 		attackMove = true,
		coordinatedSetup = false,
		abilityBlacklist = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
		},
		fallbackParams = {
			thresholds = {0.30},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_line1},
			retreat = true,
		},
		maxIdleTime = -1,
		onTransition = _CheckRetreat,
		onFailure = Despawn,
	}
	encounter:SetGoal(goalData)
end

function VehicleAttackStation(encounter)
	local goalData = {
		name = "Attack",
		target = mkr_trainStation,
		leashRange = 25,
		range = 17,
		movePathLengthFactor = 1.0,
		safeMoveWeight = 0.0,
		coordinatedSetup = false,
		maxIdleTime = -1,
	}
	encounter:SetGoal(goalData)
end



--[[ German tanks ]]
function TankCenter()
	--[[Tank center]]
	local encData = {
		name = "tankCenter",
		sgroups = {sg_enemyTanks},
		spawn = mkr_enemySpawn,
		dynamicSpawnTarget = mkr_intersectionCenter,
		units = {
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD,
				upgrades = UPG.GERMAN.PANZER_TOP_GUNNER,
			},
		},
		onDeath = TankCenter
	}
	enc_tankCenter = Encounter:Create(encData)
	t_tankEncs.center = enc_tankCenter
	
	Cmd_SquadPath(enc_tankCenter.sgroup, "pth_tankAttack", true, LOOP_NONE, true, 0)
end

function TankRight()
	--[[Tank right]]
	local encData = {
		name = "tankRight",
		sgroups = {sg_enemyTanks},
		spawn = mkr_roadNorth,
		units = {
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD,
				upgrades = Util_DifVar({nil, nil, UPG.GERMAN.PANZER_TOP_GUNNER}, g_difficulty),
			},
		},
		onDeath = TankRight
	}
	enc_tankRight = Encounter:Create(encData)
	t_tankEncs.right = enc_tankRight
	
	Cmd_SquadPath(enc_tankRight.sgroup, "pth_pincerRight", true, LOOP_NONE, true, 0)
end

function TankLeft()
	--[[Tank left]]
	local encData = {
		name = "tankLeft",
		sgroups = {sg_enemyTanks},
		spawn = mkr_attackLeft,
		dynamicSpawnTarget = Marker_GetPosition(mkr_flameDest1),
		units = {
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD,
				upgrades = Util_DifVar({nil, nil, UPG.GERMAN.PANZER_TOP_GUNNER}, g_difficulty),
			},
		},
		onDeath = TankLeft
	}
	enc_tankLeft = Encounter:Create(encData)
	t_tankEncs.left = enc_tankLeft
	
	Cmd_SquadPath(enc_tankLeft.sgroup, "pth_pincerLeft", true, LOOP_NONE, true, 0)
end

function TankSupport()
	local encData = {
		name = "tankSupport",
		sgroups = {sg_currentAttackers},
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_sandbags1,
				dynamicSpawnTarget = mkr_flameDest1,
				onDeath = ReplaceUnit,
				difficulty = {GD_NORMAL, GD_HARD},
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_sandbags1,
				dynamicSpawnTarget = mkr_flameDest1,
				onDeath = ReplaceUnit,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = trg_frontLine,
				dynamicSpawnTarget = mkr_intersectionCenter,
				onDeath = ReplaceUnit,
			},
		},
	}
	enc_tankSupport = Encounter:Create(encData)
	
	AttackIntersection(enc_tankSupport)
end	





-------------------------------------------------------------------------
-- UTIL FUNCTIONS
-------------------------------------------------------------------------
function _CheckRetreat(enc, state)
	if(state == AIObjectiveStage_Fallback) then
		SGroup_RemoveGroup(sg_currentAttackers, enc.sgroup)
	end
end

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

function ReplaceUnit(unit)
	local enc = unit.encounter
	
	enc:AddUnit(unit.data)
	
	if(not enc:Goal_HasValidObjective()) then
		enc:RestartGoal()
	end	
end

function ReplaceUnitLimited(unit)
	if(_MaxAttackSquads()) then
		local enc = unit.encounter
		
		enc:AddUnit(unit.data)
		
		if(not enc:Goal_HasValidObjective()) then
			enc:RestartGoal()
		end
	end
end

function _IsEncounterActive(enc)
	return enc ~= nil and enc:IsAlive() and enc:IsEnabled()
end

function _DebuffUnit(data)
	Modify_Armor(data.group, data.newArmorMod)
	if(SGroup_GetAvgHealth(data.group) <= 0.33) then
		print("Debuffing unit x2.5...") --Debug
		Modify_ReceivedDamage(data.group, 1.75)
	else
		print("Debuffing unit x1.5...") --Debug
		Modify_ReceivedDamage(data.group, 1.3)
	end
end

function _CheckPlayerPopulation()
	return Player_GetCurrentPopulation(player1, CT_Personnel) >= Player_GetMaxPopulation(player1, CT_Personnel)/2
end

function _MaxAttackSquads()
	return SGroup_CountSpawned(sg_currentAttackers) < Util_DifVar({7, 9, 10}, g_difficulty)
end
