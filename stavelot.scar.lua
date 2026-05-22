print("\tLoading mission file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Stavelot
-- Designer: A.Molina
-------------------------------------------------------------------------
-------------------------------------------------------------------------
import("ScriptSetup.scar") -- <== ### CRITICAL ELEMENT. 
import("XP1.scar")				-- Ardennes Assault functionality

import("Stavelot_obj_SecureFuel.scar") -- [[ Objective files ]]
import("Stavelot_encounters.scar") -- [[ Encounter data ]]

-------------------------------------------------------------------------
-- [[ MISSION SETUP ]]
-------------------------------------------------------------------------
-- Initializes players
function Mission_SetupPlayers()
	--Player references
	player1 = Setup_Player(1, 11073202, "aef", 1)				-- player1 is always the human player
	player2 = Setup_Player(2, 11073205, "west_german", 2)		-- player2 is always the AI opponent --TODO: Set as west_german
	player3 = Setup_Player(3, 11073202, "aef", 1)				-- player3 is always the AI ally
end

-- Defines key mission data and any global values used throughout the mission.
function Mission_SetupVariables()
	print("Initializing mission DATA...")
	
	--Global mission data
	g_missionData = {
		useBeginnerHints = false,					-- Wether or not to use the BeginnerHint system
		useEncounterSystem = true,					-- Whether or not to use the Encounter system
		useXP1Difficulty = true,					-- Whether or not this mission uses the XP1 Difficulty system
		missionType = MT_XP1_CHALLENGE,				-- What Mission Type is this mission? MT_
		introNIS = "XP1/Stavelot_A_Intro",
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
			OBJ_SecureFuel,							-- These are the global references to the objective tables defined in the separete files.
		},
		startingUnits = {						-- Units to be spawned for P1 on mission start. Follows same parameters as Encounters.
			{
				sbp = SBP.AEF.M8_GREYHOUND_SQUAD_MP,
				spawn = mkr_company_startUnit_spawn_03,
			}
		},
		secondaryObjectives = {
			{
				obj = SecondaryOBJ_KillVIP,
				data = {
					spawns = false, -- Initialized in Mission_Preset()
					protectEncounter = ENCOUNTERS.protectVIP,
				},
			},
			{
				obj = SecondaryOBJ_DestroyTank,
				data = {
					spawns = false, -- Initialized in Mission_Preset()
					protectEncounter = ENCOUNTERS.protectTank,
				},
			},
			{
				obj = SecondaryOBJ_RescueSquads,
				data = {
					spawns = false, -- Initialized in Mission_Preset()
				},
			},
			{
				obj = SecondaryOBJ_CaptureIntel,
				data = {
					locations = false, -- Initialized in Mission_Preset()
					number_to_spawn = 2,
					number_to_capture = 2,
					base_area = mkr_baseArea,
				},
			},
		},
	}
	
	
	--[[GLOBAL VARIABLES]]
	sg_lure1 = SGroup_CreateIfNotFound("sg_lure1")		-- Units that get lured out to help back points
	sg_lure2 = SGroup_CreateIfNotFound("sg_lure2")		-- Units that get lured out to defend ruins
	sg_lureLeft = SGroup_CreateIfNotFound("sg_lureLeft")
	sg_lureRight = SGroup_CreateIfNotFound("sg_lureRight")
	
	sg_truckGroup = SGroup_CreateIfNotFound("sg_truckGroup")
	sg_flak_halftracks = SGroup_CreateIfNotFound("sg_flak_halftracks")
	
	sg_ruinsMortarLeft = SGroup_CreateIfNotFound("sg_ruinsMortarLeft")
	sg_ruinsMortarRight = SGroup_CreateIfNotFound("sg_ruinsMortarRight")
	sg_ruinsMortars = SGroup_CreateIfNotFound("sg_ruinsMortars")
	g_misisonOver = false
	
	
	t_pathTrucks = {									-- Waypoints/exit the supply trucks can follow to escape. Seeded in Mission_Preset()
		left = {
			{path = "pth_trucksLeft1", exitPt = mkr_eastRetreat, encounter = nil, arrowOrigin = mkr_leftArrow1Origin, arrowDest = mkr_leftArrow1Dest},
			{path = "pth_trucksLeft2", exitPt = mkr_retreat5, encounter = 1, arrowOrigin = mkr_leftArrow2Origin, arrowDest = mkr_leftArrow2Dest}, --ENCOUNTERS.NorthCrossroads()},
			{path = "pth_trucksLeft3", exitPt = mkr_retreat2, encounter = 1, arrowOrigin = mkr_leftArrow3Origin, arrowDest = mkr_leftArrow3Dest}, --ENCOUNTERS.NorthCrossroads()},
		},
		right = {
			{path = "pth_trucksRight1", exitPt = mkr_retreat4, encounter = 2, arrowOrigin = mkr_rightArrow1Origin, arrowDest = mkr_rightArrow1Dest}, --ENCOUNTERS.NorthWestCrossroads()},
			{path = "pth_trucksRight2", exitPt = mkr_retreat4, encounter = 2, arrowOrigin = mkr_rightArrow1Origin, arrowDest = mkr_rightArrow1Dest},--ENCOUNTERS.NorthWestCrossroads()},
			{path = "pth_trucksRight3", exitPt = mkr_retreat3, encounter = nil, arrowOrigin = mkr_rightArrow2Origin, arrowDest = mkr_rightArrow2Dest },
		},
	}
	-- There are initialized in Mission_Preset()
	eg_fuelLocation = false								-- The location of the fuel depot. 
	t_secondarySpawns = false							-- Possible secondary objective locations. 
	
	
	
	-- Node strength flags
	g_mortars = false				--  There will be Infantry Support Guns on the map
	g_flak_halftracks = false		-- There will be Flak Halftracks on the map
	g_tanks = false					-- There wil be enemy Panzers

	g_fueltruckSent = false
	--g_aboutToSpawn = true
	
	--[[MAP GROUPS]]
	-- LAYER_fuelPointLeft/Right	-- FuelDepot objects that get despawned based on map seed
	-- eg_fuelLeft/Right			-- Terr.Point for the fuel depot
	-- eg_garrisonFuelL/R			-- garrison point near corresponding depot
	-- eg_holdSupplyLeft			-- garrison on top-left territory
	-- eg_terrRuins					-- Ruins territory point
	-- eg_supplyTerrLeft/Right		-- Upper left/right territory points
	-- eg_terrPlaza					-- Territory point next to the player's base.
	
