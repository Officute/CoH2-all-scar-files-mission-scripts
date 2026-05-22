print("\tLoading mission file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- 1943 Challenge: MUD HUNT (a.k.a. Spring Rasputitsa)
-- Designer: NJR
-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScriptSetup.scar") -- <== ### CRITICAL ELEMENT. 

-- [[ Objective files ]]
import("1943_Mud_Hunt_Obj_FindAndDestroy.scar")
import("1943_Mud_Hunt_Obj_SingleTank.scar")			-- Not actually an objective, but a type of encounter covered by the FindAndDestroy objective
import("1943_Mud_Hunt_Obj_DoubleTank.scar")			-- As above
import("1943_Mud_Hunt_Obj_ElefantTank.scar")		-- As above
import("1943_Mud_Hunt_Obj_AbandonedTank.scar")		-- A bonus objective covers this type of encounter specifically, so that's included in here (but the encounter is also covered by the FindAndDestroy objective)

-- [[ Encounter data ]]
	--TODO: Import encounter data. 
	--Filename format: <scenarioName>_encounters.scar -- Eg. import("newTemplate_encounters.scar")



-------------------------------------------------------------------------
-- [[ MISSION SETUP ]]
-------------------------------------------------------------------------
-- Initializes players
function Mission_SetupPlayers()
	--TODO: Initialize your player variables. Depending on the type of scenario, this can vary.
	
	--For Missions/Challenges:
	player1 = Setup_Player(1, 11038758, "soviet", 1)		-- player1 is always the human player
	player2 = Setup_Player(2, 11038759, "german", 2)		-- player2 is always the AI opponent
	player3 = Setup_Player(3, 11038759, "german", 2)		-- player3 is the SkirmishAI half of the enemy
	
end

-- Defines key mission data and any global values used throughout the mission.
function Mission_SetupVariables()
	print("Initializing mission DATA...")
	
	--TODO: Define mission initialization data. Example in comments on the bottom of this file.
	-- ### CRITICAL ELEMENT. This table contains all the initialization data for the mission.
	g_missionData = {
		useBeginnerHints = false,						-- Wether or not to use the BeginnerHint system
		useEncounterSystem = true,						-- Whether or not to use the Encounter system
		introNIS = "tow_mudhunt",						-- Movie filename
		introNISlet = nil,					 			-- NISlet triggered after introNIS
		introNISletSkipped = nil,	 					-- Function called if the introNISlet is skipped
		introSitRep = nil,								-- Movie (string) to play after intro nislet
		endNISlet = nil,								-- NISlet triggered on mission completion
		endNIS = nil,									-- Movie (string) to play on mission completion
		missionSpeechPath = "theater_of_war/dlc2/c02",	-- Speech path to cache (string)
		precacheSounds = {								-- Any audio files you want precached (list of strings)
		},
		nisFiles = {									-- .nis files associated with the mission (path string)
		},
		nisInTransitionTime = 0,
		nisOutTransitionTime = 0,
		objectives = {									-- List of PARENT objective tables.
			OBJ_FindAndDestroy,							-- These are the global references to the objective tables defined in the separete files.
			OBJ_TanksEscaping,								
			OBJ_AbandonedTank,								
		}
	}
	
	
	--[[GLOBAL VARIABLES]]
	--TODO: Define any global egroups/sgroups and variables
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	sg_blah = SGroup_CreateIfNotFound("sg_blah")
	eg_temp = EGroup_CreateIfNotFound("eg_temp")
	eg_blah = EGroup_CreateIfNotFound("eg_blah")
	
	sg_watchtower_guys = SGroup_CreateIfNotFound("sg_watchtower_guys")
	
	elefant_index = 0
	abandoned_index = 0
	double_index = 0
	
	--[[MAP GROUPS]]
	--TODO: Document any egroups that are defined within the worldbuilder. For example:
	-- eg_bunkerP1: This egroup contains all the player-controlled bunkers placed on the map.
	
end



-- Defines difficulty tables/tuning variables
function Mission_SetDifficulty(diffVal)
	
	g_difficulty = diffVal or Game_GetSPDifficulty() 	-- Note: Having the diffVal parameter allows for redefining difficulty settings during runtime.
	AI_OverrideDifficulty(g_difficulty)
	
	--Global difficulty table
	t_difficulty = {
		num_elefant_encounters 		= Util_DifVar({1, 1, 1}, g_difficulty),					-- vary the number of each type of encounter by difficulty
		num_abandoned_encounters 	= Util_DifVar({1, 1, 1}, g_difficulty),
		num_double_encounters 		= Util_DifVar({2, 2, 3}, g_difficulty),
		num_single_encounters 		= Util_DifVar({4, 4, 3}, g_difficulty),
		time_limit_min				= Util_DifVar({10, 7.5, 5}, g_difficulty) * 60,			-- squads that come in to rescue tanks will get spawned between these times if they hadn't otherwise been triggered already
		time_limit_max				= Util_DifVar({30, 25, 20}, g_difficulty) * 60,
		target_number_tanks			= Util_DifVar({6, 7, 9}),								-- number of tanks the player needs to destroy
		starting_manpower			= Util_DifVar({400, 300, 200}),							-- starting resources
		starting_munitions			= Util_DifVar({200, 100, 50}),
		starting_fuel				= Util_DifVar({50, 40, 30}),
		start_roaming_squads		= Util_DifVar({2, 3, 4}, g_difficulty),					-- number of roaming squads allowed at the start of the mission 
		start_leftover_at_guns		= Util_DifVar({3, 2, 1}, g_difficulty),					-- number of recrewable atguns across the map at the start of the mission
		max_roaming_squads			= Util_DifVar({4, 6, 9}, g_difficulty),					-- number of roaming squads allowed at once (this increases over time)
		ai_topup_frequency			= Util_DifVar({75, 45, 30}, g_difficulty),
		tank_speedmodifier			= Util_DifVar({0.7, 0.8, 0.9}, g_difficulty),			-- enemy tanks get a speed modifier (as well as having to traverse mud)
		free_munitions_drops		= Util_DifVar({5, 3, 2}, g_difficulty)					-- free munitions drops scattered around the map on mission start
	}
	
end



-- Sets restrictions on units, teams, etc.
function Mission_SetupRestrictions()
	--TODO: Set any tech/ability restrictions on a players, as well as resource limits.
	--	Note: Resource Income/Caps should be defined in Mission_SetDifficulty()
	
	--[[ HUMAN PLAYER ]]
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.TANK_DEPOT, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.MOTORPOOL, ITEM_REMOVED)
	
	Cmd_Upgrade(player1, UPG.SOVIET.GUARD_TROOPS, nil, true)											-- guards unlocked, but can be ordered from the rifle command building NOT as a seperate ability
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.CMD_GUARD_TROOPS, ITEM_REMOVED)
	Player_AddAbility(player1, ABILITY.SOVIET.IL_2_BOMBING_RUN_SP)										-- bomb strike prepped, but only made available if player owns ALL the watchtowers
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.IL_2_BOMBING_RUN_SP, ITEM_REMOVED)

	if g_difficulty == GD_EASY then
		Cmd_Upgrade(player1, UPG.SOVIET.IL_2_RECON, nil, true)											-- air recon prepped and made available if playing on easy mode
		Player_SetAbilityAvailability(player1, ABILITY.SOVIET.IL_2_RECON, ITEM_UNLOCKED)
	end
	if g_difficulty == GD_EASY or g_difficulty == GD_NORMAL then
		Cmd_Upgrade(player1, UPG.SOVIET.FIRE_ARTILLERY, nil, true)										-- incendiary artillery prepped and made available if playing on easy or normal mode
		Player_SetAbilityAvailability(player1, ABILITY.SOVIET.FIRE_ARTILLERY, ITEM_UNLOCKED)
	end
	
