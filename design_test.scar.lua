import("ScriptSetup.scar")
--[[ 
		Mission_SetupPlayers() 		-- Called by OnGameSetup() on frame1
		Mission_SetupVariables()
		Mission_SetDifficulty()
		Mission_SetupRestrictions()
		Mission_Preset()
		Objectives are registered
		Intro NIS
		Intro NISlet
		Sitrep
		Mission_Start()
]]--

-------------------------------------------------------------------------
-- [[ MISSION SETUP ]]
-------------------------------------------------------------------------
function Mission_SetupPlayers() 
    player1 = World_GetPlayerAt(1)
    player2 = World_GetPlayerAt(2)
end

function Mission_Preset()
	musicStart = "streamed/music/missions/m09/m09_cue_start.bsc"
	musicRadioSilence = "streamed/music/missions/m09/m09_cue_radio_silence.bsc"
	musicBreakthrough = "streamed/music/missions/m09/m09_cue_breakthrough.bsc"
	Util_PlayMusic(musicStart, 0, 0)
	
	Camera_SetDefault(35, 35, 45)
	Camera_ResetToDefault()
	
	-- Setup territories
	territory_fuelLeft = World_GetTerritorySectorID(Util_GetPosition(eg_enemyFuelPointLeft))
	territory_fuelRight = World_GetTerritorySectorID(Util_GetPosition(eg_enemyFuelPointRight))

	Player_SetResource(player1, RT_Fuel, 0)
	Player_SetPopCapOverride(player1, 35)
	Player_SetConstructionMenuAvailability(player1, "tp_construction_soviet_engineer", ITEM_REMOVED)

	EGroup_SetInvulnerable(sg_bridges, true)
	-- EGroup_SetSelectable(eg_allBuildings, false)

	SetupMainObjective()

	CapturePoints_Setup()
	DestroyTanks_Setup()

	AI_ToggleDebugPrint()
end

function SetupMainObjective()
	obj_main = {
		OnStart = CapturePoints_Start,
		-- OnStart = DestroyTanks_Start,
		Intel_Start = nil,
		Intel_Complete = nil,
		Intel_Fail = nil,
		Title = "Halt German tank production",
		Description = 1459051,		
		TitleEnd = "Halt German tank production",			
		TitleFail = 1459052,		
		Type = OT_Primary,	
	}
	Objective_Register(obj_main)
end

-------------------------------------------------------------------------
-- MISSION END
-------------------------------------------------------------------------
function MissionFailed()		
	Game_EndSP(false)
end

function MissionComplete()	
	Mission_Complete()
end

-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
function Mission_Start()
	playerRadioEnabled = true

	Event_OnHealth(Mission_Fail, nil, eg_playerHQ, 0)
	Objective_Start(obj_main)
end

-------------------------------------------------------------------------
-- [[ CapturePoints MISSION 1 ]]
-------------------------------------------------------------------------

function CapturePoints_Setup()
	obj_CapturePoints = {
		OnStart = function()
			enemyFuelUIArrowLeft = Objective_AddUIElements(obj_CapturePoints, eg_enemyFuelPointLeft, true, "Enemy Fuel Tower", true)
			enemyFuelUIArrowRight = Objective_AddUIElements(obj_CapturePoints, eg_enemyFuelPointRight, true, "Enemy Fuel Tower", true)
		end,	
		
		Parent = obj_main,
		Intel_Start = nil,				
		Intel_Complete = nil,
		Intel_Fail = nil,
		Title = "Capture Enemy Fuel Towers",
		Description = nil,
		TitleEnd = "Capture Enemy Fuel Towers",
		TitleFail = nil,
		Type = OT_Primary,
	}
	Objective_Register(obj_CapturePoints)		
end

