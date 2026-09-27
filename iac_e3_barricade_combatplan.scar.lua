-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- E3 Barricade/Beta City17 - Combat plan file
-- Designer: Dr.Epav, with scripting help from Janne252
-- 
--

--
--********************************************************************************************************
------------------------------------------ Main Functions ------------------------------------------------
--********************************************************************************************************
--

function _CombatPlan_Init()
	
	t_CombatPlan = {
		currentId			= 0,
		t_Executing 		= {},
	}
	

end

Scar_AddInit(_CombatPlan_Init)


function _CombatPlan_Rule_ExecutePlan()

	for i=table.getn(t_CombatPlan.t_Executing), 1, -1 do
		if t_CombatPlan.t_Executing[i].remove == true 
		or _CombatPlan_Execute(t_CombatPlan.t_Executing[i].plan, t_CombatPlan.t_Executing[i].id ) == true then
			SGroup_Destroy(t_CombatPlan.t_Executing[i].sg_target)
			SGroup_Destroy(t_CombatPlan.t_Executing[i].sg_actor)
			table.remove(t_CombatPlan.t_Executing, i)
		end
	end
	
end

function _CombatPlan_Execute( plan, planId )

	for k, this in pairs(plan) do
		if this.complete ~= true 
		and SGroup_IsEmpty(this.sgroup) == false then
			this.complete = CombatPlan_EvaluateAction(this, planId)
			return false
		end
	end

	return true

end

-- ** TODO Add ScarDoc Information
function CombatPlan_Add(sgroup, combatPlan, target)
	
	if SGroup_CountSpawned(sgroup) <= 0 then
		print("CombatPlan_Add: SGroup Empty, Not Executing")
		return
	elseif SGroup_CountSpawned(target) <= 0 then
		print("CombatPlan_Add: Target Empty, Not Executing")
		return
	elseif combatPlan == nil then
		fatal("CombatPlan_Add: Combat Plan was nil, Not Executing")
	end
	
	t_CombatPlan.currentId = t_CombatPlan.currentId + 1
	local plan = World_CopyTable(combatPlan)
	
	local sg_combat = SGroup_CreateIfNotFound("_sg_CombatPlan"..t_CombatPlan.currentId)
	SGroup_AddGroup(sg_combat, sgroup)
	local sg_target = SGroup_CreateIfNotFound("_sg_CombatPlanTarget"..t_CombatPlan.currentId)
	SGroup_AddGroup(sg_target, target)

	-- this processes elements of the plan
	for k, this in pairs(plan) do 
		
		this.sgroup = sg_combat
		
		if this.action == "attack" then
			this.target = sg_target
			local swid = SyncWeapon_GetFromSGroup(sgroup)
			if  swid ~= nil then
				this.syncWeapon = swid
			end
		elseif this.action == "use_ability" then
			if this.target == "position" then
				this.target = SGroup_GetPosition(sg_target)
			else
				this.target = sg_target
			end
		end
		
		if this.action == "move" then
			if this.offset ~= nil then
				local start = Util_GetPosition(sgroup)
				local direction = World_GetDirectionPointToPoint(Util_GetPosition(sgroup), Util_GetPosition(target))
				this.target = Vector_Translate(start, this.offset.x, this.offset.y, this.offset.z, direction)
			else
				this.target = Util_GetPosition(target)
			end
		end
	end
	
	local package = {
		id			= t_CombatPlan.currentId,
		plan 		= plan,
		sg_actor	= sg_combat,
		sg_target 	= sg_target, -- track the target so that the SGroup can be destroyed
	}
	
	table.insert(t_CombatPlan.t_Executing, package)
	
	if Rule_Exists(_CombatPlan_Rule_ExecutePlan) == false then
		Rule_AddInterval(_CombatPlan_Rule_ExecutePlan, 3)
	end
	
	return t_CombatPlan.currentId

end

function CombatPlan_IsExecuting(id)

	if id == nil then
		return false
	end
	
	for i=table.getn(t_CombatPlan.t_Executing), 1, -1 do
		if t_CombatPlan.t_Executing[i].id == id then
			return true
		end
	end
	
	return false

