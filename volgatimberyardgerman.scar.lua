-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- MISSION NAME: Volga Timber Yard - German
-- Designer: Sacha Narine
-- Description: Use Luftwaffe officer squads to call in air support
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
	
	player1 = World_GetPlayerAt(2) -- First human player
	player2 = World_GetPlayerAt(1) -- First enemy player
	player3 = World_GetPlayerAt(4) -- Second human player
	player4 = World_GetPlayerAt(3) -- Second enemy player
	
	sg_p_all = SGroup_CreateIfNotFound("sg_p_all")
	sg_p1_officer = SGroup_CreateIfNotFound("sg_p1_officer")
	sg_p2_officer = SGroup_CreateIfNotFound("sg_p2_officer")
	sg_e_all = SGroup_CreateIfNotFound("sg_e_all")
	sg_planes = SGroup_CreateIfNotFound("sg_planes")
	sg_planes_already_modified = SGroup_CreateIfNotFound("sg_planes_already_modified")
	sg_blah = SGroup_CreateIfNotFound("sg_blah")
	
	eg_p1_hq = EGroup_CreateIfNotFound("eg_p1_hq")
	eg_p2_hq = EGroup_CreateIfNotFound("eg_p2_hq")
	
	g_difficulty = Game_GetSPDifficulty()
	t_soviets = {}
	
	TEAM_ENEMY = Player_GetTeam(player2)
	
	for i=1,World_GetPlayerCount() do
		
		local player = World_GetPlayerAt(i)
		ToW_SetStandardResources (player)
		Player_SetResource (player, RT_Command, 1 )
		Player_SetResource(player, RT_Munition, 100)
		Player_SetResource(player, RT_Manpower, 500)
		ToW_SetUpTechTreeByYear(player,1943)
		
		if Player_GetRaceName(player) == "soviet" then			-- Enemy
			
			table.insert(t_soviets, player)
			
			if AI_IsAIPlayer(player) then
				AI_SetPersonality( player, "tow_1943_ai_battle_volgatimber")
			end
			if Player_IsHuman(player) == false then
				Setup_SetPlayerName(player, 11038758)
			end
			
			-- Halftrack Bonuses
			-- Make Soviet halftracks cheaper to produce and upgrade
			Modify_EntityCost(player, EBP.SOVIET.MOTORPOOL_MP, RT_Manpower, -50)
			Modify_EntityCost(player, EBP.SOVIET.MOTORPOOL_MP, RT_Fuel, -25)
			Modify_EntityCost(player, EBP.SOVIET.M5_HALFTRACK_MP, RT_Fuel, -15)
			Modify_EntityCost(player, EBP.SOVIET.M5_HALFTRACK_MP, RT_Manpower, -40)
			Modify_SetUpgradeCost(player, UPG.SOVIET.M5_HALFTRACK_72K_AA_GUN_PACKAGE_MP, RT_Munition, 50)
			
		elseif Player_GetRaceName(player) == "german" then		-- Player / Ally
			
			if AI_IsAIPlayer(player)  then
				AI_SetPersonality( player, "tow_1943_ai_battle_volgatimber_german_ally")	-- includes economy to encourage building luftwaffe officers
			end
			if Player_IsHuman(player) == false then
				Setup_SetPlayerName(player, 11038759)
			end
			
			Cmd_Upgrade(player, BP_GetUpgradeBlueprint("1943_volga_timber"), 1, true)
			
			-- German Vehicle Cost Nerfs
			-- Make German tanks more expensive, so they have to rely more on planes
			Modify_EntityCost(player, EBP.GERMAN.STUG_III_G_SDKFZ_141_1_MP, RT_Manpower, 150)
			Modify_EntityCost(player, EBP.GERMAN.STUG_III_G_SDKFZ_141_1_MP, RT_Fuel, 25)
			Modify_EntityCost(player, EBP.GERMAN.PANZER_IV_SDKFZ_161_MP, RT_Manpower, 150)
			Modify_EntityCost(player, EBP.GERMAN.PANZER_IV_SDKFZ_161_MP, RT_Fuel, 40)
			Modify_EntityCost(player, EBP.GERMAN.OSTWIND_FLAK_PANZER_MP, RT_Manpower, 150)
			Modify_EntityCost(player, EBP.GERMAN.OSTWIND_FLAK_PANZER_MP, RT_Fuel, 50)
			Modify_EntityCost(player, EBP.GERMAN.PANTHER_SDKFZ_171_MP, RT_Manpower, 200)
			Modify_EntityCost(player, EBP.GERMAN.PANTHER_SDKFZ_171_MP, RT_Fuel, 70)
			Modify_EntityCost(player, EBP.GERMAN.BRUMMBAR_STURMPANZER_IV_SDKFZ_166_MP, RT_Manpower, 120)
			Modify_EntityCost(player, EBP.GERMAN.BRUMMBAR_STURMPANZER_IV_SDKFZ_166_MP, RT_Fuel, 60)
			
		end
		
	end

	ToW_SetUpBattleObjectives ()
	
	
	
	--
	-- Spawns
	--
	
	-- One Pak40 to fend off an early Soviet MG halftrack
	Util_CreateSquads(player1, sg_p_all, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, mkr_enemyAT1)
	
	-- Luftwaffe Officer squads to call in air support (with hintpoints on then)
	Util_CreateSquads(player1, {sg_p_all, sg_p1_officer}, BP_GetSquadBlueprint("luftwaffe_officer_squad_tow"), mkr_officerSpawn)
	Util_CreateSquads(player3, {sg_p_all, sg_p2_officer}, BP_GetSquadBlueprint("luftwaffe_officer_squad_tow"), mkr_officerSpawn2)

	if Game_GetLocalPlayer() == player1 then
		
		hint_officer1 = HintPoint_Add(sg_p1_officer, true, 11054471) -- "Use officer to call in air support"
		Event_Timer(EventHandler_RemoveHint, {hint = hint_officer1}, 30)
		
		Player_GetAll(player1, sg_blah, eg_p1_hq)
		EGroup_Filter(eg_p1_hq, EBP.GERMAN.GERMAN_HQ_MP, FILTER_KEEP)
		
		Event_Timer(Mission_FlashLuftwaffeOfficerButton, {player = player1, hq = eg_p1_hq}, 5)
		
	end
	if Game_GetLocalPlayer() == player3 then
		
		hint_officer2 = HintPoint_Add(sg_p2_officer, true, 11054471) -- "Use officer to call in air support"
		Event_Timer(EventHandler_RemoveHint, {hint = hint_officer2}, 30)
		
		Player_GetAll(player3, sg_blah, eg_p2_hq)
		EGroup_Filter(eg_p2_hq, EBP.GERMAN.GERMAN_HQ_MP, FILTER_KEEP)
		
		Event_Timer(Mission_FlashLuftwaffeOfficerButton, {player = player3, hq = eg_p2_hq}, 5)
		
	end
	
	-- enemy AA halftracks
	Util_CreateSquads(player2, sg_e_all, SBP.SOVIET.M5_HALFTRACK_SQUAD_MP, mkr_aaTruck1, nil, nil, nil, nil, nil, UPG.SOVIET.M5_HALFTRACK_72K_AA_GUN_PACKAGE_MP)
	
	
	--
	-- Camera / Atmosphere settings
	-- 
	Camera_SetDefault(35, 40, 120)	-- set the new default camera (rotated 180 from normal, as you play from the "wrong" side)
	Camera_ResetToDefault()
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/volga_timber_yard_ALT.aps", 0)
	
	-- Misc Initialisation stuff
	Mission_Difficulty()
	Airplane_Init()	
	
