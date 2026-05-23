-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- Operation Sandcastle
-- <Extra notes here>
-- Designer: de111de
--

-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScarUtil.scar")									-- Scar functionality
import("Systems/AiManager/ai.scar")						-- Encounter system
import("Prototype/DeploymentPoints.scar")
import("Beginner.scar")								-- BeginnerHint system
import("Global_Values/CampaignGlobalConstants.scar")	-- Global values used throughout the game
import("TheatreOfWar.scar")								-- Theater of War Functions
import("Prototype/SpecialAEFunctions.scar")				-- Special functions called from the AE
--~	import("extra_scar_file_here.scar")				-- Extra scar files for the mission
import("hngOP_1_obj_MainObjectiveAllies.scar")
import("hngOP_1_obj_killCommandPostObjective.scar")

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------

function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

	local g_commandPost_Timer = 12


function OnGameSetup( )
	print("Running OnGameSetup...")
	player1 = World_GetPlayerAt(1) -- Player 1
	player2 = World_GetPlayerAt(2) -- Player 2
	player3 = World_GetPlayerAt(3) -- Player 3
	player4 = World_GetPlayerAt(4) -- Player 4
	
	--[[Setup_SetPlayerName(player1, LOC_factionName2)
	Setup_SetPlayerName(player2, LOC_factionName1)
	Setup_SetPlayerName(player3, LOC_factionName2)
	Setup_SetPlayerName(player4, LOC_factionName1)]]

end

function OnGameRestore()
	-- function takes care of restoring all global mission parameters after a save/load
	print("Restoring game from a saved session...")
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	player4 = World_GetPlayerAt(4)
	
	Game_DefaultGameRestore()
end

-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------
-- Main initialization routine. Called 1 frame after all files have been loaded.

function OnInit()
	print("Initializing mission...")
	
	--[[ SET RESTRICTIONS ]]
	Mission_Restrictions()
	
	--[[ SET MODIFIERS ]]
	Mission_SetupVariables()
	
	--[[ SET ABILITIES ]]
	Mission_Abilities()
	
	--[[ MISSION PRESETS ]]
	Mission_MissionPreset()
	
	--[[ MISSION DIFFICULTY ]]
	Mission_Difficulty()
	
	--[[ REGISTER OBJECTIVES ]]	
	-- Main obj
--~	INIT_MainOBJ()
--~	Objective_Start(INIT_MainOBJ, false)
	INIT_ObjMainObjective_allies()
	
	INIT_ObjKillCommandPostObjective()
	
	
	--[[ MISSION START ]]
	Mission_Start()

	
	print("Mission initialization finished.")
end

Scar_AddInit(OnInit)
	print("Scar actions executing...")
	