end

-- Defines difficulty tables/tuning variables
function Mission_SetDifficulty(diffVal)
	g_difficulty = diffVal or Game_GetSPDifficulty() 	-- Note: Having the diffVal parameter allows for redefining difficulty settings during runtime.
	AI_OverrideDifficulty(g_difficulty)
	
	--Global difficulty table
	t_difficulty = {
		evacTruckInterval = Util_DifVar({1.85*60, 1.35*60, 0.95*60}, g_difficulty), -- 1.85, 1.35. 0.95
		truckLoadDelay = Util_DifVar({18, 12, 6}, g_difficulty), -- 18, 12, 5
		capTimerLength = Util_DifVar({90, 90, 120}, g_difficulty),
		defenseRespawnTime = Util_DifVar({20, 15, 15}, g_difficulty),		
	}
	g_replaceUnitTime = t_difficulty.defenseRespawnTime -- time it takes for a replacement unit to spawn to reinforce fuel point
	
	--XP1 Dynamic Difficulty settings:
	PM_PL_StartingResourceHit = true
	PM_AI_CPDefenses = false
	PM_AI_Aggression = true
	PM_AI_Defensiveness = true
	
	-- NODE STRENGTH ---------------------------------------
	-- set flags for different levels of node strength
	if XP1_GetNodeStrength() >= 3 then
		g_mortars = true
	end
	
	if XP1_GetNodeStrength() >= 4 then
		g_flak_halftracks = true
	end
	
	if XP1_GetNodeStrength() >= 5 then
		g_tanks = true
	end
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
	Player_SetResource(player1, RT_Manpower, 500) --TODO: difftune?
	Player_SetResource(player1, RT_Fuel, 90)
	Player_SetResource(player1, RT_Munition, 100)
	
	Camera_ResetToDefault()
	Camera_MoveTo(mkr_camStart, false)
	
	--Make bridges invulnerable to prevent pathing issues
	EGroup_SetInvulnerable(eg_bridges, true)
	
	--Determine which variant of the mission will load
	-- 1: Fuel on Left side.
	-- 2: Fuel on Right side.
	local side = World_GetRand(1, 2)
	if Misc_IsCommandLineOptionSet("variant") then
		--For testing purposes only.
		side = tonumber(Misc_GetCommandLineString("variant"))
	end
