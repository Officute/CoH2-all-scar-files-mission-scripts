-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- MISSION NAME
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
	
end



function OnGameRestore()
	
	Game_DefaultGameRestore()
end


-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------

function OnInit()
	
	t_germans = {}
	player1 = Game_GetLocalPlayer()
	sg_p_all = SGroup_CreateIfNotFound("sg_p_all")
	g_difficulty = Game_GetSPDifficulty()
	
	for i=1,World_GetPlayerCount() do
	
		local player = World_GetPlayerAt(i)
		ToW_SetUpTechTreeByYear(player,1942)
		ToW_SetStandardResources (player)
		if Player_GetRaceName(player) == "soviet" and AI_IsAIPlayer(player) then
			Setup_SetPlayerName(player, 11038758)
		elseif Player_GetRaceName(player) == "german" and AI_IsAIPlayer(player) then
			Setup_SetPlayerName(player, 11038759)
			table.insert (t_germans, player)
			if AI_IsAIPlayer(player) then
				AI_SetPersonality( player, "tow_1942_ai_battle_resistance")
			end
			Cmd_InstantUpgrade ( player, UPG.GERMAN.PANZER_TACTICIAN)
			Cmd_InstantUpgrade ( player, UPG.GERMAN.ARMOR_COMMANDER)
			Player_SetResource(player1, RT_Munition, 100)
			Player_SetResource(player1, RT_Manpower, 500)
		end
	end
	
	Player_AddAbility(t_germans[1], ABILITY.GERMAN.STUKA_BOMBING_STRIKE_TOW)
	Player_SetAbilityAvailability (t_germans[1], ABILITY.GERMAN.STUKA_BOMBING_STRIKE_TOW, ITEM_UNLOCKED)
	Player_SetAbilityAvailability (t_germans[1], ABILITY.GERMAN.STUKA_SMOKE_BOMB, ITEM_UNLOCKED)
	Player_SetAbilityAvailability (t_germans[1], ABILITY.GERMAN.STUKA_AIR_RECON, ITEM_UNLOCKED)
	Player_CompleteUpgrade (t_germans[1], UPG.GERMAN.BATTLE_PHASE_2_MP)
	Player_AddResource(t_germans[1], RT_Fuel, 30)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.TANK_DEPOT_MP, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(t_germans[1],SBP.GERMAN.SCOUTCAR_SDKFZ222_MP, ITEM_LOCKED)
	Player_SetSquadProductionAvailability(t_germans[1],SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, ITEM_LOCKED)
	ToW_SetUpBattleObjectives ()
	Rule_AddInterval (RES_Airstrike, 200)
	Rule_AddInterval(SpawnTigerGroup, 1)
	Rule_AddInterval(SpawnPantherGroup, 1)
	Rule_AddInterval (SpawnAssaultSquads, 220)
	Rule_AddOneShot(SpawnFirstAssaultSquad, 10)
	Rule_AddInterval(SpawnAssaultGroup, 1)
	Rule_AddInterval(GiveMunitions, 180)
	Rule_AddInterval(Smokedrop , 250)
	Rule_AddInterval(Railarty, 150)
	Rule_AddInterval(ReconRun, 150)
	Player_SetPopCapOverride(t_germans[1], 150)
	Rule_AddOneShot(SpawnOpeningSupport, 90)
	GiveCommanderPoints()
		
	AT_Gun_Setup() 
	
end


Scar_AddInit(OnInit)




--Stuka Strike-----------------------------------

function RES_Airstrike ()

Cmd_Ability(t_germans[1], ABILITY.GERMAN.STUKA_BOMBING_STRIKE_TOW, EGroup_GetRandomSpawnedEntity(eg_vp_stuka), nil, true)
Rule_ChangeInterval(RES_Airstrike, World_GetRand(200, 240))

end


---Smoke Run-----------------

function Smokedrop ()

Cmd_Ability(t_germans[1], ABILITY.GERMAN.STUKA_SMOKE_BOMB, EGroup_GetRandomSpawnedEntity(eg_vp_stuka), nil, true)
Rule_ChangeInterval(Smokedrop, World_GetRand(250, 350))

