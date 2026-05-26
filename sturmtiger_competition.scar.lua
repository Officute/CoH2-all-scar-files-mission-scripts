--FOW_Enable(false)

Lib_SetupMod("0716bced86c84890b04ce7d8ebc70da2", "SturmTigerMission", DEV_MODE)

ENCOUNTERS = {}
	
WAVES = {}

g_playerCount = 0
g_aliveSturmtigers = 0
g_currentWave = 0
g_lastWave = 10
g_encoutersPerWave = 0
g_encountersAlive = 0
g_playerSGroupName = "sg_player"
g_sturmtigerRespawnTime = 60
g_munition_event_running = false
g_next_muniton_event_time = 1
g_wait_munition_event = false
g_munition_event_patrol_time = 90
g_munition_event_delay = {min = 3 * 60, max = 6 * 60}
g_encounters = {}
g_sbp_sturmtiger = Mod_GetSquadBlueprint("sturmtiger_special")
g_ability_munition_drop = Mod_GetAbilityBlueprint("sturmtiger_munition_drop")
g_ability_flare = Mod_GetAbilityBlueprint("flare_artillery_special")
g_ability_stuka_at_strafe = Mod_GetAbilityBlueprint("stuka_antitank_strafe")
g_ability_fragmentation_run = Mod_GetAbilityBlueprint("fragmentation_run")
g_ebp_repair_truck = Mod_GetEntityBlueprint("sturmtiger_mech_truck")
g_ebp_hidden_hq = Mod_GetEntityBlueprint("sturmtiger_german_hq_invisible")
g_sbp_soviet_vehicle_crew = Mod_GetSquadBlueprint("soviet_vehicle_crew_squad_mp")
g_ability_vehicle_detection = Mod_GetAbilityBlueprint("vehicle_detection")
g_intro = 0
g_outro = 0
g_sturmCount = 0
g_winningTeam = 0
g_losingTeam = 1
g_activeMunitionEventConfig = nil
g_currentWaveMaxStrength = 0
g_currentWaveStrength = 0
g_waveProgressText = nil
g_retreatWave = false
__missionKnownSquads = {}
__autoAbandonCrewSBP["soviet"] = g_sbp_soviet_vehicle_crew
__missionScanEncountersEmpty = {}
g_munition_event_disabled = false
g_mission_already_won = false

SOUNDS = {
	INTRO_MOTIVATION = "sound/speech/mp/west_german/win/intel/playerability/xb_win_apl_vasgen_nt_s",
}
for key, sound in pairs(SOUNDS) do Sound_PreCacheSound(sound) end

LOCSTRINGS = {
	INTRO_OFFICER_NAME = "",
	INTRO_MOTIVATION = "Now is the time!  Give them death! Give them destruction.  Show them no mercy!",
	INTRO_01 = "Kummersdorf, April 21, 1945, 0500 hours",
	INTRO_02 = "Aerial recon has revealed Soviet 7th Mechanized Company approaching Kummersdorf.",
	INTRO_03 = "2nd Panzer Sturmmörser Company is ordered to defend Kummersdorf at all costs.",
	INTRO_04 = "Good luck, Kommandant.",
	OUTRO_WIN_01 = "2nd Panzer Sturmmörser Company successfully held Kummersdorf.",
	OUTRO_LOSE_01 = "2nd Panzer Sturmmörser Company held Kummersdorf for as long as it could.",
	OUTRO_WIN_02 = "A total of 18 Sturmtigers were produced during the war.",
	OUTRO_LOSE_02 = "A total of 18 Sturmtigers were produced during the war.",
	OUTRO_WIN_03 = "Only 3 of them are left today, and are on display in Germany, Russia, and UK.",
	OUTRO_LOSE_03 = "Only 3 of them are left today, and are on display in Germany, Russia, and UK.",
}
for key, text in pairs(LOCSTRINGS) do LOCSTRINGS[key] = Util_CreateLocString(text) end

ICONS = {
	INTRO_SPEECH_OFFICER = "Icons_portraits_dialogue_german_officer_s_portrait",
}

