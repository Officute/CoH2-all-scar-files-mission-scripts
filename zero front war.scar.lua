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
		
		Rule_AddDelayedInterval(StatorBuff, 10, 10)

        Rule_AddDelayedInterval(Patrols, 1, 1)
		
		Rule_AddDelayedInterval(Easter, 1, 1)
		
		Cinematic()
		
		Community()

        Points()

        IndustrialEvent()
		
		TramEvent()
		
		TrainEvent()
		
		HillEvent()
		
        Elites()

        EliteNames()

        Officers()

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
		
		Blip1 = UI_CreateMinimapBlip(Point1, 9000, BT_ObjectivePrimary)
		
        World_EnableSharedLineOfSight(player1, player4, true)
        World_EnableSharedLineOfSight(player2, player4, true)

        Command_SquadEntityLoad(player5, GoldLeft, SCMD_Load, GoldHouseLeft, false, true)
        Command_SquadEntityLoad(player5, GoldRight, SCMD_Load, GoldHouseRight, false, true)
		Command_SquadEntityLoad(player3, FightingPositionTommy, SCMD_Load, FightingPositionBottom, false, true)
		Command_SquadEntityLoad(player3, EstateOfficer, SCMD_Load, EstateBuilding, false, true)
		Command_SquadEntityLoad(player3, EstateFalls, SCMD_Load, EstateBuilding, false, true)
		
		EGroup_SetInvulnerable(IndestructibleEntities, true)
		EGroup_SetInvulnerable(HillTower, true)
		
		Modify_DisableHold(NoEntryBuildings, true)

	    Player_SetPopCapOverride(player5, 900)
	    Player_SetPopCapOverride(player6, 900)
		
		Modify_UnitSpeed(TigerElite, 0.6)
		Modify_UnitSpeed(HillHetzer, 0.6)

		EGroup_SetInvulnerable(RuinsPlanks, true)	
	    EGroup_SetInvulnerable(RuinsPlatforms, true)	
	    EGroup_SetInvulnerable(TramPlatforms, true)

end

function CustomFailsafe()

        AI_EnableAll(false)

end

function StatorBuff()

        Modify_ReceivedDamage(Stator, 0.05)
        Modify_ReceivedAccuracy(Stator, 0.05)
		Rule_RemoveMe()
		
end

function Patrols()

        Cmd_SquadPatrolMarker(StartSturmpioneer, mkr_sturmpioneerpatrol)
        Rule_RemoveMe()

end

function Cinematic()

	    Camera_SetInputEnabled(false)
	    Game_SetMode(UI_Cinematic)
        Camera_Follow(Kurt)
        Camera_SetZoomDist(20)
        Util_StartIntel(EVENTS.StartCinematic)

end

function Easter()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_eastereggtrigger, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_eastereggtrigger, false)
        if Control1 == true or Control2 == true then
                local EggText = Util_CreateLocString("Hey! Thanks for finding me! Looks like I caught up with you just in time. Did you know to the west of the tram warehouse lies a small outpost for some hostiles? Better clear them out if you don't want them sneaking up on you in the middle of combat later! I am helpful right?")
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

        local CommunityHint1 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 6 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Hidden)")
        local CommunityHint2 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 6 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Behind)")
        local CommunityHint3 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 6 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Four)")
        local CommunityHint4 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 6 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Hard)")
        local CommunityHint5 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 6 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Natural)")
        local CommunityHint6 = Util_CreateLocString("You've found a community easter egg! You will be given a single random codeword which forms a part of a sentence of 6 codewords. Share your codeword with other players on this map's Steam Workshop page to co-operate and find out what the secret is. (Your codeword is: Objects)")

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_conscomtrigger, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_conscomtrigger, false)
        local Random = World_GetRand(1, 6)
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
                elseif Random == 6 then
                        HintMouseover_Add(CommunityHint6, CommunityCons, 5, true)
                end
        end
end

function TextAppear()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_communitytrigger, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_communitytrigger, false)
        if Control1 == true or Control2 == true then
                local CommunityEggText = Util_CreateLocString("A note found on the soldier's hand reads: Tomislav is turncoat. Vanguard forces failed. Target and his entourage aware of our presence. Command post has been destroyed. Allied forces survives. You have not yet been compromised.")
                HintMouseover_Add(CommunityEggText, CommunityEgg, 5, true)
                Rule_RemoveMe()
        end
end

------------------------------Points------------------------------

function Points()

        Rule_AddDelayedInterval(PointOne, 1, 1)
        Rule_AddDelayedInterval(PointTwo, 1, 1)
		Rule_AddDelayedInterval(PointThree, 1, 1)
		Rule_AddDelayedInterval(PointFour, 1, 1)

end

function PointOne()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point1, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point1, player2, false)
        if PointFocus1 == true or PointFocus2 == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat1, 1)
                local DestroyEntity = EGroup_GetSpawnedEntityAt(RetreatStart, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity)
	            Util_StartIntel(EVENTS.SovietRescue)
				Blip2 = UI_CreateMinimapBlip(Point2, 9000, BT_ObjectivePrimary)
				UI_DeleteMinimapBlip(Blip1)
                Rule_RemoveMe()
        end
end

function PointTwo()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point2, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point2, player2, false)
        if PointFocus1 == true or PointFocus2 == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat2, 1)
                local DestroyEntity = EGroup_GetSpawnedEntityAt(Retreat1, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntity)
				local TextHint1 = Util_CreateLocString("All Soviet allies must also survive. Death of a Soviet ally will result in mission failure")
                Hint1 = HintPoint_Add(mkr_hint1, true, TextHint1)
                Rule_RemoveMe()
        end
end

function PointThree()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point3, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point3, player2, false)
		local PointFocus3 = EGroup_IsCapturedByPlayer(Point3, player3, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true then
                local RetreatEntityOne = EGroup_GetSpawnedEntityAt(Retreat3, 1)
				local RetreatEntityTwo = EGroup_GetSpawnedEntityAt(RetreatExtra, 1)
                local DestroyEntity = EGroup_GetSpawnedEntityAt(Retreat2, 1)
                Entity_SetPlayerOwner(RetreatEntityOne, player1)
				Entity_SetPlayerOwner(RetreatEntityTwo, player1)
                Entity_Destroy(DestroyEntity)
                Rule_RemoveMe()
        end
end

function PointFour()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point4, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point4, player2, false)
		local PointFocus3 = EGroup_IsCapturedByPlayer(Point4, player3, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true then
                local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat4, 1)
				local DestroyEntityOne = EGroup_GetSpawnedEntityAt(Retreat3, 1)
                local DestroyEntityTwo = EGroup_GetSpawnedEntityAt(RetreatExtra, 1)
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Entity_Destroy(DestroyEntityOne)
				Entity_Destroy(DestroyEntityTwo)
				Util_StartIntel(EVENTS.HillWaveOne)
				SGroup_Kill(HillSecondControl)
                Rule_RemoveMe()
        end
end


-----------------------------Industrial Event----------------------------

function IndustrialEvent()

        Rule_AddDelayedInterval(GapCombat, 1, 1)
	    Rule_AddDelayedInterval(GapAssGrenTop, 1, 1)
        Rule_AddDelayedInterval(GapAssGrenBottom, 1, 1)
		Rule_AddDelayedInterval(AttackersDead, 1, 1)
        Rule_AddDelayedInterval(GoldArea, 1, 1)

end

function GapCombat()

        local Control = SGroup_IsUnderAttack(StartKubelTrigger, true, 9000)
        if Control == true then
	        Cmd_Move(StartKubel, mkr_startkubelto)
                Rule_RemoveMe()
        end
end

function GapAssGrenTop()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_startassgrentrigger2, false)
        local Control2 = Prox_ArePlayersNearMarker(player2, mkr_startassgrentrigger2, false)
        if Control1 == true or Control2 == true then
	        Cmd_Move(StartAssGren, mkr_startassgrento2)
                Rule_RemoveMe()
        end
end

function GapAssGrenBottom()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_startassgrentrigger1, false)
        local Control2 = Prox_ArePlayersNearMarker(player2, mkr_startassgrentrigger1, false)
        if Control1 == true or Control2 == true then
	        Cmd_Move(StartAssGren, mkr_startassgrento1)
                Rule_RemoveMe()
        end
end

function AttackersDead()

        local Control = SGroup_Count(IndustrialAttackers)
        if Control == 0 then
                Util_StartIntel(EVENTS.SovietTramDialogue)
                Rule_RemoveMe()
        end
end

function GoldArea()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_industrialtrigger, false)
        local Control2 = Prox_ArePlayersNearMarker(player2, mkr_industrialtrigger, false)
        if Control1 == true or Control2 == true then
	        Cmd_Move(IndustrialKubel, mkr_industrialkubelto)
	        Cmd_Move(IndustrialSturmpioneer, mkr_industrialsturmpioneerto)
                Rule_RemoveMe()
        end
end


----------------------------Tram Event-------------------------------

function TramEvent()

        Rule_AddDelayedInterval(TramOne, 1, 1)
		Rule_AddDelayedInterval(TramTwo, 1, 1)
	    Rule_AddDelayedInterval(TramThree, 1, 1)
		Rule_AddDelayedInterval(TramFour, 1, 1)
		Rule_AddDelayedInterval(TramTalk, 1, 1)
		Rule_AddDelayedInterval(TramEnd, 1, 1)
		Rule_AddDelayedInterval(GoldHelp, 1, 1)
		Rule_AddDelayedInterval(Suppression, 0.1, 0.1)

end

function TramOne()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point2, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point2, player2, false)
        if PointFocus1 == true or PointFocus2 == true then
                Util_StartIntel(EVENTS.TramFightOne)
                Rule_RemoveMe()
				
        end
end

function TramTwo()

        local Control = SGroup_Count(TramWaveOne)
        if Control == 0 then
                Util_StartIntel(EVENTS.TramFightTwo)
                Rule_RemoveMe()
        end
end

function TramThree()

        local Control = SGroup_Count(TramWaveTwo)
        if Control == 0 then
                Util_StartIntel(EVENTS.TramFightThree)
                Rule_RemoveMe()
        end
end

function TramFour()

        local Control = SGroup_Count(TramWaveThree)
        if Control == 0 then
                Util_StartIntel(EVENTS.TramFightFour)
                Rule_RemoveMe()
        end
end


function TramTalk()

        local Control = Prox_ArePlayersNearMarker(player6, mkr_tramthirdelitedialoguetrigger, false)
        if Control == true then
                Util_StartIntel(EVENTS.TramEliteArrive)
                Rule_RemoveMe()
        end
end

function TramEnd()

        local Control = SGroup_Count(TramWaveFour)
        if Control == 0 then
                Util_StartIntel(EVENTS.TramFinish)
                Rule_RemoveMe()
        end
end

function GoldHelp()

        local Control1 = SGroup_Count(GoldReinforcementGroup)
		local Control2 = Prox_ArePlayersNearMarker(player6, mkr_tramthirdelitedialoguetrigger, false)
        if Control1 == 1 or Control1 == 2 or Control1 == 3 then
		        if Control2 == true then
                        Util_StartIntel(EVENTS.GoldAssist)
                        Rule_RemoveMe()
				end
        end
end

function Suppression()

        SGroup_SetSuppression(TramWaveOne, 0)
		SGroup_SetSuppression(TramWaveTwo, 0)
		SGroup_SetSuppression(TramWaveThree, 0)
		SGroup_SetSuppression(TramWaveFour, 0)
				

end


-----------------------------Train Event-----------------------------

function TrainEvent()

        Rule_AddDelayedInterval(TrainCinematic, 1, 1)
		Rule_AddDelayedInterval(TrainThievesDialogue, 1, 1)

		Rule_AddDelayedInterval(StreetBrummbarMove, 1, 1)
		Rule_AddDelayedInterval(StreetPershingMove, 1, 1)
		
		Rule_AddDelayedInterval(TrainWalterSpawn, 1, 30)
		Rule_AddDelayedInterval(TrainWalterWaves, 1, 1)
        Rule_AddDelayedInterval(WalterMoveTop, 1, 10)
		Rule_AddDelayedInterval(WalterMoveMid, 1, 10)
		Rule_AddDelayedInterval(WalterMoveBottom, 1, 10)
		Rule_AddDelayedInterval(WalterGone, 1, 1)
		Rule_AddDelayedInterval(WalterDeathReinforcement, 1, 90)
		
		Rule_AddDelayedInterval(EstateSpawn, 1, 60)
		Rule_AddDelayedInterval(EstateWaves, 1, 1)
		Rule_AddDelayedInterval(EstateMoveTop, 1, 10)
		Rule_AddDelayedInterval(EstateMoveMid, 1, 10)
		Rule_AddDelayedInterval(EstateMoveBottom, 1, 10)
		
		Rule_AddDelayedInterval(AlliesSpawn, 1, 90)
		Rule_AddDelayedInterval(AlliesMoveTop, 1, 10)
		Rule_AddDelayedInterval(AlliesMoveBottom, 1, 10)
		
end

function TrainCinematic()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_traincinematictrigger, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_traincinematictrigger, false)
        if Control1 == true or Control2 == true then
                Util_StartIntel(EVENTS.TrainAmbush)
                Rule_RemoveMe()
        end
end

function TrainThievesDialogue()

		local Control1 = SGroup_IsUnderAttackByPlayer(TrainHijackers, player1, 9000)
        local Control2 = SGroup_IsUnderAttackByPlayer(TrainHijackers, player2, 9000)
        if Control1 == true or Control2 == true then
                Util_StartIntel(EVENTS.TrainSpeech)
                Rule_RemoveMe()
        end
end

function TrainWalterSpawn()

        local Control1 = SGroup_Count(WalterSpawnControl)
		local Control2 = SGroup_Count(WalterGroup)
		local Control3 = SGroup_Count(EstateControl)
        if Control1 == 0 and Control2 > 0 and Control3 > 0 then
                local Random = World_GetRand(1, 5)
                if Random == 1 then
                        Util_CreateSquads(player7, TrainOne, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_trainspawntop)
                        Util_CreateSquads(player7, TrainTwo, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_trainspawnmid)
						Util_CreateSquads(player7, TrainThree, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_trainspawnbottom)
						Util_CreateSquads(player7, TrainThree, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_trainspawnbottom)
						Cmd_Move(TrainOne, mkr_traindirecttop)
						Cmd_Move(TrainTwo, mkr_traindirectmid)
						Cmd_Move(TrainThree, mkr_traindirectbottom)
                elseif Random == 2 then
                        Util_CreateSquads(player7, TrainOne, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_trainspawntop)
						Util_CreateSquads(player7, Trainone, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_trainspawntop)
                        Util_CreateSquads(player7, TrainTwo, SBP.GERMAN.URBAN_ASSAULT_PANZER_GRENADIER_SQUAD_MP, mkr_trainspawnmid)
						Util_CreateSquads(player7, TrainThree, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_trainspawnbottom)
						Cmd_Move(TrainOne, mkr_traindirecttop)
						Cmd_Move(TrainTwo, mkr_traindirectmid)
						Cmd_Move(TrainThree, mkr_traindirectbottom)
                elseif Random == 3 then
				        Util_CreateSquads(player7, TrainOne, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_trainspawntop)
                        Util_CreateSquads(player7, TrainTwo, SBP.GERMAN.STORMTROOPER_SQUAD_MP, mkr_trainspawnmid)
						Util_CreateSquads(player7, TrainTwo, SBP.GERMAN.STORMTROOPER_SQUAD_MP, mkr_trainspawnmid)
						Util_CreateSquads(player7, TrainThree, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_trainspawnbottom)
						Cmd_Move(TrainOne, mkr_traindirecttop)
						Cmd_Move(TrainTwo, mkr_traindirectmid)
						Cmd_Move(TrainThree, mkr_traindirectbottom)
			    elseif Random == 4 then
				        Util_CreateSquads(player7, TrainOne, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_trainspawntop)
                        Util_CreateSquads(player7, TrainTwo, SBP.GERMAN.STORMTROOPER_SQUAD_MP, mkr_trainspawnmid)
						Util_CreateSquads(player7, TrainThree, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_trainspawnbottom)
						Util_CreateSquads(player7, TrainThree, SBP.GERMAN.URBAN_ASSAULT_PANZER_GRENADIER_SQUAD_MP, mkr_trainspawnbottom)
						Cmd_Move(TrainOne, mkr_traindirecttop)
						Cmd_Move(TrainTwo, mkr_traindirectmid)
						Cmd_Move(TrainThree, mkr_traindirectbottom)
			    elseif Random == 5 then
				        Util_CreateSquads(player7, TrainOne, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_trainspawntop)
                        Util_CreateSquads(player7, TrainTwo, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_trainspawnmid)
						Util_CreateSquads(player7, TrainTwo, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_trainspawnmid)
						Util_CreateSquads(player7, TrainThree, SBP.GERMAN.URBAN_ASSAULT_PANZER_GRENADIER_SQUAD_MP, mkr_trainspawnbottom)
						Cmd_Move(TrainOne, mkr_traindirecttop)
						Cmd_Move(TrainTwo, mkr_traindirectmid)
						Cmd_Move(TrainThree, mkr_traindirectbottom)
			    end
        end
end

function TrainWalterWaves()

        local Control = SGroup_Count(WalterSpawnControl)
        if Control == 0 then
                Util_StartIntel(EVENTS.TrainWalterAttacks)
                Rule_RemoveMe()
        end
end

