-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- MISSION: Tiger Ace Encounters
-- Designer: Shannon Gadbois


----------------------------------
-- Enemy Encounters -- 
----------------------------------

-- Setup the Encounter Spaces
function SetupEncounters()
	
	-- tables

	-- Variables
	sg_e_all = SGroup_CreateIfNotFound("sg_e_all")
	sg_e_infantry = SGroup_CreateIfNotFound("sg_e_infantry")
	sg_all_vehicles = SGroup_CreateIfNotFound("sg_all_vehicles")
	sg_all_infantry = SGroup_CreateIfNotFound("sg_all_infantry")
	sg_base_all = SGroup_CreateIfNotFound("sg_base_all")
	sg_base_01 = SGroup_CreateIfNotFound("sg_base_01")
	sg_base_02 = SGroup_CreateIfNotFound("sg_base_02")
	-- Start Encounters
	SetupArea01()
	Event_Proximity(Area02_Check, nil, player1, mkr_gate2_trigger_01, 35, ANY)
	Event_Proximity(Area02_Check, nil, player1, mkr_gate2_trigger_02, 10, ANY)
	Event_Proximity(Area02_Check, nil, player1, mkr_gate2_trigger_03, 10, ANY)
	SetupArea03()

	secondary_spawn = mkr_south_sp_01
	secondary_spawn_02 = mkr_south_sp_02
	random_enc = World_GetRand(1, 2) -- used for determining which tank encounter will spawn in the mission
	
	-- random encounter setup
	if random_enc == 1 then
		-- random encounter spawn point tables
		t_random_enc_01 = {mkr_random_enc_01, mkr_random_enc_02}
		t_random_enc_02 = {mkr_random_enc_03, mkr_random_enc_04}
		
		Random_Encounter_01()
		Random_Encounter_02()
		
		-- random patrol setup
		patrol_01_spawn = mkr_patrol1_sp
		patrol_01_path = "Patrol_01"
		patrol_02_spawn = mkr_patrol2_sp
		patrol_02_path = "Patrol_02"
	
	elseif random_enc == 2 then
		-- random encounter spawn point tables
		t_random_enc_01 = {mkr_random_enc_01, mkr_random_enc_03}
		t_random_enc_02 = {mkr_random_enc_02, mkr_random_enc_04}
		
		Random_Encounter_01()
		Random_Encounter_02()
		
		-- random patrol setup
		patrol_01_spawn = mkr_patrol1b_sp
		patrol_01_path = "Patrol_01b"
		patrol_02_spawn = mkr_patrol2b_sp
		patrol_02_path = "Patrol_02b"
	end
	
	Sniper_Patrol_01()
	Sniper_Patrol_02()
	
	Rule_AddInterval(Gate_Breached, 1)
	Rule_AddInterval(Check_ScoutCar, 1)
end

-- Encounter 1 - Gate 1
function SetupArea01()
	
	sg_enc01_all = SGroup_CreateIfNotFound("sg_enc01_all")

	local encData = {
		player = player2,
		sgroups = {sg_e_all},
		units = {
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = mkr_gate1_sp_01,
				load = 5,
				sgroups = {sg_enc01_all},
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = mkr_gate1_sp_02,
				load = 5,
				sgroups = {sg_enc01_all},
			},
			{
				sbp = SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD,
				spawn = mkr_gate1_at_01,
				load = 4,
				sgroups = {sg_enc01_all},
			},
		},
		onDeath = nil,
	}
	enc_01 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_gate1_space,
		leashRange = 15, 
	}
	enc_01:SetGoal(goalData)
end	

-- Encounter 2 - Gate 2
-- Check to see if either phase 2 has started or the player hasnt triggered this encounter already from a different approach direction.
function Area02_Check()
	if phase2_started == false and enc2_started == false then
		SetupArea02()
	end
end
function SetupArea02()
	enc2_started = true
	sg_enc02_all = SGroup_CreateIfNotFound("sg_enc02_all")
	sg_enc02_mortar = SGroup_CreateIfNotFound("sg_enc02_mortar")
	sg_enc02_mg = SGroup_CreateIfNotFound("sg_enc02_mg")
	local encData = {
		player = player2,
		sgroups = {sg_e_all},
		units = {
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = mkr_gate2_sp_01,
				load = 5,
				sgroups = {sg_enc02_all},
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = mkr_gate2_sp_02,
				load = 5,
				sgroups = {sg_enc02_all},
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_gate2_sp_04,
				load = 4,
				sgroups = {sg_enc02_all, sg_enc02_mortar},
			},

		},
		onDeath = nil,
	}
	enc_02 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_gate2_space,
		range = 35, 
		leashRange = 15,
		useSkirmishAI = false,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 100,
			},
		},
	}
	enc_02:SetGoal(goalData)
	
	
	local encData2 = {
		player = player2,
		sgroups = {sg_e_all},
		units = {
			{
				sbp = SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD,
				spawn = mkr_gate2_sp_03,
				load = 4,
				sgroups = {sg_enc02_all, sg_enc02_mg},
			},
		},
		onDeath = nil,
	}
	
	enc_02b = Encounter:Create(encData2)
	
	local goalData2 = {
		name = "Defend",
		target = mkr_gate2_space,
		range = 35, 
		leashRange = 10,
		useSkirmishAI = false,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 100,
			},
		},
	}
	enc_02b:SetGoal(goalData2)
end	

