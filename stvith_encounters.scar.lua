print("\tLoading encdata file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- St. Vith - Encounters data
-- Designer: A.Molina
-------------------------------------------------------------------------
-------------------------------------------------------------------------

ENCOUNTERS = {}

--WaveDefense waves
ENCOUNTERS.Wave1 = function()
	return {
		encounters = {
			-- Direction 1 - These are split so they don't clump on spawn.
			{
				direction = 1, 
				units = {
					SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				},
			},
			{
				direction = 1, 
				units = {
					{
						sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() >= 3 and g_difficulty ~= GD_EASY},
					}
				},
			},
			
			-- Direction 2
			{
				direction = 2,
				units = {
					SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				}
			},
			{
				direction = 2,
				units = {
					{
						sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() >= 3 and g_difficulty ~= GD_EASY},
					}
				}
			},
			
			-- Direction 3
			{
				direction = 3,
				units = {
					SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				}
			},
			{
				direction = 3,
				units = {
					{
						sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() >= 3 and g_difficulty ~= GD_EASY},
					}
				}
			},
		},
	}
end

ENCOUNTERS.Wave2 = function()
	local _spawns = Util_GetUniqueRandomSpawns(g_maxAttackDirs)
	
	return {
		encounters = {
			-- Direction 1
			{
				direction = _spawns[1],
				units = {
					SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
					SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				},
			},
			{
				direction = _spawns[1],
				units = {
					{
						sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() >= 4 and g_difficulty ~= GD_EASY},
					},
					{
						sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
						conditions = {g_difficulty == GD_HARD},
					},
				},
			},
		},
	}
end

ENCOUNTERS.Wave3 = function()
	local _spawns = Util_GetUniqueRandomSpawns(g_maxAttackDirs)
	
	return {
		encounters = {
			-- Direction 1
			{
				direction = _spawns[1],
				units = {
					SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
					{
						sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() >= 4 and g_difficulty ~= GD_EASY},
					},
				},
			},
			{
				direction = _spawns[1],
				units = {
					SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
					{
						sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP,
						conditions = {XP1_GetNodeStrength() >= 3 and g_difficulty ~= GD_HARD},
					},
					{
						sbp = SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() >= 2 and g_difficulty == GD_HARD},
					},
				},
			},
			
			-- Direction 2
			{
				direction = _spawns[2],
				units = {
					SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
					{
						sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() >= 4 and g_difficulty ~= GD_HARD},
					},
					{
						sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() >= 4 and g_difficulty == GD_HARD},
					},
					{
						sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() <= 3},
					},
				},
			},
			{
				direction = _spawns[2],
				units = {
					{
						sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
						difficulty = GD_HARD,
					},
					{
						sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP,
						conditions = {XP1_GetNodeStrength() <= 3},
					},
					{
						sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() >= 4 and g_difficulty ~= GD_EASY},
					},
				},
			},
		},
	}
end

ENCOUNTERS.Wave4MiniBoss = function()
	local spawnLoc = World_GetRand(1,3)

	return {
		encounters = {
			-- Direction 1
			{
				direction = spawnLoc,
				units = {
					{
						sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
						conditions = {g_panzers == false},
					},
					{
						sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
						upgrades = (g_difficulty == GD_HARD and UPG.GERMAN.PANZER_TOP_GUNNER_MP or nil),
						conditions = {g_panzers == true},
					},
					SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,	
				},
			},
			{
				direction = spawnLoc,
				units = {
					{
						sbp = SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP,
						conditions = {g_panzers == false},
					},
					{
						sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() >= 2 and g_difficulty ~= GD_HARD},
					},
					{
						sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() >= 2 and g_difficulty == GD_HARD},
					},
				},
			},
		},
	}
end

ENCOUNTERS.Wave5 = function()
	local _spawns = Util_GetUniqueRandomSpawns(g_maxAttackDirs)
	
	return {
		encounters = {
			-- Direction 1
			{
				direction = _spawns[1],
				units = {
					SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
					SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				},
			},
			{
				direction = _spawns[1],
				units = {
					{
						sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() >= 3 and g_difficulty ~= GD_EASY},
					},
				},
			},
			
			-- Direction 2
			{
				direction = _spawns[2],
				units = {
					SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
					SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				},
			},
			{
				direction = _spawns[2],
				units = {
					{
						sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() >= 3 and g_difficulty == GD_NORMAL},
					},
					{
						sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() >= 3 and g_difficulty == GD_HARD},
					},
				},
			},
		},
	}
end

ENCOUNTERS.Wave6 = function()
	local _spawns = Util_GetUniqueRandomSpawns(g_maxAttackDirs)
	
	return {
		encounters = {
			-- Direction 1
			{
				direction = _spawns[1],
				units = {
					SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
					SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
					{
						sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP,
					},
				},
			},
			{
				direction = _spawns[1],
				units = {
					{
						sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() >= 3},
					},
					{
						sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
						upgrades = (g_difficulty >= GD_NORMAL and UPG.GERMAN.PANZER_TOP_GUNNER_MP or nil),
						conditions = {g_panzers == true},
					},
					{
						sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
						conditions = {g_panzers == false},
					},
				},
			},
			
			-- Direction 2
			{
				direction = _spawns[2],
				units = {
					SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
					{
						sbp = SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP,
						conditions = {g_difficulty ~= GD_EASY},
					},
					{
						sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP,
						conditions = {g_difficulty == GD_EASY},
					},
					{
						sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() >= 5 and g_difficulty ~= GD_EASY},
					},
					{
						sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
						difficulty = GD_HARD,
					},
				},
			},
			{
				direction = _spawns[2],
				units = {
					SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
					{
						sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
						upgrades = (g_difficulty >= GD_NORMAL and UPG.GERMAN.PANZER_TOP_GUNNER_MP or nil),
						conditions = {g_panzers == true and g_difficulty == GD_HARD},
					},
					{
						sbp = SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP,
						conditions = {g_panzers == false or g_difficulty ~= GD_HARD},
					},
				},
			},
		},
	}