function WalterMoveTop()

        local Control = Prox_ArePlayersNearMarker(player7, mkr_traindirecttop, false)
        if Control == true then
                local Random = World_GetRand(1, 3)
                if Random == 1 then
				        Cmd_Move(TrainOne, mkr_traintargettop)
						SGroup_Clear(TrainOne)
				elseif Random == 2 then
				        Cmd_Move(TrainOne, mkr_traintargetmid)
						SGroup_Clear(TrainOne)
				elseif Random == 3 then
				        Cmd_Move(TrainOne, mkr_traintargetbottom)
						SGroup_Clear(TrainOne)
				end
        end
end

function WalterMoveMid()

        local Control = Prox_ArePlayersNearMarker(player7, mkr_traindirectmid, false)
        if Control == true then
                local Random = World_GetRand(1, 3)
                if Random == 1 then
				        Cmd_Move(TrainTwo, mkr_traintargettop)
						SGroup_Clear(TrainTwo)
				elseif Random == 2 then
				        Cmd_Move(TrainTwo, mkr_traintargetmid)
						SGroup_Clear(TrainTwo)
				elseif Random == 3 then
				        Cmd_Move(TrainTwo, mkr_traintargetbottom)
						SGroup_Clear(TrainTwo)
				end
        end
end

function WalterMoveBottom()

        local Control = Prox_ArePlayersNearMarker(player7, mkr_traindirectbottom, false)
        if Control == true then
                local Random = World_GetRand(1, 3)
                if Random == 1 then
				        Cmd_Move(TrainThree, mkr_traintargettop)
						SGroup_Clear(TrainThree)
				elseif Random == 2 then
				        Cmd_Move(TrainThree, mkr_traintargetmid)
						SGroup_Clear(TrainThree)
				elseif Random == 3 then
				        Cmd_Move(TrainThree, mkr_traintargetbottom)
						SGroup_Clear(TrainThree)
			    end
        end
end

function WalterGone()

        local Control1 = SGroup_Count(WalterGroup)
        if Control1 == 0 then
                Util_StartIntel(EVENTS.WalterEvent)
				Rule_RemoveMe()
        end
end

function WalterDeathReinforcement()

        local Control1 = SGroup_Count(WalterGroup)
		local Control2 = SGroup_Count(EstateOfficer)
        if Control1 == 0 and Control2 > 0 then
                local Random = World_GetRand(1, 6)
                if Random == 1 then
                        Util_CreateSquads(player3, AlliesOne, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_alliesspawn)
                        Util_CreateSquads(player3, AlliesOne, SBP.BRITISH.SAPPER_SQUAD_MP, mkr_alliesspawn)
						Util_CreateSquads(player3, AlliesTwo, SBP.AEF.RANGER_SQUAD_MP, mkr_alliesspawn)
						Util_CreateSquads(player3, AlliesTwo, SBP.BRITISH.TOMMY_SQUAD_MP, mkr_alliesspawn)
						Cmd_Move(AlliesOne, mkr_alliesdirecttop)
						Cmd_Move(AlliesTwo, mkr_alliesdirectbottom)
                elseif Random == 2 then
                        Util_CreateSquads(player3, AlliesOne, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_alliesspawn)
                        Util_CreateSquads(player3, AlliesOne, SBP.BRITISH.COMMANDO_SQUAD_MP, mkr_alliesspawn)
						Util_CreateSquads(player3, AlliesTwo, SBP.AEF.PARATROOPER_SQUAD_MP, mkr_alliesspawn)
						Util_CreateSquads(player3, AlliesTwo, SBP.BRITISH.TOMMY_SQUAD_MP, mkr_alliesspawn)
						Cmd_Move(AlliesOne, mkr_alliesdirecttop)
						Cmd_Move(AlliesTwo, mkr_alliesdirectbottom)
                elseif Random == 3 then
				        Util_CreateSquads(player3, AlliesOne, SBP.AEF.PATHFINDER_SQUAD_MP, mkr_alliesspawn)
                        Util_CreateSquads(player3, AlliesOne, SBP.BRITISH.SAPPER_SQUAD_MP, mkr_alliesspawn)
						Util_CreateSquads(player3, AlliesTwo, SBP.AEF.ASSAULT_ENGINEER_SQUAD_MP, mkr_alliesspawn)
						Util_CreateSquads(player3, AlliesTwo, SBP.BRITISH.TOMMY_SQUAD_MP, mkr_alliesspawn)
						Cmd_Move(AlliesOne, mkr_alliesdirecttop)
						Cmd_Move(AlliesTwo, mkr_alliesdirectbottom)
			    elseif Random == 4 then
				        Util_CreateSquads(player3, AlliesOne, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_alliesspawn)
                        Util_CreateSquads(player3, AlliesOne, SBP.BRITISH.SAPPER_SQUAD_MP, mkr_alliesspawn)
						Util_CreateSquads(player3, AlliesTwo, SBP.AEF.REAR_ECHELON_SQUAD_MP, mkr_alliesspawn)
						Util_CreateSquads(player3, AlliesTwo, SBP.BRITISH.COMMANDO_SQUAD_MP, mkr_alliesspawn)
						Cmd_Move(AlliesOne, mkr_alliesdirecttop)
						Cmd_Move(AlliesTwo, mkr_alliesdirectbottom)
			    elseif Random == 5 then
				        Util_CreateSquads(player3, AlliesOne, SBP.AEF.RANGER_SQUAD_MP, mkr_alliesspawn)
                        Util_CreateSquads(player3, AlliesOne, SBP.BRITISH.TOMMY_SQUAD_MP, mkr_alliesspawn)
						Util_CreateSquads(player3, AlliesTwo, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_alliesspawn)
						Util_CreateSquads(player3, AlliesTwo, SBP.BRITISH.SAPPER_SQUAD_MP, mkr_alliesspawn)
						Cmd_Move(AlliesOne, mkr_alliesdirecttop)
						Cmd_Move(AlliesTwo, mkr_alliesdirectbottom)
				elseif Random == 6 then
				        Util_CreateSquads(player3, AlliesOne, SBP.AEF.PARATROOPER_SQUAD_MP, mkr_alliesspawn)
                        Util_CreateSquads(player3, AlliesOne, SBP.BRITISH.COMMANDO_SQUAD_MP, mkr_alliesspawn)
						Util_CreateSquads(player3, AlliesTwo, SBP.AEF.RANGER_SQUAD_MP, mkr_alliesspawn)
						Util_CreateSquads(player3, AlliesTwo, SBP.BRITISH.SAPPER_SQUAD_MP, mkr_alliesspawn)
						Cmd_Move(AlliesOne, mkr_alliesdirecttop)
						Cmd_Move(AlliesTwo, mkr_alliesdirectbottom)
			    end
        end
end

function StreetBrummbarMove()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_streetbrummbartrigger, false)
        local Control2 = Prox_ArePlayersNearMarker(player2, mkr_streetbrummbartrigger, false)
        if Control1 == true or Control2 == true then
                Cmd_Move(StreetBrummbar, mkr_streetbrummbarto)
				Rule_RemoveMe()
        end
end

function StreetPershingMove()

        local Control1 = SGroup_IsUnderAttackByPlayer(StreetBrummbar, player1, 9000)
        local Control2 = SGroup_IsUnderAttackByPlayer(StreetBrummbar, player2, 9000)
		local Control3 = Prox_ArePlayersNearMarker(player1, mkr_pershingforcemove, false)
		local Control4 = Prox_ArePlayersNearMarker(player1, mkr_pershingforcemove, false)
        if Control1 == true or Control2 == true or Control3 == true or Control4 == true then
                Cmd_Move(StreetPershing, mkr_streetpershingto)
				Cmd_Move(StreetPara, mkr_streetparato)
				Cmd_Move(StreetRanger, mkr_streetrangerto)
				Rule_RemoveMe()
        end
end

function EstateSpawn()

        local Control1 = SGroup_Count(WalterSpawnControl)
		local Control2 = SGroup_Count(EstateControl)
        if Control1 == 0 and Control2 > 0 then
                local Random = World_GetRand(1, 5)
                if Random == 1 then
                        Util_CreateSquads(player5, EstateOne, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_estatespawntop)
                        Util_CreateSquads(player5, EstateTwo, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, mkr_estatespawnmid)
						Util_CreateSquads(player5, EstateTwo, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, mkr_estatespawnmid)
						Util_CreateSquads(player5, EstateThree, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_estatespawnbottom)
						Util_CreateSquads(player5, EstateThree, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, mkr_estatespawnbottom)
						Cmd_AttackMove(EstateOne, mkr_estatedirecttop)
						Cmd_AttackMove(EstateTwo, mkr_estatedirectmid)
						Cmd_Move(EstateThree, mkr_estatedirectbottom)
                elseif Random == 2 then
                        Util_CreateSquads(player5, EstateOne, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_estatespawntop)
                        Util_CreateSquads(player5, EstateOne, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_estatespawntop)
						Util_CreateSquads(player5, EstateTwo, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_estatespawnmid)
						Util_CreateSquads(player5, EstateThree, SBP.WEST_GERMAN.URBAN_ASSAULT_LIGHT_INFANTRY, mkr_estatespawnbottom)
						Util_CreateSquads(player5, EstateThree, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_estatespawnbottom)
						Cmd_Move(EstateOne, mkr_estatedirecttop)
						Cmd_AttackMove(EstateTwo, mkr_estatedirectmid)
						Cmd_AttackMove(EstateThree, mkr_estatedirectbottom)
                elseif Random == 3 then
				        Util_CreateSquads(player5, EstateOne, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, mkr_estatespawntop)
                        Util_CreateSquads(player5, EstateOne, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, mkr_estatespawntop)
						Util_CreateSquads(player5, EstateTwo, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, mkr_estatespawnmid)
						Util_CreateSquads(player5, EstateTwo, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_estatespawnmid)
						Util_CreateSquads(player5, EstateThree, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, mkr_estatespawnbottom)
						Cmd_AttackMove(EstateOne, mkr_estatedirecttop)
						Cmd_Move(EstateTwo, mkr_estatedirectmid)
						Cmd_AttackMove(EstateThree, mkr_estatedirectbottom)
			    elseif Random == 4 then
				        Util_CreateSquads(player5, EstateOne, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_estatespawntop)
                        Util_CreateSquads(player5, EstateOne, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_estatespawntop)
						Util_CreateSquads(player5, EstateTwo, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_estatespawnmid)
						Util_CreateSquads(player5, EstateTwo, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, mkr_estatespawnmid)
						Util_CreateSquads(player5, EstateThree, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_estatespawnbottom)
						Util_CreateSquads(player5, EstateThree, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_estatespawnbottom)
						Cmd_Move(EstateOne, mkr_estatedirecttop)
						Cmd_AttackMove(EstateTwo, mkr_estatedirectmid)
						Cmd_Move(EstateThree, mkr_estatedirectbottom)
			    elseif Random == 5 then
				        Util_CreateSquads(player5, EstateOne, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_estatespawntop)
                        Util_CreateSquads(player5, EstateOne, SBP.GERMAN.STORMTROOPER_SQUAD_MP, mkr_estatespawntop)
						Util_CreateSquads(player5, EstateTwo, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, mkr_estatespawnmid)
						Util_CreateSquads(player5, EstateTwo, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, mkr_estatespawnmid)
						Util_CreateSquads(player5, EstateThree, SBP.WEST_GERMAN.URBAN_ASSAULT_LIGHT_INFANTRY, mkr_estatespawnbottom)
						Util_CreateSquads(player5, EstateThree, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, mkr_estatespawnbottom)
						Cmd_AttackMove(EstateOne, mkr_estatedirecttop)
						Cmd_AttackMove(EstateTwo, mkr_estatedirectmid)
						Cmd_AttackMove(EstateThree, mkr_estatedirectbottom)
			    end
        end
end

function EstateWaves()

        local Control = SGroup_Count(WalterSpawnControl)
        if Control == 0 then
                Util_StartIntel(EVENTS.EstateAttacks)
                Rule_RemoveMe()
        end
end

function EstateMoveTop()

        local Control = Prox_ArePlayersNearMarker(player5, mkr_estatedirecttop, false)
        if Control == true then
                local Random = World_GetRand(1, 6)
                if Random == 1 then
				        Cmd_AttackMove(EstateOne, mkr_estatetargettop)
						SGroup_Clear(EstateOne)
				elseif Random == 2 then
				        Cmd_AttackMove(EstateOne, mkr_estatetargetmid)
						SGroup_Clear(EstateOne)
				elseif Random == 3 then
				        Cmd_AttackMove(EstateOne, mkr_estatetargetbottom)
						SGroup_Clear(EstateOne)
				elseif Random == 4 then
				        Cmd_Move(EstateOne, mkr_estatetargetbottom)
						SGroup_Clear(EstateOne)
				elseif Random == 5 then
				        Cmd_Move(EstateOne, mkr_estatetargetbottom)
						SGroup_Clear(EstateOne)
				elseif Random == 6 then
				        Cmd_Move(EstateOne, mkr_estatetargetbottom)
						SGroup_Clear(EstateOne)
				end
        end
end

function EstateMoveMid()

        local Control = Prox_ArePlayersNearMarker(player5, mkr_estatedirectmid, false)
        if Control == true then
                local Random = World_GetRand(1, 6)
                if Random == 1 then
				        Cmd_AttackMove(EstateTwo, mkr_estatetargettop)
						SGroup_Clear(EstateTwo)
				elseif Random == 2 then
				        Cmd_AttackMove(EstateTwo, mkr_estatetargetmid)
						SGroup_Clear(EstateTwo)
				elseif Random == 3 then
				        Cmd_AttackMove(EstateTwo, mkr_estatetargetbottom)
						SGroup_Clear(EstateTwo)
				elseif Random == 4 then
				        Cmd_Move(EstateTwo, mkr_estatetargetbottom)
						SGroup_Clear(EstateTwo)
				elseif Random == 5 then
				        Cmd_Move(EstateTwo, mkr_estatetargetbottom)
						SGroup_Clear(EstateTwo)
				elseif Random == 6 then
				        Cmd_Move(EstateTwo, mkr_estatetargetbottom)
						SGroup_Clear(EstateTwo)
				end
        end
end

function EstateMoveBottom()

        local Control = Prox_ArePlayersNearMarker(player5, mkr_estatedirectbottom, false)
        if Control == true then
                local Random = World_GetRand(1, 6)
                if Random == 1 then
				        Cmd_AttackMove(EstateThree, mkr_estatetargettop)
						SGroup_Clear(EstateThree)
				elseif Random == 2 then
				        Cmd_AttackMove(EstateThree, mkr_estatetargetmid)
						SGroup_Clear(EstateThree)
				elseif Random == 3 then
				        Cmd_AttackMove(EstateThree, mkr_estatetargetbottom)
						SGroup_Clear(EstateThree)
				elseif Random == 4 then
				        Cmd_Move(EstateThree, mkr_estatetargetbottom)
						SGroup_Clear(EstateThree)
				elseif Random == 5 then
				        Cmd_Move(EstateThree, mkr_estatetargetbottom)
						SGroup_Clear(EstateThree)
				elseif Random == 6 then
				        Cmd_Move(EstateThree, mkr_estatetargetbottom)
						SGroup_Clear(EstateThree)
				end
        end
end


function AlliesSpawn()

        local Control1 = SGroup_Count(WalterSpawnControl)
		local Control2 = SGroup_Count(EstateControl)
        if Control1 == 0 and Control2 > 0 then
                local Random = World_GetRand(1, 6)
                if Random == 1 then
                        Util_CreateSquads(player3, AlliesOne, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_alliesspawn)
                        Util_CreateSquads(player3, AlliesOne, SBP.BRITISH.SAPPER_SQUAD_MP, mkr_alliesspawn)
						Util_CreateSquads(player3, AlliesTwo, SBP.AEF.RANGER_SQUAD_MP, mkr_alliesspawn)
						Util_CreateSquads(player3, AlliesTwo, SBP.BRITISH.TOMMY_SQUAD_MP, mkr_alliesspawn)
						Cmd_Move(AlliesOne, mkr_alliesdirecttop)
						Cmd_Move(AlliesTwo, mkr_alliesdirectbottom)
                elseif Random == 2 then
                        Util_CreateSquads(player3, AlliesOne, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_alliesspawn)
                        Util_CreateSquads(player3, AlliesOne, SBP.BRITISH.COMMANDO_SQUAD_MP, mkr_alliesspawn)
						Util_CreateSquads(player3, AlliesTwo, SBP.AEF.PARATROOPER_SQUAD_MP, mkr_alliesspawn)
						Util_CreateSquads(player3, AlliesTwo, SBP.BRITISH.TOMMY_SQUAD_MP, mkr_alliesspawn)
						Cmd_Move(AlliesOne, mkr_alliesdirecttop)
						Cmd_Move(AlliesTwo, mkr_alliesdirectbottom)
                elseif Random == 3 then
				        Util_CreateSquads(player3, AlliesOne, SBP.AEF.PATHFINDER_SQUAD_MP, mkr_alliesspawn)
                        Util_CreateSquads(player3, AlliesOne, SBP.BRITISH.SAPPER_SQUAD_MP, mkr_alliesspawn)
						Util_CreateSquads(player3, AlliesTwo, SBP.AEF.ASSAULT_ENGINEER_SQUAD_MP, mkr_alliesspawn)
						Util_CreateSquads(player3, AlliesTwo, SBP.BRITISH.TOMMY_SQUAD_MP, mkr_alliesspawn)
						Cmd_Move(AlliesOne, mkr_alliesdirecttop)
						Cmd_Move(AlliesTwo, mkr_alliesdirectbottom)
			    elseif Random == 4 then
				        Util_CreateSquads(player3, AlliesOne, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_alliesspawn)
                        Util_CreateSquads(player3, AlliesOne, SBP.BRITISH.SAPPER_SQUAD_MP, mkr_alliesspawn)
						Util_CreateSquads(player3, AlliesTwo, SBP.AEF.REAR_ECHELON_SQUAD_MP, mkr_alliesspawn)
						Util_CreateSquads(player3, AlliesTwo, SBP.BRITISH.COMMANDO_SQUAD_MP, mkr_alliesspawn)
						Cmd_Move(AlliesOne, mkr_alliesdirecttop)
						Cmd_Move(AlliesTwo, mkr_alliesdirectbottom)
			    elseif Random == 5 then
				        Util_CreateSquads(player3, AlliesOne, SBP.AEF.RANGER_SQUAD_MP, mkr_alliesspawn)
                        Util_CreateSquads(player3, AlliesOne, SBP.BRITISH.TOMMY_SQUAD_MP, mkr_alliesspawn)
						Util_CreateSquads(player3, AlliesTwo, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_alliesspawn)
						Util_CreateSquads(player3, AlliesTwo, SBP.BRITISH.SAPPER_SQUAD_MP, mkr_alliesspawn)
						Cmd_Move(AlliesOne, mkr_alliesdirecttop)
						Cmd_Move(AlliesTwo, mkr_alliesdirectbottom)
				elseif Random == 6 then
				        Util_CreateSquads(player3, AlliesOne, SBP.AEF.PARATROOPER_SQUAD_MP, mkr_alliesspawn)
                        Util_CreateSquads(player3, AlliesOne, SBP.BRITISH.COMMANDO_SQUAD_MP, mkr_alliesspawn)
						Util_CreateSquads(player3, AlliesTwo, SBP.AEF.RANGER_SQUAD_MP, mkr_alliesspawn)
						Util_CreateSquads(player3, AlliesTwo, SBP.BRITISH.SAPPER_SQUAD_MP, mkr_alliesspawn)
						Cmd_Move(AlliesOne, mkr_alliesdirecttop)
						Cmd_Move(AlliesTwo, mkr_alliesdirectbottom)
			    end
        end
