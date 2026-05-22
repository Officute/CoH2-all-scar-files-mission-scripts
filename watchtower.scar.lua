print("\tLoading mission file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Watchtower
-- Designer: Ryan McGechaen
-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScriptSetup.scar") -- <== ### CRITICAL ELEMENT. 
import("XP1.scar")				-- Ardennes Assault functionality
import("WinConditions/AABattle_VictoryPointPlusAnnihilate.scar")

-- [[ Objective files ]]
import("Watchtower_obj_VICTORY.scar")
import("XP1_NarrativeObj.scar")

-- [[ Encounter data ]]
import("Watchtower_encounters.scar")



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
	print("LOADING BATTLE: In The Blind")
	

	if Marker_Exists("mkr_mapidentifier_marche", "") then	-- add some extra stuff to do with beginner hints IF and ONLY IF we are playing on Marche
		import("Libraries/BattleExtras/XP1_Marche_BeginnerHintSetup.scar")
		Marche_StartUpBeginnerHints("Watchtower")
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
		
		--atmosphere = "_mp_4p_coh2_okariver_blizzard.aps",
	}
	
	
	
	--[[GLOBAL VARIABLES]]
	g_germanStartFuel = 0
	g_aefStartFuel = 0
	
	g_germanCurrFuel = 0
	g_aefCurrFuel = 0
	g_german_captures = 0		-- numebr of times the germans captured a fuel drop
	
	g_dropZone = nil
	g_dropPoint = nil
	g_dropTimerWarningValue = 75 -- default number
	g_dropTimerValue = 90 -- default number
	
	
	g_dropRadius = 40
	g_detectRadius = 90
	g_crateRevealed = false
	
	IN_THE_BLIND_DROP_ABIL = BP_GetAbilityBlueprint("pm_drop_fuel_in_the_blind")
	IN_THE_BLIND_DROP_ENTITY = BP_GetEntityBlueprint("pm_fuel_reserve_in_the_blind")
	sg_watchtowerEnemy = SGroup_CreateIfNotFound("sg_watchtowerEnemy")
	sg_watchtowerEnemy_1 = SGroup_CreateIfNotFound("sg_watchtowerEnemy_1")
	sg_watchtowerEnemy_2 = SGroup_CreateIfNotFound("sg_watchtowerEnemy_2")
	sg_watchtowerEnemy_3 = SGroup_CreateIfNotFound("sg_watchtowerEnemy_3")
	
	sg_allsquads = SGroup_CreateIfNotFound("sg_allsquads")
	eg_allentities = EGroup_CreateIfNotFound("eg_allentities")
	Player_GetAll(player2, sg_allsquads, eg_allentities)
	
	local _baseCoordinateFind = function(gid, idx, eid)
	print("inside")
		if Entity_GetBlueprint(eid) == BP_GetEntityBlueprint("german_hq_mp") then
		print("base found")
			g_enemyBasePos = Entity_GetPosition(eid)
		end
	
	end
	EGroup_ForEach(eg_allentities, _baseCoordinateFind)
	
	--t_nodeStrengthOffset = {-40, -20, 0, 20, 40}		
	
	sg_already_vet = SGroup_CreateIfNotFound("sg_already_vet")		-- group for units we have already given veterancy to
	
	g_fuelGrabTeamTime = 15
	sg_fuelGrabTeam = SGroup_CreateIfNotFound("sg_fuelGrabTeam")
	
	eg_supplies = EGroup_CreateIfNotFound("eg_supplies")
	eg_mapEntry = EGroup_CreateIfNotFound("eg_mapEntry")
	
	eg_watchtowers = EGroup_CreateIfNotFound("eg_watchtowers")
	
	eg_enemyOwnedWatchtowers = EGroup_CreateIfNotFound("eg_enemyOwnedWatchtowers")
	eg_playerOwnedWatchtowers = EGroup_CreateIfNotFound("eg_playerOwnedWatchtowers")
	eg_unownedWatchtowers = EGroup_CreateIfNotFound("eg_unOwnedWatchtowers")	
	eg_nonCPUWatchtowers = EGroup_CreateIfNotFound("eg_nonCPUWatchtowers")
	
	eg_randomWatchtower = EGroup_CreateIfNotFound("eg_randomWatchtower") -- for determining which drop zone to capture
	eg_pickedTower = EGroup_CreateIfNotFound("eg_pickedTower")
	g_currentDropTower = nil -- for storing which tower that airdrop was dropping near
	
	t_mapEntryPoints = {}
	
	-- Temp
	t_dropMarkers = {}
	
	--[[MAP GROUPS]]
	t_interceptorTable = {
		{encounter = ENCOUNTERS.ai_watchtowerPatrol_1, sgroup = sg_watchtowerEnemy_1, active = false},
		{encounter = ENCOUNTERS.ai_watchtowerPatrol_2, sgroup = sg_watchtowerEnemy_2, active = false},
		{encounter = ENCOUNTERS.ai_watchtowerPatrol_3, sgroup = sg_watchtowerEnemy_3, active = false},
		{encounter = ENCOUNTERS.ai_watchtowerPatrol_4, sgroup = sg_watchtowerEnemy_4, active = false},
		{encounter = ENCOUNTERS.ai_watchtowerPatrol_5, sgroup = sg_watchtowerEnemy_5, active = false},
	}
	
	t_fuelGrabTable = {
		{encounter = ENCOUNTERS.ai_grab_fuel1, sgroup = sg_fuelGrabTeam},
		{encounter = ENCOUNTERS.ai_grab_fuel2, sgroup = sg_fuelGrabTeam},
		{encounter = ENCOUNTERS.ai_grab_fuel3, sgroup = sg_fuelGrabTeam},	
	}
	