--~ 	side = 2 --debug
	
	if side == 1 then
		-- Fuel is on the LEFT side of the map
		EGroup_DestroyAllEntities(LAYER_fuelPointRight)
		eg_fuelLocation = eg_fuelLeft
		g_truckDest = mkr_fuelTruckLeft
		g_truckSpawn = mkr_roadNorth
		g_truckDynSpawn = mkr_truckDynSpawnLeft
		g_defDest = mkr_defLeft
		g_defDynSpawn = mkr_defDynSpawnLeft
		t_pathTrucks = Table_GetRandomItem(t_pathTrucks.left)
		--secondary objective positions
		
		local t_secondarySpawns = {
			{spawn = mkr_secObj1, ui = mkr_supplyRight},
			{spawn = mkr_secObj2, ui = mkr_supplyRight},
			{spawn = mkr_secObj3, ui = mkr_supplyRight},
		}
		g_missionData.secondaryObjectives[1].data.spawns = t_secondarySpawns
		g_missionData.secondaryObjectives[2].data.spawns = t_secondarySpawns
		g_missionData.secondaryObjectives[3].data.spawns = {eg_holdSupplyRight}
		g_missionData.secondaryObjectives[4].data.locations = {mkr_fuelL_05, mkr_fuelL_mortar, mkr_fuelL_06, mkr_supplyLeft_02, mkr_supplyLeft}
		
	elseif side == 2 then
		-- Fuel is on the RIGHT side of the map
		EGroup_DestroyAllEntities(LAYER_fuelPointLeft)
		eg_fuelLocation = eg_fuelRight
		g_truckDest = mkr_fuelTruckRight		
		g_truckSpawn = mkr_roadSouth
		g_truckDynSpawn = mkr_truckDynSpawnRight
		g_defDynSpawn = mkr_defDynSpawnRight
		g_defDest = mkr_defRight
		t_pathTrucks = Table_GetRandomItem(t_pathTrucks.right)
		
		local t_secondarySpawns = {
			{spawn = mkr_supplyLeft_02, ui = mkr_supplyLeft_01},
			{spawn = mkr_supplyLeft, ui = mkr_supplyLeft_01},
			{spawn = mkr_supplyLeft_03, ui = mkr_supplyLeft_01},
		}
		g_missionData.secondaryObjectives[1].data.spawns = t_secondarySpawns
		g_missionData.secondaryObjectives[2].data.spawns = t_secondarySpawns
		g_missionData.secondaryObjectives[3].data.spawns = {eg_holdSupplyLeft}
		g_missionData.secondaryObjectives[4].data.locations = {mkr_fuelR_03, mkr_fuelR_04, mkr_fuelR_01, mkr_supplyRight_01, mkr_secObj3}
	end
end


-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
--Called once the intro nis/nislet/sitrep finishes playing.
function Mission_Start()
	Event_NarrativeEventsNotRunning(EventHandler_ObjectiveStart, {objective = OBJ_SecureFuel}, 1)
	SpawnStartingEncounters()
	SetEncounterEvents()
end