end

function AlliesMoveTop()

        local Control = Prox_ArePlayersNearMarker(player3, mkr_alliesdirecttop, false)
        if Control == true then
                local Random = World_GetRand(1, 3)
                if Random == 1 then
				        Cmd_AttackMove(AlliesOne, mkr_alliestargettop)
						SGroup_Clear(AlliesOne)
				elseif Random == 2 then
				        Cmd_AttackMove(AlliesOne, mkr_alliestargetmid)
						SGroup_Clear(AlliesOne)
				elseif Random == 3 then
				        Cmd_AttackMove(AlliesOne, mkr_alliestargetbottom)
						SGroup_Clear(AlliesOne)
				end
        end
end

function AlliesMoveBottom()

        local Control = Prox_ArePlayersNearMarker(player3, mkr_alliesdirectbottom, false)
        if Control == true then
                local Random = World_GetRand(1, 3)
                if Random == 1 then
				        Cmd_AttackMove(AlliesTwo, mkr_alliestargettop)
						SGroup_Clear(AlliesTwo)
				elseif Random == 2 then
				        Cmd_AttackMove(AlliesTwo, mkr_alliestargetmid)
						SGroup_Clear(AlliesTwo)
				elseif Random == 3 then
				        Cmd_AttackMove(AlliesTwo, mkr_alliestargetbottom)
						SGroup_Clear(AlliesTwo)
				end
        end
end


------------------------------Hill Event---------------------------------

function HillEvent()

        Rule_AddDelayedInterval(PershingDestroy, 1, 1)
        Rule_AddDelayedInterval(BridgeCinematic, 1, 1)
		
		Rule_AddDelayedInterval(HillSpawns, 1, 1)
		Rule_AddDelayedInterval(HillMove, 1, 5)
		Rule_AddDelayedInterval(HillDisappear, 1, 1)
		
		Rule_AddDelayedInterval(HillReinforcement, 1, 1)
		Rule_AddDelayedInterval(HillMoveOne, 1, 3)
		Rule_AddDelayedInterval(HillMoveTwo, 1, 3)
		Rule_AddDelayedInterval(HillMoveThree, 1, 3)
		
		Rule_AddDelayedInterval(HillEnemySpawn, 1, 90)
		
		Rule_AddDelayedInterval(HillAttackTwo, 1, 1)
		Rule_AddDelayedInterval(HillAttackThree, 1, 1)
		
		Rule_AddDelayedInterval(UlrichAppear, 1, 1)
		
		Rule_AddDelayedInterval(TigerMoveOne, 1, 1)
		Rule_AddDelayedInterval(TigerMoveTwo, 1, 1)
		Rule_AddDelayedInterval(TigerMoveThree, 1, 1)
		Rule_AddDelayedInterval(FriedrichDeath, 1, 1)

end

function PershingDestroy()

        local Control = SGroup_Count(EstateOfficer)
        if Control == 0 then
                SGroup_Kill(StreetPershing)
				Cmd_UngarrisonSquad(SovietGroup)
				SGroup_WarpToMarker(Walter, mkr_walterwarp)
				SGroup_WarpToMarker(Fritz, mkr_walterwarp)
				SGroup_WarpToMarker(Giovanni, mkr_walterwarp)
				SGroup_WarpToMarker(Jaap, mkr_walterwarp)
				SGroup_WarpToMarker(Jacques, mkr_walterwarp)
				SGroup_WarpToMarker(Olav, mkr_walterwarp)
				SGroup_Kill(StreetPara)
				SGroup_Kill(StreetRanger)
				Blip5 = UI_CreateMinimapBlip(Point4, 9000, BT_ObjectivePrimary)
	            UI_DeleteMinimapBlip(Blip4)
				World_GetCurrentInteractionStage()
                World_IncreaseInteractionStage()
		        Rule_RemoveMe()
        end
end

function BridgeCinematic()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_hilleventtrigger, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_hilleventtrigger, false)
        if Control1 == true or Control2 == true then
		        local Control = SGroup_Count(EstateOfficer)
				if Control == 0 then
                        Util_StartIntel(EVENTS.BridgeTalk)
                        Rule_RemoveMe()
				end
        end
end

function HillSpawns()

        local Control = SGroup_Count(HillControl)
        if Control == 0 then
                local SpawnUnit1 = SGroup_Count(SpawnMedic)
				local SpawnUnit2 = SGroup_Count(SpawnTommy)
				local SpawnUnit3 = SGroup_Count(SpawnAssEngineer)
				local SpawnUnit4 = SGroup_Count(SpawnRifle)
				local SpawnUnit5 = SGroup_Count(SpawnTruck)
				local SpawnUnit6 = SGroup_Count(SpawnCarrier)
				local SpawnUnit7 = SGroup_Count(SpawnJeep)
				local SpawnUnit8 = SGroup_Count(SpawnHalftrack)
                if SpawnUnit1 == 0 then
                        Util_CreateSquads(player3, SpawnMedic, SBP.AEF.USF_MEDIC_SQUAD_MP, mkr_spawnstart1)
                elseif SpawnUnit2 == 0 then
                        Util_CreateSquads(player3, SpawnTommy, SBP.BRITISH.TOMMY_SQUAD_MP, mkr_spawnstart2)
                elseif SpawnUnit3 == 0 then
                        Util_CreateSquads(player3, SpawnAssEngineer, SBP.AEF.ASSAULT_ENGINEER_SQUAD_MP, mkr_spawnstart3)
				elseif SpawnUnit4 == 0 then
                        Util_CreateSquads(player3, SpawnRifle, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_spawnstart4)
				elseif SpawnUnit5 == 0 then
                        Util_CreateSquads(player3, SpawnTruck, SBP.AEF.DODGE_WC51_AMBULANCE_SQUAD_MP, mkr_spawnstart1)
				elseif SpawnUnit6 == 0 then
                        Util_CreateSquads(player3, SpawnCarrier, SBP.BRITISH.UNIVERSAL_CARRIER_SQUAD_MP, mkr_spawnstart2)
				elseif SpawnUnit7 == 0 then
                        Util_CreateSquads(player3, SpawnJeep, SBP.AEF.M20_UTILITY_CAR_SQUAD_MP, mkr_spawnstart3)
				elseif SpawnUnit8 == 0 then
                        Util_CreateSquads(player3, SpawnHalftrack, SBP.AEF.M15A1_AA_HALFTRACK_SQUAD_MP, mkr_spawnstart4)	
			    end
        end
end



function HillMove()

        Cmd_Move(SpawnRifle, mkr_spawndestination)
		Cmd_Move(SpawnTommy, mkr_spawndestination)
		Cmd_Move(SpawnAssEngineer, mkr_spawndestination)
		Cmd_Move(SpawnCarrier, mkr_spawndestination)
		Cmd_Move(SpawnJeep, mkr_spawndestination)
		Cmd_Move(SpawnMedic, mkr_spawndestination)
		Cmd_Move(SpawnTruck, mkr_spawndestination)
		Cmd_Move(SpawnHalftrack, mkr_spawndestination)

end

function HillDisappear()

        local Control = SGroup_Count(HillControl)
        if Control == 0 then
                local SpawnUnit1 = Prox_AreSquadMembersNearMarker(SpawnMedic, mkr_spawndestination, true)
				local SpawnUnit2 = Prox_AreSquadMembersNearMarker(SpawnTommy, mkr_spawndestination, true)
				local SpawnUnit3 = Prox_AreSquadMembersNearMarker(SpawnAssEngineer, mkr_spawndestination, true)
				local SpawnUnit4 = Prox_AreSquadMembersNearMarker(SpawnRifle, mkr_spawndestination, true)
				local SpawnUnit5 = Prox_AreSquadMembersNearMarker(SpawnTruck, mkr_spawndestination, true)
				local SpawnUnit6 = Prox_AreSquadMembersNearMarker(SpawnCarrier, mkr_spawndestination, true)
				local SpawnUnit7 = Prox_AreSquadMembersNearMarker(SpawnJeep, mkr_spawndestination, true)
				local SpawnUnit8 = Prox_AreSquadMembersNearMarker(SpawnHalftrack, mkr_spawndestination, true)
                if SpawnUnit1 == true then
                        SGroup_DestroyAllSquads(SpawnMedic)
                elseif SpawnUnit2 == true then
                        SGroup_DestroyAllSquads(SpawnTommy)
                elseif SpawnUnit3 == true then
                        SGroup_DestroyAllSquads(SpawnAssEngineer)
				elseif SpawnUnit4 == true then
                        SGroup_DestroyAllSquads(SpawnRifle)
				elseif SpawnUnit5 == true then
                        SGroup_DestroyAllSquads(SpawnTruck)
				elseif SpawnUnit6 == true then
                        SGroup_DestroyAllSquads(SpawnCarrier)
				elseif SpawnUnit7 == true then
                        SGroup_DestroyAllSquads(SpawnJeep)
				elseif SpawnUnit8 == true then
                        SGroup_DestroyAllSquads(SpawnHalftrack)
			    end
        end
end

function HillReinforcement()

        local Control = SGroup_Count(HillControl)
        if Control == 0 then
                local SpawnUnit1 = SGroup_Count(HillTommy)
				local SpawnUnit2 = SGroup_Count(HillATTommy)
				local SpawnUnit3 = SGroup_Count(HillRifle)
				local SpawnUnit4 = SGroup_Count(HillPara)
				local SpawnUnit5 = SGroup_Count(HillPathfinder)
				local SpawnUnit6 = SGroup_Count(HillMedic)
				local SpawnUnit7 = SGroup_Count(HillRanger)
				local SpawnUnit8 = SGroup_Count(HillTowerMedic)
                if SpawnUnit1 == 0 then
                        Util_CreateSquads(player3, HillTommy, SBP.BRITISH.TOMMY_SQUAD_MP, mkr_spawnstart1)
						Cmd_Move(HillTommy, mkr_hilltommyto)
                elseif SpawnUnit2 == 0 then
                        Util_CreateSquads(player3, HillATTommy, SBP.BRITISH.TOMMY_SQUAD_TANK_HUNTER_MP, mkr_spawnstart2)
						Cmd_Move(HillATTommy, mkr_hillattommyto)
                elseif SpawnUnit3 == 0 then
                        Util_CreateSquads(player3, HillRifle, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_spawnstart3)
						Cmd_Move(HillRifle, mkr_hillrifleto)
				elseif SpawnUnit4 == 0 then
                        Util_CreateSquads(player3, HillPara, SBP.AEF.PARATROOPER_SQUAD_MP, mkr_spawnstart4)
						Cmd_Move(HillPara, mkr_hillparato)
				elseif SpawnUnit5 == 0 then
                        Util_CreateSquads(player3, HillPathfinder, SBP.AEF.PATHFINDER_SQUAD_MP, mkr_spawnstart1)
						Cmd_Move(HillPathfinder, mkr_hillpathfinderto)
				elseif SpawnUnit6 == 0 then
                        Util_CreateSquads(player3, HillMedic, SBP.BRITISH.BRIT_MEDIC_SQUAD_MP, mkr_spawnstart2)
						Cmd_Move(HillMedic, mkr_hillmedicto)
				elseif SpawnUnit7 == 0 then
                        Util_CreateSquads(player3, HillRanger, SBP.AEF.RANGER_SQUAD_MP, mkr_spawnstart3)
						Cmd_Move(HillRanger, mkr_hillrangerto)
				elseif SpawnUnit8 == 0 then
                        Util_CreateSquads(player3, HillTowerMedic, SBP.AEF.USF_MEDIC_SQUAD_MP, mkr_spawnstart4)
						Cmd_Move(HillTowerMedic, mkr_hilltowermedicto)
			    end
        end
end

function HillMoveOne()

        local Control1 = Prox_ArePlayersNearMarker(player5, mkr_hillspawnbottom, false)
		local Control2 = Prox_ArePlayersNearMarker(player6, mkr_hillspawnbottom, false)
        if Control1 == true or Control2 == true then
                local Random = World_GetRand(1, 6)
                if Random == 1 then
				        Cmd_AttackMove(HillOne, mkr_hilltarget1)
						SGroup_Clear(HillOne)
				elseif Random == 2 then
				        Cmd_AttackMove(HillOne, mkr_hilltarget2)
						SGroup_Clear(HillOne)
				elseif Random == 3 then
				        Cmd_AttackMove(HillOne, mkr_hilltarget3)
						SGroup_Clear(HillOne)
				elseif Random == 4 then
				        Cmd_Move(HillOne, mkr_hilltarget1)
						SGroup_Clear(HillOne)
				elseif Random == 5 then
				        Cmd_Move(HillOne, mkr_hilltarget2)
						SGroup_Clear(HillOne)
				elseif Random == 6 then
				        Cmd_Move(HillOne, mkr_hilltarget3)
						SGroup_Clear(HillOne)
				end
        end
end

function HillMoveTwo()

        local Control1 = Prox_ArePlayersNearMarker(player5, mkr_hillspawnmid, false)
		local Control2 = Prox_ArePlayersNearMarker(player6, mkr_hillspawnmid, false)
        if Control1 == true or Control2 == true then
                local Random = World_GetRand(1, 6)
                if Random == 1 then
				        Cmd_AttackMove(HillTwo, mkr_hilltarget2)
						SGroup_Clear(HillTwo)
				elseif Random == 2 then
				        Cmd_AttackMove(HillTwo, mkr_hilltarget3)
						SGroup_Clear(HillTwo)
				elseif Random == 3 then
				        Cmd_AttackMove(HillTwo, mkr_hilltarget4)
						SGroup_Clear(HillTwo)
				elseif Random == 4 then
				        Cmd_Move(HillTwo, mkr_hilltarget2)
						SGroup_Clear(HillTwo)
				elseif Random == 5 then
				        Cmd_Move(HillTwo, mkr_hilltarget3)
						SGroup_Clear(HillTwo)
				elseif Random == 6 then
				        Cmd_Move(HillTwo, mkr_hilltarget4)
						SGroup_Clear(HillTwo)
				end
        end
end

function HillMoveThree()

        local Control1 = Prox_ArePlayersNearMarker(player5, mkr_hillspawntop, false)
		local Control2 = Prox_ArePlayersNearMarker(player6, mkr_hillspawntop, false)
        if Control1 == true or Control2 == true then
                local Random = World_GetRand(1, 6)
                if Random == 1 then
				        Cmd_AttackMove(HillThree, mkr_hilltarget4)
						SGroup_Clear(HillThree)
				elseif Random == 2 then
				        Cmd_AttackMove(HillThree, mkr_hilltarget5)
						SGroup_Clear(HillThree)
				elseif Random == 3 then
				        Cmd_AttackMove(HillThree, mkr_hilltarget6)
						SGroup_Clear(HillThree)
				elseif Random == 4 then
				        Cmd_Move(HillThree, mkr_hilltarget4)
						SGroup_Clear(HillThree)
				elseif Random == 5 then
				        Cmd_Move(HillThree, mkr_hilltarget5)
						SGroup_Clear(HillThree)
				elseif Random == 6 then
				        Cmd_Move(HillThree, mkr_hilltarget6)
						SGroup_Clear(HillThree)
				end
        end
end

