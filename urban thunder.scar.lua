-- This following code contained in this file is copyright to Mike D. Do not re-use without express permission from all copyright holders, this work is partially protected by the Digital Millenium Copyright Act (DCMA), U.S.C, Title 17.

import("ScarUtil.scar")
import("Fatalities/Fatalities.scar")
import("Prototype/WorldEntityCollector.scar")
import("Prototype/SpecialAEFunctions.scar")
import("PrintOnScreen.scar")

function OnGameSetup()

        player1 = World_GetPlayerAt(1)
        player2 = World_GetPlayerAt(2)
        player3 = World_GetPlayerAt(3)
        player4 = World_GetPlayerAt(4)
        player5 = World_GetPlayerAt(5)
        player6 = World_GetPlayerAt(6)
        player7 = World_GetPlayerAt(7)
        player8 = World_GetPlayerAt(8)

        World_EnableSharedLineOfSight(player1, player3, false)
        World_EnableSharedLineOfSight(player2, player3, false)
        World_EnableSharedLineOfSight(player1, player4, true)
        World_EnableSharedLineOfSight(player2, player4, true)

end
Scar_AddInit(OnGameSetup)

function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

function OnInit()

        Custom()

        Rule_AddDelayedInterval(Easter, 1, 1)

        Rule_AddDelayedInterval(CustomFailsafe, 1, 1)

        Rule_AddDelayedInterval(Patrols, 1, 1)

        CinematicOne()

        Rule_AddDelayedInterval(CinematicTwo, 1, 1)

        Rule_AddDelayedInterval(HansDisappear, 1, 1)

        Community()

        Optional()

        ParkEvent()

        ForestEvent()

        MidEvent()

        RuinsEvent()

        CinemaEvent()

        CathedralEvent()

        Points()

        Elites()

        EliteHint()

        Hints()

        Officers()

        Barrage()

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
        Modify_EntityBuildTime(player1, EBP.WEST_GERMAN.SCHU_MINE_42_MP, 0.2)
        Modify_EntityBuildTime(player2, EBP.WEST_GERMAN.SCHU_MINE_42_MP, 0.2)

        World_EnableSharedLineOfSight(player1, player4, true)
        World_EnableSharedLineOfSight(player2, player4, true)

        local ControlEntity1 = SGroup_GetSpawnedSquadAt(RifleStartLeft, 1)
        local ControlEntity2 = SGroup_GetSpawnedSquadAt(RifleStartRight, 1)
        Squad_SuggestPosture(ControlEntity1, 2, 9000)
        Squad_SuggestPosture(ControlEntity2, 2, 9000)

        EGroup_SetInvulnerable(PlatformInvulnerable, true)
        EGroup_SetInvulnerable(RuinsPlatforms, true)
        EGroup_SetInvulnerable(RuinsPlanks, true)
        EGroup_SetInvulnerable(CathedralPlatforms, true)
        EGroup_SetInvulnerable(CathedralDiagonal, true)
        EGroup_SetInvulnerable(CinemaPlatforms, true)

	Player_SetPopCapOverride(player5, 900)
	Player_SetPopCapOverride(player6, 900)

        Modify_DisableHold(AcademyBuildings, true)
        Modify_DisableHold(NoEntryPrison, true)
        Modify_DisableHold(NoEntryEntrance, true)
        Modify_DisableHold(NoEntryMid, true)
        Modify_DisableHold(NoEntrySide, true)

        Modify_VehicleRotationSpeed(RuinsFlameTank, 0.3)
        Modify_VehicleRotationSpeed(StreetChurchill, 0.5)

        SGroup_SetInvulnerable(Walter, true)
        SGroup_SetInvulnerable(Fritz, true)
        SGroup_SetInvulnerable(Jaap, true)
        SGroup_SetInvulnerable(Jacques, true)
        SGroup_SetInvulnerable(Olav, true)
        SGroup_SetInvulnerable(Giovanni, true)

        SGroup_SetInvulnerable(FallInvulnerable, true)

        SGroup_SetInvulnerable(Vladilen, true)
        SGroup_SetInvulnerable(Stator, true)
        SGroup_SetInvulnerable(Aleksei, true)
        SGroup_SetInvulnerable(Nikolai, true)
        SGroup_SetInvulnerable(Yuri, true)
        SGroup_SetInvulnerable(Viktor, true)
        SGroup_SetInvulnerable(Dmitriy, true)

end

function Easter()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_eastereggtrigger, false)
        if Control == true then
                local EggText = Util_CreateLocString("Oh hello! Don't mind me, I'm just scavenging through the ruins of this house! Um... Did you know that in the nearby ruins to the north-east from here there are some documents about the timing of enemy flares? Just thought it might interest you!")
                HintMouseover_Add(EggText, SecretEgg, 5, true)
                Rule_RemoveMe()
        end
end

function CustomFailsafe()

        AI_EnableAll(false)

end

function Patrols()

        Cmd_SquadPatrolMarker(PatrolAcademy, mkr_patrolacademy)
        Cmd_SquadPatrolMarker(PatrolTank, mkr_patroltankto)
        Rule_RemoveMe()

end

function CinematicOne()

	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
        Camera_Follow(KurtStart)
        Camera_SetZoomDist(15)
        Util_StartIntel(EVENTS.Begin)

        local ControlEntity1 = SGroup_GetSpawnedSquadAt(KurtStart, 1)
        local ControlEntity2 = SGroup_GetSpawnedSquadAt(OttoStart, 1)
        local ControlEntity3 = SGroup_GetSpawnedSquadAt(FriedrichStart, 1)
        local ControlEntity4 = SGroup_GetSpawnedSquadAt(HansStart, 1)
        local ControlEntity5 = SGroup_GetSpawnedSquadAt(JozefStart, 1)

        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.M01_CONSCRIPT_MOSIN_NAGANT)
        Squad_GiveSlotItem(ControlEntity2, SLOT_ITEM.M01_CONSCRIPT_MOSIN_NAGANT)
        Squad_GiveSlotItem(ControlEntity3, SLOT_ITEM.M01_CONSCRIPT_MOSIN_NAGANT)
        Squad_GiveSlotItem(ControlEntity4, SLOT_ITEM.M01_CONSCRIPT_MOSIN_NAGANT)
        Squad_GiveSlotItem(ControlEntity5, SLOT_ITEM.M01_CONSCRIPT_MOSIN_NAGANT)

        Ceasefire_AddSGroup(KurtStart)
        Ceasefire_AddSGroup(OttoStart)
        Ceasefire_AddSGroup(FriedrichStart)
        Ceasefire_AddSGroup(HansStart)
        Ceasefire_AddSGroup(JozefStart)
        Ceasefire_AddSGroup(RifleGuards)
        Ceasefire_AddSGroup(RifleStartLeft)
        Ceasefire_AddSGroup(RifleStartRight)

end

function CinematicTwo()

        local Control = SGroup_Count(RifleGuards)
        if Control == 0 then
                Util_StartIntel(EVENTS.More)
                Rule_RemoveMe()

        end
end

function HansDisappear()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_disappear, false)
        if Control == true then
	        SGroup_DestroyAllSquads(HansStart)
	        SGroup_DestroyAllSquads(RifleStartLeft)
	        SGroup_DestroyAllSquads(RifleStartRight)
                Rule_RemoveMe()
        end
end

------------------------------Community Egg-------------------------------

function Community()

        Rule_AddDelayedInterval(ConsAppear, 1, 1)
        Rule_AddDelayedInterval(TextAppear, 1, 1)

end

function ConsAppear()

        local CommunityHint1 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 3 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Hidden)")
        local CommunityHint2 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 3 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Atrocity's)")
        local CommunityHint3 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 3 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: South)")

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_communitytrigger, false)
        local Control2 = Prox_ArePlayersNearMarker(player2, mkr_communitytrigger, false)
        local Random = World_GetRand(1, 3)
        if Control1 == true or Control2 == true then
                Rule_RemoveMe()
                if Random == 1 then
                        HintMouseover_Add(CommunityHint1, CommunityCons, 5, true)
                elseif Random == 2 then
                        HintMouseover_Add(CommunityHint2, CommunityCons, 5, true)
                elseif Random == 3 then
                        HintMouseover_Add(CommunityHint3, CommunityCons, 5, true)
                end
        end
end

function TextAppear()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_eggtrigger, false)
        local Control2 = Prox_ArePlayersNearMarker(player2, mkr_eggtrigger, false)
        if Control1 == true or Control2 == true then
                local CommunityEggText = Util_CreateLocString("A note found on the soldier's hand reads: Target successfully joined task force assault on objective. Recommend progression into next phase of plan.")
                HintMouseover_Add(CommunityEggText, EasterEgg, 5, true)
                Rule_RemoveMe()
        end
end

-----------------------------Optionals-----------------------------

function Optional()

        Rule_AddDelayedInterval(Academy, 1, 1)

        Rule_AddDelayedInterval(Chatter, 1, 1)
        Rule_AddDelayedInterval(SurpriseChat, 1, 1)

        Rule_AddDelayedInterval(HouseObjectiveStart, 1, 1)

        Rule_AddDelayedInterval(HouseObjectiveOne, 1, 1)
        Rule_AddDelayedInterval(HouseObjectiveTwo, 1, 1)
        Rule_AddDelayedInterval(HouseObjectiveThree, 1, 1)
        Rule_AddDelayedInterval(HouseObjectiveFour, 1, 1)

        Rule_AddDelayedInterval(MovementPattern, 1, 1)

end

function Academy()

        Command_SquadEntityLoad(player5, AcademyMG, SCMD_Load, AcademyHouse, false, true)
        Rule_RemoveMe()
end

function Chatter()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_guardchattrigger, false)
        if Control == true then
	        Util_StartIntel(EVENTS.GuardChat)
                Rule_RemoveMe()
        end
end

function SurpriseChat()

        local Control = SGroup_IsUnderAttack(SpawnTrigger, false, 9000)
        if Control == true then
	        Util_StartIntel(EVENTS.SurpriseChat)
                Rule_RemoveMe()
        end
end

function HouseObjectiveStart()

        local Control = SGroup_Count(SpawnTrigger)
        if Control == 0 then
	        Util_StartIntel(EVENTS.HouseWaveOne)
                SGroup_SetPlayerOwner(Friedrich, player3)
                Cmd_Move(Friedrich, mkr_friedrichcamp)
                Rule_RemoveMe()
        end
end

function HouseObjectiveOne()

        local Control = SGroup_Count(FirstWave)
        if Control == 0 then
	        Util_StartIntel(EVENTS.HouseWaveTwo)
                Rule_RemoveMe()
        end
end

function HouseObjectiveTwo()

        local Control = SGroup_Count(SecondWave)
        if Control == 0 then
	        Util_StartIntel(EVENTS.HouseWaveThree)
                Rule_RemoveMe()
        end
end

function HouseObjectiveThree()

        local Control = SGroup_Count(ThirdWave)
        if Control == 0 then
	        Util_StartIntel(EVENTS.HouseWaveFour)
                Rule_RemoveMe()
        end
end

function HouseObjectiveFour()

        local Control = SGroup_Count(FourthWave)
        if Control == 0 then
	        Util_StartIntel(EVENTS.HouseWaveEnd)
                Rule_RemoveMe()
        end
end

function MovementPattern()

        Cmd_Move(FirstOne, mkr_spawnbot)
        Cmd_AttackMove(FirstTwo, mkr_spawnmid)
        Cmd_Move(SecondOne, mkr_spawnmid)
        Cmd_AttackMove(SecondTwo, mkr_spawntop)
        Cmd_AttackMove(SecondThree, mkr_spawnbot)
        Cmd_AttackMove(ThirdOne, mkr_spawnverytop)
        Cmd_Move(ThirdTwo, mkr_spawnbot)
        Cmd_Move(ThirdThree, mkr_spawntop)
        Cmd_AttackMove(FourthOne, mkr_spawnverytop)
        Cmd_Move(FourthTwo, mkr_spawntop)
        Cmd_Move(FourthThree, mkr_spawnbot)
        Cmd_AttackMove(FourthFour, mkr_spawnverytop)

end

------------------------------Park Event----------------------------

function ParkEvent()

        Rule_AddDelayedInterval(GroupMoveTwo, 1, 1)
        Rule_AddDelayedInterval(GroupMoveThree, 1, 1)
        Rule_AddDelayedInterval(UnitLoad, 1, 1)
        Rule_AddDelayedInterval(MoveHalftrackOne, 1, 1)
        Rule_AddDelayedInterval(MoveHalftrackTwo, 1, 1)
        Rule_AddDelayedInterval(MoveHalftrackThree, 1, 1)
        Rule_AddDelayedInterval(ParkStart, 1, 1)
        Rule_AddDelayedInterval(ParkContinue, 1, 1)
        Rule_AddDelayedInterval(ParkFinish, 1, 1)

        Rule_AddDelayedInterval(EntranceStart, 1, 1)
        Rule_AddDelayedInterval(EntranceReinforce, 1, 1)
        Rule_AddDelayedInterval(EntranceEnd, 1, 1)


end

function MoveHalftrackOne()

        local Control = Prox_ArePlayersNearMarker(player5, mkr_carone, false)
        if Control == true then
	        Cmd_Move(MayorHalftrack, mkr_cartwo)
        end
end

function MoveHalftrackTwo()

        local Control = Prox_ArePlayersNearMarker(player5, mkr_cartwo, false)
        if Control == true then
	        Cmd_Move(MayorHalftrack, mkr_carthree)
        end
end

function MoveHalftrackThree()

        local Control = Prox_ArePlayersNearMarker(player5, mkr_carthree, false)
        if Control == true then
	        Cmd_Move(MayorHalftrack, mkr_carone)
        end
end

function GroupMoveTwo()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_groupto2, false)
        if Control == true then
	        Cmd_Move(Walter, mkr_walterto2)
	        Cmd_Move(Jaap, mkr_jaapto2)
	        Cmd_Move(Fritz, mkr_fritzto2)
	        Cmd_Move(Jacques, mkr_jacquesto2)
	        Cmd_Move(Giovanni, mkr_giovannito2)
	        Cmd_Move(Olav, mkr_olavto2)
                Rule_RemoveMe()
        end
end

function GroupMoveThree()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_groupto3, false)
        if Control == true then
	        Cmd_Move(Walter, mkr_walterto3)
	        Cmd_Move(Jaap, mkr_jaapto3)
	        Cmd_Move(Fritz, mkr_fritzto3)
	        Cmd_Move(Jacques, mkr_jacquesto3)
	        Cmd_Move(Giovanni, mkr_giovannito3)
	        Cmd_Move(Olav, mkr_olavto3)
                SGroup_SetPlayerOwner(Walter, player4)
                SGroup_SetPlayerOwner(Fritz, player4)
                SGroup_SetPlayerOwner(Jacques, player4)
                SGroup_SetPlayerOwner(Jaap, player4)
                SGroup_SetPlayerOwner(Olav, player4)
                SGroup_SetPlayerOwner(Giovanni, player4)
                Rule_RemoveMe()
        end
end

function UnitLoad()

        Command_SquadEntityLoad(player5, MayorGroup, SCMD_Load, MayorHouse, false, true)
        Command_SquadEntityLoad(player5, EntranceGroup, SCMD_Load, EntranceHouse, false, true)
        Rule_RemoveMe()

end

function ParkStart()

        local Control = SGroup_IsUnderAttack(ParkStartTrigger, false, 99999)
        if Control == true then
	        Util_StartIntel(EVENTS.ParkSequence)
                Rule_RemoveMe()
        end
end

function ParkContinue()

        local Control = SGroup_Count(ParkCounterTotal)
        if Control == 0 then
	        Util_StartIntel(EVENTS.ParkContinuation)
	        Cmd_Move(CounterOne, mkr_counteroneto)
	        Cmd_Move(CounterTwo, mkr_countertwoto)
	        Cmd_Move(CounterThree, mkr_counterthreeto)
	        Cmd_Move(CounterFour, mkr_counterfourto)
	        Cmd_Move(CounterFive, mkr_counterfiveto)
	        Cmd_Move(Walter, mkr_walterto4)
	        Cmd_Move(Jaap, mkr_jaapto4)
	        Cmd_Move(Fritz, mkr_fritzto4)
	        Cmd_Move(Jacques, mkr_jacquesto4)
	        Cmd_Move(Giovanni, mkr_giovannito4)
	        Cmd_Move(Olav, mkr_olavto4)
                Rule_RemoveMe()
        end
