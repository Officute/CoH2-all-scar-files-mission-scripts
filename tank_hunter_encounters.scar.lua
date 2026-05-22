print("\tLoading encdata file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Tank_Hunter - Encounters data
-- Designer: A.Molina
-------------------------------------------------------------------------
-------------------------------------------------------------------------
ENCOUNTERS = {}


-- Static Encounters
ENCOUNTERS.enemyTank_01 = function(spawnLoc)
	local encData = {
		name = "Tank_01",
		spawn = spawnLoc,
		units = {
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				spawn = Util_GetRandomPosition(spawnLoc),
				difficulty = GD_HARD,
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = Util_GetRandomPosition(spawnLoc),
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				sbp = SBP.WEST_GERMAN.KING_TIGER_SQUAD_MP,
				spawn = spawnLoc,
				sgroups = {sg_enemyTanks},
				onDeath = TankKilled,
			},
		},
		goal = {
			name = "Defend",
			target = spawnLoc,
			range = 35,
			leashRange = 45,
		},
	}
	return Encounter:Create(encData)
end

ENCOUNTERS.enemyTank_02 = function(spawnLoc)
	local encData = {
		name = "Tank_02",
		spawn = spawnLoc,
		units = {
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				spawn = Util_GetRandomPosition(spawnLoc),
				difficulty = GD_HARD,
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = Util_GetRandomPosition(spawnLoc),
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				sbp = SBP.WEST_GERMAN.PANTHER_AUSF_G_SQUAD_MP,
				spawn = spawnLoc,
				sgroups = {sg_enemyTanks},
				onDeath = TankKilled,
			},
		},
		goal = {
			name = "Defend",
			target = spawnLoc,
			range = 35,
			leashRange = 45,
		},
	}
	return Encounter:Create(encData)
end

ENCOUNTERS.enemyTank_03 = function(spawnLoc)
	local encData = {
		name = "Tank_03",
		spawn = spawnLoc,
		units = {
			{
				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
				spawn = Util_GetRandomPosition(spawnLoc),
				difficulty = GD_HARD,
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = Util_GetRandomPosition(spawnLoc),
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				sbp = SBP.WEST_GERMAN.JAGDPANZER_TANK_DESTROYER_SQUAD_MP,
				spawn = spawnLoc,
				sgroups = {sg_enemyTanks},
				onDeath = TankKilled,
			},
		},
		goal = {
			name = "Defend",
			target = spawnLoc,
			range = 35,
			leashRange = 45,
		},
	}
	return Encounter:Create(encData)
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