MissionConfig = {
	allowSturmtigerRespawnAlone = false,
	spawnSturmtigersForAIs = false,
	repairTruckDamageMultiplier = 0.15,
	enemySpawnDefendMarkers = {mrk_defend_spawn_01, mrk_defend_spawn_02, mrk_defend_spawn_03, mrk_defend_spawn_04, mrk_defend_spawn_05, mrk_defend_spawn_06, mrk_defend_spawn_07, mrk_defend_spawn_08 },
	enemySpawnDefendSpawnMarkers = {mkr_spawn_01, mkr_spawn_01, mkr_spawn_02, mkr_spawn_02, mkr_spawn_03, mkr_spawn_03, mkr_spawn_04, mkr_spawn_04 },
	enemySpawn17PounderMarkers = {mkr_pak43_01, mkr_pak43_02, mkr_pak43_03, mkr_pak43_04},
	enemyWaveSpawnMarkers = {mkr_spawn_01, mkr_spawn_02, mkr_spawn_03, mkr_spawn_04},
	repairstationMarkers = {mkr_repair_station_01, mkr_repair_station_02, mkr_repair_station_03, mkr_repair_station_04},
	enemySpawnPatrols = {
		{path = "wp_enemyspawn_01", spawn = mkr_spawn_01},
		{path = "wp_enemyspawn_02", spawn = mkr_spawn_04},
		{path = "wp_enemyspawn_03", spawn = mkr_spawn_03},
		{path = "wp_enemyspawn_04", spawn = mkr_spawn_02},
	},
	munitionDropLocations = {
		{mkr = mkr_muni_drop_01, spawn = mkr_spawn_muni_drop_01},
		{mkr = mkr_muni_drop_02, spawn = mkr_spawn_muni_drop_02},
		{mkr = mkr_muni_drop_03, spawn = mkr_spawn_muni_drop_03},
		{mkr = mkr_muni_drop_04, spawn = mkr_spawn_muni_drop_04},
		{mkr = mkr_muni_drop_05, spawn = mkr_spawn_muni_drop_05},
	},

	sturmTigerDestionations = {mkr_destination_01, mkr_destination_02, mkr_destination_03, mkr_destination_04},
	hiddenHqMarkers = {[0] = mkr_hidden_hq_team_1, [1] = mkr_hidden_hq_team_2},
	waveTitles = {
		"Calm Before the Storm",
		"Sieg",
		"Armor Rush",
		"Combined Arms",
		"Armor Rush #2",
		"Sword and Shield",
		"Take a Breather",
		"Heavy Hitters",
		"Combined Arms Redux",
		"Endsieg",
	},
	vehicleStrength = {
		{sbp = SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD_MP, strength = 1},
		{sbp = SBP.SOVIET.SU_76M_MP, strength = 2},
		{sbp = SBP.SOVIET.T_34_76_SQUAD_MP, strength = 3},
		{sbp = SBP.SOVIET.T_34_85_SQUAD_MP, strength = 5},
		{sbp = SBP.SOVIET.SU_85_MP, strength = 6},
		{sbp = SBP.SOVIET.KV_1_MP, strength = 6},
		{sbp = SBP.SOVIET.KV_2_MP, strength = 8},
		{sbp = SBP.SOVIET.IS_2_MP, strength = 9},
		{sbp = SBP.SOVIET.ISU_152_MP, strength = 10},
	},
}

DifficultyConfig = {
	MunitionIncomeMultiplier = {90/6, 75/6, 60/6, 50/6},
	StartingMunitions = {180, 120, 60, 0},
	EnemyReceivedDamage = {1.5, 1,25, 1, 1},
}

function Map_Init()
	World_RegisterPlayers() -- creates global variables player1, player2, player3, etc.
	enemyPlayer = Team_GetFirstPlayer(1)
	g_difficulty = AI_GetDifficulty(enemyPlayer)
	sg_all_sturmtigers = SGroup_CreateIfNotFound("sg_all_sturmtigers")
	sg_wave_units = SGroup_CreateIfNotFound("sg_wave_units")
	sg_munition_event_units = SGroup_CreateIfNotFound("sg_munition_event_units")
	g_skipIntro = false
	g_testOutro = false
	MunitionEventUnitsConfig()
	Mission_InitObjectives()
	Map_SetupEncounters()
	Map_SetupPlayers()
	Sound_PlayMusic("streamed/ambience_beds/battle_bg_dist_low", 2, 0)
	Players_ForEachInTeam(0, function(pid, idx, player)
		if Player_IsHuman(player) then
			g_sturmCount = g_sturmCount + 1
		end
	end)
	if not g_skipIntro then
		Map_Intro()
		Rule_AddInterval(Map_Intro, 1)
	else
		Mission_SpawnInitialSturmtiger(player1, Marker_GetPosition(mkr_sturmtiger_respawn))
		Rule_AddOneShot(Mission_Start, 1/8)
	end
	
	if g_skipIntro and g_testOutro then
		Mission_BeginOutro()
	end
