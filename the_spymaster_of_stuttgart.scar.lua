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
		
		Cinematic()
		
		Rule_AddDelayedInterval(SafeguardAI, 1, 1)

		Rule_AddOneShot(DelayAI, 60)
		
		Rule_AddDelayedInterval(MeetAmericans, 1, 1)
		
		PointOne()
		PointTwo()
		PointThree()
		PointFour()
		PointFive()
		PointSix()
		
		Lose()
		
        Elites()

        EliteNames()
		
        Upgrade()
	
        Abilities()

        BuildingRestrict()

end

Scar_AddInit(OnInit)

function Custom()

        AI_EnableAll(false)
        UI_SetAllowLoadAndSave(false)
		
		EGroup_Kill(StartBridge)
		
		EGroup_SetInvulnerable(WoodBridges, true)

	    Player_SetPopCapOverride(player1, 200)
	    Player_SetPopCapOverride(player2, 200)
		Player_SetPopCapOverride(player3, 200)
		Player_SetPopCapOverride(player4, 900)
	    Player_SetPopCapOverride(player5, 900)
		Player_SetPopCapOverride(player6, 900)
		Player_SetPopCapOverride(player7, 900)
		Player_SetPopCapOverride(player8, 900)
		
		local StartTextOne = Util_CreateLocString("Being spotted by the enemy will cause enemy patrols to be dispatched to find you. Being spotted by the patrols will cause all enemies in the nearby area to enter active combat")
		local StartTextTwo = Util_CreateLocString("Capture strategic points to progress to the next area. Enemies in the previous area will not disappear so be careful when choosing to retreat")
		local StartTextThree = Util_CreateLocString("Mission failure will occur if Kbal, Neeps or Shannon die (Officer, Royal Engineer and Tommy respectively)")
		local StartTextFour = Util_CreateLocString("Your retreat point will always be set at the location of the last strategic point you captured. Do not worry if the enemy re-captures a point, you will not lose the game because of it but your retreat point will remain there")
        StartHint1 = HintPoint_Add(mkr_hint1, true, StartTextOne)
		StartHint2 = HintPoint_Add(mkr_hint2, true, StartTextTwo)
		StartHint3 = HintPoint_Add(mkr_hint3, true, StartTextThree)
		StartHint4 = HintPoint_Add(mkr_hint4, true, StartTextFour)
		
		Blip1 = UI_CreateMinimapBlip(Point1, 9000, BT_ObjectivePrimary)
		
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("tommy_medical_supplies"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("platoon_aec_research_building_mp"))
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("platoon_aec_research_mp"))
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("tech_structure_1_construct_mp"))
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("tech_structure_1_mp"))
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("tech_structure_2_construct_mp"))
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("tech_structure_2_mp"))
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("tommy_mills_bomb_mp"))
		Player_SetUpgradeAvailability(player3, UPG.BRITISH.TOMMY_MEDICAL_SUPPLIES, ITEM_UNLOCKED)
		Player_SetUpgradeAvailability(player3, UPG.BRITISH.TOMMY_MILLS_BOMB_MP, ITEM_UNLOCKED)
		
		SGroup_SetInvulnerable(Canaris, true)
		
		
end

function Cinematic()

        Util_StartIntel(EVENTS.StartCinematic)

end

function SafeguardAI()
	
	    AI_Enable(player4, false)
		AI_Enable(player8, false)

end

function DelayAI()
	
	    AI_Enable(player5, true)
        AI_Enable(player6, true)
        AI_Enable(player7, true)

end

function MeetAmericans()

        local Control = SGroup_CanSeeSGroup(AmericansAll, PlayersAll, false)
		if Control == true then
                
		end
end



------------------------Point One-----------------------

function PointOne()

        Rule_AddDelayedInterval(SpottedCreateOne, 1, 10)
        Rule_AddDelayedInterval(SpottedMoveOne, 1, 5)
		Rule_AddDelayedInterval(SpottedPatrolOne, 1, 1)
		Rule_AddDelayedInterval(CapturedPointOne, 1, 1)

end

function SpottedCreateOne()

        local Control1 = SGroup_CanSeeSGroup(AllAreaOne, PlayersAll, false)
		local Control2 = SGroup_CanSeeSGroup(AreaPatrolOne, PlayersAll, false)
		if Control1 == true or Control2 == true then
                local ControlCount = SGroup_Count(AreaPatrolOne)
                if ControlCount == 0 then
		                local Random = World_GetRand(1, 3)
			         	if Random == 1 then
                                local Target = Player_GetSquadConcentration(player1)
			                 	Util_CreateSquads(player8, AreaPatrolOne, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_areapatrolonespawn)
				        		Cmd_AttackMove(AreaPatrolOne, Target)
								local WarningText = Util_CreateLocString("Enemy patrol has been dispatched to your location")
	                            Warning = WinWarning_ShowLoseWarning(WarningText, 2, 5, 2)
                        elseif Random == 2 then
                                local Target = Player_GetSquadConcentration(player2)
			                	Util_CreateSquads(player8, AreaPatrolOne, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_areapatrolonespawn)
					        	Cmd_AttackMove(AreaPatrolOne, Target)
								local WarningText = Util_CreateLocString("Enemy patrol has been dispatched to your location")
	                            Warning = WinWarning_ShowLoseWarning(WarningText, 2, 5, 2)
                        elseif Random == 3 then
                                local Target = Player_GetSquadConcentration(player3)
			                 	Util_CreateSquads(player8, AreaPatrolOne, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_areapatrolonespawn)
					        	Cmd_AttackMove(AreaPatrolOne, Target)
								local WarningText = Util_CreateLocString("Enemy patrol has been dispatched to your location")
	                            Warning = WinWarning_ShowLoseWarning(WarningText, 2, 5, 2)
						end
	        	end	
		end
end

function SpottedMoveOne()

        local Control1 = SGroup_CanSeeSGroup(AllAreaOne, PlayersAll, false)
		local Control2 = SGroup_CanSeeSGroup(AreaPatrolOne, PlayersAll, false)
		if Control1 == true or Control2 == true then
		        local Random = World_GetRand(1, 3)
				if Random == 1 then
                        local Target = Player_GetSquadConcentration(player1)
						Cmd_AttackMove(AreaPatrolOne, Target)
                elseif Random == 2 then
                        local Target = Player_GetSquadConcentration(player2)
						Cmd_AttackMove(AreaPatrolOne, Target)
                elseif Random == 3 then
                        local Target = Player_GetSquadConcentration(player3)
						Cmd_AttackMove(AreaPatrolOne, Target)
	        	end	
		end
end

function SpottedPatrolOne()

        local Control1 = SGroup_IsUnderAttack(AreaPatrolOne, false, 9000)
        if Control1 == true or Control2 == true then
                SGroup_SetPlayerOwner(AllAreaOne, player5)
				Rule_RemoveMe()
		end
end