--~ 	ToW_SetStandardResources(player1)
	
	--[[ ALLIED PLAYER ]]
	Cmd_Upgrade(player1, BP_GetUpgradeBlueprint("mud_digging_unlock"), 1, true)
	
	--[[ ENEMY PLAYER ]]
	Cmd_Upgrade(player2, BP_GetUpgradeBlueprint("mud_digging_unlock"), nil, true)
	
end

-- Sets up the map before the mission starts (starting units, ownership, etc.)
function Mission_Preset()
	--TODO: Make changes to the initial state of the map (spawn/despawn units or entities, diable holds, etc.).
	
	Camera_ResetToDefault()		-- there's a new default, but it takes this to reset the camera to it!
	Game_StartMuted(true)
	
	-- ToW year settings
	ToW_SetUpTechTreeByYear(player1, 1943)
	ToW_SetUpTechTreeByYear(player2, 1943)
	ToW_SetUpTechTreeByYear(player3, 1943)
	
	-- set up data for the potential encounter locations
	t_potentiallocations_elefant = {									-- the Elefant-in-the-mud encounter
		{location = mkr_location_01, removelocations = {mkr_location_01, mkr_location_07, mkr_location_24} },
		{location = mkr_location_02, removelocations = {mkr_location_02, mkr_location_16} },
		{location = mkr_location_08, removelocations = {mkr_location_08, mkr_location_16, mkr_location_24} },
	}
	t_potentiallocations_abandonedtank = {								-- the Abandoned-tank encounter
		{location = mkr_location_02, removelocations = {mkr_location_02, mkr_location_08, mkr_location_16} },
		{location = mkr_location_16, removelocations = {mkr_location_02, mkr_location_08, mkr_location_16} },
		{location = mkr_location_04, removelocations = {mkr_location_04, mkr_location_18, mkr_location_20} },
		{location = mkr_location_08, removelocations = {mkr_location_08, mkr_location_16, mkr_location_24} },
		{location = mkr_location_24, removelocations = {mkr_location_24, mkr_location_01, mkr_location_09, mkr_location_08}},
	}
	t_potentiallocations_double = {										-- the encounters with two tanks stuck next to each other
		{location = mkr_location_04, removelocations = {mkr_location_04, mkr_location_18, mkr_location_20} },
		{location = mkr_location_18, removelocations = {mkr_location_04, mkr_location_18} },
		{location = mkr_location_20, removelocations = {mkr_location_04, mkr_location_20, mkr_location_14} },
		{location = mkr_location_05, removelocations = {mkr_location_05, mkr_location_19} },
		{location = mkr_location_11, removelocations = {mkr_location_11, mkr_location_17, mkr_location_03} },
		{location = mkr_location_17, removelocations = {mkr_location_11, mkr_location_17} },
		{location = mkr_location_02, removelocations = {mkr_location_02, mkr_location_16} },
		{location = mkr_location_16, removelocations = {mkr_location_02, mkr_location_16, mkr_location_08} },
		{location = mkr_location_08, removelocations = {mkr_location_16, mkr_location_08} },
	}
	t_potentiallocations_single = {										-- the rest of the encounter locations - single vehicles
		{location = mkr_location_01, removelocations = {mkr_location_01, mkr_location_24}},
		{location = mkr_location_02, removelocations = {mkr_location_02, mkr_location_16}},
		{location = mkr_location_03, removelocations = {mkr_location_03, mkr_location_11, mkr_location_15}},
		{location = mkr_location_04, removelocations = {mkr_location_04, mkr_location_18, mkr_location_20}},
		{location = mkr_location_05, removelocations = {mkr_location_05, mkr_location_19, mkr_location_21}},
		{location = mkr_location_06, removelocations = {mkr_location_06}},
		{location = mkr_location_07, removelocations = {mkr_location_01, mkr_location_07, mkr_location_24}},
		{location = mkr_location_08, removelocations = {mkr_location_08, mkr_location_16, mkr_location_24}},
		{location = mkr_location_09, removelocations = {mkr_location_09, mkr_location_23, mkr_location_24, mkr_location_27}},
		{location = mkr_location_10, removelocations = {mkr_location_10, mkr_location_18}},
		{location = mkr_location_11, removelocations = {mkr_location_11, mkr_location_17, mkr_location_03, mkr_location_15, mkr_location_25}},
		{location = mkr_location_12, removelocations = {mkr_location_12, mkr_location_25}},
		{location = mkr_location_13, removelocations = {mkr_location_13, mkr_location_21, mkr_location_22}},
		{location = mkr_location_14, removelocations = {mkr_location_14, mkr_location_20, mkr_location_22}},
		{location = mkr_location_15, removelocations = {mkr_location_15, mkr_location_03, mkr_location_11, mkr_location_17, mkr_location_27}},
		{location = mkr_location_16, removelocations = {mkr_location_16, mkr_location_02, mkr_location_08}},
		{location = mkr_location_17, removelocations = {mkr_location_17, mkr_location_11, mkr_location_23, mkr_location_02}},
		{location = mkr_location_18, removelocations = {mkr_location_18, mkr_location_04, mkr_location_10, mkr_location_19}},
		{location = mkr_location_19, removelocations = {mkr_location_19, mkr_location_05, mkr_location_22, mkr_location_14}},
		{location = mkr_location_20, removelocations = {mkr_location_20, mkr_location_14, mkr_location_04, mkr_location_22, mkr_location_25}},
		{location = mkr_location_21, removelocations = {mkr_location_21, mkr_location_05, mkr_location_13}},
		{location = mkr_location_22, removelocations = {mkr_location_22, mkr_location_14, mkr_location_19, mkr_location_13}},
		{location = mkr_location_23, removelocations = {mkr_location_23, mkr_location_09, mkr_location_17, mkr_location_15}},
		{location = mkr_location_24, removelocations = {mkr_location_24, mkr_location_01, mkr_location_09, mkr_location_08}},
		{location = mkr_location_25, removelocations = {mkr_location_11, mkr_location_12, mkr_location_20, mkr_location_25}},
		{location = mkr_location_26, removelocations = {mkr_location_26}},
		{location = mkr_location_27, removelocations = {mkr_location_09, mkr_location_15, mkr_location_27}},
	}
	
	t_infantryspawnlocations = {
		mkr_rescuer_spawn1,
		mkr_rescuer_spawn2,
		mkr_rescuer_spawn3,
		mkr_rescuer_spawn4,
	}
	
	t_potentialmunitionsdrops = {
		mkr_munitionsdrop_01,
		mkr_munitionsdrop_02,
		mkr_munitionsdrop_03,
		mkr_munitionsdrop_04,
		mkr_munitionsdrop_05,
		mkr_munitionsdrop_06,
		mkr_munitionsdrop_07,
		mkr_munitionsdrop_08,
		mkr_munitionsdrop_09,
		mkr_munitionsdrop_10,
		mkr_munitionsdrop_11,
	}
	
	-- apply starting resources
	Player_SetResource(player1, RT_Munition, t_difficulty.starting_munitions)
	Player_SetResource(player1, RT_Manpower, t_difficulty.starting_manpower)	
	Player_SetResource(player1, RT_Fuel,  t_difficulty.starting_fuel)		
	Player_SetResource(player1, RT_Command, 10)
	
	-- some player-wide upgrades
	Cmd_InstantUpgrade(player1, UPG.SOVIET.HQ_ANTI_TANK_GRENADE, 1)
	Cmd_InstantUpgrade(player1, BP_GetUpgradeBlueprint("ptrs_better_balanced"), 1)
	
	-- add upgrades to the player's starting units
	Player_GetAll(player1)
	SGroup_Filter(sg_allsquads, SBP.SOVIET.GUARDS_TROOPS, FILTER_KEEP)
	for num = 1, math.ceil(SGroup_CountSpawned(sg_allsquads) / 2) do 
		SGroup_Remove(sg_allsquads, SGroup_GetRandomSpawnedSquad(sg_allsquads))
	end
	Cmd_InstantUpgrade(sg_allsquads, BP_GetUpgradeBlueprint("ptrs_41_at_rifle_package_guard_troop_better_balanced"))
	
	-- put guys in the towers 
	Util_CreateSquads(player2, sg_watchtower_guys, SBP.GERMAN.GRENADIER_SQUAD, eg_watchtower_north1, nil, 1, 2)
	Util_CreateSquads(player2, sg_watchtower_guys, SBP.GERMAN.GRENADIER_SQUAD, eg_watchtower_north2, nil, 1, 3)
	Modify_ReceivedDamage(sg_watchtower_guys, 3)
	Event_IsDoingAttack(EventHandler_StartIntel, {intel = EVENTS.EnemyWatchtowerSpotted}, sg_watchtower_guys, ANY, 2)
	
	-- and kick off a rule to manage the bonus for occupying all the watchtowers
	watchtower_bonus_available = false
	Rule_AddInterval(Mission_ManageWatchtowerBonus, 1)
	
	
