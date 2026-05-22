-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- Stalingrad ai battle
-- Designer: Matt Philip but really Neil did most.....because I have no idea how to script....bah

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
	player8 = World_GetPlayerAt(8)
	
end


function OnGameRestore()
	
	Game_DefaultGameRestore()
	print("NUMBER OF PLAYERS"..World_GetPlayerCount())
	-- Attackers
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	
	-- Defenders
	player5 = World_GetPlayerAt(4)
	player6 = World_GetPlayerAt(5)
	player7 = World_GetPlayerAt(6)
	player8 = World_GetPlayerAt(7)
	print("NUMBER OF PLAYERS again"..World_GetPlayerCount())
end


-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------

function OnInit()
	print("NUMBER OF PLAYERS"..World_GetPlayerCount())
	
	t_germans = {}
	sg_p_all = SGroup_CreateIfNotFound("sg_p_all")
	sg_e_all = SGroup_CreateIfNotFound ("sg_e_all")
	sg_temp = SGroup_CreateIfNotFound ("sg_temp")
	g_difficulty = Game_GetSPDifficulty()
	
	for i=1,World_GetPlayerCount() do
	
		local player = World_GetPlayerAt(i)
		ToW_SetUpTechTreeByYear(player,1942)
		ToW_SetStandardResources (player)
		
		if Player_GetRaceName(player) == "german" then				-- these are ALL AI players
			
			table.insert (t_germans, player)
			Setup_SetPlayerName(player, 11038759)	-- "Wehrmacht"
			
			if AI_IsAIPlayer(player) then
				AI_SetPersonality( player, "tow_1942_ai_battle_stalingrad")
			end
			
		elseif Player_GetRaceName(player) == "soviet"  then			-- this is a mix of humans and AI substitutes
			
			if Player_IsHuman(player) == false then
				Setup_SetPlayerName(player, 11038758)	-- "Red Army"
			end
			
			-----removing tank buildings ------
			
			Player_SetEntityProductionAvailability(player, EBP.SOVIET.TANK_DEPOT_MP, ITEM_REMOVED)
			Player_SetEntityProductionAvailability(player, EBP.SOVIET.MOTORPOOL_MP, ITEM_REMOVED)
			
			---command points----
			
			
		end
	end
	
	

	t_potential_spawn_markers =
	{
		mkr_bah1,
		mkr_bah2,
		mkr_bah3,
	}


	
	---setting up pre-placed buildings------
	
	Util_CreateEntities( player1, eg_playerbuildings, EBP.SOVIET.WEAPON_SUPPORT_CENTER_MP , mkr_1, 1 )
	Util_CreateEntities( player2, eg_playerbuildings, EBP.SOVIET.WEAPON_SUPPORT_CENTER_MP , mkr_3, 1 )
	Util_CreateEntities( player3, eg_playerbuildings, EBP.SOVIET.WEAPON_SUPPORT_CENTER_MP , mkr_5, 1 )
	Util_CreateEntities( player1, eg_playerbuildings, EBP.SOVIET.BARRACKS_MP , mkr_2, 1 )
	Util_CreateEntities( player2, eg_playerbuildings, EBP.SOVIET.BARRACKS_MP , mkr_4, 1 )
	Util_CreateEntities( player3, eg_playerbuildings, EBP.SOVIET.BARRACKS_MP , mkr_6, 1 )
	
	Player_AddAbility(player1, BP_GetAbilityBlueprint("tow_stalingrad_dispatch_t34"))
	Player_AddAbility(player1, BP_GetAbilityBlueprint("tow_stalingrad_dispatch_kat"))
	
	Player_AddAbility(player2, BP_GetAbilityBlueprint("tow_stalingrad_dispatch_su76"))
	Player_AddAbility(player2, BP_GetAbilityBlueprint("tow_stalingrad_dispatch_is2"))
	
	Player_AddAbility(player3, BP_GetAbilityBlueprint("tow_stalingrad_dispatch_kv1"))
	Player_AddAbility(player3, BP_GetAbilityBlueprint("tow_stalingrad_dispatch_t70"))
	
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("tow_stalingrad_dispatch_t34"),ITEM_REMOVED)
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("tow_stalingrad_dispatch_kat"),ITEM_REMOVED)
	
	Player_SetAbilityAvailability(player2, BP_GetAbilityBlueprint("tow_stalingrad_dispatch_su76"),ITEM_REMOVED)
	Player_SetAbilityAvailability(player2, BP_GetAbilityBlueprint("tow_stalingrad_dispatch_is2"),ITEM_REMOVED)
	
	Player_SetAbilityAvailability(player3, BP_GetAbilityBlueprint("tow_stalingrad_dispatch_kv1"),ITEM_REMOVED)
	Player_SetAbilityAvailability(player3, BP_GetAbilityBlueprint("tow_stalingrad_dispatch_t70"),ITEM_REMOVED)
	
	-- set up objectives and timer subobjectives
	ToW_SetUpBattleObjectives()
	Stalingrad_CreateSubobjectives()
	
	b4setup()
	
	add_hint()

 	Rule_AddOneShot(StartTimer, 6)
	
