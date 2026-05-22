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
	t_ally_event = { EVENTS.Area_Cleared, EVENTS.Area_Cleared_2, EVENTS.Area_Cleared_3}
	
	-- Objective Variables
	g_count = 0 -- Initial Objective Completion Count
	g_tank_count = 0 -- Finale Objective Completion Count
	g_silver = 7 -- Goal Variable for Initial Objective
	g_gold = 8 -- Goal Variable for Finale Objective
	
	-- Bonus Variables
	g_transport_count = 0 -- Initial Bonus Objective Count
	g_bonus = 3 -- Goal Variable for Bonus Objective
	
	--[[ REGISTER OBJECTIVES ]]
	Initialize_Objectives()
	Minimap_Objectives()
	
	--[[ OBJECTIVE_KICKOFF ]]
	Objective_Start(OBJ_Main) -- Start Primary Objective
	
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
			
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11051336,  --LOC("Aid Allies to Eliminate and Capture Soviet Defensive Positions"),
		Description = 0,			-- Objective Description
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	OBJ_Silver = {
		Parent = OBJ_Main,
		SetupUI = function() 
		end,
		
		OnStart = function()
			Objective_SetCounter(OBJ_Silver, g_count, g_silver)
		end,
		
		OnComplete = function()
			_ToWDebugDisplay("OBJ_Silver complete", "white")
			Rule_AddInterval(SetupGold_OBJ,1)
			AllySetupFinale01()-- Spawn in support Allies to follow tank.
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11051337, --LOC("Positions Eliminated"),
		Description = 0,			-- Objective Description
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	OBJ_Setup = {
		Parent = OBJ_Main,
		
		SetupUI = function() 
		end,
		
		OnStart = function()
			Objective_StartTimer(OBJ_Setup, COUNT_DOWN, 30)
			Event_Timer(CompleteSetup, nil, 30)
		end,
		
		OnComplete = function()		
			_ToWDebugDisplay("OBJ_Setup complete", "white")
			Start_Final_Encounters() -- Start Final Encounters
			Rule_AddInterval(StartGold,1)
			Objective_Show(OBJ_Setup, false)
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.OBJFinale,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11051338, --LOC("Prepare for the Soviet Counterattack"),
		Description = 0,			-- Objective Description
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	OBJ_Gold = {
		Parent = OBJ_Main,
		
		SetupUI = function() 
		end,
		
		OnStart = function()
			Objective_SetCounter(OBJ_Gold, g_tank_count, g_gold)
			Ally_Modifiers()
		end,
		
		OnComplete = function()		
			_ToWDebugDisplay("OBJ_Gold complete", "white")
			Objective_Complete(OBJ_Main)
			Final_Inf01_Retreat()
			Final_Inf02_Retreat()
			Final_Enc_Retreat()
			Event_Timer(Mission_MissionComplete, nil, 5)
		end,
		
		OnFail = function()

		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11051339, --LOC("Eliminate the Soviet Tanks"),
		Description = 0,			-- Objective Description
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	OBJ_Bonus = {
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			Objective_SetCounter(OBJ_Bonus, g_transport_count, g_bonus)
		end,
		
		OnComplete = function()	
			Event_Timer(Grant_Bonus_Munitions, nil, 2)
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11051340, -- LOC("Locate and Destroy Soviet Transports for Additional Munitions"),
		Description = 0,			-- Objective Description
		TitleEnd = nil, -- LOCDB [11038785] 'Reinforcements inbound.'
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}

	Objective_Register(OBJ_Main)
	Objective_Register(OBJ_Silver)	
	Objective_Register(OBJ_Gold)	
	Objective_Register(OBJ_Setup)
	Objective_Register(OBJ_Bonus)
end

-- Start Setup Gold Objective
function SetupGold_OBJ()
	if not Event_IsAnyRunning() then
		Rule_RemoveMe()
		Objective_Start(OBJ_Setup)
	end
end
-- Start Gold Objective
function StartGold()
	if not Event_IsAnyRunning() then
		Rule_RemoveMe()
		Objective_Start(OBJ_Gold)
	end
end
-- Start Bonus Objective
function Start_BonusOBJ()
		Objective_Start(OBJ_Bonus)
end

-- Icons for Objective Locations on the minimap
function Minimap_Objectives()
	obj_id_1 = Objective_AddUIElements(OBJ_Main, mkr_enc1_ui, true, 11051329)
	obj_id_2 = Objective_AddUIElements(OBJ_Main, mkr_enc2_ui, true, 11051330)
	obj_id_3 = Objective_AddUIElements(OBJ_Main, mkr_enc3_ui, true, 11051331)
	obj_id_4 = Objective_AddUIElements(OBJ_Main, mkr_enc4_ui, true, 11051332)
	obj_id_5 = Objective_AddUIElements(OBJ_Main, mkr_enc5_ui, true, 11051333)
	obj_id_6 = Objective_AddUIElements(OBJ_Main, mkr_enc6_ui, true, 11051334)
	obj_id_7 = Objective_AddUIElements(OBJ_Main, mkr_enc7_ui, true, 11051335)
end

-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------
---- MISSION HELPER FUNCTIONS	

-- Increment Objective Counter used when an encounter has been eliminated. Also kicks off additional events as the player completes encounters. 
function IncrementCounter()
	Util_StartIntel(Table_GetRandomItem(t_ally_event))  -- Area Cleared Event
	Player_AddResource(player1, RT_Munition, t_difficulty.point_reward) -- Add player munitions for each objective point completed.
	
	if SGroup_Count(sg_Tiger) ~= 0 then
		UI_CreateColouredPositionKickerMessage(player1, SGroup_GetPosition(sg_Tiger), t_difficulty.rewardMunitions, 255, 193, 37, 0) -- Kicker for Munition Addition
	end
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
			ret_Enc_Retreat() -- have remaining units on map retreat before final attack
		end
	end
	
	if g_count == 2 then
		Util_StartIntel(EVENTS.Progress_01)
	end
	
	if g_count == 3 and SGroup_Count(sg_Tiger) ~= 0 then
		Event_Timer(SetupRet01, nil, 5) -- Spawn Retaliation Encounter 1
		Cmd_Ability(player2, ABILITY.SOVIET.IL_2_RECON_SINGLEPASS_SP, sg_Tiger, Marker_GetDirection(mkr_flyby_dir), true) 
		Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_tiger_ace_foggy.aps", 15)-- Testing Day Smoke Atmos
	end
	
	if g_count == 5 and SGroup_Count(sg_Tiger) ~= 0 then
		Event_Timer(SetupRet02, nil, 5) -- Spawn Retaliation Encounter 2
		Cmd_Ability(player2, ABILITY.SOVIET.IL_2_RECON_SINGLEPASS_SP, sg_Tiger, Marker_GetDirection(mkr_flyby_dir), true) 
		Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_tiger_ace_night.aps", 360) -- Testing Night Atmos
	end
	
	if g_count == 6 then
		Util_StartIntel(EVENTS.Progress_02)
	end

	_ToWDebugDisplay("IncrementCounter:   (" .. count .. "/" .. goal ..")" , "gold") 
end

-- Increment Objective Counter used when an enemy tank has been eliminated. Kicks off further encounters as the player eliminates tanks. 
function IncrementCounter_Tank()

	g_tank_count = g_tank_count + 1
	
	local obj = nil
	local goal = 0
	local count = "ERR"
	if Objective_IsStarted(OBJ_Gold) then
		obj = OBJ_Gold
		count = g_tank_count
		goal = g_gold
	end
	
	if (obj) then
		Objective_SetCounter(obj, count, goal)
		if count >= goal then
			Objective_Complete(obj)
		end
	end
	
	if g_tank_count == 1  then
		Setup_Final_Enc02()
		Util_StartIntel(EVENTS.OBJFinale_Warning_01) -- KV2 Warning
	end

	if g_tank_count == 3 then
		Setup_Final_Enc03()
	end
	
	if g_tank_count == 5 then
		Setup_Final_Enc04()
		Setup_Final_Inf02()
		Util_StartIntel(EVENTS.OBJFinale_Warning_02) -- KV2 Warning
	end
end

-- Bonus Objective Counter
function IncrementCounter_Transports()

	g_transport_count = g_transport_count + 1
	
	Player_AddResource(player1, RT_Munition, 50) -- Add player munitions for each objective point completed.
		
	if SGroup_Count(sg_Tiger) ~= 0 then
		UI_CreateColouredPositionKickerMessage(player1, SGroup_GetPosition(sg_Tiger), 11051789, 255, 193, 37, 0) -- Kicker for Munition Addition
	end
	local obj = nil
	local goal = 0
	local count = "ERR"
	if Objective_IsStarted(OBJ_Bonus) then
		obj = OBJ_Bonus
		count = g_transport_count
		goal = g_bonus
	end
	
	if (obj) then
		Objective_SetCounter(obj, count, goal)
		if count >= goal then
			Objective_Complete(obj)
		end
	end

	
--~ 	_ToWDebugDisplay("IncrementCounter:   (" .. count .. "/" .. goal ..")" , "gold") 
end

function Grant_Bonus_Munitions()
	Player_AddResource(player1, RT_Munition, 200)
	if SGroup_Count(sg_Tiger) ~= 0 then
		UI_CreateColouredPositionKickerMessage(player1, SGroup_GetPosition(sg_Tiger), 11051793, 255, 193, 37, 0) -- Kicker for Munition Addition
	end
	
end

-------------------------------------------------------------------------
---------------- 	MISSION END FUNCTIONS ---------------------
-------------------------------------------------------------------------
function CompleteSetup()
	Objective_Complete(OBJ_Setup) 
end

function Mission_MissionComplete()
	Game_SetMode(UI_Cinematic)
	FOW_RevealAll()
	if SGroup_Count(sg_Tiger) ~= 0 then
		Camera_MoveTo(sg_Tiger, true, 0.05)
	end
	if Objective_IsComplete(OBJ_Gold) then
		Util_StartIntel(EVENTS.VPVictoryMessage)
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
	if Player_GetSquadCount(player1) < 1 then
		Mission_MissionComplete()
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