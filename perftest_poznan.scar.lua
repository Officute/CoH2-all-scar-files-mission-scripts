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
	
	-- set up groups
	sg_blah = SGroup_CreateIfNotFound("sg_blah")
	sg_enemy_hmg = SGroup_CreateIfNotFound("sg_enemy_hmg")
	sg_enemy_panzershreck = SGroup_CreateIfNotFound("sg_enemy_panzershreck")

	SGroup_SetAvgHealth(sg_part1_tank1, 0.3)
	SGroup_Hide(sg_part2_tank1, true)
	
	-- pre-load the camera pan
	NIS_CameraPan = "SP/PerformanceTest/nis/NIS_CameraPan_Poznan"
	nis_load(NIS_CameraPan)
	nis_setintransitiontime(0)
	nis_setouttransitiontime(0)
	
	-- set up the world
	Camera_SetInputEnabled(false)
	Misc_SetSelectionInputEnabled(false)
	Misc_SetDefaultCommandsEnabled(false)
	FOW_RevealAll()
	
	-- add any required abilities for the player and/or enemy
	Player_AddAbility(player1, ABILITY.SOVIET.IL_2_RECON_SINGLEPASS_SP)
	Player_AddAbility(player2, ABILITY.GLOBAL.SP_SINGLE_SHOT_MORTAR)
	Player_AddAbility(player2, ABILITY.GLOBAL.OFF_MAP_ARTILLERY)
	Player_SetResource(player1, RT_Command, 1)

	-- start the script
	Part1_Init()
	Part2_Init()
	Part3_Init()
	
	-- start the camera movement
	Game_FadeToBlack(FADE_OUT, 0)
	Scar_PlayNIS(NIS_CameraPan)
	
	Event_Timer(Init_UI, nil, 1)
	Event_Timer(Start_FadeIn, nil, 0.5)
	Event_Timer(Start_FadeOut, nil, 43)
	
end
Scar_AddInit(OnInit)
	
	
	
function Init_UI()	
	UI_SetCPMeterVisibility(false) 
end
function Start_FadeIn()
	Game_FadeToBlack(FADE_IN, 2)
end
function Start_FadeOut()
	Game_FadeToBlack(FADE_OUT, 1.8)
end



	
function Part1_Init()
	Part1_Start()	-- start this immediately
end
function Part1_Start()

	-- put an HMG gunner in the building
	Util_CreateSquads(player2, sg_blah, SBP.GERMAN.PANZER_GRENADIER_SQUAD, eg_building1)
	EGroup_SetInvulnerable(eg_building1, true)
	
	-- make guys down the street able to shoot player
	Cmd_InstantSetupTeamWeapon(sg_part1_distant)
	Modify_WeaponRange(sg_part1_distant, "hardpoint_01", 2.5)
	
	-- have unit selected
	Misc_SelectSquad(SGroup_GetSpawnedSquadAt(sg_part1_tank1, 1), true)
	
	-- start units moving up the street
	Cmd_Move(sg_part1_conscripts1, mkr_conscript1_dest)
	Cmd_Move(sg_part1_conscripts2, mkr_conscript2_dest)
	Cmd_SquadPath(sg_part1_tank1, "path_part1_tank1", true, false, false, 0)

	-- set up attack on the tank
	Event_Proximity(Part1_BlowUpTank, nil, sg_part1_tank1, mkr_tank1_dest, 10)
	
end


function Part1_BlowUpTank()

	Util_CreateSquads(player2, sg_enemy_panzershreck, SBP.GERMAN.PANZER_GRENADIER_SQUAD, eg_building1, nil, 1, 1, nil, nil, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM)
	SGroup_SetInvulnerable(sg_enemy_panzershreck, true)
	Cmd_Attack(sg_enemy_panzershreck, sg_part1_tank1)
	
	Event_OnHealth(Part1_BlowUpTank_PartB, nil, sg_part1_tank1, 0.2, false)
	
end
function Part1_BlowUpTank_PartB()
	SGroup_Kill(sg_part1_tank1)
end