end

Scar_AddInit(OnInit)



function StartTimer()

	Objective_Start(OBJ_FirstDispatch, false, true)
	Rule_AddInterval(unlock_1, 0.5)

end

function Stalingrad_CreateSubobjectives()

	OBJ_FirstDispatch = {
		SetupUI = function() 
		end,
		OnStart = function()
			Objective_StartTimer(OBJ_FirstDispatch, COUNT_DOWN, 10*60)
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		IsComplete = function()
			return false
		end,
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11054972,				-- LOCDB [11054972] 'First armored deployment available in'
		Description = 0,				-- Objective Description
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		Parent = OBJ_Main,
	}

	OBJ_SecondDispatch = {
		SetupUI = function() 
		end,
		OnStart = function()
			Objective_StartTimer(OBJ_SecondDispatch, COUNT_DOWN, 10*60)
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		IsComplete = function()
			return false
		end,
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11054973,				-- LOCDB [11054972] 'Second armored deployment available in'
		Description = 0,				-- Objective Description
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		Parent = OBJ_Main,
	}
	
	Objective_Register(OBJ_FirstDispatch)
	Objective_Register(OBJ_SecondDispatch)


end










----Setting up B4 Arty-----

function b4setup()

	Util_CreateEntities(nil, eg_howy, EBP.SOVIET.M1931_203MM_B_4_HOWITZER_ARTILLERY_COMMANDER_MP, mkr_br1, 1 )
	Util_CreateEntities(nil, eg_howy, EBP.SOVIET.M1931_203MM_B_4_HOWITZER_ARTILLERY_COMMANDER_MP, mkr_br2, 1 )

	Rule_AddPlayerEvent(Dispatch_Callback, player1, GE_AbilityExecuted)
	Rule_AddPlayerEvent(Dispatch_Callback, player2, GE_AbilityExecuted)
	Rule_AddPlayerEvent(Dispatch_Callback, player3, GE_AbilityExecuted)
	
end


--
-- unlocking first set of abilities
--
function unlock_1()

	if Objective_IsTimerSet(OBJ_FirstDispatch) and Objective_GetTimerSeconds(OBJ_FirstDispatch) == 0 then
		
		Rule_RemoveMe()
		
		Objective_Complete(OBJ_FirstDispatch, false, true)
		Objective_Show(OBJ_FirstDispatch, false)
		
		-- unlock the first dispatch abilities for each player
		Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("tow_stalingrad_dispatch_t34"),ITEM_DEFAULT)
		Player_SetAbilityAvailability(player2, BP_GetAbilityBlueprint("tow_stalingrad_dispatch_su76"),ITEM_DEFAULT)
		Player_SetAbilityAvailability(player3, BP_GetAbilityBlueprint("tow_stalingrad_dispatch_t70"),ITEM_DEFAULT)

		-- bring up a title card showing off the new unlock (different message for each player)
		if Game_GetLocalPlayer() == player1 then
			UI_NewHUDFeature(HUDF_None, 11054966, "Icons_vehicles_vehicle_soviet_t34_76_heavy_tank", 10)
		elseif Game_GetLocalPlayer() == player2 then
			UI_NewHUDFeature(HUDF_None, 11054968, "Icons_vehicles_vehicle_soviet_su76m_assault_gun", 10)
		elseif Game_GetLocalPlayer() == player3 then
			UI_NewHUDFeature(HUDF_None, 11054971, "Icons_vehicles_vehicle_soviet_t70m_light_tank", 10)
		end
		
		-- flash the ability button
		flashid_t34 = UI_FlashAbilityButton(BP_GetAbilityBlueprint("tow_stalingrad_dispatch_t34"), true)
		flashid_su76 = UI_FlashAbilityButton(BP_GetAbilityBlueprint("tow_stalingrad_dispatch_su76"),true)
		flashid_t70 = UI_FlashAbilityButton(BP_GetAbilityBlueprint("tow_stalingrad_dispatch_t70"), true)
		
		-- and remove the flashing in 10 secs time
		Rule_AddOneShot(unlock_1_stop_flashing, 10)
		
	end
	
end

function unlock_1_stop_flashing()

	UI_StopFlashing(flashid_t34)
	UI_StopFlashing(flashid_su76)
	UI_StopFlashing(flashid_t70)
	
	Objective_Start(OBJ_SecondDispatch, false, true)
	
	Rule_AddInterval(unlock_2, 0.5)
	
end


