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

        World_EnableSharedLineOfSight(player1, player2, false)

end
Scar_AddInit(OnGameSetup)

function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

function OnInit()

        Cinematic()

        Custom()

        Rule_AddDelayedInterval(CustomFailsafe, 1, 1)

        Hint()

        EliteHint()

        Retreat()

        PrisonEvent()

        VillageEvent()

        UlrichEvent()

        Rule_AddDelayedInterval(ChurchEvent, 1, 1)

        OttoEvent()

        AntonEvent()

        FriedrichEvent()

        Elites()

        Upgrade()

        BuildingRestrict()

        Rule_AddDelayedInterval(Lose, 1, 1)

end

Scar_AddInit(OnInit)

function Cinematic()

	Util_StartIntel(EVENTS.Intro)
        Blip1 = UI_CreateMinimapBlip(Point1, 9000, BT_ObjectivePrimary)
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
        Camera_SetZoomDist(6)
        Camera_Follow(Kurt)
        Cmd_Move(Kurt, mkr_to1)

end

function Custom()

        AI_EnableAll(false)

end

function CustomFailsafe()

        AI_EnableAll(false)

end


------------------------------Hints---------------------------

function Hint()

        HintKurt()
        Rule_AddDelayedInterval(HintBarrier, 0.1, 0.1)
        Rule_AddDelayedInterval(HintTerritory, 0.1, 0.1)
        Rule_AddDelayedInterval(HintAmbush, 0.1, 0.1)
        Rule_AddDelayedInterval(HintRoad, 0.1, 0.1)
        Rule_AddDelayedInterval(HintGuns, 0.1, 0.1)

        Rule_AddDelayedInterval(HintGunsRemove, 0.1, 0.1)

end

function HintKurt()

        local TextHint1 = Util_CreateLocString("Kurt (your grenadier) is an elite unit. Elite units are much harder to kill than normal units")
        local TextHint2 = Util_CreateLocString("Always check all friendly and enemy units to see which are elite units. You can identify elite units by hovering your mouse over them and seeing their special title")
        local TextHint3 = Util_CreateLocString("If Kurt or any other central character dies under your care, you lose the game")

        Hint1 = HintPoint_Add(mkr_hint1, true, TextHint1)
        Hint2 = HintPoint_Add(mkr_hint2, true, TextHint2)
        Hint3 = HintPoint_Add(mkr_tank4, true, TextHint3)

end

function HintBarrier()

        local Control = SGroup_IsUnderAttack(StartCons, false, 9000)
        if Control == true then
                local TextHint = Util_CreateLocString("The more obstacles between you and your target, the higher the chances of shots missing its target")
                Hint9 = HintPoint_Add(mkr_barrierhint, true, TextHint)
                Rule_RemoveMe()
        end
end

function HintTerritory()

        local Control = SGroup_Count(StartCons)
        if Control == 0 then
                local TextHint8 = Util_CreateLocString("Capture territory points to unlock its retreat point and sometimes it may also unlock parts of the map")
                local TextHint11 = Util_CreateLocString("You can pick up medical packs to restore health for your squads")
                Hint8 = HintPoint_Add(Point1, true, TextHint8)
                Hint11 = HintPoint_Add(mkr_hintmedic, true, TextHint11)
                HintPoint_Remove(Hint9)
                Rule_RemoveMe()
        end
end

function HintAmbush()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_hintambushtrigger, false)
        if Control == true then
                local TextHint10 = Util_CreateLocString("Be weary of areas outside your line of sight. They may hide ambushers. Approach these areas carefully")
                local TextHint = Util_CreateLocString("Only the general area of your primary objectives will be indicated on your minimap. Secondary objectives will be up to you to find and will not be displayed on your minimap")
                Hint10 = HintPoint_Add(mkr_hintambush, true, TextHint10)
                Hint26 = HintPoint_Add(mkr_objectivehint, true, TextHint)
                Rule_RemoveMe()
        end
end

function HintRoad()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_hintroad, false)
        if Control == true then
                local TextHint6 = Util_CreateLocString("Not all enemy units are worth engaging. Sometimes it is best to find a way around the enemy")
                local TextHint7 = Util_CreateLocString("Try to exploit gaps in enemy defenses")
                Hint6 = HintPoint_Add(mkr_engagehint1, true, TextHint6)
                Hint7 = HintPoint_Add(mkr_engagehint2, true, TextHint7)
                Rule_RemoveMe()
        end
end

