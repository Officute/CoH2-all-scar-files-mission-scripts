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

        World_EnableSharedLineOfSight(player1, player2, false)

end
Scar_AddInit(OnGameSetup)

function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

function OnInit()

        Custom()

        Cinematic()

        Rule_AddOneShot(WeaponFailsafe, 1)

        Rule_AddDelayedInterval(CustomFailsafe, 1, 1)

        Rule_AddDelayedInterval(Easter, 1, 1)

        Community()

        Rule_AddDelayedInterval(ChitChat, 1, 1)

        CrossroadEvent()

        LakeEvent()

        VillageEvent()

        TowerEvent()

        ForestEvent()

        FinaleEvent()

        Elites()

        EliteHint()

        Upgrade()

        Points()

        Officers()

        Abilities()

        BuildingRestrict()

        Movement()

        Lose()

	Player_SetPopCapOverride(player3, 900)
	Player_SetPopCapOverride(player4, 900)
        Modify_DisableHold(BottomLeftTo, true)

end

Scar_AddInit(OnInit)

function Custom()

        AI_EnableAll(false)
        UI_SetAllowLoadAndSave(false)
        Modify_DisableHold(Watermill, true)
        SGroup_SetInvulnerable(VillageInvulnerable, true)
        SGroup_SetInvulnerable(OfficerInvulnerable, true)
        EGroup_SetInvulnerable(BridgeInvulnerable, true)
        Modify_DisableHold(FinaleHouses, true)
        Modify_EntityBuildTime(player1, EBP.WEST_GERMAN.SCHU_MINE_42_MP, 0.2)
        Command_Squad(player4, Simmons, SCMD_SlotItemRemove, false)
        Command_Squad(player4, Fitzgerald, SCMD_SlotItemRemove, false)
        Command_Squad(player4, SimmonsTwo, SCMD_SlotItemRemove, false)
        Command_Squad(player4, FitzgeraldTwo, SCMD_SlotItemRemove, false)
        Blip1 = UI_CreateMinimapBlip(Point1, 9000, BT_ObjectivePrimary)

end

function Cinematic()

	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
        Camera_Follow(Kurt)
        Camera_SetZoomDist(10)
        Util_StartIntel(EVENTS.Begin)

end

function WeaponFailsafe()

        local ControlEntity1 = SGroup_GetSpawnedSquadAt(Simmons, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.RIFLEMEN_M1918_BAR_MP)
        local ControlEntity2 = SGroup_GetSpawnedSquadAt(Fitzgerald, 1)
        Squad_GiveSlotItem(ControlEntity2, SLOT_ITEM.RIFLEMEN_M1918_BAR_MP)
        local ControlEntity3 = SGroup_GetSpawnedSquadAt(SimmonsTwo, 1)
        Squad_GiveSlotItem(ControlEntity3, SLOT_ITEM.RIFLEMEN_M1918_BAR_MP)
        local ControlEntity4 = SGroup_GetSpawnedSquadAt(FitzgeraldTwo, 1)
        Squad_GiveSlotItem(ControlEntity4, SLOT_ITEM.RIFLEMEN_M1918_BAR_MP)

end

function CustomFailsafe()

        AI_EnableAll(false)

end

function Easter()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_eastereggtrigger, false)
        if Control == true then
                local EggText = Util_CreateLocString("Oh hello! I'm just answering nature's call here. Did you know there is a radio tower south of the walled medieval village not far from here? I bet if you get inside that tower, you can find a working radio to mess around with! See? I am helpful!")
                HintMouseover_Add(EggText, EasterEgg, 5, true)
                Rule_RemoveMe()
        end
end

------------------------------Community---------------------------

function Community()

        Rule_AddDelayedInterval(ConsAppear, 1, 1)
        Rule_AddDelayedInterval(TextAppear, 1, 1)

end

function ConsAppear()

        local CommunityHint1 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 6 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Hidden)")
        local CommunityHint2 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 6 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Clearing)")
        local CommunityHint3 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 6 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Behind)")
        local CommunityHint4 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 6 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Guarded)")
        local CommunityHint5 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 6 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Tower's)")
        local CommunityHint6 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 6 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Shadow)")

        local Control = Prox_ArePlayersNearMarker(player1, mkr_conscomtrigger, false)
        local Random = World_GetRand(1, 6)
        if Control == true then
                Rule_RemoveMe()
                if Random == 1 then
                        HintMouseover_Add(CommunityHint1, CommunityCons, 5, true)
                elseif Random == 2 then
                        HintMouseover_Add(CommunityHint2, CommunityCons, 5, true)
                elseif Random == 3 then
                        HintMouseover_Add(CommunityHint3, CommunityCons, 5, true)
                elseif Random == 4 then
                        HintMouseover_Add(CommunityHint4, CommunityCons, 5, true)
                elseif Random == 5 then
                        HintMouseover_Add(CommunityHint5, CommunityCons, 5, true)
                elseif Random == 6 then
                        HintMouseover_Add(CommunityHint6, CommunityCons, 5, true)
                end
        end
end

function TextAppear()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_communitytrigger, false)
        if Control == true then
                local CommunityEggText = Util_CreateLocString("A note found on the soldier's hand reads: Target and his entourage has met with Himmelsdorf and engaged American forces. Target capture is likely. Recommend immediate strike force to fully terminate target.")
                HintMouseover_Add(CommunityEggText, CommunityEgg, 5, true)
                Rule_RemoveMe()
        end
end

-------------------------------ChitChat-----------------------------

function ChitChat()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_chattrigger, false)
        if Control == true then
                Util_StartIntel(EVENTS.Chat)
                Rule_RemoveMe()
        end
end

------------------------------CrossroadEvent----------------------------

function CrossroadEvent()

        Rule_AddDelayedInterval(LoadUnits, 1, 1)
        Rule_AddDelayedInterval(PatrolOne, 1, 1)
        Rule_AddDelayedInterval(PatrolTwo, 1, 1)
        Rule_AddDelayedInterval(ScoutCarAttack, 1, 1)
        Rule_AddDelayedInterval(CrossroadCounterattack, 1, 1)
        Rule_AddDelayedInterval(ConsAttack, 1, 1)
        Rule_AddDelayedInterval(TruckAttack, 1, 1)
        Rule_AddDelayedInterval(TruckUnload, 1, 1)

end

function LoadUnits()

        Command_SquadSquadLoad(player3, PatrolLoad1, SCMD_Load, PatrolCar1, false, true)
        Command_SquadSquadLoad(player3, PatrolLoad2, SCMD_Load, PatrolCar2, false, true)
        Command_SquadSquadLoad(player3, GuardsLoad, SCMD_Load, GuardsTruck, false, true)
        Command_SquadSquadLoad(player3, RiflesLoad, SCMD_Load, RiflesTruck, false, true)
        Command_SquadEntityLoad(player3, ConsRight, SCMD_Load, HouseRight, false, true)
        Command_SquadEntityLoad(player3, ConsLeft, SCMD_Load, HouseLeft, false, true)
        Command_SquadEntityLoad(player4, RadioMG, SCMD_Load, RadioTower, false, true)
        Rule_RemoveMe()

end

function PatrolOne()

        Cmd_SquadPatrolMarker(PatrolCar1, mkr_patrolfield)
        Rule_RemoveMe()

end

function PatrolTwo()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_patrol2totrigger, false)
        if Control == true then
                Cmd_Move(PatrolCar2, mkr_patrol2to)
        Rule_RemoveMe()
        end

end

function ScoutCarAttack()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_scoutcartrigger, false)
        if Control == true then
                Cmd_Move(ScoutCar, mkr_scoutcarto)
                Rule_RemoveMe()
        end

end

function CrossroadCounterattack()

        local Control = SGroup_Count(CrossroadCons)
        if Control == 0 then
                Cmd_Move(EngineerLeft, mkr_engineerleft)
                Cmd_Move(EngineerRight, mkr_engineerright)
                Cmd_Move(HalftrackCenter, mkr_scoutcarto)
                Rule_RemoveMe()
        end

end

function ConsAttack()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_consattacktrigger, false)
        if Control == true then
                Cmd_Move(ConsHideRight, mkr_consattackright)
                Cmd_AttackMove(ConsHideLeft, mkr_consattackleft)
                Rule_RemoveMe()
        end
