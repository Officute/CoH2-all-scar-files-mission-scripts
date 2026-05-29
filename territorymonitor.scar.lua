


--? @shortdesc Monitors a territory point and warns the player if it goes below a certain capture threshold
--? @extdesc Can receive a parent objective to which to attach a subobjective that displays data.
--? @args Table/EGroup terrs, Float captureThreshold, Int timeoutValue, ScarFN callback, ScarFN alertIntel, Table parentObjective
--? @result Void
function Util_MonitorTerritory(terrs, captureThreshold, timeoutVal, callback, alertIntel, parentObjective)
	local SOBJ_Reclaim = nil
	
	if(parentObjective ~= nil) then
		SOBJ_Reclaim = {
			Title = LOC("Reclaim the territories"),
			Type = OT_Primary,						
			Parent = parentObjective,
			
			OnStart = function() Objective_Show(SOBJ_Reclaim, false) end,
		}
		table.insert(parentObjective.subObjectives, SOBJ_Reclaim) -- Don't forget to add them to their parent!

		Objective_Register(SOBJ_Reclaim)
		Objective_Start(SOBJ_Reclaim, false, true)
		Objective_Show(SOBJ_Reclaim, false)
	end

	__terrMonitorData = {
		objective = SOBJ_Reclaim,
		threshold = captureThreshold,
		timeout = timeoutVal,
		alert = alertIntel,
		failCallback = callback,
		territories = {},
	}
	
	if(scartype(terrs) ~= ST_TABLE) then
		terrs = {terrs}
	end
	
	for k,v in pairs(terrs) do 
		local item = {
			capturePoint = v,
			counter = 0
		}
		table.insert(__terrMonitorData.territories, item)
	end
	
	
	Rule_AddInterval(__MonitorTerritories, 5)
end


-- Internal function used to monitor territories
function __MonitorTerritories()
	for k, terr in pairs(__terrMonitorData.territories) do
		if(Player_GetStrategicPointCaptureProgress(player1, EGroup_GetRandomSpawnedEntity(terr.capturePoint)) <= __terrMonitorData.threshold) then
			if terr.counter == 0 then
				--Freshly lost. Start counters
				Objective_Show(__terrMonitorData.objective, true)
				
				if(not Objective_IsTimerSet(__terrMonitorData.objective)) then
					Objective_StartTimer(__terrMonitorData.objective, COUNT_DOWN, __terrMonitorData.timeout)
					local flashID_reclaim = UI_FlashObjectiveIcon(__terrMonitorData.objective.ID, true)
					Event_Timer(EventHandler_StopFlashing, {flashID = flashID_reclaim}, 6)
				
					if(scartype(__terrMonitorData.alert) == ST_FUNCTION) then
						Util_StartIntel(__terrMonitorData.alert)
						__terrMonitorData.alert = -1
					end
				end
				
				UI_CreateMinimapBlip(terr.capturePoint, 6, BT_DefendHere)
			end
			terr.counter = terr.counter + 5
			
			if terr.counter <= __terrMonitorData.timeout then
--~ 				local timerSeconds = Objective_GetTimerSeconds(__terrMonitorData.objective)
				local timerSeconds = math.ceil(__terrMonitorData.timeout - terr.counter, 0)
				local message = Loc_FormatText(11045653, Loc_ConvertNumber(timerSeconds)) -- LOCDB [11045653] 'Sector lost in %1SECONDS% seconds'
				UI_CreateEntityKickerMessage(World_GetPlayerAt(1), EGroup_GetRandomSpawnedEntity(terr.capturePoint), message)
			end
			if terr.counter > __terrMonitorData.timeout then
				if(__terrMonitorData.failOnTimeout) then
					Objective_Fail(__terrMonitorData.objective)
				end
				if(not Rule_Exists(__terrMonitorData.failCallback)) then Rule_AddOneShot(__terrMonitorData.failCallback, 1) end
				Objective_StopTimer(__terrMonitorData.objective)
				Rule_RemoveMe()
			end
		elseif (Player_GetStrategicPointCaptureProgress(player1, EGroup_GetRandomSpawnedEntity(terr.capturePoint)) >= __terrMonitorData.threshold and terr.counter > 0) then
			terr.counter = 0
			Objective_Show(__terrMonitorData.objective, false)
			Objective_StopTimer(__terrMonitorData.objective)
		end
	end
end