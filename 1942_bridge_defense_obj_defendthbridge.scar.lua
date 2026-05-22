-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- 1942 Bridge Defense
-- Objective File - Defend the Bridge
-- Designer: Ryan McGechaen

-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------
function DefendTheBridge_Init()

	--[[ REGISTER OBJECTIVES ]]
	Rule_AddOneShot(INIT_DefendTheBridge, 1)
	
	--[[ OBJECTIVE_KICKOFF ]]
	Event_NarrativeEventsNotRunning(DefendTheBridge_Kickoff, nil, 1)
	
	-- Define Variables
	tmr_bridgeNeutral_warning = "tmr_bridgeNeutral_warning"
	tmr_bridgeCapturing_warning = "tmr_bridgeCapturing_warning"
	
	g_mission_complete = false
	
	-- Ready Up Ability 
	g_ready_time = false -- variable used for ready up ability check
	t_ready_up_taunt = {EVENTS.Ready_Up_01, EVENTS.Ready_Up_02, EVENTS.Ready_Up_03}
	
	-- Bonus Objective Variables
	random_bonus_01 = World_GetRand(1,2)  -- variable used to pick random bonus objective
	
	bonus_01_completed = false
	bonus_02_completed = false
	bonus_03_active = false
	
	sg_bonus_ally_01 = SGroup_CreateIfNotFound("sg_bonus_ally_01")
	sg_bonus_ally_02 = SGroup_CreateIfNotFound("sg_bonus_ally_02")
	sg_transport_01 = SGroup_CreateIfNotFound("sg_transport_01")
	sg_bonus_escort_01 = SGroup_CreateIfNotFound("sg_bonus_escort_01")
	sg_bonus_ally_01 = SGroup_CreateIfNotFound("sg_bonus_ally_01")
	sg_bonus_ally_02 = SGroup_CreateIfNotFound("sg_bonus_ally_02")
	sg_bonus_enemy_01 = SGroup_CreateIfNotFound("sg_bonus_enemy_01")
	sg_bonus_enemy_02 = SGroup_CreateIfNotFound("sg_bonus_enemy_02")
	g_transport_alive = false
	
	-- Spawn Directions and movement locations
	t_north_retreat_points = {mkr_north_retreat_01, mkr_north_retreat_02, mkr_north_retreat_03}
	t_south_retreat_points = {mkr_south_retreat_01, mkr_south_retreat_02, mkr_south_retreat_03}

	t_direction_possibles = {
		{-- North Direction 01
			
			spawn_position = mkr_north_transport_01,
			position_01 = Util_GetPosition(mkr_patrol_north_01),
			position_02 = Util_GetPosition(mkr_patrol_north_02),
			position_03 = Util_GetPosition(mkr_patrol_north_03),
			position_04 = Util_GetPosition(mkr_patrol_north_04),
			position_05 = Util_GetPosition(mkr_patrol_north_05),
			retreat = t_north_retreat_points
		
		},
		{-- North Direction 02
		
			spawn_position = mkr_north_transport_02,
			position_01 = Util_GetPosition(mkr_patrol_north_01b),
			position_02 = Util_GetPosition(mkr_patrol_north_02b),
			position_03 = Util_GetPosition(mkr_patrol_north_03b),
			position_04 = Util_GetPosition(mkr_patrol_north_04b),
			position_05 = Util_GetPosition(mkr_patrol_north_05b),
			retreat = t_north_retreat_points
		},
		{ -- South Direction 01
			
			spawn_position = mkr_south_transport_01,
			position_01 = Util_GetPosition(mkr_patrol_south_01),
			position_02 = Util_GetPosition(mkr_patrol_south_02),
			position_03 = Util_GetPosition(mkr_patrol_south_03),
			position_04 = Util_GetPosition(mkr_patrol_south_04),
			position_05 = Util_GetPosition(mkr_patrol_south_05),
			retreat = t_south_retreat_points
		},
		{-- South Direction 02
		
			spawn_position = mkr_south_transport_02,
			position_01 = Util_GetPosition(mkr_patrol_south_01b),
			position_02 = Util_GetPosition(mkr_patrol_south_02b),
			position_03 = Util_GetPosition(mkr_patrol_south_03b),
			position_04 = Util_GetPosition(mkr_patrol_south_04b),
			position_05 = Util_GetPosition(mkr_patrol_south_05b),
			retreat = t_south_retreat_points
		},
	}
	
	t_direction = Table_GetRandomItem(t_direction_possibles)
	
	local rand = World_GetRand(1, #t_direction_possibles)
	t_chosen_direction = t_direction_possibles[rand]
	table.remove(t_direction_possibles, rand)
	
	Rule_AddInterval(Bonus_OBJ_Check, 1, 1000)
	Rule_AddInterval(Bonus_OBJ_02_Check, 1, 1000)
	Rule_AddInterval(Bonus_OBJ_03_Check, 1, 1000)
end

Scar_AddInit(DefendTheBridge_Init)

-------------------------------------------------------------------------
-- [[ REGISTER OBJECTIVE ]]
-------------------------------------------------------------------------
function INIT_DefendTheBridge()
	
	OBJ_DefendTheBridge = {
		Title = Loc_FormatText(11051684, Loc_ConvertNumber(t_difficulty.waves)), -- Objective Title
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		
			--[[Fires off before Objective Starts]]
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = nil,		-- Function to play if Intel_Start is Skipped
			-- Objective Starts
		SetupUI = function() 
			hpid_cp1 = Objective_AddUIElements(OBJ_DefendTheBridge, eg_bridge_cp_01, false, 11051679, false)
			hpid_cp2 = Objective_AddUIElements(OBJ_DefendTheBridge, eg_bridge_cp_02, false, 11051679, false)
		end,
		
		OnStart = function()
			Rule_Add(Mission_Fail_Check)
			Util_StartIntel(EVENTS.Intro)
		end,
		
			--[[Fires off before Objective Completes]]
		Intel_Complete = EVENTS.VPVictoryMessage,			-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = nil,	-- Function to play if Intel_Complete is Skipped
			-- Objective Completes
		OnComplete = function()
			
			
		end,
		
			--[[Fires off before Objective Fails]]
		Intel_Fail = EVENTS.Mission_Fail_Bridge_Lost,				-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = nil,		-- Function to play if Intel_Fail is Skipped
			-- Objective Fails
		OnFail = function()

		end,		
	}
	
	Objective_Register(OBJ_DefendTheBridge)
	
		--[[SUB-OBJECTIVES]]
	SOBJ_NextWave = {
		Title = Loc_FormatText(11051685, Loc_ConvertNumber(WaveDefense_GetWave()) ),
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		Parent = OBJ_DefendTheBridge,			-- Used for Sub-objectives, registers its' parent
		
			--[[Fires off before Objective Starts]]
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = nil,		-- Function to play if Intel_Start is Skipped
			-- Objective Starts
		SetupUI = function() 
			
		end,
		
		OnStart = function()

		end,
		
			--[[Fires off before Objective Completes]]
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = nil,	-- Function to play if Intel_Complete is Skipped
			-- Objective Completes
		OnComplete = function()

		end,
		
			--[[Fires off before Objective Fails]]
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = nil,		-- Function to play if Intel_Fail is Skipped
			-- Objective Fails
		OnFail = function()
			
		end,		
	}
	Objective_Register(SOBJ_NextWave)
	
	--[[SUB-OBJECTIVES]]
	SOBJ_CurrWave = {
		Title = Loc_FormatText(11051685, Loc_ConvertNumber(WaveDefense_GetWave()) ),
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		Parent = OBJ_DefendTheBridge,			-- Used for Sub-objectives, registers its' parent
		
			--[[Fires off before Objective Starts]]
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = nil,		-- Function to play if Intel_Start is Skipped
			-- Objective Starts
		SetupUI = function() 
			
		end,
		
		OnStart = function()
		
			
		end,
		
			--[[Fires off before Objective Completes]]
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = nil,	-- Function to play if Intel_Complete is Skipped
			-- Objective Completes
		OnComplete = function()
			
		end,
		
			--[[Fires off before Objective Fails]]
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = nil,		-- Function to play if Intel_Fail is Skipped
			-- Objective Fails
		OnFail = function()
			
		end,		
	}
	Objective_Register(SOBJ_CurrWave)
	
	OBJ_Bonus = {
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			Objective_StartTimer(OBJ_Bonus, COUNT_DOWN, 120)
			Rule_AddInterval(Bonus_01_Timer, 1)
		end,
		
		OnComplete = function()	
			Ally_01_Merge()
			Rule_Remove(Bonus_01_Timer)
			Objective_RemoveUIElements(OBJ_Bonus, Bonus_UI_01)
		end,
		
		OnFail = function()
			Bonus_Ally01_Retreat()
			Event_Timer(Bonus_Enc01_Retreat, nil, 5)
			Objective_RemoveUIElements(OBJ_Bonus, Bonus_UI_01)
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.Bonus,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = EVENTS.Bonus_Fail,				-- Event will play when obj fails but before UI is cleared
		Title = 11051680,
		Description = 0,			-- Objective Description
		TitleEnd = nil, -- LOCDB [11038785] 'Reinforcements inbound.'
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	Objective_Register(OBJ_Bonus)
	
	OBJ_Bonus_02 = {
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			Objective_StartTimer(OBJ_Bonus_02, COUNT_DOWN, 120)
			Rule_AddInterval(Bonus_02_Timer, 1, 1000)
		end,
		
		OnComplete = function()	
			Ally_02_Merge()
			Rule_Remove(Bonus_02_Timer)
			Objective_RemoveUIElements(OBJ_Bonus_02, Bonus_UI_02)
		end,
		
		OnFail = function()
			Bonus_Ally02_Retreat()
			Event_Timer(Bonus_Enc02_Retreat, nil, 5)
			Objective_RemoveUIElements(OBJ_Bonus_02, Bonus_UI_02)
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.Bonus,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = EVENTS.Bonus_Fail,				-- Event will play when obj fails but before UI is cleared
		Title = 11051680,
		Description = 0,			-- Objective Description
		TitleEnd = nil, -- LOCDB [11038785] 'Reinforcements inbound.'
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	Objective_Register(OBJ_Bonus_02)
	
	OBJ_Bonus_03 = {
		SetupUI = function() 
			
		end,
		
		OnStart = function()

		end,
		
		OnComplete = function()	
			Objective_RemoveUIElements(OBJ_Bonus_03, Bonus_UI_03)
			Player_AddResource(player1, RT_Manpower, 200)
			SGroup_DestroyAllSquads(sg_transport_01)
			g_transport_target = t_direction.position_05
			if bonus_03_active == true then
				bonus_escort_01:ClearGoal()
				bonus_03_active = false
			end
		end,
		
		OnFail = function()
			Objective_RemoveUIElements(OBJ_Bonus_03, Bonus_UI_03)
			SGroup_DestroyAllSquads(sg_transport_01)
			g_transport_target = t_direction.position_05
			if bonus_03_active == true then
				bonus_escort_01:ClearGoal()
				bonus_03_active = false
			end
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.Bonus_Transport,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = EVENTS.Bonus_Transport_Complete,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = EVENTS.Bonus_Transport_Fail,				-- Event will play when obj fails but before UI is cleared
		Title = 11051681,
		Description = 0,			-- Objective Description
		TitleEnd = nil, -- LOCDB [11038785] 'Reinforcements inbound.'
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	Objective_Register(OBJ_Bonus_03)
end

-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------
function DefendTheBridge_Kickoff()
	
	WaveDefense_SetObjectives(OBJ_DefendTheBridge, SOBJ_NextWave, SOBJ_CurrWave)
	WaveDefense_SetCommandSGroup(sg_e_wave_all)
	
	Objective_Start(OBJ_DefendTheBridge)
	
	Event_NarrativeEventsNotRunning(Start_Intermission, nil, 3)
	
	Rule_AddInterval(_captureWarning, 1)

end

-- Monitors for the fail conditions
function Mission_Fail_Check()	
	Player_GetAll(player1)
	SGroup_Filter(sg_allsquads, BP_GetSquadBlueprint("panzer_mg_squad"), FILTER_REMOVE)
	
	if SGroup_IsEmpty(sg_allsquads) then
		-- No more squads, give a few seconds then fail
		if not Rule_Exists(Mission_AllUnitsDead) then Rule_AddOneShot(Mission_AllUnitsDead, 5) end
	elseif Player_OwnsEGroup(player5, eg_bridge_cp, ANY) then
		Rule_RemoveMe()
		Mission_Objective_Fail()
	end
	
end

-- If the player loses all squads, he has a 5 second grace period to call in another
function Mission_AllUnitsDead()
	if (not SGroup_IsEmpty(sg_allsquads) and SGroup_IsRetreating(sg_allsquads, ALL)) or SGroup_IsEmpty(sg_allsquads) then
		Rule_Remove(Mission_Fail_Check)
		Mission_Objective_Fail()
	end
end

function Ready_Up() -- Ready Up Ability for Bridge Defense, skips intermission
	if g_ready_time == true then
		Player_AddResource(player1, RT_Manpower, Objective_GetTimerSeconds(__t_waveDefenseData.nextWaveObj))
		Event_Remove(eventID_intermissionTimer)
		End_Intermission()
		Util_StartIntel(Table_GetRandomItem(t_ready_up_taunt))
		g_ready_time = false
	end
end

function _enable_Ready_Up()
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("ready_up"), ITEM_UNLOCKED)
end

function _disable_Ready_Up()
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("ready_up"), ITEM_LOCKED)
end

--****Intermission****
-- Begins the intermission; the break between waves
function Start_Intermission()
	g_ready_time = true
	WaveDefense_NextWave()
	-- Grant Point Award on Wave Completion and enable ready up ability
	if WaveDefense_GetWave() ~= 1 then
		Player_AddResource(player1, RT_Manpower, t_difficulty.wavesReward)
		_enable_Ready_Up()
	end
	
	

	-- Check if we're done
	if WaveDefense_GetWave() == t_difficulty.waves+1 then
		g_mission_complete = true
		Objective_Complete(OBJ_DefendTheBridge)
		
		Objective_Show(SOBJ_NextWave, false)
		Objective_Show(SOBJ_CurrWave, false)
		
		Event_NarrativeEventsNotRunning(Mission_Complete, nil, 5)
		Event_Remove(eventID_intermissionTimer)
		
		-- End Mission Camera Setup
		Game_SetMode(UI_Cinematic)
		Camera_MoveTo(mkr_attack_southCapture, true, 0.05)
		
		Ally_End_Support_01()
		Event_Timer(Ally_End_Support_02, nil, 1)
		Ally_End_Support_03()
		Ally_End_Support_04()
		
		return
	end
	
	for k, v in pairs(t_attentionPoints) do
		if WaveDefense_GetWave() == v.wave then
			Util_MissionTitle(v.text, 2.5, 3, 2.5)
		end
	end

	-- Hide Curr Wave Obj 
	Objective_Show(SOBJ_CurrWave, false)
	if Rule_Exists(_enemyCounter) then Rule_Remove(_enemyCounter) end
	if Objective_IsCounterSet(SOBJ_CurrWave) then
		Objective_StopCounter(SOBJ_CurrWave)
	end
	
	local intTime = t_difficulty.intermissionTime

	if WaveDefense_GetWave() == 1 then
		intTime = intTime + 15
	end
	
	-- Setup Next Wave Obj
	
	Objective_StartTimer(SOBJ_NextWave, COUNT_DOWN, intTime, 20)
	Objective_UpdateText(SOBJ_NextWave, Loc_FormatText(11051685, Loc_ConvertNumber(WaveDefense_GetWave()) ), nil)
	Objective_Show(SOBJ_NextWave, true)
	
	WaveDefense_SelectSpawns()
	
	_disable_We_Surrender()
	-- Start countdown	
	eventID_intermissionTimer = Event_Timer(End_Intermission, nil, intTime)
end



-- Ends the intermission between waves
function End_Intermission()
	-- Disable Ready Up
	g_ready_time = false
	_disable_Ready_Up()
	
	-- Enable We Surrender!
	_enable_We_Surrender()
	
	-- Hide Next Wave Obj
	Objective_Show(SOBJ_NextWave, false)
	
	-- Show Next Wave Obj
	if not Objective_IsStarted(SOBJ_CurrWave) then
		Objective_Start(SOBJ_CurrWave, false)
	end
	Objective_UpdateText(SOBJ_CurrWave, Loc_FormatText(11051687, Loc_ConvertNumber(WaveDefense_GetWave()) ), nil)
	Objective_Show(SOBJ_CurrWave, true)
	
	-- Start next wave
	WaveDefense_SpawnWave()
	
	_objectiveTextUpdated = false
	Rule_AddDelayedInterval(_enemyCounter, 3, 1)
end

-- ****Bridge Functions****
-- Runs every second, check if the bridge is being captured
function _captureWarning()
	local cp1 = nil
	local cp2 = nil 
	
	cp1, cp2 = Util_GetCapturePointStatus()
	
	if cp1 == "ENEMY_OWNED" or cp2 == "ENEMY_OWNED" then
		Rule_RemoveMe()
		if Timer_Exists(tmr_bridgeNeutral_warning) then Timer_End(tmr_bridgeNeutral_warning) end
		if Timer_Exists(tmr_bridgeCapturing_warning) then Timer_End(tmr_bridgeCapturing_warning) end
		return
	elseif (cp1 == "ENEMY_CAPPING" or cp1 == "ENEMY_DECAPPING")
	  or (cp2 == "ENEMY_CAPPING" or cp2 == "ENEMY_DECAPPING") then
		_bridgeBeingCaptured_Warning()
		if Timer_Exists(tmr_bridgeNeutral_warning) then Timer_End(tmr_bridgeNeutral_warning) end
		return
	elseif (cp1 == "NEUTRAL" or cp2 == "NEUTRAL") then
		_bridgeNeutral()
		if Timer_Exists(tmr_bridgeCapturing_warning) then Timer_End(tmr_bridgeCapturing_warning) end
		return
	end
end

-- Bridge is being captured by the enemy
function _bridgeBeingCaptured_Warning()
	if Timer_Exists(tmr_bridgeCapturing_warning) == false then
		Timer_Start(tmr_bridgeCapturing_warning, 20)
		if g_mission_complete == false then
			Util_StartIntel(EVENTS.Enemy_Capturing_Bridge)
		end
	else
		if Timer_GetRemaining(tmr_bridgeCapturing_warning) == 0 then
			Timer_End(tmr_bridgeCapturing_warning)
		end
	end
end

-- Bridge is neutral and should be re-secured
function _bridgeNeutral()
	if Timer_Exists(tmr_bridgeNeutral_warning) == false then
		Timer_Start(tmr_bridgeNeutral_warning, 20)
		if g_mission_complete == false then
			Util_StartIntel(EVENTS.Bridge_Neutral)
		end
	else
		if Timer_GetRemaining(tmr_bridgeNeutral_warning) == 0 then
			Timer_End(tmr_bridgeNeutral_warning)
		end
	end
end

-- ****Information Functions****
-- Starts a counter when the enemy gets to a certain number to display next to the objective
function _enemyCounter()
	sg_allEnemies = SGroup_CreateIfNotFound("sg_allEnemies")
	
	Player_GetAll(player5, sg_allEnemies)
	local count = SGroup_TotalMembersCount(sg_allEnemies, true)
	if count <= 12 and not SGroup_IsRetreating(sg_allEnemies, ANY) then
		Objective_SetCounter(SOBJ_CurrWave, count)
		if not _objectiveTextUpdated then
			_objectiveTextUpdated = true
			Objective_UpdateText(SOBJ_CurrWave, Loc_FormatText(11051686, Loc_ConvertNumber(WaveDefense_GetWave()) ), nil, false)
		end
	end
end

-- **** Utilities ****
-- Returns the capture point state of the bridge VPs
function Util_GetCapturePointStatus()
	local cp1 = EGroup_GetSpawnedEntityAt(eg_bridge_cp_01, 1)
	local cp2 = EGroup_GetSpawnedEntityAt(eg_bridge_cp_02, 1)
	
	local cp1State = nil
	local cp2State = nil
	
	-- Neutral
	if World_OwnsEntity(cp1) then
		-- One part of the Bridge is neutral
		cp1State = "NEUTRAL"
	end
	
	if World_OwnsEntity(cp2) then
		-- One part of the Bridge is neutral
		cp2State = "NEUTRAL"
	end
	
	-- Decapping
	if Player_OwnsEntity(player1, cp1) then
		if Player_GetStrategicPointCaptureProgress(player5, cp1) > -1.0 and Player_GetStrategicPointCaptureProgress(player5, cp1) < 0 then
			cp1State = "ENEMY_DECAPPING"
		else
			cp1State = "PLAYER_OWNED"
		end
	end
	
	if Player_OwnsEntity(player1, cp2) then
		if Player_GetStrategicPointCaptureProgress(player5, cp2) > -1.0 and Player_GetStrategicPointCaptureProgress(player5, cp2) < 0 then
			cp2State = "ENEMY_DECAPPING"
		else
			cp2State = "PLAYER_OWNED"
		end
	end
	
	-- Capping
	if Player_GetStrategicPointCaptureProgress(player5, cp1) < 1.0 and Player_GetStrategicPointCaptureProgress(player5, cp1) > 0 then
		cp1State = "ENEMY_CAPPING"
	end
	
	if Player_GetStrategicPointCaptureProgress(player5, cp2) < 1.0 and Player_GetStrategicPointCaptureProgress(player5, cp2) > 0 then
		cp2State = "ENEMY_CAPPING"
	end
	
	-- Owned
	if Player_OwnsEntity(player5, cp1) then
		-- Mission lost
		cp1State = "ENEMY_OWNED"
	end
	
	if Player_OwnsEntity(player5, cp2) then
		-- Mission lost
		cp2State = "ENEMY_OWNED"
	end
	
	return cp1State, cp2State
	
end

------------------------------------
-- Bonus Objective Encounter Functions
------------------------------------

function Bonus_OBJ_Check()
	if WaveDefense_GetWave() == World_GetRand(4, 5) then 
		if random_bonus_01 == 1 then
			Bridge_Start_BonusObj()
			Rule_RemoveMe()
			bonus_01_completed = true
		elseif random_bonus_01 == 2 then
			Bridge_Start_BonusObj_02()
			Rule_RemoveMe()
			bonus_02_completed = true
		end
	end
end
function Bonus_01_Timer()
	if Objective_IsComplete(OBJ_Bonus) then 
		Rule_RemoveMe()
	elseif Objective_IsTimerSet(OBJ_Bonus) and Objective_GetTimerSeconds(OBJ_Bonus) == 0 then
		Objective_Fail(OBJ_Bonus)
		Rule_RemoveMe()
	elseif Objective_IsTimerSet(OBJ_Bonus) and SGroup_CountSpawned(sg_bonus_ally_01) == 0 then
		Objective_Fail(OBJ_Bonus)
		Rule_RemoveMe()
	end
end


function Bridge_Start_BonusObj()
	Objective_Start(OBJ_Bonus)
	
	Bridge_Bonus_Enemy_01()
	Bridge_Bonus_Ally_01()
	Rule_AddInterval(Bonus_01_Remove_Invul, 1, 1000)
	Bonus_UI_01 = Objective_AddUIElements(OBJ_Bonus, sg_bonus_ally_01, true, 11051682, true, 3, nil, HPAT_Objective)
end

function Bridge_Bonus_Enemy_01()

	Event_GroupLeftAlive(Bonus_Enc01_Retreat, nil,sg_bonus_enemy_01, 3, 0 )
	local encData = {
		player = player5,
		sgroups = {sg_bonus_enemy_01},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				slotItems = SLOT_ITEM.GRENADIER_MG42_LMG_MP,
				spawn = mkr_bonus_01_enemy,
				load = 3,
			},
			{
				sbp = SBP.GERMAN.PIONEER_SQUAD, 
				slotItems = SLOT_ITEM.PIONEER_FLAMETHROWER_MP,
				spawn = mkr_bonus_01_enemy,
				load = 1,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_bonus_01_enemy,
				load = 3,
			},
		},
		onDeath = nil,
	}
	bonus_enc_01 = Encounter:Create(encData)

	local goalData = {
		name = "Attack",
		target = mkr_bonus_01_enemy_dest,
		range = 15,
		leashRange = 30,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 200,
			},
		},
	}
	bonus_enc_01:SetGoal(goalData)
	SGroup_SetInvulnerable(sg_bonus_enemy_01, 1)