end


-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
--Called once the intro nis/nislet/sitrep finishes playing.
function Mission_Start()

	-- pick the actual locations we will use this time
	t_elefant = {}
	for index = 1, t_difficulty.num_elefant_encounters do
		
		if #t_potentiallocations_elefant >= 1 then
			
			local choice = Table_GetRandomItem(t_potentiallocations_elefant)					-- Pick one of the potential locations for the Elefant encounter...
			table.insert(t_elefant, choice)
			
			Elefant_SetUp(choice)
			
			Locations_RemoveItem(t_potentiallocations_elefant, choice.removelocations)
			Locations_RemoveItem(t_potentiallocations_abandonedtank, choice.removelocations)
			Locations_RemoveItem(t_potentiallocations_double, choice.removelocations)
			Locations_RemoveItem(t_potentiallocations_single, choice.removelocations)
			
		end
		
	end
	
	t_abandonedtank = {}
	for index = 1, t_difficulty.num_abandoned_encounters do
		
		if #t_potentiallocations_abandonedtank >= 1 then
			
			local choice = Table_GetRandomItem(t_potentiallocations_abandonedtank)				-- and the abandoned tank encounter...
			table.insert(t_abandonedtank, choice)
			
			AbandonedTank_SetUp(choice)
			
			Locations_RemoveItem(t_potentiallocations_abandonedtank, choice.removelocations)
			Locations_RemoveItem(t_potentiallocations_double, choice.removelocations)
			Locations_RemoveItem(t_potentiallocations_single, choice.removelocations)
			
		end
		
	end
	
	t_double = {}
	for index = 1, t_difficulty.num_double_encounters do
		
		if #t_potentiallocations_double >= 1 then
			
			local choice = Table_GetRandomItem(t_potentiallocations_double)						-- and the double tank encounters...
			table.insert(t_double, choice)
			
			DoubleTank_SetUp(choice)
			
			Locations_RemoveItem(t_potentiallocations_double, choice.removelocations)
			Locations_RemoveItem(t_potentiallocations_single, choice.removelocations)
			
		end
		
	end
	
	t_single = {}
	for index = 1, t_difficulty.num_single_encounters do
		
		if #t_potentiallocations_single >= 1 then
			
			local choice = Table_GetRandomItem(t_potentiallocations_single)						-- and the single tank encounters...
			table.insert(t_single, choice)
			
			SingleTank_SetUp(choice)
			
			Locations_RemoveItem(t_potentiallocations_single, choice.removelocations)
			
		end
		
	end
	
	for n = 1, t_difficulty.start_leftover_at_guns do										-- create some left over AT guns for people to pick up
		if #t_potentiallocations_single >= 1 then
			
			local choice = Table_GetRandomItem(t_potentiallocations_single)
			Locations_RemoveItem(t_potentiallocations_single, choice.removelocations)
			
			Util_CreateSquads(player2, sg_blah, SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD, choice.location, nil, 1, 1, nil, nil, nil, Util_GetRandomPosition(choice.location, 10))
			
		end
	end
	
	local choices = Table_GetRandomItem(t_potentialmunitionsdrops, t_difficulty.free_munitions_drops)
	for k, location in pairs(choices) do 
		Util_CreateEntities(nil, eg_blah, BP_GetEntityBlueprint("generic_instantuse_munitions_ammobox_item"), location, 1)
	end
	
	-- patrollers near the exit
	Mission_ExitPatrollers()
	
	-- initialise the skirmish AI half of the enemy
	Mission_AIPlayer_Start()
	
	-- add a hintpoint about the towers
	local hpid_startwatchtower = HintPoint_Add(eg_watchtower_south2, true, 11055665, 1.5)	-- LOC("Garrison the watchtowers for extended sightlines")
	Event_Timer(EventHandler_RemoveHint, {hint = hpid_startwatchtower}, 10) -- have this hint clear after a bit
	
	Rule_AddOneShot(Mission_StartB, 2)
	Rule_AddOneShot(Mission_HideCPMeter, 0.5)
	
