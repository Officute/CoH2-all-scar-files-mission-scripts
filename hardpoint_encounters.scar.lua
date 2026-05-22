-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Hardpoint - Encounters data
-- Designer: Jim Dodge
-------------------------------------------------------------------------
-------------------------------------------------------------------------
ENCOUNTERS = {}

--~ -- Similar to the EVENTS file, each of these creates an encounter and returns a reference.
--~ -- Remember to add a simple description for each encounter.

ENCOUNTERS.ai_point_attack_1 = function()
	local encData = {
		name = "Early Reinforcements",
		target = defenseTar,
		spawn = {Util_GetRandomPosition(mkr_reverseHardpoint_point1),
					Util_GetRandomPosition(mkr_reverseHardpoint_point2),
					Util_GetRandomPosition(mkr_reverseHardpoint_point1),
					Util_GetRandomPosition(mkr_reverseHardpoint_point2),
					Util_GetRandomPosition(mkr_reverseHardpoint_point1),
		},

		intent = ENC_INTENT.basicInfantry,
		
		onDeath = nil,
		--attackMove = true,
		safeMoveWeight = 2,
		movePathLengthFactor = 1.2,
		retaliateAttacks = true,
		retaliateAttackRange = 600,
		
	}
	currentEncounterID = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	local target = Get_VP_Target()
 	GOALS.ai_cp_pushFrontLine_goal(currentEncounterID, target)
	ScoutReport(target)
	Rule_Add(ApplyInstantVeterancy, 1)
	return enc_newEncounter
end

ENCOUNTERS.ai_point_attack_2 = function()
	local encData = {
		name = "Scouts for Vanguard",
		target = defenseTar,
		spawn = {Util_GetRandomPosition(mkr_reverseHardpoint_point2),
					Util_GetRandomPosition(mkr_reverseHardpoint_point1),
					Util_GetRandomPosition(mkr_reverseHardpoint_point2),
					Util_GetRandomPosition(mkr_reverseHardpoint_point1),
					Util_GetRandomPosition(mkr_reverseHardpoint_point2),
		},

		intent = ENC_INTENT.basicInfantry,
		
		onDeath = nil,
		--attackMove = true,
		safeMoveWeight = 2,
		movePathLengthFactor = 1,
		retaliateAttacks = true,
		retaliateAttackRange = 600,
	}
	currentEncounterID = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	local target = Get_VP_Target()
 	GOALS.ai_cp_reclaim_goal(currentEncounterID, target)
	ScoutReport(target)
	Rule_AddOneShot(ApplyInstantVeterancy, 1)
	return enc_newEncounter
end

ENCOUNTERS.ai_point_attack_3 = function()
	local encData = {
		name = "Vanguard",
		target = defenseTar,
		spawn = {Util_GetRandomPosition(mkr_reverseHardpoint_point2),
					Util_GetRandomPosition(mkr_reverseHardpoint_point1),
					Util_GetRandomPosition(mkr_reverseHardpoint_point2),
					Util_GetRandomPosition(mkr_reverseHardpoint_point1),
					Util_GetRandomPosition(mkr_reverseHardpoint_point2),
		},
		intent = ENC_INTENT.scoutForce,
		
		onDeath = nil,
		--attackMove = true,
		safeMoveWeight = 2,
		movePathLengthFactor = 1,
		retaliateAttacks = true,
		retaliateAttackRange = 600,
	}
	currentEncounterID = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	local target = Get_VP_Target()
 	GOALS.ai_cp_defense_goal(currentEncounterID, target)
	ScoutReport(target)
	Rule_AddOneShot(ApplyInstantVeterancy, 1)
	return enc_newEncounter
end

ENCOUNTERS.ai_point_attack_4 = function()
	local encData = {
		name = "Artillery Reinforcements",
		target = defenseTar,
		spawn = {Util_GetRandomPosition(mkr_reverseHardpoint_point1),
					Util_GetRandomPosition(mkr_reverseHardpoint_point2),
					Util_GetRandomPosition(mkr_reverseHardpoint_point1),
					Util_GetRandomPosition(mkr_reverseHardpoint_point2),
					Util_GetRandomPosition(mkr_reverseHardpoint_point1),
		},
		intent = ENC_INTENT.basicInfantry,
		
		onDeath = nil,
		--attackMove = true,
		safeMoveWeight = 2,
		movePathLengthFactor = 1.25,
		retaliateAttacks = true,
		retaliateAttackRange = 60,
	}
	currentEncounterID = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
		
	local target = Get_VP_Target()
 	GOALS.ai_cp_reclaim_goal(currentEncounterID, SendSquadsToNearbyMarkerBySuffix(target, "rearDefense")) --artillery squad sets up near the back of the VP
	ScoutReport(target)
	Rule_AddOneShot(ApplyInstantVeterancy, 1)
	--SGroup_IncreaseVeterancyRank(encID_ai_point_attack_4:GetSgroup(), 1)
	return enc_newEncounter
