print("\tLoading Twin_Villages_encounters file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- INTRO MISSION / TWIN VILLAGES - Encounters data
-- Designer: NJR
-------------------------------------------------------------------------
-------------------------------------------------------------------------
ENCOUNTERS = {}
GOALS = {}





---------------------------
-- SENTRY DUTY OBJECTIVE --
---------------------------

-- enemy attack through the trees (and we keep adding units to this encounter over time)
ENCOUNTERS.Support_EnemyAttack = function()

	local encData = {
		
		name = "Sentry 1 Attackers",
		player = player2,
		spawn = {mkr_sentry1_enemyspawn1, mkr_sentry1_enemyspawn2, mkr_sentry1_enemyspawn3, mkr_sentry1_enemyspawn4, mkr_sentry1_enemyspawn5},
		dynamicSpawnTarget = mkr_sentry1_encounterarea,
		sgroups = {sg_sentry1_attackers},
		
		units = {
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, load = 2},
			{sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, load = 3},
			{sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, load = 4},
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, load = 2},
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, load = 3},
			{sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, load = 4},
		},
		
		goal = {
			name = "Defend",
			target = mkr_sentry1_encounterarea,
			leashRange = Marker_GetProximityRadius(mkr_sentry1_encounterarea),
			range = Marker_GetProximityRadius(mkr_sentry1_encounterarea) + 20,
			garrison = false,
			garrisonIdle = false,
		},
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter

end






----------------------
-- AIRBORNE SECTION --
----------------------

