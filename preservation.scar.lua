print("\tLoading mission file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Preservation
-- Designer: Darwin Yuen
-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScriptSetup.scar") -- <== ### CRITICAL ELEMENT. 
import("XP1.scar")				-- Ardennes Assault functionality
import("WinConditions/AABattle_VictoryPointPlusAnnihilate.scar")

-- [[ Objective files ]]
import("Preservation_obj_VICTORY.scar")
import("XP1_NarrativeObj.scar")

-- [[ Encounter data ]]



-------------------------------------------------------------------------
-- [[ MISSION SETUP ]]
-------------------------------------------------------------------------
-- Initializes players
function Mission_SetupPlayers()
	-- Not used in battles
end

function Override_Player_Setup()
--~ 	local playerCount = World_GetPlayerCount()
--~ 	
--~ 	for i = 1, playerCount do
--~ 		local index = i
--~ 		if Player_IsHuman(World_GetPlayerAt(index)) then
--~ 			player1 = World_GetPlayerAt(index)
--~ 		end
--~ 		
--~ 	end
--~ 	
--~ 	if player1 ~= nil then
--~ 		for i = 1, playerCount do
--~ 			local index = i
--~ 			if World_GetPlayerAt(index) ~= player1 then
--~ 				if Player_IsAllied(player1, World_GetPlayerAt(index)) then
--~ 					print("test")
--~ 					player3 = World_GetPlayerAt(index)
--~ 				else
--~ 					player2 = World_GetPlayerAt(index)
--~ 				end
--~ 			end
--~ 		end
--~ 	end
	
	local playerCount = World_GetPlayerCount()
	
	for i = 1, playerCount do
		local index = i
		if Player_IsHuman(World_GetPlayerAt(index)) then
			player1 = World_GetPlayerAt(index)
		else
			player2 = World_GetPlayerAt(index)
		end
	end

	
	--player3 = Setup_Player(3, 11038759, "aef", 1)
end

-- Defines key mission data and any global values used throughout the mission.
function Mission_SetupVariables()
	print("Initializing mission DATA...")
	print("LOADING BATTLE: Preservation")
	

	if Marker_Exists("mkr_mapidentifier_marche", "") then	-- add some extra stuff to do with beginner hints IF and ONLY IF we are playing on Marche
		import("Libraries/BattleExtras/XP1_Marche_BeginnerHintSetup.scar")
		Marche_StartUpBeginnerHints("Preservation")
	end
	
	
	--TODO: Define mission initialization data. Example in comments on the bottom of this file.
	-- ### CRITICAL ELEMENT. This table contains all the initialization data for the mission.
	g_missionData = {
		useBeginnerHints = false,					-- Wether or not to use the BeginnerHint system
		useEncounterSystem = true,					-- Whether or not to use the Encounter system
		useXP1Difficulty = true,					-- Whether or not this mission uses the XP1 Difficulty system
		missionType = MT_XP1_BATTLE,					-- What Mission Type is this mission? MT_
		introNIS = nil,			 					-- Movie filename
		introNISlet = nil,					 		-- NISlet triggered after introNIS
		introNISletSkipped = nil,	 				-- Function called if the introNISlet is skipped
		introSitRep = nil,							-- Movie (string) to play after intro nislet
		endNISlet = nil,							-- NISlet triggered on mission completion
		endNIS = nil,								-- Movie (string) to play on mission completion
		missionSpeechPath = "botb/gameplay",					-- Speech path to cache (string)
		precacheSounds = {							-- Any audio files you want precached (list of strings)
		},
		nisFiles = {								-- .nis files associated with the mission (path string)
		},
		nisInTransitionTime = 0,
		nisOutTransitionTime = 0,
		objectives = {								-- List of PARENT objective tables.
			OBJ_Victory,							-- These are the global references to the objective tables defined in the separete files.
		},
		--atmosphere = "_m03_moscow_outskirts.aps",
		startingUnits = {							-- Units to be spawned for P1 on mission start. Follows same parameters as Encounters.

		},
	}
	
--~ 	PM_PL_StartingVP = true
--~ 	PM_PL_StartingResourceHit = true
	
	--[[GLOBAL VARIABLES]]
	
	t_escortSquadInfo = {
		{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, slotItem = nil},
		{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, slotItem = nil},
		{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, slotItem = nil},
		{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, slotItem = nil},
		{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, slotItem = nil},	
	}
	--[[MAP GROUPS]]

	eg_mines = EGroup_CreateIfNotFound("eg_mines") ----------------e group for mines---------------------------------------------
	eg_bunkers = EGroup_CreateIfNotFound("eg_bunkers") ----------------e group for bunkers---------------------------------------------
	
	sg_officer = SGroup_CreateIfNotFound("sg_officer")
	sg_escort = SGroup_CreateIfNotFound("sg_escort")
	sg_escort2 = SGroup_CreateIfNotFound("sg_escort2")
	sg_toBeFollowedByOfficer = SGroup_CreateIfNotFound("sg_toBeFollowedByOfficer")
	sg_ambulance = SGroup_CreateIfNotFound("sg_ambulance")
	sg_already_vet = SGroup_CreateIfNotFound("sg_already_vet")		-- group for units we have already given veterancy to
	sg_sniper = SGroup_CreateIfNotFound ("sg_sniper")
	sg_howitzer = SGroup_CreateIfNotFound ("sg_howitzer")
	
	tmr_manpowerTimer = "tmr_manpowerTimer"
	
	g_grantTime = 300 -- default in case no value entered
	g_decreaseTime = 150 -- amount of time taken off of g_grantTime when a decrease occurs after the death of an officer
	
end

-- Defines difficulty tables/tuning variables
function Mission_SetDifficulty(diffVal)
	--TODO: Define any difficulty-related settings or variables.
	-- These variables should be stored in a t_difficulty table for readability and access.
	
	g_difficulty = diffVal or Game_GetSPDifficulty() 	-- Note: Having the diffVal parameter allows for redefining difficulty settings during runtime.
	AI_OverrideDifficulty(g_difficulty)
	
	--Global difficulty table
	t_difficulty = {						-- Easy, Medium, Hard
		manpowerReward 		 	= Util_DifVar( {1000, 900, 750} ),
		enemyManpowerReward 	= Util_DifVar( {250, 350, 450} ),
		officerReward 		 	= Util_DifVar( {500, 400, 300} ),
		injectionInterval			= Util_DifVar( {240, 300, 360}), -- time between resource injections
		--munitionsReward 		 = Util_DifVar( {40, 30, 20} ),
		--fuelReward 				 = Util_DifVar( {80, 50, 20} ),
		
	}
	
	
	Player_SetResource(player1, RT_Manpower, t_difficulty.manpowerReward)
	--Player_SetResource(player2, RT_Manpower, t_difficulty.manpowerReward)
	
	Modify_PlayerResourceRate(player1, RT_Manpower, 0)
	--Modify_PlayerResourceRate(player2, RT_Manpower, 0)
	PM_AI_Aggression = true
	PM_PL_StartingResourceHit = true
	PM_AI_BaseDefenses = true
	
end

-- Sets restrictions on units, teams, etc.
function Mission_SetupRestrictions()
	--TODO: Set any tech/ability restrictions on a players, as well as resource limits.
	--	Note: Resource Income/Caps should be defined in Mission_SetDifficulty()
	
	--[[ HUMAN PLAYER ]]
--~ 	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.IS_2_HEAVY_TANK, ITEM_REMOVED)
	
	--[[ ALLIED PLAYER ]]
	
	--[[ ENEMY PLAYER ]]
	