function HillEnemySpawn()

        local Control1 = SGroup_Count(HillControl)
		local Control2 = SGroup_Count(HillSecondControl)
		local Control3 = SGroup_Count(Friedrich)
        if Control1 == 0 and Control2 == 0 and Control3 > 0 then
                local Random = World_GetRand(1, 6)
                if Random == 1 then
                        Util_CreateSquads(player5, HillOne, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_hillspawnbottom)
                        Util_CreateSquads(player5, HillTwo, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_hillspawnmid)
						Util_CreateSquads(player5, HillTwo, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_hillspawnmid)
						Util_CreateSquads(player5, HillThree, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_hillspawntop)
                elseif Random == 2 then
                        Util_CreateSquads(player5, HillOne, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_hillspawnbottom)
						Util_CreateSquads(player5, HillOne, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_hillspawnbottom)
                        Util_CreateSquads(player5, HillTwo, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_hillspawnmid)
						Util_CreateSquads(player5, HillThree, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_hillspawntop)
                elseif Random == 3 then
				        Util_CreateSquads(player5, HillOne, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_hillspawnbottom)
                        Util_CreateSquads(player5, HillTwo, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_hillspawnmid)
						Util_CreateSquads(player5, HillThree, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_hillspawntop)
						Util_CreateSquads(player5, HillThree, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_hillspawntop)
			    elseif Random == 4 then
				        Util_CreateSquads(player5, HillOne, SBP.GERMAN.STORMTROOPER_SQUAD_MP, mkr_hillspawnbottom)
                        Util_CreateSquads(player5, HillTwo, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_hillspawnmid)
						Util_CreateSquads(player5, HillTwo, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_hillspawnmid)
						Util_CreateSquads(player5, HillThree, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_hillspawntop)
			    elseif Random == 5 then
				        Util_CreateSquads(player5, HillOne, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_hillspawnbottom)
                        Util_CreateSquads(player5, HillOne, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_hillspawnbottom)
						Util_CreateSquads(player5, HillTwo, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_hillspawnmid)
						Util_CreateSquads(player5, HillThree, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, mkr_hillspawntop)
				elseif Random == 6 then
				        Util_CreateSquads(player5, HillOne, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_hillspawnbottom)
                        Util_CreateSquads(player5, HillTwo, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_hillspawnmid)
						Util_CreateSquads(player5, HillThree, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_hillspawntop)
						Util_CreateSquads(player5, HillThree, SBP.GERMAN.URBAN_ASSAULT_PANZER_GRENADIER_SQUAD_MP, mkr_hillspawntop)
			    end
        end
end

function HillAttackTwo()

        local Control = SGroup_Count(HillGroupOne)
        if Control == 0 then
		        Util_StartIntel(EVENTS.HillWaveTwo)
                Rule_RemoveMe()
		end
end

function HillAttackThree()

        local Control = SGroup_Count(HillGroupTwo)
        if Control == 0 then
		        Util_StartIntel(EVENTS.HillWaveThree)
                Rule_RemoveMe()
		end
end

function UlrichAppear()

        local Control = Prox_ArePlayersNearMarker(player8, mkr_ulrichto, false)
        if Control == true then
                Util_StartIntel(EVENTS.UlrichDialogue)
                Rule_RemoveMe()
        end
end

function TigerMoveOne()

        local Control = SGroup_Count(HillGroupThree)
        if Control == 0 then
		        Util_StartIntel(EVENTS.TigerArrive)
                Rule_RemoveMe()
		end
end

function TigerMoveTwo()

        local Control1 = SGroup_Count(HillGroupThree)
		local Control2 = Prox_ArePlayersNearMarker(player6, mkr_tigerto1, false)
        if Control1 == 0 and Control2 == true then
		        Cmd_Move(TigerElite, mkr_tigerto2)
				Util_CreateSquads(player5, SpecialSquad, SBP.GERMAN.URBAN_ASSAULT_PANZER_GRENADIER_SQUAD_MP, mkr_hillspawntop)
				Util_CreateSquads(player5, SpecialSquad, SBP.GERMAN.URBAN_ASSAULT_PANZER_GRENADIER_SQUAD_MP, mkr_hillspawntop)
				Util_CreateSquads(player5, SpecialSquad, SBP.GERMAN.URBAN_ASSAULT_PANZER_GRENADIER_SQUAD_MP, mkr_hillspawntop)
                Rule_RemoveMe()
		end
end

function TigerMoveThree()

        local Control1 = SGroup_Count(HillGroupThree)
		local Control2 = Prox_ArePlayersNearMarker(player6, mkr_tigerto2, false)
        if Control1 == 0 and Control2 == true then
		        Cmd_Move(TigerElite, mkr_tigerto3)
				Cmd_Move(SpecialSquad, mkr_hilltarget6)
                Rule_RemoveMe()
		end
end

function FriedrichDeath()

        local Control1 = SGroup_Count(HillGroupThree)
		local Control2 = Prox_ArePlayersNearMarker(player6, mkr_tigerto3, false)
        if Control1 == 0 and Control2 == true then
		        Util_StartIntel(EVENTS.TowerFalls)
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
		
		Modify_ReceivedDamage(Tomislav, 0.5)
        Modify_ReceivedAccuracy(Tomislav, 0.4)

        Modify_ReceivedDamage(Vladilen, 0.05)
        Modify_ReceivedAccuracy(Vladilen, 0.05)
        Modify_ReceivedDamage(Stator, 0.05)
        Modify_ReceivedAccuracy(Stator, 0.05)
        Modify_ReceivedDamage(Aleksei, 0.05)
        Modify_ReceivedAccuracy(Aleksei, 0.05)
        Modify_ReceivedDamage(Nikolai, 0.05)
        Modify_ReceivedAccuracy(Nikolai, 0.05)
        Modify_ReceivedDamage(Yuri, 0.05)
        Modify_ReceivedAccuracy(Yuri, 0.05)
        Modify_ReceivedDamage(Viktor, 0.05)
        Modify_ReceivedAccuracy(Viktor, 0.05)
        Modify_ReceivedDamage(Dmitriy, 0.05)
        Modify_ReceivedAccuracy(Dmitriy, 0.05)
		
		Modify_ReceivedDamage(Winter, 0.05)
        Modify_ReceivedAccuracy(Winter, 0.05)
		Modify_ReceivedDamage(Fitzgerald, 0.05)
        Modify_ReceivedAccuracy(Fitzgerald, 0.05)
		
		Modify_ReceivedDamage(Walter, 0.4)
        Modify_ReceivedAccuracy(Walter, 0.7)
        Modify_ReceivedDamage(Fritz, 0.3)
        Modify_ReceivedAccuracy(Fritz, 0.6)
        Modify_ReceivedDamage(Jaap, 0.5)
        Modify_ReceivedAccuracy(Jaap, 0.5)
        Modify_ReceivedDamage(Jacques, 0.3)
        Modify_ReceivedAccuracy(Jacques, 0.5)
        Modify_ReceivedDamage(Olav, 0.5)
        Modify_ReceivedAccuracy(Olav, 0.6)
		Modify_ReceivedDamage(Giovanni, 0.3)
        Modify_ReceivedAccuracy(Giovanni, 0.5)
		
		Modify_ReceivedDamage(TramThirdPG, 0.6)
        Modify_ReceivedAccuracy(TramThirdPG, 0.6)
		Modify_ReceivedDamage(TramThirdStorm, 0.6)
        Modify_ReceivedAccuracy(TramThirdStorm, 0.6)
		Modify_ReceivedDamage(TramFourthAssGren, 0.5)
        Modify_ReceivedAccuracy(TramFourthAssGren, 0.5)
		Modify_ReceivedDamage(TramFourthGrens, 0.5)
        Modify_ReceivedAccuracy(TramFourthGrens, 0.5)
		Modify_ReceivedDamage(TramFourthMG, 0.5)
        Modify_ReceivedAccuracy(TramFourthMG, 0.5)
		Modify_ReceivedDamage(TramFourthOber, 0.5)
        Modify_ReceivedAccuracy(TramFourthOber, 0.5)
		Modify_ReceivedDamage(TramFourthFalls, 0.5)
        Modify_ReceivedAccuracy(TramFourthFalls, 0.5)
		
		Modify_ReceivedDamage(EstateOfficer, 0.6)
        Modify_ReceivedAccuracy(EstateOfficer, 0.6)
		Modify_ReceivedDamage(EstateFalls, 0.7)
        Modify_ReceivedAccuracy(EstateFalls, 0.7)
		Modify_ReceivedDamage(EstateMG, 0.8)
        Modify_ReceivedAccuracy(EstateMG, 0.8)
		Modify_ReceivedDamage(StreetOber, 0.6)
        Modify_ReceivedAccuracy(StreetOber, 0.6)
		Modify_ReceivedDamage(StreetGren, 0.6)
        Modify_ReceivedAccuracy(StreetGren, 0.6)
		Modify_ReceivedDamage(HillPioneerElite, 0.5)
        Modify_ReceivedAccuracy(HillPioneerElite, 0.5)
		Modify_ReceivedDamage(HillAssGrenElite, 0.4)
        Modify_ReceivedAccuracy(HillAssGrenElite, 0.4)
		Modify_ReceivedDamage(HillGrenElite, 0.6)
        Modify_ReceivedAccuracy(HillGrenElite, 0.6)
		Modify_ReceivedDamage(HillStormtrooper, 0.5)
        Modify_ReceivedAccuracy(HillStormtrooper, 0.5)
		Modify_ReceivedDamage(HillAssPioneer, 0.4)
        Modify_ReceivedAccuracy(HillAssPioneer, 0.5)
		Modify_ReceivedDamage(HillPanzer, 0.5)
        Modify_ReceivedAccuracy(HillPanzer, 0.5)
		Modify_ReceivedDamage(HillCarEliteBottom, 0.7)
        Modify_ReceivedAccuracy(HillCarEliteBottom, 0.4)
		Modify_ReceivedDamage(HillCarEliteMid, 0.7)
        Modify_ReceivedAccuracy(HillCarEliteMid, 0.4)
		Modify_ReceivedDamage(HillHalftrackElite, 0.8)
        Modify_ReceivedAccuracy(HillHalftrackElite, 0.6)
		Modify_ReceivedDamage(HillOstwind, 0.7)
        Modify_ReceivedAccuracy(HillOstwind, 0.7)
		Modify_ReceivedDamage(HillOberEliteTop, 0.6)
        Modify_ReceivedAccuracy(HillOberEliteTop, 0.6)
		Modify_ReceivedDamage(HillOberEliteMid, 0.6)
        Modify_ReceivedAccuracy(HillOberEliteMid, 0.6)
		Modify_ReceivedDamage(HillFallsEliteMid, 0.6)
        Modify_ReceivedAccuracy(HillFallsEliteMid, 0.6)
		Modify_ReceivedDamage(HillFallsEliteBottom, 0.6)
        Modify_ReceivedAccuracy(HillFallsEliteBottom, 0.6)
		Modify_ReceivedDamage(HillUlrichGren, 0.5)
        Modify_ReceivedAccuracy(HillUlrichGren, 0.5)
		Modify_ReceivedDamage(HillUlrichAssGren, 0.5)
        Modify_ReceivedAccuracy(HillUlrichAssGren, 0.5)
		Modify_ReceivedDamage(Ulrich, 0.4)
        Modify_ReceivedAccuracy(Ulrich, 0.4)
		Modify_ReceivedDamage(TigerElite, 0.05)
        Modify_ReceivedAccuracy(TigerElite, 0.05)
		Modify_ReceivedDamage(HillHetzer, 0.8)
        Modify_ReceivedAccuracy(HillHetzer, 0.7)
		Modify_ReceivedDamage(HillPuma, 0.6)
        Modify_ReceivedAccuracy(HillPuma, 0.7)
		Modify_ReceivedDamage(HillTankPanzer, 0.7)
        Modify_ReceivedAccuracy(HillTankPanzer, 0.7)
		
end

function EliteNames()

        local EliteName1 = Util_CreateLocString("Kurt Bachmann")
        local EliteName2 = Util_CreateLocString("Friedrich Althaus")
        local EliteName3 = Util_CreateLocString("Otto Baasch")
        local EliteName4 = Util_CreateLocString("Hans Dunkel")
        local EliteName5 = Util_CreateLocString("Jozef Smrek")
        HintMouseover_Add(EliteName1, Kurt, 5, true)
        HintMouseover_Add(EliteName2, Friedrich, 5, true)
        HintMouseover_Add(EliteName3, Otto, 5, true)
        HintMouseover_Add(EliteName4, Hans, 5, true)
        HintMouseover_Add(EliteName5, Jozef, 5, true)

        local EliteName6 = Util_CreateLocString("Walter Hinkel")
        local EliteName7 = Util_CreateLocString("Fritz Hudel")
        local EliteName8 = Util_CreateLocString("Jaap van Gilse")
        local EliteName9 = Util_CreateLocString("Jacques Villon")
        local EliteName10 = Util_CreateLocString("Olav Storsveen")
        local EliteName11 = Util_CreateLocString("Giovanni Bassi")
        HintMouseover_Add(EliteName6, Walter, 5, true)
        HintMouseover_Add(EliteName7, Fritz, 5, true)
        HintMouseover_Add(EliteName8, Jaap, 5, true)
        HintMouseover_Add(EliteName9, Jacques, 5, true)
        HintMouseover_Add(EliteName10, Olav, 5, true)
        HintMouseover_Add(EliteName11, Giovanni, 5, true)
        SGroup_IncreaseVeterancyRank(Walter, 5, false)
        SGroup_IncreaseVeterancyRank(Fritz, 5, false)
        SGroup_IncreaseVeterancyRank(Jaap, 5, false)
        SGroup_IncreaseVeterancyRank(Jacques, 5, false)
        SGroup_IncreaseVeterancyRank(Olav, 5, false)
        SGroup_IncreaseVeterancyRank(Giovanni, 5, false)

        local EliteName12 = Util_CreateLocString("Aleksei Zaytsev")
        local EliteName13 = Util_CreateLocString("Dmitriy Titov")
        local EliteName14 = Util_CreateLocString("Nikolai Pukhov")
        local EliteName15 = Util_CreateLocString("Stator Vasnetsov")
        local EliteName16 = Util_CreateLocString("Vladilen Vasnetsov")
        local EliteName17 = Util_CreateLocString("Yuri Konev")
        local EliteName18 = Util_CreateLocString("Viktor Vasilevsky")
        HintMouseover_Add(EliteName12, Aleksei, 5, true)
        HintMouseover_Add(EliteName13, Dmitriy, 5, true)
        HintMouseover_Add(EliteName14, Nikolai, 5, true)
        HintMouseover_Add(EliteName15, Stator, 5, true)
        HintMouseover_Add(EliteName16, Vladilen, 5, true)
        HintMouseover_Add(EliteName17, Yuri, 5, true)
        HintMouseover_Add(EliteName18, Viktor, 5, true)
        SGroup_IncreaseVeterancyRank(Aleksei, 3, false)
        SGroup_IncreaseVeterancyRank(Dmitriy, 3, false)
        SGroup_IncreaseVeterancyRank(Nikolai, 3, false)
        SGroup_IncreaseVeterancyRank(Stator, 3, false)
        SGroup_IncreaseVeterancyRank(Vladilen, 3, false)
        SGroup_IncreaseVeterancyRank(Yuri, 3, false)
        SGroup_IncreaseVeterancyRank(Viktor, 3, false)
		
        local EliteName19 = Util_CreateLocString("Task Force 'Eva' Shock Troopers")		
        HintMouseover_Add(EliteName19, TramThirdPG, 5, true)
        SGroup_IncreaseVeterancyRank(TramThirdPG, 2, false)	
        local EliteName20 = Util_CreateLocString("Task Force 'Eva' Stormtroopers")		
        HintMouseover_Add(EliteName20, TramThirdStorm, 5, true)
        SGroup_IncreaseVeterancyRank(TramThirdStorm, 2, false)
        local EliteName21 = Util_CreateLocString("Task Force 'Eva' Vanguards")		
        HintMouseover_Add(EliteName21, TramFourthAssGren, 5, true)
        SGroup_IncreaseVeterancyRank(TramFourthAssGren, 3, false)	
        local EliteName22 = Util_CreateLocString("Task Force 'Eva' Assault Riflemen")		
        HintMouseover_Add(EliteName22, TramFourthGrens, 5, true)
        SGroup_IncreaseVeterancyRank(TramFourthGrens, 3, false)	
        local EliteName23 = Util_CreateLocString("Task Force 'Eva' Support Specialists")		
        HintMouseover_Add(EliteName23, TramFourthMG, 5, true)
        SGroup_IncreaseVeterancyRank(TramFourthMG, 5, false)	
        local EliteName24 = Util_CreateLocString("Task Force 'Eva' Supreme Rifles")		
        HintMouseover_Add(EliteName24, TramFourthOber, 5, true)
        SGroup_IncreaseVeterancyRank(TramFourthOber, 5, false)	
        local EliteName25 = Util_CreateLocString("Task Force 'Eva' Elite Paratroopers")		
        HintMouseover_Add(EliteName25, TramFourthFalls, 5, true)
        SGroup_IncreaseVeterancyRank(TramFourthFalls, 5, false)		

        local EliteName26 = Util_CreateLocString("Officer Dassler")		
        HintMouseover_Add(EliteName26, EstateOfficer, 5, true)
        SGroup_IncreaseVeterancyRank(EstateOfficer, 3, false)
        local EliteName27 = Util_CreateLocString("8th Special Operations")		
        HintMouseover_Add(EliteName27, EstateFalls, 5, true)
        SGroup_IncreaseVeterancyRank(EstateFalls, 5, false)
        local EliteName28 = Util_CreateLocString("21st Special Operations")		
        HintMouseover_Add(EliteName28, EstateMG, 5, true)
        SGroup_IncreaseVeterancyRank(EstateMG, 5, false)		
		local EliteName29 = Util_CreateLocString("5th Special Operations")		
        HintMouseover_Add(EliteName29, StreetOber, 5, true)
        SGroup_IncreaseVeterancyRank(StreetOber, 5, false)	
		local EliteName30 = Util_CreateLocString("29th Special Operations")		
        HintMouseover_Add(EliteName30, StreetGren, 5, true)
        SGroup_IncreaseVeterancyRank(StreetGren, 5, false)	
		local EliteName31 = Util_CreateLocString("Veteran Combat Pioneers")		
        HintMouseover_Add(EliteName31, HillPioneerElite, 5, true)
        SGroup_IncreaseVeterancyRank(HillPioneerElite, 2, false)	
		local EliteName32 = Util_CreateLocString("9th Special Operations")		
        HintMouseover_Add(EliteName32, HillAssGrenElite, 5, true)
        SGroup_IncreaseVeterancyRank(HillAssGrenElite, 3, false)	
		local EliteName33 = Util_CreateLocString("Elite Assault Grenadiers")		
        HintMouseover_Add(EliteName33, HillGrenElite, 5, true)
        SGroup_IncreaseVeterancyRank(HillGrenElite, 2, false)	
		local EliteName34 = Util_CreateLocString("24th Special Operations")		
        HintMouseover_Add(EliteName34, HillStormtrooper, 5, true)
        SGroup_IncreaseVeterancyRank(HillStormtrooper, 3, false)
		local EliteName35 = Util_CreateLocString("43rd Special Operations")		
        HintMouseover_Add(EliteName35, HillStormtrooper, 5, true)
        SGroup_IncreaseVeterancyRank(HillStormtrooper, 5, false)
		local EliteName36 = Util_CreateLocString("11th Special Operations")		
        HintMouseover_Add(EliteName36, HillPanzer, 5, true)
        SGroup_IncreaseVeterancyRank(HillPanzer, 5, false)
		local EliteName37 = Util_CreateLocString("Reinforced Scout Car")		
        HintMouseover_Add(EliteName37, HillScoutEliteBottom, 5, true)
        SGroup_IncreaseVeterancyRank(HillScoutEliteBottom, 2, false)
		local EliteName38 = Util_CreateLocString("Reinforced Scout Car")		
        HintMouseover_Add(EliteName38, HillScoutEliteMid, 5, true)
        SGroup_IncreaseVeterancyRank(HillScoutEliteMid, 2, false)
		local EliteName39 = Util_CreateLocString("Reinforced Mobile Flak Halftrack")		
        HintMouseover_Add(EliteName39, HillHalftrackElite, 5, true)
        SGroup_IncreaseVeterancyRank(HillHalftrackElite, 2, false)
		local EliteName40 = Util_CreateLocString("Reinforced Ostwind")		
        HintMouseover_Add(EliteName40, HillOstwind, 5, true)
        SGroup_IncreaseVeterancyRank(HillOstwind, 2, false)
		local EliteName41 = Util_CreateLocString("45th Special Operations")		
        HintMouseover_Add(EliteName41, HillOberEliteTop, 5, true)
        SGroup_IncreaseVeterancyRank(HillOberEliteTop, 5, false)
		local EliteName42 = Util_CreateLocString("37th Special Operations")		
        HintMouseover_Add(EliteName42, HillOberEliteMid, 5, true)
        SGroup_IncreaseVeterancyRank(HillOberEliteMid, 5, false)
		local EliteName43 = Util_CreateLocString("Ulrich Goldmund")		
        HintMouseover_Add(EliteName43, Ulrich, 5, true)
        SGroup_IncreaseVeterancyRank(Ulrich, 3, false)
		local EliteName44 = Util_CreateLocString("19th Special Operations")		
        HintMouseover_Add(EliteName44, HillUlrichGren, 5, true)
        SGroup_IncreaseVeterancyRank(HillUlrichGren, 3, false)
		local EliteName45 = Util_CreateLocString("2nd Special Operations")		
        HintMouseover_Add(EliteName45, HillUlrichAssGren, 5, true)
        SGroup_IncreaseVeterancyRank(HillUlrichAssGren, 3, false)
		local EliteName46 = Util_CreateLocString("31st Special Operations")		
        HintMouseover_Add(EliteName46, HillAssPioneer, 5, true)
        SGroup_IncreaseVeterancyRank(HillAssPioneer, 5, false)
		local EliteName47 = Util_CreateLocString("Lieutenant Fitzgerald")		
        HintMouseover_Add(EliteName47, Fitzgerald, 5, true)
        SGroup_IncreaseVeterancyRank(Fitzgerald, 5, false)
		local EliteName48 = Util_CreateLocString("Colonel Winter")		
        HintMouseover_Add(EliteName48, Winter, 5, true)
        SGroup_IncreaseVeterancyRank(Winter, 5, false)
		local EliteName49 = Util_CreateLocString("Werner Hepp")		
        HintMouseover_Add(EliteName49, TigerElite, 5, true)
        SGroup_IncreaseVeterancyRank(TigerElite, 3, false)
		local EliteName50 = Util_CreateLocString("Tomislav Novak")		
        HintMouseover_Add(EliteName50, Tomislav, 5, true)
		local EliteName51 = Util_CreateLocString("Specialized Hetzer Scorcher")		
        HintMouseover_Add(EliteName51, HillHetzer, 5, true)
        SGroup_IncreaseVeterancyRank(HillHetzer, 1, false)
		local EliteName52 = Util_CreateLocString("Reinforced Support Puma")		
        HintMouseover_Add(EliteName52, HillPuma, 5, true)
        SGroup_IncreaseVeterancyRank(HillHetzer, 2, false)
		local EliteName53 = Util_CreateLocString("Reinforced Veteran Panzer IV")		
        HintMouseover_Add(EliteName53, HillTankPanzer, 5, true)
        SGroup_IncreaseVeterancyRank(HillTankPanzer, 2, false)
		local EliteName54 = Util_CreateLocString("18th Special Operations")		
        HintMouseover_Add(EliteName54, HillFallsEliteMid, 5, true)
        SGroup_IncreaseVeterancyRank(HillFallsEliteMid, 5, false)
		local EliteName55 = Util_CreateLocString("41st Special Operations")		
        HintMouseover_Add(EliteName55, HillFallsEliteBottom, 5, true)
        SGroup_IncreaseVeterancyRank(HillFallsEliteBottom, 5, false)
		