--Spawns encounters on map
function SpawnStartingEncounters()
	g_enc_plaza = ENCOUNTERS.plaza()
	
	g_enc_ruins = ENCOUNTERS.ruins()
	g_enc_ruinsMortar1 = ENCOUNTERS.ruinsMortar1()
	g_enc_ruinsAT = ENCOUNTERS.ruinsAT()	
	
	g_enc_fuelLeft = ENCOUNTERS.fuelLeft()
	g_enc_fuelLeftPerimeter = ENCOUNTERS.fuelLeftPerimeter()
	
	g_enc_fuelRight = ENCOUNTERS.fuelRight()
	g_enc_fuelRightPerimeter = ENCOUNTERS.fuelRightPerimeter()
	
	g_enc_fuelStatic = ENCOUNTERS.fuelStaticWeapons()

	g_enc_supplyRight = ENCOUNTERS.SupplyRight()
	
	g_enc_supplyLeft = ENCOUNTERS.SupplyLeft()
	
	if t_pathTrucks.encounter ~= nil then
		if t_pathTrucks.encounter == 1 then		
			g_enc_northGuard = ENCOUNTERS.NorthCrossroads()
		elseif t_pathTrucks.encounter == 2 then
			g_enc_northGuard = ENCOUNTERS.NorthWestCrossroads()
		end		
	end
	
	-- decreases the range of the left infantry support gun in the ruins slightly, so that it doesn't hit the building the Rescue the Allies occurs in
	-- side effect is that ALL infantry support guns that use the ability will be affected but since there will always only be one or two, it's not that big of a deal on this map
	if SGroup_IsEmpty(sg_ruinsMortarLeft) == false and SGroup_IsAlive(sg_ruinsMortarLeft) then	
		--Modify_WeaponRange(sg_ruinsMortarLeft, "hardpoint_01", 0.50) 	
		Modify_AbilityMaxCastRange(player2,  ABILITY.WEST_GERMAN.LE_IG_18_BARRAGE_WG_MP, 0.85)
	end
	
end

--Creates any additional events that can trigger encounter responses.
function SetEncounterEvents()
	
	--On Engage, add unit to supply point encounter
	if(eg_fuelLocation == eg_fuelRight) then
		Event_IsEngaged(ReinforceSupplyRight, nil, g_enc_supplyRight:GetSgroup(), ANY, 3, 3)
		Event_IsEngaged(EventHandler_StartIntel, {intel = EVENTS.WarnDepotAttacked}, g_enc_fuelRight:GetSgroup(), ANY, 3, 3.0)
		
		Event_Proximity(ReinforceFuelRight, nil, player1, eg_fuelLocation, 13, ANY, 1.5)
		
	elseif(eg_fuelLocation == eg_fuelLeft) then
		Event_IsEngaged(ReinforceSupplyLeft, nil, g_enc_supplyLeft:GetSgroup(), ANY, 3, 3)
		Event_IsEngaged(EventHandler_StartIntel, {intel = EVENTS.WarnDepotAttacked}, g_enc_supplyLeft:GetSgroup(), ANY, 3, 3.0)
		
		Event_Proximity(ReinforceFuelLeft, nil, player1, eg_fuelLocation, 13, ANY, 1.5)
	end
	
	--Reinforce ruins when low health.
	Event_OnHealth(TankRuins, nil, g_enc_ruins:GetSgroup(), 0.40, false)
	
	--Warn halftracks
	if g_flak_halftracks then
		Event_PlayerCanSeeElement(EventHandler_StartIntel, {intel = EVENTS.WarnFlakHalftrack}, player1, sg_flak_halftracks, ANY)
	end
	
	-- Start secondary objective on trigger
	local _eventProx = Event_Proximity(StartSecondaryObj, nil, player1, mkr_triggerSecObj, nil, ANY)
	local _eventOwns = Event_PlayerOwnsTerritory(StartSecondaryObj, nil, player1, eg_terrPlaza, ANY)
	Event_CreateOR(StartSecondaryObj, nil, {_eventProx, _eventOwns}, 1)
end


