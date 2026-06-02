-- This following code contained in this file is copyright to Mike D. Do not re-use without express permission from all copyright holders, this work is partially protected by the Digital Millenium Copyright Act (DCMA), U.S.C, Title 17.

import("ScarUtil.scar")

function OnGameSetup()

        player1 = World_GetPlayerAt(1)
        player2 = World_GetPlayerAt(2)
        player3 = World_GetPlayerAt(3)
        player4 = World_GetPlayerAt(4)
        player5 = World_GetPlayerAt(5)
        player6 = World_GetPlayerAt(6)
        player7 = World_GetPlayerAt(7)
        player8 = World_GetPlayerAt(8)

        World_EnableSharedLineOfSight(player2, player3, false)
        World_EnableSharedLineOfSight(player3, player2, false)

        World_EnableSharedLineOfSight(player6, player7, false)
        World_EnableSharedLineOfSight(player7, player6, false)

        Util_StartIntel(EVENTS.Dialogue)

end
Scar_AddInit(OnGameSetup)

function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

function OnInit()

        Rule_AddOneShot(Vision, 2)

        Rule_AddDelayedInterval(PhaseDialogueOne, 1, 1)

        Rule_AddDelayedInterval(PhaseDialogueTwo, 1, 1)

        SpawnControl()

	Player_SetPopCapOverride(player1, 300)
	Player_SetPopCapOverride(player2, 120)
	Player_SetPopCapOverride(player3, 120)
	Player_SetPopCapOverride(player4, 50)
	Player_SetPopCapOverride(player5, 300)
	Player_SetPopCapOverride(player6, 120)
	Player_SetPopCapOverride(player7, 120)
	Player_SetPopCapOverride(player8, 50)

end

Scar_AddInit(OnInit)

function Vision()

        World_EnableSharedLineOfSight(player1, player2, true)
        World_EnableSharedLineOfSight(player1, player3, true)
        World_EnableSharedLineOfSight(player1, player4, true)

        World_EnableSharedLineOfSight(player5, player6, true)
        World_EnableSharedLineOfSight(player5, player7, true)
        World_EnableSharedLineOfSight(player5, player8, true)

end


-----------------------------Phase Dialogue--------------------------------

function PhaseDialogueOne()

        local Time = World_GetGameTime()
        if Time == 600 then
               Util_StartIntel(EVENTS.PhaseOne)
        end
end

function PhaseDialogueTwo()

        local Time = World_GetGameTime()
        if Time == 1500 then
               Util_StartIntel(EVENTS.PhaseTwo)
        end
end

-----------------------------Upgrades-------------------------------

