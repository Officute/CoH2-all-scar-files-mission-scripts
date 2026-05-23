function INIT_ObjMainObjective_allies()

	print("Initializing Main Objective...")
	
	g_sobjTimer = 300
	g_Axis_capTimer = 45
	g_Axis_cap_TimeRemaining = 45
	
	tmr_reinforcements = "tmr_reinforcements"
	tmr_Axis_cap = "tmr_Axis_cap"
	
	obj_MainObjective_allies = {
	
		SetupUI = function() 
			--Objective_StartTimer(obj_MainObjective_allies, COUNT_DOWN, g_sobjTimer, 10)
			UI_obj_MainObjective_allies1 = Objective_AddUIElements(obj_MainObjective_allies, eg_allied_capturePoint2, true, Util_CreateLocString("Critical point"), true)
			UI_obj_MainObjective_allies2 = Objective_AddUIElements(obj_MainObjective_allies, eg_allied_capturePoint3, true, Util_CreateLocString("Critical point"), true)
		end,
		
		OnStart = function()
			Rule_AddDelayedInterval(Axis_CheckPointCaptured, 1, 1)
			Objective_Start(SOBJ_ArmourSupportTimer)
			--Timer_Start(tmr_reinforcements, g_sobjTimer)
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = Util_CreateLocString("Allies have to defend"),
		Description = 0,
		Type = OT_Primary,
	}
	
	SOBJ_ArmourSupportTimer = {
		Parent = obj_MainObjective_allies,
		SetupUI = function()
			Objective_StartTimer(SOBJ_ArmourSupportTimer, COUNT_DOWN, g_sobjTimer)
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = Util_CreateLocString("Allied armour arrives in: "),
		Description = 0,
		Type = OT_Secondary,
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
	Objective_Register(SOBJ_ArmourSupportTimer)
	Objective_Register(SOBJ_ArmourSupportObjective, player1)
	Objective_Register(SOBJ_ArmourSupportObjective, player3)
	Objective_Register(SOBJ_ArmourSupportObjective_axis, player2)
	Objective_Register(SOBJ_ArmourSupportObjective_axis, player4)
	
end

Scar_AddInit(INIT_ObjMainObjective_allies)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!

--[[function Start_SOBJ_ArmourSupportObjective()
	if (Objective_GetTimerSeconds(obj_MainObjective_allies) <= 0) then				
		Rule_RemoveMe();
		World_IncreaseInteractionStage();
		Timer_End(tmr_reinforcements)
		Objective_StopTimer(obj_MainObjective_allies)
		if EGroup_GetAvgHealth(eg_allied_bridge) >= 0.01 then
			Objective_Start(SOBJ_ArmourSupportObjective);
			Objective_Start(SOBJ_ArmourSupportObjective_axis);
			Rule_Add(Start_bridgeCheck);
			Rule_Add(Start_capturePointCheck);
		else
			Util_MissionTitle(Util_CreateLocString("Allied reinforcements have arrived but can't move into the area"))
				--delayed start of the next objective
			Rule_AddOneShot(Start_obj_KillCommandPost, 120)
		end		
	end
end
	
function Start_capturePointCheck()
	if Util_GetPlayerOwner(eg_cptPoint_allied_Armour) == player1 or Util_GetPlayerOwner(eg_cptPoint_allied_Armour) == player3 then
		Rule_RemoveMe();
			--complete the objective
		Objective_Complete(SOBJ_ArmourSupportObjective);
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
		Obj_HideProgress()
	end
end]]
