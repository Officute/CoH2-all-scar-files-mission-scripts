-- This following code contained in this file is copyright to Steven McClosky, Mike D, Katarina Sanaa, Lewin Idaho and Kasper McMahon. Do not re-use without express permission from all copyright holders, this work is partially protected by the Digital Millenium Copyright Act (DCMA), U.S.C, Title 17.

import("ScarUtil.scar")
import("Fatalities/Fatalities.scar")
import("Prototype/WorldEntityCollector.scar")
import("Prototype/SpecialAEFunctions.scar")
import("PrintOnScreen.scar")

function OnGameSetup()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        World_EnableSharedLineOfSight(player1, player2, false)
        World_EnableSharedLineOfSight(player1, player3, true)

        World_SetIceHealingRate(51)

end

Scar_AddInit(OnGameSetup)

function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

function OnInit()

        Custom()

        CustomFailsafe()

        Cinematic()

        Settings()

        Hints()

        Win()

        Lose()

        Rule_AddDelayedInterval(CommunityEgg, 1, 1)

        Rule_AddDelayedInterval(EggReward, 1, 1)

        Rule_AddDelayedInterval(ConscriptEgg, 1, 1)

        StartEvent()

        ChurchEvent()

        VillageEvent()

        CampEvent()

        MichaelEvent()

        BaseOne()

        BaseTwo()

        TrenchEvent()

        BaseThree()

        FinaleEvent()

        EliteHint()

        Elites()

        Officers()

        Upgrade()

        BuildingRestrict()


end

Scar_AddInit(OnInit)

function Custom()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        AI_EnableAll(false)
        UI_SetAllowLoadAndSave(false)
        Modify_DisableHold(BurningHouse, true)
        local ControlEntity = SGroup_GetSpawnedSquadAt(Hans, 1)
        Squad_GiveSlotItem(ControlEntity, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_NO_PRONE_MP)

        SGroup_SetInvulnerable(Hans, true)
        SGroup_SetInvulnerable(Jaksa, true)

        Command_SquadEntityLoad(player4, HousePenals, SCMD_Load, Garrison, false, true)

        Blip1 = UI_CreateMinimapBlip(mkr_vulnerable, 9000, BT_ObjectivePrimary)

end

function CustomFailsafe()

        AI_EnableAll(false)

end

function Cinematic()

	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
        Camera_Follow(Kurt)
        Camera_SetZoomDist(10)
        Util_StartIntel(EVENTS.Start)

end

function Settings()

        EGroup_SetInvulnerable(Church, true)
        Cmd_SquadPatrolMarker(PatrolLeft, mkr_guardpatrolleft)
        Cmd_SquadPatrolMarker(PatrolRight, mkr_guardpatrolright)
        Cmd_SquadPatrolMarker(PatrolCenter, mkr_conspatrolcenter)

end

--------------------------------Hints----------------------------

function Hints()

        local TextHint1 = Util_CreateLocString("The difficulty of the maps is now much higher than in the first map. It is expected that multiple playthroughs may be necessary to complete this map")
        local TextHint2 = Util_CreateLocString("There is no save or load feature. Mission failure will result in a completely new playthrough. Play carefully as the cost of failure is now much higher")
        local TextHint3 = Util_CreateLocString("If you are having difficulty completing the map, share your experiences with other players and they may be able to help you. Walkthroughs and videos on this map will be available online and its Steam Workshop page")
        local TextHint4 = Util_CreateLocString("Provided you have sufficient munitions. Friedrich has the capacity to improve his anti-infantry or anti-tank capabilities with his weapon upgrades")

        Hint1 = HintPoint_Add(mkr_hint1, true, TextHint1)
        Hint2 = HintPoint_Add(mkr_hint2, true, TextHint2)
        Hint3 = HintPoint_Add(mkr_hint3, true, TextHint3)
        Hint4 = HintPoint_Add(mkr_hintfriedrich, true, TextHint4)

end

---------------------------------Win-----------------------------

function Win()

        Rule_AddDelayedInterval(IgorDead, 1, 1)

end

function IgorDead()

        local Control = SGroup_Count(Igor)
        if Control == 0 then
                Util_StartIntel(EVENTS.Ending)
                Rule_RemoveMe()
        end
end

---------------------------------Lose----------------------------

function Lose()

        Rule_AddDelayedInterval(MichaelLose, 1, 1)
        Rule_AddDelayedInterval(KurtLose, 1, 1)
        Rule_AddDelayedInterval(AntonLose, 1, 1)
        Rule_AddDelayedInterval(FriedrichLose, 1, 1)
        Rule_AddDelayedInterval(OttoLose, 1, 1)
        Rule_AddDelayedInterval(UlrichLose, 1, 1)
        Rule_AddDelayedInterval(JaksaLose, 1, 1)
        Rule_AddDelayedInterval(HansLose, 1, 1)

end

function MichaelLose()

        local Control = SGroup_Count(Michael)
        if Control == 0 then
                Game_EndSP(false)
        end
end

function KurtLose()

        local Control = SGroup_Count(Kurt)
        if Control == 0 then
                Game_EndSP(false)
        end
end

function AntonLose()

        local Control1 = SGroup_Count(Anton)
        local Control2 = SGroup_Count(AntonDeathControl)
        if Control1 == 0 and Control2 == 1 then
                Game_EndSP(false)
        end
end

function FriedrichLose()

        local Control = SGroup_Count(Friedrich)
        if Control == 0 then
                Game_EndSP(false)
        end
end

function OttoLose()

        local Control = SGroup_Count(Otto)
        if Control == 0 then
                Game_EndSP(false)
        end
end

function UlrichLose()

        local Control = SGroup_Count(Ulrich)
        if Control == 0 then
                Game_EndSP(false)
        end
end

function JaksaLose()

        local Control = SGroup_Count(Jaksa)
        if Control == 0 then
                Game_EndSP(false)
        end
end

function HansLose()

        local Control = SGroup_Count(Hans)
        if Control == 0 then
                Game_EndSP(false)
        end
end

function CommunityEgg()

        local CommunityHint1 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 6 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Lies)")
        local CommunityHint2 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 6 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Secret)")
        local CommunityHint3 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 6 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Third)")
        local CommunityHint4 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 6 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Behind)")
        local CommunityHint5 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 6 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Wings)")
        local CommunityHint6 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 6 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Angle's)")

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_activateegg, false)
        local Random = World_GetRand(1, 6)
        if Control == true then
                Rule_RemoveMe()
                if Random == 1 then
                        HintMouseover_Add(CommunityHint1, EasterEgg, 5, true)
                elseif Random == 2 then
                        HintMouseover_Add(CommunityHint2, EasterEgg, 5, true)
                elseif Random == 3 then
                        HintMouseover_Add(CommunityHint3, EasterEgg, 5, true)
                elseif Random == 4 then
                        HintMouseover_Add(CommunityHint4, EasterEgg, 5, true)
                elseif Random == 5 then
                        HintMouseover_Add(CommunityHint5, EasterEgg, 5, true)
                elseif Random == 6 then
                        HintMouseover_Add(CommunityHint6, EasterEgg, 5, true)
                end
        end
end

function EggReward()

        local EggText = Util_CreateLocString("A note found in the soldier's frozen hand reads: 'Target continue to press through Soviet lines. Exceeding all expectations. Target will likely encounter American forces if proceeding at current pace and direction. Advise immediate termination of target with all available assets. End.")

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_secreteggtrigger, false)
        if Control == true then
                HintMouseover_Add(EggText, DeadGerman, 5, true)
        end
end

function ConscriptEgg()

        local Text = Util_CreateLocString("So you've found me! I guess I should say something useful as a reward right? Um... let's see... did you know that if you kill the Soviet officer located within the big overwatch base near here, you will have an easier time free of Soviet bombing runs in the finale area? See? I am helpful!")

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_eggconstrigger, false)
        if Control == true then
                HintMouseover_Add(Text, EggCons, 5, true)
        end
end

---------------------------Start Event------------------------

function StartEvent()

        Rule_AddDelayedInterval(AntonWarp, 1, 1)
        Rule_AddDelayedInterval(AntonChase, 1, 1)
        Rule_AddDelayedInterval(RestRetreat, 1, 1)
        Rule_AddDelayedInterval(PenalsMoveTwo, 1, 1)
        Rule_AddDelayedInterval(Escape, 1, 1)
        Rule_AddDelayedInterval(Bridge, 1, 1)
        Rule_AddDelayedInterval(Vehicle, 1, 1)
        Rule_AddDelayedInterval(ShockMove, 1, 1)
        Rule_AddDelayedInterval(Vulnerable, 1, 1)
        Rule_AddDelayedInterval(Expand, 1, 1)

end

function AntonWarp()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_antonwarptrigger, false)
        if Control == true then
                SGroup_WarpToMarker(Anton, mkr_antonwarpto)
                SGroup_SetWorldOwned(Anton)
                SGroup_SetInvulnerable(Anton, true)
                SGroup_SetInvulnerable(Friedrich, true)
                SGroup_SetInvulnerable(Ulrich, true)
                SGroup_SetInvulnerable(Otto, true)
                Rule_RemoveMe()
        end
end

function AntonChase()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_antonchasetrigger, false)
        if Control == true then
                Util_StartIntel(EVENTS.Run)
                World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                SGroup_SetPlayerOwner(Anton, player2)
                Cmd_Move(Chasers, mkr_chasersto)
                Rule_AddOneShot(AntonRetreat, 1)
                Rule_RemoveMe()
        end
end

function AntonRetreat()

        Cmd_Retreat(Anton)

end

function RestRetreat()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player4, mkr_chaserstrigger, false)
        if Control == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat2, 1)
                local DestroyEntity = EGroup_GetSpawnedEntityAt(Retreat1, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity)
                Cmd_Retreat(Ulrich)
                Cmd_Retreat(Friedrich)
                Cmd_Retreat(Otto)
	        Util_CreateSquads(player4, PenalSpawns, SBP.SOVIET.PENAL_BATTALION_MP, mkr_antonwarptrigger)
	        Util_CreateSquads(player4, PenalSpawns, SBP.SOVIET.PENAL_BATTALION_MP, mkr_antonwarptrigger)
	        Util_CreateSquads(player4, PenalSpawnsTwo, SBP.SOVIET.PENAL_BATTALION_MP, mkr_penalspawn)
	        Util_CreateSquads(player4, PenalSpawnsTwo, SBP.SOVIET.PENAL_BATTALION_MP, mkr_penalspawn)
                Rule_AddOneShot(PenalsMove, 1)
                Util_StartIntel(EVENTS.Others)
                Rule_RemoveMe()
        end

end

function PenalsMove()

        Cmd_Move(PenalSpawns, mkr_penalsto1)

