-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- MISSION NAME: Volga Timber Yard - Soviet
-- Designer: Sacha Narine
-- Description: Use anti-air halftracks to shoot down enemy planes

-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScarUtil.scar")
import("TheatreOfWar.scar")
import("Systems/AiManager/ai.scar")
import("Prototype/DeploymentPoints.scar")

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------

function OnGameSetup()
--
end



function OnGameRestore()
	Game_DefaultGameRestore()
end


-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------

function OnInit()
	
	player1 = World_GetPlayerAt(1) -- First human player
	player2 = World_GetPlayerAt(2) -- First enemy player
	player3 = World_GetPlayerAt(3) -- Second human player
	player4 = World_GetPlayerAt(4) -- Second enemy player
	
	TEAM_ENEMY = Player_GetTeam(player2)
	
	sg_p_all = SGroup_CreateIfNotFound("sg_p_all")
	sg_e_all = SGroup_CreateIfNotFound("sg_e_all")
	sg_halftrack_p1 = SGroup_CreateIfNotFound("sg_halftrack_p1")
	sg_halftrack_p3 = SGroup_CreateIfNotFound("sg_halftrack_p3")
	sg_planes = SGroup_CreateIfNotFound("sg_planes")
	sg_planes_already_modified = SGroup_CreateIfNotFound("sg_planes_already_modified")
	sg_air_targets = SGroup_CreateIfNotFound("sg_air_targets")
	
	eg_temp = EGroup_CreateIfNotFound("eg_temp")
	
	Mission_Difficulty()
	
	
	t_germans = {}
	for i=1,World_GetPlayerCount() do
		
		local player = World_GetPlayerAt(i)
		
		-- set tech limitations for this mission
		ToW_SetUpTechTreeByYear(player,1943)
		ToW_SetStandardResources (player)
		
		if Player_GetRaceName(player) == "soviet" then			-- Player / Ally
			
			-- AI buddy on the player's side
			if AI_IsAIPlayer(player) then
				AI_SetPersonality( player, "tow_1943_ai_battle_volgatimber_soviet_ally")	-- inlcudes economy to encourage building AA-upgraded halftracks
			end
			if Player_IsHuman(player) == false then
				Setup_SetPlayerName(player, 11038758)
			end
			
			-- settings for the allied side 
			Player_SetResource(player, RT_Command, 1)
			Player_SetResource(player, RT_Manpower, t_difficulty.playerStartingManpower)
			Player_SetResource(player, RT_Munition, t_difficulty.playerStartingMunitions)
			Player_SetResource(player, RT_Fuel, t_difficulty.playerStartingFuel)
			
		elseif Player_GetRaceName(player) == "german" then		-- Enemy
			
			table.insert (t_germans, player)			
			
			if Player_IsHuman(player) == false then
				Setup_SetPlayerName(player, 11038759)
			end
			
			-- other upgrades / settings
			Cmd_InstantUpgrade(player, UPG.GERMAN.STUKA_FRAGMENTATION_BOMB)
			Cmd_InstantUpgrade(player, UPG.GERMAN.STUKA_CLOSE_AIR_SUPPORT)
			Player_AddAbility(player, ABILITY.GERMAN.STUKA_AIR_RECON)
			Player_AddAbility(player, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB)
			Player_AddAbility(player, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT)
			Player_SetAbilityAvailability(player, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB, ITEM_UNLOCKED)
			Player_SetAbilityAvailability(player, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT, ITEM_UNLOCKED)
			
		end
		
	end
	
	
	-- kick off ToW objective
	ToW_SetUpBattleObjectives ()
	
	
	
	--
	-- Spawns
	--
	
	-- MG halftrack for both Soviet players
	Util_CreateSquads(player1, sg_halftrack_p1, SBP.SOVIET.M5_HALFTRACK_SQUAD_MP, mkr_aaTruck1, nil, nil, nil, nil, nil, UPG.SOVIET.M5_HALFTRACK_72K_AA_GUN_PACKAGE_MP)
	Util_CreateSquads(player3, sg_halftrack_p3, SBP.SOVIET.M5_HALFTRACK_SQUAD_MP, mkr_aaTruck2, nil, nil, nil, nil, nil, UPG.SOVIET.M5_HALFTRACK_72K_AA_GUN_PACKAGE_MP)
	
	if Game_GetLocalPlayer() == player1 then
		hint_halftrackp1 = HintPoint_Add(sg_halftrack_p1, true, 11056096) -- "Use the upgraded M5 Halftrack to shoot down enemy aircraft"
		Event_Timer(EventHandler_RemoveHint, {hint = hint_halftrackp1}, 30)
	end
	if Game_GetLocalPlayer() == player3 then
		hint_halftrackp3 = HintPoint_Add(sg_halftrack_p3, true, 11056096) -- "Use the upgraded M5 Halftrack to shoot down enemy aircraft"
		Event_Timer(EventHandler_RemoveHint, {hint = hint_halftrackp3}, 30)
	end
	
	
	-- Grant both players the Tankoviy Battalion Command building to produce more halftracks
	if g_difficulty ~= GD_HARD then
		Util_CreateEntities(player1, eg_temp, EBP.SOVIET.MOTORPOOL_MP, mkr_baseBuilding2, 1)
		Util_CreateEntities(player3, eg_temp, EBP.SOVIET.MOTORPOOL_MP, mkr_baseBuilding1, 1)
	end
	
	-- enemy AT guns
	Util_CreateSquads(player2, sg_e_all, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, mkr_enemyAT1)
	Util_CreateSquads(player4, sg_e_all, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, mkr_officerSpawn2)
	
	
	
	--
	-- Halftrack Bonuses
	--
	
	-- Make Soviet halftracks cheaper to produce and upgrade
	Modify_EntityCost(player1, EBP.SOVIET.M5_HALFTRACK_MP, RT_Manpower, -20)
	Modify_EntityCost(player1, EBP.SOVIET.M5_HALFTRACK_MP, RT_Fuel, -10)
	Modify_SetUpgradeCost(player1, UPG.SOVIET.M5_HALFTRACK_72K_AA_GUN_PACKAGE_MP, RT_Munition, 30)
	
	Modify_EntityCost(player3, EBP.SOVIET.M5_HALFTRACK_MP, RT_Manpower, -20)
	Modify_EntityCost(player3, EBP.SOVIET.M5_HALFTRACK_MP, RT_Fuel, -10)
	Modify_SetUpgradeCost(player3, UPG.SOVIET.M5_HALFTRACK_72K_AA_GUN_PACKAGE_MP, RT_Munition, 30)
	
	-- Kick off enemy airplane global abilities
	Airplane_Init()	
	
