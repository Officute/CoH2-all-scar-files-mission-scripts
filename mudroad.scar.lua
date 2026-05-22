-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- Mud Road
-- Designer: Matt Philip

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


	-- human players
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	
	-- ai Defenders
	player5 = World_GetPlayerAt(5)
	player6 = World_GetPlayerAt(6)
	player7 = World_GetPlayerAt(7)
	
end


function OnGameRestore()
	
	Game_DefaultGameRestore()
	
	-- Attackers
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	
	-- Defenders
	player5 = World_GetPlayerAt(4)
	player6 = World_GetPlayerAt(5)
	player7 = World_GetPlayerAt(6)
	
end

-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------

function OnInit()
	
	t_soviets = {}
	sg_p_all = SGroup_CreateIfNotFound("sg_p_all")
	sg_e_all = SGroup_CreateIfNotFound ("sg_e_all")
	sg_scout = SGroup_CreateIfNotFound ("sg_scout")
	g_difficulty = Game_GetSPDifficulty()
	
	for i=1,World_GetPlayerCount() do
	
		local player = World_GetPlayerAt(i)
		ToW_SetUpTechTreeByYear(player,1943)
		ToW_SetStandardResources (player)
		if Player_GetRaceName(player) == "german" then
--~ 			Setup_SetPlayerName(player, 11038759)
			
			if Player_IsHuman(player) == false then
				Setup_SetPlayerName(player, 11038759)	-- "Werhmacht"
			end
			
			Player_AddAbility(player2, BP_GetAbilityBlueprint("forward_repair_station_tow"))
			Cmd_InstantUpgrade (player2, UPG.GERMAN.FORWARD_REPAIR_STATION)
			Player_AddAbility(player, BP_GetAbilityBlueprint("breakthrough_tow"))
			Player_AddAbility(player3, BP_GetAbilityBlueprint("mechanized_assault_group_tow"))
			Player_AddAbility(player1, BP_GetAbilityBlueprint("troop_training_tow"))
					
					
					
--~ 			Modify_Upkeep(player, 0)	
			
			Modify_PlayerResourceRate(player, RT_Manpower, .90, MUT_Multiplication)
			Modify_PlayerResourceRate(player, RT_Fuel, 1.3, MUT_Multiplication)
			
--~ 			Player_SetMaxPopulation(player, CT_Personnel, 50)
			
			Player_SetAbilityAvailability (player, ABILITY.GERMAN.FORWARD_REPAIR_STATION, ITEM_UNLOCKED)
			Player_SetAbilityAvailability (player, ABILITY.GERMAN.MECHANIZED_ASSAULT_GROUP, ITEM_UNLOCKED)
			Player_SetAbilityAvailability (player, ABILITY.GERMAN.BREAKTHROUGH, ITEM_UNLOCKED)
			
--~ 			Cmd_Upgrade(player, BP_GetUpgradeBlueprint("radio_upgrade"), 1, true)
			
			
		elseif Player_GetRaceName(player) == "soviet" then
			Setup_SetPlayerName(player, 11038758)
			table.insert (t_soviets, player)
			
			Player_AddResource(player, RT_Munition, 50)
			Player_AddResource(player, RT_Fuel, 30)
			Player_AddResource(player, RT_Manpower, 500)
			Player_SetMaxPopulation(player, CT_Personnel, 150)
			
			
			Modify_PlayerResourceRate(player, RT_Fuel, 1.5, MUT_Multiplication)
			Modify_PlayerResourceRate(player, RT_Munition, 1.1, MUT_Multiplication)
			Modify_PlayerResourceRate(player, RT_Manpower, 1.1, MUT_Multiplication)
--~ 			
			if AI_IsAIPlayer(player) then
				AI_SetPersonality( player, "tow_1942_ai_battle_mudroad")
			end
		end
	end
	
	ToW_SetUpBattleObjectives ()
	Rule_AddInterval(ISU_Group_Check, 1)
	

	add_hint()
	
	Rule_AddInterval(Tank_Attack_1, 1)
	Rule_AddInterval(Tank_Attack_2, 1)
	Rule_AddOneShot(Start_Transition_Phase, World_GetRand(240, 300)) -- Start Storm Transitions

	halftrack_support()
	
	
	
	
end

Scar_AddInit(OnInit)



---------------------------------
-- Atmosphere Transitions
---------------------------------

function Start_Transition_Phase()
	if VPTicker_GetTeamTickers(0) ~= 0 and VPTicker_GetTeamTickers(1) ~= 0 then
		print("Start Transition Phase")
		Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_MudRoad311_transition.aps", 30)
		Rule_AddOneShot(Start_Storm_Phase, 30)
	end
end
function Start_Storm_Phase()
	if VPTicker_GetTeamTickers(0) ~= 0 and VPTicker_GetTeamTickers(1) ~= 0 then
		print("Start Storm Phase")
		Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_MudRoad311_lightning.aps", 0)
		Rule_AddOneShot(Start_Transition_Phase_02, World_GetRand(180, 240))
	end
end
function Start_Transition_Phase_02()
	if VPTicker_GetTeamTickers(0) ~= 0 and VPTicker_GetTeamTickers(1) ~= 0 then
		print("Start Transition Phase")
		Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_MudRoad311_transition.aps", 0)
		Rule_AddOneShot(Start_Default_Phase, 30)
	end
