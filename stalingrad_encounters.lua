-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Encounter/Goal data for M05_Stalingrad
-- Designer: Andres Molina
-------------------------------------------------------------------------
-------------------------------------------------------------------------

--************************************************************************************************************************************************
-- 												OBJECTIVE 1 - Establish a Perimeter.
--************************************************************************************************************************************************

--[[ Start ]]
function Push0() --Initial push when the mission starts
	local encData = {
		name = "push0_1",
		units = {
			{
				sbp = (g_difficulty == GD_HARD and SBP.GERMAN.PANZER_GRENADIER_SQUAD or SBP.GERMAN.GRENADIER_SQUAD),
				spawn = mkr_enc5_1,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_aimArea5,
				difficulty = GD_HARD,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_spawnRoad,
			},
		}
	}
	g_enc_push0 = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = mkr_factory,
		attackMove = true,
		safeMoveWeight = 0.0,
		garrisonIdle = false,
		garrison = false,
		coordinatedSetup = false,
	}
	g_enc_push0:SetGoal(goalData)
end

function HarassBase()
	--This is stopped when player triggers stopHarass()
	if(not _IsEncounterActive(g_enc_harassBase)) then
		local encData = {
			name = "harassBase",
			spawn = mkr_enc2,
			units = {
				(g_difficulty == GD_HARD and SBP.GERMAN.GRENADIER_SQUAD or SBP.GERMAN.OSTRUPPEN_SQUAD),
				{
					sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
					difficulty = GD_HARD
				}
			},
		}
		g_enc_harassBase = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			target = mkr_alliedHMG,
			movePathLengthFactor = 1.0,
			fallbackParams = {
				thresholds = {0.33},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_enc2},
				retreatOnSuppression = true,
			},
			maxIdleTime = -1,
			onFailure = Despawn,
		}
		g_enc_harassBase:SetGoal(goalData)
	end
end


--[[ POINT A  - In front of HQ]]
function PointA()
	local encData = {
		name = "pointA",
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_aimArea5,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_demopack0,
				difficulty = GD_HARD,
			},
		},
	}
	g_enc_pointA = Encounter:Create(encData)

	local goalData = {
		name = "Attack",
		target = mkr_pointA,
		leashRange = mkr_pointA,
		range = 25,
		garrisonIdle = false,
		garrison = false,
		tacticControlsList = {
			{
				tacticType = TACTIC_Pickup,
				priority = -1,
			},
			{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = -1,
			},
		},
		fallbackParams = {
			thresholds = {0.33},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_spawn4},
			retreat = true,
		},
		onFailure = Desp,
		maxIdleTime = -1,
	}
	g_enc_pointA:SetGoal(goalData)
end

function PushA() --Pioneers attack point A
	local encData = {
		name = "pushA",
		units = {
			{
				sbp = SBP.GERMAN.PIONEER_SQUAD,
				spawn = mkr_pioneer2,
				dynamicSpawnTarget = mkr_demopack0,
				upgrades = (g_difficulty == GD_HARD and UPG.GERMAN.PIONEER_FLAMETHROWER or nil),
			},
			{
				sbp = SBP.GERMAN.PIONEER_SQUAD,
				spawn = mkr_pioneer2,
				dynamicSpawnTarget = mkr_pioneer1,
				upgrades = (g_difficulty >= GD_NORMAL and UPG.GERMAN.PIONEER_FLAMETHROWER or nil),
			},
		},
	}
	g_enc_pushA = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = mkr_pointA,
		range = 18,
		leashRange = 22,
		attackMove = true,
		safeMoveWeight = 0.0,
		coordinatedSetup = false,
		tacticCloseGround = 1.0,
		fallbackParams = {
			thresholds = {0.25},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_enc5_3},
			retreat = true,
		},
		maxIdleTime = -1,
		onFailure = DefeatedPushA,
	}
	g_enc_pushA:SetGoal(goalData)

	if(g_difficulty > GD_EASY) then
		Event_PlayerCanSeeElement(InformPioneers, nil, player1, g_enc_pushA.sgroup, ANY)
	end
end

function DefeatedPushA(enc)
	if(threatID_pioneers1 ~= nil) then
		ThreatArrow_DestroyGroup(threatID_pioneers1)
	end
	Despawn(enc)
end


--[[ AREA 5 - Above point-A ]]
function Area5()
	local encData = {
		name = "HTarea5",
		units = {
			{
				sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
				spawn = mkr_tankSpawn1,
			},
		},
	}
	g_enc_HTArea5 = Encounter:Create(encData)
	

	local encData = {
		name = "area5",
		spawn = mkr_enc5_4,
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				difficulty = GD_EASY,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_enc5_3,
				difficulty = {GD_NORMAL, GD_HARD},
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = UPG.GERMAN.GRENADIER_MG42_LMG,
				difficulty = GD_HARD,
			},
		}
	}
	g_enc_area5 = Encounter:Create(encData)
	
	SGroup_SetInvulnerable(g_enc_area5.sgroup, true)
	Event_IsUnderAttack(AttackArea5, nil, g_enc_area5.sgroup, ANY, 2)
end

function AttackArea5()
	SGroup_SetInvulnerable(g_enc_area5.sgroup, false) --This is to make sure the player doesn't take out the encounter from a distance.
	
	local goalData = {
		name = "Defend",
		target = mkr_enc5,
		range = mkr_enc5,
		leashRange = mkr_enc5,
		fallbackParams = {
			thresholds = {0.2},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {trg_enc3},
			retreat = true,
		},
		maxIdleTime = -1,
		onFailure = Despawn,
	}
	if(g_enc_area5:IsAlive()) then
		g_enc_area5:SetGoal(goalData)
	end
	
	
	--Send in HT to attack
	local goalData = {
		name = "Attack",
		target = mkr_enc5,
		movePathLengthFactor = 1.0,
		maxIdleTime = -1,
	}
	if(g_enc_HTArea5:IsAlive()) then
		g_enc_HTArea5:SetGoal(goalData)
	end
	
	
	--Grenadiers that come in, and fallback to pointD when low health
	local encData = {
		name = "attack5",
		spawn = mkr_spawn4,
		units = {
			{
				sbp = g_diffVariableSBP,
			},
			{
				sbp = Util_DifVar({SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.GRENADIER_SQUAD}, g_difficulty),
			},
		},
	}
	g_enc_attack5 = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = mkr_enc5,
		leashRange = 25,
		fallbackParams = {
			thresholds = {Util_DifVar({0.50, 0.33, 0.10}, g_difficulty)},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_pointD},
		},
		maxIdleTime = -1,
		onFailure = DefendPointD,
	}
	g_enc_attack5:SetGoal(goalData)
end


