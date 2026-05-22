print("\tLoading encdata file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- MISSION NAME - Encounters data
-- Designer: Joe Smith
-------------------------------------------------------------------------
-------------------------------------------------------------------------
ENCOUNTERS = {}

-- Similar to the EVENTS file, each of these creates an encounter and returns a reference.
-- Remember to add a simple description for each encounter.

ENCOUNTERS.BreachGates_Howitzers = function()
	
	-- this is a set of guys that come out to defend the area on the left of the airfield by the front gates
	
	local encData = {
		name = "Howitzers",
		spawn = mkr_encounter_gates_left,
		units = {
			{sbp = SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, spawn = mkr_howitzer_gates_left, killSyncWeapon = true, sgroups = {sg_howitzer_left}},
			{sbp = SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, spawn = mkr_howitzer_gates_right, killSyncWeapon = true, sgroups = {sg_howitzer_right}, difficulty = {GD_NORMAL, GD_HARD}},
		},
		onDeath = nil,
	}
	local goalData = {
		name = "Defend",
		target = mkr_encounter_howitzers,
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(goalData)
	
	return enc_newEncounter
	
end







ENCOUNTERS.BreachGates_Left = function()
	
	-- this is a set of guys that come out to defend the area on the left of the airfield by the front gates
	
	local encData = {
		name = "BreachGates Left",
		spawn = mkr_encounter_gates_left,
		units = {
			{sbp = SBP.GERMAN.GRENADIER_SQUAD, spawn = eg_barracks_left1, backupSpawn = mkr_gates_spawn1},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, spawn = eg_barracks_left2, upgrades = UPG.GERMAN.PANZERBUSCHE_39, backupSpawn = mkr_gates_spawn1},
			{sbp = SBP.GERMAN.STUG_III_E_SQUAD, spawn = mkr_gates_spawn1},
		},
		onDeath = nil,
	}
	local goalData = {
		name = "Defend",
		target = mkr_encounter_gates_left,
		garrisonIdle = true,
	}
	
	CheckForBackUpSpawns(encData)
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(goalData)
	
	return enc_newEncounter
	
end


ENCOUNTERS.BreachGates_Mid = function()
	
	-- this is a set of guys that come out to defend the area in the middle of the airfield by the front gates
	
	local encData = {
		name = "BreachGates Mid",
		spawn = mkr_encounter_gates_mid,
		units = {
			{sbp = SBP.GERMAN.GRENADIER_SQUAD, spawn = eg_barracks_mid1, backupSpawn = mkr_gates_spawn2},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD, spawn = eg_barracks_mid2, backupSpawn = mkr_gates_spawn2},
			{sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, spawn = mkr_gates_spawn2},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, spawn = mkr_gates_spawn2, upgrades = UPG.GERMAN.PANZERBUSCHE_39},
		},
		onDeath = nil,
	}
	local goalData = {
		name = "Defend",
		target = mkr_encounter_gates_mid,
		garrisonIdle = true,
	}
	
	CheckForBackUpSpawns(encData)
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(goalData)
	
	return enc_newEncounter
	
end


ENCOUNTERS.BreachGates_Right = function()
	
	-- this is a set of guys that come out to defend the area on the right of the airfield by the front gates
	
	local encData = {
		name = "BreachGates Right",
		spawn = mkr_encounter_gates_right,
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, spawn = eg_barracks_right1, upgrades = UPG.GERMAN.PANZERBUSCHE_39, backupSpawn = mkr_gates_spawn3},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD, spawn = eg_barracks_right2, backupSpawn = mkr_gates_spawn3},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD, spawn = eg_barracks_right3, backupSpawn = mkr_gates_spawn3},
			{sbp = SBP.GERMAN.STUG_III_E_SQUAD, spawn = mkr_gates_spawn3},
		},
		onDeath = nil,
	}
	local goalData = {
		name = "Defend",
		target = mkr_encounter_gates_right,
		garrisonIdle = true,
	}
	
	CheckForBackUpSpawns(encData)
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(goalData)
	
	return enc_newEncounter
	