-- Encounter 3 - Gate 3
function SetupArea03()
	
	sg_enc03_all = SGroup_CreateIfNotFound("sg_enc03_all")

	local encData = {
		player = player2,
		sgroups = {sg_e_all},
		units = {
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = mkr_gate3_sp_01,
				load = 5,
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = mkr_gate3_sp_02,
				load = 5,
			},
			{
				sbp = SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD,
				spawn = mkr_gate3_at_01,
				load = 4,
			},
		},
		onDeath = nil,
	}
	enc_03 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_gate3_space,
		leashRange = 15, 
	}
	enc_03:SetGoal(goalData)
end	

-- Encounter 4 - Gate 4
function SetupArea04()
	
	sg_enc04_all = SGroup_CreateIfNotFound("sg_enc04_all")

	local encData = {
		player = player2,
		sgroups = {sg_e_all},
		units = {
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = mkr_patrol1_sp,
				load = 3,
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = mkr_patrol1_sp,
				load = 3,
			},
		},
		onDeath = nil,
	}
	enc_04 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_base_space_north,
		leashRange = 20, 
	}
	enc_04:SetGoal(goalData)
end	

-- Encounter 4 - Gate 4
function SetupArea05()
	
	sg_enc04_all = SGroup_CreateIfNotFound("sg_enc05_all")

	local encData = {
		player = player2,
		sgroups = {sg_e_all},
		units = {
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = mkr_patrol2_sp,
				load = 3,
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = mkr_patrol2_sp,
				load = 3,
			},
		},
		onDeath = nil,
	}
	enc_05 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_base_space_east,
		leashRange = 20, 
	}
	enc_05:SetGoal(goalData)
end	

-- Patrol 1
function Sniper_Patrol_01()
	local encData = {
		player = player2,
		sgroups = {sg_e_all},
		units = {
			{
				sbp = Util_DifVar({SBP.SOVIET.GUARDS_TROOPS, SBP.SOVIET.GUARDS_TROOPS, SBP.SOVIET.SNIPER_TEAM}),
				spawn = patrol_01_spawn,
				load = 3,
			},
		},
		onDeath = nil,
	}
	enc_patrol_01 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_gate2_space,
		leashRange = 40, 
		attackMove = true,
		patrolParams = {
			path = patrol_01_path,
			wait = 12,
		},
	}
	enc_patrol_01:SetGoal(goalData)
end	

-- Patrol 1
function Sniper_Patrol_02()

	local encData = {
		player = player2,
		sgroups = {sg_e_all},
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = patrol_02_spawn,
				load = 3,
			},
		},
		onDeath = nil,
	}
	enc_patrol_02 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_gate2_space,
		attackMove = true,
		patrolParams = {
			path = patrol_02_path,
			wait = 5,
		},
	}
	enc_patrol_02:SetGoal(goalData)
end	

-- Random Encounters

function Random_Encounter_01()
	if World_GetRand(1,4) >= 2 then
		local random_spawn = Table_GetRandomItem(t_random_enc_01)
		local encData = {
			player = player2,
			sgroups = {sg_e_all},
			units = {
				{
					sbp = SBP.SOVIET.GUARDS_TROOPS,
					spawn = random_spawn,
					load = 4,
				},
			},
			onDeath = nil,
		}
		enc_random_01 = Encounter:Create(encData)
		
		local goalData = {
			name = "Defend",
			target = random_spawn,
			range = 30,
			leashRange = 40, 

		}
		enc_random_01:SetGoal(goalData)
	else
		print("Skipping random encounter 1")
	end
end	

function Random_Encounter_02()
	if World_GetRand(1,4) >= 2 then
		local random_spawn = Table_GetRandomItem(t_random_enc_02)
		local encData = {
			player = player2,
			sgroups = {sg_e_all},
			units = {
				{
					sbp = SBP.SOVIET.GUARDS_TROOPS,
					spawn = random_spawn,
					load = 4,
				},
			},
			onDeath = nil,
		}
		enc_random_02 = Encounter:Create(encData)
		
		local goalData = {
			name = "Defend",
			target = random_spawn,
			range = 30,
			leashRange = 40, 

		}
		enc_random_02:SetGoal(goalData)
	else
		print("Skipping random encounter 2")
	end
end	


-- Encounter 4 - Base 1
function SetupBase01()

	local encData = {
		player = player2,
		sgroups = {sg_e_all, sg_base_all},
		units = {
			{
				sbp = SBP.SOVIET.SOVIET_OFFICER_SQUAD,
				spawn = mkr_building_sp_01,
				load = 1,
				veterancyRank = Util_DifVar({1, 2, 3}),
			},
			{
				sbp = SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD,
				spawn = mkr_building_sp_01,
				load = 5,
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = mkr_building_sp_04,
				load = 6,
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_building_sp_05,
				load = 4,
				veterancyRank = Util_DifVar({0, 0, 1}),
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_building_sp_06,
				load = 4,
				veterancyRank = Util_DifVar({0, 0, 1}),
			},
		},
		onDeath = nil,
	}
	base_enc_01 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_base_space1,
		range = 30,
		leashRange = 20, 
	}
	base_enc_01:SetGoal(goalData)

end	


-- Encounter 4 - Base 2
function SetupBase02()

