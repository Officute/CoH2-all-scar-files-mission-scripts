function Soviet_Initialize()
	
	soviet1 = player3;
	soviet2 = player4;
	
	--AI_Enable(soviet2, true); 
	
	Soviet_DisableLights();
	
	-- Global Variables
	SOV_ENGINEER = BP_GetSquadBlueprint("combat_engineer_squad_mp");
	SOV_CONSCRIPT = BP_GetSquadBlueprint("conscript_squad_mp");
	SOV_T34 = BP_GetSquadBlueprint("t_34_85_squad_mp");
	SOV_IS2 = BP_GetSquadBlueprint("is-2_mp");
	SOV_ISU152 = BP_GetSquadBlueprint("isu-152_mp");
	SOV_SHOCK = BP_GetSquadBlueprint("shock_troops_mp");
	SOV_PENAL = BP_GetSquadBlueprint("penal_battalion_mp");
	SOV_SU76 = BP_GetSquadBlueprint("su-76m_mp");
	SOV_OFFICER = BP_GetSquadBlueprint("commissar_squad_mp");
	SOV_SNIPER = BP_GetSquadBlueprint("sniper_team_mp");
	
	SOV_RECON = BP_GetAbilityBlueprint("il-2_recon");
	SOV_ANTITANK = BP_GetAbilityBlueprint("il-2_anti_tank_bomb_strike");
	SOV_BOMBINGRUN = BP_GetAbilityBlueprint("il-2_precision_bomb_strike");
	SOV_STURMOVIK = BP_GetAbilityBlueprint("il-2_sturmovik_attack");
	SOV_SUPPORT = BP_GetAbilityBlueprint("il-2_support");
	
	SOVIET_TOTALBROKENTHROUGH = 0;
	
	S_South_Enabled = false;
	S_Center_Enabled = true;
	S_North_Enabled = false;
	
	S_Demand_Artillery = DEMAND_NONE;
	S_Demand_Air_Strafe = DEMAND_NONE;
	--S_Demand_Bombing_Run = DEMAND_NONE;
	S_Demand_IS2 = DEMAND_NONE;
	S_Demand_ISU152 = DEMAND_NONE;
	S_Demand_Oorah = DEMAND_NONE;
	S_Demand_Commissar = DEMAND_NONE;
	S_Demand_Tank = DEMAND_NONE;
	S_Demand_Special = DEMAND_NONE;
	S_Demnad_OffMapArtillery = DEMAND_NONE;
	S_Demand_PropagandaArtillery = DEMAND_NONE;
	
	LAG_MAX_CENTER = 16;
	LAG_MAX_SOUTH = 6;
	LAG_MAX_NORTH = 6;
	LAG_MAX_TANKS = 5;
	
	-- SGroups
	sg_mineclear = SGroup_CreateIfNotFound("sg_mineclear");
	sg_attack_north = SGroup_CreateIfNotFound("sg_attack_north");
	sg_attack_center = SGroup_CreateIfNotFound("sg_attack_center");
	sg_attack_south = SGroup_CreateIfNotFound("sg_attack_south");
	sg_commissar = SGroup_CreateIfNotFound("sg_commissar");
	sg_commissar_support = SGroup_CreateIfNotFound("sg_commissar_support");
	sg_special_support = SGroup_CreateIfNotFound("sg_special_support");
	sg_tanks = SGroup_CreateIfNotFound("sg_tanks");
	sg_isu152 = SGroup_CreateIfNotFound("sg_isu152");
	sg_is2 = SGroup_CreateIfNotFound("sg_is2");
	
	-- Tables
	t_spawnpositions = {mkr_enemy_spawner01, mkr_enemy_spawner02, mkr_enemy_spawner03, mkr_enemy_spawner04, mkr_enemy_spawner05, mkr_enemy_spawner06, mkr_enemy_spawner07, mkr_enemy_spawner08};
	t_destnations = 
	{
		mkr_attack_destination01, mkr_attack_destination02, mkr_attack_destination03, mkr_attack_destination04,
		mkr_attack_destination05, mkr_attack_destination06, mkr_attack_destination07, mkr_attack_destination08
	};
	
	t_priority_targets = {};
	t_random_targets = t_destnations;
	t_forcemove = {};
	t_randomendspawn = {mkr_soviet_despawn01, mkr_soviet_despawn02, mkr_soviet_despawn03};
	t_isu152_markers =
	{
		{marker = mkr_isu152_moveto01, occupied = false},
		{marker = mkr_isu152_moveto02, occupied = false},
		{marker = mkr_isu152_moveto03, occupied = false},
		{marker = mkr_isu152_moveto04, occupied = false},
		{marker = mkr_isu152_moveto05, occupied = false}
	};
	
	-- Add abilities
	Player_AddAbility(player3, BP_GetAbilityBlueprint("flare_artillery"));
	Player_AddAbility(player3, BP_GetAbilityBlueprint("fear_propaganda_artillery"));
	Player_AddAbility(player3, SOV_RECON);
	Player_AddAbility(player3, SOV_ANTITANK);
	Player_AddAbility(player3, SOV_BOMBINGRUN);
	Player_AddAbility(player3, SOV_STURMOVIK);
	Player_AddAbility(player3, SOV_SUPPORT);
	
	-- Apply Modifiers
	Modify_AbilityMaxCastRange(player3, BP_GetAbilityBlueprint("kaytusha_rocket_truck_barrage_mp"), 5.0);
	
	Modify_PlayerResourceRate(soviet2, RT_Manpower, 1.15, MUT_Multiplication);
	Modify_PlayerResourceRate(soviet2, RT_Fuel, 1.15, MUT_Multiplication);
	Modify_PlayerResourceRate(soviet2, RT_Munition, 1.25, MUT_Multiplication);
	
	Player_SetResource(soviet2, RT_Manpower, 0);
	Player_SetResource(soviet2, RT_Fuel, 0);
	Player_SetResource(soviet2, RT_Munition, 0);
	
	-- Event ID's
	EVENT_SOVIET_OFFICERSPOTTED = nil;
	
