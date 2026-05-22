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
	t_encounters = {}-- Enemy Encounter Table
	t_bonus_enc = {} -- Bonus Objective Encounters
	
	t_bonus_spawn_01 = {mkr_sp_bonus1_01, mkr_sp_bonus1_02, mkr_sp_bonus1_03, mkr_sp_bonus1_04, mkr_sp_bonus1_05} -- Random Bonus Spawn Points
	t_bonus_spawn_02 = {mkr_sp_bonus2_01, mkr_sp_bonus2_02, mkr_sp_bonus2_03, mkr_sp_bonus2_04} -- Random Bonus Spawn Points
	t_bonus_spawn_03 = {mkr_sp_bonus3_01, mkr_sp_bonus3_02, mkr_sp_bonus3_03, mkr_sp_bonus3_04, mkr_sp_bonus3_05, mkr_sp_bonus3_06} -- Random Bonus Spawn Points
	
	t_exterior_spawns_01 = {mkr_ext_sp_01, mkr_ext_sp_02, mkr_ext_sp_03} -- Random Exterior Spawn Points
	t_exterior_spawns_02 = {mkr_ext_sp_04, mkr_ext_sp_05} -- Random Exterior Spawn Points
	t_exterior_spawns_03 = {mkr_ext_sp_02, mkr_ext_sp_03} -- Random Exterior Spawn Points
	t_exterior_spawns_04 = {mkr_ext_sp_02, mkr_ext_sp_03, mkr_ext_sp_04, mkr_ext_sp_05} -- Random Exterior Spawn Points
	t_retreat_points = {mkr_retreat_01, mkr_retreat_02, mkr_retreat_03, mkr_retreat_04, mkr_retreat_05 } -- Retreat Points

	-- Variables
	sg_bonus = SGroup_CreateIfNotFound("sg_bonus") -- bonus encounter group
	sg_abandoned = SGroup_CreateIfNotFound("sg_abandoned") -- abandoned vehicle group
	sg_ally_all = SGroup_CreateIfNotFound("sg_ally_all") -- Ally group
	sg_button_enc = SGroup_CreateIfNotFound("sg_button_enc") -- Button Ability group
	
	enemy_target = sg_Tiger -- target for enemy, set to initially be the player squad until death
	Rule_AddInterval(Change_Target, 0.5)
	
	random_enc = World_GetRand(1, 2) -- used for determining which tank encounter will spawn in the mission
	
	-- Start Encounters
	SetupArea01()
	SetupArea01b()
	SetupArea02()
	SetupArea03()
	SetupArea03b()
	SetupArea04()
	SetupArea04_ATGuns_01()
	SetupArea04_ATGuns_02()
	SetupArea05()
	SetupArea05b()
	SetupArea06()
	SetupArea07()
	
	-- random encounter setup
	if random_enc == 1 then
		SetupArea06b()
		Event_Proximity(Area06b_Goal, nil, sg_Tiger, sg_enc06_tank, 45, ANY)
	elseif random_enc == 2 then
		SetupArea07b()
		Event_Proximity(Area07b_Goal, nil, sg_Tiger, sg_enc07_tank, 45, ANY)
	end

	-- Events to enable goals once the player is near the encounters
	Event_Proximity(Area05b_Goal, nil, sg_Tiger, sg_enc05_tank, 40, ANY)
	Event_Proximity(Area06_Goal, nil, sg_Tiger, mkr_enc6_trig, 70, ANY)
	Event_Proximity(Area07_Goal, nil, sg_Tiger, mkr_enc7_trig, 70, ANY)
	
	--Setup Bonus Objective Encounters
	Rule_AddInterval(Bonus_OBJ_Check, 1, 1000)

	Bonus_Enc01()
	Bonus_Enc02()
	Bonus_Enc03()
end

-- function for changing enemy target should the player die
function Change_Target()
	if SGroup_Count(sg_Tiger) == 0 then
		enemy_target = Util_GetPosition(mkr_enc4_space)
		Rule_RemoveMe()
	end
end



-- Encounter 1 - Fields - Part 1
function SetupArea01()

	-- random spawn locations
	local random_spawn_01 = {mkr_enc1_sp_03, mkr_enc1_sp_05}
	local random_spawn_02 = {mkr_enc1_sp_01, mkr_enc1_sp_04, mkr_enc1_sp_08}
	
	sg_enc01_all = SGroup_CreateIfNotFound("sg_enc01_all")
	sg_enc01_infantry = SGroup_CreateIfNotFound("sg_enc01_infantry")
	
	Event_GroupLeftAlive(AllySetupArea01, nil, sg_enc01_all, 6 ) -- Spawn allies to aid player once enemy numbers have been reduced
	Event_GroupLeftAlive(Area_01_Retreat, nil, sg_enc01_infantry, 5 ) -- Area Cleared
	Event_GroupLeftAlive(Area01_Cleared, nil, sg_enc01_all, 5 ) -- Area Cleared
	local encData = {
		player = player2,
		sgroups = {sg_enc01_all},
		units = {
			{
				sbp = t_difficulty.enemy_difficulty_type.unit_at,
				spawn = mkr_enc1_sp_02,
				load = 4,
				veterancyRank = Util_DifVar({0, 0, 2}),
				sgroups = {sg_enc01_infantry},
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = Table_GetRandomItem(random_spawn_02),
				load = 4,
				sgroups = {sg_enc01_infantry},
			},
			{
				sbp = t_difficulty.enemy_difficulty_type.unit,
				spawn = Table_GetRandomItem(random_spawn_01),
				load = 4,
				sgroups = {sg_enc01_infantry},
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = mkr_enc1_sp_02,
				load = 3,
				sgroups = {sg_enc01_infantry},
			},

		},
		onDeath = nil,
	}
	enc_01 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_enc1_space,
		range = 55,
		leashRange = 30, 
		tacticControlsList = {
			{
				tacticType = TACTIC_Ability,
				priority = 600,
			},
			{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = 100,
			},
		},
	}
	enc_01:SetGoal(goalData)
end	
function SetupArea01b()
	local random_spawn_01 = {mkr_enc1_sp_06, mkr_enc1_sp_07}
	sg_enc01_car = SGroup_CreateIfNotFound("sg_enc01_car")
	local encData = {
		player = player2,
		sgroups = {sg_enc01_all},
		units = {
			{
				sbp = SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD,
				spawn = Table_GetRandomItem(random_spawn_01),
				load = 1,
				sgroups = {sg_enc01_infantry, sg_enc01_car},
			},

		},
		onDeath = nil,
	}
	enc_01b = Encounter:Create(encData)

	local goalData = {
		name = "Attack",
		target = mkr_enc1b_space,
		range = 40,
		leashRange = 35,
		tacticControlsList = {
			{
				tacticType = TACTIC_Vehicle,
				priority = 1000,
			},
		},
	}
	enc_01b:SetGoal(goalData)
	SGroup_SetAvgHealth(sg_enc01_car, 0.4)
end


function Area_01_Retreat()
	if SGroup_TotalMembersCount(sg_enc01_infantry) >= 1 then
		Cmd_AbandonTeamWeapon ( sg_enc01_infantry, false )
		Cmd_Retreat(sg_enc01_infantry, mkr_retreat_05, mkr_retreat_05, true)
	end
end

-- Encounter 2 - Downed Tank
function SetupArea02()
	-- random spawn locations
	local random_spawn_01 = {mkr_enc2_sp_03, mkr_enc2_sp_04}
	local tank_spawn = {mkr_enc2_tank_01, mkr_enc2_tank_02}
	
	sg_enc02_all = SGroup_CreateIfNotFound("sg_enc02_all")
	sg_enc02_infantry = SGroup_CreateIfNotFound("sg_enc02_infantry")
	sg_enc02_tank = SGroup_CreateIfNotFound("sg_enc02_tank")

	Event_GroupLeftAlive(AllySetupArea02, nil, sg_enc02_tank, 0 )
	Event_GroupLeftAlive(Area02_Cleared, nil, sg_enc02_tank, 0 ) -- Area Cleared
	local encData = {
		player = player2,
		sgroups = {sg_enc02_all},
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_enc2_sp_01,
				load = 3,
				sgroups = {sg_enc02_infantry},
				veterancyRank = Util_DifVar({0, 0, 2}),
				upgrades = {UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP},
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = mkr_enc2_sp_02,
				load = 4,
				sgroups = {sg_enc02_infantry},
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = Table_GetRandomItem(random_spawn_01),
				load = 3,
				sgroups = {sg_enc02_infantry, sg_button_enc},
				upgrades = {UPG.SOVIET.GUARD_DP_28_LMG_PACKAGE},
			},
			{
				sbp = SBP.SOVIET.KV_2_TOW,
				spawn = Table_GetRandomItem(tank_spawn),
				load = 1,
				sgroups = {sg_enc02_tank},
			},
		},
		onDeath = nil,
	}
	enc_02 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_enc2_space,
		leashRange = 35,
		range = 60,
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 1000,
			},
		},
	}
	enc_02:SetGoal(goalData)
	Cmd_CriticalHit (player2, sg_enc02_tank, CRIT.VEHICLE_LOSE_TREADS_OR_WHEELS, 1)
	SGroup_SetAvgHealth(sg_enc02_tank, t_difficulty.downed_tank_health)
	Modify_Armor(sg_enc02_tank, 0.5)
	Event_Timer(Area_02_Retreat_Check, nil, 3) -- Start Retreat Event
	SGroup_AddAbility(sg_button_enc, ABILITY.SOVIET.BUTTON_VEHICLE_TOW)
	