end

-- Defines difficulty tables/tuning variables
function Mission_SetDifficulty(diffVal)
	--TODO: Define any difficulty-related settings or variables.
	-- These variables should be stored in a t_difficulty table for readability and access.
	
	g_difficulty = diffVal or Game_GetSPDifficulty() 	-- Note: Having the diffVal parameter allows for redefining difficulty settings during runtime.
	AI_OverrideDifficulty(g_difficulty)
	
	PM_AI_Aggression = true
	PM_PL_StartingResourceHit = true
	
	--Global difficulty table
	t_difficulty = {
		germanStartFuel = Util_DifVar({
			XP1_NodeDif({900, 900, 900, 900, 900}),
			XP1_NodeDif({900, 900, 900, 900, 900}),
			XP1_NodeDif({900, 900, 900, 900, 900}),
		}, g_difficulty),
		aefStartFuel = Util_DifVar({
			XP1_NodeDif({900, 900, 900, 900, 900}),
			XP1_NodeDif({900, 900, 900, 900, 900}),
			XP1_NodeDif({900, 900, 900, 900, 900}),
		}, g_difficulty),
		dropTime = Util_DifVar({60, 75, 90}),
		viewArea = Util_DifVar({45, 30, 20}), -- view area around watchtowers.
			
		
	}
	
	g_dropTimerValue =  t_difficulty.dropTime -- default number 90
	g_dropTimerWarningValue = g_dropTimerValue - 15 -- 15 seconds less than actual time at which something drops
	
	
end

-- Sets restrictions on units, teams, etc.
function Mission_SetupRestrictions()
	--TODO: Set any tech/ability restrictions on a players, as well as resource limits.
	--	Note: Resource Income/Caps should be defined in Mission_SetDifficulty()
	
	--[[ HUMAN PLAYER ]]
--~ 	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.IS_2_HEAVY_TANK, ITEM_REMOVED)
	
	--[[ ALLIED PLAYER ]]

	--[[ ENEMY PLAYER ]]
	Player_AddAbility(player2, IN_THE_BLIND_DROP_ABIL)
	
end

-- Sets up the map before the mission starts (starting units, ownership, etc.)
function Mission_Preset()
	-- temporarily to disable functionality of VPs
	if g_VPConditionsLoaded == true then
		g_VPConditionsLoaded = false
		Rule_RemoveIfExist(VPTicker_MainRule)
		Rule_RemoveIfExist(VPTicker_PointReminder)
		Rule_RemoveIfExist(VPTicker_UpdateTickers)
		
	end
	
	XP1_SetMissionSuccessLevel(1) -- initializes mission success level to 1 at beginning
	
	-- turn on VP bar and set tooltips, etc
	WinWarning_SetToolTip(0, 11079358, 11079359, "Icons_resources_flag_crate")
	WinWarning_SetToolTip(1, 11079360, 11079361, "Icons_resources_flag_crate")
	WinWarning_ScoreDisplayIconsClear()
	WinWarning_ScoreDisplayIconAdd("Icons_symbols_building_supply_stack_symbol", 255, 255, 255, 0, 11079676, 11079677, "Icons_resources_flag_crate")
	
end


-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
--Called once the intro nis/nislet/sitrep finishes playing.
function Mission_Start()
	AI_SetPersonality(player2, "botb_skirmish_watchtower")
	--MP_BlizzardInit("data:art/scenarios/presets/atmosphere/_mp_4p_coh2_okariver_blizzard.aps", "data:art/scenarios/presets/atmosphere/_mp_4p_coh2_okariver_blizzard.aps", true)
	CollectVPs()
	SortOwnedVPs()
	
	-- Start Objectives
	Objective_Start(OBJ_Victory)
	Objective_Start(SOBJ_DepleteFuel, false, true)
	
	
	Event_Timer(EventHandler_StartIntel, {intel = EVENTS.Mission_Start}, 5)
	

	-- first drop 2 mins in!
	Event_Timer(EventHandler_StartIntel, {intel = EVENTS.AirDropInc}, 1.8*60)
	
	--Rule_AddOneShot(Select_Drop_Zone, 2*60)
	Rule_AddDelayedInterval(Select_Drop_Zone, 2*60, 1)
	
	-- Collect Map Entry Points
	Rule_AddInterval(Collect_Map_Entry, 60)
	
	-- Kick off mission success level calculator
	Rule_AddInterval(CalculateSuccess, 1)
	
	
	-- Kick off enemies to take over the watchtowers
	--Rule_AddDelayedInterval(WatchtowerEnemyControl, 30, 1)
	
	-- grant veterancy to all units the ai produces based on node strength
	Rule_AddInterval(GrantEnemyVeterancy, 1)
	
	
		--Heavy Tank call in group-----------------------------------
	Rule_AddInterval(Tank_Attack_1, 720)
	
	
	NodeUnitRestrictions1() ----restricts certain ai units at different node strengths
	
	
	AirSupport() ----adds commander air support abilities based on node strengths
	
	Support() ------grants different support units based on node strength
	
	
		if g_difficulty == GD_HARD then
	
		Rule_AddOneShot(HardElements0, 30)
		Rule_AddOneShot(HardElements1, 200)
		Rule_AddOneShot(HardElements2, 500)
		Rule_AddOneShot(HardElements3, 800)

	end
	
	