end

function TruckAttack()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_guardstrucktrigger, false)
        if Control == true then
                Cmd_Move(GuardsTruck, mkr_guardstruckto)
                Rule_RemoveMe()
        end
end

function TruckUnload()

        local Control = Prox_ArePlayersNearMarker(player3, mkr_guardstruckto, false)
        if Control == true then
                Command_Squad(player3, GuardsTruck, SCMD_UnloadSquads, false)
                Rule_RemoveMe()
        end
end

------------------------------LakeEvent----------------------------

function LakeEvent()

        Rule_AddDelayedInterval(FightBegin, 1, 1)
        Rule_AddDelayedInterval(BridgeBottom, 1, 1)
        Rule_AddDelayedInterval(BridgeTop, 1, 1)

end

function FightBegin()

        local Control = Player_CanSeeSGroup(player1, VillageInvulnerable, false)
        if Control == true then
                SGroup_SetInvulnerable(VillageInvulnerable, false)
        end
end

function BridgeBottom()

        local Control = SGroup_IsUnderAttackByPlayer(PenalTrigger, player1, 9000)
        if Control == true then
                Cmd_Move(EngineerCounterattack, mkr_lakeengineerto)
                Cmd_Move(ConsGo, mkr_lakebridgeto)
                Rule_RemoveMe()
        end
end

function BridgeTop()

        local Control = SGroup_IsUnderAttackByPlayer(TopBridgeTrigger, player1, 9000)
        if Control == true then
                Cmd_Move(ShockGo, mkr_shockgo)
                Rule_RemoveMe()
        end
end

---------------------------Village Event-------------------------

function VillageEvent()

        Rule_AddDelayedInterval(CityCinematic, 1, 1)
        Rule_AddDelayedInterval(Suppression, 1, 1)
        Rule_AddDelayedInterval(SequenceTwo, 1, 1)
        Rule_AddDelayedInterval(SequenceThree, 1, 1)
        Rule_AddDelayedInterval(SequenceFour, 1, 1)
        Rule_AddDelayedInterval(SequenceFinale, 1, 1)

end

function CityCinematic()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_citytrigger, false)
        if Control == true then
	        Camera_SetInputEnabled(false)
	        Game_SetMode(UI_Cinematic)
                Camera_Follow(Kurt)
	        Util_StartIntel(EVENTS.City)
                Rule_RemoveMe()
        end
end

function Suppression()

        SGroup_SetSuppression(SovietGroup, 0)

end

function SequenceTwo()

        local Control = SGroup_Count(RaidStartGroup)
        if Control == 0 then
	        Util_StartIntel(EVENTS.Two)
                Rule_RemoveMe()
        end
end

function SequenceThree()

        local Control1 = SGroup_Count(SovietGroup)
        local Control2 = SGroup_Count(SequenceThreeControl)
        if Control1 == 0 and Control2 == 0 then
	        Util_StartIntel(EVENTS.Three)
                Rule_RemoveMe()
        end
end

function SequenceFour()

        local Control = SGroup_Count(SequenceThreeGroup)
        if Control == 0 then
	        Util_StartIntel(EVENTS.Four)
                Rule_RemoveMe()
        end
end

function SequenceFinale()

        local Control = SGroup_Count(SequenceFourGroup)
        if Control == 0 then
	        Util_StartIntel(EVENTS.SequenceEnd)
                Rule_RemoveMe()
        end
end

----------------------------Tower Event----------------------------

function TowerEvent()

        Rule_AddDelayedInterval(RangersCounterattack, 1, 1)
        Rule_AddDelayedInterval(RadioTrigger, 1, 1)
        Rule_AddDelayedInterval(RadioStuart, 1, 1)
        Rule_AddDelayedInterval(RadioCamp, 1, 1)
        Rule_AddDelayedInterval(RadioHalftrack, 1, 1)
        Rule_AddDelayedInterval(RadioStraif, 1, 1)

end

function RangersCounterattack()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_rangermovetrigger, false)
        if Control == true then
                Cmd_Move(RangersMove, mkr_rangermoveto)
                Rule_RemoveMe()
        end
end

function RadioTrigger()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_towertrigger, false)
        if Control == true then
	        Util_StartIntel(EVENTS.Radio)
                Rule_RemoveMe()
        end
end

function RadioStuart()

        local Control1 = SGroup_Count(RadioControl)
        local Control2 = SGroup_CanSeeSGroup(PlayerGroup, StuartTank, false)
        if Control1 == 0 and Control2 == true then
                local Direction = Marker_GetDirection(mkr_stuartdirection)
                Cmd_Ability(player2, ABILITY.GERMAN.STUKA_SMOKE_BOMB, mkr_stuartto, Direction, true)
                Rule_RemoveMe()
        end
end

function RadioCamp()

        local Control1 = SGroup_Count(RadioControl)
        local Control2 = SGroup_IsUnderAttackByPlayer(CampTrigger, player1, 9000)
        if Control1 == 0 and Control2 == true then
                local Direction = Marker_GetDirection(mkr_fragbombdirection)
                Cmd_Ability(player2, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB, mkr_fragbomb, Direction, true)
                Cmd_Ability(player2, ABILITY.GERMAN.STUKA_SMOKE_BOMB, mkr_campsmoke, Direction, true)
                Rule_RemoveMe()
        end
end

function RadioHalftrack()

        local Control1 = SGroup_Count(RadioControl)
        local Control2 = SGroup_CanSeeSGroup(PlayerGroup, PatrolHalftrack, false)
        if Control1 == 0 and Control2 == true then
                local Direction = Marker_GetDirection(mkr_stuartdirection)
                Cmd_Ability(player2, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT, mkr_closeairsupport, Direction, true)
                Cmd_Ability(player2, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT, mkr_closeairsupport, Direction, true)
                Rule_RemoveMe()
        end
end

function RadioStraif()

        local Control1 = SGroup_Count(RadioControl)
        local Control2 = SGroup_CanSeeSGroup(PlayerGroup, AmericanCenter, false)
        if Control1 == 0 and Control2 == true then
                local Direction = Marker_GetDirection(mkr_straifingrundirection)
                Cmd_Ability(player2, ABILITY.GERMAN.STUKA_STRAFING_RUN, mkr_straifingrun, Direction, true)
                Rule_RemoveMe()
        end
end

-----------------------------Forest Event-----------------------------

function ForestEvent()

        Rule_AddDelayedInterval(MortarFieldFailsafe, 1, 1)
        Rule_AddDelayedInterval(MortarForestFailsafe, 1, 1)
        Rule_AddDelayedInterval(VehicleAttack, 1, 1)
        Rule_AddDelayedInterval(ForestAmbush, 1, 1)
        Rule_AddDelayedInterval(EliteAmericanMove, 1, 1)

end

function MortarFieldFailsafe()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_mortarfieldtrigger, false)
        if Control == true then
                Cmd_Move(MovingMortar, mkr_mortarbottomto)
        end
end

function MortarForestFailsafe()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_mortarforesttrigger, false)
        if Control == true then
                Cmd_Move(MovingMortar, mkr_mortartopto)
        end
end

function VehicleAttack()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_vehicletrigger, false)
        if Control == true then
                Cmd_Move(StuartTank, mkr_stuartto)
        end
end

function ForestAmbush()

        local Control = SGroup_CanSeeSGroup(PlayerGroup, AmbushAttackers, false)
        if Control == true then
                Cmd_AttackMove(AmbushAttackers, mkr_ambushcommandosto)
                Cmd_Move(AmbushCommandos, mkr_ambushcommandosto)
                Cmd_Move(AmbushCar, mkr_ambushcarto)
                Cmd_Move(RiflesTruck, mkr_riflestruckto)
                Rule_RemoveMe()
        end
end

function EliteAmericanMove()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_eliteamericantrigger, false)
        if Control == true then
                Cmd_AttackMove(EliteAmerican, mkr_eliteamericanto)
                Rule_RemoveMe()
        end
end


------------------------------Finale Event-----------------------