--[[ AREA 2 - In between point-A and point-B ]]
function Area2()
	local encData = {
		name = "Area2",
		units = {
			{
				sbp = g_diffVariableSBP,
				spawn = mkr_enc2,
			}
		},
	}
	g_enc_area2 = Encounter:Create(encData)

	local goalData = {
		name = "Defend",
		target = mkr_enc2,
		leashRange = mkr_enc2,
		garrisonIdle = false,
		garrison = false,
		fallbackParams = {
			thresholds = {0.26},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_c4},
			retreat = true,
		},
		onFailure = Despawn,
	}
	g_enc_area2:SetGoal(goalData)
end

function HMG1Pos1() --Move HMG 1 to desired position
	SpawnHMGArea2(mkr_mgPos1)

	Event_Remove(proxHmg1Pos2)
	Event_Remove(proxHmg1Pos3)
end

function HMG1Pos2()
	SpawnHMGArea2(mkr_mgPos2)
	
	Event_Remove(proxHmg1Pos1)
	Event_Remove(proxHmg1Pos3)
end

function HMG1Pos3()
	SpawnHMGArea2(mkr_mgPos3)

	Event_Remove(proxHmg1Pos1)
	Event_Remove(proxHmg1Pos2)
end

function SpawnHMGArea2(dest)
	--Scripted HMG to position
	sg_hmg1 = SGroup_CreateIfNotFound("sg_hmg1")
	if(SGroup_IsEmpty(sg_hmg1)) then		
		local pos = Util_FindHiddenSpawn(Marker_GetPosition(mkr_pointB), Marker_GetPosition(mkr_enc2))
		Util_CreateSquads(player2, sg_hmg1, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, pos, dest)
	end
end


--[[ POINT B  - Waterplant ]]
function PointB()
	local encData = {
		name = "pointB",
		spawn = mkr_b1,
		units = {
			{
				sbp = Util_DifVar({SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.PANZER_GRENADIER_SQUAD}, g_difficulty),
			},
			{
				sbp = Util_DifVar({SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.GRENADIER_SQUAD}, g_difficulty),
				spawn = trg_flammer2,
				dropItems = {
					{
						slotItem = SLOT_ITEM.GRENADIER_MG42_LMG,
						dropChance = 1.0,
						exclusive = true,
					}
				}
			},
			{
				name = "supportPointB",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_c4,
				dynamicSpawnTarget = trg_flammer,
				upgrades = Util_DifVar({nil, UPG.GERMAN.GRENADIER_MG42_LMG}, g_difficulty),
			}
		},
	}
	g_enc_pointB = Encounter:Create(encData)
	
	sg_garrisonPtB = Util_CreateSquads(player2, "sg_garrisonPtB", SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_pointB)
	Squad_GiveSlotItem(SGroup_GetSpawnedSquadAt(sg_garrisonPtB, 1), SLOT_ITEM.PANZERSHRECK)
	
	if(g_difficulty >= GD_HARD) then
		sg_mortarB = Util_CreateSquads(player2, "sg_mortarB", SBP.GERMAN.MORTAR_TEAM_81MM, trg_flammer, mkr_mortarB)
	end
	
end

function EngagePointB()
	local goalData = {
		name = "Defend",
		target = mkr_pointB,
		range = mkr_pointB,
		leashRange = mkr_pointB,
		garrisonIdle = false,
		garrison = true,
		coordinatedSetupFacingPositions = {mkr_reinforceB},
		onFailure = Despawn,
	}
	g_enc_pointB:SetGoal(goalData)
end

function ReinforceB()
	--Bring in reinforcements from the top
	local encData = {
		name = "reinforceB",
		spawn = mkr_enc6,
		dynamicSpawnTarget = trg_mg2Pos3,
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
			},
			{
				sbp = g_diffVariableSBP,
				spawn = mkr_c7,
				dynamicSpawnTarget = mkr_flammer,
			},
			{
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
				difficulty = GD_HARD,
			}
		},
	}
	g_enc_reinforceB = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = mkr_b2,
		range = 25,
		leashRange = 18,
		attackMove = true,
		coordinatedSetup = false,
		garrison = true,
		fallbackParams = {
			thresholds = {0.15},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_road4},
			retreat = true,
		},
		onFailure = Despawn,
	}
	g_enc_reinforceB:SetGoal(goalData)
end



--[[ POINT D - Center territory]]
function PointD()
	local encData = {
		name = "defendD",
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_d2,
				upgrades = (g_difficulty == GD_HARD and UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM or nil),
				dropItems = {
					{
						slotItem = SLOT_ITEM.PANZERSHRECK,
						dropChance = 1.0,
						exclusive = true,
						difficulty = GD_HARD,
					}
				},
				veterancyRank = Util_DifVar({0, 0, 2}, g_difficulty),
			},
			{
				sbp = Util_DifVar({SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.GRENADIER_SQUAD}, g_difficulty),
				spawn = mkr_d4,
			},
			{
				sbp = g_diffVariableSBP,
				spawn = mkr_enc7,
			},
		}
	}
	g_enc_pointD = Encounter:Create(encData)
	g_enc_pointD:Disable()	
	
	local goalData = {
		name = "Defend",
		target = mkr_pointD,
		leashRange = Util_DifVar({25, 30, 35}, g_difficulty),
		range = 35,
		garrisonIdle = false,
		garrison = false,
		fallbackParams = {
			thresholds = {0.35},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_f1},
			retreat = true,
		},
		onFailure = Despawn,
	}
	g_enc_pointD:SetGoal(goalData)
	
end

function PushD()
	local encData = {
		name = "pushD",
		units = {
			{
				sbp = Util_DifVar({SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.PANZER_GRENADIER_SQUAD}, g_difficulty),
				spawn = mkr_f1,
				dynamicSpawnTarget = mkr_enc4,
			},
			{
				sbp = Util_DifVar({SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.GRENADIER_SQUAD}, g_difficulty),
				spawn = mkr_enc7,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_enc7,
				difficulty = GD_HARD,
			},
		},
	}
	g_enc_pushD = Encounter:Create(encData)
	
	
	local goalData = {
		name = "Attack",
		target = mkr_pointD,
		range = 35,
		leashRange = 35,
		attackMove = true,
		coordinatedSetup = false,
		tacticControlsList = {
			{
				tacticType = TACTIC_Pickup,
				priority = -1,
			},
		},
		fallbackParams = {
			thresholds = {0.25},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_f1},
			retreat = true,
		},
		maxIdleTime = -1,
	}
	g_enc_pushD:SetGoal(goalData)
	
	Rule_AddOneShot(PushDStug, 10)
end