end

Scar_AddInit(OnInit)




function Mission_Difficulty()	
	
	g_difficulty = Game_GetSPDifficulty() 
	
	t_difficulty = {						-- Easy, Medium, Hard
		playerStartingManpower 	 = Util_DifVar( {500, 350, 250} ), 
		playerStartingMunitions  = Util_DifVar( {150, 100, 50} ), 
		playerStartingFuel 		 = Util_DifVar( {75, 50, 25} ), 
		initialPlaneDelay		 = Util_DifVar( {6, 4, 2} ) * 60, 
		delayBetweenPlanes		 = Util_DifVar( {5, 3.5, 2} ) * 60,
		strafingUnlock			 = Util_DifVar( {7.5, 5,  2.5} ) * 60,
		bombingUnlock			 = Util_DifVar( {15,  10, 5} )   * 60,
		planeArmorNerf			 = Util_DifVar( {0.001, 0.0025, 0.005} ),  -- Airplanes have 1000 armor by default!
		munitionsReward 		 = Util_DifVar( {80, 40, 20} ),
		fuelReward 				 = Util_DifVar( {40, 20, 10} ),
	}
	
end




--- Enemy Airplanes
function Airplane_Init()

	t_planeAbilities = {ABILITY.GERMAN.STUKA_AIR_RECON}
	
	Rule_AddOneShot(Airplane_Recon1, 15)
	Rule_AddOneShot(Airplane_Recon2, 105)
	Rule_AddOneShot(Airplane_Rule, t_difficulty.initialPlaneDelay)
	Rule_AddOneShot(Airplane_UnlockStrafingRun, t_difficulty.strafingUnlock)
	Rule_AddOneShot(Airplane_UnlockBombingRun, t_difficulty.bombingUnlock)
	Rule_AddInterval(Airplane_ModifyArmor, 2)
	
	-- Track planes killed by either human player
	-- Grant resources for each plane shot down
	Rule_AddGlobalEvent(Airplane_Bounty, GE_EntityKilled)
	
end


