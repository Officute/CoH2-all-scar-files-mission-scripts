-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- 1942 ToW CHALLENGE: TATSINSKAIA AIRFIELD
-- Objective File - DESTROY AIRCRAFT
-- Designer: NJR
-------------------------------------------------------------------------
-------------------------------------------------------------------------


-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_Obj_DestroyAircraft()
	
	-- Pre-condition:		Starts when the player spots the first aircraft
	-- Success condition:	Player has destroyed ALL the aircraft
	-- Failure condition:	N/A
	-- Post-condition:
	--		Success:		N/A
	--		Failure:		N/A
	
	OBJ_DestroyAircraft = {
		
		--Info
		Title = 11052232,				-- Objective Title		-- locdb [11052232] "Destroy Aircraft"
		Type = OT_Primary,							-- Objective Type (OT_Primary, OT_Secondary)
		subObjectives = {},
		
		--Intel
		Intel_Start = 				EVENTS.DestroyAircraft_ObjectiveStart,		-- EVENT called *before* the objective actually starts
		Intel_Start_SkipFunc = 		nil,										-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			nil,										-- This EVENT is called _before_ the objective actually completes
		Intel_Complete_SkipFunc = 	nil,										-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				nil,										-- This EVENT is called _before_ the objective actually fails
		Intel_Fail_SkipFunc = 		nil,										-- Function to play if Intel_Fail is Skipped
		
		--Functions
		SetupUI = function() 						-- This is called alongside the new objective ui animation, but this may occur sometime _after_ the OnStart depending on any running Events
			-- ObjectiveUIElements are removed when Objective_Complete or Objective_Fail are completed
		end,
		Precondition = function() end,
		PreStart = function() end,					-- Called on start, before Intel_Start
		OnStart = function()						-- Called after any Intel_Start items, and the objective is considered officially started here
			
			-- set the counter on the objective
			local count = inital_aircraft_count - EGroup_Count(eg_aircraft)
			Objective_SetCounter(OBJ_DestroyAircraft, count, inital_aircraft_count)	
			
			-- kick off rules to monitor objective progress
			Event_Timer(Aircraft_AddBlipsToPlanes, nil, 1)
			Event_Timer(Aircraft_AircraftDestroyed, nil, 0.5)
			
		end,
		IsComplete = function() 
			return Objective_GetCounter(OBJ_DestroyAircraft) == inital_aircraft_count
		end,
		PreComplete = function() end,				-- Called before Intel_Complete
		OnComplete = function()						-- Called after any Intel_Complete items, and the objective is considered officially completed here. The objective ui animation happens at this time as well.
			
			Util_StartIntel(EVENTS.DestroyAircraft_AllDone)
			
			if Objective_IsComplete(OBJ_ControlTower) == true then
				Event_Timer(EventHandler_ObjectiveStart, {objective = OBJ_Counterattack}, 10)
			end
			
		end,
		IsFailed = function() 
			return false 
		end,
		PreFail = function() end,					-- Called before Intel_Fail
		OnFail = function()	end,					-- Called after any Intel_Fail items, and the objective is considered officially failed here. The objective ui animation happens at this time as well.
	}
	
	
	--------------------
	-- INITIALISATION --
	--------------------
	
	eg_aircraft_still_to_blip = EGroup_CreateIfNotFound("eg_aircraft_still_to_blip")
	
	EGroup_AddEGroup(eg_aircraft_still_to_blip, eg_aircraft)			-- create extra group of aircraft to track which ones we've added blips to
	inital_aircraft_count = EGroup_Count(eg_aircraft)					-- get the number of aircraft on the map at the start of the game 

	t_aircraft_positions = {}											-- note the position of all the aircraft (for triggering kickers later on)
	local _CheckEntity = function(gid, idx, eid)
		table.insert(t_aircraft_positions, Entity_GetPosition(eid))
	end
	EGroup_ForEach(eg_aircraft, _CheckEntity)
	
	flag_first_plane_destroyed = false								 	-- set some flags for use later on 

	
	
	-------------
	-- KICKOFF --
	-------------
	
	-- trigger this to start once a player can see one of the aircraft
	Event_PlayerCanSeeElement(EventHandler_ObjectiveStart, {objective = OBJ_DestroyAircraft}, player1, eg_aircraft, ANY, 4)
	
	-- trigger mini-encounters around each group of planes 
	Event_Proximity(Aircraft_CreateEncounterAroundAircraft, {encounter = ENCOUNTERS.Airfield_Aircraft1}, player1, eg_aircraft_1, 70, ANY)
	Event_Proximity(Aircraft_CreateEncounterAroundAircraft, {encounter = ENCOUNTERS.Airfield_Aircraft2}, player1, eg_aircraft_2, 70, ANY)
	Event_Proximity(Aircraft_CreateEncounterAroundAircraft, {encounter = ENCOUNTERS.Airfield_Aircraft3}, player1, eg_aircraft_3, 70, ANY)
	Event_Proximity(Aircraft_CreateEncounterAroundAircraft, {encounter = ENCOUNTERS.Airfield_Aircraft4}, player1, eg_aircraft_4, 70, ANY)
	Event_Proximity(Aircraft_CreateEncounterAroundAircraft, {encounter = ENCOUNTERS.Airfield_Aircraft5}, player1, eg_aircraft_5, 70, ANY)
	Event_Proximity(Aircraft_CreateEncounterAroundAircraft, {encounter = ENCOUNTERS.Airfield_Aircraft6}, player1, eg_aircraft_6, 70, ANY)
	Event_Proximity(Aircraft_CreateEncounterAroundAircraft, {encounter = ENCOUNTERS.Airfield_Aircraft7}, player1, eg_aircraft_7, 70, ANY)
	
	-- trigger extra tanks to come in from outside the airfield when the player hits specific locations
	local setup1 = {
		area = mkr_extra_trigger01,
		spawnloc = mkr_extra_spawn01,
		units = {
			{sbp = SBP.GERMAN.STUG_III_E_SQUAD},
		},
	}
	local setup2 = {								-- area in front of the control tower
		area = mkr_extra_trigger02,
		spawnloc = mkr_extra_spawn02,
		units = {
			{sbp = SBP.GERMAN.STUG_III_E_SQUAD},
			{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222},
		},
	}
	local setup3 = {								-- from behind the fuel depot to the north
		area = mkr_extra_trigger03,
		spawnloc = mkr_extra_spawn03,
		units = {
			{sbp = SBP.GERMAN.STUG_III_E_SQUAD},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD},
		},
	}
	local setup4 = {
		area = mkr_extra_trigger04,
		spawnloc = mkr_extra_spawn04,
		units = {
			{sbp = SBP.GERMAN.PANZER_IV_SQUAD, difficulty = GD_HARD},
			{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222, upgrades = UPG.GERMAN.SDKFZ_222_20MM_GUN, difficulty = GD_NORMAL},
			{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222, difficulty = GD_EASY},
		},
	}
	
	Event_Proximity(Aircraft_CreateExtraEncounter, setup1, player1, mkr_extra_trigger01, nil, ANY)
	Event_Proximity(Aircraft_CreateExtraEncounter, setup2, player1, mkr_extra_trigger02, nil, ANY)
	Event_Proximity(Aircraft_CreateExtraEncounter, setup3, player1, mkr_extra_trigger03, nil, ANY)
	Event_Proximity(Aircraft_CreateExtraEncounter, setup4, player1, mkr_extra_trigger04, nil, ANY)
	
	
	
	
