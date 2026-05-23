-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- Operation Hurricane
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
import("op_1.events")
import("op_1_encounters.scar")

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------

function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

	local LOC_name = Util_CreateLocString("LocString")


function OnGameSetup( )
	print("Running OnGameSetup...")
	player1 = World_GetPlayerAt(1) -- Player
	player2 = World_GetPlayerAt(2) -- Enemy or ally
	player3 = World_GetPlayerAt(3)
	player4 = World_GetPlayerAt(4)
	
	Setup_SetPlayerName(player1, Util_CreateLocString("US Forces"))
	Setup_SetPlayerName(player2, Util_CreateLocString("RAF"))
	Setup_SetPlayerName(player3, Util_CreateLocString("Wehrmacht"))
	
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
	INIT_MainOBJ()
	
	INIT_SecondOBJ()
	
	INIT_ThirdOBJ()
	
	INIT_FourthOBJ()
	
	INIT_FithOBJ()
	
	-- Main obj
--~	INIT_MainOBJ()
--~	Objective_Start(INIT_MainOBJ, false)


	--[[ MISSION START ]]
	Mission_Start()

	
	print("Mission initialization finished.")
end

Scar_AddInit(OnInit)
	print("Scar actions executing...")
	
	
--[[function Audio_Init()

	--Sound_PreCacheSoundFolder("single_player/m12")
	--Sound_PreCacheSinglePlayerSpeech("mission/m12")
	missionSpeechPath = "botb/gameplay"					-- Speech path to cache (string)

end
Scar_AddInit(Audio_Init) ]]
	