function FinaleEvent()

        Rule_AddDelayedInterval(ParadropForever, 1, 90)
        Rule_AddDelayedInterval(OfficerDialogue, 1, 1)
        Rule_AddDelayedInterval(OfficerRemove, 1, 1)
        Rule_AddDelayedInterval(SectionOne, 1, 1)
        Rule_AddDelayedInterval(SectionTwo, 1, 1)
        Rule_AddDelayedInterval(SectionThree, 1, 1)
        Rule_AddDelayedInterval(SectionFour, 1, 1)
        Rule_AddDelayedInterval(EndingStart, 1, 1)
        Rule_AddDelayedInterval(EndingFinish, 1, 1)

end

function ParadropForever()

        local Control = SGroup_Count(FinaleControl)
        if Control == 0 then
                local Target = Player_GetSquadConcentration(player1)
                local Direction = Marker_GetDirection(mkr_direction)
                Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, Target, Direction, true)
        end
end

function OfficerDialogue()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_majordialoguetrigger, false)
        if Control == true then
	        Util_StartIntel(EVENTS.Major)
                SGroup_Kill(FinaleControl)
                Rule_RemoveMe()
        end
end

function OfficerRemove()

        local Control = Prox_ArePlayersNearMarker(player4, mkr_officerteleporttrigger, false)
        if Control == true then
                SGroup_DestroyAllSquads(OfficerInvulnerable)
                Rule_RemoveMe()
        end
end

function SectionOne()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_sectiononetrigger, false)
        if Control == true then
                Cmd_Move(RearEchelonMove, mkr_rearechelonmoveto)
                Cmd_Move(RearRiflesMove, mkr_rearriflesmoveto)
                Rule_RemoveMe()
        end
end

function SectionTwo()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_sectiontwotrigger, false)
        if Control == true then
                Cmd_Move(RifleSupport, mkr_riflesupportto)
                Cmd_Move(RearRiflesMove, mkr_rearriflesmoveto)
                Rule_RemoveMe()
        end
end

function SectionThree()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_sectionthreetrigger, false)
        if Control == true then
                Cmd_Move(AmericanRight, mkr_americanrightto)
                Cmd_Move(AmericanLeft, mkr_americanleftto)
                Cmd_Move(AmericanCenter, mkr_americancenterto)
                Rule_RemoveMe()
        end
end

function SectionFour()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_sectionfourtrigger, false)
        if Control == true then
                Command_SquadEntityLoad(player4, ParaLeft, SCMD_Load, ParaLeftHouse, false, true)
                Cmd_Move(RangerLeft, mkr_rangerleftto)
                Cmd_Move(ParaRight, mkr_pararightto)
                Cmd_Move(RangerRight, mkr_rangerrightto)
                Rule_RemoveMe()
        end
end

function EndingStart()

        local Control = Prox_ArePlayersNearMarker(player1, mkr_endingtrigger, false)
        if Control == true then
	        Camera_SetInputEnabled(false)
	        Game_SetMode(UI_Cinematic)
                Camera_Follow(Kurt)
                Util_StartIntel(EVENTS.EndStart)
                Rule_RemoveMe()
        end
end

function EndingFinish()

        local Control1 = SGroup_CanSeeSGroup(PlayerGroup, SurpriseGroupLeft, false)
        local Control2 = SGroup_CanSeeSGroup(PlayerGroup, SurpriseGroupRight, false)
        if Control1 == true or Control2 == true then
                SGroup_SetInvulnerable(Kurt, true)
                SGroup_SetInvulnerable(Otto, true)
                SGroup_SetInvulnerable(Friedrich, true)
                SGroup_SetInvulnerable(Hans, true)
                SGroup_SetInvulnerable(Jozef, true)
                Util_StartIntel(EVENTS.EndEnd)
                Rule_RemoveMe()
        end
end



------------------------------Elites----------------------------

function Elites()

        Modify_ReceivedDamage(Kurt, 0.4)
        Modify_ReceivedAccuracy(Kurt, 0.8)
        Modify_ReceivedDamage(Ulrich, 0.4)
        Modify_ReceivedAccuracy(Ulrich, 0.8)
        Modify_ReceivedDamage(Otto, 0.2)
        Modify_ReceivedAccuracy(Otto, 0.7)
        Modify_ReceivedDamage(Friedrich, 0.5)
        Modify_ReceivedAccuracy(Friedrich, 0.5)
        Modify_ReceivedDamage(Tomislav, 0.5)
        Modify_ReceivedAccuracy(Tomislav, 0.4)
        Modify_ReceivedDamage(Hans, 0.2)
        Modify_ReceivedAccuracy(Hans, 0.9)
        Modify_ReceivedDamage(Jozef, 0.5)
        Modify_ReceivedAccuracy(Jozef, 0.6)

        Modify_ReceivedDamage(EliteBottomEngineer, 0.5)
        Modify_ReceivedAccuracy(EliteBottomEngineer, 0.8)
        Modify_ReceivedDamage(EliteBottomPenal, 0.7)
        Modify_ReceivedAccuracy(EliteBottomPenal, 0.7)
        Modify_ReceivedDamage(EliteTopShock, 0.7)
        Modify_ReceivedAccuracy(EliteTopShock, 0.6)
        Modify_ReceivedDamage(Himmelsdorf, 0.9)
        Modify_ReceivedAccuracy(Himmelsdorf, 0.9)
        Modify_ReceivedDamage(EliteAmerican, 0.7)
        Modify_ReceivedAccuracy(EliteAmerican, 0.7)
        Modify_ReceivedDamage(Mid2Officer, 0.4)
        Modify_ReceivedAccuracy(Mid2Officer, 0.4)
        Modify_ReceivedDamage(Adams, 0.1)
        Modify_ReceivedAccuracy(Adams, 0.1)
        Modify_ReceivedDamage(Simmons, 0.1)
        Modify_ReceivedAccuracy(Simmons, 0.1)
        Modify_ReceivedDamage(Fitzgerald, 0.1)
        Modify_ReceivedAccuracy(Fitzgerald, 0.1)
        Modify_ReceivedDamage(ParaLeft, 0.8)
        Modify_ReceivedAccuracy(ParaLeft, 0.8)


end

