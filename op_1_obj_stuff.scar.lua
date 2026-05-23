function INIT_Obj...()

	print("Initializing Second Objective...")
	obj_... = {
		--Info
		Title = (Title),  --The objective's text
		TitleEnd = (TitleEnd), -- The the message displayed on completion
		TitleFail = nil, -- The message displayed on failure
		Type = OT_Primary, -- This defines the type of objective (and by extension how it is displayed to the player)
		Parent = nil, -- If this objective has a parent, the parent objective is put here
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
	
	Objective_Register(obj_...)
	
end

Scar_AddInit(INIT_Obj...)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!