end


function Select_Drop_Zone()
	if g_aefCurrFuel <= 0 or g_germanCurrFuel <= 0 then
	
		Rule_RemoveMe()
	
	elseif g_aefCurrFuel >= 1 then 
	
		print("selecting drop zone")
		
		local randomDropEntity = EGroup_GetRandomSpawnedEntity(eg_watchtowers)
		
		if (g_currentDropTower ~= randomDropEntity or g_currentDropTower == nil) and randomDropEntity ~= nil then
			g_currentDropTower = randomDropEntity
			
			local tempPos = Util_GetRandomPosition(Entity_GetPosition(randomDropEntity), 50, nil)
			
			if Prox_ArePlayersNearMarker(player1, tempPos, ANY, 25) == false and Prox_ArePlayersNearMarker(player2, tempPos, ANY, 25) == false then
			
				g_dropZone = tempPos
				Drop_Deploy()
				Rule_RemoveMe()	
			end
		end
	end
end


function Drop_Deploy()
	
	Util_StartIntel(EVENTS.AirDrop)
	Util_MissionTitle(11075855) -- LOCDB [11075855] 'Incoming Air Drop!'

	FlashingSuppliesSymbol_Start()	-- start flashing the drop icon in the VP bar
	
	
	-- TODO: Get this selected in an are with as few units as possible
	
	
	--local _nodeStrength = XP1_GetNodeStrength()
	--local _offsetPosition = Util_GetPositionFromAtoB(Marker_GetPosition(mkr_in_the_blind), g_enemyBasePos, t_nodeStrengthOffset[_nodeStrength])
	--local _scalar = World_GetRand(-70, 70)
	--local _direction = Marker_GetDirection(mkr_in_the_blind)
	--_offsetPosition.x = _offsetPosition.x + (_direction.x * _scalar)
	--_offsetPosition.z = _offsetPosition.z + (_direction.z * _scalar)
	--g_dropZone = Util_GetRandomPosition(_offsetPosition, 10)
	--view(g_dropZone)
	
	--g_dropZone = Util_GetRandomPosition(mkr_in_the_blind)
	
	--g_dropZone = Util_GetRandomPosition(Entity_GetPosition(EGroup_GetRandomSpawnedEntity(eg_watchtowers)), 50, nil)
	
	_AddBlips()
	
	_selectDropPoint()
	
	_dropSupplies()
	Rule_AddInterval(_getSuppliesGroup, 0.5)
	
	if SGroup_IsEmpty(sg_fuelGrabTeam) or SGroup_IsAlive(sg_fuelGrabTeam) == false then
		Event_Timer(_generateFuelGrabTeam, nil, g_fuelGrabTeamTime)
	elseif SGroup_IsEmpty(sg_fuelGrabTeam) == false and SGroup_IsAlive(sg_fuelGrabTeam) == true then
		-- tell sg_fuelGrabTeam to grab the new supply location
		Event_Timer(_grabSuppliesDelay, nil, g_fuelGrabTeamTime)
	end
end

-- Find a location within the drop zone to drop supplies
function _selectDropPoint()
	-- TODO: Drop on a location the player can't see
	local randMin = World_GetRand(5, 10) -- 10, 20
	g_dropPoint = Prox_GetRandomPosition(g_dropZone, g_dropRadius, randMin)
end

-- Clear the drop point blips
function _RemoveBlips()
--~ 	for i = 1, table.getn(t_dropMarkers) do
--~ 		if t_dropMarkers[i] ~= nil then
--~ 			UI_DeleteMinimapBlip(t_dropMarkers[i])
--~ 		end
--~ 	end

	MapIcon_Destroy(CircleBlipID)

end

function _AddBlips()

--~ 	--t_dropMarkers[1] = UI_CreateMinimapBlip(g_dropZone, -1, BT_General)

