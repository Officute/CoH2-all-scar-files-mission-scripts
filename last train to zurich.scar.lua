-- This following code contained in this file is copyright to Mike D. Do not re-use without express permission from all copyright holders, this work is partially protected by the Digital Millenium Copyright Act (DCMA), U.S.C, Title 17.

import("ScarUtil.scar")
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

end
Scar_AddInit(OnGameSetup)

function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

function OnInit()

        Custom()

        Rule_AddDelayedInterval(CustomFailsafe, 1, 1)
		
		Rule_AddDelayedInterval(Easter, 1, 1)
		
		Community()
		
		Cinematic()
		
		Points()
		
		OptionalEvent()
		
		VillageEvent()
		
		CacheEvent()
		
		BridgeEvent()
		
		CampEvent()
		
		FortEvent()
		
		MillEvent()
		
		TrenchEvent()
		
		OutpostEvent()
		
		PathEvent()
		
		FinaleEvent()
		
		Officers()
		
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
        Modify_EntityBuildTime(player1, EBP.WEST_GERMAN.SCHU_MINE_42_MP, 0.2)
        Modify_EntityBuildTime(player2, EBP.WEST_GERMAN.SCHU_MINE_42_MP, 0.2)
		

		SGroup_SetInvulnerable(TestSniper, true)
		
--------Village event interactive border to include massacre and interact region only increase after both point and cinematic triggered------
--------Change HansLose function so the condition is correct. Should be Fitzgerald > 0 and not current ==------------------------
--------Player_SetHeatLossRate(player1, 1) <----Requires no invulnerability to work. Could apply to Otto ending------------------------------------------------------------
--------EGroup_DestroyAllEntities(OutpostArtyPiece)------
--------SGroup_WarpToMarker(OutpostArty, mkr_outpostartyswap)----------
--------Remove Kurt and otto invulnerability at end of finale continue cinematic-------
		
		Blip1 = UI_CreateMinimapBlip(NoHoldChurch, 9000, BT_ObjectivePrimary)
		ExtraBlip = UI_CreateMinimapBlip(Point1, 9000, BT_ObjectivePrimary)
		
        World_EnableSharedLineOfSight(player1, player4, true)
        World_EnableSharedLineOfSight(player2, player4, true)
		
		local ControlGroup1 = SGroup_GetSpawnedSquadAt(Hans, 1)
        Squad_GiveSlotItem(ControlGroup1, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_NO_PRONE_MP)
		
		SGroup_SuggestPosture(CampOfficerGroup, 2, 9999)
		
		SGroup_Hide(TrainOne, true)
		SGroup_Hide(TrainTwo, true)
		SGroup_Hide(TrainThree, true)
		SGroup_EnableMinimapIndicator(TrainOne, false)
		SGroup_EnableMinimapIndicator(TrainTwo, false)
		SGroup_EnableMinimapIndicator(TrainThree, false)
		
		EGroup_SetInvulnerable(EntityIndestructable, true)
		EGroup_SetInvulnerable(InvulnerableObjects, true)
		EGroup_SetInvulnerable(FirePits, true)
		EGroup_SetInvulnerable(BridgeObjects, true)
		EGroup_SetInvulnerable(FortStairs, true)
		EGroup_SetInvulnerable(FortPlatforms, true)
		EGroup_SetInvulnerable(PierPlatforms, true)
		
		SGroup_SetInvulnerable(Fitzgerald, true)
		SGroup_SetInvulnerable(Dmitriy, true)
		SGroup_SetInvulnerable(Viktor, true)
		SGroup_SetInvulnerable(Nikolai, true)
		SGroup_SetInvulnerable(Stator, true)
		SGroup_SetInvulnerable(Vladilen, true)
		SGroup_SetInvulnerable(Yuri, true)
		SGroup_SetInvulnerable(Aleksei, true)
		
		SGroup_SetInvulnerable(RetreatEngineer, true)
		SGroup_SetInvulnerable(BridgeAllies, true)
		SGroup_SetInvulnerable(BridgeAxis, true)
		SGroup_SetInvulnerable(MillTrucks, true)
		SGroup_SetInvulnerable(TrenchAreaUnits, true)
		SGroup_SetInvulnerable(PathMichael, true)
		SGroup_SetInvulnerable(FinaleApel, true)
		
		SGroup_SetInvulnerableToCritical(Michael, true)
		
		Modify_DisableHold(NoHoldChurch, true)
		EGroup_SetInvulnerable(NoHoldChurch, true)
		
		SGroup_Kill(TankWrecks)
		EGroup_Kill(Wrecks)
		SGroup_Kill(TrenchVehicles)
		
		EGroup_SetInvulnerable(RiverBridgeOne, true)
		EGroup_SetInvulnerable(RiverBridgeTwo, true)
		
		SGroup_SetMoodMode(Koch, MM_ForceCalm)
		SGroup_SetMoodMode(Lohse, MM_ForceCalm)
		SGroup_SetMoodMode(Dassler, MM_ForceCalm)
		
		SGroup_FaceMarker(Koch, mkr_villagecamera)
		SGroup_FaceMarker(Lohse, mkr_villagecamera)
		SGroup_FaceMarker(Dassler, mkr_villagecamera)
		SGroup_SetMoodMode(CampCalmEnemy, MM_ForceCalm)
		
		SGroup_FaceMarker(Schneider, mkr_schneiderface)
		SGroup_FaceMarker(PathFalls, mkr_schneiderface)
		SGroup_FaceMarker(PathApel, mkr_pathapelface)
		SGroup_SetMoodMode(Schneider, MM_ForceCalm)
		SGroup_SetMoodMode(PathFalls, MM_ForceCalm)
		SGroup_SetMoodMode(PathApel, MM_ForceCalm)
		
		SGroup_SetMoodMode(CacheUnits, MM_ForceCalm)
		
		Modify_UnitSpeed(CacheCar, 0.5)
		
		Command_SquadEntityLoad(player3, CampHouseEchelon, SCMD_Load, CampHouse, false, true)
		
		Cmd_CriticalHit(player5, AbandonedTank, CRIT.VEHICLE_ABANDON, 1)
		
		local StartTextHint1 = Util_CreateLocString("This chapter has multiple endings and epilogues that changes based on the choices you make and how you play. Your decisions will determine their fate.")
        StartHint1 = HintPoint_Add(mkr_hintone, true, StartTextHint1)
		
		Modify_TargetPriority(Schneider, -20)
		Modify_TargetPriority(Fitzgerald, -20)
		Modify_TargetPriority(TrainOne, -20)
		Modify_TargetPriority(TrainTwo, -20)
		Modify_TargetPriority(TrainThree, -20)

end

function CustomFailsafe()

        AI_EnableAll(false)
		
		SGroup_SetSuppression(Fitzgerald, 0)
		SGroup_SetSuppression(Dmitriy, 0)
		SGroup_SetSuppression(Viktor, 0)
		SGroup_SetSuppression(Nikolai, 0)
		SGroup_SetSuppression(Vladilen, 0)
		SGroup_SetSuppression(Stator, 0)
		SGroup_SetSuppression(Yuri, 0)
		SGroup_SetSuppression(Aleksei, 0)

end

function Easter()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_eastereggtrigger, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_eastereggtrigger, false)
        if Control1 == true or Control2 == true then
                local EggText = Util_CreateLocString("Hey! You found me! Let me share some of my wisdom. I am a firm believer in changing our own destinies through what we do, or choose not to do. Some people's destinies probably can't be changed though. If I was a betting man, I would think there are 32 possible variations of destinies in the end. Ha ha!")
                HintMouseover_Add(EggText, EasterEgg, 5, true)
                Rule_RemoveMe()
        end
end

------------------------------Community---------------------------------

function Community()

        Rule_AddDelayedInterval(ConsAppear, 1, 1)
        Rule_AddDelayedInterval(TextAppear, 1, 1)

end

function ConsAppear()

        local CommunityHint1 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 5 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Within)")
        local CommunityHint2 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 5 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Woods)")
        local CommunityHint3 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 5 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Under)")
        local CommunityHint4 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 5 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Railway)")
        local CommunityHint5 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 5 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Bridge)")

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_conscomtrigger, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_conscomtrigger, false)
        local Random = World_GetRand(1, 5)
        if Control1 == true or Control2 == true then
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
                end
        end
end

function TextAppear()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_communitytrigger, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_communitytrigger, false)
        if Control1 == true or Control2 == true then
                local CommunityEggText = Util_CreateLocString("A note found on the soldier's hand reads: Kurt Bachmann, Otto Baasch, Tomislav Novak, Hans Dunkel confirmed alive. Soviet forces close behind. Rearguard ineffective. Time insufficient and mission under grave threat. Recommend burying cargo.")
                HintMouseover_Add(CommunityEggText, CommunityEgg, 5, true)
                Rule_RemoveMe()
        end
end


--------------------------------Cinematic-----------------------------------

function Cinematic()

        Rule_AddDelayedInterval(WeatherTalk, 1, 1)

	    Camera_SetInputEnabled(false)
	    Game_SetMode(UI_Cinematic)
        Camera_Follow(Kurt)
        Camera_SetZoomDist(10)
        Util_StartIntel(EVENTS.StartCinematic)

end

function WeatherTalk()

		local Control = Prox_AreSquadsNearMarker(PlayerUnits, mkr_weathertrigger, false)
        if Control == true then
				Util_StartIntel(EVENTS.WeatherDialogue)
				Rule_RemoveMe()
        end
end

-------------------------------Points-----------------------------------

function Points()

        Rule_AddDelayedInterval(PointOne, 1, 1)
		Rule_AddDelayedInterval(PointTwo, 1, 1)
		Rule_AddDelayedInterval(PointThree, 0.1, 0.1)
		Rule_AddDelayedInterval(PointFour, 1, 1)
		Rule_AddDelayedInterval(PointFive, 1, 1)
		Rule_AddDelayedInterval(PointSix, 1, 1)
		Rule_AddDelayedInterval(PointSeven, 1, 1)
		Rule_AddDelayedInterval(PointEight, 1, 1)
		Rule_AddDelayedInterval(PointNine, 1, 1)
		
		Rule_AddDelayedInterval(FortPoint, 1, 1)

	    Rule_AddDelayedInterval(PointTalkOne, 1, 1)

end

function PointOne()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point1, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point1, player2, false)
        if PointFocus1 == true or PointFocus2 == true then
                local RetreatEntity1 = EGroup_GetSpawnedEntityAt(RetreatOne1, 1)
				local RetreatEntity2 = EGroup_GetSpawnedEntityAt(RetreatOne2, 1)
                local DestroyEntity1 = EGroup_GetSpawnedEntityAt(RetreatStart1, 1)
				local DestroyEntity2 = EGroup_GetSpawnedEntityAt(RetreatStart2, 1)
                Entity_SetPlayerOwner(RetreatEntity1, player1)
				Entity_SetPlayerOwner(RetreatEntity2, player2)
                Entity_Destroy(DestroyEntity1)
				Entity_Destroy(DestroyEntity2)
				UI_DeleteMinimapBlip(ExtraBlip)
				HintPoint_Remove(StartHint1)
                Rule_RemoveMe()
        end
end

function PointTwo()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point2, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point2, player2, false)
        if PointFocus1 == true or PointFocus2 == true then
                local RetreatEntity1 = EGroup_GetSpawnedEntityAt(RetreatTwo1, 1)
				local RetreatEntity2 = EGroup_GetSpawnedEntityAt(RetreatTwo2, 1)
                local DestroyEntity1 = EGroup_GetSpawnedEntityAt(RetreatOne1, 1)
				local DestroyEntity2 = EGroup_GetSpawnedEntityAt(RetreatOne2, 1)
                Entity_SetPlayerOwner(RetreatEntity1, player1)
				Entity_SetPlayerOwner(RetreatEntity2, player2)
                Entity_Destroy(DestroyEntity1)
				Entity_Destroy(DestroyEntity2)
				Blip3 = UI_CreateMinimapBlip(Point3, 9000, BT_ObjectivePrimary)
				UI_DeleteMinimapBlip(Blip2)
				World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                Rule_RemoveMe()
        end
end

function PointThree()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point3, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point3, player2, false)
        if PointFocus1 == true or PointFocus2 == true then
                local RetreatEntity1 = EGroup_GetSpawnedEntityAt(RetreatThree1, 1)
				local RetreatEntity2 = EGroup_GetSpawnedEntityAt(RetreatThree2, 1)
                local DestroyEntity1 = EGroup_GetSpawnedEntityAt(RetreatTwo1, 1)
				local DestroyEntity2 = EGroup_GetSpawnedEntityAt(RetreatTwo2, 1)
                Entity_SetPlayerOwner(RetreatEntity1, player1)
				Entity_SetPlayerOwner(RetreatEntity2, player2)
                Entity_Destroy(DestroyEntity1)
				Entity_Destroy(DestroyEntity2)
				PointVillageChoiceFailsafe()
				CampOptionalChoiceCheck()
				Blip4 = UI_CreateMinimapBlip(Point4, 9000, BT_ObjectivePrimary)
				UI_DeleteMinimapBlip(Blip3)
                Rule_RemoveMe()
        end
end

function PointFour()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point4, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point4, player2, false)
        if PointFocus1 == true or PointFocus2 == true then
                local RetreatEntity1 = EGroup_GetSpawnedEntityAt(RetreatFour1, 1)
				local RetreatEntity2 = EGroup_GetSpawnedEntityAt(RetreatFour2, 1)
                local DestroyEntity1 = EGroup_GetSpawnedEntityAt(RetreatThree1, 1)
				local DestroyEntity2 = EGroup_GetSpawnedEntityAt(RetreatThree2, 1)
                Entity_SetPlayerOwner(RetreatEntity1, player1)
				Entity_SetPlayerOwner(RetreatEntity2, player2)
                Entity_Destroy(DestroyEntity1)
				Entity_Destroy(DestroyEntity2)
				Blip5 = UI_CreateMinimapBlip(FortBodyguard, 9000, BT_ObjectivePrimary)
				UI_DeleteMinimapBlip(Blip4)
                Rule_RemoveMe()
        end
end

function PointFive()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point5, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point5, player2, false)
        if PointFocus1 == true or PointFocus2 == true then
                local RetreatEntity1 = EGroup_GetSpawnedEntityAt(RetreatFive1, 1)
				local RetreatEntity2 = EGroup_GetSpawnedEntityAt(RetreatFive2, 1)
                local DestroyEntity1 = EGroup_GetSpawnedEntityAt(RetreatFour1, 1)
				local DestroyEntity2 = EGroup_GetSpawnedEntityAt(RetreatFour2, 1)
                Entity_SetPlayerOwner(RetreatEntity1, player1)
				Entity_SetPlayerOwner(RetreatEntity2, player2)
                Entity_Destroy(DestroyEntity1)
				Entity_Destroy(DestroyEntity2)
				EGroup_SetPlayerOwner(InterimRetreat1, player8)
				EGroup_SetPlayerOwner(InterimRetreat2, player8)
				Blip7 = UI_CreateMinimapBlip(Point6, 9000, BT_ObjectivePrimary)
				UI_DeleteMinimapBlip(Blip6)
				World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                Rule_RemoveMe()
        end
end

function PointSix()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point6, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point6, player2, false)
        if PointFocus1 == true or PointFocus2 == true then
                local RetreatEntity1 = EGroup_GetSpawnedEntityAt(RetreatSix1, 1)
				local RetreatEntity2 = EGroup_GetSpawnedEntityAt(RetreatSix2, 1)
                local DestroyEntity1 = EGroup_GetSpawnedEntityAt(RetreatFive1, 1)
				local DestroyEntity2 = EGroup_GetSpawnedEntityAt(RetreatFive2, 1)
                Entity_SetPlayerOwner(RetreatEntity1, player1)
				Entity_SetPlayerOwner(RetreatEntity2, player2)
                Entity_Destroy(DestroyEntity1)
				Entity_Destroy(DestroyEntity2)
				Blip8 = UI_CreateMinimapBlip(Point7, 9000, BT_ObjectivePrimary)
				UI_DeleteMinimapBlip(Blip7)
				World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                Rule_RemoveMe()
        end
end

function PointSeven()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point7, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point7, player2, false)
        if PointFocus1 == true or PointFocus2 == true then
                local RetreatEntity1 = EGroup_GetSpawnedEntityAt(RetreatSeven1, 1)
				local RetreatEntity2 = EGroup_GetSpawnedEntityAt(RetreatSeven2, 1)
                local DestroyEntity1 = EGroup_GetSpawnedEntityAt(RetreatSix1, 1)
				local DestroyEntity2 = EGroup_GetSpawnedEntityAt(RetreatSix2, 1)
                Entity_SetPlayerOwner(RetreatEntity1, player1)
				Entity_SetPlayerOwner(RetreatEntity2, player2)
                Entity_Destroy(DestroyEntity1)
				Entity_Destroy(DestroyEntity2)
				local TextHint1 = Util_CreateLocString("Moving ANY character further into the water will cause all characters to begin losing heat and slowly become frostbitten for the rest of the chapter. Characters can regain heat at fire pits and inside buildings. Heavy (green) cover will pause the heat loss. Characters will die if they lose all their heat for too long and become frostbitten, resulting in mission failure. This process is not reversible, so choose carefully.")
	            Hint1 = HintPoint_Add(mkr_waterhint, true, TextHint1)
				Blip9 = UI_CreateMinimapBlip(Schneider, 9000, BT_ObjectivePrimary)
				UI_DeleteMinimapBlip(Blip8)
				World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                Rule_RemoveMe()
        end
end

function PointEight()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point8, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point8, player2, false)
        if PointFocus1 == true or PointFocus2 == true then
                local RetreatEntity1 = EGroup_GetSpawnedEntityAt(RetreatEight1, 1)
				local RetreatEntity2 = EGroup_GetSpawnedEntityAt(RetreatEight2, 1)
                local DestroyEntity1 = EGroup_GetSpawnedEntityAt(RetreatSeven1, 1)
				local DestroyEntity2 = EGroup_GetSpawnedEntityAt(RetreatSeven2, 1)
                Entity_SetPlayerOwner(RetreatEntity1, player1)
				Entity_SetPlayerOwner(RetreatEntity2, player2)
                Entity_Destroy(DestroyEntity1)
				Entity_Destroy(DestroyEntity2)
				Blip13 = UI_CreateMinimapBlip(Point9, 9000, BT_ObjectivePrimary)
				UI_DeleteMinimapBlip(Blip12)
                Rule_RemoveMe()
        end
end

function PointNine()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point9, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point9, player2, false)
        if PointFocus1 == true or PointFocus2 == true then
                local RetreatEntity1 = EGroup_GetSpawnedEntityAt(RetreatNine1, 1)
				local RetreatEntity2 = EGroup_GetSpawnedEntityAt(RetreatNine2, 1)
                local DestroyEntity1 = EGroup_GetSpawnedEntityAt(RetreatEight1, 1)
				local DestroyEntity2 = EGroup_GetSpawnedEntityAt(RetreatEight2, 1)
                Entity_SetPlayerOwner(RetreatEntity1, player1)
				Entity_SetPlayerOwner(RetreatEntity2, player2)
                Entity_Destroy(DestroyEntity1)
				Entity_Destroy(DestroyEntity2)
				Blip14 = UI_CreateMinimapBlip(Wilhelm, 9000, BT_ObjectivePrimary)
				UI_DeleteMinimapBlip(Blip13)
                Rule_RemoveMe()
        end
end

function FortPoint()

        local PointFocus1 = EGroup_IsCapturedByPlayer(InterimPoint, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(InterimPoint, player2, false)
        if PointFocus1 == true or PointFocus2 == true then
		        local PointFocus3 = EGroup_IsCapturedByPlayer(Point5, player1, false)
                local PointFocus4 = EGroup_IsCapturedByPlayer(Point5, player2, false)
                if PointFocus3 == false and PointFocus4 == false then
                        local RetreatEntity1 = EGroup_GetSpawnedEntityAt(InterimRetreat1, 1)
				        local RetreatEntity2 = EGroup_GetSpawnedEntityAt(InterimRetreat2, 1)
                        Entity_SetPlayerOwner(RetreatEntity1, player1)
				        Entity_SetPlayerOwner(RetreatEntity2, player2)
                        Rule_RemoveMe()
				end
        end
end

function PointTalkOne()

		local Control = Prox_AreSquadsNearMarker(PlayerUnits, mkr_pointonetrigger, false)
        if Control == true then
				Util_StartIntel(EVENTS.PointOneDialogue)
				Rule_RemoveMe()
        end
end

function PointVillageChoiceFailsafe()

        local Control1 = SGroup_Count(Koch)
		local Control2 = SGroup_Count(Lohse)
		local Control3 = SGroup_Count(Dassler)
		if Control1 == 0 and Control2 == 0 and Control3 == 0 then
				SGroup_Kill(VillageChoice)
        end
end




-------------------------------Optional Event------------------------------

function OptionalEvent()

        Rule_AddDelayedInterval(OptionalTrainVision, 1, 1)

        Rule_AddDelayedInterval(OptionalOne, 1, 1)
		Rule_AddDelayedInterval(OptionalTwo, 1, 1)
		Rule_AddDelayedInterval(OptionalThree, 1, 1)
		Rule_AddDelayedInterval(OptionalFour, 1, 1)
		
	    Rule_AddDelayedInterval(OptionalDisappearOne, 1, 1)
		Rule_AddDelayedInterval(OptionalDisappearTwo, 1, 1)
		Rule_AddDelayedInterval(OptionalDisappearThree, 1, 1)
		
		Rule_AddDelayedInterval(OptionalDisappearAll, 1, 1)
		Rule_AddDelayedInterval(OptionalDisappearDialogue, 1, 1)
		
		Rule_AddDelayedInterval(OptionalTrainMoveOne, 1, 1)
		
		Rule_AddDelayedInterval(OptionalTrainDisappear, 1, 1)

end

function OptionalTrainVision()

        local Control1 = SGroup_Count(TrainOne)
		if Control1 == 1 then
                local Control2 = SGroup_CanSeeSGroup(PlayerUnits, TrainOne, false)
                if Control2 == true then
                        SGroup_Hide(TrainOne, false)
		                SGroup_EnableMinimapIndicator(TrainOne, true)
		        elseif Control == false then
                        SGroup_Hide(TrainOne, true)
		                SGroup_EnableMinimapIndicator(TrainOne, false)
				end
        end
end

function OptionalOne()
 
        local Control1 = SGroup_IsUnderAttack(RetreatEngineer, false, 9000)
		local Control2 = Prox_AreSquadsNearMarker(RetreatEngineer, mkr_fallbacktriggerone, true)
		local Control3 = SGroup_CanSeeSGroup(PlayerUnits, RetreatEngineer, false)
        if Control1 == true and Control2 == true and Control3 == true then
				Util_StartIntel(EVENTS.OptionalDialogueOne)
				Rule_RemoveMe()
        end
end

function OptionalTwo()
 
        local Control1 = SGroup_IsUnderAttack(RetreatEngineer, false, 9000)
		local Control2 = Prox_AreSquadsNearMarker(RetreatEngineer, mkr_fallbacktriggertwo, true)
		local Control3 = SGroup_CanSeeSGroup(PlayerUnits, RetreatEngineer, false)
		local Control4 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_optionalcontrolextra, false)
        if Control1 == true and Control2 == true and Control3 == true and Control4 == true then
				Util_StartIntel(EVENTS.OptionalDialogueTwo)
				Rule_RemoveMe()
        end
end

function OptionalThree()
 
        local Control1 = SGroup_IsUnderAttack(RetreatEngineer, false, 9000)
		local Control2 = Prox_AreSquadsNearMarker(RetreatEngineer, mkr_fallbacktriggerthree, true)
		local Control3 = SGroup_CanSeeSGroup(PlayerUnits, RetreatEngineer, false)
		local Control4 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_optionalcontrol1, false)
        if Control1 == true and Control2 == true and Control3 == true and Control4 == true then
				Util_StartIntel(EVENTS.OptionalDialogueThree)
				Rule_RemoveMe()
        end
end

function OptionalFour()
 
        local Control1 = SGroup_IsUnderAttack(OptionalAll, false, 9000)
		local Control2 = Prox_AreSquadsNearMarker(RetreatEngineer, mkr_fallbacktriggerfour, true)
		local Control3 = SGroup_CanSeeSGroup(PlayerUnits, RetreatEngineer, false)
		local Control4 = SGroup_CanSeeSGroup(PlayerUnits, TrainOne, false)
		local Control5 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_optionalcontrol2, false)
        if Control1 == true and Control2 == true and Control3 == true and Control4 == true and Control5 == true then
				Util_StartIntel(EVENTS.OptionalDialogueFour)
				Rule_RemoveMe()
        end
end

function OptionalDisappearOne()

		local Control = Prox_AreSquadsNearMarker(RetreatEngineer, mkr_fallbacktriggerfive, true)
        if Control == true then
				SGroup_DestroyAllSquads(RetreatEngineer)
				Rule_RemoveMe()
        end
end

function OptionalDisappearTwo()

		local Control = Prox_AreSquadsNearMarker(OptionalPioneerOne, mkr_fallbacktriggerfive, true)
        if Control == true then
				SGroup_DestroyAllSquads(OptionalPioneerOne)
				Rule_RemoveMe()
        end
end

function OptionalDisappearThree()

		local Control = Prox_AreSquadsNearMarker(OptionalPioneerTwo, mkr_fallbacktriggerfive, true)
        if Control == true then
				SGroup_DestroyAllSquads(OptionalPioneerTwo)
				Rule_RemoveMe()
        end
end

function OptionalDisappearAll()

		local Control1 = SGroup_Count(OptionalAll)
		local Control2 = SGroup_Count(TrainOne)
        if Control1 == 0 and Control2 == 1 then
		        Cmd_Retreat(OptionalLeftover)
				Cmd_Move(TrainOne, mkr_trainto1)
				Rule_RemoveMe()
        end
end

function OptionalDisappearDialogue()

		local Control = SGroup_CanSeeSGroup(PlayerUnits, OptionalLeftover, false)
        if Control == true then
				Util_StartIntel(EVENTS.OptionalDialogueFive)
				Rule_RemoveMe()
        end
end

function OptionalTrainMoveOne()
 

		local Control1 = Prox_AreSquadsNearMarker(TrainOne, mkr_trainto1, true)
        if Control1 == true then
				Cmd_Move(TrainOne, mkr_trainto2)
				Rule_RemoveMe()
        end
end

function OptionalTrainDisappear()

		local Control1 = Prox_AreSquadsNearMarker(TrainOne, mkr_trainto2, true)
        if Control1 == true then
				SGroup_DestroyAllSquads(TrainOne)
				Rule_RemoveMe()
        end
end


------------------------------Village Event-----------------------------------

function VillageEvent()

        Rule_AddDelayedInterval(VillageStart, 1, 1)
		Rule_AddDelayedInterval(VillageAlert, 1, 1)
		
		Rule_AddDelayedInterval(VillageRegionExpand, 1, 1)
		
		Rule_AddDelayedInterval(OfficersMoveSouth, 1, 15)
		Rule_AddDelayedInterval(OfficersMoveWest, 1, 15)
		Rule_AddDelayedInterval(OfficersMoveNorth, 1, 15)

end


function VillageStart()

        local Control1 = SGroup_Count(Koch)
        if Control1 == 1 then
				local Control2 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_villagetrigger, false)
        		if Control2 == true then
		        		local Control3 = Player_OwnsEGroup(player1, Point2, true)
						local Control4 = Player_OwnsEGroup(player2, Point2, true)
						if Control3 == false and Control4 == false then
								Util_StartIntel(EVENTS.VillageCinematic)
								Rule_RemoveMe()
						end
				end
        end
end

function VillageAlert()

        local Control1 = SGroup_Count(Koch)
        if Control1 == 1 then
		        local Control2 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_villagetriggerone, false)
		        local Control3 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_villagetriggertwo, false)
		        local Control4 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_villagetriggerthree, false)
                if Control2 == true or Control3 == true or Control4 == true then
		                local Control5 = Player_OwnsEGroup(player1, Point2, true)
				        local Control6 = Player_OwnsEGroup(player2, Point2, true)
				        if Control5 == false and Control6 == false then
						        Util_StartIntel(EVENTS.VillageWarningDialogue)
						        SGroup_Kill(VillageFightControl)
						        SGroup_SetMoodMode(Koch, MM_Auto)
		        		        SGroup_SetMoodMode(Lohse, MM_Auto)
		        		        SGroup_SetMoodMode(Dassler, MM_Auto)
						        Cmd_Retreat(Koch)
						        Cmd_Retreat(Lohse)
						        Cmd_Retreat(Dassler)
						        Rule_RemoveMe()
						end
				end
        end
end

function VillageRegionExpand()

        local Control1 = EGroup_IsCapturedByPlayer(Point1, player1, false)
        local Control2 = EGroup_IsCapturedByPlayer(Point1, player2, false)
        if Control1 == true or Control2 == true then
                local Control3 = SGroup_Count(VillageRegionControl)
                if Control3 == 0 then
				        Blip2 = UI_CreateMinimapBlip(Point2, 9000, BT_ObjectivePrimary)
		        		World_GetCurrentInteractionStage()
                        World_IncreaseInteractionStage()
						Rule_RemoveMe()
				end
        end
end


function OfficersMoveSouth()

        local Control1 = SGroup_Count(VillageFightControl)
        if Control1 == 0 then
		        local Control1 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_villagesouth, false)
                if Control1 == false then
        				local Random = World_GetRand(1, 7)
      		   		    if Random == 1 then
     		  		            Cmd_Move(KGroup, mkr_kochwest)
								Cmd_Move(LGroup, mkr_lohsewest)
								Cmd_Move(DGroup, mkr_dasslerwest)
     		 		    elseif Random == 2 then
     		 		            Cmd_Move(KGroup, mkr_kochnorth)
								Cmd_Move(LGroup, mkr_lohsewest)
								Cmd_Move(DGroup, mkr_dasslerwest)
     		 		    elseif Random == 3 then
      		  		            Cmd_Move(KGroup, mkr_kochwest)
								Cmd_Move(LGroup, mkr_lohsenorth)
								Cmd_Move(DGroup, mkr_dasslerwest)
						elseif Random == 4 then
     		 		            Cmd_Move(KGroup, mkr_kochwest)
								Cmd_Move(LGroup, mkr_lohsewest)
								Cmd_Move(DGroup, mkr_dasslernorth)
						elseif Random == 5 then
     		 		            Cmd_Move(KGroup, mkr_kochnorth)
								Cmd_Move(LGroup, mkr_lohsenorth)
								Cmd_Move(DGroup, mkr_dasslerwest)
						elseif Random == 6 then
     		 		            Cmd_Move(KGroup, mkr_kochnorth)
								Cmd_Move(LGroup, mkr_lohsewest)
								Cmd_Move(DGroup, mkr_dasslernorth)
						elseif Random == 7 then
     		 		            Cmd_Move(KGroup, mkr_kochwest)
								Cmd_Move(LGroup, mkr_lohsenorth)
								Cmd_Move(DGroup, mkr_dasslernorth)
						end
                end
		end
end

function OfficersMoveWest()

        local Control1 = SGroup_Count(VillageFightControl)
        if Control1 == 0 then
		        local Control1 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_villagewest, false)
                if Control1 == false then
        				local Random = World_GetRand(1, 7)
      		   		    if Random == 1 then
     		  		            Cmd_Move(KGroup, mkr_kochsouth)
								Cmd_Move(LGroup, mkr_lohsesouth)
								Cmd_Move(DGroup, mkr_dasslersouth)
     		 		    elseif Random == 2 then
     		 		            Cmd_Move(KGroup, mkr_kochnorth)
								Cmd_Move(LGroup, mkr_lohsesouth)
								Cmd_Move(DGroup, mkr_dasslersouth)
     		 		    elseif Random == 3 then
      		  		            Cmd_Move(KGroup, mkr_kochsouth)
								Cmd_Move(LGroup, mkr_lohsenorth)
								Cmd_Move(DGroup, mkr_dasslersouth)
						elseif Random == 4 then
     		 		            Cmd_Move(KGroup, mkr_kochsouth)
								Cmd_Move(LGroup, mkr_lohsesouth)
								Cmd_Move(DGroup, mkr_dasslernorth)
						elseif Random == 5 then
     		 		            Cmd_Move(KGroup, mkr_kochnorth)
								Cmd_Move(LGroup, mkr_lohsenorth)
								Cmd_Move(DGroup, mkr_dasslersouth)
						elseif Random == 6 then
     		 		            Cmd_Move(KGroup, mkr_kochnorth)
								Cmd_Move(LGroup, mkr_lohsesouth)
								Cmd_Move(DGroup, mkr_dasslernorth)
						elseif Random == 7 then
     		 		            Cmd_Move(KGroup, mkr_kochsouth)
								Cmd_Move(LGroup, mkr_lohsenorth)
								Cmd_Move(DGroup, mkr_dasslernorth)
						end
                end
		end
end

function OfficersMoveNorth()

        local Control1 = SGroup_Count(VillageFightControl)
        if Control1 == 0 then
		        local Control1 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_villagenorth, false)
                if Control1 == false then
        				local Random = World_GetRand(1, 7)
      		   		    if Random == 1 then
     		  		            Cmd_Move(KGroup, mkr_kochwest)
								Cmd_Move(LGroup, mkr_lohsewest)
								Cmd_Move(DGroup, mkr_dasslerwest)
     		 		    elseif Random == 2 then
     		 		            Cmd_Move(KGroup, mkr_kochsouth)
								Cmd_Move(LGroup, mkr_lohsewest)
								Cmd_Move(DGroup, mkr_dasslerwest)
     		 		    elseif Random == 3 then
      		  		            Cmd_Move(KGroup, mkr_kochwest)
								Cmd_Move(LGroup, mkr_lohsesouth)
								Cmd_Move(DGroup, mkr_dasslerwest)
						elseif Random == 4 then
     		 		            Cmd_Move(KGroup, mkr_kochwest)
								Cmd_Move(LGroup, mkr_lohsewest)
								Cmd_Move(DGroup, mkr_dasslersouth)
						elseif Random == 5 then
     		 		            Cmd_Move(KGroup, mkr_kochsouth)
								Cmd_Move(LGroup, mkr_lohsesouth)
								Cmd_Move(DGroup, mkr_dasslerwest)
						elseif Random == 6 then
     		 		            Cmd_Move(KGroup, mkr_kochsouth)
								Cmd_Move(LGroup, mkr_lohsewest)
								Cmd_Move(DGroup, mkr_dasslersouth)
						elseif Random == 7 then
     		 		            Cmd_Move(KGroup, mkr_kochwest)
								Cmd_Move(LGroup, mkr_lohsesouth)
								Cmd_Move(DGroup, mkr_dasslersouth)
						end
                end
		end
end

------------------------------Cache Event---------------------------------


function CacheEvent()

        Rule_AddDelayedInterval(CacheStart, 1, 1)

		Rule_AddDelayedInterval(CacheReinforcements, 1, 1)
		
		Rule_AddDelayedInterval(CacheSturmAttack, 1, 10)
		
		Rule_AddDelayedInterval(CacheVision, 1, 1)
		Rule_AddDelayedInterval(CacheTalk, 1, 1)

end

function CacheStart()

        local Control1 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_cachetrigger, false)
		if Control1 == true then
                Util_StartIntel(EVENTS.CacheBegin)
				Rule_RemoveMe()
        end
end

function CacheReinforcements()

        local Control1 = SGroup_Count(CacheKubel)
        if Control1 == 0 then
                Cmd_Move(CacheOber, mkr_cacheoberto)
				Cmd_Move(CacheCar, mkr_cachecarto)
				Rule_RemoveMe()
        end
end

function CacheSturmAttack()

        local Control1 = SGroup_Count(CacheKubel)
        if Control1 == 0 then
				local Control2 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_cachearea, false)
				if Control2 == true then
                		Target = Player_GetSquadConcentration(player1)
                		Cmd_Move(CacheSturm, Target)
				end
		end
end

function CacheVision()

        local Control1 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_towertrigger, false)
		if Control1 == true then
                FOW_RevealMarker(mkr_cachevision, 9999)
		elseif Control1 == false then
		        FOW_UnRevealMarker(mkr_cachevision)
		end
end

function CacheTalk()

        local Control1 = SGroup_Count(CacheControl)
		if Control1 == 1 then
		        local Control2 = Prox_AreSquadsNearMarker(Kurt, mkr_towertrigger, false)
				if Control2 == true then
                        Util_StartIntel(EVENTS.CacheKurtDialogue)
				        Rule_RemoveMe()
				elseif Control2 == false then
				        local Control3 = Prox_AreSquadsNearMarker(Otto, mkr_towertrigger, false)
						if Control3 == true then
				                Util_StartIntel(EVENTS.CacheOttoDialogue)
				                Rule_RemoveMe()
						elseif Control3 == false then
						        local Control4 = Prox_AreSquadsNearMarker(Tomislav, mkr_towertrigger, false)
								if Control4 == true then
								        Util_StartIntel(EVENTS.CacheTomislavDialogue)
				                        Rule_RemoveMe()
								elseif Control4 == false then
								        local Control5 = Prox_AreSquadsNearMarker(Hans, mkr_towertrigger, false)
										if Control5 == true then
								                Util_StartIntel(EVENTS.CacheHansDialogue)
				                                Rule_RemoveMe()
										end
                                end
						end
				end
		end
end

------------------------------Bridge Event---------------------------------


function BridgeEvent()

        Rule_AddDelayedInterval(BridgeStart, 1, 1)
		
		Rule_AddDelayedInterval(BridgeAssEngineerMove, 1, 1)
		Rule_AddDelayedInterval(BridgeTommyMove, 1, 1)
		Rule_AddDelayedInterval(BridgeRifleMove, 1, 1)

end

function BridgeStart()

        local Control1 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_bridgestarttrigger, false)
		if Control1 == true then
                Util_StartIntel(EVENTS.BridgeDialogue)
				Rule_RemoveMe()
        end
end

function BridgeAssEngineerMove()

        local Control1 = Prox_AreSquadsNearMarker(BridgeAssEngineer, mkr_bridgemovearea, false)
		if Control1 == true then
                Cmd_Move(BridgeAssEngineer, mkr_bridgeassengineerto)
				SGroup_SetInvulnerable(BridgeAllies, false)
        end
end

function BridgeTommyMove()

        local Control1 = Prox_AreSquadsNearMarker(BridgeTommy, mkr_bridgemovearea, false)
		if Control1 == true then
                Cmd_Move(BridgeTommy, mkr_bridgetommyto)
				SGroup_SetInvulnerable(BridgeAllies, false)
        end
end

function BridgeRifleMove()

        local Control1 = Prox_AreSquadsNearMarker(BridgeRifle, mkr_bridgemovearea, false)
		if Control1 == true then
                Cmd_Move(BridgeRifle, mkr_bridgerifleto)
				SGroup_SetInvulnerable(BridgeAllies, false)
        end
end


------------------------------Camp Event----------------------------------

function CampEvent()

        Rule_AddDelayedInterval(CampChatter, 1, 1)

        Rule_AddDelayedInterval(CampStart, 1, 1)
		Rule_AddDelayedInterval(CampTrainThreeCheck, 1, 1)
		Rule_AddDelayedInterval(CampProgression, 1, 1)

		Rule_AddDelayedInterval(CampRetreat, 1, 1)
		
		Rule_AddDelayedInterval(CampMichaelAttackMove, 1, 1)

end

function CampChatter()

        local Control1 = SGroup_CanSeeSGroup(PlayerUnits, CampChatGroup, false)
		local Control2 = SGroup_Count(CampEnemyGroup)
		if Control1 == true and Control2 == 17 then
                Util_StartIntel(EVENTS.CampScoutTalk)
				Rule_RemoveMe()
        end
end

function CampStart()

        local Control1 = EGroup_IsCapturedByPlayer(Point3, player1, false)
        local Control2 = EGroup_IsCapturedByPlayer(Point3, player2, false)
        if Control1 == true or Control2 == true then
                Util_StartIntel(EVENTS.CampDialogue)
				Rule_RemoveMe()
        end
end

function CampOptionalChoiceCheck()

		local Control1 = SGroup_Count(TrainOne)
		if Control1 == 1 then
                SGroup_Kill(OptionalChoice)
				Rule_RemoveMe()
        end
end

function CampTrainThreeCheck()

        local Control1 = EGroup_IsCapturedByPlayer(Point4, player1, false)
        local Control2 = EGroup_IsCapturedByPlayer(Point4, player2, false)
        if Control1 == true or Control2 == true then
		        local Control3 = SGroup_Count(OptionalChoice)
				if Control3 == 0 then
                        SGroup_WarpToMarker(TrainThree, mkr_trainthreewarp)
				        Rule_RemoveMe()
				end
        end
end

function CampProgression()

        local Control = SGroup_GetAvgHealth(CampPanther)
        if Control < 0.99 then
                Util_StartIntel(EVENTS.CampSecondDialogue)
				Rule_RemoveMe()
        end
end

function CampRetreat()

        local Control1 = Prox_AreSquadsNearMarker(CampOfficerGroup, mkr_campretreattrigger, false)
		if Control1 == true then
                SGroup_DeSpawn(CampOfficerGroup)
				EGroup_DeSpawn(CampEnemyRetreat)
				Rule_RemoveMe()
        end
end

function CampMichaelAttackMove()

        local Control1 = SGroup_Count(CampPanther)
		local Control2 = SGroup_Count(CampEnemyGroup)
		if Control1 == 0 and Control2 == 16 then
                Cmd_Move(Michael, mkr_michaeltpto)
        end
end


------------------------------Fort Event----------------------------------

function FortEvent()

        Rule_AddDelayedInterval(FortTrainVision, 1, 1)
		Rule_AddDelayedInterval(TigerDeathFailsafe, 1, 1)

        Rule_AddDelayedInterval(FortStaging, 1, 1)
		Rule_AddDelayedInterval(MichaelStaging, 1, 1)
		
		Rule_AddDelayedInterval(FortReadyCheck, 1, 1)
		
		Rule_AddDelayedInterval(FortStart, 1, 1)
		Rule_AddDelayedInterval(FortBodyguardDeath, 1, 1)
		
		Rule_AddDelayedInterval(FortStageTwoStart, 1, 1)
		Rule_AddDelayedInterval(FortStageThreeStart, 1, 1)
		Rule_AddDelayedInterval(FortStageFourStart, 1, 1)
		
		Rule_AddDelayedInterval(WoodStageTwoStart, 1, 1)
		Rule_AddDelayedInterval(WoodStageThreeStart, 1, 1)
		Rule_AddDelayedInterval(WoodStageFourStart, 1, 1)
		Rule_AddDelayedInterval(WoodStageFiveStart, 1, 1)
		Rule_AddDelayedInterval(WoodSovietPush, 1, 1)
		
		Rule_AddDelayedInterval(FortEndBodyguardsFlee, 1, 1)
		Rule_AddDelayedInterval(FortEndBodyguardsStay, 1, 1)
		Rule_AddDelayedInterval(FortEndBodyguardsWarp, 1, 1)
		
		Rule_AddDelayedInterval(FortVolksSpawn, 1, 90)
		Rule_AddDelayedInterval(FortPanzerGrenSpawn, 1, 120)
		Rule_AddDelayedInterval(FortAssGrenSpawn, 1, 80)
		Rule_AddDelayedInterval(FortFusilierSpawn, 1, 100)
		Rule_AddDelayedInterval(FortGrenSpawn, 1, 120)
		
		Rule_AddDelayedInterval(FortGrenShrek, 1, 1)
		
	    Rule_AddDelayedInterval(WoodStormSpawn, 1, 150)
		Rule_AddDelayedInterval(WoodVolksSpawn, 1, 120)
		Rule_AddDelayedInterval(WoodAssGrenSpawn, 1, 100)
		Rule_AddDelayedInterval(WoodPanzerGrenSpawn, 1, 170)
			
		Rule_AddDelayedInterval(FortVolksMove, 1, 15)
		Rule_AddDelayedInterval(FortPanzerGrenMove, 1, 15)
		Rule_AddDelayedInterval(FortAssGrenMove, 1, 15)
		Rule_AddDelayedInterval(FortFusilierMove, 1, 15)
		Rule_AddDelayedInterval(FortGrenMove, 1, 1)
		
		Rule_AddDelayedInterval(WoodStormMove, 1, 100)
		Rule_AddDelayedInterval(WoodVolksMove, 1, 80)
		Rule_AddDelayedInterval(WoodAssGrenMove, 1, 60)
		Rule_AddDelayedInterval(WoodPanzerGrenMove, 1, 110)
		
		Rule_AddDelayedInterval(FortRifleRetreat, 1, 1)
		Rule_AddDelayedInterval(FortEngineerRetreat, 1, 1)
		Rule_AddDelayedInterval(FortParaRetreat, 1, 1)
		Rule_AddDelayedInterval(FortEchelonRetreat, 1, 1)
		Rule_AddDelayedInterval(WoodRifleRetreat, 1, 1)
		Rule_AddDelayedInterval(WoodRangerRetreat, 1, 1)
		Rule_AddDelayedInterval(WoodEchelonRetreat, 1, 1)
		
		Rule_AddDelayedInterval(FortRifleDespawn, 1, 1)
		Rule_AddDelayedInterval(FortEngineerDespawn, 1, 1)
		Rule_AddDelayedInterval(FortParaDespawn, 1, 1)
		Rule_AddDelayedInterval(FortEchelonDespawn, 1, 1)
		Rule_AddDelayedInterval(WoodRifleDespawn, 1, 1)
		Rule_AddDelayedInterval(WoodRangerDespawn, 1, 1)
		Rule_AddDelayedInterval(WoodEchelonDespawn, 1, 1)
		
		Rule_AddDelayedInterval(FortRifleSpawn, 1, 1)
		Rule_AddDelayedInterval(FortEngineerSpawn, 1, 1)
		Rule_AddDelayedInterval(FortParaSpawn, 1, 1)
		Rule_AddDelayedInterval(FortEchelonSpawn, 1, 1)
		Rule_AddDelayedInterval(WoodRifleSpawn, 1, 1)
		Rule_AddDelayedInterval(WoodRangerSpawn, 1, 1)
		Rule_AddDelayedInterval(WoodEchelonSpawn, 1, 1)
		
		Rule_AddDelayedInterval(FortRifleTransfer, 1, 1)
		Rule_AddDelayedInterval(FortEngineerTransfer, 1, 1)
		Rule_AddDelayedInterval(FortParaTransfer, 1, 1)
		Rule_AddDelayedInterval(FortEchelonTransfer, 1, 1)
		Rule_AddDelayedInterval(WoodRifleTransfer, 1, 1)
		Rule_AddDelayedInterval(WoodRangerTransfer, 1, 1)
		Rule_AddDelayedInterval(WoodEchelonTransfer, 1, 1)
		
		Rule_AddDelayedInterval(FortRifleRedirect, 1, 1)
		Rule_AddDelayedInterval(FortEngineerRedirect, 1, 1)
		Rule_AddDelayedInterval(FortParaRedirect, 1, 1)
		Rule_AddDelayedInterval(FortEchelonRedirect, 1, 1)
		
		Rule_AddDelayedInterval(FortRifleMove, 1, 1.3)
		Rule_AddDelayedInterval(FortEngineerMove, 1, 1.3)
		Rule_AddDelayedInterval(FortParaMove, 1, 1.3)
		Rule_AddDelayedInterval(FortEchelonMove, 1, 1.3)
		Rule_AddDelayedInterval(WoodRifleMove, 1, 1.3)
		Rule_AddDelayedInterval(WoodRangerMove, 1, 1.3)
		Rule_AddDelayedInterval(WoodEchelonMove, 1, 1.3)
		


end

function FortTrainVision()

        local Control1 = Prox_AreSquadsNearMarker(TrainTwo, mkr_traintwoto1, false)
		if Control1 == true then
                SGroup_Hide(TrainTwo, true)
		        SGroup_EnableMinimapIndicator(TrainTwo, false)
				SGroup_DestroyAllSquads(TrainTwo)
        end
end

function TigerDeathFailsafe()

        local Control1 = SGroup_GetAvgHealth(Michael)
        if Control1 < 0.03 then
                SGroup_SetInvulnerableToCritical(Michael, false)
				Rule_RemoveMe()
        end
end

function FortStaging()

        local Control1 = SGroup_Count(CampFortTriggerGroup)
		if Control1 == 0 then
                Util_StartIntel(EVENTS.FortInitialTalk)
				Rule_RemoveMe()
        end
end

function MichaelStaging()

        local Control1 = Prox_AreSquadsNearMarker(Michael, mkr_fortmichaelstaging, false)
		local Control2 = SGroup_Count(CampPanther)
		if Control1 == true and Control2 == 0 then
                Cmd_Move(Michael, mkr_fortmichaelto1)
				Rule_RemoveMe()
        end
end

function FortReadyCheck()

        local Control1 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_fortreadydialogue, false)
		if Control1 == true then
                Util_StartIntel(EVENTS.FortReadyTalk)
				Rule_RemoveMe()
        end
end

function FortStart()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point4, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point4, player2, false)
        if PointFocus1 == true or PointFocus2 == true then
		        Util_StartIntel(EVENTS.FortInitiation)
				Rule_RemoveMe()
        end
end

function FortBodyguardDeath()

        local Control1 = SGroup_Count(FortBodyguard)
        if Control1 == 0 then
		        local Control1 = SGroup_Count(Fitzgerald)
                if Control1 == 1 then
				        World_GetCurrentInteractionStage()
                        World_IncreaseInteractionStage()
				        Rule_RemoveMe()
				end
        end
end

function FortStageTwoStart()

        local Control1 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 then
                local Control2 = SGroup_Count(FortStageOneGroup)
                if Control2 == 0 then
		                SGroup_WarpToMarker(FortStageTwoEnemyGroup, mkr_fortwarppoint)
				        SGroup_WarpToMarker(FortStageTwoFlak, mkr_fortstagetwoflakwarp)
		                SGroup_Kill(FortStageTwo)
		                Cmd_Move(Michael, mkr_fortmichaelto3)
				        Cmd_Move(Fitzgerald, mkr_fortfitzgeraldto3)
				        Cmd_AttackMove(FortStageTwoLeft, mkr_fortstagetwoleftto)
				        Cmd_Move(FortStageTwoFlak, mkr_fortstagetwoflakto)
				        Cmd_Move(FortStageTwoMortar, mkr_fortstagetwomortarto)
				        Cmd_Move(FortStageTwoAssGren, mkr_fortstagetwoleftto)
				        Cmd_Move(FortStageTwoMG, mkr_fortstagetwomgto)
				        Cmd_Move(FortStageTwoVolksOne, mkr_fortstagetwovolksoneto)
				        Cmd_Move(FortStageTwoVolksTwo, mkr_fortstagetwovolkstwoto)
				        Cmd_Move(FortStageTwoVolksThree, mkr_fortstagetwovolksthreeto)
				        Cmd_Move(FortStageTwoVolksFour, mkr_fortstagetwovolksfourto)
				        Cmd_Move(FortStageTwoGrenOne, mkr_fortstagetwogrenoneto)
				        Cmd_Move(FortStageTwoGrenTwo, mkr_fortstagetwogrentwoto)
				        Cmd_Move(FortStageTwoFusilierOne, mkr_fortstagetwofusilieroneto)
				        Cmd_Move(FortStageTwoFusilierTwo, mkr_fortstagetwofusiliertwoto)
				        Rule_RemoveMe()
			    end
        end
end

function FortStageThreeStart()

        local Control1 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 then
                local Control2 = SGroup_Count(FortStageTwoGroup)
                if Control2 == 0 then
		                SGroup_WarpToMarker(FortStageThreeEnemyGroup, mkr_fortwarppoint)
				        SGroup_WarpToMarker(FortStageThreePanther, mkr_fortstagethreepantherwarp)
		                SGroup_Kill(FortStageThree)
		                Cmd_Move(Michael, mkr_fortmichaelto4)
				        Cmd_Move(Fitzgerald, mkr_fortfitzgeraldto4)
				        Cmd_Move(FortStageThreePanther, mkr_fortstagethreepantherto)
                        Cmd_Move(FortStageThreeStorm, mkr_fortstagethreestormto)
				        Cmd_Move(FortStageThreeRatken, mkr_fortstagethreeratkento)
				        Cmd_Move(FortStageThreeMortar, mkr_fortstagethreemortarto)
				        Cmd_Move(FortStageThreeFusilier, mkr_fortstagethreefusilierto)
				        Cmd_Move(FortStageThreeMGOne, mkr_fortstagethreemgoneto)
				        Cmd_Move(FortStageThreeMGTwo, mkr_fortstagethreemgtwoto)
				        Cmd_Move(FortStageThreeVolks, mkr_fortstagethreevolksto)
				        Rule_RemoveMe()
				end
        end
end

function FortStageFourStart()

        local Control1 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 then
                local Control2 = SGroup_Count(FortStageThreeGroup)
                if Control2 == 0 then
		                Util_CreateSquads(player5, FortEnemySpawnControl, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_fortenemyspawncontrolpoint)
		                Cmd_Move(Michael, mkr_fortmichaelto5)
				        Cmd_Move(Fitzgerald, mkr_fortfitzgeraldto5)
				        Rule_RemoveMe()
				end
        end
end

function WoodStageTwoStart()

        local Control1 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 then
                local Control2 = SGroup_Count(WoodStageOneGroup)
                if Control2 == 0 then
		                SGroup_WarpToMarker(WoodStageTwoAttackGroup, mkr_woodstagetwoattackgroupwarp)
		                SGroup_Kill(WoodStageTwo)
				        Target = Player_GetSquadConcentration(player1)
				        Cmd_AttackMove(WoodStageTwoAttackGroup, Target)
				        Cmd_Move(WoodStageTwoAttackAssGren, Target)
		                Cmd_Move(Dmitriy, mkr_wooddmitriyto3)
                        Cmd_Move(Nikolai, mkr_woodnikolaito3)
				        Cmd_Move(Viktor, mkr_woodviktorto3)
				        Cmd_Move(Vladilen, mkr_woodvladilento3)
				        Cmd_Move(Stator, mkr_woodstatorto3)
				        Cmd_Move(Yuri, mkr_woodyurito3)
				        Cmd_Move(Aleksei, mkr_woodalekseito3)
				        Rule_RemoveMe()
				end
        end
end

function WoodStageThreeStart()

        local Control1 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 then
                local Control2 = SGroup_Count(WoodStageTwoGroup)
                if Control2 == 0 then
		                SGroup_WarpToMarker(WoodStageThreeAttackGroup, mkr_woodstagethreeattackgroupwarp)
		                SGroup_Kill(WoodStageThree)
				        Target = Player_GetSquadConcentration(player1)
				        Cmd_AttackMove(WoodStageThreeAttackGroup, Target)
				        Cmd_Move(WoodStageThreeAttackAssGren, Target)
		                Cmd_Move(Dmitriy, mkr_wooddmitriyto4)
                        Cmd_Move(Nikolai, mkr_woodnikolaito4)
				        Cmd_Move(Viktor, mkr_woodviktorto4)
				        Cmd_Move(Vladilen, mkr_woodvladilento4)
				        Cmd_Move(Stator, mkr_woodstatorto4)
				        Cmd_Move(Yuri, mkr_woodyurito4)
				        Cmd_Move(Aleksei, mkr_woodalekseito4)
				        Rule_RemoveMe()
				end
        end
end

function WoodStageFourStart()

        local Control1 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 then
                local Control2 = SGroup_Count(WoodStageThreeGroup)
                if Control2 == 0 then
		                SGroup_Kill(WoodStageFour)
		                Cmd_Move(Dmitriy, mkr_wooddmitriyto5)
                        Cmd_Move(Nikolai, mkr_woodnikolaito5)
				        Cmd_Move(Viktor, mkr_woodviktorto5)
				        Cmd_Move(Vladilen, mkr_woodvladilento5)
				        Cmd_Move(Stator, mkr_woodstatorto5)
				        Cmd_Move(Yuri, mkr_woodyurito5)
				        Cmd_Move(Aleksei, mkr_woodalekseito5)
				        Rule_RemoveMe()
				end
        end
end

function WoodStageFiveStart()

        local Control1 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 then
                local Control2 = SGroup_Count(WoodStageFourGroup)
                if Control2 == 0 then
		                Util_CreateSquads(player5, FortEnemySpawnControl, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_fortenemyspawncontrolpoint)
		                SGroup_Kill(WoodStageFive)
		                Cmd_Move(Dmitriy, mkr_wooddmitriyto6)
                        Cmd_Move(Nikolai, mkr_woodnikolaito6)
				        Cmd_Move(Viktor, mkr_woodviktorto6)
				        Cmd_Move(Vladilen, mkr_woodvladilento6)
				        Cmd_Move(Stator, mkr_woodstatorto6)
				        Cmd_Move(Yuri, mkr_woodyurito6)
				        Cmd_Move(Aleksei, mkr_woodalekseito6)
				        Rule_RemoveMe()
				end
        end
end

function WoodSovietPush()

        local Control1 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 then
                local Control2 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_woodsovietpushtrigger, false)
                if Control2 == true then
		                Util_CreateSquads(player5, FortEnemySpawnControl, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_fortenemyspawncontrolpoint)
		                SGroup_Kill(WoodStageFour)
		                Cmd_Move(Dmitriy, mkr_wooddmitriyto7)
                        Cmd_Move(Nikolai, mkr_woodnikolaito7)
				        Cmd_Move(Viktor, mkr_woodviktorto7)
				        Cmd_Move(Vladilen, mkr_woodvladilento7)
				        Cmd_Move(Stator, mkr_woodstatorto7)
				        Cmd_Move(Yuri, mkr_woodyurito7)
				        Cmd_Move(Aleksei, mkr_woodalekseito7)
				        Rule_RemoveMe()
				end
        end
end

function FortEndBodyguardsFlee()

        local Control1 = SGroup_IsUnderAttack(FortBodyguard, false, 9999)
        if Control1 == true then
		        local Control2 = SGroup_Count(FortEndingControl)
				if Control2 == 1 then
		                local Control3 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_fortendarea1, false)
				        local Control4 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_fortendarea2, false)
                        if Control3 == true or Control4 == true then
				                SGroup_Kill(FortEndingControl)
		                        Util_StartIntel(EVENTS.FortEndingFlee)
								Rule_RemoveMe()
						end
				end
        end
end

function FortEndBodyguardsStay()

        local Control1 = SGroup_IsUnderAttack(FortBodyguard, false, 9999)
        if Control1 == true then
		        local Control2 = SGroup_Count(FortEndingControl)
				if Control2 == 1 then
						local Control3 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_fortendarea3, false)
						local Control4 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_fortendarea4, false)
						local Control5 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_fortendarea5, false)
						if Control3 == true or Control4 == true or Control5 == true then
				        		SGroup_Kill(FortEndingControl)
				        		Util_StartIntel(EVENTS.FortEndingStay)
								Rule_RemoveMe()
						end
				end
        end
end

function FortEndBodyguardsWarp()

        local Control1 = Prox_AreSquadsNearMarker(FortBodyguard, mkr_fortbodyguardretreatto, false)
        if Control1 == true then
		        SGroup_WarpToMarker(FortBodyguard, mkr_finalebodyguardwarp)
				Rule_RemoveMe()
		end
end


function FortVolksSpawn()

        local Control1 = SGroup_Count(FortVolks)
		local Control2 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 and Control2 == 0 then
				Util_CreateSquads(player5, FortVolks, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_fortenemyspawn)
        end
end

function FortPanzerGrenSpawn()

        local Control1 = SGroup_Count(FortPanzerGren)
		local Control2 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 and Control2 == 0 then
				Util_CreateSquads(player5, FortPanzerGren, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_fortenemyspawn)
        end
end

function FortAssGrenSpawn()

        local Control1 = SGroup_Count(FortAssGren)
		local Control2 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 and Control2 == 0 then
				Util_CreateSquads(player5, FortAssGren, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_fortenemyspawn)
        end
end

function FortFusilierSpawn()

        local Control1 = SGroup_Count(FortFusilier)
		local Control2 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 and Control2 == 0 then
				Util_CreateSquads(player5, FortFusilier, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, mkr_fortenemyspawn)
        end
end

function FortGrenSpawn()

        local Control1 = SGroup_Count(FortGren)
		local Control2 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 and Control2 == 0 then
				Util_CreateSquads(player5, FortGren, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_fortenemyspawn)
				local ControlEntity1 = SGroup_GetSpawnedSquadAt(FortGren, 1)
                Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.PANZERSHRECK_MP)
				Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.PANZERSHRECK_MP)
        end
end

function FortGrenShrek()

        local Control1 = Prox_AreSquadsNearMarker(FortGren, mkr_fortenemyspawn, false)
        if Control1 == true then
				local ControlEntity1 = SGroup_GetSpawnedSquadAt(FortGren, 1)
                Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.PANZERSHRECK_MP)
				Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.PANZERSHRECK_MP)
        end
end

function WoodStormSpawn()

        local Control1 = SGroup_Count(WoodStorm)
		local Control2 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 and Control2 == 0 then
				Util_CreateSquads(player5, WoodStorm, SBP.GERMAN.STORMTROOPER_SQUAD_MP, mkr_fortenemyspawn)
        end
end

function WoodVolksSpawn()

        local Control1 = SGroup_Count(WoodVolks)
		local Control2 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 and Control2 == 0 then
				Util_CreateSquads(player5, WoodVolks, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_fortenemyspawn)
        end
end

function WoodAssGrenSpawn()

        local Control1 = SGroup_Count(WoodAssGren)
		local Control2 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 and Control2 == 0 then
				Util_CreateSquads(player5, WoodAssGren, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_fortenemyspawn)
        end
end

function WoodPanzerGrenSpawn()

        local Control1 = SGroup_Count(WoodPanzerGren)
		local Control2 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 and Control2 == 0 then
				Util_CreateSquads(player5, WoodPanzerGren, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_fortenemyspawn)
        end
end

function FortVolksMove()

        local Control1 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(FortStageControl)
                if Control2 == 3 then
                        local Random = World_GetRand(1, 8)
                        if Random == 1 then
				                Cmd_Move(FortVolks, mkr_fortonetarget1)
				        elseif Random == 2 then
				                Cmd_Move(FortVolks, mkr_fortonetarget2)
				        elseif Random == 3 then
				                Cmd_Move(FortVolks, mkr_fortonetarget3)
				        elseif Random == 4 then
				                Cmd_Move(FortVolks, mkr_fortonetarget4)
				        elseif Random == 5 then
				                Cmd_AttackMove(FortVolks, mkr_fortonetarget1)
				        elseif Random == 6 then
				                Cmd_AttackMove(FortVolks, mkr_fortonetarget2)
				        elseif Random == 7 then
				                Cmd_AttackMove(FortVolks, mkr_fortonetarget3)
				        elseif Random == 8 then
				                Cmd_AttackMove(FortVolks, mkr_fortonetarget4)
						end
				local Control2 = SGroup_Count(FortStageControl)
                elseif Control2 == 2 then
                        local Random = World_GetRand(1, 8)
                        if Random == 1 then
				                Cmd_Move(FortVolks, mkr_forttwotarget1)
				        elseif Random == 2 then
				                Cmd_Move(FortVolks, mkr_forttwotarget2)
				        elseif Random == 3 then
				                Cmd_Move(FortVolks, mkr_forttwotarget3)
				        elseif Random == 4 then
				                Cmd_Move(FortVolks, mkr_forttwotarget4)
				        elseif Random == 5 then
				                Cmd_AttackMove(FortVolks, mkr_forttwotarget1)
				        elseif Random == 6 then
				                Cmd_AttackMove(FortVolks, mkr_forttwotarget2)
				        elseif Random == 7 then
				                Cmd_AttackMove(FortVolks, mkr_forttwotarget3)
				        elseif Random == 8 then
				                Cmd_AttackMove(FortVolks, mkr_forttwotarget4)
						end
				local Control2 = SGroup_Count(FortStageControl)
                elseif Control2 == 1 then
                        local Random = World_GetRand(1, 8)
                        if Random == 1 then
				                Cmd_Move(FortVolks, mkr_fortthreetarget1)
				        elseif Random == 2 then
				                Cmd_Move(FortVolks, mkr_fortthreetarget2)
				        elseif Random == 3 then
				                Cmd_Move(FortVolks, mkr_fortthreetarget3)
				        elseif Random == 4 then
				                Cmd_Move(FortVolks, mkr_fortthreetarget4)
				        elseif Random == 5 then
				                Cmd_AttackMove(FortVolks, mkr_fortthreetarget1)
				        elseif Random == 6 then
				                Cmd_AttackMove(FortVolks, mkr_fortthreetarget2)
				        elseif Random == 7 then
				                Cmd_AttackMove(FortVolks, mkr_fortthreetarget3)
				        elseif Random == 8 then
				                Cmd_AttackMove(FortVolks, mkr_fortthreetarget4)
						end
				end
        end
end

function FortPanzerGrenMove()

        local Control1 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(FortStageControl)
                if Control2 == 3 then
                        local Random = World_GetRand(1, 4)
                        if Random == 1 then
				                Cmd_Move(FortPanzerGren, mkr_fortonetarget1)
				        elseif Random == 2 then
				                Cmd_Move(FortPanzerGren, mkr_fortonetarget2)
				        elseif Random == 3 then
				                Cmd_Move(FortPanzerGren, mkr_fortonetarget3)
				        elseif Random == 4 then
				                Cmd_Move(FortPanzerGren, mkr_fortonetarget4)
						end
				local Control2 = SGroup_Count(FortStageControl)
                elseif Control2 == 2 then
                        local Random = World_GetRand(1, 4)
                        if Random == 1 then
				                Cmd_Move(FortPanzerGren, mkr_forttwotarget1)
				        elseif Random == 2 then
				                Cmd_Move(FortPanzerGren, mkr_forttwotarget2)
				        elseif Random == 3 then
				                Cmd_Move(FortPanzerGren, mkr_forttwotarget3)
				        elseif Random == 4 then
				                Cmd_Move(FortPanzerGren, mkr_forttwotarget4)
				        end
				local Control2 = SGroup_Count(FortStageControl)
                elseif Control2 == 1 then
                        local Random = World_GetRand(1, 4)
                        if Random == 1 then
				                Cmd_Move(FortPanzerGren, mkr_fortthreetarget1)
				        elseif Random == 2 then
				                Cmd_Move(FortPanzerGren, mkr_fortthreetarget2)
				        elseif Random == 3 then
				                Cmd_Move(FortPanzerGren, mkr_fortthreetarget3)
				        elseif Random == 4 then
				                Cmd_Move(FortPanzerGren, mkr_fortthreetarget4)
						end
				end
        end
end

function FortAssGrenMove()

        local Control1 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(FortStageControl)
                if Control2 == 3 then
                        local Random = World_GetRand(1, 4)
                        if Random == 1 then
				                Cmd_Move(FortAssGren, mkr_fortonetarget1)
				        elseif Random == 2 then
				                Cmd_Move(FortAssGren, mkr_fortonetarget2)
				        elseif Random == 3 then
				                Cmd_Move(FortAssGren, mkr_fortonetarget3)
				        elseif Random == 4 then
				                Cmd_Move(FortAssGren, mkr_fortonetarget4)
						end
				local Control2 = SGroup_Count(FortStageControl)
                elseif Control2 == 2 then
                        local Random = World_GetRand(1, 4)
                        if Random == 1 then
				                Cmd_Move(FortAssGren, mkr_forttwotarget1)
				        elseif Random == 2 then
				                Cmd_Move(FortAssGren, mkr_forttwotarget2)
				        elseif Random == 3 then
				                Cmd_Move(FortAssGren, mkr_forttwotarget3)
				        elseif Random == 4 then
				                Cmd_Move(FortAssGren, mkr_forttwotarget4)
						end
				local Control2 = SGroup_Count(FortStageControl)
                elseif Control2 == 1 then
                        local Random = World_GetRand(1, 4)
                        if Random == 1 then
				                Cmd_Move(FortAssGren, mkr_fortthreetarget1)
				        elseif Random == 2 then
				                Cmd_Move(FortAssGren, mkr_fortthreetarget2)
				        elseif Random == 3 then
				                Cmd_Move(FortAssGren, mkr_fortthreetarget3)
				        elseif Random == 4 then
				                Cmd_Move(FortAssGren, mkr_fortthreetarget4)
						end
				end
        end
end

function FortFusilierMove()

        local Control1 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(FortStageControl)
                if Control2 == 3 then
                        local Random = World_GetRand(1, 8)
                        if Random == 1 then
				                Cmd_Move(FortFusilier, mkr_fortonetarget1)
				        elseif Random == 2 then
				                Cmd_Move(FortFusilier, mkr_fortonetarget2)
				        elseif Random == 3 then
				                Cmd_Move(FortFusilier, mkr_fortonetarget3)
				        elseif Random == 4 then
				                Cmd_Move(FortFusilier, mkr_fortonetarget4)
				        elseif Random == 5 then
				                Cmd_AttackMove(FortFusilier, mkr_fortonetarget1)
				        elseif Random == 6 then
				                Cmd_AttackMove(FortFusilier, mkr_fortonetarget2)
				        elseif Random == 7 then
				                Cmd_AttackMove(FortFusilier, mkr_fortonetarget3)
				        elseif Random == 8 then
				                Cmd_AttackMove(FortFusilier, mkr_fortonetarget4)
						end
				local Control2 = SGroup_Count(FortStageControl)
                elseif Control2 == 2 then
                        local Random = World_GetRand(1, 8)
                        if Random == 1 then
				                Cmd_Move(FortFusilier, mkr_forttwotarget1)
				        elseif Random == 2 then
				                Cmd_Move(FortFusilier, mkr_forttwotarget2)
				        elseif Random == 3 then
				                Cmd_Move(FortFusilier, mkr_forttwotarget3)
				        elseif Random == 4 then
				                Cmd_Move(FortFusilier, mkr_forttwotarget4)
				        elseif Random == 5 then
				                Cmd_AttackMove(FortFusilier, mkr_forttwotarget1)
				        elseif Random == 6 then
				                Cmd_AttackMove(FortFusilier, mkr_forttwotarget2)
				        elseif Random == 7 then
				                Cmd_AttackMove(FortFusilier, mkr_forttwotarget3)
				        elseif Random == 8 then
				                Cmd_AttackMove(FortFusilier, mkr_forttwotarget4)
						end
				local Control2 = SGroup_Count(FortStageControl)
                elseif Control2 == 1 then
                        local Random = World_GetRand(1, 8)
                        if Random == 1 then
				                Cmd_Move(FortFusilier, mkr_fortthreetarget1)
				        elseif Random == 2 then
				                Cmd_Move(FortFusilier, mkr_fortthreetarget2)
				        elseif Random == 3 then
				                Cmd_Move(FortFusilier, mkr_fortthreetarget3)
				        elseif Random == 4 then
				                Cmd_Move(FortFusilier, mkr_fortthreetarget4)
				        elseif Random == 5 then
				                Cmd_AttackMove(FortFusilier, mkr_fortthreetarget1)
				        elseif Random == 6 then
				                Cmd_AttackMove(FortFusilier, mkr_fortthreetarget2)
				        elseif Random == 7 then
				                Cmd_AttackMove(FortFusilier, mkr_fortthreetarget3)
				        elseif Random == 8 then
				                Cmd_AttackMove(FortFusilier, mkr_fortthreetarget4)
						end
				end
        end
end

function FortGrenMove()

        local Control1 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 then
                Cmd_Attack(FortGren, Michael)
        end
end

function WoodStormMove()

        local Control1 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(FortStageControl)
                if Control2 == 3 then
                        local Random = World_GetRand(1, 4)
                        if Random == 1 then
				                Cmd_Move(WoodStorm, mkr_woodonetarget1)
				        elseif Random == 2 then
				                Cmd_Move(WoodStorm, mkr_woodonetarget2)
				        elseif Random == 3 then
				                Cmd_AttackMove(WoodStorm, mkr_woodonetarget1)
				        elseif Random == 4 then
				                Cmd_AttackMove(WoodStorm, mkr_woodonetarget2)
						end
				local Control2 = SGroup_Count(FortStageControl)
                elseif Control2 == 2 then
                        local Random = World_GetRand(1, 4)
                        if Random == 1 then
				                Cmd_Move(WoodStorm, mkr_woodtwotarget1)
				        elseif Random == 2 then
				                Cmd_Move(WoodStorm, mkr_woodtwotarget2)
				        elseif Random == 3 then
				                Cmd_AttackMove(WoodStorm, mkr_woodtwotarget1)
				        elseif Random == 4 then
				                Cmd_AttackMove(WoodStorm, mkr_woodtwotarget2)
						end
				end
        end
end

function WoodVolksMove()

        local Control1 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(FortStageControl)
                if Control2 == 3 then
                        local Random = World_GetRand(1, 4)
                        if Random == 1 then
				                Cmd_Move(WoodVolks, mkr_woodonetarget1)
				        elseif Random == 2 then
				                Cmd_Move(WoodVolks, mkr_woodonetarget2)
				        elseif Random == 3 then
				                Cmd_AttackMove(WoodVolks, mkr_woodonetarget1)
				        elseif Random == 4 then
				                Cmd_AttackMove(WoodVolks, mkr_woodonetarget2)
						end
				local Control2 = SGroup_Count(FortStageControl)
                elseif Control2 == 2 then
                        local Random = World_GetRand(1, 4)
                        if Random == 1 then
				                Cmd_Move(WoodVolks, mkr_woodtwotarget1)
				        elseif Random == 2 then
				                Cmd_Move(WoodVolks, mkr_woodtwotarget2)
				        elseif Random == 3 then
				                Cmd_AttackMove(WoodVolks, mkr_woodtwotarget1)
				        elseif Random == 4 then
				                Cmd_AttackMove(WoodVolks, mkr_woodtwotarget2)
						end
				end
        end
end

function WoodAssGrenMove()

        local Control1 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 then
	            local Control2 = SGroup_Count(FortStageControl)
                if Control2 == 3 then
                        local Random = World_GetRand(1, 2)
                        if Random == 1 then
				                Cmd_Move(WoodAssGren, mkr_woodonetarget1)
				        elseif Random == 2 then
				                Cmd_Move(WoodAssGren, mkr_woodonetarget2)
						end
				local Control2 = SGroup_Count(FortStageControl)
                elseif Control2 == 2 then
                        local Random = World_GetRand(1, 2)
                        if Random == 1 then
				                Cmd_Move(WoodAssGren, mkr_woodtwotarget1)
				        elseif Random == 2 then
				                Cmd_Move(WoodAssGren, mkr_woodtwotarget2)
						end
				end
        end
end

function WoodPanzerGrenMove()

        local Control1 = SGroup_Count(FortEnemySpawnControl)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(FortStageControl)
                if Control2 == 3 then
                        local Random = World_GetRand(1, 2)
                        if Random == 1 then
				                Cmd_Move(WoodPanzerGren, mkr_woodonetarget1)
				        elseif Random == 2 then
				                Cmd_Move(WoodPanzerGren, mkr_woodonetarget2)
						end
				local Control2 = SGroup_Count(FortStageControl)
                elseif Control2 == 2 then
                        local Random = World_GetRand(1, 2)
                        if Random == 1 then
				                Cmd_Move(WoodPanzerGren, mkr_woodtwotarget1)
				        elseif Random == 2 then
				                Cmd_Move(WoodPanzerGren, mkr_woodtwotarget2)
						end
				end
        end
end

function FortRifleRetreat()

        local Control1 = SGroup_GetAvgHealth(FortRifle)
        if Control1 < 0.3 then
                Cmd_Retreat(FortRifle)
        end
end

function FortEngineerRetreat()

        local Control1 = SGroup_GetAvgHealth(FortEngineer)
        if Control1 < 0.3 then
                Cmd_Retreat(FortEngineer)
        end
end

function FortParaRetreat()

        local Control1 = SGroup_GetAvgHealth(FortPara)
        if Control1 < 0.3 then
                Cmd_Retreat(FortPara)
        end
end

function FortEchelonRetreat()

        local Control1 = SGroup_GetAvgHealth(FortEchelon)
        if Control1 < 0.3 then
                Cmd_Retreat(FortEchelon)
        end
end

function WoodRifleRetreat()

        local Control1 = SGroup_GetAvgHealth(WoodRifle)
        if Control1 < 0.3 then
                Cmd_Retreat(WoodRifle)
        end
end

function WoodRangerRetreat()

        local Control1 = SGroup_GetAvgHealth(WoodRanger)
        if Control1 < 0.3 then
                Cmd_Retreat(WoodRanger)
        end
end

function WoodEchelonRetreat()

        local Control1 = SGroup_GetAvgHealth(WoodEchelon)
        if Control1 < 0.3 then
                Cmd_Retreat(WoodEchelon)
        end
end

function FortRifleDespawn()

        local Control4 = SGroup_Count(FortStageControl)
        if Control4 > 0 then
                local Control1 = Prox_AreSquadsNearMarker(FortRifle, mkr_fortretreatpoint, false)
		        if Control1 == true then
                        local Control2 = SGroup_GetAvgHealth(FortRifle)
		                if Control2 < 0.5 then
		                        local Control3 = SGroup_Count(FortRifle)
		        		        if Control3 == 1 then
		        				        SGroup_DestroyAllSquads(FortRifle)
								end
						end
                end
        end
end

function FortEngineerDespawn()

        local Control4 = SGroup_Count(FortStageControl)
        if Control4 > 0 then
                local Control1 = Prox_AreSquadsNearMarker(FortEngineer, mkr_fortretreatpoint, false)
		        if Control1 == true then
                        local Control2 = SGroup_GetAvgHealth(FortEngineer)
		                if Control2 < 0.5 then
		                        local Control3 = SGroup_Count(FortEngineer)
		        		        if Control3 == 1 then
		        				        SGroup_DestroyAllSquads(FortEngineer)
								end
						end
                end
        end
end

function FortParaDespawn()

        local Control4 = SGroup_Count(FortStageControl)
        if Control4 > 0 then
                local Control1 = Prox_AreSquadsNearMarker(FortPara, mkr_fortretreatpoint, false)
		        if Control1 == true then
                        local Control2 = SGroup_GetAvgHealth(FortPara)
		                if Control2 < 0.5 then
		                        local Control3 = SGroup_Count(FortPara)
		        		        if Control3 == 1 then
		        				        SGroup_DestroyAllSquads(FortPara)
								end
						end
                end
        end
end

function FortEchelonDespawn()

        local Control4 = SGroup_Count(FortStageControl)
        if Control4 > 0 then
                local Control1 = Prox_AreSquadsNearMarker(FortEchelon, mkr_fortretreatpoint, false)
		        if Control1 == true then
                        local Control2 = SGroup_GetAvgHealth(FortEchelon)
		                if Control2 < 0.5 then
		                        local Control3 = SGroup_Count(FortEchelon)
		        		        if Control3 == 1 then
		        				        SGroup_DestroyAllSquads(FortEchelon)
								end
						end
                end
        end
end

function WoodRifleDespawn()

        local Control4 = SGroup_Count(FortStageControl)
        if Control4 > 0 then
                local Control1 = Prox_AreSquadsNearMarker(WoodRifle, mkr_fortretreatpoint, false)
		        if Control1 == true then
                        local Control2 = SGroup_GetAvgHealth(WoodRifle)
		                if Control2 < 0.5 then
		                        local Control3 = SGroup_Count(WoodRifle)
		        		        if Control3 == 1 then
		        				        SGroup_DestroyAllSquads(WoodRifle)
								end
						end
                end
        end
end

function WoodRangerDespawn()

        local Control4 = SGroup_Count(FortStageControl)
        if Control4 > 0 then
                local Control1 = Prox_AreSquadsNearMarker(WoodRanger, mkr_fortretreatpoint, false)
		        if Control1 == true then
                        local Control2 = SGroup_GetAvgHealth(WoodRanger)
		                if Control2 < 0.5 then
		                        local Control3 = SGroup_Count(WoodRanger)
				                if Control3 == 1 then
				        		        SGroup_DestroyAllSquads(WoodRanger)
								end
						end
                end
        end
end

function WoodEchelonDespawn()

        local Control4 = SGroup_Count(FortStageControl)
        if Control4 > 0 then
                local Control1 = Prox_AreSquadsNearMarker(WoodEchelon, mkr_fortretreatpoint, false)
		        if Control1 == true then
                        local Control2 = SGroup_GetAvgHealth(WoodEchelon)
		                if Control2 < 0.5 then
		                        local Control3 = SGroup_Count(WoodEchelon)
		        		        if Control3 == 1 then
		        				        SGroup_DestroyAllSquads(WoodEchelon)
								end
						end
                end
        end
end

function FortRifleSpawn()

        local Control1 = SGroup_Count(FortEnemySpawnControl)
	    if Control1 == 0 then
                local Control2 = SGroup_Count(FortRifle)
	            if Control2 == 0 then
		                Util_CreateSquads(player3, FortRifle, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_fortretreatpoint)
				end
		end
end

function FortEngineerSpawn()

        local Control1 = SGroup_Count(FortEnemySpawnControl)
	    if Control1 == 0 then
                local Control2 = SGroup_Count(FortEngineer)
                if Control2 == 0 then
		                Util_CreateSquads(player3, FortEngineer, SBP.BRITISH.SAPPER_SQUAD_MP, mkr_fortretreatpoint)
				end
		end
end

function FortParaSpawn()

        local Control1 = SGroup_Count(FortEnemySpawnControl)
	    if Control1 == 0 then
                local Control2 = SGroup_Count(FortPara)
                if Control2 == 0 then
		                Util_CreateSquads(player3, FortPara, SBP.AEF.PARATROOPER_SQUAD_MP, mkr_fortretreatpoint)
				end
		end
end

function FortEchelonSpawn()

        local Control1 = SGroup_Count(FortEnemySpawnControl)
	    if Control1 == 0 then
                local Control2 = SGroup_Count(FortEchelon)
                if Control2 == 0 then
		                Util_CreateSquads(player3, FortEchelon, SBP.AEF.REAR_ECHELON_SQUAD_MP, mkr_fortretreatpoint)
				end
		end
end

function WoodRifleSpawn()

        local Control1 = SGroup_Count(FortEnemySpawnControl)
	    if Control1 == 0 then
                local Control2 = SGroup_Count(WoodRifle)
                if Control2 == 0 then
		                Util_CreateSquads(player3, WoodRifle, SBP.BRITISH.TOMMY_SQUAD_MP, mkr_fortretreatpoint)
				end
		end
end

function WoodRangerSpawn()

        local Control1 = SGroup_Count(FortEnemySpawnControl)
	    if Control1 == 0 then
                local Control2 = SGroup_Count(WoodRanger)
                if Control2 == 0 then
		                Util_CreateSquads(player3, WoodRanger, SBP.AEF.RANGER_SQUAD_MP, mkr_fortretreatpoint)
				end
		end
end

function WoodEchelonSpawn()

        local Control1 = SGroup_Count(FortEnemySpawnControl)
	    if Control1 == 0 then
                local Control2 = SGroup_Count(WoodEchelon)
                if Control2 == 0 then
		                Util_CreateSquads(player3, WoodEchelon, SBP.AEF.REAR_ECHELON_SQUAD_MP, mkr_fortretreatpoint)
				end
		end
end

function FortRifleTransfer()

        local Control1 = Prox_AreSquadsNearMarker(FortRifle, mkr_fortretreatpoint, false)
		if Control1 == true then
		        Cmd_Move(FortRifle, mkr_fortrifleredirect)
        end
end

function FortEngineerTransfer()

        local Control1 = Prox_AreSquadsNearMarker(FortEngineer, mkr_fortretreatpoint, false)
		if Control1 == true then
		        Cmd_Move(FortEngineer, mkr_fortengineerredirect)
        end
end

function FortParaTransfer()

        local Control1 = Prox_AreSquadsNearMarker(FortPara, mkr_fortretreatpoint, false)
		if Control1 == true then
		        Cmd_Move(FortPara, mkr_fortpararedirect)
        end
end

function FortEchelonTransfer()

        local Control1 = Prox_AreSquadsNearMarker(FortEchelon, mkr_fortretreatpoint, false)
		if Control1 == true then
		        Cmd_Move(FortEchelon, mkr_fortechelonredirect)
        end
end

function WoodRifleTransfer()

        local Control1 = Prox_AreSquadsNearMarker(WoodRifle, mkr_fortretreatpoint, false)
		if Control1 == true then
		        Cmd_Move(WoodRifle, mkr_woodredirect)
        end
end

function WoodRangerTransfer()

        local Control1 = Prox_AreSquadsNearMarker(WoodRanger, mkr_fortretreatpoint, false)
		if Control1 == true then
		        Cmd_Move(WoodRanger, mkr_woodredirect)
        end
end

function WoodEchelonTransfer()

        local Control1 = Prox_AreSquadsNearMarker(WoodEchelon, mkr_fortretreatpoint, false)
		if Control1 == true then
		        Cmd_Move(WoodEchelon, mkr_woodredirect)
        end
end

function FortRifleRedirect()

        local Control1 = Prox_AreSquadsNearMarker(FortRifle, mkr_fortrifleredirect, false)
		if Control1 == true then
                Cmd_Move(FortRifle, mkr_fortrifleto1)
		end
end

function FortEngineerRedirect()

        local Control1 = Prox_AreSquadsNearMarker(FortEngineer, mkr_fortengineerredirect, false)
		if Control1 == true then
                Cmd_Move(FortEngineer, mkr_fortengineerto1)
		end
end

function FortParaRedirect()

        local Control1 = Prox_AreSquadsNearMarker(FortPara, mkr_fortpararedirect, false)
		if Control1 == true then
                Cmd_Move(FortPara, mkr_fortparato1)
		end
end

function FortEchelonRedirect()

        local Control1 = Prox_AreSquadsNearMarker(FortEchelon, mkr_fortechelonredirect, false)
		if Control1 == true then
                Cmd_Move(FortEchelon, mkr_fortechelonto1)
		end
end

function FortRifleMove()

        local Control1 = Prox_AreSquadsNearMarker(FortRifle, mkr_fortmovecontrol, false)
		if Control1 == true then
                local Control2 = SGroup_Count(FortStageControl)
                if Control2 == 3 then
				        Cmd_AttackMove(FortRifle, mkr_fortrifleto2)
				elseif Control2 == 2 then
				        Cmd_AttackMove(FortRifle, mkr_fortrifleto3)
			    elseif Control2 == 1 then
				        Cmd_AttackMove(FortRifle, mkr_fortrifleto4)
				end
        end
end

function FortEngineerMove()

        local Control1 = Prox_AreSquadsNearMarker(FortEngineer, mkr_fortmovecontrol, false)
		if Control1 == true then
                local Control2 = SGroup_Count(FortStageControl)
                if Control2 == 3 then
				        Cmd_Move(FortEngineer, mkr_fortengineerto2)
				elseif Control2 == 2 then
				        Cmd_AttackMove(FortEngineer, mkr_fortengineerto3)
			    elseif Control2 == 1 then
				        Cmd_AttackMove(FortEngineer, mkr_fortengineerto4)
				end
        end
end

function FortParaMove()

        local Control1 = Prox_AreSquadsNearMarker(FortPara, mkr_fortmovecontrol, false)
		if Control1 == true then
                local Control2 = SGroup_Count(FortStageControl)
                if Control2 == 3 then
				        Cmd_AttackMove(FortPara, mkr_fortparato2)
				elseif Control2 == 2 then
				        Cmd_AttackMove(FortPara, mkr_fortparato3)
			    elseif Control2 == 1 then
				        Cmd_AttackMove(FortPara, mkr_fortparato4)
				end
        end
end

function FortEchelonMove()

        local Control1 = Prox_AreSquadsNearMarker(FortEchelon, mkr_fortmovecontrol, false)
		if Control1 == true then
                local Control2 = SGroup_Count(FortStageControl)
                if Control2 == 3 then
				        Cmd_AttackMove(FortEchelon, mkr_fortechelonto2)
				elseif Control2 == 2 then
				        Cmd_AttackMove(FortEchelon, mkr_fortechelonto3)
			    elseif Control2 == 1 then
				        Cmd_AttackMove(FortEchelon, mkr_fortechelonto4)
				end
        end
end

function WoodRifleMove()

        local Control1 = Prox_AreSquadsNearMarker(WoodRifle, mkr_woodmovecontrol, false)
		if Control1 == true then
                local Control2 = SGroup_Count(WoodStageControl)
                if Control2 == 4 then
				        Cmd_Move(WoodRifle, mkr_woodrifleto2)
				local Control2 = SGroup_Count(WoodStageControl)
                elseif Control2 == 3 then
				        Cmd_Move(WoodRifle, mkr_woodrifleto3)
				local Control2 = SGroup_Count(WoodStageControl)
                elseif Control2 == 2 then
				        Cmd_Move(WoodRifle, mkr_woodrifleto4)
				local Control2 = SGroup_Count(WoodStageControl)
                elseif Control2 == 1 then
				        Cmd_Move(WoodRifle, mkr_woodrifleto5)
				end
        end
end

function WoodRangerMove()

        local Control1 = Prox_AreSquadsNearMarker(WoodRanger, mkr_woodmovecontrol, false)
		if Control1 == true then
                local Control2 = SGroup_Count(WoodStageControl)
                if Control2 == 4 then
				        Cmd_Move(WoodRanger, mkr_woodrangerto2)
				local Control2 = SGroup_Count(WoodStageControl)
                elseif Control2 == 3 then
				        Cmd_Move(WoodRanger, mkr_woodrangerto3)
				local Control2 = SGroup_Count(WoodStageControl)
                elseif Control2 == 2 then
				        Cmd_Move(WoodRanger, mkr_woodrangerto4)
				local Control2 = SGroup_Count(WoodStageControl)
                elseif Control2 == 1 then
				        Cmd_Move(WoodRanger, mkr_woodrangerto5)
				end
        end
end

function WoodEchelonMove()

        local Control1 = Prox_AreSquadsNearMarker(WoodEchelon, mkr_woodmovecontrol, false)
		if Control1 == true then
                local Control2 = SGroup_Count(WoodStageControl)
                if Control2 == 4 then
				        Cmd_Move(WoodEchelon, mkr_woodechelonto2)
				local Control2 = SGroup_Count(WoodStageControl)
                elseif Control2 == 3 then
				        Cmd_Move(WoodEchelon, mkr_woodechelonto3)
				local Control2 = SGroup_Count(WoodStageControl)
                elseif Control2 == 2 then
				        Cmd_Move(WoodEchelon, mkr_woodechelonto4)
				local Control2 = SGroup_Count(WoodStageControl)
                elseif Control2 == 1 then
				        Cmd_Move(WoodEchelon, mkr_woodechelonto5)
				end
        end
end

------------------------------Mill Event----------------------------------

function MillEvent()

        Rule_AddDelayedInterval(MillStagingMove, 1, 1)
		Rule_AddDelayedInterval(MillStart, 1, 1)
		Rule_AddDelayedInterval(MillMovePrompt, 1, 1)
		
		Rule_AddDelayedInterval(MillPullout, 1, 1)
		
		Rule_AddDelayedInterval(MillSupplyDialogue, 1, 1)
		
		Rule_AddDelayedInterval(MillTruckOneDespawn, 1, 1)
		Rule_AddDelayedInterval(MillTruckTwoDespawn, 1, 1)
		Rule_AddDelayedInterval(MillTruckThreeDespawn, 1, 1)
		
end

function MillStagingMove()

        local Control1 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_millmovetrigger, false)
		if Control1 == true then
                Cmd_Move(Michael, mkr_fortmichaelto7)
		        Cmd_Move(Fitzgerald, mkr_fortfitzgeraldto7)
				Rule_RemoveMe()
		end
end

function MillStart()

        local Control1 = EGroup_IsCapturedByPlayer(Point5, player1, false)
        local Control2 = EGroup_IsCapturedByPlayer(Point5, player2, false)
        if Control1 == true or Control2 == true then
		        SGroup_DestroyAllSquads(CampAreaUnits)
                Util_StartIntel(EVENTS.MillDialogue)
				Rule_RemoveMe()
		end
end

function MillMovePrompt()

        local Control1 = Prox_AreSquadsNearMarker(Fitzgerald, mkr_millfitzgeraldto2, false)
		if Control1 == true then
		        local Control2 = EGroup_IsCapturedByPlayer(Point5, player1, false)
                local Control3 = EGroup_IsCapturedByPlayer(Point5, player2, false)
                if Control2 == true or Control3 == true then
                        Util_StartIntel(EVENTS.MillFitzgeraldSpeech)
				        Rule_RemoveMe()
				end
		end
end

function MillPullout()

        local Control1 = SGroup_IsUnderAttack(MillAreaUnits, false, 9999)
        if Control1 == true then
		        Util_StartIntel(EVENTS.MillRetreat)
				Rule_RemoveMe()
        end
end

function MillSupplyDialogue()

        local Control1 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_millsupplydialoguetrigger, false)
		if Control1 == true then
                Util_StartIntel(EVENTS.MillSupplyTalk)
				Rule_RemoveMe()
		end
end

function MillTruckOneDespawn()

        local Control1 = Prox_AreSquadsNearMarker(MillTruckOne, mkr_milltruckoneto, false)
		if Control1 == true then
		        SGroup_Kill(MillTruckOne)
				SGroup_DestroyAllSquads(MillLoadOne)
				Rule_RemoveMe()
        end
end

function MillTruckTwoDespawn()

        local Control1 = Prox_AreSquadsNearMarker(MillTruckTwo, mkr_milltrucktwoto, false)
		if Control1 == true then
		        SGroup_Kill(MillTruckTwo)
				SGroup_DestroyAllSquads(MillLoadTwo)
				Rule_RemoveMe()
        end
end

function MillTruckThreeDespawn()

        local Control1 = Prox_AreSquadsNearMarker(MillTruckThree, mkr_milltruckthreeto, false)
		if Control1 == true then
		        SGroup_Kill(MillTruckThree)
				SGroup_DestroyAllSquads(MillLoadThree)
				Rule_RemoveMe()
        end
end

------------------------------Trench Event----------------------------------

function TrenchEvent()

        Rule_AddDelayedInterval(TrenchStaging, 1, 1)
		Rule_AddDelayedInterval(TrenchVisionStart, 1, 1)
		Rule_AddDelayedInterval(TrenchAttackStart, 1, 1)
		Rule_AddDelayedInterval(TrenchAreaProgress, 1, 1)
		
		Rule_AddDelayedInterval(TrenchHelp, 1, 1)
		Rule_AddDelayedInterval(TrenchAssault, 1, 1)
		
		Rule_AddDelayedInterval(TrenchBacktrackFailsafe, 1, 1)
		
		Rule_AddInterval(TrenchLeftTarget, 10, 1)
		Rule_AddInterval(TrenchMidTarget, 10, 1)
		Rule_AddInterval(TrenchRightTarget, 10, 1)

end

function TrenchStaging()

        local Control1 = EGroup_IsCapturedByPlayer(Point6, player1, false)
        local Control2 = EGroup_IsCapturedByPlayer(Point6, player2, false)
        if Control1 == true or Control2 == true then
				SGroup_SetPlayerOwner(TrenchVictimGren, player3)
				SGroup_SetPlayerOwner(TrenchVictimAssGren, player3)
				SGroup_SetPlayerOwner(TrenchVictimVolks, player3)
				Rule_RemoveMe()
		end
end

function TrenchVisionStart()

        local Control2 = SGroup_CanSeeSGroup(PlayerUnits, TrenchVictimGren, false)
		local Control3 = SGroup_CanSeeSGroup(PlayerUnits, TrenchVictimAssGren, false)
		local Control4 = SGroup_CanSeeSGroup(PlayerUnits, TrenchVictimVolks, false)
        if Control2 == true or Control3 == true or Control4 == true then
				SGroup_SetPlayerOwner(TrenchVictims, player3)
				SGroup_SetInvulnerable(TrenchAreaUnits, false)
				Cmd_Attack(TrenchMidOber, TrenchVictimAssGren)
				Cmd_Attack(TrenchRightVolks, TrenchVictimGren)
				Cmd_Move(TrenchMidSturm, mkr_trenchsturmto)
				Cmd_Move(TrenchRightStorm, mkr_trenchstormto)
				Rule_RemoveMe()
		end
end

function TrenchAttackStart()

		local Control1 = SGroup_IsUnderAttackByPlayer(TrenchAttackers, player1, 9999)
		local Control2 = SGroup_IsUnderAttackByPlayer(TrenchAttackers, player2, 9999)
        if Control1 == true or Control2 == true then
		        local Control3 = SGroup_Count(TrenchVictims)
                if Control3 > 0 then
				        local Control4 = SGroup_Count(FinaleAirstrikeControl)
                        if Control4 == 1 then
				                Util_StartIntel(EVENTS.TrenchAttackersAliveDialogue)
				                Rule_RemoveMe()	
				        elseif Control3 == 0 then
				                Util_StartIntel(EVENTS.TrenchAttackersDeadDialogue)
				                Rule_RemoveMe()
						end
				end
		end
end

function TrenchAreaProgress()

        local Control1 = SGroup_Count(TrenchElites)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(Fitzgerald)
                if Control2 == 1 then
		                World_GetCurrentInteractionStage()
                        World_IncreaseInteractionStage()
						Rule_RemoveMe()
				end
		end
end

function TrenchHelp()

        local Control1 = Prox_AreSquadsNearMarker(Kurt, mkr_trenchhelptrigger, false)
		local Control2 = Prox_AreSquadsNearMarker(Otto, mkr_trenchhelptrigger, false)
		local Control3 = Prox_AreSquadsNearMarker(Hans, mkr_trenchhelptrigger, false)
		if Control1 == true or Control2 == true or Control3 == true then
		        local Control4 = Prox_AreSquadsNearMarker(Fitzgerald, mkr_millfitzgeraldto2, false)
                if Control4 == true then
				        local Control5 = SGroup_Count(TrenchControl)
                        if Control5 == 0 then
		                        Util_StartIntel(EVENTS.TrenchFitzgeraldTalk)
				                Rule_RemoveMe()
						end
				end
        end
end

function TrenchAssault()

        local Control1 = Prox_AreSquadsNearMarker(Kurt, mkr_trenchassaulttrigger, false)
		local Control2 = Prox_AreSquadsNearMarker(Otto, mkr_trenchassaulttrigger, false)
		local Control3 = Prox_AreSquadsNearMarker(Hans, mkr_trenchassaulttrigger, false)
		if Control1 == true or Control2 == true or Control3 == true then
				local Control4 = SGroup_Count(TrenchControl)
                if Control4 == 0 then
						local Control5 = Prox_AreSquadsNearMarker(Fitzgerald, mkr_trenchfitzgeraldto1, false)
                        if Control5 == true then
								Util_StartIntel(EVENTS.TrenchFitzgeraldAssault)
				                Rule_RemoveMe()
						end
				end
        end
end

function TrenchBacktrackFailsafe()

		local Control1 = SGroup_Count(TrenchElites)
        if Control1 == 0 then
		        Cmd_Move(Fitzgerald, mkr_millfitzgeraldfailsafe)
				Rule_RemoveMe()
        end
end


function TrenchLeftTarget()

		local Control1 = SGroup_IsUnderAttackByPlayer(TrenchLeftGroup, player1, 9999)
		local Control2 = SGroup_IsUnderAttackByPlayer(TrenchLeftGroup, player2, 9999)
        if Control1 == true or Control2 == true then
		        local Control3 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_trenchassaulttrigger, false)
				if Control3 == true then
                        Target = Player_GetSquadConcentration(player1)
                        Cmd_Move(TrenchLeftAssGren, Target)
				elseif Control3 == false then
				        Cmd_Move(TrenchLeftAssGren, mkr_trenchassgrento)
				end
		end
end

function TrenchMidTarget()

		local Control1 = SGroup_IsUnderAttackByPlayer(TrenchMidGroup, player1, 9999)
		local Control2 = SGroup_IsUnderAttackByPlayer(TrenchMidGroup, player2, 9999)
        if Control1 == true or Control2 == true then
		        local Control3 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_trenchassaulttrigger, false)
				if Control3 == true then
                        Target = Player_GetSquadConcentration(player1)
                        Cmd_Move(TrenchMidSturm, Target)
				elseif Control3 == false then
				        Cmd_Move(TrenchMidSturm, mkr_trenchsturmto)
				end
		end
end

function TrenchRightTarget()

		local Control1 = SGroup_IsUnderAttackByPlayer(TrenchRightGroup, player1, 9999)
		local Control2 = SGroup_IsUnderAttackByPlayer(TrenchRightGroup, player2, 9999)
        if Control1 == true or Control2 == true then
		        local Control3 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_trenchassaulttrigger, false)
				if Control3 == true then
                        Target = Player_GetSquadConcentration(player1)
                        Cmd_AttackMove(TrenchRightStorm, Target)
				elseif Control3 == false then
				        Cmd_Move(TrenchRightStorm, mkr_trenchstormto)
				end
		end
end

------------------------------Outpost Event----------------------------------

function OutpostEvent()

        Rule_AddDelayedInterval(OutpostTowerDialogue, 1, 1)
		Rule_AddDelayedInterval(OutpostWaterDialogue, 1, 1)
		Rule_AddDelayedInterval(OutpostFitzgeraldDialogue, 1, 1)
		Rule_AddDelayedInterval(OutpostVision, 1, 1)

        Rule_AddDelayedInterval(OutpostAlliesMove, 1, 1)
        Rule_AddDelayedInterval(OutpostSwap, 1, 1)
		Rule_AddDelayedInterval(OutpostTriggerSwap, 1, 1)
		
		Rule_AddDelayedInterval(OutpostGunMove, 1, 1)
		Rule_AddDelayedInterval(OutpostTarget, 1, 1)

end

function OutpostTowerDialogue()

        local Control1 = SGroup_Count(OutpostControl)
		if Control1 == 1 then
		        local Control2 = Prox_AreSquadsNearMarker(Kurt, mkr_outposttower, false)
				if Control2 == true then
                        Util_StartIntel(EVENTS.OutpostKurtDialogue)
				        Rule_RemoveMe()
				elseif Control2 == false then
				        local Control3 = Prox_AreSquadsNearMarker(Otto, mkr_outposttower, false)
						if Control3 == true then
				                Util_StartIntel(EVENTS.OutpostOttoDialogue)
				                Rule_RemoveMe()
						elseif Control3 == false then
						        local Control4 = Prox_AreSquadsNearMarker(Hans, mkr_outposttower, false)
								if Control4 == true then
								        Util_StartIntel(EVENTS.OutpostHansDialogue)
				                        Rule_RemoveMe()
                                end
						end
				end
		end
end

function OutpostWaterDialogue()

        local Control1 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_waterdialoguetrigger, false)
		if Control1 == true then
		        Util_StartIntel(EVENTS.OutpostFreezingDialogue)
				Rule_RemoveMe()
        end
end

function OutpostFitzgeraldDialogue()

        local Control1 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_outpostfitzgeraldartytrigger, false)
		if Control1 == true then
		        local Control2 = SGroup_Count(OutpostControl)
                if Control2 == 0 then
				        local Control3 = Prox_AreSquadsNearMarker(Fitzgerald, mkr_outpostfitzgeraldto, false)
		                if Control3 == true then
		                        Util_StartIntel(EVENTS.OutpostReportBackDialogue)
				                Rule_RemoveMe()
					    end
				end
        end
end

function OutpostVision()

        local Control1 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_outposttower, false)
		if Control1 == true then
                FOW_RevealMarker(mkr_outpostvision, 9999)
		elseif Control1 == false then
		        FOW_UnRevealMarker(mkr_outpostvision)
		end
end

function OutpostAlliesMove()

        local Control1 = EGroup_IsCapturedByPlayer(Point7, player1, false)
        local Control2 = EGroup_IsCapturedByPlayer(Point7, player2, false)
        if Control1 == true or Control2 == true then
		        Cmd_Move(Fitzgerald, mkr_outpostfitzgeraldto)
                Cmd_Move(ForwardRanger, mkr_outpostrangerto)
	            Cmd_Move(ForwardEchelon, mkr_outpostechelonto)
	            Cmd_Move(ForwardSapper, mkr_outpostsapperto)
	            Cmd_Move(ForwardCommando, mkr_outpostcommandoto)
	            Cmd_Move(ForwardPara, mkr_outpostparato)
	            Cmd_Move(ForwardTommy, mkr_outposttommyto)
				Rule_RemoveMe()
        end
end

function OutpostSwap()

        local Control1 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_outpostartyswap, false)
		if Control1 == true then
		        local Control2 = SGroup_Count(OutpostAreaUnits)
                if Control2 == 0 then
				        local Control3 = SGroup_Count(OutpostControl)
                        if Control3 == 1 then
		                        Util_StartIntel(EVENTS.OutpostArtyDialogue)
				                Rule_RemoveMe()
				        end
		        end
	    end
end

function OutpostTriggerSwap()

		local Control1 = SGroup_IsUnderAttackByPlayer(SchneiderAreaUnits, player1, 9999)
		local Control2 = SGroup_IsUnderAttackByPlayer(SchneiderAreaUnits, player2, 9999)
        if Control1 == true or Control2 == true then
		        local Control2 = SGroup_Count(OutpostSwapControl)
                if Control2 == 0 then
						Util_StartIntel(EVENTS.OutpostTankSwap)
						Rule_RemoveMe()
				end
		end
end

function OutpostGunMove()

		local Control1 = SGroup_IsUnderAttackByPlayer(OutpostAreaUnits, player1, 9999)
		local Control2 = SGroup_IsUnderAttackByPlayer(OutpostAreaUnits, player2, 9999)
        if Control1 == true or Control2 == true then
		        local Control3 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_outpostarea, false)
				if Control3 == true then
                        Cmd_Move(OutpostMG, mkr_outpostmgto)
						Rule_RemoveMe()
				end
		end
end

function OutpostTarget()

		local Control1 = SGroup_IsUnderAttackByPlayer(OutpostAreaUnits, player1, 9999)
		local Control2 = SGroup_IsUnderAttackByPlayer(OutpostAreaUnits, player2, 9999)
        if Control1 == true or Control2 == true then
		        local Control3 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_outpostarea, false)
				if Control3 == true then
                        Target = Player_GetSquadConcentration(player1)
                        Cmd_Move(OutpostPioneer, Target)
				elseif Control3 == false then
				        Cmd_Move(OutpostPioneer, mkr_outpostpioneerto)
				end
		end
end

------------------------------Path Event----------------------------------

function PathEvent()

        Rule_AddDelayedInterval(PathStart, 1, 1)
		Rule_AddDelayedInterval(PathInitialBattle, 1, 1)
		Rule_AddDelayedInterval(PathSchneiderDead, 1, 1)
		Rule_AddDelayedInterval(PathMillSovietCombat, 1, 1)
		Rule_AddDelayedInterval(PathMillPullout, 1, 1)
		Rule_AddDelayedInterval(PathBridgePullout, 1, 1)
		Rule_AddDelayedInterval(PathFitzgeraldBridge, 1, 1)
		
		Rule_AddDelayedInterval(PathFitzgeraldAirstrikeTrigger, 1, 1)
		
		Rule_AddDelayedInterval(PathApelDespawn, 1, 1)
		Rule_AddDelayedInterval(PathMichaelDeath, 1, 1)
		
		Rule_AddDelayedInterval(PathMillHouseDestruction, 1, 1)
		Rule_AddDelayedInterval(PathBridgeDestruction, 0.3, 0.3)
		
		Rule_AddDelayedInterval(PathAssGrenMove, 1, 1)
		Rule_AddDelayedInterval(PathSturmMove, 1, 1)
		Rule_AddDelayedInterval(PathSchneiderOne, 1, 10)
		Rule_AddDelayedInterval(PathSchneiderTwo, 1, 10)
		Rule_AddDelayedInterval(PathSchneiderThree, 1, 10)
		Rule_AddDelayedInterval(PathSchneiderFour, 1, 10)

end

function ColdCheck()

        local Control1 = SGroup_Count(OutpostChoice)
		if Control1 == 0 then
		        Player_SetHeatLossRate(player1, 1)
	            Player_SetHeatLossRate(player2, 1)
		end
end

function PathStart()

        local Control1 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_pathcinematictrigger, false)
		if Control1 == true then
        		Util_StartIntel(EVENTS.PathCinematic)
				Rule_RemoveMe()
		end
end

function PathInitialBattle()

		local Control1 = SGroup_IsUnderAttackByPlayer(SchneiderAreaUnits, player1, 9999)
		local Control2 = SGroup_IsUnderAttackByPlayer(SchneiderAreaUnits, player2, 9999)
        if Control1 == true or Control2 == true then
		        local Control3 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_schneiderarea, false)
				if Control3 == true then
				        Cmd_Move(Fitzgerald, mkr_pathfitzgeraldto1)
                        Cmd_Move(ForwardRanger, mkr_pathrangerto1)
						Cmd_Move(ForwardPara, mkr_pathparato1)
						Cmd_Move(ForwardSapper, mkr_pathsapperto1)
						Cmd_Move(ForwardCommando, mkr_pathcommandoto1)
						Cmd_Move(ForwardEchelon, mkr_pathechelonto1)
						Cmd_Move(ForwardTommy, mkr_pathtommyto1)
						Rule_RemoveMe()
				end
		end
end

function PathSchneiderDead()

        local Control1 = SGroup_Count(SchneiderAreaUnits)
		local Control2 = SGroup_Count(PathTrenchLeftovers)
		if Control1 == 0 and Control2 == 0 then
		        Util_StartIntel(EVENTS.PathSchneiderOver)
				Rule_RemoveMe()
		end
end

function PathMillSovietCombat()

        local Control1 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_pathretreateventtrigger, false)
		if Control1 == true then
		        local Control2 = SGroup_Count(SchneiderAreaUnits)
		        if Control2 == 0 then
        				Util_StartIntel(VIN.PathMillCombat)
						Rule_RemoveMe()
				end
		end
end

function PathMillPullout()

        local Control1 = SGroup_Count(PathMichael)
		if Control1 == 0 then
		        local Control2 = SGroup_Count(SchneiderAreaUnits)
		        if Control2 == 0 then
        				Util_StartIntel(VIN.PathMillRetreat)
						Rule_RemoveMe()
			    end
		end
end

function PathBridgePullout()

        local Control1 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_pathbridgepullouttrigger, false)
		if Control1 == true then
		        local Control2 = SGroup_Count(Tomislav)
		        if Control2 == 0 then
        				Util_StartIntel(VIN.PathBridgeCombat)
						Rule_RemoveMe()
				end
		end
end

function PathFitzgeraldBridge()

        local Control1 = Prox_AreSquadsNearMarker(Fitzgerald, mkr_finalefitzgeraldretreatpoint, false)
		if Control1 == true then
		        local Control2 = SGroup_Count(Tomislav)
		        if Control2 == 0 then
        				Util_StartIntel(VIN.PathFitzgeraldDeath)
						Rule_RemoveMe()
				end
		end
end

function PathFitzgeraldAirstrikeTrigger()

        local Control1 = Prox_AreSquadsNearMarker(Fitzgerald, mkr_fitzgeraldairstriketrigger, false)
		if Control1 == true then
		        local Control2 = SGroup_Count(Tomislav)
		        if Control2 == 0 then
        		        local Direction = Marker_GetDirection(mkr_pathbridgebombdirection)
	                    Cmd_Ability(player6, ABILITY.SOVIET.IL_2_PRECISION_BOMB_STRIKE, mkr_finalefitzgeraldretreatpoint, Direction, true, false)
						Rule_RemoveMe()
				end
		end
end

function PathApelDespawn()

        local Control1 = Prox_AreSquadsNearMarker(PathApel, mkr_pathapeldespawn, false)
		if Control1 == true then
        		SGroup_DestroyAllSquads(PathApel)
				Rule_RemoveMe()
		end
end

function PathMichaelDeath()

        local Control1 = SGroup_GetAvgHealth(PathMichael)
		if Control1 < 0.9 then
		        local Control2 = SGroup_Count(SchneiderAreaUnits)
		        if Control2 == 0 then
        				SGroup_Kill(PathMichael)
						Rule_RemoveMe()
				end
		end
end

function PathMillHouseDestruction()

        local Control1 = EGroup_GetAvgHealth(MillHouse)
		if Control1 < 0.9 then
		        EGroup_Kill(MillHouse)
				Rule_RemoveMe()
		end
end

function PathBridgeDestruction()

        local Control1 = EGroup_GetAvgHealth(PathBridge)
		if Control1 < 0.95 then
		        EGroup_Kill(PathBridge)
				Rule_RemoveMe()
		end
end

function PathAssGrenMove()

		local Control1 = SGroup_IsUnderAttackByPlayer(SchneiderAreaUnits, player1, 9999)
		local Control2 = SGroup_IsUnderAttackByPlayer(SchneiderAreaUnits, player2, 9999)
        if Control1 == true or Control2 == true then
		        local Control3 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_schneiderarea, false)
				if Control3 == true then
                        Target = Player_GetSquadConcentration(player1)
                        Cmd_Move(PathAssGren, Target)
				elseif Control3 == false then
				        Cmd_Move(PathAssGren, mkr_pathassgrendefaultto)
				end
		end
end

function PathSturmMove()

		local Control1 = SGroup_IsUnderAttackByPlayer(Schneider, player1, 9999)
		local Control2 = SGroup_IsUnderAttackByPlayer(Schneider, player2, 9999)
        if Control1 == true or Control2 == true then
		        local Control3 = Prox_AreSquadsNearMarker(PlayerUnits, mkr_schneiderarea, false)
				if Control3 == true then
                        Cmd_Move(PathSturm, Schneider)
				elseif Control3 == false then
				        Cmd_Move(PathSturm, mkr_pathsturmdefaultto)
				end
		end
end

function PathSchneiderOne()

        local Control1 = Prox_AreSquadsNearMarker(Schneider, mkr_schneiderto1, false)
		if Control1 == true then
        		Cmd_Move(Schneider, mkr_schneiderto2)
				Cmd_Move(PathFalls, mkr_schneiderto2)
		end
end

function PathSchneiderTwo()

        local Control1 = Prox_AreSquadsNearMarker(Schneider, mkr_schneiderto2, false)
		if Control1 == true then
        		Cmd_Move(Schneider, mkr_schneiderto3)
				Cmd_Move(PathFalls, mkr_schneiderto3)
		end
end

function PathSchneiderThree()

        local Control1 = Prox_AreSquadsNearMarker(Schneider, mkr_schneiderto3, false)
		if Control1 == true then
        		Cmd_Move(Schneider, mkr_schneiderto4)
				Cmd_Move(PathFalls, mkr_schneiderto4)
		end
end

function PathSchneiderFour()

        local Control1 = Prox_AreSquadsNearMarker(Schneider, mkr_schneiderto4, false)
		if Control1 == true then
        		Cmd_Move(Schneider, mkr_schneiderto1)
				Cmd_Move(PathFalls, mkr_schneiderto1)
		end
end

------------------------------Finale Event----------------------------------

function FinaleEvent()

        Rule_AddDelayedInterval(FinaleStart, 1, 1)
		Rule_AddDelayedInterval(FinaleWeapons, 1, 1)
		
		Rule_AddDelayedInterval(FinaleFightCinematicStart, 1, 1)
		Rule_AddDelayedInterval(FinaleFightCinematicContinue, 1, 1)
		Rule_AddDelayedInterval(FinaleWilhelmMG, 1, 1)
		Rule_AddDelayedInterval(WilhelmReinforcementSummon, 1, 80)
		Rule_AddDelayedInterval(FinaleWilhelmDeath, 1, 1)
			
		Rule_AddDelayedInterval(FinaleAirstrike, 1, 30)
		
		Rule_AddDelayedInterval(FinaleHansWarpAssist, 1, 1)
		Rule_AddDelayedInterval(FinaleWilhelmWarpAssist, 1, 1)
		Rule_AddDelayedInterval(FinaleHintRemove, 1, 1)
		Rule_AddDelayedInterval(FinaleHansInstantWarp, 1, 1)
		Rule_AddDelayedInterval(FinaleWilhelmDespawn, 1, 1)
		Rule_AddDelayedInterval(FinaleHansMove, 1, 1)
		Rule_AddDelayedInterval(HansDeathControl, 1, 1)
		Rule_AddDelayedInterval(WilhelmReinforcementSturm, 1, 10)
		Rule_AddDelayedInterval(WilhelmReinforcementVolks, 1, 10)
		Rule_AddDelayedInterval(WilhelmReinforcementPioneer, 1, 10)
		Rule_AddDelayedInterval(WilhelmReinforcementStorm, 1, 10)
		Rule_AddDelayedInterval(WilhelmMove, 1, 30)

end

function TrainDepartCheck()

        local Control1 = SGroup_Count(OptionalChoice)
        if Control1 == 0 then
                Cmd_Move(TrainThree, mkr_trainthreeto)
                Rule_RemoveMe()
        end
end

function FinaleStart()

        local Control1 = EGroup_IsCapturedByPlayer(Point8, player1, false)
        local Control2 = EGroup_IsCapturedByPlayer(Point8, player2, false)
        if Control1 == true or Control2 == true then
		        Util_StartIntel(VIN.FinaleInitialApelDialogue)
				Rule_RemoveMe()
		end
end

function FinaleWeapons()

        local Control1 = Prox_AreSquadsNearMarker(Kurt, mkr_finalesupplydialoguetrigger, false)
		local Control2 = Prox_AreSquadsNearMarker(Otto, mkr_finalesupplydialoguetrigger, false)
		if Control1 == true or Control2 == true then
		        Util_StartIntel(VIN.FinaleSupplyDialogue)
				Rule_RemoveMe()
		end
end

function FinaleFightCinematicStart()

        local Control1 = EGroup_IsCapturedByPlayer(Point9, player1, false)
        local Control2 = EGroup_IsCapturedByPlayer(Point9, player2, false)
        if Control1 == true or Control2 == true then
                Util_StartIntel(VIN.FinaleFightSceneOne)
                Rule_RemoveMe()
        end
end

function FinaleFightCinematicContinue()

        local Control1 = SGroup_Count(Hans)
        if Control1 == 0 then
                Util_StartIntel(VIN.FinaleFightSceneTwo)
                Rule_RemoveMe()
        end
end

function FinaleWilhelmMG()

        local Control1 = SGroup_GetAvgHealth(Wilhelm)
        if Control1 < 0.5 then
                Util_StartIntel(VIN.WilhelmFifty)
                Rule_RemoveMe()
        end
end

function WilhelmReinforcementSummon()

        local Control1 = SGroup_Count(VillageChoice)
        if Control1 == 1 then
				local Control2 = SGroup_Count(FinaleAirstrikeControl)
        		if Control2 == 0 then
						local Control3 = SGroup_Count(Wilhelm)
                		if Control3 == 1 then
				        		local Random = World_GetRand(1, 4)
      		   					if Random == 1 then
		                		        Util_CreateSquads(player5, WilhelmSturm, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_finaleenemyspawn)
								elseif Random == 2 then
								        Util_CreateSquads(player5, WilhelmVolks, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_finaleenemyspawn)
								elseif Random == 3 then
								        Util_CreateSquads(player5, WilhelmPioneer, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_finaleenemyspawn)
								elseif Random == 4 then
								        Util_CreateSquads(player5, WilhelmStorm, SBP.GERMAN.STORMTROOPER_SQUAD_MP, mkr_finaleenemyspawn)
								end
						end
				end
		end
end

function FinaleWilhelmDeath()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        Player_SetHeatLossRate(player1, 0)
	            Player_SetHeatLossRate(player2, 0)
				World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
		        Cmd_Retreat(FortBodyguard, mkr_wilhelmdeathretreat)
				Cmd_Retreat(TrenchMidOber, mkr_wilhelmdeathretreat)
				Cmd_Retreat(TrenchLeftAssGren, mkr_wilhelmdeathretreat)
				Cmd_Retreat(TrenchMidSturm, mkr_wilhelmdeathretreat)
		        Cmd_Retreat(WilhelmSturm, mkr_wilhelmdeathretreat)
				Cmd_Retreat(WilhelmVolks, mkr_wilhelmdeathretreat)
				Cmd_Retreat(WilhelmPioneer, mkr_wilhelmdeathretreat)
				Cmd_Retreat(WilhelmStorm, mkr_wilhelmdeathretreat)
				Rule_RemoveMe()
		end
end

function FinaleAirstrike()

        local Control1 = Prox_AreSquadsNearMarker(Kurt, mkr_finaleairstrikearea, false)
		local Control2 = Prox_AreSquadsNearMarker(Otto, mkr_finaleairstrikearea, false)
		if Control1 == true or Control2 == true then
		        local Control3 = SGroup_Count(FinaleAirstrikeControl)
                if Control3 == 0 then
				        local Control4 = SGroup_Count(Wilhelm)
                        if Control4 == 1 then
		                        local Target = Util_GetRandomPosition(mkr_finalearea)
						        local Direction = Marker_GetDirection(mkr_finalesovietdirection)
				                Cmd_Ability(player6, ABILITY.SOVIET.IL_2_PRECISION_BOMB_STRIKE, Target, Direction, true)
						end
				end
		end
end

function FinaleHansWarpAssist()

        local Control1 = Prox_AreSquadsNearMarker(Hans, mkr_apelhanswarptrigger, false)
		if Control1 == true then
		        SGroup_WarpToMarker(Hans, mkr_finalehanssecondwarp)
				Rule_RemoveMe()
		end
end

function FinaleWilhelmWarpAssist()

        local Control1 = Prox_AreSquadsNearMarker(FinaleApel, mkr_apelhanswarptrigger, false)
		if Control1 == true then
		        SGroup_WarpToMarker(FinaleApel, mkr_wilhelmretreatto)
				Rule_RemoveMe()
		end
end


function FinaleHintRemove()

        local Control1 = Prox_AreSquadsNearMarker(Kurt, mkr_supplyhintremove, false)
		local Control2 = Prox_AreSquadsNearMarker(Otto, mkr_supplyhintremove, false)
		if Control1 == true or Control2 == true then
		        HintPoint_Remove(HintSupply)
				Rule_RemoveMe()
		end
end

function FinaleHansInstantWarp()

        local Control1 = Prox_AreSquadsNearMarker(Hans, mkr_finalehanssecondwarp, true)
		if Control1 == true then
		        SGroup_WarpToMarker(Hans, mkr_finalefighthanswarp)
				Rule_RemoveMe()
		end
end

function FinaleWilhelmDespawn()

        local Control1 = Prox_AreSquadsNearMarker(FinaleApel, mkr_wilhelmretreatto, false)
		if Control1 == true then
		        SGroup_DestroyAllSquads(FinaleApel)
				Rule_RemoveMe()
		end
end

function FinaleHansMove()

        local Control1 = Prox_AreSquadsNearMarker(Hans, mkr_finalehanssecondwarp, false)
		if Control1 == true then
		        Cmd_Move(Hans, mkr_finalefighthanswarp)
		end
end

function HansDeathControl()

        local Control1 = SGroup_Count(HansControl)
        if Control1 == 0 then
		        local Control2 = SGroup_IsUnderAttack(Hans, true, 9999)
				if Control2 == true then
		                SGroup_Kill(Hans)
				        Rule_RemoveMe()
				end
		end
end

function WilhelmReinforcementSturm()

	local Target = Player_GetSquadConcentration(player1)
    Cmd_Move(WilhelmSturm, Target)

end

function WilhelmReinforcementVolks()

	local Target = Player_GetSquadConcentration(player1)
    Cmd_AttackMove(WilhelmVolks, Target)

end

function WilhelmReinforcementPioneer()

	local Target = Player_GetSquadConcentration(player1)
    Cmd_Move(WilhelmPioneer, Target)

end

function WilhelmReinforcementStorm()

	local Target = Player_GetSquadConcentration(player1)
    Cmd_AttackMove(WilhelmStorm, Target)

end

function WilhelmMove()

		local Control1 = SGroup_Count(FinaleAirstrikeControl)
        if Control1 == 0 then
				local Control2 = SGroup_Count(Wilhelm)
                if Control2 == 1 then
				        local Random = World_GetRand(1, 16)
      		   			if Random == 1 then
		                		Cmd_Move(Wilhelm, mkr_wilhelmto1)
								Cmd_Move(FortBodyguard, mkr_wilhelmto1)
						elseif Random == 2 then
								Cmd_Move(Wilhelm, mkr_wilhelmto2)
								Cmd_Move(FortBodyguard, mkr_wilhelmto2)
						elseif Random == 3 then
								Cmd_Move(Wilhelm, mkr_wilhelmto3)
								Cmd_Move(FortBodyguard, mkr_wilhelmto3)
						elseif Random == 4 then
								Cmd_Move(Wilhelm, mkr_wilhelmto4)
								Cmd_Move(FortBodyguard, mkr_wilhelmto4)
						elseif Random == 5 then
								Cmd_Move(Wilhelm, mkr_wilhelmto5)
								Cmd_Move(FortBodyguard, mkr_wilhelmto5)
						elseif Random == 6 then
								Cmd_Move(Wilhelm, mkr_wilhelmto6)
								Cmd_Move(FortBodyguard, mkr_wilhelmto6)
						elseif Random == 7 then
								Cmd_Move(Wilhelm, mkr_wilhelmto7)
								Cmd_Move(FortBodyguard, mkr_wilhelmto7)
						elseif Random == 8 then
								Cmd_Move(Wilhelm, mkr_wilhelmto8)
								Cmd_Move(FortBodyguard, mkr_wilhelmto8)
						elseif Random == 9 then
								Cmd_Retreat(Wilhelm, mkr_wilhelmto1)
								Cmd_Retreat(FortBodyguard, mkr_wilhelmto1)
						elseif Random == 10 then
								Cmd_Retreat(Wilhelm, mkr_wilhelmto2)
								Cmd_Retreat(FortBodyguard, mkr_wilhelmto2)
						elseif Random == 11 then
								Cmd_Retreat(Wilhelm, mkr_wilhelmto3)
								Cmd_Retreat(FortBodyguard, mkr_wilhelmto3)
						elseif Random == 12 then
								Cmd_Retreat(Wilhelm, mkr_wilhelmto4)
								Cmd_Retreat(FortBodyguard, mkr_wilhelmto4)
						elseif Random == 13 then
								Cmd_Retreat(Wilhelm, mkr_wilhelmto5)
								Cmd_Retreat(FortBodyguard, mkr_wilhelmto5)
						elseif Random == 14 then
								Cmd_Retreat(Wilhelm, mkr_wilhelmto6)
								Cmd_Retreat(FortBodyguard, mkr_wilhelmto6)
						elseif Random == 15 then
								Cmd_Retreat(Wilhelm, mkr_wilhelmto7)
								Cmd_Retreat(FortBodyguard, mkr_wilhelmto7)
						elseif Random == 16 then
								Cmd_Retreat(Wilhelm, mkr_wilhelmto8)
								Cmd_Retreat(FortBodyguard, mkr_wilhelmto8)
						end
				end
		end
end

------------------------------Officers---------------------------------

function Officers()

        Rule_AddDelayedInterval(OfficerKoch, 1, 90)
		Rule_AddDelayedInterval(OfficerLohse, 1, 73)
		Rule_AddDelayedInterval(OfficerDassler, 1, 105)
		Rule_AddDelayedInterval(OfficerSchneiderFire, 1, 70)
		Rule_AddDelayedInterval(OfficerSchneiderSmoke, 35, 70)
		Rule_AddDelayedInterval(OfficerWilhelm, 1, 70)		
		
		Rule_AddDelayedInterval(OfficerAssGrenMove, 1, 10)
		Rule_AddDelayedInterval(OfficerGrenMove, 1, 10)		

end

function OfficerKoch()

        local Control1 = SGroup_Count(VillageFightControl)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(Koch)
                if Control2 == 1 then
        				local Random = World_GetRand(1, 2)
      		   			if Random == 1 then
     		  				    Util_StartIntel(EVENTS.KochDialogueOne)
     		   		    elseif Random == 2 then
     		 				    Util_StartIntel(EVENTS.KochDialogueTwo)
					    end
                end
        end
end

function OfficerLohse()

        local Control1 = SGroup_Count(VillageFightControl)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(Lohse)
                if Control2 == 1 then
        				local Random = World_GetRand(1, 2)
      		   			if Random == 1 then
     		  		    		Util_StartIntel(EVENTS.LohseDialogueOne)
     		    		elseif Random == 2 then
     		 		    		Util_StartIntel(EVENTS.LohseDialogueTwo)
						end
                end
        end
end

function OfficerDassler()

        local Control1 = SGroup_Count(VillageFightControl)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(Dassler)
                if Control2 == 1 then
		                local Count = SGroup_Count(VillageReinforcements)
				        if Count < 2 then
        				        local Random = World_GetRand(1, 2)
      		   			        if Random == 1 then
     		  				            Util_StartIntel(EVENTS.DasslerDialogueOne)
     		    		        elseif Random == 2 then
     		 				            Util_StartIntel(EVENTS.DasslerDialogueTwo)
								end
						end
                end
        end
end

function OfficerSchneiderFire()

        local Control1 = SGroup_IsUnderAttackByPlayer(Schneider, player1, 9000)
        local Control2 = SGroup_IsUnderAttackByPlayer(Schneider, player2, 9000)
        if Control1 == true or Control2 == true then
		        local Target = Player_GetSquadConcentration(player1)
                local Direction = Marker_GetDirection(mkr_pathdirection)
                Cmd_Ability(player5, ABILITY.GERMAN.STUKA_INCENDIARY_BOMBS, Target, Direction, true, false)
		        Util_StartIntel(EVENTS.SchneiderFireSupport)
				
        end
end

function OfficerSchneiderSmoke()

        local Control1 = SGroup_IsUnderAttackByPlayer(Schneider, player1, 9000)
        local Control2 = SGroup_IsUnderAttackByPlayer(Schneider, player2, 9000)
        if Control1 == true or Control2 == true then
		        local Target = Player_GetSquadConcentration(player1)
                local Direction = Marker_GetDirection(mkr_pathdirection)
	            Cmd_Ability(player5, ABILITY.GERMAN.STUKA_SMOKE_BOMB, Target, Direction, true, false)
				Cmd_Ability(player5, ABILITY.WEST_GERMAN.VALIANT_ASSAULT, SchneiderAreaUnits, Direction, true, false)
		        Util_StartIntel(EVENTS.SchneiderSmokeSupport)
				
        end
end

function OfficerWilhelm()

        local Control1 = SGroup_Count(FinaleAirstrikeControl)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(Wilhelm)
                if Control2 == 1 then
        				local Random = World_GetRand(1, 3)
      		   			if Random == 1 then
     		  				    Util_StartIntel(VIN.WilhelmDialogueOne)
     		    		elseif Random == 2 then
     		 				    Util_StartIntel(VIN.WilhelmDialogueTwo)
						elseif Random == 3 then
     		 				    Util_StartIntel(VIN.WilhelmDialogueThree)
						end
                end
        end
end

function OfficerAssGrenMove()

        Target = Player_GetSquadConcentration(player1)
        Cmd_Move(VillageAssGren, Target)
		
end

function OfficerGrenMove()

        Target = Player_GetSquadConcentration(player1)
        Cmd_AttackMove(VillageStorm, Target)
		
end


------------------------------Elites-------------------------------

function Elites()

        Modify_ReceivedDamage(Kurt, 0.4)
        Modify_ReceivedAccuracy(Kurt, 0.7)
        Modify_ReceivedDamage(Otto, 0.2)
        Modify_ReceivedAccuracy(Otto, 0.7)
        Modify_ReceivedDamage(Hans, 0.2)
        Modify_ReceivedAccuracy(Hans, 0.9)
		Modify_ReceivedDamage(Tomislav, 0.5)
        Modify_ReceivedAccuracy(Tomislav, 0.4)
		
		Modify_ReceivedDamage(Michael, 0.03)
		Modify_ReceivedAccuracy(Michael, 0.8)

        Modify_ReceivedDamage(Koch, 0.5)
        Modify_ReceivedAccuracy(Koch, 0.7)
		Modify_ReceivedDamage(Lohse, 0.5)
        Modify_ReceivedAccuracy(Lohse, 0.7)
	    Modify_ReceivedDamage(Dassler, 0.5)
        Modify_ReceivedAccuracy(Dassler, 0.7)
		Modify_ReceivedDamage(KGuards, 0.7)
        Modify_ReceivedAccuracy(KGuards, 0.7)
		Modify_ReceivedDamage(LGuards, 0.7)
        Modify_ReceivedAccuracy(LGuards, 0.7)
		Modify_ReceivedDamage(DGuards, 0.7)
        Modify_ReceivedAccuracy(DGuards, 0.7)
		Modify_ReceivedDamage(CacheOber, 0.6)
        Modify_ReceivedAccuracy(CacheOber, 0.6)
		Modify_ReceivedDamage(CacheSturm, 0.7)
        Modify_ReceivedAccuracy(CacheSturm, 0.7)
		Modify_ReceivedAccuracy(CampPanther, 10)
		Modify_ReceivedDamage(FortBodyguard, 0.6)
        Modify_ReceivedAccuracy(FortBodyguard, 0.6)
		Modify_ReceivedDamage(WoodSturm, 0.7)
        Modify_ReceivedAccuracy(WoodSturm, 0.7)
		Modify_ReceivedDamage(WoodStageTwoMG, 0.8)
        Modify_ReceivedAccuracy(WoodStageTwoMG, 0.8)
		Modify_ReceivedDamage(WoodStageThreeMG, 0.6)
        Modify_ReceivedAccuracy(WoodStageThreeMG, 0.8)
		Modify_ReceivedDamage(WoodStageThreeVolks, 0.7)
        Modify_ReceivedAccuracy(WoodStageThreeVolks, 0.7)
		Modify_ReceivedDamage(WoodStageFourStorm, 0.6)
        Modify_ReceivedAccuracy(WoodStageFourStorm, 0.7)
		Modify_ReceivedDamage(WoodStageFourPanzerGren, 0.7)
        Modify_ReceivedAccuracy(WoodStageFourPanzerGren, 0.7)
		Modify_ReceivedDamage(TrenchMidOber, 0.7)
        Modify_ReceivedAccuracy(TrenchMidOber, 0.8)
		Modify_ReceivedDamage(TrenchMidSturm, 0.8)
        Modify_ReceivedAccuracy(TrenchMidSturm, 0.9)
		Modify_ReceivedDamage(TrenchLeftGren, 0.7)
        Modify_ReceivedAccuracy(TrenchLeftGren, 0.8)
		Modify_ReceivedDamage(TrenchLeftAssGren, 0.8)
        Modify_ReceivedAccuracy(TrenchLeftAssGren, 0.9)
		Modify_ReceivedDamage(TrenchRightVolks, 0.9)
        Modify_ReceivedAccuracy(TrenchRightVolks, 0.7)
		Modify_ReceivedDamage(TrenchRightStorm, 0.7)
        Modify_ReceivedAccuracy(TrenchRightStorm, 0.7)
		
		Modify_ReceivedDamage(TrenchVictimGren, 0.7)
        Modify_ReceivedAccuracy(TrenchVictimGren, 0.7)
		Modify_ReceivedDamage(TrenchVictimAssGren, 0.7)
        Modify_ReceivedAccuracy(TrenchVictimAssGren, 0.7)
		Modify_ReceivedDamage(TrenchVictimVolks, 0.7)
        Modify_ReceivedAccuracy(TrenchVictimVolks, 0.7)
		
		Modify_ReceivedDamage(OutpostVolks, 0.7)
        Modify_ReceivedAccuracy(OutpostVolks, 0.7)
		Modify_ReceivedDamage(OutpostPioneer, 0.6)
        Modify_ReceivedAccuracy(OutpostPioneer, 0.7)
		Modify_ReceivedDamage(OutpostMG, 0.7)
        Modify_ReceivedAccuracy(OutpostMG, 0.7)
		
		Modify_ReceivedDamage(Schneider, 0.5)
        Modify_ReceivedAccuracy(Schneider, 0.5)
		Modify_ReceivedDamage(PathFalls, 0.7)
        Modify_ReceivedAccuracy(PathFalls, 0.8)
		Modify_ReceivedDamage(PathVolks, 0.7)
        Modify_ReceivedAccuracy(PathVolks, 0.7)
		Modify_ReceivedDamage(PathSturm, 0.7)
        Modify_ReceivedAccuracy(PathSturm, 0.7)
		Modify_ReceivedDamage(PathOber, 0.7)
        Modify_ReceivedAccuracy(PathOber, 0.7)
		Modify_ReceivedDamage(PathAssGren, 0.8)
        Modify_ReceivedAccuracy(PathAssGren, 0.8)
		Modify_ReceivedDamage(PathGren, 0.7)
        Modify_ReceivedAccuracy(PathGren, 0.7)
		Modify_ReceivedDamage(PathApel, 0.2)
        Modify_ReceivedAccuracy(PathApel, 0.2)
		Modify_ReceivedDamage(Wilhelm, 0.25)
        Modify_ReceivedAccuracy(Wilhelm, 0.8)
		
end



-------------------------------Elite Names--------------------------------

function EliteNames()

        local EliteNameExtra1 = Util_CreateLocString("Kurt Bachmann")
        local EliteNameExtra2 = Util_CreateLocString("Otto Baasch")
        local EliteNameExtra3 = Util_CreateLocString("Hans Dunkel")
		local EliteNameExtra4 = Util_CreateLocString("Tomislav Novak")
        HintMouseover_Add(EliteNameExtra1, Kurt, 5, true)
        HintMouseover_Add(EliteNameExtra2, Otto, 5, true)
        HintMouseover_Add(EliteNameExtra3, Hans, 5, true)
		HintMouseover_Add(EliteNameExtra4, Tomislav, 5, true)
		
		local EliteNameExtra5 = Util_CreateLocString("Aleksei Zaytsev")
        local EliteNameExtra6 = Util_CreateLocString("Dmitriy Titov")
        local EliteNameExtra7 = Util_CreateLocString("Nikolai Pukhov")
        local EliteNameExtra8 = Util_CreateLocString("Stator Vasnetsov")
        local EliteNameExtra9 = Util_CreateLocString("Vladilen Vasnetsov")
        local EliteNameExtra10 = Util_CreateLocString("Yuri Konev")
        local EliteNameExtra11 = Util_CreateLocString("Viktor Vasilevsky")
		local EliteNameExtra12 = Util_CreateLocString("Lieutenant Fitzgerald")
        HintMouseover_Add(EliteNameExtra5, Aleksei, 5, true)
        HintMouseover_Add(EliteNameExtra6, Dmitriy, 5, true)
        HintMouseover_Add(EliteNameExtra7, Nikolai, 5, true)
        HintMouseover_Add(EliteNameExtra8, Stator, 5, true)
        HintMouseover_Add(EliteNameExtra9, Vladilen, 5, true)
        HintMouseover_Add(EliteNameExtra10, Yuri, 5, true)
        HintMouseover_Add(EliteNameExtra11, Viktor, 5, true)
		HintMouseover_Add(EliteNameExtra12, Fitzgerald, 5, true)
        SGroup_IncreaseVeterancyRank(Aleksei, 3, false)
        SGroup_IncreaseVeterancyRank(Dmitriy, 3, false)
        SGroup_IncreaseVeterancyRank(Nikolai, 3, false)
        SGroup_IncreaseVeterancyRank(Stator, 3, false)
        SGroup_IncreaseVeterancyRank(Vladilen, 3, false)
        SGroup_IncreaseVeterancyRank(Yuri, 3, false)
        SGroup_IncreaseVeterancyRank(Viktor, 3, false)
		SGroup_IncreaseVeterancyRank(Fitzgerald, 3, false)

        local EliteName1 = Util_CreateLocString("Sturmbannfuhrer Koch")
        HintMouseover_Add(EliteName1, Koch, 5, true)
        SGroup_IncreaseVeterancyRank(Koch, 5, false)
		local EliteName2 = Util_CreateLocString("Sturmbannfuhrer Lohse")
        HintMouseover_Add(EliteName2, Lohse, 5, true)
        SGroup_IncreaseVeterancyRank(Lohse, 5, false)
		local EliteName3 = Util_CreateLocString("Sturmbannfuhrer Dassler")
        HintMouseover_Add(EliteName3, Dassler, 5, true)
        SGroup_IncreaseVeterancyRank(Dassler, 5, false)
		local EliteName4 = Util_CreateLocString("Koch's Bodyguards")
        HintMouseover_Add(EliteName4, KGuards, 5, true)
        SGroup_IncreaseVeterancyRank(KGuards, 3, false)
		local EliteName5 = Util_CreateLocString("Lohse's Bodyguards")
        HintMouseover_Add(EliteName5, LGuards, 5, true)
        SGroup_IncreaseVeterancyRank(LGuards, 3, false)
		local EliteName6 = Util_CreateLocString("Dassler's Bodyguards")
        HintMouseover_Add(EliteName6, DGuards, 5, true)
        SGroup_IncreaseVeterancyRank(DGuards, 3, false)
		local EliteName7 = Util_CreateLocString("27th Special Operations")
        HintMouseover_Add(EliteName7, CacheOber, 5, true)
        SGroup_IncreaseVeterancyRank(CacheOber, 5, false)
		local EliteName8 = Util_CreateLocString("15th Special Operations")
        HintMouseover_Add(EliteName8, CacheSturm, 5, true)
        SGroup_IncreaseVeterancyRank(CacheSturm, 5, false)
		local EliteName9 = Util_CreateLocString("Michael Wittman")
        HintMouseover_Add(EliteName9, Michael, 5, true)
        SGroup_IncreaseVeterancyRank(Michael, 5, false)
		local EliteName10 = Util_CreateLocString("Wilhelm Apel")
        HintMouseover_Add(EliteName10, CampOfficer, 5, true)
        SGroup_IncreaseVeterancyRank(CampOfficer, 5, false)
		local EliteName11 = Util_CreateLocString("1st Special Operations - Apel's Bodyguards")
        HintMouseover_Add(EliteName11, CampBodyguards, 5, true)
        SGroup_IncreaseVeterancyRank(CampBodyguards, 5, false)
		local EliteName12 = Util_CreateLocString("1st Special Operations - Apel's Bodyguards")
        HintMouseover_Add(EliteName12, FortBodyguard, 5, true)
        SGroup_IncreaseVeterancyRank(FortBodyguard, 5, false)
		local EliteName13 = Util_CreateLocString("Expert Combat Sturmpioneers")
        HintMouseover_Add(EliteName13, WoodSturm, 5, true)
        SGroup_IncreaseVeterancyRank(WoodSturm, 2, false)
		local EliteName14 = Util_CreateLocString("Heavy Fire Support Specialists")
        HintMouseover_Add(EliteName14, WoodStageTwoMG, 5, true)
        SGroup_IncreaseVeterancyRank(WoodStageTwoMG, 1, false)
		local EliteName15 = Util_CreateLocString("Eastern Front Support Veterans")
        HintMouseover_Add(EliteName15, WoodStageThreeMG, 5, true)
        SGroup_IncreaseVeterancyRank(WoodStageThreeMG, 2, false)
		local EliteName16 = Util_CreateLocString("Defense Skirmish Specialists")
        HintMouseover_Add(EliteName16, WoodStageThreeVolks, 5, true)
        SGroup_IncreaseVeterancyRank(WoodStageThreeVolks, 1, false)
		local EliteName17 = Util_CreateLocString("Eastern Front Elite Stormtroopers")
        HintMouseover_Add(EliteName17, WoodStageFourStorm, 5, true)
        SGroup_IncreaseVeterancyRank(WoodStageFourStorm, 2, false)
		local EliteName18 = Util_CreateLocString("Rural Defense Experts")
        HintMouseover_Add(EliteName18, WoodStageFourPanzerGren, 5, true)
        SGroup_IncreaseVeterancyRank(WoodStageFourPanzerGren, 2, false)
		local EliteName19 = Util_CreateLocString("14th Special Operations")
        HintMouseover_Add(EliteName19, TrenchMidOber, 5, true)
        SGroup_IncreaseVeterancyRank(TrenchMidOber, 5, false)
		local EliteName20 = Util_CreateLocString("40th Special Operations")
        HintMouseover_Add(EliteName20, TrenchMidSturm, 5, true)
        SGroup_IncreaseVeterancyRank(TrenchMidSturm, 5, false)
		local EliteName21 = Util_CreateLocString("27th Special Operations")
        HintMouseover_Add(EliteName21, TrenchRightVolks, 5, true)
        SGroup_IncreaseVeterancyRank(TrenchRightVolks, 5, false)
		local EliteName22 = Util_CreateLocString("50th Special Operations")
        HintMouseover_Add(EliteName22, TrenchLeftGren, 5, true)
        SGroup_IncreaseVeterancyRank(TrenchLeftGren, 3, false)
		local EliteName23 = Util_CreateLocString("33rd Special Operations")
        HintMouseover_Add(EliteName23, TrenchLeftAssGren, 5, true)
        SGroup_IncreaseVeterancyRank(TrenchLeftAssGren, 3, false)
		local EliteName24 = Util_CreateLocString("39th Special Operations")
        HintMouseover_Add(EliteName24, TrenchRightStorm, 5, true)
        SGroup_IncreaseVeterancyRank(TrenchRightStorm, 3, false)
		local EliteName25 = Util_CreateLocString("22nd Special Operations")
        HintMouseover_Add(EliteName25, OutpostVolks, 5, true)
        SGroup_IncreaseVeterancyRank(OutpostVolks, 5, false)
		local EliteName26 = Util_CreateLocString("10th Special Operations")
        HintMouseover_Add(EliteName26, OutpostPioneer, 5, true)
        SGroup_IncreaseVeterancyRank(OutpostPioneer, 3, false)
		local EliteName27 = Util_CreateLocString("34th Special Operations")
        HintMouseover_Add(EliteName27, OutpostMG, 5, true)
        SGroup_IncreaseVeterancyRank(OutpostMG, 3, false)
		local EliteName28 = Util_CreateLocString("Sturmbannfuhrer Wolfgang Schneider")
        HintMouseover_Add(EliteName28, Schneider, 5, true)
        SGroup_IncreaseVeterancyRank(Schneider, 5, false)
		local EliteName29 = Util_CreateLocString("7th Special Operations")
        HintMouseover_Add(EliteName29, PathFalls, 5, true)
        SGroup_IncreaseVeterancyRank(PathFalls, 3, false)
		local EliteName30 = Util_CreateLocString("42nd Special Operations")
        HintMouseover_Add(EliteName30, PathVolks, 5, true)
        SGroup_IncreaseVeterancyRank(PathVolks, 5, false)
		local EliteName31 = Util_CreateLocString("30th Special Operations")
        HintMouseover_Add(EliteName31, PathSturm, 5, true)
        SGroup_IncreaseVeterancyRank(PathSturm, 5, false)
		local EliteName32 = Util_CreateLocString("48th Special Operations")
        HintMouseover_Add(EliteName32, PathOber, 5, true)
        SGroup_IncreaseVeterancyRank(PathOber, 5, false)
		local EliteName33 = Util_CreateLocString("49th Special Operations")
        HintMouseover_Add(EliteName33, PathAssGren, 5, true)
        SGroup_IncreaseVeterancyRank(PathAssGren, 3, false)
		local EliteName34 = Util_CreateLocString("15th Special Operations")
        HintMouseover_Add(EliteName34, PathGren, 5, true)
        SGroup_IncreaseVeterancyRank(PathGren, 3, false)
		local EliteName35 = Util_CreateLocString("Wilhelm Apel")
        HintMouseover_Add(EliteName35, PathApel, 5, true)
        SGroup_IncreaseVeterancyRank(PathApel, 5, false)
		local EliteName36 = Util_CreateLocString("3rd Special Operations")
        HintMouseover_Add(EliteName36, PathTiger, 5, true)
        SGroup_IncreaseVeterancyRank(PathTiger, 5, false)
		local EliteName37 = Util_CreateLocString("Wilhelm Apel")
        HintMouseover_Add(EliteName37, Wilhelm, 5, true)
        SGroup_IncreaseVeterancyRank(Wilhelm, 5, false)
		local EliteName38 = Util_CreateLocString("Michael Wittman")
        HintMouseover_Add(EliteName38, PathMichael, 5, true)
        SGroup_IncreaseVeterancyRank(PathMichael, 5, false)
		
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
		
		
	    local ControlEntity1 = SGroup_GetSpawnedSquadAt(FortStartFusilier, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.PANZERSHRECK_MP)
		Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.PANZERSHRECK_MP)
		local ControlEntity2 = SGroup_GetSpawnedSquadAt(WoodSturm, 1)
        Squad_GiveSlotItem(ControlEntity2, SLOT_ITEM.PIONEER_FLAMETHROWER_MP)
		Squad_GiveSlotItem(ControlEntity2, SLOT_ITEM.PIONEER_FLAMETHROWER_MP)
		local ControlEntity3 = SGroup_GetSpawnedSquadAt(FortStageTwoFusilierOne, 1)
        Squad_GiveSlotItem(ControlEntity3, SLOT_ITEM.PANZERSHRECK_MP)
		Squad_GiveSlotItem(ControlEntity3, SLOT_ITEM.PANZERSHRECK_MP)
		local ControlEntity4 = SGroup_GetSpawnedSquadAt(FortStageTwoVolksTwo, 1)
        Squad_GiveSlotItem(ControlEntity4, SLOT_ITEM.PANZERSHRECK_MP)
		Squad_GiveSlotItem(ControlEntity4, SLOT_ITEM.PANZERSHRECK_MP)
		local ControlEntity5 = SGroup_GetSpawnedSquadAt(FortStageTwoGrenTwo, 1)
        Squad_GiveSlotItem(ControlEntity5, SLOT_ITEM.PIONEER_FLAMETHROWER_MP)
		Squad_GiveSlotItem(ControlEntity5, SLOT_ITEM.PIONEER_FLAMETHROWER_MP)
		local ControlEntity6 = SGroup_GetSpawnedSquadAt(FortStageThreeVolks, 1)
        Squad_GiveSlotItem(ControlEntity6, SLOT_ITEM.PANZERSHRECK_MP)
		Squad_GiveSlotItem(ControlEntity6, SLOT_ITEM.PANZERSHRECK_MP)
		local ControlEntity7 = SGroup_GetSpawnedSquadAt(WoodStageThreeVolks, 1)
        Squad_GiveSlotItem(ControlEntity7, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_NO_PRONE_MP)
		Squad_GiveSlotItem(ControlEntity7, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_NO_PRONE_MP)
		local ControlEntity8 = SGroup_GetSpawnedSquadAt(WoodStageFourStorm, 1)
        Squad_GiveSlotItem(ControlEntity8, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_NO_PRONE_MP)
		local ControlEntity9 = SGroup_GetSpawnedSquadAt(WoodStageFourPanzerGren, 1)
        Squad_GiveSlotItem(ControlEntity9, SLOT_ITEM.PIONEER_FLAMETHROWER_MP)
		local ControlEntity10 = SGroup_GetSpawnedSquadAt(TrenchMidOber, 1)
        Squad_GiveSlotItem(ControlEntity10, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_NO_PRONE_MP)
		local ControlEntity11 = SGroup_GetSpawnedSquadAt(TrenchRightStorm, 1)
        Squad_GiveSlotItem(ControlEntity11, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_NO_PRONE_MP)
		local ControlEntity12 = SGroup_GetSpawnedSquadAt(TrenchRightVolks, 1)
        Squad_GiveSlotItem(ControlEntity12, SLOT_ITEM.PIONEER_FLAMETHROWER_MP)
		local ControlEntity13 = SGroup_GetSpawnedSquadAt(OutpostVolks, 1)
        Squad_GiveSlotItem(ControlEntity13, SLOT_ITEM.PIONEER_FLAMETHROWER_MP)
		Squad_GiveSlotItem(ControlEntity13, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_NO_PRONE_MP)
		local ControlEntity14 = SGroup_GetSpawnedSquadAt(PathVolks, 1)
        Squad_GiveSlotItem(ControlEntity14, SLOT_ITEM.PIONEER_FLAMETHROWER_MP)
		local ControlEntity15 = SGroup_GetSpawnedSquadAt(PathGren, 1)
        Squad_GiveSlotItem(ControlEntity15, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_NO_PRONE_MP)
		
		
		
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("p47_rocket_attack"))
        Player_AddAbility(player3, BP_GetAbilityBlueprint("p47_rocket_attack"))
		Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("p47_rocket_attack"))
        Player_AddAbility(player4, BP_GetAbilityBlueprint("p47_rocket_attack"))
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("air_drop_resources"))
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("air_drop_weapon_resupply"))
        Player_AddAbility(player3, BP_GetAbilityBlueprint("air_dropped_munitions"))
		Player_AddAbility(player3, BP_GetAbilityBlueprint("air_dropped_supplies"))
		Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("air_drop_resources"))
		Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("air_drop_weapon_resupply"))
        Player_AddAbility(player4, BP_GetAbilityBlueprint("air_dropped_munitions"))
		Player_AddAbility(player4, BP_GetAbilityBlueprint("air_dropped_supplies"))
		
		Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("stuka_smoke_bomb"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("stuka_smoke_bomb"))

        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("battle_phase_4_mp"))
        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("building_1"))
        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("building_2"))
        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("building_3"))
        Player_SetAbilityAvailability(player1, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player1, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)
		
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("sws_interval_unlock"))
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("construct_base_building_upgrade"))
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("ability_lock_out_sws_truck"))
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("first_sws_halftrack_lockout"))
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("call_sws_upgrade"))
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("construct_base_building_upgrade"))
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("sws_starting_dispatch_unlock"))
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("volk_fire_grenade"))

        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
		Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("battle_phase_4_mp"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("building_1"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("building_2"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("building_3"))
        Player_SetAbilityAvailability(player2, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player2, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)
		
		Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("sws_interval_unlock"))
		Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("construct_base_building_upgrade"))
		Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("ability_lock_out_sws_truck"))
		Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("first_sws_halftrack_lockout"))
		Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("call_sws_upgrade"))
		Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("construct_base_building_upgrade"))
		Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("sws_starting_dispatch_unlock"))
		Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("volk_fire_grenade"))

        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("battle_phase_4_mp"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("building_1"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("building_2"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("building_3"))
        Player_SetAbilityAvailability(player3, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player3, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)
		
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("sws_interval_unlock"))
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("construct_base_building_upgrade"))
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("ability_lock_out_sws_truck"))
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("first_sws_halftrack_lockout"))
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("call_sws_upgrade"))
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("construct_base_building_upgrade"))
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("sws_starting_dispatch_unlock"))
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("volk_fire_grenade"))

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
        Player_SetUpgradeAvailability(player1, UPG.AEF.FIGHTING_POSITION_MG_ADDITION_MP, ITEM_REMOVED)
		Player_SetUpgradeAvailability(player1, UPG.GERMAN.GRENADIER_VETERAN_SQUAD_LEADER_MP, ITEM_REMOVED)
		Player_SetUpgradeAvailability(player1, UPG.GERMAN.ASSAULT_GRENADIER_VETERAN_SQUAD_LEADER_MP, ITEM_REMOVED)
		Player_SetUpgradeAvailability(player1, UPG.GERMAN.PIONEER_VETERAN_SQUAD_LEADER_MP, ITEM_REMOVED)
		
		Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.VOLKS_STG44_UPGRADE, ITEM_UNLOCKED)
		Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.VOLK_FIRE_GRENADE, ITEM_UNLOCKED)
		Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.VOLKS_FLAMETHROWER_MP, ITEM_UNLOCKED)
		Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.VOLKS_CQC_UPGRADE, ITEM_UNLOCKED)

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
		Player_SetUpgradeAvailability(player2, UPG.GERMAN.GRENADIER_VETERAN_SQUAD_LEADER_MP, ITEM_REMOVED)
		Player_SetUpgradeAvailability(player2, UPG.GERMAN.ASSAULT_GRENADIER_VETERAN_SQUAD_LEADER_MP, ITEM_REMOVED)
		Player_SetUpgradeAvailability(player2, UPG.GERMAN.PIONEER_VETERAN_SQUAD_LEADER_MP, ITEM_REMOVED)
		
		Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.VOLKS_STG44_UPGRADE, ITEM_UNLOCKED)
		Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.VOLK_FIRE_GRENADE, ITEM_UNLOCKED)
		Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.VOLKS_FLAMETHROWER_MP, ITEM_UNLOCKED)
		Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.VOLKS_CQC_UPGRADE, ITEM_UNLOCKED)
		

end

function Abilities()

        Player_AddAbility(player5, BP_GetAbilityBlueprint("flare_artillery"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("flare_artillery"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("stuka_incendiary_bombs"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("stuka_flame_strike"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("flare_artillery"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("flare_artillery"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("il-2_precision_bomb_strike"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("il-2_bomb_Strike"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("major_artillery"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("light_support_artillery"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("light_artillery_support"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("fire_artillery"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("fire_artillery"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("time_on_target_artillery"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("time_on_target_artillery"))
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
		Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("valiant_assault"))
		Player_AddAbility(player5, BP_GetAbilityBlueprint("valiant_assault"))
		
		Player_AddAbility(player6, BP_GetAbilityBlueprint("flare_artillery"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("flare_artillery"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("stuka_incendiary_bombs"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("stuka_flame_strike"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("flare_artillery"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("flare_artillery"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("il-2_precision_bomb_strike"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("il-2_bomb_Strike"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("major_artillery"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("light_support_artillery"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("light_artillery_support"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("fire_artillery"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("fire_artillery"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("time_on_target_artillery"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("time_on_target_artillery"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("flare_artillery"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("flare_artillery"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("time_on_target_artillery"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("time_on_target_artillery"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("recon_sweep"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("recon_sweep"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("p47_rocket_attack"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("p47_rocket_attack"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("major_quick_recon_run"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("major_quick_recon_run_improved"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("recon_sweep"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("paratroopers_paradrop"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("paratroopers"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("glider_headquarters"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("ability_lock_out_glider_custom_loadout_launch_available"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("ability_lock_out_glider_hard_landed"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("ability_lock_out_glider_not_stopped"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("major_artillery"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("pack_howitzer_white_phosphorous_barrage_ability_mp"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("artillery_smoke_barrage"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("off_map_smoke_artillery"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("artillery_strike_white_phosphorous"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("artillery_white_phosphorous"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("artillery_strike_white_phosphorous"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("stuka_bombing_run_upgrade"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("stuka_bombing_strike"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("stuka_incendiary_bombs"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("stuka_flame_strike"))
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
		Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("valiant_assault"))
		Player_AddAbility(player6, BP_GetAbilityBlueprint("valiant_assault"))
		
		Player_AddAbility(player7, BP_GetAbilityBlueprint("flare_artillery"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("flare_artillery"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("stuka_incendiary_bombs"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("stuka_flame_strike"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("flare_artillery"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("flare_artillery"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("il-2_precision_bomb_strike"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("il-2_bomb_Strike"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("major_artillery"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("light_support_artillery"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("light_artillery_support"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("fire_artillery"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("fire_artillery"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("time_on_target_artillery"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("time_on_target_artillery"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("flare_artillery"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("flare_artillery"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("time_on_target_artillery"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("time_on_target_artillery"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("recon_sweep"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("recon_sweep"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("p47_rocket_attack"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("p47_rocket_attack"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("major_quick_recon_run"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("major_quick_recon_run_improved"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("recon_sweep"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("paratroopers_paradrop"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("paratroopers"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("glider_headquarters"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("ability_lock_out_glider_custom_loadout_launch_available"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("ability_lock_out_glider_hard_landed"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("ability_lock_out_glider_not_stopped"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("major_artillery"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("pack_howitzer_white_phosphorous_barrage_ability_mp"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("artillery_smoke_barrage"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("off_map_smoke_artillery"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("artillery_strike_white_phosphorous"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("artillery_white_phosphorous"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("artillery_strike_white_phosphorous"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("stuka_bombing_run_upgrade"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("stuka_bombing_strike"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("stuka_incendiary_bombs"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("stuka_flame_strike"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("stuka_fragmentation_bomb"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("stuka_fragmentation_bomb"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("stuka_close_air_support"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("stuka_close_air_support"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("stuka_smoke_bomb"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("stuka_smoke_bomb"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("stuka_flame_strike"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("stuka_incendiary_bombs"))
        Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("stuka_strafe"))
        Player_AddAbility(player7, BP_GetAbilityBlueprint("stuka_strafing_run"))
		Player_CompleteUpgrade(player7, BP_GetUpgradeBlueprint("valiant_assault"))
		Player_AddAbility(player7, BP_GetAbilityBlueprint("valiant_assault"))

        Player_AddAbility(player8, BP_GetAbilityBlueprint("flare_artillery"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("flare_artillery"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("stuka_incendiary_bombs"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("stuka_flame_strike"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("flare_artillery"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("flare_artillery"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("il-2_precision_bomb_strike"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("il-2_bomb_Strike"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("major_artillery"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("light_support_artillery"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("light_artillery_support"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("fire_artillery"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("fire_artillery"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("time_on_target_artillery"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("time_on_target_artillery"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("flare_artillery"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("flare_artillery"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("time_on_target_artillery"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("time_on_target_artillery"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("recon_sweep"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("recon_sweep"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("p47_rocket_attack"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("p47_rocket_attack"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("major_quick_recon_run"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("major_quick_recon_run_improved"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("recon_sweep"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("paratroopers_paradrop"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("paratroopers"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("glider_headquarters"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("ability_lock_out_glider_custom_loadout_launch_available"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("ability_lock_out_glider_hard_landed"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("ability_lock_out_glider_not_stopped"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("major_artillery"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("pack_howitzer_white_phosphorous_barrage_ability_mp"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("artillery_smoke_barrage"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("off_map_smoke_artillery"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("artillery_strike_white_phosphorous"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("artillery_white_phosphorous"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("artillery_strike_white_phosphorous"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("stuka_bombing_run_upgrade"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("stuka_bombing_strike"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("stuka_incendiary_bombs"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("stuka_flame_strike"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("stuka_fragmentation_bomb"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("stuka_fragmentation_bomb"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("stuka_close_air_support"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("stuka_close_air_support"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("stuka_smoke_bomb"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("stuka_smoke_bomb"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("stuka_flame_strike"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("stuka_incendiary_bombs"))
        Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("stuka_strafe"))
        Player_AddAbility(player8, BP_GetAbilityBlueprint("stuka_strafing_run"))
		Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("valiant_assault"))
		Player_AddAbility(player8, BP_GetAbilityBlueprint("valiant_assault"))
		
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

---------------------------------Victory-----------------------------------


function Victory()

        Rule_AddDelayedInterval(TrainPlayerChange, 1, 1)
        Rule_AddDelayedInterval(EndKurtWarp, 1, 1)
		Rule_AddDelayedInterval(EndOttoWarp, 1, 1)
		Rule_AddDelayedInterval(WilhelmTrain, 1, 1)
		Rule_AddDelayedInterval(TrainThreeDisappear, 1, 1)

        Rule_AddDelayedInterval(AAAAA, 1, 1)
		Rule_AddDelayedInterval(DAAAA, 1, 1)
		Rule_AddDelayedInterval(ADAAA, 1, 1)
		Rule_AddDelayedInterval(AADAA, 1, 1)
		Rule_AddDelayedInterval(ADDAA, 1, 1)
		Rule_AddDelayedInterval(DDAAA, 1, 1)
		Rule_AddDelayedInterval(DADAA, 1, 1)
		Rule_AddDelayedInterval(DDDAA, 1, 1)
		Rule_AddDelayedInterval(AAADA, 1, 1)
		Rule_AddDelayedInterval(DAADA, 1, 1)
		Rule_AddDelayedInterval(ADADA, 1, 1)
		Rule_AddDelayedInterval(AADDA, 1, 1)
		Rule_AddDelayedInterval(ADDDA, 1, 1)
		Rule_AddDelayedInterval(DDADA, 1, 1)
		Rule_AddDelayedInterval(DADDA, 1, 1)
		Rule_AddDelayedInterval(DDDDA, 1, 1)
		Rule_AddDelayedInterval(AAAAD, 1, 1)
		Rule_AddDelayedInterval(DAAAD, 1, 1)
		Rule_AddDelayedInterval(ADAAD, 1, 1)
		Rule_AddDelayedInterval(AADAD, 1, 1)
		Rule_AddDelayedInterval(ADDAD, 1, 1)
		Rule_AddDelayedInterval(DDAAD, 1, 1)
		Rule_AddDelayedInterval(DADAD, 1, 1)
		Rule_AddDelayedInterval(DDDAD, 1, 1)
		Rule_AddDelayedInterval(AAADD, 1, 1)
		Rule_AddDelayedInterval(DAADD, 1, 1)
		Rule_AddDelayedInterval(ADADD, 1, 1)
		Rule_AddDelayedInterval(AADDD, 1, 1)
		Rule_AddDelayedInterval(ADDDD, 1, 1)
		Rule_AddDelayedInterval(DDADD, 1, 1)
		Rule_AddDelayedInterval(DADDD, 1, 1)
		Rule_AddDelayedInterval(DDDDD, 1, 1)

end

function TrainPlayerChange()

        local Control1 = SGroup_Count(Wilhelm)
		if Control1 == 0 then
        		SGroup_SetPlayerOwner(TrainThree, player3)
				Rule_RemoveMe()
		end
end

function EndKurtWarp()

        local Control1 = Prox_AreSquadsNearMarker(Kurt, mkr_traindoor, false)
		if Control1 == true then
        		SGroup_WarpToMarker(Kurt, mkr_endtraintrigger)
				Rule_RemoveMe()
		end
end

function EndOttoWarp()

        local Control1 = Prox_AreSquadsNearMarker(Otto, mkr_traindoor, false)
		if Control1 == true then
        		SGroup_WarpToMarker(Otto, mkr_endtraintrigger)
				Rule_RemoveMe()
		end
end

function WilhelmTrain()

        local Control1 = SGroup_Count(Wilhelm)
		if Control1 == 0 then
        		SGroup_Hide(TrainThree, false)
	            SGroup_EnableMinimapIndicator(TrainThree, true)
				Rule_RemoveMe()
		end
end

function TrainThreeDisappear()

        local Control1 = Prox_AreSquadsNearMarker(TrainThree, mkr_trainthreeto, false)
		if Control1 == true then
        		SGroup_DestroyAllSquads(TrainThree)
				Rule_RemoveMe()
		end
end




function AAAAA()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 1 and Control3 == 1 and Control4 == 1 and Control5 == 1 and Control6 == 1 then
		                Util_StartIntel(END.KurtAAAAA)
				        Rule_RemoveMe()
				end
		end
end

function DAAAA()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 0 and Control3 == 1 and Control4 == 1 and Control5 == 1 and Control6 == 1 then
		                Util_StartIntel(END.KurtDAAAA)
				        Rule_RemoveMe()
				end
		end
end

function ADAAA()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 1 and Control3 == 0 and Control4 == 1 and Control5 == 1 and Control6 == 1 then
		                Util_StartIntel(END.KurtADAAA)
				        Rule_RemoveMe()
				end
		end
end

function AADAA()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 1 and Control3 == 1 and Control4 == 0 and Control5 == 1 and Control6 == 1 then
		                Util_StartIntel(END.KurtAADAA)
				        Rule_RemoveMe()
				end
		end
end

function ADDAA()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 1 and Control3 == 0 and Control4 == 0 and Control5 == 1 and Control6 == 1 then
		                Util_StartIntel(END.KurtADDAA)
				        Rule_RemoveMe()
				end
		end
end

function DDAAA()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 0 and Control3 == 0 and Control4 == 1 and Control5 == 1 and Control6 == 1 then
		                Util_StartIntel(END.KurtDDAAA)
				        Rule_RemoveMe()
				end
		end
end

function DADAA()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 0 and Control3 == 1 and Control4 == 0 and Control5 == 1 and Control6 == 1 then
		                Util_StartIntel(END.KurtDADAA)
				        Rule_RemoveMe()
				end
		end
end

function DDDAA()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 0 and Control3 == 0 and Control4 == 0 and Control5 == 1 and Control6 == 1 then
		                Util_StartIntel(END.KurtDDDAA)
				        Rule_RemoveMe()
				end
		end
end

function AAADA()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 1 and Control3 == 1 and Control4 == 1 and Control5 == 0 and Control6 == 1 then
		                Util_StartIntel(END.KurtAAADA)
				        Rule_RemoveMe()
				end
		end
end

function DAADA()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 0 and Control3 == 1 and Control4 == 1 and Control5 == 0 and Control6 == 1 then
		                Util_StartIntel(END.KurtDAADA)
				        Rule_RemoveMe()
				end
		end
end

function ADADA()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 1 and Control3 == 0 and Control4 == 1 and Control5 == 0 and Control6 == 1 then
		                Util_StartIntel(END.KurtADADA)
				        Rule_RemoveMe()
				end
		end
end

function AADDA()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 1 and Control3 == 1 and Control4 == 0 and Control5 == 0 and Control6 == 1 then
		                Util_StartIntel(END.KurtAADDA)
				        Rule_RemoveMe()
				end
		end
end

function ADDDA()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 1 and Control3 == 0 and Control4 == 0 and Control5 == 0 and Control6 == 1 then
		                Util_StartIntel(END.KurtADDDA)
				        Rule_RemoveMe()
				end
		end
end

function DDADA()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 0 and Control3 == 0 and Control4 == 1 and Control5 == 0 and Control6 == 1 then
		                Util_StartIntel(END.KurtDDADA)
				        Rule_RemoveMe()
				end
		end
end

function DADDA()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 0 and Control3 == 1 and Control4 == 0 and Control5 == 0 and Control6 == 1 then
		                Util_StartIntel(END.KurtDADDA)
				        Rule_RemoveMe()
				end
		end
end

function DDDDA()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 0 and Control3 == 0 and Control4 == 0 and Control5 == 0 and Control6 == 1 then
		                Util_StartIntel(END.KurtDDDDA)
				        Rule_RemoveMe()
				end
		end
end

function AAAAD()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 1 and Control3 == 1 and Control4 == 1 and Control5 == 1 and Control6 == 0 then
		                Util_StartIntel(END.KurtAAAAD)
				        Rule_RemoveMe()
				end
		end
end

function DAAAD()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 0 and Control3 == 1 and Control4 == 1 and Control5 == 1 and Control6 == 0 then
		                Util_StartIntel(END.KurtDAAAD)
				        Rule_RemoveMe()
				end
		end
end

function ADAAD()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 1 and Control3 == 0 and Control4 == 1 and Control5 == 1 and Control6 == 0 then
		                Util_StartIntel(END.KurtADAAD)
				        Rule_RemoveMe()
				end
		end
end

function AADAD()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 1 and Control3 == 1 and Control4 == 0 and Control5 == 1 and Control6 == 0 then
		                Util_StartIntel(END.KurtAADAD)
				        Rule_RemoveMe()
				end
		end
end

function ADDAD()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 1 and Control3 == 0 and Control4 == 0 and Control5 == 1 and Control6 == 0 then
		                Util_StartIntel(END.KurtADDAD)
				        Rule_RemoveMe()
				end
		end
end

function DDAAD()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 0 and Control3 == 0 and Control4 == 1 and Control5 == 1 and Control6 == 0 then
		                Util_StartIntel(END.KurtDDAAD)
				        Rule_RemoveMe()
				end
		end
end

function DADAD()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 0 and Control3 == 1 and Control4 == 0 and Control5 == 1 and Control6 == 0 then
		                Util_StartIntel(END.KurtDADAD)
				        Rule_RemoveMe()
				end
		end
end

function DDDAD()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 0 and Control3 == 0 and Control4 == 0 and Control5 == 1 and Control6 == 0 then
		                Util_StartIntel(END.KurtDDDAD)
				        Rule_RemoveMe()
				end
		end
end

function AAADD()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 1 and Control3 == 1 and Control4 == 1 and Control5 == 0 and Control6 == 0 then
		                Util_StartIntel(END.KurtAAADD)
				        Rule_RemoveMe()
				end
		end
end

function DAADD()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 0 and Control3 == 1 and Control4 == 1 and Control5 == 0 and Control6 == 0 then
		                Util_StartIntel(END.KurtDAADD)
				        Rule_RemoveMe()
				end
		end
end

function ADADD()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 1 and Control3 == 0 and Control4 == 1 and Control5 == 0 and Control6 == 0 then
		                Util_StartIntel(END.KurtADADD)
				        Rule_RemoveMe()
				end
		end
end

function AADDD()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 1 and Control3 == 1 and Control4 == 0 and Control5 == 0 and Control6 == 0 then
		                Util_StartIntel(END.KurtAADDD)
				        Rule_RemoveMe()
				end
		end
end

function ADDDD()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 1 and Control3 == 0 and Control4 == 0 and Control5 == 0 and Control6 == 0 then
		                Util_StartIntel(END.KurtADDDD)
				        Rule_RemoveMe()
				end
		end
end

function DDADD()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 0 and Control3 == 0 and Control4 == 1 and Control5 == 0 and Control6 == 0 then
		                Util_StartIntel(END.KurtDDADD)
				        Rule_RemoveMe()
				end
		end
end

function DADDD()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 0 and Control3 == 1 and Control4 == 0 and Control5 == 0 and Control6 == 0 then
		                Util_StartIntel(END.KurtDADDD)
				        Rule_RemoveMe()
				end
		end
end

function DDDDD()

        local Control1 = SGroup_Count(Wilhelm)
        if Control1 == 0 then
		        local Control2 = SGroup_Count(VillageChoice)
				local Control3 = SGroup_Count(FortChoice)
				local Control4 = SGroup_Count(TrenchChoice)
				local Control5 = SGroup_Count(OptionalChoice)
				local Control6 = SGroup_Count(OutpostChoice)
                if Control2 == 0 and Control3 == 0 and Control4 == 0 and Control5 == 0 and Control6 == 0 then
		                Util_StartIntel(END.KurtDDDDD)
				        Rule_RemoveMe()
				end
		end
end

END = {}

        EndText1 = Util_CreateLocString("We made it Otto! We did it! Hopefully there is nothing more between us and Switzerland.")
		EndText2 = Util_CreateLocString("At last... We are so close to the end... Now we just need to drive this train to Zurich to meet my family.")
		EndText3 = Util_CreateLocString("Do you even know how to operate a train?")
		EndText4 = Util_CreateLocString("Who knows! We will figure it out!")
		
		EndText5 = Util_CreateLocString("You have unlocked the ending: THE GOLDEN LEGACIES")
		EndText6 = Util_CreateLocString("The train journey took three days as Kurt and Otto commandeered the train towards Zurich. They eventually stopped the train on the outskirts of Zurich on 3 March 1945 and hid its golden cargo.")
		EndText7 = Util_CreateLocString("In a failed desperate attempt to prevent the gold escaping into the fog of war, the American airforce bombed presumed rail targets in the Swiss cities of Basel and Zurich, only one day after Kurt and Otto's arrival. These bombings would later be explained as accidental.")
		EndText8 = Util_CreateLocString("Otto immediately set out to find his family. Reuniting with them in Zurich soon afterwards.")
		EndText9 = Util_CreateLocString("Buoyed by his share of the secret wealth, Otto and his family took advantage of the post-war environment to live a very comfortable life. Otto eventually started a successful engineering company in Switzerland, which his descendants continue to lead today.")
		EndText10 = Util_CreateLocString("Otto's family today holds great influence amongst the rich and powerful in Switzerland. Otto died happily, surrounded by family in 1990.")
		EndText11 = Util_CreateLocString("Kurt stayed with Otto and his family for two months before using his share of the wealth to purchase his own property in Zurich. He stayed in Zurich until 1949 and then decided to return to West Germany in search of his parents.")
		EndText12 = Util_CreateLocString("Upon returning to only ruins and graves, Kurt settled and eventually wed in the city of Bonn in West Germany. He travelled with his family between West Germany, Netherlands, Belgium and Switzerland in the following years, often meeting Otto while in Zurich.")
		EndText13 = Util_CreateLocString("Kurt used his wealth wisely in the following decades and gained influence in West Germany, eventually securing a senior political position in the West German government forming critical policies. Kurt's family retained their elite status even after the reunification of Germany.")
		EndText14 = Util_CreateLocString("Kurt's family today is influential in the political, social and business spheres. Kurt died in 1990 a content man, surrounded by family, friends and respected by the highest echelons of German society.")
		
		
		
END.KurtAAAAA = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_MoveTo(mkr_finaletraincamera)
    Camera_SetZoomDist(20)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_endkurttrainwarp)
	SGroup_WarpToMarker(Otto, mkr_endottotrainwarp)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_endkurttrainto)
	Cmd_Move(Otto, mkr_endottotrainto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText2)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_traindoor)
	Cmd_Move(Otto, mkr_traindoor)
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText4)
	CTRL.WAIT()
	CTRL.Event_Delay(3)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_lastcamera)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(TrainThree, mkr_trainthreeto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText6)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText7)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText8)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText9)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText10)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText11)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText12)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText13)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText14)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()

end

        EndText15 = Util_CreateLocString("You have unlocked the ending: TIMELESS CHARITY")
		EndText16 = Util_CreateLocString("The train journey took three days as Kurt and Otto commandeered the train towards Zurich. They eventually stopped the train on the outskirts of Zurich on 3 March 1945 and hid its golden cargo.")
		EndText17 = Util_CreateLocString("In a failed desperate attempt to prevent the gold escaping into the fog of war, the American airforce bombed presumed rail targets in the Swiss cities of Basel and Zurich, only one day after Kurt and Otto's arrival. These bombings would later be explained as accidental.")
		EndText18 = Util_CreateLocString("Otto immediately set out to find his family. Reuniting with them in Zurich a few days later.")
		EndText19 = Util_CreateLocString("Eight months pass, having spent only a fraction of his wealth, Otto returned to where he left the gold, only to discover it missing. Regardless, the money he already spent ensured a decent life for his family and he eventually set up shop as a watchmaker.")
		EndText20 = Util_CreateLocString("Otto's family lived a comfortable life and eventually his children would elevate his watchmaking business to great renown. Otto died as a happy man in 1986, surrounded by his family.")
		EndText21 = Util_CreateLocString("Kurt stayed with Otto and his family for two months before using his share of the wealth to purchase a house in Basel. He stayed in Basel until 1949 and then decided to return to West Germany in search of his parents.")
		EndText22 = Util_CreateLocString("Upon returning to only ruins and graves, Kurt eventually settled in Frankfurt and began using his wealth to fund a railway company. This ultimately proved a wise choice as the company proceeded to be successful.")
		EndText23 = Util_CreateLocString("Kurt never married, but lived a fulfilling life travelling and visiting locations in West Germany, Netherlands, Belgium and Switzerland, often meeting Otto while in Zurich. Kurt donated most of his fortune to charitable organizations throughout his life.")
		EndText24 = Util_CreateLocString("These charities had significant impact in post-war West Germany and continued to operate thanks to Kurt's generous donations even after the reunification of Germany. Kurt died as a fulfilled man in 1988, beloved by all who knew him.")
	 

END.KurtDAAAA = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_MoveTo(mkr_finaletraincamera)
    Camera_SetZoomDist(20)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_endkurttrainwarp)
	SGroup_WarpToMarker(Otto, mkr_endottotrainwarp)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_endkurttrainto)
	Cmd_Move(Otto, mkr_endottotrainto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText2)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_traindoor)
	Cmd_Move(Otto, mkr_traindoor)
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText4)
	CTRL.WAIT()
	CTRL.Event_Delay(3)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_lastcamera)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(TrainThree, mkr_trainthreeto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText15)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText16)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText17)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText18)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText19)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText20)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText21)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText22)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText23)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText24)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()

end

        EndText25 = Util_CreateLocString("You have unlocked the ending: INFLUENCE AS TWO")
		EndText26 = Util_CreateLocString("The train journey took three days as Kurt and Otto commandeered the train towards Zurich. They eventually stopped the train on the outskirts of Zurich on 3 March 1945 and hid its golden cargo.")
		EndText27 = Util_CreateLocString("In a failed desperate attempt to prevent the gold escaping into the fog of war, the American airforce bombed presumed rail targets in the Swiss cities of Basel and Zurich, only one day after Kurt and Otto's arrival. These bombings would later be explained as accidental.")
		EndText28 = Util_CreateLocString("Otto immediately set out to find his family. Reuniting with them in Zurich a few days later.")
		EndText29 = Util_CreateLocString("Settled in Zurich with nothing but time and wealth, Otto sought to establish firmer roots in the city for his family and began networking initially with the locals, but eventually with more connected individuals.")
		EndText30 = Util_CreateLocString("Otto's connections and wealth afforded his family great influence and a luxurious lifestyle. One would be hard pressed to find a more influential family in Switzerland. Otto died in 1987, surrounded by friends and family as part of a huge funeral held in his honor.")
		EndText31 = Util_CreateLocString("Kurt stayed with Otto and his family for a year before returning to West Germany in search of his parents. Kurt and Otto often socialized together with the other locals in that year and the pair became lifelong friends.")
		EndText32 = Util_CreateLocString("Upon returning to only ruins and graves in West Germany, Kurt eventually settled in Stuttgart and used his wealth to open the largest bar in the city. This bar attracted patrons from all the surrounding areas and was also frequented by Otto when he visited the city.")
		EndText33 = Util_CreateLocString("Kurt eventually married a waitress of the bar and had two children with her. The large range of patrons he garnered allowed Kurt to be known throughout the city. Kurt would eventually become mayor of Stuttgart thanks to his popularity.")
		EndText34 = Util_CreateLocString("For fifteen years Kurt served as either mayor or deputy mayor of Stuttgart until he resigned to spend more time with his grandchildren. Kurt died in 1980, his funeral was considered a huge event and was attended by his family, Otto, and much of the city's residents.")
	 

END.KurtADAAA = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_MoveTo(mkr_finaletraincamera)
    Camera_SetZoomDist(20)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_endkurttrainwarp)
	SGroup_WarpToMarker(Otto, mkr_endottotrainwarp)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_endkurttrainto)
	Cmd_Move(Otto, mkr_endottotrainto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText2)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_traindoor)
	Cmd_Move(Otto, mkr_traindoor)
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText4)
	CTRL.WAIT()
	CTRL.Event_Delay(3)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_lastcamera)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(TrainThree, mkr_trainthreeto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText25)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText26)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText27)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText28)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText29)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText30)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText31)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText32)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText33)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText34)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()

end

        EndText35 = Util_CreateLocString("You have unlocked the ending: IDEAS OF JUSTICE")
		EndText36 = Util_CreateLocString("The train journey took three days as Kurt and Otto commandeered the train towards Zurich. They eventually stopped the train on the outskirts of Zurich on 3 March 1945 and hid its golden cargo.")
		EndText37 = Util_CreateLocString("In a failed desperate attempt to prevent the gold escaping into the fog of war, the American airforce bombed presumed rail targets in the Swiss cities of Basel and Zurich, only one day after Kurt and Otto's arrival. These bombings would later be explained as accidental.")
		EndText38 = Util_CreateLocString("Otto immediately set out to find his family. Reuniting with them in Zurich a few days later.")
		EndText39 = Util_CreateLocString("Otto spent the three years afterwards enjoying time with his family. During this time Otto realized that war is a mad injustice caused by man and he resolved himself to curing the world of this illness. Otto used his wealth to fund and organize those with similar ideas.")
		EndText40 = Util_CreateLocString("Otto became a renowned pacifist and his wealth allowed his message to be heard. With his family by his side he facilitated huge Swiss post-war humanitarian efforts. Otto died a well respected man in 1985 surrounded by his family, highly regarded by all who knew him.")
		EndText41 = Util_CreateLocString("Kurt stayed with Otto and his family for a year before using his wealth to purchase his own house in Zurich. Kurt became interested in medical science and would spend much of his time becoming an adept chemist.")
		EndText42 = Util_CreateLocString("Kurt eventually returned to West Germany in search of his parents. Upon returning to only ruins and graves in his home town, Kurt travelled around and finally settled in Bonn, where he met his wife and started a family. Kurt used his wealth to build his own laboratory in the city.")
		EndText43 = Util_CreateLocString("Kurt began recruiting high potential chemists and medical practitioners to conduct research and live on his dime, keen to create a medical breakthrough that would benefit humanity. His efforts would eventually lead to new discoveries in antibiotic and rehabilitative sciences.")
		EndText44 = Util_CreateLocString("With his medical footprint established, Kurt retreated to his family in his later years until his death in 1989. He died a content man, knowing he tried and achieved some measure of benefit to humanity.")
	 

END.KurtAADAA = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_MoveTo(mkr_finaletraincamera)
    Camera_SetZoomDist(20)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_endkurttrainwarp)
	SGroup_WarpToMarker(Otto, mkr_endottotrainwarp)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_endkurttrainto)
	Cmd_Move(Otto, mkr_endottotrainto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText2)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_traindoor)
	Cmd_Move(Otto, mkr_traindoor)
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText4)
	CTRL.WAIT()
	CTRL.Event_Delay(3)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_lastcamera)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(TrainThree, mkr_trainthreeto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText35)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText36)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText37)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText38)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText39)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText40)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText41)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText42)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText43)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText44)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()

end

        EndText45 = Util_CreateLocString("You have unlocked the ending: TREASURES MOST DEAR")
		EndText46 = Util_CreateLocString("The train journey took three days as Kurt and Otto commandeered the train towards Zurich. They eventually stopped the train on the outskirts of Zurich on 3 March 1945 and hid its golden cargo.")
		EndText47 = Util_CreateLocString("In a failed desperate attempt to prevent the gold escaping into the fog of war, the American airforce bombed presumed rail targets in the Swiss cities of Basel and Zurich, only one day after Kurt and Otto's arrival. These bombings would later be explained as accidental.")
		EndText48 = Util_CreateLocString("Otto immediately set out to find his family. Reuniting with them in Zurich a few days later.")
		EndText49 = Util_CreateLocString("Finally together with his family and with wealth to last a lifetime and more, Otto simply wanted to spend the rest of his life taking care of what matters to him the most, his family. Otto created trusts and invested his wealth into them for his children to use as they aged.")
		EndText50 = Util_CreateLocString("Otto devoted himself to his family, and tended to the needs of his wife, his children and eventually his grandchildren. His trusts guaranteed the futures of his descendants for generations to come. Otto died a content family man in 1985, surrounded by those he loved so dearly.")
		EndText51 = Util_CreateLocString("Kurt stayed with Otto and his family for six months before using his wealth to purchase his own house in Zurich. It was during his time in Zurich he discovered his passion for collecting works of art. Kurt eventually returned to West Germany in 1949 to search for his parents.")
		EndText52 = Util_CreateLocString("Upon returning to only ruins and graves, Kurt settled and wed in Bonn, where he and his wife used their wealth to collect ever more unique works of art, culminating in the construction and opening of their own art gallery six years later.")
		EndText53 = Util_CreateLocString("Kurt had a particular eye for collecting genuine art pieces and his family collection would include singular original works by Leonardo da Vinci, Vincent van Gogh and Gustav Klimt amongst others. His family collection was crucial in protecting these artworks in post-war Germany.")
		EndText54 = Util_CreateLocString("The Bachmann Family Collection is credited with preserving many of the world's most renowned works of art today. Kurt died surrounded by family in 1980, his name remembered as a saviour of irreplaceable treasures in the artistic world.")
	 

END.KurtADDAA = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_MoveTo(mkr_finaletraincamera)
    Camera_SetZoomDist(20)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_endkurttrainwarp)
	SGroup_WarpToMarker(Otto, mkr_endottotrainwarp)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_endkurttrainto)
	Cmd_Move(Otto, mkr_endottotrainto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText2)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_traindoor)
	Cmd_Move(Otto, mkr_traindoor)
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText4)
	CTRL.WAIT()
	CTRL.Event_Delay(3)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_lastcamera)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(TrainThree, mkr_trainthreeto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText45)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText46)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText47)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText48)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText49)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText50)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText51)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText52)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText53)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText54)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()

end

        EndText55 = Util_CreateLocString("You have unlocked the ending: THE JOYS OF LIFE")
		EndText56 = Util_CreateLocString("The train journey took three days as Kurt and Otto commandeered the train towards Zurich. They eventually stopped the train on the outskirts of Zurich on 3 March 1945 and hid its golden cargo.")
		EndText57 = Util_CreateLocString("In a failed desperate attempt to prevent the gold escaping into the fog of war, the American airforce bombed presumed rail targets in the Swiss cities of Basel and Zurich, only one day after Kurt and Otto's arrival. These bombings would later be explained as accidental.")
		EndText58 = Util_CreateLocString("Otto immediately set out to find his family. Reuniting with them in Zurich a few days later.")
		EndText59 = Util_CreateLocString("Otto realized he found incredible joy when making others laugh, and he had a pretty attractive style of self-deprecating humor. Otto used his wealth to get a spot on the Swiss radio's weekly 'humor hour' slot and found the public was very receptive to his humor.")
		EndText60 = Util_CreateLocString("Otto soon became a household name as an entertainer on the radio and eventually on television. His popularity would propel him to celebrity status in Switzerland. Otto died in 1983, surrounded by his family and crowds wishing to pay their respects to their idol.")
		EndText61 = Util_CreateLocString("Kurt stayed with Otto and his family for three months before using his wealth to purchase his own house in Bern. Fuelled by his tremendous wealth, Kurt spent his days fornicating with the local women and indulging in the finest luxuries money can buy.")
		EndText62 = Util_CreateLocString("After four years of this carefree lifestyle, Kurt decided to search for his parents in West Germany. However, upon finding only ruins and graves, Kurt once again began spending to satisfy his every desire as he travelled across all of West Germany to see what it can offer.")
		EndText63 = Util_CreateLocString("Kurt used his wealth and bought a mansion in Cologne. Eventually both he and the mansion was known far and wide as the place to go if one wished to explore bodily boundaries. In time, The Bachmann Mansion became a byword for lust and human desire across West Germany and beyond.")
		EndText64 = Util_CreateLocString("In his later years, Kurt would turn his mansion into a place to help troubled couples, while he became the authority on ways to mend broken relationships. Kurt died in 1978, happy he lived his life as he wanted to.")
	 

END.KurtDDAAA = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_MoveTo(mkr_finaletraincamera)
    Camera_SetZoomDist(20)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_endkurttrainwarp)
	SGroup_WarpToMarker(Otto, mkr_endottotrainwarp)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_endkurttrainto)
	Cmd_Move(Otto, mkr_endottotrainto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText2)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_traindoor)
	Cmd_Move(Otto, mkr_traindoor)
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText4)
	CTRL.WAIT()
	CTRL.Event_Delay(3)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_lastcamera)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(TrainThree, mkr_trainthreeto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText55)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText56)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText57)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText58)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText59)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText60)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText61)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText62)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText63)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText64)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()

end


        EndText65 = Util_CreateLocString("You have unlocked the ending: PARAGONS OF EDUCATION")
		EndText66 = Util_CreateLocString("The train journey took three days as Kurt and Otto commandeered the train towards Zurich. They eventually stopped the train on the outskirts of Zurich on 3 March 1945 and hid its golden cargo.")
		EndText67 = Util_CreateLocString("In a failed desperate attempt to prevent the gold escaping into the fog of war, the American airforce bombed presumed rail targets in the Swiss cities of Basel and Zurich, only one day after Kurt and Otto's arrival. These bombings would later be explained as accidental.")
		EndText68 = Util_CreateLocString("Otto immediately set out to find his family. Reuniting with them in Zurich a few days later.")
		EndText69 = Util_CreateLocString("With family safe and wealth beyond measure, Otto had no significant worry in his life. Otto discovered a passion for teaching, and after eight years of trying, he successfully applied for a role as lecturer of engineering at the University of Zurich.")
		EndText70 = Util_CreateLocString("Otto's knowledge helped Switzerland make crucial manufacturing and purchasing decisions in the post-war period that continues to influence Swiss government policy and actions today. Otto died a content man in 1982, surrounded by his family.")
		EndText71 = Util_CreateLocString("Kurt stayed with Otto and his family for three years before buying his own house in Zurich. When Otto began his attempts to be accepted by the University of Zurich, Kurt helped him research various engineering topics as needed.")
		EndText72 = Util_CreateLocString("Kurt eventually became an expert of engineering himself and for four years he assisted Otto in his role of lecturer as assistant researcher. Kurt then decided to travel to West Germany in search of his parents.")
		EndText73 = Util_CreateLocString("Upon finding only ruins and graves in his home town, Kurt returned to Zurich and used his share of wealth to construct a fully modern research laboratory. The Bachmann Institute served as a beacon of research and learning for decades.")
		EndText74 = Util_CreateLocString("Kurt married his own assistant researcher in 1962 and had three children. His family today continues to manage his laboratory, albeit under a different name. Kurt died in 1983, a frequently quoted name in the field of mechanical engineering.")
	 

END.KurtDADAA = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_MoveTo(mkr_finaletraincamera)
    Camera_SetZoomDist(20)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_endkurttrainwarp)
	SGroup_WarpToMarker(Otto, mkr_endottotrainwarp)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_endkurttrainto)
	Cmd_Move(Otto, mkr_endottotrainto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText2)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_traindoor)
	Cmd_Move(Otto, mkr_traindoor)
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText4)
	CTRL.WAIT()
	CTRL.Event_Delay(3)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_lastcamera)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(TrainThree, mkr_trainthreeto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText65)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText66)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText67)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText68)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText69)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText70)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText71)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText72)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText73)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText74)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()

end

        EndText75 = Util_CreateLocString("You have unlocked the ending: THE FRUITS OF TRAVELS")
		EndText76 = Util_CreateLocString("The train journey took three days as Kurt and Otto commandeered the train towards Zurich. They eventually stopped the train on the outskirts of Zurich on 3 March 1945 and hid its golden cargo.")
		EndText77 = Util_CreateLocString("In a failed desperate attempt to prevent the gold escaping into the fog of war, the American airforce bombed presumed rail targets in the Swiss cities of Basel and Zurich, only one day after Kurt and Otto's arrival. These bombings would later be explained as accidental.")
		EndText78 = Util_CreateLocString("Otto immediately set out to find his family. Reuniting with them in Zurich a few days later.")
		EndText79 = Util_CreateLocString("During the next two years, Otto developed a hobby collecting fine wines. His wealth enabled him to collect and store any wine as he fancies. After ten years of travelling around Switzerland collecting his wines, his collection is among the biggest in Switzerland.")
		EndText80 = Util_CreateLocString("Otto's wine collection became an integral part of his family, with his children tending to it in their lifetimes also. His stock of prized wines is considered a tourist attraction in Zurich today. Otto died a renowned wine connoisseur in 1977, surrounded by his family.")
		EndText81 = Util_CreateLocString("Kurt stayed with Otto and his family for a month before buying his own house in Bern. But Kurt could never settle, and spent months travelling around Switzerland. After the war ended, Kurt decided to return to West Germany in search of his parents.")
		EndText82 = Util_CreateLocString("Upon finding only ruins and graves, Kurt moved to Bonn, but was again unable to settle, as he yearned to see new places in times of peace. In the following decade, funded by his vast wealth, Kurt journeyed across West Germany, Belgium, Netherlands and Switzerland.")
		EndText83 = Util_CreateLocString("Kurt then settled for two years in a small hamlet in Liechtenstein, before again succumbing to his itch to explore. He would then travel across continents to explore China, India, Thailand, Japan and the Philippines before finally deciding he had seen enough.")
		EndText84 = Util_CreateLocString("Kurt eventually returned to Liechtenstein in his later years, where he wrote a book about his travels. His book became the top bestseller in Germany, Austria and Switzerland. Kurt died in 1990, a fulfilled man having seen more of the world than most of his time.")
	 

END.KurtDDDAA = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_MoveTo(mkr_finaletraincamera)
    Camera_SetZoomDist(20)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_endkurttrainwarp)
	SGroup_WarpToMarker(Otto, mkr_endottotrainwarp)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_endkurttrainto)
	Cmd_Move(Otto, mkr_endottotrainto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText2)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_traindoor)
	Cmd_Move(Otto, mkr_traindoor)
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText4)
	CTRL.WAIT()
	CTRL.Event_Delay(3)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_lastcamera)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(TrainThree, mkr_trainthreeto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText75)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText76)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText77)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText78)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText79)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText80)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText81)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText82)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText83)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText84)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()

end

        EndText85 = Util_CreateLocString("We did it Otto! Surely there will not be any more trouble from Task Force Eva now that Apel is dead.")
		EndText86 = Util_CreateLocString("Yes, I cannot imagine anyone who is left rallying after Apel is gone. The man held everything together.")
		EndText87 = Util_CreateLocString("So... What now? Shall we march along the tracks until we get to Switzerland?")
		EndText88 = Util_CreateLocString("Huh... That is not a bad idea! The tracks are bound to lead to Switzerland considering we are this close to the border. Good thinking Kurt!")
		
        EndText89 = Util_CreateLocString("You have unlocked the ending: PAPER INSTITUTIONS")
		EndText90 = Util_CreateLocString("With the leader of Task Force Eva dead, nobody noticed Kurt and Otto as they trekked across the snowy woods alongside the train tracks. They marched for another three weeks until they crossed the border to arrive at the Swiss city of Basel.")
		EndText91 = Util_CreateLocString("The pair did odd jobs in Basel and paid for a coach driver to take them to Zurich. After another week on the road they were finally dropped off on the outskirts of the city.")
		EndText92 = Util_CreateLocString("Otto immediately set out to find his family. Reuniting with them a few days later.")
		EndText93 = Util_CreateLocString("Determined to provide for his family, Otto eventually found a position as a copyeditor of the newspaper Neue Zürcher Zeitung based in Zurich.")
		EndText94 = Util_CreateLocString("Otto learned the skills of the trade and clawed his way to the title of editor over the next two decades. He presided over the period of the greatest growth in the history of his newspaper. Otto died in 1979, surrounded by his forever grateful family.")
		EndText95 = Util_CreateLocString("Kurt stayed with Otto and his family for two years, getting a job as a clerk at the bank Credit Suisse and contributing much of his wages to Otto's family upkeep as a way to pay for his share. Kurt bought his own house in Zurich three years later.")
		EndText96 = Util_CreateLocString("Over the next two decades, Kurt rose through the ranks to became a prominent banker. He would marry Agatha, a fellow colleague, and have a child with her. Both working adults with good positions, they would live without financial worry into old age.")
		EndText97 = Util_CreateLocString("In 1970 Agatha suddenly died due to health complications. Kurt was left heartbroken and retreated to his home, rarely seen by anyone except for his son. He began writing poetry to pass the time and managed to fill a large book of these poems.")
		EndText98 = Util_CreateLocString("Kurt died peacefully in his sleep in 1980, leaving his considerable estate to his son. His son eventually had his father's book of poems published and it was sold across Switzerland for the common man to enjoy.")
	    EndExtraText1 = Util_CreateLocString("On the first page of the book, a remembrance was included: In memory of Otto, Friedrich, Hans, Tomislav, Josef and Anton. True friendship is more valuable than a train full of gold.")

END.KurtAAADA = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(10)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_finalekurtwarp2)
	SGroup_WarpToMarker(Otto, mkr_finaleottowarp2)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto2)
	Cmd_Move(Otto, mkr_finaleottoto2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText85)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText86)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText87)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText88)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_finalecamera2)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto3)
	Cmd_Move(Otto, mkr_finaleottoto3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText89)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText90)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText91)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText92)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText93)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText94)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText95)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText96)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText97)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText98)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndExtraText1)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()

end

        EndText99 = Util_CreateLocString("You have unlocked the ending: EYES AND EARS")
		EndText100 = Util_CreateLocString("With the leader of Task Force Eva dead, nobody noticed Kurt and Otto as they trekked across the snowy woods alongside the train tracks. They marched for another three weeks until they crossed the border to arrive at the Swiss city of Basel.")
		EndText101 = Util_CreateLocString("The pair did odd jobs in Basel and paid for a coach driver to take them to Zurich. After another week on the road they were finally dropped off on the outskirts of the city.")
		EndText102 = Util_CreateLocString("Otto immediately set out to find his family. Reuniting with them a few days later.")
		EndText103 = Util_CreateLocString("Once he had settled down, Otto yearned for a simple life with his family. A month later Otto opened the doors to his small grocery store. The shop allowed the family to pay the bills and put the children through school.")
		EndText104 = Util_CreateLocString("Otto's store would become a staple of local life in Zurich, attracting customers from afar with his wide selection of goods and Otto's personal charm. Otto died beloved by all who knew him in 1977, having lived a simple but content life.")
		EndText105 = Util_CreateLocString("Kurt stayed with Otto and his family for four months as he looked for employment. During Kurt's weekly shopping trip, he befriended a local politican. Kurt eventually found work as a gardener for the politician and they remained good friends.")
		EndText106 = Util_CreateLocString("As the politican rose through the political ranks, Kurt was one day approached by a handler hired by East Germany with a lucrative offer. Kurt was offered a significant sum of money for information on his employer.")
		EndText107 = Util_CreateLocString("Kurt accepted the offer and delivered the requested information. His efficiency and effectiveness impressed his handlers, and Kurt became a top agent for the East German spy network in Switzerland for the next two decades.")
		EndText108 = Util_CreateLocString("Kurt wed into a loveless marriage as part of his spy activities in 1962. However they did not have children and Kurt died alone under mysterious circumstances in 1969. His funeral was attended by only one person, Otto.")
	 

END.KurtDAADA = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(10)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_finalekurtwarp2)
	SGroup_WarpToMarker(Otto, mkr_finaleottowarp2)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto2)
	Cmd_Move(Otto, mkr_finaleottoto2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText85)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText86)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText87)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText88)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_finalecamera2)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto3)
	Cmd_Move(Otto, mkr_finaleottoto3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText99)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText100)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText101)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText102)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText103)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText104)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText105)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText106)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText107)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText108)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()

end

        EndText109 = Util_CreateLocString("You have unlocked the ending: THE PROFESSIONAL PATH")
		EndText110 = Util_CreateLocString("With the leader of Task Force Eva dead, nobody noticed Kurt and Otto as they trekked across the snowy woods alongside the train tracks. They marched for another three weeks until they crossed the border to arrive at the Swiss city of Basel.")
		EndText111 = Util_CreateLocString("The pair did odd jobs in Basel and paid for a coach driver to take them to Zurich. After another week on the road they were finally dropped off on the outskirts of the city.")
		EndText112 = Util_CreateLocString("Otto immediately set out to find his family. Reuniting with them a few days later.")
		EndText113 = Util_CreateLocString("In order to ensure a stable life for his family, Otto realized he needed to find a respectable profession in Switzerland. Otto did part-time jobs while studying for the legal professional exams, he passed the exams after four years.")
		EndText114 = Util_CreateLocString("Otto initially worked for the reputable law firm Schellenberg Partners and left after a decade to start his own firm in 1960. Otto provided for all of his family's needs until his death in 1978, his funeral was attended by his family and Kurt.")
		EndText115 = Util_CreateLocString("Kurt stayed with Otto and his family for a year until he moved to Lucerne for a job working as an assistant to the lead accountant of a tax accountancy firm. Kurt and the lead accountant eventually formed their own firm five years later.")
		EndText116 = Util_CreateLocString("Kurt worked tirelessly and created a enviable client portfolio for his firm, earning himself a stellar reputation for his reliability in the process. Kurt decided to retire in 1961 after amassing a large savings account from his working days.")
		EndText117 = Util_CreateLocString("Kurt married in 1962 and for the next decade, the couple spent their time travelling between Italy and Switzerland to enjoy what life has to offer. They had two children during this time.")
		EndText118 = Util_CreateLocString("Once their children were independent, Kurt and his wife bought a house and permanently settled in Geneva. Kurt died five days after Otto's funeral in 1978, having lived a fulfilled life, surrounded by his own family.")
	 

END.KurtADADA = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(10)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_finalekurtwarp2)
	SGroup_WarpToMarker(Otto, mkr_finaleottowarp2)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto2)
	Cmd_Move(Otto, mkr_finaleottoto2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText85)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText86)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText87)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText88)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_finalecamera2)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto3)
	Cmd_Move(Otto, mkr_finaleottoto3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText109)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText110)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText111)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText112)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText113)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText114)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText115)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText116)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText117)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText118)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()

end

        EndText119 = Util_CreateLocString("You have unlocked the ending: DEATH OF A SALESMAN")
		EndText120 = Util_CreateLocString("With the leader of Task Force Eva dead, nobody noticed Kurt and Otto as they trekked across the snowy woods alongside the train tracks. They marched for another three weeks until they crossed the border to arrive at the Swiss city of Basel.")
		EndText121 = Util_CreateLocString("The pair did odd jobs in Basel and paid for a coach driver to take them to Zurich. After another week on the road they were finally dropped off on the outskirts of the city.")
		EndText122 = Util_CreateLocString("Otto immediately set out to find his family. Reuniting with them a few days later.")
		EndText123 = Util_CreateLocString("Otto luckily found a well paying job as an engineer soon after arriving at Zurich, this allowed him to sustain his family. However, Otto's real claim to fame was the book he authored named, describing how Kurt worked as a salesman.")
		EndText124 = Util_CreateLocString("Otto's book describing Kurt's sales practices was an instant bestseller and garnered international attention. Otto died in 1978 in the presence of his family, somewhat resentful his legacy will always be tied to Kurt, and not his own accomplishments.")
		EndText125 = Util_CreateLocString("Kurt stayed with Otto and his family as he searched for a source of income. Kurt eventually found one, selling dubious concoctions that he claims prevented hair loss. A ruthless but talented salesman, Kurt made a large fortune selling his products.")
		EndText126 = Util_CreateLocString("Determined to succeed no matter the cost, Kurt employed questionable sales practices to his work which he sometimes shared with Otto when they talked. Otto took great interest and secretly recorded his conversations with Kurt in a book.")
		EndText127 = Util_CreateLocString("Kurt's efforts eventually led to richer clientele and he began selling more ambitious products, including supposed elixirs of longevity and the like. As his claims grew grander, his sales tactics became bolder.")
		EndText128 = Util_CreateLocString("In 1968 as Kurt left Otto's house to retrieve more stock, he was gunned down in broad daylight. Kurt's funeral was attended by just Otto and his family, with his legacy found only within Otto's book that was aptly named 'Death of a Salesman'.")
	 

END.KurtAADDA = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(10)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_finalekurtwarp2)
	SGroup_WarpToMarker(Otto, mkr_finaleottowarp2)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto2)
	Cmd_Move(Otto, mkr_finaleottoto2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText85)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText86)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText87)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText88)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_finalecamera2)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto3)
	Cmd_Move(Otto, mkr_finaleottoto3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText119)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText120)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText121)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText122)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText123)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText124)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText125)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText126)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText127)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText128)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()

end

        EndText129 = Util_CreateLocString("You have unlocked the ending: THE COMMON MAN")
		EndText130 = Util_CreateLocString("With the leader of Task Force Eva dead, nobody noticed Kurt and Otto as they trekked across the snowy woods alongside the train tracks. They marched for another three weeks until they crossed the border to arrive at the Swiss city of Basel.")
		EndText131 = Util_CreateLocString("The pair did odd jobs in Basel and paid for a coach driver to take them to Zurich. After another week on the road they were finally dropped off on the outskirts of the city.")
		EndText132 = Util_CreateLocString("Otto immediately set out to find his family. Reuniting with them a few days later.")
		EndText133 = Util_CreateLocString("Otto leveraged his background in mechanical engineering to secure work at an automobile factory. With his family's financial situation secured, Otto tried to move up the company ladder to a managerial position but did not have much success.")
		EndText134 = Util_CreateLocString("Realizing his lack of success was because of his boss's distain for Germany' role in the war, Otto tried looking elsewhere for a better job, but was ultimately unsuccessful. Otto died surrounded by his family in 1975, having lived a uneventful post-war life.")
		EndText135 = Util_CreateLocString("Kurt stayed with Otto and his family for three years while working as an electrician. Eventually Kurt saved enough money after another three years to buy his own house in Zurich.")
		EndText136 = Util_CreateLocString("Kurt was seen as a reliable handyman, getting invitations to attend various issues at homes and businesses across Zurich. He enjoyed a stable life, with no serious worries that would occupy his time and mind.")
		EndText137 = Util_CreateLocString("Kurt married in 1955 and would have a son named Peter that same year. Peter would show to be abnormally intelligent as he grew and by the time he was an adult he was already highly sought after by government and businesses alike for his problem solving abilities.")
		EndText138 = Util_CreateLocString("With the exception of his son, Kurt lived with his wife in relative normality and obscurity. Kurt died a content man in 1974, grateful he had a loving wife and happy he raised a capable son.")
	 

END.KurtADDDA = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(10)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_finalekurtwarp2)
	SGroup_WarpToMarker(Otto, mkr_finaleottowarp2)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto2)
	Cmd_Move(Otto, mkr_finaleottoto2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText85)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText86)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText87)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText88)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_finalecamera2)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto3)
	Cmd_Move(Otto, mkr_finaleottoto3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText129)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText130)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText131)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText132)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText133)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText134)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText135)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText136)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText137)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText138)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()

end


        EndText139 = Util_CreateLocString("You have unlocked the ending: TOILS OF LABOR")
		EndText140 = Util_CreateLocString("With the leader of Task Force Eva dead, nobody noticed Kurt and Otto as they trekked across the snowy woods alongside the train tracks. They marched for another three weeks until they crossed the border to arrive at the Swiss city of Basel.")
		EndText141 = Util_CreateLocString("The pair did odd jobs in Basel and paid for a coach driver to take them to Zurich. After another week on the road they were finally dropped off on the outskirts of the city.")
		EndText142 = Util_CreateLocString("Otto immediately set out to find his family. Reuniting with them a few days later.")
		EndText143 = Util_CreateLocString("The job market in Switzerland was difficult at the time for Otto, who was unable to secure a well paying position at an established firm. Left with little options, Otto took up work as a construction worker, spending long days on construction sites.")
		EndText144 = Util_CreateLocString("Family life was simple due to Otto's meager earnings, but Otto did put his children through school and eventually the children became independent. Otto worked his entire life and died in 1960 in an accident at a work site.")
		EndText145 = Util_CreateLocString("Kurt stayed with Otto and his family for six months while he found work as a laborer doing whatever jobs were available across the city. He eventually moved to Basel into an apartment sharing with three other people.")
		EndText146 = Util_CreateLocString("Kurt toiled away doing hard manual work and his life can be described as continued survival day by day. On the days he was paid, he would spend the money on food, alcohol and cigarettes. On days when he was not paid, he would go hungry.")
		EndText147 = Util_CreateLocString("Life was simple but Kurt endured it with the friends he made amongst the laboring class. Some days were filled with joy and laughter late into the evenings. However, Kurt would move back to Zurich when he received word of Otto's death.")
		EndText148 = Util_CreateLocString("Kurt spent much of his later years keeping Otto's wife company and helping her when he could. Kurt never married and died alone in 1971, his funeral was attended by Otto's grateful wife.")
	 

END.KurtDDADA = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(10)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_finalekurtwarp2)
	SGroup_WarpToMarker(Otto, mkr_finaleottowarp2)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto2)
	Cmd_Move(Otto, mkr_finaleottoto2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText85)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText86)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText87)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText88)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_finalecamera2)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto3)
	Cmd_Move(Otto, mkr_finaleottoto3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText139)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText140)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText141)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText142)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText143)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText144)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText145)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText146)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText147)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText148)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()

end

        EndText149 = Util_CreateLocString("You have unlocked the ending: POLICY AND SECURITY")
		EndText150 = Util_CreateLocString("With the leader of Task Force Eva dead, nobody noticed Kurt and Otto as they trekked across the snowy woods alongside the train tracks. They marched for another three weeks until they crossed the border to arrive at the Swiss city of Basel.")
		EndText151 = Util_CreateLocString("The pair did odd jobs in Basel and paid for a coach driver to take them to Zurich. After another week on the road they were finally dropped off on the outskirts of the city.")
		EndText152 = Util_CreateLocString("Otto immediately set out to find his family. Reuniting with them a few days later.")
		EndText153 = Util_CreateLocString("A few days after arriving in Zurich, by chance Otto befriended the mayor of the city, Adolf Lüchinger. Adolf was fascinated by Otto's views of the city's problems after such a short spell in the city and asked Otto to become a part-time advisor.")
		EndText154 = Util_CreateLocString("Otto served Adolf faithfully, providing honest advice that Adolf and subsequent mayors all deeply valued. The role paid handsomely and allowed Otto's family a comfortable life. Otto died in 1972 a highly respected man, surrounded by his family.")
		EndText155 = Util_CreateLocString("Kurt stayed with Otto and his family for two months while trying to find work. After Otto befriended the mayor, Kurt was referred for a role as a guard at the mayor's office. It was a simple job, but Kurt accepted it gladly.")
		EndText156 = Util_CreateLocString("The daily routine was simple, guard the office and screen all visitors. During his time on the job Kurt would see protest and riots, beggars and terrorists at his post. The job was simple, but never too dull.")
		EndText157 = Util_CreateLocString("In 1951, Kurt's reliability caught the attention of Zurich's then mayor Emil Landolt, and shortly afterwards Kurt became Emil's personal guard and assistant. Kurt took increasingly more senior roles in the city until he became the security chief of the city.")
		EndText158 = Util_CreateLocString("Kurt married in 1953 had three children. They lived a pleasant life together in Zurich until Kurt retired and the family moved to Geneva. Kurt died in 1974 in the presence of his loving family.")
	 

END.KurtDADDA = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(10)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_finalekurtwarp2)
	SGroup_WarpToMarker(Otto, mkr_finaleottowarp2)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto2)
	Cmd_Move(Otto, mkr_finaleottoto2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText85)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText86)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText87)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText88)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_finalecamera2)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto3)
	Cmd_Move(Otto, mkr_finaleottoto3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText149)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText150)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText151)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText152)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText153)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText154)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText155)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText156)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText157)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText158)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()

end

        EndText159 = Util_CreateLocString("You have unlocked the ending: ALL OR NOTHING")
		EndText160 = Util_CreateLocString("With the leader of Task Force Eva dead, nobody noticed Kurt and Otto as they trekked across the snowy woods alongside the train tracks. They marched for another three weeks until they crossed the border to arrive at the Swiss city of Basel.")
		EndText161 = Util_CreateLocString("The pair did odd jobs in Basel and paid for a coach driver to take them to Zurich. After another week on the road they were finally dropped off on the outskirts of the city.")
		EndText162 = Util_CreateLocString("Otto immediately set out to find his family. Reuniting with them a few days later.")
		EndText163 = Util_CreateLocString("It took Otto some time to settle in Zurich and he soon realized that honest work was very hard to come by and nobody would hire him. Yet Otto would not contemplate his family going hungry, hence he began to steal food and necessities as needed.")
		EndText164 = Util_CreateLocString("As time went by Otto became bolder and more experienced at his craft. He would eventually lead his own gang of thieves in professional heists well into his older years. Otto died during a failed robbery in 1968, his name cursed by all except his family.")
		EndText165 = Util_CreateLocString("Kurt stayed with Otto and his family for two months before leaving, as he could not afford his share of expenses but also couldn't bear to stay and make Otto's family finances more difficult.")
		EndText166 = Util_CreateLocString("Kurt wandered the streets sleeping rough where convenient. It was during this time he took up a habit of gambling for his daily food and necessities. As it turned out, Kurt was quite lucky, and his winnings would sustain him for most days.")
		EndText167 = Util_CreateLocString("However, this soon became an addiction. Kurt found himself spending most of his time gambling either in the back alleys or gambling houses. He placed ever greater bets, sometimes even bets he couldn't afford to lose.")
		EndText168 = Util_CreateLocString("One day in 1954, Kurt placed a bet too large for him to handle. His luck ran out and he owed a sum he was unable to pay. Kurt attempted to flee the scene but was caught and severely beaten. Kurt died that same evening in a dark alley, alone and forgotten.")
	 

END.KurtDDDDA = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(10)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_finalekurtwarp2)
	SGroup_WarpToMarker(Otto, mkr_finaleottowarp2)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto2)
	Cmd_Move(Otto, mkr_finaleottoto2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText85)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText86)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText87)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText88)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_finalecamera2)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto3)
	Cmd_Move(Otto, mkr_finaleottoto3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText159)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText160)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText161)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText162)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText163)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText164)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText165)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText166)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText167)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText168)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()

end

        EndText169 = Util_CreateLocString("We did it Otto! We did it! With the train here and the commander dead, I am sure there will not be further issues getting to Switzerland by train!")
		EndText170 = Util_CreateLocString("Yes... You are probably right... But... Ah... We should not... Have waded into that river... I am... Freezing... For a long time...")
		EndText171 = Util_CreateLocString("Otto? No, no, no! Not here Otto... Not when we are so close!!!")
		EndText172 = Util_CreateLocString("I am afraid... I am so tired... Please Kurt... My family... Take care...Of them...")
		EndText173 = Util_CreateLocString("I am sorry Otto... Rest in peace...")
		
        EndText174 = Util_CreateLocString("You have unlocked the ending: HEART OF GOLD")
		EndText175 = Util_CreateLocString("Now alone by himself with a train full of gold, Kurt navigated the train over three days to reach the outskirts of Zurich on 3 March 1945, where he hid its golden cargo.")
		EndText176 = Util_CreateLocString("In a failed desperate attempt to prevent the gold escaping into the fog of war, the American airforce bombed presumed rail targets in the Swiss cities of Basel and Zurich, only one day after Kurt's arrival. These bombings would later be explained as accidental.")
		EndText177 = Util_CreateLocString("Over the next two months, Kurt bought a house in Zurich and decided to search for Otto's family. It was only proper that he at least gave them the news of his death.")
		EndText178 = Util_CreateLocString("Upon finding Otto's family and breaking the sad news. Otto's wife Marta could not be consoled, and Kurt stayed with his family for a month to help Marta fully recover.")
		EndText179 = Util_CreateLocString("Kurt offered half of the gold to Marta but was turned down, instead he persuaded Marta to agree to a substantial monthly stipend for the family, for the sake of her children.")
		EndText180 = Util_CreateLocString("In the following decade, Kurt used his wealth to buy properties across Switzerland and connections which provided him great influence in Swiss society. He eventually realized his wealth can be used to resolve complex situations at a national level.")
		EndText181 = Util_CreateLocString("Kurt would offer up money to Swiss families accidentally bombed by the Allies, or pay sums to West German families left homeless by the war. Any large national crisis that can be resolved with money, Kurt would try his hand at the solution.")
		EndText182 = Util_CreateLocString("Rather surprisingly, nobody would ever question him on where he obtained such wealth. Kurt mused that when everyone is happy, nobody questions how it happened. He would spend another decade of his life helping to fix problems.")
		EndText183 = Util_CreateLocString("Kurt married a noblewoman in 1965 but had no children. The couple spent the rest of their lives helping people across West Germany and Switzerland recover from the war. Kurt died by his wife's side in 1981, remembered as a benevolent savior by most who knew him.")
	 

END.KurtAAAAD = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(15)
	SGroup_SetInvulnerable(Kurt, true)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_finalekurttrainwarp)
	SGroup_WarpToMarker(Otto, mkr_finaleottotrainwarp)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_endkurttrainto)
	Cmd_Move(Otto, mkr_endottotrainto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText169)
	CTRL.WAIT()
	Player_SetHeatLossRate(player1, 1000)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText170)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurttrainto)
	Camera_MoveTo(mkr_finaleendcamera)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText171)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText172)
	CTRL.WAIT()
	SGroup_Kill(Otto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText173)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_traindoor)
	CTRL.WAIT()
	CTRL.Event_Delay(2)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_lastcamera)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(TrainThree, mkr_trainthreeto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText174)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText175)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText176)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText177)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText178)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText179)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText180)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText181)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText182)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText183)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()

end

        EndText184 = Util_CreateLocString("You have unlocked the ending: MEDICAL FORTUNE")
		EndText185 = Util_CreateLocString("Now alone by himself with a train full of gold, Kurt navigated the train over three days to reach the outskirts of Zurich on 3 March 1945, where he hid its golden cargo.")
		EndText186 = Util_CreateLocString("In a failed desperate attempt to prevent the gold escaping into the fog of war, the American airforce bombed presumed rail targets in the Swiss cities of Basel and Zurich, only one day after Kurt's arrival. These bombings would later be explained as accidental.")
		EndText187 = Util_CreateLocString("Over the next two months, Kurt bought a house in Zurich and decided to search for Otto's family. It was only proper that he at least gave them the news of his death.")
		EndText188 = Util_CreateLocString("Upon finding Otto's family and breaking the sad news. Otto's wife Marta could not be consoled, and Kurt stayed with his family for a month to help Marta fully recover.")
		EndText189 = Util_CreateLocString("Kurt offered half of the gold to Marta but was turned down, instead he persuaded Marta to agree to a substantial monthly stipend for the family, for the sake of her children.")
		EndText190 = Util_CreateLocString("Kurt would stay in Zurich until 1949, training as a medical surgeon at a medical foundation for past soldiers. Kurt learned quickly, and soon became a practicing surgeon in Zurich, well known to much the city.")
		EndText191 = Util_CreateLocString("In 1956 Kurt decided to return to West Germany to search for his parents. Upon finding only ruins and graves in his home town, Kurt moved to Frankfurt and set up a medical clinic in the north-west of the city. The clinic treated people from all walks of life.")
		EndText192 = Util_CreateLocString("Using his tremendous wealth, Kurt hired the many more doctors and nurses and his humble clinic transformed into a busy hospital. Today the hospital continues to be a center for medical excellence in Frankfurt.")
		EndText193 = Util_CreateLocString("Kurt married a nurse of the hospital in 1957 and had two children. Kurt died in 1967 after contracting the Marburg virus disease from a hospital patient. His funeral was attended by his family, friends and distinguished members of the medical profession.")
	 

END.KurtDAAAD = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(15)
	SGroup_SetInvulnerable(Kurt, true)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_finalekurttrainwarp)
	SGroup_WarpToMarker(Otto, mkr_finaleottotrainwarp)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_endkurttrainto)
	Cmd_Move(Otto, mkr_endottotrainto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText169)
	CTRL.WAIT()
	Player_SetHeatLossRate(player1, 1000)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText170)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurttrainto)
	Camera_MoveTo(mkr_finaleendcamera)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText171)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText172)
	CTRL.WAIT()
	SGroup_Kill(Otto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText173)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_traindoor)
	CTRL.WAIT()
	CTRL.Event_Delay(2)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_lastcamera)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(TrainThree, mkr_trainthreeto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText184)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText185)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText186)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText187)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText188)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText189)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText190)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText191)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText192)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText193)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()

end

        EndText194 = Util_CreateLocString("You have unlocked the ending: A NEW EMPIRE")
		EndText195 = Util_CreateLocString("Now alone by himself with a train full of gold, Kurt navigated the train over three days to reach the outskirts of Zurich on 3 March 1945, where he hid its golden cargo.")
		EndText196 = Util_CreateLocString("In a failed desperate attempt to prevent the gold escaping into the fog of war, the American airforce bombed presumed rail targets in the Swiss cities of Basel and Zurich, only one day after Kurt's arrival. These bombings would later be explained as accidental.")
		EndText197 = Util_CreateLocString("Over the next two months, Kurt bought a house in Zurich and decided to search for Otto's family. It was only proper that he at least gave them the news of his death.")
		EndText198 = Util_CreateLocString("Upon finding Otto's family and breaking the sad news. Otto's wife Marta could not be consoled, and Kurt stayed with his family for a month to help Marta fully recover.")
		EndText199 = Util_CreateLocString("Kurt offered half of the gold to Marta but was turned down, instead he persuaded Marta to agree to a substantial monthly stipend for the family, for the sake of her children.")
		EndText200 = Util_CreateLocString("Kurt would stay in Zurich for a year pondering how to use his tremendous wealth. Eventually Kurt moved to Liechtenstein in 1946 and mingled with the elite of society while enjoying the finest life has to offer there.")
		EndText201 = Util_CreateLocString("During his time in Liechtenstein, Kurt discovered the intricacies of financial investment. In 1950, Kurt leveraged his vast wealth to travel to the United States, where he married in 1953 to a fellow immigrant from West Germany. They had three children together.")
		EndText202 = Util_CreateLocString("It took Kurt three years to learn English to a competent degree. Once he had done so, Kurt began one of the greatest investment sprees ever seen. Hundreds of billions were invested into companies across the globe from Kurt's US registered shell company.")
		EndText203 = Util_CreateLocString("Kurt's investment eye was legendary, with return on investment frequently surpassing ten percent or more per annum and few losses. Today Kurt's descendants still control business empires through a Cayman Islands registered company. Kurt died in 1980, surrounded by his family.")
	 

END.KurtADAAD = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(15)
	SGroup_SetInvulnerable(Kurt, true)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_finalekurttrainwarp)
	SGroup_WarpToMarker(Otto, mkr_finaleottotrainwarp)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_endkurttrainto)
	Cmd_Move(Otto, mkr_endottotrainto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText169)
	CTRL.WAIT()
	Player_SetHeatLossRate(player1, 1000)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText170)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurttrainto)
	Camera_MoveTo(mkr_finaleendcamera)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText171)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText172)
	CTRL.WAIT()
	SGroup_Kill(Otto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText173)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_traindoor)
	CTRL.WAIT()
	CTRL.Event_Delay(2)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_lastcamera)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(TrainThree, mkr_trainthreeto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText194)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText195)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText196)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText197)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText198)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText199)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText200)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText201)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText202)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText203)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()

end

        EndText204 = Util_CreateLocString("You have unlocked the ending: PARTNERS IN LAND")
		EndText205 = Util_CreateLocString("Now alone by himself with a train full of gold, Kurt navigated the train over three days to reach the outskirts of Zurich on 3 March 1945, where he hid its golden cargo.")
		EndText216 = Util_CreateLocString("In a failed desperate attempt to prevent the gold escaping into the fog of war, the American airforce bombed presumed rail targets in the Swiss cities of Basel and Zurich, only one day after Kurt's arrival. These bombings would later be explained as accidental.")
		EndText217 = Util_CreateLocString("Over the next two months, Kurt bought a house in Zurich and decided to search for Otto's family. It was only proper that he at least gave them the news of his death.")
		EndText218 = Util_CreateLocString("Upon finding Otto's family and breaking the sad news. Otto's wife Marta could not be consoled, and Kurt stayed with his family to help Marta fully recover.")
		EndText219 = Util_CreateLocString("Kurt offered half of the gold to Marta but was turned down. However Kurt would have none of it, and insisted he stay to financially support Marta and her children.")
		EndText220 = Util_CreateLocString("Over the next five years Kurt focused most of his time on the needs of Marta and her children. The two grew close and eventually married in 1951. Kurt treated Marta and the children well and began to plan for the next stage of their life with their massive wealth.")
		EndText221 = Util_CreateLocString("Marta was well connected with the local realtors, and had a profound knowledge of valuable land across Switzerland. With the family's newfound wealth, purchasing these lands was now suddenly possible. Kurt and Marta promptly purchased great plots of valuable land across Switzerland.")
		EndText222 = Util_CreateLocString("By 1965, the family expanded their land portfolio to Liechtenstein, Italy, France, Spain, Portugal, the United Kingdom, the Philippines and the United States. The family also moved to Manila in the Philippines and set up a Christian boarding school for the local population.")
		EndText223 = Util_CreateLocString("The lands the family purchased were all used for scientific or conservation purposes. Today some of these lands continue to be privately held by the Kurt and Marta Foundation. Kurt died in Marta's presence in 1978, after a sudden short illness while on a trip in South Africa.")

END.KurtAADAD = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(15)
	SGroup_SetInvulnerable(Kurt, true)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_finalekurttrainwarp)
	SGroup_WarpToMarker(Otto, mkr_finaleottotrainwarp)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_endkurttrainto)
	Cmd_Move(Otto, mkr_endottotrainto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText169)
	CTRL.WAIT()
	Player_SetHeatLossRate(player1, 1000)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText170)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurttrainto)
	Camera_MoveTo(mkr_finaleendcamera)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText171)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText172)
	CTRL.WAIT()
	SGroup_Kill(Otto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText173)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_traindoor)
	CTRL.WAIT()
	CTRL.Event_Delay(2)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_lastcamera)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(TrainThree, mkr_trainthreeto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText204)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText205)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText206)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText207)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText208)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText209)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText210)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText211)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText212)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText213)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()

end

        EndText214 = Util_CreateLocString("You have unlocked the ending: COSMIC MYSTERIES")
		EndText215 = Util_CreateLocString("Now alone by himself with a train full of gold, Kurt navigated the train over three days to reach the outskirts of Zurich on 3 March 1945, where he hid its golden cargo.")
		EndText216 = Util_CreateLocString("In a failed desperate attempt to prevent the gold escaping into the fog of war, the American airforce bombed presumed rail targets in the Swiss cities of Basel and Zurich, only one day after Kurt's arrival. These bombings would later be explained as accidental.")
		EndText217 = Util_CreateLocString("Over the next two months, Kurt bought a house in Zurich and decided to search for Otto's family. It was only proper that he at least gave them the news of his death.")
		EndText218 = Util_CreateLocString("Upon finding Otto's family and breaking the sad news. Otto's wife Marta could not be consoled, and Kurt stayed with his family for a month to help Marta fully recover.")
		EndText219 = Util_CreateLocString("Kurt offered half of the gold to Marta but was turned down, instead he persuaded Marta to agree to a substantial monthly stipend for the family, for the sake of her children.")
		EndText220 = Util_CreateLocString("Kurt would leave Zurich for Liechtenstein in 1948 and took up a great interest in astrology. Kurt was fascinated by the movements of the stars and began to learn related subjects in mathematics and physics to better understand his interest.")
		EndText221 = Util_CreateLocString("Using his tremendous wealth, Kurt arranged to have an observatory constructed near Zurich and another near the Swiss town of St-Luc. Kurt would travel to these observatories often, and bring his findings to others in the scientific community.")
		EndText222 = Util_CreateLocString("In 1958, Kurt openly declared his intention to fund any astrology related projects of note as a means to support the badly underfunded astrology field. Offers were quick to arrive and today many observatories and research papers funded by Kurt remains available.")
		EndText223 = Util_CreateLocString("Thanks for his funding, the field of astrology made more advancements in the next decade than the previous three decades combined. Kurt never married, so he left his fortune to the scientific community when he died in 1983, highly respected by all his peers.")
	 

END.KurtADDAD = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(15)
	SGroup_SetInvulnerable(Kurt, true)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_finalekurttrainwarp)
	SGroup_WarpToMarker(Otto, mkr_finaleottotrainwarp)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_endkurttrainto)
	Cmd_Move(Otto, mkr_endottotrainto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText169)
	CTRL.WAIT()
	Player_SetHeatLossRate(player1, 1000)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText170)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurttrainto)
	Camera_MoveTo(mkr_finaleendcamera)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText171)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText172)
	CTRL.WAIT()
	SGroup_Kill(Otto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText173)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_traindoor)
	CTRL.WAIT()
	CTRL.Event_Delay(2)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_lastcamera)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(TrainThree, mkr_trainthreeto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText214)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText215)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText216)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText217)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText218)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText219)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText220)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText221)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText222)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText223)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()

end

        EndText224 = Util_CreateLocString("You have unlocked the ending: CIRCLE OF POWER")
		EndText225 = Util_CreateLocString("Now alone by himself with a train full of gold, Kurt navigated the train over three days to reach the outskirts of Zurich on 3 March 1945, where he hid its golden cargo.")
		EndText226 = Util_CreateLocString("In a failed desperate attempt to prevent the gold escaping into the fog of war, the American airforce bombed presumed rail targets in the Swiss cities of Basel and Zurich, only one day after Kurt's arrival. These bombings would later be explained as accidental.")
		EndText227 = Util_CreateLocString("Over the next two months, Kurt bought a house in Zurich and decided to search for Otto's family. It was only proper that he at least gave them the news of his death.")
		EndText228 = Util_CreateLocString("Upon finding Otto's family and breaking the sad news. Otto's wife Marta could not be consoled, and Kurt stayed with his family for a month to help Marta fully recover.")
		EndText229 = Util_CreateLocString("Seeing Marta's distress, Kurt was determined to use his wealth for a worthy cause, to create and build a better future for all.")
		EndText230 = Util_CreateLocString("Kurt sought out influential figures, politicians, innovators, promising builders and creators who were capable of making his wish become reality. Slowly but surely Kurt built up a circle of powerful individuals, leveraging his own charm and wealth.")
		EndText231 = Util_CreateLocString("Kurt backed those he sought out with vast financial support, allowing them to dominate their fields of expertise. Construction, industrials, politics, nearly all who gained Kurt's favor flourished in their field. By 1955, Kurt's efforts to rebuild Europe has started to bear fruit.")
		EndText232 = Util_CreateLocString("Kurt's plans seemed to have come true. Unfortunately, he didn't foresee how those earliest in his circle would deal with competitors. Established members of the circle would decimate newcomers in all consuming efforts to become monopolies in their fields.")
		EndText233 = Util_CreateLocString("This reality allowed those party to the monopolies to help themselves and not others, and Kurt realized what was transpiring much too late to reverse it. Kurt's circle of power which was created to help Europe, was losing its top position to selfish monopoly owners.")
	    ExtraEndText2 = Util_CreateLocString("Corruption befell those who were touched by the gold's proceeds and soon financial aid had the opposite effect of what Kurt intended. Instead of progress and renovation, corruption and stagnation took its place, eventually impeding Europe's development.")
        ExtraEndText3 = Util_CreateLocString("Kurt died an ultimately disappointed man in 1980. Despite his best efforts, the selfishness of man could not be quelled for the greater good, such was humanity's flaw that perverted his legacy.")

END.KurtADDAD = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(15)
	SGroup_SetInvulnerable(Kurt, true)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_finalekurttrainwarp)
	SGroup_WarpToMarker(Otto, mkr_finaleottotrainwarp)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_endkurttrainto)
	Cmd_Move(Otto, mkr_endottotrainto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText169)
	CTRL.WAIT()
	Player_SetHeatLossRate(player1, 1000)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText170)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurttrainto)
	Camera_MoveTo(mkr_finaleendcamera)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText171)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText172)
	CTRL.WAIT()
	SGroup_Kill(Otto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText173)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_traindoor)
	CTRL.WAIT()
	CTRL.Event_Delay(2)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_lastcamera)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(TrainThree, mkr_trainthreeto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText224)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText225)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText226)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText227)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText228)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText229)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText230)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText231)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText232)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText233)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, ExtraEndText2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, ExtraEndText3)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()

end

        EndText234 = Util_CreateLocString("You have unlocked the ending: TITAN OF INDUSTRY")
		EndText235 = Util_CreateLocString("Now alone by himself with a train full of gold, Kurt navigated the train over three days to reach the outskirts of Zurich on 3 March 1945, where he hid its golden cargo.")
		EndText236 = Util_CreateLocString("In a failed desperate attempt to prevent the gold escaping into the fog of war, the American airforce bombed presumed rail targets in the Swiss cities of Basel and Zurich, only one day after Kurt's arrival. These bombings would later be explained as accidental.")
		EndText237 = Util_CreateLocString("Over the next two months, Kurt bought a house in Zurich and decided to search for Otto's family. It was only proper that he at least gave them the news of his death.")
		EndText238 = Util_CreateLocString("Upon finding Otto's family and breaking the sad news. Otto's wife Marta could not be consoled, and Kurt stayed with his family for a month to help Marta fully recover.")
		EndText239 = Util_CreateLocString("Kurt offered half of the gold to Marta but was turned down, instead he persuaded Marta to agree to a substantial monthly stipend for the family, for the sake of her children.")
		EndText240 = Util_CreateLocString("Kurt stayed in Zurich helping Marta and her children until he decided to return to West Germany to find his parents in 1949. Upon finding only ruins and graves in his home town, Kurt settled in Bonn and wed there a year later. Kurt would have two children with his wife.")
		EndText241 = Util_CreateLocString("One day in 1953, Kurt was approached by a man with a proposition. The man knew that Kurt had great wealth and suggested plans to build an automobile factory together. Kurt inspected the plans and was convinced of its good prospects.")
		EndText242 = Util_CreateLocString("Kurt would continue to fund huge industrial projects in the production and engineering fields until 1975, when he gave the reins of his industrial empire to his children. Today many of the factories funded by Kurt still stands tall and remain operational.")
		EndText243 = Util_CreateLocString("Kurt would be credited for rejuvenating West Germany's industrial capacity in the post-war period and is commonly referred to as a titan of West German industry. Kurt died as a highly respected man in 1982, surrounded by his family.")

END.KurtDADAD = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(15)
	SGroup_SetInvulnerable(Kurt, true)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_finalekurttrainwarp)
	SGroup_WarpToMarker(Otto, mkr_finaleottotrainwarp)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_endkurttrainto)
	Cmd_Move(Otto, mkr_endottotrainto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText169)
	CTRL.WAIT()
	Player_SetHeatLossRate(player1, 1000)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText170)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurttrainto)
	Camera_MoveTo(mkr_finaleendcamera)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText171)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText172)
	CTRL.WAIT()
	SGroup_Kill(Otto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText173)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_traindoor)
	CTRL.WAIT()
	CTRL.Event_Delay(2)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_lastcamera)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(TrainThree, mkr_trainthreeto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText234)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText235)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText236)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText237)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText238)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText239)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText240)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText241)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText242)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText243)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()

end

        EndText244 = Util_CreateLocString("You have unlocked the ending: SOUL FOREVER LOST")
		EndText245 = Util_CreateLocString("Now alone by himself with a train full of gold, Kurt navigated the train over three days to reach the outskirts of Zurich on 3 March 1945, where he hid its golden cargo.")
		EndText246 = Util_CreateLocString("In a failed desperate attempt to prevent the gold escaping into the fog of war, the American airforce bombed presumed rail targets in the Swiss cities of Basel and Zurich, only one day after Kurt's arrival. These bombings would later be explained as accidental.")
		EndText247 = Util_CreateLocString("Over the next two months, Kurt bought a house in Zurich and decided to search for Otto's family. It was only proper that he at least gave them the news of his death.")
		EndText248 = Util_CreateLocString("Upon finding Otto's family and breaking the sad news. Otto's wife Marta could not be consoled, and Kurt stayed with his family for a month to help Marta fully recover.")
		EndText249 = Util_CreateLocString("Kurt offered half of the gold to Marta but was turned down, instead he persuaded Marta to agree to a substantial monthly stipend for the family, for the sake of her children.")
		EndText250 = Util_CreateLocString("With Otto's family taken care of, Kurt bought a house in Zurich. The deaths of everyone in the group weighed heavily upon Kurt's mind as he struggled to come to terms with his survival day after day. His wealth did little to alleviate his survivor's guilt.")
		EndText251 = Util_CreateLocString("Kurt sought treatment from Swiss doctors but nobody was able to help him. He was continuously haunted by those he killed and those who died. Nightmares of his journey to Switzerland were a nightly occurrence and by 1955, Kurt had a mental breakdown.")
		EndText252 = Util_CreateLocString("Kurt could not find any hobby or occupation that could distract him from his own torture. Wealth could not buy him peace and the only respite was when he was drunk on alcohol.")
		EndText253 = Util_CreateLocString("The horrors of war never left Kurt and in 1962 he died after a particularly heavy drinking session. Kurt never made a will and so his fortune was irretrievable by all except Otto's family's monthly stipend, from which their descendants still benefit to this day.")

END.KurtDDDAD = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(15)
	SGroup_SetInvulnerable(Kurt, true)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_finalekurttrainwarp)
	SGroup_WarpToMarker(Otto, mkr_finaleottotrainwarp)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_endkurttrainto)
	Cmd_Move(Otto, mkr_endottotrainto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText169)
	CTRL.WAIT()
	Player_SetHeatLossRate(player1, 1000)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText170)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurttrainto)
	Camera_MoveTo(mkr_finaleendcamera)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText171)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText172)
	CTRL.WAIT()
	SGroup_Kill(Otto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText173)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_traindoor)
	CTRL.WAIT()
	CTRL.Event_Delay(2)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_lastcamera)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(TrainThree, mkr_trainthreeto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText244)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText245)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText246)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText247)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText248)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText249)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText250)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText251)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText252)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText253)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()

end

        EndText244 = Util_CreateLocString("We did it Otto! I think we can just march along the train tracks and eventually we will be in Switzerland!")
		EndText245 = Util_CreateLocString("Ah... You are probably right... Ah... We should not have... Waded into that river... I am... Freezing... For a long time...")
		EndText246 = Util_CreateLocString("No no no Otto! We have made this so far! We are so close!")
		EndText247 = Util_CreateLocString("I am... So tired... I am afraid... This is it... Please Kurt... My family... Take care...")
		EndText248 = Util_CreateLocString("I am sorry Otto... Rest in peace...")
		
		
        EndText249 = Util_CreateLocString("You have unlocked the ending: WELL WEATHERED FUTURE")
		EndText250 = Util_CreateLocString("Kurt now faced the trek to Switzerland alone. The plan would remain unchanged despite Otto's death. Otto's family deserved to at least be informed of his passing.")
		EndText251 = Util_CreateLocString("It would take Kurt three weeks to arrive at the Swiss city of Basel. He would try to do odd jobs around the city until he earned enough to pay for a horse and cart trip to Zurich.")
		EndText252 = Util_CreateLocString("Kurt spent two weeks searching for Otto's family in Zurich. Upon finally finding the family and breaking the sad news, Otto's wife Marta could not be consoled, and Kurt stayed with the family for a month to help Marta fully recover.")
		EndText253 = Util_CreateLocString("Kurt would take a job at a factory in Zurich making coats for the average consumer. Kurt noted that the factory would consistently receive complaints regarding the quality of its coats. Whatever he earned in pay would be sent to support Otto's family.")
		EndText254 = Util_CreateLocString("For four years Kurt learned the art of coat making. He would tinker with potential ideas for different designs and materials until in 1949 he had invented a coat capable of comfortably withstanding wind, snow and rain for the wearer.")
		EndText255 = Util_CreateLocString("In 1951 after some final adjustments, Kurt patented the idea for what he called an 'All-Weather' coat. The concept was not new, however Kurt's coat proved extremely effective against the elements and was highly popular amongst the population.")
		EndText256 = Util_CreateLocString("Kurt attracted the necessary funding for his own factory producing these coats with ease. By 1955, Kurt would be producing and selling millions of coats per year, earning him a considerable fortune.")
		EndText257 = Util_CreateLocString("After he became wealthy, Kurt continued to support Marta and her children. Kurt married a noblewoman in 1956 and had a child with her, and would take his own family on trips across Western Europe over the next two decades.")
		EndText258 = Util_CreateLocString("Kurt's coat patent continues to be used by producers across the globe today, although his descendants sold their share of his factory and patent. Kurt died a content man in 1978 surrounded by his family, having led a good life through his own efforts.")

END.KurtAAADD = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(10)
	SGroup_SetInvulnerable(Kurt, true)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_finalekurtwarp2)
	SGroup_WarpToMarker(Otto, mkr_finaleottowarp2)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto2)
	Cmd_Move(Otto, mkr_finaleottoto2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText244)
	CTRL.WAIT()
	Player_SetHeatLossRate(player1, 1000)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText245)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtottoto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText246)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText247)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText248)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_finalekurtcamera)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText249)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText250)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText251)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText252)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText253)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText254)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText255)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText256)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText257)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText258)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()
	
end

        EndText259 = Util_CreateLocString("You have unlocked the ending: HIGH SEAS CALLING")
		EndText260 = Util_CreateLocString("Kurt now faced the trek to Switzerland alone. The plan would remain unchanged despite Otto's death. Otto's family deserved to at least be informed of his passing.")
		EndText261 = Util_CreateLocString("It would take Kurt three weeks to arrive at the Swiss city of Basel. He would try to do odd jobs around the city until he earned enough to pay for a horse and cart trip to Zurich.")
		EndText262 = Util_CreateLocString("Kurt spent two weeks searching for Otto's family in Zurich. Upon finally finding the family and breaking the sad news, Otto's wife Marta could not be consoled, and Kurt stayed with the family for a month to help Marta fully recover.")
		EndText263 = Util_CreateLocString("Kurt would wander around Zurich doing whatever jobs were available until 1948. Having no luck securing a long-term job in Switzerland, Kurt returned to West Germany to search for his parents.")
		EndText264 = Util_CreateLocString("Upon finding only ruins and graves, Kurt travelled to Hamburg where he found a position at the local port authority. After two years of employment as a manual laborer, Kurt began to muse about the possibility of sailing the high seas.")
		EndText265 = Util_CreateLocString("In 1952, Kurt applied for a position as a deck hand on a merchant ship docked in Hamburg. The captain took a liking to Kurt and agreed to have him travel aboard and help.")
		EndText266 = Util_CreateLocString("This arrangement lasted for five years as Kurt sailed the seas and went around the world, seeing new places he had never heard of before. Sailing the seas has opened the world to him, and he now wanted to see it all.")
		EndText267 = Util_CreateLocString("Kurt served on the ship dutifully until he met his wife in 1957 in the United States. Kurt finally settled down but his itch for adventure never faded. In 1965 Kurt bought his own ship and together with his wife went sailing around the world.")
		EndText268 = Util_CreateLocString("Kurt and his wife traversed across every continent on his ship and experienced the world to its fullest. Kurt died in 1975 in the presence of his wife, happy that he managed to see the world to his heart's content.")

END.KurtDAADD = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(10)
	SGroup_SetInvulnerable(Kurt, true)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_finalekurtwarp2)
	SGroup_WarpToMarker(Otto, mkr_finaleottowarp2)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto2)
	Cmd_Move(Otto, mkr_finaleottoto2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText244)
	CTRL.WAIT()
	Player_SetHeatLossRate(player1, 1000)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText245)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtottoto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText246)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText247)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText248)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_finalekurtcamera)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText259)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText260)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText261)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText262)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText263)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText264)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText265)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText266)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText267)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText268)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()
	
end

        EndText269 = Util_CreateLocString("You have unlocked the ending: LIVING BY MAIL")
		EndText270 = Util_CreateLocString("Kurt now faced the trek to Switzerland alone. The plan would remain unchanged despite Otto's death. Otto's family deserved to at least be informed of his passing.")
		EndText271 = Util_CreateLocString("It would take Kurt three weeks to arrive at the Swiss city of Basel. He would try to do odd jobs around the city until he earned enough to pay for a horse and cart trip to Zurich.")
		EndText272 = Util_CreateLocString("Kurt spent two weeks searching for Otto's family in Zurich. Upon finally finding the family and breaking the sad news, Otto's wife Marta could not be consoled, and Kurt stayed with the family for a month to help Marta fully recover.")
		EndText273 = Util_CreateLocString("Kurt eventually found a job in Zurich at the city's general post office. He started as a humble clerk, accepting people's mail and sending them where they needed to go.")
		EndText274 = Util_CreateLocString("Kurt was vocal about ways to improve the service, and the postmaster of the office took notice. He gave Kurt a senior role directing daily mail services, which Kurt performed to near perfection.")
		EndText275 = Util_CreateLocString("When the old postmaster retired in 1957, Kurt was the natural successor to his role. Kurt proved once again he was well capable of handling the responsibility, and the mail flowed smoothly like a river.")
		EndText276 = Util_CreateLocString("In 1964, Kurt was approached by a representative from Italy, who was referred to Kurt by the general postmaster of Switzerland. The man offered Kurt the opportunity to perform as a consultant to improve Italy's mail services, to which Kurt accepted.")
		EndText277 = Util_CreateLocString("For the next decade, Kurt travelled across Western Europe, assisting countries such as Italy, West Germany, Spain and Ireland to improve their mail networks. It was not a glamorous role, but Kurt was quite happy to do it.")
		EndText278 = Util_CreateLocString("Kurt married a widow in 1968, and spent a few peaceful years with her. Kurt died at home beside his wife in 1971, having lived a humble but content life.")

END.KurtADADD = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(10)
	SGroup_SetInvulnerable(Kurt, true)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_finalekurtwarp2)
	SGroup_WarpToMarker(Otto, mkr_finaleottowarp2)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto2)
	Cmd_Move(Otto, mkr_finaleottoto2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText244)
	CTRL.WAIT()
	Player_SetHeatLossRate(player1, 1000)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText245)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtottoto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText246)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText247)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText248)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_finalekurtcamera)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText269)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText270)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText271)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText272)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText273)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText274)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText275)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText276)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText277)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText278)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()
	
end

        EndText279 = Util_CreateLocString("You have unlocked the ending: OLD HABITS DIE HARD")
		EndText280 = Util_CreateLocString("Kurt now faced the trek to Switzerland alone. The plan would remain unchanged despite Otto's death. Otto's family deserved to at least be informed of his passing.")
		EndText281 = Util_CreateLocString("It would take Kurt three weeks to arrive at the Swiss city of Basel. He would try to do odd jobs around the city until he earned enough to pay for a horse and cart trip to Zurich.")
		EndText282 = Util_CreateLocString("Kurt spent two weeks searching for Otto's family in Zurich. Upon finally finding the family and breaking the sad news, Otto's wife Marta could not be consoled, and Kurt stayed with the family for a month to help Marta fully recover.")
		EndText283 = Util_CreateLocString("For the next four years, Kurt wandered around Zurich working whatever jobs he could find. He struggled to secure a long-term position with any employer and did not have the money or time to learn new skills for a professional trade.")
		EndText284 = Util_CreateLocString("Unable to endure the aimlessness any longer, Kurt travelled back to West Germany in 1950 to search for his parents. However, upon finding only ruins and graves, Kurt moved to Bonn where he re-enlisted in the new Bundeswehr, after exhausting all other options.")
		EndText285 = Util_CreateLocString("Kurt naturally kept his previous desertion a secret, although perhaps thanks to his experiences journeying to Switzerland, Kurt's skill in combat was unparalleled and soon caught the notice of senior officers.")
		EndText286 = Util_CreateLocString("Over the next two decades, Kurt excelled in his military career and was eventually promoted to command his own division. Kurt would never let anyone know that his command abilities were learnt during his time deserting.")
		EndText287 = Util_CreateLocString("Kurt married a school teacher in 1958 and had three children with her. Their married life was tumultuous and Kurt would frequently leave home and not return for months at a time, much to the chagrin of his wife and children.")
		EndText288 = Util_CreateLocString("Kurt commanded the respect of his men in the barracks, but not his own family at home. As such, perhaps it was expected that when Kurt died in 1979, only his military peers attended his funeral, with no person present from his loveless marriage.")

END.KurtAADDD = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(10)
	SGroup_SetInvulnerable(Kurt, true)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_finalekurtwarp2)
	SGroup_WarpToMarker(Otto, mkr_finaleottowarp2)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto2)
	Cmd_Move(Otto, mkr_finaleottoto2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText244)
	CTRL.WAIT()
	Player_SetHeatLossRate(player1, 1000)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText245)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtottoto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText246)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText247)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText248)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_finalekurtcamera)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText279)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText280)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText281)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText282)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText283)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText284)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText285)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText286)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText287)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText288)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()
	
end

        EndText289 = Util_CreateLocString("You have unlocked the ending: LIES OF RENOWN")
		EndText290 = Util_CreateLocString("Kurt now faced the trek to Switzerland alone. The plan would remain unchanged despite Otto's death. Otto's family deserved to at least be informed of his passing.")
		EndText291 = Util_CreateLocString("It would take Kurt three weeks to arrive at the Swiss city of Basel. He would try to do odd jobs around the city until he earned enough to pay for a horse and cart trip to Zurich.")
		EndText292 = Util_CreateLocString("Kurt spent two weeks searching for Otto's family in Zurich. Upon finally finding the family and breaking the sad news, Otto's wife Marta could not be consoled, and Kurt stayed with the family for a month to help Marta fully recover.")
		EndText293 = Util_CreateLocString("Kurt soon found a job cleaning windows in Zurich. The pay was meager and it was long, hard work. Kurt resented his situation greatly.")
		EndText294 = Util_CreateLocString("A year later while cleaning the windows of a wealthy family, a man rushed towards Kurt and handed him a large sum of money and thanked him for looking after the house on short notice. The man seemed to have been expecting someone else.")
		EndText295 = Util_CreateLocString("Kurt pondered what to do with the money, whether he should keep it or give it to its rightful recipient. In the end, Kurt kept the money and left Zurich in haste. This would become the start of his long career as a con artist.")
		EndText296 = Util_CreateLocString("Over the next two decades, Kurt lied and cheated his way through life. Whether it be selling miracle tonics or promising non-existent services, Kurt had done it all. He would receive his payment from his victim, then immediately leave the city.")
		EndText297 = Util_CreateLocString("Kurt's career took him through Switzerland, West Germany, Belgium, France and Spain. Where ever Kurt went, angry victims would follow in his wake. His notoriety would be such that by 1969, multiple national crime agencies would have warrants for his arrest.")
		EndText298 = Util_CreateLocString("Kurt earned a small fortune from his talents and in 1970, he finally decided to quit and retire into obscurity. Kurt never married and died in 1974, wanted and hated by the general public.")

END.KurtADDDD = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(10)
	SGroup_SetInvulnerable(Kurt, true)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_finalekurtwarp2)
	SGroup_WarpToMarker(Otto, mkr_finaleottowarp2)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto2)
	Cmd_Move(Otto, mkr_finaleottoto2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText244)
	CTRL.WAIT()
	Player_SetHeatLossRate(player1, 1000)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText245)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtottoto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText246)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText247)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText248)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_finalekurtcamera)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText289)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText290)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText291)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText292)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText293)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText294)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText295)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText296)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText297)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText298)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()
	
end

        EndText299 = Util_CreateLocString("You have unlocked the ending: DRINKS AND BANTER")
		EndText300 = Util_CreateLocString("Kurt now faced the trek to Switzerland alone. The plan would remain unchanged despite Otto's death. Otto's family deserved to at least be informed of his passing.")
		EndText301 = Util_CreateLocString("It would take Kurt three weeks to arrive at the Swiss city of Basel. He would try to do odd jobs around the city until he earned enough to pay for a horse and cart trip to Zurich.")
		EndText302 = Util_CreateLocString("Kurt spent two weeks searching for Otto's family in Zurich. Upon finally finding the family and breaking the sad news, Otto's wife Marta could not be consoled, and Kurt stayed with the family for a month to help Marta fully recover.")
		EndText303 = Util_CreateLocString("Kurt did whatever jobs he could find for a year but eventually he took a liking to a role as a barman at the local inn. The work was not too stressful and the customers were quite friendly.")
		EndText304 = Util_CreateLocString("Every day would be the same routine, clean the bar, serve the drinks, talk to the customers, clean again and then close the bar. For most people such work may have been quite dull, but Kurt craved dullness, especially after his experiences.")
		EndText305 = Util_CreateLocString("The pay wasn't stellar, but Kurt did not mind. He shared an apartment with two others and eventually grew quite close to them. On most days they would wine and dine after closing hour and have a jolly good time.")
		EndText306 = Util_CreateLocString("Kurt met his wife through the bar too. His wife, full of charm and beauty, struck up a conversation with Kurt, and the rest is history. Kurt and his wife would have two children together and live a simple life on the outskirts of Zurich.")
		EndText307 = Util_CreateLocString("In 1964, Kurt moved his family to Bern and set up his own inn, complete with a large bar. Business was good and the family ran it successfully. Even today, Kurt's family descendants proudly run the Bachmann Bern Inn.")
		EndText308 = Util_CreateLocString("Kurt died in 1977 surrounded by his family and friends, content that despite his fairly simple life, he managed to still enjoy it on his own terms.")

END.KurtDDADD = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(10)
	SGroup_SetInvulnerable(Kurt, true)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_finalekurtwarp2)
	SGroup_WarpToMarker(Otto, mkr_finaleottowarp2)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto2)
	Cmd_Move(Otto, mkr_finaleottoto2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText244)
	CTRL.WAIT()
	Player_SetHeatLossRate(player1, 1000)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText245)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtottoto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText246)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText247)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText248)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_finalekurtcamera)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText299)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText300)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText301)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText302)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText303)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText304)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText305)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText306)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText307)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText308)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()
	
end

        EndText309 = Util_CreateLocString("You have unlocked the ending: THE ENDLESS STRUGGLE")
		EndText310 = Util_CreateLocString("Kurt now faced the trek to Switzerland alone. The plan would remain unchanged despite Otto's death. Otto's family deserved to at least be informed of his passing.")
		EndText311 = Util_CreateLocString("It would take Kurt three weeks to arrive at the Swiss city of Basel. He would try to do odd jobs around the city until he earned enough to pay for a horse and cart trip to Zurich.")
		EndText312 = Util_CreateLocString("Kurt spent two weeks searching for Otto's family in Zurich. Upon finally finding the family and breaking the sad news, Otto's wife Marta could not be consoled, and Kurt stayed with the family for a month to help Marta fully recover.")
		EndText313 = Util_CreateLocString("Kurt would spend the next five years in Zurich working as an assistant in a bakery. The days were long and quite monotonous, Kurt had no love of his work and no love of his way of life.")
		EndText314 = Util_CreateLocString("As mad as it seemed, Kurt missed the exhilaration of war, the closeness of comrades and the mysteries of going to new places. Kurt realized that he was a born soldier, one who craved the discipline of the military and the thrill of combat.")
		EndText315 = Util_CreateLocString("Kurt travelled back to West Germany in 1950 in search of his parents. Upon finding only ruins and graves, Kurt re-joined the military, citing he was lost and surviving alone after getting cut off by the Soviets.")
		EndText316 = Util_CreateLocString("The military either didn't know about his situation or didn't care. In the end, Kurt was stationed in a outpost in Hamburg. A dull and boring five years followed, during which Kurt concluded he was not fit for the military, but for conflict.")
		EndText317 = Util_CreateLocString("Kurt left the military and travelled to Tunisia as part of a mercenary group in 1953. Kurt participated in various conflicts in Africa including in Tunisia, Algeria, Libya, Morocco and the Congo.")
		EndText318 = Util_CreateLocString("Kurt never married and died penniless in 1966 when fighting in an offensive against militia forces in the Congo. His story forever lost to the winds of time.")

END.KurtDADDD = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(10)
	SGroup_SetInvulnerable(Kurt, true)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_finalekurtwarp2)
	SGroup_WarpToMarker(Otto, mkr_finaleottowarp2)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto2)
	Cmd_Move(Otto, mkr_finaleottoto2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText244)
	CTRL.WAIT()
	Player_SetHeatLossRate(player1, 1000)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText245)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtottoto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText246)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText247)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText248)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_finalekurtcamera)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText309)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText310)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText311)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText312)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText313)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText314)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText315)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText316)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText317)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText318)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()
	
end

        EndText319 = Util_CreateLocString("You have unlocked the ending: EVIL MANIFEST")
		EndText320 = Util_CreateLocString("Kurt now faced the trek to Switzerland alone. The plan would remain unchanged despite Otto's death. Otto's family deserved to at least be informed of his passing.")
		EndText321 = Util_CreateLocString("It would take Kurt three weeks to arrive at the Swiss city of Basel. He would try to do odd jobs around the city until he earned enough to pay for a horse and cart trip to Zurich.")
		EndText322 = Util_CreateLocString("Kurt spent two weeks searching for Otto's family in Zurich. Upon finally finding the family and breaking the sad news, Otto's wife Marta could not be consoled, and Kurt stayed with the family for a month to help Marta fully recover.")
		EndText323 = Util_CreateLocString("For the next three years Kurt wandered the streets of Zurich searching for jobs without much success. Disillusioned and angry at the reality he found himself in, Kurt began to hate those more fortunate than him.")
		EndText324 = Util_CreateLocString("As time went by, Kurt became ever more frustrated at the fact there were no jobs for him to sustain a living. Eventually, Kurt turns to criminal activities. Pickpocketing and thievery to begin with, but by 1950, Kurt had made his first kill.")
		EndText325 = Util_CreateLocString("Kurt was extremely proficient at evading the authorities, he left almost nothing to trace for every crime he committed. As time went by, cold-blooded murder would become easier for him, and Kurt would fully embrace his murderous talents by 1952.")
		EndText326 = Util_CreateLocString("What followed in 1952 would be recorded in infamy as the largest murdering spree by the hands of a single man in all of Swiss history. Twenty six dead victims in a single year. Nobles, politicans, scholars, beggars, all were fair game for the hunt.")
		EndText327 = Util_CreateLocString("The press would describe Kurt as 'Evil Manifest', propelling his notoriety. Kurt had lost his mind to the act of killing and was now doing it for the thrill. Huge manhunts would be organized to capture him, all would fail.")
		EndText328 = Util_CreateLocString("However, in 1959 Kurt would try to murder a prominent Swiss general in his home, the general's son caught Kurt in the act and fired a lethal round, killing Kurt instantly. Kurt was buried in an unmarked grave near Basel, to be forgotten over time.")

END.KurtDDDDD = function()

	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(10)
	SGroup_SetInvulnerable(Kurt, true)
	SGroup_DestroyAllSquads(FortBodyguard)
	SGroup_DestroyAllSquads(TrenchMidOber)
	SGroup_DestroyAllSquads(TrenchLeftAssGren)
	SGroup_DestroyAllSquads(TrenchMidSturm)
	SGroup_DestroyAllSquads(WilhelmSturm)
	SGroup_DestroyAllSquads(WilhelmVolks)
	SGroup_DestroyAllSquads(WilhelmPioneer)
	SGroup_DestroyAllSquads(WilhelmStorm)
	SGroup_WarpToMarker(Kurt, mkr_finalekurtwarp2)
	SGroup_WarpToMarker(Otto, mkr_finaleottowarp2)
	SGroup_SetMoodMode(Kurt, MM_ForceCalm)
	SGroup_SetMoodMode(Otto, MM_ForceCalm)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto2)
	Cmd_Move(Otto, mkr_finaleottoto2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText244)
	CTRL.WAIT()
	Player_SetHeatLossRate(player1, 1000)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText245)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtottoto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText246)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, EndText247)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, EndText248)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(mkr_finalekurtcamera)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText319)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText320)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText321)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText322)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText323)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText324)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText325)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText326)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText327)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, EndText328)
	CTRL.WAIT()
	Game_EndSP(true)
	CTRL.WAIT()
	
end


---------------------------------Lose-------------------------------

function Lose()

        Rule_AddDelayedInterval(KurtLose, 1, 1)
		Rule_AddDelayedInterval(OttoLose, 1, 1)
		Rule_AddDelayedInterval(HansLose, 1, 1)
		Rule_AddDelayedInterval(TomislavLose, 1, 1)
        Rule_AddDelayedInterval(TigerDeathLose, 1, 1)

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

function OttoLose()

        local Control = SGroup_Count(Otto)
        if Control == 0 then
		        local Control2 = SGroup_Count(Wilhelm)
                if Control2 == 1 then
                        World_SetPlayerLose(player1)
                        World_SetPlayerLose(player2)
                        World_SetPlayerLose(player3)
                        World_SetPlayerLose(player4)
				end
        end
end

function HansLose()

        local Control1 = SGroup_Count(Fitzgerald)
        if Control1 > 0 then
                local Control2 = SGroup_Count(Hans)
                if Control2 == 0 then
                        World_SetPlayerLose(player1)
                        World_SetPlayerLose(player2)
                        World_SetPlayerLose(player3)
                        World_SetPlayerLose(player4)
				end
        end
end

function TomislavLose()

        local Control1 = SGroup_Count(SchneiderAreaUnits)
        if Control1 > 0 then
				local Control2 = SGroup_Count(Tomislav)
        		if Control2 == 0 then
                        World_SetPlayerLose(player1)
                        World_SetPlayerLose(player2)
                        World_SetPlayerLose(player3)
                        World_SetPlayerLose(player4)
				end
        end
end

function TigerDeathLose()

        local Control1 = SGroup_Count(SchneiderAreaUnits)
        if Control1 > 0 then
				local Control2 = SGroup_Count(Michael)
        		if Control2 == 0 then
                		World_SetPlayerLose(player1)
                		World_SetPlayerLose(player2)
                		World_SetPlayerLose(player3)
                		World_SetPlayerLose(player4)
				end
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
        Hans = "Icons_portraits_unit_west_german_honor_guard_w_portrait",
        Tomislav = "Icons_portraits_unit_west_german_volksgrenadier_w_portrait",
		Wilhelm = "Icons_portraits_dialogue_german_officer_w_portrait",
		
		Sturmpioneer = "Icons_portraits_unit_west_german_assault_pioneer_s_portrait",
		Pioneer = "Icons_portraits_unit_german_pioneer_w_portrait",
		Soldier = "Icons_portraits_unit_german_grenadiers_w_portrait",
		Leftover = "Icons_portraits_unit_german_pioneer_s_portrait",
		Koch = "Icons_portraits_unit_west_german_brigadefuhrer_w_portrait",
		Lohse = "Icons_portraits_unit_west_german_brigadefuhrer_s_portrait",
		Dassler = "Icons_portraits_unit_german_officer_w_portrait",
		Bodyguard = "Icons_portraits_unit_west_german_fallschirmjager_w_portrait",
		WinterGrenadier = "Icons_portraits_unit_german_grenadiers_w_portrait", 
		WinterPioneer = "Icons_portraits_unit_german_pioneer_w_portrait",
		WinterPanzerGrenadier = "Icons_portraits_unit_german_panzer_grenadiers_w_portrait",

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
	Derby					= {nameID = 11077130, icon = "Icons_bob_companies_dialog_support"},					-- Dog Company � Support
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
				manpower = 5000,
				fuel = 5000,
				munition = 5000,
				action = 0,
				command = 16,
			},
			--player 4:
			[3] = {
				manpower = 5000,
				fuel = 5000,
				munition = 5000,
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

        local OptionalText1 = Util_CreateLocString("Oh fuck. It's those fucking deserters! Help! Help!")
		local OptionalText2 = Util_CreateLocString("We have not completed the train engine repairs yet. The train must not fall into their hands! You have to hold them here for a while longer!")
		local OptionalText3 = Util_CreateLocString("They are pushing through. We do not have enough time to finish the repairs! Restart the engine now! We'll fix it later!")
		local OptionalText4 = Util_CreateLocString("Get back on the train! Quickly, move it! We are leaving!")
		local OptionalText5 = Util_CreateLocString("No... don't leave without me! Wait! Wait!")
		
		local OfficerText1 = Util_CreateLocString("Sturmbannfuhrer Koch, an artillery barrage is opening fire at your requested co-ordinates.")
		local OfficerText2 = Util_CreateLocString("Sturmbannfuhrer Koch, incendiary artillery is firing at the co-ordinates you requested.")
		local OfficerText3 = Util_CreateLocString("Sturmbannfuhrer Lohse, Luftwaffe smoke rounds are inbound, please standby.")
		local OfficerText4 = Util_CreateLocString("Sturmbannfuhrer Lohse, fragmentation airstrike is inbound, stay clear of the impact area.")
		local OfficerText5 = Util_CreateLocString("Sturmbannfuhrer Dassler, the requested assault team is approaching your position to assist.")
		local OfficerText6 = Util_CreateLocString("Sturmbannfuhrer Dassler, additional stormtroopers are arriving to help as requested.")
		
		local CacheText1 = Util_CreateLocString("Hey! Over there! It's those turncoats. Take cover!")
		local CacheText2 = Util_CreateLocString("Um... It looks like a small support and supply position. Seems like there is a narrow path they did not see which we can sneak in to grab some munitions. It could be useful!")
		local CacheText3 = Util_CreateLocString("Aha! A supply station across the lake! There must be some munitions available for the taking!")
		local CacheText4 = Util_CreateLocString("I see a lightly defended position beyond the lake. There should be some munitions there. Maybe we can snatch it from them?")
		local CacheText5 = Util_CreateLocString("... I see munitions on the opposite side of the lake...")
		
		local Text1 = Util_CreateLocString("Look, Hans is waiting up ahead... What has he found?")
		local Text2 = Util_CreateLocString("There is smoke rising from a village in the distance. An engagement likely occurred there.")
		local Text3 = Util_CreateLocString("No way around it?")
		local Text4 = Util_CreateLocString("None I can see from here.")
		local Text5 = Util_CreateLocString("Just perfect... How did Task Force Eva even get ahead of us?")
		local Text6 = Util_CreateLocString("They probably have accurate maps. Compared to them we are almost running blind.")
		local Text7 = Util_CreateLocString("...")
		local Text8 = Util_CreateLocString("Look on the bright side, we are now very close to Switzerland's border. I saw a sign earlier that shows we are only fifteen kilometers from the Swiss city of Basel!")
		local Text9 = Util_CreateLocString("If we can just cross the border, I can show any guard my Swiss papers.")
		local Text10 = Util_CreateLocString("Wait, wait, wait... What about us? I certainly do not have any paperwork for entry...")
		local Text11 = Util_CreateLocString("I think we should try not to get caught by the Swiss guardsmen... If we do get caught and they check then I will say you helped escort me to my family in Switzerland, then hope they look kindly to that.")
        local Text12 = Util_CreateLocString("That does not sound like a... foolproof plan...")
		local Text13 = Util_CreateLocString("... It is a terrible plan...")
		local Text14 = Util_CreateLocString("Hey! I never said it is good plan. It is just not the worst plan I can think of.")
		local Text15 = Util_CreateLocString("We have a worse plan than that?! We marched all this way for a plan like that?! Oh dear God we are finished...")
		local Text16 = Util_CreateLocString("Listen to me, we can figure out the fine details once we cross the border. If we get to Basel we can definitely smuggle onto a train heading to Zurich.")
		local Text17 = Util_CreateLocString("My family lives in Zurich. Once we arrive at Zurich this war is over for us!")
		local Text18 = Util_CreateLocString("But to do that we need one last push to the Swiss border. We need to get to the border before more of Task Force Eva arrives and makes it impossible.")
		local Text19 = Util_CreateLocString("... Then we must press on...")
		
		local Text20 = Util_CreateLocString("It's such a clear night... You can see the clouds over the moonlight.")
		local Text21 = Util_CreateLocString("Times like these I wish I was still a child staring into the nighttime sky. Not a care in the world...")
		
		local Text22 = Util_CreateLocString("Looks like Task Force Eva did at least catch up with the rearguard of the American and Commonwealth forces.")
		local Text23 = Util_CreateLocString("What a mess. We should approach carefully...")
		
		local Text24 = Util_CreateLocString("...")
		local Text25 = Util_CreateLocString("What... What happened here... These are German civilians right? Did the Americans or Commonwealth soldiers do this?")
		local Text26 = Util_CreateLocString("Shhh... Quiet...")
		local Text27 = Util_CreateLocString("Urgh... I do not think I have the will to keep doing this anymore. There is only so much death one can endure in a lifetime.")
		local Text28 = Util_CreateLocString("Well, the commander said no survivors. The enemy could have told them about the gold. A shame these people were in the way as they passed through.")
		local Text29 = Util_CreateLocString("But these are our people Koch! Why even bother preserving the nation if we go around murdering our own people!")
		local Text30 = Util_CreateLocString("What do you want me to say Dassler?! That I like shooting civilians?! That I like going in exile for possibly the rest of my fucking life?! At times I wonder why I even bother!")
		local Text31 = Util_CreateLocString("You know, I am so very close to just leaving. Most of the men do not want to be here. I do not want to be here...")
		local Text32 = Util_CreateLocString("What do you think Lohse? Can we tell everyone to just... pack up and go home?")
		local Text33 = Util_CreateLocString("Some of the men may still hold loyalty to their oath Dassler, and do not even think about talking to those task force fanatics. No words will convince them to leave the commander.")
		local Text34 = Util_CreateLocString("We cannot say nothing though! Our own men will fall under Apel's command if we should perish, then they probably won't even survive this ghastly winter nevermind the accursed war.")
		local Text35 = Util_CreateLocString("I know Koch, I know... Just... We should think about this some more...")
		local Text36 = Util_CreateLocString("Did he say... Apel? No... It can't be...")
		
		local Text37 = Util_CreateLocString("Alert! Alert! Those defectors are here!")
		local Text38 = Util_CreateLocString("Check your area! Don't let them get past you!")
		
		local Text39 = Util_CreateLocString("Fuck! We can't hold this any longer! We gotta pull back! Move damn it, move!")
		
		local ExtraText1 = Util_CreateLocString("Look. They are gathering for something. Preparing for an attack?")
		local ExtraText2 = Util_CreateLocString("Keep quiet and your head low. Do not let them see you and keep moving.")
		
		local Text40 = Util_CreateLocString("That is some force they got there Dmitriy. I ain't sure we got what it takes to fight that.")
		local Text41 = Util_CreateLocString("It will be difficult, but what choice do we have? They will not let us live lieutenant no matter what we do. You must surely know this!")
		local Text42 = Util_CreateLocString("He is right! That group is with Task Force Eva. They don't usually leave prisoners.")
		local Text43 = Util_CreateLocString("You god damned assholes got some nerve showing up here! I should fucking put one in you right this moment!")
		local Text44 = Util_CreateLocString("No! We need all the help we can get lieutenant! Do not be rash with your actions!")
		local Text45 = Util_CreateLocString("Argh! I know this fucking operation all started going bad when you Krauts showed up!")
		local Text46 = Util_CreateLocString("Well we have fought with you against Task Force Eva just like we agreed. What we need to worry about now is them and not fight between ourselves!")
		local Text47 = Util_CreateLocString("Wait... Is that who I think it is?")
		local Text48 = Util_CreateLocString("Well gentlemen, this war continues to bring surprises after all...")
		local Text49 = Util_CreateLocString("The remnants of an American and Commonwealth operation, aided by Soviet stragglers and our very own deserters in this part of the Fatherland. A more ridiculous merry band of misfits I have never had the pleasure to see!")
		local Text50 = Util_CreateLocString("But all good tales must come to an end, and so it must be with your story. Unless... you can provide your unconditional surrender right now?")
		local Text51 = Util_CreateLocString("I don't believe it! That's the commander... commander Apel... Wilhelm Apel!")
		local Text52 = Util_CreateLocString("What?! Wilhelm Apel?!...")
		local Text53 = Util_CreateLocString("...Then we cannot surrender, he will kill everyone.")
		local Text54 = Util_CreateLocString("Wait, you know the commander?")
		local Text55 = Util_CreateLocString("That is a long story and this is not the time. The man is merciless! I very much doubt he will take prisoners.")
		local Text56 = Util_CreateLocString("...")
		local Text57 = Util_CreateLocString("Fuck it... We got no choice and nobody lives forever I suppose... Get to your positions then.")
		local Text58 = Util_CreateLocString("Ah! Defiant to the end I see... Tank crews, advance on them!")
		local Text59 = Util_CreateLocString("What?!")
		local Text60 = Util_CreateLocString("What are you doing Wittman?! Return fire! Return fire!!!")
		
		local Text61 = Util_CreateLocString("Well Kurt, just like old times you still need me to get you out of a nasty situation. Some things never change.")
		local Text62 = Util_CreateLocString("Ha! Old habits die hard Wittman. I am grateful for your help though, as always.")
		local Text63 = Util_CreateLocString("We are all grateful for your help! Right lieutenant?")
		local Text64 = Util_CreateLocString("I won't say thanks, but you did save my men's asses just now. I won't forget that.")
		local Text65 = Util_CreateLocString("I think that is as much thanks as you are going to get from him.")
		local Text66 = Util_CreateLocString("They will surely kill you for this Wittman... That was commander Apel you just shot at! Do you even know who he is?")
		local Text67 = Util_CreateLocString("Oh I know who he is. A commander who unnecessarily sends good men under his command to their deaths. An absolute butcher.")
		local Text68 = Util_CreateLocString("...")
		local Text69 = Util_CreateLocString("He is the commander of Task Force Eva you know...")
		local Text70 = Util_CreateLocString("What... WHAT?!")
		local Text71 = Util_CreateLocString("So this Task Force Eva you keep talking about, that officer is their commander? What is he doing all the way out here?")
		local Text72 = Util_CreateLocString("He's protecting a train loaded with gold. Task Force Eva was tasked to escort that train to Zurich in Switzerland at all costs.")
		local Text73 = Util_CreateLocString("Unfortunately for me, it seems they have been mandated by our nation's leader himself to assume command over any forces they find.")
		local Text74 = Util_CreateLocString("This commander Apel sends the men he finds to do the dangerous work and only sends men from Task Force Eva when he has no other choice. I have barely seen the men from Task Force Eva come into contact with the enemy! What cowards!")
		local Text75 = Util_CreateLocString("He is no coward...")
		local Text76 = Util_CreateLocString("Looks like Hans knows the commander as well. But yes, he is a cunning and calculating man Wittman. He must have a reason to send you and others like you to do all the dirty work. We need to escape from him, not fight him.")
		local Text77 = Util_CreateLocString("Not before I kill him...")
		local Text78 = Util_CreateLocString("Please do not get distracted! We should not be focused on that commander Apel. We must escape this forest and away from his task force and the train!")
		local Text79 = Util_CreateLocString("We must hold a united front to overcome his superior forces. That is our only chance!")
		local Text80 = Util_CreateLocString("Fine. Fine! What do we need to do now Krauts? Any good ideas?")
		local Text81 = Util_CreateLocString("Well you are definitely not heading directly south from this location, that way is the main armor column and even I can't engage that many tanks and survive.")
		local Text82 = Util_CreateLocString("We can't go west because our scouts said the Soviets are right on our heels chasing the gold train. Your Soviet allies can risk it but I am definitely not taking my chances getting captured by Soviets.")
		local Text83 = Util_CreateLocString("Which means we can only head north from here... You will need me to spearhead through the fort they built covering the bridge.")
		local Text84 = Util_CreateLocString("What was that? Did you just say a fort Wittman?!")
		local Text85 = Util_CreateLocString("Relax. I'm with you now. At this point I also like the plan to retire in Switzerland. At least I hope that is still the plan...")
		local Text86 = Util_CreateLocString("It is Wittman. We're counting on you. Dmitriy, lieutenant, can we count on your help to assault that fort?")
		local Text87 = Util_CreateLocString("I like our chances of survival with you. It hasn't let us down so far!")
		local Text88 = Util_CreateLocString("You can call me Fitzgerald for fuck sake. We don't have much choice do we? Let's just get this over with... God damn Krauts...")
		
		local Text89 = Util_CreateLocString("We'll start the assault when you secure that vantage point leading into the woods. The enemy will probably continue to come at us to keep us out, so keep pushing in!")
		local Text90 = Util_CreateLocString("The Soviets can help push the wooded path so we don't get flanked. I will attack the main fortifications with the Tiger tank. My men will help on both sides.")
		
        local Text91 = Util_CreateLocString("Time to move men. Watch your area and push those Krauts on both sides!")
		
		local Text92 = Util_CreateLocString("They have broken through the lines! Drop everything and get the train out of here now!")
		local Text93 = Util_CreateLocString("Retreat! Retreat! The fortification is lost! Get out of here!")
		
		local Text94 = Util_CreateLocString("Fuck! They got around us! We will buy you time but get that train out of here now!")
		local Text95 = Util_CreateLocString("There is no way out... We fight to the last man!")
		
		local Text96 = Util_CreateLocString("Not bad folks, I got to admit I didn't think we'd do it. Yet here we are!")
		local Text97 = Util_CreateLocString("Everyone did their part comrades. It is another step closer to leaving this area.")
		local Text98 = Util_CreateLocString("Not a moment too soon...")
		local Text99 = Util_CreateLocString("But we got another problem... My scouts tell me there was heavy armor and mechanized infantry behind us to the south. It was a miracle they didn't attack us earlier but we can't realistically outrun them on foot.")
		local Text100 = Util_CreateLocString("So we cannot outrun the approaching mechanized infantry, but what other options do we have?")
		local Text101 = Util_CreateLocString("Some must stay behind to act as rearguards...")
		local Text102 = Util_CreateLocString("That is a suicide mission in our state. There is not that many of us left... What effect could any rearguard have if we split our forces further?")
		local Text103 = Util_CreateLocString("They don't need to win an engagement. They just have to buy the others enough time to clear a path forward to let us get away from our pursuers. We need to have a rearguard or we are finished if anybody surprises us from behind.")
		local Text104 = Util_CreateLocString("...")
		local Text105 = Util_CreateLocString("...")
		local Text106 = Util_CreateLocString("...")
		local Text107 = Util_CreateLocString("Well, my tank is pretty beaten up and to be honest it needs refuelling and repairs. My crew and I can stay to hold the fort while we get this maintenance done.")
		local Text108 = Util_CreateLocString("Although I think we will need a German speaker on the outside of the tank who can inform us of the situation and any word to leave. I cannot be appraised of the circusmtances while inside the tank.")
		local Text109 = Util_CreateLocString("I will stay with Wittman then. I can speak English and German so I am well suited for this task.")
		local Text110 = Util_CreateLocString("We will stay too. I remember you mentioned there were Soviets pursuing from behind. If they catch up we can talk to them.")
		local Text111 = Util_CreateLocString("Huh... You Krauts and Soviets ain't too shabby. I will ask my men for a few volunteers who wants to stay with you...")
		local Text112 = Util_CreateLocString("The rest of us will make our way south-east and see if we can find a safe way forward. We'll send someone back to the rearguard when it's time for you to re-join us.")
		local Text113 = Util_CreateLocString("Hopefully we will send word for you soon. Let us move!")
		
		local Text114 = Util_CreateLocString("My men needs some time to regroup and get ready. You Krauts go scout up ahead a bit.")
		local Text115 = Util_CreateLocString("Once we're prepared we'll meet up with you further along the way.")
		local Text116 = Util_CreateLocString("Naturally it has to be us...")
		
		local Text117 = Util_CreateLocString("Receiving fire! We are out of time! Get on the trucks. We are pulling out now!")
		local Text118 = Util_CreateLocString("Leave that thing and get on the truck! Move!")
		local Text119 = Util_CreateLocString("Go driver. Go! Quickly!")
		
		local Text120 = Util_CreateLocString("They left in a panic. Looks like they left behind anything that could not be taken in a rush.")
		local Text121 = Util_CreateLocString("It does not make sense they would be so scared of just the three of us. Perhaps they thought the American and Commonwealth men were behind us?")
        local Text122 = Util_CreateLocString("With this much equipment they could put up a good fight. What could they be so afraid of?")
		local Text123 = Util_CreateLocString("...")
		local Text124 = Util_CreateLocString("They know something we do not...")
		
		local Text125 = Util_CreateLocString("Those look like the men who fled earlier. They're getting wiped out!")
		local ExtraText3 = Util_CreateLocString("Fuck... They are getting wiped out by members of Task Force Eva. Seems like these Wehrmacht soldiers have finally outlived their usefulness...")
		local Text126 = Util_CreateLocString("We need to be careful facing them. Perhaps we could go back and ask for lieutenant Fitzgerald's help here?")
		local Text127 = Util_CreateLocString("We do not need to. We can take these trenches from them.")
		local Text128 = Util_CreateLocString("I do not think we have enough people for this, with only the three of us...")
		local Text129 = Util_CreateLocString("I will make it enough.")
		
		local Text132 = Util_CreateLocString("Those are members of Task Force Eva. We need to be careful facing them. Perhaps we could go back and ask for lieutenant Fitzgerald's help here?")
		local Text133 = Util_CreateLocString("We do not need to. We can take these trenches from them.")
		local Text134 = Util_CreateLocString("I do not think we have enough people for this, with only the three of us...")
		local Text135 = Util_CreateLocString("I will make it enough.")
		local Text136 = Util_CreateLocString("...")
		local Text137 = Util_CreateLocString("...")
		
		local Text138 = Util_CreateLocString("You're back. Just about time, we're pretty much ready to head out. Did you find any trouble ahead?")
		local Text139 = Util_CreateLocString("Yes, Task Force Eva special operations units seem to be turning on the Wehrmacht regulars in a trench formation further down the path.")
		local Text140 = Util_CreateLocString("Oh? Ain't that a good thing? Or are they in the way?")
		local Text141 = Util_CreateLocString("They are in our way...")
		local Text142 = Util_CreateLocString("So why are they liquidating their own men? This don't sound like something I've ever heard you Krauts do yet.")
		local Text143 = Util_CreateLocString("The task force never leaves any loose ends. The train is supposed to be a secret. Probably the biggest secret ever entrusted to Task Force Eva.")
		local Text144 = Util_CreateLocString("The train's final destination is likely a well guarded secret. But they could not risk one of the Wehrmacht men somehow finding out about it and leaking it to someone, even after the war has ended.")
		local Text145 = Util_CreateLocString("So these Eva assholes have a mission that goes on beyond the war? What eejit thought of this bullshit mission! I can't believe there are people who wants to drag this conflict on even more.")
		local Text146 = Util_CreateLocString("Well, I suppose it's time to move then. We're not in good form though. I've only got a handful of men left and truth be told many of them are support staff. They won't be very effective in a real firefight.")
		local Text147 = Util_CreateLocString("Everyone is helpful now. Our chances are better if we work together.")
		
		local Text148 = Util_CreateLocString("This place is fucking empty!")
		local Text149 = Util_CreateLocString("They left already. No doubt headed back to meet up with the rest of the task force.")
		local Text150 = Util_CreateLocString("...")
		
		local Text151 = Util_CreateLocString("I think there is a supply outpost on the other side of the river. We could really use more munitions to survive out here.")
		local Text152 = Util_CreateLocString("It looks like a supply outpost may be just across the river. Those munitions may prove useful for us.")
		local Text153 = Util_CreateLocString("... There are munitions across the river...")
		
		local Text154 = Util_CreateLocString("Oh God! This... This was a bad idea.")
		local Text155 = Util_CreateLocString("I did not think the water would be so cold! Getting ourselves wet is not good. I should have known better!")
		local Text156 = Util_CreateLocString("...")
		local Text157 = Util_CreateLocString("We must find heat to stay warm from now, or we will freeze.")
		local Text158 = Util_CreateLocString("Freezing out here is a sure death sentence. We need to find shelter or a fire or something!")
		local Text159 = Util_CreateLocString("Fuck, death by frostbite would be a terrible way to go after all that we have been through...")
		
		local Text160 = Util_CreateLocString("This is an American tank! They must be trying to use it as their own. Oh wow! They modified it with one of our own latest sights! This thing can now fire from a great distance!")
		local Text161 = Util_CreateLocString("We can tell lieutenant Fitzgerald about it. Maybe his men can still use it.")
		local Text162 = Util_CreateLocString("This position has a clear view of the bridge beyond. We might be able to use the supporting fire later.")
		
		local Text163 = Util_CreateLocString("Hey lieutenant. We found an American tank across the river. If you have anyone who is knowledgeable about your tanks you should send them over to have a look.")
		local Text164 = Util_CreateLocString("A tank from our army? Here? OK then... If it's true then it's too good to pass up on. I'll send someone to investigate it.")
		
		local Text165 = Util_CreateLocString("Wolfgang, I hate to ask this dangerous task of you, but... I trust you can do it.")
		local Text166 = Util_CreateLocString("The rest of Task Force Eva is inbound from the north-east very soon. I need you to hold this bridge until they arrive. Once you have all crossed the bridge, blow it up so nobody can follow us!")
		local Text167 = Util_CreateLocString("By the Schneider family name I promise we will hold this position Wilhelm.")
		local Text168 = Util_CreateLocString("Thank you old friend. I know I have already asked too much of you considering some of the things we have had to do... But it is nearly over.")
		local Text169 = Util_CreateLocString("Do be careful... The Soviets are gaining on us with incredible speed. Do not dally when the others arrive, we must move swiftly or the Soviets will crush us in a prolonged fight.")
		local Text170 = Util_CreateLocString("Remember, once everyone has crossed the river, destroy the bridge. See you soon Wolfgang!")
		local Text171 = Util_CreateLocString("We will not let you down Wilhelm!")
		
		local Text172 = Util_CreateLocString("Fire command. Drop incendiary bombs on enemy units at my position immediately! Nobody gets through this bridge!")
		local Text173 = Util_CreateLocString("Fire command. Drop smoke bombs at my position immediately! Commander Apel entrusted us with this position. We will hold it with our lives until the end!")
		
        local Text174 = Util_CreateLocString("They were discussing additional Task Force Eva units arriving from the north-east soon. Also the Soviets were catching up to them. Could our rearguard be in trouble?")
		local Text175 = Util_CreateLocString("What? The Soviets? That's no good Krauts. The men we left behind needs to leave! The situation is already in the gutter, I don't want to deal with the Red Army right now.")
		local Text176 = Util_CreateLocString("OK, here's the plan... We'll hold this bridge against any more Krauts but I need you lot to bring our rearguard over here.")
		local Text177 = Util_CreateLocString("I do not think you can hold out against the remainder of Task Force Eva...")
		local Text178 = Util_CreateLocString("Well you got a better plan? That's all I got! Every moment you waste here chatting with me is wasting time, get going and get the rearguard over here!")

		
		
EVENTS.StartCinematic = function()

	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_cinematickurtto)
	Cmd_Move(Otto, mkr_cinematicottoto)
	Cmd_Move(Tomislav, mkr_cinematictomito)
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Tomislav, Text3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text4)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Tomislav, Text5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text6)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text7)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text8)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text9)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Tomislav, Text10)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text11)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text12)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text13)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text14)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Tomislav, Text15)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text16)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text17)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text18)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text19)
	CTRL.WAIT()
    Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
    Camera_ResetToDefault()
	CTRL.WAIT()

end

EVENTS.WeatherDialogue = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text20)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Tomislav, Text21)
	CTRL.WAIT()

end

EVENTS.OptionalDialogueOne = function()

	CTRL.WAIT()
	Cmd_Retreat(RetreatEngineer)
	CTRL.Actor_PlaySpeech(ACTOR.Sturmpioneer, OptionalText1)
	CTRL.WAIT()

end

EVENTS.OptionalDialogueTwo = function()

	CTRL.WAIT()
	local DestroyEntity = EGroup_GetSpawnedEntityAt(FallbackOne, 1)
    Entity_Destroy(DestroyEntity)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Sturmpioneer, OptionalText2)
	CTRL.WAIT()
	Cmd_Retreat(RetreatEngineer)
	Cmd_Move(OptionalAssGrenOne, mkr_optionalassgrenoneto)
	CTRL.WAIT()

end

EVENTS.OptionalDialogueThree = function()

	CTRL.WAIT()
	local DestroyEntity = EGroup_GetSpawnedEntityAt(FallbackTwo, 1)
    Entity_Destroy(DestroyEntity)
	CTRL.WAIT()
	Cmd_Move(OptionalAssGrenTwo, mkr_optionalassgrentwoto)
	CTRL.Actor_PlaySpeech(ACTOR.Sturmpioneer, OptionalText3)
	CTRL.WAIT()
	Cmd_Retreat(RetreatEngineer)
	Cmd_Move(OptionalVolks, mkr_optionalvolksto)
	CTRL.WAIT()

end

EVENTS.OptionalDialogueFour = function()

	CTRL.WAIT()
	local DestroyEntity = EGroup_GetSpawnedEntityAt(FallbackThree, 1)
    Entity_Destroy(DestroyEntity)
	CTRL.WAIT()
	CTRL.Event_Delay(3)
	CTRL.WAIT()
	Cmd_Retreat(RetreatEngineer)
	Cmd_Retreat(OptionalPioneerOne)
	Cmd_Retreat(OptionalPioneerTwo)
	CTRL.Actor_PlaySpeech(ACTOR.Sturmpioneer, OptionalText4)
	CTRL.WAIT()
	Cmd_Retreat(Leftover)
	CTRL.WAIT()

end

EVENTS.OptionalDialogueFive = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Leftover, OptionalText5)
	CTRL.WAIT()

end

EVENTS.PointOneDialogue = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text22)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text23)
	CTRL.WAIT()

end

EVENTS.VillageCinematic = function()

	CTRL.WAIT()
	SGroup_Kill(VillageRegionControl)
	CTRL.WAIT()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(15)
	CTRL.WAIT()
	SGroup_WarpToMarker(Kurt, mkr_villagekurt)
	SGroup_WarpToMarker(Otto, mkr_villageotto)
	SGroup_WarpToMarker(Hans, mkr_villagehans)
	SGroup_WarpToMarker(Tomislav, mkr_villagetomi)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_villagekurtto)
	Cmd_Move(Otto, mkr_villageottoto)
	Cmd_Move(Hans, mkr_villagehansto)
	Cmd_Move(Tomislav, mkr_villagetomito)
	CTRL.WAIT()
	CTRL.Event_Delay(3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text24)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text25)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text26)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Camera_MoveTo(mkr_villagecamera)
	FOW_RevealMarker(mkr_villagecamera, 9999)
    Camera_SetZoomDist(10)
	CTRL.Actor_PlaySpeech(ACTOR.Lohse, Text27)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Koch, Text28)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Dassler, Text29)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Koch, Text30)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Dassler, Text31)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Dassler, Text32)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Lohse, Text33)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Koch, Text34)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Lohse, Text35)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	Camera_MoveTo(mkr_villagekurtto)
	FOW_UnRevealMarker(mkr_villagecamera)
    Camera_SetZoomDist(15)
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text36)
	CTRL.WAIT()
	Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
    Camera_ResetToDefault()
	CTRL.WAIT()
	UI_DeleteMinimapBlip(Blip1)
	CTRL.WAIT()
	Cmd_Move(Koch, mkr_kochto)
	Cmd_Move(Lohse, mkr_lohseto)
	Cmd_Move(Dassler, mkr_dasslerto)
	CTRL.WAIT()

end

EVENTS.VillageWarningDialogue = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Soldier, Text37)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Soldier, Text38)
	CTRL.WAIT()

end

EVENTS.KochDialogueOne = function()

	CTRL.WAIT()
	local Target = Player_GetSquadConcentration(player1)
    Cmd_Ability(player8, ABILITY.AEF.MAJOR_ARTILLERY, Target, nil, true)
	CTRL.Actor_PlaySpeech(ACTOR.Radio, OfficerText1)
	CTRL.WAIT()

end

EVENTS.KochDialogueTwo = function()

	CTRL.WAIT()
	local Target = Player_GetSquadConcentration(player1)
    Cmd_Ability(player8, ABILITY.SOVIET.FIRE_ARTILLERY, Target, nil, true)
	CTRL.Actor_PlaySpeech(ACTOR.Radio, OfficerText2)
	CTRL.WAIT()

end

EVENTS.LohseDialogueOne = function()

	CTRL.WAIT()
	local Target = Player_GetSquadConcentration(player1)
	local Direction = Marker_GetDirection(mkr_direction)
    Cmd_Ability(player6, ABILITY.GERMAN.STUKA_SMOKE_BOMB, Target, Direction, true)
	CTRL.Actor_PlaySpeech(ACTOR.Radio, OfficerText3)
	CTRL.WAIT()

end

EVENTS.LohseDialogueTwo = function()

	CTRL.WAIT()
	local Target = Player_GetSquadConcentration(player1)
    local Direction = Marker_GetDirection(mkr_direction)
    Cmd_Ability(player6, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB, Target, Direction, true)
	CTRL.Actor_PlaySpeech(ACTOR.Radio, OfficerText4)
	CTRL.WAIT()

end

EVENTS.DasslerDialogueOne = function()

	CTRL.WAIT()
    Util_CreateSquads(player7, VillageAssGren, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_villagereinforcementsspawn)
	CTRL.Actor_PlaySpeech(ACTOR.Radio, OfficerText5)
	CTRL.WAIT()

end

EVENTS.DasslerDialogueTwo = function()

	CTRL.WAIT()
    Util_CreateSquads(player7, VillageStorm, SBP.GERMAN.STORMTROOPER_SQUAD_MP, mkr_villagereinforcementsspawn)
	CTRL.Actor_PlaySpeech(ACTOR.Radio, OfficerText6)
	CTRL.WAIT()

end

EVENTS.CacheBegin = function()

	CTRL.WAIT()
	SGroup_Kill(CacheControl)
	Cmd_Move(CacheAssGren, mkr_cacheassgrento)
	Cmd_Move(CachePanzerGren, mkr_cachepanzergrento)
	Cmd_Move(CacheKubel, mkr_cachekubelto)
	Cmd_Move(CacheMG, mkr_cachemgto)
	CTRL.Actor_PlaySpeech(ACTOR.Pioneer, CacheText1)
	CTRL.WAIT()

end

EVENTS.CacheKurtDialogue = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, CacheText2)
	CTRL.WAIT()

end

EVENTS.CacheOttoDialogue = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, CacheText3)
	CTRL.WAIT()

end

EVENTS.CacheTomislavDialogue = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Tomislav, CacheText4)
	CTRL.WAIT()

end

EVENTS.CacheHansDialogue = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, CacheText5)
	CTRL.WAIT()

end

EVENTS.BridgeDialogue = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Engineer_01, Text39)
	CTRL.WAIT()
	Cmd_Retreat(BridgeAllies)
	CTRL.WAIT()

end

EVENTS.CampScoutTalk = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Tomislav, ExtraText1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, ExtraText2)
	CTRL.WAIT()

end

EVENTS.CampDialogue = function()

	CTRL.WAIT()
	World_GetCurrentInteractionStage()
    World_IncreaseInteractionStage()
	CTRL.WAIT()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(15)
	SGroup_SetInvulnerable(CampOfficerGroup, true)
	EGroup_Destroy(CampAltRetreat)
	FOW_RevealMarker(mkr_campvision, 9000)
	SGroup_WarpToMarker(Kurt, mkr_kurtcamptp)
	SGroup_WarpToMarker(Otto, mkr_ottocamptp)
	SGroup_WarpToMarker(Hans, mkr_hanscamptp)
	SGroup_WarpToMarker(Tomislav, mkr_tomislavcamptp)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_kurtcampto)
	Cmd_Move(Otto, mkr_ottocampto)
	Cmd_Move(Hans, mkr_hanscampto)
	Cmd_Move(Tomislav, mkr_tomislavcampto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text40)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text41)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text42)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text43)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text44)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text45)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text46)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text47)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(CampOfficer)
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text48)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text49)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text50)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(Kurt)
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text51)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text52)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text53)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text54)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text55)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text56)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text57)
	CTRL.WAIT()
	Cmd_Move(Michael, mkr_michaeltpto)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(CampOfficer)
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	SGroup_DestroyAllSquads(VillageAreaUnits)
	SGroup_DestroyAllSquads(OptionalAreaUnits)
	CTRL.WAIT()
	Cmd_Move(Michael, mkr_fortmichaelstaging)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text58)
	CTRL.WAIT()
	Cmd_Move(CampLeftPanzer, mkr_campleftpanzerstartto)
	Cmd_Move(CampRightPanzer, mkr_camprightpanzerstartto)
	CTRL.WAIT()
	SGroup_SetPlayerOwner(Michael, player4)
	SGroup_SetPlayerOwner(CampEnemyGroup, player5)
	Cmd_Attack(Michael, CampPanther)
	CTRL.WAIT()
	
	
end
	
EVENTS.CampSecondDialogue = function()
	
	CTRL.WAIT()
	Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
    Camera_ResetToDefault()
	SGroup_SetMoodMode(CampCalmEnemy, MM_Auto)
	FOW_RevealSGroupOnly(Michael, 9000)
	CTRL.WAIT()
	SGroup_Kill(CampPanther)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text59)
	CTRL.WAIT()
	Cmd_Move(CampLeftPanzer, mkr_campleftpanzerto)
	Cmd_Move(CampRightPanzer, mkr_camprightpanzerto)
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text60)
	Cmd_Retreat(CampOfficerGroup)
	FOW_UnRevealMarker(mkr_campvision)
	CTRL.WAIT()
	Cmd_Move(CampShrekLeft, mkr_campshrekleftto)
	Cmd_Move(CampShrekRight, mkr_campshrekrightto)
	Cmd_Move(CampGrenLeft, mkr_campgrenleftto)
	Cmd_Move(CampGrenRight, mkr_campgrenrightto)
	Cmd_Move(CampFusilierLeft, mkr_campfusilierleftto)
	Cmd_Move(CampFusilierMiddle, mkr_campfusiliermiddleto)
	Cmd_Move(CampFusilierRight, mkr_campfusilierrightto)
	Cmd_Move(CampAssGrenLeft, mkr_campassgrenleftto)
	Cmd_Move(CampAssGrenRight, mkr_campassgrenrightto)
	Cmd_Move(CampVolksLeft, mkr_campvolksleftto)
	Cmd_Move(CampVolksMiddle, mkr_campvolksmiddleto)
	Cmd_Move(CampVolksRight, mkr_campvolksrightto)
	CTRL.WAIT()

end

EVENTS.FortInitialTalk = function()

	CTRL.WAIT()
	World_GetCurrentInteractionStage()
    World_IncreaseInteractionStage()
	CTRL.WAIT()
	SGroup_WarpToMarker(Kurt, mkr_kurtforttp)
	SGroup_WarpToMarker(Otto, mkr_ottoforttp)
	SGroup_WarpToMarker(Hans, mkr_hansforttp)
	SGroup_WarpToMarker(Tomislav, mkr_tomislavforttp)
	SGroup_WarpToMarker(Fitzgerald, mkr_fitzgeraldforttp)
	SGroup_WarpToMarker(Dmitriy, mkr_dmitriyforttp)
	SGroup_WarpToMarker(Aleksei, mkr_alekseiforttp)
	SGroup_WarpToMarker(Yuri, mkr_yuriforttp)
	SGroup_WarpToMarker(Viktor, mkr_viktorforttp)
	SGroup_WarpToMarker(Stator, mkr_statorforttp)
	SGroup_WarpToMarker(Vladilen, mkr_vladilenforttp)
	SGroup_WarpToMarker(Nikolai, mkr_nikolaiforttp)
	CTRL.WAIT()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(25)
	FOW_RevealMarker(mkr_campvision, 9000)
	CTRL.WAIT()
	Cmd_Move(Michael, mkr_michaeltpto)
	Cmd_Move(Kurt, mkr_kurtforttpto)
	Cmd_Move(Otto, mkr_ottoforttpto)
	Cmd_Move(Hans, mkr_hansforttpto)
	Cmd_Move(Tomislav, mkr_tomislavforttpto)
	Cmd_Move(Dmitriy, mkr_dmitriyforttpto)
	Cmd_Move(Fitzgerald, mkr_fitzgeraldforttpto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text61)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text62)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text63)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text64)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text65)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text66)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text67)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text68)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text69)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text70)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Tomislav, Text71)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text72)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text73)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text74)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text75)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text76)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text77)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text78)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text79)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text80)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text81)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text82)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text83)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text84)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text85)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text86)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text87)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text88)
	CTRL.WAIT()
	FOW_UnRevealMarker(mkr_campvision)
	Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
    Camera_ResetToDefault()
	CTRL.WAIT()
	SGroup_WarpToMarker(FortRifle, mkr_fortinitialtp)
	SGroup_WarpToMarker(FortEngineer, mkr_fortinitialtp)
	SGroup_WarpToMarker(FortPara, mkr_fortinitialtp)
	SGroup_WarpToMarker(FortEchelon, mkr_fortinitialtp)
	SGroup_WarpToMarker(WoodRifle, mkr_woodinitialtp)
	SGroup_WarpToMarker(WoodRanger, mkr_woodinitialtp)
	SGroup_WarpToMarker(WoodEchelon, mkr_woodinitialtp)
	CTRL.WAIT()
	local Position = Marker_GetDirection(mkr_fortmichaelstaging)
	Cmd_AttackMove(Michael, mkr_fortmichaelstaging)
	Cmd_Move(Fitzgerald, mkr_fortfitzgeraldto1)
	Cmd_Move(FortRifle, mkr_fortrifleto1)
	Cmd_Move(FortEngineer, mkr_fortengineerto1)
	Cmd_Move(FortPara, mkr_fortparato1)
	Cmd_Move(FortEchelon, mkr_fortechelonto1)
	Cmd_Move(Dmitriy, mkr_wooddmitriyto1)
	Cmd_Move(Vladilen, mkr_woodvladilento1)
	Cmd_Move(Stator, mkr_woodstatorto1)
	Cmd_Move(Viktor, mkr_woodviktorto1)
	Cmd_Move(Nikolai, mkr_woodnikolaito1)
	Cmd_Move(Yuri, mkr_woodyurito1)
	Cmd_Move(Aleksei, mkr_woodalekseito1)
	Cmd_Move(WoodRifle, mkr_woodrifleto1)
	Cmd_Move(WoodRanger, mkr_woodrangerto1)
	Cmd_Move(WoodEchelon, mkr_woodechelonto1)
	CTRL.WAIT()
	local TextHintMichael = Util_CreateLocString("Michael Wittman's death will result in mission failure. You must complete the objective before his tank is destroyed.")
    HintMichael = HintPoint_Add(Michael, true, TextHintMichael)
	CTRL.WAIT()

end

EVENTS.FortReadyTalk = function()
	
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text89)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text90)
	CTRL.WAIT()

end

EVENTS.FortInitiation = function()
	
	CTRL.WAIT()
	World_GetCurrentInteractionStage()
    World_IncreaseInteractionStage()
	CTRL.WAIT()
	SGroup_Kill(FortStageOne)
	SGroup_Kill(WoodStageOne)
	HintPoint_Remove(HintMichael)
	CTRL.WAIT()
	SGroup_WarpToMarker(FortVolks, mkr_fortenemyspawn)
	SGroup_WarpToMarker(FortPanzerGren, mkr_fortenemyspawn)
	SGroup_WarpToMarker(FortAssGren, mkr_fortenemyspawn)
	SGroup_WarpToMarker(FortFusilier, mkr_fortenemyspawn)
	SGroup_WarpToMarker(FortGren, mkr_fortenemyspawn)
	SGroup_WarpToMarker(WoodVolks, mkr_fortenemyspawn)
	SGroup_WarpToMarker(WoodStorm, mkr_fortenemyspawn)
	SGroup_WarpToMarker(WoodAssGren, mkr_fortenemyspawn)
	SGroup_WarpToMarker(WoodPanzerGren, mkr_fortenemyspawn)
	CTRL.WAIT()
	SGroup_Kill(FortEnemySpawnControl)
	CTRL.WAIT()
	Command_SquadEntityLoad(player5, FortStartFusilier, SCMD_Load, FortTent, false, true)
	Cmd_Move(FortStartGren, mkr_fortstartgrento)
	Cmd_Move(FortStartAT, mkr_fortstartatto)
	Cmd_Move(FortStartMG, mkr_fortstartmgto)
	Cmd_Move(FortStartStorm, mkr_fortstartstormto)
	Cmd_Move(FortStartRatken, mkr_fortstartratkento)
	Cmd_Move(Michael, mkr_fortmichaelto2)
	Cmd_Move(Fitzgerald, mkr_fortfitzgeraldto2)
	Cmd_AttackMove(FortRifle, mkr_fortrifleto2)
	Cmd_AttackMove(FortEngineer, mkr_fortengineerto2)
	Cmd_AttackMove(FortPara, mkr_fortparato2)
	Cmd_AttackMove(FortEchelon, mkr_fortechelonto2)
	Cmd_AttackMove(WoodRifle, mkr_woodrifleto2)
	Cmd_AttackMove(WoodRanger, mkr_woodrangerto2)
	Cmd_AttackMove(WoodEchelon, mkr_woodechelonto2)
	Cmd_Move(Dmitriy, mkr_wooddmitriyto2)
	Cmd_Move(Viktor, mkr_woodviktorto2)
	Cmd_Move(Vladilen, mkr_woodvladilento2)
	Cmd_Move(Stator, mkr_woodstatorto2)
	Cmd_Move(Nikolai, mkr_woodnikolaito2)
	Cmd_Move(Yuri, mkr_woodyurito2)
	Cmd_Move(Aleksei, mkr_woodalekseito2)
	Cmd_AttackMove(WoodRifle, mkr_woodrifleto2)
	Cmd_AttackMove(WoodRanger, mkr_woodrangerto2)
	Cmd_AttackMove(WoodEchelon, mkr_woodechelonto2)
	Cmd_AttackMove(WoodStageOneAttackGroup, mkr_woodonetarget2)
	Cmd_AttackMove(WoodStageOnePanzerGren, mkr_woodonetarget1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text91)
	CTRL.WAIT()

end

EVENTS.FortEndingFlee = function()
	
	CTRL.WAIT()
	World_GetCurrentInteractionStage()
    World_IncreaseInteractionStage()
	CTRL.WAIT()
	Util_CreateSquads(player5, FortEnemySpawnControl, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_fortenemyspawncontrolpoint)
	SGroup_SetInvulnerable(Michael, true)
	SGroup_SetInvulnerable(FortBodyguard, true)
	Cmd_Move(Michael, mkr_fortmichaelto6)
	Cmd_Move(Fitzgerald, mkr_fortfitzgeraldto6)
	SGroup_Hide(TrainTwo, false)
	SGroup_EnableMinimapIndicator(TrainTwo, true)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Bodyguard, Text92)
	CTRL.WAIT()
	Cmd_Retreat(FortBodyguard, mkr_finalebodyguardwarp)
	Util_ForceRetreatAll(FortEndMG, mkr_fortunitsretreatpoint, true)
	Util_ForceRetreatAll(WoodAreaUnits, mkr_fortunitsretreatpoint, true)
	Util_ForceRetreatAll(WoodAreaReinforcements, mkr_fortunitsretreatpoint, true)
	Util_ForceRetreatAll(WoodPanzerGren, mkr_fortunitsretreatpoint, true)
	Util_ForceRetreatAll(WoodStorm, mkr_fortunitsretreatpoint, true)
	Util_ForceRetreatAll(WoodSturm, mkr_fortunitsretreatpoint, true)
	Util_ForceRetreatAll(WoodVolks, mkr_fortunitsretreatpoint, true)
	SGroup_Kill(WoodAreaKubels)
	Util_ForceRetreatAll(FortBridgeUnits, mkr_fortunitsretreatpoint, true)
	Util_ForceRetreatAll(FortAreaUnits, mkr_fortunitsretreatpoint, true)
	Util_ForceRetreatAll(FortAreaReinforcements, mkr_fortunitsretreatpoint, true)
	Util_ForceRetreatAll(FortPanzerGren, mkr_fortunitsretreatpoint, true)
	Util_ForceRetreatAll(FortFusilier, mkr_fortunitsretreatpoint, true)
	Util_ForceRetreatAll(FortGren, mkr_fortunitsretreatpoint, true)
	Util_ForceRetreatAll(FortAssGren, mkr_fortunitsretreatpoint, true)
	Util_ForceRetreatAll(FortVolks, mkr_fortunitsretreatpoint, true)
	SGroup_Kill(FortEnemyATs)
	SGroup_Kill(FortVehicles)
	Cmd_Move(TrainTwo, mkr_traintwoto1)
	Blip6 = UI_CreateMinimapBlip(Point5, 9000, BT_ObjectivePrimary)
	UI_DeleteMinimapBlip(Blip5)
	CTRL.Actor_PlaySpeech(ACTOR.Bodyguard, Text93)
	CTRL.WAIT()

end

EVENTS.FortEndingStay = function()
	
	CTRL.WAIT()
	Util_CreateSquads(player5, FortEnemySpawnControl, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_fortenemyspawncontrolpoint)
	SGroup_Kill(FortTeamDefenders)
	SGroup_Kill(WoodAreaKubels)
	SGroup_Kill(FortChoice)
	Util_ForceRetreatAll(WoodAreaUnits, mkr_fortunitsretreatpoint, true)
	Util_ForceRetreatAll(WoodAreaReinforcements, mkr_fortunitsretreatpoint, true)
	Util_ForceRetreatAll(WoodPanzerGren, mkr_fortunitsretreatpoint, true)
	Util_ForceRetreatAll(WoodStorm, mkr_fortunitsretreatpoint, true)
	Util_ForceRetreatAll(WoodSturm, mkr_fortunitsretreatpoint, true)
	Util_ForceRetreatAll(WoodVolks, mkr_fortunitsretreatpoint, true)
	Util_ForceRetreatAll(FortPanzerGren, mkr_fortunitsretreatpoint, true)
	Util_ForceRetreatAll(FortFusilier, mkr_fortunitsretreatpoint, true)
	Util_ForceRetreatAll(FortGren, mkr_fortunitsretreatpoint, true)
	Util_ForceRetreatAll(FortAssGren, mkr_fortunitsretreatpoint, true)
	Util_ForceRetreatAll(FortVolks, mkr_fortunitsretreatpoint, true)
	SGroup_SetInvulnerable(Michael, true)
	SGroup_Hide(TrainTwo, false)
	SGroup_EnableMinimapIndicator(TrainTwo, true)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Bodyguard, Text94)
	CTRL.WAIT()
	Cmd_Move(TrainTwo, mkr_traintwoto1)
	Blip6 = UI_CreateMinimapBlip(Point5, 9000, BT_ObjectivePrimary)
	UI_DeleteMinimapBlip(Blip5)
	CTRL.Actor_PlaySpeech(ACTOR.Bodyguard, Text95)
	CTRL.WAIT()

end

EVENTS.MillDialogue = function()
	
	CTRL.WAIT()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(40)
	CTRL.WAIT()
	SGroup_SetInvulnerable(Tomislav, true)
	CTRL.WAIT()
	SGroup_WarpToMarker(Michael, mkr_fortmichaelto7)
	SGroup_WarpToMarker(Fitzgerald, mkr_fortfitzgeraldto7)
	SGroup_WarpToMarker(Dmitriy, mkr_milldmitriywarp)
	SGroup_WarpToMarker(Vladilen, mkr_millvladilenwarp)
	SGroup_WarpToMarker(Stator, mkr_millstatorwarp)
	SGroup_WarpToMarker(Nikolai, mkr_millnikolaiwarp)
	SGroup_WarpToMarker(Viktor, mkr_millviktorwarp)
	SGroup_WarpToMarker(Yuri, mkr_millyuriwarp)
	SGroup_WarpToMarker(Aleksei, mkr_millalekseiwarp)
	SGroup_WarpToMarker(Kurt, mkr_millkurtwarp)
	SGroup_WarpToMarker(Otto, mkr_millottowarp)
	SGroup_WarpToMarker(Hans, mkr_millhanswarp)
	SGroup_WarpToMarker(Tomislav, mkr_milltomislavwarp)
	SGroup_WarpToMarker(RearEchelon, mkr_millrearechelonwarp)
	SGroup_WarpToMarker(RearRifle, mkr_millrearriflewarp)
	SGroup_WarpToMarker(RearEngineer, mkr_millrearengineerwarp)
	SGroup_WarpToMarker(RearSapper, mkr_millrearsapperwarp)
	SGroup_WarpToMarker(RearTommy, mkr_millreartommywarp)
	SGroup_WarpToMarker(ForwardRanger, mkr_millforwardrangerwarp)
	SGroup_WarpToMarker(ForwardEchelon, mkr_millforwardechelonwarp)
	SGroup_WarpToMarker(ForwardSapper, mkr_millforwardsapperwarp)
	SGroup_WarpToMarker(ForwardCommando, mkr_millforwardcommandowarp)
	SGroup_WarpToMarker(ForwardPara, mkr_millforwardparawarp)
	SGroup_WarpToMarker(ForwardTommy, mkr_millforwardtommywarp)
	CTRL.WAIT()
	Cmd_Move(Michael, mkr_millmichaelto1)
	Cmd_Move(Fitzgerald, mkr_millfitzgeraldto1)
	Cmd_Move(Kurt, mkr_millkurtto1)
	Cmd_Move(Otto, mkr_millottoto1)
	Cmd_Move(Hans, mkr_millhansto1)
	Cmd_Move(Tomislav, mkr_milltomislavto1)
	Cmd_Move(Dmitriy, mkr_milldmitriyto1)
	Cmd_Move(Vladilen, mkr_millvladilento1)
	Cmd_Move(Stator, mkr_millstatorto1)
	Cmd_Move(Nikolai, mkr_millnikolaito1)
	Cmd_Move(Viktor, mkr_millviktorto1)
	Cmd_Move(Yuri, mkr_millyurito1)
	Cmd_Move(Aleksei, mkr_millalekseito1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text96)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text97)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text98)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text99)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text100)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Tomislav, Text101)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text102)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text103)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text104)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text105)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text106)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text107)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text108)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Tomislav, Text109)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text110)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text111)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text112)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text113)
	CTRL.WAIT()
	SGroup_SetPlayerOwner(Tomislav, player4)
	CTRL.WAIT()
	Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
    Camera_ResetToDefault()
	CTRL.WAIT()
	Cmd_Move(Michael, mkr_millmichaelto2)
	Cmd_Move(Fitzgerald, mkr_millfitzgeraldto2)
	Cmd_Move(Tomislav, mkr_milltomislavto2)
	Cmd_Move(Dmitriy, mkr_milldmitriyto2)
	Cmd_Move(Vladilen, mkr_millvladilento2)
	Cmd_Move(Stator, mkr_millstatorto2)
	Cmd_Move(Nikolai, mkr_millnikolaito2)
	Cmd_Move(Viktor, mkr_millviktorto2)
	Cmd_Move(Yuri, mkr_millyurito2)
	Cmd_Move(Aleksei, mkr_millalekseito2)
	Cmd_Move(RearEchelon, mkr_millrearechelonto)
	Cmd_Move(RearRifle, mkr_millrearrifleto)
	Cmd_Move(RearEngineer, mkr_millrearengineerto)
	Cmd_Move(RearSapper, mkr_millrearsapperto)
	Cmd_Move(RearTommy, mkr_millreartommyto)
	Cmd_Move(ForwardRanger, mkr_millforwardrangerto)
	Cmd_Move(ForwardEchelon, mkr_millforwardechelonto)
	Cmd_Move(ForwardSapper, mkr_millforwardsapperto)
	Cmd_Move(ForwardCommando, mkr_millforwardcommandoto)
	Cmd_Move(ForwardPara, mkr_millforwardparato)
	Cmd_Move(ForwardTommy, mkr_millforwardtommyto)
	CTRL.WAIT()

end

EVENTS.MillFitzgeraldSpeech = function()
	
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text114)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text115)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text116)
	CTRL.WAIT()

end

EVENTS.MillRetreat = function()
	
	CTRL.WAIT()
	FOW_RevealMarker(mkr_millvision, 9000)
	CTRL.WAIT()
	Command_SquadSquadLoad(player5, MillLoadOne, SCMD_Load, MillTruckOne, false, true)
	CTRL.Actor_PlaySpeech(ACTOR.WinterGrenadier, Text117)
	CTRL.WAIT()
	CTRL.Event_Delay(3)
	CTRL.WAIT()
	Cmd_Move(MillTruckOne, mkr_milltruckoneto)
	Command_SquadSquadLoad(player5, MillLoadTwo, SCMD_Load, MillTruckTwo, false, true)
	CTRL.Actor_PlaySpeech(ACTOR.WinterPioneer, Text118)
	CTRL.WAIT()
	CTRL.Event_Delay(5)
	CTRL.WAIT()
	Cmd_Move(MillTruckTwo, mkr_milltrucktwoto)
	Command_SquadSquadLoad(player5, MillLoadThree, SCMD_Load, MillTruckThree, false, true)
	CTRL.Actor_PlaySpeech(ACTOR.WinterPanzerGrenadier, Text119)
	CTRL.WAIT()
	CTRL.Event_Delay(5)
	CTRL.WAIT()
	Cmd_Move(MillTruckThree, mkr_milltruckthreeto)
	CTRL.WAIT()
	CTRL.Event_Delay(5)
	CTRL.WAIT()
	FOW_UnRevealMarker(mkr_millvision)
	CTRL.WAIT()

end

EVENTS.MillSupplyTalk = function()
	
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text120)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text121)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text122)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text123)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text124)
	CTRL.WAIT()

end

EVENTS.TrenchAttackersAliveDialogue = function()

	CTRL.WAIT()
	SGroup_SetPlayerOwner(TrenchVictims, player3)
	SGroup_SetInvulnerable(TrenchAreaUnits, false)
	SGroup_Kill(TrenchControl)
	CTRL.WAIT()
	Cmd_Attack(TrenchMidOber, TrenchVictimAssGren)
	Cmd_Attack(TrenchRightVolks, TrenchVictimGren)
    Cmd_Move(TrenchMidSturm, mkr_trenchsturmto)
	Cmd_Move(TrenchRightStorm, mkr_trenchstormto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text125)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, ExtraText3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text126)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text127)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text128)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text129)
	CTRL.WAIT()

end

EVENTS.TrenchAttackersDeadDialogue = function()
	
	CTRL.WAIT()
	SGroup_SetPlayerOwner(TrenchVictims, player3)
	SGroup_SetInvulnerable(TrenchAreaUnits, false)
	SGroup_Kill(TrenchControl)
	CTRL.WAIT()
	Cmd_Attack(TrenchMidOber, TrenchVictimAssGren)
	Cmd_Attack(TrenchRightVolks, TrenchVictimGren)
    Cmd_Move(TrenchMidSturm, mkr_trenchsturmto)
	Cmd_Move(TrenchRightStorm, mkr_trenchstormto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text132)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text133)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text134)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text135)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text136)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text137)
	CTRL.WAIT()

end

EVENTS.TrenchFitzgeraldTalk = function()
	
	CTRL.WAIT()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(15)
	CTRL.WAIT()
	Util_CreateSquads(player5, TrenchChoice, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_trenchchoice)
	CTRL.WAIT()
	SGroup_WarpToMarker(Kurt, mkr_trenchkurtwarp)
	SGroup_WarpToMarker(Otto, mkr_trenchottowarp)
	SGroup_WarpToMarker(Hans, mkr_trenchhanswarp)
	SGroup_WarpToMarker(PathTrenchLeftovers, mkr_pathtrenchwarp)
	SGroup_WarpToMarker(FinaleTrenchLeftovers, mkr_finaletrenchwarp)
	CTRL.WAIT()
	Cmd_Move(Fitzgerald, mkr_trenchfitzgeraldtalkto)
	Cmd_Move(Kurt, mkr_trenchkurtto)
	Cmd_Move(Otto, mkr_trenchottoto)
	Cmd_Move(Hans, mkr_trenchhansto)
	Cmd_Move(TrenchRightVolks, mkr_pathvolksto)
	Cmd_Move(TrenchRightStorm, mkr_pathstormto)
	Cmd_Move(TrenchLeftGren, mkr_pathgrento)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text138)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text139)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text140)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text141)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text142)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text143)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text144)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text145)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text146)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text147)
	CTRL.WAIT()
	Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
    Camera_ResetToDefault()
	CTRL.WAIT()
	Cmd_AttackMove(Fitzgerald, mkr_trenchfitzgeraldto1)
	Cmd_AttackMove(ForwardPara, mkr_trenchforwardparato1)
	Cmd_AttackMove(ForwardRanger, mkr_trenchforwardrangerto1)
	Cmd_AttackMove(ForwardEchelon, mkr_trenchforwardechelonto1)
	Cmd_AttackMove(ForwardSapper, mkr_trenchforwardsapperto1)
	Cmd_AttackMove(ForwardCommando, mkr_trenchforwardcommandoto1)
	Cmd_AttackMove(ForwardTommy, mkr_trenchforwardtommyto1)
	CTRL.WAIT()

end

EVENTS.TrenchFitzgeraldAssault = function()
	
	CTRL.WAIT()
	World_GetCurrentInteractionStage()
    World_IncreaseInteractionStage()
    CTRL.WAIT()
	SGroup_Kill(TrenchVictims)
	CTRL.WAIT()
	Cmd_Move(Fitzgerald, mkr_trenchfitzgeraldto2)
	Cmd_Move(ForwardPara, mkr_trenchforwardparato2)
	Cmd_Move(ForwardRanger, mkr_trenchforwardrangerto2)
	Cmd_Move(ForwardEchelon, mkr_trenchforwardechelonto2)
	Cmd_Move(ForwardSapper, mkr_trenchforwardsapperto2)
	Cmd_Move(ForwardCommando, mkr_trenchforwardcommandoto2)
	Cmd_Move(ForwardTommy, mkr_trenchforwardtommyto2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text148)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text149)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text150)
	CTRL.WAIT()

end

EVENTS.OutpostKurtDialogue = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text151)
	CTRL.WAIT()

end

EVENTS.OutpostOttoDialogue = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text152)
	CTRL.WAIT()

end

EVENTS.OutpostHansDialogue = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text153)
	CTRL.WAIT()

end

EVENTS.OutpostFreezingDialogue = function()

	CTRL.WAIT()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(15)
	CTRL.WAIT()
	SGroup_Kill(OutpostChoice)
	CTRL.WAIT()
	SGroup_WarpToMarker(Kurt, mkr_outpostkurtwarp)
	SGroup_WarpToMarker(Otto, mkr_outpostottowarp)
	SGroup_WarpToMarker(Hans, mkr_outposthanswarp)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_outpostkurtto)
	Cmd_Move(Otto, mkr_outpostottoto)
	Cmd_Move(Hans, mkr_outposthansto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text154)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text155)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text156)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text157)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text158)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text159)
	CTRL.WAIT()
	Player_SetHeatLossRate(player1, 1)
	Player_SetHeatLossRate(player2, 1)
	Player_SetHeatGainRate(player1, 2)
	Player_SetHeatGainRate(player2, 2)
	CTRL.WAIT()
	local FireHint1 = Util_CreateLocString("Moving characters into buildings will help regain heat.")
	local FireHint2 = Util_CreateLocString("Moving characters near fire pits will help regain heat.")
	local FireHint3 = Util_CreateLocString("Moving characters behind heavy (green) cover will only pause heat loss.")
	Hint2 = HintPoint_Add(HintHouse, true, FireHint1)
	Hint3 = HintPoint_Add(HintTower, true, FireHint1)
	Hint4 = HintPoint_Add(FirePit1, true, FireHint2)
	Hint5 = HintPoint_Add(FirePit2, true, FireHint2)
	Hint6 = HintPoint_Add(RockHint1, true, FireHint3)
	Hint7 = HintPoint_Add(RockHint2, true, FireHint3)
	CTRL.WAIT()
	Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
    Camera_ResetToDefault()
	CTRL.WAIT()

end

EVENTS.OutpostArtyDialogue = function()

	CTRL.WAIT()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(15)
	CTRL.WAIT()
	Player_SetHeatLossRate(player1, 0)
	Player_SetHeatLossRate(player2, 0)
	CTRL.WAIT()
	SGroup_Kill(OutpostControl)
	SGroup_Kill(OutpostSwapControl)
	HintPoint_Remove(Hint1)
	HintPoint_Remove(Hint2)
	HintPoint_Remove(Hint3)
	HintPoint_Remove(Hint4)
	HintPoint_Remove(Hint5)
	HintPoint_Remove(Hint6)
	HintPoint_Remove(Hint7)
	CTRL.WAIT()
	SGroup_WarpToMarker(Kurt, mkr_artykurtwarp)
	SGroup_WarpToMarker(Otto, mkr_artyottowarp)
	SGroup_WarpToMarker(Hans, mkr_artyhanswarp)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_artykurtto)
	Cmd_Move(Otto, mkr_artyottoto)
	Cmd_Move(Hans, mkr_artyhansto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text160)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text161)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text162)
	CTRL.WAIT()
	Player_SetHeatLossRate(player1, 1)
	Player_SetHeatLossRate(player2, 1)
	CTRL.WAIT()
	Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
    Camera_ResetToDefault()
	CTRL.WAIT()

end

EVENTS.OutpostReportBackDialogue = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text163)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text164)
	CTRL.WAIT()

end

EVENTS.OutpostTankSwap = function()
    CTRL.WAIT()
	EGroup_DestroyAllEntities(AbandonedTank)
	FOW_RevealMarker(mkr_outpostartyswap, 9999)
	CTRL.WAIT()
	SGroup_WarpToMarker(OutpostArty, mkr_outpostartyswap)
	CTRL.WAIT()
    Modify_WeaponRange(OutpostArty, "hardpoint_01", 15)
    CTRL.WAIT()

end


EVENTS.PathCinematic = function()

	CTRL.WAIT()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(PathApel)
    Camera_SetZoomDist(20)
	CTRL.WAIT()
	HintPoint_Remove(Hint1)
	HintPoint_Remove(Hint2)
	HintPoint_Remove(Hint3)
	HintPoint_Remove(Hint4)
	HintPoint_Remove(Hint5)
	HintPoint_Remove(Hint6)
	HintPoint_Remove(Hint7)
	SGroup_Kill(OutpostControl)
	CTRL.WAIT()
	FOW_RevealMarker(mkr_pathvision, 9999)
	Player_SetHeatLossRate(player1, 0)
	Player_SetHeatLossRate(player2, 0)
	CTRL.WAIT()
	SGroup_WarpToMarker(Kurt, mkr_pathkurtwarp)
	SGroup_WarpToMarker(Otto, mkr_pathottowarp)
	SGroup_WarpToMarker(Hans, mkr_pathhanswarp)
	SGroup_WarpToMarker(Fitzgerald, mkr_pathfitzgeraldwarp)
	SGroup_WarpToMarker(ForwardSapper, mkr_pathsapperwarp)
	SGroup_WarpToMarker(ForwardTommy, mkr_pathtommywarp)
	SGroup_WarpToMarker(ForwardCommando, mkr_pathcommandowarp)
	SGroup_WarpToMarker(ForwardRanger, mkr_pathrangerwarp)
	SGroup_WarpToMarker(ForwardPara, mkr_pathparawarp)
	SGroup_WarpToMarker(ForwardEchelon, mkr_pathechelonwarp)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_pathkurtto)
	Cmd_Move(Otto, mkr_pathottoto)
	Cmd_Move(Hans, mkr_pathhansto)
	Cmd_Move(Fitzgerald, mkr_pathfitzgeraldto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text165)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text166)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Koch, Text167)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text168)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text169)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text170)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Koch, Text171)
	CTRL.WAIT()
	FOW_UnRevealMarker(mkr_pathvision)
	CTRL.WAIT()
	ColdCheck()
	CTRL.WAIT()
	Cmd_Move(PathApel, mkr_pathapeldespawn)
	Cmd_Move(Schneider, mkr_schneiderto1)
	Cmd_Move(PathFalls, mkr_schneiderto1)
	CTRL.WAIT()
	Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
    Camera_ResetToDefault()
	CTRL.WAIT()

end

EVENTS.SchneiderFireSupport = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Koch, Text172)
	CTRL.WAIT()

end

EVENTS.SchneiderSmokeSupport = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Koch, Text173)
	CTRL.WAIT()

end

EVENTS.PathSchneiderOver = function()

	CTRL.WAIT()
	Cmd_CriticalHit(player3, PathMichael, CRIT.VEHICLE_DESTROY_ENGINE, 1)
	SGroup_SetAvgHealth(Michael, 1)
	SGroup_SetInvulnerable(Tomislav, true)
	SGroup_SetInvulnerable(PathMichael, true)
	SGroup_DestroyAllSquads(Michael)
	SGroup_WarpToMarker(BridgeLeftPanther, mkr_bridgeleftpantherwarp)
	SGroup_WarpToMarker(BridgeRightPanther, mkr_bridgerightpantherwarp)
	SGroup_WarpToMarker(PathMichael, mkr_pathmichaelwarp)
	SGroup_WarpToMarker(Tomislav, mkr_pathtomislavwarp)
	SGroup_WarpToMarker(Dmitriy, mkr_pathdmitriywarp)
	SGroup_WarpToMarker(Nikolai, mkr_pathnikolaiwarp)
	SGroup_WarpToMarker(Viktor, mkr_pathviktorwarp)
	SGroup_WarpToMarker(Vladilen, mkr_pathvladilenwarp)
	SGroup_WarpToMarker(Stator, mkr_pathstatorwarp)
	SGroup_WarpToMarker(Yuri, mkr_pathyuriwarp)
	SGroup_WarpToMarker(Aleksei, mkr_pathalekseiwarp)
	SGroup_WarpToMarker(RearTommy, mkr_reartommywarp)
	SGroup_WarpToMarker(RearRifle, mkr_rearriflewarp)
	SGroup_WarpToMarker(LeftIS, mkr_leftiswarp)
	SGroup_WarpToMarker(RightIS, mkr_rightiswarp)
	SGroup_WarpToMarker(MiddleISU, mkr_isuwarp)
	Util_CreateSquads(player6, SovietGroup, SBP.SOVIET.PENAL_BATTALION_MP, mkr_leftspawnpoint)
	Util_CreateSquads(player6, SovietGroup, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_leftspawnpoint)
	Util_CreateSquads(player6, SovietGroup, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_leftspawnpoint)
	Util_CreateSquads(player6, SovietGroup, SBP.SOVIET.PENAL_BATTALION_MP, mkr_rightspawnpoint)
	Util_CreateSquads(player6, SovietGroup, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_rightspawnpoint)
	Util_CreateSquads(player6, SovietGroup, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_rightspawnpoint)
	CTRL.WAIT()
	SGroup_SnapFaceEachOther(PathMichael, MiddleISU)
	Cmd_AttackMove(SovietGroup, mkr_sovietgroupto)
	Command_SquadEntityLoad(player3, Yuri, SCMD_Load, MillHouse, false, true)
	Command_SquadEntityLoad(player3, Aleksei, SCMD_Load, MillHouse, false, true)
	CTRL.WAIT()
	SGroup_SetInvulnerable(SovietGroup, true)
	SGroup_SetInvulnerable(RearGroup, true)
	CTRL.WAIT()
	SGroup_Kill(BridgeLeftPanther)
	SGroup_Kill(BridgeRightPanther)
	SGroup_DestroyAllSquads(BridgeInfantry)
	SGroup_DestroyAllSquads(RearSapper)
	SGroup_DestroyAllSquads(RearEngineer)
	SGroup_DestroyAllSquads(RearEchelon)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text174)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text175)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text176)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text177)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text178)
	CTRL.WAIT()
	SGroup_SetInvulnerable(Kurt, true)
	SGroup_SetInvulnerable(Otto, true)
	SGroup_SetInvulnerable(Hans, true)
	CTRL.WAIT()
	SGroup_DestroyAllSquads(OutpostArty)
	Cmd_Retreat(Kurt, mkr_pathretreateventtrigger)
	Cmd_Retreat(Otto, mkr_pathretreateventtrigger)
	Cmd_Retreat(Hans, mkr_pathretreateventtrigger)
	Blip10 = UI_CreateMinimapBlip(PathMichael, 9000, BT_ObjectivePrimary)
	UI_DeleteMinimapBlip(Blip9)
	CTRL.WAIT()

end

VIN = {}

        Text179 = Util_CreateLocString("You are back! It's the damned Red Army! They do not care what our Soviets has to say. They just opened fire on us!")
		Text180 = Util_CreateLocString("Comrades they want the gold! They think we are all traitors and in league with your task force people!")
		Text181 = Util_CreateLocString("This is not going to hold! We need to...")
		Text182 = Util_CreateLocString("Tomislav NO!!!")
		Text183 = Util_CreateLocString("Wittman, let's go! Pull back damn it!")
		Text184 = Util_CreateLocString("I am trying! I think my fucking engine is gone!")
		
		Text185 = Util_CreateLocString("Damn it Wittman! No!!!")
		Text186 = Util_CreateLocString("Go comrades. Get back and tell the others to run as fast as they can! The Red Army will not be far behind and they will not keep prisoners!")
		Text187 = Util_CreateLocString("I die today with my true comrades!")
		
		Text188 = Util_CreateLocString("Where the hell is the rearguard?")
		Text189 = Util_CreateLocString("They are dead.")
		Text190 = Util_CreateLocString("Ah hell... Just... Get across the bridge will you? We gotta get across it!")
		
		Text191 = Util_CreateLocString("Come on you pieces of shit! Come and get me you fucking assholes!")
		
		Text192 = Util_CreateLocString("Don't shit yourself men.")
		Text193 = Util_CreateLocString("I suppose I could tell you it's a surprise to see you all... Although frankly who else could make it this far except you?")
		Text194 = Util_CreateLocString("You...")
		Text195 = Util_CreateLocString("Commander Apel. What a strange place to meet you again...")
		Text196 = Util_CreateLocString("Wilhelm... It has been a long time. I really do not care about the train. I just want to press on to Zurich. Please let us pass.")
		Text197 = Util_CreateLocString("You know I can't do that Otto. Especially since you are also headed to Zurich. No loose ends as we say. You should know that, seeing as you used to be part of Task Force Eva.")
		Text198 = Util_CreateLocString("Commander, we do not need any more fighting. We will not say anything. We do not even know where you are going!")
		Text199 = Util_CreateLocString("Oh?... You may not know Kurt, but Otto might, and that's a risk I am not willing to take.")
		Text200 = Util_CreateLocString("No more Wilhelm! Stop this! We do not need to kill each other...")
		Text201 = Util_CreateLocString("I... I have spent months waiting for this moment! Months just to see you in person. I will kill you myself Apel!")
		Text202 = Util_CreateLocString("No Hans... We just want to...")
		Text203 = Util_CreateLocString("THIS BASTARD KILLED MY WIFE!!!")
		Text204 = Util_CreateLocString("Hans, as I told you back in Italy, your wife's death is not my fault. I never sought her death.")
		Text205 = Util_CreateLocString("No... Blood for blood. Apel... You die today. This is where it ends.")
		Text206 = Util_CreateLocString("I will kill you myself!!!")
		Text207 = Util_CreateLocString("Wait! Hans wait!... God damn it Hans listen to me!!!")
		
		Text208 = Util_CreateLocString("Damn it! What was that about?!")
		Text209 = Util_CreateLocString("I do not know. Hans never told me anything about that.")
		Text210 = Util_CreateLocString("Look over there! All these supplies... We should take some before going further. Wilhelm is not a fool, so we have to be ready for whatever comes next.")
	
		Text211 = Util_CreateLocString("I never wanted this Hans. But I am not going to die here after all this time!")
		Text212 = Util_CreateLocString("Argh!!!")
		
		Text213 = Util_CreateLocString("You... You killed Hans...")
		Text214 = Util_CreateLocString("He didn't have to die. Because he was here for one and only one purpose. To kill me.")
		Text215 = Util_CreateLocString("You, I'm afraid, are not going anywhere tonight. There is too much risk leaving you two alive on the train's whereabouts.")
		Text216 = Util_CreateLocString("Stop, commander! We do not care about the train or the gold!")
		Text217 = Util_CreateLocString("Ah! There it is... I don't recall ever telling you about the gold Kurt. Clearly you've been told too much... That is an unacceptable risk for me, or the Fatherland.")
		Text218 = Util_CreateLocString("This train behind me holds the only future possible for our Fatherland now. Do you not see the vital importance of the task force's mission? Of my mission?")
		Text219 = Util_CreateLocString("Everything Task Force Eva has done up until this point has been for this singular purpose. Every pain, suffering and death for this one single train")
		Text220 = Util_CreateLocString("I will not let the sacrifices of countless others be in vain. It is something worth dying for.")
		Text221 = Util_CreateLocString("I stand here now, so close to the final destination. You two traitors will not hold the future of our people hostage. This ends here and now!")
		Text222 = Util_CreateLocString("Then it seems you cannot be dissuaded. Come Kurt... We may not have wanted this, but it is no different to any other opponent we faced so far.")
		Text223 = Util_CreateLocString("Let us fight on. One last time Kurt...")
		Text224 = Util_CreateLocString("One last time, Otto!")
		
		Text225 = Util_CreateLocString("Fire control, I require an artillery barrage at the pre-defined co-ordinates now!")
		Text226 = Util_CreateLocString("Airbase! I require an incendiary bombing run at the pre-defined co-ordinates now!")
		Text227 = Util_CreateLocString("Airbase! I require a fragmentation bombing run at the pre-defined co-ordinates now!")
		
		Text228 = Util_CreateLocString("It would seem I need some heavier weapons to get rid of you two!")
		
		
VIN.PathMillCombat = function()

	CTRL.WAIT()
	SGroup_SetInvulnerable(Kurt, true)
	SGroup_SetInvulnerable(Otto, true)
	SGroup_SetInvulnerable(Hans, true)
	SGroup_SetInvulnerable(RearRifle, false)
	SGroup_SetInvulnerable(RearTommy, false)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Tomislav, Text179)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text180)
	CTRL.WAIT()
	SGroup_WarpToMarker(SovietSniper, mkr_sniperwarp)
	SGroup_Kill(Nikolai)
	SGroup_SetInvulnerable(Tomislav, false)
	CTRL.WAIT()
	Cmd_Attack(SovietSniper, Tomislav)
	local Direction = Marker_GetDirection(mkr_bombdirection)
	Cmd_Ability(player6, ABILITY.SOVIET.IL_2_PRECISION_BOMB_STRIKE, mkr_bombtarget, Direction, true, false)
	CTRL.Actor_PlaySpeech(ACTOR.Tomislav, Text181)
	CTRL.WAIT()
	SGroup_Kill(Vladilen)
	SGroup_Kill(Stator)
	SGroup_Kill(Tomislav)
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text182)
	CTRL.WAIT()
	SGroup_Kill(Viktor)
	SGroup_Kill(Yuri)
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text183)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text184)
	CTRL.WAIT()
	Cmd_Attack(MiddleISU, PathMichael)
	SGroup_SetInvulnerable(PathMichael, false)
	CTRL.WAIT()

end

VIN.PathMillRetreat = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text185)
	CTRL.WAIT()
	SGroup_Kill(Yuri)
	SGroup_Kill(Aleksei)
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text186)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text187)
	CTRL.WAIT()
	SGroup_SetInvulnerable(Dmitriy, false)
	Cmd_Retreat(Kurt, mkr_outpostretreatpoint)
	Cmd_Retreat(Otto, mkr_outpostretreatpoint)
	Cmd_Retreat(Hans, mkr_outpostretreatpoint)
	SGroup_WarpToMarker(PathTiger, mkr_pathtigerwarp)
	Util_CreateSquads(player5, PathSecondGren, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_pathinfantryleftspawn)
	Util_CreateSquads(player5, PathSecondPanzerGren, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_pathinfantryleftspawn)
	Util_CreateSquads(player5, PathSecondSturm, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_pathinfantryleftspawn)
	Util_CreateSquads(player5, PathSecondVolks, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_pathinfantryrightspawn)
	Util_CreateSquads(player5, PathSecondStorm, SBP.GERMAN.STORMTROOPER_SQUAD_MP, mkr_pathinfantryrightspawn)
	Util_CreateSquads(player5, PathSecondAssGren, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_pathinfantryrightspawn)
	CTRL.WAIT()
	SGroup_SetInvulnerable(PathSecondGren, true)
	SGroup_SetInvulnerable(PathSecondPanzerGren, true)
	SGroup_SetInvulnerable(PathSecondSturm, true)
	SGroup_SetInvulnerable(PathSecondVolks, true)
	SGroup_SetInvulnerable(PathSecondStorm, true)
	SGroup_SetInvulnerable(PathSecondAssGren, true)
	CTRL.WAIT()
	local ExtraEliteName1 = Util_CreateLocString("6th Special Operations")
    HintMouseover_Add(ExtraEliteName1, PathSecondGren, 5, true)
    SGroup_IncreaseVeterancyRank(PathSecondGren, 3, false)
	local ExtraEliteName2 = Util_CreateLocString("12th Special Operations")
    HintMouseover_Add(ExtraEliteName2, PathSecondPanzerGren, 5, true)
    SGroup_IncreaseVeterancyRank(PathSecondPanzerGren, 3, false)
	local ExtraEliteName3 = Util_CreateLocString("20th Special Operations")
    HintMouseover_Add(ExtraEliteName3, PathSecondSturm, 5, true)
    SGroup_IncreaseVeterancyRank(PathSecondSturm, 5, false)
	local ExtraEliteName4 = Util_CreateLocString("32nd Special Operations")
    HintMouseover_Add(ExtraEliteName4, PathSecondVolks, 5, true)
    SGroup_IncreaseVeterancyRank(PathSecondVolks, 5, false)
	local ExtraEliteName5 = Util_CreateLocString("4th Special Operations")
    HintMouseover_Add(ExtraEliteName5, PathSecondStorm, 5, true)
    SGroup_IncreaseVeterancyRank(PathSecondStorm, 3, false)
	local ExtraEliteName6 = Util_CreateLocString("47th Special Operations")
    HintMouseover_Add(ExtraEliteName6, PathSecondAssGren, 5, true)
    SGroup_IncreaseVeterancyRank(PathSecondAssGren, 3, false)
	CTRL.WAIT()
	Cmd_AttackMove(PathSecondGren, mkr_pathleftenemyto)
	Cmd_AttackMove(PathSecondPanzerGren, mkr_pathleftenemyto)
	Cmd_AttackMove(PathSecondSturm, mkr_pathleftenemyto)
	Cmd_AttackMove(PathSecondVolks, mkr_pathrightenemyto)
	Cmd_AttackMove(PathSecondStorm, mkr_pathrightenemyto)
	Cmd_AttackMove(PathSecondAssGren, mkr_pathrightenemyto)
	CTRL.WAIT()
	Blip11 = UI_CreateMinimapBlip(Fitzgerald, 9000, BT_ObjectivePrimary)
	UI_DeleteMinimapBlip(Blip10)
	CTRL.WAIT()
	CTRL.Event_Delay(10)
	CTRL.WAIT()
	SGroup_SetInvulnerable(Kurt, false)
	SGroup_SetInvulnerable(Otto, false)
	SGroup_SetInvulnerable(Hans, false)
	CTRL.WAIT()

end

VIN.PathBridgeCombat = function()

	CTRL.WAIT()
	Player_SetHeatLossRate(player1, 0)
	Player_SetHeatLossRate(player2, 0)
	CTRL.WAIT()
	World_GetCurrentInteractionStage()
    World_IncreaseInteractionStage()
	CTRL.WAIT()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(20)
	CTRL.WAIT()
	SGroup_SetInvulnerable(Kurt, true)
	SGroup_SetInvulnerable(Otto, true)
	SGroup_SetInvulnerable(Hans, true)
	CTRL.WAIT()
	SGroup_WarpToMarker(Kurt, mkr_pathkurtsecondwarp)
	SGroup_WarpToMarker(Otto, mkr_pathottosecondwarp)
	SGroup_WarpToMarker(Hans, mkr_pathhanssecondwarp)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_pathkurtsecondto)
	Cmd_Move(Otto, mkr_pathottosecondto)
	Cmd_Move(Hans, mkr_pathhanssecondto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text188)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text189)
	CTRL.WAIT()
	Cmd_Move(PathTiger, mkr_pathtigerto)
	CTRL.WAIT()
	ColdCheck()
	CTRL.WAIT()
	Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
    Camera_ResetToDefault()
	CTRL.WAIT()
	SGroup_WarpToMarker(Kurt, mkr_pathkurtsecondto)
	SGroup_WarpToMarker(Otto, mkr_pathottosecondto)
	SGroup_WarpToMarker(Hans, mkr_pathhanssecondto)
	CTRL.WAIT()
	Cmd_Retreat(Kurt, mkr_finaleretreatpoint)
	Cmd_Retreat(Otto, mkr_finaleretreatpoint)
	Cmd_Retreat(Hans, mkr_finaleretreatpoint)
	Cmd_Retreat(Fitzgerald, mkr_finalefitzgeraldretreatpoint)
	Blip12 = UI_CreateMinimapBlip(Point8, 9000, BT_ObjectivePrimary)
	UI_DeleteMinimapBlip(Blip11)
	CTRL.WAIT()
	CTRL.Event_Delay(4)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text190)
	CTRL.WAIT()

end

VIN.PathFitzgeraldDeath = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text191)
	CTRL.WAIT()
	SGroup_SetInvulnerable(Kurt, false)
	SGroup_SetInvulnerable(Otto, false)
	SGroup_SetInvulnerable(Hans, false)
	CTRL.WAIT()
	CTRL.Event_Delay(10)
	CTRL.WAIT()
	EGroup_Kill(PathBridge)
	CTRL.WAIT()

end

VIN.FinaleBridgeDialogue = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text191)
	CTRL.WAIT()
	SGroup_SetInvulnerable(Kurt, false)
	SGroup_SetInvulnerable(Otto, false)
	SGroup_SetInvulnerable(Hans, false)
	CTRL.WAIT()
	CTRL.Event_Delay(10)
	CTRL.WAIT()
	EGroup_Kill(PathBridge)
	CTRL.WAIT()

end

VIN.FinaleInitialApelDialogue = function()

	CTRL.WAIT()
	World_GetCurrentInteractionStage()
    World_IncreaseInteractionStage()
	CTRL.WAIT()
	Player_SetHeatLossRate(player1, 0)
	Player_SetHeatLossRate(player2, 0)
	CTRL.WAIT()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_MoveTo(mkr_finalecamera)
    Camera_SetZoomDist(30)
	CTRL.WAIT()
	SGroup_SetPlayerOwner(Hans, player3)
	SGroup_SetInvulnerable(Hans, true)
	SGroup_SetInvulnerable(Wilhelm, true)
	CTRL.WAIT()
	SGroup_WarpToMarker(Kurt, mkr_finalekurtwarp)
	SGroup_WarpToMarker(Otto, mkr_finaleottowarp)
	SGroup_WarpToMarker(Hans, mkr_finalehanswarp)
	SGroup_WarpToMarker(FinaleApel, mkr_finaleapelwarp)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_finalekurtto1)
	Cmd_Move(Otto, mkr_finaleottoto1)
	Cmd_Move(Hans, mkr_finalehansto1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text192)
	CTRL.WAIT()
    CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text193)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text194)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text195)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text196)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text197)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text198)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text199)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text200)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text201)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text202)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text203)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text204)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text205)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text206)
	CTRL.WAIT()
	Cmd_Retreat(FinaleApel, mkr_wilhelmretreatto)
	Cmd_Retreat(Hans, mkr_finalehanssecondwarp)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text207)
	CTRL.WAIT()
	Camera_Follow(Kurt)
	CTRL.WAIT()
	Cmd_Retreat(Kurt, mkr_finalekurtretreatto)
	Cmd_Retreat(Otto, mkr_finaleottoretreatto)
	CTRL.WAIT()

end

VIN.FinaleSupplyDialogue = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text208)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text209)
	CTRL.WAIT()
	Command_Squad(player1, Kurt, SCMD_SlotItemRemove, false)
	Command_Squad(player1, Otto, SCMD_SlotItemRemove, false)
	Command_Squad(player2, Kurt, SCMD_SlotItemRemove, false)
	Command_Squad(player2, Otto, SCMD_SlotItemRemove, false)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text210)
	CTRL.WAIT()
	local TextSupply = Util_CreateLocString("Kurt and Otto have dropped their weapons. You now have a chance to choose another weapon from this supply cache before proceeding further.")
    HintSupply = HintPoint_Add(mkr_supplyhintpoint, true, TextSupply)
	CTRL.WAIT()
	Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
    Camera_ResetToDefault()
	CTRL.WAIT()
	ColdCheck()
	CTRL.WAIT()

end

VIN.FinaleFightSceneOne = function()

	CTRL.WAIT()
	World_GetCurrentInteractionStage()
    World_IncreaseInteractionStage()
	CTRL.WAIT()
	Player_SetHeatLossRate(player1, 0)
	Player_SetHeatLossRate(player2, 0)
	CTRL.WAIT()
	FOW_RevealMarker(mkr_finalevision, 9999)
	SGroup_SetPlayerOwner(TrainThree, player3)
	CTRL.WAIT()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_MoveTo(mkr_finalefightscenecamera)
    Camera_SetZoomDist(15)
	CTRL.WAIT()
	SGroup_SetInvulnerable(Kurt, true)
	SGroup_SetInvulnerable(Otto, true)
	SGroup_SetInvulnerable(Hans, true)
	SGroup_SetInvulnerable(Wilhelm, true)
	CTRL.WAIT()
	SGroup_WarpToMarker(Kurt, mkr_finalefightkurtwarp)
	SGroup_WarpToMarker(Otto, mkr_finalefightottowarp)
	SGroup_WarpToMarker(Hans, mkr_finalefighthanswarp)
	CTRL.WAIT()
	Cmd_Move(FortBodyguard, mkr_finalebodyguardtravel)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text211)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text212)
	CTRL.WAIT()
	SGroup_WarpToMarker(Kurt, mkr_finalekurttravel)
	SGroup_WarpToMarker(Otto, mkr_finaleottotravel)
	SGroup_Kill(HansControl)
	CTRL.WAIT()
	
end

VIN.FinaleFightSceneTwo = function()

	CTRL.WAIT()
	SGroup_SetPlayerOwner(Wilhelm, player3)
	SGroup_SetPlayerOwner(FortBodyguard, player3)
	Cmd_Move(Kurt, mkr_finalekurtto)
	Cmd_Move(Otto, mkr_finaleottoto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text213)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text214)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text215)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text216)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text217)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text218)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text219)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text220)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text221)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text222)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text223)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text224)
	CTRL.WAIT()
	SGroup_SetPlayerOwner(Wilhelm, player5)
	SGroup_SetPlayerOwner(FortBodyguard, player5)
	CTRL.WAIT()
	Cmd_Move(TrenchMidSturm, mkr_finalesturmto)
	Cmd_Move(TrenchMidOber, mkr_finaleoberto)
	Cmd_Move(TrenchLeftAssGren, mkr_finaleassgrento)
	CTRL.WAIT()
	Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
    Camera_ResetToDefault()
	CTRL.WAIT()
	FOW_UnRevealMarker(mkr_finalevision)
	CTRL.WAIT()
	SGroup_SetInvulnerable(Kurt, false)
	SGroup_SetInvulnerable(Otto, false)
	SGroup_SetInvulnerable(Wilhelm, false)
	SGroup_SetInvulnerable(FortBodyguard, false)
	CTRL.WAIT()
	SGroup_SetPlayerOwner(TrainThree, player5)
	SGroup_Hide(TrainThree, false)
	SGroup_EnableMinimapIndicator(TrainThree, true)
	CTRL.WAIT()
	TrainDepartCheck()
	CTRL.WAIT()
	ColdCheck()
	CTRL.WAIT()
	SGroup_Kill(FinaleAirstrikeControl)
	CTRL.WAIT()

end

VIN.WilhelmDialogueOne = function()

	CTRL.WAIT()
	local Target = Player_GetSquadConcentration(player1)
	local Direction = Marker_GetDirection(mkr_finalewilhelmdirection)
	Cmd_Ability(player5, ABILITY.AEF.TIME_ON_TARGET_ARTILLERY, Target, Direction, true, false)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text225)
	CTRL.WAIT()

end

VIN.WilhelmDialogueTwo = function()

	CTRL.WAIT()
	local Target = Player_GetSquadConcentration(player1)
    local Direction = Marker_GetDirection(mkr_finalewilhelmdirection)
	Cmd_Ability(player5, ABILITY.GERMAN.STUKA_INCENDIARY_BOMBS, Target, Direction, true, false)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text226)
	CTRL.WAIT()

end

VIN.WilhelmDialogueThree = function()

	CTRL.WAIT()
	local Target = Player_GetSquadConcentration(player1)
    local Direction = Marker_GetDirection(mkr_finalewilhelmdirection)
	Cmd_Ability(player5, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB, Target, Direction, true)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text227)
	CTRL.WAIT()

end

VIN.WilhelmFifty = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Wilhelm, Text228)
	CTRL.WAIT()
	local WeaponEntity1 = SGroup_GetSpawnedSquadAt(Wilhelm, 1)
    Squad_GiveSlotItem(WeaponEntity1, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_NO_PRONE_MP)
	CTRL.WAIT()

end
