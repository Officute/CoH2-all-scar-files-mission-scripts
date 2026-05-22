-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- EXAMPLE MISSION - Encounters data
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- All encounters are held in this file, and can be referenced externally to be created.
ENCOUNTERS = {}

-- Similar to the EVENTS file, each of these creates an encounter and returns a reference.

--This encounter is at the farm on the far end of the map, and is the goal of the second objective
ENCOUNTERS.ExampleEncounter = function()
	local encData = {
		name = "Second Objective Encounter", -- Encounter Name
		spawn = mkr_enemyDefendGoal, --The default spawn marker for the encounter (can be overridden below)
--~ 		sgroups = {}, --Any sgroups that the encounter should be added to
		units = { --A list of unit tables spawned by the encounter
			{
				name = "Grens", --Unit name
				sbp = SBP.GERMAN.GRENADIER_SQUAD, -- Unit blueprint 
				spawn = mkr_enemySpawnsGrens, -- Spawn marker for the unit
			},
			{
				name = "MG",
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_MP,
				spawn = mkr_enemySpawnsHMG,
			},
		},
		goal = { --This represents the goal of the encounter - (ie: whether it is defending an area, attacking, etc...)
			name = "Defend", --The name defines the type of encounter this is
			target = mkr_enemySpawns, --The target the encounter is geared around
			range = 45, -- The area around target that is considered a part of the encounter
			leashRange = mkr_enemySpawns, --The distance from the target that units in the counter will wander (when using a marker, it will get the marker's radius)
		},
	}
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	
	return enc_newEncounter
end



--~ ENCOUNTERS.ExampleEncounter = function()
--~ 	local encData = {
--~ 		name = "EnemyEncounter1", 
--~ 		spawn = mkr_enemyDefendGoal, 
--~ 		sgroups = {}, --Any sgroups that the encounter should be added to
--~ 		units = { --A list of unit tables spawned by the encounter
--~ 			{
--~ 				name = "Grens", --Unit name
--~ 				sbp = SBP.GERMAN.GRENADIER_SQUAD,
--~ 				spawn = mkr_enemySpawn,
--~ 			},
--~ 		},
--~ 		goal = { --This represents the goal of the encounter - (ie: whether it is defending an area, attacking, etc...)
--~ 			name = "Defend", --The name defines the type of encounter this is
--~ 			target = mkr_enemySpawns, --The target the encounter is geared around
--~ 			range = 45, -- The area around target that is considered a part of the encounter
--~ 			leashRange = mkr_enemySpawns, --The distance from the target that units in the counter will wander (when using a marker, it will get the marker's radius)
--~ 		},
--~ 	}
--~ 	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
--~ 	
--~ 	return enc_newEncounter
--~ end