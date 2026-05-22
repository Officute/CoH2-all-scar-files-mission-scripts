-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Mission 8
-- Panzer Hunting
-- Designer: Ryan McGechaen
-------------------------------------------------------------------------
-------------------------------------------------------------------------
import("ScarUtil.scar")
import("Systems/AiManager/ai.scar")
import("Prototype/DeploymentPoints.scar")
import("Beginner.scar")
import("Global_Values/CampaignGlobalConstants.scar")

g_isWinterMap = true

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------

function OnGameSetup()
	
	-- Required Players
	player1 = Setup_Player(1, 11040470, "soviet", 1)		-- LOCDB [11040470] '327th Rifle Division'
	player2 = Setup_Player(2, 11040471, "german", 2)		-- LOCDB [11040471] '502nd Heavy Panzer Battalion'
	
	-- Optional Players
	player3 = Setup_Player(3, 11040470, "soviet", 1)		-- player3 is always the AI ally

end

function OnGameRestore()
	
	-- function takes care of restoring all global mission parameters after a save/load
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	Util_RestoreMusic()
	
	Game_DefaultGameRestore()
end


-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------

function OnInit()
	
	-- Lets the NIS team use this mission to review videos
	if Misc_IsCommandLineOptionSet("NIS_Review") then Game_FadeToBlack(FADE_OUT, 0) return end
	
	--[[ PRECACHE MUSIC ]]
--~ 	Sound_PreCacheSound("streamed/music/missions/m04/m04_all")
--~ 	Sound_PreCacheSound("streamed/music/missions/m04/m04_ambient")
	
	--[[ PRESET DEBUG CONDITIONS ]]
	Mission_Debug()
	
	--[[ SET RESTRICTIONS ]]
	Mission_Restrictions()
	
	--[[ SET DIFFICULTY ]]
	Mission_Difficulty()
	
	--[[ MISSION PRESETS ]]
	Mission_MissionPreset()
	
	--[[ PLAY INTRO NIS]]
	TheHunt_Init()
	Mission_Start_NIS()
	
	--[[ REGISTER OBJECTIVES ]]
	Initialize_TheHunt()
	Initialize_SUB_EscortTanks()
	Initialize_SUB_DestroyTiger()
	
	Initialize_Escape()
	Initialize_Entry()
	
	--[[ GAME START CHECK ]]
	Rule_Add(Mission_MissionStart)
	
end

Scar_AddInit(OnInit)

function Mission_Debug()

	-- looks for the command line option [-debug]
	if Misc_IsCommandLineOptionSet("debug") then
		g_debug = true
	end

end

function Mission_Start_NIS()

	Event_NarrativeEventsNotRunning(EventHandler_StartNislet, {intel = EVENTS.CAMERA_START, skipCallback = _skipIntroCamera})
	
	Sound_SetVolume("Vehicles", 0.2, 1000)

end

function _skipIntroCamera()

	-- Start Objective 
	Objective_Start(SOBJ_EscortTanks)
	
	-- Warp conscripts
	SGroup_WarpToMarker(sg_hunt_p_conscripts_01, mkr_hunt_p_conscripts_01_dest)
	SGroup_WarpToMarker(sg_hunt_p_conscripts_02, mkr_hunt_p_conscripts_02_dest)
	SGroup_WarpToMarker(sg_hunt_p_conscripts_03, mkr_hunt_p_conscripts_03_dest)
	
	-- Warp tanks and get them moving
	SGroup_WarpToMarker(sg_hunt_a_t34_01, mkr_a_SKIP_t34_01_pos)
	Cmd_SquadPath(sg_hunt_a_t34_01, "pth_a_t34_01", true, false, false, 0)
	
	SGroup_WarpToMarker(sg_hunt_a_su85, mkr_a_SKIP_su76_pos)
	Cmd_SquadPath(sg_hunt_a_su85, "pth_a_su85_a", true, false, false, 0)
	
	SGroup_WarpToMarker(sg_hunt_a_t34_02, mkr_a_SKIP_t34_02_pos)
	Cmd_SquadPath(sg_hunt_a_t34_02, "pth_a_t34_02", true, false, false, 0)

end

function _reduceSpeed_01() Modifier_Remove(_speedMod_01) end
function _reduceSpeed_02() Modifier_Remove(_speedMod_02) end
function _reduceSpeed_03() Modifier_Remove(_speedMod_03) end

function Mission_Restrictions()
	
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.TANK_DEPOT, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.M1937_152MM_ML_20_ARTILLERY, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.MOTORPOOL, ITEM_LOCKED)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.BARRACKS, ITEM_LOCKED)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.WEAPON_SUPPORT_CENTER, ITEM_LOCKED)
	Player_SetEntityProductionAvailability(player3, EBP.SOVIET.MOTORPOOL, ITEM_UNLOCKED)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.OBSERVATION_POST_FUEL, ITEM_LOCKED)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.OBSERVATION_POST_MUNITION, ITEM_LOCKED)
	
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.ANTI_TANK_GRENADE, ITEM_DEFAULT)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.RGD_1_SMOKE_GRENADE, ITEM_UNLOCKED)
	
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.ANTI_TANK_GRENADE, ITEM_REMOVED)
	
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD, ITEM_REMOVED)
--~ 	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.M5_HALFTRACK_SQUAD, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.SU_76M, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.T_70M, ITEM_REMOVED)
	
	Player_SetUpgradeAvailability(player1, UPG.SOVIET.PENAL_BATTALION_FLAMETHROWER_PACKAGE, ITEM_LOCKED)
	
	Cmd_Upgrade(player1, UPG.SOVIET.GUARD_ARCHETYPE, 1, true)
	Cmd_Upgrade(player1, BP_GetUpgradeBlueprint("mission08_upgrade"), 1, true)
	Cmd_Upgrade(player1, BP_GetUpgradeBlueprint("buildable_cargo_truck_upgrade"), 1, true)
	Cmd_Upgrade(player1, BP_GetUpgradeBlueprint("disable_vehicle_criticals"), 1, true)
	Cmd_Upgrade(player1, BP_GetUpgradeBlueprint("hq_anti_tank_grenade"), 1, true)
	
	Player_SetResource(player2, RT_Command, 2)
	
	Cmd_Upgrade(player2, BP_GetUpgradeBlueprint("mission08_upgrade"), 1, true)
	Cmd_Upgrade(player2, BP_GetUpgradeBlueprint("disable_vehicle_criticals"), 1, true)
	
	
end

function Mission_Difficulty()
--~ 	Modify_WeaponAccuracy(
	-- get the difficulty
	g_difficulty = Game_GetSPDifficulty()  -- set a global difficulty variable 
	print("********* DIFFICULTY: "..g_difficulty)
	
	t_difficulty = {
		starting_Manpower 			= Util_DifVar( {900, 600, 400, 0} ), 	-- Starting Manpower
		starting_Munitions 			= Util_DifVar( {20, 10, 0, 0} ), 	-- Starting Munitions
		starting_Fuel	 			= Util_DifVar( {80, 70, 30, 0} ), 	-- Starting Fuel
		Manpower_Rate				= Util_DifVar( {3, 2, 1, 0} ), 	-- Manpower Rate
		Munitions_Rate				= Util_DifVar( {3, 2, 1, 0} ), 	-- Munitions Rate
		Fuel_Rate					= Util_DifVar( {2, 1, 1, 0} ), 	-- Fuel Rate
		-- Caps come into effect during the second beat
		Manpower_Cap				= Util_DifVar( {2201, 1501, 1001, 0} ), 	-- Manpower Cap
		Munition_Cap				= Util_DifVar( {1401, 1001, 601, 0} ), 	-- Munition Cap
		Fuel_Cap					= Util_DifVar( {281, 201, 101, 0} ), 	-- Fuel Cap
		--36
		Pop_Cap_Hunt				= Util_DifVar( {90, 70, 60, 0} ), 	-- Pop Cap during the Hunt
		Pop_Cap_Escape				= Util_DifVar( {100, 100, 80, 0} ), 	-- Pop Cap during the Escape
		
		repairTuning				= Util_DifVar( {0.3, 0.3, 0.3}),		-- Repair rate
		
		-- Tiger Tuning		
		tiger_avoid_at				= Util_DifVar( {30, 25, 20, 0 } ),		-- How often does the tiger try to flank AT guns
		tiger_armor					= Util_DifVar( {0.9, 1.5, 1.75, 0} ),			-- Tiger Armour mod (makes AT rifles useless unless vs rear)
		tiger_received_damage		= Util_DifVar( {1.2, 1, 0.9, 0} ),			-- Vulnerability on the Tiger
		tiger_sight_range			= Util_DifVar( {0.8, 1.2, 1.5, 0} ),				-- Tiger's sight range
		tiger_weapon_reload			= Util_DifVar( {1.1, 0.75, 0.65, 0} ),				-- Tiger's weapon reload
		tiger_weapon_scatter		= Util_DifVar( {1.2, 1, 1, 0} ),				-- Tiger's scatter
		
		-- Attack Tuning
		attackWaveStartDelay		= Util_DifVar( {4*60, 3*60, 2*60, 0} ), 	-- Time before the initial attack begins
		
		attack_breather				= Util_DifVar( {2, 3, 4, 0} ),		-- How many waves before a break is triggered
		attack_breather_time		= Util_DifVar( {2*60, 1.75*60, 1.5*60, 0} ),		-- How long the player has a break between large groups
		
		level1_attack_time_min		= Util_DifVar( {60, 50, 30, 0} ),		-- Min time for the waves to attack
		level1_attack_time_max		= Util_DifVar( {65, 55, 35, 0} ),		-- Max time for the waves to attack
		
		level2_attack_time_min		= Util_DifVar( {45, 30, 20, 0} ),		-- Min time for the waves to attack
		level2_attack_time_max		= Util_DifVar( {55, 35, 25, 0} ),		-- Max time for the waves to attack
		
		-- Village Germans
		mainRoad_SPG 				= Util_DifVar( {SBP.GERMAN.STUG_III_SQUAD, SBP.GERMAN.STUG_III_SQUAD, 
													SBP.GERMAN.BRUMMBAR_SQUAD, SBP.GERMAN.BRUMMBAR_SQUAD} ),			-- The SPG to spawn on the main road
	}
	Modify_ProjectileDelayTime(player2, BP_GetEntityBlueprint("bundled_stielgranate_campaign"), Util_DifVar({1.25, 1, 0.625}, g_difficulty))

end

function MISSION_Autosave_01()
	
	Util_Autosave(11049959)	-- LOCDB [11049959] 'Mission 8 - Autosave 1'
	
	Rule_AddOneShot(DestroyTiger_Start, 3)

end

-------------------------------------------------------------------------
-- MISSION Preset 
-------------------------------------------------------------------------

function Mission_MissionPreset()

	g_music_start = "streamed/music/missions/m08/m08_cue_start_mission"
	Util_PlayMusic(g_music_start, 0, 0)
	
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	sg_blah = SGroup_CreateIfNotFound("sg_blah")
	eg_temp = EGroup_CreateIfNotFound("eg_temp")
	eg_blah = EGroup_CreateIfNotFound("eg_blah")
	
	g_mod_man = Modify_PlayerResourceRate(player1, RT_Manpower, 0)
	g_mod_mun = Modify_PlayerResourceRate(player1, RT_Munition, 0)
	g_mod_fuel = Modify_PlayerResourceRate(player1, RT_Fuel, 0)
	
	Player_SetResource(player1, RT_Manpower, t_difficulty.starting_Manpower)
	Player_SetResource(player1, RT_Munition, 0)
	Player_SetResource(player1, RT_Fuel, t_difficulty.starting_Fuel)
	
	Player_SetResource(player3, RT_Fuel, 500)
	
	Player_SetResource(player1, RT_SovietProgression, 50)
	
	Player_SetPopCapOverride(player1, t_difficulty.Pop_Cap_Hunt)
	
	g_player_repRate = Modify_VehicleRepairRate(player1, t_difficulty.repairTuning, EBP.SOVIET.COMBAT_ENGINEER)
	g_player_at_cooldown = Modify_AbilityRechargeTime(player1, ABILITY.SOVIET.ANTI_TANK_GRENADE, 1.5)
	g_player_at_gren_cost = Modify_AbilityMunitionsCost(player1, ABILITY.SOVIET.ANTI_TANK_GRENADE, 2)
	g_player_button_cooldown = Modify_AbilityRechargeTime(player1, ABILITY.SOVIET.BUTTON_VEHICLE, 2)
	-- 0.3 good for main repair rate
	
	EGroup_EnableMinimapIndicator(eg_airfield_cps, false)
	
	-- Despawn pickups based on difficulty
	if g_difficulty == GD_NORMAL then
		EGroup_DeSpawn(eg_normal_items)
	elseif g_difficulty == GD_HARD then
		EGroup_DeSpawn(eg_hard_items)
		EGroup_DeSpawn(eg_normal_items)
	end
	
	EGroup_SetSelectable(eg_tiger_building, false)
	EGroup_SetInvulnerable(eg_tiger_building, true)
	
	EGroup_SetInvulnerable(eg_midRight_def, true)
	EGroup_SetInvulnerable(eg_midRight_def, true)
	
	EGroup_SetSelectable(eg_esc_hq, false)

	-- Achievement Flags
	_calledInHelpDuringHunt = false
	
	Rule_AddPlayerEvent(_checkForTankBusters, player1, GE_AbilityExecuted)
	
	_modID_player2_vet = Modify_PlayerExperienceReceived(player2, 0)
	Modify_PlayerExperienceReceived(player3, 0)
	
	EGroup_SetRecrewable(eg_45mm_at_01, false)
	EGroup_EnableUIDecorator(eg_45mm_at_01, false)
	EGroup_SetRecrewable(eg_45mm_at_02, false)
	EGroup_EnableUIDecorator(eg_45mm_at_02, false)
	EGroup_SetRecrewable(eg_45mm_at_05, false)
	EGroup_EnableUIDecorator(eg_45mm_at_05, false)
	
	eg_ptrs = EGroup_CreateIfNotFound("eg_ptrs")
	World_GetNeutralEntitiesNearPoint(eg_ptrs, Util_GetPosition(mkr_esc_e_pak_def), 200)
	
	EGroup_Filter(eg_ptrs, BP_GetEntityBlueprint("soviet_guard_ptrs"), FILTER_KEEP)
	EGroup_DeSpawn(eg_ptrs)
	
	TIGER_Init()
	
	-- Modify the AT guns
	local atGuns = EGroup_GetWBTable("eg_45mm_at_%02d")
	for i = 1, table.getn(atGuns) do
		if EGroup_IsEmpty(atGuns[i]) == false then
			Modify_WeaponReload(atGuns[i], "hardpoint_01", 0.7)
			Modify_WeaponPenetration(atGuns[i], "hardpoint_01", 0.8)
			Modify_WeaponAccuracy(atGuns[i], "hardpoint_01", 0.4)
			
			local eid = EGroup_GetSpawnedEntityAt(atGuns[i], 1)
			Entity_SetInvulnerable(eid, 0.5, -1)
			
			EGroup_SetRecrewable(atGuns[i], false)
			EGroup_EnableUIDecorator(atGuns[i], false)
		end
	end
	
	Rule_AddOneShot(Mission_HideCP, 3)
	
end

function _foundMunitions(data)
	_lastHintLoc = data.location
	EventCue_Create(CUE.MAP, 11049989, 11049989, data.location, nil, _onClick, 5) -- LOCDB [11049989] 'Supplies located'
end

function _onClick()
	Camera_MoveTo(_lastHintLoc, true, 0.5, false, true)
end

function _checkForTankBusters(caster, ability, target)

	if ability == BP_GetAbilityBlueprint("tank_buster_conscript_dispatch") then
		Rule_RemoveMe()
		
		_calledInHelpDuringHunt = true
	end

end

-------------------------------------------------------------------------
-- MISSION START 
-------------------------------------------------------------------------
function Mission_MissionStart()

	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		
	end
end



function Mission_DelayObjTitle()

	Objective_Start(SOBJ_DestroyTiger, false)
	
end

function Mission_HideCP() UI_SetCPMeterVisibility(false) end

----------------------------
-- BEAT 1
-- THE HUNT
----------------------------
-- || INIT FUNCTIONS ||
function TheHunt_Init()
	
	Resources_Disable()
	
	Player_SetDefaultSquadMoodMode(player1, MM_ForceTense)
	
	-- Spawn Players
	sg_hunt_p_conscripts_01 = SGroup_CreateIfNotFound("sg_hunt_p_conscripts_01")
	sg_hunt_p_conscripts_02 = SGroup_CreateIfNotFound("sg_hunt_p_conscripts_02")
	sg_hunt_p_conscripts_03 = SGroup_CreateIfNotFound("sg_hunt_p_conscripts_03")
	
	Util_CreateSquads(player1, sg_hunt_p_conscripts_01, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_hunt_p_conscripts_01_spawn)
	Util_CreateSquads(player1, sg_hunt_p_conscripts_02, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_hunt_p_conscripts_02_spawn)
	Util_CreateSquads(player1, sg_hunt_p_conscripts_03, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_hunt_p_conscripts_03_spawn)
	
	SGroup_SetAutoTargetting(sg_hunt_p_conscripts_01, "hardpoint_01", false)
	SGroup_SetAutoTargetting(sg_hunt_p_conscripts_02, "hardpoint_01", false)
	SGroup_SetAutoTargetting(sg_hunt_p_conscripts_03, "hardpoint_01", false)
	
	Cmd_Move(sg_hunt_p_conscripts_01, mkr_hunt_p_conscripts_01_dest)
	Cmd_Move(sg_hunt_p_conscripts_02, mkr_hunt_p_conscripts_02_dest)
	Cmd_Move(sg_hunt_p_conscripts_03, mkr_hunt_p_conscripts_03_dest)
	
	-- Spawn Allies
	sg_hunt_a_t34_01 = SGroup_CreateIfNotFound("sg_hunt_a_t34_01")
	sg_hunt_a_t34_02 = SGroup_CreateIfNotFound("sg_hunt_a_t34_02")
	sg_hunt_a_su85 = SGroup_CreateIfNotFound("sg_hunt_a_su85")
	
	Util_CreateSquads(player3, sg_hunt_a_t34_01, BP_GetSquadBlueprint("m08_t_34_76_squad_smallpath"), mkr_hunt_a_t34_01_spawn)
	Util_CreateSquads(player3, sg_hunt_a_t34_02, SBP.SOVIET.T_34_76_SQUAD, mkr_hunt_a_t34_02_spawn)
	Util_CreateSquads(player3, sg_hunt_a_su85, SBP.SOVIET.SU_76M, mkr_hunt_a_su85_spawn)
	
	SGroup_SetAutoTargetting(sg_hunt_a_t34_01, "hardpoint_01", false)
	SGroup_SetAutoTargetting(sg_hunt_a_t34_02, "hardpoint_01", false)
	SGroup_SetAutoTargetting(sg_hunt_a_su85, "hardpoint_01", false)
	
	Squad_SetInvulnerableMinCap(SGroup_GetSpawnedSquadAt(sg_hunt_a_t34_01, 1), 0.5, -1)
	Squad_SetInvulnerableToCritical(SGroup_GetSpawnedSquadAt(sg_hunt_a_t34_01, 1), true)
	Squad_SetInvulnerableToCritical(SGroup_GetSpawnedSquadAt(sg_hunt_a_t34_02, 1), true)
	Squad_SetInvulnerableToCritical(SGroup_GetSpawnedSquadAt(sg_hunt_a_su85, 1), true)
	
	g_temp_t34_01_turretRot = Modify_VehicleTurretRotationSpeed(sg_hunt_a_t34_01, "hardpoint_01", 2)
	g_temp_t34_01_mod = Modify_UnitSpeed(sg_hunt_a_t34_01, 0.5)
	Modify_UnitSpeed(sg_hunt_a_t34_02, 0.45)
	g_temp_su85_mod = Modify_UnitSpeed(sg_hunt_a_su85, 0.35)
	Modify_WeaponPenetration(sg_hunt_a_su85, "hardpoint_01", 0.2)
	
	Modify_Vulnerability(sg_hunt_a_t34_01, 9)
	Modify_Vulnerability(sg_hunt_a_t34_02, 9)
	Modify_Vulnerability(sg_hunt_a_su85, 9)
	
	SGroup_SetInvulnerable(sg_hunt_a_t34_01, 0.5)
	
	g_t34_rec_accuracy = Modify_ReceivedAccuracy(sg_hunt_a_t34_01, 9)
	
	-- The Base
	EGroup_SetAvgHealth(eg_esc_hq, 0.3)
	
	-- Functions
--~ 	TheHunt_KickOff()
	Intro_Kickoff()
	
	-- Variables
	_playerSeenTiger_quiet = false
	_playerSeenTiger_loud = false
	_playerToldFlank = false
	_tigerHasVanishedOnce = false
	
	-- Events	
	Rule_AddPlayerEvent(TheHunt_AutoTargetting_Off, player1, GE_AbilityExecuted)

end

--|| OBJECTIVE FUNCTIONS ||
function Escort_Obj_Start()
	Objective_Start(SOBJ_EscortTanks)
end

function TheHunt_Obj_Start()

	Objective_Start(OBJ_TheHunt)

end

function Initialize_TheHunt()
	
	OBJ_TheHunt = {
		
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 0)
			Util_PlayMusic(g_music_hunt_begins, 0, 4)
--~ 			Objective_Start(SOBJ_EscortTanks, false)
		end,
		
		OnComplete = function()
			Rule_AddDelayedInterval(TheHunt_SitRep_Delay, 3, 1)
			Escape_Init()
			
			if _calledInHelpDuringHunt == false then
				Scar_CompleteIntelBulletinTask(player1, "camp08_panzer_hunting_no_help_needed")
			end
			
			Event_Remove(eventID_warning)
			Event_Remove(eventID_loss)
		end,
		
		OnFail = function()
						
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = EVENTS.TH_TIGER_DISABLED,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11045878,				-- LOCDB [11045878] 'Hunt down the Tiger in the Village'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_TheHunt)
end

function Initialize_SUB_EscortTanks()

	SOBJ_EscortTanks = {
		
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			
		end,
		
		OnComplete = function()
			Rule_AddOneShot(MISSION_Autosave_01, 5)
		end,
		
		OnFail = function()
					
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = EVENTS.MASSACRE_FINISH,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11045880,				-- LOCDB [11045880] 'Escort the Allied Tanks'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
--~ 		Parent = OBJ_TheHunt,
	}
	
	Objective_Register(SOBJ_EscortTanks)