--[[function INIT_ObjMainObjective_allies()

	print("Initializing Main Objective...")
	
	g_sobjTimer = 30
	g_Axis_capTimer = 45
	g_Axis_cap_TimeRemaining = 45
	
	tmr_reinforcements = "tmr_reinforcements"
	tmr_Axis_cap = "tmr_Axis_cap"
	
	obj_MainObjective_allies = {
	
		SetupUI = function() 
			UI_obj_MainObjective_allies1 = Objective_AddUIElements(obj_MainObjective_allies, eg_allied_capturePoint2, true, Util_CreateLocString("Critical point"), true)
			UI_obj_MainObjective_allies2 = Objective_AddUIElements(obj_MainObjective_allies, eg_allied_capturePoint3, true, Util_CreateLocString("Critical point"), true)
		end,
		
		OnStart = function()
			Rule_AddDelayedInterval(Axis_CheckPointCaptured, 1, 1)
			Rule_Add(Start_SOBJ_ArmourSupportObjective)
			Timer_Start(tmr_reinforcements,  g_sobjTimer)
			Objective_StartTimer(obj_MainObjective_allies, COUNT_DOWN, g_sobjTimer, 10)
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = Util_CreateLocString("Allies have to defend"),
		Description = 0,
		Type = OT_Primary,
	}
	
	SOBJ_ArmourSupportObjective = {
		Parent = obj_MainObjective_allies,
		SetupUI = function()
			UI_SOBJ_ArmourSupportObjective = Objective_AddUIElements(SOBJ_ArmourSupportObjective, eg_cptPoint_allied_Armour, true, Util_CreateLocString("Secure this point"), true, 3.5)
		end,
		OnStart = function()
			Obj_ShowProgress2(Util_CreateLocString("Bridge"), EGroup_GetAvgHealth(eg_allied_bridge))
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = Util_CreateLocString("Capture the fuel depot"),
		Description = 0,
		Type = OT_Secondary,
	}
	
	SOBJ_ArmourSupportObjective_axis = {
		Parent = obj_MainObjective_allies,
		SetupUI = function()
			UI_SOBJ_ArmourSupportObjective_axis = Objective_AddUIElements(SOBJ_ArmourSupportObjective_axis, eg_cptPoint_allied_Armour, true, Util_CreateLocString("Deny this point to the Allies"), true, 3.5)
			UI_SOBJ_ArmourSupportObjective2_axis = Objective_AddUIElements(SOBJ_ArmourSupportObjective_axis, eg_allied_bridge, true, Util_CreateLocString("Destroy the bridge"), true, 3.5)
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = Util_CreateLocString("Prevent the Allies from capturing the fuel depot"),
		Description = 0,
		Type = OT_Secondary,
	}
	
	Objective_Register(obj_MainObjective_allies)
	Objective_Register(SOBJ_ArmourSupportObjective, player1)
	Objective_Register(SOBJ_ArmourSupportObjective, player3)
	Objective_Register(SOBJ_ArmourSupportObjective_axis, player2)
	Objective_Register(SOBJ_ArmourSupportObjective_axis, player4)
	
end --]]

function Start_SOBJ_ArmourSupportObjective()
	if Objective_IsTimerSet(SOBJ_ArmourSupportTimer) == true then
		if Objective_GetTimerSeconds(SOBJ_ArmourSupportTimer) == 0 then				
			Rule_RemoveMe()
			World_IncreaseInteractionStage()
			Timer_End(tmr_reinforcements)
			Objective_StopTimer(SOBJ_ArmourSupportTimer)
			if EGroup_GetAvgHealth(eg_allied_bridge) >= 0.01 then
				Objective_Start(SOBJ_ArmourSupportObjective_axis)
				Objective_Start(SOBJ_ArmourSupportObjective)
				Rule_Add(Start_bridgeCheck)
				Rule_Add(Start_capturePointCheck)
			else
				Util_MissionTitle(Util_CreateLocString("Allied reinforcements have arrived but can't move into the area"))
					--delayed start of the next objective
				Rule_AddOneShot(Start_obj_KillCommandPost, 120)
			end				
		end
--	else --~ if the axis managed to capture one of the critical points, before the sub objective is started, and then failed to hold it this would get triggered
--		Rule_RemoveMe()
			--broadcast a message
--		Util_MissionTitle(Util_CreateLocString("Allied reinforcements can't reach the area"))
			--delayed start of the next objective
--		Rule_AddOneShot(Start_obj_KillCommandPost, 120)
			--unlock the fuel dump even though the allied reinforcements are blocked by Axis forces
--		World_IncreaseInteractionStage()
	end
end
	