---------------------------
--Events
---------------------------
--Bring in a tank to attack the Ruins area
function TankRuins(data)
	g_enc_tankRuins = ENCOUNTERS.tankRuins()
	
	-- Syphon sg_lure2 from the depot defend encounter and send it to protect the ruins
	if(eg_fuelLocation == eg_fuelRight) then
		if(not g_enc_fuelRight:HasGoal() and SGroup_CountSpawned(sg_lureRight) > 0) then
			g_enc_fuelRight:RemoveUnitsBySgroup(sg_lureRight)
			g_enc_ruins:AddSgroup(sg_lureRight)
		end
	elseif(eg_fuelLocation == eg_fuelLeft) then
		if(not g_enc_fuelLeft:HasGoal() and SGroup_CountSpawned(sg_lureLeft) > 0) then
			g_enc_fuelLeft:RemoveUnitsBySgroup(sg_lureLeft)
			g_enc_ruins:AddSgroup(sg_lureLeft)
			
		end
	end
end

--Sends support units to reinforce supply point when it comes under attack
function ReinforceSupplyRight(data)
	g_enc_reinforceRight = ENCOUNTERS.ReinforceSupplyRight()
	
	--Take the scout car from the depot defend encounter and send it to assist the back territory
	if(not g_enc_fuelRight:HasGoal() and SGroup_CountSpawned(sg_lure1) > 0) then
		g_enc_fuelRight:RemoveUnitsBySgroup(sg_lure1)
		g_enc_reinforceRight:AddSgroup(sg_lure1)
		
	end
end

function ReinforceSupplyLeft(data)
	g_enc_reinforceLeft = ENCOUNTERS.ReinforceSupplyLeft()
	
	--Take the scout car from the depot defend encounter and send it to assist the back territory
	if(not g_enc_fuelLeft:HasGoal() and SGroup_CountSpawned(sg_lure1) > 0) then
		g_enc_fuelLeft:RemoveUnitsBySgroup(sg_lure1)
		g_enc_reinforceLeft:AddSgroup(sg_lure1)
		
	end
end

--Send in reinforcements when the player is close to capping the fuel point
function ReinforceFuelLeft()
	Util_StartIntel(EVENTS.WarnFuelReinforcements)
	g_enc_reinforceFuel = ENCOUNTERS.ReinforceFuel(mkr_roadNorth, eg_fuelLeft)
end

function ReinforceFuelRight()
	Util_StartIntel(EVENTS.WarnFuelReinforcements)
	g_enc_reinforceFuel = ENCOUNTERS.ReinforceFuel(mkr_roadSouth, eg_fuelRight)
end


----------------------------------
-- Secondary objectives
----------------------------------
function StartSecondaryObj()
	Mission_StartSecondaryObjective(true, false)
end





-------------------------------------------------------------------------
-- UTIL FUNCTIONS
-------------------------------------------------------------------------
function Despawn(enc)
	enc:ClearGoal()
	enc:RemoveOnDeath(true)
	SGroup_DestroyAllSquads(enc.sgroup)
end

--Debug. Insta-cap a selected territory point.
function Capture(player)
	if Misc_IsCommandLineOptionSet("dev") then
		local point = Util_Grab()
		if point ~= nil then
			EGroup_InstantCaptureStrategicPoint(point, player)
		end
	end
end

function ReplaceUnit(unit)

	local enc = unit.encounter	
	Event_Timer(ReplaceUnit_PartB, {_unit = unit}, g_replaceUnitTime)		
	
end

function ReplaceUnit_PartB(data)
	
	local unit = data._unit
	local enc = unit.encounter
	enc:AddUnit(unit.data)
		
	if(not enc:Goal_HasValidObjective()) then
		enc:RestartGoal()
	end
end


--Debug. Testing AI resource guidance bug
function prepBug()
	if(Misc_IsCommandLineOptionSet("dev")) then
		eg_fuelLocation = eg_fuelLeft
	--~ 	eg_fuelLocation = eg_fuelRight
		g_enc_ruins = ENCOUNTERS.ruins()
		g_enc_fuelLeft = ENCOUNTERS.fuelLeft()
		Event_OnHealth(TankRuins, nil, g_enc_ruins:GetSgroup(), 0.40, false)
	end
end