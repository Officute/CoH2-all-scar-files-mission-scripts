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
	Rule_RemoveMe()
	
	_G.print = {
        cache = ''
    }

    setmetatable(_G.print, {
        __call = function(self, ...)
            local args = {...}
            for index = 1, #args do
                self.cache = self.cache..tostring(args[index])..'\t'
            end
            self.cache = self.cache..'\n'
            PersistentMode_SerializeResults('userdata:logs/scarlog.txt', self.cache)
        end
    })
	
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
	
function INIT_ObjCasultiesObjective()

	print("Initialising casulties Objective...")
		
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
			Player_AddAbility(player, BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:panzer_dispatch"))
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
-------------------------------------------------------------------------
	g_Init = true
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























































function INIT_StrongpointObjective()

	print("Initialising strongpoint Objective...")
		
	obj_ST = {
	
		SetupUI = function()
		end,
		
		OnStart = function()
			Objective_Start(SOBJ_ST1, false)
			Objective_Start(SOBJ_ST2, false)
			Objective_Start(SOBJ_ST3, false)
			Objective_Start(SOBJ_HowInf, false)
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = Util_CreateLocString("Partisans must clear out all German strongpoints"),
		Description = 0,
		Type = OT_Primary,
	}
	
	SOBJ_ST1 = {
		Parent = obj_ST,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = Util_CreateLocString("Take out strongpoint 1"),
		Description = 0,
		Type = OT_Secondary,
	}
	
	SOBJ_ST2 = {
		Parent = obj_ST,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = Util_CreateLocString("Take out strongpoint 2"),
		Description = 0,
		Type = OT_Secondary,
	}
	
	SOBJ_ST3 = {
		Parent = obj_ST,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = Util_CreateLocString("Take out strongpoint 3"),
		Description = 0,
		Type = OT_Secondary,
	}
	
	SOBJ_HowInf = {
		Parent = obj_ST,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = Util_CreateLocString("Capture the howitzer to easily take out German positions"),
		Description = 0,
		Type = OT_Information,
	}
		
	Objective_Register(obj_ST)
	Objective_Register(SOBJ_ST1)
	Objective_Register(SOBJ_ST2)
	Objective_Register(SOBJ_ST3)
	Objective_Register(SOBJ_HowInf)
	
end

function INIT_ObjKillsObjective()

	print("Initialising kills Objective...")
		
	obj_Kills = {
	
		SetupUI = function() 
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = Util_CreateLocString(""),
		Description = 0,
		Type = OT_Primary,
	}
	
	SOBJ_Kills = {
		
		Parent = obj_Kills,
		SetupUI = function() 
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = Util_CreateLocString("Clear the area of partisans"),
		Description = 0,
		Type = OT_Primary,
	}
	
	SOBJ_srrndr = {
		
		Parent = obj_Kills,
		SetupUI = function() 
			Objective_StartTimer(SOBJ_srrndr, COUNT_DOWN, 180)
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = Util_CreateLocString("Partisans will surrender soon"),
		Description = 0,
		Type = OT_Primary,
	}
	
	Objective_Register(obj_Kills)
	Objective_Register(SOBJ_Kills)
	Objective_Register(SOBJ_srrndr)
end

function STInit1()
		--initialisation
	print("Initialising...")
	
	NumE = World_GetNumEntities() - 1
	
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		
		if Player_GetRaceName(player) == "german" then
			_german = player
		end
	end
	
	eg_PotSTs = EGroup_CreateIfNotFound("eg_PotSTs")
	
	local temp = SGroup_CreateIfNotFound("temp")
	Player_GetAll(_german, temp)
	s_generic = SGroup_GetRandomSpawnedSquad(temp)
	
	for i = 1, NumE do
		local entity = World_GetEntity(i)
		if Entity_IsCapturableBuilding(entity) and Entity_CanLoadSquad(entity, s_generic, false, false) and Util_GetDistance(Entity_GetPosition(entity), World_GetNearestInteractablePoint(Entity_GetPosition(entity))) < 1 then
			EGroup_Add(eg_PotSTs, entity)
		end
	end
	
	Rule_Add(STInit2)
	Rule_Add(OnInit)
end

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("mission/m02")
	Sound_PreCacheSinglePlayerSpeech("mission/m04")  
	Sound_PreCacheSinglePlayerSpeech("mission/m05")
	Sound_PreCacheSinglePlayerSpeech("mission/m13")
end

Scar_AddInit(Init_Audio)

function STInit2()
	if g_Init then
		Rule_RemoveMe()
		
		INIT_StrongpointObjective()
		INIT_ObjKillsObjective()
		
		print("Initialisation finished")
-------------------------------------------------------------------------
		g_MissionSpeechPath = "mission/m13"
		Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038619) -- LOCDB [11038619] 'The Germans have a strong defensive position ahead.' - 'Commissar'