function INIT_MainOBJ()

	print("Initializing First Objective...")
	obj_Main = {
		--Info
		Title = Util_CreateLocString("Destroy the first German structure"),  --The objective's text
		TitleEnd = nil, -- The the message displayed on completion
		TitleFail = nil, -- The message displayed on failure
		Type = OT_Primary, -- This defines the type of objective (and by extension how it is displayed to the player)
		Parent = nil, -- If this objective has a parent, the parent objective is put here
		subObjectives = {}, --Any subobjectives to a parent objective
		
		--Intel
		Intel_Start = 				EVENTS.opH_Intro,	-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = 		nil,	-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			nil,	-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = 	nil,	-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				nil,	-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = 		nil,	-- Function to play if Intel_Fail is Skipped
		
		--Functions
		SetupUI = function() 
			
		end,
		
		PreStart = nil,
		
		OnStart = function()
			Objective_Start(sobj_locateBuilding1, false)
		end,
		
		IsComplete = function()
			return false
		end,
		
		PreComplete = nil,
		
		OnComplete = function()
			Objective_Start(obj_Second)
		end, 
		
		IsFailed = nil,
		
		PreFail = nil,
		
		OnFail = function()
		
		end,
		
		
		-- IsComplete = function() -- Template for functions that do stuff
		--	return false
		-- end,			
	}
	
	sobj_locateBuilding1 = {
	Title = Util_CreateLocString("Locate the building"), 		-- LOCDB [11076623] 'Capture the Fuel Depot'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,						
		Parent = obj_Main,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			EVENTS.opH_building1_airStrike,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function()
			end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = function()
			Objective_Start(sobj_CaptureBuilding1, false)
		end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(obj_Main.subObjectives, sobj_locateBuilding1)
	
	sobj_CaptureBuilding1 = {
	Title = Util_CreateLocString("Capture the point"), 		-- LOCDB [11076623] 'Capture the Fuel Depot'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,						
		Parent = obj_Main,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function()
			end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = function()
			Objective_Start(sobj_repellWaveBuilding1, false)
		end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(obj_Main.subObjectives, sobj_CaptureBuilding1)
	
	sobj_repellWaveBuilding1 = {
	Title = Util_CreateLocString("Fight off the counterattack"), 		-- LOCDB [11076623] 'Capture the Fuel Depot'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,						
		Parent = obj_Main,				
		
		Intel_Start = 				EVENTS.sobj_repellWaveBuilding1_intro,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				EVENTS.sobj_repellWaveBuilding1_fail,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function()
			end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = function()
			Objective_Complete(obj_Main)
		end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(obj_Main.subObjectives, sobj_repellWaveBuilding1)
	
	Objective_Register(obj_Main)
	Objective_Register(sobj_locateBuilding1)
	Objective_Register(sobj_CaptureBuilding1)
	Objective_Register(sobj_repellWaveBuilding1)
	
end

function INIT_SecondOBJ()

	print("Initializing Second Objective...")
	obj_Second = {
		--Info
		Title = Util_CreateLocString("Retrieve coordinates of the second position"),  --The objective's text
		TitleEnd = nil, -- The the message displayed on completion
		TitleFail = nil, -- The message displayed on failure
		Type = OT_Primary, -- This defines the type of objective (and by extension how it is displayed to the player)
		Parent = nil, -- If this objective has a parent, the parent objective is put here
		subObjectives = {}, --Any subobjectives to a parent objective
		
		--Intel
		Intel_Start = 				nil,	-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = 		nil,	-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			EVENTS.opH_FreePOWs_Outtro,	-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = 	nil,	-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				nil,	-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = 		nil,	-- Function to play if Intel_Fail is Skipped
		
		--Functions
		SetupUI = function() 
			
		end,
		
		PreStart = nil,
		
		OnStart = function()
			Objective_Start(sobj_FreePOWs, false)
		end,
		
		IsComplete = function()
			return false
		end,
		
		PreComplete = nil,
		
		OnComplete = function()
		end, 
		
		IsFailed = nil,
		
		PreFail = nil,
		
		OnFail = function()
		
		end,
		
		
		-- IsComplete = function() -- Template for functions that do stuff
		--	return false
		-- end,			
	}
	
	sobj_FreePOWs = {
		--Info
		Title = Util_CreateLocString("Free the POWs"),  --The objective's text
		TitleEnd = nil, -- The the message displayed on completion
		TitleFail = nil, -- The message displayed on failure
		Type = OT_Primary, -- This defines the type of objective (and by extension how it is displayed to the player)
		Parent = obj_Second, -- If this objective has a parent, the parent objective is put here
		subObjectives = {}, --Any subobjectives to a parent objective
		
		--Intel
		Intel_Start = 				EVENTS.opH_FreePOWs_Intro,	-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = 		nil,	-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			nil,	-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = 	nil,	-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				nil,	-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = 		nil,	-- Function to play if Intel_Fail is Skipped
		
		--Functions
		SetupUI = function() 
			
		end,
		
		PreStart = nil,
		
		OnStart = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		PreComplete = nil,
		
		OnComplete = function()
			Objective_Start(sobj_EscortPOWs, false)
		end, 
		
		IsFailed = nil,
		
		PreFail = nil,
		
		OnFail = function()
		
		end,
		
		
		-- IsComplete = function() -- Template for functions that do stuff
		--	return false
		-- end,			
	}
	table.insert(obj_Second.subObjectives, sobj_FreePOWs)
	
	sobj_EscortPOWs = {
		--Info
		Title = Util_CreateLocString("Escort the rescued soldiers to safety"),  --The objective's text
		TitleEnd = nil, -- The the message displayed on completion
		TitleFail = nil, -- The message displayed on failure
		Type = OT_Primary, -- This defines the type of objective (and by extension how it is displayed to the player)
		Parent = obj_Second, -- If this objective has a parent, the parent objective is put here
		subObjectives = {}, --Any subobjectives to a parent objective
		
		--Intel
		Intel_Start = 				nil,	-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = 		nil,	-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			nil,	-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = 	nil,	-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				EVENTS.sobj_EscortPOWs_fail,	-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = 		nil,	-- Function to play if Intel_Fail is Skipped
		
		--Functions
		SetupUI = function() 
			
		end,
		
		PreStart = nil,
		
		OnStart = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		PreComplete = nil,
		
		OnComplete = function()
			Objective_Complete(obj_Second)
		end, 
		
		IsFailed = nil,
		
		PreFail = nil,
		
		OnFail = function()
		
		end,
		
		
		-- IsComplete = function() -- Template for functions that do stuff
		--	return false
		-- end,			
	}
	table.insert(obj_Second.subObjectives, sobj_EscortPOWs)
	
	Objective_Register(obj_Second)
	Objective_Register(sobj_FreePOWs)
	Objective_Register(sobj_EscortPOWs)
	
end 

function INIT_ThirdOBJ()

	print("Initializing Third Objective...")
	obj_Third = {
		--Info
		Title = Util_CreateLocString("Clear out the entrenched position"),  --The objective's text
		TitleEnd = nil, -- The the message displayed on completion
		TitleFail = nil, -- The message displayed on failure
		Type = OT_Primary, -- This defines the type of objective (and by extension how it is displayed to the player)
		Parent = nil, -- If this objective has a parent, the parent objective is put here
		subObjectives = {}, --Any subobjectives to a parent objective
		
		--Intel
		Intel_Start = 				EVENTS.obj_Third_intro,	-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = 		nil,	-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			nil,	-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = 	nil,	-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				nil,	-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = 		nil,	-- Function to play if Intel_Fail is Skipped
		
		--Functions
		SetupUI = function() 
			UI_obj_Third1 = Objective_AddUIElements(obj_Third, EGroup_GetPosition(eg_obj3_territory1), true, Util_CreateLocString("Hold this point"), true, 3.5)
			UI_obj_Third2 = Objective_AddUIElements(obj_Third, EGroup_GetPosition(eg_obj3_territory2), true, Util_CreateLocString("Hold this point"), true, 3.5)
			UI_obj_Third3 = Objective_AddUIElements(obj_Third, EGroup_GetPosition(eg_obj3_territory3), true, Util_CreateLocString("Hold this point"), true, 3.5)
		end,
		
		PreStart = nil,
		
		OnStart = function()
			Objective_Start(sobj_defend)
		end,
		
		IsComplete = function()
			return false
		end,
		
		PreComplete = nil,
		
		OnComplete = function()
		end, 
		
		IsFailed = nil,
		
		PreFail = nil,
		
		OnFail = function()
		
		end,
		
		
		-- IsComplete = function() -- Template for functions that do stuff
		--	return false
		-- end,			
	}
	
	sobj_defend = {
		--Info
		Title = Util_CreateLocString("Hold the line"),  --The objective's text
		TitleEnd = nil, -- The the message displayed on completion
		TitleFail = nil, -- The message displayed on failure
		Type = OT_Primary, -- This defines the type of objective (and by extension how it is displayed to the player)
		Parent = obj_Third, -- If this objective has a parent, the parent objective is put here
		subObjectives = {}, --Any subobjectives to a parent objective
		
		--Intel
		Intel_Start = 				nil,	-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = 		nil,	-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			EVENTS.sobj_defend_completed,	-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = 	nil,	-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				EVENTS.sobj_defend_failed,	-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = 		nil,	-- Function to play if Intel_Fail is Skipped
		
		--Functions
		SetupUI = function() 
			
		end,
		
		PreStart = nil,
		
		OnStart = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		PreComplete = nil,
		
		OnComplete = function()
			Objective_Start(sobj_assault_position3, false)
		end, 
		
		IsFailed = nil,
		
		PreFail = nil,
		
		OnFail = function()
		
		end,
		
		
		-- IsComplete = function() -- Template for functions that do stuff
		--	return false
		-- end,			
	}
	table.insert(obj_Third.subObjectives, sobj_defend)
	
	sobj_assault_position3 = {
		--Info
		Title = Util_CreateLocString("Break through the front line and capture the points"),  --The objective's text
		TitleEnd = nil, -- The the message displayed on completion
		TitleFail = nil, -- The message displayed on failure
		Type = OT_Primary, -- This defines the type of objective (and by extension how it is displayed to the player)
		Parent = obj_Third, -- If this objective has a parent, the parent objective is put here
		subObjectives = {}, --Any subobjectives to a parent objective
		
		--Intel
		Intel_Start = 				nil,	-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = 		nil,	-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			nil,	-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = 	nil,	-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				nil,	-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = 		nil,	-- Function to play if Intel_Fail is Skipped
		
		--Functions
		SetupUI = function() 
				--1
			UI_sobj_assault_position3_1 = Objective_AddUIElements(sobj_assault_position3, EGroup_GetPosition(eg_obj3_territory1), true, Util_CreateLocString("Capture"), true, 3.5)
				--2
			UI_sobj_assault_position3_2 = Objective_AddUIElements(sobj_assault_position3, EGroup_GetPosition(eg_obj3_territory2), true, Util_CreateLocString("Capture"), true, 3.5)
				--3
			UI_sobj_assault_position3_3 = Objective_AddUIElements(sobj_assault_position3, EGroup_GetPosition(eg_obj3_territory4), true, Util_CreateLocString("Capture"), true, 3.5)
				--4
			UI_sobj_assault_position3_4 = Objective_AddUIElements(sobj_assault_position3, EGroup_GetPosition(eg_obj3_territory5), true, Util_CreateLocString("Capture"), true, 3.5)
				--5
			UI_sobj_assault_position3_5 = Objective_AddUIElements(sobj_assault_position3, EGroup_GetPosition(eg_obj3_territory6), true, Util_CreateLocString("Capture"), true, 3.5)
				--6
			UI_sobj_assault_position3_6 = Objective_AddUIElements(sobj_assault_position3, EGroup_GetPosition(eg_obj3_territory7), true, Util_CreateLocString("Capture"), true, 3.5)
				--7
			UI_sobj_assault_position3_7 = Objective_AddUIElements(sobj_assault_position3, EGroup_GetPosition(eg_obj3_territory8), true, Util_CreateLocString("Capture"), true, 3.5)
		end,
		
		PreStart = nil,
		
		OnStart = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		PreComplete = nil,
		
		OnComplete = function()
			Objective_Complete(obj_Third)
		end, 
		
		IsFailed = nil,
		
		PreFail = nil,
		
		OnFail = function()
		
		end,
		
		
		-- IsComplete = function() -- Template for functions that do stuff
		--	return false
		-- end,			
	}
	table.insert(obj_Third.subObjectives, sobj_assault_position3)
	
	Objective_Register(obj_Third)
	Objective_Register(sobj_defend)
	Objective_Register(sobj_assault_position3)
	
end 

function INIT_FourthOBJ()

	print("Initializing Fourth Objective...")
	obj_Fourth = {
		--Info
		Title = Util_CreateLocString("Destroy German artillery guns"),  --The objective's text
		TitleEnd = nil, -- The the message displayed on completion
		TitleFail = nil, -- The message displayed on failure
		Type = OT_Primary, -- This defines the type of objective (and by extension how it is displayed to the player)
		Parent = nil, -- If this objective has a parent, the parent objective is put here
		subObjectives = {}, --Any subobjectives to a parent objective
		
		--Intel
		Intel_Start = 				EVENTS.obj_Fourth_intro,	-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = 		nil,	-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			EVENTS.obj_Fourth_completed,	-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = 	nil,	-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				nil,	-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = 		nil,	-- Function to play if Intel_Fail is Skipped
		
		--Functions
		SetupUI = function() 
			UI_obj_Fourth1 = Objective_AddUIElements(obj_Fourth, SGroup_GetPosition(sg_AxisArtillery1), true, Util_CreateLocString("German Artillery"), true, 3.5)
			UI_obj_Fourth2 = Objective_AddUIElements(obj_Fourth, SGroup_GetPosition(sg_AxisArtillery2), true, Util_CreateLocString("German Artillery"), true, 3.5)
			UI_obj_Fourth3 = Objective_AddUIElements(obj_Fourth, SGroup_GetPosition(sg_AxisArtillery3), true, Util_CreateLocString("German Artillery"), true, 3.5)
		end,
		
		PreStart = nil,
		
		OnStart = function()
			Objective_Start(sobj_destroyGuns, false)
		end,
		
		IsComplete = function()
			return false
		end,
		
		PreComplete = nil,
		
		OnComplete = function()
		end, 
		
		IsFailed = nil,
		
		PreFail = nil,
		
		OnFail = function()
		
		end,
		
		
		-- IsComplete = function() -- Template for functions that do stuff
		--	return false
		-- end,			
	}
	
	sobj_destroyGuns = {
		--Info
		Title = Util_CreateLocString("Howitzers destroyed:"),  --The objective's text
		TitleEnd = nil, -- The the message displayed on completion
		TitleFail = nil, -- The message displayed on failure
		Type = OT_Primary, -- This defines the type of objective (and by extension how it is displayed to the player)
		Parent = obj_Fourth, -- If this objective has a parent, the parent objective is put here
		subObjectives = {}, --Any subobjectives to a parent objective
		
		--Intel
		Intel_Start = 				nil,	-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = 		nil,	-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			nil,	-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = 	nil,	-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				nil,	-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = 		nil,	-- Function to play if Intel_Fail is Skipped
		
		--Functions
		SetupUI = function() 
			Objective_SetCounter(sobj_destroyGuns, 0, 3)
		end,
		
		PreStart = nil,
		
		OnStart = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		PreComplete = nil,
		
		OnComplete = function()
			Objective_Complete(obj_Fourth)
		end, 
		
		IsFailed = nil,
		
		PreFail = nil,
		
		OnFail = function()
		
		end,
		
		
		-- IsComplete = function() -- Template for functions that do stuff
		--	return false
		-- end,			
	}
	table.insert(obj_Fourth.subObjectives, sobj_destroyGuns)
	
	Objective_Register(obj_Fourth)
	Objective_Register(sobj_destroyGuns)
	
end

function INIT_FithOBJ()

	print("Initializing Fourth Objective...")
	obj_Fith = {
		--Info
		Title = Util_CreateLocString("Destroy the German HQ before they evacuate"),  --The objective's text
		TitleEnd = nil, -- The the message displayed on completion
		TitleFail = nil, -- The message displayed on failure
		Type = OT_Primary, -- This defines the type of objective (and by extension how it is displayed to the player)
		Parent = nil, -- If this objective has a parent, the parent objective is put here
		subObjectives = {}, --Any subobjectives to a parent objective
		
		--Intel
		Intel_Start = 				EVENTS.obj_Fith_intro,	-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = 		nil,	-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			EVENTS.obj_Fith_completed,	-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = 	nil,	-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				EVENTS.obj_Fith_failed,	-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = 		nil,	-- Function to play if Intel_Fail is Skipped
		
		--Functions
		SetupUI = function() 
		end,
		
		PreStart = nil,
		
		OnStart = function()
			Objective_Start(sobj_killConvoyBeforeRefuel, false)
		end,
		
		IsComplete = function()
			return false
		end,
		
		PreComplete = nil,
		
		OnComplete = function()
		end, 
		
		IsFailed = nil,
		
		PreFail = nil,
		
		OnFail = function()
		
		end,
		
		
		-- IsComplete = function() -- Template for functions that do stuff
		--	return false
		-- end,			
	}
	
	sobj_killConvoyBeforeRefuel = {
		--Info
		Title = Util_CreateLocString("Destroy the Convoy before it finishes refueling"),  --The objective's text
		TitleEnd = nil, -- The the message displayed on completion
		TitleFail = nil, -- The message displayed on failure
		Type = OT_Secondary, -- This defines the type of objective (and by extension how it is displayed to the player)
		Parent = obj_Fith, -- If this objective has a parent, the parent objective is put here
		subObjectives = {}, --Any subobjectives to a parent objective
		
		--Intel
		Intel_Start = 				nil,	-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = 		nil,	-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			nil,	-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = 	nil,	-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				nil,	-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = 		nil,	-- Function to play if Intel_Fail is Skipped
		
		--Functions
		SetupUI = function() 
		end,
		
		PreStart = nil,
		
		OnStart = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		PreComplete = nil,
		
		OnComplete = function()
		end, 
		
		IsFailed = nil,
		
		PreFail = nil,
		
		OnFail = function()
		
		end,
		
		
		-- IsComplete = function() -- Template for functions that do stuff
		--	return false
		-- end,			
	}
	table.insert(obj_Fith.subObjectives, sobj_killConvoyBeforeRefuel)
	
	Objective_Register(obj_Fith)
	Objective_Register(sobj_killConvoyBeforeRefuel)
	
end 
	
function Mission_Restrictions()	
	Player_AddAbility(player2, BP_GetAbilityBlueprint("allied_strategic_bombing"))
	Player_AddAbility(player2, BP_GetAbilityBlueprint("strafing_run"))
	Player_AddAbility(player2, BP_GetAbilityBlueprint("recon_sweep"))
	Player_AddAbility(player2, BP_GetAbilityBlueprint("usf_strafing_run"))
	Player_AddAbility(player2, BP_GetAbilityBlueprint("pm_airborne_rocket"))
	Player_AddAbility(player2, BP_GetAbilityBlueprint("p47_recon_mp"))
	Player_AddAbility(player2, BP_GetAbilityBlueprint("paratroopers_paradrop"))
	Player_AddAbility(player2, BP_GetAbilityBlueprint("air_drop_combat_group"))
-------------------------------------------------------------------------
	Player_SetUpgradeAvailability(player1, BP_GetUpgradeBlueprint("major_dispatched_upgrade_mp"), ITEM_LOCKED)
-------------------------------------------------------------------------
	Player_SetMaxPopulation(player2, CT_Personnel, 30)
end

function Mission_SetupVariables()
	print("Initializing mission DATA...")
	--E~ I wouldnt do global data like OBJ's or useEncounterSystem in a table, but its up to you
	
	
    g_missionData = {
		useEncounterSystem = true,
		--missionSpeechPath = "botb/gameplay",
		objectives = {
			obj_Main,	-- These are the global references to the objective tables defined in the separete files.
			obj_Second,
			obj_Third,
			obj_Fourth,
		},
		startingUnits = {
		},
	}
	
	g_convoyDespawnCount = 0
	
	--------------------------------
	------------Timers--------------
	--------------------------------
	
	tmr_objHoldTheLine_clock = "tmr_objHoldTheLine_clock"
	
	tmr_objConvoy_clock = "tmr_objConvoy_clock"
	
	g_obj3_tmr = 240
	
	g_obj5_tmr = 120
	
	
	g_clockCount = 0
	g_clockInterval = 1
	
	
	--------------------------------
	--Modifiers
	--------------------------------
	
	--mod_devTest = Modifier_Create(MAT_Squad, , MUT_Multiplication, false, 10, )
	
	--------------------------------
	-------------Tables-------------
	--------------------------------
	
	Grens_table = {
		BP_GetSquadBlueprint("grenadier_squad_sp"),
		BP_GetSquadBlueprint("assault_grenadier_squad_mp"),
	}
	
	obj3_attackers_spawns = {
		mkr_e_obj3_attackers_spawn1,
		mkr_e_obj3_attackers_spawn2,
		mkr_e_obj3_attackers_spawn3,
	}
	
	obj3_attackers_targets = {
		mkr_e_obj3_target1,
		mkr_e_obj3_target2,
		mkr_e_obj3_target3,
	}
	
	obj3_attackers_blueprints = {
		SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP,
		SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
		SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
	}
	
	obj3_planes_abilityTable = {
		BP_GetAbilityBlueprint("usf_strafing_run"),
		BP_GetAbilityBlueprint("pm_airborne_rocket"),
	}
	
	table_british_BattleGroup_infantry = {
		BP_GetSquadBlueprint("tommy_squad_mp"),
		BP_GetSquadBlueprint("tommy_squad_flame_mp"),
		BP_GetSquadBlueprint("tommy_squad_recon_mp"),
	}
	
	table_british_BattleGroup_vehicles = {
		BP_GetSquadBlueprint("churchill_default_squad_mp"),
		BP_GetSquadBlueprint("centaur_aa_mk2_squad_mp"),
		BP_GetSquadBlueprint("cromwell_mk4_75mm_squad_mp"),
	}
	
	table_obj4_panzerIV_spawns = {
		mkr_spawn_german_artillery1,
		mkr_spawn_german_artillery2,
		mkr_spawn_german_artillery3,
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
	--useEncounterSystem = true
	g_useSkirmishAI = true
	g_useWithdraw = true
	g_AUTOSAVE_DELAY = 10
	
	-------------------------------
	--spawn in units	(Util_CreateSquads(player, sGroup, BP_GetSquadBlueprint("blueprint"), spawn, destination/nil, 1, nil, false))
	-------------------------------
	sg_AxisEncounter1 = SGroup_CreateIfNotFound("sg_AxisEncounter1")
	Util_CreateSquads(player3, sg_AxisEncounter1, BP_GetSquadBlueprint("grenadier_squad_sp"), eg_enemy_building1)
	Util_CreateSquads(player3, sg_AxisEncounter1, BP_GetSquadBlueprint("assault_grenadier_squad_mp"), eg_enemy_building1)
	AI_LockSquads(player3, sg_AxisEncounter1)
		--Spawn enemy base
	eg_germanbase = EGroup_CreateIfNotFound("eg_germanbase")
	E_german_base5 = Util_CreateEntities(player3, eg_germanbase, BP_GetEntityBlueprint("schweres_kriegswerk"), mkr_spawn_enemyBase5, 1, nil)
	E_german_base4 = Util_CreateEntities(player3, eg_germanbase, BP_GetEntityBlueprint("hintere_panzerwerk"), mkr_spawn_enemyBase4, 1, nil)
	E_german_base3 = Util_CreateEntities(player3, eg_germanbase, BP_GetEntityBlueprint("bereich_festung"), mkr_spawn_enemyBase3, 1, nil)
	E_german_base2 = Util_CreateEntities(player3, eg_germanbase, BP_GetEntityBlueprint("dolch_aktionen"), mkr_spawn_enemyBase2, 1, nil)
	E_german_base1 = Util_CreateEntities(player3, eg_germanbase, BP_GetEntityBlueprint("german_hq"), mkr_spawn_enemyBase1, 1, nil)
	
	AI_Enable(player2, false)
-------------------------------------------------------------------------
	print("Mission Preset activated.")
end

function Mission_Difficulty()
	
end

function Mission_Start()
	World_IncreaseInteractionStage()
	Objective_Start(obj_Main)
	sg_Allies_paradrop1 = SGroup_CreateIfNotFound("sg_Allies_paradrop1")
	Rule_Add(Start_building1Check)
		--manage resources
	Player_SetResource(player1, RT_Munition, 500)
	Player_SetResource(player1, RT_Fuel, 500)
	Modify_PlayerResourceRate(player1, RT_Fuel, 0)
-------------------------------------------------------------------------
	sg_Allies_retreat1 = SGroup_CreateIfNotFound("sg_Allies_retreat1")
	sg_Allies_retreat2 = SGroup_CreateIfNotFound("sg_Allies_retreat2")
-------------------------------------------------------------------------
	--if Misc_IsDevMode == true then	--some... support units- FOR TESTING PURPOSES ONLY
		--print("Activating Dev test")
		--sg_testSupport = SGroup_CreateIfNotFound("sg_testSupport")
		--Util_CreateSquads(player1, sg_testSupport, BP_GetSquadBlueprint("churchill_crocodile_mp"), Util_GetRandomPosition(mkr_POW_dest, 10), nil, 3)
		--Util_CreateSquads(player1, sg_testSupport, BP_GetSquadBlueprint("m4a3_76mm_sherman_bulldozer_squad_mp"), Util_GetRandomPosition(mkr_POW_dest, 10), nil, 3)
		--SGroup_SetInvulnerable(sg_testSupport, true) --]]
	--end
-------------------------------------------------------------------------
	--AiObj1 = AI_CreateObjective(player3, )
end

function Start_building1Check()
	if Player_CanSeeEGroup(player1, eg_enemy_building1, false) == true then
		Rule_RemoveMe()
		Camera_MoveTo(Marker_GetPosition(mkr_allied_airStrike1), true, 0.35, false, false)
		Game_SetMode(UI_Fullscreen)
		Sound_SetMusicCombatValue(10, 1)
		Player_ClearArea(player1, mkr_allied_airStrike1, false)
		Cmd_Ability(player2, BP_GetAbilityBlueprint("allied_strategic_bombing"), Marker_GetPosition(mkr_allied_airStrike1), nil, true, false)
		Rule_AddOneShot(RAF_activate, 5)
		Objective_Complete(sobj_locateBuilding1)
		--Game_Letterbox(true, 0.5) 
	end
end

function RAF_activate()
	AI_Enable(player2, true)
	Game_SetMode(UI_Normal)
	--Game_Letterbox(false, 2)
	sg_Axis_RAF_recon = SGroup_CreateIfNotFound("sg_Axis_RAF_recon")
	sg_player1 = SGroup_CreateIfNotFound("sg_player1")
	Rule_AddInterval(RAF_recon, 30)
	Rule_Add(Start_territory1_check)
end

function RAF_recon()
	Player_GetAll(player3, sg_Axis_RAF_recon)
	if SGroup_IsEmpty(sg_Axis_RAF_recon) == false then
		Cmd_Ability(player2, BP_GetAbilityBlueprint("recon_sweep"), SGroup_GetPosition(sg_Axis_RAF_recon), SGroup_GetPosition(sg_Axis_RAF_recon), true, false)
	end
end

function Start_territory1_check()
	 if Util_GetPlayerOwner(eg_territory1) == player1 or Util_GetPlayerOwner(eg_territory1) == player2 then
		Rule_RemoveMe()
		Objective_Complete(sobj_CaptureBuilding1)
			--spawn in the counterattack
		Rule_AddOneShot(building1_spawn_counterattack, 7)
		Rule_Add(building1_check_Point_counterattack)
			--spawn RAF support
		Cmd_Ability(player2, BP_GetAbilityBlueprint("paratroopers_paradrop"), Marker_GetPosition(mkr_spawn_paradrop1), nil, true, false)
		Cmd_Ability(player2, BP_GetAbilityBlueprint("paratroopers_paradrop"), Marker_GetPosition(mkr_spawn_paradrop2), nil, true, false)
	 end
end

function building1_spawn_counterattack()
	Util_CreateSquads(player3, sg_AxisEncounter1, Grens_table, Util_GetRandomPosition(mkr_building1_counterattack, 10), nil, World_GetRand(3, 5))
	--Util_CreateSquads(player3, sg_AxisEncounter1, BP_GetSquadBlueprint("assault_grenadier_squad_mp"), Util_GetRandomPosition(mkr_building1_counterattack, 10), nil, World_GetRand(1, 2))
	AI_LockSquads(player3, sg_AxisEncounter1)
	Cmd_AttackMoveThenCapture(sg_AxisEncounter1, eg_territory1)
		--start the encounter
	--ENCOUNTERS.building1_counterattack() --deprecated
	--g_enc_building1_counterattack = ENCOUNTERS.building1_counterattack() --doesn't work
	Rule_Add(Post_building1Check)
end

function building1_check_Point_counterattack()
	if Util_GetPlayerOwner(eg_territory1) == player3 then
		Rule_RemoveMe()
		Objective_Fail(sobj_repellWaveBuilding1)
		Rule_AddOneShot(GameOver, 7)
			--set everyone to retreat
		Player_GetAll(player1, sg_Allies_retreat1)
		Player_GetAll(player2, sg_Allies_retreat2)
		Cmd_Retreat(sg_Allies_retreat1)
		Cmd_Retreat(sg_Allies_retreat2)
	end
end

function Post_building1Check()
	if SGroup_IsAlive(sg_AxisEncounter1) == false then
		Rule_RemoveMe()
		Rule_Remove(building1_check_Point_counterattack)
		World_IncreaseInteractionStage()
		Objective_Complete(sobj_repellWaveBuilding1, false)
		Player_GetAll(player2, sg_Allies_paradrop1)
		Player_SetMaxPopulation(player2, CT_Personnel, 75)
		Objective_Start(obj_Second)
		Rule_AddOneShot(POW_Begin, 1)
	end
end

function POW_Begin()
	sg_POWs = SGroup_CreateIfNotFound("sg_POWs")
	--Util_CreateSquads(player2, sg_POWs, BP_GetSquadBlueprint("air_support_officer_squad_mp"), eg_POW_building)
	--Util_CreateSquads(player2, sg_POWs, BP_GetSquadBlueprint("brit_medic_squad_mp"), eg_POW_building)
	Util_CreateSquads(player2, sg_POWs, BP_GetSquadBlueprint("brit_medic_squad_mp"), mkr_spawn_POW1)
	Util_CreateSquads(player2, sg_POWs, BP_GetSquadBlueprint("brit_medic_squad_mp"), mkr_spawn_POW2)
	SGroup_SetWorldOwned(sg_POWs)
	--SGroup_SuggestPosture(sg_POWs, 1, -1)
	--AI_LockSquads(player2, sg_POWs)
-------------------------------------------------------------------------
	sg_POW_guards1 = SGroup_CreateIfNotFound("sg_POW_guards1")
	Util_CreateSquads(player3, sg_POW_guards1, BP_GetSquadBlueprint("grenadier_squad_sp"), mkr_POW_patrol_spawn1)
	Util_CreateSquads(player3, sg_POW_guards1, BP_GetSquadBlueprint("grenadier_squad_sp"), Util_GetRandomPosition(mkr_POW_patrol_spawn1))
	Util_CreateSquads(player3, sg_POW_guards1, BP_GetSquadBlueprint("assault_grenadier_squad_mp"), Util_GetRandomPosition(mkr_POW_patrol_spawn1))
	Util_CreateSquads(player3, sg_POW_guards1, BP_GetSquadBlueprint("grenadier_squad_sp"), Util_GetRandomPosition(mkr_POW_patrol_spawn1))
	AI_LockSquads(player3, sg_POW_guards1)
	Cmd_SquadPatrolMarker(sg_POW_guards1, mkr_POW_patrol)
	Cmd_SquadPatrolMarker(sg_POW_guards1, mkr_POW_patrol2)
	--Cmd_SquadPath(sg_POW_guards1, "POW_patrol", true, LOOP_TOGGLE_DIRECTION, true, 0)
	--------------------------------
	sg_obj2_hmgs = SGroup_CreateIfNotFound("sg_obj2_hmgs")
	Util_CreateSquads(player3, sg_obj2_hmgs, BP_GetSquadBlueprint("mg42_heavy_machine_gun_squad"), mkr_spawn_obj2_hmg1)
	Util_CreateSquads(player3, sg_obj2_hmgs, BP_GetSquadBlueprint("mg42_heavy_machine_gun_squad"), mkr_spawn_obj2_hmg2)
	Util_CreateSquads(player3, sg_obj2_hmgs, BP_GetSquadBlueprint("mg42_heavy_machine_gun_squad"), eg_obj2_building1, nil, 2)
	AI_LockSquads(player3, sg_obj2_hmgs)
	SGroup_SetInvulnerable(sg_obj2_hmgs, true)
	--------------------------------
		--german artillery
	sg_AxisArtillery1 = SGroup_CreateIfNotFound("sg_AxisArtillery1")
	sg_AxisArtillery2 = SGroup_CreateIfNotFound("sg_AxisArtillery2")
	sg_AxisArtillery3 = SGroup_CreateIfNotFound("sg_AxisArtillery3")
	Util_CreateSquads(player3, sg_AxisArtillery1, BP_GetSquadBlueprint("howitzer_105mm_le_fh18_artillery_mp"), mkr_spawn_german_artillery1)
	Util_CreateSquads(player3, sg_AxisArtillery2, BP_GetSquadBlueprint("howitzer_105mm_le_fh18_artillery_mp"), mkr_spawn_german_artillery2)
	Util_CreateSquads(player3, sg_AxisArtillery3, BP_GetSquadBlueprint("howitzer_105mm_le_fh18_artillery_mp"), mkr_spawn_german_artillery3)
	SGroup_SetInvulnerable(sg_AxisArtillery1, true)
	SGroup_EnableMinimapIndicator(sg_AxisArtillery1, false) --1
	SGroup_SetInvulnerable(sg_AxisArtillery2, true)
	SGroup_EnableMinimapIndicator(sg_AxisArtillery2, false) --2 
	SGroup_SetInvulnerable(sg_AxisArtillery3, true)
	SGroup_EnableMinimapIndicator(sg_AxisArtillery3, false) --3
-------------------------------------------------------------------------
	Rule_Add(Start_POW_check)
	Rule_Add(Start_POW_Guard_check)
end


function Start_POW_Guard_check()
	if Player_CanSeeSGroup(player1, sg_POWs, true) == true and SGroup_IsAlive(sg_POW_guards1) == true and SGroup_IsOnScreen(player1, sg_POWs, true) == true then
		Rule_RemoveMe()
		FOW_RevealSGroupOnly(sg_POW_guards1, -1)
		hp_POW4 = HintPoint_Add(sg_POW_guards1, true, Util_CreateLocString("Kill"))
		Rule_Add(POW_guards_check)
	end
end


function POW_guards_check()
	if SGroup_IsAlive(sg_POW_guards1) == false then
		Rule_RemoveMe()
		HintPoint_Remove(hp_POW4)
	end
end

function Start_POW_check()
	if Player_CanSeeSGroup(player1, sg_POWs, true) == true and SGroup_IsAlive(sg_POW_guards1) == false and SGroup_IsOnScreen(player1, sg_POWs, true) == true then
		Rule_RemoveMe()
		Objective_Complete(sobj_FreePOWs)
		SGroup_SetPlayerOwner(sg_POWs, player2)
			--spawn the other POWs
		Util_CreateSquads(player2, sg_POWs, BP_GetSquadBlueprint("air_support_officer_squad_mp"), Util_GetRandomPosition(mkr_spawn_POW1))
		Util_CreateSquads(player2, sg_POWs, BP_GetSquadBlueprint("brit_medic_squad_mp"), Util_GetRandomPosition(mkr_spawn_POW2))
		AI_LockSquads(player2, sg_POWs)
			--set the the squads for the POWs to follow
		sg_POW_escorters = SGroup_CreateIfNotFound("sg_POW_escorters")
		World_GetSquadsNearMarker(player1, sg_POW_escorters, mkr_POW_patrol, OT_Player)
		if SGroup_IsEmpty(sg_POW_escorters) == true then
			Player_GetAll(player1, sg_POW_escorters)
		end
			--add UI indicators
		hp_POW1 = HintPoint_Add(sg_POW_escorters, true, Util_CreateLocString("Rescued British soldiers will follow this squad"))
		hp_POW2 = HintPoint_Add(sg_POWs, true, Util_CreateLocString("Escort to HQ"))
		hp_POW3 = Objective_AddUIElements(sobj_EscortPOWs, Marker_GetPosition(mkr_POW_dest), true, Util_CreateLocString("HQ"), true)
		Rule_Add(POW_escort_move)
		Rule_Add(POW_escort_check)
	end
end

function POW_escort_move()
	if SGroup_IsEmpty(sg_POW_escorters) == true then
		Rule_RemoveMe()
		Cmd_Retreat(sg_POWs, Marker_GetPosition(mkr_POW_dest))
	else
		Cmd_Move(sg_POWs, SGroup_GetPosition(sg_POW_escorters))
	end
end

function POW_escort_check()
	
	if SGroup_IsPinned(sg_POWs, false) == true then
		Cmd_Retreat(sg_POWs, Marker_GetPosition(mkr_POW_patrol))
	end
	
	if SGroup_IsEmpty(sg_POWs) == true then 
		Rule_RemoveMe()
		Rule_AddOneShot(GameOver, 7)
		Objective_Fail(sobj_EscortPOWs)
			--set everyone to retreat
		Player_GetAll(player1, sg_Allies_retreat1)
		Player_GetAll(player2, sg_Allies_retreat2)
		Cmd_Retreat(sg_Allies_retreat1)
		Cmd_Retreat(sg_Allies_retreat2)
	end
	
	if SGroup_TotalMembersCount(sg_POWs, false) <= 7 then
		WinWarning_PublishLoseReminder(player1, 2)
	end
	
	if Util_GetDistance(sg_POWs, mkr_POW_dest) <= 20 then
		Rule_RemoveMe()
		if Rule_Exists(POW_escort_move) == true then
			Rule_Remove(POW_escort_move)
		end
			--remove UI indicators
		Objective_Complete(sobj_EscortPOWs)
		HintPoint_Remove(hp_POW1)
		HintPoint_Remove(hp_POW2)
		Objective_RemoveUIElements(sobj_EscortPOWs, hp_POW3)
			--cinematic air strike
		Camera_MoveTo(Marker_GetPosition(mkr_allied_airStrike2), true, 0.7, false, false)
		Game_SetMode(UI_Fullscreen)
		Player_ClearArea(player1, mkr_allied_airStrike2, false)
		Cmd_Ability(player2, BP_GetAbilityBlueprint("allied_strategic_bombing"), Marker_GetPosition(mkr_allied_airStrike2), nil, true, false)
		Cmd_Ability(player2, BP_GetAbilityBlueprint("p47_recon_mp"), Marker_GetPosition(mkr_allied_airStrike2), nil, true, false)
		Cmd_Ability(player2, BP_GetAbilityBlueprint("strafing_run"), Marker_GetPosition(mkr_allied_strafingRun1), nil, true, false)
		Cmd_Ability(player2, BP_GetAbilityBlueprint("p47_recon_mp"), Marker_GetPosition(mkr_allied_strafingRun1), nil, true, false)
		SGroup_SetInvulnerable(sg_obj2_hmgs, false)
		Rule_AddOneShot(RAF_airstrike2, 5)
		Rule_AddOneShot(obj2_unlock_hmgs, 10)
			--unlock RAF abilities
		if SGroup_ContainsBlueprints(sg_POWs, BP_GetSquadBlueprint("air_support_officer_squad_mp"), false) == true then
			Rule_AddOneShot(unlock_RAF_abilities, 30)
		end
	end
end

function unlock_RAF_abilities()
	Player_AddAbility(player1, BP_GetAbilityBlueprint("usf_strafing_run"))
	Player_AddAbility(player1, BP_GetAbilityBlueprint("pm_airborne_strafe"))
	Player_AddAbility(player1, BP_GetAbilityBlueprint("pm_airborne_rocket"))
	Util_StartIntel(EVENTS.opH_FreePOWs_officer_survived)
end

function obj2_unlock_hmgs()
	AI_UnlockSquads(player3, sg_obj2_hmgs)
end

function RAF_airstrike2()
	Game_SetMode(UI_Normal)
	AI_UnlockSquads(player2, sg_POWs)
	World_IncreaseInteractionStage()
	--Game_Letterbox(false, 2)
-------------------------------------------------------------------------
	Rule_AddOneShot(obj3_setup, 1)
end

function obj3_setup()
	Rule_Add(Start_obj3_PointCheck)
	Objective_Start(obj_Third, false)
	Rule_Add(obj3_bunker_intel)
	--Util_MonitorTerritory(eg_obj3_territoryAll, 0, g_obj3_tmr, nil, EVENTS.obj_Third_alert, obj_Third) --doesn't work
-------------------------------------------------------------------------
	EGroup_InstantCaptureStrategicPoint(eg_obj3_territoryAll, player1)
	sg_obj3_hmgs = SGroup_CreateIfNotFound("sg_obj3_hmgs")
	Util_CreateSquads(player3, sg_obj3_hmgs, BP_GetSquadBlueprint("mg42_heavy_machine_gun_squad"), eg_obj3_building1)
	AI_LockSquads(player3, sg_obj3_hmgs)
	SGroup_SetInvulnerable(sg_obj3_hmgs, true)
	
	sg_obj3_snipers = SGroup_CreateIfNotFound("sg_obj3_snipers")
	Util_CreateSquads(player3, sg_obj3_snipers, BP_GetSquadBlueprint("sniper_squad"), mkr_spawn_obj3_sniper1)
	Util_CreateSquads(player3, sg_obj3_snipers, BP_GetSquadBlueprint("sniper_squad"), mkr_spawn_obj3_sniper2)
	AI_LockSquads(player3, sg_obj3_snipers)
	SGroup_SetInvulnerable(sg_obj3_snipers, true)
	
	eg_germanBunkers = EGroup_CreateIfNotFound("eg_germanBunkers")
	E_german_bunker1 = Util_CreateEntities(player3, eg_germanBunkers, BP_GetEntityBlueprint("bunker_mp"), mkr_spawn_bunker1, 1, nil)
	E_german_bunker2 = Util_CreateEntities(player3, eg_germanBunkers, BP_GetEntityBlueprint("bunker_mp"), mkr_spawn_bunker2, 1, nil)
	E_german_bunker3 = Util_CreateEntities(player3, eg_germanBunkers, BP_GetEntityBlueprint("bunker_mp"), mkr_spawn_bunker3, 1, nil)
	E_german_bunker4 = Util_CreateEntities(player3, eg_germanBunkers, BP_GetEntityBlueprint("bunker_mp"), mkr_spawn_bunker4, 1, nil)
	E_german_bunker5 = Util_CreateEntities(player3, eg_germanBunkers, BP_GetEntityBlueprint("bunker_mp"), mkr_spawn_bunker5, 1, nil)
	E_german_bunker6 = Util_CreateEntities(player3, eg_germanBunkers, BP_GetEntityBlueprint("bunker_mp"), mkr_spawn_bunker6, 1, nil)
	EGroup_SetInvulnerable(eg_germanBunkers, true)
	--Cmd_InstantUpgrade(eg_germanBunkers, BP_GetUpgradeBlueprint("bunker_mg42_addition"))
	Player_AddResource(player3, RT_Munition, 900)
-------------------------------------------------------------------------
	sg_obj3_attackers = SGroup_CreateIfNotFound("sg_obj3_attackers")
	Rule_AddDelayedIntervalEx(obj_3_spawn_attackers, World_GetRand(20, 30), World_GetRand(10, 15), 3)
		-- Start the objective timer
	Timer_Start(tmr_objHoldTheLine_clock, g_obj3_tmr)
	Rule_AddInterval(HoldTheLine_UpdateClock, 1)
	Rule_AddOneShot(HoldTheLine_CheckClock, g_obj3_tmr)
end

function obj_3_spawn_attackers()
	Util_CreateSquads(player3, sg_obj3_attackers, obj3_attackers_blueprints,  Table_GetRandomItem(obj3_attackers_spawns), Table_GetRandomItem(obj3_attackers_targets), 7)
	--ENCOUNTERS.Objective3_attackers()
end

function obj3_bunker_intel()
	Player_GetAll(player1, sg_player1)
	if Prox_EGroupSGroup(eg_germanBunkers, sg_player1, PROX_SHORTEST) <= 45 --[[and EGroup_IsOnScreen(player1, eg_germanBunkers, false) == true ]]then
		Rule_RemoveMe()
		Rule_AddOneShot(Restart_obj3_bunker_intel, 15)
		Util_StartIntel(EVENTS.obj_Third_avoid_bunkers)
	end
end

function Restart_obj3_bunker_intel()
	if Timer_GetRemaining(Timer_GetElapsed(tmr_objHoldTheLine_clock)) >= 1 then
		Rule_Add(obj3_bunker_intel)
	end
end

function HoldTheLine_UpdateClock()
	local percentage = 1 - (Timer_GetElapsed(tmr_objHoldTheLine_clock)/g_obj3_tmr)
	local currTime = math.floor(Timer_GetRemaining(tmr_objHoldTheLine_clock))
	local text = Loc_FormatText(Util_CreateLocString("Time until British Planes arrive:"), Loc_FormatTime(currTime, false, false)) -- LOCDB [11076568] 'Time until allied support arrives: %1TIME%'
	
	Obj_ShowProgress2(text, percentage)
	
	--[[if Timer_GetRemaining(Timer_GetElapsed(tmr_objHoldTheLine_clock)) == 60 then
		Util_StartIntel(EVENTS.HoldTheLine_OneMinute)
	end]]
end

function HoldTheLine_CheckClock()
	--if Timer_GetRemaining(Timer_GetElapsed(tmr_objHoldTheLine_clock)) <= 1 then
			--stop executing rules
		--Rule_RemoveMe()
		Rule_Remove(Start_obj3_PointCheck)
		Rule_Remove(HoldTheLine_UpdateClock)
			--remove UI indicators
		if Rule_Exists(obj3_bunker_intel) == true then
			Rule_Remove(obj3_bunker_intel)
		end
		Obj_HideProgress()
		Objective_Complete(sobj_defend)
		Objective_RemoveUIElements(obj_Third, UI_obj_Third1)
		Objective_RemoveUIElements(obj_Third, UI_obj_Third2)
		Objective_RemoveUIElements(obj_Third, UI_obj_Third3)
			--airstrikes
		Cmd_Ability(player2, BP_GetAbilityBlueprint("p47_recon_mp"), Marker_GetPosition(mkr_allied_airStrike5), nil, true, false)
		Cmd_Ability(player2, BP_GetAbilityBlueprint("allied_strategic_bombing"), Marker_GetPosition(mkr_allied_airStrike3), nil, true, false)
		
		Cmd_Ability(player2, Table_GetRandomItem(obj3_planes_abilityTable), Marker_GetPosition(mkr_allied_airStrike4), mkr_allied_airStrike4, true, false)
		--Cmd_Ability(player2, BP_GetAbilityBlueprint("pm_airborne_rocket"), Marker_GetPosition(mkr_allied_airStrike4), mkr_allied_airStrike4, true, false)
		
		Cmd_Ability(player2, Table_GetRandomItem(obj3_planes_abilityTable), Marker_GetPosition(mkr_allied_airStrike5), mkr_allied_airStrike5, true, false)
		--Cmd_Ability(player2, BP_GetAbilityBlueprint("pm_airborne_rocket"), Marker_GetPosition(mkr_allied_airStrike5), mkr_allied_airStrike5, true, false)
		
		Cmd_Ability(player2, Table_GetRandomItem(obj3_planes_abilityTable), Marker_GetPosition(mkr_allied_airStrike6), mkr_allied_airStrike6, true, false)
		--Cmd_Ability(player2, BP_GetAbilityBlueprint("pm_airborne_rocket"), Marker_GetPosition(mkr_allied_airStrike6), mkr_allied_airStrike6, true, false)
			--spawn in armoured support
		sg_obj3_armour = SGroup_CreateIfNotFound("sg_obj3_armour")
		Util_CreateSquads(player1, sg_obj3_armour, BP_GetSquadBlueprint("m4a3_sherman_squad_mp"), Util_GetRandomPosition(mkr_spawn_AtMapEdge), mkr_allied_airStrike4, 3)
			--disable invulnerabilty of the German defenders
		SGroup_SetInvulnerable(sg_obj3_hmgs, false)
		SGroup_SetInvulnerable(sg_obj3_snipers, false)
		EGroup_SetInvulnerable(eg_germanBunkers, false)
-------------------------------------------------------------------------
			--start the encounters; spawns in Germans trying to hold the line
		sg_obj3_defenders = SGroup_CreateIfNotFound("sg_obj3_defenders")
		ENCOUNTERS.obj3_defenders1()
		ENCOUNTERS.obj3_defenders2()
		SGroup_SetInvulnerable(sg_obj3_defenders, 0.75, 30)
-------------------------------------------------------------------------
		Rule_Add(Obj3_Start_Sector_Check)
	--end
end

function Start_obj3_PointCheck()
	if EGroup_IsCapturedByPlayer(eg_obj3_territoryAll, player3, false) == true then
		Rule_RemoveMe()
		Objective_Fail(sobj_defend)
		Rule_AddOneShot(GameOver, 7)
			--set everyone to retreat
		Player_GetAll(player1, sg_Allies_retreat1)
		Player_GetAll(player2, sg_Allies_retreat2)
		Cmd_Retreat(sg_Allies_retreat1)
		Cmd_Retreat(sg_Allies_retreat2)
	end
end

function Obj3_Start_Sector_Check()
	--if EGroup_IsCapturedByPlayer(eg_obj3_territoryAllInSector, player1, true) == true then
	if Util_GetPlayerOwner(eg_obj3_territory1) == player1 or Util_GetPlayerOwner(eg_obj3_territory1) == player2 then
		if Util_GetPlayerOwner(eg_obj3_territory2) == player1 or Util_GetPlayerOwner(eg_obj3_territory2) == player2 then
			if Util_GetPlayerOwner(eg_obj3_territory4) == player1 or Util_GetPlayerOwner(eg_obj3_territory4) == player2 then
				if Util_GetPlayerOwner(eg_obj3_territory5) == player1 or Util_GetPlayerOwner(eg_obj3_territory5) == player2 then
					if Util_GetPlayerOwner(eg_obj3_territory6) == player1 or Util_GetPlayerOwner(eg_obj3_territory6) == player2 then
						if Util_GetPlayerOwner(eg_obj3_territory7) == player1 or Util_GetPlayerOwner(eg_obj3_territory7) == player2 then
							if Util_GetPlayerOwner(eg_obj3_territory8) == player1 or Util_GetPlayerOwner(eg_obj3_territory8) == player2 then
								Rule_RemoveMe()
								Objective_Complete(sobj_assault_position3)
								Objective_RemoveUIElements(sobj_assault_position3, UI_sobj_assault_position3_1)
								Objective_RemoveUIElements(sobj_assault_position3, UI_sobj_assault_position3_2)
								Objective_RemoveUIElements(sobj_assault_position3, UI_sobj_assault_position3_3)
								Objective_RemoveUIElements(sobj_assault_position3, UI_sobj_assault_position3_4)
								Objective_RemoveUIElements(sobj_assault_position3, UI_sobj_assault_position3_5)
								Objective_RemoveUIElements(sobj_assault_position3, UI_sobj_assault_position3_6)
								Objective_RemoveUIElements(sobj_assault_position3, UI_sobj_assault_position3_7)
-------------------------------------------------------------------------
								World_IncreaseInteractionStage()
								Objective_Start(obj_Fourth)
								Rule_Add(Start_howitzer1_check)
								Rule_Add(Start_howitzer2_check)
								Rule_Add(Start_howitzer3_check)
								Rule_Add(Start_obj_Fourth_check)
-------------------------------------------------------------------------
								SGroup_EnableMinimapIndicator(sg_AxisArtillery1, true)
								SGroup_SetInvulnerable(sg_AxisArtillery1, false) --1
								SGroup_EnableMinimapIndicator(sg_AxisArtillery2, true)
								SGroup_SetInvulnerable(sg_AxisArtillery2, false) --2
								SGroup_EnableMinimapIndicator(sg_AxisArtillery3, true)
								SGroup_SetInvulnerable(sg_AxisArtillery3, false) --3
								ENCOUNTERS.obj4_defenders1()
								ENCOUNTERS.obj4_defenders2()
								ENCOUNTERS.obj4_defenders3()
								sg_panzerIV_patrol = SGroup_CreateIfNotFound("sg_panzerIV_patrol")
								Util_CreateSquads(player3, sg_panzerIV_patrol, BP_GetSquadBlueprint("panzer_iv_squad"), Util_GetRandomPosition(Table_GetRandomItem(table_obj4_panzerIV_spawns), World_GetRand(20, 30)), nil, World_GetRand(2, 4))
								--Cmd_SquadPath(sg_panzerIV_patrol, wp_obj4_panzerIV_patrol, true, LOOP_NORMAL, true, nil)
								--AI_LockSquads(player3, sg_panzerIV_patrol)
								--Util_StartIntel(EVENTS.opH_DerbyOnDrugs)
								--Rule_AddOneShot(Goodbye, 10)
							end
						end
					end
				end
			end
		end
	end
	--end
end

function Start_howitzer1_check()
	if SGroup_IsAlive(sg_AxisArtillery1) == false then
		Rule_RemoveMe()
		Objective_IncreaseCounter(sobj_destroyGuns)
		Objective_RemoveUIElements(obj_Fourth, UI_obj_Fourth1)
	end
end

function Start_howitzer2_check()
	if SGroup_IsAlive(sg_AxisArtillery2) == false then
		Rule_RemoveMe()
		Objective_IncreaseCounter(sobj_destroyGuns)
		Objective_RemoveUIElements(obj_Fourth, UI_obj_Fourth2)
	end
end

function Start_howitzer3_check()
	if SGroup_IsAlive(sg_AxisArtillery3) == false then
		Rule_RemoveMe()
		Objective_IncreaseCounter(sobj_destroyGuns)
		Objective_RemoveUIElements(obj_Fourth, UI_obj_Fourth3)
	end
end

function Start_obj_Fourth_check()
	if SGroup_IsAlive(sg_AxisArtillery1) == false and SGroup_IsAlive(sg_AxisArtillery2) == false and SGroup_IsAlive(sg_AxisArtillery3) == false then
		Rule_RemoveMe()
		Objective_Complete(sobj_destroyGuns, false)
		World_IncreaseInteractionStage()
		Objective_Start(obj_Fith)
-------------------------------------------------------------------------
		sg_british_BattleGroup = SGroup_CreateIfNotFound("sg_british_BattleGroup")
		Util_CreateSquads(player2, sg_british_BattleGroup, table_british_BattleGroup_infantry, Util_GetRandomPosition(mkr_spawn_british_BattleGroup), mkr_dest_british_BattleGroup, 5)
		Util_CreateSquads(player2, sg_british_BattleGroup, table_british_BattleGroup_vehicles, Util_GetRandomPosition(mkr_spawn_british_BattleGroup), mkr_dest_british_BattleGroup, 7)
		----------------------------
			--german HQ convoy
		sg_Convoy = SGroup_CreateIfNotFound("sg_Convoy")
		sg_Convoy1 = SGroup_CreateIfNotFound("sg_Convoy1")
		sg_Convoy2 = SGroup_CreateIfNotFound("sg_Convoy2")
		sg_Convoy3 = SGroup_CreateIfNotFound("sg_Convoy3")
		sg_Convoy4 = SGroup_CreateIfNotFound("sg_Convoy4")
		sg_Convoy5 = SGroup_CreateIfNotFound("sg_Convoy5")
		Util_CreateSquads(player3, {sg_Convoy, sg_Convoy1}, BP_GetSquadBlueprint("sws_halftrack_squad_sp"), mkr_spawn_Convoy1, nil, 1)
		Util_CreateSquads(player3, {sg_Convoy, sg_Convoy2}, BP_GetSquadBlueprint("sws_halftrack_squad_sp"), mkr_spawn_Convoy2, nil, 1)
		Util_CreateSquads(player3, {sg_Convoy, sg_Convoy3}, BP_GetSquadBlueprint("sws_halftrack_squad_sp"), mkr_spawn_Convoy3, nil, 1)
		Util_CreateSquads(player3, {sg_Convoy, sg_Convoy4}, BP_GetSquadBlueprint("sws_halftrack_squad_sp"), mkr_spawn_Convoy4, nil, 1)
		Util_CreateSquads(player3, {sg_Convoy, sg_Convoy5}, BP_GetSquadBlueprint("sws_halftrack_squad_sp"), mkr_spawn_Convoy5, nil, 1)
		AI_LockSquads(player3, sg_Convoy)
		--Util_StartIntel(EVENTS.opH_DerbyOnDrugs)
		--Rule_AddOneShot(Goodbye, 10)
-------------------------------------------------------------------------
		Timer_Start(tmr_objConvoy_clock, g_obj5_tmr)
		Rule_AddInterval(Convoy_UpdateClock, 1)
		Rule_Add(Start_Convoy_check)
		--Rule_Add(Start_Convoy_Alive_check)
		Rule_Add(Start_Convoy_Escape_check)
		Rule_AddOneShot(Convoy_Departure, g_obj5_tmr)
	end
end

--
function Convoy_UpdateClock()
	
	-- timer alternate
	g_clockCount = (g_clockCount + g_clockInterval)
	local percentage = (g_clockCount/g_obj5_tmr)
	--local currTime = math.floor(Timer_GetRemaining(tmr_objConvoy_clock))
	--local text = Loc_FormatText(Util_CreateLocString("Convoy Refuelling Progress"), Loc_FormatTime(currTime, false, false)) -- LOCDB [11076568] 'Time until allied support arrives: %1TIME%'
	
	Obj_ShowProgress2(Util_CreateLocString("Convoy Refuelling Progress"), percentage)
	
	--if Timer_GetRemaining(Timer_GetElapsed(tmr_objHoldTheLine_clock)) == 60 then
	--	Util_StartIntel(EVENTS.HoldTheLine_OneMinute)
	--end
end -- ]]

