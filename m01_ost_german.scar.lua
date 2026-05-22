function German_Initialize()

	german1 = player1;
	german2 = player2;

	sg_g_german1_sniper = SGroup_CreateIfNotFound("sg_g_german1_sniper");
	sg_g_german2_sniper = SGroup_CreateIfNotFound("sg_g_german2_sniper");
	
	SGroup_SetPlayerOwner(sg_coop, german2);

	t_ai_orders = nil;
	
	if (Util_IsCoop() == false) then -- make the AI take control of these units
		
		t_ai_orders = {};
		
		SGroup_EnableUIDecorator(sg_coop, false); 
		
		W_Demand_Buy = DEMAND_NONE;
		W_Demand_Vehicle = DEMAND_NONE;
		W_Demand_Infantry = DEMAND_HIGH;
		
		t_ai_orders.buyorder = {}; -- this does not contain tables, we only want to call in what we need in a "normal" looking way
		t_ai_orders.squads = {};
		t_ai_orders.squads.kt = SGroup_CreateIfNotFound("sg_german_kt");
		t_ai_orders.squads.trench = SGroup_CreateIfNotFound("sg_german_trench");
		t_ai_orders.squads.extraunit = SGroup_CreateIfNotFound("sg_xtraunit");
		
		w_buyableinfantry = {"volksgrenadier", "grenadier", "pgrenadier"};
		w_buyablevehicles = {"tiger", "panzer4", "panzer5"};
		
		w_trenchmarkers = {mkr_ai_trench01, mkr_ai_trench02, mkr_ai_trench03, mkr_ai_trench04, mkr_ai_trench05, mkr_ai_trench06, mkr_ai_trench07, mkr_ai_trench08};
		w_vehiclemarkers = {mkr_ai_vehicle01, mkr_ai_vehicle02, mkr_ai_vehicle03};
		
		w_teamweapons = {};
		
		SGroup_AddGroup(t_ai_orders.squads.trench, sg_ai_grenadiers01);
		SGroup_AddGroup(t_ai_orders.squads.trench, sg_ai_grenadiers02);
		SGroup_AddGroup(t_ai_orders.squads.trench, sg_ai_grenadiers03);
		SGroup_AddGroup(t_ai_orders.squads.trench, sg_ai_grenadiers04);
		
		Rule_AddDelayedInterval(German_DoArtillery, 360, 260);
		
	end
	
end

function German_MoveIntoDefence()
	if (t_ai_orders ~= nil) then
		local t_order = {tag = "grenadier", position = eg_ai_syncweapon03};
		t_ai_orders.buyorder = t_order;
		Cmd_CaptureTeamWeapon(sg_ai_pioneers01, eg_ai_syncweapon01, false);
		Cmd_CaptureTeamWeapon(sg_ai_pioneers02, eg_ai_syncweapon02, false);
		Cmd_Move(sg_ai_grenadiers01, mkr_ai_trench01);
		Cmd_Move(sg_ai_grenadiers02, mkr_ai_trench03);
		Cmd_Move(sg_ai_grenadiers03, mkr_ai_trench05);
		Cmd_Move(sg_ai_grenadiers04, mkr_ai_trench08);
		Rule_AddOneShot(German_UpdateTeamWeapons, 190);
		German_SpawnSquadWithTask(t_ai_orders.squads.extraunit, 1, "panzer_grenadier_squad_mp", w_buyableinfantry[3], eg_ai_syncweapon03);
		
	end
end

function German_UpdateTeamWeapons()
	local sg_temp_mortar = SGroup_CreateIfNotFound("sg_temp_mortar");
	local sg_temp_hmg = SGroup_CreateIfNotFound("sg_temp_hmg");
	local sg_leftovers = SGroup_CreateIfNotFound("sg_leftovers");
	World_GetSquadsNearMarker(german2, sg_temp_mortar, mkr_ai_teamweapons, OT_Ally);
	SGroup_Filter(sg_temp_mortar, BP_GetSquadBlueprint("mg42_heavy_machine_gun_squad_mp"), FILTER_REMOVE, sg_temp_hmg);
	SGroup_Filter(sg_temp_mortar, BP_GetSquadBlueprint("mortar_team_81mm_mp"), FILTER_KEEP, sg_leftovers);
	if (SGroup_Count(sg_temp_hmg) > 0) then
		Cmd_Garrison(sg_temp_hmg, eg_ai_building01, true, false, false); 
	end
	if (SGroup_Count(sg_temp_mortar) > 0) then
		Cmd_Move(SGroup_FromSquad(SGroup_GetSpawnedSquadAt(sg_temp_mortar, 1)), mkr_ai_mortar01);
		--Cmd_Move(SGroup_FromSquad(SGroup_GetSpawnedSquadAt(sg_temp_mortar, 2)), mkr_ai_mortar02);
	end
	Cmd_Move(sg_leftovers, German_GetRandomDefencePosition());
	SGroup_Clear(sg_temp_mortar);
	SGroup_Clear(sg_leftovers);
	SGroup_Clear(sg_temp_hmg);