function CapturePoints_Start()
	UI_SetCPMeterVisibility(false) 
	Event_Timer(EventHandler_ObjectiveStart, {objective = obj_CapturePoints}, 3)

	event_capturePointLeftComplete = Event_PlayerOwnsTerritory(CapturePointLeft_Complete, nil, player1, territory_fuelLeft)
	event_capturePointRightComplete = Event_PlayerOwnsTerritory(CapturePointRight_Complete, nil, player1, territory_fuelRight)
	event_capturePointsComplete = Event_PlayerOwnsTerritory(CapturePoints_Complete, nil, player1, {territory_fuelLeft, territory_fuelRight})

	FuelPoint_Enemies_Initial()

	-- Creates a squad of starting units
	sg_startingSquad = SGroup_CreateIfNotFound("sg_startingSquad")
	-- Util_CreateSquads(player1, sg_startingSquad, BP_GetSquadBlueprint("base_conscript_squad"), mkr_allyEntry, mkr_allyDestination, 1)
	Util_CreateSquads(player1, sg_startingSquad, BP_GetSquadBlueprint("combat_engineer_squad"), mkr_allyEntry, mkr_allyDestination, 1)
end

function FuelPoint_Enemies_Initial()
	sg_fuelSquad = SGroup_CreateIfNotFound("sg_fuelSquad")
	sg_fuelSquadLeft = SGroup_CreateIfNotFound("sg_fuelSquadLeft")
	sg_fuelSquadRight = SGroup_CreateIfNotFound("sg_fuelSquadRight")
	sg_fuelSquadRightMortar = SGroup_CreateIfNotFound("sg_fuelSquadRightMortar")
	sg_fuelSquadTriggerRetaliate = SGroup_CreateIfNotFound("sg_fuelSquadTriggerRetaliate")

	-- Left side encounter
	local encData = {
		player = player2,
		spawn = mkr_fuelSpawnLeft1,
		sgroups = {sg_fuelSquad, sg_fuelPointEnemiesLeft, sg_fuelSquadTriggerRetaliate},
		units = {
			{sbp = SBP.GERMAN.PIONEER_SQUAD,	numSquads = 1,},	
		},
	}
	enc_fuelLeft_pioneer1 = Encounter:Create(encData)
	defendGoal = {
		name = "Defend",
		target = eg_enemyFuelPointLeft,
		range = mkr_fuelRange1,
		leashRange = mkr_fuelLeashRange1,
		garrisonIdle = false,
		garrison = false,
	}
	enc_fuelLeft_pioneer1:SetGoal(defendGoal)

	-- Left side encounter
	local encData = {
		player = player2,
		spawn = mkr_fuelSpawnLeft2,
		sgroups = {sg_fuelSquad, sg_fuelSquadLeft},
		units = {
			{sbp = SBP.GERMAN.PIONEER_SQUAD,	numSquads = 1,},		
		},
	}
	enc_fuelLeft_pioneer2 = Encounter:Create(encData)
	defendGoal = {
		name = "Defend",
		target = mkr_fuelRange2,
		range = mkr_fuelRange2,
		leashRange = mkr_fuelRange2,
		garrisonIdle = false,
		garrison = false,
		pickupWeapons = true,	
		useSkirmishAI = true,
	}
	enc_fuelLeft_pioneer2:SetGoal(defendGoal)

	-- Left side encounter
	local encData = {
		player = player2,
		spawn = mkr_fuelSpawnLeft3,
		sgroups = {sg_fuelSquad, sg_fuelSquadLeft},
		units = {
			{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	numSquads = 1,	},			
		},
	}
	enc_fuelLeft_machinesquad = Encounter:Create(encData)
	defendGoal = {
		name = "Defend",
		target = mkr_fuelSpawnLeft3,
		range = mkr_fuelSpawnLeft3,
		leashRange = mkr_fuelSpawnLeft3,
		garrisonIdle = false,
		garrison = false,
		pickupWeapons = true,	
	}
	enc_fuelLeft_machinesquad:SetGoal(defendGoal)

	-- Right side encounter
	local encData = {
		player = player2,
		spawn = mkr_fuelSpawnRight1,
		sgroups = {sg_fuelSquad, sg_fuelSquadRight},
		units = {
			{sbp = SBP.GERMAN.PIONEER_SQUAD,	numSquads = 1,	veterancyRank = 1},	
		},
	}
	enc_fuelRight_pioneersquad = Encounter:Create(encData)
	defendGoal = {
		name = "Defend",
		target = mkr_fuelRangeRight1,
		range = mkr_fuelRangeRight1,
		leashRange = mkr_fuelLeashRangeRight1,
		garrisonIdle = false,
		garrison = false,
		pickupWeapons = false,	
		useSkirmishAI = true,
	}
	enc_fuelRight_pioneersquad:SetGoal(defendGoal)

	-- Right side encounter
	local encData = {
		player = player2,
		spawn = mkr_fuelSpawnRight2,
		sgroups = {sg_fuelSquad, sg_fuelSquadRight},
		units = {
			{sbp = SBP.GERMAN.PIONEER_SQUAD,	numSquads = 1,	veterancyRank = 1},	
		},
	}
	enc_fuelRight_pioneersquad2 = Encounter:Create(encData)
	defendGoal = {
		name = "Defend",
		target = mkr_fuelRangeRight2,
		range = mkr_fuelRangeRight2,
		leashRange = mkr_fuelLeashRangeRight2,
		garrisonIdle = false,
		garrison = false,
		pickupWeapons = false,		
		useSkirmishAI = true,
	}
	enc_fuelRight_pioneersquad2:SetGoal(defendGoal)

	-- Right side encounter
	local encData = {
		player = player2,
		spawn = mkr_fuelSpawnRight3,
		sgroups = {sg_fuelSquad, sg_fuelSquadRight, sg_fuelSquadRightMortar},
		units = {
			{sbp = SBP.GERMAN.MORTAR_TEAM_81MM,	numSquads = 1,	},	
		},
	}
	enc_fuelRight_mortarsquad = Encounter:Create(encData)
	defendGoal = {
		name = "Defend",
		target = mkr_fuelRangeRight3,
		range = mkr_fuelRangeRight3,
		leashRange = mkr_fuelRangeRight3,
		garrisonIdle = false,
		garrison = false,
		pickupWeapons = false,	
		useSkirmishAI = true,
	}
	enc_fuelRight_mortarsquad:SetGoal(defendGoal)

	-- creates an event
	Event_Proximity(FuelLeftRetaliate_EncounterEvent, nil, player1, mkr_leftRetaliateSpawn, 9, ANY, 7)
	Event_GroupIsDead(FuelRightRetaliate_EncounterEvent, nil, sg_fuelSquadRightMortar, 5)
	-- Event_EncounterIsDead(FuelRightRetaliate_EncounterEvent, nil, enc_fuelRight_mortarsquad, 7)
