print("\tLoading mission file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Total Domination
-- Designer: Ryan McGechaen, Darwin Yuen, Matt Philip

-- NOTE: 
-- Although this mission imports VictoryPointPlusAnnihilate.scar, it
-- actually uses custom logic to count down the tickers.
-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScriptSetup.scar") -- <== ### CRITICAL ELEMENT. 
import("XP1.scar")				-- Ardennes Assault functionality
import("WinConditions/AABattle_VictoryPointPlusAnnihilate.scar")

-- [[ Objective files ]]
import("Total_Domination_obj_VICTORY.scar")
import("XP1_NarrativeObj.scar")

-- [[ Encounter data ]]
import("Total_Domination_encounters.scar")



-------------------------------------------------------------------------
-- [[ MISSION SETUP ]]
-------------------------------------------------------------------------
-- Initializes players
function Mission_SetupPlayers()
	-- Not used in battles
end

function Override_Player_Setup()
	local playerCount = World_GetPlayerCount()
	
	for i = 1, playerCount do
		local index = i
		if Player_IsHuman(World_GetPlayerAt(index)) then
			player1 = World_GetPlayerAt(index)
		else
			player2 = World_GetPlayerAt(index)
		end
	end
end

-- Defines key mission data and any global values used throughout the mission.
function Mission_SetupVariables()
	print("Initializing mission DATA...")
	print("LOADING BATTLE: Total Domination")
	

	if Marker_Exists("mkr_mapidentifier_marche", "") then	-- add some extra stuff to do with beginner hints IF and ONLY IF we are playing on Marche
		import("Libraries/BattleExtras/XP1_Marche_BeginnerHintSetup.scar")
		Marche_StartUpBeginnerHints("Total_Domination")
	end
	
	
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
		
	}
	
	
	
	--[[GLOBAL VARIABLES]]
	--TODO: Define any global egroups/sgroups and variables
	
	--[[MAP GROUPS]]
	eg_allStratPoints = EGroup_CreateIfNotFound("eg_allStratPoints")
	
	
	eg_enemyOwnedVPs = EGroup_CreateIfNotFound("eg_enemyOwnedVPs")
	eg_playerOwnedVPs = EGroup_CreateIfNotFound("eg_playerOwnedVps")
	eg_nonCPU_VPs = EGroup_CreateIfNotFound("eg_nonCPU_VPs")
	eg_unownedVPs = EGroup_CreateIfNotFound("eg_unownedVPs")
	eg_mines = EGroup_CreateIfNotFound("eg_mines") ----------------e group for mines---------------------------------------------
	eg_bunkers = EGroup_CreateIfNotFound("eg_bunkers") ----------------e group for bunkers---------------------------------------------
	
	-- random VP attacked by enemy when all points captured
	eg_randomVP = EGroup_CreateIfNotFound("eg_randomVP")
	eg_closest2 = EGroup_CreateIfNotFound("eg_closest2")
	
	sg_VPAttacker_1 = SGroup_CreateIfNotFound("sg_VPAttacker_1")
	sg_VPAttacker_2 = SGroup_CreateIfNotFound("sg_VPAttacker_2")
	sg_VPAttacker_3 = SGroup_CreateIfNotFound("sg_VPAttacker_3")
	sg_VPAttacker_Overgroup = SGroup_CreateIfNotFound("sg_VPAttacker_Overgroup")
	sg_sniper = SGroup_CreateIfNotFound ("sg_sniper")
	sg_howitzer = SGroup_CreateIfNotFound ("sg_howitzer")
	
	-- enemy spawned for easy mode for Total Domination
	sg_SingleCaptureEnemy = SGroup_CreateIfNotFound("sg_SingleCaptureEnemy")
	
	sg_already_vet = SGroup_CreateIfNotFound("sg_already_vet")		-- group for units we have already given veterancy to
	
	-- target VP for easy mode to compensate for the fact that Easy mode AI doesn't capture 3rd point
	g_targetVP = nil
	
	-- table to store information for VP states
	t_ownershipTable= {}
	
	-- states for determining speech
	g_playerCountdownStart = false
	g_aiCountdownStart = false
	g_staleMate = false
	g_victory = false
	g_defeat = false
	g_playerCapturedAll = false
	g_enemyCapturedAll = false
	g_capSquadLocked = false
	g_killSquadLocked = false
	
		--[[MAP GROUPS]]
	t_attackerTable = {
		{encounter = ENCOUNTERS.ai_VPAttacker_1, sgroup = sg_VPAttacker_1, active = false},
		{encounter = ENCOUNTERS.ai_VPAttacker_2, sgroup = sg_VPAttacker_2, active = false},
		{encounter = ENCOUNTERS.ai_VPAttacker_3, sgroup = sg_VPAttacker_3, active = false},
		
	}
	