end
Scar_AddInit(INIT_Obj_DestroyAircraft)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------

-- This is where any supplemental functions should be written.
-- If any of the objective functions are too big/complex, they should be defined here.


function Aircraft_AircraftDestroyed(data)						-- called on an interval
	
	local count = inital_aircraft_count - EGroup_Count(eg_aircraft)
	
	if count ~= Objective_GetCounter(OBJ_DestroyAircraft) then
		
		-- award bonusses and show kicker 
		for index = #t_aircraft_positions, 1, -1 do 
			
			local pos = t_aircraft_positions[index]
			if Prox_AreEntitiesNearMarker(eg_aircraft, pos, ANY, 5) == false then
				
				Player_AddResource(player1, RT_Munition, t_difficulty.aircraft_munitions_award)					-- award bonus resources 
				
				pos.y = pos.y + 3																				-- show kicker
				UI_CreateColouredPositionKickerMessage(player1, pos, Loc_FormatText(11052233, Loc_ConvertNumber(t_difficulty.aircraft_munitions_award)) , 255, 0, 0, 0)		-- locdb [11052233] "+%1AMOUNT% Munitions"
				
				table.remove(t_aircraft_positions, index)														-- remove this point so it isn't checked again
				
			end
			
		end
		
		-- set counter
		Objective_SetCounter(OBJ_DestroyAircraft, count, inital_aircraft_count)
		
		-- trigger speech 
		if flag_first_plane_destroyed == false then
			
			Util_StartIntel(EVENTS.DestroyAircraft_FirstDestroyed)
			flag_first_plane_destroyed = true
			
		elseif EGroup_Count(eg_aircraft) == 1 then
			
			Util_StartIntel(EVENTS.DestroyAircraft_OneRemaining)
			
		end
		
	end
	
	
	if EGroup_Count(eg_aircraft) == 0 then
		return
	else
		Event_Timer(Aircraft_AircraftDestroyed, nil, 0.5)		-- re-add the event to check again in a short timeframe
	end
	
	
end



function Aircraft_CreateEncounterAroundAircraft(data)			-- called when the player gets near-ish an individual aircraft (or small group)

	data.encounter()
	
end

function Aircraft_CreateExtraEncounter(data)
	
	ENCOUNTERS.Airfield_IncomingEncounter(data.spawnloc, data.area, data.units)
	
end


function Aircraft_EncounterRetreat(encounter)					-- this is called as the encounter's onFailure callback			

	-- I want to leave any AT guns behind, so let's filter it to just the infantry
	SGroup_Filter(encounter:GetSgroup(), LIST.ATGUNS, FILTER_REMOVE)
	Cmd_StaggeredRetreat(encounter:GetSgroup(), {mkr_controltower_spawn01, mkr_extra_spawn03, mkr_extra_spawn01})

end


function Aircraft_AddBlipsToPlanes()							-- called on an interval
	
	if Player_CanSeeEGroup(player1, eg_aircraft_still_to_blip, ANY) then
		
		local _CheckEntity = function(gid, idx, eid)
			
			if Player_CanSeeEntity(player1, eid) then
				Objective_AddUIElements(OBJ_DestroyAircraft, eid, true, nil, true)
				EGroup_Remove(eg_aircraft_still_to_blip, eid)
			end
			
		end
		EGroup_ForEach(eg_aircraft_still_to_blip, _CheckEntity)
		
	end
	
	if EGroup_IsEmpty(eg_aircraft_still_to_blip) == false then
		Event_Timer(Aircraft_AddBlipsToPlanes, nil, 1)
	end
	
end