-------------------------------------------------------------------------
		eg_ST1 = EGroup_CreateIfNotFound("eg_ST1")
		eg_ST2 = EGroup_CreateIfNotFound("eg_ST2")
		eg_ST3 = EGroup_CreateIfNotFound("eg_ST3")
		
		local temp = SGroup_CreateIfNotFound("temp")
		Player_GetAll(_german, temp)
		s_generic = SGroup_GetRandomSpawnedSquad(temp)
		Util_CreateSquads(_german, nil, BP_GetSquadBlueprint("howitzer_105mm_le_fh18_artillery_mp"), Util_GetRandomPosition(Entity_GetPosition(EGroup_GetRandomSpawnedEntity(eg_CptPs)), 25))
		
		Rule_Add(Rules)
	end
end

function Rules()
	Rule_RemoveMe()
	
	print("Setting up rules and variables")
	
	Objective_Start(obj_ST)
	Objective_Start(obj_Kills, false)
	
	g_deadSovietSoldiers = 0
	g_backupPartisans = 0
	g_killLimit_ger = 300
	g_GKillsForHeroes = 200
	
	Rule_Add(SetupST1)
	Rule_AddInterval(Check_GermanKills, 1)
	Rule_Add(Check_PartisanVictory)

	print("Rules and variables initialised")
end
	Scar_AddInit(STInit1)


function Check_PartisanVictory()
	if g_ST1_dead and g_ST2_dead and g_ST3_dead then
		Rule_RemoveAll()
		g_MissionSpeechPath = "mission/m05"
		Actor_PlaySpeech(ACTOR.Russian_Commissar, 11025752) -- LOCDB [11025752] 'Well done, Comrade Captain. This section of the city is now under our control.' - 'Churkin'
		Rule_AddOneShot(PartisanVictory, 10)
		
		for i = 1, World_GetPlayerCount() do
			local player = World_GetPlayerAt(i)
			
			if Player_GetRaceName(player) == "german" then
				local temp = SGroup_CreateIfNotFound("temp")
				Player_GetAll(player, temp)
				if not SGroup_IsEmpty(temp) then
					Cmd_Retreat(temp)
				end
				
				if AI_IsAIPlayer(player) then AI_Enable(player, false) end
				
				Player_SetAllCommandAvailabilityInternal(player, ITEM_LOCKED, Util_CreateLocString("You do not appear suited for command"))
			end
		end
		Objective_Show(SOBJ_ST1, false)
		Objective_Show(SOBJ_ST2, false)
		Objective_Show(SOBJ_ST3, false)
		Objective_Complete(obj_ST)
	end
end

function PartisanVictory()
	World_SetTeamWin(Player_GetTeam(_soviet))
end


function SetupST1()
	Rule_RemoveMe()
	
	e_ST1 = EGroup_GetRandomSpawnedEntity(eg_PotSTs)
	EGroup_Add(eg_ST1, e_ST1)
	EGroup_Remove(eg_PotSTs, e_ST1)
	
	sg_ST1 = SGroup_CreateIfNotFound("sg_ST1")
	
	while Entity_CanLoadSquad(e_ST1, s_generic, false, false) do
		Util_CreateSquads(_german, sg_ST1, {BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:obersoldaten_squad_uprising"), BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:mg42_squad_no_pop_cap_mp")}, eg_ST1)
	end
	for i = 1, SGroup_CountSpawned(sg_ST1) do
		if i <= SGroup_CountSpawned(sg_ST1) then
			local squad = SGroup_GetSpawnedSquadAt(sg_ST1, i)
			
			if Squad_GetBlueprint(squad) == BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:obersoldaten_squad_uprising") then
			Squad_IncreaseVeterancyRank(squad, World_GetRand(2, 4), true)
			elseif Squad_GetBlueprint(squad) == BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:mg42_squad_no_pop_cap_mp") then
				Squad_IncreaseVeterancyRank(squad, World_GetRand(1, 2), true)
			end
		end
	end
	SGroup_SetSelectable(sg_ST1, false)
	
	HP_ST1 = HintPoint_Add(eg_ST1, false, Util_CreateLocString("Strongpoint 1"))
	
	for i = 1, World_GetRand(2, 4) do
		local e_pos = Entity_GetPosition(e_ST1)
		local pos = Prox_GetRandomPosition(e_pos, 25, 5)
		Util_CreateEntities(_german, nil, BP_GetEntityBlueprint("axis_bunker_starting_position_mp"), Util_GetPositionFromAtoB(pos, e_pos, 1), 1, pos)
	end
	
	Rule_AddInterval(ST1_Rule, 1)
	Rule_Add(SetupST2)
