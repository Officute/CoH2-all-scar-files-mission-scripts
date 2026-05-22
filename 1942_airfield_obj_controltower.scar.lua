-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- 1942 ToW CHALLENGE: TATSINSKAIA AIRFIELD
-- Objective File - BREACH GATES
-- Designer: NJR
-------------------------------------------------------------------------
-------------------------------------------------------------------------


-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_Obj_ControlTower()
	
	-- Pre-condition:		Starts at the beginning of the mission
	-- Success condition:	Player captures the territory around the airfield's Control Tower
	-- Failure condition:	N/A
	-- Post-condition:
	--		Success:		Counterattack starts
	--		Failure:		N/A
	
	OBJ_ControlTower = {
		
		--Info
		Title = 11052231,	-- Objective Title		-- locdb [11052231] "Capture the Control Tower"
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		subObjectives = {},
		
		--Intel
		Intel_Start = 				nil,		-- EVENT called *before* the objective actually starts
		Intel_Start_SkipFunc = 		nil,		-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			nil,		-- This EVENT is called _before_ the objective actually completes
		Intel_Complete_SkipFunc = 	nil,		-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				nil,		-- This EVENT is called _before_ the objective actually fails
		Intel_Fail_SkipFunc = 		nil,		-- Function to play if Intel_Fail is Skipped
		--Functions
		SetupUI = function() 						-- This is called alongside the new objective ui animation, but this may occur sometime _after_ the OnStart depending on any running Events
			Objective_AddUIElements(OBJ_ControlTower, eg_point_airfield, true, 11052231, true)
		end,
		Precondition = function() end,
		PreStart = function() end,					-- Called on start, before Intel_Start
		OnStart = function()						-- Called after any Intel_Start items, and the objective is considered officially started here
			
			-- when the player gets close, kick the bulk of this objective in
			Event_Proximity(ControlTower_Setup, nil, player1, mkr_controltower_zone, nil, ANY)
			
		end,
		IsComplete = function() 
			
			if Player_OwnsEGroup(player1, eg_point_airfield, ANY) then
				return true
			end
			
			return false 
			
		end,
		PreComplete = function() end,				-- Called before Intel_Complete
		OnComplete = function()						-- Called after any Intel_Complete items, and the objective is considered officially completed here. The objective ui animation happens at this time as well.
			
			-- make the point permanently P1's
			Entity_EnableStrategicPoint(EGroup_GetSpawnedEntityAt(eg_point_airfield, 1), false)
			
			-- and kick off a counterattack in a few secs
			if Objective_IsComplete(OBJ_DestroyAircraft) == true then
				Event_Timer(EventHandler_ObjectiveStart, {objective = OBJ_Counterattack}, 6)
			else
				-- remind player to destroy remaining aircraft?
				Util_StartIntel(EVENTS.DestroyAircraft_ObjectiveReminder)
			end
			
		end,
		IsFailed = function() return false end,
		PreFail = function() end,					-- Called before Intel_Fail
		OnFail = function()	end,					-- Called after any Intel_Fail items, and the objective is considered officially failed here. The objective ui animation happens at this time as well.
	}

	--------------------
	-- INITIALISATION --
	--------------------
	
	sg_patrol1 = SGroup_CreateIfNotFound("sg_patrol1")
	sg_patrol2 = SGroup_CreateIfNotFound("sg_patrol2")
	sg_patrol3 = SGroup_CreateIfNotFound("sg_patrol3")
	sg_patrol4 = SGroup_CreateIfNotFound("sg_patrol4")
	sg_patrol5 = SGroup_CreateIfNotFound("sg_patrol5")
	sg_patrol6 = SGroup_CreateIfNotFound("sg_patrol6")
	
	sg_howitzer_left = SGroup_CreateIfNotFound("sg_howitzer_left")
	sg_howitzer_right = SGroup_CreateIfNotFound("sg_howitzer_right")

	sg_gatesleft_halftrack = SGroup_CreateIfNotFound("sg_gatesleft_halftrack")
	sg_gatesleft_soldiers = SGroup_CreateIfNotFound("sg_gatesleft_soldiers")
	
	sg_gatesright_halftrack = SGroup_CreateIfNotFound("sg_gatesright_halftrack")
	sg_gatesright_soldiers = SGroup_CreateIfNotFound("sg_gatesright_soldiers")
	

	
	-------------
	-- KICKOFF --
	-------------
	
	-- trigger the setup of the gates area immediately
	Event_Timer(BreachGates_Setup, nil, 1)
	
	-- kickoff the regular topups a bit later
	Event_Timer(Airfield_TopUp, nil, 180 )
	