--~ 	t_dropMarkers[1] = UI_CreateMinimapBlip(Util_GetOffsetPosition(g_dropZone, OFFSET_FRONT, g_dropRadius), -1, BT_General)
--~ 	t_dropMarkers[2] = UI_CreateMinimapBlip(Util_GetOffsetPosition(g_dropZone, OFFSET_FRONT_LEFT, g_dropRadius), -1, BT_General)
--~ 	t_dropMarkers[3] = UI_CreateMinimapBlip(Util_GetOffsetPosition(g_dropZone, OFFSET_LEFT, g_dropRadius), -1, BT_General)
--~ 	t_dropMarkers[4] = UI_CreateMinimapBlip(Util_GetOffsetPosition(g_dropZone, OFFSET_BACK_LEFT, g_dropRadius), -1, BT_General)
--~ 	t_dropMarkers[5] = UI_CreateMinimapBlip(Util_GetOffsetPosition(g_dropZone, OFFSET_BACK, g_dropRadius), -1, BT_General)
--~ 	t_dropMarkers[6] = UI_CreateMinimapBlip(Util_GetOffsetPosition(g_dropZone, OFFSET_BACK_RIGHT, g_dropRadius), -1, BT_General)
--~ 	t_dropMarkers[7] = UI_CreateMinimapBlip(Util_GetOffsetPosition(g_dropZone, OFFSET_RIGHT, g_dropRadius), -1, BT_General)
--~ 	t_dropMarkers[8] = UI_CreateMinimapBlip(Util_GetOffsetPosition(g_dropZone, OFFSET_FRONT_RIGHT, g_dropRadius), -1, BT_General)

	CircleBlipID = MapIcon_CreatePosition(g_dropZone, "Icons_minimap_area_circle", 50, 255, 255, 0, 255)
	
end
-- Call in the air drop
function _dropSupplies()
	Cmd_Ability(player2, IN_THE_BLIND_DROP_ABIL, g_dropPoint, nil, true)
	
	Rule_AddDelayedInterval(ShowCrates, 5, 1)
	Rule_AddDelayedInterval(PlayerSeeCrates, 5, 1)
end

function _grabSuppliesDelay()
	if SGroup_IsEmpty(sg_fuelGrabTeam) == false and SGroup_IsAlive(sg_fuelGrabTeam) == true then
		-- tell sg_fuelGrabTeam to grab the new supply location
		if g_fuelTeam ~= nil then
			sgroup = g_fuelTeam:GetSgroup()
			AI_LockSquads(player2, sgroup)
			g_fuelTeam:Enable()			
			GOALS.ai_moveToFuel(g_fuelTeam, g_dropZone)
		end
		
	elseif SGroup_IsEmpty(sg_fuelGrabTeam) == true or SGroup_IsAlive(sg_fuelGrabTeam) == false then -- if the fuel grab team got destroyed in the meantime
		_generateFuelGrabTeam()

	end
end

-- Collect the supplies entity into a group
function _getSuppliesGroup()
	Player_GetAllEntitiesNearMarker(player2, eg_supplies, g_dropPoint, g_dropRadius)
	EGroup_Filter(eg_supplies, IN_THE_BLIND_DROP_ENTITY, FILTER_KEEP)
	
	if EGroup_IsEmpty(eg_supplies) == false then
		Rule_RemoveMe()
		
		Event_GroupIsDead(_suppliesStartTimer, nil, eg_supplies)
	end
end

-- Once the supplies is picked up, start a timer for the next drop
function _suppliesStartTimer()
	if SGroup_IsEmpty(sg_fuelGrabTeam) == false then
		-- Delete the capture guys for now
		--SGroup_DeSpawn(sg_fuelGrabTeam)
		
		-- move back to base instead
		--Cmd_Retreat(sg_fuelGrabTeam, g_enemyBasePos)
		--Cmd_AttackMove(sg_fuelGrabTeam, g_enemyBasePos, nil, nil, 15)
		
		if g_fuelTeam ~= nil then
			sgroup = g_fuelTeam:GetSgroup()
			g_fuelTeam:Disable()		
			AI_UnlockSquads(player2, sgroup)
		end
		-- release the hounds!		
	end
	
	_RemoveBlips()
	
--~ 	if g_crateRevealed == true then
--~ 		FOW_UnRevealArea(g_dropPoint, 5)
--~ 		g_crateRevealed = false	
--~ 		
--~ 		if crateID ~= nil then
--~ 			HintPoint_Remove(crateID)
--~ 		
--~ 		end
--~ 		
--~ 	end
	
	
	Event_Timer(EventHandler_StartIntel, {intel = EVENTS.AirDropInc}, g_dropTimerWarningValue)
	--Event_Timer(Select_Drop_Zone, nil, g_dropTimerValue)
	Rule_AddDelayedInterval(Select_Drop_Zone, g_dropTimerValue, 1)
end

-- Create a new team to grab the fuel (AI)
function _generateFuelGrabTeam()
	local spawn = World_GetClosest(g_dropPoint, t_mapEntryPoints)
	
	local randomFuelEncounter = 1
	
	if t_fuelGrabTable ~= nil then
	
		randomFuelEncounter = World_GetRand(1, table.getn(t_fuelGrabTable))
	end
	
	print(spawn)
	--g_fuelTeam = ENCOUNTERS.ai_grab_fuel(spawn)
	g_fuelTeam = t_fuelGrabTable[randomFuelEncounter].encounter(spawn)
		
	sgroup = g_fuelTeam:GetSgroup()
	
	Event_GroupIsDead(_pickupGroupDied, nil, sgroup, 30)
	
end

-- Once the team has moved to the dropzone, order them to pickup the drop
function Capture_Fuel_Reserves(encounter)
	sgroup = encounter:GetSgroup()
	AI_LockSquads(player2, sgroup)
	encounter:Disable()

	_pickupFuel(sgroup)
end