end	
function Area_02_Retreat_Check()
	Rule_AddInterval(Area_02_Retreat, 2, 100)
end
function Area_02_Retreat() -- Units retreat if they fall in number or their tank gets destroyed
	if SGroup_TotalMembersCount(sg_enc02_infantry) <= 3 or SGroup_Count(sg_enc02_tank) == 0 then
		enc_02:ClearGoal()
		Cmd_Retreat(sg_enc02_infantry, mkr_retreat_01, mkr_retreat_01)
		Rule_RemoveMe()
	else
	end
end

-- Encounter 3 - Fields - Part 2
function SetupArea03()

	-- random spawn locations
	local random_spawn_01 = {mkr_enc3_sp_04, mkr_enc3_sp_07}
	local random_spawn_02 = {mkr_enc3_sp_03, mkr_enc3_sp_05, mkr_enc3_sp_06}
	local random_spawn_03 = {mkr_enc3_sp_01, mkr_enc3_sp_02}
	local random_spawn_04 = {mkr_enc3_sp_08, mkr_enc3_sp_09}
	sg_enc03_all = SGroup_CreateIfNotFound("sg_enc03_all")
	sg_enc03_infantry = SGroup_CreateIfNotFound("sg_enc03_infantry")
	
	Event_GroupLeftAlive(AllySetupArea03, nil, sg_enc03_all, 6 )
	Event_GroupLeftAlive(Area_03_Retreat, nil, sg_enc03_infantry, 5 ) -- Area Cleared
	Event_GroupLeftAlive(Area03_Cleared, nil, sg_enc03_all, 5 ) -- Area Cleared
	
	local encData = {
		player = player2,
		sgroups = {sg_enc03_all},
		units = {

			{
				sbp = t_difficulty.enemy_difficulty_type.unit_at,
				spawn = Table_GetRandomItem(random_spawn_01),
				load = 4,
				veterancyRank = Util_DifVar({0, 0, 2}),
				sgroups = {sg_enc03_infantry},
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = Table_GetRandomItem(random_spawn_03),
				load = 4,
				sgroups = {sg_enc03_infantry},
			},
			{
				sbp = t_difficulty.enemy_difficulty_type.unit,
				spawn = Table_GetRandomItem(random_spawn_02),
				load = 4,
				sgroups = {sg_enc03_infantry},
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = Table_GetRandomItem(random_spawn_03),
				load = 4,
				sgroups = {sg_enc03_infantry},
			},
		},
		onDeath = nil,
	}
	enc_03 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_enc3_space,
		range = 50,
		leashRange = 25,
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Ability,
				priority = 500,
			},
			{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = 300,
			},
		},
	}
	enc_03:SetGoal(goalData)
end	

function SetupArea03b()
	
	local random_spawn_01 = {mkr_enc3_sp_08, mkr_enc3_sp_09}
	sg_enc03_car = SGroup_CreateIfNotFound("sg_enc03_car")
	local encData = {
		player = player2,
		sgroups = {sg_enc03_all},
		units = {
			{
				sbp = SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD,
				spawn = Table_GetRandomItem(random_spawn_01),
				load = 1,
				sgroups = {sg_enc03_infantry, sg_enc03_car},
			},
		},
		onDeath = nil,
	}
	enc_03b = Encounter:Create(encData)

	local goalData = {
		name = "Defend",
		target = mkr_enc3_space,
		range = 50,
		leashRange = 30,
	}
	enc_03b:SetGoal(goalData)
	SGroup_SetAvgHealth(sg_enc03_car, 0.4)
end

function Area_03_Retreat()
	if SGroup_TotalMembersCount(sg_enc03_infantry) >= 1 then
		enc_03:ClearGoal()
		Cmd_AbandonTeamWeapon ( sg_enc03_infantry, false )
		Cmd_Retreat(sg_enc03_infantry, mkr_retreat_04, mkr_retreat_04, true)
	end
end
-- Encounter 4 - Village
function SetupArea04()
	sg_enc04_all = SGroup_CreateIfNotFound("sg_enc04_all")
	sg_enc04_infantry = SGroup_CreateIfNotFound("sg_enc04_infantry")
	
	-- random spawn locations
	local random_spawn_01 = {mkr_enc4_sp_01, mkr_enc4_sp_06}
	local random_spawn_02 = {mkr_enc4_sp_04, mkr_enc4_sp_05}
	local random_spawn_03 = {mkr_enc4_sp_02, mkr_enc4_sp_05}
	Event_GroupLeftAlive(AllySetupArea04, nil, sg_enc04_all, 5 )
	Event_GroupLeftAlive(Area_04_Retreat, nil, sg_enc04_all, 4 )
	Event_GroupLeftAlive(Area04_Cleared, nil, sg_enc04_all, 4 ) -- Area Cleared
	local encData = {
		player = player2,
		sgroups = {sg_enc04_all},
		units = {
			
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_enc4_sp_AT_01,
				load = 4,
				sgroups = {sg_enc04_infantry},
				veterancyRank = Util_DifVar({0, 2, 2}),
				upgrades = {UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP},
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_enc4_sp_AT_02,
				load = 4,
				sgroups = {sg_enc04_infantry},
				veterancyRank = Util_DifVar({0, 2, 2}),
				upgrades = {UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP},
			},
			{
				sbp = t_difficulty.enemy_difficulty_type.unit_at,
				spawn = Table_GetRandomItem(random_spawn_01),
				load = 5,
				veterancyRank = Util_DifVar({0, 0, 2}),
				sgroups = {sg_enc04_infantry},
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = Table_GetRandomItem(random_spawn_02),
				load = 3,
				sgroups = {sg_enc04_infantry},
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = Table_GetRandomItem(random_spawn_03),
				load = 3,
				sgroups = {sg_enc04_infantry},
			},
		},
		onDeath = nil,
	}
	enc_04 = Encounter:Create(encData)

	local goalData = {
		name = "Defend",
		target = mkr_enc4_space,
		range = 60,
		leashRange = 35,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 200,
			},
			{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = 800,
			},
		},
	}
	enc_04:SetGoal(goalData)
end	
function Area_04_Retreat() 
	if SGroup_TotalMembersCount(sg_enc04_infantry) >= 1 then
		enc_04:ClearGoal()
		Cmd_AbandonTeamWeapon ( sg_enc04_infantry, false )
		Cmd_Retreat(sg_enc04_infantry, mkr_retreat_03, mkr_retreat_03, true)
		Area_04_AT_01_Retreat()
		Area_04_AT_02_Retreat()
	end
end
-- Encounter 4 - Village AT Gun 01
function SetupArea04_ATGuns_01()

	sg_enc04_AT_01 = SGroup_CreateIfNotFound("sg_enc04_AT_01")
	Event_GroupLeftAlive(Area_04_AT_01_Retreat, nil, sg_enc04_AT_01, 3 )
	local encData = {
		player = player2,
		sgroups = {sg_enc04_AT_01, sg_button_enc},
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_enc4_sp_AT_01,
				load = 2,
				upgrades = {UPG.SOVIET.GUARD_DP_28_LMG_PACKAGE},
			},
			{
				sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD,
				spawn = mkr_enc4_sp_AT_01,
				load = 5,
			},
		},
		onDeath = nil,
	}
	enc_04_AT_01 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_enc4_AT_01,
		range = 40,
		leashRange = 5,
		tacticControlsList = {
			{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = 1000,
			},
		},
	}
	enc_04_AT_01:SetGoal(goalData)
	SGroup_AddAbility(sg_button_enc, ABILITY.SOVIET.BUTTON_VEHICLE_TOW)
end