--~ 	local encData = {
--~ 		player = player2,
--~ 		sgroups = {sg_e_all, sg_base_all},
--~ 		units = {
--~ 			{
--~ 				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
--~ 				spawn = mkr_base_sp_04,
--~ 				load = 4,
--~ 			},
--~ 			{
--~ 				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
--~ 				spawn = mkr_base_sp_04,
--~ 				load = 6,
--~ 			},
--~ 			{
--~ 				sbp= SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
--~ 				spawn = Table_GetRandomItem({mkr_base_sp_04, mkr_base_sp_06}),
--~ 				load = 6,
--~ 			},
--~ 			{
--~ 				sbp = SBP.SOVIET.GUARDS_TROOPS,
--~ 				spawn = mkr_base_sp_04,
--~ 				load = 4,
--~ 				upgrades = {UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP},
--~ 				veterancyRank = Util_DifVar({0, 2, 3}),
--~ 			},
--~ 			{
--~ 				sbp = SBP.SOVIET.GUARDS_TROOPS,
--~ 				spawn = mkr_base_sp_04,
--~ 				load = 4,
--~ 				upgrades = {UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP},
--~ 				veterancyRank = Util_DifVar({0, 2, 3}),
--~ 			},
--~ 		},
--~ 		onDeath = nil,
--~ 	}
--~ 	base_enc_02 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_base_space2,
		range = 30,
		leashRange = 30, 
	}
	
	
	Util_CreateSquads (player2, {sg_e_all, sg_base_all, sg_base_02}, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_building_sp_02, mkr_base_sp_02, 1)
	Util_CreateSquads (player2, {sg_e_all, sg_base_all, sg_base_02}, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_building_sp_04, mkr_base_sp_04, 1)
	Util_CreateSquads (player2, {sg_e_all, sg_base_all, sg_base_02}, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_building_sp_05, mkr_base_sp_06, 1)
	Util_CreateSquads (player2, {sg_e_all, sg_base_all, sg_base_02}, SBP.SOVIET.GUARDS_TROOPS, mkr_building_sp_02, mkr_base_sp_02, 1, nil, true, mkr_base_sp_02)
	Util_CreateSquads (player2, {sg_e_all, sg_base_all, sg_base_02}, SBP.SOVIET.GUARDS_TROOPS, mkr_building_sp_06, mkr_base_sp_05, 1, nil, true, mkr_base_sp_05)
	base_enc_02 = Encounter:ConvertSgroup(sg_base_02)
	base_enc_02:SetGoal(goalData)
end	


--------------------------------------------------
-- Phase 2 Encounters
--------------------------------------------------

function Start_Waves()
	Initial_Attack_Direction()
	Wave01()
	Bonus_enc01()
	Bonus_enc02()
	Rule_AddInterval(Enemy_Capture_Check, 2)
end
function Wave01()

	Util_StartIntel(EVENTS.Enemy_Wave_01)-- Wave Start Intel Event
	
	local t_randomspawn = {mkr_west_sp_01, mkr_east_sp_01, mkr_south_sp_01}
	local RandomSpawn = Table_GetRandomItem(t_randomspawn)
	sg_wave1_all = SGroup_CreateIfNotFound("sg_wave1_all")
	sg_wave1_tanks = SGroup_CreateIfNotFound("sg_wave1_tanks")
	wave01_ui = Objective_AddUIElements(OBJ_Gold, initial_spawn, true, 11055205, true)
	wave01_ui_02 = Objective_AddUIElements(OBJ_Gold, initial_spawn_02, true, 11055205, true)
	wave1_title = Util_MissionTitle( 11055206 )
	local encData = {
		player = player2,
		sgroups = {sg_wave1_all, sg_e_all},
		units = {
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = initial_spawn,
				load = 6,
				sgroups = {sg_all_infantry},
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = initial_spawn_02,
				load = 6,
				sgroups = {sg_all_infantry},
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = initial_spawn,
				load = 4,
				sgroups = {sg_all_infantry},
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = initial_spawn_02,
				load = 4,
				sgroups = {sg_all_infantry},
			},
		},
		onDeath = nil,
	}
	enc_wave1 = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		attackMove = true,
		target = mkr_base_space1,
		range = 45,
		leashRange = 20, 
	}
	enc_wave1:SetGoal(goalData)
	
	Event_Timer(Remove_Attack_UI_01, nil, 20)
	Event_GroupLeftAlive(Wave01b, nil, sg_wave1_all, 12)
end	

function Wave01b()
	
	local t_randomspawn = {mkr_west_sp_01, mkr_east_sp_01, mkr_south_sp_01}
	local RandomSpawn = Table_GetRandomItem(t_randomspawn)
	sg_wave1_all = SGroup_CreateIfNotFound("sg_wave1_all")
	sg_wave1_tanks = SGroup_CreateIfNotFound("sg_wave1_tanks")
	wave01_ui = Objective_AddUIElements(OBJ_Gold, initial_spawn, true, 11055205, true)
	wave01_ui_02 = Objective_AddUIElements(OBJ_Gold, initial_spawn_02, true, 11055205, true)
	local encData = {
		player = player2,
		sgroups = {sg_wave1_all, sg_e_all},
		units = {
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = initial_spawn,
				load = 6,
				sgroups = {sg_all_infantry},
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = initial_spawn,
				load = 6,
				sgroups = {sg_all_infantry},
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = initial_spawn_02,
				load = 6,
				sgroups = {sg_all_infantry},
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = initial_spawn_02,
				load = 6,
				sgroups = {sg_all_infantry},
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = initial_spawn,
				load = 4,
				sgroups = {sg_all_infantry},
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = initial_spawn_02,
				load = 4,
				sgroups = {sg_all_infantry},
			},
		},
		onDeath = nil,
	}
	enc_wave1 = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		attackMove = true,
		target = mkr_base_space1,
		range = 45,
		leashRange = 20, 
	}
	enc_wave1:SetGoal(goalData)
	
	Event_Timer(Remove_Attack_UI_01, nil, 20)
	Event_GroupLeftAlive(Start_Wave02, nil, sg_wave1_all, 6)
end	