function HintGuns()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_gunstrigger, false)
        if Control == true then
                local TextHint4 = Util_CreateLocString("Picking up a weapon is a one-way process. You cannot drop a weapon after picking one up, so think carefully before you pick it up, or don't pick up a weapon at all")
                local TextHint5 = Util_CreateLocString("Not all weapons are general improvements to your performance. Some weapons hamper your performance depending on your situation, so choose carefully")
                Hint4 = HintPoint_Add(mkr_gunhint1, true, TextHint4)
                Hint5 = HintPoint_Add(mkr_gunhint2, true, TextHint5)
                HintPoint_Remove(Hint6)
                HintPoint_Remove(Hint7)
                Rule_RemoveMe()
        end
end

function HintGunsRemove()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_hintend, false)
        if Control == true then
                HintPoint_Remove(Hint4)
                HintPoint_Remove(Hint5)
                Rule_RemoveMe()
        end
end


function EliteHint()

        local EliteName1 = Util_CreateLocString("Kurt Bachmann")
        local EliteName2 = Util_CreateLocString("Elite Penal Squad")
        local EliteName3 = Util_CreateLocString("Ulrich Goldmund")
        local EliteName4 = Util_CreateLocString("Friedrich Althaus")
        local EliteName5 = Util_CreateLocString("Anton Constantin")
        local EliteName6 = Util_CreateLocString("Otto Baasch")
        local EliteName7 = Util_CreateLocString("31st Elite Guards Rifles")
        local EliteName8 = Util_CreateLocString("Wilhelm Apel")
        local EliteName9 = Util_CreateLocString("Congratulations! You've found an easter egg! These guys will be hidden within other maps of the campaign. Find them all and be the thorough explorer you know you were always meant to be!")

        HintMouseover_Add(EliteName1, Kurt, 5, true)
        HintMouseover_Add(EliteName2, StartPenals, 5, true)
        HintMouseover_Add(EliteName3, Ulrich, 5, true)
        HintMouseover_Add(EliteName4, Friedrich, 5, true)
        HintMouseover_Add(EliteName5, Anton, 5, true)
        HintMouseover_Add(EliteName6, Otto, 5, true)
        HintMouseover_Add(EliteName7, EliteGuards, 5, true)
        HintMouseover_Add(EliteName8, Officer1, 5, true)
        HintMouseover_Add(EliteName9, EasterEgg, 5, true)

end

-------------------------Point Event-------------------------

function Retreat()

        Rule_AddDelayedInterval(PointFirst, 1, 1)
        Rule_AddDelayedInterval(SeePenal, 1, 1)
        Rule_AddDelayedInterval(PenalDead, 1, 1)

end

function PointFirst()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)

        local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat2, 1)
        local PointOne = EGroup_IsCapturedByPlayer(Point1, player1, false)
        if PointOne == true then
                local DestroyEntity = EGroup_GetSpawnedEntityAt(Retreat1, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity)
                Cmd_Move(StartPenals, mkr_startpenalsto)
	        Rule_AddOneShot(StartPenalsTrigger, 4)
                Rule_RemoveMe()
        end

end

function StartPenalsTrigger()

        Cmd_Move(Officer1, mkr_officer)
        Cmd_Move(Tank1, mkr_tank1)
        Cmd_Move(Tank2, mkr_tank2)
        Cmd_Move(Tank3, mkr_tank3)
        Cmd_Move(Tank4, mkr_tank4)
        Cmd_Move(Unit1, mkr_unit1)
        Cmd_Move(Unit2, mkr_unit2)
        Cmd_Move(Unit3, mkr_unit3)
        Cmd_Move(Unit4, mkr_unit4)
        HintPoint_Remove(Hint1)
        HintPoint_Remove(Hint2)
        HintPoint_Remove(Hint3)
        Rule_RemoveMe()

end

function PenalDead()

        local Count = SGroup_Count(StartPenals)
        if Count == 0 then
                Util_StartIntel(EVENTS.Officer)
                SGroup_FaceMarker(Tank1, mkr_tankfacing)
                SGroup_FaceMarker(Tank2, mkr_tankfacing)
                SGroup_FaceMarker(Tank3, mkr_tankfacing)
                SGroup_FaceMarker(Tank4, mkr_tankfacing)
                Blip2 = UI_CreateMinimapBlip(Otto, 9000, BT_ObjectivePrimary)
                UI_DeleteMinimapBlip(Blip1)
                World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                Rule_RemoveMe()
        end
end


------------------------------Prison Event--------------------------

function PrisonEvent()

        Rule_AddDelayedInterval(EventTrigger, 1, 1)