end

function ParkFinish()

        local Control = SGroup_Count(ParkMortar)
        if Control == 0 then
                World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                Blip2 = UI_CreateMinimapBlip(Point2, 9000, BT_ObjectivePrimary)
                UI_DeleteMinimapBlip(Blip1)
                FOW_UnRevealMarker(mkr_flaretarget)
                Rule_RemoveMe()
        end
end

function EntranceStart()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_entrancestartone, false)
        local Control2 = Prox_ArePlayersNearMarker(player1, mkr_entrancestarttwo, false)
        local Control3 = Prox_ArePlayersNearMarker(player2, mkr_entrancestartone, false)
        local Control4 = Prox_ArePlayersNearMarker(player2, mkr_entrancestarttwo, false)
        if Control1 == true or Control2 == true or Control3 == true or Control4 == true then
	        Util_StartIntel(EVENTS.EntranceSequence)
                Rule_RemoveMe()
        end
end

function EntranceReinforce()

        local Control = SGroup_Count(EntranceTrigger)
        if Control == 0 then
	        Cmd_Move(EntranceCrew, mkr_entrancecrewto)
	        Cmd_Move(EntranceBazooka, mkr_entrancebazookato)
	        Cmd_Move(EntranceRear, mkr_entrancerearto)
                Rule_RemoveMe()
        end
end

function EntranceEnd()

        local Control = SGroup_Count(EntranceDefendersTotal)
        if Control == 0 then
	        Util_StartIntel(EVENTS.EntranceDialogue)
                Rule_RemoveMe()
        end
end




-------------------------------------Forest Event------------------------------------

function ForestEvent()

        Rule_AddDelayedInterval(BridgeDialogue, 1, 1)

        Rule_AddDelayedInterval(ForestAmbush, 1, 1)
        Rule_AddDelayedInterval(ForestEnd, 1, 1)
        Rule_AddDelayedInterval(ForestCinematic, 1, 1)

        Rule_AddDelayedInterval(ForestMovementBackward, 1, 1)
        Rule_AddDelayedInterval(ForestMovementForward, 1, 1)


end

function BridgeDialogue()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_bridgetrigger, false)
        if Control == true then
	        Util_StartIntel(EVENTS.BridgeTalk)
                Rule_RemoveMe()
        end
end

function ForestAmbush()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_forestambushtrigger, false)
        if Control == true then
	        Util_StartIntel(EVENTS.ForestSurprise)
                Cmd_AttackMove(ForestLeft, mkr_forestleftto)
                Cmd_AttackMove(ForestRight, mkr_forestrightto)
                SGroup_Kill(ForestControl)
                Command_SquadEntityLoad(player5, ForestGren, SCMD_Load, ForestHouse, false, true)
                Rule_RemoveMe()
        end
end

function ForestEnd()

        local Control = SGroup_Count(ForestTotal)
        if Control == 0 then
	        Util_StartIntel(EVENTS.ForestDialogue)
                Rule_RemoveMe()
        end
end

function ForestCinematic()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_midcinematictrigger, false)
        if Control == true then
	        Camera_SetInputEnabled(false)
	        Game_SetMode(UI_Cinematic)
                Camera_Follow(Kurt)
                Camera_SetZoomDist(15)
	        Util_StartIntel(EVENTS.ForestMeet)
                Rule_RemoveMe()
        end
end

function ForestMovementBackward()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_forestcoverarea, false)
        local Control2 = SGroup_Count(ForestControl)
        if Control1 == false and Control2 == 0 then
                Cmd_Move(ForestLeft, mkr_forestretreat)
                Cmd_Move(ForestRight, mkr_forestretreat)
        end
end

function ForestMovementForward()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_forestcoverarea, false)
        local Control2 = SGroup_Count(ForestControl)
        if Control1 == true and Control2 == 0 then
                Cmd_Move(ForestLeft, mkr_forestleftto)
                Cmd_Move(ForestRight, mkr_forestrightto)
        end
end


------------------------------Mid Event------------------------------

function MidEvent()

        Rule_AddDelayedInterval(MidHouseEnter, 1, 1)
        Rule_AddDelayedInterval(MidStugDeath, 1, 1)
        Rule_AddDelayedInterval(MidGunTrigger, 1, 1)
        Rule_AddDelayedInterval(MidAttackOne, 1, 1)
        Rule_AddDelayedInterval(MidAttackTwo, 1, 1)
        Rule_AddDelayedInterval(MidAttackThree, 1, 1)
        Rule_AddDelayedInterval(MidAttackFour, 1, 1)

        Rule_AddDelayedInterval(SimmonsDead, 1, 1)

end

function MidHouseEnter()

        Command_SquadEntityLoad(player5, MidEliteHouse, SCMD_Load, MidHouseLoad, false, true)
        Rule_RemoveMe()

end

function MidStugDeath()

        local Control = SGroup_GetAvgHealth(ErwinStugRight)
        if Control < 0.9 then
                SGroup_Kill(ErwinStugRight)
                Rule_RemoveMe()
        end
end

function MidGunTrigger()

        local Control = SGroup_Count(AntiTankTrigger)
        if Control == 0 then
                Cmd_Move(MidAntiTank, mkr_midantitankto)
                Rule_RemoveMe()
        end
end

function MidAttackOne()

        local Control = SGroup_Count(MidTriggerOne)
        if Control == 0 then
	        Cmd_Move(MidRangers, mkr_midrangersto)
	        Cmd_Move(MidLeftCommando, mkr_midleftcommandoto)
	        Cmd_Move(ErwinStugRight, mkr_erwinstugrightto2)
	        Cmd_Move(ErwinStugLeft, mkr_erwinstugleftto2)
	        Cmd_Move(ErwinSturmRight, mkr_erwinsturmrightto2)
	        Cmd_Move(ErwinSturmLeft, mkr_erwinsturmleftto2)
	        Cmd_Move(ErwinGrenRight, mkr_erwingrenrightto2)
	        Cmd_Move(ErwinGrenLeft, mkr_erwingrenleftto2)
	        Cmd_Move(ErwinVolksRight, mkr_erwinvolksrightto2)
	        Cmd_Move(ErwinVolksLeft, mkr_erwinvolksleftto2)
	        Cmd_Move(ErwinFallRight, mkr_erwinfallrightto2)
	        Cmd_Move(ErwinFallLeft, mkr_erwinfallleftto2)
	        Cmd_Move(ErwinOfficer, mkr_erwinofficerto2)
                Rule_RemoveMe()
        end
end

function MidAttackTwo()

        local Control = SGroup_Count(MidTriggerTwo)
        if Control == 0 then
	        Cmd_Move(MidRightTommy, mkr_midrighttommyto)
	        Cmd_Move(MidRightRangers, mkr_midrightrangersto)
	        Cmd_Move(ErwinStugLeft, mkr_erwinstugleftto3)
	        Cmd_Move(ErwinSturmRight, mkr_erwinsturmrightto3)
	        Cmd_Move(ErwinSturmLeft, mkr_erwinsturmleftto3)
	        Cmd_Move(ErwinGrenRight, mkr_erwingrenrightto3)
	        Cmd_Move(ErwinGrenLeft, mkr_erwingrenleftto3)
	        Cmd_Move(ErwinVolksRight, mkr_erwinvolksrightto3)
	        Cmd_Move(ErwinVolksLeft, mkr_erwinvolksleftto3)
	        Cmd_Move(ErwinFallRight, mkr_erwinfallrightto3)
	        Cmd_Move(ErwinFallLeft, mkr_erwinfallleftto3)
	        Cmd_Move(ErwinOfficer, mkr_erwinofficerto3)
                Rule_RemoveMe()
        end
end

function MidAttackThree()

        local Control = SGroup_Count(MidTriggerThree)
        if Control == 0 then
	        Cmd_Move(MidRightCommando, mkr_midrightcommandoto)
	        Cmd_Move(MidLeftTommy, mkr_midlefttommyto)
	        Cmd_Move(ErwinStugLeft, mkr_erwinstugleftto4)
	        Cmd_Move(ErwinSturmRight, mkr_erwinsturmrightto4)
	        Cmd_Move(ErwinSturmLeft, mkr_erwinsturmleftto4)
	        Cmd_Move(ErwinGrenRight, mkr_erwingrenrightto4)
	        Cmd_Move(ErwinGrenLeft, mkr_erwingrenleftto4)
	        Cmd_Move(ErwinVolksRight, mkr_erwinvolksrightto4)
	        Cmd_Move(ErwinVolksLeft, mkr_erwinvolksleftto4)
	        Cmd_Move(ErwinFallRight, mkr_erwinfallrightto4)
	        Cmd_Move(ErwinFallLeft, mkr_erwinfallleftto4)
	        Cmd_Move(ErwinOfficer, mkr_erwinofficerto4)
                Rule_RemoveMe()
        end
end

function MidAttackFour()

        local Control = SGroup_Count(MidTriggerFour)
        if Control == 0 then
                Util_StartIntel(EVENTS.SimmonsDialogue)
	        Cmd_Move(Simmons, mkr_simmonsto)
	        Cmd_Move(MidGuard, mkr_midguardto)
	        Cmd_Move(RearMid, mkr_rearmidto)
	        Cmd_Move(RearLeft, mkr_rearleftto)
	        Cmd_Move(RearRight, mkr_rearrightto)
	        Cmd_Move(MidLeftRifles, mkr_midleftriflesto)
                Rule_RemoveMe()
        end
end

function SimmonsDead()

        local Control = SGroup_Count(Simmons)
        if Control == 0 then
                Blip4 = UI_CreateMinimapBlip(Point3, 9000, BT_ObjectivePrimary)
                UI_DeleteMinimapBlip(Blip3)
                World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                Rule_RemoveMe()
        end
end



-----------------------------Ruins Event-----------------------------

function RuinsEvent()

        Rule_AddDelayedInterval(FallAction, 1, 1)
        Rule_AddDelayedInterval(FallDestroy, 1, 1)
        Rule_AddDelayedInterval(RuinsFlameAttack, 1, 1)
        Rule_AddDelayedInterval(RuinsFlameFollow, 1, 1)
        Rule_AddDelayedInterval(RuinsHouseAttack, 1, 1)
        Rule_AddDelayedInterval(RuinsTrap, 1, 1)
        Rule_AddDelayedInterval(RuinsAmbush, 1, 1)
        Rule_AddDelayedInterval(RuinsSurprise, 1, 1)

end

function FallAction()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_falltrigger, false)
        local Control2 = Prox_ArePlayersNearMarker(player2, mkr_falltrigger, false)
        if Control1 == true or Control2 == true then
                Cmd_Retreat(ShockFall)
                Cmd_Move(EngineerFall, mkr_engineerfallto)
                SGroup_SetInvulnerable(FallInvulnerable, false)
	        Rule_AddOneShot(SwitchPlayer, 1)
                Rule_RemoveMe()
        end
end

function SwitchPlayer()

        SGroup_SetPlayerOwner(ShockFall, player3)
        Rule_RemoveMe()
end

function FallDestroy()

        local Control = Prox_ArePlayersNearMarker(player3, mkr_fallexecute, false)
        if Control == true then
                EGroup_Kill(BridgeFall)
        end
end

function RuinsFlameAttack()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_ruinsflametrigger, false)
        local Control2 = Prox_ArePlayersNearMarker(player2, mkr_ruinsflametrigger, false)
        if Control1 == true or Control2 == true then
                Cmd_AttackMove(RuinsFlame, mkr_ruinsflameto)
        end
end

function RuinsFlameFollow()

        local Control = SGroup_Count(RuinsFlame)
        if Control == 0 then
                Cmd_Move(RuinsRifle, mkr_ruinsrifleto)
        end
end

function RuinsHouseAttack()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_ruinshousetrigger, false)
        local Control2 = Prox_ArePlayersNearMarker(player2, mkr_ruinshousetrigger, false)
        if Control1 == true or Control2 == true then
                Cmd_Move(RuinsEntrance, mkr_ruinshousetrigger)
                Rule_RemoveMe()
        end
end

function RuinsTrap()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_ruinstraptriggerright, false)
        local Control2 = Prox_ArePlayersNearMarker(player2, mkr_ruinstraptriggerright, false)
        local Control3 = Prox_ArePlayersNearMarker(player1, mkr_ruinstraptriggerleft, false)
        local Control4 = Prox_ArePlayersNearMarker(player2, mkr_ruinstraptriggerleft, false)
        local Control5 = Prox_ArePlayersNearMarker(player1, mkr_ruinstraptriggermid, false)
        local Control6 = Prox_ArePlayersNearMarker(player2, mkr_ruinstraptriggermid, false)
        local Control7 = Prox_ArePlayersNearMarker(player1, mkr_ruinsambushtriggeralternate, false)
        local Control8 = Prox_ArePlayersNearMarker(player2, mkr_ruinsambushtriggeralternate, false)
        if Control1 == true or Control2 == true then
                Cmd_Move(RuinsTrapOne, mkr_ruinstrapto1)
                Cmd_Move(RuinsTrapTwo, mkr_ruinstrapto1)
                Rule_RemoveMe()
        elseif Control3 == true or Control4 == true then
                Cmd_Move(RuinsTrapOne, mkr_ruinstrapto2)
                Cmd_Move(RuinsTrapTwo, mkr_ruinstrapto2)
                Rule_RemoveMe()
        elseif Control5 == true or Control6 == true then
                Cmd_Move(RuinsTrapOne, mkr_ruinstrapto1)
                Cmd_Move(RuinsTrapTwo, mkr_ruinstrapto1)
                Rule_RemoveMe()
        elseif Control7 == true or Control8 == true then
                Cmd_AttackMove(RuinsTrapOne, mkr_ruinstraprushto)
                Cmd_AttackMove(RuinsTrapTwo, mkr_ruinstraprushto)
                Rule_RemoveMe()
        end
end

function RuinsAmbush()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_ruinstraptriggermid, false)
        local Control2 = Prox_ArePlayersNearMarker(player2, mkr_ruinstraptriggermid, false)
        local Control3 = Prox_ArePlayersNearMarker(player1, mkr_ruinstraptriggerleft, false)
        local Control4 = Prox_ArePlayersNearMarker(player2, mkr_ruinstraptriggerleft, false)
        local Control5 = Prox_ArePlayersNearMarker(player1, mkr_ruinsambushtriggeralternate, false)
        local Control6 = Prox_ArePlayersNearMarker(player2, mkr_ruinsambushtriggeralternate, false)
        if Control1 == true or Control2 == true then
                Cmd_AttackMove(RuinsTrapFlame, mkr_ruinsambushto3)
                Cmd_Move(RuinsTrapPara, mkr_ruinsambushto1)
                Cmd_Move(RuinsTrapRifles, mkr_ruinsambushto2)
                Rule_RemoveMe()
        elseif Control3 == true or Control4 == true then
                Cmd_AttackMove(RuinsTrapFlame, mkr_ruinsflamealternate1)
                Cmd_Move(RuinsTrapPara, mkr_ruinsambushto1)
                Cmd_Move(RuinsTrapRifles, mkr_ruinsambushto2)
                Rule_RemoveMe()
        elseif Control5 == true or Control6 == true then
                Cmd_AttackMove(RuinsTrapFlame, mkr_ruinsflamealternate2)
                Cmd_Move(RuinsTrapPara, mkr_ruinsambushto1)
                Cmd_Move(RuinsTrapRifles, mkr_ruinsambushto2)
                Rule_RemoveMe()
        end
end

function RuinsSurprise()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_ruinssurpriserifletrigger, false)
        local Control2 = Prox_ArePlayersNearMarker(player2, mkr_ruinssurpriserifletrigger, false)
        if Control1 == true or Control2 == true then
                Cmd_Move(RuinsSurpriseRifle, mkr_ruinssurpriserifleto)
                Rule_RemoveMe()
        end
end