end

function FuelLeftRetaliate_EncounterEvent()

	local encData = {
		player = player2,
		spawn = mkr_fuelSpawnLeftSquadCar,
		sgroups = {sg_fuelSquad, sg_fuelSquadLeft},
		units = {
			{sbp = SBP.GERMAN.PIONEER_SQUAD,	numSquads = 1,},
			{sbp = SBP.GERMAN.PIONEER_SQUAD,	numSquads = 1,},
		},
	}
	enc_fuelLeft_Retaliate = Encounter:Create(encData)

	Cmd_AttackMove(sg_fuelSquadLeft, mkr_fuelLeashRange1)

	local goalData = {
		name = "Attack",
		target = mkr_fuelLeashRange1,
		range = 30,
		leashRange = 22,
		tacticCloseGround = true,
		tacticTargetPreference = AITacticTargetPreference_LowHealth,
		maxAttackers = 2,
		coordinatedSetup = false,
	}
	enc_fuelLeft_Retaliate:SetGoal(goalData)
end

function FuelRightRetaliate_EncounterEvent()
	sg_retaliateFuelRight = SGroup_CreateIfNotFound("sg_retaliateFuelRight")

	local encData = {
		player = player2,
		spawn = mkr_fuelSpawnRightRetaliate,
		sgroups = {sg_fuelSquad, sg_fuelSquadRight, sg_retaliateFuelRight},
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	numSquads = 1,	veterancyRank = 1},	
		},
	}
	enc_fuelRight_Retaliate = Encounter:Create(encData)

	Cmd_AttackMove(sg_retaliateFuelRight, eg_enemyFuelPointRight)

	local goalData = {
		name = "Attack",
		target = mkr_fuelSpawnRight3,
		range = 30,
		leashRange = 22,
		tacticCloseGround = true,
		tacticTargetPreference = AITacticTargetPreference_Near,
		maxAttackers = 2,
		coordinatedSetup = false,
		garrisonIdle = false,
		garrison = false,
		pickupWeapons = false,	
	}
	enc_fuelRight_Retaliate:SetGoal(goalData)
