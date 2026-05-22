print("\tLoading ObjTankEscort file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Convoy Ambush
-- Objective File - Protect the Tank
-- Designer: Byron Chow
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------

function INIT_ObjReunite()
	print("Initializing Obj_ProtectTank...")
	
	OBJ_MainObjective = {
		--Info
		Title = 11076619, 		-- LOCDB [11076619] 'Protect the Tank'
		Type = OT_Primary,              -- Objective Type (OT_Primary, OT_Secondary)
		Parent = nil,                   -- Used for sub-objectives to specify its parent. Remove for top-level objectives.
		subObjectives = {SOBJ_ScoutAhead},

		--Intel
		Intel_Start =               EVENTS.OBJ_MainObjective,        -- EVENT called *before* the objective actually starts
		Intel_Start_SkipFunc =      nil,        -- Function to play if Intel_Start is Skipped
		Intel_Complete =            EVENTS.MissionSuccess,        -- This EVENT is called _before_ the objective actually completes
		Intel_Complete_SkipFunc =   nil,        -- Function to play if Intel_Complete is Skipped
		Intel_Fail =                EVENTS.MissionFailure,        -- This EVENT is called _before_ the objective actually fails
		Intel_Fail_SkipFunc =       nil,        -- Function to play if Intel_Fail is Skipped
		--Functions
		SetupUI = function()                        -- This is called alongside the new objective ui animation, but this may occur sometime _after_ the OnStart depending on any running Events
			-- ObjectiveUIElements are removed when Objective_Complete or Objective_Fail are completed
			Objective_AddUIElements(OBJ_MainObjective, sg_tank, false, 11076619, false)
		end,
		PreStart = function() end,                  -- Called on start, before Intel_Start
		OnStart = function() 
				Objective_Start(SOBJ_ScoutAhead, false)
			end,                   -- Called after any Intel_Start items, and the objective is considered officially started here
		IsComplete = nil,   		-- Automatic check called to see if the objective is complete. Must return boolean value.
		PreComplete = nil,               -- Called before Intel_Complete
		OnComplete = function() Event_NarrativeEventsNotRunning(Mission_Complete, nil, 1) end,               -- Called after any Intel_Complete items, and the objective is considered officially completed here. The objective ui animation happens at this time as well.
		IsFailed = nil,     -- Automatic check called to see if the objective has failed. Must return boolean value.
		PreFail = nil,                   -- Called before Intel_Fail
		OnFail = function() Event_NarrativeEventsNotRunning(Mission_Fail, nil, 1) end,                  -- Called after any Intel_Fail items, and the objective is considered officially failed here. The objective ui animation happens at this time as well.
	}
	
	SOBJ_ScoutAhead = {
		--Info
		Title = 11076620,      	-- LOCDB [11076620] 'Scout ahead of the tank for enemy positions'
		Type = OT_Primary,              -- Objective Type (OT_Primary, OT_Secondary)
		Parent = OBJ_MainObjective,                   -- Used for sub-objectives to specify its parent. Remove for top-level objectives.
		subObjectives = {},

		--Intel
		Intel_Start =               nil,        -- EVENT called *before* the objective actually starts
		Intel_Start_SkipFunc =      nil,        -- Function to play if Intel_Start is Skipped
		Intel_Complete =            nil,        -- This EVENT is called _before_ the objective actually completes
		Intel_Complete_SkipFunc =   nil,        -- Function to play if Intel_Complete is Skipped
		Intel_Fail =                nil,        -- This EVENT is called _before_ the objective actually fails
		Intel_Fail_SkipFunc =       nil,        -- Function to play if Intel_Fail is Skipped
		--Functions
		SetupUI = function()                        -- This is called alongside the new objective ui animation, but this may occur sometime _after_ the OnStart depending on any running Events
			-- ObjectiveUIElements are removed when Objective_Complete or Objective_Fail are completed
		end,
		PreStart = nil,                  -- Called on start, before Intel_Start
		OnStart = nil,                   -- Called after any Intel_Start items, and the objective is considered officially started here
		IsComplete = nil,   -- Automatic check called to see if the objective is complete. Must return boolean value.
		PreComplete = nil,               -- Called before Intel_Complete
		OnComplete = nil,                -- Called after any Intel_Complete items, and the objective is considered officially completed here. The objective ui animation happens at this time as well.
		IsFailed = nil,     -- Automatic check called to see if the objective has failed. Must return boolean value.
		PreFail = nil,                   -- Called before Intel_Fail
		OnFail = nil,                    -- Called after any Intel_Fail items, and the objective is considered officially failed here. The objective ui animation happens at this time as well.
	}
	
	table.insert(OBJ_MainObjective.subObjectives, SOBJ_ScoutAhead) -- Don't forget to add them to their parent!
	
end

Scar_AddInit(INIT_ObjReunite)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!
