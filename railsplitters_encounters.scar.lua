-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Railsplitters - Encounters data
-- Designer: Jim Dodge
-------------------------------------------------------------------------
-------------------------------------------------------------------------
ENCOUNTERS = {}

--~ -- Similar to the EVENTS file, each of these creates an encounter and returns a reference.
--~ -- Remember to add a simple description for each encounter.

ENCOUNTERS.ai_scout_01 = function() --these units spawn at the final location of the medic truck and move to capture a point so that medic truck can set up, and then return to defend the area in front of the medic truck
	local encData = {
		name = "Scouting Party",

		spawn = {
			mkr_railsplitters_medic_01,
			mkr_railsplitters_medic_01,
			mkr_railsplitters_medic_01,
			mkr_railsplitters_medic_01,
		},
		intent = ENC_INTENT.basicInfantry,
		goal = {
			name = "Defend",
			target = mkr_railsplitters_encounter_01,
			range = 15,
			leashRange = 40,		
			pickupWeapons = true,
			attackEngagementMove = false,
			tacticControlsList = {
				{
					tacticType = TACTIC_Cover,
					priority = 300,
					maxRange = 30,
				},
		},
		},
	}
	
	local currentEncounterID = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return

	return enc_newEncounter
end

ENCOUNTERS.ai_retribution_01 = function() --retribution encounters are called when German bases are destroyed
	local encData = {
		name = "Retribution the First",

		spawn = {
			mkr_reverseHardpoint_point2,
			mkr_reverseHardpoint_point2,
			mkr_reverseHardpoint_point2,
			mkr_reverseHardpoint_point2,
		},
		intent = ENC_INTENT.scoutForce,
		goal = {
			name = "Attack",
			target = mkr_railsplitters_encounter_04,
			attackMove = true,
			range = 40,
			leashRange = 30,
			onSuccess = BaseRush,
		},
	}
	local currentEncounterID = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return

	return enc_newEncounter
end

--~ ENCOUNTERS.ai_retribution_02 = function() --retribution encounters are called when German bases are destroyed
--~ 	local encData = {
--~ 		name = "Retribution the Second",

--~ 		spawn = {
--~ 			mkr_reverseHardpoint_point2,
--~ 			mkr_reverseHardpoint_point2,
--~ 			mkr_reverseHardpoint_point2,
--~ 			mkr_reverseHardpoint_point2,
--~ 		},
--~ 		intent = ENC_INTENT.medAntiTankDefense,
--~ 		goal = {
--~ 			name = "Attack",
--~ 			target = mkr_railsplitters_encounter_04,
--~ 			attackMove = true,
--~ 			range = 90,
--~ 			leashRange = 30,
--~ 			--onSuccess = BaseRush,
--~ 		},
--~ 	}
--~ 	local currentEncounterID = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return

--~ 	return enc_newEncounter
--~ end

ENCOUNTERS.ai_retribution_03 = function() --retribution encounters are called when German bases are destroyed
	local encData = {
		name = "Retribution the Third",

		spawn = {
			mkr_reverseHardpoint_point1,
			mkr_reverseHardpoint_point1,
			mkr_reverseHardpoint_point1,
			mkr_reverseHardpoint_point1,
		},
		intent = ENC_INTENT.medArtillery,
		goal = {
			name = "Attack",
			target = mkr_railsplitters_encounter_03,
			attackMove = true,
			range = 90,
			leashRange = 60,
			onSuccess = BaseRush,
			pickupWeapons = true,
		},
	}
	local currentEncounterID = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return

	return enc_newEncounter
end