function Start_Convoy_check()
	if SGroup_CountSpawned(sg_Convoy) == 0 and g_convoyDespawnCount <= 3 then --if SGroup_IsAlive(sg_Convoy) == false then
		Rule_RemoveMe()
		Rule_Remove(Convoy_UpdateClock)
		Obj_HideProgress()
		Objective_Complete(obj_Fith)
		AI_Enable(player3, false)
-------------------------------------------------------------------------
			--end the game, as a VICTROY
		Util_StartIntel(EVENTS.opH_DerbyOnDrugs)
		Rule_AddOneShot(Goodbye, 10)
	end
end

--
function Convoy_Departure()
	if SGroup_IsAlive(sg_Convoy) == true then
		Rule_RemoveMe()
			--stop displaying the refueling progress
		Rule_Remove(Convoy_UpdateClock)
		Obj_HideProgress()
			--warn the player about the convoy
		Objective_Fail(sobj_killConvoyBeforeRefuel)
		Util_StartIntel(EVENTS.obj_Fith_Convoy_moving)
		Cmd_Move(sg_Convoy, mkr_Convoy_exit)
		if SGroup_IsAlive(sg_Convoy1) == true then
			Rule_Add(Start_Convoy_ProxCheck1)
		end
		if SGroup_IsAlive(sg_Convoy2) == true then
			Rule_Add(Start_Convoy_ProxCheck2)
		end
		if SGroup_IsAlive(sg_Convoy3) == true then
			Rule_Add(Start_Convoy_ProxCheck3)
		end
		if SGroup_IsAlive(sg_Convoy4) == true then
			Rule_Add(Start_Convoy_ProxCheck4)
		end
		if SGroup_IsAlive(sg_Convoy5) == true then
			Rule_Add(Start_Convoy_ProxCheck5)
		end
	end