end

function Mission_GetDifVar(data)
	--easy = 0, normal = 1, hard = 2, expert = 3
	--Msg("Returning " .. data[g_difficulty + 1] .. " with difficulty level " .. g_difficulty)
	return data[g_difficulty + 1]
end

function Map_Intro()
	if g_intro == 0 then
		Game_Letterbox(true, 0)
		Game_FadeToBlack(true, 0)
		Camera_MoveTo(mkr_sturmtiger_respawn)
	elseif g_intro == 1 then
		local squad = Mission_SpawnInitialSturmtiger(player1, Marker_GetPosition(mkr_sturmtiger_respawn))
		Player_ExecuteLocally(player1, function()
			Camera_FollowSquad(squad)
		end)
		Game_FadeToBlack(false, 5)
	elseif g_intro == 3 then 
		Util_GlobalMessage(LOCSTRINGS.INTRO_01, 4)
	elseif g_intro == 5 and g_sturmCount > 1 then
		local squad = Mission_SpawnInitialSturmtiger(player2, Marker_GetPosition(mkr_sturmtiger_respawn))
		Player_ExecuteLocally(player2, function()
			Camera_FollowSquad(squad)
		end)
	elseif g_intro == 9 and g_sturmCount > 2 then
		local squad = Mission_SpawnInitialSturmtiger(player3, Marker_GetPosition(mkr_sturmtiger_respawn))
		Player_ExecuteLocally(player3, function()
			Camera_FollowSquad(squad)
		end)
	elseif g_intro == 10 then
		Util_GlobalMessage(LOCSTRINGS.INTRO_02, 4)
	elseif g_intro == 13 and g_sturmCount > 3 then
		local squad = Mission_SpawnInitialSturmtiger(player4, Marker_GetPosition(mkr_sturmtiger_respawn))
		Player_ExecuteLocally(player4, function()
			Camera_FollowSquad(squad)
		end)
	elseif g_intro == 16 then
		Util_GlobalMessage(LOCSTRINGS.INTRO_03, 4)
	elseif g_intro == 22 then
		Util_GlobalMessage(LOCSTRINGS.INTRO_04, 4)
	elseif g_intro == 30 then
		Game_Letterbox(false, 3)
		Camera_SetInputEnabled(true)
		Rule_AddOneShot(Mission_Start, 1/8)
		
		Rule_RemoveMe()
	end

	g_intro = g_intro + 1
end


function Mission_SpawnInitialSturmtiger(player, pos)
	local squad = Squad_CreateAndSpawnToward(g_sbp_sturmtiger, player, 1, pos, World_Pos(0, 12, 0))
	local idx = Player_GetIndex(player)
	Rule_AddSquadEvent(Mission_SturmtigerDied, squad, GE_SquadKilled)
	local sgroupName = g_playerSGroupName .. idx
	
	local sgroup = SGroup_CreateIfNotFound(sgroupName)
	_G[sgroupName] = sgroup
	
	SGroup_Add(sgroup, squad)
	
	SGroup_Add(sg_all_sturmtigers, squad)
	g_aliveSturmtigers = g_aliveSturmtigers + 1
	
	Cmd_Move(sgroup, Marker_GetPosition(MissionConfig.sturmTigerDestionations[idx]))
	Player_ExecuteLocally(player, function()
		Misc_SelectSquad(squad, true)
	end)
	return squad
end

function Mission_Start()

	Rule_AddOneShot(Map_SetupEnemyDefences, 2)
	Rule_AddOneShot(Mission_StartMainObjective, 2)

	Rule_AddOneShot(StartMunitionEventObjective, 15)
	Rule_AddDelayedInterval(Mission_SpawnMunitionCrateEvents, 15, 1)
	Rule_AddDelayedInterval(Mission_WaveManager, 10, 1)
	Rule_AddInterval(Mission_ScanForNewEnemySquads, 1)