function CapturedPointOne()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point1, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point1, player2, false)
		local PointFocus3 = EGroup_IsCapturedByPlayer(Point1, player3, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true then
                Util_StartIntel(EVENTS.DialogueOne)
				Blip2 = UI_CreateMinimapBlip(Point2, 9000, BT_ObjectivePrimary)
				UI_DeleteMinimapBlip(Blip1)
				World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
				HintPoint_Remove(StartHint1)
				HintPoint_Remove(StartHint2)
				HintPoint_Remove(StartHint3)
				HintPoint_Remove(StartHint4)
				local RetreatEntity1 = EGroup_GetSpawnedEntityAt(RetreatOneOne, 1)
				local RetreatEntity2 = EGroup_GetSpawnedEntityAt(RetreatOneTwo, 1)
				local RetreatEntity3 = EGroup_GetSpawnedEntityAt(RetreatOneThree, 1)
                local DestroyEntity1 = EGroup_GetSpawnedEntityAt(StartRetreatOne, 1)
				local DestroyEntity2 = EGroup_GetSpawnedEntityAt(StartRetreatTwo, 1)
				local DestroyEntity3 = EGroup_GetSpawnedEntityAt(StartRetreatThree, 1)
                Entity_SetPlayerOwner(RetreatEntity1, player1)
				Entity_SetPlayerOwner(RetreatEntity2, player2)
				Entity_SetPlayerOwner(RetreatEntity3, player3)
                Entity_Destroy(DestroyEntity1)
				Entity_Destroy(DestroyEntity2)
				Entity_Destroy(DestroyEntity3)
                Rule_RemoveMe()
        end
end




------------------------Point Two-----------------------

function PointTwo()

        Rule_AddDelayedInterval(SpottedCreateTwo, 1, 10)
        Rule_AddDelayedInterval(SpottedMoveTwo, 1, 5)
		Rule_AddDelayedInterval(SpottedPatrolTwo, 1, 1)
		Rule_AddDelayedInterval(CapturedPointTwo, 1, 1)
		
		Rule_AddDelayedInterval(BanterStartOne, 1, 1)

end

function SpottedCreateTwo()

        local Control1 = SGroup_CanSeeSGroup(AllAreaTwo, PlayersAll, false)
		local Control2 = SGroup_CanSeeSGroup(AreaPatrolTwo, PlayersAll, false)
		if Control1 == true or Control2 == true then
                local ControlCount = SGroup_Count(AreaPatrolTwo)
                if ControlCount == 0 then
		                local Random = World_GetRand(1, 3)
			         	if Random == 1 then
                                local Target = Player_GetSquadConcentration(player1)
			                 	Util_CreateSquads(player8, AreaPatrolTwo, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_areapatroltwospawn)
				        		Cmd_AttackMove(AreaPatrolTwo, Target)
								local WarningText = Util_CreateLocString("Enemy patrol has been dispatched to your location")
	                            Warning = WinWarning_ShowLoseWarning(WarningText, 2, 5, 2)
                        elseif Random == 2 then
                                local Target = Player_GetSquadConcentration(player2)
			                	Util_CreateSquads(player8, AreaPatrolTwo, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_areapatroltwospawn)
					        	Cmd_AttackMove(AreaPatrolTwo, Target)
								local WarningText = Util_CreateLocString("Enemy patrol has been dispatched to your location")
	                            Warning = WinWarning_ShowLoseWarning(WarningText, 2, 5, 2)
                        elseif Random == 3 then
                                local Target = Player_GetSquadConcentration(player3)
			                 	Util_CreateSquads(player8, AreaPatrolTwo, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_areapatroltwospawn)
					        	Cmd_AttackMove(AreaPatrolTwo, Target)
								local WarningText = Util_CreateLocString("Enemy patrol has been dispatched to your location")
	                            Warning = WinWarning_ShowLoseWarning(WarningText, 2, 5, 2)
						end
	        	end	
		end
end

function SpottedMoveTwo()

        local Control1 = SGroup_CanSeeSGroup(AllAreaTwo, PlayersAll, false)
		local Control2 = SGroup_CanSeeSGroup(AreaPatrolTwo, PlayersAll, false)
		if Control1 == true or Control2 == true then
		        local Random = World_GetRand(1, 3)
				if Random == 1 then
                        local Target = Player_GetSquadConcentration(player1)
						Cmd_AttackMove(AreaPatrolTwo, Target)
                elseif Random == 2 then
                        local Target = Player_GetSquadConcentration(player2)
						Cmd_AttackMove(AreaPatrolTwo, Target)
                elseif Random == 3 then
                        local Target = Player_GetSquadConcentration(player3)
						Cmd_AttackMove(AreaPatrolTwo, Target)
	        	end	
		end
end

function SpottedPatrolTwo()

        local Control1 = SGroup_IsUnderAttack(AreaPatrolTwo, false, 9000)
        if Control1 == true or Control2 == true then
                SGroup_SetPlayerOwner(AllAreaTwo, player5)
				Rule_RemoveMe()
		end
end

function CapturedPointTwo()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point2, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point2, player2, false)
		local PointFocus3 = EGroup_IsCapturedByPlayer(Point2, player3, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true then
                Util_StartIntel(EVENTS.DialogueTwo)
				World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
				Blip3 = UI_CreateMinimapBlip(Point3, 9000, BT_ObjectivePrimary)
				UI_DeleteMinimapBlip(Blip2)
				local RetreatEntity1 = EGroup_GetSpawnedEntityAt(RetreatTwoOne, 1)
				local RetreatEntity2 = EGroup_GetSpawnedEntityAt(RetreatTwoTwo, 1)
				local RetreatEntity3 = EGroup_GetSpawnedEntityAt(RetreatTwoThree, 1)
                local DestroyEntity1 = EGroup_GetSpawnedEntityAt(RetreatOneOne, 1)
				local DestroyEntity2 = EGroup_GetSpawnedEntityAt(RetreatOneTwo, 1)
				local DestroyEntity3 = EGroup_GetSpawnedEntityAt(RetreatOneThree, 1)
                Entity_SetPlayerOwner(RetreatEntity1, player1)
				Entity_SetPlayerOwner(RetreatEntity2, player2)
				Entity_SetPlayerOwner(RetreatEntity3, player3)
                Entity_Destroy(DestroyEntity1)
				Entity_Destroy(DestroyEntity2)
				Entity_Destroy(DestroyEntity3)
                Rule_RemoveMe()
        end
end

function BanterStartOne()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_banteronetrigger, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_banteronetrigger, false)
		local Control3 = Prox_ArePlayersNearMarker(player3, mkr_banteronetrigger, false)
		if Control1 == true or Control2 == true or Control3 == true then
		        Util_StartIntel(EVENTS.BanterOne)
				Rule_RemoveMe()
        end
end


------------------------------Point Three---------------------------

function PointThree()

        Rule_AddDelayedInterval(CapturedPointThree, 1, 1)

end

function CapturedPointThree()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point3, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point3, player2, false)
		local PointFocus3 = EGroup_IsCapturedByPlayer(Point3, player3, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true then
                Util_StartIntel(EVENTS.DialogueThree)
				Blip4 = UI_CreateMinimapBlip(Point4, 9000, BT_ObjectivePrimary)
				UI_DeleteMinimapBlip(Blip3)
				local GowerText = Util_CreateLocString("You must now also keep Gower (the 3 star veteran commando unit) alive as well. Gower's death will result in mission failure")
                GowerHint = HintPoint_Add(mkr_gowerhintspot, true, GowerText)
				World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
				local RetreatEntity1 = EGroup_GetSpawnedEntityAt(RetreatThreeOne, 1)
				local RetreatEntity2 = EGroup_GetSpawnedEntityAt(RetreatThreeTwo, 1)
				local RetreatEntity3 = EGroup_GetSpawnedEntityAt(RetreatThreeThree, 1)
                local DestroyEntity1 = EGroup_GetSpawnedEntityAt(RetreatTwoOne, 1)
				local DestroyEntity2 = EGroup_GetSpawnedEntityAt(RetreatTwoTwo, 1)
				local DestroyEntity3 = EGroup_GetSpawnedEntityAt(RetreatTwoThree, 1)
                Entity_SetPlayerOwner(RetreatEntity1, player1)
				Entity_SetPlayerOwner(RetreatEntity2, player2)
				Entity_SetPlayerOwner(RetreatEntity3, player3)
                Entity_Destroy(DestroyEntity1)
				Entity_Destroy(DestroyEntity2)
				Entity_Destroy(DestroyEntity3)
                Rule_RemoveMe()
        end
end


---------------------------Point Four-----------------------------

function PointFour()

        Rule_AddDelayedInterval(CastleEntranceAttack, 1, 1)
        Rule_AddDelayedInterval(CastleMiddleAttack, 1, 1)
		Rule_AddDelayedInterval(CapturedPointFour, 1, 1)
		
		
		Rule_AddDelayedInterval(AmericanAttack, 1, 1)
		Rule_AddDelayedInterval(AmericansSafeguard, 1, 1)
		Rule_AddDelayedInterval(AmericansDeadOne, 1, 1)
		Rule_AddDelayedInterval(AmericansDeadTwo, 1, 1)

end

function CastleEntranceAttack()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_castletrigger, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_castletrigger, false)
		local Control3 = Prox_ArePlayersNearMarker(player3, mkr_castletrigger, false)
		if Control1 == true or Control2 == true or Control3 == true then
		        Cmd_Move(CastleLeft, mkr_castleleftattackto)
				Cmd_Move(CastleRight, mkr_castlerightattackto)
				Rule_RemoveMe()
        end
end

