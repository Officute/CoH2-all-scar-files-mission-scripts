-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- 1943 Challenge: MUD HUNT - DOUBLE TANK OBJECTIVE
-- Designer: NJR
-------------------------------------------------------------------------
-------------------------------------------------------------------------




function DoubleTank_Init()

	double_index_index = 0			-- index increases as each specific instance is created
	
	-- set the types of units that will appear for single tank encounters
	if g_difficulty == GD_EASY then
		t_doubletank_choices = {
			{
				{sbp = SBP.GERMAN.STUG_III_SQUAD},
				{sbp = SBP.GERMAN.STUG_III_SQUAD},
			},
			{
				{sbp = SBP.GERMAN.STUG_III_SQUAD},
				{sbp = SBP.GERMAN.STUG_III_SQUAD, 	upg = UPG.GERMAN.STUG_TOP_GUNNER},
			},
		}
	elseif g_difficulty == GD_NORMAL then
		t_doubletank_choices = {
			{
				{sbp = SBP.GERMAN.STUG_III_SQUAD, 	upg = UPG.GERMAN.STUG_TOP_GUNNER, 	vet = 1},
				{sbp = SBP.GERMAN.STUG_III_SQUAD, 										vet = 2},
			},
			{
				{sbp = SBP.GERMAN.STUG_III_SQUAD, 										vet = 2},
				{sbp = SBP.GERMAN.PANZER_IV_SQUAD, 										vet = 1},
			},
		}
	elseif g_difficulty == GD_HARD then
		t_doubletank_choices = {
			{
				{sbp = SBP.GERMAN.PANZER_IV_SQUAD, 	upg = UPG.GERMAN.PANZER_TOP_GUNNER, vet = 1},
				{sbp = SBP.GERMAN.STUG_III_SQUAD, 	upg = UPG.GERMAN.STUG_TOP_GUNNER, 	vet = 3},
			},
			{
				{sbp = SBP.GERMAN.STUG_III_SQUAD, 	upg = UPG.GERMAN.STUG_TOP_GUNNER, 	vet = 3},
				{sbp = SBP.GERMAN.PANZER_IV_SQUAD, 	upg = UPG.GERMAN.PANZER_TOP_GUNNER, vet = 2},
			},
			{
				{sbp = SBP.GERMAN.STUG_III_SQUAD, 	upg = UPG.GERMAN.STUG_TOP_GUNNER, 	vet = 3},
				{sbp = SBP.GERMAN.STUG_III_SQUAD, 	upg = UPG.GERMAN.STUG_TOP_GUNNER, 	vet = 2},
			},
		}
	end
	
end
	
	