function EliteHint()

        local EliteName1 = Util_CreateLocString("Kurt Bachmann")
        local EliteName2 = Util_CreateLocString("Ulrich Goldmund")
        local EliteName3 = Util_CreateLocString("Friedrich Althaus")
        local EliteName4 = Util_CreateLocString("Otto Baasch")
        local EliteName5 = Util_CreateLocString("Tomislav Novak")
        local EliteName6 = Util_CreateLocString("Hans Dunkel")
        local EliteName7 = Util_CreateLocString("Jozef Smrek")

        HintMouseover_Add(EliteName1, Kurt, 5, true)
        HintMouseover_Add(EliteName2, Ulrich, 5, true)
        HintMouseover_Add(EliteName3, Friedrich, 5, true)
        HintMouseover_Add(EliteName4, Otto, 5, true)
        HintMouseover_Add(EliteName5, Tomislav, 5, true)
        HintMouseover_Add(EliteName6, Hans, 5, true)
        HintMouseover_Add(EliteName7, Jozef, 5, true)

        local EliteName8 = Util_CreateLocString("Veteran Vanguard Engineers")
        HintMouseover_Add(EliteName8, EliteBottomEngineer, 5, true)
        SGroup_IncreaseVeterancyRank(EliteBottomEngineer, 2, false)
        local EliteName9 = Util_CreateLocString("3rd NKVD Attachment")
        HintMouseover_Add(EliteName9, EliteBottomPenal, 5, true)
        SGroup_IncreaseVeterancyRank(EliteBottomPenal, 1, false)
        local EliteName10 = Util_CreateLocString("Elite Shock Vanguards")
        HintMouseover_Add(EliteName10, EliteTopShock, 5, true)
        SGroup_IncreaseVeterancyRank(EliteTopShock, 1, false)
        local EliteName11 = Util_CreateLocString("Elite 'Himmelsdorf' Task Force")
        HintMouseover_Add(EliteName11, BotGren, 5, true)
        HintMouseover_Add(EliteName11, BotAss, 5, true)
        HintMouseover_Add(EliteName11, BotJaeger, 5, true)
        HintMouseover_Add(EliteName11, BotCar, 5, true)
        HintMouseover_Add(EliteName11, MidGren, 5, true)
        HintMouseover_Add(EliteName11, MidAss, 5, true)
        HintMouseover_Add(EliteName11, MidVolk, 5, true)
        HintMouseover_Add(EliteName11, TopGren, 5, true)
        HintMouseover_Add(EliteName11, TopAss, 5, true)
        HintMouseover_Add(EliteName11, TopJaeger, 5, true)
        HintMouseover_Add(EliteName11, TopVolk, 5, true)
        HintMouseover_Add(EliteName11, TopCar, 5, true)
        HintMouseover_Add(EliteName11, TopKubel, 5, true)
        SGroup_IncreaseVeterancyRank(Himmelsdorf, 2, false)
        local EliteName12 = Util_CreateLocString("5th Expert Specialist Engineers")
        HintMouseover_Add(EliteName12, EliteAmerican, 5, true)
        SGroup_IncreaseVeterancyRank(EliteAmerican, 2, false)
        local EliteName13 = Util_CreateLocString("Lieutenant Roebuck")
        HintMouseover_Add(EliteName13, Mid2Officer, 5, true)
        SGroup_IncreaseVeterancyRank(Mid2Officer, 3, false)
        local EliteName14 = Util_CreateLocString("Major Adams")
        HintMouseover_Add(EliteName14, Adams, 5, true)
        SGroup_IncreaseVeterancyRank(Adams, 3, false)
        local EliteName15 = Util_CreateLocString("Captain Simmons")
        HintMouseover_Add(EliteName15, Simmons, 5, true)
        SGroup_IncreaseVeterancyRank(Simmons, 3, false)
        local EliteName16 = Util_CreateLocString("Captain Fitzgerald")
        HintMouseover_Add(EliteName16, Fitzgerald, 5, true)
        SGroup_IncreaseVeterancyRank(Fitzgerald, 3, false)
        local EliteName17 = Util_CreateLocString("Special Eagle Command Attachment")
        HintMouseover_Add(EliteName17, ParaLeft, 5, true)
        SGroup_IncreaseVeterancyRank(ParaLeft, 2, false)

        local EliteName18 = Util_CreateLocString("Major Adams")
        HintMouseover_Add(EliteName18, AdamsTwo, 5, true)
        SGroup_IncreaseVeterancyRank(AdamsTwo, 3, false)
        local EliteName19 = Util_CreateLocString("Captain Simmons")
        HintMouseover_Add(EliteName19, SimmonsTwo, 5, true)
        SGroup_IncreaseVeterancyRank(SimmonsTwo, 3, false)
        local EliteName20 = Util_CreateLocString("Captain Fitzgerald")
        HintMouseover_Add(EliteName20, FitzgeraldTwo, 5, true)
        SGroup_IncreaseVeterancyRank(FitzgeraldTwo, 3, false)


end

------------------------------Upgrades-----------------------------

function Upgrade()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)

        local ControlEntity = SGroup_GetSpawnedSquadAt(Hans, 1)
        Squad_GiveSlotItem(ControlEntity, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_NO_PRONE_MP)
        local ControlEntity2 = SGroup_GetSpawnedSquadAt(EliteBottomEngineer, 1)
        Squad_GiveSlotItem(ControlEntity2, SLOT_ITEM.ROKS_2_FLAMETHROWER_ITEM_MP)
        Squad_GiveSlotItem(ControlEntity2, SLOT_ITEM.ROKS_2_FLAMETHROWER_ITEM_MP)
        local ControlEntity3 = SGroup_GetSpawnedSquadAt(EliteBottomPenal, 1)
        Squad_GiveSlotItem(ControlEntity3, SLOT_ITEM.DP_28_LIGHT_MACHINE_GUN_PACKAGE_MOVING_NO_PRONE_MP)
        local ControlEntity4 = SGroup_GetSpawnedSquadAt(EliteTopShock, 1)
        Squad_GiveSlotItem(ControlEntity4, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_NO_PRONE_MP)
        local ControlEntity5 = SGroup_GetSpawnedSquadAt(EliteAmerican, 1)
        Squad_GiveSlotItem(ControlEntity5, SLOT_ITEM.RIFLEMEN_M1918_BAR_MP)
        Squad_GiveSlotItem(ControlEntity5, SLOT_ITEM.RIFLEMEN_M1918_BAR_MP)
        local ControlEntity6 = SGroup_GetSpawnedSquadAt(ParaLeft, 1)
        Squad_GiveSlotItem(ControlEntity6, SLOT_ITEM.RIFLEMEN_30_CAL)
        Squad_GiveSlotItem(ControlEntity6, SLOT_ITEM.RIFLEMEN_M1918_BAR_MP)

        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("building_1"))
        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("building_2"))
        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("building_3"))
        Player_SetAbilityAvailability(player1, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player1, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)
		Player_SetAbilityAvailability(player1, ABILITY.WEST_GERMAN.VOLKSGRENADIER_FIRE_GRENADE_MP, ITEM_UNLOCKED)
		
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("building_1"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("building_2"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("building_3"))
        Player_SetAbilityAvailability(player2, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player2, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)
		Player_SetAbilityAvailability(player1, ABILITY.WEST_GERMAN.VOLKSGRENADIER_FIRE_GRENADE_MP, ITEM_UNLOCKED)

        Player_SetAbilityAvailability(player1, ABILITY.WEST_GERMAN.PIONEER_VOLKS_SALVAGE, ITEM_REMOVED)
        Player_SetAbilityAvailability(player1, ABILITY.WEST_GERMAN.THROUGH_SALVAGE, ITEM_REMOVED)
        Player_SetAbilityAvailability(player1, ABILITY.WEST_GERMAN.MG34_DISPATCH, ITEM_REMOVED)
        Player_SetAbilityAvailability(player1, ABILITY.WEST_GERMAN.ASSAULT_PIONEER_DROP_MEDPACK_ABILITY_MP, ITEM_REMOVED)

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
		
		Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.VOLKS_STG44_UPGRADE, ITEM_UNLOCKED)	
		

end