end

function Soviet_Oorah(target) -- spawn in a commissar and random amount of conscript squads and charges a random front-line in case target is nil

	if (SGroup_Count(sg_commissar) == 0) then

		Soviet_SpawnSquadsWithTask(sg_commissar, 1, nil, SOV_OFFICER, Soviet_GetRandomTarget(), nil, false, false, nil);
		Soviet_SpawnSquadsWithTask(sg_commissar_support, 2, BP_GetUpgradeBlueprint("ppsh-41_sub_machine_gun_upgrade_mp"), SOV_CONSCRIPT, Soviet_GetRandomTarget(), nil, true, false, nil);
		
		--IF (EVENT_SOVIET_OFFICERSPOTTED ~= nil) then
		--	Event_Remove(EVENT_SOVIET_OFFICERSPOTTED); 
		--END
		
		--table.insert(t_forcemove, sg_commissar);
		--table.insert(t_forcemove, sg_commissar_support);
		
		--EVENT_SOVIET_OFFICERSPOTTED = Event_PlayerCanSeeElement(Soviet_PlayerInteraction_OfficerSpotted, nil, player1, sg_commissar, ANY, 2); 
		
	end
	
	Cmd_Ability(sg_attack_north, BP_GetAbilityBlueprint("conscript_oorah_mp"), nil, nil, true, false);
	Cmd_Ability(sg_attack_center, BP_GetAbilityBlueprint("conscript_oorah_mp"), nil, nil, true, false);
	Cmd_Ability(sg_attack_south, BP_GetAbilityBlueprint("conscript_oorah_mp"), nil, nil, true, false);
	
	S_Demand_Commissar = DEMAND_NONE;
	
end