function Start_Wave02()
	Check_Player_Status()
	print ("Player population percentage check"..g_buffer_time)
	Event_Timer(Wave02, nil, 15 + g_buffer_time)
end

function Wave02()
	print ("Starting Wave 2")
	Player_SetAbilityAvailability(player2, ABILITY.SOVIET.ANTI_TANK_GRENADE, ITEM_UNLOCKED)
	Player_SetAbilityAvailability(player2, ABILITY.SOVIET.GUARDS_THROW_DEFENSIVE_GRENADE, ITEM_UNLOCKED)
	Start_Night() -- start night transition
	IncrementWaveCounter()
	sg_wave2_all = SGroup_CreateIfNotFound("sg_wave2_all")
	wave02_ui = Objective_AddUIElements(OBJ_Gold, secondary_spawn, true, 11055205, true)
	wave02_ui_02 = Objective_AddUIElements(OBJ_Gold, secondary_spawn_02, true, 11055205, true)
	wave2_title = Util_MissionTitle( 11055207)
	Util_StartIntel(EVENTS.Enemy_Wave_02)-- Wave Start Intel Event
	local encData = {
		player = player2,
		sgroups = {sg_wave2_all},
		units = {
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = secondary_spawn,
				load = 6,
				sgroups = {sg_all_infantry},
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = secondary_spawn_02,
				load = 6,
				sgroups = {sg_all_infantry},
			},
			{
				sbp = SBP.SOVIET.T_70M,
				spawn = secondary_spawn,
				load = 1,
				sgroups = {sg_all_vehicles},
			},

			{
				sbp = SBP.SOVIET.T_70M,
				spawn = secondary_spawn_02,
				load = 1,
				sgroups = {sg_all_vehicles},
			},

		},
		onDeath = nil,
	}
	enc_wave2 = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		attackMove = true,
		target = mkr_base_space1,
		leashRange = 30, 
	}
	enc_wave2:SetGoal(goalData)
	Event_GroupLeftAlive(Wave02b, nil, sg_wave2_all, 6)
	Event_Timer(Remove_Attack_UI_02, nil, 20)
end	

function Wave02b()
	local t_randomspawn = {mkr_west_sp_01, mkr_east_sp_01}
	local RandomSpawn = Table_GetRandomItem(t_randomspawn)
	sg_wave2b_all = SGroup_CreateIfNotFound("sg_wave2b_all")
	wave02_ui = Objective_AddUIElements(OBJ_Gold, mkr_east_attack_ui, true, 11055205, true)
	wave02b_ui = Objective_AddUIElements(OBJ_Gold, mkr_east_attack_ui, true, 11055205, true)
	local encData = {
		player = player2,
		sgroups = {sg_wave2b_all},
		units = {
			{
				sbp = SBP.SOVIET.COMBAT_ENGINEER_SQUAD,
				spawn = mkr_west_sp_01,
				load = 4,
				upgrades = {UPG.SOVIET.ENGINEER_FLAMETHROWER},
				sgroups = {sg_all_infantry},
			},
			{
				sbp = SBP.SOVIET.COMBAT_ENGINEER_SQUAD,
				spawn = mkr_west_sp_02,
				load = 4,
				upgrades = {UPG.SOVIET.ENGINEER_FLAMETHROWER},
				sgroups = {sg_all_infantry},
			},
			{
				sbp = SBP.SOVIET.COMBAT_ENGINEER_SQUAD,
				spawn = mkr_east_sp_01,
				load = 4,
				upgrades = {UPG.SOVIET.ENGINEER_FLAMETHROWER},
				sgroups = {sg_all_infantry},
			},
			{
				sbp = SBP.SOVIET.COMBAT_ENGINEER_SQUAD,
				spawn = mkr_east_sp_02,
				load = 4,
				upgrades = {UPG.SOVIET.ENGINEER_FLAMETHROWER},
				sgroups = {sg_all_infantry},
			},
			{
				sbp = SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD,
				spawn = RandomSpawn,
				load = 1,
				sgroups = {sg_all_infantry},
			},
			{
				sbp = SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD,
				spawn = RandomSpawn,
				load = 1,
				sgroups = {sg_all_infantry},
			},
		},
		onDeath = nil,
	}
	enc_wave2b = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		attackMove = true,
		target = mkr_base_space1,
		leashRange = 20, 
	}
	enc_wave2b:SetGoal(goalData)
	Event_GroupLeftAlive(Start_Wave03, nil, sg_wave2b_all, 8)
	Event_Timer(Remove_Attack_UI_02b, nil, 20)
end	

function Start_Wave03()
	Check_Player_Status()
	print ("Player population percentage check"..g_buffer_time)
	Event_Timer(Wave03, nil, 20 + g_buffer_time)
end