end




ENCOUNTERS.FuelDepot1 = function()
	
	-- guys running interference near fuel depot 1
	
	local encData = {
		name = "FuelDepot 1",
		spawn = mkr_fueldepot1_spawn1,
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, spawn = eg_fueldepot1_building1, upgrades = UPG.GERMAN.PANZERBUSCHE_39, backupSpawn = mkr_fueldepot1_spawn1},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD, spawn = eg_fueldepot1_building2, backupSpawn = mkr_fueldepot1_spawn1},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD, spawn = eg_fueldepot1_building3, backupSpawn = mkr_fueldepot1_spawn1},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD},
			{sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, difficulty = {GD_NORMAL, GD_HARD}},
			{sbp = SBP.GERMAN.STUG_III_E_SQUAD, spawn = mkr_extra_spawn02},
		},
		onDeath = nil,
	}
	local goalData = {
		name = "Defend",
		target = mkr_fueldepot1_encounter,
		garrisonIdle = true,
	}
	
	CheckForBackUpSpawns(encData)
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(goalData)
	
	return enc_newEncounter
	
end




ENCOUNTERS.FuelDepot2 = function()
	
	-- guys running interference near fuel depot 2
	
	local encData = {
		name = "FuelDepot 2",
		spawn = mkr_fueldepot2_spawn1,
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, spawn = eg_fueldepot2_building1, upgrades = UPG.GERMAN.PANZERBUSCHE_39, backupSpawn = mkr_fueldepot2_spawn1},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD, spawn = eg_fueldepot2_building2, backupSpawn = mkr_fueldepot2_spawn1},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD, spawn = eg_fueldepot2_building3, backupSpawn = mkr_fueldepot2_spawn1},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD},
			{sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, difficulty = {GD_NORMAL, GD_HARD}},
			{sbp = SBP.GERMAN.STUG_III_E_SQUAD, spawn = mkr_extra_spawn04},
		},
		onDeath = nil,
	}
	local goalData = {
		name = "Defend",
		target = mkr_fueldepot2_encounter,
		garrisonIdle = true,
	}
	
	CheckForBackUpSpawns(encData)
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(goalData)
	
	return enc_newEncounter
	
end