-- Encounter 4 - Village AT Gun 02
function SetupArea04_ATGuns_02()

	sg_enc04_AT_02 = SGroup_CreateIfNotFound("sg_enc04_AT_02")
	Event_GroupLeftAlive(Area_04_AT_02_Retreat, nil, sg_enc04_AT_02, 3 )
	local encData = {
		player = player2,
		sgroups = {sg_enc04_AT_02, sg_button_enc},
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_enc4_sp_AT_02,
				load = 2,
				upgrades = {UPG.SOVIET.GUARD_DP_28_LMG_PACKAGE},
			},
			{
				sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD,
				spawn = mkr_enc4_sp_AT_02,
				load = 5,
			},
		},
		onDeath = nil,
	}
	enc_04_AT_02 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_enc4_AT_02,
		range = 40,
		leashRange = 5,
		tacticControlsList = {
			{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = 1000,
			},
		},
	}
	enc_04_AT_02:SetGoal(goalData)
	SGroup_AddAbility(sg_button_enc, ABILITY.SOVIET.BUTTON_VEHICLE_TOW)
end	

function Area_04_AT_01_Retreat()
	-- Remaining Units Retreat
	if SGroup_Count(sg_enc04_AT_01) >= 1 then
		enc_04_AT_01:ClearGoal()
		Cmd_AbandonTeamWeapon ( sg_enc04_AT_01, false )
		Cmd_Retreat(sg_enc04_AT_01, mkr_retreat_01, mkr_retreat_01, true)
	end
end
function Area_04_AT_02_Retreat()
	-- Remaining Units Retreat
	if SGroup_Count(sg_enc04_AT_02) >= 1 then
		enc_04_AT_02:ClearGoal()
		Cmd_AbandonTeamWeapon ( sg_enc04_AT_02, false )
		Cmd_Retreat(sg_enc04_AT_02, mkr_retreat_02, mkr_retreat_02, true)
	end
end


-- Encounter 5 - RailYard
function SetupArea05()

	sg_enc05_all = SGroup_CreateIfNotFound("sg_enc05_all")
	sg_enc05_infantry = SGroup_CreateIfNotFound("sg_enc05_infantry")
	local random_spawn_01 = {mkr_enc5_tank_03, mkr_enc5_tank_04}
	Rule_AddInterval(Area_05_Retreat, 2, 100 )
	local encData = {
		player = player2,
		sgroups = {sg_enc05_all},
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_enc5_sp_01,
				load = 3,
				sgroups = {sg_enc05_infantry, sg_button_enc},
				upgrades = {UPG.SOVIET.GUARD_DP_28_LMG_PACKAGE},
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_enc5_sp_02,
				load = 3,
				sgroups = {sg_enc05_infantry},
				veterancyRank = Util_DifVar({0, 2, 2}),
				upgrades = {UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP},
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = mkr_enc5_sp_03,
				load = 4,
				sgroups = {sg_enc05_infantry},
			},
			{
				sbp = SBP.SOVIET.M5_HALFTRACK_SQUAD,
				spawn = Table_GetRandomItem(random_spawn_01),
				load = 1,
				sgroups = {sg_enc05_infantry},
			},
		},
		onDeath = nil,
	}
	enc_05 = Encounter:Create(encData)
	local goalData = {
		name = "Defend",
		target = mkr_enc5_space,
		range = 60,
		leashRange = 35,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 1000,
			},
		},
	}
	enc_05:SetGoal(goalData)
	SGroup_AddAbility(sg_button_enc, ABILITY.SOVIET.BUTTON_VEHICLE_TOW)
end	
function Area_05_Retreat()
	-- Remaining Units Retreat
	if SGroup_TotalMembersCount(sg_enc05_infantry) <= 4 or SGroup_Count(sg_enc05_tank) == 0 then
		Cmd_AbandonTeamWeapon ( sg_enc05_infantry, false )
		Cmd_Retreat(sg_enc05_infantry, mkr_retreat_03, mkr_retreat_03, true)
		Rule_RemoveMe()
	end
end

-- Encounter 5b - RailYard KV 1
function SetupArea05b()
	
	sg_enc05_all = SGroup_CreateIfNotFound("sg_enc05_all")
	sg_enc05_tank = SGroup_CreateIfNotFound("sg_enc05_tank")
	Event_GroupLeftAlive(AllySetupArea05, nil, sg_enc05_tank, 0 ) -- Allies 
	Event_GroupLeftAlive(Area05_Cleared, nil, sg_enc05_tank, 0 ) -- Area Cleared
	local random_spawn_01 = {mkr_enc5_tank_01, mkr_enc5_tank_02}
	local encData = {
		player = player2,
		sgroups = {sg_enc05_all},
		units = {
			{
				sbp = SBP.SOVIET.T_34_76_SQUAD,
				spawn = Table_GetRandomItem(random_spawn_01),
				load = 1,
				sgroups = {sg_enc05_tank},
			},
		},
		onDeath = nil,
	}
	enc_05b = Encounter:Create(encData)
end	

function Area05b_Goal() 
	local goalData = {
		name = "Attack",
		target = mkr_enc5_space,
		range = 60,
		leashRange = 30,
	}
	enc_05b:SetGoal(goalData)
end


-- Encounter 6 - North Road Artillery
function SetupArea06()

	sg_enc06_all = SGroup_CreateIfNotFound("sg_enc06_all")
	sg_enc06_infantry = SGroup_CreateIfNotFound("sg_enc06_infantry")
	sg_enc06_mortar = SGroup_CreateIfNotFound("sg_enc06_mortar")
	
	Event_GroupLeftAlive(AllySetupArea06, nil, sg_enc06_all, 6 )
	Event_GroupLeftAlive(Area06_Cleared, nil, sg_enc06_all, World_GetRand(4, 5) ) -- Area Cleared	
	
	local encData = {
		player = player2,
		sgroups = {sg_enc06_all},
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_enc6_sp_01,
				load = 3,
				sgroups = {sg_enc06_infantry},
				veterancyRank = Util_DifVar({0, 2, 2}),
				upgrades = {UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP},
			},
			{
				sbp = SBP.SOVIET.HM_120_38_MORTAR_SQUAD,
				spawn = mkr_enc6_sp_02,
				load = 4,
				veterancyRank = Util_DifVar({0, 2, 3}),
				sgroups = {sg_enc06_mortar},
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = mkr_enc6_sp_05,
				load = 4,
				sgroups = {sg_enc06_infantry},
			},
			{
				sbp = SBP.SOVIET.HM_120_38_MORTAR_SQUAD,
				spawn = mkr_enc6_sp_03,
				load = 4,
				veterancyRank = Util_DifVar({0, 2, 3}),
				sgroups = {sg_enc06_mortar},
			},
			{
				sbp = t_difficulty.enemy_difficulty_type.unit,
				spawn = mkr_enc6_sp_04,
				load = 4,
				veterancyRank = Util_DifVar({0, 0, 2}),
				sgroups = {sg_enc06_infantry},
			},
		},
		onDeath = nil,
	}
	enc_06 = Encounter:Create(encData)
	SGroup_SetAutoTargetting(sg_enc06_mortar, "hardpoint_01", false) -- Disable mortars until player activates encounter
end	
function Area06_Goal() 
	SGroup_SetAutoTargetting(sg_enc06_mortar, "hardpoint_01", true) -- Enable mortars
	local goalData = {
		name = "Defend",
		target = mkr_enc6_space,
		range = 65,
		leashRange = 45,
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 500,
			},
			{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = 500,
			},
		},
	}
	enc_06:SetGoal(goalData)
end

-- Encounter 6b - North Road  Tank
function SetupArea06b()
	sg_enc06_tank = SGroup_CreateIfNotFound("sg_enc06_tank")
	
	local random_spawn_01 = {mkr_enc6_tank_01, mkr_enc6_tank_02}
	
	local encData = {
		player = player2,
		sgroups = {sg_enc06_tank},
		units = {
			{
				sbp = SBP.SOVIET.T_34_76_SQUAD,
				spawn = Table_GetRandomItem(random_spawn_01),
				load = 1,
				sgroups = {sg_enc06_tank},
			},
		},
		onDeath = nil,
	}
	enc_06b = Encounter:Create(encData)
end	

function Area06b_Goal() 
	local goalData = {
		name = "Attack",
		target = mkr_enc6_space,
		range = 50,
		leashRange = 30,
		tacticControlsList = {
			{
				tacticType = TACTIC_Vehicle,
				priority = 1000,
			},
		},
	}
	enc_06b:SetGoal(goalData)
end