end

function German_CallInReinforcements() -- we really want to be careful with this one as the AI and the player will be sharing the units available - Apparently this FUNCTION refuses to work
	if (t_ai_orders ~= nil) then
		if (W_Demand_Buy > DEMAND_LOW or W_Demand_Buy == DEMAND_FORCE) then
			if (t_ai_orders.buyorder.tag ~= nil) then
				if (t_production[t_ai_orders.buyorder.tag].available > 1) then -- We do not allow the AI to take the last unit, in case the player really wants two KT's as an example
					Production_Buy(t_ai_orders.buyorder.tag, german2);
					if (t_ai_orders.buyorder.position == nil) then
						Cmd_Move(sg_lastreinforcement, German_GetRandomDefencePosition());
					else
						if (scartype(t_ai_orders.buyorder.position) ~= ST_MARKER) then
							if (EGroup_ContainsBlueprints(t_ai_orders.buyorder.position, BP_GetEntityBlueprint(""), ANY) == true) then
								Cmd_CaptureTeamWeapon(sg_lastreinforcement, t_ai_orders.buyorder.position, false);
							else
								Cmd_Garrison(sg_lastreinforcement, t_ai_orders.buyorder.position, true, false, false);
							end
						else
							Cmd_Move(sg_lastreinforcement , t_ai_orders.buyorder.position);
						end
					end
					SGroup_EnableUIDecorator(sg_lastreinforcement, false);
					W_Demand_Buy = W_Demand_Buy - DEMAND_LOW + 10;
					t_ai_orders.buyorder.tag = nil;
					t_ai_orders.buyorder.position = nil;
				end
			else -- There's a demand that we buy something but nothing specific is requested
				if (W_Demand_Buy >= DEMAND_HIGH or W_Demand_Buy == DEMAND_FORCE) then -- We only want to do this IF there's a high demand (so we don't annoy the player with stealing units)
					if (W_Demand_Infantry > W_Demand_Vehicle) then -- There's a higher demand on infantry than vehicles
						local unit = German_GetRandomOrder("infantry");
						if (t_production[unit].available > 1 or W_Demand_Buy == DEMAND_FORCE) then -- Make sure we don't take the last - unless we force the AI
							Production_Buy(unit, german2);
							Cmd_Move(sg_lastreinforcement, German_GetRandomDefencePosition());
							SGroup_EnableUIDecorator(sg_lastreinforcement, false);
							W_Demand_Buy = DEMAND_NONE + 10; -- we've bought something - that wasn't scripted so there is hopefully no need to buy anything else
							W_Demand_Infantry = W_Demand_Infantry - 5;
							W_Demand_Vehicle = W_Demand_Vehicle + 5;
						end
					else -- There's a higher demand on vehicles than on infantry
						local unit = German_GetRandomOrder("vehicle");
						if (t_production[unit].available > 2) then -- Make sure we don't take the last (in this case the second last because of vehicles) - Can't force the AI here
							Production_Buy(unit, german2);
							Cmd_Move(sg_lastreinforcement, German_GetRandomVehiclePosition());
							SGroup_EnableUIDecorator(sg_lastreinforcement, false);
							W_Demand_Buy = DEMAND_NONE + 10; -- we've bought something - that wasn't scripted so there is hopefully no need to buy anything else
							W_Demand_Infantry = W_Demand_Infantry + 5;
							W_Demand_Vehicle = W_Demand_Vehicle - 5;
						end
					end
				end
			end
		end
	end
end