--
-- Shot two - revenge on the building
--
function Part2_Init()

	p2_start_time = 15	-- base time this part starts
	
	SGroup_SetAutoTargetting(sg_part2_tank1, "hardpoint_01", false)

	Rule_AddOneShot(Part2_GetUnitsMoving, p2_start_time - 4)
	Rule_AddOneShot(Part2_Start, p2_start_time)
	
end
function Part2_GetUnitsMoving()
	
	Cmd_SquadPath(sg_part2_tank1, "path_part2_tank1", true, false, false, 0)
	SGroup_SetAutoTargetting(sg_part2_tank1, "hardpoint_01", true)
	
end
function Part2_Start()

	-- have new tank selected
	Misc_SelectSquad(SGroup_GetSpawnedSquadAt(sg_part2_tank1, 1), true)
	SGroup_Hide(sg_part2_tank1, false)
	
	-- set things so the building comes down easily
	SGroup_SetInvulnerable(sg_enemy_panzershreck, false)
	EGroup_SetInvulnerable(eg_building1, false)
	modid_p2_tank = Modify_WeaponDamage(sg_part2_tank1, "hardpoint_01", 20)
	building1_threshold = EGroup_GetAvgHealth(eg_building1) - 0.02
	
	Rule_Add(Part2_CollapseBuilding)
	
	
end


function Part2_CollapseBuilding()

	if Player_OwnsEGroup(player2, eg_building1, ANY) == false or EGroup_GetAvgHealth(eg_building1) <= building1_threshold then
		
		Rule_RemoveMe()
		
		EGroup_Kill(eg_building1)
		Modifier_Remove(modid_p2_tank)
		
	end
	
end






--
-- Shot three - units moving across the ice towards the fort
--
function Part3_Init()

	p3_start_time = 30	-- base time this part starts

	Rule_AddOneShot(Part3_GetUnitsMoving, p3_start_time - 10)
	Rule_AddOneShot(Part3_Start, p3_start_time)
	
end
function Part3_GetUnitsMoving()

	-- send units across the ice
	Cmd_SquadPath(sg_part3_shock1, "path_part3_shock1", true, false, false, 2)
	Cmd_SquadPath(sg_part3_shock2, "path_part3_shock2", true, false, false, 2)
	Cmd_SquadPath(sg_part3_shock3, "path_part3_shock3", true, false, false, 2)
	Cmd_SquadPath(sg_part3_shock4, "path_part3_shock4", true, false, false, 2)
	Cmd_SquadPath(sg_part3_shock5, "path_part3_shock5", true, false, false, 2)
	Cmd_SquadPath(sg_part3_shock6, "path_part3_shock6", true, false, false, 2)
	
	Cmd_SquadPath(sg_part3_tank1, "path_part3_tank1", true, false, false, 0)
	Cmd_SquadPath(sg_part3_tank2, "path_part3_tank2", true, false, false, 0)
	Cmd_SquadPath(sg_part3_tank3, "path_part3_tank3", true, false, false, 0)
	
end
function Part3_Start()
	
	Event_Timer(Part3_TriggerHowitzerShell1, nil, 2)
	Event_Timer(Part3_TriggerHowitzerShell2, nil, 3.5)
	Event_Timer(Part3_TriggerHowitzerShell3, nil, 4.2)
	
end


function Part3_TriggerHowitzerShell1(data)
	Cmd_Ability(player2, ABILITY.GLOBAL.SP_SINGLE_SHOT_MORTAR, mkr_part3_howitzer1, nil, true)
end
function Part3_TriggerHowitzerShell2(data)
	Cmd_Ability(player2, ABILITY.GLOBAL.SP_SINGLE_SHOT_MORTAR, mkr_part3_howitzer2, nil, true)
end
function Part3_TriggerHowitzerShell3(data)
	SGroup_SetInvulnerable(sg_part3_tank3, false)
	Cmd_Ability(player2, ABILITY.GLOBAL.SP_SINGLE_SHOT_MORTAR, mkr_part3_howitzer3, nil, true)
end








