-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- 1943 Challenge: MUD HUNT - ELEFANT TANK OBJECTIVE
-- Designer: NJR
-------------------------------------------------------------------------
-------------------------------------------------------------------------



function Elefant_SetUp(data)

	elefant_index = elefant_index + 1
	local sgroup = SGroup_CreateIfNotFound("sg_elefant"..elefant_index)
	local rescuer = SGroup_CreateIfNotFound("sg_elefant"..elefant_index.."_rescuer")
	
	Util_CreateSquads(player2, sgroup, SBP.GERMAN.ELEFANT_TANK_DESTROYER_SQUAD, data.location)
	Cmd_CriticalHit(player2, sgroup, CRIT.VEHICLE_STUCK_IN_MUD, 0)
	Modify_UnitSpeed(sgroup, t_difficulty.tank_speedmodifier)
	if g_difficulty ~= GD_EASY then
		SGroup_IncreaseVeterancyRank(sgroup, Util_DifVar({0, 1, 2}), true)
	end
	
	num_total_tanks = num_total_tanks + 1
	

	-- create some guys to defend the tanks
	local encData = {
		name = "Defenders for Elefant Tank "..elefant_index,
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
			target = sgroup,
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
	data.tank_sgroup = sgroup
	data.rescuer = rescuer
	
	-- trigger the rescue when the player gets close
	Event_CreateOR(Elefant_StartRescue, data, {
		Event_Proximity(__DoNothing, nil, player1, data.location, 25, ANY),
		Event_OnHealth(__DoNothing, nil, sgroup, 0.9, false),
	} )
	
	Event_PlayerCanSeeElement(Mission_TankSpottedSpeech, {intel = EVENTS.ElefantTank_Spotted, sgroup = sgroup}, player1, Util_GetPosition(sgroup), ANY)
	
end




function Elefant_StartRescue(data)
	
	local this = {}
	
	this.location = data.location
	this.target = data.tank_sgroup
	this.rescuer = data.rescuer
	this.defenders_encounter = data.defenders_encounter
	
	if t_elefant_rescuesquads == nil then
		t_elefant_rescuesquads = {}
	end
	table.insert(t_elefant_rescuesquads, this)
	
	if Rule_Exists(Elefant_Manager) == false then
		Rule_AddInterval(Elefant_Manager, 1)
	end
	
end


function Elefant_Manager()

	for index = #t_elefant_rescuesquads, 1, -1 do 
		
		local removeme = false
		local this = t_elefant_rescuesquads[index]
		
		-- this.rescuer 		- sgroup of dig out infantry
		-- this.defender 		- sgroup of other defenders
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
			
			-- remove defender encounter as well
			local sgroup = this.defenders_encounter:GetSgroup()
			if SGroup_CountSpawned(sgroup) >= 1 then
				Cmd_MoveToAndDespawn(sgroup, mkr_map_exit)
			end
			
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
			table.remove(t_elefant_rescuesquads, index)
		end
		
	end

	if #t_elefant_rescuesquads == 0 then
		Rule_RemoveMe()
	end
	
end