-- Encounter 7 - South Road Artillery
function SetupArea07()
	
	sg_enc07_all = SGroup_CreateIfNotFound("sg_enc07_all")
	sg_enc07_infantry = SGroup_CreateIfNotFound("sg_enc07_infantry")
	sg_enc07_mortar = SGroup_CreateIfNotFound("sg_enc07_mortar")
	
	Event_GroupLeftAlive(AllySetupArea07, nil, sg_enc07_all, 6 )
	Event_GroupLeftAlive(Area07_Cleared, nil, sg_enc07_all, World_GetRand(4, 5) ) -- Area Cleared	
	local encData = {
		player = player2,
		sgroups = {sg_enc07_all},
		units = {
			{
				sbp = t_difficulty.enemy_difficulty_type.unit,
				spawn = mkr_enc7_sp_01,
				load = 4,
				veterancyRank = Util_DifVar({0, 0, 2}),
				sgroups = {sg_enc07_all},
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = mkr_enc7_sp_05,
				load = 4,
				sgroups = {sg_enc07_all},
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_enc7_sp_03,
				load = 3,
				sgroups = {sg_enc07_all},
				veterancyRank = Util_DifVar({0, 2, 2}),
				upgrades = {UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP},
			},
			{
				sbp = SBP.SOVIET.HM_120_38_MORTAR_SQUAD,
				spawn = mkr_enc7_sp_02,
				load = 4,
				veterancyRank = Util_DifVar({0, 2, 3}),
				sgroups = {sg_enc07_mortar},
			},
			{
				sbp = SBP.SOVIET.HM_120_38_MORTAR_SQUAD,
				spawn = mkr_enc7_sp_04,
				load = 4,
				veterancyRank = Util_DifVar({0, 2, 3}),
				sgroups = {sg_enc07_mortar},
			},
		},
		onDeath = nil,
	}
	enc_07 = Encounter:Create(encData)
	SGroup_SetAutoTargetting(sg_enc07_mortar, "hardpoint_01", false) -- Disable mortars until player activates encounter
end	

function Area07_Goal()
	SGroup_SetAutoTargetting(sg_enc07_mortar, "hardpoint_01", true ) -- Enable Mortars
	local goalData = {
		name = "Defend",
		target = mkr_enc7_space,
		range = 65,
		leashRange = 45,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 500,
			},
			{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = 500,
			},
		},
	}
	enc_07:SetGoal(goalData)
end
-- Encounter 7 - South Road Tank
function SetupArea07b()
	sg_enc07_tank = SGroup_CreateIfNotFound("sg_enc07_tank")
		
	local encData = {
		player = player2,
		sgroups = {sg_enc07_tank},
		units = {

			{
				sbp = SBP.SOVIET.T_34_76_SQUAD,
				spawn = mkr_enc7_tank_01,
				load = 1,
				sgroups = {sg_enc07_tank},
			},
		},
		onDeath = nil,
	}
	enc_07b = Encounter:Create(encData)

	
end	

function Area07b_Goal() 
	local goalData = {
		name = "Attack",
		target = mkr_enc7_space,
		range = 50,
		leashRange = 30,
		tacticControlsList = {
			{
				tacticType = TACTIC_Vehicle,
				priority = 1000,
			},
		},
	}
	enc_07b:SetGoal(goalData)
end

----------------------------------
-- Retaliation Encounters -- 
----------------------------------
function SetupRet01()
	sg_ret01_tank = SGroup_CreateIfNotFound("sg_ret01_tank")
	sg_ret_all = SGroup_CreateIfNotFound("sg_ret_all")
	Util_StartIntel(EVENTS.OBJRetal_01) -- Update for incoming attack
	local spawnlocations_01 = {mkr_ext_sp_04, mkr_ext_sp_05} -- make one for each enc
	
	local encData = {
		player = player2,
		sgroups = {sg_ret01_tank},
		units = {

			{
				sbp = SBP.SOVIET.T_34_76_SQUAD,
				spawn = Table_GetRandomItem(spawnlocations_01),
				load = 1,
				sgroups = {sg_ret_all},
			},
			{
				sbp = SBP.SOVIET.T_34_76_SQUAD,
				spawn = Table_GetRandomItem(spawnlocations_01),
				load = 1,
				sgroups = {sg_ret_all},
			},
		},
		onDeath = nil,
	}
	enc_ret01 = Encounter:Create(encData)

	local goalData = {
		name = "Attack",
		target = enemy_target,
		range = 65,
		leashRange = 30,
		coordinatedMoveRadius = 20,
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		tacticControlsList = {
			{
				tacticType = TACTIC_Vehicle,
				priority = 1000,
			},
		},
		
	}
	enc_ret01:SetGoal(goalData)
	SGroup_SetAvgHealth(sg_ret01_tank, t_difficulty.enemy_tank_health)
end	


function SetupRet02()
	sg_ret02_tank = SGroup_CreateIfNotFound("sg_ret02_tank")
	Util_StartIntel(EVENTS.OBJRetal_02) -- Update for incoming attack
	
	local spawnlocations_01 = {mkr_ext_sp_02, mkr_ext_sp_03}
	local spawnlocations_02 = {mkr_ext_sp_04, mkr_ext_sp_05}
	local spawnlocations_03 = {mkr_ext_sp_02, mkr_ext_sp_03, mkr_ext_sp_04, mkr_ext_sp_05}
	local encData = {
		player = player2,
		sgroups = {sg_ret02_tank},
		units = {

			{
				sbp = SBP.SOVIET.KV_1,
				spawn = Table_GetRandomItem(spawnlocations_01),
				load = 1,
				sgroups = {sg_ret_all},
			},
			{
				sbp = SBP.SOVIET.KV_1,
				spawn = Table_GetRandomItem(spawnlocations_02),
				load = 1,
				sgroups = {sg_ret_all},
			},
			{
				sbp = SBP.SOVIET.T_34_76_SQUAD,
				spawn = Table_GetRandomItem(spawnlocations_03),
				load = 1,
				sgroups = {sg_ret_all},
			},
			
		},
		onDeath = nil,
	}
	enc_ret02 = Encounter:Create(encData)

	local goalData = {
		name = "Attack",
		target = enemy_target,
		range = 65,
		leashRange = 30,
		coordinatedMoveRadius = 20,
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		tacticControlsList = {
			{
				tacticType = TACTIC_Vehicle,
				priority = 1000,
			},
		},
	}
	enc_ret02:SetGoal(goalData)
	SGroup_SetAvgHealth(sg_ret02_tank, t_difficulty.enemy_tank_health)
end	

function ret_Enc_Retreat()
	-- Remaining Units Retreat
	if SGroup_TotalMembersCount(sg_ret01_tank) >= 1 then
		Cmd_AbandonTeamWeapon ( sg_ret01_tank, false )
		Cmd_Retreat(sg_ret01_tank, Util_GetClosestMarker( sg_ret01_tank, t_retreat_points ), Util_GetClosestMarker( sg_ret01_tank, t_retreat_points ))
	end
	if SGroup_TotalMembersCount(sg_ret02_tank) >= 1 then
		Cmd_AbandonTeamWeapon ( sg_ret02_tank, false )
		Cmd_Retreat(sg_ret02_tank, Util_GetClosestMarker( sg_ret02_tank, t_retreat_points ), Util_GetClosestMarker( sg_ret02_tank, t_retreat_points ))
	end
end	


-- Start Final Wave of Encounters once initial objective is complete.
function Start_Final_Encounters()
	Setup_Final_Enc01()
	Event_Timer(Setup_Final_Inf01, nil, 25)
end

function Setup_Final_Enc01()

	Cmd_Ability(player2, ABILITY.SOVIET.IL_2_RECON_SINGLEPASS_SP, enemy_target, Marker_GetDirection(mkr_flyby_dir), true) 
	sg_final_tank = SGroup_CreateIfNotFound("sg_final_tank")
	sg_final_tank_01 = SGroup_CreateIfNotFound("sg_final_tank_01")
	sg_final_enc = SGroup_CreateIfNotFound("sg_final_enc")
	local spawnlocations_01 = Table_GetRandomItem(t_exterior_spawns_01)
	local spawnlocations_02 = {mkr_ext_sp_04, mkr_ext_sp_05}
	local spawnlocations_03 = {mkr_ext_sp_02, mkr_ext_sp_03, mkr_ext_sp_04, mkr_ext_sp_05}
	
	local encData = {
		player = player2,
		sgroups = {sg_final_tank},
		units = {

			{
				sbp = SBP.SOVIET.T_34_76_SQUAD,
				spawn = spawnlocations_01,
				load = 1,
				sgroups = {sg_final_tank_01},
				onDeath = IncrementCounter_Tank,
			},
			{
				sbp = SBP.SOVIET.T_34_76_SQUAD,
				spawn = mkr_ext_sp_01b,
				load = 1,
				sgroups = {sg_final_tank_01},
				onDeath = IncrementCounter_Tank,
			},
			{
				sbp = SBP.SOVIET.M5_HALFTRACK_SQUAD,
				spawn = spawnlocations_01,
				load = 1,
				sgroups = {sg_final_enc},
			},
		},
		onDeath = nil,
	}
	enc_final01 = Encounter:Create(encData)

	local goalData = {
		name = "Attack",
		target = enemy_target,
		range = 60,
		leashRange = 40,
		coordinatedMoveRadius = 20,
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		tacticControlsList = {
			{
				tacticType = TACTIC_Vehicle,
				priority = 1000,
			},
		},
	}
	enc_final01:SetGoal(goalData)
	SGroup_SetAvgHealth(sg_final_tank_01, t_difficulty.enemy_tank_health)