-- Delayed order to pickup the fuel
function _pickupFuel(sgoup)
	if SGroup_IsEmpty(sgroup) == false then
		Command_SquadEntity(player2, sgroup, SCMD_PickUpSlotItem, eg_supplies, false)
		
		--Event_GroupIsDead(_pickupGroupDied, nil, sgroup)
	end
end

-- When the group dies, handle any potential respawn
function _pickupGroupDied()
	if EGroup_IsEmpty(eg_supplies) == false then
		-- Supplies still there
		if SGroup_IsEmpty(sg_fuelGrabTeam) == true or SGroup_IsAlive(sg_fuelGrabTeam) == false then
			_generateFuelGrabTeam()
		end
	end
end

-- Collect all enemy owned map entry points
function Collect_Map_Entry()
	Player_GetAll(player2, sg_allsquads, eg_mapEntry)
	
	EGroup_Filter(eg_mapEntry, BP_GetEntityBlueprint("map_entry_point"), FILTER_KEEP)
	
	local _insert = function(gid, idx, eid)
		table.insert(t_mapEntryPoints, eid)
	end
	
	EGroup_ForEachEx(eg_mapEntry, _insert, true, true)
end



-----------------------------------------------------
-- TEMP SCRIPT TO SIMULATE WATCHTOWER FUNCTIONALITY--
-----------------------------------------------------
-- grabs all available VPs or other stuff on the map for use as mode's focal points
function CollectVPs()
	local eg_tempAllStratPoints = EGroup_CreateIfNotFound("eg_tempAllStratPoints")
	World_GetStrategyPoints(eg_tempAllStratPoints, true)
	
	-- filters out possible entities that can be used as focal points.  For now, VPs, watchtowers will be checked.
	EGroup_Filter(eg_tempAllStratPoints, {BP_GetEntityBlueprint("victory_point"), BP_GetEntityBlueprint("watchtower"), BP_GetEntityBlueprint("tow_kalach_watchtower"), BP_GetEntityBlueprint("watchtower_battle"), },FILTER_KEEP)	
	EGroup_AddEGroup(eg_watchtowers, eg_tempAllStratPoints)
--~ 	Modify_SightRadius(eg_watchtowers, 10)

end

-- categorizes the focal points to be player owned, neutral, or enemy owned.
function SortOwnedVPs()
	
	EGroup_Clear(eg_nonCPUWatchtowers)
	EGroup_Clear(eg_unownedWatchtowers)
	EGroup_Clear(eg_enemyOwnedWatchtowers)
	
	local _filterOwnedPoints = function(gid, idx, eid)
	
		if Player_OwnsEntity(player2, eid) == true then
			EGroup_Add(eg_enemyOwnedWatchtowers, eid)
		elseif Player_OwnsEntity(player1, eid) == true then
			EGroup_Add(eg_playerOwnedWatchtowers, eid)
			EGroup_Add(eg_nonCPUWatchtowers, eid)
		else
			EGroup_Add(eg_unownedWatchtowers, eid)
			EGroup_Add(eg_nonCPUWatchtowers, eid)
		end
		
	end	
	-- do the sorting
	
	EGroup_ForEach(eg_watchtowers, _filterOwnedPoints)
end

-- checks to see if player is close enough to see crates - if so, make it more visible with an objective UI element
function PlayerSeeCrates()
	if EGroup_IsEmpty(eg_supplies) == false then
	
		if (Prox_PlayerSquadsInProximityOfEntities(player1, eg_supplies, 15, ANY) or Player_CanSeeEGroup(player1, eg_supplies, ANY)) and g_crateRevealed == false then
		
--~ 			if crateID == nil then
--~ 		
--~ 				crateID = HintPoint_Add(eg_supplies, true, LOC("Airdrop Crate"))				
--~ 		
--~ 			end
				if crateID == nil then
					
					--crateID = HintPoint_Add(eg_supplies, true, LOC("Airdrop Crate"))		
					crateID = Objective_AddUIElements(OBJ_Victory, EGroup_GetPosition(eg_supplies), true, 11075856, true, 1)  -- LOCDB [11075856] 'Capture this crate'
					
					
				end
			g_crateRevealed = true
			_RemoveBlips()
		elseif (Prox_PlayerSquadsInProximityOfEntities(player1, eg_supplies, 15, ANY) == false and Player_CanSeeEGroup(player1, eg_supplies, ANY) == false) and g_crateRevealed == true then
		
--~ 			if crateID ~= nil then
--~ 			
--~ 				HintPoint_Remove(crateID)
--~ 				crateID = nil
--~ 			
--~ 			end		

			if crateID ~= nil then
				Objective_RemoveUIElements(OBJ_Victory, crateID)
				--HintPoint_Remove(crateID)
				crateID = nil
			end			
			_AddBlips()
			g_crateRevealed = false
			
		end
		
	else
		Rule_RemoveMe()
	end
end