end

function CapturePointLeft_Complete()
	Objective_RemoveUIElements(obj_CapturePoints, enemyFuelUIArrowLeft)
	CapturedLeftFuel_EncounterEvent()
end

function CapturedLeftFuel_EncounterEvent()
	eg_garrisonFuelLeft = EGroup_CreateIfNotFound("eg_garrisonFuelLeft")

	local encData = {
		player = player2,
		spawn = mkr_capturedRetaliateSpawn,
		sgroups = {sg_fuelSquad, sg_fuelSquadLeft},
		units = {
			{sbp = SBP.GERMAN.PIONEER_SQUAD,	numSquads = 2,},	
			{sbp = SBP.GERMAN.PIONEER_SQUAD,	numSquads = 1, veterancyRank = 1},	
		},
	}
	enc_fuelLeftCaptured_Retaliate = Encounter:Create(encData)

	Cmd_AttackMove(sg_fuelSquadLeft, mkr_capturedRetaliateMove)

	local goalData = {
		name = "Attack",
		target = mkr_fuelSpawnLeft1,
		range = mkr_capturedRetaliateSpawn,
		leashRange = 22,
		tacticTargetPreference = AITacticTargetPreference_LowHealth,
		maxAttackers = 2,
		coordinatedSetup = false,
	}
	enc_fuelLeftCaptured_Retaliate:SetGoal(goalData)
end

function CapturePointRight_Complete()
	Objective_RemoveUIElements(obj_CapturePoints, enemyFuelUIArrowRight)
end

function CapturePoints_Complete()
	Objective_Complete(obj_CapturePoints)
	DestroyTanks_Start()
end

-------------------------------------------------------------------------
-- [[ Destroy Tanks MISSION 2 ]]
-------------------------------------------------------------------------

function DestroyTanks_Setup()
	obj_MoveUp = {
		Parent = obj_main,
		Intel_Start = nil,				
		Intel_Complete = nil,
		Intel_Fail = nil,
		Title = "Move into town",
		Description = nil,
		TitleEnd = "Move into town",
		TitleFail = nil,
		Type = OT_Primary,
	}
	Objective_Register(obj_MoveUp)

	obj_DestroyTanks = {
		Parent = obj_main,
		Intel_Start = nil,				
		Intel_Complete = nil,
		Intel_Fail = nil,
		Title = "Destroy the enemy tank",
		Description = nil,
		TitleEnd = "Destroy all enemy tanks",
		TitleFail = nil,
		Type = OT_Primary,
	}
	Objective_Register(obj_DestroyTanks)	
	
	obj_DefendFuelPoints = {
		OnStart = function()
			protectFuelUIArrowLeft = Objective_AddUIElements(obj_DefendFuelPoints, eg_enemyFuelPointLeft, true, "Protect fuel point", true)
			protectFuelUIArrowRight = Objective_AddUIElements(obj_DefendFuelPoints, eg_enemyFuelPointRight, true, "Protect fuel point", true)
		end,
		Parent = obj_main,
		Intel_Start = nil,				
		Intel_Complete = nil,
		Intel_Fail = nil,
		Title = "Protect fuel points from enemy capture",
		Description = nil,
		TitleEnd = "Protect fuel points from enemy capture",
		TitleFail = nil,
		Type = OT_Primary,
	}
	Objective_Register(obj_DefendFuelPoints)