end

function SetupST2()
	Rule_RemoveMe()
	
	e_ST2 = EGroup_GetRandomSpawnedEntity(eg_PotSTs)
	EGroup_Add(eg_ST2, e_ST2)
	EGroup_Remove(eg_PotSTs, e_ST2)
	
	sg_ST2 = SGroup_CreateIfNotFound("sg_ST2")
	
	while Entity_CanLoadSquad(e_ST2, s_generic, false, false) do
		Util_CreateSquads(_german, sg_ST2, {BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:obersoldaten_squad_uprising"), BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:mg42_squad_no_pop_cap_mp")}, eg_ST2)
	end
	
	for i = 1, SGroup_CountSpawned(sg_ST2) do
		if i <= SGroup_CountSpawned(sg_ST2) then
			local squad = SGroup_GetSpawnedSquadAt(sg_ST2, i)
			
			if Squad_GetBlueprint(squad) == BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:obersoldaten_squad_uprising") then
			Squad_IncreaseVeterancyRank(squad, World_GetRand(2, 4), true)
			elseif Squad_GetBlueprint(squad) == BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:mg42_squad_no_pop_cap_mp") then
				Squad_IncreaseVeterancyRank(squad, World_GetRand(1, 2), true)
			end
		end
	end
	SGroup_SetSelectable(sg_ST2, false)
	
	HP_ST2 = HintPoint_Add(eg_ST2, false, Util_CreateLocString("Strongpoint 2"))
	
	for i = 1, World_GetRand(2, 4) do
		local e_pos = Entity_GetPosition(e_ST2)
		local pos = Prox_GetRandomPosition(e_pos, 25, 5)
		Util_CreateEntities(_german, nil, BP_GetEntityBlueprint("axis_bunker_starting_position_mp"), Util_GetPositionFromAtoB(pos, e_pos, 1), 1, pos)
	end
	
	Rule_AddInterval(ST2_Rule, 1)
	Rule_Add(SetupST3)
end

function SetupST3()
	Rule_RemoveMe()
	
	e_ST3 = EGroup_GetRandomSpawnedEntity(eg_PotSTs)
	EGroup_Add(eg_ST3, e_ST3)
	EGroup_Remove(eg_PotSTs, e_ST3)
	
	sg_ST3 = SGroup_CreateIfNotFound("sg_ST3")
	
	while Entity_CanLoadSquad(e_ST3, s_generic, false, false) do
		Util_CreateSquads(_german, sg_ST3, {BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:obersoldaten_squad_uprising"), BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:mg42_squad_no_pop_cap_mp")}, eg_ST3)
	end
	
	for i = 1, SGroup_CountSpawned(sg_ST3) do
		if i <= SGroup_CountSpawned(sg_ST3) then
			local squad = SGroup_GetSpawnedSquadAt(sg_ST3, i)
			
			if Squad_GetBlueprint(squad) == BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:obersoldaten_squad_uprising") then
			Squad_IncreaseVeterancyRank(squad, World_GetRand(2, 4), true)
			elseif Squad_GetBlueprint(squad) == BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:mg42_squad_no_pop_cap_mp") then
				Squad_IncreaseVeterancyRank(squad, World_GetRand(1, 2), true)
			end
		end
	end
	SGroup_SetSelectable(sg_ST3, false)
	
	HP_ST3 = HintPoint_Add(eg_ST3, false, Util_CreateLocString("Strongpoint 3"))
	
	for i = 1, World_GetRand(2, 4) do
		local e_pos = Entity_GetPosition(e_ST3)
		local pos = Prox_GetRandomPosition(e_pos, 25, 5)
		Util_CreateEntities(_german, nil, BP_GetEntityBlueprint("axis_bunker_starting_position_mp"), Util_GetPositionFromAtoB(pos, e_pos, 1), 1, pos)
	end
	
	if AI_IsAIPlayer(_german) then
		local temp = SGroup_CreateIfNotFound("temp")
		Player_GetAll(_german, temp)
		
		for i = 1, SGroup_CountSpawned(temp) do
			local squad = SGroup_GetSpawnedSquadAt(temp, i)
			
			if Squad_GetBlueprint(squad) == BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:obersoldaten_squad_uprising") or Squad_GetBlueprint(squad) == BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:mg42_squad_no_pop_cap_mp") then
				AI_LockSquad(_german, squad)
			end
		end
	end
	
	Rule_AddInterval(ST3_Rule, 1)