-- reveal the area at the crates if they are within a certain distance of the VPs/watchtowers and exist, and if they don't exist (picked up) the area is unrevealed, and add UI to point them out.
function ShowCrates()
	if EGroup_IsEmpty(eg_supplies) == false then
		local _measureVPDistanceToDrop = function(gid, idx, eid)
		
			if 	g_crateRevealed == false then
				
				if Player_OwnsEntity(player1, eid) and Util_GetDistance(eid, g_dropPoint) < g_detectRadius then
					
					g_savedRevealPos = EGroup_GetPosition(eg_supplies)
					FOW_RevealArea(g_savedRevealPos, t_difficulty.viewArea, -1)

					
					g_crateRevealed = true
					
					if crateID == nil then
						
						--crateID = HintPoint_Add(eg_supplies, true, LOC("Airdrop Crate"))		
						crateID = Objective_AddUIElements(OBJ_Victory, EGroup_GetPosition(eg_supplies), true, 11075857, true, 1)  -- LOCDB [11075857] 'Capture this crate'
						
						_RemoveBlips()
					end
					
					
				end				
			
			elseif 	g_crateRevealed == true then
			
				if Player_OwnsEntity(player1, eid) == false and Util_GetDistance(eid, g_dropPoint) < g_detectRadius then
				
					if crateID ~= nil then
						Objective_RemoveUIElements(OBJ_Victory, crateID)
						--HintPoint_Remove(crateID)				
						crateID = nil				
						_AddBlips()
					end
					g_crateRevealed = false
					if g_savedRevealPos ~= nil then
						FOW_UnRevealArea(g_savedRevealPos, 15)
					end
				end	
			end
		end
		
		if EGroup_IsEmpty(eg_watchtowers) == false then
			EGroup_ForEach(eg_watchtowers, _measureVPDistanceToDrop)
		end
	else
		print("supplies gone")
		if g_crateRevealed == true then
		
			if crateID ~= nil then
				Objective_RemoveUIElements(OBJ_Victory, crateID)
				--HintPoint_Remove(crateID)				
				crateID = nil				
			end
			g_crateRevealed = false
			if g_savedRevealPos ~= nil then
				FOW_UnRevealArea(g_savedRevealPos, 15)
			end
		end
		
		Rule_RemoveMe()
	end

end



----------------------------
--Watchtower Enemy Control--
----------------------------

function WatchtowerEnemyControl()

	if g_towerTeam == nil or SGroup_IsEmpty(sg_watchtowerEnemy) then
	
		_getRandomWatchtower()
		
		if EGroup_IsEmpty(eg_randomWatchtower) == false then
		
			Event_Timer(_generateWatchtowerTeam, {}, 30)
			Rule_AddDelayedInterval(WatchtowerEnemyChecker, 35, 1)
			
			Rule_RemoveMe()
		end
--~ 	elseif g_towerTeam ~= nil and SGroup_IsEmpty(sg_watchtowerEnemy) then
--~ 	
--~ 		if SGroup_IsIdle(sg_watchtowerEnemy, ALL) then
--~ 		
--~ 			Choose_New_Watchtower_Target()
--~ 		end
--~ 	
	
	end
end

function WatchtowerEnemyChecker()

	if g_towerTeam == nil or SGroup_IsEmpty(sg_watchtowerEnemy) then
		Rule_AddInterval(WatchtowerEnemyControl, 1)
		Rule_RemoveMe()

	end
	
end

function _getRandomWatchtower()
	
	SortOwnedVPs() -- grabs current state of VPs
	
	-- randomly choose an unowned watchtower or a player owned watchtower
	if EGroup_IsEmpty(eg_nonCPUWatchtowers) == false then
	
		EGroup_Add(eg_randomWatchtower, EGroup_GetRandomSpawnedEntity(eg_nonCPUWatchtowers))
		
	end
end

-- Create a new team to intercept the watchtowers
function _generateWatchtowerTeam()
	local _nodeStrength = XP1_GetNodeStrength()
	--local spawn = World_GetClosest(mkr_in_the_blind, t_mapEntryPoints)
	g_towerTeam = t_interceptorTable[XP1_GetNodeStrength()].encounter(mkr_watchtowerEntryPoint)
end

-- Once the team has moved to the tower, order them find another target if applicable
function WatchtowerCheckKickoff()

	Rule_AddDelayedInterval(Choose_New_Watchtower_Target, 1, 1)

end

function Choose_New_Watchtower_Target()

	if g_towerTeam == nil or SGroup_IsEmpty(sg_watchtowerEnemy) then
		
		Rule_RemoveMe()
		
	else
		
		if EGroup_IsEmpty(eg_randomWatchtower) == false and EGroup_IsCapturedByPlayer(eg_randomWatchtower, player2, ALL) then
			
			EGroup_Clear(eg_randomWatchtower)
			
			_getRandomWatchtower()
			
			if SGroup_IsEmpty(sg_watchtowerEnemy) == false and EGroup_IsEmpty(eg_randomWatchtower) == false then
			-- tell sg_fuelGrabTeam to grab the new supply location
				if g_towerTeam ~= nil then
					
					local sgroup = g_towerTeam:GetSgroup()	
					g_towerTeam:Enable()
					AI_LockSquads(player2, sgroup)
					GOALS.ai_watchtowerDefense(g_towerTeam, eg_randomWatchtower)
					Rule_RemoveMe()
				end
				
			elseif EGroup_IsEmpty(eg_randomWatchtower) == true then
				
				-- release to AI for the time being
				-- fire off randomWatchtower checker
				
				local sgroup = g_towerTeam:GetSgroup()	
				g_towerTeam:Disable()
				AI_UnlockSquads(player2, sgroup)
				Rule_AddInterval(WatchtowerEnemyTowerChecker, 5)
				
				Rule_RemoveMe()
			end
			
		end
	end
