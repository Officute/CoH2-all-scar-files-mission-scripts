print("\tLoading Allies file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- OUREN
-- Supplementary File - ALLIES
-- Designer: NJR
-------------------------------------------------------------------------
-------------------------------------------------------------------------



function INIT_Allies()

	Rule_AddOneShot(Allies_InitNorthBridgeAssault, 140)

end
Scar_AddInit(INIT_Allies)





-- set up a bunch of encounters for the allies to gather near the water
function Allies_InitNorthBridgeAssault()
	
	-- have allies "radio in" when they get into position
	Event_Proximity(EventHandler_StartIntel, {intel = EVENTS.NorthBridge_AlliesArrive}, player3, mkr_northbridge_muster3, nil, ANY, 10)
	
	-- monitor for when we have to switch to fighting on the peninsula
	Rule_AddInterval(Allies_JoinTheFightOnThePeninsula, 1)
	
	-- create the small encounter zones
	enc_Allies1 = ENCOUNTERS.Allies_Bridge_Muster1()	-- muster 1 - next to bridge, short range. Ideal for infantry.
	enc_Allies2 = ENCOUNTERS.Allies_Bridge_Muster2()	-- muster 2 - end of bridge. Ideal for vehicles, AT guns.
	enc_Allies3 = ENCOUNTERS.Allies_Bridge_Muster3()	-- muster 3 - waters edge, short range. Ideal for infantry.
--~ 	enc_Allies4 = ENCOUNTERS.Allies_Bridge_Muster4()	-- muster 4 - back row, long range. Ideal for mortars.
--~ 	enc_Allies5 = ENCOUNTERS.Allies_Bridge_Muster5()	-- muster 5 - back row, long range. Ideal for mortars.
	
	-- add rules to drip-feed new units to these encounters
	Rule_AddInterval(Allies_ManageNorthBridge1, 35 * t_difficulty.AlliesSpawnScaler)
	Rule_AddInterval(Allies_ManageNorthBridge2, 44 * t_difficulty.AlliesSpawnScaler)
	Rule_AddDelayedInterval(Allies_ManageNorthBridge3, 20, 35 * t_difficulty.AlliesSpawnScaler)
--~ 	Rule_AddInterval(Allies_ManageNorthBridge4, 42)
--~ 	Rule_AddInterval(Allies_ManageNorthBridge5, 45)
	
end


-- drip-feed new units into allied encounters
function Allies_ManageNorthBridge1()												-- muster 1 - next to bridge, short range. Ideal for infantry.
	
	if Objective_IsComplete(SOBJ_NorthBridge) == true then
		
		Rule_RemoveMe()
		
	elseif SGroup_Count(sg_allies_muster1) < 5 then
		
		local potential_choices = {
			SBP.AEF.RIFLEMEN_SQUAD_MP,
			SBP.AEF.RIFLEMEN_SQUAD_MP,
			SBP.AEF.M1_81MM_MORTAR_SQUAD_MP,
		}
		
		local choice = { sbp = Table_GetRandomItem(potential_choices), spawn = Table_GetRandomItem({mkr_ally_spawn1, mkr_ally_spawn2, mkr_ally_spawn2}) }
		enc_Allies1:AddUnit(choice)
		
		-- restart goal if necessary
		if enc_Allies1:HasGoal() == false then
			enc_Allies1:RestartGoal()
		end
		
	end
	
end

function Allies_ManageNorthBridge2()												-- muster 2 - end of bridge. Ideal for vehicles, AT guns.
	
	if Objective_IsComplete(SOBJ_NorthBridge) == true then
		
		Rule_RemoveMe()
		
	elseif SGroup_Count(sg_allies_muster2) < 4 then
		
		local potential_tanks = {
			SBP.AEF.M4A3_SHERMAN_SQUAD_MP,
			SBP.AEF.M5A1_STUART_SQUAD_MP,
			SBP.AEF.M8_GREYHOUND_SQUAD_MP,
		}
		local potential_infantry = {
			SBP.AEF.RIFLEMEN_SQUAD_MP,
			SBP.AEF.REAR_ECHELON_SQUAD_MP,
		}
		local choice = {}
		
		if SGroup_ContainsBlueprints(sg_allies_muster2, potential_tanks, ANY) == false then
			
			choice = { sbp = Table_GetRandomItem(potential_tanks), spawn = Table_GetRandomItem({mkr_ally_spawn1, mkr_ally_spawn2}) }
			
		else
			
			choice = { sbp = Table_GetRandomItem(potential_infantry), spawn = Table_GetRandomItem({mkr_ally_spawn1, mkr_ally_spawn2}) }
			
		end
		
		enc_Allies2:AddUnit(choice)
		
		-- restart goal if necessary
		if enc_Allies2:HasGoal() == false then
			enc_Allies2:RestartGoal()
		end
		
	end
	
end

function Allies_ManageNorthBridge3()												-- muster 3 - waters edge, short range. Ideal for infantry.
	
	if Objective_IsComplete(SOBJ_NorthBridge) == true then
		
		Rule_RemoveMe()
		
	elseif SGroup_Count(sg_allies_muster3) < 5 then
		
		local potential_choices = {
			SBP.AEF.RIFLEMEN_SQUAD_MP,
			SBP.AEF.RIFLEMEN_SQUAD_MP,
			SBP.AEF.RIFLEMEN_SQUAD_MP,
			SBP.AEF.RIFLEMEN_SQUAD_MP,
			SBP.AEF.M2HB_50CAL_HMG_SQUAD_MP,
		}
		
		local choice = { sbp = Table_GetRandomItem(potential_choices) }
		enc_Allies3:AddUnit(choice)
		
		-- restart goal if necessary
		if enc_Allies3:HasGoal() == false then
			enc_Allies3:RestartGoal()
		end
		
	end
	
end

function Allies_ManageNorthBridge4()												-- muster 4 - back row, long range. Ideal for mortars.
	
	if Objective_IsComplete(SOBJ_NorthBridge) == true then
		
		Rule_RemoveMe()
		
	elseif SGroup_Count(sg_allies_muster4) < 2 then
		
		local potential_choices = {
			SBP.AEF.RIFLEMEN_SQUAD_MP,
			SBP.AEF.RIFLEMEN_SQUAD_MP,
			SBP.AEF.M1_81MM_MORTAR_SQUAD_MP,
		}
		
		local choice = { sbp = Table_GetRandomItem(potential_choices) }
		enc_Allies4:AddUnit(choice)
		
		-- restart goal if necessary
		if enc_Allies4:HasGoal() == false then
			enc_Allies4:RestartGoal()
		end
		
	end
	
end

function Allies_ManageNorthBridge5()												-- muster 5 - back row, long range. Ideal for mortars.
	
	if Objective_IsComplete(SOBJ_NorthBridge) == true then
		
		Rule_RemoveMe()
		
	elseif SGroup_Count(sg_allies_muster5) < 2 then
		
		local potential_choices = {
			SBP.AEF.RIFLEMEN_SQUAD_MP,
			SBP.AEF.RIFLEMEN_SQUAD_MP,
			SBP.AEF.M1_81MM_MORTAR_SQUAD_MP,
		}
		
		local choice = { sbp = Table_GetRandomItem(potential_choices) }
		enc_Allies5:AddUnit(choice)
		
		-- restart goal if necessary
		if enc_Allies5:HasGoal() == false then
			enc_Allies5:RestartGoal()
		end
		
	end
	
end




----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
--                                                                                                                  --
-- The following functions deal with the allies behaviour during the counterattack.                                 --
-- This script takes over and deals will all their behaviour once the northern bridge objective has been completed. --
--                                                                                                                  --
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------

function Allies_JoinTheFightOnThePeninsula()

	if Objective_IsComplete(SOBJ_NorthBridge) then
		
		Rule_RemoveMe()
		
		enc_Allies1:ClearGoal()
		enc_Allies1:Disable()
		
		enc_Allies2:ClearGoal()
		enc_Allies2:Disable()
		
		enc_Allies3:ClearGoal()
		enc_Allies3:Disable()
		
--~ 		enc_Allies4:ClearGoal()
--~ 		enc_Allies4:Disable()
		
--~ 		enc_Allies5:ClearGoal()
--~ 		enc_Allies5:Disable()
		
		-- break down any remaining blockades on the bridge
		EGroup_Kill(eg_northbridge_blockers)
		EGroup_DeSpawn(eg_northbridge_blockers_2)
		Util_ClearWrecksFromMarker(mkr_northbridge_muster2)
		
		-- get all the allied units
		Player_GetAll(player3)
		
		-- bring them into the counterattack fight
		if counterattack_stage == 1 then
			
			enc_AlliedCounterattackStage1 = ENCOUNTERS.Allies_Counterattack_Stage1()
			enc_AlliedCounterattackStage1:AddSgroup(sg_allsquads)
			
		elseif counterattack_stage == 2 then
			
			-- split the group of P3 units in half
			SGroup_Clear(sg_temp)
			for n = 1, math.floor((SGroup_CountSpawned(sg_allsquads) / 2)) do 
				local sid = SGroup_GetRandomSpawnedSquad(sg_allsquads)
				SGroup_Remove(sg_allsquads, sid)
				SGroup_Add(sg_temp, sid)
			end
			
			-- set the first half a new encounter attacking the north area
			enc_AlliedCounterattackStage2North = ENCOUNTERS.Allies_Counterattack_Stage2_North()
			enc_AlliedCounterattackStage2North:AddSgroup(sg_allsquads)
			
			-- set the second half a new encounter attacking the middle area
			enc_AlliedCounterattackStage2Middle = ENCOUNTERS.Allies_Counterattack_Stage2_Middle()
			enc_AlliedCounterattackStage2Middle:AddSgroup(sg_temp)
			
		end
		
		counterattack_allies_have_joined = true
		
		Rule_AddInterval(Counterattack_AlliesTopUp, 44 * t_difficulty.AlliesSpawnScaler)
		
	end
	
end



-- once the allies have been passed on to the counterattack script, this takes over the topping up of units
function Counterattack_AlliesTopUp()
	
	if Objective_IsComplete(OBJ_Counterattack) or Objective_IsFailed(OBJ_Counterattack) then
		
		Rule_RemoveMe()
		
	else
		
		SGroup_Clear(sg_temp)
		Player_GetAll(player3)
		
		local total_units = SGroup_CountSpawned(sg_allsquads)
		
		-- only top up if the allies are less than their cap
		if total_units < t_difficulty.AlliesMaxSize then
			
			local potential_tanks = {
				SBP.AEF.M4A3_SHERMAN_SQUAD_MP,
				SBP.AEF.M5A1_STUART_SQUAD_MP,
				SBP.AEF.M8_GREYHOUND_SQUAD_MP,
			}
			local potential_infantry = {
				SBP.AEF.RIFLEMEN_SQUAD_MP,
				SBP.AEF.REAR_ECHELON_SQUAD_MP,
			}
			local choice = {}
			
			-- now split into two groups: sg_allsquads for the vehicles, and sg_temp for everything else
			SGroup_Filter(sg_allsquads, potential_tanks, FILTER_KEEP)
			local total_vehicles = SGroup_CountSpawned(sg_allsquads)
			
			-- choose vehicle or infantry depending on the proportion of units that are 
			if (total_vehicles / total_units) <= 0.2 then
				
				-- spawn a vehicle
				choice = {
					sbp = Table_GetRandomItem(potential_tanks),
					spawn = Table_GetRandomItem({mkr_ally_spawn1, mkr_ally_spawn2}),
				}
				
			else
				
				-- spawn infantry
				choice = {
					sbp = Table_GetRandomItem(potential_infantry),
					spawn = Table_GetRandomItem({mkr_ally_spawn1, mkr_ally_spawn2, mkr_ally_spawn3}),
				}
				
			end
			
			
			if counterattack_stage == 1 then
				
				-- send the new unit to the only encounter
				enc_AlliedCounterattackStage1:AddUnit(choice)
				
				-- restart goal if necessary
				if enc_AlliedCounterattackStage1:HasGoal() == false then
					enc_AlliedCounterattackStage1:RestartGoal()
				end
				
			elseif counterattack_stage == 2 then
				
				-- figure out the ratio of enemy units to player units in each encounter area
				Team_GetAllSquadsNearMarker(TEAM_ALLIES, sg_temp, mkr_counterattack_north_encounterarea)
				local north_ratio = SGroup_CountSpawned(sg_counterattack_stage2_northencounter) / (math.max(1, SGroup_Count(sg_temp)))
				
				Team_GetAllSquadsNearMarker(TEAM_ALLIES, sg_temp, mkr_counterattack_mid_encounterarea)
				local middle_ratio = SGroup_CountSpawned(sg_counterattack_stage2_midencounter) / (math.max(1, SGroup_Count(sg_temp)))
				
				if north_ratio > middle_ratio then
					
					-- if the north encounter has a higher ratio of enemy units to player units, send the new unit there
					enc_AlliedCounterattackStage2North:AddUnit(choice)
					
					-- restart goal if necessary
					if enc_AlliedCounterattackStage2North:HasGoal() == false then
						enc_AlliedCounterattackStage2North:RestartGoal()
					end
				
				else
					
					-- otherwise send it to the middle encounter
					enc_AlliedCounterattackStage2Middle:AddUnit(choice)
					
					-- restart goal if necessary
					if enc_AlliedCounterattackStage2Middle:HasGoal() == false then
						enc_AlliedCounterattackStage2Middle:RestartGoal()
					end
				
				end
				
			end
			
		end
		
	end
	
end





function Allies_Stop()

	Rule_RemoveIfExist(Allies_ManageNorthBridge1)
	Rule_RemoveIfExist(Allies_ManageNorthBridge2)
	Rule_RemoveIfExist(Allies_ManageNorthBridge3)
	Rule_RemoveIfExist(Allies_ManageNorthBridge4)
	Rule_RemoveIfExist(Allies_ManageNorthBridge5)
	
	Rule_RemoveIfExist(Allies_JoinTheFightOnThePeninsula)
	
	Rule_RemoveIfExist(Counterattack_AlliesTopUp)

end