end

Scar_AddInit(OnInit)










function Mission_Difficulty()	
	g_difficulty = Game_GetSPDifficulty() 
	
	t_difficulty = {
 	-- Easy, Medium, Hard
		
		playerStartingManpower 	 = Util_DifVar( {500, 350, 250} ), 
		playerStartingMunitions  = Util_DifVar( {150, 100, 50} ), 
		playerStartingFuel 		 = Util_DifVar( {75, 50, 25} ), 
		initialPlaneDelay		 = Util_DifVar( {360, 240, 120} ), 
		delayBetweenPlanes		 = Util_DifVar( {360, 240, 120} ),
		strafingUnlock			 = Util_DifVar( {300, 200, 100} ),
		bombingUnlock			 = Util_DifVar( {600, 400, 200} ),
		accuracyVsAirplanes		 = Util_DifVar( {30, 20, 10} ),
		planeArmorNerf			 = Util_DifVar( {0.005, 0.0025, 0.001} ), -- Airplanes have 1000 armor by default!
		munitionsReward 		 = Util_DifVar( {80, 40, 20} ),
		fuelReward 				 = Util_DifVar( {40, 20, 10} ),
	}
end

--- Airplanes
function Airplane_Init()
	Rule_AddInterval(Airplane_ModifyArmor, 2)
end


-- This makes airplanes easier to shoot down
-- Airplanes have 1000 armor by default!
function Airplane_ModifyArmor()

	-- get everything
	SGroup_Clear(sg_planes)
	local player1Squads = Player_GetSquads(player1)
	SGroup_AddGroup(sg_planes, player1Squads)
	local player3Squads = Player_GetSquads(player3)
	SGroup_AddGroup(sg_planes, player3Squads)	
	
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





-- called when the player selects his HQ when he no longer has a Luftwaffe Officer, flashes the officer button
function Mission_FlashLuftwaffeOfficerButton(data)

	Player_GetAll(data.player)
	SGroup_Filter(sg_allsquads, BP_GetSquadBlueprint("luftwaffe_officer_squad_tow"), FILTER_KEEP)
	
	if SGroup_CountSpawned(sg_allsquads) >= 1 then
		
		Event_Timer(Mission_FlashLuftwaffeOfficerButton, data, 5)		-- wait for officer to die
		
	elseif Misc_IsEGroupSelected(data.hq, ANY) == true  then
		
		flashID_officer = UI_FlashProductionButton(PITEM_Spawn, BP_GetSquadBlueprint("luftwaffe_officer_squad_tow"), true)
		Event_Timer(EventHandler_StopFlashing, {flashID = flashID_officer}, 30)
		
	else
		
		Event_Timer(Mission_FlashLuftwaffeOfficerButton, data, 0.5)		-- wait for hq to be selected
		
	end
	
end