end

--function to check to see if eg_randomWatchtower has something here
-- then it kicks off new behaviour if squad exists
function WatchtowerEnemyTowerChecker()

	if g_towerTeam == nil or SGroup_IsEmpty(sg_watchtowerEnemy) then
		
		Rule_RemoveMe()
		
	elseif g_towerTeam ~= nil and SGroup_IsEmpty(sg_watchtowerEnemy) == false then
		
		_getRandomWatchtower()
		
		if EGroup_IsEmpty(eg_randomWatchtower) == false then
			
			-- give control back to encounter
			if g_towerTeam ~= nil then
				local sgroup = g_towerTeam:GetSgroup()	
				AI_LockSquads(player2, sgroup)
				g_towerTeam:Enable()
				GOALS.ai_watchtowerDefense(g_towerTeam, eg_randomWatchtower)
			end
			
			Rule_RemoveMe()		
		end
		
	end
	
end





-- WIN/LOSS


-- continual calculation of mission success, otherwise we'd have to repeat using this check for every situation where the game ends - it should instead be constantly updated in case.
function CalculateSuccess()
	
	if g_german_captures <= 0 then
		XP1_SetMissionSuccessLevel(3)
	elseif g_german_captures <= 3 then
		XP1_SetMissionSuccessLevel(2)
	else
		XP1_SetMissionSuccessLevel(1)
	end
	
--~ 	print("*** SUCCESS LEVEL ***")
--~ 	print(XP1_GetMissionSuccessLevel())
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
function Mission_Won_Speech()
	if Event_IsAnyRunning() == false then	
		print("victory")
		Rule_RemoveMe()
		Util_StartIntel(EVENTS.Victorious)
		Objective_Complete(OBJ_Victory, false, true)
		Rule_AddInterval(Mission_Complete, 1)
	end
end

function Mission_Lost_Speech()
	if Event_IsAnyRunning() == false then	
		print("defeat")
		Rule_RemoveMe()
		Util_StartIntel(EVENTS.Defeated)
		Objective_Fail(OBJ_Victory, false, true)
		Rule_AddInterval(Mission_Fail, 1)
	end
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
		
--~ 	Util_CreateEntities(player2, eg_mines, EBP.WEST_GERMAN.SCHU_MINE_42_MP, mkr_mines_1,  1)
--~ 	Util_CreateEntities(player2, eg_mines, EBP.WEST_GERMAN.SCHU_MINE_42_MP, mkr_mines_2,  1)
--~ 	Util_CreateEntities(player2, eg_mines, EBP.WEST_GERMAN.SCHU_MINE_42_MP, mkr_mines_3,  1)
--~ 				
--~ 	Util_CreateEntities(player2, eg_mines, EBP.WEST_GERMAN.SCHU_MINE_42_MP, mkr_mines_4,  1)
--~ 	Util_CreateEntities(player2, eg_mines, EBP.WEST_GERMAN.SCHU_MINE_42_MP, mkr_mines_5,  1)
--~ 	Util_CreateEntities(player2, eg_mines, EBP.WEST_GERMAN.SCHU_MINE_42_MP, mkr_mines_6,  1)

--~ 					
--~ 	Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER_MP, mkr_post_1,  1)
--~ 	Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER_MP, mkr_post_2,  1)
--~ 	Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER_MP, mkr_post_3,  1)
--~ 	Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER_MP, mkr_post_4,  1)
--~ 				
--~ 	Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER_MP, mkr_post_5,  1)
--~ 	Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER_MP, mkr_post_6,  1)
--~ 	Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER_MP, mkr_post_7,  1)
--~ 	Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER_MP, mkr_post_8,  1)
--~ 					
		----Pre placed enemy howitzer-----
					
				
--~ 	RandomBunker() ------function that places random bunkers on the map------
--~ 	
--~ 	Rule_AddOneShot(CreateHowy, 300)
		
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
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.AXIS_BUNKER_STARTING_POSITION_MP, marker,  1)
		end
		
	end


----------------------------function that creates a howitzer for node strength 5---------------------------
	
function CreateHowy()

	Util_CreateSquads(player2, sg_e_all, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY_MP, mkr_arty)


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




----------------------------------------------------------------------------------------------------------Air support for the ai on different node strengths--------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function AirSupport()

	Player_SetAbilityAvailability (player2, ABILITY.GERMAN.STUKA_BOMBING_STRIKE_TOW, ITEM_UNLOCKED)
	Player_SetAbilityAvailability (player2, ABILITY.GERMAN.STUKA_SMOKE_BOMB, ITEM_UNLOCKED)
	Player_SetAbilityAvailability (player2, ABILITY.GERMAN.STUKA_AIR_RECON, ITEM_UNLOCKED)
	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_BOMBING_STRIKE_TOW)
	Player_AddAbility(player2, IN_THE_BLIND_DROP_ABIL)
	Player_AddAbility(player1, ABILITY.WEST_GERMAN.AIRBORNE_ASSAULT)
	
	
end