end

function PenalsMoveTwo()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_penalstrigger, false)
        if Control == true then
                Cmd_Move(PenalSpawnsTwo, mkr_penalsto2)
                SGroup_SetInvulnerable(Kurt, true)
                Rule_RemoveMe()
        end
end

function Escape()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_escape, false)
        if Control == true then
                Util_StartIntel(EVENTS.Escape)
                Rule_RemoveMe()
        end
end

function Bridge()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_bombertrigger, false)
        if Control == true then
                local Direction = Marker_GetDirection(mkr_bridgedirection)
                Cmd_Ability(player4, ABILITY.SOVIET.IL_2_PRECISION_BOMB_STRIKE, mkr_bridge, Direction, true)
                Rule_RemoveMe()
        end
end


function Vehicle()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_soviettanktrigger, false)
        if Control == true then
                Cmd_Move(SovietTank, mkr_soviettankto)
                Rule_RemoveMe()
        end
end

function ShockMove()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_shockconstrigger, false)
        if Control == true then
                Cmd_Move(ShockCons, mkr_shockconsto)
                Rule_RemoveMe()
        end
end

function Vulnerable()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_vulnerable, false)
        if Control == true then
                SGroup_SetInvulnerable(Kurt, false)
                SGroup_SetInvulnerable(Anton, false)
                SGroup_SetInvulnerable(Friedrich, false)
                SGroup_SetInvulnerable(Ulrich, false)
                SGroup_SetInvulnerable(Otto, false)
                SGroup_SetPlayerOwner(Anton, player1)
                SGroup_SetPlayerOwner(Friedrich, player1)
                SGroup_SetPlayerOwner(Ulrich, player1)
                SGroup_SetPlayerOwner(Otto, player1)
                Blip2 = UI_CreateMinimapBlip(Point3, 9000, BT_ObjectivePrimary)
                UI_DeleteMinimapBlip(Blip1)
                Rule_RemoveMe()
        end
end

function Expand()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_vulnerable, false)
        if Control == true then
                World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                Rule_RemoveMe()
        end
end

------------------------------Church Event-----------------------------

function ChurchEvent()

        Rule_AddDelayedInterval(PointThree, 1, 1)

end

function PointThree()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local PointOne = EGroup_IsCapturedByPlayer(Point3, player1, false)
        if PointOne == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat3, 1)
                local DestroyEntity = EGroup_GetSpawnedEntityAt(Retreat2, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity)
                Cmd_Move(CounterShock, mkr_countershockto)
                Cmd_Move(CounterPenalOne, mkr_counterpenaloneto)
                Cmd_AttackMove(CounterPenalTwo, mkr_counterpenaltwoto)
                World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                Blip3 = UI_CreateMinimapBlip(Point4, 9000, BT_ObjectivePrimary)
                UI_DeleteMinimapBlip(Blip2)
                HQSatchel()
                Rule_RemoveMe()
        end

end

function HQSatchel()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local PointOne = EGroup_IsCapturedByPlayer(Point2, player1, false)
        if PointOne == true then
                Command_SquadSquadAbility(player4, CounterPenalOne, Otto, ABILITY.SOVIET.SATCHEL_CHARGE_THROW_ABILITY_MP, true, false)
        end
end

-------------------------------Village Event---------------------------------

function VillageEvent()

        Rule_AddDelayedInterval(PointFour, 1, 1)
        Rule_AddDelayedInterval(VillageEnter, 1, 1)
        Rule_AddDelayedInterval(Ambush, 1, 1)
        Rule_AddDelayedInterval(OneTurn, 1, 1)
        Rule_AddDelayedInterval(TwoTurn, 1, 1)
        Rule_AddDelayedInterval(ThreeTurn, 1, 1)
        Rule_AddDelayedInterval(FourTurn, 1, 1)
        Rule_AddDelayedInterval(AmbushEnd, 1, 1)

end


function PointFour()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local PointOne = EGroup_IsCapturedByPlayer(Point4, player1, false)
        if PointOne == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat4, 1)
                local DestroyEntity = EGroup_GetSpawnedEntityAt(Retreat3, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity)
                Blip4 = UI_CreateMinimapBlip(Jaksa, 9000, BT_ObjectivePrimary)
                UI_DeleteMinimapBlip(Blip3)
                World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                Rule_RemoveMe()
        end
end

function VillageEnter()


        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_village, false)
        if Control == true then
                Util_StartIntel(EVENTS.Village)
                Rule_RemoveMe()
        end
end

function Ambush()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_ambushtrigger, false)
        if Control == true then
                SGroup_SetPlayerOwner(Anton, player3)
                SGroup_SetPlayerOwner(Friedrich, player3)
                SGroup_SetPlayerOwner(Ulrich, player3)
                SGroup_SetPlayerOwner(Otto, player3)
                Cmd_Move(Anton, mkr_ambushanton)
                Cmd_Move(Friedrich, mkr_ambushfriedrich)
                Cmd_Move(Otto, mkr_ambushotto)
                Cmd_Move(Ulrich, mkr_ambushulrich)
                Cmd_Move(CivOne, mkr_civoneto)
                Cmd_Move(CivTwo, mkr_civtwoto)
                Cmd_Move(CivThree, mkr_civthreeto)
                Cmd_Move(CivFour, mkr_civfourto)
                Rule_RemoveMe()
        end
end


function OneTurn()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player2, mkr_civoneto, false)
        if Control == true then
                SGroup_WarpToMarker(AmbushOne, mkr_civoneto)
                Rule_AddOneShot(MoveOne, 1)
                SGroup_DestroyAllSquads(CivOne)
                Rule_RemoveMe()
        end
end

function MoveOne()

        Cmd_Move(AmbushOne, mkr_civoneto2)

end

function TwoTurn()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player2, mkr_civtwoto, false)
        if Control == true then
                SGroup_WarpToMarker(AmbushTwo, mkr_civtwoto)
                Rule_AddOneShot(MoveTwo, 1)
                SGroup_DestroyAllSquads(CivTwo)
                Rule_RemoveMe()
        end
end

function MoveTwo()

        Cmd_Move(AmbushTwo, mkr_civtwoto2)

end

function ThreeTurn()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player2, mkr_civthreeto, false)
        if Control == true then
                SGroup_WarpToMarker(AmbushThree, mkr_civthreeto)
                Rule_AddOneShot(MoveThree, 1)
                SGroup_DestroyAllSquads(CivThree)
                Rule_RemoveMe()
        end
end

function MoveThree()

        Cmd_Move(AmbushThree, mkr_civthreeto2)

end

function FourTurn()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player2, mkr_civfourto, false)
        if Control == true then
                SGroup_WarpToMarker(AmbushFour, mkr_civfourto)
                Rule_AddOneShot(MoveFour, 1)
                SGroup_DestroyAllSquads(CivFour)
                Rule_RemoveMe()
        end
end

function MoveFour()

        Cmd_Move(AmbushFour, mkr_civfourto2)

end

function AmbushEnd()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = SGroup_Count(AmbushTotal)
        if Control == 0 then
                SGroup_SetPlayerOwner(Anton, player1)
                SGroup_SetPlayerOwner(Friedrich, player1)
                SGroup_SetPlayerOwner(Ulrich, player1)
                SGroup_SetPlayerOwner(Otto, player1)
                Util_StartIntel(EVENTS.Exit)
                Rule_RemoveMe()
        end
end

-----------------------------Camp Event------------------------------

function CampEvent()

        Rule_AddDelayedInterval(PointFive, 1, 1)
        Rule_AddDelayedInterval(Meet, 1, 1)
        Rule_AddDelayedInterval(One, 1, 1)
        Rule_AddDelayedInterval(Two, 1, 1)
        Rule_AddDelayedInterval(Three, 1, 1)
        Rule_AddDelayedInterval(CampDefense, 1, 1)


end

function PointFive()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local PointOne = EGroup_IsCapturedByPlayer(Point5, player1, false)
        if PointOne == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat5, 1)
                local DestroyEntity = EGroup_GetSpawnedEntityAt(Retreat4, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity)
                Rule_RemoveMe()
        end
end

function Meet()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_camptrigger, false)
        if Control == true then
	        Camera_SetInputEnabled(false)
	        Game_SetMode(UI_Cinematic)
                Camera_Follow(Jaksa)
                Camera_SetZoomDist(35)
                Util_StartIntel(EVENTS.Camp)
                SGroup_SetPlayerOwner(Jaksa, player1)
                SGroup_SetPlayerOwner(Hans, player1)
                SGroup_WarpToMarker(Kurt, mkr_campkurt)
                SGroup_WarpToMarker(Kurt, mkr_campulrich)
                SGroup_WarpToMarker(Kurt, mkr_campanton)
                SGroup_WarpToMarker(Kurt, mkr_campotto)
                SGroup_WarpToMarker(Kurt, mkr_campfriedrich)
                Rule_RemoveMe()
        end
end

function One()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = SGroup_IsUnderAttack(CampOne, false, 9000)
        if Control == true then
                SGroup_Kill(CampOne)
                Rule_RemoveMe()
        end
end

function Two()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = SGroup_IsUnderAttack(CampTwo, false, 9000)
        if Control == true then
                SGroup_Kill(CampTwo)
                Rule_RemoveMe()
        end
end

function Three()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = SGroup_IsUnderAttack(CampThree, false, 9000)
        if Control == true then
                SGroup_Kill(CampThree)
                Rule_RemoveMe()
        end
end

function CampDefense()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_campdefensetrigger, false)
        if Control == true then
                Cmd_Move(CampLeft, mkr_campleftto)
                Cmd_Move(CampLeftMG, mkr_campleftmgto)
                Cmd_Move(CampRight, mkr_camprightto)
                Rule_RemoveMe()
        end
end


----------------------------MichaelEvent------------------------

function MichaelEvent()

        Rule_AddDelayedInterval(PointSix, 1, 1)
        Rule_AddDelayedInterval(Warp, 1, 1)

end

function PointSix()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local PointOne = EGroup_IsCapturedByPlayer(Point6, player1, false)
        if PointOne == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat6, 1)
                local DestroyEntity = EGroup_GetSpawnedEntityAt(Retreat5, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity)
                Rule_RemoveMe()
        end
end