end

function Mission_StartMainObjective()
	Objective_Start(OBJ_Main)
end

function StartMunitionEventObjective()
	Objective_Start(OBJ_MunitionEvent, false)
	
end
function Mission_WaveManager()
	if g_encountersAlive == 0 then
		g_currentWave = g_currentWave + 1
		Objective_SetCounter(OBJ_Main, g_currentWave, g_lastWave)
		
		if g_currentWave > g_lastWave then
			--Msg("Encounters alive: 0 ")
			Objective_Complete(OBJ_Main)
			
			Util_DelaySeconds(3, function()
				g_winningTeam = 0
				g_losingTeam = 1
				g_mission_already_won = true
				Mission_BeginOutro()
			end)
			
			Rule_RemoveMe()
		else
			g_waveProgressText = Util_CreateLocString("Wave " .. g_currentWave .. " - " .. MissionConfig.waveTitles[g_currentWave])
			Util_GlobalMessage(g_waveProgressText, 5)
			Obj_ShowProgress(g_waveProgressText, 1)
			Mission_SpawnWave(WAVES[g_currentWave])
		end
	end
	
	g_currentWaveStrength = 0
	for key, enc in pairs(__missionScanEncountersEmpty) do
		local encounterIsDead = false
		if SGroup_CountSpawned(enc.sgroup) == 0 then
			encounterIsDead = true
		else
			local retreatingCount = 0
			local squadCount = 0
			SGroup_ForEach(enc.sgroup, function(sgid, idx, squad)
				squadCount = squadCount + 1
				if Squad_IsRetreating(squad) then
					retreatingCount = retreatingCount + 1
				end
			end)
			
			if retreatingCount == squadCount then
				encounterIsDead = true
			end
		end
		
		if encounterIsDead then
			Mission_ReportEncounterDead(enc)
			__missionScanEncountersEmpty[key] = nil
		else
			if g_retreatWave then
				--Msg("Retreating troops: " .. SGroup_CountSpawned(enc.sgroup) .. " to " .. Pos_GetString(enc.originalSpawnPos))
				
				SGroup_ForEach(enc.sgroup, function(sgid, idx, squad)
					Cmd_Retreat(Squad_GetTempSGroup(squad), enc.originalSpawnPos)
					AutoDelete_Add(squad, enc.originalSpawnPos, 10)
					--Msg("Retreated squad.")
				end)
			end
			
			local _strength = 0
			SGroup_ForEach(enc.sgroup, function(sgid, idx, squad)
				if Squad_IsVehicle(squad) then
					local sbp = Squad_GetBlueprint(squad)
					local found = false
					for key, item in pairs(MissionConfig.vehicleStrength) do
						if item.sbp == sbp then
							_strength = _strength + item.strength
							found = true
							break
						end
					end
					
					if not found then
						_strength = _strength + 3
					end
				else
					_strength = _strength + Squad_CountSpawned(squad)
				end
			end)
			g_currentWaveStrength = g_currentWaveStrength + _strength
		end
	end
	
	if g_currentWaveStrength > g_currentWaveMaxStrength then
		g_currentWaveMaxStrength = g_currentWaveStrength 
	end
	local percentage = g_currentWaveStrength / g_currentWaveMaxStrength
	Obj_ShowProgress(g_waveProgressText, percentage)
	
	if percentage < 0.20 and not g_retreatWave then
		--Msg("Autoretreat = true")
		g_retreatWave = true
	end
end