function PushDStug()
	--Add a Stug into the mix
	sg_stugD = Util_CreateSquads(player2, "sg_stugD", (g_difficulty <= GD_NORMAL and SBP.GERMAN.STUG_III_E_SQUAD or SBP.GERMAN.STUG_III_SQUAD), mkr_enc7, mkr_stugDest)
	Cmd_InstantUpgrade(sg_stugD, BP_GetUpgradeBlueprint("disable_abandon_critical_squad"))
	if(g_difficulty > GD_NORMAL) then
		Cmd_InstantUpgrade(sg_stugD, UPG.GERMAN.STUG_TOP_GUNNER)
	end
	
	Event_ElementOnScreen(EventHandler_StartIntel, {intel_callback = EVENTS.Obj1_Stug}, player1, sg_stugD, ANY, 0.75, 1)
	
	if(g_difficulty > GD_EASY) then
		Rule_AddDelayedInterval(StugMortarReact, 11, 4)
	end
end

function StugMortarReact()
	if(SGroup_CountSpawned(sg_stugD) == 0) then
		Rule_RemoveMe()
	else
		local sg_stugAttackers = SGroup_CreateIfNotFound("stugAttackers")
		SGroup_GetLastAttacker(sg_stugD, sg_stugAttackers)
		SGroup_Filter(sg_stugAttackers, SBP.SOVIET.PM_82_41_MORTAR_SQUAD, FILTER_KEEP)
		
		if(SGroup_CountSpawned(sg_stugAttackers) > 0) then
			Rule_RemoveMe()
			enc_stugD = Encounter:ConvertSgroup(sg_stugD)
			
			local goalData = {
				name = "Attack",
				target = mkr_pointD,
				range = mkr_pointD,
				leashRange = 35,
			}
			enc_stugD:SetGoal(goalData)

		end
	end
end


function DefendPointD(enc)
	local goalData = {
		name = "Defend",
		target = mkr_pointD,
		range = mkr_pointD,
		leashRange = mkr_pointD,
		maxIdleTime = -1,
	}
	enc:SetGoal(goalData)
end

function AttackMiddleRoad(enc)
	local goalData = {
		name = "Attack",
		target = mkr_middleRoad,
		range = 30,
		leashRange = 30,
		maxIdleTime = -1,
	}
	enc:SetGoal(goalData)
end






--************************************************************************************************************************************************
-- 														OBJECTIVE 2 - Secure the bridges
--************************************************************************************************************************************************

--[[ AREA 3 ]]
function Area3()
	sg_hmgArea3 = Util_CreateSquads(player2, "sg_hmgArea3", SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, eg_garrisonArea3)

	sg_garrisonArea3 = Util_CreateSquads(player2, "sg_garrisonArea3", SBP.GERMAN.GRENADIER_SQUAD, mkr_enc3)
	if(g_difficulty >= GD_HARD) then
		SGroup_IncreaseVeterancyRank(sg_garrisonArea3, 2, true)
		Util_CreateSquads(player2, sg_garrisonArea3, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_e1)
	end
end

function StartArea3()
	local encData = {
		name = "attackersArea3",
		spawn = mkr_howitzer2enc,
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				difficulty = GD_HARD,
			}
		}
	}
	g_enc_area3 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_e1,
		range = 25,
		leashRange = mkr_e1,
		attackMove = true,
		tacticTargetPreference = AITacticTargetPreference_Near,
		fallbackParams = {
			thresholds = {0.51},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_pointE},
		},
		maxIdleTime = -1,
		onFailure = DefendPointE,
	}
	g_enc_area3:SetGoal(goalData)
end



--[[ POINT E -  Left bridge (1) ]]
function PointE()
	sg_roadAT1 = Util_CreateSquads(player2, "sg_roadAT1", SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_road3, nil, nil, nil, nil, mkr_road2)
	if(g_difficulty >= GD_HARD) then
		Util_LogSyncWpn(sg_roadAT1, true)
	end
	if(g_difficulty >= GD_NORMAL) then
		sg_roadAT2 = Util_CreateSquads(player2, "sg_roadAT2", SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_road2, nil, nil, nil, nil, mkr_enc7)
		Util_LogSyncWpn(sg_roadAT2, true)
	end
	
	sg_hmgBunker1 = Util_CreateSquads(player2, "sg_hmgBunker1", SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, eg_bunker1, nil, nil, nil, nil, mkr_road1)
	Event_ElementOnScreen(EventHandler_StartIntel, {intel_callback = EVENTS.Bridges_HateBunker}, player1, eg_bunker1, ANY, 0.8, 1)
	
	local encData = {
		name = "pointE",
		units = {
			{
				sbp = Util_DifVar({SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.GRENADIER_SQUAD}, g_difficulty),
				spawn = mkr_e2,
				veterancyRank = g_difficulty,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_e3,
				upgrades = Util_DifVar({nil, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM}, g_difficulty),
				veterancyRank = g_difficulty+1,
				dropItems = {
					{
						slotItem = SLOT_ITEM.PANZERSHRECK,
						dropChance = 1.0,
						exclusive = true,
						difficulty = {GD_EASY, GD_NORMAL},
					}
				}
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_road1,
				upgrades = UPG.GERMAN.GRENADIER_MG42_LMG,
				dropItems = {
					{
						slotItem = SLOT_ITEM.GRENADIER_MG42_LMG,
						dropChance = 1.0,
						exclusive = true,
						difficulty = {GD_EASY, GD_NORMAL},
					}
				}
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_pointE,
				difficulty = GD_HARD,
			},
		}
	}
	g_enc_pointE = Encounter:Create(encData)
	
	Event_IsEngaged(BreachPointE, nil, g_enc_pointE.sgroup, ANY, 4)
	
end

function BreachPointE() --Engage point defense and bring in stray units
	if(g_enc_pointE:IsAlive()) then
		DefendPointE(g_enc_pointE)
	end
end

function DefendPointE(enc)
	local goalData = {
		name = "Defend",
		target = mkr_e3,
		range = 32,
		leashRange = 28,
		coordinatedSetup = false,
		maxIdleTime = -1,
	}
	enc:SetGoal(goalData)
end

function PushPointE()
	--If any guys left behind, send them to defend pointE)
	Event_Remove(proxArea3Start)
	if(not _IsEncounterActive(g_enc_area3) and g_difficulty >= GD_HARD) then
		StartArea3()
		DefendPointE(g_enc_area3)
	end
	
	local encData = {
		name = "PushE",
		spawn = mkr_leftRoad,
		dynamicSpawnTarget = mkr_despawn1,
		units = {
			{
				sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
				veterancyRank = g_difficulty,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				difficulty = GD_NORMAL,
				conditions = not SGroup_IsAlive(sg_garrisonArea3),
			}
		},
	}
	enc_pushE = Encounter:Create(encData)
	
	enc_pushE:AddSgroup(sg_garrisonArea3)
	enc_pushE:AddSgroup(sg_hmgArea3)
	
	DefendPointE(enc_pushE)