end
function Mission_StartB()

	-- trigger the mission start speech
	Util_StartIntel(EVENTS.MissionStart)
	
	Rule_AddInterval(Mission_StartC, 0.5)
	
end
function Mission_StartC()

	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		
		-- kick off the player's objective
		Objective_Start(OBJ_FindAndDestroy)
		
		-- add the mission end functions
		Rule_AddInterval(Mission_Complete, 2)
		Rule_AddDelayedInterval(Mission_Fail, 1, 2)
		
	end
	
end

function Mission_HideCPMeter()
	UI_SetCPMeterVisibility(false)
end


function Locations_RemoveItem(usertable, items)

	--
	-- take the -items- passed in, and remove any entries from the -usertable- that has a location that matches any of the items
	--
	
	if scartype(items) ~= ST_TABLE then
		items = {items}
	end
	
	for index = #usertable, 1, -1 do 
		
		if Table_Contains(items, usertable[index].location) then
			table.remove(usertable, index)
		end
		
	end
	
end




--
-- functions that get called from different tank systems to handle the speech
--
function Mission_TankSpottedSpeech(data)
	
	-- trigger speech, so long as no other speech is playing right now
	if Event_IsAnyRunning() == false then
		Util_StartIntel(data.intel)
	end
	
	-- add objective pings (per tank, in case of a double-tank set)
	Mission_AddObjectiveStar(data.sgroup)
	
	local _Squad = function(gid, idx, sid)
		FOW_RevealArea(Util_GetPosition(sid), 5, 6)
	end
	SGroup_ForEach(data.sgroup, _Squad)
	
	-- add events cues and minimap blips
	EventCue_Create(CUE.NORMAL, 11055666, 0, data.sgroup, nil, nil, 6, true)			-- LOC("Tank spotted")
	UI_CreateMinimapBlip(data.sgroup, 6, BT_ObjectivePrimary)
	
