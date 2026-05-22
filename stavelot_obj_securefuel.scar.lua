-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- MISSION NAME
-- Objective File - Secure the Fuel points
-- Designer: A.Molina
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_ObjSecureFuel()
	print("Initializing OBJ_SecureFuel...")
	
	
	--Objective specific variables
	g_finalWarning = false				-- True if one more truck escape will fail the mission.
	g_trucksDestroyed = 0				-- Number of trucks that the player has destroyed
	g_initTruckDelay = 10				-- Delay in seconds since the start for trucks to start spawning (Default 2)
	g_stopTruckSpawn = false 			-- when objective is complete, stop the trucks from spawning!
	g_fuelPointCaptured = false
	g_stopTruckPause = false			-- flag to make sure truck doesn't respawn when the fuel point is capped
	
	tmr_capFuel = "tmr_capFuel"
	
	-- Tuning values for fuel loss
	currentFuelLoss = 1.0
	maxFuelLoss = 0.0	
	lossRate = 1.0
	truckLossAmount = 0.10 --0.10 default
	warningFuelLoss = maxFuelLoss + truckLossAmount	
	
	-- Pre-condition:		Mission start.
	-- Success condition:	Player captures all fuel points.
	-- Failure condition:	Timer runs out.
	-- Post-condition:
	--		Success:		Mission Complete.
	--		Failure:		Mission Failure.
	OBJ_SecureFuel = {
		--Info
		Title = 11076622, 		-- LOCDB [11076622] 'Deny the Germans access to fuel'
		Type = OT_Primary,
		Parent = nil,
		subObjectives = {},
		--Intel
		Intel_Start = 				EVENTS.MissionIntro,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			EVENTS.CaptureComplete,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				EVENTS.CaptureFail,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = nil,
		PreStart = nil,
		OnStart = function()
				Objective_Start(SOBJ_CapFuelPoints, false)
				Rule_AddOneShot(SendFuelTruck_Delay, g_initTruckDelay) -- SendFuelTruck()
				Rule_AddDelayedInterval(CheckFuelPointCaptured, 1, 1)
				--Rule_AddDelayedInterval(SendFuelTruck, 2, t_difficulty.evacTruckInterval)
			end,
		IsComplete = function() 				
				--return Util_GetPlayerOwner(eg_fuelLocation) == player1
				return g_fuelPointCaptured
			end,
		PreComplete = function() 
				if(scartype(g_enc_reinforceFuel) == ST_TABLE) then
					g_enc_reinforceFuel:ClearGoal()
					
					if SGroup_IsEmpty(g_enc_reinforceFuel:GetSgroup()) == false and SGroup_IsAlive(g_enc_reinforceFuel:GetSgroup()) == false then
					
						local retreatPos = World_GetClosest(g_enc_reinforceFuel:GetSgroup(), {mkr_retreat3, mkr_roadNorth, mkr_roadSouth})
						Cmd_StaggeredRetreat(g_enc_reinforceFuel:GetSgroup(), {retreatPos}, nil, true)
					end
				end
			end,
		OnComplete = function()
				g_stopTruckSpawn = true
				Obj_HideProgress()
				if(g_enc_reinforceFuel ~= nil and g_enc_reinforceFuel:IsAlive()) then
					g_enc_reinforceFuel:ClearGoal()
					g_enc_reinforceFuel:RemoveOnDeath(true)
					Cmd_Retreat(g_enc_reinforceFuel:GetSgroup(), g_enc_reinforceFuel.data.spawn, g_enc_reinforceFuel.data.spawn, false, true, true)
				end
				Event_RemoveAll()
				
				--Set the success level
				if(currentFuelLoss >= 0.7) then
					XP1_SetMissionSuccessLevel(XPT_MSL_GOLD)
				elseif(currentFuelLoss >= 0.4) then
					XP1_SetMissionSuccessLevel(XPT_MSL_SILVER)
				else
					XP1_SetMissionSuccessLevel(XPT_MSL_BRONZE)
				end
				
				Rule_AddInterval(Mission_Complete, 0.5)
				Obj_HideProgress()
			end,
		IsFailed = function() 
				
				return currentFuelLoss <= maxFuelLoss
			end,
		PreFail = nil,
		OnFail = function() 
				g_stopTruckSpawn = true
				Event_RemoveAll()
				Rule_AddDelayedInterval(Mission_Fail, 1.5, 0.5)
				Obj_HideProgress()
			end,
	}
	
	
	
	--[[------ SUB-OBJECTIVES -------]]
	
	
	-- Pre-condition:		Parent start.
	-- Success condition:	Fuel point is captured.
	-- Failure condition:	N/A.
	-- Post-condition:
	--		Success:		None.
	--		Failure:		None.
	SOBJ_CapFuelPoints = {
		Title = 11076623, 		-- LOCDB [11076623] 'Capture the Fuel Depot'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,						
		Parent = OBJ_SecureFuel,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function()
				fuelUIID = Objective_AddUIElements(SOBJ_CapFuelPoints, eg_fuelLocation, true, 11076623, true, 3.5) 		--[11076623] 'Capture the Fuel Depot'
			end,
		PreStart = nil,
		OnStart = function() Obj_ShowProgress2(Loc_FormatText(11076624, Loc_ConvertNumber(100)), 1.0) end, 		-- LOCDB [11076624] 'Remaining Fuel Reserves: %1PERCENT%%%'
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_SecureFuel.subObjectives, SOBJ_CapFuelPoints)
	
	
	
	
	-- Pre-condition:		First truck begins evac (EvacTruck)
	-- Success condition:	N/A.
	-- Failure condition:	N/A.
	-- Post-condition:
	--		Success:		N/A.
	--		Failure:		N/A.
	SOBJ_DestroyTrucks = {
		Title = 11076625, 		-- LOCDB [11076625] 'Destroy supply trucks to prevent fuel loss'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,						
		Parent = OBJ_SecureFuel,				
		
		Intel_Start = 				EVENTS.InformExitBlock,	
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = nil,
		PreStart = nil,
		OnStart = nil,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_SecureFuel.subObjectives, SOBJ_DestroyTrucks)