end

function CombatPlan_EvaluateAction(actionStep, planId)

	local action = actionStep.action
	local actor = actionStep.sgroup
	local target = actionStep.target
	local ability = actionStep.ability
	local wait	= actionStep.waitTime
	local syncWeapon = actionStep.syncWeapon
	
	-- if the actor is dead who is supposed to perform the plan
	-- then indicate that all the actions are complete.
	if SGroup_CountSpawned(actor) <= 0 then
		return true
	end
	
	-- attempts, ensures that each action step only performs a number of attempts
	-- and doesn't get stuck trying to do something impossible
	if action ~= "pause" then
		if actionStep.attempts == nil then
			actionStep.attempts = 0
			actionStep.lastAttempt = 0
		elseif actionStep.attempts <= 25 then
			actionStep.lastAttempt = actionStep.attempts
			actionStep.attempts = actionStep.attempts + 1
		else
			return true
		end
	end
	
	-- different types of possible actions
	--[[
	if action == "flank" then
		-- actor would choose to move to a specified flank of the target
	if action == "retreat" then
		-- actor would retreat to a specified location
	if action == "new_plan" then
		-- actor would take on an entirely new plan
	if action == "repair" then
		-- actor would repair the target
	if action == "construct" then 
		-- the actor could construct the specified EBP
	if action == "repeat" then
		-- the actor would repeat the same steps for the plan,
		-- all over again
	if action == "hide" then
		-- the actor would hide (this might be contained within the ability use section)
	if action == "garrison" then
		-- the actor would garrison any nearby buildings
	
	-- additional improvements:
		-- failure, if for some reason a particular step in the plan is not happening, there
		-- needs to be a fall back behavior to order the actor to give up and move on to the next element
		
	]]

	if action == "attack" then
		
		-- ensure that the soldiers don't give up on
		-- attacking if they are moving into position.
		if SGroup_IsMoving(actor, ANY) == true then
			actionStep.attempts = actionStep.lastAttempt
			return false
		-- checks to ensure that the primary weapon (team weapon) is 
		-- attacking, and not just any squad member.
		elseif (syncWeapon ~= nil 
			and SyncWeapon_Exists(syncWeapon) == true 
			and SyncWeapon_IsAttacking(syncWeapon, 2) == false)
		-- or if the any squad member is attacking
		or SGroup_IsDoingAttack(actor, ANY, 2) == false then
			
			if scartype(target) == ST_SGROUP
			and SGroup_IsEmpty(target) then
				return true
			end
			
			if scartype(target) == ST_EGROUP
			and EGroup_IsEmpty(target) then
				return true
			end
			
			Cmd_AttackMove(actor, target)
			
			return false
		else
			-- indicate that the action is complete
			return true
		end
	elseif action == "ungarrison" then
		
		if SGroup_IsInHoldEntity(actor, ANY)
		or SGroup_IsInHoldSquad(actor, ANY) then
			Cmd_UngarrisonSquad(actor)
			return false
		else
			-- indicate that the action is complete
			return true
		end

	elseif action == "garrison" then
		
		if SGroup_IsInHoldEntity(actor, ALL) == false then
			Util_GarrisonNearbyBuilding(actor, Util_GetPosition(actor), 50)
			return false
		else
			-- indicate that the action is complete
			return true
		end
		
	elseif action == "find cover" then
		
		-- grow the search radius each time
		-- this is run to ensure that squads are in cover
		if SGroup_IsInCover(actor) < 0.5 then
			Cmd_Move(actor, Util_GetPosition(actor), nil, nil, nil, nil, nil, 20) 
			return false
		else
			return true
		end
		
	elseif action == "move" then
		
		if Prox_AreSquadsNearMarker(actor, target, ANY, 5) == false then
			if SGroup_IsMoving(actor, ANY) == false then
				Cmd_Move(actor, target)
			end
			return false
		else
			-- indicate that the action is complete
			return true
		end
		
	elseif action == "pause" then
		
		local timerId = "__CombatPlan"..planId
		if Timer_Exists( timerId ) == false then
			Timer_Start( timerId, wait)
			return false
		elseif Timer_GetRemaining( timerId ) > 0 then
			return false
		else
			-- indicate that the action is complete
			return true
		end
		
	elseif action == "use_ability" then
		
		if SGroup_IsDoingAbility(actor, ability, ANY) == false then
				Cmd_Ability(actor, ability, target, nil, true)
			return false
		else
			-- indicate that the action is complete
			return true
		end
		
	elseif action == "retreat" then
		
		if SGroup_IsRetreating(actor, ANY) == false then
			if scartype(target) == ST_SCARPOS
			or scartype(target) == ST_MARKER then
				Cmd_Retreat(actor, target)
			else
				Cmd_Retreat(actor)
			end
			return false
		else
			return true
		end
	else
		print("CombatPlan_EvaluateAction >>> Invalid Action:  "..action)
		return true
	end