end

function Mission_TankOnTheMoveSpeech(data)
	
	-- add objective pings (per tank, in case of a double-tank set)
	Mission_AddObjectiveStar(data.sgroup)
	
	-- trigger speech
	if Player_CanSeeSGroup(player1, data.sgroup, ANY) then
		
		-- if player CAN see the tank...
		
		if Event_IsAnyRunning() == false then
			Util_StartIntel(EVENTS.TankOnTheMove_InSight)
		end
		
		EventCue_Create(CUE.NORMAL, 11055667, 0, data.sgroup, nil, nil, 6, true)		-- LOC("Tank on the move")
		UI_CreateMinimapBlip(data.sgroup, 6, BT_ObjectivePrimary)
		
	else
		
		-- if player CANNOT see the tank...
		
		if Event_IsAnyRunning() == false then
			Util_StartIntel(EVENTS.TankOnTheMove_OutOfSight)
		end
		
		UI_CreateMinimapBlip(data.sgroup, 6, BT_ObjectivePrimary)
		
	end

end

-- add an objective star to a tank (either when spotted, or when it starts moving)
function Mission_AddObjectiveStar(sgroup)
	
	if t_tankobjectivestars == nil then
		t_tankobjectivestars = {}
	end
	
	-- see if we've already added stars for this sgroup...
	local already_added = false
	for k, item in pairs(t_tankobjectivestars) do 
		if item == sgroup then
			already_added = true
		end
	end
	
	-- if not, then do it now
	if already_added == false then
		
		-- add objective pings (per tank, in case of a double-tank set)
		local _Squad = function(gid, idx, sid)
			Objective_AddUIElements(OBJ_FindAndDestroy, sid, true, nil, true)
		end
		SGroup_ForEach(sgroup, _Squad)
		
		table.insert(t_tankobjectivestars, sgroup)
		
	end
	