------------------------------Cinema Event----------------------------

function CinemaEvent()

        Rule_AddDelayedInterval(CinemaStart, 1, 1)
        Rule_AddDelayedInterval(CinemaSequenceOne, 1, 1)
        Rule_AddDelayedInterval(CinemaSequenceTwo, 1, 1)
        Rule_AddDelayedInterval(CinemaSequenceThree, 1, 1)
        Rule_AddDelayedInterval(CinemaSequenceFour, 1, 1)
        Rule_AddDelayedInterval(CinemaSequenceFive, 1, 1)
        Rule_AddDelayedInterval(CinemaChat, 1, 1)
        Rule_AddDelayedInterval(CinemaFinish, 1, 1)

        Rule_AddDelayedInterval(TransferLeft, 1, 1)
        Rule_AddDelayedInterval(TransferRight, 1, 1)

end

function CinemaStart()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_cinematrigger1, false)
        local Control2 = Prox_ArePlayersNearMarker(player2, mkr_cinematrigger1, false)
        local Control3 = Prox_ArePlayersNearMarker(player1, mkr_cinematrigger2, false)
        local Control4 = Prox_ArePlayersNearMarker(player2, mkr_cinematrigger2, false)
        if Control1 == true or Control2 == true or Control3 == true or Control4 == true then
                Rule_AddOneShot(ConscriptFailsafe, 1)
                Cmd_Move(Vladilen, mkr_vladilento1)
                Util_StartIntel(EVENTS.CinemaDialogue)
                Rule_RemoveMe()
        end
end

function ConscriptFailsafe()

        local EliteName25 = Util_CreateLocString("Stator Vasnetsov")
        HintMouseover_Add(EliteName25, Stator, 5, true)
        SGroup_IncreaseVeterancyRank(Stator, 3, false)

        Modify_ReceivedDamage(Stator, 0.02)
        Modify_ReceivedAccuracy(Stator, 0.02)

        SGroup_SetPlayerOwner(Vladilen, player4)
        SGroup_SetPlayerOwner(Stator, player4)

end

function CinemaSequenceOne()

        local Control = SGroup_Count(CinemaBegin)
        if Control == 0 then
	        Camera_SetInputEnabled(false)
	        Game_SetMode(UI_Cinematic)
                Camera_MoveTo(mkr_cinemacenter)
                Camera_SetZoomDist(20)
                Util_StartIntel(EVENTS.CinemaOne)
                Rule_RemoveMe()
        end
end

function CinemaSequenceTwo()

        local Control = SGroup_Count(CinemaWaveOne)
        if Control == 0 then
                Util_StartIntel(EVENTS.CinemaTwo)
                Rule_RemoveMe()
        end
end

function CinemaSequenceThree()

        local Control = SGroup_Count(CinemaWaveTwo)
        if Control == 0 then
                Util_StartIntel(EVENTS.CinemaThree)
                Rule_RemoveMe()
        end
end

function CinemaSequenceFour()

        local Control = SGroup_Count(CinemaWaveThree)
        if Control == 0 then
                Util_StartIntel(EVENTS.CinemaFour)
                Rule_RemoveMe()
        end
end

function CinemaSequenceFive()

        local Control = SGroup_Count(CinemaWaveFour)
        if Control == 0 then
                Util_StartIntel(EVENTS.CinemaFive)
                Rule_RemoveMe()
        end
end

function CinemaChat()

        local Control = Prox_ArePlayersNearMarker(player3, mkr_cinemasoviettrigger, false)
        if Control == true then
                Util_StartIntel(EVENTS.CinemaArrival)
                Rule_RemoveMe()
        end
end

function TransferLeft()

        local Control = Prox_ArePlayersNearMarker(player5, mkr_cinematransferleft, false)
        if Control == true then
                Cmd_Move(CinemaFourEngineerOne, mkr_cinemato5)
                Cmd_Move(CinemaFiveRanger, mkr_cinemato7)
        end
end

function TransferRight()

        local Control = Prox_ArePlayersNearMarker(player5, mkr_cinematransferright, false)
        if Control == true then
                Cmd_Move(CinemaFourEngineerTwo, mkr_cinemato1)
                Cmd_Move(CinemaFiveEngineer, mkr_cinemato10)
                Cmd_Move(CinemaFiveMedic, mkr_cinemato10)
        end
end

function CinemaFinish()

        local Control = SGroup_Count(CinemaFiveTotal)
        if Control == 0 then
                Util_StartIntel(EVENTS.CinemaEnding)
                Rule_RemoveMe()
        end
end


-----------------------------Cathedral Event-------------------------

function CathedralEvent()

        Rule_AddDelayedInterval(FrontFight, 1, 1)
        Rule_AddDelayedInterval(FrontDialogue, 1, 1)

        Rule_AddDelayedInterval(CathedralSide, 1, 1)
        Rule_AddDelayedInterval(CathedralIntermission, 1, 1)
        Rule_AddDelayedInterval(CathedralBackup, 1, 1)

        Rule_AddDelayedInterval(CathedralStart, 1, 1)

end

function FrontFight()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_fronttrigger, false)
        if Control == true then
                Cmd_Move(FrontGun, mkr_frontgun)
                Cmd_Move(FrontRanger, mkr_frontranger)
                Cmd_Move(FrontPara, mkr_frontpara)
                Rule_RemoveMe()
        end
end

function FrontDialogue()

        local Control = Prox_ArePlayersNearMarker(player5, mkr_frontgun, false)
        if Control == true then
                Util_StartIntel(EVENTS.FrontOpening)
                Rule_RemoveMe()
        end
end

function CathedralSide()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_cathedraltoptrigger, false)
        if Control == true then
                Cmd_Move(CathedralRangerOne, mkr_cathedralrangeroneto)
                Cmd_Move(CathedralRangerTwo, mkr_cathedralrangertwoto)
                Cmd_Move(CathedralEngineerOne, mkr_cathedralengineeroneto)
                Cmd_Move(CathedralEngineerTwo, mkr_cathedralengineertwoto)
                Cmd_Move(CathedralEngineerThree, mkr_cathedralengineerthreeto)
                Cmd_Move(CathedralFlankRear, mkr_flankrightbottom)
                Cmd_Move(CathedralFlankRifles, mkr_flankrighttop)
                Rule_RemoveMe()
        end
end

function CathedralIntermission()

        local Control = SGroup_Count(FlankGroup)
        if Control == 0 then
                Util_StartIntel(EVENTS.FlankEnding)
                Rule_RemoveMe()
        end
end

function CathedralBackup()

        local Control1 = Prox_ArePlayersNearMarker(player3, mkr_statorstop, false)
        local Control2 = Prox_ArePlayersNearMarker(player4, mkr_statorstop, false)
        if Control1 == true or Control2 == true then
                Util_StartIntel(EVENTS.SovietsArrive)
                Rule_RemoveMe()
        end
end

function CathedralStart()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_cathedraltrigger, false)
        if Control == true then
		Camera_SetInputEnabled(false)
		Game_SetMode(UI_Cinematic)
      		Camera_Follow(Adams)
      		Camera_SetZoomDist(5)
                Util_StartIntel(EVENTS.CathedralFinale)
                Rule_RemoveMe()
        end
end

------------------------------Points------------------------------

function Points()

        Rule_AddDelayedInterval(PointSecondaryOne, 1, 1)
        Rule_AddDelayedInterval(PointOne, 1, 1)
        Rule_AddDelayedInterval(PointTwo, 1, 1)
        Rule_AddDelayedInterval(PointThree, 1, 1)
        Rule_AddDelayedInterval(PointFour, 1, 1)
        Rule_AddDelayedInterval(PointFive, 1, 1)
        Rule_AddDelayedInterval(PointSix, 1, 1)

end

function PointSecondaryOne()

        local PointFocus1 = EGroup_IsCapturedByPlayer(PointOptional1, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(PointOptional1, player2, false)
        local PointFocus3 = EGroup_IsCapturedByPlayer(PointOptional1, player3, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(RetreatOptional1, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Rule_RemoveMe()
        end
end

function PointOne()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point1, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point1, player2, false)
        local PointFocus3 = EGroup_IsCapturedByPlayer(Point1, player3, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat1, 1)
                local DestroyEntity = EGroup_GetSpawnedEntityAt(RetreatStart, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity)
                HintPoint_Remove(Hint1)
                HintPoint_Remove(Hint2)
                Rule_RemoveMe()
        end
end

function PointTwo()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point2, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point2, player2, false)
        local PointFocus3 = EGroup_IsCapturedByPlayer(Point2, player3, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat2, 1)
                local DestroyEntity = EGroup_GetSpawnedEntityAt(Retreat1, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity)
	        Cmd_Move(ErwinStugRight, mkr_erwinstugrightto1)
	        Cmd_Move(ErwinStugLeft, mkr_erwinstugleftto1)
	        Cmd_Move(ErwinSturmRight, mkr_erwinsturmrightto1)
	        Cmd_Move(ErwinSturmLeft, mkr_erwinsturmleftto1)
	        Cmd_Move(ErwinGrenRight, mkr_erwingrenrightto1)
	        Cmd_Move(ErwinGrenLeft, mkr_erwingrenleftto1)
	        Cmd_Move(ErwinVolksRight, mkr_erwinvolksrightto1)
	        Cmd_Move(ErwinVolksLeft, mkr_erwinvolksleftto1)
	        Cmd_Move(ErwinFallRight, mkr_erwinfallrightto1)
	        Cmd_Move(ErwinFallLeft, mkr_erwinfallleftto1)
	        Cmd_Move(ErwinOfficer, mkr_erwinofficerto1)
                Blip3 = UI_CreateMinimapBlip(Simmons, 9000, BT_ObjectivePrimary)
                UI_DeleteMinimapBlip(Blip2)
                World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                Util_StartIntel(EVENTS.MidCommence)
                Rule_RemoveMe()
        end
end

function PointThree()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point3, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point3, player2, false)
        local PointFocus3 = EGroup_IsCapturedByPlayer(Point3, player3, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat3, 1)
                local DestroyEntity = EGroup_GetSpawnedEntityAt(Retreat2, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity)
                Util_StartIntel(EVENTS.StreetCinematic)
                Rule_RemoveMe()
        end
end

function PointFour()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point4, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point4, player2, false)
        local PointFocus3 = EGroup_IsCapturedByPlayer(Point4, player3, false)
        local PointControl1 = EGroup_IsCapturedByPlayer(Point5, player1, false)
        local PointControl2 = EGroup_IsCapturedByPlayer(Point5, player2, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true then
                if PointControl1 == false or PointControl2 == false then
                        local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat4, 1)
                        Entity_SetPlayerOwner(RetreatEntity, player1)
                        Rule_RemoveMe()
                end
        end
end

function PointFive()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point5, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point5, player2, false)
        local PointFocus3 = EGroup_IsCapturedByPlayer(Point5, player3, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat5, 1)
                local DestroyEntity1 = EGroup_GetSpawnedEntityAt(Retreat3, 1)
                local DestroyEntity2 = EGroup_GetSpawnedEntityAt(Retreat4, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity1)
                Entity_Destroy(DestroyEntity2)
                Rule_RemoveMe()
        end
end

function PointSix()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point6, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point6, player2, false)
        local PointFocus3 = EGroup_IsCapturedByPlayer(Point6, player3, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat6, 1)
                local DestroyEntity1 = EGroup_GetSpawnedEntityAt(Retreat5, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity1)
                Rule_RemoveMe()
        end
end



------------------------------Elites----------------------------

function Elites()

        Modify_ReceivedDamage(Kurt, 0.4)
        Modify_ReceivedAccuracy(Kurt, 0.7)
        Modify_ReceivedDamage(Otto, 0.2)
        Modify_ReceivedAccuracy(Otto, 0.7)
        Modify_ReceivedDamage(Friedrich, 0.5)
        Modify_ReceivedAccuracy(Friedrich, 0.5)
        Modify_ReceivedDamage(Hans, 0.2)
        Modify_ReceivedAccuracy(Hans, 0.9)
        Modify_ReceivedDamage(Jozef, 0.5)
        Modify_ReceivedAccuracy(Jozef, 0.6)

        Modify_ReceivedDamage(Vladilen, 0.02)
        Modify_ReceivedAccuracy(Vladilen, 0.02)
        Modify_ReceivedDamage(Stator, 0.02)
        Modify_ReceivedAccuracy(Stator, 0.02)
        Modify_ReceivedDamage(Aleksei, 0.02)
        Modify_ReceivedAccuracy(Aleksei, 0.02)
        Modify_ReceivedDamage(Nikolai, 0.02)
        Modify_ReceivedAccuracy(Nikolai, 0.02)
        Modify_ReceivedDamage(Yuri, 0.02)
        Modify_ReceivedAccuracy(Yuri, 0.02)
        Modify_ReceivedDamage(Viktor, 0.02)
        Modify_ReceivedAccuracy(Viktor, 0.02)
        Modify_ReceivedDamage(Dmitriy, 0.02)
        Modify_ReceivedAccuracy(Dmitriy, 0.02)

        Modify_ReceivedDamage(ElitePara, 0.6)
        Modify_ReceivedAccuracy(ElitePara, 0.7)
        Modify_ReceivedDamage(EliteRear, 0.8)
        Modify_ReceivedAccuracy(EliteRear, 0.8)
        Modify_ReceivedDamage(PatrolAcademy, 0.5)
        Modify_ReceivedAccuracy(PatrolAcademy, 0.5)
        Modify_ReceivedDamage(Kaiser, 0.8)
        Modify_ReceivedAccuracy(Kaiser, 0.8)
        Modify_ReceivedDamage(Erwin, 0.8)
        Modify_ReceivedAccuracy(Erwin, 0.8)
        Modify_ReceivedDamage(MidEliteHouse, 0.5)
        Modify_ReceivedAccuracy(MidEliteHouse, 0.9)
        Modify_ReceivedDamage(Simmons, 0.2)
        Modify_ReceivedAccuracy(Simmons, 0.5)
        Modify_ReceivedDamage(MidGuard, 0.7)
        Modify_ReceivedAccuracy(MidGuard, 0.8)
        Modify_ReceivedDamage(RuinsEntranceRifles, 0.5)
        Modify_ReceivedAccuracy(RuinsEntranceRifles, 0.9)
        Modify_ReceivedDamage(RuinsHouseElites, 0.9)
        Modify_ReceivedAccuracy(RuinsHouseElites, 0.5)
        Modify_ReceivedDamage(RuinsTrapRifles, 0.7)
        Modify_ReceivedAccuracy(RuinsTrapRifles, 0.7)
        Modify_ReceivedDamage(RuinsSurpriseRifle, 0.6)
        Modify_ReceivedAccuracy(RuinsSurpriseRifle, 0.7)
        Modify_ReceivedDamage(CinemaTwoRifle, 0.8)
        Modify_ReceivedAccuracy(CinemaTwoRifle, 0.8)
        Modify_ReceivedDamage(ForestGren, 0.6)
        Modify_ReceivedAccuracy(ForestGren, 0.7)
        Modify_ReceivedDamage(ForestLeft, 0.4)
        Modify_ReceivedAccuracy(ForestLeft, 0.6)
        Modify_ReceivedDamage(ForestRight, 0.4)
        Modify_ReceivedAccuracy(ForestRight, 0.6)
        Modify_ReceivedDamage(CathedralRangerOne, 0.8)
        Modify_ReceivedAccuracy(CathedralRangerOne, 0.8)
        Modify_ReceivedDamage(CathedralRangerTwo, 0.8)
        Modify_ReceivedAccuracy(CathedralRangerTwo, 0.8)
        Modify_ReceivedDamage(CathedralEngineerOne, 0.7)
        Modify_ReceivedAccuracy(CathedralEngineerOne, 0.8)
        Modify_ReceivedDamage(CathedralEngineerTwo, 0.7)
        Modify_ReceivedAccuracy(CathedralEngineerTwo, 0.8)
        Modify_ReceivedDamage(CathedralEngineerThree, 0.7)
        Modify_ReceivedAccuracy(CathedralEngineerThree, 0.8)
        Modify_ReceivedDamage(ProtectorLeft, 0.4)
        Modify_ReceivedAccuracy(ProtectorLeft, 0.4)
        Modify_ReceivedDamage(ProtectorRight, 0.4)
        Modify_ReceivedAccuracy(ProtectorRight, 0.4)
        Modify_ReceivedDamage(Adams, 0.2)
        Modify_ReceivedAccuracy(Adams, 0.2)


