function INIT_ObjKillCommandPostObjective()

	print("Initializing Main Objective...")
		
	obj_KillCommandPost = {
	
		SetupUI = function() 
			CommandPost_UI = Objective_AddUIElements(obj_KillCommandPost, eg_AxisCommandPost, true, Util_CreateLocString("Destroy"), true, 3.5)
		end,
		
		OnStart = function()
			Obj_ShowProgress(Util_CreateLocString("Command Post"), 1)
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = Util_CreateLocString("Allies need to destroy the Axis command post"),
		Description = 0,
		Type = OT_Primary,
	}
		
	Objective_Register(obj_KillCommandPost)
	
end

Scar_AddInit(INIT_ObjKillCommandPostObjective)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!