end


------------------------------Officers-------------------------------

function Officers()

        Rule_AddDelayedInterval(RuinsOfficer, 1, 45)
        Rule_AddDelayedInterval(GoldOfficer, 1, 45)
		Rule_AddDelayedInterval(RoadOfficer, 1, 30)
		Rule_AddDelayedInterval(ParkOfficer, 1, 50)

end

function RuinsOfficer()

        local Control1 = SGroup_IsUnderAttackByPlayer(GapOfficer, player1, 9000)
        local Control2 = SGroup_IsUnderAttackByPlayer(GapOfficer, player2, 9000)
        if Control1 == true or Control2 == true then
                local Target = Player_GetSquadConcentration(player1)
                local Direction = Marker_GetDirection(mkr_direction)
                Cmd_Ability(player5, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB, Target, Direction, true)
                Util_StartIntel(EVENTS.GapOfficer)
        end
end

function GoldOfficer()

        local Control1 = SGroup_IsUnderAttackByPlayer(IndustrialOfficer, player1, 9000)
        local Control2 = SGroup_IsUnderAttackByPlayer(IndustrialOfficer, player2, 9000)
        if Control1 == true or Control2 == true then
                local Target = Player_GetSquadConcentration(player1)
                local Direction = Marker_GetDirection(mkr_direction)
                Cmd_Ability(player5, ABILITY.GERMAN.STUKA_INCENDIARY_BOMBS, Target, Direction, true)
                Util_StartIntel(EVENTS.IndustrialOfficer)
        end
end

function RoadOfficer()

        local Control1 = SGroup_IsUnderAttackByPlayer(StreetOfficer, player1, 9000)
        local Control2 = SGroup_Count(StreetVolks)
        if Control1 == true and Control2 < 3 then
	        Util_CreateSquads(player5, StreetVolks, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_streetvolkspawn)
            Util_StartIntel(EVENTS.StreetOfficerDialogue)
        end
end

function ParkOfficer()

        local Control1 = SGroup_IsUnderAttackByPlayer(EstateOfficer, player1, 9000)
        local Control2 = SGroup_Count(EstateOber)
        if Control1 == true and Control2 < 2 then
	        Util_CreateSquads(player5, EstateOber, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, mkr_estatespawn)
            Util_StartIntel(EVENTS.EstateOfficerDialogue)
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
        local ControlEntity2 = SGroup_GetSpawnedSquadAt(Vladilen, 1)
        Squad_GiveSlotItem(ControlEntity2, SLOT_ITEM.BAZOOKA_MP)
	    local ControlEntity3 = SGroup_GetSpawnedSquadAt(TramThirdStorm, 1)
        Squad_GiveSlotItem(ControlEntity3, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_NO_PRONE_MP)
		local ControlEntity4 = SGroup_GetSpawnedSquadAt(StreetOber, 1)
        Squad_GiveSlotItem(ControlEntity4, SLOT_ITEM.PIONEER_FLAMETHROWER_MP)
		local ControlEntity5 = SGroup_GetSpawnedSquadAt(StreetGren, 1)
        Squad_GiveSlotItem(ControlEntity5, SLOT_ITEM.PIONEER_FLAMETHROWER_MP)
		local ControlEntity6 = SGroup_GetSpawnedSquadAt(HillGrenElite, 1)
        Squad_GiveSlotItem(ControlEntity6, SLOT_ITEM.GRENADIER_MG42_LMG_MP)
		local ControlEntity7 = SGroup_GetSpawnedSquadAt(HillStormtrooper, 1)
        Squad_GiveSlotItem(ControlEntity7, SLOT_ITEM.PANZERSHRECK_MP)
		
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
		
		Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.VOLKS_STG44_UPGRADE, ITEM_UNLOCKED)
		Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.VOLK_FIRE_GRENADE, ITEM_UNLOCKED)
		Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.VOLKS_FLAMETHROWER_MP, ITEM_UNLOCKED)
		Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.VOLKS_CQC_UPGRADE, ITEM_UNLOCKED)
		

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

end



---------------------------------Lose----------------------------

function Lose()

        Rule_AddDelayedInterval(KurtLose, 1, 1)
        Rule_AddDelayedInterval(JozefLose, 1, 1)
        Rule_AddDelayedInterval(FriedrichLose, 1, 1)
		Rule_AddDelayedInterval(FriedrichInvulnerable, 1, 1)
        Rule_AddDelayedInterval(OttoLose, 1, 1)
        Rule_AddDelayedInterval(HansLose, 1, 1)
		Rule_AddDelayedInterval(TomislavLose, 1, 1)
		
		Rule_AddDelayedInterval(TrainDefendersLose, 1, 1)
		
		Rule_AddDelayedInterval(FitzgeraldLose, 1, 1)
		Rule_AddDelayedInterval(WinterLose, 1, 1)
		Rule_AddDelayedInterval(DmitriyLose, 1, 1)
		Rule_AddDelayedInterval(NikolaiLose, 1, 1)
		Rule_AddDelayedInterval(AlekseiLose, 1, 1)
		Rule_AddDelayedInterval(ViktorLose, 1, 1)
		Rule_AddDelayedInterval(YuriLose, 1, 1)
		Rule_AddDelayedInterval(VladilenLose, 1, 1)
		Rule_AddDelayedInterval(StatorLose, 1, 1)

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

        local Control1 = SGroup_Count(Jozef)
		local Control2 = SGroup_Count(Friedrich)
        if Control1 == 0 and Control2 > 0 then
                World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
                World_SetPlayerLose(player4)
        end
end

function FriedrichLose()

        local Control1 = SGroup_Count(Friedrich)
		local Control2 = SGroup_Count(HillGroupTwo)
        if Control1 == 0 and Control2 > 0 then
                World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
                World_SetPlayerLose(player4)
        end
end

function FriedrichInvulnerable()

		local Control = SGroup_Count(HillGroupTwo)
        if Control == 0 then
                SGroup_SetInvulnerable(Friedrich, true)
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

function TomislavLose()

        local Control = SGroup_Count(Tomislav)
        if Control == 0 then
                World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
                World_SetPlayerLose(player4)
        end
end


function TrainDefendersLose()

        local Control1 = SGroup_Count(TrainUnits)
		local Control2 = SGroup_Count(EstateOfficer)
        if Control1 == 0 and Control2 > 0 then
                World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
                World_SetPlayerLose(player4)
        end
end

function FitzgeraldLose()

        local Control = SGroup_Count(Fitzgerald)
        if Control == 0 then
                World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
                World_SetPlayerLose(player4)
        end
end

function WinterLose()

        local Control1 = SGroup_Count(Winter)
		local Control2 = SGroup_Count(HillGroupTwo)
        if Control1 == 0 and Control2 > 0 then
                World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
                World_SetPlayerLose(player4)
        end
end

function DmitriyLose()

        local Control1 = SGroup_Count(Dmitriy)
		local Control2 = SGroup_Count(HillGroupTwo)
        if Control1 == 0 and Control2 > 0 then
                World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
                World_SetPlayerLose(player4)
        end
end

function NikolaiLose()

        local Control1 = SGroup_Count(Nikolai)
		local Control2 = SGroup_Count(HillGroupTwo)
        if Control1 == 0 and Control2 > 0 then
                World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
                World_SetPlayerLose(player4)
        end
end

function AlekseiLose()

        local Control1 = SGroup_Count(Aleksei)
		local Control2 = SGroup_Count(HillGroupTwo)
        if Control1 == 0 and Control2 > 0 then
                World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
                World_SetPlayerLose(player4)
        end
end

function ViktorLose()

        local Control1 = SGroup_Count(Viktor)
		local Control2 = SGroup_Count(HillGroupTwo)
        if Control1 == 0 and Control2 > 0 then
                World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
                World_SetPlayerLose(player4)
        end
end

function YuriLose()

        local Control1 = SGroup_Count(Yuri)
		local Control2 = SGroup_Count(HillGroupTwo)
        if Control1 == 0 and Control2 > 0 then
                World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
                World_SetPlayerLose(player4)
        end
end

function VladilenLose()

        local Control1 = SGroup_Count(Vladilen)
		local Control2 = SGroup_Count(HillGroupTwo)
        if Control1 == 0 and Control2 > 0 then
                World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
                World_SetPlayerLose(player4)
        end
end