end

function EliteHint()

        local EliteName1 = Util_CreateLocString("Kurt Bachmann")
        local EliteName2 = Util_CreateLocString("Friedrich Althaus")
        local EliteName3 = Util_CreateLocString("Otto Baasch")
        local EliteName4 = Util_CreateLocString("Hans Dunkel")
        local EliteName5 = Util_CreateLocString("Jozef Smrek")

        local EliteName6 = Util_CreateLocString("Walter Hinkel")
        local EliteName7 = Util_CreateLocString("Fritz Hudel")
        local EliteName8 = Util_CreateLocString("Jaap van Gilse")
        local EliteName9 = Util_CreateLocString("Jacques Villon")
        local EliteName10 = Util_CreateLocString("Olav Storsveen")
        local EliteName11 = Util_CreateLocString("Giovanni Bassi")

        HintMouseover_Add(EliteName1, Kurt, 5, true)
        HintMouseover_Add(EliteName2, Friedrich, 5, true)
        HintMouseover_Add(EliteName3, Otto, 5, true)
        HintMouseover_Add(EliteName4, Hans, 5, true)
        HintMouseover_Add(EliteName5, Jozef, 5, true)

        HintMouseover_Add(EliteName6, Walter, 5, true)
        HintMouseover_Add(EliteName7, Fritz, 5, true)
        HintMouseover_Add(EliteName8, Jaap, 5, true)
        HintMouseover_Add(EliteName9, Jacques, 5, true)
        HintMouseover_Add(EliteName10, Olav, 5, true)
        HintMouseover_Add(EliteName11, Giovanni, 5, true)

        local EliteName12 = Util_CreateLocString("28th Specialist Airbourne")
        HintMouseover_Add(EliteName12, ElitePara, 5, true)
        local EliteName13 = Util_CreateLocString("Veteran Recon Attachment")
        HintMouseover_Add(EliteName13, EliteRear, 5, true)
        local EliteName14 = Util_CreateLocString("Master Rifles Squad")
        HintMouseover_Add(EliteName14, PatrolAcademy, 5, true)
        local EliteName15 = Util_CreateLocString("Elite 'Kaiser' Task Force")
        SGroup_IncreaseVeterancyRank(Kaiser, 2, false)
        local EliteName16 = Util_CreateLocString("Elite 'Erwin' Task Force")
        SGroup_IncreaseVeterancyRank(Erwin, 2, false)

        Modify_VehicleRotationSpeed(ErwinStugLeft, 0.3)
        Modify_VehicleRotationSpeed(ErwinStugRight, 0.3)
        Modify_UnitSpeed(ErwinStugRight, 0.5)
        Modify_UnitSpeed(ErwinStugLeft, 0.5)

        local EliteName17 = Util_CreateLocString("7th Infiltration Core")
        HintMouseover_Add(EliteName17, MidEliteHouse, 5, true)
        SGroup_IncreaseVeterancyRank(MidEliteHouse, 2, false)
        local EliteName18 = Util_CreateLocString("Lieutenant Simmons")
        HintMouseover_Add(EliteName18, Simmons, 5, true)
        SGroup_IncreaseVeterancyRank(Simmons, 3, false)
        local EliteName19 = Util_CreateLocString("Veteran Bodyguards")
        HintMouseover_Add(EliteName19, MidGuard, 5, true)
        SGroup_IncreaseVeterancyRank(MidGuard, 1, false)
        local EliteName20 = Util_CreateLocString("Urban Defense Specialists")
        HintMouseover_Add(EliteName20, RuinsEntranceRifles, 5, true)
        SGroup_IncreaseVeterancyRank(RuinsEntranceRifles, 2, false)
        local EliteName21 = Util_CreateLocString("6th Airborne Elites")
        HintMouseover_Add(EliteName21, RuinsHouseElites, 5, true)
        SGroup_IncreaseVeterancyRank(RuinsHouseElites, 2, false)
        local EliteName22 = Util_CreateLocString("3rd Infiltration Core")
        HintMouseover_Add(EliteName22, RuinsTrapRifles, 5, true)
        SGroup_IncreaseVeterancyRank(RuinsTrapRifles, 1, false)
        local EliteName23 = Util_CreateLocString("Veteran Urban Skirmishers")
        HintMouseover_Add(EliteName23, RuinsSurpriseRifle, 5, true)
        SGroup_IncreaseVeterancyRank(RuinsSurpriseRifle, 2, false)
        local EliteName24 = Util_CreateLocString("Veteran Urban Marksmen")
        HintMouseover_Add(EliteName24, CinemaTwoRifle, 5, true)
        SGroup_IncreaseVeterancyRank(CinemaTwoRifle, 1, false)

        local EliteName25 = Util_CreateLocString("Vladilen Vasnetsov")
        HintMouseover_Add(EliteName25, Vladilen, 5, true)
        SGroup_IncreaseVeterancyRank(Vladilen, 3, false)
        local EliteName26 = Util_CreateLocString("Stator Vasnetsov")
        HintMouseover_Add(EliteName26, Stator, 5, true)
        SGroup_IncreaseVeterancyRank(Stator, 3, false)
        local EliteName27 = Util_CreateLocString("Aleksei Zaytsev")
        HintMouseover_Add(EliteName27, Aleksei, 5, true)
        SGroup_IncreaseVeterancyRank(Aleksei, 3, false)
        local EliteName28 = Util_CreateLocString("Dmitriy Titov")
        HintMouseover_Add(EliteName28, Dmitriy, 5, true)
        SGroup_IncreaseVeterancyRank(Dmitriy, 3, false)
        local EliteName29 = Util_CreateLocString("Nikolai Pukhov")
        HintMouseover_Add(EliteName29, Nikolai, 5, true)
        SGroup_IncreaseVeterancyRank(Nikolai, 3, false)
        local EliteName30 = Util_CreateLocString("Yuri Konev")
        HintMouseover_Add(EliteName30, Yuri, 5, true)
        SGroup_IncreaseVeterancyRank(Yuri, 3, false)
        local EliteName31 = Util_CreateLocString("Viktor Vasilevsky")
        HintMouseover_Add(EliteName31, Viktor, 5, true)
        SGroup_IncreaseVeterancyRank(Viktor, 3, false)

        local EliteName32 = Util_CreateLocString("Unmarked Assailant")
        HintMouseover_Add(EliteName32, ForestGren, 5, true)
        SGroup_IncreaseVeterancyRank(ForestGren, 3, false)
        local EliteName33 = Util_CreateLocString("Unmarked Assailant")
        HintMouseover_Add(EliteName33, ForestLeft, 5, true)
        SGroup_IncreaseVeterancyRank(ForestLeft, 3, false)
        local EliteName34 = Util_CreateLocString("Unmarked Assailant")
        HintMouseover_Add(EliteName34, ForestRight, 5, true)
        SGroup_IncreaseVeterancyRank(ForestRight, 3, false)
        local EliteName35 = Util_CreateLocString("Master Ranger Davidson")
        HintMouseover_Add(EliteName35, CathedralRangerOne, 5, true)
        SGroup_IncreaseVeterancyRank(CathedralRangerOne, 3, false)
        local EliteName36 = Util_CreateLocString("Master Ranger McCabe")
        HintMouseover_Add(EliteName36, CathedralRangerTwo, 5, true)
        SGroup_IncreaseVeterancyRank(CathedralRangerTwo, 3, false)
        local EliteName37 = Util_CreateLocString("Master Engineer Goodstein")
        HintMouseover_Add(EliteName37, CathedralEngineerOne, 5, true)
        SGroup_IncreaseVeterancyRank(CathedralEngineerOne, 3, false)
        local EliteName38 = Util_CreateLocString("Master Engineer Pawlowski")
        HintMouseover_Add(EliteName38, CathedralEngineerTwo, 5, true)
        SGroup_IncreaseVeterancyRank(CathedralEngineerTwo, 3, false)
        local EliteName39 = Util_CreateLocString("Master Engineer Harper")
        HintMouseover_Add(EliteName39, CathedralEngineerThree, 5, true)
        SGroup_IncreaseVeterancyRank(CathedralEngineerThree, 3, false)

        local EliteName40 = Util_CreateLocString("Major Adams")
        HintMouseover_Add(EliteName40, Adams, 5, true)
        SGroup_IncreaseVeterancyRank(Adams, 3, false)
        local EliteName41 = Util_CreateLocString("Command Assistant Doherty")
        HintMouseover_Add(EliteName41, ProtectorLeft, 5, true)
        SGroup_IncreaseVeterancyRank(ProtectorLeft, 3, false)
        local EliteName42 = Util_CreateLocString("Command Assistant Johnson")
        HintMouseover_Add(EliteName42, ProtectorRight, 5, true)
        SGroup_IncreaseVeterancyRank(ProtectorRight, 3, false)

        local EliteName43 = Util_CreateLocString("Elite 'Erwin' Task Force")
        HintMouseover_Add(EliteName43, ErwinFallLeft, 5, true)
        local EliteName44 = Util_CreateLocString("Elite 'Erwin' Task Force")
        HintMouseover_Add(EliteName44, ErwinFallRight, 5, true)
        local EliteName45 = Util_CreateLocString("Elite 'Erwin' Task Force")
        HintMouseover_Add(EliteName45, ErwinGrenLeft, 5, true)
        local EliteName46 = Util_CreateLocString("Elite 'Erwin' Task Force")
        HintMouseover_Add(EliteName46, ErwinGrenRight, 5, true)
        local EliteName47 = Util_CreateLocString("Elite 'Erwin' Task Force")
        HintMouseover_Add(EliteName47, ErwinOfficer, 5, true)
        local EliteName48 = Util_CreateLocString("Elite 'Erwin' Task Force")
        HintMouseover_Add(EliteName48, ErwinStugLeft, 5, true)
        local EliteName49 = Util_CreateLocString("Elite 'Erwin' Task Force")
        HintMouseover_Add(EliteName49, ErwinStugRight, 5, true)
        local EliteName50 = Util_CreateLocString("Elite 'Erwin' Task Force")
        HintMouseover_Add(EliteName50, ErwinSturmLeft, 5, true)
        local EliteName51 = Util_CreateLocString("Elite 'Erwin' Task Force")
        HintMouseover_Add(EliteName51, ErwinSturmRight, 5, true)
        local EliteName52 = Util_CreateLocString("Elite 'Erwin' Task Force")
        HintMouseover_Add(EliteName52, ErwinVolksLeft, 5, true)
        local EliteName53 = Util_CreateLocString("Elite 'Erwin' Task Force")
        HintMouseover_Add(EliteName53, ErwinVolksRight, 5, true)

        local EliteName54 = Util_CreateLocString("Elite 'Kaiser' Task Force")
        HintMouseover_Add(EliteName54, KaiserGrenLeft, 5, true)
        local EliteName55 = Util_CreateLocString("Elite 'Kaiser' Task Force")
        HintMouseover_Add(EliteName55, KaiserGrenRight, 5, true)
        local EliteName56 = Util_CreateLocString("Elite 'Kaiser' Task Force")
        HintMouseover_Add(EliteName56, KaiserOfficer, 5, true)
        local EliteName57 = Util_CreateLocString("Elite 'Kaiser' Task Force")
        HintMouseover_Add(EliteName57, KaiserPanzerLeft, 5, true)
        local EliteName58 = Util_CreateLocString("Elite 'Kaiser' Task Force")
        HintMouseover_Add(EliteName58, KaiserPanzerRight, 5, true)
        local EliteName59 = Util_CreateLocString("Elite 'Kaiser' Task Force")
        HintMouseover_Add(EliteName59, KaiserTank, 5, true)

end

------------------------------Hints---------------------------------


function Hints()

        Rule_AddDelayedInterval(ForestHint, 1, 1)

end

function ForestHint()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_disappeartrigger, false)
        if Control == true then
                HintPoint_Remove(Hint3)
                Rule_RemoveMe()
        end
end


------------------------------Officers-------------------------------

function Officers()

        Rule_AddDelayedInterval(EntranceOfficer, 1, 30)
        Rule_AddDelayedInterval(SimmonsOfficer, 1, 30)
        Rule_AddDelayedInterval(AdamsOfficer, 1, 45)

end

function EntranceOfficer()

        local Control1 = SGroup_IsUnderAttackByPlayer(EntranceCaptain, player1, 9000)
        local Control2 = SGroup_IsUnderAttackByPlayer(EntranceCaptain, player2, 9000)
        local Control3 = SGroup_IsUnderAttackByPlayer(EntranceCaptain, player3, 9000)
        local Control4 = SGroup_IsUnderAttackByPlayer(EntranceCaptain, player4, 9000)
        local Control5 = SGroup_Count(OfficerRifles)
        if Control1 == true or Control2 == true or Control3 == true or Control4 == true then
                if Control5 < 2 then
                        Util_StartIntel(EVENTS.EntranceSpeech)
                end
        end
end

function SimmonsOfficer()

        local Control1 = SGroup_IsUnderAttackByPlayer(Simmons, player1, 9000)
        local Control2 = SGroup_IsUnderAttackByPlayer(Simmons, player2, 9000)
        local Control3 = SGroup_IsUnderAttackByPlayer(Simmons, player3, 9000)
        local Control4 = SGroup_IsUnderAttackByPlayer(Simmons, player4, 9000)
        if Control1 == true or Control2 == true or Control3 == true or Control4 == true then
                local Target = Player_GetSquadConcentration(player1)
                Cmd_Ability(player5, EXTRA.AEF.PHOSPHOROUS_STRIKE, Target, nil, true)
                Util_StartIntel(EVENTS.SimmonsArty)
        end
end

function AdamsOfficer()

        local Control1 = SGroup_IsUnderAttackByPlayer(Adams, player1, 9000)
        local Control2 = SGroup_IsUnderAttackByPlayer(Adams, player2, 9000)
        local Control3 = SGroup_IsUnderAttackByPlayer(Adams, player3, 9000)
        local Control4 = SGroup_IsUnderAttackByPlayer(Adams, player4, 9000)
        if Control1 == true or Control2 == true or Control3 == true or Control4 == true then
                local Control5 = SGroup_Count(AdamsReinforceLeft)
                if Control5 < 2 then
                        local Random = World_GetRand(1, 6)
                        if Random == 1 then
                                Util_StartIntel(EVENTS.AdamsOne)
                        elseif Random == 2 then
                                Util_StartIntel(EVENTS.AdamsTwo)
                        elseif Random == 3 then
                                Util_StartIntel(EVENTS.AdamsThree)
                        elseif Random == 4 then
                                Util_StartIntel(EVENTS.AdamsFour)
                        elseif Random == 5 then
                                Util_StartIntel(EVENTS.AdamsFive)
                        elseif Random == 6 then
                                Util_StartIntel(EVENTS.AdamsSix)
                        end
                end
        end
end

------------------------------Barrage------------------------------

function Barrage()

        Rule_AddDelayedInterval(VisualOne, 1, 52)
        Rule_AddDelayedInterval(VisualTwo, 1, 40)
        Rule_AddDelayedInterval(VisualThree, 1, 45)
        Rule_AddDelayedInterval(VisualFour, 1, 74)
        Rule_AddDelayedInterval(VisualFive, 1, 47)
        Rule_AddDelayedInterval(VisualSix, 1, 89)

end

function VisualOne()

        local Control = SGroup_Count(VisualControl)
        if Control == 0 then
                local Direction = Marker_GetDirection(mkr_directionmarker)
                Cmd_Ability(player5, ABILITY.GERMAN.STUKA_BOMBING_STRIKE, mkr_visual1, Direction, true)
        end
end

function VisualTwo()

        local Control = SGroup_Count(VisualControl)
        if Control == 0 then
                local Direction = Marker_GetDirection(mkr_directionmarker)
                Cmd_Ability(player5, ABILITY.AEF.MAJOR_ARTILLERY, mkr_visual2, Direction, true)
        end
