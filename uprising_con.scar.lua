--import("ScarUtil.scar")
--import("uprising_core.scar")

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
	Scar_AddInit(OnInit)
	
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
	eg_AmmoBoxes = EGroup_CreateIfNotFound("eg_AmmoBoxes")
	--e_ammoBox = Entity_Create(BP_GetEntityBlueprint("supply_drop_manpower_ammunition"), World_GetPlayerAt(1), World_Pos(0, World_GetHeightAt(0, 0), 0), World_Pos(0, World_GetHeightAt(0, 0), 0))
	Rule_AddInterval(Generate_AmmoBoxes, 3)
-------------------------------------------------------------------------
	Rule_AddInterval(Check_PartisanKills, 1)
	g_battle_phase = 2
	--g_killLimit1 = 30
	g_killLimit2 = 30
	
	
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		
		if Player_GetRaceName(player) == "german" then
			Cmd_InstantUpgrade(player, {BP_GetUpgradeBlueprint("9d197160ccb545028db7d0bf1c944418:battle_phase_2_uprising_mp"), BP_GetUpgradeBlueprint("battle_phase_2_mp")})
		end
	end
	Objective_UpdateText(obj_BPhase, Util_CreateLocString("Current Battle Phase: 1"), nil, false)
end

function Generate_AmmoBoxes()
	if EGroup_Count(eg_AmmoBoxes) < 30 and World_GetRand(0, 10) < 8 then
		local Min = (World_GetWidth() < World_GetLength()) and World_GetWidth() or World_GetLength()
		Util_CreateEntities(nil, eg_AmmoBoxes, BP_GetEntityBlueprint("9d197160ccb545028db7d0bf1c944418:supply_drop_uprising"), World_GetNearestInteractablePoint(Util_GetRandomPosition(World_Pos(0, 0, 0), Min)), 1)
	end
end

function Check_PartisanKills()
	local g_totalPKills = 0
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		if Player_GetRaceName(player) == "soviet" then
			g_totalPKills = g_totalPKills + Stats_SoldiersKilled(player)
		end
	end --[[
	if g_totalPKills >= g_killLimit1 and g_battle_phase == 1 then
	end --]]
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
	end --[[
	if g_totalPKills >= g_killLimit1  and g_battle_phase == 1 then
		g_battle_phase = 2
		Util_MissionTitle(Util_CreateLocString("Battle Phase 1 has been launched"), 1, 3, 1)
		Objective_UpdateText(obj_BPhase, Util_CreateLocString("Current Battle Phase: "..g_battle_phase - 1), nil, false)
	else --]]
	if g_totalPKills >= g_killLimit2  and g_battle_phase == 2 then
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
































function INIT_ObjConvoyObjective()

	print("Initialising convoy Objective...")
		
	obj_Con = {
	
		SetupUI = function()
		end,
		
		OnStart = function()
			Objective_Start(SOBJ_ConGer, false)
			Objective_Start(SOBJ_ConPar, false)
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = Util_CreateLocString("The Germans need to safely escort their convoy to its destination"),
		Description = 0,
		Type = OT_Primary,
	}
	
	SOBJ_ConGer = {
		Parent = obj_Con,
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
		Type = OT_Secondary,
	}
	
	SOBJ_ConPar = {
		Parent = obj_Con,
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
		Type = OT_Secondary,
	}
	
	Objective_Register(obj_Con)
	Objective_Register(SOBJ_ConGer)
	Objective_Register(SOBJ_ConPar)
end