end

function Initialize_SUB_DestroyTiger()

	SOBJ_DestroyTiger = {
		
		SetupUI = function() 
			if SGroup_IsOnScreen(player1, sg_hunt_p_units, ANY, 0.9) == false then
				hpid_reinforcements = Objective_AddUIElements(SOBJ_DestroyTiger, mkr_hunt_a_t34_01_spawn, true, 11045881, true)	-- LOCDB [11045881] 'Incoming Reinforcements on South Road'
			end
		end,
		
		OnStart = function()
			-- Add Command Point
--~ 			Util_PlayMusic(g_ambientMusic, 0, 0)
--~ 			Sound_SetMusicCombatValue(0, 1)
			Cmd_Upgrade(player1, UPG.SOVIET.TANK_DETECTION, 1, true)
			Player_AddAbility(player1, ABILITY.SOVIET.TANK_DETECTION_ABILITY)
			
			Player_SetResource(player1, RT_Command, 2)
			
			World_GetNeutralEntitiesNearMarker(eg_blah, mkr_esc_clear_hq)
			EGroup_Filter(eg_blah, EBP.SOVIET.BARBED_WIRE_FENCE, FILTER_KEEP)
			EGroup_Kill(eg_blah)
			
--~ 			Objective_Start(SOBJ_DestroyTiger_FAIL, false)
			
			Rule_AddInterval(TheHunt_Obj_RemoveUI, 1)
			
			Player_AddAbility(player1, BP_GetAbilityBlueprint("tank_buster_conscript_dispatch"))
			Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("tank_buster_conscript_dispatch"), ITEM_DEFAULT)
			Player_SetAbilityAvailability(player1, ABILITY.SOVIET.ANTI_TANK_GRENADE, ITEM_DEFAULT)
--~ 			UI_SetSoviet227Visibility(true)
			
			-- Spawn player units
			sg_hunt_p_core = SGroup_CreateIfNotFound("sg_hunt_p_core")
			
			sg_hunt_p_units = SGroup_CreateIfNotFound("sg_hunt_p_units")
			sg_hunt_p_guard01 = SGroup_CreateIfNotFound("sg_hunt_p_guard01")
			sg_hunt_p_guard02 = SGroup_CreateIfNotFound("sg_hunt_p_guard02")
			sg_hunt_p_engineer_01 = SGroup_CreateIfNotFound("sg_hunt_p_engineer_01")
			sg_hunt_p_engineer_02 = SGroup_CreateIfNotFound("sg_hunt_p_engineer_02")
			
			Util_CreateSquads(player1, {sg_hunt_p_units, sg_hunt_p_core}, BP_GetSquadBlueprint("m08_combat_engineer_squad"), mkr_hunt_p_eng01_spawn, mkr_hunt_p_eng01_dest)
			Util_CreateSquads(player1, {sg_hunt_p_units, sg_hunt_p_core}, BP_GetSquadBlueprint("m08_combat_engineer_squad"), mkr_hunt_p_eng02_spawn, mkr_hunt_p_eng02_dest)
			
			Util_CreateSquads(player1, {sg_hunt_p_guard01, sg_hunt_p_core, sg_hunt_p_units}, SBP.SOVIET.GUARDS_TROOPS, mkr_hunt_p_guard01_spawn, mkr_hunt_p_guard01_dest, 1, 6, false, nil)
			Util_CreateSquads(player1, {sg_hunt_p_guard02, sg_hunt_p_core, sg_hunt_p_units}, SBP.SOVIET.GUARDS_TROOPS, mkr_hunt_p_guard02_spawn, mkr_hunt_p_guard02_dest, 1, 6, false, nil)
			Cmd_Upgrade(sg_hunt_p_guard01, UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP, 1, true)
			Cmd_Upgrade(sg_hunt_p_guard02, UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP, 1, true)
			
			Util_CreateSquads(player1, {sg_hunt_p_units, sg_hunt_p_core, sg_hunt_p_units}, SBP.SOVIET.SNIPER_TEAM, mkr_hunt_p_sniper_spawn, mkr_hunt_p_sniper_dest)
			
			SGroup_SetAutoTargetting(sg_hunt_p_units, "hardpoint_01", false)
			
			sg_mergehints = SGroup_CreateIfNotFound("sg_mergehints")
			sg_reinforcehints = SGroup_CreateIfNotFound("sg_reinforcehints")
			eg_reinforcehints = EGroup_CreateIfNotFound("eg_reinforcehints")
			
			Tiger_Hunting_UpdateHintGroups() 
			BeginnerHint_AddOpportunity(eg_easy_items, HINT_PICKUP, true)
			BeginnerHint_AddOpportunity(sg_mergehints, HINT_MERGE, true)
			BeginnerHint_AddOpportunity(sg_reinforcehints, HINT_REINFORCE)
			Rule_AddInterval(Tiger_Hunting_UpdateHintGroups, 30)
			
			Player_GetAll(player1, sg_hunt_p_units)
			
			EventCue_Create(CUE.NORMAL, 11045882, 11045882, mkr_hunt_p_eng02_dest, nil, _panToReinforcements, 15)	-- LOCDB [11045882] 'Reinforcements Arriving via South Road'
			
			Squad_SetInvulnerableMinCap(SGroup_GetSpawnedSquadAt(sg_e_tiger, 1), 0.49, -1)
			SGroup_EnableUIDecorator(sg_e_tiger, true)
			SGroup_EnableMinimapIndicator(sg_e_tiger, true)
			Modifier_Remove(g_tiger_accuracy)
			Modifier_Remove(g_tiger_pen)
			
			Event_NarrativeEventsNotRunning(EventHandler_StartIntel, {intel_callback = EVENTS.TH_RALLY}, 8)
			Event_ElementOnScreen(EventHandler_StartIntel, {intel_callback = EVENTS.TH_AT_GUNS_SPOTTED}, player1, eg_45mm_at_all, ANY, 0.8)
			
			local atGuns = EGroup_GetWBTable("eg_45mm_at_%02d")
			for i = 1, table.getn(atGuns) do
				if EGroup_IsEmpty(atGuns[i]) == false then
					EGroup_SetRecrewable(atGuns[i], true)
					EGroup_EnableUIDecorator(atGuns[i], true)
				end
			end
			
			EGroup_ReSpawn(eg_ptrs)
			
			Rule_AddInterval(TIGER_Track_UI, 1.5)
			
			Rule_AddInterval(TheHunt_Collect_Player_Units, 5)
			
			Rule_AddInterval(TheHunt_AT_Rifles, 1)
			Rule_AddInterval(TheHunt_Mines, 1)
			
			Cmd_Move(sg_e_tiger, mkr_theHunt_tiger_south_02)
			
			Event_PlayerCanNotSeeElement(TheHunt_Tiger_Hidden, nil, player1, sg_e_tiger, ANY)
			
			_tigerHiding = false
			
			-- Warning condition
			Rule_AddInterval(TheHunt_Obj_Used_All_Manpower, 1)
			
			-- Loss condition
			Rule_AddInterval(TheHunt_Obj_Fail, 1)
		end,
		
		OnComplete = function()
		
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.TH_REINFORCEMENTS,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = EVENTS.TH_LOST,				-- Event will play when obj fails but before UI is cleared
		Title = 11045883,				-- LOCDB [11045883] 'Destroy the Tiger'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		Parent = OBJ_TheHunt,
	}
	
	--[[  SitRep
		"Fuck, that Tiger cut through our tanks like butter!"
		"Commander, our forces are committed to the offensive, we cannot give you any more support other than a handful of troops."
		"You will have to take out the Tiger with what you have; command does -not- want that thing harassing our supply lines."
		"Lay mines, demolition charges - lure it into traps, do what you have to; but take it out!"
	
	]]
	
	Objective_Register(SOBJ_DestroyTiger)
	
end

function TheHunt_Obj_RemoveUI()

	if SGroup_IsOnScreen(player1, sg_hunt_p_units, ANY, 0.9) then
		Rule_RemoveMe()
		
		Objective_RemoveUIElements(SOBJ_DestroyTiger, hpid_reinforcements)
	end

end

function TheHunt_Obj_Fail()
	
	if SGroup_IsEmpty(sg_hunt_p_units) and Player_GetResource(player1, RT_Manpower) == 0 then
		Rule_RemoveMe()
		Objective_Fail(SOBJ_DestroyTiger)
		Game_FadeToBlack(FADE_OUT, 3.5)
		
		Event_NarrativeEventsNotRunning(TheHunt_Obj_Failed, nil, 4)
	end

end

function TheHunt_Obj_Failed()
	if Objective_IsFailed(SOBJ_DestroyTiger) then
		Game_EndSP(false)
	end
end

function TheHunt_Obj_Used_All_Manpower()

	if Player_GetResource(player1, RT_Manpower) == 0 then
		Rule_RemoveMe()
		
		Util_StartIntel(EVENTS.TH_RUN_OUT_OF_RESOURCES)
		
		Rule_AddInterval(TheHunt_Obj_Losing_Too_Many, 1)
	end

end

function TheHunt_Obj_Losing_Too_Many()
	
	Player_GetAll(player1)
	
	if SGroup_CountSpawned(sg_allsquads) <= 4 or SGroup_TotalMembersCount(sg_allsquads, true) <= 14 then
		Rule_RemoveMe()
		
		Util_StartIntel(EVENTS.TH_ALMOST_DEAD)
		
		if g_difficulty == GD_EASY then
			Rule_AddDelayedInterval(TheHunt_Easy_Help, 6, 1)
		end
	end

end

function TheHunt_Easy_Help()
	
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		
		Player_GetAll(player1)
		
		if SGroup_ContainsBlueprints(sg_allsquads, BP_GetSquadBlueprint("m08_combat_engineer_squad"), ANY) then
			Util_StartIntel(EVENTS.TH_HINT_ENGINEERS)
		elseif EGroup_IsEmpty(eg_45mm_at_all) == false then
			Util_StartIntel(EVENTS.TH_HINT_AT_GUNS)
		elseif SGroup_ContainsBlueprints(sg_allsquads, BP_GetSquadBlueprint("m08_tank_buster_conscript_squad"), ANY) then
			Util_StartIntel(EVENTS.TH_HINT_AT_GRENADES)
		elseif SGroup_ContainsBlueprints(sg_allsquads, SBP.SOVIET.GUARDS_TROOPS, ANY) then
			Util_StartIntel(EVENTS.TH_HINT_AT_RIFLES)
		end
	end		

end

--|| BEAT FUNCTIONS ||
-- Intro:: Drive Into Village
function Intro_Kickoff()
	
	-- Start the Tanks
	Cmd_SquadPath(sg_hunt_a_t34_01, "pth_a_t34_01", true, false, false, 0)
	Cmd_SquadPath(sg_hunt_a_t34_02, "pth_a_t34_02", true, false, false, 0)
	Cmd_SquadPath(sg_hunt_a_su85, "pth_a_su85_a", true, false, false, 0)
	
	-- Setup First Speech events
	Event_Proximity(EventHandler_StartIntel, {intel_callback = EVENTS.INTRO_SPEECH_01}, player3, mkr_intro_speech_trig_01, nil, ANY)
	Event_Proximity(EventHandler_StartIntel, {intel_callback = EVENTS.INTRO_SPEECH_02}, player3, mkr_intro_speech_trig_02, nil, ANY)
	
	-- Setup Brummbar Trigger
	Event_Proximity(_intro_Brummbar_Seen, nil, sg_hunt_a_t34_01, mkr_intro_brummbar_trig, nil, ANY)

end

function _intro_Brummbar_Seen()

	-- Stop Any Events
	Event_Skip()
	
	-- Play the Intel Event
	Util_StartIntel(EVENTS.INTRO_BRUMMBAR_SPOTTED)
	
	-- Stop the Lead Tank
	Cmd_Stop(sg_hunt_a_t34_01)
	
	-- Stop the following tanks
	Rule_AddOneShot(_intro_Brummbar_Stop_SU76, 1)
	Rule_AddOneShot(_intro_Brummbar_Stop_T34_02, 1.5)
	
	-- Attack the Brummbar
	Cmd_Attack(sg_hunt_a_t34_01, eg_hunt_brummbar, false, true)
	
	-- Ping the Minimap and fire Event Cue
--~ 	UI_CreateMinimapBlip(mkr_hunt_stop_armour, 5, BT_Combat)
	EventCue_Create(CUE.ATTACKED, 11045884, 11045884, sg_hunt_a_t34_01, nil, _panToBrummbar)	-- LOCDB [11045884] 'Enemy Armor Spotted'
	
	-- Start The Hit Check
	Event_OnHealth(_intro_Brummbar_Hit, nil, eg_hunt_brummbar, 0.95, false, 2)

end

function _intro_Brummbar_Stop_SU76() Cmd_Stop(sg_hunt_a_su85) end
function _intro_Brummbar_Stop_T34_02() Cmd_Stop(sg_hunt_a_t34_02) end

function _intro_Brummbar_Hit()

	-- Stop the Attack
	Cmd_Stop(sg_hunt_a_t34_01)
	
	-- Remove the Rotation Mod
	Modifier_Remove(g_temp_t34_01_turretRot)
	
	-- Play Intel
	Util_StartIntel(EVENTS.INTRO_BRUMMBAR_HIT)
	
	-- Start the check to move out
	Event_NarrativeEventsNotRunning(_intro_T34_01_Move_Out_After_Brummbar, nil, 1.5)
	Event_NarrativeEventsNotRunning(_intro_T34_02_Move_Out_After_Brummbar, nil, 4)
	Event_NarrativeEventsNotRunning(_intro_SU76_Move_Out_After_Brummbar, nil, 2)
	
	-- Setup Second Speech Events
	Event_Proximity(EventHandler_StartIntel, {intel_callback = EVENTS.INTRO_SPEECH_03}, player3, mkr_intro_speech_trig_03, nil, ANY)
	
	-- Setup Massacre Check
	Rule_Add(_massacre_KickOff)

end

function _intro_T34_01_Move_Out_After_Brummbar() Cmd_SquadPath(sg_hunt_a_t34_01, "pth_a_t34_01", true, false, false, 0) end
function _intro_T34_02_Move_Out_After_Brummbar() Cmd_SquadPath(sg_hunt_a_t34_02, "pth_a_t34_02", true, false, false, 0) end
function _intro_SU76_Move_Out_After_Brummbar() Cmd_SquadPath(sg_hunt_a_su85, "pth_a_su85_a", true, false, false, 0) end

-- Intro:: Massacre
function _massacre_KickOff()

	if Prox_AreSquadsNearMarker(sg_hunt_a_su85, mkr_massacre_trig_A, ANY)
	  and Prox_AreSquadsNearMarker(sg_hunt_a_t34_02, mkr_massacre_trig_B, ANY) then
		Rule_RemoveMe()
		
		-- Recrew the Tiger
		EGroup_SetSelectable(eg_e_tiger, true)
		EGroup_SetRecrewable(eg_e_tiger, true)
		Cmd_RecrewVehicle(sg_tiger_crew, eg_e_tiger)
		
		-- Reveal the area
		FOW_RevealMarker(mkr_massacre_tiger_reveal, 10)
		
		-- Preload stuff for skipping NISes
		-- Check for T34 damage
		Event_OnHealth(_massacre_destroy_T34_02, nil, sg_hunt_a_t34_02, 0.99, false)
		
		-- Start Capture Check
		Util_StartNislet(EVENTS.CAMERA_TIGER, _skipTigerReveal)
		
		
		Rule_Add(_massacre_Tiger_Recrewed)
	end

end

function _skipTigerReveal()
	
	Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 0)
	Util_PlayMusic(g_music_tiger_reveal, 0, 0)
	
	-- Warp the Tiger and set it up
	SGroup_WarpToMarker(sg_e_tiger, mkr_massacre_tiger_dest_A)
	
	SGroup_SetSelectable(sg_e_tiger, true)
	
	-- Remove Allied Tank modifiers
	Modifier_Remove(g_temp_t34_01_mod)
	Modifier_Remove(g_temp_su85_mod)
	
	Modifier_RemoveAllFromSGroup(sg_hunt_a_t34_01)
	Modify_UnitSpeed(sg_hunt_a_t34_01, 0.8)
	
	Modifier_RemoveAllFromSGroup(sg_hunt_a_su85)
	
	FOW_RevealSGroupOnly(sg_hunt_a_t34_01, -1)
	
	-- Warp the Rear T34 and destoy it
	SGroup_WarpToMarker(sg_hunt_a_t34_02, mkr_massacre_t34_02_dest)
	SGroup_SetAvgHealth(sg_hunt_a_t34_02, 0.9)
	
	-- Stop the Tiger from attacking the T34
	if Event_Exists(eventID_attack_t34_02) then Event_Remove(eventID_attack_t34_02) end
	
	SGroup_WarpToMarker(sg_hunt_a_su85, mkr_hunt_a_su85_dest)	
--~ 	SGroup_SnapFacePosition(sg_hunt_a_su85, Util_GetOffsetPosition(mkr_hunt_a_su85_dest, OFFSET_FRONT, 10))
	Cmd_Move(sg_hunt_a_su85, mkr_hunt_a_su85_dest, false, nil, Util_GetOffsetPosition(mkr_hunt_a_su85_dest, OFFSET_FRONT, 10))
	Cmd_Attack(sg_hunt_a_su85, sg_e_tiger, true, true)
	
	-- Warp Forward T34
	SGroup_WarpToMarker(sg_hunt_a_t34_01, mkr_hunt_a_t34_01_skipTO)
	Cmd_Move(sg_hunt_a_t34_01, mkr_hunt_a_t34_01_dest_02)
	
	if Event_Exists(eventID_t34_01_attack_tiger) == false then
		Event_Proximity(_massacre_T34_01_Attack, nil, sg_hunt_a_t34_01, mkr_hunt_a_t34_01_dest_02, 5, ANY)
	end
	
	if Rule_Exists(_massacre_deflection) == false then Rule_AddInterval(_massacre_deflection, 1) end
	
	if EGroup_IsEmpty(LAYER_Building_Wall) == false then EGroup_Kill(LAYER_Building_Wall) end

end

function _skipTigerReveal_Delay() 
	if SGroup_IsEmpty(sg_hunt_a_su85) then Rule_RemoveMe() return end
	if SGroup_IsDoingAttack(sg_e_tiger, ANY, 3) == false and SGroup_IsDoingAttack(sg_hunt_a_su85, ANY, 3) then
		Cmd_Attack(sg_e_tiger, sg_hunt_a_su85) 
	elseif (SGroup_IsDoingAttack(sg_e_tiger, ANY, 3) and SGroup_IsUnderAttack(sg_hunt_a_su85, ANY, 3)) then
		Rule_RemoveMe()
	end
end

function _massacre_Tiger_Recrewed()

	Player_GetAllSquadsNearMarker(player2, sg_e_tiger, mkr_tiger_spawn, 10)
	
	SGroup_Filter(sg_e_tiger, SBP.GERMAN.TIGER_SQUAD_SP_A2_M02, FILTER_KEEP)
--~ 	SGroup_Filter(sg_e_tiger, SBP.GERMAN.TIGER_SQUAD, FILTER_KEEP)
	
	if SGroup_IsEmpty(sg_e_tiger) == false then
		Rule_RemoveMe()
		
		-- Set Difficulty Mods
		if g_difficulty == GD_EASY then
			Modify_WeaponEnabled(Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_e_tiger, 1), 0), "hardpoint_03", false)
		elseif g_difficulty == GD_NORMAL then
			SGroup_SetAutoTargetting(sg_e_tiger, "hardpoint_03", true)
		elseif g_difficulty == GD_HARD then
			SGroup_SetAutoTargetting(sg_e_tiger, "hardpoint_03", true)
			Cmd_Upgrade(sg_e_tiger, BP_GetUpgradeBlueprint("grant_m08_tiger_mg"), 1, true)
		end
		
		-- Disable auto-targetting
		SGroup_SetAutoTargetting(sg_e_tiger, "hardpoint_01", false)
		
		-- Hide UI
		SGroup_EnableUIDecorator(sg_e_tiger, false)
		SGroup_EnableMinimapIndicator(sg_e_tiger, false)
		
		-- Set the Tiger invuln
		Squad_SetInvulnerableMinCap(SGroup_GetSpawnedSquadAt(sg_e_tiger, 1), 1, -1)
		
		-- Set it unselectable
		SGroup_SetSelectable(sg_e_tiger, false)
		
		-- Modify the Tiger
		g_tiger_accuracy = Modify_WeaponAccuracy(sg_e_tiger, "hardpoint_01", 9)
		g_tiger_pen = Modify_WeaponPenetration(sg_e_tiger, "hardpoint_01", 9)
		g_temp_Tiger_Speed = Modify_UnitSpeed(sg_e_tiger, 2.5)
		
		local modifier = Modifier_Create(MAT_Entity, "modifiers\\sight_cone_angle_modifier.lua", MUT_Multiplication, false, 0.25, "")
		g_tiger_cone = Modifier_ApplyToEntity(modifier, Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_e_tiger, 1), 0))
		
		Rule_AddOneShot(_massacre_Tiger_MoveOut, 4.0) --4.2
		
		Event_PlayerCanSeeElement(_massacre_Tiger_Spotted, nil, player1, sg_e_tiger, ANY, 8.5)
	end

end

function _massacre_Tiger_MoveOut() 
	
	Cmd_Move(sg_e_tiger, mkr_massacre_tiger_dest_A) 
	
end

function _massacre_Tiger_Spotted()
	
	-- Set the Tiger selectable
	SGroup_SetSelectable(sg_e_tiger, true)
	
	-- Remove Allied Tank modifiers
	Modifier_Remove(g_temp_t34_01_mod)
	Modifier_Remove(g_temp_su85_mod)
	
	FOW_RevealSGroupOnly(sg_hunt_a_t34_01, -1)
	
	Modifier_RemoveAllFromSGroup(sg_hunt_a_t34_01)
	Modify_UnitSpeed(sg_hunt_a_t34_01, 0.8)
	
	Modifier_RemoveAllFromSGroup(sg_hunt_a_su85)
	
	-- Tiger Attacks Second T34