end

function ST1_Rule()
	local b
	if SGroup_IsAlive(sg_ST1) then
		for i = 1, SGroup_CountSpawned(sg_ST1) do
			local group = SGroup_CreateIfNotFound("group")
			if not SGroup_IsEmpty(group) then SGroup_Clear(group) end
			SGroup_Add(group, SGroup_GetSpawnedSquadAt(sg_ST1, i))
			
			if not SGroup_IsInHoldEntity(group, true) then
				b = true
				Cmd_Garrison(group, eg_ST1, true, false, true)
			end
		end
	end
	if (Util_GetPlayerOwner(e_ST1) ~= _german and not b) or EGroup_IsEmpty(eg_ST1)  then
		Rule_RemoveMe()
		
		g_ST1_dead = true
		if not g_AnyST_dead then
			g_AnyST_dead = true
			g_MissionSpeechPath = "mission/m04"
			Actor_PlaySpeech(ACTOR.Russian_Commissar, 11022269) -- LOCDB [11022269] 'You perform like true Communists! But our work here isn't done yet, comrades.' - 'Commisar'
		end
		Objective_Complete(SOBJ_ST1)
		
		HintPoint_Remove(HP_ST1)
		
		if EGroup_IsEmpty(eg_ST1) and SGroup_IsAlive(sg_ST1) then
			SGroup_Kill(sg_ST1)
		end
		print("Strongpoint 1 wiped out")
	end
	if not g_ST1_Visible then
		for i = 1, World_GetPlayerCount() do
			local player = World_GetPlayerAt(i)
			
			if Player_GetRaceName(player) == "soviet" and Player_CanSeeEGroup(player, eg_ST1, true) then
				g_ST1_Visible = true
			end
		end
	else
		HintPoint_SetVisible(HP_ST1, true)
	end
end

function ST2_Rule()
	local b
	if SGroup_IsAlive(sg_ST2) then
		for i = 1, SGroup_CountSpawned(sg_ST2) do
			local group = SGroup_CreateIfNotFound("group")
			if not SGroup_IsEmpty(group) then SGroup_Clear(group) end
			SGroup_Add(group, SGroup_GetSpawnedSquadAt(sg_ST2, i))
			
			if not SGroup_IsInHoldEntity(group, true) then
				b = true
				Cmd_Garrison(group, eg_ST2, true, false, true)
			end
		end
	end
	if (Util_GetPlayerOwner(e_ST2) ~= _german and not b) or EGroup_IsEmpty(eg_ST2)  then
		Rule_RemoveMe()
		
		g_ST2_dead = true
		if not g_AnyST_dead then
			g_AnyST_dead = true
			g_MissionSpeechPath = "mission/m04"
			Actor_PlaySpeech(ACTOR.Russian_Commissar, 11022269) -- LOCDB [11022269] 'You perform like true Communists! But our work here isn't done yet, comrades.' - 'Commisar'
		end
		Objective_Complete(SOBJ_ST2)
		
		HintPoint_Remove(HP_ST2)
		
		if EGroup_IsEmpty(eg_ST2) and SGroup_IsAlive(sg_ST2) then
			SGroup_Kill(sg_ST2)
		end
		print("Strongpoint 2 wiped out")
	end
	if not g_ST2_Visible then
		for i = 1, World_GetPlayerCount() do
			local player = World_GetPlayerAt(i)
			
			if Player_GetRaceName(player) == "soviet" and Player_CanSeeEGroup(player, eg_ST2, true) then
				g_ST2_Visible = true
			end
		end
	else
		HintPoint_SetVisible(HP_ST2, true)
	end
end