end




--[[ POINT F - Right bridge (2) ]]
function PointF()
	sg_garrisonF1 = SGroup_CreateIfNotFound("sg_garrisonF1")
	Util_CreateSquads(player2, sg_garrisonF1, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, eg_bunker2)
	
	local encData = {
		name = "pointF",
		spawn = mkr_pointF,
		units = {
			{
				sbp = g_diffVariableSBP,
				veterancyRank = g_difficulty+1
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = Util_DifVar({nil, nil, UPG.GERMAN.GRENADIER_MG42_LMG}, g_difficulty),
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
			},
		},
	}
	g_enc_pointF = Encounter:Create(encData)
	
	DefendPointF(g_enc_pointF)
		
end

function DefendPointF(enc)
	local goalData = {
		name = "Defend",
		target = mkr_pointF,
		range = 30,
		leashRange = mkr_pointF,
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {mkr_f3, mkr_road4},
		maxIdleTime = -1,
	}
	enc:SetGoal(goalData)
end

function Area6()
	sg_roadAT3 = SGroup_CreateIfNotFound("sg_roadAT3")
	Util_CreateSquads(player2, sg_roadAT3, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_road5, mkr_road5, nil, nil, nil, mkr_enc6)
	
	sg_roadPG = SGroup_CreateIfNotFound("sg_roadPG")
	Util_CreateSquads(player2, sg_roadPG, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_reinforceC, nil, nil, nil, nil, mkr_hmg2)
	if(g_difficulty >= GD_NORMAL) then
		Cmd_InstantUpgrade(sg_roadPG, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM)
	end
	SGroup_AddSlotItemToDropOnDeath(sg_roadPG, SLOT_ITEM.PANZERSHRECK, 1.0, false)
	
	sg_scout2 = Util_CreateSquads(player2, "sg_scout2", SBP.GERMAN.SCOUTCAR_SDKFZ222, mkr_enc6)
	if(g_difficulty >= GD_HARD) then
		SGroup_CompleteEntityUpgrade(sg_scout2, UPG.GERMAN.SDKFZ_222_20MM_GUN)
	end
	
	local encHMGRoad2 = {
		name = "HMGRoad2",
		spawn = mkr_road4,
		units = {
			{
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				veterancyRank = g_difficulty,
			},
		},
	}
	g_enc_HMGRoad2 = Encounter:Create(encHMGRoad2)
	
	local hmgGoal = {
		name = "Defend",
		target = mkr_road4,
		range = 25,
		leashRange = 5,
		maxIdleTime = -1,
	}
	g_enc_HMGRoad2:SetGoal(hmgGoal)
end

function Area4()
	local encData = {
		name = "area4",
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_f2,
			},
			{
				sbp = g_diffVariableSBP,
				spawn = mkr_f3,
				veterancyRank = g_difficulty,
			},
		},
	}
	g_enc_area4 = Encounter:Create(encData)
end

function StartArea4()
	local goalData = {
		name = "Defend",
		target = mkr_enc4,
		leashRange = mkr_enc4,
		range = 26,
		fallbackParams = {
			thresholds = {0.51},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_pointF},
		},
		maxIdleTime = -1,
		onFailure = Util_DifVar({Despawn, DefendPointF}, g_difficulty),
	}
	if(g_enc_area4:IsAlive()) then
		g_enc_area4:SetGoal(goalData)
	end
end








--************************************************************************************************************************************************
-- 													OBJECTIVE 3 - Stop counterattack
--************************************************************************************************************************************************
function CounterAttack1()
	local encData = {
		name = "counterAttack1",
		spawn = mkr_leftRoad,
		dynamicSpawnTarget = mkr_bridgeSpawn1,
		sgroups = {sg_currentAttackers},
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				onDeath = ReplaceUnit,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = Util_DifVar({nil, UPG.GERMAN.GRENADIER_MG42_LMG}, g_difficulty),
				onDeath = ReplaceUnit,
			},
			{
				sbp = g_diffVariableSBP,
				spawn = mkr_end3,
				veterancyRank = g_difficulty,
				onDeath = ReplaceUnit,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				conditions = Util_CountPlayerUnitType(player1, LIST.HMGS, FILTER_KEEP, mkr_road3, 22) > 0,
			}
		},
	}
	enc_counterAttack1 = Encounter:Create(encData, nil, true)

	local goalData = {
		name = "Attack",
		target = mkr_road3,
		range = 21,
		leashRange = 25,
--~ 		attackMove = false, --TODO: Change this to TRUE once Glendon fixes issues with softmap
		movePathLengthFactor = 1.0,
		coordinatedSetup = false,
		tacticControlsList = {
			{
				tacticType = TACTIC_RushAtTarget,
				priority = 10,
			},
		},
		fallbackParams = {
			thresholds = {0.20}, --TUNE
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_end3},
			retreat = true,
		},
		
		maxIdleTime = -1,
		onTransition = _CheckRetreat,
		onFailure = Despawn,
	}
	enc_counterAttack1:SetGoal(goalData)

	Event_PlayerCanSeeElement(CounterAttack1b, nil, player1, enc_counterAttack1.sgroup, ANY, Util_DifVar({20, 15, 10}, g_difficulty))
	
	table.insert(t_encs_counterAttack, enc_counterAttack1)
end

function CounterAttack1b()
	local encData = {
		name = "counterAttack1b",
		spawn = mkr_bridgeSpawn1,
		sgroups = {sg_currentAttackers},
		units = {
			{
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
				abandonable = false,
				entityUpgrades = Util_DifVar({nil, nil, UPG.GERMAN.SDKFZ_222_20MM_GUN}, g_difficulty),
				spawn = mkr_leftRoad,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = trg_end2,
				difficulty = GD_EASY,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				upgrades = Util_DifVar({nil, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM}, g_difficulty),
				spawn = trg_end2,
				difficulty = {GD_NORMAL, GD_HARD},
			},
		},
	}
	enc_counterAttack1b = Encounter:Create(encData)

	local goalData = {
		name = "Attack",
		target = mkr_road3,
		range = 20,
		leashRange = 25,
--~ 		attackMove = false, --TODO: Change this to TRUE once Glendon fixes issues with softmap
		movePathLengthFactor = 1.0,
		coordinatedSetup = false,
		tacticControlsList = {
			{
				tacticType = TACTIC_RushAtTarget,
				priority = 10,
			},
		},
		fallbackParams = {
			thresholds = {0.10}, --TUNE
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_leftRoad},
			retreat = true,
		},
		maxIdleTime = -1,
		onTransition = _CheckRetreat,
		onFailure = Despawn,
	}
	enc_counterAttack1b:SetGoal(goalData)
	
	local hmg = Util_CreateSquads(player2, "hmgBridgeLeft", SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_end3, mkr_AT2)
	Util_LogSyncWpn(hmg, true)
	SGroup_Destroy(hmg)
	hmg = nil
	
	table.insert(t_encs_counterAttack, enc_counterAttack1b)