end
ENCOUNTERS.ai_point_attack_5 = function()
	local encData = {
		name = "Anti-Infantry Reinforcements",
		target = defenseTar,
		spawn = {Util_GetRandomPosition(mkr_reverseHardpoint_point2),
					Util_GetRandomPosition(mkr_reverseHardpoint_point1),
					Util_GetRandomPosition(mkr_reverseHardpoint_point2),
					Util_GetRandomPosition(mkr_reverseHardpoint_point1),
					Util_GetRandomPosition(mkr_reverseHardpoint_point2),
		},
		intent = ENC_INTENT.scoutForce,
		
		onDeath = nil,
		--attackMove = true,
		safeMoveWeight = 2,
		movePathLengthFactor = 1.25,
		retaliateAttacks = true,
		retaliateAttackRange = 600,
	}
	currentEncounterID = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
		
	local target = Get_VP_Target()
 	GOALS.ai_cp_pushFrontLine_goal(currentEncounterID, target)
	ScoutReport(target)
	Rule_AddOneShot(ApplyInstantVeterancy, 1)
	--SGroup_IncreaseVeterancyRank(encID_ai_point_attack_5:GetSgroup(), 1)
	return enc_newEncounter
end
ENCOUNTERS.ai_point_attack_6 = function()
	local encData = {
		name = "Experienced Reinforcements",
		target = defenseTar,
		spawn = {Util_GetRandomPosition(mkr_reverseHardpoint_point1),
					Util_GetRandomPosition(mkr_reverseHardpoint_point2),
					Util_GetRandomPosition(mkr_reverseHardpoint_point1),
					Util_GetRandomPosition(mkr_reverseHardpoint_point2),
					Util_GetRandomPosition(mkr_reverseHardpoint_point1),
		},
		intent = ENC_INTENT.smallAntiInfantryDefense,
		
		onDeath = nil,
		--attackMove = true,
		safeMoveWeight = 2,
		movePathLengthFactor = 1,
		retaliateAttacks = true,
		retaliateAttackRange = 100,
	}
	currentEncounterID = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
		
	local target = Get_VP_Target()
 	GOALS.ai_cp_reclaim_goal(currentEncounterID, target)
	ScoutReport(target)
	Rule_AddOneShot(ApplyInstantVeterancy, 1)
	--SGroup_IncreaseVeterancyRank(encID_ai_point_attack_6:GetSgroup(), 2)
	return enc_newEncounter
end
ENCOUNTERS.ai_point_attack_7 = function()
	local encData = {
		name = "Artillery Experts",
		target = defenseTar,
		spawn = {Util_GetRandomPosition(mkr_reverseHardpoint_point2),
					Util_GetRandomPosition(mkr_reverseHardpoint_point1),
					Util_GetRandomPosition(mkr_reverseHardpoint_point2),
					Util_GetRandomPosition(mkr_reverseHardpoint_point1),
					Util_GetRandomPosition(mkr_reverseHardpoint_point2),
		},
		intent = ENC_INTENT.basicHMG,
		
		onDeath = nil,
		--attackMove = true,
		safeMoveWeight = 2,
		movePathLengthFactor = 1.25,
		retaliateAttacks = true,
		retaliateAttackRange = 60,
	}
	currentEncounterID = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
		
	local target = Get_VP_Target()
 	GOALS.ai_cp_reclaim_goal(currentEncounterID, SendSquadsToNearbyMarkerBySuffix(target, "overwatch")) --artillery squad hangs back to support or open up VP
	ScoutReport(target)
	Rule_AddOneShot(ApplyInstantVeterancy, 1)
	--SGroup_IncreaseVeterancyRank(encID_ai_point_attack_7:GetSgroup(), 3).... these cannot be done here must call rule to delay function call until after unit spawn and then remove the rule immediately
	return enc_newEncounter
