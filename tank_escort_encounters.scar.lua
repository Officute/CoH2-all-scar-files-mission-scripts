print("\tLoading encdata file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Tank Escort - Encounters data
-- Designer: B.Chow
-------------------------------------------------------------------------
-------------------------------------------------------------------------
ENCOUNTERS = {}

-- Path 1 Encounters
-- First Encounter
ENCOUNTERS.encounter1a = function()
	-- The initial left-side defense of the Castle
	local encData = {
		name = "Encounter1a",
		player = player2,
		sgroups = {sg_encounter1, sg_enemies},
		units = {
			{
				name = "Encounter1a_01",
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				spawn = mkr_path1_enc1_01,
				slotItems = SLOT_ITEM.PANZERSHRECK_MP,
			},
			{
				name = "Encounter1a_02",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = mkr_path1_enc1_02,
			},
		},
		goalData = {
			name = "Defend",
			target = mkr_path1_enc1_01,
			range = 25,
			leashRange = 25,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			}
		},
	}
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_newEncounter
end



-- Second Encounter
ENCOUNTERS.encounter2a = function()
	-- The initial left-side defense of the Castle
	local encData = {
		name = "Encounter2a",
		player = player2,
		sgroups = {sg_encounter2, sg_enemies},
		units = {
			{
				name = "Encounter2a_01",
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				spawn = mkr_path1_enc2_01,
				slotItems = SLOT_ITEM.PANZERSHRECK_MP,
			},
			{
				name = "Encounter2a_02",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = mkr_path1_enc2_02,
			},
		},
		goalData = {
			name = "Defend",
			target = mkr_path1_enc2_01,
			range = 25,
			leashRange = 25,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			}
		},
	}
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_newEncounter
end

-- Third Encounter
ENCOUNTERS.encounter3a = function()
	-- The initial left-side defense of the Castle
	local encData = {
		name = "Encounter3a",
		player = player2,
		sgroups = {sg_encounter2, sg_enemies},
		triggerGoalOnEngage = true,
		units = {
			{
				name = "Encounter3a_01",
				sbp = SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP,
				spawn = mkr_path1_enc3_01,
			},
			{
				name = "Encounter3a_02",
				sbp = SBP.WEST_GERMAN.PAK40_75MM_AT_GUN_SQUAD_WG_MP,
				spawn = mkr_path1_enc3_02,
			},
		},
		goal = {
			name = "Defend",
			target = mkr_path1_enc3_02,
			range = 30,
			leashRange = 20,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_path1_enc3_facing},
		},
	}
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
--~ 	enc_newEncounter:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_newEncounter
end


-- Path 2 Encounters ----------------------------------------------------

-- First Encounter
ENCOUNTERS.encounter1b = function()
	-- The initial left-side defense of the Castle
	local encData = {
		name = "Encounter1b",
		player = player2,
		sgroups = {sg_encounter1, sg_enemies},
		units = {
			{
				name = "Encounter1b_01",
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				spawn = mkr_path2_enc1_01,
				slotItems = SLOT_ITEM.PANZERSHRECK_MP,
			},
			{
				name = "Encounter1b_02",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = mkr_path2_enc1_02,
			},
		},
		goalData = {
			name = "Defend",
			target = mkr_path2_enc1_01,
			range = 30,
			leashRange = 20,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			}
		},
	}
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_newEncounter
end

-- Second Encounter
ENCOUNTERS.encounter2b = function()
	-- The initial left-side defense of the Castle
	local encData = {
		name = "Encounter2b",
		player = player2,
		sgroups = {sg_encounter2, sg_enemies},
		units = {
			{
				name = "Encounter2a_01",
				sbp = SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP,
				spawn = mkr_path2_enc2_01,
			},
			{
				name = "Encounter2a_02",
				sbp = SBP.WEST_GERMAN.PAK40_75MM_AT_GUN_SQUAD_WG_MP,
				spawn = mkr_path2_enc2_02,
			},
		},
		goal = {
			name = "Defend",
			target = mkr_path2_enc2_01,
			range = 30,
			leashRange = 20,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_path1_enc2_facing},
		},
	}
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
--~ 	enc_newEncounter:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_newEncounter
end

-- Third Encounter
ENCOUNTERS.encounter3b = function()
	-- The initial left-side defense of the Castle
	local encData = {
		name = "Encounter3b",
		player = player2,
		sgroups = {sg_encounter3, sg_enemies},
		units = {
			{
				name = "Encounter3b_01",
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				spawn = mkr_path2_enc3_01,
				slotItems = SLOT_ITEM.PANZERSHRECK_MP,
			},
			{
				name = "Encounter3b_02",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = mkr_path2_enc3_02,
			},
		},
		goalData = {
			name = "Defend",
			target = mkr_path2_enc3_01,
			range = 25,
			leashRange = 25,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			}
		},
	}
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_newEncounter
end




-- ************************************************************


GOALS = {}

-- A goal that will be assigned to multiple encounters throughout the course of a single mission