end

-- Defines difficulty tables/tuning variables
function Mission_SetDifficulty(diffVal)
	-- These variables should be stored in a t_difficulty table for readability and access.
	
	g_difficulty = diffVal or Game_GetSPDifficulty() 	-- Note: Having the diffVal parameter allows for redefining difficulty settings during runtime.
	AI_OverrideDifficulty(g_difficulty)
	
	PM_AI_Aggression = true
	PM_PL_StartingResourceHit = true
	PM_AI_BaseDefenses = true
	
	--Global difficulty table
	t_difficulty = {
--~ 		myTimeoutValue = Util_DifVar({15, 10, 5}, g_difficulty),
		resourceLimitRate = Util_DifVar( {0.80, 0.70, 0.60} ),
		tickerLimit = Util_DifVar({360, 450, 450}),
	}
end

-- Sets restrictions on units, teams, etc.
function Mission_SetupRestrictions()
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
	
	AI_SetPersonality(player2, "botb_skirmish_total_domination")
	
	_collectCPs()
	
	-- Start Objectives
	Objective_Start(OBJ_Victory, true)
	Objective_Start(SOBJ_HoldPoints, false)
	Util_StartIntel(EVENTS.Briefing)
--~ 	-- Disable the VP win condition
	Rule_RemoveIfExist(VPTicker_UpdateTickers)
	Rule_RemoveIfExist(VPTicker_MainRule)
	
	g_player1Tickers = t_difficulty.tickerLimit -- determined by t_difficulty table
	g_player1MaxTickers = t_difficulty.tickerLimit -- determined by t_difficulty table
	g_player2Tickers = t_difficulty.tickerLimit -- determined by t_difficulty table
	g_player2MaxTickers = t_difficulty.tickerLimit  --determined by t_difficulty table
	g_teamLosing = player1
	g_teamWinning = player2
	
	local num1 = math.floor((g_player1Tickers/g_player1MaxTickers) * 250 ) -- out of 250 because of ticker UI
	local num2 = math.floor((g_player2Tickers/g_player2MaxTickers) * 250 )	
	WinWarning_SetTickers(num1, num2)	
	
	--WinWarning_SetTickers(g_player1Tickers, g_player2Tickers)
	Rule_AddInterval(VP_TickDown, 2)
	--Rule_AddInterval(VP_TickUp, 8)
	
	
	-- creates a new enemy offensive team to capture points if all 3 are captured
	Rule_AddDelayedInterval(_attackerSpawner, 10, 5)
	
	-- grant veterancy to all units the ai produces based on node strength
	Rule_AddInterval(GrantEnemyVeterancy, 1)
	
		--Heavy Tank call in group-----------------------------------
	Rule_AddInterval(Tank_Attack_1, 720)
	
	NodeUnitRestrictions1() ----restricts certain ai units at different node strengths
	
	Support() ------grants different support units based on node strength
	
	-- start checking if game is over so we can update success level
	Rule_AddInterval(CalculateMissionScore, 1)
	
	-- Speech events
	Rule_AddInterval(FirstVictoryPointCaptured, 1)
	
	
end


-- checks to see if easy mode squad that captures points should be spawned
function SingleCapCheckSpawner()

	VP_Ownership()
	local statTable = t_ownershipTable
	
	-- assuming that if unownedVPs is 1 then that is the last VP to capture
	if EGroup_Count(statTable.unownedVPs) == 1  or ((EGroup_Count(statTable.enemyOwnedVPs) == 1) and (EGroup_Count(statTable.playerOwnedVPs) == (EGroup_Count(eg_allStratPoints) - 1))) then
		if EGroup_Count(statTable.unownedVPs) == 1  then
			g_targetVP = statTable.unownedVPs
		elseif ((EGroup_Count(statTable.enemyOwnedVPs) == 1) and (EGroup_Count(statTable.playerOwnedVPs) == (EGroup_Count(eg_allStratPoints) - 1)))  then
			g_targetVP = statTable.playerOwnedVPs
		
		end
		
		
		-- if there is no enemy spawned for that	
		if SGroup_IsAlive(sg_SingleCaptureEnemy) == false then
			
			local t_capSquadInfo = {
				{sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP},
				{sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP},
				{sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP},
				{sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP},
				{sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP},	
			}
				
				
			local	nodeStrength = XP1_GetNodeStrength()
			
			Util_CreateSquads(player2, sg_SingleCaptureEnemy, t_capSquadInfo[nodeStrength].sbp, mkr_TD_EnemySpawn)
			AI_LockSquads(player2, sg_SingleCaptureEnemy)
			g_capSquadLocked = true
			
			SGroup_IncreaseVeterancyRank(sg_SingleCaptureEnemy, XP1_GetNodeStrengthVeterancy(), true)
			