function Abilities()

        Player_AddAbility(player3, BP_GetAbilityBlueprint("il-2_precision_bomb_strike"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("il-2_bomb_Strike"))
        Player_AddAbility(player3, BP_GetAbilityBlueprint("major_artillery"))
        Player_AddAbility(player3, BP_GetAbilityBlueprint("light_support_artillery"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("light_artillery_support"))
        Player_AddAbility(player3, BP_GetAbilityBlueprint("fire_artillery"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("fire_artillery"))

        Player_AddAbility(player4, BP_GetAbilityBlueprint("time_on_target_artillery"))
        Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("time_on_target_artillery"))
        Player_AddAbility(player4, BP_GetAbilityBlueprint("p47_recon_mp"))
        Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("p47_recon"))
        Player_AddAbility(player4, BP_GetAbilityBlueprint("p47_rocket_attack"))
        Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("p47_rocket_attack"))
        Player_AddAbility(player4, BP_GetAbilityBlueprint("major_quick_recon_run"))
        Player_AddAbility(player4, BP_GetAbilityBlueprint("major_quick_recon_run_improved"))
        Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("recon_sweep"))
        Player_AddAbility(player4, BP_GetAbilityBlueprint("paratroopers_paradrop"))
        Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("paratroopers"))
        Player_AddAbility(player4, BP_GetAbilityBlueprint("glider_headquarters"))
        Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("ability_lock_out_glider_custom_loadout_launch_available"))
        Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("ability_lock_out_glider_hard_landed"))
        Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("ability_lock_out_glider_not_stopped"))
        Player_AddAbility(player4, BP_GetAbilityBlueprint("major_artillery"))

        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("stuka_fragmentation_bomb"))
        Player_AddAbility(player2, BP_GetAbilityBlueprint("stuka_fragmentation_bomb"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("stuka_close_air_support"))
        Player_AddAbility(player2, BP_GetAbilityBlueprint("stuka_close_air_support"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("stuka_smoke_bomb"))
        Player_AddAbility(player2, BP_GetAbilityBlueprint("stuka_smoke_bomb"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("stuka_flame_strike"))
        Player_AddAbility(player2, BP_GetAbilityBlueprint("stuka_incendiary_bombs"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("stuka_strafe"))
        Player_AddAbility(player2, BP_GetAbilityBlueprint("stuka_strafing_run"))

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
		
end

-----------------------------Officers-----------------------------

function Officers()

        Rule_AddDelayedInterval(OfficerSaw, 1, 45)
        Rule_AddDelayedInterval(LieutenantOfficer, 1, 30)

end

function OfficerSaw()

        local Control1 = SGroup_IsUnderAttackByPlayer(SawOfficer, player1, 9000)
        local Control2 = SGroup_Count(ConsSpawn)
        if Control1 == true and Control2 < 2 then
	        Util_CreateSquads(player3, ConsSpawn, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_officerspawn)
                Util_StartIntel(EVENTS.Saw)
        end
end

function LieutenantOfficer()

        local Control1 = SGroup_IsUnderAttackByPlayer(Mid2Officer, player1, 9000)
        local Control2 = SGroup_IsUnderAttackByPlayer(Mid2Officer, player2, 9000)
        if Control1 == true or Control2 == true then
                local Target = Player_GetSquadConcentration(player1)
                Cmd_Ability(player4, ABILITY.AEF.MAJOR_ARTILLERY, Target, nil, true)
                Util_StartIntel(EVENTS.LieutenantAttack)
        end
end

----------------------------Points-------------------------------

function Points()

        Rule_AddDelayedInterval(PointOne, 1, 1)
        Rule_AddDelayedInterval(PointTwo, 1, 1)
        Rule_AddDelayedInterval(PointThree, 1, 1)
        Rule_AddDelayedInterval(PointFour, 1, 1)
        Rule_AddDelayedInterval(PointFive, 1, 1)
        Rule_AddDelayedInterval(PointSix, 1, 1)
        Rule_AddDelayedInterval(PointSeven, 1, 1)

end

function PointOne()

        local PointFocus = EGroup_IsCapturedByPlayer(Point1, player1, false)
        if PointFocus == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat1, 1)
                local DestroyEntity = EGroup_GetSpawnedEntityAt(Retreat, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity)
                Blip2 = UI_CreateMinimapBlip(Point3, 9000, BT_ObjectivePrimary)
                UI_DeleteMinimapBlip(Blip1)
                World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                Rule_RemoveMe()
        end
end

function PointTwo()

        local PointFocus = EGroup_IsCapturedByPlayer(Point2, player1, false)
        if PointFocus == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat2, 1)
                local DestroyEntity = EGroup_GetSpawnedEntityAt(Retreat1, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity)
                World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                Rule_RemoveMe()
        end
end

function PointThree()

        local PointFocus = EGroup_IsCapturedByPlayer(Point3, player1, false)
        if PointFocus == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat3, 1)
                local DestroyEntity = EGroup_GetSpawnedEntityAt(Retreat2, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity)
                FOW_RevealMarker(mkr_sight1, 9000)
                FOW_RevealMarker(mkr_sight2, 9000)
                FOW_RevealMarker(mkr_sight3, 9000)
                FOW_RevealMarker(mkr_sight4, 9000)
                FOW_RevealMarker(mkr_sight5, 9000)
	        Util_StartIntel(EVENTS.Village)
                Rule_RemoveMe()
        end
end

function PointFour()

        local PointFocus = EGroup_IsCapturedByPlayer(Point4, player1, false)
        if PointFocus == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat4, 1)
                local DestroyEntity = EGroup_GetSpawnedEntityAt(Retreat3, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity)
                World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                Blip4 = UI_CreateMinimapBlip(Point5, 9000, BT_ObjectivePrimary)
                UI_DeleteMinimapBlip(Blip3)
                Rule_RemoveMe()
        end
end

function PointFive()

        local PointFocus = EGroup_IsCapturedByPlayer(Point5, player1, false)
        if PointFocus == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat5, 1)
                local DestroyEntity = EGroup_GetSpawnedEntityAt(Retreat4, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity)
                World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                Blip5 = UI_CreateMinimapBlip(Point6, 9000, BT_ObjectivePrimary)
                UI_DeleteMinimapBlip(Blip4)
                Rule_RemoveMe()
        end
end

function PointSix()

        local PointFocus = EGroup_IsCapturedByPlayer(Point6, player1, false)
        if PointFocus == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat6, 1)
                local DestroyEntity = EGroup_GetSpawnedEntityAt(Retreat5, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity)
                World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                Blip6 = UI_CreateMinimapBlip(Point7, 9000, BT_ObjectivePrimary)
                UI_DeleteMinimapBlip(Blip5)
                Rule_RemoveMe()
        end
end

function PointSeven()

        local PointFocus = EGroup_IsCapturedByPlayer(Point7, player1, false)
        if PointFocus == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat7, 1)
                local DestroyEntity = EGroup_GetSpawnedEntityAt(Retreat6, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity)
                World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                Blip7 = UI_CreateMinimapBlip(AdamsTwo, 9000, BT_ObjectivePrimary)
                UI_DeleteMinimapBlip(Blip6)
                Rule_RemoveMe()
        end
end

-----------------------------Movement-----------------------------

function Movement()

        Rule_AddDelayedInterval(SovietOne, 1, 1)
        Rule_AddDelayedInterval(SovietTwo, 1, 1)
        Rule_AddDelayedInterval(SovietThree, 1, 1)
        Rule_AddDelayedInterval(SovietFour, 1, 1)
        Rule_AddDelayedInterval(SovietFive, 1, 1)
        Rule_AddDelayedInterval(ShermanThird, 1, 1)
        Rule_AddDelayedInterval(HalftrackMoveTop, 1, 1)
        Rule_AddDelayedInterval(HalftrackMoveBottom, 1, 1)
        Rule_AddDelayedInterval(SovietMoving, 1, 1)
        Rule_AddDelayedInterval(EnemyFirst, 1, 1)
        Rule_AddDelayedInterval(EnemySecond, 1, 1)
        Rule_AddDelayedInterval(EnemyThird, 1, 1)
        Rule_AddDelayedInterval(EnemyFourth, 1, 1)
        Rule_AddDelayedInterval(EnemyFifth, 1, 1)

end

function SovietOne()

        local Control = Prox_ArePlayersNearMarker(player3, mkr_sovietleftto, false)
        if Control == true then
                Cmd_AttackMove(SovietLeft, mkr_sovietgroupto)
        end
end

function SovietTwo()

        local Control = Prox_ArePlayersNearMarker(player3, mkr_sovietmidtoone, false)
        if Control == true then
                Cmd_Move(SovietMid, mkr_sovietmidtotwo)
        end
end

function SovietThree()

        local Control = Prox_ArePlayersNearMarker(player3, mkr_sovietrighttoone, false)
        if Control == true then
                Cmd_Move(SovietRight, mkr_sovietrighttotwo)
        end
end

function SovietFour()

        local Control = Prox_ArePlayersNearMarker(player3, mkr_sovietmidtotwo, false)
        if Control == true then
                Cmd_AttackMove(SovietMid, mkr_sovietgroupto)
        end
end

function SovietFive()

        local Control = Prox_ArePlayersNearMarker(player3, mkr_sovietrighttotwo, false)
        if Control == true then
                Cmd_AttackMove(SovietRight, mkr_sovietgroupto)
        end
end

function ShermanThird()

        local Control = Prox_ArePlayersNearMarker(player4, mkr_shermanthreetoone, false)
        if Control == true then
                Cmd_Move(ShermanThree, mkr_shermanthreetotwo)
        end
end

function HalftrackMoveTop()

        local Control = Prox_ArePlayersNearMarker(player4, mkr_halftracktopto, false)
        if Control == true then
                Cmd_Move(PatrolHalftrack, mkr_halftrackbottomto)
        end
end

function HalftrackMoveBottom()

        local Control = Prox_ArePlayersNearMarker(player4, mkr_halftrackbottomto, false)
        if Control == true then
                Cmd_Move(PatrolHalftrack, mkr_halftracktopto)
        end
end

function SovietMoving()

        Cmd_AttackMove(SovietGroup, mkr_sovietgroupto)

end