--~ 	eventID_attack_t34_02 = Event_Proximity(_massacre_Tiger_Attack_T34_02, nil, sg_e_tiger, mkr_massacre_tiger_dest_A, 5, ANY, 2)
	eventID_attack_t34_02 = Event_Proximity(_massacre_Tiger_Attack_T34_02, nil, sg_hunt_a_t34_02, mkr_massacre_t34_02_dest, 5, ANY, 2)
	
	-- Allied response
	-- Second T34 Attacks Tiger
	if SGroup_IsEmpty(sg_hunt_a_t34_02) == false then Cmd_Attack(sg_hunt_a_t34_02, sg_e_tiger, true) end
	
	-- First T34 Flanks
	Cmd_Move(sg_hunt_a_t34_01, mkr_hunt_a_t34_01_dest_02)
	eventID_t34_01_attack_tiger = Event_Proximity(_massacre_T34_01_Attack, nil, sg_hunt_a_t34_01, mkr_hunt_a_t34_01_dest_02, 5, ANY)

end

function _massacre_T34_01_Attack() Cmd_Attack(sg_hunt_a_t34_01, sg_e_tiger, true, true) end

function _massacre_Tiger_Attack_T34_02() Cmd_Attack(sg_e_tiger, sg_hunt_a_t34_02, true, false) end

function _massacre_destroy_T34_02() 
	
	-- Destroy the T-34
	if SGroup_IsEmpty(sg_hunt_a_t34_02) == false then SGroup_Kill(sg_hunt_a_t34_02)  end
	
	-- Slow the Tiger down
	Modifier_Remove(g_temp_Tiger_Speed)
	_tiger_Speed_Mod = Modify_UnitSpeed(sg_e_tiger, 0.75)
	
	if Rule_Exists(_massacre_deflection) == false then Rule_AddInterval(_massacre_deflection, 1) end
	
	-- Play Intel
	Util_StartIntel(EVENTS.MASSACRE_REAR_TANK_DEAD) 
	
	FOW_RevealSGroupOnly(sg_hunt_a_su85, 60*20)
	
	-- Check for SU-76 damage
	Event_OnHealth(_massacre_destroy_SU76, nil, sg_hunt_a_su85, 0.99, false)
	
end

function _massacre_deflection()
	if SGroup_IsDoingAttack(sg_hunt_a_su85, ANY, 3) then
		Rule_RemoveMe()
		
		Rule_AddOneShot(_massacre_deflection_intel, 1)
	end
end

function _massacre_deflection_intel()
	Util_StartIntel(EVENTS.MASSACRE_DEFLECTION)
	
	-- Attack SU76
	Cmd_Attack(sg_e_tiger, sg_hunt_a_su85)
end

function _massacre_destroy_SU76()

	-- Destroy the SU-76
	SGroup_Kill(sg_hunt_a_su85)
	
	-- Increase lead T34's armour pen
	g_t34_pen = Modify_WeaponPenetration(sg_hunt_a_t34_01, "hardpoint_01", 6)
	
	-- Hold Fire
	SGroup_SetAutoTargetting(sg_e_tiger, "hardpoint_01", false)
	
	-- Make Vuln
	Squad_SetInvulnerableMinCap(SGroup_GetSpawnedSquadAt(sg_e_tiger, 1), 0.9, -1)
	
	-- Check for damage
	Event_OnHealth(_massacre_Tiger_Hit, nil, sg_e_tiger, 0.99, false)
	
end

function _massacre_Tiger_Hit()

	-- Move and attack the T-34
	Cmd_Move(sg_e_tiger, mkr_massacre_tiger_dest_B)
	Cmd_Attack(sg_e_tiger, sg_hunt_a_t34_01, true)
	
	Modifier_Remove(g_t34_pen)
	
	-- Check for T-34 Damage
	Event_OnHealth(_massacre_Destroy_T34_Gun, nil, sg_hunt_a_t34_01, 0.99, false)

end

function _massacre_Destroy_T34_Gun()
	
	-- Stop the Tiger
	Cmd_Stop(sg_e_tiger)
	
	-- Destroy the main gun
	Cmd_CriticalHit(player2, sg_hunt_a_t34_01, CRIT.VEHICLE_DESTROY_MAINGUN, 1)
	
	-- Store the current health
	SGroup_SetAvgHealth(sg_hunt_a_t34_01, 0.5)
	
	Squad_SetInvulnerableMinCap(SGroup_GetSpawnedSquadAt(sg_hunt_a_t34_01, 1), 0.2, -1)
	
	SGroup_SetAutoTargetting(sg_e_tiger, "hardpoint_01", false)
	
	-- Slow the T-34
	Modify_UnitSpeed(sg_hunt_a_t34_01, 0.2)
	
	-- Move the T-34
	Rule_AddOneShot(_massacre_Move_T34, 1.6)

end

function _massacre_Move_T34()
	
	Util_StartIntel(EVENTS.MASSACRE_T34_RUNNING)
	
	-- Move the Tank
	Cmd_Move(sg_hunt_a_t34_01, mkr_hunt_a_t34_01_dest_03)
	
	-- Delay before firing the Tiger
	Event_NarrativeEventsNotRunning(_massacre_Finish_T34, nil, 1)

end

function _massacre_Finish_T34() 
	
	Cmd_Attack(sg_e_tiger, sg_hunt_a_t34_01)
	
	Event_OnHealth(_massacre_Destroy_T34, nil, sg_hunt_a_t34_01, 0.48, false) 
	
end

function _massacre_Destroy_T34()
	
	-- Skip the Event
	Event_Skip()
	
	Squad_SetInvulnerableToCritical(SGroup_GetSpawnedSquadAt(sg_hunt_a_t34_01, 1), false)
	Squad_SetInvulnerableMinCap(SGroup_GetSpawnedSquadAt(sg_hunt_a_t34_01, 1), 0, -1)
	
	Modifier_RemoveAllFromSGroup(sg_hunt_a_t34_01)
	
	-- Out of Control
	_massarce_Out_Of_Control()
	
	-- Defensive Mods
	g_tiger_armour = Modify_Armor(sg_e_tiger, t_difficulty.tiger_armor)
	g_tiger_receved_dam = Modify_ReceivedDamage(sg_e_tiger, t_difficulty.tiger_received_damage)
	
	g_tiger_sight_range = Modify_SightRadius(sg_e_tiger, t_difficulty.tiger_sight_range)
	g_tiger_weapon_reload = Modify_WeaponReload(sg_e_tiger, "hardpoint_01", t_difficulty.tiger_weapon_reload)
	g_tiger_weapon_scatter = Modify_WeaponScatter(sg_e_tiger, "hardpoint_01", t_difficulty.tiger_weapon_scatter)
	
	-- Tiger is weapons free
	SGroup_SetAutoTargetting(sg_e_tiger, "hardpoint_01", true)
	
	Rule_AddOneShot(_massacre_Finish, 2)

end

function _massarce_Out_Of_Control()

	Entity_ApplyCritical(Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_hunt_a_t34_01, 1), 0), CRIT.VEHICLE_OUT_OF_CONTROL_FAST, 0.1)
	
	Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 0)
	Util_PlayMusic(g_music_repair_part1, 0, 4)

end

function _massacre_Finish()
	
	FOW_UnRevealMarker(mkr_tiger_reveal_area)
	
	TIGER_Add_To_AI()
	
	Event_OnHealth(TIGER_Retreat_To_Airfield, nil, sg_e_tiger, 0.5, false)
	
	Objective_Complete(SOBJ_EscortTanks, false)
	
	Rule_AddInterval(TheHunt_Tiger_Disappeared_Once, 1)

end

-- Post Massacre
function TheHunt_Tiger_Disappeared_Once()

	if Player_CanSeeSGroup(player1, sg_e_tiger, ALL) == false then 
		Rule_RemoveMe()
		_tigerHasVanishedOnce = true
	end

end
function TheHunt_SitRep_Delay()

	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		
		Rule_AddOneShot(Escape_AutoSave, 2)
	end

end

function TheHunt_SitRep()
	
	Util_PlayMovie("m08_sitrep", 2.5, 2.5, Escape_Obj_Start)

end

function TheHunt_Tiger_Hidden() Rule_AddInterval(TheHunt_Tiger_Seen, 1) end

function TheHunt_Tiger_Seen()
	
	if _playerToldFlank == true then
		Rule_RemoveMe()
		return
	else
		if Player_CanSeeSGroup(player1, sg_e_tiger, ANY) then
			if Prox_SquadsInProximityOfSquads(sg_hunt_p_units, sg_e_tiger, 40, ANY) then
				if Player_CanSeeSGroup(player2, sg_hunt_p_units, ANY) then
					if _playerSeenTiger_loud == false then 
						Util_StartIntel(EVENTS.TH_TIGER_SPOTTED_LOUD)
						_playerSeenTiger_loud = true
					end
				elseif Player_CanSeeSGroup(player2, sg_hunt_p_units, ALL) == false then
					if _playerSeenTiger_quiet == false then
						Util_StartIntel(EVENTS.TH_TIGER_SPOTTED_QUIET)
						Util_StartIntel(EVENTS.TH_CANT_SEE)
						_playerSeenTiger_quiet = true
						_playerToldFlank = true
					end
				end
			else
				return
			end
		end
	end

end

function TheHunt_Collect_Player_Units() 
	Player_GetAll(player1, sg_hunt_p_units) 
end
function DestroyTiger_Start()
	
	Resources_Enable()
	
	Objective_Start(OBJ_TheHunt, false)
	Objective_Start(SOBJ_DestroyTiger)

end
function TheHunt_AT_Rifles()
	sg_e_atRifle_attackers = SGroup_CreateIfNotFound("sg_e_atRifle_attackers")
	if SGroup_IsUnderAttack(sg_e_tiger, ANY, 3) then
		SGroup_GetLastAttacker(sg_e_tiger, sg_e_atRifle_attackers)
		local _findATRifle = function(gid, idx, sid)
			if Squad_HasSlotItem(sid, SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP) then
				Rule_RemoveMe()
				Util_StartIntel(EVENTS.TH_AT_RIFLES)
				return
			end
		end
		SGroup_ForEach(sg_e_atRifle_attackers, _findATRifle)
	end
end


function TheHunt_AutoTargetting_Off(player, command, target)
	if command == BP_GetAbilityBlueprint("tank_buster_conscript_dispatch") then
		sg_squadCheck = SGroup_CreateIfNotFound("sg_squadCheck")
		SGroup_Clear(sg_squadCheck)
		Player_GetAll(player1, sg_squadCheck)
		SGroup_RemoveGroup(sg_squadCheck, sg_hunt_p_units)
		
		local _ceaseFire = function(gid, idx, sid)
			if Squad_GetBlueprint(sid) == SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD
			  or Squad_GetBlueprint(sid) == SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD then
				return
			end
			SGroup_SetAutoTargetting(gid, "hardpoint_01", false)
			SGroup_Add(sg_hunt_p_units, sid)
		end
		
		SGroup_ForEach(sg_squadCheck, _ceaseFire)
	end
end

function TheHunt_AT_Gun_Captured()

	for i = 1, table.getn(_atGuns) do
		if Player_OwnsEntity(player1, Entity_FromWorldID(_atGuns[i])) then
			Rule_RemoveMe()
			
			Util_StartIntel(EVENTS.TH_AT_GUNS_COLLECTED)
		end
	end

end

function _panToReinforcements() Camera_MoveTo(Util_GetPosition(mkr_hunt_p_eng02_dest), true, 0.5, false, true) end
function TheHunt_Mines()

	if Player_HasBuildingUnderConstruction(player1, EBP.SOVIET.SOVIET_MINE) then
		Rule_RemoveMe()
		
		Util_StartIntel(EVENTS.TH_MINES)
	end	

end
--|| BEAT ENCOUNTERS ||
---------------------
-- TIGER AI
---------------------
function TIGER_Init()

	sg_e_tiger = SGroup_CreateIfNotFound("sg_e_tiger")
	eg_e_tiger = EGroup_CreateIfNotFound("eg_e_tiger")
	
	Util_CreateSquads(player2, sg_e_tiger, SBP.GERMAN.TIGER_SQUAD_SP_A2_M02, mkr_tiger_spawn)
	Entity_ApplyCritical(Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_e_tiger, 1), 0), CRIT.VEHICLE_ABANDON_M8_TIGER, 1)
	World_GetNeutralEntitiesNearPoint(eg_e_tiger, Util_GetPosition(mkr_tiger_spawn), 5)
	EGroup_Filter(eg_e_tiger, EBP.GERMAN.TIGER_SDKFZ_181_SINGLEPLAYER_MISSION, FILTER_KEEP)
	
	EGroup_EnableMinimapIndicator(eg_e_tiger, false)
	EGroup_EnableUIDecorator(eg_e_tiger, false)
	EGroup_SetSelectable(eg_e_tiger, false)
	
	sg_tiger_crew = SGroup_CreateIfNotFound("sg_tiger_crew")
	
	Util_CreateSquads(player2, sg_tiger_crew, SBP.GERMAN.PIONEER_SQUAD, mkr_tiger_crew_spawn, nil, 1, 3)
	SGroup_SetInvulnerable(sg_tiger_crew, true)
	SGroup_EnableMinimapIndicator(sg_tiger_crew, false)
	SGroup_EnableUIDecorator(sg_tiger_crew, false)
	SGroup_SetSelectable(sg_tiger_crew, false)
	SGroup_Hide(sg_tiger_crew, false)
	
	-- Setup Tiger AI
	TIGER_AI_Init()
	
	Event_OnHealth(_tiger_Add_HMG, nil, sg_e_tiger, 0.90, false, 2)

end

---******--
-- TIGER AI
function TIGER_AI_Init()

	sg_e_tiger_target = SGroup_CreateIfNotFound("sg_e_tiger_target")
	sg_e_tiger_attackers = SGroup_CreateIfNotFound("sg_e_tiger_attackers")
	sg_e_tiger_pakAttackers = SGroup_CreateIfNotFound("sg_e_tiger_pakAttackers")
	sg_e_tiger_atRifles = SGroup_CreateIfNotFound("sg_e_tiger_atRifles")
	sg_e_tiger_forcedTarget = SGroup_CreateIfNotFound("sg_e_tiger_forcedTarget")
	
	_tigerHiding = true
	_tigerLastPos = nil
	-- Setup South Hunting ground
	_Hunt_Tiger_Matrix_South()
	
	_hunting_Ground = "SOUTH"
	
	Rule_AddInterval(TIGER_AI, 1)

end

function TIGER_AI()
	
	if _tigerHiding == true then return end
	
	-- Check if the Tiger leaves its' leash
	if _hunting_Ground == "NORTH" then
		if Prox_AreSquadsNearMarker(sg_e_tiger, mkr_theHunt_airfield_leash, ANY) == false then
			_tigerHiding = true
			encID_tiger:Disable()
			encID_tiger:ClearGoal()
			
			local pos = nil
			if _hunting_Ground == "SOUTH" then
				pos = Util_GetClosestMarker(sg_e_tiger, Marker_GetTable("mkr_theHunt_tiger_south_%02d"))
			else
				pos = Util_GetClosestMarker(sg_e_tiger, Marker_GetTable("mkr_theHunt_tiger_north_%02d"))
			end
			
			Cmd_Stop(sg_e_tiger)
			
--~ 			if SGroup_IsMoving(sg_e_tiger, ANY) == false then 
--~ 				print("MOVING")
--~ 				Cmd_Move(sg_e_tiger, pos)
			Command_SquadMovePosFacing(player2, sg_e_tiger, Util_GetPosition(pos), Util_GetPosition(pos), false, true)
				
				_tiger_curr_pos = pos
--~ 			end
			
			Util_StartIntel(EVENTS.TH_TIGER_RETURN_TO_COMBAT_AREA)
			
			Event_Proximity(_tiger_return_to_combat, nil, sg_e_tiger, _tiger_curr_pos, nil, ANY)
		end
	end
	
	-- Is Tiger under attack
	if SGroup_IsUnderAttack(sg_e_tiger, ANY, 5)
	  or SGroup_IsDoingAttack(sg_e_tiger, ANY, 5) then
		print("Tiger is in combat")
		SGroup_Clear(sg_e_tiger_target)
		SGroup_Clear(sg_e_tiger_attackers)
		SGroup_Clear(sg_e_tiger_pakAttackers)
		SGroup_Clear(sg_e_tiger_atRifles)
		
		if encID_tiger:IsEnabled() then
			-- Tiger has a target
			print("Tiger has a target")
			local goalData = encID_tiger:GetGoalData()
			
			if SGroup_IsRetreating(goalData.target, ANY) then
--~ 				print("Target retreating")
				encID_tiger:Disable()
				encID_tiger:ClearGoal()
				return
			end
			
			-- Collect all attackers
			Squad_GetLastAttackers(SGroup_GetSpawnedSquadAt(sg_e_tiger, 1), sg_e_tiger_attackers, 3)
			
			-- Remove the current target from the attackers sgroup
			SGroup_RemoveGroup(sg_e_tiger_attackers, sg_e_tiger_forcedTarget)
			
			if SGroup_IsEmpty(goalData.target) then encID_tiger:Disable() encID_tiger:ClearGoal() return end
			_targetingATGun = false
			
			-- Is the Tiger fighting an AT Gun?
			if SGroup_IsEmpty(sg_e_tiger_attackers) == false
			  and Squad_GetBlueprint(SGroup_GetSpawnedSquadAt(goalData.target, 1)) ~= SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD then
				print("Target NOT an AT Gun")
				-- Tiger is not fighting an AT Gun, we shoudl check if there's one
				
				SGroup_Filter(sg_e_tiger_attackers, SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD, FILTER_REMOVE, sg_e_tiger_pakAttackers)
				
				if SGroup_IsEmpty(sg_e_tiger_pakAttackers) == false then
					print("AT Gun found, target")
					SGroup_Clear(sg_e_tiger_forcedTarget)
					SGroup_Add(sg_e_tiger_forcedTarget, SGroup_GetSpawnedSquadAt(sg_e_tiger_pakAttackers, 1))
					
					_targetingATGun = true
					
					_Tiger_Assign_Target(sg_e_tiger_forcedTarget)
					return
				end
			elseif SGroup_IsEmpty(sg_e_tiger_attackers) == false
			  and Squad_GetBlueprint(SGroup_GetSpawnedSquadAt(goalData.target, 1)) == SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD then
				_targetingATGun = true
			end
			
			if _targetingATGun == false
			  and SGroup_IsEmpty(sg_e_tiger_attackers) == false
			  and Squad_HasSlotItem(SGroup_GetSpawnedSquadAt(goalData.target, 1), SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP) == false then
				-- Tiger is not fighting an squad with an AT rifle, we should check if there's one
				print("Target NOT an AT Rifle")
				
				local _findATRifle = function(gid, idx, sid)
					if Squad_HasSlotItem(sid, SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP) then
						SGroup_Add(sg_e_tiger_atRifles, sid)
						print("AT Rifle found, target")
						SGroup_Clear(sg_e_tiger_forcedTarget)
						SGroup_Add(sg_e_tiger_forcedTarget, SGroup_GetSpawnedSquadAt(sg_e_tiger_atRifles, 1))
						
						_Tiger_Assign_Target(sg_e_tiger_forcedTarget)
						return
					end
				end
				
				SGroup_ForEach(sg_e_tiger_attackers, _findATRifle)
			end
			
			-- Is the Tiger fighting an AT Rifle?
			
			-- Now to handle visibility
			if Player_CanSeeSGroup(player2, goalData.target, ALL) == false then
				print("Tiger cannot see target")
				-- Player cannot see his current target
				-- If there are other targets nearby, engage them
				if SGroup_IsEmpty(sg_e_tiger_attackers) == false then
					print("Other targets found, re-engage")
					encID_tiger:Disable()
					encID_tiger:ClearGoal()
				end
			end
			return
			
		else
			print("Tiger has no target")
			Squad_GetLastAttackers(SGroup_GetSpawnedSquadAt(sg_e_tiger, 1), sg_e_tiger_attackers, 1)
			
			SGroup_Filter(sg_e_tiger_attackers, SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD, FILTER_REMOVE, sg_e_tiger_pakAttackers)
			
			-- Is there a pak gun?
			if SGroup_IsEmpty(sg_e_tiger_pakAttackers) == false then
				SGroup_Clear(sg_e_tiger_forcedTarget)
				SGroup_Add(sg_e_tiger_forcedTarget, SGroup_GetSpawnedSquadAt(sg_e_tiger_pakAttackers, 1))
				
				_Tiger_Assign_Target(sg_e_tiger_forcedTarget)
				return
			else
				-- No Pak gun, just get a target
				if SGroup_IsEmpty(sg_e_tiger_attackers) == false then
					SGroup_Clear(sg_e_tiger_forcedTarget)
					SGroup_Add(sg_e_tiger_forcedTarget, SGroup_GetSpawnedSquadAt(sg_e_tiger_attackers, 1))
					
					_Tiger_Assign_Target(sg_e_tiger_forcedTarget)
					return
				end
			end
			
		end
		
	else
		_findVisible_Units()
		if SGroup_IsEmpty(sg_visible_units) == false then 
			print("Found a unit")
			SGroup_Clear(sg_e_tiger_forcedTarget)
			SGroup_AddGroup(sg_e_tiger_forcedTarget, sg_visible_units)
			
			_Tiger_Assign_Target(sg_e_tiger_forcedTarget)
			return
		end
--~ 		print("Tiger not in combat")
		if encID_tiger:IsEnabled() == false then
			-- Only patrol if his AI is off
			if Prox_AreSquadsNearMarker(sg_e_tiger, _tiger_curr_pos, ANY) then
--~ 				print("Tiger at Dest")
				if Timer_Exists(_tiger_wait_tmr) then
					if Timer_GetRemaining(_tiger_wait_tmr) == 0 then
						Timer_End(_tiger_wait_tmr)
						
						Cmd_SquadPath(sg_e_tiger, _tiger_curr_pth, true, false, true, 0)
					end
				else
					local dest, path = _Hunt_Find_New_Dest(_tiger_prev_pos, _tiger_curr_pos)
					
					_tiger_prev_pos = _tiger_curr_pos
					
					_tiger_curr_pos = dest
					_tiger_curr_pth = path
					
					Timer_Start(_tiger_wait_tmr, _tiger_wait_time)
					return
				end
			else
				local pos = nil
				if _hunting_Ground == "SOUTH" then
					pos = Util_GetClosestMarker(sg_e_tiger, Marker_GetTable("mkr_theHunt_tiger_south_%02d"))
				else
					pos = Util_GetClosestMarker(sg_e_tiger, Marker_GetTable("mkr_theHunt_tiger_north_%02d"))
				end
				
				if SGroup_IsMoving(sg_e_tiger, ANY) == false then 
					Cmd_Move(sg_e_tiger, pos)
					
					_tiger_curr_pos = pos
				end
			end
		end
	end