end

function VisualThree()

        local Control = SGroup_Count(VisualControl)
        if Control == 0 then
                local Direction = Marker_GetDirection(mkr_directionmarker)
                Cmd_Ability(player5, ABILITY.AEF.MAJOR_ARTILLERY, mkr_visual3, Direction, true)
        end
end

function VisualFour()

        local Control = SGroup_Count(VisualControl)
        if Control == 0 then
                local Direction = Marker_GetDirection(mkr_directionmarker)
                Cmd_Ability(player5, ABILITY.GERMAN.STUKA_BOMBING_STRIKE, mkr_visual4, Direction, true)
        end
end

function VisualFive()

        local Control = SGroup_Count(VisualControl)
        if Control == 0 then
                local Direction = Marker_GetDirection(mkr_directionmarker)
                Cmd_Ability(player5, ABILITY.AEF.MAJOR_ARTILLERY, mkr_visual5, Direction, true)
        end
end

function VisualSix()

        local Control = SGroup_Count(VisualControl)
        if Control == 0 then
                local Direction = Marker_GetDirection(mkr_directionmarker)
                Cmd_Ability(player5, ABILITY.GERMAN.STUKA_BOMBING_STRIKE, mkr_visual6, Direction, true)
        end
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

        local ControlEntity1 = SGroup_GetSpawnedSquadAt(Hans, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_NO_PRONE_MP)
        local ControlEntity2 = SGroup_GetSpawnedSquadAt(EliteRear, 1)
        SGroup_IncreaseVeterancyRank(EliteRear, 1, false)
        Squad_GiveSlotItem(ControlEntity2, SLOT_ITEM.RIFLEMEN_M1918_BAR_MP)
        local ControlEntity3 = SGroup_GetSpawnedSquadAt(ElitePara, 1)
        SGroup_IncreaseVeterancyRank(ElitePara, 2, false)
        Squad_GiveSlotItem(ControlEntity3, SLOT_ITEM.RIFLEMEN_30_CAL)
        Squad_GiveSlotItem(ControlEntity3, SLOT_ITEM.RIFLEMEN_M1918_BAR_MP)
        local ControlEntity4 = SGroup_GetSpawnedSquadAt(PatrolAcademy, 1)
        Squad_GiveSlotItem(ControlEntity4, SLOT_ITEM.RIFLEMEN_30_CAL)
        SGroup_IncreaseVeterancyRank(PatrolAcademy, 2, false)
        local ControlEntity5 = SGroup_GetSpawnedSquadAt(ErwinStugLeft, 1)
        Squad_GiveSlotItem(ControlEntity5, SLOT_ITEM.MG42_TURRET_MOUNTED_STUGIV_MP)
        local ControlEntity6 = SGroup_GetSpawnedSquadAt(ErwinStugRight, 1)
        Squad_GiveSlotItem(ControlEntity6, SLOT_ITEM.MG42_TURRET_MOUNTED_STUGIV_MP)
        local ControlEntity7 = SGroup_GetSpawnedSquadAt(MidEliteHouse, 1)
        Squad_GiveSlotItem(ControlEntity7, SLOT_ITEM.RIFLEMEN_30_CAL)
        Squad_GiveSlotItem(ControlEntity7, SLOT_ITEM.ROKS_2_FLAMETHROWER_ITEM_MP)
        local ControlEntity8 = SGroup_GetSpawnedSquadAt(Simmons, 1)
        Squad_GiveSlotItem(ControlEntity8, SLOT_ITEM.RIFLEMEN_M1918_BAR_MP)
        local ControlEntity9 = SGroup_GetSpawnedSquadAt(MidSidePara, 1)
        Squad_GiveSlotItem(ControlEntity9, SLOT_ITEM.BAZOOKA_MP)
        local ControlEntity10 = SGroup_GetSpawnedSquadAt(RuinsFlame, 1)
        Squad_GiveSlotItem(ControlEntity10, SLOT_ITEM.ROKS_2_FLAMETHROWER_ITEM_MP)
        Squad_GiveSlotItem(ControlEntity10, SLOT_ITEM.ROKS_2_FLAMETHROWER_ITEM_MP)
        local ControlEntity11 = SGroup_GetSpawnedSquadAt(RuinsEntranceRifles, 1)
        Squad_GiveSlotItem(ControlEntity11, SLOT_ITEM.RIFLEMEN_30_CAL)
        local ControlEntity12 = SGroup_GetSpawnedSquadAt(RuinsHouseElites, 1)
        Squad_GiveSlotItem(ControlEntity12, SLOT_ITEM.RIFLEMEN_M1918_BAR_MP)
        local ControlEntity13 = SGroup_GetSpawnedSquadAt(RuinsTrapFlame, 1)
        Squad_GiveSlotItem(ControlEntity13, SLOT_ITEM.TOMMY_FLAMETHROWER)
        Squad_GiveSlotItem(ControlEntity13, SLOT_ITEM.TOMMY_FLAMETHROWER)
        local ControlEntity14 = SGroup_GetSpawnedSquadAt(RuinsTrapRifles, 1)
        Squad_GiveSlotItem(ControlEntity14, SLOT_ITEM.DP_28_LIGHT_MACHINE_GUN_PACKAGE_MOVING_NO_PRONE_MP)
        local ControlEntity15 = SGroup_GetSpawnedSquadAt(RuinsSurpriseRifle, 1)
        Squad_GiveSlotItem(ControlEntity15, SLOT_ITEM.TOMMY_FLAMETHROWER)
        Squad_GiveSlotItem(ControlEntity15, SLOT_ITEM.TOMMY_FLAMETHROWER)
        local ControlEntity16 = SGroup_GetSpawnedSquadAt(ProtectorLeft, 1)
        Squad_GiveSlotItem(ControlEntity16, SLOT_ITEM.RIFLEMEN_30_CAL)
        local ControlEntity17 = SGroup_GetSpawnedSquadAt(ProtectorRight, 1)
        Squad_GiveSlotItem(ControlEntity17, SLOT_ITEM.RIFLEMEN_M1918_BAR_MP)


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
		
		Player_SetAbilityAvailability(player1, ABILITY.WEST_GERMAN.VOLKSGRENADIER_FIRE_GRENADE_MP, ITEM_UNLOCKED)

        Player_SetAbilityAvailability(player2, ABILITY.WEST_GERMAN.PIONEER_VOLKS_SALVAGE, ITEM_REMOVED)
        Player_SetAbilityAvailability(player2, ABILITY.WEST_GERMAN.THROUGH_SALVAGE, ITEM_REMOVED)
        Player_SetAbilityAvailability(player2, ABILITY.WEST_GERMAN.MG34_DISPATCH, ITEM_REMOVED)
        Player_SetAbilityAvailability(player2, ABILITY.WEST_GERMAN.ASSAULT_PIONEER_DROP_MEDPACK_ABILITY_MP, ITEM_REMOVED)
		
		Player_SetAbilityAvailability(player2, ABILITY.WEST_GERMAN.VOLKSGRENADIER_FIRE_GRENADE_MP, ITEM_UNLOCKED)

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
        Player_SetUpgradeAvailability(player1, UPG.AEF.FIGHTING_POSITION_MG_ADDITION_MP, ITEM_REMOVED)
		
		Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.VOLKS_STG44_UPGRADE, ITEM_UNLOCKED)

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
        Player_SetUpgradeAvailability(player2, UPG.AEF.FIGHTING_POSITION_MG_ADDITION_MP, ITEM_REMOVED)
		
		Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.VOLKS_STG44_UPGRADE, ITEM_UNLOCKED)

        Player_SetUpgradeAvailability(player4, UPG.GERMAN.STUG_TOP_GUNNER_MP, ITEM_UNLOCKED)

        Player_SetUpgradeAvailability(player4, UPG.GERMAN.STUG_TOP_GUNNER_MP, ITEM_UNLOCKED)

end

