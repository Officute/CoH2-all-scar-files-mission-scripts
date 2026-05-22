-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- EXAMPLE MISSION
-- Objective File - First Objective
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Objectives are typically broken into separate files that contain the objective data and related logic.
-- 
-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_ObjFirstObjective()
	print("Initializing ObjExample...")
	
	OBJ_FirstObjective = {
		--Info
		Title = "$251cd96e73d74746ab5eb7505409e218:1",  --The objective's text
		TitleEnd = "$251cd96e73d74746ab5eb7505409e218:2", -- The the message displayed on completion
		TitleFail = nil, -- The message displayed on failure
		Type = OT_Primary, -- This defines the type of objective (and by extension how it is displayed to the player)
		Parent = nil, -- If this objective has a parent, the parent objective is put here
		subObjectives = {}, --Any subobjectives to a parent objective
		
		--Intel
		Intel_Start = EVENTS.FirstObjectiveStart, -- An event (ie: speech/nislet) that kicks off when the encounter is started
		Intel_Start_SkipFunc = nil, -- A function to complete any setup that may be missed when the start event is skipped (ie: moving the camera to the nislet's end position)
		Intel_Complete = EVENTS.FirstObjectiveComplete, -- An event (ie: speech/nislet) that kicks off when the encounter is completed
		Intel_Complete_SkipFunc = nil, -- A function to complete any setup that may be missed when the end event is skipped (ie: moving the camera to the nislet's end position)
		Intel_Fail = 				nil, -- An event (ie: speech/nislet) that kicks off when the encounter is failed
		Intel_Fail_SkipFunc = 		nil,  -- A function to complete any setup that may be missed when the fail event is skipped (ie: moving the camera to the nislet's end position)
		--Functions
		SetupUI = function() --A function to setup any UI elements for the objective
		end,
		PreStart = nil, --A function called to setup anything required for the objective, before the objective is kicked off
		OnStart = function() --A function called when the objective is started
			Event_PlayerOwnsTerritory(EventHandler_ObjectiveComplete, {objective = OBJ_FirstObjective}, player1, eg_objTerritoryPoint, 1) -- The event system can be used in conjunction with handlers. Handlers give preset functionality (in this case completing the given objective)
		end,
		IsComplete = nil, -- A function that returns a boolean describing when the objective is complete
		PreComplete = nil, --A function called immediately prior to completing an objective
		OnComplete = function()  --A function called when the objective is complete
			EGroup_SetPlayerOwner(eg_playerBase, player1)
			World_IncreaseInteractionStage() 
			Objective_Start(OBJ_SecondObjective)	
		end,
		IsFailed = nil, -- A function that returns a boolean describing when the objective is failed
		PreFail = nil, --A function called immediately prior to failing an objective 
		OnFail = nil, --A function called when the objective is failed
	}	
end
Scar_AddInit(INIT_ObjFirstObjective)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!

-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------
-- This is where any supplemental functions should be written.
-- If any of the objective functions are too big/complex, they should be defined here.