ENCOUNTERS.ai_retribution_04 = function() --retribution encounters are called when German bases are destroyed
	local encData = {
		name = "Retribution the Fourth",
		spawn = {
			mkr_reverseHardpoint_point1,
			mkr_reverseHardpoint_point1,
			mkr_reverseHardpoint_point1,
			mkr_reverseHardpoint_point1,
		},
		intent = ENC_INTENT.mediumArmour,
		goal = {
			name = "Attack",
			target = mkr_railsplitters_encounter_03,
			attackMove = true,
			range = 90,
			leashRange = 40,
			onSuccess = BaseRush,
			tacticControlsList = {
			{
				tacticType = TACTIC_Vehicle,
				priority = 300,
			},
		},
		},
	}
	local currentEncounterID = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return

	return enc_newEncounter
end

ENCOUNTERS.ai_retribution_05 = function() --retribution encounters are called when German bases are destroyed
	local encData = {
		name = "Retribution the Fifth",
		spawn = {
			mkr_reverseHardpoint_point2,
			mkr_reverseHardpoint_point2,
			mkr_reverseHardpoint_point2,
			mkr_reverseHardpoint_point2,
		},
		units = {
			{
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.PANTHER_COMMANDER_SQUAD_MP, SBP.WEST_GERMAN.PANTHER_COMMANDER_SQUAD_MP, SBP.WEST_GERMAN.JAGDTIGER_TD_SQUAD_MP, SBP.WEST_GERMAN.JAGDTIGER_TD_SQUAD_MP, SBP.WEST_GERMAN.JAGDTIGER_TD_SQUAD_MP }),
			},	
		},
		goal = {
			name = "Attack",
			target = mkr_railsplitters_encounter_03,
			attackMove = true,
			range = 90,
			leashRange = 60,
			onSuccess = BaseRush,
			tacticControlsList = {
				{
					tacticType = TACTIC_Vehicle,
					priority = 300,
				},
			},
		}
	}
	local currentEncounterID = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return

	return enc_newEncounter
end

--~ ENCOUNTERS.ai_retribution_01 = function() --retribution encounters are called when German bases are destroyed
--~ 	local encData = {
--~ 		name = "Retribution the First",

--~ 		spawn = {
--~ 			mkr_reverseHardpoint_point2,
--~ 			mkr_reverseHardpoint_point2,
--~ 		},
--~ 		intent = ENC_INTENT.scoutForce,
--~ 		goal = {
--~ 			name = "Attack",
--~ 			target = mkr_railsplitters_encounter_03,
--~ 			attackMove = true,
--~ 			range = 90,
--~ 			leashRange = 30,
--~ 			onSuccess = BaseRush,
--~ 		},
--~ 	}
--~ 	local currentEncounterID = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return

--~ 	return enc_newEncounter
--~ end

GOALS = {}
--~ -- A goal that will be assigned to multiple encounters throughout the course of a single mission
GOALS.ai_pushFrontLine_goal = function(encounter, advanceTar)
	local goalData = {	
		name = "Attack",
		target = advanceTar,
		range = 15,
		leashRange = 25,		
		coordinatedMoveRadius = 40,
		retaliateAttacks = true,
		maxIdleTime = -1, --encounter never succeeds therefore does not finish
		attackEngagementMove = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_RushAtTarget,
				priority = 300,
			},
		},
		fallbackParams = {
			thresholds = {0.3},
			thresholdType = Threshold_PercentageHealth,
 			markers = {mkr_railsplitters_encounter_01},
			retreat = false,
			retreatOnSuppression = false,
		},
	}
	encounter:SetGoal(goalData)
end

function CaptureNearestTerritory(position)
	return World_GetTerritorySectorPosition( World_GetTerritorySectorID(position))
end

function ProtectSWS(encounter)
	encounter:ClearGoal()
	GOALS.ai_pushFrontLine_goal(encounter, mkr_railsplitters_medic_01)
end

function BaseRush(encounter)
	encounter:ClearGoal()
	GOALS.ai_pushFrontLine_goal(encounter, mkr_railsplitters_encounter_04)
end


function GetRetribution()
	local rand = World_GetRand(1, table.getn(t_sbp_retributionCallIns))
	return t_sbp_retributionCallIns[rand]
end