end
Scar_AddInit(INIT_Obj_ControlTower)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------

function __DoNothing()
end

function BreachGates_Setup()
	
	-- create the guys in the towers
	Util_CreateSquads(player2, sg_temp, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, eg_gatehouse_left)
	Util_CreateSquads(player2, sg_temp, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, eg_gatehouse_mid)
	Util_CreateSquads(player2, sg_temp, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, eg_gatehouse_right)
	
	-- set up howitzers
	enc_BreachGates_Howitzers = ENCOUNTERS.BreachGates_Howitzers()
	
	if g_difficulty == GD_NORMAL or g_difficulty == GD_HARD then
		local howitzer1 = Event_GroupIsDead(EventHandler_StartIntel, {intel = EVENTS.BreachGates_OneHowitzerDestroyed}, sg_howitzer_left)	-- trigger speech when you blow up one of the howitzers (only on normal or hard - on easy there's only one anyway)
		local howitzer2 = Event_GroupIsDead(EventHandler_StartIntel, {intel = EVENTS.BreachGates_OneHowitzerDestroyed}, sg_howitzer_right)
		Event_CreateOR(EventHandler_StartIntel, {intel = EVENTS.BreachGates_OneHowitzerDestroyed}, {howitzer1, howitzer2})
	end
	
	-- set up patrols 
	Util_CreateSquads(player2, sg_patrol1, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_gates_patrolspawn1, nil, 1, 3)
	Cmd_SquadPath(sg_patrol1, "path_gates_patrol1", true, LOOP_TOGGLE_DIRECTION, true, 0.5)
	
	Util_CreateSquads(player2, sg_patrol2, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_gates_patrolspawn3, nil, 1, 2)
	Cmd_SquadPath(sg_patrol2, "path_gates_patrol1", true, LOOP_TOGGLE_DIRECTION, true, 1.5)
	
	Util_CreateSquads(player2, sg_patrol3, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_gates_patrolspawn2, nil, 1, 1)
	Cmd_SquadPath(sg_patrol3, "path_gates_patrol2", true, LOOP_TOGGLE_DIRECTION, true, 0.5)
	
	Util_CreateSquads(player2, sg_patrol4, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_gates_patrolspawn4, nil, 1, 3)
	Cmd_SquadPath(sg_patrol4, "path_gates_patrol2", true, LOOP_TOGGLE_DIRECTION, true, 1.5)
	
	Util_CreateSquads(player2, sg_patrol5, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_gates_patrolspawn1, nil, 1, 2)
	Cmd_SquadPath(sg_patrol5, "path_gates_patrol3", true, LOOP_NORMAL, true, 2)
	
	Util_CreateSquads(player2, sg_patrol6, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_gates_patrolspawn3, nil, 1, 2)
	Cmd_SquadPath(sg_patrol6, "path_gates_patrol3", true, LOOP_NORMAL, true, 3)
	
	-- set up triggers for defenders at the gates
	Event_Timer(BreachGates_TriggerLeft, nil, 1)
	Event_Timer(BreachGates_TriggerMid, nil, 1)
	Event_Timer(BreachGates_TriggerRight, nil, 1)
	
	-- set up other misc events
	Event_Timer(BreachGates_DamageFromHowitzer, nil, 4)
	
end



-- trigger the various parts of the gates encounters
function BreachGates_TriggerLeft()		-- Left area (to the top of the airfield)
	
	if Prox_ArePlayersNearMarker(player1, mkr_gates_trigger_left, ANY) 
	or (enc_BreachGates_Mid ~= nil and enc_BreachGates_Mid:IsAlive() == false) then
		
		-- main encounter
		enc_BreachGates_Left = ENCOUNTERS.BreachGates_Left()
		
		-- halftrack full of guys
		Util_CreateSquads(player2, sg_gatesleft_halftrack, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, mkr_gates_spawn1, mkr_gates_trigger_left)
		Util_CreateSquads(player2, sg_gatesleft_soldiers, SBP.GERMAN.PANZER_GRENADIER_SQUAD, sg_gatesleft_halftrack, nil, nil, nil, nil, nil, UPG.GERMAN.PANZERBUSCHE_39)
		Event_PlayerCanSeeElement(BreachGates_DeployHalftrack, {halftrack = sg_gatesleft_halftrack, soldiers = sg_gatesleft_soldiers, encounter = enc_BreachGates_Left}, player1, sg_gatesleft_halftrack, ANY, 1)
		
	else
		Event_Timer(BreachGates_TriggerLeft, nil, 1)
	end
	
end


function BreachGates_TriggerMid()		-- Middle
	
	if Prox_ArePlayersNearMarker(player1, mkr_gates_trigger_mid, ANY)
	or (enc_BreachGates_Left ~= nil and enc_BreachGates_Left:IsAlive() == false)
	or (enc_BreachGates_Right ~= nil and enc_BreachGates_Right:IsAlive() == false) then
		
		-- main encounter
		enc_BreachGates_Mid = ENCOUNTERS.BreachGates_Mid()
		
	else
		Event_Timer(BreachGates_TriggerMid, nil, 1)
	end
	
end


function BreachGates_TriggerRight()		-- Right area (to the bottom of the airfield)
	
	if Prox_ArePlayersNearMarker(player1, mkr_gates_trigger_right, ANY)
	or (enc_BreachGates_Mid ~= nil and enc_BreachGates_Mid:IsAlive() == false) then
		
		-- main encounter
		enc_BreachGates_Right = ENCOUNTERS.BreachGates_Right()
		
		-- halftrack full of guys
		Util_CreateSquads(player2, sg_gatesright_halftrack, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, mkr_gates_spawn1, mkr_gates_trigger_right)
		Util_CreateSquads(player2, sg_gatesright_soldiers, SBP.GERMAN.PANZER_GRENADIER_SQUAD, sg_gatesright_halftrack, nil, nil, nil, nil, nil, UPG.GERMAN.PANZERBUSCHE_39)
		Event_PlayerCanSeeElement(BreachGates_DeployHalftrack, {halftrack = sg_gatesright_halftrack, soldiers = sg_gatesright_soldiers, encounter = enc_BreachGates_Right}, player1, sg_gatesleft_halftrack, ANY, 3.5)
		
	else
		Event_Timer(BreachGates_TriggerRight, nil, 1)
	end
	
end


-- deploy halftrack sequence
function BreachGates_DeployHalftrack(data)

	-- stop the halftrack
	Cmd_Stop(data.halftrack)
	
	Event_Timer(BreachGates_DeployHalftrack_PartB, data, 2)
	Event_Timer(BreachGates_DeployHalftrack_PartC, data, 4)
	
end
function BreachGates_DeployHalftrack_PartB(data)

	-- unload the guys
	Cmd_EjectOccupants(data.halftrack)
	
end
function BreachGates_DeployHalftrack_PartC(data)

	-- add the guys to the encounter
	data.encounter:AddSgroup(data.soldiers)
	
end




-- call out the howitzers when they start damaging your guys
function BreachGates_DamageFromHowitzer()

	if Event_IsAnyRunning() == false then
		
		SGroup_Clear(sg_temp)
		Player_GetAll(player1)
		SGroup_GetLastAttacker(sg_allsquads, sg_temp)
		
		if SGroup_ContainsBlueprints(sg_temp, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, ANY) then
			
			Util_StartIntel(EVENTS.BreachGates_CallOutHowitzers)
			
			if SGroup_Count(sg_howitzer_left) >= 1 then
				UI_CreateMinimapBlip(sg_howitzer_left, 10, BT_AttackHere)
			end
			if SGroup_Count(sg_howitzer_right) >= 1 then
				UI_CreateMinimapBlip(sg_howitzer_right, 10, BT_AttackHere)
			end
			
			return
			
		end
		
	end
	
	Event_Timer(BreachGates_DamageFromHowitzer, nil, 4)
	
end



function Airfield_TopUp()

	if Objective_IsComplete(OBJ_Counterattack) then
		
		return -- early exit, and never repeat
		
	end
	
	
	if enc_AirfieldHarrassment == nil then
		
		-- first time through, create the general runaroundguys encounter
		enc_AirfieldHarrassment = ENCOUNTERS.AirfieldHarrassment()
		
	else
		
		if SGroup_Count(enc_AirfieldHarrassment:GetSgroup()) <= 10 then
			
			local units = {}
			
			Player_GetAll(player1)
			if SGroup_IsUnderAttack(sg_allsquads, ANY, 5) == false then
				-- player is out of combat, spawn something NASTY
				units = {
					{sbp = SBP.GERMAN.GRENADIER_SQUAD, spawn = mkr_controltower_spawn01},
					{sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, spawn = mkr_controltower_spawn02},
					{sbp = SBP.GERMAN.GRENADIER_SQUAD, spawn = mkr_controltower_spawn03},
				}
			else
				-- player is in combat already, just do something small 
				units = {
					{sbp = SBP.GERMAN.GRENADIER_SQUAD, spawn = mkr_controltower_spawn01},
					{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, spawn = mkr_controltower_spawn02, upgrades = UPG.GERMAN.PANZERBUSCHE_39},
				}
			end
			
			-- add them to the general airfield def
			for index, unit in pairs(units) do 
				enc_AirfieldHarrassment:AddUnit(unit)
			end
			
		end
		
	end
	
	local rand = World_GetRand(0, 30)
	Event_Timer(Airfield_TopUp, nil, ((t_difficulty.topup_frequency * 2) + rand) )
	
end




-- triggered when the player gets close to the control tower zone
function ControlTower_Setup()
	
	-- setup units for this objective
	enc_ControlTower_ATGun1 = ENCOUNTERS.ControlTower_ATGun1()
	enc_ControlTower_ATGun2 = ENCOUNTERS.ControlTower_ATGun2()
	enc_ControlTower_Defenders = ENCOUNTERS.ControlTower_Defenders()
	
	-- create static hmg crew in the control tower
--~ 	Util_CreateSquads(player2, sg_controltower_hmg, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, eg_controltower)
	
	-- start up events
	Event_Timer(ControlTower_StukaRun_StartWave, nil, World_GetRand(t_difficulty.stuka_wave_interval_min, t_difficulty.stuka_wave_interval_max))	-- periodic stuka bombing runs
	Event_Proximity(ControlTower_Hint_SecureMode, nil, player1, mkr_controltower_zone, 20, ANY)														-- remind the player about the secure mode
	Event_Timer(ControlTower_PlayerCapturing, nil, 3)

	Rule_Add(ControlTower_Safety_VetUpPlayersLastTank, 1)
	
end


function ControlTower_StukaRun_StartWave()
	
	Player_GetAllSquadsNearMarker(player1, sg_temp, mkr_controltower_zone)
	
	if Objective_IsComplete(OBJ_ControlTower) then
		
		return 		-- early exit, and this event isn't re-added 
		
	elseif SGroup_Count(sg_temp) >= 1 then	-- check there are potential targets
		
		SGroup_Clear(sg_stuka_targets)
		
		-- call out incoming stukas
		local choices = {
			EVENTS.ControlTower_IncomingStukas1,
			EVENTS.ControlTower_IncomingStukas2,
			EVENTS.ControlTower_IncomingStukas3,
			EVENTS.ControlTower_IncomingStukas4,
		}
		Util_StartIntel(Table_GetRandomItem(choices))
		
		-- set up the stuka runs for this wave
		local delay = World_GetRand(3, 6)
		if g_difficulty == GD_EASY then
			Event_Timer(ControlTower_IndividualStukaRun, nil, (1 + delay))
			Event_Timer(ControlTower_IndividualStukaRun, nil, (3 + delay))
		elseif g_difficulty == GD_NORMAL then	
			Event_Timer(ControlTower_IndividualStukaRun, nil, (1 + delay))
			Event_Timer(ControlTower_IndividualStukaRun, nil, (3 + delay))
			Event_Timer(ControlTower_IndividualStukaRun, nil, (5 + delay))
		elseif g_difficulty == GD_HARD then
			Event_Timer(ControlTower_IndividualStukaRun, nil, (1 + delay))
			Event_Timer(ControlTower_IndividualStukaRun, nil, (3 + delay))
			Event_Timer(ControlTower_IndividualStukaRun, nil, (5 + delay))
			Event_Timer(ControlTower_IndividualStukaRun, nil, (7 + delay))
		end
		
	end
	
	Event_Timer(ControlTower_StukaRun_StartWave, nil, World_GetRand(t_difficulty.stuka_wave_interval_min, t_difficulty.stuka_wave_interval_max))		-- re-add the event for the _next_ wave
	
end


function ControlTower_IndividualStukaRun()
	
	-- grab everyone in the danger zone (and remove everyone that's already been targetted on this set of stuka runs)
	Player_GetAllSquadsNearMarker(player1, sg_temp, mkr_controltower_zone)
	SGroup_RemoveGroup(sg_temp, sg_stuka_targets)
	
	if SGroup_Count(sg_temp) >= 1 then
		
		-- pick a random squad
		local target = SGroup_GetRandomSpawnedSquad(sg_temp)
		SGroup_Single(sg_single, target)
		SGroup_Add(sg_stuka_targets, target)
		
		-- now create a reandom-ish position near it
		local target_pos = Util_GetRandomPosition(Util_GetPosition(sg_single), 8)
		
		-- if the target is in the exclude zone, push it to the zone's edge 
		if Marker_InProximity(mkr_stuka_exclude, target_pos) then
			target_pos = Util_GetPositionFromAtoB(mkr_stuka_exclude, target_pos, Marker_GetProximityRadius(mkr_stuka_exclude))
		end
		
		-- call in the stuka!
		Cmd_Ability(player2, BP_GetAbilityBlueprint("tow_airfield_stuka_bombing_run"), target_pos, Marker_GetDirection(mkr_controltower_zone), true)
		
	end
	
end



function ControlTower_Hint_SecureMode()

	if Event_IsAnyRunning() == false then
		
		UI_NewHUDFeature(HUDF_None, 11052230, "Icons_abilities_ability_raid", 10)		-- locdb [11052230] "Veteran tanks can switch into Secure Mode. In this mode they can secure territory points, but their weapons will be disabled."
		UI_FlashAbilityButton(ABILITY.SOVIET.TANK_VET_POINT_CAPTURE_ABILITY, true)
		
	else
		
		Event_Timer(ControlTower_Hint_SecureMode, nil, 1)
		
	end
	
end





function ControlTower_PlayerCapturing()
	
	local eid = EGroup_GetSpawnedEntityAt(eg_point_airfield, 1)
	if Player_GetStrategicPointCaptureProgress(player1, eid) >= -0.9 then
		
		local data = {
			area = mkr_controltower_zone,
			spawnloc = mkr_controltower_spawn01,
			units = {
				{sbp = SBP.GERMAN.PANZER_IV_SQUAD, spawn = mkr_controltower_spawn01},
				{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222, spawn = mkr_controltower_spawn02, upgrades = UPG.GERMAN.SDKFZ_222_20MM_GUN},
				{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222, spawn = mkr_controltower_spawn03, upgrades = UPG.GERMAN.SDKFZ_222_20MM_GUN},
			},
		}
		Aircraft_CreateExtraEncounter(data)
		
	else
		
		Event_Timer(ControlTower_PlayerCapturing, nil, 3)
		
	end
	
end



function ControlTower_Safety_VetUpPlayersLastTank()
	
	-- check to see if all player 1's vehicles have no veterancy
	Player_GetAll(player1)
	SGroup_Filter(sg_allsquads, {SBP.SOVIET.KV_1, SBP.SOVIET.KV_2, SBP.SOVIET.KV_8, SBP.SOVIET.T_34_76_SQUAD, SBP.SOVIET.T_70M}, FILTER_KEEP)
	
	if SGroup_CountSpawned(sg_allsquads) >= 1 then
		
		local _CheckSquad = function(gid, idx, sid)
			return Squad_GetVeterancyRank(sid) == 0
		end
		
		-- if they all have no veterancy, give level one to ONE random vehicle.
		if SGroup_ForEachAllOrAnyEx(sg_allsquads, ALL, _CheckSquad, true, false) then
			
			Squad_IncreaseVeterancyRank(SGroup_GetRandomSpawnedSquad(sg_allsquads), 1, true)
			
		end
		
	end
	
end