end	

function Setup_Final_Enc02()
	sg_final_tank_02 = SGroup_CreateIfNotFound("sg_final_tank_02")
	local spawnlocations_01 = {mkr_ext_sp_02, mkr_ext_sp_03}
	local spawnlocations_02 = {mkr_ext_sp_04, mkr_ext_sp_05}
	local spawnlocations_03 = {mkr_ext_sp_01, mkr_ext_sp_02, mkr_ext_sp_03, mkr_ext_sp_05}
	
	local encData = {
		player = player2,
		sgroups = {sg_final_tank},
		units = {
			{
				sbp = SBP.SOVIET.KV_2_TOW,
				spawn = spawnlocations_01,
				load = 1,
				sgroups = {sg_final_tank_02},
				onDeath = IncrementCounter_Tank,
			},
			{
				sbp = SBP.SOVIET.M5_HALFTRACK_SQUAD,
				spawn = mkr_ext_sp_01b,
				load = 1,
				sgroups = {sg_final_enc},
			},
			
		},
		onDeath = nil,
	}
	enc_final02 = Encounter:Create(encData)

	local goalData = {
		name = "Attack",
		target = enemy_target,
		range = 60,
		leashRange = 35,
		coordinatedMoveRadius = 20,
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		tacticControlsList = {
			{
				tacticType = TACTIC_Vehicle,
				priority = 1000,
			},
		},
	}
	enc_final02:SetGoal(goalData)
	SGroup_SetAvgHealth(sg_final_tank_02, t_difficulty.enemy_tank_health)
end	

function Setup_Final_Inf01() -- Infantry spawns to attack a random position

	sg_final_infantry = SGroup_CreateIfNotFound("sg_final_infantry")
	sg_final_inf_01 = SGroup_CreateIfNotFound("sg_final_inf_01")
	
	Event_GroupLeftAlive(Final_Inf01_Retreat, nil, sg_final_inf_01, World_GetRand(4, 5) ) -- Retreat
	
	local random_spawn_01 = Table_GetRandomItem(t_exterior_spawns_03)
	local random_target = {mkr_enc5_space, mkr_enc6_space, mkr_enc7_space}
	local encData = {
		player = player2,
		sgroups = {sg_final_infantry},
		units = {

			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = random_spawn_01,
				load = 4,
				upgrades = {UPG.SOVIET.GUARD_DP_28_LMG_PACKAGE},
				sgroups = {sg_final_inf_01},
			},
			{
				sbp = SBP.SOVIET.HM_120_38_MORTAR_SQUAD,
				spawn = random_spawn_01,
				load = 4,
				veterancyRank = Util_DifVar({0, 2, 3}),
				sgroups = {sg_final_inf_01},
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = random_spawn_01,
				load = 4,
				veterancyRank = Util_DifVar({0, 2, 2}),
				upgrades = {UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP},
				sgroups = {sg_final_inf_01, sg_button_enc},
			},
			{
				sbp = SBP.SOVIET.HM_120_38_MORTAR_SQUAD,
				spawn = random_spawn_01,
				load = 4,
				veterancyRank = Util_DifVar({0, 2, 3}),
				sgroups = {sg_final_inf_01},
			},
			
			
		},
		onDeath = nil,
	}
	enc_final_inf_01 = Encounter:Create(encData)

	local goalData = {
		name = "Attack",
		target = enemy_target,
		range = 50,
		leashRange = 30,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 200,
			},
			{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = 800,
			},
		},
	}
	enc_final_inf_01:SetGoal(goalData)
	SGroup_AddAbility(sg_button_enc, ABILITY.SOVIET.BUTTON_VEHICLE_TOW)
end	

function Setup_Final_Inf02() -- Infantry spawns to attack a random position
	sg_final_inf_02 = SGroup_CreateIfNotFound("sg_final_inf_02")
	
	Event_GroupLeftAlive(Final_Inf02_Retreat, nil, sg_final_inf_02, World_GetRand(3, 4) ) -- Retreat
	
	local random_spawn_01 = Table_GetRandomItem(t_exterior_spawns_02)
	local random_target = {mkr_enc1_space, mkr_enc2_space, mkr_enc3_space}
	local encData = {
		player = player2,
		sgroups = {sg_final_infantry},
		units = {

			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = random_spawn_01,
				load = 4,
				upgrades = {UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP},
				veterancyRank = Util_DifVar({0, 2, 2}),
				sgroups = {sg_final_inf_02},
			},
			{
				sbp = SBP.SOVIET.HM_120_38_MORTAR_SQUAD,
				spawn = random_spawn_01,
				load = 4,
				veterancyRank = Util_DifVar({0, 2, 3}),
				sgroups = {sg_final_inf_02},
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = random_spawn_01,
				load = 4,
				upgrades = {UPG.SOVIET.GUARD_DP_28_LMG_PACKAGE},
				sgroups = {sg_final_inf_02, sg_button_enc},
			},
			{
				sbp = SBP.SOVIET.HM_120_38_MORTAR_SQUAD,
				spawn = random_spawn_01,
				load = 4,
				veterancyRank = Util_DifVar({0, 2, 3}),
				sgroups = {sg_final_inf_02},
			},
		},
		onDeath = nil,
	}
	enc_final_inf_02 = Encounter:Create(encData)

	local goalData = {
		name = "Attack",
		target = enemy_target,
		range = 50,
		leashRange = 30,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 200,
			},
			{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = 800,
			},
		},
	}
	enc_final_inf_02:SetGoal(goalData)
	SGroup_AddAbility(sg_button_enc, ABILITY.SOVIET.BUTTON_VEHICLE_TOW)
end	




function Setup_Final_Enc03()
	
	Cmd_Ability(player2, ABILITY.SOVIET.IL_2_RECON_SINGLEPASS_SP, enemy_target, Marker_GetDirection(mkr_flyby_dir), true) 
	sg_final_tank_03 = SGroup_CreateIfNotFound("sg_final_tank_03")
	local spawnlocations_01 = {mkr_ext_sp_02, mkr_ext_sp_03}
	local spawnlocations_02 = {mkr_ext_sp_04, mkr_ext_sp_05}
	local spawnlocations_03 = {mkr_ext_sp_02, mkr_ext_sp_03, mkr_ext_sp_04, mkr_ext_sp_05}
	
	local encData = {
		player = player2,
		sgroups = {sg_final_tank},
		units = {

			{
				sbp = t_difficulty.enemy_difficulty_type.unit_tank,
				spawn = Table_GetRandomItem(spawnlocations_01),
				load = 1,
				sgroups = {sg_final_tank_03},
				onDeath = IncrementCounter_Tank,
			},
			{
				sbp = t_difficulty.enemy_difficulty_type.unit_tank,
				spawn = Table_GetRandomItem(spawnlocations_02),
				load = 1,
				sgroups = {sg_final_tank_03},
				onDeath = IncrementCounter_Tank,
			},
			
		},
		onDeath = nil,
	}
	enc_final03 = Encounter:Create(encData)

	local goalData = {
		name = "Attack",
		target = enemy_target,
		range = 65,
		leashRange = 30,
		coordinatedMoveRadius = 20,
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		tacticControlsList = {
			{
				tacticType = TACTIC_Vehicle,
				priority = 1000,
			},
		},
	}
	enc_final03:SetGoal(goalData)
	SGroup_SetAvgHealth(sg_final_tank_03, t_difficulty.enemy_tank_health)
end	