--~ 			if t_capSquadInfo[nodeStrength].veterancy ~= nil and t_capSquadInfo[nodeStrength].veterancy > 0 then
--~ 				SGroup_IncreaseVeterancyRank(sg_SingleCaptureEnemy, t_capSquadInfo[nodeStrength].veterancy, true)
--~ 			end
			
			if Rule_Exists(ExtraSpawnController) == false then
				Rule_AddInterval(ExtraSpawnController, 5)
			end
			
			Rule_RemoveMe()
		end
	end

end

-- controls behaviour of the extra spawned squad, which is only created in easy mode to compensate for the Easy AI's intended behaviour of always not capping the last VP.
function ExtraSpawnController()
	if SGroup_IsAlive(sg_SingleCaptureEnemy) == false then
		
		Rule_AddDelayedInterval(SingleCapCheckSpawner, 15, 10)
		Rule_RemoveMe()
		
	else
	
		if EGroup_IsEmpty(eg_allStratPoints) == false then
	
			VP_Ownership()
			local statTable = t_ownershipTable	
			
			-- if there are unowned VPs, and the unowned count is 1 then use that unowned VP as the target
			if statTable.unownedVPs ~= nil and statTable.uC == 1 then
				g_targetVP = statTable.unownedVPs
				
			-- if enemy owned count is only 1 less than max # of points 
			elseif statTable.eOC == (EGroup_Count(eg_allStratPoints) - 1) then 
				
				-- if player owns that last point then target that
				if EGroup_Count(statTable.playerOwnedVPs) == 1 then
					g_targetVP = statTable.playerOwnedVPs
				end
				
			end
			
			-- if target is valid and the CPU doesn't own it, capture
			if g_targetVP ~= nil and Player_OwnsEGroup(player2, g_targetVP, ANY) == false and EGroup_IsEmpty(g_targetVP) == false then
			
				if g_capSquadLocked == false then
					AI_LockSquads(player2, sg_SingleCaptureEnemy)
					g_capSquadLocked = true
				end
				
				Cmd_AttackMove(sg_SingleCaptureEnemy, EGroup_GetPosition(g_targetVP), nil, nil, 5, nil)
			
			-- if target is invalid or target is owned already, just let the AI control it
			elseif g_targetVP == nil or Player_OwnsEGroup(player2, eg_allStratPoints, ANY) == true or EGroup_IsEmpty(g_targetVP) == true then
				if g_capSquadLocked == true then
					AI_UnlockSquads(player2, sg_SingleCaptureEnemy)
					g_capSquadLocked = false
				end
			
			end
			
		end
	end

end