function DoubleTank_SetUp(data)
	
	if t_doubletank_choices == nil then
		DoubleTank_Init()
	end
	
	double_index = double_index + 1
	
	-- create groups for the different bits of this encounter
	local sgroupA = SGroup_CreateIfNotFound("sg_double"..double_index.."a")
	local sgroupB = SGroup_CreateIfNotFound("sg_double"..double_index.."b")
	local sgroup_both = SGroup_CreateIfNotFound("sg_double"..double_index.."_both")
	local sgroup_rescuer = SGroup_CreateIfNotFound("sg_double"..double_index.."_rescuer")
	
	-- choose unit
	local choice = t_doubletank_choices[math.mod(double_index-1, #t_doubletank_choices) + 1]		-- round-robin selection from the choices table
	local choiceA = choice[1]
	local choiceB = choice[2]
	
	-- create the tanks and set them up correctly
	Util_CreateSquads(player2, sgroupA, choiceA.sbp, data.location, nil, nil, nil, nil, nil, choiceA.upg)
	Util_CreateSquads(player2, sgroupB, choiceB.sbp, Util_GetOffsetPosition(data.location, OFFSET_FRONT_RIGHT, 8), nil, nil, nil, nil, nil, choiceB.upg, Util_GetOffsetPosition(data.location, OFFSET_FRONT, 100))
	Cmd_CriticalHit(player2, sgroupA, CRIT.VEHICLE_STUCK_IN_MUD, 0)
	Cmd_CriticalHit(player2, sgroupB, CRIT.VEHICLE_STUCK_IN_MUD, 0)
	Modify_UnitSpeed(sgroupA, t_difficulty.tank_speedmodifier)
	Modify_UnitSpeed(sgroupB, t_difficulty.tank_speedmodifier)
	if choiceA.vet ~= nil then
		SGroup_IncreaseVeterancyRank(sgroupA, choiceA.vet, true)
	end
	if choiceB.vet ~= nil then
		SGroup_IncreaseVeterancyRank(sgroupB, choiceB.vet, true)
	end
	
	num_total_tanks = num_total_tanks + 2
	
	SGroup_AddGroups(sgroup_both, {sgroupA, sgroupB})
	
	-- create some guys to defend the tanks
	local encData = {
		name = "Defenders for Double Tank "..double_index,
		spawn = data.location,
		units = {
			{sbp = SBP.GERMAN.GRENADIER_SQUAD},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD, difficulty = {GD_EASY, GD_NORMAL}},
			{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, difficulty = {GD_NORMAL, GD_HARD}},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, difficulty = GD_HARD},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, difficulty = GD_HARD},
		},
		goal = {
			name = "Defend",
			target = sgroup_both,
			range = 40,
			leashRange = 15,
			abilityBlacklist = {
				ABILITY.GLOBAL.DIG_OUT_OF_MUD,
			},
			patrolParams = {
				name = "Patrol",
				marker = data.location,
				range = 15,
				wait = 20,
			},
		},
	}
	
	data.defenders_encounter = Encounter:Create(encData, true)
	data.tank_sgroupA = sgroupA
	data.tank_sgroupB = sgroupB
	data.rescuer = sgroup_rescuer
	data.index = double_index
	
	-- trigger the rescue when the player gets close
	Event_CreateOR(DoubleTank_StartRescue, data, {
		Event_Proximity(__DoNothing, nil, player1, data.location, 25, ANY),
		Event_Timer(__DoNothing, nil, World_GetRand(t_difficulty.time_limit_min, t_difficulty.time_limit_max)),
		Event_OnHealth(__DoNothing, nil, sgroupA, 0.9, false),
		Event_OnHealth(__DoNothing, nil, sgroupB, 0.9, false),
	} )

	Event_CreateOR(Mission_TankSpottedSpeech, {intel = EVENTS.DoubleTank_Spotted, sgroup = sgroup_both}, {
		Event_PlayerCanSeeElement(__DoNothing, nil, player1, Util_GetPosition(sgroupA)),
		Event_PlayerCanSeeElement(__DoNothing, nil, player1, Util_GetPosition(sgroupB)),
	} )
	
end








function DoubleTank_StartRescue(data)
	
	local this = {}
	
	this.location = data.location
	this.targetA = data.tank_sgroupA
	this.targetB = data.tank_sgroupB
	this.targetA_state = "stuck"
	this.targetB_state = "stuck"
	this.rescuer = data.rescuer
	this.defenders_encounter = data.defenders_encounter
	
	Util_CreateSquads(player2, this.rescuer, SBP.GERMAN.PANZER_GRENADIER_SQUAD, Table_GetRandomItem(t_infantryspawnlocations), Util_GetPosition(this.location), 1)
	
	if t_doubletank_rescuesquads == nil then
		t_doubletank_rescuesquads = {}
	end
	table.insert(t_doubletank_rescuesquads, this)
	
	if Rule_Exists(DoubleTank_Manager) == false then
		Rule_AddInterval(DoubleTank_Manager, 1)
	end
	
end