function Setup_Final_Enc04()
	Cmd_Ability(player2, ABILITY.SOVIET.IL_2_RECON_SINGLEPASS_SP, enemy_target, Marker_GetDirection(mkr_flyby_dir), true) 
	sg_final_tank_04 = SGroup_CreateIfNotFound("sg_final_tank_04")
	local spawnlocations_01 = {mkr_ext_sp_02, mkr_ext_sp_03}
	local spawnlocations_02 = {mkr_ext_sp_04, mkr_ext_sp_05}
	local spawnlocations_03 = {mkr_ext_sp_02, mkr_ext_sp_03, mkr_ext_sp_04, mkr_ext_sp_05}
	
	local encData = {
		player = player2,
		sgroups = {sg_final_tank},
		units = {

			{
				sbp = SBP.SOVIET.KV_2_TOW,
				spawn = Table_GetRandomItem(spawnlocations_01),
				load = 1,
				sgroups = {sg_final_tank_04},
				onDeath = IncrementCounter_Tank,
			},
			{
				sbp = SBP.SOVIET.KV_2_TOW,
				spawn = Table_GetRandomItem(spawnlocations_02),
				load = 1,
				sgroups = {sg_final_tank_04},
				onDeath = IncrementCounter_Tank,
			},
			{
				sbp = SBP.SOVIET.KV_2_TOW,
				spawn = Table_GetRandomItem(spawnlocations_03),
				load = 1,
				sgroups = {sg_final_tank_04},
				onDeath = IncrementCounter_Tank,
			},
			
		},
		onDeath = nil,
	}
	enc_final04 = Encounter:Create(encData)

	local goalData = {
		name = "Attack",
		target = enemy_target,
		range = 65,
		leashRange = 35,
		coordinatedMoveRadius = 20,
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		tacticControlsList = {
			{
				tacticType = TACTIC_Vehicle,
				priority = 1000,
			},
		},
	}
	enc_final04:SetGoal(goalData)
	SGroup_SetAvgHealth(sg_final_tank_04, t_difficulty.enemy_tank_health)
end	

function Final_Inf01_Retreat()
	-- Remaining Units Retreat
	if SGroup_TotalMembersCount(sg_final_inf_01) >= 1 then
		Cmd_AbandonTeamWeapon ( sg_final_inf_01, false )
		Cmd_Retreat(sg_final_inf_01,  Util_GetClosestMarker(sg_final_inf_01, t_retreat_points), Util_GetClosestMarker(sg_final_inf_01, t_retreat_points))
	end
end
function Final_Inf02_Retreat()
	-- Remaining Units Retreat
	if SGroup_TotalMembersCount(sg_final_inf_02) >= 1 then
		Cmd_AbandonTeamWeapon ( sg_final_inf_02, false )
		Cmd_Retreat(sg_final_inf_02,  Util_GetClosestMarker(sg_final_inf_02, t_retreat_points), Util_GetClosestMarker(sg_final_inf_02, t_retreat_points))
	end
end
function Final_Enc_Retreat()
	-- Remaining Units Retreat
	if SGroup_TotalMembersCount(sg_final_enc) >= 1 then
		Cmd_Retreat(sg_final_enc,  Util_GetClosestMarker(sg_final_enc, t_retreat_points), Util_GetClosestMarker(sg_final_enc, t_retreat_points))
	end
end
-----------------------------------
-- Ally Spawns to Capture Areas
-----------------------------------

-- Ally Encounter 1 - Retake Field Part 1
function Area01_Cleared()
	Objective_RemoveUIElements(OBJ_Main, obj_id_1)-- Remove Minimap Marker
	IncrementCounter()-- Updated Objective Count
end

function AllySetupArea01()

	-- Encounter Info
	sg_enc01_ally = SGroup_CreateIfNotFound("sg_enc01_ally")
	
	local encData = {
		player = player3,
		sgroups = {sg_enc01_ally},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_enc1_ally_01,
				load = 4,
				sgroups = {sg_ally_all},
				upgrades = {UPG.GERMAN.AMBUSH_CAMOU_PACKAGE},
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_enc1_ally_02,
				load = 3,
				sgroups = {sg_ally_all},
				upgrades = {UPG.GERMAN.AMBUSH_CAMOU_PACKAGE},
			},
		},
		onDeath = nil,
		
	}
	enc_ally01 = Encounter:Create(encData)

	local goalData = {
		name = "Defend",
		target = mkr_enc1_ally_space,
		range = 30,
		leashRange = 10,
		safeMoveWeight = 0,
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 200,
			},
			{
				tacticType = TACTIC_RushAtTarget,
				priority = 800,
			},
			
		},
	}
	enc_ally01:SetGoal(goalData)
	Event_PlayerOwnsTerritory(Ally01_Advance, nil, player3, eg_point1, ALL, 0)-- Update goal once the player owns the territory.
	SGroup_AddAbility(sg_enc01_ally, ABILITY.GERMAN.AMBUSH_CAMO_HOLD_FIRE_MP)
	Cmd_Ability(sg_enc01_ally, ABILITY.GERMAN.AMBUSH_CAMOUFLAGE)
	Modify_ReceivedDamage(sg_enc01_ally, 0.1)
end	
function Ally01_Advance()
	Modify_SightRadius(sg_enc01_ally, 0.01)
	local goalData = {
		name = "Defend",
		target = mkr_enc1_space,
		range = 15,
		leashRange = 15,
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 1000,
			},
		},
	}
	enc_ally01:SetGoal(goalData)
end


-- Ally Encounter 2 - Retake Crossroads
function Area02_Cleared()
	Objective_RemoveUIElements(OBJ_Main, obj_id_2)
	IncrementCounter()
end

function AllySetupArea02()
	-- Encounter Info
	sg_enc02_ally = SGroup_CreateIfNotFound("sg_enc02_ally")
	
	local encData = {
		player = player3,
		sgroups = {sg_enc02_ally},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_enc2_ally_01,
				load = 3,
				sgroups = {sg_ally_all},
				upgrades = {UPG.GERMAN.AMBUSH_CAMOU_PACKAGE},
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_enc2_ally_02,
				load = 3,
				sgroups = {sg_ally_all},
				upgrades = {UPG.GERMAN.AMBUSH_CAMOU_PACKAGE},
			},
		},
		onDeath = nil,
		
	}
	enc_ally02 = Encounter:Create(encData)

	local goalData = {
		name = "Defend",
		target = mkr_enc2_ally_space,
		range = 30,
		leashRange = 10,
		safeMoveWeight = 0,
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 200,
			},
			{
				tacticType = TACTIC_RushAtTarget,
				priority = 800,
			},
		},
	}
	enc_ally02:SetGoal(goalData)
	Event_PlayerOwnsTerritory(Ally02_Advance, nil, player3, eg_point2, ALL, 0)-- Update goal once the player owns the territory.
	SGroup_AddAbility(sg_enc02_ally, ABILITY.GERMAN.AMBUSH_CAMO_HOLD_FIRE_MP)
	Cmd_Ability(sg_enc02_ally, ABILITY.GERMAN.AMBUSH_CAMOUFLAGE)
	Modify_ReceivedDamage(sg_enc02_ally, 0.1)
end	
function Ally02_Advance()
	Modify_SightRadius(sg_enc02_ally, 0.01)
	local goalData = {
		name = "Defend",
		target = mkr_enc2_space,
		range = 5,
		leashRange = 10,
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 1000,
			},
		},
	}
	enc_ally02:SetGoal(goalData)
end

-- Ally Encounter 3 - Retake Field Part 2
function Area03_Cleared()
	Objective_RemoveUIElements(OBJ_Main, obj_id_3)
	IncrementCounter()
end

function AllySetupArea03()
	-- Encounter Info
	sg_enc03_ally = SGroup_CreateIfNotFound("sg_enc03_ally")
	
	local encData = {
		player = player3,
		sgroups = {sg_enc03_ally},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_enc3_ally_01,
				load = 3,
				sgroups = {sg_ally_all},
				upgrades = {UPG.GERMAN.AMBUSH_CAMOU_PACKAGE},
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_enc3_ally_03,
				load = 3,
				sgroups = {sg_ally_all},
				upgrades = {UPG.GERMAN.AMBUSH_CAMOU_PACKAGE},
			},
		},
		onDeath = nil,
		
	}
	enc_ally03 = Encounter:Create(encData)

	local goalData = {
		name = "Defend",
		target = mkr_enc3_ally_space,
		range = 30,
		leashRange = 10,
		safeMoveWeight = 0,
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 200,
			},
			{
				tacticType = TACTIC_RushAtTarget,
				priority = 800,
			},
		},
	}
	enc_ally03:SetGoal(goalData)
	Event_PlayerOwnsTerritory(Ally03_Advance, nil, player3, eg_point3, ALL, 0)-- Update goal once the player owns the territory.
	SGroup_AddAbility(sg_enc03_ally, ABILITY.GERMAN.AMBUSH_CAMO_HOLD_FIRE_MP)
	Cmd_Ability(sg_enc03_ally, ABILITY.GERMAN.AMBUSH_CAMOUFLAGE)
	Modify_ReceivedDamage(sg_enc03_ally, 0.1)
end	
function Ally03_Advance()
	Modify_SightRadius(sg_enc03_ally, 0.01)
	local goalData = {
		name = "Defend",
		target = mkr_enc3_space,
		range = 15,
		leashRange = 15,
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 1000,
			},
		},
	}
	enc_ally03:SetGoal(goalData)
end