function ST3_Rule()
	local b
	if SGroup_IsAlive(sg_ST3) then
		for i = 1, SGroup_CountSpawned(sg_ST3) do
			local group = SGroup_CreateIfNotFound("group")
			if not SGroup_IsEmpty(group) then SGroup_Clear(group) end
			SGroup_Add(group, SGroup_GetSpawnedSquadAt(sg_ST3, i))
			
			if not SGroup_IsInHoldEntity(group, true) then
				b = true
				Cmd_Garrison(group, eg_ST3, true, false, true)
			end
		end
	end
	if (Util_GetPlayerOwner(e_ST3) ~= _german and not b) or EGroup_IsEmpty(eg_ST3)  then
		Rule_RemoveMe()
		
		g_ST3_dead = true
		if not g_AnyST_dead then
			g_AnyST_dead = true
			g_MissionSpeechPath = "mission/m04"
			Actor_PlaySpeech(ACTOR.Russian_Commissar, 11022269) -- LOCDB [11022269] 'You perform like true Communists! But our work here isn't done yet, comrades.' - 'Commisar'
		end
		Objective_Complete(SOBJ_ST3)
		
		HintPoint_Remove(HP_ST3)
		
		if EGroup_IsEmpty(eg_ST3) and SGroup_IsAlive(sg_ST3) then
			SGroup_Kill(sg_ST3)
		end
		print("Strongpoint 3 wiped out")
	end
	if not g_ST3_Visible then
		for i = 1, World_GetPlayerCount() do
			local player = World_GetPlayerAt(i)
			
			if Player_GetRaceName(player) == "soviet" and Player_CanSeeEGroup(player, eg_ST3, true) then
				g_ST3_Visible = true
			end
		end
	else
		HintPoint_SetVisible(HP_ST3, true)
	end
end