function Mission_SpawnWave(wave)
	Players_ForEachInTeam(0, function(pid, idx, player)
		if Player_IsHuman(player) then
		
			local target = Mission_GetPlayerSGroup(idx)
			
			if SGroup_IsEmpty(target) then
				target = Mission_GetNewAttackTarget()
			end
			g_retreatWave = false
			g_currentWaveMaxStrength = 0
			local waveSpawn = Marker_GetPosition(Table_GetRandomItem(MissionConfig.enemyWaveSpawnMarkers))
			local enc = wave(waveSpawn)
			enc.originalSpawnPos = waveSpawn
			Mission_RegisterEnemyUnits(enc.sgroup, enc.originalSpawnPos, enc)

			--SGroup_SetPosition(enc.sgroup, waveSpawn, 10)
			SGroup_ForEach(enc.sgroup, function(sgid, idx, squad)
				local pos = Marker_GetPosition(Table_GetRandomItem(MissionConfig.enemyWaveSpawnMarkers))
				Squad_SetPosition(squad, pos, pos)
			end)
			
			Mission_SetEncAttackGoal(enc, target)
			g_encounters[Player_GetUniqueKey(player)] = enc
			table.insert(__missionScanEncountersEmpty, enc)
			--enc:SetOnDeath(Mission_ReportEncounterDead)
			local arrow = ThreatArrow_CreateGroup(sg_wave_units)
			ThreatArrow_Add(arrow, sg_wave_units)
			Mission_ReportEncounterSpawned(enc)
		end
	end)
end

function Mission_RegisterEnemyUnits(sgroup, originalSpawnPos, enc)
	SGroup_ForEach(sgroup, function(sgid, idx, squad)
		Mission_RegisterKnownSquad(squad)
		local isVehicle = Squad_IsVehicle(squad)
		if not isVehicle and Squad_GetBlueprint(squad) ~= SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP then
			AutoRetreat_Add(squad, originalSpawnPos, AutoRetreatCondition.SquadHealth, 1/3, true, 10, enc)
		elseif isVehicle then
			Mission_RegisterEnemyVehicleSquad(squad)
		end
	end)
end

function Mission_RegisterEnemyVehicleSquad(squad)
	if not Squad_GetBlueprint(squad) ~= g_sbp_sturmtiger then
		AutoAbandon_Add(squad, {
			{crit = CRIT.VEHICLE_DESTROY_ENGINE, 			minHealth = 1/3, 	abandonDelay = {1, 5}, kill = true, killDelay = {3, 5}}, 
			{crit = CRIT.VEHICLE_DESTROY_ENGINE_REAR, 		minHealth = 1/3, 	abandonDelay = {1, 5}, kill = true, killDelay = {3, 5}}, 
			{crit = CRIT.VEHICLE_LOSE_TREADS_OR_WHEELS, 	minHealth = 0.5, 	abandonDelay = {1, 5}, kill = true, killDelay = {3, 5}}, 
			{crit = CRIT.VEHICLE_DESTROY_MAINGUN, 			minHealth = 1, 		abandonDelay = {1, 5}, kill = true, killDelay = {3, 5}}, 
			{crit = CRIT.VEHICLE_DESTROY_MAINGUN_RAMMING, 	minHealth = 1, 		abandonDelay = {1, 5}, kill = true, killDelay = {3, 5}}, 
		}, false, CRIT.VEHICLE_DECREW, true, nil, Player_GetStartingPosition(enemyPlayer))
	end
end

function Mission_SetEncAttackGoal(enc, target, spawn)
	enc:SetGoal({ 
		name = "Attack", 
		range = 15,
		leashRange = 10,
		coordinatedSetup = true,
		coordinatedMoveRadius = 10,
		retaliateAttacks = true,
		useSkirmishAI = true,
		garrison = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Recrew,
				priority = 50,
			},
			{
				tacticType = TACTIC_Pickup,
				priority = 100,
			},
			{
				tacticType = TACTIC_Avoid,
				priority = -1,
			},
		},
		target = target, 
		attackMove = false,
		maxIdleTime = 1,			
	})
end

function Mission_ReportEncounterDead(encounter)
	g_encountersAlive = g_encountersAlive - 1
	--Msg("Encounters alive: " .. g_encountersAlive)
end

function Mission_ReportEncounterSpawned(encounter)
	g_encountersAlive = g_encountersAlive + 1
	--Msg("Encounters alive: " .. g_encountersAlive)
end