-- Ally Encounter 4 - Retake Village
function Area04_Cleared()
	Objective_RemoveUIElements(OBJ_Main, obj_id_4)
	IncrementCounter()
end

function AllySetupArea04()
	-- Encounter Info
	sg_enc04_ally = SGroup_CreateIfNotFound("sg_enc04_ally")
	
	local encData = {
		player = player3,
		sgroups = {sg_enc04_ally},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_enc5_ally_01,
				load = 4,
				sgroups = {sg_ally_all},
				upgrades = {UPG.GERMAN.AMBUSH_CAMOU_PACKAGE},
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_enc5_ally_02,
				load = 4,
				sgroups = {sg_ally_all},
				upgrades = {UPG.GERMAN.AMBUSH_CAMOU_PACKAGE},
			},
		},
		onDeath = nil,
		
	}
	enc_ally04 = Encounter:Create(encData)

	local goalData = {
		name = "Defend",
		target = mkr_enc4_space,
		range = 20,
		leashRange = 10,
		safeMoveWeight = 0,
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 200,
			},
			{
				tacticType = TACTIC_RushAtTarget,
				priority = 800,
			},
		},
	}
	enc_ally04:SetGoal(goalData)
	Event_PlayerOwnsTerritory(Ally04_Advance, nil, player3, eg_point4, ALL, 0)-- Update goal once the player owns the territory.
	SGroup_AddAbility(sg_enc04_ally, ABILITY.GERMAN.AMBUSH_CAMO_HOLD_FIRE_MP)
	Cmd_Ability(sg_enc04_ally, ABILITY.GERMAN.AMBUSH_CAMOUFLAGE)
	Modify_ReceivedDamage(sg_enc04_ally, 0.1)
end	
function Ally04_Advance()
	Modify_SightRadius(sg_enc04_ally, 0.25)
	local goalData = {
		name = "Defend",
		target = mkr_enc4_space,
		range = 15,
		leashRange = 10,
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 1000,
			},
			
		},
	}
	enc_ally04:SetGoal(goalData)
end

-- Ally Encounter 5 - Retake RailYard
function Area05_Cleared()
	Objective_RemoveUIElements(OBJ_Main, obj_id_5)
	IncrementCounter()
end

function AllySetupArea05()
	-- Encounter Info
	sg_enc05_ally = SGroup_CreateIfNotFound("sg_enc05_ally")
	
	local encData = {
		player = player3,
		sgroups = {sg_enc05_ally},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_enc6_ally_01,
				load = 3,
				sgroups = {sg_ally_all},
				upgrades = {UPG.GERMAN.AMBUSH_CAMOU_PACKAGE},
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_enc6_ally_02,
				load = 3,
				sgroups = {sg_ally_all},
				upgrades = {UPG.GERMAN.AMBUSH_CAMOU_PACKAGE},
			},
		},
		onDeath = nil,
		
	}
	enc_ally05 = Encounter:Create(encData)

	local goalData = {
		name = "Defend",
		target = mkr_enc5_ally_space,
		range = 30,
		leashRange = 10,
		safeMoveWeight = 0,
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 200,
			},
			{
				tacticType = TACTIC_RushAtTarget,
				priority = 800,
			},
		},
	}
	enc_ally05:SetGoal(goalData)
	Event_PlayerOwnsTerritory(Ally05_Advance, nil, player3, eg_point5, ALL, 0)-- Update goal once the player owns the territory.
	SGroup_AddAbility(sg_enc05_ally, ABILITY.GERMAN.AMBUSH_CAMO_HOLD_FIRE_MP)
	Cmd_Ability(sg_enc05_ally, ABILITY.GERMAN.AMBUSH_CAMOUFLAGE)
	Modify_ReceivedDamage(sg_enc07_ally, 0.1)
end	
function Ally05_Advance()
	Modify_SightRadius(sg_enc05_ally, 0.25)
	local goalData = {
		name = "Defend",
		target = mkr_enc5_space,
		range = 15,
		leashRange = 10,
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 1000,
			},
			
		},
	}
	enc_ally05:SetGoal(goalData)
end


-- Ally Encounter 6 - Retake North Road Artillery
function Area06_Cleared()
	Objective_RemoveUIElements(OBJ_Main, obj_id_6)
	IncrementCounter()
	
	enc_06:ClearGoal()
	Cmd_Stop( sg_enc06_all ) 
	Cmd_AbandonTeamWeapon ( sg_enc06_all, false )
	Cmd_Retreat(sg_enc06_all, mkr_retreat_01, mkr_retreat_01, true)
end

function AllySetupArea06()
	-- Encounter Info
	sg_enc06_ally = SGroup_CreateIfNotFound("sg_enc06_ally")
	
	local encData = {
		player = player3,
		sgroups = {sg_enc06_ally},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_enc5_ally_01,
				load = 4,
				sgroups = {sg_ally_all},
				upgrades = {UPG.GERMAN.AMBUSH_CAMOU_PACKAGE},
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_enc5_ally_01,
				load = 4,
				sgroups = {sg_ally_all},
				upgrades = {UPG.GERMAN.AMBUSH_CAMOU_PACKAGE},
			},
			
		},
		onDeath = nil,
		
	}
	enc_ally06 = Encounter:Create(encData)

	local goalData = {
		name = "Defend",
		target = mkr_enc6_ally_space,
		range = 30,
		leashRange = 10,
		safeMoveWeight = 0,
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 200,
			},
			{
				tacticType = TACTIC_RushAtTarget,
				priority = 800,
			},
		},
	}
	enc_ally06:SetGoal(goalData)
	Event_PlayerOwnsTerritory(Ally06_Advance, nil, player3, eg_point6, ALL, 0)-- Update goal once the player owns the territory.
	SGroup_AddAbility(sg_enc06_ally, ABILITY.GERMAN.AMBUSH_CAMO_HOLD_FIRE_MP)
	Cmd_Ability(sg_enc06_ally, ABILITY.GERMAN.AMBUSH_CAMOUFLAGE)
	Modify_ReceivedDamage(sg_enc06_ally, 0.1)
end	
function Ally06_Advance()
	Modify_SightRadius(sg_enc06_ally, 0.25)
	local goalData = {
		name = "Defend",
		target = mkr_enc6_space,
		range = 15,
		leashRange = 10,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 1000,
			},
		},
	}
	enc_ally06:SetGoal(goalData)
end


-- Ally Encounter 7 - Retake South Road Artillery
function Area07_Cleared()
	Objective_RemoveUIElements(OBJ_Main, obj_id_7)
	IncrementCounter()
	
	enc_07:ClearGoal()
	Cmd_AbandonTeamWeapon ( sg_enc07_all, false )
	Cmd_Retreat(sg_enc07_all, mkr_retreat_02, mkr_retreat_02, true)
end
function AllySetupArea07()
	-- Encounter Info
	sg_enc07_ally = SGroup_CreateIfNotFound("sg_enc07_ally")
	
	local encData = {
		player = player3,
		sgroups = {sg_enc07_ally},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_enc6_ally_01,
				load = 4,
				sgroups = {sg_ally_all},
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_enc6_ally_02,
				load = 4,
				sgroups = {sg_ally_all},
			},
		},
		onDeath = nil,
		
	}
	enc_ally07 = Encounter:Create(encData)

	local goalData = {
		name = "Defend",
		target = mkr_enc7_ally_space,
		range = 30,
		leashRange = 10,
		safeMoveWeight = 0,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 1000,
			},
		},
	}
	enc_ally07:SetGoal(goalData)
	Event_PlayerOwnsTerritory(Ally07_Advance, nil, player3, eg_point7, ALL, 0)-- Update goal once the player owns the territory.
	SGroup_AddAbility(sg_enc07_ally, ABILITY.GERMAN.AMBUSH_CAMO_HOLD_FIRE_MP)
	Cmd_Ability(sg_enc07_ally, ABILITY.GERMAN.AMBUSH_CAMOUFLAGE)
	Modify_ReceivedDamage(sg_enc07_ally, 0.1)
end	
function Ally07_Advance()
	Modify_SightRadius(sg_enc07_ally, 0.25)
	local goalData = {
		name = "Defend",
		target = mkr_enc7_space,
		range = 15,
		leashRange = 10,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 1000,
			},
		},
	}
	enc_ally07:SetGoal(goalData)
end

function Ally_Modifiers()
	Modifier_RemoveAllFromSGroup(sg_ally_all)
	Modify_SightRadius(sg_ally_all, 2)
end