function Start_capturePointCheck()
	if Util_GetPlayerOwner(eg_cptPoint_allied_Armour) == player1 or Util_GetPlayerOwner(eg_cptPoint_allied_Armour) == player3 then
		Rule_RemoveMe()
			--stop checking for the bridge
		Rule_Remove(Start_bridgeCheck)
			--complete the objective
		Objective_Complete(SOBJ_ArmourSupportObjective);
			--broadcast a message
		Util_MissionTitle(Util_CreateLocString("Allied armour has arrived"))
			--spawn in the armour
		sg_allied_ArmourSupport = SGroup_CreateIfNotFound("sg_allied_ArmourSupport");
		Util_CreateSquads(player3, sg_allied_ArmourSupport, BP_GetSquadBlueprint("m4a3_sherman_squad_mp"), mkr_armourSupport_spawn1, mkr_armourSupport_dest, 1, nil, false);
		Util_CreateSquads(player3, sg_allied_ArmourSupport, BP_GetSquadBlueprint("m4a3_sherman_squad_mp"), mkr_armourSupport_spawn2, mkr_armourSupport_dest, 1, nil, false);
		Util_CreateSquads(player3, sg_allied_ArmourSupport, BP_GetSquadBlueprint("m4a3e8_sherman_easy_8_squad_mp"), mkr_armourSupport_spawn3, mkr_armourSupport_dest, 1, nil, false);
		Util_CreateSquads(player3, sg_allied_ArmourSupport, BP_GetSquadBlueprint("m4a3_76mm_sherman_bulldozer_squad_mp"), mkr_armourSupport_spawn4, mkr_armourSupport_dest, 1, nil, false);
		Util_CreateSquads(player3, sg_allied_ArmourSupport, BP_GetSquadBlueprint("m26_pershing_mp"), mkr_armourSupport_spawn5, mkr_armourSupport_dest, 1, nil, false);
			--remove the UI indicators
		Objective_RemoveUIElements(SOBJ_ArmourSupportObjective, UI_SOBJ_ArmourSupportObjective)
		Objective_RemoveUIElements(SOBJ_ArmourSupportObjective_axis, UI_SOBJ_ArmourSupportObjective_axis)
		Objective_RemoveUIElements(SOBJ_ArmourSupportObjective_axis, UI_SOBJ_ArmourSupportObjective2_axis)
		Obj_HideProgress()
			--delayed start of the next objective
		Rule_AddOneShot(Start_obj_KillCommandPost, 120)
	end
end

function Start_bridgeCheck()
	Obj_ShowProgress2(Util_CreateLocString("Bridge"), EGroup_GetAvgHealth(eg_allied_bridge))
	if EGroup_GetAvgHealth(eg_allied_bridge) <= 0.01 then
		Rule_RemoveMe()
			--stop checking for if team 1 owns the critical point
		Rule_Remove(Start_capturePointCheck)
			--fail the objective
		Objective_Fail(SOBJ_ArmourSupportObjective)
			--broadcast a message
		Util_MissionTitle(Util_CreateLocString("Allied reinforcements have been denied"))
			--remove the UI indicators
		Objective_RemoveUIElements(SOBJ_ArmourSupportObjective, UI_SOBJ_ArmourSupportObjective)
		Objective_RemoveUIElements(SOBJ_ArmourSupportObjective_axis, UI_SOBJ_ArmourSupportObjective_axis)
		Objective_RemoveUIElements(SOBJ_ArmourSupportObjective_axis, UI_SOBJ_ArmourSupportObjective2_axis)
		Obj_HideProgress()
			--delayed start of the next objective
		Rule_AddOneShot(Start_obj_KillCommandPost, 120)
	end
end

function Start_obj_KillCommandPost()
	--Rule_RemoveMe()
	Objective_Start(obj_KillCommandPost)
	Rule_Add(Start_CommandPostCheck)
	World_IncreaseInteractionStage()
	EGroup_EnableMinimapIndicator(eg_AxisCommandPost, true)
end

function Start_CommandPostCheck()
	Obj_ShowProgress(Util_CreateLocString("Command Post"), EGroup_GetAvgHealth(eg_AxisCommandPost))
	if EGroup_GetAvgHealth(eg_AxisCommandPost) <= 0.1 then
		Obj_SetProgressBlinking(true)
	else
		Obj_SetProgressBlinking(false)
	end