end
Scar_AddInit(INIT_ObjSecureFuel)




-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------

--Makes the loss 'timer' run down faster
function SecureFuel_SetLossRate(val)
	lossRate = math.max(lossRate, val)
end


function SendFuelTruck_Delay()
	-- sends initial fuel truck
	SendFuelTruck()
	
	-- send next fuel truck by setting interval
	Rule_AddDelayedInterval(SendFuelTruck, 5, t_difficulty.evacTruckInterval)
	
	-- send defenders by a slight offset so they get spawned first
	Rule_AddDelayedInterval(SendDefenders, 1, (t_difficulty.evacTruckInterval))
	
	Rule_AddInterval(FuelTruckSentDetect, 1) -- needed to clear up fuel truck sent status (g_fueltruckSent) if the fuel truck gets destroyed before it's "sent" out for the purposes of spawning the defenders
end

function SendDefenders()
	print(g_externalTruckDefenders == nil or (g_externalTruckDefenders ~= nil and (g_externalTruckDefenders:IsAlive() == false)) and g_fueltruckSent == false)
	if g_externalTruckDefenders == nil or (g_externalTruckDefenders ~= nil and (g_externalTruckDefenders:IsAlive() == false)) and g_fueltruckSent == false then
	
		-- Spawn fuel truck defenders
		local _enc_truckDefenders = nil
		
		-- remove speed modifier
		if defUnitSpeed ~= nil then
			Modifier_Remove(defUnitSpeed)					
			defUnitSpeed = nil
		end
		
		g_externalTruckDefenders = nil
		
		if g_trucksDestroyed >= 2 then
			print("Spawning truck defenders...")
			_enc_truckDefenders = ENCOUNTERS.TruckDefenders(g_truckSpawn, truck, g_trucksDestroyed)
			g_externalTruckDefenders = _enc_truckDefenders
			
			--Rule_AddDelayedInterval(DispatchDefendersDelay, 4,1)
			--Event_Timer(DispatchDefenders, {enc = _enc_truckDefenders, target = truck}, 4)
		end
	end