end

function DestroyTanks_Start()
	-- for debug
	pos_enemyTankSpawnLeft = Marker_GetPosition(mkr_enemyTankSpawnLeft)
	pos_enemyTankSpawnRight = Marker_GetPosition(mkr_enemyTankSpawnRight)

	Event_Timer(EventHandler_ObjectiveStart, {objective = obj_MoveUp}, 3)

	-- adds popcap to allow AT Guns to arrive
	Player_SetPopCapOverride(player1, 50)

	-- Creates SGroup for the anti tank guns
	sg_tankEncounter = SGroup_CreateIfNotFound("sg_tankEncounter")
	sg_finalEncounters = SGroup_CreateIfNotFound("sg_finalEncounters")
	sg_atGun = SGroup_CreateIfNotFound("sg_atGun")
	sg_enemyTanks = SGroup_CreateIfNotFound("sg_enemyTanks")
	sg_enemyTankLeft = SGroup_CreateIfNotFound("sg_enemyTankLeft")
	sg_enemyTankRight = SGroup_CreateIfNotFound("sg_enemyTankLeft")

	moveUpUIArrow = Objective_AddUIElements(obj_MoveUp, mkr_enemyTankLocation, true, "Move forward", true)
	Event_Proximity(MovedUp, nil, player1, mkr_capturedRetaliateSpawn, 9, ANY)

	-- Allows going passed the bridge
	World_IncreaseInteractionStage()
	-- debug_revealFullMap()
end

function MovedUp()
	Objective_Complete(obj_MoveUp)
	table_removeMoveUIArrow = {
		objTable = obj_DestroyTanks,
		elementID = moveUpUIArrow,
	}

	TankEncounters()

	Event_Timer(EventHandler_ObjectiveStart, {objective = obj_DestroyTanks}, 3)
	Event_Timer(EventHandler_ObjectiveStart, {objective = obj_DefendFuelPoints}, 8)
	Event_Timer(Objective_RemoveUIElements, table_removeMoveUIArrow, 3)

	Event_GroupIsDead(DestroyTanks_Complete, nil, sg_enemyTanks, 3)
	Event_PlayerOwnsTerritory(MissionFailed, nil, player2, {territory_fuelLeft, territory_fuelRight}, ANY)
end

function TankEncounters()
	SpawnATGun()
	TankInitialEncounter()
end

function TankInitialEncounter()
	-- Create enemy tanks
	local encData = {
		player = player2,
		spawn = mkr_enemyTankSpawnLeft,
		sgroups = {sg_enemyTanks},
		units = {
			{sbp = SBP.GERMAN.PANZER_IV_SQUAD,	numSquads = 1},	
		},
	}
	tankEncounter = Encounter:Create(encData)

	Cmd_AttackMove(sg_enemyTanks, mkr_tankMoveTo)

	local goalData = {
		name = "Attack",
		target = mkr_tankRange,
		range = mkr_tankRange,
		leashRange = 40,
	}
	tankEncounter:SetGoal(goalData)

	tankFullHealth = SGroup_GetAvgHealth(sg_enemyTanks)
	tankThreeQuartsHealth = SGroup_GetAvgHealth(sg_enemyTanks) * 0.75
	tankHalfHealth = SGroup_GetAvgHealth(sg_enemyTanks) * 0.5
	tankThirdishHealth = SGroup_GetAvgHealth(sg_enemyTanks) * 0.35
	Event_OnHealth(TankHealthBelowMax_Encounter, nil, sg_enemyTanks, tankThreeQuartsHealth, false)
	Event_OnHealth(TankHealthHalf_Encounter, nil, sg_enemyTanks, tankHalfHealth, false)