end
ENCOUNTERS.ai_point_attack_8 = function()
	local encData = {
		name = "Anti-Tank Reinforcements",
		target = defenseTar,
		spawn = {Util_GetRandomPosition(mkr_reverseHardpoint_point2),
					Util_GetRandomPosition(mkr_reverseHardpoint_point1),
					Util_GetRandomPosition(mkr_reverseHardpoint_point2),
					Util_GetRandomPosition(mkr_reverseHardpoint_point1),
					Util_GetRandomPosition(mkr_reverseHardpoint_point2),
		},
		intent = ENC_INTENT.smallAntiTankDefense,
		
		onDeath = nil,
		--attackMove = true,
		safeMoveWeight = 2,
		movePathLengthFactor = 1.25,
		retaliateAttacks = true,
		retaliateAttackRange = 60,
	}
	currentEncounterID = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
		
	local target = Get_VP_Target()
 	GOALS.ai_cp_defense_goal(currentEncounterID, target)
	ScoutReport(target)
	Rule_AddOneShot(ApplyInstantVeterancy, 1)
	--SGroup_IncreaseVeterancyRank(encID_ai_point_attack_8:GetSgroup(), 2)
	return enc_newEncounter
end
ENCOUNTERS.ai_point_attack_9 = function()
	local encData = {
		name = "Armoured Reinforcements",
		target = defenseTar,
		spawn = {Util_GetRandomPosition(mkr_reverseHardpoint_point2),
					Util_GetRandomPosition(mkr_reverseHardpoint_point1),
					Util_GetRandomPosition(mkr_reverseHardpoint_point2),
					Util_GetRandomPosition(mkr_reverseHardpoint_point1),
					Util_GetRandomPosition(mkr_reverseHardpoint_point2),
		},
		intent = ENC_INTENT.mediumArmour,
		
		onDeath = nil,
		--attackMove = true,
		safeMoveWeight = 0,
		movePathLengthFactor = 1.25,
		retaliateAttacks = true,
		retaliateAttackRange = 600,
	}
	currentEncounterID = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	local target = Get_VP_Target()
 	GOALS.ai_cp_pushFrontLine_goal(currentEncounterID, target)
	ScoutReport(target)
	Rule_AddOneShot(ApplyInstantVeterancy, 1)
	--SGroup_IncreaseVeterancyRank(encID_ai_point_attack_9:GetSgroup(), 1)
	return enc_newEncounter
end
ENCOUNTERS.ai_point_attack_10 = function()
	local encData = {
		name = "Diverted Assault Battalion 1",
		target = defenseTar,
		spawn = {Util_GetRandomPosition(mkr_reverseHardpoint_point2),
					Util_GetRandomPosition(mkr_reverseHardpoint_point1),
					Util_GetRandomPosition(mkr_reverseHardpoint_point2),
					Util_GetRandomPosition(mkr_reverseHardpoint_point1),
					Util_GetRandomPosition(mkr_reverseHardpoint_point2),
		},
		intent = ENC_INTENT.battleBaseDefenses,
		
		onDeath = nil,
		--attackMove = true,
		safeMoveWeight = 0,
		movePathLengthFactor = 1.25,
		retaliateAttacks = true,
		retaliateAttackRange = 600,
	}
	currentEncounterID = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
		
	local target = Get_VP_Target()
 	GOALS.ai_cp_defense_goal(currentEncounterID, target)
	ScoutReport(target)
	Rule_AddOneShot(ApplyInstantVeterancy, 1)
	--SGroup_IncreaseVeterancyRank(encID_ai_point_attack_10:GetSgroup(), 2)
	return enc_newEncounter
end
ENCOUNTERS.ai_point_attack_11 = function()
	local encData = {
		name = "Diverted Assault Battalion 2",
		target = defenseTar,
		spawn = {Util_GetRandomPosition(mkr_reverseHardpoint_point1),
					Util_GetRandomPosition(mkr_reverseHardpoint_point2),
					Util_GetRandomPosition(mkr_reverseHardpoint_point1),
					Util_GetRandomPosition(mkr_reverseHardpoint_point2),
					Util_GetRandomPosition(mkr_reverseHardpoint_point1),
		},
		intent = ENC_INTENT.battleBaseDefenses,
		
		onDeath = nil,
		--attackMove = true,
		safeMoveWeight = 0,
		movePathLengthFactor = 1.25,
		retaliateAttacks = true,
		retaliateAttackRange = 600,
	}
	currentEncounterID = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
		
	local target = Get_VP_Target()
 	GOALS.ai_cp_defense_goal(currentEncounterID, target)
	ScoutReport(target)
	Rule_AddOneShot(ApplyInstantVeterancy, 1)
	--SGroup_IncreaseVeterancyRank(encID_ai_point_attack_11:GetSgroup(), 3)
	return enc_newEncounter