function Warp()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_michaeltrigger, false)
        if Control == true then
                SGroup_WarpToMarker(Kurt, mkr_michaelkurt)
                SGroup_WarpToMarker(Anton, mkr_michaelanton)
                SGroup_WarpToMarker(Friedrich, mkr_michaelfriedrich)
                SGroup_WarpToMarker(Otto, mkr_michaelotto)
                SGroup_WarpToMarker(Ulrich, mkr_michaelulrich)
                SGroup_WarpToMarker(Jaksa, mkr_michaeljaksa)
                SGroup_WarpToMarker(Hans, mkr_michaelhans)
                local TextHint4 = Util_CreateLocString("Any damage taken by Michael Wittman's tank is permanent. Try to minimize the damage to his tank")
                local TextHint5 = Util_CreateLocString("Anti-tank guns are highly inaccurate versus infantry but when it does hit it is a single-shot kill. Take calculated risks. Try to stay out of its line of fire when you can to minimize your chances of being hit by it")
                Hint4 = HintPoint_Add(mkr_hint4, true, TextHint4)
                Hint5 = HintPoint_Add(mkr_hint5, true, TextHint5)
	        Camera_SetInputEnabled(false)
	        Game_SetMode(UI_Cinematic)
                Camera_Follow(Kurt)
                Camera_SetZoomDist(45)
                Util_StartIntel(EVENTS.Michael)
                MichaelMove()
                Rule_RemoveMe()
        end
end

function MichaelMove()

        Cmd_Move(Michael, mkr_michaelto)
        Cmd_Move(Kurt, mkr_michaelkurtto)
        Cmd_Move(Anton, mkr_michaelantonto)
        Cmd_Move(Friedrich, mkr_michaelfriedrichto)
        Cmd_Move(Otto, mkr_michaelottoto)
        Cmd_Move(Ulrich, mkr_michaelulrichto)
        Cmd_Move(Jaksa, mkr_michaeljaksato)
        Cmd_Move(Hans, mkr_michaelhansto)

end


----------------------------BaseOne------------------------

function BaseOne()

        Rule_AddDelayedInterval(PointSeven, 1, 1)
        Rule_AddDelayedInterval(InitiationOne, 1, 1)
        Rule_AddDelayedInterval(ToThree, 1, 1)
        Rule_AddDelayedInterval(ToFour, 1, 1)
        Rule_AddDelayedInterval(Attacked, 1, 1)

end

function PointSeven()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local PointOne = EGroup_IsCapturedByPlayer(Point7, player1, false)
        if PointOne == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat7, 1)
                local DestroyEntity = EGroup_GetSpawnedEntityAt(Retreat6, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity)
                HintPoint_Remove(Hint4)
                HintPoint_Remove(Hint5)
                Rule_RemoveMe()
        end
end


function InitiationOne()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_michaelmovetrigger, false)
        local Control2 = Prox_ArePlayersNearMarker(player3, mkr_michaelto, false)
        if Control1 == true and Control2 == true then
                Cmd_Move(Michael, mkr_michaelto2)
                Util_StartIntel(EVENTS.MichaelGo)
                Rule_RemoveMe()
        end
end

function ToThree()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player3, mkr_michaelto2, false)
        if Control == true then
                Cmd_Move(Michael, mkr_michaelto3)
                Rule_RemoveMe()
        end
end

function ToFour()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_michaelmovetrigger2, false)
        local Control2 = Prox_ArePlayersNearMarker(player3, mkr_michaelto3, false)
        if Control1 == true and Control2 == true then
                Cmd_Move(Michael, mkr_michaelto4)
                Rule_RemoveMe()
        end
end

function Attacked()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player3, mkr_michaelto3, false)
        if Control == true then
                local Target = Marker_GetPosition(mkr_michaelto3)
                local Direction = Marker_GetDirection(mkr_directiontarget)
                Command_SquadMovePosFacing(player3, Michael, Target, Direction, false, true)
                Rule_RemoveMe()
        end
end

------------------------------Base Two-------------------------

function BaseTwo()

        Rule_AddDelayedInterval(PointEight, 1, 1)
        Rule_AddDelayedInterval(EndOne, 1, 1)
        Rule_AddDelayedInterval(ToSix, 1, 1)
        Rule_AddDelayedInterval(InitiationTwo, 1, 1)
        Rule_AddDelayedInterval(ArtyBase, 1, 1)
        Rule_AddDelayedInterval(EndTwo, 1, 1)

end

function PointEight()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local PointOne = EGroup_IsCapturedByPlayer(Point8, player1, false)
        if PointOne == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat8, 1)
                local DestroyEntity = EGroup_GetSpawnedEntityAt(Retreat7, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity)
                Rule_RemoveMe()
        end
end

function EndOne()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = SGroup_Count(TotalBaseOne)
        if Control == 0 then
                World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                Blip7 = UI_CreateMinimapBlip(mkr_blip7, 9000, BT_ObjectivePrimary)
                UI_DeleteMinimapBlip(Blip6)
                Cmd_Move(Michael, mkr_michaelto5)
                Rule_RemoveMe()
        end
end

function ToSix()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player3, mkr_michaelto5, false)
        if Control == true then
                Cmd_Move(Michael, mkr_michaelto6)
                Rule_RemoveMe()
        end
end

function InitiationTwo()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control1 = SGroup_Count(TotalBaseOne)
        local Control2 = Prox_ArePlayersNearMarker(player1, mkr_michaelmovetrigger3, false)
        if Control1 == 0 and Control2 == true then
                Cmd_Move(Michael, mkr_michaelto7)
                Util_StartIntel(EVENTS.MichaelGoTwo)
                Rule_RemoveMe()
        end
end

function ArtyBase()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player3, mkr_michaelto7, false)
        if Control == true then
                Util_StartIntel(EVENTS.MichaelArty)
                Rule_RemoveMe()
        end
end

function EndTwo()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = SGroup_Count(TotalBaseTwo)
        if Control == 0 then
                Cmd_Move(Michael, mkr_michaelto8)
                Blip8 = UI_CreateMinimapBlip(Point9, 9000, BT_ObjectivePrimary)
                UI_DeleteMinimapBlip(Blip7)
                World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                Rule_RemoveMe()
        end
end

-----------------------------Trench Event----------------------------

function TrenchEvent()

        Rule_AddDelayedInterval(InitiationTrench, 1, 1)
        Rule_AddDelayedInterval(ToTen, 1, 1)
        Rule_AddDelayedInterval(ToEleven, 1, 1)
        Rule_AddDelayedInterval(GroupOne, 1, 1)
        Rule_AddDelayedInterval(GroupTwo, 1, 1)
        Rule_AddDelayedInterval(ToTwelve, 1, 1)
        Rule_AddDelayedInterval(GroupThree, 1, 1)
        Rule_AddDelayedInterval(ToThirteen, 1, 1)
        Rule_AddDelayedInterval(ToFourteen, 1, 1)
        Rule_AddDelayedInterval(PointNine, 1, 1)

end

function InitiationTrench()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control1 = Prox_ArePlayersNearMarker(player3, mkr_michaelto8, false)
        local Control2 = Prox_ArePlayersNearMarker(player1, mkr_michaelmovetrigger4, false)
        if Control1 == true and Control2 == true then
                Util_StartIntel(EVENTS.MichaelTrench)
                Rule_RemoveMe()
        end
end

function ToTen()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control1 = Prox_ArePlayersNearMarker(player3, mkr_michaelto9, false)
        local Control2 = SGroup_Count(TotalTrenchOne)
        if Control1 == true and Control2 == 0 then
                Cmd_Move(Michael, mkr_michaelto10)
                Cmd_Move(Otto, mkr_trenchotto3)
                Cmd_Move(Friedrich, mkr_trenchfriedrich3)
                Cmd_Move(Ulrich, mkr_trenchulrich3)
                Rule_RemoveMe()
        end
end

function ToEleven()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player3, mkr_michaelto10, false)
        if Control == true then
                Cmd_Move(Michael, mkr_michaelto11)
                Rule_RemoveMe()
        end
end

function GroupOne()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = SGroup_Count(TrenchMG)
        if Control == 0 then
                Cmd_Move(Friedrich, mkr_trenchfriedrich2)
                Cmd_Move(Ulrich, mkr_trenchulrich2)
                Cmd_Move(Otto, mkr_trenchotto2)
                Rule_RemoveMe()
        end
end

function GroupTwo()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = SGroup_Count(TrenchGuards)
        if Control == 0 then
                Cmd_Move(Friedrich, mkr_trenchfriedrich4)
                Cmd_Move(Ulrich, mkr_trenchulrich4)
                Cmd_Move(Otto, mkr_trenchotto4)
                Rule_RemoveMe()
        end
end

function ToTwelve()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control1 = Prox_ArePlayersNearMarker(player3, mkr_michaelto11, false)
        local Control2 = SGroup_Count(TotalTrenchTwo)
        if Control1 == true and Control2 == 0 then
                Cmd_Move(Michael, mkr_michaelto12)
                Cmd_Move(Friedrich, mkr_trenchfriedrich5)
                Cmd_Move(Ulrich, mkr_trenchulrich5)
                Cmd_Move(Otto, mkr_trenchotto5)
                Rule_RemoveMe()
        end
end

function GroupThree()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = SGroup_Count(TrenchCons)
        if Control == 0 then
                Cmd_Move(Friedrich, mkr_trenchfriedrich6)
                Cmd_Move(Ulrich, mkr_trenchulrich6)
                Cmd_Move(Otto, mkr_trenchotto6)
                Rule_RemoveMe()
        end
end

function ToThirteen()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control1 = Prox_ArePlayersNearMarker(player3, mkr_michaelto12, false)
        local Control2 = SGroup_Count(TotalTrenchThree)
        if Control1 == true and Control2 == 0 then
                Cmd_Move(Michael, mkr_michaelto13)
                Util_StartIntel(EVENTS.MichaelTrenchFinish)
                SGroup_SetPlayerOwner(Otto, player1)
                SGroup_SetPlayerOwner(Friedrich, player1)
                SGroup_SetPlayerOwner(Ulrich, player1)
                Rule_RemoveMe()
        end
end

function ToFourteen()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_michaelmovetrigger5, false)
        local Control2 = Prox_ArePlayersNearMarker(player3, mkr_michaelto13, false)
        if Control1 == true and Control2 == true then
                Cmd_Move(Michael, mkr_michaelto14)
                Util_StartIntel(EVENTS.MichaelLast)
                Rule_RemoveMe()
        end
end

function PointNine()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local PointOne = EGroup_IsCapturedByPlayer(Point9, player1, false)
        if PointOne == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat9, 1)
                local DestroyEntity = EGroup_GetSpawnedEntityAt(Retreat8, 1)
                Blip9 = UI_CreateMinimapBlip(mkr_blip9, 9000, BT_ObjectivePrimary)
                UI_DeleteMinimapBlip(Blip8)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity)
                World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                Rule_RemoveMe()
        end
end

-------------------------------Base Three-----------------------------

