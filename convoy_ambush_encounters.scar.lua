print("\tLoading encdata file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Convoy Ambush - Encounters data
-- Designer: R.McGechaen
-------------------------------------------------------------------------
-------------------------------------------------------------------------
ENCOUNTERS = {}

-- ************************************************************
-- Attack Encounter
ENCOUNTERS.convoyAmbush_Attack = function()
	-- The initial left-side defense of the Castle
	local encData = {
		name = "Convoy_Attack",
		player = player5,
		spawn = mkr_convoyAmbush_attack_spawn01,
		sgroups = {sg_convoy_all},
		units = {
			{
				name = "Convoy_Attack_01",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				spawn = mkr_convoyAmbush_attack_spawn01,
			},
			{
				name = "Convoy_Attack_02",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = mkr_convoyAmbush_attack_spawn01,
			},
		},
		goalData = {
			name = "Attack",
			target = sg_truck,
			range = 30,
			leashRange = 30,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			}
		},
	}
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(encData.goalData)
	
	
	return enc_newEncounter
end

-- Static Encounters
ENCOUNTERS.convoyAmbush_01 = function()
	local encData = {
		name = "Convoy_01",
		player = player5,
		spawn = mkr_convoyAmbush_01,
		sgroups = {sg_convoy_all},
		units = {
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				spawn = Util_GetRandomPosition(mkr_convoyAmbush_01),
				difficulty = GD_HARD,
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = Util_GetRandomPosition(mkr_convoyAmbush_01),
				difficulty = {GD_EASY, GD_HARD},
			},
			{
				name = "Convoy_01_02",
				sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
				spawn = mkr_convoyAmbush_01_hmg,
			},
		},
		goal = {
			name = "Defend",
			target = mkr_convoyAmbush_01,
			range = 35,
			leashRange = mkr_convoyAmbush_01,
		},
	}
	return Encounter:Create(encData)
end

ENCOUNTERS.convoyAmbush_02 = function()
	local encData = {
		name = "Convoy_02",
		player = player5,
		spawn = mkr_convoyAmbush_02,
		sgroups = {sg_convoy_all},
		units = {
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				spawn = Util_GetRandomPosition(mkr_convoyAmbush_02),
				difficulty = GD_HARD,
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = Util_GetRandomPosition(mkr_convoyAmbush_02),
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = Util_GetRandomPosition(mkr_convoyAmbush_02),
			},
			{
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				spawn = Util_GetRandomPosition(mkr_convoyAmbush_02),
			},
		},
		goalData = {
			name = "Defend",
			target = mkr_convoyAmbush_02,
			range = 30,
			leashRange = Marker_GetProximityRadius(mkr_convoyAmbush_02),
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			}
		},
	}
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(encData.goalData)
	
	--If engaged, focus on targetting the truck.
	local event_engaged = Event_IsEngaged(_ChangeToAttack, {encTable = enc_newEncounter}, enc_newEncounter:GetSgroup(), ANY, 3)
	
	return enc_newEncounter
end

ENCOUNTERS.convoyAmbush_03 = function()
	local encData = {
		name = "Convoy_03",
		player = player5,
		spawn = mkr_convoyAmbush_03,
		sgroups = {sg_convoy_all},
		units = {
			SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
			{
				sbp = SBP.WEST_GERMAN.RAKETENWERFER43_88MM_PUPPCHEN_ANTITANK_GUN_SQUAD_MP,
				difficulty = GD_EASY,
			},
			{
				sbp = SBP.WEST_GERMAN.PAK40_75MM_AT_GUN_SQUAD_WG_MP,
				difficulty = {GD_NORMAL, GD_HARD},
			},
		},
		goalData = {
			name = "Defend",
			target = mkr_convoyAmbush_03,
			range = 45,
			leashRange = Marker_GetProximityRadius(mkr_convoyAmbush_03),
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			}
		},
	}
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(encData.goalData)
	
	return enc_newEncounter
end

ENCOUNTERS.convoyAmbush_04 = function()
	local encData = {
		name = "Convoy_04",
		player = player5,
		spawn = mkr_convoyAmbush_04,
		sgroups = {sg_convoy_all},
		units = {
			{
				name = "Convoy_04_01",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = Util_GetRandomPosition(mkr_convoyAmbush_04),
			},
			{
				name = "Convoy_04_02",
				sbp = SBP.WEST_GERMAN.RAKETENWERFER43_88MM_PUPPCHEN_ANTITANK_GUN_SQUAD_MP,
			},
		},
		goalData = {
			name = "Defend",
			target = mkr_convoyAmbush_04,
			range = 45,
			leashRange = Marker_GetProximityRadius(mkr_convoyAmbush_04),
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			}
		},
	}
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(encData.goalData)
	
	return enc_newEncounter
end

ENCOUNTERS.convoyAmbush_05 = function()
	local encData = {
		name = "Convoy_05",
		player = player5,
		spawn = mkr_convoyAmbush_05,
		sgroups = {sg_convoy_all},
		units = {
			{
				name = "Convoy_05_01",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = Util_GetRandomPosition(mkr_convoyAmbush_05),
			},
			{
				name = "Convoy_05_02",
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				spawn = Util_GetRandomPosition(mkr_convoyAmbush_05),
			},
		},
		goal = {
			name = "Defend",
			target = mkr_convoyAmbush_05,
			range = 45,
			leashRange = Marker_GetProximityRadius(mkr_convoyAmbush_05),
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			}
		},
	}
	local enc_newEncounter = Encounter:Create(encData)
	
	Event_IsEngaged(_ChangeToAttack, {encTable = enc_newEncounter}, enc_newEncounter:GetSgroup(), ANY, 3)
	
	return enc_newEncounter
end

ENCOUNTERS.convoyAmbush_06 = function()
	local encData = {
		name = "Convoy_06",
		player = player5,
		spawn = mkr_convoyAmbush_06,
		sgroups = {sg_convoy_all},
		units = {
			{
				name = "Convoy_06_01",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				spawn = Util_GetRandomPosition(mkr_convoyAmbush_06),
			},
			{
				name = "Convoy_06_02",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				spawn = Util_GetRandomPosition(mkr_convoyAmbush_06),
				slotItems = {SLOT_ITEM.PANZERSHRECK_MP},
			},
			{
				name = "Convoy_06_02",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = Util_GetRandomPosition(mkr_convoyAmbush_06),
			},
		},
		goalData = {
			name = "Defend",
			target = mkr_convoyAmbush_06,
			range = 45,
			leashRange = Marker_GetProximityRadius(mkr_convoyAmbush_06),
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			}
		},
	}
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(encData.goalData)
	
	return enc_newEncounter
end



GOALS = {}

-- A goal that will be assigned to multiple encounters throughout the course of a single mission
GOALS.attackTruck = function(encounter)
	local goalData = {
		name = "Attack",
		target = sg_truck,
		range = 45,
		leashRange = 50,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 500,
			},
		},
	}
	
	encounter:SetGoal(goalData)
end