end

function CounterAttack2()
	local encData = {
		name = "counterAttack2",
		spawn = mkr_rightRoad,
		sgroups = {sg_currentAttackers},
		units = {
			{
				sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
				abandonable = false,
				entityUpgrades = Util_DifVar({nil, nil, UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE}, g_difficulty),
			},
			{
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
				abandonable = false,
				conditions = Util_CountPlayerUnitType(player1, LIST.ATGUNS, FILTER_KEEP, mkr_bridge2, 25) > 0,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_halftrackEnd,
				onDeath = ReplaceUnit,
				difficulty = {GD_NORMAL, GD_HARD}
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_rightRoad2,
				upgrades = Util_DifVar({nil, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM}, g_difficulty),
				veterancyRank = 2,
				onDeath = ReplaceUnit,
			},
			{
				sbp = g_diffVariableSBP,
				veterancyRank = g_difficulty+1,
				onDeath = ReplaceUnit,
			},
		},
	}
	enc_counterAttack2 = Encounter:Create(encData)

	local goalData = {
		name = "Attack",
		target = mkr_bridge2,
		range = 18,
		leashRange = 26,
		movePathLengthFactor = 1.0,
		coordinatedSetup = false,
		fallbackParams = {
			thresholds = {0.10}, --TUNE
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_halftrackEnd},
			retreat = true,
		},
		maxIdleTime = -1,
		onTransition = _CheckRetreat,
		onFailure = Despawn,
	}
	enc_counterAttack2:SetGoal(goalData)
	
	
	local counter2AT = Util_CreateSquads(player2, "counter2AT", SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_rightRoad, mkr_AT1, nil, nil, g_difficulty == GD_HARD)
	Util_LogSyncWpn(counter2AT, true)
	SGroup_Destroy(counter2AT)
	counter2AT = nil
	
	Event_PlayerCanSeeElement(EventHandler_StartIntel, {intel_callback = EVENTS.ObjDefend_Wave2}, player1, enc_counterAttack2.sgroup, ANY, 1.5)
	
	table.insert(t_encs_counterAttack, enc_counterAttack2)
end

function CounterAttack3()
	--[[ LEFT BRIDGE ]]--
	local encData = {
		name = "counterAttack3L",
		spawn = mkr_bridgeSpawn1,
		sgroups = {sg_currentAttackers},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = trg_end2,
			},
			{
				sbp = Util_DifVar({SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.GRENADIER_SQUAD}, g_difficulty),
				spawn = trg_end2,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = Util_DifVar({nil, nil, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM}, g_difficulty),
				spawn = trg_end2,
			},
		},
	}
	enc_counterAttack3L = Encounter:Create(encData)

	local goalData = {
		name = "Attack",
		target = mkr_road3,
		range = 20,
		leashRange = 25,
		movePathLengthFactor = 1.0,
		coordinatedSetup = false,
		fallbackParams = {
			thresholds = {0.25}, --TUNE
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_leftRoad},
			retreat = true,
		},
		maxIdleTime = -1,
		onTransition = _CheckRetreat,
		onFailure = Despawn,
	}
	enc_counterAttack3L:SetGoal(goalData)
	
	table.insert(t_encs_counterAttack, enc_counterAttack3L)
	
	
	--[[ RIGHT BRIDGE ]]--
	local encData = {
		name = "counterAttack3R",
		spawn = mkr_rightRoad,
		sgroups = {sg_currentAttackers},
		units = {
			{
				sbp = Util_DifVar({SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.GRENADIER_SQUAD}, g_difficulty),
				spawn = mkr_halftrackEnd,
				onDeath = ReplaceUnit,
			},
			{
				sbp = Util_DifVar({SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.GRENADIER_SQUAD}, g_difficulty),
				spawn = mkr_rightRoad2,
				veterancyRank = 2,
				onDeath = ReplaceUnit,
			},
			{
				sbp = Util_DifVar({SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.PANZER_GRENADIER_SQUAD}, g_difficulty),
				veterancyRank = g_difficulty+1,
				onDeath = ReplaceUnit,
			},
		},
	}
	enc_counterAttack3R = Encounter:Create(encData)

	local goalData = {
		name = "Attack",
		target = mkr_bridge2,
		range = 18,
		leashRange = 26,
		movePathLengthFactor = 1.0,
		coordinatedSetup = false,
		fallbackParams = {
			thresholds = {0.10}, --TUNE
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_halftrackEnd},
			retreat = true,
		},
		maxIdleTime = -1,
		onTransition = _CheckRetreat,
		onFailure = Despawn,
	}
	enc_counterAttack3R:SetGoal(goalData)
	
	table.insert(t_encs_counterAttack, enc_counterAttack3R)
end

function CounterAttack4()
	--BRIDGE 1
	CounterAttack4_LEFT()
	--BRIDGE 2
	CounterAttack4_RIGHT()	
	
	Event_PlayerCanSeeElement(EventHandler_StartIntel, {intel_callback = EVENTS.ObjDefend_WarnTanks}, player1, {enc_counterAttack4L.sgroup, enc_counterAttack4R.sgroup}, ANY, 1)
	
	table.insert(t_encs_counterAttack, enc_counterAttack4L)
	table.insert(t_encs_counterAttack, enc_counterAttack4R)
end

function CounterAttack4_LEFT()
	local encData = {
		name = "counterAttack4_left",
		spawn = mkr_bridgeSpawn1,
		sgroups = {sg_currentAttackers},
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				onDeath = Util_DifVar({nil, MortarLeft}, g_difficulty),
			},
			{
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
				spawn = mkr_leftRoad,
				killSyncWeapon = true,
			},
			{
				sbp = Util_DifVar({SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.GRENADIER_SQUAD}, g_difficulty),
				onDeath = ReplaceUnit,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_end3_1,
				onDeath = ReplaceUnit,
			},
			{
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
				abandonable = false,
				onDeath = ReplaceUnit,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD,
				upgrades = UPG.GERMAN.PANZER_TOP_GUNNER,
				abandonable = false,
				onDeath = ReplaceUnit,
				difficulty = GD_HARD,
			},
		},
	}
	enc_counterAttack4L = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = mkr_road3,
		range = 15,
		leashRange = 30,
		coordinatedSetup = false,
		movePathLengthFactor = 1.0,
		fallbackParams = {
			thresholds = {0.10},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_despawn1},
			retreat = true,
		},
		maxIdleTime = -1,
		onTransition = _CheckRetreat,
		onFailure = Despawn,
	}
	enc_counterAttack4L:SetGoal(goalData)