end

function EventTrigger()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_eventtrigger, false)
        if Control == true then
                SGroup_SetPlayerOwner(Otto, player1)
	        Camera_SetInputEnabled(false)
	        Game_SetMode(UI_Cinematic)
                Camera_Follow(Otto)
                Camera_SetZoomDist(15)
                Util_StartIntel(EVENTS.Prison)
                Rule_RemoveMe()
        end

end

-----------------------------Village Event--------------------------

function VillageEvent()

        Rule_AddDelayedInterval(VillageTrigger, 1, 1)
        Rule_AddDelayedInterval(PanzerMove, 1, 1)
        Rule_AddDelayedInterval(PanzerDeath, 1, 1)
        Rule_AddDelayedInterval(TankDeath, 1, 1)

end

function VillageTrigger()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_villagetrigger1, false)
        if Control == true then
                Cmd_Move(Grenadier1, mkr_grenadierto)
                Rule_AddOneShot(GrenadierDeath, 2)
                Rule_RemoveMe()
        end

end

function GrenadierDeath()

        SGroup_Kill(Grenadier1)

end

function PanzerMove()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_panzertrigger, false)
        if Control == true then
                local Direction = Marker_GetDirection(mkr_bombtarget)
                SGroup_SetPlayerOwner(Panzer, player2)
                SGroup_SetPlayerOwner(SovietTank, player3)
                Cmd_Move(Panzer, mkr_panzerto)
                Cmd_Move(SovietTank, mkr_t34to)
                Cmd_Ability(player3, ABILITY.SOVIET.IL_2_PRECISION_BOMB_STRIKE, mkr_bombtarget, Direction, true)
                Rule_RemoveMe()
        end
end

function PanzerDeath()

        local Control = SGroup_GetAvgHealth(Panzer)
        if Control < 0.65 then
                SGroup_Kill(Panzer)
        end

end

function TankDeath()

        local Control = SGroup_Count(Panzer)
        if Control == 0 then
                SGroup_Kill(SovietTank)
        end

end

----------------------------Ulrich Event---------------------

function UlrichEvent()

        Rule_AddDelayedInterval(HelpUlrich, 1, 1)
        Rule_AddDelayedInterval(UlrichSecond, 1, 1)
        Rule_AddDelayedInterval(TruckUnload, 1, 1)
        Rule_AddDelayedInterval(TruckDeath, 1, 1)
        Rule_AddDelayedInterval(UldrichEnd, 1, 1)

end

function HelpUlrich()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_ulrichtrigger, false)
        local Control2 = Prox_ArePlayersNearMarker(player1, mkr_ulrichtrigger2, false)
        if Control1 == true or Control2 == true then
                Util_StartIntel(EVENTS.Ulrich)
                SGroup_SetInvulnerable(Ulrich, false)
                SGroup_SetInvulnerable(PenalTrigger, false)
                local TextHint1 = Util_CreateLocString("This is a quicktime event - you must complete the objective before your comrade dies")
                local TextHint2 = Util_CreateLocString("Flanking enemy units from the sides or rear deals greater damage to them")
                Hint15 = HintPoint_Add(mkr_hintulrich1, true, TextHint1)
                Hint16 = HintPoint_Add(mkr_hintulrich2, true, TextHint2)
                Command_SquadSquadLoad(player3, ConsLoad, SCMD_Load, Truck, false, true)
                Command_SquadSquadLoad(player3, ShockLoad, SCMD_Load, Truck, false, true)
                Rule_RemoveMe()
        end

end

function UlrichSecond()

        local Control = SGroup_Count(PenalTrigger)
        if Control == 0 then
                SGroup_SetAvgHealth(Ulrich, 1.0)
                local TextHint3 = Util_CreateLocString("Don't forget to use your unit abilities while in combat. You can use your panzerfaust ability to damage vehicles")
                Hint17 = HintPoint_Add(Truck, true, TextHint3)
                Cmd_Move(Truck, mkr_truckto)
                Rule_RemoveMe()
        end
end

function TruckUnload()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)

        local Control = Prox_ArePlayersNearMarker(player3, mkr_truckto, false)
        if Control == true then
                Command_Squad(player3, Truck, SCMD_UnloadSquads, false)
                Rule_RemoveMe()
        end
end

function TruckDeath()

        local Control = SGroup_GetAvgHealth(Truck)
        if Control < 0.9 then
                SGroup_Kill(Truck)
                Rule_RemoveMe()
        end

end