function Upgrades()

        Modify_EntityCost(player1, EBP.GERMAN.BUNKER_MP, RT_Manpower, 500)
        Modify_EntityCost(player2, EBP.GERMAN.BUNKER_MP, RT_Manpower, 500)
        Modify_EntityCost(player3, EBP.GERMAN.BUNKER_MP, RT_Manpower, 500)
        Modify_EntityCost(player4, EBP.GERMAN.BUNKER_MP, RT_Manpower, 500)
        Modify_EntityCost(player5, EBP.GERMAN.BUNKER_MP, RT_Manpower, 500)
        Modify_EntityCost(player6, EBP.GERMAN.BUNKER_MP, RT_Manpower, 500)
        Modify_EntityCost(player7, EBP.GERMAN.BUNKER_MP, RT_Manpower, 500)
        Modify_EntityCost(player8, EBP.GERMAN.BUNKER_MP, RT_Manpower, 500)

        Player_SetAbilityAvailability(player2, ABILITY.SOVIET.CONSCRIPT_MOLOTOV_COCKTAIL_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player2, ABILITY.SOVIET.ANTI_TANK_GRENADE_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player3, ABILITY.SOVIET.CONSCRIPT_MOLOTOV_COCKTAIL_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player3, ABILITY.SOVIET.ANTI_TANK_GRENADE_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player4, ABILITY.SOVIET.CONSCRIPT_MOLOTOV_COCKTAIL_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player4, ABILITY.SOVIET.ANTI_TANK_GRENADE_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player6, ABILITY.SOVIET.CONSCRIPT_MOLOTOV_COCKTAIL_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player6, ABILITY.SOVIET.ANTI_TANK_GRENADE_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player7, ABILITY.SOVIET.CONSCRIPT_MOLOTOV_COCKTAIL_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player7, ABILITY.SOVIET.ANTI_TANK_GRENADE_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player8, ABILITY.SOVIET.CONSCRIPT_MOLOTOV_COCKTAIL_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player8, ABILITY.SOVIET.ANTI_TANK_GRENADE_MP, ITEM_UNLOCKED)

        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
        Player_SetAbilityAvailability(player2, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player2, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
        Player_SetAbilityAvailability(player3, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player3, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)
        Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
        Player_SetAbilityAvailability(player4, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player4, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
        Player_SetAbilityAvailability(player6, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player6, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
        Player_SetAbilityAvailability(player7, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player7, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
        Player_SetAbilityAvailability(player8, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player8, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)

        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("building_1"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("building_2"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("building_3"))
        Player_SetAbilityAvailability(player2, ABILITY.WEST_GERMAN.VOLKSGRENADIER_GRENADE_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player2, ABILITY.WEST_GERMAN.VOLKSGRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("building_1"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("building_2"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("building_3"))
        Player_SetAbilityAvailability(player3, ABILITY.WEST_GERMAN.VOLKSGRENADIER_GRENADE_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player3, ABILITY.WEST_GERMAN.VOLKSGRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("building_1"))
        Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("building_2"))
        Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("building_3"))
        Player_SetAbilityAvailability(player4, ABILITY.WEST_GERMAN.VOLKSGRENADIER_GRENADE_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player4, ABILITY.WEST_GERMAN.VOLKSGRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)

        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("building_1"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("building_2"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("building_3"))
        Player_SetAbilityAvailability(player6, ABILITY.WEST_GERMAN.VOLKSGRENADIER_GRENADE_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player6, ABILITY.WEST_GERMAN.VOLKSGRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("building_1"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("building_2"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("building_3"))
        Player_SetAbilityAvailability(player7, ABILITY.WEST_GERMAN.VOLKSGRENADIER_GRENADE_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player7, ABILITY.WEST_GERMAN.VOLKSGRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("building_1"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("building_2"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("building_3"))
        Player_SetAbilityAvailability(player8, ABILITY.WEST_GERMAN.VOLKSGRENADIER_GRENADE_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player8, ABILITY.WEST_GERMAN.VOLKSGRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)

end

Scar_AddInit(Upgrades)

-----------------------------Ability----------------------------

function Abilities()

       	Player_AddAbility(player1, ABILITY.GLOBAL.TRANSFER_ORDERS)
       	Player_AddAbility(player2, ABILITY.GLOBAL.TRANSFER_ORDERS)
       	Player_AddAbility(player3, ABILITY.GLOBAL.TRANSFER_ORDERS)
       	Player_AddAbility(player4, ABILITY.GLOBAL.TRANSFER_ORDERS)
       	Player_AddAbility(player5, ABILITY.GLOBAL.TRANSFER_ORDERS)
       	Player_AddAbility(player6, ABILITY.GLOBAL.TRANSFER_ORDERS)
       	Player_AddAbility(player7, ABILITY.GLOBAL.TRANSFER_ORDERS)
       	Player_AddAbility(player8, ABILITY.GLOBAL.TRANSFER_ORDERS)

end

Scar_AddInit(Abilities)

------------------------------Building Restrictions----------------------------

function BuildingRestrict()

        Player_SetEntityProductionAvailability(player2, EBP.GERMAN.SCHWERES_KRIEGSWERK_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.GERMAN.HINTERE_PANZERWERK_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.GERMAN.BEREICH_FESTUNG_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.GERMAN.DOLCH_AKTIONEN_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player3, EBP.GERMAN.SCHWERES_KRIEGSWERK_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player3, EBP.GERMAN.HINTERE_PANZERWERK_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player3, EBP.GERMAN.BEREICH_FESTUNG_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player3, EBP.GERMAN.DOLCH_AKTIONEN_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player4, EBP.GERMAN.SCHWERES_KRIEGSWERK_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player4, EBP.GERMAN.HINTERE_PANZERWERK_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player4, EBP.GERMAN.BEREICH_FESTUNG_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player4, EBP.GERMAN.DOLCH_AKTIONEN_MP, ITEM_REMOVED)

        Player_SetEntityProductionAvailability(player6, EBP.GERMAN.SCHWERES_KRIEGSWERK_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player6, EBP.GERMAN.HINTERE_PANZERWERK_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player6, EBP.GERMAN.BEREICH_FESTUNG_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player6, EBP.GERMAN.DOLCH_AKTIONEN_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player7, EBP.GERMAN.SCHWERES_KRIEGSWERK_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player7, EBP.GERMAN.HINTERE_PANZERWERK_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player7, EBP.GERMAN.BEREICH_FESTUNG_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player7, EBP.GERMAN.DOLCH_AKTIONEN_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player8, EBP.GERMAN.SCHWERES_KRIEGSWERK_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player8, EBP.GERMAN.HINTERE_PANZERWERK_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player8, EBP.GERMAN.BEREICH_FESTUNG_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player8, EBP.GERMAN.DOLCH_AKTIONEN_MP, ITEM_REMOVED)

        Player_SetEntityProductionAvailability(player2, EBP.SOVIET.BARRACKS_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.SOVIET.MOTORPOOL_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.SOVIET.TANK_DEPOT_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.SOVIET.WEAPON_SUPPORT_CENTER_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player3, EBP.SOVIET.BARRACKS_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player3, EBP.SOVIET.MOTORPOOL_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player3, EBP.SOVIET.TANK_DEPOT_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player3, EBP.SOVIET.WEAPON_SUPPORT_CENTER_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player4, EBP.SOVIET.BARRACKS_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player4, EBP.SOVIET.MOTORPOOL_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player4, EBP.SOVIET.TANK_DEPOT_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player4, EBP.SOVIET.WEAPON_SUPPORT_CENTER_MP, ITEM_REMOVED)

        Player_SetEntityProductionAvailability(player6, EBP.SOVIET.BARRACKS_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player6, EBP.SOVIET.MOTORPOOL_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player6, EBP.SOVIET.TANK_DEPOT_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player6, EBP.SOVIET.WEAPON_SUPPORT_CENTER_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player7, EBP.SOVIET.BARRACKS_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player7, EBP.SOVIET.MOTORPOOL_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player7, EBP.SOVIET.TANK_DEPOT_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player7, EBP.SOVIET.WEAPON_SUPPORT_CENTER_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player8, EBP.SOVIET.BARRACKS_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player8, EBP.SOVIET.MOTORPOOL_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player8, EBP.SOVIET.TANK_DEPOT_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player8, EBP.SOVIET.WEAPON_SUPPORT_CENTER_MP, ITEM_REMOVED)


end

Scar_AddInit(BuildingRestrict)

-----------------------------Starting Elites---------------------------

function StartingElites()

        Modify_ReceivedDamage(AlliesStartElites, 0.6)
        Modify_ReceivedAccuracy(AlliesStartElites, 0.6)
        local EliteName1 = Util_CreateLocString("Veteran Partisan Scouts")
        HintMouseover_Add(EliteName1, AlliesStartElites, 5, true)
        SGroup_IncreaseVeterancyRank(AlliesStartElites, 3, false)

        Modify_ReceivedDamage(AxisStartElites, 0.7)
        Modify_ReceivedAccuracy(AxisStartElites, 0.8)
        local EliteName2 = Util_CreateLocString("Ostfront Reconnaissance Veterans")
        HintMouseover_Add(EliteName2, AxisStartElites, 5, true)
        SGroup_IncreaseVeterancyRank(AxisStartElites, 5, false)

end

Scar_AddInit(StartingElites)

-----------------------------Spawn Control-------------------------------

function SpawnControl()

        Rule_AddDelayedInterval(PlayerTwo, 1, 100)

        Rule_AddDelayedInterval(PlayerThree, 1, 130)

        Rule_AddDelayedInterval(SpawnFour, 1, 180)

        Rule_AddDelayedInterval(PlayerSix, 1, 100)

        Rule_AddDelayedInterval(PlayerSeven, 1, 130)

        Rule_AddDelayedInterval(SpawnEight, 1, 180)

end

function PlayerTwo()

        local Time = World_GetGameTime()
        if Time < 600 then
                SpawnTwoOne()
        elseif Time < 1500 then
                SpawnTwoTwo()
        elseif Time > 1500 then
                SpawnTwoThree()
        end
end

function PlayerThree()

        local Time = World_GetGameTime()
        if Time < 600 then
                SpawnThreeOne()
        elseif Time < 1500 then
                SpawnThreeTwo()
        elseif Time > 1500 then
                SpawnThreeThree()
        end
end

function PlayerSix()

        local Time = World_GetGameTime()
        if Time < 600 then
                SpawnSixOne()
        elseif Time < 1500 then
                SpawnSixTwo()
        elseif Time > 1500 then
                SpawnSixThree()
        end
end

function PlayerSeven()

        local Time = World_GetGameTime()
        if Time < 600 then
                SpawnSevenOne()
        elseif Time < 1500 then
                SpawnSevenTwo()
        elseif Time > 1500 then
                SpawnSevenThree()
        end
end



------------------------------Spawn Two--------------------------------

function SpawnTwoOne()

        local Random = World_GetRand(1, 7)
        if Random == 1 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 2 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.COMMISSAR_SQUAD_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 3 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.PENAL_BATTALION_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 4 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.COMBAT_ENGINEER_SQUAD_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 5 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 6 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.PARTISANS_PTRS_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 7 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.PARTISAN_SQUAD_NAGANT_RIFLE_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        end
end

function SpawnTwoTwo()

        local Random = World_GetRand(1, 9)
        if Random == 1 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.PM_82_41_MORTAR_SQUAD_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 2 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 3 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 4 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.GUARDS_TROOPS_ASSAULT_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 5 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.PENAL_BATTALION_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 6 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 7 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 8 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.COMBAT_ENGINEER_SQUAD_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 9 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)

        end
end

function SpawnTwoThree()

        local Random = World_GetRand(1, 12)
        if Random == 1 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.PM_82_41_MORTAR_SQUAD_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 2 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.DSHK_38_HMG_SQUAD_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 3 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 4 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 5 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.PENAL_BATTALION_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 6 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 7 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 8 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.COMBAT_ENGINEER_SQUAD_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 9 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.M5_HALFTRACK_SQUAD_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 10 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 11 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)
        elseif Random == 12 then
                Util_CreateSquads(player2, GroupTwo, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP, mkr_spawn2)
                Util_StartIntel(EVENTS.ToTwo)

        end
end


------------------------------Spawn Three--------------------------------

function SpawnThreeOne()

        local Random = World_GetRand(1, 3)
        if Random == 1 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD_MP, mkr_spawn3)
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)
        elseif Random == 2 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.SU_76M_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)
        elseif Random == 3 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.T_34_76_SQUAD_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)

        end
end

function SpawnThreeTwo()

        local Random = World_GetRand(1, 8)
        if Random == 1 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.KATYUSHA_BM_13N_SQUAD_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)
        elseif Random == 2 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.SU_85_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)
        elseif Random == 3 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.T_34_76_SQUAD_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)
        elseif Random == 4 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.KV_1_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)
        elseif Random == 5 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.M5_HALFTRACK_SQUAD_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)
        elseif Random == 6 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.SU_76M_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)
        elseif Random == 7 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.T_70M_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)
        elseif Random == 8 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.T_34_85_SQUAD_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)
        end