end

function TankHealthBelowMax_Encounter()
	-- Rule_AddInterval(TankRightEncounter, 12)
	Util_NewHUDFeatureEvent(HUDF_CommandCard, "Enemies are attacking your left fuel point, use your units to defend!", "Empty", 8)
	-- TankRightEncounter()

	local encData = {
		player = player2,
		spawn = mkr_fuelSpawnLeftSquadCar,
		sgroups = {sg_tankEncounter, sg_finalEncounters},
		units = {
			{sbp = SBP.GERMAN.GRENADIER_SQUAD,	numSquads = 1,},
		},
	}
	enc_fuelLeft_Retaliate = Encounter:Create(encData)

	Cmd_AttackMove(sg_tankEncounter, mkr_fuelLeashRange1)

	local goalData = {
		name = "Attack",
		target = mkr_fuelLeashRange1,
		range = 30,
		leashRange = 22,
		tacticControlsList = {
			{
				tacticType = TACTIC_CapturePoint,
				priority = 1,
				maxUsers = 4,
				maxRange = 5,
				waitTimeSecs = 6,
			},
		},
		tacticTargetPreference = AITacticTargetPreference_LowHealth,
		maxAttackers = 3,
		coordinatedSetup = false,
		garrisonIdle = false,
		garrison = false,
		pickupWeapons = false,	
	}
	enc_fuelLeft_Retaliate:SetGoal(goalData)
end

function TankHealthHalf_Encounter()
	TankRightEncounter()
	Util_NewHUDFeatureEvent(HUDF_CommandCard, "Enemies are attacking your right fuel point, use your units to defend!", "Empty", 8)

	-- local encData = {
	-- 	player = player2,
	-- 	spawn = mkr_fuelSpawnLeftSquadCar,
	-- 	sgroups = {sg_tankEncounter2},
	-- 	units = {
	-- 		{sbp = SBP.GERMAN.GRENADIER_SQUAD,	numSquads = 1,},
	-- 		{sbp = SBP.GERMAN.PIONEER_SQUAD,	numSquads = 1, spawn = mkr_tankEncounterSpawning},
	-- 	},
	-- }
	-- enc_fuelLeft_Retaliate2 = Encounter:Create(encData)

	-- Cmd_AttackMove(sg_tankEncounter2, mkr_fuelLeashRange1)

	-- local goalData = {
	-- 	name = "Attack",
	-- 	target = mkr_fuelLeashRange1,
	-- 	range = 30,
	-- 	leashRange = 22,
	-- 	tacticControlsList = {
	-- 		{
	-- 			tacticType = TACTIC_CapturePoint,
	-- 			priority = 1,
	-- 			maxUsers = 4,
	-- 			maxRange = 5,
	-- 			waitTimeSecs = 6,
	-- 		},
	-- 	},
	-- 	tacticTargetPreference = AITacticTargetPreference_LowHealth,
	-- 	maxAttackers = 3,
	-- 	coordinatedSetup = false,
	-- 	garrisonIdle = false,
	-- 	garrison = false,
	-- 	pickupWeapons = false,	
	-- }
	-- enc_fuelLeft_Retaliate2:SetGoal(goalData)
end