function UldrichEnd()

        local Control = SGroup_Count(UldrichTotal)
        if Control == 0 then
                Util_StartIntel(EVENTS.UlrichFinish)
                World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                HintPoint_Remove(Hint15)
                HintPoint_Remove(Hint16)
                HintPoint_Remove(Hint17)
                Rule_RemoveMe()
        end

end

--------------------------Church Event------------------------

function ChurchEvent()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)

        local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat3, 1)
        local PointOne = EGroup_IsCapturedByPlayer(Point2, player1, false)
        if PointOne == true then
                local DestroyEntity = EGroup_GetSpawnedEntityAt(Retreat2, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity)
                Util_StartIntel(EVENTS.Kurt)
                Blip5 = UI_CreateMinimapBlip(Otto, 9000, BT_ObjectivePrimary)
                UI_DeleteMinimapBlip(Blip4)
                World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                Rule_RemoveMe()
        end

end 

--------------------------Otto Event--------------------------

function OttoEvent()

        Rule_AddDelayedInterval(HelpOtto, 1, 1)
        Rule_AddDelayedInterval(HillSecond, 1, 1)
        Rule_AddDelayedInterval(HillThird, 1, 1)
        Rule_AddDelayedInterval(HillFourth, 1, 1)
        Rule_AddDelayedInterval(OttoWin, 1, 1)
end

function HelpOtto()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_ottotrigger, false)
        if Control == true then
                Util_StartIntel(EVENTS.Otto)
                Rule_RemoveMe()
        end

end

function HillSecond()

        local Count = SGroup_Count(HillOne)
        if Count == 0 then
                SGroup_WarpToMarker(HillTwo, mkr_hillspawn)
                SGroup_SetAvgHealth(Otto, 1.0)
                Cmd_Move(Otto, mkr_ottoto1)
                Rule_AddOneShot(HillTwoMove, 1)
                Rule_RemoveMe()
        end
end

function HillTwoMove()

        Cmd_Move(HillTwo, mkr_hill2)
        local TextHint2 = Util_CreateLocString("Certain abilities such as your rifle grenade ability cannot be used if the target is at a steep elevation compared to your position")
        Hint27 = HintPoint_Add(mkr_hintuphill, true, TextHint2)

end

function HillThird()

        local Count = SGroup_Count(HillTwo)
        if Count == 0 then
                SGroup_WarpToMarker(HillThree, mkr_hillspawn)
                SGroup_SetAvgHealth(Otto, 1.0)
                Cmd_Move(Otto, mkr_ottoto2)
                Rule_AddOneShot(HillThreeMove, 1)
                local TextHint1 = Util_CreateLocString("Enemy machine guns or anti-tank guns will not change direction after being deployed. Use this to plan your tactics.")
                Hint14 = HintPoint_Add(HillThree, true, TextHint1)
                Rule_RemoveMe()
        end
end

function HillThreeMove()

        Cmd_Move(HillThree, mkr_hill3)

end

function HillFourth()

        local Count = SGroup_Count(HillThree)
        if Count == 0 then
                Cmd_Move(Otto, mkr_ottoto3)
        end
end

function OttoWin()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)

        local Control = Prox_ArePlayersNearMarker(player2, mkr_ottoto3, false)
        if Control == true then
                Util_StartIntel(EVENTS.OttoFinish)
                HintPoint_Remove(Hint27)
                World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                Rule_RemoveMe()
        end

end

-----------------------------Anton Event--------------------------

function AntonEvent()

        Rule_AddDelayedInterval(HelpAnton, 1, 1)
        Rule_AddDelayedInterval(AntonSight, 1, 1)
        Rule_AddDelayedInterval(HalftrackUnload, 1, 1)
        Rule_AddDelayedInterval(AntonWin, 1, 1)

end

function HelpAnton()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_antontrigger, false)
        if Control == true then
                Command_SquadSquadLoad(player3, EliteGuards, SCMD_Load, Halftrack, false, true)
                Util_StartIntel(EVENTS.Anton)
                HintPoint_Remove(Hint14)
                local TextHint1 = Util_CreateLocString("Sometimes other central characters will be placed under your command. If they die under your care, you will lose the game")
                local TextHint2 = Util_CreateLocString("Using your head is always important. Find a way to destroy this halftrack with what you have")
                Hint20 = HintPoint_Add(mkr_antonhide, true, TextHint1)
                Hint21 = HintPoint_Add(Halftrack, true, TextHint2)
                Rule_RemoveMe()
        end

end