end



-- enable and disable the bombing run ability according to the player's occupation of the watchtowers (shhh! it's a secret!)
function Mission_ManageWatchtowerBonus()
	
	if watchtower_bonus_available == false then
		
		if EGroup_Count(eg_watchtower_all) == 5 and Player_OwnsEGroup(player1, eg_watchtower_all, ALL) == true then
			
			Player_SetAbilityAvailability(player1, ABILITY.SOVIET.IL_2_BOMBING_RUN_SP, ITEM_UNLOCKED)
			watchtower_bonus_available = true			
			
			if watchtower_bonus_firstshowing ~= true then
				
				-- announce feature
				UI_NewHUDFeature(HUDF_None, 11055664, "Icons_commander_cmdr_soviet_il2_bombing_run", 5)	-- LOC("Bombing runs are available while all the watchtowers are occupied.")
				Util_StartIntel(EVENTS.AllWatchtowersOccupied)
				
				-- give player some munitions so they can try it out
				if Player_GetResource(player1, RT_Munition) < 240 then
					Player_SetResource(player1, RT_Munition, 240)
				end
				
				-- award achievement
				Scar_CompleteIntelBulletinTask(player1, "tow_spring_rasputitsa_bonus")
				
				watchtower_bonus_firstshowing = true
				
			end
			
		end
		
	else
		
		if EGroup_Count(eg_watchtower_all) ~= 5 or Player_OwnsEGroup(player1, eg_watchtower_all, ALL) == false then
			
			Player_SetAbilityAvailability(player1, ABILITY.SOVIET.IL_2_BOMBING_RUN_SP, ITEM_REMOVED)
			watchtower_bonus_available = false
			
		end
		
	end


end



-- utility function to find a nearby squad to go and dig out a tank
function Mission_FindSpareSquadForRescue(location, group)

	Player_GetAll(player3)
	
	-- only focus on squads that can dig out vehicles
	local suitable_sbps = {													
		SBP.GERMAN.OSTRUPPEN_SQUAD,
		SBP.GERMAN.GRENADIER_SQUAD,
		SBP.GERMAN.PANZER_GRENADIER_SQUAD,
	}
	SGroup_Filter(sg_allsquads, suitable_sbps, FILTER_KEEP)
	
	-- remove squads that are attacking
	local _CheckSquad = function(gid, idx, sid)
		if Squad_IsAttacking(sid, 5) or Squad_IsUnderAttack(sid, 5) then		
			SGroup_Remove(gid, sid)
		end
	end
	SGroup_ForEach(sg_allsquads, _CheckSquad)
	
	-- find the closest squad 
	local closest_sid = nil 
	local closest_distance = 99999999
	if SGroup_Count(sg_allsquads) >= 1 then
		
		local _FindClosest = function(gid, idx, sid)
			local this_distance = Util_GetDistance(location, sid)
			if this_distance < closest_distance then
				closest_sid = sid
				closest_distance = this_distance
			end
		end
		SGroup_ForEach(sg_allsquads, _FindClosest)
		
	end
	
	local random_spawn_location = Table_GetRandomItem(t_infantryspawnlocations)
	
	if Util_GetDistance(location, random_spawn_location) > closest_distance then			-- if it's easier to steal a squad, so that
		
		-- switch that squad to P2, and add to the rescuer group
		SGroup_Add(group, closest_sid)
		SGroup_SetPlayerOwner(group, player2)
		Cmd_Move(group, Util_GetPosition(location))
		
		-- create a replacement squad for the AI (seeing as we just stole one of his squads)
		Mission_AIPlayer_CreateNewSquad()
		
	else																					-- else, create a new squad
		
		-- no-one nearby, so create a squad from scratch
		Util_CreateSquads(player2, group, SBP.GERMAN.PANZER_GRENADIER_SQUAD, random_spawn_location, Util_GetPosition(location), 1)
		
	end

end