--~	if EGroup_GetAvgHealth(eg_AxisCommandPost) >= 0.1 then
--~		Obj_SetProgressBlinking(false)
--~	end
	if EGroup_GetAvgHealth(eg_AxisCommandPost) <= 0.01 then
		Rule_RemoveMe()
			--complete the objective
		Objective_Complete(obj_KillCommandPost)
			--remove the UI indicators
		Objective_RemoveUIElements(obj_KillCommandPost, CommandPost_UI)
		--[[	--set the axis base to owned by the allies; ending the game --doesn't work
		EGroup_SetPlayerOwner(eg_axis_base, player3) ]]
		EGroup_CreateKickerMessage(eg_axis_base, Util_CreateLocString("Captured by allied forces"))
			--broadcast a message
		Util_MissionTitle(Util_CreateLocString("Allied forces pushed the Germans back and successfully defended"), 1, 5, 1) 
			--end the game
		Rule_AddOneShot(Game_allies_win, 7)
		sg_Axis_lost1 = SGroup_CreateIfNotFound("sg_Axis_lost1")
		sg_Axis_lost2 = SGroup_CreateIfNotFound("sg_Axis_lost2")
		Player_GetAll(player2, sg_Axis_lost1)
		Player_GetAll(player4, sg_Axis_lost2)
		Cmd_Retreat(sg_Axis_lost1, Marker_GetPosition(mkr_Axis_withdraw), mkr_Axis_withdraw, false)
		Cmd_Retreat(sg_Axis_lost2, Marker_GetPosition(mkr_Axis_withdraw), mkr_Axis_withdraw, false)
		Obj_HideProgress()
	end
end
	
function Mission_Restrictions()	
	
end

function Mission_SetupVariables()
	print("Initializing mission DATA...")
	--E~ I wouldn't do global data like OBJ's or useEncounterSystem in a table, but its up to you
	
	
    g_missionData = {
		useEncounterSystem = false,
		objectives = {
			obj_MainObjective_allies,	-- These are the global references to the objective tables defined in the separete files.
			obj_KillCommandPost,
			SOBJ_ArmourSupportObjective,
			SOBJ_ArmourSupportObjective_axis,
		},
		startingUnits = {
		}
	}
end

function Mission_Abilities()
	
end

-------------------------------------------------------------------------
-- MISSION Preset 
-------------------------------------------------------------------------
-- Kicks off after SCAR Inits, but before MissionStart is called.
-- Use for spawning units on the map at the start

function Mission_MissionPreset()
	
	-------------------------------
	-- Set global variables
	-------------------------------
	g_missionFailed = false
	useEncounterSystem = true
	g_useSkirmishAI = true
	g_useWithdraw = true
	g_AUTOSAVE_DELAY = 10
	
	EGroup_SetAnimatorState(cosmetics_eg_lamps, "Light_State", "On")
	-------------------------------
	--spawn in units	(Util_CreateSquads(player, sGroup, BP_GetSquadBlueprint("blueprint"), spawn, destination/nil, 1, nil, false))
	-------------------------------
		--german artillery
	sg_AxisArtillery1 = SGroup_CreateIfNotFound("sg_AxisArtillery1")
	Util_CreateSquads(player2, sg_AxisArtillery1, BP_GetSquadBlueprint("howitzer_105mm_le_fh18_artillery_mp"), mkr_spawn_german_artillery1)
	Util_CreateSquads(player2, sg_AxisArtillery1, BP_GetSquadBlueprint("howitzer_105mm_le_fh18_artillery_mp"), mkr_spawn_german_artillery2)
	Util_CreateSquads(player2, sg_AxisArtillery1, BP_GetSquadBlueprint("howitzer_105mm_le_fh18_artillery_mp"), mkr_spawn_german_artillery3)
	sg_AxisArtillery2 = SGroup_CreateIfNotFound("sg_AxisArtillery2")
	Util_CreateSquads(player4, sg_AxisArtillery2, BP_GetSquadBlueprint("howitzer_105mm_le_fh18_artillery_mp"), mkr_spawn_german_artillery4)
	Util_CreateSquads(player4, sg_AxisArtillery2, BP_GetSquadBlueprint("howitzer_105mm_le_fh18_artillery_mp"), mkr_spawn_german_artillery5)
		--not owned by the axis at the beginning
	eg_AxisArtillery_neutral = EGroup_CreateIfNotFound("eg_AxisArtillery_neutral")
	Util_CreateEntities(nil, eg_AxisArtillery_neutral, BP_GetEntityBlueprint("howitzer_105mm_le_fh18_mp"), mkr_spawn_german_artillery6, 1)
		--axis command post
	eg_AxisCommandPost = EGroup_CreateIfNotFound("eg_AxisCommandPost")
	Util_CreateEntities(player2, eg_AxisCommandPost, BP_GetEntityBlueprint("west_german_hq_mp"), mkr_spawn_CommandPost, 1)
	EGroup_EnableMinimapIndicator(eg_AxisCommandPost, false)
	--if Player_GetRaceName(player2) ~= west_german then --doesn't work
		EGroup_SetSelectable(eg_AxisCommandPost, false)
	--end
		--the major
	sg_Allies_starting_units = SGroup_CreateIfNotFound("sg_Allies_starting_units")
	Util_CreateSquads(player1, sg_Allies_starting_units, BP_GetSquadBlueprint("major_squad_mp"), mkr_spawn_major, mkr_dest_major, 1, nil, false)
		--the ambulance 
	eg_Allies_starting_units = EGroup_CreateIfNotFound("eg_Allies_starting_units")
	Util_CreateEntities(player1, eg_Allies_starting_units, BP_GetEntityBlueprint("dodge_wc51_ambulance_mp"), mkr_spawn_ambulance, 1)