function AntonSight()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)

        local Control = Prox_ArePlayersNearMarker(player3, mkr_antonsight, false)
        if Control == true then
                Util_StartIntel(EVENTS.AntonPanic)
                Rule_RemoveMe()
        end
end

function HalftrackUnload()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)

        local Control = Prox_ArePlayersNearMarker(player3, mkr_halftrackto, false)
        if Control == true then
                Command_Squad(player3, Halftrack, SCMD_UnloadSquads, false)
                Rule_RemoveMe()
        end
end

function AntonWin()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)

        local Count = SGroup_Count(SouthGroup)
        if Count == 0 then
                SGroup_SetPlayerOwner(Anton, player2)
                Util_StartIntel(EVENTS.AntonFinish)
                World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                HintPoint_Remove(Hint20)
                HintPoint_Remove(Hint21)
                Rule_RemoveMe()
        end
end

------------------------------Friedrich Event--------------------------

function FriedrichEvent()

        Rule_AddDelayedInterval(HelpFriedrich, 1, 1)
        Rule_AddDelayedInterval(CommissarCall, 1, 30)
        Rule_AddDelayedInterval(FriedrichWin, 1, 1)

end

function HelpFriedrich()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)

        local Control = Prox_ArePlayersNearMarker(player1, mkr_friedrichtrigger, false)
        if Control == true then
                Util_StartIntel(EVENTS.Friedrich)
                SGroup_SetPlayerOwner(Friedrich, player1)
                local TextHint1 = Util_CreateLocString("There is usually more than one way to complete an objective. Look around and plan accordingly.")
                local TextHint2 = Util_CreateLocString("All enemy officers has an ability that call in airstrikes, artillery barrages or unit reinforcements once attacked. This ability will continue until the officer is killed")
                Hint22 = HintPoint_Add(mkr_hintcommissar, true, TextHint1)
                Hint23 = HintPoint_Add(Commissar, true, TextHint2)
                FOW_RevealArea(Marker_GetPosition(mkr_commissarreveal), 5, -1)
                Rule_RemoveMe()
        end
end

function CommissarCall()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)

        local Control = SGroup_IsUnderAttackByPlayer(Commissar, player1, 9000)
        if Control == true then
                local Target = Player_GetSquadConcentration(player1)
                Cmd_Ability(player3, ABILITY.SOVIET.IL_2_PRECISION_BOMB_STRIKE, Target, nil, true)
                Util_StartIntel(EVENTS.Commissar)
        end
end

function FriedrichWin()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)

        local Count = SGroup_Count(EndGroup)
        if Count == 0 then
                SGroup_SetPlayerOwner(Friedrich, player2)
                Util_StartIntel(EVENTS.FriedrichFinish)
                HintPoint_Remove(Hint22)
                HintPoint_Remove(Hint23)
                Rule_RemoveMe()
        end
end

------------------------------Elites----------------------------

function Elites()

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
        SGroup_IncreaseVeterancyRank(Otto, 3, false)
        SGroup_IncreaseVeterancyRank(Ulrich, 3, false)
        SGroup_IncreaseVeterancyRank(Friedrich, 3, false)
        SGroup_IncreaseVeterancyRank(Anton, 3, false)

        Modify_ReceivedDamage(StartPenals, 0.8)
        Modify_ReceivedDamage(EliteGuards, 0.8)
        SGroup_IncreaseVeterancyRank(StartPenals, 3, false)
        SGroup_IncreaseVeterancyRank(EliteGuards, 1, false)

end


function SeePenal()

        local Control = SGroup_CanSeeSGroup(Kurt, StartPenals, false)

        if Control == true then
                Util_StartIntel(EVENTS.Panic)
                Rule_RemoveMe()
        end

end

------------------------------Upgrades-----------------------------

