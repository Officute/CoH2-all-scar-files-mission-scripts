-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- MISSION NAME
-- Objective File - EXAMPLE
-- Designer: Joe Smith

-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------
function MissionObjective_Init()

	-- tables
	
	-- Objective Variables

	g_silver = 1 -- Goal Variable for Initial Objective
	g_gold = 1 -- Goal Variable for Finale Objective
	g_count = 0
	g_point_count = 0
	g_point_goal = 2
	
	g_wave_count = 1 -- Wave Finale Objective
	g_wave_goal = 5 -- Wave Finale Objective
	-- Bonus Variables
	
	--[[ REGISTER OBJECTIVES ]]
	Initialize_Objectives()
	Minimap_Objectives()
	
	--[[ OBJECTIVE_KICKOFF ]]
--~ 	Objective_Start(OBJ_Main) -- Start Primary Objective
	
end

Scar_AddInit(MissionObjective_Init)

-------------------------------------------------------------------------
-- [[ REGISTER OBJECTIVE ]]
-------------------------------------------------------------------------

-- Mission Objectives
function Initialize_Objectives()

	OBJ_Main = {
		SetupUI = function() 
		end,
		OnStart = function(self)
			Objective_Start(OBJ_Silver, false)
			Rule_AddDelayedInterval(FailCheck, 10, 2)
		end,
		
		OnComplete = function()
			
			Mission_MissionComplete()
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.Intro,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11055197,  --LOC("Take control of the soviet base"),
		Description = 0,			-- Objective Description
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	OBJ_Silver = {
		Parent = OBJ_Main,
		SetupUI = function() 
		end,
		
		OnStart = function()
--~ 			Objective_SetCounter(OBJ_Silver, g_count, g_silver)
--~ 			Bonus_Camo_Drop()
		end,
		
		OnComplete = function()
			Objective_RemoveUIElements(OBJ_Main, obj_id_1)
			Objective_RemoveUIElements(OBJ_Main, obj_id_2)
			Objective_RemoveUIElements(OBJ_Main, obj_id_3)
			Objective_RemoveUIElements(OBJ_Main, obj_id_4)
			Objective_RemoveUIElements(OBJ_Main, obj_id_5)
			Objective_Start(OBJ_Capture)
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11055198, --LOC("Breach the Base"),
		Description = 0,			-- Objective Description
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	OBJ_Capture = {
		Parent = OBJ_Main,
		SetupUI = function() 
		end,
		
		OnStart = function()
			Objective_Show(OBJ_Silver, false)
		end,
		
		OnComplete = function()
			
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = EVENTS.Captured_Base,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11055199, --LOC("Capture the Base Point or Clear the base of the Enemy"),
		Description = 0,			-- Objective Description
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	OBJ_Setup = {
		Parent = OBJ_Main,
		
		SetupUI = function() 
		end,
		
		OnStart = function()
			Objective_StartTimer(OBJ_Setup, COUNT_DOWN, 90)
			Event_Timer(CompleteSetup, nil, 90)
		end,
		
		OnComplete = function()		
			_ToWDebugDisplay("OBJ_Setup complete", "white")
			Objective_Show(OBJ_Setup, false)
			Objective_Start(OBJ_Gold)
			HintPoint_Remove(wt_hint_01)
			HintPoint_Remove(wt_hint_02)
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11051338, --LOC("Prepare for the Soviet Counterattack"),
		Description = 0,			-- Objective Description
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	OBJ_Gold = {
		Parent = OBJ_Main,
		
		SetupUI = function() 
			Objective_SetCounter(OBJ_Gold, g_wave_count, g_wave_goal)
		end,
		
		OnStart = function()
			Start_Waves()
			Rule_AddOneShot(Start_Bonus_Objective, 5)
		end,
		
		OnComplete = function()		
			_ToWDebugDisplay("OBJ_Gold complete", "white")
			Objective_Complete(OBJ_Main, false)
		end,
		
		OnFail = function()

		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11055200, --LOC("Defend Against the Soviet Counterattack"),
		Description = 0,			-- Objective Description
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	OBJ_Bonus = {
		SetupUI = function() 
			Objective_SetCounter(OBJ_Bonus, g_point_count, g_point_goal)
		end,
		
		OnStart = function()
			obj_bonusid_1 = Objective_AddUIElements(OBJ_Bonus, mkr_bonus_ui_01, true, 11055211)
			obj_bonusid_2 = Objective_AddUIElements(OBJ_Bonus, mkr_bonus_ui_02, true, 11055211)
			Event_PlayerOwnsTerritory(Bonus_UI_Check_01, nil, player1, eg_bonus_point1, ALL)
			Event_PlayerOwnsTerritory(Bonus_UI_Check_02, nil, player1, eg_bonus_point2, ALL)
		end,
		
		OnComplete = function()	

		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = EVENTS.Bonus_Complete,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11055201, -- LOC("Capture the Radio Towers to call in Airstrikes"),
		Description = 0,			-- Objective Description
		TitleEnd = nil, -- LOCDB [11038785] 'Reinforcements inbound.'
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	OBJ_Bonus_Car = {
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
		
		Intel_Start = EVENTS.Bonus_Scoutcar_Intro,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11055202, --LOC("Locate the abandonded Scout Car")
		Description = 0,			-- Objective Description
		TitleEnd = nil, -- LOCDB [11038785] 'Reinforcements inbound.'
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	OBJ_Bonus_Escort = {
		SetupUI = function() 
		end,
		
		OnStart = function()
			
		end,
		
		OnComplete = function()	
			Scar_CompleteIntelBulletinTask(player1, "tow_occupation_bonus") -- Grant Achievement 
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.Bonus_Escort_Start,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = EVENTS.Bonus_Escort_Complete,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11055298, --LOC("Locate the abandonded Scout Car")
		Description = 0,			-- Objective Description
		TitleEnd = nil, -- LOCDB [11038785] 'Reinforcements inbound.'
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	Objective_Register(OBJ_Main)
	Objective_Register(OBJ_Silver)	
	Objective_Register(OBJ_Capture)	
	Objective_Register(OBJ_Setup)
	Objective_Register(OBJ_Bonus)
	Objective_Register(OBJ_Bonus_Car)
	Objective_Register(OBJ_Bonus_Escort)
	Objective_Register(OBJ_Gold)
end


-- Icons for Objective Locations on the minimap
function Minimap_Objectives()
	obj_id_1 = Objective_AddUIElements(OBJ_Main, mkr_ui_gate1, true, 11055203)
	obj_id_2 = Objective_AddUIElements(OBJ_Main, mkr_ui_gate2, true, 11055203)
	obj_id_3 = Objective_AddUIElements(OBJ_Main, mkr_ui_gate3, true, 11055203)
	obj_id_4 = Objective_AddUIElements(OBJ_Main, mkr_ui_gate4, true, 11055203)
	obj_id_5 = Objective_AddUIElements(OBJ_Main, mkr_ui_gate5, true, 11055203)
end

-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------
---- MISSION HELPER FUNCTIONS	

-- Increment Objective Counter used when an encounter has been eliminated. Also kicks off additional events as the player completes encounters. 
function IncrementCounter()
	g_count = g_count + 1
	
	local obj = nil
	local goal = 0
	local count = "ERR"
	if Objective_IsStarted(OBJ_Silver) then
		obj = OBJ_Silver
		count = g_count
		goal = g_silver
	end
	
	if (obj) then
		Objective_SetCounter(obj, count, goal)
		if count >= goal then
			Objective_Complete(obj)
		end
	end
	
end
function IncrementWaveCounter()
	g_wave_count = g_wave_count + 1
	
	local obj = nil
	local goal = 0
	local count = "ERR"
	if Objective_IsStarted(OBJ_Gold) then
		obj = OBJ_Gold
		count = g_wave_count
		goal = g_wave_goal
	end
	
	if (obj) then
		Objective_SetCounter(obj, count, goal)
--~ 		if count >= goal then
--~ 			Objective_Complete(obj)
--~ 		end
	end
	

end
function IncrementBonusCounter()
	g_point_count = g_point_count + 1
	
	local obj = nil
	local goal = 0
	local count = "ERR"
	if Objective_IsStarted(OBJ_Bonus) then
		obj = OBJ_Bonus
		count = g_point_count
		goal = g_point_goal
	end
	
	if g_point_count == 1 then
		Util_StartIntel(EVENTS.Bonus_Progress)
	end
	
	if (obj) then
		Objective_SetCounter(obj, count, goal)
		if count >= goal then
			Objective_Complete(obj) -- complete Objective_AddPing
			-- grant bonus ability
			Cmd_InstantUpgrade(player1, UPG.GERMAN.STUKA_FRAGMENTATION_BOMB)
			Player_AddAbility(player1, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB)
			Player_SetAbilityAvailability(player1, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB,ITEM_UNLOCKED )
			Modify_AbilityMunitionsCost(player1, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB, 0.25)
			UI_AddHintAndFlashAbility(player1, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB, LOC("Fragmentation Bomb Unlocked"), 3)
		end
	end
	
end



function Start_Bonus_Objective()
	Objective_Start(OBJ_Bonus)
	World_IncreaseInteractionStage()
	EGroup_EnableStrategicPoint(eg_bonus_points, true)
	EGroup_InstantCaptureStrategicPoint( eg_bonus_points, player2 ) 
	EGroup_EnableMinimapIndicator(eg_bonus_points, true)
end
function Bonus_Complete_Check()
	Objective_Complete(OBJ_Bonus)
end

function Bonus_UI_Check_01()
	IncrementBonusCounter()
	Objective_RemoveUIElements(OBJ_Bonus, obj_bonusid_1)
end

function Bonus_UI_Check_02()
	IncrementBonusCounter()
	Objective_RemoveUIElements(OBJ_Bonus, obj_bonusid_2)
end

function Bonus_Car_Start()
	if Entity_IsValid(Scout_Carid) then 
		Objective_Start(OBJ_Bonus_Car)
		obj_bonus_id_car = Objective_AddUIElements(OBJ_Bonus_Car, scout_spawn, true, 11055204, true, 2)
	end
end

-------------------------------------------------------------------------
---------------- 	MISSION END FUNCTIONS ---------------------
-------------------------------------------------------------------------
function CompleteSetup()
	print ("Setup Complete!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	Objective_Complete(OBJ_Setup) 
end

function Mission_MissionComplete()
	mission_complete = true
	Game_SetMode(UI_Cinematic)
	FOW_RevealAll()
	if Objective_IsComplete(OBJ_Gold) then
		Util_StartIntel(EVENTS.VPVictoryMessage)
		Camera_MoveTo(eg_point1, true, 0.05)
	end
	Rule_AddDelayedInterval(Mission_MissionEnd, 1.5, 1)
end

function Mission_MissionEnd()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		if Objective_IsComplete(OBJ_Gold) then
			Game_EndSP (true)
		else
			Game_EndSP(false)
		end
	end
end



function FailCheck()
	if phase2_started == false and Player_GetSquadCount(player1) < 1 then
		Event_NarrativeEventsNotRunning(Mission_MissionComplete, nil, 1)
		Rule_RemoveMe()
	elseif phase2_started == true and Player_GetSquadCount(player1) < 1 then
		Util_StartIntel(EVENTS.Fail_Captured)
		Event_NarrativeEventsNotRunning(Mission_MissionComplete, nil, 1)
		Rule_RemoveMe()
	elseif phase2_started == true and Player_OwnsEGroup(player2, eg_point1) then
		Util_StartIntel(EVENTS.Fail_Captured)
		Event_NarrativeEventsNotRunning(Mission_MissionComplete, nil, 1)
		Camera_MoveTo(eg_point1, true, 0.05)
		Rule_RemoveMe()
	elseif phase2_started == true and EGroup_Count(eg_hq) <= 0 then
		Util_StartIntel(EVENTS.Fail_Captured)
		Event_NarrativeEventsNotRunning(Mission_MissionComplete, nil, 1)
		Util_MissionTitle( 11048793 )
		Camera_MoveTo(mkr_player_hq, true, 0.05)
		Rule_RemoveMe()
	else
		Player_GetAll(player1)
		local movers = 0
		local function CanIMove (sgroup, index, squad)
			if Squad_HasCritical(squad, CRIT.VEHICLE_DESTROY_ENGINE) 
			or Squad_HasCritical(squad, CRIT.VEHICLE_LIGHT_DESTROY_ENGINE)
			or Squad_HasCritical(squad, CRIT.VEHICLE_KILL_DRIVER_RUSSIAN)
			or Squad_HasCritical(squad, CRIT.VEHICLE_LOSE_TREADS_OR_WHEELS) then
				movers = movers
			else
				movers = movers + 1
			end
		end
		SGroup_ForEach(sg_allsquads, CanIMove )
		if movers == 0 then
			Mission_MissionComplete()
			Rule_RemoveMe()
		end
	end
end