end
function Bonus_Enc01_Retreat()
	Objective_Complete(OBJ_Bonus)
	
	if SGroup_CountSpawned(sg_bonus_enemy_01) >= 1 then
		bonus_enc_01:Disable()
		Cmd_Retreat(sg_bonus_enemy_01, mkr_bonus_01_enemy, mkr_bonus_01_enemy)
	end
end

function Bridge_Bonus_Ally_01()
	
	local encData = {
		player = player3,
		sgroups = {sg_bonus_ally_01},
		units = {
			{
				sbp = SBP.SOVIET.TOW_BRIDGE_PARTISAN_SQUAD_BASE,
				spawn = mkr_bonus_01_ally,
				load = 4,
			},
			{
				sbp = SBP.SOVIET.TOW_BRIDGE_PARTISAN_SQUAD_BASE,
				spawn = mkr_bonus_01_ally,
				load = 4,
			},
		},
		onDeath = nil,
	}
	bonus_enc_ally_01 = Encounter:Create(encData)

	local goalData = {
		name = "Defend",
		target = mkr_bonus_01_ally_dest,
		range = 15,
		leashRange = 30,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 1000,
			},
		},
	}
	bonus_enc_ally_01:SetGoal(goalData)
	Modify_ReceivedDamage(sg_bonus_ally_01, 0.025)
	Modify_WeaponAccuracy(sg_bonus_ally_01, "hardpoint_01", 0.1)