function Check_GermanKills()
	local g_totalGKills = 0
	for i=1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		
		if Player_GetRaceName(player) == "german" then
			g_totalGKills = g_totalGKills + Stats_SoldiersKilled(player)
		end
	end
	g_totalGKills = g_totalGKills - (g_deadSovietSoldiers + g_backupPartisans)
	if g_totalGKills >= g_killLimit_ger then
		Rule_RemoveMe()
		Objective_Start(SOBJ_srrndr, false)
		Rule_AddInterval(Check_PartisansAlive, 1)
		Objective_UpdateText(obj_Kills, Util_CreateLocString("No Partisans left alive"), nil, false)
		Objective_Start(SOBJ_Kills)
		for i=1, World_GetPlayerCount() do
			local player = World_GetPlayerAt(i)
			
			if Player_GetRaceName(player) == "soviet" then
				Modify_PlayerResourceRate(player, RT_Manpower, 0)
				Player_SetResource(player, RT_Manpower, 0)
				local sg_temp = SGroup_CreateIfNotFound("sg_temp")
				Player_GetAll(player, sg_temp)
				if SGroup_IsEmpty(sg_temp) == false then
					FOW_RevealSGroupOnly(sg_temp, -1)
				end
			end
		end
	else
		Objective_UpdateText(obj_Kills, Util_CreateLocString("Partisans left: "..g_killLimit_ger - g_totalGKills), nil, false)
	end --[
	if g_totalGKills >= g_GKillsForHeroes and not g_heroesUnlocked then
		g_heroesUnlocked = true
		Player_AddAbility(_soviet, BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:bytnar_dispatch"))
		Player_AddAbility(_soviet, BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:pilecki_dispatch"))
		Player_AddAbility(_soviet, BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:zenczykowski_dispatch"))
	end --]]
end

function upr_updateSovietCounter()
	g_deadSovietSoldiers = g_deadSovietSoldiers + 1
end

function Check_PartisansAlive()
	local g_partisans_dead = true
	for i=1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		
		if Player_GetRaceName(player) == "soviet" then
			local sg_temp = SGroup_CreateIfNotFound("sg_temp")
			Player_GetAll(player, sg_temp)
			if not SGroup_IsEmpty(sg_temp) then
				g_partisans_dead = false
			end
		end
	end
	if g_partisans_dead then
		Rule_RemoveMe()
		World_PreEndGame()
	end
	if Objective_IsTimerSet(SOBJ_srrndr) then
		if Objective_GetTimerSeconds(SOBJ_srrndr) < 1 then
			Rule_RemoveMe()
			World_PreEndGame()
		end
	end
end

function World_PreEndGame()
	Rule_RemoveAll()
	g_MissionSpeechPath = "mission/m02"
	Actor_PlaySpeech(ACTOR.Russian_Commissar, 11041933) -- LOCDB [11041933] 'German forces have secured control of the area. Your failure will not be tolerated!' - 'Churkin'
	for i=1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		
		if Player_GetRaceName(player) == "soviet" then
			Player_SetAllCommandAvailabilityInternal(player, ITEM_LOCKED, Util_CreateLocString("We have failed..."))
			if AI_IsAIPlayer(player) then
				AI_Enable(player, false)
			end
			local sg_temp = SGroup_CreateIfNotFound("sg_temp")
			Player_GetAll(player, sg_temp)
			if SGroup_IsEmpty(sg_temp) == false then
				Cmd_Surrender(sg_temp, 0, Player_GetStartingPosition(_german), true, true)
				SGroup_SetInvulnerable(sg_temp, true)
				SGroup_SetSelectable(sg_temp, false)
				Camera_MoveTo(sg_temp, true, 0.1)
				sg_end = sg_temp
			end
		end
	end
	Objective_Fail(obj_ST, false)
	Rule_AddOneShot(World_EndGame, 10)
end

function World_EndGame()
	World_SetTeamWin(Player_GetTeam(_german))
	if SGroup_Exists("sg_end") then
		Camera_Follow(sg_end)
	end
end

function upr_callCommander1()
	if not g_commander_called then
		BP_Commander = BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:uprising_commander_behr_mp")
		g_cmd_type = "arm"
		Commander_Create()
	end
end

function upr_callCommander2()
	if not g_commander_called then
		BP_Commander = BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:uprising_commander_fellgiebel_mp")
		g_cmd_type = "art"
		Commander_Create()
	end
end

function upr_callCommander3()
	if not g_commander_called then
		BP_Commander = BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:uprising_commander_dennhardt_mp")
		g_cmd_type = "inf"
		Commander_Create()
	end
end

function Commander_Create()
	Util_MissionTitle(Util_CreateLocString("Commander arrived"))
	g_commander_called = true
	sg_commander = SGroup_CreateIfNotFound("sg_commander")
	Util_CreateSquads(_german, sg_commander, BP_Commander, Player_GetStartingPosition(_german))
	SGroup_SetInvulnerable(sg_commander, 0.1)
	Rule_AddInterval(Commander_CheckHealth, 1)
	if g_cmd_type == "art" then
		g_SpottingModeOn = false
		g_timeTilArty_standardValue = 30
		g_timeTilArty = g_timeTilArty_standardValue
		g_timeTilArty_checkInterval = 5
		--Rule_AddInterval(Commander_ArtilleryRule, g_timeTilArty_checkInterval)
	elseif g_cmd_type == "inf" then
		g_highManpower = false
		Rule_AddInterval(Commander_InfantryRule, 1)
	elseif g_cmd_type == "arm" then
		escort = {}
		sg_commander_escort = SGroup_CreateIfNotFound("sg_commander_escort")
		Rule_AddInterval(Commander_ArmourRule, 1)
	else
		fatal("Error initialising commander: no type assigned")
	end
end

function Commander_ArmourRule()
	if SGroup_IsAlive(sg_commander) then
		while SGroup_CountSpawned(sg_commander_escort) < 4 do 
			Util_CreateSquads(_german, sg_commander_escort, {BP_GetSquadBlueprint("scoutcar_sdkfz222_mp"), BP_GetSquadBlueprint("panzer_ii_luchs_squad_mp")}, upr_GetEntryPointByRace("german"), SGroup_GetPosition(sg_commander), 1, nil, false, SGroup_GetPosition(sg_commander), nil, SGroup_GetPosition(sg_commander))
		end
		for i=1, SGroup_CountSpawned(sg_commander_escort) do
			local squad = SGroup_GetSpawnedSquadAt(sg_commander_escort, i)
			
			if Util_GetDistance(squad, SGroup_GetPosition(sg_commander)) > 25 then
				local sg_temp = SGroup_CreateIfNotFound("sg_temp")
				if not SGroup_IsEmpty(sg_temp) then
					SGroup_Clear(sg_temp)
				end
				SGroup_Add(sg_temp, squad)
				Cmd_Move(sg_temp, Util_GetRandomPosition(SGroup_GetPosition(sg_commander), 25))
			end
		end
	else
		Rule_RemoveMe()
		Cmd_Retreat(sg_commander_escort, Player_GetStartingPosition(_german))
		Rule_Add(Commander_ArmourWithdraw)
		--Rule_AddOneShot(Commander_ArmourWithdraw2, 1)
	end
end

function Commander_ArmourWithdraw()
	if not SGroup_IsEmpty(sg_commander_escort) then
		for i=1, SGroup_CountSpawned(sg_commander_escort) do
			if i <= SGroup_CountSpawned(sg_commander_escort) then
				local squad = SGroup_GetSpawnedSquadAt(sg_commander_escort, i)
			
				if Util_GetDistance(squad, Player_GetStartingPosition(_german)) < 20 then
					Squad_Destroy(squad)
				end
			end
		end
	else
		Rule_RemoveMe()
	end
end

function Commander_InfantryRule()
	if World_IsPointInPlayerTerritory(_soviet, SGroup_GetPosition(sg_commander)) == true then
		if not g_highManpower then
			g_highManpower = true
			for i=1, World_GetPlayerCount() do
				local player = World_GetPlayerAt(i)
				
				if Player_GetRaceName(player) == "german" then
					Modify_PlayerResourceRate(player, RT_Manpower, 2)
				end
			end
		end
		FOW_RevealSGroupOnly(sg_commander, 1)
	else
		if g_highManpower then
			g_highManpower = false
			for i=1, World_GetPlayerCount() do
				local player = World_GetPlayerAt(i)
				
				if Player_GetRaceName(player) == "german" then
					Modify_PlayerResourceRate(player, RT_Manpower, 0.5)
				end
			end
		end
	end
end

function Commander_ArtilleryRule()
	g_timeTilArty = g_timeTilArty - g_timeTilArty_checkInterval
	
	if g_timeTilArty < 1 then
		g_timeTilArty = g_timeTilArty_standardValue
		if SGroup_IsAlive(sg_commander) == true then
			local sg_target = SGroup_CreateIfNotFound("sg_target")
			Util_GetSquadsByRace("soviet", SGroup_GetPosition(sg_commander), 45, sg_target)
			if not SGroup_IsEmpty(sg_target) then
				Cmd_Ability(_german, BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:uprising_commander_arty"), Squad_GetPosition(SGroup_GetRandomSpawnedSquad(sg_target)))
				for i=1, World_GetPlayerCount() do
					local player = World_GetPlayerAt(i)
					
					if Player_GetRaceName(player) == "german" then
						UI_CreateColouredSquadKickerMessage(player, SGroup_GetSpawnedSquadAt(sg_commander, 1), Util_CreateLocString("Firing artillery"), 0, 255, 0, 255)
					end
				end
			else
				for i=1, World_GetPlayerCount() do
					local player = World_GetPlayerAt(i)
					
					if Player_GetRaceName(player) == "german" then
						UI_CreateColouredSquadKickerMessage(player, SGroup_GetSpawnedSquadAt(sg_commander, 1), Util_CreateLocString("No targets found"), 255, 0, 0, 255)
					end
				end
			end
		else
			Rule_RemoveMe()
		end
	else
		for i=1, World_GetPlayerCount() do
			local player = World_GetPlayerAt(i)
			
			if Player_GetRaceName(player) == "german" then
				UI_CreateColouredSquadKickerMessage(player, SGroup_GetSpawnedSquadAt(sg_commander, 1), Util_CreateLocString("Checking for targets in "..g_timeTilArty.." seconds"), 255, 255, 0, 255)
			end	
		end
	end
end

function upr_commander_ArtToggleCheck()
	if not g_SpottingModeOn then
		Rule_AddInterval(Commander_ArtilleryRule, g_timeTilArty_checkInterval)
		Util_MissionTitle(Util_CreateLocString("Spotting mode on"))
	else
		Rule_Remove(Commander_ArtilleryRule)
		Util_MissionTitle(Util_CreateLocString("Spotting mode off"))
	end
	
	g_SpottingModeOn = not g_SpottingModeOn
end

function Commander_CheckHealth()
	if SGroup_GetAvgHealth(sg_commander) <= 0.11 then
		Cmd_Retreat(sg_commander, Player_GetStartingPosition(_german))
		Rule_Add(Commander_Withdraw)
		Rule_RemoveMe()
	end
end

function Commander_Withdraw()
	if Util_GetDistance(sg_commander, Player_GetStartingPosition(_german)) <= 20 then
		SGroup_DeSpawn(sg_commander)
		Rule_RemoveMe()
	end
end

function upr_callHero1()
	if not g_hero_called then
		g_hero_called = true
		g_hero_type = "sco"
		BP_hero = BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:bytnar_uprising")
		Hero_Create()
	end
end

function upr_callHero2()
	if not g_hero_called then
		g_hero_called = true
		g_hero_type = "int"
		BP_hero = BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:pilecki_uprising")
		Hero_Create()
	end
end

function upr_callHero3()
	if not g_hero_called then
		g_hero_called = true
		g_hero_type = "pro"
		BP_hero = BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:zenczykowski_uprising")
		Hero_Create()
	end
end

function Hero_Create()
	Player_SetAbilityAvailability(_soviet, {
		BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:bytnar_dispatch"),
		BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:pilecki_dispatch"),
		BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:zenczykowski_dispatch"),
		}, ITEM_REMOVED)
	sg_hero = SGroup_CreateIfNotFound("sg_hero")
	local sg_temp = SGroup_CreateIfNotFound("sg_temp")
	Player_GetAll(_soviet, sg_temp)
	local spawnpoint
	if SGroup_IsEmpty(sg_temp) then
		spawnpoint = upr_GetEntryPointByRace("soviet")
	else
		spawnpoint = Squad_GetPosition(SGroup_GetRandomSpawnedSquad(sg_temp))
	end
	Util_CreateSquads(_soviet, sg_hero, BP_hero, spawnpoint, World_Pos(0, 0, 0))
	
	if g_hero_type == "pro" then
		for i=1, World_GetPlayerCount() do
			local player = World_GetPlayerAt(i)
			
			if Player_GetRaceName(player) == "soviet" then
				Player_AddAbility(player, BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:inspire_propaganda_artillery_uprising"))
				Player_AddAbility(player, BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:fear_propaganda_artillery_uprising"))
			end
		end
	elseif g_hero_type == "sco" then
		g_backupPartisans = 100
		Player_AddAbility(_soviet, BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:gray_ranks_uprising"))
	elseif g_hero_type == "int" then
		Rule_AddInterval(Hero_IntelRule, 1)
	else
		fatal("Error initalising partisan hero: no type assigned")
	end
end

function Hero_IntelRule()
	if SGroup_IsAlive(sg_hero) then --[[
		if SGroup_Exists("sg_commander") then
			if not SGroup_IsEmpty(sg_commander) then
				FOW_RevealSGroupOnly(sg_commander, 1)
			end
		end --]]
		if SGroup_IsAlive(sg_ST1) then
			FOW_RevealSGroupOnly(sg_ST1, 1)
		end
		if SGroup_IsAlive(sg_ST2) then
			FOW_RevealSGroupOnly(sg_ST2, 1)
		end
		if SGroup_IsAlive(sg_ST3) then
			FOW_RevealSGroupOnly(sg_ST3, 1)
		end
		local HeroSec = World_GetTerritorySectorID(SGroup_GetPosition(sg_hero))
		for i=1, World_GetPlayerCount() do
			local player = World_GetPlayerAt(i)
			
			if Player_GetRaceName(player) == "german" then
				local sg_temp = SGroup_CreateIfNotFound("sg_temp")
				local sg_allGers = SGroup_CreateIfNotFound("sg_allGers")
				Player_GetAll(player, sg_temp)
				local function _checkIfInSector(gid, idx, sid)
					if World_GetTerritorySectorID(Squad_GetPosition(sid)) == HeroSec then
						SGroup_Add(sg_allGers, sid)
					end
				end
				SGroup_ForEach(sg_temp, _checkIfInSector)
				FOW_RevealSGroupOnly(sg_allGers, 1)
			end
		end
	else
		Rule_RemoveMe()
	end
end

function upr_GetEntryPointByRace(race)
	
	local eg_all_entry_points = EGroup_CreateIfNotFound("eg_all_entries")
	
	local _sg_temp = SGroup_CreateIfNotFound("_sg_temp")
	local _eg_all = EGroup_CreateIfNotFound("_eg_all")
	
	for i=1, World_GetPlayerCount() do
	
		local player = World_GetPlayerAt(i)
		
		if Player_GetRaceName(player) == race then
			Player_GetAll(player, _sg_temp, _eg_all)
			EGroup_Filter(_eg_all, BP_GetEntityBlueprint("map_entry_point"), FILTER_KEEP)
			
			EGroup_AddEGroup(eg_all_entry_points, _eg_all)
		end
	end
	
	return Entity_GetPosition(EGroup_GetRandomSpawnedEntity(eg_all_entry_points))

end
