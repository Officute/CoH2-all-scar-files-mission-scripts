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
		
				
		World_EnableSharedLineOfSight(player1, player4, false)
		World_EnableSharedLineOfSight(player2, player4, false)
		World_EnableSharedLineOfSight(player3, player4, false)

end

Scar_AddInit(OnGameSetup)

function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

function OnInit()

        Custom()
		
		Rule_AddDelayedInterval(SafeguardAI, 1, 1)
		
		Rule_AddOneShot(PlayerAIOne, 5)
		Rule_AddOneShot(PlayerAITwo, 5)
		Rule_AddOneShot(PlayerAIThree, 5)
		
		Cinematic()
		
		TankDeaths()
		
		Rule_AddDelayedInterval(TigerLeftActivate, 1, 1)
		
		Rule_AddDelayedInterval(TigerRightActivate, 1, 1)
		
		Rule_AddDelayedInterval(KingTigerActivateOne, 1, 1)
		
		Rule_AddDelayedInterval(KingTigerActivateTwo, 1, 1)
		
		Rule_AddDelayedInterval(HelpAmbulance, 1, 1)
		
		RecurringUnload()
		
		MovingStuve()
		
		Rule_AddOneShot(DelayAI, 200)
		
		Rule_AddDelayedInterval(GameBegin, 1, 1)
		
		StartEvent()
		
		SpawnControl()
		
        Elites()

        EliteNames()

        Upgrade()

        Abilities()

        BuildingRestrict()

        Victory()

        Lose()

end

Scar_AddInit(OnInit)

function Custom()

        AI_EnableAll(false)
        UI_SetAllowLoadAndSave(false)
		
		SGroup_SetInvulnerable(Ambulance, true)
		
		Player_SetPopCapOverride(player4, 900)
	    Player_SetPopCapOverride(player5, 900)
		Player_SetPopCapOverride(player6, 900)
		Player_SetPopCapOverride(player7, 900)
		Player_SetPopCapOverride(player8, 900)
		
		Command_SquadSquadLoad(player8, ThreeOberLoad, SCMD_Load, ThreeHalftrack, false, true)
		Command_SquadSquadLoad(player8, FourCar, SCMD_Load, FourLoadCar, false, true)
		Command_SquadSquadLoad(player8, FiveLoadHalftrack, SCMD_Load, FiveHalftrack, false, true)
		Command_SquadSquadLoad(player8, FiveLoadCarOne, SCMD_Load, FiveCarOne, false, true)
		Command_SquadSquadLoad(player8, FiveLoadCarTwo, SCMD_Load, FiveCarTwo, false, true)
		Command_SquadSquadLoad(player8, SixCar, SCMD_Load, SixLoadCar, false, true)
		
		Player_SetEntityProductionAvailability(player1, EBP.AEF.AEF_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.AEF.AEF_TANK_TRAP_IMPASSABLE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.AEF.AEF_TANK_TRAP_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.AEF.AEF_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.AEF.AEF_TANK_TRAP_IMPASSABLE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.AEF.AEF_TANK_TRAP_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player3, EBP.AEF.AEF_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player3, EBP.AEF.AEF_TANK_TRAP_IMPASSABLE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player3, EBP.AEF.AEF_TANK_TRAP_MP, ITEM_REMOVED)
		
		Player_SetPopCapOverride(player1, 200)
	    Player_SetPopCapOverride(player2, 200)
		Player_SetPopCapOverride(player3, 200)
		
		local Ammotext = Util_CreateLocString("It is important to capture munition points to increase your munitions but also to deprive the enemy of munitions")
        AmmoHint1 = HintPoint_Add(mkr_ammoleft, true, Ammotext)
		AmmoHint2 = HintPoint_Add(mkr_ammoright, true, Ammotext)
		AmmoHint3 = HintPoint_Add(mkr_ammomiddle, true, Ammotext)
		
		local Walkertext = Util_CreateLocString("Protect Captain Walker at all costs. Captain Walker's death will result in mission failure.")
        WalkerHint = HintPoint_Add(Walker, true, Walkertext)
		
		ObjBlip = UI_CreateMinimapBlip(Walker, 9000, BT_ObjectivePrimary)
	
end

function SafeguardAI()
	
	    AI_Enable(player4, false)

end

function PlayerAIOne()
	
		local Control = AI_IsAIPlayer(player1)
		if Control == true then
		        AI_Enable(player1, true)
				AI_SetDifficulty(player1, AD_Hardest)
        end
end

function PlayerAITwo()
	
		local Control = AI_IsAIPlayer(player2)
		if Control == true then
		        AI_Enable(player2, true)
				AI_SetDifficulty(player2, AD_Hardest)
        end
end

function PlayerAIThree()
	
		local Control = AI_IsAIPlayer(player3)
		if Control == true then
		        AI_Enable(player3, true)
				AI_SetDifficulty(player3, AD_Hardest)
        end
end

function DelayAI()
	
	    AI_Enable(player5, true)
        AI_Enable(player6, true)
        AI_Enable(player7, true)

end

function Cinematic()

        Util_StartIntel(EVENTS.StartCinematic)

end

function TankDeaths()

        Rule_AddDelayedInterval(TigerLeft, 1, 1)
        Rule_AddDelayedInterval(TigerRight, 1, 1)

end

function TigerLeft()

        local Control = SGroup_GetAvgHealth(SevenDecoyLeft)
        if Control < 0.9 then
                SGroup_Kill(SevenDecoyLeft)
        end

end

function TigerRight()

        local Control = SGroup_GetAvgHealth(SevenDecoyRight)
        if Control < 0.9 then
                SGroup_Kill(SevenDecoyRight)
        end

end

function TigerLeftActivate()

		local Control1 = Prox_AreSquadMembersNearMarker(SevenDecoyLeft, mkr_sevendecoyleftto, true)
		if Control1 == true then
		        local DirectionOne = Marker_GetDirection(mkr_p47)
                Cmd_Ability(player4, ABILITY.AEF.P47_ROCKET_ATTACK, mkr_sevendecoyleftto, DirectionOne, true)
                Rule_RemoveMe()
        end
end

function TigerRightActivate()

		local Control1 = Prox_AreSquadMembersNearMarker(SevenDecoyRight, mkr_sevendecoyrightto, true)
		if Control1 == true then
		        local DirectionOne = Marker_GetDirection(mkr_p47)
                Cmd_Ability(player4, ABILITY.AEF.P47_ROCKET_ATTACK, mkr_sevendecoyrightto, DirectionOne, true)
                Rule_RemoveMe()
        end
end

function KingTigerActivateOne()

		local Control1 = Prox_AreSquadMembersNearMarker(SevenTiger, mkr_kingtigertrigger1, true)
		if Control1 == true then
		        local DirectionOne = Marker_GetDirection(mkr_p47)
                Cmd_Ability(player4, ABILITY.AEF.P47_ROCKET_ATTACK, mkr_kingtigertrigger1, DirectionOne, true)
                Rule_RemoveMe()
        end
end

function KingTigerActivateTwo()

		local Control1 = Prox_AreSquadMembersNearMarker(SevenTiger, mkr_kingtigertrigger2, true)
		if Control1 == true then
		        local DirectionOne = Marker_GetDirection(mkr_p47)
                Cmd_Ability(player4, ABILITY.AEF.P47_ROCKET_ATTACK, mkr_kingtigertrigger2, DirectionOne, true)
                Rule_RemoveMe()
        end
end

function HelpAmbulance()

		local Control1 = Prox_AreSquadMembersNearMarker(Ambulance, mkr_ambulance, true)
		if Control1 == true then
                SGroup_WarpToMarker(Ambulance, mkr_ambulancewarp)
        end
end


-----------------------------Recurring Unload---------------------------------

function RecurringUnload()

        Rule_AddDelayedInterval(UnloadOne, 1, 1)
		Rule_AddDelayedInterval(UnloadTwo, 1, 1)
		
end

function UnloadOne()

		local Control1 = Prox_AreSquadMembersNearMarker(ThreeHalftrack, mkr_three1to, true)
		if Control1 == true then
                Command_Squad(player8, ThreeHalftrack, SCMD_UnloadSquads, false)
                Rule_RemoveMe()
        end
end

function UnloadTwo()

		local Control1 = Prox_AreSquadMembersNearMarker(FiveHalftrack, mkr_five1to, true)
		if Control1 == true then
                Command_Squad(player8, FiveHalftrack, SCMD_UnloadSquads, false)
                Rule_RemoveMe()
        end
end


-------------------------------Moving Stuve--------------------------------

function MovingStuve()

        Rule_AddDelayedInterval(StuveOne, 1, 1)
		Rule_AddDelayedInterval(StuveTwo, 1, 1)
		Rule_AddDelayedInterval(StuveThree, 1, 1)
		Rule_AddDelayedInterval(StuveFour, 1, 1)
		Rule_AddDelayedInterval(StuveFive, 1, 1)

end

function StuveOne()

		local Control1 = Prox_AreSquadMembersNearMarker(Stuve, mkr_stuve1, true)
		if Control1 == true then
                Cmd_Move(Stuve, mkr_stuve2)
        end
end

function StuveTwo()

		local Control1 = Prox_AreSquadMembersNearMarker(Stuve, mkr_stuve2, true)
		if Control1 == true then
                Cmd_Move(Stuve, mkr_stuve3)
        end
end

function StuveThree()

		local Control1 = Prox_AreSquadMembersNearMarker(Stuve, mkr_stuve3, true)
		if Control1 == true then
                Cmd_Move(Stuve, mkr_stuve4)
        end
end

function StuveFour()

		local Control1 = Prox_AreSquadMembersNearMarker(Stuve, mkr_stuve4, true)
		if Control1 == true then
                Cmd_Move(Stuve, mkr_stuve5)
        end
end

function StuveFive()

		local Control1 = Prox_AreSquadMembersNearMarker(Stuve, mkr_stuve5, true)
		if Control1 == true then
                Cmd_Move(Stuve, mkr_stuve1)
        end
end


--------------------------------Game Begin----------------------------------