end
function Bonus_Ally01_Retreat()
	if SGroup_CountSpawned(sg_bonus_ally_01) ~= 0 then
		bonus_enc_ally_01:Disable()
		Cmd_Retreat(sg_bonus_ally_01, mkr_ally_retreat_01, mkr_ally_retreat_01)
	end
end
function Ally_01_Merge()
	if SGroup_CountSpawned(sg_bonus_ally_01) ~= 0 then
		bonus_enc_ally_01:Disable()
		Util_SetPlayerOwner (sg_bonus_ally_01, player1)
		Util_StartIntel(EVENTS.Partisans)
		Modifier_RemoveAllFromSGroup(sg_bonus_ally_01)
	end
end


function Bonus_01_Remove_Invul()
	if SGroup_CanSeeSGroup(sg_allsquads ,sg_bonus_ally_01, ANY ) then
		SGroup_SetInvulnerable(sg_bonus_ally_01, false)
		SGroup_SetInvulnerable(sg_bonus_enemy_01, false)
		Rule_RemoveMe()
	end
end



------------------------------------
-- Bonus Objective 2 Functions
------------------------------------
function Bonus_OBJ_02_Check()
	if WaveDefense_GetWave() == World_GetRand(15, 16) then 
		if bonus_01_completed == false then
			Bridge_Start_BonusObj()
			Rule_RemoveMe()
			bonus_01_completed = true
		elseif bonus_02_completed == false then
			Bridge_Start_BonusObj_02()
			Rule_RemoveMe()
			bonus_02_completed = true
		end
	end