function INIT_ObjTimerObjective()

	print("Initialising timer Objective...")
		
	obj_tmr = {
	
		SetupUI = function()
			UI_ConDest = Objective_AddUIElements(obj_Con, g_ConDest, true, Util_CreateLocString("Convoy's destination"), true, 3.5)
			UI_ConStart = Objective_AddUIElements(obj_Con, g_ConStart, true, Util_CreateLocString("The Convoy will arrive here"), true, 3.5)
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
	
	Objective_Register(obj_tmr)
end

function Init_Con()
	INIT_ObjConvoyObjective()
	INIT_ObjTimerObjective()
	for i=1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		
		if Player_GetRaceName(player) == "german" then
			_german = player
		end
	end
	Player_AddAbility(_german, BP_GetAbilityBlueprint("9d197160ccb545028db7d0bf1c944418:convoy_toggle"))
	
	g_ConStart = World_GetNearestInteractablePoint(Prox_GetRandomPosition(World_Pos(0, 0, 0), math.min(World_GetLength(), World_GetWidth()), math.min(World_GetLength(), World_GetWidth()) - 20))
	g_ConDest = Convoy_GetDest()
	g_NumTrucks = World_GetRand(1, 5)
	if g_NumTrucks % 2 == 0 then
		g_NumTrucks = g_NumTrucks + 1
	end
	
	--Sound_Play("test/vcl1")
	
	Objective_Start(obj_tmr, false)
	
	Timer_Start("tmr_con", 180)
	Rule_Add(Convoy_Spawn)
	
	eg_radioTowers = EGroup_CreateIfNotFound("eg_radioTowers")
	World_GetStrategyPoints(eg_radioTowers, true)
	EGroup_Filter(eg_radioTowers, BP_GetEntityBlueprint("9d197160ccb545028db7d0bf1c944418:radio_tower_point_uprising_mp"), FILTER_KEEP)
	EGroup_SetStrategicPointNeutral(eg_radioTowers)
	
	Rule_AddInterval(Radios_Check, 1)
end
	Scar_AddInit(Init_Con)

function Init_Audio()
	Sound_PreCacheSoundFolder("single_player/m11") 
	Sound_PreCacheSinglePlayerSpeech("mission/m11")
	g_MissionSpeechPath = "mission/m11"
end

Scar_AddInit(Init_Audio)

function ConObj_Update()
	if g_GerScore < math.ceil(g_NumTrucks/2) then
		Objective_UpdateText(SOBJ_ConGer, Util_CreateLocString("The Germans need to secure at least "..math.ceil(g_NumTrucks/2).." trucks ("..g_GerScore.."/"..math.ceil(g_NumTrucks/2)..")"), nil, false)
	else
		Objective_UpdateText(SOBJ_ConGer, Util_CreateLocString("The Germans need to secure at least "..math.ceil(g_NumTrucks/2).." trucks ("..math.ceil(g_NumTrucks/2).."/"..math.ceil(g_NumTrucks/2)..")"), nil, false)
		Objective_Complete(SOBJ_ConGer)
		Objective_Fail(SOBJ_ConPar)
		Camera_MoveTo(g_ConDest, true, 0.05, true, true)
		World_SetTeamWin(Player_GetTeam(_german))
		AI_EnableAll(false)
		for i = 1, World_GetPlayerCount() do
			local player = World_GetPlayerAt(i)
			
			if Player_GetRaceName(player) == "soviet" then
				local sg_temp = SGroup_CreateIfNotFound("sg_temp")
				Player_GetAll(player, sg_temp)
				Cmd_Retreat(sg_temp, upr_GetEntryPointByRace("soviet"))
			end
		end
		Rule_RemoveAll(900)
		Actor_PlaySpeech(ACTOR.Partisans, 11036747)  -- LOCDB [11036747] 'Enemy transport is on the move!' - 'Partisans'
	end
	g_ParScore = g_NumTrucks - (SGroup_CountSpawned(sg_ConvoyTrucks) + g_GerScore)
	if g_ParScore < math.ceil(g_NumTrucks/2) then
		Objective_UpdateText(SOBJ_ConPar, Util_CreateLocString("The Partisans need to destroy at least "..math.ceil(g_NumTrucks/2).." trucks ("..g_ParScore.."/"..math.ceil(g_NumTrucks/2)..")"), nil, false)
	else
		Objective_UpdateText(SOBJ_ConPar, Util_CreateLocString("The Partisans need to destroy at least "..math.ceil(g_NumTrucks/2).." trucks ("..math.ceil(g_NumTrucks/2).."/"..math.ceil(g_NumTrucks/2)..")"), nil, false)
		Objective_Complete(SOBJ_ConPar)
		Objective_Fail(SOBJ_ConGer)
		World_SetTeamWin(Player_GetTeam(_soviet))
		for i = 1, World_GetPlayerCount() do
			local player = World_GetPlayerAt(i)
			
			if Player_GetRaceName(player) == "german" then
				local sg_temp = SGroup_CreateIfNotFound("sg_temp")
				Player_GetAll(player, sg_temp)
				Cmd_Retreat(sg_temp, upr_GetEntryPointByRace("german"))
			end
		end
		Rule_RemoveAll(900)
		
		Actor_PlaySpeech(ACTOR.Partisans_Female, 11036908)  -- LOCDB [11036908] 'I am glad to have you with me, brothers. We do this bloody work for the good of Polska.' - 'Ania'
		--~Actor_PlaySpeech(ACTOR.Partisans, 11046938)  -- LOCDB [11036909] 'For Polska.' - 'Partisans'
	end
end

function Convoy_GetDest()
	local pot_pos = World_GetNearestInteractablePoint(Prox_GetRandomPosition(World_Pos(0, 0, 0), math.max(World_GetLength(), World_GetWidth()), math.min(World_GetLength(), World_GetWidth()) - 20))
	if Util_GetDistance(pot_pos, g_ConStart) <= math.min(World_GetLength(), World_GetWidth())/2 then
		return Convoy_GetDest()
	else
		return pot_pos
	end
end

function Convoy_Spawn()
	if Timer_GetRemaining("tmr_con") <= 0 then
		Rule_RemoveMe()
		Timer_End("tmr_con")
		Objective_Show(obj_tmr, false)
		Objective_RemoveUIElements(obj_tmr, UI_ConStart)
		
		sg_Convoy = SGroup_CreateIfNotFound("sg_Convoy")
		sg_ConvoyTrucks = SGroup_CreateIfNotFound("sg_ConvoyTrucks")
		local NumTanks = g_NumTrucks - 1
		if NumTanks == 0 then NumTanks = 1 end
		Util_CreateSquads(_german, {sg_Convoy, sg_ConvoyTrucks}, {BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:opel_blitz_squad_uprising"), BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:opel_blitz_truck_squad_uprising")}, Util_GetRandomPosition(g_ConStart, 5), g_ConDest, g_NumTrucks, nil, false, g_ConDest, nil, g_ConDest)
		Util_CreateSquads(_german, sg_Convoy, {BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:panzer_iv_squad_uprising"), BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:panther_squad_uprising"), BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:ostwind_squad_uprising")}, Util_GetRandomPosition(g_ConStart, 5), g_ConDest, NumTanks, nil, false, g_ConDest, nil, g_ConDest)
		Modify_UnitSpeed(sg_Convoy, 0.5)
		FOW_RevealSGroupOnly(sg_Convoy, -1)
		Rule_Add(Convoy_Rule, 1000)
		Rule_AddInterval(Convoy_RuleInterval, 1, 1000)
		
		if World_GetRand(1, 2) < 2 then
			Actor_PlaySpeech(ACTOR.Partisans, 11034482) -- LOCDB [11034482] 'Enemy vehicles incoming!' - 'Partisans'
		else
			Actor_PlaySpeech(ACTOR.Russian_Commissar, 11046698)   -- LOCDB [11046698] 'Trucks are coming your way. Be prepared!' - 'Pozharsky'
		end
		
		Objective_Start(obj_Con)
		Rule_AddInterval(ConObj_Update, 1)
		g_ParScore = 0
		g_GerScore = 0
		-- g_ConvoyFortified = false
	
		Convoy = {}
		Convoy.squads = {}
		Convoy.groups = {}
		Convoy.timers = {}
		for i = 1, SGroup_CountSpawned(sg_Convoy) do
			Convoy.squads[i] = SGroup_GetSpawnedSquadAt(sg_Convoy, i)
			Convoy.groups[i] = SGroup_CreateIfNotFound("sg_Convoy"..i)
			SGroup_Add(Convoy.groups[i], Convoy.squads[i])
			Convoy.timers[i] = 20
		end
	else
		Objective_UpdateText(obj_tmr, Util_CreateLocString("The convoy will arrive in "..math.floor(Timer_GetRemaining("tmr_con")/60)..":"..math.floor(math.floor(Timer_GetRemaining("tmr_con") % 60)/10)..math.floor(Timer_GetRemaining("tmr_con") % 60) - math.floor(math.floor(Timer_GetRemaining("tmr_con") % 60)/10) * 10), nil, false)
	end
end

function Convoy_Rule()
	if not SGroup_IsEmpty(sg_Convoy) then
		if not g_ConvoyStopped then
			if g_ConvoyFortified then
				g_ConvoyFortified = false
				Modifier_Remove(mod_Con)
				SGroup_CreateKickerMessage(sg_Convoy, _german, Util_CreateLocString("Fortification cancelled"))
			end
			Cmd_Move(sg_Convoy, g_ConDest)
		else
			if not g_ConvoyFortified then
				g_ConvoyFortified = true
				mod_Con = Modify_Vulnerability(sg_Convoy, 0.8)
				SGroup_CreateKickerMessage(sg_Convoy, _german, Util_CreateLocString("Fortifying"))
			end
			Cmd_Stop(sg_Convoy)
		end
		for i = 1, #Convoy.groups do
			if SGroup_IsAlive(Convoy.groups[i]) then
				local squad = Convoy.squads[i]
				
				if Util_GetDistance(squad, g_ConDest) <= 7.5 then
					if Squad_GetBlueprint(squad) == BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:opel_blitz_squad_uprising") or Squad_GetBlueprint(squad) == BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:opel_blitz_truck_squad_uprising") then
						g_GerScore = g_GerScore + 1
					end
					Squad_Destroy(squad)
				end
			end
		end
	else
		Rule_RemoveMe()
	end