function CastleMiddleAttack()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_castlemiddletrigger, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_castlemiddletrigger, false)
		local Control3 = Prox_ArePlayersNearMarker(player3, mkr_castlemiddletrigger, false)
		if Control1 == true or Control2 == true or Control3 == true then
		        Cmd_Move(CastleMid, mkr_castlemidto)
				Rule_RemoveMe()
        end
end

function CapturedPointFour()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point4, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point4, player2, false)
		local PointFocus3 = EGroup_IsCapturedByPlayer(Point4, player3, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true then
                Util_StartIntel(EVENTS.DialogueFour)
				SGroup_Kill(AmericansControl)
				HintPoint_Remove(GowerHint)
				local RetreatEntity1 = EGroup_GetSpawnedEntityAt(RetreatFourOne, 1)
				local RetreatEntity2 = EGroup_GetSpawnedEntityAt(RetreatFourTwo, 1)
				local RetreatEntity3 = EGroup_GetSpawnedEntityAt(RetreatFourThree, 1)
                local DestroyEntity1 = EGroup_GetSpawnedEntityAt(RetreatThreeOne, 1)
				local DestroyEntity2 = EGroup_GetSpawnedEntityAt(RetreatThreeTwo, 1)
				local DestroyEntity3 = EGroup_GetSpawnedEntityAt(RetreatThreeThree, 1)
                Entity_SetPlayerOwner(RetreatEntity1, player1)
				Entity_SetPlayerOwner(RetreatEntity2, player2)
				Entity_SetPlayerOwner(RetreatEntity3, player3)
                Entity_Destroy(DestroyEntity1)
				Entity_Destroy(DestroyEntity2)
				Entity_Destroy(DestroyEntity3)
                Rule_RemoveMe()
        end
end

function AmericanAttack()

        local Control1 = SGroup_Count(AmericansControl)
		if Control1 == 0 then
		        local Control2 = SGroup_IsUnderAttack(AmericansAll, false, 9000)
				if Control2 == true then
				        Util_StartIntel(EVENTS.AmericanDialogue)
				        Rule_RemoveMe()
				end
		end
end

function AmericansSafeguard()

        local Control1 = SGroup_Count(AmericansAll)
        if Control1 == 0 then
                SGroup_Kill(CastleExtra)
                Rule_RemoveMe()
        end
end

function AmericansDeadOne()

        local Control1 = SGroup_Count(AmericansAll)
		local Control2 = SGroup_Count(CastleControl)
        if Control1 == 0 and Control2 == 1 then
		        Util_StartIntel(EVENTS.PursuitDialogue)
				World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
                SGroup_Kill(CastleControl)
				Cmd_Move(ScoutCarOne, mkr_scoutcar1to)
				Cmd_Move(ScoutCarTwo, mkr_scoutcar2to)
				SGroup_SetPlayerOwner(PlayerFiveGroup, player5)
				SGroup_SetPlayerOwner(PlayerSixGroup, player6)
				SGroup_SetPlayerOwner(PlayerSevenGroup, player7)
                Rule_RemoveMe()
        end
end

function AmericansDeadTwo()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_castletrigger, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_castletrigger, false)
		local Control3 = Prox_ArePlayersNearMarker(player3, mkr_castletrigger, false)
		if Control1 == true or Control2 == true or Control3 == true then
                local Control4 = SGroup_Count(AmericansAll)
		        local Control5 = SGroup_Count(CastleControl)
                if Control4 == 0 and Control5 == 1 then
				        Util_StartIntel(EVENTS.PursuitDialogue)
						World_GetCurrentInteractionStage()
                        World_IncreaseInteractionStage()
                        SGroup_Kill(CastleControl)
				        Cmd_Move(ScoutCarOne, mkr_scoutcar1to)
				        Cmd_Move(ScoutCarTwo, mkr_scoutcar2to)
				        SGroup_SetPlayerOwner(PlayerFiveGroup, player5)
				        SGroup_SetPlayerOwner(PlayerSixGroup, player6)
				        SGroup_SetPlayerOwner(PlayerSevenGroup, player7)
                        Rule_RemoveMe()
				end
        end
end


------------------------------Point Five-----------------------------

function PointFive()

        Rule_AddDelayedInterval(CapturedPointFive, 1, 1)

end

function CapturedPointFive()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point5, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point5, player2, false)
		local PointFocus3 = EGroup_IsCapturedByPlayer(Point5, player3, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true then
                Util_StartIntel(EVENTS.DialogueFive)
				World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
				Blip7 = UI_CreateMinimapBlip(Canaris, 9000, BT_ObjectivePrimary)
		        UI_DeleteMinimapBlip(Blip6)
				Cmd_Move(PointFiveAttack, mkr_pointfiveattackto)
				local RetreatEntity1 = EGroup_GetSpawnedEntityAt(RetreatFiveOne, 1)
				local RetreatEntity2 = EGroup_GetSpawnedEntityAt(RetreatFiveTwo, 1)
				local RetreatEntity3 = EGroup_GetSpawnedEntityAt(RetreatFiveThree, 1)
                local DestroyEntity1 = EGroup_GetSpawnedEntityAt(RetreatFourOne, 1)
				local DestroyEntity2 = EGroup_GetSpawnedEntityAt(RetreatFourTwo, 1)
				local DestroyEntity3 = EGroup_GetSpawnedEntityAt(RetreatFourThree, 1)
                Entity_SetPlayerOwner(RetreatEntity1, player1)
				Entity_SetPlayerOwner(RetreatEntity2, player2)
				Entity_SetPlayerOwner(RetreatEntity3, player3)
                Entity_Destroy(DestroyEntity1)
				Entity_Destroy(DestroyEntity2)
				Entity_Destroy(DestroyEntity3)
                Rule_RemoveMe()
        end
end


-----------------------------Point Six-----------------------------

function PointSix()

        Rule_AddDelayedInterval(CapturedPointSix, 1, 1)
		
		Rule_AddDelayedInterval(HillSideAttackOne, 1, 1)
		Rule_AddDelayedInterval(HillSideAttackTwo, 1, 1)
		Rule_AddDelayedInterval(CanarisFight, 1, 1)
		Rule_AddDelayedInterval(CanarisDeath, 1, 1)
		
		Rule_AddDelayedInterval(EscapePlaneOne, 1, 1)
	    Rule_AddDelayedInterval(EscapePlaneTwo, 1, 1)
		Rule_AddDelayedInterval(EscapePlaneThree, 1, 1)

end

function CapturedPointSix()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point6, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point6, player2, false)
		local PointFocus3 = EGroup_IsCapturedByPlayer(Point6, player3, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true then
                Util_StartIntel(EVENTS.EndDialogue)
                Rule_RemoveMe()
        end
end


function HillSideAttackOne()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_hilltrigger, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_hilltrigger, false)
		local Control3 = Prox_ArePlayersNearMarker(player3, mkr_hilltrigger, false)
		if Control1 == true or Control2 == true or Control3 == true then
                local Random = World_GetRand(1, 3)
				if Random == 1 then
                        local Target = Player_GetSquadConcentration(player1)
						Cmd_Move(HillAttackTop, Target)
						Cmd_Move(HillAttackBottom, Target)
						Cmd_AttackMove(HillCar, Target)
                elseif Random == 2 then
                        local Target = Player_GetSquadConcentration(player2)
						Cmd_Move(HillAttackTop, Target)
						Cmd_Move(HillAttackBottom, Target)
						Cmd_AttackMove(HillCar, Target)
                elseif Random == 3 then
                        local Target = Player_GetSquadConcentration(player3)
						Cmd_Move(HillAttackTop, Target)
						Cmd_Move(HillAttackBottom, Target)
						Cmd_AttackMove(HillCar, Target)
	        	end	
		end
end

function HillSideAttackTwo()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_hillsecondtrigger, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_hillsecondtrigger, false)
		local Control3 = Prox_ArePlayersNearMarker(player3, mkr_hillsecondtrigger, false)
		if Control1 == true or Control2 == true or Control3 == true then
                local Random = World_GetRand(1, 3)
				if Random == 1 then
                        local Target = Player_GetSquadConcentration(player1)
						Cmd_AttackMove(HillVolks, Target)
                elseif Random == 2 then
                        local Target = Player_GetSquadConcentration(player2)
						Cmd_AttackMove(HillVolks, Target)
                elseif Random == 3 then
                        local Target = Player_GetSquadConcentration(player3)
						Cmd_AttackMove(HillVolks, Target)
	        	end	
		end