function Map_SetupPlayers()
	EGroup_SetInvulnerable(eg_bridges, true)
	
	EGroup_ForEach(eg_all_repair_stations, function(egid, idx, entity)	
		EGroup_Add(eg_all_repair_stations, Entity_Replace(entity, g_ebp_repair_truck))
	end)

	Players_ForEach(function(pid, idx, player)
		local pos = Marker_GetPosition(MissionConfig.hiddenHqMarkers[Player_GetTeam(player)])
		Entity_CreateAndSpawnToward(g_ebp_hidden_hq, player, pos, pos, true, false)
	end)
	Players_ForEachInTeam(1, function(pid, idx, player)
		Player_SetResourcesEnabled(player, false, true)
	end)
	
	g_ability_caller_player = World_GetPlayerAt(1)
	Player_AddAbility(g_ability_caller_player, g_ability_munition_drop)
	--Cmd_Ability(g_ability_caller_player, g_ability_munition_drop, World_Pos(0, 12, 0))
	Players_ForEachInTeam(0, function(pid, idx, player)
		Player_ResetResources(player)
		Modify_PlayerResourceRate(player, RT_Manpower, 0)
		Modify_PlayerResourceRate(player, RT_Fuel, 0)
		Modify_PlayerResourceRate(player, RT_Munition, Mission_GetDifVar(DifficultyConfig.MunitionIncomeMultiplier))
		Player_SetResource(player, RT_Command, 0)
		Player_SetResource(player, RT_Munition, Mission_GetDifVar(DifficultyConfig.StartingMunitions))
		
		Player_ExecuteLocally(player, function()
			Objective_Start(OBJ_Respawn, false)
			Util_Delay(18, function()	
				Objective_Show(OBJ_Respawn, false)
			end)
			Util_DelaySeconds(3, function()	
				Objective_Show(OBJ_Respawn, false)
			end)
		end)
		if Player_IsHuman(player) or MissionConfig.spawnSturmtigersForAIs then
			Player_AddAbility(player, g_ability_flare)
			Player_AddAbility(player, g_ability_stuka_at_strafe)
			Player_AddAbility(player, g_ability_fragmentation_run)
			Player_AddAbility(player, g_ability_vehicle_detection)
			
			local startingPos = Player_GetStartingPosition(player)

			
			g_playerCount = g_playerCount + 1
			
		end
	end)
	
	g_encoutersPerWave = g_playerCount
end

function Sturmtigers_MunitionCrateSpawned(caster, target)
	--Msg("crate spawned!" .. scartype_tostring(caster) .. "|" .. scartype_tostring(target))
end

function Sturmtigers_MunitionCratePickedUp(caster, target)
	--Msg("crate picked up!" .. scartype_tostring(caster) .. "|" .. scartype_tostring(target))
	local owner = Squad_GetPlayerOwner(caster)
	
	if Player_GetTeam(owner) == 0 then
		Players_ForEachInTeam(0, function(pid, idx, player)
			Player_AddResource(player, RT_Munition, 30)
		end)
	end
end

function Mission_SpawnMunitionCrateEvents()
	if g_munition_event_disabled then
		Rule_RemoveMe()
		return
	end	
	if not g_munition_event_running and not g_wait_munition_event then
		g_next_muniton_event_time = World_GetRand(g_munition_event_delay.min, g_munition_event_delay.max)
		--Msg("Next event starts in " .. g_next_muniton_event_time)
		Objective_UpdateText(OBJ_MunitionEvent, OBJ_MunitionEvent.Title1, OBJ_MunitionEvent.Title1, true)
		Objective_StartTimer(OBJ_MunitionEvent, COUNT_DOWN, g_next_muniton_event_time)
		g_munition_event_running = true
	elseif g_munition_event_running then
		g_next_muniton_event_time = g_next_muniton_event_time - 1
		if g_next_muniton_event_time == 0 then
			g_munition_event_running = false
			g_wait_munition_event = true
			--Rule_Remove(Mission_SpawnMunitionCrateEvents)
			
			local eventConfig = Table_GetRandomItem(MissionConfig.munitionDropLocations)
			Cmd_Ability(g_ability_caller_player, g_ability_munition_drop, eventConfig.mkr)
			UI_CreateMinimapBlip(eventConfig.mkr, g_munition_event_patrol_time, BT_ObjectiveSecondary)
	
			Objective_StopTimer(OBJ_MunitionEvent)
			Objective_UpdateText(OBJ_MunitionEvent, OBJ_MunitionEvent.Title2, OBJ_MunitionEvent.Title2, true)

			local enc_MuniEvent = enc_MunitionEvent(eventConfig)
			SGroup_SetPosition(enc_MuniEvent.sgroup, Marker_GetPosition(eventConfig.spawn), 10)
			enc_MuniEvent.originalSpawnPos = Marker_GetPosition(eventConfig.spawn)
			Mission_RegisterEnemyUnits(enc_MuniEvent.sgroup, enc_MuniEvent.originalSpawnPos, enc_MuniEvent)
			
			Util_DelaySeconds(g_munition_event_patrol_time, function()
				g_wait_munition_event = false
				enc_MuniEvent:Disable()
				
				local retreatPos = Marker_GetPosition(eventConfig.spawn)
				Cmd_Retreat(sg_munition_event_units, retreatPos)
				AutoDelete_Add(sg_munition_event_units, retreatPos, 10)
				SGroup_Clear(sg_munition_event_units)
			end)
		end
	end