end

-- Sets up the map before the mission starts (starting units, ownership, etc.)
function Mission_Preset()

	
end


-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
--Called once the intro nis/nislet/sitrep finishes playing.
function Mission_Start()	
		
	-- default to gold success level
	XP1_SetMissionSuccessLevel(3)
	
	AI_SetPersonality(player2, "botb_skirmish_preservation")
	g_grantTime = t_difficulty.injectionInterval -- grabs the current injection interval that depends on game difficulty
	
	-- Start Objectives
	Objective_Start(OBJ_Victory)
	Objective_Start(SOBJ_Manpower, false)
	--Objective_Start(SOBJ_VictoryPoints, false)
	--Objective_Start(SOBJ_OfficerPoints, true)
	
	--Rule_AddGlobalEvent(Officer_Bounty, GE_EntityKilled)
	Rule_AddGlobalEvent(Officer_Bounty, GE_EntityKilled)
	Rule_AddOneShot(Enemy_Officer_Spawn, 60)
	Util_StartIntel(EVENTS.Mission_Start)
	Util_CreateSquads(player1, sg_ambulance, SBP.AEF.DODGE_WC51_AMBULANCE_SQUAD_MP, mkr_preservationAmbulanceSpawn)
	
	
	-- grant veterancy to all units the ai produces based on node strength
	Rule_AddInterval(GrantEnemyVeterancy, 1)
	
	Support() ------grants different support units based on node strength
	
	--Heavy Tank call in group-----------------------------------
	Rule_AddInterval(Tank_Attack_1, 1)
	

	
	NodeUnitRestrictions1() ----restricts certain ai units at different node strengths
	
	-- start checking if game is over so we can update success level
	Rule_AddInterval(CalculateMissionScore, 1)
	
	
	if g_difficulty == GD_HARD then
	
		Rule_AddOneShot(HardElements0, 30)
		Rule_AddOneShot(HardElements1, 300)
		Rule_AddOneShot(HardElements2, 600)
		Rule_AddOneShot(HardElements3, 900)

	end
	
	
	