end

-- ** TODO Add ScarDoc
function CombatPlan_Remove(id)

	for i=table.getn(t_CombatPlan.t_Executing), 1, -1 do
		if t_CombatPlan.t_Executing[i].id == id then
			t_CombatPlan.t_Executing[i].remove = true
		end
	end

end

-- this function will translate a point based on the origin of a point
-- and the direction you want the squads to head.
function Vector_Translate(start_pos, x_offset, y, z_offset, dir)
	
	-- we do not translate the y_offset, we just let the game recalculate that information
	-- based on the height of the terrain at the new position
	local x = start_pos.x + (x_offset * dir.z) + (z_offset * dir.x)
	local z = start_pos.z - (x_offset * dir.x) + (z_offset * dir.z)
	local pos = World_Pos(x, start_pos.y, z)
	
	return pos

end

function World_GetDirectionPointToPoint(a, b)

	-- if either a or b are markers, convert them to positions
	if (scartype(a) == ST_MARKER) then
		a = Marker_GetPosition(a)
	end
	if (scartype(b) == ST_MARKER) then
		b = Marker_GetPosition(b)
	end
	
	if scartype(a) ~= ST_SCARPOS then fatal("World_GetDirectionPointToPoint: Position A invalid") end
	if scartype(b) ~= ST_SCARPOS then fatal("World_GetDirectionPointToPoint: Position B invalid") end
	
	local distBetweenPoints = World_DistancePointToPoint(a, b)
	
	if (distBetweenPoints > 0.05) then
				
		local deltax = (b.x - a.x) / distBetweenPoints
		local deltay = (b.y - a.y) / distBetweenPoints
		local deltaz = (b.z - a.z) / distBetweenPoints
		
		return World_Pos(deltax, deltay, deltaz)
		
	end
	
	-- failsafe
	print("*** WARNING in World_GetDirectionPointToPoint: Positions A and B are too close together to function properly ***")
	return a

end

--
--********************************************************************************************************
-------------------------------------------- Plan Data ---------------------------------------------------
--********************************************************************************************************
--