end

--Railway arty----------


function Railarty()

Cmd_Ability(t_germans[1], ABILITY.GERMAN.RAILWAY_GUN_ARTILLERY, EGroup_GetRandomSpawnedEntity(eg_vp_stuka), nil, true)
Rule_ChangeInterval(Railarty, World_GetRand(150, 250))

end


function AT_Gun_Setup() 

	Util_CreateEntities(nil, eg_AT_Gun, EBP.SOVIET.M1942_76MM_DIVISIONAL_GUN_ZIS_3_MP, mkr_2, 1 )

end

----Recon Overflight----

function ReconRun()

Cmd_Ability(t_germans[1], ABILITY.GERMAN.STUKA_AIR_RECON, EGroup_GetRandomSpawnedEntity(eg_vp_stuka), nil, true)
Rule_ChangeInterval(Railarty, World_GetRand(150, 300))

end


	
function SpawnPantherGroup()

	if VPTicker_GetTeamTickers(1) <= 200 then

		if g_difficulty == GD_NORMAL or g_difficulty == GD_HARD then

			Util_CreateSquads(t_germans[1], sg_p_all, SBP.GERMAN.PANZER_IV_SQUAD_MP, mkr_tankspawn)
			Util_CreateSquads(t_germans[1], sg_p_all, SBP.GERMAN.ASSAULT_OFFICER_SQUAD_MP, mkr_tankspawn)
			
		end
	
		Rule_RemoveMe()	
	
	end
	
end

function SpawnAssaultSquads()

Util_CreateSquads(t_germans[1], sg_p_all, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_tankspawn)

end


function SpawnAssaultGroup()

	if VPTicker_GetTeamTickers(1) <= 300 then

		if g_difficulty == GD_NORMAL or g_difficulty == GD_HARD then

			Util_CreateSquads(t_germans[1], sg_p_all, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_tankspawn)
			Util_CreateSquads(t_germans[1], sg_p_all, SBP.GERMAN.STUG_III_E_SQUAD_MP, mkr_tankspawn)
		
		end
		
		Rule_RemoveMe()
	end
	
end

function SpawnFirstAssaultSquad()

	if g_difficulty == GD_NORMAL or g_difficulty == GD_HARD then

		Util_CreateSquads(t_germans[1], sg_p_all, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_tankspawn)

	end
	
end


function GiveMunitions()

	if g_difficulty == GD_NORMAL then

		Player_AddResource(t_germans[1], RT_Munition, 25)
	
		if g_difficulty == GD_HARD then
	
			Player_AddResource(t_germans[1], RT_Munition, 50)
		
		end
	
	end
	
end


function GiveCommanderPoints()

	if g_difficulty == GD_NORMAL or g_difficulty == GD_EASY then

		Player_SetResource ( player1, RT_Command, 2 )
		
	
	end
	
end



function SpawnTigerGroup()

	if VPTicker_GetTeamTickers(1) <= 150 then
	
		if g_difficulty == GD_NORMAL or g_difficulty == GD_HARD then

			Util_CreateSquads(t_germans[1], sg_p_all, SBP.GERMAN.TIGER_SQUAD_MP, mkr_tankspawn)
			Util_CreateSquads(t_germans[1], sg_p_all, SBP.GERMAN.ASSAULT_OFFICER_SQUAD_MP, mkr_tankspawn)
			Util_CreateSquads(t_germans[1], sg_p_all, SBP.GERMAN.ASSAULT_OFFICER_SQUAD_MP, mkr_tankspawn)
			
		end
		
		Rule_RemoveMe()
		
	end

end


function SpawnOpeningSupport()

		if g_difficulty == GD_HARD then

			Util_CreateSquads(t_germans[1], sg_p_all, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_tankspawn)
			Util_CreateSquads(t_germans[1], sg_p_all, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_MP, mkr_tankspawn)

		if g_difficulty == GD_NORMAL then
		
			Util_CreateSquads(t_germans[1], sg_p_all, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_tankspawn)
		
		end
	
	end
	
end