end

function _findVisible_Units()
	
	sg_visible_units = SGroup_CreateIfNotFound("sg_visible_units")
	SGroup_Clear(sg_visible_units)
	
	Player_GetAll(player1)
	
	local _findVisible = function(gid, idx, sid)
--~ 		print("SEARCHING")
		if Player_CanSeeSquad(player2, sid, ALL) then
--~ 			print("CAN SEE")
			SGroup_Add(sg_visible_units, sid)
		else
--~ 			print("CANT SEE")
		end
	end
	
	SGroup_ForEach(sg_allsquads, _findVisible)

end

function _tiger_return_to_combat() _tigerHiding = false end

function _Tiger_Assign_Target(sgroup)

	encID_tiger:ClearGoal()
	
	local goalData = {
		name = "Attack",
		target = sgroup,
		
		leashRange = 150,
		range = 20,
		
		attackMove = true,
		
		maxTime = 180,
		maxIdleTime = 20,
		
		onSuccess = _returnToPatrol,
		onFailure = _returnToPatrol,
		
		tacticControlsList = {
			{
				tacticType = TACTIC_RushAtTarget,
				priority = 500,
				retryTimeSecs = 10,
				waitTimeSecs = 20,
			},
			{
				tacticType = TACTIC_Vehicle,
				waitTimeSecs = t_difficulty.tiger_avoid_at,
				timeoutTimeSecs = 30,
			},
		},
	}
	
	encID_tiger:SetGoal(goalData)
	encID_tiger:Enable()

end

function _Hunt_Find_New_Dest(prevPos, currPos)
	
	local searchTable = nil
	
	for k, v in pairs(_t_Tiger_Move) do
		if v.depart == currPos then
			searchTable = Clone(_t_Tiger_Move[k].dests)
			break
		end
	end
	
	if searchTable ~= nil then
		for k, v in pairs(searchTable) do
			if v.tar == prevPos then table.remove(searchTable, k) break end
		end
		local id = World_GetRand(1, table.getn(searchTable))
		
		return searchTable[id].tar, searchTable[id].path
	end

end

function TIGER_Add_To_AI()
	
	encID_tiger = Encounter:ConvertSgroup(sg_e_tiger)
	
	local goalData = {
		name = "Attack",
		target = mkr_hunt_e_tiger_reveal_dest,
		
		leashRange = 150,
		range = 15,
		
		attackMove = true,
		
		maxIdleTime = 5,
		maxTime = 50,
		
		onSuccess = _returnToPatrol,
		onFailure = _returnToPatrol,
	}
	
	encID_tiger:SetGoal(goalData)
	
	encID_tiger:Disable()

end

function _returnToPatrol(encounter) encID_tiger:Disable() end
function _tiger_Add_HMG() Cmd_Upgrade(sg_e_tiger, BP_GetUpgradeBlueprint("grant_m08_tiger_mg"), 1, true) end
-- Setup Tiger Hunting Grounds
function _Hunt_Tiger_Matrix_South()
	
	_tiger_curr_pos = mkr_theHunt_tiger_south_02
	_tiger_curr_pth = nil
	_tiger_prev_pos = mkr_theHunt_tiger_south_02
	
	_tiger_wait_time = 8
	_tiger_wait_tmr = "tmr_tiger_wait"
	
	_t_Tiger_Move = {
		{
			depart = mkr_theHunt_tiger_south_01,
			dests = {
				{tar = mkr_theHunt_tiger_south_02, path = "pth_tiger_01_B"},
				{tar = mkr_theHunt_tiger_south_03, path = "pth_tiger_06_A"},
				{tar = mkr_theHunt_tiger_south_06, path = "pth_tiger_05_A"},
			},
		},
		{
			depart = mkr_theHunt_tiger_south_02,
			dests = {
				{tar = mkr_theHunt_tiger_south_01, path = "pth_tiger_01_A"},
				{tar = mkr_theHunt_tiger_south_04, path = "pth_tiger_04_A"},
				{tar = mkr_theHunt_tiger_south_05, path = "pth_tiger_02_A"},
				{tar = mkr_theHunt_tiger_south_07, path = "pth_tiger_03_A"},
			},
		},
		{
			depart = mkr_theHunt_tiger_south_03,
			dests = {
				{tar = mkr_theHunt_tiger_south_01, path = "pth_tiger_06_B"},
				{tar = mkr_theHunt_tiger_south_04, path = "pth_tiger_07_A"},
			},
		},
		{
			depart = mkr_theHunt_tiger_south_04,
			dests = {
				{tar = mkr_theHunt_tiger_south_02, path = "pth_tiger_04_B"},
				{tar = mkr_theHunt_tiger_south_03, path = "pth_tiger_07_B"},
				{tar = mkr_theHunt_tiger_south_07, path = "pth_tiger_08_A"},
			},
		},
		{
			depart = mkr_theHunt_tiger_south_05,
			dests = {
				{tar = mkr_theHunt_tiger_south_02, path = "pth_tiger_02_B"},
				{tar = mkr_theHunt_tiger_south_06, path = "pth_tiger_10_A"},
				{tar = mkr_theHunt_tiger_south_07, path = "pth_tiger_09_A"},
			},
		},
		{
			depart = mkr_theHunt_tiger_south_06,
			dests = {
				{tar = mkr_theHunt_tiger_south_01, path = "pth_tiger_05_B"},
				{tar = mkr_theHunt_tiger_south_05, path = "pth_tiger_10_B"},
			},
		},
		{
			depart = mkr_theHunt_tiger_south_07,
			dests = {
				{tar = mkr_theHunt_tiger_south_02, path = "pth_tiger_03_B"},
				{tar = mkr_theHunt_tiger_south_04, path = "pth_tiger_08_B"},
				{tar = mkr_theHunt_tiger_south_05, path = "pth_tiger_09_B"},
			},
		},
	}
	
end

function _Hunt_Tiger_Matrix_North()
	
	_tiger_curr_pos = mkr_theHunt_tiger_north_01
	_tiger_curr_pth = "pth_tiger_n_03_B"
	_tiger_prev_pos = mkr_theHunt_tiger_north_01
	
	_tiger_wait_time = 8
	_tiger_wait_tmr = "tmr_tiger_wait"
	
	_t_Tiger_Move = {
		{
			depart = mkr_theHunt_tiger_north_01,
			dests = {
				{tar = mkr_theHunt_tiger_north_02, path = "pth_tiger_n_01_A"},
				{tar = mkr_theHunt_tiger_north_03, path = "pth_tiger_n_02_A"},
				{tar = mkr_theHunt_tiger_north_04, path = "pth_tiger_n_03_A"},
			},
		},
		{
			depart = mkr_theHunt_tiger_north_02,
			dests = {
				{tar = mkr_theHunt_tiger_north_01, path = "pth_tiger_n_01_B"},
				{tar = mkr_theHunt_tiger_north_03, path = "pth_tiger_n_04_B"},
				{tar = mkr_theHunt_tiger_north_04, path = "pth_tiger_n_05_B"},
				{tar = mkr_theHunt_tiger_north_05, path = "pth_tiger_n_06_A"},
			},
		},
		{
			depart = mkr_theHunt_tiger_north_03,
			dests = {
				{tar = mkr_theHunt_tiger_north_01, path = "pth_tiger_n_02_B"},
				{tar = mkr_theHunt_tiger_north_02, path = "pth_tiger_n_04_A"},
				{tar = mkr_theHunt_tiger_north_05, path = "pth_tiger_n_08_A"},
			},
		},
		{
			depart = mkr_theHunt_tiger_north_04,
			dests = {
				{tar = mkr_theHunt_tiger_north_01, path = "pth_tiger_n_03_B"},
				{tar = mkr_theHunt_tiger_north_02, path = "pth_tiger_n_05_A"},
				{tar = mkr_theHunt_tiger_north_05, path = "pth_tiger_n_07_A"},
			},
		},
		{
			depart = mkr_theHunt_tiger_north_05,
			dests = {
				{tar = mkr_theHunt_tiger_north_02, path = "pth_tiger_n_03_B"},
				{tar = mkr_theHunt_tiger_north_03, path = "pth_tiger_n_08_B"},
				{tar = mkr_theHunt_tiger_north_04, path = "pth_tiger_n_07_B"},
			},
		},
	}
	
end








-- MISC
function TIGER_Retreat_To_Airfield()
	
	Cmd_Upgrade(player2, UPG.GERMAN.PANZER_TACTICIAN, 1, true)
	
	SGroup_AddAbility(sg_e_tiger, ABILITY.GERMAN.PANZER_DEFENSIVE_SMOKE)
	Cmd_Ability(sg_e_tiger, ABILITY.GERMAN.PANZER_DEFENSIVE_SMOKE, nil, nil, true)
	
	_tigerHiding = true
	
	encID_tiger:Disable()
	encID_tiger:ClearGoal()
	
	_hunting_Ground = "NORTH"
	_Hunt_Tiger_Matrix_North()
	
	_tigerSpeedMod = Modify_UnitSpeed(sg_e_tiger, 1.5)
	
	SGroup_EnableMinimapIndicator(sg_e_tiger, false)
	SGroup_EnableUIDecorator(sg_e_tiger, false)
	
	Squad_SetInvulnerableMinCap(SGroup_GetSpawnedSquadAt(sg_e_tiger, 1), 1, -1)
	SGroup_SetInvulnerable(sg_e_tiger, true)
	
	tigerDir = Util_GetOffset(sg_e_tiger, mkr_theHunt_tiger_north_01)
	
	if tigerDir == OFFSET_BACK or tigerDir == OFFSET_BACK_LEFT or tigerDir == OFFSET_BACK_RIGHT then
		Command_SquadMovePos(player2, sg_e_tiger, Util_GetPosition(mkr_theHunt_tiger_north_01), false, true)
	else
		Cmd_Move(sg_e_tiger, mkr_theHunt_tiger_north_01)
	end
	
	Event_Proximity(TIGER_Reactivate, nil, sg_e_tiger, mkr_theHunt_tiger_north_01, nil, ANY)
	
	Event_NarrativeEventsNotRunning(TIGER_Increase_Playable_Area, nil, 2)
	
	Rule_AddInterval(TIGER_Keep_Moving, 1)
	Rule_AddOneShot(TIGER_Tiger_Is_Running_01, 2)

end 

function TIGER_Keep_Moving()

	if SGroup_IsMoving(sg_e_tiger, ANY) == false then
		if tigerDir == OFFSET_BACK or tigerDir == OFFSET_BACK_LEFT or tigerDir == OFFSET_BACK_RIGHT then
			Command_SquadMovePos(player2, sg_e_tiger, Util_GetPosition(mkr_theHunt_tiger_north_01), false, true)
		else
			Cmd_Move(sg_e_tiger, mkr_theHunt_tiger_north_01)
		end
	end

end

function TIGER_Tiger_Is_Running_01() Util_StartIntel(EVENTS.TH_TIGER_RUNNING) end

function TIGER_Increase_Playable_Area() World_IncreaseInteractionStage() EGroup_EnableMinimapIndicator(eg_airfield_cps, true) end

function TIGER_Reactivate()
	
	Rule_Remove(TIGER_Keep_Moving)
	
	_tigerHiding = false
	
	Squad_SetInvulnerableMinCap(SGroup_GetSpawnedSquadAt(sg_e_tiger, 1), 0.14, -1)
	
	Modifier_Remove(_tigerSpeedMod)
	
	SGroup_EnableMinimapIndicator(sg_e_tiger, true)
	SGroup_EnableUIDecorator(sg_e_tiger, true)
	
	Rule_Add(TIGER_Immobilize_Check)

end

function TIGER_Immobilize_Check()

	if SGroup_GetAvgHealth(sg_e_tiger) <= 0.15 then
		Rule_RemoveMe()
		
		if _tigerHiding == true then _tigerHiding = false end
		if Event_Exists(_runFurtherNorth) then Event_Remove(_runFurtherNorth) end
		
		-- Immobilize
		Player_RemoveUpgrade(player2, BP_GetUpgradeBlueprint("disable_vehicle_criticals"))
		Cmd_CriticalHit(player1, sg_e_tiger, CRIT.VEHICLE_LOSE_TREADS_OR_WHEELS, 0.5)
		
		Util_StartIntel(EVENTS.TH_TIGER_IMMOBILE)
		
		Modify_Armor(sg_e_tiger, 0.8)
		
		-- Re-set invuln min cap
		Squad_SetInvulnerableMinCap(SGroup_GetSpawnedSquadAt(sg_e_tiger, 1), 0.04, -1)
		
		Rule_Add(TIGER_Abandon_Check)
	end

end

function TIGER_Abandon_Check()
	
	if SGroup_GetAvgHealth(sg_e_tiger) <= 0.05 and Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		
		_tiger_loc = Util_GetPosition(sg_e_tiger)
		
		-- Destroy main gun
		Cmd_CriticalHit(player1, sg_e_tiger, CRIT.VEHICLE_DESTROY_MAINGUN, 0.9)
		if Rule_Exists(TIGER_AI) then Rule_Remove(TIGER_AI) end
		Rule_Remove(TIGER_Track_UI)
		
		Modifier_RemoveAllFromSGroup(sg_e_tiger)
		
		Squad_SetInvulnerableMinCap(SGroup_GetSpawnedSquadAt(sg_e_tiger, 1), 0, -1)
		
		local tiger_eid = Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_e_tiger, 1), 0)
		_tigerID = Entity_GetGameID(tiger_eid)
		
		Entity_SetInvulnerableMinCap(Entity_FromWorldID(_tigerID), 0.04, -1)
		
		-- Abandon
		Cmd_CriticalHit(player1, sg_e_tiger, CRIT.VEHICLE_ABANDON_M8_TIGER, 0.1)
		
		Objective_Complete(OBJ_TheHunt)
		
		Rule_Remove(TheHunt_Obj_Fail)
		
		Sound_SetMusicCombatValue(0, 60*999999)
		
		-- Collect the Tiger and make him unselectable
		eg_tiger = EGroup_CreateIfNotFound("eg_tiger")
		World_GetNeutralEntitiesNearPoint(eg_tiger, Util_GetPosition(mkr_hunt_tiger_north_search_07), 2000)
		EGroup_Filter(eg_tiger, EBP.GERMAN.TIGER_SDKFZ_181_SINGLEPLAYER_MISSION, FILTER_KEEP)
		
		EGroup_SetRecrewable(eg_tiger, false)
		
		-- Turn on Auto-Targetting
--~ 		Rule_Remove(TheHunt_AutoTarget_Off)
		Rule_RemovePlayerEvent(TheHunt_AutoTargetting_Off, player1)
		Player_GetAll(player1)
		
		SGroup_SetAutoTargetting(sg_allsquads, "hardpoint_01", true)
	end

end

-- Tracking UI
-- This controls the 'last known position' marker system
function TIGER_Track_UI()

	if Player_CanSeeSGroup(player1, sg_e_tiger, ANY) then
		_tigerLastPos = Util_GetPosition(sg_e_tiger)
		
		if hpid_obj_lastPos ~= nil then
			Objective_RemoveUIElements(SOBJ_DestroyTiger, hpid_obj_lastPos)
			hpid_obj_lastPos = nil
		end
		
		if hpid_obj_tiger == nil then
			hpid_obj_tiger = Objective_AddUIElements(SOBJ_DestroyTiger, sg_e_tiger, true, 11045883, false)
		end
	else
		if _tigerLastPos == nil then
			_tigerLastPos = Util_GetPosition(sg_e_tiger)
		end
		if hpid_obj_tiger ~= nil then 
			Objective_RemoveUIElements(SOBJ_DestroyTiger, hpid_obj_tiger) 
			hpid_obj_tiger = nil 
		end
		if hpid_obj_lastPos == nil then
			hpid_obj_lastPos = Objective_AddUIElements(SOBJ_DestroyTiger, _tigerLastPos, true, 11045885, true)	-- LOCDB [11045885] 'Tiger's last known position'
		else
			if Player_CanSeePosition(player1, _tigerLastPos) then
				Objective_RemoveUIElements(SOBJ_DestroyTiger, hpid_obj_lastPos)
				hpid_obj_lasPos = nil
			end
		end
		
	end

end


----------------------------
-- BEAT 2
-- ESCAPE
----------------------------
-- || INIT FUNCTIONS ||
function Escape_Init()
	
	-- General
	Player_SetResource(player1, RT_SovietProgression, 50)
	
	UI_SetSoviet227Visibility(true)
	
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("tank_buster_conscript_dispatch"), ITEM_REMOVED)
	Player_AddAbility(player1, ABILITY.SOVIET.FRONTOVIKI_CONSCRIPT_DISPATCH)
	Player_AddAbility(player1, ABILITY.SOVIET.PENAL_TROOP_DISPATCH_SP) 
	
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.OBSERVATION_POST_FUEL, ITEM_DEFAULT)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.OBSERVATION_POST_MUNITION, ITEM_DEFAULT)
	
	Rule_Add(Escape_Collect_Tiger)

end
--|| OBJECTIVE FUNCTIONS ||
function Escape_Obj_Start()	
	Sound_SetMusicCombatValue(0, 0)
	
	Objective_Start(OBJ_Escape)
end

function Initialize_Escape()

	OBJ_Escape = {
		
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			Player_RemoveUpgrade(player2, UPG.GERMAN.PANZER_TACTICIAN)
			
			Util_ClearWrecksFromMarker(mkr_massacre_trig_A)
			
			Player_SetResource(player1, RT_Manpower, 500)
			
			Objective_Start(SOBJ_Entry, false)
			
			Player_AddAbility(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH)
			Player_SetAbilityAvailability(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH, ITEM_UNLOCKED)
			
			Modifier_Remove(g_mod_man)
			Modifier_Remove(g_mod_mun)
			Modifier_Remove(g_mod_fuel)
			
			Cmd_Upgrade(player3, BP_GetUpgradeBlueprint("allow_building_hq"), 1, true)
			
--~ 			g_mod_man = Modify_PlayerResourceRate(player1, RT_Manpower, t_difficulty.Manpower_Rate)
			g_mod_fuel = Modify_PlayerResourceRate(player1, RT_Fuel, t_difficulty.Fuel_Rate)
			g_mod_mun = Player_SetResource(player1, RT_Munition, t_difficulty.starting_Munitions)
			
			g_mod_man_cap = Modify_PlayerResourceCap(player1, RT_Manpower, t_difficulty.Manpower_Cap, MUT_Addition)
			g_mod_mun_cap = Modify_PlayerResourceCap(player1, RT_Munition, t_difficulty.Munition_Cap, MUT_Addition)
			g_mod_fuel_cap = Modify_PlayerResourceCap(player1, RT_Fuel, t_difficulty.Fuel_Cap, MUT_Addition)
			
			Player_SetPopCapOverride(player1, t_difficulty.Pop_Cap_Escape)
			
			SGroup_SetSelectable(sg_e_tiger, true)
			
			Modifier_Remove(_modID_player2_vet)
			
			-- Setup HQ
			EGroup_InstantCaptureStrategicPoint(eg_esc_hq_sector, player1)
			EGroup_SetSelectable(eg_esc_hq, true)
			
			-- TEMP
--~ 			Game_EnableInput(true)
--~ 			Camera_SetInputEnabled(true)
--~ 			
			tmr_esc_init = "tmr_esc_init"
			Timer_Start(tmr_esc_init, t_difficulty.attackWaveStartDelay)
			
--~ 			Rule_AddInterval(Escape_Encounters_Init, 1)
			
			-- Spawn new units for the player
--~ 			sg_esc_p_truck01 = SGroup_CreateIfNotFound("sg_esc_p_truck01")
			sg_esc_p_truck02 = SGroup_CreateIfNotFound("sg_esc_p_truck02")
			
--~ 			Util_CreateSquads(player3, sg_esc_p_truck01, BP_GetSquadBlueprint("us6_truck_squad"), mkr_esc_p_truck01_spawn, mkr_esc_p_truck01_dest)
			Util_CreateSquads(player1, sg_esc_p_truck02, SBP.SOVIET.M5_HALFTRACK_SQUAD, mkr_esc_p_truck02_spawn, mkr_esc_p_truck02_dest)
			
			Escape_Construct_Base()
			
--~ 			Cmd_Move(sg_esc_p_truck01, mkr_esc_p_truck01_dest)
			Cmd_Move(sg_esc_p_truck02, Util_GetOffsetPosition(_tiger_loc, OFFSET_BACK, 15))
			
--~ 			SGroup_SetSelectable(sg_esc_p_truck01, false)
--~ 			SGroup_SetSelectable(sg_esc_p_truck02, false)
			
			Rule_AddOneShot(Escape_SpawnTruck_Units, 1)
			
			Cmd_Upgrade(sg_p_tiger, BP_GetUpgradeBlueprint("grant_m08_tiger_mg"), 1, true)
			
			EGroup_DeSpawn(eg_alt_map_entry)
			
			-- Attack info
			_transport_init()
			
			_attack_curr_Level = 1
			_attack_first_Wave = true
			
			_attack_break_count = 0			-- 
			tmr_break_time = "tmr_break_time"
			_attack_break = false
			
			_engaged_in_town = false	-- Is the Tiger engaged in town?
			
			_attack_break_tiger_near_dead = false
			
			-- Add the prox check to remove the attack waves
			Rule_AddInterval(Escape_Disable_Attack_Waves, 1)
		end,
		
		OnComplete = function()
			
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = EVENTS.ESC_TIGER_ESCAPES,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = EVENTS.ESC_TIGER_FAIL,				-- Event will play when obj fails but before UI is cleared
		Title = 11045886,				-- LOCDB [11045886] 'Exfiltrate the Tiger'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_Escape)
end