function GameBegin()
	
	    local Control = SGroup_Count(GameSpawnControl)
        if Control == 0 then
                Rule_AddOneShot(AttackOne, 90)
				Rule_AddOneShot(ReinforceOne, 180)
				Rule_AddOneShot(AttackTwo, 270)
				Rule_AddOneShot(ConvoyReinforce, 390)
				Rule_AddOneShot(AttackThree, 580)
				Rule_AddOneShot(ParadropOne, 700)
				Rule_AddOneShot(AttackFour, 820)
				Rule_AddOneShot(ReinforceTwo, 940)
				Rule_AddOneShot(AttackFive, 1060)
				Rule_AddOneShot(ParadropTwo, 1180)
				Rule_AddOneShot(AttackSix, 1420)
				Rule_AddOneShot(ParadropThree, 1540)
				Rule_AddOneShot(AttackSeven, 1660)
                Rule_RemoveMe()
        end
end


---------------------------------Waves Attacks------------------------------

function AttackOne()

        Util_StartIntel(EVENTS.WaveOne)

end

function ReinforceOne()

        Util_StartIntel(EVENTS.HelpOne)

end

function AttackTwo()

        Util_StartIntel(EVENTS.WaveTwo)

end

function ConvoyReinforce()

        Util_StartIntel(EVENTS.ConvoyHelp)

end

function AttackThree()

        Util_StartIntel(EVENTS.WaveThree)

end

function ParadropOne()

        Util_StartIntel(EVENTS.JumpOne)

end

function AttackFour()

        Util_StartIntel(EVENTS.WaveFour)

end

function ReinforceTwo()

        Util_StartIntel(EVENTS.HelpTwo)

end

function AttackFive()

        Util_StartIntel(EVENTS.WaveFive)

end

function ParadropTwo()

        Util_StartIntel(EVENTS.JumpTwo)

end

function AttackSix()

        Util_StartIntel(EVENTS.WaveSix)

end

function ParadropThree()

        Util_StartIntel(EVENTS.JumpThree)

end

function AttackSeven()

        Util_StartIntel(EVENTS.WaveSeven)

end


----------------------------------Start Attacks-------------------------------

function StartEvent()

        Rule_AddDelayedInterval(StartAmbushOne, 1, 1)
		Rule_AddDelayedInterval(StartAmbushTwo, 1, 1)
		Rule_AddDelayedInterval(StartAttackOne, 1, 1)
		Rule_AddDelayedInterval(StartAttackTwo, 1, 1)
		Rule_AddDelayedInterval(UnitChange, 1, 1)

end

function StartAttackOne()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_starttrigger, false)
		if Control1 == true then
                Cmd_Move(StartGren, mkr_startgrento)
                Rule_RemoveMe()
        end
end

function StartAttackTwo()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_ostruppentrigger, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_ostruppentrigger, false)
		local Control3 = Prox_ArePlayersNearMarker(player3, mkr_ostruppentrigger, false)
		if Control1 == true or Control2 == true or Control3 == true then
                Cmd_Move(StartOstruppen, mkr_startostruppento)
				Cmd_Move(StartStormtrooper, mkr_startstormtrooperto)
                Rule_RemoveMe()
        end
end

function StartAmbushOne()

        local Control1 = Prox_ArePlayersNearMarker(player4, mkr_ambush1, false)
		if Control1 == true then
                Util_StartIntel(EVENTS.DropOne)
                Rule_RemoveMe()
        end
end

function StartAmbushTwo()

        local Control1 = Prox_ArePlayersNearMarker(player4, mkr_ambush2, false)
		if Control1 == true then
                Util_StartIntel(EVENTS.DropTwo)
                Rule_RemoveMe()
        end
end

function UnitChange()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_unitswitch, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_unitswitch, false)
		local Control3 = Prox_ArePlayersNearMarker(player3, mkr_unitswitch, false)
		if Control1 == true or Control2 == true or Control3 == true then
                Util_StartIntel(EVENTS.Change)
                Rule_RemoveMe()
        end
end

----------------------------Spawn Control---------------------------

function SpawnControl()

        Rule_AddDelayedInterval(SpawnFive, 30, 140)

        Rule_AddDelayedInterval(SpawnSix, 30, 140)

        Rule_AddDelayedInterval(SpawnSeven, 30, 140)

end

------------------------------Spawn Five-----------------------------