end


function ManpowerGrant()
	
	if math.floor(Timer_GetElapsed(tmr_manpowerTimer)) >= g_grantTime or g_restartManpowerTimer == true then
		Util_MissionTitle(Loc_FormatText(11076795, Loc_ConvertNumber(t_difficulty.manpowerReward)))		-- LOCDB [11076795] '%1REWARD% Manpower granted'
		Event_NarrativeEventsNotRunning(Manpower_Grant_Speech, {}, 4)
		Player_AddResource(player1, RT_Manpower, t_difficulty.manpowerReward)
		--Player_AddResource(player2, RT_Manpower, t_difficulty.enemyManpowerReward) -- bonus enemy gets as well
		Timer_End(tmr_manpowerTimer)
		Timer_Start(tmr_manpowerTimer, g_grantTime)	
		g_restartManpowerTimer = false
		
		flashid_manpower = UI_FlashResourceItem(RUIITEM_Manpower)
		Rule_AddOneShot(ManpowerGrant_PartB, 3)
	end
	
end
function ManpowerGrant_PartB()
	UI_StopFlashing(flashid_manpower)
end



function Manpower_Grant_Speech()

	Util_StartIntel(EVENTS.Manpower_Increase)
end

function Enemy_Officer_SpawnCheck()
	if SGroup_IsAlive(sg_officer) == false then

		Rule_AddOneShot(Enemy_Officer_Spawn, 60)
		Rule_RemoveMe()
	end
end
function Enemy_Officer_Spawn()
	

	nodeStrength = XP1_GetNodeStrength()
	
	Util_MissionTitle(11075848)           -- LOCDB [11075848] 'An Enemy Officer has arrived in the area!'
	Event_NarrativeEventsNotRunning(Enemy_Officer_Dialogue, {}, 4)
	Util_CreateSquads(player2, sg_officer, SBP.WEST_GERMAN.TERROR_OFFICER_SQUAD_MP, mkr_preservationOfficerSpawn)
	Util_CreateSquads(player2, sg_escort, t_escortSquadInfo[nodeStrength].sbp, mkr_preservationOfficerSpawn)