function StatorLose()

        local Control1 = SGroup_Count(Stator)
		local Control2 = SGroup_Count(HillGroupTwo)
        if Control1 == 0 and Control2 > 0 then
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
				manpower = 5000,
				fuel = 5000,
				munition = 5000,
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

        local StartText1 = Util_CreateLocString("It has been some time since the Soviets left to find a way out of the city. I hope they did not abandon us.")
		local StartText2 = Util_CreateLocString("If I learned one thing from the last few days with them, it is that they are honest people. I believe they will come back for us.")
        local StartText3 = Util_CreateLocString("You know Kurt... It's quite funny really... When we released them from the camp all that time ago, I didn't think we would come to depend on them so much.")
		local StartText4 = Util_CreateLocString("Look at us! They go out to face the dangers while we sit back here waiting for them to bring food for us.")
		local StartText5 = Util_CreateLocString("Well... It just shows that we are all people in the end. We all have needs and wants, sometimes what we need and want could surprise ourselves!")
		local StartText6 = Util_CreateLocString("Ha! Yes, human nature is so strange sometimes.")
		local StartText7 = Util_CreateLocString("Are you both rested? Hans has just returned.")
		local StartText8 = Util_CreateLocString("Did he find Dmitriy and the others?")
		local StartText9 = Util_CreateLocString("It doesn't look like it, as he returned alone. His responses in the form of grunts are not helpful either.")
		local StartText10 = Util_CreateLocString("Everyone! We have a problem!")
		local StartText11 = Util_CreateLocString("It could be my eyes but I am fairly certain those unmarked men in Wehrmacht uniforms who attacked us are back. A huge number of them just entered the city!")
		local StartText12 = Util_CreateLocString("Did you see the Soviets anywhere?")
		local StartText13 = Util_CreateLocString("No, I just saw the Allies fighting those unmarked men. We really need to move, I estimate we have less than two hours before those men can reach here.")
		local StartText14 = Util_CreateLocString("They are less than two hundred meters away...")
		local StartText15 = Util_CreateLocString("WHAT?! How is that possible? Let me check again. That cannot be right!")
		local StartText16 = Util_CreateLocString("Jozef, we have no time! Grab anything you need. We need to get past them right now while they have not dug in. Otherwise we will not have any chance of escaping this city!")
		
        local Text1 = Util_CreateLocString("Viktor, Yuri! Come with me and push forward!... Aleksei, Nikolai, Vladilen and Stator! Take the high ground and cover us!")
        local Text2 = Util_CreateLocString("Stator, use suppressing fire! We need to force them into a crossfire!")
		
	    local Text3 = Util_CreateLocString("That was too close for comfort! Thank you for the intervention.")
	    local Text4 = Util_CreateLocString("Don't thank us yet. There are these uniformed men appearing all over the city chasing us. It won't take them long to get here.")
		local Text5 = Util_CreateLocString("They are nothing like I've seen from the Wehrmacht lately. No insignias, no base of operations and much better supported than anything the Wehrmacht can muster these days.")
	    local Text6 = Util_CreateLocString("That is because they are not Wehrmacht soldiers... They are from a secret task force formed and tasked to retrieve the gold the German government lost months ago. They are known as Task Force Eva.")
	    local Text7 = Util_CreateLocString("I would know... I was one of the original members when it was founded. Most of those men we fought were not original members. They must have picked up some stragglers who joined them along the way.")
	    local Text8 = Util_CreateLocString("My German needs work but I think I understand. Listen to me, finish up anything you need to do out there quickly and rally up inside here so we can discuss our next steps. We don't know when they will attack.")
		
	    local Text9 = Util_CreateLocString("Hey! Do you want to tell us why these Task Force Eva soldiers are here?")		
		local Text10 = Util_CreateLocString("Common rumor has it that the train carrying the government gold was ambushed by Allied forces and was lost, but that is not true...")
		local Text11 = Util_CreateLocString("What really happened is that the train was hijacked by its own guards and disappeared without trace... until Anton abandoned his group and informed Task Force Eva by contacting me.")
		local Text12 = Util_CreateLocString("Wait a minute... Are you saying Anton was originally a hijacker of this train? And that this train is here in this city?")
		local Text13 = Util_CreateLocString("Yes, to both questions.")	
		local Text14 = Util_CreateLocString("My God, and you see it fit to tell us this only now?!")			
		local Text15 = Util_CreateLocString("I didn't think it would matter as I wanted to skirt past the city. Being captured by the Allies and brought into the city was not part of the plan.")			
		local Text16 = Util_CreateLocString("So what do we do about Task Force Eva's men looking for us?")
		local Text17 = Util_CreateLocString("We have to fight them. They are ruthless, merciless and have orders not to let any knowledge of the location of the gold train escape. They will hunt us down if we do not deal with them.")
		local Text18 = Util_CreateLocString("Then let us prepare for them here. We can find an opening to escape after we've cut their momentum.")
		local Text19 = Util_CreateLocString("Agreed.")
		
		local Text20 = Util_CreateLocString("Original members of Task Force Eva incoming! They won't go down without a fight!")
		
		local Text21 = Util_CreateLocString("I think we can risk leaving now. It doesn't look like there are more of them for now.")
		local Text22 = Util_CreateLocString("Then we should head south, I heard there may be vehicles down there we can commandeer.")
		local Text23 = Util_CreateLocString("That's a great idea! I like how this man thinks!")
		local Text24 = Util_CreateLocString("Let's go. We don't have any better options right now.")
		
		local Text25 = Util_CreateLocString("You know, I always had the highest of respect for those who persevere in the face of absolute oblivion.")
		local Text26 = Util_CreateLocString("Brave words, for a lone man standing in the snow, but I see you keep interesting company. What are you doing here Tomislav?")
		local TomiText1 = Util_CreateLocString("I came to find you... to give you a warning...")
		local TomiText2 = Util_CreateLocString("There is a massive task force of men approaching the city. They're looking for you, all of you, and when they get here they will kill every last one of you.")
		local TomiText3 = Util_CreateLocString("But there is a way out... the east passage is clear due to a river further south. We can escape through there!")
		local TomiText4 = Util_CreateLocString("And no, I am not a spy. Colonel Winter and I have been acquainted for a grand total of twenty minutes.")
		local TomiText5 = Util_CreateLocString("Your friend is right you know. He came all this way to find you it seems.")
		local Text27 = Util_CreateLocString("I can only imagine your capabilities by merely surviving this long... I will not make the mistake of underestimating you, like Adams did.")
		local Text28 = Util_CreateLocString("Having said that, I guarantee you lads this is one tussle you are not going to win...")
		local Text29 = Util_CreateLocString("Let me pop'em major Winter. These bastards killed Adams, Simmons and countless other of our boys!")
		local Text30 = Util_CreateLocString("Rather than give you boys the illusion of choice, I would like to... negotiate, for everyone's interest.")
		local Text31 = Util_CreateLocString("This is very unusual. But we're listening... for now.")
		local Text32 = Util_CreateLocString("Excellent ol' chum, excellent! As you can probably guess by now, this behind me is a train station... and I'm sure you are very familiar with the rather golden contents of these trains.")
		local Text33 = Util_CreateLocString("We knew the train was stolen by its crew, but we didn't expect their resistance to be so stubborn. Nor did our intel mention you Soviets at all!")
		local Text34 = Util_CreateLocString("Now, I couldn't help but notice those, shall we say, bad men with no visible insignias have an aggressive interest in your group.")
		local Text35 = Util_CreateLocString("And this had me thinking. What if we can put our differences aside and work together to push our way out of this wretched city?")
		local Text36 = Util_CreateLocString("Wait a fucking minute here Winter! What about the mission?! We can't just pull out! We haven't secured the gold!")
		local Text37 = Util_CreateLocString("That's major Winter to you Fitzgerald. Do I have to remind you that I am the new commanding officer here? You will follow my orders dammit!")
		local Text38 = Util_CreateLocString("So you propose we join forces to leave the city?")
		local Text39 = Util_CreateLocString("Yes, those unmarked aggressors have some proper gear and support! But before we can begin to leave we will need to deal with the unmarked attackers' base of operations. Quelling the rebellious train crew would be a bonus too.")
		local Text40 = Util_CreateLocString("You mean to say the men who hijacked this train are still alive and are attacking you?")
		local Text41 = Util_CreateLocString("Quite! We are being squeezed from the west by the leftovers of the crew and to the east by the unmarked gunmen. So what shall you say to my offer?")
		local Text42 = Util_CreateLocString("This is likely the best chance we have of making it out of the city alive. We should take it!")
		local Text43 = Util_CreateLocString("Nothing about this feels right, but we're out of options. I guess we're fighting with the American and Commonwealth forces for now...")
		local Text44 = Util_CreateLocString("The unmarked assailants are sending more troops from the east. No doubt they have a local command post there.")
		local Text45 = Util_CreateLocString("Fight your way to the east and kill whoever is in charge there! That should give us some time to packour things and escape the city.")
		
		
		local Text46 = Util_CreateLocString("Walter! Fritz! What are you doing? Get out of here!")
		local Text47 = Util_CreateLocString("No Kurt. We made our choice to take this gold to secure our families' place in the future, and you made a choice to help the enemy destroy our plans...")
		local Text48 = Util_CreateLocString("Unfortunate... perhaps this is divine providence at its finest. The irony of it all...")
		local Text49 = Util_CreateLocString("We save you from certain doom. Now you would join them to doom us.")
		local Text50 = Util_CreateLocString("You filthy traitor... May you rot in hell for this.")
		
		local AirText1 = Util_CreateLocString("That's a bloody good job boys! The train tracks are clear enough for us to divert men elsewhere.")
		local AirText2 = Util_CreateLocString("We'll be able to help your push east with additional men now!")
		local AirText3 = Util_CreateLocString("I hear reports of ammunition drops incoming. I'm going to try and get the planes to drop it just shy of the frontline.")
		local AirText4 = Util_CreateLocString("Friendly planes making another pass for ammunitions drop. Do make use of it.")
		
		local Text51 = Util_CreateLocString("Good show Jerries!")
		local Text52 = Util_CreateLocString("Who is Jerry?")
		local Text53 = Util_CreateLocString("Ha! That's you lot! Listen, my men are currently packing their bags to leave the city, but we will need to keep a look out for them while they move out.")
		local Text54 = Util_CreateLocString("There is a radio tower just behind me which we can use to call for Allied air support. Further south is a defensive position on the hill which we can hold for an overwatch.")
		local Text55 = Util_CreateLocString("You Soviet boys and I will stay around the radio tower to call in support and intercept any of their German communications if we can.")
		local Text56 = Util_CreateLocString("Then I will stay at the tower with you. You Soviets can understand German?")
		local Text57 = Util_CreateLocString("I can translate it to them.")
		local Text58 = Util_CreateLocString("Right. Fitzgerald! I'll need you and the others to hold that hill with these lovely Wehrmacht chaps.")
		local Text59 = Util_CreateLocString("... Understood...")
		local Text60 = Util_CreateLocString("...")
		local Text61 = Util_CreateLocString("Now now, no bickering! I will let you know when the evacuation of the city is complete.")
		local Text62 = Util_CreateLocString("Fine. We will head for the hill. Be careful, Friedrich.")
		local Text63 = Util_CreateLocString("Of course... and Tomislav, thank you... for coming back.")
		
		local Text64 = Util_CreateLocString("Hey Krauts!")
		local Text65 = Util_CreateLocString("Um? Yes?")
		local Text66 = Util_CreateLocString("I wanna make something clear to you... I'm keeping my eyes on you. If you suddenly have a change of heart on who you're fighting here, I will personally put a bullet in your heads.")
		local Text67 = Util_CreateLocString("The only thing keeping you alive right now is that Brit with the red cap. I know the murderers you are and I won't forget that.")
		local Text68 = Util_CreateLocString("Huh... I see...")
		local Text69 = Util_CreateLocString("What did he say Otto?")
		local Text70 = Util_CreateLocString("He's warning us not to betray him.")
		local Text71 = Util_CreateLocString("It is good to know we are surrounded by such outstanding individuals.")
		local Text72 = Util_CreateLocString("...")
		
		local Text73 = Util_CreateLocString("Ulrich? Is that you?")
		local Text74 = Util_CreateLocString("Why are you trying to kill us? What? Why?!")
		local Text75 = Util_CreateLocString("He has made his choice, do what you have to do!")
		
		local Text76 = Util_CreateLocString("We have friendly planes in the air! Let it rain boys!")
		local Text77 = Util_CreateLocString("Dmitriy, you and your men can join Otto and the others on the hill. Winter and I can take care of this!")
		local Text78 = Util_CreateLocString("Are you sure? I don't think their attacks are getting any weaker.")
		local Text79 = Util_CreateLocString("Don't argue with me. Just go!")
		local Text80 = Util_CreateLocString("Understood friend. Everyone, move up to the defensive position on the hill!")
		local Text81 = Util_CreateLocString("Friendly airstrikes inbound. Keep your heads down.")
		
		local Text82 = Util_CreateLocString("Is that a fucking Tiger?")
		local Text83 = Util_CreateLocString("It's turning. Where is it going?")
		
		local Text84 = Util_CreateLocString("Friedrich! No!!!")
		local Text85 = Util_CreateLocString("Damn it! We can't stay here! We are getting overrun!")
		local Text86 = Util_CreateLocString("Otto, come! Let's go!")
		local Text87 = Util_CreateLocString("Friedrich!!!")
		local Text88 = Util_CreateLocString("Otto please! We need to...")
		local Text89 = Util_CreateLocString("... ACHHHH...")
		local Text90 = Util_CreateLocString("Jozef... Jozef! Oh God... Oh God... We need to go...")
		local Text91 = Util_CreateLocString("Don't look back Otto, just run!")
		
		
        local OfficerText1 = Util_CreateLocString("Command, this is Vanguard One. I am currently engaged with the target. Requesting fragmentation bombing run at Chokepoint B now!")
        local OfficerText2 = Util_CreateLocString("Vanguard Two to Command. Target is attacking forward outpost. Request immediate incendiary sweep!")
		local OfficerText3 = Util_CreateLocString("The defensive line is being threatened. Send reinforcements to my position now!")
		local OfficerText4 = Util_CreateLocString("What are you idiots doing?! The enemy is shooting at us! Get over here and defend the command post!")

EVENTS.StartCinematic = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, StartText1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, StartText2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, StartText3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, StartText4)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, StartText5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, StartText6)
	Cmd_Move(Friedrich, mkr_friedrichcinematicto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, StartText7)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, StartText8)
	Cmd_Move(Jozef, mkr_jozefcinematicto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, StartText9)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, StartText10)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, StartText11)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, StartText12)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, StartText13)
	Cmd_Move(Hans, mkr_hanscinematicto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, StartText14)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, StartText15)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, StartText16)
	CTRL.WAIT()
	Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
    Camera_ResetToDefault()
	CTRL.WAIT()

end
			
EVENTS.SovietRescue = function()

	CTRL.WAIT()
    Cmd_Move(IndustrialCar1, mkr_industrialcar1to)
    Cmd_Move(IndustrialCar2, mkr_industrialcar2to)
    Cmd_Move(IndustrialAssGren, mkr_industrialassgrento)
    Cmd_Move(IndustrialJaeger, mkr_industrialjaegerto)
    SGroup_IncreaseVeterancyRank(Stator, 3, false)
	CTRL.Event_Delay(20)
	CTRL.WAIT()
    Cmd_Move(Aleksei, mkr_alekseito1)
    Cmd_Move(Nikolai, mkr_nikolaito1)
    Cmd_Move(Vladilen, mkr_vladilento1)
    Cmd_Move(Stator, mkr_statorto1)
    Cmd_Move(Yuri, mkr_yurito1)
    Cmd_Move(Viktor, mkr_viktorto1)
    Cmd_Move(Dmitriy, mkr_dmitriyto1)
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text2)
	World_GetCurrentInteractionStage()
    World_IncreaseInteractionStage()
	CTRL.WAIT()
	

end

EVENTS.SovietTramDialogue = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text4)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text5)
	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text6)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text7)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text8)
	CTRL.WAIT()	
	
end

EVENTS.TramFightOne = function()

	CTRL.WAIT()
	Cmd_Move(Stator, mkr_statorto1)
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text9)
	FOW_RevealMarker(mkr_tramsight1, 9000)
	FOW_RevealMarker(mkr_tramsight2, 9000)
	FOW_RevealMarker(mkr_tramsight3, 9000)
	FOW_RevealMarker(mkr_tramsight4, 9000)
	FOW_RevealMarker(mkr_tramsight5, 9000)
	Cmd_Move(Aleksei, mkr_alekseito2)
    Cmd_Move(Nikolai, mkr_nikolaito2)
    Cmd_Move(Vladilen, mkr_vladilento2)
    Cmd_Move(Stator, mkr_statorto2)
    Cmd_Move(Yuri, mkr_yurito2)
    Cmd_Move(Viktor, mkr_viktorto2)
    Cmd_Move(Dmitriy, mkr_dmitriyto2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text10)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text11)
	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text12)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text13)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text14)
	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text15)
	CTRL.WAIT()		
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text16)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text17)
	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text18)
	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text19)
	CTRL.WAIT()
    Cmd_Move(TramAssGrenTarget, mkr_tramtarget)
    Cmd_Move(TramVolkTarget, mkr_tramtarget)
	Cmd_Move(TramAssGrenOne, mkr_tramassgrenoneto)
	Cmd_Move(TramVolkOne, mkr_tramvolkoneto)
		
end

EVENTS.TramFightTwo = function()

    CTRL.WAIT()	
	HintPoint_Remove(Hint1)
	Cmd_Move(Stator, mkr_statorto1)
	CTRL.WAIT()	
	CTRL.Event_Delay(45)
	CTRL.WAIT()
    Cmd_Move(TramSecondVolkOne, mkr_tramsecondvolkoneto)
    Cmd_Move(TramSecondVolkTwo, mkr_tramsecondvolktwoto)
    Cmd_Move(TramSecondVolkThree, mkr_tramsecondvolkthreeto)
	Cmd_Move(TramSecondMG, mkr_tramsecondmgto)
    CTRL.WAIT()	
	CTRL.Event_Delay(2)
	CTRL.WAIT()		
	Cmd_Move(TramSecondLeft, mkr_tramtargetleft)
	Cmd_Move(TramSecondRight, mkr_tramtargetright)
		
end

EVENTS.TramFightThree = function()

    CTRL.WAIT()	
	Cmd_Move(Stator, mkr_statorto1)
	CTRL.WAIT()	
	CTRL.Event_Delay(45)
	CTRL.WAIT()
    Cmd_Move(TramThirdPG, mkr_tramthirdpgto)
	Cmd_Move(TramThirdStorm, mkr_tramthirdstormto)
	Cmd_Move(TramThirdTarget, mkr_tramtarget)
	Cmd_Move(TramThirdPFLeft, mkr_tramthirdpfleftto)
    Cmd_Move(TramThirdPFRight, mkr_tramthirdpfrightto)
    CTRL.WAIT()	
		
end

EVENTS.TramFightFour = function()

    CTRL.WAIT()	
	Cmd_Move(Stator, mkr_statorto1)
	CTRL.WAIT()	
	CTRL.Event_Delay(45)
	CTRL.WAIT()
	Cmd_Move(Stator, mkr_statorto1)
	CTRL.WAIT()
    Cmd_Move(TramFourthAssGren, mkr_tramfourthassgrento)
    Cmd_Move(TramFourthMG, mkr_tramfourthmgto)
    Cmd_Move(TramFourthGrens, mkr_tramfourthgrensto)
    Cmd_Move(TramFourthOber, mkr_tramfourthoberto)
	Cmd_Move(TramFourthFalls, mkr_tramfourthfallsto)
	CTRL.WAIT()
		
end

EVENTS.TramEliteArrive = function()

	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text20)
	CTRL.WAIT()
		
end

EVENTS.GoldAssist = function()

	CTRL.WAIT()	
	SGroup_WarpToMarker(GoldAssistOne, mkr_goldassistonewarp)
	SGroup_WarpToMarker(GoldAssistTwo, mkr_goldassisttwowarp)
	SGroup_WarpToMarker(GoldAssistThree, mkr_goldassistthreewarp)
	SGroup_WarpToMarker(GoldAssistFour, mkr_goldassistfourwarp)
	CTRL.WAIT()	
	Cmd_Move(GoldAssistOne, mkr_goldassistoneto)
	Cmd_Move(GoldAssistTwo, mkr_goldassisttwoto)
	Cmd_Move(GoldAssistThree, mkr_goldassistthreeto)
	Cmd_Move(GoldAssistFour, mkr_goldassistfourto)
	CTRL.WAIT()
		
end