end
function Bridge_Start_BonusObj_02()
	Objective_Start(OBJ_Bonus_02)
	Bridge_Bonus_Enemy_02()
	Bridge_Bonus_Ally_02()
	Rule_AddInterval(Bonus_02_Remove_Invul, 1)
	Bonus_UI_02 = Objective_AddUIElements(OBJ_Bonus_02, sg_bonus_ally_02, true, 11051682, true, 3, nil, HPAT_Objective)
end
function Bonus_02_Timer()
	if Objective_IsComplete(OBJ_Bonus_02) then 
		Rule_RemoveMe()
	elseif Objective_IsTimerSet(OBJ_Bonus_02) and Objective_GetTimerSeconds(OBJ_Bonus_02) == 0 then
		Objective_Fail(OBJ_Bonus_02)
		Rule_RemoveMe()
	elseif Objective_IsTimerSet(OBJ_Bonus) and SGroup_CountSpawned(sg_bonus_ally_02) == 0 then
		Objective_Fail(OBJ_Bonus_02)
		Rule_RemoveMe()
	end
end

function Bridge_Bonus_Enemy_02()


	Event_GroupLeftAlive(Bonus_Enc02_Retreat, nil, sg_bonus_enemy_02, 3, 0 )
	local encData = {
		player = player5,
		sgroups = {sg_bonus_enemy_02},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				slotItems = SLOT_ITEM.GRENADIER_MG42_LMG_MP,
				spawn = mkr_bonus_02_enemy,
				load = 3,
			},
			{
				sbp = SBP.GERMAN.PIONEER_SQUAD, 
				slotItems = SLOT_ITEM.PIONEER_FLAMETHROWER_MP,
				spawn = mkr_bonus_02_enemy,
				load = 1,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_bonus_02_enemy,
				load = 3,
			},
		},
		onDeath = nil,
	}
	bonus_enc_02 = Encounter:Create(encData)

	local goalData = {
		name = "Attack",
		target = mkr_bonus_02_enemy_dest,
		range = 15,
		leashRange = 30,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 200,
			},
		},
	}
	bonus_enc_02:SetGoal(goalData)
	SGroup_SetInvulnerable(sg_bonus_enemy_02, 1)