function BaseThree()

        Rule_AddDelayedInterval(ToRight, 1, 1)
        Rule_AddDelayedInterval(PointLeft, 1, 7)
        Rule_AddDelayedInterval(PointCenter, 1, 7)
        Rule_AddDelayedInterval(PointRight, 1, 7)
        Rule_AddDelayedInterval(PointFourteenBase, 1, 7)
        Rule_AddDelayedInterval(BaseThreeEnd, 1, 1)

end

function ToRight()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player3, mkr_michaelto14, false)
        if Control == true then
                Cmd_Move(Michael, mkr_michaeltoright)
                Rule_RemoveMe()
        end
end

function PointLeft()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player3, mkr_michaeltoleft, false)
        local Random = World_GetRand(1, 2)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Michael, mkr_michaeltocenter)
                elseif Random == 2 then
                        Cmd_Move(Michael, mkr_michaelto14)
                end
        end
end

function PointCenter()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player3, mkr_michaeltocenter, false)
        local Random = World_GetRand(1, 2)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Michael, mkr_michaeltoleft)
                elseif Random == 2 then
                        Cmd_Move(Michael, mkr_michaeltoright)
                end
        end
end

function PointRight()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player3, mkr_michaeltoright, false)
        local Random = World_GetRand(1, 2)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Michael, mkr_michaeltocenter)
                elseif Random == 2 then
                        Cmd_Move(Michael, mkr_michaelto14)
                end
        end
end

function PointFourteenBase()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player3, mkr_michaelto14, false)
        local Random = World_GetRand(1, 2)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Michael, mkr_michaeltoleft)
                elseif Random == 2 then
                        Cmd_Move(Michael, mkr_michaeltoright)
                end
        end
end

function BaseThreeEnd()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = SGroup_Count(TotalBaseThree)
        if Control == 0 then
                Cmd_Move(Michael, mkr_michaelto15)
                World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                Rule_RemoveMe()
        end
end

---------------------------Finale Event-------------------------

function FinaleEvent()

        Rule_AddDelayedInterval(PointTen, 1, 1)
        Rule_AddDelayedInterval(AntonControlFailsafe, 1, 1)
        Rule_AddDelayedInterval(AntonKillControl, 1, 1)
        Rule_AddDelayedInterval(FinaleStart, 1, 1)
        Rule_AddDelayedInterval(KillTankMove, 1, 1)
        Rule_AddDelayedInterval(FinaleActionStart, 1, 1)
        Rule_AddDelayedInterval(AntonDeathDialogue, 1, 1)
        Rule_AddDelayedInterval(KillTankDeath, 1, 1)
        Rule_AddDelayedInterval(BossArrive, 1, 1)
        Rule_AddDelayedInterval(MichaelFirst, 1, 7)
        Rule_AddDelayedInterval(MichaelSecond, 1, 7)
        Rule_AddDelayedInterval(MichaelThird, 1, 7)
        Rule_AddDelayedInterval(MichaelFourth, 1, 7)
        Rule_AddDelayedInterval(MichaelFifth, 1, 7)
        Rule_AddDelayedInterval(MichaelSixth, 1, 7)
        Rule_AddDelayedInterval(MichaelSeventh, 1, 7)
        Rule_AddDelayedInterval(MichaelEighth, 1, 7)
        Rule_AddDelayedInterval(MichaelNinth, 1, 7)
        Rule_AddDelayedInterval(MichaelTenth, 1, 7)
        Rule_AddDelayedInterval(EnemyFirst, 1, 10)
        Rule_AddDelayedInterval(EnemySecond, 1, 10)
        Rule_AddDelayedInterval(EnemyThird, 1, 10)
        Rule_AddDelayedInterval(EnemyFourth, 1, 10)
        Rule_AddDelayedInterval(EnemyFifth, 1, 10)
        Rule_AddDelayedInterval(EnemySixth, 1, 10)
        Rule_AddDelayedInterval(EnemySeventh, 1, 10)
        Rule_AddDelayedInterval(EnemyEighth, 1, 10)
        Rule_AddDelayedInterval(EnemyNinth, 1, 10)
        Rule_AddDelayedInterval(EnemyTenth, 1, 10)
        Rule_AddDelayedInterval(IgorFirst, 1, 10)
        Rule_AddDelayedInterval(IgorSecond, 1, 10)
        Rule_AddDelayedInterval(IgorThird, 1, 10)
        Rule_AddDelayedInterval(IgorFourth, 1, 10)
        Rule_AddDelayedInterval(IgorFifth, 1, 10)
        Rule_AddDelayedInterval(IgorSixth, 1, 10)
        Rule_AddDelayedInterval(IgorSeventh, 1, 10)
        Rule_AddDelayedInterval(IgorEighth, 1, 10)
        Rule_AddDelayedInterval(IgorNinth, 1, 10)
        Rule_AddDelayedInterval(IgorTenth, 1, 10)

end

function PointTen()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local PointOne = EGroup_IsCapturedByPlayer(Point10, player1, false)
        if PointOne == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat10, 1)
                local DestroyEntity = EGroup_GetSpawnedEntityAt(TempRetreat, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity)
                Rule_RemoveMe()
        end
end

function AntonControlFailsafe()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_finaletotal, false)
        if Control == true then
                SGroup_Kill(AntonControl)
                Rule_RemoveMe()
        end
end

function AntonKillControl()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_finaletotal, false)
        if Control == true then
                SGroup_Kill(AntonDeathControl)
                Rule_RemoveMe()
        end
end

function FinaleStart()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = SGroup_Count(TotalBaseThree)
        if Control == 0 then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(TempRetreat, 1)
                local DestroyEntity = EGroup_GetSpawnedEntityAt(Retreat9, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity)
                SGroup_WarpToMarker(Michael, mkr_michaelto15)
                SGroup_WarpToMarker(Kurt, mkr_finalekurt)
                SGroup_WarpToMarker(Anton, mkr_finaleanton)
                SGroup_WarpToMarker(Jaksa, mkr_finalejaksa)
                SGroup_WarpToMarker(Hans, mkr_finalehans)
                SGroup_WarpToMarker(Friedrich, mkr_finalefriedrich)
                SGroup_WarpToMarker(Otto, mkr_finaleotto)
                SGroup_WarpToMarker(Ulrich, mkr_finaleulrich)
	        Camera_SetInputEnabled(false)
	        Game_SetMode(UI_Cinematic)
                Camera_Follow(Kurt)
                Camera_SetZoomDist(60)
                Rule_AddOneShot(FinaleMove, 1)
                Rule_RemoveMe()
        end
end

function FinaleMove()

        Cmd_Move(Michael, mkr_michaelto16)
        Cmd_Move(Kurt, mkr_finalekurtto)
        Cmd_Move(Anton, mkr_finaleantonto)
        Cmd_Move(Jaksa, mkr_finalejaksato)
        Cmd_Move(Hans, mkr_finalehansto)
        Cmd_Move(Friedrich, mkr_finalefriedrichto)
        Cmd_Move(Otto, mkr_finaleottoto)
        Cmd_Move(Ulrich, mkr_finaleulrichto)

end

function FinaleActionStart()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player3, mkr_michaelto16, false)
        if Control == true then
                Util_StartIntel(EVENTS.FinaleBegin)
                Rule_RemoveMe()
        end
end

function KillTankMove()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_finaleantonto2, false)
        if Control == true then
                Cmd_Move(KillTank, mkr_killtankto)
                Rule_AddOneShot(FailsafeKill, 3)
                Rule_RemoveMe()
        end
end

function FailsafeKill()

        SGroup_Kill(Anton)

end

function AntonDeathDialogue()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = SGroup_Count(Anton)
        if Control == 0 then
                Util_StartIntel(EVENTS.AntonDies)
                Cmd_Move(KillTank, mkr_1)
                Cmd_Move(Michael, mkr_6)
                Rule_RemoveMe()
        end
end

function KillTankDeath()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control1 = SGroup_Count(KillTank)
        local Control2 = Prox_ArePlayersNearMarker(player3, mkr_finaletotal, false)
        if Control1 == 0 and Control2 == true then
                SGroup_WarpToMarker(Enemy, mkr_enemyspawn)
                Rule_AddOneShot(EnemyTanksTo, 1)
                Rule_RemoveMe()
        end
end

function EnemyTanksTo()

        Cmd_Move(Enemy, mkr_3)

end

function BossArrive()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control1 = SGroup_Count(Enemy)
        local Control2 = Prox_ArePlayersNearMarker(player3, mkr_finaletotal, false)
        if Control1 == 0 and Control2 == true then
                Util_StartIntel(EVENTS.Boss)
                SGroup_WarpToMarker(Igor, mkr_enemyspawn)
                Rule_AddOneShot(IgorTo, 2)
                Rule_RemoveMe()
        end
end

function IgorTo()

        Cmd_Move(Igor, mkr_3)

end

function MichaelFirst()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_finaletotal, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Michael, mkr_2)
                elseif Random == 2 then
                        Cmd_Move(Michael, mkr_3)
                elseif Random == 3 then
                        Cmd_Move(Michael, mkr_4)
                elseif Random == 4 then
                        Cmd_Move(Michael, mkr_5)
                elseif Random == 5 then
                        Cmd_Move(Michael, mkr_6)
                elseif Random == 6 then
                        Cmd_Move(Michael, mkr_7)
                elseif Random == 7 then
                        Cmd_Move(Michael, mkr_8)
                end
        end
end

function MichaelSecond()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_finaletotal, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Michael, mkr_1)
                elseif Random == 2 then
                        Cmd_Move(Michael, mkr_3)
                elseif Random == 3 then
                        Cmd_Move(Michael, mkr_4)
                elseif Random == 4 then
                        Cmd_Move(Michael, mkr_5)
                elseif Random == 5 then
                        Cmd_Move(Michael, mkr_6)
                elseif Random == 6 then
                        Cmd_Move(Michael, mkr_9)
                elseif Random == 7 then
                        Cmd_Move(Michael, mkr_10)
                end
        end
end

function MichaelThird()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_finaletotal, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Michael, mkr_1)
                elseif Random == 2 then
                        Cmd_Move(Michael, mkr_2)
                elseif Random == 3 then
                        Cmd_Move(Michael, mkr_4)
                elseif Random == 4 then
                        Cmd_Move(Michael, mkr_5)
                elseif Random == 5 then
                        Cmd_Move(Michael, mkr_6)
                elseif Random == 6 then
                        Cmd_Move(Michael, mkr_8)
                elseif Random == 7 then
                        Cmd_Move(Michael, mkr_10)
                end
        end
end