--~ 	SGroup_AddGroup(sg_toBeFollowedByOfficer, sg_escort)
--~ 	Util_CreateSquads(player2, sg_escort2, t_escortSquadInfo[nodeStrength].sbp, mkr_preservationOfficerSpawn)
--~ 	SGroup_AddGroup(sg_toBeFollowedByOfficer, sg_escort2)
	
	AI_UnlockSquads(player2, sg_escort)
	AI_LockSquads(player2, sg_officer)
	--AI_LockSquads(player2, sg_escort2)
	
	--if t_escortSquadInfo[nodeStrength].veterancy ~= nil and t_escortSquadInfo[nodeStrength].veterancy > 0 then
		
		SGroup_IncreaseVeterancyRank(sg_escort, XP1_GetNodeStrengthVeterancy(), true)
		SGroup_IncreaseVeterancyRank(sg_officer, XP1_GetNodeStrengthVeterancy(), true)
	--end
	
	if t_escortSquadInfo[nodeStrength].slotItem ~= nil then
		Squad_GiveSlotItem(SGroup_GetSpawnedSquadAt(sg_escort, 1), t_escortSquadInfo[nodeStrength].slotItem) -- adds item
		Squad_AddSlotItemToDropOnDeath(SGroup_GetSpawnedSquadAt(sg_escort, 1), t_escortSquadInfo[nodeStrength].slotItem, 0.5, true) -- percentage chance the SGroup will drop this item when dead	
	end
	if t_escortSquadInfo[nodeStrength].slotItem ~= nil then
	--	Squad_GiveSlotItem(SGroup_GetSpawnedSquadAt(sg_escort2, 1), t_escortSquadInfo[nodeStrength].slotItem) -- adds item
	--	Squad_AddSlotItemToDropOnDeath(SGroup_GetSpawnedSquadAt(sg_escort2, 1), t_escortSquadInfo[nodeStrength].slotItem, 0.5, true) -- percentage chance the SGroup will drop this item when dead	
	end
	
	officerBlip = UI_CreateMinimapBlip(Marker_GetPosition(mkr_preservationOfficerSpawn), 15, BT_General)
	if Rule_Exists(Enemy_Officer_Escort_Mover) == false then
	
		Rule_AddDelayedInterval(Enemy_Officer_Escort_Mover,1, 3)
	
	end
	
	if Rule_Exists(Enemy_Officer_Behaviour) == false then
	
		Rule_AddDelayedInterval(Enemy_Officer_Behaviour,2, 3)
	
	end
	
		if Rule_Exists(Enemy_Escort_Behaviour) == false then
	
		Rule_AddDelayedInterval(Enemy_Escort_Behaviour,3, 3)
	
	end
	
	
	if Objective_IsStarted(SOBJ_OfficerPoints) == false then
		Objective_Start(SOBJ_OfficerPoints, true)
	end
	
end

function Enemy_Officer_Dialogue()

	Util_StartIntel(EVENTS.Officer_Appear)

end

function Enemy_Officer_Escort_Mover()

	if SGroup_IsAlive(sg_escort) == true and SGroup_IsAlive(sg_officer) == true and Prox_SGroupSGroup(sg_escort, sg_officer, PROX_SHORTEST) >= 3 then
		
		Cmd_Move(sg_officer, SGroup_GetPosition(sg_escort), nil, nil, nil, nil, nil, 10)
		
	elseif SGroup_IsAlive(sg_officer) == false then
		
		Rule_RemoveMe()
		
	elseif SGroup_IsAlive(sg_escort) == false then		
		
		AI_UnlockSquads(player2, sg_officer)
		Rule_RemoveMe()
		
	end
	
end

function Enemy_Officer_Behaviour()

	if SGroup_IsAlive(sg_officer) then
	
		local _terrorCount = 0
	
		local _checkOfficer = function(gid, idx, sid)
			
			if Entity_GetBlueprint(Squad_EntityAt(sid, 0)) == EBP.WEST_GERMAN.TERROR_OFFICER_MP then
				_terrorCount = _terrorCount + 1				
			end
		
		end
		
		SGroup_ForEach(sg_officer, _checkOfficer)
		
		if _terrorCount <= 0 then
			
			Cmd_Retreat(sg_officer, mkr_preservationOfficerSpawn, mkr_preservationOfficerSpawn)
			
		end
		
	elseif SGroup_CountSpawned(sg_officer) <= 0 then
	
		Rule_RemoveMe()
	
	end


end

function Enemy_Escort_Behaviour()

	if SGroup_IsEmpty(sg_escort) == false and SGroup_IsAlive(sg_escort) and SGroup_IsAlive(sg_officer) == false then
	
		local tempsquad = SGroup_CreateIfNotFound("tempsquad")
		
		SGroup_AddGroup(tempsquad, sg_escort)		
		SGroup_Clear(sg_escort)
		AI_UnlockSquads(player2, tempsquad)	
		Rule_RemoveMe()
		
		
	elseif SGroup_IsEmpty(sg_escort) or SGroup_IsAlive(sg_escort) == false then
	
		Rule_RemoveMe()
	
	end