end

function CanarisFight()

        local Control1 = SGroup_IsUnderAttack(Canaris, false, 9000)
        if Control1 == true then
                local Random = World_GetRand(1, 3)
				if Random == 1 then
						Util_StartIntel(EVENTS.KbalTraitor)
						Rule_RemoveMe()
                elseif Random == 2 then
                        Util_StartIntel(EVENTS.NeepsTraitor)
						Rule_RemoveMe()
                elseif Random == 3 then
						Util_StartIntel(EVENTS.ShannonTraitor)
						Rule_RemoveMe()
	        	end	
		end
end

function CanarisDeath()

        local Control1 = SGroup_Count(Canaris)
		local Control2 = SGroup_Count(Characters)
		if Control1 == 0 and Control2 == 2 then
                local Control3 = SGroup_Count(Kbal)
				local Control4 = SGroup_Count(Neeps)
				local Control5 = SGroup_Count(Shannon)
				if Control3 == 0 and Control4 == 1 and Control5 == 1 then
                        Util_StartIntel(EVENTS.AfterKbalDialogue)
						Rule_RemoveMe()
				elseif Control3 == 1 and Control4 == 0 and Control5 == 1 then
				        Util_StartIntel(EVENTS.AfterNeepsDialogue)
						Rule_RemoveMe()
				elseif Control3 == 1 and Control4 == 1 and Control5 == 0 then
				        Util_StartIntel(EVENTS.AfterShannonDialogue)
						Rule_RemoveMe()
	        	end	
		end
end

function EscapePlaneOne()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_planetrigger1, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_planetrigger1, false)
		local Control3 = Prox_ArePlayersNearMarker(player3, mkr_planetrigger1, false)
		if Control1 == true or Control2 == true or Control3 == true then
                local Control4 = SGroup_Count(Canaris)
				local Control5 = SGroup_Count(Characters)
				if Control4 == 0 and Control5 == 2 then
                        local Target = Marker_GetPosition(mkr_plane1)
                        local Direction = Marker_GetDirection(mkr_direction)
                        Cmd_Ability(player8, ABILITY.GERMAN.STUKA_INCENDIARY_BOMBS, Target, Direction, true)
						Rule_RemoveMe()
	        	end	
		end
end

function EscapePlaneTwo()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_planetrigger2, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_planetrigger2, false)
		local Control3 = Prox_ArePlayersNearMarker(player3, mkr_planetrigger2, false)
		if Control1 == true or Control2 == true or Control3 == true then
                local Control4 = SGroup_Count(Canaris)
				local Control5 = SGroup_Count(Characters)
				if Control4 == 0 and Control5 == 2 then
                        local Target = Marker_GetPosition(mkr_plane2)
                        local Direction = Marker_GetDirection(mkr_direction)
                        Cmd_Ability(player8, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB, Target, Direction, true)
						Rule_RemoveMe()
	        	end	
		end
end

function EscapePlaneThree()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_planetrigger3, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_planetrigger3, false)
		local Control3 = Prox_ArePlayersNearMarker(player3, mkr_planetrigger3, false)
		if Control1 == true or Control2 == true or Control3 == true then
                local Control4 = SGroup_Count(Canaris)
				local Control5 = SGroup_Count(Characters)
				if Control4 == 0 and Control5 == 2 then
                        local TargetOne = Marker_GetPosition(mkr_plane3)
						local TargetTwo = Marker_GetPosition(mkr_plane4)
                        local Direction = Marker_GetDirection(mkr_direction)
                        Cmd_Ability(player8, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB, TargetOne, Direction, true)
						Cmd_Ability(player8, ABILITY.GERMAN.STUKA_INCENDIARY_BOMBS, TargetTwo, Direction, true)
						Rule_RemoveMe()
	        	end	
		end
end

----------------------------Lose---------------------------------

function Lose()

        Rule_AddDelayedInterval(KbalLose, 1, 1)
		Rule_AddDelayedInterval(NeepsLose, 1, 1)
		Rule_AddDelayedInterval(ShannonLose, 1, 1)
		Rule_AddDelayedInterval(GowerLose, 1, 1)

end

function KbalLose()

        local Control1 = SGroup_Count(KbalControl)
		if Control1 == 1 then
                local Control2 = SGroup_Count(Kbal)
                if Control2 == 0 then
				        World_SetPlayerLose(player1)
                        World_SetPlayerLose(player2)
                        World_SetPlayerLose(player3)
			        	World_SetPlayerLose(player4)
                        Rule_RemoveMe()
				end
        end
end

function NeepsLose()

        local Control1 = SGroup_Count(NeepsControl)
		if Control1 == 1 then
                local Control2 = SGroup_Count(Neeps)
                if Control2 == 0 then
				        World_SetPlayerLose(player1)
                        World_SetPlayerLose(player2)
                        World_SetPlayerLose(player3)
			        	World_SetPlayerLose(player4)
                        Rule_RemoveMe()
				end
        end
end

function ShannonLose()

        local Control1 = SGroup_Count(ShannonControl)
		if Control1 == 1 then
                local Control2 = SGroup_Count(Shannon)
                if Control2 == 0 then
				        World_SetPlayerLose(player1)
                        World_SetPlayerLose(player2)
                        World_SetPlayerLose(player3)
			        	World_SetPlayerLose(player4)
                        Rule_RemoveMe()
				end
        end
end

function GowerLose()

        local Control2 = SGroup_Count(Gower)
        if Control2 == 0 then
				World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
			    World_SetPlayerLose(player4)
                Rule_RemoveMe()
        end
end

------------------------------Elites----------------------------

function Elites()

        Modify_ReceivedDamage(Kbal, 0.4)
        Modify_ReceivedAccuracy(Kbal, 0.4)
		Modify_ReceivedDamage(Neeps, 0.4)
        Modify_ReceivedAccuracy(Neeps, 0.4)
		Modify_ReceivedDamage(Shannon, 0.4)
        Modify_ReceivedAccuracy(Shannon, 0.4)
		Modify_ReceivedDamage(Gower, 0.4)
        Modify_ReceivedAccuracy(Gower, 0.4)
		Modify_ReceivedDamage(Ocelot, 0.5)
        Modify_ReceivedAccuracy(Ocelot, 0.5)
		Modify_ReceivedDamage(Canaris, 0.5)
        Modify_ReceivedAccuracy(Canaris, 0.5)

		
end

function EliteNames()

        local EliteName1 = Util_CreateLocString("Arthur 'Kbal' Bailey")
        HintMouseover_Add(EliteName1, Kbal, 5, true)
        SGroup_IncreaseVeterancyRank(Kbal, 3, true)
		local EliteName2 = Util_CreateLocString("Francis 'Neeps' McGregor")
        HintMouseover_Add(EliteName2, Neeps, 5, true)
        SGroup_IncreaseVeterancyRank(Neeps, 3, true)
		local EliteName3 = Util_CreateLocString("Paddy 'Shannon' Malone")
        HintMouseover_Add(EliteName3, Shannon, 5, true)
        SGroup_IncreaseVeterancyRank(Shannon, 3, true)
		local EliteName4 = Util_CreateLocString("Henry 'Gower' Jones")
        HintMouseover_Add(EliteName4, Gower, 5, true)
        SGroup_IncreaseVeterancyRank(Gower, 3, true)
		local EliteName5 = Util_CreateLocString("John 'Ocelot' Stevenson")
        HintMouseover_Add(EliteName5, Ocelot, 5, true)
        SGroup_IncreaseVeterancyRank(Ocelot, 2, true)
		local EliteName6 = Util_CreateLocString("The Spymaster of Stuttgart")
        HintMouseover_Add(EliteName6, Canaris, 5, true)
        SGroup_IncreaseVeterancyRank(Canaris, 3, true)


end
------------------------------Upgrades-----------------------------