function AllySetupFinale01()
	sg_ally_finale = SGroup_CreateIfNotFound("sg_ally_finale")
	local encData = {
		player = player3,
		sgroups = {sg_ally_finale},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = Util_GetClosestMarker(enemy_target, t_exterior_spawns_04),
				load = 3,
				sgroups = {sg_ally_finale},
				upgrades = {UPG.GERMAN.PANZERBUSCHE_39},
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = Util_GetClosestMarker(enemy_target, t_exterior_spawns_04),
				load = 3,
				sgroups = {sg_ally_finale},
				upgrades = {UPG.GERMAN.PANZERBUSCHE_39},
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = Util_GetClosestMarker(enemy_target, t_exterior_spawns_04),
				load = 3,
				sgroups = {sg_ally_finale},
				upgrades = {UPG.GERMAN.PANZERBUSCHE_39},
			},
		},
		onDeath = nil,
		
	}
	enc_ally_finale_01 = Encounter:Create(encData)

	local goalData = {
		name = "Defend",
		target = enemy_target,
		range = 40,
		leashRange = 20,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 1000,
			},
		},
	}
	enc_ally_finale_01:SetGoal(goalData)
end

-----------------------------------
-- Bonus Objective Transport Encounters
-----------------------------------
function Bonus_OBJ_Check() -- Check to see if player can see bonus
	if SGroup_CanSeeSGroup(sg_Tiger, sg_bonus, ANY) then
		Start_BonusOBJ()
		Rule_AddInterval(Bonus_Enc_01_UI, 0.5, 1000)
		Rule_AddInterval(Bonus_Enc_02_UI, 0.5, 1000)
		Rule_AddInterval(Bonus_Enc_03_UI, 0.5, 1000)
		Rule_RemoveMe()
	end
end


function Bonus_Enc01()
	
	bonus_spawn_01 = Table_GetRandomItem(t_bonus_spawn_01) -- Get random spawn location
	local bonus_state = {"full","partial"} -- Get random state
	sg_transport_01 = SGroup_CreateIfNotFound("sg_transport_01")
	sg_bonus_inf_01 = SGroup_CreateIfNotFound("sg_bonus_inf_01")
	
	t_bonus_enc[1] = {}
	local encData = {
		player = player2,
		sgroups = {sg_bonus},
		units = {
			{
				sbp = SBP.SOVIET.ZIS_6_TRANSPORT_TRUCK,
				spawn = bonus_spawn_01,
				load = 1,
				sgroups = {sg_transport_01},
				onDeath = IncrementCounter_Transports, 
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = bonus_spawn_01,
				load = 2,
				sgroups = {sg_bonus_inf_01},
			},
		},
		onDeath = nil,
		
	}
	
	t_bonus_enc[1].all = Encounter:Create(encData)
	SGroup_SetAnimatorState(sg_transport_01, "supplies_loaded", Table_GetRandomItem(bonus_state))
	Cmd_CriticalHit (player2, sg_transport_01, CRIT.VEHICLE_LIGHT_DESTROY_ENGINE, 1) -- disable engine
	Event_GroupIsDead(Bonus_Enc01_Retreat, {enc=t_bonus_enc[1].all}, sg_transport_01, 1)
	Event_GroupIsDead(Bonus_Enc_01_Remove_UI,nil, sg_transport_01, 1)
end	
function Bonus_Enc01_Retreat()
	if SGroup_Count(sg_bonus_inf_01) >= 1 then
		Cmd_AbandonTeamWeapon ( sg_bonus_inf_01, false )
		Cmd_Retreat(sg_bonus_inf_01, Util_GetClosestMarker(sg_bonus_inf_01, t_retreat_points), Util_GetClosestMarker(sg_bonus_inf_01, t_retreat_points))
	end
end

function Bonus_Enc_01_UI()
	if SGroup_CanSeeSGroup(sg_Tiger, sg_transport_01, ANY) then
		Bonus_UI_01 = Objective_AddUIElements(OBJ_Bonus, bonus_spawn_01, true, 11051341, true, 3, nil, HPAT_Objective)
		Rule_RemoveMe()
	end
end

function Bonus_Enc_01_Remove_UI()
		Objective_RemoveUIElements(OBJ_Bonus, Bonus_UI_01)
end



function Bonus_Enc02()
	t_bonus_enc[2] = {}
	bonus_spawn_02 = Table_GetRandomItem(t_bonus_spawn_02) -- Get random spawn location
	local bonus_state = {"full","partial"} -- Get random state 
	sg_transport_02 = SGroup_CreateIfNotFound("sg_transport_02")
	sg_bonus_inf_02 = SGroup_CreateIfNotFound("sg_bonus_inf_02")
	local encData = {
		player = player2,
		sgroups = {sg_bonus},
		units = {
			{
				sbp = SBP.SOVIET.ZIS_6_TRANSPORT_TRUCK,
				spawn = bonus_spawn_02,
				load = 1,
				sgroups = {sg_transport_02},
				onDeath = IncrementCounter_Transports, 
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = bonus_spawn_02,
				load = 3,
				sgroups = {sg_bonus_inf_02},
			},
		},
		onDeath = nil,
		
	}
	t_bonus_enc[2].all = Encounter:Create(encData)
	SGroup_SetAnimatorState(sg_transport_02, "supplies_loaded", Table_GetRandomItem(bonus_state))
	Cmd_CriticalHit (player2, sg_transport_02, CRIT.VEHICLE_LIGHT_DESTROY_ENGINE, 1)
	Event_GroupIsDead(Bonus_Enc02_Retreat, {enc=t_bonus_enc[2].all}, sg_transport_02, 1)
	Event_GroupIsDead(Bonus_Enc_02_Remove_UI,nil, sg_transport_02, 1)
end	
function Bonus_Enc02_Retreat()
	if SGroup_Count(sg_bonus_inf_02) >= 1 then
		Cmd_AbandonTeamWeapon ( sg_bonus_inf_02, false )
		Cmd_Retreat(sg_bonus_inf_02, Util_GetClosestMarker(sg_bonus_inf_02, t_retreat_points), Util_GetClosestMarker(sg_bonus_inf_02, t_retreat_points))
	end
end
function Bonus_Enc_02_UI()
	if SGroup_CanSeeSGroup(sg_Tiger, sg_transport_02, ANY) then
		Bonus_UI_02 = Objective_AddUIElements(OBJ_Bonus, bonus_spawn_02, true, 11051341, true, 3, nil, HPAT_Objective)
		Rule_RemoveMe()
	end
end
function Bonus_Enc_02_Remove_UI()
	Objective_RemoveUIElements(OBJ_Bonus, Bonus_UI_02)
end


function Bonus_Enc03()
	t_bonus_enc[3] = {}
	bonus_spawn_03 = Table_GetRandomItem(t_bonus_spawn_03) -- Get random spawn location
	local bonus_state = {"full","partial"} -- Get random state 
	sg_transport_03 = SGroup_CreateIfNotFound("sg_transport_03")
	sg_bonus_inf_03 = SGroup_CreateIfNotFound("sg_bonus_inf_03")
	local encData = {
		player = player2,
		sgroups = {sg_bonus},
		units = {
			{
				sbp = SBP.SOVIET.ZIS_6_TRANSPORT_TRUCK,
				spawn = bonus_spawn_03,
				load = 1,
				sgroups = {sg_transport_03},
				onDeath = IncrementCounter_Transports, 
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = bonus_spawn_03,
				load = 2,
				sgroups = {sg_bonus_inf_03},
			},
		},
		onDeath = nil,
	}
	t_bonus_enc[3].all = Encounter:Create(encData)
	SGroup_SetAnimatorState(sg_transport_03, "supplies_loaded", Table_GetRandomItem(bonus_state))
	Cmd_CriticalHit (player2, sg_transport_03, CRIT.VEHICLE_LIGHT_DESTROY_ENGINE, 1)
	Event_GroupIsDead(Bonus_Enc03_Retreat, {enc=t_bonus_enc[3].all}, sg_transport_03, 1)
	Event_GroupIsDead(Bonus_Enc_03_Remove_UI,nil, sg_transport_03, 1)
end	
function Bonus_Enc03_Retreat()
	if SGroup_Count(sg_bonus_inf_03) >= 1 then
		Cmd_AbandonTeamWeapon ( sg_bonus_inf_03, false )
		Cmd_Retreat(sg_bonus_inf_03, Util_GetClosestMarker(sg_bonus_inf_03, t_retreat_points), Util_GetClosestMarker(sg_bonus_inf_03, t_retreat_points))
	end
end
function Bonus_Enc_03_UI()
	if SGroup_CanSeeSGroup(sg_Tiger, sg_transport_03, ANY) then
		Bonus_UI_03 = Objective_AddUIElements(OBJ_Bonus, bonus_spawn_03, true,11051341, true, 3, nil, HPAT_Objective)
		Rule_RemoveMe()
	end
end
function Bonus_Enc_03_Remove_UI()
	Objective_RemoveUIElements(OBJ_Bonus, Bonus_UI_03)
end