-- Various encounters that guard the small groups of planes
ENCOUNTERS.Airfield_Aircraft1 = function()
	
	local encData = {
		name = "Aircraft 1 Defenders",
		spawn = EGroup_GetPosition(eg_aircraft_1),
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
		},
	}
	local goalData = {
		name = "Defend",
		target = eg_aircraft_1,
		leashRange = 25,
		range = 55,
		onFailure = Aircraft_EncounterRetreat,
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(goalData)
	
	return enc_newEncounter
	
end

ENCOUNTERS.Airfield_Aircraft2 = function()
	
	local encData = {
		name = "Aircraft 2 Defenders",
		spawn = EGroup_GetPosition(eg_aircraft_2),
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD},
			{sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD},
		},
	}
	local goalData = {
		name = "Defend",
		target = eg_aircraft_2,
		leashRange = 25,
		range = 55,
		onFailure = Aircraft_EncounterRetreat,
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(goalData)
	
	return enc_newEncounter
	
end

ENCOUNTERS.Airfield_Aircraft3 = function()
	
	local encData = {
		name = "Aircraft 3 Defenders",
		spawn = EGroup_GetPosition(eg_aircraft_3),
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD},
		},
	}
	local goalData = {
		name = "Defend",
		target = eg_aircraft_3,
		leashRange = 25,
		range = 55,
		onFailure = Aircraft_EncounterRetreat,
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(goalData)
	
	return enc_newEncounter
	
end


ENCOUNTERS.Airfield_Aircraft4 = function()
	
	local encData = {
		name = "Aircraft 4 Defenders",
		spawn = EGroup_GetPosition(eg_aircraft_4),
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD},
		},
	}
	local goalData = {
		name = "Defend",
		target = eg_aircraft_4,
		leashRange = 25,
		range = 55,
		onFailure = Aircraft_EncounterRetreat,
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(goalData)
	
	return enc_newEncounter
	
end


ENCOUNTERS.Airfield_Aircraft5 = function()
	
	local encData = {
		name = "Aircraft 5 Defenders",
		spawn = EGroup_GetPosition(eg_aircraft_5),
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD},
		},
	}
	local goalData = {
		name = "Defend",
		target = eg_aircraft_5,
		leashRange = 25,
		range = 55,
		onFailure = Aircraft_EncounterRetreat,
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(goalData)
	
	return enc_newEncounter
	
end


ENCOUNTERS.Airfield_Aircraft6 = function()
	
	local encData = {
		name = "Aircraft 6 Defenders",
		spawn = EGroup_GetPosition(eg_aircraft_6),
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD},
		},
	}
	local goalData = {
		name = "Defend",
		target = eg_aircraft_6,
		leashRange = 25,
		range = 55,
		onFailure = Aircraft_EncounterRetreat,
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(goalData)
	
	return enc_newEncounter
	
end


ENCOUNTERS.Airfield_Aircraft7 = function()
	
	local encData = {
		name = "Aircraft 7 Defenders",
		spawn = EGroup_GetPosition(eg_aircraft_7),
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD},
		},
	}
	local goalData = {
		name = "Defend",
		target = eg_aircraft_7,
		leashRange = 25,
		range = 55,
		onFailure = Aircraft_EncounterRetreat,
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(goalData)
	
	return enc_newEncounter
	
end




ENCOUNTERS.Airfield_IncomingEncounter = function(spawn, area, units)
	
	local encData = {
		name = "Airfield Extra "..Marker_GetName(area),
		spawn = spawn,
		units = units,
		onDeath = nil,
	}
	local goalData = {
		name = "Defend",
		target = area,
		leashRange = 40,
		range = 80,
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(goalData)
	
	return enc_newEncounter
	
end




ENCOUNTERS.AirfieldHarrassment = function()
	
	-- these are guys that are topped up periodically, and go after the player if he pulls back to repair
	
	local encData = {
		name = "Airfield Harrassment",
		spawn = mkr_airfield_middle,
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, spawn = mkr_controltower_spawn01, upgrades = UPG.GERMAN.PANZERBUSCHE_39},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, spawn = mkr_controltower_spawn02, upgrades = UPG.GERMAN.PANZERBUSCHE_39, difficulty = GD_HARD},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD, spawn = mkr_controltower_spawn03},
		},
		onDeath = nil,
	}
	local goalData = {
		name = "Defend",
		target = mkr_airfield_middle,
		range = Marker_GetProximityRadius(mkr_airfield_middle) + 40,
		leashRange = Marker_GetProximityRadius(mkr_airfield_middle),
		retaliateAttacks = true,
		patrolParams = {
			path = "path_airfield_patrol",
			wait = 5,
		},
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(goalData)
	
	return enc_newEncounter
	

end



ENCOUNTERS.ControlTower_ATGun1 = function()
	
	-- these are the Pak43s on the pedestals around the control tower
	
	local encData = {
		name = "Howitzers",
		spawn = mkr_pak43_spawn01,
		units = {
			{sbp = SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD},
		},
		onDeath = nil,
	}
	local goalData = {
		name = "Defend",
		target = mkr_pak43_spawn01,
		leashRange = 5,
		range = 55,
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(goalData)
	
	return enc_newEncounter
	
end

ENCOUNTERS.ControlTower_ATGun2 = function()
	
	-- these are the Pak43s on the pedestals around the control tower
	
	local encData = {
		name = "Howitzers",
		spawn = mkr_pak43_spawn02,
		units = {
			{sbp = SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD},
		},
		onDeath = nil,
	}
	local goalData = {
		name = "Defend",
		target = mkr_pak43_spawn02,
		leashRange = 5,
		range = 55,
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(goalData)
	
	return enc_newEncounter
	
end



ENCOUNTERS.ControlTower_Defenders = function()
	
	-- this is a set of guys that defend the area around the control tower
	
	local encData = {
		name = "Howitzers",
		spawn = mkr_controltower_zone,
		units = {
			{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, spawn = eg_controltower, backupSpawn = mkr_controltower_spawn04},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD, spawn = mkr_controltower_spawn04, difficulty = GD_NORMAL},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, spawn = mkr_controltower_spawn04, difficulty = GD_HARD, upgrades = UPG.GERMAN.PANZERBUSCHE_39},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD, spawn = mkr_controltower_spawn05},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD, spawn = mkr_controltower_spawn06},
		},
		onDeath = nil,
	}
	local goalData = {
		name = "Defend",
		target = mkr_controltower_zone,
		garrisonIdle = true,
	}
	
	CheckForBackUpSpawns(encData)
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(goalData)
	
	return enc_newEncounter
	