COMBAT_PLAN = {

	GENERIC = {
		ALL	= {
			-- special combat plan that can be referenced if you want to use the combat plan system,
			-- but you don't actually want the squads to perform any type of action.
			DoNothing = {
				{
					action 		= "pause",			
					waitTime	= 10,
				},
			},
			Attack = {
				{
					action 		= "attack",			
				},
				{
					action 		= "pause",			
					waitTime	= 5,
				},
			},
		},
		TANK = {
			FlankingDoubleAttack = {
				{
					action 		= "move",			
					offset		= {x = -15, y = 0, z = 0},
				},
				{
					action 		= "move",			
					offset		= {x = -15, y = 0, z = 40},
				},
				{
					action 		= "move",			
					offset		= {x = 0, y = 0, z = 40},
				},
				{
					action 		= "attack",			
				},
				{
					action 		= "pause",			
					waitTime	= 10,
				},
				{
					action 		= "move",			
					offset		= {x = 0, y = 0, z = 0},
				},
				{
					action 		= "move",			
					offset		= {x = 0, y = 0, z = -15},
				},
				{
					action 		= "attack",			
				},
			},
			RepeatedWithdrawAndAssault = {
				{
					action 		= "move",			
					offset		= {x = 0, y = 0, z = -15},
				},
				{
					action 		= "pause",			
					waitTime	= 5,
				},
				{
					action 		= "move",			
					offset		= {x = -20, y = 0, z = 10},
				},
				{
					action 		= "attack",			
				},
				{
					action 		= "pause",			
					waitTime	= 10,
				},
				{
					action 		= "move",			
					offset		= {x = -20, y = 0, z = -15},
				},
				{
					action 		= "pause",			
					waitTime	= 5,
				},
				{
					action 		= "move",			
					offset		= {x = 20, y = 0, z = 20},
				},
				{
					action 		= "attack",			
				},
				{
					action 		= "pause",			
					waitTime	= 10,
				},
			},
		},
		VEHICLE = {
			Withdraw = {
				{
					action 		= "move",			
					offset		= {x = 0, y = 0, z = -15},
				},
				{
					action 		= "pause",			
					waitTime	= 5,
				},
			},
			MaximizeRange = {
				{
					action 		= "attack",			
				},
				{
					action 		= "pause",			
					waitTime	= 5,
				},
				{
					action 		= "move",			
					offset		= {x = 0, y = 0, z = -25},
				},
				{
					action 		= "attack",			
				},
				{
					action 		= "pause",			
					waitTime	= 15,
				},
			},
			FlankLeftFront = {
				{
					action 		= "move",			
					offset		= {x = -20, y = 0, z = 0},
				},
				{
					action 		= "attack",			
				},
				{
					action 		= "pause",			
					waitTime	= 15,
				},
			},
			FlankRightFront = {
				{
					action 		= "move",			
					offset		= {x = 20, y = 0, z = 0},
				},
				{
					action 		= "attack",			
				},
				{
					action 		= "pause",			
					waitTime	= 15,
				},
			},
			FlankLeftBehind = {
				{
					action 		= "move",			
					offset		= {x = -15, y = 0, z = 0},
				},
				{
					action 		= "move",			
					offset		= {x = -15, y = 0, z = 40},
				},
				{
					action 		= "move",			
					offset		= {x = 0, y = 0, z = 40},
				},
				{
					action 		= "attack",			
				},
				{
					action 		= "pause",			
					waitTime	= 15,
				},
			},
			FlankRightBehind = {
				{
					action 		= "move",			
					offset		= {x = 15, y = 0, z = 0},
				},
				{
					action 		= "move",			
					offset		= {x = 15, y = 0, z = 40},
				},
				{
					action 		= "move",			
					offset		= {x = 0, y = 0, z = 40},
				},
				{
					action 		= "attack",			
				},
				{
					action 		= "pause",			
					waitTime	= 15,
				},
			},
		},
		INFANTRY = {
			FaceAttacker = {
				{
					action 		= "move",			
					offset		= {x = 0, y = 0, z = 5},
				},
				{
					action 		= "attack",			
				},
				{
					action 		= "pause",			
					waitTime	= 5,
				},
			},
			FindCover = {
				{
					action 		= "find cover",				
				},
				{
					action 		= "pause",			
					waitTime	= 15,
				},
			},
			CloseDistance = {
				{
					action 		= "ungarrison",				
				},
				{
					action 		= "move",			
				},
				{
					action 		= "attack",			
				},
				{
					action 		= "pause",			
					waitTime	= 10,
				},
			},
			UngarrisonAndAttack = {
				{
					action 		= "ungarrison",				
				},
				{
					action 		= "attack",			
				},
				{
					action 		= "pause",			
					waitTime	= 15,
				},
			},
			GarrisonNearTarget = {
				{
					action 		= "ungarrison",				
				},
				{
					action 		= "pause",			
					waitTime	= 5,
				},
				{
					action 		= "move",
				},
				{
					action 		= "garrison",			
				},
				{	-- if this action is continually run over and over again, then 
					-- make sure that they at least pause before getting out of the building
					action 		= "pause",			
					waitTime	= 20,
				},				
			},
			FindCoverAndAttack = {
				{
					action = "ungarrison",				
				},
				{
					action 		= "find cover",	
				},
				{
					action 		= "pause",			
					waitTime	= 10,
				},
				{
					action 		= "attack",			
				},					
			},
			UngarrisonAndFanOutLeft = {
				{
					action = "ungarrison",				
				},
				{
					action 		= "move",			
					offset		= {x = -15, y = 0, z = 5},
				},
				{
					action 		= "find cover",
				},
				{
					action 		= "attack",			
				},
			},
			UngarrisonAndFanOutRight = {
				{
					action = "ungarrison",				
				},
				{
					action 		= "move",			
					offset		= {x = 15, y = 0, z = 5},
				},
				{
					action 		= "find cover",	
				},
				{
					action 		= "attack",			
				},
			},
			FightingWithdrawal = {
				{
					action = "ungarrison",				
				},
				{
					action 		= "move",			
					offset		= {x = 0, y = 0, z = -15},
				},
				{
					action 		= "find cover",	
				},
				{
					action 		= "pause",			
					waitTime	= 3,
				},
				{
					action 		= "move",			
					offset		= {x = 0, y = 0, z = -30},
				},
				{
					action 		= "find cover",	
				},
				{
					action 		= "pause",			
					waitTime	= 3,
				},				
			},
			FightingWithdrawalToBuilding = {
				{
					-- this is placed here to ensure that the infantry don't get out of the building too quickly
					action 		= "pause",			
					waitTime	= 8,
				},
				{
					action = "ungarrison",				
				},
				{
					action 		= "move",			
					offset		= {x = 0, y = 0, z = -15},
				},
				{
					action 		= "pause",			
					waitTime	= 5,
				},
				{
					action 		= "move",			
					offset		= {x = 0, y = 0, z = -30},
				},
				{
					action 		= "pause",			
					waitTime	= 5,
				},
				{
					action 		= "garrison",			
				},					
			},
			DelayedRetreat = {
				{
					action = "ungarrison",				
				},
				{
					action 		= "find cover",	
				},
				{
					action 		= "pause",			
					waitTime	= 10,
				},
				{
					action 		= "retreat",			
				},					
			},
		},
	},
	
	AXIS = {
		GRENADIER = {
			ThrowGrenade = {
				{
					action		= "use_ability",	
					ability 	= ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY,
				},
				{
					action 		= "pause",			
					waitTime	= 5,
				},
				{
					action 		= "find cover",
				},
				{
					action 		= "attack",			
				},
			},
			FlankLeftThrowGrenade = {
				{
					action 		= "move",			
					offset		= {x = -15, y = 0, z = 20},
				},
				{
					action 		= "pause",			
					waitTime	= 5,
				},
				{
					action		= "use_ability",	
					ability 	= ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY,
				},
				{
					action 		= "find cover",
				},
				{
					action 		= "attack",			
				},
			},
			FlankRightThrowGrenade = {
				{
					action 		= "move",			
					offset		= {x = 15, y = 0, z = 20},
				},
				{
					action 		= "pause",			
					waitTime	= 5,
				},
				{
					action		= "use_ability",	
					ability 	= ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY,
				},
				{
					action 		= "find cover",
				},
				{
					action 		= "attack",			
				},
			},
		},
		PANZER = {
			RetreatAndFlankLeft = {
				{
					action 		= "move",			
					offset		= {x = 0, y = 0, z = -15},
				},
				{
					action 		= "move",			
					offset		= {x = -20, y = 0, z = -15},
				},
				{
					action 		= "move",			
					offset		= {x = -20, y = 0, z = 30},
				},
				{
					action 		= "pause",			
					waitTime	= 7,
				},
				{
					action 		= "attack",			
				},
			},
			RetreatAndFlankRight = {
				{
					action 		= "move",			
					offset		= {x = 0, y = 0, z = -15},
				},	
				{
					action 		= "move",			
					offset		= {x = -20, y = 0, z = -15},
				},
				{
					action 		= "move",			
					offset		= {x = -20, y = 0, z = 30},
				},
				{
					action 		= "attack",			
				},
			},
			
			FanOutRightAssault = {
				{
					action 		= "move",			
					offset		= {x = 0, y = 0, z = -15},
				},
				{
					action 		= "move",			
					offset		= {x = 70, y = 0, z = -15},
				},
				{
					action 		= "pause",			
					waitTime	= 5,
				},
				{
					action 		= "move",			
					offset		= {x = 70, y = 0, z = 50},
				},
				{
					action 		= "pause",			
					waitTime	= 10,
				},
				{
					action 		= "attack",			
				},
				{
					action 		= "pause",			
					waitTime	= 10,
				},
			},
			
			FanOutLeftAssault = {
				{
					action 		= "move",			
					offset		= {x = 0, y = 0, z = -15},
				},
				{
					action 		= "move",			
					offset		= {x = -70, y = 0, z = -15},
				},
				{
					action 		= "pause",			
					waitTime	= 10,
				},
				{
					action 		= "move",			
					offset		= {x = -70, y = 0, z = 50},
				},
				{
					action 		= "pause",			
					waitTime	= 10,
				},
				{
					action 		= "attack",			
				},
				{
					action 		= "pause",			
					waitTime	= 10,
				},
			},
		},
		SNIPER = {
			FlareManeuver = {
				{
					action		= "use_ability",	
					ability 	= ABILITY.GERMAN.JAEGER_FLARE_MP,
				},
				{
					action 		= "pause",			
					waitTime	= 5,
				},
				{
					action 		= "move",			
					offset		= {x = 0, y = 0, z = -5},
				},
				{
					action 		= "pause",			
					waitTime	= 7,
				},
			},
		},
	},
}