--
-- unlocking second set of abilities
--
function unlock_2()

	if Objective_IsTimerSet(OBJ_SecondDispatch) and Objective_GetTimerSeconds(OBJ_SecondDispatch) == 0 then
		
		Rule_RemoveMe()
		
		Objective_Complete(OBJ_SecondDispatch, false, true)
		Objective_Show(OBJ_SecondDispatch, false)
		
		-- unlock the second dispatch abilities for each player
		Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("tow_stalingrad_dispatch_kat"),ITEM_DEFAULT)
		Player_SetAbilityAvailability(player2, BP_GetAbilityBlueprint("tow_stalingrad_dispatch_is2"),ITEM_DEFAULT)
		Player_SetAbilityAvailability(player3, BP_GetAbilityBlueprint("tow_stalingrad_dispatch_kv1"),ITEM_DEFAULT)

		-- bring up a title card showing off the new unlock (different message for each player)
		if Game_GetLocalPlayer() == player1 then
			UI_NewHUDFeature(HUDF_None, 11054970, "Icons_vehicles_vehicle_soviet_katyush_rocket_truck", 10)
		elseif Game_GetLocalPlayer() == player2 then
			UI_NewHUDFeature(HUDF_None, 11054967, "Icons_vehicles_vehicle_soviet_is2", 10)
		elseif Game_GetLocalPlayer() == player3 then
			UI_NewHUDFeature(HUDF_None, 11054969, "Icons_vehicles_vehicle_soviet_kv1_heavy_tank", 10)
		end
		
		-- flash the ability button
		flashid_kat = UI_FlashAbilityButton(BP_GetAbilityBlueprint("tow_stalingrad_dispatch_kat"), true)
		flashid_is2 = UI_FlashAbilityButton(BP_GetAbilityBlueprint("tow_stalingrad_dispatch_is2"),true)
		flashid_kv1 = UI_FlashAbilityButton(BP_GetAbilityBlueprint("tow_stalingrad_dispatch_kv1"), true)
		
		-- and remove the flashing in 10 secs time
		Rule_AddOneShot(unlock_2_stop_flashing, 10)
		
	end
	
end

function unlock_2_stop_flashing()

	UI_StopFlashing(flashid_kat)
	UI_StopFlashing(flashid_is2)
	UI_StopFlashing(flashid_kv1)
	
end


function Dispatch_Callback(caster, ability, target)
	
	if ability == BP_GetAbilityBlueprint("tow_stalingrad_dispatch_t34") then
		
		SGroup_Clear(sg_temp)
		Util_CreateSquads(caster, sg_temp, SBP.SOVIET.T_34_76_SQUAD_MP, Util_GetClosestMarker(target, t_potential_spawn_markers), target)
		SGroup_IncreaseVeterancyRank(sg_temp, 2, true)
		
	elseif ability == BP_GetAbilityBlueprint("tow_stalingrad_dispatch_su76") then
		
		SGroup_Clear(sg_temp)
		Util_CreateSquads(caster, sg_temp, SBP.SOVIET.SU_76M_MP, Util_GetClosestMarker(target, t_potential_spawn_markers), target)
		SGroup_IncreaseVeterancyRank(sg_temp, 2, true)
			
	elseif ability == BP_GetAbilityBlueprint("tow_stalingrad_dispatch_t70") then
		
		SGroup_Clear(sg_temp)
		Util_CreateSquads(caster, sg_temp, SBP.SOVIET.T_70M_MP, Util_GetClosestMarker(target, t_potential_spawn_markers), target)
		SGroup_IncreaseVeterancyRank(sg_temp, 2, true)
			
		
	elseif ability == BP_GetAbilityBlueprint("tow_stalingrad_dispatch_kat") then
		
		SGroup_Clear(sg_temp)
		Util_CreateSquads(caster, sg_temp, SBP.SOVIET.KATYUSHA_BM_13N_SQUAD_MP, Util_GetClosestMarker(target, t_potential_spawn_markers), target)
		SGroup_IncreaseVeterancyRank(sg_temp, 2, true)
	
	elseif ability == BP_GetAbilityBlueprint("tow_stalingrad_dispatch_is2") then
		
		SGroup_Clear(sg_temp)
		Util_CreateSquads(caster, sg_temp, SBP.SOVIET.IS_2_MP, Util_GetClosestMarker(target, t_potential_spawn_markers), target)
		SGroup_IncreaseVeterancyRank(sg_temp, 2, true)
		
	elseif ability == BP_GetAbilityBlueprint("tow_stalingrad_dispatch_kv1") then
			
		SGroup_Clear(sg_temp)
		local spawnpoint = 
		Util_CreateSquads(caster, sg_temp, SBP.SOVIET.KV_1_MP, Util_GetClosestMarker(target, t_potential_spawn_markers), target)
		SGroup_IncreaseVeterancyRank(sg_temp, 2, true)
			
		
	end
	
end


function add_hint()

	hint1 = HintPoint_Add(mkr_br1, true, 11054631, 3, HPAT_Hint)
	hint2 = HintPoint_Add(mkr_br2, true, 11054631, 3, HPAT_Hint)

	Event_Timer(RemoveHint, nil, 45)

end

function RemoveHint()

	HintPoint_Remove(hint1)
	HintPoint_Remove(hint2)

end