end

function Mission_ScanForNewEnemySquads()
	local sg_squads = Player_GetAllSquads(enemyPlayer)
	
	SGroup_ForEach(sg_squads, function(sgid, idx, squad)
		local key = Squad_GetUniqueKey(squad)
		if not __missionKnownSquads[key]then
			Mission_RegisterKnownSquad(squad, key)
			if Squad_IsVehicle(squad) then
				Mission_RegisterEnemyVehicleSquad(squad)
			end
			
			local damageModifier = Mission_GetDifVar(DifficultyConfig.EnemyReceivedDamage)
			if damageModifier > 1 then
				Modify_ReceivedDamage(Squad_GetTempSGroup(squad), damageModifier)
			end
		end
	end)
end

function Mission_RegisterKnownSquad(squad, key)
	key = key or Squad_GetUniqueKey(squad)
	__missionKnownSquads[key] = {squad = squad, squadId = Squad_GetGameID(squad)}
end

function Mission_RespawnPlayerSturmtiger(player, offmap)
	if (g_aliveSturmtigers > 0 or MissionConfig.allowSturmtigerRespawnAlone) and Player_IsHuman(player) then
		Player_ExecuteLocally(player, function()
			Util_GlobalMessage("You have received a new Sturmtiger", 4)
		end)
		
		g_aliveSturmtigers = g_aliveSturmtigers + 1
		
		local startingPos = Player_GetStartingPosition(player)
		local spawnPos = startingPos
		
		if offmap then
			spawnPos = Marker_GetPosition(mkr_sturmtiger_respawn)
		end
		
		local squad = Squad_CreateAndSpawnToward(g_sbp_sturmtiger, player, 1, spawnPos, startingPos)

		local sgroup = Mission_GetPlayerSGroup(player)
		
		Rule_AddSquadEvent(Mission_SturmtigerDied, squad, GE_SquadKilled)
		
		SGroup_Add(sgroup, squad)
		SGroup_Add(sg_all_sturmtigers, squad)
		
		Cmd_Move(sgroup, startingPos)
		Player_ExecuteLocally(player, function()
			Misc_SelectSquad(squad, true)
		end)
		local enc = g_encounters[Player_GetUniqueKey(player)]
		
		if enc and enc:IsAlive() then		
			Mission_SetEncAttackGoal(enc, Mission_GetPlayerSGroup(player))
		end
	end
end

function Mission_Outro()
	if g_outro == 0 then
		Game_FadeToBlack(true, 3)
		Game_Letterbox(true, 3)
	elseif g_outro == 4 then
		FOW_Enable(false)
		local camPos = World_Pos(0, 10, 0)
		Camera_MoveTo(camPos)
		Camera_AutoRotate(camPos, Camera_GetZoomDist(), math.deg(Camera_GetDeclination()), 0.4)
	elseif g_outro == 5 then
		Game_FadeToBlack(false, 5)
	elseif g_outro == 6 then
		if g_winningTeam == 0 then
			Util_GlobalMessage(LOCSTRINGS.OUTRO_WIN_01, 4)
			Sound_PlayStreamed("streamed/music/stingers/stinger_victory")
		else
			Util_GlobalMessage(LOCSTRINGS.OUTRO_LOSE_01, 4)
			Sound_PlayStreamed("streamed/music/stingers/stinger_defeat")
		end
	elseif g_outro == 14 then
		if g_winningTeam == 0 then
			Util_GlobalMessage(LOCSTRINGS.OUTRO_WIN_02, 4)
		else
			Util_GlobalMessage(LOCSTRINGS.OUTRO_LOSE_02, 4)
		end
	elseif g_outro == 20 then
		if g_winningTeam == 0 then
			Util_GlobalMessage(LOCSTRINGS.OUTRO_WIN_03, 4)
		else
			Util_GlobalMessage(LOCSTRINGS.OUTRO_LOSE_03, 4)
		end
	elseif g_outro == 30 then
		Game_Letterbox(false, 2)
		Camera_StopAutoRotating()
		Lib_GameOver(g_winningTeam, g_losingTeam)
	end
	
	
	g_outro = g_outro + 1