function Upgrade()

		
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("hq_anti_tank_grenade_mp"))
        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("hq_molotov_grenade_mp"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("hq_anti_tank_grenade_mp"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("hq_molotov_grenade_mp"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("hq_anti_tank_grenade_mp"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("hq_molotov_grenade_mp"))
		
		Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("air_drop_resources"))
		Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("air_drop_weapon_resupply"))
        Player_AddAbility(player4, BP_GetAbilityBlueprint("air_dropped_munitions"))
		Player_AddAbility(player4, BP_GetAbilityBlueprint("air_dropped_supplies"))
		
		Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("stuka_smoke_bomb"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("stuka_smoke_bomb"))
		
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
		
		Player_SetUpgradeAvailability(player1, UPG.AEF.FIGHTING_POSITION_MG_ADDITION_MP, ITEM_REMOVED)
		Player_SetUpgradeAvailability(player2, UPG.AEF.FIGHTING_POSITION_MG_ADDITION_MP, ITEM_REMOVED)
		Player_SetUpgradeAvailability(player3, UPG.AEF.FIGHTING_POSITION_MG_ADDITION_MP, ITEM_REMOVED)
		
		Player_SetEntityProductionAvailability(player1, EBP.SOVIET.SAND_BAG_SOVIET_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.SOVIET.SAND_BAG_SOVIET_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player3, EBP.SOVIET.SAND_BAG_SOVIET_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.SOVIET.SAND_BAG_SOVIET, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.SOVIET.SAND_BAG_SOVIET, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player3, EBP.SOVIET.SAND_BAG_SOVIET, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.SOVIET.SAND_BAG_SOVIET_TUTORIAL, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.SOVIET.SAND_BAG_SOVIET_TUTORIAL, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player3, EBP.SOVIET.SAND_BAG_SOVIET_TUTORIAL, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.SOVIET.BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.SOVIET.BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player3, EBP.SOVIET.BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		
		Player_SetEntityProductionAvailability(player1, EBP.SOVIET.MOTORPOOL_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.SOVIET.MOTORPOOL_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player3, EBP.SOVIET.MOTORPOOL_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.SOVIET.TANK_DEPOT_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.SOVIET.TANK_DEPOT_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player3, EBP.SOVIET.TANK_DEPOT_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.SOVIET.WEAPON_SUPPORT_CENTER_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.SOVIET.WEAPON_SUPPORT_CENTER_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player3, EBP.SOVIET.WEAPON_SUPPORT_CENTER_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.SOVIET.BARRACKS_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.SOVIET.BARRACKS_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player3, EBP.SOVIET.BARRACKS_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.SOVIET.OBSERVATION_POST_FUEL_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.SOVIET.OBSERVATION_POST_FUEL_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player3, EBP.SOVIET.OBSERVATION_POST_FUEL_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.SOVIET.OBSERVATION_POST_MUNITION_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.SOVIET.OBSERVATION_POST_MUNITION_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player3, EBP.SOVIET.OBSERVATION_POST_MUNITION_MP, ITEM_REMOVED)
		

        Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
        Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("building_1"))
        Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("building_2"))
        Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("building_3"))
        Player_SetAbilityAvailability(player4, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player4, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)

        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("building_1"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("building_2"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("building_3"))
        Player_SetAbilityAvailability(player5, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player5, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)

        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("building_1"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("building_2"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("building_3"))
        Player_SetAbilityAvailability(player6, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player6, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)

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
		
		
		Player_AddAbility(player8, BP_GetAbilityBlueprint("il-2_sturmovik_attack"))
		Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("il-2_sturmovik_attack"))
		Player_AddAbility(player8, BP_GetAbilityBlueprint("il-2_support"))
		Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("il-2_support"))
		Player_AddAbility(player8, BP_GetAbilityBlueprint("il-2_precision_bomb_strike"))
		Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("il-2_bomb_strike"))
		
end

function BuildingRestrict()

        Player_SetEntityProductionAvailability(player1, EBP.GERMAN.BUNKER_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.GERMAN.SLIT_TRENCH_GERMAN_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.GERMAN.SLIT_TRENCH_GERMAN, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.WG_SANDBAG_FENCE_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_02, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_01, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.REINFORCED_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.BUNKER_WESTGERMAN_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.WG_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.GERMAN.GERMAN_SANDBAG_FENCE, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.GERMAN.GERMAN_SANDBAG_FENCE_CMD_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.GERMAN.TANK_TRAP, ITEM_REMOVED)

        Player_SetEntityProductionAvailability(player2, EBP.GERMAN.BUNKER_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.GERMAN.SLIT_TRENCH_GERMAN_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.GERMAN.SLIT_TRENCH_GERMAN, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.WG_SANDBAG_FENCE_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_02, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_01, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.REINFORCED_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.BUNKER_WESTGERMAN_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.WG_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.GERMAN.GERMAN_SANDBAG_FENCE, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.GERMAN.GERMAN_SANDBAG_FENCE_CMD_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.GERMAN.TANK_TRAP, ITEM_REMOVED)
		
		Player_SetEntityProductionAvailability(player3, EBP.GERMAN.BUNKER_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player3, EBP.GERMAN.SLIT_TRENCH_GERMAN_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player3, EBP.GERMAN.SLIT_TRENCH_GERMAN, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player3, EBP.WEST_GERMAN.WG_SANDBAG_FENCE_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player3, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_02, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player3, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_01, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player3, EBP.WEST_GERMAN.REINFORCED_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player3, EBP.WEST_GERMAN.BUNKER_WESTGERMAN_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player3, EBP.WEST_GERMAN.WG_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player3, EBP.GERMAN.GERMAN_SANDBAG_FENCE, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player3, EBP.GERMAN.GERMAN_SANDBAG_FENCE_CMD_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player3, EBP.GERMAN.TANK_TRAP, ITEM_REMOVED)
		
		Player_SetEntityProductionAvailability(player4, EBP.GERMAN.BUNKER_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player4, EBP.GERMAN.SLIT_TRENCH_GERMAN_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player4, EBP.GERMAN.SLIT_TRENCH_GERMAN, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player4, EBP.WEST_GERMAN.WG_SANDBAG_FENCE_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player4, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_02, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player4, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_01, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player4, EBP.WEST_GERMAN.REINFORCED_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player4, EBP.WEST_GERMAN.BUNKER_WESTGERMAN_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player4, EBP.WEST_GERMAN.WG_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player4, EBP.GERMAN.GERMAN_SANDBAG_FENCE, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player4, EBP.GERMAN.GERMAN_SANDBAG_FENCE_CMD_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player4, EBP.GERMAN.TANK_TRAP, ITEM_REMOVED)
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
        Protector = "Icons_portraits_unit_aef_rear_echelon_w_portrait",
		Kbal = "Icons_portraits_unit_british_officer_s_portrait",
		Neeps = "Icons_portraits_unit_british_engineer_s_portrait",
		Shannon = "Icons_portraits_unit_british_tommy_s_portrait",
		Gower = "Icons_portraits_unit_british_commando_s_portrait",

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
Modify_PlayerResourceRate(player1, RT_Munition, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player1, RT_Manpower, 0, MUT_Multiplication)

Modify_PlayerResourceRate(player2, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player2, RT_Munition, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player2, RT_Manpower, 0, MUT_Multiplication)

Modify_PlayerResourceRate(player3, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player3, RT_Munition, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player3, RT_Manpower, 0, MUT_Multiplication)

Modify_PlayerResourceRate(player4, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player4, RT_Munition, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player4, RT_Manpower, 0, MUT_Multiplication)

Modify_PlayerResourceRate(player5, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player5, RT_Munition, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player5, RT_Manpower, 0, MUT_Multiplication)

Modify_PlayerResourceRate(player6, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player6, RT_Munition, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player6, RT_Manpower, 0, MUT_Multiplication)

Modify_PlayerResourceRate(player7, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player7, RT_Munition, 0, MUT_Multiplication)
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