function Abilities()

        Player_AddAbility(player3, BP_GetAbilityBlueprint("flare_artillery"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("flare_artillery"))
        Player_AddAbility(player3, BP_GetAbilityBlueprint("stuka_incendiary_bombs"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("stuka_flame_strike"))

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

        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("stuka_fragmentation_bomb"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("stuka_fragmentation_bomb"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("stuka_close_air_support"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("stuka_close_air_support"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("stuka_smoke_bomb"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("stuka_smoke_bomb"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("stuka_flame_strike"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("stuka_incendiary_bombs"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("stuka_strafe"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("stuka_strafing_run"))
end

function BuildingRestrict()

        Player_SetEntityProductionAvailability(player1, EBP.GERMAN.BUNKER_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.GERMAN.SLIT_TRENCH_GERMAN_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.GERMAN.SLIT_TRENCH_GERMAN, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.WG_SANDBAG_FENCE_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_02, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_01, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.REINFORCED_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.REINFORCED_BARBED_WIRE_FENCE__CONSTRUCTION__MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.REINFORCED_BARBED_WIRE_TANK_TRAP_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.WG_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.WG_SANDBAG_FENCE__CONSTRUCTION__MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.WG_SANDBAG_FENCE_MP, ITEM_REMOVED)

        Player_SetEntityProductionAvailability(player2, EBP.GERMAN.BUNKER_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.GERMAN.SLIT_TRENCH_GERMAN_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.GERMAN.SLIT_TRENCH_GERMAN, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.WG_SANDBAG_FENCE_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_02, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_01, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.REINFORCED_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.REINFORCED_BARBED_WIRE_FENCE__CONSTRUCTION__MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.REINFORCED_BARBED_WIRE_TANK_TRAP_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.WG_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.WG_SANDBAG_FENCE__CONSTRUCTION__MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.WG_SANDBAG_FENCE_MP, ITEM_REMOVED)
		
end

---------------------------------Victory----------------------------


function Victory()

        Rule_AddDelayedInterval(AdamsDead, 1, 1)

end

function AdamsDead()

        local Control = SGroup_Count(Adams)
        if Control == 0 then
                Util_StartIntel(EVENTS.CathedralVictory)
                Cmd_Retreat(ProtectorLeft)
                Cmd_Retreat(ProtectorRight)
                Cmd_Retreat(CathedralStartGroup)
                Cmd_Retreat(AdamsReinforceLeft)
                Cmd_Retreat(AdamsReinforceMid)
                Cmd_Retreat(AdamsReinforceRight)
                Rule_RemoveMe()
        end
end



---------------------------------Lose----------------------------

function Lose()

        Rule_AddDelayedInterval(KurtLose, 1, 1)
        Rule_AddDelayedInterval(JozefLose, 1, 1)
        Rule_AddDelayedInterval(FriedrichLose, 1, 1)
        Rule_AddDelayedInterval(OttoLose, 1, 1)
        Rule_AddDelayedInterval(HansLose, 1, 1)

        Rule_AddDelayedInterval(StatorLose, 1, 1)
        Rule_AddDelayedInterval(VladilenLose, 1, 1)

end

function KurtLose()

        local Control = SGroup_Count(Kurt)
        if Control == 0 then
                World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
                World_SetPlayerLose(player4)
        end
end

function JozefLose()

        local Control = SGroup_Count(Jozef)
        if Control == 0 then
                World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
                World_SetPlayerLose(player4)
        end
end

function FriedrichLose()

        local Control = SGroup_Count(Friedrich)
        if Control == 0 then
                World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
                World_SetPlayerLose(player4)
        end
end

function OttoLose()

        local Control = SGroup_Count(Otto)
        if Control == 0 then
                World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
                World_SetPlayerLose(player4)
        end
end

function HansLose()

        local Control = SGroup_Count(Hans)
        if Control == 0 then
                World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
                World_SetPlayerLose(player4)
        end
end

function StatorLose()

        local Control = SGroup_Count(Stator)
        if Control == 0 then
                World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
                World_SetPlayerLose(player4)
        end
end

function VladilenLose()

        local Control = SGroup_Count(Vladilen)
        if Control == 0 then
                World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
                World_SetPlayerLose(player4)
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

function First()

local player = World_GetPlayerAt(1)
Modify_PlayerResourceRate(player, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player, RT_Munition, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player, RT_Manpower, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player, RT_Action, 0, MUT_Multiplication)

end

Scar_AddInit(First)

function Second()

local player = World_GetPlayerAt(2)
Modify_PlayerResourceRate(player, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player, RT_Munition, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player, RT_Manpower, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player, RT_Action, 0, MUT_Multiplication)

end

Scar_AddInit(Second)

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
				command = 16,
			},
			--player 2:
			[1] = {
				manpower = 0,
				fuel = 0,
				munition = 0,
				action = 0,
				command = 16,
			},
			--player 3:
			[2] = {
				manpower = 9999,
				fuel = 9999,
				munition = 9999,
				action = 0,
				command = 16,
			},
			--player 4:
			[3] = {
				manpower = 9999,
				fuel = 9999,
				munition = 9999,
				action = 0,
				command = 16,
			},
			[4] = {
				manpower = 9999,
				fuel = 9999,
				munition = 9999,
				action = 0,
				command = 16,
			},
			[5] = {
				manpower = 9999,
				fuel = 9999,
				munition = 9999,
				action = 0,
				command = 16,
			},
			[6] = {
				manpower = 9999,
				fuel = 9999,
				munition = 9999,
				action = 0,
				command = 16,
			},
			[7] = {
				manpower = 9999,
				fuel = 9999,
				munition = 9999,
				action = 0,
				command = 16,
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

        local StartText1 = Util_CreateLocString("Well... this is bad...")
        local StartText2 = Util_CreateLocString("We can't stay here... there is no food here, those corpses don't tell a good story either.")
        local StartText3 = Util_CreateLocString("It isn't hard to break out of here! This camp doesn't even have gates!")
        local StartText4 = Util_CreateLocString("But there are guards... so if you want to see how many bullets you can take before you die be my guest!")
        local StartText5 = Util_CreateLocString("Shhh! Quiet!... The guards are coming...")
        local StartText6 = Util_CreateLocString("You! You're coming with us!")
        local StartText7 = Util_CreateLocString("Hans I think they want you to go with them...")
        local StartText8 = Util_CreateLocString("You speak English?")
        local StartText9 = Util_CreateLocString("My degree was in languages...")
        local StartText10 = Util_CreateLocString("You! Let's go!")
        local StartText11 = Util_CreateLocString("...")
        local StartText12 = Util_CreateLocString("Now what?")
        local StartText13 = Util_CreateLocString("We wait until the guards change shifts and then...")

        local StartText14 = Util_CreateLocString("Hey! You all owe us a favor for this!")
        local StartText15 = Util_CreateLocString("What? Who are you? What are you doing here?")
        local StartText16 = Util_CreateLocString("Who are we? ... Misfits, profiteers, outlaws... call us whatever you like, it does not matter! Ha ha!")
        local StartText17 = Util_CreateLocString("...Walter? Fritz?")
        local StartText18 = Util_CreateLocString("Kurt?! Kurt Bachmann?")
        local StartText19 = Util_CreateLocString("...")
        local StartText20 = Util_CreateLocString("... Another friend from your past Kurt?")
        local StartText21 = Util_CreateLocString("You got that right! Kurt!!! So good to see you... in this place... of all places?")
        local StartText22 = Util_CreateLocString("I hate to cut short this reunion but we would like to get those spare weapons you guys are carrying around?")
        local StartText23 = Util_CreateLocString("Yes, yes. Give my old friend the spare guns... and some ammo.")
        local StartText24 = Util_CreateLocString("...")
        local StartText25 = Util_CreateLocString("Kurt, we need to move. Meet up with us further down the path.")
        local StartText26 = Util_CreateLocString("Where did you get that gun?")
        local StartText27 = Util_CreateLocString("... From the Americans...")
        local StartText28 = Util_CreateLocString("... I dislike these new people...")
        local StartText29 = Util_CreateLocString("Who do you even like Hans?")




        local ForestText1 = Util_CreateLocString("It's Kurt! Hit him now! Go go go!!!")
        local ForestText2 = Util_CreateLocString("What? Who are these people?!")
        local ForestText3 = Util_CreateLocString("They're targeting us! Return fire, return fire!")

        local ForestText4 = Util_CreateLocString("Unmarked assailants targeting you Kurt... What is the meaning of this?")
        local ForestText5 = Util_CreateLocString("I... I don't know. I can't imagine how they would know me. They do look familiar though...")
        local ForestText6 = Util_CreateLocString("I have a feeling we will find answers soon enough...")

        local ForestText7 = Util_CreateLocString("Hey! Hey! Are you well? We heard shooting.")
        local ForestText8 = Util_CreateLocString("Yes, yes... We are fine thank you.")
        local ForestText9 = Util_CreateLocString("Oh that's good. Because I would have really hated for anyone else to be injured just before the assault!")
        local ForestText10 = Util_CreateLocString("Assault?! The enemy has the city entrances covered!")
        local ForestText11 = Util_CreateLocString("Well... That's the order we've been given by the commander. He mentioned additional help might arrive so I guess that's you...")
        local ForestText12 = Util_CreateLocString("Is that so?...")
        local ForestText13 = Util_CreateLocString("Yes, you all look very experienced. That's very good! Stock up quickly and when you're ready we will attack!")
        local ForestText14 = Util_CreateLocString("That officer also looks young enough to be my child... This is a terrible idea... ")
        local ForestText15 = Util_CreateLocString("Even I can tell that...")

        local ForestText16 = Util_CreateLocString("Damn! The bridge is destroyed!")
        local ForestText17 = Util_CreateLocString("The destruction looks recent. Did they have orders to blow up the bridge after they arrive?")
        local ForestText18 = Util_CreateLocString("What purpose would that serve?")
        local ForestText19 = Util_CreateLocString("Yes... This makes very little sense...")
        local ForestText20 = Util_CreateLocString("... Nothing in war ever does...")


        local Text1 = Util_CreateLocString("What do you mean safe? There is barely anyone left in this part of the city... just a skeleton group left...")

        local Text2 = Util_CreateLocString("What the hell?! Run with the intel! NOW!!!")

        local Text3 = Util_CreateLocString("Hey look! There's enemy intelligence here... with their unit positions!")
        local Text4 = Util_CreateLocString("Can you all stand guard while I take a look at these? This intel will be very helpful!")
        local Text5 = Util_CreateLocString("Um... erm... I think they know we are here now!")
        local Text6 = Util_CreateLocString("Just buy me some more time. I'm missing a few reference charts...")

        local Text7 = Util_CreateLocString("Friedrich?! There is more coming you know?")
        local Text8 = Util_CreateLocString("Yes, yes Jozef! Stop your whining and focus on the perimeter please.")
        local Text9 = Util_CreateLocString("Heh... and you thought I was bad...")
        local Text10 = Util_CreateLocString("Believe me I hate you both in equal measure for this! You two are like twins at this shit!")

        local Text11 = Util_CreateLocString("Can we fucking go now? I don't think the Americans will stop attacking...")
        local Text12 = Util_CreateLocString("... They will when they are all dead...")
        local Text13 = Util_CreateLocString("Whoa! ... Somebody give this man a medal for his GOD FUCKING IMPECCABLE LOGIC!!!")
        local Text14 = Util_CreateLocString("Focus Jozef! I'm nearly done!")

        local Text15 = Util_CreateLocString("Enemy artillery incoming! Watch out!")
        local Text16 = Util_CreateLocString("FRIEEEEEEDRICH!!!")
        local Text17 = Util_CreateLocString("Nearly have everything. Come on! Just a little bit more time.")
        local Text18 = Util_CreateLocString("...")

        local Text19 = Util_CreateLocString("Got it! Let's get out of here!")
        local Text20 = Util_CreateLocString("Where are the maps? You did not lose what we came here for did you?!")
        local Text21 = Util_CreateLocString("There were no maps... but flares should be incoming at their positions in three... two... one...")
        local Text22 = Util_CreateLocString("This has to be the worst objective I've ever fought for in this war...")

        local Text23 = Util_CreateLocString("Didn't feel like discussing with us on engaging the enemy Kurt?")

        local Text24 = Util_CreateLocString("Move up! Move up!")
        local Text25 = Util_CreateLocString("Kurt! Take your men and secure that park, I don't want any surprises coming from that side.")

        local Text26 = Util_CreateLocString("Those goddam Krauts are breaking through! Hold this line damn it!!!")
        local Text27 = Util_CreateLocString("Shit! Kraut Stuka bombs. Get outta the house!")

        local Text28 = Util_CreateLocString("We were told there were infiltration units inside the city, but we did not know you would be so effective!")
        local Text29 = Util_CreateLocString("Thank you for the assistance! Amazing work!")
        local Text30 = Util_CreateLocString("Yes... that's very nice... no problem...")
        local Text31 = Util_CreateLocString("Something does not feel right... they were expecting us?")
        local Text32 = Util_CreateLocString("I agree, something isn't right here. My men and I will stay for a while to finish a few things. You go ahead, we will catch up later.")
        local Text33 = Util_CreateLocString("Stay safe Walter... Fritz...")

        local Text34 = Util_CreateLocString("We're under attack! Call in those rearguards now!")

        local Text35 = Util_CreateLocString("First the Soviets and now you asses...")
        local Text36 = Util_CreateLocString("You suckers just won't go down huh?")
        local Text37 = Util_CreateLocString("Not a problem, show these Krauts what you're made of boys!")

        local Text38 = Util_CreateLocString("Go! Go! Go! Move as planned!")

        local Text39 = Util_CreateLocString("Phosphorus barrage now lads! Give 'em one last present from Uncle Sam!")

        local Text40 = Util_CreateLocString("Retreat?! Are you outta your mind! We boys will get the job done! It's the American way, it's the only way!")
        local Text41 = Util_CreateLocString("You need to re-evaluate your situation Adams. What you are contemplating is suicide!!!")
        local Text42 = Util_CreateLocString("We have Axis forces arriving at all entrances to the city, Soviet remnants still left in the ruins and reports of goshdarn infiltrators all over the city!")
        local Text43 = Util_CreateLocString("We will stay and finish the job! Lieutenant Fitzgerald! Head to the train station and organize everyone who is left for defense!")
        local Text44 = Util_CreateLocString("Yes sir!")
        local Text45 = Util_CreateLocString("Listen up you Yankee! Unified command or not, my chaps and I are not just going to dillydally around to get slaughtered for some God forsaken gold!")
        local Text46 = Util_CreateLocString("My men are pulling out! With or without your company! You can keep our tanks in the ruins if your men can use them.")
        local Text47 = Util_CreateLocString("You talk mighty big Colonel Winter. But they'll hear about how you abandoned my brave boys when the time came! Mark my words!")
        local Text48 = Util_CreateLocString("...Assuming you live to talk about it.")

        local Text49 = Util_CreateLocString("Hey look! I recognize that Soviet soldier!")
        local Text50 = Util_CreateLocString("It's one of the soldier we released from the camp.")
        local Text51 = Util_CreateLocString("Well, I guess we should help them... where we can...")

        local Text52 = Util_CreateLocString("Thank you for the help! Do you remember us? We are the men you released from the camp!")
        local Text53 = Util_CreateLocString("Nice German skills, great grammar! Yes we remember you. What are you doing here?")
        local Text54 = Util_CreateLocString("After releasing us we were picked up by the Red Army. They then sent us to this place... Where are you guys going?")
        local Text55 = Util_CreateLocString("We are... heading to Switzerland...")
        local Text56 = Util_CreateLocString("This is not Switzerland...")
        local Text57 = Util_CreateLocString("Truely enlightening...")
        local Text58 = Util_CreateLocString("Allow me to make a proper introduction. My name is Stator Vasnetsov, this is my brother Vladilen. We are grateful to you, for a second time!")
        local Text59 = Util_CreateLocString("Not a problem...")
        local Text60 = Util_CreateLocString("Keep in mind though... the Americans and Commonwealth forces will surely have heard all that shooting.")
        local Text61 = Util_CreateLocString("But the rest of our group is coming. They are some of the others you released from the camp! It will be like a big reunion! Ha ha!")
        local Text62 = Util_CreateLocString("Heh... I guess it would be nice to see some more friendly faces in a place like this.")
        local Text63 = Util_CreateLocString("Excellent! We should wait for them here though. This place is easier to defend than anywhere outside. Agreed?")
        local Text64 = Util_CreateLocString("... I don't believe we have a choice with American and Commonwealth units converging on this place.")
        local Text65 = Util_CreateLocString("Good, good! Brace for incoming. We celebrate with vodka afterwards!")
        local Text66 = Util_CreateLocString("Vodka? What? I could use that right about now...")

        local Text67 = Util_CreateLocString("Nikolai, Yuri, take the right! Viktor, take the lead. Aleksei, behind on left! Move!")
        local Text68 = Util_CreateLocString("Vladilen, Stator, I see you've made old friends. You should try meeting new people for a change.")
        local Text69 = Util_CreateLocString("But looking at this situation I would think new people always try to kill you.")

        local Text70 = Util_CreateLocString("It is good to see you again friends! Reliable help is hard to come by here.")
        local Text71 = Util_CreateLocString("I am afraid we must celebrate with vodka later. The place is still not safe...")
        local Text72 = Util_CreateLocString("Do you know which way to the train station?")
        local Text73 = Util_CreateLocString("I do! Come! Our chances are better if we stick together.")
        local Text74 = Util_CreateLocString("Good fortune. Now we are getting somewhere!")

        local Text75 = Util_CreateLocString("Ah! They know we are here.")
        local Text76 = Util_CreateLocString("This is not good. We cannot move in a group through this cathedral. It's too risky.")
        local Text77 = Util_CreateLocString("You guys should move inside the cathedral. We will defend it from the flank.")

        local Text78 = Util_CreateLocString("You guys clear the cathedral. We'll hold here to prevent anyone hitting us from behind.")
        local Text79 = Util_CreateLocString("Good luck... comrades!")

        local Text80 = Util_CreateLocString("Y'all just can't leave it be can ya?!")
        local Text81 = Util_CreateLocString("No, don't y'all answer that... I suppose this is my fault...")
        local Text82 = Util_CreateLocString("I should have killed y'all on the spot!")
        local Text83 = Util_CreateLocString("But it's al'right. It's not too late for me to repent for my sins.")
        local Text84 = Util_CreateLocString("This is where your journey ends folks...")
        local Text85 = Util_CreateLocString("Major! The Axis have begun their assault on the train station side! They are shelling us to bits!")
        local CathedralText1 = Util_CreateLocString("Well ain't this convenient!")
        local CathedralText2 = Util_CreateLocString("Boys! We gotta take care of this bunch of strays fast.")
        local CathedralText3 = Util_CreateLocString("Get in there boys!!!")

        local Text86 = Util_CreateLocString("Give 'em no ground boys! Look lively!")
        local Text87 = Util_CreateLocString("Ain't no Krauts gonna push us out! Get in there!")
        local Text88 = Util_CreateLocString("Kick their ass boys! Give 'em hell!")
        local Text89 = Util_CreateLocString("Teach 'em a lesson boys! There ain't gonna be a retreat!")
        local Text90 = Util_CreateLocString("Rough 'em up! Nobody gonna push us around!")
        local Text91 = Util_CreateLocString("We ain't going anywhere! Give these Krauts something to remember!")

        local Text92 = Util_CreateLocString("They're retreating! We did it! We actually did it!")
        local Text93 = Util_CreateLocString("Huh... they must be after the gold...")
        local Text94 = Util_CreateLocString("Gold? What gold?")
        local Text95 = Util_CreateLocString("Oh! Urm...")
        local Text96 = Util_CreateLocString("Otto... What gold?")
        local Text97 = Util_CreateLocString("This city... I recognize it now with this cathedral... This is where we kept the gold...")
        local Text98 = Util_CreateLocString("This city was secretly built by the government to act as a hub point for all of our country's treasures. That's why it doesn't appear on any map.")
        local Text99 = Util_CreateLocString("As the Allies closed in we tried to move the treasures kept here. I left with the second last train...")
        local Text100 = Util_CreateLocString("...But the last train with the gold... with so much gold to fill every carriage of the train... It never departed!")
        local Text101 = Util_CreateLocString("This must be why the Soviets, Americans, Commonwealth and our own forces are here! They are all trying to claim the lost gold! This city holds no strategic value otherwise!")
        local Text102 = Util_CreateLocString("What?! Are you saying there enough gold somewhere in this city to fill an entire train?!")
        local Text103 = Util_CreateLocString("Yes! ... My God! ... No wonder this city is such a contested hell hole!")
        local Text104 = Util_CreateLocString("This just made our situation so much more complicated...")

        local Text105 = Util_CreateLocString("Comrades! Reinforcements are here! Let us work together!")
        local Text106 = Util_CreateLocString("We will provide suppressing fire. You eliminate their leader!")


EVENTS.Begin = function()

	CTRL.WAIT()
	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, StartText1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, StartText2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, StartText3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, StartText4)
	CTRL.WAIT()
        Cmd_Move(RifleStartLeft, mkr_rifleleftto)
        Cmd_Move(RifleStartRight, mkr_riflerightto)
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, StartText5)
        Camera_Follow(HansStart)
        Camera_SetZoomDist(18)
	CTRL.WAIT()
	CTRL.Event_Delay(4)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, StartText6)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, StartText7)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, StartText8)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, StartText9)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, StartText10)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, StartText11)
	CTRL.WAIT()
        Cmd_Move(RifleStartLeft, mkr_disappear)
        Cmd_Move(RifleStartRight, mkr_disappear)
        Cmd_Move(HansStart, mkr_disappear)
        Camera_Follow(KurtStart)
        Camera_SetZoomDist(20)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, StartText12)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, StartText13)
        Cmd_Move(Walter, mkr_rescueto)
        Cmd_Move(Fritz, mkr_rescueto)
        Cmd_Move(Jaap, mkr_rescueto)
        Cmd_Move(Jacques, mkr_rescueto)
        Cmd_Move(Giovanni, mkr_rescueto)
        Cmd_Move(Olav, mkr_rescueto)
	CTRL.WAIT()

end

EVENTS.More = function()

	CTRL.WAIT()
        Cmd_Move(Fritz, mkr_fritzstart)
        Cmd_Move(Walter, mkr_walterstart)
        Cmd_Move(Jaap, mkr_jaapstart)
        Cmd_Move(Giovanni, mkr_giovannistart)
        Cmd_Move(Olav, mkr_olavstart)
        Cmd_Move(Jacques, mkr_jacquesstart)
	CTRL.Actor_PlaySpeech(ACTOR.Walter, StartText14)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, StartText15)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Walter, StartText16)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, StartText17)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Walter, StartText18)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Fritz, StartText19)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, StartText20)
        SGroup_WarpToMarker(Hans, mkr_hansspawn)
	CTRL.WAIT()
        Cmd_Move(Hans, mkr_hansstart)
        Camera_Follow(Hans)
        Camera_SetZoomDist(20)
	SGroup_DestroyAllSquads(KurtStart)
	SGroup_DestroyAllSquads(OttoStart)
	SGroup_DestroyAllSquads(FriedrichStart)
	SGroup_DestroyAllSquads(JozefStart)
	CTRL.Actor_PlaySpeech(ACTOR.Walter, StartText21)
	CTRL.WAIT()
        SGroup_WarpToMarker(Kurt, mkr_kurtstart)
        SGroup_WarpToMarker(Otto, mkr_ottostart)
        SGroup_WarpToMarker(Friedrich, mkr_friedrichstart)
        SGroup_WarpToMarker(Jozef, mkr_jozefstart)
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, StartText22)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Walter, StartText23)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, StartText24)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Walter, StartText25)
	CTRL.WAIT()
        Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
        Camera_ResetToDefault()
        Cmd_Move(Walter, mkr_walterto1)
        Cmd_Move(Fritz, mkr_fritzto1)
        Cmd_Move(Jaap, mkr_jaapto1)
        Cmd_Move(Jacques, mkr_jacquesto1)
        Cmd_Move(Olav, mkr_olavto1)
        Cmd_Move(Giovanni, mkr_giovannito1)
        SGroup_SetPlayerOwner(Walter, player3)
        SGroup_SetPlayerOwner(Fritz, player3)
        SGroup_SetPlayerOwner(Jaap, player3)
        SGroup_SetPlayerOwner(Jacques, player3)
        SGroup_SetPlayerOwner(Olav, player3)
        SGroup_SetPlayerOwner(Giovanni, player3)
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, StartText26)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, StartText27)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, StartText28)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, StartText29)
	CTRL.WAIT()
        Blip1 = UI_CreateMinimapBlip(mkr_blip1, 9000, BT_ObjectivePrimary)
        local TextHint1 = Util_CreateLocString("Urban areas have more munitions available, but medical supplies are rare.")
        Hint1 = HintPoint_Add(mkr_hint1, true, TextHint1)
        local TextHint2 = Util_CreateLocString("Not all targets or objectives are critical to the success of the mission. Examine and choose wisely.")
        Hint2 = HintPoint_Add(mkr_hint2, true, TextHint2)
	CTRL.WAIT()