end
function Bonus_Enc02_Retreat()
	Objective_Complete(OBJ_Bonus_02)
	if SGroup_CountSpawned(sg_bonus_enemy_02) >= 1 then
		bonus_enc_02:Disable()
		Cmd_Retreat(sg_bonus_enemy_02, mkr_bonus_02_enemy, mkr_bonus_02_enemy)
	end
end

function Bridge_Bonus_Ally_02()

	local encData = {
		player = player3,
		sgroups = {sg_bonus_ally_02},
		units = {
			{
				sbp = SBP.SOVIET.TOW_BRIDGE_PARTISAN_SQUAD_BASE,
				spawn = mkr_bonus_02_ally,
				load = 4,
			},
			{
				sbp = SBP.SOVIET.TOW_BRIDGE_PARTISAN_SQUAD_BASE,
				spawn = mkr_bonus_02_ally,
				load = 4,
			},
		},
		onDeath = nil,
	}
	bonus_enc_ally_02 = Encounter:Create(encData)

	local goalData = {
		name = "Defend",
		target = mkr_bonus_02_ally_dest,
		range = 15,
		leashRange = 30,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 1000,
			},
		},
	}
	bonus_enc_ally_02:SetGoal(goalData)
	
	Modify_ReceivedDamage(sg_bonus_ally_02, 0.025)
	Modify_WeaponAccuracy(sg_bonus_ally_02, "hardpoint_01", 0.1)