function Mission_ExitPatrollers()

	local encData1 = {
		name = "Exit Patrollers 1",
		spawn = mkr_enemyroam1,
		player = player2,
		units = {
			{sbp = SBP.GERMAN.GRENADIER_SQUAD},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD, difficulty = {GD_EASY, GD_NORMAL}},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, difficulty = GD_HARD},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, difficulty = GD_HARD},
		},
		goal = {
			name = "Defend",
			target = mkr_enemyroam1,
			range = Marker_GetProximityRadius(mkr_enemyroam1) + 30,
			leashRange = Marker_GetProximityRadius(mkr_enemyroam1),
			abilityBlacklist = {
				ABILITY.GLOBAL.DIG_OUT_OF_MUD,
			},
			patrolParams = {
				name = "Patrol",
				marker = mkr_enemyroam1,
				range = Marker_GetProximityRadius(mkr_enemyroam1),
				wait = 20,
			},
		},
	}
	Encounter:Create(encData1, true)

	local encData2 = {
		name = "Exit Patrollers 2",
		spawn = mkr_enemyroam3,
		player = player2,
		units = {
			{sbp = SBP.GERMAN.GRENADIER_SQUAD},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD, difficulty = {GD_EASY, GD_NORMAL}},
			{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, difficulty = {GD_NORMAL, GD_HARD}},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, difficulty = GD_HARD},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, difficulty = GD_HARD},
		},
		goal = {
			name = "Defend",
			target = mkr_enemyroam3,
			range = Marker_GetProximityRadius(mkr_enemyroam3) + 30,
			leashRange = Marker_GetProximityRadius(mkr_enemyroam3),
			abilityBlacklist = {
				ABILITY.GLOBAL.DIG_OUT_OF_MUD,
			},
			patrolParams = {
				name = "Patrol",
				marker = mkr_enemyroam2,
				range = Marker_GetProximityRadius(mkr_enemyroam3),
				wait = 20,
			},
		},
	}
	Encounter:Create(encData2, true)

	local encData3 = {
		name = "Exit Patrollers 3",
		spawn = mkr_enemyroam3,
		player = player2,
		units = {
			{sbp = SBP.GERMAN.GRENADIER_SQUAD},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD, difficulty = {GD_EASY, GD_NORMAL}},
			{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, difficulty = GD_HARD},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, difficulty = {GD_NORMAL, GD_HARD}},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, difficulty = GD_HARD},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, difficulty = GD_HARD},
		},
		goal = {
			name = "Defend",
			target = mkr_enemyroam3,
			range = Marker_GetProximityRadius(mkr_enemyroam3) + 30,
			leashRange = Marker_GetProximityRadius(mkr_enemyroam3),
			abilityBlacklist = {
				ABILITY.GLOBAL.DIG_OUT_OF_MUD,
			},
			patrolParams = {
				name = "Patrol",
				marker = mkr_enemyroam3,
				range = Marker_GetProximityRadius(mkr_enemyroam3),
				wait = 20,
			},
		},
	}
	Encounter:Create(encData3, true)




end

 


--
-- Manage the AI skirmish player that runs nuisance around the map
--
function Mission_AIPlayer_Start()

	-- create some starting units for the ai to use to roam around
	for n = 1, t_difficulty.start_roaming_squads do
		if #t_potentiallocations_single >= 1 then
			
			local choice = Table_GetRandomItem(t_potentiallocations_single)
			Locations_RemoveItem(t_potentiallocations_single, choice.removelocations)
			
			Util_CreateSquads(player3, sg_blah, SBP.GERMAN.GRENADIER_SQUAD, choice.location, nil, 1)
			
		else
			
			local choice = Table_GetRandomItem(t_infantryspawnlocations)
			
			Util_CreateSquads(player3, sg_blah, SBP.GERMAN.GRENADIER_SQUAD, choice, nil, 1)
			
		end
	end

	
	-- and kick off the skirmish ai
	AI_RestartSCAR(player3)
	AI_SetPersonality(player3, "tow_1943_challenge_mudhunt")

	-- set some high priorities to the right of the map (the exit area)
	AI_SetCaptureImportanceEGroup(player3, eg_point_exit, 1000)
	AI_SetCaptureImportanceEGroup(player3, eg_point_nearbase1, -50)
	
	Rule_AddInterval(Mission_AIPlayer_TopUp, t_difficulty.ai_topup_frequency)
	
end

function Mission_AIPlayer_TopUp()
	
	Player_GetAll(player3)
	
	if SGroup_Count(sg_allsquads) < (t_difficulty.max_roaming_squads + (num_destroyed_tanks)) then
		
		Mission_AIPlayer_CreateNewSquad()	-- create ONE new squad for the AI
		
	end
	
end

function Mission_AIPlayer_End()

	Rule_RemoveIfExist(Mission_AIPlayer_TopUp)				-- kill off the top-up rule
	
	AI_Enable(player3, false)								-- disable the skirmish AI
	
	Player_GetAll(player3)
	if SGroup_CountSpawned(sg_allsquads) >= 1 then
		Cmd_MoveToAndDespawn(sg_allsquads, mkr_map_exit, false)
	end
	
end

function AI_SetCaptureImportanceEGroup(player, group, importance)

	local _Entity = function(gid, idx, eid)
		AI_SetCaptureImportanceBonus(player, eid, importance)
	end
	EGroup_ForEach(group, _Entity)
	
end