function Initialize_Entry()

	SOBJ_Entry = {
		
		SetupUI = function() 			
			hpid_sobj_tiger = Objective_AddUIElements(SOBJ_Entry, eg_tiger, true, 11045887, true, 2)	-- LOCDB [11045887] 'Re-crew the Tiger'
		end,
		
		OnStart = function()
			EGroup_SetRecrewable(eg_tiger, true)
			
			Objective_Start(SOBJ_Entry_FAIL, false)
			g_esc_phase = 1
			
			_readyBreakTimer = false
		end,
		
		OnComplete = function()
			
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.ESC_TIGER_SETUP_DEFENSE,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11045888,				-- LOCDB [11045888] 'Get the Tiger to the South Road'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		Parent = OBJ_Escape,
	}
	
	Objective_Register(SOBJ_Entry)
	
	SOBJ_Entry_FAIL = {
		
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			
		end,
		
		OnComplete = function()
			
		end,
		
		OnFail = function()
						
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11045889,				-- LOCDB [11045889] 'Prevent the Tiger from being destroyed'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		Parent = OBJ_Escape,
	}
	
	Objective_Register(SOBJ_Entry_FAIL)
end

function Escape_Obj_Complete_Check()

	if SGroup_IsEmpty(sg_p_tiger) == false
	  and Prox_AreSquadsNearMarker(sg_p_tiger, mkr_esc_southRoad_trig, ANY) then
		Rule_RemoveMe()
		
		if Rule_Exists(Escape_Obj_Fail_Check) then Rule_Remove(Escape_Obj_Fail_Check) end
		
		SGroup_SetInvulnerable(sg_p_tiger, true)
		
		Objective_Complete(OBJ_Escape)
		Game_FadeToBlack(FADE_OUT, 3.5)
		Event_NarrativeEventsNotRunning(Escape_Obj_Completed, nil, 4)
	end

end

function Escape_Obj_Completed()
	if Objective_IsComplete(OBJ_Escape) then
		Game_EndSP(true)
	end
end

function Escape_Obj_Fail_Check()

	if SGroup_IsEmpty(sg_p_tiger) then
		Rule_RemoveMe()
		
		if Rule_Exists(Escape_Obj_Complete_Check) then Rule_Remove(Escape_Obj_Complete_Check) end
		
		Objective_Fail(OBJ_Escape)
		Game_FadeToBlack(FADE_OUT, 3.5)
		Event_NarrativeEventsNotRunning(Escape_Obj_Failed, nil, 4)
	else
		if SGroup_GetAvgHealth(sg_p_tiger) > 1 then SGroup_SetAvgHealth(sg_p_tiger, 1) end
		local health = SGroup_GetAvgHealth(sg_p_tiger)
		-- Loc_FormatText(11045890, Loc_ConvertNumber(math.floor(health)))
		Obj_ShowProgress(11045890, SGroup_GetAvgHealth(sg_p_tiger))	-- LOCDB [11045890] 'Tiger Health'
	end

end

function Escape_Obj_Failed()
	if Objective_IsFailed(OBJ_Escape) then
		Game_EndSP(false)
	end
end

--|| BEAT FUNCTIONS ||
function Escape_Construct_Base()
	
	EGroup_InstantCaptureStrategicPoint(eg_esc_hq_sector, player1)
	
	sg_a_transport = SGroup_CreateIfNotFound("sg_a_transport")
	
	Util_CreateSquads(player3, sg_a_transport, BP_GetSquadBlueprint("us6_truck_squad"), mkr_escape_a_truck_spawn, mkr_escape_a_truck_dest)
	
	Rule_AddOneShot(_escape_base_populate_truck, 1)
	
	Player_SetEntityProductionAvailability(player3, BP_GetEntityBlueprint("hq"), ITEM_UNLOCKED)
	Player_SetEntityProductionAvailability(player3, EBP.SOVIET.BARRACKS, ITEM_UNLOCKED)
	Player_SetEntityProductionAvailability(player3, EBP.SOVIET.WEAPON_SUPPORT_CENTER, ITEM_UNLOCKED)

end

function _escape_base_populate_truck()

	sg_a_engineer_01 = SGroup_CreateIfNotFound("sg_a_engineer_01")
	sg_a_engineer_02 = SGroup_CreateIfNotFound("sg_a_engineer_02")
	sg_a_engineer_03 = SGroup_CreateIfNotFound("sg_a_engineer_03")
	
	Util_CreateSquads(player3, sg_a_engineer_01, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, sg_a_transport)
	Util_CreateSquads(player3, sg_a_engineer_02, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, sg_a_transport)
	Util_CreateSquads(player3, sg_a_engineer_03, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, sg_a_transport)
	
	SGroup_SetInvulnerable(sg_a_engineer_01, true)
	SGroup_SetInvulnerable(sg_a_engineer_02, true)
	SGroup_SetInvulnerable(sg_a_engineer_03, true)
	
	Event_Proximity(_escape_base_truck_unload, nil, sg_a_transport, mkr_escape_a_truck_dest, 5, ANY, 1)

end

function _escape_base_truck_unload()

	Cmd_UngarrisonSquad(sg_a_engineer_01)
	Cmd_UngarrisonSquad(sg_a_engineer_02)
	Cmd_UngarrisonSquad(sg_a_engineer_03)
	
	Rule_AddDelayedInterval(_escape_base_build_HQ, 3, 1)
	Rule_AddDelayedInterval(_escape_base_build_Barracks, 3, 1)
	Rule_AddDelayedInterval(_escape_base_build_WeaponSupport, 3, 1)
	
	Rule_AddDelayedInterval(_escape_base_finished, 10, 1)

end

function _escape_base_build_HQ()
	
	if SGroup_IsConstructingBuilding(sg_a_engineer_01, ALL) == false then
		Cmd_Construct(sg_a_engineer_01, BP_GetEntityBlueprint("hq"), mkr_esc_p_hq)
		return
	else
		Rule_RemoveMe()
		Rule_AddDelayedInterval(_escape_base_build_HQ_Finished, 3, 1)
	end

end

function _escape_base_build_HQ_Finished()

	if Player_HasBuilding(player3, BP_GetEntityBlueprint("hq")) then
		Rule_RemoveMe()
		
		eg_p_hq = EGroup_CreateIfNotFound("eg_p_hq")
		
		Player_GetAllEntitiesNearMarker(player3, eg_p_hq, mkr_esc_p_hq, 5)
		EGroup_Filter(eg_p_hq, BP_GetEntityBlueprint("hq"), FILTER_KEEP)
		
		EGroup_SetPlayerOwner(eg_p_hq, player1)
		
		Cmd_Garrison(sg_a_engineer_01, sg_a_transport, true)
	end

end

function _escape_base_build_Barracks()
	
	if SGroup_IsConstructingBuilding(sg_a_engineer_02, ALL) == false then
		Cmd_Construct(sg_a_engineer_02, EBP.SOVIET.BARRACKS, mkr_esc_p_building01)
		return
	else
		Rule_RemoveMe()
		Rule_AddDelayedInterval(_escape_base_build_Barracks_Finished, 3, 1)
	end

end

function _escape_base_build_Barracks_Finished()

	if Player_HasBuilding(player3, EBP.SOVIET.BARRACKS) then
		Rule_RemoveMe()
		
		eg_p_barracks = EGroup_CreateIfNotFound("eg_p_barracks")
		
		Player_GetAllEntitiesNearMarker(player3, eg_p_barracks, mkr_esc_p_building01, 5)
		EGroup_Filter(eg_p_barracks, EBP.SOVIET.BARRACKS, FILTER_KEEP)
		
		EGroup_SetPlayerOwner(eg_p_barracks, player1)
		
		Cmd_Garrison(sg_a_engineer_02, sg_a_transport, true)
	end

end

function _escape_base_build_WeaponSupport()
	
	if SGroup_IsConstructingBuilding(sg_a_engineer_03, ALL) == false then
		Cmd_Construct(sg_a_engineer_03, EBP.SOVIET.WEAPON_SUPPORT_CENTER, mkr_esc_p_building02)
		return
	else
		Rule_RemoveMe()
		Rule_AddDelayedInterval(_escape_base_build_WeaponSupport_Finished, 3, 1)
	end

end

function _escape_base_build_WeaponSupport_Finished()

	if Player_HasBuilding(player3, EBP.SOVIET.WEAPON_SUPPORT_CENTER) then
		Rule_RemoveMe()
		
		eg_p_weaponSupport = EGroup_CreateIfNotFound("eg_p_weaponSupport")
		
		Player_GetAllEntitiesNearMarker(player3, eg_p_weaponSupport, mkr_esc_p_building02, 5)
		EGroup_Filter(eg_p_weaponSupport, EBP.SOVIET.WEAPON_SUPPORT_CENTER, FILTER_KEEP)
		
		EGroup_SetPlayerOwner(eg_p_weaponSupport, player1)
		
		Cmd_Garrison(sg_a_engineer_03, sg_a_transport, true)
	end

end

function _escape_base_finished()

	if SGroup_IsInHoldSquad(sg_a_engineer_01, ALL)
	  and SGroup_IsInHoldSquad(sg_a_engineer_02, ALL)
	  and SGroup_IsInHoldSquad(sg_a_engineer_03, ALL) then
		Rule_RemoveMe()
		
		Util_StartIntel(EVENTS.ESC_TIGER_BASE_BUILT)
		
		Cmd_MoveToAndDespawn(sg_a_transport, mkr_escape_a_truck_spawn)
	end

end

function Escape_AutoSave()

	Util_Autosave(11049960)	-- LOCDB [11049960] 'Mission 8 - Autosave 2'
	
	Rule_AddOneShot(TheHunt_SitRep, 3.5)

end

function Escape_Collect_Tiger()
	
	sg_p_tiger = SGroup_CreateIfNotFound("sg_p_tiger")
	
	Player_GetAll(player1, sg_p_tiger)
	
	SGroup_Filter(sg_p_tiger, BP_GetSquadBlueprint("tiger_squad_sp_a2_m02"), FILTER_KEEP)
	
	if SGroup_IsEmpty(sg_p_tiger) == false then
		Rule_RemoveMe()
		Modifier_RemoveAllFromSGroup(sg_p_tiger)
		Modify_UnitSpeed(sg_p_tiger, 0.6)
		
		SGroup_SetSelectable(sg_p_tiger, true)
		
		Entity_SetInvulnerableMinCap(Entity_FromWorldID(_tigerID), 0, -1)
		
		Objective_RemoveUIElements(SOBJ_Entry, hpid_sobj_tiger)
		
		hpid_sobj_entry = Objective_AddUIElements(SOBJ_Entry, mkr_esc_southRoad_ui, true, 11045888, true)	
		
		Obj_ShowProgress(11047710, SGroup_GetAvgHealth(sg_p_tiger))		-- LOCDB [11047710] 'Tiger Health'
		
		-- Collect the position
		g_tiger_pos = Util_GetPosition(sg_p_tiger)
		
		Rule_AddInterval(Escape_Escalate_Level_2, 1)
		
		Util_StartIntel(EVENTS.ESC_TIGER_CAPTURED)
		
		Rule_Add(Escape_Obj_Fail_Check)
		Rule_Add(Escape_Obj_Complete_Check)
		
		Rule_AddInterval(Escape_Encounters_Init, 1)
		
		-- Health Check for Encirclement
		Event_OnHealth(Escape_Tiger_Repair_01, nil, sg_p_tiger, 0.22, true)
		Event_OnHealth(_Escape_Town_Encounters, nil, sg_p_tiger, 0.18, true)
		Event_OnHealth(EventHandler_StartIntel, {intel_callback = EVENTS.ESC_TIGER_REPAIRING_02}, sg_p_tiger, 0.37, true)
		Event_OnHealth(Escape_Tiger_Mobile, nil, sg_p_tiger, 0.45, true)
	end 

end
--Cmd_Upgrade(player1, BP_GetUpgradeBlueprint("allow_building_hq"), 1, true)
--EGroup_InstantCaptureStrategicPoint(eg_esc_hq_sector, player1)
function Escape_Disable_Attack_Waves() 
	if Prox_AreSquadsNearMarker(sg_p_tiger, mkr_esc_disable_attack_waves_trig, ANY) then
		Rule_RemoveMe()
		
		_engaged_in_town = true
	end
end

function Escape_Tiger_Repair_01()

	Util_StartIntel(EVENTS.ESC_TIGER_REPAIRING_01)
	Modifier_Remove(g_player_repRate)

end

function Escape_Tiger_Mobile()
	
	Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 0)
	Util_PlayMusic(g_music_extraction, 0, 4)
	
	g_esc_phase = 2		-- Ramp to phase 2
	Util_StartIntel(EVENTS.ESC_TIGER_MOBILE)
	
	Rule_AddDelayedInterval(Escape_Immobilize_Tiger_Check, 1.5, 1)
	
end

function Escape_SpawnTruck_Units()
	
--~ 	sg_esc_a_truck_01_eng01 = SGroup_CreateIfNotFound("sg_esc_a_truck_01_eng01")
--~ 	sg_esc_a_truck_01_eng02 = SGroup_CreateIfNotFound("sg_esc_a_truck_01_eng02")
	
	sg_esc_p_truck_01_units = SGroup_CreateIfNotFound("sg_esc_p_truck_01_units")
	sg_esc_p_truck_02_units = SGroup_CreateIfNotFound("sg_esc_p_truck_02_units")
	
--~ 	Util_CreateSquads(player3, sg_esc_a_truck_01_eng01, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, sg_esc_p_truck01)
--~ 	Util_CreateSquads(player3, sg_esc_a_truck_01_eng02, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, sg_esc_p_truck01)
	
	Util_CreateSquads(player1, sg_esc_p_truck_02_units, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, sg_esc_p_truck02, nil, 1)
	Util_CreateSquads(player1, sg_esc_p_truck_02_units, SBP.SOVIET.GUARDS_TROOPS, sg_esc_p_truck02, nil, 1)
--~ 	Cmd_Garrison(sg_esc_p_truck_02_units, sg_esc_p_truck02, true, false, true)
	
	Rule_AddInterval(Escape_Truck02_Unload, 1)

end

function Escape_Truck01_Unload()

	SGroup_SetSelectable(sg_esc_p_truck01, true)
	
	Cmd_UngarrisonSquad(sg_esc_a_truck_01_eng01, Util_GetOffsetPosition(sg_esc_p_truck01, OFFSET_BACK_LEFT, 6))
	Cmd_UngarrisonSquad(sg_esc_a_truck_01_eng02, Util_GetOffsetPosition(sg_esc_p_truck01, OFFSET_BACK_RIGHT, 6))
	
	Rule_AddDelayedInterval(_Escape_Build_Building01, 1, 3)
	Rule_AddDelayedInterval(_Escape_Build_Building02, 1, 5)
	
	-- TEMP HACK
--~ 	Util_CreateEntities(player1, eg_p_building01, EBP.SOVIET.WEAPON_SUPPORT_CENTER, mkr_esc_p_building01, 1)
--~ 	Util_CreateEntities(player1, eg_p_building02, EBP.SOVIET.MOTORPOOL, mkr_esc_p_building02, 1)
--~ 	SGroup_SetPlayerOwner(sg_esc_a_truck_01_eng01, player1)
--~ 	SGroup_SetPlayerOwner(sg_esc_a_truck_01_eng02, player1)
	SGroup_SetPlayerOwner(sg_esc_p_truck01, player1)
	
--~ 	Rule_Add(Escape_Building01_Built)
--~ 	Rule_Add(Escape_Building02_Built)
	
--~ 	Event_IsHoldingAny(Escape_Truck01_Revert, nil, sg_esc_p_truck01, true, 2)

end

function _Escape_Build_Building01()

	if SGroup_IsIdle(sg_esc_a_truck_01_eng01, ANY) then
		
		eg_p_building01 = EGroup_CreateIfNotFound("eg_p_building01")
		
		Player_GetAllEntitiesNearMarker(player3, eg_p_building01, mkr_esc_p_building01, 5)
		EGroup_Filter(eg_p_building01, EBP.SOVIET.WEAPON_SUPPORT_CENTER, FILTER_KEEP)
		
		if EGroup_IsEmpty(eg_p_building01) == false then
			Rule_RemoveMe()
			
			EGroup_SetPlayerOwner(eg_p_building01, player1)
			SGroup_SetPlayerOwner(sg_esc_a_truck_01_eng01, player1)
		end
		
		Cmd_Construct(sg_esc_a_truck_01_eng01, EBP.SOVIET.WEAPON_SUPPORT_CENTER, mkr_esc_p_building01)
	end

end

function _Escape_Build_Building02()

	if SGroup_IsIdle(sg_esc_a_truck_01_eng02, ANY) then
		
		eg_p_building02 = EGroup_CreateIfNotFound("eg_p_building02")
		
		Player_GetAllEntitiesNearMarker(player3, eg_p_building02, mkr_esc_p_building02)
		EGroup_Filter(eg_p_building02, EBP.SOVIET.MOTORPOOL, FILTER_KEEP)
		
		if EGroup_IsEmpty(eg_p_building02) == false then
			Rule_RemoveMe()
			
			EGroup_SetPlayerOwner(eg_p_building02, player1)
			SGroup_SetPlayerOwner(sg_esc_a_truck_01_eng02, player1)
		end
		
		Cmd_Construct(sg_esc_a_truck_01_eng02, EBP.SOVIET.MOTORPOOL, mkr_esc_p_building02)
	end

end

function Escape_Truck01_Revert()
	
	Cmd_Move(sg_esc_a_truck_01_eng01, Util_GetOffsetPosition(mkr_esc_p_building01, OFFSET_BACK, 8))
	Cmd_Construct(sg_esc_a_truck_01_eng01, EBP.SOVIET.WEAPON_SUPPORT_CENTER, mkr_esc_p_building01, nil, true)
	Cmd_Move(sg_esc_a_truck_01_eng02, Util_GetOffsetPosition(mkr_esc_p_building02, OFFSET_BACK_RIGHT, 10))
	Cmd_Construct(sg_esc_a_truck_01_eng02, EBP.SOVIET.MOTORPOOL, mkr_esc_p_building02, nil, true)
	
	SGroup_SetPlayerOwner(sg_esc_p_truck01, player1)

end



function Escape_Truck02_Unload()
	
	if Prox_AreSquadsNearMarker(sg_esc_p_truck02, _tiger_loc, ANY, 5) then
		Rule_RemoveMe()
		
		SGroup_SetSelectable(sg_esc_p_truck02, true)
		
		Cmd_UngarrisonSquad(sg_esc_p_truck_02_units)
	end
	
end

function Escape_Hatch_Gunner()
	
	Util_StartIntel(EVENTS.ESC_TIGER_HATCH_GUNNER)
	
	Rule_AddOneShot(Escape_Hatch_Gunner_Delay, 1.5, 1)

end

function Escape_Hatch_Gunner_Delay()

	Cmd_Upgrade(sg_p_tiger, BP_GetUpgradeBlueprint("grant_m08_tiger_mg"), 1, true)
	
	
end
-- Cmd_Upgrade(sg_e_tiger, BP_GetUpgradeBlueprint("grant_m08_tiger_mg"), 1, true)
-- SGroup_SetAutoTargetting(sg_e_tiger, "hardpoint_01", true)
-- Cmd_CriticalHit(player1, sg_e_tiger, CRIT.VEHICLE_DESTROY_MAINGUN, 1)
-- SGroup_RemoveUpgrade(sg_e_tiger, BP_GetUpgradeBlueprint("grant_m08_tiger_mg"))
function Escape_Keep_Turret_Down()

	if SGroup_GetAvgHealth(sg_p_tiger) >= 0.85 then
		SGroup_SetAvgHealth(sg_p_tiger, 0.85)
		
		if SGroup_HasCritical(sg_p_tiger, CRIT.VEHICLE_DESTROY_MAINGUN, ANY) == false then Cmd_CriticalHit(player2, sg_p_tiger, CRIT.VEHICLE_DESTROY_MAINGUN, 1) end
	end

end

function Escape_Immobilize_Tiger_Check()

--~ 	if SGroup_GetAvgHealth(sg_p_tiger) <= 0.40 and SGroup_HasCritical(sg_p_tiger, CRIT.VEHICLE_LOSE_TREADS_OR_WHEELS, ANY) == false then
--~ 		Cmd_CriticalHit(player2, sg_p_tiger, CRIT.VEHICLE_LOSE_TREADS_OR_WHEELS, 0.8)
--~ 		
--~ 		Util_StartIntel(EVENTS.ESC_TIGER_IMMOBILE)
--~ 	elseif SGroup_GetAvgHealth(sg_p_tiger) >= 0.5 and SGroup_HasCritical(sg_p_tiger, CRIT.VEHICLE_LOSE_TREADS_OR_WHEELS, ANY) then
--~ 		Entity_RemoveCritical(Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_p_tiger, 1), 0), CRIT.VEHICLE_LOSE_TREADS_OR_WHEELS)
--~ 		
--~ 		Util_StartIntel(EVENTS.ESC_TIGER_MOBILE)
--~ 	end
	
end
--|| BEAT ENCOUNTERS ||
function Escape_Encounters_Init()
	
	if SGroup_IsEmpty(sg_p_tiger) == false then
		if SGroup_GetAvgHealth(sg_p_tiger) >= 0.10 or Timer_GetRemaining(tmr_esc_init) <= 0 then
			Rule_RemoveMe()
			print("STARTING BATTLE")
			Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 0)
			Util_PlayMusic(g_music_repair_part2, 0, 4)
			
			-- Add the hatch gunner event
			Event_IsUnderAttack(Escape_Hatch_Gunner, nil, sg_p_tiger, ANY, 3, nil, 5)
			
			g_currSpawns = 0
			Rule_AddInterval(Escape_Spawn_Units, 1)
		end
	end
	
end

function Escape_Escalate_Level_2()

	if Prox_AreSquadsNearMarker(sg_p_tiger, g_tiger_pos, ALL, 30) == false then
		Rule_RemoveMe()
		
		_attack_curr_Level = 2
	end

end

function _transport_init()
	
	-- Transports
	_transport = {}
	_ai_IDs = {}
	_transport_index = 0
	
	-- Vehicles
	_vehicles = {}	
	_veh_index = 0
	_veh_IDs = {}
	
	_veh_off_map = {}		-- Table of vehicles to drive off map
	
	-- Total encounters
	_all_encs = {}
	
	_currAttackers = 0
	
	Rule_AddInterval(_all_table_mngr, 1)
	Rule_AddInterval(_vehicle_drive_off_map, 1)
--~ 	_transport_new_transport(2, SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.GRENADIER_SQUAD)

end