-- general function used repeatedly to get info about the VPs
function VP_Ownership()

	if EGroup_IsEmpty(eg_allStratPoints) == false then
		
		EGroup_Clear(eg_enemyOwnedVPs)
		EGroup_Clear(eg_playerOwnedVPs)
		EGroup_Clear(eg_nonCPU_VPs)
		EGroup_Clear(eg_unownedVPs)	
		EGroup_Clear(eg_closest2)
		lt_VP_distTable = {}
		local _filterOwnedPoints = function(gid, idx, eid)
		
			if Player_OwnsEntity(player2, eid) == true then
				EGroup_Add(eg_enemyOwnedVPs, eid)
			elseif Player_OwnsEntity(player1, eid) == true then
				EGroup_Add(eg_playerOwnedVPs, eid)
				EGroup_Add(eg_nonCPU_VPs, eid)
				table.insert(lt_VP_distTable, eid)
			else
				EGroup_Add(eg_unownedVPs, eid)
				EGroup_Add(eg_nonCPU_VPs, eid)
			end
			
		end	
		-- do the sorting
		
		EGroup_ForEach(eg_allStratPoints, _filterOwnedPoints)
		
		if (table.getn(lt_VP_distTable) - 1) >= 2 then
			for i = 1,  (table.getn(lt_VP_distTable)) do
				local tempClosest = World_GetClosest(mkr_TD_EnemySpawn, lt_VP_distTable)
				EGroup_Add(eg_closest2, tempClosest)
				
				for i = 1,  (table.getn(lt_VP_distTable) - 1) do
					if tempClosest == lt_VP_distTable[i] then
						table.remove(lt_VP_distTable, i)
						break
					end
				end
				if EGroup_Count(eg_closest2) >= 2 then
					break
				end
				
			end
		elseif table.getn(lt_VP_distTable) < 3 then
			for i = 1,  (table.getn(lt_VP_distTable)) do
				EGroup_Add(eg_closest2, lt_VP_distTable[i])
				
			end
		end
		
		
		local playerOwnedCount = EGroup_Count(eg_playerOwnedVPs)
		local enemyOwnedCount = EGroup_Count(eg_enemyOwnedVPs)
		local nonCPUCount = EGroup_Count(eg_nonCPU_VPs)
		local unownedCount = EGroup_Count(eg_unownedVPs)
		
		t_ownershipTable = {pOC = playerOwnedCount, eOC = enemyOwnedCount, nCPUC = nonCPUCount, uC = unownedCount, playerOwnedVPs = eg_playerOwnedVPs, enemyOwnedVPs = eg_enemyOwnedVPs, unownedVPs = eg_unownedVPs, nonCPUVPs = eg_nonCPU_VPs, Closest2 = eg_closest2}		
	end
end

-- function for ticking down the vp tickers
function VP_TickDown()
	
	-- * note OC equals "ownership count"
	
	-- count how many points owned by the player in here
	VP_Ownership()
	local statTable = t_ownershipTable
	if t_ownershipTable ~= nil then
		
		-- compares ownership count.  If at any time either ownership count is equal, then do nothing to decrease.
		
		if Player_OwnsEGroup(player1, eg_allStratPoints, ALL) == true then
			if math.floor(g_player2Tickers - (statTable.pOC-statTable.eOC)*1) > 0 then
				g_player2Tickers = math.floor(g_player2Tickers - (statTable.pOC-statTable.eOC)*1)
			else
				g_player2Tickers = 0
				
			end
		elseif Player_OwnsEGroup(player2, eg_allStratPoints, ALL) == true then
			if math.floor(g_player1Tickers - (statTable.eOC-statTable.pOC)*1) > 0 then
				g_player1Tickers = math.floor(g_player1Tickers - (statTable.eOC-statTable.pOC)*1)
			else
				g_player1Tickers = 0
			end
		end
		
		-- scaled to fill bar
		
		if g_player1Tickers == nil then 
			g_player1Tickers = 0
		end
		if g_player2MaxTickers == nil then
			g_player2MaxTickers = 0
		end
		
		
		local num1 = math.floor((g_player1Tickers/g_player1MaxTickers) * 250 )
		local num2 = math.floor((g_player2Tickers/g_player2MaxTickers) * 250 )	
		WinWarning_SetTickers(num1, num2)	
		--WinWarning_SetTickers(g_player1Tickers, g_player2Tickers)
	end
end

-- function for ticking up VP tickers
function VP_TickUp()
	-- * note OC equals "ownership count"
	
	-- count how many points owned by the player in here
	VP_Ownership()
	local statTable = t_ownershipTable
	if t_ownershipTable ~= nil then
		-- compares ownership count.  If at any time either ownership count is equal, then do nothing to increase
		
		-- if player owned count is greater than 0 and greater than the enemy then player's vp ticker goes up
		if statTable.pOC > 0 and statTable.pOC > statTable.eOC then
			
			if g_player1Tickers < g_player1MaxTickers then
				g_aiCountdownStart = false			
				g_player1Tickers = math.floor(g_player1Tickers + 1)
			end
			
		-- if enemy owned count is greater than 0 and greater than the enemy's vp ticker goes up
		elseif statTable.eOC > 0 and statTable.eOC > statTable.pOC then
			
			if g_player2Tickers < g_player2MaxTickers then
				g_playerCountdownStart = false
				g_player2Tickers = math.floor(g_player2Tickers + 1)
			end
			
		elseif statTable.pOC == statTable.eOC then		
		
		end
		
		-- scaled to fill bar
		if g_player1Tickers == nil then 
			g_player1Tickers = 0
		end
		if g_player2MaxTickers == nil then
			g_player2MaxTickers = 0
		end
		
		local num1 = math.floor((g_player1Tickers/g_player1MaxTickers) * 250 )
		local num2 = math.floor((g_player2Tickers/g_player2MaxTickers) * 250 )	
		WinWarning_SetTickers(num1, num2)	
		--WinWarning_SetTickers(g_player1Tickers, g_player2Tickers)
	end	