function Upgrade()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)

        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
        Player_SetAbilityAvailability(player1, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player1, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
        Player_SetAbilityAvailability(player2, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player2, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)

        Player_SetUpgradeAvailability(player1, UPG.GERMAN.GRENADIER_MG42_LMG, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.GERMAN.GRENADIER_MG42_LMG_MP, ITEM_REMOVED)

        Player_AddAbility(player3, BP_GetAbilityBlueprint("il-2_precision_bomb_strike"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("il-2_bomb_Strike"))

end

function BuildingRestrict()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)

        Player_SetEntityProductionAvailability(player1, EBP.GERMAN.BUNKER_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.GERMAN.SLIT_TRENCH_GERMAN_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.GERMAN.SLIT_TRENCH_GERMAN, ITEM_REMOVED)

end

-------------------------------Lose-----------------------------

function Lose()

        local Control1 = SGroup_Count(Kurt)
        local Control2 = SGroup_Count(Otto)
        local Control3 = SGroup_Count(Anton)
        local Control4 = SGroup_Count(Friedrich)
        local Control5 = SGroup_Count(Ulrich)
        if Control1 == 0 or Control2 == 0 or Control3 == 0 or Control4 == 0 or Control5 == 0 then
                Game_EndSP(false)
        end
end



------------------------------Events and Actors--------------------

ACTOR = {
	
	__scardoc_enum = true,

	None					= "",

        Friedrich = "Icons_portraits_unit_german_panzer_grenadiers_w_portrait",
        Ulrich = "Icons_portraits_unit_german_grenadiers_w_portrait",

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

        local Text1 = Util_CreateLocString("Kurt, come over here!")
        local Text2 = Util_CreateLocString("Here commander Apel!")
        local Text3 = Util_CreateLocString("You are a capable soldier. There are two Soviets at the crossroads ahead.")
        local Text4 = Util_CreateLocString("Put the Soviets down and secure the crossroads Kurt.")
        local Text5 = Util_CreateLocString("Alone?")
        local Text6 = Util_CreateLocString("Would you like the column to be discovered Kurt? Yes alone! We'll help out if you get into trouble.")

        local Text7 = Util_CreateLocString("Fuck! Four of them, and they look like veterans!")

        local Text8 = Util_CreateLocString("Don't shit yourself Kurt. We're here...")
        local Text9 = Util_CreateLocString("Now, go to the labour camp to the north, through the woods behind me.")
        local Text10 = Util_CreateLocString("Don't worry, there's friendlies on the other side. You can take care of yourself. Now go!")

        local Text11 = Util_CreateLocString("The Soviets are closing in. We have no more time to move these prisoners.")
        local Text12 = Util_CreateLocString("So what do we do with them?")
        local Text13 = Util_CreateLocString("Kill them. Then meet at the rendez vous point.")
        local Text14 = Util_CreateLocString("Yes sir!")
        local Text15 = Util_CreateLocString("You are all free to go.")
        local Text16 = Util_CreateLocString("What?")
        local Text17 = Util_CreateLocString("The war is almost over. Nobody else needs to die in this war, now go, and don't get caught.")
        local Text18 = Util_CreateLocString("Thank you! Thank you! Come comrades, let's get out of here.")
        local Text19 = Util_CreateLocString("What the...")
        local Text20 = Util_CreateLocString("How much of that did you hear?")
        local Text21 = Util_CreateLocString("All of it... If you are deserters, then I want in. But only if you have a plan.")
        local Text22 = Util_CreateLocString("My name is Friedrich, and this is Otto, he has a family in Switzerland, we plan to hold out there until the war passes.")
        local Text23 = Util_CreateLocString("Come join us my friend. I don't think one more for my family will matter too much.")
        local Text24 = Util_CreateLocString("Anton is my name. We could always use another helping hand.")
        local Text25 = Util_CreateLocString("Greetings, I'm Ulrich, a pleasure to meet you.")
        local Text26 = Util_CreateLocString("I'm Kurt Bachmann. I guess I am coming with you. What do we do now?")
        local Text27 = Util_CreateLocString("There is a weapons cache east of here, you can go there to gear up or meet us back at your tank column.")
        local Text28 = Util_CreateLocString("We'll discuss more once you're at the column.")

        local Text29 = Util_CreateLocString("Hey Kurt! Help me out! Flank those Soviets fast!")

        local Text30 = Util_CreateLocString("Nice shot Kurt!")
        local Text31 = Util_CreateLocString("Good. I think this road is safe for now. I'll keep an eye on it. You better secure the church first and get an idea of what's going on.")
        local Text32 = Util_CreateLocString("Then go help Otto, I heard him screaming for help not long ago.")

        local Text33 = Util_CreateLocString("Um... looks like there is only one man covering each road. This is going to be a challenge...")

        local Text34 = Util_CreateLocString("Oh it's you! Good timing.")
        local Text35 = Util_CreateLocString("The Soviets are coming down from the high ground. I need to get to that high ground to secure this road. Help me get there Kurt!")

        local Text36 = Util_CreateLocString("Oh God... thanks for the help... that was intense...")
        local Text37 = Util_CreateLocString("But I'm safe now. You should go check on Anton in the west. He is probably talking the enemy to death...")

        local Text38 = Util_CreateLocString("Good good! You're here! Everything is pretty quiet here!")
        local Text39 = Util_CreateLocString("I guess the Soviet dogs know just how scary I am eh? Ha!")
        local Text40 = Util_CreateLocString("Wait... do you hear that?")

        local Text41 = Util_CreateLocString("Oh fuck! Get out of its sight now!!!")
        local Text42 = Util_CreateLocString("There are some supplies in the village market. Go get them and we'll destroy this little group.")

        local Text43 = Util_CreateLocString("Phew! Looks like that's it! I'm... I mean we are so damn good at this.")
        local Text44 = Util_CreateLocString("Go check on Friedrich, he's might have spotted something useful... like a Soviet officer or something.")

        local Text45 = Util_CreateLocString("Hey Kurt, look. A Soviet officer.")
        local Text46 = Util_CreateLocString("I guarantee you if we kill him, this Soviet assault will be over.")
        local Text47 = Util_CreateLocString("This is typical of Soviets, no command, no assault.")
        local Text48 = Util_CreateLocString("We have to find a way to kill that officer!")

        local Text49 = Util_CreateLocString("I am under attack! Request immediate bombing run!!!")

        local Text50 = Util_CreateLocString("Urgh... it's quite ironic really...")
        local Text51 = Util_CreateLocString("We saved some Soviets today only to have other Soviets try to kill us on the same day.")
        local Text52 = Util_CreateLocString("You did the right thing. Killing should be reserved only for self-defence.")
        local Text53 = Util_CreateLocString("I hope you're right Kurt. Because we will need hearts of iron to get to Switzerland...")
        local Text54 = Util_CreateLocString("I'm sure we all have iron hearts Friedrich. Of that, I am certain.")

EVENTS.Intro = function()

	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text1)
        Cmd_Move(Kurt, mkr_to1)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text2)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text3)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text4)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text5)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text6)
        CTRL.WAIT()
        Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
        Camera_ResetToDefault()