function _escape_Start_Break_Timer_A()

	Player_GetAll(player2)
	
	if SGroup_CountSpawned(sg_allsquads) <= 5 then
		Rule_RemoveMe()
		
		-- Start the timer!
		Timer_Start(tmr_break_time, t_difficulty.attack_breather_time)
		
		-- Blow the tracks
		local currHealth = SGroup_GetAvgHealth(sg_p_tiger)
		local repHealth = 0.84
		if (currHealth + 0.1) > 0.85 then
			repHealth = 0.84
		else
			repHealth = (currHealth + 0.1)
		end
		
		Cmd_CriticalHit(player2, sg_p_tiger, CRIT.VEHICLE_LOSE_TREADS_OR_WHEELS, repHealth)
		
		Util_StartIntel(EVENTS.ESC_TIGER_IMMOBILE)
	end

end

function _escape_Start_Break_Timer_B()

	Player_GetAll(player2)
	
	if SGroup_CountSpawned(sg_allsquads) <= 5 then
		Rule_RemoveMe()
		
		-- Start the timer!
		Timer_Start(tmr_break_time, t_difficulty.attack_breather_time)
	end

end

function Escape_Spawn_Units()
	
	-- TODO: Break timer
	-- This should trigger when there are a lot of units on the map
	-- OR
	-- The tiger is getting close to being killed
	-- OR
	-- There aren't many defenders left?
	
	sg_e_mobileAttackers = SGroup_CreateIfNotFound("sg_e_mobileAttackers")
	
	-- Is the Tiger in town?
	if _engaged_in_town == true then
		Rule_RemoveMe()
		return
	end
	
	if _readyBreakTimer == true and SGroup_TotalMembersCount(sg_e_mobileAttackers) <= 2 then
		print("STARTING BREAK")
		print("TIMER SET TO: "..t_difficulty.attack_breather_time)
		Timer_Start(tmr_break_time, t_difficulty.attack_breather_time)
		_readyBreakTimer = false
		_currAttackers = 0
		return
	end
	
	-- Are there too many units around?
	if _currAttackers >= t_difficulty.attack_breather then	-- TODO: Tie this into difficulty level
		print("TOO MANY UNITS, QUE UP A BREAK")
		_readyBreakTimer = true
		return
	end
	
	if Timer_Exists(tmr_break_time) then
		print("TIME TO NEXT WAVE: "..Timer_GetRemaining(tmr_break_time))
		if Timer_GetRemaining(tmr_break_time) == 0 then
			print("BREAK OVER")
			Timer_End(tmr_break_time)
			return
		end
		return
	end
	
	-- Level 1: Tank is immobile
	-- Level 2: Once tank is X meters from its' start
	-- Level 3: Once tank is X meters from the exit
	print("SPAWNING NEW UNITS")
	if _attack_curr_Level == 1 then
		if _attack_first_Wave == true then
			print("SPAWNING FIRST UNITS")
--~ 			_attack_first_Wave = false
			
			_transport_new_transport(1, SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.GRENADIER_SQUAD)
			
			newTime = World_GetRand(80, 85)
			if Rule_Exists(Escape_Spawn_Units) then Rule_ChangeInterval(Escape_Spawn_Units, newTime) end
			return
		end
		
		local rand = World_GetRand(1, 3)
		if rand == 1 then
			_transport_new_transport(1, SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.GRENADIER_SQUAD)
			_transport_new_transport(1, SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.PANZER_GRENADIER_SQUAD)
		elseif rand == 2 then
			_transport_new_transport(1, SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.PANZER_GRENADIER_SQUAD)
			_vehicle_new_vehicle(SBP.GERMAN.SCOUTCAR_SDKFZ222)
		elseif rand == 3 then
			_transport_new_transport(1, SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.PANZER_GRENADIER_SQUAD)
		end
		
		newTime = World_GetRand(t_difficulty.level1_attack_time_min, t_difficulty.level1_attack_time_max)
	elseif _attack_curr_Level == 2 then
		local rand = World_GetRand(1, 3)
		if rand == 1 then
			_transport_new_transport(2, SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.PANZER_GRENADIER_SQUAD)
			_vehicle_new_vehicle(SBP.GERMAN.STUG_III_SQUAD)
		elseif rand == 2 then
			_transport_new_transport(1, SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.PANZER_GRENADIER_SQUAD)
			_transport_new_transport(1, SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.PANZER_GRENADIER_SQUAD)
			_vehicle_new_vehicle(SBP.GERMAN.SCOUTCAR_SDKFZ222)
		elseif rand == 3 then
			_transport_new_transport(1, SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.PANZER_GRENADIER_SQUAD)
			_vehicle_new_vehicle(SBP.GERMAN.STUG_III_SQUAD)
		end
		
		newTime = World_GetRand(t_difficulty.level2_attack_time_min, t_difficulty.level2_attack_time_max)
	end
	
	if Rule_Exists(Escape_Spawn_Units) then Rule_ChangeInterval(Escape_Spawn_Units, newTime) end

end

function _transport_new_transport(num, firstSquad, secondSquad)
	
	-- We want the spawn point to be the same
	-- Find a Spawn point
	local spawn = Table_GetRandomItem(Marker_GetTable("mkr_esc_e_spawn_%02d"))
	table.remove(spawn, 10)
	table.remove(spawn, 11)
	
	for i = 1, num do
		_transport_index = _transport_index + 1
		
		if _attack_first_Wave == true then
			_attack_first_Wave = false
			
			if SGroup_IsEmpty(sg_p_tiger) == false then
				spawn = Util_GetClosestMarker(sg_p_tiger, Marker_GetTable("mkr_esc_e_spawn_%02d"))
			end
		end
		
		-- Populate the encounter ID table
		local t = {}
		t.ht_id = ("encID_".._transport_index.."_ht")
		t.squad_id = ("encID_".._transport_index.."_squad")
		
		table.insert(_ai_IDs, t)
		
		local t = {}
		t.ht_grp = SGroup_CreateIfNotFound("_sg_ht_".._transport_index.."_grp")
		t.squad_grp = SGroup_CreateIfNotFound("_sg_ht_squad_".._transport_index.."_grp")
		t.ht_ai = t.ht_id
		t.squad_ai = t.squad_id
		
		-- Chase Timer
		t.chase_id = ("tmr_chase_".._transport_index)
		
		-- Setup the Halftrack Encounter
		local encData = {
			name = ("Enc_"),
			player = player2,
			spawn = spawn,
			sgroups = {t.ht_grp},
			units = {
				{
					name = ("TEST"),
					sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
				},
			},
		}
		
		t.ht_ai = Encounter:Create(encData)
		
		Modify_UnitSpeed(t.ht_grp, 2)
		Modify_WeaponDamage(t.ht_grp, "hardpoint_01", 0.5)
		Modify_WeaponDamage(t.ht_grp, "hardpoint_02", 0.5)
--~ 		SGroup_SetAutoTargetting(t.ht_grp, "hardpoint_01", false)
--~ 		SGroup_SetAutoTargetting(t.ht_grp, "hardpoint_02", false)
		
		-- Setup the Squads Encounter
		local encData = {
			name = ("Enc_"),
			player = player2,
			spawn = spawn,
			sgroups = {t.squad_grp, sg_e_mobileAttackers},
			units = {
				
			},
		}
		
		local _t = {
			name = ("TEST2"),
			sbp = firstSquad,
			spawn = t.ht_grp,
		}
		
		-- Setup Units tables
		if firstSquad == SBP.GERMAN.PANZER_GRENADIER_SQUAD then
			_t.upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM}
		elseif firstSquad == SBP.GERMAN.GRENADIER_SQUAD then
			local rand = World_GetRand(1, 4)
			if rand == 1 then _t.upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG} end
		end
		
		table.insert(encData.units, _t)
		
		local _t = {
			name = ("TEST2"),
			sbp = secondSquad,
			spawn = t.ht_grp,
		}
		
		-- Setup Units tables
		if secondSquad == SBP.GERMAN.PANZER_GRENADIER_SQUAD then
			_t.upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM}
		elseif secondSquad == SBP.GERMAN.GRENADIER_SQUAD then
			local rand = World_GetRand(1, 4)
			if rand == 1 then _t.upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG} end
		end
		
		table.insert(encData.units, _t)
		
		t.squad_ai = Encounter:Create(encData)
		
		local AI_tactic = AITacticTargetPreference_Near
		if g_difficulty == GD_EASY or g_difficulty == GD_NORMAL then
			AI_tactic = AITacticTargetPreference_HighDamage
		end
		
		-- Now we setup the goalData and assign
		local goalData = {
			name = "Attack",
			target = sg_p_tiger,
			
			attackMove = true,
			attackEngagementMove = true,
			
			tacticTargetPreference = AI_tactic,
			
	--~ 		onTransition = transition_func,
	--~ 		onFailure = _escape_fail,
			
			range = 30,
			leashRange = 80,
			
			tacticCloseGround = 0,
			
			safeMoveWeight = 0,
		}
		t.ht_ai:SetGoal(goalData)
		t.squad_ai:SetGoal(goalData)
		
		-- Give out Weapons
		
		-- Now disable AI on both
		t.ht_ai:Disable()
		t.squad_ai:Disable()
		
		_currAttackers = _currAttackers + 1
		
		table.insert(_transport, t)
		table.insert(_all_encs, t)
	end
	
	if Rule_Exists(_transport_mngr) == false then Rule_AddInterval(_transport_mngr, 1) end

end

function _transport_mngr()

	if SGroup_IsEmpty(sg_p_tiger) then Rule_RemoveMe() return end

	if table.getn(_transport) == 0 then
		Rule_RemoveMe()
		return
	else
		for k, this in pairs(_transport) do
			if SGroup_IsEmpty(this.squad_grp) then
				table.remove(_transport, k)
				break
			else
				
				-- Find out what's enabled
				if this.ht_ai:IsEnabled() then
					local goalData = this.ht_ai:GetGoalData()
--~ 					print("HT ENABLED")
					-- Halftrack AI enabled
					if SGroup_IsEmpty(this.ht_grp) or SGroup_IsUnderAttack(this.ht_grp, ANY, 3) 
					  or Prox_AreSquadsNearMarker(this.ht_grp, Util_GetPosition(goalData.target), ANY, 20) then
--~ 						print("_HT under attack")
						if this.ht_ai:IsEnabled() then this.ht_ai:Disable() end
						Cmd_Stop(this.ht_grp)
						
--~ 						SGroup_SetWorldOwned(this.ht_grp)
						SGroup_SetRecrewable(this.ht_grp, false)
						
						table.insert(_veh_off_map, this.ht_grp)
						
						if this.squad_ai:IsEnabled() == false then this.squad_ai:Enable() end
					end
				elseif this.squad_ai:IsEnabled() then
--~ 					print("SQUAD ENABLED")
--~ 					print("DISTANCE TO TARGET: "..World_DistanceSGroupToPoint(this.squad_grp, Util_GetPosition(sg_p_tiger), true))
					-- Group AI enabled
					if SGroup_IsUnderAttack(this.squad_grp, ANY, 5) == false
					  and World_DistanceSGroupToPoint(this.squad_grp, Util_GetPosition(sg_p_tiger), true) > 50 then
--~ 						print("_IDLE")
						-- Group AI no longer in combat and the tiger's too far
						-- is the halftrack still alive?
						if SGroup_IsEmpty(this.ht_grp) == false then
							if this.squad_ai:IsEnabled() then this.squad_ai:Disable() end
							break
						elseif SGroup_IsEmpty(this.ht_grp) then
--~ 							print("_HALFTRACK DEAD")
							-- Halftrack dead: start chase timer
							if Timer_Exists(this.chase_id) == false then
								Timer_Start(this.chase_id, 20)
							else
--~ 								print("__CHASE TIMER: "..Timer_GetRemaining(this.chase_id))
								if Timer_GetRemaining(this.chase_id) <= 0 then
									Timer_End(this.chase_id)
									Cmd_StaggeredRetreat(this.squad_grp, {mkr_esc_e_left_spawn_02})
								end
							end
						end
					end
					
				elseif this.squad_ai:IsEnabled() == false and this.ht_ai:IsEnabled() == false then
--~ 					print("NONE ENABLED")
					-- Both AI is disabled - transition from group back to halftrack
					if (SGroup_IsEmpty(this.squad_grp) == false and SGroup_IsUnderAttack(this.squad_grp, ANY, 3))
  					  or (SGroup_IsEmpty(this.ht_grp) == false and SGroup_IsUnderAttack(this.ht_grp, ANY, 3)) then
--~ 						print("_UNDER ATTACK, RE-ENABLE")
						if this.squad_ai:IsAlive() == true and this.squad_ai:IsEnabled() == false then this.squad_ai:Enable() end
						break
					else
						if SGroup_IsEmpty(this.ht_grp) == false then
							SGroup_SetPlayerOwner(this.ht_grp, player2)
							SGroup_SetRecrewable(this.ht_grp, true)
							if SGroup_IsInHoldSquad(this.squad_grp, ALL) == false then
								Cmd_Garrison(this.squad_grp, this.ht_grp)
							elseif SGroup_IsInHoldSquad(this.squad_grp, ALL) then
								if this.ht_ai:IsEnabled() == false then this.ht_ai:Enable() end
							end
						end
					end
				end
				
			end
		end
	end

end

function _vehicle_drive_off_map()

	if table.getn(_veh_off_map) == 0 then return end
	
	for i = table.getn(_veh_off_map), 1, -1 do
		if SGroup_IsEmpty(_veh_off_map[i]) then table.remove(_veh_off_map, i) return end
		if SGroup_IsHoldingAny(_veh_off_map[i]) == false then
			local marker = World_GetClosest(_veh_off_map[i], Marker_GetTable("mkr_esc_e_spawn_%02d"))
			
			Cmd_MoveToAndDespawn(_veh_off_map[i], marker)
			table.remove(_veh_off_map, i)
		end
	end

end

function _vehicle_new_vehicle(blueprint)

	-- We want the spawn point to be the same
	-- Find a Spawn point
	local spawn = Table_GetRandomItem(Marker_GetTable("mkr_esc_e_spawn_%02d"))
	
	_veh_index = _veh_index + 1
	
	-- Populate the vehicle ID table
	local t = {}
	t.veh_id = ("encID_".._veh_index.."_veh")
	
	table.insert(_veh_IDs, t)
	
	local t = {}
	t.veh_grp = SGroup_CreateIfNotFound("_sg_veh_".._veh_index.."_grp")
	t.veh_ai = t.veh_id
	
	-- Setup the Encounter
	local encData = {
		name = ("Enc_"),
		player = player2,
		spawn = spawn,
		sgroups = {t.veh_grp},
		units = {
			{
				name = ("TEST"),
				sbp = blueprint,
			},
		},
	}
	
	t.veh_ai = Encounter:Create(encData)
	
	-- Now we setup the goalData and assign
	local goalData = {
		name = "Attack",
		target = sg_p_tiger,
		
		attackMove = true,
		
--~ 		onTransition = transition_func,
--~ 		onFailure = _escape_fail,
		
		range = 9,
		leashRange = 80,
		
		tacticCloseGround = 0,
		
		safeMoveWeight = 0,
	}
	t.veh_ai:SetGoal(goalData)
	
	table.insert(_vehicles, t)
	table.insert(_all_encs, t)

end

function _all_table_mngr()
	
	if table.getn(_all_encs) > 0 then
		for k, this in pairs(_all_encs) do
			if this.squad_grp ~= nil then
				if SGroup_IsEmpty(this.squad_grp) then
					table.remove(_all_encs, k)
				end
			elseif this.veh_grp ~= nil then
				if SGroup_IsEmpty(this.veh_grp) then
					table.remove(_all_encs, k)
				end
			end
		end
	end

end




















































function Escape_Spawn_Town_Units()

	sg_esc_e_town_01 = SGroup_CreateIfNotFound("sg_esc_e_town_01")
	sg_esc_e_town_01_trans_01 = SGroup_CreateIfNotFound("sg_esc_e_town_01_trans_01")
	sg_esc_e_town_01_trans_02 = SGroup_CreateIfNotFound("sg_esc_e_town_01_trans_02")
	
	Util_CreateSquads(player2, sg_esc_e_town_01_trans_01, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, mkr_esc_e_town_L_spawn)
	Util_CreateSquads(player2, sg_esc_e_town_01_trans_02, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, mkr_esc_e_town_L_spawn)
	
	Cmd_Move(sg_esc_e_town_01_trans_01, mkr_esc_e_town_01_trans_01_dest)
	Cmd_Move(sg_esc_e_town_01_trans_02, mkr_esc_e_town_01_trans_02_dest)
	
	local encData = {
		name = ("escape_town_01"),
		player = player2,
		spawn = mkr_esc_e_town_L_spawn,
		sgroups = {sg_esc_e_town_01},
		units = {
			{
				name = "escape_m_01_tran_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				sgroups = {sg_esc_e_middle_01_tran_01},
				spawn = sg_esc_e_town_01_trans_01,
			},
			{
				name = "escape_m_01_tran_02",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				sgroups = {sg_esc_e_middle_01_tran_02},
				spawn = sg_esc_e_town_01_trans_01,
			},
		},
	}
	encID_esc_M_01 = Encounter:Create(encData)

end


----------------------------
-- Attack
----------------------------
-- Range: 12
-- LeashRange: 40

-- While the tiger is immobile:
--	-- Halftracks with Grenadiers, Scout Cars
-- When the tiger is mobile )over 50% health)
--	--


function _Escape_Town_Encounters()
	
	sg_esc_e_blockers_all = SGroup_CreateIfNotFound("sg_esc_e_blockers_all")
	
	-- Spawn the distraction
--~ 	sg_esc_e_distraction_01 = SGroup_CreateIfNotFound("sg_esc_e_distraction_01")
--~ 	sg_esc_e_distraction_squads = SGroup_CreateIfNotFound("sg_esc_e_distraction_squads")
--~ 	
--~ 	Util_CreateSquads(player2, sg_esc_e_distraction_01, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, mkr_esc_e_distraction_spawn, mkr_esc_e_distraction_dest)
--~ 	SGroup_SetInvulnerable(sg_esc_e_distraction_01, true)
	
--~ 	Rule_AddOneShot(_Escape_Distraction_Delay, 1)
	
--~ 	Event_Proximity(_Escape_Distraction_At_Base, nil, sg_esc_e_distraction_01, mkr_esc_e_distraction_dest, 5, ANY, 1)
	
	-- Second distraction
	sg_esc_e_distraction_02 = SGroup_CreateIfNotFound("sg_esc_e_distraction_02")
	
	Util_CreateSquads(player2, sg_esc_e_distraction_02, SBP.GERMAN.STUG_III_E_SQUAD, mkr_esc_e_distraction_spawn_02, mkr_esc_e_distraction_dest_02)
	
	-- Third distraction
	sg_esc_e_distraction_03 = SGroup_CreateIfNotFound("sg_esc_e_distraction_03")
	
	Util_CreateSquads(player2, sg_esc_e_distraction_03, SBP.GERMAN.SCOUTCAR_SDKFZ222, mkr_esc_e_distraction_spawn_03, mkr_esc_e_distraction_dest_03)
	
	-- Fourth distraction
	sg_esc_e_distraction_04 = SGroup_CreateIfNotFound("sg_esc_e_distraction_04")
	
	Util_CreateSquads(player2, sg_esc_e_distraction_04, SBP.GERMAN.STUG_III_E_SQUAD, mkr_esc_e_distraction_spawn_04, mkr_esc_e_distraction_dest_04)
	
	-- Mainroad
	_Escape_Town_Pak_MainRoad_Init()
	
	-- Mainroad Rear Guard
	Rule_AddOneShot(_Escape_Town_Pak_MainRoad_RearGuard_Init, 17)
	
	-- Spawn the Right Side (Delayed)
	Rule_AddOneShot(_Escape_Town_Right, 24)
	
	-- Spawn the Left Side
	Rule_AddOneShot(_Escape_Town_Left, 10)
	
	-- Spawn the Left Side Rearguard (Delayed)
	_Escape_Town_Left_RearGuard()
	
	-- Mid
	_Escape_Town_Mid()

end

function _Escape_Distraction_Delay()

	local encData = {
		name = ("Distraction"),
		player = player2,
		spawn = sg_esc_e_distraction_01,
		sgroups = {sg_esc_e_distraction_squads},
		units = {
			{
				name = ("TEST"),
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
			},
			{
				name = ("TEST"),
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
			},
		},
	}
	
	encID_distraction = Encounter:Create(encData)

end

function _Escape_Distraction_At_Base()

	Cmd_UngarrisonSquad(sg_esc_e_distraction_squads)
	
	local goalData = {
		name = "Attack",
		target = mkr_esc_e_base_distraction,
		
		range = 20,
		leashRange = 35,
	}
	
	encID_distraction:SetGoal(goalData)
	
	Rule_AddOneShot(_Escape_Distraction_At_Base_Retreat, 2*60)
	
	SGroup_SetAutoTargetting(sg_esc_e_distraction_01, "hardpoint_01", false)
	SGroup_SetAutoTargetting(sg_esc_e_distraction_01, "hardpoint_02", false)
	SGroup_SetInvulnerable(sg_esc_e_distraction_01, false)
	
	Rule_AddOneShot(_Escape_Distraction_At_Base_Abandon, 2)

end

function _Escape_Distraction_At_Base_Abandon()

	SGroup_SetRecrewable(sg_esc_e_distraction_01, false)
	Cmd_CriticalHit(player3, sg_esc_e_distraction_01, CRIT.VEHICLE_ABANDON_M8_TIGER, 1)

end

function _Escape_Distraction_At_Base_Retreat()

	-- After 2 mins, retreat.
	if SGroup_IsEmpty(sg_esc_e_distraction_squads) == false then
		Cmd_StaggeredRetreat(sg_esc_e_distraction_squads, {mkr_esc_e_town_R_spawn_05})
	end

end