end

EVENTS.GuardChat = function()

	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, Text1)

end

EVENTS.SurpriseChat = function()

	CTRL.Actor_PlaySpeech(ACTOR.American_Paratrooper_01, Text2)

end

EVENTS.HouseWaveOne = function()

	CTRL.WAIT()
	CTRL.Event_Delay(5)
	CTRL.WAIT()
        local TextHint = Util_CreateLocString("Protect Friedrich as he searches for enemy intelligence")
        HintFriedrich = HintPoint_Add(Friedrich, true, TextHint)
        FOW_RevealMarker(mkr_friedrichvision, 9000)
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text4)
	CTRL.WAIT()
        local Direction = Marker_GetDirection(mkr_spawnmid)
        Cmd_Ability(player3, ABILITY.WEST_GERMAN.FLARE_ARTILLERY, mkr_spawnmid, Direction, true)
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text6)
	CTRL.Event_Delay(35)
	CTRL.WAIT()
        SGroup_WarpToMarker(FirstOne, mkr_enemyspawn1)
        SGroup_WarpToMarker(FirstTwo, mkr_enemyspawn2)
	CTRL.WAIT()

end

EVENTS.HouseWaveTwo = function()

	CTRL.WAIT()
	CTRL.Event_Delay(5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text7)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text8)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text9)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text10)
	CTRL.WAIT()
	CTRL.Event_Delay(40)
	CTRL.WAIT()
        SGroup_WarpToMarker(SecondOne, mkr_enemyspawn5)
        SGroup_WarpToMarker(SecondTwo, mkr_enemyspawn4)
        SGroup_WarpToMarker(SecondThree, mkr_enemyspawn1)
	CTRL.WAIT()

end

EVENTS.HouseWaveThree = function()

	CTRL.WAIT()
	CTRL.Event_Delay(5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text11)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text12)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text13)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text14)
	CTRL.WAIT()
	CTRL.Event_Delay(40)
	CTRL.WAIT()
        SGroup_WarpToMarker(ThirdOne, mkr_enemyspawn5)
        SGroup_WarpToMarker(ThirdTwo, mkr_enemyspawn3)
        SGroup_WarpToMarker(ThirdThree, mkr_enemyspawn2)
	CTRL.WAIT()

end

EVENTS.HouseWaveFour = function()

	CTRL.WAIT()
	CTRL.Event_Delay(5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text15)
        local Direction = Marker_GetDirection(mkr_spawnmid)
        Cmd_Ability(player5, ABILITY.AEF.TIME_ON_TARGET_ARTILLERY, mkr_artyone, Direction, true)
        Cmd_Ability(player5, ABILITY.AEF.TIME_ON_TARGET_ARTILLERY, mkr_artytwo, Direction, true)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text16)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text17)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text18)
	CTRL.WAIT()
	CTRL.Event_Delay(40)
	CTRL.WAIT()
        Cmd_Move(OverwatchOne, mkr_overwatchto)
        SGroup_WarpToMarker(FourthOne, mkr_enemyspawn1)
        SGroup_WarpToMarker(FourthTwo, mkr_enemyspawn3)
        SGroup_WarpToMarker(FourthThree, mkr_enemyspawn4)
        SGroup_WarpToMarker(FourthFour, mkr_enemyspawn5)
	CTRL.WAIT()

end

EVENTS.HouseWaveEnd = function()

	CTRL.WAIT()
        local DestroyEntity = EGroup_GetSpawnedEntityAt(RetreatOptional1, 1)
        Entity_Destroy(DestroyEntity)
        FOW_UnRevealMarker(mkr_friedrichvision)
        SGroup_SetPlayerOwner(Friedrich, player1)
        HintPoint_Remove(HintFriedrich)
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text19)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text20)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text21)
        local Direction = Marker_GetDirection(mkr_flaretarget)
        Cmd_Ability(player4, ABILITY.WEST_GERMAN.FLARE_ARTILLERY, mkr_flaretarget, Direction, true)
        FOW_RevealMarker(mkr_flaretarget, 9000)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text22)
	CTRL.WAIT()

end

EVENTS.ParkSequence = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Walter, Text23)
        Cmd_Move(MayorRifles, mkr_mayorriflesto)
        Cmd_Move(MayorRangers, mkr_mayorrangersto)
	CTRL.WAIT()
	CTRL.Event_Delay(5)
	CTRL.WAIT()
        Cmd_Move(MayorMG, mkr_mayormgto)
	CTRL.WAIT()
	CTRL.Event_Delay(5)
	CTRL.WAIT()
        Cmd_Move(MayorAssaults, mkr_mayorassaultsto)
        Cmd_Move(MayorCar, mkr_mayorcarto)
	CTRL.WAIT()

end

EVENTS.ParkContinuation = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Walter, Text24)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Walter, Text25)
	CTRL.WAIT()

end


EVENTS.EntranceSequence = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Paratrooper_01, Text26)
        Cmd_Move(KaiserOfficer, mkr_kaiserofficerto)
        Cmd_Move(KaiserLeft, mkr_kaiserleftto)
        Cmd_Move(KaiserRight, mkr_kaiserrightto)
        Cmd_Move(KaiserTank, mkr_kaisertankto)
        Cmd_Move(KaiserHalftrack, mkr_kaiserhalftrackto)
        Cmd_Move(Walter, mkr_walterto5)
        Cmd_Move(Fritz, mkr_fritzto5)
        Cmd_Move(Jaap, mkr_jaapto5)
        Cmd_Move(Jacques, mkr_jacquesto5)
        Cmd_Move(Olav, mkr_olavto5)
        Cmd_Move(Giovanni, mkr_giovannito5)
	CTRL.WAIT()
	CTRL.Event_Delay(5)
	CTRL.WAIT()
        local Direction = Marker_GetDirection(mkr_firedirection)
        Cmd_Ability(player3, ABILITY.GERMAN.STUKA_INCENDIARY_BOMBS, mkr_firetarget, Direction, true)
	CTRL.Actor_PlaySpeech(ACTOR.American_Paratrooper_01, Text27)
	CTRL.WAIT()
	CTRL.Event_Delay(8)
	CTRL.WAIT()
        local FireEntity1 = EGroup_GetSpawnedEntityAt(EntranceHouse, 1)
        Entity_SetOnFire(EntranceHouse)
        Entity_SetBuildingVisualFireState(FireEntity1, BFS_Smoking)
	CTRL.WAIT()
	CTRL.Event_Delay(5)
	CTRL.WAIT()
        local FireEntity1 = EGroup_GetSpawnedEntityAt(EntranceHouse, 1)
        Entity_SetBuildingVisualFireState(FireEntity1, BFS_Burning)
	CTRL.WAIT()

end

EVENTS.EntranceDialogue = function()

	CTRL.WAIT()
        local TextHint3 = Util_CreateLocString("Enemy three star veteran units are masters of their craft and are the hardest to kill. Engage these enemies with extreme caution.")
        Hint3 = HintPoint_Add(mkr_hint3, true, TextHint3)
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text28)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text29)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text30)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text31)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Walter, Text32)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text33)
	CTRL.WAIT()

end

EVENTS.EntranceSpeech = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, Text34)
	CTRL.WAIT()
	Util_CreateSquads(player5, OfficerRifles, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_officerriflespawn)
	CTRL.WAIT()
        Cmd_Move(OfficerRifles, mkr_entrancecrewto)
	CTRL.WAIT()

end

EVENTS.ForestSurprise = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Assailant, ForestText1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, ForestText2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, ForestText3)
	CTRL.WAIT()

end

EVENTS.ForestDialogue = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, ForestText4)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, ForestText5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, ForestText6)
	CTRL.WAIT()

end

EVENTS.ForestMeet = function()

	CTRL.WAIT()
        SGroup_WarpToMarker(Kurt, mkr_kurtforest)
        SGroup_WarpToMarker(Otto, mkr_ottoforest)
        SGroup_WarpToMarker(Hans, mkr_hansforest)
        SGroup_WarpToMarker(Jozef, mkr_jozefforest)
        SGroup_WarpToMarker(Friedrich, mkr_friedrichforest)
        SGroup_WarpToMarker(ErwinOfficer, mkr_officerforest)
        SGroup_WarpToMarker(ErwinFallLeft, mkr_officerforest)
        SGroup_WarpToMarker(ErwinFallRight, mkr_officerforest)
	CTRL.WAIT()
        SGroup_WarpToMarker(ErwinFailsafe, mkr_erwinfailsafe)
        Cmd_Move(Kurt, mkr_kurtforestto)
        Cmd_Move(Otto, mkr_ottoforestto)
        Cmd_Move(Hans, mkr_hansforestto)
        Cmd_Move(Jozef, mkr_jozefforestto)
        Cmd_Move(Friedrich, mkr_friedrichforestto)
        Cmd_Move(ErwinOfficer, mkr_officerforestto)
        Cmd_Move(ErwinFallLeft, mkr_fallleftforestto)
        Cmd_Move(ErwinFallRight, mkr_fallrightforestto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, ForestText7)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, ForestText8)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, ForestText9)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, ForestText10)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, ForestText11)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, ForestText12)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, ForestText13)
	CTRL.WAIT()
        Cmd_Move(ErwinOfficer, mkr_officerforestend)
        Cmd_Move(ErwinFallLeft, mkr_fallleftforestend)
        Cmd_Move(ErwinFallRight, mkr_fallrightforestend)
        Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
        Camera_ResetToDefault()
	CTRL.WAIT()
	CTRL.Event_Delay(5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, ForestText14)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, ForestText15)
	CTRL.WAIT()

end

EVENTS.SimmonsDialogue = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Simmons, Text35)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Simmons, Text36)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Simmons, Text37)
	CTRL.WAIT()

end

EVENTS.MidCommence = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text38)
	CTRL.WAIT()

end

EVENTS.SimmonsArty = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Simmons, Text39)
	CTRL.WAIT()

end

EVENTS.StreetCinematic = function()

	CTRL.WAIT()
        Blip5 = UI_CreateMinimapBlip(Point5, 9000, BT_ObjectivePrimary)
        UI_DeleteMinimapBlip(Blip4)
        World_GetCurrentInteractionStage()
        World_IncreaseInteractionStage()
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
        Camera_MoveTo(mkr_cameracenter)
        Camera_SetZoomDist(20)
	CTRL.WAIT()
        SGroup_WarpToMarker(FakeWinter, mkr_fakewinterwarp)
        SGroup_WarpToMarker(FakeLeft, mkr_fakeleftwarp)
        SGroup_WarpToMarker(FakeRight, mkr_fakerightwarp)
        SGroup_SetPlayerOwner(FakeAdams, player1)
        SGroup_SetPlayerOwner(FakeFitzgerald, player1)
        SGroup_SetPlayerOwner(FakeRear, player1)
        SGroup_SetPlayerOwner(FakeWinter, player1)
        SGroup_SetPlayerOwner(FakeRight, player1)
        SGroup_SetPlayerOwner(FakeLeft, player1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, Text40)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text41)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text42)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, Text43)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text44)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text45)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text46)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, Text47)
	CTRL.WAIT()
        Cmd_Move(FakeAdams, mkr_engineerfallto)
        Cmd_Move(FakeFitzgerald, mkr_engineerfallto)
        Cmd_Move(FakeRear, mkr_engineerfallto)
        Cmd_Move(FakeWinter, mkr_engineerfallto)
        Cmd_Move(FakeRight, mkr_engineerfallto)
        Cmd_Move(FakeLeft, mkr_engineerfallto)
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text48)
	CTRL.WAIT()
        SGroup_SetPlayerOwner(FakeAdams, player3)
        SGroup_SetPlayerOwner(FakeFitzgerald, player3)
        SGroup_SetPlayerOwner(FakeRear, player3)
        SGroup_SetPlayerOwner(FakeWinter, player3)
        SGroup_SetPlayerOwner(FakeRight, player3)
        SGroup_SetPlayerOwner(FakeLeft, player3)
        Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
        Camera_ResetToDefault()
	CTRL.WAIT()
	CTRL.Event_Delay(2)
	CTRL.WAIT()
        SGroup_DestroyAllSquads(FakeAdams)
        SGroup_DestroyAllSquads(FakeFitzgerald)
        SGroup_DestroyAllSquads(FakeRear)
        SGroup_DestroyAllSquads(FakeWinter)
	CTRL.WAIT()

end

EVENTS.CinemaDialogue = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text49)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text50)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text51)
	CTRL.WAIT()

end

EVENTS.CinemaOne = function()

	CTRL.WAIT()
        SGroup_WarpToMarker(Kurt, mkr_cinemagroupwarp)
        SGroup_WarpToMarker(Otto, mkr_cinemagroupwarp)
        SGroup_WarpToMarker(Friedrich, mkr_cinemagroupwarp)
        SGroup_WarpToMarker(Jozef, mkr_cinemagroupwarp)
        SGroup_WarpToMarker(Hans, mkr_cinemagroupwarp)
	CTRL.WAIT()
        Cmd_Move(Vladilen, mkr_cinemavladilento2)
        Cmd_Move(Kurt, mkr_cinemakurtto)
        Cmd_Move(Otto, mkr_cinemaottoto)
        Cmd_Move(Friedrich, mkr_cinemafriedrichto)
        Cmd_Move(Jozef, mkr_cinemajozefto)
        Cmd_Move(Hans, mkr_cinemahansto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, Text52)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text53)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, Text54)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text55)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, Text56)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text57)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, Text58)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text59)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, Text60)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, Text61)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text62)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, Text63)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text64)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, Text65)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text66)
	CTRL.WAIT()
        SGroup_SetInvulnerable(Vladilen, false)
        SGroup_SetInvulnerable(Stator, false)
        Cmd_Move(Stator, mkr_cinemasovietto1)
        Cmd_Move(Vladilen, mkr_cinemasovietto2)
        Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
        Camera_ResetToDefault()
	CTRL.Event_Delay(15)
	CTRL.WAIT()
        SGroup_WarpToMarker(CinemaOneRanger, mkr_cinemaspawnbot)
        SGroup_WarpToMarker(CinemaOneRifle, mkr_cinemaspawnbot)
        SGroup_WarpToMarker(CinemaOneEngineer, mkr_cinemaspawntop)
	CTRL.WAIT()
	Cmd_Move(CinemaOneRanger, mkr_cinemato3)
	Cmd_Move(CinemaOneRifle, mkr_cinemato1)
	Cmd_Move(CinemaOneEngineer, mkr_cinemato4)
	CTRL.WAIT()

end

EVENTS.CinemaTwo = function()

	CTRL.WAIT()
        Cmd_Move(Stator, mkr_cinemasovietto1)
	CTRL.Event_Delay(15)
	CTRL.WAIT()
        SGroup_WarpToMarker(CinemaTwoPara, mkr_cinemaspawnbot)
        SGroup_WarpToMarker(CinemaTwoRifle, mkr_cinemaspawnmid)
        SGroup_WarpToMarker(CinemaTwoEngineerOne, mkr_cinemaspawnbot)
        SGroup_WarpToMarker(CinemaTwoEngineerTwo, mkr_cinemaspawnmid)
	CTRL.WAIT()
	Cmd_Move(CinemaTwoPara, mkr_cinemato1)
	Cmd_Move(CinemaTwoRifle, mkr_cinemato3)
	Cmd_Move(CinemaTwoEngineerOne, mkr_cinemato6)
	Cmd_Move(CinemaTwoEngineerTwo, mkr_cinemato5)
	CTRL.WAIT()