end

--~ function Enemy_Officer_Spawn()
--~ 	local Enemy_Officer_EncounterData = {
--~ 		name = "Enemy Officer",
--~ 		player = player2,
--~ 		sgroups = {sg_enemyOfficerGroup},
--~ 		veterancyRank = Util_DifVar({1, 2, 3}),
--~ 		units = {
--~ 			{
--~ 				sbp = SBP.WEST_GERMAN.TERROR_OFFICER_SQUAD_MP,
--~ 				spawn = mkr_preservationEnemyBaseDef_1,
--~ 			},
--~ 						{
--~ 				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
--~ 				spawn = mkr_preservationEnemyBaseDef_1,
--~ 			},


--~ 		},
--~ 		onDeath = nil,
--~ 	}
--~ 	local Base_Defense_AttackData = {
--~ 		name = "Defend",
--~ 		target = mkr_tankHunterEnemyBaseArea,
--~ 		leashRange = 25,
--~ 		range = 45,
--~ 		attackMove = true,
--~ 		useSkirmishAI = true,
--~ 		tacticControlsList = {

--~ 		},
--~ 	}
--~ 	encID_Base_Defense = Encounter:Create(Base_Defense_EncounterData)
--~ 	encID_Base_Defense:SetGoal(Base_Defense_AttackData)
--~ end

		

-- Officer Bounty
-- If player kills a vehicle, grant munitions and fuel
function Officer_Bounty(entityVictim, entityKiller)

	-- make sure everything is valid
	if entityVictim ~= nil and entityKiller ~= nil then
		if Entity_IsValid(Entity_GetGameID(entityVictim)) and Entity_IsValid(Entity_GetGameID(entityKiller)) then
			
			-- make sure that the killer was one of the allies
			if Util_GetPlayerOwner(entityKiller) == player1 or Util_GetPlayerOwner(entityKiller) == player3 then
				
				print("********** Victim: " .. BP_GetName(Entity_GetBlueprint(entityVictim)))
				print("********** Killer: " .. BP_GetName(Entity_GetBlueprint(entityKiller)))
				
				-- check the victim is of the appropriate EBP
				local officerBPs = {"terror_officer_mp"} 
				local victimBP = BP_GetName(Entity_GetBlueprint(entityVictim))
				if Table_Contains(officerBPs, victimBP) then 
					
					-- show a message
					Util_MissionTitle(11075849)           -- LOCDB [11075849] 'Enemy Officer killed! It will now take less time to get more manpower!'
					Event_NarrativeEventsNotRunning(OfficerDeathSpeech, {}, 4)
					-- and add the resource bonusses
					--Player_AddResource(player1, RT_Manpower, t_difficulty.officerReward)
					
					--local adjustedTicker = VPTicker_GetTeamTickers(Player_GetTeam(player2)) - ( 20 )
					--VPTicker_SetTeamTickers(Player_GetTeam(player2), math.max(adjustedTicker, 1), true)
					
					
					if g_grantTime-math.floor(Timer_GetElapsed(tmr_manpowerTimer)) <= g_decreaseTime then				
						
						Timer_Advance(tmr_manpowerTimer, Timer_GetRemaining(tmr_manpowerTimer))
						g_restartManpowerTimer = true
						
					else
					
						Timer_Advance(tmr_manpowerTimer,  g_decreaseTime)
						
					end
					
					-- retreat to base if exists
					if SGroup_IsAlive(sg_officer) then
						Cmd_Retreat(sg_officer, mkr_preservationOfficerSpawn, mkr_preservationOfficerSpawn, nil,nil, true)
					end
					if Rule_Exists(Enemy_Officer_SpawnCheck) == false then
						Rule_AddDelayedInterval(Enemy_Officer_SpawnCheck, 10, 1)
					end
				end
			end
		end
		
	end
end



function OfficerDeathSpeech()
	Util_StartIntel(EVENTS.Officer_Dead)
end