end
function Bonus_Ally02_Retreat()
	if SGroup_CountSpawned(sg_bonus_ally_02) >= 1 then
		bonus_enc_ally_02:Disable()
		Cmd_Retreat(sg_bonus_ally_02, mkr_ally_retreat_02, mkr_ally_retreat_02)
	end
end
function Ally_02_Merge()
	if SGroup_CountSpawned(sg_bonus_ally_02) >= 1 then
		bonus_enc_ally_02:Disable()
		Util_SetPlayerOwner (sg_bonus_ally_02, player1)
		Util_StartIntel(EVENTS.Partisans)
		Modifier_RemoveAllFromSGroup(sg_bonus_ally_02)
	end
end


function Bonus_02_Remove_Invul()
	if SGroup_CanSeeSGroup(sg_allsquads,sg_bonus_ally_02, ANY ) then
		SGroup_SetInvulnerable(sg_bonus_ally_02, false)
		SGroup_SetInvulnerable(sg_bonus_enemy_02, false)
	end
end
------------------------------------
-- Bonus Objective 3 Functions
------------------------------------
function Bonus_OBJ_03_Check()
	if WaveDefense_GetWave() == World_GetRand(10, 11) then 
			Bridge_Start_BonusObj_03()
			Rule_RemoveMe()
	end