function MichaelFourth()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_finaletotal, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Michael, mkr_1)
                elseif Random == 2 then
                        Cmd_Move(Michael, mkr_2)
                elseif Random == 3 then
                        Cmd_Move(Michael, mkr_3)
                elseif Random == 4 then
                        Cmd_Move(Michael, mkr_5)
                elseif Random == 5 then
                        Cmd_Move(Michael, mkr_7)
                elseif Random == 6 then
                        Cmd_Move(Michael, mkr_9)
                elseif Random == 7 then
                        Cmd_Move(Michael, mkr_10)
                end
        end
end

function MichaelFifth()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_finaletotal, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Michael, mkr_2)
                elseif Random == 2 then
                        Cmd_Move(Michael, mkr_3)
                elseif Random == 3 then
                        Cmd_Move(Michael, mkr_4)
                elseif Random == 4 then
                        Cmd_Move(Michael, mkr_6)
                elseif Random == 5 then
                        Cmd_Move(Michael, mkr_7)
                elseif Random == 6 then
                        Cmd_Move(Michael, mkr_8)
                elseif Random == 7 then
                        Cmd_Move(Michael, mkr_10)
                end
        end
end

function MichaelSixth()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_finaletotal, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Michael, mkr_2)
                elseif Random == 2 then
                        Cmd_Move(Michael, mkr_3)
                elseif Random == 3 then
                        Cmd_Move(Michael, mkr_4)
                elseif Random == 4 then
                        Cmd_Move(Michael, mkr_5)
                elseif Random == 5 then
                        Cmd_Move(Michael, mkr_7)
                elseif Random == 6 then
                        Cmd_Move(Michael, mkr_8)
                elseif Random == 7 then
                        Cmd_Move(Michael, mkr_9)
                end
        end
end

function MichaelSeventh()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_finaletotal, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Michael, mkr_2)
                elseif Random == 2 then
                        Cmd_Move(Michael, mkr_3)
                elseif Random == 3 then
                        Cmd_Move(Michael, mkr_4)
                elseif Random == 4 then
                        Cmd_Move(Michael, mkr_5)
                elseif Random == 5 then
                        Cmd_Move(Michael, mkr_6)
                elseif Random == 6 then
                        Cmd_Move(Michael, mkr_8)
                elseif Random == 7 then
                        Cmd_Move(Michael, mkr_9)
                end
        end
end

function MichaelEighth()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_finaletotal, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Michael, mkr_1)
                elseif Random == 2 then
                        Cmd_Move(Michael, mkr_2)
                elseif Random == 3 then
                        Cmd_Move(Michael, mkr_4)
                elseif Random == 4 then
                        Cmd_Move(Michael, mkr_5)
                elseif Random == 5 then
                        Cmd_Move(Michael, mkr_6)
                elseif Random == 6 then
                        Cmd_Move(Michael, mkr_7)
                elseif Random == 7 then
                        Cmd_Move(Michael, mkr_10)
                end
        end
end

function MichaelNinth()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_finaletotal, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Michael, mkr_2)
                elseif Random == 2 then
                        Cmd_Move(Michael, mkr_3)
                elseif Random == 3 then
                        Cmd_Move(Michael, mkr_4)
                elseif Random == 4 then
                        Cmd_Move(Michael, mkr_5)
                elseif Random == 5 then
                        Cmd_Move(Michael, mkr_6)
                elseif Random == 6 then
                        Cmd_Move(Michael, mkr_7)
                elseif Random == 7 then
                        Cmd_Move(Michael, mkr_8)
                end
        end
end

function MichaelTenth()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_finaletotal, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Michael, mkr_1)
                elseif Random == 2 then
                        Cmd_Move(Michael, mkr_4)
                elseif Random == 3 then
                        Cmd_Move(Michael, mkr_5)
                elseif Random == 4 then
                        Cmd_Move(Michael, mkr_6)
                elseif Random == 5 then
                        Cmd_Move(Michael, mkr_7)
                elseif Random == 6 then
                        Cmd_Move(Michael, mkr_8)
                elseif Random == 7 then
                        Cmd_Move(Michael, mkr_9)
                end
        end
end

function EnemyFirst()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player5, mkr_1, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Enemy, mkr_2)
                elseif Random == 2 then
                        Cmd_Move(Enemy, mkr_3)
                elseif Random == 3 then
                        Cmd_Move(Enemy, mkr_4)
                elseif Random == 4 then
                        Cmd_Move(Enemy, mkr_5)
                elseif Random == 5 then
                        Cmd_Move(Enemy, mkr_6)
                elseif Random == 6 then
                        Cmd_Move(Enemy, mkr_7)
                elseif Random == 7 then
                        Cmd_Move(Enemy, mkr_8)
                end
        end
end

function EnemySecond()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player5, mkr_2, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Enemy, mkr_1)
                elseif Random == 2 then
                        Cmd_Move(Enemy, mkr_3)
                elseif Random == 3 then
                        Cmd_Move(Enemy, mkr_4)
                elseif Random == 4 then
                        Cmd_Move(Enemy, mkr_6)
                elseif Random == 5 then
                        Cmd_Move(Enemy, mkr_7)
                elseif Random == 6 then
                        Cmd_Move(Enemy, mkr_8)
                elseif Random == 7 then
                        Cmd_Move(Enemy, mkr_9)
                end
        end
end

function EnemyThird()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player5, mkr_3, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Enemy, mkr_1)
                elseif Random == 2 then
                        Cmd_Move(Enemy, mkr_2)
                elseif Random == 3 then
                        Cmd_Move(Enemy, mkr_4)
                elseif Random == 4 then
                        Cmd_Move(Enemy, mkr_5)
                elseif Random == 5 then
                        Cmd_Move(Enemy, mkr_6)
                elseif Random == 6 then
                        Cmd_Move(Enemy, mkr_8)
                elseif Random == 7 then
                        Cmd_Move(Enemy, mkr_10)
                end
        end
end

function EnemyFourth()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player5, mkr_4, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Enemy, mkr_1)
                elseif Random == 2 then
                        Cmd_Move(Enemy, mkr_2)
                elseif Random == 3 then
                        Cmd_Move(Enemy, mkr_3)
                elseif Random == 4 then
                        Cmd_Move(Enemy, mkr_5)
                elseif Random == 5 then
                        Cmd_Move(Enemy, mkr_6)
                elseif Random == 6 then
                        Cmd_Move(Enemy, mkr_9)
                elseif Random == 7 then
                        Cmd_Move(Enemy, mkr_10)
                end
        end
end

function EnemyFifth()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player5, mkr_5, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Enemy, mkr_2)
                elseif Random == 2 then
                        Cmd_Move(Enemy, mkr_3)
                elseif Random == 3 then
                        Cmd_Move(Enemy, mkr_4)
                elseif Random == 4 then
                        Cmd_Move(Enemy, mkr_6)
                elseif Random == 5 then
                        Cmd_Move(Enemy, mkr_7)
                elseif Random == 6 then
                        Cmd_Move(Enemy, mkr_8)
                elseif Random == 7 then
                        Cmd_Move(Enemy, mkr_9)
                end
        end
end

function EnemySixth()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player5, mkr_6, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Enemy, mkr_1)
                elseif Random == 2 then
                        Cmd_Move(Enemy, mkr_2)
                elseif Random == 3 then
                        Cmd_Move(Enemy, mkr_4)
                elseif Random == 4 then
                        Cmd_Move(Enemy, mkr_5)
                elseif Random == 5 then
                        Cmd_Move(Enemy, mkr_7)
                elseif Random == 6 then
                        Cmd_Move(Enemy, mkr_9)
                elseif Random == 7 then
                        Cmd_Move(Enemy, mkr_10)
                end
        end
end

function EnemySeventh()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player5, mkr_7, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Enemy, mkr_1)
                elseif Random == 2 then
                        Cmd_Move(Enemy, mkr_2)
                elseif Random == 3 then
                        Cmd_Move(Enemy, mkr_3)
                elseif Random == 4 then
                        Cmd_Move(Enemy, mkr_5)
                elseif Random == 5 then
                        Cmd_Move(Enemy, mkr_6)
                elseif Random == 6 then
                        Cmd_Move(Enemy, mkr_8)
                elseif Random == 7 then
                        Cmd_Move(Enemy, mkr_9)
                end
        end
end

function EnemyEighth()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player5, mkr_8, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Enemy, mkr_1)
                elseif Random == 2 then
                        Cmd_Move(Enemy, mkr_3)
                elseif Random == 3 then
                        Cmd_Move(Enemy, mkr_4)
                elseif Random == 4 then
                        Cmd_Move(Enemy, mkr_5)
                elseif Random == 5 then
                        Cmd_Move(Enemy, mkr_7)
                elseif Random == 6 then
                        Cmd_Move(Enemy, mkr_9)
                elseif Random == 7 then
                        Cmd_Move(Enemy, mkr_10)
                end
        end
end

function EnemyNinth()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player5, mkr_9, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Enemy, mkr_1)
                elseif Random == 2 then
                        Cmd_Move(Enemy, mkr_2)
                elseif Random == 3 then
                        Cmd_Move(Enemy, mkr_4)
                elseif Random == 4 then
                        Cmd_Move(Enemy, mkr_5)
                elseif Random == 5 then
                        Cmd_Move(Enemy, mkr_7)
                elseif Random == 6 then
                        Cmd_Move(Enemy, mkr_8)
                elseif Random == 7 then
                        Cmd_Move(Enemy, mkr_10)
                end
        end
end

function EnemyTenth()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player5, mkr_10, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Enemy, mkr_1)
                elseif Random == 2 then
                        Cmd_Move(Enemy, mkr_2)
                elseif Random == 3 then
                        Cmd_Move(Enemy, mkr_3)
                elseif Random == 4 then
                        Cmd_Move(Enemy, mkr_4)
                elseif Random == 5 then
                        Cmd_Move(Enemy, mkr_5)
                elseif Random == 6 then
                        Cmd_Move(Enemy, mkr_6)
                elseif Random == 7 then
                        Cmd_Move(Enemy, mkr_8)
                end
        end
end

function IgorFirst()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player5, mkr_1, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Igor, mkr_2)
                elseif Random == 2 then
                        Cmd_Move(Igor, mkr_3)
                elseif Random == 3 then
                        Cmd_Move(Igor, mkr_4)
                elseif Random == 4 then
                        Cmd_Move(Igor, mkr_5)
                elseif Random == 5 then
                        Cmd_Move(Igor, mkr_6)
                elseif Random == 6 then
                        Cmd_Move(Igor, mkr_7)
                elseif Random == 7 then
                        Cmd_Move(Igor, mkr_8)
                end
        end
end

