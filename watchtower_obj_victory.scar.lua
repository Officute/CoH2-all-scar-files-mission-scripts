print("\tLoading ObjExample file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Watchtower
-- Objective File - VICTORY
-- Designer: Ryan McGechaen
-------------------------------------------------------------------------
-------------------------------------------------------------------------


-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_ObjVictory()
	print("Initializing ObjVictory...")
	
	-- Pre-condition:		<What are the conditions before the objective starts?>
	-- Success condition:	<What conditions complete the objective?>
	-- Failure condition:	<What conditions fail the objective?>
	-- Post-condition:
	--		Success:		<What happens if the objective is completed?>
	--		Failure:		<What happens if the objective is failed?>
	OBJ_Victory = {
		--Info
		Title = 11075860, -- LOCDB [11075860] 'Defeat the Germans'
		TitleEnd = nil,
		TitleFail = nil, 
		Type = OT_Primary,
		Parent = nil,
		subObjectives = {
		},
		
		--Intel
		Intel_Start = 				nil,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			nil,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				nil,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = nil,
		PreStart = nil,
		OnStart = function()
			DepleteFuel_Init()
		end,
		IsComplete = nil,
		PreComplete = function()
			Obj_HideProgress()
		end,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = function()
			Obj_HideProgress()
		end,
		OnFail = nil,
	}
	
	
	SOBJ_DepleteFuel = {
		Title = 11075864, -- LOCDB [11075864] 'Prevent the Germans from taking the supply drops'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Information,						
		Parent = OBJ_Victory,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = function()
			return DepleteFuel_GetFuel(g_germanCurrFuel) <= 0
		end,
		PreComplete = nil,
		OnComplete = function()
			Rule_RemoveIfExist(UpdateTickers)			
			Rule_RemoveIfExist(DepleteFuel_Manager)
			Rule_Add(Mission_Won_Speech)
		end,
		IsFailed = function()
			return DepleteFuel_GetFuel(g_aefCurrFuel) <= 0
		end,
		PreFail = nil,
		OnFail = function()
			Rule_RemoveIfExist(UpdateTickers)
			Rule_RemoveIfExist(DepleteFuel_Manager)
			Rule_Add(Mission_Lost_Speech)
		end,
	}
	table.insert(OBJ_Victory.subObjectives, SOBJ_DepleteFuel) -- Don't forget to add them to their parent!
	
end

Scar_AddInit(INIT_ObjVictory)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------


--------------------------------------------------
-- Hold Points Functions
--
-- Monitors territories and updates progress bars
function __MonitorTerritories()
	if EGroup_IsEmpty(eg_allStratPoints) == false then
		local playerOwns = 0
		local aiOwns = 0
		local neutral = 0
		
		local totalPoints = EGroup_Count(eg_allStratPoints)
		
		local __countPoints = function(gid, idx, eid)
			if Player_OwnsEntity(player1, eid) then
				playerOwns = playerOwns + 1
			elseif Player_OwnsEntity(player2, eid) then
				aiOwns = aiOwns + 1
			else
				neutral = neutral + 1
			end
		end
		
		EGroup_ForEach(eg_allStratPoints, __countPoints)
		
		-- Set Progress bar
		Obj_ShowProgress(11075869, (playerOwns/totalPoints)) -- LOCDB [11075869] 'Points Held'
		
	end
end

function DepleteFuel_Init()
	
	g_germanStartFuel = t_difficulty.germanStartFuel
	g_aefStartFuel = t_difficulty.aefStartFuel
	
	g_germanCurrFuel = g_germanStartFuel
	g_aefCurrFuel = g_aefStartFuel
	
	
	g_fuelDepleteRate = 1.2 -- depletion modifier default 1
	g_fuelGained = 125 -- default 100
	
	Rule_AddInterval(DepleteFuel_Manager, 1)
	Rule_AddInterval(IndicateLowFuelLevel, 1)
	
	-- TEMP STUFF
	g_displayAEF = true
	Rule_AddInterval(UpdateTickers, 2)
	
end

--[[
	Start at 900
	Fuel depletes at 1/sec
	60 points/min
	Match could be over as early as 15 mins
	Drop ~= every 1.5 minutes
]]

function DepleteFuel_Manager()
	
	g_germanCurrFuel = _depleteFuel_drainFuel(g_germanCurrFuel, g_fuelDepleteRate)
	g_aefCurrFuel = _depleteFuel_drainFuel(g_aefCurrFuel, g_fuelDepleteRate)
end

-- function for display
function UpdateTickers()
--~ 	if g_displayAEF == true then
--~ 		g_displayAEF = false
--~ 		Obj_ShowProgress(11075870, g_germanCurrFuel/g_germanStartFuel) -- LOCDB [11075870] 'German Supply Level'
--~ 
--~ 	elseif g_displayAEF == false then
--~ 		g_displayAEF = true
--~ 		Obj_ShowProgress(11075871 -- LOCDB [11075871] 'AEF Supply Level'
--~ , g_aefCurrFuel/g_aefStartFuel)
--~ 	end
	
	if g_germanCurrFuel == nil then 
		g_germanCurrFuel = 0
	end
	if g_aefCurrFuel == nil then
		g_aefCurrFuel = 0
	end
	
	local num1 = math.floor((g_aefCurrFuel/g_aefStartFuel) *250)
	
	local num2 = math.floor((g_germanCurrFuel/g_germanStartFuel) *250)	
	
	
	
	WinWarning_SetTickers(num1, num2)
end

function DepleteFuel_DropSupplies(target)
	Cmd_Ability(player1, BP_GetAbilityBlueprint("pm_drop_fuel_in_the_blind"), target, nil, true)
end

function DepleteFuel_GetFuel(owner)
	return owner
end

-- Depletes the fuel by set amount (if none set, defaults to 1)
function _depleteFuel_drainFuel(fuelReserve, amount)
	local newAmount = fuelReserve-amount or fuelReserve-0.5
	if newAmount >=1 then
	
		return newAmount
		
	else
		return 0
	
	end
end

-- Adds to the fuel reserves
function _depleteFuel_replenishFuel(fuelReserve, amount)
	local newAmount = fuelReserve+amount or fuelReserve+g_fuelGained
	return newAmount
end

-- Callback for picking up fuel - DO NOT DELETE/RENAME!
function _depleteFuel_pickupObject(executor, target)
	
	if g_aefCurrFuel <= 0 or g_germanCurrFuel <= 0 then
	
	else
	
		local player = Squad_GetPlayerOwner(executor)
		if player == player1 then
			
			g_aefCurrFuel = _depleteFuel_replenishFuel(g_aefCurrFuel, g_fuelGained)
			
			Util_MissionTitle(11075872) -- LOCDB [11075872] 'Allies captured the air drop.'
			Util_StartIntel(EVENTS.AlliesCapturedAirDrop)
			
			FlashingSuppliesSymbol_Stop("blue")
			-- TODO: Flash blue VP bar
			if EGroup_Count(eg_supplies) >= 1 then
				local entity = EGroup_GetSpawnedEntityAt(eg_supplies, 1)
				UI_CreateColouredEntityKickerMessage(player1, entity, 11079404, 80, 140, 200, 0)	-- LOCDB [11079404]
			end
			
		elseif player == player2 then
			
			g_german_captures = g_german_captures + 1
			g_germanCurrFuel = _depleteFuel_replenishFuel(g_germanCurrFuel, g_fuelGained)		
			
			Util_MissionTitle(11075873) -- LOCDB [11075873] 'Germans captured the air drop.'
			Util_StartIntel(EVENTS.GermansCapturedAirDrop)
			
			FlashingSuppliesSymbol_Stop("red")
			-- TODO: Flash red VP bar
			if EGroup_Count(eg_supplies) >= 1 and Player_CanSeeEGroup(player1, eg_supplies, ANY) then
				local entity = EGroup_GetSpawnedEntityAt(eg_supplies, 1)
				UI_CreateColouredEntityKickerMessage(player1, entity, 11079404, 255, 0, 0, 0)	-- LOCDB [11079404]
			end
			
		end
	end
end

function IndicateLowFuelLevel()
	
	if g_aefCurrFuel <= g_aefStartFuel * 0.15 and g_aefCurrFuel > 0 then		
		Util_StartIntel(EVENTS.AlliedFuelLow)
		Event_Timer(_restartFuelLowIndicator, {}, 60)
		Rule_RemoveMe()
	end

end 

function _restartFuelLowIndicator()

	Rule_AddInterval(IndicateLowFuelLevel, 1)

end


function FlashingSuppliesSymbol_Start()

	WinWarning_ScoreDisplayIconsClear()
	WinWarning_ScoreDisplayIconAdd("Icons_symbols_building_supply_drop_gray_symbol", 255, 255, 255, 0, 11079394, 11079395, "Icons_resources_flag_crate_parachute")
	
	_flashingSuppliesSymbol_flashState = 0
	Rule_AddInterval(FlashingSuppliesSymbol_Manager, 0.5)	-- turn this symbol on and off every 0.5 secs
	
end

function FlashingSuppliesSymbol_Manager()

	-- flip the icon between two states
	if _flashingSuppliesSymbol_flashState == 0 then		
		
		WinWarning_ScoreDisplayIconsClear()
		WinWarning_ScoreDisplayIconAdd("Icons_symbols_building_supply_stack_gray_symbol", 255, 255, 255, 0, 11079394, 11079395, "Icons_resources_flag_crate_parachute")

		_flashingSuppliesSymbol_flashState = 1
		
	elseif _flashingSuppliesSymbol_flashState == 1 then
		
		WinWarning_ScoreDisplayIconsClear()
		WinWarning_ScoreDisplayIconAdd("Icons_symbols_building_supply_drop_gray_symbol", 255, 255, 255, 0, 11079394, 11079395, "Icons_resources_flag_crate_parachute")
	
		_flashingSuppliesSymbol_flashState = 0
		
	end
	
end

function FlashingSuppliesSymbol_Stop(color)
	
	Rule_RemoveIfExist(FlashingSuppliesSymbol_Manager)
	
	if color == "red" then
		WinWarning_ScoreDisplayIconsClear()
		WinWarning_ScoreDisplayIconAdd("Icons_symbols_building_supply_drop_red_symbol", 255, 255, 255, 0, 11079394, 11079395, "Icons_resources_flag_crate_parachute")
	elseif color == "blue" then
		WinWarning_ScoreDisplayIconsClear()
		WinWarning_ScoreDisplayIconAdd("Icons_symbols_building_supply_drop_blue_symbol", 255, 255, 255, 0, 11079394, 11079395, "Icons_resources_flag_crate_parachute")
	end
	
	Rule_RemoveIfExist(FlashingSuppliesSymbol_Stop_PartB)
	Rule_AddOneShot(FlashingSuppliesSymbol_Stop_PartB, 5)
	
end
function FlashingSuppliesSymbol_Stop_PartB()

	WinWarning_ScoreDisplayIconsClear()
	WinWarning_ScoreDisplayIconAdd("Icons_symbols_building_supply_stack_symbol", 255, 255, 255, 0, 11079676, 11079677, "Icons_resources_flag_crate")

end