function Wave03()
	IncrementWaveCounter()
	Util_StartIntel(EVENTS.Enemy_Wave_03)
	local t_randomspawn = {mkr_west_sp_01, mkr_east_sp_01}
	local RandomSpawn = Table_GetRandomItem(t_randomspawn)
	sg_wave3_all = SGroup_CreateIfNotFound("sg_wave3_all")
	sg_wave3_mortar = SGroup_CreateIfNotFound("sg_wave3_mortar")
	wave03_ui = Objective_AddUIElements(OBJ_Gold, mkr_south_sp_01, true, 11055205, true)
	wave03b_ui = Objective_AddUIElements(OBJ_Gold, RandomSpawn, true, 11055205, true)
	wave3_title = Util_MissionTitle( 11055208)
	local encData = {
		player = player2,
		sgroups = {sg_wave3_all},
		units = {
			{
				sbp = SBP.SOVIET.PENAL_BATTALION,
				spawn = mkr_south_sp_01,
				load = 6,
				sgroups = {sg_all_infantry},
			},
			{
				sbp = SBP.SOVIET.PENAL_BATTALION,
				spawn = mkr_south_sp_02,
				load = 6,
				sgroups = {sg_all_infantry},
			},
			{
				sbp = SBP.SOVIET.PENAL_BATTALION,
				spawn = RandomSpawn,
				load = 6,
				sgroups = {sg_all_infantry},
			},
			{
				sbp = SBP.SOVIET.PENAL_BATTALION,
				spawn = RandomSpawn,
				load = 6,
				sgroups = {sg_all_infantry},
			},
			{
				sbp = SBP.GERMAN.MORTAR_TEAM_81MM,
				spawn = mkr_south_sp_01,
				load = 4,
				sgroups = {sg_wave3_mortar, sg_all_infantry},
			},
			{
				sbp = Util_DifVar({ SBP.GERMAN.MORTAR_TEAM_81MM, SBP.SOVIET.HM_120_38_MORTAR_SQUAD, SBP.SOVIET.HM_120_38_MORTAR_SQUAD, }),
				spawn = RandomSpawn,
				load = 4,
				sgroups = {sg_wave3_mortar, sg_all_infantry},
			},
		},
		onDeath = nil,
	}
	enc_wave3 = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		attackMove = true,
		target = mkr_base_space1,
		leashRange = 20, 
		range = 50,
	}
	enc_wave3:SetGoal(goalData)
	Modify_SightRadius(sg_wave3_mortar, 0.6)
	Event_GroupLeftAlive(Start_Wave04, nil, sg_wave3_all, 6)
	Event_Timer(Remove_Attack_UI_03, nil, 20)
end	

function Start_Wave04()
	Check_Player_Status()
	print ("Player population percentage check"..g_buffer_time)
	Event_Timer(Wave04, nil, 20 + g_buffer_time)
end

function Wave04()
	IncrementWaveCounter()
	Util_StartIntel(EVENTS.Enemy_Wave_04)
	local t_randomspawn = {mkr_east_sp_01, mkr_south_sp_01}
	local t_randomspawn2 = {mkr_west_sp_01, mkr_south_sp_01}
	local RandomSpawn = Table_GetRandomItem(t_randomspawn)
	local RandomSpawn2 = Table_GetRandomItem(t_randomspawn2)
	sg_wave4_all = SGroup_CreateIfNotFound("sg_wave4_all")
	wave04_ui = Objective_AddUIElements(OBJ_Gold, mkr_west_sp_01, true, 11055205, true)
	wave04b_ui = Objective_AddUIElements(OBJ_Gold, mkr_east_sp_01, true, 11055205, true)
	wave04c_ui = Objective_AddUIElements(OBJ_Gold, mkr_south_sp_01, true, 11055205, true)
	wave4_title = Util_MissionTitle( 11055209 )
	local encData = {
		player = player2,
		sgroups = {sg_wave4_all},
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_west_sp_01,
				load = 5,
				sgroups = {sg_all_infantry},
				upgrades = {UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP},
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_east_sp_01,
				load = 5,
				sgroups = {sg_all_infantry},
				upgrades = {UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP},
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_west_sp_01,
				load = 5,
				sgroups = {sg_all_infantry},
				upgrades = {UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP},
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_east_sp_01,
				load = 5,
				sgroups = {sg_all_infantry},
				upgrades = {UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP},
			},
			{
				sbp = Util_DifVar({ SBP.SOVIET.T_70M, SBP.SOVIET.T_70M, SBP.SOVIET.T_34_85_SQUAD, }),
				spawn = RandomSpawn,
				load = 1,
				sgroups = {sg_all_vehicles},
			},
			{
				sbp = SBP.SOVIET.SU_76M,
				spawn = RandomSpawn2,
				load = 1,
				sgroups = {sg_all_vehicles},
			},
			{
				sbp = Util_DifVar({ SBP.SOVIET.T_70M, SBP.SOVIET.T_70M, SBP.SOVIET.T_34_85_SQUAD, }),
				spawn = mkr_west_sp_01,
				load = 1,
				sgroups = {sg_all_vehicles},
			},
			{
				sbp = SBP.SOVIET.SU_76M,
				spawn = mkr_east_sp_01,
				load = 1,
				sgroups = {sg_all_vehicles},
				
			},
		},
		onDeath = nil,
	}
	enc_wave4 = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		attackMove = true,
		target = mkr_base_space1,
		leashRange = 20, 
		range = 40,
		
	}
	enc_wave4:SetGoal(goalData)
	Event_GroupLeftAlive(Start_Wave04b, nil, sg_wave4_all, 6)
	Event_Timer(Remove_Attack_UI_04, nil, 20)
end	

function Start_Wave04b()
	Check_Player_Status()
	print ("Player population percentage check"..g_buffer_time)
	Event_Timer(Wave04b, nil, 20 + g_buffer_time)
end

