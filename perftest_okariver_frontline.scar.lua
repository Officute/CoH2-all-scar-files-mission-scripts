-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScarUtil.scar")

-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------


function OnGameSetup()
	player1 = Setup_Player(1, 11040465, "soviet", 1)		-- LOCDB [11040465] '13th Guards Rifle Division'
	player2 = Setup_Player(2, 11040466, "german", 2)		-- LOCDB [11040466] '71st Infantry Division'

end

function OnGameRestore()
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)

	Game_DefaultGameRestore()
	
end



function OnInit()
	
	sg_blah = SGroup_CreateIfNotFound("sg_blah")
	sg_initial1 = SGroup_CreateIfNotFound("sg_initial1")
	sg_initial2 = SGroup_CreateIfNotFound("sg_initial2")
	sg_tank1 = SGroup_CreateIfNotFound("sg_tank1")
	sg_tank2 = SGroup_CreateIfNotFound("sg_tank2")
	sg_tank3 = SGroup_CreateIfNotFound("sg_tank3")
	sg_tank4 = SGroup_CreateIfNotFound("sg_tank4")
	
	NIS_CameraPan = "SP/PerformanceTest/nis/NIS_CameraPan"
	
	Game_SetMode(UI_Fullscreen)
	FOW_RevealAll()
	
	nis_load(NIS_CameraPan)
	nis_setintransitiontime(0)
	nis_setouttransitiontime(0)
	
	Player_AddAbility(player1, ABILITY.SOVIET.IL_2_RECON_SINGLEPASS_SP)
	Player_AddAbility(player2, ABILITY.GLOBAL.SP_SINGLE_SHOT_MORTAR)
	Player_AddAbility(player2, ABILITY.GLOBAL.OFF_MAP_ARTILLERY)

	Part1_Start()
	Rule_AddOneShot(Part2_Start, 20)
	
	Scar_PlayNIS(NIS_CameraPan)
	
end
Scar_AddInit(OnInit)
	
	
	
	
	
function Part1_Start()

	Util_CreateSquads(player1, sg_initial1, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_spawn_player1)
	Util_CreateSquads(player2, sg_initial2, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_spawn_player2)
	Cmd_Attack(sg_initial1, sg_initial2)
	Cmd_Attack(sg_initial2, sg_initial1)
	
	Util_CreateSquads(player1, sg_tank1, SBP.SOVIET.T_34_76_SQUAD_MP, mkr_spawn_tank1)
	Util_CreateSquads(player1, sg_tank2, SBP.SOVIET.T_34_76_SQUAD_MP, mkr_spawn_tank2)
	Cmd_SquadPath(sg_tank1, "path_tank1", true, false, false, 0)
	Cmd_SquadPath(sg_tank2, "path_tank2", true, false, false, 0)
	
	Modify_UnitSpeed(sg_tank1, 0.7)
	Modify_UnitSpeed(sg_tank2, 0.7)
	
	Util_CreateSquads(player2, sg_blah, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, mkr_spawn_atgun1)
	Util_CreateSquads(player2, sg_blah, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, mkr_spawn_atgun2)
	
	Rule_AddOneShot(ArtilleryHits, 5.5)
	Rule_AddOneShot(ReconFlyBys, 6.8)
end


function ArtilleryHits()
	Cmd_Ability(player2, ABILITY.GLOBAL.OFF_MAP_ARTILLERY, mkr_artillery01, nil, true)
end


function ReconFlyBys()
	Rule_AddOneShot(ReconFlyBy1, 0.5)
	Rule_AddOneShot(ReconFlyBy2, 1.4)
	Rule_AddOneShot(ReconFlyBy3, 1.9)
end
function ReconFlyBy1()
	Cmd_Ability(player1, ABILITY.SOVIET.IL_2_RECON_SINGLEPASS_SP, Marker_GetPosition(mkr_recon01), Marker_GetDirection(mkr_recon01), true)
end
function ReconFlyBy2()
	Cmd_Ability(player1, ABILITY.SOVIET.IL_2_RECON_SINGLEPASS_SP, Marker_GetPosition(mkr_recon02), Marker_GetDirection(mkr_recon01), true)
end
function ReconFlyBy3()
	Cmd_Ability(player1, ABILITY.SOVIET.IL_2_RECON_SINGLEPASS_SP, Marker_GetPosition(mkr_recon03), Marker_GetDirection(mkr_recon01), true)
end






function Part2_Start()

	Entity_SetOnFire(EGroup_GetSpawnedEntityAt(eg_house1, 1))
	
	sg_flamethrowers = SGroup_CreateIfNotFound("sg_flamethrowers")
	
	Util_CreateSquads(player2, sg_flamethrowers, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_spawn_flamethrower1, nil, nil, nil, nil, nil, UPG.GERMAN.PIONEER_FLAMETHROWER_MP)
	Util_CreateSquads(player2, sg_flamethrowers, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_spawn_flamethrower2, nil, nil, nil, nil, nil, UPG.GERMAN.PIONEER_FLAMETHROWER_MP)
	Cmd_Attack(sg_flamethrowers, eg_house2)
	
	Util_CreateSquads(player1, sg_tank3, SBP.SOVIET.M5_HALFTRACK_SQUAD_MP, mkr_spawn_tank3, nil, nil, nil, nil, nil, UPG.SOVIET.M5_HALFTRACK_72K_AA_GUN_PACKAGE_MP)
	Cmd_SquadPath(sg_tank3, "path_tank3", true, false, false, 0)
	Modify_ReceivedDamage(sg_tank3, 2)
	
	Util_CreateSquads(player2, sg_tank4, SBP.GERMAN.PANZER_IV_SQUAD_MP, mkr_spawn_tank4)
	Cmd_SquadPath(sg_tank4, "path_tank4", true, false, false, 0)
	
end