end







ENCOUNTERS.Counterattack = function()
	
	
	local encData = {
		name = "Howitzers",
		spawn = mkr_airfield_zone,
		sgroups = {sg_counterattack},
		units = {
			{sbp = SBP.GERMAN.TIGER_SQUAD, spawn = mkr_controltower_spawn02, sgroups = {sg_counterattack_tiger}},
		},
		onDeath = nil,
	}
	local goalData = {
		name = "Defend",
		target = mkr_airfield_zone,
		range = Marker_GetProximityRadius(mkr_airfield_zone) + 30,
		leashRange = Marker_GetProximityRadius(mkr_airfield_zone),
		retaliateAttacks = true,
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(goalData)
	
	return enc_newEncounter
	
end



ENCOUNTERS.Counterattack_Entourage = function()
	
	
	local encData = {
		name = "Howitzers",
		spawn = mkr_airfield_zone,
		sgroups = {sg_counterattack},
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, spawn = mkr_controltower_spawn01, sgroups = {sg_counterattack}, upgrades = UPG.GERMAN.PANZERBUSCHE_39},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, spawn = mkr_controltower_spawn03, sgroups = {sg_counterattack}},
			{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222, spawn = mkr_controltower_spawn01, sgroups = {sg_counterattack}, upgrades = {UPG.GERMAN.SDKFZ_222_20MM_GUN}, difficulty = GD_NORMAL, GD_HARD},
			{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222, spawn = mkr_controltower_spawn03, sgroups = {sg_counterattack}, upgrades = {UPG.GERMAN.SDKFZ_222_20MM_GUN}, difficulty = GD_NORMAL},
			{sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, spawn = mkr_controltower_spawn03, sgroups = {sg_counterattack}, difficulty = GD_HARD},
			{sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, spawn = mkr_controltower_spawn02, sgroups = {sg_counterattack}, difficulty = GD_HARD},
		},
		onDeath = nil,
	}
	local goalData = {
		name = "Defend",
		target = sg_counterattack_tiger,
		range = 50,
		leashRange = 60,
		onFailure = Counterattack_EntourageRetreat,
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	enc_newEncounter:SetGoal(goalData)
	
	return enc_newEncounter
	
end



GOALS = {}

-- A goal that will be assigned to multiple encounters throughout the course of a single mission
GOALS.myGenericGoal = function(encounter)
	local goalData = {
		name = "Defend",
		target = mkr_O1_space,
		range = 45,
		leashRange = mkr_O1_space,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 500,
			},
		},
	}
	
	encounter:SetGoal(goalData)
end













function CheckForBackUpSpawns(encData)

	for index, unit in pairs(encData.units) do 
		
		-- if it's an empty EGroup or an empty SGroup
		if (scartype(unit.spawn) == ST_EGROUP and EGroup_Count(unit.spawn) == 0) or (scartype(unit.spawn) == ST_SGROUP and SGroup_Count(unit.spawn) == 0) then
			
			-- if there's a backupSpawn listed, use that instead
			if unit.backupSpawn ~= nil then
				unit.spawn = unit.backupSpawn
			end
			
		end
		
	end

end