function Wave04b()
	IncrementWaveCounter()
	Player_SetAbilityAvailability(player2, ABILITY.SOVIET.ANTI_TANK_GRENADE, ITEM_LOCKED)
	Player_SetAbilityAvailability(player2, ABILITY.SOVIET.GUARDS_THROW_DEFENSIVE_GRENADE, ITEM_LOCKED)
	Util_StartIntel(EVENTS.Enemy_Wave_05)
	local t_randomspawn = {mkr_east_sp_01, mkr_south_sp_01}
	local t_randomspawn2 = {mkr_west_sp_01, mkr_south_sp_02}
	local RandomSpawn = Table_GetRandomItem(t_randomspawn)
	local RandomSpawn2 = Table_GetRandomItem(t_randomspawn2)
	sg_wave4_all = SGroup_CreateIfNotFound("sg_wave4_all")
	sg_wave4_tanks = SGroup_CreateIfNotFound("sg_wave4_all")
	wave04_ui = Objective_AddUIElements(OBJ_Gold, mkr_west_sp_01, true, 11055205, true)
	wave04b_ui = Objective_AddUIElements(OBJ_Gold, mkr_east_sp_01, true, 11055205, true)
	wave04c_ui = Objective_AddUIElements(OBJ_Gold, mkr_south_sp_01, true, 11055205, true)
	wave5_title = Util_MissionTitle( 11055210)
	local encData = {
		player = player2,
		sgroups = {sg_wave4_all, sg_enc_all},
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_west_sp_01,
				load = 5,
				sgroups = {sg_all_infantry},
				upgrades = {UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP},
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_west_sp_02,
				load = 5,
				sgroups = {sg_all_infantry},
				upgrades = {UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP},
			},
			{
				sbp = SBP.SOVIET.PENAL_BATTALION,
				spawn = mkr_west_sp_01,
				load = 5,
				sgroups = {sg_all_infantry},
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_east_sp_01,
				load = 5,
				sgroups = {sg_all_infantry},
				upgrades = {UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP},
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_east_sp_02,
				load = 5,
				sgroups = {sg_all_infantry},
				upgrades = {UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP},
			},
			{
				sbp = SBP.SOVIET.PENAL_BATTALION,
				spawn = mkr_east_sp_01,
				load = 5,
				sgroups = {sg_all_infantry},
			},
			{
				sbp = SBP.SOVIET.KV_2,
				spawn = RandomSpawn,
				load = 1,
				sgroups = {sg_enc04_tanks, sg_all_vehicles},
			},
			{
				sbp = SBP.SOVIET.KV_2,
				spawn = RandomSpawn2,
				load = 1,
				sgroups = {sg_enc04_tanks, sg_all_vehicles},
			},
		},
		onDeath = nil,
	}
	enc_wave4b = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		attackMove = true,
		target = mkr_base_space1,
		leashRange = 40, 
		range = 20,
		
	}
	enc_wave4b:SetGoal(goalData)
	Event_GroupLeftAlive(Wave04c, nil, sg_wave4_all, 8)
	Event_Timer(Remove_Attack_UI_04, nil, 20)
end	


function Wave04c()
	local t_randomspawn = {mkr_west_sp_01, mkr_west_sp_02, mkr_east_sp_01,mkr_east_sp_02, mkr_south_sp_01, mkr_south_sp_02}
	local RandomSpawn = Table_GetRandomItem(t_randomspawn)
	wave02_ui = Objective_AddUIElements(OBJ_Gold, mkr_south_sp_01, true, 11055205, true)
	wave02_ui_02 = Objective_AddUIElements(OBJ_Gold, RandomSpawn, true, 11055205, true)
	local encData = {
		player = player2,
		sgroups = {sg_wave4_all},
		units = {
--~ 			{
--~ 				sbp = SBP.SOVIET.HM_120_38_MORTAR_SQUAD,
--~ 				spawn = RandomSpawn,
--~ 				load = 4,
--~ 				sgroups = {sg_wave3_mortar, sg_all_infantry},
--~ 			},
			{
				sbp = SBP.SOVIET.PENAL_BATTALION,
				spawn = mkr_south_sp_01,
				load = 5,
				sgroups = {sg_all_infantry},
			},
			{
				sbp = SBP.SOVIET.PENAL_BATTALION,
				spawn = mkr_south_sp_01,
				load = 5,
				sgroups = {sg_all_infantry},
			},
			{
				sbp = SBP.SOVIET.PENAL_BATTALION,
				spawn = RandomSpawn,
				load = 5,
				sgroups = {sg_all_infantry},
			},
			{
				sbp = SBP.SOVIET.PENAL_BATTALION,
				spawn = RandomSpawn,
				load = 5,
				sgroups = {sg_all_infantry},
			},
		},
		onDeath = nil,
	}
	enc_wave4c = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		attackMove = true,
		target = mkr_base_space1,
		range = 50,
		leashRange = 15, 
	}
	enc_wave4c:SetGoal(goalData)
	Event_Timer(Remove_Attack_UI_02, nil, 20)
	Event_GroupLeftAlive(Final_wave_complete, nil, sg_all_vehicles, 0)
	Rule_AddInterval(Final_wave_infantry_loop, 5)
end	