end

-- displays message that the player has more VPs
function VP_PlayerStatus()
	if g_playerCountdownStart == false then
		g_playerCountdownStart = true
		Util_StartIntel(EVENTS.VPPlayerStatus)
	end
end

-- displays message that the AI has more VPs
function VP_AIStatus()
	if g_aiCountdownStart == false then
		g_aiCountdownStart = true
		Util_StartIntel(EVENTS.VPAIStatus)
	end
end




function Override_Player_Setup()
	local playerCount = World_GetPlayerCount()
	
	for i = 1, playerCount do
		local index = i
		if Player_IsHuman(World_GetPlayerAt(index)) then
			player1 = World_GetPlayerAt(index)
		else
			player2 = World_GetPlayerAt(index)
		end
	end
end

-- collects and organizes the capturable points on the map and adds victory points into their own egroup 
function _collectCPs()
	World_GetStrategyPoints(eg_allStratPoints, true)
	
	local _filterVPs = function(gid, idx, eid)
		if Entity_GetBlueprint(eid) ~= BP_GetEntityBlueprint("victory_point") then
			EGroup_Remove(eg_allStratPoints, eid)
		end
	end
	
	EGroup_ForEach(eg_allStratPoints, _filterVPs)
end

-- Create a new team to capture VP points when all 3 points are captured
function _attackerSpawner()
	if SGroup_IsAlive(sg_VPAttacker_Overgroup) == false and EGroup_IsCapturedByPlayer(eg_allStratPoints, player1, ALL) or (SGroup_IsAlive(sg_VPAttacker_Overgroup) == true and SGroup_CountSpawned(sg_VPAttacker_Overgroup) <= 1 and EGroup_IsCapturedByPlayer(eg_allStratPoints, player1, ALL)) then

		Rule_AddDelayedInterval(_generateVPTeam, 10,10)
		
		Rule_RemoveMe()
	
	end
	
end

-- Actual function that creates a team when _attackerSpawner is called
function _generateVPTeam()
	
	if SGroup_IsAlive(sg_VPAttacker_Overgroup) == false or (SGroup_IsAlive(sg_VPAttacker_Overgroup) == true and SGroup_CountSpawned(sg_VPAttacker_Overgroup) <= 1) then
		
		-- grab point info and choose a random captured point to attack
		VP_Ownership() 
			
		-- spawn enemy - length of time needs to be factored in
		_getRandomVP()	
		
		if EGroup_IsEmpty(eg_randomVP) == false then 	
			
			-- example - tbd later on
			local phase = 1 
			
			local timeplayed =math.floor(World_GetGameTime())
			
--~ 			if g_player2Tickers > 200 then
--~ 				phase = 1 
--~ 			elseif g_player2Tickers > 100 and g_player2Tickers <= 199 then	
--~ 				phase = 2
--~ 			elseif g_player2Tickers > 0 and g_player2Tickers <= 99 then	
--~ 				phase = 3
--~ 			end

			if timeplayed <= 419 then 
				phase = 1 
			elseif timeplayed >= 420 and timeplayed <= 839 then 
				phase = 2 			
			elseif timeplayed >= 839 then 
				phase = 3 			
			end
			
			g_VPTeam = t_attackerTable[phase].encounter(mkr_TD_EnemySpawn)
			Util_StartIntel(EVENTS.EnemyForceSpawn)
			attackBlip = UI_CreateMinimapBlip(Util_GetPosition(eg_randomVP), 5, BT_DefendHere)
			g_killSquadLocked = true
			Rule_AddInterval(_attackerController, 1)
		end
		
		Rule_RemoveMe()
	end
end


