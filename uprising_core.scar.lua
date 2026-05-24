import("ScarUtil.scar")
import("Fatalities/Fatalities.scar")

function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

function WinCondition_GameOver(winningTeam, losingTeam)
	-- Set the winning team (this will fire win/loss events for each player).
	World_SetTeamWin(winningTeam)
	
	local winningPlayers = Team_GetPlayers(winningTeam)
	local losingPlayers = Team_GetPlayers(losingTeam)
	
	Fatality_Execute(winningPlayers, losingPlayers)
end

function OnInit()
	print("Initializing game...")
	
	--[[ SET RESTRICTIONS ]]
	Mission_Restrictions()
	
	--[[ SET MODIFIERS ]]
--	Mission_SetupVariables()
	
	--[[ SET ABILITIES ]]
	Mission_Abilities()
	
	--[[ MISSION PRESETS ]]
	Mission_MissionPreset()
	
	--[[ MISSION DIFFICULTY ]]
--	Mission_Difficulty()
	
	--[[ REGISTER OBJECTIVES ]]	
	INIT_ObjCasultiesObjective()
	
	--[[ MISSION START ]]
	Mission_Start()

	
	print("Game initialization finished.")
end
	Scar_AddInit(OnInit)
	
function INIT_ObjCasultiesObjective()

	print("Initializing casulties Objective...")
		
	obj_BPhase = {
	
		SetupUI = function() 
		end,
		
		OnStart = function()
			Objective_Start(SOBJ_Cas, false)
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = Util_CreateLocString("Current Battle Phase: 0"),
		Description = 0,
		Type = OT_Primary,
	}
	
	SOBJ_Cas = {
		Parent = obj_BPhase,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = Util_CreateLocString("German Casulties until next Battle Phase: 30"),
		Description = 0,
		Type = OT_Secondary,
	}
		
	Objective_Register(obj_BPhase)
	Objective_Register(SOBJ_Cas)
	
end
	
function Mission_Restrictions()
	for i=1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		
		if Player_GetRaceName(player) == "soviet" then
			Modify_PlayerResourceRate(player, RT_Munition, 0)
			Modify_PlayerResourceRate(player, RT_Fuel, 0)
			Player_SetResource(player, RT_Munition, 0)
			Player_SetResource(player, RT_Fuel, 0)
		elseif Player_GetRaceName(player) == "german" then
			
		end
	end
end