function TankRightEncounter()
	local encData = {
		player = player2,
		spawn = mkr_fuelSpawnRightRetaliate,
		sgroups = {sg_fuelSquad, sg_finalEncounters},
		units = {
			{sbp = SBP.GERMAN.PIONEER_SQUAD,	numSquads = 1, spawn = mkr_tankEncounterSpawning},	
		},
	}
	enc_fuelRight_Tank = Encounter:Create(encData)

	Cmd_AttackMove(sg_fuelSquad, eg_enemyFuelPointRight)

	local goalData = {
		name = "Attack",
		target = mkr_fuelSpawnRight3,
		range = 30,
		leashRange = 22,
		tacticControlsList = {
			{
				tacticType = TACTIC_CapturePoint,
				priority = 1,
				maxUsers = 4,
				maxRange = 5,
				waitTimeSecs = 6,
			},
		},
		tacticTargetPreference = AITacticTargetPreference_Near,
		maxAttackers = 2,
		coordinatedSetup = false,
		garrisonIdle = false,
		garrison = false,
		pickupWeapons = false,	
	}
	enc_fuelRight_Tank:SetGoal(goalData)

	Event_GroupIsDead(DefendFuelPoints_Complete, nil, sg_finalEncounters, 3)
end

function SpawnATGun()
	-- Creates a squad of anti tank guns
	Util_CreateSquads(player1, sg_atGun, BP_GetSquadBlueprint("m1937_53-k_45mm_at_gun_squad"), mkr_allyEntry, mkr_allyDestination, 1)
	SGroup_SetTeamWeaponCapturable(sg_atGun, false)
	atGunArrivedArrow = Objective_AddUIElements(obj_DestroyTanks, sg_atGun, true, "Anti-Tank Gun", true)

	Event_IsSelected(ATTankSelected, nil, sg_atGun)

	-- Rule_AddInterval(IsAnotherATGunDead, 3)
end

function ATTankSelected()
	Objective_RemoveUIElements(obj_DestroyTanks, atGunArrivedArrow)
end

function DestroyTanks_Complete()
	Objective_Complete(obj_DestroyTanks)

	if Objective_IsComplete(obj_DefendFuelPoints) == true then
		MissionComplete()
	end
end

function DefendFuelPoints_Complete()
	Objective_RemoveUIElements(obj_DefendFuelPoints, protectFuelUIArrowLeft)
	Objective_RemoveUIElements(obj_DefendFuelPoints, protectFuelUIArrowRight)
	Objective_Complete(obj_DefendFuelPoints)

	if Objective_IsComplete(obj_DestroyTanks) == true then
		MissionComplete()
	end
end
-- MissionComplete()
-------------------------------------------------------------------------
-- [[ UTILITY FUNCTIONS]]
-------------------------------------------------------------------------
function debug_revealFullMap()
	FOW_PlayerRevealArea(player1, pos_enemyTankSpawnLeft, 200, -1)
	FOW_PlayerRevealArea(player1, pos_enemyTankSpawnRight, 200, -1)
end

function Debug_SetATGunHealthZero()
	if(SGroup_CountSpawned(sg_atGun) > 0) then
		local squad = SGroup_GetSpawnedSquadAt(sg_atGun, 1)
		for i=0, Squad_Count(squad)-1 do
			local entity = Squad_EntityAt(squad, i)
			if(Entity_GetHealth(entity) <= 0 and Entity_GetBlueprint(entity) == EBP.SOVIET.M1937_53_K_45MM_AT_GUN) then
				Entity_SetHealth(entity, 0)
				break
			end
		end
	end
end






-- function IsAnotherATGunDead()
-- 	if(SGroup_CountSpawned(sg_atGun) > 0) then
-- 		local squad = SGroup_GetSpawnedSquadAt(sg_atGun, 1)
-- 		for i=0, Squad_Count(squad)-1 do
-- 			local entity = Squad_EntityAt(squad, i)
-- 			if(Entity_GetHealth(entity) <= 0 and Entity_GetBlueprint(entity) == EBP.SOVIET.M1937_53_K_45MM_AT_GUN) then
-- 				Event_Timer(SpawnATGun, nil, 3)
-- 				Rule_Remove(IsAnotherATGunDead)
-- 				break
-- 			end
-- 		end
-- 	end
-- end

-- function TankThirdHealthEncounter()
-- end

-- function TankQuarterHealthEncounter()
-- end