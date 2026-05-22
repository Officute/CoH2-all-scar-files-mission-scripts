-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- 1943 Challenge: MUD HUNT - FIND AND DESTROY OBJECTIVE
-- Designer: NJR
-------------------------------------------------------------------------
-------------------------------------------------------------------------


-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_Obj_FindAndDestroy()
	
	-- Pre-condition:		Starts when the player sees their first abandoned tank
	-- Success condition:	Player has captured all abandoned tanks and got them to the rendezvous point
	-- Failure condition:	N/A
	-- Post-condition:
	--		Success:		N/A
	--		Failure:		N/A
	
	OBJ_FindAndDestroy = {
		
		--Info
		Title = 11055671,				-- Objective Title				--LOC("Find and destroy the enemy tanks")
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		subObjectives = {},
		
		--Intel
		Intel_Start = 				nil,		-- EVENT called *before* the objective actually starts
		Intel_Start_SkipFunc = 		nil,		-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			nil,		-- This EVENT is called _before_ the objective actually completes
		Intel_Complete_SkipFunc = 	nil,		-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				nil,		-- This EVENT is called _before_ the objective actually fails
		Intel_Fail_SkipFunc = 		nil,		-- Function to play if Intel_Fail is Skipped
		--Functions
		SetupUI = function() 						-- This is called alongside the new objective ui animation, but this may occur sometime _after_ the OnStart depending on any running Events
			
			Objective_SetCounter(OBJ_FindAndDestroy, num_destroyed_tanks, t_difficulty.target_number_tanks)
			
		end,
		Precondition = function() end,
		PreStart = function() end,					-- Called on start, before Intel_Start
		OnStart = function()						-- Called after any Intel_Start items, and the objective is considered officially started here
			
		end,
		IsComplete = function() 
			
			Objective_SetCounter(OBJ_FindAndDestroy, num_destroyed_tanks, t_difficulty.target_number_tanks)
			
			-- if we hit the number of tanks destroyed, we're good
			if num_destroyed_tanks >= t_difficulty.target_number_tanks then
				return true
			end
			
		end,
		PreComplete = function() end,				-- Called before Intel_Complete
		OnComplete = function()						-- Called after any Intel_Complete items, and the objective is considered officially completed here. The objective ui animation happens at this time as well.
			
		end,
		IsFailed = function() 
			
			-- if the number of potential tanks drops below the number required, it's all over
			if (num_total_tanks - num_escaped_tanks) < t_difficulty.target_number_tanks then
				return true
			end
			
		end,
		PreFail = function() end,					-- Called before Intel_Fail
		OnFail = function()	end,					-- Called after any Intel_Fail items, and the objective is considered officially failed here. The objective ui animation happens at this time as well.
	}

	OBJ_TanksEscaping = {
		
		--Info
		Title = 11055672,				-- Objective Title					-- LOC("1 tank has escaped")
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		Parent = OBJ_FindAndDestroy,
		
		--Intel
		Intel_Start = 				nil,		-- EVENT called *before* the objective actually starts
		Intel_Start_SkipFunc = 		nil,		-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			nil,		-- This EVENT is called _before_ the objective actually completes
		Intel_Complete_SkipFunc = 	nil,		-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				nil,		-- This EVENT is called _before_ the objective actually fails
		Intel_Fail_SkipFunc = 		nil,		-- Function to play if Intel_Fail is Skipped
		--Functions
		SetupUI = function() 						-- This is called alongside the new objective ui animation, but this may occur sometime _after_ the OnStart depending on any running Events
			
		end,
		Precondition = function() end,
		PreStart = function() end,					-- Called on start, before Intel_Start
		OnStart = function()						-- Called after any Intel_Start items, and the objective is considered officially started here
			
		end,
		IsComplete = function() end,
		PreComplete = function() end,				-- Called before Intel_Complete
		OnComplete = function()						-- Called after any Intel_Complete items, and the objective is considered officially completed here. The objective ui animation happens at this time as well.
			
		end,
		IsFailed = function() 
			
		end,
		PreFail = function() end,					-- Called before Intel_Fail
		OnFail = function()	end,					-- Called after any Intel_Fail items, and the objective is considered officially failed here. The objective ui animation happens at this time as well.
	}

	--------------------
	-- INITIALISATION --
	--------------------
	
	num_escaped_tanks = 0
	num_destroyed_tanks = 0
	num_total_tanks = 0
	
	
	-------------
	-- KICKOFF --
	-------------
	
	-- kicked off by the main script, which has called the AbandonedTank_SetUp function below for all the instances of abandoned tanks on the map
	
end
Scar_AddInit(INIT_Obj_FindAndDestroy)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!





-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------

-- this is called when a tank has been destroyed
function FindAndDestroy_TankHasBeenDestroyed()
	
	-- increase the count
	num_destroyed_tanks = num_destroyed_tanks + 1
	
	-- play speech if necessary
	if num_destroyed_tanks == (t_difficulty.target_number_tanks - 1) then
		Util_StartIntel(EVENTS.FindAndDestroy_OneMoreToDestroy)
	end
	
end

-- this is called when a tank has escaped
function FindAndDestroy_TankHasEscaped()
	
	-- increase the count
	num_escaped_tanks = num_escaped_tanks + 1
	
	-- show (or update) the subobjective text
	if Objective_IsStarted(OBJ_TanksEscaping) == false then
		Objective_Start(OBJ_TanksEscaping)
	else
		if (num_total_tanks - num_escaped_tanks) == t_difficulty.target_number_tanks then
			Objective_UpdateText(OBJ_TanksEscaping, Loc_FormatText(11056035, Loc_ConvertNumber(num_escaped_tanks)), 0)			-- LOC("%1NUMBER% tanks have escaped - do not allow any more")
		else
			Objective_UpdateText(OBJ_TanksEscaping, Loc_FormatText(11055673, Loc_ConvertNumber(num_escaped_tanks)), 0)			-- LOC("%1NUMBER% tanks have escaped")
		end
	end
	
	-- play speech if necessary
	if (num_total_tanks - num_escaped_tanks) == t_difficulty.target_number_tanks + 1 then
		Util_StartIntel(EVENTS.FindAndDestroy_TooManyEscaping)
	end
	
end

