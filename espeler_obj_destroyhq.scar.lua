print("\tLoading ObjTankEscort file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Espeler
-- Objective File - Destroy the enemy HQs
-- Designer: Byron Chow
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------

function INIT_OBJ_DestroyBases()
	print("Initializing ObjDestroyHqs...")
	
	
	-- Pre-condition:		Mission start.
	-- Success condition:	Minimum number of hqs are destroyed and there are no more left.
	-- Failure condition:	Too many hqs escape.
	-- Post-condition:
	--		Success:		Mission complete.
	--		Failure:		Mission fail.
	OBJ_DestroyBases = {
		--Info
		Title = 11074846,      -- LOCDB [11074846] 'Destroy Enemy Command'
		TitleEnd = 11074847,   -- LOCDB [11074847] 'Enemy HQ halftracks destroyed'
		TitleFail = 11074848,  -- LOCDB [11074848] 'HQ halftracks escaped'
		Type = OT_Primary,              -- Objective Type (OT_Primary, OT_Secondary)
		Parent = nil,                   -- Used for sub-objectives to specify its parent. Remove for top-level objectives.
		subObjectives = {SOBJ_DestroyHqs},

		--Intel
		Intel_Start =               EVENTS.OBJ_DestroyBases,        -- EVENT called *before* the objective actually starts
		Intel_Start_SkipFunc =      nil,        -- Function to play if Intel_Start is Skipped
		Intel_Complete =  			nil,        -- This EVENT is called _before_ the objective actually completes
		Intel_Complete_SkipFunc =   nil,        -- Function to play if Intel_Complete is Skipped
		Intel_Fail =                EVENTS.MissionFailure,        -- This EVENT is called _before_ the objective actually fails
		Intel_Fail_SkipFunc =       nil,        -- Function to play if Intel_Fail is Skipped
		--Functions
		SetupUI = function()                        -- This is called alongside the new objective ui animation, but this may occur sometime _after_ the OnStart depending on any running Events
			-- ObjectiveUIElements are removed when Objective_Complete or Objective_Fail are completed
			g_alert_bar = Obj_ShowProgress2(11074845, g_alert_percent) -- LOCDB [11074845] 'Enemy Alert Level'
		end,
		PreStart = function() end,                  -- Called on start, before Intel_Start
		OnStart = function() 
				Objective_Start(SOBJ_DestroyHqs, false)
				Objective_Start(OBJ_DestroyHalftracks, true)
			end,                   -- Called after any Intel_Start items, and the objective is considered officially started here
		IsComplete = function() 
			if g_total_hqs_escaped <= 1 and SGroup_Count(sg_enemy_hq_all) == 0 then
				return true
			else
				return false 
			end
		end,   -- Automatic check called to see if the objective is complete. Must return boolean value.
		PreComplete = function() 
			print("precomplete ran")
			if g_total_hqs_escaped > 0 then
				Util_StartIntel(EVENTS.MissionCompletePartial)
			else
				Util_StartIntel(EVENTS.MissionCompleteFull)
			end
		end,               -- Called before Intel_Complete
		OnComplete = function() 
			CalculateMissionScore()
			Rule_AddInterval(Mission_Complete, 1) 
		end,               -- Called after any Intel_Complete items, and the objective is considered officially completed here. The objective ui animation happens at this time as well.
		IsFailed = function() 
			-- if too many hq's escape or player base is destroyed
			if g_total_hqs_escaped >= 2 or EGroup_IsEmpty(eg_XP1_player_base) then
				return true
			else
				return false 
			end
		end,     -- Automatic check called to see if the objective has failed. Must return boolean value.
		PreFail = function() end,                   -- Called before Intel_Fail
		OnFail = function() Rule_AddInterval(Mission_Fail, 1) end,                  -- Called after any Intel_Fail items, and the objective is considered officially failed here. The objective ui animation happens at this time as well.
	}
	
	
	-- Pre-condition:		Mission start.
	-- Success condition:	None.
	-- Failure condition:	None.
	-- Post-condition:
	--		Success:		None.
	--		Failure:		None.
	-- Just used to clarify objective
	SOBJ_DestroyHqs = {
		--Info
		Title = 11074849, -- LOCDB [11074849] 'Destroy Enemy HQs'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,              -- Objective Type (OT_Primary, OT_Secondary)
		Parent = OBJ_DestroyBases,                   -- Used for sub-objectives to specify its parent. Remove for top-level objectives.
		subObjectives = {SOBJ_ScoutAhead},

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
			g_hq_arrow_id1 = Objective_AddUIElements(SOBJ_DestroyHqs, sg_enemy_hq1, true, 11074853, true, 3.0) -- LOCDB [11074853] 'Destroy HQ'
			g_hq_arrow_id2 = Objective_AddUIElements(SOBJ_DestroyHqs, sg_enemy_hq2, true, 11074853, true, 3.0) -- LOCDB [11074853] 'Destroy HQ'
			g_hq_arrow_id3 = Objective_AddUIElements(SOBJ_DestroyHqs, sg_enemy_hq3, true, 11074853, true, 3.0) -- LOCDB [11074853] 'Destroy HQ'
		end,
		PreStart = function() end,                  -- Called on start, before Intel_Start
		OnStart = function() 
		end,                   -- Called after any Intel_Start items, and the objective is considered officially started here
		IsComplete = function() return false end,   -- Automatic check called to see if the objective is complete. Must return boolean value.
		PreComplete = function() end,               -- Called before Intel_Complete
		OnComplete = function() end,               -- Called after any Intel_Complete items, and the objective is considered officially completed here. The objective ui animation happens at this time as well.
		IsFailed = function() return false end,     -- Automatic check called to see if the objective has failed. Must return boolean value.
		PreFail = function() end,                   -- Called before Intel_Fail
		OnFail = function() end,                  -- Called after any Intel_Fail items, and the objective is considered officially failed here. The objective ui animation happens at this time as well.
	}
	
	table.insert(OBJ_DestroyBases.subObjectives, SOBJ_DestroyHqs) -- Don't forget to add them to their parent!
	
	
	-- Pre-condition:		Mission start.
	-- Success condition:	All IR halftracks destroyed.
	-- Failure condition:	None.
	-- Post-condition:
	--		Success:		None.
	--		Failure:		None.
	OBJ_DestroyHalftracks = {
		--Info
		Title = 11074851, -- LOCDB [11074851] 'Destroy IR Halftracks'
		TitleEnd = 11074852, -- LOCDB [11074852] 'All IR Halftracks Destroyed'
		TitleFail = nil,
		Type = OT_Secondary,              -- Objective Type (OT_Primary, OT_Secondary)
		Parent = nil,                   -- Used for sub-objectives to specify its parent. Remove for top-level objectives.
		subObjectives = {},

		--Intel
		Intel_Start =      EVENTS.OBJ_DestroyHalftracks,        -- EVENT called *before* the objective actually starts
		Intel_Start_SkipFunc =      nil,        -- Function to play if Intel_Start is Skipped
		Intel_Complete =            nil,        -- This EVENT is called _before_ the objective actually completes
		Intel_Complete_SkipFunc =   nil,        -- Function to play if Intel_Complete is Skipped
		Intel_Fail =                nil,        -- This EVENT is called _before_ the objective actually fails
		Intel_Fail_SkipFunc =       nil,        -- Function to play if Intel_Fail is Skipped
		--Functions
		SetupUI = function()                        -- This is called alongside the new objective ui animation, but this may occur sometime _after_ the OnStart depending on any running Events
			-- ObjectiveUIElements are removed when Objective_Complete or Objective_Fail are completed
		end,
		PreStart = function() end,                  -- Called on start, before Intel_Start
		OnStart = function() end,                   -- Called after any Intel_Start items, and the objective is considered officially started here
		IsComplete = function() 
			if SGroup_Count(sg_halftracks_all) > 0 then
				return false 
			else
				return true
			end
		end,   -- Automatic check called to see if the objective is complete. Must return boolean value.
		PreComplete = function() end,               -- Called before Intel_Complete
		OnComplete = function() end,                -- Called after any Intel_Complete items, and the objective is considered officially completed here. The objective ui animation happens at this time as well.
		IsFailed = function() return false end,     -- Automatic check called to see if the objective has failed. Must return boolean value.
		PreFail = function() end,                   -- Called before Intel_Fail
		OnFail = function() end,                    -- Called after any Intel_Fail items, and the objective is considered officially failed here. The objective ui animation happens at this time as well.
	}
	
	table.insert(OBJ_DestroyBases.subObjectives, OBJ_DestroyHalftracks) -- Don't forget to add them to their parent!
		
end

Scar_AddInit(INIT_OBJ_DestroyBases)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!