end --]]

--[[
function Start_Convoy_Alive_check()
	if SGroup_CountSpawned(sg_Convoy) == 0 and g_convoyDespawnCount <= 3 then
		Util_StartIntel(EVENTS.opH_DerbyOnDrugs)
		Rule_AddOneShot(Goodbye, 10)
	end
end -- ]]

function Start_Convoy_Escape_check()
	if g_convoyDespawnCount == 3 then
		Rule_RemoveMe()
		Objective_Fail(obj_Fith)
		Rule_AddOneShot(GameOver, 7)
			--set everyone to retreat
		Player_GetAll(player1, sg_Allies_retreat1)
		Player_GetAll(player2, sg_Allies_retreat2)
		Cmd_Retreat(sg_Allies_retreat1)
		Cmd_Retreat(sg_Allies_retreat2)
	end
end

function Start_Convoy_ProxCheck1()
	if Prox_MarkerSGroup(mkr_Convoy_exit, sg_Convoy1) <= 10 then
		Rule_RemoveMe()
		SGroup_DeSpawn(sg_Convoy1)
		g_convoyDespawnCount = g_convoyDespawnCount + 1
	end
end

function Start_Convoy_ProxCheck2()
	if Prox_MarkerSGroup(mkr_Convoy_exit, sg_Convoy2) <= 10 then
		Rule_RemoveMe()
		SGroup_DeSpawn(sg_Convoy2)
		g_convoyDespawnCount = g_convoyDespawnCount + 1
	end
end

function Start_Convoy_ProxCheck3()
	if Prox_MarkerSGroup(mkr_Convoy_exit, sg_Convoy3) <= 10 then
		Rule_RemoveMe()
		SGroup_DeSpawn(sg_Convoy3)
		g_convoyDespawnCount = g_convoyDespawnCount + 1
	end
end

function Start_Convoy_ProxCheck4()
	if Prox_MarkerSGroup(mkr_Convoy_exit, sg_Convoy4) <= 10 then
		Rule_RemoveMe()
		SGroup_DeSpawn(sg_Convoy4)
		g_convoyDespawnCount = g_convoyDespawnCount + 1
	end
end

function Start_Convoy_ProxCheck5()
	if Prox_MarkerSGroup(mkr_Convoy_exit, sg_Convoy5) <= 10 then
		Rule_RemoveMe()
		SGroup_DeSpawn(sg_Convoy5)
		g_convoyDespawnCount = g_convoyDespawnCount + 1
	end
end

function Goodbye()
	Game_QuitApp()
end

function GameOver()
	--Game_FadeToBlack(FADE_OUT, 2)
	Game_EndSP(false)
end
