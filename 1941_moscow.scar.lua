-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- THEATRE OF WAR - 1941 - Moscow
-- Designer: NJR
-- 
-- 
-------------------------------------------------------------------------
-------------------------------------------------------------------------
import("ScarUtil.scar")
import("TheatreOfWar.scar")
import("Systems/AiManager/ai.scar")
import("Systems/BlizzardMulitplayer.scar")

g_isWinterMap = true

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------

function OnGameSetup()
	
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = Setup_Player(3, 11039129, "german", 2) -- LOCDB [11039129] '2nd Panzer Army'
	player4 = Setup_Player(4, 11039129, "german", 2) -- LOCDB [11039129] '2nd Panzer Army'

end



function OnGameRestore()
	
	-- function takes care of restoring all global mission parameters after a save/load
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	player4 = World_GetPlayerAt(4)
	
	Game_DefaultGameRestore()
	
end


-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------

function OnInit()

	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	eg_temp = EGroup_CreateIfNotFound("eg_temp")
	sg_blah = SGroup_CreateIfNotFound("sg_blah")
	eg_blah = EGroup_CreateIfNotFound("eg_blah")
	
	sg_e_riverwest = SGroup_CreateIfNotFound("sg_e_riverwest")
	sg_e_rivereast = SGroup_CreateIfNotFound("sg_e_rivereast")
	sg_e_patrolriverwest = SGroup_CreateIfNotFound("sg_e_patrolriverwest")
	sg_e_patrolrivereast = SGroup_CreateIfNotFound("sg_e_patrolrivereast")
	sg_e_bridgehead = SGroup_CreateIfNotFound("sg_e_bridgehead")
	sg_e_yard = SGroup_CreateIfNotFound("sg_e_yard")
	sg_e_spit1 = SGroup_CreateIfNotFound("sg_e_spit1")
	sg_e_spit2 = SGroup_CreateIfNotFound("sg_e_spit2")
	sg_e_counterattack = SGroup_CreateIfNotFound("sg_e_counterattack")

	sg_rivertargets = SGroup_CreateIfNotFound("sg_rivertargets")
	
	
	--
	-- Get the player data
	--
	print("1: ".. Player_GetRaceName(player1) .. " ... Human:".. tostring(Player_IsHuman(player1)).. "  AIPlayer:".. tostring(AI_IsAIPlayer(player1)).."/Enabled:".. tostring(AI_IsEnabled(player1)))
	print("2: ".. Player_GetRaceName(player2) .. " ... Human:".. tostring(Player_IsHuman(player2)).. "  AIPlayer:".. tostring(AI_IsAIPlayer(player2)).."/Enabled:".. tostring(AI_IsEnabled(player2)))
	print("3: ".. Player_GetRaceName(player3) .. " ... Human:".. tostring(Player_IsHuman(player3)).. "  AIPlayer:".. tostring(AI_IsAIPlayer(player3)).."/Enabled:".. tostring(AI_IsEnabled(player3)))
	print("4: ".. Player_GetRaceName(player4) .. " ... Human:".. tostring(Player_IsHuman(player4)).. "  AIPlayer:".. tostring(AI_IsAIPlayer(player4)).."/Enabled:".. tostring(AI_IsEnabled(player4)))
	
	--
	-- Lock out AI control of certain units for P3 and P4
	--
	if AI_IsEnabled(player3) then
		AI_LockSquads(player3, sg_lockedout_ai)
	end
	if AI_IsEnabled(player4) then
		AI_LockSquads(player4, sg_lockedout_ai)
	end
	
	
	--
	-- Set Restrictions and Difficulty
	--
	Mission_Restrictions()
	Mission_Difficulty()
	SetupAchievements()
	
	local bliz_atmsph = "data:art/scenarios/presets/atmosphere/1941_moscow_blizzard.aps"
	local def_atmsph  = "data:art/scenarios/presets/atmosphere/1941_moscow_snowy.aps"
	
	t_blizzardData = {
		blizzard_interval_first = World_GetRand(60, 120),
		}
	
	MP_BlizzardInit(bliz_atmsph, def_atmsph, true, t_blizzardData)
--~ 	MP_BlizzardInit(bliz_atmsph, def_atmsph)
		
	Cmd_CriticalHit(player1, sg_abandonedvehicles, CRIT.VEHICLE_ABANDON, 1)
	
	Sound_PreCacheSound( "campaign/e3_demo_plash_screen_audio" )	
	
	
	--
	-- All done, let's go...
	--
	
--~ 	Util_PlayMovie("m04-cin02", 0, 2)
	
	Moscow_InitPreplacedUnits()
--~ 	Moscow_InitHowitzers()
	Mission_Start()
end

Scar_AddInit(OnInit)