end

EVENTS.Panic = function()

	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text7)
        CTRL.WAIT()
end

EVENTS.Officer = function()

	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text8)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text9)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text10)
        CTRL.WAIT()
end

EVENTS.Prison = function()

	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text11)
        Cmd_Move(Kurt, mkr_eventtrigger)
        SGroup_SuggestPosture(Anton, 2, 120)
        SGroup_SuggestPosture(Friedrich, 2, 120)
        SGroup_SuggestPosture(Otto, 2, 120)
        SGroup_SuggestPosture(Ulrich, 2, 120)
        HintPoint_Remove(Hint8)
        HintPoint_Remove(Hint10)
        HintPoint_Remove(Hint11)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text12)
        SGroup_SetWorldOwned(Otto)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text13)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text14)
        CTRL.WAIT()
        Cmd_Move(Officer2, mkr_officer2to)
	CTRL.Event_Delay(5)
        CTRL.WAIT()
        local Unit = SGroup_GetSpawnedSquadAt(Officer2, 1)
        Squad_Destroy(Unit)
        CTRL.WAIT()
        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        SGroup_FaceEachOther(Anton, Prisoner)
        SGroup_FaceEachOther(Friedrich, Prisoner)
        SGroup_FaceEachOther(Ulrich, Prisoner)
        SGroup_FaceEachOther(Otto, Prisoner)
        Cmd_Move(Kurt, mkr_kurtto)
        CTRL.Event_Delay(2)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text15)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, Text16)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text17)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, Text18)
        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        SGroup_SetPlayerOwner(Prisoner, player2)
        SGroup_SetPlayerOwner(Prisoner2, player2)
        CTRL.WAIT()
        Cmd_Move(Prisoner, mkr_engagehint2)
        Cmd_Move(Prisoner2, mkr_engagehint2)
        SGroup_FaceEachOther(Anton, Kurt)
        SGroup_FaceEachOther(Friedrich, Kurt)
        SGroup_FaceEachOther(Ulrich, Kurt)
        SGroup_FaceEachOther(Otto, Kurt)
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text19)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text20)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text21)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text22)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text23)
        local ConsPrisoner1 = SGroup_GetSpawnedSquadAt(Prisoner, 1)
        local ConsPrisoner2 = SGroup_GetSpawnedSquadAt(Prisoner2, 1)
        Squad_Destroy(ConsPrisoner1)
        Squad_Destroy(ConsPrisoner2)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Ostruppen, Text24)
        local ConvoyUnit1 = SGroup_GetSpawnedSquadAt(Tank3, 1)
        local ConvoyUnit2 = SGroup_GetSpawnedSquadAt(Unit4, 1)
        Squad_Destroy(ConvoyUnit1)
        Squad_Destroy(ConvoyUnit2)
        SGroup_Kill(Officer1)
        SGroup_Kill(Tank1)
        SGroup_Kill(Tank2)
        SGroup_Kill(Tank4)
        SGroup_Kill(Unit1)
        SGroup_Kill(Unit2)
        SGroup_Kill(Unit3)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ulrich, Text25)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text26)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text27)
        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        SGroup_SetPlayerOwner(Anton, player2)
        SGroup_SetPlayerOwner(Otto, player2)
        SGroup_SetPlayerOwner(Friedrich, player2)
        SGroup_SetPlayerOwner(Ulrich, player2)
        SGroup_SetInvulnerable(Ulrich, true)
        SGroup_SetInvulnerable(PenalTrigger, true)
        Camera_Follow(Kurt)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text28)
        Cmd_Move(Anton, mkr_eventtrigger)
        Cmd_Move(Friedrich, mkr_eventtrigger)
        Cmd_Move(Otto, mkr_eventtrigger)
        Cmd_Move(Ulrich, mkr_eventtrigger)
        Blip3 = UI_CreateMinimapBlip(Ulrich, 9000, BT_ObjectivePrimary)
        UI_DeleteMinimapBlip(Blip2)
        World_GetCurrentInteractionStage()
        World_IncreaseInteractionStage()
        CTRL.WAIT()
        SGroup_WarpToMarker(Anton, mkr_anton)
        SGroup_WarpToMarker(Ulrich, mkr_ulrich)
        SGroup_WarpToMarker(Otto, mkr_otto)
        SGroup_WarpToMarker(Friedrich, mkr_friedrich)
        Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
        Camera_ResetToDefault()
        CTRL.WAIT()
        