end

function Mission_BeginOutro()
	g_munition_event_disabled = true
	Rule_Remove(Mission_SpawnMunitionCrateEvents)
	Rule_Remove(Mission_WaveManager)
	Rule_RemoveAll()

	Objective_Show(OBJ_MunitionEvent, false)
	Objective_Show(OBJ_Respawn, false)
	Rule_AddInterval(Mission_Outro, 1)
	Sound_SetVolume("music", 1, 0)
end
function Mission_SturmtigerDied(caster)
	g_aliveSturmtigers = g_aliveSturmtigers - 1
	
	if g_aliveSturmtigers == 0 and not MissionConfig.allowSturmtigerRespawnAlone and not g_mission_already_won then
		g_winningTeam = 1
		g_losingTeam = 0
		Mission_BeginOutro()
	else
		local player = Squad_GetPlayerOwner(caster)
		
		Player_ExecuteLocally(player, function()
			Objective_Show(OBJ_Respawn, true)
			Objective_UpdateTitle(OBJ_Respawn, Util_CreateLocString("A new Sturmtiger will arrive in " .. g_sturmtigerRespawnTime .. " seconds."), true)
			
			Objective_StartTimer(OBJ_Respawn, COUNT_DOWN, g_sturmtigerRespawnTime)
			
			Util_Delay(4, function()
				Objective_UpdateTitle(OBJ_Respawn, Util_CreateLocString("A new Sturmtiger will arrive in "), false)
			end)
			Util_DelaySeconds(g_sturmtigerRespawnTime, function()
				Objective_Show(OBJ_Respawn, false)
			end)
		end)

		
		Util_DelaySeconds(g_sturmtigerRespawnTime, function()
			Mission_RespawnPlayerSturmtiger(player, true)
		end)
		
		local enc = g_encounters[Player_GetUniqueKey(player)]
		
		if enc and enc:IsAlive() then
			Mission_SetEncAttackGoal(enc, Mission_GetNewAttackTarget())
		end
	end
end

function Mission_GetNewAttackTarget()
	local target = sg_all_sturmtigers
	Msg("Target is sg_all_sturmtigers for now.. " .. SGroup_CountSpawned(sg_all_sturmtigers) .. ", repairtrucks: " .. EGroup_CountSpawned(eg_all_repair_stations))
	if SGroup_CountSpawned(sg_all_sturmtigers) == 0 then
		if EGroup_CountSpawned(eg_all_repair_stations) > 0 then
			Msg("nope, Target is now repair stations")
			target = eg_all_repair_stations
		else
			Msg("nope, Target is center of the map")
			target =  World_Pos(0, 12, 0)
		end
	end
	
	return target
end

function Map_SpawnEnemySpawnDefenders(spawn, path)
	local enc_EnemyDefences = enc_EnemySpawnDefences(spawn, path)
	SGroup_SetPosition(enc_EnemyDefences.sgroup, Marker_GetPosition(spawn), 10)
end

function Map_SetupEnemyDefences()

	for key, patrol in ipairs(MissionConfig.enemySpawnPatrols) do
		Map_SpawnEnemySpawnDefenders(patrol.spawn, patrol.path)
	end
end

function Mission_GetPlayerSGroup(playerIndex)
	if scartype(playerIndex) == ST_PLAYER then
		playerIndex = Player_GetIndex(playerIndex)
	end
	
	return _G[g_playerSGroupName .. playerIndex]
end