function Mission_Restrictions()	-- Utilize for setting restrictions on Units, players, etc
	
	-- Set up 1941 Tech Tree
	ToW_SetUpTechTreeByYear(player1, 1941)
	ToW_SetUpTechTreeByYear(player2, 1941)
	ToW_SetUpTechTreeByYear(player3, 1941)
	ToW_SetUpTechTreeByYear(player4, 1941)
	
	Player_SetUpgradeAvailability(player1, UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE, ITEM_REMOVED)
	Player_SetUpgradeAvailability(player2, UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE, ITEM_REMOVED)
	
	ToW_SetStandardResources (player1)
	ToW_SetStandardResources (player2)
	ToW_SetStandardResources (player3)
	ToW_SetStandardResources (player4)
	
end

function Mission_Difficulty()

	if Misc_IsCommandLineOptionSet("easy") then
		g_difficulty = GD_EASY
	elseif Misc_IsCommandLineOptionSet ("hard") then
		g_difficulty = GD_HARD
	else
		g_difficulty = Game_GetSPDifficulty()   
	end
	
		
	_ToWDebugDisplay("Difficulty is " .. g_difficulty, "white")
		
	t_difficulty = {
		
		numFew  = Util_DifVar( { 1, 1, 1, 2}, g_difficulty),
		numSome = Util_DifVar( { 1, 1, 2, 2}, g_difficulty),
		numMany = Util_DifVar( { 1, 2, 2, 2}, g_difficulty),

	}

end


function Mission_Start()

--~ 	local rand = World_GetRand(60, 120)	
--~ 	Rule_AddOneShot(Mission_BlizzardEnd, rand)

	-- stagger the AI's capabilities
	Moscow_AISettings_01()
	Rule_AddOneShot(Moscow_AISettings_02, (4 * 60))
	
	local data = { target = eg_vp1 }
	Event_Timer(Moscow_PointRaid, data, (3 * 60))
	
	Util_StartIntel(EVENTS.Intro)
	ToW_SetUpBattleObjectives ()

end


-------------------------------------------
-------------------------------------------
--
--  Set up Mission Objective
--
-------------------------------------------
-------------------------------------------






-- functions that change AI behaviour during the course of the mission
function Moscow_AISettings_01()

	-- we don't want the AI building tanks too early
	Player_SetEntityProductionAvailability(player3, EBP.GERMAN.HINTERE_PANZERWERK, ITEM_LOCKED)
	Player_SetEntityProductionAvailability(player4, EBP.GERMAN.HINTERE_PANZERWERK, ITEM_LOCKED)
	
	Player_SetEntityProductionAvailability(player3, EBP.GERMAN.SCHWERES_KRIEGSWERK, ITEM_LOCKED)
	Player_SetEntityProductionAvailability(player4, EBP.GERMAN.SCHWERES_KRIEGSWERK, ITEM_LOCKED)

end


function Moscow_AISettings_02()

	Player_SetEntityProductionAvailability(player3, EBP.GERMAN.HINTERE_PANZERWERK, ITEM_DEFAULT)
	Player_SetEntityProductionAvailability(player4, EBP.GERMAN.HINTERE_PANZERWERK, ITEM_DEFAULT)

end