end

EVENTS.Ulrich = function()

	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ulrich, Text29)
        CTRL.WAIT()
end

EVENTS.UlrichFinish = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ulrich, Text30)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ulrich, Text31)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ulrich, Text32)
        Blip4 = UI_CreateMinimapBlip(Point2, 9000, BT_ObjectivePrimary)
        UI_DeleteMinimapBlip(Blip3)
        CTRL.WAIT()
end

EVENTS.Kurt = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text33)
        CTRL.WAIT()
end

EVENTS.Otto = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text34)
        SGroup_WarpToMarker(HillOne, mkr_hillspawn)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text35)
        Cmd_Move(HillOne, mkr_hill1)
        CTRL.WAIT()
end

EVENTS.OttoFinish = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text36)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text37)
        Blip6 = UI_CreateMinimapBlip(Anton, 9000, BT_ObjectivePrimary)
        UI_DeleteMinimapBlip(Blip5)
        CTRL.WAIT()
end

EVENTS.Anton = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Ostruppen, Text38)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Ostruppen, Text39)
        SGroup_WarpToMarker(Halftrack, mkr_southspawn)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Ostruppen, Text40)
        Cmd_Move(Halftrack, mkr_halftrackto)
        CTRL.WAIT()
end

EVENTS.AntonPanic = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Ostruppen, Text41)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Ostruppen, Text42)
        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        SGroup_SetPlayerOwner(Anton, player1)
        Cmd_Move(Anton, mkr_antonhide)
end

EVENTS.AntonFinish = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Ostruppen, Text43)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Ostruppen, Text44)
        Blip7 = UI_CreateMinimapBlip(Friedrich, 9000, BT_ObjectivePrimary)
        UI_DeleteMinimapBlip(Blip6)
        CTRL.WAIT()
end

EVENTS.Friedrich = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text45)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text46)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text47)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text48)
        CTRL.WAIT()
end

EVENTS.Commissar = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, Text49)
        CTRL.WAIT()
end

EVENTS.FriedrichFinish = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text50)
        UI_DeleteMinimapBlip(Blip7)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text51)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text52)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text53)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text54)
        CTRL.WAIT()
	Game_EndSP(true)
end






































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

function Third()

local player = World_GetPlayerAt(3)
Modify_PlayerResourceRate(player, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player, RT_Munition, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player, RT_Manpower, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player, RT_Action, 0, MUT_Multiplication)

end

Scar_AddInit(Third)

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
				manpower = 0,
				fuel = 0,
				munition = 0,
				action = 0,
				command = 016,
			},
			--player 3:
			[2] = {
				manpower = 0,
				fuel = 0,
				munition = 0,
				action = 0,
				command = 16,
			},
			--player 4:
			[3] = {
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
	end
end

Scar_AddInit(CustomStartingResources_Init)