end

EVENTS.CinemaThree = function()

	CTRL.WAIT()
        Cmd_Move(Stator, mkr_cinemasovietto1)
	CTRL.Event_Delay(15)
	CTRL.WAIT()
        SGroup_WarpToMarker(CinemaThreeRanger, mkr_cinemaspawntop)
        SGroup_WarpToMarker(CinemaThreeParaOne, mkr_cinemaspawnmid)
        SGroup_WarpToMarker(CinemaThreeParaTwo, mkr_cinemaspawnbot)
        SGroup_WarpToMarker(CinemaThreeMedic, mkr_cinemaspawnside)
        SGroup_WarpToMarker(CinemaThreeRifle, mkr_cinemaspawnside)
        SGroup_WarpToMarker(CinemaThreeRear, mkr_cinemaspawnside)
	CTRL.WAIT()
	Cmd_Move(CinemaThreeRanger, mkr_cinemato4)
	Cmd_Move(CinemaThreeParaOne, mkr_cinemato3)
	Cmd_Move(CinemaThreeParaTwo, mkr_cinemato1)
	Cmd_Move(CinemaThreeMedic, mkr_cinemato2)
	Cmd_Move(CinemaThreeRifle, mkr_cinemato2)
	Cmd_Move(CinemaThreeRear, mkr_cinemato8)
	CTRL.WAIT()

end

EVENTS.CinemaFour = function()

	CTRL.WAIT()
        Cmd_Move(Stator, mkr_cinemastatorto)
        Cmd_Move(Vladilen, mkr_cinemavladilento)
	CTRL.WAIT()
	CTRL.Event_Delay(20)
	CTRL.WAIT()
        SGroup_WarpToMarker(CinemaFourEngineerOne, mkr_cinemaspawnside)
        SGroup_WarpToMarker(CinemaFourEngineerTwo, mkr_cinemaspawnside)
        SGroup_WarpToMarker(CinemaFourPara, mkr_cinemaspawnside)
        SGroup_WarpToMarker(CinemaFourRear, mkr_cinemaspawnside)
        SGroup_WarpToMarker(CinemaFourRifle, mkr_cinemaspawnside)
	CTRL.WAIT()
	Cmd_Move(CinemaFourEngineerOne, mkr_cinematransferleft)
	Cmd_Move(CinemaFourEngineerTwo, mkr_cinematransferright)
	Cmd_Move(CinemaFourPara, mkr_cinemato9)
	Cmd_Move(CinemaFourRear, mkr_cinemato2)
	Cmd_Move(CinemaFourRifle, mkr_cinemato8)
	CTRL.WAIT()

end

EVENTS.CinemaFive = function()

	CTRL.WAIT()
        Cmd_Move(Stator, mkr_cinemastatorto)
	CTRL.WAIT()
	CTRL.Event_Delay(15)
	CTRL.WAIT()
        SGroup_WarpToMarker(CinemaFiveGun, mkr_cinemaspawnside)
        SGroup_WarpToMarker(CinemaFiveRanger, mkr_cinemarangersalternative)
        SGroup_WarpToMarker(CinemaFiveEngineer, mkr_cinemaspawnside)
        SGroup_WarpToMarker(CinemaFiveMedic, mkr_cinemaspawnside)
        SGroup_WarpToMarker(CinemaFivePara, mkr_cinemaspawnside)
        SGroup_WarpToMarker(CinemaFiveRifle, mkr_cinemaspawnside)
	CTRL.WAIT()
	Cmd_Move(CinemaFiveGun, mkr_cinemato9)
	Cmd_Move(CinemaFiveRanger, mkr_cinematransferleft)
	Cmd_Move(CinemaFiveEngineer, mkr_cinematransferright)
	Cmd_Move(CinemaFiveMedic, mkr_cinematransferright)
	Cmd_Move(CinemaFivePara, mkr_cinemato8)
	Cmd_Move(CinemaFiveRifle, mkr_cinemato12)
	CTRL.WAIT()
	CTRL.Event_Delay(15)
	CTRL.WAIT()
        SGroup_WarpToMarker(Aleksei, mkr_cinemasovietspawn)
        SGroup_WarpToMarker(Nikolai, mkr_cinemasovietspawn)
        SGroup_WarpToMarker(Yuri, mkr_cinemasovietspawn)
        SGroup_WarpToMarker(Viktor, mkr_cinemasovietspawn)
        SGroup_WarpToMarker(Dmitriy, mkr_cinemasovietspawn)
	CTRL.WAIT()
	Cmd_Move(Aleksei, mkr_cinemaalekseito)
	Cmd_Move(Nikolai, mkr_cinemanikolaito)
	Cmd_Move(Yuri, mkr_cinemayurito)
	Cmd_Move(Viktor, mkr_cinemaviktorto)
	Cmd_Move(Dmitriy, mkr_cinemadmitriyto)
	CTRL.WAIT()

end

EVENTS.CinemaArrival = function()

	CTRL.WAIT()
        SGroup_SetPlayerOwner(Aleksei, player4)
        SGroup_SetPlayerOwner(Nikolai, player4)
        SGroup_SetPlayerOwner(Yuri, player4)
        SGroup_SetPlayerOwner(Dmitriy, player4)
        SGroup_SetPlayerOwner(Viktor, player4)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text67)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text68)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text69)
	CTRL.WAIT()

end

EVENTS.CinemaEnding = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text70)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text71)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text72)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text73)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text74)
        Blip6 = UI_CreateMinimapBlip(Adams, 9000, BT_ObjectivePrimary)
        UI_DeleteMinimapBlip(Blip5)
        World_GetCurrentInteractionStage()
        World_IncreaseInteractionStage()
	Cmd_Move(Aleksei, mkr_alekseistreet)
	Cmd_Move(Nikolai, mkr_nikolaistreet)
	Cmd_Move(Yuri, mkr_yuristreet)
	Cmd_Move(Viktor, mkr_viktorstreet)
	Cmd_Move(Dmitriy, mkr_dmitriystreet)
	Cmd_Move(Vladilen, mkr_vladilenstreet)
	Cmd_Move(Stator, mkr_statorstreet)
	CTRL.WAIT()

end

EVENTS.FrontOpening = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text75)
	Cmd_Move(Aleksei, mkr_alekseistreetmove)
	Cmd_Move(Nikolai, mkr_nikolaistreetmove)
	Cmd_Move(Yuri, mkr_yuristreetmove)
	Cmd_Move(Viktor, mkr_viktorstreetmove)
	Cmd_Move(Dmitriy, mkr_dmitriystreetmove)
	Cmd_Move(Vladilen, mkr_vladilenstreetmove)
	Cmd_Move(Stator, mkr_statorstreetmove)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text76)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text77)
	CTRL.WAIT()

end

EVENTS.FlankEnding = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text78)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text79)
	CTRL.WAIT()

end

EVENTS.CathedralFinale = function()

	CTRL.WAIT()
        FOW_RevealMarker(mkr_cathedralsight1, 9000)
        FOW_RevealMarker(mkr_cathedralsight2, 9000)
        SGroup_WarpToMarker(Adams, mkr_adamswarpto)
        SGroup_WarpToMarker(ProtectorLeft, mkr_protectorleftwarpto)
        SGroup_WarpToMarker(ProtectorRight, mkr_protectorrightwarpto)
	Cmd_Move(Kurt, mkr_cathedralrally)
	Cmd_Move(Otto, mkr_cathedralrally)
	Cmd_Move(Hans, mkr_cathedralrally)
	Cmd_Move(Friedrich, mkr_cathedralrally)
	Cmd_Move(Jozef, mkr_cathedralrally)
        SGroup_SetPlayerOwner(Adams, player1)
        SGroup_SetPlayerOwner(ProtectorLeft, player1)
        SGroup_SetPlayerOwner(ProtectorRight, player1)
        SGroup_SetPlayerOwner(AdamsMedic, player1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, Text80)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, Text81)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, Text82)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, Text83)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, Text84)
	Cmd_Move(ProtectorLeft, mkr_protectorleftwarpto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Protector, Text85)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, CathedralText1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, CathedralText2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, CathedralText3)
        SGroup_Kill(VisualControl)
	CTRL.WAIT()
        SGroup_SetPlayerOwner(Adams, player5)
        SGroup_SetPlayerOwner(ProtectorLeft, player5)
        SGroup_SetPlayerOwner(ProtectorRight, player5)
        SGroup_SetPlayerOwner(AdamsMedic, player5)
	Cmd_Move(Adams, mkr_adamsto)
	Cmd_Move(ProtectorLeft, mkr_protectorleftto)
	Cmd_Move(ProtectorRight, mkr_protectorrightto)
        Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
        Camera_ResetToDefault()
	CTRL.WAIT()
	Cmd_Move(CathedralPara, mkr_cathedralparato)
	Cmd_Move(CathedralRifles, mkr_cathedralriflesto)
	Cmd_Move(CathedralRanger, mkr_cathedralrangerto)
	Cmd_Move(CathedralEngineers, mkr_cathedralengineersto)
	Cmd_Move(CathedralMedic, mkr_cathedralmedicto)
	Cmd_Move(CathedralTruck, mkr_cathedraltruckto)
	CTRL.WAIT()
	CTRL.Event_Delay(40)
	CTRL.WAIT()
	Cmd_Move(Vladilen, mkr_vladilenstop)
	Cmd_Move(Stator, mkr_statorstop)
	CTRL.WAIT()

end

EVENTS.SovietsArrive = function()

	CTRL.WAIT()
        SGroup_SetInvulnerable(Vladilen, false)
        SGroup_SetInvulnerable(Stator, false)
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, Text105)
        SGroup_FacePosition(Stator, mkr_reinforcethree)
        SGroup_FacePosition(Vladilen, mkr_reinforcethree)
        local TextHint10 = Util_CreateLocString("Stator and Vladilen are now vulnerable to enemy fire. You will lose if they are killed")
        CathedralHint = HintPoint_Add(mkr_statorstop, true, TextHint10)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, Text106)
	CTRL.WAIT()
	CTRL.Event_Delay(40)
	CTRL.WAIT()
        HintPoint_Remove(CathedralHint)
	CTRL.WAIT()

end



EVENTS.AdamsOne = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, Text86)
	CTRL.WAIT()
        Util_CreateSquads(player5, AdamsReinforceLeft, SBP.AEF.PARATROOPER_SQUAD_MP, mkr_adamsspawnleft)
        Util_CreateSquads(player5, AdamsReinforceMid, SBP.AEF.ASSAULT_ENGINEER_SQUAD_MP, mkr_adamsspawnleft)
        Util_CreateSquads(player5, AdamsReinforceRight, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_adamsspawnright)
	CTRL.WAIT()
	Cmd_Move(AdamsReinforceLeft, mkr_cathedralparato)
	Cmd_Move(AdamsReinforceMid, mkr_reinforcethree)
	Cmd_Move(AdamsReinforceRight, mkr_reinforcefive)
	CTRL.WAIT()

end

EVENTS.AdamsTwo = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, Text87)
	CTRL.WAIT()
        Util_CreateSquads(player5, AdamsReinforceLeft, SBP.AEF.REAR_ECHELON_SQUAD_MP, mkr_adamsspawnleft)
        Util_CreateSquads(player5, AdamsReinforceMid, SBP.AEF.RANGER_SQUAD_MP, mkr_adamsspawnleft)
        Util_CreateSquads(player5, AdamsReinforceRight, SBP.AEF.ASSAULT_ENGINEER_SQUAD_MP, mkr_adamsspawnright)
	CTRL.WAIT()
	Cmd_Move(AdamsReinforceLeft, mkr_reinforcetwo)
	Cmd_Move(AdamsReinforceMid, mkr_reinforceeight)
	Cmd_Move(AdamsReinforceRight, mkr_cathedralengineersto)
	CTRL.WAIT()

end

EVENTS.AdamsThree = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, Text88)
	CTRL.WAIT()
        Util_CreateSquads(player5, AdamsReinforceLeft, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_adamsspawnleft)
        Util_CreateSquads(player5, AdamsReinforceMid, SBP.AEF.PARATROOPER_SQUAD_MP, mkr_adamsspawnleft)
        Util_CreateSquads(player5, AdamsReinforceRight, SBP.AEF.REAR_ECHELON_SQUAD_MP, mkr_adamsspawnright)
	CTRL.WAIT()
	Cmd_Move(AdamsReinforceLeft, mkr_reinforceseven)
	Cmd_Move(AdamsReinforceMid, mkr_reinforceone)
	Cmd_Move(AdamsReinforceRight, mkr_reinforcefour)
	CTRL.WAIT()

end

EVENTS.AdamsFour = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, Text89)
	CTRL.WAIT()
        Util_CreateSquads(player5, AdamsReinforceLeft, SBP.AEF.ASSAULT_ENGINEER_SQUAD_MP, mkr_adamsspawnleft)
        Util_CreateSquads(player5, AdamsReinforceMid, SBP.AEF.PARATROOPER_SQUAD_MP, mkr_adamsspawnleft)
        Util_CreateSquads(player5, AdamsReinforceRight, SBP.AEF.RANGER_SQUAD_MP, mkr_adamsspawnright)
	CTRL.WAIT()
	Cmd_Move(AdamsReinforceLeft, mkr_cathedralrangerto)
	Cmd_Move(AdamsReinforceMid, mkr_reinforceone)
	Cmd_Move(AdamsReinforceRight, mkr_cathedralmedicto)
	CTRL.WAIT()

end

EVENTS.AdamsFive = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, Text90)
	CTRL.WAIT()
        Util_CreateSquads(player5, AdamsReinforceLeft, SBP.AEF.ASSAULT_ENGINEER_SQUAD_MP, mkr_adamsspawnleft)
        Util_CreateSquads(player5, AdamsReinforceMid, SBP.AEF.RANGER_SQUAD_MP, mkr_adamsspawnleft)
        Util_CreateSquads(player5, AdamsReinforceRight, SBP.AEF.ASSAULT_ENGINEER_SQUAD_MP, mkr_adamsspawnright)
	CTRL.WAIT()
	Cmd_Move(AdamsReinforceLeft, mkr_cathedralrangerto)
	Cmd_Move(AdamsReinforceMid, mkr_reinforcethree)
	Cmd_Move(AdamsReinforceRight, mkr_reinforcefive)
	CTRL.WAIT()

end

EVENTS.AdamsSix = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, Text91)
	CTRL.WAIT()
        Util_CreateSquads(player5, AdamsReinforceLeft, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_adamsspawnleft)
        Util_CreateSquads(player5, AdamsReinforceMid, SBP.AEF.REAR_ECHELON_SQUAD_MP, mkr_adamsspawnleft)
        Util_CreateSquads(player5, AdamsReinforceRight, SBP.AEF.PARATROOPER_SQUAD_MP, mkr_adamsspawnright)
	CTRL.WAIT()
	Cmd_Move(AdamsReinforceLeft, mkr_reinforceseven)
	Cmd_Move(AdamsReinforceMid, mkr_reinforcesix)
	Cmd_Move(AdamsReinforceRight, mkr_cathedralriflesto)
	CTRL.WAIT()

end

EVENTS.CathedralVictory = function()

	CTRL.WAIT()
        SGroup_WarpToMarker(Kurt, mkr_kurtvictorywarp)
        SGroup_WarpToMarker(Otto, mkr_ottovictorywarp)
        SGroup_SetInvulnerable(Kurt, true)
        SGroup_SetInvulnerable(Otto, true)
        SGroup_SetInvulnerable(Hans, true)
        SGroup_SetInvulnerable(Friedrich, true)
        SGroup_SetInvulnerable(Jozef, true)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text92)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text93)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text94)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text95)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text96)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text97)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text98)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text99)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text100)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text101)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text102)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text103)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text104)
	CTRL.WAIT()
        Game_EndSP(true)
	CTRL.WAIT()

end

EVENTS.BridgeTalk = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, ForestText16)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, ForestText17)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, ForestText18)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, ForestText19)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, ForestText20)
	CTRL.WAIT()

end