function SpawnFive()

        local Random = World_GetRand(1, 20)
        if Random == 1 then
                Util_CreateSquads(player5, GroupFive, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 2 then
                Util_CreateSquads(player5, GroupFive, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 3 then
                Util_CreateSquads(player5, GroupFive, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 4 then
                Util_CreateSquads(player5, GroupFive, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 5 then
                Util_CreateSquads(player5, GroupFive, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 6 then
                Util_CreateSquads(player5, GroupFive, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 7 then
                Util_CreateSquads(player5, GroupFive, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 8 then
                Util_CreateSquads(player5, GroupFive, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 9 then
                Util_CreateSquads(player5, GroupFive, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 10 then
                Util_CreateSquads(player5, GroupFive, SBP.GERMAN.OSTRUPPEN_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 11 then
                Util_CreateSquads(player5, GroupFive, SBP.GERMAN.OSTRUPPEN_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 12 then
                Util_CreateSquads(player5, GroupFive, SBP.GERMAN.OSTRUPPEN_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 13 then
                Util_CreateSquads(player5, GroupFive, SBP.GERMAN.URBAN_ASSAULT_PANZER_GRENADIER_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 14 then
                Util_CreateSquads(player5, GroupFive, SBP.GERMAN.URBAN_ASSAULT_PANZER_GRENADIER_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 15 then
                Util_CreateSquads(player5, GroupFive, SBP.GERMAN.STORMTROOPER_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 16 then
                Util_CreateSquads(player5, GroupFive, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 17 then
                Util_CreateSquads(player5, GroupFive, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 18 then
                Util_CreateSquads(player5, GroupFive, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 19 then
                Util_CreateSquads(player5, GroupFive, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 20 then
                Util_CreateSquads(player5, GroupFive, SBP.GERMAN.OFFICER_SQUAD, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)

        end
end

------------------------------Spawn Six-----------------------------

function SpawnSix()

        local Random = World_GetRand(1, 20)
        if Random == 1 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 2 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 3 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 4 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 5 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 6 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 7 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 8 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 9 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 10 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.OSTRUPPEN_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 11 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.OSTRUPPEN_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 12 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.SCOUTCAR_SDKFZ222_MP, mkr_spawn6)
				Util_CreateSquads(player6, GroupSix, SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 13 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.SCOUTCAR_SDKFZ222_MP, mkr_spawn6)
				Util_CreateSquads(player6, GroupSix, SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 14 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.URBAN_ASSAULT_PANZER_GRENADIER_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 15 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.STORMTROOPER_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 16 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 17 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 18 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 19 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 20 then
                Util_CreateSquads(player6, GroupSix, SBP.GERMAN.OFFICER_SQUAD, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)

        end
end

------------------------------Spawn Seven-----------------------------

function SpawnSeven()

        local Random = World_GetRand(1, 20)
        if Random == 1 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 2 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 3 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 4 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 5 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 6 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 7 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 8 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 9 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 10 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.OSTRUPPEN_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 11 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.OSTRUPPEN_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 12 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.PUMA_EAST_GERMAN_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 13 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.PUMA_EAST_GERMAN_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 14 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.URBAN_ASSAULT_PANZER_GRENADIER_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 15 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.STORMTROOPER_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 16 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 17 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 18 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 19 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 20 then
                Util_CreateSquads(player7, GroupSeven, SBP.GERMAN.OFFICER_SQUAD, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)

        end
end


------------------------------Elites----------------------------

function Elites()

        Modify_ReceivedDamage(Walker, 0.3)
        Modify_ReceivedAccuracy(Walker, 0.3)
		Modify_ReceivedDamage(Woodstock, 0.4)
        Modify_ReceivedAccuracy(Woodstock, 0.4)
		Modify_ReceivedDamage(Ballsacks, 0.4)
        Modify_ReceivedAccuracy(Ballsacks, 0.4)
		Modify_ReceivedDamage(Greyshot, 0.4)
        Modify_ReceivedAccuracy(Greyshot, 0.4)
		Modify_ReceivedDamage(Malaka, 0.4)
        Modify_ReceivedAccuracy(Malaka, 0.4)
		Modify_ReceivedDamage(Tightrope, 0.5)
        Modify_ReceivedAccuracy(Tightrope, 0.5)
		Modify_ReceivedDamage(Gentlemen, 0.4)
        Modify_ReceivedAccuracy(Gentlemen, 0.4)
		
		Modify_ReceivedDamage(ThreeOfficer, 0.6)
        Modify_ReceivedAccuracy(ThreeOfficer, 0.6)
		Modify_ReceivedDamage(FourOfficer, 0.6)
        Modify_ReceivedAccuracy(FourOfficer, 0.6)
		Modify_ReceivedDamage(SixOfficerOne, 0.4)
        Modify_ReceivedAccuracy(SixOfficerOne, 0.4)
		Modify_ReceivedDamage(SixOfficerTwo, 0.4)
        Modify_ReceivedAccuracy(SixOfficerTwo, 0.4)
		Modify_ReceivedDamage(ConvoyOfficer, 0.6)
        Modify_ReceivedAccuracy(ConoyOfficer, 0.6)
		Modify_ReceivedDamage(SevenOfficer, 0.4)
        Modify_ReceivedAccuracy(SevenOfficer, 0.4)
		Modify_ReceivedDamage(SevenTiger, 0.4)
        Modify_ReceivedAccuracy(SevenTiger, 0.7)
		Modify_ReceivedDamage(Stuve, 0.2)
        Modify_ReceivedAccuracy(Stuve, 0.2)
		
end

function EliteNames()

        local EliteName1 = Util_CreateLocString("Captain Walker")
        HintMouseover_Add(EliteName1, Walker, 5, true)
        SGroup_IncreaseVeterancyRank(Walker, 3, false)
		local EliteName2 = Util_CreateLocString("Ray 'Woodstock' Anderson")
        HintMouseover_Add(EliteName2, Woodstock, 5, true)
        SGroup_IncreaseVeterancyRank(Woodstock, 3, false)
		local EliteName3 = Util_CreateLocString("John 'Ballsacks' Sachs")
        HintMouseover_Add(EliteName3, Ballsacks, 5, true)
        SGroup_IncreaseVeterancyRank(Ballsacks, 3, false)
		local EliteName4 = Util_CreateLocString("Eddie 'Greyshot' Davis")
        HintMouseover_Add(EliteName4, Greyshot, 5, true)
        SGroup_IncreaseVeterancyRank(Greyshot, 3, false)
		
		local EliteName5 = Util_CreateLocString("Oberleutnant 'Hess' Assault Squad")
        HintMouseover_Add(EliteName5, ThreeOfficer, 5, true)
        SGroup_IncreaseVeterancyRank(ThreeOfficer, 2, false)
		local EliteName6 = Util_CreateLocString("Special Operations 'Schmidt' Assault Squad")
        HintMouseover_Add(EliteName6, FourOfficer, 5, true)
        SGroup_IncreaseVeterancyRank(FourOfficer, 2, false)
		local EliteName7 = Util_CreateLocString("Konstantinos 'Malaka' Papagos")
        HintMouseover_Add(EliteName7, Malaka, 5, true)
        SGroup_IncreaseVeterancyRank(Malaka, 3, false)
		local EliteName8 = Util_CreateLocString("Alex 'Tightrope' Frost")
        HintMouseover_Add(EliteName8, Tightrope, 5, true)
        SGroup_IncreaseVeterancyRank(Tightrope, 3, false)
		local EliteName9 = Util_CreateLocString("Andrew 'Kbal' Miller")
        HintMouseover_Add(EliteName9, Gentlemen, 5, true)
        SGroup_IncreaseVeterancyRank(Gentlemen, 3, false)
		local EliteName10 = Util_CreateLocString("Sturmbannfuhrer 'Weber' Assault Squad")
        HintMouseover_Add(EliteName10, SixOfficerOne, 5, true)
        SGroup_IncreaseVeterancyRank(SixOfficerOne, 3, false)
		local EliteName11 = Util_CreateLocString("Sturmbannfuhrer 'Schwarz' Assault Squad")
        HintMouseover_Add(EliteName11, SixOfficerTwo, 5, true)
        SGroup_IncreaseVeterancyRank(SixOfficerTwo, 3, false)
		local EliteName12 = Util_CreateLocString("Sturmbannfuhrer 'Kurtz' Assault Squad")
        HintMouseover_Add(EliteName12, ConvoyOfficer, 5, true)
        SGroup_IncreaseVeterancyRank(ConvoyOfficer, 2, false)
		local EliteName13 = Util_CreateLocString("Sturmbannfuhrer 'Dietrich' Assault Squad")
        HintMouseover_Add(EliteName13, SevenOfficer, 5, true)
        SGroup_IncreaseVeterancyRank(SevenOfficer, 3, false)
		local EliteName14 = Util_CreateLocString("Ace 'Helping Hans' Tiger B")
        HintMouseover_Add(EliteName14, SevenTiger, 5, true)
        SGroup_IncreaseVeterancyRank(SevenTiger, 5, false)
		local EliteName15 = Util_CreateLocString("Reinforced 'Stuve' Raid Car")
        HintMouseover_Add(EliteName15, Stuve, 5, true)
        SGroup_IncreaseVeterancyRank(Stuve, 3, false)

end
------------------------------Upgrades-----------------------------

function Upgrade()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)
        local player7 = World_GetPlayerAt(7)
        local player8 = World_GetPlayerAt(8)

        local ControlEntity1 = SGroup_GetSpawnedSquadAt(BazookaParas, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.BAZOOKA_MP)
        local ControlEntity2 = SGroup_GetSpawnedSquadAt(BazookaParas, 2)
        Squad_GiveSlotItem(ControlEntity2, SLOT_ITEM.BAZOOKA_MP)
		local ControlEntity3 = SGroup_GetSpawnedSquadAt(BazookaParas, 3)
        Squad_GiveSlotItem(ControlEntity3, SLOT_ITEM.BAZOOKA_MP)
		local ControlEntity4 = SGroup_GetSpawnedSquadAt(BazookaParas, 4)
        Squad_GiveSlotItem(ControlEntity4, SLOT_ITEM.BAZOOKA_MP)
		local ControlEntity5 = SGroup_GetSpawnedSquadAt(BazookaParas, 5)
        Squad_GiveSlotItem(ControlEntity5, SLOT_ITEM.BAZOOKA_MP)
		local ControlEntity6 = SGroup_GetSpawnedSquadAt(BazookaParas, 6)
        Squad_GiveSlotItem(ControlEntity6, SLOT_ITEM.BAZOOKA_MP)
		local ControlEntity7 = SGroup_GetSpawnedSquadAt(TwoTwoPara, 1)
        Squad_GiveSlotItem(ControlEntity7, SLOT_ITEM.BAZOOKA_MP)
		local ControlEntity8 = SGroup_GetSpawnedSquadAt(TwoOnePara, 1)
        Squad_GiveSlotItem(ControlEntity8, SLOT_ITEM.BAZOOKA_MP)
		local ControlEntity9 = SGroup_GetSpawnedSquadAt(ConvoyOfficer, 1)
        Squad_GiveSlotItem(ControlEntity9, SLOT_ITEM.PANZERSHRECK_MP)
		Squad_GiveSlotItem(ControlEntity9, SLOT_ITEM.PANZERSHRECK_MP)
		local ControlEntity10 = SGroup_GetSpawnedSquadAt(ConvoyGrenOne, 1)
        Squad_GiveSlotItem(ControlEntity10, SLOT_ITEM.PANZERSHRECK_MP)
		Squad_GiveSlotItem(ControlEntity10, SLOT_ITEM.PANZERSHRECK_MP)
		Squad_GiveSlotItem(ControlEntity10, SLOT_ITEM.PANZERSHRECK_MP)
		Squad_GiveSlotItem(ControlEntity10, SLOT_ITEM.PANZERSHRECK_MP)
		local ControlEntity11 = SGroup_GetSpawnedSquadAt(ConvoyGrenTwo, 1)
        Squad_GiveSlotItem(ControlEntity11, SLOT_ITEM.PANZERSHRECK_MP)
		Squad_GiveSlotItem(ControlEntity11, SLOT_ITEM.PANZERSHRECK_MP)
		Squad_GiveSlotItem(ControlEntity11, SLOT_ITEM.PANZERSHRECK_MP)
		Squad_GiveSlotItem(ControlEntity11, SLOT_ITEM.PANZERSHRECK_MP)
		local ControlEntity12 = SGroup_GetSpawnedSquadAt(ConvoyGrenThree, 1)
        Squad_GiveSlotItem(ControlEntity12, SLOT_ITEM.PANZERSHRECK_MP)
		Squad_GiveSlotItem(ControlEntity12, SLOT_ITEM.PANZERSHRECK_MP)
		Squad_GiveSlotItem(ControlEntity12, SLOT_ITEM.PANZERSHRECK_MP)
		Squad_GiveSlotItem(ControlEntity12, SLOT_ITEM.PANZERSHRECK_MP)
		local ControlEntity13 = SGroup_GetSpawnedSquadAt(SevenGren, 1)
        Squad_GiveSlotItem(ControlEntity13, SLOT_ITEM.PANZERSHRECK_MP)
		Squad_GiveSlotItem(ControlEntity13, SLOT_ITEM.PANZERSHRECK_MP)
		

		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("rifle_command_grenade_mp"))
		Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("rifle_command_grenade_mp"))
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("rifle_command_grenade_mp"))
		Player_AddAbility(player1, BP_GetAbilityBlueprint("paratroopers_paradrop"))
        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("paratroopers"))
		Player_AddAbility(player2, BP_GetAbilityBlueprint("paratroopers_paradrop"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("paratroopers"))
		Player_AddAbility(player3, BP_GetAbilityBlueprint("paratroopers_paradrop"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("paratroopers"))
		Player_AddAbility(player4, BP_GetAbilityBlueprint("paratroopers_paradrop"))
        Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("paratroopers"))
		Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("p47_rocket_attack"))
        Player_AddAbility(player4, BP_GetAbilityBlueprint("p47_rocket_attack"))
		Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("air_drop_resources"))
		Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("air_drop_weapon_resupply"))
        Player_AddAbility(player4, BP_GetAbilityBlueprint("air_dropped_munitions"))
		Player_AddAbility(player4, BP_GetAbilityBlueprint("air_dropped_supplies"))
		
		Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("stuka_smoke_bomb"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("stuka_smoke_bomb"))
		
		Player_SetUpgradeAvailability(player1, UPG.AEF.FIGHTING_POSITION_MG_ADDITION_MP, ITEM_REMOVED)
		Player_SetUpgradeAvailability(player2, UPG.AEF.FIGHTING_POSITION_MG_ADDITION_MP, ITEM_REMOVED)
		Player_SetUpgradeAvailability(player3, UPG.AEF.FIGHTING_POSITION_MG_ADDITION_MP, ITEM_REMOVED)
		
		Player_SetUpgradeAvailability(player3, UPG.AEF.FIGHTING_POSITION_MG_ADDITION_MP, ITEM_REMOVED)

        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("building_1"))
        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("building_2"))
        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("building_3"))
        Player_SetAbilityAvailability(player1, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player1, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)

        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("building_1"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("building_2"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("building_3"))
        Player_SetAbilityAvailability(player2, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player2, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)

        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("building_1"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("building_2"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("building_3"))
        Player_SetAbilityAvailability(player3, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player3, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)

        Player_SetAbilityAvailability(player1, ABILITY.WEST_GERMAN.PIONEER_VOLKS_SALVAGE, ITEM_REMOVED)
        Player_SetAbilityAvailability(player1, ABILITY.WEST_GERMAN.THROUGH_SALVAGE, ITEM_REMOVED)
        Player_SetAbilityAvailability(player1, ABILITY.WEST_GERMAN.MG34_DISPATCH, ITEM_REMOVED)
        Player_SetAbilityAvailability(player1, ABILITY.WEST_GERMAN.ASSAULT_PIONEER_DROP_MEDPACK_ABILITY_MP, ITEM_REMOVED)

        Player_SetAbilityAvailability(player2, ABILITY.WEST_GERMAN.PIONEER_VOLKS_SALVAGE, ITEM_REMOVED)
        Player_SetAbilityAvailability(player2, ABILITY.WEST_GERMAN.THROUGH_SALVAGE, ITEM_REMOVED)
        Player_SetAbilityAvailability(player2, ABILITY.WEST_GERMAN.MG34_DISPATCH, ITEM_REMOVED)
        Player_SetAbilityAvailability(player2, ABILITY.WEST_GERMAN.ASSAULT_PIONEER_DROP_MEDPACK_ABILITY_MP, ITEM_REMOVED)

        Player_SetUpgradeAvailability(player1, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_1_SCHREK_MP, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_MP, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_SECOND, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_SECOND_MP, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_THIRD_MP, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.GERMAN.GRENADIER_MG42_LMG, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.GERMAN.GRENADIER_MG42_LMG_MP, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.PANZERSCHRECK_UNLOCKED, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.WAFFEN_INFRARED_STG44, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.MG34_DISPATCH, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.THROUGH_SALVAGE, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.PANZERSCHRECK_UNLOCKED, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.WAFFEN_MG34_LMG_MP, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.ASSAULT_PIONEER_REPAIR_UPGRADE, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.ASSAULT_PIONEER_PANZERSCHRECK_UPGRADE, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.ASSAULT_PIONEER_COMBAT_UPGRADE, ITEM_REMOVED)

        Player_SetUpgradeAvailability(player2, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_1_SCHREK_MP, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_MP, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_SECOND, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_SECOND_MP, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_THIRD_MP, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.GERMAN.GRENADIER_MG42_LMG, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.GERMAN.GRENADIER_MG42_LMG_MP, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.PANZERSCHRECK_UNLOCKED, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.WAFFEN_INFRARED_STG44, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.MG34_DISPATCH, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.THROUGH_SALVAGE, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.PANZERSCHRECK_UNLOCKED, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.WAFFEN_MG34_LMG_MP, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.ASSAULT_PIONEER_REPAIR_UPGRADE, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.ASSAULT_PIONEER_PANZERSCHRECK_UPGRADE, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.ASSAULT_PIONEER_COMBAT_UPGRADE, ITEM_REMOVED)
		

end

function Abilities()

        Player_AddAbility(player4, BP_GetAbilityBlueprint("flare_artillery"))
        Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("flare_artillery"))

        Player_AddAbility(player6, BP_GetAbilityBlueprint("il-2_precision_bomb_strike"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("il-2_bomb_Strike"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("major_artillery"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("light_support_artillery"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("light_artillery_support"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("fire_artillery"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("fire_artillery"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("time_on_target_artillery"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("time_on_target_artillery"))

        Player_AddAbility(player5, BP_GetAbilityBlueprint("flare_artillery"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("flare_artillery"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("time_on_target_artillery"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("time_on_target_artillery"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("recon_sweep"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("recon_sweep"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("p47_rocket_attack"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("p47_rocket_attack"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("major_quick_recon_run"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("major_quick_recon_run_improved"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("recon_sweep"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("paratroopers_paradrop"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("paratroopers"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("glider_headquarters"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("ability_lock_out_glider_custom_loadout_launch_available"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("ability_lock_out_glider_hard_landed"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("ability_lock_out_glider_not_stopped"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("major_artillery"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("pack_howitzer_white_phosphorous_barrage_ability_mp"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("artillery_smoke_barrage"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("off_map_smoke_artillery"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("artillery_strike_white_phosphorous"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("artillery_white_phosphorous"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("artillery_strike_white_phosphorous"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("stuka_bombing_run_upgrade"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("stuka_bombing_strike"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("stuka_incendiary_bombs"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("stuka_flame_strike"))

        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("stuka_fragmentation_bomb"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("stuka_fragmentation_bomb"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("stuka_close_air_support"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("stuka_close_air_support"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("stuka_smoke_bomb"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("stuka_smoke_bomb"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("stuka_flame_strike"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("stuka_incendiary_bombs"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("stuka_strafe"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("stuka_strafing_run"))
end

function BuildingRestrict()

        Player_SetEntityProductionAvailability(player1, EBP.GERMAN.BUNKER_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.GERMAN.SLIT_TRENCH_GERMAN_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.GERMAN.SLIT_TRENCH_GERMAN, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.WG_SANDBAG_FENCE_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_02, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_01, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.REINFORCED_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)

        Player_SetEntityProductionAvailability(player2, EBP.GERMAN.BUNKER_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.GERMAN.SLIT_TRENCH_GERMAN_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.GERMAN.SLIT_TRENCH_GERMAN, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.WG_SANDBAG_FENCE_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_02, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_01, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.REINFORCED_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
end

---------------------------------Victory----------------------------


function Victory()

        Rule_AddDelayedInterval(TigerDeath, 1, 1)

end

function TigerDeath()

        local Control = SGroup_Count(SevenTiger)
        if Control == 0 then
		        SGroup_SetInvulnerable(Walker, true)
                Util_StartIntel(EVENTS.WinSpeech)
				Rule_RemoveMe()
        end
end



---------------------------------Lose----------------------------

function Lose()

        Rule_AddDelayedInterval(WalkerLose, 1, 1)

end



function WalkerLose()

        local Control = SGroup_Count(Walker)
        if Control == 0 then
                World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
        end
end
------------------------------Events and Actors--------------------


EXTRA = {}

EXTRA.AEF = {
	PHOSPHOROUS_STRIKE = BP_GetAbilityBlueprint("artillery_strike_white_phosphorous"),
}

--? @enum EXTRA.AEF
--? EXTRA.AEF.PHOSPHOROUS_STRIKE



ACTOR = {
	
	__scardoc_enum = true,

	None					= "",

        Friedrich = "Icons_portraits_unit_german_panzer_grenadiers_w_portrait",
        Walter = "Icons_portraits_unit_german_grenadiers_w_portrait",
        Fritz = "Icons_portraits_unit_west_german_fallschirmjager_w_portrait",
        Jozef = "Icons_portraits_unit_west_german_assault_pioneer_w_portrait",
        Hans = "Icons_portraits_unit_west_german_honor_guard_w_portrait",
        Assailant = "Icons_portraits_unit_german_grenadiers_w_portrait",
        Tomislav = "Icons_portraits_unit_west_german_volksgrenadier_w_portrait",
        Simmons = "Icons_portraits_unit_aef_captain_w_portrait",
        Winter = "Icons_portraits_unit_british_officer_w_portrait",
		Tomislav = "Icons_portraits_unit_west_german_volksgrenadier_w_portrait",
        Protector = "Icons_portraits_unit_aef_rear_echelon_w_portrait",

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

function Resources()

Modify_PlayerResourceRate(player1, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player1, RT_Munition, 0.5, MUT_Multiplication)
Modify_PlayerResourceRate(player1, RT_Manpower, 0, MUT_Multiplication)

Modify_PlayerResourceRate(player2, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player2, RT_Munition, 0.5, MUT_Multiplication)
Modify_PlayerResourceRate(player2, RT_Manpower, 0, MUT_Multiplication)

Modify_PlayerResourceRate(player3, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player3, RT_Munition, 0.5, MUT_Multiplication)
Modify_PlayerResourceRate(player3, RT_Manpower, 0, MUT_Multiplication)

Modify_PlayerResourceRate(player4, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player4, RT_Munition, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player4, RT_Manpower, 0, MUT_Multiplication)

Modify_PlayerResourceRate(player5, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player5, RT_Munition, 0.2, MUT_Multiplication)
Modify_PlayerResourceRate(player5, RT_Manpower, 0, MUT_Multiplication)

Modify_PlayerResourceRate(player6, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player6, RT_Munition, 0.2, MUT_Multiplication)
Modify_PlayerResourceRate(player6, RT_Manpower, 0, MUT_Multiplication)

Modify_PlayerResourceRate(player7, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player7, RT_Munition, 0.2, MUT_Multiplication)
Modify_PlayerResourceRate(player7, RT_Manpower, 0, MUT_Multiplication)

Modify_PlayerResourceRate(player8, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player8, RT_Munition, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player8, RT_Manpower, 0, MUT_Multiplication)

end

Scar_AddInit(Resources)

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
				manpower = 200,
				fuel = 0,
				munition = 0,
				action = 0,
				command = 0,
			},
			--player 2:
			[1] = {
				manpower = 200,
				fuel = 0,
				munition = 0,
				action = 0,
				command = 0,
			},
			--player 3:
			[2] = {
				manpower = 200,
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


EVENTS = {}

        local AmbulanceText1 = Util_CreateLocString("Friendly ambulance arriving from the rear. You should get replacement men before the ambulance returns to the rear.")

        local StartText1 = Util_CreateLocString("OK folks we are coming up on the landing zone. Prepare to drop.")
        local Text1 = Util_CreateLocString("Remember! We got to hold this town so our men can have time to grab a beachhead out on the coast! If we fail here then the entire operation is in jeopardy!")
		local StartText2 = Util_CreateLocString("Meet up with the remainder of Captain Walker's men in the town center.")
        local Text2 = Util_CreateLocString("Green zone in Five...")
		local Text3 = Util_CreateLocString("Four...")
		local Text4 = Util_CreateLocString("Three...")
		local Text5 = Util_CreateLocString("Two...")
		local Text6 = Util_CreateLocString("One...")
		local Text7 = Util_CreateLocString("Up on the landing zone. Drop when ready. God be with you boys.")
		
		local Text8 = Util_CreateLocString("Jesus Christ this zone is too hot!")
		local Text9 = Util_CreateLocString("They're everywhere! Help!")

		local Text10 = Util_CreateLocString("Holy God's Great Mercy! Are you all there is? Tell me the main group is coming later!")
		local Text11 = Util_CreateLocString("With this many men we'll be dead as soon as them Helping Hans gets here!")
		local Text12 = Util_CreateLocString("Right, listen up! You folks will split into three groups.")
		local Text13 = Util_CreateLocString("Woodstock, incorporate Group A into your men, take the medic also.")
		local Text14 = Util_CreateLocString("Ballsacks! Your men and Group B will join ranks.")
		local Text15 = Util_CreateLocString("Greyshot, take Group C and what's left of 117 and 151.")
		local Text16 = Util_CreateLocString("I want this town Kraut free, you hear me?! No matter the cost!")
		local Text17 = Util_CreateLocString("Woodstock, Ballsacks, Greyshot. Defend this goddam town! I'll be calling for reinforcements inside this house here.")
		local Text18 = Util_CreateLocString("There's little cover outside of town so maximize the narrow streets within the built-up areas.")
		local Text19 = Util_CreateLocString("But enough talk. Move out!")
		
		local Text20 = Util_CreateLocString("Walker here. My scouts report enemy units closing in from the east and west side of town.")
		local Text21 = Util_CreateLocString("They are probably enemy scouts. Clear them out. The enemy will know we mean business when their scouts don't return.")
		
		local Text22 = Util_CreateLocString("Hey! Don't bunch up all together! The enemy have artillery and air support ya know?!")
		local Text23 = Util_CreateLocString("Well would ya look at that! We got some of our stragglers coming from the south. Clear a path for them.")
		
		local Text24 = Util_CreateLocString("God damn it! I hear motors outside of town.")
		local Text25 = Util_CreateLocString("That's confirmed. Enemy light vehicles with escort incoming from town east.")
		local Text26 = Util_CreateLocString("This is fucking crazy! They've got the entire town surrounded!")
		local Text27 = Util_CreateLocString("We just need to hold the center. Maybe if we're lucky we can take those munition storage points.")
		local Text28 = Util_CreateLocString("Damn all this crap! Where the hell is Ballsacks when you need him?!")
		
		local ExtraText1 = Util_CreateLocString("Captain! We've spotted a friendly light vehicle column with some men inbound from the east in two minutes. The Germans have also spotted them though!")
		local ExtraText2 = Util_CreateLocString("Then we need to clear a path for them. Get out there and defend that column boys!")
		local ExtraText3 = Util_CreateLocString("OK boys, here comes the column.")
		
		local Text29 = Util_CreateLocString("Scouts are reporting a huge group of assault units approaching the town from the north.")
		local Text30 = Util_CreateLocString("Pivot your defence towards that direction but don't ignore the other paths. You never know what'll be coming.")
		
		local Text31 = Util_CreateLocString("You boys feel like a rescue mission? I'm hearing radio chatter of a paradrop at the Field Alpha in just two minutes! Check your maps for the location.")
		local Text32 = Util_CreateLocString("That field is bound to be defended. Clear them defenders there or the reinforcements are screwed as soon as they land.")
		local Text33 = Util_CreateLocString("Friendly paratroopers inbound. I hope for their sakes you cleared that field...")
		
		local Text34 = Util_CreateLocString("Panzer from the east, Hetzer from the west! Get your asses in position!")
		local Text35 = Util_CreateLocString("Make use of the buildings. I hope you still have someone with a bazooka or this will be a very short engagement!")
		
		local Text36 = Util_CreateLocString("You sure we should be going this way Miller?")
		local Text37 = Util_CreateLocString("Maybe you should find a bush and let off some juice instead of second guessing me Malaka!")
		local Text38 = Util_CreateLocString("How about I kick your ass Miller?!")
		local Text39 = Util_CreateLocString("Quiet! Both of you. I'm so sick of listening to your shit all week.")
		
		local Text40 = Util_CreateLocString("Kraut's coming from all directions and got a brummbar to the north! We gotta prepare or else it'll blast us all to hell!")
		
		local Text41 = Util_CreateLocString("Boys! I'm receiving news that a second batch of paratroopers will be landing in Field Beta in around two minutes.")
		local Text42 = Util_CreateLocString("That field is going to be defended. Clear it out to allow our men to drop safely. Check your maps for directions.")
		local Text43 = Util_CreateLocString("Here comes our boys from airborne... You did neutralized the landing area right?!")
		
		local Text44 = Util_CreateLocString("Ostwind from east and west, with escorts! Scouts also report a few SS squads from the north!")
		local Text45 = Util_CreateLocString("Just our fucking luck with SS showing up here. Those guys don't mess around. Get to your fucking positions!")
		
		local Text46 = Util_CreateLocString("Last wave of airbourne paratroopers inbound at Field Gamma in three minutes. you boys need to neutralize that area so our guys can land.")
		local Text47 = Util_CreateLocString("Captain Walker! We have a friendly tank column arriving from the east in about three minutes, but the enemy is re-directing their forces to intercept them.")
		local Text48 = Util_CreateLocString("Holy hell! This is bad! We can really use those tanks right about now, but we can't just let our boys in airbourne get slaughtered in that field!")
		local Text49 = Util_CreateLocString("I'm leaving the decision up to you boys. Save them if you have the manpower for it!")
		local Text50 = Util_CreateLocString("Alright boys, friendly convoy and airbourne both inbound. Hopefully you've secured a path for them.")
		
		local Text51 = Util_CreateLocString("Oh no... This is a load of crap!")
		local Text52 = Util_CreateLocString("TIGERS INCOMING!!!")
		local Text53 = Util_CreateLocString("Get to your positions! Only the big one from the north has escorts! Fucking take it out!")
		
		local Text54 = Util_CreateLocString("WE DID IT!!! WE DID IT BOYS!!!")
		local Text55 = Util_CreateLocString("Today we held the Krauts at bay! Tomorrow, we liberate Paris! ONWARDS!")
		
		
	
EVENTS.ToFive = function()

	CTRL.WAIT()
	Cmd_Move(GroupFive, mkr_spawn5to)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	SGroup_Clear(GroupFive)
    CTRL.WAIT()

end

EVENTS.ToSix = function()

	CTRL.WAIT()
	Cmd_Move(GroupSix, mkr_spawn6to)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	SGroup_Clear(GroupSix)
    CTRL.WAIT()

end

EVENTS.ToSeven = function()

	CTRL.WAIT()
	Cmd_Move(GroupSeven, mkr_spawn7to)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	SGroup_Clear(GroupSeven)
    CTRL.WAIT()

end

EVENTS.StartCinematic = function()

	CTRL.WAIT()
	Camera_MoveTo(mkr_para3)
	CTRL.Actor_PlaySpeech(ACTOR.Para, StartText1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, StartText2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text4)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text6)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text7)
	local Direction = Marker_GetDirection(mkr_para1)
	Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_dummypara4, Direction, true)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_dummypara6, Direction, true)
	CTRL.WAIT()
	CTRL.Event_Delay(2)
	CTRL.WAIT()
	Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_dummypara5, Direction, true)
	CTRL.WAIT()
	CTRL.Event_Delay(8)
	CTRL.WAIT()
	Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_dummypara3, Direction, true)
	CTRL.WAIT()
	CTRL.Event_Delay(2)
	CTRL.WAIT()
	Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_dummypara1, Direction, true)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_dummypara2, Direction, true)
	CTRL.WAIT()
	CTRL.Event_Delay(5)
	CTRL.WAIT()
    Cmd_Ability(player1, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_para1, Direction, true)
	Cmd_Ability(player2, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_para3, Direction, true)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Cmd_Ability(player1, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_para2, Direction, true)
	Cmd_Ability(player3, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_para5, Direction, true)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Cmd_Ability(player2, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_para4, Direction, true)
	Cmd_Ability(player3, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_para6, Direction, true)
	CTRL.WAIT()
	
end

EVENTS.DropOne = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Paratrooper_01, Text8)
	FOW_RevealMarker(mkr_dummypara2, 9000)
	Cmd_Move(StartOstwind, mkr_startostwindto)
	CTRL.WAIT()
	CTRL.Event_Delay(5)
	CTRL.WAIT()
	FOW_UnRevealMarker(mkr_dummypara2)
	CTRL.WAIT()

end

EVENTS.DropTwo = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Paratrooper_01, Text9)
	FOW_RevealMarker(mkr_dummypara5, 9000)
	Cmd_Move(StartHalftrack, mkr_starthalftrackto)
	CTRL.WAIT()
	CTRL.Event_Delay(5)
	CTRL.WAIT()
	FOW_UnRevealMarker(mkr_dummypara5)
	CTRL.WAIT()

end

EVENTS.Change = function()

	CTRL.WAIT()
	FOW_RevealMarker(mkr_basevision, 9000)
	local RetreatEntity1 = EGroup_GetSpawnedEntityAt(RetreatOne, 1)
	local RetreatEntity2 = EGroup_GetSpawnedEntityAt(RetreatTwo, 1)
	local RetreatEntity3 = EGroup_GetSpawnedEntityAt(RetreatThree, 1)
	local DestroyEntity1 = EGroup_GetSpawnedEntityAt(StartRetreatOne, 1)
	local DestroyEntity2 = EGroup_GetSpawnedEntityAt(StartRetreatTwo, 1)
	local DestroyEntity3 = EGroup_GetSpawnedEntityAt(StartRetreatThree, 1)
    Entity_SetPlayerOwner(RetreatEntity1, player1)
	Entity_SetPlayerOwner(RetreatEntity2, player2)
	Entity_SetPlayerOwner(RetreatEntity3, player3)
    Entity_Destroy(DestroyEntity1)
    Entity_Destroy(DestroyEntity2)
    Entity_Destroy(DestroyEntity3)
	HintPoint_Remove(AmmoHint1)
	HintPoint_Remove(AmmoHint2)
	HintPoint_Remove(AmmoHint3)
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, Text10)
    Command_SquadEntityLoad(player4, Walker, SCMD_Load, CommandHouse, false, true)
	Command_SquadEntityLoad(player4, Pathfinders, SCMD_Load, CommandHouse, false, true)
	Command_SquadEntityLoad(player4, Paratroopers, SCMD_Load, CommandHouse, false, true)
	Command_SquadEntityLoad(player4, Riflemen, SCMD_Load, CommandHouse, false, true)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, Text11)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, Text12)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, Text13)
	SGroup_SetPlayerOwner(GroupA, player1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, Text14)
	SGroup_SetPlayerOwner(GroupB, player2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, Text15)
	SGroup_SetPlayerOwner(GroupC, player3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, Text16)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, Text17)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, Text18)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, Text19)
	CTRL.WAIT()
	HintPoint_Remove(WalkerHint)
	UI_DeleteMinimapBlip(ObjBlip)
	SGroup_Kill(GameSpawnControl)
	CTRL.WAIT()

end

EVENTS.WaveOne = function()

	CTRL.WAIT()
	SGroup_WarpToMarker(OneAltGren, mkr_spawnleftroad)
	SGroup_WarpToMarker(OneAssGren, mkr_spawnleftroad)
	SGroup_WarpToMarker(OneGren, mkr_spawnleftroad)
	SGroup_WarpToMarker(OneStorm, mkr_spawnleftroad)
	CTRL.WAIT()
	Cmd_AttackMove(OneAltGren, mkr_one3to)
	Cmd_SquadPatrolMarker(OneAssGren, mkr_leftammopatrol)
	Cmd_Move(OneGren, mkr_one1to)
	Cmd_AttackMove(OneStorm, mkr_one4to)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text20)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text21)
	CTRL.WAIT()

end

EVENTS.HelpOne = function()

    CTRL.WAIT()
    CTRL.Actor_PlaySpeech(ACTOR.Para, AmbulanceText1)
	CTRL.WAIT()
	local WarningText = Util_CreateLocString("Ambulance is arriving from the rear and will be leaving shortly")
	Warning = WinWarning_ShowLoseWarning(WarningText, 2, 5, 2)
	SGroup_WarpToMarker(Ambulance, mkr_ambulanceappear)
	FOW_RevealSGroupOnly(Ambulance, 30)
	CTRL.WAIT()
	Cmd_Move(Ambulance, mkr_ambulanceto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text22)
	CTRL.WAIT()
	CTRL.Event_Delay(15)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text23)
	CTRL.WAIT()
	SGroup_WarpToMarker(OneOne, mkr_reinforce1)
	SGroup_WarpToMarker(OneTwo, mkr_reinforce2)
	SGroup_WarpToMarker(OneThree, mkr_reinforce3)
	SGroup_SetPlayerOwner(OneOne, player1)
	SGroup_SetPlayerOwner(OneTwo, player2)
	SGroup_SetPlayerOwner(OneThree, player3)
	CTRL.WAIT()
	Cmd_Move(OneOne, mkr_reinforceto1)
	Cmd_Move(OneTwo, mkr_reinforceto2)
	Cmd_Move(OneThree, mkr_reinforceto3)
	CTRL.WAIT()
	CTRL.Event_Delay(20)
	CTRL.WAIT()
	Cmd_Move(Ambulance, mkr_ambulance)
	CTRL.WAIT()
	

end

EVENTS.WaveTwo = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Paratrooper_01, Text24)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text25)
	CTRL.WAIT()
	SGroup_WarpToMarker(TwoSturm, mkr_spawnleftforest)
	SGroup_WarpToMarker(TwoNorth, mkr_spawn6)
	SGroup_WarpToMarker(TwoEast, mkr_spawnrightfield)
	SGroup_WarpToMarker(TwoScoutCar, mkr_spawnrightforest)
	CTRL.WAIT()
	Cmd_SquadPatrolMarker(TwoSturm, mkr_townbottompatrol)
	Cmd_Move(TwoScoutCar, mkr_townto1)
	Cmd_AttackMove(TwoEast, mkr_townto3)
	Cmd_Move(TwoNorth, mkr_townto2)
	CTRL.WAIT()
	CTRL.Event_Delay(35)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, Text26)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Paratrooper_01, Text27)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, Text28)
	CTRL.WAIT()
	
end

EVENTS.ConvoyHelp = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, AmbulanceText1)
	Player_AddResource(player1, RT_Manpower, 100)
	Player_AddResource(player2, RT_Manpower, 100)
	Player_AddResource(player3, RT_Manpower, 100)
	CTRL.WAIT()
    local WarningText = Util_CreateLocString("Ambulance is arriving from the rear and will be leaving shortly")
	Warning = WinWarning_ShowLoseWarning(WarningText, 2, 5, 2)
	SGroup_WarpToMarker(Ambulance, mkr_ambulanceappear)
	FOW_RevealSGroupOnly(Ambulance, 30)
	CTRL.WAIT()
	Cmd_Move(Ambulance, mkr_ambulanceto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Paratrooper_01, ExtraText1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, ExtraText2)
	local TextHint5 = Util_CreateLocString("Optional: Secure and clear the road of hostiles before the friendly convoy arrives")
    Hint5 = HintPoint_Add(mkr_rightroadblip, true, TextHint5)
	Blip5 = UI_CreateMinimapBlip(mkr_rightroadblip, 9000, BT_AttackHere)
	CTRL.WAIT()
	SGroup_WarpToMarker(TruckRatOne, mkr_spawn7)
	SGroup_WarpToMarker(TruckRatTwo, mkr_spawn7)
	SGroup_WarpToMarker(TruckFusilierOne, mkr_spawn7)
	SGroup_WarpToMarker(TruckFusilierTwo, mkr_spawn7)
	SGroup_WarpToMarker(TruckOstruppen, mkr_spawn7)
	CTRL.WAIT()
	Cmd_Move(TruckRatOne, mkr_truckrat1to)
	Cmd_Move(TruckRatTwo, mkr_truckrat2to)
	Cmd_Move(TruckFusilierOne, mkr_truckfusilier1to)
	Cmd_Move(TruckFusilierTwo, mkr_truckfusilier2to)
	Cmd_Move(TruckOstruppen, mkr_truckostruppento)
	CTRL.WAIT()
	CTRL.Event_Delay(20)
	CTRL.WAIT()
	Cmd_Move(Ambulance, mkr_ambulance)
	CTRL.WAIT()
	CTRL.Event_Delay(100)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, ExtraText3)
	CTRL.WAIT()
	HintPoint_Remove(Hint5)
	UI_DeleteMinimapBlip(Blip5)
	SGroup_WarpToMarker(TruckOne, mkr_truck1)
	SGroup_WarpToMarker(TruckTwo, mkr_truck2)
	SGroup_WarpToMarker(TruckThree, mkr_truck3)
	SGroup_WarpToMarker(TruckEscort, mkr_spawnrightroad)
	SGroup_SetPlayerOwner(TruckGroupOne, player1)
	SGroup_SetPlayerOwner(TruckGroupTwo, player2)
	SGroup_SetPlayerOwner(TruckGroupThree, player3)
	CTRL.WAIT()
	Cmd_Move(TruckOne, mkr_truck1to)
	Cmd_Move(TruckTwo, mkr_truck2to)
	Cmd_Move(TruckThree, mkr_truck3to)
	Cmd_Move(TruckEscort, mkr_truckescortto)
	CTRL.WAIT()

end

EVENTS.WaveThree = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text29)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text30)
	CTRL.WAIT()
	SGroup_WarpToMarker(ThreeVolks, mkr_spawn6)
	SGroup_WarpToMarker(ThreeSturm, mkr_spawn6)
	SGroup_WarpToMarker(ThreeTransfer, mkr_spawnrightfield)
	SGroup_WarpToMarker(ThreeMG, mkr_spawnrightfield)
	SGroup_WarpToMarker(ThreeFusilier, mkr_spawnrightforest)
	SGroup_WarpToMarker(ThreeOfficer, mkr_spawn6)
	SGroup_WarpToMarker(ThreeAssGren, mkr_spawnrightfield)
	SGroup_WarpToMarker(ThreeHalftrack, mkr_spawnleftroad)
	CTRL.WAIT()
	SGroup_WarpToMarker(SafetyHalftrack, mkr_safetywarp)
	Cmd_Move(ThreeTransfer, mkr_four2to)
	Cmd_Move(ThreeHalftrack, mkr_three1to)
	Cmd_Move(ThreeOfficer, mkr_three2to)
	Cmd_Move(ThreeSturm, mkr_three2to)
	Cmd_AttackMove(ThreeVolks, mkr_three2to)
	Cmd_AttackMove(ThreeMG, mkr_three4to)
	Cmd_Move(ThreeAssGren, mkr_three3to)
	CTRL.WAIT()
	
end

EVENTS.JumpOne = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, AmbulanceText1)
	Player_AddResource(player1, RT_Manpower, 100)
	Player_AddResource(player2, RT_Manpower, 100)
	Player_AddResource(player3, RT_Manpower, 100)
	CTRL.WAIT()
	local WarningText = Util_CreateLocString("Ambulance is arriving from the rear and will be leaving shortly")
	Warning = WinWarning_ShowLoseWarning(WarningText, 2, 5, 2)
	SGroup_WarpToMarker(Ambulance, mkr_ambulanceappear)
	FOW_RevealSGroupOnly(Ambulance, 30)
	CTRL.WAIT()
	Cmd_Move(Ambulance, mkr_ambulanceto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text31)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text32)
	local TextHint1 = Util_CreateLocString("Optional: Clear the landing zone of enemies before reinforcements arrive")
    Hint1 = HintPoint_Add(mkr_field1, true, TextHint1)
	Blip1 = UI_CreateMinimapBlip(mkr_field1, 9000, BT_AttackHere)
	CTRL.WAIT()
	CTRL.Event_Delay(20)
	CTRL.WAIT()
	Cmd_Move(Ambulance, mkr_ambulance)
	CTRL.WAIT()
	CTRL.Event_Delay(100)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text33)
	CTRL.WAIT()
	HintPoint_Remove(Hint1)
	UI_DeleteMinimapBlip(Blip1)
	local Direction = Marker_GetDirection(mkr_para1)
	local RetreatEntity1 = EGroup_GetSpawnedEntityAt(FieldRetreat1, 1)
	local RetreatEntity2 = EGroup_GetSpawnedEntityAt(FieldRetreat2, 1)
	local RetreatEntity3 = EGroup_GetSpawnedEntityAt(FieldRetreat3, 1)
    Entity_SetPlayerOwner(RetreatEntity1, player1)
	Entity_SetPlayerOwner(RetreatEntity2, player2)
	Entity_SetPlayerOwner(RetreatEntity3, player3)
	Cmd_Ability(player1, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_dummypara1, Direction, true)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Cmd_Ability(player2, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_dummypara2, Direction, true)
	CTRL.WAIT()
	CTRL.Event_Delay(2)
	CTRL.WAIT()
	Cmd_Ability(player3, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_dummypara3, Direction, true)
	CTRL.WAIT()
	CTRL.Event_Delay(20)
	CTRL.WAIT()
	local RetreatEntity1 = EGroup_GetSpawnedEntityAt(FieldRetreat1, 1)
	local RetreatEntity2 = EGroup_GetSpawnedEntityAt(FieldRetreat2, 1)
	local RetreatEntity3 = EGroup_GetSpawnedEntityAt(FieldRetreat3, 1)
    Entity_SetPlayerOwner(RetreatEntity1, player4)
	Entity_SetPlayerOwner(RetreatEntity2, player4)
	Entity_SetPlayerOwner(RetreatEntity3, player4)
	
end

EVENTS.WaveFour = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text34)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text35)
	CTRL.WAIT()
	Modify_UnitSpeed(FourPanzer, 0.4)
	Modify_UnitSpeed(FourHetzer, 0.5)
	FOW_RevealSGroupOnly(FourPanzer, 300)
	FOW_RevealSGroupOnly(FourHetzer, 300)
	SGroup_WarpToMarker(FourPanzer, mkr_spawnrightroad)
	SGroup_WarpToMarker(FourCar, mkr_spawn7)
	SGroup_WarpToMarker(FourHetzer, mkr_spawn5)
	SGroup_WarpToMarker(FourAltOber, mkr_spawn5)
	SGroup_WarpToMarker(FourOfficer, mkr_spawnrightroad)
	SGroup_WarpToMarker(FourOber, mkr_spawnrightroad)
	SGroup_WarpToMarker(FourGrens, mkr_spawnleftforest)
	SGroup_WarpToMarker(FourUrban, mkr_spawnrightfield)
	CTRL.WAIT()
	Cmd_Move(FourPanzer, mkr_four1to)
	Cmd_Move(FourCar, mkr_four3to)
	Cmd_AttackMove(FourHetzer, mkr_four4to)
	Cmd_Move(FourOber, mkr_four1to)
	Cmd_AttackMove(FourOfficer, mkr_four2to)
	Cmd_AttackMove(FourUrban, mkr_townto2)
	Cmd_Move(FourAltOber, mkr_four4to)
	Cmd_Move(FourGrens, mkr_three2to)
	CTRL.WAIT()
	
end

EVENTS.HelpTwo = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, AmbulanceText1)
	Player_AddResource(player1, RT_Manpower, 100)
	Player_AddResource(player2, RT_Manpower, 100)
	Player_AddResource(player3, RT_Manpower, 100)
	CTRL.WAIT()
	local WarningText = Util_CreateLocString("Ambulance is arriving from the rear and will be leaving shortly")
	Warning = WinWarning_ShowLoseWarning(WarningText, 2, 5, 2)
	SGroup_WarpToMarker(Ambulance, mkr_ambulanceappear)
	FOW_RevealSGroupOnly(Ambulance, 30)
	CTRL.WAIT()
	Cmd_Move(Ambulance, mkr_ambulanceto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text36)
	SGroup_WarpToMarker(TwoAll, mkr_reinforce3)
	SGroup_WarpToMarker(TwoThree, mkr_reinforce3)
	CTRL.WAIT()
	Cmd_Move(TwoOne, mkr_reinforceto1)
	Cmd_Move(TwoTwo, mkr_reinforceto2)
	Cmd_Move(TwoThree, mkr_reinforceto3)
	Cmd_Move(TwoGroupThree, mkr_reinforceto3)
	SGroup_SetPlayerOwner(TwoOne, player1)
	SGroup_SetPlayerOwner(TwoTwo, player2)
	SGroup_SetPlayerOwner(TwoThree, player3)
	SGroup_SetPlayerOwner(TwoGroupThree, player3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, Text37)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text38)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, Text39)
	CTRL.WAIT()
	CTRL.Event_Delay(20)
	CTRL.WAIT()
	Cmd_Move(Ambulance, mkr_ambulance)
	CTRL.WAIT()

end

EVENTS.WaveFive = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text40)
	CTRL.WAIT()
	Modify_UnitSpeed(FiveBrummbar, 0.5)
	FOW_RevealSGroupOnly(FiveBrummbar, 300)
	SGroup_WarpToMarker(FiveBrummbar, mkr_spawn6)
	SGroup_WarpToMarker(FiveAssGren, mkr_spawn6)
	SGroup_WarpToMarker(FiveHalftrack, mkr_spawnrightroad)
	SGroup_WarpToMarker(FiveCarOne, mkr_spawn5)
	SGroup_WarpToMarker(FiveCarTwo, mkr_spawnleftforest)
	SGroup_WarpToMarker(FiveRight, mkr_spawn7)
	SGroup_WarpToMarker(FiveLeft, mkr_spawn5)
	CTRL.WAIT()
	SGroup_WarpToMarker(SafetyHalftrack, mkr_safetywarp)
	Cmd_Move(FiveBrummbar, mkr_townto1)
	Cmd_Move(FiveAssGren, mkr_townto1)
	Cmd_Move(FiveHalftrack, mkr_five1to)
	Cmd_Move(FiveCarOne, mkr_five3to)
	Cmd_Move(FiveCarTwo, mkr_five2to)
	Cmd_AttackMove(FiveRight, mkr_townto3)
	Cmd_AttackMove(FiveLeft, mkr_three1to)
	CTRL.WAIT()
	
end

EVENTS.JumpTwo = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, AmbulanceText1)
	Player_AddResource(player1, RT_Manpower, 100)
	Player_AddResource(player2, RT_Manpower, 100)
	Player_AddResource(player3, RT_Manpower, 100)
	CTRL.WAIT()
	local WarningText = Util_CreateLocString("Ambulance is arriving from the rear and will be leaving shortly")
	Warning = WinWarning_ShowLoseWarning(WarningText, 2, 5, 2)
	SGroup_WarpToMarker(Ambulance, mkr_ambulanceappear)
	FOW_RevealSGroupOnly(Ambulance, 30)
	CTRL.WAIT()
	Cmd_Move(Ambulance, mkr_ambulanceto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text41)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text42)
	local TextHint2 = Util_CreateLocString("Optional: Clear the landing zone of enemies before reinforcements arrive")
    Hint2 = HintPoint_Add(mkr_field2, true, TextHint2)
	Blip2 = UI_CreateMinimapBlip(mkr_field2, 9000, BT_AttackHere)
	CTRL.WAIT()
	CTRL.Event_Delay(20)
	CTRL.WAIT()
	Cmd_Move(Ambulance, mkr_ambulance)
	CTRL.WAIT()
	CTRL.Event_Delay(100)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text43)
	CTRL.WAIT()
	HintPoint_Remove(Hint2)
	UI_DeleteMinimapBlip(Blip2)
	local Direction = Marker_GetDirection(mkr_para1)
	local RetreatEntity1 = EGroup_GetSpawnedEntityAt(FieldRetreat4, 1)
	local RetreatEntity2 = EGroup_GetSpawnedEntityAt(FieldRetreat5, 1)
	local RetreatEntity3 = EGroup_GetSpawnedEntityAt(FieldRetreat6, 1)
    Entity_SetPlayerOwner(RetreatEntity1, player1)
	Entity_SetPlayerOwner(RetreatEntity2, player2)
	Entity_SetPlayerOwner(RetreatEntity3, player3)
	Cmd_Ability(player1, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_dummypara7, Direction, true)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Cmd_Ability(player2, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_dummypara8, Direction, true)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Cmd_Ability(player3, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_dummypara9, Direction, true)
	CTRL.WAIT()
	CTRL.Event_Delay(20)
	CTRL.WAIT()
	local RetreatEntity1 = EGroup_GetSpawnedEntityAt(FieldRetreat4, 1)
	local RetreatEntity2 = EGroup_GetSpawnedEntityAt(FieldRetreat5, 1)
	local RetreatEntity3 = EGroup_GetSpawnedEntityAt(FieldRetreat6, 1)
    Entity_SetPlayerOwner(RetreatEntity1, player4)
	Entity_SetPlayerOwner(RetreatEntity2, player4)
	Entity_SetPlayerOwner(RetreatEntity3, player4)
	
end

EVENTS.WaveSix = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text44)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text45)
	CTRL.WAIT()
	Modify_UnitSpeed(SixRightOstwind, 0.5)
	Modify_UnitSpeed(SixLeftOstwind, 0.5)
	FOW_RevealSGroupOnly(SixRightOstwind, 120)
	FOW_RevealSGroupOnly(SixLeftOstwind, 120)
	SGroup_WarpToMarker(SixRightOstwind, mkr_spawnrightroad)
	SGroup_WarpToMarker(SixLeftOstwind, mkr_spawn5)
	SGroup_WarpToMarker(SixCar, mkr_spawnrightroad)
	SGroup_WarpToMarker(SixAA, mkr_spawnrightroad)
	SGroup_WarpToMarker(SixKubelOne, mkr_spawnrightforest)
	SGroup_WarpToMarker(SixKubelTwo, mkr_spawnleftforest)
	SGroup_WarpToMarker(SixNorth, mkr_spawn6)
	SGroup_WarpToMarker(SixEast, mkr_spawnrightroad)
	SGroup_WarpToMarker(SixWest, mkr_spawn5)
	CTRL.WAIT()
	Cmd_Move(SixRightOstwind, mkr_six3to)
	Cmd_Move(SixLeftOstwind, mkr_six2to)
	Cmd_Move(SixCar, mkr_six1to)
	Cmd_AttackMove(SixAA, mkr_six1to)
	Cmd_AttackMove(SixKubelOne, mkr_six4to)
	Cmd_AttackMove(SixKubelTwo, mkr_six5to)
	Cmd_Move(SixNorth, mkr_six6to)
	Cmd_Move(SixEast, mkr_six3to)
	Cmd_AttackMove(SixWest, mkr_six2to)
	CTRL.WAIT()
	
end

EVENTS.JumpThree = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, AmbulanceText1)
	Player_AddResource(player1, RT_Manpower, 100)
	Player_AddResource(player2, RT_Manpower, 100)
	Player_AddResource(player3, RT_Manpower, 100)
	CTRL.WAIT()
	local WarningText = Util_CreateLocString("Ambulance is arriving from the rear and will be leaving shortly")
	Warning = WinWarning_ShowLoseWarning(WarningText, 2, 5, 2)
	SGroup_WarpToMarker(Ambulance, mkr_ambulanceappear)
	FOW_RevealSGroupOnly(Ambulance, 30)
	CTRL.WAIT()
	Cmd_Move(Ambulance, mkr_ambulanceto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text46)
	local TextHint3 = Util_CreateLocString("Optional: Clear the landing zone of enemies before reinforcements arrive")
    Hint3 = HintPoint_Add(mkr_field3, true, TextHint3)
	Blip3 = UI_CreateMinimapBlip(mkr_field3, 9000, BT_AttackHere)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text47)
	local TextHint4 = Util_CreateLocString("Optional: Secure and clear the road of hostiles before the friendly convoy arrives")
    Hint4 = HintPoint_Add(mkr_spawn5to, true, TextHint4)
	Blip4 = UI_CreateMinimapBlip(mkr_spawn5to, 9000, BT_AttackHere)
	SGroup_WarpToMarker(ConvoyLeader, mkr_spawnleftforest)
	SGroup_WarpToMarker(ConvoyTop, mkr_spawnleftforest)
	SGroup_WarpToMarker(ConvoyBottom, mkr_spawnleftforest)
	SGroup_WarpToMarker(ConvoyOne, mkr_spawnleftforest)
	SGroup_WarpToMarker(ConvoyTwo, mkr_spawnleftforest)
	SGroup_WarpToMarker(Stuve, mkr_spawnleftroad)
	CTRL.WAIT()
	Cmd_Move(ConvoyLeader, mkr_convoyleaderto)
	Cmd_Move(ConvoyTop, mkr_convoytopto)
	Cmd_Move(ConvoyBottom, mkr_convoybottomto)
	Cmd_Move(ConvoyOne, mkr_convoyoneto)
	Cmd_Move(ConvoyTwo, mkr_convoytwoto)
	Cmd_Move(Stuve, mkr_stuve5)
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text48)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text49)
	CTRL.WAIT()
	CTRL.Event_Delay(20)
	CTRL.WAIT()
	Cmd_Move(Ambulance, mkr_ambulance)
	CTRL.WAIT()
	CTRL.Event_Delay(140)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text50)
	SGroup_WarpToMarker(TankOne, mkr_tank1)
	SGroup_WarpToMarker(TankTwo, mkr_tank2)
	SGroup_WarpToMarker(TankThree, mkr_tank3)
	Player_AddAbility(player1, BP_GetAbilityBlueprint("air_drop_combat_group"))
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("paradropped_support_drop"))
	Player_AddAbility(player2, BP_GetAbilityBlueprint("paradrops_anti_tank_gun"))
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("paradrop_anti_tank_gun"))
	Player_AddAbility(player3, BP_GetAbilityBlueprint("paradrop_machine_gun"))
	Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("paradrop_machine_gun"))
	HintPoint_Remove(Hint3)
	UI_DeleteMinimapBlip(Blip3)
	HintPoint_Remove(Hint4)
	UI_DeleteMinimapBlip(Blip4)
	CTRL.WAIT()
	Cmd_Move(TankOne, mkr_tank1to)
	Cmd_Move(TankTwo, mkr_tank2to)
	Cmd_Move(TankThree, mkr_tank3to)
	SGroup_SetPlayerOwner(TankOne, player1)
	SGroup_SetPlayerOwner(TankTwo, player2)
	SGroup_SetPlayerOwner(TankThree, player3)
	local Direction = Marker_GetDirection(mkr_para1)
	local RetreatEntity1 = EGroup_GetSpawnedEntityAt(FieldRetreat7, 1)
	local RetreatEntity2 = EGroup_GetSpawnedEntityAt(FieldRetreat8, 1)
	local RetreatEntity3 = EGroup_GetSpawnedEntityAt(FieldRetreat9, 1)
    Entity_SetPlayerOwner(RetreatEntity1, player1)
	Entity_SetPlayerOwner(RetreatEntity2, player2)
	Entity_SetPlayerOwner(RetreatEntity3, player3)
	Cmd_Ability(player1, ABILITY.AEF.AIR_DROP_COMBAT_GROUP, mkr_dummypara4, Direction, true)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Cmd_Ability(player2, ABILITY.AEF.PARADROPS_ANTI_TANK_GUN, mkr_dummypara5, Direction, true)
	Cmd_Ability(player2, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_dummypara5, Direction, true)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Cmd_Ability(player3, ABILITY.AEF.PARADROP_MACHINE_GUN, mkr_dummypara6, Direction, true)
	Cmd_Ability(player3, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_dummypara6, Direction, true)
	CTRL.WAIT()
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("air_drop_combat_group"), ITEM_REMOVED)
	Player_RemoveUpgrade(player1, BP_GetUpgradeBlueprint("paradropped_support_drop"))
	Player_SetAbilityAvailability(player2, BP_GetAbilityBlueprint("paradrops_anti_tank_gun"), ITEM_REMOVED)
	Player_RemoveUpgrade(player2, BP_GetUpgradeBlueprint("paradrop_anti_tank_gun"))
	Player_SetAbilityAvailability(player3, BP_GetAbilityBlueprint("paradrop_machine_gun"), ITEM_REMOVED)
	Player_RemoveUpgrade(player3, BP_GetUpgradeBlueprint("paradrop_machine_gun"))
	CTRL.WAIT()
	CTRL.Event_Delay(20)
	CTRL.WAIT()
	local RetreatEntity1 = EGroup_GetSpawnedEntityAt(FieldRetreat7, 1)
	local RetreatEntity2 = EGroup_GetSpawnedEntityAt(FieldRetreat8, 1)
	local RetreatEntity3 = EGroup_GetSpawnedEntityAt(FieldRetreat9, 1)
    Entity_SetPlayerOwner(RetreatEntity1, player4)
	Entity_SetPlayerOwner(RetreatEntity2, player4)
	Entity_SetPlayerOwner(RetreatEntity3, player4)
	CTRL.WAIT()
	
end

EVENTS.WaveSeven = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text51)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text52)
	Modify_UnitSpeed(SevenTiger, 0.6)
	Modify_UnitSpeed(SevenDecoyLeft, 0.7)
	Modify_UnitSpeed(SevenDecoyRight, 0.7)
	Modify_UnitSpeed(SevenPanther, 0.7)
	FOW_RevealSGroupOnly(SevenAll, 500)
	SGroup_WarpToMarker(SevenTiger, mkr_spawn6)
	SGroup_WarpToMarker(SevenEscort, mkr_sevenspawn)
	SGroup_WarpToMarker(SevenAttack, mkr_sevenspawn)
	SGroup_WarpToMarker(SevenPumaOne, mkr_truck1)
	SGroup_WarpToMarker(SevenPumaTwo, mkr_truck2)
	SGroup_WarpToMarker(SevenPanther, mkr_spawn5)
	SGroup_WarpToMarker(SevenDecoyLeft, mkr_spawnleftforest)
	SGroup_WarpToMarker(SevenDecoyRight, mkr_spawnrightforest)
	CTRL.WAIT()
	SGroup_WarpToMarker(SafetyHalftrack, mkr_safetywarp)
	Cmd_Move(SevenTiger, mkr_seven1to)
	Cmd_Move(SevenEscort, mkr_seven2to)
	Cmd_AttackMove(SevenAttack, mkr_seven3to)
	Cmd_Move(SevenPumaOne, mkr_four3to)
	Cmd_Move(SevenPumaTwo, mkr_five1to)
	Cmd_Move(SevenPanther, mkr_seven4to)
	Cmd_Move(SevenDecoyLeft, mkr_decoyleftto)
	Cmd_Move(SevenDecoyRight, mkr_decoyrightto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text53)
	CTRL.WAIT()
	
end

EVENTS.WinSpeech = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text54)
	local Direction = Marker_GetDirection(mkr_para1)
    Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_2, Direction, true)
	Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_5, Direction, true)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Para, Text55)
	local Direction = Marker_GetDirection(mkr_para1)
	Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_4, Direction, true)
	Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_3, Direction, true)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	local Direction = Marker_GetDirection(mkr_para1)
	Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_1, Direction, true)
	Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_7, Direction, true)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	local Direction = Marker_GetDirection(mkr_para1)
	Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_6, Direction, true)
	Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_1, Direction, true)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	local Direction = Marker_GetDirection(mkr_para1)
	Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_7, Direction, true)
	Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_2, Direction, true)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	local Direction = Marker_GetDirection(mkr_para1)
	Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_3, Direction, true)
	Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_4, Direction, true)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	local Direction = Marker_GetDirection(mkr_para1)
	Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_5, Direction, true)
	Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_6, Direction, true)
	CTRL.WAIT()
	CTRL.Event_Delay(3)
	CTRL.WAIT()
	World_SetPlayerWin(player1)
    World_SetPlayerWin(player2)
    World_SetPlayerWin(player3)
	World_SetPlayerWin(player4)
	CTRL.WAIT()

end