end


--Send a fuel truck to the depot
function SendFuelTruck()
	--local truckGroup = SGroup_Create("")
	--Util_CreateSquads(player2, truckGroup, SBP.GERMAN.OPEL_BLITZ_SQUAD, g_truckSpawn, g_truckDest)
	--Event_Proximity(EvacTruck, {group = truckGroup}, truckGroup, g_truckDest, 8, ANY, t_difficulty.truckLoadDelay)
	if g_stopTruckPause == false then
		if g_stopTruckSpawn == false then
		
			if SGroup_IsEmpty(sg_truckGroup) and SGroup_IsAlive(sg_truckGroup) == false and g_fueltruckSent == false then -- SGroup_CountSpawned(sg_truckGroup) <= 0  then
				Util_CreateSquads(player2, sg_truckGroup, SBP.GERMAN.OPEL_BLITZ_SQUAD, g_truckSpawn, g_truckDest)
				SGroup_SetAnimatorState(sg_truckGroup, "supplies_loaded", "half")
				
				
				--Event_Proximity(EvacTruck, {group = sg_truckGroup}, sg_truckGroup, g_truckDest, 8, ANY, t_difficulty.truckLoadDelay)
				if Rule_Exists(EvacTruckCheck) == false then
					g_fueltruckSent = true
					Rule_AddDelayedInterval(EvacTruckCheck, 1, 1)
				end
			end
		elseif g_stopTruckSpawn == true then -- removes rule when objective is complete
		
			Rule_RemoveMe()
		end
	elseif g_stopTruckPause == true then
	
		--Rule_RemoveMe()
	end
end


function EvacTruckCheck()

	if SGroup_IsEmpty(sg_truckGroup) == false and SGroup_IsAlive(sg_truckGroup) == true then
		
		if Prox_MarkerSGroup(g_truckDest, sg_truckGroup, PROX_SHORTEST) <= 8 then
			
			if Rule_Exists(EvacTruckDelay) == false then				
				
				-- initialize defender goal if they exist, now that the trucks are spawned
				if g_externalTruckDefenders ~= nil and (g_externalTruckDefenders:IsAlive() == true)	then	
					g_externalTruckDefenders:ClearGoal()
					local goal = {
						name = "Defend",
						target = sg_truckGroup,
						range = 35,
						leashRange = 17,
						attackMove = true,
						coordinatedSetup = false,
						maxIdleTime = -1,
						maxTime = -1,		
					},
					Event_IsEngaged(TruckDefenders_OnEngaged, {encounter = g_externalTruckDefenders, goal = goal, truck = sg_truckGroup}, g_externalTruckDefenders:GetSgroup(), ANY, 5)
				end
				
				
				
				Rule_AddOneShot(DispatchDefendersDelay, t_difficulty.truckLoadDelay - 3)
				Rule_AddOneShot(EvacTruckDelay, (t_difficulty.truckLoadDelay))
			end			
			
			Rule_RemoveMe()
		end
	else	
		Rule_RemoveMe()
	end
end

function EvacTruckDelay()
	if SGroup_IsEmpty(sg_truckGroup) == false and SGroup_IsAlive(sg_truckGroup) == true then
		EvacTruck({group = sg_truckGroup})
	end
end