--
-- Set up the pockets of sentry guys which will automatically retreat
--
function Moscow_InitPreplacedUnits()
	
	
	-- Guys defending the river to the west of the bridge
	local RiverWest_EncounterData = {
		name = "RiverWest",
		player = player3,
		spawn = mkr_RiverWest,
		sgroups = {sg_e_riverwest},
		units = {
			{
				name = "REPLACE_NAME",
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				spawn = mkr_RiverWest_Spawn1,
			},
			{
				name = "REPLACE_NAME",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_RiverWest_Spawn2,
				numSquads = t_difficulty.numSome,
			},
		},
		onDeath = nil,
	}
	local RiverWest_GoalData = {
		name = "Defend",
		target = mkr_RiverWest,
		range = 80,
		leashRange = mkr_RiverWest,
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {
			mkr_RiverWest_Direction,
		},
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
			{
				tacticType = TACTIC_Avoid,
				priority = -1,
			},
		},
		fallbackParams = {
			thresholds = {0.5},
			retreat = true,
			retreatOnSuppression = true,
		},
		onFailure = function()
			Util_ReAllowAI(sg_e_riverwest)
		end,
	}
	encID_RiverWest = Encounter:Create(RiverWest_EncounterData)
	encID_RiverWest:SetGoal(RiverWest_GoalData)
	Modify_SightRadius(sg_e_riverwest, 1.5)
	
	
	
	-- Guys defending the river to the east of the bridge (in front of the dockyard)
	local RiverEast_EncounterData = {
		name = "RiverEast",
		player = player4,
		spawn = mkr_RiverEast,
		sgroups = {sg_e_rivereast},
		units = {
			{
				name = "REPLACE_NAME",
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				numSquads = t_difficulty.numSome,
			},
		},
		onDeath = nil,
	}
	local RiverEast_GoalData = {
		name = "Defend",
		target = mkr_RiverEast,
		range = 55,
		leashRange = mkr_RiverEast,
		garrison = true,
		garrisonIdle = true,
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {
			mkr_RiverEast_Direction,
		},
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
			{
				tacticType = TACTIC_Avoid,
				priority = -1,
			},
		},
		useSkirmishAI = true,
		fallbackParams = {
			thresholds = {0.5},
			retreat = true,
			retreatOnSuppression = true,
		},
		onFailure = function()
			Util_ReAllowAI(sg_e_rivereast)
		end,
	}
	encID_RiverEast = Encounter:Create(RiverEast_EncounterData)
	encID_RiverEast:SetGoal(RiverEast_GoalData)
	Modify_SightRadius(sg_e_rivereast, 1.5)
	
	
	
	local RiverEastSpit1_EncounterData = {
		name = "RiverEastSpit1",
		player = player4,
		spawn = mkr_Spit1,
		sgroups = {sg_e_spit1},
		units = {
			{
				name = "REPLACE_NAME",
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
			},
			{
				name = "REPLACE_NAME",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				numSquads = t_difficulty.numSome,
			},
		},
		onDeath = nil,
	}
	local RiverEastSpit1_GoalData = {
		name = "Defend",
		target = mkr_Spit1,
		range = 45,
		leashRange = mkr_Spit1,
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {
			mkr_RiverEast_Direction,
		},
		useSkirmishAI = true,
	}
	encID_Spit1 = Encounter:Create(RiverEastSpit1_EncounterData)
	encID_Spit1:SetGoal(RiverEastSpit1_GoalData)
	Modify_SightRadius(sg_e_spit1, 1.5)
	
	
	local RiverEastSpit2_EncounterData = {
		name = "RiverEastSpit2",
		player = player4,
		spawn = mkr_Spit2,
		sgroups = {sg_e_spit2},
		units = {
			{
				name = "REPLACE_NAME",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				numSquads = t_difficulty.numSome,
			},
		},
		onDeath = nil,
	}
	local RiverEastSpit2_GoalData = {
		name = "Defend",
		target = mkr_Spit2,
		range = 40,
		leashRange = mkr_Spit2,
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {
			mkr_RiverEast_Direction,
		},
		useSkirmishAI = true,
	}
	encID_Spit2 = Encounter:Create(RiverEastSpit2_EncounterData)
	encID_Spit2:SetGoal(RiverEastSpit2_GoalData)
	Modify_SightRadius(sg_e_spit2, 1.5)
	
	
	
	-- guys patrolling the riverbanks
	local PatrolRiverWest_EncounterData = {
		name = "PatrolRiverWest",
		player = player4,
		spawn = mkr_RiverBank_WestVP,
		sgroups = {sg_e_patrolriverwest},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_RiverBank_West1,
				numSquads = t_difficulty.numSome,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_RiverBank_West1,
				numSquads = t_difficulty.numSome,
			},
		},
	}
	local PatrolRiverWest_GoalData = {
		name = "Defend",
		target = mkr_RiverBank_WestVP,
		range = mkr_RiverBank_WestVP,
		useSkirmishAI = true,
		fallbackParams = {
			thresholds = {0.3},
			retreat = true,
			retreatOnSuppression = true,
		},
		onFailure = function()
			Util_ReAllowAI(sg_e_patrolriverwest)
		end,
	}
	encID_PatrolRiverWest = Encounter:Create(PatrolRiverWest_EncounterData)
	encID_PatrolRiverWest:SetGoal(PatrolRiverWest_GoalData)
	Modify_SightRadius(sg_e_patrolriverwest, 1.3)
	
	
	
	local PatrolRiverEast_EncounterData = {
		name = "PatrolRiverEast",
		player = player4,
		spawn = mkr_RiverBank_EastVP,
		sgroups = {sg_e_patrolrivereast},
		units = {
			{
				name = "REPLACE_NAME",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_RiverBank_East1,
				numSquads = t_difficulty.numSome,
			},
			{
				name = "REPLACE_NAME",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_RiverBank_East1,
				numSquads = t_difficulty.numSome,
			},
		},
	}
	local PatrolRiverEast_GoalData = {
		name = "Defend",
		target = mkr_RiverBank_EastVP,
		range = mkr_RiverBank_EastVP,
		useSkirmishAI = true,
		fallbackParams = {
			thresholds = {0.3},
			retreat = true,
			retreatOnSuppression = true,
		},
		onFailure = function()
			Util_ReAllowAI(sg_e_patrolrivereast)
		end,
	}
	encID_PatrolRiverEast = Encounter:Create(PatrolRiverEast_EncounterData)
	encID_PatrolRiverEast:SetGoal(PatrolRiverEast_GoalData)
	Modify_SightRadius(sg_e_patrolrivereast, 1.3)
	
	-- Guys defending the yard
	local Yard_EncounterData = {
		name = "Yard",
		player = player4,
		spawn = mkr_Yard,
		sgroups = {sg_e_yard},
		units = {
			{
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				numSquads = t_difficulty.numMany,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				numSquads = t_difficulty.numMany,
			},
		},
		onDeath = nil,
	}
	local Yard_GoalData = {
		name = "Defend",
		target = mkr_Yard,
		range = 80,
		leashRange = mkr_Yard,
		garrison = true,
		garrisonIdle = true,
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {
			mkr_RiverEast_Direction,
		},
		useSkirmishAI = true,
		fallbackParams = {
			thresholds = {0.5},
			retreat = true,
			retreatOnSuppression = true,
		},
		onFailure = function()
			Util_ReAllowAI(sg_e_yard)
		end,
	}
	encID_Yard = Encounter:Create(Yard_EncounterData)
	encID_Yard:SetGoal(Yard_GoalData)
	
	
	
	