end


GOALS = {}

-- A goal that will be assigned to multiple encounters throughout the course of a single mission
GOALS.ai_cp_defense_goal = function(encounter, defenseTar)
	
	local goalData = {
		name = "Defend",
		target = defenseTar,
		range = 30,
		leashRange = 20,		
		coordinatedMoveRadius = 5,
		--retaliateAttacks = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 200,
				maxRange = 20,
			},
		},
		onFailure = HealAndHandover,
		fallbackParams = {
			thresholds = {0.3},
			thresholdType = Threshold_PercentageHealth,
 			markers = {mkr_reverseHardpoint_point2},
			retreat = true,
			retreatOnSuppression = true,
 			retreatDelay = 3,
		},
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(defenseTar, OFFSET_FRONT_LEFT, 40),
			Util_GetOffsetPosition(defenseTar, OFFSET_FRONT, 40),
			Util_GetOffsetPosition(defenseTar, OFFSET_FRONT_RIGHT, 40),
			Util_GetOffsetPosition(defenseTar, OFFSET_BACK_LEFT, 40),
			Util_GetOffsetPosition(defenseTar, OFFSET_BACK_RIGHT, 40),
		},
	}
	
	encounter:SetGoal(goalData)
end

-- A goal that will be assigned to multiple encounters throughout the course of a single mission
GOALS.ai_cp_reclaim_goal = function(encounter, reclaimTar)
	
	local goalData = {
		name = "Attack",
		target = reclaimTar,
		range = 2,
		leashRange = 20,		
		--coordinatedMoveRadius = 15,
		--tacticCloseGround = 900;
		pickupWeapons = true;
		attackEngagementMove = false;
		tacticControlsList = {
			{
				tacticType = TACTIC_RushAtTarget,
				priority = 1000,
				maxRange = 20,
			},
		},
		onFailure = HealAndHandover,
		fallbackParams = {
			thresholds = {0.1},
			thresholdType = Threshold_PercentageHealth,
 			markers = {mkr_reverseHardpoint_point1},
			retreat = true,
			retreatOnSuppression = false,
 			retreatDelay = 0,
		},
--~ 		coordinatedSetupFacingPositions = {
--~ 			Util_GetOffsetPosition(defenseTar, OFFSET_FRONT_LEFT, 10),
--~ 			Util_GetOffsetPosition(defenseTar, OFFSET_FRONT, 1),
--~ 			Util_GetOffsetPosition(defenseTar, OFFSET_FRONT_RIGHT, 20),
--~ 			Util_GetOffsetPosition(defenseTar, OFFSET_BACK_LEFT, 40),
--~ 			Util_GetOffsetPosition(defenseTar, OFFSET_BACK_RIGHT, 15),
--~ 		},
	}
	
	encounter:SetGoal(goalData)
end

-- A goal that will be assigned to multiple encounters throughout the course of a single mission
GOALS.ai_cp_pushFrontLine_goal = function(encounter, advanceTar)
	
	local goalData = {
		name = "Attack",
		target = SendSquadsToNearbyMarkerBySuffix(advanceTar, "frontDefense"),
		range = 15,
		leashRange = 25,		
		coordinatedMoveRadius = 20,
		--retaliateAttacks = true,
		garrison = true;
		maxIdleTime = -1;
		attackEngagementMove = true;
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 800,
				maxRange = 80,
			},
		},
		onFailure = HealAndHandover,
		fallbackParams = {
			thresholds = {0.3},
			thresholdType = Threshold_PercentageHealth,
 			markers = {mkr_reverseHardpoint_point2},
			retreat = false,
			retreatOnSuppression = true,
 			retreatDelay = 5,
		},