function _getRandomVP()
	if EGroup_Exists("eg_randomVP") == true then
	
		VP_Ownership() -- grabs current state of VPs
		local statTable = t_ownershipTable
			
		
		if EGroup_IsEmpty(statTable.Closest2) == false then
			
			-- clears current EGroup of random VP.			
			EGroup_Clear(eg_randomVP)
			
			-- randomly choose an unowned VP or a player owned VP			
			EGroup_Add(eg_randomVP, EGroup_GetRandomSpawnedEntity(statTable.Closest2))
			
			
		end
	
	end
end

-- controller function for how the enemy VP attacker team behaves
function _attackerController()
	if SGroup_IsAlive(sg_VPAttacker_Overgroup) == false then
		g_killSquadLocked = false
		-- generate VP attacker here
		Rule_AddDelayedInterval(_attackerSpawner, 20, 10)
		Rule_RemoveMe()
		
	else
	
		if EGroup_IsEmpty(eg_allStratPoints) == false then
	
			if EGroup_IsCapturedByPlayer(eg_allStratPoints, player1, ALL) then
				
				if g_killSquadLocked == false then
					_getRandomVP()
					
					if EGroup_IsEmpty(eg_randomVP) == false then
						AI_LockSquads(player2, sg_VPAttacker_Overgroup)
						--g_VPTeam:Enable()						
						
						GOALS.ai_VP_attack_goal(g_VPTeam, eg_randomVP)					
						Rule_AddDelayedInterval(delayedNotification, 5, 1)
						g_killSquadLocked = true			
					end
				end
				
				
			elseif EGroup_IsCapturedByPlayer(eg_allStratPoints, player1, ALL) == false then
			
				if g_killSquadLocked == true then
					--g_VPTeam:Disable()
					g_VPTeam:ClearGoal()
					AI_UnlockSquads(player2, sg_VPAttacker_Overgroup)
					g_killSquadLocked = false
				end
			end
		end
	end
end


function delayedNotification()
	if Event_IsAnyRunning() == false then
		Util_StartIntel(EVENTS.EnemyForce)
		attackBlip = UI_CreateMinimapBlip(Util_GetPosition(eg_randomVP), 5, BT_DefendHere)
		Rule_RemoveMe()
	end
end



-- plays speech after the player captures their first VP
function FirstVictoryPointCaptured()
	if EGroup_Count(eg_playerOwnedVPs) > 0 then
		Util_StartIntel(EVENTS.FirstPointCaptured )
		Rule_RemoveMe()
		Rule_AddDelayedInterval(CaptureReminder, 6*60, 2)
	end
end

-- plays speech to remind player to capture all three points
-- called by FirstVictoryPointCaptured
function CaptureReminder()
	if EGroup_Count(eg_playerOwnedVPs) < 3 then
		Util_StartIntel(EVENTS.CaptureReminder)
		Rule_RemoveMe()
		Rule_AddDelayedInterval(CaptureReminder, 6*60, 2)
	end
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
		
	elseif XP1_GetNodeStrength() == 5 then
		
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
		
		Rule_AddOneShot(CreateHowy, 500)
		
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
	
		local choice = Table_GetRandomItem(potential_markers, 2)
	
		for index, marker in pairs(choice) do
			Util_CreateEntities(player2, eg_bunkers, EBP.GERMAN.AXIS_BUNKER_STARTING_POSITION_MP, marker,  1)
		end
		
	end


----------------------------function that creates a howitzer for node strength 5---------------------------
	
function CreateHowy()

	Util_CreateSquads(player2, {sg_howitzer, sg_e_all}, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY_MP, mkr_arty)
	Rule_AddInterval(ArtilleryAttack, 1)

end


------------------------------------------------------------------------------------------------------------------Random Heavy Tank Call In for Node Strength 4/5---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Tank_Attack_1()
	
		if XP1_GetNodeStrength() >= 4 then
			Spawn_T1()
			Rule_RemoveMe()
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




--------------------------------------specific unit support for different node strengths----------------------------------------------


function Support()

	if XP1_GetNodeStrength() >= 2 then
	
	Rule_AddInterval(CreatePanzer, 500)
		
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


-------------------------------------------------------------------------
-- [[ MISSION END ]]
-------------------------------------------------------------------------
--This function is called by the Win conditions scar file. 
--See .../scar/WinConditions/vpplusannihilate.scar or .../none.scar
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
	
