
function __Metrics_Init()

	__lastUnitCount = 0
	__lastSquadCount = 0
	__lastGameTime = 0
	__lastPointsLost = 0
	__totalPointsLost = 0
	
end

Scar_AddInit(__Metrics_Init)

function Metrics_Start()
--~ 	EGroup_InstantCaptureStrategicPoint(eg_left_vp, player2)
	
end

function Metrics_RegisterCapturePoint(egroup, playerOwner)
	local playerOwner = playerOwner or player2
	Event_PlayerOwnsElement(_metrics_capturePoint, {_egroup = egroup, _player = playerOwner}, playerOwner, egroup, 0, ALL)
end

function _metrics_capturePoint(data)
	local recapturePlayer = data._player
	
	__totalPointsLost = __totalPointsLost + 1
	
	if recapturePlayer == player1 then
		recapturePlayer = player2
	elseif recapturePlayer == player2 then
		recapturePlayer = player1
	end
	Event_PlayerOwnsElement(_metrics_capturePoint_Reset, data, recapturePlayer, egroup, 1, ALL)
end

function _metrics_capturePoint_Reset(data)
	local egroup = data._egroup
	local player = data._player
	
	Metrics_RegisterCapturePoint(egroup, player)
end

function Metrics_Complete()

	print("*******************************************************************************************")
	print("*******************************************************************************************")
	print("****************************************  METRICS  ****************************************")
	print("*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*")
	print("-------------------------------------  END GAME STATS  ------------------------------------")
	print("GAME TIME: *** "..Stats_TotalDuration().." ***")
	print("-----------------------------------------  LOSSES  ----------------------------------------")
	print("TOTAL PLAYER UNITS LOST: *** "..Stats_InfantryLost(player1).." ***")
	print("TOTAL PLAYER SQUADS LOST: *** "..Stats_TotalSquadsLost(player1).." ***")
	print("")
	print("TOTAL PLAYER VEHICLES LOST: *** "..Stats_VehiclesLost(player1).." ***")
	print("")
	print("TOTAL PLAYER BUILDINGS LOST: *** "..Stats_BuildingsLost(player1).." ***")
	print("-----------------------------------------  KILLS  -----------------------------------------")
	print("TOTAL ENEMY UNITS KILLED: *** "..Stats_KillsTotal(player1).." ***")
	print("")
	print("TOTAL PLAYER BUILDINGS LOST: *** "..Stats_BuildingsLost(player1).." ***")
--~ 	print("----------------------------------------  RESOURCES  --------------------------------------")
--~ 	print("TOTAL RESOURCES SPENT: *** "..Stats_ResSpent(player1).." ***")
--~ 	print("TOTAL RESOURCES SPENT: *** "..Stats_ResSpent(player1).." ***")
	print("-------------------------------------  CAPTURE POINTS  -------------------------------------")
	print("TOTAL POINTS LOST BY PLAYER: *** "..__totalPointsLost.." ***")

end

function Metrics_CheckPoint(checkpointName)
	
	-- Last count
	local totalLost = Stats_InfantryLost(player1)
	local lastCount = __lastUnitCount
	local lostUnits = totalLost-lastCount
	
	-- update lastCount
	__lastUnitCount = totalLost
	
	-- Last count
	local totalLost = Stats_TotalSquadsLost(player1)
	local lastCount = __lastSquadCount
	local lostSquads = totalLost-lastCount
	
	-- update lastCount
	__lastSquadCount = totalLost
	
	-- Last count Points
	local totalLost = __totalPointsLost
	local lastCount = __lastPointsLost
	local lostPoints = totalLost-lastCount
	
	__lastPointsLost = totalLost
	
	-- Update Time
	local lengthOfTime = (Stats_TotalDuration()-__lastGameTime)
	__lastGameTime = Stats_TotalDuration()
	
	
	print("*******************************************************************************************")
	print("*******************************************************************************************")
	print("****************************************  METRICS  ****************************************")
	print("*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*")
	print("----------------------------  CHECKPOINT: "..checkpointName.."  ---------------------------")
	print("TIME FOR CHECKPOINT: *** "..__formatTime(lengthOfTime).." ***")
	print("TOTAL PLAYER UNITS LOST SINCE LAST CHECK: *** "..lostUnits.." ***")
	print("TOTAL PLAYER SQUADS LOST SINCE LAST CHECK: *** "..lostSquads.." ***")
	print("TOTAL POINTS LOST SINCE LAST CHECK: *** "..lostPoints.." ***")
	
end


function __formatTime(sSeconds)
	local nSeconds = sSeconds
	if nSeconds == 0 then
		--return nil;
		return "00:00:00";
	else 
		nHours = string.format("%02.f", math.floor(nSeconds/3600));
		nMins = string.format("%02.f", math.floor(nSeconds/60 - (nHours*60)));
		nSecs = string.format("%02.f", math.floor(nSeconds - nHours*3600 - nMins *60));
		return nHours..":"..nMins..":"..nSecs
	end
end