--~ 		coordinatedSetupFacingPositions = {
--~ 			Util_GetOffsetPosition(defenseTar, OFFSET_FRONT_LEFT, 80),
--~ 			Util_GetOffsetPosition(defenseTar, OFFSET_FRONT, 80),
--~ 			Util_GetOffsetPosition(defenseTar, OFFSET_FRONT_RIGHT, 80),
--~ 			Util_GetOffsetPosition(defenseTar, OFFSET_FRONT_LEFT, 60),
--~ 			Util_GetOffsetPosition(defenseTar, OFFSET_FRONT_RIGHT, 60),
--~ 		},
	}
	
	encounter:SetGoal(goalData)
end

-- A goal that will be assigned to multiple encounters throughout the course of a single mission
--~ GOALS.ai_cp_infiltrate_goal = function(encounter, defenseTar)
--~ 	
--~ 	local goalData = {
--~ 		name = "Ability",
--~ 		target = defenseTar,
--~ 		range = 50,
--~ 		leashRange = 30,		
--~ 		coordinatedMoveRadius = 10,
--~ 		--retaliateAttacks = true,
--~ 		tacticControlsList = {
--~ 			{
--~ 				tacticType = TACTIC_Cover,
--~ 				priority = 200,
--~ 				maxRange = 20,
--~ 			},
--~ 		},
--~ 		onFailure = HealAndHandover,
--~ 		fallbackParams = {
--~ 			thresholds = {0.3},
--~ 			thresholdType = Threshold_PercentageHealth,
--~  			markers = {mkr_reverseHardpoint_point1},
--~ 			retreat = true,
--~ 			retreatOnSuppression = true,
--~  			retreatDelay = 3,
--~ 		},
--~ 		coordinatedSetupFacingPositions = {
--~ 			Util_GetOffsetPosition(defenseTar, OFFSET_FRONT_LEFT, 60),
--~ 			Util_GetOffsetPosition(defenseTar, OFFSET_FRONT, 60),
--~ 			Util_GetOffsetPosition(defenseTar, OFFSET_FRONT_RIGHT, 60),
--~ 			Util_GetOffsetPosition(defenseTar, OFFSET_BACK_LEFT, 60),
--~ 			Util_GetOffsetPosition(defenseTar, OFFSET_BACK_RIGHT, 60),
--~ 		},
--~ 	}
--~ 	
--~ 	encounter:SetGoal(goalData)
--~ end


function HealAndHandover(encounter)
	print("heal and handover")
	encounter:ClearGoal()
	local player_squads = nil
	Cmd_InstantReinforceUnitPos(encounter:GetSgroup(), 12, mkr_reverseHardpoint_point1, CHECK_BOTH, DO_NOTHING) --$$$this line may or may not happen as designed, check it
	SGroup_IncreaseVeterancyRank(encounter:GetSgroup())
	AI_UnlockSquads( player2, encounter:GetSgroup() ) 
end

function SendSquadsToNearbyMarkerBySuffix(target, suffix)
	if Marker_Exists(Marker_GetName(target), "") then
		if suffix == "overwatch" then
			for i = 1 , #t_encounterDestinations do
				if Marker_GetName(target) == Marker_GetName(t_encounterDestinations[i].vp)  then
					return t_encounterDestinations[i].overwatch
				else
					--print("passing through overwatch at " .. i)
				end
			end
		elseif suffix == "rearDefense" then
			for i = 1 , #t_encounterDestinations do
				if Marker_GetName(target) == Marker_GetName(t_encounterDestinations[i].vp)  then
					return t_encounterDestinations[i].rearDefense
				else
					--print("passing through rearDefense at " .. i)
				end
			end
		elseif suffix == "frontDefense" then
			for i = 1 , #t_encounterDestinations do
				if Marker_GetName(target) == Marker_GetName(t_encounterDestinations[i].vp)  then
					return t_encounterDestinations[i].frontDefense
				else
					--print("passing through frontDefense at " .. i)
				end
			end
		else
			print("invalid suffix passed, encounter will default to original marker")
			return target
		end
	else
		print("invalid target passed, encounter will not occur")
	end
end

function ApplyInstantVeterancy()
	--take current encounter and assign veterancy based on a value in a table
	SGroup_IncreaseVeterancyRank(currentEncounterID:GetSgroup(), t_instantVeterancy[i_encounter])
	--print(i_encounter)
	--increment i_encounter
	i_encounter = i_encounter + 1
	
	--remove this rule so it can be used again for the next encounter
	Rule_RemoveMe()
end