EVENTS.TramFinish = function()

	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text21)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text22)
	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text23)
	Blip3 = UI_CreateMinimapBlip(Point3, 9000, BT_ObjectivePrimary)
	UI_DeleteMinimapBlip(Blip2)
	World_GetCurrentInteractionStage()
    World_IncreaseInteractionStage()
	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text24)
	FOW_UnRevealMarker(mkr_tramsight1)
	FOW_UnRevealMarker(mkr_tramsight2)
	FOW_UnRevealMarker(mkr_tramsight3)
	FOW_UnRevealMarker(mkr_tramsight4)
	FOW_UnRevealMarker(mkr_tramsight5)
	CTRL.WAIT()	
	Cmd_Move(Dmitriy, mkr_dmitriyto3)
	Cmd_Move(Stator, mkr_statorto3)
	Cmd_Move(Vladilen, mkr_vladilento3)
	Cmd_Move(Nikolai, mkr_nikolaito3)
	Cmd_Move(Aleksei, mkr_alekseito3)
	Cmd_Move(Viktor, mkr_viktorto3)
	Cmd_Move(Yuri, mkr_yurito3)
	CTRL.WAIT()
	
end

EVENTS.TrainAmbush = function()

	CTRL.WAIT()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(20)
	CTRL.WAIT()
	SGroup_WarpToMarker(Kurt, mkr_kurtwarp)
	SGroup_WarpToMarker(Otto, mkr_ottowarp)
	SGroup_WarpToMarker(Friedrich, mkr_friedrichwarp)
	SGroup_WarpToMarker(Hans, mkr_hanswarp)
	SGroup_WarpToMarker(Jozef, mkr_jozefwarp)
	SGroup_WarpToMarker(Vladilen, mkr_vladilenwarp)
	SGroup_WarpToMarker(Stator, mkr_statorwarp)
	SGroup_WarpToMarker(Dmitriy, mkr_dmitriywarp)
	SGroup_WarpToMarker(Viktor, mkr_viktorwarp)
	SGroup_WarpToMarker(Aleksei, mkr_alekseiwarp)
	SGroup_WarpToMarker(Nikolai, mkr_nikolaiwarp)
	SGroup_WarpToMarker(Yuri, mkr_yuriwarp)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_kurttrainto)
	Cmd_Move(Otto, mkr_ottotrainto)
	Cmd_Move(Friedrich, mkr_friedrichtrainto)
	Cmd_Move(Hans, mkr_hanstrainto)
	Cmd_Move(Jozef, mkr_jozeftrainto)
	Cmd_Move(Vladilen, mkr_vladilentrainto)
	Cmd_Move(Stator, mkr_statortrainto)
	Cmd_Move(Dmitriy, mkr_dmitriytrainto)
	Cmd_Move(Viktor, mkr_viktortrainto)
	Cmd_Move(Aleksei, mkr_alekseitrainto)
	Cmd_Move(Nikolai, mkr_nikolaitrainto)
	Cmd_Move(Yuri, mkr_yuritrainto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text25)
	CTRL.WAIT()
    CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text26)
    SGroup_WarpToMarker(Fitzgerald, mkr_fitzgeraldwarp)
	SGroup_WarpToMarker(CinematicRiflemen, mkr_riflemenwarp)
	SGroup_WarpToMarker(CinematicRanger, mkr_rangerwarp)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Tomislav, TomiText1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Tomislav, TomiText2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Tomislav, TomiText3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Tomislav, TomiText4)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, TomiText5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text27)
	Cmd_Move(Fitzgerald, mkr_fitzgeraldtrainto)
	Cmd_Move(CinematicTommy, mkr_tommytrainto)
	Cmd_Move(CinematicSapper, mkr_sappertrainto)
	Cmd_Move(CinematicRiflemen, mkr_riflementrainto)
	Cmd_Move(CinematicRanger, mkr_rangertrainto)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text28)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text29)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text30)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text31)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text32)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text33)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text34)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text35)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text36)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text37)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text38)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text39)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text40)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text41)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text42)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text43)
	CTRL.WAIT()
    Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
    Camera_ResetToDefault()
	CTRL.WAIT()
	local TextHint2 = Util_CreateLocString("Soviet allies, Colonel Winter, Lieutenant Fitzgerald and at least one Allied unit occupying the train station must survive. Death of any one of these units will result in mission failure")
	Hint2 = HintPoint_Add(mkr_hint2, true, TextHint2)
	Blip4 = UI_CreateMinimapBlip(EstateBuilding, 9000, BT_ObjectivePrimary)
	UI_DeleteMinimapBlip(Blip3)
	World_GetCurrentInteractionStage()
    World_IncreaseInteractionStage()
	SGroup_SetPlayerOwner(Tomislav, player1)
	Command_SquadEntityLoad(player3, FightingPositionPathfinder, SCMD_Load, FightingPositionTop, false, true)
	Command_SquadEntityLoad(player4, Yuri, SCMD_Load, TrainBuilding, false, true)
	Command_SquadEntityLoad(player4, Aleksei, SCMD_Load, TrainBuilding, false, true)
	Command_SquadEntityLoad(player4, Dmitriy, SCMD_Load, TrainBuilding, false, true)
	Command_SquadEntityLoad(player4, Viktor, SCMD_Load, TrainBuilding, false, true)
	Cmd_Move(Stator, mkr_statorto4)
	Cmd_Move(Vladilen, mkr_vladilento4)
	Cmd_Move(Nikolai, mkr_nikolaito4)
	Cmd_Move(TrainTopPara, mkr_traintopparato)
	Cmd_Move(TrainTopTommy, mkr_traintoptommyto)
	Cmd_Move(TrainTopSapper, mkr_traintopsapperto)
	Cmd_Move(TrainTopCommando, mkr_traintopcommandoto)
	Cmd_Move(TrainTopAT, mkr_traintopatto)
	Cmd_Move(TrainBottomTommy, mkr_trainbottomtommyto)
	Cmd_Move(TrainBottomCommando, mkr_trainbottomcommandoto)
	Cmd_Move(TrainBottomRanger, mkr_trainbottomrangerto)
	Cmd_Move(TrainBottomEngineer, mkr_trainbottomengineerto)
	Cmd_Move(TrainBottomRifle, mkr_trainbottomrifleto)
	Cmd_Move(TrainBottomAT, mkr_trainbottomatto)
	Cmd_Move(CinematicRiflemen, mkr_traincinematicriflemento)
	Cmd_Move(CinematicRanger, mkr_traincinematicrangerto)
	Cmd_Move(Winter, mkr_trainwinterto)
	Cmd_Move(Fitzgerald, mkr_trainfitzgeraldto)
	Cmd_Move(ParaProtection, mkr_trainparaprotectionto)
	Command_SquadEntityLoad(player3, TrainUnits, SCMD_Load, TrainStation, false, true)
	FOW_RevealMarker(mkr_trainvision1, 9000)
	FOW_RevealMarker(mkr_trainvision2, 9000)
	FOW_RevealMarker(mkr_trainvision3, 9000)
	FOW_RevealMarker(mkr_trainvision4, 9000)
	SGroup_WarpToMarker(BritMedic, mkr_britmedicwarp)
	SGroup_WarpToMarker(AmericanMedic, mkr_americanmedicwarp)
	SGroup_WarpToMarker(EstateHalftrack, mkr_estatehalftrack)
	SGroup_WarpToMarker(EstatePuma, mkr_estatepuma)
	SGroup_WarpToMarker(EstateCar, mkr_estatecar)
	SGroup_WarpToMarker(StreetMortar, mkr_streetmortar)
	SGroup_WarpToMarker(StreetGren, mkr_streetgren)
	SGroup_WarpToMarker(StreetJager, mkr_streetjager)
	SGroup_WarpToMarker(StreetAssPioneer, mkr_streetasspioneer)
	SGroup_WarpToMarker(StreetMG, mkr_streetmg)
	SGroup_WarpToMarker(StreetOber, mkr_streetober)
	SGroup_WarpToMarker(StreetHalftrack, mkr_streethalftrack)
	SGroup_Kill(WalterSpawnControl)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text44)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text45)
	CTRL.WAIT()

end

EVENTS.TrainSpeech = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text46)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Walter, Text47)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Walter, Text48)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Walter, Text49)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Walter, Text50)
	CTRL.WAIT()

end

EVENTS.WalterEvent = function()

    CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, AirText1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, AirText2)
	CTRL.WAIT()
	
end


EVENTS.TrainWalterAttacks = function()

	CTRL.WAIT()	
	CTRL.Event_Delay(10)
	CTRL.WAIT()	
    Util_CreateSquads(player7, TrainOne, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_trainspawntop)
    Util_CreateSquads(player7, TrainOne, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_trainspawnmid)
	Util_CreateSquads(player7, TrainOne, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_trainspawnbottom)
    Util_CreateSquads(player7, TrainTwo, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_trainspawntop)
    Util_CreateSquads(player7, TrainTwo, SBP.GERMAN.URBAN_ASSAULT_PANZER_GRENADIER_SQUAD_MP, mkr_trainspawnmid)
	Util_CreateSquads(player7, TrainThree, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_trainspawnbottom)
	Util_CreateSquads(player7, TrainThree, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_trainspawnbottom)
	CTRL.WAIT()
	Cmd_Move(TrainOne, mkr_traindirecttop)
	Cmd_Move(TrainTwo, mkr_traindirectmid)
	Cmd_Move(TrainThree, mkr_traindirectbottom)
    CTRL.WAIT()
	CTRL.Event_Delay(30)
	CTRL.WAIT()
	Util_CreateSquads(player7, TrainOne, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_trainspawntop)
    Util_CreateSquads(player7, TrainOne, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_trainspawnmid)
	Util_CreateSquads(player7, TrainTwo, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_trainspawnbottom)
    Util_CreateSquads(player7, TrainTwo, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_trainspawntop)
    Util_CreateSquads(player7, TrainTwo, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_trainspawnmid)
	Util_CreateSquads(player7, TrainThree, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_trainspawnbottom)
	Util_CreateSquads(player7, TrainThree, SBP.GERMAN.URBAN_ASSAULT_PANZER_GRENADIER_SQUAD_MP, mkr_trainspawnbottom)
	Util_CreateSquads(player7, TrainFour, SBP.GERMAN.URBAN_ASSAULT_PANZER_GRENADIER_SQUAD_MP, mkr_trainspawnbottom)
	Util_CreateSquads(player7, TrainFour, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_trainspawnbottom)
	Util_CreateSquads(player7, TrainFour, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_trainspawnbottom)
	CTRL.WAIT()
	Cmd_Move(TrainOne, mkr_traindirecttop)
	Cmd_Move(TrainTwo, mkr_traindirectmid)
	Cmd_Move(TrainThree, mkr_traindirectbottom)
	Cmd_Move(TrainFour, mkr_traintargetbottom)
	CTRL.WAIT()
	CTRL.Event_Delay(30)
	CTRL.WAIT()
	HintPoint_Remove(Hint2)
	Util_CreateSquads(player7, TrainOne, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_trainspawntop)
    Util_CreateSquads(player7, TrainOne, SBP.GERMAN.URBAN_ASSAULT_PANZER_GRENADIER_SQUAD_MP, mkr_trainspawnmid)
	Util_CreateSquads(player7, TrainTwo, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_trainspawnbottom)
    Util_CreateSquads(player7, TrainTwo, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_trainspawntop)
    Util_CreateSquads(player7, TrainThree, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_MP, mkr_trainspawnmid)
	Util_CreateSquads(player7, TrainThree, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_trainspawnbottom)
	Util_CreateSquads(player7, TrainThree, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_trainspawnbottom)
	Util_CreateSquads(player7, TrainFour, SBP.GERMAN.URBAN_ASSAULT_PANZER_GRENADIER_SQUAD_MP, mkr_trainspawnbottom)
	Util_CreateSquads(player7, TrainFour, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_trainspawnbottom)
	Util_CreateSquads(player7, TrainFour, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_trainspawnbottom)
	Util_CreateSquads(player7, TrainFour, SBP.GERMAN.STORMTROOPER_SQUAD_MP, mkr_trainspawnbottom)
	CTRL.WAIT()
	Cmd_Move(TrainOne, mkr_traindirecttop)
	Cmd_Move(TrainTwo, mkr_traindirectmid)
	Cmd_Move(TrainThree, mkr_traindirectbottom)
	Cmd_AttackMove(TrainThree, mkr_traintargetbottom)
	CTRL.WAIT()	
	
end


EVENTS.EstateAttacks = function()

	CTRL.WAIT()	
	CTRL.Event_Delay(10)
	CTRL.WAIT()	
    Util_CreateSquads(player5, EstateOne, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, mkr_estatespawntop)
    Util_CreateSquads(player5, EstateOne, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_estatespawntop)
	Util_CreateSquads(player5, EstateOne, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_estatespawntop)
    Util_CreateSquads(player5, EstateTwo, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, mkr_estatespawnmid)
    Util_CreateSquads(player5, EstateTwo, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, mkr_estatespawnmid)
	Util_CreateSquads(player5, EstateThree, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_estatespawnbottom)
	Util_CreateSquads(player5, EstateThree, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, mkr_estatespawnbottom)
	CTRL.WAIT()
	Cmd_Move(EstateOne, mkr_estatedirecttop)
	Cmd_Move(EstateTwo, mkr_estatedirectmid)
	Cmd_Move(EstateThree, mkr_estatedirectbottom)
    CTRL.WAIT()
	CTRL.Event_Delay(30)
	CTRL.WAIT()
	Util_CreateSquads(player5, EstateOne, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_estatespawntop)
    Util_CreateSquads(player5, EstateOne, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, mkr_estatespawntop)
	Util_CreateSquads(player5, EstateOne, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_estatespawntop)
    Util_CreateSquads(player5, EstateTwo, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, mkr_estatespawnmid)
    Util_CreateSquads(player5, EstateTwo, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_estatespawnmid)
	Util_CreateSquads(player5, EstateThree, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_estatespawnbottom)
	Util_CreateSquads(player5, EstateThree, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_estatespawnbottom)
	CTRL.WAIT()
	Cmd_Move(EstateOne, mkr_estatedirecttop)
	Cmd_Move(EstateTwo, mkr_estatedirectmid)
	Cmd_Move(EstateThree, mkr_estatedirectbottom)
	CTRL.WAIT()
	CTRL.Event_Delay(30)
	CTRL.WAIT()
	Util_CreateSquads(player5, TrainOne, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_estatespawntop)
    Util_CreateSquads(player5, TrainOne, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_estatespawntop)
	Util_CreateSquads(player5, TrainTwo, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_estatespawnmid)
    Util_CreateSquads(player5, TrainTwo, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_estatespawnmid)
    Util_CreateSquads(player5, TrainTwo, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_estatespawnmid)
	Util_CreateSquads(player5, TrainThree, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_estatespawnbottom)
	Util_CreateSquads(player5, TrainThree, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_estatespawnbottom)
	CTRL.WAIT()
	Cmd_Move(TrainOne, mkr_estatedirecttop)
	Cmd_Move(TrainTwo, mkr_estatedirectmid)
	Cmd_Move(TrainThree, mkr_estatedirectbottom)
	CTRL.WAIT()	
    CTRL.WAIT()
	CTRL.Event_Delay(30)
	CTRL.WAIT()
	Util_CreateSquads(player5, TrainOne, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, mkr_estatespawntop)
    Util_CreateSquads(player5, TrainOne, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_estatespawntop)
	Util_CreateSquads(player5, TrainTwo, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_estatespawnmid)
    Util_CreateSquads(player5, TrainTwo, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_estatespawnmid)
    Util_CreateSquads(player5, TrainThree, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, mkr_estatespawnbottom)
	Util_CreateSquads(player5, TrainThree, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, mkr_estatespawnbottom)
	Util_CreateSquads(player5, TrainThree, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, mkr_estatespawnbottom)
	CTRL.WAIT()
	Cmd_Move(TrainOne, mkr_estatedirecttop)
	Cmd_Move(TrainTwo, mkr_estatedirectmid)
	Cmd_Move(TrainThree, mkr_estatedirectbottom)
	
end