-- call this to supply ONE new squad to the skirmish AI player
function Mission_AIPlayer_CreateNewSquad()
	
	SGroup_Clear(sg_temp)
	
	-- set a different list of potenial SBPs depending on how many tanks have been killed so far
	local potential_sbps = nil 
	
	if g_difficulty == GD_EASY then
		
		if num_destroyed_tanks >= 4 then	-- only have to destroy 5 tanks in EASY mode
			potential_sbps = {
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			upg = nil, 							vet = 1},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			upg = nil, 							vet = nil},
				{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, 	upg = nil, 							vet = nil},
			}
		elseif num_destroyed_tanks >= 2 then
			potential_sbps = {
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, 					upg = nil, 							vet = nil},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, 					upg = nil, 							vet = nil},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			upg = nil, 							vet = nil},
			}
		else
			potential_sbps = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD, 					upg = nil, 							vet = nil},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, 					upg = nil, 							vet = nil},
			}
		end
		
	elseif g_difficulty == GD_NORMAL then
		
		if num_destroyed_tanks >= 5 then	-- only have to destroy 6 tanks in NORMAL mode
			potential_sbps = {
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			upg = nil, 							vet = 1},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			upg = nil, 							vet = 1},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			upg = nil, 							vet = 2},
				{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,		upg = nil, 							vet = nil},
				{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,		upg = nil, 							vet = 1},
				{sbp = SBP.GERMAN.MORTAR_TEAM_81MM, 				upg = nil, 							vet = nil},
			}
		elseif num_destroyed_tanks >= 4 then
			potential_sbps = {
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, 					upg = nil, 							vet = 1},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			upg = nil, 							vet = 1},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			upg = nil, 							vet = nil},
				{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, 	upg = nil, 							vet = nil},
			}
		elseif num_destroyed_tanks >= 2 then
			potential_sbps = {
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, 					upg = nil, 							vet = nil},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, 					upg = nil, 							vet = nil},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			upg = nil, 							vet = nil},
			}
		else
			potential_sbps = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD, 					upg = nil, 							vet = nil},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, 					upg = nil, 							vet = nil},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, 					upg = nil, 							vet = nil},
			}
		end
		
	elseif g_difficulty == GD_HARD then
		
		if num_destroyed_tanks >= 5 then	-- have to destroy 8 tanks in HARD mode
			potential_sbps = {
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			upg = nil, 							vet = 2},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			upg = nil, 							vet = 2},
				{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,		upg = nil, 							vet = 1},
				{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,		upg = nil, 							vet = 1},
				{sbp = SBP.GERMAN.MORTAR_TEAM_81MM, 				upg = nil, 							vet = 1},
			}
		elseif num_destroyed_tanks >= 3 then
			potential_sbps = {
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, 					upg = nil, 							vet = 2},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			upg = nil, 							vet = 1},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			upg = nil, 							vet = 1},
				{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, 	upg = nil, 							vet = nil},
			}
		elseif num_destroyed_tanks >= 1 then
			potential_sbps = {
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, 					upg = nil, 							vet = 1},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, 					upg = nil, 							vet = nil},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			upg = nil, 							vet = nil},
			}
		else
			potential_sbps = {
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, 					upg = nil, 							vet = nil},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, 					upg = nil, 							vet = nil},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, 					upg = nil, 							vet = nil},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			upg = nil, 							vet = nil},
			}
		end
		
	end
	
	-- make a choice based upon the above tables
	local choice =  Table_GetRandomItem(potential_sbps)
	
	-- create _one_ new squad
	Util_CreateSquads(player3, sg_temp, choice.sbp, mkr_rescuer_spawn2, Util_GetPosition(EGroup_GetRandomSpawnedEntity(eg_point_all)), 1, nil, nil, nil, choice.upg)
	if choice.vet ~= nil then
		SGroup_IncreaseVeterancyRank(sg_temp, choice.vet, true)
	end
	
end










function Mission_Complete()
	
	if Objective_IsComplete(OBJ_FindAndDestroy) and Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		Rule_RemoveIfExist(Mission_Fail)
		
		Util_StartIntel(EVENTS.MissionComplete)		-- trigger speech
		Mission_AIPlayer_End()						-- get AI to retreat
		
		Rule_AddInterval(Mission_CompleteB, 1)
		
	end
	
end
function Mission_CompleteB()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		Game_EndSP(true)
	end
end



function Mission_Fail()
	
	if Event_IsAnyRunning() == false then
		
		if Objective_IsFailed(OBJ_FindAndDestroy) then
			
			Rule_RemoveMe()
			Rule_RemoveIfExist(Mission_Complete)
			
			Util_StartIntel(EVENTS.MissionFailed)		-- trigger speech
			
			Rule_AddInterval(Mission_FailB, 1)
			
		elseif Mission_PlayerIsOutOfGame() == true then
			
			Rule_RemoveMe()
			Rule_RemoveIfExist(Mission_Complete)
			
			Rule_AddDelayedInterval(Mission_FailB, 3, 1)
			
		end
		
	end
	
end
function Mission_FailB()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		Game_EndSP(false)
	end
end




function Mission_PlayerIsOutOfGame()

	Player_GetAll(player1)
	EGroup_Filter(eg_allentities, EBP.SOVIET.HQ, FILTER_KEEP)
	
	if SGroup_CountSpawned(sg_allsquads) == 0 and EGroup_CountSpawned(eg_allentities) == 0 then
		
		return true
		
	end
	
end