end


function Moscow_PointRaid (data)

	data = data or {}
	data.target = data.target or eg_vp1
	
	local startRaid = false

	if not World_OwnsEGroup(data.target, ALL) then
		if Player_OwnsEGroup(player4, data.target, ALL) then
			Event_Timer(Moscow_PointRaid, data, 120)
			startRaid = false
		end
	end


	sg_transport = SGroup_CreateIfNotFound("sg_transport")
	sg_raiders = SGroup_CreateIfNotFound("sg_raiders")
	
	if not (encID_raiders) then
		startRaid = true
	elseif not encID_raiders:IsAlive() then
		startRaid = true
	end


	if startRaid then
		local encData = {
			player = player4,
			sgroups = {sg_raiders,},
			units = {
				{
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = mkr_raiderSpawn,
					numSquads = 2,
				},
			},
			onDeath = nil,
		}
		encID_raiders = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			target = data.target,
			maxTime = 45,
			onSuccess = function()
				Util_ReAllowAI(sg_raiders)
				Event_Timer(Moscow_PointRaid, data, 120)
			end,
			onFailure = function()
				Util_ReAllowAI(sg_raiders)
				Event_Timer(Moscow_PointRaid, data, 120)
			end,
			
		}
		encID_raiders:SetGoal(goalData)
	end
end

function Util_ReAllowAI(group)
	if AI_IsEnabled(player3) then
		AI_UnlockSquads(player3, group)
	end
	if AI_IsEnabled(player4) then
		AI_UnlockSquads(player4, group)
	end
end

function Achieve(data)
	if scartype (data) == ST_STRING then
		data = { id = data }
	end
	_ToWDebugDisplay("ACHIEVEMENT: " .. data.id, "gold")
	Scar_CompleteIntelBulletinTask(player1, data.id)
	if not AI_IsEnabled(player2) then
		Scar_CompleteIntelBulletinTask(player2, data.id)
	end
end

function SetupAchievements()
	g_halftrackCount = 0
	g_campfireCount = 0
	sg_halftracks = SGroup_CreateIfNotFound("sg_halftracks")
	Rule_AddDelayedInterval(AchievementCheck, 3, 1)
	Rule_AddGlobalEvent(CountCampfires, GE_ConstructionComplete)
	
end

function CountHalftracks(sgroup, index, squad)	
	if not SGroup_ContainsSquad(sg_halftracks, Squad_GetGameID(squad)) then
		g_halftrackCount = g_halftrackCount + 1
		SGroup_Add(sg_halftracks, squad)
	end
end

function AchievementCheck()
	Player_GetAll(player1)
	SGroup_Filter(sg_allsquads, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, FILTER_KEEP)
	SGroup_ForEach(sg_allsquads, CountHalftracks)
	Player_GetAll(player2)
	SGroup_Filter(sg_allsquads, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, FILTER_KEEP)
	SGroup_ForEach(sg_allsquads, CountHalftracks)
	if g_halftrackCount >= 3 then
		Achieve ("tow_general_winter_halftracked")
		Rule_RemoveMe()
	end
end

function CountCampfires (player, ebp)
	_ToWDebugDisplay("CountCampfires: " .. BP_GetName(ebp))

	if BP_GetName(ebp) == "buildable_campfire_mp" then
		g_campfireCount = g_campfireCount + 1
	end
	
	if g_campfireCount >= 10 then
		Achieve("tow_general_winter_cookout")
		Rule_RemoveMe()
	end

end