end

function MortarLeft()
	Util_CreateSquads(player2, nil, SBP.GERMAN.MORTAR_TEAM_81MM, mkr_bridgeSpawn1, mkr_mortarDestLeft)
end

function CounterAttack4_RIGHT()
	local encData = {
		name = "counterAttack4_right",
		spawn = mkr_rightRoad,
		sgroups = {sg_currentAttackers},
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
			},
			{
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
				spawn = mkr_halftrackEnd,
				killSyncWeapon = true,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				onDeath = ReplaceUnit,
				difficulty = {GD_NORMAL, GD_HARD},
			},
			{
				sbp = Util_DifVar({SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.GRENADIER_SQUAD}, g_difficulty),
				spawn = mkr_end10,
				dynamicSpawnTarget = mkr_rightRoad2,
				onDeath = ReplaceUnit,
			},
			{
				sbp = Util_DifVar({SBP.GERMAN.STUG_III_E_SQUAD, SBP.GERMAN.STUG_III_E_SQUAD, SBP.GERMAN.STUG_III_SQUAD}, g_difficulty),
				spawn = mkr_end10,
				abandonable = false,
				onDeath = ReplaceUnit,
			},
		},
	}
	enc_counterAttack4R = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = mkr_bridge2,
		range = 18,
		leashRange = 26,
		movePathLengthFactor = 1.2,
		coordinatedSetup = false,
		fallbackParams = {
			thresholds = {0.10},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_rightRoad},
			retreat = true,
		},
		maxIdleTime = -1,
		onTransition = _CheckRetreat,
		onFailure = Despawn,
	}
	enc_counterAttack4R:SetGoal(goalData)
end






--************************************************************************************************************************************************
-- 													OBJECTIVE 4 - Destroy the Enemy base
--************************************************************************************************************************************************
--[[ BRIDGE 1 - Left ]]
function SetupBridge1()
	Event_Proximity(Bridge1, {filterlist = {SBP.SOVIET.IL_2_STUMOVIK_SQUAD_MP}, filtertype = FILTER_REMOVE}, player1, mkr_bridgeSpawn1, 8, ANY, 3.0)
	Event_Proximity(TankLeft, {filterlist = {SBP.SOVIET.IL_2_STUMOVIK_SQUAD_MP}, filtertype = FILTER_REMOVE}, player1, trg_end2, nil, ANY)
end

function Bridge1()
	local encData = {
		name = "bridge1",
		spawn = mkr_end6,
		dynamicSpawnTarget = mkr_leftRoad,
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
			}
		},
	}
	enc_bridge1 = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = mkr_despawn1,
		range = 20,
		leashRange = 20,
		attackMove = true,
		movePathLengthFactor = 1.0,
		fallbackParams = {
			thresholds = {0.67},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_end13},
			retreat = true,
		},
		onFailure = Despawn,
	}
	enc_bridge1:SetGoal(goalData)
end

function TankLeft()
	local tankPos = Util_GetPositionFromAtoB(mkr_end6, mkr_leftRoad, 18)
	sg_tankLeft = Util_CreateSquads(player2, "sg_tankLeft", SBP.GERMAN.PANZER_IV_STUBBY_SQUAD, Util_FindHiddenSpawn(mkr_end13, mkr_end6), tankPos, nil, nil, nil, nil, nil, mkr_end6)
	if(g_difficulty >= GD_HARD) then
		Cmd_Upgrade(sg_tankLeft, UPG.GERMAN.PANZER_TOP_GUNNER, 1, true)
	end
	Event_PlayerCanSeeElement(EventHandler_StartIntel, {intel_callback = EVENTS.ObjAttack_Panzer}, player1, sg_tankLeft, ANY, 1)
	
	local encData = {
		name = "infLeftRoad",
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_end13,
				dynamicSpawnTarget = mkr_end6,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_leftRoad2,
			},
		},
	}
	enc_infLeftRoad = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = trg_end2,
		range = 35,
		leashRange = 30,
		coordinatedSetup = false,
		movePathLengthFactor = 1.0,
		abilityControlsList = {
			{
				abilityPBG = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
				maxCasters = 0,
			},
		},
		fallbackParams = {
			thresholds = {0.63},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_despawn4},
			retreat = true,
		},
		maxIdleTime = -1,
		onFailure = Despawn,
	}
	enc_infLeftRoad:SetGoal(goalData)
end


--[[ DEPOT ]]
function SetupDepot()
	local encData = {
		name = "depot",
		spawn = mkr_depot,
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
			},
		},
	}
	g_enc_endDepot = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_depot,
		range = 25,
		leashRange = mkr_depot,
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {trg_hiddenPath},
		maxIdleTime = -1,
	}
	if(g_difficulty == GD_EASY) then
		goalData.tacticControlsList = {
			{
				tacticType = TACTIC_Pickup,
				priority = -1,
			},
			{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = -1,
			},
		}
	end
	g_enc_endDepot:SetGoal(goalData)
end



--[[ CENTER ]]
function SetupBasePerimeter()
	--Infantry
	local sg_basePerim1 = Util_CreateSquads(player2, "sg_basePerim1", SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_end4)
	Event_OnHealth(_RunAway, {group = sg_basePerim1, dest = mkr_baseExit}, sg_basePerim1, 0.5, false)
	
	local encData = {
		name = "basePerimInfantry",
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_end5,
				moveTo = mkr_end3,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = Util_DifVar({nil, UPG.GERMAN.GRENADIER_MG42_LMG}, g_difficulty),
				spawn = mkr_end5,
				moveTo = mkr_end3_1,
			},
		},
	}
	g_enc_basePerimInfantry = Encounter:Create(encData)
	Event_IsEngaged(EngagePerimInfantry, nil, g_enc_basePerimInfantry.sgroup, ANY, 3, 1.5)
	
	
	--Light vehicle
	local encData = {
		name = "scoutPerim",
		units = {
			{
				sbp = Util_DifVar({SBP.GERMAN.SCOUTCAR_SDKFZ222, SBP.GERMAN.SCOUTCAR_SDKFZ222, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD}, g_difficulty),
				spawn = mkr_scoutEnd,
				entityUpgrades = Util_DifVar({nil, UPG.GERMAN.SDKFZ_222_20MM_GUN, UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE}, g_difficulty),
			},
		},
	}
	enc_scoutPerim = Encounter:Create(encData)
	
	if(g_difficulty >= GD_HARD) then
		Event_IsEngaged(EngageScoutPerim, nil, enc_scoutPerim.sgroup, ANY, 3, 3.0)
	end
	
	
	--Gate HMG
	local encData = {
		name = "baseGateHMG",
		spawn = mkr_end14,
		units = {
			{
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
			},
		},
	}
	g_enc_baseGateHMG = Encounter:Create(encData)
	StationaryDefend(g_enc_baseGateHMG, mkr_end14, mkr_end5)
	
	
	--Gate AT
	local encData = {
		name = "baseGateAT",
		spawn = mkr_baseAT,
		units = {
			{
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
			},
		},
	}
	g_enc_baseGateAT = Encounter:Create(encData)
	StationaryDefend(g_enc_baseGateAT, mkr_baseAT, mkr_end3)