end

function SpawnThreeThree()

        local Random = World_GetRand(1, 14)
        if Random == 1 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.KATYUSHA_BM_13N_SQUAD_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)
        elseif Random == 2 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.SU_85_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)
        elseif Random == 3 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.T_70M_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)
        elseif Random == 4 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.KV_1_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)
        elseif Random == 5 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.M5_HALFTRACK_SQUAD_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)
        elseif Random == 6 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.T_34_85_SQUAD_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)
        elseif Random == 7 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.KV_8_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)
        elseif Random == 8 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.KV_2_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)
        elseif Random == 9 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.KV_2_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)
        elseif Random == 10 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.IS_2_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)
        elseif Random == 11 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.IS_2_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)
        elseif Random == 12 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.ISU_152_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)
        elseif Random == 13 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.ISU_152_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)
        elseif Random == 14 then
                Util_CreateSquads(player3, GroupThree, SBP.SOVIET.SOVIET_76MM_SHERMAN_MP, mkr_spawn3)
                Util_StartIntel(EVENTS.ToThree)

        end
end



------------------------------Spawn Four-------------------------------

function SpawnFour()

        local Random = World_GetRand(1, 11)
        if Random == 1 then
                local Control = SGroup_Count(AlliesOne)
                if Control == 0 then
                        Util_StartIntel(EVENTS.EliteAlliesOne)
                elseif Control == 1 then
                        SpawnFour()
                end
        elseif Random == 2 then
                local Control = SGroup_Count(AlliesTwo)
                if Control == 0 then
                        Util_StartIntel(EVENTS.EliteAlliesTwo)
                elseif Control == 1 then
                        SpawnFour()
                end
        elseif Random == 3 then
                local Control = SGroup_Count(AlliesThree)
                if Control == 0 then
                        Util_StartIntel(EVENTS.EliteAlliesThree)
                elseif Control == 1 then
                        SpawnFour()
                end
        elseif Random == 4 then
                local Control = SGroup_Count(AlliesFour)
                if Control == 0 then
                        Util_StartIntel(EVENTS.EliteAlliesFour)
                elseif Control == 1 then
                        SpawnFour()
                end
        elseif Random == 5 then
                local Control = SGroup_Count(AlliesFive)
                if Control == 0 then
                        Util_StartIntel(EVENTS.EliteAlliesFive)
                elseif Control == 1 then
                        SpawnFour()
                end
        elseif Random == 6 then
                local Control = SGroup_Count(AlliesSix)
                if Control == 0 then
                        Util_StartIntel(EVENTS.EliteAlliesSix)
                elseif Control == 1 then
                        SpawnFour()
                end
        elseif Random == 7 then
                local Control = SGroup_Count(AlliesSeven)
                if Control == 0 then
                        Util_StartIntel(EVENTS.EliteAlliesSeven)
                elseif Control == 1 then
                        SpawnFour()
                end
        elseif Random == 8 then
                local Control = SGroup_Count(AlliesEight)
                if Control == 0 then
                        Util_StartIntel(EVENTS.EliteAlliesEight)
                elseif Control == 1 then
                        SpawnFour()
                end
        elseif Random == 9 then
                local Control = SGroup_Count(AlliesNine)
                if Control == 0 then
                        Util_StartIntel(EVENTS.EliteAlliesNine)
                elseif Control == 1 then
                        SpawnFour()
                end
        elseif Random == 10 then
                local Control = SGroup_Count(AlliesTen)
                if Control == 0 then
                        Util_StartIntel(EVENTS.EliteAlliesTen)
                elseif Control == 1 then
                        SpawnFour()
                end
        elseif Random == 11 then
                FailsafeAllies()
        end
end

function FailsafeAllies()

        local Control1 = SGroup_Count(AlliesOne)
        local Control2 = SGroup_Count(AlliesTwo)
        local Control3 = SGroup_Count(AlliesThree)
        local Control4 = SGroup_Count(AlliesFour)
        local Control5 = SGroup_Count(AlliesFive)
        local Control6 = SGroup_Count(AlliesSix)
        local Control7 = SGroup_Count(AlliesSeven)
        local Control8 = SGroup_Count(AlliesEight)
        local Control9 = SGroup_Count(AlliesNine)
        local Control10 = SGroup_Count(AlliesTen)

        if Control1 == 0 or Control2 == 0 or Control3 == 0 or Control4 == 0 or Control5 == 0 or Control6 == 0 or Control7 == 0 or Control8 == 0 or Control9 == 0 or Control10 == 0 then
                SpawnFour()
        end
end


------------------------------Spawn Six-----------------------------

