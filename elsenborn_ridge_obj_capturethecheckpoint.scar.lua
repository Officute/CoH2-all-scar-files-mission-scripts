print("\tLoading ObjSecureTheFlank file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Elsenborn Ridge
-- Objective File - Capture the Checkpoint
-- Designer: Ryan McGechaen
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_ObjCaptureTheCheckpoint()
	print("Initializing OBJ_CaptureTheCheckpoint...")
	
	-- Pre-condition:		<What are the conditions before the objective starts?>
	-- Success condition:	<What conditions complete the objective?>
	-- Failure condition:	<What conditions fail the objective?>
	-- Post-condition:
	--		Success:		<What happens if the objective is completed?>
	--		Failure:		<What happens if the objective is failed?>
	OBJ_CaptureTheCheckpoint = {
		--Info
		Title = 11076642,	-- LOCDB [11076642] 'Capture the checkpoint to receive reinforcements'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Secondary,
		Parent = nil,
		subObjectives = {},
		--Intel
		Intel_Start = 				EVENTS.CaptureTheCheckpoint_Start,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			EVENTS.CaptureTheCheckpoint_Complete,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				nil,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = function()
			hpid_OBJ_CaptureTheCheckpoint = Objective_AddUIElements(OBJ_CaptureTheCheckpoint, eg_checkpoint, true, 11076642, true, 4.0)
		end,
		PreStart = function()
			CaptureTheCheckpoint_Init()
		end,
		OnStart = function()
			World_IncreaseInteractionStage()
			
			sg_a_truck_01 = SGroup_CreateIfNotFound("sg_a_truck_01")
			sg_a_truck_02 = SGroup_CreateIfNotFound("sg_a_truck_02")
			sg_a_rein_01 = SGroup_CreateIfNotFound("sg_a_rein_01")
			sg_a_rein_02 = SGroup_CreateIfNotFound("sg_a_rein_02")
			
			g_firstAttention = false
			g_secondAttention = false
			g_allSpawned = false
		end,
		IsComplete = function()
			return Player_OwnsEGroup(player1, eg_checkpoint)
		end,
		PreComplete = nil,
		OnComplete = function()
			Rule_AddOneShot(Reinforcements_Spawn_01, 20)
			Rule_AddOneShot(Reinforcements_Spawn_02, 35)
			-- Logic for closing wave defense encounters
		end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = function() 
			
		end,
	}
	
end
Scar_AddInit(INIT_ObjCaptureTheCheckpoint)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------

-- This is where any supplemental functions should be written.
-- If any of the objective functions are too big/complex, they should be defined here.
function CaptureTheCheckpoint_Init()
	-- Initialize Encounters
	ENCOUNTERS.CaptureTheCheckpoint_smlForest()
	ENCOUNTERS.CaptureTheCheckpoint_medForest()
	ENCOUNTERS.CaptureTheCheckpoint_medDefense()
	ENCOUNTERS.CaptureTheCheckpoint_road()
end

function Reinforcements_Spawn_01()
	if Objective_IsComplete(OBJ_HoldTheLine) == false then
		if g_firstAttention == false then
			g_firstAttention = true
			Util_StartIntel(EVENTS.CaptureTheCheckpoint_Reinforcements_01)
		else
			if g_secondAttention == false then
				g_secondAttention = true
				Util_StartIntel(EVENTS.CaptureTheCheckpoint_Reinforcements_02)
			end
		end
		Util_CreateSquads(player3, sg_a_truck_01, SBP.AEF.M3_HALFTRACK_SQUAD_MP, mkr_a_truck_spawn, nil, 1)
		enc_rein_01 = ENCOUNTERS.Allied_Reinforcements_01()
		Cmd_Garrison(sg_a_rein_01, sg_a_truck_01, true, false, true)
		
		Cmd_Move(sg_a_truck_01, mkr_a_truck_wayPoint)
		Cmd_Move(sg_a_truck_01, mkr_a_truck_unload)
		
		eventID_rein_01_unload = Event_Proximity(DoNothing, nil, sg_a_truck_01, mkr_a_truck_unload, 10, ANY)
		eventID_rein_01_truckDead = Event_GroupIsDead(DoNothing, nil, sg_a_truck_01)
		
		Event_CreateOR(_unloadTruck, {_encounterID = enc_rein_01, _sg = sg_a_truck_01}, {eventID_rein_01_unload, eventID_rein_01_truckDead})
		Event_GroupIsDead(_reinDead, {_sg = sg_a_rein_01}, sg_a_rein_01)
	end
end

function Reinforcements_Spawn_02()
	if Objective_IsComplete(OBJ_HoldTheLine) == false then
		if g_allSpawned == false then
			g_allSpawned = true
		else
			if g_secondAttention == false then
				g_secondAttention = true
				Util_StartIntel(EVENTS.CaptureTheCheckpoint_Reinforcements_02)
			end
		end
		Util_CreateSquads(player3, sg_a_truck_02, SBP.AEF.M3_HALFTRACK_SQUAD_MP, mkr_a_truck_spawn, nil, 1)
		enc_rein_02 = ENCOUNTERS.Allied_Reinforcements_02()
		Cmd_Garrison(sg_a_rein_02, sg_a_truck_02, true, false, true)
		
		Cmd_Move(sg_a_truck_02, mkr_a_truck_wayPoint)
		Cmd_Move(sg_a_truck_02, mkr_a_truck_unload)
		
		eventID_rein_02_unload = Event_Proximity(DoNothing, nil, sg_a_truck_02, mkr_a_truck_unload, 10, ANY)
		eventID_rein_02_truckDead = Event_GroupIsDead(DoNothing, nil, sg_a_truck_02)
		
		Event_CreateOR(_unloadTruck, {_encounterID = enc_rein_02, _sg = sg_a_truck_02}, {eventID_rein_02_unload, eventID_rein_02_truckDead})
		Event_GroupIsDead(_reinDead, {_sg = sg_a_rein_02}, sg_a_rein_02)
	end
end

function _unloadTruck(data)
	local encounterID = data._encounterID
	local sg = data._sg
	
	if SGroup_IsEmpty(sg) == false then
	
		Cmd_EjectOccupants(sg)
		Event_Timer(_truckReturn, {_sg = sg}, 8)
		
	else
		-- tells unloaded allies to move to the front line if the truck died
		if sg == sg_a_truck_01 and  SGroup_IsAlive(sg_a_rein_01) == true then
			Cmd_AttackMove(sg_a_rein_01, mkr_startingUnit_03, true)

		elseif sg == sg_a_truck_02 and SGroup_IsAlive(sg_a_rein_02) == true then
			Cmd_AttackMove(sg_a_rein_02, mkr_startingUnit_04, true)

		end
	end
	encounterID:Enable()
	
end



function _reinDead(data)
	local sg = data._sg
	
	if sg == sg_a_rein_01 then
		Event_Timer(Reinforcements_Spawn_01, nil, 60)
	elseif sg == sg_a_rein_02 then
		Event_Timer(Reinforcements_Spawn_02, nil, 60)
	end
end

function _truckReturn(data)
	local sg = data._sg
	if SGroup_IsAlive(sg) then 
		Cmd_Move(sg, mkr_a_truck_wayPoint)
		Cmd_MoveToAndDespawn(sg, mkr_a_truck_despawn)
	end
	
	if sg == sg_a_truck_01 and  SGroup_IsAlive(sg_a_rein_01) == true then
		Cmd_Move(sg_a_rein_01, mkr_startingUnit_03, true)

	elseif sg == sg_a_truck_02 and SGroup_IsAlive(sg_a_rein_02) == true then
		Cmd_Move(sg_a_rein_02, mkr_startingUnit_04, true)

	end
end

function DoNothing()
end