end

function StationaryDefend(encounter, position, facing)
	local goalData = {
		name = "Defend",
		target = position,
		leashRange = 5,
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {facing},
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
		},
	}
	encounter:SetGoal(goalData)
end

function EngagePerimInfantry()
	local goalData = {
		name = "Defend",
		target = mkr_howitzerRange3,
		range = 32,
		leashRange = 26,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
		},
		fallbackParams = {
			thresholds = {0.51},
--~ 			thresholdType = Threshold_PercentageEntitiesRemaining,
			globalPercentage = 0.9,
			markers = {mkr_baseExit},
			retreat = true,
		},
		onFailure = Despawn,
		maxIdleTime = -1,
	}
	if(g_enc_basePerimInfantry:IsAlive()) then
		g_enc_basePerimInfantry:SetGoal(goalData)
	end
end

function EngageScoutPerim()
	local goalData = {
		name = "Attack",
		target = trg_panzerBase,
		range = 40,
		leashRange = 40,
		maxIdleTime = -1,
	}
	if(enc_scoutPerim:IsAlive()) then
		enc_scoutPerim:SetGoal(goalData)
	end
end


--[[ ENEMY BASE ]]
function SetupEnemyBase()
	--Infantry inside the base
	sg_baseGermans = SGroup_CreateIfNotFound("baseGermans")
	
	local encData = {
		name = "infBase",
		sgroups = {sg_baseGermans},
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_base2,
			},
			{
				sbp = SBP.GERMAN.OFFICER_SQUAD,
				spawn = mkr_base1,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_base4,
			},
			{
				sbp = Util_DifVar({SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.MORTAR_TEAM_81MM}, g_difficulty),
				spawn = mkr_base3,
			},
		},
	}
	enc_infBase = Encounter:Create(encData)
	
	
	--Panzer inside base
	local encData = {
		name = "panzerBase",
		spawn = trg_enemyBase,
		units = {
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD,
				upgrades = Util_DifVar({nil, UPG.GERMAN.PANZER_TOP_GUNNER}, g_difficulty),
			}
		},
	}
	enc_panzerBase = Encounter:Create(encData)
	Event_Proximity(PanzerBaseMove, {filterlist = {SBP.SOVIET.IL_2_STUMOVIK_SQUAD_MP}, filtertype = FILTER_REMOVE}, player1, trg_panzerBase, nil, ANY)
end

function PanzerBaseMove()
	--Make Enemy HQ weaker
	Modify_Armor(eg_enemyBaseBldgs, 0.5)
	Modify_ReceivedDamage(eg_enemyBaseBldgs, 2.0)
	
	if(enc_panzerBase:IsAlive()) then
		Modify_ReceivedDamage(enc_panzerBase.sgroup, 1.35)
		Cmd_Move(enc_panzerBase.sgroup, trg_panzerBase)

		Event_PlayerCanSeeElement(InformPanzer, nil, player1, enc_panzerBase.sgroup, ANY, 1.5)
		Event_Proximity(StartPanzerDefense, nil, enc_panzerBase.sgroup, trg_panzerBase, 6, ANY, Util_DifVar({10, 5, 0}, g_difficulty))
	end
end

function InformPanzer()
	if(enc_panzerBase:IsAlive()) then
		Util_StartIntel(EVENTS.ObjAttack_Panzer2)
		Event_OnHealth(EventHandler_StartIntel, {intel_callback = EVENTS.ObjAttack_FinalPush}, enc_panzerBase.sgroup, 0.0, false, 1.0)
	end
end

function StartPanzerDefense()
	local goalData = {
		name = "Defend",
		target = trg_panzerBase,
		range = 40,
		leashRange = 40,
		maxIdleTime = -1,
	}
	
	if(enc_panzerBase:IsAlive()) then
		enc_panzerBase:SetGoal(goalData)
	end
end



--[[ BRIDGE 2 - Right ]]
function SetupBridge2()
	sg_bridgeRight1 = Util_CreateSquads(player2, "sg_bridgeRight1", SBP.GERMAN.GRENADIER_SQUAD, mkr_end9, nil, nil, nil, nil, nil, UPG.GERMAN.GRENADIER_MG42_LMG)
	Event_OnHealth(_RunAway, {group = sg_bridgeRight1, dest = mkr_despawn3}, sg_bridgeRight1, 0.45, false)
	
	sg_bridgeRight2 = Util_CreateSquads(player2, "sg_bridgeRight2", SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_end7, nil, nil, nil, nil, nil, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM)
	Event_OnHealth(_RunAway, {group = sg_bridgeRight2, dest = mkr_despawn3}, sg_bridgeRight2, 0.25, false)
	
	sg_bridgeRight3 = Util_CreateSquads(player2, "sg_bridgeRight3", SBP.GERMAN.PIONEER_SQUAD, mkr_end10, mkr_rightRoad2, nil, nil, nil, nil, UPG.GERMAN.PIONEER_FLAMETHROWER)
	Event_OnHealth(_RunAway, {group = sg_bridgeRight3, dest = mkr_despawn3}, sg_bridgeRight3, 0.55, false)
	
	local encData = {
		name = "tankRight",
		units = {
			{
				sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
				spawn = mkr_stug,
				abandonable = false,
			},
		},
	}
	enc_tankRight = Encounter:Create(encData)
end





--************************************************************************************************************************************************
-- 													BONUS 1 - Locate enemy howitzers
--************************************************************************************************************************************************
function SetupHowitzerEncounter1()
	--Howitzer 1
	local encData = {
		name = "Howitzer1",
		spawn = mkr_howitzer1enc,
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				difficulty = {GD_NORMAL, GD_HARD},
			},
			{
				sbp = SBP.GERMAN.PIONEER_SQUAD,
				difficulty = {GD_EASY},
			},
		},
	}
	enc_howitzer1 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_howitzer1enc,
		range = 25,
		leashRange = mkr_howitzer1enc,
		garrisonIdle = false,
		garrison = false,
	}
	enc_howitzer1:SetGoal(goalData)
end