EVENTS.BridgeTalk = function()

	CTRL.WAIT()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
    Camera_Follow(Kurt)
    Camera_SetZoomDist(20)
	CTRL.WAIT()
	FOW_UnRevealMarker(mkr_trainvision1)
	FOW_UnRevealMarker(mkr_trainvision2)
	FOW_UnRevealMarker(mkr_trainvision3)
	FOW_UnRevealMarker(mkr_trainvision4)
	SGroup_WarpToMarker(Kurt, mkr_kurtspawn)
	SGroup_WarpToMarker(Otto, mkr_ottospawn)
	SGroup_WarpToMarker(Friedrich, mkr_friedrichspawn)
	SGroup_WarpToMarker(Hans, mkr_hansspawn)
	SGroup_WarpToMarker(Jozef, mkr_jozefspawn)
	SGroup_WarpToMarker(Tomislav, mkr_tomislavspawn)
	SGroup_WarpToMarker(Vladilen, mkr_vladilenspawn)
	SGroup_WarpToMarker(Stator, mkr_statorspawn)
	SGroup_WarpToMarker(Dmitriy, mkr_dmitriyspawn)
	SGroup_WarpToMarker(Viktor, mkr_viktorspawn)
	SGroup_WarpToMarker(Aleksei, mkr_alekseispawn)
	SGroup_WarpToMarker(Nikolai, mkr_nikolaispawn)
	SGroup_WarpToMarker(Yuri, mkr_yurispawn)
	SGroup_WarpToMarker(Winter, mkr_winterspawn)
	SGroup_WarpToMarker(Fitzgerald, mkr_fitzgeraldspawn)
	SGroup_SetInvulnerable(Kurt, true)	
	SGroup_SetInvulnerable(Otto, true)	
	SGroup_SetInvulnerable(Jozef, true)
	SGroup_SetInvulnerable(Hans, true)
	SGroup_SetInvulnerable(Friedrich, true)
	SGroup_SetInvulnerable(Tomislav, true)
	SGroup_SetInvulnerable(Winter, true)
	SGroup_SetInvulnerable(Fitzgerald, true)
	SGroup_SetInvulnerable(Dmitriy, true)
	CTRL.WAIT()
	Cmd_Move(Kurt, mkr_kurtmove)
	Cmd_Move(Otto, mkr_ottomove)
	Cmd_Move(Friedrich, mkr_friedrichmove)
	Cmd_Move(Hans, mkr_hansmove)
	Cmd_Move(Jozef, mkr_jozefmove)
	Cmd_Move(Tomislav, mkr_tomislavmove)
	Cmd_Move(Dmitriy, mkr_dmitriymove)
	Cmd_Move(Winter, mkr_wintermove)
	Cmd_Move(Fitzgerald, mkr_fitzgeraldmove)
	SGroup_DestroyAllSquads(TrainAll)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text51)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text52)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text53)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text54)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text55)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text56)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text57)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text58)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text59)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text60)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text61)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text62)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text63)
	CTRL.WAIT()
    Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
    Camera_ResetToDefault()
	CTRL.WAIT()
	SGroup_SetPlayerOwner(Friedrich, player3)
	SGroup_SetInvulnerable(Kurt, false)	
	SGroup_SetInvulnerable(Otto, false)	
	SGroup_SetInvulnerable(Jozef, false)
	SGroup_SetInvulnerable(Hans, false)
	SGroup_SetInvulnerable(Friedrich, false)
	SGroup_SetInvulnerable(Tomislav, false)
	SGroup_SetInvulnerable(Winter, false)
	SGroup_SetInvulnerable(Fitzgerald, false)
	SGroup_SetInvulnerable(Dmitriy, false)
	Command_SquadEntityLoad(player3, Winter, SCMD_Load, HillTower, false, true)
	Command_SquadEntityLoad(player4, Friedrich, SCMD_Load, HillTower, false, true)
	Cmd_Move(Dmitriy, mkr_dmitriyhillto)
    Cmd_Move(Fitzgerald, mkr_fitzgeraldhillto)	
	SGroup_Kill(HillControl)
	CTRL.WAIT()

end

EVENTS.HillWaveOne = function()

	CTRL.WAIT()
	FOW_RevealMarker(mkr_hillvision1, 9000)
	FOW_RevealMarker(mkr_hillvision2, 9000)
	FOW_RevealMarker(mkr_hillvision3, 9000)
	Cmd_Move(HillMortar, mkr_hilltargetpoint)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text64)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text65)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text66)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Text67)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text68)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text69)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text70)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text71)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Hans, Text72)
	CTRL.WAIT()
	CTRL.Event_Delay(30)
	CTRL.WAIT()
	SGroup_WarpToMarker(HillCarMid, mkr_hillroadmid)
	SGroup_WarpToMarker(HillCarBottom, mkr_hillroadbottom)
    Util_CreateSquads(player5, HillOne, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, mkr_hillspawnbottom)
	Util_CreateSquads(player5, HillOne, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, mkr_hillspawnbottom)
	Util_CreateSquads(player5, HillOne, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, mkr_hillspawnbottom)
	Util_CreateSquads(player5, HillTwo, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_hillspawnmid)
	Util_CreateSquads(player5, HillTwo, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_hillspawnmid)
	Util_CreateSquads(player5, HillTwo, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_hillspawnmid)
	Util_CreateSquads(player5, HillThree, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_hillspawnmid)
	Util_CreateSquads(player5, HillThree, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_hillspawnmid)
	Util_CreateSquads(player5, HillThree, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_hillspawnmid)
	CTRL.WAIT()
	CTRL.Event_Delay(10)
	CTRL.WAIT()
	Cmd_Move(HillCarMid, mkr_hillcarmidto)
	Cmd_Move(HillCarBottom, mkr_hillcarbottomto)
	local DirectionOne = Marker_GetDirection(mkr_smoke1)
    Cmd_Ability(player5, ABILITY.GERMAN.STUKA_SMOKE_BOMB, mkr_smoke1, DirectionOne, true)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	local DirectionTwo = Marker_GetDirection(mkr_smoke2)
    Cmd_Ability(player5, ABILITY.GERMAN.STUKA_SMOKE_BOMB, mkr_smoke2, DirectionTwo, true)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	local DirectionThree = Marker_GetDirection(mkr_smoke3)
    Cmd_Ability(player5, ABILITY.GERMAN.STUKA_SMOKE_BOMB, mkr_smoke3, DirectionThree, true)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	local DirectionFour = Marker_GetDirection(mkr_smoke4)
    Cmd_Ability(player5, ABILITY.GERMAN.STUKA_SMOKE_BOMB, mkr_smoke4, DirectionFour, true)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	local DirectionFive = Marker_GetDirection(mkr_smoke5)
    Cmd_Ability(player5, ABILITY.GERMAN.STUKA_SMOKE_BOMB, mkr_smoke5, DirectionFive, true)
	CTRL.WAIT()
	CTRL.Event_Delay(30)
	CTRL.WAIT()
	SGroup_WarpToMarker(HillGrenElite, mkr_hillspawnbottom)
	SGroup_WarpToMarker(HillPanzer, mkr_hillspawnbottom)
	SGroup_WarpToMarker(HillPioneerElite, mkr_hillspawnbottom)
	SGroup_WarpToMarker(HillAssPioneer, mkr_hillspawnmid)
	SGroup_WarpToMarker(HillAssGrenElite, mkr_hillspawnmid)
	SGroup_WarpToMarker(HillStormtrooper, mkr_hillspawntop)
	CTRL.WAIT()
	Cmd_Move(HillGrenElite, mkr_hilltarget1)
	Cmd_Move(HillPanzer, mkr_hilltarget2)
	Cmd_Move(HillPioneerElite, mkr_hilltarget3)
	Cmd_Move(HillAssPioneer, mkr_hilltarget6)
	Cmd_Move(HillAssGrenElite, mkr_hilltarget4)
	Cmd_Move(HillStormtrooper, mkr_hilltarget5)
	CTRL.WAIT()
	
end

EVENTS.HillWaveTwo = function()

	CTRL.WAIT()
	CTRL.Event_Delay(45)
	CTRL.WAIT()
    Util_CreateSquads(player5, HillOne, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, mkr_hillspawnbottom)
	Util_CreateSquads(player5, HillOne, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, mkr_hillspawnbottom)
	Util_CreateSquads(player5, HillOne, SBP.GERMAN.STORMTROOPER_SQUAD_MP, mkr_hillspawnbottom)
	Util_CreateSquads(player5, HillTwo, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, mkr_hillspawnmid)
	Util_CreateSquads(player5, HillTwo, SBP.GERMAN.STORMTROOPER_SQUAD_MP, mkr_hillspawnmid)
	Util_CreateSquads(player5, HillTwo, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_hillspawnmid)
	Util_CreateSquads(player5, HillThree, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, mkr_hillspawntop)
	Util_CreateSquads(player5, HillThree, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, mkr_hillspawntop)
	CTRL.WAIT()
	CTRL.Event_Delay(30)
	CTRL.WAIT()
	SGroup_WarpToMarker(HillScoutEliteBottom, mkr_hillroadbottom)
	SGroup_WarpToMarker(HillScoutEliteMid, mkr_hillroadmid)
	SGroup_WarpToMarker(HillHalftrackElite, mkr_hillspawnside)
	SGroup_WarpToMarker(HillOstwind, mkr_ostwindspawn)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text76)
	CTRL.WAIT()
	local Direction = Marker_GetDirection(mkr_rocketdirection)
    Cmd_Ability(player3, ABILITY.AEF.P47_ROCKET_ATTACK, mkr_rockettarget, Direction, true)
	Cmd_Move(HillScoutEliteBottom, mkr_hillscoutbottomeliteto)
	Cmd_Move(HillScoutEliteMid, mkr_hillscoutmideliteto)
	Cmd_Move(HillHalftrackElite, mkr_hillhalftrackeliteto)
	Cmd_Move(HillOstwind, mkr_hillostwindto)
	CTRL.WAIT()
	
end

EVENTS.HillWaveThree = function()

	CTRL.WAIT()
	CTRL.Event_Delay(45)
	CTRL.WAIT()
    Util_CreateSquads(player5, HillOne, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, mkr_hillspawnbottom)
	Util_CreateSquads(player5, HillOne, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, mkr_hillspawnbottom)
	Util_CreateSquads(player5, HillOne, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_hillspawnbottom)
	Util_CreateSquads(player5, HillOne, SBP.GERMAN.STORMTROOPER_SQUAD_MP, mkr_hillspawnbottom)
	Util_CreateSquads(player5, HillTwo, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, mkr_hillspawnmid)
	Util_CreateSquads(player5, HillTwo, SBP.GERMAN.STORMTROOPER_SQUAD_MP, mkr_hillspawnmid)
	Util_CreateSquads(player5, HillTwo, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_hillspawnmid)
	Util_CreateSquads(player5, HillThree, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, mkr_hillspawntop)
	Util_CreateSquads(player5, HillThree, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, mkr_hillspawntop)
	Util_CreateSquads(player5, HillThree, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_hillspawntop)
	CTRL.WAIT()
	CTRL.Event_Delay(45)
	CTRL.WAIT()
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text77)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text78)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text79)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, Text80)
	CTRL.WAIT()
	Cmd_Move(Dmitriy, mkr_dmitriyhillmove)
	Cmd_Move(Stator, mkr_statorhillmove)
	Cmd_Move(Vladilen, mkr_vladilenhillmove)
	Cmd_Move(Nikolai, mkr_nikolaihillmove)
	Cmd_Move(Viktor, mkr_viktorhillmove)
	Cmd_Move(Aleksei, mkr_alekseihillmove)
	Cmd_Move(Yuri, mkr_yurihillmove)
	SGroup_WarpToMarker(HillTankPanzer, mkr_hillroadmid)
	SGroup_WarpToMarker(HillPuma, mkr_hillroadbottom)
	SGroup_WarpToMarker(HillHetzer, mkr_hillroadbottom)
	SGroup_WarpToMarker(HillUlrichGren, mkr_hillspawntop)
	SGroup_WarpToMarker(HillUlrichAssGren, mkr_hillspawntop)
	SGroup_WarpToMarker(Ulrich, mkr_hillspawntop)
	SGroup_WarpToMarker(HillOberEliteTop, mkr_hillspawntop)
	SGroup_WarpToMarker(HillOberEliteMid, mkr_hillspawnmid)
	SGroup_WarpToMarker(HillFallsEliteMid, mkr_hillspawnmid)
	SGroup_WarpToMarker(HillFallsEliteBottom, mkr_hillspawnbottom)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Winter, Text81)
	CTRL.WAIT()
	Cmd_Move(HillTankPanzer, mkr_hilltarget5)
	Cmd_Move(HillPuma, mkr_hillpumato)
	Cmd_Move(HillHetzer, mkr_hillhetzerto)
	Cmd_Move(HillUlrichAssGren, mkr_hilltarget6)
	Cmd_Move(HillUlrichGren, mkr_ulrichto)
	Cmd_Move(Ulrich, mkr_ulrichto)
	Cmd_Move(HillOberEliteTop, mkr_hilltarget7)
	Cmd_Move(HillOberEliteMid, mkr_hilltarget4)
	Cmd_Move(HillFallsEliteMid, mkr_hilltarget3)
	Cmd_Move(HillFallsEliteBottom, mkr_hilltarget1)
	local DirectionOne = Marker_GetDirection(mkr_rocketdirection)
	local DirectionTwo = Marker_GetDirection(mkr_rocketturn1)
	local DirectionThree = Marker_GetDirection(mkr_rocketturn2)
    Cmd_Ability(player3, ABILITY.AEF.P47_ROCKET_ATTACK, mkr_hilltarget5, DirectionOne, true)
	Cmd_Ability(player3, ABILITY.AEF.P47_ROCKET_ATTACK, mkr_hilltarget4, DirectionTwo, true)
	Cmd_Ability(player3, ABILITY.AEF.P47_ROCKET_ATTACK, mkr_hilltarget2, DirectionThree, true)
	CTRL.WAIT()
	
end

EVENTS.TigerArrive = function()

	CTRL.WAIT()
	CTRL.Event_Delay(5)
	CTRL.WAIT()
	SGroup_SetInvulnerable(Kurt, true)
	SGroup_SetInvulnerable(Otto, true)
	SGroup_SetInvulnerable(Tomislav, true)
	SGroup_SetInvulnerable(Hans, true)
	SGroup_SetInvulnerable(Jozef, true)
	SGroup_SetInvulnerable(Friedrich, true)
	SGroup_SetInvulnerable(Winter, true)
	SGroup_SetInvulnerable(Fitzgerald, true)
	SGroup_SetInvulnerable(Vladilen, true)
	SGroup_SetInvulnerable(Stator, true)
	SGroup_SetInvulnerable(Dmitriy, true)
	SGroup_SetInvulnerable(Nikolai, true)
	SGroup_SetInvulnerable(Aleksei, true)
	SGroup_SetInvulnerable(Viktor, true)
	SGroup_SetInvulnerable(Yuri, true)
	SGroup_SetInvulnerable(EndCinematicBottomGren, true)
	SGroup_SetInvulnerable(EndCinematicTopGren, true)
	SGroup_WarpToMarker(TigerElite, mkr_hillroadmid)
	CTRL.WAIT()
	Cmd_Move(TigerElite, mkr_tigerto1)
	Cmd_Move(Fitzgerald, mkr_fitzgeraldfinalespawn)
	CTRL.WAIT()
	CTRL.Event_Delay(5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text82)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text83)
	CTRL.WAIT()

end

EVENTS.TowerFalls = function()

	CTRL.WAIT()
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
	Camera_ResetToDefault()
    Camera_Follow(TigerElite)
	Cmd_Attack(TigerElite, HillTower)
	SGroup_WarpToMarker(Fitzgerald, mkr_fitzgeraldfinalespawn)
	SGroup_WarpToMarker(Kurt, mkr_kurtfinalespawn)
	SGroup_WarpToMarker(Otto, mkr_ottofinalespawn)
	SGroup_WarpToMarker(Hans, mkr_hansfinalespawn)
	SGroup_WarpToMarker(Tomislav, mkr_tomislavfinalespawn)
	SGroup_WarpToMarker(Jozef, mkr_jozeffinalespawn)
	local RetreatEntity = EGroup_GetSpawnedEntityAt(RetreatFinale, 1)
	local DestroyEntity = EGroup_GetSpawnedEntityAt(Retreat4, 1)
    Entity_SetPlayerOwner(RetreatEntity, player1)
    Entity_Destroy(DestroyEntity)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	Cmd_Move(Kurt, mkr_kurtfinalespawn)
	Cmd_Move(Otto, mkr_ottofinalespawn)
	Cmd_Move(Hans, mkr_hansfinalespawn)
	Cmd_Move(Tomislav, mkr_tomislavfinalespawn)
	Cmd_Move(Jozef, mkr_jozeffinalespawn)
	CTRL.WAIT()
	CTRL.Event_Delay(9)
	CTRL.WAIT()
	EGroup_Kill(HillTower)
	SGroup_Kill(Friedrich)
	SGroup_Kill(Winter)
	CTRL.WAIT()
	CTRL.Event_Delay(5)
	CTRL.WAIT()
	Camera_Follow(Kurt)
	SGroup_WarpToMarker(EndCinematicBottomGren, mkr_endcinematicassgrenspawn)
	SGroup_WarpToMarker(EndCinematicTopGren, mkr_endcinematictopgrenspawn)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text84)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text85)
	Cmd_Move(EndCinematicBottomGren, mkr_endcinematicassgrento)
	Cmd_Move(EndCinematicTopGren, mkr_endcinematictopgrento)
	Cmd_Retreat(Fitzgerald)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text86)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text87)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text88)
	CTRL.WAIT()
	SGroup_Kill(Jozef)
	CTRL.Actor_PlaySpeech(ACTOR.Jozef, Text89)
	Cmd_Retreat(Stator)
	Cmd_Retreat(Vladilen)
	Cmd_Retreat(Dmitriy)
	Cmd_Retreat(Nikolai)
	Cmd_Retreat(Aleksei)
	Cmd_Retreat(Viktor)
	Cmd_Retreat(Yuri)
	CTRL.WAIT()
	CTRL.Event_Delay(5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text90)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text91)
	Cmd_Retreat(Kurt)
	Cmd_Retreat(Otto)
	Cmd_Retreat(Hans)
	Cmd_Retreat(Tomislav)
	CTRL.WAIT()
	CTRL.Event_Delay(5)
	CTRL.WAIT()
	Game_EndSP(true)
    CTRL.WAIT()

end

EVENTS.GapOfficer = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, OfficerText1)
	CTRL.WAIT()

end

EVENTS.IndustrialOfficer = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, OfficerText2)
	CTRL.WAIT()

end

EVENTS.StreetOfficerDialogue = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, OfficerText3)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Cmd_AttackMove(StreetVolks, mkr_streetvolksto)
	CTRL.WAIT()

end

EVENTS.EstateOfficerDialogue = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, OfficerText4)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Cmd_SquadPatrolMarker(EstateOber, mkr_estateoberpatrol)
	CTRL.WAIT()

end

EVENTS.UlrichDialogue = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text73)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text74)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Friedrich, Text75)
	CTRL.WAIT()

end