-- Trigger German airplane abilities periodically
-- Air recon, fragmentation bomb, close air support
function Airplane_Rule()
	
	Rule_RemoveMe()
	
	-- pick an ability 
	local ability = Table_GetRandomItem(t_planeAbilities)
	
	if ability == ABILITY.GERMAN.STUKA_AIR_RECON then
		
		-- find the greatest concentraion of p1 or p3 squads, and send a recon plane that way
		SGroup_Clear(sg_air_targets)
		local concentration_p1 = Player_GetSquadConcentration(player1)
		local concentration_p3 = Player_GetSquadConcentration(player3)
		if scartype(concentration_p1) == ST_SGROUP then
			SGroup_AddGroup(sg_air_targets, concentration_p1)
		end
		if scartype(concentration_p3) == ST_SGROUP then
			SGroup_AddGroup(sg_air_targets, concentration_p3)
		end
		
		local target = nil
		if SGroup_CountSpawned(sg_air_targets) >= 1 then
			target = SGroup_GetRandomSpawnedSquad(sg_air_targets)
		end
		
		if target ~= nil and scartype(target) == ST_SQUAD then
			
			Cmd_Ability(player2, ability, Util_GetPosition(target), nil, true)
			
			-- add a delay before the next plane
			Rule_AddOneShot(Airplane_Rule, t_difficulty.delayBetweenPlanes + World_GetRand(0, 60) - 30 )
			
		else
			Rule_AddOneShot(Airplane_Rule, 3)
		end
		
	else
		
		-- get all p1 and p3 squads that the enemy can see
		SGroup_Clear(sg_air_targets)
		SGroup_AddGroup(sg_air_targets, Player_GetSquads(player1))
		SGroup_AddGroup(sg_air_targets, Player_GetSquads(player3))
		
		local findTarget = function (gid, idx, squad)
			if Player_CanSeeSquad(player2, squad, ANY) == false then
				SGroup_Remove(gid, squad)
			end
		end
		SGroup_ForEach(sg_air_targets, findTarget)
		
		-- pick a random target
		local target = nil
		if ability == ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT then
			target = FindInfantryConcentration(sg_air_targets)
			if target == nil then
				target = FindVehicleConcentration(sg_air_targets)
			end
		elseif ability == ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB then
			target = FindVehicleConcentration(sg_air_targets)
			if target == nil then
				target = FindInfantryConcentration(sg_air_targets)
			end
		end
		
		if target ~= nil then
			
			-- pick an ability and cast it
			Cmd_Ability(player2, ability, Util_GetPosition(target), nil, true)
			
			-- add a delay before the next plane
			Rule_AddOneShot(Airplane_Rule, t_difficulty.delayBetweenPlanes + World_GetRand(0, 60) - 30 )
			
		else
			Rule_AddOneShot(Airplane_Rule, 3)
		end
		
	end
	
end

-- Air Recon is called twice early in the mission
-- To show the MG halftrack shooting at planes
function Airplane_Recon1()
	Cmd_Ability(player2, ABILITY.GERMAN.STUKA_AIR_RECON, mkr_recon1, nil, true)
end

function Airplane_Recon2()
	Cmd_Ability(player2, ABILITY.GERMAN.STUKA_AIR_RECON, mkr_recon2, nil, true)
end

-- After X minutes, unlock the other two German airplane abilities
function Airplane_UnlockStrafingRun()
	table.insert(t_planeAbilities, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT)
end
function Airplane_UnlockBombingRun()
	table.insert(t_planeAbilities, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB)
end





-- This makes airplanes easier to shoot down
-- Airplanes have 1000 armor by default!
function Airplane_ModifyArmor()

	-- get everything
	SGroup_Clear(sg_planes)
	local player2Squads = Player_GetSquads(player2)
	SGroup_AddGroup(sg_planes, player2Squads)
	local player4Squads = Player_GetSquads(player4)
	SGroup_AddGroup(sg_planes, player4Squads)	
	
	-- remove things on the ground
	local _CheckInSky = function (gid, idx, squad)
		local squadPos = Squad_GetPosition(squad)
		if squadPos.y < 50 then
			SGroup_Remove(sg_planes, squad)
		end
	end
	SGroup_ForEach(sg_planes, _CheckInSky)
	
	-- remove units dealt with previously
	SGroup_RemoveGroup(sg_planes, sg_planes_already_modified)
	
	-- anyone left?	
	if not SGroup_IsEmpty(sg_planes) then
		Modify_Armor(sg_planes, t_difficulty.planeArmorNerf, true)
		SGroup_AddGroup(sg_planes_already_modified, sg_planes)
	end
	
end