--Moves one of the German supply trucks off-map
function EvacTruck(data)
	
	if SGroup_IsEmpty(data.group) == false and SGroup_IsAlive(data.group) == true then
		if g_stopTruckPause == false then
		
			local truck = data.group
			
			--Check to see if the truck was destroyed while waiting to evac
			if(SGroup_CountSpawned(truck) <= 0 ) then
				return
			end
			
			--Set truck cargo state
			SGroup_SetAnimatorState(truck, "supplies_loaded", "full")			
			
			-- Remove any wrecks that could potentially block the escape route
			Util_ClearWrecksFromMarker(EGroup_GetPosition(eg_bridgeLeft), 20)
			Util_ClearWrecksFromMarker(EGroup_GetPosition(eg_bridgeRight), 20)
			
			
			UI_CreateMinimapBlip(truck, 10, BT_AttackHere)
			FOW_RevealSGroupOnly(truck, -1)
			HintPoint_Add(truck, true, 11076626) 		-- LOCDB [11076626] 'Supply truck'
			
			Modify_UnitSpeed(truck, 0.5)
			Cmd_SquadPath(truck, t_pathTrucks.path, true, LOOP_NONE, false, 0)
			
			if Rule_Exists(DespawnTruck) == false then
				print("despawn check activated")
				Rule_AddDelayedInterval(DespawnTruck, 4, 1)
			end
			
			if not Objective_IsStarted(SOBJ_DestroyTrucks) then
				Objective_Start(SOBJ_DestroyTrucks)
				if exitArrow == nil then
					exitArrow = MapIcon_CreateArrow(t_pathTrucks.arrowOrigin, t_pathTrucks.arrowDest, 255, 0, 0, 0)
				end
				
				FOW_RevealMarker(t_pathTrucks.exitPt, -1)
				ExitHint = HintPoint_Add(Marker_GetPosition(t_pathTrucks.exitPt), true, 11079134) -- LOCDB [11079134] 'Truck Escape Route'
				ExitBlip = UI_CreateMinimapBlip(Marker_GetPosition(t_pathTrucks.exitPt), -1, BT_General)
				
			else
				
				if exitArrow == nil then
					exitArrow = MapIcon_CreateArrow(t_pathTrucks.arrowOrigin, t_pathTrucks.arrowDest, 255, 0, 0, 0)
				end
				
				FOW_RevealMarker(t_pathTrucks.exitPt, -1)
				ExitHint = HintPoint_Add(Marker_GetPosition(t_pathTrucks.exitPt), true, 11079134) -- LOCDB [11079134] 'Truck Escape Route'
				ExitBlip = UI_CreateMinimapBlip(Marker_GetPosition(t_pathTrucks.exitPt), -1, BT_General)
				
				Util_StartIntel(EVENTS.WarnTruck)
			end
		elseif g_stopTruckPause == true then
		
		end
	end
end

-- helper function for assigning goal to truck defenders
function TruckDefenders_OnEngaged(data)
	if SGroup_CountSpawned(data.truck) >=1 then -- makes sure goal trucks still exist
		data.encounter:SetGoal(data.goal)
	end
end

function DispatchDefendersDelay()

	if SGroup_IsEmpty(sg_truckGroup) == false and SGroup_IsAlive(sg_truckGroup) == true and g_fueltruckSent == true then
		_dispatchTableInfo = {enc = g_externalTruckDefenders, target = sg_truckGroup}
		DispatchDefenders(_dispatchTableInfo)
		Rule_RemoveMe()	
	end

end


function DispatchDefenders(data)
	if data.enc ~= nil then
		print("defenders sent")
		if defUnitSpeed == nil then
			-- speed to compensate for slower heavier units
			if g_tanks == true then
			
				if g_trucksDestroyed <= 2 then 
					defUnitSpeed = Modify_UnitSpeed(data.enc:GetSgroup(), 0.55) -- flak
				elseif g_trucksDestroyed == 3 then
					defUnitSpeed = Modify_UnitSpeed(data.enc:GetSgroup(), 0.50)
				elseif g_trucksDestroyed >= 4 then
					defUnitSpeed = Modify_UnitSpeed(data.enc:GetSgroup(), 0.55)
				end					
				
			elseif g_tanks == false then
			
			if g_trucksDestroyed <= 2 then 
					defUnitSpeed = Modify_UnitSpeed(data.enc:GetSgroup(), 0.55)
				elseif g_trucksDestroyed >= 3 then
					defUnitSpeed = Modify_UnitSpeed(data.enc:GetSgroup(), 0.50)
				
				end								
			end
		end
		Cmd_SquadPath(data.enc:GetSgroup(), t_pathTrucks.path, true, LOOP_NONE, true, 0, t_pathTrucks.exitPt, nil, true)
	end