end

function Convoy_RuleInterval()
	if not SGroup_IsEmpty(sg_Convoy) then
		for i = 1, #Convoy.groups do
			if SGroup_IsAlive(Convoy.groups[i]) then
				local squad = Convoy.squads[i]
				
				if Util_GetDistance(squad, g_ConDest) <= 60 then
					if Convoy.timers[i] < 1 then
						if Squad_GetBlueprint(squad) == BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:opel_blitz_squad_uprising") or Squad_GetBlueprint(squad) == BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:opel_blitz_truck_squad_uprising") then
						g_GerScore = g_GerScore + 1
						end
						Squad_Destroy(squad)
					else
						Convoy.timers[i] = Convoy.timers[i] - 1
					end
				end
			end
		end
	else
		Rule_RemoveMe()
	end
end

function upr_ToggleConvoy()
	g_ConvoyStopped = not g_ConvoyStopped
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


do
local BP_Commander

function upr_callCommander1()
	if g_commander_called == false then
		BP_Commander = BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:uprising_commander_behr_mp")
		g_cmd_type = "arm"
		Commander_Create()
	end
end

function upr_callCommander2()
	if g_commander_called == false then
		BP_Commander = BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:uprising_commander_fellgiebel_mp")
		g_cmd_type = "art"
		Commander_Create()
	end
end

function upr_callCommander3()
	if g_commander_called == false then
		BP_Commander = BP_GetSquadBlueprint("9d197160ccb545028db7d0bf1c944418:uprising_commander_dennhardt_mp")
		g_cmd_type = "inf"
		Commander_Create()
	end
end

function Commander_Create()
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

--[[		
function Commander_ArmourWithdraw2()
	Rule_Add(Commander_ArmourWithdraw)
end --]]

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

function Util_GetSquadsByRace(race, pos, radius, group)
	for i=1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		
		if Player_GetRaceName(player) == race then
			local sg_temp = SGroup_CreateIfNotFound("sg_temp")
			Player_GetAll(player, sg_temp)
			
			local _filterByDistance = function(gid, idx, sid)
				if Util_GetDistance(Squad_GetPosition(sid), pos) <= radius then 
					SGroup_Add(group, sid)
				end
			end
			
			SGroup_ForEach(sg_temp, _filterByDistance)
		end
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
