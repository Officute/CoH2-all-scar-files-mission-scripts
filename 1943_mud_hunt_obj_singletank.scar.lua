-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- 1943 Challenge: MUD HUNT - SINGLE TANK OBJECTIVE
-- Designer: NJR
-------------------------------------------------------------------------
-------------------------------------------------------------------------

function SingleTank_Init()

	single_index = 0			-- index increases as each specific instance is created
	
	-- set the types of units that will appear for single tank encounters
	if g_difficulty == GD_EASY then
		t_singletank_choices = {
			{sbp = SBP.GERMAN.STUG_III_SQUAD},
			{sbp = SBP.GERMAN.STUG_III_SQUAD},
			{sbp = SBP.GERMAN.STUG_III_SQUAD, upg = UPG.GERMAN.STUG_TOP_GUNNER},
			{sbp = SBP.GERMAN.STUG_III_SQUAD, upg = UPG.GERMAN.STUG_TOP_GUNNER},
		}
	elseif g_difficulty == GD_NORMAL then
		t_singletank_choices = {
			{sbp = SBP.GERMAN.STUG_III_SQUAD},
			{sbp = SBP.GERMAN.STUG_III_SQUAD, upg = UPG.GERMAN.STUG_TOP_GUNNER},
			{sbp = SBP.GERMAN.PANZER_IV_SQUAD},
			{sbp = SBP.GERMAN.PANZER_IV_SQUAD},
		}
	elseif g_difficulty == GD_HARD then
		t_singletank_choices = {
			{sbp = SBP.GERMAN.PANZER_IV_SQUAD, upg = UPG.GERMAN.PANZER_TOP_GUNNER},
			{sbp = SBP.GERMAN.PANZER_IV_SQUAD, upg = UPG.GERMAN.PANZER_TOP_GUNNER},
			{sbp = SBP.GERMAN.PANZER_IV_SQUAD, upg = UPG.GERMAN.PANZER_TOP_GUNNER},
		}
	end
	
end


function SingleTank_SetUp(data)
	
	if t_singletank_choices == nil then
		SingleTank_Init()
	end
	
	single_index = single_index + 1
	
	-- create groups for the different bits of this encounter
	local sgroup = SGroup_CreateIfNotFound("sg_single"..single_index)
	local rescuer = SGroup_CreateIfNotFound("sg_single"..single_index.."_rescuer")
	
	-- choose unit
	local choice = t_singletank_choices[math.mod(single_index-1, #t_singletank_choices) + 1]		-- round-robin selection from the choices table
	
	-- create the tanks and set them up correctly
	Util_CreateSquads(player2, sgroup, choice.sbp, data.location, nil, nil, nil, nil, nil, choice.upg)
	Cmd_CriticalHit(player2, sgroup, CRIT.VEHICLE_STUCK_IN_MUD, 0)
	Modify_UnitSpeed(sgroup, t_difficulty.tank_speedmodifier)
	if choice.vet ~= nil then
		SGroup_IncreaseVeterancyRank(sgroup, choice.vet, true)
	end
	
	num_total_tanks = num_total_tanks + 1
	
	data.tank_sgroup = sgroup
	data.rescuer = rescuer
	data.index = single_index
	
	-- trigger the rescue when the player gets close
	Event_CreateOR(SingleTank_StartRescue, data, {
		Event_Proximity(__DoNothing, nil, player1, data.location, 25, ANY),
		Event_Timer(__DoNothing, nil, World_GetRand(t_difficulty.time_limit_min, t_difficulty.time_limit_max)),
		Event_OnHealth(__DoNothing, nil, sgroup, 0.75, false)
	} )
	
	Event_PlayerCanSeeElement(Mission_TankSpottedSpeech, {intel = EVENTS.SingleTank_Spotted, sgroup = sgroup}, player1, Util_GetPosition(sgroup), ANY)
	
end




function SingleTank_StartRescue(data)
	
	local this = {}
	
	this.location = data.location
	this.target = data.tank_sgroup
	this.rescuer = data.rescuer
	
	if t_singletank_rescuesquads == nil then
		t_singletank_rescuesquads = {}
	end
	table.insert(t_singletank_rescuesquads, this)
	
	if Rule_Exists(SingleTank_Manager) == false then
		Rule_AddInterval(SingleTank_Manager, 1)
	end
	
end


function SingleTank_Manager()

	for index = #t_singletank_rescuesquads, 1, -1 do 
		
		local removeme = false
		local this = t_singletank_rescuesquads[index]
		
		-- this.rescuer 		- sgroup of engineers
		-- this.target 			- vehicle they are rescuing
		
		if SGroup_Count(this.target) == 0 then
			
			-- vehicle was killed by player
			FindAndDestroy_TankHasBeenDestroyed()
			SGroup_SetPlayerOwner(this.rescuer, player3)		-- pass rescuers over to skirmish AI
			
			removeme = true
			
		elseif SGroup_Count(this.rescuer) == 0 then
			
			-- rescuer was killed by player
			Mission_FindSpareSquadForRescue(this.location, this.rescuer)
			
		elseif Prox_AreSquadsNearMarker(this.target, mkr_map_exit, ANY, 3) then
			
			-- remove tank from map
			SGroup_DestroyAllSquads(this.target)
			Cmd_MoveToAndDespawn(this.rescuer, mkr_map_exit)
			
			FindAndDestroy_TankHasEscaped()
			
			removeme = true
			
		elseif SGroup_HasCritical(this.target, CRIT.VEHICLE_STUCK_IN_MUD, ANY) == false then
			
			-- vehicle is free, send it on its way
			Cmd_Move(this.target, mkr_map_exit)
			Cmd_Move(this.rescuer, Util_GetOffsetPosition(this.target, OFFSET_BACK, 5))
			
			-- play some speech to let the player know a tank is free and on the move
			if this.on_the_move ~= true then
				Mission_TankOnTheMoveSpeech({sgroup = this.target})
				this.on_the_move = true
			end
			
		elseif Prox_AreSquadsNearMarker(this.rescuer, Util_GetPosition(this.target), ANY, 5) then
			
			-- rescuers are near the tank 
			Cmd_Ability(this.rescuer, ABILITY.GLOBAL.DIG_OUT_OF_MUD, this.target)
			
		else
			
			Cmd_Move(this.rescuer, this.target)
			
		end
		
		
		
		if removeme == true then
			table.remove(t_singletank_rescuesquads, index)
		end
		
	end

	if #t_singletank_rescuesquads == 0 then
		Rule_RemoveMe()
	end
	
end