end

--Tells the truck defenders to exit the map. Called if truck is destroyed.
function EvacDefenders()
	--print("Ordering " .. g_externalTruckDefenders.data.name .. " to exit map")
	--g_externalTruckDefenders:ClearGoal()
	--Cmd_Retreat(g_externalTruckDefenders:GetSgroup(), t_pathTrucks.exitPt, t_pathTrucks.exitPt, false, true)
end


function FuelTruckSentDetect()
	if SGroup_IsEmpty(sg_truckGroup) or SGroup_IsAlive(sg_truckGroup) == false and g_fueltruckSent == true then
		g_fueltruckSent = false
	end
end

--Triggered when the truck reaches off-map target
function DespawnTruck()	
	--Determine whether the truck was destroyed or it escaped
	if SGroup_IsEmpty(sg_truckGroup) == false and SGroup_IsAlive(sg_truckGroup) and g_fueltruckSent == true then
		if (SGroup_CountSpawned(sg_truckGroup) > 0 and Prox_AreSquadMembersNearMarker(sg_truckGroup, t_pathTrucks.exitPt, ANY, 10)) then
			print("Fuel truck escaped")
			--The truck reached the exit point
			SGroup_DeSpawn(sg_truckGroup)
			g_fueltruckSent = false
			-- Update the progress bar
			--currentFuelLoss = math.max(currentFuelLoss - truckLossAmount, maxFuelLoss)
			if (currentFuelLoss - truckLossAmount) <= (maxFuelLoss + 0.05) then
				currentFuelLoss = 0
			else
				currentFuelLoss = currentFuelLoss - truckLossAmount
			end
			
			Obj_ShowProgress2(Loc_FormatText(11076624, Loc_ConvertNumber(math.floor(currentFuelLoss*100))), currentFuelLoss)		-- [11076624] 'Remaining Fuel Reserves: %1PERCENT%%%'
			
			--Warn if this is the last truck
			--if(currentFuelLoss - truckLossAmount <= maxFuelLoss and not g_finalWarning) then
			if(currentFuelLoss - truckLossAmount <= warningFuelLoss and not g_finalWarning) then
				g_finalWarning = true
				Util_StartIntel(EVENTS.WarnFinalTruck)
				Obj_SetProgressBlinking(true)
			end
			
			UIWarning_Show(11076628) 		-- LOCDB [11076628] 'Supply truck has escaped'
				
			-- Give new order to defenders to move off-map and despawn
			if g_externalTruckDefenders ~= nil and g_externalTruckDefenders:IsAlive() then
				g_externalTruckDefenders:ClearGoal()
				if defUnitSpeed ~= nil then
					Modifier_Remove(defUnitSpeed)
					defUnitSpeed = nil
				end
				-- tells truck defenders to go down the path 
				Cmd_SquadPath(g_externalTruckDefenders:GetSgroup(), t_pathTrucks.path, true, LOOP_NONE, false, 0, t_pathTrucks.exitPt, nil, true)				
				--EvacDefenders()
			end
				
			if exitArrow ~= nil then
				MapIcon_Destroy(exitArrow)
				exitArrow = nil
			end
			if ExitHint ~= nil then
				HintPoint_Remove(ExitHint)
				ExitHint = nil
			end
			if ExitBlip ~= nil then
				UI_DeleteMinimapBlip(ExitBlip)
				ExitBlip = nil
			end
			
			Rule_RemoveMe()
		end
		
	elseif SGroup_IsEmpty(sg_truckGroup) == true or SGroup_IsAlive(sg_truckGroup) == false and g_fueltruckSent == true then
		-- Supply truck was destroyed
		-- Do nothing, but increase the counter of trucks destroyed
		g_trucksDestroyed = g_trucksDestroyed + 1
		print("Fuel truck destroyed. Count: " .. g_trucksDestroyed)
		g_fueltruckSent = false
			
		-- Give new order to defenders to move off-map and despawn
		if g_externalTruckDefenders ~= nil and g_externalTruckDefenders:IsAlive() then
			g_externalTruckDefenders:ClearGoal()
			if defUnitSpeed ~= nil then
				Modifier_Remove(defUnitSpeed)					
				defUnitSpeed = nil
			end
			-- tells truck defenders to go down the path	
			Cmd_SquadPath(g_externalTruckDefenders:GetSgroup(), t_pathTrucks.path, true, LOOP_NONE, false, 0, t_pathTrucks.exitPt, nil, true)
			--EvacDefenders()
		end
		
	
		if exitArrow ~= nil then
			MapIcon_Destroy(exitArrow)
			exitArrow = nil
		end
		if ExitHint ~= nil then
			HintPoint_Remove(ExitHint)
			ExitHint = nil
		end
		if ExitBlip ~= nil then
			UI_DeleteMinimapBlip(ExitBlip)
			ExitBlip = nil
		end
		Rule_RemoveMe()
	end