end

ENCOUNTERS.Wave7 = function()
	local _spawns = Util_GetUniqueRandomSpawns(g_maxAttackDirs)
	
	return {
		encounters = {
			-- Direction 1
			{
				direction = _spawns[1],
				units = {
					{
						sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
					},
					{
						sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
						conditions = {g_difficulty ~= GD_HARD},
					},
					{
						sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() <= 4 and g_difficulty >= GD_NORMAL}
					},
					{
						sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() >= 5 and g_difficulty >= GD_NORMAL}
					},
					{
						sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
						conditions = {g_difficulty == GD_HARD},
					},
				},
			},
			{
				direction = _spawns[1],
				units = {
					{
						sbp = SBP.WEST_GERMAN.PANTHER_AUSF_G_SQUAD_MP,
						sgroups = {sg_finalHeavyTank},
						upgrades = (g_difficulty >= GD_NORMAL and UPG.GERMAN.PANTHER_TOP_GUNNER_MP or nil),
						conditions = {g_king_tiger == false and g_panzers == true},
					},
					{
						sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
						sgroups = {sg_finalHeavyTank},
						conditions = {g_panzers == false and g_king_tiger == false},
					},
					{
						sbp = SBP.WEST_GERMAN.KING_TIGER_SQUAD_MP,
						sgroups = {sg_finalHeavyTank},
						conditions = {g_king_tiger == true},
					},
				},
			},
			
			-- Direction 2
			{
				direction = _spawns[2],
				units = {
					{
						sbp = 	SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
					},
					{
						sbp = 	SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
					},
					{
						sbp = 	SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() <= 4 and g_difficulty >= GD_NORMAL}
					},
					{
						sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
						conditions = {XP1_GetNodeStrength() >= 5 and g_difficulty >= GD_NORMAL}
					},
					{
						sbp = 	SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
						conditions = {g_difficulty == GD_HARD},
					},
				},
			},
			{
				direction = _spawns[2],
				units = {
					{
						sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
						upgrades = (g_difficulty >= GD_NORMAL and UPG.GERMAN.PANZER_TOP_GUNNER_MP or nil),
						conditions = {g_panzers == true},
					},
					{
						sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
						conditions = {g_panzers == false},
					},
					{
						sbp = SBP.GERMAN.STUG_III_SQUAD_MP,
						conditions = {g_panzers == false and g_difficulty == GD_HARD},
					},
				},
			},
		},
	}
end


--Radio Jammer + escort.
ENCOUNTERS.RadioJammer = function(spawnLoc, moveToLoc)
	local encData = {
		name = "radioJammer",
		spawn = spawnLoc,
		moveTo = moveToLoc,
		attackMoveTo = true,
		units = {
			{
				sbp = SBP.WEST_GERMAN.SCOUTCAR_223_SQUAD,
			},
		},
		onDeath = JammerDestroyed,
		goal = {
			name = "Defend",
			target = moveToLoc,
			range = 30,
			leashRange = 12,
			maxIdleTime = -1,
			movePathLengthFactor = 1.0,
			safeMoveWeight = 0.0,
			retaliateAttacks = false,
		},
	}
	return XP1_EncounterCreate(encData)
end

ENCOUNTERS.JammerDefender = function(spawnLoc, defendTarget)
	local encData = {
		name = "radioJammer",
		spawn = spawnLoc,
		attackMoveTo = true,
		units = {
			SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
		},
		goal = {
			name = "Defend",
			target = defendTarget,
			range = 30,
			leashRange = 15,
			maxIdleTime = -1,
			movePathLengthFactor = 1.0,
			safeMoveWeight = 0.0,
			retaliateAttacks = false,
			onFailure = RetreatEncounter,
		},
	}
	return XP1_EncounterCreate(encData)
end

function RetreatEncounter(enc)
	enc:ClearGoal()
--~ 	enc:Disable()
	
	Cmd_Retreat(enc:GetSgroup(), enc.data.spawn, enc.data.spawn, false, true)
end


GOALS = {}

-- A goal that will be assigned to multiple encounters throughout the course of a single mission
GOALS.AttackBase = function(encounter)
	local goalData = {				
		name = "Defend",
		target = mkr_attackBase,
		range = 5,
		leashRange = 5,
		attackMove = true,
		coordinatedSetup = false,
		tacticControlsList = {
			{tacticType = TACTIC_Pickup, priority = -1},
			{tacticType = TACTIC_Recrew, priority = -1},
			{tacticType = TACTIC_CaptureTeamWeapon, priority = -1},
			{tacticType = TACTIC_RushAtTarget, priority = -1},
		},
		movePathLengthFactor = -1,
	}
	
	encounter:SetGoal(goalData)
end