function EnemyFirst()

        local Control = Prox_ArePlayersNearMarker(player4, mkr_raid1, false)
        local Unit1 = Prox_AreSquadMembersNearMarker(RaidCar1, mkr_raid1, false)
        local Unit2 = Prox_AreSquadMembersNearMarker(RaidCar2, mkr_raid1, false)
        local Unit3 = Prox_AreSquadMembersNearMarker(RaidHalftrack, mkr_raid1, false)
        if Control == true then
                if Unit1 == true then
                        Cmd_Move(RaidCar1, mkr_raid2)
                elseif Unit2 == true then
                        Cmd_Move(RaidCar2, mkr_raid2)
                elseif Unit3 == true then
                        Cmd_Move(RaidHalftrack, mkr_raid5)
                end
        end
end

function EnemySecond()

        local Control = Prox_ArePlayersNearMarker(player4, mkr_raid2, false)
        local Unit1 = Prox_AreSquadMembersNearMarker(RaidCar1, mkr_raid2, false)
        local Unit2 = Prox_AreSquadMembersNearMarker(RaidCar2, mkr_raid2, false)
        local Unit3 = Prox_AreSquadMembersNearMarker(RaidHalftrack, mkr_raid2, false)
        if Control == true then
                if Unit1 == true then
                        Cmd_Move(RaidCar1, mkr_raid3)
                elseif Unit2 == true then
                        Cmd_Move(RaidCar2, mkr_raid3)
                elseif Unit3 == true then
                        Cmd_Move(RaidHalftrack, mkr_raid1)
                end
        end
end

function EnemyThird()

        local Control = Prox_ArePlayersNearMarker(player4, mkr_raid3, false)
        local Unit1 = Prox_AreSquadMembersNearMarker(RaidCar1, mkr_raid3, false)
        local Unit2 = Prox_AreSquadMembersNearMarker(RaidCar2, mkr_raid3, false)
        local Unit3 = Prox_AreSquadMembersNearMarker(RaidHalftrack, mkr_raid3, false)
        if Control == true then
                if Unit1 == true then
                        Cmd_Move(RaidCar1, mkr_raid4)
                elseif Unit2 == true then
                        Cmd_Move(RaidCar2, mkr_raid4)
                elseif Unit3 == true then
                        Cmd_Move(RaidHalftrack, mkr_raid2)
                end
        end
end

function EnemyFourth()

        local Control = Prox_ArePlayersNearMarker(player4, mkr_raid4, false)
        local Unit1 = Prox_AreSquadMembersNearMarker(RaidCar1, mkr_raid4, false)
        local Unit2 = Prox_AreSquadMembersNearMarker(RaidCar2, mkr_raid4, false)
        local Unit3 = Prox_AreSquadMembersNearMarker(RaidHalftrack, mkr_raid4, false)
        if Control == true then
                if Unit1 == true then
                        Cmd_Move(RaidCar1, mkr_raid5)
                elseif Unit2 == true then
                        Cmd_Move(RaidCar2, mkr_raid5)
                elseif Unit3 == true then
                        Cmd_Move(RaidHalftrack, mkr_raid3)
                end
        end
end

function EnemyFifth()

        local Control = Prox_ArePlayersNearMarker(player4, mkr_raid5, false)
        local Unit1 = Prox_AreSquadMembersNearMarker(RaidCar1, mkr_raid5, false)
        local Unit2 = Prox_AreSquadMembersNearMarker(RaidCar2, mkr_raid5, false)
        local Unit3 = Prox_AreSquadMembersNearMarker(RaidHalftrack, mkr_raid5, false)
        if Control == true then
                if Unit1 == true then
                        Cmd_Move(RaidCar1, mkr_raid1)
                elseif Unit2 == true then
                        Cmd_Move(RaidCar2, mkr_raid1)
                elseif Unit3 == true then
                        Cmd_Move(RaidHalftrack, mkr_raid4)
                end
        end
end

---------------------------------Lose----------------------------

function Lose()

        Rule_AddDelayedInterval(KurtLose, 1, 1)
        Rule_AddDelayedInterval(JozefLose, 1, 1)
        Rule_AddDelayedInterval(FriedrichLose, 1, 1)
        Rule_AddDelayedInterval(OttoLose, 1, 1)
        Rule_AddDelayedInterval(UlrichLose, 1, 1)
        Rule_AddDelayedInterval(TomislavLose, 1, 1)
        Rule_AddDelayedInterval(HansLose, 1, 1)

end

function KurtLose()

        local Control = SGroup_Count(Kurt)
        if Control == 0 then
                Game_EndSP(false)
        end
end

function JozefLose()

        local Control = SGroup_Count(Jozef)
        if Control == 0 then
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

function TomislavLose()

        local Control = SGroup_Count(Tomislav)
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






EVENTS = {}

        local Text1 = Util_CreateLocString("Air raid! Air raid! AIR RAID!!!")
        local Text2 = Util_CreateLocString("Oh I've seen this kind of tactic before... this is no raid...")
        local Text3 = Util_CreateLocString("...")
        local Text4 = Util_CreateLocString("...Airbourne assault.")

        local Text5 = Util_CreateLocString("Soviet counterattack! We must re-position to the north!")
        local Text6 = Util_CreateLocString("How long do we need to hold out here?")
        local Text7 = Util_CreateLocString("I don't know, I'm not all-knowing!")
        local Text8 = Util_CreateLocString("Yeah! I can really see that!")

        local Text9 = Util_CreateLocString("Mobile vehicles incoming!")
        local Text10 = Util_CreateLocString("Keep yourselves mobile! Move!")
        local Text11 = Util_CreateLocString("Where is that relief force Jozef?")
        local Text12 = Util_CreateLocString("Shut up and keep firing!")

        local Text13 = Util_CreateLocString("The Americans and British are pushing from the south-east again! Move!")
        local Text14 = Util_CreateLocString("Where are those reinforcements Jozef!!!")
        local Text15 = Util_CreateLocString("For the last time, I don't know!")
        local Text16 = Util_CreateLocString("Damn it Jozef! DO I LOOK LIKE I HAVE AMMO FOR DAYS?!")

        local Text17 = Util_CreateLocString("That's it! We can't stay any longer, we're pressing ahead.")
        local Text18 = Util_CreateLocString("Deserters right? I am good at seeing these things, I am coming with you.")
        local Text19 = Util_CreateLocString("Good, because this is the end of the road for me... I won't be going with you further.")
        local Text20 = Util_CreateLocString("What? Why?!")
        local Text21 = Util_CreateLocString("I came all the way out here for Anton. I have failed, there is no reason for me to go with you any more.")
        local Text22 = Util_CreateLocString("He has made his choice. Anybody else who want to stay behind, do so. Anyone else who wants to keep going, follow me.")
        local Text23 = Util_CreateLocString("Where is Ulrich?")
        local Text24 = Util_CreateLocString("Oh shit, did we lose Ulrich?")
        local Text25 = Util_CreateLocString("I didn't see him, did he just disappear?")
        local Text26 = Util_CreateLocString("We don't have time for this! We need to keep moving, before any more men realize we are deserters and shoot us!")
        local Text27 = Util_CreateLocString("We will see you later Tomislav.")
        local Text28 = Util_CreateLocString("Yes, I'm sure you will...")

        local Text29 = Util_CreateLocString("Hey! The radio is still working.")
        local Text30 = Util_CreateLocString("And a convenient map of the area is here...")
        local Text31 = Util_CreateLocString("Let's call for some air back-up shall we? Heh heh...")
        local Text32 = Util_CreateLocString("... I do not need back-up...")
        local Text33 = Util_CreateLocString("Fire command, this is... Task Force Himmelsdorf, we require air support at co-ordinates, four, seven, zero.")
        local Text34 = Util_CreateLocString("Task Force Himmelssdorf we acknowledge your request and assistance is en-route.")
        local Text35 = Util_CreateLocString("Heh... Nice!")

        local Text36 = Util_CreateLocString("What the hell?! Enemy troops here? Roebuck's attack failed?")
        local Text37 = Util_CreateLocString("Son of a bitch, they must have taken Roebuck out. Pull back!")

        local Text38 = Util_CreateLocString("Enemies have breached the rearguard! I need more men here now!")

        local Text39 = Util_CreateLocString("Ah there's more enemy troops here than expected! Fire artillery at co-ordinates now!")

        local Text40 = Util_CreateLocString("Well hello boys! Looks like it's just you and us... Simmons! Fitzgerald! Let 'em have it!")
        local Text41 = Util_CreateLocString("Right away major!")
        local Text42 = Util_CreateLocString("Careful there Simmons, this bunch passed through our front lines... they know their what they're doing.")

        local Text43 = Util_CreateLocString("Er... we have a problem!")
        local Text44 = Util_CreateLocString("Why I say chums! You seem to be in a spot of trouble! Look's like you could use a hand.")
        local Text45 = Util_CreateLocString("What do we do Friedrich?!")
        local Text46 = Util_CreateLocString("Drop your weapon... there is no hope of winning this fight...")
        local Text47 = Util_CreateLocString("Damn it!!!")
        local Text48 = Util_CreateLocString("...")
        local Text49 = Util_CreateLocString("It does looks like they are surrendering major Adams, wouldn't you agree?")
        local Text50 = Util_CreateLocString("I swear to God Fitzgerald... I don't understand most of what this British guy says. Who talks like this?")
        local Text51 = Util_CreateLocString("Take them away to the holding cell in the city. We'll talk to them later.")

        local Story1 = Util_CreateLocString("You must be the reinforcements we requested! Are more coming?")
        local Story2 = Util_CreateLocString("What reinforcements? We are not your reinforcements.")
        local Story3 = Util_CreateLocString("What are you talking about? You must be it! The Soviets are attacking from the north and Americans and British to the south-east, and you are saying you're not here to help?")
        local Story4 = Util_CreateLocString("We are not here to help...")
        local Story5 = Util_CreateLocString("Just who are you people?! If they attack we are all dead, don't you fools understand that?")
        local Story6 = Util_CreateLocString("My name is Jozef. If you know what is good for you, you'll stay here with us and fight this one out...")
        local Story7 = Util_CreateLocString("Reinforcements are coming soon anyway, so we just need to hold out until then. I don't care what you are to be honest, I just care about survival!")
        local Story8 = Util_CreateLocString("Unfortunately I do think he is right... there will undoubtedly be more Soviets coming... and if what he says is true, then we are trapped in here for the moment...")
        local Story9 = Util_CreateLocString("Urgh... fine. Everyone just stay alive... please...")

        local Story10 = Util_CreateLocString("The shooting has stopped...")
        local Story11 = Util_CreateLocString("Yeah... I wonder who won...")
        local Story12 = Util_CreateLocString("Hey! you'll be fine. You'll make it out of this!")
        local Story13 = Util_CreateLocString("Heh heh... thanks. I have memories of my wife Marta and my children to keep me going.")
        local Story14 = Util_CreateLocString("That's right! One step at a time to the end.")

        local Story15 = Util_CreateLocString("So what do I call your children when we get to Switzerland?")
        local Story16 = Util_CreateLocString("Walther is the older one, he is twelve now. Anna is nine. I had her not long before the war.")
        local Story17 = Util_CreateLocString("Marta, Walther and Anna. It must be pretty comfortable with them around Christmas time eh?")
        local Story18 = Util_CreateLocString("Ha ha yeah... Hopefully we can join them before this Christmas.")
        local Story19 = Util_CreateLocString("Heh... that'll be nice. I haven't had a good Christmas in a long time...")