function SpawnSixOne()

        local Random = World_GetRand(1, 6)
        if Random == 1 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 2 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.OSTRUPPEN_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 3 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 4 then
                Util_CreateSquads(player6, GroupSix, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 5 then
                Util_CreateSquads(player6, GroupSix, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 6 then
                Util_CreateSquads(player6, GroupSix, SBP.WEST_GERMAN.RAKETENWERFER43_88MM_PUPPCHEN_ANTITANK_GUN_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)

        end
end

function SpawnSixTwo()

        local Random = World_GetRand(1, 10)
        if Random == 1 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 2 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 3 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 4 then
                Util_CreateSquads(player6, GroupSix, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 5 then
                Util_CreateSquads(player6, GroupSix, SBP.WEST_GERMAN.RAKETENWERFER43_88MM_PUPPCHEN_ANTITANK_GUN_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 6 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 7 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.MORTAR_TEAM_81MM_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 8 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.STORMTROOPER_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 9 then
                Util_CreateSquads(player6, GroupSix, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 10 then
                Util_CreateSquads(player6, GroupSix, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)

        end
end

function SpawnSixThree()

        local Random = World_GetRand(1, 15)
        if Random == 1 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 2 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 3 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 4 then
                Util_CreateSquads(player6, GroupSix, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 5 then
                Util_CreateSquads(player6, GroupSix, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 6 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 7 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.MORTAR_TEAM_81MM_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 8 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.STORMTROOPER_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 9 then
                Util_CreateSquads(player6, GroupSix, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 10 then
                Util_CreateSquads(player6, GroupSix, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 11 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 12 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 13 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.URBAN_ASSAULT_PANZER_GRENADIER_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 14 then
                Util_CreateSquads(player6, GroupSix, SBP.WEST_GERMAN.TERROR_OFFICER_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)
        elseif Random == 15 then
                Util_CreateSquads(player6, GroupSix, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, mkr_spawn6)
                Util_StartIntel(EVENTS.ToSix)

        end
end

------------------------------Spawn Seven------------------------------------

function SpawnSevenOne()

        local Random = World_GetRand(1, 4)
        if Random == 1 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.SCOUTCAR_SDKFZ222_MP, mkr_spawn7)
                Util_CreateSquads(player7, GroupSeven, SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 2 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.PUMA_EAST_GERMAN_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 3 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.STUG_III_E_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 4 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.PANZER_IV_STUBBY_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        end
end

function SpawnSevenTwo()

        local Random = World_GetRand(1, 11)
        if Random == 1 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.SCOUTCAR_SDKFZ222_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 2 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.STUG_III_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 3 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.PANZER_IV_STUBBY_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 4 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.OSTWIND_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 5 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.PUMA_EAST_GERMAN_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 6 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.PANZERWERFER_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 7 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 8 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.PANZER_IV_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 9 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.MORTAR_250_HALFTRACK_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 10 then
                Util_CreateSquads(player7, GroupSeven, SBP.WEST_GERMAN.HETZER_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 11 then
                Util_CreateSquads(player7, GroupSeven, SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        end
end

function SpawnSevenThree()

        local Random = World_GetRand(1, 17)
        if Random == 1 then
                Util_CreateSquads(player7, GroupSeven, SBP.WEST_GERMAN.SDKFZ_251_20_IR_SEARCHLIGHT_HALFTRACK_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 2 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.STUG_III_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 3 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.ELEFANT_TANK_DESTROYER_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 4 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.OSTWIND_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 5 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.BRUMMBAR_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 6 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.PANZERWERFER_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 7 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 8 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.PANZER_IV_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 9 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.PANZER_IV_COMMAND_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 10 then
                Util_CreateSquads(player7, GroupSeven, SBP.WEST_GERMAN.HETZER_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 11 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.PANTHER_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 12 then
                Util_CreateSquads(player7, GroupSeven, SBP.WEST_GERMAN.KING_TIGER_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 13 then
                Util_CreateSquads(player7, GroupSeven, SBP.WEST_GERMAN.JAGDTIGER_TD_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 14 then
                Util_CreateSquads(player7, GroupSeven, SBP.WEST_GERMAN.JAGDPANZER_TANK_DESTROYER_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 15 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.TIGER_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 16 then
                Util_CreateSquads(player7, GroupSeven, SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 17 then
                Util_CreateSquads(player7, GroupSeven, SBP.WEST_GERMAN.SDKFZ_251_WURFRAHMEN_40_HALFTRACK_SQUAD_MP, mkr_spawn7)
                Util_StartIntel(EVENTS.ToSeven)

        end
end

------------------------------Spawn Eight-------------------------------

function SpawnEight()

        local Random = World_GetRand(1, 11)
        if Random == 1 then
                local Control = SGroup_Count(AxisOne)
                if Control == 0 then
                        Util_StartIntel(EVENTS.EliteAxisOne)
                elseif Control == 1 then
                        SpawnEight()
                end
        elseif Random == 2 then
                local Control = SGroup_Count(AxisTwo)
                if Control == 0 then
                        Util_StartIntel(EVENTS.EliteAxisTwo)
                elseif Control == 1 then
                        SpawnEight()
                end
        elseif Random == 3 then
                local Control = SGroup_Count(AxisThree)
                if Control == 0 then
                        Util_StartIntel(EVENTS.EliteAxisThree)
                elseif Control == 1 then
                        SpawnEight()
                end
        elseif Random == 4 then
                local Control = SGroup_Count(AxisFour)
                if Control == 0 then
                        Util_StartIntel(EVENTS.EliteAxisFour)
                elseif Control == 1 then
                        SpawnEight()
                end
        elseif Random == 5 then
                local Control = SGroup_Count(AxisFive)
                if Control == 0 then
                        Util_StartIntel(EVENTS.EliteAxisFive)
                elseif Control == 1 then
                        SpawnEight()
                end
        elseif Random == 6 then
                local Control = SGroup_Count(AxisSix)
                if Control == 0 then
                        Util_StartIntel(EVENTS.EliteAxisSix)
                elseif Control == 1 then
                        SpawnEight()
                end
        elseif Random == 7 then
                local Control = SGroup_Count(AxisSeven)
                if Control == 0 then
                        Util_StartIntel(EVENTS.EliteAxisSeven)
                elseif Control == 1 then
                        SpawnEight()
                end
        elseif Random == 8 then
                local Control = SGroup_Count(AxisEight)
                if Control == 0 then
                        Util_StartIntel(EVENTS.EliteAxisEight)
                elseif Control == 1 then
                        SpawnEight()
                end
        elseif Random == 9 then
                local Control = SGroup_Count(AxisNine)
                if Control == 0 then
                        Util_StartIntel(EVENTS.EliteAxisNine)
                elseif Control == 1 then
                        SpawnEight()
                end
        elseif Random == 10 then
                local Control = SGroup_Count(AxisTen)
                if Control == 0 then
                        Util_StartIntel(EVENTS.EliteAxisTen)
                elseif Control == 1 then
                        SpawnEight()
                end
        elseif Random == 11 then
                FailsafeAxis()
        end
end

function FailsafeAxis()

        local Control1 = SGroup_Count(AxisOne)
        local Control2 = SGroup_Count(AxisTwo)
        local Control3 = SGroup_Count(AxisThree)
        local Control4 = SGroup_Count(AxisFour)
        local Control5 = SGroup_Count(AxisFive)
        local Control6 = SGroup_Count(AxisSix)
        local Control7 = SGroup_Count(AxisSeven)
        local Control8 = SGroup_Count(AxisEight)
        local Control9 = SGroup_Count(AxisNine)
        local Control10 = SGroup_Count(AxisTen)

        if Control1 == 0 or Control2 == 0 or Control3 == 0 or Control4 == 0 or Control5 == 0 or Control6 == 0 or Control7 == 0 or Control8 == 0 or Control9 == 0 or Control10 == 0 then
                SpawnEight()
        end
end



------------------------------Events and Actors--------------------

ACTOR = {
	
	__scardoc_enum = true,

	None					= "",

        Friedrich = "Icons_portraits_unit_german_panzer_grenadiers_w_portrait",
        Ulrich = "Icons_portraits_unit_german_grenadiers_w_portrait",
        Jozef = "Icons_portraits_unit_west_german_assault_pioneer_w_portrait",
        Hans = "Icons_portraits_unit_west_german_honor_guard_w_portrait",
        Tomislav = "Icons_portraits_unit_west_german_volksgrenadier_w_portrait",
        Simmons = "Icons_portraits_unit_aef_captain_w_portrait",
        British = "Icons_portraits_unit_british_officer_w_portrait",

	-- Generic Russians
	Russian_Commissar		= "Icons_portraits_dialogue_soviet_commissar_s_portrait",
	Russian_Junior_Officer	= "Icons_portraits_dialogue_soviet_poznan_officer_01_w_portrait", -- Poznan_01 looks junior. No unique art for "junior officer".
	Russian_Senior_Officer	= "Icons_portraits_dialogue_soviet_senior_officer_s_portrait",
	Russian_Radio_Command	= "Icons_portraits_dialogue_soviet_command_radio_s_portrait",
	
	Russian_Soldier_01		= "Icons_portraits_dialogue_soviet_soldier_01_s_portrait",
	Russian_Soldier_02		= "Icons_portraits_dialogue_soviet_soldier_02_s_portrait",
	Russian_Soldier_03		= "Icons_portraits_dialogue_soviet_soldier_03_s_portrait",
	Russian_Soldier_04		= "Icons_portraits_dialogue_soviet_soldier_04_s_portrait",
	Russian_Soldier_05		= "Icons_portraits_dialogue_soviet_soldier_05_s_portrait",
	Russian_Soldier_06		= "Icons_portraits_dialogue_soviet_soldier_06_s_portrait",
	Russian_Soldier_07		= "Icons_portraits_dialogue_soviet_soldier_07_s_portrait",
	
	Russian_Sniper			= "Icons_portraits_dialogue_soviet_sniper_s_portrait",
	
	Russian_Engineer		= "Icons_portraits_dialogue_soviet_engineer_s_portrait",
	
	Russian_Tank_Commander	= "Icons_portraits_dialogue_soviet_tank_commander_s_portrait",
	Russian_Tank_Gunner		= "Icons_portraits_dialogue_soviet_tank_gunner_s_portrait",
	Russian_Tank_Officer	= "Icons_portraits_dialogue_soviet_tank_officer_s_portrait",
	
	Civilian				= "Icons_portraits_dialogue_civilian_s_portrait",
	Civilian_Female			= "Icons_portraits_dialogue_civilian_female_s_portrait",
	
	Partisans				= "Icons_portraits_dialogue_partisan_male_s_portrait",
	Partisans_Female 		= "Icons_portraits_dialogue_partisan_female_s_portrait",
	
	-- CoH2 Campaign
	Ania					= "Icons_portraits_dialogue_ania_s_portrait",
	Churkin					= "Icons_portraits_dialogue_churkin_s_portrait",
	Isakovich				= "Icons_portraits_dialogue_isakovich_s_portrait",
	Polivanov				= "Icons_portraits_dialogue_major_polivanov_s_portrait",
	Pozharsky				= "Icons_portraits_dialogue_pozharski_s_portrait",
	Yuri					= "Icons_portraits_dialogue_yuri_s_portrait",
	
	Poznan_Officer_01		= "Icons_portraits_dialogue_soviet_poznan_officer_01_w_portrait",
	Poznan_Officer_02		= "Icons_portraits_dialogue_soviet_poznan_officer_02_w_portrait",
	
	-- Generic Germans
	German_Officer			= "Icons_portraits_dialogue_german_officer_s_portrait",
	German_Ostruppen		= "Icons_portraits_dialogue_german_ostruppen_s_portrait",
	German_Grenadier		= "Icons_portraits_dialogue_german_grenadier_s_portrait",
	German_Panzer_Grenadier	= "Icons_portraits_dialogue_german_panzer_grenadier_s_portrait",
	German_Artillery		= "Icons_portraits_dialogue_german_artillery_officer_s_portrait",
	
	-- CoH2 XP1
	Derby					= {nameID = 11077130, icon = "Icons_bob_companies_dialog_support"},					-- Dog Company – Support
	Vastano					= {nameID = 11077122, icon = "Icons_bob_companies_dialog_airborne"},				-- Able Company - Airborne
	Edwards					= {nameID = 11077126, icon = "Icons_bob_companies_dialog_infantry"},				-- Baker Company - Mechanized
	Durante					= {nameID = 11081058, icon = "Icons_bob_companies_dialog_ranger"},					-- Fox Company - Ranger
	Jackson					= {nameID = 11077132, icon = "Icons_portraits_dialogue_aef_captain_w_portrait"},	-- the commander in the intro mission, temp since we have no jackson portrait
	
	Ouren_112th 			= {nameID = 11080987, icon = ""},	
	Houffalize_1st 			= {nameID = 11080988, icon = ""},	
	
	-- Generic Americans
	American_Riflemen_01	= "Icons_portraits_dialogue_aef_rifleman_w_portrait",
	American_Engineer_01	= "Icons_portraits_dialogue_aef_assault_engineer_w_portrait",
	American_Paratrooper_01	= "Icons_portraits_dialogue_aef_paratrooper_w_portrait", -- temp
	
	American_Lieutenant_01	= "Icons_portraits_dialogue_aef_lieutenant_w_portrait",
	American_Captain_01		= "Icons_portraits_dialogue_aef_captain_w_portrait",
	American_Major_01		= "Icons_portraits_dialogue_aef_major_w_portrait",
}






























--------------------------------Resources----------------------------------

function Second()

Modify_PlayerResourceRate(player2, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player2, RT_Munition, 1, MUT_Multiplication)
Modify_PlayerResourceRate(player2, RT_Manpower, 1, MUT_Multiplication)
Modify_PlayerResourceRate(player2, RT_Action, 1, MUT_Multiplication)

end

Scar_AddInit(Second)

function Third()

Modify_PlayerResourceRate(player3, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player3, RT_Munition, 1, MUT_Multiplication)
Modify_PlayerResourceRate(player3, RT_Manpower, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player3, RT_Action, 1, MUT_Multiplication)

end

Scar_AddInit(Third)

function Fourth()

Modify_PlayerResourceRate(player4, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player4, RT_Munition, 0.6, MUT_Multiplication)
Modify_PlayerResourceRate(player4, RT_Manpower, 0.3, MUT_Multiplication)
Modify_PlayerResourceRate(player4, RT_Action, 1, MUT_Multiplication)

end

Scar_AddInit(Fourth)

function Sixth()

Modify_PlayerResourceRate(player6, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player6, RT_Munition, 1, MUT_Multiplication)
Modify_PlayerResourceRate(player6, RT_Manpower, 1, MUT_Multiplication)
Modify_PlayerResourceRate(player6, RT_Action, 1, MUT_Multiplication)

end

Scar_AddInit(Sixth)

function Seventh()

Modify_PlayerResourceRate(player7, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player7, RT_Munition, 1, MUT_Multiplication)
Modify_PlayerResourceRate(player7, RT_Manpower, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player7, RT_Action, 1, MUT_Multiplication)

end

Scar_AddInit(Seventh)

function Eighth()

Modify_PlayerResourceRate(player8, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player8, RT_Munition, 0.6, MUT_Multiplication)
Modify_PlayerResourceRate(player8, RT_Manpower, 0.3, MUT_Multiplication)
Modify_PlayerResourceRate(player8, RT_Action, 1, MUT_Multiplication)

end

Scar_AddInit(Eighth)

function CustomStartingResources_Init()
	--[[
	
	Some information about income_modifier table and how to use it:
		- All resource income modifiers affect the # per minute value.
		- By default all resource income modifiers are set to 1 (value = 1, math_type = MUT_Multiplication). As you know, anything * 1 is the same value.
		- MUT_Multiplication multiplies the income rate and MUT_Addition adds to it. Here are some examples of that:
			- Let's say manpower income is 294 manpower per minute. With value = 10, math_type = MUT_Multiplication we will get 2940 manpower per minute,
			since 294 * 10 = 2940.
			Let's say manpower income is still 294 manpower per minute. With value = 10, math_type = MUT_Addition, we will get 304 manpower per minute, 
			since 294 + 10 = 304.
			
		- How to add 50 extra munition income? 
			{type = RT_Munition, value = 50, math_type = MUT_Addition}
		
		- How to remove 100 from manpower income?
			{type = RT_Manpower, value = -100, math_type = MUT_Addition}
			
		- How to double manpower income?
			{type = RT_Manpower, value = 2, math_type = MUT_Multiplication}
	]]
	
	local ResourceSets = {
		standard = {
			--german:
			[0] = {
				manpower = 490,
				fuel = 20,
				munition = 0,
				action = 0,
				command = 1,
			},
			--soviet:
			[1] = {
				manpower = 490,
				fuel = 50,
				munition = 0,
				action = 0,
				command = 1,

			},
			--Obercommando west:
			[2] = {
				manpower = 240,
				fuel = 40,
				munition = 0,
				action = 0,
				command = 1,
			},
			--us forces:
			[3] = {
				manpower = 400,
				fuel = 15,
				munition = 0,
				action = 0,
				command = 1,
			},
			[4] = {
				manpower = 400,
				fuel = 15,
				munition = 0,
				action = 0,
				command = 1,
			},
			[5] = {
				manpower = 400,
				fuel = 15,
				munition = 0,
				action = 0,
				command = 1,
			},
			[6] = {
				manpower = 400,
				fuel = 15,
				munition = 0,
				action = 0,
				command = 1,
			},
			[7] = {
				manpower = 400,
				fuel = 15,
				munition = 0,
				action = 0,
				command = 1,
			},
			income_modifier = {
				{type = RT_Manpower, value = 1, math_type = MUT_Multiplication}, -- manpower. math_type = MUT_Multiplication OR MUT_Addition
				{type = RT_Munition, value = 1, math_type = MUT_Multiplication}, -- munition. math_type = MUT_Multiplication OR MUT_Addition
				{type = RT_Fuel, value = 1, math_type = MUT_Multiplication}, -- fuel. math_type = MUT_Multiplication OR MUT_Addition
				{type = RT_Action, value = 1, math_type = MUT_Multiplication}, -- action/xp. math_type = MUT_Multiplication OR MUT_Addition
			},
		},
		customSet_01 = {
			--player 1:
			[0] = {
				manpower = 0,
				fuel = 0,
				munition = 0,
				action = 0,
				command = 0,
			},
			--player 2:
			[1] = {
				manpower = 0,
				fuel = 0,
				munition = 0,
				action = 0,
				command = 0,
			},
			--player 3:
			[2] = {
				manpower = 0,
				fuel = 0,
				munition = 0,
				action = 0,
				command = 0,
			},
			--player 4:
			[3] = {
				manpower = 0,
				fuel = 0,
				munition = 0,
				action = 0,
				command = 0,
			},
			[4] = {
				manpower = 0,
				fuel = 0,
				munition = 0,
				action = 0,
				command = 0,
			},
			[5] = {
				manpower = 0,
				fuel = 0,
				munition = 0,
				action = 0,
				command = 0,
			},
			[6] = {
				manpower = 0,
				fuel = 0,
				munition = 0,
				action = 0,
				command = 0,
			},
			[7] = {
				manpower = 0,
				fuel = 0,
				munition = 0,
				action = 0,
				command = 0,
			},
		income_modifier = {
			{type = RT_Manpower, value = 1, math_type = MUT_Multiplication}, -- manpower. math_type = MUT_Multiplication OR MUT_Addition
			{type = RT_Munition, value = 1, math_type = MUT_Multiplication}, -- munition. math_type = MUT_Multiplication OR MUT_Addition
			{type = RT_Fuel, value = 1, math_type = MUT_Multiplication}, -- fuel. math_type = MUT_Multiplication OR MUT_Addition
			{type = RT_Action, value = 1, math_type = MUT_Multiplication}, -- action/xp. math_type = MUT_Multiplication OR MUT_Addition
		},
                }, 
	}
	--This will set the resource set to use in-game
	local g_ResourceSet = ResourceSets.customSet_01
	
	local Player_ApplyResourceSet = function(player, resourceSet)
		Player_SetResource(player, RT_Manpower, resourceSet.manpower)
		Player_SetResource(player, RT_Fuel, resourceSet.fuel)
		Player_SetResource(player, RT_Munition, resourceSet.munition)
		Player_SetResource(player, RT_Action, resourceSet.action)
		Player_SetResource(player, RT_Command, resourceSet.command)	
	end
	
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		local resource_set = g_ResourceSet[Player_GetRaceIndex(player)]
		Player_ApplyResourceSet(player, resource_set)
		for key, resource in ipairs(g_ResourceSet.income_modifier) do
			local _value = resource.value
			if resource.math_type == MUT_Addition then
				_value = _value / (60 * 8)
			end
			Modify_PlayerResourceRate(player, resource.type, _value, resource.math_type)
		end
	end
end

function Player_GetRaceIndex(player)
	local racename = player
	if racename == World_GetPlayerAt(1) then
		return 0
	elseif racename == World_GetPlayerAt(2) then
		return 1
	elseif racename == World_GetPlayerAt(3) then
		return 2
	elseif racename == World_GetPlayerAt(4) then
		return 3
	elseif racename == World_GetPlayerAt(5) then
		return 4
	elseif racename == World_GetPlayerAt(6) then
		return 5
	elseif racename == World_GetPlayerAt(7) then
		return 6
	elseif racename == World_GetPlayerAt(8) then
		return 7
	end
end

Scar_AddInit(CustomStartingResources_Init)

--------------------------------------Events---------------------------------------

EVENTS = {}

        local Text1 = Util_CreateLocString("Commanders...")
        local Text2 = Util_CreateLocString("You have been sent to this area to support the local forces in capturing this critical set of fortifications.")
        local Text3 = Util_CreateLocString("Communications and logistics has been severely disrupted by the enemy. Reinforcements are coming but in small groups.")
        local Text4 = Util_CreateLocString("We cannot be certain what kind of reinforcements are coming and when... I suppose you will have to make use of anyone who arrives.")
        local Text5 = Util_CreateLocString("Make good use of elite reinforcements. They are some of our best veterans and can really make a difference in this battle!")
        local Text6 = Util_CreateLocString("Play to your strengths commanders. Good luck to you!")

        local Text7 = Util_CreateLocString("Commander, we have received news that more powerful troops are now available to you. They will now join you when they arrive.")
        local Text8 = Util_CreateLocString("Commander, we have confirmation that the most powerful of our troops have reached your front. They will join your battle when they arrive.")


EVENTS.ToSix = function()

	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Cmd_Move(GroupSix, mkr_to6)
        CTRL.WAIT()
	SGroup_Clear(GroupSix)
        CTRL.WAIT()

end

EVENTS.ToSeven = function()

	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Cmd_Move(GroupSeven, mkr_to7)
        CTRL.WAIT()
	SGroup_Clear(GroupSeven)
        CTRL.WAIT()

end

EVENTS.ToTwo = function()

	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Cmd_Move(GroupTwo, mkr_to2)
        CTRL.WAIT()
	SGroup_Clear(GroupTwo)
        CTRL.WAIT()

end

EVENTS.ToThree = function()

	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Cmd_Move(GroupThree, mkr_to3)
        CTRL.WAIT()
	SGroup_Clear(GroupThree)
        CTRL.WAIT()

end

---------------------------------Elite Allies List-------------------------------------

EVENTS.EliteAlliesOne = function()

	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
        Util_CreateSquads(player4, AlliesOne, SBP.SOVIET.M11_ANIA_SNIPER_SQUAD, mkr_spawn4)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()
        Modify_ReceivedDamage(AlliesOne, 0.6)
        Modify_ReceivedAccuracy(AlliesOne, 0.6)
        local EliteName1 = Util_CreateLocString("Partisan Ace")
        HintMouseover_Add(EliteName1, AlliesOne, 5, true)
        SGroup_IncreaseVeterancyRank(AlliesOne, 3, false)
	CTRL.WAIT()
	Cmd_Move(AlliesOne, mkr_to4)
        CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()

end

EVENTS.EliteAlliesTwo = function()

	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
        Util_CreateSquads(player4, AlliesTwo, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_spawn4)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()
        Modify_ReceivedDamage(AlliesTwo, 0.6)
        Modify_ReceivedAccuracy(AlliesTwo, 0.7)
        local EliteName1 = Util_CreateLocString("Master Assault Specialists")
        HintMouseover_Add(EliteName1, AlliesTwo, 5, true)
        SGroup_IncreaseVeterancyRank(AlliesTwo, 3, false)
	CTRL.WAIT()
	Cmd_Move(AlliesTwo, mkr_to4)
        CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()

end

EVENTS.EliteAlliesThree = function()

	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
        Util_CreateSquads(player4, AlliesThree, SBP.SOVIET.PENAL_BATTALION, mkr_spawn4)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()
        Modify_ReceivedDamage(AlliesThree, 0.7)
        Modify_ReceivedAccuracy(AlliesThree, 0.4)
        local ControlEntity1 = SGroup_GetSpawnedSquadAt(AlliesThree, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_PARTISAN_TROOP_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.ROKS_2_FLAMETHROWER_ITEM_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.ROKS_2_FLAMETHROWER_ITEM_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.BAZOOKA_MP)
        local EliteName1 = Util_CreateLocString("3rd Penal Specialists")
        HintMouseover_Add(EliteName1, AlliesThree, 5, true)
        SGroup_IncreaseVeterancyRank(AlliesThree, 3, false)
	CTRL.WAIT()
	Cmd_Move(AlliesThree, mkr_to4)
        CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()

end

EVENTS.EliteAlliesFour = function()

	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
        Util_CreateSquads(player4, AlliesFour, SBP.SOVIET.PARTISANS_RIFLE_MP, mkr_spawn4)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()
        Modify_ReceivedDamage(AlliesFour, 0.5)
        Modify_ReceivedAccuracy(AlliesFour, 0.2)
        local ControlEntity1 = SGroup_GetSpawnedSquadAt(AlliesFour, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.DP_28_LIGHT_MACHINE_GUN_PACKAGE_MOVING_NO_PRONE_MP)
        local EliteName1 = Util_CreateLocString("Veteran Infiltrators")
        HintMouseover_Add(EliteName1, AlliesFour, 5, true)
        SGroup_IncreaseVeterancyRank(AlliesFour, 3, false)
	CTRL.WAIT()
	Cmd_Move(AlliesFour, mkr_to4)
        CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()

end

EVENTS.EliteAlliesFive = function()

	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
        Util_CreateSquads(player4, AlliesFive, SBP.SOVIET.GUARDS_TROOPS, mkr_spawn4)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()
        Modify_ReceivedDamage(AlliesFive, 0.5)
        Modify_ReceivedAccuracy(AlliesFive, 0.6)
        local ControlEntity1 = SGroup_GetSpawnedSquadAt(AlliesFive, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.DP_28_LIGHT_MACHINE_GUN_PACKAGE_MOVING_NO_PRONE_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.ROKS_2_FLAMETHROWER_ITEM_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP_MP)
        local EliteName1 = Util_CreateLocString("15th Elite Guards Rifles")
        HintMouseover_Add(EliteName1, AlliesFive, 5, true)
        SGroup_IncreaseVeterancyRank(AlliesFive, 3, false)
	CTRL.WAIT()
	Cmd_Move(AlliesFive, mkr_to4)
        CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()

end

EVENTS.EliteAlliesSix = function()

	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
        Util_CreateSquads(player4, AlliesSix, SBP.SOVIET.PARTISANS_PTRS_MP, mkr_spawn4)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()
        Modify_ReceivedDamage(AlliesSix, 0.7)
        Modify_ReceivedAccuracy(AlliesSix, 0.2)
        local ControlEntity1 = SGroup_GetSpawnedSquadAt(AlliesSix, 1)
        local EliteName1 = Util_CreateLocString("Partisan Anti Tank Specialists")
        HintMouseover_Add(EliteName1, AlliesSix, 5, true)
        SGroup_IncreaseVeterancyRank(AlliesSix, 3, false)
	CTRL.WAIT()
	Cmd_Move(AlliesSix, mkr_to4)
        CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()

end

EVENTS.EliteAlliesSeven = function()

	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
        Util_CreateSquads(player4, AlliesSeven, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_spawn4)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()
        Modify_ReceivedDamage(AlliesSeven, 0.9)
        Modify_ReceivedAccuracy(AlliesSeven, 0.3)
        local ControlEntity1 = SGroup_GetSpawnedSquadAt(AlliesSeven, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.OBERSOLDATEN_MG34_LMG_MOVING_NO_PRONE_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.ROKS_2_FLAMETHROWER_ITEM_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.RIFLEMEN_30_CAL)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.PANZERSHRECK_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.RIFLEMEN_M1918_BAR_MP)
        local EliteName1 = Util_CreateLocString("Veteran Stalingrad Brawlers")
        HintMouseover_Add(EliteName1, AlliesSeven, 5, true)
        SGroup_IncreaseVeterancyRank(AlliesSeven, 3, false)
	CTRL.WAIT()
	Cmd_Move(AlliesSeven, mkr_to4)
        CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()

end

EVENTS.EliteAlliesEight = function()

	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
        Util_CreateSquads(player4, AlliesEight, SBP.SOVIET.COMMISSAR_SQUAD_MP, mkr_spawn4)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()
        Modify_ReceivedDamage(AlliesEight, 0.2)
        Modify_ReceivedAccuracy(AlliesEight, 0.9)
        local ControlEntity1 = SGroup_GetSpawnedSquadAt(AlliesEight, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_NO_PRONE_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_NO_PRONE_MP)
        local EliteName1 = Util_CreateLocString("Politburo Enforcers")
        HintMouseover_Add(EliteName1, AlliesEight, 5, true)
        SGroup_IncreaseVeterancyRank(AlliesEight, 3, false)
	CTRL.WAIT()
	Cmd_Move(AlliesEight, mkr_to4)
        CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()

end

EVENTS.EliteAlliesNine = function()

	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
        Util_CreateSquads(player4, AlliesNine, SBP.SOVIET.GUARDS_TROOPS, mkr_spawn4)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()
        Modify_ReceivedDamage(AlliesNine, 0.4)
        Modify_ReceivedAccuracy(AlliesNine, 0.6)
        local ControlEntity1 = SGroup_GetSpawnedSquadAt(AlliesNine, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.GUARD_TROOP_ASSAULT_PACKAGE)
        local EliteName1 = Util_CreateLocString("3rd Assault Guards Elites")
        HintMouseover_Add(EliteName1, AlliesNine, 5, true)
        SGroup_IncreaseVeterancyRank(AlliesNine, 3, false)
	CTRL.WAIT()
	Cmd_Move(AlliesNine, mkr_to4)
        CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()

end

EVENTS.EliteAlliesTen = function()

	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
        Util_CreateSquads(player4, AlliesTen, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_spawn4)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()
        Modify_ReceivedDamage(AlliesTen, 0.4)
        Modify_ReceivedAccuracy(AlliesTen, 0.5)
        local ControlEntity1 = SGroup_GetSpawnedSquadAt(AlliesTen, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.BAZOOKA_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.RIFLEMEN_30_CAL)
        local EliteName1 = Util_CreateLocString("Elite Shock Skirmishers")
        HintMouseover_Add(EliteName1, AlliesTen, 5, true)
        SGroup_IncreaseVeterancyRank(AlliesTen, 3, false)
	CTRL.WAIT()
	Cmd_Move(AlliesTen, mkr_to4)
        CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()

end

--------------------------------------Elite Axis List-----------------------------------




EVENTS.EliteAxisOne = function()

	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
        Util_CreateSquads(player8, AxisOne, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_spawn8)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()
        local ControlEntity1 = SGroup_GetSpawnedSquadAt(AxisOne, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.JAEGER_G43_RIFLE_ITEM_MP)
        Modify_ReceivedDamage(AxisOne, 0.6)
        Modify_ReceivedAccuracy(AxisOne, 0.6)
        local EliteName1 = Util_CreateLocString("Veteran Skirmishers")
        HintMouseover_Add(EliteName1, AxisOne, 5, true)
        SGroup_IncreaseVeterancyRank(AxisOne, 3, false)
	CTRL.WAIT()
	Cmd_Move(AxisOne, mkr_to8)
        CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()

end

EVENTS.EliteAxisTwo = function()

	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
        Util_CreateSquads(player8, AxisTwo, SBP.GERMAN.GRENADIER_SQUAD, mkr_spawn8)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()
        local ControlEntity1 = SGroup_GetSpawnedSquadAt(AxisTwo, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.BAZOOKA_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.PPSH41_ASSAULT_PACKAGE_MP)
        Modify_ReceivedDamage(AxisTwo, 0.7)
        Modify_ReceivedAccuracy(AxisTwo, 0.7)
        local EliteName1 = Util_CreateLocString("Ostfront Veteran Survivors")
        HintMouseover_Add(EliteName1, AxisTwo, 5, true)
        SGroup_IncreaseVeterancyRank(AxisTwo, 3, false)
	CTRL.WAIT()
	Cmd_Move(AxisTwo, mkr_to8)
        CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()

end

EVENTS.EliteAxisThree = function()

	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
        Util_CreateSquads(player8, AxisThree, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_spawn8)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()
        local ControlEntity1 = SGroup_GetSpawnedSquadAt(AxisThree, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.URBAN_ASSAULT_FLAMETHROWER_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.WEST_GERMAN_MINESWEEPER)
        Modify_ReceivedDamage(AxisThree, 0.7)
        Modify_ReceivedAccuracy(AxisThree, 0.8)
        local EliteName1 = Util_CreateLocString("23rd Oberkommando Pathfinders")
        HintMouseover_Add(EliteName1, AxisThree, 5, true)
        SGroup_IncreaseVeterancyRank(AxisThree, 3, false)
	CTRL.WAIT()
	Cmd_Move(AxisThree, mkr_to8)
        CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()

end

EVENTS.EliteAxisFour = function()

	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
        Util_CreateSquads(player8, AxisFour, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_spawn8)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()
        local ControlEntity1 = SGroup_GetSpawnedSquadAt(AxisFour, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.PANZERSHRECK_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.DP_28_LIGHT_MACHINE_GUN_PACKAGE_MOVING_NO_PRONE_MP)
        Modify_ReceivedDamage(AxisFour, 0.4)
        Modify_ReceivedAccuracy(AxisFour, 0.5)
        local EliteName1 = Util_CreateLocString("12th Assault Specialists")
        HintMouseover_Add(EliteName1, AxisFour, 5, true)
        SGroup_IncreaseVeterancyRank(AxisFour, 3, false)
	CTRL.WAIT()
	Cmd_Move(AxisFour, mkr_to8)
        CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()
	SGroup_Clear(GroupEight)
        CTRL.WAIT()

end

EVENTS.EliteAxisFive = function()

	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
        Util_CreateSquads(player8, AxisFive, SBP.GERMAN.STORMTROOPER_SQUAD_MP, mkr_spawn8)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()
        Modify_ReceivedDamage(AxisFive, 0.6)
        Modify_ReceivedAccuracy(AxisFive, 0.6)
        local EliteName1 = Util_CreateLocString("5th Stormtrooper Elites")
        HintMouseover_Add(EliteName1, AxisFive, 5, true)
        SGroup_IncreaseVeterancyRank(AxisFive, 3, false)
	CTRL.WAIT()
	Cmd_Move(AxisFive, mkr_to8)
        CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()

end

EVENTS.EliteAxisSix = function()

	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
        Util_CreateSquads(player8, AxisSix, SBP.GERMAN.OSTRUPPEN_SQUAD_MP, mkr_spawn8)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()
        local ControlEntity1 = SGroup_GetSpawnedSquadAt(AxisSix, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.PANZERSHRECK_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.PANZERSHRECK_MP)
        Modify_ReceivedDamage(AxisSix, 0.4)
        Modify_ReceivedAccuracy(AxisSix, 0.2)
        local EliteName1 = Util_CreateLocString("Eastern Skirmish Specialists")
        HintMouseover_Add(EliteName1, AxisSix, 5, true)
        SGroup_IncreaseVeterancyRank(AxisSix, 3, false)
	CTRL.WAIT()
	Cmd_Move(AxisSix, mkr_to8)
        CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()

end

EVENTS.EliteAxisSeven = function()

	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
        Util_CreateSquads(player8, AxisSeven, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_spawn8)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()
        local ControlEntity1 = SGroup_GetSpawnedSquadAt(AxisSeven, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_NO_PRONE_MP)
        Modify_ReceivedDamage(AxisSeven, 0.7)
        Modify_ReceivedAccuracy(AxisSeven, 0.8)
        local EliteName1 = Util_CreateLocString("Rural Combat Specialists")
        HintMouseover_Add(EliteName1, AxisSeven, 5, true)
        SGroup_IncreaseVeterancyRank(AxisSeven, 5, false)
	CTRL.WAIT()
	Cmd_Move(AxisSeven, mkr_to8)
        CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()

end

EVENTS.EliteAxisEight = function()

	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
        Util_CreateSquads(player8, AxisEight, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, mkr_spawn8)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()
        Modify_ReceivedDamage(AxisEight, 0.7)
        Modify_ReceivedAccuracy(AxisEight, 0.7)
        local EliteName1 = Util_CreateLocString("1st Elite Paratrooper Core")
        HintMouseover_Add(EliteName1, AxisEight, 5, true)
        SGroup_IncreaseVeterancyRank(AxisEight, 5, false)
	CTRL.WAIT()
	Cmd_Move(AxisEight, mkr_to8)
        CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()

end

EVENTS.EliteAxisNine = function()

	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
        Util_CreateSquads(player8, AxisNine, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_spawn8)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()
        local ControlEntity1 = SGroup_GetSpawnedSquadAt(AxisNine, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_MP)
        Modify_ReceivedDamage(AxisNine, 0.7)
        Modify_ReceivedAccuracy(AxisNine, 0.6)
        local EliteName1 = Util_CreateLocString("3rd Elite Engineers")
        HintMouseover_Add(EliteName1, AxisNine, 5, true)
        SGroup_IncreaseVeterancyRank(AxisNine, 5, false)
	CTRL.WAIT()
	Cmd_Move(AxisNine, mkr_to8)
        CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()

end

EVENTS.EliteAxisTen = function()

	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
        Util_CreateSquads(player8, AxisTen, SBP.GERMAN.SNIPER_SQUAD_MP, mkr_spawn8)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()
        Modify_ReceivedDamage(AxisTen, 0.5)
        Modify_ReceivedAccuracy(AxisTen, 0.5)
        local EliteName1 = Util_CreateLocString("Sniper Ace")
        HintMouseover_Add(EliteName1, AxisTen, 5, true)
        SGroup_IncreaseVeterancyRank(AxisTen, 3, false)
	CTRL.WAIT()
	Cmd_Move(AxisTen, mkr_to8)
        CTRL.WAIT()
	CTRL.Event_Delay(1)
        CTRL.WAIT()

end

EVENTS.Dialogue = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text1)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text2)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text3)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text4)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text5)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text6)
        CTRL.WAIT()

end

EVENTS.PhaseOne = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text7)
        CTRL.WAIT()

end

EVENTS.PhaseTwo = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text8)
        CTRL.WAIT()

end