function Display_Manpower_Countdown()	
	
	timeString = Loc_FormatTime((g_grantTime- math.floor(Timer_GetElapsed(tmr_manpowerTimer))), false, false)
	
	Obj_ShowProgress(Loc_FormatText(11075078, timeString), (g_grantTime- math.floor(Timer_GetElapsed(tmr_manpowerTimer)))/g_grantTime)
	
end


-- Veterancy functions ---------------------------------------------------------------------------------------------------------

-- add veterancy based on node strength
function RandomVeterancy(group, index, squadid)
	
	if SGroup_ContainsSquad(sg_already_vet, Squad_GetGameID(squadid)) == false then
		
		if Squad_GetVeterancyRank(squadid) == 0 then
			Squad_IncreaseVeterancyRank(squadid, XP1_GetNodeStrengthVeterancy(), true)
		end
		
		-- add to list of already vet units so they don't get veterancy again
		SGroup_Add(sg_already_vet, squadid)
	end
end

-- increase veterancy for units produced by ai player
-- called by a rule
function GrantEnemyVeterancy(sgroup, index, squad)
	local 	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	Player_GetAll(player2, sg_temp)
	SGroup_ForEach(sg_temp, RandomVeterancy)
end

-------------------------------------------------------------------------------------------------------------------------------------





--------------------------------------specific unit support for different node strengths----------------------------------------------


function Support()

	if XP1_GetNodeStrength() >= 2 then
	
	Rule_AddInterval(CreatePanzer, 400)
		
--~ 	elseif XP1_GetNodeStrength() == 3 then
	
	Rule_AddInterval(CreateSniper, 600)
	
--~ 	elseif XP1_GetNodeStrength() == 4 then
--~ 	
--~ 	Rule_AddOneShot(CreateJadtiger, 180)

--~ 	elseif XP1_GetNodeStrength() == 5 then
--~ 	
--~ 	Rule_AddOneShot(CreateTigerAce, 180)

	end
end



function CreatePanzer()


	
	Util_CreateSquads(player2, sg_e_all, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_reverseHardpoint_point1)

end
	
	
function CreateSniper()

	if XP1_GetNodeStrength() >= 3 then
		Util_CreateSquads(player2, {sg_sniper, sg_e_all}, SBP.GERMAN.SNIPER_SQUAD_MP, mkr_reverseHardpoint_point1)
		if Rule_Exists(SpottedSniper) == false then
			Rule_AddInterval(SpottedSniper, 2)
		end
	end

end
	

function CreateJadtiger()

	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.JAGDTIGER_TD_SQUAD_MP, mkr_reverseHardpoint_point1)

end
	
function CreateTigerAce()

	Util_CreateSquads(player2, sg_e_all, SBP.GERMAN.TIGER_ACE_SQUAD_MP, mkr_reverseHardpoint_point1)

end
	

	
	
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------Unit Restrictions on Node Strengths and other node strength elements---------------------------------------------