function DoubleTank_Manager()

	for index = #t_doubletank_rescuesquads, 1, -1 do 
		
		local removeme = false
		local this = t_doubletank_rescuesquads[index]
		
		-- this.rescuer 		- sgroup of engineers
		-- this.targetA
		-- this.targetB			- vehicles they are rescuing
		
		-- mark any vehicles that were destroyed
		if this.targetA_state ~= "destroyed" and this.targetA_state ~= "escaped" and SGroup_Count(this.targetA) == 0 then
			this.targetA_state = "destroyed"
			FindAndDestroy_TankHasBeenDestroyed()
		end
		if this.targetB_state ~= "destroyed" and this.targetB_state ~= "escaped" and SGroup_Count(this.targetB) == 0 then
			this.targetB_state = "destroyed"
			FindAndDestroy_TankHasBeenDestroyed()
		end
		
		
		
		if SGroup_Count(this.targetA) + SGroup_Count(this.targetB) == 0 then
			
			SGroup_SetPlayerOwner(this.rescuer, player3)		-- pass rescuers over to skirmish AI
			
			-- vehicle was killed by player
			removeme = true
			
		elseif SGroup_Count(this.rescuer) == 0 then
			
			-- rescuer was killed by player
			Mission_FindSpareSquadForRescue(this.location, this.rescuer)
			
		end
		
		
		if this.targetA_state == "free" and Prox_AreSquadsNearMarker(this.targetA, mkr_map_exit, ANY, 3) then
			
			-- remove tank from map
			SGroup_DestroyAllSquads(this.targetA)
			
			this.targetA_state = "escaped"
			FindAndDestroy_TankHasEscaped()
			
		end
		
		if this.targetB_state == "free" then
			
			if Prox_AreSquadsNearMarker(this.targetB, mkr_map_exit, ANY, 3) then
				
				-- remove tank from map
				SGroup_DestroyAllSquads(this.targetB)
				Cmd_MoveToAndDespawn(this.rescuer, mkr_map_exit)
				
				this.targetB_state = "escaped"
				FindAndDestroy_TankHasEscaped()
				
				-- remove defender encounter as well
				local sgroup = this.defenders_encounter:GetSgroup()
				if SGroup_CountSpawned(sgroup) >= 1 then
					Cmd_MoveToAndDespawn(sgroup, mkr_map_exit)
				end
				
				removeme = true
				
			else
				
				Cmd_Move(this.rescuer, Util_GetOffsetPosition(this.targetB, OFFSET_BACK, 5))
				
			end
			
		end
		
		if this.targetA_state == "stuck" and SGroup_Count(this.targetA) >= 1 then
			
			if SGroup_HasCritical(this.targetA, CRIT.VEHICLE_STUCK_IN_MUD, ANY) == false then
				
				-- vehicle is free, send it on its way
				Cmd_Move(this.targetA, mkr_map_exit)
				Cmd_Move(this.rescuer, this.targetB)
				
				this.targetA_state = "free"
				
				-- play some speech to let the player know a tank is free and on the move
				Mission_TankOnTheMoveSpeech({sgroup = this.targetA})
				
				-- make the defenders focus on the remaining tank
				if SGroup_CountSpawned(this.targetB) >= 1 then
					local goalData = this.defenders_encounter:GetGoalData()
					goalData.target = this.targetB
					this.defenders_encounter:SetGoal(goalData)
				end
				
			elseif Prox_AreSquadsNearMarker(this.rescuer, Util_GetPosition(this.targetA), ANY, 5) then
				
				-- rescuers are near the tank 
				Cmd_Ability(this.rescuer, ABILITY.GLOBAL.DIG_OUT_OF_MUD, this.targetA)
				
			else
				
				Cmd_Move(this.rescuer, this.targetA)
				
			end
			
		elseif this.targetB_state == "stuck" and SGroup_Count(this.targetB) >= 1 then
			
			if SGroup_HasCritical(this.targetB, CRIT.VEHICLE_STUCK_IN_MUD, ANY) == false then
				
				-- vehicle is free, send it on its way
				Cmd_Move(this.targetB, mkr_map_exit)
				Cmd_Move(this.rescuer, Util_GetOffsetPosition(this.targetB, OFFSET_BACK, 5))
				
				this.targetB_state = "free"
				
				-- play some speech to let the player know a tank is free and on the move
				Mission_TankOnTheMoveSpeech({sgroup = this.targetB})
				
			elseif this.targetB_state == "stuck" and Prox_AreSquadsNearMarker(this.rescuer, Util_GetPosition(this.targetB), ANY, 5) then
				
				-- rescuers are near the tank 
				Cmd_Ability(this.rescuer, ABILITY.GLOBAL.DIG_OUT_OF_MUD, this.targetB)
				
			else
				
				Cmd_Move(this.rescuer, this.targetB)
				
			end
			
		end
		
		
		if removeme == true then
			table.remove(t_doubletank_rescuesquads, index)
		end
		
	end

	if #t_doubletank_rescuesquads == 0 then
		Rule_RemoveMe()
	end
	
end