function Final_wave_infantry_loop()

	if SGroup_TotalMembersCount(sg_all_infantry) <= 8 then
		print("!!!!!!!LOOPING INFANTRY!!!!!!!!")
		
		local t_randomspawn = {mkr_west_sp_01, mkr_west_sp_02, mkr_east_sp_01, mkr_east_sp_02}
		local t_randomspawn_02 = {mkr_south_sp_01, mkr_south_sp_02, mkr_west_sp_01, mkr_east_sp_01}
		local RandomSpawn = Table_GetRandomItem(t_randomspawn)
		local RandomSpawn2 = Table_GetRandomItem(t_randomspawn_02)
		
		Util_CreateSquads(player2, {sg_e_infantry, sg_all_infantry}, SBP.SOVIET.PENAL_BATTALION, RandomSpawn, nil, 1, 4, true, nil, UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP )
		Util_CreateSquads(player2, {sg_e_infantry, sg_all_infantry}, SBP.SOVIET.GUARDS_TROOPS, RandomSpawn, nil, 1, 4, true, nil, UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP )
		Util_CreateSquads(player2, {sg_e_infantry, sg_all_infantry}, SBP.SOVIET.GUARDS_TROOPS, RandomSpawn, nil, 1, 4, true, nil, UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP )
		Util_CreateSquads(player2, {sg_e_infantry, sg_all_infantry}, SBP.SOVIET.PENAL_BATTALION, RandomSpawn2, nil, 1, 4, true, nil, UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP )
		Util_CreateSquads(player2, {sg_e_infantry, sg_all_infantry}, SBP.SOVIET.GUARDS_TROOPS, RandomSpawn2, nil, 1, 4, true, nil, UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP )
		Util_CreateSquads(player2, {sg_e_infantry, sg_all_infantry}, SBP.SOVIET.GUARDS_TROOPS, RandomSpawn2, nil, 1, 4, true, nil, UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP )
		
		enc_wave4c:AddSgroup(sg_e_infantry)
		
		Rule_RemoveMe()
		Rule_AddDelayedInterval(Final_wave_infantry_loop, 25, 5)
	end
	
end

function Final_wave_complete()
	mission_complete = true
	Rule_AddOneShot(Main_Objective_Complete, 5)
	if SGroup_TotalMembersCount(sg_all_infantry) ~= 0 then
		enc_wave4c:ClearGoal()
		Modify_ReceivedDamage(sg_all_infantry, 3)
		Cmd_Retreat(sg_all_infantry)
	end
end

function Bonus_enc01()
	sg_bonus_enc_all = SGroup_CreateIfNotFound("sg_bonus_enc_all")
	local encData = {
		player = player2,
		sgroups = {sg_bonus_enc_all},
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_bonus_enc1_sp,
				load = 5,
			},
			{
				sbp = Util_DifVar( { SBP.SOVIET.BASE_CONSCRIPT_SQUAD, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD, } ),
				spawn = mkr_bonus_enc1_sp,
				load = 4,
			},
			{
				sbp = SBP.SOVIET.T_70M,
				spawn = mkr_bonus_enc1_sp_02,
				load = 1,
			},
		},
		onDeath = nil,
	}
	bonus_enc_01 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		attackMove = true,
		target = mkr_bonus1_space,
		range = 50,
		leashRange = 30, 
	}
	bonus_enc_01:SetGoal(goalData)
end	
function Bonus_enc02()
	local encData = {
		player = player2,
		sgroups = {sg_bonus_enc_all},
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_bonus_enc2_sp,
				load = 5,
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_bonus_enc2_sp_02,
				load = 5,
			},
			{
				sbp = Util_DifVar( { SBP.SOVIET.BASE_CONSCRIPT_SQUAD, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD, } ),
				spawn = mkr_bonus_enc2_sp,
				load = 4,
			},			
		},
		onDeath = nil,
	}
	bonus_enc_02 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		attackMove = true,
		target = mkr_bonus2_space,
		range = 50,
		leashRange = 30, 
	}
	bonus_enc_02:SetGoal(goalData)
end	


----------------------------------
-- Additional Encounter Functions
----------------------------------

function Main_Objective_Complete()
	Objective_Complete(OBJ_Gold)
end

-- Check for Breach

function Gate_Breached()
	if EGroup_Count(eg_gates) <= 8 then
		SetupBase01()
		SetupBase02()
		Rule_RemoveMe()
		IncrementCounter()
		Start_Day() -- Start day transition
		Util_StartIntel(EVENTS.Breached)
		Rule_Add(Check_For_Base_Capture)
	end
end

function Check_For_Base_Capture()
	if Player_OwnsEGroup(player1, eg_point1) == true then
		Setup_Phase2()
		Rule_RemoveMe()
	elseif SGroup_CountSpawned(sg_base_all) <= 2 then
		Setup_Phase2()
		Rule_RemoveMe()
	end
	
end

-- Check for Scout Car Capture and Start Encounter
function Check_ScoutCar()
	if Entity_IsValid(Scout_Carid) and Player_OwnsEntity(player1, Entity_FromWorldID(Scout_Carid)) then
		ScoutCar_Enc()
		Objective_RemoveUIElements(OBJ_Bonus_Car, obj_bonus_id_car)
		Rule_RemoveMe()
	elseif Entity_IsValid(Scout_Carid) == false  then 
		if Objective_IsStarted(OBJ_Bonus_Car) == true then
			Objective_Fail(OBJ_Bonus_Car)
			Objective_RemoveUIElements(OBJ_Bonus_Car, obj_bonus_id_car)
		end
		Rule_RemoveMe()
	end
end

-- Encounter 3 - Gate 3
function ScoutCar_Enc()
	Util_StartIntel(EVENTS.Bonus_Scoutcar)
	SGroup_IncreaseVeterancyRank(sg_scout, 3)
	Objective_Complete(OBJ_Bonus_Car)
	sg_enc03_all = SGroup_CreateIfNotFound("sg_enc03_all")

	local encData = {
		player = player2,
		sgroups = {sg_e_all},
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = scout_enc_spawn,
				load = 2,
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = scout_enc_spawn,
				load = 3,
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = scout_enc_spawn2,
				load = 3,
			},
		},
		onDeath = nil,
	}
	scout_enc_01 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = scout_enc_space,
		leash = 20, 
	}
	scout_enc_01:SetGoal(goalData)
end	

