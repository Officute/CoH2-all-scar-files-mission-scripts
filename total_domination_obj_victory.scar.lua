print("\tLoading ObjExample file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Total Domination
-- Objective File - VICTORY
-- Designer: Ryan McGechaen
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_ObjVictory()
	print("Initializing ObjVictory...")
	
	-- Pre-condition:		Scenario start
	-- Success condition:	Enemy tickers reach 0
	-- Failure condition:	Player tickers reach 0
	-- Post-condition:
	--		Success:		mission win
	--		Failure:		mission fail
	OBJ_Victory = {
		--Info
		Title = 11075874,-- LOCDB [11075874] 'Reduce the Germans to zero Victory Point tickers'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,
		Parent = nil,
		subObjectives = {
		},
		
		--Intel
		Intel_Start = 				nil,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			EVENTS.Victorious,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				function() Util_StartIntel(EVENTS.Defeated) end,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = function()
		end,
		PreStart = nil,
		OnStart = function()
			Rule_AddInterval(__MonitorTerritories, 1)
		end,
		IsComplete = function()
			return g_player2Tickers == 0 or g_victory == true
		end,
		PreComplete = function()
			Rule_Remove(__MonitorTerritories)
			Rule_Remove(VP_TickDown)
			Rule_Remove(VP_TickUp)
			Event_RemoveAll()
			AI_RemoveAllEncounters()
			Rule_RemoveAll(8)
		end,
		OnComplete = function() Rule_AddInterval(Mission_Complete, 1) end,
		IsFailed = function()
			return g_player1Tickers == 0 or g_defeat == true
			end,
		PreFail = function()
			Rule_Remove(__MonitorTerritories)
			Rule_Remove(VP_TickDown)
			Rule_Remove(VP_TickUp)
		end,
		OnFail = function() Rule_AddInterval(Mission_Fail, 1) end,
	}
	
	
	
	-- Pre-condition:		
	-- Success condition:	
	-- Failure condition:	
	-- Post-condition:
	--		Success:		
	--		Failure:		
	SOBJ_HoldPoints = {
		Title = 11075877, -- LOCDB [11075877] 'Tickers are only reduced when a player holds all three victory points'
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
		OnStart = function() 
			Rule_AddInterval(CountPlayerVPs, 1)	-- start counting how many VPs we have
		end,
		IsComplete = function()
				return ((g_player1Tickers > 0 and g_player2Tickers <= 0) and g_playerCapturedAll == true)
			end,
		PreComplete = nil,
		OnComplete = function()
				g_victory = true
			end,
		IsFailed = function()
		
				return ((g_player2Tickers > 0 and g_player1Tickers <= 0) and g_enemyCapturedAll == true)
			end,
		PreFail = nil,
		OnFail = function()
				print("fail2")
				g_defeat = true
			end,
	}
	table.insert(OBJ_Victory.subObjectives, SOBJ_HoldPoints) -- Don't forget to add them to their parent!
	
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
--~ 		local playerOwns = 0
--~ 		local aiOwns = 0
--~ 		local neutral = 0
--~ 		
--~ 		local totalPoints = EGroup_Count(eg_allStratPoints)
--~ 		
--~ 		local __countPoints = function(gid, idx, eid)
--~ 			if Player_OwnsEntity(player1, eid) then
--~ 				playerOwns = playerOwns + 1
--~ 			elseif Player_OwnsEntity(player2, eid) then
--~ 				aiOwns = aiOwns + 1
--~ 			else
--~ 				neutral = neutral + 1
--~ 			end
--~ 		end
--~ 		
--~ 		EGroup_ForEach(eg_allStratPoints, __countPoints)
		
		-- Set Progress bar
	
		VP_Ownership()
		local statTable = t_ownershipTable
		local totalPoints = EGroup_Count(eg_allStratPoints)

--~ 		if Player_OwnsEGroup(player1, eg_allStratPoints, ALL) and g_playerCapturedAll == false then
--~ 			--print("ding!")
--~ 			g_playerCapturedAll = true
--~ 			Player_AddResource(player2, RT_Manpower, 500)
--~ 			Player_AddResource(player2, RT_Munition, 100)
--~ 			Player_AddResource(player2, RT_Fuel, 100)
--~ 			_StartTimer()
--~ 		elseif Player_OwnsEGroup(player1, eg_allStratPoints, ALL) == false and g_playerCapturedAll then
--~ 			g_playerCapturedAll = false
--~ 			ResetTimer()
--~ 		end

		if Player_OwnsEGroup(player1, eg_allStratPoints, ALL) and g_playerCapturedAll == false then
			
			g_playerCapturedAll = true			
			
			Util_MissionTitle(11075878) -- LOCDB [11075878] 'We now control all the Victory Points.'
			Objective_UpdateText(SOBJ_HoldPoints, 11075879, 11075880, false) -- LOCDB [11075879] 'Maintain control of all the Victory Points'-- LOCDB [11075880] 'Capture and hold all the Victory Points'
			
			Util_StartIntel(EVENTS.VPAllPlayer)
			
			-- compensate the AI 
			--Player_AddResource(player2, RT_Manpower, 500)
			--Player_AddResource(player2, RT_Munition, 100)
			--Player_AddResource(player2, RT_Fuel, 100)			
			
			--ManpowerLimit = Modify_PlayerResourceRate(player1, RT_Manpower, t_difficulty.resourceLimitRate)
			--MunitionLimit = Modify_PlayerResourceRate(player1, RT_Munition, t_difficulty.resourceLimitRate)
			--FuelLimit = Modify_PlayerResourceRate(player1, RT_Fuel, t_difficulty.resourceLimitRate)
			
			--_StartTimer()
			
		elseif Player_OwnsEGroup(player2, eg_allStratPoints, ALL) and g_enemyCapturedAll == false then
			
			g_enemyCapturedAll = true
			Util_MissionTitle(11075881) -- LOCDB [11075881] 'The enemy has all Victory Points.'
			Objective_UpdateText(SOBJ_HoldPoints, 11075882, 11075883, false) -- LOCDB [11075882] 'Prevent enemy from owning all the Victory Points' -- LOCDB [11075883] 'Prevent enemy from owning all the Victory Points'
			
			Util_StartIntel(EVENTS.VPAllEnemy)
			--_StartTimer()
			
			-- compensate the player
			--Player_AddResource(player1, RT_Manpower, 500)
			--Player_AddResource(player1, RT_Munition, 100)
			--Player_AddResource(player1, RT_Fuel, 100)	
			
			
		elseif Player_OwnsEGroup(player1, eg_allStratPoints, ALL) == false and g_playerCapturedAll then
			
			g_playerCapturedAll = false			
			
			Util_MissionTitle(11075884) -- LOCDB [11075884] 'We have lost total control of the Victory Points.'
			Objective_UpdateText(SOBJ_HoldPoints, 11075885, 11075886, false) -- LOCDB [11075885] 'Capture all Victory Points to decrease enemy VP tickers' -- LOCDB [11075886] 'Capture all Victory Points to decrease enemy VP tickers'
			
			Util_StartIntel(EVENTS.VPPlayerLostControlOfAll)
			-- remove modifiers for player when total control is lost
			if ManpowerLimit ~= nil then
				--Modifier_Remove(ManpowerLimit)
			end
			if MunitionLimit ~= nil then
				--Modifier_Remove(MunitionLimit)
			end
			if FuelLimit ~= nil then
				--Modifier_Remove(FuelLimit)
			end		
			
			--ResetTimer()		
			
		elseif Player_OwnsEGroup(player2, eg_allStratPoints, ALL) == false and g_enemyCapturedAll then
			
			g_enemyCapturedAll = false
			Objective_UpdateText(SOBJ_HoldPoints, 11075887, 11075888, false) -- LOCDB [11075887] 'Capture all Victory Points to decrease enemy VP tickers'	 -- LOCDB [11075888] 'Capture all Victory Points to decrease enemy VP tickers'
			
			Util_MissionTitle(11075889) -- LOCDB [11075889] 'The enemy has lost total control of the Victory Points.'
			--ResetTimer()
			
		end
		
		-- update objective UI text
		if (g_playerCapturedAll == false and g_enemyCapturedAll == false) or  (g_playerCapturedAll == true and g_enemyCapturedAll == false) then
			
			--Obj_HideProgress()
			--Obj_ShowProgress(LOC("Points Held By Player"), (statTable.pOC/totalPoints))
			
		elseif (g_playerCapturedAll == false and g_enemyCapturedAll == true) then
			
			--Obj_HideProgress()
			--Obj_ShowProgress(LOC("Enemy has ALL Victory Points"), (statTable.pOC/totalPoints))
			
		end
	end
end


function Timer_Is_Complete()
	if Objective_IsTimerSet(SOBJ_HoldPoints) then
		--print(Objective_GetTimerSeconds(SOBJ_HoldPoints))
		if math.floor(Objective_GetTimerSeconds(SOBJ_HoldPoints)) <= 0 then
			--return true
			Objective_StopTimer(SOBJ_HoldPoints)
			g_timerComplete = true
		end
	end
end

function _StartTimer()
	if Objective_IsTimerSet(SOBJ_HoldPoints) == false then
		Objective_StartTimer(SOBJ_HoldPoints, COUNT_DOWN, 120)
	elseif Objective_IsTimerSet(SOBJ_HoldPoints) == true then
		Objective_ResumeTimer(SOBJ_HoldPoints)
	end
end

function _PauseTimer()
	
	Objective_PauseTimer(SOBJ_HoldPoints)
end

function ResetTimer()
	Objective_StopTimer(SOBJ_HoldPoints)
	--Objective_StartTimer(SOBJ_HoldPoints, COUNT_DOWN, 120)
	--_PauseTimer()
end


-- keeps updating how many VPs the player has and updates the objective 
function CountPlayerVPs()
	local current_count = 0	-- count of how many vps the player has
	
	
	local count_vps = function(egroup, index, item)
		if Player_OwnsEntity(player1, item) then
			current_count = current_count + 1
		end
	end
	
	-- count how many vps the player owns
	EGroup_ForEach(eg_allStratPoints, count_vps)
	Objective_SetCounter(SOBJ_HoldPoints, current_count, 3)	-- update objective counter
end