---------------------------
-- End of generic plan data
---------------------------
-- Unique data for E3_Barricade
---------------------------

	t_CombatPlanBarricade = {
	{
				{
					action 		= "pause",			
					waitTime	= 4,
				},
				{
					action 		= "ungarrison",				
				},
				{
					action 		= "move",
					offset		= {x = 0, y = 0, z = 15},					
				},
				{
					action 		= "attack",			
				},
				{
					action 		= "pause",			
					waitTime	= 10,
				},				
			},
	{
				{
					action 		= "attack",			
				},
				{
					action 		= "find cover",	
				},
				{
					action 		= "pause",			
					waitTime	= 6,
				},				
			},
	{
				{
					action 		= "pause",			
					waitTime	= 6,
				},
				{
					action 		= "find cover",	
				},
				{
					action 		= "attack",			
				},				
			},
	{
				{
					action 		= "pause",			
					waitTime	= 5,
				},
				{
					action		= "use_ability",	
					ability 	= BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_grenadier_rifle_grenade"),
				},
				{
					action 		= "find cover",
				},
				{
					action 		= "attack",			
				},
			},
	{
				{
					action 		= "pause",			
					waitTime	= 4,
				},
				{
					action 		= "find cover",
				},
				{
					action 		= "attack",
				},
				{
					action 		= "pause",			
					waitTime	= 4,		
				},
				{
					action 		= "move",
					offset		= {x = 0, y = 0, z = 10},
				},
				{
					action 		= "attack",
				},
			},
		}
	
		Plan_Test = {
				{
					action 		= "pause",			
					waitTime	= 4,
				},
				{
					action 		= "find cover",
				},
				{
					action 		= "attack",
				},
				{
					action 		= "pause",			
					waitTime	= 6,		
				},
				{
					action 		= "move",
					offset		= {x = 0, y = 0, z = 10},
				},
				{
					action 		= "attack",
				},
			}

