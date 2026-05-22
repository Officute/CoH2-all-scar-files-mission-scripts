function Civilian_Initialize()

	t_spawners = { mkr_prisoner_spawner01, mkr_prisoner_spawner02 };
	t_destinations = 
	{
		mkr_prison01, mkr_prison02, mkr_prison03, mkr_prison04,
		mkr_prison05, mkr_prison06, mkr_prison07, mkr_prison08,
		mkr_prison09, mkr_prison10, mkr_prison11, mkr_prison12
	};

	sg_prisoner1 = SGroup_CreateIfNotFound("sg_prisoner1");
	sg_prisoner2 = SGroup_CreateIfNotFound("sg_prisoner2");
	sg_prisoner3 = SGroup_CreateIfNotFound("sg_prisoner3");
	sg_prisoner4 = SGroup_CreateIfNotFound("sg_prisoner4");
	sg_prisoner5 = SGroup_CreateIfNotFound("sg_prisoner5");
	
	t_prisoners = { sg_prisoner1, sg_prisoner2, sg_prisoner3, sg_prisoner4, sg_prisoner5 };
	
	sg_executionee = SGroup_CreateIfNotFound("sg_executionee");
	
	Util_CreateSquads(player2, sg_prisoner1, BP_GetSquadBlueprint("partisans_rifle_mp"), t_spawners[World_GetRand(1, #t_spawners)], nil, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player2, sg_prisoner2, BP_GetSquadBlueprint("partisans_rifle_mp"), t_spawners[World_GetRand(1, #t_spawners)], nil, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player2, sg_prisoner3, BP_GetSquadBlueprint("partisans_rifle_mp"), t_spawners[World_GetRand(1, #t_spawners)], nil, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player2, sg_prisoner4, BP_GetSquadBlueprint("partisans_rifle_mp"), t_spawners[World_GetRand(1, #t_spawners)], nil, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player2, sg_prisoner5, BP_GetSquadBlueprint("partisans_rifle_mp"), t_spawners[World_GetRand(1, #t_spawners)], nil, 1, nil, false, nil, nil, nil);
	
	SGroup_SetWorldOwned(sg_prisoner1);
	SGroup_SetWorldOwned(sg_prisoner2);
	SGroup_SetWorldOwned(sg_prisoner3);
	SGroup_SetWorldOwned(sg_prisoner4);
	SGroup_SetWorldOwned(sg_prisoner5);
	
	SGroup_SetWeaponState(sg_prisoner1, false);
	SGroup_SetWeaponState(sg_prisoner2, false);
	SGroup_SetWeaponState(sg_prisoner3, false);
	SGroup_SetWeaponState(sg_prisoner4, false);
	SGroup_SetWeaponState(sg_prisoner5, false);
	
	SGroup_DisableUI(sg_prisoner1);
	SGroup_DisableUI(sg_prisoner2);
	SGroup_DisableUI(sg_prisoner3);
	SGroup_DisableUI(sg_prisoner4);
	SGroup_DisableUI(sg_prisoner5);
	
	c_freed = false;
	
	c_currentPOW = 0;
	
	Rule_AddInterval(Civilian_PrisonerUpdate, 7);
	Rule_AddInterval(Civilian_ExecutionUpdate, 6 * 60);
	
end

function Civilian_PrisonerUpdate()
	if (c_freed == false) then
		for i=1, #t_prisoners do
			local rand = World_GetRand(1, 10);
			if (rand <= 6) then
				if (SGroup_IsMoving(t_prisoners[i], ANY) == false) then
					Cmd_Move(t_prisoners[i], t_destinations[World_GetRand(1, #t_destinations)]);
				end
			end
		end
	end
end

function Civilian_PrisonerFree()

	c_freed = true;

	for i=1, #t_prisoners do
		SGroup_SetPlayerOwner(t_prisoners[i], player1);
		SGroup_DisableUI(t_prisoners[i], true, false);
	end
	
end

function Civilian_CheckFreedom()
	if (EGroup_Count(eg_gates) < 2) then
		Civilian_PrisonerFree();
		Objective_Complete(OBJ_PRISONERS, true);
		Rule_RemoveMe();
	end
end

function Civilian_ExecutionUpdate()
	if (Objective_IsComplete(OBJ_EXECUTIONS)) then
		Rule_RemoveMe();
	elseif (c_currentPOW >= t_difficulty.maxex) then
		Objective_Fail(OBJ_EXECUTIONS, true);
		Rule_RemoveMe();
	else
		if (SGroup_Count(sg_execution_units) > 0) then
			Civilian_SpawnPOW();
			if (Objective_IsComplete(OBJ_CAPRADIO) == true) then
				Util_StartIntel(EVENTS.POWINCOMING);
			end
		else
			Objective_Complete(OBJ_EXECUTIONS, true);
		end
	end
end

function Civilian_SpawnPOW()
	
	local sg_transport = SGroup_CreateIfNotFound("sg_transport");
	Util_CreateSquads(player3, sg_transport, BP_GetSquadBlueprint("sdkfz_251_halftrack_squad_mp"), mkr_convoy_exit2, nil, 1, nil, false, nil, nil, nil);
	Util_CreateSquads(player3, sg_executionee, BP_GetSquadBlueprint("partisans_rifle_mp"), sg_transport, nil, 1, nil, false, nil, nil, nil);
	Modify_Vulnerability(sg_executionee, 10.0);
	Cmd_SquadPath(sg_transport, "ex_in", true, LOOP_NORMAL, false, 1, nil, true, true);
	Cmd_EjectOccupants(sg_transport, mkr_partisan_execution02, true); 
	Cmd_SquadPath(sg_transport, "ex_out", true, LOOP_NORMAL, false, 1, nil, true, true);
	
	Event_Proximity(Civilian_DoExecution, nil, sg_executionee, mkr_partisan_execution02, 1, ANY, 0);
	
end

function Civilian_DoExecution()
	Cmd_Move(SGroup_FromSquad(SGroup_GetSpawnedSquadAt(sg_execution_units, 1)), mkr_german_execution01);
	Cmd_Move(SGroup_FromSquad(SGroup_GetSpawnedSquadAt(sg_execution_units, 2)), mkr_german_execution02);
	Event_Proximity(Civilian_ExecuteExecution, nil, sg_execution_units, mkr_partisan_execution02, 2, ANY, 0);
end

function Civilian_ExecuteExecution()
	SGroup_SetPlayerOwner(sg_executionee, player2);
	Rule_Add(Civilian_ExecutionDone);
end

function Civilian_ExecutionDone()
	if (SGroup_Count(sg_executionee) == 0) then
		c_currentPOW = c_currentPOW+1;
		Cmd_Move(sg_execution_units, mkr_execution_standby);
		Rule_RemoveMe();
	end
end