EVENTS.Village = function()

	CTRL.WAIT()
        local Direction = Marker_GetDirection(mkr_direction)
        Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_para1, Direction, true)
        Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_para2, Direction, true)
	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text1)
        CTRL.WAIT()
        Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_para2, Direction, true)
        Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_para3, Direction, true)
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text2)
        CTRL.WAIT()
        Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_para1, Direction, true)
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text3)
        CTRL.WAIT()
        Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_para1, Direction, true)
        Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_para2, Direction, true)
        Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_para3, Direction, true)
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text4)
        CTRL.WAIT()
        Cmd_Move(StartSherman, mkr_shermanto)
        Cmd_Move(MidRight, mkr_mid1rightto)
        Cmd_Move(MidLeft, mkr_mid1leftto)
        Cmd_Move(BottomRight, mkr_bottom1rightto)
        Cmd_Move(BottomLeft, mkr_para2)
        CTRL.WAIT()

end

EVENTS.Two = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text6)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text7)
	CTRL.WAIT()
	CTRL.Event_Delay(25)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text8)
	Util_CreateSquads(player3, SovietGroup, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_sovietspawn)
	Util_CreateSquads(player3, SovietGroup, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_sovietspawn)
	Util_CreateSquads(player3, SovietGroup, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_sovietspawn)
	Util_CreateSquads(player3, SovietMid, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_sovietspawn)
	Util_CreateSquads(player3, SovietMid, SBP.SOVIET.PENAL_BATTALION_MP, mkr_sovietspawn)
	CTRL.WAIT()
        Cmd_AttackMove(SovietGroup, mkr_sovietgroupto)
        Cmd_Move(SovietLeft, mkr_sovietleftto)
        Cmd_Move(SovietMid, mkr_sovietmidtoone)
        Cmd_Move(SovietRight, mkr_sovietrighttoone)
	CTRL.WAIT()
	CTRL.Event_Delay(15)
	CTRL.WAIT()
	Util_CreateSquads(player3, SovietLeft, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_sovietspawn)
	Util_CreateSquads(player3, SovietLeft, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_sovietspawn)
	CTRL.WAIT()
	CTRL.Event_Delay(15)
	CTRL.WAIT()
	Util_CreateSquads(player3, SovietRight, SBP.SOVIET.PENAL_BATTALION_MP, mkr_sovietspawn)
	Util_CreateSquads(player3, SovietRight, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_sovietspawn)
	Util_CreateSquads(player3, SovietRight, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_sovietspawn)
	Util_CreateSquads(player3, SovietGroup, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_sovietspawn)
	Util_CreateSquads(player3, SovietGroup, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_sovietspawn)
	CTRL.WAIT()
        Cmd_AttackMove(SovietGroup, mkr_sovietgroupto)
        Cmd_Move(SovietLeft, mkr_sovietleftto)
        Cmd_Move(SovietMid, mkr_sovietmidtoone)
        Cmd_Move(SovietRight, mkr_sovietrighttoone)
        SGroup_Kill(SequenceThreeControl)
	CTRL.WAIT()

end


EVENTS.Three = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text9)
        Cmd_Ability(player4, ABILITY.AEF.TIME_ON_TARGET_ARTILLERY, mkr_artillerytargettwo, Direction, true)
	CTRL.WAIT()
        Cmd_Ability(player4, ABILITY.AEF.TIME_ON_TARGET_ARTILLERY, mkr_artillerytargetone, Direction, true)
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text10)
	CTRL.WAIT()
	CTRL.Event_Delay(30)
	CTRL.WAIT()
        Cmd_Move(BotGren, mkr_botgrento1)
        Cmd_Move(BotAss, mkr_botassto1)
        Cmd_Move(BotJaeger, mkr_botjaegerto1)
        Cmd_Move(BotCar, mkr_botcarto1)
        Cmd_Move(MidGren, mkr_midgrento1)
        Cmd_Move(MidAss, mkr_midassto1)
        Cmd_Move(MidVolk, mkr_midvolkto1)
        Cmd_Move(TopGren, mkr_topgrento1)
        Cmd_Move(TopAss, mkr_topassto1)
        Cmd_Move(TopJaeger, mkr_topjaegerto1)
        Cmd_Move(TopVolk, mkr_topvolkto1)
        Cmd_Move(TopCar, mkr_topcarto1)
        Cmd_Move(TopKubel, mkr_topkubelto1)
        Cmd_Move(RaidCar1, mkr_raid5)
        Cmd_Move(RaidCar2, mkr_raid4)
	CTRL.WAIT()
	CTRL.Event_Delay(8)
	CTRL.WAIT()
        Cmd_Move(ShermanThree, mkr_shermanthreetoone)
        Cmd_Move(Universal1, mkr_universal1to)
        Cmd_Move(Universal2, mkr_universal2to)
        Cmd_Move(MGCar1, mkr_mgcar1to)
        Cmd_Move(MGCar2, mkr_mgcar2to)
        Cmd_Move(RaidHalftrack, mkr_raid4)
        Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_gliderland, Direction, true)
        Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_gliderdirection, Direction, true)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text11)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text12)
	CTRL.WAIT()