-- Airplane Bounty
-- If either Soviet player kills an enemy plane, grant munitions
function Airplane_Bounty(entityVictim, entityKiller)

	-- make sure everything is valid
	if entityVictim ~= nil and entityKiller ~= nil then
		if Entity_IsValid(Entity_GetGameID(entityVictim)) and Entity_IsValid(Entity_GetGameID(entityKiller)) then
			
			-- make sure that the killer was one of the allies
			if Util_GetPlayerOwner(entityKiller) == player1 or Util_GetPlayerOwner(entityKiller) == player3 then
				
				print("********** Victim: " .. BP_GetName(Entity_GetBlueprint(entityVictim)))
				print("********** Killer: " .. BP_GetName(Entity_GetBlueprint(entityKiller)))
				
				-- check the victim is of the appropriate EBP
				local planeBPs = {"stuka_air_recon",  "stuka_fragementation_bomb", "stuka_ju87_anti_tank"} 
				local victimBP = BP_GetName(Entity_GetBlueprint(entityVictim))
				if Table_Contains(planeBPs, victimBP) then 
					
					-- show a message
					local message = Loc_FormatText(11054472, Loc_ConvertNumber(t_difficulty.munitionsReward), Loc_ConvertNumber(t_difficulty.fuelReward))		-- "Airplane Destroyed: + Munitions + Fuel"
					Util_MissionTitle(message) 
					
					-- and add the resource bonusses
					Player_AddResource(player1, RT_Munition, t_difficulty.munitionsReward)
					Player_AddResource(player1, RT_Fuel, t_difficulty.fuelReward)
					
					Player_AddResource(player3, RT_Munition, t_difficulty.munitionsReward)
					Player_AddResource(player3, RT_Fuel, t_difficulty.fuelReward)
					
				end
			end
		end
		
	end
end




function FindInfantryConcentration(group)

	local group_copy = SGroup_CreateIfNotFound("group_copy")
	local list = {
		SBP.SOVIET.BASE_CONSCRIPT_SQUAD_MP,
		SBP.SOVIET.COMBAT_ENGINEER_SQUAD_MP,
		SBP.SOVIET.CONSCRIPT_SQUAD_MP,
		SBP.SOVIET.COMMISSAR_SQUAD_MP,
		SBP.SOVIET.DSHK_38_HMG_SQUAD_MP,
		SBP.SOVIET.GUARDS_TROOPS_MP,
		SBP.SOVIET.HM_120_38_MORTAR_SQUAD_MP,
		SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD_MP,
		SBP.SOVIET.M1931_203MM_B_4_HOWITZER_ARTILLERY_MP,
		SBP.SOVIET.M1937_152MM_ML_20_ARTILLERY_MP,
		SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD_MP,
		SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP,
		SBP.SOVIET.PENAL_BATTALION_MP,
		SBP.SOVIET.PM_82_41_MORTAR_SQUAD_MP,
		SBP.SOVIET.SHOCK_TROOPS_MP,
		SBP.SOVIET.SNIPER_TEAM_MP,
		SBP.SOVIET.SOVIET_OFFICER_SQUAD_MP,
	}
	
	SGroup_Clear(group_copy)
	SGroup_AddGroup(group_copy, group)
	SGroup_Filter(group_copy, list, FILTER_KEEP)
	
	return FindConcentration(group_copy)
	
end
function FindVehicleConcentration(group)

	local group_copy = SGroup_CreateIfNotFound("group_copy")
	local list = {
		SBP.SOVIET.ISU_152_MP,
		SBP.SOVIET.IS_2_MP,
		SBP.SOVIET.KATYUSHA_BM_13N_SQUAD_MP,
		SBP.SOVIET.KV_1_COMMANDER_MP,
		SBP.SOVIET.KV_1_MP,
		SBP.SOVIET.KV_2_MP,
		SBP.SOVIET.KV_8_MP,
		SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD_MP,
		SBP.SOVIET.M5_HALFTRACK_SQUAD_MP,
		SBP.SOVIET.SU_76M_MP,
		SBP.SOVIET.SU_85_MP,
		SBP.SOVIET.T_34_76_SQUAD_MP,
		SBP.SOVIET.T_70M_MP,
		SBP.SOVIET.T_34_85_SQUAD_MP,
		SBP.SOVIET.T_34_85_ADVANCED_SQUAD_MP,
	}
	
	SGroup_Clear(group_copy)
	SGroup_AddGroup(group_copy, group)
	SGroup_Filter(group_copy, list, FILTER_KEEP)
	
	return FindConcentration(group_copy)
	
end



function FindConcentration(group)
	
	local best_position = nil 
	local best_score = 0 
	
	local _ScoreSquad = function(gid, idx, sid)
		
		local this_position = Util_GetPosition(sid)
		local this_score = ScorePosition(gid, this_position, 15)
		
		if this_score > best_score then
			
			best_score = this_score
			best_position = this_position
			
		end
		
	end
	SGroup_ForEach(group, _ScoreSquad)
	
	return Util_GetRandomPosition(best_position, 5)
	
end
	
function ScorePosition(group, location, range)

	local score = 0
	
	local _CheckSquad = function(gid, idx, sid)
		
		if Util_GetDistance(location, Util_GetPosition(sid)) <= range then
			
			score = score + 1
			
		end
		
	end
	SGroup_ForEach(group, _CheckSquad)
	
	return score
	
end