end

--Checks if the player captures the fuel point.
function CheckFuelPointCaptured()
	if Util_GetPlayerOwner(eg_fuelLocation) == player1 then
		Rule_RemoveMe()
		
		StartHoldFuelTimer()
		
		if Rule_Exists(CheckHoldFuelTimer) == false then
			Rule_AddInterval(CheckHoldFuelTimer, 1)
		end
	end
end

--Called when the player secures the fuel point.
function StartHoldFuelTimer()
	if Timer_Exists(tmr_capFuel) == false then
		Timer_Start(tmr_capFuel,  t_difficulty.capTimerLength)
		Objective_UpdateText(SOBJ_CapFuelPoints, 11079163) -- LOCDB [11079163] 'Hold the Fuel Depot'
		Objective_StartTimer(SOBJ_CapFuelPoints, COUNT_DOWN, t_difficulty.capTimerLength, 10)	
		
		if g_stopTruckPause == false then
			g_stopTruckPause = true
		end
		
		if fuelUIID ~= nil then
			Objective_RemoveUIElements(SOBJ_CapFuelPoints, fuelUIID)
			fuelUIID = Objective_AddUIElements(SOBJ_CapFuelPoints, eg_fuelLocation, true, 11079163, true, 3.5) 		--[11079163] 'Hold the Fuel Depot'
		end
	end
end

function StopHoldFuelTimer()
	if Timer_Exists(tmr_capFuel) == true then
		Timer_End(tmr_capFuel)
		Objective_UpdateText(SOBJ_CapFuelPoints,11076623, nil) --[11076623] 'Capture the Fuel Depot'
		Objective_StopTimer(SOBJ_CapFuelPoints)
		
		if g_stopTruckPause == true then
			g_stopTruckPause = false
		end
		
		if fuelUIID ~= nil then
			Objective_RemoveUIElements(SOBJ_CapFuelPoints, fuelUIID)
			fuelUIID = Objective_AddUIElements(SOBJ_CapFuelPoints, eg_fuelLocation, true, 11076623, true, 3.5) 		--[11076623] 'Capture the Fuel Depot'
		end
		
		Rule_AddInterval(CheckFuelPointCaptured, 1)
		Rule_RemoveMe()
	end
end


--Check if the holdFuel timer has finished
function CheckHoldFuelTimer()

	if Util_GetPlayerOwner(eg_fuelLocation) ~= player1 then
		Rule_RemoveMe()
		Rule_AddInterval(StopHoldFuelTimer, 1)
		
	elseif Util_GetPlayerOwner(eg_fuelLocation) == player1 and math.floor(Timer_GetRemaining(tmr_capFuel)) <= 0 then
		Rule_RemoveMe()
		g_fuelPointCaptured = true
	end
end


--Debug function. Resets fuel loss
function delayloss()
	if Misc_IsCommandLineOptionSet("dev") then
		currentFuelLoss = 1.0
	end
end