function Soviet_Special()

	if (SGroup_Count(sg_special_support) < 2) then

		local t_specials = {SOV_ENGINEER, SOV_SNIPER, SOV_PENAL, SOV_SHOCK};
		Soviet_SpawnSquadsWithTask(sg_special_support, 2, nil, t_specials[World_GetRand(1, #t_specials)], Soviet_GetRandomTarget(), nil, false, false, nil);
		
		S_Demand_Special = DEMAND_NONE;
		
	else
		S_Demand_Special = S_Demand_Special + 1;
	end
	
end

function Soviet_CallTank()

	if (SGroup_Count(sg_tanks) < LAG_MAX_TANKS) then
		local amount = LAG_MAX_TANKS - SGroup_Count(sg_tanks);
		if (amount >= 2) then
			amount = World_GetRand(1, amount);
		end
		Soviet_SpawnSquadsWithTask(sg_tanks, amount, nil, SOV_T34, {mkr_attack_destination03, mkr_attack_destination04, mkr_attack_destination05, mkr_attack_destination06}, nil, true, false, nil, true);
		local rand = World_GetRand(0, 100);
		if (rand >= DEMAND_HIGH) then
			Soviet_SpawnSquadsWithTask(sg_tanks, 1, nil, SOV_SU76, {mkr_attack_destination03, mkr_attack_destination04, mkr_attack_destination05, mkr_attack_destination06}, nil, true, false, nil, true);
		end
		S_Demand_Tank = DEMAND_NONE;
	end

end

function Soviet_DoBarrage()

	local t_middle = {mkr_center_trench01, mkr_center_trench02, mkr_center_trench03, mkr_center_trench04};

	Cmd_Ability(sg_katyusha_north, BP_GetAbilityBlueprint("kaytusha_rocket_truck_barrage_mp"), mkr_north_trench, nil, true, false);
	Cmd_Ability(sg_katyusha_south, BP_GetAbilityBlueprint("kaytusha_rocket_truck_barrage_mp"), mkr_southern_trench, nil, true, false);
	Cmd_Ability(sg_katyusha_center, BP_GetAbilityBlueprint("kaytusha_rocket_truck_barrage_mp"), t_middle[World_GetRand(1, #t_middle)], nil, true, false);
	
end

function Soviet_DoKatyushaBarrage()

	if (SGroup_Count(sg_katyusha_north) > 0) then
		Cmd_Ability(sg_katyusha_north, BP_GetAbilityBlueprint("kaytusha_rocket_truck_barrage_mp"), Soviet_GetPriorityMarker(), nil, true, false);
	end
	
	if (SGroup_Count(sg_katyusha_south) > 0) then
		Cmd_Ability(sg_katyusha_south, BP_GetAbilityBlueprint("kaytusha_rocket_truck_barrage_mp"), Soviet_GetPriorityMarker(), nil, true, false);
	end
	
	if (SGroup_Count(sg_katyusha_center) > 0) then
		Cmd_Ability(sg_katyusha_center, BP_GetAbilityBlueprint("kaytusha_rocket_truck_barrage_mp"), Soviet_GetPriorityMarker(), nil, true, false);
	end

	S_Demand_Artillery = DEMAND_NONE;
	
end

function Soviet_DoFlares()

	if (g_time.current == TIME_NIGHT) then

		Cmd_Ability(player3, BP_GetAbilityBlueprint("flare_artillery"), mkr_center_trench01, nil, true, false);
		Cmd_Ability(player3, BP_GetAbilityBlueprint("flare_artillery"), mkr_center_trench02, nil, true, false);
		Cmd_Ability(player3, BP_GetAbilityBlueprint("flare_artillery"), mkr_center_trench03, nil, true, false);
		Cmd_Ability(player3, BP_GetAbilityBlueprint("flare_artillery"), mkr_center_trench04, nil, true, false);
		
		Cmd_Ability(player3, BP_GetAbilityBlueprint("flare_artillery"), mkr_north_trench, nil, true, false);
		Cmd_Ability(player3, BP_GetAbilityBlueprint("flare_artillery"), mkr_southern_trench, nil, true, false);

	end
	
end

function Soviet_DoAirRaid()

	local abilities = {SOV_RECON, SOV_ANTITANK,	SOV_BOMBINGRUN,	SOV_STURMOVIK, SOV_SUPPORT};
	local events = {EVENTS.PLANE01, EVENTS.PLANE02, EVENTS.PLANE03, EVENTS.PLANE04};

	if (g_time.current == TIME_DAY) then
		
		local pos = Soviet_GetPriorityMarker();
	
		if (pos == nil) then
			pos = Soviet_GetRandomMarker();
		end
	
		Cmd_Ability(player3, abilities[World_GetRand(1, #abilities)], pos, nil, true, false);
		Util_StartIntel(events[World_GetRand(1, #events)]);
		
	end
	
	S_Demand_Air_Strafe = DEMAND_NONE;

end

function Soviet_DoPropaganda()

	local pos = Soviet_GetPriorityMarker();
	
	if (pos == nil) then
		pos = Soviet_GetRandomMarker();
	end
	
	Cmd_Ability(player3, BP_GetAbilityBlueprint("fear_propaganda_artillery"), pos, nil, true, false);
	
	S_Demand_PropagandaArtillery = DEMAND_NONE;

end

function Soviet_IS2()

	if (SGroup_Count(sg_tanks) < LAG_MAX_TANKS) then
		Soviet_SpawnSquadsWithTask(sg_is2, 2, nil, SOV_IS2, {mkr_attack_destination03, mkr_attack_destination04, mkr_attack_destination05, mkr_attack_destination06}, nil, true, false, nil, true);
		SGroup_AddGroup(sg_tanks, sg_is2);
	end

	Soviet_SpawnSquadsWithTask(sg_commissar_support, 3, BP_GetUpgradeBlueprint("ppsh-41_sub_machine_gun_upgrade_mp"), SOV_CONSCRIPT, Soviet_GetRandomTarget(), nil, true, false, nil);
	
	S_Demand_IS2 = DEMAND_NONE;

end

function Soviet_ISU152()

	local pos = Soviet_GetISUMarker()
	if (pos == nil) then
		return;
	else
		Soviet_SpawnSquadsWithTask(sg_isu152, 1, nil, SOV_ISU152, pos, nil, false, false, nil, true);
		S_Demand_IS2 = DEMAND_NONE;
	end
	
end

function Soviet_EnableLights()

	for i=1, EGroup_Count(eg_soviet_lights) do
		Entity_SetAnimatorState(EGroup_GetSpawnedEntityAt(eg_soviet_lights, i), "Light_State", "On");
		Entity_SetAnimatorVariable(EGroup_GetSpawnedEntityAt(eg_soviet_lights, i), "Hinge", 0.0);
	end
	
end

function Soviet_DisableLights()

	for i=1, EGroup_Count(eg_soviet_lights) do
		Entity_SetAnimatorState(EGroup_GetSpawnedEntityAt(eg_soviet_lights, i), "Light_State", "Off");
		Entity_SetAnimatorVariable(EGroup_GetSpawnedEntityAt(eg_soviet_lights, i), "Hinge", 0.0);
	end

end

function Soviet_ClearMines()
	Soviet_SpawnSquadsWithTask(sg_mineclear, 3, BP_GetUpgradeBlueprint("engineer_minesweeper_mp"), SOV_ENGINEER, {mkr_nomansland01, mkr_nomansland02, mkr_nomansland03}, nil, false, false);
end

function Soviet_GetRandomSpawnPosition()
	return t_spawnpositions[World_GetRand(1, #t_spawnpositions)];
end

function Soviet_SpawnSquadsWithTask(sgroup, amount, upgrade, blueprint, target, soviet, randomtarget, follow, fixedspawn, attackmove)

	if (soviet == nil) then
		soviet = soviet1;
	end

	local targetcounter = 1;
	
	for i=1, amount do

		local sg_temp = SGroup_CreateIfNotFound("sg_soviettask"..i);
		
		local dest = target;
		local spawnpos = Soviet_GetRandomSpawnPosition();
		local dest_target = nil;
		local dest_path = nil;
	
		if (scartype(target) == ST_TABLE) then
			if (#target == amount) then
				dest = target[i];
			else
				if (randomtarget == true) then
					dest = target[World_GetRand(1, #target)];
				else
					dest = target[targetcounter];
					targetcounter = targetcounter + 1;
					if (targetcounter > #target) then
						targetcounter = 1;
					end
				end
			end
		elseif (target == nil) then
			dest = t_destnations[World_GetRand(1, #t_destnations)];
		elseif (scartype(target) == ST_SGROUP or scartype(target) == ST_EGROUP) then
			dest = nil;
			dest_target = target;
		elseif (scartype(target) == ST_STRING) then
			dest = nil;
			dest_path = target;
		elseif (scartype(target) == ST_MARKER) then
			dest = target;
		end
		
		if (fixedspawn ~= nil) then
			spawnpos = fixedspawn;
		end
		
		if (attackmove == nil) then
			attackmove = false;
		end
		
		Util_CreateSquads(soviet, sg_temp, blueprint, spawnpos, dest, 1, nil, attackmove, nil, nil, nil);
		
		Modify_SquadCaptureRate(sg_temp, 5); 
		
		SGroup_EnableUIDecorator(sg_temp, false); 
		
		if (dest == nil) then
			if (dest_target ~= nil) then
				if (follow == false) then
					Cmd_Attack(sg_temp, dest_target, false, false, nil);
				else
					Cmd_Follow(sg_temp, dest_target);
				end
			else
				Cmd_SquadPath(sg_temp, dest_path, true, LOOP_NONE, true, 0, Util_GetDespawnerFromPath(dest_path), false, true);
			end
		end
		
		if (upgrade ~= nil) then
			if (scartype(upgrade) == ST_TABLE) then
				Cmd_InstantUpgrade(sg_temp, upgrade[World_GetRand(1, #upgrade)], 1);
			else
				Cmd_InstantUpgrade(sg_temp, upgrade, 1);
			end
		end
		
		if (dest_path == nil) then
			local rand = World_GetRand(0, 100);
			if (rand > 50) then
				Cmd_MoveToAndDespawn(sg_temp, t_randomendspawn[World_GetRand(1, #t_randomendspawn)], true);
			else
				Cmd_AttackMoveThenCapture(sg_temp, eg_munition_point, true); 
			end
		end
		
		SGroup_AddGroup(sgroup, sg_temp);
		SGroup_Clear(sg_temp);
		
	end
	
end

function Soviet_BeginAttacks()

	sg_tank01 = SGroup_CreateIfNotFound("sg_soviet_tank01");
	sg_tank02 = SGroup_CreateIfNotFound("sg_soviet_tank02");
	sg_tank03 = SGroup_CreateIfNotFound("sg_soviet_tank03");
	
	Soviet_SpawnSquadsWithTask(sg_tank01, 1, nil, SOV_T34, mkr_attack_destination03, nil, false, false, mkr_enemy_spawner01);
	Soviet_SpawnSquadsWithTask(sg_tank02, 1, nil, SOV_T34, mkr_attack_destination04, nil, false, false, mkr_enemy_spawner02);
	Soviet_SpawnSquadsWithTask(sg_tank03, 1, nil, SOV_T34, mkr_attack_destination05, nil, false, false, mkr_enemy_spawner03);
	
	Modify_UnitSpeed(sg_tank01, 0.4);
	Modify_UnitSpeed(sg_tank02, 0.4);
	Modify_UnitSpeed(sg_tank03, 0.4);
	
	Soviet_SpawnSquadsWithTask(sg_attack_center, 2, nil, SOV_CONSCRIPT, mkr_attack_destination03, nil, false, false, mkr_enemy_spawner01);
	Soviet_SpawnSquadsWithTask(sg_attack_center, 2, nil, SOV_CONSCRIPT, mkr_attack_destination04, nil, false, false, mkr_enemy_spawner02);
	Soviet_SpawnSquadsWithTask(sg_attack_center, 2, nil, SOV_CONSCRIPT, mkr_attack_destination05, nil, false, false, mkr_enemy_spawner03);

	Rule_AddDelayedInterval(Soviet_Update, 60, 10);
	Rule_AddDelayedInterval(Soviet_DoFlares, 120, 120);
	
end

function Soviet_Update()

	if (S_Center_Enabled) then
		if (SGroup_Count(sg_attack_center) < LAG_MAX_CENTER) then
			Soviet_SpawnSquadsWithTask(sg_attack_center, 1, nil, SOV_CONSCRIPT, {mkr_attack_destination03, mkr_attack_destination04, mkr_attack_destination05, mkr_attack_destination06}, nil, true, false, nil);
			S_Demand_Special = S_Demand_Special + t_difficulty.special_increment;
		end
	end

	if (S_North_Enabled) then
		if (SGroup_Count(sg_attack_north) < LAG_MAX_NORTH) then
			Soviet_SpawnSquadsWithTask(sg_attack_north, 1, nil, SOV_CONSCRIPT, {mkr_attack_destination06, mkr_attack_destination07, mkr_attack_destination08}, nil, true, false, nil);
			S_Demand_Special = S_Demand_Special + t_difficulty.special_increment;
		end
	end
	
	if (S_South_Enabled) then
		if (SGroup_Count(sg_attack_south) < LAG_MAX_SOUTH) then
			Soviet_SpawnSquadsWithTask(sg_attack_south, 1, nil, SOV_CONSCRIPT, {mkr_attack_destination03, mkr_attack_destination02, mkr_attack_destination01}, nil, true, false, nil);
			S_Demand_Special = S_Demand_Special + t_difficulty.special_increment;
		end
	end
	
	Soviet_ForceMove();
	Soviet_UpdateTargets();
	Soviet_HandleDemands();
	Soviet_DoCleanup();
	
end

function Soviet_ForceMove()
	if (#t_forcemove > 0) then
		local RemoveAt = nil;
		for i=1, #t_forcemove do
			if (SGroup_IsMoving(t_forcemove[i]) == false) then
				SGroup_WarpToMarker(t_forcemove[i], mkr_commandmovewarp);
				Cmd_Move(t_forcemove[i], Soviet_GetRandomTarget());
			elseif (SGroup_Count(t_forcemove[i]) == 0) then
				RemoveAt = i;
			end
		end
		if (RemoveAt ~= nil) then
			table.remove(t_forcemove, RemoveAt);
		end
	end
end

function Soviet_UpdateTargets()

	local RemoveAt = nil;

	if (#t_priority_targets > 0) then
		for i=1, #t_priority_targets do
			if (t_priority_targets[i].type ~= ST_MARKER) then -- sgroup
				if (SGroup_Count(t_priority_targets[i].object) == 0) then
					RemoveAt = i;
				else
					t_priority_targets[i].importance = t_priority_targets[i].importance + 1;
				end
			end -- it was a marker - don't remove it
		end
	end

	if (RemoveAt ~= nil) then
		table.remove(t_priority_targets, RemoveAt);
	end
	
	if (#t_priority_targets < 15) then -- have a maximum of 14 high priority targets so we don't waste memory on units we won't be bothering with
		
		sg_temp_attacker = SGroup_CreateIfNotFound("sg_temp_attacker");
		if (SGroup_Count(sg_attack_center) > 0) then
			SGroup_GetLastAttacker(sg_attack_center, sg_temp_attacker, 1);
			if (SGroup_Count(sg_temp_attacker) > 0) then
				local sg_temp = SGroup_CreateIfNotFound("object"..#t_priority_targets);
				SGroup_AddGroup(sg_temp, sg_temp_attacker);
				table.insert(t_priority_targets, {type = ST_SGROUP, object = sg_temp, importance = 0});
				S_Demand_PropagandaArtillery = S_Demand_PropagandaArtillery + 1;
			end
			SGroup_Clear(sg_temp_attacker);
		end
		if (SGroup_Count(sg_attack_north) > 0) then
			SGroup_GetLastAttacker(sg_attack_north, sg_temp_attacker, 1);
			if (SGroup_Count(sg_temp_attacker) > 0) then
				local sg_temp = SGroup_CreateIfNotFound("object"..#t_priority_targets);
				SGroup_AddGroup(sg_temp, sg_temp_attacker);
				table.insert(t_priority_targets, {type = ST_SGROUP, object = sg_temp, importance = 0});
				S_Demand_PropagandaArtillery = S_Demand_PropagandaArtillery + 1;
			end
			SGroup_Clear(sg_temp_attacker);
		end
		if (SGroup_Count(sg_attack_south) > 0) then
			SGroup_GetLastAttacker(sg_attack_south, sg_temp_attacker, 1);
			if (SGroup_Count(sg_temp_attacker) > 0) then
				local sg_temp = SGroup_CreateIfNotFound("object"..#t_priority_targets);
				SGroup_AddGroup(sg_temp, sg_temp_attacker);
				table.insert(t_priority_targets, {type = ST_SGROUP, object = sg_temp, importance = 0});
				S_Demand_PropagandaArtillery = S_Demand_PropagandaArtillery + 1
			end
			SGroup_Clear(sg_temp_attacker);
		end
		
	end
	
end

function Soviet_HandleDemands()

	if (S_Demand_Commissar >= DEMAND_HIGH) then
		if (#t_priority_targets >= 2) then
			Soviet_Oorah(Soviet_GetPriorityTarget());
		else
			Soviet_Oorah(Soviet_GetRandomTarget());
		end
		S_Demand_PropagandaArtillery = S_Demand_PropagandaArtillery + 15;
	else
		S_Demand_Commissar = S_Demand_Commissar + t_difficulty.commissar_increment;
	end

	if (S_Demand_Special >= DEMAND_HIGH) then
		Soviet_Special();
	else
		S_Demand_Special = S_Demand_Special + t_difficulty.special_increment;
	end
	
	if (S_Demand_PropagandaArtillery >= DEMAND_MEDIUM) then
		local rand = World_GetRand(1, 100);
		if (rand >= S_Demand_PropagandaArtillery or S_Demand_PropagandaArtillery == DEMAND_FORCE) then
			Soviet_DoPropaganda();
		else
			S_Demand_PropagandaArtillery = S_Demand_PropagandaArtillery + 20; -- We want to do it very soon then
		end
	elseif (S_Demand_PropagandaArtillery >= DEMAND_HIGH) then
		Soviet_DoPropaganda();
	else
		S_Demand_PropagandaArtillery = S_Demand_PropagandaArtillery + Util_DifVar({1,2,3,3});
	end
	
	if (S_Demand_Tank >= DEMAND_MEDIUM) then
		if (S_Demand_Tank >= DEMAND_HIGH) then
			Soviet_CallTank();
		else
			local rand = World_GetRand(1, 5);
			if (rand >= 4) then
				Soviet_CallTank();
			end
		end
	else
		S_Demand_Tank = S_Demand_Tank + Util_DifVar({5,8,9,9});
	end
	
	if (S_Demand_Air_Strafe >= t_difficulty.airstrafelevel) then
		Soviet_DoAirRaid();
	else
		S_Demand_Air_Strafe = S_Demand_Air_Strafe + Util_DifVar({4,5,6,6});
	end
	
	if (S_Demand_Artillery >= DEMAND_HIGH + 20) then
		Soviet_DoKatyushaBarrage();
	else
		S_Demand_Artillery = S_Demand_Artillery + Util_DifVar({2,3,4,4});
	end
	
	if (S_Demand_IS2 >= DEMAND_HIGH) then
		local rand = World_GetRand(0, 100);
		if (rand >= DEMAND_HIGH) then
			Soviet_IS2();
		end
	else
		S_Demand_IS2 = S_Demand_IS2 + Util_DifVar({1,2,3,3});
	end
	
	if (S_Demand_ISU152 >= DEMAND_FORCE) then
		local rand = World_GetRand(0, 100);
		if (rand >= DEMAND_HIGH) then
			Soviet_ISU152();
		end
	else
		local rand = World_GetRand(0, 100);
		if (rand >= 75) then
			S_Demand_ISU152 = S_Demand_ISU152 + Util_DifVar({1,3,5,5});
		end
	end
	
end

function Soviet_GetRandomTarget()

	local randomplayer = World_GetRand(1, 2);
	
	if (randomplayer == 1) then
		local squad = SGroup_GetSpawnedSquadAt(Player_GetSquads(player1), World_GetRand(1, SGroup_Count(Player_GetSquads(player1))));
		return SGroup_FromSquad(squad);
	else
		local squad = SGroup_GetSpawnedSquadAt(Player_GetSquads(player2), World_GetRand(1, SGroup_Count(Player_GetSquads(player2))));
		return SGroup_FromSquad(squad);
	end

end

function Soviet_GetPriorityTarget()

	local t_canditates = {};
	
	for i=1, #t_priority_targets do
		if (t_priority_targets[i].type ~= ST_MARKER) then
			table.insert(t_canditates, t_priority_targets[i].object);
		end
	end

	if (#t_canditates >= 2) then
		return t_canditates[World_GetRand(1, #t_canditates)];
	else
		return Soviet_GetRandomTarget();
	end
	
end

function Soviet_GetHighestPriorityTarget()
	local current = {importance = -1};
	if (#t_priority_targets > 0) then
		for i=1, #t_priority_targets do
			if (t_priority_targets[i].importance > current.importance) then
				current = t_priority_targets[i];
			end
		end
	end
	return current;
end

function Soviet_GetRandomMarker()
	local rand = World_GetRand(1, 2);
	if (rand == 1) then
		return t_destnations[World_GetRand(1, #t_destnations)];
	else
		return t_random_targets[World_GetRand(1, #t_random_targets)];
	end
end

function Soviet_GetPriorityMarker()
	local priority = Soviet_GetPriorityTarget();
	if (scartype(priority) == ST_SGROUP) then
		if (SGroup_Count(priority) == 0) then
			return Soviet_GetRandomMarker();
		end
	end
	return Util_GetPosition(priority);
end

function Soviet_GetISUMarker()
	for i=1, #t_isu152_markers do
		if (t_isu152_markers[i].occupied == false) then
			t_isu152_markers[i].occupied = true;
			return t_isu152_markers[i].marker;
		end
	end
	S_Demand_ISU152 = (-9999);
	return Soviet_GetRandomMarker();
end

function Soviet_PlayerInteraction_OfficerSpotted()
	Util_StartIntel(EVENTS.COMMISSARSPOTTED);
	if (SGroup_Count(sg_g_german1_sniper) == 0) then
		Util_CreateSquads(german1, sg_g_german1_sniper, BP_GetSquadBlueprint("sniper_squad_mp"), Production_GetRandomSpawn(), mkr_player_unit_dest, 1, nil, false, nil, nil, nil);
	end
	if (SGroup_Count(sg_g_german2_sniper) == 0) then
		Util_CreateSquads(german2, sg_g_german2_sniper, BP_GetSquadBlueprint("sniper_squad_mp"), Production_GetRandomSpawn(), mkr_player_unit_dest, 1, nil, false, nil, nil, nil);
	end
	Rule_AddInterval(Soviet_PlayerInteraction_OfficerDesert, 15);
end

function Soviet_PlayerInteraction_OfficerDesert()
	if (SGroup_Count(sg_commissar) > 0) then
		local pos = Util_GetRandomPosition(SGroup_GetPosition(sg_commissar), 25);
		local squads = SGroup_CreateIfNotFound("sg_commissar_victims");
		World_GetSquadsNearMarker(german1, squads, pos, OT_Player);
		World_GetSquadsNearMarker(german2, squads, pos, OT_Player);
		
		if (SGroup_Count(squads) > 0) then
			for i=1, SGroup_Count(squads) do
				German_CalculateDesertion(SGroup_GetSpawnedSquadAt(squads, i));
			end
			SGroup_Clear(squads);
		end
	else
		Rule_RemoveMe();
	end
end

function Soviet_DoCleanup()

	local squads = SGroup_CreateIfNotFound("sg_saved_units");
	World_GetSquadsNearMarker(soviet1, squads, mkr_frontline_total_collapse, OT_Player);
	if (SGroup_Count(squads) > 0) then
		SGroup_DestroyAllSquads(squads);
	end
	
end