end

EVENTS.Four = function()

	CTRL.WAIT()
	CTRL.Event_Delay(45)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text13)
        Cmd_Move(Mid2Group, mkr_mid2groupto)
        Cmd_Move(Mid2Officer, mkr_mid2officerto)
        Cmd_Move(Mid2Engineer, mkr_mid2engineerto)
        local Direction = Marker_GetDirection(mkr_direction)
        Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_para3, Direction, true)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Tomislav, Text14)
        Cmd_Ability(player4, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_para2, Direction, true)
	CTRL.WAIT()
        Cmd_Move(CommandosOne, mkr_commandosoneto)
        Cmd_Move(CommandosTwo, mkr_commandostwoto)
        Cmd_Move(BritCar, mkr_gliderland)
        Cmd_Move(FlameTommyOne, mkr_tommyoneto)
        Cmd_Move(FlameTommyTwo, mkr_tommytwoto)
        SGroup_SetInvulnerable(Ulrich, true)
        SGroup_SetPlayerOwner(Ulrich, player2)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
        Cmd_Retreat(Ulrich)
	CTRL.WAIT()
	CTRL.Event_Delay(4)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text15)
        Cmd_Move(DozerTank, mkr_sovietgroupto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text16)
	CTRL.WAIT()

end

EVENTS.SequenceEnd = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text17)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text18)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Tomislav, Text19)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text20)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Tomislav, Text21)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text22)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text23)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text24)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text25)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text26)
	CTRL.WAIT()
        SGroup_SetPlayerOwner(Tomislav, player2)
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text27)
	CTRL.WAIT()
        Cmd_Move(Tomislav, mkr_bulldozerto)
	CTRL.Actor_PlaySpeech(ACTOR.Tomislav, Text28)
        World_GetCurrentInteractionStage()
        World_IncreaseInteractionStage()
        FOW_UnRevealMarker(mkr_sight1)
        FOW_UnRevealMarker(mkr_sight2)
        FOW_UnRevealMarker(mkr_sight3)
        FOW_UnRevealMarker(mkr_sight4)
        FOW_UnRevealMarker(mkr_sight5)
        Blip3 = UI_CreateMinimapBlip(Point4, 9000, BT_ObjectivePrimary)
        UI_DeleteMinimapBlip(Blip2)

end

EVENTS.Radio = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text29)
        SGroup_Kill(RadioControl)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text30)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text31)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text32)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text33)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, Text34)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text35)

end

EVENTS.Major = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, Text36)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, Text37)
        Cmd_Move(Adams, mkr_officerteleporttrigger)
        Cmd_Move(Simmons, mkr_officerteleporttrigger)
        Cmd_Move(Fitzgerald, mkr_officerteleporttrigger)
	CTRL.WAIT()

end

EVENTS.Saw = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, Text38)
        Cmd_AttackMove(ConsSpawn, mkr_consspawnto)
	CTRL.WAIT()

end

EVENTS.LieutenantAttack = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text39)
	CTRL.WAIT()

end

EVENTS.EndStart = function()

	CTRL.WAIT()
        SGroup_SetInvulnerable(PlayerGroup, true)
        SGroup_SetInvulnerable(AmericanThreeOfficers, true)
        SGroup_SetInvulnerable(SurpriseGroupRight, true)
        SGroup_SetInvulnerable(SurpriseGroupLeft, true)
        SGroup_WarpToMarker(Kurt, mkr_kurt)
        SGroup_WarpToMarker(Otto, mkr_otto)
        SGroup_WarpToMarker(Friedrich, mkr_friedrich)
        SGroup_WarpToMarker(Hans, mkr_hans)
        SGroup_WarpToMarker(Jozef, mkr_jozef)
	CTRL.WAIT()
        Cmd_Move(Kurt, mkr_kurtto)
        Cmd_Move(Otto, mkr_ottoto)
        Cmd_Move(Friedrich, mkr_friedrichto)
        Cmd_Move(Hans, mkr_hansto)
        Cmd_Move(Jozef, mkr_jozefto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, Text40)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Simmons, Text41)
        Cmd_Move(SurpriseGroupLeft, mkr_surprisegroupleftto)
        Cmd_Move(SurpriseGroupRight, mkr_surprisegrouprightto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, Text42)
	CTRL.WAIT()
end

EVENTS.EndEnd = function()

	CTRL.WAIT()
        SGroup_FaceEachOther(Jozef, BritishOfficer)
        FOW_RevealMarker(mkr_endingsight, 9000)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text43)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.British, Text44)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text45)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text46)
	CTRL.WAIT()
        Cmd_Surrender(Kurt, nil, mkr_kurtto, false, true)
        Cmd_Surrender(Otto, nil, mkr_ottoto, false, true)
        Cmd_Surrender(Friedrich, nil, mkr_friedrichto, false, true)
        Cmd_Surrender(Jozef, nil, mkr_jozefto, false, true)
        Cmd_Surrender(Hans, nil, mkr_hansto, false, true)
	CTRL.WAIT()
        SGroup_SetPlayerOwner(AdamsTwo, player2)
        SGroup_SetPlayerOwner(SimmonsTwo, player2)
        SGroup_SetPlayerOwner(FitzgeraldTwo, player2)
        SGroup_SetPlayerOwner(SurpriseGroupLeft, player2)
        SGroup_SetPlayerOwner(SurpriseGroupRight, player2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text47)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text48)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.British, Text49)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Simmons, Text50)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, Text51)
	CTRL.WAIT()
        Game_EndSP(true)

end

EVENTS.City = function()

	CTRL.WAIT()
        SGroup_SetInvulnerable(Kurt, true)
        SGroup_SetInvulnerable(Otto, true)
        SGroup_SetInvulnerable(Friedrich, true)
        SGroup_SetInvulnerable(Ulrich, true)
        SGroup_SetInvulnerable(Jozef, true)
        SGroup_SetInvulnerable(Tomislav, true)
        SGroup_SetInvulnerable(Hans, true)
        SGroup_WarpToMarker(Kurt, mkr_villagekurt)
        SGroup_WarpToMarker(Otto, mkr_villageotto)
        SGroup_WarpToMarker(Friedrich, mkr_villagefriedrich)
        SGroup_WarpToMarker(Hans, mkr_villagehans)
        SGroup_WarpToMarker(Tomislav, mkr_villagetomislav)
        SGroup_WarpToMarker(Ulrich, mkr_villageulrich)
        SGroup_SetPlayerOwner(Jozef, player1)
	CTRL.WAIT()
        Cmd_Move(Kurt, mkr_villagekurtto)
        Cmd_Move(Otto, mkr_villageottoto)
        Cmd_Move(Friedrich, mkr_villagefriedrichto)
        Cmd_Move(Hans, mkr_villagehansto)
        Cmd_Move(Tomislav, mkr_villagetomislavto)
        Cmd_Move(Ulrich, mkr_villageulrichto)
        Cmd_Move(Jozef, mkr_villagejozefto)
	CTRL.WAIT()
	CTRL.Event_Delay(3)
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Story1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Tomislav, Story2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Story3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Story4)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Story5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Story6)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Story7)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ulrich, Story8)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Story9)
	CTRL.WAIT()
        SGroup_SetInvulnerable(Kurt, false)
        SGroup_SetInvulnerable(Otto, false)
        SGroup_SetInvulnerable(Friedrich, false)
        SGroup_SetInvulnerable(Ulrich, false)
        SGroup_SetInvulnerable(Jozef, false)
        SGroup_SetInvulnerable(Tomislav, false)
        SGroup_SetInvulnerable(Hans, false)
        Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
        Camera_ResetToDefault()
	CTRL.WAIT()

end

EVENTS.Begin = function()

	CTRL.WAIT()
        Cmd_Move(Kurt, mkr_startkurtto)
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Story10)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Story11)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Story12)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Story13)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Story14)
	CTRL.WAIT()
        Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
        Camera_ResetToDefault()

end

EVENTS.Chat = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Story15)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Story16)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Story17)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Story18)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Story19)
	CTRL.WAIT()

end