-- Mainroad Rear Guard
function _Escape_Town_Pak_MainRoad_RearGuard_Init()

	-- Rear Guard
	sg_esc_e_mainRoad_rearGuard = SGroup_CreateIfNotFound("sg_esc_e_mainRoad_rearGuard")
	
	sg_esc_e_mainRoad_rearGuard_ht01 = SGroup_CreateIfNotFound("sg_esc_e_mainRoad_rearGuard_ht01")
	sg_esc_e_mainRoad_rearGuard_ht02 = SGroup_CreateIfNotFound("sg_esc_e_mainRoad_rearGuard_ht02")
	sg_esc_e_mainRoad_rearGuard_01 = SGroup_CreateIfNotFound("sg_esc_e_mainRoad_rearGuard_01")
	sg_esc_e_mainRoad_rearGuard_02 = SGroup_CreateIfNotFound("sg_esc_e_mainRoad_rearGuard_02")
	
	-- Spawn the Vehicles
	Util_CreateSquads(player2, {sg_esc_e_mainRoad_rearGuard_ht01, sg_esc_e_blockers_all}, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, mkr_esc_e_town_R_spawn)
	Util_CreateSquads(player2, {sg_esc_e_mainRoad_rearGuard_ht02, sg_esc_e_blockers_all}, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, mkr_esc_e_town_R_spawn_02)
	
	SGroup_SetInvulnerable(sg_esc_e_mainRoad_rearGuard_ht01, true)
	SGroup_SetInvulnerable(sg_esc_e_mainRoad_rearGuard_ht02, true)
	
	Cmd_SquadPath(sg_esc_e_mainRoad_rearGuard_ht01, "pth_mainRoad_rearGuard_ht_01", true, false, false, 0)
	Cmd_SquadPath(sg_esc_e_mainRoad_rearGuard_ht02, "pth_mainRoad_rearGuard_ht_02", true, false, false, 0)
	
	Cmd_Move(sg_esc_e_mainRoad_rearGuard_ht01, mkr_esc_e_mainRoad_rearGuard_ht01_dest, nil, Util_GetOffsetPosition(mkr_esc_e_mainRoad_rearGuard_ht01_dest, OFFSET_BACK, 10))
	Cmd_Move(sg_esc_e_mainRoad_rearGuard_ht02, mkr_esc_e_mainRoad_rearGuard_ht02_dest, nil, Util_GetOffsetPosition(mkr_esc_e_mainRoad_rearGuard_ht02_dest, OFFSET_FRONT, 10))
	
	-- Spawn the Units
	Rule_AddOneShot(_Escape_Town_MainRoad_RearGuard, 1)
	
	-- Unload
	Event_Proximity(_Escape_Town_MainRoad_RearGuard_Unload_01, nil, sg_esc_e_mainRoad_rearGuard_ht01, mkr_esc_e_mainRoad_rearGuard_ht01_dest, 5, ANY, 5)
	Event_Proximity(_Escape_Town_MainRoad_RearGuard_Unload_02, nil, sg_esc_e_mainRoad_rearGuard_ht02, mkr_esc_e_mainRoad_rearGuard_ht02_dest, 5, ANY, 5)
	
	-- Infantry
	sg_esc_e_midRight01 = SGroup_CreateIfNotFound("sg_esc_e_midRight01")
	sg_esc_e_midRight02 = SGroup_CreateIfNotFound("sg_esc_e_midRight02")
	sg_esc_e_midRight_grens = SGroup_CreateIfNotFound("sg_esc_e_midRight_grens")
	--eg_midRight_def
	Util_CreateSquads(player2, sg_esc_e_midRight01, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_esc_e_town_R_spawn, eg_midRight_def, 1)
	Cmd_Garrison(sg_esc_e_midRight01, eg_midRight_def, true)
	Cmd_Upgrade(sg_esc_e_midRight01, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM, 2, true)
	Util_CreateSquads(player2, sg_esc_e_midRight02, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_esc_e_town_R_spawn, Util_GetOffsetPosition(mkr_esc_e_midRight_trench01, OFFSET_BACK, 5), 1)
	Cmd_Upgrade(sg_esc_e_midRight02, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM, 2, true)
	
	Util_CreateSquads(player2, sg_esc_e_midRight_grens, SBP.GERMAN.GRENADIER_SQUAD, mkr_esc_e_town_R_spawn, mkr_esc_e_midRight_trench01)
	Cmd_Construct(sg_esc_e_midRight_grens, EBP.GERMAN.SLIT_TRENCH_GERMAN, mkr_esc_e_midRight_trench01, nil, true)

end

function _Escape_Town_MidRight_Trench_01()
	-- Trench built, hop in
	eg_midRight_trench_01 = EGroup_CreateIfNotFound("eg_midRight_trench_01")
	
	World_GetNeutralEntitiesNearMarker(eg_midRight_trench_01, mkr_esc_e_midRight_trench01)
	
	EGroup_Filter(eg_midRight_trench_01, EBP.GERMAN.SLIT_TRENCH_GERMAN, FILTER_KEEP)
	
	if EGroup_IsEmpty(eg_midRight_trench_01) == false then
		Rule_RemoveMe()
		
		Cmd_Garrison(sg_esc_e_midRight02, eg_midRight_trench_01)
	end

end

function _Escape_Town_MainRoad_RearGuard()
	
	-- Main Rearguard encounter
	local encData = {
		name = ("MainRoad_RearGuard"),
		player = player2,
		spawn = sg_esc_e_mainRoad_rearGuard_ht01,
		sgroups = {sg_esc_e_mainRoad_rearGuard, sg_esc_e_blockers_all},
		units = {
			{
				name = ("TEST"),
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				sgroups = {sg_esc_e_mainRoad_rearGuard_01},
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
			},
		},
	}
	
	encID_mainRoad_RearGuard = Encounter:Create(encData)
	
	-- Defend Engineers
	local encData = {
		name = ("MainRoad_RearGuard"),
		player = player2,
		spawn = sg_esc_e_mainRoad_rearGuard_ht02,
		sgroups = {sg_esc_e_mainRoad_rearGuard, sg_esc_e_blockers_all},
		units = {
			{
				name = ("TEST"),
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				sgroups = {sg_esc_e_mainRoad_rearGuard_02},
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
			},
		},
	}
	
	encID_mainRoad_RearGuard_eng = Encounter:Create(encData)
	
	-- Spawn the Pioneers
	sg_esc_e_mainRoad_rearGuard_pio01 = SGroup_CreateIfNotFound("sg_esc_e_mainRoad_rearGuard_pio01")
	
	Util_CreateSquads(player2, {sg_esc_e_mainRoad_rearGuard_pio01, sg_esc_e_blockers_all}, SBP.GERMAN.PIONEER_SQUAD, sg_esc_e_mainRoad_rearGuard_ht02)

end

function _Escape_Town_MainRoad_RearGuard_Unload_01()
	-- Unload and build the trench
	Cmd_Stop(sg_esc_e_mainRoad_rearGuard_ht01)
	Cmd_UngarrisonSquad(sg_esc_e_mainRoad_rearGuard_01)
	Cmd_Construct(sg_esc_e_mainRoad_rearGuard_01, EBP.GERMAN.SLIT_TRENCH_GERMAN, mkr_esc_e_mainRoad_trench, nil, true)
	
	Rule_AddInterval(_Escape_Town_MainRoad_RearGuard_Trench, 1)
	SGroup_SetAutoTargetting(sg_esc_e_mainRoad_rearGuard_ht01, "hardpoint_01", true)
	SGroup_SetAutoTargetting(sg_esc_e_mainRoad_rearGuard_ht01, "hardpoint_02", true)
	SGroup_SetInvulnerable(sg_esc_e_mainRoad_rearGuard_ht01, false)
	
	table.insert(_veh_off_map, sg_esc_e_mainRoad_rearGuard_ht01)
--~ 	Rule_AddOneShot(_Escape_Town_MainRoad_RearGuard_Abandon_01, 8)

end

function _Escape_Town_MainRoad_RearGuard_Abandon_01()
	
	SGroup_SetRecrewable(sg_esc_e_mainRoad_rearGuard_ht01, false)
	Cmd_CriticalHit(player3, sg_esc_e_mainRoad_rearGuard_ht01, CRIT.VEHICLE_ABANDON_M8_TIGER, 1)
	
end

function _Escape_Town_MainRoad_RearGuard_Trench()
	-- Trench built, hop in
	eg_mainRoad_rearGuard_trench = EGroup_CreateIfNotFound("eg_mainRoad_rearGuard_trench")
	
	World_GetNeutralEntitiesNearMarker(eg_mainRoad_rearGuard_trench, mkr_esc_e_mainRoad_trench)
	
	EGroup_Filter(eg_mainRoad_rearGuard_trench, EBP.GERMAN.SLIT_TRENCH_GERMAN, FILTER_KEEP)
	
	if EGroup_IsEmpty(eg_mainRoad_rearGuard_trench) == false then
		Rule_RemoveMe()
		
		Cmd_Garrison(sg_esc_e_mainRoad_rearGuard_01, eg_mainRoad_rearGuard_trench)
	end

end

function _Escape_Town_MainRoad_RearGuard_Unload_02()
	-- Unload and build the minefield
	Cmd_Stop(sg_esc_e_mainRoad_rearGuard_ht02)
	Cmd_UngarrisonSquad(sg_esc_e_mainRoad_rearGuard_02)
	Cmd_UngarrisonSquad(sg_esc_e_mainRoad_rearGuard_pio01, mkr_esc_e_pak_mainRoad_minefield)
	
	sg_esc_e_mainRoad_rearGuard_03 = SGroup_CreateIfNotFound("sg_esc_e_mainRoad_rearGuard_03")
	sg_esc_e_mainRoad_rearGuard_04 = SGroup_CreateIfNotFound("sg_esc_e_mainRoad_rearGuard_04")
	
	Util_CreateSquads(player2, sg_esc_e_mainRoad_rearGuard_03, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_esc_e_mainRoad_rearGuard_ht02_dest, nil, 1, 4, false, nil, {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_SECOND})
	if EGroup_IsEmpty(eg_def_building_01) == false then Cmd_Garrison(sg_esc_e_mainRoad_rearGuard_03, eg_def_building_01) end
	Util_CreateSquads(player2, sg_esc_e_mainRoad_rearGuard_04, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_esc_e_mainRoad_rearGuard_ht02_dest, nil, 1, 4, false, nil, {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_SECOND})
	if EGroup_IsEmpty(eg_def_building_02) == false then Cmd_Garrison(sg_esc_e_mainRoad_rearGuard_04, eg_def_building_02) end
	
--~ 	Cmd_Move(sg_esc_e_mainRoad_rearGuard_pio01, mkr_esc_e_pak_mainRoad_minefield, true)
	Cmd_Construct(sg_esc_e_mainRoad_rearGuard_pio01, EBP.GERMAN.MINE_FIELD, mkr_esc_e_pak_mainRoad_minefield, nil, true)
	
	Rule_AddDelayedInterval(_Escape_Town_MainRoad_RearGuard_AI_On, 15, 1)
	
	SGroup_SetAutoTargetting(sg_esc_e_mainRoad_rearGuard_ht02, "hardpoint_01", true)
	SGroup_SetAutoTargetting(sg_esc_e_mainRoad_rearGuard_ht02, "hardpoint_02", true)
	SGroup_SetInvulnerable(sg_esc_e_mainRoad_rearGuard_ht02, false)
	
	table.insert(_veh_off_map, sg_esc_e_mainRoad_rearGuard_ht02)
--~ 	Rule_AddOneShot(_Escape_Town_MainRoad_RearGuard_Abandon_02, 5)
	
end

function _Escape_Town_MainRoad_RearGuard_Abandon_02()
	
	SGroup_SetRecrewable(sg_esc_e_mainRoad_rearGuard_ht02, false)
	Cmd_CriticalHit(player3, sg_esc_e_mainRoad_rearGuard_ht02, CRIT.VEHICLE_ABANDON_M8_TIGER, 1)
	
end

function _Escape_Town_MainRoad_RearGuard_AI_On()

	if SGroup_IsConstructingBuilding(sg_esc_e_mainRoad_rearGuard_pio01, ANY) == false and 
	  SGroup_IsMoving(sg_esc_e_mainRoad_rearGuard_pio01, ALL) == false then
		Rule_RemoveMe()
		
		encID_mainRoad_RearGuard_eng:AddSgroup(sg_esc_e_mainRoad_rearGuard_pio01)
		
		local goalData = {
			name = "Defend",
			target = mkr_esc_e_mainRoad_rearGuard,
			
			garrison = true,
			garrisonIdle = true,
		}
		
		encID_mainRoad_RearGuard_eng:SetGoal(goalData)
	end

end
-- Mainroad
function _Escape_Town_Pak_MainRoad_Init()
	-------------------------------
	-- Main Road Pak
	sg_esc_e_pak_mainRoad = SGroup_CreateIfNotFound("sg_esc_e_pak_mainRoad")
	
	sg_esc_e_pak_mainRoad_ht01 = SGroup_CreateIfNotFound("sg_esc_e_pak_mainRoad_ht01")
	sg_esc_e_pak_mainRoad_ht02 = SGroup_CreateIfNotFound("sg_esc_e_pak_mainRoad_ht02")
	sg_esc_e_pak_mainRoad_stug = SGroup_CreateIfNotFound("sg_esc_e_pak_mainRoad_stug")
	sg_esc_e_pak_mainRoad_pak = SGroup_CreateIfNotFound("sg_esc_e_pak_mainRoad_pak")
	sg_esc_e_pak_def_01 = SGroup_CreateIfNotFound("sg_esc_e_pak_def_01")
	sg_esc_e_pak_def_02 = SGroup_CreateIfNotFound("sg_esc_e_pak_def_02")
	
	-- Spawn the Vehicles
	Util_CreateSquads(player2, {sg_esc_e_pak_mainRoad_stug, sg_esc_e_blockers_all}, t_difficulty.mainRoad_SPG, mkr_esc_e_town_R_spawn)
	Util_CreateSquads(player2, {sg_esc_e_pak_mainRoad_ht01, sg_esc_e_blockers_all}, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, mkr_esc_e_town_R_spawn_05)
	Util_CreateSquads(player2, {sg_esc_e_pak_mainRoad_ht02, sg_esc_e_blockers_all}, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, mkr_esc_e_town_R_spawn_02)
	
	SGroup_SetInvulnerable(sg_esc_e_pak_mainRoad_stug, true)
	SGroup_SetInvulnerable(sg_esc_e_pak_mainRoad_ht01, true)
	SGroup_SetInvulnerable(sg_esc_e_pak_mainRoad_ht02, true)
	
	Modify_UnitSpeed(sg_esc_e_pak_mainRoad_ht01, 0.9)
	Modify_UnitSpeed(sg_esc_e_pak_mainRoad_ht02, 0.9)
	
	Cmd_SquadPath(sg_esc_e_pak_mainRoad_stug, "pth_mainRoad_stug", true, false, false, 0)
	Cmd_SquadPath(sg_esc_e_pak_mainRoad_ht01, "pth_mainRoad_ht_01", true, false, false, 0)
	Cmd_SquadPath(sg_esc_e_pak_mainRoad_ht02, "pth_mainRoad_ht_02", true, false, false, 0)
	
	Cmd_Move(sg_esc_e_pak_mainRoad_stug, mkr_esc_e_mainRoad_stug_dest, true, nil, Util_GetOffsetPosition(mkr_esc_e_mainRoad_stug_dest, OFFSET_FRONT, 10))
	Cmd_Move(sg_esc_e_pak_mainRoad_ht01, mkr_esc_e_mainRoad_ht01_dest, true)
	Cmd_Move(sg_esc_e_pak_mainRoad_ht02, mkr_esc_e_mainRoad_ht02_dest, true)
	
	-- Spawn the Pak
	Util_CreateSquads(player2, {sg_esc_e_pak_mainRoad_pak, sg_esc_e_blockers_all}, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_esc_e_town_R_spawn_03, mkr_esc_e_pak_mainRoad)
	
	Modify_UnitSpeed(sg_esc_e_pak_mainRoad_pak, 1.5)
	
	TeamWeapon_AddGroup(sg_esc_e_pak_mainRoad_pak)
	
	-- Spawn the units
	Rule_AddOneShot(_Escape_Town_MainRoad_Pak, 1)
	
	-- Unload
	Event_Proximity(_Escape_Town_MainRoad_pak_Unload_01, nil, sg_esc_e_pak_mainRoad_ht01, mkr_esc_e_mainRoad_ht01_dest, 5, ANY, 5)
	Event_Proximity(_Escape_Town_MainRoad_pak_Unload_02, nil, sg_esc_e_pak_mainRoad_ht02, mkr_esc_e_mainRoad_ht02_dest, 5, ANY, 5)
	
	-- Dig in
	Rule_AddInterval(_Escape_Town_MainRoad_pak_Stug_HullDown, 1)
	
	-- Seen
	Event_PlayerCanSeeElement(EventHandler_StartIntel, {intel_callback = EVENTS.ESC_ENCIRCLE}, player1, sg_esc_e_blockers_all, ANY)
end
	
function _Escape_Town_MainRoad_Pak()
	
	-- Trench
	local encData = {
		name = ("MainRoad_Pak"),
		player = player2,
		spawn = sg_esc_e_pak_mainRoad_ht01,
		sgroups = {sg_esc_e_pak_mainRoad, sg_esc_e_blockers_all},
		units = {
			{
				name = ("TEST"),
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				sgroups = {sg_esc_e_pak_def_01},
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
			},
		},
	}
	
	encID_mainRoad_trench = Encounter:Create(encData)
	
	-- Defend Engineers
	local encData = {
		name = ("MainRoad_RearGuard"),
		player = player2,
		spawn = sg_esc_e_pak_mainRoad_ht02,
		sgroups = {sg_esc_e_pak_mainRoad, sg_esc_e_blockers_all},
		units = {
			{
				name = ("TEST"),
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				sgroups = {sg_esc_e_pak_def_02},
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
			},
			{
				name = ("TEST"),
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				sgroups = {sg_esc_e_pak_def_02},
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
			},
		},
	}
	
	encID_mainRoad_def_02 = Encounter:Create(encData)

end

function _Escape_Town_MainRoad_pak_Unload_01()
	-- Unload and build the trench
	Cmd_UngarrisonSquad(sg_esc_e_pak_def_01)
	Cmd_Construct(sg_esc_e_pak_def_01, EBP.GERMAN.SLIT_TRENCH_GERMAN, mkr_esc_e_mainRoad_trench_02, nil, true)
	
	SGroup_SetInvulnerable(sg_esc_e_pak_mainRoad_ht01, false)
	
	Rule_AddInterval(_Escape_Town_MainRoad_Pak_Trench, 1)
	SGroup_SetAutoTargetting(sg_esc_e_pak_mainRoad_ht01, "hardpoint_01", true)
	SGroup_SetAutoTargetting(sg_esc_e_pak_mainRoad_ht01, "hardpoint_02", true)
	
	table.insert(_veh_off_map, sg_esc_e_pak_mainRoad_ht01)
--~ 	Rule_AddOneShot(_Escape_Town_MainRoad_pak_Abandon_01, 5)

end

function _Escape_Town_MainRoad_pak_Abandon_01()
	
	SGroup_SetRecrewable(sg_esc_e_pak_mainRoad_ht01, false)
	Cmd_CriticalHit(player3, sg_esc_e_pak_mainRoad_ht01, CRIT.VEHICLE_ABANDON_M8_TIGER, 1)
	
end

function _Escape_Town_MainRoad_Pak_Trench()
	-- Trench built, hop in
	eg_mainRoad_pak_trench = EGroup_CreateIfNotFound("eg_mainRoad_pak_trench")
	
	World_GetNeutralEntitiesNearMarker(eg_mainRoad_pak_trench, mkr_esc_e_mainRoad_trench_02)
	
	EGroup_Filter(eg_mainRoad_pak_trench, EBP.GERMAN.SLIT_TRENCH_GERMAN, FILTER_KEEP)
	
	if EGroup_IsEmpty(eg_mainRoad_pak_trench) == false then
		Rule_RemoveMe()
		
		Cmd_Garrison(sg_esc_e_pak_def_01, eg_mainRoad_pak_trench)
	end

end

function _Escape_Town_MainRoad_pak_Unload_02()
	-- Unload and build the minefield
	Cmd_UngarrisonSquad(sg_esc_e_pak_def_02)
	
	SGroup_SetInvulnerable(sg_esc_e_pak_mainRoad_ht02, false)
	
	Rule_AddDelayedInterval(_Escape_Town_MainRoad_Pak_AI_On, 2, 1)
	
	SGroup_SetAutoTargetting(sg_esc_e_pak_mainRoad_ht02, "hardpoint_01", true)
	SGroup_SetAutoTargetting(sg_esc_e_pak_mainRoad_ht02, "hardpoint_02", true)
	
	table.insert(_veh_off_map, sg_esc_e_pak_mainRoad_ht02)
--~ 	Rule_AddOneShot(_Escape_Town_MainRoad_pak_Abandon_02, 5)
	
end

function _Escape_Town_MainRoad_pak_Abandon_02()
	
	SGroup_SetRecrewable(sg_esc_e_pak_mainRoad_ht02, false)
	Cmd_CriticalHit(player3, sg_esc_e_pak_mainRoad_ht02, CRIT.VEHICLE_ABANDON_M8_TIGER, 1)
	
end

function _Escape_Town_MainRoad_Pak_AI_On()

	local goalData = {
		name = "Defend",
		target = mkr_esc_e_pak_def,
		
		range = 40,
		leashRange = 20,
		
		garrison = false,
		garrisonIdle = false,
	}
	
	encID_mainRoad_def_02:SetGoal(goalData)

end


function _Escape_Town_MainRoad_pak_Stug_HullDown()
	if Prox_AreSquadsNearMarker(sg_esc_e_pak_mainRoad_stug, mkr_esc_e_mainRoad_stug_dest, ANY, 5)
	  and SGroup_IsMoving(sg_esc_e_pak_mainRoad_stug, ANY) == false then
		local squadHeading = Squad_GetHeading(SGroup_GetSpawnedSquadAt(sg_esc_e_pak_mainRoad_stug, 1))
		local markerHeading = Marker_GetDirection(mkr_esc_e_mainRoad_stug_dest)
		if Util_GetDistance(squadHeading, markerHeading) <= 0.1 then
			Rule_RemoveMe()
			
			Util_GetDistance(squadHeading, markerHeading)
			
			SGroup_SetInvulnerable(sg_esc_e_pak_mainRoad_stug, false)
			
			Cmd_Upgrade(sg_esc_e_pak_mainRoad_stug, BP_GetUpgradeBlueprint("instant_german_hulldown"), 1, true)
		end
	end

end
-- Right
function _Escape_Town_Right()

	sg_esc_e_right = SGroup_CreateIfNotFound("sg_esc_e_right")
	
	sg_esc_e_right_stug = SGroup_CreateIfNotFound("sg_esc_e_right_stug")
	sg_esc_e_right_ht = SGroup_CreateIfNotFound("sg_esc_e_right_ht")
	sg_esc_e_right_pio = SGroup_CreateIfNotFound("sg_esc_e_right_pio")
	
	Util_CreateSquads(player2, {sg_esc_e_right_stug, sg_esc_e_blockers_all}, SBP.GERMAN.STUG_III_SQUAD, mkr_esc_e_town_R_spawn, mkr_esc_e_right_stug_dest)
	Util_CreateSquads(player2, {sg_esc_e_right_ht, sg_esc_e_blockers_all}, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, mkr_esc_e_town_R_spawn_02, mkr_esc_e_right_ht_dest)
	SGroup_SetInvulnerable(sg_esc_e_right_ht, true)
	Rule_AddOneShot(_Escape_Town_Right_Units, 1)
	