function Initial_Attack_Direction()
	if EGroup_Count(eg_west_barriers) <= 3 and EGroup_Count(eg_east_barriers) == 4 then
		initial_spawn = mkr_west_sp_01
		initial_spawn_02 = mkr_west_sp_02
		print("Initial Spawn from the west")
	elseif EGroup_Count(eg_east_barriers) <= 3 and EGroup_Count(eg_west_barriers) == 4 then
		initial_spawn = mkr_east_sp_01
		initial_spawn_02 = mkr_east_sp_02
		print("Initial Spawn from the east")
	elseif EGroup_Count(eg_east_barriers) == 4 and EGroup_Count(eg_west_barriers) == 4 then
		initial_spawn = mkr_south_sp_01
		initial_spawn_02 = mkr_south_sp_02	
		local t_randomspawn = {mkr_west_sp_01, mkr_east_sp_01}
		local t_randomspawn_02 = {mkr_west_sp_02, mkr_east_sp_02}
		secondary_spawn = Table_GetRandomItem(t_randomspawn)
		secondary_spawn_02 = Table_GetRandomItem(t_randomspawn_02)
		print("Initial Spawn from the south")
	elseif EGroup_Count(eg_east_barriers) <= 3 and EGroup_Count(eg_west_barriers) <= 3 then
		local t_randomspawn = {mkr_west_sp_01, mkr_east_sp_01}
		local t_randomspawn_02 = {mkr_west_sp_02, mkr_east_sp_02}
		initial_spawn = Table_GetRandomItem(t_randomspawn)
		initial_spawn_02 = Table_GetRandomItem(t_randomspawn_02)
		print("Random spawn direction")
	end
end

-- Remove Attack Direction UI
function Remove_Attack_UI_01()
	Objective_RemoveUIElements(OBJ_Gold, wave01_ui)
	Objective_RemoveUIElements(OBJ_Gold, wave01_ui_02)
end

function Remove_Attack_UI_02()
	Objective_RemoveUIElements(OBJ_Gold, wave02_ui)
	Objective_RemoveUIElements(OBJ_Gold, wave02_ui_02)
end

function Remove_Attack_UI_02b()
	Objective_RemoveUIElements(OBJ_Gold, wave02_ui)
	Objective_RemoveUIElements(OBJ_Gold, wave02b_ui)
end
function Remove_Attack_UI_03()
	Objective_RemoveUIElements(OBJ_Gold, wave03_ui)
	Objective_RemoveUIElements(OBJ_Gold, wave03b_ui)
end

function Remove_Attack_UI_04()
	Objective_RemoveUIElements(OBJ_Gold, wave04_ui)
	Objective_RemoveUIElements(OBJ_Gold, wave04b_ui)
	Objective_RemoveUIElements(OBJ_Gold, wave04c_ui)
end


-- Retreat Functions
function Enemy_Retreat()
	if SGroup_CountSpawned(sg_e_all) >= 1 then
		print("Enemy Retreating!!!!!!!!!!!!")
		Modify_ReceivedDamage(sg_e_all, 5)
		Cmd_AbandonTeamWeapon ( sg_e_all, false )
		Cmd_Retreat(sg_e_all, Util_GetPosition(mkr_south_sp_01), mkr_south_sp_01, true )
	end
end

function Enemy_Retreat_Base()
	if SGroup_CountSpawned(sg_base_all) >= 1 then
		print("Base Enemy Retreating!!!!!!!!!!!!")
		base_enc_01:ClearGoal()
		base_enc_02:ClearGoal()
		Modify_ReceivedDamage(sg_base_all, 5)
		Cmd_Retreat(sg_base_all, nil, mkr_west_sp_01)
	end
end
-------------------------------------
-- Weather Events
-------------------------------------

--Night to Day Transition
function Start_Day()
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_cnd_day_05.aps", 30)-- Blizzard Day Atmos
	Event_Timer(Start_Day_pt2, nil, 30)
end
function Start_Day_pt2()
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_cnd_day_04.aps", 30)-- Blizzard Day Atmos
	Event_Timer(Start_Day_pt3, nil, 30)
end
function Start_Day_pt3()
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_cnd_day_03.aps", 30)-- Blizzard Day Atmos
	Event_Timer(Start_Day_pt4, nil, 30)
end
function Start_Day_pt4()
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_cnd_day_02.aps", 30)-- Blizzard Day Atmos
end


-- Day to Night transition with blizzards
function Start_Night()
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_cnd_day_blizzard.aps", 15)-- Blizzard Day Atmos
	Event_Timer(Start_Night_pt2, nil, 60)
end
function Start_Night_pt2()
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_cnd_day_02.aps", 30)-- Blizzard Day Atmos
	Event_Timer(Start_Night_pt3, nil, 60)
end
function Start_Night_pt3()
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_cnd_day_03.aps", 30)-- Blizzard Day Atmos
	Event_Timer(Start_Night_pt4, nil, 30)
end
function Start_Night_pt4()
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_cnd_day_04.aps", 30)-- Blizzard Day Atmos
	Event_Timer(Start_Night_pt5, nil, 30)
end
function Start_Night_pt5()
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_cnd_day_05.aps", 30)-- Blizzard Day Atmos
	Event_Timer(Start_Night_pt6, nil, 30)
end
function Start_Night_pt6()
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_cnd_night_01.aps", 30)-- Blizzard Day Atmos
	Event_Timer(Start_Night_pt7, nil, 120)
end
function Start_Night_pt7()
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_cnd_night_blizzard.aps", 30)-- Blizzard Day Atmos
	Event_Timer(Start_Night_pt8, nil, 90)
end
function Start_Night_pt8()
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_cnd_night_01.aps", 30)-- Blizzard Day Atmos
end