EVENTS = {}

        local Text1 = Util_CreateLocString("G'day lads! Glad you could make it. I'm sure we all know why we're here. Allow me to introduce myself, the codename's Kbal.")
		local Text2 = Util_CreateLocString("Ha ha! What is this boyo! We exchanging codenames already now? Can ye believe gis right gob Shannon?")
		local Text3 = Util_CreateLocString("Ah don't listen to him. I've been with him for a week now. This Scot isn't right in the ol' noggin!")
		local Text4 = Util_CreateLocString("Um... Quite... I'm trust command has briefed you all on the mission to assassinate Reinhard Canaris? We'll first need to rendez vous with Gower and the Yanks to the east though.")
		local Text5 = Util_CreateLocString("Aye... The so called Spymaster of Stuttgart. I heard for once ye Englishmen finally got a good lead on his whereabouts and sent the best of the best to kill him.")
		local Text6 = Util_CreateLocString("Low opinions about the English have we? I wonder why they sent you along... This can't possibly work well.")
		local Text7 = Util_CreateLocString("Cause yer lookin' at the best of the best from Glasgow to Edinburgh laddie! All ye soft English be sitting on yer useless booties in London, not a talent amongst ya!")
		local Text8 = Util_CreateLocString("Oi! Can we get a move on please! I'd like to get back to Belfast by Christmas ladies.")
		local Text9 = Util_CreateLocString("Gladly... Keep your eyes open lads. We need to make sure Jerry doesn't spot us or we'll be in a right proper toss up.")
		local Text10 = Util_CreateLocString("This'll be easy. We get more of a challenge hiding from Bobbies in Antrim.")
		local Text11 = Util_CreateLocString("Ha! I remember when me and me brother Haggis got in 'em fights with the local English lads. The Bulls of Whitburn they call us! Tis how I found I got a knack for fightin'.")
	    local Text12 = Util_CreateLocString("Some proper good bouts they were! Gave them Sassenbachs a good lesson! Me brother Haggis would...")
		local Text13 = Util_CreateLocString("Hush! Jerry is too close for your memories of troublemaking. Be quiet!")
		
		local Text14 = Util_CreateLocString("Something doesn't feels quite right lads. Don't you get this feeling? This bridge is not even guarded...")
		local Text15 = Util_CreateLocString("Are ye daft? Have you been to Northern Ireland? This feels just about right. Now don't be thinking all them cities out there should be looking like that busy shitehole called London!")
	    local Text16 = Util_CreateLocString("Get some balls on ye Kbal! Ach! If ye held me balls ye couldn't be me caddie!")
		local Text17 = Util_CreateLocString("It's not even worth my time to argue with you ungrateful louts...")
		local Text18 = Util_CreateLocString("Ha ha! This reminds me of the time me and me brother Haggis snuck into the Van Houten cracker factory in Livingston. They said we were ungrateful for our wages and gave us the boot!")
		local Text19 = Util_CreateLocString("Well that manager got his comeuppance when me brother Haggis gave him a boot up the pisshole. After that me brother Haggis...")
		local Text20 = Util_CreateLocString("Focus for fecks sake Neeps! Focus!")
		
		local Text21 = Util_CreateLocString("Ah I got to say Neeps, this really is a tad bit too easy. Not much to fight here.")
		local Text22 = Util_CreateLocString("Ach! Scared already? I've seen wee lasses with more bollocks than the both of ye!")
	    local Text23 = Util_CreateLocString("Now me brother Haggis! There's a man ye can rely on to go sewer diving with ye! The Cleaners of Ingliston they'd call us! None of ye weak ladies can be...")
		local Text24 = Util_CreateLocString("Ah shut it Neeps! I do feel it too Shannon. It's still too... easy...")
		local Text25 = Util_CreateLocString("In any case it's too late now... We need to press ahead and secure the river crossing for Gower and the Yanks.")
		
		local Text26 = Util_CreateLocString("Bloody good job lads! The codename's Gower. Thanks for securing the crossing. I hope the Jerries didn't give you much trouble.")
		local Text27 = Util_CreateLocString("Not much, not much at all in fact... Who's the Yank?")
		local Text28 = Util_CreateLocString("Codename's Ocelot gentlemen. The boys and I are from the First Special Service Force. Sent to take care of business here on the American side of things.")
	    local Text29 = Util_CreateLocString("Well look at ye... Ye look like me brother Haggis! This here laddies, is what a REAL man looks like ya worthless gobs!")
		local Text30 = Util_CreateLocString("Ignore him Gower, he rambles on... Do you have any updates on where the spymaster is located?")
		local Text31 = Util_CreateLocString("He's still holed up in the fortification at the center of the city. There's only one way to get in so you'll have to storm it and clear it out. My boys and I will keep watch at the entrance.")
	    local Text32 = Util_CreateLocString("Staying behind eh? I guess ye still not me brother Haggis... Now that ye mention it... We've nay seen a single Jerry in a while!") 
		local Text33 = Util_CreateLocString("Glad you noticed...") 
		
		local Text34 = Util_CreateLocString("What? There's no one here! Kbal, Could our intelligence be wrong?") 
		local Text35 = Util_CreateLocString("This is impossible... There is no place Canaris could run to! There are no inhabited places almost a hundred miles from here.") 
		local Text36 = Util_CreateLocString("Well either that or someone tipped the bastard off!")
		local Text37 = Util_CreateLocString("Correct! Great assessment! Reinhard Canaris, at your service gentlemen. I couldn't help overhearing your conversation through the radio hidden in the walls.")
		local Text38 = Util_CreateLocString("It was inevitable that intelligence of my whereabouts would be leaked by your formidable intelligence operations. But you must remember that the art of espionage works both ways.")
		local Text39 = Util_CreateLocString("A flaw in your efforts lies in the fact that the Commonwealth and the United States have differing end goals. You are just pawns in the grand game that is being played.")
		local Text40 = Util_CreateLocString("I hope you will understand that I did what was necessary to ensure my own survival. Try not to hold a grudge against the Americans. They are just following orders! Ha ha!")
		local Text41 = Util_CreateLocString("What de bloody hell was that!!!")
		
		local Text42 = Util_CreateLocString("No quarter men! We got orders to take Reinhard Canaris alive so stick to the plan. We can't let the British leave here alive or they'll kill him!")
		local Text43 = Util_CreateLocString("Holy sweet Christ! Are they firing on us Kbal?")
		local Text44 = Util_CreateLocString("Get your head in order. Shannon! Gower! Neeps! For Christ sakes, return fire!!!")
		local Text45 = Util_CreateLocString("I'm gonna show them how me and me brother Haggis deal with backstabbers in Glasgow!!!")
		
		local ExtraText1 = Util_CreateLocString("Oh believe me. One day us Scots will rise up and leave The Union. Oh tis will be a glorious day indeed!")
		local ExtraText2 = Util_CreateLocString("You mean like an exit from Britain, of sorts? Like... a 'Brexit'?")
		local ExtraText3 = Util_CreateLocString("What the bloody hell are ye talking about laddie? We going ta leave The Union not migrate to another foreign land!")
		local ExtraText4 = Util_CreateLocString("Brexit! Ach! Such a terrible name! You need something more identifying... Like... 'Scoxit' or so.")
		local ExtraText5 = Util_CreateLocString("Well you lads can both forget about those names catching on with the public. They both sound like nicknames of some horrid breakfast cereal.")
		
		local Text46 = Util_CreateLocString("Ach! That was a proper backstab! Look! It woke dem locals up too! Almost like what ye Englishmen always do, bouncing about fecking up other people's business!")
		local Text47 = Util_CreateLocString("Bloody hell we have incoming from outside the city... Shut up Neeps this is no time for it!")
		local Text48 = Util_CreateLocString("I guess them Yanks really likes to fuck around with us, don't they?")
		local Text49 = Util_CreateLocString("Exactly so... But we've got a job to finish here lads. Chin up! We're not leaving here until this Spymaster of Stuttgart is dead.")
		local Text50 = Util_CreateLocString("Ha ha! What ye said reminds me of that time me and me brother Haggis tried to scare dem Cockney boys...")
		local Text51 = Util_CreateLocString("Ah would ya give it a rest Neeps.")
		
		local Text52 = Util_CreateLocString("That was a mighty close one there lads. Those Yanks really got the drop on us. I hope the Yanks was not in league with the spymaster...")
		local Text53 = Util_CreateLocString("Ah it's nothing one of your Bobbies in London hadn't done before. What I'm thinking is what our government is gonna do once they hear of it!")
		local Text54 = Util_CreateLocString("Nay! Dey won't hear ye at all! Ye best believe dem arses at Westminster will bury this ever happened! We cannae afford te lose de Yanks as allies.")
		local Text55 = Util_CreateLocString("Keep a tight lip on this until we're clear lads. This story isn't for casual talk.")
		local Text56 = Util_CreateLocString("Ach! Ye Englishmen are too tight fer ye own britches! No humour at all! Ach!")
		
		local Text57 = Util_CreateLocString("I commend your attempt in getting this far. But I assure you, this isn't the end of me. But ironically I intend for your journey to end here.")
		local Text58 = Util_CreateLocString("You think you've taken me by surprise, but I have one last trick up my sleeve for you.")
		local ChoiceText1 = Util_CreateLocString("Arthur... It's time...")
		local ChoiceText2 = Util_CreateLocString("Understood. Sorry lads, nothing personal. Now if you'd be so kind and die that would be great!")
		local ChoiceText3 = Util_CreateLocString("Francis... It's time...")
		local ChoiceText4 = Util_CreateLocString("Ha ha ha! I cannae believe ye gobs actually fell for the act! Serves ye right for talkin down on me!")
		local ChoiceText5 = Util_CreateLocString("Paddy... It's time...")
		local ChoiceText6 = Util_CreateLocString("Alright lads. It seems we've come to the end of our time here. Nice knowing you all!")
		local Text59 = Util_CreateLocString("FUCKING TRAITOR!!! KILL ALL OF THEM!!!")
		
		local Text60 = Util_CreateLocString("Well the Jerries certainly know where we are now! We got company from the east! We need head west out of town, now!")
		local Text61 = Util_CreateLocString("Watch out for the incoming planes! One wrong step and it'll be the end of us!")
		local ChoiceText7 = Util_CreateLocString("Ach! Stabbed in the back! Fecking fantastic but no surprise from an Englishman!")
		local ChoiceText8 = Util_CreateLocString("Neeps, for once I'm not sure this has anything to do with him being English... A traitor has no allegiance...")
		local ChoiceText9 = Util_CreateLocString("For God's sake I knew he didn't like me much but the bugger has gone off the deep end!")
		local ChoiceText10 = Util_CreateLocString("At least I don't need to hear about his brother Haggis ever again...")
		local ChoiceText11 = Util_CreateLocString("A traitor at such a young age. Unbelievable!")
		local ChoiceText12 = Util_CreateLocString("Ach! Good riddance! Me and me brother Haggis fought plenty of backstabbers. The end is always the same, with their face to the ground!")
		
		local Text62 = Util_CreateLocString("The forest is just to the west, don't stop now, keep running!")
		local Text63 = Util_CreateLocString("Wait until command hears this tale! Something we can tell our grandchildren about! Ha ha!")
		
		