function SetupHowitzerEncounter2()
	--Howitzer 2
	local encData = {
		name = "Howitzer2",
		spawn = mkr_howitzer2enc,
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				difficulty = {GD_NORMAL, GD_HARD},
			},
			{
				sbp = SBP.GERMAN.PIONEER_SQUAD,
				difficulty = {GD_EASY},
			},
		},
	}
	enc_howitzer2 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_howitzer2enc,
		range = 25,
		leashRange = 18,
		fallbackParams = {
			thresholds = {0.26},
			markers = {trg_hiddenPath},
			retreat = true,
		},
		onFailure = Despawn,
		maxIdleTime = -1,
	}
	enc_howitzer2:SetGoal(goalData)
end



--************************************************************************************************************************************************
-- 													BONUS 2 - Secure northern bridge
--************************************************************************************************************************************************
--[[ POINT C - Lower right ]]
function SetupNorthBridge()
	--Germans blocking bridge
	sg_northBridge = SGroup_CreateIfNotFound("sg_northBridge")
	Util_CreateSquads(player2, sg_northBridge, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_c8, mkr_c8)
	Util_CreateSquads(player2, sg_northBridge, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_c7)
	Util_CreateSquads(player2, sg_northBridge, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_hmg2, mkr_hmg2)
	
	if(g_difficulty >= GD_NORMAL) then
		Util_CreateSquads(player2, sg_northBridge, SBP.GERMAN.GRENADIER_SQUAD, mkr_c2, mkr_c2, nil, nil, nil, nil, UPG.GERMAN.GRENADIER_MG42_LMG)		
	end
	
	
	local encData = {
		name = "pointC",
		spawn = mkr_c1,
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				difficulty = GD_EASY,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
			}
		}
	}
	g_enc_pointC = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_pointC,
		range = mkr_pointC,
		leashRange = 20,
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {mkr_flammer, mkr_c4},
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				waitTimeSecs = 8,
			},
		},
		fallbackParams = {
			markers = {mkr_tankDest2},
			thresholds = {0.33},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			retreat = true,
		},
		onFailure = Despawn,
		maxIdleTime = -1,
	}
	g_enc_pointC:SetGoal(goalData)
end

function AlliesBridgeNorth()
	local encData = {
		name = "alliesBridgeNorth",
		player = player3,
		spawn = mkr_reinforcements,
		units = {
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				onDeath = ReplaceUnit,
			},
			{
				sbp = SBP.SOVIET.COMBAT_ENGINEER_SQUAD,
				onDeath = ReplaceUnit,
			},
		},
	}
	enc_alliesBridgeNorth = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = mkr_c7,
		leashRange = 15,
		attackMove = true,
		safeMoveWeight = 0.0,
		coordinatedSetup = false,
		tacticControlsList = {
			{
				tacticType = TACTIC_Ability,
				priority = -1,
			},
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
			{
				tacticType = TACTIC_ForceAttack,
				priority = -1,
			},
		},
		fallbackParams = {
			thresholds = {0.3},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_reinforcements},
			retreatOnSuppression = true,
			retreat = true,
		},
		maxIdleTime = 15,
		onFailure = Despawn,
		onSuccess = SecurePointC,
	}
	enc_alliesBridgeNorth:SetGoal(goalData)
end

function SecurePointC(enc)
	enc:RemoveOnDeath(true)
	
	local goalData = {
		name = "Defend",
		target = eg_pointC,
		range = 10,
		leashRange = 15,
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {mkr_flammer, mkr_c4},
		maxIdleTime = 30,
	}
	enc:SetGoal(goalData)
end






-------------------------------------------------------------------------
-- Util functions
-------------------------------------------------------------------------
function Despawn(enc)
	SGroup_DestroyAllSquads(enc.sgroup)
end

function ReplaceUnit(unit)
	local enc = unit.encounter
	if(enc:IsAlive()) then
		enc:AddUnit(unit.data)
		
		if(not enc:Goal_HasValidObjective()) then
--~ 			print(enc:RestartGoal()) --debug
			enc:RestartGoal()
		end
	end
end

function _IsEncounterActive(enc)
	return enc ~= nil and enc:IsAlive()
end

function _CheckRetreat(enc, state)
	if(state == AIObjectiveStage_Fallback) then
		SGroup_RemoveGroup(sg_currentAttackers, enc.sgroup)
	end
end

function _RunAway(data)
	Cmd_Retreat(data.group, data.dest, data.dest)
end

function _AnalizeStrength(player, location, radius, filterList)
	local t_analisis = {}
	local unitsArea = SGroup_CreateIfNotFound("unitsArea")
	SGroup_Clear(unitsArea)
	
	t_analisis.num = World_GetSquadsNearPoint(player, unitsArea, Util_GetPosition(location), radius, OT_Player)
	
	if(filterList ~= nil) then
		SGroup_Filter(unitsArea, filterList, FILTER_KEEP)
	end
	
	for i=1, SGroup_CountSpawned(unitsArea) do
		local squad = SGroup_GetSpawnedSquadAt(unitsArea, i)
		local blueprint = Squad_GetBlueprint(squad)
		
		if(t_analisis[BP_GetName(blueprint)] ~= nil) then
			t_analisis[BP_GetName(blueprint)].num = t_analisis[BP_GetName(blueprint)].num + 1
			t_analisis[BP_GetName(blueprint)].avgHealth = (t_analisis[BP_GetName(blueprint)].avgHealth + Squad_GetHealthPercentage(squad))/2
		else
			t_analisis[BP_GetName(blueprint)] = {}
			t_analisis[BP_GetName(blueprint)].num = 1
			t_analisis[BP_GetName(blueprint)].avgHealth = Squad_GetHealthPercentage(squad)
		end
	end
	
	return t_analisis
end

function _GetAnalisisNum(data, blueprint)
	if(data[BP_GetName(blueprint)] == nil) then
		return 0
	else
		return data[BP_GetName(blueprint)].num
	end
end

function _GetAnalisisHealth(data, blueprint)
	if(data[BP_GetName(blueprint)] == nil) then
		return 0
	else
		return data[BP_GetName(blueprint)].avgHealth
	end
end

function Util_CountPlayerUnitType(player, filterList, filterType, location, radius)
	local unitsArea = SGroup_CreateIfNotFound("unitsArea")
	SGroup_Clear(unitsArea) --recycle sgroup
	
	if(location ~= nil) then
		--Search a specific location
		if(scartype(location) == ST_MARKER and radius == nil) then radius = Marker_GetProximityRadius(location) end
		World_GetSquadsNearPoint(player, unitsArea, Util_GetPosition(location), radius, OT_Player)
	else
		--Search all of the player's units
		unitsArea = Player_GetSquads(player)
	end
	
	if(filterList ~= nil) then
		SGroup_Filter(unitsArea, filterList, filterType)
	end
	
	return SGroup_CountSpawned(unitsArea)
end