function NodeUnitRestrictions1()

	if XP1_GetNodeStrength() == 1 then
	
	
		------disabled infantry----

		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, ITEM_LOCKED)
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.LE_IG_18_INF_SUPPORT_GUN_SQUAD_MP, ITEM_LOCKED)
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, ITEM_LOCKED)
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, ITEM_LOCKED)
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, ITEM_LOCKED)
			
		----disabled armor----
			
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.KING_TIGER_SQUAD_MP, ITEM_LOCKED)
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.PANTHER_AUSF_G_SQUAD_MP, ITEM_LOCKED)
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.STURMTIGER_SQUAD_MP, ITEM_LOCKED)
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.JAGDTIGER_TD_SQUAD_MP, ITEM_LOCKED)
			
		----disabled base buildings----
		
		Player_SetAbilityAvailability(player2, ABILITY.WEST_GERMAN.CONSTRUCT_ARMORED_INFANTRY_COMMAND, ITEM_LOCKED)
			
		----disabled unit abilities----
		
		Player_SetAbilityAvailability(player2, ABILITY.WEST_GERMAN.VOLKSGRENADIER_GRENADE_MP, ITEM_LOCKED)
	
		
	elseif XP1_GetNodeStrength() == 2 then
		
		------disabled infantry----

			
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, ITEM_LOCKED)
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, ITEM_LOCKED)
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, ITEM_LOCKED)
				
		----disabled armor----

		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.KING_TIGER_SQUAD_MP, ITEM_LOCKED)
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.STURMTIGER_SQUAD_MP, ITEM_LOCKED)
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.JAGDTIGER_TD_SQUAD_MP, ITEM_LOCKED)

	elseif XP1_GetNodeStrength() == 3 then
		
		------disabled infantry----

			
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, ITEM_LOCKED)
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, ITEM_LOCKED)
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, ITEM_LOCKED)
				
		----disabled armor----

		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.KING_TIGER_SQUAD_MP, ITEM_LOCKED)
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.STURMTIGER_SQUAD_MP, ITEM_LOCKED)
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.JAGDTIGER_TD_SQUAD_MP, ITEM_LOCKED)
		
		
	elseif XP1_GetNodeStrength() == 4 then
	
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, ITEM_LOCKED)
		
	elseif XP1_GetNodeStrength() == 5 then
	
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, ITEM_LOCKED)
			
				-------Pre Placed Mines, Mine posts and Bunkers on map-----
			
		Util_CreateEntities(player2, eg_mines, EBP.WEST_GERMAN.SCHU_MINE_42_MP, mkr_mines_1,  1)
		Util_CreateEntities(player2, eg_mines, EBP.WEST_GERMAN.SCHU_MINE_42_MP, mkr_mines_2,  1)
		Util_CreateEntities(player2, eg_mines, EBP.WEST_GERMAN.SCHU_MINE_42_MP, mkr_mines_3,  1)
					
		Util_CreateEntities(player2, eg_mines, EBP.WEST_GERMAN.SCHU_MINE_42_MP, mkr_mines_4,  1)
		Util_CreateEntities(player2, eg_mines, EBP.WEST_GERMAN.SCHU_MINE_42_MP, mkr_mines_5,  1)
		Util_CreateEntities(player2, eg_mines, EBP.WEST_GERMAN.SCHU_MINE_42_MP, mkr_mines_6,  1)

						
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER_MP, mkr_post_1,  1)
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER_MP, mkr_post_2,  1)
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER_MP, mkr_post_3,  1)
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER_MP, mkr_post_4,  1)
					
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER_MP, mkr_post_5,  1)
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER_MP, mkr_post_6,  1)
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER_MP, mkr_post_7,  1)
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER_MP, mkr_post_8,  1)
						
			----Pre placed enemy howitzer-----
						
	--~ 	Util_CreateSquads(player2, sg_e_all, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY_MP, mkr_arty)
					
		RandomBunker() ------function that places random bunkers on the map------
		
		Rule_AddOneShot(CreateHowy, 450)
		
		-- start events for node strength call outs
		Rule_AddInterval(SpottedBunker, 2)
		Rule_AddInterval(SpottedMines, 2)

	end
end


-------------------------------------------------random bunker placement function------------------------------

function RandomBunker()

		local potential_markers =
		{	
		mkr_bunker_1,
		mkr_bunker_2,
		mkr_bunker_3,
		mkr_bunker_4,
		}
	
		local choice = Table_GetRandomItem(potential_markers)
		Util_CreateEntities(player2, eg_bunkers, EBP.GERMAN.AXIS_BUNKER_STARTING_POSITION_MP, choice,  1)
--~ 		for index, marker in pairs(choice) do
--~ 			Util_CreateEntities(player2, eg_mines, EBP.GERMAN.AXIS_BUNKER_STARTING_POSITION_MP, marker,  1)
--~ 		end
--~ 		
	end


----------------------------function that creates a howitzer for node strength 5---------------------------
	
function CreateHowy()

	Util_CreateSquads(player2, {sg_howitzer, sg_e_all}, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY_MP, mkr_arty)
	Rule_AddInterval(ArtilleryAttack, 1)

end

------------------------------------------------------------------------------------------------------------------Random Heavy Tank Call In for Node Strength 4/5---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Tank_Attack_1()
	if VPTicker_GetTeamTickers(1) <= 100 then
		if XP1_GetNodeStrength() >= 4 then
			Spawn_T1()
			Rule_RemoveMe()
		end
	end