----------------------------------------------------------------------------------------
	print("Mission Preset activated.")
end

function Mission_Difficulty()
	
end

function Mission_Start()
	Objective_Start(obj_MainObjective_allies)
	Rule_AddOneShot(Delayed_Start_SOBJ_ArmourSupportObjective, 5)
	--Rule_Add(Start_CapturePointCheck)
end

function Delayed_Start_SOBJ_ArmourSupportObjective()
	Rule_Add(Start_SOBJ_ArmourSupportObjective)
end

--[[function Start_CapturePointCheck()
	if EGroup_IsCapturedByPlayer(eg_allied_capturePoint1, player2, true) then
		Rule_RemoveMe()
			--broadcast a message
		Util_MissionTitle(Util_CreateLocString("The Axis broke through the front line and captured the area"))
			--end the game
		World_SetPlayerLose(player1)
		World_SetPlayerLose(player3)
		EGroup_SetPlayerOwner(eg_allied_base, player2)
	end
	if Util_GetPlayerOwner(eg_allied_capturePoint1) == player2 or Util_GetPlayerOwner(eg_allied_capturePoint1) == player4 then
		if Util_GetPlayerOwner(eg_allied_capturePoint2) == player2 or Util_GetPlayerOwner(eg_allied_capturePoint2) == player4 then
			Rule_RemoveMe()
			EGroup_SetPlayerOwner(eg_allied_base, player2)
				--broadcast a message
			Util_MissionTitle(Util_CreateLocString("The Axis broke through the front line and captured the area"))
		end
	end
end ]]

function Axis_CheckPointCaptured()
	if (Util_GetPlayerOwner(eg_allied_capturePoint2) == player2 or Util_GetPlayerOwner(eg_allied_capturePoint2) == player4) and (Util_GetPlayerOwner(eg_allied_capturePoint3) == player2 or Util_GetPlayerOwner(eg_allied_capturePoint3) == player4) then
		Rule_RemoveMe()
		
		Axis_StartHoldTimer()
		
		if Rule_Exists(Axis_CheckHoldTimer) == false then
			Rule_AddInterval(Axis_CheckHoldTimer, 1)
		end
	end
end