--~ 	Rule_AddOneShot(_Escape_Town_Right_Abandon_01, 5)
	
	table.insert(_veh_off_map, sg_esc_e_right_ht)
	
	Event_Proximity(_Escape_Town_Right_Unload_01, nil, sg_esc_e_right_ht, mkr_esc_e_right_ht_dest, 5)
	
	Rule_AddInterval(_Escape_Town_Right_HullDown, 1)
	Event_Proximity(_Escape_Town_Right_HullDown, nil, sg_esc_e_right_stug, mkr_esc_e_right_stug_dest, 2)

end

function _Escape_Town_Right_Abandon_01()
	
	SGroup_SetRecrewable(sg_esc_e_right_ht, false)
	Cmd_CriticalHit(player3, sg_esc_e_right_ht, CRIT.VEHICLE_ABANDON_M8_TIGER, 1)
	
end

function _Escape_Town_Right_HullDown()
	
	if Prox_AreSquadsNearMarker(sg_esc_e_right_stug, mkr_esc_e_right_stug_dest, ANY, 5)
	  and SGroup_IsMoving(sg_esc_e_right_stug, ANY) == false then
		Rule_RemoveMe()
		
		Cmd_Upgrade(sg_esc_e_right_stug, BP_GetUpgradeBlueprint("instant_german_hulldown"), 1, true)
	end

end

function _Escape_Town_Right_Units()

	-- Main Rearguard encounter
	local encData = {
		name = ("Town_Right"),
		player = player2,
		spawn = sg_esc_e_right_ht,
		sgroups = {sg_esc_e_right, sg_esc_e_blockers_all},
		units = {
			{
				name = ("TEST"),
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				sgroups = {sg_esc_e_right},
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
			},
			{
				name = ("TEST"),
				sbp = SBP.GERMAN.PIONEER_SQUAD,
				sgroups = {sg_esc_e_right_pio},
			},
		},
	}
	
	encID_right = Encounter:Create(encData)

end

function _Escape_Town_Right_Unload_01()
	
	Cmd_UngarrisonSquad(sg_esc_e_right, Util_GetOffsetPosition(mkr_esc_e_right_stug_dest, OFFSET_LEFT, 5))
	Cmd_UngarrisonSquad(sg_esc_e_right_pio, mkr_esc_e_right_minefield)
	
	Cmd_Construct(sg_esc_e_right_pio, EBP.GERMAN.MINE_FIELD, mkr_esc_e_right_minefield, nil, true)
	Cmd_Move(sg_esc_e_right_pio, Util_GetOffsetPosition(mkr_esc_e_right_stug_dest, OFFSET_BACK, 8), true)
	
	Cmd_Move(sg_esc_e_right, Util_GetOffsetPosition(mkr_esc_e_right_stug_dest, OFFSET_LEFT, 5), true)
	
	Rule_AddDelayedInterval(_Escape_Town_Right_AI_On, 30, 1)

end

function _Escape_Town_Right_AI_On()
	print("BLAH")
	if SGroup_IsConstructingBuilding(sg_esc_e_right_pio, ANY) == false and 
	  SGroup_IsMoving(sg_esc_e_right_pio, ALL) == false then
		Rule_RemoveMe()
		
		local goalData = {
			name = "Defend",
			target = sg_esc_e_right_stug,
			
			range = 30,
			leashRange = 12,
			
			garrison = false,
			garrisonIdle = false,
		}
		
		encID_right:SetGoal(goalData)
	end

end



-- Mid
function _Escape_Town_Mid()

	sg_esc_e_mid_stug_01 = SGroup_CreateIfNotFound("sg_esc_e_mid_stug_01")
	sg_esc_e_mid_stug_02 = SGroup_CreateIfNotFound("sg_esc_e_mid_stug_02")
	
	local encData = {
		name = ("HMG_Enc_def_02"),
		player = player2,
		spawn = mkr_esc_e_mid_stug_01_spawn,
		sgroups = {sg_esc_e_blockers_all},
		units = {
			{
				sbp = SBP.GERMAN.STUG_III_SQUAD,
				spawn = mkr_esc_e_mid_stug_01_spawn,
				sgroups = {sg_esc_e_mid_stug_01},
			},
			{
				sbp = SBP.GERMAN.STUG_III_SQUAD,
				spawn = mkr_esc_e_mid_stug_02_spawn,
				sgroups = {sg_esc_e_mid_stug_02},
			},
		},
	}
	encID_stugHunters = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = sg_p_tiger,
		
		range = 40,
		leashRange = 30,
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = -1,
			},
			{
				tacticType = TACTIC_Vehicle,
				priority = 500,
			},
		}
	}
	encID_stugHunters:SetGoal(goalData)
	
	encID_stugHunters:Disable()
	
	Cmd_Move(sg_esc_e_mid_stug_01, mkr_esc_e_mid_stug_01_dest)
	Cmd_Move(sg_esc_e_mid_stug_02, mkr_esc_e_mid_stug_02_dest)
	
	Rule_AddInterval(_Escape_Town_StartStugs, 1)
	
end

function _Escape_Town_StartStugs()
	if Prox_AreSquadsNearMarker(sg_p_tiger, mkr_esc_startStug_hunting, ANY)
	  or SGroup_IsDoingAttack(sg_esc_e_mid_stug_01, ANY, 3)
	  or SGroup_IsDoingAttack(sg_esc_e_mid_stug_02, ANY, 3)
	  or SGroup_IsUnderAttack(sg_esc_e_mid_stug_01, ANY, 3)
	  or SGroup_IsUnderAttack(sg_esc_e_mid_stug_02, ANY, 3) then
		Rule_RemoveMe()
		
		encID_stugHunters:Enable()
	end
end

-- Left
function _Escape_Town_Left()

	sg_esc_e_left = SGroup_CreateIfNotFound("sg_esc_e_left")
	
	sg_esc_e_left_ht01 = SGroup_CreateIfNotFound("sg_esc_e_left_ht01")
	sg_esc_e_left_ht02 = SGroup_CreateIfNotFound("sg_esc_e_left_ht02")
	sg_esc_e_left_pio_01 = SGroup_CreateIfNotFound("sg_esc_e_left_pio_01")
	sg_esc_e_left_hmg_01 = SGroup_CreateIfNotFound("sg_esc_e_left_hmg_01")
	sg_esc_e_left_01 = SGroup_CreateIfNotFound("sg_esc_e_left_01")
	sg_esc_e_left_02 = SGroup_CreateIfNotFound("sg_esc_e_left_02")
	sg_esc_e_left_pak_01 = SGroup_CreateIfNotFound("sg_esc_e_left_pak_01")
	sg_esc_e_left_pak_02 = SGroup_CreateIfNotFound("sg_esc_e_left_pak_02")
	
	Util_CreateSquads(player2, {sg_esc_e_left_ht01, sg_esc_e_blockers_all}, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, mkr_esc_e_left_spawn_01, mkr_esc_e_left_ht01_dest)
	Util_CreateSquads(player2, {sg_esc_e_left_ht02, sg_esc_e_blockers_all}, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, mkr_esc_e_left_spawn_02, mkr_esc_e_left_ht02_dest)
	Rule_AddOneShot(_Escape_Town_Left_Units, 1)
	
	SGroup_SetInvulnerable(sg_esc_e_left_ht01, true)
	SGroup_SetInvulnerable(sg_esc_e_left_ht02, true)
	
	Util_CreateSquads(player2, {sg_esc_e_left_pak_01, sg_esc_e_blockers_all}, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_esc_e_left_spawn_03, mkr_esc_e_left_pak_01)
	Util_CreateSquads(player2, {sg_esc_e_left_pak_02, sg_esc_e_blockers_all}, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_esc_e_left_spawn_04, mkr_esc_e_left_pak_02)
	
	TeamWeapon_AddGroup(sg_esc_e_left_pak_01)
	TeamWeapon_AddGroup(sg_esc_e_left_pak_02)
	
	Modify_UnitSpeed(sg_esc_e_left_pak_01, 2)
	Modify_UnitSpeed(sg_esc_e_left_pak_02, 2)
	
	-- Unload
	Event_Proximity(_Escape_Town_Left_Unload_01, nil, sg_esc_e_left_ht01, mkr_esc_e_left_ht01_dest, 5, ANY, 5)
	Event_Proximity(_Escape_Town_Left_Unload_02, nil, sg_esc_e_left_ht02, mkr_esc_e_left_ht02_dest, 5, ANY, 5)
	
end

function _Escape_Town_Left_Units()

	-- Main Rearguard encounter
	local encData = {
		name = ("Town_Left"),
		player = player2,
		spawn = sg_esc_e_left_ht01,
		sgroups = {sg_esc_e_left, sg_esc_e_blockers_all},
		units = {
			{
				name = ("TEST"),
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				sgroups = {sg_esc_e_left_hmg_01},
			},
		},
	}
	
	encID_left = Encounter:Create(encData)
	
	Util_CreateSquads(player2, sg_esc_e_left_pio_01, SBP.GERMAN.PIONEER_SQUAD, sg_esc_e_left_ht01)
	
	-- Left Trenches
	local encData = {
		name = ("Town_Left_Trenches"),
		player = player2,
		spawn = sg_esc_e_left_ht02,
		sgroups = {sg_esc_e_left, sg_esc_e_blockers_all},
		units = {
			{
				name = ("TEST"),
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				sgroups = {sg_esc_e_left_01},
			},
			{
				name = ("TEST"),
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				sgroups = {sg_esc_e_left_02},
			},
		},
	}
	
	encID_left_trenches = Encounter:Create(encData)

end

function _Escape_Town_Left_Unload_01()
	-- Unload and build the trench
	Cmd_UngarrisonSquad(sg_esc_e_left_hmg_01)
--~ 	Util_GarrisonNearbyBuilding(sg_esc_e_left_hmg_01, Util_GetPosition(sg_esc_e_left_hmg_01), 20, false)
	
	Cmd_UngarrisonSquad(sg_esc_e_left_pio_01, mkr_esc_e_left_minefield_02)
--~ 	Cmd_Move(sg_esc_e_left_pio_01, mkr_esc_e_left_minefield_02, true)
	Cmd_Construct(sg_esc_e_left_pio_01, EBP.GERMAN.MINE_FIELD, mkr_esc_e_left_minefield_02, nil, true)
	
	Rule_AddOneShot(_Escape_Town_Left_Enable_AI, 5)
	Rule_AddDelayedInterval(_Escape_Town_Left_Add_Pio, 30, 1)
	
	SGroup_SetAutoTargetting(sg_esc_e_left_ht01, "hardpoint_01", true)
	SGroup_SetAutoTargetting(sg_esc_e_left_ht01, "hardpoint_02", true)
	
	SGroup_SetInvulnerable(sg_esc_e_left_ht01, false)
	
	table.insert(_veh_off_map, sg_esc_e_left_ht01)
--~ 	Rule_AddOneShot(_Escape_Town_Left_Abandon_01, 5)

end

function _Escape_Town_Left_Abandon_01()
	
	SGroup_SetRecrewable(sg_esc_e_left_ht01, false)
	Cmd_CriticalHit(player3, sg_esc_e_left_ht01, CRIT.VEHICLE_ABANDON_M8_TIGER, 1)
	
end

function _Escape_Town_Left_Enable_AI()

	local goalData = {
		name = "Defend",
		target = mkr_esc_e_left_def,
		
		range = 20,
		leashRange = 40,
		
		garrison = true,
		garrisonIdle = true,
	}
	
	encID_left:SetGoal(goalData)

end

function _Escape_Town_Left_Add_Pio()
	
	if SGroup_IsConstructingBuilding(sg_esc_e_left_pio_01, ANY) == false and
	  SGroup_IsMoving(sg_esc_e_left_pio_01, ALL) == false then
		Rule_RemoveMe()
		
		encID_left:AddSgroup(sg_esc_e_left_pio_01)
	end

end

function _Escape_Town_Left_Unload_02()
	-- Unload and build the trench
	Cmd_UngarrisonSquad(sg_esc_e_left_01)
	Cmd_UngarrisonSquad(sg_esc_e_left_02)
	Cmd_Construct(sg_esc_e_left_01, EBP.GERMAN.SLIT_TRENCH_GERMAN, mkr_esc_e_left_trench_01, nil, true)
	Cmd_Construct(sg_esc_e_left_02, EBP.GERMAN.SLIT_TRENCH_GERMAN, mkr_esc_e_left_trench_02, nil, true)
	
	Rule_AddInterval(_Escape_Town_Left_Trench_01, 1)
	Rule_AddInterval(_Escape_Town_Left_Trench_02, 1)
	SGroup_SetAutoTargetting(sg_esc_e_left_ht02, "hardpoint_01", true)
	SGroup_SetAutoTargetting(sg_esc_e_left_ht02, "hardpoint_02", true)
	SGroup_SetInvulnerable(sg_esc_e_left_ht02, false)
	
	-- Overload units
	sg_esc_e_left_03 = SGroup_CreateIfNotFound("sg_esc_e_left_03")
	sg_esc_e_left_04 = SGroup_CreateIfNotFound("sg_esc_e_left_04")
	
	Util_CreateSquads(player2, {sg_esc_e_left_03, sg_esc_e_blockers_all}, SBP.GERMAN.GRENADIER_SQUAD, Util_GetPosition(sg_esc_e_left_ht02))
	Util_CreateSquads(player2, {sg_esc_e_left_04, sg_esc_e_blockers_all}, SBP.GERMAN.PANZER_GRENADIER_SQUAD, Util_GetPosition(sg_esc_e_left_ht02))
	Cmd_Upgrade(sg_esc_e_left_04, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM, 1, true)
	
	Cmd_Construct(sg_esc_e_left_03, EBP.GERMAN.SLIT_TRENCH_GERMAN, mkr_esc_e_left_trench_03, Util_GetOffsetPosition(mkr_esc_e_left_trench_03, OFFSET_FRONT, 6))
	Cmd_Construct(sg_esc_e_left_03, EBP.GERMAN.SLIT_TRENCH_GERMAN, mkr_esc_e_left_trench_04, Util_GetOffsetPosition(mkr_esc_e_left_trench_04, OFFSET_FRONT, 6), true)
	
	Rule_AddInterval(_Escape_Town_Left_Trench_03, 1)
	Rule_AddInterval(_Escape_Town_Left_Trench_04, 1)
	
	Cmd_Move(sg_esc_e_left_04, Util_GetOffsetPosition(mkr_esc_e_left_trench_03, OFFSET_BACK, 6))
	
	table.insert(_veh_off_map, sg_esc_e_left_ht02)
--~ 	Rule_AddOneShot(_Escape_Town_Left_Abandon_02, 5)

end

function _Escape_Town_Left_Abandon_02()
	
	SGroup_SetRecrewable(sg_esc_e_left_ht02, false)
	Cmd_CriticalHit(player3, sg_esc_e_left_ht02, CRIT.VEHICLE_ABANDON_M8_TIGER, 1)
	
end

function _Escape_Town_Left_Trench_01()
	-- Trench built, hop in
	eg_left_trench_01 = EGroup_CreateIfNotFound("eg_left_trench_01")
	
	World_GetNeutralEntitiesNearMarker(eg_left_trench_01, mkr_esc_e_left_trench_01)
	
	EGroup_Filter(eg_left_trench_01, EBP.GERMAN.SLIT_TRENCH_GERMAN, FILTER_KEEP)
	
	if EGroup_IsEmpty(eg_left_trench_01) == false then
		Rule_RemoveMe()
		
		Cmd_Garrison(sg_esc_e_left_01, eg_left_trench_01)
	end

end

function _Escape_Town_Left_Trench_02()
	-- Trench built, hop in
	eg_left_trench_02 = EGroup_CreateIfNotFound("eg_left_trench_02")
	
	World_GetNeutralEntitiesNearMarker(eg_left_trench_02, mkr_esc_e_left_trench_02)
	
	EGroup_Filter(eg_left_trench_02, EBP.GERMAN.SLIT_TRENCH_GERMAN, FILTER_KEEP)
	
	if EGroup_IsEmpty(eg_left_trench_02) == false then
		Rule_RemoveMe()
		
		Cmd_Garrison(sg_esc_e_left_02, eg_left_trench_02)
	end

end

function _Escape_Town_Left_Trench_03()
	-- Trench built, hop in
	eg_left_trench_03 = EGroup_CreateIfNotFound("eg_left_trench_03")
	
	World_GetNeutralEntitiesNearMarker(eg_left_trench_03, mkr_esc_e_left_trench_03)
	
	EGroup_Filter(eg_left_trench_03, EBP.GERMAN.SLIT_TRENCH_GERMAN, FILTER_KEEP)
	
	if EGroup_IsEmpty(eg_left_trench_03) == false then
		Rule_RemoveMe()
		
		Cmd_Garrison(sg_esc_e_left_04, eg_left_trench_03)
	end

end

function _Escape_Town_Left_Trench_04()
	-- Trench built, hop in
	eg_left_trench_04 = EGroup_CreateIfNotFound("eg_left_trench_04")
	
	World_GetNeutralEntitiesNearMarker(eg_left_trench_04, mkr_esc_e_left_trench_04)
	
	EGroup_Filter(eg_left_trench_04, EBP.GERMAN.SLIT_TRENCH_GERMAN, FILTER_KEEP)
	
	if EGroup_IsEmpty(eg_left_trench_04) == false then
		Rule_RemoveMe()
		
		Cmd_Garrison(sg_esc_e_left_03, eg_left_trench_04)
	end

end

-- Left Rear Guard
function _Escape_Town_Left_RearGuard()

	sg_esc_e_left_rearGuard = SGroup_CreateIfNotFound("sg_esc_e_left_rearGuard")
	
	sg_esc_e_left_rearGuard_ht = SGroup_CreateIfNotFound("sg_esc_e_left_rearGuard_ht")
	sg_esc_e_left_rearGuard_pio = SGroup_CreateIfNotFound("sg_esc_e_left_rearGuard_pio")
	sg_esc_e_left_rearGuard_panzerGren = SGroup_CreateIfNotFound("sg_esc_e_left_rearGuard_panzerGren")
	
	Util_CreateSquads(player2, {sg_esc_e_left_rearGuard_ht, sg_esc_e_blockers_all}, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, mkr_esc_e_left_spawn_05, mkr_esc_e_left_rearGuard_ht01_dest_A)
	
	SGroup_SetInvulnerable(sg_esc_e_left_rearGuard_ht, true)
	Event_Proximity(_Escape_Town_Left_RearGuard_Unload_01_A, nil, sg_esc_e_left_rearGuard_ht, mkr_esc_e_left_rearGuard_ht01_dest_A, 5, ANY, 5)
	
end

function _Escape_Town_Left_RearGuard_Unload_01_A()

	Util_CreateSquads(player2, {sg_esc_e_left_rearGuard_pio, sg_esc_e_blockers_all}, SBP.GERMAN.PIONEER_SQUAD, mkr_esc_e_left_rearGuard_ht01_dest_A)
	Cmd_Move(sg_esc_e_left_rearGuard_pio, mkr_esc_e_left_minefield_01)
	Cmd_Construct(sg_esc_e_left_rearGuard_pio, EBP.GERMAN.MINE_FIELD, mkr_esc_e_left_minefield_01, nil, true)
	Cmd_Move(sg_esc_e_left_rearGuard_pio, Util_GetOffsetPosition(mkr_esc_e_left_trench_04, OFFSET_BACK, 5), true)
	
	Cmd_Move(sg_esc_e_left_rearGuard_ht, mkr_esc_e_left_rearGuard_ht01_dest_B)
	Event_Proximity(_Escape_Town_Left_RearGuard_Unload_01_B, nil, sg_esc_e_left_rearGuard_ht, mkr_esc_e_left_rearGuard_ht01_dest_B, 5, ANY, 5)

end

function _Escape_Town_Left_RearGuard_Unload_01_B()
	
	SGroup_SetInvulnerable(sg_esc_e_left_rearGuard_ht, false)
	Util_CreateSquads(player2, {sg_esc_e_left_rearGuard_panzerGren, sg_esc_e_blockers_all}, SBP.GERMAN.PANZER_GRENADIER_SQUAD, Util_GetOffsetPosition(mkr_esc_e_left_rearGuard_ht01_dest_B, OFFSET_RIGHT, 5))
	Cmd_Upgrade(sg_esc_e_left_rearGuard_panzerGren, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM, 1, true)

end
-- Hint groups
function Tiger_Hunting_UpdateHintGroups()

	local conscripts = {
		SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
		SBP.SOVIET.M08_TANK_BUSTER_CONSCRIPT_SQUAD,
		SBP.SOVIET.CONSCRIPT_SQUAD,
		SBP.SOVIET.PENAL_BATTALION,
	}
	Player_GetAll(player1, sg_mergehints)
	SGroup_Filter(sg_mergehints, conscripts, FILTER_KEEP)
	
	
	local infantry = {}
	local _add = function(k, v) table.insert(infantry, v) end
	table.foreach(LIST.INFANTRY, _add)
	table.foreach(LIST.ATGUNS, _add)
	table.foreach(LIST.HMGS, _add)
	
	Player_GetAll(player1, sg_reinforcehints)
	SGroup_Filter(sg_reinforcehints, infantry, FILTER_KEEP)

end






function Util_GetOffset(element, target)
	
	local _tDir = {OFFSET_BACK, OFFSET_BACK_LEFT, OFFSET_BACK_RIGHT, OFFSET_FRONT, OFFSET_FRONT_LEFT, OFFSET_FRONT_RIGHT, OFFSET_LEFT, OFFSET_RIGHT}
	local closest = 99999999
	local dir = nil
	
	for i = 1, table.getn(_tDir) do
		local pos = Util_GetOffsetPosition(element, _tDir[i], 5)
		local dist = Util_GetDistance(pos, target)
		if dist < closest then
			closest = dist
			dir = _tDir[i]
		end
	end
	
	return dir

end
--print(Util_GetOffset(sg_e_tiger, mkr_theHunt_tiger_north_01)
