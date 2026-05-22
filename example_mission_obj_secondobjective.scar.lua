-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- EXAMPLE MISSION
-- Objective File - Second Objective
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_ObjSecondObjective()
	print("Initializing INIT_ObjSecondObjective...")
	
	OBJ_SecondObjective = {
		--Info
		Title = "$251cd96e73d74746ab5eb7505409e218:3",  --"Wipe out the enemy forces."
		TitleEnd = "$251cd96e73d74746ab5eb7505409e218:4",  --"Enemy forces defeated."
		TitleFail = LOC("Objective Failed"),
		Type = OT_Primary,
		Parent = nil,
		subObjectives = {},
		
		--Intel
		Intel_Start = nil,
		Intel_Start_SkipFunc = nil,
		Intel_Complete = nil,
		Intel_Complete_SkipFunc = nil,
		Intel_Fail = nil,
		Intel_Fail_SkipFunc = nil,
		--Functions
		SetupUI = function()
		end,
		PreStart = nil,
		OnStart = function()
			local enc = ENCOUNTERS.ExampleEncounter()
			Event_EncounterIsDead(EventHandler_ObjectiveComplete, {objective = OBJ_SecondObjective}, enc, 1)
		end,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = function()
			Event_Timer(EndMission, nil, 3)
		end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
end
Scar_AddInit(INIT_ObjSecondObjective)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!

-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------
-- This is where any supplemental functions should be written.
-- If any of the objective functions are too big/complex, they should be defined here.
function EndMission()
	Game_EndSP(true)
end