function IgorSecond()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player5, mkr_2, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Igor, mkr_1)
                elseif Random == 2 then
                        Cmd_Move(Igor, mkr_3)
                elseif Random == 3 then
                        Cmd_Move(Igor, mkr_4)
                elseif Random == 4 then
                        Cmd_Move(Igor, mkr_5)
                elseif Random == 5 then
                        Cmd_Move(Igor, mkr_6)
                elseif Random == 6 then
                        Cmd_Move(Igor, mkr_9)
                elseif Random == 7 then
                        Cmd_Move(Igor, mkr_10)
                end
        end
end

function IgorThird()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player5, mkr_3, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Igor, mkr_1)
                elseif Random == 2 then
                        Cmd_Move(Igor, mkr_2)
                elseif Random == 3 then
                        Cmd_Move(Igor, mkr_4)
                elseif Random == 4 then
                        Cmd_Move(Igor, mkr_5)
                elseif Random == 5 then
                        Cmd_Move(Igor, mkr_6)
                elseif Random == 6 then
                        Cmd_Move(Igor, mkr_8)
                elseif Random == 7 then
                        Cmd_Move(Igor, mkr_10)
                end
        end
end

function IgorFourth()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player5, mkr_4, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Igor, mkr_1)
                elseif Random == 2 then
                        Cmd_Move(Igor, mkr_2)
                elseif Random == 3 then
                        Cmd_Move(Igor, mkr_3)
                elseif Random == 4 then
                        Cmd_Move(Igor, mkr_5)
                elseif Random == 5 then
                        Cmd_Move(Igor, mkr_7)
                elseif Random == 6 then
                        Cmd_Move(Igor, mkr_9)
                elseif Random == 7 then
                        Cmd_Move(Igor, mkr_10)
                end
        end
end

function IgorFifth()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player5, mkr_5, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Igor, mkr_2)
                elseif Random == 2 then
                        Cmd_Move(Igor, mkr_3)
                elseif Random == 3 then
                        Cmd_Move(Igor, mkr_4)
                elseif Random == 4 then
                        Cmd_Move(Igor, mkr_6)
                elseif Random == 5 then
                        Cmd_Move(Igor, mkr_7)
                elseif Random == 6 then
                        Cmd_Move(Igor, mkr_8)
                elseif Random == 7 then
                        Cmd_Move(Igor, mkr_10)
                end
        end
end

function IgorSixth()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player5, mkr_6, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Igor, mkr_2)
                elseif Random == 2 then
                        Cmd_Move(Igor, mkr_3)
                elseif Random == 3 then
                        Cmd_Move(Igor, mkr_4)
                elseif Random == 4 then
                        Cmd_Move(Igor, mkr_5)
                elseif Random == 5 then
                        Cmd_Move(Igor, mkr_7)
                elseif Random == 6 then
                        Cmd_Move(Igor, mkr_8)
                elseif Random == 7 then
                        Cmd_Move(Igor, mkr_9)
                end
        end
end

function IgorSeventh()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player5, mkr_7, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Igor, mkr_2)
                elseif Random == 2 then
                        Cmd_Move(Igor, mkr_3)
                elseif Random == 3 then
                        Cmd_Move(Igor, mkr_4)
                elseif Random == 4 then
                        Cmd_Move(Igor, mkr_5)
                elseif Random == 5 then
                        Cmd_Move(Igor, mkr_6)
                elseif Random == 6 then
                        Cmd_Move(Igor, mkr_8)
                elseif Random == 7 then
                        Cmd_Move(Igor, mkr_9)
                end
        end
end

function IgorEighth()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player5, mkr_8, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Igor, mkr_1)
                elseif Random == 2 then
                        Cmd_Move(Igor, mkr_2)
                elseif Random == 3 then
                        Cmd_Move(Igor, mkr_4)
                elseif Random == 4 then
                        Cmd_Move(Igor, mkr_5)
                elseif Random == 5 then
                        Cmd_Move(Igor, mkr_6)
                elseif Random == 6 then
                        Cmd_Move(Igor, mkr_7)
                elseif Random == 7 then
                        Cmd_Move(Igor, mkr_10)
                end
        end
end

function IgorNinth()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player5, mkr_9, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Igor, mkr_2)
                elseif Random == 2 then
                        Cmd_Move(Igor, mkr_3)
                elseif Random == 3 then
                        Cmd_Move(Igor, mkr_4)
                elseif Random == 4 then
                        Cmd_Move(Igor, mkr_5)
                elseif Random == 5 then
                        Cmd_Move(Igor, mkr_6)
                elseif Random == 6 then
                        Cmd_Move(Igor, mkr_7)
                elseif Random == 7 then
                        Cmd_Move(Igor, mkr_8)
                end
        end
end

function IgorTenth()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = Prox_ArePlayersNearMarker(player5, mkr_10, false)
        local Random = World_GetRand(1, 7)
        if Control == true then
                if Random == 1 then
                        Cmd_Move(Igor, mkr_1)
                elseif Random == 2 then
                        Cmd_Move(Igor, mkr_4)
                elseif Random == 3 then
                        Cmd_Move(Igor, mkr_5)
                elseif Random == 4 then
                        Cmd_Move(Igor, mkr_6)
                elseif Random == 5 then
                        Cmd_Move(Igor, mkr_7)
                elseif Random == 6 then
                        Cmd_Move(Igor, mkr_8)
                elseif Random == 7 then
                        Cmd_Move(Igor, mkr_9)
                end
        end
end




------------------------------Hints---------------------------

function EliteHint()

        local EliteName1 = Util_CreateLocString("Kurt Bachmann")
        local EliteName2 = Util_CreateLocString("Ulrich Goldmund")
        local EliteName3 = Util_CreateLocString("Friedrich Althaus")
        local EliteName4 = Util_CreateLocString("Anton Constantin")
        local EliteName5 = Util_CreateLocString("Otto Baasch")
        local EliteName6 = Util_CreateLocString("Tomislav Novak")
        local EliteName7 = Util_CreateLocString("Hans Dunkel")
        local EliteName9 = Util_CreateLocString("Igor Oktyabrskaya")

        HintMouseover_Add(EliteName1, Kurt, 5, true)
        HintMouseover_Add(EliteName2, Ulrich, 5, true)
        HintMouseover_Add(EliteName3, Friedrich, 5, true)
        HintMouseover_Add(EliteName4, Anton, 5, true)
        HintMouseover_Add(EliteName5, Otto, 5, true)
        HintMouseover_Add(EliteName6, Jaksa, 5, true)
        HintMouseover_Add(EliteName7, Hans, 5, true)
        HintMouseover_Add(EliteName9, Igor, 5, true)

        local EliteHint1 = Util_CreateLocString("17th Elite Guards Rifles")
        local EliteHint2 = Util_CreateLocString("NKVD Honorary Selects")
        local EliteHint3 = Util_CreateLocString("9th Shock Honor Guards")

        HintMouseover_Add(EliteHint1, CampRight, 5, true)
        HintMouseover_Add(EliteHint2, PenalElites, 5, true)
        HintMouseover_Add(EliteHint3, EliteShock, 5, true)

end


------------------------------Elites--------------------------------

function Elites()

        Weapons()

        Modify_ReceivedDamage(Kurt, 0.4)
        Modify_ReceivedAccuracy(Kurt, 0.8)
        Modify_ReceivedDamage(Ulrich, 0.4)
        Modify_ReceivedAccuracy(Ulrich, 0.8)
        Modify_ReceivedDamage(Anton, 0.4)
        Modify_ReceivedAccuracy(Anton, 0.5)
        Modify_ReceivedDamage(Otto, 0.2)
        Modify_ReceivedAccuracy(Otto, 0.7)
        Modify_ReceivedDamage(Friedrich, 0.5)
        Modify_ReceivedAccuracy(Friedrich, 0.5)
        Modify_ReceivedDamage(Jaksa, 0.5)
        Modify_ReceivedAccuracy(Jaksa, 0.4)
        Modify_ReceivedDamage(Hans, 0.2)
        Modify_ReceivedAccuracy(Hans, 0.9)

        Modify_ReceivedDamage(Michael, 0.05)
        Modify_ReceivedDamage(Igor, 0.2)

        Modify_ReceivedDamage(CampRight, 0.6)
        Modify_ReceivedAccuracy(CampRight, 0.8)
        Modify_ReceivedDamage(PenalElites, 0.5)
        Modify_ReceivedAccuracy(PenalElites, 0.7)
        Modify_ReceivedDamage(EliteShock, 0.8)
        Modify_ReceivedAccuracy(EliteShock, 0.7)

        SGroup_IncreaseVeterancyRank(Igor, 3, false)
        SGroup_IncreaseVeterancyRank(CampRight, 1, false)
        SGroup_IncreaseVeterancyRank(PenalElites, 2, false)
        SGroup_IncreaseVeterancyRank(EliteShock, 1, false)

end

function Weapons()

        local ControlEntity1 = SGroup_GetSpawnedSquadAt(CampRight, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.ROKS_2_FLAMETHROWER_ITEM_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.DP_28_LIGHT_MACHINE_GUN_PACKAGE_MOVING_NO_PRONE_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_MP)

        local ControlEntity2 = SGroup_GetSpawnedSquadAt(PenalElites, 1)
        Squad_GiveSlotItem(ControlEntity2, SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP_MP)

        local ControlEntity3 = SGroup_GetSpawnedSquadAt(EliteShock, 1)
        Squad_GiveSlotItem(ControlEntity3, SLOT_ITEM.ROKS_2_FLAMETHROWER_ITEM_MP)
        Squad_GiveSlotItem(ControlEntity3, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_MP)

end


------------------------------Officers------------------------------

function Officers()

        Rule_AddDelayedInterval(OfficerBase, 1, 45)
        Rule_AddDelayedInterval(OfficerOutpost, 1, 75)  
        Rule_AddDelayedInterval(OfficerArty, 1, 120)  
        Rule_AddDelayedInterval(ShockSpawnMove, 1, 1) 
        Rule_AddDelayedInterval(OfficerLast, 1, 80) 
        Rule_AddDelayedInterval(FinaleBarrage, 1, 80) 

end

function OfficerBase()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = SGroup_IsUnderAttackByPlayer(HQOfficer, player1, 9000)
        if Control == true then
                local Target = Player_GetSquadConcentration(player1)
                Cmd_Ability(player4, ABILITY.AEF.MAJOR_ARTILLERY, Target, nil, true)
                Util_StartIntel(EVENTS.HQOfficer)
        end
end

function OfficerOutpost()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = SGroup_IsUnderAttackByPlayer(OutpostOfficer, player1, 9000)
        if Control == true then
                local Target = Player_GetSquadConcentration(player1)
                Cmd_Ability(player4, ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY, Target, nil, true)
                Util_StartIntel(EVENTS.Outpost)
        end
end