function Axis_StartHoldTimer()
	--if Timer_Exists(tmr_Axis_cap) == false then
	--	Timer_Start(tmr_Axis_cap,  g_Axis_capTimer)
	if Objective_IsTimerSet(obj_MainObjective_allies) == false then
		Objective_UpdateText(obj_MainObjective_allies, Util_CreateLocString("If the Allies fail to retake the points Axis will win")) -- LOCDB [11079163] 'Hold the Fuel Depot'
		Objective_StartTimer(obj_MainObjective_allies, COUNT_DOWN, g_Axis_capTimer, 10)	
				
		--[[if fuelUIID ~= nil then
			Objective_RemoveUIElements(SOBJ_CapFuelPoints, fuelUIID)
			fuelUIID = Objective_AddUIElements(SOBJ_CapFuelPoints, eg_fuelLocation, true, 11079163, true, 3.5) 		--[11079163] 'Hold the Fuel Depot'
		end]]
	end
end

function Axis_StopHoldTimer()
	if Objective_IsTimerSet(obj_MainObjective_allies) == true then
		--Timer_End(tmr_Axis_cap)
		Objective_UpdateText(obj_MainObjective_allies, Util_CreateLocString("Allies have to defend"), nil) --[11076623] 'Capture the Fuel Depot'
		Objective_StopTimer(obj_MainObjective_allies)
		
		--[[if fuelUIID ~= nil then
			Objective_RemoveUIElements(SOBJ_CapFuelPoints, fuelUIID)
			fuelUIID = Objective_AddUIElements(SOBJ_CapFuelPoints, eg_fuelLocation, true, 11076623, true, 3.5) 		--[11076623] 'Capture the Fuel Depot'
		end ]]
		
		Rule_AddInterval(Axis_CheckPointCaptured, 1)
		Rule_RemoveMe()
	end
end


	--Check if the timer has finished
function Axis_CheckHoldTimer()
	--Obj_ShowProgressTimer(Util_CreateLocString("Time"), g_Axis_cap_TimeRemaining) --doesn't work
	--g_Axis_cap_TimeRemaining = g_Axis_cap_TimeRemaining - 1

	if (Util_GetPlayerOwner(eg_allied_capturePoint2) == player1 or Util_GetPlayerOwner(eg_allied_capturePoint2) == player3) and (Util_GetPlayerOwner(eg_allied_capturePoint3) == player1 or Util_GetPlayerOwner(eg_allied_capturePoint3) == player3) then
		Rule_RemoveMe()
		Rule_AddInterval(Axis_StopHoldTimer, 1)
		
	elseif --[[(Util_GetPlayerOwner(eg_allied_capturePoint2) == player2 or Util_GetPlayerOwner(eg_allied_capturePoint2) == player4) and (Util_GetPlayerOwner(eg_allied_capturePoint3) == player2 or Util_GetPlayerOwner(eg_allied_capturePoint3) == player4) and]] math.floor(Objective_GetTimerSeconds(obj_MainObjective_allies)) == 0 then
		Rule_RemoveMe()
			--broadcast a message
		Util_MissionTitle(Util_CreateLocString("The Axis broke through the front line and captured the area"), 1, 5, 1)
			--end the game
		Rule_AddOneShot(Game_axis_win, 7)
			--fail the objective
		--Objective_Fail(obj_MainObjective_allies) ~not really necessary
		sg_Allies_lost1 = SGroup_CreateIfNotFound("sg_Allies_lost1")
		sg_Allies_lost2 = SGroup_CreateIfNotFound("sg_Allies_lost2")
		Player_GetAll(player1, sg_Allies_lost1)
		Player_GetAll(player3, sg_Allies_lost2)
		--SGroup_SetSelectable(sg_Allies_lost1, false) --not necessary 
		--SGroup_SetSelectable(sg_Allies_lost2, false)
		Cmd_Retreat(sg_Allies_lost1, Marker_GetPosition(mkr_Allies_withdraw), mkr_Allies_withdraw, false)
		Cmd_Retreat(sg_Allies_lost2, Marker_GetPosition(mkr_Allies_withdraw2), mkr_Allies_withdraw2, false)
		Obj_HideProgress()
	end
end

function Game_axis_win()
	World_SetTeamWin(Player_GetTeam(player2))
end

function Game_allies_win()
	World_SetTeamWin(Player_GetTeam(player1))
end