--------------------------------Speech------------------------------

EVENTS.StartCinematic = function()

        CTRL.WAIT()
        Camera_SetInputEnabled(false)
	    Game_SetMode(UI_Cinematic)
	    Camera_MoveTo(mkr_startcamera)
	    Camera_SetZoomDist(15)
		CTRL.WAIT()
		CTRL.Event_Delay(2)
		CTRL.WAIT()
		SGroup_WarpToMarker(Kbal, mkr_kbalstartwarp)
	    CTRL.WAIT()
		Cmd_Move(Kbal, mkr_kbalstartto)
		Cmd_Move(Shannon, mkr_shannonstartto)
		Cmd_Move(Neeps, mkr_neepsstartto)
		CTRL.Event_Delay(0.5)
	    CTRL.WAIT()
		Cmd_Move(Kbal, mkr_kbalstartto)
		CTRL.WAIT()
		CTRL.Event_Delay(2)
	    CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Kbal, Text1)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Neeps, Text2)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Shannon, Text3)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Kbal, Text4)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Neeps, Text5)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Kbal, Text6)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Neeps, Text7)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Shannon, Text8)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Kbal, Text9)
		Camera_SetInputEnabled(true)
	    Game_SetMode(UI_Normal)
        Camera_ResetToDefault()
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Shannon, Text10)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Neeps, Text11)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Neeps, Text12)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Kbal, Text13)
		
end

EVENTS.DialogueOne = function()

        CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Kbal, Text14)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Shannon, Text15)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Neeps, Text16)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Kbal, Text17)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Neeps, Text18)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Neeps, Text19)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Kbal, Text20)
		CTRL.WAIT()
		
end

EVENTS.BanterOne = function()

        CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Neeps, ExtraText1)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Shannon, ExtraText2)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Neeps, ExtraText3)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Neeps, ExtraText4)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Kbal, ExtraText5)
		CTRL.WAIT()
		
end

EVENTS.DialogueTwo = function()

        CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Shannon, Text21)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Neeps, Text22)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Neeps, Text23)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Kbal, Text24)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Kbal, Text25)
		CTRL.WAIT()
		
end

EVENTS.DialogueThree = function()

        CTRL.WAIT()
		Cmd_Move(Gower, mkr_gowerto)
		Cmd_Move(PiatCommando, mkr_piatcommandoto)
		Cmd_Move(NormalCommando, mkr_normalcommandoto)
		Cmd_Move(Ocelot, mkr_ocelotto1)
		Cmd_Move(AssEngin, mkr_assenginto1)
		Cmd_Move(Para, mkr_parato1)
		Cmd_Move(Rifle, mkr_rifleto1)
		SGroup_SetPlayerOwner(Gower, player1)
		SGroup_SetPlayerOwner(PiatCommando, player2)
		SGroup_SetPlayerOwner(NormalCommando, player3)
		CTRL.Actor_PlaySpeech(ACTOR.Gower, Text26)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Kbal, Text27)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, Text28)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Neeps, Text29)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Kbal, Text30)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, Text31)
		CTRL.WAIT()
		Cmd_Move(Ocelot, mkr_ocelotto2)
		Cmd_Move(AssEngin, mkr_assenginto2)
		Cmd_Move(Para, mkr_parato2)
		Cmd_Move(Rifle, mkr_rifleto2)
		CTRL.Actor_PlaySpeech(ACTOR.Neeps, Text32)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Shannon, Text33)
		CTRL.WAIT()
		
end

EVENTS.DialogueFour = function()

        CTRL.WAIT()
		Camera_MoveTo(mkr_castlecamera)
		Camera_SetInputEnabled(false)
	    Game_SetMode(UI_Cinematic)
	    Camera_SetZoomDist(25)
		SGroup_WarpToMarker(Kbal, mkr_kbalwarpto)
		SGroup_WarpToMarker(Neeps, mkr_neepswarpto)
		SGroup_WarpToMarker(Shannon, mkr_shannonwarpto)
		SGroup_WarpToMarker(Gower, mkr_gowerwarpto)
		SGroup_WarpToMarker(OneOne, mkr_playeroneto)
		SGroup_WarpToMarker(OneTwo, mkr_playeroneto)
		SGroup_WarpToMarker(TwoOne, mkr_playertwoto)
		SGroup_WarpToMarker(TwoTwo, mkr_playertwoto)
		SGroup_WarpToMarker(ThreeOne, mkr_playerthreeto)
		SGroup_WarpToMarker(ThreeTwo, mkr_playerthreeto)
		SGroup_WarpToMarker(ExtraOne, mkr_extrato)
		SGroup_WarpToMarker(ExtraTwo, mkr_extrato)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Shannon, Text34)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Kbal, Text35)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Gower, Text36)
		CTRL.WAIT()
		Game_FadeToBlack(FADE_OUT, 0.5)
	    CTRL.WAIT()
		CTRL.Event_Delay(0.5)
		CTRL.WAIT()
		FOW_RevealMarker(mkr_officercamera, 150)
		Camera_MoveTo(mkr_officercamera)
		CTRL.WAIT()
		Game_FadeToBlack(FADE_IN, 0.5)
	    CTRL.WAIT()
		CTRL.Event_Delay(0.5)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Radio, Text37)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Radio, Text38)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Radio, Text39)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Radio, Text40)
		CTRL.WAIT()
		Game_FadeToBlack(FADE_OUT, 0.5)
	    CTRL.WAIT()
		CTRL.Event_Delay(0.5)
		CTRL.WAIT()
		Camera_MoveTo(mkr_castlecamera)
		CTRL.WAIT()
		Game_FadeToBlack(FADE_IN, 0.5)
	    CTRL.WAIT()
		Camera_SetInputEnabled(true)
	    Game_SetMode(UI_Normal)
        Camera_ResetToDefault()
		Blip5 = UI_CreateMinimapBlip(Ocelot, 9000, BT_ObjectivePrimary)
		UI_DeleteMinimapBlip(Blip4)
	    CTRL.WAIT()
		CTRL.Event_Delay(2)
		CTRL.WAIT()
		SGroup_SetPlayerOwner(AmericansAll, player8)
		Cmd_Move(Ocelot, mkr_ocelotto3)
		Cmd_Move(AssEngin, mkr_assenginto3)
		Cmd_Move(Para, mkr_parato3)
		Cmd_AttackMove(Rifle, mkr_rifleto3)
		CTRL.Actor_PlaySpeech(ACTOR.Neeps, Text41)
		CTRL.WAIT()
		
