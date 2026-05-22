print("\tLoading ObjExample file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Elsenborn Ridge
-- Objective File - Hold The Line
-- Designer: Ryan McGechaen
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_ObjHoldTheLine()
	print("Initializing OBJ_HoldTheLine...")
	
	-- Pre-condition:		<What are the conditions before the objective starts?>
	-- Success condition:	<What conditions complete the objective?>
	-- Failure condition:	<What conditions fail the objective?>
	-- Post-condition:
	--		Success:		<What happens if the objective is completed?>
	--		Failure:		<What happens if the objective is failed?>
	OBJ_HoldTheLine = {
		--Info
		Title = 11076562,		-- LOCDB [11076562] 'Defend the Victory Points'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,
		Parent = nil,
		subObjectives = {SOBJ_DefendVictoryPoints, SOBJ_NextArtilleryBarrage},
		--Intel
		Intel_Start = 				EVENTS.HoldTheLine_Start,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			EVENTS.HoldTheLine_Complete,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				EVENTS.HoldTheLine_Failed,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = function()
			hpid_left_vp = Objective_AddUIElements(OBJ_HoldTheLine, eg_left_vp, true, 11076563) -- LOCDB [11076563] 'Defend'
			hpid_right_vp = Objective_AddUIElements(OBJ_HoldTheLine, eg_right_vp, true, 11076563) -- LOCDB [11076563] 'Defend'
		end,
		PreStart = nil,
		OnStart = function()
--~ 			local event1 = Event_PlayerOwnsElement(DoNothing, nil, player2, eg_left_vp, 1)
--~ 			local event2 = Event_PlayerOwnsElement(DoNothing, nil, player2, eg_right_vp, 1)
--~ 			
--~ 			Event_CreateOR(HoldTheLine_Fail, nil, {event1, event2}, 1)
			
			g_currentTime = 0
			
			g_pointsLost = 0
			__terrMonitorData = {}
			__terrMonitorData.territories = {
				{
					egroup = eg_left_vp,
					counter = 0,
				},
				{
					egroup = eg_right_vp,
					counter = 0,
				},
			}
			
			Rule_AddInterval(__MonitorTerritories, 1)
			
--~ 			Event_PlayerOwnsTerritory(_HoldTheLine_VP_Captured, {_eg = eg_left_vp, _var = g_leftVP_playerHeld}, player2, eg_left_VP, ANY)
			
--~ 			local currTime = 21*60
--~ 			local timeText = LOC("Time until reinforcements arrive: ")
--~ 			local formatTime = Loc_FormatTime(60, false, true)
--~ 			Obj_ShowProgress2(timeText, g_currentTime)
--~ 			Obj_ShowProgress2((LOC("Time until reinforcements arrive: ")..(Loc_FormatTime(21*60, false, true))), g_currentTime)
			Rule_AddInterval(HoldTheLine_UpdateClock, 1)
		end,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = function()
			--Set the mission success level. Based on how many times the player uses the artillery barrage
			if(g_barrageCount <= 2) then
				XP1_SetMissionSuccessLevel(XPT_MSL_GOLD)
			elseif(g_barrageCount <= 4) then
				XP1_SetMissionSuccessLevel(XPT_MSL_SILVER)
			else
				XP1_SetMissionSuccessLevel(XPT_MSL_BRONZE)
			end			
			
			Metrics_Complete()
			Rule_AddDelayedInterval(Mission_Complete, 5, 1)
		end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = function() 
			Metrics_Complete()
			Rule_AddDelayedInterval(Mission_Fail, 2, 1)
		end,
	}
	
	SOBJ_DefendVictoryPoints = {
		Title = 11076564, -- LOCDB [11076564] 'Hold both victory points'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,						
		Parent = OBJ_HoldTheLine,				
		
		Intel_Start = 				nil,		
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
	table.insert(OBJ_HoldTheLine.subObjectives, SOBJ_DefendVictoryPoints) -- Don't forget to add them to their parent!
	
	SOBJ_ArtilleryBarrageDuration = {
		Title = 11076565, -- LOCDB [11076565] 'Artillery Barrage Complete in:'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,						
		Parent = OBJ_HoldTheLine,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_HoldTheLine.subObjectives, SOBJ_ArtilleryBarrageDuration) -- Don't forget to add them to their parent!
	
	SOBJ_NextArtilleryBarrage = {
		Title = 11076566,  -- LOCDB [11076566] 'Next Artillery Barrage:'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,						
		Parent = OBJ_HoldTheLine,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_HoldTheLine.subObjectives, SOBJ_NextArtilleryBarrage) -- Don't forget to add them to their parent!
	
	SOBJ_RecapturePoint = {
		Title = 11076567, -- LOCDB [11076567] 'Re-capture the'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,						
		Parent = OBJ_HoldTheLine,				
		
		Intel_Start = 				nil,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			nil,		
		Intel_Complete_SkipFunc = 	nil,		
		Intel_Fail = 				nil,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_HoldTheLine.subObjectives, SOBJ_RecapturePoint) -- Don't forget to add them to their parent!
	
end
Scar_AddInit(INIT_ObjHoldTheLine)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------

-- This is where any supplemental functions should be written.
-- If any of the objective functions are too big/complex, they should be defined here.
function HoldTheLine_Complete()
	Objective_Complete(OBJ_HoldTheLine)
end

function HoldTheLine_Fail()
	Objective_Fail(OBJ_HoldTheLine)
end

function HoldTheLine_UpdateClock()
	local percentage = 1 - (Timer_GetElapsed(tmr_objHoldTheLine_clock)/g_missionTime)
	local currTime = math.floor(Timer_GetRemaining(tmr_objHoldTheLine_clock))
	local text = Loc_FormatText(11076568, Loc_FormatTime(currTime, false, false)) -- LOCDB [11076568] 'Time until allied support arrives: %1TIME%'
	
	Obj_ShowProgress2(text, percentage)
	if Timer_GetRemaining(Timer_GetElapsed(tmr_objHoldTheLine_clock)) == 60 then
		Util_StartIntel(EVENTS.HoldTheLine_OneMinute)
	end
end



function DoNothing()
end

-- TODO: This will be replaced with Loc_FormatTime eventually once all lines are converted to loc strings)
function Temp_FormatTime(amt)
	local rawSecs = amt
--~ 	local rawSecs = math.mod(amt, 60)
	
--~ 	local mins = math.floor((amt/60)+0.5)
	
	local startMinutes = math.modf(rawSecs/60)
	local secs = rawSecs - startMinutes*60
	
	local startHours = math.modf(startMinutes/60)
	local mins = math.floor((startMinutes - startHours*60)+0.5)
--~ 	local secs = math.floor(rawSecs+0.5)
	
--~ 	print(math.floor(secs+0.5))
--~ 	print(mins)
	
	local formatMins = ""
	if mins < 10 then
		formatMins = ("0"..mins)
	else
		formatMins = mins
	end
	
	local formatSecs = ""
	if math.floor(secs+0.5) < 10 then
		formatSecs = ("0"..math.floor(secs+0.5))
	else
		formatSecs = math.floor(secs+0.5)
	end
	local formatTime = tostring((formatMins..":"..formatSecs))
	return formatTime
end


function __MonitorTerritories()
--~ 	print("monitoring territories!!!! (hold Line)")
	
	for k,v in pairs(__terrMonitorData.territories) do
		if ( World_OwnsEGroup(v.egroup, ANY) or Util_GetPlayerOwner(v.egroup) == player2 ) and g_missionComplete == false  then
			if v.counter == 0 then
				g_pointsLost = g_pointsLost + 1
				if g_pointsLost >= 2 then
					Rule_RemoveMe()
					Objective_Fail(OBJ_HoldTheLine)
					return
				end
				Util_StartIntel(EVENTS.HoldTheLine_PointCapturing)
				Objective_StartTimer(SOBJ_DefendVictoryPoints, COUNT_DOWN, 180, 90)
				Objective_UpdateText(SOBJ_DefendVictoryPoints, 11076569, 0, true) -- LOCDB [11076569] 'Reclaim the lost Victory Point'
				Objective_SetAlwaysShowDetails(SOBJ_DefendVictoryPoints, true, false, false)
				flashID_defend = UI_FlashObjectiveIcon(SOBJ_DefendVictoryPoints.ID, true)
				
				if v.egroup == eg_left_vp then
					LeftVP_SwitchCoverHintsToBack()
				elseif v.egroup == eg_right_vp then
					RightVP_SwitchCoverHintsToBack()
				end
				
			end
			
			v.counter = v.counter + 1

			if v.counter <= 180 then
				local timerSeconds = Objective_GetTimerSeconds(SOBJ_DefendVictoryPoints)
				local message = Loc_FormatText(11045653, Loc_ConvertNumber(timerSeconds)) -- LOCDB [11045653] 'Sector lost in %1SECONDS% seconds'
				UI_CreateEntityKickerMessage(World_GetPlayerAt(1), EGroup_GetRandomSpawnedEntity(v.egroup), message)
			end
			
			if v.counter > 180 then
				if Player_HasCapturingSquadNearStrategicPoint(player1, EGroup_GetSpawnedEntityAt(v.egroup, 1)) then
					print("Delaying loss")
					return
				end
				Objective_Fail(OBJ_HoldTheLine)
				Rule_RemoveMe()
				return
			end
			
		elseif (Util_GetPlayerOwner(v.egroup) == player1 and v.counter > 0 ) or g_missionComplete == true  then
			print("Player owns")
			v.counter = 0
			g_pointsLost = g_pointsLost - 1
			if flashID_defend ~=nil then
				UI_StopFlashing(flashID_defend)
			end
			Objective_UpdateText(SOBJ_DefendVictoryPoints, 11076570, 0, false) -- LOCDB [11076570] 'Hold both points'
			Objective_SetAlwaysShowDetails(SOBJ_DefendVictoryPoints, false, false, false)
			Objective_StopTimer(SOBJ_DefendVictoryPoints)
			
			if v.egroup == eg_left_vp then
				LeftVP_SwitchCoverHintsToFront()
			elseif v.egroup == eg_right_vp then
				RightVP_SwitchCoverHintsToFront()
			end
			
		end
	end
	
	if g_missionComplete == true then
		Rule_RemoveMe()
	end
end

function _losingHQReminder()
	if Util_GetPlayerOwner(eg_vp) == player2 then 
		Util_StartIntel(EVENTS.LosingHQ)
	end
end





function Hints_ArtilleryLocations()

	t_hints_artillerylocations = {
		{marker = mkr_hint_artillery1},
		{marker = mkr_hint_artillery2},
		{marker = mkr_hint_artillery3},
		{marker = mkr_hint_artillery4},
		{marker = mkr_hint_artillery5},
	}
	
	BeginnerHint_AddOpportunity(sg_tankhints_targets, BP_GetAbilityBlueprint("pm_artillery_support_anti_tank"), true)
	BeginnerHint_AddOpportunity(sg_tankhints_targets, BP_GetAbilityBlueprint("pm_pinpoint_artillery"), true)
	Rule_AddInterval(Hints_UpdateArtilleryLocations, 5)

end


function Hints_UpdateArtilleryLocations()

	for index, item in pairs(t_hints_artillerylocations) do 
	
		Player_GetAllSquadsNearMarker(player2, sg_temp, item.marker)
		
		if item.hintid == nil then
			if SGroup_TotalMembersCount(sg_temp) >= 7 then
				item.hintid = BeginnerHint_AddOpportunity(item.marker, BP_GetAbilityBlueprint("pm_artillery_support_105mm"))
			end
		else
			if SGroup_TotalMembersCount(sg_temp) <= 4 then
				item.hintid = BeginnerHint_RemoveOpportunity(item.hintid)
				item.hintid = nil
			end
		end
	
	end

end


	

function LeftVP_SwitchCoverHintsToFront()

	-- remove the old
	BeginnerHint_RemoveOpportunity(mkr_leftback_heavycover1)
	BeginnerHint_RemoveOpportunity(mkr_leftback_lightcover1)
	BeginnerHint_RemoveOpportunity(mkr_leftback_lightcover2)
	
	-- add the new
	BeginnerHint_AddOpportunity(mkr_leftfront_heavycover1,  HINT_HEAVYCOVER, true)
	BeginnerHint_AddOpportunity(mkr_leftfront_heavycover2,  HINT_HEAVYCOVER, true)
	BeginnerHint_AddOpportunity(mkr_leftfront_heavycover3,  HINT_HEAVYCOVER, true)
	BeginnerHint_AddOpportunity(mkr_leftfront_heavycover4,  HINT_HEAVYCOVER, true)
	
end
function LeftVP_SwitchCoverHintsToBack()

	-- remove the old
	BeginnerHint_RemoveOpportunity(mkr_leftfront_heavycover1)
	BeginnerHint_RemoveOpportunity(mkr_leftfront_heavycover2)
	BeginnerHint_RemoveOpportunity(mkr_leftfront_heavycover3)
	BeginnerHint_RemoveOpportunity(mkr_leftfront_heavycover4)
	
	-- add the new
	BeginnerHint_AddOpportunity(mkr_leftback_heavycover1,  HINT_HEAVYCOVER, true)
	BeginnerHint_AddOpportunity(mkr_leftback_lightcover1,  HINT_LIGHTCOVER, true)
	BeginnerHint_AddOpportunity(mkr_leftback_lightcover2,  HINT_LIGHTCOVER, true)

end


function RightVP_SwitchCoverHintsToFront()

	-- remove the old
	BeginnerHint_RemoveOpportunity(mkr_rightback_heavycover1)
	BeginnerHint_RemoveOpportunity(mkr_rightback_heavycover2)

	-- add the new
	BeginnerHint_AddOpportunity(mkr_rightfront_heavycover1,  HINT_HEAVYCOVER, true)
	BeginnerHint_AddOpportunity(mkr_rightfront_heavycover2,  HINT_HEAVYCOVER, true)
	BeginnerHint_AddOpportunity(mkr_rightfront_heavycover3,  HINT_HEAVYCOVER, true)
	BeginnerHint_AddOpportunity(mkr_rightfront_lightcover1,  HINT_LIGHTCOVER, true)

end
function RightVP_SwitchCoverHintsToBack()

	-- remove the old
	BeginnerHint_RemoveOpportunity(mkr_rightfront_heavycover1)
	BeginnerHint_RemoveOpportunity(mkr_rightfront_heavycover2)
	BeginnerHint_RemoveOpportunity(mkr_rightfront_heavycover3)
	BeginnerHint_RemoveOpportunity(mkr_rightfront_lightcover1)
	
	-- add the new
	BeginnerHint_AddOpportunity(mkr_rightback_heavycover1,  HINT_HEAVYCOVER, true)
	BeginnerHint_AddOpportunity(mkr_rightback_heavycover2,  HINT_HEAVYCOVER, true)

end