-- the first line of allied defenders (they eventually fall back fold into the subsequent encounters)
ENCOUNTERS.Airborne_VillageAttackers1 = function()

	local encData = {
		
		name = "Rocherath Attackers 1",
		player = player2,
		spawn = {mkr_airborne_edgespawn_west, mkr_airborne_edgespawn_north},
		dynamicSpawnTarget = mkr_rocherath_enemy_encounterarea1,
		sgroups = {sg_airborne_attackers1},
		
		units = {
			{sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, load = 3, spawn = mkr_airborne_village_enemyspawn3},
		},
		
		goal = {
			name = "Defend",
			target = mkr_rocherath_enemy_encounterarea1,
			leashRange = Marker_GetProximityRadius(mkr_rocherath_enemy_encounterarea1),
			range = Marker_GetProximityRadius(mkr_rocherath_enemy_encounterarea1) + 30,
		},
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter

end

ENCOUNTERS.Airborne_VillageAttackers2 = function()

	local encData = {
		
		name = "Rocherath Attackers 2",
		player = player2,
		spawn = {mkr_airborne_edgespawn_west, mkr_airborne_edgespawn_north, mkr_airborne_edgespawn_east},
		dynamicSpawnTarget = mkr_rocherath_enemy_encounterarea2,
		sgroups = {sg_airborne_attackers2},
		
		units = {
			{sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, load = 3, spawn = mkr_airborne_village_enemyspawn1},
			{sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, load = 3, spawn = mkr_airborne_village_enemyspawn2},
		},
		
		goal = {
			name = "Defend",
			target = mkr_rocherath_enemy_encounterarea2,
			leashRange = Marker_GetProximityRadius(mkr_rocherath_enemy_encounterarea2),
			range = Marker_GetProximityRadius(mkr_rocherath_enemy_encounterarea2) + 30,
		},
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter

end

ENCOUNTERS.Airborne_VillageAttackers3 = function()

	local encData = {
		
		name = "Rocherath Attackers 3",
		player = player2,
		spawn = {mkr_airborne_edgespawn_north, mkr_airborne_edgespawn_east, mkr_airborne_edgespawn_southeast},
		dynamicSpawnTarget = mkr_rocherath_enemy_encounterarea3,
		sgroups = {sg_airborne_attackers3},
		
		units = {
			{sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, load = 2, spawn = mkr_airborne_village_enemyspawn4},
			{sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, load = 3, spawn = mkr_airborne_village_enemyspawn5},
		},
		
		goal = {
			name = "Defend",
			target = mkr_rocherath_enemy_encounterarea3,
			leashRange = Marker_GetProximityRadius(mkr_rocherath_enemy_encounterarea3),
			range = Marker_GetProximityRadius(mkr_rocherath_enemy_encounterarea3) + 30,
		},
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter

end





GOALS.Airborne_VillageAttackers1_Secondary = function()
	
	return {
		name = "Defend",
		target = mkr_rocherath_enemy_encounterarea1b,
		leashRange = Marker_GetProximityRadius(mkr_rocherath_enemy_encounterarea1b),
		range = Marker_GetProximityRadius(mkr_rocherath_enemy_encounterarea1b) + 30,
		garrison = true,
		garrisonIdle = true,
	}

end

GOALS.Airborne_VillageAttackers2_Secondary = function()
	
	return {
		name = "Defend",
		target = mkr_rocherath_enemy_encounterarea2b,
		leashRange = Marker_GetProximityRadius(mkr_rocherath_enemy_encounterarea2b),
		range = Marker_GetProximityRadius(mkr_rocherath_enemy_encounterarea2b) + 30,
		garrison = true,
		garrisonIdle = true,
	}

end

GOALS.Airborne_VillageAttackers3_Secondary = function()
	
	return {
		name = "Defend",
		target = mkr_rocherath_enemy_encounterarea3b,
		leashRange = Marker_GetProximityRadius(mkr_rocherath_enemy_encounterarea3b),
		range = Marker_GetProximityRadius(mkr_rocherath_enemy_encounterarea3b) + 30,
		garrison = true,
		garrisonIdle = true,
	}

end





ENCOUNTERS.Airborne_ForestDefenders = function()

	local encData = {
		
		name = "Forest defenders",
		player = player2,
		spawn = {mkr_rocherath_enemyspawn1, mkr_rocherath_enemyspawn2, mkr_rocherath_enemyspawn3, mkr_rocherath_enemyspawn4},
		sgroups = {sg_airborne_forest_defenders},
		
		units = {
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = mkr_rocherath_enemyspawn1},
			{sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, spawn = mkr_rocherath_enemyspawn3},
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = mkr_rocherath_enemyspawn4},
		},
		
		triggerGoalOnSight = true,
		goal = {
			name = "Defend",
			target = mkr_rocherath_forest_encounterarea,
			leashRange = Marker_GetProximityRadius(mkr_rocherath_forest_encounterarea),
			range = Marker_GetProximityRadius(mkr_rocherath_forest_encounterarea) + 30,
		},
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter

end


ENCOUNTERS.Airborne_RadioDefenders = function()

	local encData = {
		
		name = "Radio Tower defenders",
		player = player2,
		spawn = {mkr_rocherath_enemyspawn1, mkr_rocherath_enemyspawn2, mkr_rocherath_enemyspawn3, mkr_rocherath_enemyspawn4},
		sgroups = {sg_airborne_radiotower_defenders},
		
		units = {
			{sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, spawn = mkr_rocherath_enemyspawn1},
			{sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, spawn = mkr_rocherath_enemyspawn2},
			{sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, spawn = mkr_rocherath_enemyspawn3},
		},
		
		goal = {
			name = "Defend",
			target = mkr_airborne_radioarea,
			leashRange = Marker_GetProximityRadius(mkr_airborne_radioarea),
			range = Marker_GetProximityRadius(mkr_airborne_radioarea) + 30,
			garrison = true,
			garrisonIdle = false,
		},
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter

end



------------------------
-- MECHANIZED SECTION --
------------------------

-- units on north side of the road
ENCOUNTERS.Mechanized_Attackers1 = function()

	local encData = {
		
		name = "Mechanized Attackers 1",
		player = player2,
		spawn = {mkr_mechanized_additionalspawn1, mkr_mechanized_additionalspawn2, mkr_mechanized_additionalspawn3},
		dynamicSpawnTarget = mkr_mechanized_encounterarea1,
		sgroups = {sg_mechanized_attackers1},
		
		units = {
			{sbp = SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP, spawn = mkr_mechanized_infantryspawn1},
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = mkr_mechanized_infantryspawn2},
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = mkr_mechanized_infantryspawn3},
		},
		
		goal = {
			name = "Defend",
			target = mkr_mechanized_encounterarea1,
			leashRange = Marker_GetProximityRadius(mkr_mechanized_encounterarea1),
			range = Marker_GetProximityRadius(mkr_mechanized_encounterarea1) + 20,
		},
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter

end


-- units on south side of the road
ENCOUNTERS.Mechanized_Attackers2 = function()

	local encData = {
		
		name = "Mechanized Attackers 2",
		player = player2,
		spawn = {mkr_mechanized_additionalspawn4, mkr_mechanized_additionalspawn5, mkr_mechanized_additionalspawn6},
		dynamicSpawnTarget = mkr_mechanized_encounterarea2,
		sgroups = {sg_mechanized_attackers2},
		
		units = {
			{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, spawn = mkr_mechanized_infantryspawn4},
			{sbp = SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP, spawn = mkr_mechanized_infantryspawn5},
			{sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, spawn = mkr_mechanized_infantryspawn6},
		},
		
		goal = {
			name = "Defend",
			target = mkr_mechanized_encounterarea2,
			leashRange = Marker_GetProximityRadius(mkr_mechanized_encounterarea2),
			range = Marker_GetProximityRadius(mkr_mechanized_encounterarea2) + 20,
		},
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter

end


-- units at the head of the road
ENCOUNTERS.Mechanized_Attackers3 = function()

	local encData = {
		
		name = "Mechanized Attackers 3",
		player = player2,
		spawn = mkr_mechanized_additionalspawn4,
		dynamicSpawnTarget = mkr_mechanized_encounterarea3,
		sgroups = {sg_mechanized_attackers3},
		
		units = {
			{sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, spawn = mkr_mechanized_infantryspawn1},
			{sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, spawn = mkr_mechanized_infantryspawn4},
		},
		
		triggerGoalOnSight = true,
		goal = {
			name = "Defend",
			target = mkr_mechanized_encounterarea3,
			leashRange = Marker_GetProximityRadius(mkr_mechanized_encounterarea3),
			range = Marker_GetProximityRadius(mkr_mechanized_encounterarea3) + 20,
		},
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter

end








-- allied units who man the sentry point and give you LOS during the mechanized fight
ENCOUNTERS.Mechanized_SentryDefenders1 = function()

	local encData = {
		
		name = "Mechanized Sentry Defenders 1",
		player = player4,	-- Support
		spawn = mkr_mechanized_sentryencounterarea,
		sgroups = {sg_mechanized_sentrydefenders1},
		
		units = {
			{sbp = SBP.AEF.RIFLEMEN_SQUAD_MP, spawn = eg_sentry2_watchtower},
			{sbp = SBP.AEF.RIFLEMEN_SQUAD_MP, spawn = eg_sentry2_house1},
			{sbp = SBP.AEF.RIFLEMEN_SQUAD_MP, spawn = eg_sentry2_house2},
			{sbp = SBP.AEF.M2HB_50CAL_HMG_SQUAD_MP, spawn = mkr_mechanized_sentryspawn1},
			{sbp = SBP.AEF.M2HB_50CAL_HMG_SQUAD_MP, spawn = mkr_mechanized_sentryspawn2},
		},
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_mechanized_sentryencounterarea,
			leashRange = Marker_GetProximityRadius(mkr_mechanized_sentryencounterarea),
			range = Marker_GetProximityRadius(mkr_mechanized_sentryencounterarea) + 30,
			garrison = true,
			garrisonIdle = false,
		},
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter

end

ENCOUNTERS.Mechanized_ForwardSentryDefenders1 = function()

	local encData = {
		
		name = "Mechanized Forward Sentry Defenders 1",
		player = player4,	-- Support
		spawn = eg_sentry2_house1,
		backupSpawn = mkr_mechanized_sentry_backupspawn,
		sgroups = {sg_mechanized_forwardsentrydefenders1},
		
		units = {
			{sbp = SBP.AEF.RIFLEMEN_SQUAD_MP, spawn = mkr_mechanized_sentryspawn1},
		},
		
		goal = {
			name = "Defend",
			target = mkr_mechanized_sentryforwardencounterarea1,
			leashRange = Marker_GetProximityRadius(mkr_mechanized_sentryforwardencounterarea1),
			range = Marker_GetProximityRadius(mkr_mechanized_sentryforwardencounterarea1) + 30,
		},
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter

end


ENCOUNTERS.Mechanized_ForwardSentryDefenders2 = function()

	local encData = {
		
		name = "Mechanized Forward Sentry Defenders 2",
		player = player4,	-- Support
		spawn = eg_sentry2_house2,
		backupSpawn = mkr_mechanized_sentry_backupspawn,
		sgroups = {sg_mechanized_forwardsentrydefenders2},
		
		units = {
			{sbp = SBP.AEF.RIFLEMEN_SQUAD_MP, spawn = mkr_mechanized_sentryspawn1},
		},
		
		goal = {
			name = "Defend",
			target = mkr_mechanized_sentryforwardencounterarea2,
			leashRange = Marker_GetProximityRadius(mkr_mechanized_sentryforwardencounterarea2),
			range = Marker_GetProximityRadius(mkr_mechanized_sentryforwardencounterarea2) + 30,
		},
	}
	
	local enc_newEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	return enc_newEncounter

end