end
function Bridge_Start_BonusObj_03()
	Objective_Start(OBJ_Bonus_03)
	g_transport_alive = true
	bonus_03_active = true
	Bridge_Bonus_Transport_01()
	Bridge_Transport_Escort_01()
	Bonus_UI_03 = Objective_AddUIElements(OBJ_Bonus_03, sg_transport_01, true, 11051683, true, 3, nil, HPAT_Objective)
end

function Bridge_BonusObj_03_Complete()
		if g_transport_alive == true then
			Objective_Complete(OBJ_Bonus_03)
			g_transport_alive = false
		end
end
function Bridge_Bonus_Transport_01()

	g_transport_target = sg_transport_01
	Util_CreateSquads (player5, sg_transport_01, SBP.SOVIET.ZIS_6_TRANSPORT_TRUCK, t_direction.spawn_position, t_direction.spawn_position, 1)
	
	SGroup_SetAnimatorState(sg_transport_01, "supplies_loaded", "full")
	Cmd_Move(sg_transport_01, Util_GetPosition(t_direction.position_01))
	Event_Proximity(North_Path_01, nil, sg_transport_01, t_direction.position_01, 5, ALL, 10)
	Event_GroupIsDead(Bridge_BonusObj_03_Complete, nil, sg_transport_01)
	Modify_ReceivedDamage(sg_transport_01, 0.85)
	Cmd_CriticalHit (player5, sg_transport_01, CRIT.VEHICLE_LIGHT_DAMAGE_ENGINE, 1) -- disable engine
end	

function Bridge_Transport_Escort_01()
	Rule_AddInterval(Escort_01_Retreat, 1)

	local encData = {
		player = player5,
		sgroups = {sg_bonus_escort_01},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				slotItems = SLOT_ITEM.GRENADIER_MG42_LMG_MP,
				spawn = t_direction.spawn_position,
				load = 3,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = t_direction.spawn_position,
				load = 3,
			},
		},
		onDeath = nil,
	}
	bonus_escort_01 = Encounter:Create(encData)
	Cmd_Move(sg_bonus_escort_01, Util_GetPosition(t_direction.position_01))

end

