----- Convoy -----
-- ToW 1942 Challenge
-- Player Army: German
------------------

function RegisterObjectives()
	-- MAIN/PARENT objective: Destroy the Convoy
	OBJ_DestroyConvoy = {
		Title = 11051272, -- Cripple the Soviet Convoy
		-- WIN: Complete all sub-objectives by destroying target vehicles
		-- LOSE: Allow any target vehicle to escape off the map
		Type = OT_Primary,	
				
		Intel_Start = EVENTS.OBJDestroyConvoy,			
		OnStart = function()
			Rule_AddOneShot(Convoy_Begin, t_difficulty.setupTimeBeforeWave1) 
			Event_Timer(EventHandler_ObjectiveStart, {objective = OBJ_Scavenge}, 6)
			Objective_Start(SOBJ_WaitingTime, false)
			Objective_StartTimer(SOBJ_WaitingTime, COUNT_DOWN, t_difficulty.setupTimeBeforeWave1, 5)
		end,		
		
		SetupUI = function()
			if g_difficulty ~= GD_HARD then
				hintSalvage = HintPoint_Add(eg_wreckedTankHint, true, 11051578)
				Event_OnHealth(EventHandler_RemoveHint, {hint = hintSalvage}, eg_wreckedTankHint, EGroup_GetAvgHealth(eg_wreckedTankHint)-0.1, false)
			end
			
			local f = function (gid, idx, barricade)
				table.insert(t_barricadeHints, HintPoint_Add(barricade, true, 11051579))
			end
			EGroup_ForEach(eg_allBarricades, f)	
			Objective_AddUIElements(OBJ_DestroyConvoy, mkr_convoyStart, true, 11051657, true)
			Objective_AddUIElements(OBJ_DestroyConvoy, mkr_convoyDest, true, 11051658, true)
		end,
			
		Intel_Complete = EVENTS.Success,				
		OnComplete = function()
			Game_EndSP(true)
		end,
		
		Intel_Fail = nil,					
		OnFail = nil,
	}	
	Objective_Register(OBJ_DestroyConvoy)
	
	-- Alternate main objective for HARD difficulty
	-- On HARD, the player must destroy all convoy vehicles
	OBJ_DestroyConvoyHard = {
		Title = 11051279, -- Destroy all Soviet Vehicles
		-- WIN: Destroy all Soviet vehicles
		-- LOSE: Allow any Soviet vehicle to escape off the map
		Type = OT_Primary,	
				
		Intel_Start = EVENTS.OBJDestroyConvoy,			
		OnStart = function()
			Rule_AddOneShot(Convoy_Begin, t_difficulty.setupTimeBeforeWave1) 
		end,		
		
		SetupUI = function()
			Objective_AddUIElements(OBJ_DestroyConvoyHard , mkr_convoyStart, true, 11051657, true)
			Objective_AddUIElements(OBJ_DestroyConvoyHard , mkr_convoyDest, true, 11051658, true)
		end,
			
		Intel_Complete = EVENTS.Success,				
		OnComplete = function()
			Game_EndSP(true)
		end,
		
		Intel_Fail = nil,					
		OnFail = nil,
	}	
	Objective_Register(OBJ_DestroyConvoyHard)
	
	-- Wave 1, Target One: Halftrack or Truck
	SOBJ_TargetOne = {
		Parent = OBJ_DestroyConvoy,
		Title = 11051273, -- Destroy an M5 Halftrack or ZIS-6 Supply Truck
		-- WIN: Destroy either a truck or a halftrack in Wave 1
		-- LOSE: Allow both the truck and halftrack to escape
		Type = OT_Primary,	
		Intel_Start = nil,			
		OnStart = nil,		
		
		SetupUI = function()

		end,
			
		Intel_Complete = nil,					
		OnComplete = function()		
			
		end,
		
		Intel_Fail = nil,						
		OnFail = nil,
	}
	Objective_Register(SOBJ_TargetOne)
	
	-- Wave 1, Target Two: T-70 Light Tank
	SOBJ_TargetTwo = {
		Parent = OBJ_DestroyConvoy,
		Title = 11051274, -- Destroy the T-70 Light Tank
		-- WIN: Destroy the T-70 in Wave 1
		-- LOSE: Allow the T-70 to escape off the map
		Type = OT_Primary,	
		Intel_Start = nil,			
		OnStart = function()
			local reveal = function (gid, idx, eid)
				FOW_PlayerRevealArea(player1, Entity_GetPosition(eid), 3, -1)
			end
			EGroup_ForEach(eg_wrecks, reveal)
		end,		
		
		SetupUI = function()

		end,
			
		Intel_Complete = nil,				
		OnComplete = nil,
		
		Intel_Fail = nil,				
		OnFail = nil,
	}
	Objective_Register(SOBJ_TargetTwo) 
	
	-- Wave 2, Target One: T-34 Medium Tank
	SOBJ_TargetThree = {
		Parent = OBJ_DestroyConvoy,
		Title = 11051277, -- Destroy the T-34 Medium Tank
		-- WIN: Destroy the T-34 in Wave 2
		-- LOSE: Allow the T-34 to escape off the map
		Type = OT_Primary,	
		Intel_Start = nil,			
		OnStart = function()
		end,		
		SetupUI = function()
		end,
		Intel_Complete = nil,				
		OnComplete = nil,
		
		Intel_Fail = nil,				
		OnFail = nil,
	}
	Objective_Register(SOBJ_TargetThree)
	
	-- Wave 2, Target Two: Both Supply Trucks
	SOBJ_TargetFour = {
		Parent = OBJ_DestroyConvoy,
		Title = 11051275, -- Destroy both ZIS-6 Supply Trucks
		-- WIN: Destroy both supply trucks in Wave 2
		-- LOSE: Allow any supply trucks to escape off the map
		Type = OT_Primary,	
		Intel_Start = nil,			
		OnStart = function()
		end,		
		SetupUI = function()
		end,
		Intel_Complete = nil,				
		OnComplete = nil,
		
		Intel_Fail = nil,						
		OnFail = nil,
	}
	Objective_Register(SOBJ_TargetFour)
	
	-- Wave 3, Target One: Both KV Heavy Tanks
	SOBJ_TargetFive = {
		Parent = OBJ_DestroyConvoy,
		Title = 11051278, -- Destroy the KV-1 and KV-8 Heavy Tanks
		-- WIN: Destroy both KV tanks in Wave 3
		-- LOSE: Allow either KV tank to escape off the map
		Type = OT_Primary,	
		Intel_Start = nil,			
		OnStart = function()
		end,		
		SetupUI = function()
		end,
		Intel_Complete = nil,			
		OnComplete = nil,
		
		Intel_Fail = nil,						
		OnFail = nil,
	}
	Objective_Register(SOBJ_TargetFive)
	
	-- Wave 3, Target Two: Supply Truck
	SOBJ_TargetSix = {
		Parent = OBJ_DestroyConvoy,
		Title = 11051276, -- Destroy the ZIS-6 Supply Truck
		-- WIN: Destroy the supply truck in Wave 3
		-- LOSE: Allow the supply truck to escape off the map
		Type = OT_Primary,	
		Intel_Start = nil,			
		OnStart = function()
		end,		
		SetupUI = function()
		end,
		Intel_Complete = nil,				
		OnComplete = nil,
		
		Intel_Fail = nil,					
		OnFail = nil,
	}
	Objective_Register(SOBJ_TargetSix)
	
	SOBJ_WaitingTime = {
		Parent = OBJ_DestroyConvoy,
		Title = 11051852, -- Time to prepare -- Waiting time between convoy waves
		Type = OT_Primary,	
		Intel_Start = nil,			
		OnStart = function()
		end,		
		SetupUI = function()
		end,
		Intel_Complete = nil,				
		OnComplete = nil,
		
		Intel_Fail = nil,					
		OnFail = nil,
	}
	Objective_Register(SOBJ_WaitingTime)
	
	OBJ_Scavenge = {
		Title = 11051580, -- Scavenge munitions from wrecked vehicles
		-- No win or lose conditions
		Type = OT_Secondary,	
		Intel_Start = nil,			
		OnStart = function()
			Rule_AddInterval(OBJ_Scavenge_Complete_Check, 2)
		end,		
		SetupUI = function()
			local f = function (gid, idx, wreck)
				Objective_AddUIElements(OBJ_Scavenge, wreck, true, 11051580, false)
			end
			EGroup_ForEach(eg_wrecks, f)
			Objective_AddUIElements(OBJ_Scavenge, eg_wreckedTankHint, true, 11051580, false)
		end,
		Intel_Complete = nil,			
		OnComplete = nil,
		
		Intel_Fail = nil,				
		OnFail = nil,
	}
	Objective_Register(OBJ_Scavenge)
end

Scar_AddInit(RegisterObjectives)


--- WIN/LOSE functions

function OBJ_DestroyConvoy_EndMission()
	Objective_Complete(g_mainObjective)
end

function OBJ_DestroyConvoy_ConvoyEscaped()
	Util_StartIntel(EVENTS.Fail)
	Util_MissionTitle(11051576, 1, 4, 1)
	Event_Timer(OBJ_DestroyConvoy_Failed, nil, 10)
end

function OBJ_DestroyConvoy_PlayerDead()
	Util_MissionTitle(11051577, 1, 4, 1)
	Event_Timer(OBJ_DestroyConvoy_Failed, nil, 6)
end

function OBJ_DestroyConvoy_Failed()
	Game_EndSP(false)
end

function OBJ_Scavenge_Complete_Check()
	if EGroup_Count(eg_wrecks) == 0 then
		Objective_Complete(OBJ_Scavenge)
	end
end