end
function Start_Default_Phase()
	if VPTicker_GetTeamTickers(0) ~= 0 and VPTicker_GetTeamTickers(1) ~= 0 then
		print("Start Default Phase")
		Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_MudRoad311_default.aps", 15)
		Rule_AddOneShot(Start_Transition_Phase, World_GetRand(210, 260))
	end
end

---------------------------------
-- Mission Functions
---------------------------------
function halftrack_support()

	Util_CreateSquads(player1, sg_p_all, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, mkr_spawn_1)

	Util_CreateSquads(player2, sg_p_all, SBP.GERMAN.MECHANIZED_250_HALFTRACK_MP, mkr_spawn_2)

	Util_CreateSquads(player3, sg_p_all, SBP.GERMAN.PANZERWERFER_SQUAD_MP, mkr_spawn_3)

end



----------tanks pressure 1-------

function Tank_Attack_1()
	if VPTicker_GetTeamTickers(1) <= 350 then
		Spawn_T1()
		Rule_RemoveMe()
	end
end

function Spawn_T1()

	Util_CreateSquads(t_soviets[1], sg_e_all, SBP.SOVIET.KV_1_MP, mkr_tankspawn)
	Util_CreateSquads(t_soviets[1], sg_e_all, SBP.SOVIET.T_34_85_SQUAD_MP, mkr_tankspawn)
	Util_CreateSquads(t_soviets[1], sg_e_all, SBP.SOVIET.KV_1_MP, mkr_tankspawn)

end


----------tanks pressure 2-------


function Tank_Attack_2()
	if VPTicker_GetTeamTickers(1) <= 250 then
		Spawn_T2()
		Rule_RemoveMe()
	end
end

function Spawn_T2()

	Util_CreateSquads(t_soviets[1], sg_e_all, SBP.SOVIET.KV_1_MP, mkr_tankspawn)
	Util_CreateSquads(t_soviets[1], sg_e_all, SBP.SOVIET.T_34_85_SQUAD_MP, mkr_tankspawn)
	Util_CreateSquads(t_soviets[1], sg_e_all, SBP.SOVIET.KV_1_MP, mkr_tankspawn)

end


function ISU_Group_Check()

		if g_difficulty == GD_NORMAL or g_difficulty == GD_HARD then

		if VPTicker_GetTeamTickers(1) <= 150 then
			ISU_Spawn()
			ISU_Spawn_2()
			Rule_RemoveMe()
		end
	end	

end


function ISU_Spawn()
	local ISU_Attack_EncounterData = {
		name = "ISU_Attack",
		player = t_soviets[1],
		spawn = mkr_tankspawn,
		sgroups = {sg_e_all},
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
			},
			{
				sbp = SBP.SOVIET.ISU_152_MP,
			},
		},
		onDeath = nil,
	}

	
		local goalData = {
		name = "Defend",
		target = mkr_attack_1,
		leashRange = 20, 
		attackMove = true
	}
	enc_isu1 = Encounter:Create (ISU_Attack_EncounterData)
	enc_isu1:SetGoal(goalData)
	
end


function ISU_Spawn_2()
	local ISU_Attack_EncounterData = {
		name = "ISU_Attack",
		player = t_soviets[1],
		spawn = mkr_tankspawn,
		sgroups = {sg_e_all},
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
			},
			{
				sbp = SBP.SOVIET.ISU_152_MP,
			},
		},
		onDeath = nil,
	}

	
		local goalData = {
		name = "Defend",
		target = mkr_attack_2,
		leashRange = 20, 
		attackMove = true
	}
	enc_isu2 = Encounter:Create (ISU_Attack_EncounterData)
	enc_isu2:SetGoal(goalData)
	
end

----t70 attack----

function T70_Attack()
	if VPTicker_GetTeamTickers(1) <= 300 then
		Spawn_T70()
		Rule_RemoveMe()
	end
end

function Spawn_T70()

	Util_CreateSquads(t_soviets[1], sg_e_all, SBP.SOVIET.T_70M_MP, mkr_tankspawn)
	Util_CreateSquads(t_soviets[1], sg_e_all, SBP.SOVIET.T_70M_MP, mkr_tankspawn)
	Util_CreateSquads(t_soviets[1], sg_e_all, SBP.SOVIET.KV_2_MP, mkr_tankspawn)

end


----kv1 attack----

function Kv1_Attack()
	if VPTicker_GetTeamTickers(1) <= 230 then
		Spawn_Kv1()
		Rule_RemoveMe()
	end
end

function Spawn_Kv1()

	Util_CreateSquads(t_soviets[1], sg_e_all, SBP.SOVIET.KV_1_MP, mkr_tankspawn)
	Util_CreateSquads(t_soviets[1], sg_e_all, SBP.SOVIET.KV_1_MP, mkr_tankspawn)


end

---mortar support----

function Mortar_Support()
	if VPTicker_GetTeamTickers(1) <= 300 then
		Spawn_Mortar_Support()
		Rule_RemoveMe()
	end
end


function add_hint()

	hint1 = HintPoint_Add(mkr_br1, true, 11055955, 3, HPAT_Hint)
	hint2 = HintPoint_Add(mkr_br2, true, 11055955, 3, HPAT_Hint)

end