end

function Spawn_T1()

	local potential_units =
	{	
		SBP.WEST_GERMAN.PANTHER_COMMANDER_SQUAD_MP,
		SBP.WEST_GERMAN.PANTHER_AUSF_G_SQUAD_MP,
		SBP.WEST_GERMAN.STURMTIGER_SQUAD_MP,
		SBP.WEST_GERMAN.KING_TIGER_SQUAD_MP,
		SBP.WEST_GERMAN.JAGDTIGER_TD_SQUAD_MP,
	}
	
	local choice = Table_GetRandomItem(potential_units)
	
	Util_CreateSquads(player2, sg_e_all, choice, mkr_reverseHardpoint_point1)

end




-- Call out events ----------------------------------------------

function SpottedBunker()
	if EGroup_IsEmpty(eg_bunkers) then
		Rule_RemoveMe()
	
	elseif Player_CanSeeEGroup(player1, eg_bunkers, ANY) then
		Util_StartIntel(EVENTS.Bunker)
		Rule_RemoveMe()
	end
end

function SpottedMines()
	if EGroup_IsEmpty(eg_mines) then
		Rule_RemoveMe()
	
	elseif Player_CanSeeEGroup(player1, eg_mines, ANY) then
		Util_StartIntel(EVENTS.Minefield)
		Rule_RemoveMe()
	end
end

function SpottedSniper()
	if Player_CanSeeSGroup(player1, sg_sniper, ANY) then
		Util_StartIntel(EVENTS.Sniper)
		Rule_RemoveMe()
	end
end

function ArtilleryAttack()
	SGroup_Clear(sg_temp)
	Player_GetAll(player1)
	
	if SGroup_IsUnderAttack(sg_allsquads, ANY, 1) then
		SGroup_GetLastAttacker(sg_allsquads, sg_temp, 1)
		
		if SGroup_ContainsSGroup(sg_temp, sg_howitzer, ANY) then
			Util_StartIntel(EVENTS.Artillery)
			Rule_RemoveMe()
		end
	end
end

	



-- SUCCESS LEVEL ----------------------------------------------------
-- calculates final mission score
function CalculateMissionScore()
	
	-- assuming player starts at gold, we keep checking if the player's vp's drop below a threshold then lower their success level accordingly
	
	-- silver
	if VPTicker_GetTeamTickerFromPlayerID(player1) < 200 and VPTicker_GetTeamTickerFromPlayerID(player1) >= 100 then
		XP1_SetMissionSuccessLevel(2)

	-- bronze
	elseif VPTicker_GetTeamTickerFromPlayerID(player1) < 100 then
		XP1_SetMissionSuccessLevel(1)

	end
	
end

----last minute difficulty changes to make battle harder on hard---

function HardElements0()
	
	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, mkr_reverseHardpoint_point1)

end

function HardElements1()

	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, mkr_reverseHardpoint_point1)

end

function HardElements2()

	Player_AddResource(player2, RT_Manpower, 200)
	
	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.PANZER_IV_AUSF_J_BATTLE_GROUP_MP, mkr_reverseHardpoint_point1)

end

function HardElements3()

	Player_AddResource(player2, RT_Manpower, 200)
	Player_AddResource(player2, RT_Fuel, 50)
	
	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.PANZER_IV_AUSF_J_BATTLE_GROUP_MP, mkr_reverseHardpoint_point1)
	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.LE_IG_18_INF_SUPPORT_GUN_SQUAD_MP, mkr_reverseHardpoint_point1)

end


-------------------------------------------------------------------------
-- [[ MISSION END ]]
-------------------------------------------------------------------------
--This function is called by the Win conditions scar file. 
--See .../scar/WinConditions/xp1_vpplusannihilate.scar or ...xp1_none.scar
function WinConditionEndCallback(winningTeam)
	if(Player_GetTeam(player1) == winningTeam) then
		if Objective_IsComplete(OBJ_Victory) == false then
			Objective_Complete(OBJ_Victory)
		end
	else
		if Objective_IsFailed(OBJ_Victory) == false then
			Objective_Fail(OBJ_Victory)
		end
	end
end