function OfficerArty()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control1 = SGroup_IsUnderAttackByPlayer(ArtyOfficer, player1, 9000)
        local Control2 = SGroup_Count(ShockSpawn)
        if Control1 == true and Control2 < 2 then
	        Util_CreateSquads(player4, ShockSpawn, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_shockspawn)
                Util_StartIntel(EVENTS.Arty)
        end
end

function ShockSpawnMove()

        Cmd_AttackMove(ShockSpawn, mkr_shockspawnto)

end

function OfficerLast()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control = SGroup_IsUnderAttackByPlayer(LastOfficer, player1, 9000)
        if Control == true then
                local Target = Player_GetSquadConcentration(player1)
                Cmd_Ability(player4, ABILITY.SOVIET.FIRE_ARTILLERY, Target, nil, true)
                Util_StartIntel(EVENTS.Last)
        end
end

function FinaleBarrage()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_finaletotal, false)
        local Control2 = SGroup_Count(OutpostOfficer)
        if Control1 == true and Control2 == 1 then
                local Target = Player_GetSquadConcentration(player1)
                Cmd_Ability(player4, ABILITY.SOVIET.IL_2_PRECISION_BOMB_STRIKE, Target, nil, true)
                Util_StartIntel(EVENTS.OverwatchBarrage)
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

        Player_SetAbilityAvailability(player1, ABILITY.WEST_GERMAN.PIONEER_VOLKS_SALVAGE, ITEM_REMOVED)
        Player_SetAbilityAvailability(player1, ABILITY.WEST_GERMAN.THROUGH_SALVAGE, ITEM_REMOVED)
        Player_SetAbilityAvailability(player1, ABILITY.WEST_GERMAN.MG34_DISPATCH, ITEM_REMOVED)
		
		Player_SetAbilityAvailability(player1, ABILITY.WEST_GERMAN.VOLKSGRENADIER_FIRE_GRENADE_MP, ITEM_UNLOCKED)

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
		
		Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.VOLKS_STG44_UPGRADE, ITEM_UNLOCKED)
		Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.VOLK_FIRE_GRENADE, ITEM_UNLOCKED)
		Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.VOLKS_FLAMETHROWER_MP, ITEM_UNLOCKED)
		Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.VOLKS_CQC_UPGRADE, ITEM_UNLOCKED)

        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("sws_interval_unlock"))
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("construct_base_building_upgrade"))
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("ability_lock_out_sws_truck"))
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("first_sws_halftrack_lockout"))
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("call_sws_upgrade"))
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("construct_base_building_upgrade"))
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("sws_starting_dispatch_unlock"))
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("volk_fire_grenade"))		

        Player_AddAbility(player4, BP_GetAbilityBlueprint("il-2_precision_bomb_strike"))
        Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("il-2_bomb_Strike"))
        Player_AddAbility(player4, BP_GetAbilityBlueprint("major_artillery"))
        Player_AddAbility(player4, BP_GetAbilityBlueprint("light_support_artillery"))
        Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("light_artillery_support"))
        Player_AddAbility(player4, BP_GetAbilityBlueprint("fire_artillery"))
        Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("fire_artillery"))

end

function BuildingRestrict()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)

        Player_SetEntityProductionAvailability(player1, EBP.GERMAN.BUNKER_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.GERMAN.SLIT_TRENCH_GERMAN_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.GERMAN.SLIT_TRENCH_GERMAN, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.WG_SANDBAG_FENCE_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_02, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_01, ITEM_REMOVED)

end

------------------------------Resources---------------------------

function First()

local player = World_GetPlayerAt(1)
Modify_PlayerResourceRate(player, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player, RT_Munition, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player, RT_Manpower, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player, RT_Action, 0, MUT_Multiplication)

end

Scar_AddInit(First)

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
				manpower = 600,
				fuel = 40,
				munition = 9000,
				action = 0,
				command = 2,
			},
			--player 3:
			[2] = {
				manpower = 800,
				fuel = 50,
				munition = 9000,
				action = 0,
				command = 4,
			},
			--player 4:
			[3] = {
				manpower = 9000,
				fuel = 9000,
				munition = 9000,
				action = 0,
				command = 10,
			},
			--player 5:
			[4] = {
				manpower = 800,
				fuel = 50,
				munition = 9000,
				action = 0,
				command = 10,
			},
			--player 6:
			[5] = {
				manpower = 800,
				fuel = 50,
				munition = 9000,
				action = 0,
				command = 10,
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
	end
end

Scar_AddInit(CustomStartingResources_Init)



------------------------------Events and Actors--------------------

ACTOR = {
	
	__scardoc_enum = true,

	None					= "",

        Friedrich = "Icons_portraits_unit_german_panzer_grenadiers_w_portrait",
        Ulrich = "Icons_portraits_unit_german_grenadiers_w_portrait",
        Hans = "Icons_portraits_unit_west_german_honor_guard_w_portrait",
        Jaksa = "Icons_portraits_unit_west_german_volksgrenadier_w_portrait",

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


EVENTS = {}

        local Text1 = Util_CreateLocString("I think we've lost those pursuing Soviets.")
        local Text2 = Util_CreateLocString("I hope you're right, I need a rest and a drink of my whiskey. Too much running...")
        local Text3 = Util_CreateLocString("God Otto, this is a really odd whiskey you have here...")
        local Text4 = Util_CreateLocString("Don't take his canteen from him like that Anton.")
        local Text5 = Util_CreateLocString("Heh heh... of course it tastes odd. That's my piss canteen you got in your hand!")
        local Text6 = Util_CreateLocString("Anton... stop drinking from Otto's piss canteen and scout up ahead. We need you to do something helpful now!")
        local Text7 = Util_CreateLocString("Urgh... Gladly...")

        local Text8 = Util_CreateLocString("Run, run, RUN!")

        local Text9 = Util_CreateLocString("Oh fuck! Soviets behind us too! Into the woods now!")

        local Text10 = Util_CreateLocString("What the fuck did you do to get the entire Red Army after us Anton?!")
        local Text11 = Util_CreateLocString("I just wanted his vodka! Is that so much to ask?!")
        local Text12 = Util_CreateLocString("Look around you and tell me what you think the answer is!!!")
        local Text13 = Util_CreateLocString("Apprently running for our lives is not enough to shut you two up!!!")

        local Text14 = Util_CreateLocString("I'm under attack! Requesting artillery support! Now!")

        local Text15 = Util_CreateLocString("Only women here?")
        local Text16 = Util_CreateLocString("Something about these women looks odd...")

        local Text17 = Util_CreateLocString("Ah God! I should have seen this coming! Get to cover now!")

        local Text18 = Util_CreateLocString("A true waste of good lives...")
        local Text19 = Util_CreateLocString("They just tried to dress up in women's clothes to kill us! You'll excuse me if I don't share your high opinions about them.")
        local Text20 = Util_CreateLocString("Do you think they just decided to dress in civilian clothing to kill you Anton? They follow orders just like any other person in any other army.")
        local Text21 = Util_CreateLocString("Despite their efforts, you just killed them, not the other way around, so show some respect.")
        local Text22 = Util_CreateLocString("The main casualty in war is always ordinary people, in truth,  they are no different from us...")

        local Text23 = Util_CreateLocString("Hey don't shoot! We're friendlies!")
        local Text24 = Util_CreateLocString("Whoa! Did you guys kill all these Soviets?")
        local Text25 = Util_CreateLocString("It was mostly Hans here, but I'll take the credit if he doesn't want it.")
        local Text26 = Util_CreateLocString("...")
        local Text27 = Util_CreateLocString("Wait... Tomi? Tomislav Novak?")
        local Text28 = Util_CreateLocString("ANTON!!! My God! What are you doing here?!")
        local Text29 = Util_CreateLocString("I was going to ask you the same thing!")
        local Text30 = Util_CreateLocString("Ah... your mother tasked me with bringing you home Anton. If I wasn't captured by the Soviets I might have found you sooner.")
        local Text31 = Util_CreateLocString("When was this?! When did you set out?")
        local Text32 = Util_CreateLocString("Almost a year ago I think.")
        local Text33 = Util_CreateLocString("Oh... oh... I see...")
        local Text34 = Util_CreateLocString("Tomi... everyone back home is dead. I'm deserting with my friends to claim the inheritance to the estate in Switzerland.")
        local Text35 = Util_CreateLocString("Oh good God... dead? And you're deserting? Amongst all this madness! You really put me in a strange position Anton.")
        local Text36 = Util_CreateLocString("Sorry Tomi, but I reckon my chances of surviving this war with the Wehrmacht isn't that high.")
        local Text37 = Util_CreateLocString("Urgh... I can't blame you. Fine, I guess it's time for me to go rogue.")
        local Text38 = Util_CreateLocString("And what about your friend Hans?")
        local Text39 = Util_CreateLocString("Oh I only met him an hour ago... Hey Hans! Do you want to join us? We're deserting!")
        local Text40 = Util_CreateLocString("...")
        local Text41 = Util_CreateLocString("Let's go...")

        local Text42 = Util_CreateLocString("Overwatch outpost is under attack! Get a light mortar barrage on that position now!")

        local Text43 = Util_CreateLocString("Bah! We're under attack! Call in spare shock units from the rear!")

        local Text44 = Util_CreateLocString("Is that a Tiger tank?")
        local Text45 = Util_CreateLocString("I wonder what it's doing alone out here...")
        local Text46 = Util_CreateLocString("What? Is that you Michael?!")
        local Text47 = Util_CreateLocString("Bachmann? Kurt? Since when did you take on the business of conducting suicide missions? Ha ha!")
        local Text48 = Util_CreateLocString("Wittman! You wonderful ass! What the hell are you doing here?! I heard you died on the western front!")
        local Text49 = Util_CreateLocString("Command substituted me with another poor guy on the day... unfortunately the rest of my crew were really killed...")
        local Text50 = Util_CreateLocString("They gave me this nice uniform and apparently everything is supposed to be fine. Anyway, you are either here on a suicide mission or deserting. So which is it?")
        local Text51 = Util_CreateLocString("Ah you know me! I've always wanted to go to Switzerland.")
        local Text52 = Util_CreateLocString("Huh... is that it? Well I'm actually here on a suicide mission.")
        local Text53 = Util_CreateLocString("But since nobody really expects me and the lads to return... I guess a slight detour to help an old friend past enemy defenses wouldn't matter much.")
        local Text54 = Util_CreateLocString("Are you sure about this Wittman? It could be dangerous up ahead...")
        local Text55 = Util_CreateLocString("You forget one crucial fact Bachmann... I'm Michael Wittman!")
        local Text56 = Util_CreateLocString("Heh... You pompous ass.")
        local Text57 = Util_CreateLocString("If only everyone had this much confidence in your abilities...")

        local Text58 = Util_CreateLocString("Ready or not Kurt, I'm moving out!")

        local Text59 = Util_CreateLocString("Shit! They have quite a few anti-tank guns in that fortification. You guys should clear it out before we move on.")
        local Text60 = Util_CreateLocString("No wonder he is legendary... he is probably the only one alive after every battle if he gets others to fight them like this...")

        local Text61 = Util_CreateLocString("I'm moving forward. Try to keep up!")

        local Text62 = Util_CreateLocString("I see an enemy artillery position on that small high ground. You guys should neutralize it before we proceed.")
        local Text63 = Util_CreateLocString("He's losing my respect at an incredibly fast rate right now.")

        local Text64 = Util_CreateLocString("Nice work everyone! I've been doing some observation while you were away...")
        local Text65 = Util_CreateLocString("There is a formidable series of Soviet trench defensive positions ahead.")
        local Text66 = Util_CreateLocString("Yes, I had a look too. There is no way to sneak past it.")
        local Text67 = Util_CreateLocString("There is no way to sneak past it and there is only one available path for your tank to attack Michael...")
        local Text68 = Util_CreateLocString("The rest of us should split into two groups. Otto and Ulrich will assault the left treeline with me...")
        local Text69 = Util_CreateLocString("Kurt, Anton, Tomislav and Hans can take the right river flank. Any objections?")
        local Text70 = Util_CreateLocString("Sounds good to me.")
        local Text71 = Util_CreateLocString("...")
        local Text72 = Util_CreateLocString("Good. Let's move!")

        local Text73 = Util_CreateLocString("Not bad guys! Not bad at all!")
        local Text74 = Util_CreateLocString("Fucking easy to say in your mobile pillbox...")
        local Text75 = Util_CreateLocString("Ha! That was really intense Wittman! But we made it!")
        local Text76 = Util_CreateLocString("Whoa! I think we may have been better at the internment camp. Right Hans?")
        local Text77 = Util_CreateLocString("...")
        local Text78 = Util_CreateLocString("Forget I asked...")

        local Text79 = Util_CreateLocString("Axis units approaching end of defensive area. Request immediate incendiary barrage on enemy infantry!")

        local Text80 = Util_CreateLocString("Enemy compound ahead. I should probably be vanguard, looks like a trap.")

        local Text81 = Util_CreateLocString("This is a terribly bad place to be. Dense shrubs on both sides. I can't see anything past them.")
        local Text82 = Util_CreateLocString("Agreed. Someone needs to scout ahead. Anton, take the lead!")
        local Text83 = Util_CreateLocString("What? Why does it he have to do it? He doesn't have much combat experience. I'll do it.")
        local Text84 = Util_CreateLocString("It's not a problem Tomi,  we've got each other's backs. I've been scouting ahead with these guys for weeks now. I'll be fine.")

        local Text85 = Util_CreateLocString("ANTON!!! NO!!!")
        local Text86 = Util_CreateLocString("FUCK! SHIT! Oh God... FUCK!!!")
        local Text87 = Util_CreateLocString("Get your fucking shit together and find yourselves some suitable weapons for this fight! NOW!!!")

        local Text88 = Util_CreateLocString("Those markings... the tank of Igor Oktyabrskaya! Ha ha ha! Finally! An enemy tanker worthy of a true challenge!")

        local Text89 = Util_CreateLocString("Anton... Oh God Anton... I'm so sorry...")
        local Text90 = Util_CreateLocString("... Do not cry...")
        local Text91 = Util_CreateLocString("Just... leave me be... please....")
        local Text92 = Util_CreateLocString("Friedrich, talk to me my friend.")
        local Text93 = Util_CreateLocString("Not again... not fucking AGAIN!")
        local Text94 = Util_CreateLocString("He volunteered to go Friedrich. In the end it wasn't you who made him do it, it was himself.")
        local Text95 = Util_CreateLocString("...")
        local Text96 = Util_CreateLocString("You boys should keep moving. This place isn't safe.")
        local Text97 = Util_CreateLocString("Listen to me Friedrich, these things happen. Get your act together!")
        local Text98 = Util_CreateLocString("Kurt! It's good to see you, I only wish we parted ways again in better situations...")
        local Text99 = Util_CreateLocString("We'll see each other again. I'm sure!")
        local Text100 = Util_CreateLocString("Take care of yourself. Take care of your friends. They are good people... they just don't all know it yet.")

        local Text101 = Util_CreateLocString("Overwatch calling Airfield Seven! Unidentified infantry attempting to leave the defensive zone. Request immediate bombing run!")

EVENTS.Start = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text1)
        Cmd_Move(Anton, mkr_antonto1)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text2)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Ostruppen, Text3)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text4)
        Cmd_Move(Friedrich, mkr_friedrichto)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text5)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text6)
        Cmd_Move(Anton, mkr_antonto2)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Ostruppen, Text7)
        Cmd_Move(Otto, mkr_ottoto)
        Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
        Camera_ResetToDefault()
        CTRL.WAIT()