end

EVENTS.AmericanDialogue = function()

        CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, Text42)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Shannon, Text43)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Kbal, Text44)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Neeps, Text45)
		CTRL.WAIT()
		
end

EVENTS.PursuitDialogue = function()

        CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Neeps, Text46)
		Blip6 = UI_CreateMinimapBlip(Point5, 9000, BT_ObjectivePrimary)
		UI_DeleteMinimapBlip(Blip5)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Kbal, Text47)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Shannon, Text48)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Gower, Text49)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Neeps, Text50)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Shannon, Text51)
		CTRL.WAIT()
		
end

EVENTS.DialogueFive = function()

        CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Gower, Text52)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Shannon, Text53)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Neeps, Text54)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Kbal, Text55)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Neeps, Text56)
		CTRL.WAIT()
		
end

EVENTS.KbalTraitor = function()

        CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text57)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text58)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, ChoiceText1)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Kbal, ChoiceText2)
		SGroup_SetPlayerOwner(PlayerOneAll, player8)
		SGroup_SetPlayerOwner(GroupGower, player1)
		SGroup_SetInvulnerable(PlayersAll, true)
		SGroup_SetInvulnerable(GroupGower, true)
		SGroup_Kill(KbalControl)
		ExtraBlip = UI_CreateMinimapBlip(Kbal, 9000, BT_ObjectivePrimary)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Gower, Text59)
		Cmd_AttackMove(Kbal, mkr_traitorto)
		SGroup_SetInvulnerable(PlayersAll, false)
		SGroup_SetInvulnerable(GroupGower, false)
		SGroup_SetInvulnerable(Canaris, false)
		CTRL.WAIT()
		
end

EVENTS.NeepsTraitor = function()

        CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text57)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text58)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, ChoiceText3)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Neeps, ChoiceText4)
		SGroup_SetPlayerOwner(PlayerTwoAll, player8)
		SGroup_SetPlayerOwner(GroupGower, player2)
		SGroup_SetInvulnerable(PlayersAll, true)
		SGroup_SetInvulnerable(GroupGower, true)
		SGroup_Kill(NeepsControl)
		ExtraBlip = UI_CreateMinimapBlip(Neeps, 9000, BT_ObjectivePrimary)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Gower, Text59)
		Cmd_AttackMove(Neeps, mkr_traitorto)
		SGroup_SetInvulnerable(PlayersAll, false)
		SGroup_SetInvulnerable(GroupGower, false)
		SGroup_SetInvulnerable(Canaris, false)
		CTRL.WAIT()
		
end

EVENTS.ShannonTraitor = function()

        CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text57)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text58)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, ChoiceText5)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Shannon, ChoiceText6)
		SGroup_SetPlayerOwner(PlayerThreeAll, player8)
		SGroup_SetPlayerOwner(GroupGower, player3)
		SGroup_SetInvulnerable(PlayersAll, true)
		SGroup_SetInvulnerable(GroupGower, true)
		SGroup_Kill(ShannonControl)
		ExtraBlip = UI_CreateMinimapBlip(Shannon, 9000, BT_ObjectivePrimary)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Gower, Text59)
		Cmd_AttackMove(Shannon, mkr_traitorto)
		SGroup_SetInvulnerable(PlayersAll, false)
		SGroup_SetInvulnerable(GroupGower, false)
		SGroup_SetInvulnerable(Canaris, false)
		CTRL.WAIT()
		
end

EVENTS.AfterKbalDialogue = function()

        CTRL.WAIT()
		FOW_RevealSGroupOnly(ChaserGroup, 9000)
		FOW_RevealSGroupOnly(ChaserLeft, 9000)
		FOW_RevealSGroupOnly(ChaserRight, 9000)
		SGroup_WarpToMarker(ChaserLeft, mkr_chaserleftspawn)
		SGroup_WarpToMarker(ChaserRight, mkr_chaserrightspawn)
		Blip8 = UI_CreateMinimapBlip(Point6, 9000, BT_ObjectivePrimary)
		UI_DeleteMinimapBlip(Blip7)
		UI_DeleteMinimapBlip(ExtraBlip)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Gower, Text60)
		Cmd_AttackMove(ChaserGroup, mkr_chasergroupto)
		Cmd_AttackMove(ChaserLeft, mkr_chaserto)
		Cmd_AttackMove(ChaserRight, mkr_chaserto)
		World_GetCurrentInteractionStage()
        World_IncreaseInteractionStage()
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Gower, Text61)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Neeps, ChoiceText7)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Shannon, ChoiceText8)
		CTRL.WAIT()
		
end

EVENTS.AfterNeepsDialogue = function()

        CTRL.WAIT()
		FOW_RevealSGroupOnly(ChaserGroup, 9000)
		FOW_RevealSGroupOnly(ChaserLeft, 9000)
		FOW_RevealSGroupOnly(ChaserRight, 9000)
		SGroup_WarpToMarker(ChaserLeft, mkr_chaserleftspawn)
		SGroup_WarpToMarker(ChaserRight, mkr_chaserrightspawn)
		Blip8 = UI_CreateMinimapBlip(Point6, 9000, BT_ObjectivePrimary)
		UI_DeleteMinimapBlip(Blip7)
		UI_DeleteMinimapBlip(ExtraBlip)
        CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Gower, Text60)
		Cmd_AttackMove(ChaserGroup, mkr_chasergroupto)
		Cmd_AttackMove(ChaserLeft, mkr_chaserto)
		Cmd_AttackMove(ChaserRight, mkr_chaserto)
		World_GetCurrentInteractionStage()
        World_IncreaseInteractionStage()
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Gower, Text61)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Kbal, ChoiceText9)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Shannon, ChoiceText10)
		CTRL.WAIT()
		
end

EVENTS.AfterShannonDialogue = function()

        CTRL.WAIT()
		FOW_RevealSGroupOnly(ChaserGroup, 9000)
		FOW_RevealSGroupOnly(ChaserLeft, 9000)
		FOW_RevealSGroupOnly(ChaserRight, 9000)
		SGroup_WarpToMarker(ChaserLeft, mkr_chaserleftspawn)
		SGroup_WarpToMarker(ChaserRight, mkr_chaserrightspawn)
		Blip8 = UI_CreateMinimapBlip(Point6, 9000, BT_ObjectivePrimary)
		UI_DeleteMinimapBlip(Blip7)
		UI_DeleteMinimapBlip(ExtraBlip)
        CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Gower, Text60)
		Cmd_AttackMove(ChaserGroup, mkr_chasergroupto)
		Cmd_AttackMove(ChaserLeft, mkr_chaserto)
		Cmd_AttackMove(ChaserRight, mkr_chaserto)
		World_GetCurrentInteractionStage()
        World_IncreaseInteractionStage()
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Gower, Text61)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Kbal, ChoiceText11)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Neeps, ChoiceText12)
		CTRL.WAIT()
		
end

EVENTS.EndDialogue = function()

        CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Gower, Text62)
		SGroup_SetInvulnerable(Kbal, true)
		SGroup_SetInvulnerable(Neeps, true)
		SGroup_SetInvulnerable(Shannon, true)
		SGroup_SetInvulnerable(Gower, true)
		Cmd_Move(ChaserGroup, mkr_chasergroupretreat)
		Cmd_Move(ChaserLeft, mkr_chaserleftspawn)
		Cmd_Move(ChaserRight, mkr_chaserrightspawn)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Gower, Text63)
		CTRL.WAIT()
		World_SetPlayerWin(player1)
        World_SetPlayerWin(player2)
        World_SetPlayerWin(player3)
	    World_SetPlayerWin(player4)
		CTRL.WAIT()
		
end