function Escort_Goal()
	local goalData = {
		name = "Defend",
		target = g_transport_target,
		range = 2,
		leashRange = 15,
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
	bonus_escort_01:SetGoal(goalData)
end

function Escort_01_Retreat()
	if SGroup_TotalMembersCount(sg_transport_01) == 0 or SGroup_TotalMembersCount(sg_bonus_escort_01) <= 2 then
		bonus_escort_01:ClearGoal()

		if SGroup_TotalMembersCount(sg_bonus_escort_01) ~= 0 then
			Cmd_Retreat(sg_bonus_escort_01, Util_GetClosestMarker(sg_bonus_escort_01, t_direction.retreat), Util_GetClosestMarker(sg_bonus_escort_01, t_direction.retreat))
			Rule_RemoveMe()
		end
	elseif Objective_IsFailed(OBJ_Bonus_03) then
		bonus_escort_01:ClearGoal()

		if SGroup_TotalMembersCount(sg_bonus_escort_01) ~= 0 then
			Cmd_Retreat(sg_bonus_escort_01, Util_GetClosestMarker(sg_bonus_escort_01, t_direction.retreat), Util_GetClosestMarker(sg_bonus_escort_01, t_direction.retreat))
			Rule_RemoveMe()
		end
	end
	
end

function North_Path_01()
	if SGroup_CountSpawned(sg_transport_01)  >= 1 then
		Cmd_Move(sg_transport_01, Util_GetPosition(t_direction.position_02))
		Event_Proximity(North_Path_02, nil, sg_transport_01, t_direction.position_02, 5, ALL, 10)
		Escort_Goal()
	end
end	

function North_Path_02()
	if SGroup_CountSpawned(sg_transport_01)  >= 1 then
		Cmd_Move(sg_transport_01, Util_GetPosition(t_direction.position_03))
		Event_Proximity(North_Path_03, nil, sg_transport_01, t_direction.position_03, 5, ALL, 10)
	end
end	

function North_Path_03()
	if SGroup_CountSpawned(sg_transport_01)  >= 1 then
		Cmd_Move(sg_transport_01, Util_GetPosition(t_direction.position_04))
		Event_Proximity(North_Path_04, nil, sg_transport_01, t_direction.position_04, 5, ALL, 10)
	end
end	

function North_Path_04()
	if SGroup_CountSpawned(sg_transport_01)  >= 1 then
		Cmd_Move(sg_transport_01, Util_GetPosition(t_direction.position_05))
		Event_Proximity(North_Path_05, nil, sg_transport_01, t_direction.position_05, 5, ALL)
		if SGroup_CountSpawned(sg_bonus_escort_01) >= 1 then
			bonus_escort_01:ClearGoal()
			Cmd_Move(sg_bonus_escort_01, Util_GetPosition(t_direction.position_05))
		end
	end
end	

function North_Path_05()
	if SGroup_CountSpawned(sg_transport_01)  >= 1 then
		SGroup_DestroyAllSquads(sg_transport_01)
		g_transport_target = t_direction.position_05
		Objective_Fail(OBJ_Bonus_03)
		g_transport_alive = false
	end
end	

------------------------------------
-- Mission End Ally
------------------------------------


function Ally_End_Support_01()
	sg_end_ally_01 = SGroup_CreateIfNotFound("sg_end_ally_01")
	sg_end_vehicle_01 = SGroup_CreateIfNotFound("sg_end_vehicle_01")
	sg_end_vehicle_02 = SGroup_CreateIfNotFound("sg_end_vehicle_02")
	local encData = {
		player = player3,
		sgroups = {sg_end_ally_01},
		units = {
			{
				sbp = SBP.SOVIET.T_70M,
				spawn = mkr_ally_end_01,
				load = 1,
			},
			{
				sbp = SBP.SOVIET.M5_HALFTRACK_SQUAD,
				spawn = mkr_ally_end_02,
				sgroups = {sg_end_vehicle_01},
				load = 1,
			},
			{
				sbp = SBP.SOVIET.M5_HALFTRACK_SQUAD,
				spawn = mkr_ally_end_03,
				sgroups = {sg_end_vehicle_02},
				load = 1,
			},
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				spawn = sg_end_vehicle_01,
				load = 5,
			},
		},
		onDeath = nil,
	}
	ally_end_01 = Encounter:Create(encData)

	local goalData = {
		name = "Defend",
		target = mkr_attack_northCapture,
		range = 10,
		leashRange = 15,
		attackMove = false,
	}
	ally_end_01:SetGoal(goalData)
end

function Ally_End_Support_02()
	sg_end_ally_02 = SGroup_CreateIfNotFound("sg_end_ally_02")
	local encData = {
		player = player3,
		sgroups = {sg_end_ally_02},
		units = {
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				spawn = mkr_ally_end_01b,
				dynamicSpawnTarget = mkr_ally_dyn_01b,
				load = 5,
			},
		},

		onDeath = nil,
	}
	ally_end_02 = Encounter:Create(encData)

	local goalData = {
		name = "Defend",
		target = mkr_attack_southCapture,
		range = 5,
		leashRange = 10,
		attackMove = false,
	}
	ally_end_02:SetGoal(goalData)
end

function Ally_End_Support_03()
	local encData = {
		player = player3,
		sgroups = {sg_end_ally_01},
		units = {
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				spawn = mkr_ally_end_04,
				dynamicSpawnTarget = mkr_ally_dyn_01,
				load = 5,
			},
		},
		onDeath = nil,
	}
	ally_end_03 = Encounter:Create(encData)

	local goalData = {
		name = "Defend",
		target = mkr_attack_southCapture_02,
		range = 5,
		leashRange = 10,
		attackMove = false,
	}
	ally_end_03:SetGoal(goalData)
end

function Ally_End_Support_04()
	local encData = {
		player = player3,
		sgroups = {sg_end_ally_02},
		units = {
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				spawn = mkr_ally_end_03b,
				dynamicSpawnTarget = mkr_ally_dyn_01b,
				load = 5,
			},
		},
		onDeath = nil,
	}
	ally_end_04 = Encounter:Create(encData)

	local goalData = {
		name = "Defend",
		target = mkr_attack_southCapture_03,
		range = 5,
		leashRange = 10,
		attackMove = false,
	}
	ally_end_04:SetGoal(goalData)
end