end

EVENTS.Run = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Ostruppen, Text8)
        HintPoint_Remove(Hint1)
        HintPoint_Remove(Hint2)
        HintPoint_Remove(Hint3)
        HintPoint_Remove(Hint4)
        CTRL.WAIT()
end

EVENTS.Others = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text9)
        CTRL.WAIT()
end

EVENTS.Escape = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text10)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Ostruppen, Text11)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text12)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text13)
        CTRL.WAIT()
end

EVENTS.HQOfficer = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, Text14)
        CTRL.WAIT()
end

EVENTS.Village = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ulrich, Text15)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text16)
        CTRL.WAIT()
end

EVENTS.Ambush = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text17)
        CTRL.WAIT()
end

EVENTS.Exit = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text18)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Ostruppen, Text19)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text20)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text21)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text22)
        CTRL.WAIT()
end

EVENTS.Camp = function()

	CTRL.WAIT()
        Blip5 = UI_CreateMinimapBlip(Michael, 9000, BT_ObjectivePrimary)
        UI_DeleteMinimapBlip(Blip4)
        Cmd_Move(Kurt, mkr_campkurtto)
        Cmd_Move(Anton, mkr_campantonto)
        Cmd_Move(Friedrich, mkr_campfriedrichto)
        Cmd_Move(Ulrich, mkr_campulrichto)
        Cmd_Move(Otto, mkr_campottoto)
	CTRL.Actor_PlaySpeech(ACTOR.Ulrich, Text23)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text24)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jaksa, Text25)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text26)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Ostruppen, Text27)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jaksa, Text28)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Ostruppen, Text29)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jaksa, Text30)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Ostruppen, Text31)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jaksa, Text32)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Ostruppen, Text33)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Ostruppen, Text34)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jaksa, Text35)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Ostruppen, Text36)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jaksa, Text37)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text38)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jaksa, Text39)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text40)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text41)
        CTRL.WAIT()
        SGroup_SetInvulnerable(Jaksa, false)
        SGroup_SetInvulnerable(Hans, false)
        Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
        Camera_ResetToDefault()
        CTRL.WAIT()
end

EVENTS.Outpost = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, Text42)
        CTRL.WAIT()
end

EVENTS.Arty = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, Text43)
        CTRL.WAIT()
end

EVENTS.Michael = function()

	CTRL.WAIT()
        World_GetCurrentInteractionStage()
        World_IncreaseInteractionStage()
        local EliteName8 = Util_CreateLocString("Michael Wittman")
        HintMouseover_Add(EliteName8, Michael, 5, true)
	CTRL.Actor_PlaySpeech(ACTOR.Jaksa, Text44)
        Blip6 = UI_CreateMinimapBlip(mkr_blip6, 9000, BT_ObjectivePrimary)
        UI_DeleteMinimapBlip(Blip5)
        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)
        SGroup_SetPlayerOwner(Michael, player3)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Ostruppen, Text45)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text46)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text47)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text48)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text49)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text50)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text51)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text52)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text53)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text54)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text55)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text56)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ulrich, Text57)
        Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
        Camera_ResetToDefault()
        CTRL.WAIT()
end

EVENTS.MichaelGo = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text58)
        CTRL.WAIT()
end

EVENTS.MichaelBack = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text59)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ulrich, Text60)
        CTRL.WAIT()
end

EVENTS.MichaelGoTwo = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text61)
        CTRL.WAIT()
end

EVENTS.MichaelArty = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text62)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Ostruppen, Text63)
        CTRL.WAIT()
end

EVENTS.MichaelTrench = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text64)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text65)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text66)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text67)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text68)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text69)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text70)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text71)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text72)
        Cmd_Move(Michael, mkr_michaelto9)
        Cmd_Move(Friedrich, mkr_trenchfriedrich1)
        Cmd_Move(Ulrich, mkr_trenchulrich1)
        Cmd_Move(Otto, mkr_trenchotto1)
        SGroup_SetInvulnerable(Friedrich, true)
        SGroup_SetInvulnerable(Ulrich, true)
        SGroup_SetInvulnerable(Otto, true)
        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)
        local player6 = World_GetPlayerAt(6)
        SGroup_SetPlayerOwner(Friedrich, player3)
        SGroup_SetPlayerOwner(Ulrich, player3)
        SGroup_SetPlayerOwner(Otto, player3)
        CTRL.WAIT()
end

EVENTS.MichaelTrenchFinish = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text73)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ulrich, Text74)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text75)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jaksa, Text76)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text77)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jaksa, Text78)
        CTRL.WAIT()
end

EVENTS.Last = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, Text79)
        CTRL.WAIT()
end

EVENTS.MichaelLast = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text80)
        CTRL.WAIT()
end

EVENTS.FinaleBegin = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jaksa, Text81)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text82)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jaksa, Text83)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Ostruppen, Text84)
        CTRL.WAIT()
        EGroup_Kill(FinaleBridge)
        Cmd_Move(Anton, mkr_finaleantonto2)
        CTRL.WAIT()
end

EVENTS.AntonDies = function()

	CTRL.WAIT()
        Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
        Camera_ResetToDefault()
	CTRL.Actor_PlaySpeech(ACTOR.Jaksa, Text85)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text86)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text87)
        Blip10 = UI_CreateMinimapBlip(Michael, 9000, BT_ObjectivePrimary)
        UI_DeleteMinimapBlip(Blip9)
        CTRL.WAIT()
end

EVENTS.Boss = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text88)
        CTRL.WAIT()
end

EVENTS.Ending = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jaksa, Text89)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text90)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jaksa, Text91)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text92)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text93)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text94)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text95)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text96)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text97)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text98)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text99)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text100)
        CTRL.WAIT()
        Game_EndSP(true)

end

EVENTS.OverwatchBarrage = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, Text101)
        CTRL.WAIT()
end