function Mission_Abilities()
	for i=1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		
		if Player_GetRaceName(player) == "soviet" then
			Player_AddAbility(player, BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:partisans_uprising"))
			Player_AddAbility(player, BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:partisans_commander_anti_vehicle_uprising"))
			Player_AddAbility(player, BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:partisans_uprising_spotter"))
			Player_AddAbility(player, BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:partisans_uprising_medic"))
			Player_AddAbility(player, BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:partisans_uprising_engi"))
			Player_AddAbility(player, BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:partisans_uprising_building"))
			Player_AddAbility(player, BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:sniper_uprising"))
			Player_SetAbilityAvailability(player, {
				BP_GetAbilityBlueprint("for_mother_russia_ability"),
				BP_GetAbilityBlueprint("il-2_support"),
				BP_GetAbilityBlueprint("fear_propaganda_artillery"),
				BP_GetAbilityBlueprint("il-2_precision_bomb_strike"),
				BP_GetAbilityBlueprint("il-2_recon"),
				BP_GetAbilityBlueprint("scorched_earth_policy"),
				BP_GetAbilityBlueprint("rapid_conscription"),
				BP_GetAbilityBlueprint("partisan_dispatch"),
				BP_GetAbilityBlueprint("tank_detection_ability"),
				BP_GetAbilityBlueprint("mark_vehicle"),
				BP_GetAbilityBlueprint("il-2_sturmovik_attack"),
				BP_GetAbilityBlueprint("soviet_hq_engineer_call_in"),
				BP_GetAbilityBlueprint("cmd_is2_heavy_tank"),
				BP_GetAbilityBlueprint("cmd_120mm_mortar_crew"),
				BP_GetAbilityBlueprint("cmd_guard_troops"),
				BP_GetAbilityBlueprint("cmd_isu-152"),
				BP_GetAbilityBlueprint("cmd_katyusha"),
				BP_GetAbilityBlueprint("cmd_penal_battalion"),
				BP_GetAbilityBlueprint("cmd_shock_troops"),
				BP_GetAbilityBlueprint("cmd_radio_intercept"),
				BP_GetAbilityBlueprint("cmd_t34_85_medium_tank"),
				BP_GetAbilityBlueprint("cmd_vehicle_crew_repair_training"),
				BP_GetAbilityBlueprint("cmd_kv-8_unlock_mp"),
				BP_GetAbilityBlueprint("cmd_at_gun_ambush_tactics_mp"),
				BP_GetAbilityBlueprint("cmd_conscript_assault_package"),
				BP_GetAbilityBlueprint("cmd_ml_20"),
				BP_GetAbilityBlueprint("fire_artillery"),
				BP_GetAbilityBlueprint("army_item_global_cover_training"),
				BP_GetAbilityBlueprint("partisan_dispatch_tow"),
				BP_GetAbilityBlueprint("no_retreat_no_surrender"),
				BP_GetAbilityBlueprint("scorched_earth_policy_mp"),
				BP_GetAbilityBlueprint("commissar_squad_mp"),
				BP_GetAbilityBlueprint("b4_203mm_howitzer"),
				BP_GetAbilityBlueprint("forward_hq"),
				BP_GetAbilityBlueprint("booby_trap"),
				BP_GetAbilityBlueprint("m-42_at_gun"),
				BP_GetAbilityBlueprint("cmd_kv-1_unlock"),
				BP_GetAbilityBlueprint("kv-2"),
				BP_GetAbilityBlueprint("soviet_industry"),
				BP_GetAbilityBlueprint("repair_station"),
				BP_GetAbilityBlueprint("tank_traps"),
				BP_GetAbilityBlueprint("anti-personnel_mines"),
				BP_GetAbilityBlueprint("spy_network"),
				BP_GetAbilityBlueprint("partisans_commander_anti_infantry"),
				BP_GetAbilityBlueprint("partisans_commander_anti_vehicle"),
				BP_GetAbilityBlueprint("salvage_kits"),
				BP_GetAbilityBlueprint("manpower_blitz"),
				BP_GetAbilityBlueprint("hold_the_line"),
				BP_GetAbilityBlueprint("conscript_ptrs_upgrade"),
				BP_GetAbilityBlueprint("il-2_anti_tank_bomb_strike"),
				BP_GetAbilityBlueprint("dshk_mp"),
				BP_GetAbilityBlueprint("il-2_sturmovik_attack_advanced"),
				BP_GetAbilityBlueprint("sherman_soviet_dispatch"),
				BP_GetAbilityBlueprint("m5_halftrack_assault"),
				BP_GetAbilityBlueprint("cmd_tank_hunter_ambush_tactics_mp"),
				BP_GetAbilityBlueprint("light_anti_vehicle_mines"),
				BP_GetAbilityBlueprint("anti_tank_overwatch"),
				BP_GetAbilityBlueprint("commissar_officer_squad_mp"),
				BP_GetAbilityBlueprint("scorched_earth_mp"),
			}, ITEM_REMOVED)
		end
	end
end

function Mission_MissionPreset()
	eg_CptPs = EGroup_CreateIfNotFound("eg_CptPs")
	World_GetStrategyPoints(eg_CptPs, false)
	
	local g_FoundSoviet = false
	local _soviet
	for i=1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		if Player_GetRaceName(player) == "soviet" and g_FoundSoviet == false then
			g_FoundSoviet = true
			_soviet = player
		end
	end
	
	local _GenerateFront = function(gid, idx, eid)
		if _soviet ~= nil then
			if World_GetRand(0, 1) < 0.5 then
				Entity_InstantCaptureStrategicPoint(eid, _soviet)
			end	
		end
	end
	
	EGroup_ForEach(eg_CptPs, _GenerateFront)
end

function Mission_Start()
	for i=1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		
		if Player_GetRaceName(player) == "soviet" then
			Util_CollectSovietBase(player)
			local sg_all = SGroup_CreateIfNotFound("sg_all")
			Player_GetAll(player, sg_all)
			SGroup_DestroyAllSquads(sg_all)
		elseif Player_GetRaceName(player) == "west_german" then
			Player_SetAllCommandAvailabilityInternal(player, ITEM_LOCKED, Util_CreateLocString("Please play the Ostheer"))
		elseif (Player_GetRaceName(player) == "aef") or (Player_GetRaceName(player) == "british") then
			Player_SetAllCommandAvailabilityInternal(player, ITEM_LOCKED, Util_CreateLocString("Please play the Soviet Union"))
		elseif Player_GetRaceName(player) == "german" then
			Util_ReplaceGermanBase(player)
			local sg_all = SGroup_CreateIfNotFound("sg_all")
			Player_GetAll(player, sg_all)
			SGroup_DestroyAllSquads(sg_all)
			Util_CreateSquads(player, nil, BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:pioneer_squad_uprising_mp"), Player_GetStartingPosition(player), Player_GetStartingPosition(player), 2)
			Util_CreateSquads(player, nil, {BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:assault_grenadier_squad_uprising_mp"), BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:grenadier_squad_uprising_mp")}, Player_GetStartingPosition(player), Player_GetStartingPosition(player), 2)
		end
	end
	if EGroup_Exists("eg_AllSovietHQs") == true then
		if EGroup_IsEmpty(eg_AllSovietHQs) == false then 
			EGroup_SetWorldOwned(eg_AllSovietHQs)	
		end
	end
	if EGroup_Exists("eg_AllSovietMGs") == true then
		if EGroup_IsEmpty(eg_AllSovietMGs) == false then
			EGroup_DestroyAllEntities(eg_AllSovietMGs)
		end
	end
-------------------------------------------------------------------------
	Objective_Start(obj_BPhase, false)
-------------------------------------------------------------------------
	eg_radioTowers = EGroup_CreateIfNotFound("eg_radioTowers")
	World_GetStrategyPoints(eg_radioTowers, true)
	EGroup_Filter(eg_radioTowers, BP_GetEntityBlueprint("9d197160ccb545028db7d0bf1c944418:radio_tower_point_uprising_mp"), FILTER_KEEP)
	EGroup_SetStrategicPointNeutral(eg_radioTowers)
	Rule_AddInterval(Radios_Check, 1)
-------------------------------------------------------------------------
	eg_AmmoBoxes = EGroup_CreateIfNotFound("eg_AmmoBoxes")
	--e_ammoBox = Entity_Create(BP_GetEntityBlueprint("supply_drop_manpower_ammunition"), World_GetPlayerAt(1), World_Pos(0, World_GetHeightAt(0, 0), 0), World_Pos(0, World_GetHeightAt(0, 0), 0))
	Rule_AddInterval(Generate_AmmoBoxes, 3)
-------------------------------------------------------------------------
	Rule_AddInterval(Check_PartisanKills, 1)
	g_battle_phase = 1
	g_killLimit1 = 30
	g_killLimit2 = 60
end

function Generate_AmmoBoxes()
	if EGroup_Count(eg_AmmoBoxes) < 30 and World_GetRand(0, 10) < 8 then
		local Min = (World_GetWidth() < World_GetLength()) and World_GetWidth() or World_GetLength()
		Util_CreateEntities(nil, eg_AmmoBoxes, BP_GetEntityBlueprint("9d197160ccb545028db7d0bf1c944418:supply_drop_uprising"), World_GetNearestInteractablePoint(Util_GetRandomPosition(World_Pos(0, 0, 0), Min)), 1)
	end
end

function Check_PartisanKills()
	local g_totalPKills = 0
	for i=1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		if Player_GetRaceName(player) == "soviet" then
			g_totalPKills = g_totalPKills + Stats_SoldiersKilled(player)
		end
	end 
	if g_totalPKills >= g_killLimit1 and g_battle_phase == 1 then
		for i = 1, World_GetPlayerCount() do
			local player = World_GetPlayerAt(i)
			
			if Player_GetRaceName(player) == "german" then
				Cmd_InstantUpgrade(player, {BP_GetUpgradeBlueprint("9d197160ccb545028db7d0bf1c944418:battle_phase_2_uprising_mp"), BP_GetUpgradeBlueprint("battle_phase_2_mp")})
			end
		end
	end
	if g_totalPKills >= g_killLimit2 and g_battle_phase == 2 then
		for i = 1, World_GetPlayerCount() do
			local player = World_GetPlayerAt(i)
			
			if Player_GetRaceName(player) == "german" then
				Cmd_InstantUpgrade(player, {BP_GetUpgradeBlueprint("9d197160ccb545028db7d0bf1c944418:battle_phase_3_uprising_mp"), BP_GetUpgradeBlueprint("battle_phase_3_mp")})
			end
		end
	end
	if g_battle_phase == 1 then
		Objective_UpdateText(SOBJ_Cas, Util_CreateLocString("German Casulties until next Battle Phase: "..g_killLimit1 - g_totalPKills), nil, false)
	elseif g_battle_phase == 2 then
		Objective_UpdateText(SOBJ_Cas, Util_CreateLocString("German Casulties until next Battle Phase: "..g_killLimit2 - g_totalPKills), nil, false)
	elseif g_battle_phase == 3 then
		Objective_Show(SOBJ_Cas, false)
		Rule_RemoveMe()
	end
	if g_totalPKills >= g_killLimit1  and g_battle_phase == 1 then
		g_battle_phase = 2
		Util_MissionTitle(Util_CreateLocString("Battle Phase 1 has been launched"), 1, 3, 1)
		Objective_UpdateText(obj_BPhase, Util_CreateLocString("Current Battle Phase: "..g_battle_phase - 1), nil, false)
	elseif g_totalPKills >= g_killLimit2  and g_battle_phase == 2 then
		g_battle_phase = 3
		Util_MissionTitle(Util_CreateLocString("Battle Phase 2 has been launched"), 1, 3, 1)
		Objective_UpdateText(obj_BPhase, Util_CreateLocString("Current Battle Phase: "..g_battle_phase - 1), nil, false)
	end
end

function Util_ReplaceGermanBase(player)
	local __sgroup = SGroup_CreateIfNotFound("__sgroup")
	local eg_all = EGroup_CreateIfNotFound("eg_all")
	Player_GetAll(player, __sgroup, eg_all)
	
	eg_AllGermanHQs = EGroup_CreateIfNotFound("eg_AllGermanHQs")
	
	local _sortBase = function(gid, idx, eid)
		if Entity_GetBlueprint(eid) == BP_GetEntityBlueprint("german_hq_mp") then
			local e_pos = Entity_GetPosition(eid)
			Entity_Destroy(eid)
			Util_CreateEntities(player, nil, BP_GetEntityBlueprint("9d197160ccb545028db7d0bf1c944418:german_hq_uprising_mp"), e_pos, 1)
		end
	end
	
	EGroup_ForEach(eg_all, _sortBase)
end

function Util_CollectSovietBase(player) 
	
	local __sgroup = SGroup_CreateIfNotFound("__sgroup")
	local eg_all = EGroup_CreateIfNotFound("eg_all")
	Player_GetAll(player, __sgroup, eg_all) 
	
	eg_AllSovietHQs = EGroup_CreateIfNotFound("eg_AllSovietHQs")
	eg_AllSovietMGs = EGroup_CreateIfNotFound("eg_AllSovietMGs")
	
	local _sortBase = function(gid, idx, eid)
		if Entity_GetBlueprint(eid) == BP_GetEntityBlueprint("hq_mp") then
			EGroup_Add(eg_AllSovietHQs, eid)
		elseif Entity_GetBlueprint(eid) == BP_GetEntityBlueprint("machine_gun_nest_mp") then
			EGroup_Add(eg_AllSovietMGs, eid)
		end
	end
	
	EGroup_ForEach(eg_all, _sortBase) 
end

function Radios_Check()
	local g_sovietsHoldRT = false
	local g_germansHoldRT = false
	for i=1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		if EGroup_IsCapturedByPlayer(eg_radioTowers, player, false) and (Player_GetRaceName(player) == "soviet") then
			g_sovietsHoldRT = true
		end
	end
	if g_sovietsHoldRT then
		for i=1, World_GetPlayerCount() do
			local player = World_GetPlayerAt(i)
			
			if Player_GetRaceName(player) == "soviet" then
				Player_AddAbility(player, BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:guards_dispatch_uprising_mp"))
				Player_SetAbilityAvailability(player, BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:guards_dispatch_uprising_mp"), ITEM_UNLOCKED)
			end
		end
	else
		for i=1, World_GetPlayerCount() do
			local player = World_GetPlayerAt(i)
			
			if Player_GetRaceName(player) == "soviet" then
				Player_SetAbilityAvailability(player, BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:guards_dispatch_uprising_mp"), ITEM_REMOVED)
			end
		end
	end
	for i=1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		if EGroup_IsCapturedByPlayer(eg_radioTowers, player, false) and (Player_GetRaceName(player) == "german") then
			g_germansHoldRT = true
		end
	end
	if g_germansHoldRT then
		for i=1, World_GetPlayerCount() do
			local player = World_GetPlayerAt(i)
			
			if Player_GetRaceName(player) == "german" then
				Player_AddAbility(player, BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:fallschirmjaeger_uprising"))
				Player_SetAbilityAvailability(player, BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:fallschirmjaeger_uprising"), ITEM_UNLOCKED)
			end
		end
	else
		for i=1, World_GetPlayerCount() do
			local player = World_GetPlayerAt(i)
			
			if Player_GetRaceName(player) == "german" then
				Player_SetAbilityAvailability(player, BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:fallschirmjaeger_uprising"), ITEM_REMOVED)
			end
		end
	end
end