----------------------------------grants the ai with different air support abilities based on node strength---------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------


function AirSupport()

	if XP1_GetNodeStrength() == 2 then

	
	
	elseif XP1_GetNodeStrength() == 3 then
	
	Player_SetResource ( player2, RT_Command, 15 )
	
--~ 	Player_AddAbility(player2, ABILITY.GERMAN.AIR_DROPPED_MEDICAL_SUPPLIES)
--~ 	Player_CompleteUpgrade(player2, UPG.GERMAN.AIR_DROP_MEDICAL_SUPPLIES)
	
	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_AIR_RECON)
	Player_CompleteUpgrade(player2, UPG.GERMAN.RECON_PLANE)
	
	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_SMOKE_BOMB)
	Player_CompleteUpgrade(player2, UPG.GERMAN.STUKA_SMOKE_BOMB)
	
	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_STRAFING_RUN)
	Player_CompleteUpgrade(player2, UPG.GERMAN.STUKA_STRAFE)
	
	elseif XP1_GetNodeStrength() == 4 then
	
	Player_SetResource ( player2, RT_Command, 15 )
	
--~ 	Player_AddAbility(player2, ABILITY.GERMAN.AIR_DROPPED_MEDICAL_SUPPLIES)
--~ 	Player_CompleteUpgrade(player2, UPG.GERMAN.AIR_DROP_MEDICAL_SUPPLIES)
	
	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT)
	Player_CompleteUpgrade(player2, UPG.GERMAN.STUKA_CLOSE_AIR_SUPPORT)
	
	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_STRAFING_RUN)
	Player_CompleteUpgrade(player2, UPG.GERMAN.STUKA_STRAFE)
	
	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_INCENDIARY_BOMBS)
	Player_CompleteUpgrade(player2, UPG.GERMAN.STUKA_FLAME_STRIKE)
	
	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_AIR_RECON)
	Player_CompleteUpgrade(player2, UPG.GERMAN.RECON_PLANE)
	
	elseif XP1_GetNodeStrength() == 5 then
	
	Player_SetResource ( player2, RT_Command, 15 )
	
--~ 	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_BOMBING_STRIKE)
--~ 	Player_CompleteUpgrade(player2, UPG.GERMAN.STUKA_BOMBING_RUN_UPGRADE)

	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB)
	Player_CompleteUpgrade(player2, UPG.GERMAN.STUKA_FRAGMENTATION_BOMB)

	
	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_AERIAL_SUPERIORITY_CLOSE_AIR_SUPPORT)
	Player_CompleteUpgrade(player2, UPG.GERMAN.AERIAL_SUPERIORITY_STUKA_CLOSE_AIR_SUPPORT)
	
	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_STRAFING_RUN)
	Player_CompleteUpgrade(player2, UPG.GERMAN.STUKA_STRAFE)
	
	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_AIR_RECON)
	Player_CompleteUpgrade(player2, UPG.GERMAN.RECON_PLANE)
	
	
	end
end




--------------------------------------specific unit support for different node strengths----------------------------------------------


function Support()

	if XP1_GetNodeStrength() >= 2 then
	
	Rule_AddInterval(CreatePanzer, 500)
		
	end
end



function CreatePanzer()


	
	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, mkr_reverseHardpoint_point1)
	

end
	

----last minute difficulty changes to make battle harder on hard---

function HardElements0()
	
	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, mkr_reverseHardpoint_point1)
	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_reverseHardpoint_point1)

end

function HardElements1()

	Player_AddResource(player2, RT_Manpower, 150)
	Player_AddResource(player2, RT_Fuel, 40)
	Player_AddResource(player2, RT_Munition, 60)
	
	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, mkr_reverseHardpoint_point1)
	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_reverseHardpoint_point1)

end

function HardElements2()

	Player_AddResource(player2, RT_Manpower, 200)
	Player_AddResource(player2, RT_Fuel, 60)
	Player_AddResource(player2, RT_Munition, 80)
	
	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.PANZER_IV_AUSF_J_BATTLE_GROUP_MP, mkr_reverseHardpoint_point1)
	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_reverseHardpoint_point1)

end

function HardElements3()

	Player_AddResource(player2, RT_Manpower, 200)
	Player_AddResource(player2, RT_Fuel, 50)
	Player_AddResource(player2, RT_Munition, 80)
	
	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.PANZER_IV_AUSF_J_BATTLE_GROUP_MP, mkr_reverseHardpoint_point1)
	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.LE_IG_18_INF_SUPPORT_GUN_SQUAD_MP, mkr_reverseHardpoint_point1)

end

	
	-------------------------------------------------------------------------
-- [[ MISSION END ]]
-------------------------------------------------------------------------
--This function is called by the Win conditions scar file. 
--See .../scar/WinConditions/vpplusannihilate.scar or .../none.scar
function WinConditionEndCallback(winningTeam)
	if(Player_GetTeam(player1) == winningTeam) then
		if Objective_IsComplete(SOBJ_DepleteFuel) == false then
			Objective_Complete(SOBJ_DepleteFuel)
		end
	else
		if Objective_IsFailed(SOBJ_DepleteFuel) == false then
			Objective_Fail(SOBJ_DepleteFuel)
		end
	end
end