function German_GetRandomOrder(buytype)
	if (buytype == "vehicle") then
		return w_buyablevehicles[World_GetRand(1, w_buyablevehicles)];
	else
		return w_buyableinfantry[World_GetRand(1, #w_buyableinfantry)];
	end
end

function German_DoArtillery()
	local t_arty_pos = {mkr_nomansland01, mkr_nomansland02, mkr_nomansland03};
	local randpos1 = Util_GetRandomPosition(t_arty_pos[World_GetRand(1, #t_arty_pos)], 45);
	local randpos2 = Util_GetRandomPosition(t_arty_pos[World_GetRand(1, #t_arty_pos)], 45);
	if (SGroup_Count(sg_ai_artillery01) > 0) then
		Cmd_Ability(sg_ai_artillery01, BP_GetAbilityBlueprint("howitzer_105mm_barrage_ability_mp"), randpos1, nil, true, false);
	end
	if (SGroup_Count(sg_ai_artillery02) > 0) then
		Cmd_Ability(sg_ai_artillery02, BP_GetAbilityBlueprint("howitzer_105mm_barrage_ability_mp"), randpos2, nil, true, false);
	end
end

function German_Update()
	if (t_ai_orders ~= nil) then
		if (g_time.current == TIME_NIGHT) then
			if (SGroup_Count(t_ai_orders.squads.kt) == 0) then
				local t_order = {tag = "kingtiger", position = mkr_ai_kingtiger};
				t_ai_orders.buyorder = t_order;
				W_Demand_Buy = W_Demand_Buy + DEMAND_LOW;
				W_Demand_Vehicle = DEMAND_NONE - 15; -- because we're buying a KT
			end
			if (SGroup_Count(t_ai_orders.squads.trench) <= 4) then
				W_Demand_Buy = W_Demand_Buy + DEMAND_LOW; -- just get something
				W_Demand_Infantry = W_Demand_Infantry + 5;
			end
			German_CallInReinforcements();
			if (Util_GetPlayerOwner(sg_lastreinforcement) ~= german2) then
				German_Reinforce();
			end
		end
	else
		Rule_RemoveMe();
	end
end

function German_Reinforce()

	if (g_time.current == TIME_NIGHT) then

		local hasSpend = false;

		if (SGroup_Count(sg_ai_grenadiers01) == 0 and hasSpend == false) then
			German_SpawnSquadWithTask(sg_ai_grenadiers01, 1, "volksgrenadier_squad_mp", "volksgrenadier_squad_mp", German_GetRandomDefencePosition())
			hasSpend = true;
		end

		if (SGroup_Count(sg_ai_grenadiers02) == 0 and hasSpend == false) then
			German_SpawnSquadWithTask(sg_ai_grenadiers02, 1, "volksgrenadier_squad_mp", "volksgrenadier_squad_mp", German_GetRandomDefencePosition())
			hasSpend = true;
		end
		
		if (SGroup_Count(sg_ai_grenadiers03) == 0 and hasSpend == false) then
			German_SpawnSquadWithTask(sg_ai_grenadiers03, 1, "volksgrenadier_squad_mp", "volksgrenadier_squad_mp", German_GetRandomDefencePosition())
			hasSpend = true;
		end
		
		if (SGroup_Count(sg_ai_grenadiers04) == 0 and hasSpend == false) then
			German_SpawnSquadWithTask(sg_ai_grenadiers04, 1, "volksgrenadier_squad_mp", "volksgrenadier_squad_mp", German_GetRandomDefencePosition())
			hasSpend = true;
		end
		
		if (SGroup_Count(sg_ai_pioneers01) == 0 and hasSpend == false) then
			German_SpawnSquadWithTask(sg_ai_pioneers01, 1, "volksgrenadier_squad_mp", "volksgrenadier_squad_mp", German_GetRandomDefencePosition())
			hasSpend = true;
		end
		
		if (SGroup_Count(sg_ai_pioneers02) == 0 and hasSpend == false) then
			German_SpawnSquadWithTask(sg_ai_pioneers02, 1, "volksgrenadier_squad_mp", "volksgrenadier_squad_mp", German_GetRandomDefencePosition())
			hasSpend = true;
		end
		
	end
	
end

function German_SpawnSquadWithTask(sgroup, amount, blueprint, unittype, position_target)
	
	local target = nil;
	local teamweapon = nil;
	local sg_temp = SGroup_CreateIfNotFound("sg_german_spawn_task");
	
	if (scartype(position_target) == ST_EGROUOP) then
		teamweapon = position_target;
	else
		target = position_target;
	end
	
	Util_CreateSquads(german2, sg_temp, BP_GetSquadBlueprint(blueprint), Production_GetRandomSpawn(), target, amount, nil, true, nil, nil, nil);
	
	SGroup_IncreaseVeterancyRank(sg_temp, World_GetRand(0, 3), true);
	Modify_WeaponRange(sg_temp, "hardpoint_01", 1.5);	
	SGroup_EnableUIDecorator(sg_temp, false);
	Production_Upgrade(sg_temp, unittype);
	
	if (teamweapon ~= nil) then
		Cmd_CaptureTeamWeapon(sg_temp, teamweapon, false);
	end
	
	if (Rule_Exists(_updateteamweapons) == false and teamweapon ~= nil) then
		--Rule_AddInterval(_updateteamweapons);
	end
	
	SGroup_AddGroup(sgroup, sg_temp);
	SGroup_Clear(sg_temp);
	
end

function _updateteamweapons()

	if (#w_teamweapons > 0) then
	
		for i=1, #w_teamweapons do
			
		end
	
	else
		Rule_RemoveMe();
	end

end

function German_Desert(squad)
	
	local exitpos = mkr_enemy_spawner02;
	
	SGroup_CreateKickerMessage(squad, Game_GetLocalPlayer(), 42812)
	
	if _surrender == nil then
		_surrender = {}
	end
	
	local temp = {pos_exit = exitpos, state = false, deleteSquad = true, disarm = true};
	table.insert(_surrender, temp)
	local num = table.getn(_surrender)
	_surrender[num].sgroup = SGroup_CreateIfNotFound("_sg_surrender"..num)
	_surrender[num].timer = "_SURRENDER_TIMER"..num
	SGroup_Add(_surrender[num].sgroup, sid)
	Cmd_Stop(squad)
	
	if SGroup_HasTeamWeapon(squad, ANY) then
		Cmd_AbandonTeamWeapon(squad, true)
	end
	
	SGroup_SetSuppression(squad, 0)
	SGroup_SetAutoTargetting(squad, "hardpoint_01", false)	
	SGroup_SetInvulnerable(squad, true)
	SGroup_SetCrushable(squad, false)
	SGroup_EnableAttention(squad, false)
	
	SGroup_EnableUIDecorator(sgroupid, false )
	SGroup_EnableMinimapIndicator(sgroupid, false)
	SGroup_SetSelectable(sgroupid, false)
	
	if Rule_Exists(_DesertInternal) == false then
		Rule_AddInterval(_DesertInternal, 0.5)
	end
	
end

function _DesertInternal()

	_sg_surrender_internal = SGroup_CreateIfNotFound("_sg_surrender_internal")

	for k, v in pairs(_surrender) do
		
		if SGroup_IsEmpty(v.sgroup) then
			table.remove(_surrender, k)
		else
		
			if not SGroup_IsMoving( v.sgroup, ALL ) 
			and v.state == false then
				
				if SGroup_HasTeamWeapon(v.sgroup, ANY) then
					Cmd_AbandonTeamWeapon(v.sgroup, true)
				elseif SGroup_IsInHoldEntity(v.sgroup, ANY) or SGroup_IsInHoldSquad(v.sgroup, ANY) then
					Cmd_UngarrisonSquad(v.sgroup)
				else
					v.state = "surrender"
					Timer_Start(v.timer, 3*60)
					SGroup_SetMoodMode(v.sgroup, MM_ForceCalm)
					SGroup_SetAnimatorState(v.sgroup, "surrender", "on")
					
					if v.disarm == true then
						SGroup_CallSquadFunction(v.sgroup, function(id) Squad_AddAbility(id, ABILITY.GLOBAL.SP_DROP_WEAPONS) end, nil)
						Cmd_Ability(v.sgroup, ABILITY.GLOBAL.SP_DROP_WEAPONS, nil, nil, true, true )
					end
					Cmd_DoPlan(v.sgroup, "surrender", v.pos_exit, true)
				end
				
			elseif v.state == "surrender" then		
				if Prox_AreSquadMembersNearMarker(v.sgroup, v.pos_exit, ANY, 5)
				  or Timer_GetRemaining(v.timer) <= 0 then
					if v.deleteSquad == true then
						SGroup_DestroyAllSquads(v.sgroup)
					end
				elseif not SGroup_IsMoving(v.sgroup, ANY) then
					Cmd_DoPlan(v.sgroup, "surrender", v.pos_exit, true)
				end
			end
			
		end
		
	end
	
	if table.getn(_surrender) == 0 then
		SGroup_Destroy(_sg_surrender_internal)
		Rule_RemoveMe()
	end

end

function German_CalculateDesertion(target) -- This is called in the soviets file and will calculate when a squad will surrender
	local squad = SGroup_FromName(target);
	local lvldesert = 0;
	lvldesert = lvldesert + t_difficulty.commissar_fear;
	lvldesert = lvldesert + (SGroup_GetVeterancyRank(squad) * 5);
	if (SGroup_GetAvgHealth(squad) >= 0.75) then
		lvldesert = lvldesert + 50;
	elseif (SGroup_GetAvgHealth(squad) >= 0.5) then
		lvldesert = lvldesert + 25;
	else
		lvldesert = lvldesert + 12;
	end
	if (lvldesert >= t_difficulty.commissar_fear_level) then
		German_Desert(squad);
	end
	SGroup_Clear(squad);
end

function German_GetRandomDefencePosition()
	return w_trenchmarkers[World_GetRand(1, #w_trenchmarkers)];
end

function German_GetRandomVehiclePosition()
	return w_vehiclemarkers[World_GetRand(1, #w_vehiclemarkers)];
end
